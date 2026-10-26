import android.os.SystemClock;
import android.view.InputDevice;
import android.view.InputEvent;
import android.view.MotionEvent;
import java.lang.reflect.Method;

/** adb shell app_process 测试入口；坐标基于 2400×1080，可通过参数缩放。 */
public final class EmulatorGestures {
    private static Object manager;
    private static Method inject;
    private static long down;
    private static float scale;
    private static final float[][] points={{1946,900},{1200,760},{1740,896}};
    private static void send(int action,int... ids) throws Exception {
        MotionEvent.PointerProperties[] properties=new MotionEvent.PointerProperties[ids.length];
        MotionEvent.PointerCoords[] coords=new MotionEvent.PointerCoords[ids.length];
        for(int i=0;i<ids.length;i++) {
            properties[i]=new MotionEvent.PointerProperties();
            properties[i].id=ids[i]; properties[i].toolType=MotionEvent.TOOL_TYPE_FINGER;
            coords[i]=new MotionEvent.PointerCoords();
            coords[i].x=points[ids[i]][0]*scale; coords[i].y=points[ids[i]][1]*scale;
            coords[i].pressure=1; coords[i].size=1;
        }
        MotionEvent event=MotionEvent.obtain(down,SystemClock.uptimeMillis(),action,ids.length,
            properties,coords,0,0,1,1,0,0,InputDevice.SOURCE_TOUCHSCREEN,0);
        try {
            if(!((Boolean)inject.invoke(manager,event,2))) throw new IllegalStateException("Touch rejected");
        } finally { event.recycle(); }
    }
    public static void main(String[] args) throws Exception {
        String mode=args.length>0?args[0]:"drag";
        scale=args.length>1?Float.parseFloat(args[1]):0.5f;
        Class<?> cls=Class.forName("android.hardware.input.InputManagerGlobal");
        manager=cls.getMethod("getInstance").invoke(null);
        inject=cls.getMethod("injectInputEvent",InputEvent.class,int.class);
        if(mode.equals("joystick")) { points[1][0]=580; points[1][1]=820; }
        down=SystemClock.uptimeMillis(); send(MotionEvent.ACTION_DOWN,0);
        SystemClock.sleep(500);
        send(MotionEvent.ACTION_POINTER_DOWN|(1<<8),0,1);
        SystemClock.sleep(1000); System.out.println("BEGIN_"+mode);
        SystemClock.sleep(600);
        send(MotionEvent.ACTION_POINTER_DOWN|(2<<8),0,1,2);
        if(mode.equals("drag")) {
            for(int i=1;i<=40;i++) {
                points[1][0]=1200+i*4; points[1][1]=760-i*2;
                send(MotionEvent.ACTION_MOVE,0,1,2); SystemClock.sleep(50);
            }
        } else { SystemClock.sleep(2000); }
        SystemClock.sleep(1000); System.out.println("MOVED_"+mode);
        SystemClock.sleep(700);
        send(MotionEvent.ACTION_POINTER_UP|(1<<8),0,1,2);
        send(MotionEvent.ACTION_POINTER_UP|(1<<8),0,2);
        SystemClock.sleep(700); System.out.println("SHOOT_ONLY");
        SystemClock.sleep(700); send(MotionEvent.ACTION_UP,0);
        SystemClock.sleep(300); System.out.println("RELEASED");
    }
}
