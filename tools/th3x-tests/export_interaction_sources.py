"""仅从原始ECL/反汇编导出交互常量；不执行游戏、Lua或弹幕脚本。"""
from pathlib import Path
import argparse
import json
from ecl_source import Source

ROOT=Path(__file__).resolve().parents[2]

def export(workspace):
    cache={}
    def source(game,file):
        key=game,file
        if key not in cache:
            cache[key]=Source(workspace/f'decompiled/ecl/{game}/{file}.decl',
                workspace/f'original/ECL/th{game:02}/{file}.ecl',game)
        return cache[key]
    evidence={8:[],10:[]}
    tables={8:{},10:{}}
    for path in sorted((workspace/'original/ECL/th08').glob('*.ecl')):
        for name,body in source(8,path.stem).subs.items():
            rows=[i for i in body if i.mask&8 and i.op in (77,78,183)]
            if not rows:continue
            assert all(all(isinstance(v,(int,float)) for v in i.args) for i in rows)
            key=path.stem+':'+name[3:]
            tables[8][key]=[[i.time,i.op,*i.args] for i in rows]
            evidence[8].extend(dict(key=key,address=hex(i.address),time=i.time,op=i.op,args=i.args) for i in rows)
    for stage in range(1,8):
        file=f'stage{stage:02}'
        subs={**source(10,'default').subs,**source(10,file).subs}
        mask=16 if stage==7 else 8
        def prefix(name,seen=()):
            if name in seen:return []
            result=[]
            for i in subs.get(name,[]):
                if i.time!=0 or not i.mask&mask:continue
                # 11是同步CALL；15/16是异步，不能将其副作用提前到入口。
                if i.op==11 and isinstance(i.args[0],str):
                    result.extend(prefix(i.args[0].strip('"'),(*seen,name)))
                elif i.op in (322,323,361):
                    assert all(isinstance(v,int) for v in i.args)
                    result.append((name,i))
            return result
        for name in source(10,file).subs:
            rows=prefix(name)
            if not rows:continue
            key=file+':'+name
            tables[10][key]=[[i.op,*i.args] for _,i in rows]
            evidence[10].extend(dict(key=key,sub=sub,address=hex(i.address),time=i.time,op=i.op,args=i.args) for sub,i in rows)
    for game,name,comment in [(8,'th31','77/78为主/副受弹框，183为Bomb期间停止判定；保留原时点。'),
                              (10,'th35','同步入口的322/323置位/清位，361为接触保护；335受弹无敌独立处理。')]:
        lines=['-- 原始ECL交互常量，export_interaction_sources.py导出；游戏不读ECL。','-- '+comment,'return {']
        for key,events in sorted(tables[game].items()):
            values=','.join('{'+','.join(map(str,event))+'}' for event in events)
            lines.append(f"    ['{key}']={{{values}}},")
        (ROOT/f'mod/GAME/{name}_interaction_sources.lua').write_text('\n'.join(lines+['}'])+'\n')
    return evidence

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('workspace',type=Path)
    ap.add_argument('--evidence',type=Path,required=True)
    args=ap.parse_args()
    data=export(args.workspace)
    args.evidence.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
    print({g:len(rows) for g,rows in data.items()})
