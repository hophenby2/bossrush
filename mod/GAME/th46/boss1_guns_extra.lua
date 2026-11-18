-- Original 跳跃双侧扇 c157e30/c1585e0 与中央宽幅炮 c157d80/c158430。
-- 宽幅炮的两个时钟彼此独立：火球每 5 步一只、共 48 只；四路双扇间隔 40→8，速度偏移 8→32。
-- 子弹运动指令及 0xa2 子敌机交给具名原生工厂，不能以普通直线弹或装饰代替。
return function(initialize,advance,aim,finish)
    local direction=dofile('mod/GAME/th46/direction.lua')
    local unit,min,max=direction.unit,math.min,math.max
    local Leap=Class(object,{
        init=function(o,host,ports,waves)
            initialize(o,host,assert(ports.motionFan,'跳跃炮缺少原生运动扇工厂'))
            o.ports=ports
            o.pauseClock,o.pause,o.shotClock,o.shotInterval=0,4,0,1
            o.remaining,o.count,o.waves=0,1,waves
            o.angleLeft,o.angleRight,o.resetMark=0,0,0
            o.kind,o.speedLeft,o.speedRight=0x25,10,10
            o.side=assert(ports.random,'跳跃炮缺少随机数接口')(1)
            o.motionType,o.motionTime,o.aimed,o.fanCount,o.fanStep=2,32,0,10,28
        end,
        frame=function(o)
            if not advance(o)then return end
            if o.remaining==0 then
                o.pauseClock=o.pauseClock-1
                if o.pauseClock<0 then o.pauseClock,o.remaining,o.resetMark=o.pause,o.count,0 end
                return
            end
            o.shotClock=o.shotClock-1
            if o.shotClock>=0 then return end
            o.shotClock=o.shotInterval
            local x=o.host.boardX
            local y=o.host.boardY+o.host.raw[16]-160*unit
            local left,right=aim(o,x-94*unit,y),aim(o,x+94*unit,y)
            if o.aimed==0 then o.aimed,o.angleLeft,o.angleRight=1,left,right end
            local count=o.fanCount+o.side%2
            -- c3c4560 是基速，不是 c38a4ac 的动态 rank；弹分配器随后才加 rank >> 5。
            local speed=2-assert(o.ports.baseSpeed,'跳跃炮缺少原版基速接口')(o.run)
            o.emit(o.run,x-94*unit,y,o.angleLeft,speed,o.kind,count,o.fanStep,1,o.motionTime,o.motionType)
            o.emit(o.run,x+94*unit,y,o.angleRight,speed,o.kind,count,o.fanStep,1,o.motionTime,o.motionType)
            o.remaining=o.remaining-1
            if o.remaining>0 then return end
            o.motionTime,o.side,o.count,o.waves=4,o.side+1,o.count+1,o.waves-1
            if o.waves<=0 then finish(o)end
        end,
    })
    local Wide=Class(object,{
        init=function(o,host,ports,side)
            initialize(o,host,assert(ports.fan,'宽幅炮缺少原生扇弹工厂'))
            o.ports=ports
            o.spawnClock,o.spawnInterval,o.children=64,4,48
            o.shotClock,o.shotWait,o.turnClock,o.turnInterval=96,40,64,3
            o.angle,o.turn=side~=0 and 296 or 216,side~=0 and -1 or 1
            o.kind,o.fanSpeed,o.childSpeed,o.spreadOffset=0x13,0,16,0
            assert(ports.pose,'宽幅炮缺少中央关节接口')(host,o.angle,4)
        end,
        frame=function(o)
            if not advance(o)then return end
            o.turnClock=o.turnClock-1
            if o.turnClock<0 then o.turnClock,o.angle=o.turnInterval,o.angle+o.turn end
            o.spawnClock=o.spawnClock-1
            if o.spawnClock<0 then
                o.spawnClock=o.spawnInterval
                local dx,dy=direction.vector(128,o.angle)
                local b=o.host.raw
                local child=assert(o.ports.child,'宽幅炮缺少 0xa2 原生敌机工厂')
                child(o.run,0xa2,b[0x1a8c]+4*dx,b[0x1a90]+4*dy,o.host,o.angle,o.childSpeed,0)
                o.childSpeed=min(128,o.childSpeed+8)
                o.ports.pose(o.host,o.angle,1)
                o.children=o.children-1
                if o.children<=0 then finish(o)end
            end
            -- 原版在关闭炮台后仍会走到本步的扇弹分支，不能在 finish 后提前返回。
            o.shotClock=o.shotClock-1
            if o.shotClock>=0 then return end
            o.shotClock,o.shotWait=o.shotWait,max(8,o.shotWait-3)
            o.fanSpeed=min(32,o.fanSpeed+8)
            local b=o.host.raw
            local x,y=b[0x1a8c],b[0x1a90]+24*unit
            o.emit(o.run,x,y,o.angle+96,o.fanSpeed,o.kind,4,24-o.spreadOffset)
            o.emit(o.run,x,y,o.angle-96,o.fanSpeed,o.kind,4,24-o.spreadOffset)
        end,
    })
    return {leap=function(host,ports,waves)return New(Leap,host,ports,waves)end,
        wide=function(host,ports,side)return New(Wide,host,ports,side)end}
end
