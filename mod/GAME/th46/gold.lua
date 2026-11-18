-- Original 模式金块：0x0c094030 / 0x0c094130 初始化，0x0c094590 / 0x0c0948b0 更新。
-- 保留 16.16 位移、48 步空中奖励、168 像素吸附和拾取后的计数浮字。只挂载已还原的掉落入口。
-- 差异 1：初速、初相和掉落分支使用 LuaSTG 录像随机数；原版共用随机序列尚未接入。
-- 差异 2：原版颜色加算用 LuaSTG 混色近似；其余尚未移植的敌机不会贡献原版金块计数。
local direction = dofile('mod/GAME/th46/direction.lua')
local unit, vector, heading = direction.unit, direction.vector, direction.heading
local floor, min, max, abs = math.floor, math.min, math.max, math.abs
local texture = 'th46_gold'
local capacity, airSteps, seekDistance = 1024, 48, 168*unit
local limits = {[0]=88, [1]=84}

local function place(o)
    o.x,o.y=floor(o.boardX/unit)-120,floor(o.boardY/unit)-160
end

local function remove(o)
    if o.closed then return end
    o.closed=true
    o.run.roadGold[o]=nil
    o.run.goldCount=o.run.goldCount-1
    o.hide,o.colli=true,false
    object.RawDel(o)
end

local function resetSpeed(o)
    o.speed,o.angle=3+ran:Int(0,30),224+ran:Int(0,63)
    o.boardVX,o.boardVY=vector(o.speed,o.angle)
end

local function overlaps(o,p)
    local position=p.pilotPosition
    return abs(floor(position.x/unit)-floor(o.boardX/unit))<=o.radius+2
        and abs(floor(position.y/unit)-1-floor(o.boardY/unit))<=o.radius+2
end

local function collect(o,p)
    if o.ground and not o.initialized then return end
    if not o.colli or p.run~=o.run or p.respawn~=0 or not overlaps(o,p) then return end
    local run=o.run
    -- 0x0c06afb0 的空中小/大金块加 2/4，落地加 1/2；先更新计数，再以本面计数加分。
    local air=o.air>0
    local increment=(o.kind+1)*(air and 2 or 1)
    run.goldStage=min(9999,(run.goldStage or 0)+increment)
    run.goldTotal=min(99999,(run.goldTotal or 0)+increment)
    local points=run.goldStage*(air and 2 or 1)
    lstg.var.score=min(0xee6b27ff,lstg.var.score+points)
    o.points,o.popup,o.colli=points,true,false
    if o.ground then o.layer=LAYER.ITEM end
    o.popupX,o.popupY,o.shown,o.target=o.boardX,o.boardY,0,run.goldTotal
    o.drawX,o.drawY,o.drawAlpha=o.popupX,o.popupY,255
    o.popupVX,o.popupVY=vector(24,heading(o.popupX,o.popupY,8*unit,262*unit))
    o.alpha,o.serial=255,run.serial
end

local function advancePopup(o)
    -- 0x0c0957a0 每次追上剩余计数的三分之一加一；到达后每步减 16，不能直接删除金块。
    if o.alpha==0 then remove(o); return end
    if o.shown<o.target then o.shown=min(o.target,o.shown+floor((o.target-o.shown)/3)+1) end
    o.drawX,o.drawY,o.drawAlpha=o.popupX,o.popupY,o.alpha
    o.popupX,o.popupY=o.popupX+o.popupVX,o.popupY+o.popupVY
    if o.shown==o.target then
        o.alpha=max(0,o.alpha-16)
        if o.alpha==0 then remove(o) end
    end
end

local function advance(o)
    if o.popup then advancePopup(o); return end
    local run,p=o.run,o.run.roadClock.player
    if o.motion==0 then
        o.boardX=o.boardX+run.roadCameraDelta
        o.boardY=o.boardY+3*unit
        if o.speed<limits[o.kind] then
            o.speed=min(limits[o.kind],o.speed+2)
            o.boardVX,o.boardVY=vector(o.speed,o.angle)
        end
        o.air=max(0,o.air-1)
        o.boardY=o.boardY+o.boardVY
        if o.speed<=47 then o.boardX=o.boardX+o.boardVX end
        -- 第 55 步结束时全局计数为 1262；道具读取递增前的 1261，每八步只搜索一次自机。
        if o.speed>80 and (run.roadFrame+6)%8==0 and p.respawn==0 and not p.laser then
            local dx,dy=abs(p.pilotPosition.x-o.boardX),abs(p.pilotPosition.y-o.boardY)
            if max(dx,dy)+floor(min(dx,dy)/2)<=seekDistance then
                o.motion,o.interval,o.tint=1,0,o.kind==0 and 80 or 112
            end
        end
    elseif p.respawn~=0 then
        -- 0x0c0947d0 受击时切回自由运动，本步只推进动画。
        o.motion=0
        resetSpeed(o)
    else
        -- 吸附分支只在加速前比较上限，奇数初速可停在 89 / 85；自由运动才作钳制。
        if o.speed<limits[o.kind] then o.speed=o.speed+2 end
        o.angle=heading(o.boardX,o.boardY,p.pilotPosition.x,p.pilotPosition.y)
        o.boardVX,o.boardVY=vector(o.speed,o.angle)
        o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
    end
    o.clock=o.clock-1
    if o.clock<0 then o.phase,o.clock=(o.phase+1)%16,o.interval end
    place(o)
    -- 0x0c093ba4 只回收已经进入过边界的出界道具；场外出生的最多等待 180 步。
    local x=o.boardX+(run.roadCamera or 0)*unit
    local inside=x>-72*unit and x<312*unit and o.boardY>-32*unit and o.boardY<352*unit
    if inside then o.entered=true
    else
        o.outside=o.outside+1
        if o.entered or o.outside>179 then remove(o) end
    end
end

-- 地面大金块走 0x0c0942d0 / 0x0c094ef0：不作空中抛射，每步读取所属背景层的整数位移。
local function advanceGround(o)
    if o.popup then advancePopup(o);return end
    local run,p=o.run,o.run.roadClock.player
    if not o.initialized then
        o.phase=ran:Int(0,15)
        if o.kind==1 then o.shakeClock=ran:Int(0,6)end
        o.initialized=true;return
    end
    if o.motion==0 then
        o.boardX=o.boardX+run.roadCameraDelta
        o.glow=max(0,o.glow-1)
        local dx,dy=abs(p.pilotPosition.x-o.boardX),abs(p.pilotPosition.y-o.boardY)
        local distance=max(dx,dy)+floor(min(dx,dy)/2)
        if p.respawn~=0 then distance=320*unit elseif p.laser then distance=24*unit end
        if p.respawn==0 and distance<=(o.kind==0 and 48 or 64)*unit then
            o.speed,o.motion,o.interval,o.tint=72,1,0,0
            o.layer=LAYER.ENEMY+40
        elseif distance>(o.kind==0 and 96 or 112)*unit then
            o.tint=max(0,o.tint-1)
            if o.kind==0 then o.interval=1 end
        else
            if o.kind==0 then
                o.interval=0
                o.shakeX,o.shakeY=(ran:Int(0,1)-1)*unit,(ran:Int(0,1)-1)*unit
            else
                o.shakeClock=o.shakeClock-1
                if o.shakeClock<0 then
                    o.shakeClock=7;o.shakeX,o.shakeY=(ran:Int(0,3)-2)*unit,(ran:Int(0,3)-2)*unit
                end
            end
            o.tint=min(128,o.tint+2)
        end
    elseif p.respawn~=0 then o.motion,o.speed=0,0
    else
        o.angle=heading(o.boardX,o.boardY,p.pilotPosition.x,p.pilotPosition.y)
        local x,y=vector(o.speed,o.angle);o.boardX,o.boardY=o.boardX+x,o.boardY+y
    end
    o.boardY=o.boardY-(run.roadGroundDelta or 0)
    o.clock=o.clock-1
    if o.clock<0 then o.phase,o.clock=(o.phase+1)%16,o.interval end
    place(o)
    local x=o.boardX+(run.roadCamera or 0)*unit
    local inside=x>-72*unit and x<312*unit and o.boardY>-32*unit and o.boardY<352*unit
    if inside then o.entered=true
    else o.outside=o.outside+1;if o.entered or o.outside>179 then remove(o) end end
end

local Gold=Class(object,{
    init=function(o,run,x,y,kind,ground)
        o.run,o.group,o.layer,o.bound=run,GROUP.ITEM,LAYER.ITEM,false
        -- 街机练习禁用东方通用掉落；标记原生道具，避免 item.lua 的 New 包装器将其回收。
        o.native_pickup=true
        o.boardX,o.boardY,o.kind,o.serial=x,y,kind,run.serial
        o.birthFrame,o.motion,o.air,o.alpha=run.roadFrame,0,airSteps,255
        o.radius=kind==0 and 10 or 20
        o.a,o.b,o.rect,o.colli=o.radius+1,o.radius+2,true,true
        o.ground,o.initialized=ground,not ground
        if ground then
            o.layer=LAYER.ENEMY-1
            o.radius=kind==0 and 16 or 24;o.a,o.b=o.radius+1,o.radius+2
            o.air,o.phase,o.clock,o.interval,o.tint,o.glow=0,0,1,1,96,80
            o.shakeX,o.shakeY,o.shakeClock=0,0,0
            o.entered,o.outside,o.popup,o.closed=false,0,false,false
            run.roadGold[o]=true;run.goldCount=run.goldCount+1;place(o);return
        end
        resetSpeed(o)
        o.phase,o.clock,o.interval=ran:Int(0,15),kind,kind
        o.tint,o.entered,o.outside=kind==0 and 64 or 80,false,0
        o.popup,o.closed=false,false
        run.roadGold[o]=true
        run.goldCount=run.goldCount+1
        place(o)
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        if o.ground then advanceGround(o)else advance(o)end
    end,
    colli=collect,
    render=function(o)
        if o.ground and not o.initialized then return end
        if o.ground and not o.popup then
            local image=o.kind==0 and 'th46_worm_death_'..o.phase or 'th46_groundbug_'..(105+o.phase)
            local tint=min(255,floor(o.tint/128*255))
            SetImageState(image,'',255,o.motion==1 and 80 or tint,o.motion==1 and 255 or tint,o.motion==1 and 80 or tint)
            Render(image,floor((o.boardX+o.shakeX)/unit)-120,floor((o.boardY+o.shakeY)/unit)-160)
            if o.glow>0 and o.motion==1 then
                local glow=o.kind==0 and 'th46_worm_death_16' or 'th46_groundbug_121'
                SetImageState(glow,'mul+add',112,40,128,40)
                Render(glow,o.x,o.y)
            end
            return
        end
        if o.popup then
            if o.shown==0 then return end
            local value=tostring(o.shown)
            local x,y=floor(o.drawX/unit)-120,floor(o.drawY/unit)-160
            local r,b=floor(o.drawAlpha/2),floor(o.drawAlpha/3)+80
            for i=1,#value do
                local image=texture..'_'..(32+tonumber(value:sub(i,i)))
                SetImageState(image,'mul+add',o.drawAlpha,r,b,r)
                Render(image,x+(i-1)*12,y)
            end
        else
            if o.motion==1 and o.air>0 then
                SetImageState(texture..'_42','mul+add',112,40,128,40)
                Render(texture..'_42',o.x,o.y)
            end
            local image=texture..'_'..(o.kind*16+o.phase)
            -- EP1C12 颜色系数以 64 为一倍；额外亮度叠一次加算，避免把金块画成四分之一亮度。
            SetImageState(image,'',255,255,255,255)
            Render(image,o.x,o.y)
            local extra=max(0,o.tint-64)*4
            local green=extra+(o.motion==0 and o.air*4 or 0)
            if green>0 then
                SetImageState(image,'mul+add',255,extra,green,extra)
                Render(image,o.x,o.y)
            end
        end
    end,
})

return {
    open=function()
        if CheckRes('img',texture..'_0') then return end
        LoadTexture(texture,'Resources/th46/stage1/gold.png')
        SetTextureSamplerState(texture,'point+clamp')
        for slot=0,42 do LoadImage(texture..'_'..slot,texture,slot%8*64,floor(slot/8)*64,64,64) end
    end,
    emit=function(run,x,y,kind)
        run.roadGold,run.goldCount=run.roadGold or {},run.goldCount or 0
        if run.goldCount>=capacity then return end
        return New(Gold,run,x,y,kind)
    end,
    emitGround=function(run,x,y,kind)
        run.roadGold,run.goldCount=run.roadGold or {},run.goldCount or 0
        if run.goldCount>=capacity then return end
        return New(Gold,run,x,y,kind==0 and 0 or 1,true)
    end,
    choose=function(laser)
        -- 0x0c096a12：低速击破必掉一枚随机大小；普通击破二分之一概率掉大金块。
        local choice=ran:Int(0,1)
        if laser then return choice end
        if choice==0 then return 1 end
    end,
    close=function(run)
        for o in pairs(run.roadGold or {}) do if IsValid(o) then remove(o) end end
        run.roadGold,run.goldCount=nil,0
    end,
}
