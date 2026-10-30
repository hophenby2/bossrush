#!/usr/bin/env python3
"""将全部静态 Lua 子程序与原生 ECL 顺序取指参照器逐帧对照；不会修改游戏代码。"""
import argparse
import subprocess
import tempfile
from pathlib import Path
from source import Source,road_catalogue
from expand import lit

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('data',type=Path);p.add_argument('--frames',type=int,default=1800);p.add_argument('--card',type=int);p.add_argument('--dump',type=Path)
    args=p.parse_args();source=Source(args.data)
    data={stage:{sub:[[r['pos'],r['t'],r['op'],r['a']] for r in source.active(stage,sub)] for sub in subs} for stage,subs in source.stages.items()}
    data['roads']=road_catalogue(source)
    def lua(value):
        if isinstance(value,dict):return '{'+','.join(f'[{lit(key)}]={lua(v)}' for key,v in value.items())+'}'
        if isinstance(value,tuple):return '{'+','.join(lua(v) for v in value)+'}'
        if isinstance(value,list):return '{'+','.join(lua(v) for v in value)+'}'
        return lit(value)
    with tempfile.TemporaryDirectory(prefix='th32-ecl-') as folder:
        path=Path(folder)/'source.lua';path.write_text('return '+lua(data))
        outputs=[]
        for variant in ('native','oracle'):
            command=['luajit','tools/th32-tests/native.lua','program',str(args.frames),variant,str(path)]
            if args.card or args.dump:command.append(str(args.card or 0))
            if args.dump:command.append(str(args.dump)+'.'+variant)
            outputs.append(subprocess.check_output(command,text=True))
        native,oracle=map(str.splitlines,outputs)
        assert len(native)==len(oracle),(len(native),len(oracle))
        for a,b in zip(native,oracle):
            assert a==b,('静态 Lua 与原生 ECL 参照器不一致',a,b)
        print(f'通过：{len(native)} 段新增原生流程，逐帧发弹/激光/移动/使魔/特殊攻击事件及对象峰值一致；每段最多 {args.frames} 帧')
if __name__=='__main__':main()
