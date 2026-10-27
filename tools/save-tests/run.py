#!/usr/bin/env python3
"""构建宿主测试用 cjson，运行不接触真实玩家目录的存档回归。"""
from pathlib import Path
import argparse
import platform
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--browser',action='store_true',help='附加浏览器界面与二维码回归，需 Puppeteer')
parser.add_argument('--windows-pc',action='store_true',help='附加已准备好的 Windows x64 LuaJIT / Wine 网络回归')
args=parser.parse_args()
build=ROOT/'android/build/save-tests'
engine=ROOT/'android/.cache/LuaSTG-x/frameworks/cocos2d-x/external/lua'
source=engine/'lua-cjson'
if not (source/'lua_cjson.c').exists():
    parser.error('请先运行 python3 android/build.py --assets-only，准备固定版本引擎缓存')
build.mkdir(parents=True,exist_ok=True)
patched=build/'lua_cjson.c'
patched.write_text((source/'lua_cjson.c').read_text().replace('luaL_setfuncs','br_luaL_setfuncs'))
flags=['-bundle','-undefined','dynamic_lookup'] if platform.system()=='Darwin' else ['-shared','-fPIC']
subprocess.run(['cc','-O2',*flags,'-I',str(engine/'luajit/include'),'-I',str(source),str(patched),str(source/'strbuf.c'),str(source/'fpconv.c'),'-o',str(build/'cjson.so')],check=True)
with tempfile.TemporaryDirectory(prefix='bossrush-save-tests-') as sandbox:
    subprocess.run(['luajit',str(ROOT/'tools/save-tests/unit.lua'),str(ROOT),sandbox],cwd=ROOT,check=True)
subprocess.run(['python3',str(ROOT/'tools/save-tests/integration.py'),*(['--windows-pc'] if args.windows_pc else [])],cwd=ROOT,check=True)
if args.browser:
    (ROOT/'android/dist/save-sync-test').mkdir(parents=True,exist_ok=True)
    subprocess.run(['node',str(ROOT/'tools/save-tests/browser.cjs')],cwd=ROOT,check=True)
