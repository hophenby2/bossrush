---=====================================
---TH22  西行庭：幽幽子 Lunatic 符卡
---  以 FDF2 源码中的 Batch/Barrage 语义逐卡推导：
---  Batch 负责发射器运动与周期，Barrage 才拥有速度向量、
---  加速度向量、朝向和事件。这里直接用 LuaSTG 任务、
---  NewSimpleBullet 与运动回调复刻，不携带数据解释器。
---=====================================

local class = {}
_editor_class["TH22"] = class

local bullet, object, boss, sp = bullet, object, boss, sp
local task, ran, New = task, ran, New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local Angle, Dist = Angle, Dist
local sin, cos, min, max, abs, int = sin, cos, min, max, abs, int

---FDF2 是 640x480、左上原点。这里按 Boss Rush 可玩区域换算。
local function map_x(x)
    return x * 0.6 - 192
end

local function map_y(y)
    return y * 448 / 480 - 224
end

---普通直行弹。angle 为 FDF2 角度：0 右、90 下、180 左、270 上。
local function fdf_bullet(style, col, x, y, angle, speed, omiga, update)
    local wrapped = update and function(obj)
        update(obj, obj.timer or 0)
    end or nil
    return NewSimpleBullet(style, col, x, y, speed or 0, angle, false,
            omiga or 0, true, true, nil, nil, wrapped)
end

---把延迟后的目标速度写成帧内平滑，对应子弹事件的“变化到”。
local function speed_to_bullet(style, col, x, y, angle, speed, delay, target,
                               ramp, omiga)
    local function update(o, t)
        if t > (delay or 0) and target then
            local v = GetV(o)
            local d = target - v
            ramp = ramp or 60
            if abs(d) > abs(target * 0.01) then
                SetV(o, v + d / ramp, angle, true)
            else
                SetV(o, target, angle, true)
            end
        end
    end
    return fdf_bullet(style, col, x, y, angle, speed, omiga, update)
end

---加速度向量弹，对应“子弹加速度/子弹加速度方向”。
local function accel_bullet(style, col, x, y, angle, speed, delay, accel,
                            accel_angle)
    local function update(o, t)
        if t > delay then
            o.vx = o.vx + cos(accel_angle) * accel
            o.vy = o.vy + sin(accel_angle) * accel
        end
    end
    return fdf_bullet(style, col, x, y, angle, speed, 0, update)
end

---均匀环/扇。FDF2 的角度均分公式与这里一致。
local function fdf_ring(master, style, col, count, angle, spread, speed,
                        omiga, update)
    for i = 0, count - 1 do
        local a = spread >= 360 and (angle + i * 360 / count)
                or (angle + (i - (count - 1) / 2) * spread / count)
        fdf_bullet(style, col, master.x, master.y, a, speed, omiga, update)
    end
end

---绑定发射器：FDF2 把小发射器绑在已有弹上，这里用幽灵对象表达。
class["TH22-carrier"] = Class(object, {
    init = function(self, x, y, angle, speed, interval, child_angle,
                    child_speed, style, col)
        self.x, self.y = x, y
        self.angle = angle
        self.vx, self.vy = cos(angle) * speed, sin(angle) * speed
        self.interval = interval
        self.child_angle = child_angle
        self.child_speed = child_speed
        self.style, self.col = style, col
        self.group = GROUP.GHOST
        self.layer = LAYER.ENEMY_BULLET_EF
    end,
    frame = function(self)
        self.x = self.x + self.vx
        self.y = self.y + self.vy
        if self.timer % self.interval == 0 then
            fdf_bullet(self.style, self.col, self.x, self.y,
                    self.child_angle, self.child_speed)
        end
        if self.y < lstg.world.b - 48 or self.y > lstg.world.t + 48
                or self.x < lstg.world.l - 96 or self.x > lstg.world.r + 96 then
            object.RawDel(self)
        end
    end,
})

---boss 缓慢在 FDF2 Center 的范围内移动；“范围移动”是随机场地移动。
local function wander(self, x1, x2, y1, y2, time)
    local tx = ran:Float(map_x(x1), map_x(x2))
    local ty = ran:Float(map_y(y1), map_y(y2))
    task.MoveTo(tx, ty, time, 3)
end

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th22_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1)
end

boss.Define("1a", "西行寺幽幽子", "TH22_0", TH22_bg, { 0, 320 }, class["SCBG1"], "Yuyuko", 27)

---============================
---[1] 「无垢梦世界」 b620
---============================
do
    local sc = boss.card.New("「无垢梦世界」", 1, 8, 50, 22500)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 331)
    function sc:before()
        task.MoveTo(0, map_y(144), 60, 2)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 160 then
                    fdf_bullet(butterfly, 2, self.x, self.y, 90, 1.3, 6)
                end
                task.Wait(11)
            end
        end)
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 160 then
                    fdf_bullet(sakura, 3, self.x, self.y, 270, 1.8, -6)
                end
                task.Wait(7)
            end
        end)
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 180 then
                    fdf_bullet(ball_small, 4, self.x, self.y, 90, 1.0, 6)
                end
                task.Wait(20)
            end
        end)
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 1860 then
                    fdf_ring(self, flower2, 5, 5, 90, 360, 0.01, 6,
                            function(o, t)
                                if t > 60 then
                                    local v = GetV(o)
                                    if v < 2 then SetV(o, v + 0.033, o.rot, true) end
                                end
                            end)
                end
                task.Wait(12)
            end
        end)
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 2460 then
                    fdf_ring(self, butterfly, 6, 31, Angle(self, player), 360,
                            4.0, 6, function(o, t)
                                if t > 60 then
                                    local v = GetV(o)
                                    if v > 2 then SetV(o, v - 0.033, o.rot, true) end
                                end
                            end)
                end
                task.Wait(60)
            end
        end)
    end
end

---[2] 「往生之灯，来世之花」 b657
do
    local sc = boss.card.New("「往生之灯，来世之花」", 1, 8, 60, 23000)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 332)
    function sc:before()
        task.MoveTo(0, map_y(144), 60, 2)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 3500 do
                if self.timer >= 31 then
                    speed_to_bullet(flower2, 2, map_x(50), lstg.world.b + 18,
                            270, 0.001, 300, 1.42, 60)
                    speed_to_bullet(sakura, 5, map_x(460), lstg.world.b + 18,
                            270, 0.001, 360, 1.5, 60)
                end
                task.Wait(11)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                if self.timer >= 31 then
                    fdf_bullet(butterfly, 6, map_x(50), lstg.world.t - 18,
                            90, 0.001)
                    fdf_bullet(butterfly, 3, map_x(460), lstg.world.t - 18,
                            90, 1.0)
                end
                task.Wait(11)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                fdf_ring(self, star_small, 2, 3, 0, 360, 1.0)
                task.Wait(6)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                if self.timer >= 1 and self.timer <= 180 then
                    New(class["TH22-carrier"], map_x(60), map_y(-40), 90,
                            4.2, 8, 0, 2.2, ball_mid, 4)
                end
                if self.timer >= 600 and self.timer <= 780 then
                    New(class["TH22-carrier"], map_x(572), map_y(-40), 90,
                            4.2, 10, 180, 2.2, ball_mid, 5)
                end
                task.Wait(24)
            end
        end)
    end
end

---[3] 故国「永无归日纹」 b654
do
    local sc = boss.card.New("故国「永无归日纹」", 1, 8, 50, 22500)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 333)
    function sc:before()
        task.MoveTo(0, map_y(145), 60, 2)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 400 then
                    local phase = (self.timer - 400) % 160
                    local r = 230 * sin(phase * 180 / 160)
                    local x = map_x(315) + r
                    local y = map_y(12) + (self.timer - 400) * 3.6
                    if y < lstg.world.b then
                        local v = 3.6 + 0.5 * sin((self.timer % 60) * 6)
                        fdf_bullet(ball_mid, 2, x, y, 90, v, 2)
                        fdf_bullet(ball_small, 5, x, y, 90, v, 2)
                        fdf_bullet(sakura, 7, x, y, 90, v, 2)
                    end
                end
                task.Wait(19)
            end
        end)
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 151 then
                    fdf_ring(self, star_big, 3, 1, 270, 180, 0.01, nil,
                            function(o, t)
                                if t < 120 then
                                    SetV(o, max(0.001, 0.01 * (1 - t / 120)),
                                            o.rot, true)
                                end
                            end)
                end
                task.Wait(1)
            end
        end)
        task.New(self, function()
            while self.timer <= 2900 do
                local targets = { 5, 4, 3, 2 }
                local speed = targets[(self.timer % 4) + 1] or 5
                fdf_ring(self, flower2, 4, 29, 90, 360, 1.0, 5,
                        function(o, t)
                            if t > 120 and t < 180 then
                                local v = GetV(o)
                                SetV(o, v + (speed - v) / 60, o.rot, true)
                            end
                        end)
                task.Wait(1)
            end
        end)
        task.New(self, function()
            while self.timer <= 2900 do
                if self.timer >= 720 then
                    fdf_ring(self, ball_mid, 6, 12, 90, 360, 3.5)
                end
                task.Wait(180)
            end
        end)
    end
end

---[4] 死游戏「我楽多地狱」 b656
do
    local sc = boss.card.New("死游戏「我楽多地狱」", 1, 8, 60, 26000)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 334)
    function sc:before()
        wander(self, 260, 370, 176, 175, 60)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 3500 do
                local t = self.timer
                if t >= 121 then
                    fdf_ring(self, ball_small, 2, 16, 270, 180, 1.5, 10)
                end
                if t >= 241 then
                    fdf_ring(self, ball_small, 4, 16, 270, 180, 1.5, -10)
                end
                if t >= 1 then
                    fdf_ring(self, butterfly, 3, 30, 90, 360, 2.0, 10)
                    fdf_ring(self, butterfly, 5, 30, 90, 360, 2.0, -10)
                end
                task.Wait(1)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                local t = self.timer
                if t >= 1 then
                    for _, a in ipairs({ 0, 180 }) do
                        accel_bullet(star_small, 6, self.x, self.y, a, 0.01,
                                61, 0.135, a + 90)
                    end
                end
                if t >= 181 then
                    fdf_ring(self, star_big, 7, 22, 90, 180, 1.5, 16)
                end
                task.Wait(5)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                if self.timer % 300 >= 180 and self.timer % 300 <= 212 then
                    fdf_ring(self, ball_mid, 2, 2, 90, 360, 0.01, nil,
                            function(o, t)
                                if t == 121 then SetV(o, 2, 260, true) end
                                if t > 121 and t < 181 then
                                    SetV(o, GetV(o) + 0.135, 260, true)
                                end
                            end)
                end
                task.Wait(1)
            end
        end)
    end
end

---[5] 幽舞「桜华烂漫·心中」 b659
do
    local sc = boss.card.New("幽舞「桜华烂漫·心中」", 1, 8, 60, 24000)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 335)
    function sc:before()
        wander(self, 260, 370, 146, 142, 60)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 3500 do
                local targets = { 2.5, 2.0, 1.5 }
                for k = 1, 3 do
                    local target = targets[k]
                    fdf_ring(self, k == 1 and sakura or butterfly, 2 + k,
                            13, Angle(self, player), 360, 0.6, 10,
                            function(o, bt)
                                if bt > 60 and bt < 120 then
                                    SetV(o, GetV(o) + (target - GetV(o)) / 60,
                                            o.rot, true)
                                end
                            end)
                end
                task.Wait(300)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                local side = (self.timer % 50 < 25) and 0 or 180
                fdf_ring(self, flower2, 3, 1, side, 360, 0.01, 7,
                        function(o, bt)
                            if bt > 61 and bt < 189 then
                                SetV(o, GetV(o) + 1 / 128, side, true)
                            end
                            if bt >= 480 then SetV(o, 0.01, side, true) end
                        end)
                task.Wait(25)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                local t = self.timer
                if t >= 301 then
                    fdf_ring(self, sakura, 4, 9, 0, 360, 0.01, nil,
                            function(o, bt)
                                if bt > 1 and bt < 561 then
                                    SetV(o, GetV(o) + 3 / 560, o.rot, true)
                                end
                                if bt > 141 then SetV(o, GetV(o), 120, true) end
                            end)
                    fdf_ring(self, flower2, 6, 9, 180, 360, 0.01, nil,
                            function(o, bt)
                                if bt > 1 and bt < 561 then
                                    SetV(o, GetV(o) + 3 / 560, o.rot, true)
                                end
                                if bt > 141 then SetV(o, GetV(o), -120, true) end
                            end)
                end
                if t == 300 or t == 900 or t == 1500 then
                    accel_bullet(ball_small, 5, self.x, self.y, 90, 0.4, 31,
                            0.03, 90)
                end
                task.Wait(600)
            end
        end)
        task.New(self, function()
            while self.timer <= 3500 do
                if self.timer == 1800 then
                    local targets = { 3.0, 2.5, 3.5 }
                    for k, target in ipairs(targets) do
                        fdf_ring(self, butterfly, 2 + k, 37,
                                Angle(self, player), 360, 0.2, nil,
                                function(o, bt)
                                    if bt > 360 and bt < 390 then
                                        SetV(o, GetV(o) + (target - GetV(o)) / 30,
                                                o.rot, true)
                                    end
                                end)
                    end
                    break
                end
                task.Wait(1)
            end
        end)
    end
end

---[6] 诱魂「彷徨的空蝉」 b652
do
    local sc = boss.card.New("诱魂「彷徨的空蝉」", 1, 8, 62, 34000)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 336)
    function sc:before()
        task.MoveTo(0, map_y(145), 60, 2)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 3700 do
                local t = self.timer
                if t >= 31 and t <= 151 then
                    fdf_ring(self, ball_mid, 2, 31, 90, 360, 0.95, -22,
                            function(o, bt)
                                if bt > 120 and bt < 180 then
                                    SetV(o, GetV(o) + 0.00917, o.rot, true)
                                end
                            end)
                    fdf_ring(self, ball_mid, 5, 31, 270, 360, 0.95, 22)
                end
                if t >= 480 and t <= 780 then
                    fdf_ring(self, ball_small, 4, 21, Angle(self, player),
                            360, 2.5)
                end
                task.Wait(12)
            end
        end)
        task.New(self, function()
            while self.timer <= 3700 do
                if self.timer >= 1 and self.timer <= 420 then
                    fdf_ring(self, star_small, 3, 90, 360, 360, 0.5, nil,
                            function(o, bt)
                                if bt == 81 then SetV(o, 1.4, 0, true) end
                                if bt > 81 then
                                    o.vx = o.vx + cos(0) * 0.008
                                    o.vy = o.vy + sin(0) * 0.008
                                end
                            end)
                    fdf_ring(self, flower2, 6, 36, 0, 360, 0.5, nil,
                            function(o, bt)
                                if bt > 81 and bt < 201 then
                                    SetV(o, GetV(o) + 0.033, 120, true)
                                end
                            end)
                end
                task.Wait(420)
            end
        end)
        task.New(self, function()
            while self.timer <= 3700 do
                if self.timer >= 480 and self.timer <= 780 then
                    fdf_ring(self, ball_small, 2, 21, Angle(self, player),
                            360, 2.0)
                end
                task.Wait(12)
            end
        end)
    end
end

---[7] 「西行庭千本桜図」 b660
do
    local sc = boss.card.New("「西行庭千本桜図」", 1, 10, 38, 1000000)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 337)
    function sc:before()
        task.MoveTo(0, map_y(145), 60, 2)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 2200 do
                local t = self.timer
                if t <= 120 then
                    for i = 0, 2 do
                        fdf_bullet(ball_small, 2, self.x + (i - 1) * 48,
                                lstg.world.b - 12, 270, 5.0)
                    end
                end
                if t >= 182 then
                    local cycles = {
                        { 6, 50, 90, 220, 0.45 }, { 7, 30, 90, 260, 0.8 },
                        { 7, 40, 90, 220, 1.0 }, { 8, 75, 270, 220, 1.0 },
                        { 9, 60, 90, 290, 0.4 }, { 9, 70, 90, 290, 1.0 },
                    }
                    for _, c in ipairs(cycles) do
                        fdf_ring(self, flower2, 3, c[1], c[3], c[4], 0.01,
                                nil, function(o, bt)
                                    if bt > 261 then
                                        SetV(o, GetV(o) + c[5] / 360,
                                                o.rot, true)
                                    end
                                end)
                    end
                end
                if t >= 510 then
                    fdf_ring(self, sakura, 5, 8, 0, 360, 8.0, 15.65)
                end
                task.Wait(4)
            end
        end)
    end
end

---[8] 终焉「千桜华宴」 b673
do
    local sc = boss.card.New("终焉「千桜华宴」", 1, 10, 103, 74000)
    boss.card.add({ { sc, "1a" } }, 27, sc.name, 338)
    function sc:before()
        task.MoveTo(0, map_y(145), 60, 2)
    end
    function sc:init()
        task.New(self, function()
            while self.timer <= 6100 do
                local t = self.timer
                if t % 200 == 1 then
                    fdf_ring(self, ball_mid, 2, 1, 0, 360, 1.0)
                    fdf_ring(self, ball_mid, 5, 1, 180, 360, 1.0)
                end
                if t >= 100 and (t - 100) % 200 == 1 then
                    fdf_ring(self, flower2, 3, 1, 90, 180, 0.01, nil,
                            function(o, bt)
                                if bt > 112 and bt < 118 then
                                    SetV(o, GetV(o) + 0.1, o.rot, true)
                                end
                            end)
                end
                if t >= 1 and (t - 1) % 200 == 1 then
                    fdf_ring(self, ball_small, 2, 2, 90, 360, 0.01, nil,
                            function(o, bt)
                                if bt > 112 and bt < 118 then
                                    SetV(o, GetV(o) + 0.1, 90, true)
                                end
                            end)
                end
                if t >= 220 and t <= 700 then
                    if (t - 220) % 24 == 1 then
                        fdf_ring(self, ball_small, 2, 2, 90, 180, 1.0)
                        fdf_ring(self, flower2, 4, 5, 90, 360, 0.6, nil,
                                function(o, bt)
                                    if bt == 350 then SetV(o, 1.0, o.rot, true) end
                                    if bt > 360 then
                                        o.vx = o.vx + cos(90) * 0.004
                                        o.vy = o.vy + sin(90) * 0.004
                                    end
                                end)
                    end
                end
                if t >= 920 and t <= 1400 then
                    if (t - 920) % 24 == 1 then
                        fdf_ring(self, ball_small, 5, 2, 90, 180, 1.0)
                        fdf_ring(self, flower2, 6, 5, 90, 360, 0.6, nil,
                                function(o, bt)
                                    if bt == 351 then SetV(o, 0.3, o.rot, true) end
                                    if bt > 360 then
                                        o.vx = o.vx + cos(90) * 0.004
                                        o.vy = o.vy + sin(90) * 0.004
                                    end
                                end)
                    end
                end
                if t % 160 == 1 then
                    fdf_ring(self, ball_mid, 4, 45, Angle(self, player), 360, 1.0)
                end
                task.Wait(1)
            end
        end)
    end
end
