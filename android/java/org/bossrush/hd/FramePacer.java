package org.bossrush.hd;

import android.view.Choreographer;
import android.util.Log;
import org.cocos.lib.CocosGLSurfaceView;

/** 绘制由系统垂直同步唤醒，GL线程不再自行休眠。所有方法在UI线程执行。 */
final class FramePacer implements Choreographer.FrameCallback {
    private final CocosGLSurfaceView view;
    private final FrameCadence cadence = new FrameCadence();
    private boolean active;
    private long reportStarted;
    private int callbacks, requests;

    FramePacer(CocosGLSurfaceView view) { this.view = view; }

    void start() {
        if (active) return;
        active = true;
        cadence.reset();
        reportStarted = 0;
        callbacks = requests = 0;
        Choreographer.getInstance().postFrameCallback(this);
    }

    void stop() {
        active = false;
        Choreographer.getInstance().removeFrameCallback(this);
        cadence.reset();
    }

    @Override public void doFrame(long time) {
        if (!active) return;
        if (reportStarted == 0) reportStarted = time;
        callbacks++;
        if (cadence.shouldRender(time)) { view.requestRender(); requests++; }
        if (time-reportStarted >= 5_000_000_000L) {
            double seconds = (time-reportStarted)/1_000_000_000.0;
            Log.i("BOSSRUSH_PACING", "vsync_hz=" + callbacks/seconds + " request_fps=" + requests/seconds);
            reportStarted = time;
            callbacks = requests = 0;
        }
        Choreographer.getInstance().postFrameCallback(this);
    }
}
