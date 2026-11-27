-- Unity原图及Animator状态机。逻辑以120Hz推进，贴图保留各帧pivot/PPU。
local A={data=dofile('mod/GAME/th38/actors.lua')}
local D=A.data
local function picture(key)
    if not key then return end
    local p=D.sprites[key];local id='asl_actor_'..key
    if not CheckRes('img',id) then
        local pool=GetResourceStatus();SetResourceStatus('global')
        LoadTexture(id,'Resources/th38/actors/'..p.file)
        LoadImage(id,id,0,0,p.w,p.h);SetImageCenter(id,p.pivot[1],p.pivot[2])
        SetResourceStatus(pool)
    end
    return id,p.scale
end
local function states(nodes)
    local list={}
    for i,n in ipairs(nodes) do
        local c=n.controller and D.controllers[n.controller]
        list[i]={clip=c and c.default,clock=0,sprite=n.sprite,bob=0,bobTime=n.Boss_move_doudong and n.Boss_move_doudong.time_start or 0,x=n.x,y=n.y}
    end
    return list
end
local function step(nodes,list,params)
    for i,n in ipairs(nodes) do
        local s=list[i];local ctrl=n.controller and D.controllers[n.controller]
        if ctrl and s.clip then
            local clip=ctrl.states[s.clip]
            if clip then
                local elapsed=s.clock
                for _,t in ipairs(clip.transitions) do
                    local pass=t.exit==0 or elapsed>=clip.length*t.exitTime
                    for _,condition in ipairs(t.conditions) do
                        local value=params[condition[1]] or false
                        pass=pass and (condition[2]==1 and value or condition[2]==2 and not value)
                    end
                    if pass and ctrl.states[t.to] then s.clip=t.to;s.clock=0;clip=ctrl.states[s.clip];break end
                end
                s.clock=s.clock+clip.speed/120
                local t=clip.loop==1 and s.clock%math.max(.0001,clip.length) or math.min(s.clock,clip.length)
                for _,curve in ipairs(clip.tracks) do
                    if curve.path=='' then
                        for _,key in ipairs(curve.keys) do if key[1]<=t then s.sprite=key[2] end end
                    end
                end
            end
        end
        local bob=n.Boss_move_doudong
        if bob then
            s.bob=s.bob+.001*sin(s.bobTime)*(bob.A==0 and 1 or bob.A)
            s.bobTime=(s.bobTime+1)%(bob.time_zhouqi==0 and 360 or bob.time_zhouqi)
        end
        local move=n.Lihuimove1
        if move then
            s.time=(s.time or 0)+1
            local t=s.time<=84 and s.time or s.time<=94 and 84 or s.time-10
            local speed=math.max(.095,.0003*(t*t-200*t)+2.5)
            s.x,s.y=s.x+move.yidongx*speed,s.y+move.yidongy*speed
            s.alpha=t<84 and .00025*(-t*t+175*t) or .0002*(-t*t+160*t)+.5
        end
    end
end
local function render(nodes,list,x,y,rot,mirror,tint)
    for i,n in ipairs(nodes) do
        local s=list[i];local id,scale=picture(s.sprite)
        if id then
            local c=n.color;local a=math.max(0,math.min(1,s.alpha or c[4]))
            SetImageState(id,tint and tint.blend or '',a*255*(tint and tint.alpha or 1),c[1]*255*(tint and tint.red or 1),c[2]*255*(tint and tint.green or 1),c[3]*255*(tint and tint.blue or 1))
            Render(id,x+s.x*48*(mirror or 1),y+(s.y+s.bob)*48,(rot or 0)+n.rotation,
                scale*(s.sx or n.sx)*(n.flip[1]==1 and -1 or 1)*(mirror or 1),scale*n.sy*(n.flip[2]==1 and -1 or 1))
        end
    end
end
function A.name(key,index)
    local phase=D.phases[key]
    local profile=phase and D.profiles[phase[index or 1]]
    return profile and profile.name
end
function A.position(key,index)
    local phase=D.phases[key]
    return phase and phase.positions and phase.positions[index]
end
function A.bind(o,key,index)
    o.no_hp_render=true -- 原作HUD显示Boss血条。
    local phase=D.phases[key]
    local profile=phase and phase[index or 1]
    if not profile then return end
    o.name=A.name(key,index) or o.name
    if not o.asl_actor or o.asl_actor.profile~=profile then
        local p=D.profiles[profile]
        o.asl_actor={profile=profile,nodes=p.nodes,states=states(p.nodes),mirrorClock=0,mirror=1}
    end
    o._wisys=o._wisys or {}
    o._wisys.frame=function() end
    o._wisys.render=function() A.render(o) end
    if o._bosssys and o._bosssys.aura then o._bosssys.aura.hide=true end
end
function A.tick(o,s)
    local a=o.asl_actor;if not a then return end
    local left=s.direction%360>90 and s.direction%360<270
    local p=D.profiles[a.profile]
    if p.mirror==1 then
        a.mirrorClock=math.max(-10,math.min(10,a.mirrorClock+(left and -1 or 1)))
        if a.mirrorClock==-10 then a.mirror=-1 elseif a.mirrorClock==10 then a.mirror=1 end
    end
    step(a.nodes,a.states,{Moveleft=math.abs(s.speed)>.5 and left,Moveright=math.abs(s.speed)>.5 and not left,Act=(s.act or 0)~=0})
    a.rotation=(s.rotation or 90)-90
    a.tint={alpha=(s.alpha or 100)/100,red=(s.red or 100)/100,green=(s.green or 100)/100,blue=(s.blue or 100)/100,
        blend=s.blend==1 and 'mul+add' or s.invert==1 and 'mul+rev' or ''}
end
function A.render(o)
    local a=o.asl_actor
    if a and not o.hide then render(a.nodes,a.states,o.x,o.y,a.rotation,a.mirror,a.tint) end
    local s=o.asl
    if s and s.c.linked and not (RogueBossHUD and RogueBossHUD.enabled()) then
        local bar=D.linkedBar
        a.healthStates=a.healthStates or states(bar.nodes)
        for i,n in ipairs(bar.nodes) do
            if n.linkedHealth then a.healthStates[i].sx=n.sx*math.max(0,o.hp/o.maxhp) end
        end
        render(bar.nodes,a.healthStates,o.x,o.y+bar.offset*48,0,1)
    end
end
local Portrait=Class(object,{
    init=function(o,nodes)
        o.nodes,o.states=nodes,states(nodes)
        o.bound,o.colli,o.group,o.layer=false,false,GROUP.GHOST,LAYER.TOP-10
    end,
    frame=function(o)
        step(o.nodes,o.states,{});step(o.nodes,o.states,{})
        if o.timer>=150 then Del(o) end
    end,
    render=function(o) render(o.nodes,o.states,-216,230.4,0,1) end,
})
function A.portrait(key)
    local p=D.phases[key];local nodes=p and p.portrait and D.portraits[p.portrait]
    if nodes then return New(Portrait,nodes) end
end
A.picture=picture
function A.prepare(key)
    local phase=D.phases[key]
    if not phase then return end
    local function nodes(list)
        for _,n in ipairs(list or {}) do
            picture(n.sprite)
            local controller=n.controller and D.controllers[n.controller]
            for _,clip in pairs(controller and controller.states or {}) do
                for _,track in ipairs(clip.tracks) do if track.path=='' then
                    for _,frame in ipairs(track.keys) do picture(frame[2]) end
                end end
            end
        end
    end
    for _,id in ipairs(phase) do nodes(D.profiles[id].nodes) end
    nodes(phase.portrait and D.portraits[phase.portrait])
    if phase.linked then nodes(D.linkedBar.nodes) end
end
return A
