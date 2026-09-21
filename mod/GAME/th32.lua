---=====================================
---TH32  猩红测试：蕾米莉亚符卡测试场
---复用 TH08 的立绘、背景与 BGM；红色幻想乡按 TH06 ECL 移植。
---=====================================
_editor_class["TH32"] = {}
local TH08 = _editor_class["TH08"] or {}
local class = _editor_class["TH32"]

local bullet_lw3_4 = TH08["bullet_lw3-4"]
local bullet_lw3_5 = TH08["bullet_lw3-5"]
local RAD_TO_DEG = 57.29577951308232
local PI = 3.141592653589793

local function red_magic_dist(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return (dx * dx + dy * dy) ^ 0.5
end

local red_magic_huge = Class(bullet, {
    init = function(self, x, y, angle, speed, duration, speed_delta, angle_delta)
        bullet.init(self, ball_huge, COLOR.RED, true, true)
        self.x, self.y = x, y
        object.SetV(self, speed, angle, true)
        task.New(self, function()
            for elapsed = 1, duration do
                object.SetV(self, speed + speed_delta * elapsed,
                        self.rot + angle_delta * RAD_TO_DEG, true)
                task.Wait()
            end
        end)
    end,
})

local red_magic_huges = {}

local red_magic_mid = Class(bullet, {
    init = function(self, x, y, angle)
        bullet.init(self, ball_mid, COLOR.RED, true, true)
        self.x, self.y = x, y
        object.SetV(self, 0, angle, true)
    end,
})

local function red_magic_mid_activate(distance_mode)
    local owner = _boss
    if owner == nil then return function() end end
    local shared_angle = ran:Float(-180, 180)
    local function activate(unit)
        local angle
        if distance_mode then
            local distance = red_magic_dist(unit.x, unit.y, owner.x, owner.y)
            angle = distance * PI / 256 * RAD_TO_DEG + shared_angle
        else
            angle = ran:Float(-180, 180)
        end
        local vx, vy = cos(angle) * 0.01, sin(angle) * 0.01
        task.New(unit, function()
            for _ = 1, 120 do
                unit.vx, unit.vy = vx, vy
                vx, vy = vx + cos(angle) * 0.01, vy + sin(angle) * 0.01
                task.Wait()
            end
        end)
    end
    return activate
end

local function red_magic_spawn_mids()
    local units = {}
    for round = 1, 20 do
        for index = #red_magic_huges, 1, -1 do
            local huge = red_magic_huges[index]
            if IsValid(huge) then
                units[#units + 1] = New(red_magic_mid, huge.x, huge.y,
                        ran:Float(-180, 180))
            else
                table.remove(red_magic_huges, index)
            end
        end
        if round < 20 then
            task.Wait(10)
        end
    end
    return units
end

local function red_magic_bullet(owner, angle, speed, duration, speed_delta, angle_delta, sound)
    local huge = New(red_magic_huge, owner.x, owner.y, angle, speed,
            duration or 0, speed_delta or 0, angle_delta or 0)
    red_magic_huges[#red_magic_huges + 1] = huge
    if sound then
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end
end

local function red_magic_sub41()
    return red_magic_spawn_mids()
end

local function red_magic_activate_mids(units, distance_mode)
    local activate = red_magic_mid_activate(distance_mode)
    for _, unit in ipairs(units) do
        activate(unit)
    end
end

local function red_magic_circle(owner, count, layers, speed, layer_speed, angle,
        layer_angle, duration, speed_delta, angle_delta)
    for layer = 0, layers - 1 do
        for i = 0, count - 1 do
            red_magic_bullet(owner,
                    angle + i * 360 / count + layer * layer_angle,
                    speed + (layer_speed - speed) * layer / layers,
                    duration, speed_delta, angle_delta, layer == 0 and i == 0)
        end
    end
end

local red_card = boss.card.New("「红色的幻想乡」", 140, 140, 140, 2000)
local function wait_card(self)
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
    task.MoveTo(0, 120, 60, 2)
end

function red_card:before()
    red_magic_huges = {}
    wait_card(self)
end

function red_card:init()
    task.New(self, function()
        task.Wait(180)
        while true do
            local phase = ran:Float(-180, 180)

            red_magic_circle(self, 14, 4, 4.0, 1.8, phase, -18)
            red_magic_activate_mids(red_magic_sub41(), false)
            red_magic_circle(self, 10, 1, 2.0, 2.0, phase + 18, 0,
                    80, 0.023, -0.024543693)
            red_magic_activate_mids(red_magic_sub41(), true)
            task.Wait(60)

            red_magic_circle(self, 17, 1, 2.0, 2.0, phase + 18, 0,
                    60, 0.026, 0.024543693)
            red_magic_activate_mids(red_magic_sub41(), false)
            task.Wait(50)
            red_magic_circle(self, 16, 1, 1.0, 1.0, phase + 18, 0,
                    80, 0.023, -0.024543693)
            red_magic_activate_mids(red_magic_sub41(), true)
            task.Wait(60)
        end
    end)
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


boss.Define("1a", "蕾米莉亚·斯卡蕾特", "TH08_NEW_3", TH08_bg,
        { 0, 384 }, TH08["SCBG-LW13"], "Remilia", 30)

boss.card.add({ { red_card, "1a" } }, 30, "「红色的幻想乡」", 369)

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
