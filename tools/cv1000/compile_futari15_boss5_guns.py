"""整理第五面炮台回调与独立出膛接口，保留身体、私有参数和本步自机输入。"""
import argparse
import struct
import sys
from collections import defaultdict
from pathlib import Path

sys.dont_write_bytecode=True
from compile_futari15_boss5_motion import read
from compile_futari15_boss5_control import encode

SIZE=0x27A8
RECORD=28+SIZE*2+80+384
MODES={0xC1BF540:'first_a_init',0xC1BF870:'first_a',0xC1BF610:'first_b_init',0xC1BFD20:'first_b',
       0xC1BF6C0:'first_c_init',0xC1C00D0:'first_c',0xC1BF760:'first_d_init',0xC1C0540:'first_d',
       0xC1C0B40:'second_a_init',0xC1C0C90:'second_a',0xC1C0C00:'second_b_init',0xC1C0F40:'second_b',
       0xC1C13F0:'third_a_init',0xC1C1600:'third_a',0xC1C14E0:'third_b_init',0xC1C1830:'third_b',
       0xC1C1570:'third_c_init',0xC1C1A60:'third_c'}
SIZES={'first_a':124,'first_b':124,'first_c':76,'first_d':136,'second_a':60,
       'second_b':100,'third_a':92,'third_b':36,'third_c':84}
INIT_FIELDS={
    'first_a':list(range(0,24,4))+list(range(28,48,4))+list(range(56,112,4))+[112],
    'first_b':list(range(0,52,4))+list(range(56,92,4)),
    'first_c':list(range(0,28,4))+list(range(36,76,4)),
    'first_d':list(range(0,48,4))+list(range(60,136,4)),
    'second_a':list(range(0,24,4))+list(range(28,60,4)),
    'second_b':list(range(0,40,4))+[52]+list(range(64,88,4))+[92,96],
    'third_a':list(range(0,12,4))+list(range(16,36,4))+list(range(40,76,4))+[80,88],
    'third_b':list(range(0,24,4))+[32],
    'third_c':list(range(0,28,4))+list(range(36,84,4)),
}
FIELDS={a:4 for a in [8,12,16,20,28,32,36,40,0x27a0,0x27a4,0x2788,0x278c,0x2790]}
for a in range(0x26D0,0x2788,4):FIELDS[a]=4


def operation(row,queries):
    _,helper,caller,a,b,c,d,*tail=row
    result=tail[-1]
    stack=tail[8:16]
    if helper==0xC077F30:return [['switch',MODES[c]],None]
    if helper==0xC077FA0:return [['remove'],None]
    if helper==0xC0631F0:return [['random',a],result]
    if helper==0xC076220:return [['aim',b,c],result]
    if helper==0xC076300:return [['target_position'],queries[(helper,caller)][:2]]
    if helper==0xC076830:return None
    if helper==0xC068C80:return [['weapon_flag'],bool(result)]
    if helper==0xC0761F0:return [['target_flip'],None]
    if helper==0xC1B06F0:return [['collision',bool(b)],None]
    if helper==0xC078130:return [['spawn','task',b],result]
    if helper==0xC076960:return [['bullet',b,c,d,stack[0],stack[1],stack[2]],None]
    if helper==0xC076B70:return [['fan',b,c,d]+stack[:5],None]
    if helper in [0xC0632B0,0xC063680]:return None
    if helper==0xC0786A0:
        assert b==0xC1B5B10
        return [['motion','replace','wander_init']+tail[:7],None]
    raise ValueError(f'未知炮台接口 {helper:x}，调用位置 {caller:x}')


def compile_reference(prefix, output, group):
    ops=defaultdict(list)
    for line in Path(str(prefix)+'.guns-ops').read_text().splitlines():
        values=list(map(int,line.split()));ops[values[0]].append(values)
    inputs={}
    for line in Path(str(prefix)+'.guns-counter').read_text().splitlines():
        ident,*values=map(int,line.split());inputs[ident]=values
    contexts={}
    for line in Path(str(prefix)+'.guns-context').read_text().splitlines():
        ident,*values=map(int,line.split());contexts[ident]=values
    queries=defaultdict(dict)
    for line in Path(str(prefix)+'.guns-queries').read_text().splitlines():
        ident,helper,caller,*values=map(int,line.split());queries[ident][helper,caller]=values
    fields=sorted(FIELDS)
    rows=[]
    with Path(str(prefix)+'.guns').open('rb')as stream:
        while chunk:=stream.read(RECORD):
            assert len(chunk)==RECORD,'炮台记录不完整'
            frame,ident,index,handle,before,after,active=struct.unpack_from('>7I',chunk)
            mode=MODES[before];base=mode.removesuffix('_init')
            if group and base not in group:continue
            b0,b1=chunk[28:28+SIZE],chunk[28+SIZE:28+SIZE*2]
            v0,v1=chunk[-384:-192],chunk[-192:]
            allowed={i for a in FIELDS for i in range(a,a+4)}
            uncovered=[a^7 for a,(x,y)in enumerate(zip(b0,b1))if x!=y and(a^7)not in allowed]
            assert not uncovered,(hex(before),list(map(hex,uncovered)))
            requests=[]
            for raw in ops[ident]:
                op=operation(raw,queries[ident])
                if op:requests.append(op)
            count=SIZES[base]//64+1
            offsets=INIT_FIELDS[base]if mode.endswith('_init')else range(0,count*64,4)
            checks=[]
            if active:
                for a in offsets:
                    width=1 if mode=='first_a_init'and a==112 or mode=='third_a_init'and a==68 else 4
                    checks.extend([a,width,read(v1,a,width)])
            rows.append([frame,index+1,handle,mode,MODES[after],bool(active),
                [read(b0,a)for a in fields],[read(b1,a)for a in fields],
                [read(v0,a)for a in range(0,count*64,4)],checks,requests,inputs[ident],contexts[ident][0]])
    assert rows,'没有炮台回调'
    # 每批独立函数，避免完整三段记录超过 LuaJIT 单函数 65536 常量限制。
    lines=['-- 独立原版炮台入口/返回及出膛参数；仅回归工具载入。',
        'local steps={}', 'local function append(rows)for _,r in ipairs(rows)do steps[#steps+1]=r end end']
    for start in range(0,len(rows),1500):
        lines.append('append((function()return {')
        lines.extend(encode(row)+','for row in rows[start:start+1500])
        lines.append('}end)())')
    lines.append('return {fields='+encode(fields)+',sizes={'+','.join(k+'='+str(v)for k,v in SIZES.items())+'},steps=steps}')
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))
    print(len(rows),'次原版炮台回调')


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('prefix',type=Path);p.add_argument('output',type=Path)
    p.add_argument('--group',action='append',choices=list(SIZES))
    a=p.parse_args();compile_reference(a.prefix,a.output,a.group)
