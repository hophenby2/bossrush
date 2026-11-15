-- 0xe1c24 的飞行甲板把炮口时钟、五块受击盒和坠毁倒计时放在同一个敌机槽内。
return function(program, path, bullets, effects, remove, score)
    local bit = require('bit')
    local band,bor = bit.band,bit.bor
    local s16,word,pack,unpackPosition = program.s16,program.word,program.pack,program.unpack
    local data = program.deckCarrier
    local M = {}

    local function tick(s,index)
        local clock = s[index]
        s[index] = (clock-1)%256
        return clock == 0
    end

    local function place(o)
        for _,part in ipairs(o.attachments) do
            part.h,part.l,part.x,part.y = o.h,o.l,program.world(o.h,o.l)
        end
    end

    function M.init(o)
        local run,s = o.run,o.state
        local fifth = run.stageNumber == 5
        o.colorFrame,o.cover,o.rotor,o.hpBoxes = 1,0,1,{o,unpack(o.attachments)}
        o.guns = {}
        o.durability,o.armor = fifth and 0x7600 or word(s,0x20),fifth and 0xa0 or word(s,0x36)
        if fifth then run.capacity = 120 else run.patrol42Block = true end
        for _,part in ipairs(o.hpBoxes) do
            part.front,part.back = s16(part.front),s16(part.back)+(fifth and 0x600 or 0)
            part.right,part.left = s16(part.right),s16(part.left)
            part.a,part.b = (part.right+part.left)/128,(part.back+part.front)/128
        end
        local extend = (fifth and 4 or 0)+(o.part[0x1f] ~= 0 and 3 or 0)
        for i,source in ipairs(data.mounts) do
            o.guns[i] = {unpack(source)}
            o.guns[i][8] = source[8]+extend
        end
        place(o)
    end

    local function retire(o)
        o.run.patrol42Block = nil
        remove(o)
    end

    local function damage(o)
        local run = o.run
        local flags,loss = 0,0
        for _,part in ipairs(o.hpBoxes) do
            flags = bor(flags,part.flags)
            loss = math.max(loss,band(0x7fff-part.hp,0xffff))
            part.hp,part.flags = 0x7fff,band(part.flags,0xa7ff)
        end
        if band(flags,0x5800) == 0 then
            o.colorFrame = o.durability < 0x2200 and band(run.frame,0x0e)==0 and 3 or 1
            return
        end
        o.durability = o.durability-(o.armor==0 and loss or 0)
        o.colorFrame = o.colorFrame == 2 and 1 or 2
        local hit = score.source(o,o.attachments)
        if o.durability <= 0x2200 and not o.weakened then
            score.kill(hit,0x186,nil,nil,o)
            o.weakened = true
            for i,gun in ipairs(o.guns) do
                local h,l = program.add(o.h,o.l,gun[5],gun[6])
                effects.spawn(run,h,l,i%2==1 and data.innerBreak or data.outerBreak,false,true)
            end
            if run.onBreakPart then run.onBreakPart(o) end
        end
        if o.durability < 0 then
            score.kill(hit,0x23a,nil,nil,o)
            for _,part in ipairs(o.hpBoxes) do part.flags = 0x8000 end
            o.crash,o.colorFrame = o.state[0x26],1
            effects.spawn(run,o.h,o.l,data.death,false,true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
        end
    end

    local function emit(o, offsets, angle, kind, speed)
        local muzzle = data.portMuzzle[band(angle,0x3f)+1]
        local h,l = program.add(muzzle[1],muzzle[2],offsets[1],offsets[2])
        bullets.emitFasterInLoop(o.run,kind,speed,angle*4,s16(o.h+h),s16(o.l+l))
    end

    local ports = {{-321,-832},{-320,832}}
    local function hatch(o)
        local s,fifth = o.state,o.run.stageNumber==5
        if s[0x27]==0 and tick(s,0x2a) then s[0x2a],s[0x2e],s[0x34],s[0x27]=s[0x2b],s[0x2f],0,1 end
        if s[0x27]==1 then
            o.cover=math.min(0x280,o.cover+0xe)
            if o.cover==0x280 then s[0x27]=2 end
        end
        if s[0x27]==2 then
            if s[0x32]==0 and tick(s,0x2c) then s[0x2c],s[0x32]=s[0x2d],s[0x33] end
            if s[0x32]~=0 and tick(s,0x30) then
                s[0x30],s[0x32]=s[0x31],s[0x32]-1
                for i,port in ipairs(ports) do
                    local sign = i==1 and 1 or -1
                    for ray=0,fifth and 4 or 2 do
                        emit(o,port,0x20+sign*(s[0x34]+ray*(fifth and 2 or 4)),0xc,0)
                    end
                end
                if s[0x32]==0 then
                    s[0x34],s[0x2e]=s[0x34]+2,s[0x2e]-1
                    if s[0x2e]==0 then s[0x27]=3 end
                end
            end
        end
        if s[0x27]==3 then
            o.cover=math.max(0,o.cover-0xe)
            if o.cover==0 then
                s[0x27]=0
                if o.weakened then
                    s[0x2b]=0x10
                    if s[0x2a]>0x10 and s[0x2a]<0x80 then s[0x2a]=0x10 end
                end
            end
        end
    end

    local function guns(o)
        local run = o.run
        if not run.pilotH then return end
        for _,gun in ipairs(o.guns) do
            local target = program.angle(s16(o.h+gun[5]),s16(o.l+gun[6]),run.pilotH,run.pilotL,gun[3])
            gun[3]=program.turnToward(gun[3],target)
            if gun[9]==0 and tick(gun,1) then gun[1],gun[9]=gun[2],gun[10] end
            if gun[9]~=0 and tick(gun,7) then
                gun[7],gun[9]=gun[8],gun[9]-1
                local muzzle = data.gunMuzzle[band(gun[3],0x3e)/2+1]
                local dh,dl = program.add(muzzle[1],muzzle[2],gun[5],gun[6])
                local h,l,angle = s16(o.h+dh),s16(o.l+dl),gun[3]*4
                if run.stageNumber==5 then
                    local spread=8+4*run.route.loop
                    bullets.emitFasterInLoop(run,3,11,angle,h,l)
                    bullets.emitFasterInLoop(run,2,8,angle-spread,h,l)
                    bullets.emitFasterInLoop(run,2,8,angle+spread,h,l)
                else
                    bullets.emitFasterInLoop(run,2,4,angle,h,l)
                end
            end
        end
    end

    local function damagedFan(o)
        local run,s = o.run,o.state
        if not tick(s,0x1a) then return end
        s[0x1a]=s[0x1b]
        if not run.pilotH then return end
        local shifted = o.part[0x1f] ~= 0
        local wide = not shifted and run.stageNumber==5
        local spacing,rays = shifted and 12 or wide and 10 or 16,shifted and 9 or wide and 13 or 7
        local angle = program.aimByte(s16(o.h-0x600),o.l,run.pilotH,run.pilotL,0x80,true)-(wide and 0x3c or 0x30)
        for i=rays-1,0,-1 do
            local p = data.fanMuzzle[band(angle+2,0xfc)/4+1]
            if i%2==0 then
                bullets.emitSpeedPair(run,8,4,angle,o.h,o.l,p[1]-0x600,p[2])
            else
                bullets.emitAngle(run,8,4,angle,o.h,o.l,p[1]-0x600,p[2])
            end
            angle=angle+spacing
        end
    end

    function M.step(o)
        local run = o.run
        if o.crash then
            if run.frame%4==0 then program.random(run,program.randomParity) end
            o.h,o.crash = s16(o.h-0x40),o.crash-1
            if o.crash==0 then effects.spawn(run,o.h,o.l,data.wreck,true,true); retire(o) end
            return
        end
        damage(o)
        o.armor=math.max(0,o.armor-1)
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        place(o)
        local inside=band(o.h+0x1000,0xffff)<0x8400 and band(o.l+0x1e00+run.cameraOffset,0xffff)<0x7400
        if o.entered and not inside then retire(o); return end
        o.entered=o.entered or inside
        hatch(o)
        if o.weakened then damagedFan(o) else guns(o) end
        o.rotor=o.rotor%4+1
    end

    function M.render(o, draw)
        local art,color,fifth=data.art[o.run.stageNumber],o.colorFrame,o.run.stageNumber==5
        local pos=pack(o.h,o.l)
        local function sprite(id,offset,dh)
            local h,l=unpackPosition(pos+offset)
            draw(o,id,s16(h-o.h+(dh or 0)),s16(l-o.l))
        end
        -- 0xa981c 先按宽度补偿原点，再将含放大掩码的精灵入队。
        sprite(art.body[color][1],0xf600f700,fifth and -1440 or 0)
        sprite(art.body[color][2],0xf600f800+(fifth and 0xf8ffef00 or 0xfbffef00),fifth and -1200 or 0)
        sprite(art.body[color][3],0xf600f800+(fifth and 0xf9001100 or 0xfc001100),fifth and -1200 or 0)
        for i,p in ipairs(ports) do
            sprite(art.ports[color][i],0xfe00fe00+pack(p[1],p[2]),o.cover-(fifth and 0x100 or 0))
        end
        for i,gun in ipairs(o.guns) do
            local p=pack(gun[5],gun[6])
            if not o.weakened then
                sprite(art.gun[color][band(gun[3],0x3e)/2+1],p+0xfc00fc00,fifth and -0x200 or 0)
            end
            sprite(art.rotors[color][o.rotor],p+0xf9000000+0xfc00fc00,fifth and -0x600 or 0)
        end
    end

    return M
end
