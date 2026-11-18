-- 0x0c0992c0 分配的 128 槽碎片池。0 / 1 类走抛物线，24 类沿破损处方向减速。
-- 0x0c099520 / 0x0c0998b0 先等待再每步减 8 透明度，离场由原回调的透明度倒数决定。
local direction=dofile('mod/GAME/th46/direction.lua')
local vector=direction.vector
local floor,trunc=math.floor,math.modf
local capacity=128
local texture='th46_midboss1_effects'

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.run.roadFragments[o]=nil
    o.run.fragmentCount=o.run.fragmentCount-1
    object.RawDel(o)
end

local function initialize(o)
    o.phase=ran:Int(0,#o.bank.frames-1)
    if o.kind==24 then
        o.angle=(o.angle or 0)+trunc((ran:Int(0,14)-7)/4)
        o.speed=52+ran:Int(0,15)+2*ran:Int(0,15)
        o.fadeDelay=floor(o.speed/2)+32
    else
        o.angle=8*ran:Int(0,42)-168
        o.speed=52+2*ran:Int(0,15)
        o.fadeDelay=20+4*ran:Int(0,15)
    end
    o.speedClock,o.alpha,o.flipY=1,255,o.angle>255 and -1 or 1
    o.initialized=true
end

local function update(o)
    o.boardX=o.boardX+o.run.roadCameraDelta
    o.speedClock=o.speedClock-1
    local minimum=o.kind==24 and 0 or 10
    if o.speedClock<0 and o.speed>minimum then
        o.speedClock=o.speed>16 and 1 or 3
        o.speed=o.speed-2
        if o.speed<0 then o.speed=0 end
    end
    if o.fadeDelay>0 then
        o.fadeDelay=o.fadeDelay-1
    else
        o.alpha=o.alpha-8
        if o.alpha<0 then remove(o); return end
    end
    local vx,vy=vector(o.speed,o.angle)
    if o.kind==24 then
        o.boardX=o.boardX+vx
        o.boardY=o.boardY+vy-0x8000
    else
        -- SH-3 对负横向分量先加 3 再右移两位，因此此处必须向零取整。
        o.boardX=o.boardX+3*trunc(vx/4)
        o.boardY=o.boardY+vy+o.speed*1024-0x16000
    end
    local increment=0
    if o.speed>27 then increment=4
    elseif o.speed>=20 and o.speed<=26 then increment=2
    elseif o.speed<=18 then increment=1 end
    o.phase=(o.phase+increment)%32
end

return function(data)
    local Fragment=Class(object,{
        init=function(o,run,x,y,kind,angle,deferred,layer)
            o.run,o.serial,o.birthFrame=run,run.serial,run.roadFrame
            o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY+2,false,false
            if deferred then o.layer=LAYER.ENEMY-2 end
            if layer then o.layer=layer end
            o.boardX,o.boardY,o.kind=x,y,kind
            o.bank=data[kind%12]
            o.angle,o.initialized,o.closed=angle,false,false
            run.roadFragments[o]=true
            run.fragmentCount=run.fragmentCount+1
            -- 敌机指令早于碎片池，碰撞击破晚于碎片池；后者等下一逻辑步才初始化。
            if not deferred then initialize(o); update(o) end
        end,
        frame=function(o)
            if o.closed or o.serial==o.run.serial then return end
            o.serial=o.run.serial
            if not o.initialized then initialize(o) end
            update(o)
        end,
        render=function(o)
            if not o.initialized then return end
            local frame=o.bank.frames[o.phase+1]
            local image=texture..'_'..(o.bank.first+o.phase)
            SetImageState(image,'',o.alpha,255,255,255)
            Render(image,floor(o.boardX/65536)-120+frame[2],floor(o.boardY/65536)-160+frame[3],0,1,o.flipY)
        end,
    })

    return {
        emit=function(run,x,y,kind,angle,deferred,layer)
            if not run.roadFragments then run.roadFragments,run.fragmentCount={},0 end
            if run.fragmentCount>=capacity then return end
            return New(Fragment,run,x,y,kind,angle,deferred,layer)
        end,
        close=function(run)
            for o in pairs(run.roadFragments or {}) do
                remove(o)
            end
            run.roadFragments,run.fragmentCount=nil,0
        end,
    }
end
