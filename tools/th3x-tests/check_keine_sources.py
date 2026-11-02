"""以原始ECL运行的父/子context比较慧音两段补入攻击，覆盖整张卡的生成、运动、枪和激光。"""
from pathlib import Path
import math
import sys

from card_catalogue import runtime, plain
from ecl_source import Source, ScalarTrace, f32

SOURCE = Source(Path('E:/workspace/.bossrush-validation/original-anm/ecl/8/ecldata3.decl'),
                Path('E:/workspace/原作/ECL/th08/ecldata3.ecl'))
EFFECTS = (64,72,74,75,77,83,90,95,105,110,113,122,129,130,132,134,135,145,153,160,174,177)


def reference(root, frames, player=(192,400)):
    x,y=192.,128.
    ctx=ScalarTrace(SOURCE,f'Sub{root}',external=lambda index,t:
                    {10040:3,10042:x,10043:y}.get(index,0),effects=EFFECTS,snapshots=True)
    actors, births, shots, lasers, positions = [],[],[],[],[]
    move=None
    boss_gun=None

    class Actor:
        def __init__(self,event,born):
            sub,self.x,self.y,hp,*_=event['args']
            self.born,self.sub=born,sub
            self.ctx=ScalarTrace(SOURCE,f'Sub{sub}',variables=event['variables'],external=self.get,
                                 effects=EFFECTS,snapshots=True)
            self.cx,self.cy,self.angle,self.omega,self.radius,self.radial=0,0,0,0,0,0
            self.gun=None
            births.append([born,sub,self.x-192,224-self.y,hp])

        def get(self,index,t):
            return {10042:self.x,10043:self.y}.get(index,self.ctx.variables.get(index,0))

        def tick(self,t):
            start=len(self.ctx.events);self.ctx.tick()
            for e in self.ctx.events[start:]:
                a=e['args']
                if e['op']==72: _,self.cx,self.cy,self.angle,self.omega,self.radius,self.radial=a
                elif e['op']==74: _,self.omega,self.radial=a
                elif e['op']==135:
                    self.gun=ScalarTrace(SOURCE,f'Sub{a[1]}',external=self.get,effects=EFFECTS)
            if self.ctx.done:return False
            if self.gun:collect_gun(self.gun,t,self.x,self.y,self.sub)
            self.angle=f32(self.angle+self.omega)
            if self.angle>math.pi:self.angle=f32(self.angle-2*math.pi)
            elif self.angle< -math.pi:self.angle=f32(self.angle+2*math.pi)
            self.radius=f32(self.radius+self.radial)
            self.x=f32(self.cx+f32(math.cos(self.angle)*self.radius))
            self.y=f32(self.cy+f32(math.sin(self.angle)*self.radius))
            positions.append([t,self.born,self.sub,self.x-192,224-self.y])
            return True

    def collect_gun(gun,t,x,y,sub):
        start=len(gun.events);gun.tick()
        for e in gun.events[start:]:
            if 96<=e['op']<=99:
                # SET_BOSS将本体的近身距离清零，附着使魔仍是出生默认值。
                if sub==root or (x-player[0])**2+(y-player[1])**2>=1024:
                    a=e['args'];shots.append([t,sub,x-192,224-y,e['op'],*a[:6],-a[6],-a[7],a[8]])
            elif e['op']==114:
                lasers.append([t,x-192,224-y,-e['args'][2],*e['args'][:2],*e['args'][3:]])

    for t in range(frames):
        start=len(ctx.events);ctx.tick()
        for e in ctx.events[start:]:
            if e['op']==64:
                n,ease,tx,ty=e['args'];assert ease==4
                move=(t,n,x,y,tx-x,ty-y)
            elif e['op']==90:actors.append(Actor(e,t))
            elif e['op']==135:
                boss_gun=ScalarTrace(SOURCE,f'Sub{e["args"][1]}',effects=EFFECTS)
        if boss_gun:collect_gun(boss_gun,t,x,y,root)
        if move:
            begin,n,sx,sy,dx,dy=move;u=min(1,(t-begin+1)/n);q=1-(1-u)**2
            x,y=sx+dx*q,sy+dy*q
            if u==1:move=None
        actors=[a for a in actors if a.tick(t)]
    return births,shots,lasers,positions


def check():
    lua=runtime()
    lua.execute('''
        audit_cards={};boss.card.add=function(parts,_,_,id) audit_cards[id]=parts[1][1] end
        local raw_new=New
        audit_objects={};audit_clock=0;audit_active=false
        New=function(cls,...)
            local o=raw_new(cls,...)
            if audit_active and (o.keine_x or o.keine_phase) then
                o.audit_birth=audit_clock;audit_objects[#audit_objects+1]=o
                if o.keine_x then
                    audit_births[#audit_births+1]={audit_clock,tonumber(o.th08_source:match(':(%d+)')),
                        o.x,o.y,o._original_raw_hp}
                else
                    audit_lasers[#audit_lasers+1]={audit_clock,o.x,o.y,o.rot*math.pi/180,
                        0,o.index-1,0,0,640,640,12,120,20,10,90,10,0}
                end
            end
            return o
        end
        dofile('mod/GAME/th31.lua')
        local function find(fn,wanted,seen)
            if (type(fn)~='function' and type(fn)~='table') or seen[fn] then return end;seen[fn]=true
            if type(fn)=='table' then
                for _,v in pairs(fn) do local out=find(v,wanted,seen);if out then return out end end
                return
            end
            for i=1,100 do
                local name,v=debug.getupvalue(fn,i);if not name then break end
                if name==wanted then return v end
                if name~='M' and name~='class' then
                    local out=find(v,wanted,seen);if out then return out end
                end
            end
        end
        audit_ex=assert(find(audit_cards[3426].frame,'EX',{}))
        function audit_keine(id,frames,px,py)
            audit_births,audit_shots,audit_lasers,audit_positions={},{},{},{}
            audit_objects={};audit_active=true
            local card=audit_cards[id]
            local b={x=0,y=96,timer=0,ani=0,rot=0};player.x,player.y=px-192,224-py
            local save=audit_ex.shoot
            audit_ex.shoot=function(o,x,y,a)
                local sub=o.th08_source and tonumber(o.th08_source:match(':(%d+)')) or (id==3426 and 30 or 71)
                audit_shots[#audit_shots+1]={audit_clock,sub,x,y,a.op,a.type,a.color-1,
                    a.count1,a.count2,a.speed1,a.speed2,a.angle,a.step,a.flags}
            end
            card.init(b)
            for t=0,frames-1 do
                audit_clock=t;b.timer,b.ani=t,t;card.frame(b)
                local i=1
                while i<=#audit_objects do
                    local o=audit_objects[i];i=i+1
                    if IsValid(o) then
                        o.class.frame(o)
                        if o.keine_x and IsValid(o) then
                            audit_positions[#audit_positions+1]={t,o.audit_birth,
                                tonumber(o.th08_source:match(':(%d+)')),o.x,o.y}
                        end
                        o.timer,o.ani=o.timer+1,o.ani+1
                    end
                end
            end
            card.del(b);audit_ex.shoot=save;audit_active=false
            for _,o in ipairs(audit_objects) do assert(not IsValid(o),'卡结束后使魔/激光未回收') end
            return {audit_births,audit_shots,audit_lasers,audit_positions}
        end
        function audit_keine_beam()
            local c=_editor_class.TH31.th08_keine_laser
            local o=New(c,0,0,0)
            local out={}
            for t=0,150 do
                if IsValid(o) then c.frame(o) end
                out[#out+1]={IsValid(o),o.keine_phase,o.w,o.colli}
            end
            return out
        end
    ''')
    checked=0
    for id,root,frames,player in ((3426,30,2280,(192,400)),(3427,71,2100,(192,400)),
                                 (3426,30,400,(192,192)),(3426,30,400,(128,192)),
                                 (3427,71,400,(192,128))):
        actual=plain(lua.globals().audit_keine(id,frames,*player))
        expected=reference(root,frames,player)
        for label,got,want in zip(('出生','发弹','激光','位置'),actual,expected):
            # 同帧按原作对象槽遍历。测试不创建真子弹，弹雾与对象池由原生引擎另验。
            got=got or []
            if isinstance(got,dict):got=[]
            assert len(got)==len(want),(id,label,len(got),len(want))
            for n,(a,b) in enumerate(zip(got,want)):
                assert len(a)==len(b),(id,label,n,a,b)
                for j,(v,w) in enumerate(zip(a,b)):
                    # 原作f32公转累计与Lua双精度容许2/1000像素；时间、数量、整数参数仍精确比较。
                    assert math.isclose(v,w,rel_tol=0,abs_tol=.002 if isinstance(w,float) else 0), (id,label,n,j,v,w)
                    checked+=1
        print(f'{id} 自机{player}：{len(expected[0])}只使魔、{len(expected[1])}次出弹、{len(expected[2])}根激光、{len(expected[3])}个逐帧位置通过。')
    descriptor=next(r.args for r in SOURCE.subs['Sub74'] if r.op==114)
    width,start,duration,ending,hit,hitend=descriptor[7:13]
    phase,timer=1,0
    expected=[]
    for frame in range(int(start+duration+ending)+1):
        active=True
        if phase==1:
            w=timer*width/start if timer>start-min(30,start) else 1.2
            colli=timer>=hit
            if timer>=start:phase,timer=2,0
        if phase==2:
            w,colli=width,True
            if timer>=duration:phase,timer=3,0
        if phase==3:
            if timer>=ending:active=False
            else:w,colli=width*(1-timer/ending),timer<hitend
        expected.append([active,phase,w,colli]);timer+=1
    for frame,(actual,want) in enumerate(zip(plain(lua.globals().audit_keine_beam()),expected)):
        for value,target in zip(actual,want):
            assert abs(value-target)<1e-9,(frame,'激光预热/生效/消散',actual,want)
            checked+=1
    print('高天原激光151帧的宽度、判定开关和退场状态通过。')
    print(f'共{checked}项比较；不包含实际子弹轨迹、击破后的分支、刻符路线条件或逐帧画面。')


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');check()
