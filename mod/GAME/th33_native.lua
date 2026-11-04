-- TH095 BulletManager.cpp:445..478/1428..1445：出生先退四帧速度，过渡期半速，
-- 结束当帧再执行一次完整ACTIVE。bullet.anm的interrupt7/8/9分别等待8/15/25帧。
-- 激光状态机来自PhotoEffect.cpp；秘鍵来自enm16/script8/sprite11，幽幽子的扇面来自
-- enm17/script12/sprite11。原始THTX只经texture_png.py封装成PNG，没有重画。
local N={}
-- SpawnWithContext先RunEcl(0)，保留协程及运动状态，位置仍待管理器积分。
function N.enemy_birth(o,step)
    local x,y=o.x,o.y
    local run=step or task.Do
    run(o)
    if not IsValid(o) or o.status=='del' or o.status=='kill' then return false end
    o.x,o.y=x,y
    return true
end
function N.boundary_angle(x,y,box,previous)
    local a
    if player.x<x then
        a=ran:Float(0,math.pi/2)+2.3561945
        if a>math.pi then a=a-2*math.pi end
    else a=ran:Float(0,math.pi/2)-0.78539819 end
    if x<box[1]+96 then
        if a>1.5707964 then a=3.1415927-a
        elseif a< -1.5707964 then a= -3.1415927-a end
    end
    if x>box[3]-96 then
        if a<1.5707964 and a>=0 then a=3.1415927-(previous or 0)
        elseif a> -1.5707964 and a<=0 then a= -3.1415927-(previous or 0) end
    end
    if y<box[2]+48 and a<0 then a= -a end
    if y>box[4]-48 and a>0 then a= -a end
    return a
end
local function easing(t,mode)
    if mode>=1 and mode<=3 then return t^(mode+1) end
    if mode>=4 and mode<=6 then return 1-(1-t)^(mode-2) end
    return t
end
function N.move(owner,st,tx,ty,n,mode,box)
    mode=mode or 0
    if st.mv then st.mv.alive=false end
    local token={alive=true};st.mv=token
    local x0,y0=owner.x,owner.y
    local dx,dy=tx-x0,ty-y0
    task.New(owner,function()
        for s=1,n do
            if not token.alive or st.dead then return end
            local t=type(mode)=='function' and mode(s/n) or easing(s/n,mode)
            local x,y=x0+dx*t,y0+dy*t
            st.mv_angle=math.atan2(-(y-owner.y),x-owner.x)
            if box then
                x=math.max(box[1],math.min(box[3],x))
                y=math.max(224-box[4],math.min(224-box[2],y))
            end
            owner.x,owner.y=x,y
            task.Wait()
        end
    end)
end
function N.bmove(owner,st,n,mode,speed,box)
    local a=N.boundary_angle(owner.x,224-owner.y,box,st.mv_angle)
    N.move(owner,st,owner.x+math.cos(a)*speed*n,owner.y-math.sin(a)*speed*n,n,mode,box)
end
LoadTexture('th33_enm16','Resources/System/th33_enm16.png')
LoadImage('th33_key','th33_enm16',128,80,128,144)
LoadTexture('th33_fan','Resources/System/th33_fan.png')
LoadImage('th33_fan','th33_fan',0,0,512,255)
-- enm17/script12与Sub8/9：一把跟随本体的扇子，不是额外八只绕圈的蝶。
N.fan=Class(object,{
    init=function(o,owner)
        o.owner,o.x,o.y,o.th095_fan_age=owner,owner.x,owner.y,0
        o.group,o.colli,o.bound,o.layer=GROUP.GHOST,false,false,LAYER.ENEMY-0.01
    end,
    frame=function(o)
        if not IsValid(o.owner) then object.RawDel(o);return end
        o.x,o.y=o.owner.x,o.owner.y
        o.th095_fan_age=o.th095_fan_age+1
    end,
    render=function(o)
        local t=o.th095_fan_age
        local sx=easing(math.min(1,t/30),4)
        local sy=t<30 and 0.2*sx or (0.2+0.8*easing(math.min(1,(t-30)/30),4))
        local y
        if t<30 then y=8*easing(t/128,4)
        elseif t<158 then
            local start=8*easing(30/128,4)
            y=start+(4-start)*easing((t-30)/128,4)
        else
            local phase=math.floor((t-158)/128)%2
            local u=easing((t-158)%128/128,4)
            y=phase==0 and (4-8*u) or (-4+8*u)
        end
        SetImageState('th33_fan','mul+add',255,255,255,255)
        Render('th33_fan',o.x,o.y-y,0,sx,sy)
    end,
})
local native_laser=OriginalBulletVisual.laser(laser,95)
-- PhotoEffectManager::Spawn只有共用的256槽；两种激光共用，满槽整根不生成。
local laser_slots={}
local function reserve_laser(o)
    local free
    for i=1,256 do
        local current=laser_slots[i]
        if current==o then return true end
        if (not current or not IsValid(current)) and not free then free=i end
    end
    if not free then object.RawDel(o);return false end
    laser_slots[free]=o
    return true
end
local straight_laser=Class(native_laser,{
    frame=function(o)
        local length=o.th095_length
        if length<o.th095_max_length then
            length=math.min(o.th095_max_length,length+o.th095_laser_speed)
        else
            o.th095_tail=o.th095_tail+o.th095_laser_speed
            o.x,o.y=o.x+cos(o.rot)*o.th095_laser_speed,o.y+sin(o.rot)*o.th095_laser_speed
            if o.th095_terminal>0 and o.th095_tail+length>o.th095_terminal then
                length=o.th095_terminal-o.th095_tail;o.th095_max_length=length
                if length<=0 then object.RawDel(o);return end
            end
        end
        o.th095_length=length
        local hx,hy=o.x+cos(o.rot)*length,o.y+sin(o.rot)*length
        local w=o.w0
        local function outside(x,y) return x+w<=-192 or x-w>=192 or y+w<=-224 or y-w>=224 end
        if outside(o.x,o.y) and outside(hx,hy) then object.RawDel(o);return end
        o.l1,o.l2,o.l3,o.w,o.alpha,o.colli=0,length,0,w,1,length>16
        native_laser.frame(o)
    end,
})
function N.straight(o,max_length,width,speed,initial,terminal)
    if not reserve_laser(o) then return false end
    o.class,o._native_laser_straight=straight_laser,true
    o.th095_length,o.th095_max_length=initial or 0,max_length
    o.th095_tail=(initial or 0)>0 and 0.01 or 0
    o.th095_terminal,o.th095_laser_speed=terminal or 0,speed
    o.l1,o.l2,o.l3,o.w0,o.w,o.alpha=0,initial or 0,0,width,width,1
    o.bound,o.colli=false,false
    return true
end
local rotating_laser=Class(native_laser,{
    frame=function(o)
        local length=math.min(o.th095_max_length,o.l2+o.th095_laser_speed)
        o.rot=o.rot+o.th095_angular_speed
        if o.th095_follow and IsValid(o.th095_target) then o.x,o.y=o.th095_target.x,o.th095_target.y end
        o.x,o.y=o.x+o.th095_laser_vx,o.y+o.th095_laser_vy
        local state,t,w=o.th095_laser_state,o.th095_laser_time,o.w
        if state==3 then
            if t>=o.th095_startup then state,t=4,0 end
        elseif state==4 then
            if t>=o.th095_growth then state,t,w=2,0,o.w0
            else w=t*o.w0/o.th095_growth end
        end
        if state==2 and t>=o.th095_sustain then state,t=5,0 end
        if state==5 then
            if t>=o.th095_fade then object.RawDel(o);return end
            w=o.w0*(1-t/o.th095_fade)
        end
        o.th095_laser_state,o.th095_laser_time=state,t+1
        o.l1,o.l2,o.l3,o.w,o.alpha=0,length,0,w,1
        o.colli=(state==4 or state==2) and length>16
        native_laser.frame(o)
    end,
})
function N.rotating(o,target,max_length,width,speed,startup,growth,sustain,fade,angular_speed,vx,vy,follow)
    if not reserve_laser(o) then return false end
    o.class,o.bound=rotating_laser,false
    o.th095_laser_state,o.th095_laser_time=3,0
    o.th095_target,o.th095_follow=target,follow
    o.th095_laser_speed,o.th095_angular_speed=speed,angular_speed
    o.th095_laser_vx,o.th095_laser_vy=vx,vy
    o.th095_startup,o.th095_growth,o.th095_sustain,o.th095_fade=startup,growth,sustain,fade
    o.th095_max_length,o.w0,o.w,o.alpha=max_length,width,2,1
    o.counter,o.colli=0,false
    return true
end
LoadTexture('th33_transition','Resources/System/th33_transition.png')
for i=0,4 do
    LoadImage('th33_despawn_'..i,'th33_transition',145+i*16,241,14,14)
end
local despawn=Class(object,{
    frame=function(o)
        o.th095_despawn_age=o.th095_despawn_age+1
        local u=o.th095_despawn_age/o.th095_despawn_duration
        if u>=1 then OriginalBulletVisual.retire(o);return end
        o.vx,o.vy=o.th095_despawn_vx/2,o.th095_despawn_vy/2
        if o.th095_despawn_star then
            -- ANM interrupt1：小弹换14px星芒，0.4→1.9；不是直接释放父弹槽。
            local scale=0.4+1.5*(1-(1-u)^2)
            o.hscale,o.vscale=scale,scale
        else
            local scale=(1-u)^2
            o.hscale,o.vscale=o.th095_despawn_h*scale,o.th095_despawn_v*scale
            if o.imgclass.native_type==16 or o.imgclass.native_type==17 then o._a=255*scale end
        end
    end,
    render=function(o)
        if o.th095_despawn_star then
            SetImageState(o.img,'mul+add',255,255,255,255)
            Render(o.img,o.x,o.y,0,o.hscale,o.vscale)
        else bullet.render(o) end
    end,
    del=function(o) if not o._original_silent_remove then object.Preserve(o) end end,
    kill=function(o) object.Preserve(o) end,
})
function N.despawn(o)
    if o.th095_despawn_age then return end
    local kind=o.imgclass.native_type or 0
    local small=kind<12 or kind==23
    o.th095_despawn_age,o.th095_despawn_duration=0,small and 8 or 12
    o.th095_despawn_vx,o.th095_despawn_vy=o.vx,o.vy
    o.th095_despawn_h,o.th095_despawn_v=o.hscale,o.vscale
    o.th095_despawn_star=small
    o.colli,o.bound,o.class=false,false,despawn
    if small then
        local color=o.th095_color
        if color==nil then
            local index=o.real_index or 16
            color=index==16 and 0 or index
        end
        local c=(color==0 or color==15) and 0 or (color<=4 and 1 or (color<=8 and 2 or (color<=11 and 3 or 4)))
        if kind==23 then c=4 end
        o.img='th33_despawn_'..c
        o.hscale,o.vscale=0.4,0.4
    end
end
local pool,stamp,scene,used={},nil,nil,0
function N.reset_owned(tag)
    for _,o in ipairs(pool) do
        if IsValid(o) and o.status~='del' and o.status~='kill' and o.sg_tag==tag then
            -- ExIns21只清运动程序，保留当前角度和ANM，再以4.5速直飞。
            o.th095_motion_reset=true
            o.th095_angle,o.th095_speed=o.rot,4.5
            o.vx,o.vy=4.5*cos(o.rot),4.5*sin(o.rot)
            o.th095_spawn_vx,o.th095_spawn_vy=o.vx,o.vy
            o.th095_despawn_vx,o.th095_despawn_vy=o.vx,o.vy
        end
    end
end
local function refresh()
    local list={}
    for _,o in ipairs(pool) do
        if IsValid(o) and o.status~='del' and o.status~='kill' then list[#list+1]=o end
    end
    pool,used=list,#list
end
function N.reserve()
    local s=stage and stage.current_stage
    local t=s and s.timer
    if not t or t~=stamp or s~=scene or used>=1600 then
        refresh();stamp,scene=t,s
    end
    if used>=1600 then return false end
    used=used+1
    return true
end
local function bit(v,n) return math.floor(v/n)%2==1 end
function N.rate(owner,speed)
    if not owner.th095_rate_active then
        owner.th095_rate_active=true
        owner.th095_saved_fps=lstg.var.CYFPS
    end
    lstg.var.CYFPS=60*speed
end
function N.restore_rate(owner)
    if owner.th095_rate_active then
        lstg.var.CYFPS=owner.th095_saved_fps
        owner.th095_rate_active,owner.th095_saved_fps=nil,nil
    end
end
function N.begin(o,flags,birth)
    pool[#pool+1]=o
    o.th095_angle,o.th095_speed=o.rot,GetV(o)
    o.class=o.logclass or o.class
    if o._layer and o.imgclass.size then
        o.layer=o._layer-o.imgclass.size*0.001+(o._index or 1)*0.00001
    end
    local count=bit(flags,2) and 8 or (bit(flags,4) and 15 or (bit(flags,8) and 25 or 0))
    o.th095_spawn_flags=flags
    if count>0 then
        o.th095_spawn_left=count
        o.th095_spawn_vx,o.th095_spawn_vy=o.vx,o.vy
        o.x,o.y=o.x-o.vx*4,o.y-o.vy*4
        o.colli=false
    end
    -- SpawnSingleBullet在出生当帧就认领第一条记录，此时不更新运动或记录计时。
    if birth then birth(o,true) end
end
function N.step(o,frame)
    local left=o.th095_spawn_left or 0
    if left>0 then
        local vx,vy=o.th095_spawn_vx,o.th095_spawn_vy
        left=left-1;o.th095_spawn_left=left
        if left>0 then o.vx,o.vy=vx/2,vy/2;return end
        -- 原作同帧先走SPAWNING的半步，再落入ACTIVE走完整步。
        o.x,o.y=o.x+vx/2,o.y+vy/2
        o.vx,o.vy=vx,vy
        o.colli=not o.th095_capture_disabled;o._native_visual_start=o.ani
    end
    if frame and not o.th095_motion_reset then frame(o) end
end
-- 回调只改velocity，不改逻辑angle/speed；ExIns3要用后两者恢复运动。
function N.capture_tag(mode,tag,angle,speed)
    for _,o in ipairs(pool) do
        if IsValid(o) and o.status~='del' and o.status~='kill' and o.sg_tag==tag then
            local a=mode==2 and angle or angle+o.th095_angle
            local v=speed>-999 and speed or o.th095_speed
            o.vx,o.vy=v*cos(a),v*sin(a)
            o.th095_capture_disabled,o.colli=true,false
            if (o.th095_spawn_left or 0)>0 then
                o.th095_spawn_vx,o.th095_spawn_vy=o.vx,o.vy
                -- ExIns2的pendingInterrupt等本次弹更新末尾执行；4则已在ECL里执行。
                o.th095_spawn_left=mode==4 and 1 or 2
            end
            OriginalBulletVisual.photo_phase(o,true,mode==4)
        end
    end
end
function N.fade_tag(tag)
    for _,o in ipairs(pool) do
        if IsValid(o) and o.status~='del' and o.status~='kill' and o.sg_tag==tag and o.th095_capture_disabled then
            o._native_anm.interps.alpha={time=0,duration=30,mode=0,from={64},target={255}}
        end
    end
end
function N.restore_motion()
    for _,o in ipairs(pool) do
        if IsValid(o) and o.status~='del' and o.status~='kill' then
            o.vx,o.vy=o.th095_speed*cos(o.th095_angle),o.th095_speed*sin(o.th095_angle)
            o.th095_capture_disabled=false
            o.colli=not (o.th095_despawn_age or o._original_despawning)
            if (o.th095_spawn_left or 0)>0 then
                o.th095_spawn_vx,o.th095_spawn_vy=o.vx,o.vy
                o.th095_spawn_left=2;o.colli=false
            end
            OriginalBulletVisual.photo_phase(o,false,false)
        end
    end
end
return N
