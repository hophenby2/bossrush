-- 0x1a8aa4 先运行两路烟尘，再停掉舰身绘制并通知伴飞机离舰。
return function(program,effects,art,tasks)
    local band=require('bit').band
    local floor=math.floor
    local s16,s8=program.s16,program.s8
    local data=program.boss6
    local M={}

    local function narrow(run)
        return s8(program.random(run,program.randomNarrow))
    end

    local function shake(run)
        return program.hovercraftRandom[program.nextRandom(run,127)]
    end

    function M.begin(o)
        o.coversHidden=true
        o.run.boss6Defeated=true
        o.run.boss6EscortCue=2
        for _,offset in ipairs(data.wreckOffsets) do effects.emit(o,0x8b,0,0,offset,false,0) end
    end

    local function smoke(o,row,offset)
        local kind,position,flags,speed,angle,delay=unpack(row)
        local run=o.run
        speed=band(speed+floor(narrow(run)/2),255)
        angle=band(angle+narrow(run),255)
        if offset then angle=program.random(run,program.randomByte) end
        effects.emit(o,kind,speed,angle,offset or position,band(flags,2)~=0,delay)
    end

    local function largeBlast(o,t)
        local run=o.run
        t.blastClock=band(t.blastReload+2*narrow(run),255)
        program.nextRandom(run)
        local center=data.blastCenters[program.nextRandom(run,3)]
        for _,row in ipairs(data.largeBlast) do
            local h,l=program.addPacked(0,0,row[2])
            local offset=center+s16(h+floor(shake(run)/2))*0x10000+band(l+floor(shake(run)/2),0xffff)
            smoke(o,row,offset)
        end
        local queue=run.spawnQueue
        for _=1,program.nextRandom(run,1)+1 do
            queue[#queue+1]={[3]=0x4a,[4]=0,[10]=0x1af1b2,h=0x7800,l=s16(0x1c00+shake(run))}
        end
        if t.lightReload>3 then t.blastReload,t.lightReload=t.blastReload-4,t.lightReload-1 end
    end

    local function burn(o,t)
        t.blastClock=t.blastClock-1
        if t.blastClock<0 then largeBlast(o,t) end
        t.lightClock=t.lightClock-1
        if t.lightClock<0 then
            t.lightClock=t.lightReload
            smoke(o,data.lightSmoke[t.lightIndex])
            t.lightIndex=t.lightIndex%#data.lightSmoke+1
        end
        if t.lightReload>3 then return end
        t.heavyClock=t.heavyClock-1
        if t.heavyClock>=0 then return end
        t.heavyClock=1
        smoke(o,data.heavySmoke[t.heavyIndex])
        t.heavyIndex=t.heavyIndex%#data.heavySmoke+1
        t.heavyRemaining=t.heavyRemaining-1
        if t.heavyRemaining==0 then
            o.draws={}
            tasks.clear(o.aux)
            t.phase,t.clock=2,9
        end
    end

    local function wreck(o,t)
        if t.phase==1 then burn(o,t); return end
        t.clock=t.clock-1
        if t.clock>0 then return end
        if t.phase==2 then t.phase,t.clock=3,8
        elseif t.phase==3 then
            t.phase,t.clock=4,0x80
            o.run.boss6EscortDepart=true
        else
            o.run.boss6=nil
            o.retired=true
        end
    end

    M.event={function(o,t)
        t.phase=1
        t.blastClock,t.blastReload=0x40,0x40
        t.lightClock,t.lightReload,t.lightIndex=0,7,1
        t.heavyClock,t.heavyRemaining,t.heavyIndex=0,0x20,1
    end,wreck}

    local Debris={parts=1}
    function Debris.init(o)
        local run=o.run
        o.h,o.l,o.flags=o.row.h,o.row.l,0x8000
        o.pose=program.nextRandom(run,31)-1
        o.poseReload=1+s8(program.random(run,data.signs))
        o.speedReload=program.nextRandom(run,7)
        o.variant=program.nextRandom(run,3)
        o.poseClock,o.speedClock,o.speed=0,0,0
        return true
    end

    function Debris.step(o)
        local dh,dl=program.vector(o.speed,0x80,o.run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if o.h<0 then return false end
        o.poseClock,o.speedClock=o.poseClock-1,o.speedClock-1
        if o.poseClock<0 then o.poseClock,o.pose=o.poseReload,(o.pose-1)%32 end
        if o.speedClock<0 then o.speedClock,o.speed=o.speedReload,o.speed+1 end
        return true
    end

    function Debris.render(o)
        if not o.run.art then return end
        local narrowBoard=o.variant==2
        local images=narrowBoard and data.images.wreckNarrow or data.images.wreckWide
        art.draw(o.run.art.sprites[images[o.pose+1]],o.h,o.l,-0x800,narrowBoard and -0x500 or -0x600)
    end

    M.debris=Debris
    return M
end
