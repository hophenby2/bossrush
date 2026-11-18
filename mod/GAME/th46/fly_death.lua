-- 第一面 0x11 / 0x13 / 0x23 共用的 0x0c0a2190：Original 击破分、爆炸、碎片与金块。
-- 碰撞在粒子队列之后执行；粒子下一逻辑步启动，伴随爆炸分别额外等待两步、一步。
-- 差异 1：使用 LuaSTG 录像随机数，尚未接入原版全局随机序列及共享粒子池占用。
-- 差异 2：EP1C12 加算用 LuaSTG 混色近似，击破音效尚未挂载。
-- 差异 3：通用 Bomb 尚未传入原版碰撞事件标志；此处保留 0x20、0x400 的原回调分支。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/midboss1_effect_data.lua')
local fragments=dofile('mod/GAME/th46/fragments.lua')(data.debris)
local gold=dofile('mod/GAME/th46/gold.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,min,trunc=math.floor,math.min,math.modf
local texture,capacity,killPoints='th46_midboss1_effects',128,240

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.run.flyEffects[o]=nil
    o.run.flyEffectCount=o.run.flyEffectCount-1
    object.RawDel(o)
end

local function advance(o)
    o.boardX=o.boardX+o.run.roadCameraDelta
    if not o.visible then
        o.wait=o.wait-1
        if o.wait>=0 then return end
        o.visible=true
        if o.dropKind~=nil then
            -- 0x0c096570 在首次积分之前生成金块，不能跟随爆炸移动后再取掉落坐标。
            gold.emit(o.run,o.boardX+(ran:Int(0,16)-8)*unit,o.boardY+(ran:Int(0,16)-8)*unit,o.dropKind)
        end
        o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
        return
    end
    o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
    o.clock=o.clock-1
    if o.clock>=0 then return end
    o.index=o.index+1
    local frame=o.animation.frames[o.index]
    if not frame then remove(o); return end
    o.clock=frame[1]
end

local Particle=Class(object,{
    init=function(o,run,x,y,kind,speed,angle,wait,alpha,flip,blend,dropKind)
        o.run,o.serial,o.birthFrame=run,run.serial,run.roadFrame
        -- 0x0c0a2248 将绘制深度设为本体减一；爆炸不能盖住同批其它飞虫。
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY-1,false,false
        o.boardX,o.boardY,o.boardVX,o.boardVY=x,y,vector(speed,angle)
        o.kind,o.animation,o.index,o.wait=kind,data[kind],4,wait
        -- 构造回调设为 1，启动当步的动画回调再减为 0；不能用第四画格的间隔代替。
        o.clock=0
        o.alpha,o.flip,o.blend,o.dropKind=alpha,flip,blend,dropKind
        o.visible,o.closed=false,false
        run.flyEffects[o]=true
        run.flyEffectCount=run.flyEffectCount+1
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        advance(o)
    end,
    render=function(o)
        if not o.visible then return end
        local frame=o.animation.frames[o.index]
        local image=texture..'_'..(o.animation.first+o.index-1)
        SetImageState(image,o.blend,o.alpha,255,255,255)
        Render(image,floor(o.boardX/unit)-120+frame[2]*o.flip,floor(o.boardY/unit)-160+frame[3],0,o.flip,1)
    end,
})

local function particle(o,kind,speed,angle,wait,alpha,flip,blend,dropKind)
    local run=o.run
    if run.flyEffectCount>=capacity then return end
    return New(Particle,run,o.boardX,o.boardY,kind,speed,angle,wait,alpha,flip,blend,dropKind)
end

local function explode(o)
    local focused=o.player.laser
    local jitter=ran:Int(0,14)
    jitter=jitter<7 and jitter-11 or jitter-3
    particle(o,8,o.speed,o.heading+4*jitter,0,255,1,'',gold.choose(focused))
    local angle=o.heading+2*ran:Int(0,63)-64
    particle(o,0,trunc(3*o.speed/4),o.heading,2,255,1,'')
    particle(o,0,16,angle,1,80,-1,'mul+add')
    particle(o,0,24,angle+4*ran:Int(0,16),1,48,1,'mul+add')
    for _=1,3 do fragments.emit(o.run,o.boardX,o.boardY,0,nil,true) end
    if not focused then gold.emit(o.run,o.boardX,o.boardY,0) end
end

return {
    open=function(run) run.flyEffects,run.flyEffectCount={},0 end,
    damage=function(o,amount,flags)
        flags=flags or 0
        -- 原回调忽略 0x400 碰撞事件；血量归零后同一碰撞批次不再重复结算。
        if o.hp<=0 or floor(flags/0x400)%2==1 then return end
        o.hp=o.hp-amount
        if o.hp>0 then return end
        o.colli=false
        local points=floor(flags/0x20)%2==1 and floor(killPoints/40) or killPoints
        lstg.var.score=min(0xee6b27ff,lstg.var.score+points)
        explode(o)
    end,
    close=function(run)
        for o in pairs(run.flyEffects or {}) do remove(o) end
        run.flyEffects,run.flyEffectCount=nil,0
        fragments.close(run)
    end,
}
