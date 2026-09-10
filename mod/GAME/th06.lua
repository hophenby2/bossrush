local class = {}
_editor_class["TH06"] = class

local cos, sin, abs, min, max, sign = cos, sin, abs, min, max, sign
local bullet, object, laser, boss = bullet, object, laser, boss
local task, ran, Create, sp = task, ran, Create, sp
local table = table
local GROUP, LAYER, COLOR = GROUP, LAYER, COLOR
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out
local servant = SimpleServant

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_1", true, 0, 0, 0, -0.04, 0.07, 0, "mul+add", 1, 1)
    _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, 0, -0.07, 0, "", 1, 1)
end
class["SCBG2"] = Class(_SC_BG)
class["SCBG2"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_3", false, 0, 0, 0, 0, 0, 0.3, "mul+add", 3, 3)
    _SC_BG.AddLayer(self, "th06_4", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1)
    _SC_BG.AddLayer(self, "th06_2", true, 0, 0, 0, 0, 0, 0, "", 1, 1)
end
class["SCBG3"] = Class(_SC_BG)
class["SCBG3"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_5", false, 0, 0, 0, 0, 0, -0.5, "", 2.3, 2.3)
    _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2, 2)
    _SC_BG.AddLayer(self, "th06_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
end
class["SCBG4"] = Class(_SC_BG)
class["SCBG4"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2, 2)
    _SC_BG.AddLayer(self, "th06_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
end
class["SCBG5"] = Class(_SC_BG)
class["SCBG5"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 3, 3)
    _SC_BG.AddLayer(self, "th06_7_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1, function(unit)
        unit.r = 128
        unit.g = 128
        unit.b = 128
    end)
end
do
    boss.Define("1a", "露米娅", "TH06_0", TH06_bg, { 240, 384 }, class["SCBG1"], "Rumia", 1)
    boss.Define("1b", "琪露诺", "TH06_0", TH06_bg, { -240, 384 }, class["SCBG1"], "Chiruno", 1)
    local name = "暗冰符「零下的赝光」"
    local sc1 = boss.card.New(name, 1, 1, 60, 600)
    local sc2 = boss.card.New(name, 1, 1, 60, 600)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 1, name, 1)

    function sc1:before()
        task.MoveTo(0, 150, 60, 2)
    end
    function sc1:init()
        local T = false
        task.New(self, function()
            local A
            local d = 1
            while true do
                PlaySound("boon01", 0.1, self.x / 256, false)
                A = Angle(self, player)
                for D = -1, 1, 2 do
                    for r = 0, 22, 11 do
                        object.Connect(self, New(class["obj0-1"], self.x, self.y, A, D, r), 0, true)
                    end
                end
                task.Wait(100)
                Newcharge_in(self.x, self.y, 255, 227, 132)

                task.Wait(60)
                for _ = 1, 60 do
                    for _ = -1, 1, 2 do
                        for r = 0, 22, 11 do
                            New(class["bullet0-2"], self.x, self.y, A, d, r, ran:Int(1, 2))
                            if T then
                                New(class["bullet0-2"], self.x, self.y, -A, d, r, ran:Int(1, 2))
                            end
                        end
                    end
                    task.Wait(2)
                    A = A + 7 * d
                end
                task.MoveToPlayer(60, -120, 120, 70, 130, 20, 40, 8, 16, 2, 1)
                task.Wait(100)
                d = -d
            end
        end)
        task.New(self, function()
            boss.violent(self)
            T = true
        end)
    end
    function sc2:before()
        task.MoveTo(0, 100, 60, 2)
    end
    function sc2:init()
        local add = { 0, 0 }
        task.New(self, function()
            local d = 1
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20 + add[1]) do
                    New(class["bullet0-1"], self.x, self.y, 2.5, a, (2 + ran:Float(0.03, 0.1)) * d)
                end
                task.Wait(300 + add[2])
                d = -d
            end
        end)
        task.New(self, function()
            boss.violent(self)
            add = { 20, -100 }
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    New(class["bullet0-1"], self.x, self.y, 2, a, ran:Float(1, 3) * ran:Sign())
                end
                task.Wait(300)
            end
        end)
        task.New(self, function()
            task.Wait(120)
            while true do
                task.MoveToPlayer(60, -120, 120, 0, 70, 20, 40, 8, 16, 2, 1)
                task.Wait(180)
            end
        end)
    end

end--boss1

do
    boss.Define("2a", "红美铃", "TH06_0", TH06_bg, { -350, 120 }, class["SCBG2"], "Meirin", 1)
    boss.Define("2b", "帕秋莉·诺蕾姬", "TH06_0", TH06_bg, { 350, 120 }, class["SCBG2"], "Knowledge", 1)
    local name = "金华「彩虹华色」"
    local sc1 = boss.card.New(name, 1, 1, 60, 650)
    local sc2 = boss.card.New("金华「彩虹华色」", 1, 1, 60, 650)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 1, name, 2)
    function sc1:before()
        task.MoveTo(-70, 100, 60, 2)
    end
    function sc1:init()
        local r = 1
        local w = 100
        local w2 = 80
        task.New(self, function()
            boss.violent(self)
            r = 2

            w = 60
            w2 = 41
        end)
        task.New(self, function()
            local col = { 2, COLOR.ORANGE, COLOR.GOLDEN_YELLOW, COLOR.GREEN, 6, COLOR.CYAN, 4 }
            local d = 1
            local T, l, i
            while true do
                T = ran:Int(1, 7)
                i = 0
                for _ = 1, 30 do
                    for _ = 1, 3 do
                        i = i + 1
                        for c = 0, 1 do
                            l = 120 - c * 60
                            New(class["bullet0-3"], self.x + cos(30 * d * c + 4 * i * d) * l, self.y + sin(30 * d * c + 4 * i * d) * l,
                                    col[(T + c) % 7 + 1], 1 + sin(i * 10 % 180), 4 * i * d, abs(i % 19 - 9) <= r, w2 - c * 15)
                        end

                    end
                    task.Wait()
                end
                task.Wait(w)
                d = -d
            end
        end)
        task.New(self, function()
            task.Wait(120)
            while true do
                task.MoveToPlayer(60, -120, 60, 80, 144,
                        20, 40, 8, 16, 2, 1)
                task.Wait(180)
            end
        end)
    end

    function sc2:before()
        task.MoveTo(70, 100, 60, 2)
    end
    function sc2:init()
        local second = false
        task.New(self, function()
            boss.violent(self)
            second = true
            local a = 0
            for i = 1, _infinite do
                Create.bullet_decel(self.x, self.y, water_drop, 14, 5, 2.5 + sin(i * 3), a, true)
                PlaySound("tan00")
                task.Wait()
                a = a + 17
            end
        end)
        task.New(self, function()
            local t = 30
            while true do
                t = min(t, 50)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                for d = -1, 1, 2 do
                    New(class["laser0-1"], self.x, self.y, Angle(self, player), t, 360 / t, d, 60, 14)
                    if second then
                        New(class["laser0-1"], self.x, self.y, Angle(self, player), t, 360 / t, d, 60, 21)
                    end
                end
                task.Wait(300)
                task.MoveToPlayer(60, 120, -60, 80, 144, 20, 40, 8, 16, 2, 1)
                task.Wait(60)
                t = t + 4
            end
        end)
    end
end

do
    boss.Define("3a", "十六夜咲夜", "TH06_0", TH06_bg, { 0, 384 }, class["SCBG3"], "Sakuya", 1)
    boss.Define("3b", "蕾米莉亚·斯卡蕾特", "TH06_0", TH06_bg, { 0, 384 }, class["SCBG3"], "Remilia", 1)
    boss.Define("3c", "芙兰朵露·斯卡蕾特", "TH06_0", TH06_bg, { 0, 384 }, class["SCBG3"], "Flandre", 1)
    local name = "「互逆的红烛」"
    local sc1 = boss.card.New(name, 1, 1, 80, 600)
    local sc2 = boss.card.New(name, 1, 1, 80, 700)
    local sc3 = boss.card.New(name, 1, 1, 80, 700)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" }, { sc3, "3c" } }, 1, name, 3)
    function sc1:before()
        task.MoveTo(0, 150, 60, 2)
    end
    function sc1:init()
        local inc,
        other,
        tp = 12,
        function()
        end,
        function()
        end
        task.New(self, function()
            boss.violent(self)
            inc = 9
            other = function()
                for i = 1, 20 do
                    for v = 1, 3 do
                        NewSimpleBullet(knife, 2, self.x, self.y, v, i * 18, true)
                    end
                end
            end
            tp = function()
                for i = 1, 10 do
                    for v = 1, 3 do
                        Create.bullet_accel(self.x + cos(i * 36) * (90 + v * 10), self.y + sin(i * 36) * (90 + v * 10), knife,
                                4, 0.1, v, i * 36 + 180)
                        PlaySound("tan00", 0.5, 0, true)
                    end
                end
            end
            boss.violent(self)
            inc = 6
            other = function()
                for i = 1, 25 do
                    for v = 2, 4 do
                        NewSimpleBullet(knife, 2, self.x, self.y, v, i * 360 / 25, true)
                    end
                end
            end
            tp = function(d)
                for i = 1, 12 do
                    for v = 1, 3 do
                        Create.bullet_accel(self.x + cos(i * 30 + v * 5 * d) * (90 + v * 10), self.y + sin(i * 30 + v * 5 * d) * (90 + v * 10), knife,
                                4, 0.1, v, i * 30 + v * 5 * d + 180)
                        PlaySound("tan00", 0.5, 0, true)
                    end
                end
            end
        end)
        task.New(self, function()
            while true do
                CollisionCheck(GROUP.ENEMY_BULLET, GROUP.ENEMY_BULLET2)
                task.Wait()
            end
        end)
        local d = 1
        task.New(self, function()
            while true do
                for _ = 1, 2 do
                    task.New(self, function()
                        task.MoveToPlayer(120, -96, 96, 112, 144,
                                32, 64, 8, 16, 2, 3)
                    end)
                    other()
                    for _ = 1, 10 do
                        NewSimpleBullet(knife, 6, self.x, self.y, 2.5, -20, true).group = GROUP.ENEMY_BULLET2
                        NewSimpleBullet(knife, 6, self.x, self.y, 2.5, 20, true).group = GROUP.ENEMY_BULLET2
                        PlaySound("tan00")
                        task.Wait(inc)
                    end
                end
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 64, 64)
                task.Wait(40)
                tp(d)
                task.Wait(40)
                do
                    local s, _d_s = (0), (90 / 10)
                    for _ = 1, 11 do
                        self.hscale = 1 - 0.5 * sin(s)
                        self.vscale = 1 + 1 * sin(s)
                        player.hscale = 1 - 0.5 * sin(s)
                        player.vscale = 1 + 1 * sin(s)
                        task.Wait()
                        s = s + _d_s
                    end
                end
                New(bullet_cleaner, self.x, self.y, 80, 0, 1, false, false, 0)
                self.x, self.y, player.x, player.y = player.x, player.y, self.x, self.y
                do
                    local s, _d_s = (90), (-90 / 10)
                    for _ = 1, 11 do
                        self.hscale = 1 - 0.5 * sin(s)
                        self.vscale = 1 + 1 * sin(s)
                        player.hscale = 1 - 0.5 * sin(s)
                        player.vscale = 1 + 1 * sin(s)
                        task.Wait()
                        s = s + _d_s
                    end
                end
                task.Wait(88)
                d = -d
            end
        end)
    end
    function sc1:del()
        player.hscale = 1
        player.vscale = 1
        self.hscale = 1
        self.vscale = 1
    end

    function sc2:before()
        task.MoveTo(-50, 100, 60, 2)
    end
    function sc2:init()
        local vio = { w = 2, n = 1, v = 2, wait = 320 }
        task.New(self, function()
            boss.violent(self)
            vio.w = 3
            vio.n = 4
            boss.violent(self)
            vio.w = 4
            vio.n = 9
            vio.v = 3.5
            vio.wait = 80
        end)
        task.New(self, function()
            local list, y, sr = {}
            while true do
                list.d = 0
                y = -224
                sr = 0
                for _ = 1, 60 do
                    for v = 2, 4, 2 / vio.w do
                        New(class["bullet0-4"], -192, y, v, 0, sr, list)
                    end
                    task.Wait()
                    y = y + 448 / 59
                    sr = sr + 720 / 59
                end
                task.Wait(80)
                task.New(self, function()
                    task.MoveTo(50, 100, 30, 2)
                    task.MoveTo(-50, 100, 30, 2)
                    task.MoveTo(50, 100, 30, 2)
                    task.MoveTo(-50, 100, 30, 2)
                end)
                for a = 1, 40 do
                    for i = 1, vio.n do
                        New(class["bullet0-5"], self.x, self.y, vio.v, a * 9 + i * 360 / vio.n)
                    end
                    task.Wait(3)
                end
                task.Wait(vio.wait)
                Newcharge_in(self.x, self.y, 255, 200, 200)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 255, 200, 200)
                list.d = 1
                task.Wait()
                list.d = 0
            end
        end)

    end

    function sc3:before()
        task.MoveTo(50, 100, 60, 2)
    end
    function sc3:init()
        local vio = { w = 2, n = 1, v = 2, wait = 320 }
        task.New(self, function()
            boss.violent(self)
            vio.w = 3
            vio.n = 4
            boss.violent(self)
            vio.w = 4
            vio.n = 9
            vio.v = 3.5
            vio.wait = 80
        end)
        task.New(self, function()
            local list, y, sr = {}
            while true do
                list.d = 0
                y = -224
                sr = 180
                for _ = 1, 60 do
                    for v = 2, 4, 2 / vio.w do
                        New(class["bullet0-4"], 192, y, v, 180, sr, list)
                    end
                    task.Wait()
                    y = y + 448 / 59
                    sr = sr - 720 / 59
                end
                task.Wait(80)
                task.New(self, function()
                    task.MoveTo(-50, 100, 30, 2)
                    task.MoveTo(50, 100, 30, 2)
                    task.MoveTo(-50, 100, 30, 2)
                    task.MoveTo(50, 100, 30, 2)
                end)
                for a = 40, 1, -1 do
                    for i = 1, vio.n do
                        New(class["bullet0-5"], self.x, self.y, vio.v, 180 + a * 9 + i * 360 / vio.n)
                    end
                    task.Wait(3)
                end
                task.Wait(vio.wait)
                Newcharge_in(self.x, self.y, 255, 200, 200)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 255, 200, 200)
                list.d = 1
                task.Wait()
                list.d = 0
            end
        end)

    end

end

do

    boss.Define("4a", "蕾米莉亚·斯卡蕾特", "TH06_1", TH06_bg, { 384, 0 }, class["SCBG3"], "Remilia", 1)
    boss.Define("4b", "芙兰朵露·斯卡蕾特", "TH06_1", TH06_bg, { -384, 0 }, class["SCBG3"], "Flandre", 1)
    local name = "破坏「掌握命运之线」"
    local sc1 = boss.card.New(name, 1, 1, 70, 770)
    local sc2 = boss.card.New(name, 1, 1, 70, 770)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 1, name, 4)
    function sc1:before()
        task.MoveTo(-50, 100, 60, 2)
    end
    function sc1:init()
        local n = 3
        local drot = 120 / 7
        task.New(self, function()
            boss.violent(self)
            n = 4
            drot = 91 / 7
        end)
        task.New(self, function()
            local d = 1
            local s = 75
            local rot, l
            while true do
                rot = ran:Float(0, 360)
                l = 0
                for _ = 1, 150 do
                    for a in sp.math.AngleIterator(rot, n) do
                        Create.bullet_decel(self.x + cos(a + 50 * d) * sin(l) * s, self.y + sin(a + 50 * d) * sin(l) * s, knife, 2, 6, 2.5, a)
                    end
                    PlaySound("tan00")
                    task.Wait()
                    rot = rot + drot
                    l = l + 180 / 149
                end
                rot = ran:Float(0, 360)
                l = 180
                for _ = 1, 150 do
                    for a in sp.math.AngleIterator(rot, n) do
                        Create.bullet_decel(self.x + cos(a - 50 * d) * sin(l) * s, self.y + sin(a - 50 * d) * sin(l) * s, knife, 6, 6, 2.5, a)
                    end
                    PlaySound("tan00")
                    task.Wait()
                    rot = rot - drot
                    l = l + 180 / 149
                end
                d = -d
                task.Wait(120)
                s = min(s + 15, 150)
            end
        end)
        task.New(self, function()
            task.Wait(180)
            while true do
                task.MoveToPlayer(60, -100, 0, 120, 144,
                        32, 64, 10, 20, 2, 1)
                task.Wait(120)
            end
        end)
    end

    function sc2:before()
        task.MoveTo(50, 100, 60, 2)
    end
    function sc2:init()
        local inc = { 19, 150, 5 }
        task.New(self, function()
            boss.violent(self)
            inc = { 10, 80, 12 }
        end)
        task.New(self, function()
            local d = 1
            local a
            while true do
                a = ran:Float(0, 360)
                for _ = 1, 25 do
                    New(class["bullet1-1"], self.x, self.y, a, inc[3])
                    task.Wait(inc[1])
                    a = a + 360 / 25
                end
                task.Wait(inc[2])
                Newcharge_out(self.x, self.y, 255, 200, 200)
                self.d = true
                task.Wait()
                self.d = false
                d = -d
                task.Wait(120)
            end
        end)
        task.New(self, function()
            do
                while true do
                    task.MoveToPlayer(60, 0, 100, 112, 144,
                            32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
                    task.Wait(60)
                end
            end
        end)
    end


end

do
    boss.Define("5a", "蕾米莉亚·斯卡蕾特", "TH06_1", TH06_bg, { 0, 500 }, class["SCBG5"], "Remilia", 1)
    boss.Define("6a", "芙兰朵露·斯卡蕾特", "TH06_1", TH06_bg, { 0, 500 }, class["SCBG5"], "Flandre", 1)

    local sc1_name = "红符「地狱下的伪装」"
    local sc1 = boss.card.New(sc1_name, 2, 2, 60, 690)
    boss.card.add({ { sc1, "5a" } }, 1, sc1_name, 195)
    function sc1:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 140, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 140, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(80)
        self.x, self.y = 0, 140
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)

            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            self.colli = false
            self._wisys:SetImageInList("Remilia2")
            local polarbs = {}
            local function PolarBullet(cx, cy, a, r, o)
                local self = NewObject(Class(bullet, {
                    del = function(unit)
                        bullet.del(unit)
                        for _ = 1, 5 do
                            New(class.revhppar, unit.x, unit.y, self)
                        end
                    end
                }, true))
                bullet.init(self, ball_big, 6, false, true)
                self.x, self.y = cx + cos(a) * r, cy + sin(a) * r
                self._blend = "mul+rev"
                self.bound = false
                self.colli = false
                task.New(self, function()
                    task.Wait(80)
                    self.colli = true
                end)
                self.fogtime = 80
                table.insert(polarbs, self)
                task.New(self, function()
                    while true do
                        self.x, self.y = cx + cos(a) * r, cy + sin(a) * r
                        a = a + o
                        task.Wait()
                    end
                end)
            end
            local function DeadBullet(x, y, v, a)
                local self = NewObject(Class(bullet, {
                    del = function(self)
                        bullet.del(self)
                        local b = Create.bullet_accel(self.x, self.y, arrow_small, 4,
                                0.1, 2, Angle(self, player), true, false)
                        b.group = GROUP.INDES
                    end
                }, true))
                bullet.init(self, arrow_big, 2, false, true)
                object.SetV(self, v, a, true)
                self.x, self.y = x, y
            end
            servant.init(NewObject(servant), self.x, self.y, 0, 250, 128, 114, 1.5, function(self)
                task.New(self, function()
                    self:FadeIn(15)
                    object.ChangingSizeColli(self, -0.5, -0.5, 15)
                end)
                task.New(self, function()
                    local d = 1
                    for i = 0, 17 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 3 + i * 2) do
                            PolarBullet(self.x, self.y, a, i * 37, d * (0.6 - i * 0.04))
                        end
                        d = -d
                        task.Wait(15)
                    end
                end)
            end)
            task.New(self, function()
                while true do
                    task.MoveToPlayer(100, -200, 200, 40, 160,
                            100, 120, 40, 50, 3, 3)
                    task.Wait(100)
                end
            end)
            task.Wait(45)
            while true do
                for a in sp.math.AngleIterator(Angle(self, player), 10) do
                    for z = -2, 2 do
                        DeadBullet(self.x, self.y, 1.2 - abs(z) * 0.05, a + z * 1.3)
                    end
                end
                PlaySound("tan00")
                task.Wait(75)
            end

        end)
    end

    local sc2_name = "禁忌「心境之锁」"
    local sc2 = boss.card.New(sc2_name, 1, 1, 60, 850)
    boss.card.add({ { sc2, "6a" } }, 1, sc2_name, 196)
    function sc2:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(80)
        self.x, self.y = 0, 120
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local smear_mode = "mul+add"
            local smear_color = { 200, 200, 200 }
            local function ball_mid_cre(x, y, v, a)
                local b = Create.bullet_decel(x, y, ball_mid, 4, v, v, a, true, false)
                b.flag = true
                function b:frame_new()
                    bullet.frame(self)
                    object.smear_frame(self, 3)
                end
                function b:render_new()
                    object.smear_render(self, smear_mode, smear_color)
                    bullet.render(self)
                end
                PlaySound("tan00")
            end
            local laser_warning = Class(laser, {
                init = function(self, x, y, a)
                    laser.init(self, 2, x, y, a, 0, 0, 0, 12, 12, 0)
                    laser._TurnHalfOn(self, 0, false)
                    self.line = 0
                    task.New(self, function()
                        for i = 1, 60 do
                            self.line = sin(i * 1.5) * 900
                            task.Wait()
                        end
                        laser._TurnOff(self, 30, true)
                        object.Del(self)
                    end)
                end,
                render = function(self)
                    SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
                    Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot,
                            self.line / 16, 0.25)
                    laser.render(self)
                end
            }, true)
            local d = 1
            while true do

                local rot = 90 - d * 60
                for i = 1, 14 do
                    for a in sp.math.AngleIterator(rot, 20) do
                        ball_mid_cre(self.x + cos(rot) * 25, self.y + sin(rot) * 25, 3, a)
                    end
                    rot = rot + d * 17
                    if i == 8 then
                        d = -d
                    end
                    task.Wait(9)
                end
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.New(self, function()
                    local bx, by = self.x, self.y
                    for i = 1, 120 do
                        i = task.SetMode[2](i / 60)
                        object.BulletDo(function(b)
                            if b.flag then
                                local A = Angle(b, bx, by)
                                b.x = b.x + cos(A) * i * 3
                                b.y = b.y + sin(A) * i * 3
                                if i <= 60 then
                                    object.smear_add(b, 60)

                                end
                            end
                        end)
                        task.Wait()
                    end
                end)
                local x, y = player.x, player.y
                task.New(self, function()
                    for z = -2, 2 do
                        New(laser_warning, self.x, self.y, Angle(self, x, y) + z * 2)

                    end
                    for _ = 1, 5 do
                        NewWave(x, y, 2, 128, 60, 250, 128, 114)
                        task.Wait(3)
                    end
                end)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 250, 128, 114)

                task.New(self, function()
                    task.MoveTo(ran:Float(90, 150) * d, 100, 60, 2)
                end)
                local A = Angle(self, x, y)
                task.New(self, function()
                    local bx, by = self.x, self.y
                    for k = 1, 3 do
                        for i = 1, 10 do

                            for _ = 1, 4 do
                                Create.bullet_decel(bx + ran:Float(-30, 30), by + ran:Float(-30, 30), ellipse,
                                        ran:Int(1, 2), 20 - i * 1.3, 7 - i * 0.6, A + ran:Float(-10, 10), true, false)
                                Create.bullet_accel(bx + ran:Float(-30, 30), by + ran:Float(-30, 30), ball_mid,
                                        ran:Int(1, 2), 0.8, 4 - i * 0.1 - k * 0.6, ran:Float(0, 360), true, false)
                            end
                            Create.bullet_decel(bx + ran:Float(-20, 20), by + ran:Float(-20, 20), ball_huge,
                                    2, 20 - i * 0.8, 12 - i * 0.8, A + ran:Float(-7, 7), true, false)
                        end
                        task.Wait(5)
                    end
                end)

                local R, G, B = sp:HSVtoRGB(0, 0.6, 1)
                NewBon(self.x, self.y, 60, 100, R, G, B)
                for _x = -2, 2 do
                    ParticleLaserLine(R, G, B, self.x + _x * 24 * cos(A + 90), self.y + _x * 24 * sin(A + 90),
                            2, 17 - abs(_x) * 3, A, 40, 16, 10)
                end
                task.Wait(111)
            end
        end)
    end
end

do
    class["laser0-1"] = Class(laser, {
        init = function(self, _x, _y, a, f, aa, d, t, r)
            laser.init(self, COLOR.ORANGE, _x, _y, 0, 0, 0, 0, 6, 4, 0)
            object.SetV(self, 1, a, false)
            self.rot = a
            self.bound = false
            self.line = 0
            self.Isradial = true
            self.radial_v = 8
            task.New(self, function()
                laser._TurnHalfOn(self, 0, false)
                task.New(self, function()
                    if f > 0 then
                        New(class["laser0-2"], self.x + cos(a) * r, self.y + sin(a) * r, a + aa * d, f - 1, aa, d, t + 8, r)
                    end
                    for i = 1, 60 do
                        self.line = sin(i * 1.5) * 500
                        task.Wait()
                    end
                    task.Wait(t - 60)
                    laser._TurnOn(self, 1, true, false)
                    for _ = 1, 50 do
                        self.l3 = self.l3 + 8
                        task.Wait()
                    end
                    for _ = 1, 50 do
                        self.l1 = self.l1 + 8
                        task.Wait()
                    end
                    laser._TurnOff(self, 30, true)
                    object.Del(self)
                end)
                do
                    for i = 1, 60 do
                        object.SetV(self, 1 - i / 60, a, false)
                        task.Wait()
                    end
                end
            end)
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end
    })
    class["laser0-2"] = Class(laser, {
        init = function(self, _x, _y, a, f, aa, d, t, r)
            laser.init(self, COLOR.ORANGE, _x, _y, 0, 0, 0, 0, 6, 4, 0)
            object.SetV(self, 1, a - aa * d, false)
            self.rot = a
            self.bound = false
            self.line = 0
            self.Isradial = true
            self.radial_v = 8
            task.New(self, function()
                laser._TurnHalfOn(self, 30, false)
                task.New(self, function()
                    if f > 0 then
                        New(class["laser0-2"], self.x + cos(a) * r, self.y + sin(a) * r, a + aa * d, f - 1, aa, d, t + 8, r)
                    end
                    for i = 1, 60 do
                        self.line = sin(i * 1.5) * 500
                        task.Wait()
                    end
                    task.Wait(t - 60)
                    laser._TurnOn(self, 1, true, false)
                    for _ = 1, 50 do
                        self.l3 = self.l3 + 8
                        task.Wait()
                    end
                    for _ = 1, 50 do
                        self.l1 = self.l1 + 8
                        task.Wait()
                    end
                    laser._TurnOff(self, 30, true)
                    object.Del(self)
                end)
                do
                    for i = 1, 60 do
                        object.SetV(self, 1 - i / 60, a - aa * d, false)
                        task.Wait()
                    end
                end
            end)
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end
    })
end--laser

do
    class["bullet0-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a, r)
            bullet.init(self, ball_light, COLOR.BLUE, true, true)
            self.x, self.y = _x, _y
            self.r = r
            self.bright = {}
            PlaySound("kira00", 0.1, self.x / 256, false)
            object.SetV(self, v, a, true)
            self.bound = false
            task.New(self, function()
                for _ = 1, 110 do
                    object.SetV(self, v, a, true)
                    task.Wait()
                    a = a + r
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            local a
            for i = 1, 2 do
                a = self.timer * 5 * sign(self.r) + 360 / 2 * i
                table.insert(self.bright, { x = self.x + cos(a) * 13, y = self.y + sin(a) * 13, alpha = 255, a = 0, v = 0 })
            end
            local b
            for i = #self.bright, 1, -1 do
                b = self.bright[i]
                b.alpha = max(0, b.alpha - 7)
                b.x = b.x + cos(b.a) * b.v
                b.y = b.y + sin(b.a) * b.v
                if b.alpha == 0 then
                    table.remove(self.bright, i)
                end
            end
            if Dist(self.x, self.y, 0, 0) > 500 then
                object.Del(self)
            end
        end,
        render = function(self)
            self.class.base.render(self)
            for _, b in ipairs(self.bright) do
                SetImageState('bright', "mul+add", b.alpha, 135, 206, 235)
                Render('bright', b.x, b.y, 0, 0.05)
            end
        end
    })
    class["bullet0-2"] = Class(bullet, { init = function(self, _x, _y, a, d, r, t)
        bullet.init(self, ball_huge, COLOR.RED, true, true)
        self.x, self.y = _x, _y
        PlaySound("tan00", 0.1, self.x / 256, false)
        object.SetV(self, 13, a, true)
        task.New(self, function()
            while true do
                if self.y > 224 or self.y < -224 or self.x > 192 or self.x < -192 then
                    break
                end
                task.Wait()
            end
            if t == 1 then
                Create.bullet_decel(self.x, self.y, ball_big, 14, 5, ran:Float(1, 2), ran:Float(0, 360), false)
                PlaySound("tan00", 0.1, self.x / 256, false)
            end
            object.Del(self)
        end)
        task.New(self, function()
            task.Wait(8)
            local A = self.rot
            for _ = 1, 30 do
                object.SetV(self, 13, A, true)
                task.Wait()
                A = A + 220 / 29 * d
            end
            A = self.rot
            for _ = 1, 10 do
                object.SetV(self, 13, A, true)
                task.Wait()
                A = A + r * d / 9
            end
            task.Wait(280)
            object.Del(self)
        end)
    end })
    class["bullet0-3"] = Class(bullet, { init = function(self, _x, _y, col, v, a, t, dvt)
        bullet.init(self, square, col, false, true)
        self.x, self.y = _x, _y
        --_object.set_color(self, "mul+add", 255, 255, 255, 255)
        if t then
            bullet.ChangeImage(self, square, COLOR.GRAY)
        end
        object.SetV(self, v, a, true)
        PlaySound("tan00", 0.1, self.x / 256, true)
        self.bound = false
        task.New(self, function()
            object.ChangingV(self, v, 0, self.rot, dvt or 80, true, 1)
            task.Wait(30)
            if t then
                for i = 1, 3 do
                    NewSimpleBullet(knife, col, self.x, self.y, 1, self.rot + i * 120, false, 0, true, true)
                end
            end
            object.Del(self)
        end)
    end })
    class["bullet0-4"] = Class(bullet, {
        init = function(self, _x, _y, v, a, sr, list)
            bullet.init(self, ball_mid, COLOR.RED, false, true)
            self.x, self.y = _x, _y
            PlaySound("tan00")
            self.rot = 0
            self.angle = a
            object.SetV(self, v, a)
            self.f = 0
            self.flag = 0
            task.New(self, function()
                for i = 1, 60 do
                    object.SetV(self, v - v * i / 60, self.angle)
                    task.Wait()
                end
                self.flag = 1
            end)
            task.New(self, function()
                while true do
                    if list.d == 1 and self.flag == 1 then
                        break
                    end
                    task.Wait()
                end
                self.f = 1
                self.flag = 0
                for i = 1, 60 do
                    object.SetV(self, i / 60, sr)
                    task.Wait()
                end
            end)
            task.New(self, function()
                while not self.jump do
                    task.Wait()
                end
                self.flag = 0
                PlaySound("kira00")
                bullet.ChangeImage(self, self.imgclass, 10)
                Create.bullet_create_eff(self.x, self.y, self.imgclass, 10)
                object.SetV(self, 0, self.angle)
                for i = 1, 130 do
                    object.SetV(self, 1.2 * i / 130, self.angle)
                    task.Wait()
                end
            end)
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            task.New(self, function()
                if other.group == GROUP.ENEMY_BULLET2 then
                    if self.flag == 1 then
                        self.jump = true
                    end
                    if self.f == 1 then
                        object.Del(self)
                    end
                end
            end)
        end
    })
    class["bullet0-5"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, ball_mid, COLOR.BLUE, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00")
            self.rot = 0
            self.angle = a
            object.SetV(self, v, a)
            self.flag = 1
            task.New(self, function()
                while not self.jump do
                    task.Wait()
                end
                self.flag = 0
                PlaySound("kira00")
                bullet.ChangeImage(self, self.imgclass, 14)
                Create.bullet_create_eff(self.x, self.y, self.imgclass, 14)
                self.angle = Angle(self, player)
                object.SetV(self, 0, self.angle)
                for i = 1, 130 do
                    object.SetV(self, 1.2 * i / 130, self.angle)
                    task.Wait()
                end
            end)
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            task.New(self, function()
                if other.group == GROUP.ENEMY_BULLET2 and self.flag == 1 then
                    self.jump = true
                end
            end)
        end
    })
    class["bullet1-1"] = Class(bullet, {
        init = function(self, _x, _y, a, way)
            bullet.init(self, ball_huge, COLOR.DEEP_PURPLE, true, true)
            self.x, self.y = _x, _y
            self.way = way
            _object.set_color(self, "mul+add", 255, 255, 255, 255)
            object.SetV(self, 3, a, true)
            self.flag = 1
        end,
        frame = function(self)
            self.class.base.frame(self)
            if self.x > 192 or self.x < -192 or self.y > 224 or self.y < -224 then
                object.SetV(self, 0, self.rot, true)
            end
            if _boss.d == true and self.flag > 0 then
                self.flag = 0
                local a = Angle(self.x, self.y, 0, 0)
                for _ = 1, self.way do
                    NewSimpleBullet(knife, COLOR.DEEP_PURPLE, self.x, self.y, 1, a, true)
                    a = a + 360 / self.way
                end
                object.Del(self)
            end
        end,
        del = function(self)
            if not self.dk then
                self.dk = true
                object.Preserve(self)
                task.New(self, function()
                    local s = 1
                    local a = 255
                    for _ = 1, 11 do
                        self.hscale = s
                        self.vscale = s
                        _object.set_color(self, "mul+add", a, 255, 255, 255)
                        task.Wait()
                        s = s + 2 / 10
                        a = a + -255 / 10
                    end
                    object.RawDel(self)
                end)
            end
        end
    })
end --bullet

do
    class["obj0-1"] = Class(_object, {
        init = function(self, _x, _y, a, d, r)
            self.x, self.y = _x, _y
            self.img = "img_void"
            self.layer = LAYER.TOP
            self.group = GROUP.ENEMY_BULLET
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.black = {}
            object.SetV(self, 13, a, true)
            task.New(self, function()
                task.Wait(8)
                local A = self.rot
                for _ = 1, 30 do
                    object.SetV(self, 13, A, true)
                    task.Wait()
                    A = A + 220 / 29 * d
                end
                A = self.rot
                for _ = 1, 10 do
                    object.SetV(self, 13, A, true)
                    task.Wait()
                    A = A + r * d / 9
                end
                task.Wait(280)
                object.Del(self)
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if self.timer % 3 == 0 then
                table.insert(self.black, { x = self.x, y = self.y, a = ran:Float(0, 360), v = 0.08, timer = 1, alpha = 0 })
            end
            local b
            for i = #self.black, 1, -1 do
                b = self.black[i]
                if b.timer <= 60 then
                    b.alpha = min(155, b.alpha + 155 / 60)
                elseif b.timer <= 120 then
                    if Dist(player, b.x, b.y) < 40 then
                        ext.achievement:get(49)
                    end
                elseif b.timer <= 180 then
                    b.alpha = max(0, b.alpha - 155 / 60)
                end
                b.x = b.x + cos(b.a) * b.v
                b.y = b.y + sin(b.a) * b.v
                b.timer = b.timer + 1
                if b.timer >= 180 then
                    table.remove(self.black, i)
                end
            end
        end,
        render = function(self)
            for _, b in ipairs(self.black) do
                SetImageState("BlackFog", "", b.alpha, 255, 255, 255)
                Render("BlackFog", b.x, b.y)
            end
        end
    })
    class["revhppar"] = Class(_object, {
        init = function(self, x, y, targetboss)
            self.x, self.y = x, y
            self.img = "bright"
            self.layer = LAYER.ENEMY_BULLET_EF
            self.group = GROUP.INDES
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            local col = { 250, 128, 114 }
            self._blend, self._a, self._r, self._g, self._b = 'mul+add', 160, unpack(col)
            self.vscale = 8 / 150
            self.hscale = 8 / 150
            task.New(self, function()
                local a, l = ran:Float(0, 360), ran:Float(40, 80)
                task.MoveToEx(cos(a) * l, sin(a) * l, ran:Int(45, 70), 2)
                task.Wait(10)
                if IsValid(targetboss) then
                    task.MoveTo(targetboss.x, targetboss.y, 45, 1)
                end
                if IsValid(targetboss) then
                    Damage(targetboss, 2)
                end
                task.Wait(30)
                object.Del(self)
            end)
        end
    })
end --object
