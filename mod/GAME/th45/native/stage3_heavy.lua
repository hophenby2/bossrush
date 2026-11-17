-- 0x154a62 汇总四块判定的伤害，侧炮拆除后只保留中央炮的循环。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local s16,addPacked = program.s16,program.addPacked
    local data = program.stage3Heavy
    local H = {parts=4}
    local fan = {0,4,8,-4,-8}

    function H.init(o)
        o.extraParts = {}
        for i,row in ipairs(data.parts) do
            local p = i==1 and o or {}
            p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(row)
            if i>1 then o.extraParts[i-1] = p end
        end
        if not path.attach(o,o.row) then return false end
        o.health,o.palette,o.rotorPalette = 0x2100,19,10
        o.phase,o.clock,o.lid,o.lidMotion,o.flaps,o.rotor = 0,0x40-o.run.tankFireRank,0,0,0,0
        for _,p in ipairs(o.extraParts) do p.h,p.l = o.h,o.l end
        return true
    end

    local function damage(o)
        local total,hit = o.damage or 0,o.impact
        for _,p in ipairs(o.extraParts) do
            total = total+(p.damage or 0)
            hit = hit or p.impact
            p.hp,p.damage,p.impact = 0x7fff,0,nil
        end
        if not hit then
            o.palette,o.rotorPalette = 19,10
            if o.health<0x180 then o.palette,o.rotorPalette = 25,25 end
            return true
        end
        o.hp,o.damage,o.impact = 0x7fff,0,nil
        o.health = o.health-band(total,0xffff)
        if o.palette==25 then o.palette,o.rotorPalette = 19,10 end
        o.palette,o.rotorPalette = bxor(o.palette,12),bxor(o.rotorPalette,21)
        if o.health<=0x900 and not o.broken then
            o.broken,o.lidMotion,o.phase = true,1,2
            o.extraParts[2].flags,o.extraParts[3].flags = 0x8000,0x8000
            effects.emitSequence(o,data.blasts[1])
        elseif o.health<0 then
            effects.emitSequence(o,data.blasts[2])
            return false
        end
        return true
    end

    local function emit(o,kind,speed,angle,muzzle,precise)
        bullets.emit(o,kind,speed,angle,s16(floor(muzzle/0x10000)),s16(muzzle),precise)
    end

    local function openCenter(o)
        o.phase,o.lidMotion,o.gap,o.count,o.aim = 3,1,16,2,0x80
    end

    local function fire(o)
        local run = o.run
        if o.lidMotion==1 then
            o.lid = math.min(o.lid+1,7)
            if o.lid==7 then o.lidMotion=0 end
        elseif o.lidMotion==2 then
            o.lid = math.max(o.lid-1,0)
            if o.lid==0 then o.lidMotion=0 end
        end
        if o.phase==0 then
            if o.broken then openCenter(o)
            else
                o.flaps = math.max(o.flaps-0x40,0)
                if o.h>=0x1400 and not run.blockEnemyFire then
                    o.clock = o.clock-1
                    if o.clock<0 then
                        o.clock,o.phase = 0x50-run.tankFireRank,1
                    end
                end
            end
        end
        if o.phase==1 then
            o.flaps = o.flaps+0x40
            if o.flaps>=0x200 then
                o.phase,o.flaps,o.gap,o.count,o.sideAim = 2,0x180,16,4,nil
            end
        end
        if o.phase==2 then
            if o.broken then openCenter(o)
            else
                o.gap = o.gap-1
                if o.gap>=0 then return end
                o.gap = 4
                if not o.sideAim then
                    local p = run.player
                    o.sideAim = {program.angle(s16(o.h-0x1200),s16(o.l+0x500),p,0x20),
                                 program.angle(s16(o.h-0x1200),s16(o.l-0x500),p,0x20)}
                end
                if o.h<0x1400 then openCenter(o)
                else
                    if not run.blockEnemyFire then
                        for side=1,2 do
                            local base = side==1 and 0xee000500 or 0xedfffb00
                            for _,d in ipairs(fan) do
                                local angle = band(o.sideAim[side]+d,63)
                                emit(o,13,5,angle*4,program.mid2.muzzle0[angle+1]+base,false)
                            end
                        end
                    end
                    o.count = o.count-1
                    if o.count==0 then openCenter(o) end
                end
            end
        end
        if o.phase~=3 or o.lidMotion~=0 then return end
        o.flaps = math.max(o.flaps-0x40,0)
        o.gap = o.gap-1
        if o.gap>=0 then return end
        o.gap = 16
        if o.h<0x1400 then o.phase,o.lidMotion = 0,2; return end
        if not run.blockEnemyFire then
            for ray=0,4 do
                local a = o.aim-22+ray*11
                local muzzle = data.muzzle[floor(band(a+2,0xfc)/4)+1]
                emit(o,10,0,a,muzzle,true)
            end
            for ray=0,4 do
                local a = o.aim-16+ray*8
                local muzzle = data.muzzle[floor(band(a+2,0xfc)/4)+1]
                emit(o,10,-4,a,muzzle,true)
            end
        end
        o.count = o.count-1
        if o.count==0 then
            o.count,o.aim = 2,program.angle8(o.h,o.l,run.player,0x80)
            if not o.broken then o.phase,o.lidMotion = 0,2 end
        end
    end

    function H.step(o)
        local run = o.run
        if not damage(o) or not path.step(o,-run.groundScroll) then return false end
        o.extraParts[1].h,o.extraParts[1].l = o.h,o.l
        o.extraParts[2].h,o.extraParts[2].l = addPacked(o.h,o.l,0xf5800500)
        o.extraParts[3].h,o.extraParts[3].l = addPacked(o.h,o.l,0xf57ffb00)
        if band(o.l+0x1800+run.cameraOffset,0xffff)<0x6800 and band(o.h+0xc00,0xffff)<0x9000 then
            o.seen = true
        elseif o.seen then return false end
        if not run.freeze and not run.stopPathClock then
            fire(o)
            o.rotor = (o.rotor-1)%30
        end
        o.visible = true
        return true
    end

    function H.render(o)
        if not o.run.art or not o.visible then return end
        local function draw(image,offset,flip)
            local h,l = addPacked(o.h,o.l,offset)
            art.draw(o.run.art.sprites[image],h,l,0,0,flip)
        end
        local bank = data.images[o.palette]
        local parts = o.broken and bank.wreck or bank.body
        for _,row in ipairs(parts) do
            local offset = row[2]
            if row[3] then offset = floor(offset/0x10000)*0x10000+band(offset+row[3]*o.flaps,0xffff) end
            draw(row[1],offset)
        end
        local row = bank.lid[o.lid+1]
        draw(row[1],row[2])
        local rotor = data.rotors[o.rotorPalette][o.rotor+1]
        draw(rotor[1],rotor[2])
        draw(rotor[1],rotor[3],true)
    end

    return H
end
