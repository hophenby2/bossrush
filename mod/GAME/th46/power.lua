-- 0x0c091de0 的 0 类小 P：出生后下一步初始化，再下一步开始漂浮；内边界反弹 1800 步。
-- 0x0c0927b0 的拾取只改原生火力计数和分数，通用射击仍待原版各火力档指令替换。
-- 差异 1：使用 LuaSTG 录像随机数；目前只挂载已还原的 0 类分配入口，容量为原版的 12 槽。
-- 差异 2：光晕、文字与分数浮字以 LuaSTG 混色近似 EP1C12，尚未接入原版拾取音效。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/power_data.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,min,max,abs=math.floor,math.min,math.max,math.abs
local texture,capacity='th46_power',12

local function place(o)
    o.x,o.y=floor(o.boardX/unit)-120,floor(o.boardY/unit)-160
end

local function remove(o)
    if o.closed then return end
    o.closed,o.hide,o.colli=true,true,false
    o.run.roadPower[o]=nil
    o.run.powerCount=o.run.powerCount-1
    object.RawDel(o)
end

local function velocity(o)
    o.boardVX,o.boardVY=vector(o.speed,o.angle)
end

local function initialize(o)
    -- 0x0c091fe0 的纵向越界分支跳过横向钳制，不能合并为两轴同时钳制。
    if o.boardY>=312*unit then o.boardY=312*unit
    elseif o.boardY<24*unit then o.boardY=24*unit
    else o.boardX=max(16*unit,min(224*unit,o.boardX)) end
    o.speed,o.angle=18,192+8*ran:Int(0,15)
    velocity(o)
    o.phase,o.clock,o.interval,o.bounce=0,2,2,1800
    o.initialized,o.colli=true,true
    place(o)
end

local function collect(o,p)
    if not o.colli or p.run~=o.run or p.respawn~=0 then return end
    local pos=p.pilotPosition
    if abs(floor(pos.x/unit)-floor(o.boardX/unit))>22
        or abs(floor(pos.y/unit)-1-floor(o.boardY/unit))>22 then return end
    local state=NativePlayers.state()
    o.full=state.power>=7
    state.power=min(7,state.power+1)
    o.points=o.full and 10000 or 500
    lstg.var.score=min(0xee6b27ff,lstg.var.score+o.points)
    -- 原版道具绘制队列先于拾取碰撞；拾取这一帧仍保留已经提交的图标。
    o.itemPhase=o.phase
    o.colli,o.popup,o.mode,o.phase=false,true,0,0
    o.clock,o.interval=o.full and 1 or 0,o.full and 1 or 0
    o.count,o.hold,o.alpha=0,5,255
    local choice=ran:Int(0,7)
    o.speed,o.angle=14+2*(choice-choice%2),o.boardX<120*unit and 128 or 384
    o.serial=o.run.serial
end

local function advancePopup(o)
    velocity(o)
    o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY+0x8000
    o.drawPhase,o.drawAlpha=o.phase,o.alpha
    o.clock=o.clock-1
    if o.clock<0 then
        o.clock=o.interval
        o.phase=o.phase+1
        if not o.full then
            o.alpha=max(0,o.alpha-6)
            if o.phase>52 then remove(o) end
        elseif o.mode==0 then
            if o.phase>4 then o.count=o.count+1 end
            if o.phase>7 then o.mode=1 end
        elseif o.mode==1 then
            o.count=o.count+1
            if o.count>3 then
                o.hold=o.hold-1
                if o.hold<0 then o.mode=2 else o.count=0 end
            end
        else
            o.alpha=o.alpha-21
            o.count=o.count+1
            if o.count>15 then remove(o) end
        end
    end
    if o.full then o.drawAlpha=o.alpha end
    place(o)
end

local function advance(o)
    -- 0x0c091d46 在各类回调之前补上 2 层的本步镜头位移，浮字和初始化也受它影响。
    o.boardX=o.boardX+(o.run.roadCameraDelta or 0)
    if not o.initialized then initialize(o);return end
    if o.popup then advancePopup(o);return end
    o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
    local x=o.boardX+(o.run.roadCamera or 0)*unit
    if x<=-72*unit or x>=312*unit or o.boardY<=-32*unit or o.boardY>=352*unit then remove(o);return end
    if o.bounce>0 then
        o.bounce=o.bounce-1
        if o.boardX<=16*unit then
            o.boardX=16*unit
            if o.angle>255 then
                if o.boardY>=176*unit then o.angle=320 end
                o.angle=(8*ran:Int(0,14)-o.angle-56)%512
                velocity(o)
            end
        elseif o.boardX>224*unit then
            o.boardX=224*unit
            if o.angle<=256 then
                if o.boardY>=176*unit then o.angle=192 end
                o.angle=(8*ran:Int(0,14)-o.angle-56)%512
                velocity(o)
            end
        end
        if o.boardY>=312*unit then
            o.boardY=312*unit
            if not (o.angle>=129 and o.angle<=383) then o.angle=(8*ran:Int(0,14)-o.angle-312)%512 end
            velocity(o)
        elseif o.boardY<24*unit then
            o.boardY=24*unit
            o.angle=(8*ran:Int(0,14)-o.angle-312)%512
            velocity(o)
        end
    end
    o.clock=o.clock-1
    if o.clock<0 then
        o.phase=(o.phase+1)%4
        o.clock=o.interval+(o.phase==0 and 22 or 0)
    end
    place(o)
end

local function draw(slot,x,y,alpha,blend,r,g,b)
    local image=texture..'_'..slot
    SetImageState(image,blend or '',alpha or 255,r or 255,g or 255,b or 255)
    Render(image,x,y)
end

local Power=Class(object,{
    init=function(o,run,x,y)
        o.run,o.serial,o.birthFrame=run,run.serial,run.roadFrame
        o.group,o.layer,o.bound,o.colli=GROUP.ITEM,LAYER.ITEM,false,false
        o.native_pickup,o.a,o.b,o.rect=true,21,22,true
        -- 分配器扣的是 1 层镜头偏移，第一面该层为零；2 层的逐步平移在 advance 中补上。
        o.boardX,o.boardY=x,y
        o.initialized,o.popup,o.closed=false,false,false
        run.roadPower[o]=true
        run.powerCount=run.powerCount+1
        place(o)
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        advance(o)
        -- 0x0c091d76 在回调之后还有一层可视区回收，不能只用宽边界 helper。
        if not o.closed and (o.boardX<0 or o.boardX>240*unit or o.boardY<0 or o.boardY>320*unit) then remove(o) end
    end,
    colli=collect,
    render=function(o)
        if not o.initialized or o.closed then return end
        if o.popup and o.drawPhase~=nil then
            if o.full then
                local value=tostring(o.points)
                local blue=floor(((o.run.roadFrame or 0)+1207)/2)%2==1 and 255 or 0
                for i=1,#value do
                    draw(54+tonumber(value:sub(i,i)),o.x+i*8,o.y,o.drawAlpha%256,'mul+add',255,255,blue)
                end
            else
                local phase=data.phase[o.drawPhase+1]
                local subphase=data.subphase[o.drawPhase+1]
                local a=phase<=15 and 255 or 720-31*phase
                local offset,sub=data.main[phase+1],data.sub[subphase+1]
                draw(6+phase,o.x+offset[1],o.y+8+offset[2],floor(3*a/4),'mul+add')
                draw(30+subphase,o.x+sub[1],o.y+sub[2],a%256,'mul+add')
            end
        else
            draw(4,o.x+16,o.y-48,128)
            local clock=(o.run.roadFrame or 0)+1207
            for i=0,3 do
                local t=(clock+2*i)%16
                local dx,dy=vector(-t*16,clock)
                local alpha=floor((15-t)*47/15)
                draw(5,o.x+dx/unit,o.y+dy/unit,alpha,'mul+add')
                draw(5,o.x-dx/unit,o.y-dy/unit,alpha,'mul+add')
            end
            draw(5,o.x,o.y,63,'mul+add')
            draw(o.popup and o.itemPhase or o.phase,o.x,o.y)
        end
    end,
})

return {
    open=function(run)
        run.roadPower,run.powerCount={},0
        if CheckRes('img',texture..'_0') then return end
        LoadTexture(texture,'Resources/th46/stage1/power.png')
        SetTextureSamplerState(texture,'point+clamp')
        for i=0,63 do LoadImage(texture..'_'..i,texture,i%8*128,floor(i/8)*128,128,128) end
    end,
    emit=function(run,x,y)
        if run.powerCount>=capacity then return end
        return New(Power,run,x,y)
    end,
    close=function(run)
        for o in pairs(run.roadPower or {}) do remove(o) end
        run.roadPower,run.powerCount=nil,0
    end,
}
