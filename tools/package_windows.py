#!/usr/bin/env python3
"""生成可独立运行的 Windows x64 游戏包；不读取玩家存档或录像。"""
from pathlib import Path
import argparse
import hashlib
import struct
import zipfile
import json
import re
import sys
from release_version import game_version

ROOT=Path(__file__).resolve().parents[1]
TOOL_ROOT=ROOT
ENGINE_ROOT=ROOT
OUTPUT=ROOT/'android/dist'

def package(version,optimize=False):
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
    generated={}
    aliases={}
    image_records={}
    audio_records={}
    if optimize:
        sys.path.insert(0,str(TOOL_ROOT/'android'))
        from asset_optimizer import optimize_images
        from audio_optimizer import optimize_audio
        images=[path for name,path in files.items() if name.endswith('.png')]
        audio=[path for name,path in files.items() if name.endswith('.wav')]
        optimized,image_records=optimize_images(images,TOOL_ROOT/'android/.cache/lossless-images',ROOT,True)
        sounds,audio_records=optimize_audio(audio,TOOL_ROOT/'android/.cache/vorbis-sounds')
        # Sub按文件头解码图片/音频，保留PNG/WAV逻辑文件名以兼容原枚举和原作脚本。
        for name,path in list(files.items()): files[name]=optimized.get(path,sounds.get(path,path))
        # HGE字体在C++内部读取Bitmap，不经过Lua LoadTexture；这些图保留实体文件。
        font_bitmaps=set()
        for name,path in files.items():
            if name.endswith('.fnt'):
                for bitmap in re.findall(r'(?im)^Bitmap\s*=\s*([^\r\n]+)',path.read_text(encoding='utf-8-sig')):
                    font_bitmaps.add((Path(name).parent/bitmap.strip().strip('"')).as_posix())
        copies={}
        for name in sorted(list(files)):
            if not name.endswith('.png'):continue
            digest=hashlib.sha256(files[name].read_bytes()).digest()
            if digest in copies and name not in font_bitmaps:
                aliases[name]=copies[digest]
                del files[name]
            else:copies.setdefault(digest,name)
        generated['windows/asset_aliases.lua']=('return {\n'+''.join(
            ' ['+json.dumps(src,ensure_ascii=False)+']='+json.dumps(dst,ensure_ascii=False)+',\n'
            for src,dst in sorted(aliases.items()))+'}\n').encode()
        files['windows/assets.lua']=TOOL_ROOT/'windows/assets.lua'
        entry=(ROOT/'launch').read_text(encoding='utf-8-sig')
        anchor='lstg.DoFile("launch.lua")'
        assert entry.count(anchor)==1,'Windows入口不符合预期'
        generated['launch']=entry.replace(anchor,'lstg.DoFile("windows/assets.lua")\n'+anchor).encode()
        del files['launch']
    out=OUTPUT;out.mkdir(parents=True,exist_ok=True)
    name=f'BossRushHD-Windows-x64-{version}'+('-slim' if optimize else '')
    target=out/(name+'.zip')
    guide=f'''Boss Rush HD {version} Windows x64 发行版

完整离线包，含 LuaSTG Sub 引擎、脚本、音乐与素材。完整解压后运行 LuaSTGSub.exe。
请保持 launch、Lua 脚本及各素材文件夹位于 exe 同级，勿在压缩包内直接启动。
适用 Windows x64，需要支持 Direct3D 11 的显卡。引擎版本为 LuaSTG Sub 0.21.129。

主菜单提供 roguelike模式、顺序模式、查看录像、按键设置、其他设置、退出游戏。
顺序模式按当前保留卡集的原作阶段进行：每作Lunatic/Extra/Phantasm各自独立，永夜抄Final A/B分开；文花帖按原作Level 1–10/Extra分场景。
此模式没有血量倍率或阶段强化，保留生命与Bomb；中Boss战期间道中时间轴继续前进，到原作等待点才停止，错过的增援不会从头补播。
关卡背景使用原作STD模型、镜头与ANM，符卡背景沿用原作ANM；原曲从PCM/WAV压成Ogg，保留采样率、声道和循环点。
roguelike 模式没有战数上限：所选卡池内每轮不重复，抽完后重新洗牌继续。
可选择永夜抄、红魔乡、妖妖梦、风神录，以及 Lunatic、Extra/Phantasm、Last Word、Boss / 道中。
高级选项默认收起，默认勾选四作 Lunatic 的非符和符卡；Extra/Phantasm、Last Word、道中、时符默认不勾选。
时符选项可排除无法击破的耐久卡；地灵殿目前不开放 roguelike 选择。
筛选交集内至少有一张候选即可开始。生命、强化和 Bomb 跨轮保留。
普通非符和符卡撑满时限即掉落强化，中弹或使用 Bomb 不取消该超时奖励。
主菜单连续输入88888开放练习；关卡与符卡练习仅收录TH31–TH35，名称统一为“xxx原作”。
练习列表与整关按已移植内容的原作阶段排序，被中Boss隔开的道中分别收录；妖妖梦三道中分为前半、中段、后半。
初始十条命，答题复活已禁用；生命耗尽时结算，可重开或返回标题并保存录像。

阶段强化三选一：左侧蓝色增加 Bomb 恢复，中间紫色增加火力，右侧黄色减小自机判定。
开局三枚 Bomb，上限九枚；恢复速度为100时每三十秒恢复一枚。按 X 消耗一枚释放 Bomb。
左上角显示三个属性及属性条，透明度50%；火力无上限，以自动扩展的对数刻度显示。
右上角使用红星显示生命、绿星显示 Bomb，恢复中的 Bomb 按扇形进度显示。
每进入第n阶段，敌方血量在当前基础上乘以(1+n/100)；左侧显示阶段号及累计倍率。
累计血量倍率使用完整数字，过长会换行；符卡名可在设置中切换中文和日文，默认中文。
强化选项保留下落接取演出，普通道具掉落关闭。
成就、联机、存档同步和续玩点系统暂时停用，F5/F9/F10 的相关入口关闭。
普通本地设置、成长记录及录像功能保留，旧十战录像仍按旧规则结束。

默认操作：方向键移动，Shift 低速，Z 射击/确认，X Bomb/返回，C 特殊，Esc 暂停。
准备界面可用 Enter 开始，也可使用鼠标；按键可在主菜单中调整。

本包不含玩家存档、录像、个人设置、运行日志、开发及构建缓存。
首次运行会在游戏目录建立本地数据，请解压到有写入权限的文件夹。
原有 User/ 和 replay/ 数据可自行保留；恢复续玩入口在当前版本停用。
引擎及依赖许可证见 licenses/。
'''

    if optimize:
        guide=guide.replace('完整离线包，含 LuaSTG Sub 引擎、脚本、音乐与素材。','精简离线包，含 LuaSTG Sub 引擎、脚本、音乐与素材。')
        guide+='\n本版修复铃仙停弹朝向、妖梦缓时与一念无量劫变白效果；新增Boss红白线段血圈，红弧为剩余血量、白弧为已扣血量。\n'
        guide+='\n精简范围：保留TH31–TH35及当前随机模式。已删除关卡的旧录像不在兼容范围，原录像文件不改写。\n核心图片无损；非核心适度压缩；音效压缩为Ogg，关卡脚本、资源尺寸和Alpha不变。\n'
    with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as archive:
        for relative,path in sorted(files.items()): archive.write(path,name+'/'+relative)
        archive.writestr(name+'/README.zh-CN.txt',guide)
        for relative,data in sorted(generated.items()):archive.writestr(name+'/'+relative,data)
    # 对全部成员做 CRC 和逐文件 SHA-256 校验，避免只检查文件名而漏掉素材。
    with zipfile.ZipFile(target) as archive:
        assert archive.testzip() is None,'Windows ZIP CRC 失败'
        for relative,path in files.items():
            assert hashlib.sha256(archive.read(name+'/'+relative)).digest()==hashlib.file_digest(path.open('rb'),'sha256').digest(),relative
        for relative,data in generated.items():assert archive.read(name+'/'+relative)==data,relative
        for source,actual in aliases.items():assert name+'/'+actual in archive.namelist(),source
        assert not any('/User/' in n or '/replay/' in n for n in archive.namelist())
    digest=hashlib.file_digest(target.open('rb'),'sha256').hexdigest()
    target.with_suffix('.zip.sha256').write_text(digest+'  '+target.name+'\n')
    if optimize:
        report={'file':target.name,'bytes':target.stat().st_size,'sha256':digest,'logical_images':len(image_records),
                'lossy_images':sum(r.get('lossy',False) for r in image_records.values()),'deduplicated_images':len(aliases),
                'converted_audio':sum(r['converted'] for r in audio_records.values()),'font_bitmaps_kept':sorted(font_bitmaps),
                'engine_sha256':hashlib.sha256(exe.read_bytes()).hexdigest(),'source_materials_changed':False}
        (out/(name+'-verification.json')).write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(f'Windows 完整包校验通过：{len(files)} 个文件，{target.stat().st_size/1024/1024:.1f} MiB；SHA-256 {digest}')
    return target

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--version',help='默认读取THlib/UI/UI.lua的ui.version')
    parser.add_argument('--game-root',type=Path,help='只从指定源码快照读取游戏脚本与素材')
    parser.add_argument('--engine-root',type=Path,default=ENGINE_ROOT,help='Windows 引擎、DLL 及其相邻许可证目录')
    parser.add_argument('--output-dir',type=Path,default=OUTPUT)
    parser.add_argument('--optimize-assets',action='store_true',help='复用核心无损/非核心压缩、Ogg音效及重复图片去重规则')
    args=parser.parse_args()
    if args.game_root: ROOT=args.game_root.resolve()
    ENGINE_ROOT=args.engine_root.resolve();OUTPUT=args.output_dir.resolve()
    package(args.version or game_version(ROOT),args.optimize_assets)
