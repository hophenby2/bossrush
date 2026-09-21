---=====================================
---TH31  永夜LastWord
---  重新按 TH08 v0x800 ECL 与 th08full 解释器移植：
---  · opcode 97 = 固定角扇形弹；opcode 99 = 固定角圆弹；
---    opcode 111 = 弹速变换（减速 / 向量加速度 / 极坐标加速度 / 转向）。
---  · TH08 与 LuaSTG 的游戏区同为 384×448：x' = x - 192，y' = 224 - y。
---    ECL 弧度换算为 LuaSTG 度；transform 按官方顺序更新。
---  · 17 张卡全部是官方超时卡，因此血量设为不可击破，并保留原卡节奏。
---=====================================

local class = {}
_editor_class["TH31"] = class

local boss = boss
local task = task
local object = object
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local Del = Del
local cos, sin = cos, sin
local Angle = Angle
local Dist = Dist
local sqrt = sqrt
local abs = abs
local int = int

local ball_small = ball_small
local ball_mid = ball_mid
local ellipse = ellipse
local knife = knife
local grain_a = grain_a
local star_small = star_small

local TH08_SC = _editor_class["TH08"] or {}
local TH07_SC = _editor_class["TH07"] or {}

--TH08 BulletManager.hpp 的 transform kind 位。
local SPAWN_FAST, SPAWN_NORMAL, SPAWN_SLOW = 0x2, 0x4, 0x8
local DECELERATE, ACCEL_VECTOR, ACCEL_POLAR = 0x1, 0x10, 0x20
local DIR_RELATIVE, DIR_AIMED, DIR_ABSOLUTE = 0x40, 0x80, 0x100
local BOUNCE_ALL, BOUNCE_BOTTOM = 0x400, 0x800
local SET_CULL_DELAY, SET_SPRITE, DESPAWN_MARKER = 0x2000, 0x4000, 0x40000
local WAIT, DESPAWN, PLAY_SOUND = 0x20000, 0x40000, 0x80000
local EX_MARKER, WRAP_X, WRAP_Y = 0x100000, 0x400000, 0x800000

local RAD_TO_DEG = 57.29577951308232

local function has_flag(flags, kind)
    if kind <= 0 then return false end
    return math.floor(flags / kind) % 2 ~= 0
end

local function set_v(bullet, speed, angle)
    angle = angle or bullet.rot
    object.SetV(bullet, speed, angle, true)
end

--对应 Bullet::AdvanceTransformProgram：保留官方 18 个 transform 槽位、
--按 kind 共享的 exState，以及 allowWhileActive 的原始语义。
local function ecl_hook(records, transform_flags)
    local flags = transform_flags or 0
    local slots = {}
    local next_slot = 0
    for _, record in ipairs(records) do
        local slot = record.slot or next_slot
        if slot < 0 or slot >= 18 then
            error("ECL transform slot out of range: " .. tostring(slot), 2)
        end
        record.allow_while_active = record.allow_while_active == true
        slots[slot + 1] = record
        next_slot = slot + 1
    end

    return function(bullet)
        local active = {}
        local direction_state
        local index = 0
        local logical_speed = sqrt(bullet.vx * bullet.vx + bullet.vy * bullet.vy)
        local logical_angle = Angle(0, 0, bullet.vx, bullet.vy)
        local cull_delay = 0

        if has_flag(flags, SPAWN_FAST) or has_flag(flags, SPAWN_NORMAL)
                or has_flag(flags, SPAWN_SLOW) then
            bullet.x = bullet.x - bullet.vx * 4
            bullet.y = bullet.y - bullet.vy * 4
        end

        local function activate()
            while index < 18 do
                local record = slots[index + 1]
                if not record or not record.kind or record.kind <= 0 then return end
                if not has_flag(flags, record.kind) then
                    index = index + 1
                elseif record.kind == SET_CULL_DELAY then
                    cull_delay = record.frames or 0
                    bullet.bound = cull_delay == 0
                    index = index + 1
                elseif record.kind == SET_SPRITE or record.kind == PLAY_SOUND
                        or record.kind == EX_MARKER or record.kind == DESPAWN_MARKER then
                    index = index + 1
                elseif record.kind == DESPAWN then
                    Del(bullet)
                    return
                elseif record.allow_while_active or next(active) == nil then
                    if record.kind == DECELERATE then
                        active[DECELERATE] = { timer = 0 }
                    elseif record.kind == ACCEL_VECTOR then
                        active[ACCEL_VECTOR] = {
                            timer = 0,
                            magnitude = record.speed or 0,
                            angle = (record.angle or -999) > -990
                                    and record.angle * RAD_TO_DEG or logical_angle,
                            duration = record.duration or 0,
                        }
                    elseif record.kind == ACCEL_POLAR then
                        active[ACCEL_POLAR] = {
                            timer = 0,
                            speed_delta = record.speed or 0,
                            angle_delta = (record.angle or 0) * RAD_TO_DEG,
                            duration = record.duration or 0,
                        }
                    elseif record.kind == DIR_RELATIVE or record.kind == DIR_AIMED
                            or record.kind == DIR_ABSOLUTE then
                        direction_state = {
                            kind = record.kind,
                            timer = 0,
                            angle = record.angle * RAD_TO_DEG,
                            speed = (record.speed or -999) > -999
                                    and record.speed or logical_speed,
                            interval = record.interval or 0,
                            repeat_count = record.repeat_count or 1,
                            done = 0,
                        }
                        active[record.kind] = direction_state
                    elseif record.kind == BOUNCE_ALL or record.kind == BOUNCE_BOTTOM then
                        active[record.kind] = {
                            speed = (record.speed or -1) >= 0 and record.speed or logical_speed,
                            limit = record.repeat_count or 1,
                            done = 0,
                        }
                    elseif record.kind == WAIT then
                        active[WAIT] = { timer = record.frames or 0 }
                    elseif record.kind == WRAP_X or record.kind == WRAP_Y then
                        active[record.kind] = { timer = record.frames or 0 }
                    end
                    index = index + 1
                else
                    return
                end
            end
        end

        local function set_velocity(speed, angle)
            logical_speed = speed
            logical_angle = angle
            set_v(bullet, speed, angle)
        end

        local function update_deceleration()
            local state = active[DECELERATE]
            if state.timer <= 16 then
                set_v(bullet, logical_speed + 5 - state.timer * 5 / 16, logical_angle)
            else
                active[DECELERATE] = nil
                set_v(bullet, logical_speed, logical_angle)
            end
            state.timer = state.timer + 1
        end

        local function update_vector_acceleration()
            local state = active[ACCEL_VECTOR]
            if state.timer >= state.duration then
                active[ACCEL_VECTOR] = nil
            else
                bullet.vx = bullet.vx + cos(state.angle) * state.magnitude
                bullet.vy = bullet.vy + sin(state.angle) * state.magnitude
                if abs(bullet.vx) > 0.0001 or abs(bullet.vy) > 0.0001 then
                    logical_angle = Angle(0, 0, bullet.vx, bullet.vy)
                    bullet.rot = logical_angle
                end
            end
            state.timer = state.timer + 1
        end

        local function update_polar_acceleration()
            local state = active[ACCEL_POLAR]
            if state.timer >= state.duration then
                active[ACCEL_POLAR] = nil
            else
                logical_angle = (logical_angle + state.angle_delta) % 360
                logical_speed = logical_speed + state.speed_delta
                set_v(bullet, logical_speed, logical_angle)
            end
            state.timer = state.timer + 1
        end

        local function update_direction(kind)
            local state = direction_state
            if state.timer >= state.interval then
                local next_angle
                if kind == DIR_RELATIVE then
                    next_angle = logical_angle + state.angle
                elseif kind == DIR_AIMED then
                    next_angle = Angle(bullet, player) + state.angle
                else
                    next_angle = state.angle
                end
                state.done = state.done + 1
                if state.done >= state.repeat_count then
                    active[kind] = nil
                end
                set_velocity(state.speed, next_angle)
                state.timer = 0
            else
                set_v(bullet, logical_speed - logical_speed * state.timer / state.interval,
                        logical_angle)
            end
            state.timer = state.timer + 1
        end

        local function update_bounce(kind)
            local state = active[kind]
            if bullet.x <= -224 or bullet.x >= 224 then
                logical_angle = -logical_angle - 180
                logical_speed = state.speed
                set_v(bullet, logical_speed, logical_angle)
                state.done = state.done + 1
            end
            if bullet.y >= 224 or (kind == BOUNCE_ALL and bullet.y <= -224) then
                logical_angle = -logical_angle
                logical_speed = state.speed
                set_v(bullet, logical_speed, logical_angle)
                state.done = state.done + 1
            end
            if state.done >= state.limit then active[kind] = nil end
        end

        local function update_wrap(kind)
            local state = active[kind]
            if kind == WRAP_X then
                if bullet.x < -192 then bullet.x = bullet.x + 384
                elseif bullet.x > 192 then bullet.x = bullet.x - 384 end
            else
                if bullet.y < -224 then bullet.y = bullet.y + 448
                elseif bullet.y > 224 then bullet.y = bullet.y - 448 end
            end
            if state.timer <= 0 then
                active[kind] = nil
            else
                state.timer = state.timer - 1
            end
        end

        activate()

        function bullet.frame_other()
            activate()
            if active[DECELERATE] then update_deceleration() end
            if active[ACCEL_VECTOR] then update_vector_acceleration() end
            if active[ACCEL_POLAR] then update_polar_acceleration() end
            if active[DIR_RELATIVE] then update_direction(DIR_RELATIVE) end
            if active[DIR_ABSOLUTE] then update_direction(DIR_ABSOLUTE) end
            if active[DIR_AIMED] then update_direction(DIR_AIMED) end
            if active[BOUNCE_ALL] then update_bounce(BOUNCE_ALL) end
            if active[BOUNCE_BOTTOM] then update_bounce(BOUNCE_BOTTOM) end
            if active[WRAP_X] then update_wrap(WRAP_X) end
            if active[WRAP_Y] then update_wrap(WRAP_Y) end
            if active[WAIT] then
                local state = active[WAIT]
                if state.timer <= 0 then
                    active[WAIT] = nil
                else
                    state.timer = state.timer - 1
                end
            end
            if cull_delay > 0 then
                cull_delay = cull_delay - 1
                if cull_delay == 0 then bullet.bound = true end
            end
        end
    end
end

local function fan(style, color, owner, count, speed, angle, step, hook)
    for i = 0, count - 1 do
        local spread
        if count % 2 ~= 0 then
            spread = int((i + 1) / 2) * step
            if i % 2 ~= 0 then
                spread = -spread
            end
        else
            spread = (int(i / 2) + 0.5) * step
            if i % 2 ~= 0 then
                spread = -spread
            end
        end
        NewSimpleBullet(style, color, owner.x, owner.y, speed, angle + spread,
                false, 0, false, false, false, false, hook)
    end
end

local function circle(style, color, owner, count, speed1, angle, step, speed2, hook)
    local count2 = speed2 and 2 or 1
    for j = 0, count2 - 1 do
        local v = count2 > 1 and speed1 - (speed1 - speed2) * j / count2 or speed1
        for i = 0, count - 1 do
            local a = angle + i * 360 / count + j * (step or 0)
            NewSimpleBullet(style, color, owner.x, owner.y, v, a,
                    false, 0, false, false, false, false, hook)
        end
    end
end

local function wait_card(self)
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
    task.MoveTo(0, 96, 56, 2)
end

local function add_card(name, id, letter, owner, time)
    local card = boss.card.New(name, 6, 8, time or 99, 10000000)
    boss.card.add({ { card, letter } }, 29, name, id)
    card.before = wait_card
    card.init = function(self)
        local owner_boss = self
        task.New(self, function()
            owner(owner_boss)
        end)
    end
    return card
end


class["SCBG1"] = Class(_SC_BG)
class["SCBG2"] = Class(_SC_BG)

boss.Define("1a", "莉格露·奈特巴格", "TH08_NEW_0", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW1"], "Nightbug", 29)
boss.Define("1b", "米斯蒂娅·萝蕾拉", "TH08_NEW_0", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW1"], "Lorelei", 29)
boss.Define("1c", "上白泽慧音", "TH08_NEW_0", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW3"], "Kamishirasawa", 29)
boss.Define("1d", "铃仙·优昙华院·因幡", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW4"], "Reisen", 29)
boss.Define("1e", "八意永琳", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW5"], "Yagokoro", 29)
boss.Define("1f", "蓬莱山辉夜", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW6"], "Neet", 29)
boss.Define("1g", "藤原妹红", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW6"], "Mokou", 29)
boss.Define("1h", "因幡帝", "TH08_NEW_2", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW8"], "Tewi", 29)
boss.Define("1i", "上白泽慧音", "TH08_NEW_2", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW9"], "Kamishirasawa2", 29)
boss.Define("1j", "博丽灵梦", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, class["SCBG1"], "Reimu", 29)
boss.Define("1k", "雾雨魔理沙", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, class["SCBG2"], "Marisa", 29)
boss.Define("1l", "十六夜咲夜", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW10"], "Sakuya", 29)
boss.Define("1m", "魂魄妖梦", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW11"], "Youmu", 29, 0.6)
boss.Define("1n", "爱丽丝·玛格特洛依德", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW12"], "Alice", 29)
boss.Define("1o", "蕾米莉亚·斯卡蕾特", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW13"], "Remilia", 29)
boss.Define("1p", "西行寺幽幽子", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW14"], "Yuyuko", 29)
boss.Define("1q", "八云紫", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH07_SC["SCBG8"], "Yukari", 29)

class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_0", true, 0, 0, 0, 0, 0.3, 0, "", 1, 1)
    _SC_BG.AddLayer(self, "th08_3", true, 0, 0, 0, -0.2, 0, 0, "mul+add", 1, 1)
end

class["SCBG2"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0, "mul+sub", 1, 1)
    _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0, 0, 1.5, 0, "", 1, 1)
end

-- 205 季节外调のバタフライストーム
add_card("「季节外调的蝴蝶风暴」", 351, "1a", function(self)
    task.Wait(110)
    task.New(self, function()
        local angle, spin = Angle(self.x, self.y, player.x, player.y), 0
        while true do
            local hook = ecl_hook({
                { slot = 0, kind = DESPAWN_MARKER, allow_while_active = true, frames = 400 },
                { slot = 1, kind = WAIT, allow_while_active = true, frames = 60 },
                { slot = 2, kind = DIR_RELATIVE, allow_while_active = true,
                  angle = -math.pi / 2, speed = -999, interval = 30, repeat_count = 1 },
                { slot = 3, kind = EX_MARKER, allow_while_active = true },
                { slot = 4, kind = DIR_ABSOLUTE, allow_while_active = true,
                  angle = math.pi, speed = 0, interval = 60, repeat_count = 1 },
                { slot = 5, kind = EX_MARKER, allow_while_active = true, frames = 0 },
                { slot = 6, kind = WAIT, allow_while_active = true, frames = 10 },
                { slot = 9, kind = EX_MARKER, allow_while_active = true, frames = 27 },
                { slot = 10, kind = DIR_RELATIVE, allow_while_active = true,
                  angle = 2.0943952, speed = 2.8, interval = 10, repeat_count = 1 },
                { slot = 11, kind = EX_MARKER, allow_while_active = true, frames = 8 },
            }, 0xA6244)
            local radius = 128
            for i = 0, 23 do
                local spread = (i % 2 == 0 and 1 or -1) * int((i + 1) / 2) * 15
                local direction = angle + spread
                NewSimpleBullet(ball_small, 4,
                        self.x + cos(direction) * radius, self.y + sin(direction) * radius,
                        0.5, direction + 180, false, 0, false, false, false, false, hook)
            end
            angle = angle + 15
            spin = spin + 1
            PlaySound("tan00", 0.05, 0, true)
            task.Wait(7)
        end
    end)
    task.New(self, function()
        while true do
            task.Wait(70)
            task.MoveTo(ran:Float(-130, 130), ran:Float(70, 150), 45, 2)
        end
    end)
end)

-- 206 ブラインドナイトバード
add_card("「盲夜鸟」", 352, "1b", function(self)
    task.Wait(110)
    task.New(self, function()
        -- ecldata2sp.Sub45：cull 60；60 帧绝对转向 0 后，
        -- Easy 的持续 60 帧加速度 0.09166667；每帧 10 发 15° 扇。
        local hook = ecl_hook({
            { slot = 0, kind = DESPAWN_MARKER, allow_while_active = true, frames = 60 },
            { slot = 1, kind = DIR_ABSOLUTE, allow_while_active = true,
              angle = 0, speed = 0, interval = 60, repeat_count = 1 },
            { slot = 2, kind = ACCEL_VECTOR, allow_while_active = true,
              speed = 0.09166667, angle = -999.9, duration = 60 },
        }, 0x2252)
        for _ = 1, 15 do
            fan(ellipse, 10, self, 1, 3.0, 0, 0, hook)
            task.Wait(1)
        end
    end)
end)

-- 207 日出づる国の天子
add_card("「日出之国的天子」", 353, "1c", function(self)
    task.Wait(110)
    task.New(self, function()
        -- ecldata3sp.Sub56/Sub59：三个 familiar 每 20 帧交替发
        -- 0.9 自机狙与 1.1 扇形弹；完整 familiar 轨道另行保留。
        local hook = ecl_hook({}, 0x4210)
        local groups = { { x = -96, a = -90 }, { x = 96, a = -90 }, { x = 0, a = 0 } }
        while true do
            for _, g in ipairs(groups) do
                NewSimpleBullet(ball_mid, 1, g.x, 96, 0.9,
                        Angle(g.x, 96, player.x, player.y),
                        false, 0, false, false, false, false, hook)
                fan(ball_mid, 3, { x = g.x, y = 96 }, 1, 1.1,
                        Angle(g.x, 96, player.x, player.y), 1.5, hook)
            end
            task.Wait(20)
        end
    end)
    task.New(self, function()
        while true do
            task.Wait(180)
            task.MoveTo(ran:Float(-110, 110), 110, 50, 2)
        end
    end)
end)

-- 208 幻朧月睨
add_card("「幻胧月睨」", 354, "1d", function(self)
    task.Wait(110)
    local hook = ecl_hook({}, 0)
    while true do
        local aim = Angle(self.x, self.y, player.x, player.y)
        circle(ball_mid, 8, self, 128, 5.0, aim, 5.625, 1.0, hook)
        task.Wait(30)
        task.MoveTo(-20, 150, 45, 2)
        task.Wait(45)
        circle(ball_mid, 2, self, 128, 5.4, aim + 3.75,
                5.625, 1.0, hook)
        circle(ball_mid, 6, self, 128, 2.8, aim + 45 - 3.75,
                5.625, 1.0, hook)
        task.Wait(30)
        task.MoveTo(20, 150, 45, 2)
        task.Wait(45)
        circle(ball_mid, 6, self, 44, 5.2, aim, 5.625, 2.6, hook)
        circle(ball_mid, 2, self, 44, 2.6, aim + 3.75,
                5.625, 2.6, hook)
        task.Wait(120)
    end
end)

-- 209 天網蜘網捕蝶の法
add_card("「天网蛛网捕蝶之法」", 355, "1e", function(self)
    task.Wait(110)
    task.New(self, function()
        local angle = Angle(self.x, self.y, player.x, player.y) - 22.5
        while true do
            circle(ball_small, 4, self, 10, 1.1, angle, 0)
            angle = angle + 67.5
            task.Wait(4)
        end
    end)
    task.New(self, function()
        while true do
            task.MoveTo(ran:Float(-130, 130), ran:Float(75, 145), 55, 2)
            task.Wait(65)
        end
    end)
end)

-- 210 蓬莱の樹海
add_card("「蓬莱之树海」", 356, "1f", function(self)
    task.Wait(110)
    task.New(self, function()
        local hooks = {}
        for i = 1, 8 do
            hooks[i] = ecl_hook({
                { kind = WAIT, allow_while_active = false, frames = i * 10 },
                { kind = DIR_ABSOLUTE, allow_while_active = false,
                  angle = 3.1415927, speed = 0.5, interval = 1, repeat_count = 1 },
            }, 0x20040)
        end
        while true do
            for i, hook in ipairs(hooks) do
                NewSimpleBullet(star_small, 7, self.x, self.y, 0.5, i * 45,
                        false, 0, false, false, false, false, hook)
            end
            task.Wait(130)
        end
    end)
    task.New(self, function()
        while true do
            task.MoveTo(ran:Float(-120, 120), ran:Float(80, 145), 70, 2)
            task.Wait(90)
        end
    end)
end)

-- 211 フェニックス再誕
add_card("「不死鸟再诞」", 357, "1g", function(self)
    task.Wait(110)
    task.New(self, function()
        -- ecldata8sp.Sub110/Sub111：每 10 帧生成一轮围绕 Boss 的低速火种；
        -- 每个 120 帧内沿自身方向加速 0.14166667。
        local hook = ecl_hook({
            { slot = 0, kind = DESPAWN_MARKER, allow_while_active = true, frames = 120 },
            { slot = 1, kind = ACCEL_VECTOR, allow_while_active = true,
              speed = 0.14166667, angle = -999.9, duration = 120 },
        }, 0x2212)
        while true do
            local base = Angle(self.x, self.y, player.x, player.y)
            for i = 0, 15 do
                NewSimpleBullet(grain_a, 1, self.x, self.y, 0.5,
                        base + i * 22.5, false, 0, false, false, false, false, hook)
            end
            task.Wait(10)
        end
    end)
    task.New(self, function()
        while true do
            task.MoveTo(ran:Float(-130, 130), ran:Float(75, 145), 60, 2)
            task.Wait(80)
        end
    end)
end)

-- 212 エンシェントデューパー
add_card("「远古的欺骗者」", 358, "1h", function(self)
    task.Wait(110)
    task.New(self, function()
        local hook = ecl_hook({
            { kind = WAIT, allow_while_active = false, frames = 3 },
            { kind = DIR_AIMED, allow_while_active = false,
              angle = 0.0, speed = 1.0, interval = 7, repeat_count = 1 },
        }, 0x20080)
        while true do
            for side = -1, 1, 2 do
                local x = side * 126
                for i = 0, 47 do
                    local b = NewSimpleBullet(knife, 7, x, 168, 1.0,
                            side < 0 and 0 or 180, false, 0, false, false, false, false,
                            hook)
                    b.omiga = side * 1.4
                end
            end
            task.Wait(240)
        end
    end)
end)

-- 213 無何有浄化
add_card("「无何有净化」", 359, "1i", function(self)
    task.Wait(110)
    task.New(self, function()
        -- ecldata8sp.Sub114：标记 0，等待；每 2 帧标记 1，
        -- 120 帧后统一 despawn；基础弹为三向 3.0。
        local pending = ecl_hook({
            { slot = 0, kind = DESPAWN_MARKER, allow_while_active = true, frames = 0 },
        }, 0x61FE2)
        local armed = ecl_hook({
            { slot = 1, kind = DESPAWN_MARKER, allow_while_active = true, frames = 0 },
            { slot = 2, kind = DESPAWN, allow_while_active = true, frames = 0 },
        }, 0x61FE2)
        while true do
            local aim = Angle(self.x, self.y, player.x, player.y)
            local base = 0
            for _ = 1, 25 do
                base = (base + 0.1308997 * RAD_TO_DEG) % 360
                for i = 0, 2 do
                    local b = NewSimpleBullet(ball_mid, 2, self.x, self.y, 3.0,
                            aim + base + i * 120, false, 0, false, false, false,
                            false, i == 0 and pending or armed)
                    b._r, b._g, b._b = 170, 230, 255
                end
                task.Wait(2)
            end
            task.Wait(100)
        end
    end)
    task.New(self, function()
        while true do
            task.MoveTo(ran:Float(-130, 130), ran:Float(75, 145), 65, 2)
            task.Wait(80)
        end
    end)
end)

-- 214 夢想天生
add_card("「梦想天生」", 360, "1j", function(self)
    task.Wait(90)
    while true do
        task.MoveTo(ran:Float(-120, 120), ran:Float(70, 150), 35, 2)
        task.Wait(30)
        local count = 8 + int(self.timer / 600) * 2
        local aim = Angle(self.x, self.y, player.x, player.y)
        for i = 1, count do
            local b = NewSimpleBullet(ball_light, 1, self.x, self.y, 2.4,
                    aim + i * 360 / count, false, 0, false, false, false, false,
                    function(o)
                        if o.timer == 35 then
                            set_v(o, 0.15)
                        elseif o.timer == 105 then
                            set_v(o, 1.1, Angle(o.x, o.y, player.x, player.y))
                        end
                    end)
            b._r, b._g, b._b = 255, 244, 210
        end
        task.Wait(145)
    end
end, 37)

-- 215 ブレイジングスター
add_card("「炽热之星」", 361, "1k", function(self)
    task.Wait(90)
    task.MoveTo(-170, 60, 50, 2)
    while true do
        for cycle = 1, 4 do
            local base = Angle(self.x, self.y, player.x, player.y)
            task.Wait(60)
            task.MoveTo(-170 + (cycle - 1) * 108, 60 + (cycle - 1) * 20, 45, 2)
            for i = 1, 4 do
                fan(grain_a, 5 + cycle, self, 8, 2.9, base, 9)
                task.Wait(10)
            end
        end
    end
end, 36)

-- 216 デフレーションワールド
add_card("「紧缩世界」", 362, "1l", function(self)
    task.Wait(110)
    task.New(self, function()
        -- ecldata_sk.Sub2：左右两组各 15 发，1 帧/发；60 帧后
        -- 分别转 ±90° 且速度变为 2.5。第三组每 8 帧 1 发。
        local left = ecl_hook({
            { slot = 0, kind = DIR_RELATIVE, allow_while_active = true,
              angle = math.pi / 2, speed = 2.5, interval = 60, repeat_count = 1 },
        }, 0x100242)
        local right = ecl_hook({
            { slot = 0, kind = DIR_RELATIVE, allow_while_active = true,
              angle = -math.pi / 2, speed = 2.5, interval = 60, repeat_count = 1 },
        }, 0x100242)
        local plain = ecl_hook({}, 0x202)
        for i = 0, 14 do
            NewSimpleBullet(star_small, 3, self.x, self.y, 2.5, i * 45,
                    false, 0, false, false, false, false, i % 2 == 0 and left or right)
        end
        task.Wait(1)
        for i = 0, 14 do
            NewSimpleBullet(star_small, 3, self.x, self.y, 2.5, i * 45,
                    false, 0, false, false, false, false, i % 2 == 0 and left or right)
        end
        for _ = 1, 5 do
            NewSimpleBullet(star_small, 3, self.x, self.y, 3.0, 0,
                    false, 0, false, false, false, false, plain)
            task.Wait(8)
        end
    end)
end, 131)

-- 217 待宵反射衛星斬
add_card("「待宵反射卫星斩」", 363, "1m", function(self)
    task.Wait(110)
    task.New(self, function()
        -- ecldata_ym.Sub5：初始两圈静止 10 帧；每 6 帧重写槽位：
        -- 60 帧沿当前方向加速、120 帧切向 +0.00833333 弧度/帧。
        local base_hook = ecl_hook({
            { slot = 0, kind = DESPAWN_MARKER, allow_while_active = true, frames = 10 },
        }, 0x20232)
        local first_hook = ecl_hook({
            { slot = 1, kind = ACCEL_VECTOR, allow_while_active = true,
              speed = 0.008333334, angle = -999.0, duration = 60 },
            { slot = 2, kind = ACCEL_POLAR, allow_while_active = true,
              speed = 0.008333334, angle = 0, duration = 120 },
            { slot = 3, kind = ACCEL_VECTOR, allow_while_active = true,
              speed = 0.008333334, angle = -999.0, duration = 120 },
        }, 0x20232)
        while true do
            local aim = Angle(self.x, self.y, player.x, player.y)
            for i = 0, 1 do
                NewSimpleBullet(ellipse, 4, self.x, self.y, 0,
                        90 + i * 180, false, 0, false, false, false, false,
                        i == 0 and base_hook or first_hook)
            end
            task.Wait(6)
        end
    end)
end)

-- 218 グランギニョル座の怪人
add_card("「格兰吉纽尔剧场的怪人」", 364, "1n", function(self)
    task.Wait(110)
    task.New(self, function()
        while true do
            for side = -1, 1, 2 do
                local angle = side < 0 and 180 or 0
                circle(ellipse, 4, self, 2, 1.4, angle, 6, nil, function(o)
                    if o.timer == 60 then
                        set_v(o, 1.8, Angle(o.x, o.y, player.x, player.y))
                    end
                end)
            end
            task.Wait(110)
        end
    end)
    task.New(self, function()
        while true do
            task.MoveTo(ran:Float(-130, 130), ran:Float(75, 145), 80, 2)
            task.Wait(100)
        end
    end)
end)

-- 219 スカーレットディスティニー
add_card("「猩红命运」", 365, "1o", function(self)
    task.Wait(110)
    task.New(self, function()
        local spin = 90
        while true do
            for i = 1, 3 do
                fan(knife, 4, self, 9, 2.4, spin + i * 90, 7)
            end
            spin = spin + 12
            task.Wait(65)
        end
    end)
    task.New(self, function()
        while true do
            task.MoveTo(ran:Float(-125, 125), ran:Float(75, 145), 55, 2)
            task.Wait(60)
        end
    end)
end)

-- 220 西行寺無余涅槃
add_card("「西行寺无余涅槃」", 366, "1p", function(self)
    task.Wait(110)
    task.New(self, function()
        while true do
            local count = 4
            for i = 1, count do
                local b = NewSimpleBullet(sakura, 4, self.x, self.y, 1.0,
                        Angle(self.x, self.y, player.x, player.y) + i * 360 / count,
                        false, 0, false, false, false, false,
                        function(o)
                            if o.timer % 4 == 0 and o.timer < 80 then
                                local a = Angle(o.x, o.y, player.x, player.y)
                                local child = NewSimpleBullet(ball_small, 8, o.x, o.y, 1.05, a)
                                child._r, child._g, child._b = 250, 185, 205
                            end
                        end)
                b._r, b._g, b._b = 245, 135, 170
            end
            task.Wait(8)
        end
    end)
end)

-- 221 深弾幕結界 -夢幻泡影-
add_card("「深弹幕结界 -梦幻泡影-」", 367, "1q", function(self)
    task.Wait(90)
    local waves = {
        { n = 520, color = 4, speed = 1.5, base = 0, da = 1.5, delay = 800 },
        { n = 520, color = 6, speed = 1.4, base = 180, da = -1.0, delay = 800 },
        { n = 520, color = 5, speed = 1.35, base = 270, da = -0.45, delay = 830 },
        { n = 520, color = 7, speed = 1.45, base = 45, da = 0.6, delay = 890 },
    }
    for _, w in ipairs(waves) do
        task.New(self, function()
            while true do
                for i = 1, w.n do
                    local b = NewSimpleBullet(ball_small, w.color, self.x, self.y,
                            w.speed, w.base + i * w.da, false, 0, false, false, false, false)
                    b._r, b._g, b._b = 220, 235, 255
                end
                task.Wait(w.delay)
            end
        end)
    end
end)
