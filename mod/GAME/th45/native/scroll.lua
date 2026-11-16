-- 0x14a800 分开推进地图位置与两路脚本计数。每 8 像素才推进一个生成位置。
return function(program)
    local s16 = program.s16
    local floor = math.floor
    local M = {}

    local capacities = {[1]=110,[2]=150,[3]=190,[4]=200}
    local commands = {}
    commands[4] = function(run,lane,args)
        local h,l = s16(args[4]),s16(args[5])
        h = h < 0 and h + 0x20 or h - 0x20
        lane.loop = {h=floor(h / 8),l=floor((l - 0x20) / 8),period=args[6],remaining=args[6]}
    end
    commands[8] = function(_,lane,args)
        lane.pendingH,lane.pendingL = s16(args[4]),s16(args[5])
    end
    commands[12] = function(_,lane)
        lane.release = lane.major + 4
    end
    commands[24] = function(run,_,args)
        run.bulletCapacity = assert(capacities[args[4]],'无效的原版敌弹槽容量')
    end
    commands[28] = function(run,lane)
        lane.loop = nil
        for _,state in ipairs(run.scroll) do state.release = nil end
    end
    commands[52] = function(run,_,args) run.stageFlags[args[4]] = false end
    commands[56] = function(run,_,args) run.stageFlags[args[4]] = true end

    local function dispatch(run,lane,number,major,minor)
        local rows = run.stage.scroll[number]
        local row = rows[lane.cursor]
        while row and (row[1] == 0xffff or row[1] == major) and (row[2] == 0xffff or row[2] == minor) do
            local handler = commands[row[3]]
            if handler then handler(run,lane,row) end
            if run.onScrollCommand then run.onScrollCommand(run,number,row) end
            lane.cursor = lane.cursor + 1
            row = rows[lane.cursor]
        end
    end

    function M.init(run)
        run.scroll,run.stageFlags = {},{}
        run.bulletCapacity = 70
        run.groundScroll,run.cameraFine,run.cameraOffset,run.cameraStep = 0,0,0,0
        run.cameraRelative = true
        for i = 1,2 do
            run.scroll[i] = {major=0,minor=0,hSpeed=0,lSpeed=0,hRest=0,lRest=0,hPixels=0,lPixels=0,hBlock=0,lBlock=0,cursor=1}
        end
        dispatch(run,run.scroll[1],1,0,0)
        dispatch(run,run.scroll[2],2,0,0)
    end

    local function loops(lane)
        local loop = lane.loop
        if not loop then return false end
        loop.remaining = loop.remaining - 1
        if loop.remaining ~= 0 then return false end
        loop.remaining = loop.period
        lane.hBlock,lane.lBlock = lane.hBlock + loop.h,lane.lBlock + loop.l
        return true
    end

    local function takePixels(value)
        local count = value >= 0 and floor(value / 64) or -floor(-value / 64)
        return count,value - count * 64
    end

    -- 0x14af46 只取上一帧自机横向速度的 3/8，按 64 单位量化后才和敌机同步。
    local function camera(run)
        local p = run.nativePlayer
        local previous = run.cameraOffset
        if p and p.active then
            local delta = floor(p.cameraMotion / 4)
            delta = delta + floor(delta / 2)
            if delta < 0 and p.l >= 0x3500 or delta >= 0 and p.l <= 0x300 then delta = 0 end
            if not run.cameraRelative then
                local displacement = p.l - 0x1c00
                local pixels = displacement < 0 and math.ceil(displacement / 0xc0) or floor(displacement / 0xc0)
                delta = pixels * 64 - previous
            end
            local requested = run.cameraFine + delta
            run.cameraFine = math.max(-0x800,math.min(0x800,requested))
            if requested ~= run.cameraFine and (p.l <= 0x300 or p.l >= 0x3500) then
                run.cameraRelative = false
            end
            run.cameraOffset = floor(run.cameraFine / 64) * 64
        end
        run.cameraStep = run.cameraOffset - previous
        run.playerCameraStep = run.cameraStep
    end

    function M.step(run)
        if run.freeze then run.groundScroll,run.cameraStep,run.playerCameraStep = 0,0,0; return end
        camera(run)
        local main,alternate = run.scroll[1],run.scroll[2]
        local previous = main.hPixels
        for index,lane in ipairs(run.scroll) do
            if lane.pendingH then
                lane.hSpeed,lane.lSpeed = lane.pendingH,lane.pendingL
                lane.pendingH,lane.pendingL = nil,nil
            end
            local multiplier = run.halfPathSpeed and 0.5 or 1
            local dh,dl
            dh,lane.hRest = takePixels(lane.hRest + floor(lane.hSpeed * multiplier))
            dl,lane.lRest = takePixels(lane.lRest + floor(lane.lSpeed * multiplier))
            local step = dh < 0 and -1 or 1
            for _ = 1,math.abs(dh) do
                lane.hPixels = lane.hPixels + step
                local block = lane.hPixels % 8
                if block == (step == 1 and 0 or 7) then
                    lane.hBlock = lane.hBlock + step
                    if index == 1 then loops(lane) end
                    if not lane.release then lane.major = lane.major + step end
                end
                if block == 0 then dispatch(run,lane,index,lane.major,lane.minor) end
            end
            step = dl < 0 and -1 or 1
            for _ = 1,math.abs(dl) do
                lane.lPixels = lane.lPixels + step
                local block = lane.lPixels % 8
                if block == (step == 1 and 0 or 7) then
                    lane.lBlock,lane.minor = lane.lBlock + step,lane.minor + step
                end
                if block == 0 then dispatch(run,lane,index,lane.major,lane.minor) end
            end
        end
        run.groundScroll = (main.hPixels - previous) * -64
        run.major,run.minor = alternate.major,alternate.minor
    end

    return M
end
