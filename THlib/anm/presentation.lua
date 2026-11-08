-- 离线导出的演出调度：只执行标量、CALL/等待/子context和独立ANM，不产生伤害或运动。
-- 不把时间戳套到墙钟；效果子程序的30/32拍、动态等待及回跳沿各context自己的时间。
local T={shared={[8]={},[95]={}},carriers={},managed={},ambients={}}
-- 原导出文件把 TH08/TH095 全部文件的演出脚本塞进一张表，约 20 万个字面量常量，
-- 超过 LuaJIT 单函数 65536 常量上限（lj_parse.c: fs_fixup_k，BCMAX_D+1 = 0x10000）。
-- 现按 ECL 文件切成 presentation_programs.d/，首次访问时才加载。
local program_index=dofile('mod/GAME/original/presentation_programs_index.lua')
local program_cache={[8]={},[95]={}}
local function program_file(game,file)
    -- 演出常量只导出 TH08(8)/TH095(95)；其余作品（如 TH10 的 game=10）没有数据。
    -- 原实现靠 data[game] and data[game][file] 短路，这里必须显式挡住，否则索引 nil。
    local cache=program_cache[game]
    if not cache or not file then return false end
    local bank=cache[file]
    if bank==nil then
        bank=false
        local names=program_index[tostring(game)]
        if names and names[file] then
            bank=dofile('mod/GAME/original/presentation_programs.d/'..game..'_'..file..'.lua') or false
        end
        cache[file]=bank
    end
    return bank
end
local F=dofile('THlib/anm/original_effects.lua')
T.sound=dofile('THlib/anm/original_sounds.lua')
function T.native_pulse(owner,duration,repeats,argb)
    local alpha=math.floor(argb/0x1000000)%256
    local r,g,b=math.floor(argb/0x10000)%256,math.floor(argb/0x100)%256,argb%256
    return New(F.screen_pulse,owner,duration,repeats,alpha,{r,g,b})
end
function T.native_shake(owner,duration,amplitude)
    F.shake_envelope(owner,amplitude,0,duration,0)
end
local bit=bit or require('bit')
local function trunc(n) return n>=0 and math.floor(n) or math.ceil(n) end
local function copy(v) local r={};for k,n in pairs(v or {}) do r[k]=n end;return r end
local function context(sub,v) return {sub=sub,pc=1,time=0,v=copy(v),stack={},wait=0,interps={}} end
local function random(s)
    -- 演出标量有独立、可重放的随机流，不二次消耗手写发弹/运动已经读取的随机数。
    s.seed=(s.seed*16807)%2147483647
    return s.seed/2147483647
end
local function value(s,c,a)
    if type(a)~='table' then return a end
    local n=a.var
    local o=s.owner
    if s.game==95 then
        if n==10026 then return s.x end
        if n==10027 then return 224-s.y end
        if n==10082 then return (o.th095_photo_owner or o).x end
        if n==10083 then return 224-(o.th095_photo_owner or o).y end
        if n==10029 then return player.x end
        if n==10030 then return 224-player.y end
        if n==10032 or n==10085 then return math.atan2(-(player.y-s.y),player.x-s.x) end
        if n==10033 then return s.clock end
        if n==10035 then return o.hp or 0 end
        if n==10034 then return math.sqrt((o.x-player.x)^2+(o.y-player.y)^2) end
        if n==10081 then return o.photo_hit_count or (o.th095_photo_owner and o.th095_photo_owner.photo_hit_count) or 0 end
        if n==10084 then return o.th095_photos_taken or (o.th095_photo_owner and o.th095_photo_owner.th095_photos_taken) or 0 end
        if n==10052 then return s.angle or o.th095_move_angle or -(o._angdir or o.rot or 0)*math.pi/180 end
        if n==10022 and o.th095_transition_state then return o.th095_transition_state.th095_transition_left or 0 end
        if n==10065 then return random(s)*2*math.pi-math.pi end
        -- TH095随机编号为0x2720..0x2723（10016..10019）。
        if n==10016 or n==10018 then return math.floor(random(s)*2147483647) end
        if n==10017 then return random(s) end
        if n==10019 then return random(s)*2-1 end
        if n>=10044 and n<=10051 then return s.shared[n] or 0 end
    else
        if n==10042 then return s.x+192 end
        if n==10043 then return 224-s.y end
        if n==10045 then return player.x+192 end
        if n==10046 then return 224-player.y end
        if n==10048 then return math.atan2(-(player.y-s.y),player.x-s.x) end
        if n==10049 then return s.clock end
        if n==10050 then return math.sqrt((o.x-player.x)^2+(o.y-player.y)^2) end
        if n==10051 then return o.hp or 0 end
        if n==10040 then return 3 end
        if n==10041 then return 16 end
        -- TH08随机编号为0x2730..0x2733（10032..10035）。
        if n==10032 or n==10034 then return math.floor(random(s)*2147483647) end
        if n==10033 then return random(s) end
        if n==10035 then return random(s)*2-1 end
        if n==10082 then return random(s)*2*math.pi-math.pi end
        if n==10097 then return _editor_class.TH31.th08_combat.youkai(s.owner) and 1 or 0 end
        if n==10096 then
            local parent=o.th08_attached and o.th08_parent or o
            return _editor_class.TH31.th08_combat.actor_count(parent.th08_children or {})
        end
        if n>=10008 and n<=10015 or n>=10024 and n<=10031 then return s.enemy[n] or 0 end
        if n>=10061 and n<=10068 then return s.shared[n] or 0 end
    end
    return c.v[n] or 0
end
local function put(s,c,a,n,isfloat)
    if type(a)~='table' then return end
    if not isfloat then n=trunc(n) end
    local id=a.var
    if s.game==8 and id>=10061 and id<=10068 or s.game==95 and id>=10044 and id<=10051 then s.shared[id]=n
    elseif s.game==8 and (id>=10008 and id<=10015 or id>=10024 and id<=10031) then s.enemy[id]=n
    else c.v[id]=n end
end
local function effect(s,c,op,a)
    local o=s.owner
    if s.game==8 then
        if op==139 or op==140 then F.spawn8({x=s.x,y=s.y},s.phase,a[1],a[2],a[3],a[4]) end
        if op==124 and a[1] and s.bank.sound_scripts[c.sub] then T.sound.play(8,a[1],s.x) end
        if op==136 and a[1]==1 then New(F.screen_pulse,s.phase) end
        if op==136 and a[1]==10 then
            New(F.screen_pulse,s.phase,30,5,64)
            F.shake_envelope(s.phase)
        end
        if op==136 and a[1]==15 then F.shake_envelope(s.phase,16,20,20,20) end
        if op==136 and a[1]==17 then New(F.screen_pulse,s.phase,180) end
        if op==136 and (a[1]==3 or a[1]==20 or a[1]==6) then F.start_warp({x=s.x,y=s.y},s.phase,a[1]) end
        if op==136 and a[1]==5 then F.stop_warp(s.phase) end
        if op==137 then s.ex_callback=a[1]>=0 and a[1] or nil end
    else
        if op>=54 and op<=62 and o._original_presentation_carrier then
            local event={0,op};for _,v in ipairs(a) do event[#event+1]=v end
            OriginalStageVisual.source_event(o,95,s.file,event)
        elseif op==124 and o._original_actor then OriginalANM.interrupt(o._original_actor.vm,a[1])
        elseif op==77 then
            o._original_damage_box={a[1],a[2]}
            if o._bosssys then o.a,o.b,o.rect=a[1]/2,a[2]/2,true end
        elseif op==85 then
            -- TH095 ResetNonPhotoTargets：纯演出使魔也属于同一敌机池。
            for _,carrier in ipairs(T.carriers) do
                if carrier~=o and carrier.phase==s.phase and IsValid(carrier) and not carrier.th095_photo_target then
                    object.RawDel(carrier)
                end
            end
        elseif op==106 and a[1] and s.bank.sound_scripts[c.sub] then T.sound.play(95,a[1],s.x)
        elseif op==118 and (a[1]==12 or a[1]==13) then OriginalStageVisual.interrupt_background(95,a[1]-10)
        elseif op==118 and a[1]==0 then
            F.new(95,'bullet',291,s.x,s.y,s.phase)
            for _=1,32 do F.new(95,'bullet',290,s.x,s.y,s.phase) end
            T.sound.play(95,18,s.x)
        elseif op==118 and a[1]==8 and o._original_actor then
            local actor=o._original_actor
            local v=F.new(95,actor.archive,c.v[10022] or 0,s.x,s.y,s.phase)
            if actor.vm.sprite and v.vm.data.sprites[actor.vm.sprite] then v.vm.sprite=actor.vm.sprite end
            v.vm.rotation=copy(actor.vm.rotation)
            if actor.vm.scale[1]<0 then v.vm.scale[1]=-v.vm.scale[1] end
        elseif op==118 and a[1]==7 then
            local angle=o.th095_move_angle or -(o._angdir or o.rot or 0)*math.pi/180
            for i=0,1 do
                local v=s.handles[i]
                if v and IsValid(v) then
                    v.x,v.y=s.x+24*math.cos(angle)-128,s.y-24*math.sin(angle)+16
                    v.vm.rotation[3]=angle
                end
            end
        elseif op>=79 and op<=81 then
            local has=math.floor(a[1]/8)%2==1
            if op==79 then o._original_hidden=has elseif has then o._original_hidden=op==80 end
            local adapter=OriginalStageVisual.adapters[95]
            if adapter and adapter.event then adapter.event(o,{0,op,a[1]}) end
        elseif op==143 then
            o.th095_photo_marker=a[1]~=0 and a[2] or 0
            if s.marker and IsValid(s.marker) then object.RawDel(s.marker) end
            s.marker=nil
            if a[1]~=0 and o.th095_photo_target then s.marker=F.new(95,'bullet',295,s.x,s.y,s.phase);s.marker.follow=o end
        elseif op==144 then
            local v=F.new(95,'bullet',293,s.x,s.y,s.phase)
            v.follow,v.pulse,v.duration=o,a[1],a[1]
            T.sound.play(95,45,s.x)
        elseif op==150 or op==151 then
            local id=op==150 and a[1] or a[2]
            local x,y=s.x+(s.shot_x or 0),s.y-(s.shot_y or 0)
            local origins=o.th095_effect_origins
            local key=s.file..':'..c.sub
            local origin=origins and origins[key]
            if origin and origin.clock==s.clock then x,y=origin.x,origin.y;origins[key]=nil end
            local v=F.new(95,'enm'..s.file:match('ecl(%d+)_'),id,x,y,s.phase)
            if op==151 then s.handles[a[1]]=v end
        elseif op==152 then
            local v=s.handles[a[1]]
            if v and IsValid(v) then OriginalANM.interrupt(v.vm,a[2]) end
        end
    end
end
local function enter(s,c,target)
    c.sub,c.pc,c.time,c.wait=target,1,0,0
end
local function run(s,c)
    if c.done then return end
    local mask=8
    if s.game==8 and s.owner.th08_attached then
        local m=_editor_class.TH31.th08_combat
        mask=8+(m.youkai(s.owner) and 64 or 32)
    end
    while true do
        if c.wait>0 then c.wait=c.wait-1;c.time=c.time-1;break end
        local p=s.bank.scripts[c.sub]
        local row=p and p[c.pc]
        if not row then c.done=true;break end
        if row[1]~=c.time then break end
        c.pc=c.pc+1
        if bit.band(row[3],mask)==mask then
            local op,raw=row[2],{}
            for i=4,#row do raw[i-3]=row[i] end
            local a={};for i,v in ipairs(raw) do a[i]=value(s,c,v) end
            if op==1 then c.done=true;s.terminated=true;break
            elseif op==2 then c.wait=math.max(0,trunc(a[1]))
            elseif op==4 or op==5 then
                local jump=op==4
                if op==5 then put(s,c,raw[3],a[3]-1);jump=value(s,c,raw[3])>0 end
                if jump then c.time,c.pc=a[1],raw[2] end
            elseif op>=6 and op<=9 then
                local n=a[2];if op>=8 then n=n*(random(s)<0.5 and -1 or 1) end
                put(s,c,raw[1],n,op==7 or op==9)
            elseif op>=10 and op<=29 then
                local x,y,k=a[1],a[2],(op-10)%5
                if op>=20 then x,y=a[2],a[3] end
                local f=op>=15 and op<=19 or op>=25
                if not f then x,y=trunc(x),trunc(y) end
                local n
                if k==0 then n=x+y elseif k==1 then n=x-y elseif k==2 then n=x*y
                elseif k==3 then n=y~=0 and x/y or 0 else n=y~=0 and math.fmod(x,y) or 0 end
                put(s,c,raw[1],n,f)
            elseif op==30 or op==31 then put(s,c,raw[1],a[1]+(op==30 and 1 or -1))
            elseif op==32 or op==33 then put(s,c,raw[1],op==32 and math.sin(a[2]) or math.cos(a[2]),true)
            elseif op==34 then put(s,c,raw[1],math.atan2(a[5]-a[3],a[4]-a[2]),true)
            elseif op==35 then put(s,c,raw[1],(a[2]-a[3])*a[4]+a[3],true)
            elseif op==36 then
                c.interps[raw[1].var]={age=0,n=a[2],mode=a[4],first=a[5],last=a[6]}
                put(s,c,raw[1],a[5],true)
            elseif op==37 then put(s,c,raw[1],(a[1]+math.pi)%(2*math.pi)-math.pi,true)
            elseif op==38 then
                put(s,c,raw[1],math.cos(a[3])*a[4],true);put(s,c,raw[2],math.sin(a[3])*a[4],true)
            elseif op==39 then put(s,c,raw[1],math.sqrt((a[2]-a[4])^2+(a[3]-a[5])^2),true)
            elseif op>=40 and op<=51 then
                local x,y=a[1],a[2];if op%2==0 then x,y=trunc(x),trunc(y) end
                local k=math.floor((op-40)/2)
                local yes=k==0 and x==y or k==1 and x~=y or k==2 and x<y or k==3 and x<=y or k==4 and x>y or k==5 and x>=y
                if yes then c.time,c.pc=a[3],raw[4] end
            elseif op==52 then
                c.stack[#c.stack+1]={sub=c.sub,pc=c.pc,time=c.time,v=c.v,interps=c.interps,callback=c.callback}
                local interps={};for id,p in pairs(c.interps) do interps[id]=copy(p) end
                c.v,c.interps=copy(c.v),interps
                local first,shared=s.game==8 and 10053 or 10036,s.game==8 and 10061 or 10044
                for i=0,7 do c.v[first+i]=s.shared[shared+i] or 0 end
                enter(s,c,raw[1])
            elseif op==53 then
                local p=table.remove(c.stack)
                if not p then c.done=true;break end
                c.sub,c.pc,c.time,c.v,c.interps=p.sub,p.pc,p.time,p.v,p.interps
                c.callback=p.callback
            elseif op==63 then
                s.x,s.y=a[1]-(s.game==8 and 192 or 0),224-a[2]
                if s.owner._original_presentation_carrier then s.owner.x,s.owner.y=s.x,s.y end
            elseif op==64 and s.owner._original_presentation_carrier then
                s.motion={x=s.x,y=s.y,dx=a[3]-s.x,dy=224-a[4]-s.y,n=math.max(1,a[1]),age=0,mode=a[2]}
            elseif op==65 and s.owner._original_presentation_carrier then
                s.angle,s.speed,s.motion=a[1],a[2],'polar'
            elseif op==70 and s.owner._original_presentation_carrier then s.omega=a[1]
            elseif op==71 and s.owner._original_presentation_carrier then s.accel=a[1]
            elseif s.game==95 and (op==83 or op==84) and s.bank.pure_actor[raw[1]] then
                local key=s.file..':'..raw[1]:sub(4)
                if not T.managed[95] or not T.managed[95][key] then
                    local x,y=s.x,s.y
                    local origins=s.owner.th095_presentation_origins
                    local origin=origins and origins[key]
                    if origin and origin.clock==s.clock then x,y=origin.x,origin.y;origins[key]=nil end
                    if op==84 then x,y=x+a[2],y-a[3] end
                    T.start(s.owner,95,key,x,y,0,c.v)
                end
            elseif s.game==8 and op>=90 and op<=94 and s.bank.pure_actor[raw[1]] then
                local x,y=a[2]-192,224-a[3]
                if op==91 or op==92 or op==94 then x,y=s.x+a[2],s.y-a[3] end
                T.start(s.owner,8,s.file..':'..raw[1]:sub(4),x,y,0,c.v,op<=92)
            elseif op==(s.game==8 and 135 or 117) then
                local slot,target=trunc(a[1]),raw[2]
                if type(target)=='number' or not s.bank.active[target] and not s.owner._original_presentation_carrier then s.children[slot]=nil
                else s.children[slot]=context(target,c.v) end
            elseif s.game==95 and op==115 then
                s.callbacks[a[1]]={threshold=a[2],sub=raw[3]}
            elseif s.game==95 and op==119 then c.callback=a[1]>=0 and a[1] or nil
            elseif s.game==95 and op==109 then
                s.owner.th095_photo_target=a[1]>=0
                if a[1]<0 and s.marker and IsValid(s.marker) then object.RawDel(s.marker);s.marker=nil end
            elseif op==(s.game==8 and 110 or 100) then s.shot_x,s.shot_y=a[1],a[2]
            else effect(s,c,op,a) end
        end
    end
    c.time=c.time+1
    for id,p in pairs(c.interps) do
        p.age=math.min(p.n,p.age+1)
        local u=math.min(1,p.age/math.max(1,p.n))
        if p.mode>=1 and p.mode<=3 then u=u^(p.mode+1)
        elseif p.mode>=4 and p.mode<=6 then u=1-(1-u)^(p.mode-2) end
        c.v[id]=p.first+(p.last-p.first)*u
    end
    if not s.terminated and not c.done and c.callback then effect(s,c,118,{c.callback}) end
end
function T.bind(o,game,key)
    local file,number=key:match('^([^:]+):(.+)$')
    if not file or not number then return false end
    local bank=program_file(game,file)
    local sub='Sub'..number
    o._original_native_motion=bank and bank.motion[sub]
    if not bank or not bank.active[sub] then o._original_presentation=nil;return end
    local seed=1
    for i=1,#key do seed=(seed*31+key:byte(i))%2147483647 end
    o._original_presentation={owner=o,game=game,file=file,bank=bank,root=context(sub,o._original_presentation_seed_vars),children={},
        enemy={},shared=T.shared[game],handles={},callbacks={},clock=-1,seed=seed,
        phase=o.th08_card_owner or o.th095_photo_owner or o,motion_active=bank.motion[sub]}
end
function T.advance(o,clock)
    local s=o._original_presentation
    if not s then return end
    while s.clock<clock do
        if s.terminated then return end
        s.clock=s.clock+1
        s.x,s.y=o.x,o.y
        if s.clock>0 and (o.th095_photo_marker or 0)>0 then
            o.th095_photo_marker=math.max(0,(o.th095_photo_marker or 0)-1)
            if o.th095_photo_marker==0 and s.marker and IsValid(s.marker) then object.RawDel(s.marker);s.marker=nil end
        end
        if s.game==95 then
            -- UpdateScheduledEclCalls按0..9处理，触发时释放全部16个子context。
            for k=0,9 do
                local c=s.callbacks[k]
                if c and c.threshold>=0 and (o.photo_hit_count or 0)>=c.threshold then
                    enter(s,s.root,c.sub);s.root.done=false;s.callbacks[k]=nil;s.children={}
                end
            end
        end
        run(s,s.root)
        for slot=0,(s.game==95 and 15 or 7) do
            if s.terminated then break end
            if s.children[slot] then run(s,s.children[slot]) end
        end
        if s.game==8 and not s.terminated and s.ex_callback==13 then
            -- Background::AccumulateTint(0xffc03030)，每帧只影响背景ANM。
            T.background_mix={owner=s.phase,card=s.phase.current_card,
                stamp=stage.current_stage.timer,color={192,48,48}}
        end
        if o._original_presentation_carrier and not s.terminated then
            local before=s.x
            local m=s.motion
            if type(m)=='table' then
                m.age=math.min(m.n,m.age+1)
                local t=m.age/m.n
                if m.mode>=1 and m.mode<=3 then t=t^(m.mode+1)
                elseif m.mode>=4 and m.mode<=6 then t=1-(1-t)^(m.mode-2) end
                s.x,s.y=m.x+m.dx*t,m.y+m.dy*t
            elseif m=='polar' then
                s.angle,s.speed=s.angle+(s.omega or 0),s.speed+(s.accel or 0)
                s.x,s.y=s.x+s.speed*math.cos(s.angle),s.y-s.speed*math.sin(s.angle)
            end
            if s.clock>0 then o.x,o.y=s.x,s.y end
            o.th095_animation_vx,o.th095_animation_stamp,o.th095_animation_queue=s.x-before,o.ani,true
        end
    end
end
function T.captured(o,key)
    local s=o._original_presentation
    if not s then return end
    local n=key:match(':(%d+)$')
    s.terminated=false
    enter(s,s.root,'Sub'..n);s.root.done=false
end
function T.handle(o,slot)
    local s=o._original_presentation
    return s and s.handles[slot]
end
T.carrier=Class(object,{
    init=function(o,owner,game,key,x,y,delay,vars,attached,entry)
        o.group,o.bound,o.colli=GROUP.GHOST,false,false
        o.layer=LAYER.ENEMY
        o._original_presentation_carrier=true
        o.x,o.y,o.owner,o.phase=x,y,owner,owner.th08_card_owner or owner.th095_photo_owner or owner
        o.delay,o.age=delay or 0,-1
        o.attached=attached
        o.th08_card_owner=game==8 and o.phase or nil
        o.th095_photo_owner=game==95 and o.phase or nil
        local adapter=OriginalStageVisual.adapters[game]
        if adapter and adapter.reserve and not adapter.reserve(o) then object.RawDel(o);return end
        o._original_presentation_seed_vars=vars
        if game==95 then OriginalStageVisual.bind_source(o,game,key)
        else T.bind(o,game,key) end
        local s=o._original_presentation
        if s then
            s.phase=o.phase
            if entry then s.root.pc,s.root.time=entry.pc,entry.time end
        end
        o._original_presentation_seed_vars=nil
        if o.delay==0 then T.advance(o,0);o.started=true end
        T.carriers[#T.carriers+1]=o
    end,
    frame=function(o)
        local parent=o.attached and o.owner or o.phase
        if not IsValid(parent) or parent.status=='del' or parent.status=='kill' then object.RawDel(o);return end
        o.age=o.age+1
        if o.age<o.delay then return end
        local adapter=OriginalStageVisual.adapters[o._original_source and o._original_source.game]
        if adapter and adapter.frame and adapter.frame(o) then
            if IsValid(o) then OriginalStageVisual.tick(o) end
            return
        end
        if not o.started then T.advance(o,0);o.started=true end
        local rate=IsValid(o.phase) and o.phase._native_rate_source
        if rate or o.presentation_clock then
            o.presentation_clock=o.presentation_clock or (o.age-o.delay+1)
            T.advance(o,math.floor(o.presentation_clock))
            o.presentation_clock=o.presentation_clock+(rate and rate.fm or 1)
        else T.advance(o,o.age-o.delay+1) end
        local s=o._original_presentation
        if not s or s.terminated then object.RawDel(o);return end
        OriginalStageVisual.tick(o)
    end,
    render=function(o) OriginalStageVisual.draw(o) end,
},true)
function T.start(owner,game,key,x,y,delay,vars,attached,entry)
    return New(T.carrier,owner,game,key,x,y,delay,vars,attached,entry)
end
T.ambient_anchor=Class(object,{
    init=function(o)
        o.group,o.hide,o.bound,o.colli=GROUP.GHOST,true,false,false
    end,
},true)
function T.enter_stage(game,key)
    local a=T.ambients[game]
    if not a then return end
    local scene=stage.current_stage
    if a.key~=key or a.scene~=scene or scene.timer<a.started or not IsValid(a.anchor) then
        T.clear(a.anchor)
        if IsValid(a.anchor) then object.RawDel(a.anchor) end
        T.ambients[game]=nil
    end
end
function T.ambient_start(game,key,script,x,y,entry)
    T.enter_stage(game,key)
    local a=T.ambients[game]
    if a then return a.carrier end
    local anchor=New(T.ambient_anchor)
    a={key=key,scene=stage.current_stage,started=stage.current_stage.timer,anchor=anchor}
    T.ambients[game]=a
    a.carrier=T.start(anchor,game,script,x,y,0,nil,nil,entry)
    return a.carrier
end
function T.manage(game,key)
    T.managed[game]=T.managed[game] or {}
    T.managed[game][key]=true
end
function T.clear(phase)
    local n=0
    for _,o in ipairs(T.carriers) do
        if IsValid(o) and o.phase==phase then object.RawDel(o)
        elseif IsValid(o) then n=n+1;T.carriers[n]=o end
    end
    for i=#T.carriers,n+1,-1 do T.carriers[i]=nil end
    F.clear(phase)
end
T.new_effect=F.new
T.spawn8=F.spawn8
T.draw_warp_background=F.draw_warp_background
T.advance_shake=F.advance_shake
return T
