-- LuaJIT 的弱键表不能释放“值反向持有键”的环；代理仍需在对象存活时保持身份和状态。
-- 分帧清理仅删除引擎已释放的对象，不改变对象、代理或攻击效果本身的生命周期。
return function(valid,budget)
    local cache=setmetatable({},{__mode='k'})
    local cursor
    local function prune()
        for _=1,budget or 128 do
            local key=next(cache,cursor)
            if key==nil then cursor=nil;return end
            if not valid(key) then cache[key]=nil
            else cursor=key end
        end
    end
    local function clear()
        for key in pairs(cache) do cache[key]=nil end
        cursor=nil
    end
    return cache,prune,clear
end
