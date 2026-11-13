lstg.wis = lstg.wis or {}
s4_boss = {}

local _ACT_NONE_AUTO_Hisoka, _ACT_CAST_Hisoka, _ACT_Appear_Hisoka, _ACT_DisAppear_Hisoka
local cast_times = -1 --吹泡泡动作的计时器 -1表示不启用吹出泡泡的特殊动作

local path = "res/stage/stage4/"
--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Hisoka_boss"
local texFile = path.."Hisoka_boss.png"
local tex_u, tex_v, tex_n = 200, 174, 12


local function load_res()
    --载入行走图资源
    LoadTexture(tex, texFile)
    --载入boss其他素材资源
    LoadTexture("s4_boss_item" ,path.."s4_boss_item.png")
    do
        --泡泡
        LoadImage("s4_bubble1", "s4_boss_item", 0, 0, 164, 164, 4, 4, false)
        --白光特效
        LoadImage("s4_boss_eff1", "s4_boss_item", 0, 164, 164, 164, 16, 16)
        --彩虹特效
        LoadImage("s4_boss_eff2", "s4_boss_item", 512, 512, 512, 512, 16, 16)
        --月牙特效
        LoadImage("s4_boss_eff3", "s4_boss_item", 0, 512, 512, 512, 16, 16)
        --十字星特效
        LoadImage("s4_boss_eff4", "s4_boss_item", 512, 0, 512, 512, 16, 16)
        --下雨特效
        LoadImage("s4_boss_eff5", "s4_boss_item", 164, 0, 164, 164, 16, 16)
        --贝壳使魔
        LoadImageGroupFromFile("s4_boss_shell_item",  path.."s4_boss_shell_item.png", false, 5,1, 8, 8, false)
    end
    --泡泡爆炸
    LoadImageGroupFromFile("bubble_boom",  path.."bubble_boom_eff.png", false, 7,1, 0, 0, false)
    for i = 1, 7 do
        SetImageState("bubble_boom"..i, "mul+add", Color(255, 255, 255, 255))
    end
    --四面boss符卡背景
    path = "res/background/boss4/"
    LoadImageFromFile("s4_boss_scbg1", path .. "scbg1.png", true, 0, 0, false, 0)
    SetImageState("s4_boss_scbg1", "mul+rev", Color(255, 255, 255, 255))
    LoadImageFromFile("s4_boss_scbg2", path .. "scbg2.png", true, 0, 0, false, 0)
    --立绘加载
    path = "res/stage/stage4/"
    LoadImageFromFile("s4boss_pic", path .. "s4boss_pic.png", true, 0, 0, false, 0)
    LoadImageGroup("shell", tex, 0, 5*tex_v, 1*tex_u, 1*tex_v, 6, 1)
    --新载一个反色光玉的素材
    local S = lstg.ResourceSet.Find("EISlib.bullet")
    S:AddSprite("sp_ball_dark", "_bullet_512_3_texture", 0, 0, 128, 128)
    S:SetSpriteState("sp_ball_dark", "mul+rev", lstg.Color(128, 255, 255, 255))
end
load_res()

--通常
do
    local id, anime, list
    local cutFrame = 8
    local wi = {
        ["normal"] = {
            id = { 1, 2, 3, 4, 5, 6, 7, 11, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
        },
        ["left"] = {
            id = { 25, 26, 27, 28, 29, 30, 31},
            loop = 3,
        },
        ["right"] = {
            id = { 13, 14, 15, 16, 17, 18, 19},
            loop = 3,
        },
    }
    function _ACT_NONE_AUTO_Hisoka(wisys, self, actionCount, actionCountMax)
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


--贝壳
local shell = Class(object)
function shell:init(mst)
    self.bound = false
    self.x, self.y = mst.x, mst.y
    self.mst = mst
    self.layer = LAYER_ENEMY-1
    self.rate = 1 --透明度比率
    self.drate = 1/18 --透明度变化率
    self.hscale, self.vscale = 1, 1
end
function shell:frame()
    self.rate = max(0, min(1, self.rate + self.drate))
    self.hscale, self.vscale = 0.5 + 0.5*self.rate, 1.25 - 0.25*self.rate
    if IsValid(self.mst) then
        self.x, self.y = self.mst.x, self.mst.y
        self.hide = self.mst.hide
    else
        Del(self)
    end
end
function shell:render()
    local img = "shell"..(1 + int(self.timer/8)%6)
    SetImageState(img, "", Color(255*self.rate, 255, 255, 255))
    Render(img, self.x, self.y, 0, 2*self.hscale*hscale, 2*self.vscale*vscale)
end

--施法(吹泡泡的动作)
do
    local cutFrame = 8
    local id = { 37, 38, 39, 40, 41, 42, 42, 41}
    local id2 = {40, 41, 40, 39, 39}
    local loop = 4
    local tran = #id - loop
    function _ACT_CAST_Hisoka(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local anime_max = int((actionCountMax - actionCount)/ cutFrame)
        local n
        if anime < 3 then
            n = anime + 1 --前三帧动画是一定要的
        elseif cast_times > -1 then --遇上手动的吹泡泡动作，则使用吹泡泡的动作
            cast_times = cast_times - 1
            if anime_max < 3 then wisys.actionCount =  wisys.actionCount - 1 end --无论中间有无吹泡泡动作打断，最后收尾动作总会有
            return id2[int(max(cast_times, 0)/8)%5 + 1], hscale, vscale
        elseif anime_max < 3  then --结束动作
            n = anime_max + 1
        elseif anime >= tran then
            n = tran + (anime - tran) % loop
        else
            n = anime + 1
        end
        return id[n], hscale, vscale
    end
end

local function sp_cast(IsnWait) --做一个吹出泡泡的动作
    if IsValid(lstg.tmpvar.casts) then --在cast动作内才能使用
        cast_times = 32
   end
    if not IsnWait then --吐泡泡前摇
        task.Wait(32)
    end
end
local function cast(self, t, IsnWait) --做一个准备吹泡泡的动作
    if not t or t < 40 then t = 40 end
    if IsValid(lstg.tmpvar.casts) then
        cast_times = -1
        Del(lstg.tmpvar.casts)
    end
    self._wisys:setAction("cast", t)
    lstg.tmpvar.casts = New(tasker, function ()
        task.Wait(t)
        cast_times = -1
    end)
    if not IsnWait then --默认要把前摇做完才能攻击
        task.Wait(24)
    end
end

--出现
do
    local cutFrame = 4
    local id = { 54, 53, 52, 51, 49, 50 }
    local loop = 1
    local tran = #id - loop
    function _ACT_Appear_Hisoka(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local n
        if anime >= tran then
            n = tran + (anime - tran) % loop
        else
            n = anime + 1
        end
        return id[n], hscale, vscale
    end
end

--消失
do
    local cutFrame = 4
    local id = { 50, 49, 51, 52, 53, 54, 55 } --47是透明图
    local loop = 1
    local tran = #id - loop
    function _ACT_DisAppear_Hisoka(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local n
        if anime >= tran then
            n = tran + 1
        else
            n = anime + 1
        end
        return id[n], hscale, vscale
    end
end

--四面立绘演出
local pic_show
do
    local function fog(a)
        local obj = New(s4_boss.fog, a)
        obj.x, obj.y = 0, 0
        obj.layer = LAYER_TOP + 2
        task.New(obj, function()
            egg.SimAlpCh(obj, 0, 150, 20)
            egg.SimSizeCh(obj, 1, 0.75, 30)
            egg.AddSimStrChV(obj, 6, 3, a, 60)
            task.Wait(20)
            egg.SimAlpCh(obj, 150, 0, 30)
            task.Wait(30)
            Del(obj)
        end)
    end
    local pic = Class(object)
    function pic:init()
        self.x, self.y = 0, 0
        self.img = "s4boss_pic"
        self.layer = LAYER_TOP + 1
        self.group = GROUP_GHOST
        _object.set_color(self, "", 0, 255, 255, 255)
        self.bound = false
        self.hscale, self.vscale = 0, 0
        self.size = 0.5
        self.trails = {}
        task.New(self, function()
            egg.SimAlpCh(self, 0, 255, 15)
            task.New(self, function()
                for x = 1, 20 do
                    self.size = 0.5 + 0.5*sin(90/20*x)
                    task.Wait(1)
                end
            end)
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
        Render(self.img, self.x, self.y, 0, self.size, self.size)
        for _, o in ipairs(self.trails) do
            SetImgState(self, "", o[5], 255, 255, 255)
            Render(self.img, o[1], o[2], 0, o[3], o[4])
        end
    end

    function pic_show()
        New(tasker, function()
            for i = 0, 15 do
                fog(22.5*i)
            end
            task.Wait(15)
            New(pic)
            New(spell_open_circle_eff, 0, 0, 255, 0, 255, 's4_bubble_blue', 's4_bubble_orange')  --配合开卡立绘的特效
            misc.ShakeScreen(10, 3)
        end)
    end
end
s4_boss.pic_show = pic_show



local function appear(self, IsnWait)
    self.hide = false
    self.colli = false
    self._wisys:setAction("appear", 24)
    if IsValid(self.shell) then
        self.shell.drate = 1/18
    end
    if not IsnWait then --默认要把动作做完才能执行其他
        task.Wait(24)
    end
    self.colli = true
end
local function disappear(self, IsnWait)
    self.colli = false
    self._wisys:setAction("disappear", 24)
    if IsValid(self.shell) then
        self.shell.drate = -1/18
    end
    if not IsnWait then --默认要把动作做完才能执行其他
        task.Wait(24)
    end
    self.hide = true
end
local function flash(self, x, y, IsnWait)
    x, y = x or self.x, y or self.y
    if  IsnWait then
        task.New(self, function ()
            disappear(self)
            self.x, self.y = x, y
            appear(self)
        end)
    else
        disappear(self)
        self.x, self.y = x, y
        appear(self)
    end
end




local scbg = Class(background)
function scbg:init()
    background.init(self,true)
    self.x, self.y = 0, 0
    self.layer = LAYER_BG+1
    self.open = true
    self.alpha = 0
end
function scbg:frame()
    --[[if IsValid(_boss) then
        if (self.open and (self.open or _boss.cards[_boss.card_num] and _boss.cards[_boss.card_num].is_sc)) then
            --self.alpha = 0
            self.alpha = min(1, self.alpha + 0.035)
        elseif self.alpha > 0 then
            self.alpha = max(0, self.alpha - 0.035)
        end
        --if IsValid(_boss.bg) then _boss.bg.alpha = 0 end
    --else
       Del(self)
    end]]
    if self.open then
        self.alpha = min(1, self.alpha + 0.035)
    end
end
function scbg:render()
    if self.alpha > 0 then
        SetImageState("s4_circle_cloud", "mul+rev", Color(200*self.alpha, 255, 255, 255))
        Render("s4_circle_cloud", 0, 0, 0.5*self.timer, 1)
        SetImageState("s4_circle_cloud", "mul+rev", Color(160*self.alpha, 255, 255, 255))
        Render("s4_circle_cloud", 0, 0, 0.4*self.timer, 0.7)
        SetImageState("s4_circle_cloud", "mul+rev", Color(80*self.alpha, 255, 255, 255))
        Render("s4_circle_cloud", 0, 0, 0.4*self.timer, 0.4)
        EISlib.Render.RenderTexturePolarRing("s4_boss_scbg2", "mul+rev", Color(255*self.alpha, 255, 255, 255),
                0, 90,
                0, 400,
                0, 120, 2,
                (self.timer * 0.006) % 1)
        SetImageState("s4_boss_scbg1", "mul+rev", Color(255*self.alpha, 255, 255, 255))
        Render("s4_boss_scbg1", 0, 0, 0, 1)
        --又加了一层，黑暗系符卡背景
        SetImageState("white", "", Color(120, 0, 0, 0))
        Render4V("white", -192, 224, 0.5,
                192, 224, 0.5,
                192, -224, 0.5,
                -192, -224, 0.5
        )
        SetImageState("white", "", Color(255, 255, 255, 255)) --设回来吧，省得哪里又出了问题
    end
end
s4_boss.scbg = scbg

--泡泡爆炸的效果
local bubble_boom = Class(object)
function bubble_boom:init(x, y, size)
    self.x, self.y = x, y
    self.size = size
    self.imgs = {"bubble_boom1", "bubble_boom2", "bubble_boom3", "bubble_boom4", "bubble_boom5", "bubble_boom6", "bubble_boom7"}
    self.img = "bubble_boom1"
end
function bubble_boom:render()
    if self.timer >= 27 then Del(self) end
    self.img = self.imgs[int(self.timer/4)%7+1]
    SetImgState(self, "mul+add", 255, 255, 255, 255)
    Render(self.img, self.x, self.y, 0, self.size)
end
--黑泡泡爆炸效果
local bubble_dark_boom = Class(bubble_boom)
function bubble_dark_boom:init(x, y, size)
    bubble_boom.init(self, x, y, size)
end
function bubble_dark_boom:render()
    if self.timer >= 27 then Del(self) end
    self.img = self.imgs[int(self.timer/4)%7+1]
    SetImgState(self, "mul+rev", 255, 255, 255, 255)
    Render(self.img, self.x, self.y, 0, self.size)
end

--泡泡弹幕基类，不推荐直接new，生成实现由下面的函数实现
local bubble_class = Class(bullet)
function bubble_class:init(x, y, rot, size)
    _object.set_color(self, "", 255, 255, 255, 255)
    self.timer = 11
    self.group = GROUP_ENEMY_BULLET
    self.colli = false
    self.x, self.y = x, y
    self.size = size
    self.rot = rot
    self.img = "s4_bubble1"
    self.hscale, self.vscale = 0, 0
    self.a, self.b = 8, 8
end
function bubble_class:frame()
    task.Do(self)
end
function bubble_class:render()
    _object.render(self)
end
function bubble_class:colli(other)
    bullet.colli(self, other)
end
function bubble_class:kill()
    if not self.hide then
        New(bubble_boom, self.x, self.y, self.size)
        New(item_faith_minor, self.x, self.y)
    end
end
function bubble_class:del()
    if not self.hide then
        New(bubble_boom, self.x, self.y, self.size)
    end
end
s4_boss.bubble_class = bubble_class

--黑泡泡
local bubble_dark_class = Class(bubble_class)
function bubble_dark_class:init(x, y, rot, size)
    bubble_class.init(self, x, y, rot, size)
    self.img1 = "sp_ball_dark"
end
function bubble_dark_class:render()
    Render(self.img1, self.x, self.y, self.rot, 2*self.hscale, 2*self.vscale)
	DefaultRenderFunc(self)
end
function bubble_dark_class:kill()
    if not self.hide then
        New(bubble_dark_boom, self.x, self.y, self.size)
        New(item_faith_minor, self.x, self.y)
    end
end
function bubble_dark_class:del()
    if not self.hide then
        New(bubble_dark_boom, self.x, self.y, self.size)
    end
end
s4_boss.bubble_dark_class = bubble_dark_class

--常规可用的泡泡模版
--泡泡弹幕定义
local bubble, bubble2, bubble_dark, bubble_dark2, bubble_dark3
do
    --基础泡泡弹幕定义
    function bubble(x, y, size, t0, t1)
        local obj = New(s4_boss.bubble_class, x, y, 0, size) --来自4boss脚本文件里的泡泡类
        _object.set_color(obj,"",0,255,255,255)
        local rate
        task.New(obj,function()
            t0 = t0 or 20
            t1 = t1 or 15
            local size
            do local x,_d_x=(0),(90/(t0 -1)) for _=1,t0 do
                size = obj.size
                rate = sin(x)
                obj.hscale, obj.vscale = (1.5 - 0.5*rate)*size, (1.5 - 0.5*rate)*size
                obj._a = 255*rate
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            do local x,_d_x=(0),(180/(t1 - 1)) for _=1,t1 do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.25*rate)*size
                obj.hscale = (1 + 0.1*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            obj.colli = true
            --泡泡的动态变化
            do local x,_d_x=(180),(6) for _=1,_infinite do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.05*rate)*size
                obj.hscale = (1 + 0.05*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
        end)
        return obj
    end
    --吹出来的泡泡
    function bubble2(x, y, size, t0, t1)
        local obj = New(s4_boss.bubble_class, x, y, 0, size) --来自4boss脚本文件里的泡泡类
        _object.set_color(obj,"",255,255,255,255)
        local rate
        task.New(obj,function()
            t0 = t0 or 20
            t1 = t1 or 15
            local size
            do local x,_d_x=(0),(90/(t0 -1)) for _=1,t0 do
                size = obj.size
                rate = sin(x)
                obj.hscale, obj.vscale = rate*size, rate*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            do local x,_d_x=(0),(180/(t1 - 1)) for _=1,t1 do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.25*rate)*size
                obj.hscale = (1 + 0.1*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            obj.colli = true
            --泡泡的动态变化
            do local x,_d_x=(180),(6) for _=1,_infinite do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.05*rate)*size
                obj.hscale = (1 + 0.05*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
        end)
        return obj
    end
    --基础泡泡弹幕定义
    function bubble_dark(x, y, size, t0, t1)
        local obj = New(s4_boss.bubble_dark_class, x, y, 2, size) --来自4boss脚本文件里的泡泡类
        _object.set_color(obj,"",0,255,255,255)
        local rate
        task.New(obj,function()
            t0 = t0 or 20
            t1 = t1 or 15
            local size
            do local x,_d_x=(0),(90/(t0 -1)) for _=1,t0 do
                size = obj.size
                rate = sin(x)
                obj.hscale, obj.vscale = (1.5 - 0.5*rate)*size, (1.5 - 0.5*rate)*size
                obj._a = 255*rate
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            do local x,_d_x=(0),(180/(t1 - 1)) for _=1,t1 do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.25*rate)*size
                obj.hscale = (1 + 0.1*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            obj.colli = true
            --泡泡的动态变化
            do local x,_d_x=(180),(6) for _=1,_infinite do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.05*rate)*size
                obj.hscale = (1 + 0.05*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
        end)
        return obj
    end
    --吹出来的泡泡
    function bubble_dark2(x, y, size, t0, t1)
        local obj = New(s4_boss.bubble_dark_class, x, y, 0, size) --来自4boss脚本文件里的泡泡类
        _object.set_color(obj,"",255,255,255,255)
        local rate
        task.New(obj,function()
            t0 = t0 or 20
            t1 = t1 or 15
            local size
            do local x,_d_x=(0),(90/(t0 -1)) for _=1,t0 do
                size = obj.size
                rate = sin(x)
                obj.hscale, obj.vscale = rate*size, rate*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            do local x,_d_x=(0),(180/(t1 - 1)) for _=1,t1 do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.25*rate)*size
                obj.hscale = (1 + 0.1*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            obj.colli = true
            --泡泡的动态变化
            do local x,_d_x=(180),(6) for _=1,_infinite do
                size = obj.size
                rate = sin(x)
                obj.vscale = (1 - 0.05*rate)*size
                obj.hscale = (1 + 0.05*rate)*size
                obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
        end)
        return obj
    end
    --基础泡泡弹幕定义
    function bubble_dark3(x, y, size, t0, t1)
        local obj = New(s4_boss.bubble_dark_class, x, y, 2, size) --来自4boss脚本文件里的泡泡类
        _object.set_color(obj,"",0,255,255,255)
        local rate
        task.New(obj,function()
            t0 = t0 or 20
            t1 = t1 or 15
            local size
            do local x,_d_x=(0),(1/(t0 -1)) for _=1,t0 do
                size = obj.size
                rate = x
                obj.hscale, obj.vscale = (1.5 - 0.5*rate)*size, (1.5 - 0.5*rate)*size
                obj._a = 255*rate
                obj.a, obj.b = 8*obj.hscale, 8*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            do local x,_d_x=(-1),(2/(t1 - 1)) for _=1,t1 do
                size = obj.size
                rate = abs(x)
                obj.vscale = (1 - 0.25*(1-rate))*size
                obj.hscale = (1 + 0.1*(1-rate))*size
                obj.a, obj.b = 8*obj.hscale, 8*obj.vscale
                task.Wait(1)
                x=x+_d_x end end
            obj.colli = true
        end)
        return obj
    end
end
--导出
s4_boss.bubble = bubble
s4_boss.bubble2 = bubble2
s4_boss.bubble_dark = bubble_dark
s4_boss.bubble_dark2 = bubble_dark2
s4_boss.bubble_dark3 = bubble_dark3

--四boss蓄力特效
local eff, dark_eff, bkeff, laser_eff, dark_bkeff
do
    function eff(x, y, t)
        PlaySound("ch00")
        New(AbEff, x, y, 's4_bubble_blue', 's4_bubble_orange', 168, 114, 235)
        if t then task.Wait(t) end
    end
    function dark_eff(x, y, t)
        PlaySound("ch00")
        New(AbEff, x, y, 's4_bubble_blue', 's4_bubble_orange', 168, 114, 235, "mul+rev")
        if t then task.Wait(t) end
    end
    function bkeff(x, y)
        PlaySound("enep00")
        Spell_break_eff(x, y, 168, 114, 235, 's4_bubble_blue', 's4_bubble_orange')
    end
    function dark_bkeff(x, y)
        PlaySound("enep00")
        Spell_break_eff(x, y, 168, 114, 235, 's4_bubble_blue', 's4_bubble_orange', 1, "mul+rev")
    end
    function laser_eff(x, y, a, r, g, b)
        New(s4_boss.lasereff, x, y, a, r, g, b)
    end
end
s4_boss.eff = eff
s4_boss.dark_eff = dark_eff
s4_boss.bkeff = bkeff
s4_boss.dark_bkeff = dark_bkeff
s4_boss.laser_eff = laser_eff

--简单的扇贝对象
local shell_class
do
    shell_class = Class(enemybase)
    function shell_class:init(x, y, hp)
        enemybase.init(self, hp, true)
        --self.a, self.b = 12, 12
        self.x, self.y = x, y
        self.size = 1
        self.hscale, self.vscale = 1, 1
        _object.set_color(self, "", 255, 255, 255, 255)
        self.img = "s4_boss_shell_item1"
        self.imgs = {}
        for i = 1, 5 do
            self.imgs[i] = "s4_boss_shell_item"..i
        end
    end
    function shell_class:frame()
        enemybase.frame(self)
        if self.hp <= 0 then
            Kill(self)
        end
    end
    function shell_class:colli(other)
        enemybase.colli(self, other)
    end
    function shell_class:render()
        _object.render(self)
    end
    function shell_class:take_damage(dmg)
        self.hp = self.hp - dmg
    end
    --开扇贝动作
    function shell_class:open()
        task.New(self, function()
            for i = 1, 5 do
                self.img = self.imgs[i]
                task.Wait(8)
            end
        end)
    end
    --关扇贝动作
    function shell_class:close()
        task.New(self, function()
            for i = 5, 1, -1 do
                self.img = self.imgs[i]
                task.Wait(8)
            end
        end)
    end
    function shell_class:kill()
        New(bubble_boom, self.x, self.y, self.size)
    end
    function shell_class:del()
        New(bubble_boom, self.x, self.y, self.size)
    end
end
s4_boss.shell_class = shell_class


--激光预警
do
    local lasereff = Class(object)
    function lasereff:init(x, y, a, r, g, b)
        r, g, b = r or 177, g or 255, b or 97
        self.bound = false
        self.x, self.y = x + 300*cos(a), y + 300*sin(a)
        self.rot = a
        self.hscale, self.vscale = 75, 0
        self.img = "white"
        _object.set_color(self, "mul+rev", 100, r, g, b)
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
    s4_boss.lasereff = lasereff
end
--曲线激光
local bentlaser
do
    bentlaser = Class(laser_bent)
    function bentlaser:init(x, y, l, w, co, st)
        co = co or 16
        st = st or 4
        l = l or 32
        w = w or 8
        laser_bent.init(self, co, x, y, l, w, st,0)
    end
end
s4_boss.bentlaser = bentlaser
--雾
local fog = Class(object)
do
    function fog:init(a)
        self.bound = false
        self.img = "s4_fog"
        self.rot = a or 0
        self.hscale, self.vscale = 1, 1
        self.layer = LAYER_TOP-1
        _object.set_color(self, "", 255, 255, 255, 255)
    end
    function fog:frame()
        task.Do(self)
    end
    function fog:render()
        _object.render(self)
    end
end
s4_boss.fog = fog

--设置行走图
function lstg.wis.Hisoka(self)
    self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
    self._wisys:connectAction("normal", _ACT_NONE_AUTO_Hisoka)
    self._wisys:connectAction("cast", _ACT_CAST_Hisoka)
    self._wisys:connectAction("appear", _ACT_Appear_Hisoka)
    self._wisys:connectAction("disappear", _ACT_DisAppear_Hisoka)
    self.shell = New(shell, self) --生成底坐贝壳对象

    self.cast = cast    --准备吹泡泡的动作，参数self, t持续时间(若小于40帧会自动补正为40帧), IsnWait，如果填true则无前摇，否则该函数执行需要等24帧的前摇动作才能执行后面的内容
    self.sp_cast = sp_cast  --吹出泡泡的动作 self:填对象本身就行，IsnWait:填true要等待48帧的动画效果
    self.appear = appear   --出现效果 self:填对象本身就行，IsnWait:不填true要等待48帧的动画效果
    self.disappear = disappear  --消失效果 self:填对象本身就行，IsnWait:不填true要等待48帧的动画效果
    self.flash = flash  --闪现效果 self:填对象本身就行，IsnWait:不填true要等待96帧的动画效果

    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 0, "mul+rev"
    self.saoqi = New(boss_saoqi, self)
    --self.sc_bg = New(s4_boss.bg)
end
