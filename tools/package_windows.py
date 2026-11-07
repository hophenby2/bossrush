#!/usr/bin/env python3
"""生成可独立运行的 Windows x64 游戏包；不读取玩家存档或录像。"""
from pathlib import Path
import argparse
import hashlib
import struct
import zipfile

ROOT=Path(__file__).resolve().parents[1]
ENGINE_ROOT=ROOT
OUTPUT=ROOT/'android/dist'

def package(version):
    exe=ENGINE_ROOT/'LuaSTGSub.exe'
    data=exe.read_bytes();header=struct.unpack_from('<I',data,0x3c)[0]
    assert data[:2]==b'MZ' and data[header:header+4]==b'PE\0\0', '缺少有效 Windows 引擎'
    assert struct.unpack_from('<H',data,header+4)[0]==0x8664, '需要 Windows x64 引擎'
    files={}
    for name in ['launch','launch.lua','launcher.lua','core.lua','manual','Update.txt','LuaSTGSub.exe']:
        path=(ENGINE_ROOT if name=='LuaSTGSub.exe' else ROOT)/name;assert path.is_file(),name;files[name]=path
    for folder in ['THlib','Resources','mod','music','BadApple','shader']:
        for path in (ROOT/folder).rglob('*'):
            if path.is_file() and not path.name.startswith('.') and path.suffix not in {'.bak','.orig','.bakpool'}:
                files[path.relative_to(ROOT).as_posix()]=path
    for path in (ROOT/'tools/relay').glob('*'):
        if path.is_file(): files['relay/'+path.name]=path
    for path in ENGINE_ROOT.glob('*.dll'): files[path.name]=path
    upstream=ENGINE_ROOT.parent/'LuaSTG-Sub'
    assert (upstream/'License.txt').is_file(),'缺少引擎许可证'
    files['licenses/LuaSTG-Sub/License.txt']=upstream/'License.txt'
    for path in (upstream/'data/license').rglob('*'):
        if path.is_file():files['licenses/'+path.relative_to(upstream/'data/license').as_posix()]=path
    assert not any(n.startswith(('User/','replay/')) for n in files)
    out=OUTPUT;out.mkdir(parents=True,exist_ok=True)
    name=f'BossRushHD-Windows-x64-{version}'
    target=out/(name+'.zip')
    guide=f'''Boss Rush HD {version} Windows x64 发行版

完整离线包，含 LuaSTG Sub 引擎、脚本、音乐与素材。完整解压后运行 LuaSTGSub.exe。
请保持 launch、Lua 脚本及各素材文件夹位于 exe 同级，勿在压缩包内直接启动。
适用 Windows x64，需要支持 Direct3D 11 的显卡。引擎版本为 LuaSTG Sub 0.21.129。

主菜单仅保留：roguelike模式、查看录像、按键设置、其他设置、退出游戏。
roguelike 模式没有战数上限：所选卡池内每轮不重复，抽完后重新洗牌继续。
可选择永夜抄、红魔乡、妖妖梦、风神录，以及 Lunatic、Extra/Phantasm、Boss / 道中。
筛选交集内至少有一张候选即可开始。生命、强化、Bomb 和复活次数跨轮保留。
初始十条命，每局最多三次答题复活机会，答对恢复五条命并获得三秒无敌。
生命耗尽且未能复活时结算，记录累计完成战数；可重开或返回标题并保存录像。

阶段强化三选一：左侧蓝色增加 Bomb 恢复，中间红色增加火力，右侧绿色减小自机判定。
开局三枚 Bomb，上限三枚；100 蓝值时每三十秒恢复一枚。按 X 立即消耗一枚释放 Bomb。
保留答题和强化选项的演出，普通道具掉落关闭。
成就、联机、存档同步和续玩点系统暂时停用，F5/F9/F10 的相关入口关闭。
普通本地设置、成长记录及录像功能保留，旧十战录像仍按旧规则结束。

默认操作：方向键移动，Shift 低速，Z 射击/确认，X Bomb/返回，C 特殊，Esc 暂停。
准备界面可用 Enter 开始，也可使用鼠标；按键可在主菜单中调整。

本包不含玩家存档、录像、个人设置、运行日志、开发及构建缓存。
首次运行会在游戏目录建立本地数据，请解压到有写入权限的文件夹。
原有 User/ 和 replay/ 数据可自行保留；恢复续玩入口在当前版本停用。
引擎及依赖许可证见 licenses/；详细模式规则见 mod/roguelike.txt。
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
    parser.add_argument('--version',default='0.13.0')
    parser.add_argument('--game-root',type=Path,help='只从指定源码快照读取游戏脚本与素材')
    parser.add_argument('--engine-root',type=Path,default=ENGINE_ROOT,help='Windows 引擎、DLL 及其相邻许可证目录')
    parser.add_argument('--output-dir',type=Path,default=OUTPUT)
    args=parser.parse_args()
    if args.game_root: ROOT=args.game_root.resolve()
    ENGINE_ROOT=args.engine_root.resolve();OUTPUT=args.output_dir.resolve()
    package(args.version)
