-- 600×720 原作画面共用宿主战斗区。UI 模式仍裁切到战斗区。
local L = LikeDreamer
local V = {}
L.Viewport = V

function V.capture()
    local world = lstg.world
    local left,right,bottom,top = world.scrl,world.scrr,world.scrb,world.scrt
    local scale = math.min((right-left)/L.Core.WIDTH,(top-bottom)/L.Core.HEIGHT)
    local origin = (left+right-L.Core.WIDTH*scale)/2
    local ceiling = (bottom+top+L.Core.HEIGHT*scale)/2
    return {
        left=left,right=right,bottom=bottom,top=top,scale=scale,origin=origin,ceiling=ceiling,
        mapX=function(_, x) return origin+(x-340)*scale end,
        mapY=function(_, y) return ceiling-y*scale end,
    }
end

function V.draw(callback, ...)
    local previous = lstg.viewmode or 'world'
    SetViewMode('ui')
    local box = V.capture()
    SetRenderRect(box.left,box.right,box.bottom,box.top,
        box.left,box.right,box.bottom,box.top)
    callback(...)
    SetViewMode(previous)
end

return V
