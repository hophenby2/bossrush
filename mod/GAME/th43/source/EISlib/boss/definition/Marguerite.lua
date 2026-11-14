-----------------------------------------------
---东方栖霞园 四面boss点图动作及特效
-----------------------------------------------

local T = EISlib.BossDefinition.Type

--导入其他包的方法
local newSimpleClass = EGGlib.Class.newSimpleClass
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local Bclass = {}
EISlib.BossDefinition.Marguerite = Bclass

--行走图设置
local boss_name = "Marguerite"  --以boss名来作为其相关素材的前缀
local path = "res/boss/"..boss_name.."/"

local boss_arua_img = boss_name.."boss_arua"

--符卡背景
local scbg_imgs = {}
for i = 1, 3 do
    scbg_imgs[i] = boss_name.."_scbg"..i
end

local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.addLayer(self, scbg_imgs[3],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, 0, 0.25, "mul+rev", --vx, vy, omiga, blend
            0.5, 0.5, --hscale, vscale
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[2],
            false, --is tile
            0, 0, 0, --x, y, rot
            0, 0, 0, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[1],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, 1, 0, "", --vx, vy, omiga, blend
            0.5, 0.5, --hscale, vscale
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
end

--region 立绘演出

local function _load_spellcard_effect()
    for i = 1, 5 do
        LoadImageFromFile(
            boss_name .. "pic_show_" .. i,
            "res/performer/Lechat/spellcard/" .. i .. ".png")
    end
end

--立绘演出
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
    local s = 0.4
    self.layer = LAYER_ENEMY_BULLET + 1
    self.bound = false
    self.x, self.y = 0, 0
    self.obj_list = {}
    local list = {}
    --构造
    do
        for i = 1, 5 do
            list[i] = pic_show_obj.new(boss_name.."pic_show_"..i, 0, 0, 0, s, s, "", 255, 255, 255, 255) --x, y, rot, hscale, vscale, blend, _a, _r, _g, _b
        end
        --排序
        table.insert(self.obj_list, list[5])
        table.insert(self.obj_list, list[4])
        table.insert(self.obj_list, list[3])
        table.insert(self.obj_list, list[2])
        table.insert(self.obj_list, list[1])
    end
    --立绘人物动态
    task.New(self, function()
        local obj = list[2]
        obj._a = 0
        obj.x, obj.y = 400, 300
        obj.hscale, obj.vscale = 0.5, 0.5
        obj.rot = -5
        task.New(self, function()
            local t = 120
            local drot = 5/t
            for _ = 1, t do
                obj.rot = obj.rot + drot
                task.Wait(1)
            end
        end)
        task.New(self, function()
            local t = 15
            local d_a = 255/t
            for i = 1, t do
                obj._a = obj._a + d_a
                task.Wait(1)
            end
        end)
        accDecMoveToPoint(obj, 30, -10, 1, 0, 29) --30帧
        obj.vx, obj.vy = 0.5*cos(-150), 0.5*sin(-150)
        task.Wait(60)
        alphaAndSizeChange(obj, -255, 0, 30)
    end)
    --闪电与刀光动态
    task.New(self, function()
        local obj = list[1]
        obj._blend = "mul+add"
        obj.x, obj.y = 0, -20
        obj._a = 0
        obj.hscale, obj.vscale = 0, 0
        obj.vy = 0.25
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
        alphaAndSizeChange(obj, 0, 0.05, 60)
        alphaAndSizeChange(obj, -255, 0.025, 30)
    end)
    --光背动态
    task.New(self, function()
        local t = 120
        local obj = list[3]
        obj.hscale, obj.vscale = 0.5*s, 0.5*s
        obj.x, obj.y = 0, 0
        obj.vx, obj.vy = 30/t, 30/t --往右上方走
        obj._a = 0
        alphaAndSizeChange(obj, 255, 0.5*s, 30)
        task.Wait(60)
        alphaAndSizeChange(obj, -255, 0, 30)
    end)
    --十字架
    task.New(self, function()
        local t = 120
        local obj = list[4]
        obj.x, obj.y = 0, 0
        obj.hscale, obj.vscale = 0.5*s, 0.5*s
        obj.vx, obj.vy = 0/t, -15/t --往下走
        obj._a = 0
        alphaAndSizeChange(obj, 255, 0.5*s, 30)
        task.Wait(60)
        alphaAndSizeChange(obj, -255, 0, 30)
    end)
    --环状云
    task.New(self, function()
        local t = 120
        local obj = list[5]
        obj.hscale, obj.vscale = 0.5*s, 0.5*s
        obj.x, obj.y = 0, 0
        obj.vx, obj.vy = 0/t, 30/t --往下走
        obj._a = 0
        --角度变化
        obj.rot = -90
        task.New(self, function()
            local t = 30
            local drot = -2*obj.rot/t
            local d_drot = -drot/t
            for _ = 1, t do
                drot = drot + d_drot
                obj.rot = obj.rot + drot + 0.25
                task.Wait(1)
            end
            t = 90
            for _ = 1, t do
                obj.rot = obj.rot + 0.25
                task.Wait(1)
            end
        end)
        alphaAndSizeChange(obj, 255, 0.5*s, 30)
        alphaAndSizeChange(obj, 0, 0.05*s, 60)
        alphaAndSizeChange(obj, -255, 0.025*s, 30)
    end)
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

--endregion

--region 精二立绘静态（用于立绘鉴赏页面）

---@class face.Marguerite : luaclass
local face_Marguerite = luaclass("face.Marguerite")
bossface.Lechat = face_Marguerite

function face_Marguerite.load()
    for i = 1, 5 do
        local name_ = "face-Marguerite-image-" .. i
        lstg.LoadTexture(name_, "res/performer/Lechat/spellcard/" .. i .. ".png")
        local w_, h_ = lstg.GetTextureSize(name_)
        lstg.LoadImage(name_, name_, 0, 0, w_, h_)
    end
    lstg.SetImageCenter("face-Marguerite-image-" .. 1, 1420, 1180)
    lstg.SetImageCenter("face-Marguerite-image-" .. 3, 1258, 1214)
    lstg.SetImageCenter("face-Marguerite-image-" .. 5, 1630, 1338)
end
function face_Marguerite.unload()
    for i = 1, 5 do
        local name_ = "face-Marguerite-image-" .. i
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

function face_Marguerite:ctor()
    ---@class face.Marguerite.image
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
    
    ---@type face.Marguerite.image[]
    self._image = {}
    
    -- 环状云
    self._cloud = {
        x = 0,
        y = 7.5,
        rot = 0,
        hscale = 0.4,
        vscale = 0.4,
        image = "face-Marguerite-image-" .. 5,
        color = 0xFFFFFFFF,
        blend = "",
    }
    table.insert(self._image, self._cloud)
    
    -- 十字架
    table.insert(self._image, {
        x = 0,
        y = -3.75,
        rot = 0,
        hscale = 0.4,
        vscale = 0.4,
        image = "face-Marguerite-image-" .. 4,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 光背动态
    self._back = {
        x = 7.5,
        y = 7.5,
        rot = 0,
        hscale = 0.4,
        vscale = 0.4,
        image = "face-Marguerite-image-" .. 3,
        color = 0xFFFFFFFF,
        blend = "",
    }
    table.insert(self._image, self._back)
    
    -- 闪电与刀光动态
    self._light = {
        x = 0,
        y = -20,
        rot = 0,
        hscale = 0.4,
        vscale = 0.4,
        image = "face-Marguerite-image-" .. 1,
        color = 0xFFFFFFFF,
        blend = "mul+add",
    }
    table.insert(self._image, self._light)
    
    -- 人物
    table.insert(self._image, {
        x = 30,
        y = -10,
        rot = 0,
        hscale = 0.5,
        vscale = 0.5,
        image = "face-Marguerite-image-" .. 2,
        color = 0xFFFFFFFF,
        blend = "",
    })
end
function face_Marguerite:update()
    -- 动态效果
    self._cloud.rot = self._cloud.rot + 0.016
    self._back.rot = self._back.rot - 0.02
    self._light.rot = 4 * lstg.sin(self.timer * 0.06)
    -- 计时器
    self.timer = self.timer + 1
end
function face_Marguerite:draw(x, y, rot, scale, alpha)
    scale = scale * 0.36 -- 在主菜单，因为坐标系不一样需要进一步缩放
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

--region boss的魔法阵（有更好的素材可替代
local magic_img = "new_magic"
local color_index = {
    1, 1, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 8, 9
}
local renderImg = EGGlib.RenderEffect.renderImg
local magic = Class(other_enemy)
function magic:init(x, y, hp, show_hpbar, drop, death_func, co1, co2)
    other_enemy.init(self,
            x, y, magic_img..color_index[co1], --x, y, img,
            hp, show_hpbar, --hp, show_hpbar,
            drop,
            true, --no_count
            death_func)
    self.img2 = magic_img..color_index[co2]
    self._color = Color(255, 255, 255, 255)
    self._blend = ""
end
function magic:frame()
    other_enemy.frame(self)
end
function magic:render()
    local x, y, blend, color, h, v = self.x, self.y, self._blend, self._color, self.hscale, self.vscale
    renderImg(self.img, x, y, self.timer, 1.5*h, 1.5*v, blend, color)
    renderImg(self.img2, x, y, -self.timer, 1*h, 1*v, blend, color)
end
--endregion

local light_tex = boss_name.."_light"

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s4_boss", --theme_music,
        stage4_background, --background,
        --资源载入函数
        function()
            --符卡背景
            for i = 1, 3 do
                LoadImageFromFile(scbg_imgs[i], path .. "scbg"..i..".png", true, 0, 0, false, 0)
            end
            --行走图
            LoadTexture(boss_name.."_BossWalkImage", path .. "BossWalkImage.png")--载入行走图资源
            --魔法阵
            LoadImageFromFile(boss_arua_img, path.."boss_arua.png")
            --金光
            LoadTexture(light_tex, path.."light.png")
            Add_bentlaser_texture(light_tex, light_tex) --添加至曲线激光
            --pic show
            _load_spellcard_effect()
        end,
        --行走图动作函数
        T.createWalkImage(
                boss_name.."_BossWalkImage", 180, 180, 5, --tex, u, v, n
        --normalMovementFunc,
                T.createNormalMovementFunc(
                        T.createActionTable({1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 8, 9, 10}), --normal
                        T.createActionTable({11, 12, 13, 14, 15, 16}, 4), --left
                        T.createActionTable({17, 18, 19, 20, 21, 22}, 4), --right
                        8, --cutFrame,
                        0.5  --size,
                ),
                {
                    --96f
                    {"cast", T.createSpecialActionFunc(
                            {23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 12)
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                },
        --spActionFuncTable,
                {
                    --96f
                    {"cast",
                     function(self)
                         self:setAction("cast", 96)
                     end},
                }
        ),
        --boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 100, 255, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                end,
                --scOpenEffect,
                function(self)
                    New(pic_show)
                    New(effect.spell_attack, 255, 255, 0)
                    --New(EGGlib.RenderEffect.BreakEffect, 0, 0, 'tree_leaf_white', 'Cherry_eff', 255, 255, 0)
                    --EGGlib.RenderEffect.createScOpenShowCircle("", 255, 255, 0, 20, 20, 20)
                    --effect.generalSpellShow(pic_show_img, 0.5, boss_arua_img, 218, 162, 193)
                    task.Wait(60) --模拟默认立绘演出90f
                    self.absorbAction(self, 60)
                end,
                --absorbEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 255, 0)
                    if t then task.Wait(t) end
                end,
                --breakEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 255, 0)
                    if t then task.Wait(t) end
                end,
                --absorbAction,
                function(self, t, x, y)
                    --self.cast("") --暂时没有2boss的蓄力动作
                    x, y = x or self.x, y or self.y
                    self.absorbEffect(self, t, x, y)
                end,
                --scBreakEffect
                function(self)
                    EGGlib.RenderEffect.scBreakEffect(self.x, self.y, 255, 255, 0, 'tree_leaf_white', 'Cherry_eff')
                end
        ),
        scbg, --scbg
        pic_show, --pic_show
        function(self)
            boss.class.changeAuraImg(self, boss_arua_img)
            --召唤魔法阵
            self.createMagic = function(x, y, hp, show_hpbar, drop, death_func, co1, co2)
                return New(magic, x, y, hp, show_hpbar, drop, death_func, co1, co2)
            end
        end
)
return BossRes
