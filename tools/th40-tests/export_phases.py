#!/usr/bin/env python3
"""从已反编译C#提取Boss阶段、MBG启动条件和原作运动参数。只在离线运行。"""
import argparse,json,re,math
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--source',type=Path,required=True);p.add_argument('--game',type=Path,required=True);a=p.parse_args()
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'mod/GAME/th40';q=lambda s:json.dumps(s,ensure_ascii=False)
def lua(v):
 if v is None:return 'nil'
 if isinstance(v,bool):return str(v).lower()
 if isinstance(v,(int,float)):return repr(v)
 if isinstance(v,str):return q(v)
 if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
 return '{'+','.join('['+q(k)+']='+lua(x) for k,x in v.items())+'}'
def close(s,pos,left='{',right='}'):
 depth=1;i=pos+1;quoted=False;esc=False
 while depth:
  c=s[i]
  if quoted:
   if esc:esc=False
   elif c=='\\':esc=True
   elif c=='"':quoted=False
  elif c=='"':quoted=True
  elif c==left:depth+=1
  elif c==right:depth-=1
  i+=1
 return i
def body(s,anchor):
 start=s.index('{',s.index(anchor));return s[start+1:close(s,start)-1]
def choose(s):
 def f(m):
  pairs=re.findall(r'(\d+|_)\s*=>\s*("(?:\\.|[^"\\])*")',m[1]);d=dict(pairs);return d.get('3',d.get('_','""'))
 return re.sub(r'\(int\)base\.Difficulty switch\s*\{([^}]+)\}',f,s)
def guard(s,pos):
 out=[]
 for m in re.finditer(r'\bif\s*\(',s):
  start=s.index('(',m.start());end=close(s,start,'(',')');b=s.find('{',end)
  if b<0:continue
  if s[end:b].strip():continue
  stop=close(s,b)
  if b<pos<stop:out.append(s[start+1:end-1])
 return out
def expression(s):
 s=re.sub(r'\((?:float|int|double)\)','',s)
 s=re.sub(r'(?<=\d)[fL]\b','',s)
 s=s.replace('base.Boss.MaxHP','o.maxhp').replace('base.Boss.HealthPoint','o.hp').replace('base.Time','t').replace('base.BoundRect.Width','384').replace('base.BoundRect.Height','448')
 s=s.replace('flag','o.flag').replace('&&',' and ').replace('||',' or ').replace('!=','~=')
 s=re.sub(r'!\s*','not ',s)
 s=s.replace('base.Difficulty','3').replace('DifficultLevel.Hard','2').replace('DifficultLevel.Normal','1').replace('DifficultLevel.Lunatic','3')
 return s
unhandled=[]
def conditions(s,pos):
 gs=[]
 for g in guard(s,pos):
  if any(k in g for k in ['OnSpell','EnemyPlaneList','SpellList','MyPlane']):continue
  if 'base.' in expression(g):unhandled.append(g);continue
  gs.append('('+expression(g)+')')
 return ' and '.join(gs) or 'true'
def selected(s):return choose(s)
def path_literal(s):return s.replace('\\\\','/').replace('\\','/').removeprefix('./CS/')
def callbacks(s,source):
 s=selected(s);out=[]
 # 文件变量在所属条件块内定义；每次创建保留各自的原作条件。
 for m in re.finditer(r'new CSEmitterController\(',s):
  previous=s[:m.start()];files=list(re.finditer(r'(?:string\s+)?fileName\s*=\s*"([^"]+)"',previous))
  if not files:unhandled.append(source+': no fileName');continue
  key=path_literal(files[-1][1])
  if not key:continue
  rest=s[m.start():];end=rest.find('\n\t\t}')
  config=rest[:end if end>=0 else len(rest)]
  bound='BossBinding = true' in config
  anchor='current' if 'BaseOriginalPosition = base.OriginalPosition' in config else 'default'
  point=re.search(r'BaseOriginalPosition = new PointF?\(([^;]+)\)',config)
  if point:anchor=[192,float(point[1].split(',')[-1])]
  cond=conditions(s,m.start())
  clear='N.clear(o);o.flag=o.flag+1;' if 'flag == ' in cond else ''
  out.append('if '+cond+' then '+clear+'N.controller(o,'+q(key)+','+lua(bound)+','+lua(anchor)+') end')
 for m in re.finditer(r'(?:base\.Boss\.)?MoveUpDown\(([^)]*)\)',s):
  out.append('if '+conditions(s,m.start())+' then N.bob(o,t,'+(m[1].strip() or '80')+') end')
 for m in re.finditer(r'(?:base\.Boss\.)?RandomMove\((\d+),\s*(\d+),\s*([\d.]+)f?,\s*new Rectangle\(([^)]+)\)\)',s):
  values=[int(m[1]),int(m[2]),float(m[3])]+[float(eval(expression(x),{'__builtins__':{}},{})) for x in m[4].split(',')]
  out.append('if '+conditions(s,m.start())+' then N.wander(o,t,'+','.join(map(str,values))+') end')
 return '\n'.join(out)
def armor(s,boss):
 m=re.search(r'(?:base\.Boss\.|base\.)Armon = ([^;]+)',s)
 if not m:return 0
 value=m[1]
 if 'ArmonArray' in value:
  index=int(re.search(r'\[(\d+)\]',value)[1]);path=re.search(r'LoadArmon\("([^"]+)"',boss)
  values=(a.game/'CS'/path_literal(path[1])).read_text().splitlines()
  return float(values[index])
 return float(expression(value))
def movement(s,default):
 m=re.search(r'(?:base\.)?Boss\.DestPoint = new PointF?\(([^)]+)\)|base\.DestPoint = new PointF?\(([^)]+)\)',s)
 if not m:return default
 return [float(eval(expression(x),{'__builtins__':{}},{})) for x in (m[1] or m[2]).split(',')]
identities={'Ami':'娅米','Rakuki':'桃雨洛熙','Koreirei':'古灵灵','Seiryuu':'夏青柳','Kage':'魅明魔影','Rakukun':'桃雨洛薰','Tensei':'梦璃夜天星','Rika':'雾隐梨花'}
stages={};phases=[];functions={};index=68000
for chapter in ['01','02','03','04','05','06','Ex']:
 stage=(a.source/('GameState_SSS'+chapter+'.cs')).read_text();bs=re.findall(r'new (Boss_\w+)\(',stage);times=re.search(r'int\[\] array = new int\[\d+\] \{([^}]+)',stage)
 clocks=[int(x) for x in times[1].split(',')];chs='EX' if chapter=='Ex' else str(int(chapter));stagePhases=[]
 # FSC是原作可触发的独立阶段；练习保留，顺序入口另按原条件过滤。
 final=bs[-1];extraBoss=re.sub(r'\d+$',lambda m:str(int(m[0])+1).zfill(len(m[0])),final)
 allboss=bs+([extraBoss] if (a.source/(extraBoss+'.cs')).exists() else [])
 for bossindex,bossclass in enumerate(allboss):
  src=(a.source/(bossclass+'.cs')).read_text();who=re.sub(r'^Boss_|\d+$','',bossclass)
  if who not in identities:continue
  role='mid' if bossindex==0 and len(bs)>1 else 'boss'
  life=int(re.search(r'base.Life = (\d+);',src)[1]);limit=int(re.search(r'base.SpellTime = (\d+);',src)[1])
  for n in range(life,0,-1):
   anchor='private void Ctrl'+str(n)+'()'
   if anchor not in src:continue
   method=body(src,anchor);non=body(method,'if (!base.OnSpell)') if 'if (!base.OnSpell)' in method else ''
   emitted=callbacks(non,bossclass+'.Ctrl'+str(n))
   def add(meta,fn):
    global index
    index+=1;meta['id']=index;phases.append(meta);stagePhases.append(index);functions[index]=fn
   common={'chapter':chs,'boss':who,'boss_name':identities[who],'role':role,'source':bossclass+'.Ctrl'+str(n),'time':limit,'maxhp':10000}
   if emitted and '.mbg' in choose(non):
    hp=re.search(r'base.SpellcardHP = (\d+)',non);hp=int(hp[1]) if hp else 2000
    add(dict(common,kind='nonspell',title='',hp=10000-hp,dest=movement(non,[192,120]),armor=armor(non,src)),emitted)
   spells=list(dict.fromkeys(re.findall(r'new (SpellCard_SSS\w+)\(',method)))
   if not spells:continue
   # 机体A/B/C/D保持同一阶段，运行时按所选LuaSTG自机映射，练习另保留来源。
   primary=spells[0];ps=(a.source/(primary+'.cs')).read_text();title=re.findall(r'base.SC_Name = "([^"]*)"',ps)[-1]
   constructor=body(ps,'public '+primary+'(');shoot=body(ps,'public override void Shoot()')
   move=re.search(r'Boss.DestPoint = new PointF?\(([^)]+)\)',constructor)
   dest=[192,120] if not move else [float(eval(expression(x),{'__builtins__':{}},{})) for x in move[1].split(',')]
   timed=re.findall(r'base.SpellTime = (\d+)',method);duration=int(timed[-1]) if timed else limit
   backgrounds=re.findall(r'new Background\w*\(StageData, "([^"]+)"',constructor)
   if 'new BackgroundBoss06' in constructor:backgrounds=['底色','绿光','蓝光','红光']
   meta=dict(common,kind='spell',title=title,hp=2000,time=duration,dest=dest,source=primary,optional='_FSC' in primary,armor=armor(shoot,src),backgrounds=backgrounds,survival=': BaseTimeSC' in ps)
   if 'base.OnSpell = true' in non:meta['hp']=10000
   variants={};variant_fns={}
   for sc in spells:
    text=(a.source/(sc+'.cs')).read_text();variant_fns[sc]=callbacks(body(text,'public override void Shoot()'),sc);variants[sc]=re.findall(r'base.SC_Name = "([^"]*)"',text)[-1]
   meta['variants']=variants
   fn='local route=N.route(o)\n'
   for j,(sc,code) in enumerate(variant_fns.items()):
    letter=sc[-1] if sc[-1] in 'ABCD' and re.search(r'\d[ABCD]$',sc) else 'A'
    fn+=('if' if j==0 else 'elseif')+' route=='+q(letter)+' then\n'+code+'\n'
   fn+='else\n'+list(variant_fns.values())[0]+'\nend'
   add(meta,fn)
 offset=int(re.search(r'cSEmitterController.Time = base.TimeMain ([+-] \d+)',stage)[1].replace(' ',''))
 stages[chs]={'clock':clocks,'offset':offset,'bosses':bs,'ids':stagePhases,'road_a':f'St{chapter}/A/'+('' if chapter=='Ex' else 'L/'),'road_b':f'St{chapter}/B/'+('' if chapter=='Ex' else 'L/')}
# 道中完整时钟另用同一关的分段入口，原作暂停出敌、Boss退场后的B段从原TimeMain+60续接。
for ch,stage in stages.items():
 for part in ['a','b']:
  folder=stage['road_'+part];paths=sorted(str(p.relative_to(a.game/'CS')) for p in (a.game/'CS'/folder).glob('*.mbg'))
  if not paths:continue
  index+=1;first,last=(2,stage['clock'][0]) if part=='a' else (stage['clock'][1]+1,stage['clock'][2])
  if part=='b' and len(stage['bosses'])==1:continue # 四面B虽随包存在，GameState从未调用。
  if part=='a' and (last<=first or len(stage['bosses'])==1):last=stage['clock'][2]
  if last<=first:continue
  phases.append({'id':index,'chapter':ch,'boss':'road','boss_name':'道中','role':'road','kind':'road','title':'夏夜祭'+ch+'道中'+('前半' if part=='a' else '后半'),'hp':1,'time':last-first,'clock_first':first,'clock_last':last,'patterns':paths,'source':'GameState_SSS'+('Ex' if ch=='EX' else ch.zfill(2)),'part':part})
  stage['road_'+part+'_id']=index
  functions[index]='\n'.join('N.road_controller(o,'+q(p)+','+str(first+stage['offset'])+')' for p in paths)
# 阶段顺序从Boss的Life倒序和源码创建链生成，不从文件名排序猜非符与符卡。
orders={}
for ch,s in stages.items():
 rows=[p for p in phases if p['chapter']==ch and p['kind']!='road'];mid=[p['id'] for p in rows if p['role']=='mid'];boss=[p['id'] for p in rows if p['role']=='boss']
 orders[ch]=([s['road_a_id']] if 'road_a_id' in s else [])+mid+([s['road_b_id']] if 'road_b_id' in s else [])+boss
out=['-- 原作C#阶段与运动参数的离线转换；只包含Lua函数和常量。','local P='+lua(phases)]
for i,meta in enumerate(phases,1):
 if meta['kind']=='road':out.append('P[%d].begin=function(o,N)\n%s\nend'%(i,functions[meta['id']]))
 else:out.append('P[%d].step=function(o,t,N)\n%s\nend'%(i,functions[meta['id']]))
out+=['return {phases=P,orders='+lua(orders)+',stages='+lua(stages)+'}'];(OUT/'phases.lua').write_text('\n'.join(out)+'\n')
(OUT/'phase_manifest.json').write_text(json.dumps({'phases':phases,'orders':orders,'unhandled_conditions':unhandled},ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'phases':len(phases),'kinds':{k:sum(p['kind']==k for p in phases) for k in ['spell','nonspell','road']},'orders':{k:len(v) for k,v in orders.items()},'unhandled':unhandled},ensure_ascii=False))
