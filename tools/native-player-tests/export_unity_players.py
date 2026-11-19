#!/usr/bin/env python3
"""保留雪莲华自机 prefab 图、引用和 MonoBehaviour 原始逻辑。"""
import argparse,hashlib,json,math,re,subprocess,sys
from pathlib import Path
import yaml
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools/th38-tests'))
from export_background import Source,doc,fid,lua
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--assets',type=Path,required=True);ap.add_argument('--parser-lib',type=Path,required=True);args=ap.parse_args()
a=Source(args.assets);prefab=a.root/'Resources/xuelianhua/prefab'
out=ROOT/'mod/GAME/th38/native_players';out.mkdir(parents=True,exist_ok=True)
art=ROOT/'Resources/th38/player';art.mkdir(parents=True,exist_ok=True)
data={'prefabs':{},'sprites':{},'clips':{},'roots':{}};hashes={};scripts={}
data['staticTypes']=dict((name,kind) for kind,name in re.findall(r'public static (bool|int|float|double) (\w+)\s*;', (a.root/'Scripts/Sincos.cs').read_text()))
def record(p):hashes[str(p.relative_to(a.root))]=hashlib.sha256(p.read_bytes()).hexdigest()
def sprite(ref):
 p=a.path(ref)
 if not p or not fid(ref):return None
 key=ref['guid']+'_'+str(fid(ref))
 if key in data['sprites']:return key
 record(p);record(p.with_name(p.name+'.meta'))
 ti=yaml.safe_load(p.with_name(p.name+'.meta').read_text())['TextureImporter'];im=Image.open(p).convert('RGBA')
 entries=ti.get('spriteSheet',{}).get('sprites') or []
 if entries:
  names={int(next(iter(v['first'].values()))):v['second'] for v in ti['internalIDToNameTable']};s=next(v for v in entries if v['name']==names[fid(ref)])
  rect=s['rect'];pivot=s['pivot'];x,y,w,h=(rect[k] for k in ('x','y','width','height'));im=im.crop((x,im.height-y-h,x+w,im.height-y))
 else:w,h=im.size;pivot=ti.get('spritePivot',{'x':.5,'y':.5})
 im.save(art/(key+'.png'))
 data['sprites'][key]={'w':w,'h':h,'ox':w*pivot['x'],'oy':h*(1-pivot['y']),'scale':48/ti.get('spritePixelsToUnits',100)}
 return key
def clip(p):
 key=p.relative_to(a.root).as_posix()
 if key in data['clips']:return key
 record(p);v=next(v for k,i,v in doc(p,{74}));data['clips'][key]={'length':v['m_AnimationClipSettings']['m_StopTime'],'loop':v['m_AnimationClipSettings'].get('m_LoopTime',0),'tracks':[{'path':c.get('path') or '', 'keys':[[k['time'],sprite(k['value'])] for k in c['curve']]} for c in v.get('m_PPtrCurves') or []]};return key
q=[]
for name,stem in {'reimu':'Center_lingmeng','yukari':'Center_zi','marisa':'Center_molisha','marisa_b':'Center_yinqinai','byakuren':'Center_bailian','miko':'Center_shenzi'}.items():
 p=next(prefab.rglob(stem+'.prefab'));data['roots'][name]=p.relative_to(a.root).as_posix();q.append(p)
q.append(prefab/'zhuqiang.prefab')
def convert(v):
 if isinstance(v,dict):
  p=a.path(v)
  if p:
   if p.suffix=='.prefab':q.append(p);return {'prefab':p.relative_to(a.root).as_posix()}
   if p.suffix.lower() in ('.png','.jpg','.tga','.psd'):return {'sprite':sprite(v)}
   return {'asset':p.relative_to(a.root).as_posix()}
  if 'fileID' in v:return {'fileID':str(fid(v))}
  return {k:convert(c) for k,c in v.items()}
 if isinstance(v,list):return [convert(c) for c in v]
 return v
while q:
 p=q.pop(0);key=p.relative_to(a.root).as_posix()
 if key in data['prefabs']:continue
 record(p);entries=list(doc(p,{1,4,114,212,95,58,61,198}));trans={i:v for k,i,v in entries if k==4};objects={i:v for k,i,v in entries if k==1};nodes=[];data['prefabs'][key]=nodes
 for i,t in trans.items():
  go=fid(t['m_GameObject']);node={'id':str(go),'transform':str(i),'name':objects[go]['m_Name'],'active':objects[go].get('m_IsActive',1),'parent':str(fid(t['m_Father'])),'pos':list(t['m_LocalPosition'].values()),'scale':list(t['m_LocalScale'].values()),'angle':math.degrees(2*math.atan2(t['m_LocalRotation']['z'],t['m_LocalRotation']['w'])),'components':[]};nodes.append(node)
  for k,j,v in entries:
   if k in (1,4) or fid(v['m_GameObject'])!=go:continue
   if k==114:
    sp=a.path(v['m_Script']);name=sp.stem
    scripts[name]=sp;record(sp)
    node['components'].append({'id':str(j),'type':name,'enabled':v.get('m_Enabled',1),'fields':convert({k:x for k,x in v.items() if not k.startswith('m_')})})
   elif k==212:node['components'].append({'id':str(j),'type':'SpriteRenderer','fields':{'sprite':{'sprite':sprite(v['m_Sprite'])},'color':v['m_Color'],'sortingOrder':v['m_SortingOrder'],'enabled':v.get('m_Enabled',1)}})
   elif k==95:
    controller=a.path(v['m_Controller']);motion=None
    if controller:
     record(controller);states=list(doc(controller,{1102}));motion=next((a.path(v['m_Motion']) for k,i,v in states if a.path(v['m_Motion'])),None)
    node['components'].append({'id':str(j),'type':'Animator','fields':{'clip':clip(motion) if motion else None}})
   elif k in (58,61):node['components'].append({'id':str(j),'type':'Collider2D','fields':convert(v)})
   elif k==198:node['components'].append({'id':str(j),'type':'ParticleSystem','fields':{}})
# 仅执行自机/武器行为，音量控制、通用界面与结界库存由宿主边界处理。
skip={'Centeryidong','Zijidonghua','Zijiwudi','Pl_shoot_se','Zhunxintexiao','Centerxuanzhuan','Soundyinliangkongzhi','Tongyong_sr_color_to_shader','Tongyong_sr_Alpha_to_shader','Jiejie_shifang','Jiejie_break','Jiejie_bailian','Lan_ins_jiance','Bomb'}
selected=[p for n,p in sorted(scripts.items()) if n not in skip]
# 倍率条只去掉 UI 绘制准备，切换、衰减和暴走计时保留原文。
import tempfile
rate=a.root/'Scripts/Beilvcao.cs';record(rate)
raw=rate.read_text();start=raw.index('private void FixedUpdate()');tail=raw.index('if (Sincos.if_change != last_ifqiehuan)',start)
logic=raw[:start]+'private void FixedUpdate() {\n'+raw[tail:]
with tempfile.TemporaryDirectory() as temp:
 rp=Path(temp)/'Beilvcao.cs';rp.write_text(logic)
 subprocess.run([sys.executable,str(Path(__file__).with_name('csharp_logic.py')),'--parser-lib',str(args.parser_lib),'--methods','FixedUpdate','--out',str(out/'rate.lua'),str(rp)],check=True)

subprocess.run([sys.executable,str(Path(__file__).with_name('csharp_logic.py')),'--parser-lib',str(args.parser_lib),'--out',str(out/'source.lua'),*map(str,selected)],check=True)
(out/'data.lua').write_text('-- 雪莲华原始 prefab 与贴图切片；由 export_unity_players.py 生成。\nreturn '+lua(data)+'\n')
(out/'sources.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n')
print(len(data['prefabs']),'prefab，',len(selected),'原始行为，',len(data['sprites']),'无损切片')
