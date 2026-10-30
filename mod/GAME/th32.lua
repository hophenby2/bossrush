---=====================================
---TH32 猩红测试：红魔乡 Lunatic / Extra 全部 Boss 符卡及非符（含中 Boss）。
---原生 ecldata1..7.ecl：47 个不同符卡名；四条帕秋莉路线展开为 54 条符卡、37 段非符。
---证据：th06/src/{EclManager,EnemyEclInstr,BulletManager,EnemyManager}.cpp；数据哈希见下方。
---使用 LuaSTG bullet / laser / enemy / object 和协程。离线展开后只执行直接 Lua 调用，
---运行时不读 ECL，不保存指令数组，也不运行指令解释器。
---原作与本作都是 384×448：x=x原-192，y=224-y原，角度取负，不缩放弹道。
---差异 1：弹图、出场光圈、音效、立绘、背景与 BGM 复用现有资源；小恶魔用大妖精图，
---原作 ANM 的无判定装饰粒子省略，使魔用现成敌机图，芙兰分身使用芙兰行走图。
---差异 2：沿用本测试场的 rank 上限：L=32，Extra=18；原作分别在 10..32 / 14..18 浮动。
---各卡仍执行原作的 rank 数量、速度、周期插值与 ins_131；没有按密度另行调参。
---本文件的原作弹体使用 rank_speed=false，Boss 使用原始 HP，保证上述固定 ECL rank 口径。
---差异 3：自机、Bomb、擦弹和伤害结算走本项目系统；弹体使用原作矩形判定尺寸，
---激光包含原作预热/收束阶段「仅中点有判定」的行为。击破血量与时限取原生 ECL。
---=====================================
_editor_class["TH32"] = {}
local class = _editor_class["TH32"]
local TH08 = _editor_class["TH08"] or {}
local bullet_lw3_4, bullet_lw3_5 = TH08["bullet_lw3-4"], TH08["bullet_lw3-5"]
do -- 原作内部用弧度，作用域在此结束，保留后面自制卡的 LuaSTG 角度制。
local task, object, bullet, laser = task, object, bullet, laser
local min, max, floor, sqrt = math.min, math.max, math.floor, math.sqrt
local cos, sin, atan2 = math.cos, math.sin, math.atan2
local PI, DEG = math.pi, 180 / math.pi
local bit = require("bit")
local band = bit.band
local LEVEL, RANK, POOL_SIZE = 30, 32, 640

-- 只列本关实际使用的弹种：{THlib 图样，原精灵宽，原精灵高，原判定全宽}。
-- BulletManager.cpp 的 grazeSize 是全宽；Player::CheckCollision 再除以二。
local SHAPES = {
    [0] = { ball_small, 8, 8, 4 }, [2] = { grain_a, 16, 16, 4 },
    [4] = { arrow_small, 16, 16, 5 }, [7] = { water_drop, 30, 30, 11 },
    [1] = { ball_mid_c, 16, 16, 6 },
    [3] = { ball_small, 16, 16, 6 }, [5] = { arrow_small, 16, 16, 4 },
    [6] = { ball_big, 32, 32, 16 }, [8] = { knife, 32, 32, 9 },
    [9] = { ball_huge, 64, 64, 32 },
}
local COLOUR16={16,1,2,3,4,5,6,7,8,9,10,11,12,12,14,16}
local COLOUR8={15,2,4,6,8,10,12,16}
local COLOUR4={2,6,10,12}
local function colour(sprite, c)
    local palette=(sprite==9 or sprite==7) and COLOUR4 or (sprite>=6 and COLOUR8 or COLOUR16)
    -- Func4 会把所有大弹改为 GREEN8=5，Func0 会把全池改为 WHITE=15，
    -- 包括原来只有四/八色的弹种；代理素材按这些变色语义补齐颜色。
    return palette[c+1] or COLOUR8[c+1] or COLOUR16[c+1] or 16
end
local function normal_angle(a)
    while a > PI do a = a - 2 * PI end
    while a < -PI do a = a + 2 * PI end
    return a
end
local function alive(b)
    return b and IsValid(b) and not b.th06_dead
end
local function in_screen(b)
    return b.x >= -192 - b.th06_w / 2 and b.x <= 192 + b.th06_w / 2
        and b.y >= -224 - b.th06_h / 2 and b.y <= 224 + b.th06_h / 2
end
local function retire(b)
    b.th06_dead = true
    object.RawDel(b)
end
local function velocity(b, a, v)
    b.th06_angle, b.th06_speed = a, v
    b.vx, b.vy = cos(a) * v, -sin(a) * v
end

class["原作弹"] = Class(bullet, {
    init = function(b, s, sprite, c, x, y, a, v, flags, ex)
        local shape = SHAPES[sprite]
        bullet.init(b, shape[1], colour(sprite, c), false, true)
        -- bullet.init 会把 class 换成雾化样式；本类自己负责原作出场状态与计时。
        b.class = b.logclass
        b.x, b.y, b.bound = x, y, false
        b.th06_owner, b.th06_sprite = s, sprite
        b.rank_speed=false
        b.th06_w, b.th06_h = shape[2], shape[3]
        if sprite==0 then b.hscale,b.vscale=.5,.5 elseif sprite==1 then b.hscale,b.vscale=.8,8/9 elseif sprite==7 then b.hscale,b.vscale=.625,1 end
        b.a, b.b, b.rect, b.rot = shape[4] / 2, shape[4] / 2, true, 0
        b.th06_flags, b.th06_tick, b.th06_out = flags, 0, 0
        b.th06_colour=c
        b.th06_ex = ex or {}
        b.th06_turns = 0
        b.th06_awake = false
        -- 紅魔郷CM.DAT 内 etama3.anm script17/18/19/20：10/16/32/32；
        -- etama4.anm script2：泡弹的三种出场 flags 都使用 24 帧。
        b.th06_spawn = band(flags, 2) ~= 0 and 10
            or (band(flags, 4) ~= 0 and 16 or (band(flags, 8) ~= 0 and 32 or 0))
        -- 大弹共享 SPAWN_*_HUGE，三种 flags 都用同一段动画。
        if sprite >= 6 and b.th06_spawn > 0 then b.th06_spawn = sprite == 9 and 24 or 32 end
        b.th06_spawn_total = b.th06_spawn
        b.colli = b.th06_spawn == 0
        velocity(b, a, v)
        if band(flags, 16) ~= 0 then
            local dir = b.th06_ex[3]
            if dir == nil or dir <= -999 then dir = a end
            b.th06_ax, b.th06_ay = cos(dir) * b.th06_ex[2], -sin(dir) * b.th06_ex[2]
        end
    end,
    frame = function(b)
        if b.th06_owner.time_stopped then
            if not b.th06_paused then b.th06_pause_vx,b.th06_pause_vy=b.vx,b.vy;b.th06_paused=true end
            b.vx,b.vy=0,0
            return
        elseif b.th06_paused then
            b.vx,b.vy=b.th06_pause_vx,b.th06_pause_vy;b.th06_paused=false
        end
        bullet.frame(b)
        local flags, ex = b.th06_flags, b.th06_ex
        local spawn_dx, spawn_dy = 0, 0
        if b.th06_spawn > 0 then
            b.colli = false
            local divisor = band(flags, 2) ~= 0 and 2 or (band(flags, 4) ~= 0 and 2.5 or 3)
            b.vx, b.vy = (b.th06_vx or cos(b.th06_angle) * b.th06_speed) / divisor,
                (b.th06_vy or -sin(b.th06_angle) * b.th06_speed) / divisor
            spawn_dx, spawn_dy = b.vx, b.vy
            b.th06_spawn = b.th06_spawn - 1
            b.th06_tick = 0
            -- 原作出场动画的最后一帧落入 FIRED，同帧还会再积分一次完整速度。
            if b.th06_spawn > 0 then return end
        end
        do
            b.colli = true
            if band(flags, 1) ~= 0 then
                if b.th06_tick <= 16 then
                    b.vx, b.vy = cos(b.th06_angle) * (b.th06_speed + 5 - b.th06_tick * 5 / 16),
                        -sin(b.th06_angle) * (b.th06_speed + 5 - b.th06_tick * 5 / 16)
                else
                    b.th06_flags = flags - 1
                end
            elseif band(flags, 16) ~= 0 and b.th06_tick < ex[1] then
                -- ex4 是向量加速，不能写成「速度标量递增」；醒弹时速度从零开始。
                b.th06_vx = (b.th06_vx or cos(b.th06_angle) * b.th06_speed) + b.th06_ax
                b.th06_vy = (b.th06_vy or -sin(b.th06_angle) * b.th06_speed) + b.th06_ay
                b.vx, b.vy = b.th06_vx, b.th06_vy
                b.th06_angle = atan2(-b.vy, b.vx)
            elseif band(flags, 32) ~= 0 and b.th06_tick < ex[1] then
                velocity(b, b.th06_angle + ex[3], b.th06_speed + ex[2])
            else
                -- 出场结束或加速结束后，保持最后一个速度向量。
                b.vx = b.th06_vx or cos(b.th06_angle) * b.th06_speed
                b.vy = b.th06_vy or -sin(b.th06_angle) * b.th06_speed
            end
            -- 0x800 在「整颗精灵越界」后反弹一次；底边不反射，但仍会消耗次数。
            local turn_flag = band(flags, 64) ~= 0 and 64 or (band(flags, 256) ~= 0 and 256 or (band(flags, 128) ~= 0 and 128 or 0))
            if turn_flag ~= 0 then
                local speed, interval = b.th06_speed, max(1, ex[1])
                if b.th06_tick >= interval * (b.th06_turns + 1) then
                    b.th06_turns = b.th06_turns + 1
                    if b.th06_turns >= (ex[4] or 1) then b.th06_flags = b.th06_flags - turn_flag end
                    local a = ex[2]
                    if turn_flag == 64 then a = b.th06_angle + a end
                    if turn_flag == 128 then a = atan2(-(player.y - b.y), player.x - b.x) + a end
                    velocity(b, a, ex[3] and ex[3] >= 0 and ex[3] or b.th06_speed)
                else
                    speed = speed * (1 - (b.th06_tick - interval * b.th06_turns) / interval)
                    b.vx, b.vy = cos(b.th06_angle) * speed, -sin(b.th06_angle) * speed
                end
            elseif band(flags, 3072) ~= 0 and not in_screen(b) then
                local a = b.th06_angle
                if b.x < -192 or b.x >= 192 then a = -a - PI end
                if b.y > 224 or (band(flags, 1024) ~= 0 and b.y <= -224) then a = -a end
                velocity(b, a, ex[2] and ex[2] >= 0 and ex[2] or b.th06_speed)
                b.th06_turns = b.th06_turns + 1
                if b.th06_turns >= (ex[1] or 1) then b.th06_flags = flags - band(flags, 3072) end
            end
            b.th06_tick = b.th06_tick + 1
        end
        b.vx, b.vy = b.vx + spawn_dx, b.vy + spawn_dy
        -- 引擎在 frame 之后积分；按下一位置判断，保证衍生弹看不到已释放的弹槽。
        local nx, ny = b.x + b.vx, b.y + b.vy
        local inside = nx >= -192 - b.th06_w / 2 and nx <= 192 + b.th06_w / 2
            and ny >= -224 - b.th06_h / 2 and ny <= 224 + b.th06_h / 2
        if inside then b.th06_out = 0 else
            b.th06_out = b.th06_out + 1
            if (band(b.th06_flags, 3520) == 0 and b.th06_out == 1) or b.th06_out >= 256 then retire(b) end
        end
    end,
    render = function(b)
        -- 出场图只是替代视觉，运动和判定仍由原作状态机控制。
        local a = b._a
        if b.th06_spawn > 0 then b._a = 255 * (1 - b.th06_spawn / b.th06_spawn_total) end
        bullet.render(b)
        b._a = a
    end,
})

local function single(s, sprite, c, x, y, a, v, flags, ex)
    -- 保留原作环形槽位顺序：Func8/9 按槽号扫描，不能把新生弹插到一个无序集合里。
    for _ = 1, POOL_SIZE do
        local i = s.next_slot
        s.next_slot = i % POOL_SIZE + 1
        if not alive(s.pool[i]) then
            local b = New(class["原作弹"], s, sprite, c, x, y, a, v, flags or 0, ex)
            s.pool[i] = b
            return b
        end
    end
end

-- 原生发弹工厂；a/step 均保留 ECL 弧度，只有写入 LuaSTG 速度时才翻转 y。
-- mode=ring/fan/aim/random；这只是几何函数，不接收或执行 ECL 指令。
local function shoot(owner, mode, sprite, c, n, layers, v1, v2, a, step, flags, ex, x, y)
    local s = owner.th06
    x, y = x or owner.x, y or owner.y
    local influence = s.rank_speed
    if v1 ~= 0 then v1 = max(.3, v1 + influence) end
    v2 = max(.3, v2 + influence / 2)
    a = normal_angle(a)
    local aimed = (mode == "aim" or mode == "ring_aim" or mode == "offset_aim") and atan2(-(player.y - y), player.x - x) or 0
    local full = false
    for layer = 0, layers - 1 do
        for i = 0, n - 1 do
            local angle = a
            if mode == "ring" or mode == "ring_aim" or mode == "random_speed" then angle = a + aimed + i * 2 * PI / n + layer * step
            elseif mode == "offset" or mode == "offset_aim" then angle = a + aimed + PI / n + i * 2 * PI / n
            elseif mode == "random" or mode == "random_angle" then angle = ran:Float(step, a)
            else
                local k = n % 2 == 1 and floor((i + 1) / 2) or floor(i / 2) + .5
                angle = a + aimed + (i % 2 == 1 and -1 or 1) * k * step
            end
            local speed = (mode == "random" or mode == "random_speed") and ran:Float(v2, v1) or v1 - (v1 - v2) * layer / layers
            if not single(s, sprite, c, x, y, angle, speed, flags, ex) then
                full = true; break
            end
        end
        if full then break end
    end
    if band(flags or 0, 512) ~= 0 then PlaySound("tan00", .1, x / 256, false) end
end

local function move_to(b, x, y, frames)
    b.th06.move = { x = b.x, y = b.y, dx = x - b.x, dy = y - b.y, t = 0, n = frames }
end
local function drift(b, speed, frames)
    -- ins_50 对原坐标逐次反射角度；上下反射都要执行，窄框中可能互相抵消。
    local a = ran:Float(-PI, PI)
    if b.x < -64 then
        if a > PI / 2 then a = PI - a elseif a < -PI / 2 then a = -PI - a end
    end
    if b.x > 64 then
        if a >= 0 and a < PI / 2 then a = PI - a elseif a <= 0 and a > -PI / 2 then a = -PI - a end
    end
    if b.y > 128 and a < 0 then a = -a end
    if b.y < 152 and a > 0 then a = -a end
    move_to(b, b.x + cos(a) * speed * frames / 2, b.y - sin(a) * speed * frames / 2, frames)
end
local function move_step(b)
    local m = b.th06.move
    if m then
        m.t = m.t + 1
        local u = min(m.t / m.n, 1)
        local e = 2 * u - u * u
        b.x, b.y = m.x + m.dx * e, m.y + m.dy * e
        if m.t >= m.n then b.th06.move = nil end
    end
    b.x, b.y = min(160, max(-160, b.x)), min(176, max(104, b.y))
end

-- Func8：扫描所有高度 >=30 的活弹（包括刀和中玉），池满也计入 changedBullets。
local function seed_small(b)
    local s, count = b.th06, 0
    for i = 1, POOL_SIZE do
        local big = s.pool[i]
        if alive(big) and big.th06_h >= 30 then
            single(s, 3, 1, big.x, big.y, ran:Float(-PI, PI), 0, 8)
            count = count + 1
        end
    end
    return count
end
local function awaken(b, random_each)
    local s = b.th06
    local shared = ran:Float(-PI, PI) -- Func11 也会先消耗这一次随机数。
    for i = 1, POOL_SIZE do
        local small = s.pool[i]
        if alive(small) and small.th06_h < 30 and small.th06_speed == 0 then
            local dx, dy = small.x - b.x, small.y - b.y
            local distance2 = dx * dx + dy * dy
            local distance = distance2 > .1 and sqrt(distance2) or 0
            local a = random_each and ran:Float(-PI, PI) or distance * PI / 256 + shared
            small.th06_ax, small.th06_ay = cos(a) * .01, -sin(a) * .01
            small.th06_ex = { 120, .01 }
            small.th06_flags = bit.bor(small.th06_flags, 16)
            small.th06_speed, small.th06_tick, small.th06_awake = .01, 0, true
            -- 原作只修改 speed 字段，velocity 仍是零，第一帧加速后为 0.01。
            small.th06_vx, small.th06_vy = 0, 0
            bullet.ChangeImage(small, SHAPES[3][1], colour(3, 2))
            small.a, small.b, small.rect = 3, 3, true
        end
    end
end
local function trail(b, rounds, gap)
    for _ = 1, rounds do
        if seed_small(b) == 0 then return end
        task.Wait(gap)
    end
end

-- Func7 的 48 段激光采用原生 laser 的碰撞/擦弹；显示时换回完整线段。
class["大卫之星激光"] = Class(laser, {
    init = function(l, x, y, a, length, width, start)
        laser.init(l, width == 20 and 8 or 2, x, y, -a * DEG, 0, length, 0, width, 0, 0)
        l.bound = false
        l.th06_x, l.th06_y, l.th06_length = x, y, length
        l.th06_width, l.th06_start, l.th06_age = width, start, 0
    end,
    frame = function(l)
        local t, start = l.th06_age, l.th06_start
        if t >= 166 then retire(l); return end
        local w = l.th06_width
        if t < start then w = t > start - 30 and t * w / start or 1.2
        elseif t >= 150 then w = w * (1 - (t - 150) / 16) end
        l.th06_draw_width = w
        local length, shift = l.th06_length, 0
        if t < start or t >= 150 then
            -- 原作错误写到 laserSize.x：预热最后阶段和消退只有中点附近可碰撞。
            length = w / 2
            shift = (l.th06_length - length) / 2
        end
        l.x, l.y = l.th06_x + math.cos(l.rot / DEG) * shift, l.th06_y + math.sin(l.rot / DEG) * shift
        l.l1, l.l2, l.l3, l.w, l.alpha = 0, length, 0, l.th06_width / 2, 1
        l.colli = t >= 50
        laser.frame(l)
        l.th06_age = t + 1
    end,
    render = function(l)
        local x, y, length, w = l.x, l.y, l.l2, l.w
        l.x, l.y, l.l2 = l.th06_x, l.th06_y, l.th06_length
        l.w = (l.th06_draw_width or 1.2) * 7 / 16
        laser.render(l)
        l.x, l.y, l.l2, l.w = x, y, length, w
    end,
})
local function star(b)
    local phase = ran:Float(0, 2 * PI)
    for i = #b.th06.lasers, 1, -1 do
        if not alive(b.th06.lasers[i]) then table.remove(b.th06.lasers, i) end
    end
    for outer = 0, 1 do
        local base = (outer == 0 and -PI or -7 * PI / 8) + phase
        local turn = outer == 0 and PI / 4 or -PI / 4
        local points = {}
        for i = 0, 7 do
            local a = base + i * PI / 4
            points[i] = { b.x + cos(a) * 32, b.y - sin(a) * 32 }
        end
        for inner = 0, 2 do
            local length = inner < 2 and 112 or 480
            for i = 0, 7 do
                local p, a = points[i], base + inner * turn + i * PI / 4
                local ray = New(class["大卫之星激光"], p[1], p[2], a, 440, 20, 60 + inner * 16)
                b.th06.lasers[#b.th06.lasers + 1] = ray
                p[1], p[2] = p[1] + cos(a) * length, p[2] - sin(a) * length
            end
        end
    end
end

local function begin(b, y, rank_speed)
    b.th06 = { pool = {}, next_slot = 1, lasers = {},
        rank_speed = rank_speed or 0 }
    b.colli, b.no_hp_render, b.NotPlayTimeOutSound = true, false, false
    -- 独立练习从场外生成 Boss；原作在进入符卡前已经启用同一组移动边界。
    b.x, b.y = min(160, max(-160, b.x)), min(176, max(104, b.y))
    move_to(b, 0, 224 - y, 120)
    task.Wait(120)
end
local function cleanup(b)
    if not b.th06 then return end
    for _, o in pairs(b.th06.pool) do if alive(o) then object.Del(o) end end
    for _, o in ipairs(b.th06.lasers) do if alive(o) then object.Del(o) end end
    b.th06 = nil
end
local function new_card(name, timeout, hp, run)
    local c = boss.card.New(name, 2, 2, timeout, hp)
    function c:before() self.th06 = nil;self.a,self.b,self.rect=28,28,true end
    function c:init()
        self.hp,self.maxhp,self._rank_hp_proxy=c.hp,c.hp,true
        task.New(self, function() run(self) end)
    end
    function c:frame() if self.th06 then move_step(self) end end
    function c:del() cleanup(self) end
    return c
end
boss.Define("1a", "蕾米莉亚·斯卡蕾特", "TH06_0", TH06_bg,
    { 0, 384 }, TH08["SCBG-LW13"], "Remilia", LEVEL)
local function register(c, name, id)
    boss.card.add({ { c, "1a" } }, LEVEL, name .. "（Lunatic）", id)
end

-- Sub31 @0x3a38：64 帧蓄力，48 段青色激光；4 组双环相隔 16 帧，周期 188 帧。
do
    local NAME, ID, TIME, HP = "神罚「年幼的恶魔之王」", 3802, 40, 1200
    local function run(b)
        begin(b, 112, RANK / 32 - .5)
        while true do
            task.Wait(64)
            star(b)
            local a, a2 = ran:Float(-PI, PI), ran:Float(-PI, PI)
            for _ = 1, 4 do
                shoot(b, "ring", 9, 3, 12, 1, .8, 1, a, 0, 528, {120, .015})
                shoot(b, "ring", 6, 3, 14, 2, 1.5, .5, a2, 0, 528, {120, .015})
                a, a2 = a + PI / 16, a2 - PI / 32
                task.Wait(16)
            end
            drift(b, 2.5, 90); task.Wait(60)
        end
    end
    register(new_card(NAME, TIME, HP, run), NAME, ID)
end

-- Sub33 @0x40d8：刀环 100 帧内每帧转 ±1.8°，札弹一次上/左右反弹。
-- 0x4352/0x4406 的加角仍带 H 掩码，L 只执行自己发弹后面的加角。
do
    local NAME, ID, TIME, HP = "狱符「千根针的针山」", 3805, 40, 1600
    local function run(b)
        begin(b, 144)
        while true do
            local a = ran:Float(-PI, PI)
            for _ = 1, 5 do
                shoot(b, "ring", 8, 1, 16, 1, 2, 1, a, -PI / 200, 544, {100, 0, PI / 100})
                a = a + PI / 32; task.Wait(3)
                shoot(b, "ring", 8, 1, 16, 1, 2, 1, a, -PI / 200, 544, {100, 0, -PI / 100})
                a = a + PI / 32; task.Wait(3)
                for j = 1, 2 do
                    shoot(b, "ring", 5, 2, 32, 1, 1.3, 1, a, -PI / 200, 2560, {1, -1})
                    a = a + PI / 32
                    task.Wait(j == 1 and 3 or 8)
                end
            end
            drift(b, 1.5, 90); task.Wait(50)
        end
    end
    register(new_card(NAME, TIME, HP, run), NAME, ID)
end

-- Sub35 @0x4828：8 路偶数自机狙泡弹，48 次全池采样，每 4 帧一次。
-- 只有剩余循环数 <=32 才唤醒；大玉提前离场时，静止小弹可以留到下一轮。
do
    local NAME, ID, TIME, HP = "神术「吸血鬼幻想」", 3808, 40, 1600
    local function run(b)
        begin(b, 108)
        while true do
            shoot(b, "aim", 9, 1, 8, 1, 7, 2, 0, -PI / 10, 516)
            local left = 48
            while left > 0 do
                if seed_small(b) == 0 then break end
                task.Wait(4); left = left - 1
            end
            if left <= 32 then awaken(b, false) end
            drift(b, 2.5, 60); task.Wait(24)
        end
    end
    register(new_card(NAME, TIME, HP, run), NAME, ID)
end

-- Sub37：RANDOM 同时随机方向和速度；仅 angle1 归一化，保留跨 ±π 时的宽扇。
local function scarlet_fan(b, a, spread, count, v1, v2, sprite, c, flags)
    shoot(b, "random", sprite, c, count, 1, v1, v2, a - spread, a + spread, flags)
end
local function scarlet_shot(b, a)
    shoot(b, "fan", 9, 0, 1, 1, 6.2, 1.2, a, 0, 2)
    scarlet_fan(b, a, PI / 32, 3, 6, 4, 6, 1, 2)
    scarlet_fan(b, a, PI / 20, 5, 4, 3, 6, 1, 2)
    scarlet_fan(b, a, PI / 8, 10, 3, 2, 1, 2, 0)
    scarlet_fan(b, a, PI / 4, 5, 2, 1, 1, 2, 0)
    PlaySound("tan00", .1, b.x / 256, false)
end
local function aimed_shot(b)
    scarlet_shot(b, atan2(-(player.y - b.y), player.x - b.x))
end

-- Sub39 @0x5528：五次逐次狙击；17×3 帧正转；两次狙击；17×3 帧反转。
-- CALL 的 Sub37 当帧返回；循环跳转时重设 ECL 时钟，整个周期 468 帧。
do
    local NAME, ID, TIME, HP = "红符「绯红之主」", 3811, 30, 1300
    local function run(b)
        begin(b, 112)
        while true do
            task.Wait(64)
            for shot = 1, 5 do
                aimed_shot(b)
                if shot == 5 then drift(b, 2.5, 90) end
                task.Wait(6)
            end
            local a = atan2(-(player.y - b.y), player.x - b.x)
            for _ = 1, 17 do
                scarlet_shot(b, a); a = normal_angle(a + PI / 8); task.Wait(3)
            end
            task.Wait(80)
            aimed_shot(b); task.Wait(6)
            aimed_shot(b); drift(b, 2.5, 90); task.Wait(6)
            a = atan2(-(player.y - b.y), player.x - b.x)
            for _ = 1, 17 do
                scarlet_shot(b, a); a = normal_angle(a - PI / 8); task.Wait(3)
            end
            task.Wait(80)
        end
    end
    register(new_card(NAME, TIME, HP, run), NAME, ID)
end

-- Sub44 @0x627c：A/B/C/D 发弹时间为 0/200/480/680，正常整轮 930 帧。
-- A 的 flags=512 不启用曲率；Sub41 返回后才唤醒，全池无大弹时会提前返回。
do
    local NAME, ID, TIME, HP = "「红色的幻想乡」", 369, 140, 5300
    local function run(b)
        begin(b, 128)
        while true do
            shoot(b, "ring", 9, 1, 14, 4, 4, 1.8, ran:Float(-PI, PI), -PI / 10, 512)
            drift(b, 2.5, 60); trail(b, 20, 10); awaken(b, true)
            shoot(b, "ring", 9, 1, 12, 1, 2, 1, ran:Float(-PI, PI), -PI / 200,
                544, {80, .023, -PI / 128})
            drift(b, 2.5, 60); trail(b, 20, 10); awaken(b, false)
            local a = ran:Float(-PI, PI); task.Wait(80)
            shoot(b, "ring", 9, 1, 17, 1, 2, 1, a, -PI / 200, 544, {60, .026, PI / 128})
            trail(b, 20, 10); awaken(b, true); drift(b, 2.5, 60)
            shoot(b, "ring", 9, 1, 16, 1, 1, 1, ran:Float(-PI, PI), -PI / 200,
                544, {80, .023, -PI / 128})
            trail(b, 20, 10); awaken(b, false); drift(b, 2.5, 60); task.Wait(50)
        end
    end
    register(new_card(NAME, TIME, HP, run), NAME, ID)
end

-- TH06_KERNEL_START
-- 全关共享的原生几何/对象组件。下方各子程序已经离线展开，不含指令表或运行时取指器。
local H, P = {}, { {}, {}, {}, {}, {}, {}, {} }
local STOP = {}
local enemy = enemy
local function trunc(x) return x < 0 and math.ceil(x) or floor(x) end
function H.random_int(n) return n>0 and ran:Int(0,n-1) or 0 end
function H.reset_rank(a)
    a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-.5,.5,0,0,0,0
end
function H.lerp(rank, lo, hi, integer)
    local n = rank * (hi - lo) / 32
    return lo + (integer and trunc(n) or n)
end
function H.trace(b, kind, ...)
    local hook = rawget(_G, "TH32_NATIVE_TRACE")
    if hook then hook(b, kind, ...) end
end
function H.ctx(epoch)
    return { i0=0,i1=0,i2=0,i3=0,f0=0,f1=0,f2=0,f3=0,c0=0,c1=0,c2=0,c3=0,cmp=0,time=0,epoch=epoch or 0 }
end
function H.wait(b, v, target)
    local a = b.th06_actor
    a.context = v
    local delay = max(0,target-v.epoch)-max(0,v.time-v.epoch)
    if delay > 0 then for _=1,delay do task.Wait() end end
    v.time = target
end
function H.call(b, v, fn, i0, f0)
    local child = {}
    for k,value in pairs(v) do child[k]=value end
    child.time, child.epoch, child.i0, child.f0 = 0, 0, i0, f0
    b.th06_actor.context = child
    fn(b, child)
    b.th06_actor.context = v
end
function H.life(b)
    local a=b.th06_actor
    return a.death_life or (b.hp + (a.main and a.meta.threshold or 0))
end
function H.player_angle(b) return atan2(-(player.y-b.y),player.x-b.x) end
function H.distance(b) return sqrt((player.x-b.x)^2+(player.y-b.y)^2) end
function H.position(b,x,y,z)
    b.x,b.y=x-192,224-y
    b.th06_actor.z=z or 0
end
function H.clamp(b)
    local box=b.th06_actor.bounds
    if box then b.x=min(box[3]-192,max(box[1]-192,b.x));b.y=min(224-box[2],max(224-box[4],b.y)) end
end
function H.move_to(b,frames,x,y,z,ease)
    local a=b.th06_actor
    a.move={x=b.x,y=b.y,dx=x-192-b.x,dy=224-y-b.y,n=max(1,frames),t=0,ease=ease}
    a.mode="interp";a.axisx,a.axisy=0,0
    a.z=z or a.z
    H.trace(b,"move",frames,x,y,z,ease)
end
function H.move_dir(b,frames,angle,speed,ease)
    H.move_to(b,frames,b.x+192+cos(angle)*speed*frames/2,224-b.y+sin(angle)*speed*frames/2,0,ease)
end
function H.rand_angle(b,lo,hi,bounded)
    local a=ran:Float(lo,hi)
    local box=b.th06_actor.bounds
    if bounded and box then
        local x,y=b.x+192,224-b.y
        if x<box[1]+96 then if a>PI/2 then a=PI-a elseif a< -PI/2 then a=-PI-a end end
        if x>box[3]-96 then if a>=0 and a<PI/2 then a=PI-a elseif a<=0 and a> -PI/2 then a=-PI-a end end
        if y<box[2]+48 and a<0 then a=-a end
        if y>box[4]-48 and a>0 then a=-a end
    end
    b.th06_actor.angle=a
end
function H.interval(b,n,random)
    local a=b.th06_actor
    a.interval=n+H.lerp(a.rank,trunc(n/5),-trunc(n/5),true)
    if not random then a.interval_tick=0
    elseif a.interval>0 then a.interval_tick=ran:Int(0,a.interval-1) end
    H.trace(b,"interval",a.interval,random)
end
local MODES={"aim","fan","ring_aim","ring","offset_aim","offset","random_angle","random_speed","random"}
function H.pattern(b,mode,sprite,c,n,l,v1,v2,angle,step,flags)
    local a=b.th06_actor
    mode=MODES[mode] or mode
    n=max(1,n+H.lerp(a.rank,a.rank_n1_lo,a.rank_n1_hi,true))
    l=max(1,l+H.lerp(a.rank,a.rank_n2_lo,a.rank_n2_hi,true))
    local influence=H.lerp(a.rank,a.rank_lo,a.rank_hi,false)
    if v1~=0 then v1=max(.3,v1+influence) end
    v2=max(.3,v2+influence/2)
    a.pattern={mode=mode,sprite=sprite,c=c,n=n,l=l,v1=v1,v2=v2,angle=normal_angle(angle),step=step,flags=flags}
    H.trace(b,"pattern",mode,sprite,c,n,l,v1,v2,normal_angle(angle),step,flags)
    if not a.muted then H.fire(b) end
end
function H.fire(b,x,y,pattern)
    local a=b.th06_actor
    local p=pattern or a.pattern
    if not p then return end
    local e=a.extra
    local ex={e[1],e[5],e[6],e[2]}
    if band(p.flags,16)~=0 and ex[1]<=0 then ex[1]=99999 end
    x,y=x or b.x+a.offsetx,y or b.y-a.offsety
    H.trace(b,"fire",p.mode,p.sprite,p.c,p.n,p.l,p.v1,p.v2,p.angle,p.step,p.flags,x,y)
    shoot(b,p.mode,p.sprite,p.c,p.n,p.l,p.v1,p.v2,p.angle,p.step,p.flags,ex,x,y)
end
function H.cancel(b)
    local s=b.th06
    for i=1,POOL_SIZE do local p=s.pool[i];if alive(p) then object.Del(p) end end
    for i=1,64 do local l=s.laser_pool[i];if alive(l) then H.fade_laser(l,false) end end
    H.trace(b,"cancel")
end
function H.erase(b)
    local a=b.th06_actor
    a.dead=true
    if a.main then b.hp=0 else object.RawDel(b) end
    error(STOP,0)
end
function H.clear_helpers(b)
    local s=b.th06
    for i=2,#s.actors do local a=s.actors[i];if not a.dead and IsValid(a.object) then H.kill_actor(a) end end
end
function H.change_colour(p,c)
    local shape=SHAPES[p.th06_sprite]
    bullet.ChangeImage(p,shape[1],colour(p.th06_sprite,c))
    p.th06_colour=c;p.a,p.b,p.rect=shape[4]/2,shape[4]/2,true
end

-- 所有激光共用原作 64 个槽位；源点、起止偏移、长度、速度和旋转均可独立变化。
class["原作直线激光"] = Class(laser, {
    init=function(l,s,sprite,c,x,y,angle,speed,startoff,endoff,length,width,prepare,active,fade,hitstart,hitend,flags)
        laser.init(l,colour(3,c),x,y,-angle*DEG,0,max(0,endoff-startoff),0,width,0,0)
        l.bound=false;l.th06_owner=s
        l.th06_origin_x,l.th06_origin_y=x,y
        l.th06_angle,l.th06_speed=angle,speed
        l.th06_startoff,l.th06_endoff,l.th06_length=startoff,endoff,length
        l.th06_width,l.th06_prepare,l.th06_active=width,prepare,active
        l.th06_fade,l.th06_hitstart,l.th06_hitend=fade,hitstart,hitend
        l.th06_flags,l.th06_timer,l.th06_state=flags,0,prepare==0 and 1 or 0
        l.th06_sprite=sprite
    end,
    frame=function(l)
        if l.th06_owner.time_stopped then return end
        local t,state=l.th06_timer,l.th06_state
        l.th06_endoff=l.th06_endoff+l.th06_speed
        if l.th06_length<l.th06_endoff-l.th06_startoff then l.th06_startoff=l.th06_endoff-l.th06_length end
        l.th06_startoff=max(0,l.th06_startoff)
        local len=max(0,l.th06_endoff-l.th06_startoff)
        local w,alpha,hit=l.th06_width,1,false
        if state==0 then
            if band(l.th06_flags,1)~=0 then alpha=min(1,t/max(1,l.th06_prepare))
            else w=t>l.th06_prepare-min(l.th06_prepare,30) and t*l.th06_width/max(1,l.th06_prepare) or 1.2 end
            hit=t>=l.th06_hitstart
            if t>=l.th06_prepare then state=1;t=0 end
        end
        if state==1 then
            w,alpha,hit=l.th06_width,1,true
            if t>=l.th06_active then state=2;t=0 end
        end
        if state==2 then
            if l.th06_fade==0 or t>=l.th06_fade then retire(l);return end
            w=l.th06_width*(1-t/l.th06_fade)
            hit=t<l.th06_hitend
        end
        l.th06_draw_width,l.th06_draw_alpha=w,alpha
        l.th06_draw_length,l.th06_draw_start=len,l.th06_startoff
        -- 原作预热/收束阶段把宽度错写到长度，仅中点有很短的一段判定。
        local start=l.th06_startoff
        if state~=1 and band(l.th06_flags,1)==0 then start=start+(len-w/2)/2;len=w/2 end
        l.rot=-l.th06_angle*DEG
        l.x=l.th06_origin_x+cos(l.th06_angle)*start
        l.y=l.th06_origin_y-sin(l.th06_angle)*start
        l.l1,l.l2,l.l3,l.w,l.alpha,l.colli=0,len,0,l.th06_width/2,1,hit
        laser.frame(l)
        l.th06_state,l.th06_timer=state,t+1
    end,
    render=function(l)
        local x,y,len,w,alpha=l.x,l.y,l.l2,l.w,l.alpha
        local start=l.th06_draw_start or l.th06_startoff
        l.x=l.th06_origin_x+cos(l.th06_angle)*start;l.y=l.th06_origin_y-sin(l.th06_angle)*start
        l.l2=l.th06_draw_length or 0;l.w=(l.th06_draw_width or 1.2)*7/16;l.alpha=l.th06_draw_alpha or 1
        laser.render(l)
        l.x,l.y,l.l2,l.w,l.alpha=x,y,len,w,alpha
    end,
})
function H.fade_laser(l,collide)
    if alive(l) and l.th06_state<2 then l.th06_state,l.th06_timer=2,0 end
    if not collide then l.th06_hitend=0 end
end
function H.laser(b,aim,sprite,c,angle,speed,startoff,endoff,length,width,prepare,active,fade,hitstart,hitend,flags)
    local a,s=b.th06_actor,b.th06
    if aim then angle=angle+H.player_angle(b) end
    for i=1,64 do
        if not alive(s.laser_pool[i]) then
            local l=New(class["原作直线激光"],s,sprite,c,b.x+a.offsetx,b.y-a.offsety,angle,speed,startoff,endoff,length,width,prepare,active,fade,hitstart,hitend,flags)
            s.laser_pool[i]=l;a.lasers[a.laser_index]=l
            H.trace(b,"laser",aim,sprite,c,angle,speed,startoff,endoff,length,width,prepare,active,fade,hitstart,hitend,flags)
            return l
        end
    end
    a.lasers[a.laser_index]=nil
end
function H.rotate_laser(b,index,angle,aim)
    local l=b.th06_actor.lasers[index]
    if alive(l) then l.th06_angle=aim and (atan2(-(player.y-l.th06_origin_y),player.x-l.th06_origin_x)+angle) or (l.th06_angle+angle) end
end
function H.offset_laser(b,index,x,y)
    local l=b.th06_actor.lasers[index]
    if alive(l) then l.th06_origin_x,l.th06_origin_y=b.x+x,b.y-y end
end
function H.laser_test(b,index) return alive(b.th06_actor.lasers[index]) and 0 or 1 end
function H.laser_cancel(b,index)
    local l=b.th06_actor.lasers[index]
    if alive(l) then H.fade_laser(l,true) end
end

function H.new_actor(s,b,stage,sub,main,meta)
    if not main then meta.shot=(s.actors[1] and s.actors[1].meta.shot) or 0 end
    local a={object=b,main=main,meta=meta,stage=stage,sub=sub,phase=0,interval=0,interval_tick=0,
        offsetx=0,offsety=0,z=0,angle=0,speed=0,angular=0,accel=0,axisx=0,axisy=0,mode="axis",
        rank=stage==7 and 18 or 32,rank_lo=-.5,rank_hi=.5,rank_n1_lo=0,rank_n1_hi=0,rank_n2_lo=0,rank_n2_hi=0,
        extra={0,0,0,0,0,0,0,0},lasers={},laser_index=0,damageable=true,collidable=true,interactable=true,
        context=H.ctx(main and meta.epoch or 0),bounds=main and meta.bounds or nil}
    if main and b.th06_previous_context then
        for k,value in pairs(b.th06_previous_context) do if k~="time" and k~="epoch" then a.context[k]=value end end
    end
    b.th06,b.th06_actor=s,a;b.vx,b.vy=0,0
    for i=1,256 do
        if not s.actors[i] or s.actors[i].dead or not IsValid(s.actors[i].object) then s.actors[i]=a;a.slot=i;break end
    end
    a.co=coroutine.create(function() P[stage][sub](b,a.context) end)
    return a
end
function H.run_actor(a)
    if a.dead or coroutine.status(a.co)=="dead" then return end
    local ok,err=coroutine.resume(a.co)
    if not ok and err~=STOP then error(err,0) end
end
function H.kill_actor(a)
    if a.dead then return end
    if a.death then
        local fn=a.death;a.death=nil;a.object.hp=max(1,a.object.hp)
        local prior=a.context;a.context={}
        for k,value in pairs(prior) do a.context[k]=value end
        a.context.time,a.context.epoch=0,0;a.death_life=0
        a.co=coroutine.create(function() fn(a.object,a.context) end)
        H.run_actor(a)
    else a.dead=true;object.RawDel(a.object) end
end
class["原作使魔"] = Class(enemy, {
    init=function(b,s,stage,sub,x,y,z,hp)
        enemy.init(b,15,max(1,hp),false,false,false)
        b.bound=false;b.x,b.y=x-192,224-y
        local a=H.new_actor(s,b,stage,sub,false,{epoch=0,threshold=0})
        a.z=z;a.initial_life=hp
        H.run_actor(a)
        if not a.dead then H.actor_post(a,false) end
        if hp>=0 then b.hp=hp end -- SpawnEnemy 在首次 RunEcl 之后再次覆盖正生命值。
    end,
    frame=function(b)
        if b.th06_actor and not b.th06_actor.dead then
            if b._wisys then b._wisys:frame() end
        end
    end,
    render=function(b)
        local a=b.th06_actor
        if a and not a.invisible and not a.dead then
            if a.clone then b._wisys:render(b.dmgt,b.dmgmaxt) else enemy.render(b) end
        end
    end,
    kill=function(b) object.Preserve(b);H.kill_actor(b.th06_actor) end,
    del=function(b) b.th06_actor.dead=true end,
})
function H.spawn(b,stage,sub,x,y,z,hp)
    local s=b.th06;local count=0
    for _,a in ipairs(s.actors) do if not a.dead then count=count+1 end end
    if count>=256 then return end
    H.trace(b,"spawn",stage,sub,x,y,z,hp)
    return New(class["原作使魔"],s,stage,sub,x,y,z,hp)
end
function H.actor_motion(a)
    local b=a.object
    b.x,b.y=b.x+a.axisx,b.y-a.axisy
    H.clamp(b)
    if not a.main then
        local inside=b.x>=-224 and b.x<=224 and b.y>=-256 and b.y<=256
        if inside then a.entered=true elseif a.entered then a.dead=true;object.RawDel(b);return end
    end
end
function H.actor_post(a,count_phase)
    local b=a.object
    if a.mode=="velocity" then
        a.angle=normal_angle(a.angle+a.angular);a.speed=a.speed+a.accel
        a.axisx,a.axisy=cos(a.angle)*a.speed,sin(a.angle)*a.speed
    elseif a.mode=="interp" and a.move then
        local m=a.move;m.t=m.t+1
        local u=min(1,m.t/m.n);local e=u
        if m.ease==1 then e=1-(1-u)^2 elseif m.ease==2 then e=1-(1-u)^4 elseif m.ease==3 then e=u*u elseif m.ease==4 then e=u^4 end
        a.axisx,a.axisy=m.x+m.dx*e-b.x,-(m.y+m.dy*e-b.y)
        a.angle=atan2(a.axisy,a.axisx)
        if m.t>=m.n then
            a.mode="axis";b.x,b.y=m.x+m.dx,m.y+m.dy;a.axisx,a.axisy=0,0
        end
    end
    H.clamp(b)
    if a.interval>0 then
        a.interval_tick=a.interval_tick+1
        if a.interval_tick>=a.interval then H.fire(b);a.interval_tick=0 end
    end
    local v=a.context
    if v.repeat_func then H.extra(b,v,v.repeat_func,0,true) end
    if count_phase~=false then a.phase=a.phase+1 end
    local visible=not a.invisible and a.interactable
    b._a=(a.invisible or (a.bat_timer or 0)>0) and 0 or 255
    b.DMG_factor=a.damageable and visible and 1 or 0
    b._colli=a.collidable and visible
    SetAttr(b,"colli",b._colli and b.x>=-224 and b.x<=224 and b.y>=-256 and b.y<=256)
end
class["原作流程控制"] = Class(object, {
    init=function(o,b,meta)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY,false,false
        o.owner=b;o.s=b.th06
        H.new_actor(o.s,b,meta.stage,meta.sub,true,meta)
    end,
    frame=function(o)
        local s=o.s
        if s.closed or not IsValid(o.owner) then object.RawDel(o);return end
        -- EnemyManager 按槽顺序：先移动，再执行脚本，最后更新下帧速度。
        for i=1,256 do
            local a=s.actors[i]
            if a and not IsValid(a.object) then a.dead=true end
            if a and not a.dead and IsValid(a.object) then
                H.actor_motion(a)
                if not a.dead then
                    if not a.main and a.life_threshold and a.life_threshold>=0 and a.object.hp<a.life_threshold and a.life_fn then
                        local fn=a.life_fn;a.object.hp=max(1,a.life_threshold);a.life_threshold=nil
                        local prior=a.context;a.context={}
                        for k,value in pairs(prior) do a.context[k]=value end
                        a.context.time,a.context.epoch=0,0
                        a.co=coroutine.create(function() fn(a.object,a.context) end)
                    elseif not a.main and a.object.hp<=0 then H.kill_actor(a) end
                    if a.main and a.timeout and a.phase>=a.timeout then a.object.hp=0 end
                    if not a.main and a.timeout and a.phase>=a.timeout and a.timeout_fn then
                        local fn=a.timeout_fn;a.timeout=nil
                        local prior=a.context;a.context={}
                        for k,value in pairs(prior) do a.context[k]=value end
                        a.context.time,a.context.epoch=0,0
                        a.co=coroutine.create(function() fn(a.object,a.context) end)
                    end
                    H.run_actor(a)
                    if not a.dead then H.actor_post(a) end
                end
            end
        end
    end,
})
function H.card_init(b,meta)
    b.th06={pool={},next_slot=1,lasers={},laser_pool={},actors={},rank_speed=0}
    b.th06_meta=meta;b.no_hp_render=false;b.NotPlayTimeOutSound=false
    if not b.th06_previous_context then
        b.x,b.y=meta.entry_x or 0,meta.entry_y or 128
    end
    b.th06_saved={a=b.a,b=b.b,rect=b.rect,DMG_factor=b.DMG_factor,_a=b._a}
    b.hp,b.maxhp,b._rank_hp_proxy=meta.hp,meta.hp,true
    if meta.hitbox then b.a,b.b,b.rect=meta.hitbox[1]/2,meta.hitbox[2]/2,true end
    b.th06_control=New(class["原作流程控制"],b,meta)
end
function H.card_del(b)
    local s=b.th06
    if not s then return end
    if b.th06_actor then
        b.th06_previous_context={}
        for k,value in pairs(b.th06_actor.context) do b.th06_previous_context[k]=value end
    end
    s.closed=true;s.time_stopped=false
    for _,a in ipairs(s.actors) do if not a.main and IsValid(a.object) then a.dead=true;object.RawDel(a.object) end end
    for _,p in pairs(s.pool) do if alive(p) then object.Del(p) end end
    for _,l in pairs(s.laser_pool) do if alive(l) then object.Del(l) end end
    if b.th06_control and IsValid(b.th06_control) then object.RawDel(b.th06_control) end
    local saved=b.th06_saved
    if saved then b.a,b.b,b.rect,b.DMG_factor,b._a=saved.a,saved.b,saved.rect,saved.DMG_factor,saved._a end
    b._colli=true;b.th06=nil;b.th06_actor=nil;b.th06_control=nil;b.th06_meta=nil
end
function H.sprite(b,id)
    local a=b.th06_actor;a.sprite=id
    if not a.main and a.stage==7 and id>=160 and id<=164 and not a.clone then
        a.clone=true
        local a0,b0,rect=b.a,b.b,b.rect
        b._wisys=BossWalkImageSystem(b)
        b._wisys:SetImageInList("Flandre")
        b.a,b.b,b.rect=a0,b0,rect
    end
end
function H.set_velocity(p,a,v)
    velocity(p,a,v)
    if band(p.th06_flags,16)~=0 then p.th06_vx,p.th06_vy=p.vx,p.vy else p.th06_vx,p.th06_vy=nil,nil end
end
function H.bat(b)
    local a=b.th06_actor
    if (player.nextspell or 0)>0 then a.bat_timer=60;a.interactable=false
    elseif (a.bat_timer or 0)>0 then
        a.bat_timer=a.bat_timer-1
        if a.bat_timer==0 then a.interactable=true end
    end
end
function H.extra(b,v,id,arg,repeated)
    local s,a=b.th06,b.th06_actor
    H.trace(b,repeated and "repeat_extra" or "extra",id,arg)
    if id==0 then
        for i=1,POOL_SIZE do
            local p=s.pool[i]
            if alive(p) then
                H.change_colour(p,15)
                if arg==0 then p.th06_speed=0;p.vx,p.vy=0,0;p.th06_vx,p.th06_vy=0,0
                else
                    local dir=ran:Float(-PI,PI)
                    p.th06_flags=bit.bor(p.th06_flags,16);p.th06_ex={220,.01,dir};p.th06_tick=0
                    p.th06_ax,p.th06_ay=cos(dir)*.01,-sin(dir)*.01
                    p.th06_vx,p.th06_vy=p.vx,p.vy
                end
            end
        end
    elseif id==1 then
        H.fire(b,b.x+ran:Float(-arg/2,arg/2),b.y-ran:Float(-arg*.75/2,arg*.75/2))
    elseif id==2 then
        if v.i2>=v.i3 then v.repeat_func=nil;return end
        if v.i2==0 then
            a.star_origin={b.x,b.y,player.x,player.y}
            a.star_angle=ran:Float(-PI,PI)
        end
        if v.i2%30==0 then a.star_angle=normal_angle(a.star_angle+4*PI/5) end
        if v.i2%6==0 and a.pattern then
            local p=a.pattern;local q=v.i2/v.i3;local origin=a.star_origin
            local x=origin[1]+(origin[3]-origin[1])*q*.1
            local y=origin[2]+(origin[4]-origin[2])*q*.1
            local u=(v.i2%30)/30;q=q+.5
            local speed=p.v1;p.angle=PI/3*q
            for j=0,4 do
                local a1,a2=a.star_angle+j*4*PI/5,a.star_angle+(j+1)*4*PI/5
                local px=x+(cos(a1)*(1-u)+cos(a2)*u)*v.f3
                local py=y-(sin(a1)*(1-u)+sin(a2)*u)*v.f3
                p.v1=speed+ran:Float(0,p.v2);H.fire(b,px,py);p.v1=speed;p.angle=p.angle-PI/6*q
            end
            PlaySound("tan00",.1,b.x/256,false)
        end
        v.i2=v.i2+1
    elseif id==3 then
        local routes={{0,3,1},{2,3,4},{1,4,0},{4,2,3}}
        local r=routes[(a.meta.shot or 0)+1];v.i1,v.i2,v.i3=r[1],r[2],r[3]
    elseif id==4 then
        if arg<2 then s.time_stopped=arg==1 else
            local count=0
            for i=1,POOL_SIZE do
                local p=s.pool[i]
                if alive(p) and p.th06_h>=30 and p.th06_colour~=5 and ran:Int(0,3)==0 then
                    H.change_colour(p,5)
                    local dx,dy=p.x-player.x,p.y-player.y
                    local dir=ran:Float(0,2*PI)
                    if dx*dx+dy*dy<=128^2 then dir=dir+atan2(-dy,dx)+PI/2 end
                    H.set_velocity(p,dir,p.th06_speed)
                    count=count+1;if count==52 then break end
                end
            end
        end
        v.i2=0
    elseif id==5 then
        if v.i2%9==0 then
            local k=floor(v.i2/9)
            local dx,dy=player.x-b.x,-(player.y-b.y);local length=sqrt(dx*dx+dy*dy)
            local scale=length>0 and ((k%2==1 and -256 or 256)/length) or 0
            local mx,my=dx*scale,dy*scale
            local bx,by=dx*(.5-k*.5/9)+mx,dy*(.5-k*.5/9)+my
            mx,my=-mx,-my
            mx,my=mx*cos(PI/4)+my*sin(PI/4),-mx*sin(PI/4)+my*cos(PI/4)
            local p={mode="aim",sprite=8,c=3,n=3,l=1,v1=2,v2=1,angle=0,step=PI/6,flags=0}
            for _=1,9 do
                mx,my=mx*cos(-PI/18)+my*sin(-PI/18),-mx*sin(-PI/18)+my*cos(-PI/18)
                H.fire(b,b.x+bx+mx,b.y-by-my,p)
            end
            PlaySound("tan00",.1,b.x/256,false)
        end
        v.i2=v.i2+1
    elseif id==6 then
        -- 蝙蝠翼是无判定的 ANM 粒子；行走图仍由 LuaSTG 的角色图系统绘制。
    elseif id==7 then star(b)
    elseif id==8 then v.i3=seed_small(b)
    elseif id==9 or id==11 then awaken(b,id==11)
    elseif id==10 then H.bat(b)
    elseif id==12 then
        for i=0,7 do
            local l=a.lasers[i]
            if alive(l) then H.fire(b,b.x+cos(l.th06_angle)*64,b.y+sin(l.th06_angle)*64) end
        end
    elseif id==13 then
        if v.i3%6==0 and a.pattern then
            local p=a.pattern;local angle=v.f2
            for _=1,arg do
                p.angle=angle+v.f1
                H.fire(b,cos(angle)*v.f3,-sin(angle)*v.f3)
                angle=angle+2*PI/arg
            end
        end
        v.i3=v.i3+1
    elseif id==14 then
        v.i3=0
        for i=0,7 do
            local l=a.lasers[i]
            if alive(l) then
                local along=l.th06_startoff
                while along<l.th06_endoff do
                    H.fire(b,l.th06_origin_x+cos(l.th06_angle)*along,l.th06_origin_y-sin(l.th06_angle)*along)
                    along=along+48
                end
                v.i3=v.i3+1
            end
        end
    elseif id==15 then
        local count=0
        for i=1,POOL_SIZE do
            local large=s.pool[i]
            if alive(large) and large.th06_h>=30 then
                count=count+1
                local biga=atan2(-(large.y-b.y),large.x-b.x)
                for j=1,POOL_SIZE do
                    local p=s.pool[j]
                    if alive(p) and p.th06_h<30 and p.th06_speed==0 and (p.x-large.x)^2+(p.y-large.y)^2<64^2 then
                        local angle=(atan2(-(p.y-b.y),p.x-b.x)-biga)*2.2+biga
                        p.th06_flags=bit.bor(p.th06_flags,16);p.th06_tick=0;p.th06_ex={120,.01,angle}
                        p.th06_speed=.01;p.th06_angle=angle;p.th06_ax,p.th06_ay=cos(angle)*.01,-sin(angle)*.01
                        p.th06_vx,p.th06_vy=0,0;H.change_colour(p,(p.th06_colour or 1)+1)
                    end
                end
            end
        end
        H.bat(b);v.i3=count
    elseif id==16 then
        local life=a.phase>=7200 and 0 or H.life(b)
        if arg==0 then v.f3=2-life/6000;v.c1=trunc(life*240/6000)+40
        else
            local range=320-life*160/6000;v.f2=ran:Float(192-range/2,192+range/2)
            range=128-life*64/6000;v.f3=ran:Float(96-range/2,96+range/2)
        end
    else error("未实现的原作特殊攻击 "..tostring(id)) end
end

-- TH06_KERNEL_END


-- TH06_EXPANDED_START

-- 此段由 tools/th32-tests/expand.py 从原生二进制离线展开；不要在游戏里载入原始 ECL。

-- ecldata1.ecl SHA-256：9d9a40e9f7e3ab9346d3874438134659cacf9d34f4aff57b96b4be4ea85b99d7

-- ecldata2.ecl SHA-256：aa89aaaf13264d909bbaaa24f2af263ae1a58145ad5cc33fcea5eb9cb920c43e

-- ecldata3.ecl SHA-256：44dfcaa737b7d4b3d1275655627e15a9d5b7710fc75a0885fb39d8c9485056d6

-- ecldata4.ecl SHA-256：92695da99b651da492f4fb7c7497b5c8ed8105a23370cc4529901609077c8b60

-- ecldata5.ecl SHA-256：50b5c4777a56910148466c7e5ea1c8dadc126e706420604d52421a49bf861d1b

-- ecldata6.ecl SHA-256：4a4d4e5bf7ff79ab49b918267130b42308b3a5565cc892dc0e636b8b667740e5

-- ecldata7.ecl SHA-256：fb900c7e54b1f5d0c36a2e09986bef8f8fde002ca7b5005d12e3aaec7e856392

-- 第 1 面，原生 Sub4，起始 0x4b4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f3=0.019999999552965164
        a.extra={-1,-1,-1,-1,0.019999999552965164,-999.0,-1.0,-1.0}
        H.pattern(b,4,0,v.i0,28,1,0.0,0.0,v.f0,0.0,21)
        return
    end
    P[1][4]=B.part1
end

-- 第 1 面，原生 Sub5，起始 0x5cc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=ran:Float(0,3.0)
        v.f1=(v.f1)+(0.5)
        v.f0=ran:Float(0,6.2831854820251465)
        v.f0=(v.f0)-(3.1415927410125732)
        H.pattern(b,4,0,v.i0,24,1,v.f1,0.699999988079071,v.f0,0.0,5)
        v.f1=ran:Float(0,3.0)
        v.f1=(v.f1)+(0.5)
        v.f0=ran:Float(0,6.2831854820251465)
        v.f0=(v.f0)-(3.1415927410125732)
        H.pattern(b,4,2,v.i0,24,1,v.f1,0.699999988079071,v.f0,0.0,5)
        return
    end
    P[1][5]=B.part1
end

-- 第 1 面，原生 Sub6，起始 0x804。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        a.bounds=nil
        a.collidable=false
        a.damageable=false
        H.sprite(b,128)
        H.wait(b,v,40)
        H.move_to(b,120,192.0,-64.0,0.0,3)
        H.wait(b,v,160)
        H.erase(b)
    end
    P[1][6]=B.part1
end

-- 第 1 面，原生 Sub7，起始 0x8c4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        a.bounds=nil
        H.sprite(b,128)
        H.move_to(b,60,192.0,-64.0,0.0,3)
        H.wait(b,v,60)
        H.erase(b)
    end
    P[1][7]=B.part1
end

-- 第 1 面，原生 Sub8，起始 0x944。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.collidable=false
        a.death=P[1][6]
        a.life_threshold=500
        a.life_fn=P[1][9]
        a.timeout=1440;a.phase=0
        a.timeout_fn=P[1][7]
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        H.position(b,192.0,-32.0,0.0);H.clamp(b)
        b.a,b.b,b.rect=(48.0)/2,(56.0)/2,true
        H.move_to(b,60,320.0,128.0,0.0,1)
        H.wait(b,v,60)
        a.damageable=true
        a.collidable=true
        H.wait(b,v,80)
        H.wait(b,v,100)
        H.wait(b,v,130)
        H.wait(b,v,160)
        H.pattern(b,3,1,6,16,7,2.0,1.0,0.0,0.0,9)
        H.sprite(b,133)
        H.wait(b,v,192)
        v.i0=3
        v.f0=2.0
        v.c0=2
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,202)
        H.move_to(b,60,192.0,64.0,0.0,1)
        v.f1=1.7000000476837158
        H.wait(b,v,262)
        H.call(b,v,P[1][4],6,0.0)
        H.sprite(b,133)
        H.wait(b,v,270)
        H.call(b,v,P[1][4],2,0.06544984877109528)
        H.wait(b,v,278)
        H.call(b,v,P[1][4],10,0.13089969754219055)
        H.wait(b,v,286)
        H.call(b,v,P[1][4],13,0.19634954631328583)
        H.wait(b,v,294)
        H.call(b,v,P[1][4],14,0.2617993950843811)
        H.wait(b,v,324)
        H.sprite(b,134)
        H.wait(b,v,384)
        H.move_to(b,60,64.0,96.0,0.0,1)
        H.wait(b,v,394)
        H.wait(b,v,414)
        H.pattern(b,3,1,10,16,7,2.0,1.0,0.0,0.0,9)
        H.wait(b,v,444)
        H.pattern(b,3,1,13,16,7,2.0,1.0,0.0,0.0,9)
        H.wait(b,v,476)
        H.wait(b,v,516)
        H.wait(b,v,526)
        H.move_to(b,60,192.0,80.0,0.0,1)
        v.f1=1
        H.wait(b,v,586)
        H.call(b,v,P[1][5],6,0.0)
        H.sprite(b,133)
        H.wait(b,v,594)
        H.call(b,v,P[1][5],2,-0.06544984877109528)
        H.wait(b,v,602)
        H.call(b,v,P[1][5],10,-0.13089969754219055)
        H.wait(b,v,610)
        H.call(b,v,P[1][5],13,-0.19634954631328583)
        H.wait(b,v,618)
        H.call(b,v,P[1][5],14,-0.2617993950843811)
        v.f0=(v.f0)+(0.5)
        H.wait(b,v,648)
        H.sprite(b,134)
        H.wait(b,v,708)
        H.move_to(b,60,320.0,96.0,0.0,1)
        H.wait(b,v,718)
        H.wait(b,v,738)
        H.pattern(b,3,1,6,16,7,2.0,1.0,0.0,0.0,9)
        H.wait(b,v,768)
        H.pattern(b,3,1,2,16,7,2.0,1.0,0.0,0.0,9)
        H.sprite(b,133)
        H.wait(b,v,800)
        H.wait(b,v,840)
        H.sprite(b,134)
        v.f0=(v.f0)+(0.5)
        v.c0=v.c0-1
        if v.c0>0 then v.time=192;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,850)
        H.move_to(b,60,192.0,-64.0,0.0,1)
        H.wait(b,v,910)
        H.erase(b)
    end
    P[1][8]=B.part1
end

-- 第 1 面，原生 Sub9，起始 0x11ac。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",0)
        a.damageable=false
        a.bounds={32.0,48.0,352.0,144.0}
        a.phase=0
        a.timeout=1320;a.phase=0
        a.timeout_fn=P[1][6]
        H.move_to(b,120,192.0,96.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        a.muted=true
        H.pattern(b,3,0,6,48,1,2.799999952316284,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,25,true)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.laser_index=0
        H.laser(b,false,0,6,0.39269909262657166,0.0,0.0,500.0,500.0,32.0,30,120,16,30,14,0)
        a.laser_index=1
        H.laser(b,false,0,6,2.7488934993743896,0.0,0.0,500.0,500.0,32.0,30,120,16,30,14,0)
        H.wait(b,v,150)
        v.c0=120
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,151)
        H.rotate_laser(b,0,0.008267348632216454,false)
        H.rotate_laser(b,1,-0.008267348632216454,false)
        v.c0=v.c0-1
        if v.c0>0 then v.time=150;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,211)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,120,a.angle,a.speed,1)
        H.wait(b,v,331)
        v.time=120;return B.part2(b,v)
    end
    P[1][9]=B.part1
end

-- 第 1 面，原生 Sub11，起始 0x15aa。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        a.collidable=true
        a.death=P[1][16]
        H.sprite(b,134)
        if not a.main then b.hp=7000 end
        a.phase=0
        a.life_threshold=900
        a.life_fn=P[1][22]
        a.timeout=2100;a.phase=0
        a.timeout_fn=P[1][22]
        a.bounds={32.0,48.0,352.0,144.0}
        H.wait(b,v,20)
        H.wait(b,v,40)
        H.wait(b,v,100)
        H.call(b,v,P[1][12],0,0.0)
        H.wait(b,v,3100)
        H.erase(b)
    end
    P[1][11]=B.part1
end

-- 第 1 面，原生 Sub12，起始 0x171a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,12)
        H.pattern(b,1,3,2,1,10,6.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,20)
        H.pattern(b,1,3,1,2,10,6.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,28)
        H.pattern(b,1,3,2,2,10,6.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,36)
        H.pattern(b,1,3,1,3,10,6.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,44)
        H.pattern(b,1,3,2,3,10,6.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,52)
        H.pattern(b,1,3,1,4,10,6.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,60)
        H.pattern(b,1,3,2,5,10,6.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,180)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][13],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][14],0,0.0) end
        H.call(b,v,P[1][15],0,0.0)
    end
    P[1][12]=B.part1
end

-- 第 1 面，原生 Sub13，起始 0x1d06。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,60)
        H.pattern(b,3,1,6,24,2,4.0,1.0,0.0,0.13089969754219055,4)
        H.wait(b,v,68)
        H.pattern(b,3,0,5,24,1,3.0,1.0,0.0,0.0,2)
        H.wait(b,v,76)
        H.pattern(b,3,1,6,24,2,2.0,1.0,0.0,-0.13089969754219055,4)
        H.wait(b,v,84)
        H.pattern(b,3,0,5,24,1,3.0,1.0,0.0,0.0,2)
        H.wait(b,v,92)
        H.pattern(b,3,1,6,32,2,4.0,1.0,0.0,0.13089969754219055,4)
        H.wait(b,v,100)
        H.pattern(b,3,0,5,24,1,3.0,1.0,0.0,0.0,2)
        H.wait(b,v,108)
        H.pattern(b,3,1,6,32,2,2.0,1.0,0.0,-0.13089969754219055,4)
        H.wait(b,v,228)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][12],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][14],0,0.0) end
        H.call(b,v,P[1][15],0,0.0)
    end
    P[1][13]=B.part1
end

-- 第 1 面，原生 Sub14，起始 0x22f2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,80)
        H.pattern(b,1,2,2,5,16,5.0,1.0,0.0,0.06544984877109528,8)
        H.wait(b,v,110)
        H.pattern(b,3,1,6,48,3,4.0,1.0,0.0,0.06544984877109528,4)
        H.wait(b,v,200)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][13],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][12],0,0.0) end
        H.call(b,v,P[1][15],0,0.0)
    end
    P[1][14]=B.part1
end

-- 第 1 面，原生 Sub15，起始 0x24e2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        v.c0=16
        v.f0=1.0
        v.i0=H.random_int(2)
        v.cmp=(v.i0)-(0)
        if v.cmp==0 then v.time=2;return B.part5(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=-0.2617993950843811
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.pattern(b,1,1,10,3,3,v.f0,1.0,v.f1,0.06544984877109528,4)
        v.f0=(v.f0)+(0.25)
        v.f1=(v.f1)+(0.06544984877109528)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        v.time=4;return B.part7(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        v.f1=0.2617993950843811
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        H.pattern(b,1,1,10,3,3,v.f0,1.0,v.f1,0.06544984877109528,4)
        v.f0=(v.f0)+(0.25)
        v.f1=(v.f1)+(-0.06544984877109528)
        v.c0=v.c0-1
        if v.c0>0 then v.time=2;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][13],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][14],0,0.0) end
        H.call(b,v,P[1][12],0,0.0)
    end
    P[1][15]=B.part1
end

-- 第 1 面，原生 Sub16，起始 0x283e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        H.trace(b,"spell_end")
        a.collidable=true
        a.death=P[1][17]
        H.sprite(b,134)
        if not a.main then b.hp=7500 end
        a.phase=0
        a.life_threshold=800
        a.life_fn=P[1][23]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[1][23]
        a.interactable=true
        H.wait(b,v,200)
        a.damageable=true
        H.call(b,v,P[1][18],0,0.0)
        H.wait(b,v,3200)
        H.erase(b)
    end
    P[1][16]=B.part1
end

-- 第 1 面，原生 Sub17，起始 0x297e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.collidable=false
        a.damageable=false
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=0.6000000238418579;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.timeout=-1;a.phase=0
        a.life_threshold=-1
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.wait(b,v,4)
        H.wait(b,v,6)
        H.wait(b,v,8)
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        H.trace(b,"spell_end")
        if not a.main then b.hp=0 end
        H.wait(b,v,3010)
        H.erase(b)
    end
    P[1][17]=B.part1
end

-- 第 1 面，原生 Sub18，起始 0x2afe。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,12)
        H.pattern(b,1,1,10,7,8,3.0,1.0,0.0,0.09817477315664291,4)
        H.wait(b,v,20)
        H.laser(b,true,0,6,0.0,0.0,0.0,500.0,500.0,16.0,120,60,16,120,14,0)
        H.wait(b,v,28)
        H.laser(b,true,0,6,0.0,0.0,0.0,500.0,500.0,16.0,120,60,16,120,14,0)
        H.wait(b,v,36)
        H.laser(b,true,0,6,0.0,0.0,0.0,500.0,500.0,16.0,120,60,16,120,14,0)
        H.wait(b,v,44)
        H.laser(b,true,0,6,0.0,0.0,0.0,500.0,500.0,16.0,120,60,16,120,14,0)
        H.wait(b,v,52)
        H.laser(b,true,0,6,0.0,0.0,0.0,500.0,500.0,16.0,120,60,16,120,14,0)
        H.wait(b,v,60)
        H.laser(b,true,0,6,0.0,0.0,0.0,500.0,500.0,16.0,120,60,16,120,14,0)
        H.wait(b,v,124)
        H.wait(b,v,132)
        H.wait(b,v,140)
        H.wait(b,v,148)
        H.wait(b,v,156)
        H.wait(b,v,164)
        H.wait(b,v,224)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][19],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][20],0,0.0) end
        H.call(b,v,P[1][21],0,0.0)
    end
    P[1][18]=B.part1
end

-- 第 1 面，原生 Sub19，起始 0x2eaa。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,60)
        H.sprite(b,136)
        H.pattern(b,3,2,10,48,2,3.0,1.5,0.0,0.0,4)
        H.wait(b,v,90)
        H.pattern(b,3,0,10,32,2,3.5999999046325684,1.5,0.0,0.0,2)
        H.wait(b,v,120)
        H.pattern(b,3,2,10,48,2,3.0,1.5,0.0,0.0,4)
        H.wait(b,v,240)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][18],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][20],0,0.0) end
        H.call(b,v,P[1][21],0,0.0)
    end
    P[1][19]=B.part1
end

-- 第 1 面，原生 Sub20，起始 0x31a6。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,60)
        H.pattern(b,1,2,13,16,2,3.0,1.0,0.0,0.13089969754219055,8)
        H.sprite(b,136)
        H.wait(b,v,80)
        H.pattern(b,1,2,13,23,2,3.0,1.0,0.0,0.13089969754219055,8)
        H.wait(b,v,100)
        H.pattern(b,1,2,13,20,2,3.0,1.0,0.0,0.13089969754219055,8)
        H.wait(b,v,220)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][19],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][18],0,0.0) end
        H.call(b,v,P[1][21],0,0.0)
    end
    P[1][20]=B.part1
end

-- 第 1 面，原生 Sub21，起始 0x34a2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        v.c0=16
        v.f0=1.0
        v.i0=H.random_int(2)
        v.cmp=(v.i0)-(0)
        if v.cmp==0 then v.time=2;return B.part5(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=-0.7139983177185059
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.pattern(b,1,1,10,4,3,v.f0,1.0,v.f1,0.14279966056346893,4)
        v.f0=(v.f0)+(0.25)
        v.f1=(v.f1)+(0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        v.time=4;return B.part7(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        v.f1=0.7139983177185059
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        H.pattern(b,1,1,10,4,3,v.f0,1.0,v.f1,0.14279966056346893,4)
        v.f0=(v.f0)+(0.25)
        v.f1=(v.f1)+(-0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=2;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[1][19],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[1][20],0,0.0) end
        H.call(b,v,P[1][18],0,0.0)
    end
    P[1][21]=B.part1
end

-- 第 1 面，原生 Sub22，起始 0x37fe。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",1)
        a.damageable=false
        a.timeout=1500;a.phase=0
        a.phase=0
        H.move_to(b,120,192.0,96.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c1=2
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=16
        v.f0=1.0
        v.f1=-0.5711986422538757
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        H.pattern(b,1,1,5,1,3,v.f0,0.800000011920929,v.f1,0.06544984877109528,4)
        v.f0=(v.f0)+(0.20000000298023224)
        v.f1=(v.f1)+(0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.c0=16
        v.f0=1.0
        v.f1=0.5711986422538757
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        H.pattern(b,1,1,7,1,3,v.f0,0.800000011920929,v.f1,0.06544984877109528,4)
        v.f0=(v.f0)+(0.20000000298023224)
        v.f1=(v.f1)+(-0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=122;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.c0=16
        v.f0=1.0
        v.f1=-0.7853981852531433
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,126)
        H.pattern(b,1,1,6,1,3,v.f0,0.800000011920929,v.f1,0.06544984877109528,4)
        v.f0=(v.f0)+(0.20000000298023224)
        v.f1=(v.f1)+(0.15707963705062866)
        v.c0=v.c0-1
        if v.c0>0 then v.time=124;return B.part8(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,126)
        v.c0=16
        v.f0=1.0
        v.f1=0.7853981852531433
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,128)
        H.pattern(b,1,1,8,1,3,v.f0,0.800000011920929,v.f1,0.06544984877109528,4)
        v.f0=(v.f0)+(0.20000000298023224)
        v.f1=(v.f1)+(-0.15707963705062866)
        v.c0=v.c0-1
        if v.c0>0 then v.time=126;return B.part10(b,v) end
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,128)
        v.c1=v.c1-1
        if v.c1>0 then v.time=120;return B.part3(b,v) end
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,228)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,120,a.angle,a.speed,1)
        v.time=120;return B.part2(b,v)
    end
    P[1][22]=B.part1
end

-- 第 1 面，原生 Sub23，起始 0x3e6c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",2)
        a.damageable=false
        a.timeout=1500;a.phase=0
        a.phase=0
        H.move_to(b,120,192.0,96.0,0.0,1)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-1.0,1.0,-3,6,0,0
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.sprite(b,136)
        a.extra={40,1,-1,-1,1.5707963705062866,1.5,-1.0,-1.0}
        H.pattern(b,3,2,6,28,2,3.0,1.0,0.0,0.0,68)
        a.extra={40,1,-1,-1,-1.5707963705062866,1.5,-1.0,-1.0}
        H.pattern(b,3,2,6,28,2,3.0,1.0,0.11219973862171173,0.0,68)
        H.wait(b,v,180)
        a.extra={40,1,-1,-1,-1.5707963705062866,1.5,-1.0,-1.0}
        H.pattern(b,3,2,10,28,2,3.0,1.0,0.0,0.0,68)
        a.extra={40,1,-1,-1,1.5707963705062866,1.5,-1.0,-1.0}
        H.pattern(b,3,2,10,28,2,3.0,1.0,0.11219973862171173,0.0,68)
        H.wait(b,v,240)
        a.extra={40,1,-1,-1,1.5707963705062866,1.5,-1.0,-1.0}
        H.pattern(b,3,2,2,28,2,3.0,1.0,0.0,0.0,68)
        a.extra={40,1,-1,-1,-1.5707963705062866,1.5,-1.0,-1.0}
        H.pattern(b,3,2,2,28,2,3.0,1.0,0.11219973862171173,0.0,68)
        a.extra={60,1,-1,-1,0.0,-1.0,-1.0,-1.0}
        H.wait(b,v,300)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,120,a.angle,a.speed,1)
        a.extra={40,1,-1,-1,0.0,4.0,-1.0,-1.0}
        v.c1=2
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,300)
        v.c0=12
        v.f0=1.0
        v.f1=-0.5711986422538757
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,302)
        H.pattern(b,1,1,6,1,1,v.f0,0.0,v.f1,0.09817477315664291,132)
        v.f0=(v.f0)+(0.20000000298023224)
        v.f1=(v.f1)+(0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=300;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,302)
        v.c0=12
        v.f0=1.0
        v.f1=0.5711986422538757
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,304)
        H.pattern(b,1,1,6,1,1,v.f0,0.0,v.f1,0.09817477315664291,132)
        v.f0=(v.f0)+(0.20000000298023224)
        v.f1=(v.f1)+(-0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=302;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,304)
        v.c1=v.c1-1
        if v.c1>0 then v.time=300;return B.part3(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,304)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,364)
        v.time=120;return B.part2(b,v)
    end
    P[1][23]=B.part1
end

-- 第 2 面，原生 Sub14，起始 0xdb4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,40)
        v.c0=48
        v.f0=1.5
        v.f1=1.399999976158142
        v.f2=1.5707963705062866
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        H.pattern(b,4,4,10,4,2,v.f0,v.f1,v.f2,0.0,5)
        v.f0=(v.f0)+(0.05000000074505806)
        H.wait(b,v,41)
        v.f1=(v.f1)+(-0.019999999552965164)
        v.f2=(v.f2)+(0.13089969754219055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=40;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,41)
        return
    end
    P[2][14]=B.part1
end

-- 第 2 面，原生 Sub15，起始 0xf4c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,40)
        v.c0=48
        v.f0=1.5
        v.f1=1.399999976158142
        v.f2=1.5707963705062866
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        H.pattern(b,4,4,2,4,2,v.f0,v.f1,v.f2,0.0,5)
        v.f0=(v.f0)+(0.05000000074505806)
        H.wait(b,v,41)
        v.f1=(v.f1)+(-0.019999999552965164)
        v.f2=(v.f2)+(-0.13089969754219055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=40;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,41)
        return
    end
    P[2][15]=B.part1
end

-- 第 2 面，原生 Sub16，起始 0x10e4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,40)
        v.c0=16
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        a.extra={40,1,-1,-1,0.0,4.0,-1.0,-1.0}
        H.pattern(b,1,5,15,9,2,5.5,2.0,0.0,0.19634954631328583,132)
        H.pattern(b,1,5,6,9,1,3.5,2.0,0.0,0.19634954631328583,4)
        H.wait(b,v,50)
        v.c0=v.c0-1
        if v.c0>0 then v.time=40;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        return
    end
    P[2][16]=B.part1
end

-- 第 2 面，原生 Sub17，起始 0x12d4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=b.x+192
        a.interactable=false
        v.cmp=(v.f0)-(192.0)
        if v.cmp<0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,66)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,67)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,320.0)
        v.f0=(v.f0)+(32.0)
        H.wait(b,v,40)
        v.cmp=(v.f0)-(192.0)
        if v.cmp<0 then v.time=40;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        H.sprite(b,68)
        v.time=40;return B.part7(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        H.sprite(b,69)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        H.position(b,v.f0,96.0,0.0);H.clamp(b)
        a.interactable=true
        H.wait(b,v,80)
        return
    end
    P[2][17]=B.part1
end

-- 第 2 面，原生 Sub18，起始 0x1418。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.erase(b)
    end
    P[2][18]=B.part1
end

-- 第 2 面，原生 Sub19，起始 0x1454。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,10)
        H.move_to(b,60,192.0,-64.0,0.0,1)
        H.wait(b,v,70)
        H.erase(b)
    end
    P[2][19]=B.part1
end

-- 第 2 面，原生 Sub20，起始 0x1498。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.death=P[2][18]
        b.a,b.b,b.rect=(45.0)/2,(56.0)/2,true
        a.timeout=1920;a.phase=0
        a.timeout_fn=P[2][19]
        H.sprite(b,64)
        H.position(b,192.0,-32.0,0.0);H.clamp(b)
        H.move_to(b,60,192.0,96.0,0.0,1)
        H.wait(b,v,60)
        a.damageable=true
        H.wait(b,v,70)
        H.wait(b,v,80)
        H.wait(b,v,90)
        H.wait(b,v,130)
        v.c1=8
        v.i3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,130)
        if (v.i3)==(0) then H.call(b,v,P[2][14],0,0.0) end
        if (v.i3)==(1) then H.call(b,v,P[2][15],0,0.0) end
        if (v.i3)==(2) then H.call(b,v,P[2][16],0,0.0) end
        v.i3=(v.i3)+(1)
        v.cmp=(v.i3)-(3)
        if v.cmp<0 then v.time=130;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,130)
        v.i3=0
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,130)
        H.call(b,v,P[2][17],0,0.0)
        H.wait(b,v,210)
        v.c1=v.c1-1
        if v.c1>0 then v.time=130;return B.part2(b,v) end
    end
    P[2][20]=B.part1
end

-- 第 2 面，原生 Sub22，起始 0x185c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.collidable=true
        if not a.main then b.hp=10000 end
        a.phase=0
        a.life_threshold=1500
        a.life_fn=P[2][30]
        a.timeout=1500;a.phase=0
        a.timeout_fn=P[2][30]
        H.wait(b,v,20)
        a.damageable=true
        H.wait(b,v,30)
        H.wait(b,v,40)
        H.wait(b,v,50)
        v.c3=0
        H.wait(b,v,70)
        H.call(b,v,P[2][23],0,0.0)
    end
    P[2][22]=B.part1
end

-- 第 2 面，原生 Sub23，起始 0x19c4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.move_to(b,40,192.0,96.0,0.0,1)
        v.f1=0.06544984877109528
        v.c0=3
        H.wait(b,v,41)
        H.sprite(b,131)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-0.5,1.0,0,2,0,0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,41)
        v.f0=(H.player_angle(b))+(0.0)
        H.pattern(b,2,5,6,1,1,5.0,1.0,v.f0,v.f1,4)
        H.wait(b,v,43)
        H.pattern(b,2,5,6,2,1,4.5,1.0,v.f0,v.f1,4)
        H.wait(b,v,45)
        H.pattern(b,2,5,6,3,1,4.0,1.0,v.f0,v.f1,4)
        H.wait(b,v,47)
        H.pattern(b,2,5,6,4,1,3.5,1.0,v.f0,v.f1,4)
        H.wait(b,v,49)
        H.pattern(b,2,5,6,5,1,3.0,1.0,v.f0,v.f1,4)
        H.wait(b,v,51)
        H.pattern(b,2,5,6,6,1,2.5,1.0,v.f0,v.f1,4)
        H.pattern(b,4,3,6,32,2,3.0,1.0,v.f0,v.f1,4)
        v.f1=(v.f1)+(0.06544984877109528)
        H.wait(b,v,111)
        v.c0=v.c0-1
        if v.c0>0 then v.time=41;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,111)
        H.call(b,v,P[2][24],0,0.0)
    end
    P[2][23]=B.part1
end

-- 第 2 面，原生 Sub24，起始 0x1c9c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=3.0;a.mode="velocity"
        H.wait(b,v,1)
        v.c0=3
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-0.5,0.30000001192092896,0,4,0,0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,21)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        H.move_dir(b,60,a.angle,a.speed,1)
        a.extra={60,1,-1,-1,0.0,4.0,-1.0,-1.0}
        H.pattern(b,3,1,6,24,2,2.0,1.0,0.0,0.0,4)
        v.i0=(v.c3)*(3)
        H.wait(b,v,41)
        H.pattern(b,3,5,15,32,1,5.0,1.0,0.0,0.0,132)
        H.wait(b,v,61)
        H.pattern(b,3,1,6,16,2,2.0,1.0,0.0,0.0,4)
        v.i0=(v.c3)*(5)
        H.wait(b,v,101)
        v.c0=v.c0-1
        if v.c0>0 then v.time=1;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,101)
        v.c3=(v.c3)+(1)
        H.call(b,v,P[2][23],0,0.0)
    end
    P[2][24]=B.part1
end

-- 第 2 面，原生 Sub25，起始 0x2028。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        a.damageable=false
        a.collidable=true
        a.death=P[2][28]
        if not a.main then b.hp=13000 end
        a.phase=0
        a.life_threshold=3200
        a.life_fn=P[2][31]
        a.timeout=3000;a.phase=0
        a.timeout_fn=P[2][31]
        a.interactable=true
        v.c3=0
        H.wait(b,v,200)
        a.damageable=true
        H.call(b,v,P[2][26],0,0.0)
        H.wait(b,v,3200)
        H.erase(b)
    end
    P[2][25]=B.part1
end

-- 第 2 面，原生 Sub26，起始 0x217c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=3.0;a.mode="velocity"
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        H.move_dir(b,60,a.angle,a.speed,1)
        v.c0=8
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=(v.c3)+(20)
        H.pattern(b,3,1,6,v.i0,2,4.0,1.0,0.0,0.0,4)
        H.wait(b,v,10)
        H.pattern(b,5,0,5,8,1,1.2999999523162842,1.0,0.0,0.0,5)
        H.wait(b,v,20)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,20)
        H.call(b,v,P[2][27],0,0.0)
    end
    P[2][26]=B.part1
end

-- 第 2 面，原生 Sub27，起始 0x234c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=3.0;a.mode="velocity"
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        H.move_dir(b,60,a.angle,a.speed,1)
        v.c0=3
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.laser(b,true,0,6,0.0,4.0,0.0,0.0,192.0,6.0,0,9999,30,0,30,0)
        H.laser(b,true,0,5,0.39269909262657166,4.0,0.0,0.0,192.0,6.0,0,9999,30,0,30,0)
        H.laser(b,true,0,5,-0.39269909262657166,4.0,0.0,0.0,192.0,6.0,0,9999,30,0,30,0)
        H.pattern(b,3,1,6,32,2,2.0,1.0,0.0,0.0,4)
        H.wait(b,v,50)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        v.c3=(v.c3)+(1)
        v.cmp=(v.c3)-(12)
        if v.cmp<0 then v.time=50;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        a.phase=99999
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.call(b,v,P[2][26],0,0.0)
    end
    P[2][27]=B.part1
end

-- 第 2 面，原生 Sub28，起始 0x2548。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.collidable=false
        a.damageable=false
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=0.6000000238418579;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.timeout=-1;a.phase=0
        a.life_threshold=-1
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.wait(b,v,4)
        H.wait(b,v,6)
        H.wait(b,v,8)
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        H.trace(b,"spell_end")
        if not a.main then b.hp=0 end
        H.wait(b,v,3010)
        H.erase(b)
    end
    P[2][28]=B.part1
end

-- 第 2 面，原生 Sub30，起始 0x2b76。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",4)
        a.damageable=false
        a.timeout=2100;a.phase=0
        H.move_to(b,120,192.0,96.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.c3=0
        v.f0=1.399999976158142
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=8
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i1=math.fmod(v.c3,2)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=120;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f2=(v.f2)+(0.39269909262657166)
        v.time=120;return B.part6(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f2=(v.f2)+(-0.39269909262657166)
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f1=ran:Float(0,6.2831854820251465)
        v.f1=(v.f1)+(-3.1415927410125732)
        v.f3=ran:Float(0,0.09817477315664291)
        v.f3=(v.f3)+(-0.04908738657832146)
        v.i3=3
        v.i2=(v.c3)+(13)
        a.extra={60,1,-1,-1,v.f2,v.f0,-1.0,-1.0}
        H.pattern(b,4,5,6,v.i2,v.i3,5.0,1.5,v.f1,0.0,260)
        H.wait(b,v,140)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,140)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.0;a.mode="velocity"
        H.move_dir(b,120,a.angle,a.speed,1)
        v.f0=(v.f0)+(0.15000000596046448)
        v.cmp=(v.c3)-(10)
        if v.cmp<0 then v.time=140;return B.part9(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,140)
        a.phase=99999
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,260)
        v.c3=(v.c3)+(1)
        v.time=120;return B.part2(b,v)
    end
    P[2][30]=B.part1
end

-- 第 2 面，原生 Sub31，起始 0x2e8c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",5)
        a.damageable=false
        a.timeout=2400;a.phase=0
        a.life_threshold=1400
        a.life_fn=P[2][32]
        a.timeout_fn=P[2][32]
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-0.30000001192092896,1.0,-1,5,0,0
        H.sprite(b,131)
        H.move_to(b,120,192.0,96.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,120,a.angle,a.speed,1)
        v.c0=6
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i0=(v.c3)+(16)
        H.wait(b,v,125)
        H.pattern(b,9,1,6,v.i0,1,4.0,1.0,3.1415927410125732,-3.1415927410125732,4)
        H.wait(b,v,130)
        H.pattern(b,9,1,2,v.i0,1,4.0,1.0,3.1415927410125732,-3.1415927410125732,4)
        H.wait(b,v,135)
        H.pattern(b,9,1,10,v.i0,1,4.0,1.0,3.1415927410125732,-3.1415927410125732,4)
        H.wait(b,v,140)
        H.pattern(b,9,1,13,v.i0,1,4.0,1.0,3.1415927410125732,-3.1415927410125732,4)
        H.wait(b,v,145)
        H.pattern(b,9,1,14,v.i0,1,4.0,1.0,3.1415927410125732,-3.1415927410125732,4)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,205)
        H.extra(b,v,0,0,false)
        H.wait(b,v,265)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,120,a.angle,a.speed,1)
        v.c0=6
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,265)
        v.cmp=(v.c3)-(3)
        if v.cmp>=0 then v.time=275;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,275)
        H.pattern(b,1,3,6,3,3,4.0,2.0,0.0,0.39269909262657166,4)
        v.time=295;return B.part10(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,275)
        v.cmp=(v.c3)-(6)
        if v.cmp>=0 then v.time=285;return B.part9(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,285)
        H.pattern(b,1,3,6,5,3,4.0,2.0,0.0,0.39269909262657166,4)
        v.time=295;return B.part10(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,295)
        H.pattern(b,1,3,6,5,3,5.0,2.0,0.0,0.19634954631328583,4)
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,295)
        v.c0=v.c0-1
        if v.c0>0 then v.time=265;return B.part5(b,v) end
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,415)
        H.extra(b,v,0,1,false)
        v.c3=(v.c3)+(1)
        H.wait(b,v,595)
        v.time=120;return B.part2(b,v)
    end
    P[2][31]=B.part1
end

-- 第 2 面，原生 Sub32，起始 0x334a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        a.damageable=false
        a.phase=0
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-0.5,0.30000001192092896,0,4,0,0
        H.wait(b,v,60)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",6)
        a.timeout=1980;a.phase=0
        a.life_fn=P[2][28]
        a.muted=true
        v.i0=24
        H.pattern(b,9,5,6,v.i0,1,2.0,0.4000000059604645,3.1415927410125732,-3.1415927410125732,5)
        a.muted=false
        H.sprite(b,131)
        H.move_to(b,120,192.0,96.0,0.0,1)
        H.wait(b,v,180)
        a.damageable=true
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,180)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.2000000476837158;a.mode="velocity"
        H.move_dir(b,120,a.angle,a.speed,1)
        v.c0=12
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,190)
        H.extra(b,v,1,128,false)
        v.c0=v.c0-1
        if v.c0>0 then v.time=180;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,190)
        v.c3=(v.c3)+(1)
        v.time=180;return B.part2(b,v)
    end
    P[2][32]=B.part1
end

-- 第 3 面，原生 Sub9，起始 0xefc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.interactable=false
        a.death=P[3][15]
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        a.life_threshold=1300
        a.life_fn=P[3][14]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[3][16]
        H.position(b,352.0,-96.0,0.0);H.clamp(b)
        H.move_to(b,100,192.0,150.0,0.0,3)
        H.call(b,v,P[3][10],100,0.0)
        a.damageable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,144.0}
        H.wait(b,v,10)
        H.wait(b,v,20)
        H.wait(b,v,30)
        v.c0=160
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.i3=math.fmod(v.c0,2)
        if (v.i3)==(0) then H.call(b,v,P[3][11],0,0.0) end
        if (v.i3)==(1) then H.call(b,v,P[3][12],0,0.0) end
        a.muted=true
        H.pattern(b,3,2,2,32,2,3.0,2.0,0.0,0.03490658476948738,4)
        a.muted=false
        H.interval(b,30,true)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=5.0;a.mode="velocity"
        H.move_dir(b,50,a.angle,a.speed,3)
        H.call(b,v,P[3][10],50,0.0)
        H.interval(b,0,true)
        H.wait(b,v,90)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.call(b,v,P[3][16],0,0.0)
        H.erase(b)
    end
    P[3][9]=B.part1
end

-- 第 3 面，原生 Sub10，起始 0x1270。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,64)
        v.c1=trunc((v.i0)/(2))
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,2)
        v.c1=v.c1-1
        if v.c1>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.sprite(b,64)
        return
    end
    P[3][10]=B.part1
end

-- 第 3 面，原生 Sub11，起始 0x1334。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c1=8
        H.wait(b,v,20)
        v.f0=ran:Float(0,32.0)
        v.f0=(v.f0)-(16.0)
        v.f1=ran:Float(0,32.0)
        v.f1=(v.f1)-(16.0)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,20)
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,8,3,6,24,1,3.0,1.7000000476837158,0.0,0.0,4)
        v.f2=ran:Float(0,32.0)
        v.f2=(v.f2)-(16.0)
        v.f0=(v.f0)+(v.f2)
        v.f2=ran:Float(0,24.0)
        v.f1=(v.f1)+(v.f2)
        H.wait(b,v,28)
        v.c1=v.c1-1
        if v.c1>0 then v.time=20;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,68)
        return
    end
    P[3][11]=B.part1
end

-- 第 3 面，原生 Sub12，起始 0x1528。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c1=8
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.pattern(b,4,1,2,96,1,1.100000023841858,0.6000000238418579,0.0,0.0,4)
        H.wait(b,v,10)
        return
    end
    P[3][12]=B.part1
end

-- 第 3 面，原生 Sub14，起始 0x19c2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",8)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        a.phase=0
        a.timeout=1200;a.phase=0
        a.timeout_fn=P[3][16]
        H.move_to(b,120,192.0,144.0,0.0,1)
        H.call(b,v,P[3][10],120,0.0)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=math.fmod(a.phase,1)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=0;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.extra={60,2,-1,-1,-2.6179938316345215,1.600000023841858,-1.0,-1.0}
        H.pattern(b,4,5,13,6,1,4.0,0.6000000238418579,v.f0,0.0,68)
        a.extra={60,2,-1,-1,-3.665191411972046,1.600000023841858,-1.0,-1.0}
        H.pattern(b,4,5,13,6,1,4.0,0.6000000238418579,v.f1,0.0,68)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=(v.f0)+(0.1483529806137085)
        v.f1=(v.f1)-(0.16580627858638763)
        v.cmp=(v.f0)-(3.1415927410125732)
        if v.cmp<=0 then v.time=0;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=(v.f0)-(6.2831854820251465)
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.f1)-(3.1415927410125732)
        if v.cmp>=0 then v.time=0;return B.part8(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=(v.f0)+(6.2831854820251465)
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c2=6
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=math.fmod(a.phase,120)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=0;return B.part11(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,3,5,2,52,1,1.600000023841858,0.6000000238418579,0.0,0.0,4)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        v.c2=v.c2-1
        if v.c2>0 then v.time=0;return B.part9(b,v) end
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        v.time=0;return B.part2(b,v)
    end
    P[3][14]=B.part1
end

-- 第 3 面，原生 Sub15，起始 0x1dbc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.call(b,v,P[3][16],0,0.0)
    end
    P[3][15]=B.part1
end

-- 第 3 面，原生 Sub16，起始 0x1e10。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.trace(b,"spell_end")
        H.interval(b,0,true)
        a.bounds=nil
        a.collidable=false
        a.damageable=false
        H.wait(b,v,130)
        H.move_to(b,60,192.0,-64.0,0.0,1)
        H.call(b,v,P[3][10],50,0.0)
        H.erase(b)
    end
    P[3][16]=B.part1
end

-- 第 3 面，原生 Sub18，起始 0x1ff4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.collidable=true
        if not a.main then b.hp=14000 end
        a.phase=0
        a.life_threshold=1900
        a.life_fn=P[3][29]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[3][29]
        a.death=P[3][20]
        a.damageable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,144.0}
        H.wait(b,v,10)
        H.wait(b,v,20)
        H.wait(b,v,30)
        H.wait(b,v,50)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.call(b,v,P[3][19],0,0.0)
        v.c3=v.c3 + 1
        H.wait(b,v,170)
        v.time=50;return B.part2(b,v)
    end
    P[3][18]=B.part1
end

-- 第 3 面，原生 Sub19，起始 0x21a8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.c0=30
        v.f2=2.0
        v.i0=(v.c3)+(5)
        v.cmp=(v.i0)-(10)
        if v.cmp<0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=10
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=(v.i0)+(5)
        v.i1=math.fmod(v.c3,2)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,3,5,2,v.i0,1,v.f2,0.6000000238418579,v.f0,0.0,4)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=(v.f0)+(0.09817477315664291)
        v.time=0;return B.part7(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=(v.f0)-(0.09817477315664291)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=(v.f2)+(0.05000000074505806)
        H.wait(b,v,4)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part4(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=5.0;a.mode="velocity"
        H.move_dir(b,40,a.angle,a.speed,3)
        H.sprite(b,64)
        v.c0=16
        v.f1=0.039269909262657166
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        H.pattern(b,3,5,2,v.i0,1,v.f2,0.6000000238418579,v.f0,0.0,4)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=4;return B.part11(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        v.f0=(v.f0)+(v.f1)
        v.time=4;return B.part12(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        v.f0=(v.f0)-(v.f1)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        v.f1=(v.f1)+(0.06544984877109528)
        v.f2=(v.f2)+(0.05999999865889549)
        H.wait(b,v,6)
        v.c0=v.c0-1
        if v.c0>0 then v.time=4;return B.part9(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,6)
        H.sprite(b,64)
        return
    end
    P[3][19]=B.part1
end

-- 第 3 面，原生 Sub20，起始 0x2534。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.collidable=true
        H.trace(b,"spell_end")
        if not a.main then b.hp=12000 end
        a.phase=0
        a.life_threshold=1400
        a.life_fn=P[3][30]
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[3][30]
        a.death=P[3][26]
        H.interval(b,0,false)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-1.0,1.0,-2,6,0,0
        a.damageable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,144.0}
        H.wait(b,v,160)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,160)
        H.call(b,v,P[3][21],0,0.0)
        v.c2=4
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,160)
        v.i0=H.random_int(3)
        if (v.i0)==(0) then H.call(b,v,P[3][22],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[3][23],0,0.0) end
        if (v.i0)==(2) then H.call(b,v,P[3][24],0,0.0) end
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,80,a.angle,a.speed,3)
        H.call(b,v,P[3][10],80,0.0)
        v.c2=v.c2-1
        if v.c2>0 then v.time=160;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,160)
        v.c3=v.c3 + 1
        H.wait(b,v,280)
        v.time=160;return B.part2(b,v)
    end
    P[3][20]=B.part1
end

-- 第 3 面，原生 Sub21，起始 0x27c4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.spawn(b,3,25,32.0,-32.0,0.0,2000)
        H.spawn(b,3,25,352.0,-32.0,0.0,1000)
        H.wait(b,v,30)
        H.spawn(b,3,25,96.0,-32.0,0.0,500)
        H.spawn(b,3,25,288.0,-32.0,0.0,2000)
        H.wait(b,v,60)
        H.spawn(b,3,25,160.0,-32.0,0.0,1000)
        H.spawn(b,3,25,224.0,-32.0,0.0,500)
        return
    end
    P[3][21]=B.part1
end

-- 第 3 面，原生 Sub22，起始 0x28b4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)
        v.f0=(v.f0)-(3.1415927410125732)
        H.pattern(b,4,3,5,20,3,3.0,2.0,v.f0,0.2617993950843811,4)
        v.f0=ran:Float(0,6.2831854820251465)
        v.f0=(v.f0)-(3.1415927410125732)
        H.wait(b,v,70)
        H.pattern(b,4,3,6,16,2,3.0,2.0,v.f0,0.2617993950843811,4)
        v.f0=ran:Float(0,6.2831854820251465)
        v.f0=(v.f0)-(3.1415927410125732)
        H.wait(b,v,140)
        H.pattern(b,4,3,5,20,3,3.0,2.0,v.f0,0.2617993950843811,4)
        return
    end
    P[3][22]=B.part1
end

-- 第 3 面，原生 Sub23，起始 0x2b0c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.extra={-1,-1,-1,-1,0.02500000037252903,1.5707963705062866,-1.0,-1.0}
        H.pattern(b,9,3,6,20,1,2.0,0.30000001192092896,0.0,-3.1415927410125732,25)
        H.wait(b,v,70)
        H.pattern(b,9,3,6,16,1,2.0,0.30000001192092896,0.0,-3.1415927410125732,25)
        H.wait(b,v,140)
        H.pattern(b,9,3,6,20,1,2.0,0.30000001192092896,0.0,-3.1415927410125732,25)
        return
    end
    P[3][23]=B.part1
end

-- 第 3 面，原生 Sub24，起始 0x2d0c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)
        v.f0=(v.f0)-(3.1415927410125732)
        H.pattern(b,9,3,5,32,1,4.0,1.2999999523162842,3.1415927410125732,-3.1415927410125732,2)
        H.wait(b,v,70)
        H.pattern(b,9,3,5,16,1,4.0,1.2999999523162842,3.1415927410125732,-3.1415927410125732,2)
        H.wait(b,v,140)
        H.pattern(b,9,3,5,24,1,4.0,1.2999999523162842,3.1415927410125732,-3.1415927410125732,2)
        return
    end
    P[3][24]=B.part1
end

-- 第 3 面，原生 Sub25，起始 0x2e88。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,15)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,1.5;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.05000000074505806;a.mode="velocity"
        v.c1=4
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.f0=(H.player_angle(b))+(0.0)
        v.f1=1.600000023841858
        v.c0=30
        a.accel=0.0;a.mode="velocity"
        H.pattern(b,3,3,6,16,1,1.600000023841858,0.0,v.f0,0.39269909262657166,4)
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,2,4,6,3,1,v.f1,0.0,v.f0,0.5235987901687622,4)
        v.f1=(v.f1)+(0.18000000715255737)
        v.i0=math.fmod(v.c0,3)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=70;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,72)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part3(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,232)
        v.c1=v.c1-1
        if v.c1>0 then v.time=40;return B.part2(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,232)
        v.f2=ran:Float(0,1.5707963705062866)+0.7853981852531433
        a.angle,a.speed=v.f2,1.5;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][25]=B.part1
end

-- 第 3 面，原生 Sub26，起始 0x30f4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.collidable=true
        H.trace(b,"spell_end")
        H.clear_helpers(b)
        if not a.main then b.hp=16500 end
        a.phase=0
        a.life_threshold=3400
        a.life_fn=P[3][32]
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[3][32]
        a.death=P[3][34]
        H.interval(b,0,false)
        v.repeat_func=nil
        a.damageable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,144.0}
        H.wait(b,v,160)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,160)
        H.call(b,v,P[3][28],0,0.0)
        H.call(b,v,P[3][27],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=4.0;a.mode="velocity"
        H.move_dir(b,80,a.angle,a.speed,3)
        H.call(b,v,P[3][10],80,0.0)
        v.c3=v.c3 + 1
        H.wait(b,v,280)
        v.time=160;return B.part2(b,v)
    end
    P[3][26]=B.part1
end

-- 第 3 面，原生 Sub27，起始 0x3314。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.extra={-1,-1,-1,-1,0.027000000700354576,1.5707963705062866,-1.0,-1.0}
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        v.c0=40
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,9,5,6,3,1,1.0,0.30000001192092896,0.0,-3.1415927410125732,19)
        H.wait(b,v,2)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,82)
        return
    end
    P[3][27]=B.part1
end

-- 第 3 面，原生 Sub28，起始 0x34ec。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.extra={60,1,-1,-1,-2.6179938316345215,4.0,-1.0,-1.0}
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-0.5,0.800000011920929,0,0,0,0
        v.c0=6
        v.f0=2.0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,4,4,6,42,1,v.f0,2.0,0.0,0.0,66)
        v.f0=(v.f0)+(0.6000000238418579)
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,21)
        H.wait(b,v,71)
        a.extra={60,1,-1,-1,2.4434609413146973,4.0,-1.0,-1.0}
        v.c0=6
        v.f0=2.0
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,71)
        H.pattern(b,4,4,2,42,1,v.f0,2.0,0.0,0.0,66)
        v.f0=(v.f0)+(0.6000000238418579)
        H.wait(b,v,72)
        v.c0=v.c0-1
        if v.c0>0 then v.time=71;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,92)
        return
    end
    P[3][28]=B.part1
end

-- 第 3 面，原生 Sub29，起始 0x3834。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",9)
        H.clear_helpers(b)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.phase=0
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[3][20]
        H.move_to(b,120,192.0,64.0,0.0,1)
        H.call(b,v,P[3][10],120,0.0)
        a.damageable=true
        v.f1=0.8726646304130554
        H.move_to(b,2000,192.0,160.0,0.0,1)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f1
        H.pattern(b,4,5,2,2,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f0=(v.f0)+(0.11344639956951141)
        H.pattern(b,4,5,14,3,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f0=(v.f0)+(0.11344639956951141)
        H.pattern(b,4,5,13,4,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f0=(v.f0)+(0.11344639956951141)
        H.pattern(b,4,5,11,2,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f0=(v.f0)+(0.11344639956951141)
        H.pattern(b,4,5,8,8,2,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f0=(v.f0)+(0.11344639956951141)
        H.pattern(b,4,5,6,3,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f0=(v.f0)+(0.11344639956951141)
        H.pattern(b,4,5,4,2,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f2=3.1415927410125732
        v.f0=(v.f2)-(v.f0)
        H.pattern(b,4,5,8,4,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.f0=(v.f0)+(-0.11344639956951141)
        H.pattern(b,4,5,10,4,1,2.5999999046325684,0.6000000238418579,v.f0,0.0,2)
        v.i0=math.fmod(v.c3,96)
        v.cmp=(v.i0)-(48)
        if v.cmp>=0 then v.time=0;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=(v.f1)+(0.13089969754219055)
        v.time=0;return B.part5(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=(v.f1)+(-0.13089969754219055)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.f1)-(-3.1415927410125732)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=(v.f1)+(6.2831854820251465)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c3=(v.c3)+(1)
        H.wait(b,v,7)
        v.time=0;return B.part2(b,v)
    end
    P[3][29]=B.part1
end

-- 第 3 面，原生 Sub30，起始 0x3dae。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.clear_helpers(b)
        H.wait(b,v,1)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",10)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=-0.5,0.800000011920929,0,0,0,0
        a.phase=0
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[3][26]
        H.move_to(b,120,192.0,64.0,0.0,1)
        H.call(b,v,P[3][10],120,0.0)
        a.damageable=true
        v.f1=0.0
        H.move_to(b,2000,192.0,160.0,0.0,1)
        v.c3=0
        v.c3=0
        v.i2=0
        v.i3=160
        v.f3=112.0
        a.muted=true
        H.pattern(b,1,3,6,4,1,1.2000000476837158,1.0,0.0,2.24399471282959,4)
        a.muted=false
        v.repeat_func=2
        H.interval(b,0,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,81)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,80,a.angle,a.speed,3)
        H.call(b,v,P[3][10],80,0.0)
        H.wait(b,v,181)
        v.i2=0
        v.i3=160
        v.f3=112.0
        v.repeat_func=2
        v.c3=v.c3 + 1
        v.time=1;return B.part2(b,v)
    end
    P[3][30]=B.part1
end

-- 第 3 面，原生 Sub32，起始 0x4512。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2160;a.phase=0
        H.clear_helpers(b)
        a.damageable=false
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",12)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.life_threshold=2000
        a.life_fn=P[3][33]
        a.timeout_fn=P[3][33]
        H.move_to(b,120,192.0,64.0,0.0,1)
        H.call(b,v,P[3][10],120,0.0)
        a.damageable=true
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.extra={-1,-1,-1,-1,0.02500000037252903,1.5707963705062866,-1.0,-1.0}
        v.c0=40
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=v.f0
        H.pattern(b,2,5,6,1,1,1.5,0.30000001192092896,v.f2,0.5235987901687622,19)
        v.f2=(v.f2)+(1.5707963705062866)
        H.pattern(b,2,5,10,1,1,1.5,0.30000001192092896,v.f2,0.5235987901687622,19)
        v.f2=(v.f2)+(1.5707963705062866)
        H.pattern(b,2,5,11,1,1,1.5,0.30000001192092896,v.f2,0.5235987901687622,19)
        v.f2=(v.f2)+(1.5707963705062866)
        H.pattern(b,2,5,8,1,1,1.5,0.30000001192092896,v.f2,0.5235987901687622,19)
        v.f0=(v.f0)+(0.1745329201221466)
        v.f0=normal_angle(v.f0)
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=3.0;a.mode="velocity"
        H.move_dir(b,80,a.angle,a.speed,3)
        H.call(b,v,P[3][10],80,0.0)
        H.wait(b,v,21)
        v.c0=30
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,21)
        v.f2=v.f0
        a.extra={-1,-1,-1,-1,0.024000000208616257,3.1415927410125732,-1.0,-1.0}
        H.pattern(b,9,5,2,1,1,1.2000000476837158,0.30000001192092896,v.f0,0.09817477315664291,19)
        v.f2=(v.f2)+(1.5707963705062866)
        a.extra={-1,-1,-1,-1,0.024000000208616257,0.0,-1.0,-1.0}
        H.pattern(b,9,5,4,1,1,1.2000000476837158,0.30000001192092896,v.f2,0.09817477315664291,19)
        v.f2=(v.f2)+(1.5707963705062866)
        a.extra={-1,-1,-1,-1,0.024000000208616257,2.356194496154785,-1.0,-1.0}
        H.pattern(b,9,5,13,2,1,1.2000000476837158,0.30000001192092896,v.f2,0.09817477315664291,19)
        v.f2=(v.f2)+(1.5707963705062866)
        a.extra={-1,-1,-1,-1,0.024000000208616257,0.7853981852531433,-1.0,-1.0}
        H.pattern(b,9,5,14,2,1,1.2000000476837158,0.30000001192092896,v.f2,0.09817477315664291,19)
        v.f0=(v.f0)-(0.5235987901687622)
        v.f0=normal_angle(v.f0)
        H.wait(b,v,23)
        v.c0=v.c0-1
        if v.c0>0 then v.time=21;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,23)
        v.c3=v.c3 + 1
        v.time=0;return B.part2(b,v)
    end
    P[3][32]=B.part1
end

-- 第 3 面，原生 Sub33，起始 0x4b54。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        a.timeout=2160;a.phase=0
        a.timeout_fn=P[3][34]
        H.clear_helpers(b)
        a.damageable=false
        v.c3=0
        a.phase=0
        H.wait(b,v,60)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",13)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.move_to(b,120,192.0,128.0,0.0,1)
        H.call(b,v,P[3][10],120,0.0)
        a.damageable=true
        v.f0=1.5707963705062866
        v.f1=-1.5707963705062866
        v.i0=2
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.f1=(v.f0)+(0.0)
        a.extra={-1,-1,-1,-1,0.01600000075995922,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,6,v.i0,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        H.wait(b,v,61)
        v.f1=(v.f0)+(1.5707963705062866)
        a.extra={-1,-1,-1,-1,0.017999999225139618,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,10,1,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        v.f1=(v.f0)+(3.1415927410125732)
        a.extra={-1,-1,-1,-1,0.01600000075995922,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,11,1,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        H.wait(b,v,62)
        v.f1=(v.f0)+(-1.5707963705062866)
        a.extra={-1,-1,-1,-1,0.017999999225139618,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,8,1,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        H.wait(b,v,63)
        v.f1=(v.f2)+(0.0)
        a.extra={-1,-1,-1,-1,0.01600000075995922,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,2,v.i0,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        v.f1=(v.f2)+(0.0)
        a.extra={-1,-1,-1,-1,0.017999999225139618,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,2,1,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        H.wait(b,v,64)
        v.f1=(v.f2)+(3.1415927410125732)
        a.extra={-1,-1,-1,-1,0.017999999225139618,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,2,1,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        H.wait(b,v,65)
        v.f1=(v.f2)+(0.0)
        a.extra={-1,-1,-1,-1,0.01600000075995922,v.f1,-1.0,-1.0}
        H.pattern(b,9,5,2,3,1,1.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        v.f0=(v.f0)+(0.10471975803375244)
        v.cmp=(v.f0)-(3.1415927410125732)
        if v.cmp<=0 then v.time=65;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.f0=(v.f0)-(6.2831854820251465)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.f2=(v.f2)-(0.10471975803375244)
        v.cmp=(v.f2)-(-3.1415927410125732)
        if v.cmp>=0 then v.time=65;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.f2=(v.f2)+(6.2831854820251465)
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.cmp=(a.phase)-(1200)
        if v.cmp<=0 then v.time=65;return B.part8(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.i0=3
        v.time=65;return B.part10(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.cmp=(a.phase)-(600)
        if v.cmp<=0 then v.time=65;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.i0=2
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        v.c3=v.c3 + 1
        H.wait(b,v,66)
        v.time=60;return B.part2(b,v)
    end
    P[3][33]=B.part1
end

-- 第 3 面，原生 Sub34，起始 0x529e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.collidable=false
        a.damageable=false
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=0.6000000238418579;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.timeout=-1;a.phase=0
        a.life_threshold=-1
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.wait(b,v,4)
        H.wait(b,v,6)
        H.wait(b,v,8)
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        H.trace(b,"spell_end")
        if not a.main then b.hp=0 end
        H.wait(b,v,3010)
        H.erase(b)
    end
    P[3][34]=B.part1
end

-- 第 4 面，原生 Sub1，起始 0x1cc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,16)
        a.damageable=false
        a.interactable=false
        H.wait(b,v,30)
        v.c0=12
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,80.0)+-40.0
        v.f1=ran:Float(0,80.0)+-40.0
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=ran:Float(0,1.0)+1.0
        H.pattern(b,4,4,6,16,1,v.f1,0.0,v.f0,0.09817477315664291,4)
        H.wait(b,v,36)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,36)
        H.wait(b,v,156)
        H.erase(b)
    end
    P[4][1]=B.part1
end

-- 第 4 面，原生 Sub21，起始 0x1d80。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.interactable=false
        H.sprite(b,64)
        H.clear_helpers(b)
        H.cancel(b)
        b.a,b.b,b.rect=(40.0)/2,(56.0)/2,true
        a.bounds={32.0,48.0,352.0,176.0}
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][25]
        a.death=P[4][24]
        H.position(b,192.0,128.0,0.0);H.clamp(b)
        H.wait(b,v,30)
        a.interactable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        H.call(b,v,P[4][22],0,0.19634954631328583)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.call(b,v,P[4][23],0,0.0)
        H.wait(b,v,90)
        H.call(b,v,P[4][22],0,-0.19634954631328583)
        H.call(b,v,P[4][23],0,0.0)
        H.wait(b,v,91)
        v.time=30;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,40091)
        H.erase(b)
    end
    P[4][21]=B.part1
end

-- 第 4 面，原生 Sub22，起始 0x1f6c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.c0=8
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.extra={-1,-1,-1,-1,0.024000000208616257,-999.0,-1.0,-1.0}
        H.pattern(b,4,9,1,8,1,1.2000000476837158,1.0,v.f1,0.0,20)
        v.f1=(v.f1)+(v.f0)
        H.wait(b,v,20)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,20)
        return
    end
    P[4][22]=B.part1
end

-- 第 4 面，原生 Sub23，起始 0x2058。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.spawn(b,4,1,(b.x+192),(224-b.y),a.z,1000)
        H.wait(b,v,30)
        H.spawn(b,4,1,(b.x+192),(224-b.y),a.z,1000)
        return
    end
    P[4][23]=B.part1
end

-- 第 4 面，原生 Sub24，起始 0x20b8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.interactable=false
        H.trace(b,"spell_end")
        H.erase(b)
    end
    P[4][24]=B.part1
end

-- 第 4 面，原生 Sub25，起始 0x2120。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.interactable=false
        H.trace(b,"spell_end")
        H.erase(b)
    end
    P[4][25]=B.part1
end

-- 第 4 面，原生 Sub27，起始 0x2294。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        a.collidable=true
        if not a.main then b.hp=17000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,144.0}
        v.i3=0
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][37]
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.stage==7 and 4 or 3))-(1)
        if v.cmp~=0 then v.time=0;return B.part11(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(0)
        if v.cmp~=0 then v.time=0;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][42]
        a.life_threshold=1600
        a.life_fn=P[4][42]
        v.time=0;return B.part11(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(1)
        if v.cmp~=0 then v.time=0;return B.part8(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][45]
        a.life_threshold=1600
        a.life_fn=P[4][45]
        v.time=0;return B.part11(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(2)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][47]
        a.life_threshold=1600
        a.life_fn=P[4][47]
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][50]
        a.life_threshold=1800
        a.life_fn=P[4][50]
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.stage==7 and 4 or 3))-(1)
        if v.cmp<=0 then v.time=0;return B.part19(b,v) end
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(0)
        if v.cmp~=0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][43]
        a.life_threshold=1500
        a.life_fn=P[4][43]
        v.time=0;return B.part19(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(1)
        if v.cmp~=0 then v.time=0;return B.part16(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][46]
        a.life_threshold=1600
        a.life_fn=P[4][46]
        v.time=0;return B.part19(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(2)
        if v.cmp~=0 then v.time=0;return B.part18(b,v) end
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][48]
        a.life_threshold=1600
        a.life_fn=P[4][48]
        v.time=0;return B.part19(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][51]
        a.life_threshold=1800
        a.life_fn=P[4][51]
        return B.part19(b,v)
    end
    function B.part19(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.death=P[4][37]
        H.wait(b,v,10)
        H.wait(b,v,20)
        H.wait(b,v,30)
        H.wait(b,v,40)
        v.c3=0
        return B.part20(b,v)
    end
    function B.part20(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        v.i0=math.fmod(v.c3,2)
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=100;return B.part22(b,v) end
        return B.part21(b,v)
    end
    function B.part21(b,v)
        local a=b.th06_actor
        H.wait(b,v,100)
        if (v.i0)==(0) then H.call(b,v,P[4][32],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][28],0,0.0) end
        v.time=280;return B.part28(b,v)
    end
    function B.part22(b,v)
        local a=b.th06_actor
        H.wait(b,v,100)
        v.cmp=((a.stage==7 and 4 or 3))-(1)
        if v.cmp~=0 then v.time=160;return B.part24(b,v) end
        return B.part23(b,v)
    end
    function B.part23(b,v)
        local a=b.th06_actor
        H.wait(b,v,160)
        if (v.i0)==(0) then H.call(b,v,P[4][33],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][29],0,0.0) end
        v.time=280;return B.part28(b,v)
    end
    function B.part24(b,v)
        local a=b.th06_actor
        H.wait(b,v,160)
        v.cmp=((a.stage==7 and 4 or 3))-(2)
        if v.cmp~=0 then v.time=220;return B.part26(b,v) end
        return B.part25(b,v)
    end
    function B.part25(b,v)
        local a=b.th06_actor
        H.wait(b,v,220)
        if (v.i0)==(0) then H.call(b,v,P[4][34],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][30],0,0.0) end
        v.time=280;return B.part28(b,v)
    end
    function B.part26(b,v)
        local a=b.th06_actor
        H.wait(b,v,220)
        v.cmp=((a.stage==7 and 4 or 3))-(3)
        if v.cmp~=0 then v.time=280;return B.part28(b,v) end
        return B.part27(b,v)
    end
    function B.part27(b,v)
        local a=b.th06_actor
        H.wait(b,v,280)
        if (v.i0)==(0) then H.call(b,v,P[4][35],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][31],0,0.0) end
        return B.part28(b,v)
    end
    function B.part28(b,v)
        local a=b.th06_actor
        H.wait(b,v,280)
        H.call(b,v,P[4][36],0,0.0)
        v.c3=v.c3 + 1
        v.time=40;return B.part20(b,v)
    end
    function B.part29(b,v)
        local a=b.th06_actor
        H.wait(b,v,9280)
        H.erase(b)
    end
    P[4][27]=B.part1
end

-- 第 4 面，原生 Sub28，起始 0x2a70。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,3,3,2,8,1,1.5,1.2000000476837158,0.0,0.0,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=180
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(120)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,0.006041524466127157,false)
        H.rotate_laser(b,1,0.006041524466127157,false)
        H.rotate_laser(b,2,0.006041524466127157,false)
        H.rotate_laser(b,3,0.006041524466127157,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,-0.006041524466127157,false)
        H.rotate_laser(b,5,-0.006041524466127157,false)
        H.rotate_laser(b,6,-0.006041524466127157,false)
        H.rotate_laser(b,7,-0.006041524466127157,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][28]=B.part1
end

-- 第 4 面，原生 Sub29，起始 0x329c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,3,3,2,10,1,2.0,1.2000000476837158,0.0,0.0,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=180
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(120)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,0.006829549092799425,false)
        H.rotate_laser(b,1,0.006829549092799425,false)
        H.rotate_laser(b,2,0.006829549092799425,false)
        H.rotate_laser(b,3,0.006829549092799425,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,-0.006829549092799425,false)
        H.rotate_laser(b,5,-0.006829549092799425,false)
        H.rotate_laser(b,6,-0.006829549092799425,false)
        H.rotate_laser(b,7,-0.006829549092799425,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][29]=B.part1
end

-- 第 4 面，原生 Sub30，起始 0x3ac8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,3,3,2,14,1,2.4000000953674316,1.2000000476837158,0.0,0.0,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=150
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(100)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,0.00819545891135931,false)
        H.rotate_laser(b,1,0.00819545891135931,false)
        H.rotate_laser(b,2,0.00819545891135931,false)
        H.rotate_laser(b,3,0.00819545891135931,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(50)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(50)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,-0.00819545891135931,false)
        H.rotate_laser(b,5,-0.00819545891135931,false)
        H.rotate_laser(b,6,-0.00819545891135931,false)
        H.rotate_laser(b,7,-0.00819545891135931,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][30]=B.part1
end

-- 第 4 面，原生 Sub31，起始 0x42f4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,3,3,2,10,2,3.0,1.2000000476837158,0.0,0.0,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=140
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(93)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,0.008780849166214466,false)
        H.rotate_laser(b,1,0.008780849166214466,false)
        H.rotate_laser(b,2,0.008780849166214466,false)
        H.rotate_laser(b,3,0.008780849166214466,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(46)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(46)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,-0.008780849166214466,false)
        H.rotate_laser(b,5,-0.008780849166214466,false)
        H.rotate_laser(b,6,-0.008780849166214466,false)
        H.rotate_laser(b,7,-0.008780849166214466,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][31]=B.part1
end

-- 第 4 面，原生 Sub32，起始 0x4b20。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,3,3,2,1,2,2.0,1.2000000476837158,0.0,0.0,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=180
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(120)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,-0.006041524466127157,false)
        H.rotate_laser(b,1,-0.006041524466127157,false)
        H.rotate_laser(b,2,-0.006041524466127157,false)
        H.rotate_laser(b,3,-0.006041524466127157,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,0.006041524466127157,false)
        H.rotate_laser(b,5,0.006041524466127157,false)
        H.rotate_laser(b,6,0.006041524466127157,false)
        H.rotate_laser(b,7,0.006041524466127157,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][32]=B.part1
end

-- 第 4 面，原生 Sub33，起始 0x534c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,3,3,2,1,2,2.0,1.2000000476837158,0.0,0.0,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,70,20,30,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=180
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(120)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,-0.006829549092799425,false)
        H.rotate_laser(b,1,-0.006829549092799425,false)
        H.rotate_laser(b,2,-0.006829549092799425,false)
        H.rotate_laser(b,3,-0.006829549092799425,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,30,90,20,30,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(60)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,0.006829549092799425,false)
        H.rotate_laser(b,5,0.006829549092799425,false)
        H.rotate_laser(b,6,0.006829549092799425,false)
        H.rotate_laser(b,7,0.006829549092799425,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][33]=B.part1
end

-- 第 4 面，原生 Sub34，起始 0x5b78。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,1,3,2,2,2,2.0,1.2000000476837158,0.0,0.09817477315664291,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,58,16,25,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=150
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(100)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,-0.00819545891135931,false)
        H.rotate_laser(b,1,-0.00819545891135931,false)
        H.rotate_laser(b,2,-0.00819545891135931,false)
        H.rotate_laser(b,3,-0.00819545891135931,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(50)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,25,75,16,25,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(50)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,0.00819545891135931,false)
        H.rotate_laser(b,5,0.00819545891135931,false)
        H.rotate_laser(b,6,0.00819545891135931,false)
        H.rotate_laser(b,7,0.00819545891135931,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][34]=B.part1
end

-- 第 4 面，原生 Sub35，起始 0x63a4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.muted=true
        H.pattern(b,1,3,2,2,2,2.5,1.2000000476837158,0.0,0.09817477315664291,4)
        a.muted=false
        a.lasers={}
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=1
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=2
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=3
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        v.time=0;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=0
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=1
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=2
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        a.laser_index=3
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,54,15,23,14,0)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=140
        v.i0=0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(93)
        if v.cmp>=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,0,-0.008780849166214466,false)
        H.rotate_laser(b,1,-0.008780849166214466,false)
        H.rotate_laser(b,2,-0.008780849166214466,false)
        H.rotate_laser(b,3,-0.008780849166214466,false)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(46)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,6,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=5
        H.laser(b,false,1,6,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=6
        H.laser(b,false,1,6,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=7
        H.laser(b,false,1,6,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        v.time=0;return B.part11(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=4
        H.laser(b,false,1,2,0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=5
        H.laser(b,false,1,2,2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=6
        H.laser(b,false,1,2,-2.356194496154785,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        a.laser_index=7
        H.laser(b,false,1,2,-0.7853981852531433,0.0,64.0,500.0,500.0,24.0,23,70,15,23,14,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i0)-(46)
        if v.cmp<0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rotate_laser(b,4,0.008780849166214466,false)
        H.rotate_laser(b,5,0.008780849166214466,false)
        H.rotate_laser(b,6,0.008780849166214466,false)
        H.rotate_laser(b,7,0.008780849166214466,false)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.c3)-(0)
        if v.cmp==0 then v.time=0;return B.part17(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.i0,40)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,12,0,false)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i0=v.i0 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part5(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[4][35]=B.part1
end

-- 第 4 面，原生 Sub36，起始 0x6bd0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.i0=(v.c3)+(24)
        a.muted=true
        H.pattern(b,3,3,2,v.i0,4,3.5,1.2000000476837158,0.0,0.0,4)
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,40,false)
        H.wait(b,v,90)
        H.move_to(b,90,192.0,128.0,0.0,1)
        H.wait(b,v,180)
        H.interval(b,0,false)
        return
    end
    P[4][36]=B.part1
end

-- 第 4 面，原生 Sub37，起始 0x6d90。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        v.i3=1
        a.damageable=true
        a.collidable=true
        if not a.main then b.hp=16000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=0;return B.part9(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(0)
        if v.cmp~=0 then v.time=0;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][42]
        a.life_threshold=1500
        a.life_fn=P[4][42]
        v.time=0;return B.part9(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(1)
        if v.cmp~=0 then v.time=0;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][45]
        a.life_threshold=1600
        a.life_fn=P[4][45]
        v.time=0;return B.part9(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(2)
        if v.cmp~=0 then v.time=0;return B.part8(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][47]
        a.life_threshold=1600
        a.life_fn=P[4][47]
        v.time=0;return B.part9(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][50]
        a.life_threshold=1800
        a.life_fn=P[4][50]
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.stage==7 and 4 or 3))-(1)
        if v.cmp~=0 then v.time=0;return B.part17(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(0)
        if v.cmp~=0 then v.time=0;return B.part12(b,v) end
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][51]
        a.life_threshold=1500
        a.life_fn=P[4][51]
        v.time=0;return B.part17(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(1)
        if v.cmp~=0 then v.time=0;return B.part14(b,v) end
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][48]
        a.life_threshold=1600
        a.life_fn=P[4][48]
        v.time=0;return B.part17(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(2)
        if v.cmp~=0 then v.time=0;return B.part16(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][43]
        a.life_threshold=1700
        a.life_fn=P[4][43]
        v.time=0;return B.part17(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][53]
        a.life_threshold=1800
        a.life_fn=P[4][53]
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.stage==7 and 4 or 3))-(1)
        if v.cmp<=0 then v.time=0;return B.part25(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(0)
        if v.cmp~=0 then v.time=0;return B.part20(b,v) end
        return B.part19(b,v)
    end
    function B.part19(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][52]
        a.life_threshold=1500
        a.life_fn=P[4][52]
        v.time=0;return B.part25(b,v)
    end
    function B.part20(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(1)
        if v.cmp~=0 then v.time=0;return B.part22(b,v) end
        return B.part21(b,v)
    end
    function B.part21(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][49]
        a.life_threshold=1600
        a.life_fn=P[4][49]
        v.time=0;return B.part25(b,v)
    end
    function B.part22(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(2)
        if v.cmp~=0 then v.time=0;return B.part24(b,v) end
        return B.part23(b,v)
    end
    function B.part23(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][44]
        a.life_threshold=1800
        a.life_fn=P[4][44]
        v.time=0;return B.part25(b,v)
    end
    function B.part24(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[4][54]
        a.life_threshold=1800
        a.life_fn=P[4][54]
        return B.part25(b,v)
    end
    function B.part25(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.death=P[4][39]
        H.wait(b,v,120)
        v.c3=0
        return B.part26(b,v)
    end
    function B.part26(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i0=math.fmod(v.c3,2)
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=180;return B.part28(b,v) end
        return B.part27(b,v)
    end
    function B.part27(b,v)
        local a=b.th06_actor
        H.wait(b,v,180)
        if (v.i0)==(0) then H.call(b,v,P[4][32],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][28],0,0.0) end
        v.time=360;return B.part34(b,v)
    end
    function B.part28(b,v)
        local a=b.th06_actor
        H.wait(b,v,180)
        v.cmp=((a.stage==7 and 4 or 3))-(1)
        if v.cmp~=0 then v.time=240;return B.part30(b,v) end
        return B.part29(b,v)
    end
    function B.part29(b,v)
        local a=b.th06_actor
        H.wait(b,v,240)
        if (v.i0)==(0) then H.call(b,v,P[4][33],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][29],0,0.0) end
        v.time=360;return B.part34(b,v)
    end
    function B.part30(b,v)
        local a=b.th06_actor
        H.wait(b,v,240)
        v.cmp=((a.stage==7 and 4 or 3))-(2)
        if v.cmp~=0 then v.time=300;return B.part32(b,v) end
        return B.part31(b,v)
    end
    function B.part31(b,v)
        local a=b.th06_actor
        H.wait(b,v,300)
        if (v.i0)==(0) then H.call(b,v,P[4][34],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][30],0,0.0) end
        v.time=360;return B.part34(b,v)
    end
    function B.part32(b,v)
        local a=b.th06_actor
        H.wait(b,v,300)
        v.cmp=((a.stage==7 and 4 or 3))-(3)
        if v.cmp~=0 then v.time=360;return B.part34(b,v) end
        return B.part33(b,v)
    end
    function B.part33(b,v)
        local a=b.th06_actor
        H.wait(b,v,360)
        if (v.i0)==(0) then H.call(b,v,P[4][35],0,0.0) end
        if (v.i0)==(1) then H.call(b,v,P[4][31],0,0.0) end
        return B.part34(b,v)
    end
    function B.part34(b,v)
        local a=b.th06_actor
        H.wait(b,v,360)
        H.call(b,v,P[4][38],0,0.0)
        v.c3=v.c3 + 1
        v.time=120;return B.part26(b,v)
    end
    function B.part35(b,v)
        local a=b.th06_actor
        H.wait(b,v,9360)
        H.erase(b)
    end
    P[4][37]=B.part1
end

-- 第 4 面，原生 Sub38，起始 0x76a0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.i0=(v.c3)+(10)
        a.muted=true
        H.pattern(b,3,3,6,v.i0,5,5.5,1.5,0.0,0.0,4)
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,10,false)
        H.wait(b,v,90)
        H.move_to(b,90,192.0,128.0,0.0,1)
        H.wait(b,v,180)
        H.interval(b,60,false)
        a.muted=true
        H.pattern(b,3,3,6,20,1,1.5,1.0,0.0,0.0,4)
        a.muted=false
        return
    end
    P[4][38]=B.part1
end

-- 第 4 面，原生 Sub39，起始 0x7940。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.damageable=false
        a.collidable=true
        if not a.main then b.hp=5100 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.life_threshold=3400
        a.life_fn=P[4][40]
        a.death=P[4][40]
        H.extra(b,v,3,0,false)
        H.wait(b,v,120)
        a.damageable=true
        if (v.i1)==(0) then H.call(b,v,P[4][55],0,0.0) end
        if (v.i1)==(1) then H.call(b,v,P[4][56],0,0.0) end
        if (v.i1)==(2) then H.call(b,v,P[4][57],0,0.0) end
        if (v.i1)==(3) then H.call(b,v,P[4][58],0,0.0) end
        if (v.i1)==(4) then H.call(b,v,P[4][59],0,0.0) end
    end
    P[4][39]=B.part1
end

-- 第 4 面，原生 Sub40，起始 0x7bb8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.damageable=false
        a.collidable=true
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.life_threshold=1700
        a.life_fn=P[4][41]
        a.death=P[4][41]
        H.wait(b,v,120)
        a.damageable=true
        if (v.i2)==(0) then H.call(b,v,P[4][55],0,0.0) end
        if (v.i2)==(1) then H.call(b,v,P[4][56],0,0.0) end
        if (v.i2)==(2) then H.call(b,v,P[4][57],0,0.0) end
        if (v.i2)==(3) then H.call(b,v,P[4][58],0,0.0) end
        if (v.i2)==(4) then H.call(b,v,P[4][59],0,0.0) end
    end
    P[4][40]=B.part1
end

-- 第 4 面，原生 Sub41，起始 0x7dd4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.damageable=false
        a.collidable=true
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.death=P[4][60]
        H.wait(b,v,120)
        a.damageable=true
        if (v.i3)==(0) then H.call(b,v,P[4][55],0,0.0) end
        if (v.i3)==(1) then H.call(b,v,P[4][56],0,0.0) end
        if (v.i3)==(2) then H.call(b,v,P[4][57],0,0.0) end
        if (v.i3)==(3) then H.call(b,v,P[4][58],0,0.0) end
        if (v.i3)==(4) then H.call(b,v,P[4][59],0,0.0) end
    end
    P[4][41]=B.part1
end

-- 第 4 面，原生 Sub42，起始 0x7fb0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",14)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=1800;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=5
        v.i0=trunc((v.c3)/(3))
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={128,-1,-1,-1,0.0,0.02454369328916073,-1.0,-1.0}
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={128,-1,-1,-1,0.0,-0.02454369328916073,-1.0,-1.0}
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={128,-1,-1,-1,0.0,0.02454369328916073,-1.0,-1.0}
        H.wait(b,v,128)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,248)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,258)
        v.time=120;return B.part2(b,v)
    end
    P[4][42]=B.part1
end

-- 第 4 面，原生 Sub43，起始 0x836e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",19)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=1800;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=5
        v.i0=trunc((v.c3)/(3))
        v.i0=(v.i0)+(10)
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={128,-1,-1,-1,0.0,0.02454369328916073,-1.0,-1.0}
        H.pattern(b,4,7,0,v.i0,2,2.5,1.2000000476837158,v.f0,0.13089969754219055,32)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={128,-1,-1,-1,0.0,-0.02454369328916073,-1.0,-1.0}
        H.pattern(b,4,7,0,v.i0,2,2.5,1.2000000476837158,v.f0,0.13089969754219055,32)
        H.wait(b,v,128)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,248)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,258)
        v.time=120;return B.part2(b,v)
    end
    P[4][43]=B.part1
end

-- 第 4 面，原生 Sub44，起始 0x8770。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",22)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=1800;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=8
        v.i0=trunc((v.c3)/(5))
        v.i0=(v.i0)+(7)
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={128,-1,-1,-1,0.0,0.02454369328916073,-1.0,-1.0}
        H.pattern(b,4,7,0,v.i0,2,2.0,1.0,v.f0,0.13089969754219055,32)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={128,-1,-1,-1,0.0,-0.02454369328916073,-1.0,-1.0}
        H.pattern(b,4,7,0,v.i0,2,2.0,1.0,v.f0,0.13089969754219055,32)
        H.pattern(b,9,9,0,6,1,4.0,0.699999988079071,3.1415927410125732,-3.1415927410125732,0)
        H.wait(b,v,128)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,248)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,258)
        v.time=120;return B.part2(b,v)
    end
    P[4][44]=B.part1
end

-- 第 4 面，原生 Sub45，起始 0x8ad2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",15)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=12
        a.muted=true
        H.pattern(b,1,3,6,16,2,3.5,1.2000000476837158,3.1415927410125732,0.3490658402442932,4)
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,22,false)
        v.f0=(3.1415927410125732)/(8.0)
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.laser(b,true,0,6,0.0,4.0,0.0,0.0,96.0,6.0,0,9999,30,0,30,0)
        H.laser(b,true,0,6,v.f0,4.0,0.0,0.0,96.0,6.0,0,9999,30,0,30,0)
        v.f1=(0.0)-(v.f0)
        H.laser(b,true,0,6,v.f1,4.0,0.0,0.0,96.0,6.0,0,9999,30,0,30,0)
        v.f0=(v.f0)-(0.02617993950843811)
        H.wait(b,v,130)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,130)
        H.interval(b,0,false)
        v.c0=8
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.f0=0.0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,130)
        H.pattern(b,1,6,3,10,1,2.5,0.699999988079071,v.f0,0.22439947724342346,0)
        v.i0=v.c3
        v.i0=(v.i0)+(1)
        H.wait(b,v,140)
        v.c0=v.c0-1
        if v.c0>0 then v.time=130;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,140)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,190)
        v.time=120;return B.part2(b,v)
    end
    P[4][45]=B.part1
end

-- 第 4 面，原生 Sub46，起始 0x8f28。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",23)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=12
        a.muted=true
        H.pattern(b,3,3,6,30,2,3.0,1.7999999523162842,0.0,0.3490658402442932,4)
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,22,false)
        v.f0=(3.1415927410125732)/(8.0)
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.laser(b,true,0,6,v.f0,0.0,0.0,640.0,640.0,8.0,20,50,10,20,10,0)
        v.f1=(0.0)-(v.f0)
        H.laser(b,true,0,6,v.f1,0.0,0.0,640.0,640.0,8.0,20,50,10,20,10,0)
        v.f0=(v.f0)-(0.02617993950843811)
        H.wait(b,v,130)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,130)
        H.interval(b,0,false)
        v.c0=8
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.f0=0.0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,130)
        H.pattern(b,1,9,1,10,1,3.799999952316284,0.699999988079071,v.f0,0.3141592741012573,0)
        v.f1=ran:Float(0,0.1745329201221466)+-0.0872664600610733
        v.f0=(v.f0)-(v.f1)
        H.wait(b,v,140)
        v.c0=v.c0-1
        if v.c0>0 then v.time=130;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,140)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,190)
        v.time=120;return B.part2(b,v)
    end
    P[4][46]=B.part1
end

-- 第 4 面，原生 Sub47，起始 0x933e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",16)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i1=math.fmod(v.i0,6)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.extra={-1,-1,-1,-1,0.012000000104308128,2.356194496154785,-1.0,-1.0}
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.extra={-1,-1,-1,-1,0.012000000104308128,2.356194496154785,-1.0,-1.0}
        v.f0=ran:Float(0,384.0)
        v.f0=(v.f0)-((b.x+192))
        v.f1=(32.0)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,10,1,1,1.2000000476837158,0.30000001192092896,2.6354472637176514,2.076941728591919,19)
        v.c1=math.fmod(v.i0,2)
        v.cmp=(v.c1)-(0)
        if v.cmp~=0 then v.time=122;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.f0=ran:Float(0,192.0)
        v.f1=(v.f0)-((224-b.y))
        v.f0=(396.0)-((b.x+192))
        v.time=122;return B.part7(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.f0=ran:Float(0,192.0)+192.0
        v.f1=(v.f0)-((224-b.y))
        v.f0=(396.0)-((b.x+192))
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,11,1,1,1.2000000476837158,0.30000001192092896,2.6354472637176514,2.076941728591919,19)
        v.i0=v.i0 + 1
        H.wait(b,v,126)
        v.time=120;return B.part2(b,v)
    end
    P[4][47]=B.part1
end

-- 第 4 面，原生 Sub48，起始 0x9748。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",20)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i1=math.fmod(v.i0,6)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.extra={-1,-1,-1,-1,0.012000000104308128,0.7853981852531433,-1.0,-1.0}
        H.pattern(b,9,5,13,15,1,2.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        H.pattern(b,9,5,13,12,1,2.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.extra={60,-1,-1,-1,0.012000000104308128,0.7853981852531433,-1.0,-1.0}
        v.f0=ran:Float(0,384.0)
        v.f0=(v.f0)-((b.x+192))
        v.f1=(32.0)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,10,1,1,1.2000000476837158,0.30000001192092896,1.0646508932113647,0.5061454772949219,19)
        v.c1=math.fmod(v.i0,2)
        v.cmp=(v.c1)-(0)
        if v.cmp~=0 then v.time=122;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.f0=ran:Float(0,192.0)
        v.f1=(v.f0)-((224-b.y))
        v.f0=-12.0
        v.f0=(v.f0)-((b.x+192))
        v.time=122;return B.part7(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.f0=ran:Float(0,192.0)+192.0
        v.f1=(v.f0)-((224-b.y))
        v.f0=-12.0
        v.f0=(v.f0)-((b.x+192))
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,11,2,1,1.5,0.30000001192092896,1.0646508932113647,0.5061454772949219,19)
        v.i0=v.i0 + 1
        H.wait(b,v,126)
        v.time=120;return B.part2(b,v)
    end
    P[4][48]=B.part1
end

-- 第 4 面，原生 Sub49，起始 0x9bfe。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",24)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i1=math.fmod(v.i0,5)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.extra={-1,-1,-1,-1,0.00800000037997961,1.5707963705062866,-1.0,-1.0}
        H.pattern(b,9,5,11,30,1,2.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c1=math.fmod(v.i0,2)
        v.cmp=(v.c1)-(0)
        if v.cmp~=0 then v.time=120;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,384.0)
        v.f1=(v.f0)-((224-b.y))
        v.f0=(396.0)-((b.x+192))
        a.extra={-1,-1,-1,-1,0.00800000037997961,2.356194496154785,-1.0,-1.0}
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,10,1,1,2.0,0.30000001192092896,2.6354472637176514,2.076941728591919,19)
        v.time=120;return B.part7(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,384.0)
        v.f1=(v.f0)-((224-b.y))
        v.f0=-12.0
        v.f0=(v.f0)-((b.x+192))
        a.extra={-1,-1,-1,-1,0.00800000037997961,0.7853981852531433,-1.0,-1.0}
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,10,1,1,2.0,0.30000001192092896,1.0646508932113647,0.5061454772949219,19)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i0=v.i0 + 1
        H.wait(b,v,125)
        v.time=120;return B.part2(b,v)
    end
    P[4][49]=B.part1
end

-- 第 4 面，原生 Sub50，起始 0xa044。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",17)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,3.1415927410125732)+-1.5707963705062866
        a.extra={180,1,-1,-1,v.f0,1.399999976158142,-1.0,-1.0}
        v.cmp=((224-player.y))-((224-b.y))
        if v.cmp>=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.pattern(b,1,3,6,7,2,2.799999952316284,1.2000000476837158,0.0,0.3490658402442932,4)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,132)
        v.time=120;return B.part2(b,v)
    end
    P[4][50]=B.part1
end

-- 第 4 面，原生 Sub51，起始 0xa27a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",21)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,3.1415927410125732)+-1.5707963705062866
        a.extra={50,2,-1,-1,v.f0,2.200000047683716,-1.0,-1.0}
        H.pattern(b,9,1,12,15,1,3.299999952316284,2.299999952316284,3.1415927410125732,0.0,67)
        v.cmp=((224-player.y))-((224-b.y))
        if v.cmp>=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.pattern(b,1,3,6,7,2,2.799999952316284,1.2000000476837158,0.0,0.3490658402442932,4)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,129)
        v.time=120;return B.part2(b,v)
    end
    P[4][51]=B.part1
end

-- 第 4 面，原生 Sub52，起始 0xa4dc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",25)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,3.1415927410125732)+-1.5707963705062866
        a.extra={90,1,-1,-1,v.f0,1.7999999523162842,-1.0,-1.0}
        H.pattern(b,9,1,12,18,1,2.4000000953674316,1.0,3.1415927410125732,0.0,67)
        v.cmp=((224-player.y))-((224-b.y))
        if v.cmp>0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.pattern(b,1,3,6,7,2,2.799999952316284,1.2000000476837158,0.0,0.3490658402442932,4)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i1=math.fmod(v.i0,3)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=120;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.pattern(b,3,9,3,7,1,3.4000000953674316,1.2000000476837158,0.0,0.39269909262657166,4)
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i0=v.i0 + 1
        H.wait(b,v,135)
        v.time=120;return B.part2(b,v)
    end
    P[4][52]=B.part1
end

-- 第 4 面，原生 Sub53，起始 0xa7ba。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",18)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.c0=8
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.extra={60,1,-1,-1,v.f1,2.0,-1.0,-1.0}
        H.pattern(b,4,6,6,8,1,4.0,1.0,v.f0,0.0,257)
        v.f1=(v.f1)+(0.7853981852531433)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,160)
        v.time=120;return B.part2(b,v)
    end
    P[4][53]=B.part1
end

-- 第 4 面，原生 Sub54，起始 0xa9cc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",26)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,2.5)+1.0
        v.f1=H.player_angle(b)
        a.extra={60,1,-1,-1,v.f1,v.f0,-1.0,-1.0}
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,3,15,10,3,6.0,0.5,v.f0,0.0,257)
        H.wait(b,v,170)
        v.time=120;return B.part2(b,v)
    end
    P[4][54]=B.part1
end

-- 第 4 面，原生 Sub55，起始 0xabf2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",27)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2400;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=8
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,7,0,20,2,2.5,0.699999988079071,v.f0,0.13089969754219055,0)
        H.wait(b,v,128)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,188)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        v.c0=3
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,188)
        v.f0=ran:Float(0,3.1415927410125732)+-1.5707963705062866
        v.i0=(v.c3)*(2)
        v.i0=(v.i0)+(24)
        a.extra={130,1,-1,-1,v.f0,2.0,-1.0,-1.0}
        H.pattern(b,9,1,13,v.i0,1,2.4000000953674316,1.0,3.1415927410125732,0.0,67)
        H.wait(b,v,198)
        v.c0=v.c0-1
        if v.c0>0 then v.time=188;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,198)
        v.time=120;return B.part2(b,v)
    end
    P[4][55]=B.part1
end

-- 第 4 面，原生 Sub56，起始 0xb004。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",28)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2400;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c1=math.fmod(v.i0,4)
        v.cmp=(v.c1)-(0)
        if v.cmp~=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.extra={-1,-1,-1,-1,0.012000000104308128,2.356194496154785,-1.0,-1.0}
        H.pattern(b,9,7,0,22,1,2.5,0.30000001192092896,3.1415927410125732,-3.1415927410125732,19)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.extra={60,-1,-1,-1,0.012000000104308128,2.356194496154785,-1.0,-1.0}
        v.f0=ran:Float(0,384.0)
        v.f0=(v.f0)-((b.x+192))
        v.f1=(32.0)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,2,1,1,1.2000000476837158,0.30000001192092896,2.6354472637176514,2.076941728591919,19)
        v.c1=math.fmod(v.i0,2)
        v.cmp=(v.c1)-(0)
        if v.cmp~=0 then v.time=122;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.f0=ran:Float(0,192.0)
        v.f1=(v.f0)-((224-b.y))
        v.f0=(380.0)-((b.x+192))
        v.time=122;return B.part7(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.f0=ran:Float(0,192.0)+192.0
        v.f1=(v.f0)-((224-b.y))
        v.f0=(380.0)-((b.x+192))
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,9,5,2,2,1,1.600000023841858,0.30000001192092896,2.6354472637176514,2.076941728591919,19)
        v.i0=v.i0 + 1
        H.wait(b,v,132)
        v.time=120;return B.part2(b,v)
    end
    P[4][56]=B.part1
end

-- 第 4 面，原生 Sub57，起始 0xb4ea。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",29)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2400;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        a.muted=true
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,20,false)
        v.i0=0
        v.f0=0.0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.pattern(b,3,3,8,32,2,2.799999952316284,1.2000000476837158,3.1415927410125732,0.3490658402442932,4)
        H.pattern(b,1,9,3,10,1,1.7999999523162842,0.699999988079071,v.f0,0.3490658402442932,0)
        v.f1=ran:Float(0,0.22439947724342346)+-0.11219973862171173
        v.f0=(v.f0)-(v.f1)
        H.wait(b,v,140)
        a.muted=true
        H.pattern(b,3,3,10,24,2,2.799999952316284,1.2000000476837158,3.1415927410125732,0.3490658402442932,4)
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,20,false)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        v.i0=math.fmod(v.c3,8)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=140;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,140)
        v.f0=0.0
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,190)
        v.time=120;return B.part2(b,v)
    end
    P[4][57]=B.part1
end

-- 第 4 面，原生 Sub58，起始 0xb97c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",30)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2400;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        v.i0=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=8
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.i0=(v.c3)*(1)
        v.i0=(v.i0)+(28)
        a.extra={90,-1,-1,-1,0.003000000026077032,0.012271846644580364,-1.0,-1.0}
        H.pattern(b,3,3,14,v.i0,2,1.5,0.800000011920929,v.f0,0.3490658402442932,37)
        H.wait(b,v,140)
        a.extra={90,-1,-1,-1,0.003000000026077032,-0.012271846644580364,-1.0,-1.0}
        H.pattern(b,3,3,8,v.i0,2,1.5,0.800000011920929,v.f0,-0.3490658402442932,37)
        H.wait(b,v,160)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,160)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,210)
        v.time=120;return B.part2(b,v)
    end
    P[4][58]=B.part1
end

-- 第 4 面，原生 Sub59，起始 0xbc82。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",31)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2400;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        H.sprite(b,66)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,288.0)+-144.0
        v.f1=ran:Float(0,128.0)+-64.0
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        v.f0=ran:Float(0,2.0)+1.600000023841858
        H.pattern(b,2,9,2,3,1,v.f0,0.800000011920929,1.5707963705062866,0.5235987901687622,4)
        v.i0=math.fmod(v.c3,18)
        v.cmp=(v.i0)-(7)
        if v.cmp~=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,121)
        v.f0=ran:Float(0,3.1415927410125732)+-1.5707963705062866
        a.extra={180,1,-1,-1,v.f0,1.7000000476837158,-1.0,-1.0}
        H.pattern(b,9,1,11,24,1,2.4000000953674316,1.0,3.1415927410125732,-3.1415927410125732,2)
        v.c3=v.c3 + 1
        H.wait(b,v,140)
        v.time=120;return B.part2(b,v)
    end
    P[4][59]=B.part1
end

-- 第 4 面，原生 Sub60，起始 0xc04c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.collidable=false
        a.damageable=false
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=0.6000000238418579;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.timeout=-1;a.phase=0
        a.life_threshold=-1
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.wait(b,v,4)
        H.wait(b,v,6)
        H.wait(b,v,8)
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        H.trace(b,"spell_end")
        if not a.main then b.hp=0 end
        H.wait(b,v,3010)
        H.erase(b)
    end
    P[4][60]=B.part1
end

-- 第 5 面，原生 Sub13，起始 0x1370。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.interactable=false
        H.sprite(b,128)
        H.clear_helpers(b)
        H.cancel(b)
        b.a,b.b,b.rect=(40.0)/2,(56.0)/2,true
        a.bounds={32.0,48.0,352.0,176.0}
        a.collidable=true
        a.damageable=true
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[5][17]
        a.death=P[5][16]
        a.life_threshold=710
        a.life_fn=P[5][18]
        H.position(b,192.0,128.0,0.0);H.clamp(b)
        H.wait(b,v,30)
        a.interactable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f1=0.0
        H.call(b,v,P[5][14],0,0.3141592741012573)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.f1=3.1415927410125732
        H.call(b,v,P[5][15],0,-0.3141592741012573)
        v.f1=3.1415927410125732
        H.wait(b,v,90)
        H.call(b,v,P[5][14],0,-0.3141592741012573)
        v.f1=0.0
        H.call(b,v,P[5][15],0,0.3141592741012573)
        H.wait(b,v,91)
        v.time=30;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,40091)
        H.erase(b)
    end
    P[5][13]=B.part1
end

-- 第 5 面，原生 Sub14，起始 0x15ec。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,8,3,8,1,3.200000047683716,1.0,v.f1,0.28559932112693787,0)
        v.f1=(v.f1)+(v.f0)
        H.wait(b,v,8)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,8)
        return
    end
    P[5][14]=B.part1
end

-- 第 5 面，原生 Sub15，起始 0x1718。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,4,2,5,3,2.0,1.0,v.f1,0.04487989470362663,0)
        v.f1=(v.f1)+(v.f0)
        H.wait(b,v,3)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,3)
        return
    end
    P[5][15]=B.part1
end

-- 第 5 面，原生 Sub16，起始 0x1834。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.call(b,v,P[5][17],0,0.0)
    end
    P[5][16]=B.part1
end

-- 第 5 面，原生 Sub17，起始 0x1898。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.sprite(b,128)
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        a.bounds=nil
        a.collidable=false
        a.damageable=false
        H.wait(b,v,130)
        H.move_to(b,60,192.0,-64.0,0.0,1)
        H.wait(b,v,190)
        H.erase(b)
    end
    P[5][17]=B.part1
end

-- 第 5 面，原生 Sub18，起始 0x197a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",33)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        a.phase=0
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[5][17]
        H.move_to(b,120,192.0,144.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.i0=H.random_int(2)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=120;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.call(b,v,P[5][19],0,0.0)
        v.time=120;return B.part5(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.call(b,v,P[5][20],0,0.0)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i0=(1)-(v.i0)
        v.time=120;return B.part2(b,v)
    end
    P[5][18]=B.part1
end

-- 第 5 面，原生 Sub19，起始 0x1af8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.move_to(b,40,96.0,144.0,0.0,1)
        a.muted=true
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.pattern(b,3,4,2,19,2,1.5,0.800000011920929,0.0,0.0,2052)
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,6,false)
        H.wait(b,v,30)
        H.sprite(b,135)
        H.wait(b,v,60)
        H.sprite(b,134)
        H.position(b,288.0,96.0,0.0);H.clamp(b)
        H.interval(b,0,false)
        H.wait(b,v,80)
        v.c0=3
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        H.pattern(b,1,8,3,11,4,6.5,1.2000000476837158,0.0,0.3141592741012573,516)
        H.wait(b,v,98)
        v.c0=v.c0-1
        if v.c0>0 then v.time=80;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,158)
        H.sprite(b,133)
        H.wait(b,v,218)
        H.sprite(b,134)
        H.position(b,192.0,144.0,0.0);H.clamp(b)
        H.wait(b,v,248)
        return
    end
    P[5][19]=B.part1
end

-- 第 5 面，原生 Sub20，起始 0x1d9c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.move_to(b,40,288.0,144.0,0.0,1)
        a.muted=true
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.pattern(b,3,4,2,16,2,1.5,0.800000011920929,0.0,0.0,2052)
        a.muted=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.interval(b,6,false)
        H.wait(b,v,30)
        H.sprite(b,137)
        H.wait(b,v,60)
        H.sprite(b,134)
        H.position(b,96.0,96.0,0.0);H.clamp(b)
        H.interval(b,0,false)
        H.wait(b,v,80)
        v.c0=3
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        H.pattern(b,1,8,3,11,4,6.5,1.2000000476837158,0.0,0.3141592741012573,516)
        H.wait(b,v,98)
        v.c0=v.c0-1
        if v.c0>0 then v.time=80;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,158)
        H.sprite(b,133)
        H.wait(b,v,218)
        H.sprite(b,134)
        H.position(b,192.0,144.0,0.0);H.clamp(b)
        H.wait(b,v,248)
        return
    end
    P[5][20]=B.part1
end

-- 第 5 面，原生 Sub22，起始 0x216c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        a.collidable=true
        if not a.main then b.hp=19000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,132.0}
        H.extra(b,v,4,0,false)
        a.timeout=2700;a.phase=0
        a.timeout_fn=P[5][44]
        a.life_threshold=1400
        a.life_fn=P[5][44]
        a.timeout_fn=P[5][45]
        a.life_fn=P[5][45]
        a.death=P[5][34]
        H.wait(b,v,10)
        H.wait(b,v,20)
        H.wait(b,v,30)
        H.wait(b,v,40)
        H.wait(b,v,100)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,100)
        H.call(b,v,P[5][23],0,0.0)
        a.muted=true
        H.pattern(b,3,8,3,16,2,3.0,1.0,0.0,0.15707963705062866,516)
        a.muted=false
        H.interval(b,40,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.7000000476837158;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,160)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.7000000476837158;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,220)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.7000000476837158;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.interval(b,0,true)
        H.call(b,v,P[5][24],0,0.0)
        H.wait(b,v,290)
        v.c3=v.c3 + 1
        H.wait(b,v,300)
        v.time=100;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9300)
        H.erase(b)
    end
    P[5][22]=B.part1
end

-- 第 5 面，原生 Sub23，起始 0x2590。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.spawn(b,5,25,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,26,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,27,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,28,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,31,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,32,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,29,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,30,(b.x+192),(224-b.y),a.z,100)
        H.wait(b,v,60)
        return
    end
    P[5][23]=B.part1
end

-- 第 5 面，原生 Sub24，起始 0x26c8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,170)
        v.c0=12
        v.f0=0.04908738657832146
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,170)
        H.pattern(b,2,8,2,4,8,4.0,1.2000000476837158,1.5707963705062866,v.f0,512)
        v.f0=(v.f0)+(0.3141592741012573)
        H.wait(b,v,178)
        v.c0=v.c0-1
        if v.c0>0 then v.time=170;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,238)
        return
    end
    P[5][24]=B.part1
end

-- 第 5 面，原生 Sub25，起始 0x27f8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,0.7853981852531433,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,6,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(0.6283185482025146)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][25]=B.part1
end

-- 第 5 面，原生 Sub26，起始 0x29e0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,0.0,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,10,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(-0.3141592741012573)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][26]=B.part1
end

-- 第 5 面，原生 Sub27，起始 0x2bc8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,2.356194496154785,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,10,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(-0.6283185482025146)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][27]=B.part1
end

-- 第 5 面，原生 Sub28，起始 0x2db0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,3.1415927410125732,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,6,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(0.3141592741012573)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][28]=B.part1
end

-- 第 5 面，原生 Sub29，起始 0x2f98。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,1.1780972480773926,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,6,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(0.6283185482025146)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][29]=B.part1
end

-- 第 5 面，原生 Sub30，起始 0x3180。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,1.9634953737258911,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,10,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(-0.6283185482025146)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][30]=B.part1
end

-- 第 5 面，原生 Sub31，起始 0x3368。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,0.39269909262657166,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,10,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(-0.3141592741012573)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][31]=B.part1
end

-- 第 5 面，原生 Sub32，起始 0x3550。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,2.7488934993743896,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        H.wait(b,v,50)
        v.c0=trunc((240)/(6))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,2,6,5,1,2.0,1.2000000476837158,v.f0,0.02617993950843811,512)
        v.i0=math.fmod(v.c0,16)
        v.f0=(v.f0)+(0.3141592741012573)
        H.wait(b,v,56)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,56)
        H.wait(b,v,116)
        H.erase(b)
    end
    P[5][32]=B.part1
end

-- 第 5 面，原生 Sub33，起始 0x3738。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,60)
        H.erase(b)
    end
    P[5][33]=B.part1
end

-- 第 5 面，原生 Sub34，起始 0x3764。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=17000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,132.0}
        H.extra(b,v,4,0,false)
        a.timeout=2700;a.phase=0
        a.timeout_fn=P[5][46]
        a.life_threshold=1400
        a.life_fn=P[5][46]
        a.death=P[5][41]
        a.timeout_fn=P[5][47]
        a.life_fn=P[5][47]
        H.wait(b,v,60)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.call(b,v,P[5][35],0,0.0)
        a.muted=true
        H.pattern(b,3,8,3,16,2,2.5,1.0,0.0,0.15707963705062866,516)
        a.muted=false
        H.interval(b,40,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,120)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,180)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.interval(b,0,true)
        H.call(b,v,P[5][40],0,0.0)
        H.wait(b,v,250)
        v.c3=v.c3 + 1
        H.wait(b,v,260)
        v.time=60;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9260)
        H.erase(b)
    end
    P[5][34]=B.part1
end

-- 第 5 面，原生 Sub35，起始 0x3b00。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.spawn(b,5,36,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,37,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,38,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,5,39,(b.x+192),(224-b.y),a.z,100)
        H.wait(b,v,60)
        return
    end
    P[5][35]=B.part1
end

-- 第 5 面，原生 Sub36，起始 0x3ba8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,0.7853981852531433,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        a.extra={2,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.wait(b,v,50)
        v.c0=trunc((250)/(14))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,4,2,5,1,2.200000047683716,1.2000000476837158,v.f0,0.015707964077591896,2560)
        v.f0=(v.f0)+(0.6283185482025146)
        H.wait(b,v,64)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,64)
        H.wait(b,v,124)
        H.erase(b)
    end
    P[5][36]=B.part1
end

-- 第 5 面，原生 Sub37，起始 0x3e28。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,0.0,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        a.extra={2,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.wait(b,v,50)
        v.c0=trunc((250)/(14))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,4,6,5,1,2.200000047683716,1.2000000476837158,v.f0,0.015707964077591896,2560)
        v.f0=(v.f0)+(-0.19634954631328583)
        H.wait(b,v,64)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,64)
        H.wait(b,v,124)
        H.erase(b)
    end
    P[5][37]=B.part1
end

-- 第 5 面，原生 Sub38，起始 0x40a8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,2.356194496154785,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        a.extra={2,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.wait(b,v,50)
        v.c0=trunc((250)/(14))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,4,6,5,1,2.200000047683716,1.2000000476837158,v.f0,0.015707964077591896,2560)
        v.f0=(v.f0)+(-0.6283185482025146)
        H.wait(b,v,64)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,64)
        H.wait(b,v,124)
        H.erase(b)
    end
    P[5][38]=B.part1
end

-- 第 5 面，原生 Sub39，起始 0x4328。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.move_dir(b,370,3.1415927410125732,0.800000011920929,1)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[5][33]
        a.interactable=false
        a.extra={2,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.wait(b,v,50)
        v.c0=trunc((250)/(14))
        v.f0=v.f0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        H.pattern(b,2,4,2,5,1,2.200000047683716,1.2000000476837158,v.f0,0.015707964077591896,2560)
        v.f0=(v.f0)+(0.19634954631328583)
        H.wait(b,v,64)
        v.c0=v.c0-1
        if v.c0>0 then v.time=50;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,64)
        H.wait(b,v,124)
        H.erase(b)
    end
    P[5][39]=B.part1
end

-- 第 5 面，原生 Sub40，起始 0x45a8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,100)
        v.c0=12
        v.f0=0.04908738657832146
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.pattern(b,4,8,3,24,1,2.0,1.2000000476837158,1.5707963705062866,v.f0,512)
        H.wait(b,v,160)
        return
    end
    P[5][40]=B.part1
end

-- 第 5 面，原生 Sub41，起始 0x4624。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=16000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,132.0}
        H.extra(b,v,4,0,false)
        a.timeout=2700;a.phase=0
        a.timeout_fn=P[5][50]
        a.life_threshold=1700
        a.life_fn=P[5][50]
        a.death=P[5][51]
        H.wait(b,v,60)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.call(b,v,P[5][42],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,50,a.angle,a.speed,1)
        H.wait(b,v,120)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.0;a.mode="velocity"
        H.move_dir(b,50,a.angle,a.speed,1)
        H.call(b,v,P[5][43],0,0.0)
        H.wait(b,v,220)
        v.c3=v.c3 + 1
        H.wait(b,v,230)
        v.time=60;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9230)
        H.erase(b)
    end
    P[5][41]=B.part1
end

-- 第 5 面，原生 Sub42，起始 0x4844。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={2,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,4,8,3,5,2,1.7999999523162842,1.2000000476837158,v.f0,0.015707964077591896,2560)
        v.f0=(v.f0)+(0.09817477315664291)
        H.wait(b,v,5)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        return
    end
    P[5][42]=B.part1
end

-- 第 5 面，原生 Sub43，起始 0x4a18。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={2,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,4,8,1,5,2,2.0,1.2000000476837158,v.f0,0.015707964077591896,2560)
        v.f0=(v.f0)-(0.09817477315664291)
        H.wait(b,v,5)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,65)
        return
    end
    P[5][43]=B.part1
end

-- 第 5 面，原生 Sub44，起始 0x4bec。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",34)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.phase=0
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[5][34]
        H.move_to(b,120,192.0,112.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=32
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,214)
        H.extra(b,v,4,1,false)
        a.interactable=false
        v.i0=0
        v.repeat_func=5
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,304)
        v.c0=8
        v.repeat_func=nil
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,304)
        H.wait(b,v,308)
        v.c0=v.c0-1
        if v.c0>0 then v.time=304;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,338)
        H.extra(b,v,4,0,false)
        a.interactable=true
        H.wait(b,v,368)
        v.time=120;return B.part2(b,v)
    end
    P[5][44]=B.part1
end

-- 第 5 面，原生 Sub45，起始 0x4e8e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",37)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.phase=0
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[5][34]
        H.move_to(b,120,192.0,112.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=32
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,144)
        H.pattern(b,9,9,0,35,1,5.0,1.2000000476837158,3.1415927410125732,0.0,512)
        H.wait(b,v,194)
        H.extra(b,v,4,1,false)
        a.interactable=false
        v.i0=0
        v.repeat_func=5
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,284)
        v.c0=8
        v.repeat_func=nil
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,284)
        H.wait(b,v,288)
        v.c0=v.c0-1
        if v.c0>0 then v.time=284;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,318)
        H.extra(b,v,4,0,false)
        a.interactable=true
        H.wait(b,v,418)
        v.time=120;return B.part2(b,v)
    end
    P[5][45]=B.part1
end

-- 第 5 面，原生 Sub46，起始 0x5130。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",35)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.phase=0
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[5][41]
        H.move_to(b,120,192.0,112.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=32
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,194)
        H.extra(b,v,4,1,false)
        a.interactable=false
        v.i0=0
        v.repeat_func=5
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,254)
        v.c0=6
        v.repeat_func=nil
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,254)
        H.extra(b,v,4,2,false)
        H.wait(b,v,259)
        v.c0=v.c0-1
        if v.c0>0 then v.time=254;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,289)
        H.extra(b,v,4,0,false)
        a.interactable=true
        H.wait(b,v,389)
        v.time=120;return B.part2(b,v)
    end
    P[5][46]=B.part1
end

-- 第 5 面，原生 Sub47，起始 0x53ba。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",38)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.phase=0
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[5][41]
        H.move_to(b,120,192.0,112.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=32
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,144)
        H.pattern(b,4,7,1,12,4,2.200000047683716,1.2000000476837158,0.0,0.0,512)
        H.pattern(b,4,7,1,14,4,2.200000047683716,1.2000000476837158,0.0,0.0,512)
        H.wait(b,v,194)
        H.extra(b,v,4,1,false)
        a.interactable=false
        v.i0=0
        v.repeat_func=5
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,254)
        v.c0=6
        v.repeat_func=nil
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,254)
        H.extra(b,v,4,2,false)
        H.wait(b,v,259)
        v.c0=v.c0-1
        if v.c0>0 then v.time=254;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,289)
        H.extra(b,v,4,0,false)
        a.interactable=true
        H.wait(b,v,389)
        v.time=120;return B.part2(b,v)
    end
    P[5][47]=B.part1
end

-- 第 5 面，原生 Sub48，起始 0x5684。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=8
        v.f0=H.player_angle(b)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,4,8,3,15,3,2.0,1.0,v.f0,0.0,512)
        v.f0=(v.f0)+(0.7853981852531433)
        H.wait(b,v,4)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,25)
        return
    end
    P[5][48]=B.part1
end

-- 第 5 面，原生 Sub49，起始 0x57fc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=8
        v.f0=H.player_angle(b)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,8,1,7,4,2.799999952316284,1.0,v.f0,0.039269909262657166,512)
        v.f0=(v.f0)-(0.7853981852531433)
        H.wait(b,v,2)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,23)
        return
    end
    P[5][49]=B.part1
end

-- 第 5 面，原生 Sub50，起始 0x5992。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",39)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.phase=0
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[5][51]
        H.move_to(b,120,192.0,144.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.call(b,v,P[5][48],0,0.0)
        H.call(b,v,P[5][49],0,0.0)
        H.extra(b,v,4,1,false)
        a.interactable=false
        v.i0=0
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,140)
        v.c0=7
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,140)
        H.extra(b,v,4,2,false)
        H.wait(b,v,144)
        v.c0=v.c0-1
        if v.c0>0 then v.time=140;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,174)
        H.extra(b,v,4,0,false)
        a.interactable=true
        H.wait(b,v,274)
        v.time=120;return B.part2(b,v)
    end
    P[5][50]=B.part1
end

-- 第 5 面，原生 Sub51，起始 0x5bbc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.collidable=false
        a.damageable=false
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=0.6000000238418579;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.timeout=-1;a.phase=0
        a.life_threshold=-1
        H.extra(b,v,4,0,false)
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.wait(b,v,4)
        H.wait(b,v,6)
        H.wait(b,v,8)
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        H.trace(b,"spell_end")
        if not a.main then b.hp=0 end
        H.wait(b,v,3010)
        H.erase(b)
    end
    P[5][51]=B.part1
end

-- 第 6 面，原生 Sub9，起始 0xa48。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.interactable=false
        H.sprite(b,128)
        H.clear_helpers(b)
        H.cancel(b)
        b.a,b.b,b.rect=(40.0)/2,(56.0)/2,true
        a.bounds={32.0,48.0,352.0,120.0}
        a.collidable=true
        a.damageable=true
        a.timeout=1020;a.phase=0
        a.timeout_fn=P[6][13]
        a.death=P[6][12]
        v.cmp=((a.meta.shot or 0))-(0)
        if v.cmp~=0 then v.time=0;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.life_threshold=750
        a.life_fn=P[6][14]
        v.time=0;return B.part9(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(1)
        if v.cmp~=0 then v.time=0;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.life_threshold=1000
        a.life_fn=P[6][14]
        v.time=0;return B.part9(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(2)
        if v.cmp~=0 then v.time=0;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.life_threshold=1100
        a.life_fn=P[6][14]
        v.time=0;return B.part9(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=((a.meta.shot or 0))-(3)
        if v.cmp~=0 then v.time=0;return B.part9(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.life_threshold=1100
        a.life_fn=P[6][14]
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.position(b,192.0,128.0,0.0);H.clamp(b)
        H.wait(b,v,30)
        a.interactable=true
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f1=0.0
        H.call(b,v,P[6][10],0,0.2617993950843811)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.call(b,v,P[6][11],0,0.0)
        v.f1=3.1415927410125732
        H.wait(b,v,31)
        H.call(b,v,P[6][10],0,-0.2617993950843811)
        H.call(b,v,P[6][11],0,0.0)
        H.wait(b,v,32)
        v.time=30;return B.part10(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,40032)
        H.erase(b)
    end
    P[6][9]=B.part1
end

-- 第 6 面，原生 Sub10，起始 0xe28。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=12
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,8,3,12,1,4.800000190734863,1.0,v.f1,0.2617993950843811,0)
        v.f1=(v.f1)+(v.f0)
        H.wait(b,v,4)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        return
    end
    P[6][10]=B.part1
end

-- 第 6 面，原生 Sub11，起始 0xf54。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=16
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f1=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f2=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={60,1,-1,-1,v.f2,-999.0,-1.0,-1.0}
        H.wait(b,v,1)
        H.pattern(b,2,4,2,9,1,2.5,1.0,v.f1,0.03490658476948738,66)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        return
    end
    P[6][11]=B.part1
end

-- 第 6 面，原生 Sub12，起始 0x10b4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.call(b,v,P[6][13],0,0.0)
    end
    P[6][12]=B.part1
end

-- 第 6 面，原生 Sub13，起始 0x1118。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        H.sprite(b,128)
        H.trace(b,"spell_end")
        H.interval(b,0,false)
        a.bounds=nil
        a.collidable=false
        a.damageable=false
        H.erase(b)
    end
    P[6][13]=B.part1
end

-- 第 6 面，原生 Sub14，起始 0x11ac。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",40)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        a.phase=0
        a.timeout=900;a.phase=0
        a.timeout_fn=P[6][13]
        H.move_to(b,120,192.0,144.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        a.extra={1,-1,-1,-1,0.05999999865889549,-999.0,-1.0,-1.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.pattern(b,9,3,6,9,1,6.0,3.0,3.1415927410125732,0.0,4)
        H.pattern(b,9,3,6,12,1,5.0,3.0,0.0,-3.1415927410125732,4)
        H.wait(b,v,124)
        v.time=120;return B.part2(b,v)
    end
    P[6][14]=B.part1
end

-- 第 6 面，原生 Sub17，起始 0x152e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        a.collidable=true
        if not a.main then b.hp=13000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        H.extra(b,v,4,0,false)
        a.timeout=2700;a.phase=0
        a.timeout_fn=P[6][31]
        a.life_threshold=1200
        a.life_fn=P[6][31]
        a.death=P[6][19]
        H.wait(b,v,10)
        H.wait(b,v,20)
        H.wait(b,v,30)
        H.wait(b,v,40)
        H.wait(b,v,100)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,100)
        H.call(b,v,P[6][18],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.call(b,v,P[6][18],0,0.0)
        H.wait(b,v,200)
        v.c3=v.c3 + 1
        H.wait(b,v,210)
        v.time=100;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9210)
        H.erase(b)
    end
    P[6][17]=B.part1
end

-- 第 6 面，原生 Sub18，起始 0x17be。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=32
        v.f0=0.04908738657832146
        v.f1=-1.5707963705062866
        v.f2=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,3,5,5,1,2.4000000953674316,1.2000000476837158,v.f0,0.09817477315664291,512)
        v.f0=(v.f0)+(0.6283185482025146)
        H.pattern(b,2,9,0,6,1,3.5,1.2000000476837158,v.f1,1.0471975803375244,512)
        v.f1=(v.f1)-(0.39269909262657166)
        H.pattern(b,2,6,3,6,1,2.5,1.2000000476837158,v.f2,0.7853981852531433,512)
        v.f2=(v.f2)+(3.1415927410125732)
        H.pattern(b,2,6,3,6,1,2.5,1.2000000476837158,v.f2,0.7853981852531433,512)
        v.f2=(v.f2)-(3.1415927410125732)
        v.f2=(v.f2)+(0.15707963705062866)
        H.wait(b,v,8)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,18)
        return
    end
    P[6][18]=B.part1
end

-- 第 6 面，原生 Sub19，起始 0x1b7a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=15500 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        H.extra(b,v,4,0,false)
        a.timeout=2700;a.phase=0
        a.timeout_fn=P[6][33]
        a.life_threshold=1600
        a.life_fn=P[6][33]
        a.death=P[6][23]
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.800000011920929,0,0,0,0
        H.wait(b,v,60)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.phase=(a.phase)+(30)
        H.wait(b,v,150)
        H.call(b,v,P[6][20],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.phase=(a.phase)+(30)
        H.wait(b,v,240)
        H.call(b,v,P[6][21],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.phase=(a.phase)+(30)
        H.wait(b,v,330)
        H.call(b,v,P[6][22],0,0.0)
        H.call(b,v,P[6][20],0,0.0)
        v.c3=v.c3 + 1
        H.wait(b,v,340)
        v.time=60;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9340)
        H.erase(b)
    end
    P[6][19]=B.part1
end

-- 第 6 面，原生 Sub20，起始 0x1ece。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c1=8
        v.c0=20
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,5)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        H.pattern(b,1,9,0,1,1,6.0,1.2000000476837158,0.0,0.0,4)
        v.f0=(H.player_angle(b))-(0.09817477315664291)
        v.f1=(H.player_angle(b))+(0.09817477315664291)
        H.pattern(b,9,6,1,5,1,6.0,5.0,v.f0,v.f1,4)
        v.f0=(H.player_angle(b))-(0.15707963705062866)
        v.f1=(H.player_angle(b))+(0.15707963705062866)
        H.pattern(b,9,6,1,5,1,5.0,4.0,v.f0,v.f1,4)
        v.f0=(H.player_angle(b))-(0.3141592741012573)
        v.f1=(H.player_angle(b))+(0.3141592741012573)
        H.pattern(b,9,1,2,5,1,4.0,2.0,v.f0,v.f1,4)
        v.f0=(H.player_angle(b))-(0.7853981852531433)
        v.f1=(H.player_angle(b))+(0.7853981852531433)
        H.pattern(b,9,1,2,5,1,2.0,1.0,v.f0,v.f1,4)
        v.cmp=((a.stage==7 and 4 or 3))-(8)
        if v.cmp~=0 then v.time=5;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.f0=(H.player_angle(b))-(1.5707963705062866)
        v.f1=(H.player_angle(b))+(1.5707963705062866)
        H.pattern(b,9,1,2,12,1,3.0,1.0,v.f0,v.f1,4)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,15)
        v.c1=v.c1-1
        if v.c1>0 then v.time=5;return B.part3(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,25)
        return
    end
    P[6][20]=B.part1
end

-- 第 6 面，原生 Sub21，起始 0x21ae。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c1=8
        v.c0=20
        v.f2=0.0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,5)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        H.pattern(b,2,9,0,1,1,7.0,1.2000000476837158,v.f2,0.0,4)
        v.f0=(v.f2)-(0.09817477315664291)
        v.f1=(v.f2)+(0.09817477315664291)
        H.pattern(b,9,6,1,3,1,6.0,5.0,v.f0,v.f1,4)
        v.f0=(v.f2)-(0.15707963705062866)
        v.f1=(v.f2)+(0.15707963705062866)
        H.pattern(b,9,6,1,5,1,5.0,4.0,v.f0,v.f1,4)
        v.f0=(v.f2)-(0.3141592741012573)
        v.f1=(v.f2)+(0.3141592741012573)
        H.pattern(b,9,1,2,5,1,4.0,2.0,v.f0,v.f1,4)
        v.f0=(v.f2)-(0.7853981852531433)
        v.f1=(v.f2)+(0.7853981852531433)
        H.pattern(b,9,1,2,5,1,2.0,1.0,v.f0,v.f1,4)
        v.cmp=((a.stage==7 and 4 or 3))-(4)
        if v.cmp~=0 then v.time=5;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.f0=(v.f2)-(1.5707963705062866)
        v.f1=(v.f2)+(1.5707963705062866)
        H.pattern(b,9,1,2,16,1,3.0,1.0,v.f0,v.f1,4)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.cmp=((a.stage==7 and 4 or 3))-(8)
        if v.cmp~=0 then v.time=5;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.f0=(v.f2)-(1.5707963705062866)
        v.f1=(v.f2)+(1.5707963705062866)
        H.pattern(b,9,1,2,32,1,4.0,1.0,v.f0,v.f1,4)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.f2=(v.f2)+(0.39269909262657166)
        H.wait(b,v,13)
        v.c1=v.c1-1
        if v.c1>0 then v.time=5;return B.part3(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,20)
        return
    end
    P[6][21]=B.part1
end

-- 第 6 面，原生 Sub22，起始 0x253e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c1=8
        v.c0=20
        v.f2=3.1415927410125732
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,5)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        H.pattern(b,2,9,0,1,1,7.0,1.2000000476837158,v.f2,0.0,4)
        v.f0=(v.f2)-(0.09817477315664291)
        v.f1=(v.f2)+(0.09817477315664291)
        H.pattern(b,9,6,1,3,1,6.0,5.0,v.f0,v.f1,4)
        v.f0=(v.f2)-(0.15707963705062866)
        v.f1=(v.f2)+(0.15707963705062866)
        H.pattern(b,9,6,1,5,1,5.0,4.0,v.f0,v.f1,4)
        v.f0=(v.f2)-(0.3141592741012573)
        v.f1=(v.f2)+(0.3141592741012573)
        H.pattern(b,9,1,2,5,1,4.0,2.0,v.f0,v.f1,4)
        v.f0=(v.f2)-(0.7853981852531433)
        v.f1=(v.f2)+(0.7853981852531433)
        H.pattern(b,9,1,2,5,1,2.0,1.0,v.f0,v.f1,4)
        v.cmp=((a.stage==7 and 4 or 3))-(4)
        if v.cmp~=0 then v.time=5;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.f0=(v.f2)-(1.5707963705062866)
        v.f1=(v.f2)+(1.5707963705062866)
        H.pattern(b,9,1,2,8,1,3.0,1.0,v.f0,v.f1,4)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.cmp=((a.stage==7 and 4 or 3))-(8)
        if v.cmp~=0 then v.time=5;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.f0=(v.f2)-(1.5707963705062866)
        v.f1=(v.f2)+(1.5707963705062866)
        H.pattern(b,9,1,2,24,1,3.0,1.0,v.f0,v.f1,4)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        v.f2=(v.f2)+(-0.39269909262657166)
        H.wait(b,v,13)
        v.c1=v.c1-1
        if v.c1>0 then v.time=5;return B.part3(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,20)
        return
    end
    P[6][22]=B.part1
end

-- 第 6 面，原生 Sub23，起始 0x28ce。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=11000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        H.extra(b,v,4,0,false)
        a.timeout=2700;a.phase=0
        a.timeout_fn=P[6][35]
        a.life_threshold=1600
        a.life_fn=P[6][35]
        a.death=P[6][26]
        H.wait(b,v,60)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.call(b,v,P[6][24],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,188)
        H.call(b,v,P[6][25],0,0.0)
        H.wait(b,v,288)
        v.c3=v.c3 + 1
        H.wait(b,v,298)
        v.time=60;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9298)
        H.erase(b)
    end
    P[6][23]=B.part1
end

-- 第 6 面，原生 Sub24，起始 0x2ada。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=60
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,4,8,1,4,2,6.0,3.200000047683716,v.f0,0.0,512)
        v.f0=(v.f0)+(0.09817477315664291)
        H.wait(b,v,2)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        return
    end
    P[6][24]=B.part1
end

-- 第 6 面，原生 Sub25，起始 0x2c2a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=60
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,4,8,3,4,2,6.0,3.200000047683716,v.f0,0.0,512)
        v.f0=(v.f0)-(0.09817477315664291)
        H.wait(b,v,2)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        return
    end
    P[6][25]=B.part1
end

-- 第 6 面，原生 Sub26，起始 0x2d7a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=13000 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        H.extra(b,v,4,0,false)
        a.timeout=3600;a.phase=0
        a.timeout_fn=P[6][39]
        a.life_threshold=1300
        a.life_fn=P[6][39]
        a.death=P[6][43]
        H.wait(b,v,60)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.call(b,v,P[6][27],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=4.0;a.mode="velocity"
        H.move_dir(b,30,a.angle,a.speed,1)
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=7.0;a.mode="velocity"
        H.move_dir(b,30,a.angle,a.speed,1)
        H.wait(b,v,120)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=4.0;a.mode="velocity"
        H.move_dir(b,30,a.angle,a.speed,1)
        H.wait(b,v,150)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=7.0;a.mode="velocity"
        H.move_dir(b,30,a.angle,a.speed,1)
        H.wait(b,v,180)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=4.0;a.mode="velocity"
        H.move_dir(b,30,a.angle,a.speed,1)
        H.wait(b,v,210)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=7.0;a.mode="velocity"
        H.move_dir(b,30,a.angle,a.speed,1)
        H.wait(b,v,240)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=4.0;a.mode="velocity"
        H.move_dir(b,30,a.angle,a.speed,1)
        H.wait(b,v,270)
        H.call(b,v,P[6][28],0,0.0)
        H.wait(b,v,350)
        v.c3=v.c3 + 1
        H.wait(b,v,360)
        v.time=60;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9360)
        H.erase(b)
    end
    P[6][26]=B.part1
end

-- 第 6 面，原生 Sub27，起始 0x30d6。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c1=5
        v.c0=20
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,5)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        H.sprite(b,165)
        a.interactable=false
        v.c0=30
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,5)
        H.spawn(b,6,29,(b.x+192),(224-b.y),a.z,100)
        H.spawn(b,6,29,(b.x+192),(224-b.y),a.z,100)
        H.wait(b,v,6)
        v.c0=v.c0-1
        if v.c0>0 then v.time=5;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,6)
        v.i0=math.fmod(v.c3,3)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=6;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,6)
        a.sound=25;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.extra={-1,-1,-1,-1,0.02500000037252903,1.5707963705062866,-1.0,-1.0}
        a.muted=true
        H.pattern(b,9,2,2,20,1,2.5,1.0,3.1415927410125732,-3.1415927410125732,528)
        a.muted=false
        H.interval(b,8,false)
        v.time=6;return B.part10(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,6)
        v.cmp=(v.i0)-(1)
        if v.cmp~=0 then v.time=6;return B.part9(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,6)
        a.sound=25;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.extra={-1,-1,-1,-1,0.02500000037252903,1.5707963705062866,-1.0,-1.0}
        a.muted=true
        H.pattern(b,1,9,0,13,1,8.0,1.0,0.0,0.19634954631328583,528)
        a.muted=false
        H.interval(b,16,false)
        v.time=6;return B.part10(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,6)
        a.sound=25;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.extra={-1,-1,-1,-1,0.02500000037252903,1.5707963705062866,-1.0,-1.0}
        a.muted=true
        H.pattern(b,3,7,1,20,2,6.0,2.0,0.0,0.0,528)
        a.muted=false
        H.interval(b,10,false)
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,6)
        return
    end
    P[6][27]=B.part1
end

-- 第 6 面，原生 Sub28，起始 0x35ce。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,160)
        H.interval(b,0,false)
        a.interactable=true
        return
    end
    P[6][28]=B.part1
end

-- 第 6 面，原生 Sub29，起始 0x3646。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,165)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.interactable=false
        v.f0=ran:Float(0,3.1415927410125732)
        v.f1=ran:Float(0,0.7853981852531433)+-0.39269909262657166
        v.f1=(v.f1)/(20.0)
        v.f2=ran:Float(0,4.0)+5.0
        a.angle,a.speed=v.f0,v.f2;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=v.f1;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[6][29]=B.part1
end

-- 第 6 面，原生 Sub31，起始 0x3a38。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",46)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.phase=0
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[6][19]
        H.move_to(b,120,192.0,112.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=16
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        H.extra(b,v,7,0,false)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.c0=4
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        a.extra={120,-1,-1,-1,0.014999999664723873,-999.0,-1.0,-1.0}
        H.pattern(b,4,9,3,12,1,0.800000011920929,1.0,v.f0,0.0,528)
        H.pattern(b,4,6,3,14,2,1.5,0.5,v.f1,0.0,528)
        v.f0=(v.f0)+(0.19634954631328583)
        v.f1=(v.f1)-(0.09817477315664291)
        H.wait(b,v,140)
        v.c0=v.c0-1
        if v.c0>0 then v.time=124;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,140)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,200)
        v.time=120;return B.part2(b,v)
    end
    P[6][31]=B.part1
end

-- 第 6 面，原生 Sub33，起始 0x40d8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",47)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.phase=0
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[6][23]
        H.move_to(b,120,192.0,144.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        a.sound=23;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=5
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.extra={100,-1,-1,-1,0.0,0.03141592815518379,-1.0,-1.0}
        H.pattern(b,4,8,1,16,1,2.0,1.0,v.f0,-0.015707964077591896,544)
        v.f0=(v.f0)+(0.09817477315664291)
        H.wait(b,v,123)
        a.extra={100,-1,-1,-1,0.0,-0.03141592815518379,-1.0,-1.0}
        H.pattern(b,4,8,1,16,1,2.0,1.0,v.f0,-0.015707964077591896,544)
        v.f0=(v.f0)+(0.09817477315664291)
        H.wait(b,v,126)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.pattern(b,4,5,2,32,1,1.2999999523162842,1.0,v.f0,-0.015707964077591896,2560)
        v.f0=(v.f0)+(0.09817477315664291)
        H.wait(b,v,129)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        H.pattern(b,4,5,2,32,1,1.2999999523162842,1.0,v.f0,-0.015707964077591896,2560)
        v.f0=(v.f0)+(0.09817477315664291)
        H.wait(b,v,137)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,137)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,187)
        v.time=120;return B.part2(b,v)
    end
    P[6][33]=B.part1
end

-- 第 6 面，原生 Sub35，起始 0x4828。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.interactable=true
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",48)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.phase=0
        a.timeout=2400;a.phase=0
        a.timeout_fn=P[6][26]
        v.c3=0
        H.move_to(b,120,192.0,108.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i0=math.fmod(v.c3,2)
        H.pattern(b,1,9,1,8,1,7.0,2.0,0.0,-0.3141592741012573,516)
        v.c0=48
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.extra(b,v,8,0,false)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=120;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.time=124;return B.part6(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.cmp=(v.c0)-(32)
        if v.cmp>=0 then v.time=124;return B.part8(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        H.extra(b,v,9,0,false)
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,148)
        v.time=120;return B.part2(b,v)
    end
    P[6][35]=B.part1
end

-- 第 6 面，原生 Sub37，起始 0x4ca2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,9,0,1,1,6.199999809265137,1.2000000476837158,v.f2,0.0,2)
        v.f0=(v.f2)-(0.09817477315664291)
        v.f1=(v.f2)+(0.09817477315664291)
        H.pattern(b,9,6,1,3,1,6.0,4.0,v.f0,v.f1,2)
        v.f0=(v.f2)-(0.15707963705062866)
        v.f1=(v.f2)+(0.15707963705062866)
        H.pattern(b,9,6,1,5,1,4.0,3.0,v.f0,v.f1,2)
        v.f0=(v.f2)-(0.39269909262657166)
        v.f1=(v.f2)+(0.39269909262657166)
        H.pattern(b,9,1,2,10,1,3.0,2.0,v.f0,v.f1,0)
        v.f0=(v.f2)-(0.7853981852531433)
        v.f1=(v.f2)+(0.7853981852531433)
        H.pattern(b,9,1,2,5,1,2.0,1.0,v.f0,v.f1,0)
        return
    end
    P[6][37]=B.part1
end

-- 第 6 面，原生 Sub39，起始 0x5528。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,160)
        a.interactable=true
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",49)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.phase=0
        a.death=P[6][44]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[6][44]
        v.c3=0
        H.move_to(b,120,192.0,112.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=16
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.f2=H.player_angle(b)
        H.call(b,v,P[6][37],0,0.0)
        H.wait(b,v,130)
        v.f2=H.player_angle(b)
        H.call(b,v,P[6][37],0,0.0)
        H.wait(b,v,136)
        v.f2=H.player_angle(b)
        H.call(b,v,P[6][37],0,0.0)
        H.wait(b,v,142)
        v.f2=H.player_angle(b)
        H.call(b,v,P[6][37],0,0.0)
        H.wait(b,v,148)
        v.f2=H.player_angle(b)
        H.call(b,v,P[6][37],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,154)
        v.f2=H.player_angle(b)
        v.c0=17
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,154)
        H.call(b,v,P[6][37],0,0.0)
        v.f2=(v.f2)+(0.39269909262657166)
        v.f2=normal_angle(v.f2)
        H.wait(b,v,157)
        v.c0=v.c0-1
        if v.c0>0 then v.time=154;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,237)
        v.f2=H.player_angle(b)
        H.call(b,v,P[6][37],0,0.0)
        H.wait(b,v,243)
        v.f2=H.player_angle(b)
        H.call(b,v,P[6][37],0,0.0)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,249)
        v.f2=H.player_angle(b)
        v.c0=17
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,249)
        H.call(b,v,P[6][37],0,0.0)
        v.f2=(v.f2)-(0.39269909262657166)
        v.f2=normal_angle(v.f2)
        H.wait(b,v,252)
        v.c0=v.c0-1
        if v.c0>0 then v.time=249;return B.part7(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,252)
        v.c0=24
        v.c3=v.c3 + 1
        H.wait(b,v,332)
        v.time=120;return B.part2(b,v)
    end
    P[6][39]=B.part1
end

-- 第 6 面，原生 Sub40，起始 0x5a86。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,8,0,false)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.time=17;return B.part5(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,17)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,17)
        return
    end
    P[6][40]=B.part1
end

-- 第 6 面，原生 Sub41，起始 0x5b1a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=20
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.extra(b,v,8,0,false)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.time=10;return B.part5(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        return
    end
    P[6][41]=B.part1
end

-- 第 6 面，原生 Sub43，起始 0x5c7a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=4700 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=10
        a.death=P[6][45]
        H.wait(b,v,60)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",45)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.phase=0
        a.timeout=7200;a.phase=0
        a.timeout_fn=P[6][45]
        v.c3=0
        H.move_to(b,120,192.0,128.0,0.0,1)
        H.wait(b,v,180)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,180)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,9,1,10,1,2.0,1.0,v.f0,-0.015707964077591896,2560)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.call(b,v,P[6][40],0,0.0)
        H.wait(b,v,196)
        H.extra(b,v,9,0,false)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,9,1,12,1,2.0,1.0,v.f0,-0.015707964077591896,2560)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.call(b,v,P[6][40],0,0.0)
        H.extra(b,v,9,0,false)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,9,1,8,1,2.0,1.0,v.f0,-0.015707964077591896,2560)
        H.call(b,v,P[6][40],0,0.0)
        H.extra(b,v,9,0,false)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.wait(b,v,246)
        H.pattern(b,4,9,1,15,1,2.0,1.0,v.f0,-0.015707964077591896,2560)
        H.call(b,v,P[6][40],0,0.0)
        H.extra(b,v,9,0,false)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.wait(b,v,286)
        H.pattern(b,4,9,1,8,2,4.0,1.0,v.f0,-0.39269909262657166,512)
        H.call(b,v,P[6][40],0,0.0)
        H.extra(b,v,9,0,false)
        v.c3=v.c3 + 1
        H.wait(b,v,386)
        v.time=180;return B.part2(b,v)
    end
    P[6][43]=B.part1
end

-- 第 6 面，原生 Sub44，起始 0x627c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=true
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=5300 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=10
        a.death=P[6][45]
        H.wait(b,v,60)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",50)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        H.interval(b,0,true)
        H.clear_helpers(b)
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.phase=0
        a.timeout=8400;a.phase=0
        a.timeout_fn=P[6][45]
        v.c3=0
        H.move_to(b,120,192.0,128.0,0.0,1)
        H.wait(b,v,180)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,180)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={120,-1,-1,-1,0.023000000044703484,0.02454369328916073,-1.0,-1.0}
        H.pattern(b,4,9,1,14,4,4.0,1.7999999523162842,v.f0,-0.3141592741012573,512)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.call(b,v,P[6][41],0,0.0)
        H.extra(b,v,11,0,false)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={80,-1,-1,-1,0.023000000044703484,-0.02454369328916073,-1.0,-1.0}
        H.pattern(b,4,9,1,12,1,2.0,1.0,v.f0,-0.015707964077591896,544)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.call(b,v,P[6][41],0,0.0)
        H.extra(b,v,9,0,false)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={60,-1,-1,-1,0.026000000536441803,0.02454369328916073,-1.0,-1.0}
        H.wait(b,v,260)
        H.pattern(b,4,9,1,17,1,2.0,1.0,v.f0,-0.015707964077591896,544)
        H.call(b,v,P[6][41],0,0.0)
        H.extra(b,v,11,0,false)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.extra={80,-1,-1,-1,0.023000000044703484,-0.02454369328916073,-1.0,-1.0}
        H.pattern(b,4,9,1,16,1,1.0,1.0,v.f0,-0.015707964077591896,544)
        H.call(b,v,P[6][41],0,0.0)
        H.extra(b,v,9,0,false)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,310)
        v.time=180;return B.part2(b,v)
    end
    P[6][44]=B.part1
end

-- 第 6 面，原生 Sub45，起始 0x68b6。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.collidable=false
        a.damageable=false
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=0.6000000238418579;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.timeout=-1;a.phase=0
        a.life_threshold=-1
        v.repeat_func=nil
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.wait(b,v,4)
        H.wait(b,v,6)
        H.wait(b,v,8)
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        H.trace(b,"spell_end")
        if not a.main then b.hp=0 end
        H.wait(b,v,3010)
        H.erase(b)
    end
    P[6][45]=B.part1
end

-- 第 Extra 面，原生 Sub22，起始 0x1ed0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",51)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2100;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c1=2
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=ran:Float(0,384.0)
        v.f1=ran:Float(0,180.0)
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        v.f0=ran:Float(0,0.019999999552965164)+0.004999999888241291
        a.extra={96,-1,-1,-1,v.f0,-999.0,-1.0,-1.0}
        H.pattern(b,9,2,6,1,1,0.0,0.0,1.5953400135040283,1.5462526082992554,24)
        v.c1=v.c1-1
        if v.c1>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i0=math.fmod(v.c3,32)
        v.cmp=(v.i0)-(7)
        if v.cmp~=0 then v.time=120;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        v.i0=trunc((v.c3)/(5))
        v.i0=(v.i0)+(12)
        H.pattern(b,2,2,8,v.i0,1,2.700000047683716,2.0,-1.5707963705062866,0.2617993950843811,0)
        v.c3=v.c3 + 1
        H.wait(b,v,126)
        v.time=120;return B.part2(b,v)
    end
    P[7][22]=B.part1
end

-- 第 Extra 面，原生 Sub23，起始 0x2206。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",52)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2880;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.i3=0
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.f0=0.20000000298023224
        a.muted=true
        a.extra={100,-1,-1,-1,0.014999999664723873,-999.0,-1.0,-1.0}
        H.pattern(b,2,3,2,2,1,v.f0,0.0,0.0,0.5235987901687622,536)
        a.muted=false
        v.f1=0.0
        v.f2=0.0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f3=0.0
        a.muted=true
        a.extra={100,-1,-1,-1,0.014999999664723873,-999.0,-1.0,-1.0}
        H.pattern(b,2,1,2,2,1,v.f0,0.0,0.0,0.5235987901687622,536)
        a.muted=false
        v.c0=280
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.extra(b,v,13,3,false)
        v.f3=(v.f3)+(1.0)
        v.f2=(v.f2)+(0.02454369328916073)
        v.f1=(v.f1)-(0.02454369328916073)
        H.wait(b,v,121)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,121)
        v.f0=(v.f0)+(0.10000000149011612)
        a.muted=true
        a.extra={100,-1,-1,-1,0.014999999664723873,-999.0,-1.0,-1.0}
        H.pattern(b,2,1,2,2,1,v.f0,0.0,0.0,0.5235987901687622,536)
        a.muted=false
        v.f3=0.0
        v.c0=280
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,121)
        H.extra(b,v,13,5,false)
        v.f3=(v.f3)+(1.0)
        v.f2=(v.f2)-(0.02454369328916073)
        v.f1=(v.f1)+(0.02454369328916073)
        H.wait(b,v,122)
        v.c0=v.c0-1
        if v.c0>0 then v.time=121;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        v.f0=(v.f0)+(0.10000000149011612)
        a.muted=true
        a.extra={100,-1,-1,-1,0.014999999664723873,-999.0,-1.0,-1.0}
        H.pattern(b,2,1,2,1,1,0.0,0.0,0.0,1.0471975803375244,536)
        a.muted=false
        v.f3=0.0
        v.c0=180
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        H.extra(b,v,13,6,false)
        v.f3=(v.f3)+(1.0)
        v.f2=(v.f2)-(0.02454369328916073)
        v.f1=(v.f1)+(0.009817477315664291)
        H.wait(b,v,123)
        v.c0=v.c0-1
        if v.c0>0 then v.time=122;return B.part7(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,123)
        v.f0=(v.f0)+(0.10000000149011612)
        a.muted=true
        a.extra={100,-1,-1,-1,0.019999999552965164,-999.0,-1.0,-1.0}
        H.pattern(b,2,1,2,1,1,v.f0,0.0,0.0,0.5235987901687622,536)
        a.muted=false
        v.f3=0.0
        v.c0=200
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,123)
        H.extra(b,v,13,5,false)
        v.f3=(v.f3)+(1.0)
        v.f2=(v.f2)+(0.02454369328916073)
        v.f1=(v.f1)-(0.06544984877109528)
        H.wait(b,v,124)
        v.c0=v.c0-1
        if v.c0>0 then v.time=123;return B.part9(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.c3=v.c3 + 1
        H.wait(b,v,184)
        v.time=120;return B.part2(b,v)
    end
    P[7][23]=B.part1
end

-- 第 Extra 面，原生 Sub24，起始 0x2880。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",53)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=2400;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.i3=0
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.spawn(b,7,25,192.0,144.0,0.0,-5536)
        H.spawn(b,7,26,64.0,112.0,0.0,-5536)
        H.spawn(b,7,27,256.0,96.0,0.0,-5536)
        H.spawn(b,7,28,320.0,112.0,0.0,-5536)
        H.spawn(b,7,29,128.0,96.0,0.0,-5536)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,10120)
        v.time=120;return B.part2(b,v)
    end
    P[7][24]=B.part1
end

-- 第 Extra 面，原生 Sub25，起始 0x2a7a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[7][30]
        H.wait(b,v,32)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,32)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,5,2,10,2,2.0,1.0,v.f0,0.0,512)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.wait(b,v,36)
        H.pattern(b,4,5,2,10,2,2.0,1.0,v.f0,0.0,512)
        v.c3=v.c3 + 1
        H.wait(b,v,126)
        v.time=32;return B.part2(b,v)
    end
    P[7][25]=B.part1
end

-- 第 Extra 面，原生 Sub26，起始 0x2bc2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[7][30]
        H.wait(b,v,64)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,64)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,1,5,6,11,2,3.0,2.5999999046325684,0.0,0.2617993950843811,520)
        v.c3=v.c3 + 1
        H.wait(b,v,114)
        v.time=64;return B.part2(b,v)
    end
    P[7][26]=B.part1
end

-- 第 Extra 面，原生 Sub27，起始 0x2cc6。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[7][30]
        H.wait(b,v,16)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,16)
        a.extra={120,-1,-1,-1,0.012000000104308128,2.356194496154785,-1.0,-1.0}
        H.pattern(b,9,5,10,10,1,2.0,0.30000001192092896,3.1415927410125732,-3.1415927410125732,531)
        v.c3=v.c3 + 1
        H.wait(b,v,36)
        v.time=16;return B.part2(b,v)
    end
    P[7][27]=B.part1
end

-- 第 Extra 面，原生 Sub28，起始 0x2dde。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[7][30]
        H.wait(b,v,48)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,48)
        a.extra={60,1,-1,-1,H.player_angle(b),1.5,-1.0,-1.0}
        v.f1=H.player_angle(b)
        H.pattern(b,4,5,0,16,1,4.0,1.0,v.f0,0.0,769)
        v.c3=v.c3 + 1
        H.wait(b,v,118)
        v.time=48;return B.part2(b,v)
    end
    P[7][28]=B.part1
end

-- 第 Extra 面，原生 Sub29，起始 0x2f0a。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death=P[7][30]
        H.wait(b,v,16)
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,16)
        v.c0=6
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,16)
        v.f0=ran:Float(0,3.1415927410125732)+-1.5707963705062866
        a.extra={180,1,-1,-1,v.f0,1.399999976158142,-1.0,-1.0}
        v.f0=(H.player_angle(b))+(1.5707963705062866)
        v.f1=(H.player_angle(b))-(1.5707963705062866)
        H.pattern(b,9,5,13,1,1,2.4000000953674316,1.0,v.f0,v.f1,579)
        v.c0=v.c0-1
        if v.c0>0 then v.time=16;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,16)
        v.c3=v.c3 + 1
        H.wait(b,v,56)
        v.time=16;return B.part2(b,v)
    end
    P[7][29]=B.part1
end

-- 第 Extra 面，原生 Sub30，起始 0x3096。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,30)
        H.erase(b)
    end
    P[7][30]=B.part1
end

-- 第 Extra 面，原生 Sub32，起始 0x3216。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=10000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][35]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][33]
        a.life_threshold=1800
        a.life_fn=P[7][33]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,40)
        H.wait(b,v,50)
        H.wait(b,v,60)
        H.wait(b,v,70)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,64,2,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,60,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        H.wait(b,v,170)
        v.c3=v.c3 + 1
        H.wait(b,v,180)
        v.time=70;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9180)
        H.erase(b)
    end
    P[7][32]=B.part1
end

-- 第 Extra 面，原生 Sub33，起始 0x352e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",54)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=3300;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        v.f0=1.2999999523162842
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.spawn(b,7,34,v.f0,0.0,0.0,20)
        H.spawn(b,7,34,v.f0,0.0,0.0,22)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,280)
        H.spawn(b,7,34,v.f0,0.0,0.0,1121)
        H.spawn(b,7,34,v.f0,0.0,0.0,1123)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,440)
        H.spawn(b,7,34,v.f0,0.0,0.0,20)
        H.spawn(b,7,34,v.f0,0.0,0.0,22)
        H.wait(b,v,520)
        H.spawn(b,7,34,v.f0,0.0,0.0,111)
        H.spawn(b,7,34,v.f0,0.0,0.0,113)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,720)
        H.spawn(b,7,34,v.f0,0.0,0.0,1111)
        H.spawn(b,7,34,v.f0,0.0,0.0,1113)
        H.spawn(b,7,34,v.f0,0.0,0.0,1010)
        H.spawn(b,7,34,v.f0,0.0,0.0,1012)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,920)
        H.spawn(b,7,34,v.f0,0.0,0.0,111)
        H.spawn(b,7,34,v.f0,0.0,0.0,123)
        H.spawn(b,7,34,v.f0,0.0,0.0,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,22)
        v.c3=v.c3 + 1
        H.wait(b,v,927)
        v.time=120;return B.part2(b,v)
    end
    P[7][33]=B.part1
end

-- 第 Extra 面，原生 Sub34，起始 0x3994。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,16)
        a.damageable=false
        a.collidable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        H.wait(b,v,60)
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.f2=(b.x+192)
        v.i0=math.fmod(H.life(b),10)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=60;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.position(b,0.0,0.0,0.0);H.clamp(b)
        v.i1=0
        v.time=60;return B.part9(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i0)-(1)
        if v.cmp~=0 then v.time=60;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.position(b,384.0,0.0,0.0);H.clamp(b)
        v.i1=1
        v.time=60;return B.part9(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i0)-(2)
        if v.cmp~=0 then v.time=60;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.position(b,384.0,448.0,0.0);H.clamp(b)
        v.i1=2
        v.time=60;return B.part9(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i0)-(3)
        if v.cmp~=0 then v.time=60;return B.part9(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.position(b,0.0,448.0,0.0);H.clamp(b)
        v.i1=3
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i0=trunc((H.life(b))/(10))
        v.c1=math.fmod(v.i0,10)
        v.i3=trunc((H.life(b))/(100))
        v.i3=math.fmod(v.i3,10)
        v.cmp=(v.i3)-(0)
        if v.cmp==0 then v.time=60;return B.part11(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i1=(v.i1)-(1)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i1)-(0)
        if v.cmp>=0 then v.time=60;return B.part13(b,v) end
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i1=3
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i2=trunc((H.life(b))/(1000))
        v.i2=math.fmod(v.i2,10)
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.f1=(b.x+192)
        v.f3=(224-b.y)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=60;return B.part16(b,v) end
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.f3=(v.f3)+(448.0)
        v.time=60;return B.part22(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i1)-(1)
        if v.cmp~=0 then v.time=60;return B.part18(b,v) end
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.f1=(v.f1)-(384.0)
        v.time=60;return B.part22(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i1)-(2)
        if v.cmp~=0 then v.time=60;return B.part20(b,v) end
        return B.part19(b,v)
    end
    function B.part19(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.f3=(v.f3)-(448.0)
        v.time=60;return B.part22(b,v)
    end
    function B.part20(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i1)-(3)
        if v.cmp~=0 then v.time=60;return B.part22(b,v) end
        return B.part21(b,v)
    end
    function B.part21(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.f1=(v.f1)+(384.0)
        return B.part22(b,v)
    end
    function B.part22(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=60;return B.part24(b,v) end
        return B.part23(b,v)
    end
    function B.part23(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i1=(v.i1)-(1)
        v.time=60;return B.part25(b,v)
    end
    function B.part24(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i1=(v.i1)+(1)
        return B.part25(b,v)
    end
    function B.part25(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i1)-(0)
        if v.cmp>=0 then v.time=60;return B.part27(b,v) end
        return B.part26(b,v)
    end
    function B.part26(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i1=3
        v.time=60;return B.part29(b,v)
    end
    function B.part27(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i1)-(3)
        if v.cmp<=0 then v.time=60;return B.part29(b,v) end
        return B.part28(b,v)
    end
    function B.part28(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.i1=0
        return B.part29(b,v)
    end
    function B.part29(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.move_to(b,120,v.f1,v.f3,0.0,1)
        v.c0=10
        return B.part30(b,v)
    end
    function B.part30(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i2)-(0)
        if v.cmp~=0 then v.time=60;return B.part32(b,v) end
        return B.part31(b,v)
    end
    function B.part31(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.f0=atan2((224.0)-((224-b.y)),(192.0)-((b.x+192)))
        H.pattern(b,2,1,4,1,1,v.f2,1.0,v.f0,0.0,512)
        v.time=60;return B.part34(b,v)
    end
    function B.part32(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        v.cmp=(v.i2)-(1)
        if v.cmp~=0 then v.time=60;return B.part34(b,v) end
        return B.part33(b,v)
    end
    function B.part33(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.pattern(b,1,3,6,1,1,v.f2,1.0,v.f0,0.0,512)
        return B.part34(b,v)
    end
    function B.part34(b,v)
        local a=b.th06_actor
        H.wait(b,v,72)
        v.c0=v.c0-1
        if v.c0>0 then v.time=60;return B.part30(b,v) end
        return B.part35(b,v)
    end
    function B.part35(b,v)
        local a=b.th06_actor
        H.wait(b,v,73)
        v.c1=v.c1-1
        if v.c1>0 then v.time=60;return B.part14(b,v) end
        return B.part36(b,v)
    end
    function B.part36(b,v)
        local a=b.th06_actor
        H.wait(b,v,73)
        H.wait(b,v,103)
        H.erase(b)
    end
    P[7][34]=B.part1
end

-- 第 Extra 面，原生 Sub35，起始 0x4074。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=8000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][38]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][36]
        a.life_threshold=1200
        a.life_fn=P[7][36]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,64,2,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,30,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,50,a.angle,a.speed,1)
        H.wait(b,v,190)
        v.c3=v.c3 + 1
        H.wait(b,v,200)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9200)
        H.erase(b)
    end
    P[7][35]=B.part1
end

-- 第 Extra 面，原生 Sub36，起始 0x42fc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",55)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=3300;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        a.bounds={0.0,0.0,384.0,120.0}
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        a.laser_index=0
        H.laser(b,false,1,2,-2.9845130443573,0.0,32.0,420.0,388.0,24.0,60,800,20,60,18,0)
        v.c0=120
        v.f3=-2.9845130443573
        v.f2=-1.4137166738510132
        v.f1=0.039269909262657166
        H.call(b,v,P[7][37],0,0.0)
        H.move_to(b,120,0.0,40.0,0.0,1)
        H.wait(b,v,240)
        a.laser_index=0
        H.laser(b,false,1,2,1.5707963705062866,0.0,32.0,400.0,368.0,24.0,60,800,20,60,18,0)
        v.c0=60
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,240)
        H.offset_laser(b,0,0.0,0.0)
        H.wait(b,v,241)
        v.c0=v.c0-1
        if v.c0>0 then v.time=240;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,241)
        H.move_to(b,90,352.0,96.0,0.0,1)
        v.c0=64
        v.f3=1.5707963705062866
        v.f2=0.0
        v.f1=0.0
        H.call(b,v,P[7][37],0,0.0)
        H.move_to(b,30,384.0,40.0,0.0,1)
        v.c0=30
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,241)
        H.offset_laser(b,0,0.0,0.0)
        H.wait(b,v,242)
        v.c0=v.c0-1
        if v.c0>0 then v.time=241;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,242)
        a.laser_index=0
        H.laser(b,false,1,2,1.5707963705062866,0.0,32.0,400.0,368.0,24.0,60,800,20,60,18,0)
        H.wait(b,v,302)
        H.move_to(b,90,32.0,50.0,0.0,1)
        v.c0=64
        v.f3=1.5707963705062866
        v.f2=3.1415927410125732
        v.f1=0.0
        H.call(b,v,P[7][37],0,0.0)
        H.move_to(b,120,192.0,80.0,0.0,1)
        a.laser_index=0
        H.laser(b,false,1,2,-0.15707963705062866,0.0,32.0,400.0,368.0,24.0,60,800,20,60,18,0)
        v.c0=120
        v.f3=-0.15707963705062866
        v.f2=-1.7278759479522705
        v.f1=-0.039269909262657166
        H.call(b,v,P[7][37],0,0.0)
        v.c3=v.c3 + 1
        H.wait(b,v,362)
        v.time=120;return B.part2(b,v)
    end
    P[7][36]=B.part1
end

-- 第 Extra 面，原生 Sub37，起始 0x4896。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.laser_index=1
        H.laser(b,false,1,2,v.f3,0.0,32.0,420.0,388.0,12.0,1,6,1,1,8,0)
        H.rotate_laser(b,0,v.f1,false)
        H.offset_laser(b,0,0.0,0.0)
        v.f2=(v.f2)+(v.f1)
        v.f3=(v.f3)+(v.f1)
        v.f3=normal_angle(v.f3)
        v.f2=normal_angle(v.f2)
        v.i3=1
        v.i0=math.fmod(v.i1,5)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=0;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.extra={96,-1,-1,-1,0.019999999552965164,-999.0,-1.0,-1.0}
        H.pattern(b,2,2,2,1,1,0.009999999776482582,1.0,v.f2,0.0,532)
        H.extra(b,v,14,0,false)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.cmp=(v.i3)-(0)
        if v.cmp~=0 then v.time=0;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.time=1;return B.part7(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=v.i1 + 1
        H.wait(b,v,1)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        H.laser_cancel(b,0)
        return
    end
    P[7][37]=B.part1
end

-- 第 Extra 面，原生 Sub38，起始 0x4ac6。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=8000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][43]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][39]
        a.life_threshold=1900
        a.life_fn=P[7][39]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,32,3,4.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,60,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,190)
        v.c3=v.c3 + 1
        H.wait(b,v,200)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9200)
        H.erase(b)
    end
    P[7][38]=B.part1
end

-- 第 Extra 面，原生 Sub39，起始 0x4d4e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",56)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=3900;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        v.c0=32
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,123)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,123)
        H.move_to(b,60,128.0,96.0,0.0,1)
        H.spawn(b,7,40,0.0,0.0,0.0,1200)
        H.spawn(b,7,41,0.0,0.0,0.0,1200)
        H.spawn(b,7,42,0.0,0.0,0.0,1200)
        H.wait(b,v,183)
        v.c3=0
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,32,2,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,20,false)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,183)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,48,1,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,40,true)
        v.c0=3
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,183)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.2000000476837158;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c3=v.c3 + 1
        H.wait(b,v,373)
        v.c0=v.c0-1
        if v.c0>0 then v.time=183;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,373)
        H.interval(b,0,true)
        H.wait(b,v,473)
        H.pattern(b,4,6,3,40,3,3.0,1.0,v.f0,0.06283185631036758,512)
        H.wait(b,v,563)
        v.time=183;return B.part4(b,v)
    end
    P[7][39]=B.part1
end

-- 第 Extra 面，原生 Sub40，起始 0x5104。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        H.sprite(b,160)
        H.position(b,-32.0,96.0,0.0);H.clamp(b)
        H.move_to(b,60,64.0,96.0,0.0,1)
        H.wait(b,v,60)
        a.damageable=true
        a.bounds={32.0,48.0,352.0,120.0}
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,32,1,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,60,true)
        v.c0=1
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.2000000476837158;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,360)
        v.c3=v.c3 + 1
        H.wait(b,v,450)
        v.c0=v.c0-1
        if v.c0>0 then v.time=60;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,450)
        H.interval(b,0,true)
        H.wait(b,v,550)
        H.pattern(b,4,6,3,40,3,3.0,1.0,v.f0,0.0,512)
        H.wait(b,v,640)
        v.time=60;return B.part2(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,9640)
        H.erase(b)
    end
    P[7][40]=B.part1
end

-- 第 Extra 面，原生 Sub41，起始 0x5368。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        H.sprite(b,160)
        H.position(b,256.0,-32.0,0.0);H.clamp(b)
        H.move_to(b,60,256.0,96.0,0.0,1)
        H.wait(b,v,60)
        a.damageable=true
        a.bounds={32.0,48.0,352.0,120.0}
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,32,1,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,40,true)
        v.c0=1
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.2000000476837158;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,260)
        v.c3=v.c3 + 1
        H.wait(b,v,350)
        v.c0=v.c0-1
        if v.c0>0 then v.time=60;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,350)
        H.interval(b,0,true)
        H.wait(b,v,450)
        H.pattern(b,4,6,6,8,10,5.0,1.0,0.0,0.0,512)
        H.wait(b,v,540)
        v.time=60;return B.part2(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,9540)
        H.erase(b)
    end
    P[7][41]=B.part1
end

-- 第 Extra 面，原生 Sub42，起始 0x55cc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        H.sprite(b,160)
        H.position(b,416.0,96.0,0.0);H.clamp(b)
        H.move_to(b,60,320.0,96.0,0.0,1)
        H.wait(b,v,60)
        a.damageable=true
        a.bounds={32.0,48.0,352.0,120.0}
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,2,32,1,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,40,true)
        v.c0=1
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=1.2000000476837158;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,310)
        v.c3=v.c3 + 1
        H.wait(b,v,400)
        v.c0=v.c0-1
        if v.c0>0 then v.time=60;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,400)
        H.interval(b,0,true)
        H.wait(b,v,500)
        H.pattern(b,1,6,5,7,5,3.200000047683716,1.0,0.0,0.3141592741012573,512)
        H.wait(b,v,590)
        v.time=60;return B.part2(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,9590)
        H.erase(b)
    end
    P[7][42]=B.part1
end

-- 第 Extra 面，原生 Sub43，起始 0x5830。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=8000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][47]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][44]
        a.life_threshold=2400
        a.life_fn=P[7][44]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,6,32,2,2.0,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,40,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,190)
        v.c3=v.c3 + 1
        H.wait(b,v,200)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9200)
        H.erase(b)
    end
    P[7][43]=B.part1
end

-- 第 Extra 面，原生 Sub44，起始 0x5ab8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",57)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=3900;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=15
        v.c0=32
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,123)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,123)
        H.spawn(b,7,45,64.0,0.0,1.5707963705062866,1200)
        H.wait(b,v,133)
        H.spawn(b,7,45,400.0,320.0,3.1415927410125732,1200)
        H.wait(b,v,143)
        H.spawn(b,7,45,-16.0,160.0,0.0,1200)
        H.wait(b,v,153)
        H.spawn(b,7,45,320.0,464.0,-1.5707963705062866,1200)
        H.wait(b,v,163)
        H.spawn(b,7,45,128.0,0.0,1.5707963705062866,1200)
        H.wait(b,v,173)
        H.spawn(b,7,45,400.0,256.0,3.1415927410125732,1200)
        H.wait(b,v,183)
        H.spawn(b,7,45,-16.0,192.0,0.0,1200)
        H.wait(b,v,193)
        H.spawn(b,7,45,256.0,464.0,-1.5707963705062866,1200)
        H.wait(b,v,203)
        H.spawn(b,7,45,400.0,64.0,3.1415927410125732,1200)
        H.wait(b,v,213)
        H.spawn(b,7,45,-16.0,128.0,0.0,1200)
        H.wait(b,v,373)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,1,1,3.5999999046325684,0.0,v.f0,0.0,516)
        H.wait(b,v,433)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,1,1,3.5999999046325684,0.0,v.f0,0.0,516)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,473)
        H.spawn(b,7,45,400.0,0.0,2.356194496154785,1200)
        H.wait(b,v,488)
        H.spawn(b,7,45,400.0,128.0,2.356194496154785,1200)
        H.wait(b,v,503)
        H.spawn(b,7,45,400.0,256.0,2.356194496154785,1200)
        H.wait(b,v,563)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,1,1,3.5999999046325684,0.0,v.f0,0.0,516)
        H.wait(b,v,593)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,3,1,3.5999999046325684,0.0,0.0,1.0471975803375244,516)
        H.wait(b,v,633)
        H.spawn(b,7,45,-16.0,0.0,0.7853981852531433,1200)
        H.wait(b,v,648)
        H.spawn(b,7,45,-16.0,128.0,0.7853981852531433,1200)
        H.wait(b,v,663)
        H.spawn(b,7,45,-16.0,256.0,0.7853981852531433,1200)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,723)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,1,1,3.5999999046325684,0.0,v.f0,0.0,516)
        H.wait(b,v,753)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,3,1,3.5999999046325684,0.0,0.0,1.0471975803375244,516)
        v.c3=v.c3 + 1
        H.wait(b,v,813)
        v.time=123;return B.part3(b,v)
    end
    P[7][44]=B.part1
end

-- 第 Extra 面，原生 Sub45，起始 0x608e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.invisible=true
        a.damageable=false
        a.collidable=false
        a.interactable=false
        H.sprite(b,160)
        v.f0=a.z
        a.z=0.0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        a.angle,a.speed=v.f0,3.200000047683716;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.death=P[7][46]
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,1,9,1,1,0.0,0.0,0.0,0.0,516)
        H.wait(b,v,6)
        v.time=0;return B.part2(b,v)
    end
    P[7][45]=B.part1
end

-- 第 Extra 面，原生 Sub46，起始 0x61ea。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.erase(b)
    end
    P[7][46]=B.part1
end

-- 第 Extra 面，原生 Sub47，起始 0x6206。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=10000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][49]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][48]
        a.life_threshold=1400
        a.life_fn=P[7][48]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,6,32,2,2.5,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,30,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,190)
        v.c3=v.c3 + 1
        H.wait(b,v,200)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9200)
        H.erase(b)
    end
    P[7][47]=B.part1
end

-- 第 Extra 面，原生 Sub48，起始 0x648e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",58)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=3600;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        a.bounds={32.0,48.0,352.0,448.0}
        H.move_to(b,30,192.0,224.0,0.0,1)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f0=1.5707963705062866
        v.f1=1.5953400135040283
        v.c1=300
        v.i3=0
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.pattern(b,2,2,8,4,1,1.399999976158142,0.0,v.f1,0.06544984877109528,512)
        v.f1=(v.f1)+(0.2716168761253357)
        v.f1=normal_angle(v.f1)
        v.f2=(v.f1)-(v.f0)
        v.cmp=(v.f2)-(0.0)
        if v.cmp>=0 then v.time=120;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f2=(0.0)-(v.f2)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.cmp=(v.f2)-(0.2617993950843811)
        if v.cmp>=0 then v.time=120;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.f1=(v.f1)+(0.39269909262657166)
        v.f0=(v.f0)-(0.6283185482025146)
        v.f0=normal_angle(v.f0)
        v.f3=(v.f1)+(3.1415927410125732)
        H.pattern(b,2,3,6,24,3,3.4000000953674316,1.7999999523162842,v.f3,0.19634954631328583,512)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.i3=v.i3 + 1
        H.wait(b,v,122)
        v.c1=v.c1-1
        if v.c1>0 then v.time=120;return B.part3(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,182)
        v.c1=180
        v.f0=1.5707963705062866
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,182)
        H.pattern(b,2,2,14,4,1,1.399999976158142,0.0,v.f1,0.06544984877109528,512)
        v.f1=(v.f1)-(0.2716168761253357)
        v.f1=normal_angle(v.f1)
        v.f2=(v.f1)-(v.f0)
        v.cmp=(v.f2)-(0.0)
        if v.cmp>=0 then v.time=182;return B.part11(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,182)
        v.f2=(0.0)-(v.f2)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,182)
        v.cmp=(v.f2)-(0.2617993950843811)
        if v.cmp>=0 then v.time=182;return B.part13(b,v) end
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,182)
        v.f1=(v.f1)-(0.39269909262657166)
        v.f0=(v.f0)+(0.7330383062362671)
        v.f0=normal_angle(v.f0)
        v.f3=(v.f1)+(3.1415927410125732)
        H.pattern(b,2,3,2,24,3,3.4000000953674316,1.7999999523162842,v.f3,0.19634954631328583,512)
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,182)
        v.i3=v.i3 + 1
        H.wait(b,v,184)
        v.c1=v.c1-1
        if v.c1>0 then v.time=182;return B.part9(b,v) end
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,184)
        v.c3=v.c3 + 1
        H.wait(b,v,191)
        v.time=120;return B.part2(b,v)
    end
    P[7][48]=B.part1
end

-- 第 Extra 面，原生 Sub49，起始 0x6980。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=10000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][53]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][50]
        a.life_threshold=2200
        a.life_fn=P[7][50]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,6,32,2,3.5,1.0,v.f0,0.0,513)
        a.muted=false
        H.interval(b,30,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,190)
        v.c3=v.c3 + 1
        H.wait(b,v,200)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9200)
        H.erase(b)
    end
    P[7][49]=B.part1
end

-- 第 Extra 面，原生 Sub50，起始 0x6c08。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",59)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=4200;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=30
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,122)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        H.spawn(b,7,51,(b.x+192),(224-b.y),2.356194496154785,102)
        H.spawn(b,7,51,(b.x+192),(224-b.y),2.7488934993743896,114)
        H.spawn(b,7,51,(b.x+192),(224-b.y),3.1415927410125732,113)
        H.spawn(b,7,51,(b.x+192),(224-b.y),0.7853981852531433,104)
        H.spawn(b,7,51,(b.x+192),(224-b.y),0.39269909262657166,108)
        H.spawn(b,7,51,(b.x+192),(224-b.y),0.0,111)
        H.wait(b,v,182)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        v.c0=30
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,182)
        H.wait(b,v,184)
        v.c0=v.c0-1
        if v.c0>0 then v.time=182;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,184)
        H.spawn(b,7,51,-32.0,336.0,-0.5890486240386963,104)
        H.wait(b,v,194)
        H.spawn(b,7,52,-32.0,304.0,-0.5890486240386963,106)
        H.wait(b,v,204)
        H.spawn(b,7,51,-32.0,272.0,-0.5890486240386963,108)
        H.wait(b,v,214)
        H.spawn(b,7,52,-32.0,240.0,-0.5890486240386963,111)
        H.wait(b,v,224)
        H.spawn(b,7,51,-32.0,208.0,-0.5890486240386963,113)
        H.wait(b,v,234)
        H.spawn(b,7,52,-32.0,176.0,-0.5890486240386963,114)
        H.wait(b,v,244)
        H.spawn(b,7,51,-32.0,144.0,-0.5890486240386963,102)
        H.wait(b,v,334)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,394)
        H.spawn(b,7,51,416.0,336.0,3.337942123413086,104)
        H.wait(b,v,404)
        H.spawn(b,7,52,416.0,304.0,3.337942123413086,106)
        H.wait(b,v,414)
        H.spawn(b,7,51,416.0,272.0,3.337942123413086,108)
        H.wait(b,v,424)
        H.spawn(b,7,52,416.0,240.0,3.337942123413086,111)
        H.wait(b,v,434)
        H.spawn(b,7,51,416.0,208.0,3.337942123413086,113)
        H.wait(b,v,444)
        H.spawn(b,7,52,416.0,176.0,3.337942123413086,114)
        H.wait(b,v,454)
        H.spawn(b,7,51,416.0,144.0,3.337942123413086,102)
        H.wait(b,v,594)
        H.spawn(b,7,51,-32.0,336.0,0.0,104)
        H.wait(b,v,604)
        H.spawn(b,7,51,416.0,304.0,3.1415927410125732,106)
        H.wait(b,v,614)
        H.spawn(b,7,51,-32.0,272.0,0.0,108)
        H.wait(b,v,624)
        H.spawn(b,7,51,416.0,240.0,3.1415927410125732,111)
        H.wait(b,v,634)
        H.spawn(b,7,51,-32.0,208.0,0.0,113)
        H.wait(b,v,644)
        H.spawn(b,7,51,416.0,176.0,3.1415927410125732,114)
        H.wait(b,v,654)
        H.spawn(b,7,51,-32.0,144.0,0.0,102)
        H.move_to(b,60,192.0,224.0,0.0,1)
        H.wait(b,v,714)
        v.c3=v.c3 + 1
        H.wait(b,v,721)
        v.time=120;return B.part2(b,v)
    end
    P[7][50]=B.part1
end

-- 第 Extra 面，原生 Sub51，起始 0x7282。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.invisible=true
        a.damageable=false
        a.collidable=false
        a.interactable=false
        H.sprite(b,160)
        v.f0=a.z
        a.z=0.0
        v.i0=math.fmod(H.life(b),100)
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        a.angle,a.speed=v.f0,5.800000190734863;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.death=P[7][46]
        v.c3=0
        v.c1=50
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.c3,2)
        v.f1=ran:Float(0,1.0)
        v.f2=ran:Float(0,0.009999999776482582)+0.014999999664723873
        a.extra={180,-1,-1,-1,v.f2,1.5707963705062866,-1.0,-1.0}
        H.pattern(b,2,3,v.i0,1,1,v.f1,0.0,-1.5707963705062866,0.0,19)
        v.c3=v.c3 + 1
        H.wait(b,v,4)
        v.c1=v.c1-1
        if v.c1>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        H.erase(b)
    end
    P[7][51]=B.part1
end

-- 第 Extra 面，原生 Sub52，起始 0x74b2。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.invisible=true
        a.damageable=false
        a.collidable=false
        a.interactable=false
        H.sprite(b,160)
        v.f0=a.z
        a.z=0.0
        v.i0=math.fmod(H.life(b),100)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        a.angle,a.speed=v.f0,5.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.death=P[7][46]
        v.c3=0
        v.c1=50
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.i1=math.fmod(v.c3,2)
        v.f1=ran:Float(0,1.0)
        v.f2=ran:Float(0,0.013000000268220901)+0.012000000104308128
        a.extra={120,-1,-1,-1,v.f2,1.5707963705062866,-1.0,-1.0}
        H.pattern(b,2,3,v.i0,1,1,v.f1,0.0,-1.5707963705062866,0.0,19)
        v.f0=(v.f0)+(0.014959964901208878)
        a.angle,a.speed=v.f0,5.0;a.mode="velocity"
        v.c3=v.c3 + 1
        H.wait(b,v,4)
        v.c1=v.c1-1
        if v.c1>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,4)
        H.erase(b)
    end
    P[7][52]=B.part1
end

-- 第 Extra 面，原生 Sub53，起始 0x770e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=10000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][56]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][54]
        a.life_threshold=1520
        a.life_fn=P[7][54]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,6,32,3,2.5,1.0,v.f0,0.06544984877109528,513)
        a.muted=false
        H.interval(b,30,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,190)
        v.c3=v.c3 + 1
        H.wait(b,v,200)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9200)
        H.erase(b)
    end
    P[7][53]=B.part1
end

-- 第 Extra 面，原生 Sub54，起始 0x7996。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",60)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=4200;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        v.c0=30
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,122)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        a.extra={2,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f2=-2.356194496154785
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-1.9634953737258911
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-1.5707963705062866
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-1.1780972480773926
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-0.7853981852531433
        H.call(b,v,P[7][55],0,0.0)
        H.move_dir(b,10,1.5707963705062866,4.0,1)
        H.wait(b,v,182)
        H.move_to(b,90,288.0,96.0,0.0,1)
        H.wait(b,v,292)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f2=0.7853981852531433
        H.call(b,v,P[7][55],0,0.0)
        v.f2=0.39269909262657166
        H.call(b,v,P[7][55],0,0.0)
        v.f2=0.0
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-0.39269909262657166
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-0.7853981852531433
        H.call(b,v,P[7][55],0,0.0)
        H.move_dir(b,10,3.1415927410125732,4.0,1)
        H.wait(b,v,352)
        H.move_to(b,60,96.0,96.0,0.0,1)
        H.wait(b,v,412)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f2=2.356194496154785
        H.call(b,v,P[7][55],0,0.0)
        v.f2=2.7488934993743896
        H.call(b,v,P[7][55],0,0.0)
        v.f2=3.1415927410125732
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-2.7488934993743896
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-2.356194496154785
        H.call(b,v,P[7][55],0,0.0)
        H.move_dir(b,10,0.0,4.0,1)
        H.wait(b,v,472)
        H.move_to(b,60,32.0,128.0,0.0,1)
        H.wait(b,v,532)
        H.move_to(b,120,352.0,128.0,0.0,0)
        v.c0=5
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,532)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f2=-1.5707963705062866
        H.call(b,v,P[7][55],0,0.0)
        H.wait(b,v,556)
        v.c0=v.c0-1
        if v.c0>0 then v.time=532;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,586)
        H.move_to(b,60,192.0,128.0,0.0,1)
        H.wait(b,v,646)
        v.c0=30
        H.wait(b,v,648)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part3(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,648)
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        v.f2=2.356194496154785
        H.call(b,v,P[7][55],0,0.0)
        v.f2=3.1415927410125732
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-2.356194496154785
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-1.5707963705062866
        H.call(b,v,P[7][55],0,0.0)
        v.f2=-0.7853981852531433
        H.call(b,v,P[7][55],0,0.0)
        v.f2=0.0
        H.call(b,v,P[7][55],0,0.0)
        v.f2=0.7853981852531433
        H.call(b,v,P[7][55],0,0.0)
        H.move_dir(b,10,1.5707963705062866,4.0,1)
        H.wait(b,v,768)
        v.c3=v.c3 + 1
        H.wait(b,v,775)
        v.time=120;return B.part2(b,v)
    end
    P[7][54]=B.part1
end

-- 第 Extra 面，原生 Sub55，起始 0x81b8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.pattern(b,2,9,1,1,1,5.199999809265137,1.2000000476837158,v.f2,0.0,2048)
        v.f0=(v.f2)-(0.02454369328916073)
        v.f1=(v.f2)+(0.02454369328916073)
        H.pattern(b,9,6,3,9,1,5.0,3.5,v.f0,v.f1,2048)
        v.f0=(v.f2)-(0.06544984877109528)
        v.f1=(v.f2)+(0.06544984877109528)
        H.pattern(b,9,6,3,3,1,3.5,2.5,v.f0,v.f1,2048)
        v.f0=(v.f2)-(0.07853981852531433)
        v.f1=(v.f2)+(0.07853981852531433)
        H.pattern(b,9,1,6,5,1,2.5,1.5,v.f0,v.f1,2048)
        v.f0=(v.f2)-(0.09817477315664291)
        v.f1=(v.f2)+(0.09817477315664291)
        H.pattern(b,9,1,6,8,1,1.5,0.5,v.f0,v.f1,2048)
        return
    end
    P[7][55]=B.part1
end

-- 第 Extra 面，原生 Sub56，起始 0x836c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=10000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][59]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][57]
        a.life_threshold=1800
        a.life_fn=P[7][57]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,3,2,6,5,6,5.5,1.0,0.0,0.0,513)
        a.muted=false
        H.interval(b,20,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,190)
        v.c3=v.c3 + 1
        H.wait(b,v,200)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9200)
        H.erase(b)
    end
    P[7][56]=B.part1
end

-- 第 Extra 面，原生 Sub57，起始 0x85f4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",61)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=4200;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.spawn(b,7,58,64.0,288.0,288.0,10)
        H.spawn(b,7,58,320.0,160.0,160.0,10)
        H.wait(b,v,210)
        v.c0=240
        v.i0=0
        v.f2=1.7999999523162842
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,210)
        v.i1=math.fmod(v.i0,16)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=210;return B.part5(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,210)
        H.pattern(b,2,3,2,32,1,5.199999809265137,1.2000000476837158,-1.5707963705062866,0.13089969754219055,0)
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,210)
        v.i1=math.fmod(v.i0,24)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=210;return B.part7(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,210)
        H.pattern(b,1,3,2,17,1,v.f2,1.2000000476837158,0.0,0.15707963705062866,0)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,210)
        v.i0=v.i0 + 1
        H.wait(b,v,211)
        v.c0=v.c0-1
        if v.c0>0 then v.time=210;return B.part3(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,231)
        H.spawn(b,7,58,64.0,160.0,160.0,10)
        H.spawn(b,7,58,320.0,288.0,288.0,10)
        H.wait(b,v,321)
        v.c0=250
        v.i0=0
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,321)
        v.i1=math.fmod(v.i0,16)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=321;return B.part11(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,321)
        H.pattern(b,2,3,2,32,1,5.199999809265137,1.2000000476837158,-1.5707963705062866,0.13089969754219055,0)
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,321)
        v.i1=math.fmod(v.i0,16)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=321;return B.part13(b,v) end
        return B.part12(b,v)
    end
    function B.part12(b,v)
        local a=b.th06_actor
        H.wait(b,v,321)
        v.f1=(v.f2)+(2.0999999046325684)
        H.pattern(b,1,3,2,7,1,v.f1,1.2000000476837158,0.0,0.15707963705062866,0)
        return B.part13(b,v)
    end
    function B.part13(b,v)
        local a=b.th06_actor
        H.wait(b,v,321)
        v.i0=v.i0 + 1
        H.wait(b,v,322)
        v.c0=v.c0-1
        if v.c0>0 then v.time=321;return B.part9(b,v) end
        return B.part14(b,v)
    end
    function B.part14(b,v)
        local a=b.th06_actor
        H.wait(b,v,332)
        H.spawn(b,7,58,64.0,128.0,288.0,10)
        H.spawn(b,7,58,320.0,128.0,288.0,10)
        H.wait(b,v,422)
        v.c0=250
        v.i0=0
        return B.part15(b,v)
    end
    function B.part15(b,v)
        local a=b.th06_actor
        H.wait(b,v,422)
        v.i1=math.fmod(v.i0,16)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=422;return B.part17(b,v) end
        return B.part16(b,v)
    end
    function B.part16(b,v)
        local a=b.th06_actor
        H.wait(b,v,422)
        H.pattern(b,2,3,2,32,1,5.199999809265137,1.2000000476837158,-1.5707963705062866,0.13089969754219055,0)
        return B.part17(b,v)
    end
    function B.part17(b,v)
        local a=b.th06_actor
        H.wait(b,v,422)
        v.i1=math.fmod(v.i0,16)
        v.cmp=(v.i1)-(0)
        if v.cmp~=0 then v.time=422;return B.part19(b,v) end
        return B.part18(b,v)
    end
    function B.part18(b,v)
        local a=b.th06_actor
        H.wait(b,v,422)
        v.f1=(v.f2)+(1.0)
        H.pattern(b,1,3,2,17,1,v.f2,1.2000000476837158,0.0,0.15707963705062866,0)
        return B.part19(b,v)
    end
    function B.part19(b,v)
        local a=b.th06_actor
        H.wait(b,v,422)
        v.i0=v.i0 + 1
        H.wait(b,v,423)
        v.c0=v.c0-1
        if v.c0>0 then v.time=422;return B.part15(b,v) end
        return B.part20(b,v)
    end
    function B.part20(b,v)
        local a=b.th06_actor
        H.wait(b,v,423)
        v.f2=(v.f2)+(0.20000000298023224)
        H.wait(b,v,473)
        v.c3=v.c3 + 1
        H.wait(b,v,480)
        v.time=120;return B.part2(b,v)
    end
    P[7][57]=B.part1
end

-- 第 Extra 面，原生 Sub58，起始 0x8c12。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.interactable=false
        a.collidable=false
        H.sprite(b,16)
        v.f2=a.z
        a.z=0.0
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        a.angle,a.speed=v.f0,0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.death=P[7][46]
        H.wait(b,v,30)
        a.laser_index=0
        H.laser(b,false,1,6,-1.5707963705062866,0.0,0.0,216.0,216.0,24.0,60,800,20,60,18,0)
        a.laser_index=1
        H.laser(b,false,1,6,0.0,0.0,0.0,216.0,216.0,24.0,60,800,20,60,18,0)
        a.laser_index=2
        H.laser(b,false,1,6,1.5707963705062866,0.0,0.0,216.0,216.0,24.0,60,800,20,60,18,0)
        a.laser_index=3
        H.laser(b,false,1,6,3.1415927410125732,0.0,0.0,216.0,216.0,24.0,60,800,20,60,18,0)
        v.f1=(384.0)-((b.x+192))
        v.cmp=((b.x+192))-(192.0)
        if v.cmp>=0 then v.time=30;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f3=0.019634954631328583
        v.time=30;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f3=-0.019634954631328583
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=-1.5707963705062866
        v.c1=50
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        H.offset_laser(b,0,0.0,0.0)
        H.offset_laser(b,1,0.0,0.0)
        H.offset_laser(b,2,0.0,0.0)
        H.offset_laser(b,3,0.0,0.0)
        H.rotate_laser(b,0,v.f3,false)
        H.rotate_laser(b,1,v.f3,false)
        H.rotate_laser(b,2,v.f3,false)
        H.rotate_laser(b,3,v.f3,false)
        v.f0=(v.f0)+(v.f1)
        H.wait(b,v,31)
        v.c1=v.c1-1
        if v.c1>0 then v.time=30;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,31)
        v.c1=220
        H.move_to(b,220,v.f1,v.f2,0.0,0)
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,31)
        H.offset_laser(b,0,0.0,0.0)
        H.offset_laser(b,1,0.0,0.0)
        H.offset_laser(b,2,0.0,0.0)
        H.offset_laser(b,3,0.0,0.0)
        H.rotate_laser(b,0,v.f3,false)
        H.rotate_laser(b,1,v.f3,false)
        H.rotate_laser(b,2,v.f3,false)
        H.rotate_laser(b,3,v.f3,false)
        v.f0=(v.f0)+(v.f1)
        H.wait(b,v,32)
        v.c1=v.c1-1
        if v.c1>0 then v.time=31;return B.part7(b,v) end
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,32)
        H.laser_cancel(b,0)
        H.laser_cancel(b,1)
        H.laser_cancel(b,2)
        H.laser_cancel(b,3)
        v.c1=60
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,32)
        H.offset_laser(b,0,0.0,0.0)
        H.offset_laser(b,1,0.0,0.0)
        H.offset_laser(b,2,0.0,0.0)
        H.offset_laser(b,3,0.0,0.0)
        H.rotate_laser(b,0,v.f3,false)
        H.rotate_laser(b,1,v.f3,false)
        H.rotate_laser(b,2,v.f3,false)
        H.rotate_laser(b,3,v.f3,false)
        H.wait(b,v,33)
        v.c1=v.c1-1
        if v.c1>0 then v.time=32;return B.part9(b,v) end
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,63)
        H.erase(b)
    end
    P[7][58]=B.part1
end

-- 第 Extra 面，原生 Sub59，起始 0x926e。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=1000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][67]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][60]
        a.life_threshold=1000
        a.life_fn=P[7][60]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,1,2,6,1,6,5.5,1.0,0.0,0.0,513)
        a.muted=false
        H.interval(b,20,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        if a.main and a.sub==59 then H.erase(b) end
        H.call(b,v,P[7][60],0,0.0)
        H.wait(b,v,100)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9100)
        H.erase(b)
    end
    P[7][59]=B.part1
end

-- 第 Extra 面，原生 Sub60，起始 0x94ca。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",62)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=5160;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        a.survival=true
        a.invisible=true
        a.interactable=false
        a.damageable=false
        a.collidable=false
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.spawn(b,7,66,192.0,96.0,0.0,4)
        H.wait(b,v,920)
        H.spawn(b,7,66,192.0,96.0,0.0,4)
        H.wait(b,v,984)
        H.spawn(b,7,66,0.0,0.0,0.0,4)
        H.wait(b,v,1048)
        H.spawn(b,7,66,384.0,0.0,0.0,3)
        H.wait(b,v,1112)
        H.spawn(b,7,66,0.0,448.0,0.0,3)
        H.wait(b,v,1176)
        H.spawn(b,7,66,384.0,448.0,0.0,2)
        H.wait(b,v,1976)
        H.call(b,v,P[7][61],0,0.0)
        H.wait(b,v,2296)
        H.call(b,v,P[7][62],0,0.0)
        H.wait(b,v,2616)
        H.call(b,v,P[7][63],0,0.0)
        H.wait(b,v,2936)
        H.call(b,v,P[7][64],0,0.0)
        H.wait(b,v,3256)
        H.call(b,v,P[7][65],0,0.0)
        H.wait(b,v,3576)
        H.call(b,v,P[7][61],0,0.0)
        H.wait(b,v,3816)
        H.call(b,v,P[7][62],0,0.0)
        H.wait(b,v,4056)
        H.call(b,v,P[7][63],0,0.0)
        H.wait(b,v,4296)
        H.call(b,v,P[7][64],0,0.0)
        H.wait(b,v,4536)
        H.call(b,v,P[7][65],0,0.0)
        H.wait(b,v,4676)
        H.call(b,v,P[7][61],0,0.0)
        H.wait(b,v,4816)
        H.call(b,v,P[7][62],0,0.0)
        H.wait(b,v,4956)
        H.call(b,v,P[7][63],0,0.0)
        H.wait(b,v,5096)
        H.call(b,v,P[7][64],0,0.0)
        H.wait(b,v,5236)
        H.call(b,v,P[7][65],0,0.0)
        H.wait(b,v,5243)
        v.time=120;return B.part2(b,v)
    end
    P[7][60]=B.part1
end

-- 第 Extra 面，原生 Sub61，起始 0x98b4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=0.0
        v.f1=-12.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,2,1,5,3.200000047683716,1.0,1.5707963705062866,0.0,8)
        v.f0=396.0
        v.f1=0.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,2,1,5,3.200000047683716,1.0,3.1415927410125732,0.0,8)
        v.f0=384.0
        v.f1=460.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,2,1,5,3.200000047683716,1.0,-1.5707963705062866,0.0,8)
        v.f0=-12.0
        v.f1=448.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,2,1,5,3.200000047683716,1.0,0.0,0.0,8)
        v.f2=-12.0
        v.f3=ran:Float(0,32.0)
        v.c0=14
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        v.f0=atan2((224.0)-(v.f3),(192.0)-(v.f2))
        H.pattern(b,2,3,2,1,1,1.2000000476837158,0.0,v.f0,1.0471975803375244,8)
        v.f3=(v.f3)+(32.0)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=396.0
        v.f3=ran:Float(0,32.0)
        v.c0=14
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        v.f0=atan2((224.0)-(v.f3),(192.0)-(v.f2))
        H.pattern(b,2,3,2,1,1,1.2000000476837158,0.0,v.f0,1.0471975803375244,8)
        v.f3=(v.f3)+(32.0)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=-12.0
        v.c0=12
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        v.f0=atan2((224.0)-(v.f3),(192.0)-(v.f2))
        H.pattern(b,2,3,2,1,1,1.2000000476837158,0.0,v.f0,1.0471975803375244,8)
        v.f2=(v.f2)+(32.0)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.c0=12
        v.f2=ran:Float(0,32.0)
        v.f3=460.0
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        v.f0=atan2((224.0)-(v.f3),(192.0)-(v.f2))
        H.pattern(b,2,3,2,1,1,1.2000000476837158,0.0,v.f0,1.0471975803375244,8)
        v.f2=(v.f2)+(32.0)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part8(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return
    end
    P[7][61]=B.part1
end

-- 第 Extra 面，原生 Sub62，起始 0x9fec。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=-12.0
        v.f1=0.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,5,3.200000047683716,1.0,0.0,0.0,8)
        v.f0=384.0
        v.f1=-12.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,5,3.200000047683716,1.0,1.5707963705062866,0.0,8)
        v.f0=396.0
        v.f1=448.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,5,3.200000047683716,1.0,3.1415927410125732,0.0,8)
        v.f0=0.0
        v.f1=460.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,5,3.200000047683716,1.0,-1.5707963705062866,0.0,8)
        v.f2=-12.0
        v.f3=ran:Float(0,32.0)
        v.c0=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,2,1.5,0.699999988079071,0.0,0.0,8)
        v.f3=(v.f3)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=396.0
        v.f3=ran:Float(0,32.0)
        v.c0=10
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,2,1.5,0.699999988079071,3.1415927410125732,0.0,8)
        v.f3=(v.f3)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=-12.0
        v.c0=9
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,2,1.5,0.699999988079071,1.5707963705062866,0.0,8)
        v.f2=(v.f2)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=460.0
        v.c0=9
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,6,1,2,1.5,0.699999988079071,-1.5707963705062866,0.0,8)
        v.f2=(v.f2)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part8(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return
    end
    P[7][62]=B.part1
end

-- 第 Extra 面，原生 Sub63，起始 0xa6a4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=0.0
        v.f1=-12.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,1,5,3.200000047683716,1.0,1.5707963705062866,0.0,8)
        v.f0=396.0
        v.f1=0.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,1,5,3.200000047683716,1.0,3.1415927410125732,0.0,8)
        v.f0=384.0
        v.f1=460.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,1,5,3.200000047683716,1.0,-1.5707963705062866,0.0,8)
        v.f0=-12.0
        v.f1=448.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,1,5,3.200000047683716,1.0,0.0,0.0,8)
        v.f2=-12.0
        v.f3=ran:Float(0,32.0)
        v.c0=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,2,1,0.800000011920929,1.0,0.0,1.0471975803375244,8)
        v.f3=(v.f3)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=396.0
        v.f3=ran:Float(0,32.0)
        v.c0=10
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,2,1,0.800000011920929,1.0,3.1415927410125732,1.0471975803375244,8)
        v.f3=(v.f3)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=-12.0
        v.c0=9
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,2,1,0.800000011920929,1.0,1.5707963705062866,1.0471975803375244,8)
        v.f2=(v.f2)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=460.0
        v.c0=9
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,10,2,1,0.800000011920929,1.0,-1.5707963705062866,1.0471975803375244,8)
        v.f2=(v.f2)+(44.79999923706055)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part8(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return
    end
    P[7][63]=B.part1
end

-- 第 Extra 面，原生 Sub64，起始 0xad5c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=-12.0
        v.f1=0.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,14,1,5,3.200000047683716,1.0,0.0,0.0,8)
        v.f0=384.0
        v.f1=-12.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,14,1,5,3.200000047683716,1.0,1.5707963705062866,0.0,8)
        v.f0=396.0
        v.f1=448.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,14,1,5,3.200000047683716,1.0,3.1415927410125732,0.0,8)
        v.f0=0.0
        v.f1=460.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,14,1,5,3.200000047683716,1.0,-1.5707963705062866,0.0,8)
        v.f2=0.0
        v.f3=ran:Float(0,32.0)
        v.c0=11
        a.extra={220,-1,-1,-1,0.0,-0.007479982450604439,-1.0,-1.0}
        v.f0=1.5707963705062866
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,14,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f3=(v.f3)+(40.0)
        v.f0=(v.f0)-(0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=384.0
        v.f3=ran:Float(0,32.0)
        v.c0=11
        v.f0=3.1415927410125732
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,14,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f3=(v.f3)+(40.0)
        v.f0=(v.f0)+(0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=0.0
        v.c0=9
        v.f0=1.5707963705062866
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,14,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f2=(v.f2)+(40.0)
        v.f0=(v.f0)+(0.1745329201221466)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=448.0
        v.c0=9
        v.f0=0.0
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,14,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f2=(v.f2)+(40.0)
        v.f0=(v.f0)-(0.1745329201221466)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part8(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return
    end
    P[7][64]=B.part1
end

-- 第 Extra 面，原生 Sub65，起始 0xb450。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f0=0.0
        v.f1=-12.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,13,1,5,3.200000047683716,1.0,1.5707963705062866,0.0,8)
        v.f0=396.0
        v.f1=0.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,13,1,5,3.200000047683716,1.0,3.1415927410125732,0.0,8)
        v.f0=384.0
        v.f1=460.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,13,1,5,3.200000047683716,1.0,-1.5707963705062866,0.0,8)
        v.f0=-12.0
        v.f1=448.0
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        H.pattern(b,2,3,13,1,5,3.200000047683716,1.0,0.0,0.0,8)
        v.f2=0.0
        v.f3=ran:Float(0,32.0)
        v.c0=11
        a.extra={220,-1,-1,-1,0.0,0.007479982450604439,-1.0,-1.0}
        v.f0=0.0
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,13,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f3=(v.f3)+(40.0)
        v.f0=(v.f0)-(0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=384.0
        v.f3=ran:Float(0,32.0)
        v.c0=11
        v.f0=1.5707963705062866
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,13,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f3=(v.f3)+(40.0)
        v.f0=(v.f0)+(0.14279966056346893)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=-0.0
        v.c0=9
        v.f0=0.0
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,13,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f2=(v.f2)+(40.0)
        v.f0=(v.f0)+(0.1745329201221466)
        v.f0=normal_angle(v.f0)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        v.f2=ran:Float(0,32.0)
        v.f3=448.0
        v.c0=9
        v.f0=-1.5707963705062866
        v.f2=(v.f2)-((b.x+192))
        v.f3=(v.f3)-((224-b.y))
        return B.part8(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.offsetx,a.offsety,a.offsetz=v.f2,v.f3,0.0
        H.pattern(b,2,3,13,1,1,1.0,1.0,v.f0,0.7853981852531433,40)
        v.f2=(v.f2)+(40.0)
        v.f0=(v.f0)-(0.1745329201221466)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part8(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        return
    end
    P[7][65]=B.part1
end

-- 第 Extra 面，原生 Sub66，起始 0xbb54。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.invisible=true
        a.damageable=false
        a.collidable=false
        a.interactable=false
        H.sprite(b,16)
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        b.a,b.b,b.rect=(56.0)/2,(56.0)/2,true
        a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=0.0,0.0,0,0,0,0
        a.death=P[7][46]
        v.c3=0
        a.sound=27;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.muted=true
        H.pattern(b,1,3,6,3,1,0.5,0.0,0.0,1.0471975803375244,514)
        a.muted=false
        H.interval(b,6,false)
        H.wait(b,v,60)
        v.c0=math.fmod(H.life(b),10)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        H.move_to(b,192,(player.x+192),(224-player.y),0.0,1)
        v.c3=v.c3 + 1
        H.wait(b,v,252)
        v.c0=v.c0-1
        if v.c0>0 then v.time=60;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,252)
        H.erase(b)
    end
    P[7][66]=B.part1
end

-- 第 Extra 面，原生 Sub67，起始 0xbd08。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.trace(b,"spell_end")
        if not a.main then b.hp=6000 end
        a.invisible=false
        a.collidable=true
        a.interactable=true
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=6
        H.clear_helpers(b)
        H.interval(b,0,false)
        a.death=P[7][69]
        a.timeout=1800;a.phase=0
        a.timeout_fn=P[7][68]
        a.life_threshold=-1
        a.life_fn=P[7][68]
        a.survival=false
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.damageable=false
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c3=0
        H.wait(b,v,30)
        a.damageable=true
        H.wait(b,v,90)
        a.muted=true
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,1,2,6,1,6,5.5,1.0,0.0,0.0,513)
        a.muted=false
        H.interval(b,20,false)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,90)
        H.call(b,v,P[7][68],0,0.0)
        H.wait(b,v,100)
        v.time=90;return B.part2(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,9100)
        H.erase(b)
    end
    P[7][67]=B.part1
end

-- 第 Extra 面，原生 Sub68，起始 0xc004。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b);H.reset_rank(a);H.trace(b,"spell",63)
        H.interval(b,0,false)
        H.clear_helpers(b)
        a.sound=-1;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=false
        a.collidable=true
        a.offsetx,a.offsety,a.offsetz=0.0,0.0,0.0
        a.timeout=9000;a.phase=0
        a.phase=0
        a.phase=0
        v.c3=0
        H.move_to(b,120,192.0,80.0,0.0,1)
        H.wait(b,v,120)
        a.damageable=true
        v.repeat_func=10
        v.c0=30
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.wait(b,v,122)
        v.c0=v.c0-1
        if v.c0>0 then v.time=120;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.extra={1,-1,-1,-1,-1.0,-1.0,-1.0,-1.0}
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        H.extra(b,v,16,0,false)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,2,6,88,1,v.f3,1.0,v.f0,0.0,2560)
        H.extra(b,v,16,1,false)
        v.f0=v.f2
        v.f1=v.f3
        v.f0=(v.f0)-((b.x+192))
        v.f1=(v.f1)-((224-b.y))
        a.offsetx,a.offsety,a.offsetz=v.f0,v.f1,0.0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,122)
        H.wait(b,v,123)
        v.c1=v.c1-1
        if v.c1>0 then v.time=122;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,124)
        v.time=122;return B.part4(b,v)
    end
    P[7][68]=B.part1
end

-- 第 Extra 面，原生 Sub69，起始 0xc2c6。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.speed=0.0;a.mode="velocity"
        a.collidable=false
        a.damageable=false
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=0.6000000238418579;a.mode="velocity"
        H.move_dir(b,60,a.angle,a.speed,1)
        a.timeout=-1;a.phase=0
        a.life_threshold=-1
        v.repeat_func=nil
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,2)
        H.wait(b,v,4)
        H.wait(b,v,6)
        H.wait(b,v,8)
        H.wait(b,v,10)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,10)
        H.trace(b,"spell_end")
        if not a.main then b.hp=0 end
        H.wait(b,v,3010)
        H.erase(b)
    end
    P[7][69]=B.part1
end

-- 卡表只注册实际 L / Extra 分支；保留帕秋莉四条机体路线的完整原作顺序。

boss.Define("2a","露米娅·中 Boss","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG1"],"Rumia",LEVEL)

boss.Define("3a","露米娅","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG1"],"Rumia",LEVEL)

boss.Define("4a","大妖精","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG1"],"Daiyousei",LEVEL)

boss.Define("5a","琪露诺","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG1"],"Chiruno",LEVEL)

boss.Define("6a","红美铃·中 Boss","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Meirin",LEVEL)

boss.Define("7a","红美铃","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Meirin",LEVEL)

boss.Define("8a","小恶魔","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Daiyousei",LEVEL)

boss.Define("9a","帕秋莉·灵梦Ａ路线","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Knowledge",LEVEL)

boss.Define("15a","帕秋莉·灵梦Ｂ路线","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Knowledge",LEVEL)

boss.Define("16a","帕秋莉·魔理沙Ａ路线","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Knowledge",LEVEL)

boss.Define("17a","帕秋莉·魔理沙Ｂ路线","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Knowledge",LEVEL)

boss.Define("10a","咲夜·五面中 Boss","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG3"],"Sakuya",LEVEL)

boss.Define("11a","十六夜咲夜","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG3"],"Sakuya",LEVEL)

boss.Define("12a","咲夜·六面中 Boss","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG3"],"Sakuya",LEVEL)

boss.Define("13a","帕秋莉·Extra","TH06_0",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG2"],"Knowledge",LEVEL)

boss.Define("14a","芙兰朵露·斯卡蕾特","TH06_1",TH06_bg,{0,384},(_editor_class["TH06"] or {})["SCBG3"],"Flandre",LEVEL)

do

    local meta={stage=1,sub=8,group=2,life=6000,threshold=500,hp=5500,shot=0,timeout=1440,epoch=0,invul=60,bounds=nil,order=1,entry_x=128.0,entry_y=96.0,hitbox={48.0,56.0},id=3900}

    local card=boss.card.New("",1.0,1.0,24.0,5500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"2a"}},LEVEL,"一面中 Boss 非符（Lunatic）",3900)

end

do

    local meta={stage=1,sub=9,group=2,life=500,threshold=0,hp=500,shot=0,timeout=1320,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=2,entry_x=128.0,entry_y=96.0,hitbox={48.0,56.0},id=3901}

    local card=boss.card.New("月符「月光」",2.0,2.0,22.0,500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"2a"}},LEVEL,"月符「月光」（Lunatic）",3901)

end

do

    local meta={stage=1,sub=11,group=3,life=7000,threshold=900,hp=6100,shot=0,timeout=2100,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=3,entry_x=0.0,entry_y=128.0,hitbox={48.0,56.0},id=3902}

    local card=boss.card.New("",0.0,0.0,35.0,6100,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"3a"}},LEVEL,"露米娅 非符一（Lunatic）",3902)

end

do

    local meta={stage=1,sub=22,group=3,life=900,threshold=0,hp=900,shot=0,timeout=1500,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=4,entry_x=0.0,entry_y=128.0,hitbox={48.0,56.0},id=3903}

    local card=boss.card.New("夜符「夜雀」",2.0,2.0,25.0,900,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"3a"}},LEVEL,"夜符「夜雀」（Lunatic）",3903)

end

do

    local meta={stage=1,sub=16,group=3,life=7500,threshold=800,hp=6700,shot=0,timeout=1800,epoch=0,invul=200,bounds={32.0,48.0,352.0,144.0},order=5,entry_x=0.0,entry_y=128.0,hitbox={48.0,56.0},id=3904}

    local card=boss.card.New("",3.3333333333333335,3.3333333333333335,30.0,6700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"3a"}},LEVEL,"露米娅 非符二（Lunatic）",3904)

end

do

    local meta={stage=1,sub=23,group=3,life=800,threshold=0,hp=800,shot=0,timeout=1500,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=6,entry_x=0.0,entry_y=128.0,hitbox={48.0,56.0},id=3905}

    local card=boss.card.New("暗符「境界线」",2.0,2.0,25.0,800,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"3a"}},LEVEL,"暗符「境界线」（Lunatic）",3905)

end

do

    local meta={stage=2,sub=20,group=4,life=10000,threshold=0,hp=10000,shot=0,timeout=1920,epoch=0,invul=60,bounds=nil,order=7,entry_x=0.0,entry_y=128.0,hitbox={45.0,56.0},id=3906}

    local card=boss.card.New("",1.0,1.0,32.0,10000,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"4a"}},LEVEL,"大妖精 非符（Lunatic）",3906)

end

do

    local meta={stage=2,sub=22,group=5,life=10000,threshold=1500,hp=8500,shot=0,timeout=1500,epoch=0,invul=20,bounds={32.0,48.0,352.0,134.0},order=8,entry_x=0,entry_y=128,hitbox={48.0,56.0},id=3907}

    local card=boss.card.New("",0.3333333333333333,0.3333333333333333,25.0,8500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"5a"}},LEVEL,"琪露诺 非符一（Lunatic）",3907)

end

do

    local meta={stage=2,sub=30,group=5,life=1500,threshold=0,hp=1500,shot=0,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,134.0},order=9,entry_x=0,entry_y=128,hitbox={48.0,56.0},id=3908}

    local card=boss.card.New("雹符「冰雹暴风」",2.0,2.0,35.0,1500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"5a"}},LEVEL,"雹符「冰雹暴风」（Lunatic）",3908)

end

do

    local meta={stage=2,sub=25,group=5,life=13000,threshold=3200,hp=9800,shot=0,timeout=3000,epoch=0,invul=200,bounds={32.0,48.0,352.0,134.0},order=10,entry_x=0,entry_y=128,hitbox={48.0,56.0},id=3909}

    local card=boss.card.New("",3.3333333333333335,3.3333333333333335,50.0,9800,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"5a"}},LEVEL,"琪露诺 非符二（Lunatic）",3909)

end

do

    local meta={stage=2,sub=31,group=5,life=3200,threshold=1400,hp=1800,shot=0,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,134.0},order=11,entry_x=0,entry_y=128,hitbox={48.0,56.0},id=3910}

    local card=boss.card.New("冻符「完美冻结」",2.0,2.0,40.0,1800,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"5a"}},LEVEL,"冻符「完美冻结」（Lunatic）",3910)

end

do

    local meta={stage=2,sub=32,group=5,life=1400,threshold=0,hp=1400,shot=0,timeout=1980,epoch=60,invul=120,bounds={32.0,48.0,352.0,134.0},order=12,entry_x=0,entry_y=128,hitbox={48.0,56.0},id=3911}

    local card=boss.card.New("雪符「钻石风暴」",2.0,2.0,33.0,1400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"5a"}},LEVEL,"雪符「钻石风暴」（Lunatic）",3911)

end

do

    local meta={stage=3,sub=9,group=6,life=13000,threshold=1300,hp=11700,shot=0,timeout=1800,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=13,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3912}

    local card=boss.card.New("",0.0,0.0,30.0,11700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"6a"}},LEVEL,"三面中 Boss 非符（Lunatic）",3912)

end

do

    local meta={stage=3,sub=14,group=6,life=1300,threshold=0,hp=1300,shot=0,timeout=1200,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=14,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3913}

    local card=boss.card.New("华符「绚烂华灵」",0.0,0.0,20.0,1300,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"6a"}},LEVEL,"华符「绚烂华灵」（Lunatic）",3913)

end

do

    local meta={stage=3,sub=18,group=7,life=14000,threshold=1900,hp=12100,shot=0,timeout=1800,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=15,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3914}

    local card=boss.card.New("",0.0,0.0,30.0,12100,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"7a"}},LEVEL,"红美铃 非符一（Lunatic）",3914)

end

do

    local meta={stage=3,sub=29,group=7,life=1900,threshold=0,hp=1900,shot=0,timeout=1800,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=16,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3915}

    local card=boss.card.New("虹符「彩虹的风铃」",0.0,0.0,30.0,1900,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"7a"}},LEVEL,"虹符「彩虹的风铃」（Lunatic）",3915)

end

do

    local meta={stage=3,sub=20,group=7,life=12000,threshold=1400,hp=10600,shot=0,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=17,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3916}

    local card=boss.card.New("",0.0,0.0,40.0,10600,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"7a"}},LEVEL,"红美铃 非符二（Lunatic）",3916)

end

do

    local meta={stage=3,sub=30,group=7,life=1400,threshold=0,hp=1400,shot=0,timeout=2400,epoch=1,invul=0,bounds={32.0,48.0,352.0,144.0},order=18,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3917}

    local card=boss.card.New("幻符「华想梦葛」",0.0,0.0,40.0,1400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"7a"}},LEVEL,"幻符「华想梦葛」（Lunatic）",3917)

end

do

    local meta={stage=3,sub=26,group=7,life=16500,threshold=3400,hp=13100,shot=0,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=19,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3918}

    local card=boss.card.New("",0.0,0.0,40.0,13100,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"7a"}},LEVEL,"红美铃 非符三（Lunatic）",3918)

end

do

    local meta={stage=3,sub=32,group=7,life=3400,threshold=2000,hp=1400,shot=0,timeout=2160,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=20,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3919}

    local card=boss.card.New("彩符「彩光乱舞」",0.0,0.0,36.0,1400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"7a"}},LEVEL,"彩符「彩光乱舞」（Lunatic）",3919)

end

do

    local meta={stage=3,sub=33,group=7,life=2000,threshold=0,hp=2000,shot=0,timeout=2160,epoch=60,invul=0,bounds={32.0,48.0,352.0,144.0},order=21,entry_x=0.0,entry_y=80.0,hitbox={56.0,56.0},id=3920}

    local card=boss.card.New("彩符「极彩台风」",0.0,0.0,36.0,2000,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"7a"}},LEVEL,"彩符「极彩台风」（Lunatic）",3920)

end

do

    local meta={stage=4,sub=21,group=8,life=7000,threshold=0,hp=7000,shot=0,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,176.0},order=22,entry_x=0,entry_y=128,hitbox={40.0,56.0},id=3921}

    local card=boss.card.New("",0.0,0.0,40.0,7000,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"8a"}},LEVEL,"小恶魔 非符（Lunatic）",3921)

end

do

    local meta={stage=4,sub=27,group=9,life=17000,threshold=1500,hp=15500,shot=0,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=23,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3922}

    local card=boss.card.New("",0.0,0.0,40.0,15500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"9a"}},LEVEL,"帕秋莉 非符一（Lunatic·灵梦Ａ）",3922)

end

do

    local meta={stage=4,sub=43,group=9,life=1500,threshold=0,hp=1500,shot=0,timeout=1800,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=24,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3923}

    local card=boss.card.New("火符「火神之光上级」",2.0,2.0,30.0,1500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"9a"}},LEVEL,"火符「火神之光上级」（Lunatic·灵梦Ａ）",3923)

end

do

    local meta={stage=4,sub=37,group=9,life=16000,threshold=1500,hp=14500,shot=0,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=25,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3924}

    local card=boss.card.New("",0.0,0.0,40.0,14500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"9a"}},LEVEL,"帕秋莉 非符二（Lunatic·灵梦Ａ）",3924)

end

do

    local meta={stage=4,sub=52,group=9,life=1500,threshold=0,hp=1500,shot=0,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=26,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3925}

    local card=boss.card.New("土符「三石塔的震动」",2.0,2.0,35.0,1500,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"9a"}},LEVEL,"土符「三石塔的震动」（Lunatic·灵梦Ａ）",3925)

end

do

    local meta={stage=4,sub=55,group=9,life=1700,threshold=0,hp=1700,shot=0,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=27,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3926}

    local card=boss.card.New("火＆土符「熔岩巨石」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"9a"}},LEVEL,"火＆土符「熔岩巨石」（Lunatic·灵梦Ａ）",3926)

end

do

    local meta={stage=4,sub=58,group=9,life=1700,threshold=0,hp=1700,shot=0,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=28,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3927}

    local card=boss.card.New("金＆水符「水银之毒」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"9a"}},LEVEL,"金＆水符「水银之毒」（Lunatic·灵梦Ａ）",3927)

end

do

    local meta={stage=4,sub=56,group=9,life=1700,threshold=0,hp=1700,shot=0,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=29,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3928}

    local card=boss.card.New("木＆火符「森林大火」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"9a"}},LEVEL,"木＆火符「森林大火」（Lunatic·灵梦Ａ）",3928)

end

do

    local meta={stage=4,sub=27,group=15,life=17000,threshold=1600,hp=15400,shot=1,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=30,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3929}

    local card=boss.card.New("",0.0,0.0,40.0,15400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"15a"}},LEVEL,"帕秋莉 非符一（Lunatic·灵梦Ｂ）",3929)

end

do

    local meta={stage=4,sub=46,group=15,life=1600,threshold=0,hp=1600,shot=1,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=31,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3930}

    local card=boss.card.New("水符「湖葬」",2.0,2.0,35.0,1600,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"15a"}},LEVEL,"水符「湖葬」（Lunatic·灵梦Ｂ）",3930)

end

do

    local meta={stage=4,sub=37,group=15,life=16000,threshold=1600,hp=14400,shot=1,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=32,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3931}

    local card=boss.card.New("",0.0,0.0,40.0,14400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"15a"}},LEVEL,"帕秋莉 非符二（Lunatic·灵梦Ｂ）",3931)

end

do

    local meta={stage=4,sub=49,group=15,life=1600,threshold=0,hp=1600,shot=1,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=33,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3932}

    local card=boss.card.New("木符「翠绿风暴」",2.0,2.0,35.0,1600,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"15a"}},LEVEL,"木符「翠绿风暴」（Lunatic·灵梦Ｂ）",3932)

end

do

    local meta={stage=4,sub=57,group=15,life=1700,threshold=0,hp=1700,shot=1,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=34,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3933}

    local card=boss.card.New("水＆木符「水精灵」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"15a"}},LEVEL,"水＆木符「水精灵」（Lunatic·灵梦Ｂ）",3933)

end

do

    local meta={stage=4,sub=58,group=15,life=1700,threshold=0,hp=1700,shot=1,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=35,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3934}

    local card=boss.card.New("金＆水符「水银之毒」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"15a"}},LEVEL,"金＆水符「水银之毒」（Lunatic·灵梦Ｂ）",3934)

end

do

    local meta={stage=4,sub=59,group=15,life=1700,threshold=0,hp=1700,shot=1,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=36,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3935}

    local card=boss.card.New("土＆金符「翡翠巨石」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"15a"}},LEVEL,"土＆金符「翡翠巨石」（Lunatic·灵梦Ｂ）",3935)

end

do

    local meta={stage=4,sub=27,group=16,life=17000,threshold=1600,hp=15400,shot=2,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=37,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3936}

    local card=boss.card.New("",0.0,0.0,40.0,15400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"16a"}},LEVEL,"帕秋莉 非符一（Lunatic·魔理沙Ａ）",3936)

end

do

    local meta={stage=4,sub=48,group=16,life=1600,threshold=0,hp=1600,shot=2,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=38,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3937}

    local card=boss.card.New("木符「风灵角笛上级」",2.0,2.0,35.0,1600,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"16a"}},LEVEL,"木符「风灵角笛上级」（Lunatic·魔理沙Ａ）",3937)

end

do

    local meta={stage=4,sub=37,group=16,life=16000,threshold=1800,hp=14200,shot=2,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=39,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3938}

    local card=boss.card.New("",0.0,0.0,40.0,14200,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"16a"}},LEVEL,"帕秋莉 非符二（Lunatic·魔理沙Ａ）",3938)

end

do

    local meta={stage=4,sub=44,group=16,life=1800,threshold=0,hp=1800,shot=2,timeout=1800,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=40,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3939}

    local card=boss.card.New("火符「火神之光辉」",2.0,2.0,30.0,1800,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"16a"}},LEVEL,"火符「火神之光辉」（Lunatic·魔理沙Ａ）",3939)

end

do

    local meta={stage=4,sub=56,group=16,life=1700,threshold=0,hp=1700,shot=2,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=41,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3940}

    local card=boss.card.New("木＆火符「森林大火」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"16a"}},LEVEL,"木＆火符「森林大火」（Lunatic·魔理沙Ａ）",3940)

end

do

    local meta={stage=4,sub=59,group=16,life=1700,threshold=0,hp=1700,shot=2,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=42,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3941}

    local card=boss.card.New("土＆金符「翡翠巨石」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"16a"}},LEVEL,"土＆金符「翡翠巨石」（Lunatic·魔理沙Ａ）",3941)

end

do

    local meta={stage=4,sub=55,group=16,life=1700,threshold=0,hp=1700,shot=2,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=43,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3942}

    local card=boss.card.New("火＆土符「熔岩巨石」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"16a"}},LEVEL,"火＆土符「熔岩巨石」（Lunatic·魔理沙Ａ）",3942)

end

do

    local meta={stage=4,sub=27,group=17,life=17000,threshold=1800,hp=15200,shot=3,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=44,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3943}

    local card=boss.card.New("",0.0,0.0,40.0,15200,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"17a"}},LEVEL,"帕秋莉 非符一（Lunatic·魔理沙Ｂ）",3943)

end

do

    local meta={stage=4,sub=51,group=17,life=1800,threshold=0,hp=1800,shot=3,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=45,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3944}

    local card=boss.card.New("土符「三石塔上级」",2.0,2.0,35.0,1800,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"17a"}},LEVEL,"土符「三石塔上级」（Lunatic·魔理沙Ｂ）",3944)

end

do

    local meta={stage=4,sub=37,group=17,life=16000,threshold=1800,hp=14200,shot=3,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,144.0},order=46,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3945}

    local card=boss.card.New("",0.0,0.0,40.0,14200,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"17a"}},LEVEL,"帕秋莉 非符二（Lunatic·魔理沙Ｂ）",3945)

end

do

    local meta={stage=4,sub=54,group=17,life=1800,threshold=0,hp=1800,shot=3,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=47,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3946}

    local card=boss.card.New("金符「银龙」",2.0,2.0,35.0,1800,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"17a"}},LEVEL,"金符「银龙」（Lunatic·魔理沙Ｂ）",3946)

end

do

    local meta={stage=4,sub=59,group=17,life=1700,threshold=0,hp=1700,shot=3,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=48,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3947}

    local card=boss.card.New("土＆金符「翡翠巨石」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"17a"}},LEVEL,"土＆金符「翡翠巨石」（Lunatic·魔理沙Ｂ）",3947)

end

do

    local meta={stage=4,sub=57,group=17,life=1700,threshold=0,hp=1700,shot=3,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=49,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3948}

    local card=boss.card.New("水＆木符「水精灵」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"17a"}},LEVEL,"水＆木符「水精灵」（Lunatic·魔理沙Ｂ）",3948)

end

do

    local meta={stage=4,sub=58,group=17,life=1700,threshold=0,hp=1700,shot=3,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,144.0},order=50,entry_x=0.0,entry_y=96.0,hitbox={48.0,56.0},id=3949}

    local card=boss.card.New("金＆水符「水银之毒」",2.0,2.0,40.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"17a"}},LEVEL,"金＆水符「水银之毒」（Lunatic·魔理沙Ｂ）",3949)

end

do

    local meta={stage=5,sub=13,group=10,life=15000,threshold=710,hp=14290,shot=0,timeout=2400,epoch=0,invul=0,bounds={32.0,48.0,352.0,176.0},order=51,entry_x=0.0,entry_y=96.0,hitbox={40.0,56.0},id=3950}

    local card=boss.card.New("",0.0,0.0,40.0,14290,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"10a"}},LEVEL,"五面中 Boss 非符（Lunatic）",3950)

end

do

    local meta={stage=5,sub=18,group=10,life=710,threshold=0,hp=710,shot=0,timeout=1800,epoch=0,invul=120,bounds={32.0,48.0,352.0,176.0},order=52,entry_x=0.0,entry_y=96.0,hitbox={40.0,56.0},id=3951}

    local card=boss.card.New("奇术「迷惑误导」",2.0,2.0,30.0,710,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"10a"}},LEVEL,"奇术「迷惑误导」（Lunatic）",3951)

end

do

    local meta={stage=5,sub=22,group=11,life=19000,threshold=1400,hp=17600,shot=0,timeout=2700,epoch=0,invul=0,bounds={32.0,48.0,352.0,132.0},order=53,entry_x=0.0,entry_y=96.0,hitbox={56.0,56.0},id=3952}

    local card=boss.card.New("",0.0,0.0,45.0,17600,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"11a"}},LEVEL,"咲夜 非符一（Lunatic）",3952)

end

do

    local meta={stage=5,sub=45,group=11,life=1400,threshold=0,hp=1400,shot=0,timeout=1800,epoch=0,invul=120,bounds={32.0,48.0,352.0,132.0},order=54,entry_x=0.0,entry_y=96.0,hitbox={56.0,56.0},id=3953}

    local card=boss.card.New("幻幽「夜雾幻影杀人鬼」",2.0,2.0,30.0,1400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"11a"}},LEVEL,"幻幽「夜雾幻影杀人鬼」（Lunatic）",3953)

end

do

    local meta={stage=5,sub=34,group=11,life=17000,threshold=1400,hp=15600,shot=0,timeout=2700,epoch=0,invul=0,bounds={32.0,48.0,352.0,132.0},order=55,entry_x=0.0,entry_y=96.0,hitbox={56.0,56.0},id=3954}

    local card=boss.card.New("",0.0,0.0,45.0,15600,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"11a"}},LEVEL,"咲夜 非符二（Lunatic）",3954)

end

do

    local meta={stage=5,sub=47,group=11,life=1400,threshold=0,hp=1400,shot=0,timeout=1800,epoch=0,invul=120,bounds={32.0,48.0,352.0,132.0},order=56,entry_x=0.0,entry_y=96.0,hitbox={56.0,56.0},id=3955}

    local card=boss.card.New("幻世「世界」",2.0,2.0,30.0,1400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"11a"}},LEVEL,"幻世「世界」（Lunatic）",3955)

end

do

    local meta={stage=5,sub=41,group=11,life=16000,threshold=1700,hp=14300,shot=0,timeout=2700,epoch=0,invul=0,bounds={32.0,48.0,352.0,132.0},order=57,entry_x=0.0,entry_y=96.0,hitbox={56.0,56.0},id=3956}

    local card=boss.card.New("",0.0,0.0,45.0,14300,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"11a"}},LEVEL,"咲夜 非符三（Lunatic）",3956)

end

do

    local meta={stage=5,sub=50,group=11,life=1700,threshold=0,hp=1700,shot=0,timeout=1800,epoch=0,invul=120,bounds={32.0,48.0,352.0,132.0},order=58,entry_x=0.0,entry_y=96.0,hitbox={56.0,56.0},id=3957}

    local card=boss.card.New("女仆秘技「杀人玩偶」",2.0,2.0,30.0,1700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"11a"}},LEVEL,"女仆秘技「杀人玩偶」（Lunatic）",3957)

end

do

    local meta={stage=6,sub=9,group=12,life=6000,threshold=1100,hp=4900,shot=0,timeout=1020,epoch=0,invul=0,bounds={32.0,48.0,352.0,120.0},order=59,entry_x=0.0,entry_y=104.0,hitbox={40.0,56.0},id=3958}

    local card=boss.card.New("",0.0,0.0,17.0,4900,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"12a"}},LEVEL,"六面中 Boss 非符（Lunatic）",3958)

end

do

    local meta={stage=6,sub=14,group=12,life=1100,threshold=0,hp=1100,shot=0,timeout=900,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=60,entry_x=0.0,entry_y=104.0,hitbox={40.0,56.0},id=3959}

    local card=boss.card.New("奇术「永恒的温柔」",2.0,2.0,15.0,1100,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"12a"}},LEVEL,"奇术「永恒的温柔」（Lunatic）",3959)

end

do

    local meta={stage=6,sub=17,group=1,life=13000,threshold=1200,hp=11800,shot=0,timeout=2700,epoch=0,invul=0,bounds={32.0,48.0,352.0,120.0},order=1,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3960}

    local card=boss.card.New("",0.0,0.0,45.0,11800,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"1a"}},LEVEL,"蕾米莉亚 非符一（Lunatic）",3960)

end

do

    local meta={stage=6,sub=19,group=1,life=15500,threshold=1600,hp=13900,shot=0,timeout=2700,epoch=0,invul=0,bounds={32.0,48.0,352.0,120.0},order=3,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3961}

    local card=boss.card.New("",0.0,0.0,45.0,13900,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"1a"}},LEVEL,"蕾米莉亚 非符二（Lunatic）",3961)

end

do

    local meta={stage=6,sub=23,group=1,life=11000,threshold=1600,hp=9400,shot=0,timeout=2700,epoch=0,invul=0,bounds={32.0,48.0,352.0,120.0},order=5,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3962}

    local card=boss.card.New("",0.0,0.0,45.0,9400,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"1a"}},LEVEL,"蕾米莉亚 非符三（Lunatic）",3962)

end

do

    local meta={stage=6,sub=26,group=1,life=13000,threshold=1300,hp=11700,shot=0,timeout=3600,epoch=0,invul=0,bounds={32.0,48.0,352.0,120.0},order=7,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3963}

    local card=boss.card.New("",0.0,0.0,60.0,11700,nil,false)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"1a"}},LEVEL,"蕾米莉亚 非符四（Lunatic）",3963)

end

do

    local meta={stage=7,sub=22,group=13,life=1800,threshold=0,hp=1800,shot=0,timeout=2100,epoch=0,invul=120,bounds={32.0,48.0,352.0,104.0},order=70,entry_x=0.0,entry_y=120.0,hitbox={40,56},id=3964}

    local card=boss.card.New("月符「沉默的月神」",2.0,2.0,35.0,1800,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"13a"}},LEVEL,"月符「沉默的月神」（Extra）",3964)

end

do

    local meta={stage=7,sub=23,group=13,life=1450,threshold=0,hp=1450,shot=0,timeout=2880,epoch=0,invul=120,bounds={32.0,48.0,352.0,104.0},order=71,entry_x=0.0,entry_y=120.0,hitbox={40,56},id=3965}

    local card=boss.card.New("日符「皇家烈焰」",2.0,2.0,48.0,1450,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"13a"}},LEVEL,"日符「皇家烈焰」（Extra）",3965)

end

do

    local meta={stage=7,sub=24,group=13,life=1100,threshold=0,hp=1100,shot=0,timeout=2400,epoch=0,invul=120,bounds={32.0,48.0,352.0,104.0},order=72,entry_x=0.0,entry_y=120.0,hitbox={40,56},id=3966}

    local card=boss.card.New("火水木金土符「贤者之石」",2.0,2.0,40.0,1100,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"13a"}},LEVEL,"火水木金土符「贤者之石」（Extra）",3966)

end

do

    local meta={stage=7,sub=32,group=14,life=10000,threshold=1800,hp=8200,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=73,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3967}

    local card=boss.card.New("",0.5,0.5,30.0,8200,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符一（Extra）",3967)

end

do

    local meta={stage=7,sub=33,group=14,life=1800,threshold=0,hp=1800,shot=0,timeout=3300,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=74,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3968}

    local card=boss.card.New("禁忌「红莓陷阱」",2.0,2.0,55.0,1800,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁忌「红莓陷阱」（Extra）",3968)

end

do

    local meta={stage=7,sub=35,group=14,life=8000,threshold=1200,hp=6800,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=75,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3969}

    local card=boss.card.New("",0.5,0.5,30.0,6800,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符二（Extra）",3969)

end

do

    local meta={stage=7,sub=36,group=14,life=1200,threshold=0,hp=1200,shot=0,timeout=3300,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=76,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3970}

    local card=boss.card.New("禁忌「莱瓦汀」",2.0,2.0,55.0,1200,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁忌「莱瓦汀」（Extra）",3970)

end

do

    local meta={stage=7,sub=38,group=14,life=8000,threshold=1900,hp=6100,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=77,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3971}

    local card=boss.card.New("",0.5,0.5,30.0,6100,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符三（Extra）",3971)

end

do

    local meta={stage=7,sub=39,group=14,life=1900,threshold=0,hp=1900,shot=0,timeout=3900,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=78,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3972}

    local card=boss.card.New("禁忌「四重存在」",2.0,2.0,65.0,1900,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁忌「四重存在」（Extra）",3972)

end

do

    local meta={stage=7,sub=43,group=14,life=8000,threshold=2400,hp=5600,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=79,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3973}

    local card=boss.card.New("",0.5,0.5,30.0,5600,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符四（Extra）",3973)

end

do

    local meta={stage=7,sub=44,group=14,life=2400,threshold=0,hp=2400,shot=0,timeout=3900,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=80,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3974}

    local card=boss.card.New("禁忌「笼中鸟」",2.0,2.0,65.0,2400,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁忌「笼中鸟」（Extra）",3974)

end

do

    local meta={stage=7,sub=47,group=14,life=10000,threshold=1400,hp=8600,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=81,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3975}

    local card=boss.card.New("",0.5,0.5,30.0,8600,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符五（Extra）",3975)

end

do

    local meta={stage=7,sub=48,group=14,life=1400,threshold=0,hp=1400,shot=0,timeout=3600,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=82,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3976}

    local card=boss.card.New("禁忌「恋之迷宫」",2.0,2.0,60.0,1400,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁忌「恋之迷宫」（Extra）",3976)

end

do

    local meta={stage=7,sub=49,group=14,life=10000,threshold=2200,hp=7800,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=83,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3977}

    local card=boss.card.New("",0.5,0.5,30.0,7800,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符六（Extra）",3977)

end

do

    local meta={stage=7,sub=50,group=14,life=2200,threshold=0,hp=2200,shot=0,timeout=4200,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=84,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3978}

    local card=boss.card.New("禁弹「星弧破碎」",2.0,2.0,70.0,2200,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁弹「星弧破碎」（Extra）",3978)

end

do

    local meta={stage=7,sub=53,group=14,life=10000,threshold=1520,hp=8480,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=85,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3979}

    local card=boss.card.New("",0.5,0.5,30.0,8480,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符七（Extra）",3979)

end

do

    local meta={stage=7,sub=54,group=14,life=1520,threshold=0,hp=1520,shot=0,timeout=4200,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=86,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3980}

    local card=boss.card.New("禁弹「折反射」",2.0,2.0,70.0,1520,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁弹「折反射」（Extra）",3980)

end

do

    local meta={stage=7,sub=56,group=14,life=10000,threshold=1800,hp=8200,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=87,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3981}

    local card=boss.card.New("",0.5,0.5,30.0,8200,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符八（Extra）",3981)

end

do

    local meta={stage=7,sub=57,group=14,life=1800,threshold=0,hp=1800,shot=0,timeout=4200,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=88,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3982}

    local card=boss.card.New("禁弹「刻着过去的钟表」",2.0,2.0,70.0,1800,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"禁弹「刻着过去的钟表」（Extra）",3982)

end

do

    local meta={stage=7,sub=59,group=14,life=1000,threshold=1000,hp=1,shot=0,timeout=1800,epoch=0,invul=30,bounds={32.0,48.0,352.0,120.0},order=89,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3983}

    local card=boss.card.New("",0.5,0.5,30.0,1,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"芙兰朵露 非符九（Extra）",3983)

end

do

    local meta={stage=7,sub=60,group=14,life=1000,threshold=0,hp=1000,shot=0,timeout=5160,epoch=0,invul=5160,bounds={32.0,48.0,352.0,120.0},order=90,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3984}

    local card=boss.card.New("秘弹「之后就一个人都没有了吗？」",86.0,86.0,86.0,1000,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"秘弹「之后就一个人都没有了吗？」（Extra）",3984)

end

do

    local meta={stage=7,sub=68,group=14,life=6000,threshold=0,hp=6000,shot=0,timeout=9000,epoch=0,invul=120,bounds={32.0,48.0,352.0,120.0},order=91,entry_x=0.0,entry_y=128.0,hitbox={56.0,56.0},id=3985}

    local card=boss.card.New("ＱＥＤ「４９５年的波纹」",2.0,2.0,150.0,6000,nil,true)

    card.th06_source=meta;card.th06_order=meta.order

    function card:before() self.th06=nil end

    function card:init() H.card_init(self,meta) end

    function card:del() H.card_del(self) end

    boss.card.add({{card,"14a"}},LEVEL,"ＱＥＤ「４９５年的波纹」（Extra）",3985)

end

do

    local remilia=_editor_boss["1a"..LEVEL]

    if remilia and remilia.cards then

        local order={[3960]=1,[3802]=2,[3961]=3,[3805]=4,[3962]=5,[3808]=6,[3963]=7,[3811]=8,[369]=9}

        for _,card in ipairs(remilia.cards) do card.th06_order=order[card.card_id] or 100 end

        table.sort(remilia.cards,function(a,b) return a.th06_order<b.th06_order end)

    end

end

class.boss_order={2,3,4,5,6,7,8,9,15,16,17,10,11,12,1,13,14}

-- TH06_EXPANDED_END

end

local function NewText(x, y, layer, text, alpha, color, lifetime, f, viewmode, ...)
    if _G.SimpleText == nil then return end
    return New(_G.SimpleText, x, y, layer, text, alpha, color, lifetime, f, viewmode, ...)
end

local function NewBulletLW34(...)
    if bullet_lw3_4 == nil then return end
    return New(bullet_lw3_4, ...)
end

local function NewBulletLW35(...)
    if bullet_lw3_5 == nil then return end
    return New(bullet_lw3_5, ...)
end


local card = boss.card.New("「克罗里·尤斯福德」", 11, 11, 11, 2000)
function card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
    task.MoveTo(0, 120, 60, 2)
end

function card:init()
    task.New(self, function()
        NewText(480, 550, nil,
                "克罗里·尤斯福德，漫画《终结的炽天使》及其衍生作品中人物",
                255, { 250, 128, 114 }, nil, function()
                    local self = task.GetSelf()
                    task.MoveTo(480, 330, 80, 2)
                    task.Wait(80)
                    NewText(480, 550, nil,
                            "实力强悍，与第十三始祖的排位不符",
                            255, { 250, 128, 194 }, nil, function()
                                task.MoveTo(480, 330, 110, 2)
                                task.Wait(100)
                                task.MoveTo(480, -100, 40, VALUE_SET.ACCEL)
                                object.RawDel(task.GetSelf())
                            end, "ui", "center")
                    task.MoveTo(480, -100, 40, VALUE_SET.ACCEL)
                    object.RawDel(self)
                end, "ui", "center")

    local a, old_x, old_y, x, y, angle, radius, v
    while true do
        self.t = false
        a = -90 + ran:Float(-20, 20)
        for _ = 1, 70 do
            NewBulletLW34(self.x, self.y, 150, a, self.x, self.y, 7)
                a = a + 360 / 75
            end

            old_x, old_y = self.x, self.y
            task.MoveToPlayer(60, -200, 200, 70, 120,
                    32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
            task.Wait(40)

            Newcharge_in(self.x, self.y, 255, 30, 30)
            task.Wait(60)
            misc.ShakeScreen(30, 0.4)
            Newcharge_out(self.x, self.y, 255, 30, 30)
            self.t = true

            v = 6
            for _ = 1, 30 do
                for _ = 1, 30 do
                    a = ran:Float(0, 360)
                    radius = ran:Float(150, 300)
                    x = old_x + cos(a) * radius
                    y = old_y + sin(a) * radius
                    NewSimpleBullet(square, 1, x, y, 8 + v, a + ran:Float(-25, 25))
                end
                angle = ran:Float(0, 360)
                radius = ran:Float(150, 300)
                NewBulletLW35(
                        old_x + cos(angle) * radius, old_y + sin(angle) * radius,
                        2, ball_mid, 0, ran:Float(0.4, 0.8), ran:Float(0, 360))
                task.Wait()
                v = v + 2 / 29
            end
            task.Wait(20)
        end
    end)
end

boss.card.add({ { card, "1a" } }, 30, "「克罗里·尤斯福德」", 368)
