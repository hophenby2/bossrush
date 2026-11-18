#!/usr/bin/env python3
"""导出雪莲华敌机击破prefab的层级、Sprite、动画和粒子参数。"""
import argparse,copy,hashlib,json,re,shutil
from pathlib import Path
from PIL import Image
import yaml
from export_background import Source,doc,fid,xyz,rgba,lua
ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--assets',type=Path,required=True);args=ap.parse_args()
source=Source(args.assets.resolve());out=ROOT/'Resources/th38/enemy_death';out.mkdir(exist_ok=True)
sprites={};clips={};hashes={}
def record(path):hashes[str(path.relative_to(source.root))]=hashlib.sha256(path.read_bytes()).hexdigest()
def sprite(ref):
    path=source.path(ref)
    if not path or not fid(ref):return None
    key=ref['guid']+'_'+str(fid(ref))
    if key in sprites:return key
    record(path);meta=yaml.load(path.with_name(path.name+'.meta').read_text(),Loader=yaml.CSafeLoader)['TextureImporter']
    img=Image.open(path).convert('RGBA');rows=meta.get('spriteSheet',{}).get('sprites') or []
    if rows:
        names={int(next(iter(v['first'].values()))):v['second'] for v in meta['internalIDToNameTable']}
        s=next(v for v in rows if v['name']==names[fid(ref)]);r=s['rect'];pivot=s['pivot']
        x,y,w,h=[r[k] for k in ('x','y','width','height')];img=img.crop((x,img.height-y-h,x+w,img.height-y))
    else:w,h=img.size;pivot=meta.get('spritePivot',{'x':.5,'y':.5})
    img.save(out/(key+'.png'),optimize=True)
    sprites[key]={'w':w,'h':h,'ox':w*pivot['x'],'oy':h*(1-pivot['y']),'ppu':meta['spritePixelsToUnits']}
    return key
def animation(path):
    key=path.relative_to(source.root).as_posix()
    if key in clips:return key
    record(path);c=next(v for k,i,v in doc(path,{74}))
    tracks=[]
    for v in c.get('m_PPtrCurves') or []:
        if v['attribute']=='m_Sprite':tracks.append([[f['time'],sprite(f['value'])] for f in v['curve']])
    clips[key]={'tracks':tracks,'length':c['m_AnimationClipSettings']['m_StopTime'],'loop':c['m_AnimationClipSettings']['m_LoopTime']}
    return key
prefabs=source.root/'Resources/xuelianhua/prefab/enemy';deaths={};enemies={}
for path in sorted(prefabs.glob('emy*.prefab')):
    if not re.fullmatch(r'emy\d+',path.stem):continue
    record(path)
    script=next((v for k,i,v in doc(path,{114}) if 'enemy_death' in v),{})
    target=source.path(script.get('enemy_death',{}));enemies[int(path.stem[3:])]=target.stem if target else False
for path in sorted(prefabs.glob('emy_death*.prefab')):
    record(path);entries=list(doc(path,{1,4,95,114,198,199,212}));nodes=[]
    transforms={i:v for k,i,v in entries if k==4};order=list(transforms)
    for key,tr in transforms.items():
        go=fid(tr['m_GameObject']);sr=next((v for k,i,v in entries if k==212 and fid(v['m_GameObject'])==go),None)
        ps=next((v for k,i,v in entries if k==198 and fid(v['m_GameObject'])==go),None)
        scripts={}
        for k,i,v in entries:
            if k==114 and fid(v['m_GameObject'])==go:
                sp=source.path(v['m_Script'])
                if sp:scripts[sp.stem]={k:v[k] for k in ('xishu','b','beilv','time','time_death','speed','speed_add','speed_max') if k in v}
        node={'parent':order.index(fid(tr['m_Father']))+1 if fid(tr['m_Father']) in transforms else 0,
            'pos':xyz(tr['m_LocalPosition']),'rot':[*xyz(tr['m_LocalRotation']),tr['m_LocalRotation']['w']],
            'scale':xyz(tr['m_LocalScale']),'scripts':scripts}
        if sr:
            node['sprite']=sprite(sr['m_Sprite']);node['color']=rgba(sr['m_Color']);node['order']=sr['m_SortingOrder']+65536*sr['m_SortingLayer']
            node['blend']=source.material(source.path(sr['m_Materials'][0])).get('blend','')
            animator=next((v for k,i,v in entries if k==95 and fid(v['m_GameObject'])==go),None)
            if animator and source.path(animator['m_Controller']):
                ctrl=list(doc(source.path(animator['m_Controller']),{1102}))
                motion=next((source.path(v['m_Motion']) for k,i,v in ctrl if source.path(v['m_Motion'])),None)
                if motion:node['clip']=animation(motion)
        if ps:
            renderer=next(v for k,i,v in entries if k==199 and fid(v['m_GameObject'])==go)
            original=ps['EmissionModule']['rateOverTime']['scalar'];clone=copy.deepcopy(ps)
            clone['EmissionModule']['rateOverTime']['scalar']=max(original,1)
            node['particles']=source.particle(clone,renderer)
            if node['particles']:
                node['particles']['rate']=original
                node['particles']['scalingMode']=ps['scalingMode']
                node['particles']['bursts']=ps['EmissionModule'].get('m_Bursts') or []
        nodes.append(node)
    deaths[path.stem]=nodes
audio=source.path({'guid':'41f707a9c2bf4779a4532ca758f6b48a'})
record(audio);shutil.copyfile(audio,out/'enemy_death.wav')
(ROOT/'mod/GAME/th38/enemy_death_data.lua').write_text('-- 原始敌机击破prefab，不使用通用爆炸代替。\nreturn '+lua({'enemies':enemies,'deaths':deaths,'sprites':sprites,'clips':clips})+'\n')
(out/'sources.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n')
print(len(deaths),'prefab，',len(sprites),'Sprite，',len(clips),'动画')
