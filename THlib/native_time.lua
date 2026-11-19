-- Unity Time.timeScale：按真实宿主帧累积整个游戏的逻辑预算。
-- 统一缓速自机、射击、弹幕、碰撞及符卡计时；渲染、音乐和暂停菜单继续运行。
local T={scale=1,budget=0}
function T.set(owner,scale)
    T.owner=owner;T.scale=math.max(.01,scale)
end
function T.reset(owner)
    if owner and T.owner~=owner then return end
    T.owner,T.scale,T.budget=nil,1,0
end
function T.allowFrame()
    if not T.owner or T.owner.closed then T.reset();return true end
    T.budget=T.budget+T.scale
    if T.budget<1-1e-9 then return false end
    T.budget=T.budget-1
    return true
end
NativeTime=T
return T
