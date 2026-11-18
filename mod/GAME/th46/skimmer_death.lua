-- 0x0c0a87d0：0x31 击破产生八份碎片、六份独立爆炸和 Original 金块；普通击破为 1800 分。
-- 碰撞晚于粒子队列，六份爆炸均从下一逻辑步起计算原版的 6 / 3 / 0 步等待。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/midboss1_effect_data.lua')
local fragments=dofile('mod/GAME/th46/fragments.lua')(data.debris)
local gold=dofile('mod/GAME/th46/gold.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,min=math.floor,math.min
local texture,capacity='th46_midboss1_effects',128

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.run.skimmerEffects[o]=nil
    o.run.skimmerEffectCount=o.run.skimmerEffectCount-1
    object.RawDel(o)
end

local Particle=Class(object,{
    init=function(o,host,dx,dy,kind,speed,angle,wait,flags,alpha,depth,drop)
        o.run,o.serial,o.birthFrame=host.run,host.run.serial,host.run.roadFrame
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY+depth,false,false
        o.boardX,o.boardY=host.boardX+dx*unit,host.boardY+dy*unit
        -- 0x0c096930 设置标志：bit 3 从首格起播，否则从第 4 格起播；不是画格编号。
        o.kind,o.animation,o.flags,o.index=kind,data[kind],flags,floor(flags/8)%2==1 and 1 or 4
        o.boardVX,o.boardVY=vector(speed,angle)
        o.wait,o.clock,o.alpha,o.drop=wait,0,alpha,drop
        o.visible,o.closed=false,false
        o.run.skimmerEffects[o]=true
        o.run.skimmerEffectCount=o.run.skimmerEffectCount+1
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        o.boardX=o.boardX+o.run.roadCameraDelta
        if not o.visible then
            o.wait=o.wait-1
            if o.wait>=0 then return end
            o.visible=true
            if o.drop~=nil then gold.emit(o.run,o.boardX+(ran:Int(0,16)-8)*unit,o.boardY+(ran:Int(0,16)-8)*unit,o.drop) end
            o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
        else
            -- 原队列先积分再检查最后一格；回收这一步也会留下最终位置。
            o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
            o.clock=o.clock-1
            if o.clock<0 then
                o.index=o.index+1
                local frame=o.animation.frames[o.index]
                if not frame then remove(o);return end
                o.clock=frame[1]
            end
        end
    end,
    render=function(o)
        if not o.visible then return end
        local frame=o.animation.frames[o.index]
        local image=texture..'_'..(o.animation.first+o.index-1)
        SetImageState(image,'mul+add',o.alpha,255,255,255)
        Render(image,floor(o.boardX/unit)-120+frame[2],floor(o.boardY/unit)-160+frame[3])
    end,
})

return {
    open=function(run) run.skimmerEffects,run.skimmerEffectCount={},0 end,
    defeat=function(o,flags)
        flags=flags or 0
        if floor(flags/0x400)%2==0 then
            local points=floor(flags/0x20)%2==1 and 45 or 1800
            lstg.var.score=min(0xee6b27ff,lstg.var.score+points)
        end
        for _=1,2 do
            for _=1,2 do fragments.emit(o.run,o.boardX,o.boardY,ran:Int(0,1),nil,true,LAYER.ENEMY+1) end
            for _=1,2 do fragments.emit(o.run,o.boardX,o.boardY,0,nil,true,LAYER.ENEMY+1) end
        end
        local function emit(dx,dy,kind,speed,angle,wait,flags,alpha,depth)
            local drop=gold.choose(o.player.laser)
            if o.run.skimmerEffectCount<capacity then New(Particle,o,dx,dy,kind,speed,angle,wait,flags,alpha,depth,drop) end
        end
        emit(16,-20,4,6,ran:Int(0,31)-16,6,10,192,2)
        emit(-16,-18,5,6,ran:Int(0,31)-16,6,2,192,2)
        emit(18,-44,5,6,ran:Int(0,31)-16,3,10,176,1)
        emit(32,-4,2,5,96,3,2,160,1)
        emit(-32,-32,2,3,432,0,2,128,1)
        emit(0,-8,6,0,0,0,10,192,0)
        if not o.player.laser then gold.emit(o.run,o.boardX,o.boardY,0) end
    end,
    close=function(run)
        for o in pairs(run.skimmerEffects or {}) do remove(o) end
        run.skimmerEffects,run.skimmerEffectCount=nil,0
        fragments.close(run)
    end,
}
