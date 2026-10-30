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
function V.laser(base)
    if lasers[base] then return lasers[base] end
    local function render(o)
        -- THlib 的 16px 图按 w/7 显示；原作按实际像素宽度显示。
        -- 仅渲染期间换算，frame/碰撞继续使用原先的 w、w0。
        local w, w0 = o.w, o.w0
        local factor = o._visual_width_factor or 1
        if factor == 2 and w0 == 1.2 and w == w0 then factor = 1 end
        o.w, o.w0 = w * factor * 7 / 16, w0 * factor * 7 / 16
        base.render(o)
        o.w, o.w0 = w, w0
    end
    local fading = Class(base, { frame = task.Do, render = render,
        del = function() end, kill = function() end }, true)
    local mapped = Class(base, {
        render = render,
        kill = function(o) base.kill(o); o.class = fading end,
        del = function(o) base.del(o); o.class = fading end,
    }, true)
    lasers[base] = mapped
    return mapped
end
OriginalBulletVisual = V
return V
