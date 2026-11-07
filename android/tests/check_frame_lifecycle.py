#!/usr/bin/env python3
"""用可控消息队列执行实际FramePacer和Activity生命周期片段，检查恢复、切换及旧回调失效。"""
from pathlib import Path
import os
import subprocess

ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'build/frame-lifecycle-check'
BUILD.mkdir(parents=True,exist_ok=True)
activity=(ROOT/'java/org/bossrush/hd/BossRushActivity.java').read_text(encoding='utf-8')
resume=activity.split('@Override protected void onResume() {',1)[1].split('        if (audioManager != null)',1)[0]
base=(ROOT/'.cache/LuaSTG-x/frameworks/cocos2d-x/cocos/platform/android/java/src/org/cocos/lib/CocosActivity.java').read_text()
assert 'mGLSurfaceView.setRenderMode(GLSurfaceView.RENDERMODE_CONTINUOUSLY);' in base
sources={
'android/os/HandlerThread.java':'''package android.os;
public class HandlerThread {public boolean closed;public HandlerThread(String s,int p){} public void start(){} public Object getLooper(){return this;} public boolean quitSafely(){closed=true;return true;}}
''',
'android/os/Process.java':'''package android.os; public class Process {public static final int THREAD_PRIORITY_DISPLAY=-4;}''',
'android/os/Handler.java':'''package android.os;
import java.util.*;
public class Handler {
 public static final ArrayDeque<Runnable> posted=new ArrayDeque<>(),delayed=new ArrayDeque<>();
 public Handler(Object looper){} public void post(Runnable r){posted.add(r);}
 public void postDelayed(Runnable r,long ms){if(ms<1)throw new AssertionError("忙等");delayed.add(r);}
 public void removeCallbacksAndMessages(Object token){posted.clear();delayed.clear();}
 public static void drain(){while(!posted.isEmpty())posted.remove().run();}
}
''',
'android/view/Choreographer.java':'''package android.view;
import java.util.*;
public class Choreographer {
 public interface FrameCallback {void doFrame(long time);}
 private static final Choreographer instance=new Choreographer();
 public final ArrayList<FrameCallback> callbacks=new ArrayList<>();
 public static Choreographer getInstance(){return instance;}
 public void postFrameCallback(FrameCallback c){callbacks.add(c);}
 public void removeFrameCallback(FrameCallback c){callbacks.removeIf(x->x==c);}
 public static void fire(long time){var list=new ArrayList<>(instance.callbacks);instance.callbacks.clear();for(var c:list)c.doFrame(time);}
}
''',
'android/util/Log.java':'''package android.util;public class Log {public static int i(String a,String b){return 0;}}''',
'android/opengl/GLSurfaceView.java':'''package android.opengl;public class GLSurfaceView {public static final int RENDERMODE_CONTINUOUSLY=1,RENDERMODE_WHEN_DIRTY=0;}''',
'org/cocos/lib/CocosGLSurfaceView.java':'''package org.cocos.lib;
public class CocosGLSurfaceView {public int requests,mode;public void requestRender(){requests++;} public void setRenderMode(int m){mode=m;}}
''',
'org/bossrush/hd/FramePacerCheck.java':'''package org.bossrush.hd;
import android.os.Handler;import android.view.Choreographer;import android.opengl.GLSurfaceView;import org.cocos.lib.CocosGLSurfaceView;
class BaseActivity {
 final CocosGLSurfaceView view=new CocosGLSurfaceView();
 CocosGLSurfaceView getGLSurfaceView(){return view;}
 protected void onResume(){view.setRenderMode(GLSurfaceView.RENDERMODE_CONTINUOUSLY);}
}
public class FramePacerCheck extends BaseActivity {
 boolean resumed;final FramePacer framePacer=new FramePacer(view);
 @Override protected void onResume(){'''+resume+'''}
 public static void main(String[] args) {
  var activity=new FramePacerCheck();var pacer=activity.framePacer;var view=activity.view;
  pacer.configure(true);activity.onResume();Handler.drain();
  if(view.mode!=GLSurfaceView.RENDERMODE_WHEN_DIRTY)throw new AssertionError("基类恢复覆盖按需模式");
  for(int i=0;i<120;i++)Choreographer.fire(i*1_000_000_000L/120);
  if(view.requests!=60)throw new AssertionError("高刷新率多绘制: "+view.requests);
  pacer.stop();Handler.drain();int stopped=view.requests;Choreographer.fire(2_000_000_000L);
  if(view.requests!=stopped)throw new AssertionError("暂停后继续请求");
  activity.onResume();Handler.drain();
  if(view.mode!=0 || Choreographer.getInstance().callbacks.size()!=1)throw new AssertionError("恢复未重新调度");
  pacer.configure(false);Handler.drain();
  if(!Choreographer.getInstance().callbacks.isEmpty() || Handler.delayed.size()!=1)throw new AssertionError("关闭同步未切到独立时钟");
  Runnable stale=Handler.delayed.remove();pacer.configure(true);Handler.drain();int before=view.requests;stale.run();
  if(view.requests!=before || !Handler.delayed.isEmpty())throw new AssertionError("旧时钟回调未失效");
  for(int i=0;i<20;i++)pacer.configure(i%2==0);Handler.drain();
  if(!Choreographer.getInstance().callbacks.isEmpty() || Handler.delayed.size()!=1)throw new AssertionError("重复切换产生多条调度链");
  pacer.close();Handler.drain();
  if(!Choreographer.getInstance().callbacks.isEmpty() || !Handler.delayed.isEmpty())throw new AssertionError("退出遗留回调");
  System.out.println("实际Activity恢复按需绘制、同步/独立时钟切换、旧回调失效和退出清理检查通过");
 }
}
'''
}
for name,text in sources.items():
    p=BUILD/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
java=Path(os.environ.get('JAVA_HOME','C:/Program Files/Java/jdk-24'))/'bin'
classes=BUILD/'classes';classes.mkdir(exist_ok=True)
suffix='.exe' if os.name=='nt' else ''
subprocess.run([str(java/('javac'+suffix)),'-encoding','UTF-8','-d',str(classes),
    *map(str,BUILD.rglob('*.java')),
    str(ROOT/'java/org/bossrush/hd/FrameCadence.java'),str(ROOT/'java/org/bossrush/hd/FramePacer.java')],check=True)
subprocess.run([str(java/('java'+suffix)),'-Dstdout.encoding=UTF-8','-cp',str(classes),'org.bossrush.hd.FramePacerCheck'],check=True)
