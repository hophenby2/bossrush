#!/usr/bin/env python3
"""离线导出雪莲华Boss prefab、Animator状态图、Sprite切片和开符立绘；不改动原工程。"""
import argparse, hashlib, json, math
from functools import cache
from pathlib import Path
import yaml, re, struct
import sys
sys.dont_write_bytecode=True
from PIL import Image
from export_background import Source, doc, fid, xyz, rgba, lua, ROOT, HEADER

ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('assets',type=Path)
args=ap.parse_args()
source=Source(args.assets.resolve())
out=ROOT/'mod/GAME/th38'
art=ROOT/'Resources/th38/actors';art.mkdir(exist_ok=True)
sprites={};controllers={};profiles={};phases={};portraits={};backgrounds={};hashes={}
bossNames=['雪珂','暗华 美夜香','莉帕斯·缇米蒂丝·白雪','荼靡 结音 / 墨樱 初月','万光 绘照','妙严宫 雪华','蚀神 星罗']

def record(path):
    hashes[path.relative_to(source.root).as_posix()]=hashlib.sha256(path.read_bytes()).hexdigest()

@cache
def documents(path):
    record(path)
    return {i:(k,v) for k,i,v in doc(path,{1,4,74,95,114,212,1101,1102,1107})}

@cache
def sprite(guid,index):
    path=source.guids[guid];record(path)
    meta=path.with_name(path.name+'.meta');record(meta)
    ti=yaml.load(meta.read_text(),Loader=yaml.CSafeLoader)['TextureImporter']
    with Image.open(path) as im:
        entries=ti.get('spriteSheet',{}).get('sprites') or []
        if entries:
            names={int(next(iter(v['first'].values()))):v['second'] for v in ti['internalIDToNameTable']}
            item=next(x for x in entries if x['name']==names[index])
            r=item['rect'];pivot=item['pivot']
            x,y,w,h=r['x'],r['y'],r['width'],r['height']
            cropped=im.crop((x,im.height-y-h,x+w,im.height-y))
        else:
            w,h=im.size;cropped=im.copy();pivot=ti.get('spritePivot',{'x':.5,'y':.5})
        key=guid+'_'+str(index)
        cropped.save(art/(key+'.png'))
    sprites[key]=dict(file=key+'.png',w=w,h=h,pivot=[w*pivot['x'],h*(1-pivot['y'])],scale=48/ti.get('spritePixelsToUnits',100))
    return key

def sprite_ref(ref):
    return sprite(ref['guid'],fid(ref)) if fid(ref) and ref.get('guid') else None

@cache
def controller(path):
    key=path.relative_to(source.root).as_posix();d=documents(path)
    result={'states':{}}
    for i,(kind,state) in d.items():
        if kind==1107:
            if fid(state.get('m_DefaultState')):result['default']=fid(state['m_DefaultState'])
        if kind!=1102:continue
        motion=source.path(state['m_Motion'])
        if not motion:continue
        c=next(v for k,v in documents(motion).values() if k==74)
        tracks=[]
        for curve in c.get('m_PPtrCurves') or []:
            tracks.append(dict(path=curve.get('path') or '',keys=[[k['time'],sprite_ref(k['value'])] for k in curve['curve'] or []]))
        floats=[]
        for curve in c.get('m_FloatCurves') or []:
            floats.append(dict(path=curve.get('path') or '',attribute=curve['attribute'],keys=[[k['time'],k['value'],k.get('inSlope',0),k.get('outSlope',0)] for k in curve['curve']['m_Curve']]))
        transitions=[]
        for ref in state['m_Transitions']:
            t=d[fid(ref)][1]
            transitions.append(dict(to=fid(t['m_DstState']),exit=t.get('m_HasExitTime',0),exitTime=t.get('m_ExitTime',1),conditions=[[x['m_ConditionEvent'],x['m_ConditionMode'],x.get('m_EventTreshold',0)] for x in t['m_Conditions'] or []]))
        setting=c['m_AnimationClipSettings']
        result['states'][i]=dict(name=state['m_Name'],speed=state['m_Speed'],length=setting['m_StopTime'],loop=setting.get('m_LoopTime',0),tracks=tracks,floats=floats,transitions=transitions)
    controllers[key]=result
    return key

def nodes(path,only=None):
    d=documents(path);output=[]
    gos={i:v for i,(k,v) in d.items() if k==1}
    transforms={fid(v['m_GameObject']):(i,v) for i,(k,v) in d.items() if k==4}
    byid={i:v for i,v in transforms.values()}
    def tr(i):
        t=byid[i];p=t['m_LocalPosition'];s=t['m_LocalScale'];q=t['m_LocalRotation']
        angle=math.degrees(2*math.atan2(q['z'],q['w']))
        parent=fid(t['m_Father'])
        if parent and parent in byid:
            x,y,sx,sy,a=tr(parent);c=math.cos(math.radians(a));sn=math.sin(math.radians(a))
            return x+p['x']*sx*c-p['y']*sy*sn,y+p['x']*sx*sn+p['y']*sy*c,sx*s['x'],sy*s['y'],a+angle
        # Boss本体的位置由弹幕控制；立绘prefab的位置属于原作屏幕坐标。
        return (0 if only else p['x']),(0 if only else p['y']),s['x'],s['y'],angle
    for go,g in gos.items():
        if only and g['m_Name'] not in only:continue
        comps=[d[fid(x['component'])] for x in g['m_Component'] if fid(x['component']) in d]
        sr=next((v for k,v in comps if k==212),None)
        if not sr:continue
        anim=next((v for k,v in comps if k==95),None)
        scripts={source.path(v['m_Script']).stem:v for k,v in comps if k==114 and source.path(v['m_Script'])}
        x,y,sx,sy,a=tr(transforms[go][0])
        n=dict(name=g['m_Name'],sprite=sprite_ref(sr['m_Sprite']),x=x,y=y,sx=sx,sy=sy,rotation=a,color=rgba(sr['m_Color']),order=sr['m_SortingOrder'],flip=[sr['m_FlipX'],sr['m_FlipY']])
        if anim and source.path(anim['m_Controller']):n['controller']=controller(source.path(anim['m_Controller']))
        for script,fields in [('Boss_move_doudong',['A','time_start','time_zhouqi']),('Lihuimove1',['yidongx','yidongy']),('Tongyong_xuanzhuan',['zhuansu']),('Tongyong_death',['time'])]:
            if script in scripts:n[script]={k:scripts[script][k] for k in fields}
        if n.get('sprite') or n.get('controller'):output.append(n)
    return sorted(output,key=lambda x:x['order'])

for path in sorted((source.root/'Resources/xuelianhua/prefab/boss').glob('*/*.prefab')):
    if path.parent.name not in ('l','exa') or '_test' in path.name:continue
    d=documents(path)
    move=next((v for k,v in d.values() if k==114 and 'double_boss2' in v),None)
    inside=next((v for k,v in d.values() if k==114 and 'lihui' in v),None)
    if not move or not inside:continue
    ns=nodes(path,{'boss_sprite','yinying'})
    if not ns:continue
    key=path.relative_to(source.root).as_posix()
    profiles[key]=dict(nodes=ns,mirror=move.get('DUICHEN',0),jump=move.get('jump',0))
    nameplate=source.path(inside.get('boss_name_start',{}))
    if nameplate:
        number=re.fullmatch(r'boss_name([1-7])',nameplate.stem)
        assert number,('未知原作姓名条',nameplate)
        profiles[key]['name']=bossNames[int(number[1])-1]
        record(nameplate);record(nameplate.with_suffix('.png'))
    # 副体的Boss_in路径是未使用的占位数据，实际弹幕/阶段由主体现有Bossmove同步。
    if move['double_boss2']:continue
    keys=[inside['path']]+move['path'];pictures=[inside['lihui']]+move['danmu_lihui']
    block=next(raw for _,_,raw in HEADER.findall(path.read_text()) if 'double_boss2:' in raw)
    raw=re.search(r'^  fuka_num: *(.*)$',block,re.M)[1]
    numbers=[inside['fuka_num']]+(list(struct.unpack('<'+'i'*(len(raw)//8),bytes.fromhex(raw))) if raw else [])
    for phase,pic,number in zip(keys,pictures,numbers):
        phase=(phase or '').replace('xuelianhua/danmaku/','').replace('//','/')
        if not phase:continue
        index=2 if move['double_boss2'] else 1
        phases.setdefault(phase,{})[index]=key
        if not move['double_boss2']:phases[phase]['number']=number
        pf=source.path(pic)
        if pf and pf.relative_to(source.root).as_posix() not in portraits:
            pk=pf.relative_to(source.root).as_posix();portraits[pk]=nodes(pf)
        if pf and not move['double_boss2']:phases[phase]['portrait']=pf.relative_to(source.root).as_posix()
# Boss_creat按原场景相邻tick创建主副体；同时保留自机分支的boss_B对应关系。
for scene in sorted((source.root/'Scene').glob('Stage*.unity')):
    spawns=[v for _,(k,v) in documents(scene).items() if k==114 and 'doubleboss' in v]
    for secondary in spawns:
        if not secondary['doubleboss']:continue
        for field,index in [('boss_L',None),('boss_EXA',None),('boss_B',3)]:
            def reference(row):
                value=row.get(field,{})
                return value[index] if index is not None and len(value)>index else value if index is None else {}
            path=source.path(reference(secondary))
            if not path:continue
            key=path.relative_to(source.root).as_posix()
            if key not in profiles:continue
            move=next((v for k,v in documents(path).values() if k==114 and 'double_boss2' in v),None)
            if not move or not move['double_boss2']:continue
            primary=next((v for v in spawns if v['time_in']==secondary['time_in']-1),None)
            assert primary,(scene,key,'副体缺少前一tick的主Boss')
            main=source.path(reference(primary));assert main,(scene,key,'主Boss引用缺失')
            main=main.relative_to(source.root).as_posix()
            matched=0
            for phase in phases.values():
                if phase.get(1)==main:phase[2]=key;matched+=1
            assert matched,(scene,key,main,'主Boss阶段缺失')
# 符卡背景由Boss_fuka_creat按fuka_num动态生成，不属于Stage*.unity场景。
for path in sorted((source.root/'Resources/xuelianhua/prefab/boss/fuka_beijing').glob('fuka*.prefab')):
    d=documents(path);trs=[(i,v) for i,(k,v) in d.items() if k==4]
    indexes={i:n+1 for n,(i,v) in enumerate(trs)}
    go_tr={fid(v['m_GameObject']):indexes[i] for i,v in trs}
    script_tr={i:go_tr.get(fid(v.get('m_GameObject'))) for i,(k,v) in d.items() if k==114}
    ns=[]
    for i,t in trs:
        go=fid(t['m_GameObject']);g=d[go][1]
        comps=[d[fid(x['component'])] for x in g['m_Component'] if fid(x['component']) in d]
        scripts={}
        for k,v in comps:
            if k!=114:continue
            sp=source.path(v['m_Script'])
            if not sp:continue
            fields={key:value for key,value in v.items() if not key.startswith('m_')}
            for key,value in list(fields.items()):
                if isinstance(value,dict) and 'fileID' in value:fields[key]=indexes.get(fid(value),script_tr.get(fid(value),0))
                elif isinstance(value,list) and value and isinstance(value[0],dict) and 'fileID' in value[0]:fields[key]=[indexes.get(fid(x),script_tr.get(fid(x),0)) for x in value]
            fields['enabled']=v.get('m_Enabled',1)
            scripts[sp.stem]=fields;record(sp)
        q=t['m_LocalRotation']
        n=dict(name=g['m_Name'],parent=indexes.get(fid(t['m_Father']),0),pos=xyz(t['m_LocalPosition']),scale=xyz(t['m_LocalScale']),
            rotation=math.degrees(math.atan2(2*(q['w']*q['z']+q['x']*q['y']),1-2*(q['y']**2+q['z']**2))),
            scripts=scripts,active=g.get('m_IsActive',1))
        sr=next((v for k,v in comps if k==212),None)
        if sr:
            n.update(sprite=sprite_ref(sr['m_Sprite']),color=rgba(sr['m_Color']),order=sr['m_SortingOrder'])
            mat=source.path(sr['m_Materials'][0]) if sr['m_Materials'] else None
            if mat:
                shader=next(doc(mat,{21}))[2]['m_Shader'];sp=source.path(shader)
                n['blend']='mul+add' if sp and 'add' in sp.stem.lower() or fid(shader)==200 else 'mul+rev' if sp and 'fanse' in sp.stem.lower() else ''
        ns.append(n)
    backgrounds[path.stem]=ns
# 按原switch与fuka_name prefab的数组顺序绑定，不用关卡号猜图。
creator=source.root/'Resources/xuelianhua/prefab/boss/fuka_name.prefab'
creation=next(v for k,v in documents(creator).values() if k==114 and 'fuka_beijing' in v)
keys=[source.path(ref).stem for ref in creation['fuka_beijing']]
code=(source.root/'Scripts/Boss_fuka_creat.cs').read_text()
spellMap={}
import re
for block in code.split('break;'):
    match=re.search(r'Instantiate\(fuka_beijing\[(\d+)\]',block)
    if match:
        for number in re.findall(r'case (\d+):',block):spellMap[int(number)]=keys[int(match[1])]
record(source.root/'Scripts/Boss_fuka_creat.cs')
for name in ['Bossmove','Boss_move_doudong','Boss_in','Lihuimove1']:
    record(source.root/'Scripts'/(name+'.cs'))
record(source.root/'Scripts/Anniu_xuanzhong.cs')
(out/'actors.lua').write_text('-- 原作prefab、AnimatorController和AnimationClip离线参数。\nreturn '+lua(dict(sprites=sprites,controllers=controllers,profiles=profiles,phases=phases,portraits=portraits,backgrounds=backgrounds,spellMap=spellMap))+'\n')
(out/'visual_sources.json').write_text(json.dumps(dict(sprites=len(sprites),profiles=len(profiles),phases=len(phases),portraits=len(portraits),sha256=hashes),ensure_ascii=False,indent=2)+'\n')
print(len(profiles),'Boss prefabs,',len(phases),'phases,',len(sprites),'sprites,',len(portraits),'portraits')
