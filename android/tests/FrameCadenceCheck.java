package org.bossrush.hd;

/** 验证高刷新率不加速游戏，慢帧和恢复后不密集补发绘制。 */
public final class FrameCadenceCheck {
    public static void main(String[] args) {
        for (int rate : new int[] {60, 90, 120, 144, 165}) {
            FrameCadence cadence = new FrameCadence();
            int count = 0;
            for (int i = 0; i < rate*10; i++) {
                if (cadence.shouldRender(1_000_000_000L*i/rate)) count++;
            }
            if (count != 600) throw new AssertionError(rate + "Hz: " + count);
        }
        FrameCadence cadence = new FrameCadence();
        if (!cadence.shouldRender(0) || cadence.shouldRender(0)) throw new AssertionError("重复提交");
        if (!cadence.shouldRender(250_000_000) || cadence.shouldRender(251_000_000)) throw new AssertionError("慢帧补发");
        cadence.reset();
        if (!cadence.shouldRender(252_000_000)) throw new AssertionError("恢复不及时");
        cadence.reset();
        int jittered=0;
        for (int i=0;i<600;i++) {
            long jitter=(i%5-2)*700_000L;
            if (cadence.shouldRender(10_000_000L+1_000_000_000L*i/60+jitter)) jittered++;
        }
        if (jittered<599 || jittered>600) throw new AssertionError("60Hz抖动漏帧: "+jittered);
        cadence.reset();
        long time=0;
        int timer=0;
        while(time<10_000_000_000L) {
            if(cadence.shouldRender(time))timer++;
            time+=Math.max(1,(cadence.delayNanos(time)+999_999L)/1_000_000L)*1_000_000L;
        }
        if(timer!=600) throw new AssertionError("独立时钟漂移: "+timer);
        System.out.println("60/90/120/144/165Hz、抖动、独立时钟、慢帧与恢复调度检查通过");
    }
}
