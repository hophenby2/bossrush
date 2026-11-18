-- 第一面关底 Original 的共享血量与六个受弹矩形：0x0c14b1b0 / 0x0c14b690 / 0x0c14b9c0。
-- 第一段 170752 HP，降至 66816 即钳到该值再换段；不能把过量伤害带进第二段。
-- 此模块等待完整战斗控制器挂载，尚未替换练习入口中的关底采样。
local object=object
local floor=math.floor
local unit=65536
-- 0x0c303ebc，每行取牵引点下标、左右上下距离；六盒均挂在第 0 块共享血量上。
local shapes={{1,56,56,96,96},{0,32,32,21,21},{4,44,44,44,44},
              {5,44,44,44,44},{2,48,48,56,56},{3,48,48,56,56}}
local initialHP,changeHP,warningHP,timeout=170752,66816,16704,18000

local function refresh(o)
    for _,b in ipairs(o.boxes)do
        b.hp=o.hp
        b.colli=o.enabled and not o.closed and o.mode~='defeat'
    end
end

local function request(o,kind,event,cause)
    o.request,o.cause,o.event=kind,cause,event
    if kind=='change'then
        o.phase,o.hp,o.invulnerable,o.mode=1,changeHP,true,'change'
        -- 超时分支先撤判定；伤害分支继续挡住自弹，但不再扣血。
        if cause=='timeout'then o.enabled=false end
    else
        o.hp,o.invulnerable,o.enabled,o.mode=0,true,false,'defeat'
    end
    refresh(o)
    if o.notify then o.notify(o,kind,event,cause)end
end

local function damage(box,amount,event)
    local o=box.host
    -- 原回调先置命中标志，之后才检查换段无敌和剩余血量。
    o.hitMark=true
    if o.invulnerable or o.hp<=0 or o.closed then return 1 end
    o.hp=(o.hp-amount+2147483648)%4294967296-2147483648
    if o.phase==0 and o.hp<=changeHP then
        request(o,'change',event,'damage')
    elseif o.phase==1 and o.hp<=0 then
        if o.defeatInhibited then o.hp=512;refresh(o);return 1 end
        request(o,'defeat',event,'damage');return 0
    end
    refresh(o)
    return 1
end

local function hitPilot(box,p)
    local position=p.pilotPosition
    local dx=floor(position.x/unit)-floor(box.boardX/unit)
    local dy=floor(position.y/unit)-1-floor(box.boardY/unit)
    return dx>=-box.shape[2]-2 and dx<=box.shape[3]+2
       and dy>=-box.shape[5]-2 and dy<=box.shape[4]+2
end

local Box=Class(object,{
    init=function(o,host,shape)
        o.host,o.run,o.shape=host,host.run,shape
        o.group,o.layer,o.rect,o.bound=GROUP.ENEMY,LAYER.ENEMY,true,false
        o.a,o.b=(shape[2]+shape[3])/2,(shape[4]+shape[5])/2
        o.x,o.y,o.boardX,o.boardY=0,0,0,0
        o.hp,o.colli,o.hide=host.hp,false,true
        o.damage,o.hitPilot=damage,hitPilot
    end,
    colli=function(o,shot)
        if not o.colli or not shot.colli or not shot.dmg then return end
        -- RawDel 等帧末才回收；重叠的其它受弹盒仍会收到同一颗自弹，必须先退出碰撞。
        shot.colli=false
        damage(o,shot.dmg,shot)
        object.RawDel(shot)
    end,
})

local Core=Class(object,{
    init=function(o,run,p,notify)
        o.run,o.player,o.notify=run,p,notify
        o.group,o.layer,o.bound,o.colli,o.hide=GROUP.GHOST,LAYER.ENEMY,false,false,true
        o.hp,o.maxhp,o.warningHP,o.phase=initialHP,initialHP,warningHP,0
        o.phaseClock,o.finalClock=timeout,timeout
        o.mode,o.enabled,o.invulnerable,o.closed='enter',false,false,false
        o.defeatInhibited=false
        o.boxes={}
        for _,shape in ipairs(shapes)do o.boxes[#o.boxes+1]=New(Box,o,shape)end
    end,
})

local function close(o)
    if not o or o.closed then return end
    o.closed,o.hide=true,true
    for _,b in ipairs(o.boxes)do b.colli,b.hide=false,true;object.RawDel(b)end
    object.RawDel(o)
end

return {
    create=function(run,p,notify)return New(Core,run,p,notify)end,
    -- 六点由绘图更新器提供：原结构 0x1f9c+i*0x8c；坐标并非紧邻的六组长字。
    sync=function(o,points)
        for _,b in ipairs(o.boxes)do
            local p=assert(points[b.shape[1]+1],'关底缺少受弹牵引点')
            b.boardX,b.boardY=p[1],p[2]
            b.x,b.y=floor(p[1]/unit)-120,floor(p[2]/unit)-160
        end
        refresh(o)
    end,
    enable=function(o,enabled)
        o.enabled=enabled
        if enabled and o.mode=='enter'then o.mode='fight'end
        refresh(o)
    end,
    resume=function(o)
        assert(o.mode=='change','只有转阶段控制器可以重新开放关底判定')
        o.invulnerable,o.enabled,o.mode,o.request=false,true,'fight',nil
        refresh(o)
    end,
    -- 抑制条件来自 0x0c076890（全局管理器字段），不能用自机复活倒数冒充。
    advance=function(o,paused,inhibitDefeat)
        if inhibitDefeat~=nil then o.defeatInhibited=inhibitDefeat end
        if o.closed or paused or o.mode=='defeat'then return end
        o.hitMark=false
        if o.phase==0 then
            o.phaseClock=o.phaseClock-1
            if o.phaseClock<0 then request(o,'change',nil,'timeout')end
        elseif o.mode~='change'then
            o.finalClock=o.finalClock-1
            if o.finalClock<0 then
                if o.defeatInhibited then o.finalClock=300
                else request(o,'defeat',nil,'timeout')end
            end
        end
    end,
    close=close,
}
