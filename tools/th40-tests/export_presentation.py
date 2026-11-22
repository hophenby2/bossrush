#!/usr/bin/env python3
"""补导夏夜祭原作阶段音效、蓄力入口和曲名贴图，不重写弹幕数据。"""
import argparse
import hashlib
import json
from pathlib import Path
import re
from PIL import Image

ROOT=Path(__file__).resolve().parents[2]


def lua(v):
    if isinstance(v,dict):return '{'+','.join('['+lua(k)+']='+lua(x) for k,x in v.items())+'}'
    if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
    return 'nil' if v is None else json.dumps(v,ensure_ascii=False)


def close(s,start,left='{',right='}'):
    depth=1;quoted=False;escaped=False
    for i in range(start+1,len(s)):
        c=s[i]
        if quoted:
            if escaped:escaped=False
            elif c=='\\':escaped=True
            elif c=='"':quoted=False
        elif c=='"':quoted=True
        elif c==left:depth+=1
        elif c==right:
            depth-=1
            if depth==0:return i
    raise ValueError('原代码括号未闭合')


def body(s,anchor):
    start=s.index('{',s.index(anchor));return s[start+1:close(s,start)]


def condition(s,position):
    guards=[]
    for match in re.finditer(r'\bif\s*\(',s):
        start=s.index('(',match.start());end=close(s,start,'(',')');brace=s.find('{',end)
        if brace<0 or s[end+1:brace].strip() or not brace<position<close(s,brace):continue
        text=s[start+1:end]
        text=re.sub(r'\((?:int|float|double)\)','',text)
        text=re.sub(r'(?<=\d)f\b','',text)
        text=text.replace('base.Time','t').replace('base.Difficulty','3')
        for name,n in [('Easy',0),('Normal',1),('Hard',2),('Lunatic',3)]:text=text.replace('DifficultLevel.'+name,str(n))
        text=text.replace('base.Boss.OnAction','o.action').replace('base.Boss.HealthPoint','o.hp')
        text=text.replace('&&',' and ').replace('||',' or ').replace('!=','~=')
        text=re.sub(r'!(?!=)','not ',text)
        assert 'base.' not in text,('未转换的表现条件',text)
        guards.append('('+text+')')
    return ' and '.join(guards) or 'true'


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--source',type=Path,required=True)
    ap.add_argument('--game',type=Path,required=True)
    args=ap.parse_args();hashes={};callbacks={};openings={};titles={}
    art=ROOT/'Resources/th40/presentation';art.mkdir(exist_ok=True)
    def read(name):
        p=args.source/(name+'.cs');raw=p.read_bytes();hashes[p.name]=hashlib.sha256(raw).hexdigest();return raw.decode('utf-8-sig')
    def compile(s):
        actions=[]
        for m in re.finditer(r'(?:base\.)?StageData\.SoundPlay\("([^"]+)"\)',s):
            actions.append((m.start(),'N.sound('+lua(m[1])+')'))
        for m in re.finditer(r'new Emitter(Save|GiveOut)Enegy3D\([^;]+?Color\.(FromArgb\(([^)]+)\)|(\w+))\)',s):
            rgb=[int(n.strip()) for n in m[3].split(',')] if m[3] else {
                'Green':[0,128,0],'Yellow':[255,255,0],'Red':[255,0,0],'Purple':[128,0,128],
                'SkyBlue':[135,206,235],'White':[255,255,255]}[m[4]]
            actions.append((m.start(),'N.presentation.energy(o.cx-320,240-o.cy,'+lua(m[1]=='Save')+','+lua(rgb)+')'))
        return '\n'.join('if '+condition(s,pos)+' then '+action+' end' for pos,action in sorted(actions))
    phases=json.loads((ROOT/'mod/GAME/th40/phase_manifest.json').read_text(encoding='utf8'))['phases']
    for p in phases:
        if p['kind']=='road':continue
        sources=list((p.get('variants') or {p['source']:True}).keys())
        for source in sources:
            if source in callbacks:continue
            name,_,method=source.partition('.');code=read(name)
            if method:
                stage=body(code,'private void '+method+'()')
                stage=body(stage,'if (!base.OnSpell)')
                callbacks[source]=compile(stage)
            else:
                callbacks[source]=compile(body(code,'public override void Shoot()'))
                openings[source]=compile(body(code,'public '+name+'('))
    sheets={}
    for path in (args.game/'Image').rglob('*.txt'):
        try:text=path.read_text(encoding='utf-8-sig')
        except UnicodeDecodeError:text=path.read_text(encoding='gb18030')
        for row in text.splitlines():
            values=row.split()
            if len(values)>=7:sheets[values[0]]=(path,*values[1:7])
    for chapter in ['01','02','03','04','05','06','Ex']:
        code=read('GameState_SSS'+chapter)
        match=re.search(r'new MusicTitle\(base.StageData, "([^"]+)"',code);name=match[1]
        sheet,*values=sheets[name];x,y,w,h,ox,oy=map(int,values);png=sheet.with_suffix('.png')
        image=Image.open(png).crop((x,y,x+w,y+h));target=art/('music'+chapter+'.png');image.save(target)
        hashes[str(sheet.relative_to(args.game))]=hashlib.sha256(sheet.read_bytes()).hexdigest()
        hashes[str(png.relative_to(args.game))]=hashlib.sha256(png.read_bytes()).hexdigest()
        key='EX' if chapter=='Ex' else str(int(chapter))
        titles[key]={'file':target.relative_to(ROOT).as_posix(),'size':[w,h],'name':name}
    for name in ['MusicTitle','EmitterSaveEnegy3D','EmitterGiveOutEnegy3D','Particle3D1','BaseParticle3D']:read(name)
    lines=['-- 原作 C# 的音效和视觉调用；攻击脚本保留在 phases.lua。','return {titles='+lua(titles)+',step={']
    lines+=['['+lua(key)+']=function(o,t,N)\n'+fn+'\nend,' for key,fn in sorted(callbacks.items())]
    lines+=['},opening={']
    lines+=['['+lua(key)+']=function(o,t,N)\n'+fn+'\nend,' for key,fn in sorted(openings.items())]
    lines+=['}}']
    (ROOT/'mod/GAME/th40/presentation_data.lua').write_text('\n'.join(lines)+'\n',encoding='utf8',newline='\n')
    (ROOT/'mod/GAME/th40/presentation_sources.json').write_text(json.dumps(dict(source_sha256=hashes,
        callbacks=len(callbacks),openings=len(openings),titles=titles),ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print('阶段表现',len(callbacks),'开卡',len(openings),'原图曲名',len(titles))


if __name__=='__main__':main()
