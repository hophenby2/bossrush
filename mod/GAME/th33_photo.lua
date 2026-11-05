-- TH095的非目标敌机拍摄、毒雾减速与ExIns20回避；计数与Boss伤害仍由关卡入口结算。
-- PhotoRuntime只拍取景框相交的实体，112切换主context，运动与已创建的VM独立保留。
local P={actors={}}
local sources=dofile('mod/GAME/th33_photo_sources.lua')
local function valid(o) return o and IsValid(o) and o.status~='del' and o.status~='kill' end
function P.contains(camera,o,width,height)
    if not camera or not camera.A then return false end
    local poly={camera.A,camera.B,camera.C,camera.D}
    local hw,hh=(width or 8)/2,(height or width or 8)/2
    -- 原作是AABB重叠；项目相机允许旋转，对四条边及x/y轴做分离轴检查。
    local axes={{1,0},{0,1}}
    for i=1,4 do
        local a,b=poly[i],poly[i%4+1]
        axes[#axes+1]={-(b.y-a.y),b.x-a.x}
    end
    for _,axis in ipairs(axes) do
        local x,y=axis[1],axis[2]
        local low,high=math.huge,-math.huge
        for _,v in ipairs(poly) do local n=v.x*x+v.y*y;low=math.min(low,n);high=math.max(high,n) end
        local center=o.x*x+o.y*y
        local half=math.abs(x)*hw+math.abs(y)*hh
        if center+half<low or center-half>high then return false end
    end
    return true
end
function P.target_contains(camera,o)
    if not camera or not camera.A then return false end
    local poly={camera.A,camera.B,camera.C,camera.D}
    -- PhotoCamera的有效目标判定要求8×8方框完全位于取景框内，和普通使魔的相交判定不同。
    for _,dx in ipairs({-4,4}) do for _,dy in ipairs({-4,4}) do
        local sign
        for i=1,4 do
            local a,b=poly[i],poly[i%4+1]
            local cross=(b.x-a.x)*(o.y+dy-a.y)-(b.y-a.y)*(o.x+dx-a.x)
            if cross~=0 then
                local side=cross>0
                if sign~=nil and side~=sign then return false end
                sign=side
            end
        end
    end end
    return true
end
function P.bind(o,key)
    if o._bosssys then return end
    if P.reserve and not P.reserve(o) then object.RawDel(o);return false end
    if o.th095_skip_offscreen==nil then o.th095_skip_offscreen=true end -- 模板flags1默认置0x04000000。
    o.th095_photo_source=key
    o.th095_collidable=false
    o.th095_photo_cfg=sources[key] or {box={24,24},life=0}
    o.th095_photo_owner=P.owner
    P.actors[#P.actors+1]=o
end
function P.flags(o,c)
    local contains=math.floor(c[3]/2)%2==1
    if c[2]==79 then o.th095_collidable=not contains
    elseif contains then o.th095_collidable=c[2]==81 end
    local skip=math.floor(c[3]/16)%2==1
    if c[2]==79 then o.th095_skip_offscreen=skip
    elseif skip then o.th095_skip_offscreen=c[2]==81 end
    if o._bosssys then o.colli=o.th095_collidable end
end
function P.cull(o)
    if o._bosssys or o.th095_skip_offscreen~=false then return false end
    local actor=o._original_actor
    local vm=actor and actor.vm
    local sprite=vm and vm.data.sprites[vm.sprite]
    local w,h=0,0
    if sprite then w,h=sprite[4]*vm.scale[1],sprite[5]*vm.scale[2] end
    local x,y=o.x+(o.vx or 0),o.y+(o.vy or 0)
    local outside=x+w<=-192 or x-w>=192 or y+h<=-224 or y-h>=224
    if not outside then o.th095_entered=true
    elseif o.th095_entered then object.RawDel(o);return true end
    return false
end
function P.contact(o)
    if not valid(o) or o._bosssys or not o.th095_collidable or o.th095_contact_stamp==o.ani then return end
    o.th095_contact_stamp=o.ani
    local box=o._original_damage_box or {24,24}
    local function check(p)
        if valid(p) and math.abs(p.x-o.x)<=box[1]/2+(p.A or p.a or 0)
            and math.abs(p.y-o.y)<=box[2]/2+(p.B or p.b or 0) then p.class.colli(p,o) end
    end
    if GameNet then GameNet.forEachPlayer(check) else check(player) end
end
local function scale_near(o)
    if not P.owner or not valid(player) then return end
    local d=(player.x-o.x)^2+(player.y-o.y)^2
    if d<1024 then P.move_scale=0.25
    elseif d<4096 then P.move_scale=(d-1024)/3072*0.75+0.25 end
end
function P.take(camera,owner)
    if owner~=P.owner then return end
    for _,o in ipairs(P.actors) do
        if valid(o) and o.th095_photo_owner==owner and not o._original_hidden and (o.th095_photo_marker or 0)==0 then
            local cfg=o.th095_photo_cfg
            local box=o._original_damage_box or cfg.box
            if P.contains(camera,o,box[1],box[2]) then o.th095_photo_pending=true end
        end
    end
end
local function enter_capture(o)
    o.th095_photo_pending=nil
    local cfg=o.th095_photo_cfg
    task.Clear(o)
    if o._mv and o._mv.mv then o._mv.mv.alive=false end
    local state={age=0,life=cfg.life,move=o.th095_motion_snapshot}
    if cfg.drop then state.move={x=o.x,y=o.y,dx=0,dy=-cfg.drop,n=cfg.life,mode=cfg.mode,age=0} end
    if not state.move and o.dir and o.spd then state.velocity={o.spd*math.cos(o.dir),-o.spd*math.sin(o.dir)} end
    o.th095_photo_capture=state
    if cfg.callback then OriginalStageVisual.presentation.captured(o,cfg.callback)
    else o._original_presentation=nil end
    if cfg.script then
        local file=o.th095_photo_source:match('^ecl(%d+)_')
        OriginalStageVisual.actor(o,95,'enm'..file,cfg.script)
        o._original_actor.poses=nil
    end
    if cfg.interrupt and o.th095_cloud_vm and not o._original_presentation then
        OriginalANM.interrupt(o.th095_cloud_vm,cfg.interrupt[2])
    end
    o.vx,o.vy=0,0
end
local function easing(t,mode)
    if type(mode)=='function' then return mode(t) end
    if mode>=1 and mode<=3 then return t^(mode+1) end
    if mode>=4 and mode<=6 then return 1-(1-t)^(mode-2) end
    return t
end
function P.frame_actor(o)
    if o.th095_photo_pending then enter_capture(o) end
    local c=o.th095_photo_capture
    if not c then return false end
    local program=o._original_presentation
    if program then OriginalStageVisual.presentation.advance(o,program.clock+1) end
    if c.age>=c.life then object.RawDel(o);return true end
    if o.th095_poison then scale_near(o) end
    local m=c.move
    if m and m.age<m.n then
        m.age=m.age+1
        local u=easing(math.min(1,m.age/m.n),m.mode or 0)
        o.x,o.y=m.x+m.dx*u,m.y+m.dy*u
    elseif c.velocity then
        o.x,o.y=o.x+c.velocity[1],o.y+c.velocity[2]
    elseif o.th095_poison then
        o.x=o.x+o.th095_cloud_dx;o.y=o.y+o.th095_cloud_dy
    end
    c.age=c.age+1
    return true
end
function P.begin(owner)
    P.owner,P.move_scale=owner,1
    local p=player
    if not valid(p) or not p._playersys then return end
    owner.th095_slow_player=p
    p._playersys:addFrameBeforeEvent('th095.poison',1000,function(who)
        if P.owner~=owner then return end
        owner.th095_speeds={who.hspeed,who.lspeed,who.llspeed}
        local s=P.move_scale or 1
        who.hspeed,who.lspeed=who.hspeed*s,who.lspeed*s
        if who.llspeed then who.llspeed=who.llspeed*s end
    end)
    p._playersys:addFrameAfterEvent('th095.poison',-1000,function(who)
        local s=owner.th095_speeds
        if s then who.hspeed,who.lspeed,who.llspeed=s[1],s[2],s[3];owner.th095_speeds=nil end
    end)
end
function P.finish(owner)
    OriginalStageVisual.presentation.clear(owner)
    local p=owner.th095_slow_player
    if valid(p) and p._playersys then
        p._playersys:removeFrameBeforeEvent('th095.poison')
        p._playersys:removeFrameAfterEvent('th095.poison')
        local s=owner.th095_speeds
        if s then p.hspeed,p.lspeed,p.llspeed=s[1],s[2],s[3] end
    end
    owner.th095_slow_player,owner.th095_speeds=nil,nil
    owner.th095_transition_state=nil
    for _,o in ipairs(P.actors) do if valid(o) and o.th095_photo_owner==owner then object.RawDel(o) end end
    P.actors={}
    if P.owner==owner then P.owner,P.move_scale=nil,1 end
end
function P.owner_frame(owner)
    if P.owner~=owner then return end
    P.move_scale=1
    local n=0
    for _,o in ipairs(P.actors) do if valid(o) then n=n+1;P.actors[n]=o end end
    for i=#P.actors,n+1,-1 do P.actors[i]=nil end
end
P.cloud=Class(object,{
    init=function(o,owner,kind,angle)
        if P.reserve and not P.reserve(o) then object.RawDel(o);return end
        local speed=kind=='b' and 2 or kind=='c' and 1 or 0.8
        o.x,o.y=owner.x+60*math.cos(angle),owner.y-60*math.sin(angle)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY,false,false
        o.th095_poison,o.th095_cloud_kind,o.th095_cloud_age=true,kind,1
        o.th095_cloud_dx,o.th095_cloud_dy=speed*math.cos(angle),-speed*math.sin(angle)
        OriginalStageVisual.bind_source(o,95,'ecl9_'..kind..':6')
        local handle=OriginalStageVisual.presentation.handle(o,0)
        o.th095_cloud_vm=handle and handle.vm
        o.th095_cloud_handle=handle
    end,
    frame=function(o)
        if o.th095_cloud_handle and IsValid(o.th095_cloud_handle) then
            o.th095_cloud_handle.x,o.th095_cloud_handle.y=o.x,o.y
        end
        local program=o._original_presentation
        if program and not o.th095_photo_capture and not o.th095_photo_pending then
            OriginalStageVisual.presentation.advance(o,program.clock+1)
        end
        if not P.frame_actor(o) then
            scale_near(o)
            local t=o.th095_cloud_age
            local fade=o.th095_cloud_kind=='b' and 90 or o.th095_cloud_kind=='c' and 240
            if t>=(o.th095_cloud_kind=='a' and 300 or fade+20) then object.RawDel(o);return end
            o.x,o.y=o.x+o.th095_cloud_dx,o.y+o.th095_cloud_dy
            o.th095_cloud_age=t+1
        end
        OriginalStageVisual.tick(o)
    end,
    render=function(o)
        OriginalStageVisual.draw(o)
    end,
},true)
function P.clouds(owner,kind)
    local a=math.atan2(-(player.y-owner.y),player.x-owner.x)
    if kind=='a' then
        for _,offset in ipairs({0,-math.pi/4,math.pi/4}) do New(P.cloud,owner,kind,a+offset) end
    elseif kind=='c' then
        for i=0,15 do New(P.cloud,owner,kind,a+i*0.39269909) end
    else
        task.New(owner,function()
            local angle=1.5707964
            while P.owner==owner do
                New(P.cloud,owner,'b',angle)
                angle=angle+0.39269909
                task.Wait(7)
            end
        end)
    end
end
-- ExIns20使用正在取景的相机，而不是已经结算的照片数。
function P.transition(owner,native)
    local camera=player and player.camera
    if native.th095_transition_left and native.th095_transition_left>0 then
        native.th095_transition_left=native.th095_transition_left-1
        if native.th095_transition_left==60 then
            OriginalStageVisual.interrupt_background(95,3)
            OriginalStageVisual.presentation.sound.play(95,15,owner.x)
        end
    end
    if (native.th095_transition_left or 0)==0 and camera and camera.photoing and not camera.writing and P.target_contains(camera,owner) then
        native.th095_transition_left=120
        OriginalStageVisual.interrupt_background(95,2)
        OriginalStageVisual.presentation.sound.play(95,38,owner.x)
        local width=math.max(camera.A.x,camera.B.x,camera.C.x,camera.D.x)-math.min(camera.A.x,camera.B.x,camera.C.x,camera.D.x)
        local center=camera.centerx
        local tx=center+(center<0 and 1 or -1)*width*0.60000002
        local ty=owner.y+(player.y>owner.y and -1 or 1)*ran:Float(0,64)
        native.th095_transition_target={tx,ty}
    end
    return native.th095_transition_left or 0
end
function P.transition_move(owner,state,native)
    local target=state.th095_transition_target
    if target then
        state.th095_transition_target=nil
        if state.mv then state.mv.alive=false end
        native.clear_move(owner)
        state.th095_transition_motion={x=owner.x,y=owner.y,dx=target[1]-owner.x,
            dy=target[2]-owner.y,age=0,n=60}
    end
    local m=state.th095_transition_motion
    if not m then return end
    m.age=m.age+1
    local t=math.min(1,m.age/m.n)
    local u=1-(1-t)^2
    local x,y=m.x+m.dx*u,m.y+m.dy*u
    local box=state.th095_transition_box
    if box then
        x=math.max(box[1],math.min(box[3],x))
        y=math.max(224-box[4],math.min(224-box[2],y))
    end
    native.queue_move(owner,owner.th095_move_serial,x,y,state)
    if m.age>=m.n then state.th095_transition_motion=nil end
end
for _,kind in ipairs({'a','b','c'}) do OriginalStageVisual.presentation.manage(95,'ecl9_'..kind..':6') end
return P
