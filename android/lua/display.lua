-- 屏幕尺寸变化只更新显示映射，保留正在进行的弹幕、世界边界与镜头偏移。
local D = {}
function D.resize(width, height)
    local world, offset = lstg.world, lstg.worldoffset
    local savedOffset = {}
    for key, value in pairs(offset or {}) do savedOffset[key] = value end
    for _, value in ipairs({setting,cur_setting,default_setting}) do
        value.resx, value.resy = width, height
    end
    ResetScreen()
    if world then
        lstg.world = world
        SetBound(world.boundl,world.boundr,world.boundb,world.boundt)
    end
    if offset then
        for key in pairs(offset) do offset[key]=nil end
        for key, value in pairs(savedOffset) do offset[key]=value end
        lstg.worldoffset = offset
    end
    if AndroidInput then AndroidInput.reset(true) end
    if AndroidPauseCache then AndroidPauseCache.invalidate() end
end
return D
