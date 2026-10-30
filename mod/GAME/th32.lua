---=====================================
---TH32 猩红测试：红魔乡 Lunatic / Extra 全部 Boss 战和道中（含中 Boss）。
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
---14 张场外道中载体按原始时间轴分前后半；六面后半是无敌机的入场等待。
---非冻结轴在中 Boss 战期间继续推进；后半整关衔接会扣除中 Boss 的原生攻击帧。
---差异 4：切卡按项目框架清场，框架入场/结算帧不推进原作道中轴；单卡练习从完整段重放。
---原作 P/大P/满P 用信仰道具代理，Bomb 用蓄力道具代理，残机用增失误额度道具代理。
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
H.road_clocks={}
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
function H.run_actor(a,initial)
    if a.dead or coroutine.status(a.co)=="dead" then return end
    local tick=a.object.th06.tick or 0
    if not initial and a.resume_tick==tick then return end
    if not initial then a.resume_tick=tick end
    local ok,err=coroutine.resume(a.co)
    if not ok and err~=STOP then error(err,0) end
end
function H.kill_actor(a)
    if a.dead then return end
    if a.object.th06.road then
        if a.death_mode==3 then
            a.object.hp=1;a.damageable=false;a.death_mode=0
            return
        end
        H.enemy_drop(a)
        if (a.death_mode or 0)==0 then a.dead=true;object.RawDel(a.object);return end
    end
    if a.death then
        local fn=a.death;a.death=nil;a.object.hp=max(1,a.object.hp)
        a.interactable=false;a.damageable=false;a.resume_tick=nil
        local prior=a.context;a.context={}
        for k,value in pairs(prior) do a.context[k]=value end
        a.context.time,a.context.epoch=0,0;a.death_life=0
        a.co=coroutine.create(function() fn(a.object,a.context) end)
        H.run_actor(a)
    else a.dead=true;object.RawDel(a.object) end
end
class["原作使魔"] = Class(enemy, {
    init=function(b,s,stage,sub,x,y,z,hp,drop,score)
        enemy.init(b,15,max(1,hp),false,false,false)
        b.bound=false;b.x,b.y=x-192,224-y
        local a=H.new_actor(s,b,stage,sub,false,{epoch=0,threshold=0})
        a.z=z;a.initial_life=hp;a.drop=drop;a.score=score
        H.run_actor(a,true)
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
function H.spawn(b,stage,sub,x,y,z,hp,drop,score)
    local s=b.th06;local count=0
    for _,a in ipairs(s.actors) do if not a.dead then count=count+1 end end
    if count>=256 then return end
    H.trace(b,"spawn",stage,sub,x,y,z,hp)
    return New(class["原作使魔"],s,stage,sub,x,y,z,hp,drop,score)
end
function H.actor_motion(a)
    local b=a.object
    -- Enemy::Move 的镜像只反射最终 x 位移，不修改极坐标角度或绝对插值目标。
    b.x,b.y=b.x+(a.mirrored and -a.axisx or a.axisx),b.y-a.axisy
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
    if count_phase~=false then
        a.phase=a.phase+1
        if a.main and not a.meta.road then H.road_mid_tick(a) end
    end
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
        s.tick=(s.tick or 0)+1
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
    elseif not a.main and b.th06.road and id<128 and b._wisys then
        -- 原作姿态脚本共用一组妖精图；用现成颜色/体型代理，不按姿态号反复重建。
        local family=math.floor(id/6)
        local style=({1,2,3,4,10,11,12,13,14,15,16,17,18})[family%13+1]
        if a.road_style~=style and b._wisys.SetImage then
            local aa,bb,rect=b.a,b.b,b.rect
            b._wisys:SetImage(style,8);a.road_style=style
            b.a,b.b,b.rect=aa,bb,rect
        end
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

-- 道中空载体：普通敌机共用上面的原生敌机/弹池；宿主在场外、无判定、无血条。
local ROAD_MID_GROUP={2,4,6,8,10,12,13}
local RANDOM_DROPS={0,0,1,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,0,0,1,0,0,1,0,0,0,1,1,0,0,2}
function H.road_scene()
    local st=rawget(_G,"stage")
    return st and st.current_stage or false
end
function H.road_mid_tick(a)
    local clock=H.road_clocks[a.stage]
    if clock and clock.owner==H.road_scene() and clock.phase=="mid" and not clock.frozen
        and a.meta.group==ROAD_MID_GROUP[a.stage] then
        clock.ticks=clock.ticks+1
    end
end
function H.road_init(b,meta)
    local scene=H.road_scene();local clock=H.road_clocks[meta.stage]
    if meta.part=="before" then
        clock={owner=scene,phase="pre",ticks=0,frozen=meta.frozen,drops={count=0,index=1}}
        H.road_clocks[meta.stage]=clock
    end
    local seek=0
    if meta.part=="after" and clock and clock.owner==scene then
        if not meta.frozen then seek=min(meta.timeout,clock.ticks) end
        clock.phase="post"
    end
    local runtime={}
    for k,value in pairs(meta) do runtime[k]=value end
    runtime.epoch=seek
    b.th06_previous_context=nil
    H.card_init(b,runtime)
    local s,a=b.th06,b.th06_actor
    s.road=true;s.road_drop_state=(clock and clock.owner==scene and clock.drops) or {count=0,index=1}
    a.damageable,a.collidable,a.interactable,a.invisible=false,false,false,true
    a.timeout=max(1,meta.timeout-seek)
    b.x,b.y,b._colli,b.colli,b._a=0,400,false,false,0
    b.no_hp_render,b.NotPlayTimeOutSound=true,true
    -- 卡表保存完整段时长；整关内后半按实际中 Boss 时钟缩短，单卡练习从完整段起点重放。
    b.t1,b.t2,b.t3=a.timeout,a.timeout,a.timeout
    H.trace(b,"road_begin",meta.id,meta.base,meta.ending,seek)
end
function H.road_del(b)
    local meta=b.th06_meta
    if meta and meta.part=="before" then
        local clock=H.road_clocks[meta.stage]
        if clock and clock.owner==H.road_scene() then clock.phase="mid";clock.ticks=0 end
    end
    H.card_del(b)
end
function H.timeline_spawn(b,op,sub,x,y,z,hp,drop,score)
    -- 随机创建按 GameManager 的自机活动区尺寸取值；原作这里没有加活动区左上偏移。
    if op>=4 then
        if x<=-990 then x=ran:Float(0,368) end
        if y<=-990 then y=ran:Float(0,416) end
        if z<=-990 then z=ran:Float(0,800) end
    end
    local mirrored=op==2 or op==3 or op==6 or op==7
    H.trace(b,"timeline_spawn",op,sub,x,y,z,hp,drop,score,mirrored)
    local obj=H.spawn(b,b.th06_actor.stage,sub,x,y,z,hp,drop,score)
    -- SpawnEnemy 的首次 RunEcl 先发生，主时间轴随后才置 mirrored。
    if obj and IsValid(obj) then obj.th06_actor.mirrored=mirrored end
    return obj
end
function H.drop_item(b,id)
    if not b.th06.road then return end
    local lib=rawget(_G,"item")
    local objects=lib and lib.obj
    if not objects then return end
    local proxy={ [0]=objects.faith,[1]=objects.point,[2]=objects.faith,[3]=objects.addcharge,
        [4]=objects.faith,[5]=objects.addmisscount,[6]=objects.faith_minor }
    if proxy[id] then New(proxy[id],b.x,b.y) end
    H.trace(b,"drop",id,b.x,b.y)
end
function H.enemy_drop(a)
    if a.loot_done or not a.object.th06.road then return end
    a.loot_done=true
    H.trace(a.object,"enemy_defeat",a.sub,a.initial_life or 1)
    if a.score and a.score>=0 and lstg and lstg.var and lstg.var.score then lstg.var.score=lstg.var.score+a.score end
    local id=a.drop or -2
    if id==-1 then
        local state=a.object.th06.road_drop_state
        if state.count%3==0 then
            id=RANDOM_DROPS[state.index];state.index=state.index%#RANDOM_DROPS+1
        else id=-2 end
        state.count=state.count+1
    end
    if id>=0 then H.drop_item(a.object,id) end
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

-- 第 1 面，原生 Sub0，起始 0x70。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,0)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,6,1,1,3.0,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,120,true)
        H.wait(b,v,40)
        a.angular=-0.02454369328916073;a.mode="velocity"
        H.wait(b,v,120)
        a.angular=0.019634954631328583;a.mode="velocity"
        H.wait(b,v,220)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[1][0]=B.part1
end

-- 第 1 面，原生 Sub1，起始 0x15c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,0)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,6,1,1,3.0,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,120,true)
        H.wait(b,v,100)
        a.angular=0.019634954631328583;a.mode="velocity"
        H.wait(b,v,200)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[1][1]=B.part1
end

-- 第 1 面，原生 Sub2，起始 0x238。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,3)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.offsetx,a.offsety,a.offsetz=12.0,-12.0,0.0
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,60)
        H.sprite(b,5)
        a.speed=0.0;a.mode="velocity"
        H.wait(b,v,70)
        H.pattern(b,1,1,2,11,2,1.399999976158142,0.5,0.0,0.15707963705062866,3)
        H.wait(b,v,130)
        a.accel=0.05000000074505806;a.mode="velocity"
        a.angular=0.05235987901687622;a.mode="velocity"
        H.wait(b,v,190)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[1][2]=B.part1
end

-- 第 1 面，原生 Sub3，起始 0x3b8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,3)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.offsetx,a.offsety,a.offsetz=12.0,-12.0,0.0
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,60)
        H.sprite(b,5)
        a.speed=0.0;a.mode="velocity"
        H.wait(b,v,70)
        H.pattern(b,1,1,2,5,1,1.399999976158142,0.0,0.0,0.2617993950843811,3)
        H.wait(b,v,130)
        a.accel=0.05000000074505806;a.mode="velocity"
        a.angular=0.05235987901687622;a.mode="velocity"
        H.wait(b,v,190)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[1][3]=B.part1
end

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
        a.death_mode=1
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
        a.death_mode=2
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
        a.death_mode=3
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

-- 第 2 面，原生 Sub0，起始 0x94。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.death_mode=1
        a.death=P[2][5]
        a.angle,a.speed=0.7853981852531433,3.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,3,4,11,10,2,2.5,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,180,true)
        a.accel=-0.014999999664723873;a.mode="velocity"
        H.wait(b,v,180)
        H.interval(b,0,false)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][0]=B.part1
end

-- 第 2 面，原生 Sub1，起始 0x1e8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.1780972480773926,3.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,3,4,11,10,2,2.5,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,180,true)
        a.accel=-0.014999999664723873;a.mode="velocity"
        H.wait(b,v,200)
        H.interval(b,0,false)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][1]=B.part1
end

-- 第 2 面，原生 Sub2，起始 0x31c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.death_mode=1
        a.death=P[2][5]
        a.angle,a.speed=1.5707963705062866,3.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,3,4,11,10,2,2.5,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,180,true)
        a.accel=-0.014999999664723873;a.mode="velocity"
        H.wait(b,v,200)
        H.interval(b,0,false)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][2]=B.part1
end

-- 第 2 面，原生 Sub3，起始 0x470。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.9634953737258911,3.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,3,4,11,10,2,2.5,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,180,true)
        a.accel=-0.014999999664723873;a.mode="velocity"
        H.wait(b,v,200)
        H.interval(b,0,false)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][3]=B.part1
end

-- 第 2 面，原生 Sub4，起始 0x5a4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.death_mode=1
        a.death=P[2][5]
        a.angle,a.speed=2.356194496154785,3.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,3,4,11,10,2,2.5,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,180,true)
        a.accel=-0.014999999664723873;a.mode="velocity"
        H.wait(b,v,200)
        H.interval(b,0,false)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][4]=B.part1
end

-- 第 2 面，原生 Sub5，起始 0x77c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,1)
        H.pattern(b,5,2,2,10,1,2.0,0.0,0.0,0.0,4)
        H.erase(b)
    end
    P[2][5]=B.part1
end

-- 第 2 面，原生 Sub6，起始 0x7c4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,0)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle=H.player_angle(b)+(0.0);a.speed=2.4000000953674316;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,6,3,1,2.5,0.0,0.0,0.19634954631328583,4)
        a.muted=false
        H.interval(b,120,true)
        H.wait(b,v,180)
        a.angular=-0.02454369328916073;a.mode="velocity"
        H.wait(b,v,280)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][6]=B.part1
end

-- 第 2 面，原生 Sub7，起始 0x8a0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        b.a,b.b,b.rect=(16.0)/2,(16.0)/2,true
        H.rand_angle(b,0.7853981852531433,2.356194496154785,false)
        a.speed=3.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][7]=B.part1
end

-- 第 2 面，原生 Sub8，起始 0x918。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(22.0)/2,(22.0)/2,true
        H.rand_angle(b,0.7853981852531433,2.356194496154785,false)
        a.speed=5.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][8]=B.part1
end

-- 第 2 面，原生 Sub9，起始 0x9a0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,9)
        b.a,b.b,b.rect=(22.0)/2,(22.0)/2,true
        H.rand_angle(b,0.7853981852531433,2.356194496154785,false)
        a.speed=5.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][9]=B.part1
end

-- 第 2 面，原生 Sub10，起始 0xa28。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,10)
        b.a,b.b,b.rect=(22.0)/2,(22.0)/2,true
        H.rand_angle(b,0.7853981852531433,2.356194496154785,false)
        a.speed=5.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][10]=B.part1
end

-- 第 2 面，原生 Sub11，起始 0xab0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,11)
        b.a,b.b,b.rect=(22.0)/2,(22.0)/2,true
        H.rand_angle(b,0.7853981852531433,2.356194496154785,false)
        a.speed=5.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][11]=B.part1
end

-- 第 2 面，原生 Sub12，起始 0xb38。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,3)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.offsetx,a.offsety,a.offsetz=12.0,-12.0,0.0
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,60)
        H.sprite(b,5)
        a.speed=0.0;a.mode="velocity"
        H.wait(b,v,70)
        H.pattern(b,1,1,1,11,5,2.4000000953674316,0.800000011920929,0.0,0.2617993950843811,3)
        H.wait(b,v,130)
        a.accel=0.05000000074505806;a.mode="velocity"
        a.angular=0.05235987901687622;a.mode="velocity"
        H.wait(b,v,190)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[2][12]=B.part1
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
        H.drop_item(b,3)
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
        a.death_mode=1
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
        a.death_mode=3
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

-- 第 3 面，原生 Sub0，起始 0x9c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,3,4,6,10,2,3.0,1.0,0.0,0.13089969754219055,4)
        a.muted=false
        H.interval(b,200,true)
        a.angle,a.speed=0.5235987901687622,4.5;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=-0.06544984877109528;a.mode="velocity"
        H.wait(b,v,115)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][0]=B.part1
end

-- 第 3 面，原生 Sub1，起始 0x1b4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,3,4,6,10,2,3.0,1.0,0.0,0.13089969754219055,4)
        a.muted=false
        H.interval(b,200,true)
        a.angle,a.speed=0.5235987901687622,4.5;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=-0.06544984877109528;a.mode="velocity"
        H.wait(b,v,115)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][1]=B.part1
end

-- 第 3 面，原生 Sub2，起始 0x2cc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,3,4,6,10,2,3.0,1.0,0.0,0.13089969754219055,4)
        a.muted=false
        H.interval(b,200,true)
        a.angle,a.speed=-1.0471975803375244,4.0;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=0.03490658476948738;a.mode="velocity"
        H.wait(b,v,90)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][2]=B.part1
end

-- 第 3 面，原生 Sub3，起始 0x3e4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,3,4,6,10,2,3.0,1.0,0.0,0.13089969754219055,4)
        a.muted=false
        H.interval(b,200,true)
        a.angle,a.speed=-1.0471975803375244,4.0;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=0.03490658476948738;a.mode="velocity"
        H.wait(b,v,90)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][3]=B.part1
end

-- 第 3 面，原生 Sub4，起始 0x4fc。
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
        H.wait(b,v,70)
        v.f0=(H.player_angle(b))+(0.0)
        v.f1=1.600000023841858
        v.c0=30
        a.accel=0.0;a.mode="velocity"
        H.pattern(b,3,3,6,16,1,1.600000023841858,0.0,v.f0,0.39269909262657166,4)
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,2,4,6,5,1,v.f1,0.0,v.f0,0.2617993950843811,4)
        v.f1=(v.f1)+(0.20999999344348907)
        v.i0=math.fmod(v.c0,3)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=70;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,72)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part2(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,72)
        v.f2=ran:Float(0,1.5707963705062866)
        v.f2=(v.f2)+(0.7853981852531433)
        a.angle,a.speed=v.f2,1.5;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][4]=B.part1
end

-- 第 3 面，原生 Sub5，起始 0x764。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,16)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,1.5;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.05000000074505806;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        v.f1=ran:Float(0,1.0)
        v.f1=(v.f1)+(1.0)
        H.pattern(b,1,1,2,24,3,v.f1,1.0,0.0,0.22439947724342346,4)
        v.f2=ran:Float(0,1.5707963705062866)
        v.f2=(v.f2)+(0.7853981852531433)
        H.wait(b,v,100)
        a.angle,a.speed=v.f2,-1.5;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][5]=B.part1
end

-- 第 3 面，原生 Sub6，起始 0x908。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,0)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,1,7,1,2.5,0.0,0.0,0.03490658476948738,4)
        a.muted=false
        H.interval(b,90,true)
        H.wait(b,v,40)
        a.angular=-0.02454369328916073;a.mode="velocity"
        H.wait(b,v,120)
        a.angular=0.019634954631328583;a.mode="velocity"
        H.wait(b,v,220)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][6]=B.part1
end

-- 第 3 面，原生 Sub7，起始 0xab8。
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
        H.wait(b,v,70)
        v.f0=1.5707963705062866
        v.f1=1.600000023841858
        v.c0=16
        a.accel=0.0;a.mode="velocity"
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,2,4,6,5,1,v.f1,0.0,v.f0,0.5235987901687622,4)
        v.f1=(v.f1)+(0.30000001192092896)
        v.i0=math.fmod(v.c0,3)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=70;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,72)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part2(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,72)
        v.f2=ran:Float(0,1.5707963705062866)
        v.f2=(v.f2)+(0.7853981852531433)
        a.angle,a.speed=v.f2,-1.5;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][7]=B.part1
end

-- 第 3 面，原生 Sub8，起始 0xd1c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,15)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.5;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.0833333358168602;a.mode="velocity"
        H.wait(b,v,70)
        v.f0=1.5707963705062866
        v.f1=1.600000023841858
        v.c0=16
        a.accel=0.0;a.mode="velocity"
        a.extra={-1,-1,-1,-1,0.02500000037252903,1.5707963705062866,-1.0,-1.0}
        H.pattern(b,9,3,15,22,1,2.0,0.30000001192092896,0.0,-3.1415927410125732,25)
        v.f2=ran:Float(0,1.5707963705062866)
        v.f2=(v.f2)+(0.7853981852531433)
        a.angle,a.speed=v.f2,1.5;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[3][8]=B.part1
end

-- 第 3 面，原生 Sub9，起始 0xefc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.damageable=false
        a.interactable=false
        a.death_mode=1
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
        H.drop_item(b,5)
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
        H.spawn(b,3,25,32.0,-32.0,0.0,2000,1,2000)
        H.spawn(b,3,25,352.0,-32.0,0.0,1000,1,2000)
        H.wait(b,v,30)
        H.spawn(b,3,25,96.0,-32.0,0.0,500,1,2000)
        H.spawn(b,3,25,288.0,-32.0,0.0,2000,1,2000)
        H.wait(b,v,60)
        H.spawn(b,3,25,160.0,-32.0,0.0,1000,1,2000)
        H.spawn(b,3,25,224.0,-32.0,0.0,500,1,2000)
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
        a.death_mode=3
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

-- 第 4 面，原生 Sub0，起始 0x104。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        H.spawn(b,4,1,(b.x+192),(224-b.y),a.z,1000,0,10)
        a.accel=0.0;a.mode="velocity"
        v.f0=ran:Float(0,1.5707963705062866)+0.7853981852531433
        a.angle,a.speed=v.f0,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][0]=B.part1
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

-- 第 4 面，原生 Sub2，起始 0x38c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,1,2,6,8,2,1.7999999523162842,1.0,0.0,0.2617993950843811,4)
        a.muted=false
        H.interval(b,50,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.collidable=false
        a.angle,a.speed=0.0,4.199999809265137;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=-0.06544984877109528;a.mode="velocity"
        H.wait(b,v,70)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][2]=B.part1
end

-- 第 4 面，原生 Sub3，起始 0x50c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,1,2,6,9,2,1.7999999523162842,1.0,0.0,0.2617993950843811,4)
        a.muted=false
        H.interval(b,50,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.collidable=false
        a.angle,a.speed=-1.0471975803375244,4.199999809265137;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=0.06544984877109528;a.mode="velocity"
        H.wait(b,v,70)
        a.angular=-0.13089969754219055;a.mode="velocity"
        H.wait(b,v,150)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][3]=B.part1
end

-- 第 4 面，原生 Sub4，起始 0x69c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,1,2,6,5,3,1.5,0.699999988079071,0.0,0.2617993950843811,4)
        a.muted=false
        H.interval(b,128,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.collidable=false
        a.angle,a.speed=0.0,4.199999809265137;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=-0.06544984877109528;a.mode="velocity"
        H.wait(b,v,70)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][4]=B.part1
end

-- 第 4 面，原生 Sub5，起始 0x81c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,1,2,6,5,3,1.5,0.699999988079071,0.0,0.2617993950843811,4)
        a.muted=false
        H.interval(b,128,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.collidable=false
        a.angle,a.speed=-1.0471975803375244,4.5;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=0.06544984877109528;a.mode="velocity"
        H.wait(b,v,70)
        a.angular=-0.13089969754219055;a.mode="velocity"
        H.wait(b,v,150)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][5]=B.part1
end

-- 第 4 面，原生 Sub6，起始 0x9ac。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.collidable=false
        a.angle,a.speed=0.0,4.5;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=-0.06544984877109528;a.mode="velocity"
        H.wait(b,v,70)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][6]=B.part1
end

-- 第 4 面，原生 Sub7，起始 0xa44。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.collidable=false
        a.angle,a.speed=-1.0471975803375244,4.5;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=0.06544984877109528;a.mode="velocity"
        H.wait(b,v,110)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][7]=B.part1
end

-- 第 4 面，原生 Sub8，起始 0xadc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,1,2,6,9,2,2.299999952316284,1.2000000476837158,0.0,0.1745329201221466,4)
        a.muted=false
        H.interval(b,50,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.collidable=false
        a.angle,a.speed=1.5707963705062866,4.5;a.mode="velocity"
        H.wait(b,v,100)
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][8]=B.part1
end

-- 第 4 面，原生 Sub9，起始 0xc3c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,1,2,6,9,2,2.299999952316284,1.2000000476837158,0.0,0.1745329201221466,4)
        a.muted=false
        H.interval(b,50,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.collidable=false
        a.angle,a.speed=0.0,4.5;a.mode="velocity"
        H.wait(b,v,100)
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][9]=B.part1
end

-- 第 4 面，原生 Sub10，起始 0xd9c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=0.0,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        H.spawn(b,4,1,(b.x+192),(224-b.y),a.z,1000,0,10)
        a.accel=0.0;a.mode="velocity"
        v.f0=ran:Float(0,1.5707963705062866)+0.7853981852531433
        a.angle,a.speed=v.f0,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][10]=B.part1
end

-- 第 4 面，原生 Sub11，起始 0xe64。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,10)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.death_mode=1
        a.death=P[4][12]
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        v.c0=64
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.i0=H.random_int(2)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=70;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.f1=0.2416609674692154
        v.time=70;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.f1=-0.2416609674692154
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,4,2,6,9,3,3.200000047683716,1.7999999523162842,v.f0,0.0,4)
        v.f0=(v.f0)+(v.f1)
        H.wait(b,v,78)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,78)
        a.angle,a.speed=-1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][11]=B.part1
end

-- 第 4 面，原生 Sub12，起始 0x10a4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.cancel(b)
        H.erase(b)
    end
    P[4][12]=B.part1
end

-- 第 4 面，原生 Sub13，起始 0x10dc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,10)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=0.0,2.0;a.mode="velocity"
        a.death_mode=1
        a.death=P[4][12]
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        v.c0=64
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.i0=H.random_int(2)
        v.cmp=(v.i0)-(0)
        if v.cmp~=0 then v.time=70;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.f1=0.2416609674692154
        v.time=70;return B.part4(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.f1=-0.2416609674692154
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,4,2,6,3,2,2.0999999046325684,1.399999976158142,v.f0,0.0,4)
        v.f0=(v.f0)+(v.f1)
        H.wait(b,v,78)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,78)
        a.angle,a.speed=-1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][13]=B.part1
end

-- 第 4 面，原生 Sub14，起始 0x1298。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.death_mode=1
        a.death=P[4][15]
        H.wait(b,v,30)
        a.interactable=true
        v.c0=60
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=30;return B.part4(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,3,0,10,7,1,1.2000000476837158,1.0,v.f0,0.0,5)
        v.f1=(v.f0)+(0.4487989544868469)
        H.pattern(b,3,3,10,7,1,1.2000000476837158,1.0,v.f1,0.0,5)
        v.time=30;return B.part10(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.cmp=((a.stage==7 and 4 or 3))-(1)
        if v.cmp~=0 then v.time=30;return B.part6(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,3,0,10,11,1,1.2000000476837158,1.0,v.f0,0.0,5)
        v.f1=(v.f0)+(0.28559932112693787)
        H.pattern(b,3,3,10,11,1,1.2000000476837158,1.0,v.f1,0.0,5)
        v.time=30;return B.part10(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.cmp=((a.stage==7 and 4 or 3))-(2)
        if v.cmp~=0 then v.time=30;return B.part8(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,3,0,10,12,2,1.600000023841858,1.0,v.f0,0.0,5)
        v.f1=(v.f0)+(0.28559932112693787)
        H.pattern(b,3,3,10,12,1,1.600000023841858,1.0,v.f1,0.0,5)
        v.time=30;return B.part10(b,v)
    end
    function B.part8(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.cmp=((a.stage==7 and 4 or 3))-(3)
        if v.cmp~=0 then v.time=30;return B.part10(b,v) end
        return B.part9(b,v)
    end
    function B.part9(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,3,0,10,15,2,2.5,1.0,v.f0,0.0,5)
        v.f1=(v.f0)+(0.28559932112693787)
        H.pattern(b,3,3,10,15,2,2.5,1.0,v.f1,0.0,5)
        return B.part10(b,v)
    end
    function B.part10(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        H.wait(b,v,80)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part11(b,v)
    end
    function B.part11(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        a.interactable=false
        H.wait(b,v,110)
        H.erase(b)
    end
    P[4][14]=B.part1
end

-- 第 4 面，原生 Sub15，起始 0x169c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.wait(b,v,30)
        H.erase(b)
    end
    P[4][15]=B.part1
end

-- 第 4 面，原生 Sub16，起始 0x16dc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.death_mode=1
        a.death=P[4][15]
        H.wait(b,v,30)
        a.interactable=true
        v.c0=10
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        H.pattern(b,3,3,6,32,3,3.0,1.0,0.0,0.0,5)
        H.wait(b,v,80)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        a.interactable=false
        H.wait(b,v,110)
        H.erase(b)
    end
    P[4][16]=B.part1
end

-- 第 4 面，原生 Sub17，起始 0x1894。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,13)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.death_mode=1
        a.death=P[4][15]
        H.wait(b,v,30)
        a.interactable=true
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        H.pattern(b,5,0,10,11,1,1.2000000476837158,1.0,0.0,0.0,5)
        H.pattern(b,3,3,10,11,1,1.2000000476837158,1.0,v.f1,0.0,5)
        H.wait(b,v,80)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        a.interactable=false
        H.wait(b,v,110)
        H.erase(b)
    end
    P[4][17]=B.part1
end

-- 第 4 面，原生 Sub18，起始 0x19f4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        H.spawn(b,4,20,(b.x+192),(224-b.y),a.z,1000,0,10)
        a.accel=0.0;a.mode="velocity"
        v.f0=ran:Float(0,1.5707963705062866)+0.7853981852531433
        a.angle,a.speed=v.f0,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[4][18]=B.part1
end

-- 第 4 面，原生 Sub20，起始 0x1c7c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,16)
        a.damageable=false
        a.interactable=false
        H.wait(b,v,120)
        H.laser(b,false,0,6,1.5707963705062866,0.0,0.0,500.0,500.0,32.0,90,120,16,70,14,0)
        H.pattern(b,3,4,6,32,2,1.2000000476837158,0.0,0.0,0.09817477315664291,4)
        H.wait(b,v,320)
        H.wait(b,v,440)
        H.erase(b)
    end
    P[4][20]=B.part1
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
        a.death_mode=1
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
        H.spawn(b,4,1,(b.x+192),(224-b.y),a.z,1000,0,10)
        H.wait(b,v,30)
        H.spawn(b,4,1,(b.x+192),(224-b.y),a.z,1000,0,10)
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
        H.drop_item(b,3)
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=2
        a.collidable=true
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.life_threshold=1700
        a.life_fn=P[4][41]
        a.death_mode=2
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
        a.death_mode=2
        a.collidable=true
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.death_mode=3
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

-- 第 5 面，原生 Sub0，起始 0xe0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c0=8
        v.f0=1.5
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,3,3,6,40,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.3799999952316284)
        v.f0=(v.f0)+(0.10000000149011612)
        H.wait(b,v,75)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,75)
        a.angle,a.speed=1.5707963705062866,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][0]=B.part1
end

-- 第 5 面，原生 Sub1，起始 0x29c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,10)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=0.0,2.5;a.mode="velocity"
        a.muted=true
        H.pattern(b,9,2,6,5,2,1.7999999523162842,0.800000011920929,3.1415927410125732,0.0,516)
        a.muted=false
        H.interval(b,30,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][1]=B.part1
end

-- 第 5 面，原生 Sub2，起始 0x40c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.death_mode=1
        a.death=P[5][7]
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c0=5
        v.f0=1.5
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,3,3,6,32,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.550000011920929)
        v.f0=(v.f0)+(0.20000000298023224)
        H.wait(b,v,74)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,74)
        a.angle,a.speed=1.5707963705062866,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][2]=B.part1
end

-- 第 5 面，原生 Sub3，起始 0x5e8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.death_mode=1
        a.death=P[5][8]
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.f0=1.5
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=70;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.time=80;return B.part5(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.c0=4
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,3,3,6,24,2,v.f0,1.0,0.13089969754219055,0.0,516)
        v.f0=(v.f0)+(0.20000000298023224)
        H.wait(b,v,75)
        H.pattern(b,3,3,6,24,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.20000000298023224)
        H.wait(b,v,80)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        v.c0=3
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        H.pattern(b,3,3,6,24,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.25)
        H.wait(b,v,85)
        v.c0=v.c0-1
        if v.c0>0 then v.time=80;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,85)
        a.angle,a.speed=1.5707963705062866,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][3]=B.part1
end

-- 第 5 面，原生 Sub4，起始 0x8a8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.death_mode=1
        a.death=P[5][8]
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.f0=1.5
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=70;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.time=80;return B.part5(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.c0=4
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,3,3,2,24,2,v.f0,1.0,0.13089969754219055,0.0,516)
        v.f0=(v.f0)+(0.20000000298023224)
        H.wait(b,v,75)
        H.pattern(b,3,3,2,24,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.20000000298023224)
        H.wait(b,v,80)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        v.c0=3
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        H.pattern(b,3,3,2,24,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.25)
        H.wait(b,v,85)
        v.c0=v.c0-1
        if v.c0>0 then v.time=80;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,85)
        a.angle,a.speed=1.5707963705062866,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][4]=B.part1
end

-- 第 5 面，原生 Sub5，起始 0xb68。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        a.death_mode=1
        a.death=P[5][8]
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.f0=1.5
        v.cmp=((a.stage==7 and 4 or 3))-(0)
        if v.cmp~=0 then v.time=70;return B.part3(b,v) end
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.time=80;return B.part5(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.c0=4
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,3,3,10,24,2,v.f0,1.0,0.13089969754219055,0.0,516)
        v.f0=(v.f0)+(0.20000000298023224)
        H.wait(b,v,75)
        H.pattern(b,3,3,10,24,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.20000000298023224)
        H.wait(b,v,80)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        v.c0=3
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,80)
        H.pattern(b,3,3,10,24,1,v.f0,1.0,0.0,0.0,516)
        v.f0=(v.f0)+(0.25)
        H.wait(b,v,85)
        v.c0=v.c0-1
        if v.c0>0 then v.time=80;return B.part6(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,85)
        a.angle,a.speed=1.5707963705062866,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][5]=B.part1
end

-- 第 5 面，原生 Sub6，起始 0xe28。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,11)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.c0=40
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.f0=ran:Float(0,3.9269907474517822)+-0.39269909262657166
        v.f1=ran:Float(0,2.0)+1.0
        H.pattern(b,2,1,6,7,2,v.f1,1.0,v.f0,0.039269909262657166,516)
        H.wait(b,v,73)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,73)
        a.angle,a.speed=1.5707963705062866,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][6]=B.part1
end

-- 第 5 面，原生 Sub7，起始 0xfb8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.erase(b)
    end
    P[5][7]=B.part1
end

-- 第 5 面，原生 Sub8，起始 0xfe4。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.erase(b)
    end
    P[5][8]=B.part1
end

-- 第 5 面，原生 Sub9，起始 0x1010。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,10)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=0.0,2.5;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,6,6,1,1.5,0.800000011920929,0.0,0.19634954631328583,516)
        a.muted=false
        H.interval(b,40,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][9]=B.part1
end

-- 第 5 面，原生 Sub10，起始 0x10cc。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,11)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=0.0,2.5;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,4,2,4,1,1.5,0.800000011920929,0.0,0.2617993950843811,516)
        a.muted=false
        H.interval(b,30,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][10]=B.part1
end

-- 第 5 面，原生 Sub11，起始 0x1188。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=0.0,2.5;a.mode="velocity"
        a.muted=true
        H.pattern(b,9,3,2,4,1,1.5,0.800000011920929,3.1415927410125732,-3.1415927410125732,516)
        a.muted=false
        H.interval(b,10,true)
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[5][11]=B.part1
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
        a.death_mode=1
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
        H.drop_item(b,5)
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
        a.death_mode=2
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
        a.death_mode=2
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
        H.spawn(b,5,25,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,26,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,27,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,28,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,31,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,32,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,29,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,30,(b.x+192),(224-b.y),a.z,100,0,0)
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=2
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
        a.death_mode=2
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
        H.spawn(b,5,36,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,37,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,38,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,5,39,(b.x+192),(224-b.y),a.z,100,0,0)
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=0
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
        a.death_mode=2
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
        a.death_mode=3
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

-- 第 6 面，原生 Sub0，起始 0xc8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        a.invisible=true
        a.interactable=false
        v.c0=18
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,40)
        b.x=(ran:Float(0,384.0))-192
        b.y=224-(ran:Float(0,224.0)+224.0)
        H.wait(b,v,80)
        b.x=(ran:Float(0,384.0))-192
        b.y=224-(ran:Float(0,224.0)+224.0)
        H.wait(b,v,120)
        b.x=(ran:Float(0,384.0))-192
        b.y=224-(ran:Float(0,224.0)+224.0)
        v.c0=v.c0-1
        if v.c0>0 then v.time=0;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,120)
        H.erase(b)
    end
    P[6][0]=B.part1
end

-- 第 6 面，原生 Sub1，起始 0x20c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,9,2,6,6,2,1.600000023841858,1.0,3.1415927410125732,-3.1415927410125732,4)
        a.muted=false
        H.interval(b,30,true)
        a.angle,a.speed=0.5235987901687622,4.5;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=-0.06544984877109528;a.mode="velocity"
        H.wait(b,v,115)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[6][1]=B.part1
end

-- 第 6 面，原生 Sub2，起始 0x318。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,9)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,9,2,6,6,2,1.600000023841858,1.0,3.1415927410125732,-3.1415927410125732,4)
        a.muted=false
        H.interval(b,30,true)
        a.angle,a.speed=0.5235987901687622,4.5;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=-0.06544984877109528;a.mode="velocity"
        H.wait(b,v,115)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[6][2]=B.part1
end

-- 第 6 面，原生 Sub3，起始 0x424。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,8)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,9,2,2,9,1,2.0,1.0,3.1415927410125732,-3.1415927410125732,4)
        a.muted=false
        H.interval(b,30,true)
        a.angle,a.speed=-1.0471975803375244,4.0;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=0.03490658476948738;a.mode="velocity"
        H.wait(b,v,90)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[6][3]=B.part1
end

-- 第 6 面，原生 Sub4，起始 0x530。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,9)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.muted=true
        H.pattern(b,9,2,2,9,1,2.0,1.0,3.1415927410125732,-3.1415927410125732,4)
        a.muted=false
        H.interval(b,30,true)
        a.angle,a.speed=-1.0471975803375244,4.0;a.mode="velocity"
        H.wait(b,v,30)
        a.angular=0.03490658476948738;a.mode="velocity"
        H.wait(b,v,90)
        a.angular=0.0;a.mode="velocity"
        H.interval(b,0,true)
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[6][4]=B.part1
end

-- 第 6 面，原生 Sub5，起始 0x63c。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,11)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=0.0,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.death_mode=1
        a.death=P[6][6]
        H.pattern(b,3,2,6,60,2,3.200000047683716,1.0,0.0,0.0,4)
        a.accel=0.0;a.mode="velocity"
        v.f0=ran:Float(0,1.5707963705062866)+0.7853981852531433
        a.angle,a.speed=v.f0,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[6][5]=B.part1
end

-- 第 6 面，原生 Sub6，起始 0x7d8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.erase(b)
    end
    P[6][6]=B.part1
end

-- 第 6 面，原生 Sub7，起始 0x804。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,11)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        a.death_mode=1
        a.death=P[6][6]
        H.pattern(b,3,2,6,60,1,1.600000023841858,1.0,0.0,0.0,4)
        a.accel=0.0;a.mode="velocity"
        v.f0=ran:Float(0,1.5707963705062866)+0.7853981852531433
        a.angle,a.speed=v.f0,1.7999999523162842;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[6][7]=B.part1
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
        a.death_mode=1
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
        H.drop_item(b,3)
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=3
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=2
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
        a.death_mode=2
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
        H.spawn(b,6,29,(b.x+192),(224-b.y),a.z,100,0,0)
        H.spawn(b,6,29,(b.x+192),(224-b.y),a.z,100,0,0)
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
        a.death_mode=2
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
        a.death_mode=2
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=4700 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=10
        a.death_mode=3
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
        a.death_mode=2
        H.trace(b,"spell_end")
        a.collidable=true
        if not a.main then b.hp=5300 end
        a.phase=0
        a.offsetx,a.offsety,a.offsetz=0.0,-12.0,0.0
        a.bounds={32.0,48.0,352.0,120.0}
        v.repeat_func=10
        a.death_mode=3
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

-- 第 Extra 面，原生 Sub0，起始 0x128。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,0)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,6,1,1,4.0,0.0,0.0,0.0,4)
        a.muted=false
        H.interval(b,60,true)
        H.wait(b,v,40)
        a.angular=-0.02454369328916073;a.mode="velocity"
        H.wait(b,v,120)
        a.angular=0.019634954631328583;a.mode="velocity"
        H.wait(b,v,220)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][0]=B.part1
end

-- 第 Extra 面，原生 Sub1，起始 0x214。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        a.death_mode=1
        a.death=P[7][15]
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.damageable=false
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=true
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=0.5
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,4,3,6,16,1,v.f1,1.0,v.f0,0.0,516)
        v.f0=(v.f0)+(0.039269909262657166)
        v.f1=(v.f1)+(0.30000001192092896)
        H.wait(b,v,74)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,74)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=0.5
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,74)
        H.pattern(b,4,3,6,16,1,4.0,1.0,v.f0,0.0,516)
        v.f0=(v.f0)+(-0.039269909262657166)
        v.f1=(v.f1)+(0.30000001192092896)
        H.wait(b,v,78)
        v.c0=v.c0-1
        if v.c0>0 then v.time=74;return B.part4(b,v) end
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,78)
        a.angle,a.speed=1.5707963705062866,1.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][1]=B.part1
end

-- 第 Extra 面，原生 Sub2，起始 0x458。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,12)
        a.death_mode=1
        a.death=P[7][15]
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.damageable=false
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=true
        v.c1=2
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=0.5
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,4,3,6,13,1,v.f1,1.0,v.f0,0.0,513)
        v.f0=(v.f0)+(0.06544984877109528)
        v.f1=(v.f1)+(0.18000000715255737)
        H.wait(b,v,74)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,74)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=0.5
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,74)
        H.pattern(b,4,3,6,13,1,v.f1,1.0,v.f0,0.0,513)
        v.f0=(v.f0)-(0.06544984877109528)
        v.f1=(v.f1)+(0.18000000715255737)
        H.wait(b,v,78)
        v.c0=v.c0-1
        if v.c0>0 then v.time=74;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,82)
        v.c1=v.c1-1
        if v.c1>0 then v.time=70;return B.part2(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,82)
        a.angle,a.speed=1.5707963705062866,1.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][2]=B.part1
end

-- 第 Extra 面，原生 Sub3，起始 0x6c8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,10)
        a.death_mode=1
        a.death=P[7][15]
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.damageable=false
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.damageable=true
        v.c1=2
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=0.5
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        H.pattern(b,4,3,2,13,1,v.f1,1.0,v.f0,0.0,513)
        v.f0=(v.f0)-(0.06544984877109528)
        v.f1=(v.f1)+(0.18000000715255737)
        H.wait(b,v,74)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,74)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=0.5
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,74)
        H.pattern(b,4,3,2,13,1,v.f1,1.0,v.f0,0.0,513)
        v.f0=(v.f0)+(0.06544984877109528)
        v.f1=(v.f1)+(0.18000000715255737)
        H.wait(b,v,78)
        v.c0=v.c0-1
        if v.c0>0 then v.time=74;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,82)
        v.c1=v.c1-1
        if v.c1>0 then v.time=70;return B.part2(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,82)
        a.angle,a.speed=1.5707963705062866,1.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][3]=B.part1
end

-- 第 Extra 面，原生 Sub4，起始 0x938。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,10)
        a.death_mode=1
        a.death=P[7][15]
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.damageable=false
        H.wait(b,v,40)
        a.accel=-0.06666667014360428;a.mode="velocity"
        H.wait(b,v,70)
        a.accel=0.0;a.mode="velocity"
        a.sound=22;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        v.i0=4
        v.c1=6
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.c0=14
        v.f1=0.5
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,70)
        v.i1=(v.i0)+(2)
        H.pattern(b,4,2,2,v.i1,1,v.f1,1.0,v.f0,0.0,513)
        v.f0=(v.f0)-(0.09817477315664291)
        v.f1=(v.f1)+(0.20000000298023224)
        H.wait(b,v,73)
        v.c0=v.c0-1
        if v.c0>0 then v.time=70;return B.part3(b,v) end
        return B.part4(b,v)
    end
    function B.part4(b,v)
        local a=b.th06_actor
        H.wait(b,v,73)
        v.c0=8
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        v.f1=2.0
        return B.part5(b,v)
    end
    function B.part5(b,v)
        local a=b.th06_actor
        H.wait(b,v,73)
        H.pattern(b,4,2,6,v.i0,1,v.f1,1.0,v.f0,0.0,513)
        v.f0=(v.f0)+(0.03141592815518379)
        v.f1=(v.f1)+(0.15000000596046448)
        H.wait(b,v,77)
        v.c0=v.c0-1
        if v.c0>0 then v.time=73;return B.part5(b,v) end
        return B.part6(b,v)
    end
    function B.part6(b,v)
        local a=b.th06_actor
        H.wait(b,v,77)
        v.i0=(v.i0)+(3)
        H.wait(b,v,81)
        v.c1=v.c1-1
        if v.c1>0 then v.time=70;return B.part2(b,v) end
        return B.part7(b,v)
    end
    function B.part7(b,v)
        local a=b.th06_actor
        H.wait(b,v,81)
        a.damageable=true
        a.angle,a.speed=1.5707963705062866,1.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][4]=B.part1
end

-- 第 Extra 面，原生 Sub5，起始 0xbec。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,3)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.offsetx,a.offsety,a.offsetz=12.0,-12.0,0.0
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,60)
        H.sprite(b,5)
        a.speed=0.0;a.mode="velocity"
        H.wait(b,v,70)
        H.pattern(b,1,1,2,11,3,4.0,3.0,0.0,0.4487989544868469,3)
        H.wait(b,v,130)
        a.accel=0.05000000074505806;a.mode="velocity"
        a.angular=0.05235987901687622;a.mode="velocity"
        H.wait(b,v,190)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,1000)
        H.erase(b)
    end
    P[7][5]=B.part1
end

-- 第 Extra 面，原生 Sub6，起始 0xcf8。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,3)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.offsetx,a.offsety,a.offsetz=12.0,-12.0,0.0
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        H.wait(b,v,60)
        H.sprite(b,5)
        a.speed=0.0;a.mode="velocity"
        H.wait(b,v,70)
        H.pattern(b,1,1,2,3,4,6.0,2.0,0.0,0.06544984877109528,3)
        H.pattern(b,1,1,2,2,3,6.599999904632568,2.0999999046325684,0.0,0.06544984877109528,3)
        H.wait(b,v,130)
        a.accel=0.05000000074505806;a.mode="velocity"
        a.angular=0.009817477315664291;a.mode="velocity"
        H.wait(b,v,190)
        a.angular=0.0;a.mode="velocity"
        a.accel=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][6]=B.part1
end

-- 第 Extra 面，原生 Sub7，起始 0xe40。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,3)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.offsetx,a.offsety,a.offsetz=12.0,-12.0,0.0
        a.angle,a.speed=0.0,2.0;a.mode="velocity"
        H.wait(b,v,60)
        H.sprite(b,5)
        a.speed=0.0;a.mode="velocity"
        H.wait(b,v,70)
        H.pattern(b,1,3,2,7,4,5.0,1.0,0.0,0.06544984877109528,3)
        H.pattern(b,1,3,2,6,3,4.599999904632568,1.100000023841858,0.0,0.06544984877109528,3)
        H.wait(b,v,130)
        a.accel=0.05000000074505806;a.mode="velocity"
        a.angular=0.009817477315664291;a.mode="velocity"
        H.wait(b,v,190)
        a.angular=0.0;a.mode="velocity"
        a.accel=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][7]=B.part1
end

-- 第 Extra 面，原生 Sub8，起始 0xf88。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,0)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,6,3,1,4.0,0.0,0.0,0.19634954631328583,4)
        a.muted=false
        H.interval(b,90,true)
        H.wait(b,v,40)
        a.angular=-0.02454369328916073;a.mode="velocity"
        H.wait(b,v,120)
        a.angular=0.019634954631328583;a.mode="velocity"
        H.wait(b,v,220)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][8]=B.part1
end

-- 第 Extra 面，原生 Sub9，起始 0x1074。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,0)
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.angle,a.speed=1.5707963705062866,2.0;a.mode="velocity"
        a.muted=true
        H.pattern(b,1,0,6,3,1,4.0,0.0,0.0,0.39269909262657166,4)
        a.muted=false
        H.interval(b,70,true)
        H.wait(b,v,40)
        a.angular=-0.02454369328916073;a.mode="velocity"
        H.wait(b,v,120)
        a.angular=0.019634954631328583;a.mode="velocity"
        H.wait(b,v,220)
        a.angular=0.0;a.mode="velocity"
        H.wait(b,v,10000)
        H.erase(b)
    end
    P[7][9]=B.part1
end

-- 第 Extra 面，原生 Sub10，起始 0x1160。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death_mode=1
        a.death=P[7][30]
        H.wait(b,v,30)
        v.c3=0
        a.interactable=true
        v.c0=8
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,0,2,16,1,1.2000000476837158,1.0,v.f0,0.0,3)
        H.wait(b,v,41)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,41)
        a.interactable=false
        H.wait(b,v,71)
        H.erase(b)
    end
    P[7][10]=B.part1
end

-- 第 Extra 面，原生 Sub11，起始 0x12d0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death_mode=1
        a.death=P[7][30]
        H.wait(b,v,30)
        v.c3=0
        a.interactable=true
        v.c0=7
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,9,0,2,20,1,1.7999999523162842,0.6000000238418579,3.1415927410125732,-3.1415927410125732,3)
        H.wait(b,v,42)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,42)
        a.interactable=false
        H.wait(b,v,72)
        H.erase(b)
    end
    P[7][11]=B.part1
end

-- 第 Extra 面，原生 Sub12，起始 0x1440。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death_mode=1
        a.death=P[7][30]
        H.wait(b,v,30)
        v.c3=0
        a.interactable=true
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,1,0,6,9,1,1.600000023841858,0.6000000238418579,0.0,0.3141592741012573,3)
        H.wait(b,v,50)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        a.interactable=false
        H.wait(b,v,80)
        H.erase(b)
    end
    P[7][12]=B.part1
end

-- 第 Extra 面，原生 Sub13，起始 0x15c0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death_mode=1
        a.death=P[7][30]
        H.wait(b,v,30)
        v.c3=0
        a.interactable=true
        v.c0=6
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,1,0,6,1,4,2.5,1.0,0.0,0.0,3)
        H.wait(b,v,50)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,50)
        a.interactable=false
        H.wait(b,v,80)
        H.erase(b)
    end
    P[7][13]=B.part1
end

-- 第 Extra 面，原生 Sub14，起始 0x1730。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.sprite(b,14)
        a.interactable=false
        b.a,b.b,b.rect=(28.0)/2,(28.0)/2,true
        a.sound=7;if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
        a.death_mode=1
        a.death=P[7][30]
        H.wait(b,v,30)
        v.c3=0
        a.interactable=true
        v.c0=4
        return B.part2(b,v)
    end
    function B.part2(b,v)
        local a=b.th06_actor
        H.wait(b,v,30)
        v.f0=ran:Float(0,6.2831854820251465)+-3.1415927410125732
        H.pattern(b,4,0,2,10,3,2.200000047683716,0.6000000238418579,v.f0,0.0,3)
        H.wait(b,v,60)
        v.c0=v.c0-1
        if v.c0>0 then v.time=30;return B.part2(b,v) end
        return B.part3(b,v)
    end
    function B.part3(b,v)
        local a=b.th06_actor
        H.wait(b,v,60)
        a.interactable=false
        H.wait(b,v,90)
        H.erase(b)
    end
    P[7][14]=B.part1
end

-- 第 Extra 面，原生 Sub15，起始 0x18a0。
do
    local B={}
    function B.part1(b,v)
        local a=b.th06_actor
        H.wait(b,v,0)
        H.erase(b)
    end
    P[7][15]=B.part1
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
        H.spawn(b,7,25,192.0,144.0,0.0,-5536,-2,10)
        H.spawn(b,7,26,64.0,112.0,0.0,-5536,-2,10)
        H.spawn(b,7,27,256.0,96.0,0.0,-5536,-2,10)
        H.spawn(b,7,28,320.0,112.0,0.0,-5536,-2,10)
        H.spawn(b,7,29,128.0,96.0,0.0,-5536,-2,10)
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
        a.death_mode=1
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
        a.death_mode=1
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
        a.death_mode=1
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
        a.death_mode=1
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
        a.death_mode=1
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
        a.death_mode=2
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
        H.spawn(b,7,34,v.f0,0.0,0.0,20,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,22,-2,10)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,280)
        H.spawn(b,7,34,v.f0,0.0,0.0,1121,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,1123,-2,10)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,440)
        H.spawn(b,7,34,v.f0,0.0,0.0,20,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,22,-2,10)
        H.wait(b,v,520)
        H.spawn(b,7,34,v.f0,0.0,0.0,111,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,113,-2,10)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,720)
        H.spawn(b,7,34,v.f0,0.0,0.0,1111,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,1113,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,1010,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,1012,-2,10)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,920)
        H.spawn(b,7,34,v.f0,0.0,0.0,111,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,123,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,10,-2,10)
        H.spawn(b,7,34,v.f0,0.0,0.0,22,-2,10)
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
        a.death_mode=2
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
        a.death_mode=2
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
        H.spawn(b,7,40,0.0,0.0,0.0,1200,2,10)
        H.spawn(b,7,41,0.0,0.0,0.0,1200,2,10)
        H.spawn(b,7,42,0.0,0.0,0.0,1200,2,10)
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
        a.death_mode=2
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
        H.spawn(b,7,45,64.0,0.0,1.5707963705062866,1200,-2,10)
        H.wait(b,v,133)
        H.spawn(b,7,45,400.0,320.0,3.1415927410125732,1200,2,10)
        H.wait(b,v,143)
        H.spawn(b,7,45,-16.0,160.0,0.0,1200,2,10)
        H.wait(b,v,153)
        H.spawn(b,7,45,320.0,464.0,-1.5707963705062866,1200,2,10)
        H.wait(b,v,163)
        H.spawn(b,7,45,128.0,0.0,1.5707963705062866,1200,-2,10)
        H.wait(b,v,173)
        H.spawn(b,7,45,400.0,256.0,3.1415927410125732,1200,2,10)
        H.wait(b,v,183)
        H.spawn(b,7,45,-16.0,192.0,0.0,1200,2,10)
        H.wait(b,v,193)
        H.spawn(b,7,45,256.0,464.0,-1.5707963705062866,1200,2,10)
        H.wait(b,v,203)
        H.spawn(b,7,45,400.0,64.0,3.1415927410125732,1200,2,10)
        H.wait(b,v,213)
        H.spawn(b,7,45,-16.0,128.0,0.0,1200,2,10)
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
        H.spawn(b,7,45,400.0,0.0,2.356194496154785,1200,-2,10)
        H.wait(b,v,488)
        H.spawn(b,7,45,400.0,128.0,2.356194496154785,1200,-2,10)
        H.wait(b,v,503)
        H.spawn(b,7,45,400.0,256.0,2.356194496154785,1200,-2,10)
        H.wait(b,v,563)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,1,1,3.5999999046325684,0.0,v.f0,0.0,516)
        H.wait(b,v,593)
        v.f0=ran:Float(0,1.5707963705062866)+-0.7853981852531433
        H.pattern(b,1,9,3,3,1,3.5999999046325684,0.0,0.0,1.0471975803375244,516)
        H.wait(b,v,633)
        H.spawn(b,7,45,-16.0,0.0,0.7853981852531433,1200,-2,10)
        H.wait(b,v,648)
        H.spawn(b,7,45,-16.0,128.0,0.7853981852531433,1200,-2,10)
        H.wait(b,v,663)
        H.spawn(b,7,45,-16.0,256.0,0.7853981852531433,1200,-2,10)
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
        a.death_mode=1
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
        a.death_mode=2
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
        a.death_mode=2
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
        H.spawn(b,7,51,(b.x+192),(224-b.y),2.356194496154785,102,-2,10)
        H.spawn(b,7,51,(b.x+192),(224-b.y),2.7488934993743896,114,-2,10)
        H.spawn(b,7,51,(b.x+192),(224-b.y),3.1415927410125732,113,-2,10)
        H.spawn(b,7,51,(b.x+192),(224-b.y),0.7853981852531433,104,-2,10)
        H.spawn(b,7,51,(b.x+192),(224-b.y),0.39269909262657166,108,-2,10)
        H.spawn(b,7,51,(b.x+192),(224-b.y),0.0,111,-2,10)
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
        H.spawn(b,7,51,-32.0,336.0,-0.5890486240386963,104,-2,10)
        H.wait(b,v,194)
        H.spawn(b,7,52,-32.0,304.0,-0.5890486240386963,106,-2,10)
        H.wait(b,v,204)
        H.spawn(b,7,51,-32.0,272.0,-0.5890486240386963,108,-2,10)
        H.wait(b,v,214)
        H.spawn(b,7,52,-32.0,240.0,-0.5890486240386963,111,-2,10)
        H.wait(b,v,224)
        H.spawn(b,7,51,-32.0,208.0,-0.5890486240386963,113,-2,10)
        H.wait(b,v,234)
        H.spawn(b,7,52,-32.0,176.0,-0.5890486240386963,114,-2,10)
        H.wait(b,v,244)
        H.spawn(b,7,51,-32.0,144.0,-0.5890486240386963,102,-2,10)
        H.wait(b,v,334)
        H.rand_angle(b,-3.1415927410125732,3.1415927410125732,true)
        a.speed=2.5;a.mode="velocity"
        H.move_dir(b,90,a.angle,a.speed,1)
        H.wait(b,v,394)
        H.spawn(b,7,51,416.0,336.0,3.337942123413086,104,-2,10)
        H.wait(b,v,404)
        H.spawn(b,7,52,416.0,304.0,3.337942123413086,106,-2,10)
        H.wait(b,v,414)
        H.spawn(b,7,51,416.0,272.0,3.337942123413086,108,-2,10)
        H.wait(b,v,424)
        H.spawn(b,7,52,416.0,240.0,3.337942123413086,111,-2,10)
        H.wait(b,v,434)
        H.spawn(b,7,51,416.0,208.0,3.337942123413086,113,-2,10)
        H.wait(b,v,444)
        H.spawn(b,7,52,416.0,176.0,3.337942123413086,114,-2,10)
        H.wait(b,v,454)
        H.spawn(b,7,51,416.0,144.0,3.337942123413086,102,-2,10)
        H.wait(b,v,594)
        H.spawn(b,7,51,-32.0,336.0,0.0,104,-2,10)
        H.wait(b,v,604)
        H.spawn(b,7,51,416.0,304.0,3.1415927410125732,106,-2,10)
        H.wait(b,v,614)
        H.spawn(b,7,51,-32.0,272.0,0.0,108,-2,10)
        H.wait(b,v,624)
        H.spawn(b,7,51,416.0,240.0,3.1415927410125732,111,-2,10)
        H.wait(b,v,634)
        H.spawn(b,7,51,-32.0,208.0,0.0,113,-2,10)
        H.wait(b,v,644)
        H.spawn(b,7,51,416.0,176.0,3.1415927410125732,114,-2,10)
        H.wait(b,v,654)
        H.spawn(b,7,51,-32.0,144.0,0.0,102,-2,10)
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
        a.death_mode=1
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
        a.death_mode=1
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
        a.death_mode=2
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
        a.death_mode=2
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
        H.spawn(b,7,58,64.0,288.0,288.0,10,-2,10)
        H.spawn(b,7,58,320.0,160.0,160.0,10,-2,10)
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
        H.spawn(b,7,58,64.0,160.0,160.0,10,-2,10)
        H.spawn(b,7,58,320.0,288.0,288.0,10,-2,10)
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
        H.spawn(b,7,58,64.0,128.0,288.0,10,-2,10)
        H.spawn(b,7,58,320.0,128.0,288.0,10,-2,10)
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
        a.death_mode=1
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
        a.death_mode=2
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
        H.spawn(b,7,66,192.0,96.0,0.0,4,-2,10)
        H.wait(b,v,920)
        H.spawn(b,7,66,192.0,96.0,0.0,4,-2,10)
        H.wait(b,v,984)
        H.spawn(b,7,66,0.0,0.0,0.0,4,-2,10)
        H.wait(b,v,1048)
        H.spawn(b,7,66,384.0,0.0,0.0,3,-2,10)
        H.wait(b,v,1112)
        H.spawn(b,7,66,0.0,448.0,0.0,3,-2,10)
        H.wait(b,v,1176)
        H.spawn(b,7,66,384.0,448.0,0.0,2,-2,10)
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
        a.death_mode=1
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
        a.death_mode=3
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

-- 一面道中·前半：原时间轴 0..2008，96 次创建。
P[1]["road_before"]=function(b,v)
    if v.epoch<=128 then
        H.wait(b,v,128)
        H.timeline_spawn(b,0,0,60.0,-32.0,0.0,8,-1,300)
    end
    if v.epoch<=144 then
        H.wait(b,v,144)
        H.timeline_spawn(b,0,0,68.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=160 then
        H.wait(b,v,160)
        H.timeline_spawn(b,0,0,76.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=176 then
        H.wait(b,v,176)
        H.timeline_spawn(b,0,0,84.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=192 then
        H.wait(b,v,192)
        H.timeline_spawn(b,0,0,92.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=256 then
        H.wait(b,v,256)
        H.timeline_spawn(b,2,0,324.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=272 then
        H.wait(b,v,272)
        H.timeline_spawn(b,2,0,316.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=288 then
        H.wait(b,v,288)
        H.timeline_spawn(b,2,0,308.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=304 then
        H.wait(b,v,304)
        H.timeline_spawn(b,2,0,300.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=320 then
        H.wait(b,v,320)
        H.timeline_spawn(b,2,0,292.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=336 then
        H.wait(b,v,336)
        H.timeline_spawn(b,2,0,284.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=352 then
        H.wait(b,v,352)
        H.timeline_spawn(b,2,0,276.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=368 then
        H.wait(b,v,368)
        H.timeline_spawn(b,2,0,268.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=432 then
        H.wait(b,v,432)
        H.timeline_spawn(b,0,1,32.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,352.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=448 then
        H.wait(b,v,448)
        H.timeline_spawn(b,0,1,48.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,336.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=464 then
        H.wait(b,v,464)
        H.timeline_spawn(b,0,1,64.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,320.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=480 then
        H.wait(b,v,480)
        H.timeline_spawn(b,0,1,80.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,304.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=496 then
        H.wait(b,v,496)
        H.timeline_spawn(b,0,1,96.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,288.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=512 then
        H.wait(b,v,512)
        H.timeline_spawn(b,0,1,112.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,272.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=528 then
        H.wait(b,v,528)
        H.timeline_spawn(b,0,1,128.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,256.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=544 then
        H.wait(b,v,544)
        H.timeline_spawn(b,0,1,144.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,240.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=560 then
        H.wait(b,v,560)
        H.timeline_spawn(b,0,1,160.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,224.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=576 then
        H.wait(b,v,576)
        H.timeline_spawn(b,0,1,176.0,-32.0,0.0,32,-1,300)
        H.timeline_spawn(b,2,1,208.0,-32.0,0.0,8,-1,300)
    end
    if v.epoch<=640 then
        H.wait(b,v,640)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=700 then
        H.wait(b,v,700)
        H.timeline_spawn(b,2,3,256.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=750 then
        H.wait(b,v,750)
        H.timeline_spawn(b,0,3,128.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=800 then
        H.wait(b,v,800)
        H.timeline_spawn(b,2,2,352.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=850 then
        H.wait(b,v,850)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=890 then
        H.wait(b,v,890)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=930 then
        H.wait(b,v,930)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=960 then
        H.wait(b,v,960)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=990 then
        H.wait(b,v,990)
        H.timeline_spawn(b,0,3,32.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1020 then
        H.wait(b,v,1020)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1040 then
        H.wait(b,v,1040)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1060 then
        H.wait(b,v,1060)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1080 then
        H.wait(b,v,1080)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1090 then
        H.wait(b,v,1090)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1100 then
        H.wait(b,v,1100)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1110 then
        H.wait(b,v,1110)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,0,700)
    end
    if v.epoch<=1220 then
        H.wait(b,v,1220)
        H.timeline_spawn(b,6,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1230 then
        H.wait(b,v,1230)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1240 then
        H.wait(b,v,1240)
        H.timeline_spawn(b,6,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1250 then
        H.wait(b,v,1250)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1260 then
        H.wait(b,v,1260)
        H.timeline_spawn(b,6,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1270 then
        H.wait(b,v,1270)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1280 then
        H.wait(b,v,1280)
        H.timeline_spawn(b,6,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1290 then
        H.wait(b,v,1290)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1300 then
        H.wait(b,v,1300)
        H.timeline_spawn(b,6,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1310 then
        H.wait(b,v,1310)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1320 then
        H.wait(b,v,1320)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1330 then
        H.wait(b,v,1330)
        H.timeline_spawn(b,6,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1340 then
        H.wait(b,v,1340)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1350 then
        H.wait(b,v,1350)
        H.timeline_spawn(b,6,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1360 then
        H.wait(b,v,1360)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1370 then
        H.wait(b,v,1370)
        H.timeline_spawn(b,6,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1380 then
        H.wait(b,v,1380)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1390 then
        H.wait(b,v,1390)
        H.timeline_spawn(b,6,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1400 then
        H.wait(b,v,1400)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,32,-1,300)
    end
    if v.epoch<=1600 then
        H.wait(b,v,1600)
        H.timeline_spawn(b,2,0,320.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,352.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1616 then
        H.wait(b,v,1616)
        H.timeline_spawn(b,2,0,312.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,344.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1632 then
        H.wait(b,v,1632)
        H.timeline_spawn(b,2,0,304.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,336.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1648 then
        H.wait(b,v,1648)
        H.timeline_spawn(b,2,0,296.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,328.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1664 then
        H.wait(b,v,1664)
        H.timeline_spawn(b,2,0,288.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,320.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1680 then
        H.wait(b,v,1680)
        H.timeline_spawn(b,2,0,280.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,312.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1696 then
        H.wait(b,v,1696)
        H.timeline_spawn(b,0,0,64.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,96.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1712 then
        H.wait(b,v,1712)
        H.timeline_spawn(b,0,0,72.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,104.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1728 then
        H.wait(b,v,1728)
        H.timeline_spawn(b,0,0,80.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,112.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1744 then
        H.wait(b,v,1744)
        H.timeline_spawn(b,0,0,88.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,120.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1760 then
        H.wait(b,v,1760)
        H.timeline_spawn(b,0,0,96.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,128.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1776 then
        H.wait(b,v,1776)
        H.timeline_spawn(b,0,0,104.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,136.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1792 then
        H.wait(b,v,1792)
        H.timeline_spawn(b,0,0,112.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,144.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=1808 then
        H.wait(b,v,1808)
        H.timeline_spawn(b,0,0,120.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,152.0,-32.0,0.0,3,-1,300)
    end
    H.wait(b,v,2008)
    H.erase(b)
end

-- 一面道中·后半：原时间轴 2008..5278，126 次创建。
P[1]["road_after"]=function(b,v)
    if v.epoch<=400 then
        H.wait(b,v,400)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=430 then
        H.wait(b,v,430)
        H.timeline_spawn(b,2,3,256.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=460 then
        H.wait(b,v,460)
        H.timeline_spawn(b,0,3,128.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=490 then
        H.wait(b,v,490)
        H.timeline_spawn(b,2,2,352.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=520 then
        H.wait(b,v,520)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=550 then
        H.wait(b,v,550)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=580 then
        H.wait(b,v,580)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=610 then
        H.wait(b,v,610)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=640 then
        H.wait(b,v,640)
        H.timeline_spawn(b,0,3,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=670 then
        H.wait(b,v,670)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=700 then
        H.wait(b,v,700)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=730 then
        H.wait(b,v,730)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=760 then
        H.wait(b,v,760)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=790 then
        H.wait(b,v,790)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=820 then
        H.wait(b,v,820)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=850 then
        H.wait(b,v,850)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=880 then
        H.wait(b,v,880)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=910 then
        H.wait(b,v,910)
        H.timeline_spawn(b,2,3,256.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=940 then
        H.wait(b,v,940)
        H.timeline_spawn(b,0,3,128.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=970 then
        H.wait(b,v,970)
        H.timeline_spawn(b,2,2,352.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1000 then
        H.wait(b,v,1000)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1030 then
        H.wait(b,v,1030)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1060 then
        H.wait(b,v,1060)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1090 then
        H.wait(b,v,1090)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1120 then
        H.wait(b,v,1120)
        H.timeline_spawn(b,0,3,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1150 then
        H.wait(b,v,1150)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1180 then
        H.wait(b,v,1180)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1210 then
        H.wait(b,v,1210)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1240 then
        H.wait(b,v,1240)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1270 then
        H.wait(b,v,1270)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1300 then
        H.wait(b,v,1300)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1330 then
        H.wait(b,v,1330)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1360 then
        H.wait(b,v,1360)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1390 then
        H.wait(b,v,1390)
        H.timeline_spawn(b,2,3,256.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1420 then
        H.wait(b,v,1420)
        H.timeline_spawn(b,0,3,128.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1450 then
        H.wait(b,v,1450)
        H.timeline_spawn(b,2,2,352.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1480 then
        H.wait(b,v,1480)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1510 then
        H.wait(b,v,1510)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1540 then
        H.wait(b,v,1540)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1570 then
        H.wait(b,v,1570)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1600 then
        H.wait(b,v,1600)
        H.timeline_spawn(b,0,3,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1630 then
        H.wait(b,v,1630)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1660 then
        H.wait(b,v,1660)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1690 then
        H.wait(b,v,1690)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1720 then
        H.wait(b,v,1720)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1750 then
        H.wait(b,v,1750)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1780 then
        H.wait(b,v,1780)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1810 then
        H.wait(b,v,1810)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1840 then
        H.wait(b,v,1840)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1870 then
        H.wait(b,v,1870)
        H.timeline_spawn(b,2,3,256.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1900 then
        H.wait(b,v,1900)
        H.timeline_spawn(b,0,3,128.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1930 then
        H.wait(b,v,1930)
        H.timeline_spawn(b,2,2,352.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1960 then
        H.wait(b,v,1960)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=1990 then
        H.wait(b,v,1990)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2020 then
        H.wait(b,v,2020)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2050 then
        H.wait(b,v,2050)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2080 then
        H.wait(b,v,2080)
        H.timeline_spawn(b,0,3,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2110 then
        H.wait(b,v,2110)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2140 then
        H.wait(b,v,2140)
        H.timeline_spawn(b,0,3,24.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2170 then
        H.wait(b,v,2170)
        H.timeline_spawn(b,2,3,304.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2200 then
        H.wait(b,v,2200)
        H.timeline_spawn(b,0,2,144.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2230 then
        H.wait(b,v,2230)
        H.timeline_spawn(b,2,3,344.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2260 then
        H.wait(b,v,2260)
        H.timeline_spawn(b,0,2,32.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2290 then
        H.wait(b,v,2290)
        H.timeline_spawn(b,2,2,240.0,-32.0,0.0,80,-1,700)
    end
    if v.epoch<=2490 then
        H.wait(b,v,2490)
        H.timeline_spawn(b,0,0,32.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,64.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2506 then
        H.wait(b,v,2506)
        H.timeline_spawn(b,0,0,40.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,72.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2522 then
        H.wait(b,v,2522)
        H.timeline_spawn(b,0,0,48.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,80.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2538 then
        H.wait(b,v,2538)
        H.timeline_spawn(b,0,0,56.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,88.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2554 then
        H.wait(b,v,2554)
        H.timeline_spawn(b,0,0,64.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,96.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2570 then
        H.wait(b,v,2570)
        H.timeline_spawn(b,0,0,72.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,104.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2586 then
        H.wait(b,v,2586)
        H.timeline_spawn(b,0,0,80.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,112.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2602 then
        H.wait(b,v,2602)
        H.timeline_spawn(b,2,0,320.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,352.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2618 then
        H.wait(b,v,2618)
        H.timeline_spawn(b,2,0,312.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,344.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2634 then
        H.wait(b,v,2634)
        H.timeline_spawn(b,2,0,304.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,336.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2650 then
        H.wait(b,v,2650)
        H.timeline_spawn(b,2,0,296.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,328.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2666 then
        H.wait(b,v,2666)
        H.timeline_spawn(b,2,0,288.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,320.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2682 then
        H.wait(b,v,2682)
        H.timeline_spawn(b,2,0,280.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,312.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2698 then
        H.wait(b,v,2698)
        H.timeline_spawn(b,2,0,272.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,304.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2714 then
        H.wait(b,v,2714)
        H.timeline_spawn(b,2,0,264.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,296.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2730 then
        H.wait(b,v,2730)
        H.timeline_spawn(b,0,0,32.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,64.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2746 then
        H.wait(b,v,2746)
        H.timeline_spawn(b,0,0,40.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,72.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2762 then
        H.wait(b,v,2762)
        H.timeline_spawn(b,0,0,48.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,80.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2778 then
        H.wait(b,v,2778)
        H.timeline_spawn(b,0,0,56.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,88.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2794 then
        H.wait(b,v,2794)
        H.timeline_spawn(b,0,0,64.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,96.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2810 then
        H.wait(b,v,2810)
        H.timeline_spawn(b,0,0,72.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,104.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2826 then
        H.wait(b,v,2826)
        H.timeline_spawn(b,0,0,80.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,112.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2842 then
        H.wait(b,v,2842)
        H.timeline_spawn(b,0,0,88.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,0,0,120.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2858 then
        H.wait(b,v,2858)
        H.timeline_spawn(b,2,0,320.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,352.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2874 then
        H.wait(b,v,2874)
        H.timeline_spawn(b,2,0,312.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,344.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2890 then
        H.wait(b,v,2890)
        H.timeline_spawn(b,2,0,304.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,336.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2906 then
        H.wait(b,v,2906)
        H.timeline_spawn(b,2,0,296.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,328.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2922 then
        H.wait(b,v,2922)
        H.timeline_spawn(b,2,0,288.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,320.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2938 then
        H.wait(b,v,2938)
        H.timeline_spawn(b,2,0,280.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,312.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2954 then
        H.wait(b,v,2954)
        H.timeline_spawn(b,2,0,272.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,304.0,-32.0,0.0,3,-1,300)
    end
    if v.epoch<=2970 then
        H.wait(b,v,2970)
        H.timeline_spawn(b,2,0,264.0,-32.0,0.0,3,-1,300)
        H.timeline_spawn(b,2,0,296.0,-32.0,0.0,3,-1,300)
    end
    H.wait(b,v,3270)
    H.erase(b)
end

-- 二面道中·前半：原时间轴 0..2588，162 次创建。
P[2]["road_before"]=function(b,v)
    if v.epoch<=330 then
        H.wait(b,v,330)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=336 then
        H.wait(b,v,336)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=342 then
        H.wait(b,v,342)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=348 then
        H.wait(b,v,348)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=354 then
        H.wait(b,v,354)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=360 then
        H.wait(b,v,360)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=366 then
        H.wait(b,v,366)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=372 then
        H.wait(b,v,372)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=378 then
        H.wait(b,v,378)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=384 then
        H.wait(b,v,384)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=390 then
        H.wait(b,v,390)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=396 then
        H.wait(b,v,396)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=402 then
        H.wait(b,v,402)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=408 then
        H.wait(b,v,408)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=414 then
        H.wait(b,v,414)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=420 then
        H.wait(b,v,420)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=426 then
        H.wait(b,v,426)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=432 then
        H.wait(b,v,432)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=438 then
        H.wait(b,v,438)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=444 then
        H.wait(b,v,444)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=450 then
        H.wait(b,v,450)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=456 then
        H.wait(b,v,456)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=462 then
        H.wait(b,v,462)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=468 then
        H.wait(b,v,468)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=474 then
        H.wait(b,v,474)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=480 then
        H.wait(b,v,480)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=486 then
        H.wait(b,v,486)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=492 then
        H.wait(b,v,492)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=498 then
        H.wait(b,v,498)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=504 then
        H.wait(b,v,504)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=510 then
        H.wait(b,v,510)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=516 then
        H.wait(b,v,516)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=522 then
        H.wait(b,v,522)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=528 then
        H.wait(b,v,528)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=534 then
        H.wait(b,v,534)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=540 then
        H.wait(b,v,540)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=546 then
        H.wait(b,v,546)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=552 then
        H.wait(b,v,552)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=558 then
        H.wait(b,v,558)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=564 then
        H.wait(b,v,564)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=570 then
        H.wait(b,v,570)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=576 then
        H.wait(b,v,576)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=582 then
        H.wait(b,v,582)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=588 then
        H.wait(b,v,588)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=594 then
        H.wait(b,v,594)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=600 then
        H.wait(b,v,600)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=606 then
        H.wait(b,v,606)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=612 then
        H.wait(b,v,612)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=618 then
        H.wait(b,v,618)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=624 then
        H.wait(b,v,624)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=630 then
        H.wait(b,v,630)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=636 then
        H.wait(b,v,636)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=642 then
        H.wait(b,v,642)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=648 then
        H.wait(b,v,648)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=654 then
        H.wait(b,v,654)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=660 then
        H.wait(b,v,660)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=666 then
        H.wait(b,v,666)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=672 then
        H.wait(b,v,672)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=678 then
        H.wait(b,v,678)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=684 then
        H.wait(b,v,684)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=690 then
        H.wait(b,v,690)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=696 then
        H.wait(b,v,696)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=702 then
        H.wait(b,v,702)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=708 then
        H.wait(b,v,708)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=714 then
        H.wait(b,v,714)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=720 then
        H.wait(b,v,720)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=726 then
        H.wait(b,v,726)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=732 then
        H.wait(b,v,732)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=738 then
        H.wait(b,v,738)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,0,700)
    end
    if v.epoch<=744 then
        H.wait(b,v,744)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=984 then
        H.wait(b,v,984)
        H.timeline_spawn(b,0,6,32.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1000 then
        H.wait(b,v,1000)
        H.timeline_spawn(b,0,6,48.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1006 then
        H.wait(b,v,1006)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1016 then
        H.wait(b,v,1016)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1032 then
        H.wait(b,v,1032)
        H.timeline_spawn(b,0,6,80.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1048 then
        H.wait(b,v,1048)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1064 then
        H.wait(b,v,1064)
        H.timeline_spawn(b,0,6,112.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1070 then
        H.wait(b,v,1070)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1080 then
        H.wait(b,v,1080)
        H.timeline_spawn(b,0,6,128.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1096 then
        H.wait(b,v,1096)
        H.timeline_spawn(b,0,6,144.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1112 then
        H.wait(b,v,1112)
        H.timeline_spawn(b,0,6,160.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1128 then
        H.wait(b,v,1128)
        H.timeline_spawn(b,0,6,176.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1144 then
        H.wait(b,v,1144)
        H.timeline_spawn(b,0,6,192.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1160 then
        H.wait(b,v,1160)
        H.timeline_spawn(b,0,6,208.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1166 then
        H.wait(b,v,1166)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1176 then
        H.wait(b,v,1176)
        H.timeline_spawn(b,0,6,224.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1192 then
        H.wait(b,v,1192)
        H.timeline_spawn(b,0,6,256.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1198 then
        H.wait(b,v,1198)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1208 then
        H.wait(b,v,1208)
        H.timeline_spawn(b,0,6,272.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1214 then
        H.wait(b,v,1214)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1224 then
        H.wait(b,v,1224)
        H.timeline_spawn(b,0,6,288.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1230 then
        H.wait(b,v,1230)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1240 then
        H.wait(b,v,1240)
        H.timeline_spawn(b,0,6,304.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1340 then
        H.wait(b,v,1340)
        H.timeline_spawn(b,0,6,352.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1356 then
        H.wait(b,v,1356)
        H.timeline_spawn(b,0,6,336.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1362 then
        H.wait(b,v,1362)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1372 then
        H.wait(b,v,1372)
        H.timeline_spawn(b,0,6,320.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1388 then
        H.wait(b,v,1388)
        H.timeline_spawn(b,0,6,304.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1404 then
        H.wait(b,v,1404)
        H.timeline_spawn(b,0,6,288.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1420 then
        H.wait(b,v,1420)
        H.timeline_spawn(b,0,6,272.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1426 then
        H.wait(b,v,1426)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1436 then
        H.wait(b,v,1436)
        H.timeline_spawn(b,0,6,256.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1452 then
        H.wait(b,v,1452)
        H.timeline_spawn(b,0,6,240.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1468 then
        H.wait(b,v,1468)
        H.timeline_spawn(b,0,6,224.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1484 then
        H.wait(b,v,1484)
        H.timeline_spawn(b,0,6,208.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1500 then
        H.wait(b,v,1500)
        H.timeline_spawn(b,0,6,192.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1516 then
        H.wait(b,v,1516)
        H.timeline_spawn(b,0,6,176.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1522 then
        H.wait(b,v,1522)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1532 then
        H.wait(b,v,1532)
        H.timeline_spawn(b,0,6,160.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1548 then
        H.wait(b,v,1548)
        H.timeline_spawn(b,0,6,128.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1554 then
        H.wait(b,v,1554)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1564 then
        H.wait(b,v,1564)
        H.timeline_spawn(b,0,6,112.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1570 then
        H.wait(b,v,1570)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1580 then
        H.wait(b,v,1580)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1586 then
        H.wait(b,v,1586)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1596 then
        H.wait(b,v,1596)
        H.timeline_spawn(b,0,6,80.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1696 then
        H.wait(b,v,1696)
        H.timeline_spawn(b,0,6,32.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1712 then
        H.wait(b,v,1712)
        H.timeline_spawn(b,0,6,48.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1718 then
        H.wait(b,v,1718)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1728 then
        H.wait(b,v,1728)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1744 then
        H.wait(b,v,1744)
        H.timeline_spawn(b,0,6,80.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1760 then
        H.wait(b,v,1760)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1776 then
        H.wait(b,v,1776)
        H.timeline_spawn(b,0,6,112.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1782 then
        H.wait(b,v,1782)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1792 then
        H.wait(b,v,1792)
        H.timeline_spawn(b,0,6,128.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1808 then
        H.wait(b,v,1808)
        H.timeline_spawn(b,0,6,144.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1824 then
        H.wait(b,v,1824)
        H.timeline_spawn(b,0,6,160.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1840 then
        H.wait(b,v,1840)
        H.timeline_spawn(b,0,6,176.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1856 then
        H.wait(b,v,1856)
        H.timeline_spawn(b,0,6,192.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1872 then
        H.wait(b,v,1872)
        H.timeline_spawn(b,0,6,208.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1878 then
        H.wait(b,v,1878)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1888 then
        H.wait(b,v,1888)
        H.timeline_spawn(b,0,6,224.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1904 then
        H.wait(b,v,1904)
        H.timeline_spawn(b,0,6,256.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1910 then
        H.wait(b,v,1910)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1920 then
        H.wait(b,v,1920)
        H.timeline_spawn(b,0,6,272.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1926 then
        H.wait(b,v,1926)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1936 then
        H.wait(b,v,1936)
        H.timeline_spawn(b,0,6,288.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=1942 then
        H.wait(b,v,1942)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=1952 then
        H.wait(b,v,1952)
        H.timeline_spawn(b,0,6,304.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2052 then
        H.wait(b,v,2052)
        H.timeline_spawn(b,0,6,352.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2068 then
        H.wait(b,v,2068)
        H.timeline_spawn(b,0,6,336.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2074 then
        H.wait(b,v,2074)
        H.timeline_spawn(b,4,4,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=2084 then
        H.wait(b,v,2084)
        H.timeline_spawn(b,0,6,320.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2100 then
        H.wait(b,v,2100)
        H.timeline_spawn(b,0,6,304.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2116 then
        H.wait(b,v,2116)
        H.timeline_spawn(b,0,6,288.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2132 then
        H.wait(b,v,2132)
        H.timeline_spawn(b,0,6,272.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2138 then
        H.wait(b,v,2138)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=2148 then
        H.wait(b,v,2148)
        H.timeline_spawn(b,0,6,256.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2164 then
        H.wait(b,v,2164)
        H.timeline_spawn(b,0,6,240.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2180 then
        H.wait(b,v,2180)
        H.timeline_spawn(b,0,6,224.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2196 then
        H.wait(b,v,2196)
        H.timeline_spawn(b,0,6,208.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2212 then
        H.wait(b,v,2212)
        H.timeline_spawn(b,0,6,192.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2228 then
        H.wait(b,v,2228)
        H.timeline_spawn(b,0,6,176.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2234 then
        H.wait(b,v,2234)
        H.timeline_spawn(b,4,1,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=2244 then
        H.wait(b,v,2244)
        H.timeline_spawn(b,0,6,160.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2260 then
        H.wait(b,v,2260)
        H.timeline_spawn(b,0,6,128.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2266 then
        H.wait(b,v,2266)
        H.timeline_spawn(b,4,2,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=2276 then
        H.wait(b,v,2276)
        H.timeline_spawn(b,0,6,112.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2282 then
        H.wait(b,v,2282)
        H.timeline_spawn(b,4,3,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=2292 then
        H.wait(b,v,2292)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,60,-1,500)
    end
    if v.epoch<=2298 then
        H.wait(b,v,2298)
        H.timeline_spawn(b,4,0,-999.0,-32.0,0.0,70,1,700)
    end
    if v.epoch<=2308 then
        H.wait(b,v,2308)
        H.timeline_spawn(b,0,6,80.0,-32.0,0.0,60,-1,500)
    end
    H.wait(b,v,2588)
    H.erase(b)
end

-- 二面道中·后半：原时间轴 2588..5983，302 次创建。
P[2]["road_after"]=function(b,v)
    if v.epoch<=1000 then
        H.wait(b,v,1000)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1005 then
        H.wait(b,v,1005)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1010 then
        H.wait(b,v,1010)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1015 then
        H.wait(b,v,1015)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1020 then
        H.wait(b,v,1020)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1025 then
        H.wait(b,v,1025)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1030 then
        H.wait(b,v,1030)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1035 then
        H.wait(b,v,1035)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1040 then
        H.wait(b,v,1040)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1045 then
        H.wait(b,v,1045)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1050 then
        H.wait(b,v,1050)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1055 then
        H.wait(b,v,1055)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1060 then
        H.wait(b,v,1060)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1065 then
        H.wait(b,v,1065)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1070 then
        H.wait(b,v,1070)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1075 then
        H.wait(b,v,1075)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1080 then
        H.wait(b,v,1080)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1085 then
        H.wait(b,v,1085)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1090 then
        H.wait(b,v,1090)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1095 then
        H.wait(b,v,1095)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1100 then
        H.wait(b,v,1100)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1105 then
        H.wait(b,v,1105)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1110 then
        H.wait(b,v,1110)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1115 then
        H.wait(b,v,1115)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1120 then
        H.wait(b,v,1120)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1125 then
        H.wait(b,v,1125)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1130 then
        H.wait(b,v,1130)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1135 then
        H.wait(b,v,1135)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1140 then
        H.wait(b,v,1140)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1145 then
        H.wait(b,v,1145)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1150 then
        H.wait(b,v,1150)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1155 then
        H.wait(b,v,1155)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1160 then
        H.wait(b,v,1160)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1165 then
        H.wait(b,v,1165)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1170 then
        H.wait(b,v,1170)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1175 then
        H.wait(b,v,1175)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1180 then
        H.wait(b,v,1180)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1185 then
        H.wait(b,v,1185)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1190 then
        H.wait(b,v,1190)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1195 then
        H.wait(b,v,1195)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1200 then
        H.wait(b,v,1200)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1205 then
        H.wait(b,v,1205)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1210 then
        H.wait(b,v,1210)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1215 then
        H.wait(b,v,1215)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1220 then
        H.wait(b,v,1220)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1225 then
        H.wait(b,v,1225)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1230 then
        H.wait(b,v,1230)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1235 then
        H.wait(b,v,1235)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1240 then
        H.wait(b,v,1240)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1245 then
        H.wait(b,v,1245)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1250 then
        H.wait(b,v,1250)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1255 then
        H.wait(b,v,1255)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1260 then
        H.wait(b,v,1260)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1265 then
        H.wait(b,v,1265)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1270 then
        H.wait(b,v,1270)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1275 then
        H.wait(b,v,1275)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1280 then
        H.wait(b,v,1280)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1285 then
        H.wait(b,v,1285)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1290 then
        H.wait(b,v,1290)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1295 then
        H.wait(b,v,1295)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1300 then
        H.wait(b,v,1300)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1305 then
        H.wait(b,v,1305)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1310 then
        H.wait(b,v,1310)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1315 then
        H.wait(b,v,1315)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1320 then
        H.wait(b,v,1320)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1325 then
        H.wait(b,v,1325)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1330 then
        H.wait(b,v,1330)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1335 then
        H.wait(b,v,1335)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1340 then
        H.wait(b,v,1340)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1345 then
        H.wait(b,v,1345)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1350 then
        H.wait(b,v,1350)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1355 then
        H.wait(b,v,1355)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1360 then
        H.wait(b,v,1360)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1365 then
        H.wait(b,v,1365)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1370 then
        H.wait(b,v,1370)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1375 then
        H.wait(b,v,1375)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1380 then
        H.wait(b,v,1380)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1385 then
        H.wait(b,v,1385)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1390 then
        H.wait(b,v,1390)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1395 then
        H.wait(b,v,1395)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1400 then
        H.wait(b,v,1400)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1405 then
        H.wait(b,v,1405)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1410 then
        H.wait(b,v,1410)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1415 then
        H.wait(b,v,1415)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1420 then
        H.wait(b,v,1420)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1425 then
        H.wait(b,v,1425)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1430 then
        H.wait(b,v,1430)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1435 then
        H.wait(b,v,1435)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1440 then
        H.wait(b,v,1440)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1445 then
        H.wait(b,v,1445)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1450 then
        H.wait(b,v,1450)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1455 then
        H.wait(b,v,1455)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1460 then
        H.wait(b,v,1460)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1465 then
        H.wait(b,v,1465)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1470 then
        H.wait(b,v,1470)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1475 then
        H.wait(b,v,1475)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1480 then
        H.wait(b,v,1480)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1485 then
        H.wait(b,v,1485)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1490 then
        H.wait(b,v,1490)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1495 then
        H.wait(b,v,1495)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1500 then
        H.wait(b,v,1500)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1505 then
        H.wait(b,v,1505)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1510 then
        H.wait(b,v,1510)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1515 then
        H.wait(b,v,1515)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1520 then
        H.wait(b,v,1520)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1525 then
        H.wait(b,v,1525)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1530 then
        H.wait(b,v,1530)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1535 then
        H.wait(b,v,1535)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1540 then
        H.wait(b,v,1540)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1545 then
        H.wait(b,v,1545)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1550 then
        H.wait(b,v,1550)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1555 then
        H.wait(b,v,1555)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1560 then
        H.wait(b,v,1560)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1565 then
        H.wait(b,v,1565)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1570 then
        H.wait(b,v,1570)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1575 then
        H.wait(b,v,1575)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1580 then
        H.wait(b,v,1580)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1585 then
        H.wait(b,v,1585)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1590 then
        H.wait(b,v,1590)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1595 then
        H.wait(b,v,1595)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1600 then
        H.wait(b,v,1600)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1605 then
        H.wait(b,v,1605)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1610 then
        H.wait(b,v,1610)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1615 then
        H.wait(b,v,1615)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1620 then
        H.wait(b,v,1620)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1625 then
        H.wait(b,v,1625)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1630 then
        H.wait(b,v,1630)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1635 then
        H.wait(b,v,1635)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1640 then
        H.wait(b,v,1640)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1645 then
        H.wait(b,v,1645)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1650 then
        H.wait(b,v,1650)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1655 then
        H.wait(b,v,1655)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1660 then
        H.wait(b,v,1660)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1665 then
        H.wait(b,v,1665)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1670 then
        H.wait(b,v,1670)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1675 then
        H.wait(b,v,1675)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1680 then
        H.wait(b,v,1680)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1685 then
        H.wait(b,v,1685)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1690 then
        H.wait(b,v,1690)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1695 then
        H.wait(b,v,1695)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1700 then
        H.wait(b,v,1700)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1705 then
        H.wait(b,v,1705)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1710 then
        H.wait(b,v,1710)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1715 then
        H.wait(b,v,1715)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1720 then
        H.wait(b,v,1720)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1725 then
        H.wait(b,v,1725)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1730 then
        H.wait(b,v,1730)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1735 then
        H.wait(b,v,1735)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1740 then
        H.wait(b,v,1740)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1745 then
        H.wait(b,v,1745)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1750 then
        H.wait(b,v,1750)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1755 then
        H.wait(b,v,1755)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1760 then
        H.wait(b,v,1760)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1765 then
        H.wait(b,v,1765)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1770 then
        H.wait(b,v,1770)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1775 then
        H.wait(b,v,1775)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1780 then
        H.wait(b,v,1780)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1785 then
        H.wait(b,v,1785)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1790 then
        H.wait(b,v,1790)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1795 then
        H.wait(b,v,1795)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1800 then
        H.wait(b,v,1800)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1805 then
        H.wait(b,v,1805)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1810 then
        H.wait(b,v,1810)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1815 then
        H.wait(b,v,1815)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1820 then
        H.wait(b,v,1820)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1825 then
        H.wait(b,v,1825)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1830 then
        H.wait(b,v,1830)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1835 then
        H.wait(b,v,1835)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1840 then
        H.wait(b,v,1840)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1845 then
        H.wait(b,v,1845)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1850 then
        H.wait(b,v,1850)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1855 then
        H.wait(b,v,1855)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1860 then
        H.wait(b,v,1860)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1865 then
        H.wait(b,v,1865)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1870 then
        H.wait(b,v,1870)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1875 then
        H.wait(b,v,1875)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1880 then
        H.wait(b,v,1880)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1885 then
        H.wait(b,v,1885)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1890 then
        H.wait(b,v,1890)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1895 then
        H.wait(b,v,1895)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1900 then
        H.wait(b,v,1900)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1905 then
        H.wait(b,v,1905)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1910 then
        H.wait(b,v,1910)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=1915 then
        H.wait(b,v,1915)
        H.timeline_spawn(b,4,7,-999.0,-32.0,0.0,30,-1,350)
    end
    if v.epoch<=2035 then
        H.wait(b,v,2035)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2045 then
        H.wait(b,v,2045)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2055 then
        H.wait(b,v,2055)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2065 then
        H.wait(b,v,2065)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2075 then
        H.wait(b,v,2075)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2085 then
        H.wait(b,v,2085)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2095 then
        H.wait(b,v,2095)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2105 then
        H.wait(b,v,2105)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,32.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2115 then
        H.wait(b,v,2115)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2125 then
        H.wait(b,v,2125)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2135 then
        H.wait(b,v,2135)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2145 then
        H.wait(b,v,2145)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,64.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2155 then
        H.wait(b,v,2155)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2165 then
        H.wait(b,v,2165)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2175 then
        H.wait(b,v,2175)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2185 then
        H.wait(b,v,2185)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,96.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2195 then
        H.wait(b,v,2195)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2205 then
        H.wait(b,v,2205)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2215 then
        H.wait(b,v,2215)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2225 then
        H.wait(b,v,2225)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,128.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2235 then
        H.wait(b,v,2235)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2245 then
        H.wait(b,v,2245)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2255 then
        H.wait(b,v,2255)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2265 then
        H.wait(b,v,2265)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,160.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2275 then
        H.wait(b,v,2275)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2285 then
        H.wait(b,v,2285)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2295 then
        H.wait(b,v,2295)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2305 then
        H.wait(b,v,2305)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,192.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2315 then
        H.wait(b,v,2315)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2325 then
        H.wait(b,v,2325)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2335 then
        H.wait(b,v,2335)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2345 then
        H.wait(b,v,2345)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,224.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2355 then
        H.wait(b,v,2355)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2365 then
        H.wait(b,v,2365)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2375 then
        H.wait(b,v,2375)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2385 then
        H.wait(b,v,2385)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,256.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2395 then
        H.wait(b,v,2395)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2405 then
        H.wait(b,v,2405)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2415 then
        H.wait(b,v,2415)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2425 then
        H.wait(b,v,2425)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,288.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2435 then
        H.wait(b,v,2435)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2445 then
        H.wait(b,v,2445)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2455 then
        H.wait(b,v,2455)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2465 then
        H.wait(b,v,2465)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,320.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2475 then
        H.wait(b,v,2475)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2485 then
        H.wait(b,v,2485)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2495 then
        H.wait(b,v,2495)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2505 then
        H.wait(b,v,2505)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,352.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2625 then
        H.wait(b,v,2625)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2635 then
        H.wait(b,v,2635)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2645 then
        H.wait(b,v,2645)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2655 then
        H.wait(b,v,2655)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2665 then
        H.wait(b,v,2665)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2675 then
        H.wait(b,v,2675)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2685 then
        H.wait(b,v,2685)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2695 then
        H.wait(b,v,2695)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,352.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2705 then
        H.wait(b,v,2705)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2715 then
        H.wait(b,v,2715)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2725 then
        H.wait(b,v,2725)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2735 then
        H.wait(b,v,2735)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,320.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2745 then
        H.wait(b,v,2745)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2755 then
        H.wait(b,v,2755)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2765 then
        H.wait(b,v,2765)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2775 then
        H.wait(b,v,2775)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,288.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2785 then
        H.wait(b,v,2785)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2795 then
        H.wait(b,v,2795)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2805 then
        H.wait(b,v,2805)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2815 then
        H.wait(b,v,2815)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,256.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2825 then
        H.wait(b,v,2825)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2835 then
        H.wait(b,v,2835)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2845 then
        H.wait(b,v,2845)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2855 then
        H.wait(b,v,2855)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,224.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2865 then
        H.wait(b,v,2865)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2875 then
        H.wait(b,v,2875)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2885 then
        H.wait(b,v,2885)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2895 then
        H.wait(b,v,2895)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,192.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2905 then
        H.wait(b,v,2905)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2915 then
        H.wait(b,v,2915)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2925 then
        H.wait(b,v,2925)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2935 then
        H.wait(b,v,2935)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,160.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2945 then
        H.wait(b,v,2945)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2955 then
        H.wait(b,v,2955)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2965 then
        H.wait(b,v,2965)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2975 then
        H.wait(b,v,2975)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,128.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=2985 then
        H.wait(b,v,2985)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=2995 then
        H.wait(b,v,2995)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3005 then
        H.wait(b,v,3005)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3015 then
        H.wait(b,v,3015)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,96.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=3025 then
        H.wait(b,v,3025)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3035 then
        H.wait(b,v,3035)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3045 then
        H.wait(b,v,3045)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3055 then
        H.wait(b,v,3055)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,64.0,-32.0,0.0,80,-1,600)
    end
    if v.epoch<=3065 then
        H.wait(b,v,3065)
        H.timeline_spawn(b,4,8,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3075 then
        H.wait(b,v,3075)
        H.timeline_spawn(b,4,9,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3085 then
        H.wait(b,v,3085)
        H.timeline_spawn(b,4,10,-999.0,-32.0,0.0,50,-1,350)
    end
    if v.epoch<=3095 then
        H.wait(b,v,3095)
        H.timeline_spawn(b,4,11,-999.0,-32.0,0.0,50,-1,350)
        H.timeline_spawn(b,0,12,32.0,-32.0,0.0,80,-1,600)
    end
    H.wait(b,v,3395)
    H.erase(b)
end

-- 三面道中·前半：原时间轴 0..3804，220 次创建。
P[3]["road_before"]=function(b,v)
    if v.epoch<=400 then
        H.wait(b,v,400)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=408 then
        H.wait(b,v,408)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=416 then
        H.wait(b,v,416)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=424 then
        H.wait(b,v,424)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=432 then
        H.wait(b,v,432)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=440 then
        H.wait(b,v,440)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=448 then
        H.wait(b,v,448)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=456 then
        H.wait(b,v,456)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=464 then
        H.wait(b,v,464)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=472 then
        H.wait(b,v,472)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=480 then
        H.wait(b,v,480)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=488 then
        H.wait(b,v,488)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=496 then
        H.wait(b,v,496)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=504 then
        H.wait(b,v,504)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=512 then
        H.wait(b,v,512)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=520 then
        H.wait(b,v,520)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=528 then
        H.wait(b,v,528)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=536 then
        H.wait(b,v,536)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=544 then
        H.wait(b,v,544)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=552 then
        H.wait(b,v,552)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=560 then
        H.wait(b,v,560)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=568 then
        H.wait(b,v,568)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=576 then
        H.wait(b,v,576)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=584 then
        H.wait(b,v,584)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=592 then
        H.wait(b,v,592)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=600 then
        H.wait(b,v,600)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=608 then
        H.wait(b,v,608)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=616 then
        H.wait(b,v,616)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=706 then
        H.wait(b,v,706)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=714 then
        H.wait(b,v,714)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=722 then
        H.wait(b,v,722)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=730 then
        H.wait(b,v,730)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=738 then
        H.wait(b,v,738)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=746 then
        H.wait(b,v,746)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=754 then
        H.wait(b,v,754)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=762 then
        H.wait(b,v,762)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=770 then
        H.wait(b,v,770)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=778 then
        H.wait(b,v,778)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=786 then
        H.wait(b,v,786)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=794 then
        H.wait(b,v,794)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=802 then
        H.wait(b,v,802)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=810 then
        H.wait(b,v,810)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=818 then
        H.wait(b,v,818)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=826 then
        H.wait(b,v,826)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=834 then
        H.wait(b,v,834)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=842 then
        H.wait(b,v,842)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=850 then
        H.wait(b,v,850)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=858 then
        H.wait(b,v,858)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=866 then
        H.wait(b,v,866)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=874 then
        H.wait(b,v,874)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=882 then
        H.wait(b,v,882)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=890 then
        H.wait(b,v,890)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1110 then
        H.wait(b,v,1110)
        H.timeline_spawn(b,0,4,320.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,64.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1170 then
        H.wait(b,v,1170)
        H.timeline_spawn(b,0,4,288.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,96.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1230 then
        H.wait(b,v,1230)
        H.timeline_spawn(b,0,4,256.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,128.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1290 then
        H.wait(b,v,1290)
        H.timeline_spawn(b,0,4,224.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,160.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1470 then
        H.wait(b,v,1470)
        H.timeline_spawn(b,0,4,256.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,128.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1490 then
        H.wait(b,v,1490)
        H.timeline_spawn(b,0,4,288.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,96.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1510 then
        H.wait(b,v,1510)
        H.timeline_spawn(b,0,4,320.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,64.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1730 then
        H.wait(b,v,1730)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1750 then
        H.wait(b,v,1750)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1770 then
        H.wait(b,v,1770)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1790 then
        H.wait(b,v,1790)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1810 then
        H.wait(b,v,1810)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1816 then
        H.wait(b,v,1816)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=1828 then
        H.wait(b,v,1828)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=1840 then
        H.wait(b,v,1840)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=1852 then
        H.wait(b,v,1852)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=1864 then
        H.wait(b,v,1864)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=1876 then
        H.wait(b,v,1876)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=1888 then
        H.wait(b,v,1888)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=1908 then
        H.wait(b,v,1908)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1928 then
        H.wait(b,v,1928)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1948 then
        H.wait(b,v,1948)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1968 then
        H.wait(b,v,1968)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1988 then
        H.wait(b,v,1988)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=1994 then
        H.wait(b,v,1994)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2006 then
        H.wait(b,v,2006)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2018 then
        H.wait(b,v,2018)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2030 then
        H.wait(b,v,2030)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2042 then
        H.wait(b,v,2042)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2054 then
        H.wait(b,v,2054)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2066 then
        H.wait(b,v,2066)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2186 then
        H.wait(b,v,2186)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2206 then
        H.wait(b,v,2206)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2226 then
        H.wait(b,v,2226)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2246 then
        H.wait(b,v,2246)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2266 then
        H.wait(b,v,2266)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2272 then
        H.wait(b,v,2272)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2284 then
        H.wait(b,v,2284)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2296 then
        H.wait(b,v,2296)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2308 then
        H.wait(b,v,2308)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2320 then
        H.wait(b,v,2320)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2332 then
        H.wait(b,v,2332)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2344 then
        H.wait(b,v,2344)
        H.timeline_spawn(b,0,6,64.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,0,6,96.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2364 then
        H.wait(b,v,2364)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2384 then
        H.wait(b,v,2384)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2404 then
        H.wait(b,v,2404)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2424 then
        H.wait(b,v,2424)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2444 then
        H.wait(b,v,2444)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2450 then
        H.wait(b,v,2450)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2462 then
        H.wait(b,v,2462)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2474 then
        H.wait(b,v,2474)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2486 then
        H.wait(b,v,2486)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2498 then
        H.wait(b,v,2498)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2510 then
        H.wait(b,v,2510)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2522 then
        H.wait(b,v,2522)
        H.timeline_spawn(b,2,6,320.0,-32.0,0.0,30,-1,300)
        H.timeline_spawn(b,2,6,288.0,-32.0,0.0,30,-1,300)
    end
    if v.epoch<=2822 then
        H.wait(b,v,2822)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2830 then
        H.wait(b,v,2830)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2838 then
        H.wait(b,v,2838)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2846 then
        H.wait(b,v,2846)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2854 then
        H.wait(b,v,2854)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2862 then
        H.wait(b,v,2862)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2870 then
        H.wait(b,v,2870)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2878 then
        H.wait(b,v,2878)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2886 then
        H.wait(b,v,2886)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2894 then
        H.wait(b,v,2894)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2902 then
        H.wait(b,v,2902)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2910 then
        H.wait(b,v,2910)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2918 then
        H.wait(b,v,2918)
        H.timeline_spawn(b,0,0,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2926 then
        H.wait(b,v,2926)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2936 then
        H.wait(b,v,2936)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2946 then
        H.wait(b,v,2946)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2956 then
        H.wait(b,v,2956)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2966 then
        H.wait(b,v,2966)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2976 then
        H.wait(b,v,2976)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=2984 then
        H.wait(b,v,2984)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=2992 then
        H.wait(b,v,2992)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3000 then
        H.wait(b,v,3000)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3008 then
        H.wait(b,v,3008)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3016 then
        H.wait(b,v,3016)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3024 then
        H.wait(b,v,3024)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3032 then
        H.wait(b,v,3032)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3040 then
        H.wait(b,v,3040)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3048 then
        H.wait(b,v,3048)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3056 then
        H.wait(b,v,3056)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3064 then
        H.wait(b,v,3064)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3072 then
        H.wait(b,v,3072)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3080 then
        H.wait(b,v,3080)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3088 then
        H.wait(b,v,3088)
        H.timeline_spawn(b,2,0,416.0,64.0,0.0,30,-1,500)
    end
    if v.epoch<=3098 then
        H.wait(b,v,3098)
        H.timeline_spawn(b,0,4,256.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,128.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3108 then
        H.wait(b,v,3108)
        H.timeline_spawn(b,0,4,288.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,96.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3118 then
        H.wait(b,v,3118)
        H.timeline_spawn(b,0,4,320.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,64.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3208 then
        H.wait(b,v,3208)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3216 then
        H.wait(b,v,3216)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3224 then
        H.wait(b,v,3224)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3232 then
        H.wait(b,v,3232)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3240 then
        H.wait(b,v,3240)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3248 then
        H.wait(b,v,3248)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3256 then
        H.wait(b,v,3256)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3264 then
        H.wait(b,v,3264)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3272 then
        H.wait(b,v,3272)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3280 then
        H.wait(b,v,3280)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3288 then
        H.wait(b,v,3288)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3296 then
        H.wait(b,v,3296)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3304 then
        H.wait(b,v,3304)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3312 then
        H.wait(b,v,3312)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3322 then
        H.wait(b,v,3322)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3332 then
        H.wait(b,v,3332)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3342 then
        H.wait(b,v,3342)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3352 then
        H.wait(b,v,3352)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3362 then
        H.wait(b,v,3362)
        H.timeline_spawn(b,4,5,-999.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3370 then
        H.wait(b,v,3370)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3378 then
        H.wait(b,v,3378)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3386 then
        H.wait(b,v,3386)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3394 then
        H.wait(b,v,3394)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3402 then
        H.wait(b,v,3402)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3410 then
        H.wait(b,v,3410)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3418 then
        H.wait(b,v,3418)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3426 then
        H.wait(b,v,3426)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3434 then
        H.wait(b,v,3434)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3442 then
        H.wait(b,v,3442)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3450 then
        H.wait(b,v,3450)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3458 then
        H.wait(b,v,3458)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3466 then
        H.wait(b,v,3466)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3474 then
        H.wait(b,v,3474)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=3484 then
        H.wait(b,v,3484)
        H.timeline_spawn(b,0,4,256.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,128.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3494 then
        H.wait(b,v,3494)
        H.timeline_spawn(b,0,4,288.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,96.0,-32.0,0.0,400,1,1000)
    end
    if v.epoch<=3504 then
        H.wait(b,v,3504)
        H.timeline_spawn(b,0,4,320.0,-32.0,0.0,400,1,1000)
        H.timeline_spawn(b,0,4,64.0,-32.0,0.0,400,1,1000)
    end
    H.wait(b,v,3804)
    H.erase(b)
end

-- 三面道中·后半：原时间轴 3805..5854，187 次创建。
P[3]["road_after"]=function(b,v)
    if v.epoch<=11 then
        H.wait(b,v,11)
        H.timeline_spawn(b,0,7,64.0,-32.0,0.0,450,-1,1000)
        H.timeline_spawn(b,2,7,320.0,-32.0,0.0,450,-1,1000)
    end
    if v.epoch<=41 then
        H.wait(b,v,41)
        H.timeline_spawn(b,0,7,128.0,-32.0,0.0,450,-1,1000)
        H.timeline_spawn(b,2,7,256.0,-32.0,0.0,450,-1,1000)
    end
    if v.epoch<=71 then
        H.wait(b,v,71)
        H.timeline_spawn(b,0,7,192.0,-32.0,0.0,450,-1,1000)
        H.timeline_spawn(b,2,7,192.0,-32.0,0.0,450,-1,1000)
    end
    if v.epoch<=79 then
        H.wait(b,v,79)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=87 then
        H.wait(b,v,87)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=95 then
        H.wait(b,v,95)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=103 then
        H.wait(b,v,103)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=111 then
        H.wait(b,v,111)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=119 then
        H.wait(b,v,119)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=127 then
        H.wait(b,v,127)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=135 then
        H.wait(b,v,135)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=143 then
        H.wait(b,v,143)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=151 then
        H.wait(b,v,151)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=159 then
        H.wait(b,v,159)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=167 then
        H.wait(b,v,167)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=175 then
        H.wait(b,v,175)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=185 then
        H.wait(b,v,185)
        H.timeline_spawn(b,0,7,32.0,-32.0,0.0,450,-1,1000)
        H.timeline_spawn(b,2,7,352.0,-32.0,0.0,450,-1,1000)
    end
    if v.epoch<=215 then
        H.wait(b,v,215)
        H.timeline_spawn(b,0,7,96.0,-32.0,0.0,450,-1,1000)
        H.timeline_spawn(b,2,7,288.0,-32.0,0.0,450,-1,1000)
    end
    if v.epoch<=245 then
        H.wait(b,v,245)
        H.timeline_spawn(b,0,7,160.0,-32.0,0.0,450,-1,1000)
        H.timeline_spawn(b,2,7,224.0,-32.0,0.0,450,-1,1000)
    end
    if v.epoch<=373 then
        H.wait(b,v,373)
        H.timeline_spawn(b,0,8,64.0,-32.0,0.0,350,-1,1000)
        H.timeline_spawn(b,2,8,320.0,-32.0,0.0,350,-1,1000)
    end
    if v.epoch<=403 then
        H.wait(b,v,403)
        H.timeline_spawn(b,0,8,128.0,-32.0,0.0,350,-1,1000)
        H.timeline_spawn(b,2,8,256.0,-32.0,0.0,350,-1,1000)
    end
    if v.epoch<=433 then
        H.wait(b,v,433)
        H.timeline_spawn(b,0,8,192.0,-32.0,0.0,350,-1,1000)
        H.timeline_spawn(b,2,8,192.0,-32.0,0.0,350,-1,1000)
    end
    if v.epoch<=437 then
        H.wait(b,v,437)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=441 then
        H.wait(b,v,441)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=445 then
        H.wait(b,v,445)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=449 then
        H.wait(b,v,449)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=453 then
        H.wait(b,v,453)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=457 then
        H.wait(b,v,457)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=461 then
        H.wait(b,v,461)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=465 then
        H.wait(b,v,465)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=469 then
        H.wait(b,v,469)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=473 then
        H.wait(b,v,473)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=477 then
        H.wait(b,v,477)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=481 then
        H.wait(b,v,481)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=485 then
        H.wait(b,v,485)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=489 then
        H.wait(b,v,489)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=493 then
        H.wait(b,v,493)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=497 then
        H.wait(b,v,497)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=501 then
        H.wait(b,v,501)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=505 then
        H.wait(b,v,505)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=509 then
        H.wait(b,v,509)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=513 then
        H.wait(b,v,513)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=517 then
        H.wait(b,v,517)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=521 then
        H.wait(b,v,521)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=525 then
        H.wait(b,v,525)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=529 then
        H.wait(b,v,529)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=533 then
        H.wait(b,v,533)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=537 then
        H.wait(b,v,537)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=665 then
        H.wait(b,v,665)
        H.timeline_spawn(b,0,8,60.0,-32.0,0.0,350,1,1000)
        H.timeline_spawn(b,2,8,324.0,-32.0,0.0,350,1,1000)
    end
    if v.epoch<=695 then
        H.wait(b,v,695)
        H.timeline_spawn(b,0,8,124.0,-32.0,0.0,350,1,1000)
        H.timeline_spawn(b,2,8,260.0,-32.0,0.0,350,1,1000)
    end
    if v.epoch<=725 then
        H.wait(b,v,725)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,350,1,1000)
        H.timeline_spawn(b,2,8,196.0,-32.0,0.0,350,1,1000)
    end
    if v.epoch<=755 then
        H.wait(b,v,755)
        H.timeline_spawn(b,0,7,80.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,304.0,-32.0,0.0,450,1,1000)
    end
    if v.epoch<=785 then
        H.wait(b,v,785)
        H.timeline_spawn(b,0,7,144.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,240.0,-32.0,0.0,450,1,1000)
    end
    if v.epoch<=815 then
        H.wait(b,v,815)
        H.timeline_spawn(b,0,7,208.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,176.0,-32.0,0.0,450,1,1000)
    end
    if v.epoch<=845 then
        H.wait(b,v,845)
        H.timeline_spawn(b,0,8,60.0,-32.0,0.0,350,1,1000)
    end
    if v.epoch<=875 then
        H.wait(b,v,875)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,350,1,1000)
    end
    if v.epoch<=879 then
        H.wait(b,v,879)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=883 then
        H.wait(b,v,883)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=887 then
        H.wait(b,v,887)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=891 then
        H.wait(b,v,891)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=895 then
        H.wait(b,v,895)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=899 then
        H.wait(b,v,899)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=903 then
        H.wait(b,v,903)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=907 then
        H.wait(b,v,907)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=911 then
        H.wait(b,v,911)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=915 then
        H.wait(b,v,915)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=919 then
        H.wait(b,v,919)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=923 then
        H.wait(b,v,923)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=927 then
        H.wait(b,v,927)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=931 then
        H.wait(b,v,931)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=935 then
        H.wait(b,v,935)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=939 then
        H.wait(b,v,939)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=943 then
        H.wait(b,v,943)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=947 then
        H.wait(b,v,947)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=951 then
        H.wait(b,v,951)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=955 then
        H.wait(b,v,955)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=959 then
        H.wait(b,v,959)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=963 then
        H.wait(b,v,963)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=967 then
        H.wait(b,v,967)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=971 then
        H.wait(b,v,971)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=975 then
        H.wait(b,v,975)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=979 then
        H.wait(b,v,979)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1009 then
        H.wait(b,v,1009)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1013 then
        H.wait(b,v,1013)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1017 then
        H.wait(b,v,1017)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1021 then
        H.wait(b,v,1021)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1025 then
        H.wait(b,v,1025)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1029 then
        H.wait(b,v,1029)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1033 then
        H.wait(b,v,1033)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1037 then
        H.wait(b,v,1037)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1041 then
        H.wait(b,v,1041)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1045 then
        H.wait(b,v,1045)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1049 then
        H.wait(b,v,1049)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1053 then
        H.wait(b,v,1053)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1057 then
        H.wait(b,v,1057)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1061 then
        H.wait(b,v,1061)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1065 then
        H.wait(b,v,1065)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1069 then
        H.wait(b,v,1069)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1073 then
        H.wait(b,v,1073)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1077 then
        H.wait(b,v,1077)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1081 then
        H.wait(b,v,1081)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1085 then
        H.wait(b,v,1085)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1089 then
        H.wait(b,v,1089)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1093 then
        H.wait(b,v,1093)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1097 then
        H.wait(b,v,1097)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1101 then
        H.wait(b,v,1101)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1105 then
        H.wait(b,v,1105)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1109 then
        H.wait(b,v,1109)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1139 then
        H.wait(b,v,1139)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1143 then
        H.wait(b,v,1143)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1147 then
        H.wait(b,v,1147)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1151 then
        H.wait(b,v,1151)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1155 then
        H.wait(b,v,1155)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1159 then
        H.wait(b,v,1159)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1163 then
        H.wait(b,v,1163)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1167 then
        H.wait(b,v,1167)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1171 then
        H.wait(b,v,1171)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1175 then
        H.wait(b,v,1175)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1179 then
        H.wait(b,v,1179)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1183 then
        H.wait(b,v,1183)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1187 then
        H.wait(b,v,1187)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1191 then
        H.wait(b,v,1191)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1195 then
        H.wait(b,v,1195)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1199 then
        H.wait(b,v,1199)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1203 then
        H.wait(b,v,1203)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1207 then
        H.wait(b,v,1207)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1211 then
        H.wait(b,v,1211)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1215 then
        H.wait(b,v,1215)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1219 then
        H.wait(b,v,1219)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1223 then
        H.wait(b,v,1223)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1227 then
        H.wait(b,v,1227)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1231 then
        H.wait(b,v,1231)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1235 then
        H.wait(b,v,1235)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1239 then
        H.wait(b,v,1239)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1269 then
        H.wait(b,v,1269)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1273 then
        H.wait(b,v,1273)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1277 then
        H.wait(b,v,1277)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1281 then
        H.wait(b,v,1281)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1285 then
        H.wait(b,v,1285)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1289 then
        H.wait(b,v,1289)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1293 then
        H.wait(b,v,1293)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1297 then
        H.wait(b,v,1297)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1301 then
        H.wait(b,v,1301)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1305 then
        H.wait(b,v,1305)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1309 then
        H.wait(b,v,1309)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1313 then
        H.wait(b,v,1313)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1317 then
        H.wait(b,v,1317)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1321 then
        H.wait(b,v,1321)
        H.timeline_spawn(b,2,2,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1325 then
        H.wait(b,v,1325)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1329 then
        H.wait(b,v,1329)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1333 then
        H.wait(b,v,1333)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1337 then
        H.wait(b,v,1337)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1341 then
        H.wait(b,v,1341)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1345 then
        H.wait(b,v,1345)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1349 then
        H.wait(b,v,1349)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1353 then
        H.wait(b,v,1353)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1357 then
        H.wait(b,v,1357)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1361 then
        H.wait(b,v,1361)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1365 then
        H.wait(b,v,1365)
        H.timeline_spawn(b,0,2,-32.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1369 then
        H.wait(b,v,1369)
        H.timeline_spawn(b,2,3,416.0,192.0,0.0,30,-1,500)
    end
    if v.epoch<=1529 then
        H.wait(b,v,1529)
        H.timeline_spawn(b,0,8,60.0,-32.0,0.0,350,1,1000)
        H.timeline_spawn(b,2,8,324.0,-32.0,0.0,350,1,1000)
    end
    if v.epoch<=1609 then
        H.wait(b,v,1609)
        H.timeline_spawn(b,0,7,32.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,352.0,-32.0,0.0,450,1,1000)
    end
    if v.epoch<=1619 then
        H.wait(b,v,1619)
        H.timeline_spawn(b,0,7,80.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,304.0,-32.0,0.0,450,1,1000)
    end
    if v.epoch<=1629 then
        H.wait(b,v,1629)
        H.timeline_spawn(b,0,7,128.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,256.0,-32.0,0.0,450,1,1000)
    end
    if v.epoch<=1639 then
        H.wait(b,v,1639)
        H.timeline_spawn(b,0,7,176.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,208.0,-32.0,0.0,450,1,1000)
    end
    if v.epoch<=1649 then
        H.wait(b,v,1649)
        H.timeline_spawn(b,0,7,224.0,-32.0,0.0,450,1,1000)
        H.timeline_spawn(b,2,7,160.0,-32.0,0.0,450,1,1000)
    end
    H.wait(b,v,2049)
    H.erase(b)
end

-- 四面道中·前半：原时间轴 0..4132，116 次创建。
P[4]["road_before"]=function(b,v)
    if v.epoch<=440 then
        H.wait(b,v,440)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,400,1,2000)
        H.timeline_spawn(b,0,0,352.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=472 then
        H.wait(b,v,472)
        H.timeline_spawn(b,0,0,64.0,-32.0,0.0,400,0,2000)
        H.timeline_spawn(b,0,0,320.0,-32.0,0.0,400,0,2000)
    end
    if v.epoch<=504 then
        H.wait(b,v,504)
        H.timeline_spawn(b,0,0,128.0,-16.0,0.0,400,1,2000)
        H.timeline_spawn(b,0,0,256.0,-16.0,0.0,400,1,2000)
    end
    if v.epoch<=1004 then
        H.wait(b,v,1004)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1014 then
        H.wait(b,v,1014)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1024 then
        H.wait(b,v,1024)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1034 then
        H.wait(b,v,1034)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1044 then
        H.wait(b,v,1044)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1054 then
        H.wait(b,v,1054)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1064 then
        H.wait(b,v,1064)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1074 then
        H.wait(b,v,1074)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1084 then
        H.wait(b,v,1084)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1094 then
        H.wait(b,v,1094)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1104 then
        H.wait(b,v,1104)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1114 then
        H.wait(b,v,1114)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1124 then
        H.wait(b,v,1124)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1134 then
        H.wait(b,v,1134)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1234 then
        H.wait(b,v,1234)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1244 then
        H.wait(b,v,1244)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1254 then
        H.wait(b,v,1254)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1264 then
        H.wait(b,v,1264)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1274 then
        H.wait(b,v,1274)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1284 then
        H.wait(b,v,1284)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1294 then
        H.wait(b,v,1294)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1304 then
        H.wait(b,v,1304)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1314 then
        H.wait(b,v,1314)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1324 then
        H.wait(b,v,1324)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1334 then
        H.wait(b,v,1334)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1344 then
        H.wait(b,v,1344)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1354 then
        H.wait(b,v,1354)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1364 then
        H.wait(b,v,1364)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,-1,500)
    end
    if v.epoch<=1514 then
        H.wait(b,v,1514)
        H.timeline_spawn(b,0,10,-32.0,48.0,0.0,400,2,2000)
        H.timeline_spawn(b,2,10,416.0,48.0,0.0,400,2,2000)
    end
    if v.epoch<=1546 then
        H.wait(b,v,1546)
        H.timeline_spawn(b,0,10,-32.0,96.0,0.0,400,2,2000)
        H.timeline_spawn(b,2,10,416.0,96.0,0.0,400,2,2000)
    end
    if v.epoch<=1578 then
        H.wait(b,v,1578)
        H.timeline_spawn(b,0,10,-32.0,160.0,0.0,400,2,2000)
        H.timeline_spawn(b,2,10,416.0,160.0,0.0,400,2,2000)
    end
    if v.epoch<=1878 then
        H.wait(b,v,1878)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1888 then
        H.wait(b,v,1888)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1898 then
        H.wait(b,v,1898)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1908 then
        H.wait(b,v,1908)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1918 then
        H.wait(b,v,1918)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1928 then
        H.wait(b,v,1928)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1938 then
        H.wait(b,v,1938)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1948 then
        H.wait(b,v,1948)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1958 then
        H.wait(b,v,1958)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1968 then
        H.wait(b,v,1968)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1978 then
        H.wait(b,v,1978)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1988 then
        H.wait(b,v,1988)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1998 then
        H.wait(b,v,1998)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2008 then
        H.wait(b,v,2008)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2108 then
        H.wait(b,v,2108)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2118 then
        H.wait(b,v,2118)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2128 then
        H.wait(b,v,2128)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2138 then
        H.wait(b,v,2138)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2148 then
        H.wait(b,v,2148)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2158 then
        H.wait(b,v,2158)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2168 then
        H.wait(b,v,2168)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2178 then
        H.wait(b,v,2178)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2188 then
        H.wait(b,v,2188)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2198 then
        H.wait(b,v,2198)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2208 then
        H.wait(b,v,2208)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2218 then
        H.wait(b,v,2218)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2228 then
        H.wait(b,v,2228)
        H.timeline_spawn(b,0,2,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2238 then
        H.wait(b,v,2238)
        H.timeline_spawn(b,2,2,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2388 then
        H.wait(b,v,2388)
        H.timeline_spawn(b,0,11,96.0,-32.0,0.0,2000,2,2000)
        H.timeline_spawn(b,2,11,288.0,-32.0,0.0,2000,2,2000)
    end
    if v.epoch<=2412 then
        H.wait(b,v,2412)
        H.timeline_spawn(b,0,13,-32.0,96.0,0.0,2000,2,2000)
        H.timeline_spawn(b,2,13,416.0,96.0,0.0,2000,2,2000)
    end
    if v.epoch<=2712 then
        H.wait(b,v,2712)
        H.timeline_spawn(b,0,5,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2722 then
        H.wait(b,v,2722)
        H.timeline_spawn(b,2,5,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2732 then
        H.wait(b,v,2732)
        H.timeline_spawn(b,0,5,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2742 then
        H.wait(b,v,2742)
        H.timeline_spawn(b,2,5,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2752 then
        H.wait(b,v,2752)
        H.timeline_spawn(b,0,5,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2762 then
        H.wait(b,v,2762)
        H.timeline_spawn(b,2,5,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2772 then
        H.wait(b,v,2772)
        H.timeline_spawn(b,0,5,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2782 then
        H.wait(b,v,2782)
        H.timeline_spawn(b,2,5,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2792 then
        H.wait(b,v,2792)
        H.timeline_spawn(b,0,5,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2802 then
        H.wait(b,v,2802)
        H.timeline_spawn(b,2,5,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2812 then
        H.wait(b,v,2812)
        H.timeline_spawn(b,0,5,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2822 then
        H.wait(b,v,2822)
        H.timeline_spawn(b,2,5,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2832 then
        H.wait(b,v,2832)
        H.timeline_spawn(b,0,5,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2842 then
        H.wait(b,v,2842)
        H.timeline_spawn(b,2,5,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2942 then
        H.wait(b,v,2942)
        H.timeline_spawn(b,0,4,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2952 then
        H.wait(b,v,2952)
        H.timeline_spawn(b,2,4,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2962 then
        H.wait(b,v,2962)
        H.timeline_spawn(b,0,4,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2972 then
        H.wait(b,v,2972)
        H.timeline_spawn(b,2,4,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2982 then
        H.wait(b,v,2982)
        H.timeline_spawn(b,0,4,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2992 then
        H.wait(b,v,2992)
        H.timeline_spawn(b,2,4,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3002 then
        H.wait(b,v,3002)
        H.timeline_spawn(b,0,4,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3012 then
        H.wait(b,v,3012)
        H.timeline_spawn(b,2,4,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3022 then
        H.wait(b,v,3022)
        H.timeline_spawn(b,0,4,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3032 then
        H.wait(b,v,3032)
        H.timeline_spawn(b,2,4,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3042 then
        H.wait(b,v,3042)
        H.timeline_spawn(b,0,4,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3052 then
        H.wait(b,v,3052)
        H.timeline_spawn(b,2,4,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3062 then
        H.wait(b,v,3062)
        H.timeline_spawn(b,0,4,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3072 then
        H.wait(b,v,3072)
        H.timeline_spawn(b,2,4,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3172 then
        H.wait(b,v,3172)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3182 then
        H.wait(b,v,3182)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3192 then
        H.wait(b,v,3192)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3202 then
        H.wait(b,v,3202)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3212 then
        H.wait(b,v,3212)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3222 then
        H.wait(b,v,3222)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3232 then
        H.wait(b,v,3232)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3242 then
        H.wait(b,v,3242)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3252 then
        H.wait(b,v,3252)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3262 then
        H.wait(b,v,3262)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3452 then
        H.wait(b,v,3452)
        H.timeline_spawn(b,4,14,-999.0,32.0,0.0,3500,1,2000)
    end
    if v.epoch<=3492 then
        H.wait(b,v,3492)
        H.timeline_spawn(b,4,14,-999.0,128.0,0.0,3500,1,2000)
    end
    if v.epoch<=3532 then
        H.wait(b,v,3532)
        H.timeline_spawn(b,4,14,-999.0,144.0,0.0,3500,1,2000)
    end
    if v.epoch<=3582 then
        H.wait(b,v,3582)
        H.timeline_spawn(b,4,14,-999.0,64.0,0.0,4500,1,2000)
    end
    if v.epoch<=3632 then
        H.wait(b,v,3632)
        H.timeline_spawn(b,4,14,-999.0,80.0,0.0,4500,1,2000)
    end
    if v.epoch<=3692 then
        H.wait(b,v,3692)
        H.timeline_spawn(b,4,14,-999.0,96.0,0.0,4500,1,2000)
    end
    H.wait(b,v,4132)
    H.erase(b)
end

-- 四面道中·后半：原时间轴 4132..10694，279 次创建。
P[4]["road_after"]=function(b,v)
    if v.epoch<=800 then
        H.wait(b,v,800)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=810 then
        H.wait(b,v,810)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=820 then
        H.wait(b,v,820)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=830 then
        H.wait(b,v,830)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=840 then
        H.wait(b,v,840)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=850 then
        H.wait(b,v,850)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=860 then
        H.wait(b,v,860)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=870 then
        H.wait(b,v,870)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=880 then
        H.wait(b,v,880)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=890 then
        H.wait(b,v,890)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=900 then
        H.wait(b,v,900)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=910 then
        H.wait(b,v,910)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=920 then
        H.wait(b,v,920)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=930 then
        H.wait(b,v,930)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1080 then
        H.wait(b,v,1080)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1090 then
        H.wait(b,v,1090)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1100 then
        H.wait(b,v,1100)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1110 then
        H.wait(b,v,1110)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1120 then
        H.wait(b,v,1120)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1130 then
        H.wait(b,v,1130)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1140 then
        H.wait(b,v,1140)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1150 then
        H.wait(b,v,1150)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1160 then
        H.wait(b,v,1160)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1170 then
        H.wait(b,v,1170)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1180 then
        H.wait(b,v,1180)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1190 then
        H.wait(b,v,1190)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1200 then
        H.wait(b,v,1200)
        H.timeline_spawn(b,0,6,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1210 then
        H.wait(b,v,1210)
        H.timeline_spawn(b,2,6,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1360 then
        H.wait(b,v,1360)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1370 then
        H.wait(b,v,1370)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1380 then
        H.wait(b,v,1380)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1390 then
        H.wait(b,v,1390)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1400 then
        H.wait(b,v,1400)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1410 then
        H.wait(b,v,1410)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1420 then
        H.wait(b,v,1420)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1430 then
        H.wait(b,v,1430)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1440 then
        H.wait(b,v,1440)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1450 then
        H.wait(b,v,1450)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1460 then
        H.wait(b,v,1460)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1470 then
        H.wait(b,v,1470)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1480 then
        H.wait(b,v,1480)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1490 then
        H.wait(b,v,1490)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1640 then
        H.wait(b,v,1640)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1650 then
        H.wait(b,v,1650)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1660 then
        H.wait(b,v,1660)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1670 then
        H.wait(b,v,1670)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1680 then
        H.wait(b,v,1680)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1690 then
        H.wait(b,v,1690)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1700 then
        H.wait(b,v,1700)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1710 then
        H.wait(b,v,1710)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1720 then
        H.wait(b,v,1720)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1730 then
        H.wait(b,v,1730)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1740 then
        H.wait(b,v,1740)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1750 then
        H.wait(b,v,1750)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=1760 then
        H.wait(b,v,1760)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1770 then
        H.wait(b,v,1770)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=1830 then
        H.wait(b,v,1830)
        H.timeline_spawn(b,0,16,48.0,96.0,0.0,1500,2,2000)
        H.timeline_spawn(b,0,16,336.0,96.0,0.0,1500,2,2000)
    end
    if v.epoch<=1890 then
        H.wait(b,v,1890)
        H.timeline_spawn(b,0,18,32.0,-48.0,0.0,400,1,2000)
        H.timeline_spawn(b,0,18,352.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=1922 then
        H.wait(b,v,1922)
        H.timeline_spawn(b,0,18,64.0,-32.0,0.0,400,0,2000)
        H.timeline_spawn(b,0,18,320.0,-32.0,0.0,400,0,2000)
    end
    if v.epoch<=1954 then
        H.wait(b,v,1954)
        H.timeline_spawn(b,0,18,128.0,-16.0,0.0,400,1,2000)
        H.timeline_spawn(b,0,18,256.0,-16.0,0.0,400,1,2000)
    end
    if v.epoch<=2454 then
        H.wait(b,v,2454)
        H.timeline_spawn(b,0,16,48.0,96.0,0.0,1500,2,2000)
        H.timeline_spawn(b,0,16,336.0,96.0,0.0,1500,2,2000)
    end
    if v.epoch<=2514 then
        H.wait(b,v,2514)
        H.timeline_spawn(b,0,18,48.0,-48.0,0.0,400,1,2000)
        H.timeline_spawn(b,0,18,336.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=2546 then
        H.wait(b,v,2546)
        H.timeline_spawn(b,0,18,128.0,-32.0,0.0,400,0,2000)
        H.timeline_spawn(b,0,18,256.0,-32.0,0.0,400,0,2000)
    end
    if v.epoch<=2578 then
        H.wait(b,v,2578)
        H.timeline_spawn(b,0,18,160.0,-16.0,0.0,400,2,2000)
        H.timeline_spawn(b,0,18,224.0,-16.0,0.0,400,2,2000)
    end
    if v.epoch<=2638 then
        H.wait(b,v,2638)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2648 then
        H.wait(b,v,2648)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2658 then
        H.wait(b,v,2658)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2668 then
        H.wait(b,v,2668)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2678 then
        H.wait(b,v,2678)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2688 then
        H.wait(b,v,2688)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2698 then
        H.wait(b,v,2698)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2708 then
        H.wait(b,v,2708)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2718 then
        H.wait(b,v,2718)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2728 then
        H.wait(b,v,2728)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2738 then
        H.wait(b,v,2738)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2748 then
        H.wait(b,v,2748)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=2758 then
        H.wait(b,v,2758)
        H.timeline_spawn(b,0,7,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2768 then
        H.wait(b,v,2768)
        H.timeline_spawn(b,2,7,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=2778 then
        H.wait(b,v,2778)
        H.timeline_spawn(b,0,18,24.0,-48.0,0.0,400,1,2000)
        H.timeline_spawn(b,0,18,360.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=2810 then
        H.wait(b,v,2810)
        H.timeline_spawn(b,0,18,96.0,-32.0,0.0,400,0,2000)
        H.timeline_spawn(b,0,18,288.0,-32.0,0.0,400,0,2000)
    end
    if v.epoch<=2842 then
        H.wait(b,v,2842)
        H.timeline_spawn(b,0,18,144.0,-16.0,0.0,400,1,2000)
        H.timeline_spawn(b,0,18,240.0,-16.0,0.0,400,1,2000)
    end
    if v.epoch<=3362 then
        H.wait(b,v,3362)
        H.timeline_spawn(b,0,11,96.0,-32.0,0.0,2500,2,2000)
        H.timeline_spawn(b,0,17,286.0,48.0,0.0,1500,1,2000)
        H.timeline_spawn(b,0,17,254.0,48.0,0.0,1500,1,2000)
    end
    if v.epoch<=3512 then
        H.wait(b,v,3512)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3522 then
        H.wait(b,v,3522)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3532 then
        H.wait(b,v,3532)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3542 then
        H.wait(b,v,3542)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3552 then
        H.wait(b,v,3552)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3562 then
        H.wait(b,v,3562)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3572 then
        H.wait(b,v,3572)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3582 then
        H.wait(b,v,3582)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3592 then
        H.wait(b,v,3592)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3602 then
        H.wait(b,v,3602)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3612 then
        H.wait(b,v,3612)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3622 then
        H.wait(b,v,3622)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3632 then
        H.wait(b,v,3632)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3642 then
        H.wait(b,v,3642)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3652 then
        H.wait(b,v,3652)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3662 then
        H.wait(b,v,3662)
        H.timeline_spawn(b,2,3,416.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3762 then
        H.wait(b,v,3762)
        H.timeline_spawn(b,0,11,288.0,-32.0,0.0,2500,2,2000)
        H.timeline_spawn(b,0,17,96.0,48.0,0.0,1500,1,2000)
        H.timeline_spawn(b,0,17,128.0,48.0,0.0,1500,1,2000)
    end
    if v.epoch<=3912 then
        H.wait(b,v,3912)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3922 then
        H.wait(b,v,3922)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3932 then
        H.wait(b,v,3932)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3942 then
        H.wait(b,v,3942)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3952 then
        H.wait(b,v,3952)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3962 then
        H.wait(b,v,3962)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3972 then
        H.wait(b,v,3972)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=3982 then
        H.wait(b,v,3982)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=3992 then
        H.wait(b,v,3992)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=4002 then
        H.wait(b,v,4002)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=4012 then
        H.wait(b,v,4012)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=4022 then
        H.wait(b,v,4022)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=4032 then
        H.wait(b,v,4032)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=4042 then
        H.wait(b,v,4042)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=4052 then
        H.wait(b,v,4052)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,0,500)
    end
    if v.epoch<=4062 then
        H.wait(b,v,4062)
        H.timeline_spawn(b,0,3,-32.0,170.0,0.0,40,1,500)
    end
    if v.epoch<=4282 then
        H.wait(b,v,4282)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4292 then
        H.wait(b,v,4292)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4302 then
        H.wait(b,v,4302)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4312 then
        H.wait(b,v,4312)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4322 then
        H.wait(b,v,4322)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4332 then
        H.wait(b,v,4332)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4342 then
        H.wait(b,v,4342)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4352 then
        H.wait(b,v,4352)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4362 then
        H.wait(b,v,4362)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4372 then
        H.wait(b,v,4372)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4382 then
        H.wait(b,v,4382)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4392 then
        H.wait(b,v,4392)
        H.timeline_spawn(b,0,8,96.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4442 then
        H.wait(b,v,4442)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4452 then
        H.wait(b,v,4452)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4462 then
        H.wait(b,v,4462)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4472 then
        H.wait(b,v,4472)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4482 then
        H.wait(b,v,4482)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4492 then
        H.wait(b,v,4492)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4502 then
        H.wait(b,v,4502)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4512 then
        H.wait(b,v,4512)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4522 then
        H.wait(b,v,4522)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4532 then
        H.wait(b,v,4532)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4542 then
        H.wait(b,v,4542)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4552 then
        H.wait(b,v,4552)
        H.timeline_spawn(b,0,8,196.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4602 then
        H.wait(b,v,4602)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=4612 then
        H.wait(b,v,4612)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=4622 then
        H.wait(b,v,4622)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=4632 then
        H.wait(b,v,4632)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=4642 then
        H.wait(b,v,4642)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=4652 then
        H.wait(b,v,4652)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=4662 then
        H.wait(b,v,4662)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=4672 then
        H.wait(b,v,4672)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=4682 then
        H.wait(b,v,4682)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=4692 then
        H.wait(b,v,4692)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=4702 then
        H.wait(b,v,4702)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=4712 then
        H.wait(b,v,4712)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=4762 then
        H.wait(b,v,4762)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,1,500)
    end
    if v.epoch<=4772 then
        H.wait(b,v,4772)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,0,500)
    end
    if v.epoch<=4782 then
        H.wait(b,v,4782)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,1,500)
    end
    if v.epoch<=4792 then
        H.wait(b,v,4792)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,0,500)
    end
    if v.epoch<=4802 then
        H.wait(b,v,4802)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,1,500)
    end
    if v.epoch<=4812 then
        H.wait(b,v,4812)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,0,500)
    end
    if v.epoch<=4822 then
        H.wait(b,v,4822)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,1,500)
    end
    if v.epoch<=4832 then
        H.wait(b,v,4832)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,0,500)
    end
    if v.epoch<=4842 then
        H.wait(b,v,4842)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,1,500)
    end
    if v.epoch<=4852 then
        H.wait(b,v,4852)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,0,500)
    end
    if v.epoch<=4862 then
        H.wait(b,v,4862)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,1,500)
    end
    if v.epoch<=4872 then
        H.wait(b,v,4872)
        H.timeline_spawn(b,2,9,416.0,128.0,0.0,40,0,500)
    end
    if v.epoch<=4922 then
        H.wait(b,v,4922)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4932 then
        H.wait(b,v,4932)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4942 then
        H.wait(b,v,4942)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4952 then
        H.wait(b,v,4952)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4962 then
        H.wait(b,v,4962)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4972 then
        H.wait(b,v,4972)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=4982 then
        H.wait(b,v,4982)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=4992 then
        H.wait(b,v,4992)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5002 then
        H.wait(b,v,5002)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5012 then
        H.wait(b,v,5012)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5022 then
        H.wait(b,v,5022)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5032 then
        H.wait(b,v,5032)
        H.timeline_spawn(b,0,8,288.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5082 then
        H.wait(b,v,5082)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5092 then
        H.wait(b,v,5092)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5102 then
        H.wait(b,v,5102)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5112 then
        H.wait(b,v,5112)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5122 then
        H.wait(b,v,5122)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5132 then
        H.wait(b,v,5132)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5142 then
        H.wait(b,v,5142)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5152 then
        H.wait(b,v,5152)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5162 then
        H.wait(b,v,5162)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5172 then
        H.wait(b,v,5172)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5182 then
        H.wait(b,v,5182)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,1,500)
    end
    if v.epoch<=5192 then
        H.wait(b,v,5192)
        H.timeline_spawn(b,0,8,188.0,-32.0,0.0,40,0,500)
    end
    if v.epoch<=5242 then
        H.wait(b,v,5242)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,1,500)
    end
    if v.epoch<=5252 then
        H.wait(b,v,5252)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,0,500)
    end
    if v.epoch<=5262 then
        H.wait(b,v,5262)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,1,500)
    end
    if v.epoch<=5272 then
        H.wait(b,v,5272)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,0,500)
    end
    if v.epoch<=5282 then
        H.wait(b,v,5282)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,1,500)
    end
    if v.epoch<=5292 then
        H.wait(b,v,5292)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,0,500)
    end
    if v.epoch<=5302 then
        H.wait(b,v,5302)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,1,500)
    end
    if v.epoch<=5312 then
        H.wait(b,v,5312)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,0,500)
    end
    if v.epoch<=5322 then
        H.wait(b,v,5322)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,1,500)
    end
    if v.epoch<=5332 then
        H.wait(b,v,5332)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,0,500)
    end
    if v.epoch<=5342 then
        H.wait(b,v,5342)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,1,500)
    end
    if v.epoch<=5352 then
        H.wait(b,v,5352)
        H.timeline_spawn(b,2,9,416.0,48.0,0.0,40,0,500)
    end
    if v.epoch<=5402 then
        H.wait(b,v,5402)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5412 then
        H.wait(b,v,5412)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5422 then
        H.wait(b,v,5422)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5432 then
        H.wait(b,v,5432)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5442 then
        H.wait(b,v,5442)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5452 then
        H.wait(b,v,5452)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5462 then
        H.wait(b,v,5462)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5472 then
        H.wait(b,v,5472)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5482 then
        H.wait(b,v,5482)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5492 then
        H.wait(b,v,5492)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5502 then
        H.wait(b,v,5502)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5512 then
        H.wait(b,v,5512)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5712 then
        H.wait(b,v,5712)
        H.timeline_spawn(b,0,11,192.0,-32.0,0.0,2000,2,2000)
    end
    if v.epoch<=5722 then
        H.wait(b,v,5722)
        H.timeline_spawn(b,0,11,64.0,-32.0,0.0,1200,2,2000)
    end
    if v.epoch<=5732 then
        H.wait(b,v,5732)
        H.timeline_spawn(b,0,11,320.0,-32.0,0.0,1200,2,2000)
    end
    if v.epoch<=5822 then
        H.wait(b,v,5822)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5832 then
        H.wait(b,v,5832)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5842 then
        H.wait(b,v,5842)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5852 then
        H.wait(b,v,5852)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5862 then
        H.wait(b,v,5862)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5872 then
        H.wait(b,v,5872)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5882 then
        H.wait(b,v,5882)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5892 then
        H.wait(b,v,5892)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5902 then
        H.wait(b,v,5902)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5912 then
        H.wait(b,v,5912)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5922 then
        H.wait(b,v,5922)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5932 then
        H.wait(b,v,5932)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5942 then
        H.wait(b,v,5942)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=5952 then
        H.wait(b,v,5952)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5962 then
        H.wait(b,v,5962)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5972 then
        H.wait(b,v,5972)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5982 then
        H.wait(b,v,5982)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=5992 then
        H.wait(b,v,5992)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=6002 then
        H.wait(b,v,6002)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=6012 then
        H.wait(b,v,6012)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=6022 then
        H.wait(b,v,6022)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=6032 then
        H.wait(b,v,6032)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=6042 then
        H.wait(b,v,6042)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,1,500)
    end
    if v.epoch<=6052 then
        H.wait(b,v,6052)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,0,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    if v.epoch<=6062 then
        H.wait(b,v,6062)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,40,1,500)
        H.timeline_spawn(b,2,9,352.0,96.0,0.0,40,0,500)
    end
    H.wait(b,v,6562)
    H.erase(b)
end

-- 五面道中·前半：原时间轴 0..3372，66 次创建。
P[5]["road_before"]=function(b,v)
    if v.epoch<=440 then
        H.wait(b,v,440)
        H.timeline_spawn(b,0,0,160.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,0,224.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=690 then
        H.wait(b,v,690)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,200,1,2000)
    end
    if v.epoch<=710 then
        H.wait(b,v,710)
        H.timeline_spawn(b,0,1,-32.0,136.0,0.0,200,1,2000)
    end
    if v.epoch<=730 then
        H.wait(b,v,730)
        H.timeline_spawn(b,0,1,-32.0,144.0,0.0,200,1,2000)
    end
    if v.epoch<=750 then
        H.wait(b,v,750)
        H.timeline_spawn(b,0,1,-32.0,152.0,0.0,200,1,2000)
    end
    if v.epoch<=770 then
        H.wait(b,v,770)
        H.timeline_spawn(b,0,1,-32.0,160.0,0.0,200,1,2000)
    end
    if v.epoch<=790 then
        H.wait(b,v,790)
        H.timeline_spawn(b,0,1,-32.0,168.0,0.0,200,1,2000)
    end
    if v.epoch<=810 then
        H.wait(b,v,810)
        H.timeline_spawn(b,0,1,-32.0,176.0,0.0,200,1,2000)
    end
    if v.epoch<=830 then
        H.wait(b,v,830)
        H.timeline_spawn(b,0,1,-32.0,184.0,0.0,200,1,2000)
    end
    if v.epoch<=850 then
        H.wait(b,v,850)
        H.timeline_spawn(b,0,2,32.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,2,352.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=1042 then
        H.wait(b,v,1042)
        H.timeline_spawn(b,2,1,352.0,128.0,0.0,200,1,2000)
    end
    if v.epoch<=1062 then
        H.wait(b,v,1062)
        H.timeline_spawn(b,2,1,352.0,136.0,0.0,200,1,2000)
    end
    if v.epoch<=1082 then
        H.wait(b,v,1082)
        H.timeline_spawn(b,2,1,352.0,144.0,0.0,200,1,2000)
    end
    if v.epoch<=1102 then
        H.wait(b,v,1102)
        H.timeline_spawn(b,2,1,352.0,152.0,0.0,200,1,2000)
    end
    if v.epoch<=1122 then
        H.wait(b,v,1122)
        H.timeline_spawn(b,2,1,352.0,160.0,0.0,200,1,2000)
    end
    if v.epoch<=1142 then
        H.wait(b,v,1142)
        H.timeline_spawn(b,2,1,352.0,168.0,0.0,200,1,2000)
    end
    if v.epoch<=1162 then
        H.wait(b,v,1162)
        H.timeline_spawn(b,2,1,352.0,176.0,0.0,200,1,2000)
    end
    if v.epoch<=1182 then
        H.wait(b,v,1182)
        H.timeline_spawn(b,2,1,352.0,184.0,0.0,200,1,2000)
    end
    if v.epoch<=1442 then
        H.wait(b,v,1442)
        H.timeline_spawn(b,0,0,128.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,0,256.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=1462 then
        H.wait(b,v,1462)
        H.timeline_spawn(b,0,1,-32.0,160.0,0.0,200,1,2000)
    end
    if v.epoch<=1482 then
        H.wait(b,v,1482)
        H.timeline_spawn(b,0,1,-32.0,168.0,0.0,200,1,2000)
    end
    if v.epoch<=1502 then
        H.wait(b,v,1502)
        H.timeline_spawn(b,0,1,-32.0,176.0,0.0,200,1,2000)
    end
    if v.epoch<=1522 then
        H.wait(b,v,1522)
        H.timeline_spawn(b,0,1,-32.0,184.0,0.0,200,1,2000)
    end
    if v.epoch<=1542 then
        H.wait(b,v,1542)
        H.timeline_spawn(b,0,1,-32.0,192.0,0.0,200,1,2000)
    end
    if v.epoch<=1562 then
        H.wait(b,v,1562)
        H.timeline_spawn(b,0,1,-32.0,200.0,0.0,200,1,2000)
    end
    if v.epoch<=1582 then
        H.wait(b,v,1582)
        H.timeline_spawn(b,0,1,-32.0,208.0,0.0,200,1,2000)
    end
    if v.epoch<=1602 then
        H.wait(b,v,1602)
        H.timeline_spawn(b,0,1,-32.0,216.0,0.0,200,1,2000)
    end
    if v.epoch<=1622 then
        H.wait(b,v,1622)
        H.timeline_spawn(b,2,1,352.0,64.0,0.0,200,1,2000)
    end
    if v.epoch<=1642 then
        H.wait(b,v,1642)
        H.timeline_spawn(b,2,1,352.0,72.0,0.0,200,1,2000)
    end
    if v.epoch<=1662 then
        H.wait(b,v,1662)
        H.timeline_spawn(b,2,1,352.0,80.0,0.0,200,1,2000)
    end
    if v.epoch<=1682 then
        H.wait(b,v,1682)
        H.timeline_spawn(b,2,1,352.0,88.0,0.0,200,1,2000)
    end
    if v.epoch<=1702 then
        H.wait(b,v,1702)
        H.timeline_spawn(b,2,1,352.0,96.0,0.0,200,1,2000)
    end
    if v.epoch<=1722 then
        H.wait(b,v,1722)
        H.timeline_spawn(b,2,1,352.0,104.0,0.0,200,1,2000)
    end
    if v.epoch<=1742 then
        H.wait(b,v,1742)
        H.timeline_spawn(b,2,1,352.0,112.0,0.0,200,1,2000)
    end
    if v.epoch<=1762 then
        H.wait(b,v,1762)
        H.timeline_spawn(b,2,1,352.0,120.0,0.0,200,1,2000)
    end
    if v.epoch<=1782 then
        H.wait(b,v,1782)
        H.timeline_spawn(b,0,2,32.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,2,352.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=1802 then
        H.wait(b,v,1802)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,200,1,2000)
    end
    if v.epoch<=1822 then
        H.wait(b,v,1822)
        H.timeline_spawn(b,0,1,-32.0,72.0,0.0,200,1,2000)
    end
    if v.epoch<=1842 then
        H.wait(b,v,1842)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,200,1,2000)
    end
    if v.epoch<=1862 then
        H.wait(b,v,1862)
        H.timeline_spawn(b,0,1,-32.0,88.0,0.0,200,1,2000)
    end
    if v.epoch<=1882 then
        H.wait(b,v,1882)
        H.timeline_spawn(b,0,1,-32.0,96.0,0.0,200,1,2000)
    end
    if v.epoch<=1902 then
        H.wait(b,v,1902)
        H.timeline_spawn(b,0,1,-32.0,104.0,0.0,200,1,2000)
    end
    if v.epoch<=1922 then
        H.wait(b,v,1922)
        H.timeline_spawn(b,0,1,-32.0,112.0,0.0,200,1,2000)
    end
    if v.epoch<=1942 then
        H.wait(b,v,1942)
        H.timeline_spawn(b,0,1,-32.0,120.0,0.0,200,1,2000)
    end
    if v.epoch<=1962 then
        H.wait(b,v,1962)
        H.timeline_spawn(b,2,1,352.0,208.0,0.0,200,1,2000)
    end
    if v.epoch<=1982 then
        H.wait(b,v,1982)
        H.timeline_spawn(b,2,1,352.0,216.0,0.0,200,1,2000)
    end
    if v.epoch<=2002 then
        H.wait(b,v,2002)
        H.timeline_spawn(b,2,1,352.0,224.0,0.0,200,1,2000)
    end
    if v.epoch<=2022 then
        H.wait(b,v,2022)
        H.timeline_spawn(b,2,1,352.0,232.0,0.0,200,1,2000)
    end
    if v.epoch<=2042 then
        H.wait(b,v,2042)
        H.timeline_spawn(b,2,1,352.0,240.0,0.0,200,1,2000)
    end
    if v.epoch<=2062 then
        H.wait(b,v,2062)
        H.timeline_spawn(b,2,1,352.0,248.0,0.0,200,1,2000)
    end
    if v.epoch<=2082 then
        H.wait(b,v,2082)
        H.timeline_spawn(b,2,1,352.0,256.0,0.0,200,1,2000)
    end
    if v.epoch<=2102 then
        H.wait(b,v,2102)
        H.timeline_spawn(b,2,1,352.0,264.0,0.0,200,1,2000)
    end
    if v.epoch<=2352 then
        H.wait(b,v,2352)
        H.timeline_spawn(b,0,3,32.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,3,352.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=2442 then
        H.wait(b,v,2442)
        H.timeline_spawn(b,0,4,128.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,4,256.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=2532 then
        H.wait(b,v,2532)
        H.timeline_spawn(b,0,5,160.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,5,224.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=2652 then
        H.wait(b,v,2652)
        H.timeline_spawn(b,0,6,192.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=2762 then
        H.wait(b,v,2762)
        H.timeline_spawn(b,0,6,32.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=2872 then
        H.wait(b,v,2872)
        H.timeline_spawn(b,0,6,352.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=2972 then
        H.wait(b,v,2972)
        H.timeline_spawn(b,0,6,160.0,-48.0,0.0,900,2,2000)
    end
    H.wait(b,v,3372)
    H.erase(b)
end

-- 五面道中·后半：原时间轴 3374..7704，161 次创建。
P[5]["road_after"]=function(b,v)
    if v.epoch<=500 then
        H.wait(b,v,500)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=515 then
        H.wait(b,v,515)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=530 then
        H.wait(b,v,530)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=545 then
        H.wait(b,v,545)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=560 then
        H.wait(b,v,560)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=575 then
        H.wait(b,v,575)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=590 then
        H.wait(b,v,590)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=605 then
        H.wait(b,v,605)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=620 then
        H.wait(b,v,620)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=635 then
        H.wait(b,v,635)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=650 then
        H.wait(b,v,650)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=665 then
        H.wait(b,v,665)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,1,2000)
    end
    if v.epoch<=680 then
        H.wait(b,v,680)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=695 then
        H.wait(b,v,695)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=710 then
        H.wait(b,v,710)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=725 then
        H.wait(b,v,725)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=740 then
        H.wait(b,v,740)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,1,2000)
    end
    if v.epoch<=830 then
        H.wait(b,v,830)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=845 then
        H.wait(b,v,845)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=860 then
        H.wait(b,v,860)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=875 then
        H.wait(b,v,875)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=890 then
        H.wait(b,v,890)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=905 then
        H.wait(b,v,905)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=920 then
        H.wait(b,v,920)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=935 then
        H.wait(b,v,935)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=950 then
        H.wait(b,v,950)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=965 then
        H.wait(b,v,965)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=980 then
        H.wait(b,v,980)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=995 then
        H.wait(b,v,995)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=1010 then
        H.wait(b,v,1010)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=1025 then
        H.wait(b,v,1025)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=1040 then
        H.wait(b,v,1040)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1055 then
        H.wait(b,v,1055)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=1145 then
        H.wait(b,v,1145)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=1160 then
        H.wait(b,v,1160)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1175 then
        H.wait(b,v,1175)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1190 then
        H.wait(b,v,1190)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1205 then
        H.wait(b,v,1205)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1220 then
        H.wait(b,v,1220)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=1235 then
        H.wait(b,v,1235)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=1250 then
        H.wait(b,v,1250)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1265 then
        H.wait(b,v,1265)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=1280 then
        H.wait(b,v,1280)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1295 then
        H.wait(b,v,1295)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=1310 then
        H.wait(b,v,1310)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=1325 then
        H.wait(b,v,1325)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=1340 then
        H.wait(b,v,1340)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=1355 then
        H.wait(b,v,1355)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1370 then
        H.wait(b,v,1370)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=1460 then
        H.wait(b,v,1460)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=1475 then
        H.wait(b,v,1475)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1490 then
        H.wait(b,v,1490)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1505 then
        H.wait(b,v,1505)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1520 then
        H.wait(b,v,1520)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1535 then
        H.wait(b,v,1535)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=1550 then
        H.wait(b,v,1550)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=1565 then
        H.wait(b,v,1565)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1580 then
        H.wait(b,v,1580)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=1595 then
        H.wait(b,v,1595)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1610 then
        H.wait(b,v,1610)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=1625 then
        H.wait(b,v,1625)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=1640 then
        H.wait(b,v,1640)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=1655 then
        H.wait(b,v,1655)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=1670 then
        H.wait(b,v,1670)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1685 then
        H.wait(b,v,1685)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=1775 then
        H.wait(b,v,1775)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=1790 then
        H.wait(b,v,1790)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1805 then
        H.wait(b,v,1805)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1820 then
        H.wait(b,v,1820)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1835 then
        H.wait(b,v,1835)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1850 then
        H.wait(b,v,1850)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=1865 then
        H.wait(b,v,1865)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=1880 then
        H.wait(b,v,1880)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=1895 then
        H.wait(b,v,1895)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=1910 then
        H.wait(b,v,1910)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=1925 then
        H.wait(b,v,1925)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=1940 then
        H.wait(b,v,1940)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=1955 then
        H.wait(b,v,1955)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=1970 then
        H.wait(b,v,1970)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=1985 then
        H.wait(b,v,1985)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2000 then
        H.wait(b,v,2000)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=2090 then
        H.wait(b,v,2090)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=2105 then
        H.wait(b,v,2105)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2120 then
        H.wait(b,v,2120)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2135 then
        H.wait(b,v,2135)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2150 then
        H.wait(b,v,2150)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2165 then
        H.wait(b,v,2165)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=2180 then
        H.wait(b,v,2180)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=2195 then
        H.wait(b,v,2195)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2210 then
        H.wait(b,v,2210)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=2225 then
        H.wait(b,v,2225)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2240 then
        H.wait(b,v,2240)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=2255 then
        H.wait(b,v,2255)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=2270 then
        H.wait(b,v,2270)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=2285 then
        H.wait(b,v,2285)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=2300 then
        H.wait(b,v,2300)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2315 then
        H.wait(b,v,2315)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=2405 then
        H.wait(b,v,2405)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=2420 then
        H.wait(b,v,2420)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2435 then
        H.wait(b,v,2435)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2450 then
        H.wait(b,v,2450)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2465 then
        H.wait(b,v,2465)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2480 then
        H.wait(b,v,2480)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=2495 then
        H.wait(b,v,2495)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=2510 then
        H.wait(b,v,2510)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2525 then
        H.wait(b,v,2525)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=2540 then
        H.wait(b,v,2540)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2555 then
        H.wait(b,v,2555)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=2570 then
        H.wait(b,v,2570)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=2585 then
        H.wait(b,v,2585)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=2600 then
        H.wait(b,v,2600)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=2615 then
        H.wait(b,v,2615)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2630 then
        H.wait(b,v,2630)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=2720 then
        H.wait(b,v,2720)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=2735 then
        H.wait(b,v,2735)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2750 then
        H.wait(b,v,2750)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2765 then
        H.wait(b,v,2765)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2780 then
        H.wait(b,v,2780)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2795 then
        H.wait(b,v,2795)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=2810 then
        H.wait(b,v,2810)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=2825 then
        H.wait(b,v,2825)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2840 then
        H.wait(b,v,2840)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=2855 then
        H.wait(b,v,2855)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=2870 then
        H.wait(b,v,2870)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=2885 then
        H.wait(b,v,2885)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=2900 then
        H.wait(b,v,2900)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=2915 then
        H.wait(b,v,2915)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=2930 then
        H.wait(b,v,2930)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=2945 then
        H.wait(b,v,2945)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=3035 then
        H.wait(b,v,3035)
        H.timeline_spawn(b,2,1,416.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=3050 then
        H.wait(b,v,3050)
        H.timeline_spawn(b,0,9,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=3065 then
        H.wait(b,v,3065)
        H.timeline_spawn(b,2,10,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=3080 then
        H.wait(b,v,3080)
        H.timeline_spawn(b,0,11,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=3095 then
        H.wait(b,v,3095)
        H.timeline_spawn(b,2,9,416.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=3110 then
        H.wait(b,v,3110)
        H.timeline_spawn(b,0,10,-32.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=3125 then
        H.wait(b,v,3125)
        H.timeline_spawn(b,2,11,416.0,96.0,0.0,150,0,2000)
    end
    if v.epoch<=3140 then
        H.wait(b,v,3140)
        H.timeline_spawn(b,0,1,-32.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=3155 then
        H.wait(b,v,3155)
        H.timeline_spawn(b,2,1,416.0,64.0,0.0,150,1,2000)
    end
    if v.epoch<=3170 then
        H.wait(b,v,3170)
        H.timeline_spawn(b,0,11,-32.0,96.0,0.0,150,1,2000)
    end
    if v.epoch<=3185 then
        H.wait(b,v,3185)
        H.timeline_spawn(b,2,9,416.0,72.0,0.0,150,0,2000)
    end
    if v.epoch<=3200 then
        H.wait(b,v,3200)
        H.timeline_spawn(b,0,10,-32.0,80.0,0.0,150,0,2000)
    end
    if v.epoch<=3215 then
        H.wait(b,v,3215)
        H.timeline_spawn(b,2,9,416.0,32.0,0.0,150,1,2000)
    end
    if v.epoch<=3230 then
        H.wait(b,v,3230)
        H.timeline_spawn(b,0,1,-32.0,80.0,0.0,150,1,2000)
    end
    if v.epoch<=3245 then
        H.wait(b,v,3245)
        H.timeline_spawn(b,2,11,416.0,64.0,0.0,150,0,2000)
    end
    if v.epoch<=3260 then
        H.wait(b,v,3260)
        H.timeline_spawn(b,0,10,-32.0,128.0,0.0,150,0,2000)
    end
    if v.epoch<=3460 then
        H.wait(b,v,3460)
        H.timeline_spawn(b,0,2,32.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,2,352.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3550 then
        H.wait(b,v,3550)
        H.timeline_spawn(b,0,2,64.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,2,320.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3640 then
        H.wait(b,v,3640)
        H.timeline_spawn(b,0,2,96.0,-48.0,0.0,900,2,2000)
        H.timeline_spawn(b,0,2,288.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3840 then
        H.wait(b,v,3840)
        H.timeline_spawn(b,0,2,32.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3850 then
        H.wait(b,v,3850)
        H.timeline_spawn(b,0,2,352.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3860 then
        H.wait(b,v,3860)
        H.timeline_spawn(b,0,2,64.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3870 then
        H.wait(b,v,3870)
        H.timeline_spawn(b,0,2,320.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3880 then
        H.wait(b,v,3880)
        H.timeline_spawn(b,0,2,96.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3890 then
        H.wait(b,v,3890)
        H.timeline_spawn(b,0,2,288.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3900 then
        H.wait(b,v,3900)
        H.timeline_spawn(b,0,2,128.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3910 then
        H.wait(b,v,3910)
        H.timeline_spawn(b,0,2,256.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3920 then
        H.wait(b,v,3920)
        H.timeline_spawn(b,0,2,144.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=3930 then
        H.wait(b,v,3930)
        H.timeline_spawn(b,0,2,240.0,-48.0,0.0,900,2,2000)
    end
    H.wait(b,v,4330)
    H.erase(b)
end

-- 六面道中·前半：原时间轴 0..2564，124 次创建。
P[6]["road_before"]=function(b,v)
    if v.epoch<=440 then
        H.wait(b,v,440)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=448 then
        H.wait(b,v,448)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=456 then
        H.wait(b,v,456)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=464 then
        H.wait(b,v,464)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=472 then
        H.wait(b,v,472)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=480 then
        H.wait(b,v,480)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=488 then
        H.wait(b,v,488)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=496 then
        H.wait(b,v,496)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=504 then
        H.wait(b,v,504)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=512 then
        H.wait(b,v,512)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=520 then
        H.wait(b,v,520)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=528 then
        H.wait(b,v,528)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=536 then
        H.wait(b,v,536)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=544 then
        H.wait(b,v,544)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=552 then
        H.wait(b,v,552)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=560 then
        H.wait(b,v,560)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=568 then
        H.wait(b,v,568)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=576 then
        H.wait(b,v,576)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=584 then
        H.wait(b,v,584)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=592 then
        H.wait(b,v,592)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=600 then
        H.wait(b,v,600)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=608 then
        H.wait(b,v,608)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=616 then
        H.wait(b,v,616)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=624 then
        H.wait(b,v,624)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=632 then
        H.wait(b,v,632)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=640 then
        H.wait(b,v,640)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=648 then
        H.wait(b,v,648)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=656 then
        H.wait(b,v,656)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=664 then
        H.wait(b,v,664)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=672 then
        H.wait(b,v,672)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=680 then
        H.wait(b,v,680)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=688 then
        H.wait(b,v,688)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=696 then
        H.wait(b,v,696)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=704 then
        H.wait(b,v,704)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=712 then
        H.wait(b,v,712)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=720 then
        H.wait(b,v,720)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=728 then
        H.wait(b,v,728)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=736 then
        H.wait(b,v,736)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=744 then
        H.wait(b,v,744)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=752 then
        H.wait(b,v,752)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=760 then
        H.wait(b,v,760)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=768 then
        H.wait(b,v,768)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=776 then
        H.wait(b,v,776)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=784 then
        H.wait(b,v,784)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=792 then
        H.wait(b,v,792)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=800 then
        H.wait(b,v,800)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=808 then
        H.wait(b,v,808)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=816 then
        H.wait(b,v,816)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=824 then
        H.wait(b,v,824)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=832 then
        H.wait(b,v,832)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=840 then
        H.wait(b,v,840)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=848 then
        H.wait(b,v,848)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=856 then
        H.wait(b,v,856)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=864 then
        H.wait(b,v,864)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=872 then
        H.wait(b,v,872)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=880 then
        H.wait(b,v,880)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=888 then
        H.wait(b,v,888)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=896 then
        H.wait(b,v,896)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=904 then
        H.wait(b,v,904)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=912 then
        H.wait(b,v,912)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=920 then
        H.wait(b,v,920)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=928 then
        H.wait(b,v,928)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=936 then
        H.wait(b,v,936)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=944 then
        H.wait(b,v,944)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=952 then
        H.wait(b,v,952)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=960 then
        H.wait(b,v,960)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=968 then
        H.wait(b,v,968)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=976 then
        H.wait(b,v,976)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=984 then
        H.wait(b,v,984)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=992 then
        H.wait(b,v,992)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1000 then
        H.wait(b,v,1000)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1008 then
        H.wait(b,v,1008)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1016 then
        H.wait(b,v,1016)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1024 then
        H.wait(b,v,1024)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1032 then
        H.wait(b,v,1032)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1040 then
        H.wait(b,v,1040)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1048 then
        H.wait(b,v,1048)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1056 then
        H.wait(b,v,1056)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1064 then
        H.wait(b,v,1064)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1072 then
        H.wait(b,v,1072)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1080 then
        H.wait(b,v,1080)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1088 then
        H.wait(b,v,1088)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1096 then
        H.wait(b,v,1096)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1104 then
        H.wait(b,v,1104)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1112 then
        H.wait(b,v,1112)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1120 then
        H.wait(b,v,1120)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1128 then
        H.wait(b,v,1128)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1136 then
        H.wait(b,v,1136)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1144 then
        H.wait(b,v,1144)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1152 then
        H.wait(b,v,1152)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1160 then
        H.wait(b,v,1160)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1168 then
        H.wait(b,v,1168)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1176 then
        H.wait(b,v,1176)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1184 then
        H.wait(b,v,1184)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1192 then
        H.wait(b,v,1192)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1200 then
        H.wait(b,v,1200)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1208 then
        H.wait(b,v,1208)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1216 then
        H.wait(b,v,1216)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1224 then
        H.wait(b,v,1224)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1232 then
        H.wait(b,v,1232)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1240 then
        H.wait(b,v,1240)
        H.timeline_spawn(b,0,1,-32.0,128.0,0.0,80,0,1000)
    end
    if v.epoch<=1248 then
        H.wait(b,v,1248)
        H.timeline_spawn(b,0,3,-32.0,192.0,0.0,80,1,1000)
    end
    if v.epoch<=1256 then
        H.wait(b,v,1256)
        H.timeline_spawn(b,2,2,416.0,128.0,0.0,80,1,1000)
    end
    if v.epoch<=1264 then
        H.wait(b,v,1264)
        H.timeline_spawn(b,2,4,416.0,192.0,0.0,80,0,1000)
    end
    if v.epoch<=1274 then
        H.wait(b,v,1274)
        H.timeline_spawn(b,0,0,160.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=1284 then
        H.wait(b,v,1284)
        H.timeline_spawn(b,0,0,160.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=1294 then
        H.wait(b,v,1294)
        H.timeline_spawn(b,0,0,160.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=1304 then
        H.wait(b,v,1304)
        H.timeline_spawn(b,0,0,160.0,-48.0,0.0,900,2,2000)
    end
    if v.epoch<=1544 then
        H.wait(b,v,1544)
        H.timeline_spawn(b,2,5,416.0,92.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,5,-32.0,92.0,0.0,500,2,1000)
    end
    if v.epoch<=1664 then
        H.wait(b,v,1664)
        H.timeline_spawn(b,0,7,128.0,-32.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,7,256.0,-32.0,0.0,500,2,1000)
    end
    if v.epoch<=1784 then
        H.wait(b,v,1784)
        H.timeline_spawn(b,2,5,416.0,144.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,5,-32.0,144.0,0.0,500,2,1000)
    end
    if v.epoch<=2084 then
        H.wait(b,v,2084)
        H.timeline_spawn(b,2,5,416.0,92.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,5,-32.0,92.0,0.0,500,2,1000)
    end
    if v.epoch<=2104 then
        H.wait(b,v,2104)
        H.timeline_spawn(b,2,5,416.0,192.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,5,-32.0,192.0,0.0,500,2,1000)
    end
    if v.epoch<=2124 then
        H.wait(b,v,2124)
        H.timeline_spawn(b,2,5,416.0,128.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,5,-32.0,128.0,0.0,500,2,1000)
    end
    if v.epoch<=2144 then
        H.wait(b,v,2144)
        H.timeline_spawn(b,2,5,416.0,64.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,5,-32.0,64.0,0.0,500,2,1000)
    end
    if v.epoch<=2164 then
        H.wait(b,v,2164)
        H.timeline_spawn(b,2,5,416.0,48.0,0.0,500,2,1000)
        H.timeline_spawn(b,0,5,-32.0,48.0,0.0,500,2,1000)
    end
    H.wait(b,v,2564)
    H.erase(b)
end

-- 六面道中·后半（入场等待）：原时间轴 2567..3167，0 次创建。
P[6]["road_after"]=function(b,v)
    H.wait(b,v,600)
    H.erase(b)
end

-- Extra道中·前半：原时间轴 0..4740，132 次创建。
P[7]["road_before"]=function(b,v)
    if v.epoch<=440 then
        H.wait(b,v,440)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=460 then
        H.wait(b,v,460)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=480 then
        H.wait(b,v,480)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=500 then
        H.wait(b,v,500)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=520 then
        H.wait(b,v,520)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=540 then
        H.wait(b,v,540)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=560 then
        H.wait(b,v,560)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=580 then
        H.wait(b,v,580)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=600 then
        H.wait(b,v,600)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,2,2000)
    end
    if v.epoch<=640 then
        H.wait(b,v,640)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=660 then
        H.wait(b,v,660)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=680 then
        H.wait(b,v,680)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=700 then
        H.wait(b,v,700)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=720 then
        H.wait(b,v,720)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=740 then
        H.wait(b,v,740)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=760 then
        H.wait(b,v,760)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=780 then
        H.wait(b,v,780)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=800 then
        H.wait(b,v,800)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,2,2000)
    end
    if v.epoch<=840 then
        H.wait(b,v,840)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=860 then
        H.wait(b,v,860)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=880 then
        H.wait(b,v,880)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=900 then
        H.wait(b,v,900)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=920 then
        H.wait(b,v,920)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=940 then
        H.wait(b,v,940)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=960 then
        H.wait(b,v,960)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=980 then
        H.wait(b,v,980)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1000 then
        H.wait(b,v,1000)
        H.timeline_spawn(b,0,0,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,0,64.0,-48.0,0.0,20,2,2000)
    end
    if v.epoch<=1040 then
        H.wait(b,v,1040)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1060 then
        H.wait(b,v,1060)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1080 then
        H.wait(b,v,1080)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1100 then
        H.wait(b,v,1100)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1120 then
        H.wait(b,v,1120)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1140 then
        H.wait(b,v,1140)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1160 then
        H.wait(b,v,1160)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1180 then
        H.wait(b,v,1180)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1200 then
        H.wait(b,v,1200)
        H.timeline_spawn(b,2,0,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,0,352.0,-48.0,0.0,20,2,2000)
    end
    if v.epoch<=1360 then
        H.wait(b,v,1360)
        H.timeline_spawn(b,0,5,368.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1380 then
        H.wait(b,v,1380)
        H.timeline_spawn(b,0,5,336.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1400 then
        H.wait(b,v,1400)
        H.timeline_spawn(b,0,5,304.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1420 then
        H.wait(b,v,1420)
        H.timeline_spawn(b,0,5,272.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1440 then
        H.wait(b,v,1440)
        H.timeline_spawn(b,0,5,240.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1460 then
        H.wait(b,v,1460)
        H.timeline_spawn(b,0,5,208.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1480 then
        H.wait(b,v,1480)
        H.timeline_spawn(b,0,5,176.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1500 then
        H.wait(b,v,1500)
        H.timeline_spawn(b,0,5,144.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1520 then
        H.wait(b,v,1520)
        H.timeline_spawn(b,0,5,112.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1540 then
        H.wait(b,v,1540)
        H.timeline_spawn(b,0,5,80.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1560 then
        H.wait(b,v,1560)
        H.timeline_spawn(b,0,5,48.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1580 then
        H.wait(b,v,1580)
        H.timeline_spawn(b,0,5,16.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1600 then
        H.wait(b,v,1600)
        H.timeline_spawn(b,0,5,-16.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1630 then
        H.wait(b,v,1630)
        H.timeline_spawn(b,0,5,368.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1650 then
        H.wait(b,v,1650)
        H.timeline_spawn(b,0,5,336.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1670 then
        H.wait(b,v,1670)
        H.timeline_spawn(b,0,5,304.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1690 then
        H.wait(b,v,1690)
        H.timeline_spawn(b,0,5,272.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1710 then
        H.wait(b,v,1710)
        H.timeline_spawn(b,0,5,240.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1730 then
        H.wait(b,v,1730)
        H.timeline_spawn(b,0,5,208.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1750 then
        H.wait(b,v,1750)
        H.timeline_spawn(b,0,5,176.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1770 then
        H.wait(b,v,1770)
        H.timeline_spawn(b,0,5,144.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1790 then
        H.wait(b,v,1790)
        H.timeline_spawn(b,0,5,112.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1810 then
        H.wait(b,v,1810)
        H.timeline_spawn(b,0,5,80.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1830 then
        H.wait(b,v,1830)
        H.timeline_spawn(b,0,5,48.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1850 then
        H.wait(b,v,1850)
        H.timeline_spawn(b,0,5,16.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1870 then
        H.wait(b,v,1870)
        H.timeline_spawn(b,0,5,-16.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=1950 then
        H.wait(b,v,1950)
        H.timeline_spawn(b,0,5,16.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1970 then
        H.wait(b,v,1970)
        H.timeline_spawn(b,0,5,48.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=1990 then
        H.wait(b,v,1990)
        H.timeline_spawn(b,0,5,80.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2010 then
        H.wait(b,v,2010)
        H.timeline_spawn(b,0,5,112.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2030 then
        H.wait(b,v,2030)
        H.timeline_spawn(b,0,5,144.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2050 then
        H.wait(b,v,2050)
        H.timeline_spawn(b,0,5,176.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2070 then
        H.wait(b,v,2070)
        H.timeline_spawn(b,0,5,208.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2090 then
        H.wait(b,v,2090)
        H.timeline_spawn(b,0,5,240.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2110 then
        H.wait(b,v,2110)
        H.timeline_spawn(b,0,5,272.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2130 then
        H.wait(b,v,2130)
        H.timeline_spawn(b,0,5,304.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2150 then
        H.wait(b,v,2150)
        H.timeline_spawn(b,0,5,336.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2170 then
        H.wait(b,v,2170)
        H.timeline_spawn(b,0,5,368.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2190 then
        H.wait(b,v,2190)
        H.timeline_spawn(b,0,5,400.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2220 then
        H.wait(b,v,2220)
        H.timeline_spawn(b,0,5,16.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2240 then
        H.wait(b,v,2240)
        H.timeline_spawn(b,0,5,48.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2260 then
        H.wait(b,v,2260)
        H.timeline_spawn(b,0,5,80.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2280 then
        H.wait(b,v,2280)
        H.timeline_spawn(b,0,5,112.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2300 then
        H.wait(b,v,2300)
        H.timeline_spawn(b,0,5,144.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2320 then
        H.wait(b,v,2320)
        H.timeline_spawn(b,0,5,176.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2340 then
        H.wait(b,v,2340)
        H.timeline_spawn(b,0,5,208.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2360 then
        H.wait(b,v,2360)
        H.timeline_spawn(b,0,5,240.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2380 then
        H.wait(b,v,2380)
        H.timeline_spawn(b,0,5,272.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2400 then
        H.wait(b,v,2400)
        H.timeline_spawn(b,0,5,304.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2420 then
        H.wait(b,v,2420)
        H.timeline_spawn(b,0,5,336.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2440 then
        H.wait(b,v,2440)
        H.timeline_spawn(b,0,5,368.0,-48.0,0.0,100,1,2000)
    end
    if v.epoch<=2460 then
        H.wait(b,v,2460)
        H.timeline_spawn(b,0,5,400.0,-48.0,0.0,100,2,2000)
    end
    if v.epoch<=2660 then
        H.wait(b,v,2660)
        H.timeline_spawn(b,0,1,192.0,-48.0,0.0,800,2,2000)
    end
    if v.epoch<=2780 then
        H.wait(b,v,2780)
        H.timeline_spawn(b,0,1,32.0,-48.0,0.0,600,2,2000)
        H.timeline_spawn(b,0,1,352.0,-48.0,0.0,600,2,2000)
    end
    if v.epoch<=2900 then
        H.wait(b,v,2900)
        H.timeline_spawn(b,0,2,192.0,-48.0,0.0,800,2,2000)
    end
    if v.epoch<=3020 then
        H.wait(b,v,3020)
        H.timeline_spawn(b,0,3,128.0,-48.0,0.0,800,2,2000)
    end
    if v.epoch<=3140 then
        H.wait(b,v,3140)
        H.timeline_spawn(b,0,2,256.0,-48.0,0.0,800,2,2000)
    end
    if v.epoch<=3260 then
        H.wait(b,v,3260)
        H.timeline_spawn(b,0,3,192.0,-48.0,0.0,800,2,2000)
    end
    if v.epoch<=3740 then
        H.wait(b,v,3740)
        H.timeline_spawn(b,0,4,192.0,-16.0,0.0,500,2,2000)
    end
    H.wait(b,v,4740)
    H.erase(b)
end

-- Extra道中·后半：原时间轴 4743..8593，206 次创建。
P[7]["road_after"]=function(b,v)
    if v.epoch<=120 then
        H.wait(b,v,120)
        H.timeline_spawn(b,0,6,64.0,-48.0,0.0,400,2,2000)
    end
    if v.epoch<=150 then
        H.wait(b,v,150)
        H.timeline_spawn(b,2,6,320.0,-48.0,0.0,400,2,2000)
    end
    if v.epoch<=180 then
        H.wait(b,v,180)
        H.timeline_spawn(b,0,6,192.0,-48.0,0.0,400,2,2000)
    end
    if v.epoch<=270 then
        H.wait(b,v,270)
        H.timeline_spawn(b,0,7,-32.0,96.0,0.0,400,1,2000)
    end
    if v.epoch<=280 then
        H.wait(b,v,280)
        H.timeline_spawn(b,2,7,416.0,96.0,0.0,400,1,2000)
    end
    if v.epoch<=290 then
        H.wait(b,v,290)
        H.timeline_spawn(b,2,6,256.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=300 then
        H.wait(b,v,300)
        H.timeline_spawn(b,0,6,128.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=390 then
        H.wait(b,v,390)
        H.timeline_spawn(b,2,7,416.0,128.0,0.0,400,1,2000)
    end
    if v.epoch<=400 then
        H.wait(b,v,400)
        H.timeline_spawn(b,0,7,-32.0,128.0,0.0,400,1,2000)
    end
    if v.epoch<=410 then
        H.wait(b,v,410)
        H.timeline_spawn(b,2,7,416.0,64.0,0.0,400,1,2000)
    end
    if v.epoch<=420 then
        H.wait(b,v,420)
        H.timeline_spawn(b,0,7,-32.0,64.0,0.0,400,1,2000)
    end
    if v.epoch<=430 then
        H.wait(b,v,430)
        H.timeline_spawn(b,2,6,240.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=440 then
        H.wait(b,v,440)
        H.timeline_spawn(b,0,6,144.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=500 then
        H.wait(b,v,500)
        H.timeline_spawn(b,2,6,224.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=505 then
        H.wait(b,v,505)
        H.timeline_spawn(b,0,6,160.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=510 then
        H.wait(b,v,510)
        H.timeline_spawn(b,2,6,256.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=515 then
        H.wait(b,v,515)
        H.timeline_spawn(b,0,6,128.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=520 then
        H.wait(b,v,520)
        H.timeline_spawn(b,2,6,288.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=525 then
        H.wait(b,v,525)
        H.timeline_spawn(b,0,6,96.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=530 then
        H.wait(b,v,530)
        H.timeline_spawn(b,2,6,320.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=535 then
        H.wait(b,v,535)
        H.timeline_spawn(b,0,6,64.0,-48.0,0.0,400,1,2000)
    end
    if v.epoch<=565 then
        H.wait(b,v,565)
        H.timeline_spawn(b,2,7,416.0,96.0,0.0,400,1,2000)
    end
    if v.epoch<=570 then
        H.wait(b,v,570)
        H.timeline_spawn(b,0,7,-32.0,96.0,0.0,400,1,2000)
    end
    if v.epoch<=575 then
        H.wait(b,v,575)
        H.timeline_spawn(b,2,7,416.0,128.0,0.0,400,1,2000)
    end
    if v.epoch<=580 then
        H.wait(b,v,580)
        H.timeline_spawn(b,0,7,-32.0,128.0,0.0,400,1,2000)
    end
    if v.epoch<=585 then
        H.wait(b,v,585)
        H.timeline_spawn(b,2,7,416.0,160.0,0.0,400,1,2000)
    end
    if v.epoch<=590 then
        H.wait(b,v,590)
        H.timeline_spawn(b,0,7,-32.0,160.0,0.0,400,1,2000)
    end
    if v.epoch<=595 then
        H.wait(b,v,595)
        H.timeline_spawn(b,2,7,416.0,192.0,0.0,400,1,2000)
    end
    if v.epoch<=600 then
        H.wait(b,v,600)
        H.timeline_spawn(b,0,7,-32.0,192.0,0.0,400,1,2000)
    end
    if v.epoch<=605 then
        H.wait(b,v,605)
        H.timeline_spawn(b,2,7,416.0,224.0,0.0,400,1,2000)
    end
    if v.epoch<=610 then
        H.wait(b,v,610)
        H.timeline_spawn(b,0,7,-32.0,224.0,0.0,400,1,2000)
    end
    if v.epoch<=730 then
        H.wait(b,v,730)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=745 then
        H.wait(b,v,745)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=760 then
        H.wait(b,v,760)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=775 then
        H.wait(b,v,775)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=790 then
        H.wait(b,v,790)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=805 then
        H.wait(b,v,805)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=820 then
        H.wait(b,v,820)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=835 then
        H.wait(b,v,835)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=850 then
        H.wait(b,v,850)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,2,2000)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=865 then
        H.wait(b,v,865)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=880 then
        H.wait(b,v,880)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=895 then
        H.wait(b,v,895)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=910 then
        H.wait(b,v,910)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=925 then
        H.wait(b,v,925)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=940 then
        H.wait(b,v,940)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=955 then
        H.wait(b,v,955)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=970 then
        H.wait(b,v,970)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,2,2000)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=980 then
        H.wait(b,v,980)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=990 then
        H.wait(b,v,990)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1000 then
        H.wait(b,v,1000)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1010 then
        H.wait(b,v,1010)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1020 then
        H.wait(b,v,1020)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1030 then
        H.wait(b,v,1030)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1040 then
        H.wait(b,v,1040)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1050 then
        H.wait(b,v,1050)
        H.timeline_spawn(b,0,8,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,8,64.0,-48.0,0.0,20,2,2000)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1060 then
        H.wait(b,v,1060)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1070 then
        H.wait(b,v,1070)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1080 then
        H.wait(b,v,1080)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1090 then
        H.wait(b,v,1090)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1100 then
        H.wait(b,v,1100)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1110 then
        H.wait(b,v,1110)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=1120 then
        H.wait(b,v,1120)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=1130 then
        H.wait(b,v,1130)
        H.timeline_spawn(b,2,8,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,8,352.0,-48.0,0.0,20,2,2000)
    end
    if v.epoch<=1250 then
        H.wait(b,v,1250)
        H.timeline_spawn(b,4,10,-999.0,32.0,0.0,800,1,2000)
    end
    if v.epoch<=1310 then
        H.wait(b,v,1310)
        H.timeline_spawn(b,4,11,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=1370 then
        H.wait(b,v,1370)
        H.timeline_spawn(b,4,12,-999.0,80.0,0.0,800,1,2000)
    end
    if v.epoch<=1430 then
        H.wait(b,v,1430)
        H.timeline_spawn(b,4,13,-999.0,48.0,0.0,800,1,2000)
    end
    if v.epoch<=1490 then
        H.wait(b,v,1490)
        H.timeline_spawn(b,4,14,-999.0,128.0,0.0,800,1,2000)
    end
    if v.epoch<=1610 then
        H.wait(b,v,1610)
        H.timeline_spawn(b,4,10,-999.0,96.0,0.0,800,1,2000)
    end
    if v.epoch<=1660 then
        H.wait(b,v,1660)
        H.timeline_spawn(b,4,11,-999.0,80.0,0.0,800,1,2000)
    end
    if v.epoch<=1710 then
        H.wait(b,v,1710)
        H.timeline_spawn(b,4,12,-999.0,32.0,0.0,800,1,2000)
    end
    if v.epoch<=1760 then
        H.wait(b,v,1760)
        H.timeline_spawn(b,4,13,-999.0,48.0,0.0,800,1,2000)
    end
    if v.epoch<=1810 then
        H.wait(b,v,1810)
        H.timeline_spawn(b,4,14,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=1930 then
        H.wait(b,v,1930)
        H.timeline_spawn(b,4,10,-999.0,32.0,0.0,800,1,2000)
    end
    if v.epoch<=1970 then
        H.wait(b,v,1970)
        H.timeline_spawn(b,4,11,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=2010 then
        H.wait(b,v,2010)
        H.timeline_spawn(b,4,12,-999.0,80.0,0.0,800,1,2000)
    end
    if v.epoch<=2050 then
        H.wait(b,v,2050)
        H.timeline_spawn(b,4,13,-999.0,128.0,0.0,800,1,2000)
    end
    if v.epoch<=2090 then
        H.wait(b,v,2090)
        H.timeline_spawn(b,4,14,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=2210 then
        H.wait(b,v,2210)
        H.timeline_spawn(b,4,10,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=2240 then
        H.wait(b,v,2240)
        H.timeline_spawn(b,4,11,-999.0,128.0,0.0,800,1,2000)
    end
    if v.epoch<=2270 then
        H.wait(b,v,2270)
        H.timeline_spawn(b,4,12,-999.0,96.0,0.0,800,1,2000)
    end
    if v.epoch<=2300 then
        H.wait(b,v,2300)
        H.timeline_spawn(b,4,13,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=2330 then
        H.wait(b,v,2330)
        H.timeline_spawn(b,4,14,-999.0,32.0,0.0,800,1,2000)
    end
    if v.epoch<=2630 then
        H.wait(b,v,2630)
        H.timeline_spawn(b,4,10,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=2640 then
        H.wait(b,v,2640)
        H.timeline_spawn(b,4,11,-999.0,128.0,0.0,800,1,2000)
    end
    if v.epoch<=2650 then
        H.wait(b,v,2650)
        H.timeline_spawn(b,4,12,-999.0,96.0,0.0,800,1,2000)
    end
    if v.epoch<=2660 then
        H.wait(b,v,2660)
        H.timeline_spawn(b,4,13,-999.0,64.0,0.0,800,1,2000)
    end
    if v.epoch<=2670 then
        H.wait(b,v,2670)
        H.timeline_spawn(b,4,14,-999.0,32.0,0.0,800,1,2000)
    end
    if v.epoch<=2680 then
        H.wait(b,v,2680)
        H.timeline_spawn(b,4,10,-999.0,128.0,0.0,800,1,2000)
    end
    if v.epoch<=2690 then
        H.wait(b,v,2690)
        H.timeline_spawn(b,4,13,-999.0,80.0,0.0,800,1,2000)
    end
    if v.epoch<=2700 then
        H.wait(b,v,2700)
        H.timeline_spawn(b,4,14,-999.0,70.0,0.0,800,1,2000)
    end
    if v.epoch<=2710 then
        H.wait(b,v,2710)
        H.timeline_spawn(b,4,10,-999.0,16.0,0.0,800,1,2000)
    end
    if v.epoch<=2720 then
        H.wait(b,v,2720)
        H.timeline_spawn(b,4,11,-999.0,96.0,0.0,800,1,2000)
    end
    if v.epoch<=2730 then
        H.wait(b,v,2730)
        H.timeline_spawn(b,4,12,-999.0,80.0,0.0,800,1,2000)
    end
    if v.epoch<=3050 then
        H.wait(b,v,3050)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3065 then
        H.wait(b,v,3065)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3080 then
        H.wait(b,v,3080)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3095 then
        H.wait(b,v,3095)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3110 then
        H.wait(b,v,3110)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3125 then
        H.wait(b,v,3125)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3140 then
        H.wait(b,v,3140)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3155 then
        H.wait(b,v,3155)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3170 then
        H.wait(b,v,3170)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,2,2000)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3185 then
        H.wait(b,v,3185)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3200 then
        H.wait(b,v,3200)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3215 then
        H.wait(b,v,3215)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3230 then
        H.wait(b,v,3230)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3245 then
        H.wait(b,v,3245)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3260 then
        H.wait(b,v,3260)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3275 then
        H.wait(b,v,3275)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3290 then
        H.wait(b,v,3290)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,2,2000)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3300 then
        H.wait(b,v,3300)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3310 then
        H.wait(b,v,3310)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3320 then
        H.wait(b,v,3320)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3330 then
        H.wait(b,v,3330)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3340 then
        H.wait(b,v,3340)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3350 then
        H.wait(b,v,3350)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3360 then
        H.wait(b,v,3360)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3370 then
        H.wait(b,v,3370)
        H.timeline_spawn(b,0,9,32.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,0,9,64.0,-48.0,0.0,20,2,2000)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3380 then
        H.wait(b,v,3380)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3390 then
        H.wait(b,v,3390)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3400 then
        H.wait(b,v,3400)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3410 then
        H.wait(b,v,3410)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3420 then
        H.wait(b,v,3420)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3430 then
        H.wait(b,v,3430)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,0,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,0,2000)
    end
    if v.epoch<=3440 then
        H.wait(b,v,3440)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,1,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,1,2000)
    end
    if v.epoch<=3450 then
        H.wait(b,v,3450)
        H.timeline_spawn(b,2,9,320.0,-48.0,0.0,20,2,2000)
        H.timeline_spawn(b,2,9,352.0,-48.0,0.0,20,5,2000)
    end
    H.wait(b,v,3850)
    H.erase(b)
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

    local meta={id=4000,group=18,stage=1,sub="road_before",road=true,part="before",frozen=false,base=0,ending=2008,timeout=2008,epoch=0,invul=2008,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=2}

    boss.Define("18a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("一面道中·前半",33.46666666666667,33.46666666666667,33.46666666666667,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"18a"}},LEVEL,"一面道中·前半",4000)

end

do

    local meta={id=4001,group=19,stage=1,sub="road_after",road=true,part="after",frozen=false,base=2008,ending=5278,timeout=3270,epoch=0,invul=3270,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=2}

    boss.Define("19a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("一面道中·后半",54.5,54.5,54.5,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"19a"}},LEVEL,"一面道中·后半",4001)

end

do

    local meta={id=4002,group=20,stage=2,sub="road_before",road=true,part="before",frozen=false,base=0,ending=2588,timeout=2588,epoch=0,invul=2588,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=4}

    boss.Define("20a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("二面道中·前半",43.13333333333333,43.13333333333333,43.13333333333333,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"20a"}},LEVEL,"二面道中·前半",4002)

end

do

    local meta={id=4003,group=21,stage=2,sub="road_after",road=true,part="after",frozen=false,base=2588,ending=5983,timeout=3395,epoch=0,invul=3395,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=4}

    boss.Define("21a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("二面道中·后半",56.583333333333336,56.583333333333336,56.583333333333336,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"21a"}},LEVEL,"二面道中·后半",4003)

end

do

    local meta={id=4004,group=22,stage=3,sub="road_before",road=true,part="before",frozen=true,base=0,ending=3804,timeout=3804,epoch=0,invul=3804,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=6}

    boss.Define("22a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("三面道中·前半",63.4,63.4,63.4,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"22a"}},LEVEL,"三面道中·前半",4004)

end

do

    local meta={id=4005,group=23,stage=3,sub="road_after",road=true,part="after",frozen=true,base=3805,ending=5854,timeout=2049,epoch=0,invul=2049,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=6}

    boss.Define("23a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("三面道中·后半",34.15,34.15,34.15,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"23a"}},LEVEL,"三面道中·后半",4005)

end

do

    local meta={id=4006,group=24,stage=4,sub="road_before",road=true,part="before",frozen=false,base=0,ending=4132,timeout=4132,epoch=0,invul=4132,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=8}

    boss.Define("24a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("四面道中·前半",68.86666666666666,68.86666666666666,68.86666666666666,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"24a"}},LEVEL,"四面道中·前半",4006)

end

do

    local meta={id=4007,group=25,stage=4,sub="road_after",road=true,part="after",frozen=false,base=4132,ending=10694,timeout=6562,epoch=0,invul=6562,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=8}

    boss.Define("25a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("四面道中·后半",109.36666666666666,109.36666666666666,109.36666666666666,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"25a"}},LEVEL,"四面道中·后半",4007)

end

do

    local meta={id=4008,group=26,stage=5,sub="road_before",road=true,part="before",frozen=false,base=0,ending=3372,timeout=3372,epoch=0,invul=3372,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=10}

    boss.Define("26a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("五面道中·前半",56.2,56.2,56.2,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"26a"}},LEVEL,"五面道中·前半",4008)

end

do

    local meta={id=4009,group=27,stage=5,sub="road_after",road=true,part="after",frozen=false,base=3374,ending=7704,timeout=4330,epoch=0,invul=4330,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=10}

    boss.Define("27a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("五面道中·后半",72.16666666666667,72.16666666666667,72.16666666666667,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"27a"}},LEVEL,"五面道中·后半",4009)

end

do

    local meta={id=4010,group=28,stage=6,sub="road_before",road=true,part="before",frozen=true,base=0,ending=2564,timeout=2564,epoch=0,invul=2564,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=12}

    boss.Define("28a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("六面道中·前半",42.733333333333334,42.733333333333334,42.733333333333334,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"28a"}},LEVEL,"六面道中·前半",4010)

end

do

    local meta={id=4011,group=29,stage=6,sub="road_after",road=true,part="after",frozen=true,base=2567,ending=3167,timeout=600,epoch=0,invul=600,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=12}

    boss.Define("29a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("六面道中·后半（入场等待）",10.0,10.0,10.0,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"29a"}},LEVEL,"六面道中·后半（入场等待）",4011)

end

do

    local meta={id=4012,group=30,stage=7,sub="road_before",road=true,part="before",frozen=true,base=0,ending=4740,timeout=4740,epoch=0,invul=4740,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=13}

    boss.Define("30a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("Extra道中·前半",79.0,79.0,79.0,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"30a"}},LEVEL,"Extra道中·前半",4012)

end

do

    local meta={id=4013,group=31,stage=7,sub="road_after",road=true,part="after",frozen=true,base=4743,ending=8593,timeout=3850,epoch=0,invul=3850,hp=10000000,threshold=0,bounds=nil,entry_x=0,entry_y=400,hitbox={0,0},mid_group=13}

    boss.Define("31a","道中","TH06_0",TH06_bg,{0,400},nil,"img_void",LEVEL)

    local card=boss.card.New("Extra道中·后半",64.16666666666667,64.16666666666667,64.16666666666667,10000000)

    card.th06_source=meta

    function card:before() self.th06=nil;self.NotPlayTimeOutSound=true;self.colli=false;self.no_hp_render=true end

    function card:init() H.road_init(self,meta) end

    function card:del() H.road_del(self) end

    boss.card.add({{card,"31a"}},LEVEL,"Extra道中·后半",4013)

end

do

    local remilia=_editor_boss["1a"..LEVEL]

    if remilia and remilia.cards then

        local order={[3960]=1,[3802]=2,[3961]=3,[3805]=4,[3962]=5,[3808]=6,[3963]=7,[3811]=8,[369]=9}

        for _,card in ipairs(remilia.cards) do card.th06_order=order[card.card_id] or 100 end

        table.sort(remilia.cards,function(a,b) return a.th06_order<b.th06_order end)

    end

end

class.boss_order={18,2,19,3,20,4,21,5,22,6,23,7,24,8,25,9,15,16,17,26,10,27,11,28,12,29,1,30,13,31,14}

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
