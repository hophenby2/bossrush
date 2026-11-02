"""只沿TH07入口的标量分支核对保护和计时；不执行弹幕、运动或对象逻辑。"""
from ecl_source import Variable


def prefix10(source, sub, difficulty=3, visual_branch=0):
    """TH10多次setInvuln入口：按栈条件、跳转重设时间及wait还原实际经过帧数。"""
    rows = source.subs[sub]
    stop = max(i for i, r in enumerate(rows) if r.op == 335)
    lookup = {r.address:i for i, r in enumerate(rows)}
    external = {-9959:difficulty, -9986:visual_branch}
    stack, pc, offset, events = [], 0, 0, []
    def value(arg):
        if not isinstance(arg, Variable):return arg
        assert arg.index in external, ('TH10入口未知变量',arg)
        return external[arg.index]
    for _ in range(10000):
        index = pc
        r = rows[pc];pc += 1
        if not r.mask & (1 << difficulty):continue
        if r.op == 42:stack.append(value(r.args[0]))
        elif r.op in (59,69):
            right,left=stack.pop(),stack.pop()
            stack.append(int(left==right if r.op==59 else left>=right))
        elif r.op in (12,13,14):
            take=True if r.op==12 else (stack.pop()==0 if r.op==13 else stack.pop()!=0)
            if take:
                offset+=r.time-r.args[1]
                pc=lookup[source.labels[r.args[0]]]
        elif r.op==83:offset+=value(r.args[0])
        elif r.op==335:
            events.append(dict(frame=r.time+offset,op=r.op,value=value(r.args[0]),
                               address=hex(r.address),script_time=r.time))
        elif r.op not in (21,40,256,280,281,325,326,327,328,329,331,334,336,
                         342,343,344,345,347,357,359,360,364,420,421):
            raise NotImplementedError(('TH10入口含未核对调度',hex(r.address),r.op))
        if index==stop:
            assert not stack, ('TH10入口栈未平衡',sub)
            return events
    raise AssertionError('TH10入口分支未收敛')


def factor10(events, frame):
    deadline = 0
    for event in events:
        if event['frame']>frame:break
        deadline = event['frame']+event['value']
    return 0 if frame<deadline else 1

# stop是最后一条入口减伤指令；到这里为止均没有CALL/WAIT。
CASES = {3451:(8,63),3461:(7,61),4468:(2,68),4469:(2,75),4471:(2,70)}


def prefix(source, sub, difficulty=3):
    rows=source.subs[f'Sub{sub}']
    guards=[i for i,r in enumerate(rows) if r.op==142]
    assert guards, '入口没有显式减伤计时，须核对跨阶段继承'
    stop=max(i for i,r in enumerate(rows) if r.op in (103,114,142))
    lookup={r.address:i for i,r in enumerate(rows)}
    variables={10016:difficulty}
    pc,offset=0,0
    result=[]
    def val(a):
        if isinstance(a,Variable):
            assert a.index in variables, ('入口依赖未确定变量',a)
            return variables[a.index]
        return a
    for _ in range(10000):
        r=rows[pc];pc+=1
        if not r.mask&(1<<difficulty):continue
        if r.op in (4,5):
            variables[r.args[0].index]=val(r.args[1])
        elif r.op==2 or 28<=r.op<=39:
            if r.op==2:
                time,label=r.args;take=True
            else:
                a,b=map(val,r.args[:2]);time,label=r.args[2:]
                take=(a==b,a!=b,a<b,a<=b,a>b,a>=b)[(r.op-28)//2]
            if take:
                offset+=r.time-time
                pc=lookup[source.labels[label]]
        elif r.op in (103,114,142):
            result.append(dict(frame=r.time+offset,op=r.op,value=val(r.args[0]),
                               address=hex(r.address),script_time=r.time))
        elif r.op in (1,3,41,42,45,144):
            raise NotImplementedError(('入口含额外调度，不能忽略',hex(r.address),r.op))
        elif r.op not in (0,55,62,63,73,78,81,90,91,94,95,97,101,102,106,107,110,111,115,119,122,124,126,131,132,133,135,139,154):
            raise NotImplementedError(('入口含未核对副作用',hex(r.address),r.op))
        if pc-1==stop:return result
    raise AssertionError('入口分支未收敛')


def factor(events,frame):
    # 这些入口从上一阶段可受击状态进入；首10帧没有103(0)的卡不能提前全免。
    hittable,guard_until=True,0
    for event in events:
        if event['frame']>frame:break
        if event['op']==103:hittable=bool(event['value'])
        elif event['op']==142:guard_until=event['frame']+event['value']
    return 0 if not hittable else 1/9 if frame<guard_until else 1


def prefix08(source,sub):
    """TH08只接受不含CALL/WAIT/外部条件的保护入口；其余明确交回逐子程序核对。"""
    rows=source.subs[sub]
    guards=[i for i,r in enumerate(rows) if r.op==160]
    assert guards, '入口没有显式减伤计时，须核对跨阶段继承'
    stop=max(i for i,r in enumerate(rows) if r.op in (79,80,81,134,160))
    lookup={r.address:i for i,r in enumerate(rows)}
    variables={10040:3}
    pc,offset=0,0
    events=[]
    def val(a):
        if isinstance(a,Variable):
            assert a.index in variables, ('入口依赖未确定变量',a)
            return variables[a.index]
        return a
    for _ in range(10000):
        r=rows[pc];pc+=1
        if not r.mask&8:continue
        if r.op in (6,7):
            if isinstance(r.args[1],Variable) and r.args[1].index not in variables:
                variables.pop(r.args[0].index,None)
            else:variables[r.args[0].index]=val(r.args[1])
        elif r.op==4 or 40<=r.op<=51:
            if r.op==4:time,label=r.args;take=True
            else:
                a,b=map(val,r.args[:2]);time,label=r.args[2:]
                take=(a==b,a!=b,a<b,a<=b,a>b,a>=b)[(r.op-40)//2]
            if take:offset+=r.time-time;pc=lookup[source.labels[label]]
        elif r.op in (79,80,81,134,160):
            events.append(dict(frame=r.time+offset,op=r.op,value=val(r.args[0]),
                               address=hex(r.address),script_time=r.time))
        elif r.op not in (0,54,55,56,57,58,59,60,61,62,63,64,65,66,67,75,76,77,78,
                          95,105,110,113,122,123,124,127,129,130,131,132,144,153,155,157,173,177,182,183):
            raise NotImplementedError(('TH08入口含未核对的调度或副作用',hex(r.address),r.op))
        if pc-1==stop:return events
    raise AssertionError('TH08入口分支未收敛')


def factor08(events,frame):
    disabled,guard_until=0,0
    for event in events:
        if event['frame']>frame:break
        op,value=event['op'],event['value']
        if op==79:disabled=value
        elif op==80:disabled|=value
        elif op==81:disabled&=~value
        elif op==160:guard_until=event['frame']+value
    return 0 if disabled&5 else 1/9 if frame<guard_until else 1
