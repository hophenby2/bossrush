#!/usr/bin/env python3
"""离线导出春雪篇完整背景时间轴、无简化模型及原尺寸纹理。"""
import argparse, hashlib, io, json, re, struct
from pathlib import Path
from Crypto.Cipher import DES3
from PIL import Image
from xnb_model import Reader
from export import lua,atom

ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--content',type=Path,required=True)
ap.add_argument('--unpacked-models',type=Path,required=True,help='XNB解压后的Model目录；模型本身不重采样')
args=ap.parse_args()
dest=ROOT/'mod/GAME/th37/scenes';models=dest/'models';models.mkdir(exist_ok=True)
assets=ROOT/'Resources/th37/scene';hashes={};names=set();textures=set();stats={}
def source(p):
    b=p.read_bytes();hashes[str(p)]=hashlib.sha256(b).hexdigest();return b
def texture(path):
    b=source(path);assert b[:3]==b'XNB' and not b[5]&128
    at=10
    def var():
        nonlocal at
        n=s=0
        while True:
            x=b[at];at+=1;n|=(x&127)<<s;s+=7
            if x<128:return n
    assert var()==1
    size=var();assert b'Texture2DReader' in b[at:at+size];at+=size+4
    assert var()==0 and var()==1
    fmt,w,h,mips,size=struct.unpack_from('<5I',b,at);raw=b[at+20:at+20+size]
    if fmt==0:return Image.frombytes('RGBA',(w,h),raw)
    code={4:b'DXT1',5:b'DXT3',6:b'DXT5'}[fmt]
    hdr=struct.pack('<7I11I2I4s5I5I',124,0x81007,h,w,size,0,0,*([0]*11),32,4,code,0,0,0,0,0,0x1000,0,0,0,0)
    return Image.open(io.BytesIO(b'DDS '+hdr+raw)).convert('RGBA')
allowed=set('LightSetting Shake SetModel PrepareModel ActiveModel AnimateModelUV ChangeView ChangeTarget SetRunningStep SetRunningStepX SetRunningStepY SetLoopDistance SetLoopOffset SetStopLoop SetWaitBoss SetPraticleLauncher SetPraticle SetColor SetAlpha Open Fadein Fadeout DelModel PutModelOnFront PutModelOnNextLoop ResetModelOrder ClearLoopStep ClearRunningStep UntilModelComing UntilBGMSwitch ChangeField'.split())
for chapter in range(1,9):
    p=args.content/'Data'/f'{chapter}1.xna';b=DES3.new(bytes.fromhex('4D3C3F50123A4577898C758F7E9E1187'),DES3.MODE_ECB).decrypt(source(p));rows=b[:-b[-1]].decode('utf-8-sig').splitlines()
    events=[]
    for line in rows:
        if line.startswith('UsingModel('):names.update(line[11:-1].split(','));continue
        if line in ('','End'):continue
        m=re.fullmatch(r'\[(\d+):(\d+):(\d+)\](\w+)(?:\((.*)\))?',line);assert m,line
        mm,ss,ff,op,raw=m.groups();assert op in allowed,op
        a=[atom(s) for s in raw.split(',')] if raw else []
        events.append([int(mm)*3600+int(ss)*60+int(ff),op,*a])
    (dest/f'{chapter}.lua').write_text('-- 原作Data背景控制轴；时间由背景自己的等待条件推进。\nreturn '+lua(events)+'\n')
    stats[chapter]=len(events)
for name in sorted(names,key=int):
    path=args.unpacked_models/(name+'.xnb');source(path)
    parts=[];triangles=0
    for mesh,tex,alpha,vertices in Reader(path).parse():
        if not tex:continue
        tex=tex.replace('\\','/').rsplit('/',1)[-1];textures.add(tex)
        parts.append([tex,alpha,vertices.reshape(-1,5).ravel().tolist()]);triangles+=len(vertices)
    (models/(name+'.lua')).write_text('-- 原始三角形、UV和材质，未简化。\nreturn '+lua(parts)+'\n')
    stats['model_'+name]=triangles
for tex in sorted(textures):texture(args.unpacked_models/(tex+'.xnb')).save(assets/(tex+'.png'),optimize=True)
manifest={'models':len(names),'textures':len(textures),'statistics':stats,'sha256':hashes}
(dest/'sources.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
print(len(names),'模型，',len(textures),'原尺寸纹理，',sum(stats[n] for n in range(1,9)),'背景命令')
