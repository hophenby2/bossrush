package org.bossrush.hd;

/** 只改变像素分辨率，保持画面纵横比，游戏坐标和判定范围不变。 */
public final class RenderGeometry {
    private RenderGeometry() {}

    public static int[] bufferSize(int width, int height, boolean nativeResolution) {
        if (width <= 0 || height <= 0) return new int[] {1, 1};
        float scale = nativeResolution ? 1.0f : Math.min(1.0f, 720.0f / Math.min(width, height));
        return new int[] {Math.max(1, Math.round(width * scale)), Math.max(1, Math.round(height * scale))};
    }

    public static float inputScale(int buffer, int view) {
        return view > 0 ? buffer / (float) view : 1.0f;
    }
}
