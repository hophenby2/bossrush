-- 四面装甲机与坦克共用原版炮口表。机体、附属判定和炮塔各自推进。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bor = bit.band,bit.bor
    local floor,abs = math.floor,math.abs
    local s16,packed = program.s16,program.addPacked
    local data = program.stage4Armor
    local muzzle = program.stage3Heavy.muzzle

    local function attach(o,variant)
        o.extraParts = {}
        for i,box in ipairs(variant.boxes) do
            local p = i==1 and o or {}
            p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(box)
            if i>1 then o.extraParts[i-1]=p end
        end
        o.speed = 0
        if not path.attach(o,o.row) then return false end
        for _,p in ipairs(o.extraParts) do p.h,p.l=o.h,o.l end
        return true
    end

    local function visible(o,top,vertical,side,horizontal)
        if band(o.h+top,0xffff)<vertical and band(o.l+side+o.run.cameraOffset,0xffff)<horizontal then
            o.seen = true
            return true
        end
        return not o.seen
    end

    local function sharedDamage(o,normal,warning)
        local hit,total = o.impact,o.damage or 0
        for _,p in ipairs(o.extraParts) do
            hit,total = hit or p.impact,total+(p.damage or 0)
            p.impact,p.damage,p.hp = nil,0,0x7fff
        end
        o.impact,o.damage,o.hp = nil,0,0x7fff
        if o.protection>=0 then o.protection,total=o.protection-1,0 end
        if hit then
            o.health = o.health-band(total,0xffff)
            o.palette = o.palette==31 and normal or 31
        else o.palette = o.health<warning and 25 or normal end
        return o.health>=0
    end

    local function emit(o,kind,speed,angle,offset,extend)
        if extend then offset=offset+muzzle[floor(band(angle+2,0xfc)/4)+1] end
        bullets.emit(o,kind,speed,angle,s16(floor(offset/0x10000)),s16(offset),true)
    end

    local function draft(o,kind,bank,index,offset,flip)
        local h,l = packed(o.h,o.l,offset)
        local image = data.images[kind][bank][index]
        art.draw(o.run.art.sprites[image],h,l,0,0,flip)
    end

    local function range(o)
        local p = o.run.player
        if not p or not p.active then return false end
        local dh,dl = abs(s16(o.h-p.h)),abs(s16(o.l-p.l))
        dh = dh-floor(dh/4)
        return math.max(dh,dl)+floor(math.min(dh,dl)/2)>=program.patrolFireDistance[o.run.stageNumber]
    end

    local air = {parts=2}
    function air.init(o)
        local run = o.run
        if run.stageNumber==4 and run.stageFlags[0] then return false end
        if not attach(o,data.air) then return false end
        local state = data.air.state
        o.palette,o.health,o.protection = 9,state[15],state[5]
        o.rotor,o.rotorClock,o.flap,o.flapClock = state[11]/16,1,state[13]/4,1
        o.centerClock = (run.stageNumber==4 and run.major<8 and 0x70 or floor(state[6]/256))-run.volleyRank
        o.centerLeft,o.sideClock,o.sideLeft = floor(state[7]/256),floor(state[17]/256),floor(state[18]/256)
        o.rightAim,o.leftAim = floor(state[8]/256),band(state[8],255)
        return true
    end

    local function broadside(o)
        local p = o.run.player
        o.sideClock = o.sideClock-1
        if o.sideClock>=0 then return end
        o.sideClock,o.flapOpen = 3,true
        if o.sideLeft==7 then
            if not p or not p.active then return end
            o.wingA = program.angle8(s16(o.h-0x7c0),s16(o.l+0x440),p,0x80)
            o.wingB = program.angle8(s16(o.h-0x7c0),s16(o.l-0x540),p,0x80)
        end
        for _,d in ipairs({-12,0,12}) do emit(o,13,6,o.wingA+d,0xf8400440,true) end
        for _,d in ipairs({-12,0,12}) do emit(o,13,6,o.wingB+d,0xf840fac0,true) end
        o.sideLeft = o.sideLeft-1
        if o.sideLeft<0 then
            o.sideClock,o.sideLeft,o.sideActive,o.flapOpen = 0x10,7,false,false
        end
    end

    local function nose(o)
        local run = o.run
        o.centerClock = o.centerClock-1
        if o.centerClock>=0 then return end
        o.centerClock = 4
        if o.centerLeft==8 then
            if not run.player or not run.player.active then return end
            local aim = program.angle8(s16(o.h-0x240),o.l,run.player,0x80)
            o.rightAim,o.leftAim = aim-0x24,aim+0x24
        end
        for _,d in ipairs({-12,0,12,24}) do emit(o,0x15,1,o.rightAim+d,0xfdc00300,true) end
        for _,d in ipairs({12,0,-12,-24}) do emit(o,0x15,1,o.leftAim+d,0xfdc0fd40,true) end
        o.rightAim,o.leftAim,o.centerLeft = o.rightAim+1,o.leftAim-1,o.centerLeft-1
        if o.centerLeft<0 then
            o.centerClock,o.centerLeft,o.sideActive = 0x20-floor(run.volleyRank/2),8,true
            o.rightAim,o.leftAim = 0x5c,0xa4
        end
    end

    function air.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) or not visible(o,0xc00,0x8800,0x1200,0x5c00) then return false end
        o.extraParts[1].h,o.extraParts[1].l = o.h,o.l
        if not sharedDamage(o,9,0x580) then effects.emitSequence(o,data.airBlast); return false end
        o.rotorClock = o.rotorClock-1
        if o.rotorClock<0 then o.rotor,o.rotorClock=(o.rotor-1)%30,1 end
        if o.flapOpen then
            o.flapClock = o.flapClock-1
            if o.flapClock<0 then o.flap,o.flapClock=(o.flap-1)%8,1 end
        end
        if not run.freeze and not run.stopPathClock and o.h>=0x1800 then
            if o.sideActive then broadside(o) else nose(o) end
        end
        return true
    end

    function air.render(o)
        local assets = o.run.art
        if not assets then return end
        draft(o,'air',o.palette,1,0xe2000000)
        draft(o,'air',o.palette,o.flap+2,0xf5800240)
        draft(o,'air',o.palette,o.flap+2,0xf580f8c0,true)
        local bank = o.palette==9 and 10 or o.palette
        local rotor = data.images.rotors[bank][o.rotor+1]
        for i=2,3 do
            local h,l = packed(o.h,o.l,rotor[i])
            art.draw(assets.sprites[rotor[1]],h,l,0,0,i==3)
        end
    end

    local tank = {parts=1}
    function tank.init(o)
        if not attach(o,data.tank) then return false end
        local run,state = o.run,data.tank.state
        o.palette,o.protection,o.fireClock,o.aim = 8,state[13],floor(state[5]/256)-run.tankFireRank,0x20
        o.type,o.frameIndex = band(o.direction,0x38)/8,0
        o.groups,o.reloadGroups,o.modifier,o.trackClock = 0,1,s16(state[19]),1
        if run.stageNumber==4 and run.major>=0x230 then o.hp=0x400 end
        if o.direction==0x10 or o.direction==0x30 then o.front,o.back,o.right,o.left=0x780,0x780,0x780,0x780 end
        if band(o.flags,0x2000)==0 then
            o.grow = o.part[0x1e]==1 and 'back' or 'front'
            o[o.grow],o.fireClock = -0xa00,0x40
            o.part[0x1e] = 0
        end
        return true
    end

    local function tankFire(o)
        local run = o.run
        if o.h<0x3000 or band(o.flags,0x2000)==0 or not range(o) then return end
        o.fireClock = o.fireClock-1
        if o.fireClock>=0 then return end
        o.fireClock = 5
        local base = data.tankMuzzles[floor(o.aim/2)+1]+0x03800000
        for _,d in ipairs({-16,0,16}) do
            emit(o,6,o.modifier,o.aim*4+d,base,true)
            emit(o,6,o.modifier+2,o.aim*4+d,base,true)
        end
        o.groups = o.groups-1
        if o.groups<0 then
            o.groups,o.modifier,o.fireClock = 0,-2,0x10-floor(run.volleyRank/4)
            o.reloadGroups = o.reloadGroups-1
            if o.reloadGroups<0 then o.reloadGroups,o.fireClock=1,0x30-run.volleyRank end
        end
    end

    function tank.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) or not visible(o,0xe00,0x8c00,0x1200,0x5c00) then return false end
        local dh = o.direction<0x40 and not run.stopPathClock and not run.freeze and o.dh or 0
        if o.grow and band(o.flags,0x2000)~=0 and o[o.grow]<0xa00 then
            o[o.grow] = s16(o[o.grow]+(o.grow=='front' and -dh or dh))
        end
        if o.protection>=0 then
            o.protection = o.protection-1
            o.hp = o.protection<0 and 0xa00 or 0x7fff
        end
        if o.impact then
            o.impact,o.damage = nil,0
            o.palette = o.palette==31 and 8 or 31
            if o.hp<0 then effects.emitSequence(o,data.tankBlast); return false end
        else o.palette = o.hp<0x280 and 25 or 8 end
        if not run.freeze and not run.stopPathClock then
            if o.direction<0x40 then
                o.trackClock = o.trackClock-1
                if o.trackClock<0 then o.trackClock,o.frameIndex=1,(o.frameIndex-1)%3 end
            end
            o.aim = program.towards(o.aim,program.angle(s16(o.h+0x380),o.l,run.player,o.aim))
            tankFire(o)
        end
        return true
    end

    function tank.render(o)
        if not o.run.art then return end
        draft(o,'tank',o.palette,o.type*3+o.frameIndex+1,0xf200f700)
        draft(o,'tankTurret',o.palette,floor(o.aim/2)+1,0xfb80f900)
    end

    local function carriers(mirror)
        local H = {parts=3}
        local side = mirror and 1 or -1
        local turret = mirror and 0xffc00380 or 0xffc0fc80
        local shells = mirror and {
            {1,-16,0x10000480},{1,-32,0x10000480},{1,16,0x0fc002c0},{1,32,0x0fc002c0},{1,0,0x0d800440},
            {2,0,0x0400f840},{2,16,0x01c0f840},{2,32,0x01c0f840},{2,-16,0x01c0f9c0},{2,-32,0x01c0f9c0},
        } or {
            {1,16,0x1000fb80},{1,32,0x1000fb80},{1,-16,0x0fc0fd40},{1,-32,0x0fc0fd40},{1,0,0x0d80fbc0},
            {2,0,0x040007c0},{2,-16,0x01c007c0},{2,-32,0x01c007c0},{2,16,0x01c00640},{2,32,0x01c00640},
        }
        local trackOffsets = mirror and {0xfe40f900,0xf3400040,0xfc800880}
            or {0xfe400700,0xf340ffc0,0xfc80f780}
        local doorOffsets = mirror and {0x0d800440,0x00c0f840} or {0x0d80fbc0,0x00c007c0}

        function H.init(o)
            if not attach(o,data.carrier) then return false end
            local state,run = data.carrier.state,o.run
            o.palette,o.health,o.protection,o.aim = 7,state[18],state[12],0x20
            o.hatch,o.hatchClock,o.track,o.trackClock,o.phase,o.aimClock = 0,1,0,1,0,0
            o.mainClock,o.sideClock = floor(state[5]/256)-run.volleyRank,floor(state[16]/256)-run.volleyRank
            o.mainShots,o.sideShots = floor(state[6]/256),floor(state[17]/256)
            if band(o.flags,0x2000)==0 then
                local flip = (o.part[0x1e] or 0)~=0
                o.growFirst = flip and 2 or 1
                o.growV = flip and 'back' or 'front'
                o.growH = flip==mirror and 'right' or 'left'
                o.part[0x1e] = 0
                for _,p in ipairs(o.extraParts) do
                    p.flags = band(p.flags,0xdfff)
                    p[o.growV],p[o.growH] = -0x800,-0x800
                end
            end
            return true
        end

        local function grow(o,p,dh,dl)
            local h,l = p[o.growV]<0x800,p[o.growH]<0x800
            if h then p[o.growV]=s16(p[o.growV]-dh) end
            if l then p[o.growH]=s16(p[o.growH]-dl) end
            return h,l
        end

        local function boxes(o)
            if not o.growFirst then return end
            local first,second = o.extraParts[o.growFirst],o.extraParts[3-o.growFirst]
            if band(o.flags,0x2000)==0 then
                first.flags,second.flags = band(first.flags,0xdfff),band(second.flags,0xdfff)
            else first.flags=bor(first.flags,0x2000) end
            if not o.part[0x1e] or o.part[0x1e]==0 then return end
            local run = o.run
            local dh,dl = 0,0
            if o.direction<0x40 and not run.stopPathClock and not run.freeze then dh,dl=o.dh,2*o.dl end
            if run.halfPathSpeed then dh,dl=floor(dh/2),floor(dl/2) end
            if o.growFirst==2 then dh,dl=-dh,-dl end
            if mirror then dl=-dl end
            local h,l = grow(o,first,dh,dl)
            if h and l then return end
            second.flags = bor(second.flags,0x2000)
            h,l = grow(o,second,dh,dl)
            if not h and not l then o.growFirst=nil end
        end

        local function wingFire(o)
            local p = o.run.player
            if o.sideShots==3 then
                if not p or not p.active then return false end
                o.aims = {program.angle8(s16(o.h+0xd80),s16(o.l+side*0x440),p,0x80),
                    program.angle8(s16(o.h+0x400),s16(o.l-side*0x7c0),p,0x80)}
            end
            for _,r in ipairs(shells) do emit(o,13,-1,o.aims[r[1]]+r[2],r[3]) end
            return true
        end

        local function wings(o)
            local run = o.run
            if not o.seen then return end
            if o.phase==0 then
                if o.h>=0x2c00 and band(o.flags,0x2000)~=0 then
                    o.sideClock = o.sideClock-1
                    if o.sideClock<0 then o.sideClock,o.phase=0x10,1 end
                end
            elseif o.phase==1 then
                o.hatchClock = o.hatchClock-1
                if o.hatchClock<0 then
                    o.hatch,o.hatchClock = o.hatch+1,1
                    if o.hatch==7 then o.phase=2 end
                end
            elseif o.phase==2 then
                o.sideClock = o.sideClock-1
                if o.sideClock<0 then
                    o.sideClock=6
                    if o.h<0x2c00 or wingFire(o) then
                        o.sideShots = o.sideShots-1
                        if o.sideShots<0 then o.sideShots,o.sideClock,o.phase=3,4,3 end
                    end
                end
            elseif o.sideClock>0 then o.sideClock=o.sideClock-1
            else
                o.hatchClock = o.hatchClock-1
                if o.hatchClock<0 then
                    o.hatch,o.hatchClock = o.hatch-1,1
                    if o.hatch==0 then o.sideClock,o.phase=0x50-run.tankFireRank,0 end
                end
            end
        end

        local function mainGun(o)
            local run = o.run
            o.aimClock = o.aimClock-1
            if o.aimClock<0 then
                o.aimClock = 4
                local aim = program.angle(s16(o.h-0x40),s16(o.l+side*0x380),run.player,o.aim)
                o.aim = program.towards(o.aim,aim)
            end
            if o.h<0x2c00 or band(o.flags,0x2000)==0 or not range(o) then return end
            o.mainClock = o.mainClock-1
            if o.mainClock>=0 then return end
            o.mainClock = 0xa
            local base = data.carrierMuzzles[floor(o.aim/2)+1]+turret
            for _,d in ipairs({-28,-14,0,14,28}) do emit(o,10,-3,o.aim*4+d,base,true) end
            o.mainShots = o.mainShots-1
            if o.mainShots<0 then o.mainShots,o.mainClock=4,0x50-run.tankFireRank end
        end

        function H.step(o)
            local run = o.run
            if not path.step(o,-run.groundScroll) then return false end
            boxes(o)
            if not visible(o,0x1200,0x9400,0x1400,0x6000) then return false end
            o.extraParts[1].h,o.extraParts[1].l = packed(o.h,o.l,mirror and 0xf8000400 or 0xf800fc00)
            o.extraParts[2].h,o.extraParts[2].l = packed(o.h,o.l,0x08000000)
            if not sharedDamage(o,7,0x380) then
                effects.emitSequence(o,mirror and data.mirroredBlast or data.carrierBlast)
                return false
            end
            if not run.freeze and not run.stopPathClock then
                if o.direction<0x40 then
                    o.trackClock = o.trackClock-1
                    if o.trackClock<0 then
                        o.track,o.trackClock = (o.track+(o.direction==0 and -1 or 1))%4,1
                    end
                end
                wings(o)
                mainGun(o)
            end
            return true
        end

        function H.render(o)
            if not o.run.art then return end
            for i,offset in ipairs(trackOffsets) do
                draft(o,'carrierTreads',o.palette,(i-1)*4+o.track+1,offset+0xfa00fc00,mirror)
            end
            draft(o,'carrier',o.palette,1,0xee00f500,mirror)
            for i,offset in ipairs(doorOffsets) do
                draft(o,'carrierDoors',o.palette,(i-1)*8+o.hatch+1,offset+0xfa00fc00,mirror)
            end
            draft(o,'carrierTurret',o.palette,floor(o.aim/2)+1,turret+0xf800fb00)
        end
        return H
    end

    return air,tank,carriers(false),carriers(true)
end
