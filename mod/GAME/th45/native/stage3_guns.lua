-- 0x1618bc 和 0x16137a 在每轮首发锁定方向，小艇 0x1559d6 则逐轮反转扫射。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local s16,addPacked = program.s16,program.addPacked
    local data = program.stage3Guns

    local function fire(o,kind,speed,angle,offset,precise)
        bullets.emit(o,kind,speed,angle,s16(floor(offset/0x10000)),s16(offset),precise)
    end

    local function common(o,variant)
        local run = o.run
        if o.impact then
            o.impact = nil
            o.palette = bxor(o.palette==25 and variant.palette or o.palette,variant.flash)
            if o.hp<0 then
                effects.emitSequence(o,variant.blast)
                return false
            end
        else o.palette = o.hp<variant.warning and 25 or variant.palette end
        if not path.step(o,-run.groundScroll) then return false end
        local bound = variant.bounds
        if band(o.l+bound[1]+run.cameraOffset,0xffff)<bound[2] and band(o.h+bound[3],0xffff)<bound[4] then
            o.seen = true
        elseif o.seen then return false end
        o.visible = true
        return true
    end

    local function turret(index)
        local variant = data.variants[index]
        local dual = index==1
        local H = {parts=1}
        function H.init(o)
            local run = o.run
            o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(variant.box)
            o.palette,o.aim,o.count,o.gap = variant.palette,0x20,0,0
            o.clock = (dual and 0x18 or 0x20)-run.volleyRank
            if dual and run.stageNumber==3 and run.major>=0x2e5 then o.hp=0xc00 end
            return path.attach(o,o.row)
        end
        function H.step(o)
            if not common(o,variant) then return false end
            local run = o.run
            if run.freeze or run.stopPathClock then return true end
            if o.count==0 then o.aim = program.towards(o.aim,program.angle(o.h,o.l,run.player,o.aim)) end
            if o.h<0x2c00 then o.count=0; return true end
            if dual and run.blockEnemyFire then return true end
            if o.count==0 then
                o.clock = o.clock-1
                if o.clock>=0 then return true end
                o.clock = dual and 0x30-run.sweepFireRank or 0x1c-run.volleyRank
                o.count = dual and 5 or 4
            end
            o.gap = o.gap-1
            if o.gap<0 then
                o.gap,o.count = dual and 6 or 5,o.count-1
                local muzzle = program.mid2.muzzle0[o.aim+1]
                for _,ports in ipairs(variant.guns) do
                    fire(o,14,dual and 3 or 2,o.aim*4,ports[floor(o.aim/2)+1]+muzzle)
                end
            end
            return true
        end
        function H.render(o)
            if not o.run.art or not o.visible then return end
            local row = variant.images[o.palette][floor(o.aim/2)+1]
            local h,l = addPacked(o.h,o.l,row[2])
            art.draw(o.run.art.sprites[row[1]],h,l,0,0,row[3]==1)
        end
        return H
    end

    local craft = {parts=1}
    local variant = data.variants[3]
    function craft.init(o)
        local run = o.run
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(variant.box)
        if not path.attach(o,o.row) then return false end
        o.palette,o.clock,o.aim,o.count,o.gap = variant.palette,0x40-run.tankFireRank,0x20,0,0
        local flip = program.random(run,program.randomByte)>=0x80 and -1 or 1
        o.stepAngle,o.bias = 2*flip,-0x14*flip
        o.animation = program.random(run,program.mid2.patternRandom,127)
        return true
    end

    function craft.step(o)
        if not common(o,variant) then return false end
        local run = o.run
        if run.freeze or run.stopPathClock then return true end
        if o.count==0 and not run.blockEnemyFire and o.h>=0x2c00 then
            o.clock = o.clock-1
            if o.clock<0 then
                o.clock,o.count = 0x50-run.tankStartRank,20
                o.aim = band(program.angle(o.h,o.l,run.player,o.aim)+o.bias,63)
            end
        end
        if o.count>0 then
            o.gap = o.gap-1
            if o.gap<0 then
                o.gap,o.count = 8,o.count-1
                if o.h>=0x2c00 and not run.blockEnemyFire then
                    local a = o.aim*4
                    fire(o,6,-1,a,0xff000400)
                    fire(o,6,-1,a+0x10,0xff000400)
                    fire(o,6,-1,a,0xfefffc00)
                    fire(o,6,-1,a-0x10,0xfefffc00)
                    o.aim = band(o.aim+o.stepAngle,63)
                end
                if o.count==0 then o.stepAngle,o.bias = -o.stepAngle,-o.bias end
            end
        end
        if (o.speed or 0)>0 and o.direction<0x40 then
            o.animation = (o.animation+(o.direction==0 and 1 or -1))%3
        end
        return true
    end

    function craft.render(o)
        if not o.run.art or not o.visible then return end
        local image = variant.images[o.palette][o.animation+1]
        art.draw(o.run.art.sprites[image],o.h,o.l,-0xa00,-0x600)
    end

    local broad = {parts=1}
    local broadData = data.variants[4]
    function broad.init(o)
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(broadData.box)
        o.palette,o.aim,o.phase,o.count,o.gap = broadData.palette,0x20,1,0,0
        o.clock,o.secondClock = 0x14-o.run.volleyRank,0x14-o.run.volleyRank
        return path.attach(o,o.row)
    end

    function broad.step(o)
        if not common(o,broadData) then return false end
        local run = o.run
        if run.freeze or run.stopPathClock then return true end
        if o.count==0 then o.aim = program.towards(o.aim,program.angle(o.h,o.l,run.player,o.aim)) end
        if o.h<0x2c00 then o.phase,o.count = 1,0; return true end
        if o.count==0 then
            local clock = o.phase==1 and 'clock' or 'secondClock'
            o[clock] = o[clock]-1
            if o[clock]>=0 then return true end
            if o.phase==1 then
                o.clock,o.count = 0x90-(run.broadGunRank or 0),3
            else
                o.secondClock,o.count,o.gap = 0x14-run.volleyRank,5,0
            end
        end
        o.gap = o.gap-1
        if o.gap>=0 then return true end
        local a = o.aim
        if o.phase==1 then
            for side=1,2 do
                local d = side==1 and 4 or -4
                for ray=0,2 do fire(o,2,0,(a+ray*d)*4,broadData.guns[side+1][a+1]) end
            end
            o.gap = 4
        else
            for _,d in ipairs({0,2,4,-2,-4}) do
                local angle = band(a+d,63)
                fire(o,11,1,angle*4,broadData.guns[1][a+1]+program.mid2.muzzle1[angle+1])
            end
            o.gap = 6
        end
        o.count = o.count-1
        if o.count==0 then o.phase,o.gap = 3-o.phase,4 end
        return true
    end

    function broad.render(o)
        if not o.run.art or not o.visible then return end
        local row = broadData.images[o.palette][o.aim+1]
        local h,l = addPacked(o.h,o.l,row[2])
        art.draw(o.run.art.sprites[row[1]],h,l,0,0,row[3]==1)
    end

    return turret(1),turret(2),craft,broad
end
