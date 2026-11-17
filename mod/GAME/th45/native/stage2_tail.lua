-- 0x16778a 的炮位控制同组 0x167e7e 编队。炮位击破时，子机按编队序号依次退出。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local floor = math.floor
    local s16,addPacked = program.s16,program.addPacked
    local data = program.stage2Tail
    local lead,child,tank = {parts=1},{parts=1},{parts=1}

    local function attach(o,kind)
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(kind.body)
        return path.attach(o,o.row)
    end

    local function visible(o,hOffset,hLimit,lOffset,lLimit)
        local inside = band(o.h+hOffset,0xffff)<hLimit and band(o.l+lOffset+o.run.cameraOffset,0xffff)<lLimit
        if inside then o.seen = true end
        return inside or not o.seen
    end

    local function hit(o)
        local impact = o.impact
        o.flags,o.impact,o.damage = band(o.flags,0xa6ff),nil,0
        return impact
    end

    local function aim(o,pivot,current)
        local h,l = addPacked(0,0,pivot)
        return program.angle(s16(o.h+h),s16(o.l+l),o.run.player,current)
    end

    local function emit(o,kind,modifier,angle,offset,precise)
        local h,l = addPacked(0,0,offset)
        bullets.emit(o,kind,modifier,angle,h,l,precise)
    end

    local function draw(o,id,offset,dh,dl)
        if id==0 then return end
        local h,l = addPacked(o.h,o.l,offset)
        art.draw(o.run.art.sprites[id],h,l,dh,dl)
    end

    function lead.init(o)
        if not attach(o,data.lead) then return false end
        local s,run = data.lead.state,o.run
        o.normal,o.flash = unpack(data.leadPalettes[run.stageNumber])
        o.palette,o.aim = o.normal,aim(o,0,o.direction%64)
        o.shotClock,o.shotGap = s[5]-run.tankFireRank,s[6]
        o.amount,o.amountReset,o.trackClock,o.trackGap = s[7],s[8],s[9],s[10]
        return true
    end

    local function leadAttack(o)
        local run = o.run
        local pivot = data.leadPivot[o.direction%64+1]
        o.trackClock = o.trackClock-1
        if o.trackClock<0 then
            o.trackClock = o.trackGap
            if o.amount==o.amountReset then o.aim = program.towards(o.aim,aim(o,pivot,o.aim)) end
        end
        if o.h<0x1000 then return end
        o.shotClock = o.shotClock-1
        if o.shotClock>=0 then return end
        o.shotClock = 4
        local _,dl = addPacked(0,0,pivot)
        local width,start = unpack(data.leadFireBand[run.stageNumber])
        if band(o.l+dl-start,0xffff)+width>=0x10000 or not run.player or not run.player.active then return end
        local muzzle = pivot+data.leadMuzzle[floor(o.aim/2)+1]
        for _,step in ipairs({0,-12,-24,12,24}) do emit(o,1,0,o.aim*4+step,muzzle,true) end
        o.amount = o.amount-1
        if o.amount<0 then o.amount,o.shotClock = o.amountReset,o.shotGap-run.roadReloadRank end
    end

    function lead.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) or not visible(o,0xe00,0x9600,0x1200,0x5c00) then return false end
        if hit(o) then
            if o.hp<0 then
                run.stageFlags[o.part[0x1e] or 0] = false
                bullets.clear(run,1)
                effects.emit(o,0x85,0,0,0xfc00fe00,true)
                effects.emit(o,0x88,0,0,0x02000400,true)
                return false
            end
            o.palette = bxor(o.palette==25 and o.normal or o.palette,o.flash)
        else
            o.palette = o.hp<0x180 and not run.dual and 25 or o.normal
        end
        if not run.freeze and not run.stopPathClock and not run.blockEnemyFire then leadAttack(o) end
        return true
    end

    function lead.render(o)
        if not o.run.art then return end
        local dir = o.direction%64+1
        local palette = o.palette
        draw(o,data.leadBody[palette][dir],0,unpack(data.lead.draw))
        draw(o,data.leadTurret[palette][floor(o.aim/2)+1],data.leadPivot[dir],-0x600,-0x500)
    end

    function child.init(o)
        if not attach(o,data.child) or not o.run.stageFlags[o.part[0x1e] or 0] then return false end
        local s,run = data.child.state,o.run
        o.normal,o.flash = unpack(data.childPalettes[run.stageNumber])
        o.portNormal,o.portFlash = unpack(data.childPortPalettes[run.stageNumber])
        o.palette,o.portPalette = o.normal,o.portNormal
        local initial = aim(o,0,o.direction%64)
        o.aims,o.index = {initial,initial},o.row.index or 0
        o.shotClock,o.shotGap = s[5]-run.roadChildRank,s[6]
        o.amount,o.amountReset,o.trackClock,o.trackGap = s[7],s[8],s[9],s[10]
        return true
    end

    local function detachTurrets(o,pivots)
        for _,pivot in ipairs(pivots) do effects.emit(o,13,0,0,pivot+0x900,true) end
    end

    local function destroyChild(o,pivots)
        if not o.wreck then
            detachTurrets(o,pivots)
        elseif o.h>=0x2800 and o.run.player and o.run.player.active then
            local player = o.run.player
            local dh,dl = math.abs(o.h-player.h),math.abs(o.l-player.l)
            dh = dh-floor(dh/4)
            if math.max(dh,dl)+floor(math.min(dh,dl)/2)>=0x1c00 then
                for _,pivot in ipairs(pivots) do
                    local h,l = addPacked(0,0,pivot)
                    local angle = program.angle8(s16(o.h+h),s16(o.l+l),player,0x80)
                    emit(o,10,-4,angle,pivot,true)
                    for _,offset in ipairs({0x10,0x20,-0x10,-0x20}) do emit(o,9,-4,angle+offset,pivot,true) end
                end
            end
        end
        effects.emit(o,0x88,0,0,0xfc00fe00,true)
        return false
    end

    local function childAttack(o,pivots)
        local run = o.run
        o.trackClock = o.trackClock-1
        if o.trackClock<0 then
            o.trackClock = o.trackGap
            if o.amount==o.amountReset then
                for i,pivot in ipairs(pivots) do o.aims[i] = program.towards(o.aims[i],aim(o,pivot,o.aims[i])) end
            end
        end
        if o.h<0x2800 then return end
        o.shotClock = o.shotClock-1
        if o.shotClock>=0 then return end
        o.shotClock = 6
        for i,dir in ipairs(o.aims) do
            local h,l = addPacked(o.h,o.l,data.childMuzzle[floor(dir/2)+1])
            local dh,dl = addPacked(0,0,pivots[i]+0x02000000)
            bullets.emit(o,4,-2,dir*4,s16(h+dh-o.h),s16(l+dl-o.l))
        end
        o.amount = o.amount-1
        if o.amount<0 then o.amount,o.shotClock = o.amountReset,o.shotGap+4-run.roadReloadRank end
    end

    function child.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) or not visible(o,0xc00,0x9400,0x1200,0x5c00) then return false end
        local pivots = data.childPivots[o.direction%64+1]
        if o.releaseClock then
            o.releaseClock = o.releaseClock-1
            if o.releaseClock==0 then return destroyChild(o,pivots) end
            return true
        end
        if not run.stageFlags[o.part[0x1e] or 0] then
            o.flags,o.releaseClock = bor(0x8000,band(o.flags,0xff)),4*(o.index+1)
            o.palette,o.portPalette = o.normal,o.portNormal
            return true
        end
        if hit(o) then
            if o.hp<0 and not o.wreck then
                detachTurrets(o,pivots)
                o.flags,o.hp,o.wreck = 0x8080,0x800,true
                o.wreckFrames = {program.random(run,data.wreckRandom,63)+1,program.random(run,data.wreckRandom,63)+1}
                return true
            end
            o.palette = bxor(o.palette==25 and o.normal or o.palette,o.flash)
            o.portPalette = bxor(o.portPalette==25 and o.portNormal or o.portPalette,o.portFlash)
        else
            o.palette = o.normal
            o.portPalette = o.hp<0x200 and not run.dual and 25 or o.portNormal
        end
        if not o.wreck and not run.freeze and not run.stopPathClock and not run.blockEnemyFire then childAttack(o,pivots) end
        return true
    end

    function child.render(o)
        if not o.run.art then return end
        local dir = o.direction%64+1
        draw(o,data.childBody[o.palette][dir],0,unpack(data.child.draw))
        for i,pivot in ipairs(data.childPivots[dir]) do
            if o.wreck then
                draw(o,data.wreck[o.wreckFrames[i]],pivot,-0x200,-0x200)
            else
                draw(o,data.childTurret[o.portPalette][floor(o.aims[i]/2)+1],pivot,-0x400,-0x400)
            end
        end
    end

    function tank.init(o)
        local run = o.run
        local stage = run.stageNumber
        if run.stageFlags[0] and (stage<=4 and (stage~=2 or run.major>=0xce)
            or stage==5 and run.major>=0x10f and run.major<=0x11a) then return false end
        if not attach(o,data.tank) then return false end
        local s = data.tank.state
        o.palette,o.aim,o.home = s[21],aim(o,0,0x20),band(o.direction+0x20,0x3c)
        o.shotClock,o.shotGap,o.brakeShots = s[3]-run.roadTankStartRank+8,s[4],s[18]
        o.speedClock,o.speedGap,o.repeatClock,o.repeatGap = s[15],s[16],s[19],s[20]
        o.tread,o.treadClock = 0,0
        return true
    end

    local function tankFire(o,target)
        local run = o.run
        if not program.fireBand(o) or not run.player or not run.player.active or run.blockEnemyFire then return end
        emit(o,0,0,target*4,data.tankMuzzle[floor(o.aim/2)+1])
    end

    local function tickSpeed(o,limit,increment)
        if o.speed==limit then return false end
        o.speedClock = o.speedClock-1
        if o.speedClock>=0 then return false end
        o.speedClock,o.speed = o.speedGap,o.speed+increment
        return o.speed==limit
    end

    local function brake(o)
        local target = aim(o,0,o.aim)
        o.repeatClock = o.repeatClock-1
        if o.repeatClock==0 then
            o.repeatClock = o.repeatGap
            tankFire(o,target)
        end
        if tickSpeed(o,0,-1) then
            o.braked,o.speedClock,o.speedGap,o.shotClock,o.turnClock = true,0,2,1,0x30
            o.direction = band(o.aim,0x3c)
            o.turnStep = o.direction==o.home and 0 or o.direction>o.home and 4 or -4
            o.turned = false
        end
        if not o.run.tankAimLocked then o.aim = program.towards(o.aim,target) end
    end

    local function accelerate(o)
        if (o.part[0x1e] or 0)==0 and o.brakeShots>0 then
            o.shotClock = o.shotClock-1
            if o.shotClock==0 then
                o.shotClock,o.brakeShots = o.shotGap,o.brakeShots-1
                tankFire(o,o.aim)
            end
            return
        end
        tickSpeed(o,0x1c,1)
        if o.turned then return end
        o.turnClock = o.turnClock-1
        if o.turnClock<0 then
            o.turnClock = data.tank.state[6]
            o.direction = band(o.direction+o.turnStep,0x3c)
            o.turned = o.direction==o.home
        end
    end

    function tank.step(o)
        local run = o.run
        if hit(o) then
            if o.hp<0 then effects.emit(o,2,band(o.speed+8,255),o.direction*4,0,true); return false end
            o.palette = bxor(o.palette,data.tank.state[22])
        else
            o.palette = data.tank.state[21]
        end
        if not visible(o,0x600,0x7c00,0xe00,0x5400) then return false end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.direction*4,run.slowVectors)
            o.h,o.l = s16(o.h+dh),s16(o.l+dl)
            if not run.stopPathClock then
                if o.braked then accelerate(o) else brake(o) end
            end
        end
        o.drawTread = o.tread
        if not run.stopPathClock then
            o.treadClock = o.treadClock-1
            if o.treadClock<0 then o.treadClock,o.tread = 1,(o.tread+1)%4 end
        end
        return true
    end

    function tank.render(o)
        if not o.run.art then return end
        local dir = floor((o.braked and o.direction or o.aim)/2)
        if o.drawTread then
            draw(o,program.tankImages[o.palette][dir*4+o.drawTread+1],0,unpack(data.tank.draw))
        end
    end

    return lead,child,tank
end
