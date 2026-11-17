-- 0x19319e 先运行 0x13aaec 的任务，再由 0x193412 汇总各部件的伤害。
return function(program,bullets,art,effects)
    local directory = 'mod/GAME/th45/native/'
    local tasks = dofile('mod/GAME/th44/native/boss_tasks.lua')
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local s16 = program.s16
    local data = program.boss3
    local H = {parts=10}

    local function positionParts(o)
        o.extraParts[1].h,o.extraParts[1].l = o.h,o.l
        o.extraParts[2].h,o.extraParts[2].l = o.h,o.l
        o.anchorH,o.anchorL = s16(o.h+0xe00),o.l
        if not o.chainH or o.run.freeze then return end
        local distanceH = math.abs(s16(o.chainH-o.chainTargetH))
        local distanceL = math.abs(s16(o.chainL-o.chainTargetL))
        distanceH = distanceH-math.floor(distanceH/4)
        local d = math.max(distanceH,distanceL)+math.floor(math.min(distanceH,distanceL)/2)
        local profile = data.chainSpeed[o.chainProfile]
        local speed = profile.maximum
        for _,row in ipairs(profile.limits) do
            if d<=row[1] then speed=row[2]; break end
        end
        o.chainSpeedClock = o.chainSpeedClock-1
        if o.chainSpeedClock<0 then
            o.chainSpeedClock = o.chainSpeedPeriod
            if o.chainSpeed<speed then o.chainSpeed=o.chainSpeed+1
            elseif o.chainSpeed>speed then o.chainSpeed=o.chainSpeed-1 end
        end
        local a = program.angle8(o.chainH,o.chainL,{h=o.chainTargetH,l=o.chainTargetL,active=true},0)
        local dh,dl = program.vector(o.chainSpeed,a,o.run.slowVectors)
        o.chainH,o.chainL = s16(o.chainH+dh),s16(o.chainL+dl-o.run.cameraStep)
    end

    local motion,distance = dofile(directory..'boss3_motion.lua')(program,tasks.attach,positionParts)
    local aux,events,attacks = dofile(directory..'boss3_tasks.lua')(program,bullets,effects,tasks,distance)

    function H.init(o)
        o.h,o.l = 0,s16(0x1c00-o.run.cameraOffset)
        o.phase,o.health,o.protected = 0,data.health[1],true
        o.clocks = {unpack(data.timeout)}
        o.extraParts = {}
        for i=1,H.parts do
            local p = i==1 and o or {flags=0x8000,h=0,l=0}
            if data.parts[i] then p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(data.parts[i]) end
            if i>1 then o.extraParts[i-1] = p end
        end
        o.mainFrame,o.engineFrame,o.doorFrame,o.spin,o.engineSpin = 0,0,0,1,1
        o.palettes = {16,16,18}
        o.draws = {[0]=true,[1]=true}
        o.aux = {limit=25,unique=true,handlers=aux,label='三面关底短任务'}
        o.events = {limit=5,handlers=events,label='三面关底事件'}
        o.attacks = {limit=20,handlers=attacks,label='三面关底攻击'}
        o.run.boss3 = o
        tasks.attach(o.events,0)
        positionParts(o)
        return true
    end

    local function phaseChange(o)
        local phase = o.phase
        o.phase,o.protected = phase+1,true
        o.palettes[1],o.palettes[2],o.palettes[3] = 15,16,18
        tasks.clear(o.events)
        tasks.clear(o.attacks)
        bullets.clear(o.run,1)
        o.chainLinksFire,o.chainVolley = nil,0
        if phase==0 then
            o.extraParts[2].flags = 0x8000
            effects.emitSequence(o,data.phaseOneBlast)
        elseif phase==1 then
            o.extraParts[2-phase].flags = 0x8000
            o.draws[4] = nil
            effects.emitSequence({run=o.run,h=s16(o.h-0x800),l=o.l},data.phaseTwoBlast)
        else
            o.dying,o.flags = true,0x8000
        end
        tasks.attach(o.events,phase+1)
    end

    local function damage(o)
        if o.dying then return end
        local total,hit = o.damage or 0,o.impact
        o.impact,o.damage,o.hp = nil,0,0x7fff
        for index=1,2-o.phase do
            local p = o.extraParts[index]
            total,hit = total+(p.damage or 0),hit or p.impact
            p.impact,p.damage,p.hp = nil,0,0x7fff
        end
        if o.phase==0 and o.chain and (o.chain.damage or 0)>0 then
            total,hit,o.chain.damage = total+o.chain.damage,true,0
        end
        local palettes = o.palettes
        if hit then
            palettes[1] = bxor(palettes[1]==25 and 15 or palettes[1],0x10)
            palettes[2] = bxor(palettes[2]==25 and 16 or palettes[2],0xf)
            palettes[3] = bxor(palettes[3]==25 and 18 or palettes[3],0xd)
            if not o.protected then
                o.health = o.health-band(total,0xffff)
                local threshold = o.phase==0 and data.health[1]-data.health[2] or o.phase==1 and data.health[4] or 0
                if o.health<=threshold then
                    if o.phase==2 and not (o.run.player and o.run.player.active) then o.health=0x200
                    else phaseChange(o) end
                end
            end
        else
            local threshold = o.phase==0 and 0x41726 or o.phase==1 and 0x20c8c or 0x7e43
            palettes[1],palettes[2],palettes[3] = 15,16,18
            if o.health<=threshold and not o.run.blockEnemyFire then
                palettes[1],palettes[2],palettes[3] = 25,25,25
            end
        end
    end

    function H.step(o)
        if o.finished then
            o.run.boss3,o.run.stageCleared = nil,true
            return false
        end
        local run = o.run
        if not run.freeze and not run.stopPathClock then
            tasks.tick(o,o.aux)
            tasks.tick(o,o.events)
        end
        if not run.stopPathClock then
            local pending = o.nextMotion
            if pending then
                o.nextMotion = nil
                if not o.move or o.move.index~=pending.index then
                    o.move = pending
                    motion[pending.index][1](o,pending)
                else motion[o.move.index][2](o,o.move) end
            elseif o.move then motion[o.move.index][2](o,o.move) end
        end
        if not run.freeze then tasks.tick(o,o.attacks) end
        damage(o)
        if not o.dying and not run.freeze and not run.stopPathClock then
            local clock = o.phase+1
            o.clocks[clock] = o.clocks[clock]-1
            if o.clocks[clock]==0 then
                if run.player and run.player.active then phaseChange(o)
                else o.clocks[clock]=0x78 end
            end
        end
        return true
    end

    function H.render(o)
        local assets = o.run.art
        if not assets then return end
        local function draw(part,palette,frame,offset)
            local bank = data.images[part]
            local h,l = program.addPacked(o.h,o.l,offset)
            art.draw(assets.sprites[(bank[palette] or bank[31])[frame+1]],h,l,0,0)
        end
        local draws,palettes = o.draws,o.palettes
        if draws[0] then draw('engine',palettes[2],o.engineFrame,0xfc00e200) end
        if draws[1] then draw('hull',palettes[1],o.mainFrame,0xe600ec00) end
        if draws[2] then draw('openHull',palettes[1],o.doorFrame,0xe000e400) end
        if draws[3] then draw('wing',palettes[3],o.mainFrame,0xe800e600) end
        if draws[4] then draw('openWing',palettes[3],o.mainFrame,0xe000f500) end
    end

    return H
end
