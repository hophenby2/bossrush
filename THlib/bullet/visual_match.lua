-- 子弹只换现成样式、不缩放、不改旧判定；激光显示与碰撞分别按原作几何处理。
local V = {}
local function inherit_data(child, parent)
    -- LuaSTG 的 Class 只复制六个回调，不会继承 CyGrow、_TurnOn 等类表方法。
    for k, value in pairs(parent) do
        if rawget(child, k) == nil then child[k] = value end
    end
    return child
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
            local a, b, rect = o.a, o.b, o.rect
            o._blend = blend
            visual.init(o, index)
            o.a, o.b, o.rect = a, b, rect
        end,
        size = visual.size,
        RenderFunc = visual.RenderFunc,
        SetColorFunc = visual.SetColorFunc,
        visual_style = visual,
        collision_style = original.collision_style or original,
    }, true)
    inherit_data(mapped, visual)
    styles[original][visual] = mapped
    return mapped
end

local function width_factor(o)
    local factor = o._visual_width_factor or 1
    if factor == 2 and o.w0 == 1.2 and o.w == o.w0 then factor = 1 end
    return factor
end

function V.laser_collision(o, check)
    local x, y, w, l1, l2, l3, colli = o.x, o.y, o.w, o.l1, o.l2, o.l3, o.colli
    local full = w * width_factor(o)
    local len, offset = l1 + l2 + l3, 0
    if not o._native_laser_box then
        if o._native_laser_game == 95 then
            -- PhotoGame::CalcLaserHitbox 接收全宽，激光在两端各留 8px。
            o.w = full < 32 and full / 2 or full - 16
            offset, len = 8, math.max(0, len - 16)
            if o._native_laser_straight and full <= 40 then o.colli = false end
        else
            -- TH07/08 的 laserSize.y = 原作 width/2；判定盒半高再除以二。
            local phase, clock, hbEnd, maximum
            if o._native_laser_game == 7 then
                phase, clock, hbEnd, maximum = o.pl_state, (o.pl_t or 1)-1, o.pl_hbEnd, o.pl_lw
                if phase ~= nil then phase = phase + 1 end
            elseif o._native_laser_phase then
                local p = o._native_laser_phase
                phase, clock, hbEnd, maximum = rawget(o,p[1]), (rawget(o,p[2]) or 1)-1, p[3], p[4]
            end
            o.w = (maximum or full) / 2
            local start = o.pl_sOff or o._native_laser_start or 0
            if phase == 1 or phase == 3 then
                -- 原作展开/收束期间只在中点保留小判定段；纵向尺寸仍用最大宽度。
                offset, len = len / 2 - full / 4, full / 2
                if phase == 3 and hbEnd then o.colli = clock < hbEnd end
            elseif o._native_laser_game == 8 and start > 0 then
                offset, len = len * 0.15, len * 0.7
            end
        end
    end
    local angle = math.rad(o.rot)
    o.x, o.y = x + math.cos(angle) * offset, y + math.sin(angle) * offset
    o.l1, o.l2, o.l3 = 0, len, 0
    check(o)
    o.x, o.y, o.w, o.l1, o.l2, o.l3, o.colli = x, y, w, l1, l2, l3, colli
end

local lasers = {}
function V.laser_render_width(o)
    return o.w * width_factor(o) * 7 / 16
end

function V.laser(base, game)
    lasers[base] = lasers[base] or {}
    if lasers[base][game] then return lasers[base][game] end
    local mapped = Class(base, {
        init = function(o, ...)
            base.init(o, ...)
            o._native_laser_game = game
            -- 现有 laser2 的亮芯横截面更接近原作；避免 laser1 大量透明边缘造成过细观感。
            -- 只换光柱三段，不改变节点/头部的原色号。
            o.imgid = 2
            o.img1, o.img2, o.img3 = 'laser21'..o.index, 'laser22'..o.index, 'laser23'..o.index
        end,
    }, true)
    inherit_data(mapped, base)
    lasers[base][game] = mapped
    return mapped
end
OriginalBulletVisual = V
return V
