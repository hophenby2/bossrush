#!/usr/bin/env python3
"""在隔离安卓设备验证顺序模式机体菜单、续关触控与灵击原生绘制。"""
import argparse
import json
from pathlib import Path
import subprocess
import time
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--serial',required=True)
p.add_argument('--adb',default=str(Path.home()/'Library/Android/sdk/platform-tools/adb'))
p.add_argument('--apk',type=Path)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--only',choices=['menu','bomb','continue'])
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
base=[a.adb,'-s',a.serial];package='org.bossrush.hd';flag='files/bossrush/User/android-diagnostics'
def adb(*words,input=None,check=True):
    return subprocess.run(base+list(words),input=input,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=check)
if a.apk:adb('install','-r',str(a.apk.resolve()))
saved=adb('exec-out','run-as',package,'cat',flag,check=False)
cases=[('bomb-reimua','kind=bomb machine=reimua'),('bomb-marisab','kind=bomb machine=marisab'),
       ('menu-portrait','kind=menu'),('menu-landscape','kind=menu landscape=1'),
       ('continue-portrait','kind=continue sequence=th06_lunatic'),('continue-landscape','kind=continue sequence=th06_lunatic landscape=1')]
try:
    for name,options in cases:
        if a.only and not name.startswith(a.only):continue
        dest=a.output/name;dest.mkdir(exist_ok=True)
        adb('shell','wm','size','1600x720' if name.endswith('landscape') else '720x1600')
        token='tag='+str(time.time_ns());mode=f'content presentation=1 {options} {token}'
        adb('shell','am','force-stop',package)
        adb('shell','run-as',package,'tee',flag,input=mode.encode())
        adb('shell','am','start','-n',package+'/.BossRushActivity')
        deadline=time.monotonic()+100
        while time.monotonic()<deadline:
            time.sleep(1)
            log=adb('exec-out','run-as',package,'cat','files/lstg_log.txt',check=False).stdout.decode(errors='replace')
            (dest/'runtime.log').write_text(log)
            if 'BOSSRUSH_ERROR:' in log or 'BOSSRUSH_BOOT_ERROR:' in log:raise RuntimeError(name+' 运行错误')
            if 'BOSSRUSH_PRESENTATION_DONE: '+mode in log:break
        else:raise TimeoutError(name+' 诊断超时')
        raw=adb('exec-out','run-as',package,'cat','files/bossrush/User/android-presentation-probe.json').stdout
        result=json.loads(raw);(dest/'result.json').write_bytes(raw)
        for path in result['shots']:
            (dest/Path(path).name).write_bytes(adb('exec-out','run-as',package,'cat','files/bossrush/'+path).stdout)
        (dest/'screen.png').write_bytes(adb('exec-out','screencap','-p').stdout)
        if name.startswith('bomb'):assert len(result['rows'])==7 and len(result['shots'])==7,name
        if name.startswith('continue'):assert result['rows'][-1]['continues']==1,name
        print(name,'通过',flush=True)
finally:
    adb('shell','wm','size','reset',check=False)
    adb('shell','am','force-stop',package,check=False)
    if saved.returncode==0:adb('shell','run-as',package,'tee',flag,input=saved.stdout,check=False)
    else:adb('shell','run-as',package,'rm','-f',flag,check=False)
