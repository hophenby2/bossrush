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
    for path in (ROOT/'tools/relay').glob('*'):
        if path.is_file(): files['relay/'+path.name]=path
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

主菜单：随机十战 / 接续模式 / 双Boss随机十战。
接续模式在当前 Boss 剩余 HP ≤15% 或剩余时间 <3秒时推进；旧 Boss 继续存活，下一张先用 GHOST 碰撞组等旧 Boss 退出。接续模式不掉落强化选项，Boss 死亡 / 击破结算也不自动全屏消弹。
双模式每步同时运行两张不同卡，十步共二十张，允许同角色。
Boss 出场、开卡初始化及第一段指定位置移动按原 X+96 / X-96、原 Y；后续移动沿用原卡。
两张卡全部结束后推进；第十次失误触发答题复活，每局最多成功三次。
答题沿用原 Special 的八道数学题；上下左右移动，上顶中玉横线提前确认、符卡放弃，答对后原场续战并无敌三秒。
答题期间冻结战斗；累计失误不回退，题目与复活次数可关内恢复。不加入天气、商店与道具构筑。
Rank 初始 50、范围 0–100，每秒自然 +0.05，收卡 +3，中弹 -8。敌弹速度与开卡 HP 在原定义的 90%–110% 间变化。
当前卡 HP 倍率固定，切关、复活与续玩继承 Rank；新局重置。规则详见 mod/roguelike.txt 和 THlib/rank.txt。F9 联机合作，F5 手动保存，F10 存档同步；暂停、退出及每 120 逻辑帧补存。

本包不含用户存档或录像。旧玩家更新前可保留自己的 User/、replay/，再覆盖游戏文件。
精确关内续玩需要同 Lua 源码和引擎平台；旧版关内点因源码更新会保留并拒绝重建。
本次含关内续玩、多存档同步、单/双 Boss 随机十战与接续模式、答题复活、定位及子弹朝向修复，以及全局 Rank、双人联机与 0.9.1 弹幕分区道具。
击破阶段后出现两个选项，红字影响伤害，蓝字影响射击频率；初始 100，右侧明确显示。
选项与原 Special 共用中玉横线、分隔弹和随弹下落文字，沿用 500 逻辑帧下降周期；上顶横线提前生效。新局重置，本局继承并支持关内恢复。
自机火力 150 时，普通弹与追踪弹及拖影宽高均为原来的1.5倍，魔理沙光束宽度同步放大。
联机两位玩家分别选择与成长，详细规则见 THlib/drops.txt。
联机支持局域网/公网 IPv4 直连及自部署中继，房主选关开始；对方自机及自机弹为 65% 不透明度。
失误、Rank、分数、复活额度共享，联机仅保存独立合作统计。F9 房间管理，ESC 暂停；原口令与原自机可重连。
中继脚本及部署步骤位于 relay/；本包未配置公共中继。详见 THlib/net/联机说明.txt。
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
    parser.add_argument('--version',default='0.10.3')
    package(parser.parse_args().version)
