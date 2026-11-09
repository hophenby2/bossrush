package org.bossrush.hd;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.opengl.GLSurfaceView;
import android.os.Build;
import android.os.Bundle;
import android.os.SystemClock;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import java.io.IOException;
import java.io.InputStream;
import org.cocos.lib.CocosActivity;
import org.cocos.lib.CocosGLSurfaceView;
import org.cocos.lib.CocosRenderer;

/** 游戏数据仅使用应用私有目录，切后台和失去音频焦点时暂停。 */
public final class BossRushActivity extends CocosActivity {
    private static BossRushActivity instance;
    private static volatile boolean requestedVsync;
    private SaveManagerDialog saveManager;
    private AudioManager audioManager;
    private AudioFocusRequest focusRequest;
    private boolean resumed;
    private ImageView startupView;
    private long startupStarted;
    private boolean nativeResolution;
    private int renderWidth, renderHeight;
    private FramePacer framePacer;

    private void resizeSurface(CocosGLSurfaceView view, int width, int height) {
        if (width <= 0 || height <= 0) return;
        int[] size = RenderGeometry.bufferSize(width, height, nativeResolution);
        if (size[0] == renderWidth && size[1] == renderHeight) return;
        renderWidth = size[0];
        renderHeight = size[1];
        view.getHolder().setFixedSize(renderWidth, renderHeight);
        Log.i("BOSSRUSH_DISPLAY", "view=" + width + "x" + height +
            " buffer=" + renderWidth + "x" + renderHeight);
    }

    @Override public CocosGLSurfaceView onCreateView() {
        CocosGLSurfaceView view = super.onCreateView();
        view.getHolder().addCallback(new SurfaceHolder.Callback() {
            private void prefer60Hz(SurfaceHolder holder) {
                if (Build.VERSION.SDK_INT >= 30 && holder.getSurface().isValid()) {
                    holder.getSurface().setFrameRate(60.0f, Surface.FRAME_RATE_COMPATIBILITY_FIXED_SOURCE);
                }
            }
            @Override public void surfaceCreated(SurfaceHolder holder) { prefer60Hz(holder); }
            @Override public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) { prefer60Hz(holder); }
            @Override public void surfaceDestroyed(SurfaceHolder holder) {}
        });
        view.addOnLayoutChangeListener((v, left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom) ->
            resizeSurface(view, right-left, bottom-top));
        view.setOnTouchListener((v, event) -> {
            if (renderWidth <= 0 || renderHeight <= 0) return view.onTouchEvent(event);
            // Surface可由系统缩放到全屏，触点仍是View像素，必须同步换算全部手指。
            MotionEvent scaled = MotionEvent.obtain(event);
            Matrix matrix = new Matrix();
            matrix.setScale(RenderGeometry.inputScale(renderWidth, view.getWidth()),
                RenderGeometry.inputScale(renderHeight, view.getHeight()));
            scaled.transform(matrix);
            try { return view.onTouchEvent(scaled); }
            finally { scaled.recycle(); }
        });
        return view;
    }

    public static void configureRendering(boolean nativeResolution) {
        BossRushActivity current = instance;
        if (current == null) return;
        current.runOnUiThread(() -> {
            current.nativeResolution = nativeResolution;
            CocosGLSurfaceView view = current.getGLSurfaceView();
            if (view != null) current.resizeSurface(view, view.getWidth(), view.getHeight());
        });
    }

    public static void configureVsync(boolean enabled) {
        requestedVsync = enabled;
        BossRushActivity current = instance;
        if (current != null) current.runOnUiThread(() -> {
            if (current.framePacer != null) current.framePacer.configure(enabled);
        });
    }

    /** 记住布局选择，下一次启动在创建 Surface 前就使用对应方向。 */
    public static void configurePortrait(boolean enabled) {
        BossRushActivity current = instance;
        if (current == null) return;
        current.runOnUiThread(() -> {
            current.getPreferences(MODE_PRIVATE).edit().putBoolean("portrait", enabled).apply();
            current.setRequestedOrientation(enabled ? ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT
                : ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
        });
    }

    private static native void nativeFocus(boolean active);
    private static native void nativeBack();
    private static native void nativeSaveClose();

    /** GL 初始化前先呈现项目自带加载图，首个游戏帧提交后交还给原加载界面。 */
    private void showStartup() {
        try (InputStream stream = getAssets().open("game/THlib/UI/loading.png")) {
            Bitmap image = BitmapFactory.decodeStream(stream);
            if (image == null) return;
            startupView = new ImageView(this);
            startupView.setBackgroundColor(Color.BLACK);
            startupView.setScaleType(ImageView.ScaleType.FIT_CENTER);
            startupView.setImageBitmap(image);
            addContentView(startupView, new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        } catch (IOException error) {
            Log.w("BOSSRUSH_STARTUP", "无法提前读取原加载图", error);
        }
    }

    public static void finishStartup() {
        BossRushActivity current = instance;
        if (current == null) return;
        current.runOnUiThread(() -> {
            ImageView overlay = current.startupView;
            if (overlay == null) return;
            current.startupView = null;
            // GL 命令还要经过 Cocos 提交及交换，稍后移除以免露出未绘制的 Surface。
            overlay.postDelayed(() -> {
                if (overlay.getParent() instanceof ViewGroup) {
                    ((ViewGroup) overlay.getParent()).removeView(overlay);
                }
                overlay.setImageDrawable(null);
            }, 32);
            Log.i("BOSSRUSH_STARTUP", "首个游戏帧：" +
                (SystemClock.elapsedRealtime() - current.startupStarted) + " ms");
        });
    }

    /** 对话框覆盖在游戏 Activity 上，GL 线程继续处理非阻塞同步请求。 */
    public static void openSaveManager(String url) {
        BossRushActivity current = instance;
        if (current == null) return;
        current.runOnUiThread(() -> {
            if (current.saveManager != null && current.saveManager.isShowing()) return;
            current.saveManager = new SaveManagerDialog(current, url);
            current.saveManager.setOnDismissListener(dialog -> {
                current.runOnGLThread(BossRushActivity::nativeSaveClose);
                current.immersive();
            });
            current.saveManager.show();
        });
    }

    @Override protected void onLoadNativeLibraries() {
        Log.i("BOSSRUSH_STARTUP", "开始加载原生库");
        System.loadLibrary("cocos2dlua");
        Log.i("BOSSRUSH_STARTUP", "原生库就绪：" +
            (SystemClock.elapsedRealtime() - startupStarted) + " ms");
    }

    @Override protected void onCreate(Bundle state) {
        startupStarted = SystemClock.elapsedRealtime();
        setRequestedOrientation(getPreferences(MODE_PRIVATE).getBoolean("portrait", true)
            ? ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT : ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
        setEnableVirtualButton(false);
        super.onCreate(state);
        instance = this;
        CocosRenderer.setExternalFramePacing(true);
        getGLSurfaceView().setRenderMode(GLSurfaceView.RENDERMODE_WHEN_DIRTY);
        framePacer = new FramePacer(getGLSurfaceView());
        framePacer.configure(requestedVsync);
        showStartup();
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        immersive();
        audioManager = (AudioManager) getSystemService(Activity.AUDIO_SERVICE);
        focusRequest = new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
            .setAudioAttributes(new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_GAME)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build())
            .setOnAudioFocusChangeListener(change -> {
                final boolean active = resumed && change == AudioManager.AUDIOFOCUS_GAIN;
                runOnGLThread(() -> nativeFocus(active));
            }).build();
    }

    private void immersive() {
        getWindow().getDecorView().setSystemUiVisibility(
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY | View.SYSTEM_UI_FLAG_FULLSCREEN |
            View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
            View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
    }

    @Override public void onWindowFocusChanged(boolean focused) {
        super.onWindowFocusChanged(focused);
        if (focused) immersive();
    }

    @Override protected void onResume() {
        super.onResume();
        // 基类onResume会强制切回连续绘制，必须在它之后恢复按需模式。
        getGLSurfaceView().setRenderMode(GLSurfaceView.RENDERMODE_WHEN_DIRTY);
        resumed = true;
        if (framePacer != null) framePacer.start();
        if (audioManager != null) {
            final boolean active = audioManager.requestAudioFocus(focusRequest) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED;
            runOnGLThread(() -> nativeFocus(active));
        }
    }

    @Override protected void onPause() {
        resumed = false;
        if (framePacer != null) framePacer.stop();
        runOnGLThread(() -> nativeFocus(false));
        if (audioManager != null) audioManager.abandonAudioFocusRequest(focusRequest);
        super.onPause();
    }

    @Override public void onBackPressed() {
        runOnGLThread(BossRushActivity::nativeBack);
    }

    @Override public boolean dispatchKeyEvent(KeyEvent event) {
        // GLSurfaceView 会吞掉返回键；在 Activity 层转为游戏帧可见的 ESC 脉冲。
        if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
            if (event.getAction() == KeyEvent.ACTION_UP && !event.isCanceled()) {
                runOnGLThread(BossRushActivity::nativeBack);
            }
            return true;
        }
        return super.dispatchKeyEvent(event);
    }

    @Override public void onRequestPermissionsResult(int code, String[] permissions, int[] results) {
        super.onRequestPermissionsResult(code, permissions, results);
        if (saveManager != null) saveManager.permissionResult(code, results);
    }

    @Override protected void onActivityResult(int code, int result, Intent data) {
        if (saveManager != null && saveManager.activityResult(code, result, data)) return;
        super.onActivityResult(code, result, data);
    }

    @Override protected void onDestroy() {
        if (framePacer != null) framePacer.stop();
        if (saveManager != null) saveManager.dismiss();
        if (framePacer != null) framePacer.close();
        instance = null;
        super.onDestroy();
    }
}
