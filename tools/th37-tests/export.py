#!/usr/bin/env python3
"""从本地梦华祭二工程离线展开原生Lua；游戏不读取XNA、C#或事件字符串。"""
from __future__ import annotations
import argparse, collections, hashlib, json, re
from pathlib import Path
from Crypto.Cipher import DES3
ROOT=Path(__file__).resolve().parents[2]
KEYS=[bytes.fromhex('CA90D8D3BCD6F4B4AEC2BC652816BDB7'),None,bytes.fromhex('4D3C3F50123A4577898C758F7E9E1187')]
PROPS={'当前帧':'time','X坐标':'fx','Y坐标':'fy','半径':'r','半径方向':'rdirection','条数':'tiao','周期':'t','角度':'fdirection','范围':'range','速度':'speed','速度方向':'speedd','加速度':'aspeed','加速度方向':'aspeedd','生命':'life','类型':'type','宽比':'wscale','高比':'hscale','长度':'longs','R':'colorR','G':'colorG','B':'colorB','不透明度':'alpha','朝向':'head','子弹速度':'sonspeed','子弹速度方向':'sonspeedd','子弹加速度':'sonaspeed','子弹加速度方向':'sonaspeedd','横比':'xscale','纵比':'yscale','雾化效果':'Mist','消除效果':'Dispel','高光效果':'Blend','拖影效果':'Afterimage','出屏即消':'Outdispel','无敌状态':'Invincible','半宽':'halfw','半高':'halfh','ID':'id'}
BATCH='id parentid Binding bindid Bindwithspeedd unused x y begin life fx fy r rdirection rdirections tiao t fdirection fdirections range speed speedd speedds aspeed aspeedd aspeedds sonlife type wscale hscale colorR colorG colorB alpha head heads Withspeedd sonspeed sonspeedd sonspeedds sonaspeed sonaspeedd sonaspeedds xscale yscale Mist Dispel Blend Afterimage Outdispel Invincible Parentevents Sonevents'.split()
RAND_BATCH='fx fy r rdirection tiao t fdirection range speed speedd aspeed aspeedd head sonspeed sonspeedd sonaspeed sonaspeedd'.split()
LASE='id parentid Binding bindid Bindwithspeedd unused x y begin life r rdirection rdirections tiao t fdirection fdirections range speed speedd speedds aspeed aspeedd aspeedds sonlife type wscale longs alpha Ray sonspeed sonspeedd sonspeedds sonaspeed sonaspeedd sonaspeedds xscale yscale Blend Outdispel Invincible unused Parentevents Sonevents'.split()
RAND_LASE='r rdirection tiao t fdirection range speed speedd aspeed aspeedd sonspeed sonspeedd sonaspeed sonaspeedd'.split()
COVER='id parentid x y begin life halfw halfh Circle type controlid speed speedd speedds aspeed aspeedd aspeedds Parentevents Sonevents'.split()
REBOUND='id parentid x y begin life longs angle time speed speedd aspeed aspeedd Parentevents'.split()
FORCE='id parentid x y begin life halfw halfh Circle type controlid speed speedd aspeed aspeedd addaspeed addaspeedd Suction Repulsion addspeed'.split()

def lua(v):
 if v is None:return 'nil'
 if isinstance(v,bool):return str(v).lower()
 if isinstance(v,(float,int)):return repr(v)
 if isinstance(v,str):return json.dumps(v,ensure_ascii=False)
 if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
 return '{'+','.join('['+lua(str(k))+']='+lua(x) for k,x in v.items())+'}'
def atom(s):
 if s in ('True','False'):return s=='True'
 if s.startswith('{X:'):return [float(n) for n in re.findall(r':([-+\d.eE]+)',s)]
 try:return float(s) if any(c in s for c in '.eE') else int(s)
 except ValueError:return s

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--source',type=Path,required=True);args=ap.parse_args()
 source=args.source.resolve();content=source/'src/THMHJ/bin/x86/Debug/net461/Content';data=content/'Data';dst=ROOT/'mod/GAME/th37';art=ROOT/'Resources/th37';art.mkdir(exist_ok=True)
 hashes={};stats=collections.Counter();unsupported=[]
 for name in ('Game','StageManager','Code','CrazyStorm','Batch','Barrage','Lase','Cover','Rebound','Force','Time','Center','Execution','BExecution','CExecution','Enemy','EnemyEvent','Boss','BossCard','CSManager'):
  p=source/'src/THMHJ/THMHJ'/(name+'.cs');hashes[str(p.relative_to(source))]=hashlib.sha256(p.read_bytes()).hexdigest()
 def decrypt(p,kind):
  b=p.read_bytes();hashes[str(p.relative_to(source))]=hashlib.sha256(b).hexdigest();b=DES3.new(KEYS[kind],DES3.MODE_ECB).decrypt(b);n=b[-1];assert 1<=n<=8 and b[-n:]==bytes([n])*n,p;return b[:-n]
 def text(name):
  b=decrypt(data/(name+'.xna'),2)
  for enc in ('utf-8-sig','gb18030','utf-16'):
   try:return b.decode(enc)
   except UnicodeDecodeError:pass
  raise ValueError(name)
 def numeric(s):
  a=s.split('+');base=a[0];rnd=float(a[1]) if len(a)>1 else 0
  if base in ('自机','自身'):return lua(base),rnd
  return str(float(base)),rnd
 def action(a,kind):
  if a.startswith('范围移动'):return 'R.move(o,'+','.join(a.split('，')[1:])+')'
  if a=='跟随自机':return 'R.follow(o)'
  if a=='额外发射':return 'R.fire(o)'
  if a.startswith('PlayMusic('):return 'R.sound('+lua(a[10:-1])+')'
  m=re.fullmatch(r'(.+?)(变化到|增加|减少)(.+?)，([^，]+)，(\d+)帧(?:\((\d+)\))?',a)
  if not m:raise ValueError('无法展开事件 '+a)
  prop,op,val,mode,dur,limit=m.groups();assert prop in PROPS,prop;v,rnd=numeric(val)
  field='sonlife' if prop=='生命' and kind in ('batch','laser') else PROPS[prop]
  return 'R.change(o,'+','.join([lua(field),v,str(rnd),str({'变化到':0,'增加':1,'减少':2}[op]),lua(mode),dur])+')'
 def predicate(c,period,add):
  # 原作每到组周期先增加loop，再将条件值平移loop*addtime。
  parts=re.split('(且|或)',c);out=[]
  for p in parts:
   if p in ('且','或'):out.append('and' if p=='且' else 'or');continue
   m=re.fullmatch(r'(.+?)([=<>])([-+.\d]+)',p);assert m,c
   prop,op,value=m.groups();assert prop in PROPS,c
   lhs='t' if prop=='当前帧' else '(o.'+PROPS[prop]+' or 0)'
   shift=f'+math.floor(t/{max(1,period)})*{add}' if add else ''
   out.append(f'{lhs}{"==" if op=="=" else op}({value}{shift})')
  return ' '.join(out)
 def events(s,kind):
  lines=[]
  for group in s.split('&'):
   if not group:continue
   if kind=='rebound':
    lines.append(action(group+'，正比，1帧',kind));continue
   assert group.count('|')>=3,(kind,s,group)
   tag,period,add,ev=group.split('|',3);period,add=int(period),int(add)
   for e in ev.split(';'):
    if not e:continue
    cond,a=e.split('：',1);body=action(a,kind);pred=predicate(cond,period,add);stats['events']+=1
    limit=re.search(r'帧\((\d+)\)$',a)
    if limit:
     idx=stats['events'];body=f'if R.once(o,{idx},{limit[1]}) then {body} end'
    lines.append('if '+pred+' then '+body+' end')
  return 'function(o,t,R)\n'+ '\n'.join(lines)+'\nend'
 def record(line,kind,fields,rands):
  raw=line.split(',');o={k:atom(v) for k,v in zip(fields,raw) if k not in ('unused','Parentevents','Sonevents')}
  start=len(fields);o['rand']={k:atom(v) for k,v in zip(rands,raw[start:])};o['kind']=kind
  if kind=='batch':
   for k,v in zip(['Cover','Rebound','Force','Deepbind'],raw[70:]):o[k]=atom(v)
  elif kind=='laser' and len(raw)>58:o['Deepbind']=atom(raw[58])
  out=lua(o)[:-1]
  for k in ('Parentevents','Sonevents'):
   if k in fields:out+=','+k+'='+events(raw[fields.index(k)],kind if k=='Parentevents' else kind+'-son')
  return out+'}'
 patterns={}
 def pattern(name):
  if name in patterns:return
  t=text('b'+name);lines=t.splitlines();i=1;custom=[];global_events=[]
  while not lines[i].startswith('Center:'):
   count=int(lines[i].split()[0]);kind=lines[i];i+=1
   block=lines[i:i+count];i+=count
   if 'Types' in kind:custom=[[atom(v) for v in x.split('_')[1:]] for x in block]
   elif 'GlobalEvents' in kind:global_events=block
  center=lines[i][7:].split(',');available=len(center)>=2
  if not available:center=['315','240','0','0','0','0','']
  i+=1;total=int(lines[i].split(':')[1].split(',')[0]);i+=1
  ce='&'.join(['中心|1|0|'+center[6]]) if len(center)>6 else ''
  rows=[];features=collections.Counter()
  for layer in range(4):
   h=lines[i].split(':',1)[1].split(',');i+=1
   if h[0]=='empty':continue
   for kind,fields,rands,n in zip(['batch','laser','cover','rebound','force'],[BATCH,LASE,COVER,REBOUND,FORCE],[RAND_BATCH,RAND_LASE,[],[],[]],h[3:]):
    for _ in range(int(n)):
     rows.append(record(lines[i],kind,fields,rands));features[kind]+=1;i+=1
  patterns[name]=True;stats.update(features)
  global_code=[]
  for ge_index,line in enumerate(global_events):
   ge=[atom(x) for x in line.split('_')];start=int(ge[0])
   if ge[4]:global_code.append(f'if t=={start} then R.jump(c,{ge_index+1},{ge[5]},{ge[6]}) end')
   if ge[10]:global_code.append(f'if t=={start} then R.quake(c,{ge[11]},{ge[12]}) end')
   if ge[16]:global_code.append(f'if t>={start} then R.slow(c,{ge[17]},{ge[18]},t,{start}) end')
  # 中心运动独立于宿主；中心脚本控制boss，普通发射器坐标只做一次center偏移。
  code='-- 离线展开：b'+name+'.xna；事件均已编译为Lua条件和调用。\nreturn {id='+lua(name)+',total='+str(total)+',centerAvailable='+lua(available)+',center='+lua([atom(x) for x in center[:6]])+',centerEvents='+events(ce,'center')+',globalEvents=function(c,t,R)\n'+'\n'.join(global_code)+'\nend,types='+lua(custom)+',emitters={\n'+',\n'.join(rows)+'\n}}\n'
  (dst/'patterns').mkdir(exist_ok=True);(dst/'patterns'/(name+'.lua')).write_text(code)
  tex=data/('b'+name+'.dat')
  if tex.exists():(art/('b'+name+'.png')).write_bytes(decrypt(tex,0))
 def time(s):
  m,s,f=map(int,s.split(':'));return m*3600+s*60+f
 def commands(t):
  out=[];ls=t.splitlines();i=0
  while i<len(ls):
   l=ls[i].strip();i+=1
   if l.startswith('//') or not l:continue
   if l.startswith('For '):
    times=re.findall(r'\[([^]]+)\]',l);first,last,step=map(time,times);block=[]
    while i<len(ls):
     v=ls[i].strip();i+=1
     if v=='}':break
     if v not in ('','{') and not v.startswith('//'):block.append(v)
    for v in block:
     for tick in range(first,last+1,step):out.append((tick,v))
   else:
    m=re.fullmatch(r'\[([^]]+)\](.*)',l)
    if m:out.append((time(m[1]),m[2]))
  return sorted(enumerate(out),key=lambda pair:(pair[1][0],pair[0]))
 chapters=[];next_id=37000;allcards=[]
 actors={2:('橙','Chen'),3:('伊吹萃香','Suika'),4:('八云蓝','Ran'),5:('爱丽丝·玛格特罗依德','Alice'),6:('圣白莲','Byakuren'),7:('帕秋莉·诺蕾姬','Knowledge'),8:('西行寺幽幽子','Yuyuko'),9:('八云紫','Yukari')}
 for stage,diff in [(s,4) for s in range(1,7)]+[(7,5),(8,6)]:
  name=str(stage)+'0'+str(diff);names={line.split(' ',1)[0]:line.split(' ',1)[1] for line in text('s'+str(diff)).splitlines() if ' ' in line};cs=commands(text(name));bosses=[];roads=[];current=None;driver=[];lasttime=0;roadstart=0
  for order,(tick,cmd) in cs:
   m=re.fullmatch(r'(\w+)(?:\((.*)\))?',cmd);assert m,cmd;fn,args_=m.groups();args_=args_.split(',') if args_ else []
   if fn=='SetBoss':
    if tick>roadstart:
     rid=next_id;next_id+=1;roads.append({'id':rid,'first':roadstart,'last':tick})
    roadstart=tick
    current={'time':tick,'actor':int(args_[0]),'cards':[],'source':args_,'id':f'{stage}_{len(bosses)+1}'};bosses.append(current)
   elif fn=='SetBossCard':
    kind,bid,seconds,hp=map(int,args_[:4]);flag=args_[4] if len(args_)>4 else '';key=str(stage)+str(bid);pattern(key)
    if flag=='CONTINUE':current['cards'][-1].setdefault('continuations',[]).append({'pattern':key,'time':seconds,'hp':hp});continue
    ident=next_id;next_id+=1;actorname,img=actors.get(current['actor'],('梦华祭角色','Yukari'));title=names.get(('f' if not kind else '')+key,('符卡' if kind else '通常弹幕')+' '+key)
    c={'id':ident,'pattern':key,'spell':kind==1,'seconds':seconds,'hp':hp,'immune':int(flag) if flag.isdigit() else 0,'flag':flag,'title':title,'actor':actorname,'image':img,'chapter':str(stage) if stage<=6 else 'EX' if stage==7 else 'PH','boss':current['id']}
    current['cards'].append(c);allcards.append(c)
   elif fn=='SetBossItems':
    assert current and len(args_)==9
    current['items']=[int(x) for x in args_]
    driver.append((tick,fn,args_)) # Retain the historical driver for old replays.
   elif fn=='ExtraBoss':
    if current:current['extraBoss']=True
    driver.append((tick,fn,args_))
   elif fn=='StageEnd':lasttime=tick
   else:
    if fn=='SetEnemy' and args_[7]!='-1':pattern(str(stage)+args_[7])
    driver.append((tick,fn,args_))
  if lasttime>roadstart:
   rid=next_id;next_id+=1;roads.append({'id':rid,'first':roadstart,'last':lasttime})
  chapter={'name':str(stage) if stage<=6 else 'EX' if stage==7 else 'PH','stage':stage,'difficulty':diff,'script':name,'length':lasttime,'bosses':bosses,'roads':roads};chapters.append(chapter)
  code=['-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。','return function(R,state,t)']
  grouped=collections.defaultdict(list)
  for tick,fn,a in driver:grouped[tick].append('R.stage_'+fn+'(state,'+','.join(lua(x) for x in a)+')' if a else 'R.stage_'+fn+'(state)')
  for tick,lines_ in grouped.items():code+=['if t=='+str(tick)+' then']+lines_+['end']
  code+=['end'];(dst/('stage'+str(stage)+'.lua')).write_text('\n'.join(code)+'\n')
  stats['stage_commands']+=len(driver)
 common=[[atom(v) for v in x.split('_')[1:]] for x in text('3').splitlines() if x]
 out={'chapters':chapters,'cards':allcards,'bulletTypes':common,'enemyTypes':[[atom(v) for v in x.split(',')] for x in text('0').splitlines() if x]}
 (dst/'catalogue.lua').write_text('-- 原始阶段元数据；历史槽位固定在37000段。\nreturn '+lua(out)+'\n')
 for name,path in [('barrages','Pattern/barrages'),('enemys','List/enemys')]:
  (art/(name+'.png')).write_bytes(decrypt(content/'Graphics'/(path+'.xna'),0))
 stats['patterns']=len(patterns);stats['cards']=len(allcards);stats['spells']=sum(c['spell'] for c in allcards);stats['nonspells']=sum(not c['spell'] for c in allcards);stats['roads']=sum(len(x['roads']) for x in chapters)
 manifest={'source':str(source),'statistics':dict(stats),'unsupported':unsupported,'sha256':hashes}
 (dst/'sources.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n');print(json.dumps({'statistics':stats,'unsupported_count':len(unsupported)},ensure_ascii=False,indent=2))
if __name__=='__main__':main()
