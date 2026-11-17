-- 0x1668a8 保留爆破后的地景对象。0x167038 的两门炮独立跟踪，轮流更新方向。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local data = program.stage2Forts
    local shed,cannons = {parts=1},{parts=2}
    local offsets = {0x07000640,0x0700f7c0}
    local muzzleL = {0x640,-0x840}

    local function attach(o,kind)
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(kind.body)
        o.normalPalette,o.flashMask = unpack(kind.palettes[o.run.stageNumber])
        o.palette = o.normalPalette
        return path.attach(o,o.row)
    end

    local function advance(o,hOffset,hLimit)
        if not path.step(o,-o.run.groundScroll) then return false end
        if band(o.h+hOffset,0xffff)<hLimit and band(o.l+0x1400+o.run.cameraOffset,0xffff)<0x6000 then
            o.seen = true
        elseif o.seen then return false end
        return true
    end

    local function hit(o,lowHealth,activeHp)
        if o.protection >= 0 then
            o.protection,o.damage = o.protection-1,0
            o.hp = o.protection<0 and activeHp or 0x7fff
        end
        if o.impact then
            o.impact,o.damage,o.flags = nil,0,band(o.flags,0xa6ff)
            o.palette = bxor(o.palette==25 and o.normalPalette or o.palette,o.flashMask)
            return o.hp<0
        end
        o.palette = o.hp<lowHealth and not o.run.dual and 25 or o.normalPalette
        return false
    end

    local function draw(o,id,offset)
        local h,l = program.addPacked(o.h,o.l,offset)
        art.draw(o.run.art.sprites[id],h,l,0,0)
    end

    function shed.init(o)
        if not attach(o,data.shed) then return false end
        local state = data.shed.state
        o.protection,o.destroyClock = state[8],state[6]
        if o.run.major >= 0xa0 then o.hp = 0x800 end
        return true
    end

    function shed.step(o)
        if not advance(o,0x2600,0x9600) then return false end
        if o.wreck then
            o.destroyClock = o.destroyClock-1
            return o.destroyClock>0
        end
        if hit(o,0x280,0xa00) then
            o.wreck,o.flags,o.palette = true,0x8080,o.normalPalette
            effects.emitSequence(o,data.shed.destruction)
        end
        return true
    end

    function shed.render(o)
        if not o.run.art then return end
        local group = data.shedImages[o.palette]
        draw(o,group[1],0x02000000)
        draw(o,group[2],0x02000e00)
        draw(o,group[3],0x00000400)
    end

    function cannons.init(o)
        if not attach(o,data.cannons) then return false end
        local run,state = o.run,data.cannons.state
        o.protection,o.shotClock = state[42],state[9]-run.fortStartRank
        o.trackClock,o.trackFrame,o.drawH = 1,0,-0xc00
        o.burst,o.burstSize,o.waves,o.waveSize = state[11],state[12],state[29],state[30]
        o.spread,o.aimClock,o.trackSide = state[32],0,1
        o.modifier,o.baseModifier = 0,0
        o.aims = {}
        for index,dl in ipairs(muzzleL) do
            o.aims[index] = program.angle(o.h+0x700,o.l+dl,run.player,o.direction%64)
        end
        o.extraParts = {{flags=0x8000,h=o.h,l=o.l}}
        if run.stageNumber==2 or run.stageNumber==4 then run.bulletCapacity = 150 end
        if run.stageNumber==2 then run.stageFlags[0] = true end
        if run.stageNumber==4 then o.hp = 0x3000 end
        return true
    end

    local function fire(o,aim,offset)
        local h,l = program.addPacked(0,0,data.muzzle[floor(aim/2)+1]+offset)
        local angle = aim*4
        bullets.emit(o,22,o.modifier,angle,h,l,true)
        local d = o.spread
        local stage = o.run.stageNumber
        local kind = (stage==4 or stage==6) and 22 or 20
        local spread = stage==6 and {d,2*d,-d,-2*d,-3*d} or {d,-d,-2*d-8,2*d+8}
        for _,step in ipairs(spread) do bullets.emit(o,kind,o.modifier,angle+step,h,l,true) end
    end

    local function attack(o)
        local run = o.run
        o.aimClock = o.aimClock-1
        if o.aimClock < 0 then
            o.aimClock = data.cannons.state[14]
            if o.burst==o.burstSize and run.player and run.player.active then
                local side = o.trackSide
                local aim = o.aims[side]
                o.aims[side] = program.towards(aim,program.angle(o.h+0x700,o.l+muzzleL[side],run.player,aim))
                o.trackSide = 3-side
            end
        end
        if o.h < 0x3400 then return end
        o.shotClock = o.shotClock-1
        if o.shotClock >= 0 then return end
        o.shotClock = 4
        for index,aim in ipairs(o.aims) do fire(o,aim,offsets[index]) end
        o.modifier,o.spread,o.burst = o.modifier+2,o.spread-1,o.burst-1
        if o.burst >= 0 then return end
        o.burstSize,o.baseModifier,o.waves = o.burstSize+1,o.baseModifier+2,o.waves-1
        o.burst,o.modifier,o.shotClock = o.burstSize,o.baseModifier,0xa-floor(run.fortBurstRank/2)
        if o.waves >= 0 then return end
        o.waves,o.spread = o.waveSize,data.cannons.state[32]
        o.burstSize,o.burst,o.baseModifier,o.modifier = 2,2,0,0
        o.shotClock = 0x60-run.gunshipMainRank
    end

    function cannons.step(o)
        local run = o.run
        if not advance(o,0xc00,0x8800) then
            if run.stageNumber==2 then run.stageFlags[0] = false end
            return false
        end
        if hit(o,0xa00,0x2800) then
            effects.emitSequence(o,data.cannons.destruction)
            if run.stageNumber==2 then run.stageFlags[0] = false end
            return false
        end
        if not run.stopPathClock and not run.freeze then
            o.drawH = -0xc00
            if o.direction<0x40 then
                o.trackClock = o.trackClock-1
                if o.trackClock < 0 then
                    o.trackClock,o.drawH = 1,-0xc40
                    o.trackFrame = (o.trackFrame+(o.direction==0x10 and 1 or -1))%4
                end
            end
            if not run.blockEnemyFire then attack(o) end
        end
        return true
    end

    function cannons.render(o)
        if not o.run.art then return end
        local images = data.cannonImages[o.palette]
        art.draw(o.run.art.sprites[images.body[1]],o.h,o.l,o.drawH,-0x1100)
        draw(o,images.tracks[o.trackFrame+1],0xfa000000+0xfc00f500)
        draw(o,images.hullDetail[1],0x1200ff00+0xfc00f900)
        for side,aim in ipairs(o.aims) do
            draw(o,images.turrets[floor(aim/2)+1],offsets[side]+0xf800fa00)
        end
    end

    return shed,cannons
end
