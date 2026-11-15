-- 0xf58f6 生成倍率筹码，0xf592a 按筹码面值调度漂移、吸附和拾取。
return function(program)
    local band = require('bit').band
    local s16 = program.s16
    local abs, floor, max, min = math.abs, math.floor, math.max, math.min
    local data = program.chip
    local exits = {0,-0x200,-0x400,-0x600,-0x600}
    local M = {}

    local function remove(o)
        o.run.chips[o.slot] = nil
        o.run.chipCount = o.run.chipCount - 1
        object.RawDel(o)
    end

    local Chip = Class(object, {
        init = function(o, run, slot, kind, h, l)
            local row = data[kind]
            o.run, o.slot, o.kind, o.frames = run, slot, kind, row[7]
            o.h, o.l = h, s16(l + run.cameraStep)
            o.drawH, o.drawL, o.front, o.back, o.right, o.left = unpack(row,1,6)
            local random = s16(program.random(run,program.effectRandom)*256)/256
            o.speed = 9 + floor(abs(random)/2)
            local jitter = s16(program.random(run,program.randomSign)*256)/256 + 1
            o.angle = band(0x20 + program.random(run,data.headingRandom) - jitter,0x3f)
            o.dh, o.dl = program.vector(o.speed, o.angle*4)
            o.index = 1
            o.direct = run.player.locked
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.ENEMY+1, false, false
        end,
        render = function(o)
            local image = o.run.art.sprites[o.frames[o.index]]
            local x,y = program.world(o.h+o.drawH,o.l+o.drawL)
            Render(image[1],floor(x)+image[2]/2,floor(y)+image[3]/2)
        end,
    })

    function M.spawn(run, kind, h, l)
        if band(h+0x800,0xffff) >= 0xa000
            or band(l+run.cameraStep+0xe00+run.cameraOffset,0xffff) >= 0x5400 then return end
        for slot=1,40 do
            if not run.chips[slot] then
                local o = New(Chip,run,slot,kind,h,l)
                run.chips[slot] = o
                run.chipCount = run.chipCount + 1
                return o
            end
        end
    end

    function M.contact(run, h,l,front,back,right,left)
        for slot=1,40 do
            local o = run.chips[slot]
            if o and o.h ~= 0 and program.overlap(o,h,l,front,back,right,left) then o.taken = true end
        end
    end

    local function distance(o, p)
        local h = s16(o.h-p.h)
        if o.direct then return max(0,h) end
        local l = abs(s16(o.l-p.l))
        h = abs(h)
        h = h-floor(h/4)
        return max(h,l)+floor(min(h,l)/2)
    end

    local function step(o)
        local run, p = o.run, o.run.player
        o.l = s16(o.l-run.cameraStep)
        if o.taken then
            run.stageMultiplier = min(999,run.stageMultiplier+o.kind)
            run.bossMultiplier = min(9999,run.bossMultiplier+o.kind)
            remove(o)
            return
        end
        local active = p.respawn == 0 and not p.defeated
        if o.homing and not active then remove(o); return end
        if not o.homing and o.speed >= 0x18 and active and distance(o,p) < 0x1c00 then
            o.homing = true
            o.angle = program.aimByte(o.h,o.l,p.h,p.l,o.angle*4)
            o.dh,o.dl = program.vector(o.speed,o.angle)
        end
        if o.homing then
            o.speed = min(0x30,o.speed+2)
            local angle = program.aimByte(o.h,o.l,p.h,p.l,o.angle)
            if angle ~= o.angle then
                o.angle = angle
                o.dh, o.dl = program.vector(o.speed,angle)
            end
            o.h, o.l = s16(o.h+o.dh), s16(o.l+o.dl)
            o.index = (o.index+1)%32+1
        else
            o.speed = min(0x2c,o.speed+2)
            o.dh, o.dl = program.vector(o.speed,o.angle*4)
            o.h = s16(o.h+0xc0+o.dh)
            if o.speed < 0x18 then o.l = s16(o.l+o.dl) end
            o.index = o.index%32+1
            if o.h < exits[o.kind] then remove(o) end
        end
    end

    function M.step(run)
        for slot=1,40 do
            local o = run.chips[slot]
            if o then step(o) end
        end
    end

    function M.clear(run)
        for _,o in pairs(run.chips) do remove(o) end
    end

    return M
end
