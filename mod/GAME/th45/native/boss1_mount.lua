-- 0x11a010、0x119fa4、0x119fda 各自截断一次定点坐标，挂点用这三次旋转的结果。
return function(program)
    local abs,floor,min,max = math.abs,math.floor,math.min,math.max
    local band = require('bit').band
    local s16 = program.s16
    local trig = program.boss1.trig
    local M = {}

    function M.distance(o,h,l)
        local dh,dl = abs(s16(o.h-h)),abs(s16(o.l-l))
        dh = dh-floor(dh/4)
        return max(dh,dl)+floor(min(dh,dl)/2)
    end

    function M.speed(distance,rows,limit)
        for _,row in ipairs(rows) do
            if row[1] == 0xffff then break end
            if distance <= row[1] then return row[2] end
        end
        return limit
    end

    function M.place(o,mount,spin,yaw,tilt)
        local sin,cos = unpack(trig[spin+1])
        local x = floor((cos*mount.x-sin*mount.y)/64)
        local y = floor((sin*mount.x+cos*mount.y)/64)
        sin,cos = unpack(trig[yaw+1])
        local l = floor((cos*y-sin*mount.z)/64)
        local z = floor((sin*y+cos*mount.z)/64)
        sin,cos = unpack(trig[tilt+1])
        mount.h,mount.l = s16(o.h+floor((cos*x+sin*z)/64)),s16(o.l+l)
        mount.depth = floor((cos*z-sin*x)/64)
        mount.angle = yaw
    end

    function M.ready(mounts)
        for _,mount in ipairs(mounts) do
            if mount.arm and mount.arm.mode ~= 0 then return false end
        end
        return true
    end

    -- 0x18b25e 只占一个无判定对象槽。机臂的发弹与退场仍由 0x18ab18 更新。
    local carrier = {parts=1}

    function carrier.init(o)
        local row = o.row
        o.h,o.l,o.boss = row.h,row.l,row.boss
        o.aim,o.direction,o.spin,o.rotation,o.ramp = row.aim,row.aim,row.spin,row.rotation,row.ramp
        o.flags,o.speed,o.clock = 0x8000,0,1
        return true
    end

    function carrier.step(o)
        if o.boss.armDestroyed then return false end
        local run = o.run
        if run.freeze then return true end
        if not o.reversed then
            if o.ramp > 0 then o.speed,o.ramp = o.speed+1,o.ramp-1 end
            if o.ramp == 0 then
                o.clock = o.clock-1
                if o.clock < 0 then
                    o.clock,o.speed = 1,o.speed-1
                    if o.speed <= 4 then
                        o.reversed,o.clock,o.speed,o.direction = true,0x40,4,band(o.direction+0x80,255)
                        for _,mount in ipairs(o.boss.mounts) do mount.reversed = true end
                    end
                end
            end
        end
        if o.reversed then
            o.clock = o.clock-1
            if o.clock < 0 then
                o.clock,o.speed = 0,o.speed+1
                if (run.frame+1)%16 == 0 then o.rotation = min(0x10,o.rotation+1) end
            end
        end
        local dh,dl = program.vector(o.speed,o.direction,run.slowVectors)
        o.h,o.l = s16(o.h+dh),s16(o.l+dl)
        o.spin = band(o.spin+o.rotation,255)
        for _,mount in ipairs(o.boss.mounts) do M.place(o,mount,o.spin,o.aim,0xa0) end
        return not M.ready(o.boss.mounts)
    end

    M.carrier = carrier
    return M
end
