"""从已审阅的TH10直线波次导出生成表；只解析源文件，不执行ECL/Lua、不勾选清单。"""
import argparse
from pathlib import Path
from ecl_source import Source, Variable

ROOT=Path(__file__).resolve().parents[2]
FIELDS={-9985:'I0',-9984:'I1',-9983:'I2',-9982:'I3',-9981:'F0',-9980:'F1',-9979:'F2',-9978:'F3'}
def value(v):
    if isinstance(v,Variable):
        if v.index in FIELDS:return '{reg="'+FIELDS[v.index]+'"}'
        assert v.index>=0 and v.index%4==0,v
        return '{local_id='+str(v.index)+'}'
    if isinstance(v,str):return v
    return repr(v)

def export(ws):
    lines=['-- TH10已逐行核对的直线道中波次；原创建名、帧距、参数快照和调用先后。',
           '-- 不含ECL字节码/解释器；游戏只按表等待、改寄存器和调用原生Lua行为。','return {']
    for stage in (5,7):
        s=Source(ws/f'decompiled/ecl/10/stage{stage:02}.decl',ws/f'original/ECL/th10/stage{stage:02}.ecl',10)
        lines.append(f'[{stage}]={{')
        for name,body in s.subs.items():
            if not name.startswith('MainSub') or name=='MainSubBoss':continue
            lines.append(f'{name}={{')
            prev=0;stack=[]
            for i in body:
                if not i.mask&8:continue
                op=i.op;args=i.args;record=None
                if op in (0,10,40,338,339,340):continue
                if op in (42,44):stack.append(args[0]);continue
                if op==50:
                    b=stack.pop();a=stack.pop()
                    assert isinstance(a,Variable) and a.index in FIELDS and isinstance(b,int),(name,i)
                    stack.append('{reg="'+FIELDS[a.index]+'",add='+str(b)+'}')
                    continue
                if op in (43,45):
                    assert args[0].index in FIELDS or args[0].index>=0 and args[0].index%4==0,(stage,name,i)
                    v=stack.pop();v=v if isinstance(v,str) and v.startswith('{') else value(v)
                    record='"'+('='+FIELDS[args[0].index] if args[0].index in FIELDS else '~'+str(args[0].index))+'",'+v
                elif op in (256,257,260,261,265,266,267,268):
                    target=args[0].strip('"')
                    if target.startswith(('Boss','MBoss','Maple')):continue
                    assert len(args)==6 and not any(isinstance(v,Variable) and v.index<0 for v in args[1:]),(name,i)
                    # score在阶段接口折算；生命/掉落类型保持原字段，位置参数在调用context求值。
                    record=','.join([args[0],value(args[3]),value(args[1]),value(args[2]),str(op in(260,261,267,268)).lower(),value(args[5])])
                elif op in (11,15):
                    target=args[0].strip('"')
                    if target=='MainSubBoss':continue
                    assert target.startswith('MainSub'),(name,i)
                    record='"@'+('c' if op==11 else 'a')+target+'"'+''.join(','+value(v) for v in args[1:])
                else:raise ValueError((stage,name,hex(i.address),op,args))
                assert i.time>=prev,(stage,name,i)
                lines.append('    {'+str(i.time-prev)+','+record+'}, -- 0x'+format(i.address,'x')+' 原'+str(i.time))
                prev=i.time
            assert not stack,(stage,name,stack)
            lines.append('},')
        lines.append('},')
    lines.append('}')
    (ROOT/'mod/GAME/th35_road_waves.lua').write_text('\n'.join(lines)+'\n')

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('workspace',type=Path)
    export(p.parse_args().workspace)
