#!/usr/bin/env python3
"""从雪莲华发行数据和重建工程离线展开原生LuaSTG数据；不启动Unity，不修改来源。"""
import argparse, collections, functools, hashlib, json, re, shutil, struct
from pathlib import Path
import yaml
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('source',type=Path);a=p.parse_args();SRC=a.source.resolve()
OUT=ROOT/'mod/GAME/th38';ASSET=ROOT/'Resources/th38';OUT.mkdir(exist_ok=True);ASSET.mkdir(exist_ok=True)
hashes={}
def read(p):
 b=p.read_bytes();hashes[p.relative_to(SRC).as_posix()]=hashlib.sha256(b).hexdigest();return b.decode('utf-8-sig')
def lua(v):
 if v is None:return 'nil'
 if isinstance(v,bool):return str(v).lower()
 if isinstance(v,(int,float)):return str(int(v)) if int(v)==v else repr(v)
 if isinstance(v,str):return json.dumps(v,ensure_ascii=False)
 if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
 return '{'+','.join('['+lua(k)+']='+lua(x) for k,x in v.items())+'}'
def dump(path,data):path.write_text('-- 离线生成，修改生成器后重建；来源SHA见sources.json。\nreturn '+lua(data)+'\n')
def ints(v):
 if not v:return []
 return list(struct.unpack('<'+'i'*(len(v)//8),bytes.fromhex(v)))
# 字段名直接对应Basic.cs，导出时保留原始数值单位，运行时没有文本读取/解析。
GUID={}
for pat in ['Scripts/**/*.meta','Resources/xuelianhua/prefab/**/*.meta']:
 for p in (SRC/'Assets').glob(pat):
  m=re.search(r'^guid: (\w+)',p.read_text(errors='replace'),re.M)
  if m:GUID[m[1]]=p.with_suffix('')
wanted=['Boss_creat','Boss_in','Bossmove','Zairustage1','LSC_6','Boss_zhuanjieduan']
scriptids={g:Path(f).stem for g,f in GUID.items() if Path(f).stem in wanted}
@functools.lru_cache(None)
def docs(p):
 out=[]
 for s in re.split(r'^--- !u!\d+ &[-\d]+.*$',read(p),flags=re.M)[1:]:
  if not any(g in s for g in scriptids):continue
  d=yaml.load(s,Loader=yaml.BaseLoader).get('MonoBehaviour')
  if d:
   d['_script']=scriptids.get(d.get('m_Script',{}).get('guid'));out.append(d)
 return out
cardnames={int(i):json.loads('"'+s+'"').strip() for i,s in re.findall(r'Sincos.cardname\[(\d+)\] = "([^"\n]+)"',read(SRC/'Assets/Scripts/Gameloading.cs'))}
patterns={};statistics=collections.Counter();missing=[]
for difficulty in ['L','EXA']:
 base=SRC/'THasl/xuelianhua/danmaku'/difficulty
 for folder in sorted(x for x in base.rglob('*') if x.is_dir()):
  files=sorted(folder.glob('*.txt'))
  if not files:continue
  key=folder.relative_to(SRC/'THasl/xuelianhua/danmaku').as_posix();items=[]
  for file in files:
   lines=read(file).splitlines()
   def row(n):return [x.strip() for x in (lines[n-1] if n<=len(lines) else '').split(',')]
   def number(s):return float(s) if s else 0
   raw={f'a{n}_{i+1}':number(x) for n in [2,3,4,5,6,7,8,9,48,49,50,51,52,53,54] for i,x in enumerate(row(n)) if not(n==6 and i==1)}
   raw['a47']=int(number(row(47)[0]));raw['custom']=row(6)[1] if len(row(6))>1 else ''
   def events(start,count,repeat,period,random):
    out=[]
    for i in range(count):
     at=lambda n:number(row(n)[i]) if i<len(row(n)) else 0
     out.append([at(n) for n in range(start,start+13)]+[at(repeat),max(1,at(period)),at(random)])
    return out
   counts=list(map(lambda x:int(number(x)),row(12)))
   raw['events']=events(14,counts[0],27,28,46)
   raw['sonEvents']=events(30,counts[1] if len(counts)>1 else 0,43,44,45)
   nr=int(number(row(10)[0]));names=row(11);kinds=row(10)
   raw['links']=[{'name':names[i+1],'kind':int(kinds[i+1])} for i in range(nr)]
   raw['name']=file.name
   items.append(raw);statistics['scripts']+=1;statistics['events']+=len(raw['events'])+len(raw['sonEvents']);statistics['kind_'+str(raw['a47'])]+=1
  known={x['name'] for x in items}
  for x in items:
   for link in x['links']:
    if link['name'] not in known:missing.append(key+'/'+x['name']+' -> '+link['name'])
  patterns[key]={'key':key,'items':items}
  target=OUT/'patterns'/f'{key.replace("/","_")}.lua';dump(target,patterns[key])
# 从场景的Boss_creat、Boss_in和Bossmove逐项取顺序；不能用目录名猜出卡链。
chapters=[];uid=38000;extras=[]
def canonical(s):return re.sub('/+','/',s or '').removeprefix('xuelianhua/danmaku/')
def phases(prefab,role):
 global uid
 records=docs(prefab);inside=next((x for x in records if x['_script']=='Boss_in'),None);moving=next((x for x in records if x['_script']=='Bossmove' and x.get('double_boss2')!='1'),None)
 if not inside or not moving:return []
 rows=[(inside['path'],int(inside['leixing']),int(inside['fuka_num']))]
 rows+=list(zip(moving['path'],ints(moving['danmu_leixing']),ints(moving['fuka_num'])))
 out=[]
 for path,kind,name in rows:
  key=canonical(path)
  if not key:continue
  if key not in patterns:missing.append('阶段路径缺失：'+key);continue
  bosses=[b for b in patterns[key]['items'] if b['a47']==2]
  if not bosses:missing.append('Boss参数缺失：'+key);continue
  uid+=1
  out.append({'id':uid,'key':key,'title':cardnames.get(name,'') if kind else '非符 '+key.rsplit('/',1)[-1], 'spell':kind!=0,'endurance':kind==2,'role':role,'hp':sum(max(1,b['a6_6']) for b in bosses),'ticks':max(b['a2_8'] for b in bosses),'immune':max(b['a51_3'] for b in bosses)})
 for d in records:
  if d['_script']=='Boss_zhuanjieduan':
   index=int(d['number'])-1
   if index<len(out):
    out[index]['transitions']=[{'hp':hp,'time':time,'key':canonical(path),'reset':int(d.get('if_timeclean','')[i*2:i*2+2] or '0',16)!=0,'clear':int(d.get('if_xiaodan','')[i*2:i*2+2] or '0',16)!=0} for i,(hp,time,path) in enumerate(zip(ints(d['life_zhuanhuan']),ints(d['time_zhuanhuan']),d['path']))]
 lsc=GUID.get(moving.get('Boss_LSC',{}).get('guid'))
 if lsc:
  for d in docs(lsc):
   if d['_script']=='LSC_6':
    last=GUID.get(d.get('boss',{}).get('guid'))
    if last:extras.extend(phases(last,'lastspell'))
 return out
for name in ['1','2','3','4','5','6','EXA']:
 recs=docs(SRC/'Assets/Scene'/('Stage'+name+'.unity'));road=next(x for x in recs if x['_script']=='Zairustage1')
 difficulty='EXA' if name=='EXA' else 'L'
 chapter={'name':name,'roads':[],'bosses':[]}
 spawns=sorted([x for x in recs if x['_script']=='Boss_creat'],key=lambda x:int(x['time_in']))
 roadkeys=[difficulty+'/'+road['path']]+[difficulty+'/'+s for s in road['houban_path']]
 starts=[0]+ints(road['houban_time'])
 for i,x in enumerate(spawns):
  prefab=GUID.get(x.get('boss_EXA' if name=='EXA' else 'boss_L',{}).get('guid'))
  if not prefab:continue
  seq=phases(prefab,'mid' if i==0 and len(spawns)>1 and name!='4' else 'boss')
  if not seq:continue
  chapter['bosses'].append({'time':int(x['time_in']),'cards':seq,'source':str(prefab.relative_to(SRC))})
  if x.get('if_boss_B')=='1':
   other=x.get('boss_B',[])
   if len(other)>3:
    pf=GUID.get(other[3].get('guid'))
    if pf:extras.extend(phases(pf,'alternate'))
 for i,key in enumerate(roadkeys):
  key=canonical(key)
  if key not in patterns:missing.append('道中路径缺失：'+key);continue
  start=starts[i];end=chapter['bosses'][i]['time'] if i<len(chapter['bosses']) else start
  if end<=start:continue
  uid+=1;chapter['roads'].append({'id':uid,'key':key,'first':start,'last':end,'role':'road'})
 chapters.append(chapter)
# 原始弹图切片使用重建纹理的数值后缀顺序；记录每片矩形，避免Unity内部ID排序污染。
bullet=SRC/'Assets/Resources/xuelianhua/image/Bullet/bullet.png'
meta=yaml.safe_load(read(Path(str(bullet)+'.meta')))['TextureImporter'];h=Image.open(bullet).height
shutil.copyfile(bullet,ASSET/'bullet.png')
hashes[bullet.relative_to(SRC).as_posix()]=hashlib.sha256(bullet.read_bytes()).hexdigest()
sprites={}
for s in meta['spriteSheet']['sprites']:
 n=int(s['name'].rsplit('_',1)[-1]);r=s['rect'];sprites[n]=[r['x'],h-r['y']-r['height'],r['width'],r['height']]
customs={}
for item in [b for pat in patterns.values() for b in pat['items']]:
 if not item.get('custom'):continue
 path=SRC/'Assets/Resources/xuelianhua/image/Bullet/zidingyi'/item['custom'].replace('\\','/').rsplit('/',1)[-1]
 if not path.suffix:path=path.with_suffix('.png')
 if path.exists():
  dst='custom'+str(len(customs))+'.png' if item['custom'] not in customs else customs[item['custom']]['file']
  w,h=Image.open(path).size;customs[item['custom']]={'file':dst,'w':w,'h':h};shutil.copyfile(path,ASSET/dst);hashes[path.relative_to(SRC).as_posix()]=hashlib.sha256(path.read_bytes()).hexdigest()
 else:missing.append('自定义图缺失：'+str(path.relative_to(SRC)))
for script in ['Basic','Basic_zi','Bulletmove','Enemymove','Bossmove','Boss_in','Boss_creat','Zairustage1','Sincos','Centeryidong','LSC_6','Boss_zhuanjieduan','Laser_move_zhi','Laser_move_line','Laser_move_wan']:
 f=SRC/'Assets/Scripts'/f'{script}.cs'
 if f.exists():read(f)
dump(OUT/'catalogue.lua',{'chapters':chapters,'extra':extras,'sprites':sprites,'customs':customs,'keys':sorted(patterns)})
report={'title':'东方雪莲华 ～ Abyss Soul Lotus.','difficulty':['L','EXA'],'statistics':dict(statistics),'chapters':len(chapters),'combat':sum(len(g['cards']) for c in chapters for g in c['bosses']),'roads':sum(len(c['roads']) for c in chapters),'extra':len(extras),'missing':sorted(set(missing)),'sha256':dict(sorted(hashes.items()))}
(OUT/'sources.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items() if k!='sha256'},ensure_ascii=False,indent=2))
