#!/usr/bin/env python3
"""把夏夜祭 MBG 离线编译为原生 Lua 回调；游戏不解析 MBG/中文事件。"""
import argparse,hashlib,json,re,shutil,subprocess,wave,struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser();p.add_argument('--game',type=Path,required=True);p.add_argument('--source',type=Path,required=True);p.add_argument('--media',action='store_true');a=p.parse_args()
OUT=ROOT/'mod/GAME/th40';ASSET=ROOT/'Resources/th40';OUT.mkdir(exist_ok=True);ASSET.mkdir(exist_ok=True)
q=lambda s:json.dumps(str(s),ensure_ascii=False)
def lua(v):
 if v is None:return 'nil'
 if isinstance(v,bool):return str(v).lower()
 if isinstance(v,(float,int)):return repr(v)
 if isinstance(v,str):return q(v)
 if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
 return '{'+','.join('['+q(k)+']='+lua(x) for k,x in v.items())+'}'
def num(x):return float(x) if '.' in x or 'e' in x.lower() else int(x)
def point(x):return [float(v) for v in re.findall(r'[XY]:([^ }]+)',x)]
def block(s,pos):
 start=s.index('{',pos);depth=1;i=start+1;quoted=False;escape=False
 while depth:
  c=s[i]
  if quoted:
   if escape:escape=False
   elif c=='\\':escape=True
   elif c=='"':quoted=False
  elif c=='"':quoted=True
  elif c=='{':depth+=1
  elif c=='}':depth-=1
  i+=1
 return s[start+1:i-1],i
E=['cx','cy','radius','radius_angle','ways','cycle','emit_angle','spread','speed','direction','accel','accel_angle','p.life','p.type','p.width','p.height','p.red','p.green','p.blue','p.alpha','p.angle','p.speed','p.direction','p.accel','p.accel_angle','p.scale_x','p.scale_y','p.mist','p.dispel','p.blend','p.ghost','p.out','p.invincible']
B=['life','type','width','height','red','green','blue','alpha','angle','speed','direction','accel','accel_angle','scale_x','scale_y','mist','dispel','blend','ghost','out','invincible']
EN=['X坐标','Y坐标','半径','半径方向','条数','周期','角度','范围','速度','速度方向','加速度','加速度方向','生命','类型','宽比','高比','R','G','B','不透明度','朝向','子弹速度','子弹速度方向','子弹加速度','子弹加速度方向','横比','纵比','雾化效果','消除效果','高光效果','拖影效果','出屏即消','无敌状态']
BN=['生命','类型','宽比','高比','R','G','B','不透明度','朝向','子弹速度','子弹速度方向','子弹加速度','子弹加速度方向','横比','纵比','雾化效果','消除效果','高光效果','拖影效果','出屏即消','无敌状态']
COND={'当前帧':'t','X坐标':'o.cx','Y坐标':'o.cy','半径':'o.radius','半径方向':'o.radius_angle','条数':'o.ways','周期':'o.cycle','角度':'o.emit_angle','范围':'o.spread','宽比':'o.p.width','高比':'o.p.height','不透明度':'o.p.alpha','朝向':'o.p.angle'}
event_count=0;ignored=[]
def compile_events(text,emitter,origin):
 global event_count
 if not text:return 'nil'
 code=['function(o,t,N)'];keys=EN if emitter else BN;fields=E if emitter else B
 for gi,group in enumerate(text.split('&')):
  if not group:continue
  tag,period,delta,body=group.split('|',3);period=max(1,int(period));delta=int(delta)
  code+=['o.loops[%d]=o.loops[%d] or 0'%(gi,gi), 'if (%s)%%%d==0 then o.loops[%d]=o.loops[%d]+1 end'%('t' if emitter else 't+1',period,gi,gi)]
  shift='o.loops[%d]*%d'%(gi,delta)
  for ei,event in enumerate(body.split(';')):
   if not event:continue
   event_count+=1;left,right=event.split('：',1);parts=re.split('(且|或)',left)
   conds=[re.fullmatch(r'(.+?)([<>=])(.+)',parts[j]) for j in range(0,len(parts),2)]
   if not all(conds):raise ValueError((origin,event))
   # 原程序将第二条件的类型也绑定到第一个条件的属性，保留该语义。
   first=conds[0][1];expressions=[f'{COND[first]} {"==" if c[2]=="=" else c[2]} ({float(c[3])}+{shift})' for c in conds]
   condition=(' and ' if len(parts)>1 and parts[1]=='且' else ' or ').join('('+s+')' for s in expressions)
   if right=='额外发射':action='N.emit(o)'
   elif right.startswith('恢复') or right.startswith('范围移动'):
    ignored.append({'file':origin,'event':event});continue
   else:
    m=re.fullmatch(r'(.+?)(变化到|增加|减少)([^，]+)，(正比|固定|正弦)，(\d+)帧?(?:\((\d+)\))?',right)
    if not m:raise ValueError((origin,event))
    name,change,value,curve,duration,limit=m.groups();field=fields[keys.index(name)]
    base,*random=value.split('+');base=base.strip();rnd=float(random[0]) if random else 0
    if base=='自机':
     if emitter and field=='cx':amount='N.player_x()'
     elif emitter and field=='cy':amount='N.player_y()'
     else:amount='N.aim(o)'
    elif base=='自身':
     amount='o.cx-4' if emitter and field=='cx' else 'o.cy+16' if emitter and field=='cy' else 'N.self_angle(o)'
    else:amount=repr(float(base))
    if rnd:amount='('+amount+')+'+repr(rnd)+'*N.pm(o.run)'
    owner,key=('o.p',field[2:]) if field.startswith('p.') else ('o',field)
    signature=gi*10000+ei;count=int(limit or 0)
    initial=',o.p.height' if field=='p.width' else ''
    action=f'N.tween(o,{owner},{q(key)},{amount},{["变化到","增加","减少"].index(change)},{["正比","固定","正弦"].index(curve)},{int(duration)}{initial})'
    if count:action=f'if (o.once[{signature}] or 0)<{count} then o.once[{signature}]=(o.once[{signature}] or 0)+1;{action} end'
   code+=['if '+condition+' then '+action+' end']
 code+=['end'];return '\n'.join(code)
def record(row,kind,origin):
 s=row.split(',');get=lambda i,default=0:num(s[i]) if i<len(s) and s[i] else default
 boolean=lambda i:i<len(s) and s[i]=='True'
 r={}
 if kind!='cover':
  r={'id':get(0),'layer':get(1),'bind':get(3,-1),'with_direction':boolean(4),'cx':get(6),'cy':get(7),'start':get(8),'duration':get(9),'mode':kind}
 if kind=='cover':
  r={'id':get(0),'layer':get(1),'bind':get(23,-1),'cx':get(2),'cy':get(3),'start':get(4),'duration':get(5),'mode':'cover','width':get(6),'height':get(7),'round':boolean(8),'type':get(9),'control_id':get(10),'speed':get(11),'direction':get(12),'accel':get(14),'accel_angle':get(15),'deep':boolean(24),'p':{}}
  return r,compile_events(s[17],True,origin),compile_events(s[18],False,origin)
 laser=kind=='laser';off=2 if laser else 0
 if laser:
  r.update(radius=get(10),radius_angle=get(11),ways=get(13),cycle=get(14),emit_angle=get(15),spread=get(17),speed=get(18),direction=get(19),accel=get(21),accel_angle=get(22),deep=boolean(58),motion=boolean(60),head=boolean(62))
  r['mode']='ray' if boolean(29) else 'bend' if boolean(61) else 'laser'
  p={'life':get(24),'type':get(25),'width':1,'height':get(26),'length':get(27),'alpha':int(get(28)*255/100),'angle':0,'speed':get(30),'direction':get(31),'accel':get(33),'accel_angle':get(34),'scale_x':1,'scale_y':1,'mist':False,'dispel':True,'blend':boolean(38),'ghost':False,'out':True,'invincible':boolean(40),'red':255,'green':255,'blue':255,'reflect':get(59)}
  if r['mode']=='ray':p.update(width=get(27)/256,height=.2,max_width=get(27)/256,max_height=1)
  for j,k in enumerate(['radius','radius_angle','ways','cycle','emit_angle','spread','speed','direction','accel','accel_angle','p.speed','p.direction','p.accel','p.accel_angle']):r.setdefault('random',{})[k]=get(44+j)
  e,b=s[42],s[43]
 else:
  r.update(fx=get(10),fy=get(11),radius=get(12),radius_angle=get(13),ways=get(15),cycle=get(16),emit_angle=get(17),spread=get(19),speed=get(20),direction=get(21),accel=get(23),accel_angle=get(24),deep=boolean(73),motion=boolean(74),sound=s[76] if len(s)>76 else '',specify_sound=boolean(77),count=max(1,get(94,1)),delta_v=get(95),radius_follows=len(s)>110 and get(96)!=0,effect=get(91))
  p={'life':get(26),'type':get(27),'width':get(28),'height':get(29),'red':get(30),'green':get(31),'blue':get(32),'alpha':min(255,int(get(33)*255/100)),'angle':get(34)+180,'follow':boolean(36),'speed':get(37),'direction':get(38),'accel':get(40),'accel_angle':get(41),'scale_x':get(43),'scale_y':get(44),'mist':boolean(45),'dispel':boolean(46),'blend':boolean(47),'ghost':boolean(48),'out':boolean(49),'invincible':boolean(50),'reflect':get(75),'region':get(79)}
  p['cover']=boolean(70)
  if boolean(81):
   r['mode']='enemy';p.update(enemy=s[82],hp=get(83),red_drop=get(84),blue_drop=get(85),enemy_color=get(86),backfire=boolean(87),clear_radius=get(88),green_drop=get(89),star_drop=get(90))
  elif get(91)>0:r['mode']='effect';p['texture']=s[92]
  for j,k in enumerate(['x','y','radius','radius_angle','ways','cycle','emit_angle','spread','speed','direction','accel','accel_angle','p.angle','p.speed','p.direction','p.accel','p.accel_angle']):r.setdefault('random',{})[k]=get(53+j)
  e,b=s[51],s[52]
 r['p']=p
 return r,compile_events(e,True,origin),compile_events(b,False,origin)
patterns={};hashes={}
for path in sorted((a.game/'CS').rglob('*.mbg')):
 rel=str(path.relative_to(a.game/'CS'));lines=iter(path.read_text(encoding='utf-8-sig').splitlines());assert next(lines)=='Crazy Storm Data 1.01'
 total=0;records=[]
 for line in lines:
  if line.startswith('Totalframe:'):total=int(line.split(':')[1])
  if re.match(r'Layer\d+:',line) and not line.endswith('empty'):
   header=line.split(':',1)[1].split(',')
   for i,kind in enumerate(['bullet','laser','cover','rebound','force']):
    count=int(header[3+i]) if len(header)>3+i else 0
    for _ in range(count):
     row=next(lines)
     if kind in ['rebound','force']:continue # 原CS_Data也只跳过这两种记录。
     data,emitter,child=record(row,kind,rel);records.append((data,emitter,child))
 key=hashlib.sha256(rel.encode()).hexdigest()[:16];patterns[rel]=key;hashes[rel]=hashlib.sha256(path.read_bytes()).hexdigest()
 output=['-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。','local T={total='+str(total)+',emitters={}}']
 for i,(data,ev,ch) in enumerate(records,1):output+=['T.emitters[%d]=%s'%(i,lua(data)),'T.emitters[%d].events=%s'%(i,ev),'T.emitters[%d].p.events=%s'%(i,ch)]
 output+=['return T'];(OUT/('p_'+key+'.lua')).write_text('\n'.join(output)+'\n')
(OUT/'patterns.lua').write_text('-- 路径只用于离线来源追踪；值为已编译Lua模块。\nreturn '+lua(patterns)+'\n')
(OUT/'source_manifest.json').write_text(json.dumps({'exe_sha256':hashlib.sha256((a.game/'THSSS.exe').read_bytes()).hexdigest(),'patterns':hashes,'event_count':event_count,'source_noops':ignored},ensure_ascii=False,indent=2)+'\n')
# 导出原图切片，保持图集坐标；所有资源名前缀隔离，避免覆盖现有关卡。
atlas=[]
for folder in ['Bullet','Boss','Enemy','Effect','Background']:
 for path in sorted((a.game/'Image'/folder).rglob('*.txt')):
  image=path.with_suffix('.png')
  if not image.exists():continue
  target=ASSET/folder/str(image.relative_to(a.game/'Image'/folder));target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(image,target)
  raw=path.read_bytes()
  try:text=raw.decode('utf-8-sig')
  except UnicodeDecodeError:text=raw.decode('gb18030')
  for line in text.splitlines():
   cells=line.split()
   if len(cells)>=5:
    try:atlas.append([cells[0],str(target.relative_to(ROOT)),*[int(x) for x in cells[1:5]]])
    except ValueError:pass
known={row[0] for row in atlas}
for folder in ['Bullet','Boss','Enemy','Effect','Background']:
 for image in sorted((a.game/'Image'/folder).rglob('*.png')):
  target=ASSET/folder/str(image.relative_to(a.game/'Image'/folder));target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(image,target)
  if image.stem not in known:
   width,height=struct.unpack('>II',image.read_bytes()[16:24]);atlas.append([image.stem,str(target.relative_to(ROOT)),0,0,width,height]);known.add(image.stem)
(OUT/'atlas.lua').write_text('-- 原作图集切片参数。\nreturn '+lua(atlas)+'\n')
bullet_source=(a.source/'BaseBullet_CS.cs').read_text()
names=re.search(r'string\[\] BulletName = new string\[\d+\]\s*\{([^}]+)\}',bullet_source)[1]
entries=re.findall(r'null|"[^"\n]*"',names);assert len(entries)==229
(OUT/'bullet_names.lua').write_text('-- 原BaseBullet_CS.Type的纹理索引；0保留为空。\nreturn {'+','.join('['+str(i)+']='+s for i,s in enumerate(entries) if s!='null')+'}\n')
print(json.dumps({'patterns':len(patterns),'events':event_count,'atlas':len(atlas),'source_noops':len(ignored)},ensure_ascii=False))
