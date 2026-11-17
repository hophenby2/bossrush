-- 0x16c36a 的机身与翼炮分别追踪自机，只有机身登记受击框。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local s16 = program.s16
    local M = {parts=1}
    local mainAngles,wingAngles = {0,0x18,-0x18},{0,0x10,0x20,-0x10,-0x20}

    local function aimBody(o,aim)
        o.mainAim = aim
        o.shape = program.gunshipShapes[aim + 1]
    end

    function M.init(o)
        local data = program.gunshipStart
        o.flags,o.hp,o.front,o.back,o.right,o.left,o.speed = unpack(data.body)
        o.normalPalette,o.flashPalette,o.deathClock,o.guardClock = unpack(data.status)
        o.palette = o.normalPalette
        o.mainClock,o.mainCount,o.bodyAimClock = unpack(data.main)
        o.wingClock,o.wingCount,o.wingAimClock = unpack(data.wing)
        o.smokeClock = 0
        if not path.attach(o,o.row) then return false end
        local aim = program.angle(o.h,o.l,o.run.player,0x20)
        aimBody(o,aim)
        o.wingAim = {aim,aim}
        return true
    end

    local function track(o)
        local p = o.run.player
        local data = program.gunshipStart
        o.bodyAimClock = o.bodyAimClock - 1
        if o.bodyAimClock < 0 then
            o.bodyAimClock = data.main[3]
            if o.mainCount == data.main[2] then
                local aim = o.mainAim
                aimBody(o,program.towards(aim,program.angle(o.h,o.l,p,aim)))
            end
        end
        o.wingAimClock = o.wingAimClock - 1
        if o.wingAimClock < 0 then
            o.wingAimClock = data.wing[3]
            if o.wingCount == data.wing[2] then
                for wing = 1,2 do
                    local dh,dl = program.addPacked(0,0,o.shape[3 + wing])
                    local aim = o.wingAim[wing]
                    o.wingAim[wing] = program.towards(aim,program.angle(s16(o.h + dh),s16(o.l + dl),p,aim))
                end
            end
        end
    end

    local function fire(o)
        local run = o.run
        -- 0x16c732 只扰动中间弹的方向，三颗共用这次算出的炮口。
        o.mainClock = o.mainClock - 1
        if o.mainClock < 0 then
            o.mainClock = 6
            local jitter = program.random(run,program.randomNarrow)
            if jitter >= 0x80 then jitter = jitter - 0x100 end
            local angle = band(o.mainAim * 4 + floor(jitter / 2),255)
            local extension = program.gunshipMainShotOffsets[floor(band(angle + 2,0xfc) / 4) + 1]
            local dh,dl = program.addPacked(0,0,program.gunshipMainMuzzles[o.mainAim + 1] + extension)
            for _,delta in ipairs(mainAngles) do bullets.emit(o,2,4,angle + delta,dh,dl,true) end
            o.mainCount = o.mainCount - 1
            if o.mainCount < 0 then
                o.mainCount,o.mainClock = program.gunshipStart.main[2],0x60 - run.gunshipMainRank
            end
        end
        -- 0x16c7c4 与 0x16c826 各用自己的翼炮方向和安装坐标。
        o.wingClock = o.wingClock - 1
        if o.wingClock >= 0 then return end
        o.wingClock = 6
        for wing,aim in ipairs(o.wingAim) do
            local index = floor(aim / 2) + 1
            local dh,dl = program.addPacked(0,0,o.shape[3 + wing] + program.gunshipWingMuzzles[index])
            local angle = band(aim,0x3e) * 4
            for _,delta in ipairs(wingAngles) do bullets.emit(o,0x0d,2,angle + delta,dh,dl,true) end
        end
        o.wingCount = o.wingCount - 1
        if o.wingCount < 0 then
            o.wingCount,o.wingClock = program.gunshipStart.wing[2],0x80 - run.gunshipWingRank
        end
    end

    local function damage(o)
        if o.guardClock >= 0 then
            o.damage = 0
            o.guardClock = o.guardClock - (o.run.dual and 2 or 1)
            o.hp = o.guardClock >= 0 and 0x7fff or program.gunshipStart.body[2]
        end
        if o.impact then
            o.impact = nil
            o.flags = band(o.flags,0xa6ff)
            if o.hp < 0 then
                o.flags,o.palette,o.dying,o.visible = 0x8080,o.normalPalette,true,false
                return false
            end
            local base = o.palette == 25 and o.normalPalette or o.palette
            o.palette = bxor(base,o.flashPalette)
        elseif o.hp < 0x600 and band(o.run.frame,15) < 2 then
            o.palette = 25
        else
            o.palette = o.normalPalette
        end
        return true
    end

    local function dying(o)
        local run = o.run
        if run.stopPathClock then return true end
        if o.deathClock >= 0x2a then
            o.smokeClock = o.smokeClock - 1
            if o.smokeClock < 0 then
                o.smokeClock = 2
                -- 0x16c3bc 为爆声取一次随机数，后续碎片以同一游标继续取样。
                program.nextRandom(run)
                local kind = program.gunshipSmoke[band(program.random(run,program.randomByte),7) + 1]
                local angle = band(program.random(run,program.randomHalf,127) + 0x60,255)
                local h = program.gunshipSmokeH[program.nextRandom(run,63)]
                local l = program.gunshipSmokeL[program.nextRandom(run,63)]
                local dh,dl = s16(h - 0x800),s16(l * 2)
                effects.emit(o,kind,2,angle,dh * 0x10000 + band(dl,0xffff),false,0,7)
            end
        end
        o.deathClock = o.deathClock - 1
        if o.deathClock == 0x14 then effects.emitSequence(o,program.gunshipDestruction) end
        return o.deathClock > 0
    end

    function M.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.h + 0x1600,0xffff) < 0x9c00 then
            o.seen = true
        elseif o.seen then
            return false
        end
        o.visible = true
        if o.dying then return dying(o) end
        if not damage(o) then return true end
        if not run.freeze and not run.stopPathClock then
            track(o)
            if o.h >= 0x4400 and not run.blockEnemyFire then fire(o) end
        end
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local images = program.gunshipImages[o.palette]
        local sprites = assets.sprites
        local shape = o.shape
        art.draw(sprites[images[1][o.mainAim + 1]],o.h,o.l,shape[1],shape[2],o.mainAim > 0x20)
        for wing,aim in ipairs(o.wingAim) do
            local index = floor(aim / 2) + 1
            local h,l = program.addPacked(o.h,o.l,shape[3 + wing] + program.gunshipWingSprites[index])
            art.draw(sprites[images[2][index]],h,l,0,0)
        end
    end

    return M
end
