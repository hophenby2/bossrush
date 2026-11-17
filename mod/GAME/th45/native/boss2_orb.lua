-- 0x192e3c：两颗绕行球挂在普通敌机队列，返回对面的机腹挂点时各自回收。
return function(program,bullets,art)
    local band = require('bit').band
    local abs, floor = math.abs, math.floor
    local s16 = program.s16
    local M = {parts=1}

    local function returnPoint(o)
        local boss = o.boss
        return {active=true,h=s16(boss.h-0x1e00),l=s16(boss.l+o.returnOffset)}
    end

    function M.init(o)
        local row = o.row
        o.boss,o.h,o.l,o.angle = row.boss,row.h,row.l,row.angle
        o.returnOffset = row.side == 0 and 0xb80 or -0xb80
        o.flags,o.animation = 0x8000,0
        return true
    end

    function M.step(o)
        local boss,run = o.boss,o.run
        if run.enemies[boss.slot] ~= boss then return false end
        local target = returnPoint(o)
        if not run.freeze then
            local angle = program.angle8(o.h,o.l,target,o.angle)
            local delta = program.s8(angle-o.angle)
            o.angle = band(o.angle + math.max(-5,math.min(5,delta)),255)
        end
        if not run.stopPathClock then
            local dh,dl = program.vector(0x20,o.angle,run.slowVectors)
            o.h,o.l = s16(o.h+dh),s16(o.l+dl)
        end
        if not run.freeze then
            local dh,dl = abs(s16(o.h-target.h)),abs(s16(o.l-target.l))
            dh = dh-floor(dh/4)
            if math.max(dh,dl)+floor(math.min(dh,dl)/2) <= 0x100 then return false end
            if boss.orbsFire and boss.orbTarget then
                local angle = program.angle8(o.h,o.l,boss.orbTarget,0x80)
                bullets.emit(boss,11,4,angle,o.h-boss.h,o.l-boss.l,true)
            end
        end
        o.animation = (o.animation+1)%4
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if assets then art.draw(assets.sprites[program.boss2.images.orb[26][o.animation+1]],o.h,o.l,-0x400,-0x200) end
    end

    return M
end
