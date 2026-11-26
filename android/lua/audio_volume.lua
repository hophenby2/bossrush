-- Sub 的总音量会立即作用于已播放资源；LuaSTG-x 原接口只影响下一次 Play。
-- 保留每个资源的曲目/淡入音量，再与总音量相乘，避免淡入覆盖设置或反复重播。
return function(native,expose)
    -- 按逻辑名保存音量，不持有资源句柄；缓存卸载仍可释放资源，Lua userdata 被 GC 也不会丢设置。
    local music,sounds={},{}
    local bgmFactor,seFactor=1,1
    native.SetBGMVolume(1);native.SetSEVolume(1)
    local function apply(rows,factor,find)
        for name,volume in pairs(rows) do
            local resource=find(name)
            if resource then resource:getSource():setVolume(volume*factor) else rows[name]=nil end
        end
    end
    expose('PlayMusic',function(name,volume,position)
        local resource=assert(FindResMusic(name),name)
        volume=volume or 1;music[name]=volume
        return native.PlayMusic(name,volume*bgmFactor,position)
    end)
    expose('PlaySound',function(name,volume,pan)
        local resource=assert(FindResSound(name),name)
        volume=volume or 1;sounds[name]=volume
        return native.PlaySound(name,volume*seFactor,pan)
    end)
    expose('SetBGMVolume',function(name,volume)
        if volume==nil then
            if bgmFactor==name then return end
            bgmFactor=name;apply(music,bgmFactor,FindResMusic)
        else
            local resource=assert(FindResMusic(name),name);music[name]=volume
            resource:getSource():setVolume(volume*bgmFactor)
        end
    end)
    local function setSound(name,volume)
        if volume==nil then
            if seFactor==name then return end
            seFactor=name;apply(sounds,seFactor,FindResSound)
        else
            local resource=assert(FindResSound(name),name);sounds[name]=volume
            resource:getSource():setVolume(volume*seFactor)
        end
    end
    expose('SetSEVolume',setSound)
    expose('SetSourceSoundVolume',setSound)
end
