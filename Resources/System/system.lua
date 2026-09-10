local path = "Resources\\System\\"
LoadImageFromFile("stage_clear", path .. "stage_clear.png")
SetImageCenter("stage_clear", 256, 256)
local tex

do
    LoadSound("se_Sakura", path .. "se_Sakura.wav")
    LoadImageFromFile("Sakura1", path .. "Sakura1.png")
    LoadImageFromFile("Sakura2", path .. "Sakura2.png")
    LoadTexture("sakura_item", path .. "sakura_item.png")
    LoadImage("item11", "sakura_item", 0, 0, 32, 32, 8, 8)
    SetImageState("item11", "", 150, 200, 200, 200)
    LoadImage("item_up11", "sakura_item", 32, 0, 32, 32)
end--sakura

do
    LoadImageGroup("c_attack", "boss", 64, 0, 16, 8, 1, 16)
    for i = 1, 16 do
        SetImageState("c_attack" .. i, "mul+add", 255, 255, 255, 255)
    end
end--circle_attack


do
    tex = "hint.UFO"
    LoadTexture(tex, path .. 'hint.UFO.png')
    LoadImage("hint.UFO_blank", tex, 0, 16, 24, 16)
    LoadImageGroup("hint.UFO_filled", tex, 24, 0, 24, 16, 3, 1)
    LoadImageGroup("hint.UFO_charging", tex, 24, 16, 24, 16, 3, 1)
    LoadImageSetCenter("hint.UFO_bar", tex, 0, 32, 96, 16, 0, 4)
    LoadImageGroup("UFO_", tex, 0, 48, 32, 24, 3, 1)
    LoadImageGroup("UFO_Flicker_", tex, 0, 72, 32, 24, 3, 1)
    tex = "ufo_anim"
    LoadTexture(tex, path .. "ufo_anim.png")
    for i = 1, 4 do
        LoadAnimation("BIG_UFO_" .. i, tex, 0, 64 * i - 64, 64, 64, 4, 1, 8)
    end
    ---@type UFO
    DoFile(path .. "UFO.lua")
end--UFO

do
    tex = "hint.astral"
    LoadTexture(tex, path .. 'hint.astral.png')
    LoadImageSetCenter("astral_bone_on", tex, 64, 0, 32, 48, 16, 48)
    LoadImageSetCenter("astral_bone_off", tex, 96, 0, 32, 48, 16, 48)
    LoadImageSetCenter("astral_gauge_on", tex, 0, 0, 16, 32, 8, 32)
    LoadImageSetCenter("astral_gauge_off", tex, 16, 0, 16, 32, 8, 32)
    --LoadImage("astral_gauge_ing", 'hint.astral', 32, 0, 16, 32)直接用rt
    LoadImageGroup("astral_soul_normal", tex, 0, 33, 32, 32, 2, 1, 8, 8)
    LoadImageGroup("astral_soul_purple", tex, 0, 64, 32, 32, 1, 2, 8, 8)
    LoadImageGroup("astral_soul_green", tex, 32, 64, 32, 32, 1, 2, 8, 8)
    LoadImageGroup("astral_soul_blue", tex, 64, 64, 32, 32, 1, 2, 8, 8)
    LoadImageGroup("astral_soul_white", tex, 96, 64, 32, 32, 1, 2, 8, 8)
    LoadImageFromFile("eff_astral", path .. "eff_astral.png")
    ---@type Astral
    DoFile(path .. "Astral.lua")
end--astral

do
    LoadImageFromFile('Grazer2', path .. 'Grazer.png')
    ---@type grazer
end--grazer

do
    tex = "hint.season"
    LoadTexture(tex, path .. 'hint.season.png')
    LoadImage("Releasable", tex, 0, 32, 64, 16)
    LoadImageGroup("season_text", tex, 0, 0, 32, 32, 4, 1)
    LoadImageGroup("season_item", tex, 0, 64, 16, 16, 2, 2, 4, 4)
    ---@type Season
    DoFile(path .. "Season.lua")
end--season

do
    tex = "hint.beast"
    LoadTexture(tex, path .. 'hint.beast.png')
    LoadImageGroup("hint.beast_filled", tex, 0, 0, 48, 48, 3, 1)
    LoadAnimation("hint.beast_fillingpoint", tex, 0, 48, 16, 16, 11, 1, 4)
    SetAnimationCenter("hint.beast_fillingpoint", 8, 10)
    LoadAnimation("hint.beast_fillingfire", tex, 0, 64, 48, 48, 4, 3, 4)
    SetAnimationCenter("hint.beast_fillingfire", 24, 29)
    LoadImageGroup("Beast_Indv_", tex, 144, 0, 32, 32, 3, 1)
    LoadImageGroup("Beast_", tex, 0, 224, 32, 32, 3, 1)
    LoadImageGroup("Beast_Flicker_", tex, 96, 224, 32, 32, 3, 1)
    LoadTexture("eff_beast", path .. "eff_beast.png")

    tex = "beast_other"
    LoadTexture(tex, path .. 'beast_other.png')
    LoadAnimation("beast_aura1", tex, 0, 128, 64, 64, 4, 2, 4)
    SetAnimationCenter("beast_aura1", 32, 36)
    LoadAnimation("beast_aura2", tex, 0, 256, 64, 64, 4, 2, 4)
    SetAnimationCenter("beast_aura2", 32, 36)
    LoadAnimation("beast_aura3", tex, 0, 0, 64, 64, 4, 2, 4)
    SetAnimationCenter("beast_aura3", 32, 36)
    LoadAniFromFile("beast_hyper_tip", path .. "beast_hyper_tip.png", nil, 1, 2, 3)

    tex = "beast_tool"
    LoadTexture(tex, path .. 'beast_tool.png')
    LoadImageSetCenter("beast_hyper_2", tex, 0, 0, 80, 64, 80, 80)
    LoadImage("beast_hyper_1", tex, 0, 80, 64, 32, 48, 16)
    SetImageState("beast_hyper_1", "mul+add", 120, 255, 255, 255)
    CopyImage("beast_hyper_1_ef", "beast_hyper_1")
    LoadTexture("beast_hyper_3", path .. 'beast_tool2.png')
    ---@type Beast
    DoFile(path .. "Beast.lua")
end--beast

local lstg, cos, sin, table, string, int = lstg, cos, sin, table, string, int
local max, min = max, min
local task, object, item, ext = task, object, item, ext
local PlaySound = PlaySound
local IsValid, Dist, New = IsValid, Dist, New
local SetViewMode = SetViewMode
local SetImageState = SetImageState
local SetAnimationState = SetAnimationState
local Render = Render
local RenderAnimation = RenderAnimation
local SetFontState = SetFontState
local RenderText = RenderText
local Color = Color
local RenderTexture = RenderTexture
local unpack = unpack
local RenderRect = RenderRect
local manual = ext.manual

local sakura_back = Class(object)
function sakura_back:init(u)
    self.layer = LAYER.BG + 5
    self.group = GROUP.GHOST
    self.colli = false
    self.sakura = u
end
function sakura_back:frame()
    if not lstg.var.ON_sakura then
        Del(self)
    end
end
function sakura_back:render()
    if self.sakura then
        if self.sakura.black_alpha > 0 then
            if lstg.var.ON_sakura then
                SetImageState("white", "", self.sakura.black_alpha, 0, 0, 0)
            else
                SetImageState("white", "", self.sakura.black_alpha, 255, 255, 255)
            end
            RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
        end
        local s = self.sakura.circle
        local player = player
        if s.alpha > 0 then
            SetImageState("Sakura1", "mul+add", s.alpha / 2, 255, 255, 255)
            Render("Sakura1", player.x, player.y, s.rot[1], s.scale)
            SetImageState("Sakura2", "mul+add", s.alpha, 255, 255, 255)
            Render("Sakura2", player.x, player.y, s.rot[2], s.scale)
        end
    end
end

local hzc_buling = Class(object, {
    init = function(self, x, y, color)
        self.x, self.y = x, y
        self.layer = LAYER.TOP
        self.group = GROUP.GHOST
        self.color = color
    end,
    frame = function(self)
        if self.timer == 20 then
            Del(self)
        end
    end,
    render = function(self)
        SetImageState("circle_charge", "mul+add", (1 - self.timer / 21) * 255, unpack(self.color))
        Render("circle_charge", self.x, self.y, 0, self.timer / 21 / 5)
    end
})
local hzc_bullet_cleaner = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.layer = LAYER.TOP
        self.group = GROUP.GHOST
        self.colli = false
    end,
    frame = function(self)
        if self.timer == 20 then
            Del(self)
        end
        self.a = self.timer * 11
        cutLasersByCircle(self.x, self.y, self.a, item.obj.faith_minor)
        object.BulletDo(function(o)
            if Dist(self, o) < self.a then
                object.Kill(o)
            end
        end)
        object.LaserDo(function(o)
            if Dist(self, o) < self.a and not o.Isradial and not o.Isgrowing then
                object.Kill(o)
            end
        end)
    end,
    render = function(self)
        SetImageState("circle_charge", "mul+add", (1 - self.timer / 21) * 255, 135, 206, 235)
        Render("circle_charge", self.x, self.y, 0, self.timer / 21 * 220 / 256)
    end
})
_G.hzc_bullet_cleaner = hzc_bullet_cleaner

local astral_back = Class(object, { frame = task.Do })
function astral_back:init()
    self.layer = LAYER.BG + 1.2
    self.group = GROUP.GHOST
    self.colli = false
    self._a = 0
    PlaySound("boon01")
    task.New(self, function()
        for i = 1, 60 do
            self._a = 255 * sin(i * 1.5)
            task.Wait()
        end
        while lstg.var.ON_astral do
            task.Wait()
        end
        self.text = "0.00"
        for i = 59, 0, -1 do
            self._a = 255 * sin(i * 1.5)
            task.Wait()
        end
        object.RawDel(self)
    end)
end
function astral_back:render()
    SetImageState("eff_astral", "", self._a, 180, 180, 180)
    Render("eff_astral", 0, 0, -self.ani * 1.5)
    --SetFontState("Score", "", self._a, 180, 180, 180)
    --RenderText("Score", self.text or string.format("%0.2f", lstg.var.astral / 30), 0, 120, 1, "centerpoint")
end

local hyper_tip = Class(object)
function hyper_tip:init()
    self.x, self.y = player.x, min(lstg.world.t - 20, player.y + 32)
    self.group = GROUP.GHOST
    self.layer = LAYER.PLAYER - 1
    self.colli = false
    self.bound = false
    self.img = "beast_hyper_tip"
    self.hscale, self.vscale = 0.5, 0.5
end
function hyper_tip:frame()
    if self.timer > 90 then
        Del(self)
    end
end
_G.hyper_tip = hyper_tip

local beast_back = Class(object, { frame = task.Do })
function beast_back:init(who)
    self.layer = LAYER.BG + 3
    self.group = GROUP.GHOST
    self.colli = false
    self._r = 0
    self.who = who
    task.New(self, function()
        for i = 1, 60 do
            self._r = 800 * sin(i * 1.5)
            task.Wait()
        end
        while lstg.var.beast_charging do
            task.Wait()
        end
        for i = 59, 0, -1 do
            self._r = 800 * sin(i * 1.5)
            task.Wait()
        end
        object.RawDel(self)
    end)
end
function beast_back:render()
    local x, y = player.x, player.y
    misc.PolarCoordinatesRender("eff_beast", x, y, 0, self._r, -self.timer / 3, 128, 1, 0,
            "mul+rev", Color(128, 0, 0, 255), Color(175, 255, 0, 0), 128 / self._r)
    if self.who then
        RenderAnimation("beast_aura" .. self.who, self.timer, x, y)
    end
    SetImageState("white", "", 255, 0, 0, 0)
    RenderRect("white", x - 21, x + 21, y - 30, y - 35)
    SetImageState("white", "", 255, 100, 100, 255)
    RenderRect("white", x - 20, x - 20 + 40 * (lstg.var.beast_charging_time / lstg.var.max_beast_charging_time), y - 31, y - 34)
end
_G.beast_back = beast_back

local achievement = ext.achievement
local system = { }
function system:init()
    self.frame4_ChargeAction = {
        function()
            local y = player.y
            local rot = 0
            if self.player_name == 'reimu_player' then
                local b = reimu_player.bullets.trail
                local p = (lstg.var.man >= 80) and { 2, 0.7 } or { 1, 0.6 }
                for _ = 1, 30 do
                    for a = -p[1], p[1] do
                        for d = -1, 1, 2 do
                            New(b, player.x + 15 * d, y, 7, a * 5 - rot * d + 90 + 90 * d, 900, p[2])
                        end
                    end
                    task.Wait()
                    y = y + 384 / 29
                    rot = rot + 270 / 29
                end
            elseif self.player_name == 'marisa_player' then
                local b = marisa_player.bullets.missile
                local p = (lstg.var.man >= 80) and { 1, 7, 1.9 } or { 0.5, 10, 1.8 }
                for _ = 1, 40 do
                    for a = -p[1], p[1] do
                        for d = -1, 1, 2 do
                            New(b, player.x + 15 * d, y, 7, a * p[2] - rot * d + 90 + 90 * d, p[3])
                        end
                    end
                    task.Wait()
                    y = y + 384 / 39
                    rot = rot + 270 / 39
                end
            end

        end,
        function()
            lstg.var.charge = lstg.var.charge - 1
            New(Circle_Attack, player.x, player.y, 80, { 255, 255, 255 }, 60, 0, true)
            local a
            if self.player_name == 'reimu_player' then
                local b = reimu_player.bullets.trail
                local p = (lstg.var.man >= 80) and { 6, 4, 0.8 } or { 4, 8, 0.6 }
                for v = 3, 3 + p[1] - 1 do
                    a = ran:Float(0, 360)
                    for _ = 1, 20 do
                        New(b, player.x, player.y, v, a, 900, p[3])
                        a = a + 18
                    end
                    task.Wait(p[2])
                end
            elseif self.player_name == 'marisa_player' then
                local b = marisa_player.bullets.missile
                local p = (lstg.var.man >= 80) and { 4, 1.5 } or { 2, 1.7 }
                for v = 6, 6 + p[1] - 1 do
                    a = ran:Float(0, 360)
                    for _ = 1, 30 do
                        New(b, player.x, player.y, v, a, p[2])
                        a = a + 12
                    end
                    task.Wait(8)
                end
            end
        end
    }
    self.FaithEvents_ALL = {
        { "自机无敌5秒", function()
            player.protect = 300
        end },
        { "快速开启Hyper模式", function()
            if lstg.var.beast_charging then
                PlaySound("release")
                New(hyper_tip)
                New(Beast.base, player.x, player.y + 64, ran:Int(1, 3))
                New(Beast.base, player.x, player.y + 64, ran:Int(1, 3))
                lstg.var.beast_charging_time = lstg.var.max_beast_charging_time
            else
                local turn = { 0, 0, 0 }
                for _, p in ipairs(lstg.var.beast) do
                    turn[p] = turn[p] + 1
                end
                local hyper
                local count = max(unpack(turn))
                if count == turn[1] then
                    hyper = 1
                elseif count == turn[2] then
                    hyper = 2
                elseif count == turn[3] then
                    hyper = 3
                end
                --优先级红绿蓝
                for _ = 1, 9 - #lstg.var.beast do
                    table.insert(lstg.var.beast, hyper)
                    New(Beast.render_on, hyper, #lstg.var.beast)
                end
                Beast:check()
            end
        end, 11 },
        { "增加2级季节槽", function()
            Season.Addseason(200)
        end, 10 },
        { "充满灵界槽", function()
            Astral.GetAstral(300)
        end, 7 },
        { "快速召唤UFO", function()
            if IsValid(UFO.big_ufo) then
                local ufo = sp:CopyTable(lstg.var.UFO)
                object.Kill(UFO.big_ufo)
                for i = 1, 3 do
                    UFO:Insert(ufo[i])
                end
            else
                local ufo = lstg.var.UFO
                local count = #ufo
                if count == 0 then
                    --无ufo时自动生成彩ufo
                    for i = 1, 3 do
                        UFO:Insert(i)
                    end
                elseif count == 1 then
                    --1个ufo时生成该色ufo
                    for _ = 1, 2 do
                        UFO:Insert(ufo[1])
                    end
                elseif #ufo == 2 then
                    --2个ufo时，如果2个同色就生成该色ufo，异色则生成彩ufo
                    if ufo[1] == ufo[2] then
                        UFO:Insert(ufo[1])
                    else
                        --1,2→3  2,3→1  1,3→2
                        UFO:Insert(-(ufo[1] + ufo[2]) + 6)
                    end
                end
            end
        end, 6 },
        { "蓄力满级", function()
            SetChargeLevel(3)
        end, 3 },
        { "开启樱花结界", function()
            lstg.var.sakura = 50000
        end, 1 },
    }--记得去system_store.lua写一下
    self.Graze_color = { 200, 200, 200 }
    self.frame2_ManAction = {
        function(self)
            self.man.col = { 128, 128, 128 }
            self.man.addp = 90
            self.man.subp = max(self.man.subp - 0.3, 0)
        end,
        function(self)
            self.man.col = { 255, 255, 255 }
            self.man.subp = 90
            self.man.addp = max(self.man.addp - 0.5, 0)
        end
    }
    self.playerIDs = { reimu_player = 1, chiruno_player = 2, aya_player = 3, marisa_player = 4 }
    self.addtime = scoredata.Player_playtime
    self:init_value()
end
function system:frame()
    self.timer = stage.current_stage.timer
    task.Do(self)
    if self.addtime[self.playerID] >= 216000 then
        achievement:get(76 + self.playerID)
    end
    if self.addtime[self.playerID] >= 864000 then
        achievement:get(80 + self.playerID)
    end
    self.addtime[self.playerID] = self.addtime[self.playerID] + 1
    local f = self.DoFrame
    for _, i in ipairs(self.do_index) do
        if f[i] then
            f[i](self)
        end
    end
end
function system:render()

    local r = self.DoRender
    local w = lstg.world
    self.timer = stage.current_stage.timer
    local alpha = min(self.timer / 120, 1)
    for _, i in ipairs(self.do_index) do
        if r[i] then
            r[i](self, w, alpha)
        end
    end
    SetViewMode("world")
    if player.protect > 0 then
        local tA = min(player.protect, 20) / 20
        ui:RenderText("title", ("%0.2f"):format(player.protect / 60), player.x, player.y + 20,
                0.4, Color(tA * 150, 255, 255, 255), "centerpoint")
    end
end
function system:init_value()
    self.task = {}
    self.sakura = {
        black_alpha = 0,
        circle = { alpha = 0, rot = { 0, 0 }, omiga = { -0.6, 0.6 }, scale = 1.1 },
        count = 0,
        CD = 0
    }
    self.man = { addp = 90, subp = 0, col = { 255, 255, 255 } }
    self.charge = { alpha = 0 }
    self.FaithEventText = {}
    local v = lstg.var
    if v.ON_sakura then
        New(sakura_back, self.sakura)
    end
    self.player_name = GetGlobal("player_name")
    self.seasonid = v.seasonid
    self.playerID = self.playerIDs[self.player_name]
    if v.UFO then
        for i, u in ipairs(v.UFO) do
            New(UFO.render_on, u, i)
        end
    end
    if v.beast then
        for i, u in ipairs(v.beast) do
            New(Beast.render_on, u, i)
        end
    end
    if v.ON_astral then
        New(astral_back)
    end
    if v.beast_charging_time and v.beast_charging_time > 0 then
        New(beast_back, v.hyper_mode)
    end

    self.do_index = {}
    if v.current_system then
        local str = v.current_system
        for i = 1, #str do
            table.insert(self.do_index, str:sub(i, i):byte() - 64)
        end
    end

    self.FaithEvents = {}
    for _, p in ipairs(self.FaithEvents_ALL) do
        if p[3] then
            if SearchStageLevel[p[3]] then
                table.insert(self.FaithEvents, { p[1], p[2] })
            end
        else
            table.insert(self.FaithEvents, { p[1], p[2] })
        end
    end
end
function system.countdist(x, y)
    if lstg.world.t > 224 then
        local player = player
        if IsValid(player) and Dist(player.x + 320, player.y + 240, x, y) <= 90 then
            return 1 - (90 - max(Dist(player.x + 320, player.y + 240, x, y), 40)) / 55
        else
            return 1
        end
    else
        return 1
    end
end
system.DoFrame = {
    [1] = function(self)
        local s = self.sakura
        if not lstg.var.ON_sakura and lstg.var.sakura >= 50000 and s.CD <= 0 then
            lstg.var.ON_sakura = true
            New(sakura_back, self.sakura)
            s.circle.scale = 1.1
            PlaySound("se_Sakura", 1)
            lstg.var.sakura_bonus = true
            player.protect = 60
        end
        if lstg.var.ON_sakura then
            for _, unit in ObjList(GROUP.ITEM) do
                unit.target = player
                unit.attract = 8
            end
            s.black_alpha = min(s.black_alpha + 2, 120)
            s.circle.alpha = min(s.circle.alpha + 255 / 60, 255)
            s.circle.rot[1] = s.circle.rot[1] + s.circle.omiga[1]
            s.circle.rot[2] = s.circle.rot[2] + s.circle.omiga[2]
            s.circle.scale = lstg.var.sakura / 50000 + 0.1
            lstg.var.sakura = max(lstg.var.sakura - 50000 / 540, 0)
            if lstg.var.sakura == 0 then
                lstg.var.ON_sakura = false
                if lstg.var.sakura_bonus then
                    s.count = min(s.count + 1, 10)
                    New(Sakura_bonus, s.count)
                else
                    s.count = 0
                    item.ClearBossBonus()
                    PlaySound("bonus2", 0.2, 0, false)
                    local b
                    object.BulletDo(function(unit)
                        b = New(item.obj.sakura, unit.x, unit.y, nil, nil, 10)
                        b.attract = 8
                        b.target = player
                        Del(unit)
                    end)
                end
                player.protect = 40
                s.CD = 80
            end
        else
            s.black_alpha = max(s.black_alpha - 12, 0)
            s.circle.alpha = max(s.circle.alpha - 25.5, 0)
        end
        s.CD = max(0, s.CD - 1)
    end,
    [2] = function(self)
        if self.player_name == "aya_player" then
            return
        end
        local p = player
        local m = self.man
        if self.charge.alpha == 0 then
            lstg.var.man = max(0, min(100, lstg.var.man + sin(90 - m.addp) * 0.7 - sin(90 - m.subp) * 0.6))
        end

        if not p.dialog and not p.lock and not p.time_stop then
            if p.timer % 4 == 0 then
                if p.__slow_flag then
                    self.frame2_ManAction[1](self)
                else
                    if p.__shoot_flag then
                        if self.charge.alpha == 0 then
                            self.frame2_ManAction[2](self)
                        end
                    else
                        self.frame2_ManAction[1](self)
                    end
                end
            end
            if lstg.var.man >= 80 then
                m.col = { 250, 128, 114 }

                if not lstg.tmpvar.stop_add_score then
                    lstg.var.score = lstg.var.score + 100
                end
            end
        end
    end,
    [3] = function(self)
        local c = self.charge
        if KeyIsPressed("spell") then
            PlaySound("hyz_charge00", 1, player.x / 256, false)
        end
        if player.__spell_flag then
            c.alpha = min(255, c.alpha + 255 / 15)
            lstg.var.charging = min(lstg.var.charge + 1, lstg.var.charging + 1 / 60)
            player.nextshoot = 4
        else
            local charge = int(lstg.var.charging)
            c.alpha = max(0, c.alpha - 255 / 15)
            if lstg.var.charging > 0 then
                lstg.var.charging = 0
            end
            if charge <= 0 then
                return
            end
            for i = 1, min(2, charge) do
                task.New(player, self.frame4_ChargeAction[i])
            end
            if charge == 3 then
                lstg.var.charge = lstg.var.charge - 1
                New(Circle_Attack, player.x, player.y, 150, { 255, 255, 255 }, 180, 1)
            elseif charge == 4 then
                lstg.var.charge = lstg.var.charge - 2
                New(Circle_Attack, player.x, player.y, 250, { 255, 255, 255 }, 300, 1)
            end

        end
    end,
    [4] = function(self)
        --if KeyIsPressed("spell") then lstg.var.faith=lstg.var.faith_maxcount end
        local m = self.FaithEventText
        if m.timer then
            m.timer = m.timer + 1
            if m.timer >= 300 then
                self.FaithEventText = {}
            end
        end
        if lstg.var.faith_maxcount == 0 then
            lstg.var.faith_maxcount = 1500
        elseif lstg.var.faith >= lstg.var.faith_maxcount then
            PlaySound("bonus")
            lstg.var.faith = lstg.var.faith - lstg.var.faith_maxcount
            local bonus = ran:Int(1, #self.FaithEvents)
            self.FaithEventText = { timer = 0, msg = self.FaithEvents[bonus][1] }
            self.FaithEvents[bonus][2]()
            lstg.var.faith_maxcount = 1500
        end
    end,
    [5] = function(self)
        local var = lstg.var
        var.grazerevp = min(90, var.grazerevp + 0.2)
        var.grazetimes = max(0.1, var.grazetimes - 0.007 * sin(max(0, var.grazerevp)))
        if var.grazetimes >= 3 or player.y >= player.collect_line then
            if self.timer % 10 + 1 <= 5 then
                self.Graze_color = { 255, 227, 132 }
            else
                self.Graze_color = { 220, 220, 220 }
            end
        else
            self.Graze_color = { 200, 200, 200 }
        end
        if var.grazetimes >= 3 then
            for _, unit in ObjList(GROUP.ITEM) do
                unit.target = player
                unit.attract = 8
            end
        end
    end,
    [7] = function()
        local p = player
        if lstg.var.ON_astral then
            for _, o in ObjList(GROUP.ITEM2) do
                if o.IsAstral then
                    if o.attract < 7 then
                        o.attract = o.attract + 0.1
                        o.target = p
                    end
                end
            end
        else
            for _, o in ObjList(GROUP.ITEM2) do
                if o.IsAstral then
                    if o.attract < 5 and Dist(p, o) < 80 then
                        o.attract = o.attract + 0.1
                        o.target = p
                    end
                end
            end
        end
        --连击处理
        lstg.var.blue_time = max(lstg.var.blue_time - 1, 0)
        if lstg.var.blue_time == 0 then
            lstg.var.blue_combo = 0
        end
        if lstg.var.astral == 300 and not lstg.var.ON_astral and p.__slow_flag and KeyIsPressed("special") then
            lstg.var.ON_astral = true
            New(astral_back)
            achievement:get(32)
        end
        if lstg.var.ON_astral then
            lstg.var.astral = max(0, lstg.var.astral - 0.5)
            p._alpha = 100
            item.ClearBossBonus()
            if lstg.var.astral == 0 then
                lstg.var.ON_astral = false
                p._alpha = 255
                player.protect = 80
            end
        end
    end,
    [8] = function()
        local bar = lstg.var.itembar
        local count = bar.red + bar.blue + bar.green

        if count >= 300 then
            local MAX = max(bar.red, bar.blue, bar.green)
            local way = ""
            local id
            local player = player
            if MAX == bar.red then
                way = "red"
                id = { 250, 128, 114 }
                --这太bug了
                --New(item.obj.revdead, player.x, player.y + 60)
                if SearchStageLevel[1] then
                    lstg.var.sakura = 50000
                end
            elseif MAX == bar.blue then
                way = "blue"
                id = { 135, 206, 235 }
                New(hzc_bullet_cleaner, player.x, player.y)
            else
                way = "green"
                id = { 189, 252, 201 }
                item.Dropitem(item.obj.addcharge, 1, player.x, player.y + 60)
            end
            if bar[way] / count == 1 then
                achievement:get(41)
            end
            lstg.var.score = lstg.var.score + item.TweakScore(100000 * bar[way] / count)
            New(hzc_buling, player.x, player.y, id)
            New(float_text, "Score", string.format("Pureness   %d%%", bar[way] / count * 100),
                    player.x, player.y + 50, 0, 0, 90, 0.3, 0.3, Color(255, unpack(id)), Color(0, 0, 0, 0))
            New(float_text, "Score", way:upper() .. " BONUS",
                    player.x, player.y + 80, 0, 0, 90, 0.3, 0.3, Color(255, unpack(id)), Color(0, 0, 0, 0))
            bar.red = 0
            bar.blue = 0
            bar.green = 0
            PlaySound("bonus3", 1, 0, true)
        end

    end,
    [10] = function(self)
        local p = player
        local v = lstg.var
        if v.seasoncd > 0 then
            v.seasoncd = v.seasoncd - 1
        end
        if v.season >= 100 and v.seasoncd == 0 and (not p.__slow_flag) and KeyIsPressed("special") then
            if v.season >= 600 then
                achievement:get(28)
            end
            New(Season.Attack[self.seasonid], int(v.season / 100))
            PlaySound("release")
            for _, unit in ObjList(6) do
                unit.target = player
                unit.attract = 8
            end
        end
    end,
    [11] = function()
        local v = lstg.var
        if v.beast_charging_time > 0 then
            v.beast_charging_time = v.beast_charging_time - 1
            Beast:Attack()
            if v.beast_charging_time == 0 then
                v.beast_charging = false
                v.hyper_mode = nil
                if v.get_beast_hyper then
                    New(hyper_tip)
                    New(Beast.base, player.x, player.y + 64, ran:Int(1, 3))
                    New(Beast.base, player.x, player.y + 64, ran:Int(1, 3))
                    v.get_beast_hyper = false
                end
                for _ = 1, 9 do
                    Del(Beast.stay_in[1])
                    table.remove(v.beast, 1)
                    table.remove(Beast.stay_in, 1)
                end
            end
        end
    end
}
local centerpoint = "centerpoint"
local white = "white"
local normal = ""
local font = "Score"
local blend = ""
local ttf = "title"
local center = "center"
local bottom, top = "bottom", "top"
local left = "left"
local right = "right"
system.DoRender = {
    [1] = function(self, w, alpha)
        SetViewMode("ui")
        local a = alpha * 255
        local scrr, scrt = w.scrr, w.scrt
        local var = lstg.var
        SetImageState("line_7", normal, a, 255, 255, 255)
        RenderRect("line_7", scrr + 6, 960 - 6, scrt - 156, scrt - 164)
        ui:RenderText(ttf, "樱点", scrr + 6, scrt - 155,
                0.7, Color(a, 218, 160, 214), left, bottom)
        ui:RenderText(ttf, ("%d/%d"):format(var.sakura, 50000), 960 - 6, scrt - 160,
                0.6, Color(a, 218, 160, 214), right, bottom)
        SetImageState(white, normal, a, 255, 255, 255)
        RenderRect(white, scrr + 6, scrr + 70, scrt - 155, scrt - 158)
        SetImageState(white, normal, a, 50, 50, 50)
        RenderRect(white, scrr + 6.5, scrr + 69.5, scrt - 155.5, scrt - 157.5)
        local color = Color(a, 250, 128, 114)
        if self.sakura.CD > 0 then
            color = Color(a, 128, 128, 128)
        end
        if lstg.var.ON_sakura then
            color = Color(a, 218, 112, 214)
        end
        SetImageState(white, normal, color)
        RenderRect(white, scrr + 6.5, scrr + 6.5 + 63 * (var.sakura / 50000), scrt - 155.5, scrt - 157.5)
    end,
    [2] = function(self, w, alpha)
        if self.player_name == "aya_player" then
            return
        end
        SetViewMode("world")
        local var = lstg.var
        ui:RenderText(ttf, ("%0.1f%%"):format(var.man), player.x, max(w.b + 10, player.y - 20),
                0.43, Color(alpha * 255, unpack(self.man.col)), center)
    end,
    [3] = function(self, w, alpha)
        SetViewMode("world")
        local var = lstg.var
        if self.charge.alpha > 0 then
            ui:RenderText(ttf, ("%d/%d"):format(var.charging, var.charge + 1), player.x, min(w.t - 20, player.y + 35),
                    0.8, Color(self.charge.alpha * alpha, 255, 255, 255), centerpoint)
        end
    end,
    [4] = function(self, w, alpha)
        SetViewMode("ui")
        local a = alpha * 255
        local scrr, scrt = w.scrr, w.scrt
        local var = lstg.var
        SetImageState("line_7", normal, a, 255, 255, 255)
        RenderRect("line_7", scrr + 6, 960 - 6, scrt - 186, scrt - 194)
        ui:RenderText(ttf, "信仰值", scrr + 6, scrt - 185,
                0.7, Color(a, 189, 252, 201), left, bottom)
        ui:RenderText(ttf, ("%d/%d"):format(var.faith, var.faith_maxcount), 960 - 6, scrt - 190,
                0.6, Color(a, 189, 252, 201), right, bottom)
        SetImageState(white, normal, a, 255, 255, 255)
        RenderRect(white, scrr + 6, scrr + 70, scrt - 185, scrt - 188)
        SetImageState(white, normal, a, 50, 50, 50)
        RenderRect(white, scrr + 6.5, scrr + 69.5, scrt - 185.5, scrt - 187.5)
        SetImageState(white, normal, a, 189, 252, 201)
        RenderRect(white, scrr + 6.5, scrr + 6.5 + 63 * (var.faith / var.faith_maxcount), scrt - 185.5, scrt - 187.5)
        if self.FaithEventText.msg then
            ui:RenderText(ttf, self.FaithEventText.msg, 960 - 6, scrt - 181,
                    0.55, Color(alpha * 255 * min(1, sin(self.FaithEventText.timer * 0.6) * 8), 230, 255, 230), right, bottom)
        end

    end,
    [5] = function(self, w, alpha)
        SetViewMode("ui")
        local scrr, scrt = w.scrr, w.scrt
        local var = lstg.var
        ui:RenderText(ttf, ("(x%0.1f) %d"):format(var.grazetimes, item.TweakScore((var.ON_sakura and 1200 or 200) * var.grazetimes)),
                scrr + 40, scrt - 69, 0.6, Color(alpha * 255, unpack(self.Graze_color)), left, bottom)
    end,
    [6] = function(_, w, alpha)
        SetViewMode("ui")
        local a = alpha * 255
        local x, y = w.scrl - 140, w.scrb - 120
        local var = lstg.var
        SetImageState("hint.UFO_bar", normal, a, 255, 255, 255)
        Render("hint.UFO_bar", 0 + x, 330 + y)
        SetImageState("hint.UFO_blank", normal, a, 255, 255, 255)
        for i = 1, 3 do
            Render("hint.UFO_blank", i * 24 - 8 + x, 330 + y)
        end
        ui:RenderText(ttf, "Next", 96 + x, 320 + y, 0.6, Color(a, 180, 180, 180), centerpoint)
        local n = "UFO_" .. var.UFO_next
        SetImageState(n, normal, a, 255, 255, 255)
        Render(n, 96 + x, 336 + y, 0, 0.9, 0.9)
        SetImageState(n, normal, 255, 255, 255, 255)
        if var.UFO_mode == 2 then
            ui:RenderText(ttf, "?", 96 + x, 336 + y, 1.1, Color(a, 180, 180, 180), centerpoint)
        end

    end,
    [7] = function(self, w, alpha)
        SetViewMode("ui")
        local a = alpha * 255
        local x, y = w.scrl - 60, w.scrb
        local var = lstg.var
        SetImageState("astral_gauge_off", normal, a, 255, 255, 255)
        for i = 0, 2 do
            Render("astral_gauge_off", x - 50 + i * 16, y)
        end
        local color
        local state
        if var.astral >= 100 then
            color = Color(a, 255, 230 + 20 * sin(self.timer * 3), 255)
            state = "on"
        else
            color = Color(a, 255, 255, 255)
            state = "off"
        end
        SetImageState("astral_bone_" .. state, normal, color)
        Render("astral_bone_" .. state, x - 68, y - 2)
        if var.astral / 100 >= 1 then
            SetImageState("astral_gauge_on", normal, color)
            for i = 0, var.astral / 100 - 1 do
                Render("astral_gauge_on", x - 50 + i * 16, y)
            end
        end
        --32,0,48,32
        if var.astral < 300 then
            local i = int(var.astral / 100)
            local c = (var.astral - i * 100) / 100
            if c > 0 then
                local col = Color(255, 255, 255, 255)
                RenderTexture("hint.astral", normal,
                        { x - 58 + i * 16, y + 32, 0.5, 32, 0, col },
                        { x - 58 + i * 16 + 16 * c, y + 32, 0.5, 32 + 16 * c, 0, col },
                        { x - 58 + i * 16 + 16 * c, y, 0.5, 32 + 16 * c, 32, col },
                        { x - 58 + i * 16, y, 0.5, 32, 32, col })
            end
        end
        SetViewMode("world")
        if var.ON_astral then
            ui:RenderText("big_text", ("%0.2f"):format(var.astral / 30), 0, w.t - 60,
                    1, Color(255, 255, 255, 255), "center")
        end

    end,
    [8] = function(_, w, alpha)
        SetViewMode("ui")
        local a = alpha * 255
        local scrr, scrt = w.scrr, w.scrt
        local var = lstg.var
        local bar = var.itembar
        local count = max(bar.red + bar.blue + bar.green, 1)
        SetImageState("line_7", normal, a, 255, 255, 255)
        RenderRect("line_7", scrr + 6, 960 - 6, scrt - 216, scrt - 224)
        ui:RenderText(ttf, "道具比例",
                scrr + 6, scrt - 215, 0.7, Color(a, 255, 255, 230), left, bottom)
        ui:RenderText(ttf, ("%02d%%"):format(bar.red / count * 100),
                scrr + 75, scrt - 214, 0.55, Color(a, 255, 100, 100), right, bottom)
        ui:RenderText(ttf, ("%02d%%"):format(bar.blue / count * 100),
                scrr + 100, scrt - 214, 0.55, Color(a, 100, 100, 255), right, bottom)
        ui:RenderText(ttf, ("%02d%%"):format(bar.green / count * 100),
                scrr + 125, scrt - 214, 0.55, Color(a, 100, 255, 100), right, bottom)
        ui:RenderText(ttf, ("%d%%"):format(count / 3),
                960 - 6, scrt - 220, 0.6, Color(a, 173, 173, 173), right, bottom)
        SetImageState(white, normal, a, 255, 255, 255)
        RenderRect(white, scrr + 6, scrr + 125, scrt - 215, scrt - 218)
        SetImageState(white, normal, a, 50, 50, 50)
        RenderRect(white, scrr + 6.5, scrr + 124.5, scrt - 215.5, scrt - 217.5)
        SetImageState(white, normal, a, bar.red / count * 255, bar.green / count * 255, bar.blue / count * 255)
        RenderRect(white, scrr + 6.5, scrr + 6.5 + 118 * count / 300, scrt - 215.5, scrt - 217.5)
    end,
    [10] = function(self, w, alpha)
        SetViewMode("ui")

        local a = alpha * 255
        local x, y = w.scrl - 140, w.scrb - 45
        local var = lstg.var
        SetImageState("season_text" .. self.seasonid, normal, a, 255, 255, 255)
        Render("season_text" .. self.seasonid, 13 + x, 220 + y, 0, 0.5)

        local value = var.season / 100
        if value < 1 then
            SetImageState(white, normal, a, 120, 120, 255)
            RenderRect(white, 10 + x, 10 + 54 * value + x, 212 + y, 207 + y)
        elseif value < 6 then
            SetImageState(white, normal, a, 120, 120, 255)
            RenderRect(white, 10 + x, 64 + x, 212 + y, 207 + y)
            OriginalSetImageState(white, normal,
                    Color(a, 255, 227, 132),
                    Color(a, 255, 255, 255),
                    Color(a, 255, 255, 255),
                    Color(a, 255, 227, 132))
            RenderRect(white, 10 + x, 10 + 54 * (value % 1) + x, 212 + y, 207 + y)
        else
            OriginalSetImageState(white, normal,
                    Color(a, 255, 227, 132),
                    Color(a, 255, 255, 255),
                    Color(a, 255, 255, 255),
                    Color(a, 255, 227, 132))
            RenderRect(white, 10 + x, 64 + x, 212 + y, 207 + y)
        end
        SetImageState(white, normal, a, 120, 120, 150)
        misc.RenderOutLine(white, 10 + x, 64 + x, 212 + y, 207 + y, 0.5, 0)
        ui:RenderText(ttf, ("%d"):format(value), 70 + x, 207 + y, 0.9, Color(a, 128, 128, 255), left, bottom)
        if value >= 1 then
            if self.timer % 45 < 23 then
                SetImageState("Releasable", normal, a, 255, 255, 255)
            else
                SetImageState("Releasable", normal, a, 160, 255, 255)
            end

            Render("Releasable", 36 + x, 218 + y, 0, 0.5)
        end
    end,
    [11] = function(self, w, alpha)
        SetViewMode("ui")
        local a = alpha * 255
        local x, y = w.scrl - 150, w.scrb - 42
        local var = lstg.var
        SetImageState(white, normal, alpha * 150, 255, 227, 132)
        for i = 0, 2 do
            RenderRect(white, 32 + x, 96 + x, 168 - i * 32 + 0.5 + y, 168 - i * 32 - 0.5 + y)
        end
        for j = 0, 2 do
            RenderRect(white, 32 + j * 32 + 0.5 + x, 32 + j * 32 - 0.5 + x, 168 + y, 104 + y)
        end
        SetAnimationState("hint.beast_fillingpoint", normal, a, 255, 255, 255)
        local t = 1
        for i = 0, 2 do
            for j = 0, 2 do
                RenderAnimation("hint.beast_fillingpoint", self.timer + t * 4, 32 + j * 32 + x, 168 - i * 32 + y)
                t = t + 1
            end
        end
    end
}

lstg.system = system
lstg.system:init()

local SearchStageLevel = SearchStageLevel
function SetChargeLevel(n)
    if SearchStageLevel[3] then
        lstg.var.charge = min(n, 3)
        lstg.system.charge.alpha = 255
    end
end
System = Class(object)

Sakura_bonus = Class(object, { frame = task.Do })
function Sakura_bonus:init(count)
    PlaySound("bonus")
    self.alpha = 0
    self.group = 0
    self.layer = 1
    self.count = count
    lstg.var.score = lstg.var.score + 540000 * count
    task.New(self, function()
        for i = 1, 60 do
            self.alpha = sin(i * 1.5)
            task.Wait()
        end
        task.Wait(120)
        for i = 59, 0, -1 do
            self.alpha = sin(i * 1.5)
            task.Wait()
        end
        Del(self)
    end)
end
function Sakura_bonus:render()
    SetViewMode("ui")
    local w = lstg.world
    local scrr, scrt = w.scrr, w.scrt
    ui:RenderText("title", ("Bonus! %d"):format(self.count * 540000), 960 - 6 + 60 - 60 * self.alpha, scrt - 151,
            0.55, Color(self.alpha * 255, 255, 230, 255), right, bottom)
    SetViewMode("world")
end

Circle_Attack = Class(object)
function Circle_Attack:init(x, y, radius, color, time, dmg, nocbn)
    self.dmg = dmg
    self.x, self.y = x, y
    self.vy = 1
    self.radius = radius
    self.bound = false
    PlaySound("slash", 0.2, 0, false)
    self.circle = {}
    self.r = 0
    if not nocbn then
        item.ClearBossBonus()
    end
    self.color = color
    self.layer = LAYER.PLAYER
    self.group = GROUP.PLAYER_BULLET
    self.killflag = true
    self.alpha = 1
    self.leaf = {}
    player.protect = time
    task.New(self, function()
        for i = 1, time / 2 do
            self.r = self.radius * sin(i / (time / 4 * 3) * 90)
            task.Wait()
        end
        task.Wait(time / 2)
        self.colli = false
        for i = 29, 0, -1 do
            self.alpha = sin(i * 3)
            task.Wait()
        end
        Del(self)
    end)
end
local rand = math.random
function Circle_Attack:frame()
    task.Do(self)
    self.a = self.r
    self.b = self.r
    if self.colli then
        local a
        for _ = 1, 2 do
            a = rand() * 360
            table.insert(self.leaf, { x = self.x + self.r * cos(a), y = self.y + self.r * sin(a), scale = 0,
                                      a = a + (rand() - 0.5) * 20, v = (rand() + 0.8) * 0.4,
                                      rot = rand() * 360, omiga = (rand() + 1) * ({ -1, 1 })[rand(2)],
                                      timer = 1 })
        end
    end
    local l
    for i = #self.leaf, 1, -1 do
        l = self.leaf[i]
        if l.timer <= 3 then
            l.scale = min(l.scale + 0.8 / 3, 0.8)
        else
            l.x = l.x + cos(l.a) * l.v
            l.y = l.y + sin(l.a) * l.v
            l.scale = max(l.scale - 0.02, 0)
        end
        l.rot = l.rot + l.omiga
        l.timer = l.timer + 1
        if l.scale == 0 then
            table.remove(self.leaf, i)
        end
    end
    if self.colli then
        New(bomb_bullet_killer, self.x, self.y, self.r, self.r, false)
    end
end
function Circle_Attack:render()
    for i = 1, 16 do
        SetImageState("c_attack" .. i, 'mul+add', self.alpha * 255, 255, 255, 255)
    end
    misc.RenderRing("c_attack", self.x, self.y, self.r - 22, self.r + 10, self.timer * 8, 32, 16)
    SetImageState("leaf", "mul+add", 255, 250, 128, 114)
    for _, l in ipairs(self.leaf) do
        Render("leaf", l.x, l.y, l.rot, l.scale)
    end
end

