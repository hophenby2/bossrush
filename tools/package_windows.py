#!/usr/bin/env python3
"""生成可独立运行的 Windows x64 游戏包；不读取玩家存档或录像。"""
from pathlib import Path
import argparse
import hashlib
import struct
import zipfile

ROOT=Path(__file__).resolve().parents[1]

def package(version):
    exe=ROOT/'LuaSTGSub.exe'
    data=exe.read_bytes();header=struct.unpack_from('<I',data,0x3c)[0]
    assert data[:2]==b'MZ' and data[header:header+4]==b'PE\0\0', '缺少有效 Windows 引擎'
    assert struct.unpack_from('<H',data,header+4)[0]==0x8664, '需要 Windows x64 引擎'
    files={}
    for name in ['launch','launch.lua','launcher.lua','core.lua','manual','Update.txt','LuaSTGSub.exe']:
        path=ROOT/name;assert path.is_file(),name;files[name]=path
    for folder in ['THlib','Resources','mod','music','BadApple','shader']:
        for path in (ROOT/folder).rglob('*'):
            if path.is_file() and not path.name.startswith('.') and path.suffix not in {'.bak','.orig','.bakpool'}:
                files[path.relative_to(ROOT).as_posix()]=path
    for path in ROOT.glob('*.dll'): files[path.name]=path
    upstream=ROOT.parent/'LuaSTG-Sub'
    assert (upstream/'License.txt').is_file(),'缺少引擎许可证'
    files['licenses/LuaSTG-Sub/License.txt']=upstream/'License.txt'
    for path in (upstream/'data/license').rglob('*'):
        if path.is_file():files['licenses/'+path.relative_to(upstream/'data/license').as_posix()]=path
    assert not any(n.startswith(('User/','replay/')) for n in files)
    out=ROOT/'android/dist';out.mkdir(parents=True,exist_ok=True)
    name=f'BossRushHD-Windows-x64-{version}'
    target=out/(name+'.zip')
    guide=f'''Boss Rush HD {version} Windows x64 测试版

完整离线包，含 LuaSTG Sub 引擎、脚本与素材。解压后运行 LuaSTGSub.exe。
请保持 launch、Lua 脚本与各素材文件夹位于 exe 同级，勿在压缩包内直接启动。
使用 Windows 10 / 11 x64 及支持 Direct3D 11 的显卡。

主菜单：随机十战 / 双Boss随机十战。
双模式每步同时运行两张不同卡，十步共二十张，允许同角色。
Boss 出场与开卡初始化位置按原 X+96 / X-96、原 Y；后续移动沿用原卡。
两张卡全部结束后推进；累计十次失误结束。不加入天气、商店与道具构筑。
规则详见 mod/roguelike.txt。F5 手动保存，F10 存档同步；暂停、退出及每 120 逻辑帧补存。

本包不含用户存档或录像。旧玩家更新前可保留自己的 User/、replay/，再覆盖游戏文件。
精确关内续玩需要同 Lua 源码和引擎平台；旧版关内点因源码更新会保留并拒绝重建。
本次含 0.3.1 关内续玩、0.4.0 单 Boss 随机十战与 0.5.0 双 Boss 模式。
Windows 引擎使用原发行目录的 LuaSTGSub.exe；引擎和依赖许可证见 licenses/。
'''
    with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as archive:
        for relative,path in sorted(files.items()): archive.write(path,name+'/'+relative)
        archive.writestr(name+'/README.zh-CN.txt',guide)
    # 对全部成员做 CRC 和逐文件 SHA-256 校验，避免只检查文件名而漏掉素材。
    with zipfile.ZipFile(target) as archive:
        assert archive.testzip() is None,'Windows ZIP CRC 失败'
        for relative,path in files.items():
            assert hashlib.sha256(archive.read(name+'/'+relative)).digest()==hashlib.file_digest(path.open('rb'),'sha256').digest(),relative
        assert not any('/User/' in n or '/replay/' in n for n in archive.namelist())
    digest=hashlib.file_digest(target.open('rb'),'sha256').hexdigest()
    target.with_suffix('.zip.sha256').write_text(digest+'  '+target.name+'\n')
    print(f'Windows 完整包校验通过：{len(files)} 个文件，{target.stat().st_size/1024/1024:.1f} MiB；SHA-256 {digest}')
    return target

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--version',default='0.5.0')
    package(parser.parse_args().version)
