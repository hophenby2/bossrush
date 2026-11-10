#!/usr/bin/env python3
"""在指定测试设备逐作验证整关及符卡入口；恢复私有诊断标记。"""
import argparse
import json
from pathlib import Path
import subprocess
import time

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--serial',required=True)
p.add_argument('--adb',default=str(Path.home()/'Library/Android/sdk/platform-tools/adb'))
p.add_argument('--output',type=Path,required=True)
p.add_argument('--apk',type=Path)
p.add_argument('--levels',default='29,30,31,32,33',help='验证实际关卡level，逗号分隔')
p.add_argument('--replay',action='store_true',help='实际保存并回放当前练习录像')
p.add_argument('--audio',action='store_true',help='逐个加载、播放并核对全部WAV逻辑音效的原生解码信息')
p.add_argument('--sequences',help='顺序模式稳定key列表，逗号分隔；all表示全部十二个实际难度/路线入口')
p.add_argument('--frames',type=int,default=300,help='每个入口运行的逻辑帧数')
p.add_argument('--shoot',action='store_true',help='让无敌测试自机持续射击，验证击破后续接')
p.add_argument('--after-midboss',action='store_true',help='必须经过中Boss和连续道中，实际进入关底或下一面')
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
base=[a.adb,'-s',a.serial];package='org.bossrush.hd';flag='files/bossrush/User/android-diagnostics'
def adb(*words,input=None,check=True):
    return subprocess.run(base+list(words),input=input,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=check)
if a.apk:adb('install','-r',str(a.apk.resolve()))
saved=adb('exec-out','run-as',package,'cat',flag,check=False)
replay_path='files/bossrush/replay/__slim-content-check.rpy'
saved_replay=adb('exec-out','run-as',package,'cat',replay_path,check=False) if a.replay else None
try:
    sequences=['th08_lunatic_a','th08_lunatic_b','th08_extra','th06_lunatic','th06_extra','th095_scenes','th095_extra',
        'th07_lunatic','th07_extra','th07_phantasm','th10_lunatic','th10_extra'] if a.sequences=='all' else a.sequences.split(',') if a.sequences else []
    cases=[(key,False) for key in sequences] if sequences else [(level,whole) for level in map(int,('29' if a.audio else a.levels).split(',')) for whole in ([False] if a.audio else [False,True])]
    for level,whole in cases:
        directory=a.output/(str(level)+('' if sequences else '-whole' if whole else '-spell'));directory.mkdir(exist_ok=True)
        token='tag='+str(time.time_ns())
        mode=f'content {"sequence" if sequences else "level"}={level} frames={a.frames} whole={int(whole)} replay={int(a.replay)} audio={int(a.audio)} shoot={int(a.shoot)} after_midboss={int(a.after_midboss)} {token}'
        adb('shell','am','force-stop',package)
        adb('shell','run-as',package,'tee',flag,input=mode.encode())
        adb('shell','am','start','-n',package+'/.BossRushActivity')
        deadline=time.monotonic()+max(70,a.frames/30+30)
        while time.monotonic()<deadline:
            time.sleep(1)
            log=adb('exec-out','run-as',package,'cat','files/lstg_log.txt',check=False).stdout.decode('utf-8',errors='replace')
            (directory/'runtime.log').write_text(log)
            if 'BOSSRUSH_ERROR:' in log or 'BOSSRUSH_BOOT_ERROR:' in log:raise RuntimeError(str(directory)+' 运行报错')
            if token in log and 'BOSSRUSH_CONTENT_DONE:' in log[log.index(token):]:break
        else:raise TimeoutError(str(directory)+' 验证超时')
        (directory/'screen.png').write_bytes(adb('exec-out','screencap','-p').stdout)
        if a.audio:
            decoded=adb('exec-out','run-as',package,'cat','files/bossrush/User/android-audio-check.tsv').stdout
            (directory/'audio.tsv').write_bytes(decoded)
            expected=json.loads((Path(__file__).resolve().parents[1]/'android/build/audio-optimization.json').read_text())
            lines=decoded.decode().splitlines()
            assert len(lines)==len(expected),'原生验证音效数量不全'
            for line in lines:
                path,frames,channels,rate,duration=line.split('\t');record=expected[path]
                assert int(frames)==record['frames'] and int(channels)==record['channels'],path
                assert abs(int(rate)-record['sample_rate'])<=1,path
                assert abs(float(duration)-record['frames']/record['sample_rate'])<.00001,path
        elif not a.replay:
            (directory/'native.png').write_bytes(adb('exec-out','run-as',package,'cat','files/bossrush/snapshot/android-content.png').stdout)
        print(mode,'通过',flush=True)
finally:
    adb('shell','am','force-stop',package,check=False)
    if saved.returncode==0:adb('shell','run-as',package,'tee',flag,input=saved.stdout,check=False)
    else:adb('shell','run-as',package,'rm','-f',flag,check=False)
    if saved_replay is not None:
        if saved_replay.returncode==0:adb('shell','run-as',package,'tee',replay_path,input=saved_replay.stdout,check=False)
        else:adb('shell','run-as',package,'rm','-f',replay_path,check=False)
