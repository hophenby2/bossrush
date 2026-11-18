"""把关底专用采样的真实受弹、本体状态及独立发弹探针整理成回归样本。"""
import argparse
import struct
import re
from collections import defaultdict
from pathlib import Path


def actor_states(path):
    # 主体和根对象的保存项均以八字节倒序保存，帧头是独立的大端五个长字。
    size = 20+0x3F50+0x920
    with path.open('rb') as stream:
        while block := stream.read(size):
            if len(block) != size:
                raise ValueError('关底记录被截断')
            frame = struct.unpack_from('>I',block)[0]
            raw = block[20:20+0x3F50]
            def word(at):
                return struct.unpack_from('<i',raw,at ^ 4)[0]
            yield frame, [word(0x1FFC),word(0x22EC),word(0x22E8)&65535]


def compile_core(prefix, output):
    states = dict(actor_states(Path(str(prefix)+'.actors')))
    hits, active = [], None
    with Path(str(prefix)+'.hits').open(encoding='utf-8') as stream:
        for line in stream:
            r = line.split()
            if r[0] == 'I':
                if active:
                    hits.append(active)
                values = list(map(int,r[1:]))
                active = values[:6]+values[1:4]
            elif active:
                _,value,mask = map(int,r[2:])
                if mask == 0xFFFFFFFF:
                    active[6] = (value+2147483648)%4294967296-2147483648
    if active:
        hits.append(active)
    if not hits:
        raise ValueError('没有捕获到真实伤害回调')
    for i,row in enumerate(hits):
        following = hits[i+1] if i+1<len(hits) else None
        after = following[1:4] if following and following[0] == row[0] else states[row[0]]
        if row[6] != after[0]:
            raise ValueError(f'第 {row[0]} 帧的血量写入与帧末状态不一致')
        row[7:9] = after[1:3]
    lines = [f'-- 原版 c14b690 的 {len(hits)} 次真实命中，包含换段钳血和最终击破。',
             '-- 各行：原版帧、命中前 HP / 段号 / 无敌、伤害、事件标志、命中后 HP / 段号 / 无敌。','return {']
    lines += ['    {'+','.join(map(str,row))+'},' for row in hits]
    lines.append('}')
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_guns(prefix, output, only_head=False):
    def read(suffix):
        return [list(map(int,line.split())) for line in Path(str(prefix)+suffix).read_text(encoding='utf-8').splitlines()]
    def digest(rows):
        value = 0
        for row in rows:
            for n in row:
                value = (value*131+n) % 16777213
        return value
    names = {0xC158070:'head',0xC157F80:'burst',0xC1581D0:'side'}
    fields = {'head':[0,1,2,3,4,5,8,9,10,14],
              'burst':[0,1,2,3,4,5,10,11,12],
              'side':[0,1,2,3,4,5,6,10,11,12,14,15,17]}
    groups = defaultdict(list)
    for r in read('.guns'):
        if r[2] not in names:
            raise ValueError('出现未移植的炮台回调')
        if not only_head or r[2] == 0xC158070:
            groups[r[1],r[3]].append(r)
    if not groups:
        raise ValueError('没有捕获到炮台')
    shots = read('.shots')
    for row in shots:
        row[1:3] = [(n+2147483648)%4294967296-2147483648 for n in row[1:3]]
    positions = {}
    with Path(str(prefix)+'.actors').open('rb') as stream:
        while block := stream.read(20+0x3F50+0x920):
            if len(block) != 20+0x3F50+0x920:
                raise ValueError('关底记录被截断')
            positions[struct.unpack_from('>I',block)[0]] = [struct.unpack_from('<i',block,20+(at^4))[0] for at in (8,12)]
    lines = [f'-- 原版 {len(groups)} 次完整炮台寿命；发弹参数来自 c076960 / c076b70 的独立读取探针。',
             '-- 各步输入为本体坐标、自机前一步坐标和复活状态；本体先更新，自机碰撞后更新。',
             '-- 头炮最后一步要求收束当前连射；其余炮台自行结束，驱动与姿态事件仍由战斗控制器负责。','return {']
    # 忽略瞄准管理器的内部指针和目标句柄，只核对原生对象保存的计时及射击状态。
    for rows in groups.values():
        kind = names[rows[0][2]]
        if any(b[0] != a[0]+1 for a,b in zip(rows,rows[1:])):
            raise ValueError('炮台记录不连续')
        states = [[r[0]]+[r[9+i] for i in fields[kind]] for r in rows]
        source_shots = [s[:6]+(s[8:10] if len(s)>8 else [1,0]) for s in shots
                        if rows[0][0] <= s[0] <= rows[-1][0]+1 and (len(s)<8 or s[7] == rows[0][2])]
        if not source_shots or source_shots[-1][0] != rows[-1][0]+1:
            raise ValueError('必须包含炮台收束的最后一发')
        inputs = [[r[4],r[5]]+(rows[i-1] if i else r)[6:9] for i,r in enumerate(rows)]
        inputs.append(positions[rows[-1][0]+1]+rows[-1][6:9])
        initial = rows[0][9:]
        config = [initial[5],initial[3]] if kind == 'burst' else [initial[i] for i in (0,1,6,12,14)] if kind == 'side' else []
        lines += [f'    {{kind="{kind}",config={{'+','.join(map(str,config))+'},',
                  f'     first={rows[0][0]},states={len(states)},stateHash={digest(states)},',
                  f'     shots={len(source_shots)},shotHash={digest(source_shots)},inputs={{']
        lines += ['        {'+','.join(map(str,row))+'},' for row in inputs]
        lines += ['    }},']
    lines.append('}')
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_pose(prefix, output):
    # 字段宽度由原指令导出；期望值始终从独立入口/返回探针的原版字节读取。
    module = Path('mod/GAME/th46/boss1_pose.lua').read_text(encoding='utf-8')
    def fields(name):
        table = re.search(name+r'=\{(.*?)\},\n',module,re.S)[1]
        return [(int(a),int(b)) for a,b in re.findall(r'\{(\d+),([124])\}',table)]
    inputs = fields('inputFields')
    outputs = sorted(set(fields('outputFields'))|{(16,4),(20,4),(24,4)})
    covered = {at+i for at,width in outputs for i in range(width)}
    def read(raw,at,width):
        return struct.unpack_from({1:'<b',2:'<h',4:'<i'}[width],raw,at^{1:7,2:6,4:4}[width])[0]
    initial,previous,steps,hash_value,landing_count = None,None,[],0,0
    record_size = 32+0x3F50*2
    with Path(str(prefix)+'.pose').open('rb') as stream:
        while block := stream.read(record_size):
            if len(block) != record_size:
                raise ValueError('关节入口/返回记录被截断')
            frame,_,_,dx,camera,px,py,active = struct.unpack_from('>3I4iI',block)
            before,after = block[32:32+0x3F50],block[32+0x3F50:]
            for at in range(0x3F50):
                if before[at^7] != after[at^7] and at not in covered:
                    raise ValueError(f'第 {frame} 帧漏掉原版写入字段 {at:x}')
            values = {at:read(before,at,width) for at,width in inputs}
            if initial is None:
                initial = values.copy()
            patches = [n for at in sorted(values) if previous is not None and values[at]!=previous[at] for n in (at,values[at])]
            landed = int(read(before,24,4)!=0 and read(before,16,4)+read(before,20,4)<=0)
            steps.append([frame,dx,camera,px,py,active,landed,patches])
            landing_count += landed
            for n in [frame]+[read(after,at,width) for at,width in outputs]:
                hash_value = (hash_value*131+n)%16777213
            previous = {at:read(after,at,width) for at,width in inputs}
    if not steps:
        raise ValueError('没有关节调用记录')
    lines = [f'-- 原版 {len(steps)} 次完整关节调用；每次核对 {len(outputs)} 个写入字段，含高度、落地与半字标志。',
             '-- 初始字段之后只记录两次调用之间的外部控制改动；不保存预计算姿态。',
             'return {',f'    states={len(steps)},hash={hash_value},landings={landing_count},',
             '    initial={'+','.join(f'[{at}]={v}' for at,v in sorted(initial.items()))+'},','    steps={']
    for row in steps:
        lines.append('        {'+','.join(map(str,row[:7]))+',{'+','.join(map(str,row[7]))+'}},')
    lines += ['    },','}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_motion(prefix, output):
    module = Path('mod/GAME/th46/boss1_pose.lua').read_text(encoding='utf-8')
    def fields(name):
        return {int(a):int(b) for a,b in re.findall(r'\{(\d+),([124])\}',re.search(name+r'=\{(.*?)\},\n',module,re.S)[1])}
    outputs = fields('outputFields')
    outputs.update({16:4,20:4,24:4,28:4,32:4,88:4})
    inputs = fields('inputFields')
    inputs.update(outputs)
    inputs.update({48:4,52:4,56:2})
    modes = {0xC14F630:'simple',0xC14F690:'simple_init',0xC14F6D0:'wander',0xC14F7E0:'wander_init',
             0xC14F870:'move_init',0xC14F960:'entry',0xC14FA20:'entry_init',0xC14FA80:'move'}
    params = {'move':[(0,'state'),(16,'targetX'),(20,'targetY'),(24,'clock'),(28,'interval'),(32,'acceleration'),(36,'half')],
              'wander':[(8,'anchorX'),(12,'anchorY'),(16,'targetX'),(20,'targetY')],
              'entry':[(0,'state'),(4,'clock')]}
    def read(raw,at,width=4):return struct.unpack_from({1:'<b',2:'<h',4:'<i'}[width],raw,at^{1:7,2:6,4:4}[width])[0]
    def variables(kind,raw):
        values = {name:read(raw,at)for at,name in params.get(kind,[])}
        if kind=='entry'and values['state']==0:values['clock']=0
        return values
    randoms = {}
    for line in Path(str(prefix)+'.motion-randoms').read_text(encoding='utf-8').splitlines():
        frame,caller,value = map(int,line.split())
        limit = {0xC14F778:48,0xC14F788:24,0xC14F814:48,0xC14F824:24}.get(caller)
        if limit is None:raise ValueError('出现未挂载的移动随机调用')
        randoms.setdefault(frame,[]).extend((limit,value))
    initial,previous,steps,hash_value = None,None,[],0
    initial_vars = {}
    record_size = 44+0x3F50*2+96
    with Path(str(prefix)+'.motion').open('rb') as stream:
        while block := stream.read(record_size):
            if len(block)!=record_size:raise ValueError('移动入口/返回记录被截断')
            frame,before_fn,dx,camera,px,py,alive,c0,c1,c2,after_fn = struct.unpack_from('>2I4iI3iI',block)
            before,after = block[44:44+0x3F50],block[44+0x3F50:44+0x3F50*2]
            before_vars,after_vars = block[-96:-48],block[-48:]
            mode,following = modes[before_fn],modes[after_fn]
            values = {at:read(before,at,width)for at,width in inputs.items()}
            if initial is None:
                initial=values.copy();initial_vars=variables(mode,before_vars)
            patch = [n for at in sorted(values) if previous is not None and values[at]!=previous[at] for n in (at,values[at])]
            steps.append([frame,mode,following,dx,camera,px,py,alive,[c0,c1,c2],patch,randoms.pop(frame,[])])
            for n in [frame,after_fn]+[read(after,at,width) for at,width in sorted(outputs.items())]+list(variables(following,after_vars).values()):
                hash_value=(hash_value*131+n)%16777213
            previous={at:read(after,at,width)for at,width in inputs.items()}
    if not steps:raise ValueError('没有移动回调')
    if randoms:raise ValueError('移动随机数没有对应的调用')
    def lua(value):
        if isinstance(value,str):return '"'+value+'"'
        if isinstance(value,list):return '{'+','.join(map(lua,value))+'}'
        return str(value)
    lines=[f'-- 原版 {len(steps)} 次移动入口/返回；控制器只注入外部改动，不使用原版位置轨迹驱动本体。',
           'return {',f'    states={len(steps)},hash={hash_value},',
           '    fields={'+','.join('{%d,%d}'%(a,w)for a,w in sorted(outputs.items()))+'},',
           '    initial={'+','.join(f'[{a}]={v}'for a,v in sorted(initial.items()))+'},',
           '    variables={'+','.join(f'{k}={v}'for k,v in initial_vars.items())+'},','    steps={']
    lines += ['        '+lua(row)+','for row in steps]
    lines += ['    },','}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_birth(prefix, output):
    module = Path('mod/GAME/th46/boss1_pose.lua').read_text(encoding='utf-8')
    fields = {int(a):int(w)for name in ('inputFields','outputFields')for a,w in re.findall(
        r'\{(\d+),([124])\}',re.search(name+r'=\{(.*?)\},\n',module,re.S)[1])}
    draw=Path('mod/GAME/th46/boss1_draw.lua').read_text(encoding='utf-8')
    fields.update({int(a):int(w)for name in ('inputFields','outputFields')for a,w in re.findall(
        r'\{(\d+),([124])\}',re.search(name+r'=\{(.*?)\},\n',draw,re.S)[1])})
    fields.update({at:4 for at in (8,12,16,20,24,28,32,48,52,88,0x1FFC,0x2000,0x2004,0x22EC,0x2314)})
    fields[56]=2
    fields.update({0x2010:4,0x22e0:4,0x22e4:4})
    fields.update({at:4 for at in (20,24,28,32,40,88,0x233c,0x2340)})
    tasks=Path('mod/GAME/th46/boss1_tasks.lua').read_text(encoding='utf-8')
    table=tasks[tasks.index('    fields='):tasks.index('    create=',tasks.index('    fields='))]
    fields.update({int(a,0):int(w)for a,w in re.findall(r'\{(0x[0-9a-f]+|\d+),([124])\}',table)})
    with Path(str(prefix)+'.actors').open('rb') as stream:block=stream.read(20+0x3F50+0x920)
    if len(block)!=20+0x3F50+0x920:raise ValueError('没有完整出生记录')
    raw=block[20:20+0x3F50]
    def read(at,w):return struct.unpack_from({1:'<b',2:'<h',4:'<i'}[w],raw,at^{1:7,2:6,4:4}[w])[0]
    if read(0x1FFC,4)!=170752 or read(12,4)!=500*65536:
        raise ValueError('首条记录不是 Original 出生状态')
    hash_value=0
    for at,w in sorted(fields.items()):hash_value=(hash_value*131+read(at,w))%16777213
    root=block[20+0x3f50:]
    depth=sum(struct.unpack_from('<i',root,at^4)[0]for at in (0xa8,0xb8))
    lines=['-- 原版构造器返回后的首条记录，核对关节、移动、绘图、演出、牵引点及血量字段。',
           f'return {{frame={struct.unpack_from(">I",block)[0]},camera={120*65536-read(8,4)},hash={hash_value},depth={depth},',
           '    fields={'+','.join('{%d,%d}'%(a,w)for a,w in sorted(fields.items()))+'},','}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_extra_guns(prefix,output):
    modes={0xc157d80:'wide_init',0xc158430:'wide',0xc157e30:'leap_init',0xc1585e0:'leap'}
    fields={'wide':dict(zip(('spawnClock','spawnInterval','children','shotClock','shotWait',
        'turnClock','turnInterval','angle','turn','kind','fanSpeed','childSpeed','spreadOffset'),
        (0,4,16,24,28,32,36,48,52,56,60,64,72))),
        'leap':dict(zip(('pauseClock','pause','shotClock','shotInterval','remaining','count','waves',
        'angleLeft','angleRight','resetMark','kind','speedLeft','speedRight','side','motionType',
        'motionTime','aimed','fanCount','fanStep'),(0,4,8,12,16,20,24,32,36,40,44,48,52,60,64,68,72,76,80)))}
    ops=defaultdict(list)
    def normalize(row):
        fn,a,b,c,d,*tail=row
        stack,cfg,result=tail[:8],tail[8:16],tail[16]
        if fn==0xc0631f0:return [['random',a],result]
        if fn==0xc154f80:return [['pose',b,c],0]
        if fn in (0xc076b70,0xc076c10):
            value=['fan'if fn==0xc076b70 else'motionFan',c,d,stack[1],stack[0],b,stack[2],stack[3]]
            if fn==0xc076c10:value+=stack[4:7]
            elif stack[4]!=0:raise ValueError('出现未移植的扇弹附加参数')
            return [value,0]
        # c075750 收到的是整份栈配置；0xa2 从 +12 起读主人、角度、速度和等待。
        if fn==0xc075750:return [['child',a,b,c,'host',*cfg[4:7]],0]
        raise ValueError(f'未知炮台接口 {fn:x}')
    for line in Path(str(prefix)+'.extra-gun-ops').read_text(encoding='utf-8').splitlines():
        r=list(map(int,line.split()));ops[r[0]].append(normalize(r[1:]))
    read=lambda raw,at:struct.unpack_from('<i',raw,at^4)[0]
    size=48+2*0x3f50+80+192
    rows=[]
    with Path(str(prefix)+'.extra-guns').open('rb')as stream:
        while block:=stream.read(size):
            if len(block)!=size:raise ValueError('跳跃及宽幅炮记录被截断')
            frame,seq,fn,handle,index,following,active,px,py,respawn,base_speed,side=struct.unpack_from('>12I',block)
            before,after=block[48:48+0x3f50],block[48+0x3f50:48+2*0x3f50]
            config=block[48+2*0x3f50:48+2*0x3f50+80]
            params=block[-96:]
            mode=modes[fn];kind=mode.split('_')[0]
            expected={name:read(params,at)for name,at in fields[kind].items()}
            if mode=='leap_init':
                for name in ('angleLeft','angleRight','resetMark'):expected.pop(name)
            elif mode=='leap'and expected['aimed']==0:
                for name in ('angleLeft','angleRight'):expected.pop(name)
            # c077fa0 当场释放参数块；返回后这里已经是分配器链表，不能当炮台字段。
            if not active:expected={}
            body_fields=(8,12,16,76,80,0x1ac0,0x1a8c,0x1a90)
            for at in range(0x2350):
                if before[at^7]!=after[at^7]and not any(a<=at<a+4 for a in (76,80)):
                    raise ValueError(f'第 {frame} 帧炮台漏写本体字段 {at:x}')
            rows.append([frame,seq,handle,mode,modes[following]if active else mode.replace('_init',''),bool(active),
                read(config,0),[read(before,a)for a in body_fields],[read(after,a)for a in body_fields],
                [(v+2147483648)%4294967296-2147483648 for v in (px,py)],respawn,base_speed,expected,ops[seq]])
    if not rows:raise ValueError('没有捕获到跳跃及宽幅炮')
    def lua(v):
        if isinstance(v,str):return '"'+v+'"'
        if isinstance(v,bool):return str(v).lower()
        if isinstance(v,dict):return '{'+','.join(k+'='+lua(n)for k,n in v.items())+'}'
        if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
        return str(v)
    lines=['-- 原版独立炮台入口/返回及发弹、子敌机和关节请求，禁止作为游戏运行数据。',
        'return {fields={8,12,16,76,80,0x1ac0,0x1a8c,0x1a90},steps={']
    lines+=['    '+lua(row)+','for row in rows];lines+=['}}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_tasks(prefix,output):
    module=Path('mod/GAME/th46/boss1_tasks.lua').read_text(encoding='utf-8')
    modes={int(a,16):name for name,a in re.findall(r'([a-z_]+)=0x([0-9a-f]+)',re.search(r'local source=\{(.*?)\}',module,re.S)[1])}
    table=module[module.index('    fields='):module.index('    create=',module.index('    fields='))]
    fields=sorted((int(a,0),int(w))for a,w in re.findall(r'\{(0x[0-9a-f]+|\d+),([124])\}',table))
    with Path(str(prefix)+'.actors').open('rb')as stream:actor=stream.read(20)
    if len(actor)!=20:raise ValueError('演出任务记录缺少关底本体')
    body=struct.unpack('>5I',actor)[3]
    covered={at+i for at,w in fields for i in range(w)}
    def read(raw,at,w=4):return struct.unpack_from({1:'<b',2:'<h',4:'<i'}[w],raw,at^{1:7,2:6,4:4}[w])[0]
    operations=defaultdict(list)
    with Path(str(prefix)+'.task-ops').open(encoding='utf-8')as stream:
        for line in stream:
            r=list(map(int,line.split()));operations[r[0]].append(r[1:])
    def normalize(r):
        fn,a,b,c,d,*tail=r
        cfg,stack,point,result=tail[:8],tail[8:16],tail[16:18],tail[18]
        if fn in(0xc0781c0,0xc078230):return None
        if fn==0xc078130:
            mode=modes[b];length={'pose_init':1,'tilt_init':2}.get(mode,0)
            return ['spawn',mode,cfg[:length]],result
        if fn in(0xc156240,0xc156420):
            bank={0xc309020:'enter_small',0xc3090b0:'enter_large',0xc309260:'enter_dust'}[b]
            return ['strip'if fn==0xc156240 else'scatter',bank,c,*point,stack[0]],0
        if fn==0xc14e230:return ['footprints',b,c],0
        if fn==0xc09c300:return ['screen_begin',a,b,c],0
        if fn==0xc09c330:return ['screen_ramp',a,b,c],0
        if fn==0xc09c4c0:return ['sound',a],0
        if fn==0xc0966d0:
            # 一批两份烟粒子只提交一次原生效果请求；坐标由本步关节锚点另行核对。
            return None
        if fn in (0xc0760b0,0xc0760d0,0xc156670):return None
        overlay={0xc14e2f0:'create',0xc14e250:'enable',0xc14e270:'disable'}
        if fn in overlay:return ['overlay',overlay[fn]],0
        raise ValueError(('未处理的演出任务接口',hex(fn)))
    def private(mode,raw):
        if mode=='leap_smoke_init':return [0,12,16]
        if mode=='leap_smoke':return [0,4,12,16]
        if mode=='landing_init':return [0,8,12,16]
        if mode=='landing':return [0,4,8,12,16]
        if mode=='enter_init':return [0,4]
        if mode=='enter':return [0,4]+([8]if read(raw,0)!=0 else[])
        if mode.startswith('flash'):return []
        if mode.startswith('tilt'):return [0,4,8,12]
        if mode.startswith(('expand','relax')):return [4,8]
        return [4,8,12]
    def digest(values):
        n=0
        for value in values:n=(n*131+value)%16777213
        return n
    part_modes={name for name in modes.values()if name.startswith(('arm_','central','reset'))}
    initial=previous=None;steps=[];calls=0;closed=0
    size=36+2*0x3f50+336
    with Path(str(prefix)+'.tasks').open('rb')as stream:
        while block:=stream.read(size):
            if len(block)!=size:raise ValueError('演出任务入口/返回记录被截断')
            frame,number,pool,entry,handle,index,following,active,result=struct.unpack_from('>9I',block)
            if entry not in modes or frame>=13197:continue
            before,after=block[36:36+0x3f50],block[36+0x3f50:36+2*0x3f50]
            config,before_vars,after_vars=block[-336:-256],block[-256:-128],block[-128:]
            mode=modes[entry]
            for at in range(0x2350):
                if at not in covered and before[at^7]!=after[at^7]:
                    raise ValueError(('演出任务漏记本体写回',mode,hex(at)))
            values={at:read(before,at,w)for at,w in fields}
            if initial is None:initial=values.copy()
            patches=[n for at,_ in fields if previous is not None and values[at]!=previous[at]for n in(at,values[at])]
            configs=[read(config,i*4)for i in range({'tilt_init':2,'pose_init':1}.get(mode,0))]
            state=[]
            if active:
                for at in private(mode,after_vars):
                    value=read(after_vars,at)
                    if at==4 and mode in part_modes:value-=body
                    state.extend((at,value))
            ops=[list(value)for r in operations[number]if(value:=normalize(r))is not None]
            if mode=='leap_smoke'and any(r[0]==0xc0966d0 for r in operations[number]):
                ops.insert(0,[['leap_dust',read(before,0x1b7c),read(before,0x1b80),120],0])
            if mode=='landing_init':
                # 每个脚点的两组四份图形合并为一个效果工厂请求，脚点取独立 helper 的实参。
                strips=[r for r in operations[number]if r[0]==0xc156670]
                if len(strips)!=4:raise ValueError('落地烟尘缺少四组图形分配')
                for r in strips[::2]:ops.append([['land_burst',*r[21:23],120],0])
            if mode=='landing':
                offsets=[r[-1]for r in operations[number]if r[0]in(0xc0760b0,0xc0760d0)]
                if len(offsets)!=2:raise ValueError('落地缺少两次画面偏移读取')
                ops.insert(0,[['camera_offset'],offsets])
                if any(r[0]==0xc0966d0 for r in operations[number]):
                    ops.append([['land_dust',read(before,0x1b7c),read(before,0x1b80),120],0])
            calls+=len(ops);closed+=not active
            steps.append([frame,number,handle,index,mode,modes[following],bool(active),configs,patches,
                          digest(read(after,at,w)for at,w in fields),state,ops])
            previous={at:read(after,at,w)for at,w in fields}
    if not steps:raise ValueError('没有已移植的演出任务回调')
    def lua(value):
        if isinstance(value,str):return '"'+value+'"'
        if isinstance(value,bool):return 'true'if value else'false'
        if isinstance(value,(tuple,list)):return '{'+','.join(map(lua,value))+'}'
        return str(value)
    lines=['-- 原版二十槽演出任务的独立返回和挂载探针；仅作回归，不载入游戏。',
           'return {',f'    states={len(steps)},calls={calls},closed={closed},depth=120,',
           '    initial={'+','.join(f'[{a}]={v}'for a,v in sorted(initial.items()))+'},','    steps={']
    lines+=['        '+lua(r)+','for r in steps];lines+=['    },','}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_control(prefix,output):
    modes={0xc14fe20:'entry_init',0xc14fbf0:'entry',0xc151610:'pattern_init',0xc151880:'pattern',
           0xc1516e0:'leap_init',0xc151ba0:'leap',0xc151740:'wide_init',0xc151d50:'wide'}
    spawns={0xc154a10:('enter_pose',0),0xc154c80:('enter_flash',0),0xc156130:('tilt',2),
            0xc157c60:('head',0),0xc157be0:('burst',2),0xc157ce0:('side',4),
            0xc155060:('pose_left',0),0xc1550d0:('pose_right',0),0xc155ea0:('leap_smoke',0),
            0xc157e30:('leap_gun',1),0xc157d80:('wide_gun',1),0xc154ee0:('reset_pose',0)}
    movements={0xc14f690:('simple_init',0),0xc14f870:('move_init',3)}
    raw_fields=[20,24,28,32,40,88,0x233c,0x2340]
    def read(raw,at):return struct.unpack_from('<i',raw,at^4)[0]
    operations=defaultdict(list)
    with Path(str(prefix)+'.control-ops').open(encoding='utf-8')as stream:
        for line in stream:
            row=list(map(int,line.split()));operations[row[0]].append(row[1:])
    def normalize(r):
        fn,a,b,c,d,*tail=r;cfg,result=tail[:8],tail[8]
        if fn in(0xc078130,0xc077ea0):
            name,length=spawns[b];return ['spawn',name]+cfg[:length],result
        if fn==0xc0783f0:return ['control',modes[b]],result
        if fn==0xc0784e0:return ['remove'],0
        if fn in(0xc0786a0,0xc078730):
            name,length=movements[b];return ['motion','replace'if fn==0xc0786a0 else'ensure',name]+cfg[:length],0
        if fn in(0xc0780a0,0xc078330):return ['alive','gun'if fn==0xc0780a0 else'task',b],result!=0
        if fn==0xc0780c0:return ['stop',b,c],0
        if fn==0xc0631f0:return ['random',a],result
        if fn==0xc155960:return ['pose',b,c],0
        if fn==0xc1561a0:return ['jump'],0
        if fn==0xc41b4a4:return ['signal','boss_scene',a],0
        signals={0xc14e290:['open_view'],0xc14e230:['clear_footprints'],0xc14b5b0:['enable_collision',b!=0],
                 0xc10ea20:['stage_scroll',a],0xc068150:['activate_boss',b]}
        if fn in signals:return ['signal']+signals[fn],0
        if fn in(0xc078470,0xc1561c0):return None
        raise ValueError(('未处理的主任务接口',hex(fn)))
    def private_fields(mode,after):
        if mode=='entry_init':return [0,4]
        if mode=='entry':return [0,4]+([8]if read(after,0)!=0 else[])
        if mode in('leap_init','leap'):return [0,4,8]
        values=[0,4,8,16,20,24,28,40,44]
        state=read(after,0)
        if mode in('pattern','wide')and state>=10:values.append(32)
        if mode=='pattern'and state>=20:values.append(12)
        if mode=='pattern'and state>=40:values.append(36)
        return sorted(values)
    steps=[];previous=None;initial=None;calls=0
    size=28+0x3f50*2+160
    with Path(str(prefix)+'.control').open('rb')as stream:
        while block:=stream.read(size):
            if len(block)!=size:raise ValueError('主任务入口/返回记录被截断')
            frame,number,entry,handle,following,active,result=struct.unpack_from('>7I',block)
            if entry not in modes:continue
            before,after=block[28:28+0x3f50],block[28+0x3f50:28+0x3f50*2]
            before_vars,after_vars=block[-160:-80],block[-80:]
            values={at:read(before,at)for at in raw_fields}
            if initial is None:initial=values.copy()
            patches=[n for at in raw_fields if previous is not None and values[at]!=previous[at]for n in(at,values[at])]
            ops=[]
            for r in operations[number]:
                op=normalize(r)
                if op:ops.append(list(op));calls+=1
            state_fields=private_fields(modes[entry],after_vars)if active else[]
            steps.append([frame,handle,modes[entry],modes[following],bool(active),patches,
                          [read(after,at)for at in raw_fields],
                          [n for at in state_fields for n in(at,read(after_vars,at))],ops])
            previous={at:read(after,at)for at in raw_fields}
    if not steps:raise ValueError('没有已移植的 Original 主任务回调')
    def lua(value):
        if isinstance(value,str):return '"'+value+'"'
        if isinstance(value,bool):return 'true'if value else'false'
        if isinstance(value,(tuple,list)):return '{'+','.join(map(lua,value))+'}'
        return str(value)
    lines=['-- 原版主任务入口/返回及直接调用接口；仅作回归输入与期望值，不载入游戏流程。',
           'return {',f'    states={len(steps)},calls={calls},',
           '    fields='+lua(raw_fields)+',',
           '    initial={'+','.join(f'[{a}]={v}'for a,v in sorted(initial.items()))+'},','    steps={']
    lines+=['        '+lua(r)+','for r in steps];lines+=['    },','}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


def compile_draw(prefix,output):
    module=Path('mod/GAME/th46/boss1_draw.lua').read_text(encoding='utf-8')
    def fields(name):return {int(a):int(w)for a,w in re.findall(r'\{(\d+),([124])\}',re.search(name+r'=\{(.*?)\},\n',module,re.S)[1])}
    inputs,outputs=fields('inputFields'),fields('outputFields')
    operations=defaultdict(list)
    with Path(str(prefix)+'.draw-ops').open(encoding='utf-8')as stream:
        for line in stream:
            r=line.split();operations[int(r[0])].append((r[1],list(map(int,r[2:]))))
    def digest(rows):
        value=0
        for row in rows:
            for n in row:value=(value*131+n)%16777213
        return value
    def read(raw,at,w):return struct.unpack_from({1:'<b',2:'<h',4:'<i'}[w],raw,at^{1:7,2:6,4:4}[w])[0]
    steps=[];initial=previous=None;total=0
    with Path(str(prefix)+'.draw').open('rb')as stream:
        while block:=stream.read(28+0x3f50*2):
            if len(block)!=28+0x3f50*2:raise ValueError('绘图入口/返回记录被截断')
            frame,number,color_at,alpha_at,depth,sx,sy=struct.unpack_from('>IIiiiii',block)
            before,after=block[28:28+0x3f50],block[28+0x3f50:]
            values={at:read(before,at,w)for at,w in inputs.items()}
            if initial is None:initial=values.copy()
            patches=[n for at in sorted(values)if previous is not None and values[at]!=previous[at]for n in(at,values[at])]
            rows,allocated,events,randoms=[],{},[],[]
            for kind,r in operations.pop(number):
                if kind=='S':
                    row=r[1:]+[0x808080,-1,0];allocated[r[0]]=row;rows.append(row)
                elif kind=='C':
                    fn,ptr,a,c,d=r
                    row=allocated.get(ptr)
                    if row is None:raise ValueError('属性找不到原精灵')
                    row[{0xc05e328:4,0xc05e2d8:6,0xc05e424:5}[fn]]=d if fn==0xc05e424 else a
                elif kind=='E':
                    fn,a,c=r
                    if fn==0xc09c4c0:events.append([1,a]);randoms.append(a-5)
                    elif fn==0xc154b40:events.append([2,c])
                    else:events.append([3,0])
            total+=len(rows)
            steps.append([frame,number,depth,sx,sy,read(before,color_at,4)if color_at>=0 else 0x808080,
                          read(before,alpha_at,4)if alpha_at>=0 else -1,patches,
                          digest([[read(after,at,w)for at,w in sorted(outputs.items())]]),
                          digest(rows),digest(events),len(rows),randoms])
            previous={at:read(after,at,w)for at,w in inputs.items()}
    if operations:raise ValueError('绘图请求缺少对应的本体回调')
    def lua(value):
        if isinstance(value,list):return '{'+','.join(map(lua,value))+'}'
        return str(value)
    lines=['-- 原版绘图入口/返回和独立精灵探针；仅外部字段作为补丁输入，绘图与牵引点均由算式生成。',
           'return {',f'    states={len(steps)},sprites={total},',
           '    initial={'+','.join(f'[{a}]={v}'for a,v in sorted(initial.items()))+'},','    steps={']
    lines+=['        '+lua(r)+','for r in steps];lines+=['    },','}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('prefix',type=Path)
    parser.add_argument('output',type=Path)
    parser.add_argument('--mode',choices=('core','head','guns','pose','motion','birth','draw','control','tasks','extra-guns'),default='core')
    args = parser.parse_args()
    if args.mode=='core':
        compile_core(args.prefix,args.output)
    elif args.mode=='pose':
        compile_pose(args.prefix,args.output)
    elif args.mode=='motion':
        compile_motion(args.prefix,args.output)
    elif args.mode=='birth':
        compile_birth(args.prefix,args.output)
    elif args.mode=='extra-guns':
        compile_extra_guns(args.prefix,args.output)
    elif args.mode=='draw':
        compile_draw(args.prefix,args.output)
    elif args.mode=='control':
        compile_control(args.prefix,args.output)
    elif args.mode=='tasks':
        compile_tasks(args.prefix,args.output)
    else:
        compile_guns(args.prefix,args.output,only_head=args.mode=='head')
