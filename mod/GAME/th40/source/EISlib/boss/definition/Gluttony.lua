-----------------------------------------------
---东方栖霞园 ex面boss点图动作及特效
-----------------------------------------------

local T = EISlib.BossDefinition.Type
local Bclass = {}
EISlib.BossDefinition.Gluttony = Bclass
--导入其他包的方法
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local defaultRenderAni = EGGlib.RenderEffect.defaultRenderAni
local newSimpleClass = EGGlib.Class.newSimpleClass
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange

--行走图设置
local boss_name = "Gluttony"  --以boss名来作为其相关素材的前缀
local path = "res/boss/Gluttony/"

--Image和Animation声明
--立绘
local pic_show_img = boss_name.."pic_show"
--使魔
local red_servant_img1 = boss_name.."_red_servant1"
local red_servant_img2 = boss_name.."_red_servant2"
local white_servant_img1 = boss_name.."_white_servant1"
local white_servant_img2 = boss_name.."_white_servant2"
local red_servant_ani1 = boss_name.."_red_servant1"
local red_servant_ani2 = boss_name.."_red_servant2"
local purple_servant_img1 = boss_name.."_purple_servant1"
local purple_servant_img2 = boss_name.."_purple_servant2"
local pink_servant_img1 = boss_name.."_pink_servant1"
local pink_servant_img2 = boss_name.."_pink_servant2"
local purple_servant_ani1 = boss_name.."_purple_servant1"
local purple_servant_ani2 = boss_name.."_purple_servant2"
--使魔尾巴
local servant_trail_tex = boss_name.."servant_trail"
Bclass.servant_trail_tex = servant_trail_tex
--毛
local fur_img_list = {}
for i = 1, 5 do
    fur_img_list[i] = boss_name.."_fur"..i
end
Bclass.fur_img_list = fur_img_list
--彩虹屁
local rainbow_tex = boss_name.."_rainbow"
Bclass.rainbow_tex = rainbow_tex
--虫洞
Bclass.cave_ani = boss_name.."_cave"

--符卡背景
local scbg_imgs = {}
for i = 1, 7 do
    scbg_imgs[i] = boss_name.."_scbg"..i
end

local boss_arua_img = boss_name.."boss_arua"

local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.addLayer(self, scbg_imgs[7],
            false, --is tile
            0, 0, 0, --x, y, rot
            0, 0, -0.25, "mul+rev", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[6],
            true, --is tile
            0, 0, 0, --x, y, rot
            1, 0, 0, "mul+rev", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[5],
            false, --is tile
            0, 0, 0, --x, y, rot
            0, 0, 0, "mul+rev", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[4],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, 1, 0, "mul+add", --vx, vy, omiga, blend
            0.5, 0.5, --hscale, vscale
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )

    _spellcard_background.addLayer(self, scbg_imgs[3],
            false, --is tile
            0, 0, 0, --x, y, rot
            0, 0, 0, "", --vx, vy, omiga, blend
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

    _spellcard_background.addLayer(self, scbg_imgs[1],
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
end

--region 使魔

--非帧动画
Bclass.servant1 = Class(other_enemy)
do
    local servant_type_list = {}
    servant_type_list[COLOR_RED] = red_servant_img1
    servant_type_list[COLOR_DEEP_RED] = red_servant_img2
    servant_type_list[COLOR_GRAY] = white_servant_img1
    servant_type_list[COLOR_DEEP_GRAY] = white_servant_img2
    servant_type_list[COLOR_PURPLE] = purple_servant_img1
    servant_type_list[COLOR_DEEP_PURPLE] = purple_servant_img2
    servant_type_list[COLOR_BLUE] = pink_servant_img1
    servant_type_list[COLOR_DEEP_BLUE] = pink_servant_img2
    function Bclass.servant1:init(x, y, hp, show_hpbar, drop, death_func, color)
        other_enemy.init(self,
                x, y, servant_type_list[color], --x, y, img,
                hp, show_hpbar, --hp, show_hpbar,
                drop,
                true, --no_count
                death_func)
        robject.set_color(self, "", 255, 255, 255, 255)
        self.a, self.b = 8, 8
    end
    function Bclass.servant1:frame()
        other_enemy.frame(self)
    end
    function Bclass.servant1:render()
        defaultRenderImg(self)
    end
end
--帧动画
Bclass.servant2 = Class(Bclass.servant1)
do
    local servant_type_list = {}
    servant_type_list[COLOR_RED] = red_servant_ani1
    servant_type_list[COLOR_DEEP_RED] = red_servant_ani2
    servant_type_list[COLOR_PURPLE] = purple_servant_ani1
    servant_type_list[COLOR_DEEP_PURPLE] = purple_servant_ani2
    function Bclass.servant2:init(x, y, hp, show_hpbar, drop, death_func, color)
        other_enemy.init(self,
                x, y, servant_type_list[color], --x, y, img,
                hp, show_hpbar, --hp, show_hpbar,
                drop,
                true, --no_count
                death_func)
        robject.set_color(self, "", 255, 255, 255, 255)
        self.a, self.b = 8, 8
    end
    function Bclass.servant2:frame()
        other_enemy.frame(self)
    end
    function Bclass.servant2:render()
        defaultRenderAni(self)
    end
end
--endregion

--region 立绘演出
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
    local s = 0.7
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
        obj.x, obj.y = 0, -384
        obj.hscale, obj.vscale = 0.8, 0.8
        task.New(self, function()
            local t = 15
            local d_a = 255/t
            for i = 1, t do
                obj._a = obj._a + d_a
                task.Wait(1)
            end
        end)
        accDecMoveToPoint(obj, 0, 0, 1, 0, 29) --30帧
        obj.vx, obj.vy = 0, 0.1
        task.Wait(60)
        alphaAndSizeChange(obj, -255, 0, 30)
    end)
    --红色环带动态
    task.New(self, function()
        local obj = list[1]
        obj.x, obj.y = 0, 100
        obj._a = 0
        obj.hscale, obj.vscale = 0.5*s, 0.5*s
        task.New(self, function()
            local t = 30
            local ds = s/t
            local d_ds = -ds/t
            for _ = 1, t do
                ds = ds + d_ds
                obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                task.Wait(1)
            end
        end)
        --角度变化
        obj.rot = 90
        task.New(self, function()
            local t = 30
            local drot = -2*obj.rot/t
            local d_drot = -drot/t
            for _ = 1, t do
                drot = drot + d_drot
                obj.rot = obj.rot + drot - 0.25
                task.Wait(1)
            end
            t = 90
            for _ = 1, t do
                obj.rot = obj.rot - 0.25
                task.Wait(1)
            end
        end)
        alphaAndSizeChange(obj, 255, 0, 30)
        alphaAndSizeChange(obj, 0, 0.05*s, 60)
        alphaAndSizeChange(obj, -255, 0.025*s, 30)
    end)
    --后面那团红雾动态
    task.New(self, function()
        local t = 120
        local obj = list[3]
        obj.hscale, obj.vscale = 0.5*s, 0.5*s
        obj.x, obj.y = 0, 0
        obj.vx, obj.vy = 0/t, -10/t
        obj._a = 0
        alphaAndSizeChange(obj, 255, 0.5*s, 30)
        alphaAndSizeChange(obj, 255, 0.05*s, 30)
        alphaAndSizeChange(obj, 255, 0.05*s, 30)
        alphaAndSizeChange(obj, -200, 0.025*s, 30)
    end)
    --触手
    task.New(self, function()
        local t = 120
        local obj = list[4]
        obj.x, obj.y = 0, 0
        obj.hscale, obj.vscale = 0.5*s, 0.5*s
        obj.vx, obj.vy = 0/t, 30/t --往上走
        obj._a = 0
        alphaAndSizeChange(obj, 255, 0.5*s, 30)
        alphaAndSizeChange(obj, 0, 0.15*s, 60)
        alphaAndSizeChange(obj, -255, 0.075, 30)
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

---@class face.Kleine : luaclass
local face_Kleine = luaclass("face.Kleine")
bossface.Kleine = face_Kleine

function face_Kleine.load()
    for i = 1, 5 do
        local name_ = "face-Kleine-image-" .. i
        lstg.LoadTexture(name_, "res/performer/Kleine/spellcard/" .. i .. ".png")
        local w_, h_ = lstg.GetTextureSize(name_)
        lstg.LoadImage(name_, name_, 0, 0, w_, h_)
    end
end
function face_Kleine.unload()
    for i = 1, 5 do
        local name_ = "face-Kleine-image-" .. i
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

function face_Kleine:ctor()
    ---@class face.Kleine.image
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
    
    ---@type face.Kleine.image[]
    self._image = {}
    
    -- 旋云
    table.insert(self._image, {
        x = 80,
        y = 240,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Kleine-image-" .. 5,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 底云
    table.insert(self._image, {
        x = 80,
        y = -280,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Kleine-image-" .. 3,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 触手
    table.insert(self._image, {
        x = 0,
        y = -440,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Kleine-image-" .. 4,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 人物立绘
    table.insert(self._image, {
        x = 0,
        y = 0,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Kleine-image-" .. 2,
        color = 0xFFFFFFFF,
        blend = "",
    })
    
    -- 红蝶
    table.insert(self._image, {
        x = 120,
        y = 360,
        rot = 0,
        hscale = 1,
        vscale = 1,
        image = "face-Kleine-image-" .. 1,
        color = 0xFFFFFFFF,
        blend = "",
    })
end
function face_Kleine:update()
    -- 计时器
    self.timer = self.timer + 1
end
function face_Kleine:draw(x, y, rot, scale, alpha)
    scale = scale * 0.24
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

--region 行走图
--第一套，猫形态
local WalkImage1 =  T.createWalkImage(
        boss_name.."_BossWalkImage1", 120, 120, 5, --tex, u, v, n
--normalMovementFunc,
        T.createNormalMovementFunc(
                T.createActionTable({1, 2, 3, 4, 5, 6, 7}), --normal
                nil, --left
                T.createActionTable({11, 12, 13, 14}, 4), --right
                8, --cutFrame,
                0.5  --size,
        ),
        {},
--spActionFuncTable,
        {})

--第二套，人形态（没抱猫
local WalkImage2 =  T.createWalkImage(
        boss_name.."_BossWalkImage2", 200, 200, 5, --tex, u, v, n
--normalMovementFunc,
        T.createNormalMovementFunc(
                T.createActionTable({1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 10, 11, 12}), --normal
                T.createActionTable({13, 14, 15, 16, 17, 18}, 4), --left
                T.createActionTable({19, 20, 21, 22, 23, 24}, 4), --right
                8, --cutFrame,
                0.5  --size,
        ),
        {},
--spActionFuncTable,
        {})

--第三套，人形态（抱猫
local WalkImage3 =  T.createWalkImage(
        boss_name.."_BossWalkImage3", 200, 200, 5, --tex, u, v, n
--normalMovementFunc,
        T.createNormalMovementFunc(
                T.createActionTable({1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 10, 11, 12}), --normal
                T.createActionTable({13, 14, 15, 16, 17, 18}, 4), --left
                T.createActionTable({19, 20, 21, 22, 23, 24}, 4), --right
                8, --cutFrame,
                0.5  --size,
        ),
        {
            --把猫抓回来
            {"grab", T.createSpecialActionFunc(
                    {26, 27, 28, 29, 30}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 5)
                        return n
                    end, --func,
                    8, 0.5)}, --cutFrame, size
            --把猫放下
            {"put_down", T.createSpecialActionFunc(
                    {30, 29, 28, 27, 26}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 5)
                        return n
                    end, --func,
                    8, 0.5)}, --cutFrame, size
        },
--spActionFuncTable,
        {
            --把猫抓回来
            {"grab",
             function(self)
                 self:setAction("grab", 40)
             end},
            --把猫放下
            {"put_down",
             function(self)
                 self:setAction("put_down", 40)
             end},
        })

--endregion

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s7_boss", --theme_music,
        stage7_background, --background,
        --资源载入函数
        function()
            --符卡背景
            for i = 1, 7 do
                LoadImageFromFile(scbg_imgs[i], path.."scbg"..i..".png", true, 0, 0, false, 0)
            end
            --行走图
            LoadTexture(boss_name.."_BossWalkImage1", path .. "BossWalkImage1.png")--载入行走图资源
            LoadTexture(boss_name.."_BossWalkImage2", path .. "BossWalkImage2.png")--载入行走图资源
            LoadTexture(boss_name.."_BossWalkImage3", path .. "BossWalkImage3.png")--载入行走图资源
            --立绘
            --LoadImageFromFile(pic_show_img, path .. "pic_show.png", true, 0, 0, false, 0)

            --彩虹屁
            LoadTexture(rainbow_tex, path.."rainbow.png")
            Add_bentlaser_texture(rainbow_tex, rainbow_tex) --添加至曲线激光

            --使魔
            local servant_tex = boss_name.."_servant"
            LoadTexture(servant_tex, path.."servant.png")
            LoadAnimation(red_servant_ani1, servant_tex, 0, 0, 128, 128, 6, 1, 8)
            LoadAnimation(red_servant_ani2, servant_tex, 0, 128, 128, 128, 6, 1, 8)
            LoadAnimation(purple_servant_ani1, servant_tex, 0, 384, 128, 128, 6, 1, 8)
            LoadAnimation(purple_servant_ani2, servant_tex, 0, 512, 128, 128, 6, 1, 8)
            LoadImage(red_servant_img1, servant_tex, 0, 256, 128, 128)
            LoadImage(red_servant_img2, servant_tex, 128, 256, 128, 128)
            LoadImage(white_servant_img1, servant_tex, 256, 256, 128, 128)
            LoadImage(white_servant_img2, servant_tex, 384, 256, 128, 128)
            LoadImage(purple_servant_img1, servant_tex, 0, 640, 128, 128)
            LoadImage(purple_servant_img2, servant_tex, 128, 640, 128, 128)
            LoadImage(pink_servant_img1, servant_tex, 256, 640, 128, 128)
            LoadImage(pink_servant_img2, servant_tex, 384, 640, 128, 128)
            --使魔尾巴
            LoadTexture(servant_trail_tex, path.."servant_trail.png")
            Add_bentlaser_texture(servant_trail_tex, servant_trail_tex) --添加至曲线激光

            --猫毛
            local fur_tex = boss_name.."_fur"
            LoadTexture(fur_tex, path.."fur.png")
            for i = 1, 5 do
                LoadImage(fur_img_list[i], fur_tex, 64*(i-1), 0, 64, 64)
            end

            --pic show
            do
                local path = path.."pic_show/"
                for i = 1, 5 do
                    LoadImageFromFile(boss_name.."pic_show_"..i, "res/performer/Kleine/spellcard/"..i..".png")
                end
            end

            --黑洞
            LoadAniFromFile(Bclass.cave_ani, path.."cave.png", false, 4, 3, 4)

            --魔法阵
            LoadImageFromFile(boss_arua_img, path.."boss_arua.png")
            
            -- 雾气效果（有一张解密时符用到）
            LoadImageFromFile("Lycaropiafog", "res/boss/Lycaropia/fog.png")
        end,
        --行走图动作函数
        WalkImage3,
        --boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 100, 255, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                end,
                --scOpenEffect,
                function(self)
                    --New(pic_show)
                    New(pic_show)
                    New(effect.spell_attack, 255, 0, 0)
                    New(EGGlib.RenderEffect.BreakEffect, 0, 0, 'tree_leaf_white', 'Cherry_eff', 255, 0, 0)
                    task.Wait(60) --模拟默认立绘演出90f
                    self.absorbAction(self, 60)
                end,
                --absorbEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 100, 100)
                    if t then task.Wait(t) end
                end,
                --breakEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 100, 100)
                    if t then task.Wait(t) end
                end,
                --absorbAction,
                function(self, t, x, y)
                    --self.cast("revolve_staff")
                    x, y = x or self.x, y or self.y
                    self.absorbEffect(self, t, x, y)
                end,
                --scBreakEffect
                function(self)
                    EGGlib.RenderEffect.scBreakEffect(self.x, self.y, 255, 100, 100, 'tree_leaf_white', 'Cherry_eff')
                end
        ),
        scbg, --scbg
        pic_show, --pic_show
        function(self)
            boss.class.changeAuraImg(self, boss_arua_img)
            --以下两个状态转换，需要在task环境下执行
            self.changeToHumanWithCat = function()
                T.changeWalkImage(self, WalkImage3)
                self.cast("grab")
                task.Wait(40)
            end
            self.changeToHuman = function()
                T.changeWalkImage(self, WalkImage3)
                self.cast("put_down")
                task.Wait(31)
                T.changeWalkImage(self, WalkImage2)
            end
            --设置特殊爆炸
            boss.setBossExplode(self,
                    function(boss)
                        --player.dialog = true
                        lstg.var.timeslow = 2
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
            --[[self.changeToCat = function()
                T.changeWalkImage(self, WalkImage1)
            end]]
        end
)
return BossRes
