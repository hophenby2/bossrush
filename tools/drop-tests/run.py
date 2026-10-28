#!/usr/bin/env python3
"""在临时目录验证阶段掉落、射击频率、伤害、双人选择与旧模式兼容。"""
from pathlib import Path
import argparse
import os
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--windows-pc',action='store_true')
args=parser.parse_args()
for windows in ([False,True] if args.windows_pc else [False]):
    with tempfile.TemporaryDirectory(prefix='bossrush-drop-tests-') as sandbox:
        command=['luajit',str(ROOT/'tools/drop-tests/unit.lua'),str(ROOT),sandbox]
        environment=None
        if windows:
            win=lambda value:'Z:'+str(value).replace('/','\\')
            base=ROOT/'android/build/save-tests'
            command=['wine',str(base/'LuaJIT-win/src/luajit.exe'),win(ROOT/'tools/drop-tests/unit.lua'),win(ROOT),win(sandbox)]
            environment=dict(os.environ,WINEPREFIX=str(base/'wine'),WINEDEBUG='-all',MVK_CONFIG_LOG_LEVEL='0')
        subprocess.run(command,cwd=ROOT,env=environment,check=True)
