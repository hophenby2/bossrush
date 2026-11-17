-- 0x1b56c0 的三个实体判定共用耐久。0x1b6a88 的击破分支可以在本帧换挂任务。
return function(program,bullets,effects,art)
    local directory = 'mod/GAME/th45/native/'
    local tasks = dofile('mod/GAME/th44/native/boss_tasks.lua')
    local aux,events,motion,attacks = dofile(directory..'mid3_tasks.lua')(program,bullets,effects,tasks)
    local band,bxor = require('bit').band,require('bit').bxor
    local s16,addPacked = program.s16,program.addPacked
    local floor = math.floor
    local data = program.mid3
    local H = {parts=8}

    function H.init(o)
        o.extraParts = {}
        for i,row in ipairs(data.parts) do
            local p = i==1 and o or {}
            p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(row)
            p.h,p.l = 0,0
            if i>1 then o.extraParts[i-1] = p end
        end
        o.hit = {o.extraParts[4],o.extraParts[5],o.extraParts[6]}
        o.health,o.aim = data.health,0x20
        o.bodyPalette,o.treadPalette = 19,20
        o.door,o.wreck,o.tread,o.kick,o.broken = 0,0,0,0,{}
        o.aux = {limit=25,unique=true,handlers=aux,label='三面中 Boss 短任务'}
        o.events = {limit=5,handlers=events,label='三面中 Boss 事件'}
        o.attacks = {limit=20,handlers=attacks,label='三面中 Boss 攻击'}
        local run = o.run
        run.midBoss,run.stageFlags[0],run.stageFlags[1],run.bulletCapacity = o,true,true,150
        tasks.attach(o.events,0)
        return true
    end

    local function defeat(o)
        o.health,o.defeated,o.protected = -1,true,true
        o.bodyPalette,o.treadPalette = 19,20
        o.run.stageFlags[1] = false
        for _,p in ipairs(o.hit) do p.flags = 0x8000 end
        bullets.clear(o.run,0xb0)
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        tasks.clear(o.aux)
        tasks.attach(o.events,1)
        o.nextMotion = 6
    end

    local function damage(o)
        local struck,total = false,0
        for _,p in ipairs(o.hit) do
            if p.impact then
                struck,total = true,total+(p.damage or 0)
                p.impact,p.damage,p.hp = nil,0,0x7fff
            end
        end
        if struck then
            if o.bodyPalette==25 then o.bodyPalette,o.treadPalette = 19,20 end
            o.bodyPalette,o.treadPalette = bxor(o.bodyPalette,0xc),bxor(o.treadPalette,0xb)
            if not o.protected then o.health = o.health-band(total,0xffff) end
        elseif not o.defeated then
            o.bodyPalette,o.treadPalette = 19,20
            if o.health<0x5d00 then o.bodyPalette,o.treadPalette = 25,25 end
        end
        if o.health<0 and o.phaseTwo and not o.protected and not o.defeated then
            defeat(o)
        elseif o.health<0x7600 and not o.protected and not o.phaseTwo then
            o.phaseTwo,o.protected = true,true
            o.run.stageFlags[1] = false
            o.lockAim = false
            o.hit[1].right,o.hit[1].left = 0xc00,0xc00
            o.hit[3].right,o.hit[3].left = 0x800,0x800
            tasks.clear(o.attacks)
            tasks.clear(o.events)
            tasks.stop(o.aux,0)
            tasks.stop(o.aux,1)
            tasks.attach(o.events,6)
            bullets.clear(o.run,0x40)
        end
    end

    function H.step(o)
        local run = o.run
        if o.finished then
            run.midBoss = nil
            return false
        end
        damage(o)
        if o.kick>0 then
            local dh,dl = program.vector(o.kick,o.kickAngle,run.slowVectors)
            o.h,o.l,o.kick = s16(o.h+dh),s16(o.l+dl),o.kick-1
        end
        if not run.freeze then
            if not run.stopPathClock then tasks.tick(o,o.aux); tasks.tick(o,o.events) end
            if o.nextMotion then
                o.move,o.nextMotion = {index=o.nextMotion},nil
                motion[o.move.index][1](o,o.move)
            elseif o.move then motion[o.move.index][2](o,o.move) end
            tasks.tick(o,o.attacks)
        elseif o.move and o.move.index==0 then motion[0][2](o,o.move) end
        for _,p in ipairs(o.hit) do p.h,p.l = o.h,o.l end
        if run.major>=0x171 and not o.retreatQueued and not o.defeated
            and not run.freeze and not run.stopPathClock then
            o.retreatQueued = true
            tasks.attach(o.events,8)
        end
        return true
    end

    function H.render(o)
        local assets = o.run.art
        if not assets or o.hidden then return end
        local function draw(image,offset,flip)
            local h,l = addPacked(o.h,o.l,offset)
            art.draw(assets.sprites[image],h,l,0,0,flip)
        end
        if o.drawRamp then
            local row = data.ramps[o.ramp+1]
            if row then draw(row[1],row[2]) end
        end
        if not o.drawBody then return end
        local track = data.treads[o.treadPalette][o.tread+1]
        draw(track,0xfe01ea00)
        draw(track,0xfe010200,true)
        local bank = data.banks[o.bodyPalette]
        for _,row in ipairs(bank.body) do draw(row[1],row[2]) end
        if o.drawDoors then
            for side,frames in ipairs(bank.doors) do
                if o.broken[side] then
                    draw(bank.wreck[side][o.wreck+1],side==1 and 0xe2000200 or 0xe380ea00)
                else
                    local row = frames[o.door+1]
                    draw(row[1],row[2])
                end
            end
        end
        if o.drawTurret then draw(bank.turret[floor(o.aim/2)+1],0xfa00fb00) end
    end

    return H
end
