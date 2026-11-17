-- 0x1af618 先处理受击，再推进部件、事件、移动与攻击任务。
return function(program,bullets,effects,art)
    local tasks = dofile('mod/GAME/th44/native/boss_tasks.lua')
    local directory = 'mod/GAME/th45/native/'
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local abs,floor,min,max = math.abs,math.floor,math.min,math.max
    local s16 = program.s16
    local M = {parts=13}
    local hitParts = {1,2,3,4,8,9,10}
    local damageParts = {{8,9,10},{1,3},{2,4}}
    local direct = {}

    local function stepMotion(o)
        if o.run.freeze then return end
        local dh,dl = program.vector(o.speed,o.direction * 4,o.run.slowVectors)
        o.h,o.l = s16(o.h + dh),s16(o.l + dl)
    end

    local function positionParts(o)
        for _,part in ipairs(o.extraParts) do
            part.h,part.l = program.addPacked(o.h,o.l,part.offset)
        end
    end

    local handlers = dofile(directory .. 'mid1_tasks.lua')(program,bullets,effects,tasks)
    M.render = dofile(directory .. 'mid1_art.lua')(program,art)

    local function enable(o,...)
        for i = 1,select('#',...) do o.drawParts[select(i,...)] = true end
    end

    function M.init(o)
        local data = program.mid1
        o.extraParts,o.drawParts = {},{}
        for index,row in ipairs(data.parts) do
            local flags,front,back,right,left,hp,offset = unpack(row)
            o.extraParts[index] = {flags=flags,front=front,back=back,right=right,left=left,hp=hp,
                offset=offset,h=o.h or 0,l=o.l or 0,run=o.run}
        end
        o.flags,o.h,o.l = 0x8000,0,0
        o.health = {data.coreHP,data.wingHP,data.wingHP}
        o.palette = {19,19,19}
        o.wingLost,o.wingCount,o.deathWingCount = {},0,0
        o.hatch = {0,0}
        o.tailFrame,o.engineFrame,o.hullFrame,o.roll = 0,0,0,0
        o.cannonAim = {0x20,0x20}
        o.cannonLoops,o.cannonLength,o.cannonRate = 0,0,0
        o.ringSpeed = 0
        o.speed,o.direction,o.clock = 0,0,data.timeout
        o.aux = {handlers=handlers.aux,limit=25,unique=true,label='Espgaluda 中 Boss 部件'}
        o.events = {handlers=handlers.events,limit=5,label='Espgaluda 中 Boss 事件'}
        o.attacks = {handlers=handlers.attacks,limit=20,label='Espgaluda 中 Boss 攻击'}
        o.targetPhase = nil
        tasks.attach(o.events,0)
        o.run.midBoss,o.run.stageFlags[0],o.run.bulletCapacity = o,true,110
        return true
    end

    -- 0x1b0d52 从右下掠过。首轮绘图只登记压缩机身。
    direct[0] = {function(o)
        o.phaseClock,o.warningFrame,o.warningClock = 0x60,0x7c,0x10
        o.speed,o.direction = 0x60,0x37
        o.h,o.l = 0x1400,s16(0x4600 - o.run.cameraOffset)
    end,function(o)
        if not o.run.stopPathClock then
            if o.warningFrame > 0 then
                o.warningClock = o.warningClock - 1
                if o.warningClock < 0 then o.warningFrame,o.warningClock = o.warningFrame - 4,0 end
            end
            o.phaseClock = o.phaseClock - 1
            if o.phaseClock == 0 then
                o.drawParts[11] = nil
                enable(o,12)
                tasks.stop(o.aux,6)
                o.targetPhase = 7
            end
        end
        if o.phaseClock >= 0x38 or o.run.stopPathClock then stepMotion(o) end
    end}

    -- 0x1b0dfa、0x1b0e88、0x1b0f16 共享移动规则，各自使用独立的边界。
    local function wander(index)
        return {function(o) o.wanderAim = nil end,function(o)
            stepMotion(o)
            if o.wanderAim then
                o.direction = program.towards(o.direction,o.wanderAim)
                if o.direction == o.wanderAim then o.wanderAim = nil end
            end
            local bounds = program.mid1.wander[index]
            local angle = program.random(o.run,program.randomNarrow)
            local low,high = bounds[1],bounds[2]
            if o.run.major >= 0x125 and o.run.major < 0x140 then low,high = bounds[5],bounds[6] end
            local l = band(o.l + 0x2800,0xffff)
            if l < low then angle = angle + 0x10
            elseif l >= high then angle = angle + 0x30
            elseif o.h >= bounds[4] then angle = angle + 0x20
            elseif o.h >= bounds[3] then return end
            o.wanderAim = band(angle,63)
        end}
    end
    for i = 1,3 do direct[i] = wander(i) end

    direct[5] = {function(o) o.speed,o.direction = 0xa,0 end,function(o)
        stepMotion(o)
        if band(o.h + 0x1e00,0xffff) >= 0xac00 then o.finished = true end
    end}

    direct[6] = {function(o)
        o.speed,o.direction,o.accelClock = 2,0x20,0x10
    end,function(o)
        if o.speed < 0x18 and not o.run.stopPathClock then
            o.accelClock = o.accelClock - 1
            if o.accelClock < 0 then o.speed,o.accelClock = o.speed + 1,8 end
        end
        stepMotion(o)
    end}

    local function finishApproach(o)
        o.drawParts[12] = nil
        o.speed = 6
        for _,index in ipairs(hitParts) do o.extraParts[index].flags = 0xa001 end
        enable(o,0,5,4,7,6,1,10,2,3)
        for _,index in ipairs({5,4,8,9}) do tasks.attach(o.aux,index) end
        tasks.attach(o.events,5)
    end

    -- 0x1b1036 从上方转向并缩回缩放表，表走完才开放七处判定。
    direct[7] = {function(o)
        o.speed,o.direction,o.h = 0x1e,0x20,0x7c00
        o.l = s16(0xc00 - o.run.cameraOffset)
        o.roll,o.rollClock,o.approachBrakeClock = 0x114,8,1
    end,function(o)
        if o.run.stopPathClock then stepMotion(o); return end
        local l = 0x1c00 - o.run.cameraOffset
        local aim = program.angle(o.h,o.l,{h=0x5400,l=l,active=true},o.direction)
        o.direction = program.towards(o.direction,aim)
        stepMotion(o)
        local dh,dl = abs(o.h - 0x3800),abs(o.l - l)
        dh = dh - floor(dh / 4)
        if max(dh,dl) + floor(min(dh,dl) / 2) <= 0x1800 then
            o.approachBrakeClock = o.approachBrakeClock - 1
            if o.approachBrakeClock < 0 then
                o.approachBrakeClock,o.speed = 1,max(0,o.speed - 1)
            end
        end
        o.rollClock = o.rollClock - 1
        if o.rollClock < 0 then
            o.rollClock = 1
            o.roll = o.roll - 0xc
            if o.roll == -0xc then finishApproach(o) end
        end
    end}

    local function breakWing(o,index)
        if o.wingLost[index] then return end
        o.wingLost[index] = true
        o.health[index + 1] = -1
        o.palette[index + 1] = 19
        for _,slot in ipairs(damageParts[index + 1]) do o.extraParts[slot].flags = 0x8000 end
        tasks.attach(o.events,index)
    end

    local function breakCore(o)
        bullets.clear(o.run,0xb0)
        tasks.clear(o.aux)
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        o.dying,o.health[1],o.palette[1],o.targetPhase = true,-1,19,6
        for _,index in ipairs(hitParts) do o.extraParts[index].flags = 0x8000 end
        for wing = 1,2 do
            if not o.wingLost[wing] then
                o.deathWingCount = o.deathWingCount + 1
                if wing == 2 and (o.recoil or 0) > 0 then
                    o.recoil,o.recoilAngle = 0x18,0
                else
                    o.recoil,o.recoilAngle = 0x1e,wing == 1 and 0xc0 or 0x40
                end
                breakWing(o,wing)
            end
        end
        tasks.attach(o.events,3)
    end

    local function takeDamage(o)
        for group,indices in ipairs(damageParts) do
            if o.health[group] >= 0 then
                local damage,hit = 0,false
                for _,index in ipairs(indices) do
                    local part = o.extraParts[index]
                    if part.impact then hit = true end
                    damage = damage + (part.damage or 0)
                end
                if hit then
                    for _,index in ipairs(indices) do
                        local part = o.extraParts[index]
                        part.hp,part.damage,part.impact = 0x7fff,0,nil
                        part.flags = band(part.flags,0xa6ff)
                    end
                    o.palette[group] = bxor(o.palette[group] == 25 and 19 or o.palette[group],0xc)
                    if not o.protected then
                        o.health[group] = o.health[group] - band(damage,0xffff)
                        if o.health[group] < 0 then
                            if group == 1 then breakCore(o); break end
                            breakWing(o,group - 1)
                            o.health[1] = o.health[1] - floor(o.health[1] / 4)
                            bullets.clear(o.run,0x20)
                            o.recoil,o.recoilAngle = 0x1e,group == 2 and 0xc0 or 0x40
                            handlers.onWingLost(o)
                        end
                    end
                else
                    local low = group == 1 and 0x4800 or 0x1599
                    o.palette[group] = o.health[group] < low and band(o.run.frame,15) < 2 and 25 or 19
                end
            end
        end
        o.wingCount = (o.wingLost[1] and 1 or 0) + (o.wingLost[2] and 1 or 0)
    end

    local function advanceDamageState(o)
        if o.recoil and o.recoil > 0 then
            local dh,dl = program.vector(o.recoil,o.recoilAngle)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
            o.recoil = o.recoil - 1
        end
        if not o.run.stopPathClock and not o.run.freeze and o.clock > 0 then
            o.clock = o.clock - 1
            if o.clock == 0 and not o.dying then tasks.attach(o.events,9) end
        end
    end

    function M.step(o)
        if o.finished then o.run.midBoss,o.run.stageFlags[0] = nil,false; return false end
        local wasDying = o.dying
        if not o.dying then takeDamage(o) end
        if not o.dying or wasDying then advanceDamageState(o) end
        local run = o.run
        if not run.stopPathClock then
            tasks.tick(o,o.aux)
            if not run.freeze then tasks.tick(o,o.events) end
        end
        local newPhase = o.targetPhase
        o.targetPhase = nil
        if newPhase and newPhase ~= o.phase then
            o.phase = newPhase
            local init = direct[newPhase][1]
            init(o)
        end
        if o.phase then direct[o.phase][2](o) end
        positionParts(o)
        if not run.stopPathClock then tasks.tick(o,o.attacks) end
        return true
    end

    return M
end
