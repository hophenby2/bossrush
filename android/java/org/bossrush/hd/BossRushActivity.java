package org.bossrush.hd;

import android.app.Activity;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import org.cocos.lib.CocosActivity;

/** 游戏数据仅使用应用私有目录，切后台和失去音频焦点时暂停。 */
public final class BossRushActivity extends CocosActivity {
    private AudioManager audioManager;
    private AudioFocusRequest focusRequest;
    private boolean resumed;

    private static native void nativeFocus(boolean active);
    private static native void nativeBack();

    @Override protected void onLoadNativeLibraries() {
        System.loadLibrary("cocos2dlua");
    }

    @Override protected void onCreate(Bundle state) {
        setEnableVirtualButton(false);
        super.onCreate(state);
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
        resumed = true;
        if (audioManager != null) {
            final boolean active = audioManager.requestAudioFocus(focusRequest) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED;
            runOnGLThread(() -> nativeFocus(active));
        }
    }

    @Override protected void onPause() {
        resumed = false;
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
}
