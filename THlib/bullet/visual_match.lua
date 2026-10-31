-- 原作移植的显示与回收：保留代理图样尺寸/判定，原ANM朝向和出屏规则单独登记。
local V = {}
V.profiles = dofile('THlib/bullet/original_profiles.lua')
local native_styles = {}
function V.retire(o)
    o._original_silent_remove=true
    object.RawDel(o)
end
function V.native_style(game, kind, style)
    native_styles[game] = native_styles[game] or {}
    local bykind = native_styles[game]
    bykind[kind] = bykind[kind] or {}
    if bykind[kind][style] then return bykind[kind][style] end
    local mapped = Class(style, {native_profile=assert(V.profiles[game][kind]), native_game=game,
        native_type=kind, visual_style=style.visual_style or style,
        collision_style=style.collision_style or style, size=style.size,
        RenderFunc=style.RenderFunc, SetColorFunc=style.SetColorFunc}, true)
    bykind[kind][style]=mapped
    return mapped
end

-- TH07在折向/反弹期间允许连续出屏128帧；命令结束后倒数已积累的出屏帧。
-- 用原始精灵尺寸检查本帧积分后的坐标，关闭LuaSTG默认边界，避免它提前截断回程。
function V.th07_cull(o, delay, active)
    o.bound=false
    if delay~=0 then return end
    local p=o.imgclass.native_profile or V.profiles[7][o.th07_sprite or 0]
    local x,y=o.x+o.vx,o.y+o.vy
    local outside=x+p.w/2 < -192 or x-p.w/2 > 192 or y+p.h/2 < -224 or y-p.h/2 > 224
    if not outside then o.th07_out=0;return end
    local off=o.th07_out or 0
    if active then
        off=off+1
        if off>=128 then V.retire(o) end
    elseif off==0 then V.retire(o)
    else off=off-1 end
    o.th07_out=off
end
function V.finish_bullet(o)
    local game=o.imgclass.native_game
    local p=o.imgclass.native_profile
    if game==7 and not o.th07_cull_managed then
        V.th07_cull(o,0,false)
    elseif game==95 then
        -- 文花帖的helper用精灵全宽/高作余量，没有TH07的128帧宽限。
        local x,y=o.x+o.vx,o.y+o.vy
        if x+p.w<=-192 or x-p.w>=192 or y+p.h<=-224 or y-p.h>=224 then V.retire(o) end
    elseif game==10 and not o.tb then
        local left=o.th10_cull_delay or 10
        V.th10_cull(o,left,o.x+o.vx,o.y+o.vy)
        o.th10_cull_delay=math.max(0,left-1)
    end
end
function V.th10_cull(o,delay,x,y)
    o.bound=false
    local p=o.imgclass.native_profile
    -- TH10原始g_BulletCullTop=-64，另外三边为-192/192/448。
    if delay<=0 and (x+p.w/2<=-192 or x-p.w/2>=192 or y+p.h/2<=-224 or y-p.h/2>=288) then
        V.retire(o)
        return true
    end
end
local styles = {}
function V.style(original, visual)
    visual = visual.visual_style or visual
    if original == visual then return original end
    styles[original] = styles[original] or {}
    if styles[original][visual] then return styles[original][visual] end
    local mapped = Class(visual, {
        init = function(o, index)
            -- img 赋值会从资源重置判定，所以先取原样式的判定，换图后再恢复。
            local blend = o._blend
            original.init(o, index)
            local a, b = o.a, o.b
            o._blend = blend
            visual.init(o, index)
            o.a, o.b = a, b
        end,
        size = visual.size,
        RenderFunc = visual.RenderFunc,
        SetColorFunc = visual.SetColorFunc,
        visual_style = visual,
        collision_style = original.collision_style or original,
    }, true)
    styles[original][visual] = mapped
    return mapped
end

local lasers = {}
-- 原生 TH06/07/08 在预热/消散阶段把宽度误写入长度，只有中点短段能命中。
-- 参数单独登记，避免把这段判定画成整条有伤害光柱，或直接关掉消散段判定。
function V.native_laser(o, phase, timer, width, hitend, flags, offset)
    o._native_laser_geometry = { phase=phase, timer=timer, width=width,
        hitend=hitend or 0, flags=flags or 0, offset=offset or o._native_laser_start or 0 }
end
local function laser_width(o)
    local factor = o._visual_width_factor or 1
    if factor == 2 and o.w0 == 1.2 and o.w == o.w0 then factor = 1 end
    return o.w*factor
end
function V.laser_render_width(o)
    return laser_width(o)*7/16
end
function V.laser_collision(o, callback)
    local p = o._native_laser_geometry
    local game = o._native_laser_game
    if not p then
        local phase = o._native_laser_phase
        p = {phase=phase and o[phase[1]] or 2, timer=phase and o[phase[2]] or 0,
            hitend=phase and phase[3] or 0,
            width=phase and phase[4] or laser_width(o),
            offset=o._native_laser_start or 0, flags=0}
        if game == 7 and o.pl_state then
            p.phase,p.timer,p.width,p.hitend = o.pl_state+1,o.pl_t,o.pl_lw,o.pl_hbEnd
        end
    end
    local x,y,l1,l2,l3,w,alpha,colli = o.x,o.y,o.l1,o.l2,o.l3,o.w,o.alpha,o.colli
    local length, start = l1+l2+l3, 0
    local drawWidth = laser_width(o)
    if o._native_laser_box then
        -- Enemy::CheckBulletPlayerCollision 先把敌人接触框除以1.5。
        -- 横斩只是借激光绘制；原生实体结束后没有激光的残留判定。
        start,length = length/6,length*2/3
        o.w,o.colli = p.width*2/3,colli and p.phase~=3
    elseif game == 95 then
        -- PhotoEffect.cpp：两端各去掉8px；直线型另有 width>40 的原生闸门。
        start,length = 8,math.max(0,length-16)
        o.w = drawWidth < 32 and drawWidth/2 or drawWidth-16
        o.colli = colli and length > 0 and (not o._native_laser_straight or drawWidth > 40)
    else
        o.w = p.width/2
        if p.phase ~= 2 and p.flags%2 == 0 then
            local short = math.max(0,drawWidth/2)
            start,length = (length-short)/2,short
        elseif game == 8 and p.offset > 0 then
            start,length = length*0.15,length*0.7
        end
    end
    if not o._native_laser_box and game ~= 95 and p.phase == 3 then o.colli = p.timer < p.hitend end
    o.x,o.y = x+cos(o.rot)*start,y+sin(o.rot)*start
    o.l1,o.l2,o.l3,o.alpha = 0,length,0,1
    callback(o)
    o.x,o.y,o.l1,o.l2,o.l3,o.w,o.alpha,o.colli = x,y,l1,l2,l3,w,alpha,colli
end
function V.laser(base, game)
    lasers[base] = lasers[base] or {}
    local key = game or 0
    if lasers[base][key] then return lasers[base][key] end
    local function render(o)
        -- laser.render 在画图时读取 laser_render_width；不改写碰撞字段。
        base.render(o)
    end
    local fading = Class(base, { frame = task.Do, render = render,
        del = function() end, kill = function() end }, true)
    local mapped = Class(base, {
        init = function(o, ...)
            base.init(o, ...)
            o._native_laser_game = game
        end,
        render = render,
        kill = function(o) base.kill(o); o.class = fading end,
        del = function(o) base.del(o); o.class = fading end,
    }, true)
    -- Class 只继承六个回调。CyGrow 等协程入口仍从 class 表显式调用。
    for k,v in pairs(base) do
        if rawget(mapped,k) == nil then mapped[k] = v end
    end
    lasers[base][key] = mapped
    return mapped
end
OriginalBulletVisual = V
return V
