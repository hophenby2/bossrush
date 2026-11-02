"""逐帧比较六段三姐妹非符的发射指令、命令继承、激光和移动请求；不等同于完整轨迹验证。"""
import math
from pathlib import Path
import sys

from card_catalogue import runtime, plain
from ecl_source import Source, Variable, f32


class Reference:
    # 只在离线测试中解释原始文件。未列出的指令必须报错。
    def __init__(self, source, sub, rank):
        self.source, self.sub, self.rank = source, sub, rank
        self.pc = self.time = self.frame = 0
        self.variables = dict.fromkeys(range(10000, 10016), 0)
        self.globals = dict.fromkeys(range(10037, 10045), 0)
        self.stack, self.events = [], []
        self.command, self.low, self.high = None, 0, 0

    def get(self, v):
        if not isinstance(v, Variable): return v
        if v.index in self.variables: return self.variables[v.index]
        if v.index in self.globals: return self.globals[v.index]
        return {10024:f32(.731), 10060:f32(-.456)}[v.index]

    def put(self, v, value, floating=False):
        target = self.globals if v.index in self.globals else self.variables
        target[v.index] = f32(value) if floating else int(value)

    def jump(self, time, label):
        self.time = time
        address = self.source.labels[label]
        self.pc = next(i for i,r in enumerate(self.source.subs[self.sub]) if r.address==address)

    def event(self, kind, *values):
        self.events.append([self.frame,kind,*values])

    def tick(self):
        for _ in range(10000):
            row = self.source.subs[self.sub][self.pc]
            if row.time != self.time: break
            self.pc += 1
            if not row.mask&8: continue
            raw, op = row.args, row.op
            a = [self.get(v) for v in raw]
            if op in (4,5):self.put(raw[0],a[1],op==5)
            elif op in (12,13,14,15,16,19,20,21,22,23):
                i=op-12 if op<19 else op-19
                left,right=a[1:]
                value=(lambda:left+right,lambda:left-right,lambda:left*right,
                       lambda:left/right,lambda:math.fmod(left,right))[i]()
                self.put(raw[0],value,op>=19)
            elif op==17:self.put(raw[0],a[0]+1)
            elif op==2:self.jump(*a)
            elif op==3:
                self.put(raw[2],a[2]-1)
                if self.get(raw[2])>0:self.jump(a[0],a[1])
            elif op==40:
                angle=a[0];pi=f32(math.pi)
                while angle>pi:angle=f32(angle-2*pi)
                while angle< -pi:angle=f32(angle+2*pi)
                self.put(raw[0],angle,True)
            elif op==41:
                self.stack.append((self.sub,self.pc,self.time,self.variables.copy()))
                self.variables.update({k-8:v for k,v in self.globals.items()})
                self.sub,self.pc,self.time=f'Sub{a[0]}',0,0
            elif op==42:self.sub,self.pc,self.time,self.variables=self.stack.pop()
            elif op==52:self.put(raw[0],.345,True)
            elif op==54:self.event('drift',a[3],a[0],a[1])
            elif op==55:self.event('move',a[0],a[1],a[2],a[3])
            elif op==117:
                assert a[0]==17
                self.event('charge',a[1])
            elif op==79:
                assert a[0]==0
                self.command=a[1:]
            elif op==131:self.low,self.high=a[:2]
            elif op in (64,65,66,67):
                p=a[:8]
                offset=f32(self.low+self.rank*(self.high-self.low)/32)
                p[4]=max(.3,f32(p[4]+offset));p[5]=max(.3,f32(p[5]+offset/2))
                self.event('shoot',op,*p,a[8],self.command.copy() if self.command else [])
            elif op==82:self.event('laser',*a)
            elif op not in (0,62,78,91,102,103,105,108,110,114,119,132,142,145,154):
                raise NotImplementedError((self.sub,hex(row.address),op))
        else:raise AssertionError('原始程序零帧循环')
        self.time+=1
        self.frame+=1


def check():
    source=Source(Path('E:/workspace/.bossrush-validation/original-anm/ecl/7/ecldata4.decl'),
                  Path('E:/workspace/原作/ECL/th07/ecldata4.ecl'),7)
    lua=runtime()
    lua.execute('''
        local ffi=require('ffi');local f=ffi.new('float[1]')
        function pf(x) f[0]=x;return tonumber(f[0]) end
        function prism_events(name,frames,rank)
            local events={};local clock=0
            local function event(kind,...) events[#events+1]={clock,kind,...} end
            local api={
                random_angle=function()return pf(-.456) end,aim=function()return pf(.731) end,
                f32=pf,normalize=function(a)
                    local pi=pf(math.pi)
                    while a>pi do a=pf(a-2*pi) end
                    while a< -pi do a=pf(a+2*pi) end
                    return a
                end,
                move=function(o,t,e,x,y)event('move',t,e,x+192,224-y)end,
                drift=function(o,s,t,e)event('drift',s,t,e)end,
                charge=function(o,n)event('charge',n)end,
                shoot=function(o,x,y,op,s,c,n,l,v1,v2,a,da,cmd)
                    local flags=cmd.flags
                    cmd=cmd.list[1]
                    local command={}
                    if cmd then command={cmd.type,cmd.flag,cmd.dur,cmd.loop,
                        cmd.type==32 and cmd.speed or -cmd.angle*math.pi/180,
                        cmd.type==32 and -cmd.angle*math.pi/180 or cmd.speed} end
                    event('shoot',op,s,c,n,l,v1,v2,a,da,flags,command)
                end,
                laser=function(x,y,a,s)
                    event('laser',s.sprite,s.color,-a,s.spd,s.sOff,s.eOff,s.sLen,s.w,
                        s.tStart,s.dur,s.tEnd,s.hbStart,s.hbEnd,s.flags)
                end,
            }
            local impl=dofile('mod/GAME/th34_prism_nonspells.lua')(api)
            local co=coroutine.create(function()impl[name]({th07_rank=rank,x=0,y=112})end)
            task.Wait=function(n)for i=1,n do coroutine.yield()end end
            for t=0,frames-1 do clock=t;local ok,err=coroutine.resume(co);assert(ok,err) end
            return events
        end
    ''')
    checks=0
    def equal(a,b,where):
        nonlocal checks
        if isinstance(b,list):
            if a=={}:a=[]
            assert len(a)==len(b),(where,a,b)
            for i,(x,y) in enumerate(zip(a,b)):equal(x,y,(*where,i))
        elif isinstance(b,(int,float)):
            assert math.isclose(a,b,rel_tol=1e-6,abs_tol=3e-5),(where,a,b)
            checks+=1
        else:assert a==b,(where,a,b)
    for name,sub in [('luna2',64),('luna3',68),('merlin2',80),('merlin3',83),('lyrica2',98),('lyrica3',103)]:
        for rank in (10,16,32):
            ref=Reference(source,f'Sub{sub}',rank)
            for _ in range(3600):ref.tick()
            actual=plain(lua.globals().prism_events(name,3600,rank))
            equal(actual,ref.events,(name,rank))
        print(name,'完整3600帧，Rank 10/16/32，发弹/变速命令/激光/移动请求相符')
    print(f'三姐妹六段非符：{checks}项标量比较通过；不覆盖弹体实际运动、命中、池满或像素画面。')


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    check()
