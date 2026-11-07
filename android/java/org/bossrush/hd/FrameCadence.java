package org.bossrush.hd;

/** 跟随显示时钟选择60帧；慢帧后只提交一次，避免补发无用的绘制请求。 */
public final class FrameCadence {
    private static final long INTERVAL = 1_000_000_000L / 60;
    private static final long TOLERANCE = INTERVAL / 4;
    private long next, previous;
    private boolean initialized;

    public void reset() { initialized = false; }

    public boolean shouldRender(long time) {
        if (!initialized || time < previous) {
            initialized = true;
            next = time;
        }
        previous = time;
        if (time + TOLERANCE < next) return false;
        // 保留60Hz相位，迟到时跳过已经错过的请求，不能反复用迟到时刻重置周期。
        next += INTERVAL;
        if (next <= time) next += ((time-next)/INTERVAL+1)*INTERVAL;
        return true;
    }

    public long delayNanos(long time) { return initialized ? Math.max(0, next-time) : 0; }
}
