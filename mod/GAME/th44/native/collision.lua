-- 0x1442cc 与 0x14432c。先遍历部件槽，再遍历自机弹槽。
return function(program)
    local bit = require('bit')
    local band,bor = bit.band,bit.bor
    local min,max,floor = math.min,math.max,math.floor
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
                                -- 0x15e916 把单人局的 $812ff0 设为 1，双人局设为 0。
                                if run.dual then damage = damage - floor(damage / 4) end
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

    -- 0x1444e2 先结算炮口判定，0x144702 再依次扫描两组机体槽并收短激光。
    function M.laser(run,p,beam)
        if run.frame % 2 == 0 then return end
        local bias = 0x2800
        local flags = bor(p.hitFlags,0x400)
        local _,_,haloFront,haloBack,haloRight,haloLeft = unpack(beam.profile.halo)
        local h,l = p.h + bias,p.l + bias
        local hf,hb,hr,hl = h + haloFront,h - haloBack,l + haloRight,l - haloLeft
        local front,back = u16(beam.h + bias + 0x400 + beam.length),u16(beam.h + bias)
        local right,left = u16(beam.l + bias + beam.right),u16(beam.l + bias - beam.left)
        local initial = not beam.armed
        local damage = beam.damage
        local stop,hit = 0x7400 + bias,false
        beam.armed = true
        for bank = 1,2 do
            local parts = run.partSlots[bank]
            local limit = bank == 1 and 100 or 50
            for i = 1,limit do
                local o = parts[i]
                -- 0x144556 的炮口只处理高字节第 5 位或第 0 位有效的部件。
                if o and band(o.flags,0x8000) ~= 0 and band(o.flags,0x2100) ~= 0 and o.hp >= 0 then
                    local of,ob,oright,oleft = bounds(o,bias)
                    if ob < 0x9800 and of >= hb and ob <= hf and oright >= hl and oleft <= hr and u16(o.h) < 0x6f00 then
                        local amount = p.hyperPower and damage * 2 or damage
                        o.damage(o,run.dual and amount - floor(amount / 2) or amount,flags)
                    end
                    if not initial and o.hp >= 0 and band(o.flags,0x2000) ~= 0 and ob < 0x9800
                        and of >= back and ob <= front and oright >= left and oleft <= right then
                        local through = not p.hyperPower and bank == 1 and p.doll ~= 1 and band(o.flags,0x0200) ~= 0
                        if through or ob < stop then
                            if not through then
                                stop = ob >= back and ob or back + 0x400
                                front,hit = min(front,stop),true
                            end
                            local amount = through and damage * 2 or damage
                            if p.hyperPower then
                                amount = amount + floor(amount / 4) * p.hyperPower
                            end
                            if bank == 2 then damage = floor(damage / 8) end
                            if run.dual then amount = amount - floor(amount / 4) end
                            o.damage(o,bank == 1 and u16(o.h) >= 0x6f00 and 0 or amount,flags)
                        end
                    end
                end
            end
        end
        if not initial then beam.endH,beam.hit = max(0,stop - bias),hit end
    end

    -- 0x144964 的普通炸弹横扫整个可接战范围，每次扫描只扣一次。
    function M.shotBomb(run,p)
        for bank = 1,2 do
            local parts = run.partSlots[bank]
            for i = 1,bank == 1 and 100 or 50 do
                local o = parts[i]
                if o and band(o.flags,0xa000) == 0xa000 and o.hp >= 0 then
                    local _,back = bounds(o,0x2800)
                    if back <= 0x9800 and o.h + o.front < 0xd800 and o.l + o.right >= 0
                        and u16(o.l - o.left + 0x2800) <= 0x6000 then o.damage(o,0x50,p.hitFlags) end
                end
            end
        end
    end

    local function meets(o,box)
        return o.h + o.front >= box.h - box.back and o.h - o.back <= box.h + box.front
            and o.l + o.right >= box.l - box.left and o.l - o.left <= box.l + box.right
    end

    -- 0x144a5c 先选阻挡激光的地物，0x144b60 才让沿途各束分别命中飞行部件。
    function M.laserBomb(run,p,bomb,boxes)
        local nearest,stop = nil,0x7800
        for i = 1,50 do
            local o = run.partSlots[2][i]
            if o and band(o.flags,0xa100) > 0x8000 and o.hp >= 0 then
                local h = max(p.h + 0xc00,o.h - o.back)
                if h < stop then
                    for slot = 1,41 do
                        local box = bomb.trail[slot]
                        if box and meets(o,box) then nearest,stop = o,h; break end
                    end
                end
            end
        end
        local flags = bor(p.hitFlags,0x400)
        if nearest then nearest.damage(nearest,0x208,flags) end
        bomb.groundHit,bomb.endH = nearest,stop
        for i = 1,100 do
            local o = run.partSlots[1][i]
            if o and band(o.flags,0xa100) > 0x8000 and o.hp >= 0 and u16(o.h) < 0x7000
                and (not nearest or o.h < stop) then
                for _, box in ipairs(boxes) do
                    if meets(o,box) then
                        o.damage(o,0x1e0,flags)
                        if o.hp < 0 then break end
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
