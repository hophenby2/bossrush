-- 0x0c077510 / 0x0c077600 的 0 / 1 / 3 类尾气节点及六类粒子。
-- 节点随本体两个振动锚点移动，已发出的粒子独立淡出，不能在击破时随节点一起删除。
-- 差异 1：随机数使用 LuaSTG 录像序列；128 槽只统计已移植的这三类尾气。
-- 差异 2：EP1C12 加算和颜色倍率使用 LuaSTG mul+add 近似。
local direction=dofile('mod/GAME/th46/direction.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,trunc=math.floor,math.modf
local texture,capacity='th46_exhaust',128

local function draw(slot,x,y,alpha,r,g,b)
    local image=texture..'_'..slot
    SetImageState(image,'mul+add',alpha,r,g,b)
    Render(image,floor(x/unit)-120,floor(y/unit)-160)
end

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.run.exhaustSparks[o]=nil
    o.run.exhaustCount=o.run.exhaustCount-1
    object.RawDel(o)
end

local function advance(o)
    o.boardX=o.boardX+o.boardVX+(o.run.roadCameraDelta or 0)
    o.boardY=o.boardY+o.boardVY
    if o.kind==0 or o.kind==1 then
        o.alpha=o.alpha-4
        if o.alpha<0 then o.alpha=0;remove(o);return end
        o.clock=o.clock-1
        if o.clock<0 then o.clock,o.phase=2,(o.phase+1)%16 end
    elseif o.kind==8 then
        o.alpha=o.alpha-2
        if o.alpha<0 then o.alpha=0;remove(o) end
    else
        o.alpha=o.alpha-3
        if o.alpha<0 then o.alpha=0;remove(o);return end
        o.clock=o.clock-1
        if o.clock<0 then
            o.clock,o.phase=1,o.phase-1
            if o.phase<0 then o.phase=0;remove(o) end
        end
    end
end

local Spark=Class(object,{
    init=function(o,run,x,y,kind,phase,angle)
        o.run,o.serial,o.birthFrame=run,run.serial,run.roadFrame
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY-2,false,false
        o.boardX,o.boardY,o.kind=x,y,kind
        o.speed,o.angle,o.boardVX,o.boardVY=12,angle,vector(12,angle)
        o.alpha,o.phase,o.clock=kind==8 and 96 or kind<=1 and 128 or 160,
            kind==8 and phase or kind<=1 and ran:Int(0,15) or kind==16 and 35 or 25,0
        o.closed=false
        run.exhaustSparks[o]=true
        run.exhaustCount=run.exhaustCount+1
        -- 原版全局粒子队列在节点队列之后，分配当步已经积分并减透明度。
        advance(o)
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        advance(o)
    end,
    render=function(o)
        if o.closed then return end
        if o.kind==8 then draw(o.phase,o.boardX,o.boardY,o.alpha,255,255,255)
        elseif o.kind==0 then draw(42+o.phase,o.boardX,o.boardY,o.alpha,255,255,255)
        elseif o.kind==1 then draw(59+o.phase,o.boardX,o.boardY,o.alpha,255,255,255)
        elseif o.kind==15 or o.kind==16 then draw(o.phase<=25 and 16+o.phase or 49+o.phase,o.boardX,o.boardY,o.alpha,255,128,128)
        else draw(16+o.phase,o.boardX,o.boardY,o.alpha,128,255,255) end
    end,
})

local Node=Class(object,{
    init=function(o,host,index,kind)
        o.run,o.host,o.index,o.kind=host.run,host,index,kind or 3
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY-1,false,false
        o.phase,o.clock,o.spawnClock=ran:Int(0,15),1,o.kind<=1 and 5 or 7
        o.closed=false
    end,
    render=function(o)
        if o.closed then return end
        if o.kind<=1 then
            draw(58,o.boardX,o.boardY,128,255,64,64)
            draw((o.kind==0 and 42 or 59)+o.phase,o.boardX,o.boardY,192,255,255,255)
        else draw(o.phase,o.boardX,o.boardY,80,255,255,255) end
    end,
})

return {
    open=function(run)
        run.exhaustSparks,run.exhaustCount=run.exhaustSparks or {},run.exhaustCount or 0
        if CheckRes('img',texture..'_0') then return end
        LoadTexture(texture,'Resources/th46/stage1/exhaust.png')
        SetTextureSamplerState(texture,'point+clamp')
        for i=0,83 do LoadImage(texture..'_'..i,texture,i%8*64,floor(i/8)*64,64,64) end
    end,
    attach=function(host,kind)
        host.exhaustNodes={}
        for i=1,kind and kind<=1 and 2 or 4 do host.exhaustNodes[i]=New(Node,host,i,kind) end
    end,
    step=function(host)
        local pending={}
        for i,o in ipairs(host.exhaustNodes) do
            local left=i%2==1
            local span=o.kind==1 and 44 or 28
            o.boardX=host.boardX+(left and -span or span)*unit
            if o.kind<=1 then o.boardY=host.boardY+16*unit
            else
                o.boardY=host.boardY+host.waves[i<=2 and 3 or 4][4]
                    +trunc(host.waves[1][4]/10)+(i<=2 and 4 or -4)*unit
            end
            o.spawnClock=o.spawnClock-1
            if o.spawnClock<0 then
                o.spawnClock=5
                local kind=ran:Int(0,1)~=0 and (o.kind<=1 and o.kind or 8) or (o.kind<=1 and o.kind+15 or 18)
                local angle=(host.angle+(left and 232 or 280)-ran:Int(0,95)+48)%512
                if host.run.exhaustCount+#pending<capacity then
                    pending[#pending+1]={o.boardX,o.boardY,kind,o.phase,angle}
                end
            end
            o.clock=o.clock-1
            if o.clock<0 then o.clock,o.phase=1,(o.phase+1)%16 end
        end
        -- 0 类粒子的随机首格在全局粒子队列中初始化，晚于这一轮所有节点的随机发射。
        for _,args in ipairs(pending) do New(Spark,host.run,unpack(args)) end
    end,
    detach=function(host)
        for _,o in ipairs(host.exhaustNodes or {}) do
            o.closed,o.hide=true,true
            object.RawDel(o)
        end
    end,
    close=function(run)
        for o in pairs(run.exhaustSparks or {}) do remove(o) end
        run.exhaustSparks,run.exhaustCount=nil,0
    end,
}
