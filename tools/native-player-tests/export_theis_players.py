#!/usr/bin/env python3
"""导出祈华梦原始自机类，仅隔离资源标识符。"""
import argparse,hashlib,json,re,shutil
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source',type=Path,required=True);a=p.parse_args()
out=ROOT/'mod/GAME/ports/theis/native_players';out.mkdir(exist_ok=True);hashes={}
for name in ['reimu','marisa','mokou']:
 path=a.source/'EISlib/player'/(name+'.lua');raw=path.read_bytes();text=raw.decode('utf-8-sig')
 resources=set(re.findall(r'(?:LoadTexture|LoadImage|LoadAnimation|LoadImageGroup|LoadImageFromFile)\(\s*[\'\"]([^\'\"]+)',text))
 # 构造器、SetImageState 与图组前缀中的资源名称也一起替换。
 for key in sorted(resources,key=len,reverse=True):
  for quote in ["'",'"']:text=text.replace(quote+key+quote,quote+'native_theis_'+key+quote)
 # 统一文本换行，去除原文件行尾空白；不改变 Lua 表达式。
 text='\n'.join(line.rstrip() for line in text.splitlines())+'\n'
 (out/(name+'.lua')).write_text('-- 原作自机，仅隔离资源名称以免与其他作品冲突。\n'+text)
 hashes[str(path.relative_to(a.source))]=hashlib.sha256(raw).hexdigest()
 assetroot=a.source.parent/'stage/res/player'/name
 destination=ROOT/'Resources/ports/theis/res/player'/name;destination.mkdir(exist_ok=True)
 for asset in assetroot.glob('*.png'):
  shutil.copy2(asset,destination/asset.name)
  hashes['stage/res/player/'+name+'/'+asset.name]=hashlib.sha256(asset.read_bytes()).hexdigest()
(out/'sources.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n')
