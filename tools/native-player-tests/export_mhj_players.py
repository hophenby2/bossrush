#!/usr/bin/env python3
"""导出两作幕华祭的原始装备/自机弹/Bomb 逻辑，以及永夜篇武器数据。"""
import argparse,hashlib,importlib.util,json,subprocess,sys,tempfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--spring',type=Path,required=True);ap.add_argument('--night',type=Path,required=True)
ap.add_argument('--night-content',type=Path,required=True);ap.add_argument('--parser-lib',type=Path,required=True)
args=ap.parse_args();dest=ROOT/'mod/GAME/ports/mhj/native_players';dest.mkdir(parents=True,exist_ok=True)
hashes={}
for name,src in [('spring',args.spring),('night',args.night)]:
    sources=[src/(s+'.cs') for s in ('EquipShoot','Equipment','SelfBarrage','SingleBomb')]
    if name=='night':sources.extend(src/(s+'.cs') for s in ('AnimationClip','AnimationMachine'))
    subprocess.run([sys.executable,str(Path(__file__).with_name('csharp_logic.py')),'--parser-lib',str(args.parser_lib),'--out',str(dest/(name+'.lua')),*map(str,sources)],check=True)
    for p in sources:hashes[str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
    p=src/'SpecialSystem.cs'
    subprocess.run([sys.executable,str(Path(__file__).with_name('csharp_logic.py')),'--parser-lib',str(args.parser_lib),'--out',str(dest/(name+'_special.lua')),str(p)],check=True)
    hashes[str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
    if name=='night':
        for kind,methods in [('Curve','Update,Rotate'),('CardDisplay','CardDisplay,TextureUpdate,Update'),('Character','Character@5,Update@2,Position,ResetPos,SetPosition,DrawSprite,DrawEquip,IsPositionInLight,SelectChaseTarget,Petrify,Relieve,ClearNegativeStatus,GettingOld,ReturnYouth,Control,Lockdown,FreeControl,NativeNegativeUpdate')]:
            p=src/(kind+'.cs')
            target=dest/('night_'+kind.lower()+'.lua')
            if kind=='Character':
                # 从原 Update 连续截出控制/石化段；Bomb 已由宿主的同一原始实例更新，避免执行两次。
                text=p.read_text();start=text.index('\t\tif (CBanShoot && !controling)')
                end=text.index('\t\tf++;',start);body=text[start:end]
                first=body.index('\t\t\tif (bomb != null && !bomb.Die)')
                last=body.index('\t\t\trelieveTime++;',first)
                body=body[:first]+body[last:]
                derived=text.rsplit('}',1)[0]+'public void NativeNegativeUpdate() {\n'+body+'\n}\n}'
                with tempfile.TemporaryDirectory(prefix='bossrush-night-status-') as temp:
                    copy=Path(temp)/p.name;copy.write_text(derived)
                    subprocess.run([sys.executable,str(Path(__file__).with_name('csharp_logic.py')),'--parser-lib',str(args.parser_lib),'--methods',methods,'--out',str(target),str(copy)],check=True)
                target.write_text(target.read_text().replace(hashlib.sha256(derived.encode()).hexdigest(),hashlib.sha256(p.read_bytes()).hexdigest()))
            else:
                subprocess.run([sys.executable,str(Path(__file__).with_name('csharp_logic.py')),'--parser-lib',str(args.parser_lib),'--methods',methods,'--out',str(target),str(p)],check=True)
            hashes[str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
spec=importlib.util.spec_from_file_location('art',Path(__file__).with_name('export_art.py'));art=importlib.util.module_from_spec(spec);spec.loader.exec_module(art)
spec=importlib.util.spec_from_file_location('spring',ROOT/'tools/th37-tests/export.py');export=importlib.util.module_from_spec(spec);spec.loader.exec_module(export)
src=args.night_content/'Data/10.xna';hashes[str(src)]=hashlib.sha256(src.read_bytes()).hexdigest()
rows=iter(art.read(src,1).decode('utf-8-sig').splitlines());data={}
fields=('mainSpeed','otherSpeed1','otherSpeed2','main','part','skill','other1','other2','other3','other4')
for name in ('reimu','marisa','sanae','mokou'):
    h=list(map(float,next(rows).split(',')));d={'header':h}
    for mode in ('A','B'):d[mode]=dict(zip(fields,map(float,next(rows).split(','))))
    for _ in range(int(h[0])):next(rows)
    data[name]=d
(dest/'night_data.lua').write_text('-- 原作 Data/10.xna 的移动、Bomb 与 A/B 武器数值。\nreturn '+export.lua(data)+'\n')
for i in range(1,6):
    src=args.night_content/'Graphics/List'/('selfbarrage'+str(i)+'.xna');hashes[str(src)]=hashlib.sha256(src.read_bytes()).hexdigest()
    (ROOT/'Resources/native_players/source'/('39_selfbarrage'+str(i)+'.png')).write_bytes(art.read(src,0))
src=args.night_content/'Data/7.xna';hashes[str(src)]=hashlib.sha256(src.read_bytes()).hexdigest()
raw=art.read(src,1);settings=[list(map(int,line.split(','))) for line in raw.decode('utf-16' if raw.startswith((b'\xff\xfe',b'\xfe\xff')) else 'utf-8-sig').splitlines()]
(dest/'night_settings.lua').write_text('-- 原作 Data/7.xna 的灯笼等级、能量与涨槽规则。\nreturn '+export.lua(settings)+'\n')
for name in ('spscore','bosslist'):
    src=args.night_content/'Graphics/List'/(name+'.xna');hashes[str(src)]=hashlib.sha256(src.read_bytes()).hexdigest()
    (ROOT/'Resources/native_players/source'/('39_'+name+'.png')).write_bytes(art.read(src,0))
(dest/'sources.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n')
