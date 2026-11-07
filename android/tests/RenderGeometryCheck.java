package org.bossrush.hd;

/** 直接检查发行版使用的尺寸与触点换算，不需要Android模拟器。 */
public final class RenderGeometryCheck {
    private static void check(boolean ok, String message) {
        if (!ok) throw new AssertionError(message);
    }
    public static void main(String[] args) {
        int[][] cases={{3168,1440,1584,720},{2400,1080,1600,720},{1920,1080,1280,720},{960,540,960,540}};
        for (int[] c : cases) {
            int[] b=RenderGeometry.bufferSize(c[0],c[1],false);
            check(b[0]==c[2] && b[1]==c[3],"渲染面尺寸错误");
            check(Math.abs(c[0]*0.5f*RenderGeometry.inputScale(b[0],c[0])-b[0]*0.5f)<0.001f,"横向触点未居中");
            check(Math.abs(c[1]*0.5f*RenderGeometry.inputScale(b[1],c[1])-b[1]*0.5f)<0.001f,"纵向触点未居中");
            int[] nativeSize=RenderGeometry.bufferSize(c[0],c[1],true);
            check(nativeSize[0]==c[0] && nativeSize[1]==c[1],"原生分辨率未保留");
        }
        System.out.println("渲染尺寸、原生档位和触点中心换算检查通过");
    }
}
