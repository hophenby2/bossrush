-- 三面舰艇各有两块判定，回调汇总本帧命中后再扣共用耐久。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local s16,addPacked = program.s16,program.addPacked
    local data = program.stage3Airships
    local fanBase = {[1]=0x08c00200,[2]=0x06bffdc0,[4]=0x06c00240,[7]=0x08bffe00}
    local turretPosition = {[3]={0x057ff900,0x0f000880},[6]={0x05800700,0x0efff780}}
    local sweepPosition = {[5]=0x0a7fff00,[8]=0x0a800100}
    local sweepAngles = {{0,4,8,12,16,-4,-8,-12,-16},{2,6,10,14,-2,-6,-10,-14}}
    local defaultPalette,flash = unpack(data.palette)

    local function wait(o,key,reload)
        o[key] = o[key]-1
        if o[key] >= 0 then return false end
        o[key] = reload
        return true
    end

    local function part(p,row)
        p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(row)
    end

    local function damage(o)
        local p = o.otherSide
        if o.impact or p.impact then
            o.health = o.health-band((o.damage or 0)+(p.damage or 0),0xffff)
            o.hp,p.hp = 0x7fff,0x7fff
            o.damage,p.damage,o.impact,p.impact = 0,0,nil,nil
            local old = o.palette == 25 and defaultPalette or o.palette
            o.palette = bxor(old,flash)
            if o.health < 0 then
                effects.emitSequence(o,o.variant.destruction)
                return false
            end
        else
            o.palette = o.health < o.warning and 25 or defaultPalette
        end
        return true
    end

    local function fire(o,kind,speed,angle,offset,precise)
        bullets.emit(o,kind,speed,angle,floor(offset/0x10000),s16(offset),precise)
    end

    -- 四向箭弹和平行圆弹各自计时，前后两组三连圆弹使用不同的速度修正。
    local function fan(o)
        local rank = o.run.volleyRank
        if o.radialCount == 0 and o.h >= 0x3000 and wait(o,'radialClock',0x10-floor(rank/4)) then
            o.radialCount = 5
        end
        if o.radialCount > 0 and wait(o,'radialGap',2) then
            for ray=0,3 do
                local angle = o.angle+ray*0x40
                local offset = program.mid2.muzzle1[floor(band(angle+2,0xfc)/4)+1]+fanBase[o.variantIndex]
                fire(o,13,-4,angle,offset,true)
            end
            o.angle,o.radialCount = band(o.angle+6,255),o.radialCount-1
        end
        if not o.roundReady and o.h >= 0x800 and wait(o,'roundClock',0x18-floor(rank/2)) then
            o.roundReady = true
        end
        if o.roundReady and wait(o,'roundGap',6) then
            for i,row in ipairs(o.variant.guns) do fire(o,10,i <= 3 and 2 or -8,row[2],row[1],true) end
            o.roundReady = false
        end
    end

    local function track(o,aim,offset)
        local h = s16(o.h+floor((offset+0x8000)/0x10000))
        local l = s16(o.l+s16(offset))
        return program.towards(aim,program.angle(h,l,o.run.player,aim))
    end

    -- 0x1543e2 只更新待发炮的反侧瞄准，当前炮的七次发射共享一个方向。
    local function doubleTurret(o)
        local positions = turretPosition[o.variantIndex]
        local waiting = o.side == 1 and 2 or 1
        o.aim[waiting] = track(o,o.aim[waiting],positions[waiting])
        if o.h < 0x1400 then return end
        if o.radialCount == 0 and wait(o,'radialClock',0) then o.radialCount = 7 end
        if o.radialCount > 0 and wait(o,'radialGap',5) then
            local aim = o.aim[o.side]
            local offset = data.muzzle[floor(band(aim,0x3e)/2)+1]+positions[o.side]
            fire(o,6,1,aim*4,offset,false)
            o.radialCount = o.radialCount-1
            if o.radialCount == 0 then o.side = 3-o.side end
        end
    end

    -- 0x153536 和 0x153580 在同一个炮口交错发出九路和八路。
    local function sweep(o)
        local position = sweepPosition[o.variantIndex]
        if o.radialCount == 0 then
            if o.h < 0x1400 then return end
            o.aim = track(o,o.aim,position)
            if not wait(o,'radialClock',0x40-o.run.sweepFireRank) then return end
            o.radialCount = 4
        end
        if wait(o,'radialGap',6) then
            local aim = o.aim
            local offset = data.sweepMuzzle[floor(band(aim,0x3e)/2)+1]+position
            for _,angle in ipairs(sweepAngles[o.side]) do fire(o,2,-1,(aim+angle)*4,offset,false) end
            o.side,o.radialCount = 3-o.side,o.radialCount-1
        end
    end

    local function make(index)
        local variant = data.variants[index]
        local isFan = fanBase[index] ~= nil
        local shoot = isFan and fan or (turretPosition[index] and doubleTurret or sweep)
        local flip = index <= 3 or index == 8
        local reversePropeller = index == 2 or index == 7 or index == 8
        local H = {parts=2}

        function H.init(o)
            local run = o.run
            o.variant,o.variantIndex,o.health = variant,index,variant.health
            o.otherSide = {}
            o.extraParts = {o.otherSide}
            part(o,variant.parts[1])
            part(o.otherSide,variant.parts[2])
            if not path.attach(o,o.row) then return false end
            o.otherSide.h,o.otherSide.l = o.h,o.l
            o.palette,o.warning = defaultPalette,isFan and 0x200 or 0xaa
            o.radialClock,o.radialGap,o.radialCount,o.roundClock = 0x40-run.tankFireRank,0,0,0x40-run.tankFireRank
            o.animation,o.animClock = 0,0
            if isFan then
                o.angle,o.roundGap = program.random(run,program.randomByte),0
            else
                o.aim,o.side = turretPosition[index] and {0x20,0x20} or 0x20,1
            end
            return true
        end

        function H.step(o)
            if not damage(o) or not path.step(o,-o.run.groundScroll) then return false end
            local run = o.run
            o.otherSide.h,o.otherSide.l = o.h,o.l
            if band(o.l+0x1800+run.cameraOffset,0xffff)<0x6800 and
                band(o.h+(isFan and 0x1200 or 0x1400),0xffff)<(isFan and 0x9400 or 0x9800) then
                o.seen = true
            elseif o.seen then return false end
            if not run.freeze and not run.stopPathClock then
                shoot(o)
                if wait(o,'animClock',0) then
                    local forward = o.direction > 0x20
                    if reversePropeller then forward = o.direction < 0x20 end
                    o.animation = band(o.animation+(forward and 1 or -1),7)
                end
            end
            o.visible = true
            return true
        end

        function H.render(o)
            local assets = o.run.art
            if not assets or not o.visible then return end
            local palette = o.palette
            for _,row in ipairs(variant.images[palette]) do
                local h,l = addPacked(o.h,o.l,row[1])
                art.draw(assets.sprites[row[#row==2 and 2 or o.animation+2]],h,l,0,0,flip)
            end
            local positions = turretPosition[index]
            if positions then
                for i,aim in ipairs(o.aim) do
                    local h,l = addPacked(o.h,o.l,positions[i]+0xf800fb00)
                    local image = data.turrets[palette][floor(band(aim,0x3e)/2)+1]
                    art.draw(assets.sprites[image],h,l,0,0)
                end
            elseif not isFan then
                local h,l = addPacked(o.h,o.l,sweepPosition[index]+0xf600f900)
                local image = data.sweepTurrets[palette][floor(band(o.aim,0x3e)/2)+1]
                art.draw(assets.sprites[image],h,l,0,0)
            end
        end

        return H
    end

    local handlers = {}
    for index,callback in ipairs({0x151ca4,0x152a86,0x154306,0x152384,0x1530fa,0x153cd6,0x151568,0x15373e}) do
        handlers[callback] = make(index)
    end
    return handlers
end
