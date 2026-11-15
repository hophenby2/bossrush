-- 0x129578 建立机身两侧的关节。0x129086 和 0x1292a2 让各节追随自己的目标。
return function(program, bullets, effects)
    local floor, ceil, abs = math.floor, math.ceil, math.abs
    local s16, add = program.s16, program.add
    local band = require('bit').band
    local data = program.boss5
    local M = {}
    local offsets = {
        {{-0x2601,-0xc00},{-1,-0x940},{-0x881,-0xc00},{-0xec1,-0x1200},{-0x16c1,-0x1400},{-0x1f81,-0x1140}},
        {{-0x25c0,0xc00},{0,0x940},{-0x880,0xc00},{-0xec0,0x1200},{-0x16c0,0x1400},{-0x1f80,0x1140}},
    }

    local function trunc(value)
        return value < 0 and ceil(value) or floor(value)
    end

    local Joint = Class(object, {
        init = function(p, owner, offset, art)
            p.run, p.host, p.art = owner.run, owner, art
            p.group, p.layer, p.colli, p.bound = GROUP.GHOST, LAYER.ENEMY, false, false
            p.h, p.l = add(owner.h,owner.l,unpack(offset))
            p.heading, p.speed = 0, 0
        end,
        render = function(p)
            local boss = p.host
            if boss.hidden or boss.phase ~= 1 and boss.phase ~= 2 then return end
            local id = p.art[boss.hitFlash][floor(p.heading/2)+1][1]
            local image = p.run.art.sprites[id]
            local h = p.h - (p.art == data.armHead and 0x800 or 0xa00)
            local l = p.l - (p.art == data.armHead and 0x600 or 0x800)
            local x,y = program.world(h,l)
            Render(image[1],floor(x)+image[2]/2,floor(y)+image[3]/2)
        end,
    })

    local Scout = Class(object, {
        init = function(p, o, arm, prior)
            p.run,p.host,p.arm=o.run,o,arm
            p.group,p.layer,p.colli,p.bound=GROUP.ENEMY,LAYER.ENEMY,false,false
            p.damage=function() end
            p.h,p.l=arm.head.h,arm.head.l
            p.bodyContact,p.kind=false,0x65
            p.front,p.back,p.right,p.left=0xc0,0xc0,0x4c0,0x4c0
            if prior then
                p.kind,p.heading,p.turn=0x66,prior.heading,prior.turn
                p.h,p.l,p.continues=prior.h,prior.l,prior.continues-1
                p.counter,p.pause,p.aim=prior.counter,prior.pause,prior.aim
            end
            p.frameIndex,p.age=0,0
        end,
        render=function(p)
            if p.kind~=0x65 or p.frameIndex<6 and p.run.frame%2==1 then return end
            local a=data.armPod[p.frameIndex+1]
            local image=p.run.art.sprites[a[1]]
            local x,y=program.world(p.h+a[2],p.l+a[3])
            Render(image[1],floor(x)+image[2]/2,floor(y)+image[3]/2)
        end,
    })

    local function addScout(o, arm, prior)
        for slot=17,48 do
            if not o.children[slot] then
                o.children[slot]=New(Scout,o,arm,prior)
                return o.children[slot]
            end
        end
    end

    function M.launch(o, side)
        local arm=o.arms[side]
        arm.launched=false
        addScout(o,arm)
    end

    local function bounce(p)
        local h,l,a=p.h,p.l,p.heading
        if a==0x10 and l>0x3600 then p.l=0x3600
        elseif a==0x30 and l<0x200 then p.l=0x200
        elseif a==0 and h>0x6e00 then p.h=0x6e00
        elseif a==0x20 and h<0x700 then p.h=0x700
        else return end
        p.heading,p.pause=band(a+p.turn,0x3f),6
    end

    local function scoutStep(o,p)
        local run=o.run
        p.age=p.age+1
        if p.kind==0x65 then
            if not p.heading then
                p.h,p.l=p.arm.head.h,p.arm.head.l
                if p.arm.launched then
                    p.heading,p.speed,p.bodyContact=p.arm.head.heading,p.arm.head.speed-4,true
                end
            else
                local h,l=program.vector(p.speed,p.heading*4)
                p.h,p.l=s16(p.h+h),s16(p.l+l-run.cameraStep)
                local visible=p.l>=0x200 and p.l<0x3600 and p.h>0x700
                if not visible and p.entered then
                    effects.spawn(run,p.h,p.l,{{0,0x85,0,0,0,0,0}},false,true)
                    if o.phase < 2 then
                        local q=addScout(o,p.arm)
                        if q then
                            q.h,q.l,q.kind,q.heading=p.h,p.l,0x66,p.arm.side==1 and 0x10 or 0x30
                            q.turn,q.counter,q.pause,q.aim,q.continues=p.arm.side==1 and -0x10 or 0x10,0x20,0,0x20,0x38
                        end
                    end
                    return true
                end
                p.entered=p.entered or visible
            end
            if p.age%2==0 then
                p.frameIndex=p.frameIndex+1
                if p.frameIndex==10 then p.frameIndex=6 end
            end
        else
            local dh,dl=program.vector(0x38,p.heading*4)
            p.h,p.l=s16(p.h+dh),s16(p.l+dl+run.cameraStep)
            bounce(p)
            if p.age%5==0 and o.phase<2 then
                if run.pilotH then
                    local desired=program.angle(p.h,p.l,run.pilotH,run.pilotL,p.aim)
                    p.aim=program.turnToward(p.aim,desired)
                end
                if p.pause==0 then bullets.emitDirect(run,2,-2,p.aim,p.h,p.l)
                else p.pause=p.pause-1 end
                p.counter=p.counter+1
            end
            if p.age>=data.scoutSetup[2] then
                effects.spawn(run,p.h,p.l,{{0,0x87,0,0,0,0,0}},false,true)
                if o.phase<2 and p.continues>0 then addScout(o,p.arm,p) end
                return true
            end
        end
        p.x,p.y=program.world(p.h,p.l)
    end

    function M.open(o)
        if o.arms then return end
        o.arms = {}
        for side = 1,2 do
            local poses = offsets[side]
            local arm = {dh=poses[1][1],dl=poses[1][2],side=side,joints={}}
            arm.head = New(Joint,o,poses[1],data.armHead)
            for i = 2,6 do
                arm.joints[i-1] = New(Joint,o,poses[i],i == 2 and data.armBase or data.armLink)
            end
            o.arms[side] = arm
        end
    end

    local function chase(p, h, l, cam)
        p.heading = program.angle(p.h,p.l,h,l,p.heading)
        local distance = program.distance(p.h,p.l,h,l)
        p.speed = 0x2f
        for _, row in ipairs(data.linkSpeed) do
            if distance <= row[1] then p.speed = row[2]; break end
        end
        local dh,dl = program.vector(p.speed,p.heading*4)
        p.h, p.l = s16(p.h+dh), s16(p.l+dl-cam)
        p.x,p.y = program.world(p.h,p.l)
    end

    local function follow(o, arm)
        local poses, cam = offsets[arm.side], o.run.cameraStep
        local h,l = add(o.h,o.l,arm.dh,arm.dl)
        local head = arm.head
        chase(head,h,l,cam)
        local bh,bl = add(o.h,o.l,unpack(poses[2]))
        local mh,ml = bh-floor(s16(bh-head.h)/2), bl-floor(s16(bl-head.l)/2)
        local bend = -floor((-0x3400+abs(s16(bh-head.h)))/4)
        if bend >= 0 then
            mh,ml = mh+floor(bend/2),ml+(arm.side == 1 and -bend or bend)
        end
        local dh,dl = trunc((bh-mh)/5),trunc((bl-ml)/5)
        local eh,el = trunc((mh-head.h)/5),trunc((ml-head.l)/5)
        chase(arm.joints[1],bh-floor(dh/2),bl-dl,cam)
        chase(arm.joints[2],bh-2*dh,bl-2*dl,cam)
        chase(arm.joints[3],bh-4*dh,bl-4*dl,cam)
        chase(arm.joints[4],mh-eh,ml-el,cam)
        chase(arm.joints[5],mh-3*eh,ml-3*el,cam)
    end

    function M.step(o)
        if not o.arms then return end
        for _, arm in ipairs(o.arms) do follow(o,arm) end
        for slot=17,48 do
            local p=o.children[slot]
            if p and (o.phase>=3 or scoutStep(o,p)) then
                o.children[slot]=nil
                object.RawDel(p)
            end
        end
    end

    function M.close(o)
        for _, arm in ipairs(o.arms or {}) do
            for _, p in ipairs(arm.joints) do if IsValid(p) then object.RawDel(p) end end
            if IsValid(arm.head) then object.RawDel(arm.head) end
        end
        o.arms = nil
        for slot=17,48 do
            local p=o.children[slot]
            if p then
                if IsValid(p) then object.RawDel(p) end
                o.children[slot]=nil
            end
        end
    end

    return M
end
