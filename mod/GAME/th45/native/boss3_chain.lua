-- 0x195426 用 96 个历史点定位 12 节炮链，末节上的炮口跟随原版炮链而非本体。
return function(program,bullets,art,effects)
    local bit = require('bit')
    local band = bit.band
    local floor,ceil = math.floor,math.ceil
    local s16 = program.s16
    local data = program.boss3
    local H = {parts=1}

    local function divide12(value)
        return value<0 and ceil(value/12) or floor(value/12)
    end

    function H.init(o)
        local boss = o.row.boss
        o.boss,o.h,o.l,o.flags = boss,boss.h,boss.l,0x8000
        o.front,o.back,o.left,o.right,o.hp = 0,0x800,0x600,0x600,0x7fff
        o.history,o.links = {},{}
        for i=1,96 do o.history[i] = {h=o.h,l=o.l} end
        for i=1,12 do o.links[i] = {h=o.h,l=o.l} end
        o.angle,o.guard,o.palette = 0x80,0x60,17
        boss.chain = o
        return true
    end

    local function emit(o,kind,speed,angle,port,muzzle)
        local h,l = s16(port.h+floor(muzzle/0x10000)),s16(port.l+muzzle)
        return bullets.emit(o.boss,kind,speed,angle,s16(h-o.boss.h),s16(l-o.boss.l),true)
    end

    local function updateLinks(o)
        local boss = o.boss
        local history = o.history
        local point = history[96]
        for i=96,2,-1 do
            local previous = history[i-1]
            history[i] = previous
            previous.l = s16(previous.l-o.run.cameraStep)
        end
        history[1],point.h,point.l = point,boss.chainH,boss.chainL
        for i,p in ipairs(o.links) do
            local sample = history[1+(i-1)*8]
            p.h = s16(boss.anchorH+divide12(s16(sample.h-boss.anchorH))*(i-1))
            p.l = s16(boss.anchorL+divide12(s16(sample.l-boss.anchorL))*(i-1))
        end
        o.h,o.l = o.links[12].h,o.links[12].l
    end

    local function aimHead(o,player)
        local aim = program.angle8(o.h,o.l,player,o.angle)
        local delta = program.s8(aim-o.angle)
        o.angle = band(o.angle+math.max(-2,math.min(2,delta)),255)
    end

    local function fan(o)
        o.fireClock = o.fireClock-1
        if o.fireClock>=0 then return end
        o.fireClock = 4
        for ray=0,4 do
            local a = band(o.fireAngle-0x30+ray*0x18,255)
            emit(o,14,0,a,o,program.stage3Heavy.muzzle[floor(band(a+2,0xfc)/4)+1])
        end
        o.fireCount = o.fireCount-1
        if o.fireCount==0 then o.boss.chainVolley=0 end
    end

    local function linksFire(o)
        local b = o.boss
        if not b.chainLinksFire then o.linkAttack=nil; return end
        local t = o.linkAttack
        if not t then
            t = {delay=8,clock=0,count=0,reload=6,index=11,angle=0x10,turn=0}
            o.linkAttack = t
        end
        if t.count==0 then
            t.delay = t.delay-1
            if t.delay>=0 then return end
            t.delay,t.count,t.reload = 8,t.reload,t.reload+1
            t.angle = program.random(o.run,program.randomByte)
        end
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = 2
        for ray=0,7 do
            local a = band(t.angle+ray*0x20,255)
            if a>=0x44 and a<=0xbc then
                emit(o,0x18,-3,a,o.links[t.index],data.chainRingMuzzles[floor(band(a+2,0xfc)/4)+1])
            end
        end
        t.angle,t.count = band(t.angle+t.turn,255),t.count-1
        if t.count==0 then
            t.turn,t.index = -t.turn,t.index-1
            if t.index<7 then t.index,t.reload=11,6 end
        end
    end

    local function breakLinks(o)
        o.flags = 0x8000
        if not o.breakLink then o.breakLink,o.breakClock=12,0x20 end
        o.breakClock = o.breakClock-1
        if o.breakClock>=0 then return true end
        o.breakClock = 4
        local p = o.links[o.breakLink]
        local origin = {run=o.run,h=p.h,l=p.l}
        for i,kind in ipairs({0x85,4}) do
            local offset = program.debrisOffsets[program.nextRandom(o.run,63)][1]
            program.nextRandom(o.run)
            local angle = o.angle+program.s8(program.random(o.run,program.randomNarrow))*2
            effects.emit(origin,kind,i==1 and 0x1c or 0x24,angle,offset,false)
        end
        p.broken,o.breakLink = true,o.breakLink-1
        return o.breakLink>0
    end

    local function spiral(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock,t.angle = 3,band(t.angle+t.turn,255)
        local dh,dl = program.vector(0x80,t.angle)
        local offset = floor(dh/8)*0x10000+band(dl,0xffff)
        emit(o,13,-10,t.angle,o,offset)
        emit(o,13,-8,t.angle+0x20,o,offset)
    end

    local function rows(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = 4
        local flip = t.flip
        for i=1,t.ports do
            local angle = t.angle+(flip and 0x80 or 0)
            local p = o.links[4+i]
            emit(o,0x18,t.speeds[i],angle+4,p,flip and -0x800000 or 0x4800000)
            emit(o,0x18,t.speeds[i],angle-4,p,flip and 0x4800000 or -0x800000)
            t.speeds[i] = math.min(2,t.speeds[i]+2)
            flip = not flip
        end
        if t.cycles==1 then
            t.angle = t.angle+t.turn
            if t.angle<0x32 or t.angle>0x4c then t.turn=-t.turn end
        end
        t.count = t.count-1
        if t.count==0 then
            t.ports,t.cycles = t.ports+1,t.cycles-1
            t.count = t.cycles==1 and 0x1c or 4
            if t.cycles==0 then o.boss.chainVolley=0 end
        end
    end

    function H.step(o)
        local boss,run = o.boss,o.run
        if run.enemies[boss.slot]~=boss then return false end
        if o.guard>0 then
            o.guard = o.guard-1
            if o.guard==0 then o.flags=0xa000 end
        end
        if not run.freeze and boss.phase>0 and not breakLinks(o) then
            boss.chain = nil
            return false
        end
        o.palette = o.impact and (o.palette==17 and 31 or 17) or 17
        o.impact,o.hp = nil,0x7fff
        if not run.freeze then
            updateLinks(o)
            local mode = boss.chainVolley
            if mode~=o.mode then
                o.mode = mode
                if mode==2 then
                    o.fireClock,o.fireCount = 0,4
                    o.fireAngle = program.angle(o.h,o.l,run.player,0x20)*4
                elseif mode==3 then
                    o.formation = {clock=0x40,angle=program.random(run,program.randomHalf,127),
                        turn=program.random(run,program.randomByte)>=0x80 and -2 or 2}
                elseif mode==4 then
                    o.formation = {clock=0,angle=0x40,turn=2,ports=1,cycles=8,count=4,
                        flip=program.s8(program.random(run,program.boss2.finalTurn))<0,speeds={-8,-8,-8,-8,-8,-8,-8,-8}}
                end
            end
            linksFire(o)
            if mode==2 then fan(o) end
            if mode==3 then spiral(o,o.formation) end
            if mode==4 then rows(o,o.formation) end
            if not mode or mode==0 then aimHead(o,run.player) end
        end
        return true
    end

    function H.render(o)
        local assets = o.run.art
        if not assets then return end
        local images,palette = data.images,o.palette
        for i,p in ipairs(o.links) do
            if not p.broken then
                local frame = i==12 and floor(o.angle/2)+1 or 1
                local id = (i==12 and images.chainHead or images.chainLink)[palette][frame]
                art.draw(assets.sprites[id],p.h,p.l,i==12 and -0xc00 or -0x600,i==12 and -0xa00 or -0x500,
                    i==12 and o.angle>=0x80)
            end
        end
    end

    return H
end
