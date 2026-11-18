-- 0x0c0acc70 / 0x0c0ace50：蜈蚣 HP 降到零后仍随背景移动，五段演出完成才解除道中禁入。
-- 计时取原程序的减到负数语义：29 次随机爆炸、两批定点爆炸、末段碎片及 5 大 / 10 小地面金块。
-- 差异 1：随机分支仍用 LuaSTG 录像随机数；原版各对象共用的随机队列尚未接入。
-- 差异 2：原版声音、末段画面抖动和与其他敌机共用的粒子池占用尚未接入。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/worm_death_data.lua')
local effects=dofile('mod/GAME/th46/midboss1_effect_data.lua')
local fragments=dofile('mod/GAME/th46/fragments.lua')(effects.debris)
local gold=dofile('mod/GAME/th46/gold.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,min,max=math.floor,math.min,math.max
local texture='th46_worm_death'
local function signed(n)return(n+2147483648)%4294967296-2147483648 end

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true;o.run.wormEffects[o]=nil
    o.run.wormEffectCount=o.run.wormEffectCount-1;object.RawDel(o)
end

local Particle=Class(object,{
    init=function(o,host,x,y,kind,speed,angle,wait,flags,alpha,depth,flip,drop)
        o.run,o.serial,o.birthFrame=host.run,host.run.serial-1,host.run.roadFrame
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY+depth,false,false
        o.boardX,o.boardY,o.kind=x,y,kind
        o.animation,o.index,o.flags=effects[kind],floor(flags/8)%2==1 and 1 or 4,flags
        o.boardVX,o.boardVY=vector(speed,angle)
        o.wait,o.clock,o.alpha,o.drop=wait,0,alpha,drop
        o.flip,o.flipY=flip%2==1 and -1 or 1,floor(flip/2)%2==1 and -1 or 1
        o.visible,o.closed=false,false
        o.run.wormEffects[o]=true;o.run.wormEffectCount=o.run.wormEffectCount+1
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        -- 掉落入口读取积分前的位置；等待期间也跟随第二背景层。
        if not o.visible and o.wait==0 and o.drop~=nil then
            gold.emit(o.run,o.boardX+(ran:Int(0,16)-8)*unit,o.boardY+(ran:Int(0,16)-8)*unit,o.drop)
        end
        o.boardX=o.boardX+o.run.roadCameraDelta
        o.boardY=o.boardY-(o.run.roadGroundDelta or 0)
        if not o.visible then
            o.wait=o.wait-1
            if o.wait>=0 then return end
            o.visible=true;o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
        else
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
        local image='th46_midboss1_effects_'..(o.animation.first+o.index-1)
        SetImageState(image,floor(o.flags/2)%2==1 and 'mul+add' or '',o.alpha,255,255,255)
        Render(image,floor(o.boardX/unit)-120+frame[2]*o.flip,floor(o.boardY/unit)-160+frame[3]*o.flipY,0,o.flip,o.flipY)
    end,
})

local Corpse=Class(object,{
    init=function(o,host,x,y,kind)
        o.run,o.serial=host.run,host.run.serial-1
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY-2,false,false
        o.boardX,o.boardY,o.kind=x,y,kind
        o.phase,o.variant=ran:Int(0,3),ran:Int(0,0)
        o.clock,o.alpha,o.frozen,o.closed=0,255,false,false
        o.run.wormCorpses[o]=true
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        o.boardX=o.boardX+o.run.roadCameraDelta;o.boardY=o.boardY-(o.run.roadGroundDelta or 0)
        if not o.frozen then
            o.clock=o.clock-1
            if o.clock<0 then o.clock,o.phase=2,(o.phase+1)%4 end
        end
        if o.alpha>72 then o.alpha=o.alpha-1;if o.alpha==72 then o.frozen=true end end
        if o.boardX<-48*unit or o.boardX>288*unit or o.boardY<-48*unit or o.boardY>368*unit then
            o.closed,o.hide=true,true;o.run.wormCorpses[o]=nil;object.RawDel(o)
        end
    end,
    render=function(o)
        local image=texture..'_'..(17+(o.kind-2)*4+o.phase)
        local c=floor(min(128,o.alpha)*255/128)
        SetImageState(image,'',255,c,c,c)
        Render(image,floor(o.boardX/unit)-120,floor(o.boardY/unit)-160)
    end,
})

local function emit(host,x,y,kind,speed,angle,wait,flags,alpha,depth,flip,drop)
    if host.run.wormEffectCount>=128 then return end
    return New(Particle,host,x,y,kind,speed,angle,wait,flags,alpha,depth,flip,drop)
end

local function rows(host,table,alpha,drops,parts)
    local depth=parts and 0 or 1
    for _,r in ipairs(table) do
        local x,y=host.baseX+signed(r[3]),host.baseY+signed(r[4])
        local drop;if drops then drop=gold.choose(host.laserDefeat)end
        emit(host,x,y,r[1],r[5],signed(r[6]),r[7],r[2]%65536,alpha,depth,r[10] or 0,drop)
        if parts then
            for i=1,r[9] do
                local fragment=fragments.emit(host.run,x,y,r[8],nil,true,LAYER.ENEMY+depth)
                if fragment then fragment.serial=host.run.serial-1 end
            end
        end
    end
end

local function tint(o)
    o.deathFade=min(255,o.deathFade+6)
    o.deathTone=128+floor(o.deathFade/2)
end

local function corpse(o,x,y,kind)
    -- 0x0c09b5d0 在全部残骸中查 48 像素近似距离，近邻拒绝分配，不能无条件造五份。
    local count=0
    for _,pool in ipairs({o.run.wormCorpses or {},o.run.groundCorpses or {}})do
        for c in pairs(pool)do
            if not c.closed then
                count=count+1
                local dx,dy=math.abs(x-c.boardX),math.abs(y-c.boardY)
                if max(dx,dy)+floor(min(dx,dy)/2)<=48*unit then return end
            end
        end
    end
    if count<128 then New(Corpse,o,x,y,kind)end
end

local function ground(o,x,y,kind)
    local item=gold.emitGround(o.run,x,y,kind)
    -- 本回调早于道具池，和晚于道具池的普通地面敌机击破相差一个初始化步。
    if item then item.serial=o.run.serial-1 end
end

return {
    open=function()
        if CheckRes('img',texture..'_0')then return end
        LoadTexture(texture,'Resources/th46/stage1/worm_death.png');SetTextureSamplerState(texture,'point+clamp')
        for slot=0,24 do LoadImage(texture..'_'..slot,texture,slot%8*128,floor(slot/8)*128,128,128)end
    end,
    begin=function(o,flags)
        o.run.wormEffects,o.run.wormEffectCount,o.run.wormCorpses=o.run.wormEffects or {},o.run.wormEffectCount or 0,o.run.wormCorpses or {}
        o.deathPhase,o.deathFade,o.deathTone=1,0,128
        o.laserDefeat=o.player and o.player.laser or false
        -- 0x0c06d6a0 当步清场，随后 96 步在敌弹池更新前把新增弹也切到消弹动画。
        o.run.wormClearUntil=o.run.roadFrame+96
        if o.run.wormClearShots then o.run.wormClearShots()end
        flags=flags or 0
        if floor(flags/0x400)%2==0 then
            lstg.var.score=min(0xee6b27ff,lstg.var.score+(floor(flags/0x20)%2==1 and 820 or 8200))
        end
    end,
    step=function(o)
        o.deathTone=128
        if o.deathPhase==1 then
            o.deathPhase,o.soundClock,o.soundInterval=2,4,8
            o.burstClock,o.burstInterval,o.burstCount=0,2,28
            rows(o,data.first,192,true,false)
        end
        if o.deathPhase==2 then
            tint(o);o.soundClock=o.soundClock-1
            if o.soundClock<0 then o.soundClock=o.soundInterval;ran:Int(0,1)end
            o.burstClock=o.burstClock-1
            if o.burstClock<0 then
                o.burstClock=o.burstInterval
                local at=data.points[ran:Int(0,255)%16+1]
                local x=o.baseX+(at[1]*8+ran:Int(0,54)-27)*unit
                local y=o.baseY+(at[2]*8+ran:Int(0,16)*2-32)*unit
                local odd=o.burstCount%2==1
                local r=(odd and data.odd or data.even)[ran:Int(0,255)%8+1]
                local speed,angle=8+ran:Int(0,12),ran:Int(0,20)-10
                local flip=ran:Int(0,1)
                emit(o,x,y,r[1],speed,angle,odd and 0 or 2,r[2],odd and 192 or 112,odd and 2 or 3,flip,gold.choose(o.laserDefeat))
                for i=1,2 do
                    local f=fragments.emit(o.run,x,y,0,nil,true,LAYER.ENEMY+1)
                    if f then f.serial=o.run.serial-1 end
                end
                o.burstCount=o.burstCount-1
                if o.burstCount<0 then o.deathPhase,o.deathWait=3,22 end
            end
        elseif o.deathPhase==3 then
            if o.deathWait>0 then o.deathWait=max(0,o.deathWait-1)
            else tint(o);rows(o,data.second,192,true,false);o.deathWait,o.deathPhase=8,4 end
        elseif o.deathPhase==4 then
            tint(o);o.deathWait=o.deathWait-1
            if o.deathWait<0 then
                rows(o,data.last,255,false,true);rows(o,data.smoke,96,false,true)
                o.deathWait,o.deathPhase=4,5
            end
        elseif o.deathPhase==5 then
            o.deathWait=o.deathWait-1
            if o.deathWait<0 then
                o.deathPhase=6
                for _,at in ipairs({{32,16,2},{-32,8,3},{0,-56,3},{-48,-40,3},{40,-24,3}})do
                    corpse(o,o.baseX+at[1]*unit,o.baseY+at[2]*unit,at[3])
                end
                for _,at in ipairs({{0,0},{-19,19},{-19,-19},{19,19},{19,-19}})do ground(o,o.baseX+at[1]*unit,o.baseY+at[2]*unit)end
                for i=1,10 do ground(o,o.baseX+(ran:Int(0,63)-32)*unit,o.baseY+(ran:Int(0,63)-32)*unit,0)end
            end
        end
    end,
    close=function(run)
        for o in pairs(run.wormEffects or {})do remove(o)end
        for o in pairs(run.wormCorpses or {})do o.closed,o.hide=true,true;object.RawDel(o)end
        run.wormEffects,run.wormEffectCount,run.wormCorpses=nil,0,nil
    end,
}
