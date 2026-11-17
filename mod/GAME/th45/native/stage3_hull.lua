-- 0x160a9e 跟随舰体脚本推进，路径字节还决定这座炮座是否启用两组火力。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local s16,addPacked = program.s16,program.addPacked
    local data = program.stage3Hull
    local H = {parts=2}
    local narrow,wide = {0,4,8,28,32,-4,-8,-28,-32},{0,12,24,36,48,-12,-24,-36,-48}

    function H.init(o)
        o.second = {}
        o.extraParts = {o.second}
        for i,p in ipairs({o,o.second}) do
            p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(data.boxes[i])
        end
        o.speed = 0
        if not path.attach(o,o.row) then return false end
        o.h = s16(o.h+0x1b80)
        o.second.h,o.second.l = o.h,o.l
        o.armed = (o.part[0x1e] or 0)~=0
        o.health,o.palette,o.animation = o.armed and 0x3800 or 0x1000,22,0
        o.radialClock,o.radialGap,o.radialCount = 0x20-o.run.volleyRank,0,0
        o.aimClock,o.aimGap,o.aimCount = 0x24-o.run.volleyRank,0,0
        o.angle,o.phase = 0,1
        return true
    end

    local function animate(o)
        o.animation = (o.animation+1)%8
    end

    local function death(o)
        if o.run.freeze then return true end
        if o.deathClock%4==0 and o.smokeCount>0 then
            local run = o.run
            local kind = program.gunshipSmoke[band(program.random(run,program.randomByte),7)+1]
            program.random(run,program.randomHalf,127)
            local angle = program.random(run,program.randomHalf,127)
            local h = s16(program.gunshipSmokeH[program.nextRandom(run,63)])
            local l = s16(program.gunshipSmokeH[program.nextRandom(run,63)])
            effects.emit(o,kind,2,angle,(h+floor(h/2)+0x800)*0x10000+band(l,0xffff),false,0,0x18)
            program.nextRandom(run,63)
            program.nextRandom(run,63)
            o.smokeCount = o.smokeCount-1
            if o.smokeCount==0 then o.finalClock=o.deathClock+35 end
        end
        if o.deathClock%4==0 then animate(o) end
        if o.deathClock==o.finalClock then
            effects.emitSequence(o,data.blasts[o.armed and 2 or 1])
            return false
        end
        o.deathClock = o.deathClock+1
        return true
    end

    local function damage(o)
        local p = o.second
        if not o.impact and not p.impact then
            o.palette = o.health<0x2aa and 25 or 22
            return
        end
        local damage = (o.damage or 0)+(p.damage or 0)
        if not o.armed or o.h<0x6e00 then o.health = o.health-band(damage,0xffff) end
        o.damage,p.damage,o.impact,p.impact,o.hp,p.hp = 0,0,nil,nil,0x7fff,0x7fff
        o.palette = bxor(o.palette==25 and 22 or o.palette,9)
        if o.health<0 then
            o.flags,p.flags,o.palette = 0x8000,0x8000,22
            o.deathClock,o.smokeCount = 0,o.armed and 20 or 4
        end
    end

    local function tick(o,field,period)
        o[field] = o[field]-1
        if o[field]>=0 then return false end
        o[field] = period
        return true
    end

    local function fire(o)
        local run = o.run
        if not o.armed then return end
        o.angle = band(o.angle+1,255)
        local p = run.player
        if o.phase==1 then
            if o.h<0x3800 then o.phase=2
            elseif o.radialCount>0 or tick(o,'radialClock',0x48-run.sweepFireRank) then
                if o.radialCount==0 then o.radialCount=0x18 end
                if tick(o,'radialGap',1) then
                    if not run.blockEnemyFire and p and p.active then
                        for side=0,1 do
                            local dh,dl = program.vector(0x80,o.angle+side*0x80)
                            dh,dl = s16(dh*2-0x1400),s16(dl*4)
                            local aim = program.angle(s16(o.h+dh),s16(o.l+dl),p,0x20)
                            bullets.emit(o,11,5,aim*4,dh,dl)
                        end
                    end
                    o.angle,o.radialCount = o.angle+0x10,o.radialCount-1
                    if o.radialCount==0 then o.phase=2 end
                end
            end
        end
        if o.phase~=2 then return end
        if o.h<0x3800 then o.phase,o.aimCount = 1,0; return end
        if o.aimCount==0 then
            if not tick(o,'aimClock',0x30-run.sweepFireRank) then return end
            o.aimCount = 3
        end
        if not tick(o,'aimGap',6) then return end
        if not run.blockEnemyFire and p and p.active then
            local aim = program.angle8(s16(o.h-0x1e00),o.l,p,0x80)
            for _,d in ipairs(narrow) do bullets.emit(o,2,-5,aim+d,-0x1e00,0,true) end
            for _,d in ipairs(wide) do bullets.emit(o,2,4,aim+d,-0x1e00,0,true) end
        end
        o.aimCount = o.aimCount-1
        if o.aimCount==0 then o.phase=1 end
    end

    function H.step(o)
        local run = o.run
        o.second.h,o.second.l = o.h,o.l
        if o.deathClock then return death(o) end
        damage(o)
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.l+0x2000+run.cameraOffset,0xffff)<0x7800 and band(o.h+0x1800,0xffff)<0xb400 then
            o.seen = true
        elseif o.seen then return false end
        if not run.freeze and not run.stopPathClock and not o.deathClock then
            fire(o)
            animate(o)
        end
        o.visible = true
        return true
    end

    function H.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        for _,row in ipairs(data.images[o.palette]) do
            local h,l = addPacked(o.h,o.l,row[1])
            local frame = #row==3 and 3 or o.animation+3
            if h<0x7000 and l>-0xa00 and l<0x3800 then
                art.draw(assets.sprites[row[frame]],h,l,0,0,row[2]==1)
            end
        end
    end

    return H
end
