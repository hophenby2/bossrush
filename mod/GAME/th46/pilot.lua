-- 虫姬二人 1.5 Original 普通蕾可。SH-3 在 0x0c078f70 用本帧速度积分，
-- 到 0x0c079f60 才处理射击键、更新下一帧速度。
local min, max = math.min, math.max
local unit = 0x10000
local fullSpeed, focusSpeed, speedStep = 0x28000, 0x14000, 0x2000
local holdFrames = 16
local fallFrames, recoveryFrames = 49, 80

local function axis(position, velocity, low, high)
    local nextPosition = position + velocity
    if nextPosition <= low then return low, 0 end
    if nextPosition >= high then return high, 0 end
    return nextPosition, velocity
end

local function place(player, position)
    player.x, player.y = position.x / unit - 120, position.y / unit - 160
end

return {
    recoveryFrames = recoveryFrames,
    recoveryProtection = 255,
    spawn = function(player)
        local position = { x=120*unit, y=50*unit, vx=0, vy=0, speed=fullSpeed, held=0 }
        player.pilotPosition = position
        player.laser, player.slow = false, 0
        place(player, position)
    end,
    move = function(player, key)
        local position = player.pilotPosition
        local dx = (key.right and 1 or 0) - (key.left and 1 or 0)
        local dy = (key.up and 1 or 0) - (key.down and 1 or 0)
        -- 0x0c285d10 对含有相反方向的输入组合返回零。
        if (key.right and key.left) or (key.up and key.down) then dx, dy = 0, 0 end
        local speed = position.speed
        -- 0x0c063680 使用向量表，斜向表项 2896 与轴向表项 4096 的比为 181/256。
        if dx ~= 0 and dy ~= 0 then speed = speed * 181 / 256 end
        position.x, position.vx = axis(position.x, dx*speed, 8*unit, 232*unit)
        position.y, position.vy = axis(position.y, dy*speed, 27*unit, 281*unit)
        place(player, position)

        position.held = key.shoot and position.held + 1 or 0
        player.laser = position.held >= holdFrames
        player.slow = player.laser and 1 or 0
        if not key.shoot then
            position.speed = min(fullSpeed, position.speed + speedStep)
        elseif position.held > holdFrames and position.held % 2 == 0 then
            position.speed = max(focusSpeed, position.speed - speedStep)
        end
    end,
    fall = function(player)
        local position = player.pilotPosition
        -- 0x0c0799b6 在坠落动画结束前直接积分，不经过玩家移动边界。
        position.vx = 0
        position.vy = player.respawn >= recoveryFrames-fallFrames and -2*unit or 0
        position.y = position.y + position.vy
        place(player, position)
    end,
}
