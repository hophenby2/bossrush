-- 0x1931d4 负责更换攻击与机动，0x19190a 负责部件动作。
return function(program, bind, position, effects)
    local bit = require('bit')
    local band = bit.band
    local min, max = math.min, math.max
    local attach, stop, contains, phase = bind.attach, bind.stop, bind.contains, bind.phase
    local s16, vector = program.s16, program.vector
    local data = program.boss1
    local components, directors = {}, {}

    local function finish(o, bank, clock)
        o[bank][clock.slot] = nil
    end

    local function countdown(clock, key, reload)
        clock[key] = clock[key] - 1
        if clock[key] >= 0 then return false end
        clock[key] = reload
        return true
    end

    local function noTasks(bank, indices)
        for _, index in ipairs(indices) do
            if contains(bank, index) then return false end
        end
        return true
    end

    local function bothWingsGone(o)
        return o.wings[1].broken and o.wings[2].broken
    end

    local function steerTail(o, clock)
        local p = o.run.player
        if not p or not p.active then return end
        clock.track = clock.track - 1
        if clock.track >= 0 then return end
        clock.track = 2
        local from = o.tail.pitch + 0x20
        local aim = program.angle(o.tail.h,o.tail.l,p.h,p.l,from)
        local target = max(0x19,min(0x27,aim))
        if target ~= from then o.tail.pitch = o.tail.pitch + (target < from and -1 or 1) end
    end

    directors[0] = {
        function(_, clock) clock.wait=0xc0 end,
        function(o, clock)
            clock.wait = clock.wait - 1
            if clock.wait == 0 then phase(o,0); finish(o,'directors',clock) end
        end,
    }

    -- 0x19326e。先等本体炮组，炮翼在同一时间轴上交替瞄准。
    directors[1] = {
        function(o, clock)
            phase(o,5)
            -- 初始化落入第一次更新，0x10 的倒数当场消费一次。
            clock.stage, clock.wait, clock.wingClock, clock.wingGap, clock.side = 0, 0xf, 0x60, 0x2c, 1
            o.aimTier, o.rapidTier, o.spanTier = o.aimTier or 0, o.rapidTier or 0, o.spanTier or 0
            o.lateTier, o.pairTier = o.lateTier or 0, o.pairTier or 0
            clock.mainCount = min(0x80, 0x30 + o.aimTier)
            clock.mainGap = max(3, 4 - o.rapidTier)
            clock.pairGap, clock.pairSpeed = min(4, o.pairTier), min(0x20, -2 + o.spanTier)
            o.aimTier, o.rapidTier = min(0x80, o.aimTier + 2), max(3, o.rapidTier - 1)
            o.pairTier, o.spanTier = min(4, o.pairTier + 1), min(0x20, o.spanTier + 2)
        end,
        function(o, clock)
            local attacks = o.attacks
            if clock.stage == 0 and not contains(attacks,1) and countdown(clock,'wait',0) then
                clock.stage = 1
                attach(attacks,1,{clock=0,gap=clock.mainGap,count=clock.mainCount,modifier=o.lateTier})
                o.lateTier = min(0xc, o.lateTier + 2)
            end
            if clock.stage == 1 and noTasks(attacks,{3,4}) then
                if not contains(attacks,1) then
                    clock.stage, clock.volleyWait = 2, band(0x20 + program.bossRandom(o.run), 0xff)
                elseif countdown(clock,'wingClock',clock.wingGap) then
                    attach(attacks,clock.side + 2,{count=4,mode=0,modifier=0})
                    clock.side = 3 - clock.side
                    if clock.side == 1 then clock.pairGap = min(4, clock.pairGap + 1) end
                end
            end
            if clock.stage == 2 then
                clock.volleyWait = clock.volleyWait - 1
                if clock.volleyWait == 0 and noTasks(attacks,{3,4}) then
                    local gap = program.bossSmallRandom(o.run) + 1
                    for i = 3, 4 do attach(attacks,i,{count=8,mode=gap,modifier=clock.pairSpeed}) end
                    clock.stage = 3
                end
            end
            if clock.stage == 3 and noTasks(attacks,{1,3,4}) then
                attach(o.directors,3)
                finish(o,'directors',clock)
            end
        end,
    }

    local function wingCycleInit(target)
        return function(o, clock)
            if bothWingsGone(o) then
                if target == 8 then attach(o.directors,1) else attach(o.directors,6) end
                finish(o,'directors',clock)
                return
            end
            clock.stage = 0
            phase(o,target)
        end
    end

    -- 0x193538。先让两翼伸展，再让中炮独立完成攻击，最后收起两翼。
    directors[2] = {wingCycleInit(8),function(o, clock)
        if bothWingsGone(o) then attach(o.directors,1); finish(o,'directors',clock); return end
        if clock.stage == 0 and o.phase == 4 then
            attach(o.components,8); attach(o.components,9)
            clock.stage = 1
        end
        if clock.stage == 1 and noTasks(o.components,{8,9}) then clock.stage, clock.wait = 2, 0x10 end
        if clock.stage == 2 then
            clock.wait = clock.wait - 1
            if clock.wait == 0 then attach(o.components,14); clock.stage = 3 end
        end
        if clock.stage == 3 and not contains(o.components,14) then
            attach(o.components,12); attach(o.components,13)
            phase(o,5)
            clock.stage = 4
        end
        if clock.stage == 4 and noTasks(o.components,{12,13}) and not contains(o.attacks,2) then
            attach(o.components,15)
            attach(o.directors,1)
            finish(o,'directors',clock)
        end
    end}

    -- 0x19366c。较低位置使翼板向内伸展，停顿后由炮翼各自发射。
    directors[3] = {wingCycleInit(3),function(o, clock)
        if bothWingsGone(o) then attach(o.directors,6); finish(o,'directors',clock); return end
        if clock.stage == 0 and o.phase == 4 then
            attach(o.components,16); attach(o.components,17)
            clock.stage = 1
        end
        if clock.stage == 1 and noTasks(o.components,{8,9}) then clock.stage, clock.wait = 2, 0x40 end
        if clock.stage == 2 then
            clock.wait = clock.wait - 1
            if clock.wait == 0 then
                attach(o.attacks,8); attach(o.components,18); attach(o.components,19)
                clock.stage, clock.wait = 3, 0x40
            end
        elseif clock.stage == 3 then
            clock.wait = clock.wait - 1
            if clock.wait == 0 then
                program.bossSmallRandom(o.run)
                phase(o,5)
                clock.stage = 4
            end
        end
        if clock.stage == 4 and noTasks(o.attacks,{7,9,10}) then
            attach(o.directors,6); finish(o,'directors',clock)
        end
    end}

    directors[4] = {
        function(_, clock) clock.stage, clock.wait, clock.count = 0, 0x7f, 4 end,
        function(o, clock)
            if clock.stage == 0 then
                clock.wait = clock.wait - 1
                if clock.wait ~= 0 then return end
                clock.stage, clock.wait = 1, 0x40
            end
            local attack = clock.stage == 1 and 11 or 12
            if not contains(o.attacks,attack) then
                if clock.count == 0 then
                    clock.stage, clock.count = 3 - clock.stage, 4
                    clock.wait = clock.stage == 1 and 0x40 or 0x60
                elseif countdown(clock,'wait',clock.stage == 1 and 0x40 or 0x60) then
                    attach(o.attacks,attack)
                    clock.count = clock.count - 1
                end
            end
        end,
    }

    directors[5] = {
        function(_, clock) clock.wait=0x3f end,
        function(o, clock)
            if not contains(o.attacks,0) and countdown(clock,'wait',4) then attach(o.attacks,0) end
        end,
    }

    directors[6] = {
        function(o, clock)
            clock.stage, clock.fireClock, clock.volley, clock.interval, clock.speed = 0, 0x70, 0xd, 0x50, 1
            clock.track = 2
            clock.speedStep, clock.count = 4, min(5, 3 + (o.tailTier or 0))
            o.tailTier = min(5,(o.tailTier or 0) + 1)
            phase(o,6)
        end,
        function(o, clock)
            if clock.stage == 0 and o.phase == 7 then
                stop(o.components,7); attach(o.components,20)
                program.bossSmallRandom(o.run)
                clock.fireClock, clock.stage = 0x70, 1
                program.bossRandom(o.run)
            end
            if clock.stage == 1 then steerTail(o,clock) end
            if clock.stage == 1 and not contains(o.attacks,13) and countdown(clock,'fireClock',clock.interval) then
                clock.interval = clock.interval - 8
                attach(o.attacks,13,{modifier=clock.volley,count=clock.speed,delta=clock.speedStep})
                clock.volley, clock.speed, clock.speedStep = clock.volley + 4, clock.speed + 1, clock.speedStep + 2
                clock.count = clock.count - 1
                if clock.count == 0 then clock.stage, clock.wait = 2, 0x50 end
            end
            if clock.stage == 2 and not contains(o.attacks,13) then
                clock.wait = clock.wait - 1
                if clock.wait == 0 then
                    attach(o.components,15); stop(o.components,20); attach(o.components,7)
                    attach(o.directors,2)
                    finish(o,'directors',clock)
                end
            end
        end,
    }

    local function wingShake(i)
        return {
            function(o, clock)
                clock.h, clock.l = program.bossWideRandom(o.run), program.bossWideRandom(o.run)
            end,
            function(o, clock)
                local wing = o.wings[i]
                if wing.broken then finish(o,'components',clock); return end
                local dh = vector(2, clock.h)
                local _, dl = vector(1, clock.l)
                wing.offsetH, wing.offsetL = s16(wing.offsetH + dh), s16(wing.offsetL + dl)
                clock.h, clock.l = band(clock.h + 2,0xff), band(clock.l + 1,0xff)
            end,
        }
    end

    local function wingPropeller(i)
        return {
            function(_, clock) clock.wait=0 end,
            function(o, clock)
                local wing = o.wings[i]
                if wing.broken then finish(o,'components',clock); return end
                wing.form = wing.form < 3 and wing.form + 1 or 0
            end,
        }
    end

    local function wingBreak(i)
        return {
            function(_, clock)
                clock.phase, clock.wait, clock.gap, clock.drop, clock.zoom = 0, 0x10, 8, 0, 0x6000
            end,
            function(o, clock)
                local wing = o.wings[i]
                if clock.phase == 0 then
                    effects.emit(wing,data.wingBursts[i])
                    clock.phase = 1
                elseif clock.phase == 2 then
                    effects.emit(wing,data.wingDebris[i])
                    finish(o,'components',clock)
                    return
                elseif countdown(clock,'wait',clock.gap) then
                    clock.gap = max(0, clock.gap - 1)
                    clock.drop, clock.zoom = clock.drop + 0x10, clock.zoom - 0x800
                    wing.zoom = clock.zoom
                    if clock.zoom < 0 then
                        wing.hidden, clock.drop, clock.phase = true, 0, 2
                    end
                end
                position(wing, wing.h - clock.drop, wing.l - o.run.cameraStep)
            end,
        }
    end

    local function wingTravel(i, open, sign)
        return {
            function(_, clock)
                clock.wait, clock.stage = open and 0 or 0x20, 0
            end,
            function(o, clock)
                local wing = o.wings[i]
                if wing.broken then finish(o,'components',clock); return end
                if clock.stage == 0 then
                    if clock.wait > 0 then clock.wait = clock.wait - 1; return end
                    if open and wing.form ~= 0 or not open and wing.form ~= 26 then return end
                    stop(o.components,open and i + 1 or i + 9)
                    if open then wing.form = 4 end
                    clock.stage = 1
                end
                local direction = open and 1 or -1
                wing.extension = wing.extension + direction * 0xc0
                wing.arm, wing.form = band(wing.arm + direction * sign * 2, 0xff), wing.form + direction
                if open and wing.form == 26 or not open and wing.form == 4 then
                    attach(o.components,open and i + 9 or i + 1)
                    finish(o,'components',clock)
                end
            end,
        }
    end

    local function wingOpenLoop(i)
        return {
            function(_, clock) clock.wait=0 end,
            function(o, clock)
                local wing = o.wings[i]
                if wing.broken then finish(o,'components',clock); return end
                if countdown(clock,'wait',0) then wing.form = 26 + (wing.form - 25) % 6 end
            end,
        }
    end

    components[0], components[1] = wingShake(1), wingShake(2)
    components[2], components[3] = wingPropeller(1), wingPropeller(2)
    components[4], components[5] = wingBreak(1), wingBreak(2)
    components[8], components[9] = wingTravel(1,true,1), wingTravel(2,true,1)
    components[10], components[11] = wingOpenLoop(1), wingOpenLoop(2)
    components[12], components[13] = wingTravel(1,false,1), wingTravel(2,false,1)
    components[16], components[17] = wingTravel(1,true,-1), wingTravel(2,true,-1)
    components[18], components[19] = wingTravel(1,false,-1), wingTravel(2,false,-1)

    local function tailMove(o)
        o.tail.form = (o.tail.form + 1) % 7
    end
    components[7] = {tailMove, function(o, clock)
        clock.wait = clock.wait or 0
        clock.gap = clock.gap or 8
        if countdown(clock,'wait',clock.gap) then
            if clock.gap > 2 then clock.gap = clock.gap - 1
            elseif clock.gap < 2 then clock.gap = clock.gap + 1 end
            tailMove(o)
        end
    end}
    components[20] = {
        function(_, clock) clock.wait=0 end,
        function(o) tailMove(o) end,
    }
    components[15] = {
        function(_, clock) clock.wait=1 end,
        function(o, clock)
            if countdown(clock,'wait',1) then
                if o.tail.pitch == 0 then finish(o,'components',clock)
                else o.tail.pitch = o.tail.pitch + (o.tail.pitch < 0 and 1 or -1) end
            end
        end,
    }
    components[14] = {
        function(o, clock)
            clock.spin = program.bossSmallRandom(o.run) == 0 and -1 or 1
            clock.speed, clock.phase, clock.wait, clock.change = clock.spin, 0, 0x60, 0x40
            local gap = max(4,4 - (o.spinTier or 0))
            o.spinTier = min(4,(o.spinTier or 0) + 1)
            attach(o.attacks,5,{gap=gap}); attach(o.attacks,6,{gap=gap}); attach(o.attacks,14)
        end,
        function(o, clock)
            if clock.phase == 0 then
                clock.wait = clock.wait - 1
                if clock.wait ~= 0 then return end
                clock.phase = 1
            end
            for _, wing in ipairs(o.wings) do wing.angle = band(wing.angle + clock.speed,0xff) end
            if clock.phase == 1 and countdown(clock,'change',0x40) then
                clock.speed = clock.speed + clock.spin
                if math.abs(clock.speed) == 2 then clock.phase, clock.wait, clock.change = 2, 0x100, 0x60 end
            end
            if clock.phase ~= 2 then return end
            if clock.wait > 0 then clock.wait = clock.wait - 1; return end
            if clock.speed ~= clock.spin * 2 then
                if countdown(clock,'change',0x20) then clock.speed = clock.speed - clock.spin end
            elseif band(o.wings[1].angle,0xfe) == 0x40 then
                o.wings[1].angle, o.wings[2].angle = 0x40, 0xc0
                for _, id in ipairs({5,6,14}) do stop(o.attacks,id) end
                finish(o,'components',clock)
            end
        end,
    }

    -- 0x192004。机身退场期间依次消费三段爆炸指令及最终转场挡板。
    components[6] = {
        function(_, clock)
            clock.phase, clock.wait, clock.fire, clock.fragmentIndex = 0, 0x20, 0, 1
        end,
        function(o, clock)
            if clock.phase == 0 then
                effects.emit(o,data.hullBurst)
                clock.phase = 1
            elseif clock.phase == 1 then
                clock.wait = clock.wait - 1
                if clock.wait == 0 then
                    effects.emit(o,data.tailBurst)
                    o.hideTail = true
                    clock.phase, clock.wait = 2, 0x80
                end
            elseif clock.phase == 2 and clock.wait > 0 then
                clock.wait = clock.wait - 1
            elseif clock.phase == 2 or clock.phase == 3 then
                if countdown(clock,'fire',clock.phase == 2 and 0xc or 4) then
                    effects.emit(o,{data.hullFragments[clock.fragmentIndex]})
                    clock.fragmentIndex = clock.fragmentIndex + 1
                    if clock.phase == 2 and clock.fragmentIndex == 9 then
                        clock.phase, clock.fire, clock.fragmentIndex = 3, 0, 1
                    elseif clock.phase == 3 and clock.fragmentIndex == 17 then
                        o.wipe = 1
                        clock.phase, clock.wait = 4, 8
                    end
                end
            elseif clock.phase == 4 then
                clock.wait = clock.wait - 1
                if clock.wait == 0 then
                    o.hideTail, o.showGuns, o.wipe = true, false, nil
                    clock.phase = 5
                else
                    o.wipe = min(8,o.wipe + 1)
                end
            elseif clock.phase == 5 then
                effects.emit(o,data.hullDebris)
                clock.phase, clock.wait = 6, 0x80
            elseif clock.phase == 6 then
                clock.wait = clock.wait - 1
                if clock.wait == 0 then o.finished = true end
            end
        end,
    }

    return {directors=directors,components=components}
end
