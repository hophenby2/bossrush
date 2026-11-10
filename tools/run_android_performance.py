#!/usr/bin/env python3
"""在显式指定的测试设备运行确定性场景，保存日志、截图及结果，恢复诊断开关。"""
import argparse
import json
from pathlib import Path
import re
import subprocess
import time

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--adb',default=str(Path.home()/'Library/Android/sdk/platform-tools/adb'))
parser.add_argument('--serial',required=True)
parser.add_argument('--apk',type=Path)
parser.add_argument('--mode',default='benchmark case=3600 frames=900 seed=20261109')
parser.add_argument('--output',required=True,type=Path)
parser.add_argument('--timeout',type=int,default=180)
parser.add_argument('--background',action='store_true',help='稳定画面后切后台再返回，检查进程与绘制恢复')
args=parser.parse_args()
args.output.mkdir(parents=True,exist_ok=True)
base=[args.adb,'-s',args.serial]
package='org.bossrush.hd'
diagnostic='files/bossrush/User/android-diagnostics'
def adb(*words,input=None,check=True):
    return subprocess.run(base+list(words),input=input,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=check)
def write_mode(value):
    adb('shell','run-as',package,'mkdir','-p','files/bossrush/User')
    adb('shell','run-as',package,'tee',diagnostic,input=value)

if args.apk: adb('install','-r',str(args.apk.resolve()))
saved=adb('exec-out','run-as',package,'cat',diagnostic,check=False)
token='tag='+str(time.time_ns())
mode=args.mode+' '+token
log=''
try:
    adb('shell','am','force-stop',package)
    if args.mode.startswith('graphics'):
        adb('shell','run-as',package,'rm','-f','files/bossrush/snapshot/android-graphics.png',check=False)
    write_mode(mode.encode())
    adb('shell','am','start','-n',package+'/.BossRushActivity')
    deadline=time.monotonic()+args.timeout
    while time.monotonic()<deadline:
        time.sleep(2)
        log=adb('exec-out','run-as',package,'cat','files/lstg_log.txt',check=False).stdout.decode('utf-8',errors='replace')
        (args.output/'runtime.log').write_text(log)
        if 'BOSSRUSH_ERROR:' in log or 'BOSSRUSH_BOOT_ERROR:' in log:
            raise RuntimeError('场景报错，见 '+str(args.output/'runtime.log'))
        if args.mode.startswith('graphics'):
            ready='BOSSRUSH_GRAPHICS_READY:' in log
        else:
            ready=token in log and 'BOSSRUSH_CASE_ACTIONS:' in log[log.index(token):]
        if ready: break
    else: raise TimeoutError('场景未在时限内完成，见 '+str(args.output/'runtime.log'))
    (args.output/'screen.png').write_bytes(adb('exec-out','screencap','-p').stdout)
    if args.background:
        pid=adb('shell','pidof',package).stdout.strip()
        adb('shell','input','keyevent','3');time.sleep(1)
        adb('shell','am','start','-n',package+'/.BossRushActivity');time.sleep(2)
        assert pid==adb('shell','pidof',package).stdout.strip(),'返回前台后进程发生变化'
        (args.output/'screen-return.png').write_bytes(adb('exec-out','screencap','-p').stdout)
    if args.mode.startswith('graphics'):
        picture=adb('exec-out','run-as',package,'cat','files/bossrush/snapshot/android-graphics.png')
        (args.output/'native-snapshot.png').write_bytes(picture.stdout)
    if not args.mode.startswith('graphics'):
        state=adb('exec-out','run-as',package,'cat','files/bossrush/User/android-case-state.txt')
        (args.output/'state.txt').write_bytes(state.stdout)
    if 'probe=1' in args.mode:
        probe=adb('exec-out','run-as',package,'cat','files/bossrush/User/android-performance-probe.json')
        (args.output/'probe.json').write_bytes(probe.stdout)
    if 'state=full' in args.mode:
        state=adb('exec-out','run-as',package,'cat','files/bossrush/User/android-case-frames.txt')
        (args.output/'frames.txt').write_bytes(state.stdout)
    if 'snap=1' in args.mode:
        for frame in [630,720,780]:
            shot=adb('exec-out','run-as',package,'cat',f'files/bossrush/snapshot/android-case-{frame}.png')
            (args.output/f'frame-{frame}.png').write_bytes(shot.stdout)
    result={'mode':args.mode,'serial':args.serial,'model':adb('shell','getprop','ro.product.model').stdout.decode().strip(),
            'case':{},'perf':[],'contracts':[line for line in log.splitlines() if any(tag in line for tag in ['CONTRACTS:','COLLISION_CHECK:','CASE_ACTIONS:'])]}
    for line in log.splitlines():
        if 'BOSSRUSH_CASE_DONE:' in line:
            result['case']=dict(re.findall(r'(\w+)=([\w.]+)',line))
        if 'BOSSRUSH_PERF:' in line and 'RogueTen@RogueTen' in line and 'paused=false' in line:
            result['perf'].append(dict(re.findall(r'(\w+)=([\w.@-]+)',line)))
    (args.output/'result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'output':str(args.output),'case':result['case'],'contracts':result['contracts']},ensure_ascii=False))
finally:
    adb('shell','am','force-stop',package,check=False)
    if saved.returncode==0: write_mode(saved.stdout)
    else: adb('shell','run-as',package,'rm','-f',diagnostic,check=False)
