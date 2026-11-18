-- 0xa2 / c15e250：中央宽幅炮抛出的实体，按配置速度直飞，每三步换一幅，共十六幅。
-- c15e3e0 不扣血，普通自弹只被吸收；八步后启用 16px 受弹盒及 30px 自机接触盒。
-- Bomb 或主人的 0x2314 标志才触发 18 类爆炸；自然出界不产生爆炸。
-- 爆炸/掉落及 0x3d 发弹由原生工厂挂载，缺少工厂时明确报错。
-- 差异 1：叠加层的板上 2/1/255 混色暂用 LuaSTG 加算近似。
local direction=dofile('mod/GAME/th46/direction.lua')
local art=dofile('mod/GAME/th46/boss1_children_art.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,abs=math.floor,math.abs
local texture='th46_boss1_children'
local function place(o)o.x,o.y=o.boardX/unit-120,o.boardY/unit-160 end
local function close(o)
    if o.closed then return end
    o.closed,o.colli,o.hide=true,false,true
    o.run.boss1Children[o]=nil
    object.RawDel(o)
end
local function explode(o,byParent)
    if o.closed then return end
    -- 原版先分配粒子再撤碰撞；先撤自弹判定，保留原坐标交给工厂。
    o.colli=false
    assert(o.ports.explode,'关底子敌机缺少原生 18 类爆炸工厂')(o,byParent)
    close(o)
end
local function hitPilot(o,p)
    if not o.colli then return false end
    local s=p.pilotPosition
    return abs(floor(o.boardX/unit)-floor(s.x/unit))<=32
        and abs(floor(o.boardY/unit)-(floor(s.y/unit)-1))<=32
end
local function step(o)
    if o.closed or o.serial==o.run.serial then return end
    o.serial=o.run.serial
    if o.parent.raw[0x2314]~=0 then explode(o,true);return end
    if assert(o.ports.bomb,'关底子敌机缺少 Bomb 状态接口')(o.run)then explode(o,false);return end
    local dx,dy=vector(o.speed,o.angle)
    o.boardX=o.boardX+dx+(o.run.roadCameraDelta or 0);o.boardY=o.boardY+dy
    place(o)
    local camera=(o.run.roadCamera or 0)*unit
    local visible=o.boardY>-32*unit and o.boardY<352*unit
        and o.boardX+camera>-72*unit and o.boardX+camera<312*unit
    if not visible then close(o);return end
    o.visible,o.hide=true,false
    if o.protection~=0 then
        o.protection=o.protection-1
        if o.protection<=0 then o.protection,o.colli=0,true end
    end
    o.renderDepth=124+(o.protection==0 and 86 or 0)
    o.layer=LAYER.ENEMY+o.renderDepth-120
    if o.flags~=0 and assert(o.ports.frame,'关底子敌机缺少原版全局步号')(o.run)%32<2 then
        for i=0,1 do
            local angle=o.angle+128+i*256
            local vx,vy=vector(320,angle)
            local emit=assert(o.ports.emit,'关底子敌机缺少 0x3d 原生弹工厂')
            emit(o.run,o.boardX+vx,o.boardY+vy,angle,-30,0x3d)
        end
    end
    o.animationClock=o.animationClock-1
    if o.animationClock<0 then o.animationClock,o.animation=o.animationInterval,o.animation+1 end
end
local function draw(o,emit)
    if o.closed or not o.visible then return end
    local index=o.animation%16;local offset=art.offsets[index+1]
    emit(0x6a4d+index,o.boardX+offset[1]*unit,o.boardY+offset[2]*unit,o.renderDepth)
    emit(0x6a5d+index,o.boardX,o.boardY,o.renderDepth)
end
local Child=Class(object,{
    init=function(o,run,x,y,parent,angle,speed,flags,ports)
        o.run,o.serial,o.parent,o.ports=run,run.serial,parent,ports
        local random=ports.random or function(n)return ran:Int(0,n)end
        o.boardX,o.boardY,o.speed,o.angle,o.flags=x,y,speed,angle,flags
        o.turnWait,o.turnInterval=random(4)+3,random(2)+2
        o.protection,o.randomSpeed=8,random(14)+32
        o.randomAngle=angle+random(16)-8
        o.animationClock,o.animationInterval,o.animation=2,2,0
        -- 独立绘制探针中 96 只均到构造的下一步才首次提交精灵。
        o.group,o.layer,o.bound,o.colli,o.hide=GROUP.ENEMY,LAYER.ENEMY+4,false,false,true
        o.visible=false
        o.renderDepth=124
        o.a,o.b,o.rect,o.hitPilot=16,16,true,hitPilot
        o.closed=false
        run.boss1Children=run.boss1Children or {};run.boss1Children[o]=true
        place(o)
    end,
    frame=step,
    colli=function(o,shot)
        if not o.colli or not shot.colli or not shot.dmg then return end
        shot.colli=false;object.RawDel(shot)
    end,
    render=function(o)
        draw(o,function(sprite,x,y)
            local image=texture..'_'..(sprite-0x6a4d)
            SetImageState(image,sprite>=0x6a5d and'mul+add'or'',255,255,255,255)
            Render(image,floor(x/unit)-120,floor(y/unit)-160)
        end)
    end,
})
return {
    load=function()
        if CheckRes('tex',texture)then return end
        LoadTexture(texture,'Resources/th46/stage1/boss1_children.png')
        SetTextureSamplerState(texture,'point+clamp')
        for i,row in ipairs(art.frames)do LoadImage(texture..'_'..(i-1),texture,unpack(row))end
    end,
    create=function(...)return New(Child,...)end,
    step=step,
    draw=draw,
    close=function(run)
        for o in pairs(run.boss1Children or {})do close(o)end
        run.boss1Children=nil
    end,
}
