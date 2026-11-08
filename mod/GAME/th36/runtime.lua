-- 地灵殿的Lua对象后端。时间、变量、双路运动按TH11重建工程SecondaryScript/
-- SecondaryActor{Creation,Update,Motion,Transition}核对；ECL在离线工具中展开。
-- 场地384×448，原坐标x不缩放，y写入LuaSTG时才换成224-y。
local class=...
local H={}
local object,enemy,New,IsValid=object,enemy,New,IsValid
local A=OriginalANM
local bit=require('bit')
local band,bor,bnot=bit.band,bit.bor,bit.bnot
local ffi=require('ffi')
local single=ffi.new('float[1]')
local PI,TAU=3.1415927410125732,6.2831854820251465
local yield=coroutine.yield
local programs={}
class.runtime=H
H.programs=programs
function H.f32(n) single[0]=n;return tonumber(single[0]) end
function H.int(n) return bit.tobit(n<0 and math.ceil(n) or math.floor(n)) end
function H.random32(s)
    local high=band(bit.bxor(s.random_seed,0x9630)-0x6553,65535)
    s.random_seed=band(bit.rshift(high,14)+bit.lshift(high,2),65535)
    local low=band(bit.bxor(s.random_seed,0x9630)-0x6553,65535)
    s.random_seed=band(bit.rshift(low,14)+bit.lshift(low,2),65535)
    s.random_calls=s.random_calls+2
    return high*65536+low
end
function H.random(s,lo,hi)
    local unit=H.f32(H.f32(H.random32(s))/4294967296)
    return H.f32(lo+H.f32((hi-lo)*unit))
end
function H.angle(n)
    n=H.f32(n)
    while n>PI do n=H.f32(n-TAU) end
    while n< -PI do n=H.f32(n+TAU) end
    return n
end
local function quantize(n) return H.f32(math.floor(H.f32(n*100))/100) end
local function live(a) return not a.dead and IsValid(a.o) end
function H.clock(a) return a.session.frame end
function H.push(v,n) v.s[#v.s+1]=n end
function H.pop(v) local n=assert(v.s[#v.s],'TH11表达式栈下溢');v.s[#v.s]=nil;return n end
function H.at(a,v,t)
    while H.clock(a)-v.origin<t do yield() end
    -- 防止错误展开把原作含wait的循环变成零帧死循环。
    v.steps=v.stamp==H.clock(a) and v.steps+1 or 1;v.stamp=H.clock(a)
    assert(v.steps<100000,'TH11零帧循环：'..v.name)
end
local function context(a,name,args)
    local v={l={},s={},origin=H.clock(a),name=name,steps=0}
    for i,n in ipairs(args or {}) do v.l[(i-1)*4]=n end
    return v
end
function H.call(a,v,fn,name,...)
    assert(fn,'TH11子程序缺失：'..name)
    -- 勇仪在同一个演员上从MBoss转入Boss，不能只看enmCreate的名称判定终战。
    if name=='Boss' then a.final_boss=true;a.session.final_actor=a end
    local start=H.clock(a)
    fn(a,context(a,name,{...}))
    v.origin=v.origin+H.clock(a)-start
end
local function thread(a,fn,name,id,args)
    assert(fn,'TH11子程序缺失：'..name)
    local t={id=id,name=name}
    t.co=coroutine.create(function() fn(a,context(a,name,args)) end)
    return t
end
function H.async(a,fn,name,id,...)
    table.insert(a.threads,2,thread(a,fn,name,id,{...}))
end
function H.stop_thread(a,id) for _,t in ipairs(a.threads) do if t.id==id then t.dead=true;break end end end
function H.stop_threads(a) for i=2,#a.threads do a.threads[i].dead=true end end
function H.read(a,v,index)
    if index==-1 then return H.pop(v) end
    if index==-10000 then return bit.tobit(H.random32(a.session)) end
    if index==-9999 then return H.random(a.session,0,1) end
    if index==-9998 then return H.random(a.session,-PI,PI) end
    if index==-9987 then return H.random(a.session,-1,1) end
    if index==-9997 or index==-9977 then return a.o.x end
    if index==-9996 or index==-9976 then return 224-a.o.y end
    if index==-9989 then return math.atan2(224-player.y-(224-a.o.y),player.x-a.o.x) end
    if index==-9986 then return band(a.flags,0x100000)~=0 and 1 or 0 end
    if index==-9965 then return player.x end
    if index==-9964 then return 224-player.y end
    if index==-9963 then local b=a.session.boss;return b and b.o.x or 0 end
    if index==-9962 then local b=a.session.boss;return b and 224-b.o.y or 0 end
    if index==-9971 then return a.motion[0].angle end
    if index==-9970 then return a.motion[1].angle end
    if index==-9958 then
        return math.atan2(a.dy or 0,a.dx or 0)
    end
    if index==-9988 then return a.phase_time end
    if index==-9959 then return a.session.stage==7 and 4 or 3 end
    if index==-9954 then return a.o.hp end
    if index==-9949 then return a.session.misses end
    if index==-9948 then return a.session.bombs end
    if index==-9947 then return a.session.capture end
    if index==-9946 then local n=0;for _,e in ipairs(a.session.actors) do if live(e) and band(e.flags,0x20)==0 then n=n+1 end end;return n end
    if index==-9945 then return a.session.shot end
    if index==-9944 then return math.sqrt((player.x-a.o.x)^2+(player.y-a.o.y)^2) end
    if index>=-9943 and index<=-9936 then local b=a.session.boss;return b and (b.vars[index-42] or 0) or 0 end
    assert(index>=-9985 and index<=-9978 or index>=-9935 and index<=-9932,'TH11未知全局变量：'..index)
    return a.vars[index] or 0
end
function H.write(a,index,n)
    if index==-9954 then a.o.hp=n
    elseif index==-9947 then a.session.capture=n
    elseif index==-9949 then a.session.misses=n
    elseif index==-9948 then a.session.bombs=n
    else a.vars[index]=n end
end
function H.ease(mode,u)
    if mode>=1 and mode<=3 then return u^(mode+1) end
    if mode>=4 and mode<=6 then return 1-(1-u)^(mode-2) end
    if mode>=9 and mode<=14 then
        local power=(mode-9)%3+2
        if mode<=11 then return u<.5 and (2*u)^power/2 or 1-(2-2*u)^power/2 end
        return u<.5 and (1-(1-2*u)^power)/2 or ((2*u-1)^power+1)/2
    end
    if mode==15 then return 0 end
    if mode==16 then return 1 end
    return u
end
local function motion(x,y) return {x=x,y=y,cx=x,cy=y,angle=0,speed=0,r=0,rv=0,tilt=0,ratio=1} end
function H.sync(a)
    local m,n=a.motion[0],a.motion[1]
    local x,y=quantize(m.x+n.x),quantize(m.y+n.y)
    if a.limit then
        local b=a.limit
        x=math.max(b[1]-b[3]/2,math.min(b[1]+b[3]/2,x))
        y=math.max(b[2]-b[4]/2,math.min(b[2]+b[4]/2,y))
    end
    a.dx,a.dy=x-a.o.x,y-(224-a.o.y)
    a.o.x,a.o.y=x,224-y
    a.o.vx,a.o.vy=0,0
end
local function compose(m)
    if m.circle then
        local x,y=math.cos(m.angle-m.tilt)*m.r,math.sin(m.angle-m.tilt)*m.r
        x=x*m.ratio
        m.x,m.y=m.cx+x*math.cos(m.tilt)-y*math.sin(m.tilt),m.cy+x*math.sin(m.tilt)+y*math.cos(m.tilt)
    end
end
function H.position(a,ch,x,y)
    local m=a.motion[ch]
    if x> -999999 then m.x=x end;if y> -999999 then m.y=y end
    m.circle=false;H.sync(a)
end
function H.position_time(a,ch,duration,mode,x,y)
    local m=a.motion[ch]
    m.pos={t=0,duration=duration,mode=mode,x=m.x,y=m.y,tx=x> -999999 and x or m.x,ty=y> -999999 and y or m.y}
    m.circle=false
end
function H.velocity(a,ch,angle,speed)
    local m=a.motion[ch]
    if angle> -999999 then m.angle=H.angle(band(a.flags,0x8000)~=0 and PI-angle or angle) end
    if speed> -999999 then m.speed=speed end
    m.circle=false
end
local function pair(m,key1,key2,t,mode,x,y)
    m[key1..'_tween']={t=0,duration=t,mode=mode,x=m[key1],y=m[key2],tx=x,ty=y,key2=key2}
end
function H.velocity_time(a,ch,t,mode,angle,speed)
    local m=a.motion[ch]
    local x=angle> -999999 and (band(a.flags,0x8000)~=0 and PI-angle or angle) or m.angle
    local y=speed> -999999 and speed or m.speed
    if mode==7 then x,y=angle> -999999 and angle or 0,speed> -999999 and speed or 0
    elseif math.abs(x-m.angle)>=PI then if x>m.angle then m.angle=m.angle+TAU else x=x+TAU end end
    pair(m,'angle','speed',t,mode,x,y);m.circle=false
end
function H.circle(a,ch,angle,speed,r,rv)
    local m=a.motion[ch]
    if not m.circle then m.cx,m.cy=m.x,m.y end
    if angle> -999999 then m.angle=H.angle(angle) end
    if speed> -999999 then m.speed=speed end
    if r> -999999 then m.r=r end
    if rv> -999999 then m.rv=rv end
    m.circle=true;compose(m);H.sync(a)
end
function H.circle_time(a,ch,t,mode,speed,r,rv)
    local m=a.motion[ch]
    pair(m,'angle','speed',t,mode,0,speed> -999999 and speed or m.speed)
    pair(m,'r','rv',t,mode,r> -999999 and r or m.r,rv> -999999 and rv or m.rv)
    m.circle=true;compose(m);H.sync(a)
end
function H.ellipse(a,ch,angle,speed,r,rv,tilt,ratio)
    H.circle(a,ch,angle,speed,r,rv)
    local m=a.motion[ch]
    if tilt> -999999 then m.tilt=H.angle(tilt) end
    if ratio> -999999 then m.ratio=ratio end
    compose(m);H.sync(a)
end
function H.bezier(a,ch,t,dx,dy,x,y,ex,ey)
    H.position_time(a,ch,t,8,x,y)
    a.motion[ch].pos.controls={dx,dy,ex,ey}
end
function H.motion_reset(a)
    a.motion[0],a.motion[1]=motion(a.o.x,224-a.o.y),motion(0,0)
end
function H.wander(a,ch,t,mode,speed)
    local b=a.limit or {0,128,280,96}
    local x,y=a.o.x,224-a.o.y
    local angle=H.random(a.session,-PI,PI)
    if x<b[1]-b[3]/4 then angle=angle/3
    elseif x>b[1]+b[3]/4 then angle=H.angle(angle/3+PI)
    elseif x<player.x then angle=angle/2 else angle=H.angle(angle/2+PI) end
    if y<b[2]-b[4]/4 then angle=math.abs(angle) elseif y>b[2]+b[4]/4 then angle=-math.abs(angle) end
    local m=a.motion[ch];m.angle,m.speed=angle,speed
    H.velocity_time(a,ch,t,mode,angle,0)
end
function H.limit(a,...) a.limit={...};H.sync(a) end
local function step_motion(m)
    for _,key in ipairs({'angle','r','tilt'}) do
        local s=m[key..'_tween']
        if s then
            s.t=s.t+1
            if s.mode==7 then
                if s.duration<=0 or s.t<s.duration then s.x,s.y=H.f32(s.x+s.tx),H.f32(s.y+s.ty) end
                m[key],m[s.key2]=s.x,s.y
            else
                local u=H.ease(s.mode,math.min(1,s.t/math.max(1,s.duration)))
                if key~='angle' or not m.circle then m[key]=H.f32(s.x+(s.tx-s.x)*u) end
                m[s.key2]=H.f32(s.y+(s.ty-s.y)*u)
            end
            if s.duration>0 and s.t>=s.duration then m[key..'_tween']=nil end
        end
    end
    if m.pos then
        local s=m.pos;s.t=s.t+1
        local u=H.ease(s.mode,math.min(1,s.t/math.max(1,s.duration)))
        if s.controls then
            -- mode8是Hermite，控制向量为端点导数，不是贝塞尔控制点。
            local c=s.controls;local u2,u3=u*u,u*u*u
            m.x=(2*u3-3*u2+1)*s.x+(u3-2*u2+u)*c[1]+(-2*u3+3*u2)*s.tx+(u3-u2)*c[3]
            m.y=(2*u3-3*u2+1)*s.y+(u3-2*u2+u)*c[2]+(-2*u3+3*u2)*s.ty+(u3-u2)*c[4]
        else m.x,m.y=s.x+(s.tx-s.x)*u,s.y+(s.ty-s.y)*u end
        if s.t>=s.duration then m.pos=nil end
    elseif m.circle then
        m.r=H.f32(m.r+m.rv);m.angle=H.angle(m.angle+m.speed);compose(m)
    else m.x,m.y=m.x+math.cos(m.angle)*m.speed,m.y+math.sin(m.angle)*m.speed end
    m.x,m.y=quantize(m.x),quantize(m.y)
end
function H.hurtbox(a,w,h) a.hurt={w,h};a.o._original_damage_box={w,h};a.o.a,a.o.b,a.o.rect=w/2,h/2,true end
function H.hitbox(a,w,h) a.hit={w,h};a.o._original_contact_box={w,h} end
function H.flags(a,flags,on)
    a.flags=on and bor(a.flags,flags) or band(a.flags,bnot(flags))
    a.o._original_hidden=band(a.flags,0x20)~=0
    a.o.colli=band(a.flags,0x20)==0
end
function H.life(a,hp) a.o.hp,a.o.maxhp=hp,hp end
function H.boss_slot(a,index)
    if index>=0 then a.session.boss=a;a.is_boss=true
    elseif a.session.boss==a then a.session.boss=nil end
end
function H.interrupt(a,slot,hp,time,next_name) a.interrupts[slot]={hp=hp,time=time,name=next_name} end
function H.timeout(a,slot,name) assert(a.interrupts[slot]);a.interrupts[slot].timeout=name end
function H.life_marker(a,slot,hp,color) a.markers[slot]={hp,color} end
function H.spell(a,id,timeout,bonus,name,opcode)
    if opcode==357 then id=id+(a.session.stage==7 and 4 or 3)
    elseif opcode==358 then id=id+2 elseif opcode==359 then id=id+1 end
    a.session.spell=id;a.session.capture=1;a.phase_time=0
    if H.on_spell then H.on_spell(a,id,name) end
end
function H.spell_end(a) a.session.spell=nil;a.survival=false end
function H.sound(a,id) if PlaySound and (id==0 or id==1 or id==2) then PlaySound(id==2 and 'enep00' or 'tan00',.25,math.max(-1,math.min(1,a.o.x/192))) end end
function H.shake(a,t,x,y) if misc and misc.ShakeScreen then misc.ShakeScreen(t,x/8) end end
function H.fog(a,limit,color) a.fog={limit,color} end
function H.stage_label(a,id) a.session.std_label=id end
function H.background_end(a) a.fog=nil end
function H.time_scale(a,rate)
    -- 原作367改的是全局动画时标；只节流ECL会让死亡演出里的弹仍以全速运动。
    local s=a.session
    s.changed_cyfps=true;s.clock_rate=rate
    lstg.var.CYFPS=(s.saved_cyfps or 60)*rate
end
function H.mark_effects(a) a.session.mark_effects=true end
function H.score(a,n) a.session.score=a.session.score+n end
function H.debug_entry(a,id) error('正式道中不应调用调试入口：'..id) end
function H.actor_group(a,op,id)
    if op==370 then a.actor_group=id
    elseif op==369 then H.flags(a,0x8000000,id~=0)
    else for _,e in ipairs(a.session.actors) do if e~=a and e.actor_group==id then H.erase(e) end end end
end
function H.drop_clear(a) a.drops={} end
function H.drop_extra(a,id,n) a.drops[id]=n end
function H.drop_area(a,w,h) a.drop_area={w,h} end
function H.drop_main(a,id) a.drop_id=id end
function H.drop(a)
    -- 差异1：道具采用本项目的power/faith体系，不改写玩家存档或原作计分系统。
    if item and item.DropItem then item.DropItem(a.o.x,a.o.y,{a.drops[1] or 0,a.drops[2] or 0,0}) end
end
function H.dialog(a,id)
    -- 差异2：对白由本项目流程略过；阻塞指令保留Boss生死等待，不虚增攻击时钟。
    a.session.dialog=id
    if a.session.final_dead then a.session.done=true end
end
function H.dialog_wait(a,v)
    local s=a.session
    if a.proxy and not a.practice and s.dialog==1 then
        local start=H.clock(a)
        -- 原MSG负责结束同步；省略对白后仍须等保留零血的Boss演出退出。
        while s.final_actor and live(s.final_actor) do yield() end
        v.origin=v.origin+H.clock(a)-start
        if s.final_dead then s.done=true end
    end
end
function H.boss_wait(a,v)
    local start=H.clock(a)
    while a.session.boss and live(a.session.boss) do yield() end
    v.origin=v.origin+H.clock(a)-start
    if a.session.final_dead then a.session.done=true end
end
function H.select_anm(a,id) a.bank=id end
local function archive(a,bank) return bank==0 and 'bullet' or bank==1 and 'enemy' or ('stgenm%02d'):format(a.session.stage) end
function H.anm_slot(a,slot,id)
    if id<0 then a.anm[slot]=nil;return end
    a.anm[slot]=A.new(11,archive(a,a.bank),id)
end
function H.anm_main(a,slot,id) H.anm_slot(a,slot,id);if slot==0 then a.base_script=id;a.base_bank=a.bank;a.poses=true end end
function H.anm_cast(a,slot) local bank=a.bank;a.bank=a.base_bank or a.bank;H.anm_slot(a,slot,(a.base_script or 0)+5);a.bank=bank end
function H.anm_switch(a,slot,event) if a.anm[slot] then A.interrupt(a.anm[slot],event) end end
function H.anm_reset(a) H.anm_slot(a,0,a.base_script or 0);a.poses=false end
function H.anm_rotate(a,slot,angle) if a.anm[slot] then a.anm[slot].rotation[3]=angle end end
function H.anm_death(a,id) a.death_anm=id end
local effect_class=Class(object,{
    init=function(o,game,file,id,x,y)
        o.vm=A.new(game,file,id);o.x,o.y=x,y;o.group,o.layer,o.colli,o.bound=GROUP.GHOST,LAYER.ENEMY,false,false
    end,
    frame=function(o) A.step(o.vm);if o.vm.finished and not o.vm.visible then object.RawDel(o) end end,
    render=function(o) A.draw(o.vm,o.x,o.y) end,
},true)
function H.effect(a,bank,id) local o=New(effect_class,11,archive(a,bank),id,a.o.x,a.o.y);a.session.effects[#a.session.effects+1]=o end
function H.effect_abs(a,bank,id) local o=New(effect_class,11,archive(a,bank),id,0,224);a.session.effects[#a.session.effects+1]=o end
function H.erase(a)
    if a.dead then return end
    a.dead=true
    for _,n in ipairs(a.ring_nodes or {}) do if IsValid(n) then object.RawDel(n) end end
    if a.session.boss==a then a.session.boss=nil end
    if a.final_boss then a.session.final_dead=true end
    if a.proxy then a.session.done=true else object.RawDel(a.o) end
end
function H.kill_all(a)
    -- main是整关的控制宿主，不属于这条指令要清掉的道中敌机。
    for _,e in ipairs(a.session.actors) do if e~=a and not e.proxy and not e.is_boss and band(e.flags,0x400020)==0 then H.erase(e) end end
end
local actor_class=Class(enemy,{
    init=function(o,session,sub,x,y,hp,origin,mirrored)
        enemy.init(o,1,math.max(1,hp),false,false,false)
        o.img='img_void';o.bound=false
        H.attach(o,session,sub,x,y,hp,origin,mirrored)
    end,
    frame=function(o) end,
    render=function(o)
        local a=o.th11_actor;if not a or band(a.flags,0x20)~=0 then return end
        for slot,vm in pairs(a.anm) do
            local override=slot==0 and a.flash_magenta and {color={255,0,255},alpha=255} or nil
            A.draw(vm,o.x,o.y,a.anm_angle and -math.deg(a.anm_angle) or nil,nil,nil,nil,nil,override)
        end
    end,
    kill=function(o)
        local a=o.th11_actor
        if a and not a.dead and not a.transition_pending then H.transition(a,band(a.flags,0x80)==0) end
        if not a or a.dead then object.RawDel(o) else object.Preserve(o) end
    end,
    del=function(o) if o.th11_actor then H.erase(o.th11_actor) end end,
})
class.actor=actor_class
function H.attach(o,session,sub,x,y,hp,origin,mirrored)
    local a={o=o,session=session,sub=sub,motion={[0]=motion(x,y),[1]=motion(0,0)},vars={},threads={},
        flags=mirrored and 0x8000 or 0,interrupts={},markers={},anm={},bank=0,hurt={24,24},hit={24,24},
        drops={},guns={},invul=2,phase_time=-1,contact_invul=-1,poses=false,actor_group=0}
    o.th11_actor=a;o.x,o.y=x,224-y
    o.hp,o.maxhp=hp,hp
    o._original_collision_game=11
    for n=-9985,-9978 do a.vars[n]=origin and origin.vars[n] or 0 end
    -- TH11的创建参数块还有F4..F7，不能仅拷TH10的八个寄存器。
    for n=-9935,-9932 do a.vars[n]=origin and origin.vars[n] or 0 end
    for i=0,7 do H.gun_new(a,i) end
    a.threads[1]=thread(a,assert(session.program[sub],sub),sub,-1,{})
    session.actors[#session.actors+1]=a
    return a
end
function H.spawn(a,op,sub,x,y,hp,score,drop)
    local s=a.session
    if (op==265 or op==266 or op==267 or op==268) and s.boss and live(s.boss) then return end
    local absolute=op==257 or op==261 or op==266 or op==268
    local mirrored=op==260 or op==261 or op==267 or op==268
    if not absolute then x,y=x+a.o.x,y+224-a.o.y end
    local o=New(actor_class,s,sub,x,y,hp,a,mirrored)
    local e=o.th11_actor;e.score=score;e.drop_id=drop;e.final_boss=sub=='Boss'
    if e.final_boss then s.final_actor=e end
    H.update(e)
    return e
end
function H.transition(a,dying)
    local chosen,index,timed
    for i=0,7 do
        local it=a.interrupts[i]
        if it and it.hp>=0 then
            if a.o.hp<=it.hp or dying then chosen,index=it,i;break end
            break
        end
    end
    if not chosen then
        for i=0,7 do local it=a.interrupts[i]
            if it and it.hp>=0 and it.time>0 then
                if a.phase_time>=it.time then chosen,index,timed=it,i,true end
                break
            end
        end
    end
    if not chosen then if dying then H.erase(a) end;return end
    a.o.hp=chosen.hp;a.interrupts[index]=nil;a.phase_time=-1
    a.flags=timed and bor(a.flags,0x100000) or band(a.flags,bnot(0x100000))
    local name=timed and chosen.timeout or chosen.name;name=name or chosen.name
    if timed and not a.survival then a.session.capture=0 end
    if a.proxy and a.practice and name~=a.practice.sub then
        -- ECL中断可能比框架t3早一帧；显式传递超时，不能把耗尽时限算作击破收卡。
        if timed then a.o.timeout=true end
        a.session.done=true;return
    end
    a.sub=name;a.threads={thread(a,assert(a.session.program[name],name),name,-1,{})};a.transition_pending=true
    a.o._original_accepts_damage=false;a.o.dmg_factor,a.o.DMG_factor=0,0
    if H.on_transition then H.on_transition(a,name,timed) end
end
function H.update(a)
    if not live(a) or a.updated==a.session.frame then return end
    a.updated=a.session.frame
    a.transition_pending=false
    step_motion(a.motion[0]);step_motion(a.motion[1]);H.sync(a)
    local threads={};for _,t in ipairs(a.threads) do threads[#threads+1]=t end
    for _,t in ipairs(threads) do
        if not t.dead and coroutine.status(t.co)~='dead' and live(a) then
            local ok,err=coroutine.resume(t.co)
            if not ok then error(('TH11第%d面 %s/%s：%s'):format(a.session.stage,a.sub,t.name,debug.traceback(t.co,tostring(err)))) end
            if t==threads[1] and coroutine.status(t.co)=='dead' then H.erase(a);break end
        end
    end
    if not live(a) then return end
    for i=#a.threads,2,-1 do local t=a.threads[i];if t.dead or coroutine.status(t.co)=='dead' then table.remove(a.threads,i) end end
    H.run_callback(a)
    H.transition(a,a.o.hp<=0 and band(a.flags,0x80)==0)
    a.o.colli=band(a.flags,0x20)==0 and not a.damage_callback
    if not a.proxy then a.o.group=(band(a.flags,2)~=0 or a.contact_invul>0) and GROUP.NONTJT or GROUP.ENEMY end
    local damage=a.invul<=0 and band(a.flags,0x31)==0 and not a.survival and not a.transition_pending and not (a.proxy and not a.practice)
    a.o._original_accepts_damage=damage
    a.o.dmg_factor,a.o.DMG_factor=damage and 1 or 0,damage and 1 or 0
    -- 原作369是8000000标志：主ANM每4帧以FFFF00FF闪一次，不是创建分组。
    a.flash_magenta=band(a.flags,0x8000000)~=0 and a.phase_time%4==0
    a.invul=a.invul-1;a.contact_invul=a.contact_invul-1;a.phase_time=a.phase_time+1
    if a.poses and a.anm[0] then
        local dx=a.o.x-(a.last_x or a.o.x);local direction=dx< -.1 and -1 or dx>.1 and 1 or 0
        if direction~=a.direction then
            local id=direction==-1 and 1 or direction==1 and 2 or a.direction==-1 and 3 or a.direction==1 and 4 or 0
            local bank=a.bank;a.bank=a.base_bank or bank;H.anm_slot(a,0,(a.base_script or 0)+id);a.bank=bank
            a.direction=direction
        end
    end
    a.last_x=a.o.x
    for _,vm in pairs(a.anm) do A.step(vm) end
    if not a.is_boss and not a.proxy then
        local x,y=a.o.x,224-a.o.y;local w,h=a.hurt[1]/2,a.hurt[2]/2
        if x+w>=-192 and x-w<=192 and y+h>=0 and y-h<=448 then a.entered=true
        elseif a.entered and ((x+w< -192 or x-w>192) and band(a.flags,4)==0 or (y+h<0 or y-h>448) and band(a.flags,8)==0) then H.erase(a) end
    end
end
function H.load(stage)
    if not programs[stage] then
        local p={};assert(loadfile(('mod/GAME/th36/stage%02d.lua'):format(stage)))(H,p);programs[stage]=p
    end
    return programs[stage]
end
function H.session(host,stage,sub,meta)
    local s={host=host,stage=stage,program=H.load(stage),frame=0,rate=1,accumulator=0,actors={},bullets={},lasers={},effects={},
        shot=meta and meta.shot or 0,misses=0,bombs=0,capture=1,score=0,random_seed=ran:Int(0,65535),random_calls=0,
        observed_misses=lstg.var.dead or 0,observed_bombs=GameDrops and GameDrops.bombState and GameDrops.bombState(player) or 0,
        saved_cyfps=lstg.var.CYFPS}
    local hp=meta and meta.total_hp or 10000000
    local a=H.attach(host,s,sub,meta and meta.x or 0,meta and meta.y or 128,hp)
    a.proxy=true;a.practice=meta;s.root=a
    if meta then a.is_boss=true;s.boss=a;H.select_anm(a,2);H.anm_main(a,0,meta.sprite or 0);H.limit(a,0,128,280,96) end
    host.th36_session=s;host.bound=false
    if meta then host.hp=hp-meta.threshold;host.maxhp=meta.hp end
    return s
end
function H.step(s)
    if s.done then return end
    local misses=lstg.var.dead or 0
    local bombs=GameDrops and GameDrops.bombState and GameDrops.bombState(player) or 0
    local lost,used=math.max(0,misses-s.observed_misses),math.max(0,s.observed_bombs-bombs)
    s.misses,s.bombs=s.misses+lost,s.bombs+used
    if lost>0 or used>0 then s.capture=0 end
    s.observed_misses,s.observed_bombs=misses,bombs
    if s.root.practice then s.host.hp=s.host.hp+s.root.practice.threshold end
    s.accumulator=s.accumulator+s.rate
    while s.accumulator>=1 and not s.done do
        s.accumulator=s.accumulator-1
        local i=1
        while i<=#s.actors do local a=s.actors[i];if live(a) then H.update(a) end;i=i+1 end
        for j=#s.actors,1,-1 do if s.actors[j].dead then table.remove(s.actors,j) end end
        if s.frame%120==0 then
            for j=#s.effects,1,-1 do if not IsValid(s.effects[j]) then table.remove(s.effects,j) end end
        end
        s.frame=s.frame+1
    end
    if s.root.practice then s.host.hp=math.max(0,s.root.o.hp-s.root.practice.threshold);s.host.maxhp=s.root.practice.hp end
    if s.done then s.host.hp=0 end
end
function H.close(s)
    if not s then return end
    if s.changed_cyfps then lstg.var.CYFPS=s.saved_cyfps;s.changed_cyfps=false end
    -- proxy只保留框架宿主；其原作状态与弧形受击节点也必须随本卡结束。
    for _,a in ipairs(s.actors) do H.erase(a) end
    for _,b in ipairs(s.bullets) do if IsValid(b) then object.Kill(b) end end
    for _,l in ipairs(s.lasers) do if IsValid(l) then object.Del(l) end end
    for _,e in ipairs(s.effects) do if IsValid(e) then object.RawDel(e) end end
    s.done=true
end
-- 发弹和原作专用回调分开，便于逐项对照，加载时仍是普通Lua函数。
assert(loadfile('mod/GAME/th36/projectiles.lua'))(H,class)
assert(loadfile('mod/GAME/th36/callbacks.lua'))(H,class)
return H
