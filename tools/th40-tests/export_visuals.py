#!/usr/bin/env python3
"""从夏夜祭构造函数导出符卡背景/立绘原参数，不用通用滚动背景替代。"""
import argparse, hashlib, json, re, shutil
from pathlib import Path
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--source',type=Path,required=True);ap.add_argument('--game',type=Path,required=True);args=ap.parse_args()
source=args.source;game=args.game;hashes={}
def read(path):
 b=path.read_bytes();hashes[str(path.relative_to(source))]=hashlib.sha256(b).hexdigest();return b.decode('utf-8-sig')
def lua(v):
 if v is None:return 'nil'
 if isinstance(v,bool):return str(v).lower()
 if isinstance(v,(int,float)):return repr(v)
 if isinstance(v,str):return json.dumps(v,ensure_ascii=False)
 if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
 return '{'+','.join('['+lua(k)+']='+lua(x) for k,x in v.items())+'}'
def body(s,pos):
 start=s.index('{',pos);depth=1;i=start+1
 while depth:
  if s[i]=='{':depth+=1
  elif s[i]=='}':depth-=1
  i+=1
 return s[start+1:i-1]
def number(v):
 v=v.strip()
 if v in ('true','false'):return v=='true'
 v=v.removesuffix('f')
 return float(v)
pattern=re.compile(r'new (Background\w+)\(StageData(?:, "([^"]+)")?\)')
def backgrounds(s):
 result=[];matches=list(pattern.finditer(s))
 for i,m in enumerate(matches):
  cls,name=m.groups();tail=s[m.end():matches[i+1].start() if i+1<len(matches) else len(s)]
  if cls=='BackgroundBoss06':result.append(dict(kind='tensei'));continue
  if cls in ('BackgroundBoss04','BackgroundBoss05','BackgroundBossEx'):
   ss=read(source/(cls+'.cs'));result+=backgrounds(body(ss,ss.index('public '+cls+'(')));continue
  assert name and cls in ('BackgroundRotate','BackgroundMove2','BackgroundSC'),(cls,name)
  fields={}
  if tail.lstrip().startswith('{'):
   for key,value in re.findall(r'(\w+) = ([^,\n]+)',body(tail,0)):
    fields[key]=number(value)
  part=dict(kind=cls,name=name,fields=fields)
  ev=re.search(r'当前帧=1：不透明度变化到([\d.]+)，正弦，(\d+)',tail)
  if ev:
   period=re.search(r'\bt = (\d+)',tail)
   part['alphaEvent']=[float(ev[1]),int(ev[2]),int(period[1]) if period else 200]
  result.append(part)
 return result
configs={};needed={'SpellCircle06'}
for path in sorted(source.glob('SpellCard_SSS*.cs')):
 s=read(path);ctor=body(s,s.index('public '+path.stem+'('));layers=backgrounds(ctor)
 pics=[]
 for m in re.finditer(r'new (FullPic\d*)\(StageData, "([^"]+)"\)',ctor):
  tail=ctor[m.end():];scale=1
  if tail.lstrip().startswith('{'):
   match=re.search(r'\bScale = ([\d.]+)',body(tail,0))
   if match:scale=float(match[1])
  pics.append(dict(kind=m[1],name=m[2],scale=scale));needed.add(m[2])
 needed.update(p['name'] for p in layers if 'name' in p)
 configs[path.stem]=dict(backgrounds=layers,portraits=pics)
# 仅导出符卡用的立绘；原图切片已由atlas.lua加载，补记原作旋转中心偏移。
assets={};centers={};regions={};images=game/'Image'
for txt in images.rglob('*.txt'):
 try:s=txt.read_text(encoding='utf-8-sig')
 except UnicodeError:s=txt.read_text(encoding='gb18030')
 for row in s.splitlines():
  values=row.split()
  if len(values)>=7:
   try:
    centers[values[0]]=[int(values[3])/2+int(values[5]),int(values[4])/2+int(values[6])]
    regions[values[0]]=[txt.with_suffix('.png'),*[int(x) for x in values[1:5]]]
   except ValueError:pass
for name in sorted(needed):
 if not name.startswith('Face'):continue
 region=regions.get(name)
 if region:
  pic,x,y,w,h=region
  with Image.open(pic) as im:cropped=im.crop((x,y,x+w,y+h))
 else:
  pic=next(images.rglob(name+'.png'))
  with Image.open(pic) as im:cropped=im.copy();w,h=im.size
 dest=ROOT/'Resources/th40/Face'/(name+'.png');dest.parent.mkdir(exist_ok=True);cropped.save(dest)
 assets[name]=dict(file=str(dest.relative_to(ROOT)),w=w,h=h)
for n in ['FullPic2','FullPic3','BaseBossTouhou','BackgroundMove2','BackgroundRotate','BackgroundSC','BackgroundBoss06','SpellCardAttack']:
 read(source/(n+'.cs'))
(ROOT/'mod/GAME/th40/visuals.lua').write_text('-- 原作构造函数离线参数，背景不拉伸、不虚构滚动速度。\nreturn '+lua(dict(configs=configs,assets=assets,centers=centers))+'\n')
(ROOT/'mod/GAME/th40/visual_sources.json').write_text(json.dumps(dict(configs=len(configs),portraits=len(assets),sha256=hashes),ensure_ascii=False,indent=2)+'\n')
print(len(configs),'spell configurations,',len(assets),'portrait resources')
