-- 原作死亡时钟与消弹范围。伤害、无敌弹和激光交给各作后端筛选。
local D={}
local function backend(level)
    local c=({[35]=TH37,[36]=TH38,[37]=TH39,[38]=_editor_class.TH40})[level]
    return c and (c.runtime or c.native)
end
function D.clear(level,x,y,r)
    if r<=0 then return end
    local rtm=backend(level)
    if rtm and rtm.deathClear then rtm.deathClear(x,y,r);return end
    -- 两作EIS的player_death_circle只Del普通弹；不清GROUP_INDES，也不截激光。
    for _,o in ObjList(GROUP.ENEMY_BULLET) do
        if not o.IsLaser and not o.IsBentLaser and Dist(x,y,o.x,o.y)<r then Del(o) end
    end
end
local Circle=Class(object,{
    init=function(o,p)
        o.x,o.y,o.level=p.x,p.y,p.native_level
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.TOP-1,false,false
    end,
    frame=function(o)
        local t=o.timer+1
        if t>30 then D.clear(o.level,o.x,o.y,800*(1+sin(-90+90*(t-30)/60))) end
        if t>=90 then object.RawDel(o) end
    end,
    render=function(o)
        local t=o.timer+1;local k=1+sin(-90+math.min(90,t)*1)
        local r=16+984*k;local r1=800*k
        local r2=t>30 and 800*(1+sin(-90+90*(t-30)/60)) or 0
        local function circle(x,y,radius)
            if radius<=0 then return end
            SetImageState('white','add+sub',255,255,255,255)
            for a=0,359,360/32 do
                Render4V('white',x,y,.5,x,y,.5,x+radius*cos(a+5.625),y+radius*sin(a+5.625),.5,x+radius*cos(a-5.625),y+radius*sin(a-5.625),.5)
            end
        end
        circle(o.x,o.y,r);circle(o.x,o.y,r2)
        circle(o.x+32,o.y,r1);circle(o.x-32,o.y,r1);circle(o.x,o.y+32,r1);circle(o.x,o.y-32,r1)
        SetImageState('white','',255,255,255,255)
    end,
},true)
local Impact=Class(object,{
    init=function(o,p)
        local key=p.native_level==39 and '41' or '43';o.x,o.y=p.x,p.y
        local name='native_'..key..'_death'
        if not CheckRes('psi',name) then
            local pool=GetResourceStatus();SetResourceStatus('global')
            local img=NativePlayers.visual.image(key..'_particles',0,0,32,32)
            LoadPS(name,'Resources/native_players/source/'..key..'_death.psi',img)
            SetResourceStatus(pool)
        end
        o.img=name;o.hscale,o.vscale=1,1;o.layer=LAYER.PLAYER+50
    end,
    frame=function(o) if o.timer==4 then ParticleStop(o) elseif o.timer>=60 then object.RawDel(o) end end,
},true)
function D.hit(p)
    p.native_death_committed=false;p.native_death_circle=nil
    if p.native_level==39 or p.native_level==41 then
        New(Impact,p);p.native_hit_clock=0;return
    end
    if p.native_level~=35 and p.native_level~=37 then return end
    p.native_death_clock=0;p.native_death_committed=false
    local rtm=backend(p.native_level)
    if rtm and rtm.playerDeathEffect then rtm.playerDeathEffect(p) end
    PlaySound('pldead00',.5)
end
function D.defer(p)
    if p.native_level~=35 and p.native_level~=37 then return false end
    local target=p.native_level==35 and 30 or 60
    if not p.native_death_clock then D.hit(p) end
    if p.native_death_clock<target then p.native_miss_pending=true;return true end
    return false
end
function D.miss(p)
    p.native_death_committed=true;p.native_miss_pending=nil
    if p.native_level==35 or p.native_level==37 then
        p.protect=p.native_level==35 and 281-(p.native_death_clock or 30) or 301-(p.native_death_clock or 60)
    else
        p.native_death_clock=0
        p.native_death_x,p.native_death_y=p.x,p.y
        if p.native_level==36 then p.protect=250;p.native_body_hidden=true end
        if p.native_level==39 or p.native_level==41 then
            p.native_body_hidden=true
            if not p.native_death_circle then New(Circle,p) end
            p.native_death_circle=nil
        end
    end
end
function D.cancel(p)
    if not p.native_death_committed then
        p.native_death_clock,p.native_miss_pending=nil,nil
        p.native_body_hidden,p.native_tint=nil,nil
        p.native_hit_clock=nil
        p.native_death_circle=nil
    end
end
function D.locked(p)
    local t=p.native_death_clock
    if not t then return false end
    local level=p.native_level
    return level==35 and t<95 or level==37 and t<125 or level==38 and t<=70
end
function D.frame(p)
    if p.native_hit_clock then
        p.native_hit_clock=p.native_hit_clock+1
        if p.native_level==39 and p.native_hit_clock==16 then New(Circle,p);p.native_death_circle=true end
    end
    local t=p.native_death_clock;if t==nil then return end
    t=t+1;p.native_death_clock=t
    local level=p.native_level
    if (level==35 or level==37) and p.native_miss_pending and t==(level==35 and 30 or 60) then NativePlayers.miss(p) end
    if level==35 or level==37 then
        local first,last,free,ending=30,100,95,280
        local scale=1
        if level==37 then first,last,free,ending,scale=50,120,125,300,2/3 end
        if t<free then D.clear(level,p.x,p.y,t*15*scale) end
        if t>first and t<=last then
            local rtm=backend(level)
            if rtm and rtm.deathDamage then rtm.deathDamage(p.x,p.y,math.abs((t-10)*10)*scale,2) end
        end
        if level==35 then
            p.native_body_hidden=t<=30
            if t==31 then p.x,p.y=0,-270 end
            if t>31 and t<free then p.y=math.min(-180,p.y+2) end
        else
            local fade=p.hitWindow==60 and 49 or 24
            p.native_tint=t<=60 and {math.max(0,255*(1-(t/fade)^(fade==49 and 4 or 2))),255,0,0} or nil
            p.native_body_hidden=t>fade and t<=60
            if t==61 and not NativePlayers.state().recover then p.x,p.y=0,(360-740)*scale end
            if t>61 and t<free and not NativePlayers.state().recover then p.y=math.min(-400/3,p.y+.8*p.machine.fast-8/15) end
            if NativePlayers.state().recover then
                p.native_body_hidden=t<240
                if t==240 then p.x,p.y=0,0 end
                p.death=t<300 and 91 or 0
            end
        end
        if t>first then p.native_tint=t%6<3 and {255,0,0,255} or {255,255,255,255} end
        if not NativePlayers.state().recover then p.death=t<free and 91 or 0 end
        if t>ending then p.native_death_clock=nil;p.native_death_committed=nil;p.native_tint=nil end
    elseif level==36 then
        -- Death_xiaodan以120Hz计时，100tick后半径每tick增加0.135个Unity单位。
        if t>=50 and t<90 then D.clear(level,p.native_death_x,p.native_death_y,(t*2-100)*.135*48) end
        p.death=t<100 and 91 or 0
        if t==100 then
            p.x,p.y=0,(-13.5+201*.025+4.8)*48
            p.native_body_hidden,p.native_death_clock,p.native_death_committed=nil,nil,nil
        end
    elseif level==38 then
        -- BulletRemover半径初值2，每帧+20，持续30帧；同时对敌机造成20伤害。
        if t<=30 then
            local r=2+t*20;D.clear(level,p.native_death_x,p.native_death_y,r)
            local rtm=backend(level);if rtm and rtm.deathDamage then rtm.deathDamage(p.native_death_x,p.native_death_y,r,20) end
        end
        if t==1 then p.x,p.y=0,-324 end
        if t<=70 then p.y=math.min(-194,p.y+2);p.death=91 else p.death=0 end
        p.native_tint=t<300 and math.floor(t/2)%2==0 and {255,0,0,139} or nil
        if t>=300 then p.native_death_clock=nil;p.native_tint=nil end
    elseif level==39 or level==41 then
        if t==40 then p.x,p.y=0,level==41 and -288 or -234.8;p.native_body_hidden=nil end
        if t>40 and t<90 then
            local left=90-t
            p.y=level==41 and -288+112*sin(90*(1-left/50)) or -176-1.2*left
        end
        if t>=90 then
            p.native_death_clock,p.native_hit_clock,p.native_death_committed=nil,nil,nil
        end
    end
end
return D
