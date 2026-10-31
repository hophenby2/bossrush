-- 原作移植的显示映射：只替换现成样式，不缩放弹体，不改变既有碰撞尺寸。
local V = {}
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
