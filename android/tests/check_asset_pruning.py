#!/usr/bin/env python3
"""执行Like Dreamer真实资源登记，确保裁剪包含全部十关及全部机体需要的文件。"""
from pathlib import Path
import argparse
import subprocess
import sys
import zipfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'android'))
from asset_policy import include_asset, native_font_images, DREAMER

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--apk', type=Path)
args = parser.parse_args()
lua = '''
local paths={}
local function add(_,name,path) if type(path)=='string' then paths[path]=true end end
local methods={AddTexture=add,AddSpriteFromFile=add,AddSound=add,AddMusic=add}
setmetatable(methods,{__index=function() return function() end end})
lstg={ResourceSet={Create=function() return setmetatable({},{__index=methods}) end}}
dofile('mod/GAME/ports/dreamer/LikeDreamer/resources.lua')
for path in pairs(paths) do print('Resources/ports/dreamer/'..path) end
'''
result = subprocess.run(['luajit', '-'], cwd=ROOT, input=lua, text=True, capture_output=True, check=True)
paths = result.stdout.splitlines()
assert paths, '未执行资源登记'
for path in paths:
    assert include_asset(path), '裁剪了当前登记资源：'+path
    assert (ROOT/path).is_file(), '登记文件缺失：'+path
assert not include_asset(DREAMER+'stage/StageBack1.png')
assert not include_asset(DREAMER+'system/Ending.png')
assert not include_asset(DREAMER+'bgm/Title.ogg')
assert include_asset('Resources/th43/boss/Cirno/BossWalkImage.png')
if args.apk:
    with zipfile.ZipFile(args.apk) as apk:
        for image in native_font_images(ROOT):
            assert 'assets/game/'+image.relative_to(ROOT).as_posix() in apk.namelist(), image
        # 使用APK中的实际别名，覆盖图片编码、去重和WAV转换共同作用后的路径。
        resolver = "local a="+apk.read('assets/game/asset_variants.lua').decode().removeprefix('return ')
        resolver += "\nfor line in io.lines() do print('assets/game/'..(a[line] or line)) end"
        result = subprocess.run(['luajit', '-e', resolver], input='\n'.join(paths)+'\n',
                                text=True, capture_output=True, check=True)
        for path in result.stdout.splitlines():
            assert path in apk.namelist(), 'APK缺少当前登记资源：'+path
        for path in apk.namelist():
            if path.startswith('assets/game/'):
                assert include_asset(path.removeprefix('assets/game/')), 'APK仍有应裁剪资源：'+path
print(f'Like Dreamer完整资源登记与裁剪检查通过，共{len(paths)}个依赖')
