-- 0x1442cc 与 0x14432c。先遍历部件槽，再遍历自机弹槽。
return function(program)
    local band = require('bit').band
    local M = {}
    local function u16(n) return band(n, 0xffff) end

    local function bounds(o, bias)
        local h, l = o.h + bias, o.l + bias
        return u16(h + o.front), u16(h - o.back), u16(l + o.right), u16(l - o.left)
    end

    -- 自机弹的纵向后沿从前沿减去整段长度，横向左沿减去两次左侧距离。
    local function overlapsShot(shot, bias, front, back, right, left)
        local frontEdge = u16(shot.h + bias + shot.front)
        local rightEdge = u16(shot.l + bias + shot.right)
        return frontEdge >= back and u16(frontEdge - shot.back) <= front
            and rightEdge >= left and u16(rightEdge - shot.left * 2) <= right
    end

    function M.shots(run, shots, hitFlags)
        for bank = 1, 2 do
            local slots = run.partSlots[bank]
            local limit, bias, edge = 100, 0x2800, 0x9700
            if bank == 2 then limit, bias, edge = 50, 0x1800, 0x8800 end
            for index = 1, limit do
                local part = slots[index]
                if part and band(part.flags, 0xa000) == 0xa000 then
                    local front, back, right, left = bounds(part, bias)
                    if back < edge then
                        for slot = 1, 36 do
                            local shot = shots[slot]
                            if shot and shot.damage >= 0 and (bank == 1 or not shot.special)
                                and overlapsShot(shot, bias, front, back, right, left) then
                                local damage = shot.damage
                                shot.pendingHit, shot.damage = true, program.s16(damage - part.hp)
                                if not run.dual then damage = damage - math.floor(damage / 4) end
                                if bank == 1 and u16(part.h) >= 0x6f00 then damage = 0 end
                                part.damage(part, damage, hitFlags)
                                if part.hp < 0 then break end
                            end
                        end
                    end
                end
            end
        end
    end

    -- 0x1441ec 的低位只控制机体接触。射击仍使用各自的 0x2000 标志。
    function M.body(run, player)
        local front, back, right, left = bounds(player, 0x2800)
        for bank = 1, 2 do
            for index = 1, bank == 1 and 100 or 50 do
                local enemy = run.partSlots[bank][index]
                if enemy and band(enemy.flags, 0x8001) == 0x8001 then
                    local ef, eb, er, el = bounds(enemy, 0x2800)
                    if eb < 0xf800 and front >= eb and back <= ef and right >= el and left <= er then
                        enemy.damage(enemy, 1, player.hitFlags)
                        return enemy
                    end
                end
            end
        end
    end

    return M
end
