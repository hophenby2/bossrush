-- 0x11c216。敌弹用自己的定点中心跟自机判定框比较，爆散中的槽不重复命中。
return function(program,bullets,shots)
    local band = require('bit').band
    local floor = math.floor
    local s16 = program.s16
    local M = {}

    function M.pilot(run,p)
        local front,back = band(p.h + p.front,0xffff),band(p.h - p.back,0xffff)
        local right,left = band(p.l + p.right,0xffff),band(p.l - p.left,0xffff)
        for i = 1,run.bulletCapacity do
            local b = run.bullets[i]
            if b and band(b.flags,0x5100) == 0 then
                local h,l = band(b.h,0xffff),band(b.l,0xffff)
                if h >= back and h <= front and l >= left and l <= right then
                    p.pendingHit = true
                    bullets.contact(b)
                    return b
                end
            end
        end
    end

    -- 0x11b2c8 的普通机体接触要求部件低位开启，命中当帧只写接触标志。
    function M.body(run,p)
        local bias = 0x2800
        local pf,pb = band(p.h + p.front + bias,0xffff),band(p.h - p.back + bias,0xffff)
        local pr,pl = band(p.l + p.right + bias,0xffff),band(p.l - p.left + bias,0xffff)
        for bank = 1,2 do
            for i = 1,bank == 1 and 90 or 30 do
                local part = run.partSlots[bank][i]
                if part and band(part.flags or 0,0x8001) == 0x8001 then
                    local h,l = part.h + bias,part.l + bias
                    local back = band(h - part.back,0xffff)
                    if back < 0xf800 and pf >= back and pb <= band(h + part.front,0xffff)
                        and pr >= band(l - part.left,0xffff) and pl <= band(l + part.right,0xffff) then
                        p.pendingHit,part.impact = true,true
                        return part
                    end
                end
            end
        end
    end

    -- 0x11b3d0 扫描普通部件槽，再走 0x11b50e 的 Boss 部件槽。
    function M.shots(run,p)
        for bank = 1,2 do
            local bias = bank == 1 and 0x2800 or 0x1800
            for i = 1,bank == 1 and 90 or 30 do
                local part = run.partSlots[bank][i]
                if part and band(part.flags or 0,0xa000) == 0xa000 then
                    local h,l = part.h + bias,part.l + bias
                    local front,back = band(h + part.front,0xffff),band(h - part.back,0xffff)
                    local right,left = band(l + part.right,0xffff),band(l - part.left,0xffff)
                    if back < (bank == 1 and 0x9600 or 0x8800) then
                        for slot = 1,35 do
                            local shot = p.shots[slot]
                            if shot and shot.damage >= 0 then
                                local hf = band(shot.h + bias + shot.front,0xffff)
                                local lr = band(shot.l + bias + shot.right,0xffff)
                                if hf >= back and band(hf - shot.back,0xffff) <= front
                                    and lr >= left and band(lr - shot.left * 2,0xffff) <= right then
                                    local damage = shot.damage
                                    if not run.dual then damage = damage - floor(damage / 4) end
                                    if run.halfPathSpeed then damage = damage - floor(damage / 4) end
                                    shot.damage = s16(shot.damage - part.hp)
                                    shots.contact(shot)
                                    part.impact = true
                                    if bank == 2 or band(part.h,0xffff) < 0x6e00 then
                                        part.damage = (part.damage or 0) + damage
                                        part.hp = s16(part.hp - damage)
                                    end
                                    if part.hp < 0 then break end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return M
end
