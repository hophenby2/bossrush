-- 0x0c0a7100：地面敌机击破产生六份碎片、十一份爆炸、残骸及五枚地面大金块，普通计分 2600。
-- 参数由原版指令离线展开；碰撞在粒子队列之后，所有爆炸从下一逻辑步才启动。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/midboss1_effect_data.lua')
local fragments=dofile('mod/GAME/th46/fragments.lua')(data.debris)
local gold=dofile('mod/GAME/th46/gold.lua')
local deathRows=dofile('mod/GAME/th46/groundbug_data.lua').death
local function signed(n)return(n+2147483648)%4294967296-2147483648 end
local object,unit,vector=object,direction.unit,direction.vector
local floor,min=math.floor,math.min
local texture,capacity='th46_midboss1_effects',128

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.run.groundEffects[o]=nil
    o.run.groundEffectCount=o.run.groundEffectCount-1
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
        o.run.groundEffects[o]=true
        o.run.groundEffectCount=o.run.groundEffectCount+1
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        o.boardX=o.boardX+o.run.roadCameraDelta
        o.boardY=o.boardY-o.run.roadGroundDelta
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
        Render(image,floor(o.boardX/unit)-120+frame[2]*(o.flip or 1),floor(o.boardY/unit)-160+frame[3],0,o.flip or 1,1)
    end,
})

local Corpse=Class(object,{
    init=function(o,host)
        o.run,o.serial=host.run,host.run.serial
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY-1,false,false
        o.boardX,o.boardY=host.boardX,host.boardY
        o.phase,o.variant=ran:Int(0,3),ran:Int(0,0)
        o.clock,o.alpha,o.frozen,o.closed,o.visible=0,255,false,false,false
        o.run.groundCorpses[o]=true
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial;o.visible=true
        o.boardX=o.boardX+o.run.roadCameraDelta;o.boardY=o.boardY-o.run.roadGroundDelta
        if not o.frozen then
            o.clock=o.clock-1
            if o.clock<0 then o.clock,o.phase=2,(o.phase+1)%4 end
        end
        if o.alpha>72 then o.alpha=o.alpha-1;if o.alpha==72 then o.frozen=true end end
        if o.boardX<-48*unit or o.boardX>288*unit or o.boardY<-48*unit or o.boardY>368*unit then
            o.closed,o.hide=true,true;o.run.groundCorpses[o]=nil;object.RawDel(o)
        end
    end,
    render=function(o)
        if not o.visible then return end
        local image='th46_groundbug_'..(122+o.phase)
        local c=math.floor(min(128,o.alpha)*255/128)
        SetImageState(image,'',255,c,c,c)
        Render(image,floor(o.boardX/unit)-120,floor(o.boardY/unit)-160)
    end,
})
return {
    open=function(run)run.groundEffects,run.groundEffectCount,run.groundCorpses={},0,{} end,
    defeat=function(o,flags)
        flags=flags or 0
        if floor(flags/0x400)%2==0 then
            local points=floor(flags/0x20)%2==1 and 260 or 2600
            lstg.var.score=min(0xee6b27ff,lstg.var.score+points)
        end
        for i=1,6 do fragments.emit(o.run,o.boardX,o.boardY,0,nil,true,LAYER.ENEMY+1) end
        for _,row in ipairs(deathRows) do
            local drop=gold.choose(o.player.laser)
            if o.run.groundEffectCount<capacity then
                local particle=New(Particle,o,signed(row[3])/unit,signed(row[4])/unit,row[1],row[5],row[6],row[7],row[2],192,1,drop)
                particle.flip=row[10]==1 and -1 or 1
            end
        end
        New(Corpse,o)
        for _,at in ipairs({{0,0},{-19,19},{-19,-19},{19,19},{19,-19}}) do
            gold.emitGround(o.run,o.boardX+at[1]*unit,o.boardY+at[2]*unit)
        end
    end,
    close=function(run)
        for o in pairs(run.groundEffects or {}) do remove(o) end
        for o in pairs(run.groundCorpses or {}) do o.closed,o.hide=true,true;object.RawDel(o) end
        run.groundEffects,run.groundEffectCount,run.groundCorpses=nil,0,nil
    end,
}
