-- 0x1235a0 给两束通常弹分配独立槽。0x126a62 先推进两次出膛，再挂成熟弹的运动。
return function(program,art)
    local band = require('bit').band
    local floor = math.floor
    local s16 = program.s16
    local M = {}

    local function render(o)
        local assets = o.run.art
        if assets then art.draw(assets.sprites[o.image],o.h,o.l,o.offsetH,o.offsetL,o.mirror) end
    end

    local function flying(o)
        o.h,o.l = s16(o.h + o.dh),s16(o.l + o.dl)
        if band(o.h,0xffff) >= 0x8000 or band(o.l + 0x400,0xffff) >= 0x4000 then return false end
        o.image = o.flightImages[o.flightFrame]
        o.flightFrame = o.flightFrame == 1 and 3 or o.flightFrame - 1
        return true
    end

    local function impact(o)
        o.hitClock = o.hitClock - 1
        if o.hitClock < 0 then
            o.hitClock,o.hitFrame = o.hitPeriod,o.hitFrame - 1
            if o.hitFrame == 0 then return false end
            o.image = o.hitImages[o.hitFrame]
        end
        o.h,o.l = s16(o.h + o.dh),s16(o.l + o.dl)
        return true
    end

    local function beginImpact(o)
        local jitter = program.shotJitter
        local dh,dl = o.armed and o.dh or 0,o.armed and o.dl or 0
        if o.launchFrame == 2 then o.h = s16(o.h - 0x200) end
        dh = dh + floor(jitter[program.nextRandom(o.run,63)] / 2)
        dl = dl + floor(jitter[program.nextRandom(o.run,63)] / 2)
        o.h,o.l = s16(o.h + dh),s16(o.l + dl)
        o.dh,o.dl = floor(dh / 8),floor(dl / 8)
        o.offsetH,o.offsetL,o.hitClock,o.hitPeriod = unpack(o.hitShape)
        o.hitFrame,o.update = #o.hitImages + 1,impact
        o.damage = -1
        return impact(o)
    end

    local function launching(o)
        o.launchFrame = o.launchFrame + 1
        if o.launchFrame == 3 then
            o.h,o.l = s16(o.h + o.shiftH),s16(o.l + o.dl + o.shiftL)
            o.offsetH,o.offsetL = o.flightH,o.flightL
            o.update,o.armed = flying,true
            return flying(o)
        end
        if o.launchFrame == 2 then o.h,o.l = s16(o.h + o.pilot.deltaH),s16(o.l + o.pilot.deltaL) end
        o.h,o.l = s16(o.h + floor(o.dh / 2)),s16(o.l + o.dl)
        return true
    end

    local Shot = Class(object,{
        init = function(o,p,slot,source,variant,angle,side)
            local h,l,dh,dl,front,back,right,left,flightH,flightL,shiftH,shiftL = unpack(variant[1])
            o.pilot,o.run,o.slot = p,p.run,slot
            o.h,o.l = s16(p.h + h),s16(p.l + l * side)
            o.offsetH,o.offsetL,o.flightH,o.flightL = dh,dl,flightH,flightL
            o.front,o.back,o.right,o.left = front,back,right,left
            o.image,o.flightImages,o.flightFrame = variant[2][p.shotFrame],variant[3],1
            o.shiftH,o.shiftL = shiftH,shiftL
            o.hitShape,o.hitImages = variant[4],variant[5]
            o.damage,o.mirror = source.meta[2],side < 0
            o.dh,o.dl = program.vector(source.meta[3],angle)
            o.launchFrame,o.update = 0,launching
            o.group,o.layer,o.bound,o.colli = GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,false
            o.x,o.y = program.world(o.h,o.l)
        end,
        render = render,
    })

    function M.emit(p)
        local loadout = p.form == 2 and program.pilotAwakenedShots or program.pilotShots
        local sides = loadout[p.power + 1]
        local available = {}
        local burstLimit = p.run.dual and (p.run.shotCapacity or 7) or 5
        for slot = 1,burstLimit * #sides do
            if not p.shots[slot] then available[#available + 1] = slot end
            if #available == #sides then break end
        end
        if #available < #sides then return false end
        for index,source in ipairs(sides) do
            local side = index == 1 and 1 or -1
            local tilt = side > 0 and p.rightTilt or p.leftTilt
            local variant = source.variants[floor((tilt + 2) / 4) + 1]
            local slot = available[index]
            p.shots[slot] = New(Shot,p,slot,source,variant,band(tilt * side,255),side)
        end
        p.shotFrame = p.shotFrame == 1 and 3 or p.shotFrame - 1
        return true
    end

    function M.remove(o)
        o.pilot.shots[o.slot] = nil
        object.RawDel(o)
    end

    function M.contact(o)
        o.update = beginImpact
    end

    function M.step(p)
        for slot = 1,35 do
            local shot = p.shots[slot]
            if shot then
                shot.l = s16(shot.l - p.run.cameraStep)
                if not shot.update(shot) then M.remove(shot)
                else shot.x,shot.y = program.world(shot.h,shot.l) end
            end
        end
    end

    return M
end
