#!/usr/bin/env python3
"""从已提取的栖霞园发行版导出自机原脚本与原始素材，保存来源摘要。"""
import argparse, hashlib, json, shutil
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--scripts',type=Path,required=True)
ap.add_argument('--assets',type=Path,required=True)
args=ap.parse_args()
dest=ROOT/'mod/GAME/th43/native_players'
dest.mkdir(parents=True,exist_ok=True)
records={}
def write(path,data,source):
    path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
    records[str(path.relative_to(ROOT))]={'source':source,'sha256':hashlib.sha256(data).hexdigest()}
for rel in ['equip_system.lua',*[f'{n}/{f}.lua' for n in ('reimu','marisa','sakuya') for f in (n,'equip')]]:
    src=args.scripts/'EISlib/player'/rel
    write(dest/rel,src.read_bytes(),'data:EISlib/player/'+rel)
src=args.scripts/'EISlib/system/PowerRank.lua'
write(dest/'PowerRank.lua',src.read_bytes(),'data:EISlib/system/PowerRank.lua')
text=(args.scripts/'EISlib/system/spellcard.lua').read_text()
text='local SC=system.spellcard\n'+text[text.index('local SCA = {}'):text.index('--region spellcard bonus')]
write(dest/'auxiliary.lua',text.encode(),'data:EISlib/system/spellcard.lua')
# 资源加载函数与暗幕类保持连续原文；自机基础生命周期由宿主接管。
for source,start,end,out,prefix,suffix in (
    ('playerclass.lua','function M.loadRes','--region player class','resources.lua','local M=EISlib.Player\n',''),
    ('component.lua','local darkmask =','--region Move','darkmask.lua','local M={}\nlocal inter=source_interpolation\n','\nreturn M.DarkMask\n')):
    text=(args.scripts/'EISlib/player'/source).read_text()
    text=text[text.index(start):text.index(end)]
    write(dest/out,(prefix+text+suffix).encode(),'data:EISlib/player/'+source)
text=(args.scripts/'EISlib/effect/effect_item.lua').read_text()
head=text[text.index('local text_move_v ='):text.index('local text_size_1 =')]
piece=text[text.index('local float_dec_bomb ='):]
piece='local defaultRenderAni=EGGlib.RenderEffect.defaultRenderAni\n'+head+piece
write(dest/'bomb_effect.lua',piece.encode(),'data:EISlib/effect/effect_item.lua')
for src in sorted((args.assets/'res/player').rglob('*')):
    if src.is_file():
        rel=src.relative_to(args.assets/'res')
        write(ROOT/'Resources/th43'/rel,src.read_bytes(),'player.res:res/'+str(rel))
(dest/'sources.json').write_text(json.dumps(records,ensure_ascii=False,indent=2)+'\n')
print('已导出',len(records),'份原作文件')
