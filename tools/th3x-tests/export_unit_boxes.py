"""提取原作 ECL 子程序入口的常量判定框，供普通 LuaSTG 对象初始化使用。"""
import argparse
from pathlib import Path
import re

root=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--ecl',type=Path,required=True)
args=parser.parse_args()
lines=['-- 原作子程序入口的判定尺寸（全宽高）；export_unit_boxes.py 生成。',
       '-- inherited 项沿同一敌机的 CALL/中断/生命与计时回调传播；不沿生成敌机指令传播。','return {']
# 参数位置据 TH07 EclManager.cpp、TH08 EclRunHigh.inl；动态目标不猜测。
edges={7:{41:0,107:0,108:0,113:0,115:0,144:1,148:2},
       8:{52:0,126:0,130:0,133:2,134:1,135:1}}
for game in (7,8,10):
    lines.append('    [%d]={'%game)
    for path in sorted((args.ecl/str(game)).glob('*.decl')):
        source=path.read_text('utf-8',errors='replace')
        subs=dict(re.findall(r'(?:void|sub)\s+(\w+)\([^)]*\)\s*\{(.*?)\n\}',source,re.S))
        def th10_birth(name,seen=()):
            if name in seen:return {}
            prefix=re.split(r'\n\+\d+:',subs.get(name,''))[0]
            fields={}
            for op,arguments in re.findall(r'ins_(\d+)\((.*?)\);',prefix):
                if int(op)==11:
                    target=re.match(r'"([^"]+)"',arguments)
                    if target:fields.update(th10_birth(target[1],(*seen,name)))
                elif int(op) in (320,321):
                    size=re.fullmatch(r'\s*([-\d.]+)f,\s*([-\d.]+)f\s*',arguments)
                    if size:fields['damage' if int(op)==320 else 'contact']='{'+size[1]+','+size[2]+'}'
            return fields
        direct, bosses, graph = {}, set(), {}
        for name,body in subs.items():
            prefix=re.split(r'\n\+\d+:',body)[0]
            fields=[]
            if game==10:
                fields=[key+'='+value for key,value in th10_birth(name).items()]
            for i,op in enumerate([101] if game==7 else [77] if game==8 else [320,321]):
                if game==10:continue
                match=re.search(r'ins_'+str(op)+r'\(\s*([-\d.]+)f,\s*([-\d.]+)f',prefix)
                if match:
                    fields.append(('damage' if i==0 else 'contact')+'={'+match[1]+','+match[2]+'}')
            boss_op=99 if game==7 else 127 if game==8 else None
            if boss_op and re.search(r'ins_'+str(boss_op)+r'\(\d+\)',prefix):
                bosses.add(name)
            if fields:
                direct[name]=tuple(fields)
            graph[name]=set()
            for op,arguments in re.findall(r'ins_(\d+)\((.*?)\);',body):
                index=edges.get(game,{}).get(int(op))
                if index is None:
                    continue
                values=arguments.split(',')
                if len(values)>index and re.fullmatch(r'\s*\d+\s*',values[index]):
                    target='Sub'+values[index].strip()
                    if target in subs:
                        graph[name].add(target)
        reached={name:set() for name in subs}
        if game==8:
            # ECL里保留了未被时间轴生成的旧Boss入口（如二面Sub25），不能拿它污染实际继承。
            born=set()
            for body in re.findall(r'timeline\s+\w+\([^)]*\)\s*\{(.*?)\n\}',source,re.S):
                born.update('Sub'+n for n in re.findall(r'ins_[0-3]\(\s*\d+,\s*(\d+),',body))
            for body in subs.values():
                born.update('Sub'+n for n in re.findall(r'ins_9[0-4]\(\s*(\d+),',body))
            # EnemyManager::Initialize的出生模板是24×24；另生的Last Spell不能沿用前一只Boss。
            for name in born:
                if name in subs: direct.setdefault(name,('damage={24,24}',))
            pending=[(name,direct[name]) for name in born if name in direct]
        else:
            pending=[(name,direct[name]) for name in bosses if name in direct]
        while pending:
            name,box=pending.pop()
            box=direct.get(name,box)
            if box in reached[name]:
                continue
            reached[name].add(box)
            pending.extend((target,box) for target in graph[name])
        for name in subs:
            fields=list(direct.get(name,()))
            if not fields and len(reached[name])==1:
                fields=list(next(iter(reached[name])))+['inherited=true']
            if not fields:
                continue
            key=path.stem+':'+(name[3:] if name.startswith('Sub') else name)
            lines.append('        ["'+key+'"]={'+','.join(fields)+'},')
    lines.append('    },')
lines.append('}')
(root/'mod/GAME/original/unit_boxes.lua').write_text('\n'.join(lines)+'\n','utf-8')
