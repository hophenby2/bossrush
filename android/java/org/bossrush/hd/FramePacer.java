package org.bossrush.hd;

import android.view.Choreographer;
import android.util.Log;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Process;
import org.cocos.lib.CocosGLSurfaceView;

/** 独立线程调度60帧：同步开启时跟随显示时钟，关闭时使用单调时钟截止时间。 */
final class FramePacer {
    private final CocosGLSurfaceView view;
    private final FrameCadence cadence = new FrameCadence();
    private final HandlerThread thread;
    private final Handler handler;
    private volatile boolean active;
    private volatile int generation;
    private boolean vsync;
    private Choreographer choreographer;
    private Choreographer.FrameCallback callback;
    private long reportStarted;
    private int callbacks, requests;

    FramePacer(CocosGLSurfaceView view) {
        this.view = view;
        thread = new HandlerThread("BossRush帧调度", Process.THREAD_PRIORITY_DISPLAY);
        thread.start();
        handler = new Handler(thread.getLooper());
    }

    void configure(boolean enabled) {
        if (vsync == enabled) return;
        boolean running = active;
        if (running) stop();
        vsync = enabled;
        if (running) start();
    }

    void start() {
        if (active) return;
        active = true;
        final int token = ++generation;
        final boolean synchronizedMode = vsync;
        handler.post(() -> {
            if (!alive(token)) return;
            cadence.reset();
            reportStarted = 0;
            callbacks = requests = 0;
            if (synchronizedMode) {
                choreographer = Choreographer.getInstance();
                callback = time -> onVsync(time, token);
                choreographer.postFrameCallback(callback);
            } else onTimer(token);
        });
    }

    void stop() {
        active = false;
        generation++;
        handler.removeCallbacksAndMessages(null);
        handler.post(() -> {
            if (choreographer != null && callback != null) choreographer.removeFrameCallback(callback);
            callback = null;
        });
    }

    private boolean alive(int token) { return active && token == generation; }

    private void onVsync(long time, int token) {
        if (!alive(token)) return;
        pulse(time, true);
        if (alive(token)) choreographer.postFrameCallback(callback);
    }

    private void onTimer(int token) {
        if (!alive(token)) return;
        pulse(System.nanoTime(), false);
        if (alive(token)) {
            long delay = Math.max(1, (cadence.delayNanos(System.nanoTime())+999_999)/1_000_000);
            handler.postDelayed(() -> onTimer(token), delay);
        }
    }

    private void pulse(long time, boolean synchronizedMode) {
        if (reportStarted == 0) reportStarted = time;
        callbacks++;
        if (cadence.shouldRender(time)) { view.requestRender(); requests++; }
        if (time-reportStarted >= 5_000_000_000L) {
            double seconds = (time-reportStarted)/1_000_000_000.0;
            Log.i("BOSSRUSH_PACING", "mode=" + (synchronizedMode ? "vsync" : "clock") +
                " callback_hz=" + callbacks/seconds + " request_fps=" + requests/seconds);
            reportStarted = time;
            callbacks = requests = 0;
        }
    }

    void close() { stop(); thread.quitSafely(); }
}
