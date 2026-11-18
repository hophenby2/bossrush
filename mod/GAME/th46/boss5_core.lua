-- 第五面关底 Original：0x0c1b0290 / 0x0c1b07f0 / 0x0c1b0dd0 / 0x0c1b0fe0。
-- 三段共用 1807744 HP；两个阈值为 1069056、545664，过量伤害在换段时钳回阈值。
-- 判定表来自 0x0c31c370：前两盒跟随点 0，第三盒跟随点 1，出生时第三盒关闭。
-- 此处只负责受弹和换段请求；完整战斗、图形及爆件控制器就绪后再替换关卡采样入口。
local object=object
local floor=math.floor
local unit=65536
local initialHP,firstHP,secondHP,warningHP,timeout=1807744,1069056,545664,136416,18000
local shapes={{1,0,0,56,56,21,77},{1,0,48,104,104,32,32},{2,0,0,16,16,16,16}}
local fields={0x2604,0x2610,0x2634,0x2636,0x2638,0x263c,0x2640,
    0x2664,0x2668,0x267c,0x2680,0x2684,0x2688,0x268c,0x2690,
    0x2694,0x2698,0x269c,0x26a0,0x26a4,0x26a8,0x26ac,0x26b0,
    0x26b4,0x26b8,0x26bc,0x26c0,0x26c4,0x26c8,0x26cc}
local function signed(v)return(v+2147483648)%4294967296-2147483648 end
local function refresh(o)
    local r=o.raw
    o.hp,o.phase,o.invulnerable=r[0x2604],r[0x2638],r[0x2636]~=0
    for _,b in ipairs(o.boxes)do
        b.hp=o.hp
        b.colli=o.enabled and b.enabled and not o.closed and r[0x2634]==0
    end
end
local function transition(o,kind,cause,event)
    local r=o.raw
    r[0x263c],r[0x2636]=1,1
    r[0x2688+(kind-1)*4]=1
    if kind<3 then
        r[0x2638],r[0x2604]=kind,r[kind==1 and 0x2664 or 0x2668]
    else
        r[0x2634],r[0x2604]=1,0
    end
    local at=0x2694+(kind-1)*20
    r[at]=cause=='timeout'and 2 or 1
    if cause~='timeout'then
        -- 来源由真正命中的自弹提供；这里保留原版两次读取来源坐标的写回结果。
        local source=event and event.sourceInfo or{0,0,0,0}
        for i=1,4 do r[at+i*4]=source[i]end
    end
    refresh(o)
    o.request={kind=kind<3 and'change'or'defeat',phase=kind,cause=cause,event=event,
        score=cause~='timeout'and(900000+kind*100000)or 0}
    if o.notify then o.notify(o,o.request)end
end
local function applyDamage(o,amount,event,cause)
    local r=o.raw
    if o.closed or r[0x2636]~=0 or r[0x2604]<=0 then return 1 end
    r[0x2604]=signed(r[0x2604]-amount)
    local phase,hp=r[0x2638],r[0x2604]
    if phase==0 and hp<=r[0x2664]then transition(o,1,cause,event)
    elseif phase==1 and hp<=r[0x2668]then transition(o,2,cause,event)
    elseif phase==2 and hp<=0 then
        if o.defeatInhibited then r[0x2604]=512
        else transition(o,3,cause,event);return 0 end
    end
    refresh(o)
    return 1
end
local function damage(b,amount,event)
    local o=b.host
    o.raw[0x2610]=1
    return applyDamage(o,amount,event,'damage')
end
local function hitPilot(b,p)
    if not b.colli then return false end
    local s,pos=b.shape,p.pilotPosition
    local dx=floor(pos.x/unit)-floor(b.originX/unit)
    local dy=floor(pos.y/unit)-1-floor(b.originY/unit)
    return dx>=-s[5]-2 and dx<=s[4]+2 and dy>=-s[7]-2 and dy<=s[6]+2
end
local Box=Class(object,{
    init=function(b,host,index)
        local s=shapes[index]
        b.host,b.run,b.shape,b.index=host,host.run,s,index
        b.group,b.layer,b.rect,b.bound=GROUP.ENEMY,LAYER.ENEMY,true,false
        b.a,b.b=(s[4]+s[5])/2,(s[6]+s[7])/2
        b.originX,b.originY,b.boardX,b.boardY=0,0,0,0
        b.enabled,b.colli,b.hide=index<3,false,true
        b.damage,b.hitPilot=damage,hitPilot
    end,
    colli=function(b,shot)
        if not b.colli or not shot.colli or not shot.dmg then return end
        shot.colli=false
        damage(b,shot.dmg,shot)
        object.RawDel(shot)
    end,
})
local Core=Class(object,{
    init=function(o,run,p,notify)
        o.run,o.player,o.notify=run,p,notify
        o.group,o.layer,o.bound,o.colli,o.hide=GROUP.GHOST,LAYER.ENEMY,false,false,true
        o.enabled,o.closed,o.defeatInhibited=false,false,false
        o.maxhp,o.warningHP=initialHP,warningHP
        o.raw,o.boxes={},{}
        for _,at in ipairs(fields)do o.raw[at]=0 end
        o.raw[0x2604],o.raw[0x2608],o.raw[0x260c]=initialHP,initialHP,warningHP
        o.raw[0x2664],o.raw[0x2668]=firstHP,secondHP
        o.raw[0x266c],o.raw[0x2670],o.raw[0x2674]=738688,523392,secondHP
        o.raw[0x267c],o.raw[0x2680],o.raw[0x2684]=timeout,timeout,timeout
        for i=1,3 do o.boxes[i]=New(Box,o,i)end
        refresh(o)
    end,
})
local function advance(o,paused,inhibitDefeat)
    if inhibitDefeat~=nil then o.defeatInhibited=inhibitDefeat end
    if o.closed or paused then return end
    local r=o.raw
    local phase=r[0x2638]
    if phase<0 or phase>2 then return end
    local clock,done=0x267c+phase*4,0x2688+phase*4
    if r[done]~=0 then return end
    r[clock]=signed(r[clock]-1)
    if r[clock]<0 then
        if phase==2 and o.defeatInhibited then r[clock]=300;return end
        r[done]=1
        transition(o,phase+1,'timeout')
    end
end
local function applyPending(o,event)
    local r=o.raw
    if o.closed or r[0x2634]~=0 or r[0x2640]==0 then return end
    r[0x2610]=0
    applyDamage(o,r[0x2640],event,'accumulated')
    r[0x2640]=0
end
local function close(o)
    if not o or rawget(o,'closed')then return end
    o.closed=true
    for _,b in ipairs(o.boxes)do b.colli=false;object.RawDel(b)end
    object.RawDel(o)
end
return {
    fields=fields,
    create=function(run,p,notify)return New(Core,run,p,notify)end,
    transition=transition,
    advance=advance,applyPending=applyPending,close=close,refresh=refresh,
    enable=function(o,enabled)o.enabled=enabled;refresh(o)end,
    setBox=function(o,index,enabled)o.boxes[index].enabled=enabled;refresh(o)end,
    -- 换段演出自行决定何时解除无敌，不用采样的帧号替代真实任务的完成条件。
    resume=function(o)
        assert(o.raw[0x2634]==0 and o.raw[0x263c]~=0,'关底没有可恢复的换段')
        o.raw[0x2636],o.raw[0x263c],o.request=0,0,nil
        refresh(o)
    end,
    sync=function(o,points)
        for _,b in ipairs(o.boxes)do
            local s=b.shape
            local point=assert(points[s[1]],'第五面关底缺少受弹牵引点')
            b.originX,b.originY=point[1]+s[2]*unit,point[2]+s[3]*unit
            b.boardX,b.boardY=b.originX+(s[4]-s[5])*unit/2,b.originY+(s[6]-s[7])*unit/2
            b.x,b.y=floor(b.boardX/unit)-120,floor(b.boardY/unit)-160
        end
        refresh(o)
    end,
}
