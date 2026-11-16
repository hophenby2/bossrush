-- 0x16de5a 的五个部件保留各自位置。主部件挂载八种运动，前后炮座独立推进发射与后坐。
return function(program, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world,packed = program.s16,program.world,program.addPacked
    local floor,min,max,abs = math.floor,math.min,math.max,math.abs
    local M = {parts=5}
    local data = program.mid5b
    local movement = {}

    local function decrement(o,key)
        o[key] = o[key] - 1
        return o[key] == 0
    end

    local function tick(o,key,gap)
        o[key] = o[key] - 1
        if o[key] >= 0 then return false end
        o[key] = gap
        return true
    end

    local function queue(o,kind,h,l,arg)
        local run = o.run
        local q,entry = run.spawnQueue,program.actorCallbacks[kind]
        q[#q + 1] = {run.major,0,kind,0,0,entry[1],entry[2],h=h,l=l,arg=arg}
    end

    local function move(o,h,l)
        l = s16(l - o.run.cameraOffset)
        local dh,dl = abs(s16(h - o.h)),abs(s16(l - o.l))
        dh = dh - floor(dh / 4)
        local distance = max(dh,dl) + floor(min(dh,dl) / 2)
        if distance < 0x200 then
            o.speed = distance < 0x100 and 6 or 8
            if distance < 0x40 then return true end
        end
        o.angle = program.turn64(o.angle,program.angle(o.h,o.l,h,l,o.angle))
        return false
    end

    local function mode(o,index)
        if o.mode == index then return end
        o.mode,o.modeStep = index,0
    end

    movement[0] = function(o)
        if o.modeStep == 0 then o.modeStep,o.speed,o.angle,o.brakeClock = 1,0x16,0,2 end
        if o.modeStep == 1 and o.h >= 0x2000 then o.modeStep = 2 end
        if o.modeStep == 2 and tick(o,'brakeClock',2) and decrement(o,'speed') then
            o.flags,o.launched = 0xa001,true
            mode(o,1)
        end
    end

    movement[1] = function(o)
        if o.modeStep == 0 then
            o.modeStep,o.speed,o.waypoint,o.moveClock = 1,4,1,0x12c
            o.frontActive,o.frontLatch,o.rearActive,o.rearLatch = true,false,true,0
            o.rearClock = o.run.loop == 0 and 0x18 or 4
        end
        local route = data.patrol[o.waypoint]
        if move(o,route[1],route[2]) then o.waypoint = 3 - o.waypoint end
        if decrement(o,'moveClock') then
            mode(o,o.route == 0 and 2 or 4)
            o.route = 1 - o.route
            o.frontActive,o.rearActive = false,false
        end
    end

    local function pod(o,kind,side,muzzle,angle)
        local h,l = packed(o.h,o.l,side == 1 and 0xc7f or 0xc80,side == 1 and -0xa00 or 0xa00)
        h,l = packed(h,l,muzzle[1],muzzle[2])
        queue(o,kind,h,l,angle)
    end

    movement[2] = function(o)
        if o.modeStep == 0 then
            o.modeStep,o.speed,o.podCount = 1,0x10,0x10
            o.leftAngle,o.rightAngle = 0,0
        end
        if o.modeStep == 1 and move(o,0x2800,0x1c00) then o.modeStep,o.speed = 2,0 end
        if o.modeStep == 2 then
            o.doorShift = min(0x600,o.doorShift + 0x40)
            if o.doorShift == 0x600 then o.modeStep = 3 end
        end
        if o.modeStep == 3 and o.run.aimPhase % 2 == 0 then
            local m = data.podMuzzles[o.podCount % 8 + 1]
            pod(o,0x52,1,m,o.leftAngle)
            pod(o,0x52,2,m,o.rightAngle)
            o.leftAngle,o.rightAngle = band(o.leftAngle + 4,63),band(o.rightAngle - 4,63)
            if decrement(o,'podCount') then mode(o,3) end
        end
    end

    local function returnToBack(o,wait)
        if o.modeStep == 0 then o.modeStep,o.speed,o.moveClock = 1,0x10,wait end
        o.doorShift = max(0,o.doorShift - 0x40)
        if o.modeStep == 1 and move(o,0x5c00,0x1c00) then o.modeStep,o.speed = 2,0 end
        if o.modeStep == 2 and decrement(o,'moveClock') then mode(o,1) end
    end

    movement[3] = function(o) returnToBack(o,0xf0) end

    movement[4] = function(o)
        if o.modeStep == 0 then o.modeStep,o.speed,o.podStage = 1,8,0 end
        if o.modeStep == 1 and move(o,0x3200,0x1c00) then
            o.modeStep,o.speed,o.podStage = 2,4,1
        end
        if o.modeStep == 2 and move(o,0x3600,0x2a00) then o.modeStep,o.podStage = 3,1 end
        if o.modeStep == 3 and move(o,0x3600,0xe00) then mode(o,5) end
        if o.podStage == 1 then
            o.doorShift = min(0x600,o.doorShift + 0x40)
            if o.doorShift == 0x600 then o.podStage,o.podCount,o.podAngle = 2,8,0 end
        end
        if o.podStage == 2 and (o.run.frame - 1) % 8 == 0 then
            local m = data.podMuzzles[o.podCount % 8 + 1]
            for side = 1,2 do
                pod(o,0x58,side,m,band(4 - o.podAngle,63))
                o.podAngle = band(o.podAngle + 1,7)
            end
            if decrement(o,'podCount') then o.podStage = 0 end
        end
    end

    movement[5] = function(o) returnToBack(o,0x40) end
    movement[7] = function(o)
        if o.modeStep == 0 then o.modeStep,o.angle = 1,0 end
        if o.speed ~= 8 then o.speed = min(8,o.speed + 1) end
        if o.h <= s16(0x9800) then o.leaving = true end
    end

    function M.init(o)
        o.h,o.l,o.flags,o.hp = -0xc00,0x1c00 - o.run.cameraOffset,0x8000,0x7fff
        o.front,o.back,o.right,o.left = 0x1000,0xb00,0xe00,0xe00
        o.health,o.palette,o.mode,o.modeStep,o.route = 0x12000,18,0,0,0
        o.speed,o.angle,o.frontShift,o.rearLeft,o.rearRight,o.doorShift = 8,0,0,0,0,0
        o.deathStage,o.deathClock,o.deathRounds,o.deathCursor = 0,8,2,1
        for _, part in ipairs(o.extraParts) do part.flags,part.h,part.l = 0x8000,o.h,o.l end
        local run = o.run
        run.fifthMid2,run.fifthMid2Projectiles = o,true
        run.bulletCapacity = max(run.bulletCapacity,110)
        return true
    end

    function M.damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end

    local function updateFront(o)
        if o.frontActive then
            if o.frontLatch then o.frontShift,o.frontLatch = 0xa00,false end
            if o.frontShift == 0 then
                local h,l = packed(o.h,o.l,-0x3c1,-0x1380)
                queue(o,0x4e,h,l,-0x600)
                h,l = packed(o.h,o.l,-0x3c0,0x1380)
                queue(o,0x4e,h,l,0x600)
                o.frontLatch = true
            end
        end
        o.frontShift = max(0,o.frontShift - 0x100)
    end

    local function updateRear(o)
        local run = o.run
        if o.rearActive then
            if o.rearLatch == 1 then o.rearLeft = 0x800
            elseif o.rearLatch == 2 then o.rearRight = 0x800 end
            o.rearLatch = 0
            local pilot = run.player
            if (run.frame - 1) % 16 == 0 and pilot and pilot.active and pilot.h >= o.h - 0x400 then
                for angle = 0x2e,0x52 do
                    local m = program.shipFan[4][band(angle,63) + 1]
                    bullets.emit(run,7,run.loop == 0 and 1 or 5,angle,s16(o.h + m[1]),s16(o.l + m[2]))
                end
            end
            local gap = run.loop == 0 and 0x18 or 4
            if tick(o,'rearClock',gap) and o.rearLeft + o.rearRight == 0 then
                local side = band(program.bossWideRandom(run),1)
                local h,l = packed(o.h,o.l,side == 0 and -0xb81 or -0xb80,side == 0 and -0x400 or 0x400)
                queue(o,0x50,h,l)
                o.rearLatch = side + 1
            end
        end
        o.rearLeft,o.rearRight = max(0,o.rearLeft - 0x80),max(0,o.rearRight - 0x80)
    end

    local function blast(o,row,moveWithHull)
        local speed,angle = floor(row[6] / 256),band(row[6],255)
        if moveWithHull then speed,angle = o.speed,o.angle * 4 end
        effects.emit(o,{{row[2],row[1],row[4],row[5],speed,angle,flip=band(row[3],0x40) ~= 0}})
    end

    local function die(o)
        o.h = s16(o.h - 0x40)
        bullets.clearWithFade(o.run)
        if o.deathStage == 2 then
            o.leaving = true
        elseif o.deathStage == 1 then
            if decrement(o,'deathClock') then
                for _, row in ipairs(data.wreckFinal) do blast(o,row) end
                o.deathStage = 2
            end
        elseif tick(o,'deathClock',8) then
            blast(o,data.wreckCycle[o.deathCursor],true)
            o.deathCursor = o.deathCursor % #data.wreckCycle + 1
            if o.deathCursor == 1 and decrement(o,'deathRounds') then o.deathStage,o.deathClock = 1,0x10 end
        end
    end

    local function checkDamage(o)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = 18; return end
        o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,13)
        hyper.hit(o,flags)
        if not o.escaping then o.health = o.health - band(0x7fff - o.hp,0xffff) end
        o.hp = 0x7fff
        if o.health >= 0 or o.dying then return end
        local run = o.run
        o.dying,o.flags = true,0x8000
        hyper.kill(run,flags,1000)
        run.fifthMid2,run.fifthMid2Projectiles = nil,false
        run.scrollSpeed[1],run.scrollSpeed[2] = 0x20,0x20
        bullets.clearWithFade(run,flags)
    end

    function M.step(o)
        local run = o.run
        if run.freeze then return end
        if o.leaving then
            run.fifthMid2 = nil
            run.scrollSpeed[1],run.scrollSpeed[2] = 0x20,0x20
            remove(o)
            return
        end
        if not o.escaping and not o.dying and run.major == 0x1f0 then
            o.escaping = true
            mode(o,7)
        end
        checkDamage(o)
        if o.dying then die(o)
        else
            movement[o.mode](o)
            local dh,dl = program.vector(o.speed,o.angle * 4)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
            if not o.escaping then updateFront(o); updateRear(o) end
        end
        o.x,o.y = world(o.h,o.l)
    end

    local function draw(o,id,dh,dl)
        local art = o.run.art[id]
        local h,l = packed(o.h,o.l,dh,dl)
        local x,y = world(h,l)
        Render(art[1],floor(x) + art[2] / 2,floor(y) + art[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local hull,pieces = data.images[o.palette],data.images[18]
        draw(o,pieces[5],-0x1581 + o.rearLeft,-0x600)
        draw(o,pieces[5],-0x1580 + o.rearRight,0x200)
        draw(o,pieces[4],-0x9c1,-0x1480 + o.frontShift)
        draw(o,pieces[4],-0x9c0,0x1280 - o.frontShift)
        draw(o,hull[1],-0x1300,-0x700)
        draw(o,hull[2],-0x580 + o.doorShift,-0x1100)
        draw(o,hull[3],-0xe00,-0x1a00)
    end

    return M
end
