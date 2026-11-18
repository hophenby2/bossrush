"""整理二十槽演出的独立入口/返回；每条记录保留原版前置条件与真实写入。"""
import argparse
import re
import struct
import sys
from collections import defaultdict
from pathlib import Path

sys.dont_write_bytecode = True
from compile_futari15_boss5_motion import read
from compile_futari15_boss5_control import encode

SIZE = 0x27A8
RECORD = 28 + 2*SIZE + 80 + 256
MODES = {}
POINTER_INITIALIZERS={}
for name in ['boss5_tasks.lua','boss5_task_parts.lua','boss5_task_entry.lua']:
    path = Path('mod/GAME/th46') / name
    if path.exists():
        text = path.read_text(encoding='utf-8')
        for match in re.finditer(r"(?:register\('([a-z_]+)',|\b([a-z_]+)=\{)(0x[0-9a-f]+)",text):
            MODES[int(match[3],16)] = match[1] or match[2]
        for match in re.finditer(r"\b[a-z_]+_init=\{(0x[0-9a-f]+),(0x[0-9a-f]+),",text):
            if int(match[2],16)<SIZE:
                POINTER_INITIALIZERS[int(match[1],16)]=int(match[2],16)

BASES = [0x1e18,0x2010,0x2064,0x21b4,0x1c20,0x1c74,0x1bcc,0x1d1c,0x2304,
         0x20b8,0x210c,0x1f68,0x1fbc,0x1dc4,0x22b0]
FIELDS = {a:4 for a in [8,12,32,36,40,0xfc,0x100,0x128,0x12c,0x124,0x134,0x13c,
                        0x1bbc,0x1a20,0x1a30,0x1db4,0x1d70,0x138,0x21f8,0x262c,0x2630,0x2638,0xb7c,
                        0x275c,0x2760,0x2764,0x2768]}
for a in BASES:
    for offset in [0,12,16,56,64,68]:
        FIELDS[a+offset] = 4
    FIELDS[a+72] = 2
for a in [0x2250,0x22a4,0x1e60,0x1eb4]:
    FIELDS[a] = 2
for a in range(0x2694,0x26d0,4):
    FIELDS[a] = 4


def body_address(path):
    candidates=set()
    with path.open('rb') as file:
        while chunk:=file.read(RECORD):
            assert len(chunk)==RECORD,'不完整任务记录'
            entry=struct.unpack_from('>I',chunk,16)[0]
            if entry in POINTER_INITIALIZERS:
                candidates.add(read(chunk[-128:],4)-POINTER_INITIALIZERS[entry])
    assert len(candidates)==1,'无法从独立关节指针一致确定原版本体地址'
    address=candidates.pop()
    assert 0xC000000<=address<0xC800000-SIZE and address%8==0
    return address


def operation(v, queries, state, body):
    _,helper,caller,a,b,c,d,*tail = v
    result = tail[-1]
    query=queries.get((helper,caller))
    if 0xC1BC090<=caller<0xC1BC150:
        return None
    if helper==0xC1BC090:
        return [['weapon_mode'],[query[0],query[2]]]
    if helper==0xC0680B0:
        state['weapon']=b
        return None
    if helper==0xC06AB10:
        return [['weapon_active',state['weapon']],bool(result)]
    if helper==0xC0761D0:
        return [['camera',a],result]
    if helper==0xC076140:
        return [['root_offset',b],result]
    if helper==0xC076830:
        return None
    if helper==0xC068790:
        return [['scene_counter',c],query[0]]
    if helper==0xC09C3A0:
        return [['queue_get',a],query[:2]]
    if helper==0xC09C330:
        return [['queue_set',a,b,c],None]
    if helper==0xC062BAC:
        return [['service',helper,a,b],None]
    if helper==0xC0E51A0:
        return [['service',helper],None]
    if helper==0xC077510:
        args=query[:]
        for i in [1,6]:args[i]-=body
        return [['joint_effect']+args+[c],result]
    if helper==0xC078330:
        return [['alive','task',b],bool(result)]
    if helper in [0xC10FED0,0xC110550]:
        return [['timeline_call',helper,a],None]
    if helper in [0xC1108D0,0xC1108F0,0xC110930,0xC110950,0xC110970,0xC110990,0xC110A50,0xC110D30]:
        return [['timeline_call',helper],None]
    if helper == 0xC063680:
        return None
    if helper == 0xC0781C0:
        return [['switch',MODES[c]],None]
    if helper == 0xC078230:
        return [['remove'],None]
    if helper in [0xC1B4610,0xC1B4630,0xC1B46B0]:
        return [['layer',helper],None]
    if helper in [0xC10EF10,0xC10EE90,0xC1109D0,0xC1109F0]:
        return [['service',helper],None]
    if helper == 0xC0631F0:
        return [['random',a],result]
    if helper == 0xC0768F0:
        return [['root_field12'],result]
    if helper == 0xC0966D0:
        return [['particle',a,b,c,d],result]
    if helper in [0xC096830,0xC096930,0xC096890,0xC096870,0xC0968D0]:
        return [['particle_set',helper,a,b]+([c] if helper==0xC096830 else []),None]
    if helper == 0xC096950:
        return [['particle_source',a,b,c,d,tail[8],tail[9]],None]
    if helper == 0xC0992C0:
        return [['fragment',a,b,c,d],result]
    if helper == 0xC099380:
        return [['fragment_angle',a,b],None]
    if helper == 0xC0982A0:
        return [['dust',a,b,c,d,tail[8]],result]
    if helper == 0xC098340:
        return [['dust_motion',a,b,c],None]
    if helper == 0xC078130:
        return [['spawn','task',b],result]
    raise ValueError(f'未知演出接口 {helper:x}，调用位置 {caller:x}')


def compile_reference(prefix, output):
    body=body_address(Path(str(prefix)+'.tasks'))
    ops = defaultdict(list)
    for line in Path(str(prefix)+'.tasks-ops').read_text().splitlines():
        v = list(map(int,line.split()))
        ops[v[0]].append(v)
    counters = dict(map(lambda line:map(int,line.split()),Path(str(prefix)+'.tasks-counter').read_text().splitlines()))
    queries=defaultdict(dict)
    queryfile=Path(str(prefix)+'.tasks-queries')
    if queryfile.exists():
        for line in queryfile.read_text().splitlines():
            ident,helper,caller,*values=map(int,line.split())
            queries[ident][helper,caller]=values
    fields = sorted(FIELDS.items())
    contexts={}
    for line in Path(str(prefix)+'.tasks-context').read_text().splitlines():
        ident,*values=map(int,line.split())
        contexts[ident]=values
    rows=[]
    skipped=set()
    with Path(str(prefix)+'.tasks').open('rb') as file:
        while chunk:=file.read(RECORD):
            assert len(chunk)==RECORD,'不完整任务记录'
            frame,ident,index,handle,before,after,active=struct.unpack_from('>7I',chunk)
            if before not in MODES:
                skipped.add(before);continue
            b0,b1=chunk[28:28+SIZE],chunk[28+SIZE:28+2*SIZE]
            config=chunk[28+2*SIZE:28+2*SIZE+80]
            v0,v1=chunk[-256:-128],chunk[-128:]
            private0=[read(v0,a,4) for a in range(0,64,4)]
            private1=[read(v1,a,4) for a in range(0,64,4)]
            mode=MODES[before]
            # 身体指针只用于关系定位；原生参数保存身体内偏移，不能保留模拟器地址。
            for private in [private0,private1]:
                if body <= private[1] < body+SIZE:
                    private[1]-=body
            changed = []
            for a,width in fields:
                if read(b0,a,width)!=read(b1,a,width):
                    changed.append((a,width))
            allowed=set()
            for a,width in fields:
                allowed.update(range(a,a+width))
            uncovered=[a^7 for a,(x,y) in enumerate(zip(b0,b1)) if x!=y and (a^7) not in allowed]
            assert not uncovered,(hex(before),list(map(hex,uncovered)))
            requests=[]
            state={}
            for raw in ops[ident]:
                op=operation(raw,queries[ident],state,body)
                if op is not None: requests.append(op)
            # 粒子/尘屑工厂返回值由其第一处 setter 的对象参数确认，不使用深层返回探针的 R0。
            for i,op in enumerate(requests):
                kind=op[0][0]
                if kind in ['particle','fragment','dust']:
                    following=requests[i+1:]
                    setter=next(x for x in following if x[0][0] in ['particle_set','fragment_angle','dust_motion'])
                    op[1]=setter[0][2] if setter[0][0]=='particle_set' else setter[0][1]
            checkprivate=[]
            if active:
                for i,n in enumerate(private1):
                    a=i*4
                    if mode in ['flash_init','flash_resume']:
                        continue
                    if mode.endswith('_init'):
                        if mode.startswith('timeline_'): mask={0,4,8,12,16}
                        elif mode in ['entry_init','change_init','scene_init']: mask={0,4}
                        elif mode in ['left_scale_init','right_scale_init']: mask={4,8,12,16}
                        elif mode=='morph_init': mask={4,8,12}
                        elif 'break_init' in mode:
                            mask={0,4,8}
                            if mode!='core_break_init':mask.add(28)
                            if mode in ['body_break_init','lower_body_break_init','core_break_init']:mask.add(12)
                            if mode not in ['core_break_init','left_final_break_init','right_final_break_init']:mask.add(56)
                        else: mask={4,8,12}
                        if a not in mask:continue
                    if n!=private0[i]or mode.endswith('_init'):checkprivate.extend([a,n])
            rows.append([frame,index+1,handle,mode,MODES[after],bool(active),
                         [read(b0,a,w) for a,w in fields],[read(b1,a,w) for a,w in fields],
                         private0,checkprivate,[read(config,a,4) for a in range(0,80,4)],requests,counters[ident],contexts[ident][0]])
    assert rows,'没有演出任务记录'
    assert not skipped,'尚未移植的演出入口：'+','.join(hex(a) for a in sorted(skipped))
    lines=['-- 独立 MAME 回调前后对照；原生对象运行时不载入此文件。',
           'return {fields='+encode([a for a,w in fields])+',steps={']
    lines.extend(encode(row)+',' for row in rows)
    lines.append('}}')
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))
    print(len(rows),'次回调，全部入口已覆盖')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('prefix',type=Path)
    parser.add_argument('output',type=Path)
    args=parser.parse_args()
    compile_reference(args.prefix,args.output)
