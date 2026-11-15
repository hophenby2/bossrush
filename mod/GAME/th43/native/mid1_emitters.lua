-- 0x130446 的发射槽。中炮、子机分配及子机发射许可分别计时。
return function(program, bullets, drones)
    local band = require('bit').band
    local s16 = program.s16
    local muzzle = program.mid1.muzzle
    local M = {}

    local function atMuzzle(o, index)
        local dh,dl = program.unpack(muzzle[band(index,0x3f)+1]+0xeb000000)
        return s16(o.h+dh),s16(o.l+dl)
    end

    local function mainRay(o, kind, modifier, angle, muzzleAngle)
        local h,l = atMuzzle(o,math.floor(band(muzzleAngle+2,0xff)/4))
        local spread = o.run.route.loop == 1 and 2 or 0
        bullets.emitAngle(o.run,kind,modifier,angle-spread,h,l)
        if spread > 0 then bullets.emitAngle(o.run,kind,modifier,angle+spread,h,l) end
    end

    -- 0x1304d6 每轮首发取自机角。两种条数交替，翼部击破后额外开放射角。
    local function main(o, f)
        local run = o.run
        f.clock = 4
        if f.left == f.total then
            if not run.pilotH then return end
            f.angle = program.aimByte(s16(o.h-0x1500),o.l,run.pilotH,run.pilotL,f.angle,true)
        end
        local odd = f.rounds%2
        local count = odd == 0 and 7 or 6
        local start = f.angle-(odd == 0 and 0x27 or 0x20)
        local modifier = (f.total-f.left)*3+o.mainStrength+odd*2
        local angle = start
        for _ = 1, count do
            mainRay(o,odd,modifier,angle,angle)
            angle = angle+13
        end
        if o.wings[1].broken or o.wings[2].broken then
            -- 0x1305a6 的两发沿用最后一次取到的炮口。
            local muzzleAngle = angle-13
            mainRay(o,odd,modifier,angle,muzzleAngle)
            mainRay(o,odd,modifier,start-13,muzzleAngle)
        end
        f.left = f.left-1
        if f.left >= 0 then return end
        f.clock,f.total = 0x1c,math.min(6,f.total+1)
        f.left,f.rounds = f.total,f.rounds-1
        if f.rounds < 0 then
            o.emit[1] = nil
            o.mainStrength = math.min(3,o.mainStrength+1)
            o.mainWaveBonus = math.min(4,o.mainWaveBonus+1)
            o.mainDelayBonus = math.min(8,o.mainDelayBonus+2)
            o.beginGate(o,'barrel',false)
        end
    end

    local function launch(o, f)
        if not o.wings[1].broken then drones.spawn(o,-1,f.sprite,0x10) end
        if not o.wings[2].broken then drones.spawn(o,1,f.sprite,0x30) end
        f.clock,f.sprite = 0x12,(f.sprite-4)%12
        f.left = f.left-1
        if f.left < 0 then
            o.emit[2] = nil
            o.droneRise = math.min(8,o.droneRise+2)
            o.beginGate(o,'bay',false)
        end
    end

    local function bayGuard(o, f)
        local run = o.run
        f.clock = 0x10
        if run.pilotH then
            local a = program.angle(s16(o.h-0x1500),o.l,run.pilotH,run.pilotL)
            a = band(a,0x3e)
            local h,l = atMuzzle(o,a)
            if run.route.loop == 0 then bullets.emitDirect(run,2,-4,a,h,l)
            else
                bullets.emitAngle(run,2,-2,a*4,h,l)
                bullets.emitAngle(run,2,-4,a*4-4,h,l)
                bullets.emitAngle(run,2,-4,a*4+4,h,l)
            end
            if o.wings[1].broken or o.wings[2].broken then
                for _, offset in ipairs({-4,-8,4,8}) do
                    local angle = a+offset
                    local mh,ml = atMuzzle(o,angle)
                    local modifier = math.abs(offset) == 4 and -2 or -3
                    bullets.emitDirect(run,2,modifier,angle,mh,ml)
                    if run.route.loop == 1 then bullets.emitDirect(run,2,modifier+6,angle,mh,ml) end
                end
            end
        end
        f.left = f.left-1
        if f.left < 0 then f.left,f.clock = 0xf,0x1c end
    end

    function M.start(o, index)
        if index == 3 then
            o.droneClock,o.droneRise = 0x30,0
            return
        end
        local f = {created=o.tick}
        if index == 1 then
            f.clock,f.left,f.total = 0x10-o.mainDelayBonus,2,2
            f.rounds,f.angle = 4+o.mainWaveBonus,0
        elseif index == 2 then
            f.clock,f.left,f.sprite = 0x10,9+o.droneRise,0
        else
            f.clock,f.left = 0x30,0xf
        end
        o.emit[index] = f
    end

    function M.step(o)
        for i = 1, 4 do
            if i == 3 and o.droneClock then
                o.droneClock = o.droneClock-1
                if o.droneClock < 0 then
                    local _, rank = program.smallRank(o.run)
                    o.droneClock = band(0x26-rank,0xff)
                end
            else
                local f = o.emit[i]
                if f and f.created < o.tick then
                    f.clock = f.clock-1
                    if f.clock < 0 then
                        if i == 1 then main(o,f)
                        elseif i == 2 then launch(o,f)
                        else bayGuard(o,f) end
                    end
                end
            end
        end
    end

    return M
end
