-- 0xcaf58、0xcb2dc、0xccfa8 的卷轴计数和关卡指令。
local floor, min, max, abs = math.floor, math.min, math.max, math.abs
local M = {}
local capacities = {110, 150, 190, 210}

function M.init(run, stage)
    run.stage = stage
    run.major, run.minor = stage.major, stage.minor
    run.mapMajor, run.mapMinor = stage.major, stage.minor + 36
    run.scrollX, run.scrollY = 32 + stage.minor * 8, stage.major * 8
    run.scrollAccumX, run.scrollAccumY = 0, 0
    run.scrollPixelX, run.scrollPixelY = 0, 0
    run.scrollStep, run.cameraStep, run.cameraOffset, run.cameraFixed = 0, 0, 0, 0
    run.actorScrollRemainder, run.oldCamera = 0, 0
    run.scrollIndex, run.scrollSpeed = {1, 1}, {{0,0}, {0,0}}
    run.scrollNextSpeed = {{0,0}, {0,0}}
    run.spawnIndex, run.capacity, run.holdMajor = 1, run.route and run.route.loop == 1 and 110 or 70, false
    run.freezeCamera, run.centerCamera = false, false
    run.mapLoop, run.scrollJump, run.releaseAt = nil, nil, nil
end

local function matches(run, row)
    local a, b = row[1], row[2]
    return (a ~= 0xffff or b ~= 0xffff)
        and (a == 0xffff or a == run.major) and (b == 0xffff or b == run.minor)
end

-- 遭遇战结束时用 0xcce52 登记解锁点。卷轴先走完当前循环。
function M.release(run, major)
    run.releaseAt = major
end

-- 0x127202 解除五面末段的停留。里路线接着以 8 像素/帧驶入 0x344 的循环。
function M.beginDoom(run)
    run.doomScroll = true
    run.major, run.minor, run.mapMajor, run.mapMinor = 0x29c, 0x48, 0x29c, 0x48
    run.holdMajor, run.mapLoop, run.releaseAt = false, nil, nil
    run.scrollAccumY, run.scrollPixelY = 0, 0
    run.scrollX = run.cameraOffset / 64
    run.scrollNextSpeed[1][1] = 0x200
    -- 练习快进可能已越过这组停留指令。两条流都从里路线接续的位置恢复。
    for stream, events in ipairs(run.stage.scroll) do
        local index = 1
        while events[index] and events[index][1] <= 0x29c do index = index + 1 end
        run.scrollIndex[stream] = index
    end
end

function M.doomTileRow(row, forward)
    local loopRows = 28 -- 0x344 处的 -928，经原程序扣除 32 像素的换页预留。
    if row >= forward then return forward - loopRows + (row - forward) % loopRows end
    return row
end

local function command(run, row, stream)
    local op, a, b = row[3], row[4], row[5]
    if op == 8 then
        local speed = run.scrollNextSpeed[stream]
        speed[1], speed[2] = a, b
    elseif op == 12 then
        run.holdMajor = true
    elseif op == 24 then
        run.capacity = capacities[a] or run.capacity
    elseif op == 28 then
        run.holdMajor, run.mapLoop = false, nil
    elseif op == 32 then
        run.centerCamera, run.freezeCamera = true, true
    elseif op == 36 then
        run.centerCamera, run.freezeCamera = false, true
    elseif op == 40 then
        run.scrollJump = {a, b, row[6]}
    elseif op == 4 then
        local n = a < 0 and 32 or -32
        local period = floor((b - 32) / 8)
        run.mapLoop = {delta=floor((a + n) / 8), period=period, remaining=period, mode=row[6]}
    end
    -- 调色板、背景精灵和演出标志由各自的对象消费。
    if run.onScrollCommand then run.onScrollCommand(run, row, stream) end
end

function M.events(run)
    for stream = 1, 2 do
        local events, index = run.stage.scroll[stream], run.scrollIndex[stream]
        while events[index] and matches(run, events[index]) do
            command(run, events[index], stream)
            index = index + 1
        end
        run.scrollIndex[stream] = index
    end
    local jump = run.scrollJump
    if jump then
        run.scrollJump = nil
        run.major, run.minor = jump[1], jump[2]
        run.mapMajor, run.mapMinor = jump[1] - (jump[3] == 0 and 4 or 0), jump[2] + 36
        if jump[3] ~= 0 then
            run.scrollAccumY, run.scrollPixelY, run.scrollAccumX, run.scrollPixelX = 0, 0, 0, 0
        end
        M.events(run)
    end
end

local function camera(run, pilot, playerDx)
    local prev = run.cameraOffset
    if run.centerCamera then
        local pos = run.cameraFixed
        run.cameraFixed = pos > 0 and max(0, pos - 32) or min(0, pos + 32)
    elseif pilot and not run.freezeCamera then
        if playerDx and run.previousPilotL then
            local delta = floor(playerDx / 4)
            if not (pilot <= 0x300 and delta < 0 or pilot >= 0x3500 and delta > 0) then
                run.cameraFixed = min(0x800, max(-0x800, run.cameraFixed + delta + floor(delta / 2)))
            end
        elseif not run.previousPilotL then
            local target = (pilot - 0x1c00) / 0xc0
            local whole = target < 0 and math.ceil(target) or floor(target)
            run.cameraFixed = min(0x800, max(-0x800, whole * 64))
        end
    end
    run.cameraOffset = floor(run.cameraFixed / 64) * 64
    run.cameraStep = run.cameraOffset - prev
    if not run.centerCamera and abs(run.cameraFixed) == 0x800 then
        run.freezeCamera = false
    end
    return run.cameraStep / 64
end

local function pixels(value, velocity)
    if velocity < 0 then return min(0, math.ceil(value / 64)) end
    return max(0, floor(value / 64))
end

function M.advance(run, pilot, playerDx)
    if run.freeze then
        run.cameraStep, run.scrollStep = 0, 0
        return
    end
    M.events(run)
    for i, speed in ipairs(run.scrollSpeed) do
        speed[1], speed[2] = unpack(run.scrollNextSpeed[i])
    end
    local main, sub = run.scrollSpeed[1], run.scrollSpeed[2]
    -- 0xcad08 同时修改两条横向速度流，第二条只用于对象坐标换算。
    local bossL = run.bossScrollL
    local mainL, subL = bossL or main[2], bossL or sub[2]
    local ah, al = run.scrollAccumY + main[1], run.scrollAccumX + mainL
    local dh, dl = pixels(ah, main[1]), pixels(al, mainL)
    run.scrollAccumY, run.scrollAccumX = ah - dh * 64, al - dl * 64
    for _ = 1, abs(dh) do
        local sign = dh > 0 and 1 or -1
        run.scrollPixelY = (run.scrollPixelY + sign) % 8
        if run.scrollPixelY == 0 and sign == 1 or run.scrollPixelY == 7 and sign == -1 then
            local wasHeld = run.holdMajor
            local loop = run.mapLoop
            run.mapMajor = run.mapMajor + sign
            if loop then
                loop.remaining = loop.remaining - 1
                if loop.remaining == 0 then
                    loop.remaining = loop.period
                    if run.releaseAt then
                        run.major, run.releaseAt = run.releaseAt, nil
                        run.holdMajor = false
                        run.mapLoop = nil
                    else
                        run.mapMajor = run.mapMajor + loop.delta
                    end
                end
            end
            if not wasHeld or not run.holdMajor then run.major = (run.major + sign) % 65536 end
        end
        M.events(run)
    end
    for _ = 1, abs(dl) do
        local sign = dl > 0 and 1 or -1
        run.scrollPixelX = (run.scrollPixelX + sign) % 8
        if run.scrollPixelX == 0 and sign == 1 or run.scrollPixelX == 7 and sign == -1 then
            run.mapMinor, run.minor = run.mapMinor + sign, (run.minor + sign) % 65536
            local limit = run.stage.across * 4
            if run.mapMinor <= 0 then run.mapMinor = limit end
        end
        M.events(run)
    end
    run.scrollStep = dh
    -- 0x0ac556 把主轴的整像素位移和副轴的定点速度相加后写出。
    local adjusted = run.actorScrollRemainder + dl * 64 + subL + camera(run, pilot, playerDx) * 64
    run.actorScrollRemainder = adjusted % 64
    run.cameraStep = adjusted - run.actorScrollRemainder
    run.scrollX, run.scrollY = run.scrollX + dl + run.cameraOffset / 64 - run.oldCamera / 64, run.scrollY + dh
    run.oldCamera = run.cameraOffset
end

return M
