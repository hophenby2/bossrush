--祈华梦五面boss素材定义
lstg.wis = lstg.wis or {}
s5_boss = {}

local _ACT_NONE_AUTO_Jinguuji, _ACT_CAST_Jinguuji, _ACT_CAST1_Jinguuji


--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Jinguuji_boss"
local texFile = "Jinguuji_boss.png"
local tex_u, tex_v, tex_n = 180, 180, 10

--加载其他资源
local function load_res()
    local path
    --五面boss符卡背景
    path = "res/background/boss5b/"
    LoadImageFromFile("s5_boss_scbg1", path .. "scbg1.png", true, 0, 0, false, 0)
    LoadImageFromFile("s5_boss_scbg2", path .. "scbg2.png", true, 0, 0, false, 0)
    LoadImageFromFile("s5_boss_scbg3", path .. "scbg3.png", true, 0, 0, false, 0)
    LoadImageFromFile("s5_boss_scbg4", path .. "scbg4.png", true, 0, 0, false, 0)
    path = "res/stage/stage5/"
    LoadTexture(tex, path .. "Jinguuji_boss.png")--载入行走图资源
    LoadImageFromFile("s5boss_pic", path .. "s5boss_pic.png", true, 0, 0, false, 0)--立绘加载
end
load_res()


--通常
do
    local id, anime, list
    local cutFrame = 8
    local wi = {
        ["normal"] = {
            id = { 1, 2, 3, 4, 5, 1, 2, 6, 7, 8},
        },
        ["left"] = {
            id = { 11, 12, 13, 14, 15, 16, 17},
            loop = 3,
        },
        ["right"] = {
            id = { 21, 22, 23, 24, 25, 26, 27},
            loop = 3,
        },
    }
    function _ACT_NONE_AUTO_Jinguuji(wisys, self, actionCount, actionCountMax)
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
end

--施法(挥御币)
local cast, cast_l, cast_r, cast_lr, cast_rl, cast_lrlr, cast_rlrl, cast_lrlrlrlr
do
    local cutFrame = 8
    local id = { 31, 32, 33, 34, 35, 36, 37, 38, 39}
    function _ACT_CAST_Jinguuji(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local n
        if anime < 8 then
            n = anime + 1 --前三帧动画是一定要的
        else
            n = 9
        end
        return id[n], hscale, vscale
    end
    --只有挥舞的动作了
    local id = { 36, 37, 38, 39, 38, 37, 36}
    function _ACT_CAST1_Jinguuji(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local n
        if anime < 6 then
            n = anime + 1 --前三帧动画是一定要的
        else
            n = 7
        end
        return id[n], hscale, vscale
    end

    --函数本体
    function cast(self)
        self._wisys:setAction("cast", 72)
    end
    function cast_l(self)
        self._wisys:setAction("cast", 40)
    end
    function cast_r(self)
        self.hscale = -self.hscale
        self._wisys:setAction("cast", 40)
        task.New(self, function()
            task.Wait(40)
            self.hscale = -self.hscale
        end)
    end
    function cast_lr(self)
        task.New(self, function()
            self._wisys:setAction("cast", 40)
            task.Wait(40)
            self.hscale = -self.hscale
            self._wisys:setAction("cast", 72)
            task.Wait(72)
            self.hscale = -self.hscale
        end)
    end
    function cast_rl(self)
        task.New(self, function()
            self.hscale = -self.hscale
            self._wisys:setAction("cast", 40)
            task.Wait(40)
            self.hscale = -self.hscale
            self._wisys:setAction("cast", 72)
        end)
    end
    function cast_lrlr(self)
        task.New(self, function()
            for _ = 1, 2 do
                self._wisys:setAction("cast", 40)
                task.Wait(40)
                self.hscale = -self.hscale
                self._wisys:setAction("cast", 40)
                task.Wait(40)
                self.hscale = -self.hscale
            end
            self._wisys:setAction("cast1", 54)
            task.Wait(32)
            self.hscale = -self.hscale
            task.Wait(24)
            self.hscale = -self.hscale
        end)
    end
    function cast_rlrl(self)
        task.New(self, function()
            for _ = 1, 2 do
                self.hscale = -self.hscale
                self._wisys:setAction("cast", 40)
                task.Wait(40)
                self.hscale = -self.hscale
                self._wisys:setAction("cast", 40)
                task.Wait(40)
            end
            self.hscale = -self.hscale
            self._wisys:setAction("cast1", 54)
            task.Wait(32)
            self.hscale = -self.hscale
            task.Wait(24)
        end)
    end
    function cast_lrlrlrlr(self)
        task.New(self, function()
            for _ = 1, 4 do
                self._wisys:setAction("cast", 40)
                task.Wait(40)
                self.hscale = -self.hscale
                self._wisys:setAction("cast", 40)
                task.Wait(40)
                self.hscale = -self.hscale
            end
            --转三圈
            for _ = 1, 3 do
                self._wisys:setAction("cast1", 54)
                task.Wait(32)
                self.hscale = -self.hscale
                task.Wait(24)
                self.hscale = -self.hscale
            end
        end)
    end
end


--五面符卡背景
local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.AddLayer(self, "s5_boss_scbg4", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
    _spellcard_background.AddLayer(self, "s5_boss_scbg3", true, 0, 0, 0, 0, -1, 0, "mul+rev", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
    _spellcard_background.AddLayer(self, "s5_boss_scbg2", true, 0, 0, 0, 0, 1, 0, "mul+rev", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
    _spellcard_background.AddLayer(self, "s5_boss_scbg1", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
end
s5_boss.scbg = scbg


-- 五面立绘演出
local pic_show
do
    local pic = Class(object)
    function pic:init()
        self.x, self.y = 0, 100
        self.img = "s5boss_pic"
        self.layer = LAYER_TOP + 1
        self.group = GROUP_GHOST
        _object.set_color(self, "", 0, 255, 255, 255)
        self.x, self.y = 120, 50
        self.bound = false
        self.hscale, self.vscale = 1, 1
        self.size = 1
        self.trails = {}
        task.New(self, function()
            egg.AddSimStrChV(self, 8, 1, 200, 30)
            egg.AddSimStrChV(self, 0, 4, 170, 70, 60)
            egg.SimAlpCh(self, 0, 255, 30)
            for _ = 1, 60 do
                table.insert(self.trails, { self.x, self.y, self.size, self.size, 20 }) --x, y, hscale, vscale, _a
                task.Wait(1)
            end
            task.Wait(20)
            egg.SimAlpCh(self, 255, 0, 20)
            task.Wait(20)
            Del(self)
        end)
    end
    function pic:frame()
        task.Do(self)
        for _, o in ipairs(self.trails) do
            o[3] = o[3] + 0.01
            o[4] = o[4] + 0.01
            o[5] = o[5] - 1.5
            if o[5] <= 0 then
                table.remove(self.trails, 1)
            end
        end
    end
    function pic:render()
        SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
        --SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.size, self.size)
        for _, o in ipairs(self.trails) do
            SetImgState(self, "", o[5], 255, 255, 255)
            Render(self.img, o[1], o[2], 0, o[3], o[4])
        end
    end
    function pic_show()
        New(tasker, function()
            New(pic)
            task.Wait(20)
            New(spell_open_circle_eff, 0, 0, 0, 255, 255, "yuyuko_ghost", "star_eff_white")  --配合开卡立绘的特效
            misc.ShakeScreen(10, 3)
        end)
    end
end
s5_boss.pic_show = pic_show


--设置行走图
function lstg.wis.Jinguuji(self)
    self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
    self._wisys:connectAction("normal", _ACT_NONE_AUTO_Jinguuji)
    self._wisys:connectAction("cast", _ACT_CAST_Jinguuji)
    self._wisys:connectAction("cast1", _ACT_CAST1_Jinguuji)
    self.cast = cast    --挥御币动作
    self.cast_l = cast_l
    self.cast_r = cast_r  --左挥与右挥
    self.cast_lr = cast_lr
    self.cast_rl = cast_rl
    self.cast_lrlr = cast_lrlr
    self.cast_rlrl = cast_rlrl
    self.cast_lrlrlrlr = cast_lrlrlrlr --欧拉欧拉欧拉欧拉~！
    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 255, 0, "mul+rev"
    self.saoqi = New(boss_saoqi, self)
end

--激光预警
local lasereff
do
    lasereff = Class(object)
    function lasereff:init(x, y, a, r, g, b)
        r, g, b = r or 177, g or 255, b or 97
        self.bound = false
        self.x, self.y = x + 300*cos(a), y + 300*sin(a)
        self.rot = a
        self.hscale, self.vscale = 75, 0
        self.img = "white"
        _object.set_color(self, "", 100, r, g, b)
        task.New(self, function()
            local ds, d_a = 1/50, -100/30
            for _ = 1, 20 do
                self.vscale = self.vscale + 2*ds
                task.Wait(1)
            end
            for _ = 1, 30 do
                self.vscale = self.vscale + ds
                self._a = self._a + d_a
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function lasereff:frame()
        task.Do(self)
    end
    function lasereff:render()
        local rate, v = 1, 1
        for _ = 1, 3 do
            SetImgState(self, self._blend, self._a*rate, self._r*rate, self._g*rate, self._b*rate)
            Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale*v)
            rate = rate - 0.2
            v = v + 0.3
        end
    end
end

--五boss蓄力特效
local eff, bkeff, scbkeff, laser_eff
do
    function eff(x, y, t)
        New(AbEff, x, y, 'tree_leaf_white', 'yuyuko_ghost', 168, 114, 235)
        if t then task.Wait(t) end
    end
    function bkeff(x, y)
        Spell_break_eff(x, y, 255, 0, 255, 'tree_leaf_white', 'yuyuko_ghost', 0)
    end
    function scbkeff(x, y)
        Spell_break_eff(x, y, 255, 0, 255, 'tree_leaf_white', 'yuyuko_ghost', 0.5)
    end
    function laser_eff(x, y, a, r, g, b)
        New(lasereff, x, y, a, r, g, b)
    end
end
s5_boss.eff = eff
s5_boss.bkeff = bkeff
s5_boss.scbkeff = scbkeff
s5_boss.laser_eff = laser_eff
