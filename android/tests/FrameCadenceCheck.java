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
        System.out.println("60/90/120/144/165Hz、慢帧与恢复调度检查通过");
    }
}
