-----------------------------------------------
---东方栖霞园 六面boss点图动作及特效
-----------------------------------------------

local T = EISlib.BossDefinition.Type
local Bclass = {}
EISlib.BossDefinition.Sonia = Bclass
--导入其他包的方法
local newSimpleClass = EGGlib.Class.newSimpleClass
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local setSize = EGGlib.ObjectEvent.setSize
local velch = EGGlib.ObjectEvent.velocityChange
local tranRot = EGGlib.Math.TranRot

--行走图设置
local boss_name = "Sonia"  --以boss名来作为其相关素材的前缀
local path = "res/boss/Sonia/"

local boss_aura_img1 = boss_name.."boss_aura1"
local boss_aura_img2 = boss_name.."boss_aura2"

--符卡背景
local scbg_imgs = {}
for i = 1, 6 do
    scbg_imgs[i] = boss_name.."_scbg"..i
end


local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.addLayer(self, scbg_imgs[6],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, -1, 0, "mul+rev", --vx, vy, omiga, blend
            0.75, 0.75, --hscale, vscale
            function(self)
            end,
            function(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[3],
            false, --is tile
            0, -300, 180, --x, y, rot
            0, 0, 0, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                --呼吸动画
                local s = 1.005 + 0.005*sin(self.timer)
                self.hscale, self.vscale = s, s
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[2],
            false, --is tile
            0, -300, 0, --x, y, rot
            0, 0, 0.25, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
            end,
            function(self)
            end
    )

    --星星
    _spellcard_background.addLayer(self, scbg_imgs[5],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, -3, 0, "mul+add", --vx, vy, omiga, blend
            0.35, 0.35, --hscale, vscale
            function(self)
            end,
            function(self)
            end,
            function(self)
            end
    )

    --骚气
    _spellcard_background.addLayer(self, scbg_imgs[4],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, 5, 0, "mul+add", --vx, vy, omiga, blend
            3, 1, --hscale, vscale
            function(self)
            end,
            function(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[1],
            false, --is tile
            0, 0, 0, --x, y, rot
            0, 0, 0, "", --vx, vy, omiga, blend
            1, -1, --hscale, vscale
            function(self)
            end,
            function(self)
            end,
            function(self)
            end
    )
end

--立绘演出元素类
local pic_show_obj = newSimpleClass()
--override
function pic_show_obj.constructor(self, img, x, y, rot, hscale, vscale, blend, _a, _r, _g, _b)
    self.img = img
    self.x, self.y = x or 0, y or 0
    self.rot = rot or 0
    self.hscale, self.vscale = hscale or 1, vscale or 1
    robject.set_color(self, blend or "", _a or 255, _r or 255, _g or 255, _b or 255)
    self.vx, self.vy, self.ax, self.ay = 0, 0, 0, 0
end
function pic_show_obj.update(self)
    self.vx, self.vy = self.vx + self.ax, self.vy + self.ay
    self.x, self.y = self.x + self.vx, self.y + self.vy
end
function pic_show_obj.draw(self)
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end


local pic_show_ani = newSimpleClass()
--override
function pic_show_ani.constructor(self, img, x, y, rot, hscale, vscale, blend, _a, _r, _g, _b)
    self.img = img
    self.x, self.y = x or 0, y or 0
    self.rot = rot or 0
    self.hscale, self.vscale = hscale or 1, vscale or 1
    robject.set_color(self, blend or "", _a or 255, _r or 255, _g or 255, _b or 255)
    self.vx, self.vy, self.ax, self.ay = 0, 0, 0, 0
    self.ani = 0
    self.timer = 0
end
function pic_show_ani.update(self)
    self.vx, self.vy = self.vx + self.ax, self.vy + self.ay
    self.x, self.y = self.x + self.vx, self.y + self.vy
    self.ani = self.ani + 1
    self.timer = self.timer + 1
end
function pic_show_ani.draw(self)
    SetAnimationState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    RenderAnimation(self.img, self.ani, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local pic_show = Class(object)
function pic_show:init()
    local s = 0.5
    self.layer = LAYER_ENEMY_BULLET + 1
    self.bound = false
    self.x, self.y = 0, 0
    self.obj_list = {}
    local list = {}
    --构造
    do
        for i = 1, 9 do
            list[i] = pic_show_obj.new(boss_name.."pic_show_"..i, 0, 0, 0, s, s, "", 255, 255, 255, 255) --x, y, rot, hscale, vscale, blend, _a, _r, _g, _b
        end
        --排序
        table.insert(self.obj_list, list[8])
        table.insert(self.obj_list, list[7])
        table.insert(self.obj_list, list[6])
        table.insert(self.obj_list, list[5])
        table.insert(self.obj_list, list[4])
        table.insert(self.obj_list, list[3])
        table.insert(self.obj_list, list[2])
        table.insert(self.obj_list, list[1])
        table.insert(self.obj_list, list[9])
    end
    --立绘人物动态
    task.New(self, function()
        local obj = list[3]
        obj.x, obj.y = 400, 300
        obj.hscale, obj.vscale = 0.85, 0.85
        obj.rot = -5
        task.New(self, function()
            local t = 120
            local drot = 5/t
            for _ = 1, t do
                obj.rot = obj.rot + drot
                task.Wait(1)
            end
        end)
        accDecMoveToPoint(obj, 50, -25, 1, 0, 29) --60帧
        obj.vx, obj.vy = 0.5*cos(-150), 0.5*sin(-150)
        task.Wait(60)
        alphaAndSizeChange(obj, -255, 0, 30)
    end)
    --立绘防护罩动态
    task.New(self, function()
        local obj = list[1]
        obj._blend = "mul+add"
        obj.x, obj.y = 0, -20
        obj._a = 0
        obj.hscale, obj.vscale = 0, 0
        obj.vy = 0.25
        task.New(self, function()
            local t = 30
            local ds = 2*0.5/t
            local d_ds = -ds/t
            local s = 0
            for _ = 1, t do
                ds = ds + d_ds
                s = s + ds
                obj.hscale, obj.vscale = s, s
                task.Wait(1)
            end
        end)
        alphaAndSizeChange(obj, 255, 0, 30)
        alphaAndSizeChange(obj, 0, 0.1, 60)
        alphaAndSizeChange(obj, -255, 0.05, 30)
    end)
    --立绘极光动态
    task.New(self, function()
        local obj = list[9]
        obj._blend = "mul+add"
        obj._a = 0
        obj.hscale, obj.vscale = 0, 0
        task.New(self, function()
            local t = 30
            local ds = 2*0.4/t
            local d_ds = -ds/t
            local s = 0
            for _ = 1, t do
                ds = ds + d_ds
                s = s + ds
                obj.hscale, obj.vscale = s, s
                task.Wait(1)
            end
        end)
        alphaAndSizeChange(obj, 255, 0, 30)
        alphaAndSizeChange(obj, 0, 0.08, 60)
        alphaAndSizeChange(obj, -255, 0.04, 30)
    end)
    --立绘光背背景动态
    task.New(self, function()
        local obj = list[7]
        do
            --两侧的灯跟随
            list[2].update = function(self)
                self.x, self.y = obj.x, obj.y + 150
                self._a = obj._a
                setSize(self, obj.hscale, obj.vscale)
            end
            list[8].update = function(self)
                self.x, self.y = obj.x, obj.y + 200
                self._a = obj._a
                setSize(self, obj.hscale, obj.vscale)
            end
            --圆环
            list[5].update = function(self)
                self.x, self.y = obj.x, obj.y
                self._a = obj._a
                setSize(self, obj.hscale, obj.vscale)
            end
            list[6].update = function(self)
                self.x, self.y = obj.x, obj.y
                self._a = obj._a
                setSize(self, obj.hscale, obj.vscale)
            end
            --蝙蝠背景
            list[4].update = function(self)
                self.x, self.y = obj.x, obj.y
                self._a = obj._a
                setSize(self, obj.hscale, obj.vscale)
            end
        end
        obj.x, obj.y = 0, -60
        obj._a = 0
        obj.hscale, obj.vscale = 0, 0
        task.New(self, function()
            velch(obj, 3, 0.35, 90, 30)
        end)
        task.New(self, function()
            local t = 30
            local ds = 2*0.6/t
            local d_ds = -ds/t
            local s = 0
            for _ = 1, t do
                ds = ds + d_ds
                s = s + ds
                obj.hscale, obj.vscale = s, s
                task.Wait(1)
            end
        end)
        alphaAndSizeChange(obj, 255, 0, 30)
        alphaAndSizeChange(obj, 0, 0, 60)
        alphaAndSizeChange(obj, -255, 0, 30)
    end)
    --蝙蝠动态
    local function createBat()
        local d_a = 255/30
        local c = ran:Int(100, 255)
        local obj = pic_show_ani.new(boss_name.."bat", 0, 0, 0, 0, 0, "", 0, c, c, c)
        local v = ran:Float(2, 10)
        local a = ran:Float(0, 360)
        obj.vx, obj.vy = v*cos(a), v*sin(a)
        obj.ani = ran:Int(0, 23)
        obj.dh, obj.dv = 0.004*sign(obj.vx)*v, 0.004*v
        obj.update = function(self)
            if self.timer < 30 then
                self._a = self._a + d_a
            elseif self.timer >= 90 and self.timer < 120 then
                self._a = self._a - d_a
            end
            obj.hscale, obj.vscale = obj.hscale + obj.dh, obj.vscale + obj.dv
            pic_show_ani.update(self)
        end
        table.insert(self.obj_list, obj)
    end
    for _ = 1, 100 do
        createBat()
    end
end
function pic_show:frame()
    task.Do(self)
    for _, obj in pairs(self.obj_list) do
        obj.update(obj)
    end
    if self.timer > 1 then
        self.hide = false
    else
        self.hide = true
    end
    if self.timer > 120 then
        Del(self)
    end
end
function pic_show:render()
    for _, obj in pairs(self.obj_list) do
        obj.draw(obj)
    end
end

--region 精二立绘静态（用于立绘鉴赏页面）

---@class face.Sonia : luaclass
local face_Sonia = luaclass("face.Sonia")
bossface.Sonia = face_Sonia

function face_Sonia.load()
    for i = 1, 10 do
        local name_ = "face-Sonia-image-" .. i
        lstg.LoadTexture(name_, "res/performer/Sonia/spellcard/" .. i .. ".png")
        local w_, h_ = lstg.GetTextureSize(name_)
        lstg.LoadImage(name_, name_, 0, 0, w_, h_)
    end
end
function face_Sonia.unload()
    for i = 1, 10 do
        local name_ = "face-Sonia-image-" .. i
        local pool_ = "stage"
        pool_ = lstg.CheckRes(2, name_)
        if pool_ then
            lstg.RemoveResource(pool_, 2, name_)
        end
        pool_ = lstg.CheckRes(1, name_)
        if pool_ then
            lstg.RemoveResource(pool_, 1, name_)
        end
    end
end

function face_Sonia:ctor()
    ---@class face.Sonia.image
    local _ = {
        x = 0,
        y = 0,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "",
        color = 0xFFFFFFFF,
        blend = "",
    }
    
    self.timer = 0
    
    ---@type face.Sonia.image[]
    self._image = {}
    
    -- 光辉效果
    table.insert(self._image, {
        x = 40,
        y = 180,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 9,
        color = 0xFFFFFFFF,
        blend = "mul+add",
    })
    
    -- 魔法门
    table.insert(self._image, {
        x = 20,
        y = 0,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 7,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 蝙蝠群
    table.insert(self._image, {
        x = 0,
        y = -140,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 4,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 灯远
    table.insert(self._image, {
        x = 40,
        y = 0,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 8,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 圆环斜的1
    table.insert(self._image, {
        x = 0,
        y = -140,
        rot = 0,
        hscale = 1.04,
        vscale = 1.04,
        image = "face-Sonia-image-" .. 5,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 圆环圆的
    table.insert(self._image, {
        x = 0,
        y = -140,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 6,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 人物
    table.insert(self._image, {
        x = 56,
        y = -240,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 3,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 圆环斜的2
    table.insert(self._image, {
        x = 0,
        y = -140,
        rot = 0,
        hscale = 1.04,
        vscale = 1.04,
        image = "face-Sonia-image-" .. 10,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 灯近
    table.insert(self._image, {
        x = 0,
        y = 0,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 2,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 光罩
    table.insert(self._image, {
        x = 0,
        y = -100,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Sonia-image-" .. 1,
        color = 0xFFFFFFFF,
        blend = "mul+add",
    })
end
function face_Sonia:update()
    -- 计时器
    self.timer = self.timer + 1
end
function face_Sonia:draw(x, y, rot, scale, alpha)
    scale = scale * 0.18
    local function vec2rot(u, v, a)
        return
        u * lstg.cos(a) - v * lstg.sin(a),
        u * lstg.sin(a) + v * lstg.cos(a)
    end
    local color = lstg.Color(0xFFFFFFFF)
    for _, v in ipairs(self._image) do
        color.argb = v.color
        color.a = color.a * alpha
        lstg.SetImageState(v.image, v.blend, color)
        local x_, y_ = vec2rot(v.x, v.y, rot)
        lstg.Render(v.image, x + x_ * scale, y + y_ * scale, v.rot + rot, v.hscale * scale, v.vscale * scale)
    end
end

--endregion

--光背贴图
local ring_img = boss_name.."_ring"
local head_img = boss_name.."_head"
local flag_imgs = {}
for i = 0, 5 do
    flag_imgs[i + 1] = boss_name.."_flag_"..i
end
local gem_imgs = {}
for i = 0, 19 do
    gem_imgs[i + 1] = boss_name.."_gem_"..i
end
local whirlpools_imgs = {}
for i = 0, 17 do
    whirlpools_imgs[i + 1] = boss_name.."_whirlpools_"..i
end
local wing_imgs = {}
for i = 1, 3 do
    wing_imgs[i] = boss_name.."_wing_"..i
end

--蓝月亮背景
local red_moon_imgs = {}
for i = 0, 39 do
    red_moon_imgs[i + 1] = boss_name.."_red_moon"..i
end

--鳞弹拖尾
local blue_light_tex = boss_name.."light_blue"
Bclass.blue_light_tex = blue_light_tex
--region  又是变形金刚组装
local backlight_size = 0.8

--这几个光背组件的出现控制函数


local function appear(self, size_t, phase, size)
    size = size or 1
    self.size_t = size_t
    self.size = 0
    self.dsize = size*backlight_size/size_t/sin(phase)
    self.phase = 0 --相位
    self.dphase = phase/size_t
    self.hscale, self.vscale = 0, 0
end

local function disappear(self, size_t)
    self.size_t = size_t
    self.dphase = -self.phase/size_t
    self.dsize = -self.size/size_t
end

local function normalSizeChangeInit(self, size)
    appear(self, 0, 0, size)
    disappear(self, 0) --默认是关掉的
end

local function normalSizeChangeFrame(self)
    if self.size_t > 0 then
        self.size = self.size + self.dsize
        self.phase = self.phase + self.dphase
        local s = self.size*sin(self.phase)
        self.hscale, self.vscale = s, s
        self.size_t = self.size_t - 1
    end
end

local head = Class(object)
function head:init(mst)
    self.img = head_img
    self.mst = mst
    self._dx, self._dy = 0, 45*backlight_size
    self.x, self.y = mst.x + self._dx, mst.y + self._dy
    self.bound = false
    self.layer = LAYER_BG + 52
    robject.set_color(self, "", 255, 255, 255, 255)
    normalSizeChangeInit(self)
end
function head:frame()
    local mst = self.mst
    if IsValid(mst) then
        self.x, self.y = mst.x + self._dx, mst.y + self._dy
    else
        Del(self)
    end
    normalSizeChangeFrame(self)
end
function head:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
function head:open()
    appear(self, 60, 120) --self, size_t, phase --出现动画时间为60，相位为120（大概会有一个先放大再变小到正常贴图的动画）
end
function head:close()
    disappear(self, 60) --self, size_t
end

local ring = Class(object)
function ring:init(mst)
    self.img =  ring_img
    self.mst = mst
    self.x, self.y = mst.x, mst.y
    self.bound = false
    self.layer = LAYER_BG + 53
    robject.set_color(self, "", 255, 255, 255, 255)
    normalSizeChangeInit(self)
end
function ring:frame()
    local mst = self.mst
    if IsValid(mst) then
        self.x, self.y = mst.x, mst.y
    else
        Del(self)
    end
    normalSizeChangeFrame(self)
end
function ring:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
function ring:open()
    appear(self, 60, 120) --self, size_t, phase --出现动画时间为60，相位为120（大概会有一个先放大再变小到正常贴图的动画）
end
function ring:close()
    disappear(self, 60) --self, size_t
end


local gem = Class(object)
function gem:init(mst, u)
    self.img = gem_imgs[1]
    self.mst = mst
    self._dx, self._dy = 80*u*backlight_size, 80*backlight_size
    self.x, self.y = mst.x + self._dx, mst.y + self._dy
    self.bound = false
    self.layer = LAYER_BG + 54
    robject.set_color(self, "", 255, 255, 255, 255)
    normalSizeChangeInit(self)
    self.u = u
end
function gem:frame()
    self.img = gem_imgs[math.floor(self.timer/4)%20 + 1]
    local mst = self.mst
    if IsValid(mst) then
        self.x, self.y = mst.x + self._dx, mst.y + self._dy
    else
        Del(self)
    end
    normalSizeChangeFrame(self)
end
function gem:render()
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale*self.u, self.vscale)
end
function gem:open()
    appear(self, 60, 120)
end
function gem:close()
    disappear(self, 60)
end

local Flag = Class(object)
function Flag:init(mst)
    self.img = flag_imgs[1]
    self.mst = mst
    self._dy = 0
    self.x, self.y = mst.x, mst.y + self._dy
    self.bound = false
    self.layer = LAYER_BG + 51
    robject.set_color(self, "", 255, 255, 255, 255)
    normalSizeChangeInit(self)
    --自己的

end
function Flag:frame()
    self.img = flag_imgs[math.floor(self.timer/4)%6 + 1]
    local mst = self.mst
    if IsValid(mst) then
        self.x, self.y = mst.x, mst.y + self._dy + 5*(sin(2*self.timer) - 1)
    else
        Del(self)
    end

    if self.size_t > 0 then
        self._dy = self._dy + self.d_dy
    end
    normalSizeChangeFrame(self)
end
function Flag:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
function Flag:open()
    appear(self, 60, 120)
    --向下移动
    self.d_dy = -110*backlight_size/self.size_t --size_t由上面的appear产生
end
function Flag:close()
    disappear(self, 60)
    --收回来了
    self.d_dy = (0 - self._dy)/self.size_t
end

local whirlpools = Class(object)
function whirlpools:init(mst)
    self.img = whirlpools_imgs[1]
    self.hscale, self.vscale = backlight_size, backlight_size
    self.mst = mst
    self.x, self.y = mst.x, mst.y
    self.bound = false
    self.layer = LAYER_BG + 51
    robject.set_color(self, "", 255, 255, 255, 255)
    normalSizeChangeInit(self)
end
function whirlpools:frame()
    self.img = whirlpools_imgs[math.floor(self.timer/4)%18 + 1]
    local mst = self.mst
    if IsValid(mst) then
        self.x, self.y = mst.x, mst.y
    else
        Del(self)
    end
    normalSizeChangeFrame(self)
end
function whirlpools:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
function whirlpools:open()
    appear(self, 60, 120) --self, size_t, phase --出现动画时间为60，相位为120（大概会有一个先放大再变小到正常贴图的动画）
end
function whirlpools:close()
    disappear(self, 60) --self, size_t
end

local dx, dy = 0*141*0.5*backlight_size, 0*121*0.5*backlight_size  --翅膀根部离光背中心的距离
local wing_size = 1.5
local wing1_len = 170*0.5*backlight_size*wing_size --翅膀1的长度
local wing2_len = 200*0.5*backlight_size*wing_size
local wing3_len = 260*0.5*backlight_size*wing_size

local function wingRotChange(self, drot_t, drot0, drot)
    self.drot_t = drot_t --变化时间
    self.drot0 = drot0 or self.drot0 --相对于主人的角度
    self.d_drot = drot/drot_t --变化率
end

local function wingDaChange(self, _da_t, _da0, _da)
    self._da_t = _da_t --变化时间
    self._da = _da0 or self._da--翅膀振幅
    self.d_da = _da/_da_t --变化率
end

local function wingChangeInit(self)
    wingRotChange(self, 0, 0, 0)
    self.rot = self.mst.rot + self.drot0 --self.drot0由上面的函数提供
    wingDaChange(self, 0, 0, 0)
end
local function wingChangeFrame(self)
    if self.drot_t > 0 then
        self.drot0 = self.drot0 + self.d_drot
        self.drot_t = self.drot_t - 1
    end
    if self._da_t > 0 then
        self._da = self._da + self.d_da
        self._da_t = self._da_t - 1
    end
end

local wing2, wing3 --声明翅膀2和3（要依附于1）
local wing1 = Class(object)
function wing1:init(mst, u)
    self.img = wing_imgs[1]
    self.mst = mst
    wingChangeInit(self)
    self.rot = self.drot0
    self._dx, self._dy = dx*u, dy
    self.x, self.y = mst.x + self._dx, mst.y + self._dy
    self.head_x, self.head_y = self.x + wing1_len*cos(self.rot), self.y + wing1_len*sin(self.rot)
    normalSizeChangeInit(self, wing_size)
    self.bound = false
    self.layer = LAYER_BG + 55
    robject.set_color(self, "", 255, 255, 255, 255)
    --顺序：索引由小到大，翅膀由内到外（1对应最里边的一扇，3对应最外边的一扇）
    self.wings = {}
    table.insert(self.wings, New(wing2, self, u, 0.75))
    table.insert(self.wings, New(wing2, self, u, 0.9))
    table.insert(self.wings, New(wing3, self, u, 1))
    self.u = u
end
function wing1:frame()
    local mst = self.mst
    if IsValid(mst) then
        self.rot = self.drot0 + self._da*sin(2*self.timer)
        self.x, self.y = mst.x + self._dx, mst.y + self._dy
        self.head_x, self.head_y = self.x + wing1_len*cos(self.rot), self.y + wing1_len*sin(self.rot)
    else
        Del(self)
    end
    wingChangeFrame(self)
    self.vscale = abs(self.vscale)
    normalSizeChangeFrame(self)
    self.vscale = self.vscale*self.u
end
function wing1:render()
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function wing1:open()
    tasker(function()
        --角度朝向正上方
        wingRotChange(self, 0, 90, 0) -- t, drot0, d_drot
        --放大出现
        appear(self, 30, 120, 1.2*wing_size*backlight_size) --size_t, phase, size
        local obj
        for i = 1, 3 do
            obj = self.wings[i]
            if IsValid(obj) then
                wingRotChange(obj, 0, -180*obj.u, 0)
            end
        end
        task.Wait(30)
        for i = 1, 3 do
            obj = self.wings[i]
            if IsValid(obj) then
                appear(obj, 30, 120, obj.size0*wing_size*backlight_size) --size_t, phase, size
            end
        end
        task.Wait(30)
        --向两侧折
        wingRotChange(self, 60, 90, -40*self.u) -- t, drot0, d_drot
        task.Wait(15)
        --其他翅膀部件也开始分散开，并且在一定范围内晃动
        self.timer = -30
        wingDaChange(self, 60, nil, 10*self.u - self._da) --_da_t, _da0, _da
        local drots = {-130*self.u, -94*self.u, -65*self.u} --三个翅膀部件转完后相对主翅膀的角度
        local _das = {10*self.u, 16*self.u, 20*self.u}
        for i = 3, 1, -1 do
            obj = self.wings[i]
            if IsValid(obj) then
                obj.timer = -30 --这个是影响到振幅的
                wingRotChange(obj, 30 + 10*(i-1), nil, drots[i] - obj.drot0)
                wingDaChange(obj, 30 + 10*(i-1), nil, _das[i] - obj._da) --_da_t, _da0, _da
            end
            task.Wait(20)
        end
    end)
end
function wing1:close()
    tasker(function()
        local obj
        --翅膀收回去
        wingDaChange(self, 60, nil, 0 - self._da) --_da_t, _da0, _da
        for i = 3, 1, -1 do
            obj = self.wings[i]
            if IsValid(obj) then
                wingRotChange(obj, 30 + 5*(i-1), nil, -180*obj.u - obj.drot0)
                wingDaChange(obj, 30 + 5*(i-1), nil, 0 - obj._da) --_da_t, _da0, _da
            end
            task.Wait(10)
        end
        --向中间折回
        wingRotChange(self, 60, nil, 90 - self.drot0) -- t, drot0, d_drot
        task.Wait(60)
        --其他翅膀部件缩小消失
        for i = 1, 3 do
            obj = self.wings[i]
            if IsValid(obj) then
                disappear(obj, 30) --size_t
            end
        end
        task.Wait(30)
        --本体也缩小消失
        disappear(self, 30) --size_t
    end)
end
function wing1:getWing(i)
    return self.wings[i]
end

wing2 = Class(object)
function wing2:init(mst, u, size)
    self.img = wing_imgs[2]
    self.mst = mst
    wingChangeInit(self)
    self.x, self.y = mst.head_x, mst.head_y
    normalSizeChangeInit(self, size*wing_size)
    self.bound = false
    self.layer = LAYER_BG + 54
    robject.set_color(self, "", 255, 255, 255, 255)
    EGGlib.RenderEffect.newTrail(self,
            -1, 6, 1, --dlayer, maxnum, frame,
            self.img, 1.1, --img, size,
            "mul+add", 99999, 0.75, --blend, times, _a_rate,
            true, 2, true, --Isdsize, size_min, Isdalpah,
            {0, 255, 255}, {0, 50, 255}
    )
    self.u = u
    self.size0 = size
end
function wing2:frame()
    local mst = self.mst
    if IsValid(mst) then
        self.rot = mst.rot + self.drot0 + self._da*sin(2*self.timer)
        self.x, self.y = mst.head_x, mst.head_y
    else
        Del(self)
    end
    wingChangeFrame(self)
    --特殊处理：对vscale
    self.vscale = abs(self.vscale)
    normalSizeChangeFrame(self)
    self.vscale = self.vscale*self.u
end
function wing2:render()
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function wing2:getHeadPos()
    local s = self.hscale
    return self.x + wing2_len*s*cos(self.rot), self.y + wing2_len*s*sin(self.rot)
end

wing3 = Class(object)
function wing3:init(mst, u, size)
    self.img = wing_imgs[3]
    self.mst = mst
    wingChangeInit(self)
    self.x, self.y = mst.head_x, mst.head_y
    normalSizeChangeInit(self, size*wing_size)
    self.bound = false
    self.layer = LAYER_BG + 54
    robject.set_color(self, "", 255, 255, 255, 255)
    EGGlib.RenderEffect.newTrail(self,
            -1, 6, 1, --dlayer, maxnum, frame,
            self.img, 1.1, --img, size,
            "mul+add", 99999, 0.75, --blend, times, _a_rate,
            true, 2, true, --Isdsize, size_min, Isdalpah,
            {0, 255, 255}, {0, 50, 255}
    )
    self.u = u
    self.size0 = size
end
function wing3:frame()
    local mst = self.mst
    if IsValid(mst) then
        self.rot = mst.rot + self.drot0 + self._da*sin(2*self.timer)
        self.x, self.y = mst.head_x, mst.head_y
    else
        Del(self)
    end
    wingChangeFrame(self)
    self.vscale = abs(self.vscale)
    normalSizeChangeFrame(self)
    self.vscale = self.vscale*self.u
end
function wing3:render()
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function wing3:getHeadPos()
    local s = self.hscale
    return self.x + wing3_len*s*cos(self.rot), self.y + wing3_len*s*sin(self.rot)
end


local backlight = Class(object)
function backlight:init(boss)
    self.objs = {}
    self.objs["head"] = New(head, self)
    self.objs["ring"] = New(ring, self)
    for i = 1, 2 do
        self.objs["gem"..i] = New(gem, self, tranU(i))
    end
    self.objs["flag"] = New(Flag, self)
    self.objs["whirlpools"] = New(whirlpools, self)
    self.objs["wing_right"] = New(wing1, self, 1)
    self.objs["wing_left"] = New(wing1, self, -1)
    self.bound = false
    self.boss = _boss
    self.isOpen = false
    self.destory = false
end
function backlight:frame()
    local boss = self.boss
    if IsValid(boss) then
        self.x, self.y = boss.x, boss.y
    elseif not self.destory then
        backlight.destory(self)
    end
    task.Do(self)
end
function backlight:open()
    for _, obj in pairs(self.objs) do
        obj.class.open(obj)
    end
    self.isOpen = true
end
function backlight:close()
    tasker(function()
        local list = {self.objs["wing_right"], self.objs["wing_left"]}
        --先收翅膀
        for _, obj in pairs(list) do
            obj.class.close(obj)
        end
        task.Wait(60)
        list = {self.objs["head"], self.objs["ring"], self.objs["gem1"], self.objs["gem2"], self.objs["flag"],  self.objs["whirlpools"]}
        --收其他的
        for _, obj in pairs(list) do
            obj.class.close(obj)
        end
        self.isOpen = false
    end)
end
function backlight:getPart(name)
    return self.objs[name]
end
function backlight:destory()
    self.destory = true
    task.New(self, function()
        if self.isOpen then
            backlight.close(self)
            task.Wait(180)
        end
        for _, obj in pairs(self.objs) do
            Del(obj)
        end
        Del(self)
    end)
end
--endregion

--region 滤镜与冲击波环
local ring1_img = boss_name.."ring1"
local ring2_img = boss_name.."ring2"
Bclass.ring1_img = ring1_img
Bclass.ring2_img = ring2_img
--endregion

--region 行走图
--第一套，杖形态
local WalkImage1 =  T.createWalkImage(
        boss_name.."_BossWalkImage1", 180, 180, 6, --tex, u, v, n
        --normalMovementFunc,
        T.createNormalMovementFunc(
                T.createActionTable({1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 9, 10, 11, 12}), --normal
                T.createActionTable({13, 14, 15, 16, 17, 18}, 4), --left
                T.createActionTable({19, 20, 21, 22, 23, 24}, 4), --right
                8, --cutFrame,
                0.5  --size,
        ),
        {
            --旋转法杖(一整套)
            {"revolve_staff", T.createSpecialActionFunc(
                    {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 11)
                        return n
                    end, --func,
                    4, 0.5)}, --cutFrame, size
            --旋转法杖（一直转着）
            {"revolve_staff2", T.createSpecialActionFunc(
                    {28, 29, 30, 31}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame)
                        n = n%4 + 1
                        return n
                    end, --func,
                    4, 0.5)}, --cutFrame, size
            --旋转法杖（收尾）
            {"revolve_staff3", T.createSpecialActionFunc(
                    {32, 33, 34, 35}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame)
                        n = min(n, 4)
                        return n
                    end, --func,
                    4, 0.5)}, --cutFrame, size
        },
        --spActionFuncTable,
        {
            --正常转完一轮法杖
            {"revolve_staff",
             function(self)
                 self:setAction("revolve_staff", 44)
             end},
            --开始转
            {"revolve_start",
             function(self)
                 task.New(self, function()
                     self:setAction("revolve_staff", 24)
                     task.Wait(24)
                     self:setAction("revolve_staff2", 999)
                 end)
             end},
            --结束转
            {"revolve_end",
             function(self)
                 self:setAction("revolve_staff3", 24)
             end},
        })

--第二套，剑形态
local WalkImage2 =  T.createWalkImage(
        boss_name.."_BossWalkImage2", 256, 256, 6, --tex, u, v, n
--normalMovementFunc,
        T.createNormalMovementFunc(
                T.createActionTable({1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 10, 11, 12}), --normal
                T.createActionTable({13, 14, 15, 16, 17, 18}, 4), --left
                T.createActionTable({19, 20, 21, 22, 23, 24}, 4), --right
                8, --cutFrame,
                0.5  --size,
        ),
        {
            --由法杖转变为剑 40f
            {"changeToSword", T.createSpecialActionFunc(
                    {25, 26, 27, 28, 29, 30, 35, 36, 37, 38}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 10)
                        return n
                    end, --func,
                    4, 0.5)}, --cutFrame, size
            --由剑转为法杖 40f
            {"changeToStaff", T.createSpecialActionFunc(
                    {38, 37, 36, 35, 30, 29, 28, 27, 26, 25}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 10)
                        return n
                    end, --func,
                    4, 0.5)}, --cutFrame, size
            --向右挥刀
            {"right_attack", T.createSpecialActionFunc(
                    {39, 40, 41}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 3)
                        return n
                    end, --func,
                    8, 0.5)}, --cutFrame, size
            --向左挥刀
            {"left_attack", T.createSpecialActionFunc(
                    {42, 43, 44}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 3)
                        return n
                    end, --func,
                    8, 0.5)}, --cutFrame, size
        },
        --spActionFuncTable,
        {
            --由法杖转变为剑 56f
            {"changeToSword",
             function(self)
                 self:setAction("changeToSword", 42)
             end},
            --由剑转为法杖
            {"changeToStaff",
             function(self)
                 self:setAction("changeToStaff", 42)
             end},
            --向右挥刀
            {"right_attack",
             function(self)
                 self:setAction("right_attack", 24)
             end},
            --向左挥刀
            {"left_attack",
             function(self)
                 self:setAction("left_attack", 24)
             end},
        })

--endregion

--region 刀子
--剑拖影
local swordLight = Class(laser_bent)
function swordLight:init(mst, dr, u, len, wide)
    if IsValid(mst) then
        local a = mst.rot + 90*u
        self._da = 90*u
        self.getPos = function()
            local dx, dy = tranRot(dr, 0, 2.5*u + mst.rot - 0)
            return dx, dy
        end
        local dx, dy = self.getPos()
        laser_bent.init(self, 1, mst.x + dx, mst.y + dy, len, wide, "Sonia_sword_light", 0)
        self.rot = a
        self.alpha = 1
        self.group = GROUP_GHOST -- 特效用曲线激光
        self.layer = LAYER_TOP
        self.colli = false -- 特效用曲线激光
        self.bound = false
        self.mst = mst
        self.release = false
        robject.set_color(self, "mul+add", 255, 255, 255, 255)
    else
        self.status = "del"
    end
end
function swordLight:frame()
    if not self.release then
        if IsValid(self.mst) then
            local dx, dy = self.getPos()
            self.rot = self.mst.rot + self._da
            self.x, self.y = self.mst.x + dx, self.mst.y + dy
        end
    elseif self.alpha > 0 then
        self.alpha = max(0, self.alpha - 0.025)
    else
        self.status = "del"
    end

    if self.timer > 60 then
        self.bound = true
    end
    laser_bent.frame(self)
end

--剑
local sword = Class(object)
function sword:init(x, y)
    self.img = "Sonia_sword"
    self.x, self.y = x, y
    --self.layer = LAYER_PLAYER - 1
    self.layer = LAYER_TOP
    robject.set_color(self, "", 255, 255, 255, 255)
end
function sword:frame()
    if self.status == "normal" then
        task.Do(self)
    end
end
function sword:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
function sword:createLight(u, wt, start_r, add_r)
    for i = 0, 3 do
        local obj = New(swordLight, self, start_r + add_r*i*self.hscale, u, 20 + 20*i, 30 + 30*(3-i)) --mst, dr, u, len, wide
        task.New(obj, function()
            task.Wait(wt)
            local t = 30
            local l0 = obj.l
            local dl = -l0/t
            while l0 + dl > 2 do
                l0 = l0 + dl
                obj.l = math.ceil(l0)
                task.Wait(1)
            end
            obj.status = 'del'
        end)
    end
end

Bclass.sword = sword
--endregion

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s6_boss", --theme_music,
        stage6_background, --background,
        --资源载入函数
        function()
            --符卡背景
            for i = 1, 6 do
                LoadImageFromFile(scbg_imgs[i], path .. "scbg"..i..".png", true, 0, 0, false, 0)
            end
            --行走图
            LoadTexture(boss_name.."_BossWalkImage1", path .. "BossWalkImage1.png")--杖形态
            LoadTexture(boss_name.."_BossWalkImage2", path .. "BossWalkImage2.png")--剑形态

            --光背素材
            local backlight_path = path.."backlight/"
            LoadImageFromFile(ring_img, backlight_path.."ring.png")
            LoadImageFromFile(head_img, backlight_path.."head.png")
            for i = 0, 5 do
                LoadImageFromFile(flag_imgs[i + 1], backlight_path.."flag/"..i..".png")
            end
            for i = 0, 19 do
                LoadImageFromFile(gem_imgs[i + 1], backlight_path.."gem/"..i..".png")
            end
            for i = 0, 17 do
                LoadImageFromFile(whirlpools_imgs[i + 1], backlight_path.."whirlpools/"..i..".png")
            end
            local pos = {
                {44, 48},
                {35, 28},
                {30, 64}
            }
            for i = 1, 3 do
                LoadImageFromFile(wing_imgs[i], backlight_path.."wing/"..i..".png")
                SetImageCenter(wing_imgs[i], pos[i][1], pos[i][2])
            end
            --剑
            LoadImageFromFile(boss_name.."_sword", path.."sword.png")
            SetImageCenter(boss_name.."_sword", 17, 50)
            local sword_light_tex = boss_name.."_sword_light"
            LoadTexture(sword_light_tex, path.."sword_light.png")
            Add_bentlaser_texture(sword_light_tex, sword_light_tex) --添加至曲线激光
            --血灵碎片拖尾
            local chip_light_tex = boss_name.."_chip_light"
            LoadTexture(chip_light_tex, path.."chip_light.png")
            Add_bentlaser_texture(chip_light_tex, chip_light_tex) --添加至曲线激光
            --蓝鳞弹拖尾
            LoadTexture(blue_light_tex, path.."light_blue.png")
            Add_bentlaser_texture(blue_light_tex, blue_light_tex) --添加至曲线激光
            --蓝月亮
            for i = 0, 39 do
                LoadImageFromFile(red_moon_imgs[i+1], path.."red_moon/"..i..".png")
            end
            --pic show
            do
                local path = path.."pic_show/"
                for i = 1, 9 do
                    LoadImageFromFile(boss_name.."pic_show_"..i, "res/performer/Sonia/spellcard/"..i..".png")
                end
                LoadAniFromFile(boss_name.."bat", path.."bat.png", false, 6, 1, 4)
            end
            --ring
            LoadImageFromFile(ring1_img, path.."ring1.png")
            LoadImageFromFile(ring2_img, path.."ring2.png")

            --aura
            LoadImageFromFile(boss_aura_img1, path.."boss_aura1.png")
            LoadImageFromFile(boss_aura_img2, path.."boss_aura2.png")
            
            --彩虹屁
            LoadTexture("Gluttony_rainbow", "res/boss/Gluttony/rainbow.png")
            Add_bentlaser_texture("Gluttony_rainbow", "Gluttony_rainbow") --添加至曲线激光
        end,
        --行走图动作函数
        WalkImage1,  --默认杖形态
        --boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 255, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                end,
                --scOpenEffect,
                function(self)
                    New(pic_show)
                    New(effect.spell_attack, 0, 255, 255)
                    task.Wait(60)
                    self.absorbAction(self, 60)
                end,
                --absorbEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 0, 150, 150)
                    if t then task.Wait(t) end
                end,
                --breakEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 0, 150, 150)
                    if t then task.Wait(t) end
                end,
                --absorbAction,
                function(self, t, x, y)
                    self.revolveStaff()
                    x, y = x or self.x, y or self.y
                    self.absorbEffect(self, t, x, y)
                end,
                --scBreakEffect
                function(self)
                    EGGlib.RenderEffect.scBreakEffect(self.x, self.y, 0, 150, 150, 'tree_leaf_white', 'Cherry_eff')
                end
        ),
        scbg, --scbg
        pic_show, --pic_show
        function(self)
            system.spellcard.auxiliary.setChainBonusBase(system.spellcard.BONUS_CHAIN_BASE_S5S6) -- 修改为2倍
            self.backlight = New(backlight, self) --创建光背
            self.openBacklight = function()
                if not IsValid(self.backlight) then
                    self.backlight = New(backlight, self) --创建光背
                end
                backlight.open(self.backlight)
            end
            self.getBacklight = function()
                return self.backlight
            end
            self.changeToStaff = function()
                T.changeWalkImage(self, WalkImage2)
                self.cast("changeToStaff")
                task.New(self, function()
                    task.Wait(40)
                    T.changeWalkImage(self, WalkImage1) --行走图切换
                end)
            end
            self.changeToSword = function()
                T.changeWalkImage(self, WalkImage2)
                self.cast("changeToSword")
            end
            self.revolveStaff = function()
                T.changeWalkImage(self, WalkImage1)
                self.cast("revolve_staff")
            end
            self.rightAttack = function()
                T.changeWalkImage(self, WalkImage2)
                self.cast("right_attack")
            end
            self.leftAttack = function()
                T.changeWalkImage(self, WalkImage2)
                self.cast("left_attack")
            end
            --设置特殊爆炸
            boss.setBossExplode(self,
                    function(boss)
                        --player.dialog = true
                        lstg.var.timeslow = 2
                        backlight.destory(boss.backlight)
                        local angle = ran:Float(10, 20)
                        boss.vx = 0.2 * cos(angle)
                        boss.vy = 0.2 * sin(angle)
                        New(boss_death_ef, boss.x, boss.y, true)
                        task.Wait(60)
                        New(boss_death_ef, boss.x, boss.y, true)
                        task.Wait(60)
                        boss.vx = 0
                        boss.vy = 0
                        New(boss_death_ef, boss.x, boss.y)
                        New(boss_death_circle, boss.x, boss.y)
                        boss.hide = true
                        lstg.var.timeslow = nil
                        task.Wait(60)
                        Del(boss)
                    end
            )
            --设置特殊法阵样式
            boss.class.changeRenderAuraFunc(self, function(self)
                local s = 0.9 + 0.15*sin(1.5*self.ani)
                local alpha = 0.8 + 0.2*sin(2.5*self.ani)
                SetImageState(boss_aura_img1, "mul+add", Color(self.aura_alpha*alpha, 255, 255, 255))
                Render(boss_aura_img1, self.x, self.y, self.ani * 0.8, s, s)
                SetImageState(boss_aura_img2, "mul+add", Color(self.aura_alpha*alpha, 255, 255, 255))
                Render(boss_aura_img2, self.x, self.y, -self.ani * 0.8, 0.7*s, 0.7*s)
            end)
        end
)
return BossRes
