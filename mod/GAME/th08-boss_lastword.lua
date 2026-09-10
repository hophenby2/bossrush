local function tcoffset(self, r)
    if not ext.sc_pr then
        self.ui.timeCounter.yoffset2 = r
    end
end
local function scoffset(self, r)
    if not ext.sc_pr then
        self._sc_name_obj.yoffset2 = r
    end
end
local function boss_init(self)
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
    if ext.sc_pr then
        ToBigScreen(60)
    end
end

local cos, sin, abs, min, max, int, tan = cos, sin, abs, min, max, int, tan
local object, boss = object, boss
local task, ran, Create, misc = task, ran, Create, misc
local GROUP, LAYER, COLOR = GROUP, LAYER, COLOR
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local IsValid = IsValid
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out
local _editor_class = _editor_class

local function NewText(x, y, layer, text, alpha, color, lifetime, f, viewmode, ...)
    return New(SimpleText, x, y, layer, text, alpha, color, lifetime, f, viewmode, ...)
end

do
    boss.Define("9a", "莉格露·奈特巴格", "TH08_NEW_0", TH08_bg,
            { 0, 550 }, _editor_class["TH08"]["SCBG-LW1"], "Nightbug", 3)
    local _tmp_sc = boss.card.New("「蛍火の杜へ」", 26, 26, 26, 600)
    function _tmp_sc:before()
        boss_init(self)
        task.MoveTo(0, 120, 56, 2)
    end
    function _tmp_sc:init()
        tcoffset(self, -1)
        task.New(self, function()
            task.Wait(111)
            NewText(110 + 160, 460 + 30, nil,
                    "︽\n萤\n火\n之\n森\n︾\n ︵\n蛍\n火\nの\n杜\nへ\n︶\n，",
                    0, { 255, 227, 132 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.3, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(50)
            NewText(92 + 160, 320 + 30, nil,
                    "是\n绿\n川\n幸\n编\n著\n的\n漫\n画\n作\n品\n。",
                    0, { 255, 255, 255 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.3, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            object.Connect(self, New(_editor_class["TH08"]["bullet_lw0-2"], self.x, self.y, COLOR.GOLDEN_YELLOW), 0, true)
            local s, _d_s = (1), (-0.8 / 89)
            for _ = 1, 90 do
                self.vscale = s
                self.hscale = s
                task.Wait()
                s = s + _d_s
            end
            local a = ran:Float(0, 360)
            local v
            for _ = 1, 40 do
                v = 0.4
                for _ = 1, 3 do
                    New(_editor_class["TH08"]["bullet_lw0-1"], self.x, self.y, v, a, ran:Float(0.6, 1.3) * ran:Sign(), ran:Int(40, 90))
                    v = v + 0.3
                end
                a = a + 90
            end
            _object.set_color(self, "", 0, 255, 255, 255)
            task.New(self, function()
                for t = 1, _infinite do
                    object.SetV(self, sin(min(t, 90)) * cos(t / 2) * cos(t / 2), Angle(self, player), false)
                    task.Wait()
                end
            end)
            local x, y
            while true do
                x, y = self.x + cos(ran:Float(0, 360)) * ran:Float(0, 80), self.y + sin(ran:Float(0, 360)) * ran:Float(0, 80)
                New(_editor_class["TH08"]["bullet_lw0-1"], x, y, ran:Float(0.2, 0.6), ran:Float(0, 360), ran:Float(0.6, 1.3) * ran:Sign(), ran:Int(40, 90))
                task.Wait(6)
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "9a" } }, 3, "「蛍火の杜へ」", 25)
end--bosslw1
do
    boss.Define("9b", "米斯蒂娅·萝蕾拉", "TH08_NEW_0", TH08_bg,
            { 0, 550 }, _editor_class["TH08"]["SCBG-LW1"], "Lorelei", 3)
    local _tmp_sc = boss.card.New("玉章「七人同行之一」", 26, 26, 26, 1500)
    function _tmp_sc:before()
        boss_init(self)

        task.MoveTo(0, 180, 56, 2)
    end
    function _tmp_sc:frame()
        CollisionCheck(GROUP.GHOST, GROUP.PLAYER)
    end
    function _tmp_sc:init()
        scoffset(self, -1)
        tcoffset(self, -1)
        task.New(self, function()
            task.Wait(111 + 13 * 60)
            NewText(110 + 160, 430 + 30, nil,
                    "夜\n雀\n为\n︽\n滑\n头\n鬼\n之\n孙\n︾\n中\n出\n场\n的\n妖\n怪\n，",
                    0, { 135, 206, 235 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.3, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(111)
            NewText(90 + 160, 320 + 30, nil,
                    "最\n初\n作\n为\n四\n国\n妖\n怪\n七\n人\n同\n行\n之\n一\n|",
                    0, { 255, 255, 255 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            NewText(70 + 160, 320 + 30, nil,
                    "玉\n章\n的\n部\n下\n登\n场",
                    0, { 255, 255, 255 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(111)
            NewText(50 + 160, 430 + 30, nil,
                    "拥\n有\n碰\n到\n她\n黑\n色\n羽\n毛\n的\n人",
                    0, { 200, 200, 255 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(220)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            NewText(30 + 160, 430 + 30, nil,
                    "眼\n前\n就\n会\n一\n片\n漆\n黑\n的\n能\n力",
                    0, { 160, 160, 160 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(220)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            self.scale_s = 7
            New(_editor_class["TH08"]["Blindness with Feather"], self.x, self.y, self, self.y)
            while true do
                object.Connect(self, New(_editor_class["TH08"]["bullet_lw0-3"], ran:Float(-320, 320), 250,
                        ran:Float(1, 1.8), ran:Float(-7, 7) - 90, ran:Float(1, 2) * ran:Sign(), ran:Float(0.4, 0.8), self),
                        0, true)
                object.Connect(self, New(_editor_class["TH08"]["bullet_lw0-3"], ran:Float(-320, 320), -250,
                        ran:Float(1, 1.8), ran:Float(-7, 7) + 90, ran:Float(1, 2) * ran:Sign(), ran:Float(0.4, 0.8), self),
                        0, true)
                task.Wait(15)
            end
        end)
        task.New(self, function()
            object.Connect(self, New(_editor_class["TH08"]["bullet_lw0-2"], self.x, self.y, COLOR.GREEN), 0, true)
            local s, _d_s = (1), (-0.8 / 89)
            for _ = 1, 90 do
                self.vscale = s
                self.hscale = s
                task.Wait()
                s = s + _d_s
            end
            _object.set_color(self, "", 0, 255, 255, 255)
            task.New(self, function()
                local t = 1
                while true do
                    object.SetV(self, sin(min(t, 90)) * sin(t) * sin(t), Angle(self, player), false)
                    t = t + 1
                    task.Wait()
                end
            end)
        end)
    end
    boss.card.add({ { _tmp_sc, "9b" } }, 3, "玉章「七人同行之一」", 26)
end--bosslw2
do
    boss.Define("10a", "上白泽慧音", "TH08_NEW_0", TH08_bg,
            { -500, 0 }, _editor_class["TH08"]["SCBG-LW3"], "Kamishirasawa", 3)
    local _tmp_sc = boss.card.New("白泽「吉祥之兽」", 13, 13, 13, 1500)
    function _tmp_sc:before()
        boss_init(self)

        task.MoveTo(0, 100, 56, 2)
    end
    function _tmp_sc:init()
        task.New(self, function()
            task.Wait(111)
            NewText(110 + 160, 430 + 30, nil,
                    "白\n泽\n是\n中\n国\n古\n代\n神\n话\n中\n地\n位\n崇\n高\n的\n神\n兽",
                    0, { 189, 252, 201 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(111)
            NewText(90 + 160, 320 + 30, nil,
                    "祥\n瑞\n之\n象\n征",
                    0, { 255, 255, 255 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(111)
            NewText(70 + 160, 430 + 30, nil,
                    "是\n令\n人\n逢\n凶\n化\n吉\n的\n吉\n祥\n之\n兽",
                    0, { 230, 255, 200 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(220)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            task.init_left_wait(self)
            local beat = 3600 / 129
            task.Wait()
            boss.cast(self, 5555555)
            do
                local a, _d_a = (ran:Float(0, 360)), (360 / 8)
                for _ = 1, 8 do
                    object.Connect(self, New(_editor_class["TH08"]["bullet_lw0-4"], self.x, self.y, a), 0, true)
                    a = a + _d_a
                end
            end
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(115)
            local c, d, t, a, x
            ---n是边数
            ---        c,d不用管
            ---t是每边的点数
            for n = 3, 15 do
                a = 0
                for _ = 1, n do
                    c = (180 - 360 / n) / 2
                    d = 1 / tan(c) * 1.5
                    t = int(60 / n)
                    x = d
                    for _ = 1, t do
                        Create.bullet_setvxvy(self.x, self.y, grain_a, 6, x * cos(a) - 1.5 * sin(a), x * sin(a) + 1.5 * cos(a))
                        x = x - 2 * d / t
                    end
                    a = a + 360 / n
                end
                PlaySound("tan00")
                task.Wait2(self, beat * 4)
            end
        end)
    end
    function _tmp_sc:del()
    end
    boss.card.add({ { _tmp_sc, "10a" } }, 3, "白泽「吉祥之兽」", 27)
end--bosslw3
do
    boss.Define("11a", "铃仙·优昙华院·因幡", "TH08_NEW_0", TH08_bg,
            { -500, 0 }, _editor_class["TH08"]["SCBG-LW4"], "Reisen", 3)
    local _tmp_sc = boss.card.New("「The Killer Bunny」", 13, 13, 13, 1500)
    function _tmp_sc:before()
        lstg.var.eye = false
        boss_init(self)

        task.MoveTo(0, 100, 56, 2)
    end
    function _tmp_sc:init()
        task.New(self, function()
            task.Wait(111)
            NewText(64 + 160, 400 + 30, nil,
                    "杀\n手\n兔\n是\nM\nC\n中\n的\n兔\n子\n变\n种",
                    0, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.2, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "left")
            task.Wait(111)
            NewText(0 + 160, 410 + 30, nil,
                    "对\n任\n何\n玩\n家\n都\n敌\n对",
                    0, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "left")
            task.Wait(111)
            NewText(110 + 160, 320 + 30, nil,
                    "其\n毛\n发\n纯\n白\n，\n有\n横\n向\n的\n血\n红\n色\n眼\n睛",
                    0, { 255, 255, 255 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            local rot = Angle(self, player)
            local a
            for _ = 1, 9 do
                a = rot - 10
                for _ = 1, 11 do
                    New(_editor_class["TH08"]["bullet_lw0-5"], self.x, self.y, a, 1.5, self.x, self.y, 20)
                    a = a + 2
                end
                rot = rot + 40
            end
            task.Wait(100)
            local x1, x2, t
            while true do
                object.Connect(self, New(_editor_class["TH08"]["RedScreen"], 0, 0))
                x1 = -140
                x2 = 140
                a = 1.6
                t = 11
                for _ = 1, 40 do
                    object.Connect(self, New(_editor_class["TH08"]["RedEye"], x1, 50, t, a, "L"))
                    object.Connect(self, New(_editor_class["TH08"]["RedEye"], x2, 50, t, a, "R"))
                    task.Wait()
                    x1 = x1 + 50 / 39
                    x2 = x2 - 50 / 39
                    a = a - 0.6 / 39
                    t = t + 1
                end
                task.Wait(130)
            end
        end)
        task.New(self, function()
            task.Wait(140)
            local rot
            while true do
                if not self.eye then
                    rot = Angle(self, player) + ran:Float(-45, 45)
                    for _ = 1, 9 do
                        for z = -3, 3 do
                            New(_editor_class["TH08"]["bullet_lw0-5"], self.x, self.y, rot + z * 3, 2.3, self.x, self.y, 20)
                        end
                        rot = rot + 40
                    end
                end
                task.Wait(13)
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "11a" } }, 3, "「The Killer Bunny」", 28)
end--bosslw4
do
    boss.Define("13a", "八意永琳", "TH08_NEW_1", TH08_bg,
            { -500, 100 }, _editor_class["TH08"]["SCBG-LW5"], "Yagokoro", 3)
    local White = Class(object)
    function White:init(_boss)
        self.colli = false
        self.boss = _boss
        self.layer = LAYER.TOP + 1
        self.group = GROUP.INDES
    end
    function White:render()
        SetImageState("white", "add+rev", self.boss.white_a, 255, 255, 255)
        RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
    end
    local _tmp_sc = boss.card.New("药符「酒石酸唑吡坦」", 14, 14, 14, 1500)
    function _tmp_sc:before()
        boss_init(self)
        self.white_a = 0
        New(White, self)
        task.MoveTo(0, 100, 56, 2)
    end
    function _tmp_sc:init()
        boss.card.UnlockOD(self,23)
        task.New(self, function()
            task.Wait(111)
            NewText(320 + 160, 250 + 30, nil,
                    "酒石酸唑吡坦为一催眠剂",
                    0, { 180, 180, 180 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(111)
            NewText(320 + 160, 230 + 30, nil,
                    "镇静催眠作用很强",
                    0, { 220, 220, 220 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            task.Wait()
            local col = { 2, 6, COLOR.GREEN, COLOR.ORANGE, COLOR.CYAN }
            local d = 1
            local l, a1, a2, a, v, rot
            local t = 1
            local n = 10
            while true do
                Newcharge_out(self.x, self.y, 255, 255, 100)
                l = 120
                boss.cast(self, 120)
                task.New(self, function()
                    a1 = ran:Float(0, 360)
                    a2 = ran:Float(0, 360)
                    for i = 1, 200 do
                        for j = 1, t do
                            Create.bullet_decel(self.x + cos(a1) * l, self.y + sin(a1) * l, ({ grain_a, grain_b })[i % 2 + 1], col[t],
                                    5, ({ 0.5, 1 })[i % 2 + 1] + j, a1 * t * 0.6)
                            Create.bullet_decel(self.x + cos(a2) * l, self.y + sin(a2) * l, ({ grain_a, grain_b })[i % 2 + 1], col[t],
                                    5, ({ 0.5, 1 })[i % 2 + 1] + j, a2 * t * 0.6)
                            PlaySound("tan00", 0.1, self.x / 256, true)
                        end
                        l = l - 1
                        task.Wait()
                        a1 = a1 + 7
                        a2 = a2 - 7
                    end
                end)
                v = 1
                rot = Angle(self, player)
                for _ = 1, 50 do
                    a = rot
                    for _ = 1, n do
                        Create.bullet_accel(self.x + cos(a) * l, self.y + sin(a) * l, butterfly, col[t], 0.5, v, a + 180, true)
                        PlaySound("tan00", 0.1, self.x / 256, true)
                        a = a + 360 / n
                    end
                    task.Wait(2)
                    v = v + 0.1
                    rot = rot + (360 / n / 2 - 0.2) * d
                end
                task.Wait(30)
                task.MoveToPlayer(60, -250, 250, 90, 144,
                        40, 80, 20, 40, 2, 1)
                d = -d
                t = t + 1
                n = n + 1
            end
        end)
        task.New(self, function()
            task.Wait(420)
            self.white_a = 70
            PlaySound("nice", 1, 0, false)
            lstg.var.timeslow = 2
            task.Wait(210)
            self.white_a = 140
            PlaySound("nice", 1, 0, false)
            lstg.var.timeslow = 3
            task.Wait(140)
            self.white_a = 210
            PlaySound("nice", 1, 0, false)
            lstg.var.timeslow = 4
        end)
    end
    function _tmp_sc:del()
        self.white_a = 0
        lstg.var.timeslow = 1
    end
    boss.card.add({ { _tmp_sc, "13a" } }, 3, "药符「酒石酸唑吡坦」", 29)

    local sc_od = boss.card.New("药符「甲基己胺-Overdrive」", 22, 22, 22, 1500)
    function sc_od:before()
        boss_init(self)
        task.MoveTo(0, 100, 56, 2)
    end
    function sc_od:init()
        task.New(self, function()
            task.Wait()
            local col = { 2, 6, 10, 14, 8, 2, 6, 10, 14, 8, 2, 6, 10, 14, 8 }
            local d = 1
            local t = 1
            local l, a1, a2, a, v, rot
            local n = 7
            while true do
                Newcharge_out(self.x, self.y, 255, 255, 100)
                l = 120
                boss.cast(self, 120)
                task.New(self, function()
                    a1 = ran:Float(0, 360)
                    a2 = ran:Float(0, 360)
                    for i = 1, 100 do
                        Create.bullet_decel(self.x + cos(a1) * l, self.y + sin(a1) * l, ({ grain_a, grain_b })[i % 2 + 1], col[t],
                                5, 1 + i % 2, a1 * 0.6)
                        Create.bullet_decel(self.x + cos(a2) * l, self.y + sin(a2) * l, ({ grain_a, grain_b })[i % 2 + 1], col[t],
                                5, 1 + i % 2, a2 * 0.6)
                        PlaySound("tan00")
                        l = l - 1
                        task.Wait(2)
                        a1 = a1 + 14
                        a2 = a2 - 14
                    end
                end)
                v = 1
                rot = Angle(self, player)
                for _ = 1, 50 do
                    a = rot
                    for _ = 1, n do
                        Create.bullet_accel(self.x + cos(a) * l, self.y + sin(a) * l, butterfly, col[t], 0.5, v, a + 180)
                        PlaySound("tan00")
                        a = a + 360 / n
                    end
                    task.Wait(2)
                    v = v + 0.05
                    rot = rot + (360 / n / 2 - 0.2) * d
                end
                task.Wait(30)
                task.MoveToPlayer(60, -250, 250, 90, 144,
                        40, 80, 20, 40, 2, 1)
                d = -d
                n = n + 1
                t = t + 1
            end
        end)
        task.New(self, function()
            task.Wait(300)
            SmearScreen(self, 2, 400, nil, nil, true)
            PlaySound("nice")
            lstg.var.CYFPS = 80
            task.Wait(400)
            SmearScreen(self, 5, 400, nil, nil, true)
            PlaySound("nice")
            lstg.var.CYFPS = 100
            task.Wait(400)
            SmearScreen(self, 6, 900, nil, nil, true)
            PlaySound("nice")
            lstg.var.CYFPS = 120
        end)
    end
    function sc_od:del()
        lstg.var.CYFPS = 60
    end
    boss.card.add({ { sc_od, "13a" } }, 3, "药符「甲基己胺-Overdrive」", 219, 23)


end--bosslw5
do
    boss.Define("14a", "蓬莱山辉夜", "TH08_NEW_1", TH08_bg,
            { 500, 100 }, _editor_class["TH08"]["SCBG-LW6"], "Neet", 3)
    local _tmp_sc = boss.card.New("「Baccano!」", 26, 26, 26, 1500)
    function _tmp_sc:before()
        boss_init(self)
        task.MoveTo(0, 120, 56, 2)
    end
    function _tmp_sc:init()
        tcoffset(self, -1)
        task.New(self, function()
            task.Wait(111)
            NewText(320 + 160, 240 + 30, nil,
                    "《永生之酒》(Baccano!)改编自由成田良悟创作、榎波克己负责插画的同名轻小说。",
                    0, { 180, 180, 180 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(360)
            NewText(320 + 160, 240 + 30, nil,
                    "\"喝了永生之酒的人无论受什么样的伤都不会死，唯一的致死的方法是喝了永生之酒的人自相残杀\"",
                    0, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            New(_editor_class["TH08"]["bullet_lw1-1"], self.x, self.y, 180)
            New(_editor_class["TH08"]["bullet_lw1-1"], self.x, self.y, 0)
            task.Wait(180)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(60)
            do
                local A = 0
                while true do
                    for a = 1, 25 do
                        Create.bullet_dec_acc(self.x + cos(a * 360 / 25 + A) * 100, self.y + sin(a * 360 / 25 - A) * 100,
                                arrow_small, 6, 6, 3, a * 360 / 25)
                        PlaySound("tan00", 0.1, 0, true)
                    end
                    task.Wait(5)
                    A = A + 3.75
                end
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "14a" } }, 3, "「Baccano!」", 30)
end--bosslw6
do
    boss.Define("14b", "藤原妹红", "TH08_NEW_1", TH08_bg,
            { -500, 144 }, _editor_class["TH08"]["SCBG-LW6"], "Mokou", 3)
    local _tmp_sc = boss.card.New("「炉心融解」", 26, 26, 26, 1500)
    function _tmp_sc:before()
        boss_init(self)
        self.fire = { x = self.x, y = self.y, alpha = 0, hscale = 1, vscale = 1, timer = 0 }
        task.MoveTo(50, 100, 56, 2)
    end
    function _tmp_sc:init()
        scoffset(self, -1)
        tcoffset(self, -1)
        task.New(self, function()
            NewText(110 + 160, 430 + 30, nil,
                    "核\n融\n合\n炉\nに\nさ",
                    0, { 255, 100, 100 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.3, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(229)
            NewText(110 + 160, 400 + 30, nil,
                    "飛\nび\n込\nん\nで\nみ\nた\nら",
                    0, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.2, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(404 - 229)
            NewText(90 + 160, 400 + 30, nil,
                    "そ\nし\nた\nら",
                    0, { 135, 206, 235 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(491 - 404)
            NewText(70 + 160, 430 + 30, nil,
                    "き\nっ\nと\n眠\nる\nよ\nう\nに\n消\nえ\nて\nい\nけ\nる\nん\nだ",
                    0, { 255, 100, 100 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.2, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(698 - 491)
            NewText(110 + 160, 300 + 30, nil,
                    "僕\nの\nい\nな\nい\n朝\nは",
                    0, { 255, 150, 100 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.3, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(928 - 698)
            NewText(110 + 160, 400 + 30, nil,
                    "今\nよ\nり\nず\nっ\nと\n素\n晴",
                    0, { 255, 100, 150 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(1091 - 928)
            NewText(90 + 160, 400 + 30, nil,
                    "ら\nし\nく\nて",
                    0, { 255, 150, 150 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.3, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(1190 - 1091)
            NewText(70 + 160, 300 + 30, nil,
                    "全\nて\nの\n歯\n車\nが\n噛\nみ\n合\nっ\nた",
                    0, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.2, 90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        self.fireservant = {}
        do
            local y = -180
            local a = 0
            for t = 1, 4 do
                self.fireservant[t] = New(_editor_class["TH08"]["bullet_lw1-2"], self.x, self.y, a, y)
                y = y + 120
                a = a + 180
            end
        end
        task.New(self, function()
            while true do
                task.Wait(190)
                do
                    local s = 0
                    for _ = 1, 11 do
                        self.hscale = 1 - 0.5 * sin(s)
                        self.vscale = 1 + 1 * sin(s)
                        task.Wait()
                        s = s + 9
                    end
                end
                self.fire.x = self.x
                self.fire.y = self.y
                self.fire.timer = 0
                task.New(self, function()
                    self.fire.alpha = 1

                    for i = 1, 30 do
                        self.fire.hscale = self.fire.hscale + 0.7
                        self.fire.vscale = self.fire.vscale - 1 / 30
                        task.Wait()
                    end
                    self.fire.alpha = 0
                    self.fire.hscale = 1
                    self.fire.vscale = 1
                end)
                task.MoveToPlayer(0, -250, 250, 0, 150, 120, 160, 20, 40, VALUE_SET.NORMAL, WANDER_MODE.RANDOM)
                do
                    local s = 90
                    for _ = 1, 11 do
                        self.hscale = 1 - 0.5 * sin(s)
                        self.vscale = 1 + 1 * sin(s)
                        task.Wait()
                        s = s - 9
                    end
                end
            end
        end)
        task.New(self, function()
            task.Wait(16)
            local sd = 1
            local a, rot, v
            while true do
                a = ran:Float(0, 360)
                for _ = 1, 15 do
                    rot = a
                    v = 1.8
                    for _ = 1, 1 do
                        NewSimpleBullet(water_drop, 6, self.x, self.y, v, rot)
                        PlaySound("tan00", 0.1, self.x, false)
                        rot = rot + 4 * sd
                        v = v + 0.1
                    end
                    a = a + 360 / 15
                end
                PlaySound("kira00", 1, self.x, false)
                sd = -sd
                task.Wait(40)
            end
        end)
    end
    function _tmp_sc:frame()
        self.fire.timer = self.fire.timer + 1
    end
    function _tmp_sc:render()
        SetImageState("FireBird", "", 155, 255, 255, 255)
        Render("FireBird", self.x, self.y + sin(self.ani * 4) * 4)
        local t2 = self.ani % 90
        local t = self.fire.timer
        SetImageState("FireBird", "", (100 + 155 * (1 - min(1, t2 / 50))) * sin(min(90, t)), 255, 255, 255)
        Render("FireBird", self.x, self.y + sin(self.ani * 4) * 4, 0, 1 + sin(90 - min(90, t * 2)) * 2)
        SetImageState("FireBird", "mul+add", self.fire.alpha * 155, 255, 255, 255)
        Render("FireBird", self.fire.x, self.fire.y, 0, self.fire.hscale, self.fire.vscale)
    end
    boss.card.add({ { _tmp_sc, "14b" } }, 3, "「炉心融解」", 31)
end--bosslw7
do
    boss.Define("15a", "因幡帝", "TH08_NEW_1", TH08_bg,
            { -200, 500 }, _editor_class["TH08"]["SCBG-LW8"], "Tewi", 3)
    local _tmp_sc = boss.card.New("BEASTARS「ハル」", 28, 28, 28, 1500)
    function _tmp_sc:before()
        boss_init(self)

        task.MoveTo(0, 100, 56, 2)
    end
    function _tmp_sc:init()

        self._transport = New(Class(object, {
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard and not self.flag then
                        ext.achievement:get(133)
                    end
                    object.RawDel(self)
                end)
            end,
            frame = task.Do
        }, true))
        task.New(self, function()
            task.Wait(111)
            NewText(320 + 160, 250 + 30, nil,
                    "《BEASTARS》是板垣巴留所创作的日本漫画",
                    0, { 135, 206, 235 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(111)
            NewText(320 + 160, 230 + 30, nil,
                    "哈鲁,侏儒种的兔子，是雷格西和提姆同校的3年级女生",
                    0, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            do
                local a = ran:Float(0, 360)
                for _ = 1, 8 do
                    object.Connect(self, New(_editor_class["TH08"]["bullet_lw1-4"], player.x + cos(a) * 80, player.y + sin(a) * 80,
                            12, a + 180, player.x + cos(a) * 80, player.y + sin(a) * 80, 100))
                    a = a + 360 / 8
                end
            end
            task.Wait(30)
            local col = { 4, 6, 8, 10 }
            task.New(self, function()
                task.Wait(80)
                local b
                while true do
                    b = NewSimpleBullet(grain_a, 6, self.x + ran:Float(-8, 8), self.y + ran:Float(-8, 8), ran:Float(1, 3), ran:Float(-46, 46) + 90)
                    object.ForbidV(b, ran:Float(4, 5))
                    object.SetA(b, 0.02, Angle(self, player), false)
                    b.navi = true
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(5)
                end
            end)
            do
                local n = 10
                local a, t, l
                while true do
                    boss.cast(self, 60)
                    task.Wait(8)
                    a = ran:Float(0, 360)
                    t = ran:Int(1, 4)
                    for _ = 1, n do
                        l = 100
                        for _ = 1, 2 do
                            object.Connect(self, New(_editor_class["TH08"]["bullet_lw1-4"], self.x, self.y - 50, col[t], a, self.x, self.y, l))
                            l = l + 23
                        end
                        a = a + 360 / n
                    end
                    task.MoveToPlayer(60, -120, 120, 80, 144,
                            40, 80, 20, 40, 2, 3)
                    task.Wait(160)
                    n = n + 1
                end
            end
        end)
    end
    function _tmp_sc:frame()
        CollisionCheck(GROUP.GHOST, GROUP.PLAYER)
    end
    boss.card.add({ { _tmp_sc, "15a" } }, 3, "BEASTARS「ハル」", 32)
end--bosslw8
do
    boss.Define("17a", "上白泽慧音", "TH08_NEW_2", TH08_bg,
            { 500, -140 }, _editor_class["TH08"]["SCBG-LW9"], "Kamishirasawa2", 3)
    local _tmp_sc = boss.card.New("白泽「万妖之首」", 19, 19, 19, 1500)
    function _tmp_sc:before()
        boss_init(self)

        task.MoveTo(0, 90, 60, 2)
    end
    function _tmp_sc:init()
        task.New(self, function()
            task.Wait(111)
            NewText(320 + 160, 290 + 30, nil,
                    "白泽亦能说人话，通万物之情，晓天下万物状貌",
                    0, { 255, 227, 132 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.2, 0)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(360)
            NewText(320 + 160, 210 + 30, nil,
                    "《白泽图》曰:羊有一角当顶上，龙也，杀之震死",
                    0, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.2, 180)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            boss.cast(self, 5555555)
            Newcharge_in(self.x, self.y, 128, 32, 32)
            task.Wait(120)
            local D = 1
            task.New(self, function()
                task.Wait(60)
                PlaySound("slash", 0.1, 0, false)
                while true do
                    New(_editor_class["TH08"]["bullet_lw2-2"], ran:Float(-320, 320), 244,
                            ran:Float(1, 2), ran:Float(-10, 10) - 90)
                    task.Wait()
                end
            end)
            local d, t, v, rot, ac, fv, a, x, a1
            local n = 3
            while true do
                v, rot, ac, fv = 0.3, ran:Float(0, 360), 0, 2.7
                for _ = 1, 5 do
                    a = rot
                    for _ = 1, n do
                        d = 1 / tan((180 - 360 / n) / 2) * v
                        t = 13
                        x, a1 = d, a
                        for _ = 1, t do
                            New(_editor_class["TH08"]["bullet_lw2-1"], self.x, self.y, x * cos(a) - v * sin(a), x * sin(a) + v * cos(a), grain_b, 5, a1 + ac, fv)
                            x = x - 2 * d / t
                            a1 = a1 + 360 / n / t
                        end
                        a = a + 360 / n
                    end
                    v = v + 0.5
                    rot = rot + 20 * D
                    ac = ac + 40 * D
                    fv = fv - 0.2
                end
                task.Wait(140)
                self.out = true
                task.Wait()
                self.out = false
                Newcharge_out(self.x, self.y, 255, 30, 255)
                D = -D
                task.Wait(80)
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "17a" } }, 3, "白泽「万妖之首」", 33)
end--bosslw9
do
    boss.Define("18a", "十六夜咲夜", "TH08_NEW_2", TH08_bg,
            { 200, 500 }, _editor_class["TH08"]["SCBG-LW10"], "Sakuya", 3)
    local _tmp_sc = boss.card.New("「乔鲁诺·咲夜」", 12, 12, 12, 1500)
    function _tmp_sc:before()
        boss_init(self)

        task.MoveTo(120, 100, 60, 2)
    end
    function _tmp_sc:init()
        task.New(self, function()
            task.Wait(111)
            local text
            text = NewText(320 + 160, 520 + 30, nil,
                    "乔鲁诺·乔巴纳，是日本漫画《JOJO的奇妙冒险》第五季黄金之风的男主角",
                    255, { 255, 227, 132 }, nil, function()
                        local self = task.GetSelf()
                        task.MoveTo(320 + 160, 400 + 30, 60, 2)
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            text.nopause = true
            task.Wait(360)
            text = NewText(320 + 160, 520 + 30, nil,
                    "身份为DIO(身体为乔纳森·乔斯达)与某个不知名日本女性的儿子",
                    255, { 255, 227, 255 }, nil, function()
                        local self = task.GetSelf()
                        task.MoveTo(320 + 160, 400 + 30, 60, 2)
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            text.nopause = true
        end)
        self.nopause = true
        task.New(self, function()
            task.Wait(24)
            local D = 1
            local t = 3
            local A, d, a
            while true do
                task.New(self, function()
                    task.MoveToPlayer(60, -200, 200, 112, 144,
                            20, 40, 16, 32, 2, 1)
                end)
                task.New(self, function()
                    for _ = 1, 160 do
                        AddSuperPause(1)
                        self.timer = self.timer - 1
                        task.Wait()
                    end
                end)
                PlaySound("kira00", 1, self.x, false)
                A = 0
                d = 10
                for _ = 1, 80 do
                    a = 0
                    for _ = 1, 20 do
                        New(_editor_class["TH08"]["bullet_lw2-3"],
                                player.x + cos(a + A) * 80 + cos(a) * 160, player.y + sin(a - A) * 80 + sin(a) * 160, d * D)
                        a = a + 18
                    end
                    task.Wait()
                    A = A + 3 * D
                    d = d + 20
                end
                task.Wait(80)
                D = -D
                task.Wait(150)
                t = t + 1
            end
        end)
    end
    function _tmp_sc:render()
        if GetCurrentSuperPause() > 0 then
            SetImageState("white", "", 200, 41, 36, 33)
            RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
        end
    end
    boss.card.add({ { _tmp_sc, "18a" } }, 3, "「乔鲁诺·咲夜」", 34)
end--bosslw10
do
    boss.Define("19a", "魂魄妖梦", "TH08_NEW_3", TH08_bg,
            { -500, 0 }, _editor_class["TH08"]["SCBG-LW11"], "Youmu", 3, 0.6)
    local _tmp_sc = boss.card.New("恶鬼「罗刹」", 11, 11, 11, 2000)
    function _tmp_sc:before()
        boss_init(self)
        task.MoveTo(-200, 120, 60, 2)
    end
    function _tmp_sc:init()
        NewText(0, 0, nil, "食人肉之恶鬼", 0, { 255, 227, 132 }, nil, function()
            local self = task.GetSelf()
            for _ = 1, 660 do
                if lstg.var.gray then
                    self.alpha0 = 255
                else
                    self.alpha0 = 0
                end
                self.alpha = self.alpha + (self.alpha0 - self.alpha) / 10
                task.Wait()
            end
            object.RawDel(self)
        end, "world", "center")
        task.New(self, function()
            task.Wait(60)
            NewText(20 + 160, 300 + 30, nil,
                    "罗\n刹\n，\n此\n云\n恶\n鬼\n也",
                    0, { 200, 200, 200 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(60)
            NewText(40 + 160, 300 + 30, nil,
                    "食\n人\n血\n肉",
                    0, { 200, 200, 200 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(60)
            NewText(60 + 160, 300 + 30, nil,
                    "或\n飞\n空\n、\n或\n地\n行\n，\n捷\n疾\n可\n畏",
                    0, { 200, 200, 200 }, nil, function()
                        local self = task.GetSelf()
                        object.SetV(self, 0.1, -90)
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            local a, L
            while true do
                SmearScreen(self, 4, 48)
                Newcharge_in(self.x, self.y, 100, 255, 255)
                self.bg.layers[1].slash_time = 48
                task.New(self, function()
                    for _ = 1, 48 do
                        boss.cast(self, 20)
                        task.Wait()
                    end
                end)
                for v = 1, 3 do
                    a = ran:Float(0, 360)
                    for _ = 1, 70 do
                        object.Connect(self, New(_editor_class["TH08"]["bullet_lw3-1"], player.x + cos(a) * 20, player.y + sin(a) * 20, v, a))
                        a = a + 360 / 80
                    end
                end
                task.Wait(48)
                PlaySound("slash", 1, self.x, false)
                L = abs(-176 - self.y)
                New(_editor_class["TH08"]["Slash_1"], self.x, self.y - L / 2, L, -90)
                task.Wait(20)
                task.MoveToPlayer(42, -200, 200, 70, 160,
                        80, 120, 16, 32, 2, 1)
                task.Wait()
            end
        end)
    end
    function _tmp_sc:frame()
        CollisionCheck(GROUP.GHOST, GROUP.INDES)
    end
    function _tmp_sc:del()
        lstg.var.gray = false
        _object.set_color(self, "", 255, 255, 255, 255)
    end
    boss.card.add({ { _tmp_sc, "19a" } }, 3, "恶鬼「罗刹」", 35)
end--bosslw11
do
    boss.Define("20a", "爱丽丝·玛格特洛依德", "TH08_NEW_3", TH08_bg,
            { -500, 0 }, _editor_class["TH08"]["SCBG-LW12"], "Alice", 3)
    local _tmp_sc = boss.card.New("System Call「物件变形术」", 11, 11, 11, 2000)
    function _tmp_sc:before()
        boss_init(self)

        task.MoveTo(0, 144, 60, 2)
    end
    function _tmp_sc:init()
        NewText(128 + 160, 240 + 30, nil,
                "System Call...",
                0, { 255, 227, 132 }, nil, function()
                    local self = task.GetSelf()
                    object.SetV(self, 0.3, 0)
                    for i = 1, 30 do
                        self.alpha = sin(i * 3) * 255
                        task.Wait()
                    end
                    task.Wait(180)
                    NewText(512 + 160, 220 + 30, nil,
                            "From Object Polygonal Shape",
                            0, { 189, 252, 201 }, nil, function()
                                local unit = task.GetSelf()
                                object.SetV(unit, 0.3, 180)
                                for i = 1, 30 do
                                    unit.alpha = sin(i * 3) * 255
                                    task.Wait()
                                end
                                task.Wait(180)
                                for i = 29, 0, -1 do
                                    unit.alpha = sin(i * 3) * 255
                                    task.Wait()
                                end
                                object.RawDel(unit)
                            end, "ui", "center")
                    for i = 29, 0, -1 do
                        self.alpha = sin(i * 3) * 255
                        task.Wait()
                    end
                    object.RawDel(self)
                end, "ui", "center")
        task.New(self, function()
            do
                local X = -210
                for _ = 1, 3 do
                    object.Connect(self, New(_editor_class["TH08"]["enemy3-1"], self.x, self.y, X, 0))
                    X = X + 210
                end
            end
            do
                local v = 2
                local A, n
                local c, d, t, vx, vy, v2, X, a, x, a1
                while true do
                    self.t = false
                    Newcharge_in(self.x, self.y, 0, 255, 127)
                    A, n = ran:Float(0, 360), ran:Int(3, 7)
                    v2 = 1
                    X = -210
                    for _ = 1, 3 do
                        a = Angle(self, player)
                        for _ = 1, n do
                            c = (180 - 360 / n) / 2
                            d = 1 / tan(c) * v
                            t = int(40 / n)
                            x = d
                            a1 = a
                            for _ = 1, t do
                                vx, vy = x * cos(a) - v * sin(a), x * sin(a) + v * cos(a)
                                New(_editor_class["TH08"]["bullet_lw3-2"], self.x, self.y, v2, a1 + A, X + vx * 30, vy * 30)
                                x = x - 2 * d / t
                                a1 = a1 + 360 / n / t
                            end
                            a = a + 360 / n
                        end
                        task.Wait(20)
                        v2 = v2 + 1
                        X = X + 210
                    end
                    task.Wait(185 - 60)
                    self.t = true
                    Newcharge_out(self.x, self.y, 0, 255, 127)
                    task.Wait()
                end
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "20a" } }, 3, "System Call「物件变形术」", 36)
end--bosslw12
do
    boss.Define("21a", "蕾米莉亚·斯卡蕾特", "TH08_NEW_3", TH08_bg,
            { 0, 384 }, _editor_class["TH08"]["SCBG-LW13"], "Remilia", 3)
    local _tmp_sc = boss.card.New("「克罗里·尤斯福德」", 11, 11, 11, 2000)
    function _tmp_sc:before()
        boss_init(self)

        task.MoveTo(0, 120, 60, 2)
    end
    function _tmp_sc:init()
        task.New(self, function()
            NewText(320 + 160, 520 + 30, nil,
                    "克罗里·尤斯福德，漫画《终结的炽天使》及其衍生作品中人物",
                    255, { 250, 128, 114 }, nil, function()
                        local self = task.GetSelf()
                        task.MoveTo(320 + 160, 300 + 30, 80, 2)
                        task.Wait(80)
                        NewText(320 + 160, 520 + 30, nil,
                                "实力强悍，与第十三始祖的排位不符",
                                255, { 250, 128, 194 }, nil, function()
                                    task.MoveTo(320 + 160, 300 + 30, 110, 2)
                                    task.Wait(100)
                                    task.MoveTo(320 + 160, -100, 40, VALUE_SET.ACCEL)
                                    object.RawDel(task.GetSelf())
                                end, "ui", "center")
                        task.MoveTo(320 + 160, -100, 40, VALUE_SET.ACCEL)
                        object.RawDel(self)
                    end, "ui", "center")
            local a, _x, _y, x, y, A, X, Y, v
            while true do
                self.t = false
                a = -90 + ran:Float(-20, 20)
                for _ = 1, 70 do
                    New(_editor_class["TH08"]["bullet_lw3-4"], self.x, self.y, 150, a, self.x, self.y, 7)
                    a = a + 360 / 75
                end
                _x, _y = self.x, self.y
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
                        x, y = _x + cos(a) * ran:Float(150, 300), _y + sin(a) * ran:Float(150, 300)
                        NewSimpleBullet(square, 1, x, y, 8 + v, a + ran:Float(-25, 25))
                    end
                    A = ran:Float(0, 360)
                    X, Y = _x + cos(A) * ran:Float(150, 300), _y + sin(A) * ran:Float(150, 300)
                    New(_editor_class["TH08"]["bullet_lw3-5"], X, Y, 2, ball_mid, 0, ran:Float(0.4, 0.8), ran:Float(0, 360))
                    task.Wait()
                    v = v + 2 / 29
                end
                task.Wait(20)
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "21a" } }, 3, "「克罗里·尤斯福德」", 37)
end--bosslw13
do
    boss.Define("22a", "西行寺幽幽子", "TH08_NEW_3", TH08_bg,
            { 0, 500 }, _editor_class["TH08"]["SCBG-LW14"], "Yuyuko", 3)
    local _tmp_sc = boss.card.New("「蝴蝶梦之舞」", 25, 25, 25, 2000)
    function _tmp_sc:before()
        self.fan = New(_editor_class["TH07"]["fan"], self)
        lstg.tmpvar.bg.cherry.open = true
        boss_init(self)
        task.MoveTo(-180, 150, 60, 2)
    end
    function _tmp_sc:frame()
        local s = sin(min(self.ani, 90))
        local x, y = 320 - 40 * s, 240 - 50 * s
        player.x = min(x, max(-x, player.x))
        player.y = min(y, max(-y, player.y))
        if IsValid(self.bg) then
            self.bg.alpha = 0
        end
        CollisionCheck(GROUP.ENEMY_BULLET, GROUP.GHOST)
        CollisionCheck(GROUP.ENEMY_BULLET, GROUP.INDES)
    end
    function _tmp_sc:init()
        task.New(self, function()
            task.Wait(111)
            NewText(320 + 160, 240 + 30, nil,
                    "在东方绯想天中的必杀技“蝴蝶梦之舞”被作为扇舞的基准动作之一。",
                    0, { 255, 227, 132 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
            task.Wait(360)
            NewText(320 + 160, 240 + 30, nil,
                    "扇舞这个动作大量出现于各种二次创作中",
                    0, { 255, 227, 200 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            task.Wait(60)
            local d = 1
            for x = 0, 8 do
                object.Connect(self, New(_editor_class["TH08"]["Little_Fan_Green"], self.x, self.y, 1.5, 0,
                        ran:Float(16, 23),
                        -320 + 640 * x / 8, -230, 0))
                object.Connect(self, New(_editor_class["TH08"]["Little_Fan_Green"], self.x, self.y, 1.5, 0,
                        -ran:Float(16, 23),
                        -320 + 640 * x / 8, 230, 180))
            end
            for y = 0, 6 do
                object.Connect(self, New(_editor_class["TH08"]["Little_Fan_Green"], self.x, self.y, 1.5, 0,
                        ran:Float(16, 23),
                        -320, -230 + 460 * y / 6, -90))
                object.Connect(self, New(_editor_class["TH08"]["Little_Fan_Green"], self.x, self.y, 1.5, 0,
                        -ran:Float(16, 23),
                        320, -230 + 460 * y / 6, 90))
            end
            local n = 1
            local t = 30
            local a, A
            while true do
                Newcharge_in(self.x, self.y, 255, 255, 100)
                a = ran:Float(0, 360)
                for _ = 1, 2 do
                    object.Connect(self, New(_editor_class["TH08"]["Little_Fan_Golden"], self.x, self.y, a, 70, 10, 10 * d, 240, self))
                    a = a + 180
                end
                task.Wait(60)
                task.CRMoveTo(240, 1, -180 * d, 150, 0, 60, 180 * d, 150)
                PlaySound("tan00", 0.1, self.x, false)
                a = Angle(self, player)
                for _ = 1, t do
                    for v = 1, 2, 0.5 do
                        NewSimpleBullet(ball_big, 4, self.x, self.y, v, a)
                    end
                    a = a + 360 / t
                end
                Newcharge_out(self.x, self.y, 255, 255, 100)
                A = a
                for _ = 1, int(n) do
                    object.Connect(self, New(_editor_class["TH08"]["Little_Fan_Blue"], self.x + cos(A) * 50, self.y + sin(A) * 50, d, A))
                    A = A + 360 / int(n)
                end
                d = -d
                task.Wait(80)
                n = n + 0.5
                t = t + 4
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "22a" } }, 3, "「蝴蝶梦之舞」", 38)
end--bosslw14
do
    boss.Define("23a", "八云紫", "TH08_NEW_3", TH08_bg,
            { 300, 480 }, _editor_class["SCBG8:TH07"], "Yukari", 3)
    CreateRenderTarget("player_distance")
    local _tmp_sc = boss.card.New("「境界の彼方」", 40, 40, 40, 2000)
    function _tmp_sc:before()
        lstg.tmpvar.bg.cherry.open = true
        boss_init(self)
        self._wisys:SetFloat()
        self.mirror = { alpha = 0, omiga = 0, rot = 0 }
        self.image = { x = 0, y = 0, a = 3, b = 3 }
        self.circle = { x = 0, y = 0, r = 0 }
        player.nextshoot = _infinite
        local color = Color(255, 150, 255, 255)
        local w = lstg.world
        self.rendertex1 = { [3] = 0.5, [6] = color }
        self.rendertex2 = { [3] = 0.5, [6] = color }
        self.rendertex3 = { [3] = 0.5, [6] = color }
        self.rendertex4 = { [3] = 0.5, [6] = color }
        self.rendertex1[1], self.rendertex1[2] = w.l, w.t
        self.rendertex2[1], self.rendertex2[2] = w.r, w.t
        self.rendertex3[1], self.rendertex3[2] = w.r, w.b
        self.rendertex4[1], self.rendertex4[2] = w.l, w.b
        self.rendertex1[4], self.rendertex1[5] = WorldToScreen(w.l, w.t)
        self.rendertex2[4], self.rendertex2[5] = WorldToScreen(w.r, w.t)
        self.rendertex3[4], self.rendertex3[5] = WorldToScreen(w.r, w.b)
        self.rendertex4[4], self.rendertex4[5] = WorldToScreen(w.l, w.b)
        task.MoveTo(0, 0, 60, 2)
        self.refresh = function()
            self.image.x = player.x * cos(self.mirror.rot * 2) + player.y * sin(self.mirror.rot * 2)
            self.image.y = player.x * sin(self.mirror.rot * 2) - player.y * cos(self.mirror.rot * 2)
            object.BulletDo(function(unit)
                object.Del(unit)
            end)
            self.circle = { x = self.image.x, y = self.image.y, r = 100 }
            Newcharge_out(self.x, self.y, 32, 32, 128)
            New(WhiteScreen, LAYER.TOP, 30)
        end
    end
    function _tmp_sc:render()
        local t = self.ani
        local p = player
        SetImageState("yukari-ef", "mul+add", 50 + min(150, t) + sin(t * 0.7 - 90) * 50, 255, 255, 255)
        Render("yukari-ef", self.x, self.y, -0.5 * t, 1.8 + sin(t * 0.7 + 135) * 0.1)
        if self.mirror.alpha > 0 then
            Render("mirror", self.x, self.y, self.mirror.rot, 2, 1)
            PushRenderTarget("player_distance")
            RenderClear(Color(0, 0, 0, 0))
            Render(p.img, self.image.x, self.image.y, 180 + self.mirror.rot * 2, -p.hscale, p.vscale)
            local x, y
            if lstg.var.player_name == "reimu_player" then
                for i = 1, 4 do
                    x = p.sp[i][1]
                    y = p.sp[i][2]
                    SetImageState('reimu_support', 'mul+add', 100, 255, 255, 255)
                    Render('reimu_support',
                            x * cos(self.mirror.rot * 2) + y * sin(self.mirror.rot * 2),
                            x * sin(self.mirror.rot * 2) - y * cos(self.mirror.rot * 2),
                            p.timer * 3 + 180 + self.mirror.rot * 2, 1.5)
                    SetImageState('reimu_support', '', 255, 255, 255, 255)
                    Render('reimu_support',
                            x * cos(self.mirror.rot * 2) + y * sin(self.mirror.rot * 2),
                            x * sin(self.mirror.rot * 2) - y * cos(self.mirror.rot * 2),
                            p.timer * 3 + 180 + self.mirror.rot * 2)
                end
            elseif lstg.var.player_name == "marisa_player" then
                local sz = 1.2 + 0.1 * sin(p.timer * 0.2)
                --support
                SetImageState('marisa_support', '', 255, 255, 255, 255)
                for i = 1, 4 do
                    x = p.sp[i][1]
                    y = p.sp[i][2]
                    Render('marisa_support', x * cos(self.mirror.rot * 2) + y * sin(self.mirror.rot * 2),
                            x * sin(self.mirror.rot * 2) - y * cos(self.mirror.rot * 2),
                            180 + self.mirror.rot * 2, 1)
                end
                --support deco
                SetImageState('marisa_support', '', 128, 255, 255, 255)
                for i = 1, 4 do
                    x = p.sp[i][1]
                    y = p.sp[i][2]
                    Render('marisa_support', x * cos(self.mirror.rot * 2) + y * sin(self.mirror.rot * 2),
                            x * sin(self.mirror.rot * 2) - y * cos(self.mirror.rot * 2),
                            180 + self.mirror.rot * 2, sz)
                end
            end
            SetImageState("player_aura", "", 192, 255, 255, 255)
            Render("player_aura", self.image.x, self.image.y, -p.grazer.aura + p.grazer.aura_d, p.lh)
            SetImageState("player_aura", "", Color(0xC0FFFFFF) * p.lh + Color(0x00FFFFFF) * (1 - p.lh))
            Render("player_aura", self.image.x, self.image.y, p.grazer.aura, 2 - p.lh)
            PopRenderTarget("player_distance")
            RenderTexture("player_distance", "", self.rendertex1, self.rendertex2, self.rendertex3, self.rendertex4)
        end
        SetImageState("white", "mul+add", 255, 189, 252, 201)
        misc.SectorRender(self.circle.x, self.circle.y, self.circle.r, self.circle.r * 0.95, 0, 360, 18)
    end
    function _tmp_sc:frame()
        if IsValid(self.bg) then
            self.bg.alpha = 0
        end
        self.image.x = player.x * cos(self.mirror.rot * 2) + player.y * sin(self.mirror.rot * 2)
        self.image.y = player.x * sin(self.mirror.rot * 2) - player.y * cos(self.mirror.rot * 2)
        self.mirror.rot = self.mirror.rot + self.mirror.omiga
        self.circle.r = max(0, self.circle.r - 1)
        object.BulletDo(function(unit)
            if Dist(self.image.x, self.image.y, unit.x, unit.y) < self.image.a + unit.a then
                player.class.colli(player, unit)
                object.Del(unit)
            end
        end)
        object.IndesDo(function(unit)
            if Dist(self.image.x, self.image.y, unit.x, unit.y) < self.image.a + unit.a then
                player.class.colli(player, unit)
            end
        end)
    end
    function _tmp_sc:init()
        self._transport = New(Class(object, {
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(9)
                    end
                    object.RawDel(self)
                end)
            end,
            frame = task.Do
        }, true))
        self.mirror = { alpha = 1, omiga = 0, rot = 0 }
        self.refresh()
        task.New(self, function()
            task.Wait(111)
            NewText(320 + 160, 100 + 30, nil,
                    "《境界的彼方》(境界の彼方)是由鸟居奈古梦著作、鸭居知世插画的轻小说",
                    0, { 255, 100, 255 }, nil, function()
                        local self = task.GetSelf()
                        for i = 1, 30 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        task.Wait(180)
                        for i = 29, 0, -1 do
                            self.alpha = sin(i * 3) * 255
                            task.Wait()
                        end
                        object.RawDel(self)
                    end, "ui", "center")
        end)
        task.New(self, function()
            task.Wait()
            boss.cast(self, 66666)
            local s = 0
            local a
            while true do
                a = Angle(self, player)
                for _ = 1, 14 do
                    Create.bullet_accel(self.x + cos(a) * 16, self.y + sin(a) * 16, arrow_big, 6, 0.5, ran:Float(2, 3), a + s)
                    a = a + 360 / 14
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(70)
                a = Angle(self, player)
                for _ = 1, 14 do
                    Create.bullet_accel(self.x, self.y, ball_big, 6, 0.5, ran:Float(2, 3), a)
                    a = a + 360 / 14
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(70)
                s = s + 15
            end
        end)
        task.New(self, function()
            while true do
                if self.t then
                    break
                end
                task.Wait()
            end
            task.Wait(60)
            while true do
                PlaySound("tan00")
                Create.bullet_dec_acc(self.x, self.y, ball_mid_c, 2, 5, ran:Float(1, 4), ran:Float(0, 360))
                task.Wait(2)
            end
        end)
        task.New(self, function()
            task.Wait(300)
            Newcharge_in(self.x, self.y, 200, 30, 30)
            task.Wait(60)
            self.mirror = { alpha = 1, omiga = 0, rot = 45 }
            self.refresh()
            task.Wait(300)
            Newcharge_in(self.x, self.y, 200, 30, 30)
            task.Wait(60)
            self.mirror = { alpha = 1, omiga = 0, rot = -80 }
            self.refresh()
            task.Wait(300)
            Newcharge_in(self.x, self.y, 200, 30, 30)
            task.Wait(60)
            self.mirror = { alpha = 1, omiga = 0.1, rot = 0 }
            self.refresh()
            task.Wait(400)
            self.t = true
            Newcharge_in(self.x, self.y, 200, 30, 30)
            task.Wait(60)
            self.mirror = { alpha = 1, omiga = 0, rot = -90 }
            self.refresh()
        end)
    end
    function _tmp_sc:del()
        player.nextshoot = 0
    end
    boss.card.add({ { _tmp_sc, "23a" } }, 3, "「境界の彼方」", 39)
end--bosslw15