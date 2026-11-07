"""从原作 ECL 保留动画指令；使魔的交互和运动仍由现有逐条移植执行。"""
from pathlib import Path
import argparse
import importlib.util
import json
import re

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('anm_export',Path(__file__).with_name('export_original_anm.py'))
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)

def read_subs(path):
    text=path.read_text(encoding='utf-8',errors='replace')
    result={}
    for m in re.finditer(r'(?:sub|void) (\w+)\([^)]*\)\s*\{([^}]+)\}',text):
        time=0;instructions=[]
        for line in m[2].splitlines():
            tm=re.search(r'^\+(\d+):',line)
            if tm: time+=int(tm[1])
            elif re.fullmatch(r'\d+:',line.strip()): time=int(line.strip()[:-1])
            ins=re.search(r'ins_(\d+)\((.*)\);',line)
            if ins:
                instructions.append((time,int(ins[1]),ins[2]))
        result[m[1]]=instructions
    return result

def export(cache):
    output={}
    for game,folder,ops in [(8,cache/'ecl'/'8',set(range(54,63))|{79,80,81}),
                            (95,Path(r'E:\workspace\.bossrush-validation\source-assets\th095'),set(range(54,63))|{79,80,81}),
                            (7,cache/'ecl'/'7',{95,96,97,98})]:
        profiles={}
        for path in folder.glob('*.decl'):
            subs=read_subs(path)
            def expanded(name,seen=()):
                if name in seen: return []
                result=[]
                for time,op,args in subs.get(name,[]):
                    result.append((time,op,args))
                    if op==(41 if game==7 else 52) and re.fullmatch(r'\d+',args.strip()):
                        for ct,co,ca in expanded('Sub'+args.strip(),(*seen,name)):
                            if co in ops: result.append((time+ct,co,ca))
                return result
            for sub in subs:
                instructions=expanded(sub)
                events=[];unresolved=[];loop=None
                for time,op,args in instructions:
                    if op in ops:
                        if '[' in args: unresolved.append([time,op,args]);continue
                        values=[]
                        try: values=[int(a.strip()) for a in args.split(',') if a.strip()]
                        except ValueError: unresolved.append([time,op,args]);continue
                        events.append([time,op,*values])
                    elif op==4 and game in (8,95):
                        parts=args.split(',')
                        if len(parts)==2 and re.fullmatch(r'\d+',parts[0].strip()) and int(parts[0])<time:
                            loop=[int(parts[0]),time]
                if events:
                    events.sort(key=lambda row:row[0])
                    key=path.stem+':'+(sub[3:] if sub.startswith('Sub') else sub)
                    profiles[key]={'events':events}
                    if unresolved: profiles[key]['unresolved']=unresolved
                    if loop: profiles[key]['loop']=loop
        output[game]=profiles
    # 风神录的命名子程序把 ANM 编号作为同步调用参数传递；保留原参数，不能用弹色反推敌机颜色。
    common=read_subs(cache/'ecl'/'10'/'default.decl')
    profiles={}
    for path in (cache/'ecl'/'10').glob('stage*.decl'):
        subs={**common,**read_subs(path)}
        def argument(token,params):
            token=re.sub(r'^_[SFD]{2}\s+','',token.strip())
            if re.fullmatch(r'\[-?\d+\]',token):
                pos=int(token[1:-1]);return params.get(pos,{'arg':pos})
            try:return int(token)
            except ValueError:return None
        def visual(name,params=None,seen=()):
            if name in seen:return []
            events=[];params=params or {}
            for time,op,args in subs.get(name,[]):
                values=[a.strip() for a in args.split(',')]
                if op in (11,15) and values and values[0].startswith('"'):
                    called=json.loads(values[0])
                    passed={i*4:argument(a,params) for i,a in enumerate(values[1:])}
                    events.extend([[time+c[0],*c[1:]] for c in visual(called,passed,(*seen,name))])
                elif op in (258,259,262,269):
                    parsed=[argument(a,params) for a in values]
                    if all(a is not None for a in parsed):events.append([time,op,*parsed])
            return events
        for name in subs:
            events=visual(name)
            profiles[path.stem+':'+name]={'events':sorted(events,key=lambda c:c[0])}
    output[10]=profiles
    target=ROOT/'mod'/'GAME'/'original'/'visual_ecl.lua'
    target.write_text('-- 原作 ECL 的动画指令，由 tools/th3x-tests/export_visual_ecl.py 导出。\nreturn '+module.lua(output)+'\n',encoding='utf-8')
    print({g:len(p) for g,p in output.items()})
    return output

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--cache',type=Path,default=Path(r'E:\workspace\.bossrush-validation\original-anm'))
    export(ap.parse_args().cache)
