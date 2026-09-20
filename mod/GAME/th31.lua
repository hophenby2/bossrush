---=====================================
---TH31  永夜LastWord
---  重新按 TH08 v0x800 ECL 与 th08full 解释器移植：
---  · opcode 97 = 固定角扇形弹；opcode 99 = 固定角圆弹；
---    opcode 111 = 弹速变换（减速 / 定角加速度 / 切向加速度 / 定时静止）。
---  · ECL 坐标是 384×448 游戏区（中心 192,224）；本项目宽 384。
---    因 此统一用 0.6 缩放速度与半径，角度按 LuaSTG 度数换算。
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
local cos, sin = cos, sin
local Angle = Angle
local Dist = Dist

local ball_small = ball_small
local ball_mid = ball_mid
local ellipse = ellipse
local knife = knife
local grain_a = grain_a
local star_small = star_small

local TH08_SC = _editor_class["TH08"] or {}
local TH07_SC = _editor_class["TH07"] or {}

local function deg(rad)
    return rad * 180 / math.pi
end

local function set_v(owner, speed, angle)
    object.SetV(owner, speed, angle or owner.rot, true)
end

local function fan(style, color, owner, count, speed, angle, step, hook)
    for i = 0, count - 1 do
        local spread = int((i + 1) / 2) * step
        if i % 2 == 0 then
            spread = -spread
        end
        local a = angle + spread
        NewSimpleBullet(style, color, owner.x, owner.y, speed, a,
                false, 0, false, false, false, false, hook)
    end
end

local function circle(style, color, owner, count, speed, angle, step, ring, hook)
    ring = ring or 1
    for j = 0, ring - 1 do
        local v = ring > 1 and (speed - j * ((speed - 0.5) / ring)) or speed
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

local function add_card(name, id, letter, owner, bg, time)
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
            local hook = function(b)
                b.th31_wait = 45
                b.frame_other = function(o)
                    if o.th31_wait > 0 then
                        o.th31_wait = o.th31_wait - 1
                        set_v(o, 0)
                    else
                        set_v(o, min(1.2 + 0.012, 2.4))
                    end
                end
            end
            circle(ball_small, 4, self, 16, 1.2, angle, 15, 1, hook)
            angle = angle + 14
            spin = spin + 1
            PlaySound("tan00", 0.05, 0, true)
            task.Wait(spin < 8 and 7 or 12)
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
    local hook = function(b)
        b.th31_wait = 40
        b.frame_other = function(o)
            if o.th31_wait > 0 then
                o.th31_wait = o.th31_wait - 1
                set_v(o, 0)
            else
                set_v(o, min(1.9 + 0.020, 2.0))
            end
        end
    end
    while true do
        fan(ellipse, 5, self, 10, 1.9, Angle(self.x, self.y, player.x, player.y), 15, hook)
        task.Wait(30)
    end
end)

-- 207 日出づる国の天子
add_card("「日出之国的天子」", 353, "1c", function(self)
    task.Wait(110)
    task.New(self, function()
            local hook = function(b)
                b.th31_wait = 52
                b.frame_other = function(o)
                    if o.th31_wait > 0 then
                        o.th31_wait = o.th31_wait - 1
                        set_v(o, 0)
                    else
                        set_v(o, 0.55 * 1.45)
                    end
                end
        end
        local groups = { { x = -60, a = -90 }, { x = 60, a = -90 }, { x = 0, a = 0 } }
        while true do
            for _, g in ipairs(groups) do
                for n = 1, 3 do
                    local a = g.a + (n - 2) * 120
                    for i = -1, 1 do
                        local b = NewSimpleBullet(ball_mid, 6, g.x, 168, 0.55, a + i * 4.5,
                                false, 0, false, false, false, false, hook)
                        b._r, b._g, b._b = 236, 188, 120
                    end
                end
            end
            task.Wait(120)
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
    local burst
    burst = function(angle, count, color)
        circle(ball_mid, color or 6, self, count, 3.1, angle, 5.625, 1)
    end
    while true do
        local aim = Angle(self.x, self.y, player.x, player.y)
        burst(aim, 128, 8)
        task.Wait(30)
        task.MoveTo(-20, 150, 45, 2)
        task.Wait(45)
        burst(aim + 45, 128, 12)
        burst(aim - 45, 128, 4)
        task.Wait(30)
        task.MoveTo(20, 150, 45, 2)
        task.Wait(45)
        burst(aim, 44, 8)
        burst(aim + 180, 44, 4)
        task.Wait(120)
    end
end)

-- 209 天網蜘網捕蝶の法
add_card("「天网蛛网捕蝶之法」", 355, "1e", function(self)
    task.Wait(110)
    task.New(self, function()
        local angle = Angle(self.x, self.y, player.x, player.y) - 22.5
        while true do
            circle(ball_small, 4, self, 10, 1.1, angle, 0, 1)
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
            local angle = i * 45
            local hook = function(b)
                b.th31_delay = 110 + i * 10
                b.th31_a = angle + 180
                b.frame_other = function(o)
                    if o.timer >= o.th31_delay then
                        set_v(o, 1.8, o.th31_a)
                        o.th31_delay = 999999
                    end
                end
            end
            table.insert(hooks, hook)
        end
        while true do
            for i, hook in ipairs(hooks) do
                local b = NewSimpleBullet(star_small, 7, self.x, self.y, 1.7, i * 45,
                        false, 0, false, false, false, false, hook)
                b._r, b._g, b._b = 180, 255, 190
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
        local turn = 0
        while true do
            local base = Angle(self.x, self.y, player.x, player.y)
            for i = 0, 7 do
                local hook = function(b)
                    b.th31_turn = turn + 1
                    b.frame_other = function(o)
                        if o.timer == 42 then
                            set_v(o, 1.05, base + 90)
                        elseif o.timer == 90 then
                            set_v(o, 1.45, base + 180)
                        elseif o.timer == 145 then
                            set_v(o, 1.8, base)
                        end
                    end
                end
                NewSimpleBullet(grain_a, 5 + (turn % 3), self.x, self.y, 1.05, base + i * 45,
                        false, 0, false, false, false, false, hook)
            end
            turn = turn + 1
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
        local phase = 0
        while true do
            for side = -1, 1, 2 do
                local x = side * 126
                for i = 0, 47 do
                    local b = NewSimpleBullet(knife, 7, x, 170, 2.4,
                            side < 0 and 0 or 180, false, 0, false, false, false, false,
                            function(o)
                                if o.timer == 38 then
                                    set_v(o, 1.15, Angle(o.x, o.y, player.x, player.y) + phase)
                                end
                            end)
                    b.omiga = side * 1.4
                end
            end
            phase = phase + 17
            task.Wait(240)
        end
    end)
end)

-- 213 無何有浄化
add_card("「无何有净化」", 359, "1i", function(self)
    task.Wait(110)
    task.New(self, function()
        local angle = 90
        while true do
            for i = 1, 3 do
                local b = NewSimpleBullet(ball_mid, 6, self.x, self.y, 0.35, angle + i * 120,
                        false, 0, false, false, false, false, function(o)
                            if o.timer < 64 then
                                set_v(o, 0.35 + o.timer * 0.014)
                            end
                        end)
                b._r, b._g, b._b = 170, 230, 255
            end
            angle = angle + 12
            task.Wait(120)
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
    while true do
        for pass = 1, 2 do
            local hook = function(b)
                b.th31_wait = pass * 90
                b.frame_other = function(o)
                    if o.th31_wait > 0 then
                        o.th31_wait = o.th31_wait - 1
                        set_v(o, 0)
                    else
                        set_v(o, 1.5)
                    end
                end
            end
            fan(knife, 6, self, 20, 1.8, 90, 5.625, hook)
            task.Wait(120)
        end
        task.MoveTo(ran:Float(-130, 130), ran:Float(75, 145), 45, 2)
    end
end, 131)

-- 217 待宵反射衛星斬
add_card("「待宵反射卫星斩」", 363, "1m", function(self)
    task.Wait(110)
    task.New(self, function()
        while true do
            local aim = Angle(self.x, self.y, player.x, player.y)
            circle(ellipse, 6, self, 6, 0, aim, 11.25, 1, function(o)
                if o.timer == 10 then
                    set_v(o, 0.28, aim)
                end
            end)
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
                circle(ellipse, 4, self, 2, 1.4, angle, 6, 1, function(o)
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
