-- 0x0c0aac50：0x32 击破产生四份碎片、二十份爆炸及 Original 金块，普通击破为 4800 分。
-- 参数由原版指令离线展开；碰撞在粒子队列之后，所有爆炸从下一逻辑步才启动。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/midboss1_effect_data.lua')
local fragments=dofile('mod/GAME/th46/fragments.lua')(data.debris)
local gold=dofile('mod/GAME/th46/gold.lua')
local emitDeath=dofile('mod/GAME/th46/longfly_death_data.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,min=math.floor,math.min
local texture,capacity='th46_midboss1_effects',128

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.run.longflyEffects[o]=nil
    o.run.longflyEffectCount=o.run.longflyEffectCount-1
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
        o.run.longflyEffects[o]=true
        o.run.longflyEffectCount=o.run.longflyEffectCount+1
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
        SetImageState(image,math.floor(o.flags/2)%2==1 and 'mul+add' or '',o.alpha,255,255,255)
        Render(image,floor(o.boardX/unit)-120+frame[2],floor(o.boardY/unit)-160+frame[3])
    end,
})

return {
    open=function(run) run.longflyEffects,run.longflyEffectCount={},0 end,
    defeat=function(o,flags)
        flags=flags or 0
        if floor(flags/0x400)%2==0 then
            -- 本类走 0x0c0765b0；0x20 事件取十分之一，与 0x31 的四十分之一不同。
            local points=floor(flags/0x20)%2==1 and 480 or 4800
            lstg.var.score=min(0xee6b27ff,lstg.var.score+points)
        end
        emitDeath(o.raw,function(kind,x,y,depth,speed,angle,wait,flags,alpha)
            local drop=gold.choose(o.player.laser)
            if o.run.longflyEffectCount<capacity then
                local particle=New(Particle,o,0,0,kind,speed,angle,wait,flags,alpha,depth-130,drop)
                particle.boardX,particle.boardY=x,y
            end
        end,function(kind,x,y,depth)
            fragments.emit(o.run,x,y,kind,nil,true,LAYER.ENEMY+depth-130)
        end,function(high)return ran:Int(0,high)end)
        if not o.player.laser then gold.emit(o.run,o.boardX,o.boardY,0) end
    end,
    close=function(run)
        for o in pairs(run.longflyEffects or {}) do remove(o) end
        run.longflyEffects,run.longflyEffectCount=nil,0
        fragments.close(run)
    end,
}
