lstg.wis = lstg.wis or {}
s7_boss = {}

local _ACT_NONE_AUTO_Iwabuchi, _ACT_CAST_Iwabuchi, _ACT_CAST2_Iwabuchi
local cast, cast2

local path = "res/stage/stage7/"
--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Iwabuchi_boss"
local texFile = path.."Iwabuchi_boss.png"
local tex_u, tex_v, tex_n = 180, 180, 9


local function load_res()
    --载入行走图资源
    LoadTexture(tex, texFile)
    --符卡背景加载
    path = "res/background/boss7/"
    for i = 1, 5 do
        LoadImageFromFile("s7_boss_scbg"..i, path .. "scbg"..i..".png")
    end
    --立绘加载
    path = "res/stage/stage7/"
    LoadImageFromFile("s7boss_pic", path .. "s7boss_pic.png", true, 0, 0, false, 0)
    --地爆天星
    LoadImageFromFile("stone_unclear", path.."stone_unclear.png", true, 64, 64)
    --三种石头
    LoadTexture("stone", path.."stone.png")
    LoadImage("stone_mid", "stone", 0, 0, 128, 128, 4, 4)
    LoadImage("stone_big", "stone", 128, 0, 128, 128, 8, 8)
    LoadImage("stone_huge", "stone", 256, 0, 128, 128, 12, 12)
    --尖石头
    LoadImageFromFile("pointed_stone", path.."pointed_stone.png", true, 24, 4)
    --手掌
    LoadTexture("hands", path.."hands.png")
    LoadImage("hand", "hands", 148, 0, 148, 284, 16, 70, true)
    SetImageCenter("hand", 90, 130)
    --[[冲击波
    LoadTexture("dash", path.."dash.png")]]

end
load_res()

--精简的蓄力特效
local simAbsorbEff = Class(object)
function simAbsorbEff:init(x, y, img1, img2, R, G, B, blend)
    blend = blend or "mul+add"
    local imgs = {img1 or 'bamboo_leaf_white', img2 or 'tree_leaf_white'}
    self.bound = false
    self.x, self.y = 0, 0
    PlaySound("power02", 0.5)
    task.New(self, function()
        local obj = New(qhm_eff.eff_11, x, y, 4.5, R, G, B, blend)
        obj.img = "starlight"
        local a, r
        for _ = 1, 15 do
            for _ = 1, 1 do
                a, r = ran:Float(0, 360), ran:Float(350, 600)
                New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.5, 1.25), R, G, B, blend)
            end
            task.Wait(2)
        end
        Del(self)
    end)
    task.New(self, function()
        local a, r
        for _ = 1, 20 do
            for _ = 1, 1 do
                a, r = ran:Float(0,360), ran:Float(300,600)
                New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.075,0.125), R, G, B, blend)
            end
            task.Wait(2)
        end
    end)
end
function simAbsorbEff:frame()
    task.Do(self)
end

local function simeff(x, y)
    New(simAbsorbEff, x, y, nil, nil, 159, 249, 252, "mul+add")
end
s7_boss.simeff = simeff

local function set_bgm_speed(name, speed)
    if lstg.CheckRes(4, name) then
        lstg.SetBGMSpeed(name, speed)
    end
end

--特殊能力（减速obj
--加了BGM变速功能 by Xiliusha，不影响replay功能
local timeslow = Class(object)
function timeslow:init(boss)
    self.boss = boss
    self.slow_times = 0 --减速时间，大于0就减速
    self.fps = 60
    self.minfps = 45
    lstg.var.timeslow = nil
    set_bgm_speed("s7_boss", 1)
end
--[[function timeslow:frame()
    if IsValid(self.boss) then
        local scbg = self.boss.bg
        if self.slow_times > 0 then
            --自机处于无敌就没必要浪费时间了
            if player.protect < 60 then
                self.fps = max(self.minfps, self.fps - 5)
            else
                self.fps = min(60, self.fps + 1)
            end
            self.slow_times = self.slow_times - 1
            if IsValid(scbg) then
                scbg.drate = -0.1
            end
        else
            self.fps = min(60, self.fps + 1)
            if IsValid(scbg) then
                scbg.drate = 0.1
            end
        end
        SetFPS(self.fps)
    else
        Del(self)
    end
end]]
function timeslow:frame()
    if IsValid(self.boss) then
        local scbg = self.boss.bg
        self.slow_times = max(0, self.slow_times - 1)
        if self.slow_times > 0 and player.protect < 60 then
            --自机处于无敌就没必要浪费时间了
            if self.minfps == 45 then
                lstg.var.timeslow = 1.5
                if setting.allow_change_bgm_speed then
                    set_bgm_speed("s7_boss", 0.66)
                end
            elseif self.minfps == 30 then
                lstg.var.timeslow = 2
                if setting.allow_change_bgm_speed then
                    set_bgm_speed("s7_boss", 0.5)
                end
            end
            if IsValid(scbg) then
                scbg.drate = -0.1
            end
        else
            if IsValid(scbg) then
                scbg.drate = 0.1
            end
            lstg.var.timeslow = nil
            set_bgm_speed("s7_boss", 1)
        end
    else
        Del(self)
    end
end
function timeslow:addTimes(dt)
    --lstg.var.timeslow = 2
    if self.slow_times == 0 and dt > 10 then
        PlaySound("kira00")
    end
    self.slow_times = self.slow_times + dt
end
function timeslow:setMinFps(min)
    self.minfps = min
end
function timeslow:reFresh()
    self.slow_times = 0
    self.minfps = 45
end

--立绘演出
local pic_show
do
    local pic = Class(object)
    function pic:init()
        self.group = GROUP_GHOST
        _object.set_color(self, "", 0, 255, 255, 255)
        self.x, self.y = 0, 100
        self.img = "s7boss_pic"
        self.size = 0.9
        self.trails = {}
        task.New(self, function()
            for _ = 1, 60 do
                table.insert(self.trails, {self.x, self.y, self.size, self.size, 20}) --x, y, hscale, vscale, _a
                task.Wait(1)
            end
            task.Wait(15)
            egg.SimAlpCh(self, 255, 0, 30)
            task.Wait(30)
            Del(self)
        end)
        task.New(self, function()
            task.MoveTo(0, 0, 60, MOVE_DECEL)
        end)
        egg.SimAlpCh(self, 0, 255, 30)
    end
    function pic:frame()
        task.Do(self)
        for _, o in ipairs(self.trails) do
            o[3] = o[3] + 0.01
            o[4] = o[4] + 0.01
            o[5] = o[5] - 1.5
            if o[5] <= 0 then table.remove(self.trails, 1) end
        end
    end
    function pic:render()
        SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.size, self.size)
        for _, o in ipairs(self.trails) do
            SetImgState(self, "mul+add", o[5], 255, 255, 255)
            Render(self.img, o[1], o[2], 0, o[3], o[4])
        end
    end
    local light = Class(object)
    function light:init()
        self.group = GROUP_GHOST
        _object.set_color(self, "mul+add", 255, 255, 255, 0)
        self.img = "s5_light"
        self.bound = false
        self.x, self.y = 0, 300
        self.size = 1.5
        self.trails = {}
        task.New(self, function()
            for _ = 1, 60 do
                table.insert(self.trails, {self.x, self.y, self.size, self.size, 30}) --x, y, hscale, vscale, _a
                task.Wait(1)
            end
        end)
        task.New(self, function()
            task.MoveTo(0, -224, 90, MOVE_DECEL)
            Del(self)
        end)
        --egg.SimAlpCh(self, 0, 255, 30)
    end
    function light:frame()
        pic.frame(self)
    end
    function light:render()
        pic.render(self)
    end
    local cherry = Class(object)
    function cherry:init(x, y, v, a)
        self.x, self.y = x, y
        self.bound = false
        self.size = ran:Float(0.8, 1)
        self.hscale, self.vscale = self.size, self.size
        local img = ran:Int(1, 3)
        if img == 1 then
            self.img = "stone_big"
        elseif img == 2 then
            self.img = "stone_mid"
        else
            self.img = "stone_huge"
        end
        self.img = "stone_big"
        self.rot = ran:Float(0, 360)
        self.timer = ran:Int(0, 120)
        self.omiga = ran:Float(0.5, 1)*ran:Sign()
        _object.set_color(self, "", 0, 150, 255, 255)
        task.New(self, function()
            egg.SimAlpCh(self, 0, 150, 20)
            egg.AddAccDecChV(self, v, a, 1, 30, 60)
            task.Wait(60)
            egg.SimAlpCh(self, 150, 0, 30)
            task.Wait(30)
            Del(self)
        end)
    end
    function cherry:frame()
        task.Do(self)
        --self.vscale = self.size*sin(6*self.timer)
    end
    function cherry:render()
        SetImgState(self, "", self._a, 255, 255, 255)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
        SetImgState(self, "", 255, 255, 255, 255)
    end
    function pic_show()
        New(pic)
        New(light)
        New(tasker, function()
            local y, dy, u = 250, -224/10
            for _ = 1, 10 do
                y = y + dy
                for _ = 1, 5 do
                    u = ran:Sign()
                    New(cherry, u*ran:Float(60, 90), y, ran:Float(3, 4), -90 + u*ran:Float(-30, 60))
                end
                task.Wait(1)
            end
        end)
    end
end
s7_boss.pic_show = pic_show

--符卡背景
local scbg
do
    scbg =Class(background)
    function scbg:init()
        background.init(self,true)
        self.connects_x, self.connects_y = 0, 0
        self.rate = 1
        self.drate = 0
    end
    function scbg:frame()
        self.connects_x, self.connects_y = self.connects_x + 0.5, self.connects_y - 0.5
        if self.connects_x >= 256 then
            self.connects_x = self.connects_x - 256
            self.connects_y = self.connects_y + 256
        end

        self.rate = min(1, max(0, self.rate + self.drate))
    end
    function scbg:render()
        if self.alpha > 0 then
            local rate = self.rate
            background.WarpEffectCapture()
            --底层正常渲染
            SetImageState("s7_boss_scbg1", "", Color(255*self.alpha, 255, 100 + 155*rate, 100 + 155*rate))
            Render("s7_boss_scbg1", 0, 0, 0, 1)
            --中层减法
            SetImageState("s7_boss_scbg3", "mul+rev", Color((255 + 0*sin(self.timer))*self.alpha, 255, 255, 255))
            SetImageState("s7_boss_scbg2", "mul+rev", Color((255 + 0*sin(self.timer))*self.alpha, 255, 255, 255))
            for i = -2, 1 do
                for j = -1, 2 do
                    Render("s7_boss_scbg2", self.connects_x + 256*i, self.connects_y + 256*j, 0, 1)
                    Render("s7_boss_scbg3", self.connects_x + 256*i, self.connects_y + 256*j, 0, 1)
                end
            end
            --顶层正常渲染
            SetImageState("s7_boss_scbg4", "", Color(150*self.alpha, 255, 100 + 155*rate, 100 + 155*rate))
            Render("s7_boss_scbg4", 0, 0, 0, 1)
            background.WarpEffectApply(self.alpha)
            --顶层减法+极坐标
            EISlib.Render.RenderTexturePolarRing("s7_boss_scbg5", "mul+add", Color(100*self.alpha, 88*(1-rate), 88*rate, 0),
                    0, 110,
                    0, 400,
                    0, 60, 2,
                    (self.timer * 0.0075) % 1)
        end
    end
end
s7_boss.scbg = scbg

--通常
do
    local id, anime, list
    local cutFrame = 8
    local wi = {
        ["normal"] = {
            id = { 1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9 },
        },
        ["left"] = {
            id = { 10, 11, 12, 13, 14, 15, 16, 17},
            loop = 4,
        },
        ["right"] = {
            id = { 19, 20, 21, 22, 23, 24, 25, 26},
            loop = 4,
        },
    }
    function _ACT_NONE_AUTO_Iwabuchi(wisys, self, actionCount, actionCountMax)
        self.lr = self.lr or 1
        if self.dx > 0.005 then
            self.lr = min(self.lr + 2, 28)
        elseif self.dx < -0.005 then
            self.lr = max(self.lr - 2, -28)
        end
        if self.lr == 0 then
            if self.dx < 0 then
                self.lr = self.lr - 2
            else
                self.lr = self.lr + 2
            end
        end
        if self.dx == 0 then
            self.lr = sign(self.lr) * max(1, abs(self.lr) - 1)
        end
        if abs(self.lr) == 1 then
            list = wi["normal"]
            anime = int(self.ani / cutFrame) % #list.id + 1
            id = list.id[anime]
        elseif self.lr == 28 then
            list = wi["right"]
            anime = int(self.ani / cutFrame) % list.loop + 1
            id = list.id[#list.id - list.loop + anime]
            hscale = list.hscale or hscale
        elseif self.lr == -28 then
            list = wi["left"]
            anime = int(self.ani / cutFrame) % list.loop + 1
            id = list.id[#list.id - list.loop + anime]
            hscale = list.hscale or hscale
        elseif self.lr > 1 then
            list = wi["right"]
            anime = int((self.lr / 28) * #list.id) + 1
            id = list.id[anime]
            hscale = list.hscale or hscale
        elseif self.lr < -1 then
            list = wi["left"]
            anime = int((self.lr / 28) * #list.id) + 1
            id = list.id[anime]
            hscale = list.hscale or hscale
        end
        return id, hscale, vscale
    end

    --施法（集气
    local cutFrame = 8
    local id = { 28, 29, 30, 31, 32}
    function _ACT_CAST_Iwabuchi(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local n
        if anime < 3 then
            n = anime + 1
        else
            n = 4 + (anime - 3)%2 --最后两帧循环
        end
        return id[n], hscale, vscale
    end

    function cast(self, t)
        self._wisys:setAction("cast", t)
    end

    --施法（甩手
    local cutFrame = 8
    local id = { 37, 38, 39, 40, 41, 42, 43, 44}
    function _ACT_CAST2_Iwabuchi(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local n
        if anime < 6 then
            n = anime + 1
        else
            n = 7 + (anime - 3)%2 --最后两帧循环
        end
        return id[n], hscale, vscale
    end

    function cast2(self, t)
        self._wisys:setAction("cast2", t)
    end
end

--设置行走图
function lstg.wis.Iwabuchi(self)
    self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
    self._wisys:connectAction("normal", _ACT_NONE_AUTO_Iwabuchi)
    self._wisys:connectAction("cast", _ACT_CAST_Iwabuchi)
    self._wisys:connectAction("cast2", _ACT_CAST2_Iwabuchi)
    --self._wisys:connectAction("appear", _ACT_Appear_Iwabuchi)
    --self._wisys:connectAction("disappear", _ACT_DisAppear_Iwabuchi)
    self.cast = cast
    self.cast2 = cast2

    self.timeslow = New(timeslow, self)
    self.addTimes = function(dt)
        if IsValid(self.timeslow) then
            timeslow.addTimes(self.timeslow, dt)
        end
    end
    self.reFresh = function()
        if IsValid(self.timeslow) then
            timeslow.reFresh(self.timeslow)
        end
    end
    self.minFps = function(min)
        if IsValid(self.timeslow) then
            timeslow.setMinFps(self.timeslow, min)
        end
    end

    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 255, 0, "mul+add"
    self.saoqi = New(boss_saoqi, self)
end
