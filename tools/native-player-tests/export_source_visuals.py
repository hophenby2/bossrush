#!/usr/bin/env python3
"""离线保留自机原图、分部动画、中心点与道具切片；不重采样像素。"""
import argparse, hashlib, importlib.util, json, re, shutil, sys
from pathlib import Path
from PIL import Image

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('player_art',Path(__file__).with_name('export_art.py'))
old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
sys.path.insert(0,str(ROOT/'tools/th38-tests'))
from export_background import Source, doc, fid, lua

ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('part2',type=Path);ap.add_argument('asl',type=Path);ap.add_argument('part3',type=Path);ap.add_argument('bdb',type=Path)
ap.add_argument('--theis',type=Path)
args=ap.parse_args()
out=ROOT/'Resources/native_players/source';out.mkdir(exist_ok=True)
data={'players':{},'images':{},'unity':{},'items':{}};hashes={}

def image(key,im):
    im.save(out/(key+'.png'),optimize=True)
    data['images'][key]=list(im.size)
    return key

def texture(root,name,prefix):
    path=root/('Graphics/Pattern' if name=='items' else 'Graphics/List')/(name+'.xna')
    hashes[str(path)]=hashlib.sha256(path.read_bytes()).hexdigest()
    from io import BytesIO
    return image(prefix+name,Image.open(BytesIO(old.read(path,0))).convert('RGBA'))

# 春雪篇原图为15列，不把转向的4帧复制成8帧。
tex=texture(args.part2,'actor','37_')
ox,oy,w,h,*_=map(int,old.read(args.part2/'Data/10.xna',1).decode().split(','))
for j,name in enumerate(('reimu','marisa','sanae','youmu')):
    data['players']['35_'+name]={'tex':tex,'w':w,'h':h,'ox':ox,'oy':oy,'row':j,'scale':1}
texture(args.part2,'items','37_')
texture(args.part2,'selfbarrage','37_')
data['items'][35]={'tex':'37_items','rects':{'life':[111,35,21,21],'bombs':[144,35,21,21],
    'power':[63,15,13,13],'powerBig':[40,10,17,17],'powerFull':[82,9,19,19],'lifeBig':[107,0,29,29],
    'bombsBig':[141,3,27,26],'points':[23,15,13,13]},'scale':1}
data['items'][35]['rects']['bombs']=[143,35,21,21]

# 永夜篇每个部件保留全部Idle/Left/Right/Shift/Old状态，独立计时与跟随延迟。
rows=iter(old.read(args.part3/'Data/10.xna',1).decode('utf-8-sig').splitlines())
for name in ('reimu','marisa','sanae','mokou'):
    count,w,h,ox,oy,scale,*_=map(float,next(rows).split(','));next(rows);next(rows)
    parts={}
    for _ in range(int(count)):
        desc,tex,x,y,interval,delay,dx,dy,angle,change=next(rows).split(',')
        part,_,states=desc.rstrip(']').partition('[')
        key='39_actor'+tex
        if key not in data['images']:texture(args.part3,'actor'+tex,'39_')
        a={'tex':key,'x':int(x),'y':int(y),'interval':int(interval),'follow':int(delay),
            'dx':float(dx),'dy':float(dy),'rotation':float(angle),'change':int(change)}
        for state in states.split('|'):parts.setdefault(part,{})[state]=a
    data['players']['37_'+name]={'w':w,'h':h,'ox':ox,'oy':oy,'scale':scale*2/3,
        'parts':[{'name':k,'states':v} for k,v in parts.items()]}
texture(args.part3,'items','39_')
data['items'][37]={'tex':'39_items','rects':{'life':[0,0,72,64],'lifeBig':[72,0,83,89],
    'bombs':[153,0,60,65],'bombsBig':[213,0,78,72],'points':[944,304,80,80]},'scale':2/3,
    'halos':{'life':[292,0,169,166],'lifeBig':[461,0,227,221],'bombs':[691,0,169,166],'bombsBig':[0,88,227,221]}}

# Unity的AnimationClip逐关键帧切换，Sprite切片保留pivot和PPU。
source=Source(args.asl.resolve());sprites={};clips={}
def sprite(ref):
    if not fid(ref) or not ref.get('guid'):return None
    key=ref['guid']+'_'+str(fid(ref))
    if key in sprites:return key
    import yaml
    path=source.path(ref);meta=path.with_name(path.name+'.meta')
    hashes[str(path)]=hashlib.sha256(path.read_bytes()).hexdigest()
    ti=yaml.load(meta.read_text(),Loader=yaml.CSafeLoader)['TextureImporter']
    im=Image.open(path).convert('RGBA');entries=ti.get('spriteSheet',{}).get('sprites') or []
    if entries:
        names={int(next(iter(v['first'].values()))):v['second'] for v in ti['internalIDToNameTable']}
        s=next(v for v in entries if v['name']==names[fid(ref)])
        r=s['rect'];p=s['pivot'];x,y,w,h=(r[k] for k in ('x','y','width','height'))
        im=im.crop((x,im.height-y-h,x+w,im.height-y))
    else:w,h=im.size;p=ti.get('spritePivot',{'x':.5,'y':.5})
    image(key,im)
    sprites[key]={'ox':w*p['x'],'oy':h*(1-p['y']),'scale':48/ti.get('spritePixelsToUnits',100)}
    return key
def clip(path):
    key=path.relative_to(source.root).as_posix()
    if key in clips:return key
    c=next(v for k,i,v in doc(path,{74}))
    tracks=[{'path':v.get('path') or '', 'keys':[[f['time'],sprite(f['value'])] for f in v['curve']]} for v in c.get('m_PPtrCurves') or []]
    clips[key]={'tracks':tracks,'length':c['m_AnimationClipSettings']['m_StopTime'],
        'loop':c['m_AnimationClipSettings'].get('m_LoopTime',0)}
    return key
src=source.root/'Resources/xuelianhua/prefab'
specs={'reimu':('lingmeng','basic_lingmeng','lingmeng_left_basic','lingmeng_right_basic'),
 'yukari':('lingmeng/zi','zi_basic','zi_basicleft','zi_basicright'),
 'marisa':('molisha/move','molisha_basic','molisha_basic_left','molisha_basic_right'),
 'byakuren':('bailian','basic','left','right'),'miko':('bailian/shenzi','shenzi_basic','shenzi_left','shenzi_right')}
for name,(folder,*names) in specs.items():
    data['players']['36_'+name]={'clips':[clip(src/folder/(n+'.anim')) for n in names]}
prefabs={}
# 原prefab的Scale与旋转；主炮/诱导弹/掉落物不再借用宿主弹图。
for path in sorted(src.rglob('*.prefab')):
    if path.stem.startswith(('zhuqiang_','lingmeng_youdao','lingmeng_zhen','zi_zhen','molisha_youdao','ziji_xuli3zidan','item','Item','endbullet','laser_','Death_chongjibo')):
        d=list(doc(path,{4,212}))
        sr=next((v for k,i,v in d if k==212),None)
        if not sr:continue
        tr=next((v for k,i,v in d if k==4 and fid(v['m_GameObject'])==fid(sr['m_GameObject'])),None)
        if not tr:continue
        s=sprite(sr['m_Sprite'])
        if s:prefabs[path.stem]={'sprite':s,'sx':tr['m_LocalScale']['x'],'sy':tr['m_LocalScale']['y'],
            'color':list(sr['m_Color'].values()),'rotation':tr['m_LocalRotation']}
bulletclips={}
for path in (src.parent/'image/Bullet/bullet2').glob('*.controller'):
    if not path.stem.startswith(('yandan','yinfu','xuehua')):continue
    c=list(doc(path,{1102}));motion=next((source.path(v['m_Motion']) for k,i,v in c if source.path(v['m_Motion'])),None)
    if motion:bulletclips[path.stem]=clip(motion)
scene=source.root/'Scene/Stage1_spell.unity'
loading=next(v for k,i,v in doc(scene,{114}) if isinstance(v.get('spr'),list))
itemsprites=[sprite(ref) for ref in loading['spr']]
lasers={}
for path in (src.parent/'image/Bullet/jiguang').glob('*.png'):
    lasers[path.stem.lower()]=image('38_'+path.stem.lower(),Image.open(path).convert('RGBA'))
enemies={}
for path in (src/'enemy').glob('emy*.prefab'):
    if not path.stem[3:].isdigit():continue
    d=list(doc(path,{4,212,95,1102}));ns=[]
    for k,i,sr in d:
        if k!=212:continue
        tr=next((v for k,i,v in d if k==4 and fid(v['m_GameObject'])==fid(sr['m_GameObject'])),None)
        if not tr:continue
        anim=next((v for k,i,v in d if k==95 and fid(v['m_GameObject'])==fid(sr['m_GameObject'])),None)
        n={'sprite':sprite(sr['m_Sprite']),'sx':tr['m_LocalScale']['x'],'sy':tr['m_LocalScale']['y']}
        if anim and source.path(anim['m_Controller']):
            ctrl=list(doc(source.path(anim['m_Controller']),{1102}))
            motion=next((source.path(v['m_Motion']) for k,i,v in ctrl if source.path(v['m_Motion'])),None)
            if motion:n['clip']=clip(motion)
        if n['sprite'] or n.get('clip'):ns.append(n)
    enemies[int(path.stem[3:])]=ns
beams={}
import yaml
for n,stem in enumerate(('laser_zhi','laser_zhi2','Laser_wan','laser_zhi3')):
    path=next(p for p in (src.parent/'image/Bullet/jiguang').glob('*.png') if p.stem.lower()==stem.lower())
    meta=yaml.load(path.with_name(path.name+'.meta').read_text(),Loader=yaml.CSafeLoader)
    guid=meta['guid'];ti=meta['TextureImporter']
    entries=sorted(ti['internalIDToNameTable'],key=lambda v:int(v['second'].rsplit('_',1)[-1]))
    beams[n]=[sprite({'guid':guid,'fileID':int(next(iter(v['first'].values())))}) for v in entries]
playerlasers={}
for path in src.rglob('CenterObject*.prefab'):
    d=list(doc(path,{114,212}))
    for k,i,v in d:
        if k!=114 or not any(key in v for key in ('damage_gaosu','damage_baozou')):continue
        sr=next((sr for k,i,sr in d if k==212 and fid(sr['m_GameObject'])==fid(v['m_GameObject'])),None)
        if sr:playerlasers[path.stem]=sprite(sr['m_Sprite'])
for path in (src/'bailian/shenzi').glob('shenzi_laser*.prefab'):
    sr=next((v for k,i,v in doc(path,{212})),None)
    if sr:playerlasers[path.stem]=sprite(sr['m_Sprite'])
data['unity']={'sprites':sprites,'clips':clips,'prefabs':prefabs,'bulletclips':bulletclips,'lasers':lasers,'beams':beams,'items':itemsprites,'enemies':enemies,'playerlasers':playerlasers}

# 栖霞园12帧待机与4+8帧转向原图，子弹使用原128像素切片。
for name in ('reimu','marisa','sakuya'):
    entries={}
    for mode in ('normal','left','right','bullets','trail1','trail2','laser','laser_eff'):
        p=args.bdb/'res/player'/name/(mode+'.png')
        if p.exists():entries[mode]=image('43_'+name+'_'+mode,Image.open(p).convert('RGBA'))
    data['players']['41_'+name]={'textures':entries,'scale':.85*.5}
    for mode in ('main','straight','trail','spread'):
        p=args.bdb/'res/player'/name/(mode+'_eff.png')
        if p.exists():image('43_'+name+'_'+mode+'_eff',Image.open(p).convert('RGBA'))
image('43_pointer',Image.open(args.bdb/'res/effect/player_pointer.png').convert('RGBA'))
image('41_pointer',Image.open(ROOT/'Resources/ports/theis/res/effect/player_pointer.png').convert('RGBA'))
image('43_particles',Image.open(args.bdb/'src/res/particles.png').convert('RGBA'))
shutil.copyfile(args.bdb/'res/effect/player_death_ef.psi',out/'43_death.psi')
if args.theis:
    image('41_particles',Image.open(args.theis/'src/res/particles.png').convert('RGBA'))
    shutil.copyfile(args.theis/'THlib/player/player_death_ef.psi',out/'41_death.psi')
(ROOT/'THlib/native_player_visual_data.lua').write_text('-- 原作无损图集、切片与动画参数，由export_source_visuals.py生成。\nreturn '+lua(data)+'\n')
(ROOT/'tools/native-player-tests/visual_sources.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n')
print(len(data['images']),'原图／切片，',len(data['players']),'机体，',len(clips),'Unity动画')

# 复用原CrazyStorm编译器导出79..82，不用宿主粒子替代原作死亡演出。
s=importlib.util.spec_from_file_location('death_export',ROOT/'tools/th39-tests/export_background.py')
m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
ex=m.BackgroundExport(None,args.part3)
for n in ('79','80','81','82'):ex.pattern(n,'e',m.SCENES)
(ROOT/'mod/GAME/th39/scenes/death.lua').write_text('return '+lua(ex.textures)+'\n')
