#!/usr/bin/env python3
"""复用已有Mac原生程序，在本worktree用正式资源管线生成独立测试包。"""
import argparse,importlib.util,shutil,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--base-app',type=Path,required=True)
p.add_argument('--engine',type=Path,required=True,help='已有macos/.cache/LuaSTG-x，只读取src/res')
a=p.parse_args();target=root/'macos/dist/Boss Rush HD.app'
assert a.base_app.resolve()!=target.resolve(),'基础包不能是输出目录'
assert (a.base_app/'Contents/MacOS/BossRushHD').is_file()
assert (a.engine/'src/keycode.lua').is_file()
target.parent.mkdir(parents=True,exist_ok=True)
shutil.copytree(a.base_app,target,dirs_exist_ok=True)
spec=importlib.util.spec_from_file_location('th38_mac_build',root/'macos/build.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);m.ENGINE=a.engine.resolve()
# prepare_assets会重写WAV标准数据块；直接覆盖源码WAV会令focus音效解码失败。
assets=m.resources();destination=target/'Contents/Resources'
shutil.rmtree(destination/'game');shutil.copytree(assets,destination,dirs_exist_ok=True)
cache=root/'macos/.cache/LuaSTG-x/src';cache.mkdir(parents=True,exist_ok=True)
shutil.copy2(a.engine/'src/keycode.lua',cache/'keycode.lua')
subprocess.run(['codesign','--force','--deep','--sign','-',str(target)],check=True)
print(target)
