#!/usr/bin/env python3
"""导出夏夜祭四机体的原始主炮、副武器与子机布局计算。"""
import argparse,hashlib,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--source',type=Path,required=True);ap.add_argument('--parser-lib',type=Path,required=True);ap.add_argument('--game',type=Path,required=True);args=ap.parse_args()
dest=ROOT/'mod/GAME/th40/native_players';dest.mkdir(parents=True,exist_ok=True)
files=[args.source/(kind+'_'+name+'.cs') for kind in ('MyPlane','SubPlane') for name in ('Reimu','Marisa','Sanae','Koishi')]
subprocess.run([sys.executable,str(Path(__file__).with_name('csharp_logic.py')),'--parser-lib',str(args.parser_lib),'--methods','Shoot,SubPlaneCtrl','--out',str(dest/'source.lua'),*map(str,files)],check=True)
records={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
for name in ('BaseSubPlane','BaseObject','BaseSpell','Spell_Reimu','Spell_Shinmyoumaru','Spell_PlaneB','Spell_Sanae','Spell_Koishi'):
 p=args.source/(name+'.cs');records[p.name]=hashlib.sha256(p.read_bytes()).hexdigest()
game=args.game
atlas={}
for name in ('Reimu','Marisa','Sanae','Koishi'):
 path=game/'Image/MyPlane'/(name+'.txt')
 records['Image/MyPlane/'+path.name]=hashlib.sha256(path.read_bytes()).hexdigest()
 for line in path.read_text(encoding='utf-8-sig').splitlines():
  key,*values=line.split()
  if len(values)==6:atlas[key]=[name,*map(int,values)]
(dest/'atlas.lua').write_text('-- 原作 MyPlane 图集切片、中心点偏移。\nreturn {'+','.join('['+json.dumps(k)+']={'+json.dumps(v[0])+','+','.join(map(str,v[1:]))+'}' for k,v in atlas.items())+'}\n')

(dest/'sources.json').write_text(json.dumps(records,ensure_ascii=False,indent=2)+'\n')
