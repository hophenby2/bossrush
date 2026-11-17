-- 0x1b8026 的三个机身判定共用耐久。事件换挂移动和攻击，零件各用自己的动画时钟。
return function(program,bullets,effects,art)
    local directory = 'mod/GAME/th45/native/'
    local tasks = dofile('mod/GAME/th44/native/boss_tasks.lua')
    local attacks = dofile(directory..'mid4_attacks.lua')(program,bullets,tasks)
    local aux,events,motion = dofile(directory..'mid4_tasks.lua')(program,effects,tasks)
    local band,bor,bxor = require('bit').band,require('bit').bor,require('bit').bxor
    local s16,packed = program.s16,program.addPacked
    local floor = math.floor
    local data = program.mid4
    local H = {parts=12}

    function H.init(o)
        o.extraParts = {}
        for i,row in ipairs(data.parts) do
            local p = i==1 and o or {}
            p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(row)
            p.h,p.l = 0,0
            if i>1 then o.extraParts[i-1] = p end
        end
        o.hit = {o.extraParts[6],o.extraParts[7],o.extraParts[8]}
        o.health,o.palette,o.protected = data.health,20,true
        o.wingHatch,o.coreHatch,o.tail,o.engine = 0,0,0,0
        o.pod,o.cannonAim,o.drawParts = {0,0},{0x20,0x20},{}
        o.tune = {}
        for index=0,5 do o.tune[index] = {period=0,waves=0,length=0,speed=0} end
        o.aux = {limit=25,unique=true,handlers=aux,label='四面中 Boss 部件'}
        o.events = {limit=5,handlers=events,label='四面中 Boss 事件'}
        o.attacks = {limit=20,handlers=attacks,label='四面中 Boss 攻击'}
        local run = o.run
        run.midBoss,run.stageFlags[0],run.bulletCapacity = o,true,150
        tasks.attach(o.events,0)
        return true
    end

    local function damage(o)
        if o.defeated or o.retreating then return end
        local hit,total = false,0
        for _,part in ipairs(o.hit) do
            if part.impact then
                hit,total = true,total+(part.damage or 0)
                part.impact,part.damage,part.hp = nil,0,0x7fff
            end
        end
        if hit then
            o.palette = bxor(o.palette==25 and 20 or o.palette,0xb)
            if not o.protected then o.health = o.health-band(total,0xffff) end
        else
            o.palette = o.health<0xba00 and not o.run.freeze and 25 or 20
        end
        if o.health<0 and not o.protected then
            o.health,o.defeated,o.protected,o.palette = -1,true,true,20
            o.run.stageFlags[7] = true
            for _,part in ipairs(o.hit) do part.flags = 0x8000 end
            tasks.clear(o.attacks)
            tasks.clear(o.events)
            tasks.clear(o.aux)
            tasks.attach(o.events,3)
            bullets.clear(o.run,0xb0)
            o.nextMotion = 6
        elseif o.health<0x11200 and not o.phaseTwo then
            o.phaseTwo,o.protected = true,true
            tasks.clear(o.attacks)
            tasks.clear(o.events)
            tasks.stop(o.aux,0)
            tasks.attach(o.aux,1)
            tasks.attach(o.events,11)
            bullets.clear(o.run,0x20)
        end
    end

    function H.step(o)
        local run = o.run
        if o.finished then
            run.midBoss,run.stageFlags[0],run.stageFlags[2],run.stageFlags[7] = nil,false,false,false
            return false
        end
        damage(o)
        if not (run.freeze or run.stopPathClock) then
            if run.major>=0x198 and not o.retreatQueued and not o.defeated then
                o.retreatQueued = true
                tasks.attach(o.events,9)
            end
            tasks.tick(o,o.aux)
            tasks.tick(o,o.events)
        end
        if o.nextMotion then
            if not o.move or o.move.index~=o.nextMotion then
                o.move = {index=o.nextMotion}
                motion[o.move.index][1](o,o.move)
            else
                motion[o.move.index][2](o,o.move)
            end
            o.nextMotion = nil
        elseif o.move then
            motion[o.move.index][2](o,o.move)
        end
        for side=1,2 do
            local part = o.extraParts[side]
            part.h,part.l = packed(o.h,o.l,side==1 and 0xfe001000 or 0xfe00f000)
        end
        for _,part in ipairs(o.hit) do part.h,part.l = o.h,o.l end
        if not run.freeze then tasks.tick(o,o.attacks) end
        return true
    end

    function H.render(o)
        local assets = o.run.art
        if not assets then return end
        local images = data.images[o.palette]
        local function draw(id,offset)
            local h,l = packed(o.h,o.l,offset)
            art.draw(assets.sprites[id],h,l,0,0)
        end
        local mask = o.drawParts
        if mask[0] then
            draw(images.engine[o.engine+1],0x1000f700)
            draw(images.body,0xf000fa00)
            draw(images.coreHatch[o.coreHatch+1],0xf800fa00)
            draw(images.core,data.coreOffsets[o.coreHatch+1]+0xfe00fe00)
        end
        if mask[1] then
            draw(images.rightWingBase,0x0a000600)
            draw(images.rightWing[o.wingHatch+1],0xf2000600)
        end
        if mask[2] then
            draw(images.leftWingBase,0x0e00f700+0xfc00fd00)
            draw(images.leftWing[o.wingHatch+1],0xfe00f000+0xf400f600)
        end
        if mask[3] then draw(images.rightTail[o.tail+1],0x10000900) end
        if mask[4] then draw(images.leftTail[o.tail+1],0x1c00ed00+0xf400f600) end
        if mask[5] then
            draw(images.pod,data.podOffsets[o.pod[1]+1]*0x10000+0x01000140)
            draw(images.pod,data.podOffsets[o.pod[2]+1]*0x10000+0x0f00fbc0+0xf200fd00)
        end
        if mask[6] then
            draw(images.cannon[floor(o.cannonAim[1]/2)+1],0xfe000400)
            draw(images.cannon[floor(o.cannonAim[2]/2)+1],0x0400f700+0xfa00fb00)
        end
    end

    return H
end
