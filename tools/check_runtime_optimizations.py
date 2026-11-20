#!/usr/bin/env python3
"""与指定 Git 基线逐值对照弹体判定、运动及随机流；所有参考文件写入临时目录。"""
import argparse
import hashlib
import os
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--baseline',default='e6c42fd169662ba7ad8b452d738f7681f517bc3e')
a=p.parse_args()
with tempfile.TemporaryDirectory(prefix='bossrush-runtime-parity-') as folder:
    refs={}
    for source in ('mod/GAME/th37/runtime.lua','mod/GAME/th38/runtime.lua','mod/GAME/th40/native.lua'):
        out=Path(folder)/(source.replace('/','_'))
        out.write_bytes(subprocess.check_output(['git','show',a.baseline+':'+source],cwd=ROOT))
        refs[source]=out
    checks=[('spring','191','mod/GAME/th37/runtime.lua'),('spring','367','mod/GAME/th37/runtime.lua'),
            ('snow','L/stage1/a','mod/GAME/th38/runtime.lua'),('snow','L/stage6/boss1/9','mod/GAME/th38/runtime.lua')]
    for mode,pattern,path in checks:
        def trace(file,native=False):
            env=dict(os.environ,BOSSRUSH_TRACE_NATIVE='1' if native else '0')
            return subprocess.check_output(['luajit','tools/runtime-tests/projectile_trace.lua',mode,str(file),pattern],cwd=ROOT,env=env)
        before,after=trace(refs[path]),trace(path,True)
        assert before==trace(path),f'无批量接口平台出现轨迹变化：{mode}/{pattern}'
        assert before==after, f'弹体轨迹或判定发生变化：{mode}/{pattern}'
        print(mode,pattern,len(before),'bytes',hashlib.sha256(before).hexdigest(),flush=True)

    for card in (68041,68053):
        cmd=['luajit','tools/runtime-tests/summer_trace.lua']
        before=subprocess.check_output([*cmd,str(refs['mod/GAME/th40/native.lua']),str(card)],cwd=ROOT)
        after=subprocess.check_output([*cmd,'mod/GAME/th40/native.lua',str(card)],cwd=ROOT,env=dict(os.environ,BOSSRUSH_TRACE_NATIVE='1'))
        fallback=subprocess.check_output([*cmd,'mod/GAME/th40/native.lua',str(card)],cwd=ROOT,env=dict(os.environ,BOSSRUSH_TRACE_NATIVE='0'))
        assert before==fallback,f'夏夜祭普通接口轨迹变化：{card}'
        assert before==after,f'夏夜祭绑定轨迹、事件或随机流发生变化：{card}'
        print('summer',card,len(before),'bytes',hashlib.sha256(before).hexdigest(),flush=True)
