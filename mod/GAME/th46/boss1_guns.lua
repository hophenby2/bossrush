-- 第一面关底 Original 的头部连射、五路扇与左右侧炮，等待完整战斗控制器按原入口挂载。
-- 每串先 2 发，每两串加一发、最多 4 发；串间等待 24→20，速度参数 0→24，串内隔 5 步转向最多 4 格。
local direction=dofile('mod/GAME/th46/direction.lua')
local object,unit,heading,vector=object,direction.unit,direction.heading,direction.vector
local min,max=math.min,math.max
local function close(o)
    if o.closed then return end
    o.closed,o.hide=true,true;o.run.boss1Guns[o]=nil;object.RawDel(o)
end
local function turn(current,target)
    return(current+max(-4,min(4,(target-current+256)%512-256)))%512
end
local function initialize(o,host,emit)
    o.host,o.run,o.player,o.emit=host,host.run,host.player,emit
    o.serial,o.group,o.bound,o.colli,o.hide=host.run.serial,GROUP.GHOST,false,false,true
    o.closed=false
    o.run.boss1Guns=o.run.boss1Guns or {};o.run.boss1Guns[o]=true
    o.run.boss1GunOrder=(o.run.boss1GunOrder or 0)+1;o.order=o.run.boss1GunOrder
end
local function advance(o)
    if o.closed or o.serial==o.run.serial then return false end
    o.serial=o.run.serial;return true
end
local function aim(o,x,y)
    local p=o.player
    return p.respawn==0 and heading(x,y,p.pilotPosition.x,p.pilotPosition.y)or 256
end
local function finish(o)
    close(o)
    if o.host.gunDone then o.host.gunDone(o.host,o)end
end
local Head=Class(object,{
    init=function(o,host,emit)
        initialize(o,host,emit)
        o.pauseClock,o.pause,o.shotClock,o.shotInterval=0,24,0,4
        o.remaining,o.count,o.angle,o.kind,o.speed,o.pairs=0,2,256,0x13,0,0
        o.stopRequested=false
    end,
    frame=function(o)
        if not advance(o)then return end
        if o.remaining==0 then
            o.pauseClock=o.pauseClock-1
            if o.pauseClock<0 then o.pauseClock,o.remaining=o.pause,o.count end
            return
        end
        o.shotClock=o.shotClock-1
        if o.shotClock>=0 then return end
        o.shotClock=o.shotInterval
        local x,y=o.host.boardX,o.host.boardY-104*unit
        local target=aim(o,x,y)
        if o.remaining==o.count then o.angle=target else o.angle=turn(o.angle,target)end
        o.emit(o.run,x,y,o.angle,o.speed,o.kind)
        o.remaining=o.remaining-1
        if o.remaining>0 then return end
        o.pairs=o.pairs+1
        if o.pairs>1 then o.pairs,o.count=0,min(4,o.count+1)end
        o.pause,o.speed=max(20,o.pause-4),min(24,o.speed+2)
        if o.stopRequested then finish(o)end
    end,
})

-- 0x0c157be0 / 0x0c157f80：两轮调用分别给 2 发 / 隔 17 步和 4 发 / 隔 13 步。
-- 五路参数交给原生弹工厂展开；每发重新瞄准，速度偏移从 1 起逐发加一。
local Burst=Class(object,{
    init=function(o,host,emitFan,count,interval)
        initialize(o,host,emitFan)
        o.pauseClock,o.pause,o.shotClock,o.shotInterval=0,0,0,interval
        o.remaining,o.count,o.kind,o.speed,o.baseSpeed=0,count,0x34,1,1
    end,
    frame=function(o)
        if not advance(o)then return end
        if o.remaining==0 then
            o.pauseClock=o.pauseClock-1
            if o.pauseClock<0 then o.pauseClock,o.remaining=o.pause,o.count end
            return
        end
        o.shotClock=o.shotClock-1
        if o.shotClock>=0 then return end
        o.shotClock=o.shotInterval
        local x,y=o.host.boardX,o.host.boardY-104*unit
        o.emit(o.run,x,y,aim(o,x,y),o.speed,o.kind,5,40)
        o.speed,o.remaining=o.speed+1,o.remaining-1
        if o.remaining==0 then o.speed=o.baseSpeed;finish(o)end
    end,
})

-- 0x0c157ce0 / 0x0c1581d0：每侧连射两串再增加一对侧扇，六串结束才收回侧炮。
-- 原指令先按 64*i 求垂直偏移再加倍，因此扇层离中心 8*i 像素，不能误当 4*i。
local Side=Class(object,{
    init=function(o,host,emit,config,firstSide)
        initialize(o,host,emit)
        o.gunType='side'
        o.pauseClock,o.pause,o.shotClock,o.shotInterval=config.delay,config.pause,0,2
        o.remaining,o.count,o.waves,o.angleLeft,o.angleRight=0,3,config.waves,0,0
        o.kind,o.speed,o.baseSpeed=0x31,config.speed-2,config.speed-2
        o.side,o.sideClock,o.extraPairs=firstSide==nil and ran:Int(0,1)or firstSide,2,0
    end,
    frame=function(o)
        if not advance(o)then return end
        if o.remaining==0 then
            o.pauseClock=o.pauseClock-1
            if o.pauseClock<0 then o.pauseClock,o.remaining=o.pause,o.count end
            return
        end
        o.shotClock=o.shotClock-1
        if o.shotClock>=0 then return end
        o.shotClock=o.shotInterval
        local left=o.side%2==1
        local x,y=o.host.boardX+(left and -94 or 94)*unit,o.host.boardY-148*unit
        local key=left and 'angleLeft'or'angleRight'
        if o.remaining==o.count then o[key]=aim(o,x,y)end
        local a=o[key]
        o.emit(o.run,x,y,a,o.speed,o.kind)
        for i=1,o.extraPairs do
            local dx,dy=vector(64*i,a-128)
            o.emit(o.run,x+2*dx,y+2*dy,a-36*i,o.speed-4*i,o.kind)
            dx,dy=vector(64*i,a+128)
            o.emit(o.run,x+2*dx,y+2*dy,a+36*i,o.speed-4*i,o.kind)
        end
        o.remaining=o.remaining-1
        if o.remaining>0 then return end
        o.side,o.sideClock=o.side+1,o.sideClock-1
        if o.sideClock<=0 then o.sideClock,o.extraPairs=2,o.extraPairs+1 end
        o.waves,o.speed=o.waves-1,o.baseSpeed
        if o.waves<=0 then
            o.waves,o.pauseClock,o.count,o.extraPairs=6,96,3,0
            finish(o)
        end
    end,
})
local extra=dofile('mod/GAME/th46/boss1_guns_extra.lua')(initialize,advance,aim,finish)
return {
    head=function(host,emit)return New(Head,host,emit)end,
    burst=function(host,emitFan,count,interval)return New(Burst,host,emitFan,count,interval)end,
    side=function(host,emit,config,firstSide)return New(Side,host,emit,config,firstSide)end,
    leap=extra.leap,
    wide=extra.wide,
    stop=function(o)o.stopRequested=true end,
    step=function(run)
        local list={};for o in pairs(run.boss1Guns or {})do list[#list+1]=o end
        table.sort(list,function(a,b)return a.order<b.order end)
        for _,o in ipairs(list)do o.class.frame(o)end
    end,
    close=function(run)
        for o in pairs(run.boss1Guns or {})do close(o)end
        run.boss1Guns=nil
    end,
}
