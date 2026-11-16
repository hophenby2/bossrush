-- 0x179862 按槽推进动画。每张图持续时间和带位移的换图均来自 ROM。
return function(program,art)
    local band = require('bit').band
    local floor = math.floor
    local s16 = program.s16
    local M = {}

    local function setFrame(o,frame)
        o.imageFrame,o.clock = frame,frame[1]
        o.h,o.l = program.addPacked(o.h,o.l,frame[4])
    end

    local Effect = Class(object,{
        init = function(o,origin,slot,kind,speed,angle,offset,ground,delay)
            o.run,o.slot,o.frames = origin.run,slot,program.effects[kind]
            o.h,o.l,o.offset,o.delay = origin.h,origin.l,offset,delay or 0
            o.dh,o.dl = program.vector(speed,angle)
            o.frameIndex,o.ground = 0,ground
            o.group,o.layer,o.bound,o.colli = GROUP.GHOST,LAYER.ENEMY + 1,false,false
        end,
        render = function(o)
            local frame,assets = o.imageFrame,o.run.art
            if frame and assets then art.draw(assets.sprites[frame[5]],o.h,o.l,frame[2],frame[3]) end
        end,
    })

    -- 0x179a82 总池为 80 槽，满时的溢出槽不会进入绘制循环。
    function M.emit(origin,kind,speed,angle,offset,ground,delay)
        local run = origin.run
        for slot = 1,80 do
            if not run.effects[slot] then
                run.effects[slot] = New(Effect,origin,slot,kind,speed,angle,offset,ground,delay)
                return
            end
        end
    end

    function M.remove(o)
        o.run.effects[o.slot] = nil
        object.RawDel(o)
    end

    local function tick(o)
        local run = o.run
        if o.delay > 0 then
            o.delay = o.delay - 1
            o.h = s16(o.h + (o.ground and run.groundScroll or 0))
            o.l = s16(o.l - run.cameraStep)
            return true
        end
        if o.frameIndex == 0 then
            o.h,o.l = program.addPacked(o.h,o.l,o.offset)
            o.frameIndex = 1
            setFrame(o,o.frames[1])
            o.clock = o.clock + 1
        end
        local dh,dl = o.dh,o.dl
        if run.halfPathSpeed then dh,dl = floor(dh / 2),floor(dl / 2) end
        o.h,o.l = s16(o.h + dh + (o.ground and run.groundScroll or 0)),s16(o.l + dl - run.cameraStep)
        if band(o.l + 0x1000,0xffff) >= 0x5800 or band(o.h + 0x1000,0xffff) >= 0x9000 then return false end
        if not run.stopPathClock then
            o.clock = o.clock - 1
            if o.clock < 0 then
                o.frameIndex = o.frameIndex + 1
                local frame = o.frames[o.frameIndex]
                if not frame then return false end
                setFrame(o,frame)
            end
        end
        o.x,o.y = program.world(o.h,o.l)
        return true
    end

    function M.step(run)
        for slot = 1,80 do
            local o = run.effects[slot]
            if o and not tick(o) then M.remove(o) end
        end
    end

    return M
end
