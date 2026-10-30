#!/usr/bin/env python3
"""从原生 ecldata6.ecl 独立解码 L 行，与 Lua 原生实现的发弹轨迹对照。

用法：python3 tools/th32-tests/ecl_oracle.py /path/to/ecldata6.ecl
只在测试中解释 ECL；游戏不加载本文件。对照发弹参数、CALL/RET 时钟、循环、
无大弹的提前返回、16 次采样以前结束时不唤醒等行为。几何和弹体运动另由 native.lua unit 验证。
"""
import argparse
import copy
import math
from pathlib import Path
import struct
import subprocess

FORMATS = {
    2:'ii',3:'iii',4:'ii',5:'if',9:'iff',13:'iii',17:'iii',18:'i',20:'iff',21:'iff',26:'i',27:'ii',
    29:'ii',30:'ii',31:'ii',32:'ii',33:'ii',34:'ii',35:'iif',47:'f',50:'ff',57:'ifff',61:'i',
    67:'hhii4fi',68:'hhii4fi',70:'hhii4fi',75:'hhii4fi',78:'',79:'',82:'4i4f',121:'ii',131:'ffiiii',
}
SUBS = [31,33,35,39,44]


def f32(v): return struct.unpack('<f',struct.pack('<f',v))[0]


ZPI=f32(math.pi)


def norm(a):
    while a > ZPI: a = f32(a-2*ZPI)
    while a < -ZPI: a = f32(a+2*ZPI)
    return a


def decode(path):
    data = path.read_bytes()
    count, = struct.unpack_from('<H', data)
    offsets = struct.unpack_from('<'+'I'*count, data, 16)
    table = {}
    for sub in SUBS+[37,41]:
        pos = offsets[sub]
        while pos < offsets[sub+1]:
            t, op, size = struct.unpack_from('<ihh',data,pos)
            assert size >= 12
            args = list(struct.unpack_from('<'+FORMATS[op],data,pos+12)) if op in FORMATS else []
            table[pos] = (t,op,data[pos+9],args,pos+size)
            pos += size
    return offsets,table


def oracle(offsets,table,sub,frames,seedmode):
    ctx = dict(pc=offsets[sub],time=0,vars={})
    stack=[];result=[];rank=.5;ex=[-1]*8;disabled=False;seedcalls=0
    epoch = 60 if sub==44 else 0
    def resolve(v): return ctx['vars'].get(int(v),0) if -10025<=v<=-10001 else v
    def emit(kind,*args): result.append([frame-epoch,kind,*args])
    for frame in range(frames+epoch+1):
        guard=0
        while True:
            t,op,mask,args,nxt = table[ctx['pc']]
            if t != ctx['time']: break
            guard+=1;assert guard<10000
            old=ctx['pc'];ctx['pc']=nxt
            if not mask&8: continue  # RunEcl 实际判断的是该位为 1 才执行。
            if op in (4,5): ctx['vars'][args[0]]=resolve(args[1])
            elif op==9: ctx['vars'][args[0]]=resolve(args[2])+resolve(args[1])/2
            elif op in (13,17,20,21):
                a,b=resolve(args[1]),resolve(args[2])
                value={13:lambda:a+b,17:lambda:a%b,20:lambda:a+b,21:lambda:a-b}[op]()
                ctx['vars'][args[0]]=f32(value) if op in (20,21) else value
            elif op==18: ctx['vars'][args[0]]=resolve(args[0])+1
            elif op==26: ctx['vars'][args[0]]=norm(resolve(args[0]))
            elif op==27: ctx['cmp']=resolve(args[0])-resolve(args[1])
            elif op in (2,3,29,30,31,32,33,34):
                jump=op==2
                if op==3:
                    ctx['vars'][args[2]]=resolve(args[2])-1
                    jump=resolve(args[2])>0
                if 29<=op<=34:
                    c=ctx['cmp'];jump={29:c<0,30:c<=0,31:c==0,32:c>0,33:c>=0,34:c!=0}[op]
                if jump:ctx['time'],ctx['pc']=args[0],old+args[1]
            elif op==35:
                stack.append(copy.deepcopy(ctx))
                ctx=copy.deepcopy(ctx);ctx['pc']=offsets[args[0]];ctx['time']=0
                ctx['vars'][-10001],ctx['vars'][-10005]=args[1],args[2]
            elif op==36: ctx=stack.pop()
            elif op==78: disabled=True
            elif op==79: disabled=False
            elif op==82: ex=args
            elif op==131: rank=args[1]  # 固定 rank=32。
            elif op in (67,68,70,75):
                if disabled:continue
                sprite,c,n,l,v1,v2,a,step,flags=args
                n,l,v1,v2,a,step=map(resolve,(n,l,v1,v2,a,step))
                if v1: v1=max(.3,v1+rank)
                v2=max(.3,v2+rank/2)
                mode={67:'aim',68:'fan',70:'ring',75:'random'}[op]
                active=flags&(16+32+2048)
                emit('shot',mode,sprite,c,n,l,v1,v2,norm(a),step,flags,
                     ex[0] if active else -1,ex[4] if active else -1,
                     ex[5] if flags&(16+32) else -1)
            elif op==61: emit('drift',speed,args[0])
            elif op==47: speed=args[0]
            elif op==121:
                func,arg=args
                if func==7:emit('star',arg)
                elif func==8:
                    seedcalls+=1;emit('seed')
                    ctx['vars'][-10004]=0 if seedmode=='zero' or seedmode=='early' and seedcalls%13==0 else 1
                elif func in (9,11):emit('awake',func)
            # 视觉、HP、伤害开关等不属于此测试的事件流。
        ctx['time']+=1
    return result


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('ecl',type=Path)
    parser.add_argument('--frames',type=int,default=2400)
    args=parser.parse_args()
    offsets,table=decode(args.ecl)
    total=0
    for seedmode in ('always','zero','early'):
        text=subprocess.check_output(['luajit','tools/th32-tests/native.lua','trace',str(args.frames),seedmode],text=True)
        actual=[[] for _ in SUBS]
        for line in text.splitlines():
            index,t,kind,*values=line.split('|')
            row=[int(t),kind]
            for value in values:
                try:row.append(float(value))
                except ValueError:row.append(value)
            actual[int(index)-1].append(row)
        for i,sub in enumerate(SUBS):
            expected=oracle(offsets,table,sub,args.frames,seedmode)
            assert len(expected)==len(actual[i]),(sub,seedmode,'事件数',len(expected),len(actual[i]))
            for n,(left,right) in enumerate(zip(expected,actual[i])):
                assert len(left)==len(right),(sub,n,left,right)
                for col,(a,b) in enumerate(zip(left,right)):
                    if isinstance(a,(int,float)) and isinstance(b,(int,float)):
                        delta=abs(a-b)
                        if left[1]=='shot' and col==9:delta=abs(norm(a-b))
                        assert delta<.0001,(sub,seedmode,n,col,left,right)
                    else:assert a==b,(sub,seedmode,n,left,right)
            total+=len(expected)
    print(f'通过：五张 L 卡 × 三种全池采样结果，{total} 个原生 ECL 事件逐项一致（每种 {args.frames} 帧）')

if __name__=='__main__':main()
