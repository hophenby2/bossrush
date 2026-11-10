"""导出风神录出生子程序中的原始掉落配置；同步调用继承主掉落，dropClear只清附加表。"""
from pathlib import Path
import importlib.util
import argparse
import re

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('visual',ROOT/'tools/th3x-tests/export_visual_ecl.py')
visual=importlib.util.module_from_spec(spec);spec.loader.exec_module(visual)
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--ecl',type=Path,default=Path('E:/workspace/.bossrush-validation/original-anm/ecl/10'))
folder=ap.parse_args().ecl
common=visual.read_subs(folder/'default.decl')
out={}
for path in sorted(folder.glob('stage*.decl')):
    subs={**common,**visual.read_subs(path)}
    incoming={}
    for instructions in subs.values():
        for _,op,args in instructions:
            if op not in (256,257,260,261,265,266,267,268,270,271):continue
            fields=[s.strip() for s in args.split(',')]
            if not fields[0].startswith('"'):continue
            try:reward,drop=int(fields[-2]),int(fields[-1])
            except ValueError:continue
            incoming.setdefault(fields[0].strip('"'),set()).add((reward,drop))
    def expand(name,seen=()):
        if name in seen:return []
        result=[]
        for time,op,args in subs.get(name,[]):
            if time>0:break
            if op==11:
                called=re.match(r'"([^"]+)"',args)
                if called:result.extend(expand(called[1],(*seen,name)))
            elif op in (326,327,328,330):
                try:values=[float(s.strip().rstrip('f')) for s in args.split(',') if s.strip()]
                except ValueError:continue
                result.append([op,*values])
        return result
    for name in subs:
        requests=incoming.get(name,set())
        reward,main=next(iter(requests)) if len(requests)==1 else (0,0)
        override=False
        extra,area={},[32,32]
        for op,*args in expand(name):
            if op==326:extra={}
            elif op==327:extra[int(args[0])]=int(args[1])
            elif op==328:area=args
            elif op==330:main=int(args[0]);override=True
        out[path.stem+':'+name]={'main':main,'main_override':override,'extra':extra,'area':area,'score':reward}
target=ROOT/'mod/GAME/original/players/th10_drops.lua'
rows=[f'  [{visual.module.lua(key)}]={visual.module.lua(value)},' for key,value in out.items()]
target.write_text('-- 原作出生时的主掉落/附加掉落、散布范围与击破分；自动导出。\nreturn {\n'+'\n'.join(rows)+'\n}\n','utf8',newline='\n')
print('风神录原作出生掉落配置：',len(out))
