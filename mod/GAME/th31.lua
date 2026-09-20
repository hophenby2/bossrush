---=====================================
---TH31  东方永夜抄 Last Word 移植
---本文件按 TH08 原版 ECL 的行为，用 LuaSTG 对象/协程语法手工重写。
---不使用 ECL 解释器，也不复用本工程二创的 th08-boss_lastword.lua。
---=====================================

local boss = boss
local Class = Class
local object = object
local laser = laser
local task = task
local ran = ran
local COLOR = COLOR
local GROUP = GROUP
local LAYER = LAYER
local New = New
local NewSimpleBullet = NewSimpleBullet
local ball_mid = ball_mid
local knife = knife
local SetImageState = SetImageState
local Render = Render
local IsValid = IsValid
local Angle = Angle
local cos, sin = cos, sin
local min, max, floor = min, max, math.floor

local _editor_class = _editor_class
local class = _editor_class["TH31"] or {}
_editor_class["TH31"] = class

local TH31_LEVEL = 29
local DEG = 180 / math.pi
local BOSS_IMG = {
    Alice = "Alice",
    Remilia = "Remilia",
    Sakuya = "Sakuya",
    Youmu = "Youmu",
    Yuyuko = "Yuyuko",
    Yukari = "Yukari",
}

local function clamp(v, a, b)
    return min(max(v, a), b)
end

local function bullet(style, color, x, y, v, a, omiga)
    return NewSimpleBullet(style or ball_mid, color or COLOR.RED, x, y, v or 0,
            a or 0, false, omiga or 0, false)
end

local function ring(style, color, x, y, count, v, a, omiga, radius)
    if radius and radius > 0 then
        x = x + cos(a) * radius
        y = y + sin(a) * radius
    end
    for i = 0, count - 1 do
        bullet(style, color, x, y, v, a + 360 * i / count, omiga)
    end
end

local function fan(style, color, x, y, count, v, a, spread, omiga)
    local step = count > 1 and spread / (count - 1) or 0
    local start = a - spread / 2
    for i = 0, count - 1 do
        bullet(style, color, x, y, v, start + i * step, omiga)
    end
end

local function move_random(b, range_x, range_y, dist)
    task.MoveTo(clamp(b.x + ran:Float(-dist, dist), range_x[1], range_x[2]),
            clamp(b.y + ran:Float(-dist, dist), range_y[1], range_y[2]), 60, 2)
end

local function orbit_doll(self, b)
    local cx, cy = b.x, b.y
    local t = min(120, self.fade)
    local px = cx + cos(self.angle) * self.radius * (1 - t / 120)
    local py = cy + sin(self.angle) * self.radius * (1 - t / 120)
    self.x = px + cos(self.angle) * self.radius * (t / 120)
    self.y = py + sin(self.angle) * self.radius * (t / 120)
end

local function make_doll(color, size)
    return Class(object, {
        init = function(self, master, angle, omega, radius, life)
            self.x, self.y = master.x, master.y
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET_EF
            self.master = master
            self.angle = angle
            self.omega = omega
            self.radius = radius
            self.life = life
            self.fade = 0
            self.img = "white"
            self.a, self.b = size, size
            self.hscale = 1
            self.vscale = 1
            object.Connect(master, self)
        end,
        frame = function(self)
            self.fade = self.fade + 1
            self.life = self.life - 1
            if self.life <= 0 or not IsValid(self.master) then
                object.Del(self)
                return
            end
            orbit_doll(self, self.master)
            self.angle = self.angle + self.omega
            if self.fire then
                self.fire(self)
            end
        end,
        render = function(self)
            SetImageState(self.img, "mul+add", self.fade < 30 and 255 * self.fade / 30 or 255,
                    color[1], color[2], color[3])
            Render(self.img, self.x, self.y, self.angle, self.hscale, self.vscale)
        end,
    }, true)
end

class["th31_doll_red"] = make_doll({ 255, 120, 140 }, 8)
class["th31_doll_blue"] = make_doll({ 140, 170, 255 }, 8)
class["th31_doll_white"] = make_doll({ 235, 235, 255 }, 7)
class["th31_doll_purple"] = make_doll({ 220, 130, 255 }, 8)

local function remilia_stream(b, angle, speed, delta, delay, count, period)
    task.New(b, function()
        task.Wait(delay)
        local self = task.GetSelf()
        for _ = 1, count do
            ring(ball_mid, COLOR.RED, self.x, self.y, 20, speed, angle, delta * 0.5, 64)
            angle = angle + delta
            task.Wait(period)
        end
    end)
end

local sc_sakuya = boss.card.New("「デフレーションワールド」", 2, 2, 99, 99999990)
function sc_sakuya:before()
    task.MoveTo(0, 96, 110, 2)
end

function sc_sakuya:init()
    task.New(self, function()
        local self = task.GetSelf()
        while true do
            local angle = 0
            for phase = 1, 2 do
                for _ = 1, 15 do
                    fan(ball_mid, COLOR.CYAN, self.x, self.y, 20, 2.5, angle, 45, 1)
                    angle = angle + 25.7 * (phase == 1 and 1 or -1)
                    task.Wait()
                end
            end
            for _ = 1, 50 do
                fan(ball_mid, COLOR.RED, self.x, self.y, 20, 3, Angle(self, player), 45, 1)
                task.Wait(8)
            end
            task.Wait(90)
            move_random(self, { -96, 96 }, { 96, 160 }, 96)
            task.Wait(60)
            move_random(self, { -96, 96 }, { 96, 160 }, 120)
            task.Wait(100)
            fan(knife, COLOR.YELLOW, self.x, self.y, 6, 0.8, Angle(self, player), 22.5, 0)
        end
    end)
end

local sc_youmu = boss.card.New("「待宵反射衛星斬」", 2, 2, 99, 99999990)
function sc_youmu:before()
    task.MoveTo(0, 96, 110, 2)
end

function sc_youmu:init()
    task.New(self, function()
        local self = task.GetSelf()
        while true do
            task.Wait(20)
            local by = -196
            self.y = by
            task.New(self, function()
                local self = task.GetSelf()
                for i = 0, 15 do
                    local y = by + ran:Float(0, 14) + i * 1.2
                    New(class["th31_youmu_slash"], self.x, y, 157.5)
                    New(class["th31_youmu_slash"], self.x, y, 22.5)
                    task.Wait()
                end
            end)
            for _, dx in ipairs({ 0, -8, 8, -16, 16 }) do
                task.New(self, function()
                    local self = task.GetSelf()
                    task.Wait(8)
                    local l = New(laser, COLOR.BLUE, self.x + dx, self.y, -90, 16, 992, 16, 16, 0, 0)
                    laser._TurnOn(l, 4, true)
                    task.Wait(56)
                    laser._TurnOff(l, 16, true)
                    task.Wait(16)
                    object.Del(l)
                end)
            end
            task.Wait(60)
            task.MoveTo(clamp(player.x, -176, 176), 96, 60, 2)
            task.Wait(60)
        end
    end)
end

class["th31_youmu_slash"] = Class(object, {
    init = function(self, x, y, a)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.ENEMY_BULLET, LAYER.ENEMY_BULLET
        self.vx, self.vy = cos(a) * 10, sin(a) * 10
        self.img = "white"
        self.a, self.b = 8, 8
        self.life = 66
    end,
    frame = function(self)
        self.x = self.x + self.vx
        self.y = self.y + self.vy
        self.life = self.life - 1
        if self.life % 6 == 0 then
            ring(ball_mid, COLOR.BLUE, self.x, self.y, 4, 0.4, 90, 0)
        end
        if self.life <= 0 then
            object.Del(self)
        end
    end,
    render = function(self)
        SetImageState(self.img, "mul+add", 255, 130, 180, 255)
        Render(self.img, self.x, self.y, 0, 1, 3)
    end,
}, true)

local sc_alice = boss.card.New("「グランギニョル座の怪人」", 2, 2, 99, 99999990)
function sc_alice:before()
    task.MoveTo(0, 96, 110, 2)
end

function sc_alice:init()
    for i = 0, 7 do
        local d = New(class["th31_doll_red"], self, 180 + i * 45, 1.2, 60, 6000)
        d.fire = function(self)
            if self.fade % 60 == 0 then
                ring(ball_mid, COLOR.RED, self.x, self.y, 4, 1, self.angle + 7.5, 1)
                ring(ball_mid, COLOR.YELLOW, self.x, self.y, 4, 1, self.angle + 15, 1)
            end
        end
    end
    for i = 0, 7 do
        local d = New(class["th31_doll_blue"], self, 180 + i * 45, -1.2, 60, 6000)
        d.fire = function(self)
            local phase = floor(self.fade / 600) % 2
            if phase == 1 and self.fade % 8 == 0 then
                fan(ball_mid, COLOR.BLUE, self.x, self.y, 4, 5, Angle(self, player), 45, 0)
            end
        end
    end
    task.New(self, function()
        local self = task.GetSelf()
        while true do
            for _ = 1, 5 do
                move_random(self, { -110, 110 }, { 32, 136 }, 96)
                task.Wait(60)
            end
            task.MoveTo(0, 96, 60, 2)
            task.Wait(60)
        end
    end)
end

local sc_remilia = boss.card.New("「スカーレットディスティニー」", 2, 2, 99, 99999990)
function sc_remilia:before()
    task.MoveTo(0, 96, 110, 2)
end

function sc_remilia:init()
    task.New(self, function()
        local self = task.GetSelf()
        local speed = 4
        while true do
            local pa = Angle(self, player)
            remilia_stream(self, pa + 90, speed, 10.6, 0, 128, 2)
            remilia_stream(self, pa - 90, speed, -10.6, 0, 128, 2)
            remilia_stream(self, pa + 180, speed, 7.2, 60, 32, 2)
            task.Wait(130)
            move_random(self, { -110, 110 }, { 32, 136 }, 96)
            task.Wait(60)
            speed = min(speed + 1, 9)
        end
    end)
end

local sc_yuyuko = boss.card.New("「西行寺無余涅槃」", 2, 2, 99, 99999990)
function sc_yuyuko:before()
    task.MoveTo(0, 112, 110, 2)
end

function sc_yuyuko:init()
    task.New(self, function()
        local self = task.GetSelf()
        local count = 20
        local radial = 0.5
        local laser_count = 6
        while true do
            local base = ran:Float(0, 360)
            for i = 0, 2 do
                local a = base + 120 * i
                local l = New(laser, COLOR.PURPLE, self.x, self.y, a, 64, 320, 64, 16, 0, 0)
                task.New(l, function()
                    local self = task.GetSelf()
                    laser._TurnOn(self, 60, true)
                    for _ = 1, 60 do
                        self.rot = self.rot + 1
                        task.Wait()
                    end
                    task.Wait(330)
                    laser._TurnOff(self, 30, true)
                    task.Wait(30)
                    object.Del(self)
                end)
            end
            for i = 0, 2 do
                local a = base + 60 + 120 * i
                local l = New(laser, COLOR.RED, self.x, self.y, a, 64, 320, 64, 16, 0, 0)
                task.New(l, function()
                    local self = task.GetSelf()
                    laser._TurnOn(self, 60, true)
                    for _ = 1, 60 do
                        self.rot = self.rot - 1
                        task.Wait()
                    end
                    task.Wait(330)
                    laser._TurnOff(self, 30, true)
                    task.Wait(30)
                    object.Del(self)
                end)
            end
            for i = 0, 3 do
                ring(ball_mid, COLOR.PURPLE, self.x, self.y, count, radial, base + 9 * i, 0)
                task.Wait(10)
            end
            for i = 0, 3 do
                ring(ball_mid, COLOR.RED, self.x, self.y, 24 + 2 * i, 0.8, base + 30 * i, i % 2 == 0 and 2 or -2)
                task.Wait(30)
            end
            move_random(self, { -64, 64 }, { 96, 128 }, 16)
            task.Wait(60)
            ring(ball_mid, COLOR.WHITE, self.x, self.y, 24, radial, 90, 0)
            radial = radial + 0.08
            count = count + 3
            laser_count = min(laser_count + 2, 12)
            task.Wait(95)
        end
    end)
end

local YUKARI_PHASES = {
    { angle = 180, omega = 1.5, radius = 224, spin = 1.5, life = 520, ways = 4, speed = 2.5 },
    { angle = 0, omega = -1.5, radius = 192, spin = -1.0, life = 520, ways = 4, speed = 2.5 },
    { angle = 180, omega = -1.0, radius = 224, spin = -1.5, life = 520, ways = 4, speed = 2.0 },
    { angle = 180, omega = 1.5, radius = 192, spin = 1.5, life = 520, ways = 4, speed = 2.0 },
    { angle = 180, omega = 1.0, radius = 224, spin = 1.5, life = 520, ways = 4, speed = 2.0 },
    { angle = 180, omega = -1.8, radius = 224, spin = -1.8, life = 520, ways = 4, speed = 2.0 },
    { angle = -90, omega = 1.8, radius = 224, spin = 1.5, life = 520, ways = 4, speed = 2.0 },
    { angle = 90, omega = 1.8, radius = 224, spin = -1.5, life = 520, ways = 4, speed = 2.0 },
    { angle = 90, omega = 1.8, radius = 224, spin = 1.5, life = 520, ways = 4, speed = 2.0 },
    { angle = 90, omega = -1.8, radius = 224, spin = -1.5, life = 520, ways = 4, speed = 2.0 },
    { angle = -90, omega = 1.8, radius = 224, spin = 1.5, life = 480, ways = 2, speed = 4.0 },
    { angle = 90, omega = 1.8, radius = 224, spin = 1.5, life = 480, ways = 2, speed = 4.0 },
    { angle = 90, omega = -1.8, radius = 224, spin = -1.5, life = 520, ways = 2, speed = 6.0 },
    { angle = 180, omega = -1.8, radius = 224, spin = -1.5, life = 520, ways = 2, speed = 6.0 },
    { angle = -90, omega = 1.8, radius = 224, spin = 1.5, life = 280, ways = 2, speed = 5.0 },
    { angle = 90, omega = 1.8, radius = 224, spin = 1.5, life = 280, ways = 2, speed = 5.0 },
    { angle = -90, omega = 1.8, radius = 224, spin = 1.5, life = 280, ways = 2, speed = 5.0 },
    { angle = 90, omega = 1.8, radius = 224, spin = 1.5, life = 280, ways = 2, speed = 5.0 },
}

local sc_yukari = boss.card.New("「深弾幕結界　-夢幻泡影-」", 2, 2, 131, 10000000)
function sc_yukari:before()
    task.MoveTo(0, 96, 90, 2)
end

function sc_yukari:init()
    task.New(self, function()
        local self = task.GetSelf()
        task.MoveTo(0, 0, 60, 2)
        for _, phase in ipairs(YUKARI_PHASES) do
            for _, color in ipairs({ class["th31_doll_purple"], class["th31_doll_white"] }) do
                local d = New(color, self, phase.angle, phase.omega, phase.radius, phase.life)
                d.fire = function(self)
                    if self.fade > 120 and self.fade % 3 == 0 then
                        local a = self.angle + (floor(self.fade / 3) * phase.spin)
                        fan(ball_mid, COLOR.PURPLE, self.x, self.y, phase.ways, phase.speed, a, 0, 0)
                        fan(ball_mid, COLOR.WHITE, self.x, self.y, 2, 0.5, self.angle, 22, 0)
                    end
                end
            end
            task.Wait(520)
        end
        while true do
            for _ = 1, 6 do
                local x = ran:Float(-160, 160)
                local y = ran:Float(-176, 176)
                if x * x + y * y > 1024 then
                    ring(ball_mid, COLOR.PURPLE, x, y, 2, 2, Angle(self, x, y), 0)
                end
                task.Wait()
            end
            task.Wait(90)
        end
    end)
end

---卡表按 ECL 中的 data id 排列：咲夜、妖梦、爱丽丝、蕾米、幽幽子、紫。
local lastwords = {
    { letter = "a", id = 351, name = "十六夜咲夜", img = BOSS_IMG.Sakuya, bgm = "TH08_NEW_0", card = sc_sakuya },
    { letter = "b", id = 352, name = "魂魄妖梦", img = BOSS_IMG.Youmu, bgm = "TH08_NEW_0", card = sc_youmu },
    { letter = "c", id = 353, name = "爱丽丝·玛格特洛依德", img = BOSS_IMG.Alice, bgm = "TH08_NEW_1", card = sc_alice },
    { letter = "d", id = 354, name = "蕾米莉亚·斯卡蕾特", img = BOSS_IMG.Remilia, bgm = "TH08_NEW_1", card = sc_remilia },
    { letter = "e", id = 355, name = "西行寺幽幽子", img = BOSS_IMG.Yuyuko, bgm = "TH08_NEW_2", card = sc_yuyuko },
    { letter = "f", id = 356, name = "八云紫", img = BOSS_IMG.Yukari, bgm = "TH08_NEW_3", card = sc_yukari },
}

for _, unit in ipairs(lastwords) do
    boss.Define("31" .. unit.letter, unit.name, unit.bgm, TH08_bg,
            { 0, 550 }, TH31_bg, unit.img, TH31_LEVEL)
    boss.card.add({ { unit.card, "31" .. unit.letter } }, TH31_LEVEL, unit.name, unit.id)
end
