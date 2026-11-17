-- 0x166be8 首次击破关闭炮台，底座保留判定和第二段耐久。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local data = program.stage3Platform
    local M = {parts=1}

    function M.init(o)
        local run = o.run
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(data.body)
        o.normalPalette,o.flashMask = unpack(data.palettes[run.stageNumber])
        o.palette,o.baseHp = o.normalPalette,o.hp
        if run.stageNumber == 3 and run.major >= 0x170 then o.hp,o.baseHp = 0x180,0x180 end
        if run.stageNumber == 4 then o.hp,o.baseHp = 0x140,0x100 end
        if not path.attach(o,o.row) then return false end
        o.aim = program.angle(o.h,o.l,run.player,o.direction%64)
        o.aimClock,o.shotClock = 1,0x48-run.tankFireRank
        o.burstReload = run.stageNumber == 4 and 1 or 2
        o.burst,o.wave = o.burstReload,1
        return true
    end

    local function hit(o)
        if not o.impact then
            o.palette = o.hp < 0xc0 and 25 or o.normalPalette
            return true
        end
        o.impact,o.damage = nil,0
        o.palette = bxor(o.palette == 25 and o.normalPalette or o.palette,o.flashMask)
        if o.hp >= 0 then return true end
        local wreck = o.wreck
        effects.emit(o,wreck and 0x88 or 0x84,0,0,wreck and 0xfc00fe00 or 0xfe00fe00,true)
        if wreck then return false end
        o.wreck,o.flags,o.hp = true,0xa280,o.baseHp
        return true
    end

    local function attack(o)
        local run = o.run
        o.aimClock = o.aimClock-1
        if o.aimClock < 0 then
            o.aimClock = 1
            if o.burst == o.burstReload then o.aim = program.towards(o.aim,program.angle(o.h,o.l,run.player,o.aim)) end
        end
        if o.h < 0x2800 then return end
        o.shotClock = o.shotClock-1
        if o.shotClock >= 0 then return end
        local aim = band(o.aim,0x3e)
        local offset = data.muzzle[floor(aim/2)+1]
        bullets.emit(o,0,0,aim*4,floor(offset/0x10000),program.s16(offset),false)
        o.shotClock,o.burst = 4,o.burst-1
        if o.burst >= 0 then return end
        o.shotClock,o.burst,o.wave = 0x18,o.burstReload,o.wave-1
        if o.wave < 0 then o.shotClock,o.wave = 0x64-run.platformFireRank,1 end
    end

    function M.step(o)
        if not path.step(o,-o.run.groundScroll) then return false end
        local run = o.run
        if band(o.l+0xe00+run.cameraOffset,0xffff)<0x5400 and band(o.h+0x800,0xffff)<0x8000 then
            o.seen = true
        elseif o.seen then return false end
        if not hit(o) then return false end
        if not o.wreck and not run.freeze and not run.stopPathClock then attack(o) end
        o.visible = true
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local group = data.images[o.palette]
        local index = o.wreck and 1 or floor(band(o.aim,0x3e)/2)+2
        art.draw(assets.sprites[group[index]],o.h,o.l,-0x800,-0x600)
    end

    return M
end
