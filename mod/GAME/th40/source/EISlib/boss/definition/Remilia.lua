-----------------------------------------------
---东方栖霞园 蕾米点图动作及特效
-----------------------------------------------

local T = EISlib.BossDefinition.Type
--导入其他包
local alphaChange = EGGlib.ObjectEvent.alphaChange --透明度变化事件
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local velchTask = EGGlib.ObjectEvent.velocityChangeTask

--行走图设置
local boss_name = "Remilia"  --以boss名来作为其相关素材的前缀
local path = "res/boss/"..boss_name.."/"
local pic_show_img1 = boss_name.."pic_show1"
local pic_show_img2 = boss_name.."pic_show2"
local ball_img = "ball_light1"
local boss_arua_img = boss_name.."boss_arua"
--资源载入写在这里，就不写boss定义里了
local function loadRes(res_boss_name, path)
    --符卡背景
    for i = 1, 3 do
        LoadImageFromFile(res_boss_name.."_scbg"..i, path .. "scbg"..i..".png", true, 0, 0, false, 0)
    end
    --行走图
    LoadTexture(res_boss_name.."BossWalkImage1", path .. "BossWalkImage1.png") --打伞的
    LoadTexture(res_boss_name.."BossWalkImage2", path .. "BossWalkImage2.png") --没打伞的

    do
        local sp_path = "res/performer/Remilia/"
        LoadImageFromFile(pic_show_img1, sp_path .. "perplex.png", true, 0, 0, false, 0)
        LoadImageFromFile(pic_show_img2, sp_path .. "spellcard.png", true, 0, 0, false, 0)
    end

    --魔法阵
    LoadImageFromFile(boss_arua_img, path.."boss_arua.png")
end

--region 符卡背景定义
local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.addLayer(self, boss_name.."_scbg3", true, 0, 0, 0, 0, 0.75, 0, "mul+rev", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, boss_name.."_scbg2", false, 0, 144, 0, 0, 0, 0, "", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, boss_name.."_scbg1", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
end
--endregion

--region 符卡立绘
local ball = Class(object)
function ball:init(x, y)
    local size = ran:Float(0.5, 0.75)
    self.hscale, self.vscale = size, size
    self.img = ball_img
    self.layer = LAYER_ENEMY_BULLET + 5
    self.omiga = ran:Float(1, 6)
    self.x, self.y = x, y
    robject.set_color(self, "mul+add", 0, 255, 255, 255)
    velchTask(self, ran:Float(1, 10), 1, ran:Float(-210, 30), 40, 10)
    self.rot = ran:Float(0, 360)
    --透明度变化
    task.New(self, function()
        alphaChange(self, 0, 255, 30)
        task.Wait(ran:Int(0, 45))
        alphaChange(self, 255, 0, 30)
    end)
end
function ball:frame()
    task.Do(self)
end
function ball:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
local pic_show1 = Class(object)
function pic_show1:init()
    self.img = pic_show_img1
    self.layer = LAYER_ENEMY_BULLET + 5.5
    self.x, self.y = 50, 150
    local size = 0.5
    self.hscale, self.vscale = size, size
    robject.set_color(self, "", 0, 255, 255, 255)
    alphaChangeTask(self, 0, 255, 60)
    for _ = 1, 90 do
        New(ball, 50, 150)
    end
    task.New(self, function()
        --圈
        EGGlib.RenderEffect.createScOpenShowCircle("", 120, 40, 40, 30, 30, 30)
        --闪虚影
        EGGlib.RenderEffect.createBossPicShowTrail(self, 1,--dlayer
                9, --maxnum
                3, --frame
                self.img, --img,
                1, --size,
                30, --times,
                240, 100, 100 --r, g, b
        )
        --立绘移动
        task.MoveTo(self, 50, 0, 60, MOVE_DECEL)
        self.vy = -0.1
        task.Wait(45)
        alphaChangeTask(self, 255, 0, 45)
        task.MoveTo(self, 50, -100, 45, MOVE_ACCEL)
        Del(self)
    end)
end
function pic_show1:frame()
    task.Do(self)
end
function pic_show1:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

local pic_show2 = Class(object)
function pic_show2:init()
    self.img = pic_show_img2
    self.layer = LAYER_ENEMY_BULLET + 5.5
    self.x, self.y = 100, 150
    local size = 0.5
    self.hscale, self.vscale = size, size
    robject.set_color(self, "", 0, 255, 255, 255)
    alphaChangeTask(self, 0, 255, 60)
    for _ = 1, 90 do
        New(ball, 50, 150)
    end
    task.New(self, function()
        --圈
        EGGlib.RenderEffect.createScOpenShowCircle("", 120, 40, 40, 30, 30, 30)
        --闪虚影
        EGGlib.RenderEffect.createBossPicShowTrail(self, 1,--dlayer
                9, --maxnum
                3, --frame
                self.img, --img,
                1, --size,
                30, --times,
                240, 100, 100 --r, g, b
        )
        --立绘移动
        task.MoveTo(self, -50, 0, 60, MOVE_DECEL)
        self.vx, self.vy = -0.1, -0.1
        task.Wait(45)
        alphaChangeTask(self, 255, 0, 45)
        task.MoveTo(self, -200, -100, 45, MOVE_ACCEL)
        Del(self)
    end)
end
function pic_show2:frame()
    task.Do(self)
end
function pic_show2:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

local pic_show = pic_show1 --default
--endregion

---@class face.Remilia : luaclass
local face_Remilia = luaclass("face.Remilia")
bossface.Remilia = face_Remilia

function face_Remilia.load()
    local name_ = "face-Remilia-image-1"
    lstg.LoadTexture(name_, "res/performer/Remilia/spellcard.png")
    local w_, h_ = lstg.GetTextureSize(name_)
    lstg.LoadImage(name_, name_, 0, 0, w_, h_)
    lstg.SetImageCenter(name_, 1190, 820)
end
function face_Remilia.unload()
    local name_ = "face-Remilia-image-1"
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

function face_Remilia:ctor() end
function face_Remilia:update() end
function face_Remilia:draw(x, y, rot, scale, alpha)
    scale = scale * 0.20 -- 在主菜单，因为坐标系不一样需要进一步缩放
    local color_ = lstg.Color(alpha * 255, 255, 255, 255)
    lstg.SetImageState("face-Remilia-image-1", "", color_)
    lstg.Render("face-Remilia-image-1", x, y, rot, scale)
end

--region 特殊的使魔妖精
local fairy = Class(enemy)
function fairy:init(x, y)
    enemy.init(self,
            x, y, --x, y
            EISlib.Enemy.Style.FAIRY_SMALL_5_YELLOW, --style
            99999, --hp
            false, --show_hpbar
            {0, 30}, --blue_num
            true --no_count
    )
end
--生成仆从妖精事件
local function spawn_fairy(self)
    local servant = New(fairy, -15, 144 + 120) --生成仆从妖精
    self.servant = servant
    task.New(self, function()
        --减速下降并回到主人身边，准备拿伞
        local v, dv = -2, 2/120
        for _ = 1, 120 do
            if IsValid(servant) then
                servant.y = servant.y + v
            end
            v = v + dv
            task.Wait(1)
        end
        self.throwUmbrella(self) --扔雨伞
        servant._stylemgr:setStyle(EISlib.Enemy.Style.FAIRY_SMALL_5_SP) --改成拿伞的
        --task.Wait() 可能要等待一段时间，做出递接伞的动作
        local dx, dy = -15/30, 30/30
        for _ = 1, 30 do
            if IsValid(servant) then
                servant.x, servant.y = servant.x + dx, servant.y + dy
            end
            task.Wait(1)
        end
        self.layer = LAYER_ENEMY - 1
        task.New(servant, function()
            servant.timer = 0
            while IsValid(self) do
                servant.x, servant.y = self.x - 30, self.y + 30 + 5*sin(servant.timer)
                task.Wait(1)
            end
            Kill(servant)
        end)
    end)
    return servant
end

--endregion
--region 行走图
local WalkImage1 =  T.createWalkImage(
        boss_name.."BossWalkImage1", 240, 240, 6, --tex, u, v, n
        --normalMovementFunc,
        T.createNormalMovementFunc(
                T.createActionTable({1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9}), --normal
                T.createActionTable({10, 11, 12, 13, 14}, 4), --left
                T.createActionTable({15, 16, 17, 18, 19}, 4), --right
                8, --cutFrame,
                0.5  --size,
        ),
        {
            --把伞丢掉
            {"release_umbrella", T.createSpecialActionFunc(
                    {20, 21, 22, 23}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 4) --最大为4，也就是上表中的23号图
                        return n
                    end, --func,
                    8, 0.5)}, --cutFrame, size
        },
        --spActionFuncTable,
        {
            {"release_umbrella",
             function(self, isWait)
                 self:setAction("release_umbrella", 32)
                 if isWait then task.Wait(24) end
             end}
        })

--第二套 没有伞的动作
local WalkImage2 =  T.createWalkImage(
        boss_name.."BossWalkImage2", 240, 240, 6, --tex, u, v, n
        --normalMovementFunc,
        T.createNormalMovementFunc(
                T.createActionTable({1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9}, 3), --normal
                T.createActionTable({10, 11, 12, 13, 14}, 4), --left
                T.createActionTable({15, 16, 17, 18, 19}, 4), --right
                8, --cutFrame,
                0.5  --size,
        ),
        {
            --掷神枪
            {"laser_attack", T.createSpecialActionFunc(
                    {20, 21, 22, 23, 24, 25, 26, 27, 28, 29}, --action_table,
                    function(wisys, self, actionCount, actionCountMax, cutFrame)
                        local n = int(actionCount/cutFrame) + 1
                        n = min(n, 10) --最大为10，也就是上表中的29号图
                        return n
                    end, --func,
                    8, 0.5)}, --cutFrame, size
        },
        --spActionFuncTable,
        {
            {"laser_attack",
             function(self, isWait)
                 self:setAction("laser_attack", 80)
                 if isWait then task.Wait(80) end
             end}
        })
--endregion

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s1_boss", --theme_music,
        stage1_background, --background,
        --资源载入函数
        function()
            loadRes(boss_name, path)
        end,
        --行走图动作函数
        WalkImage1,
        --boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 100, 100, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                    -- 魔法阵减色效果
                    self.fxa = 255
                    self.fxr = 192
                    self.fxg = 160
                    self.fxb = 64
                end,
        --scOpenEffect,
                function(self)
                    local r, g, b = 255, 0, 0
                    EGGlib.RenderEffect.createScOpenShowCircle("", 255, 150, 150, 30, 30, 30)
                    New(effect.lattice, r, g, b)
                    New(effect.diamond, r, g, b)
                    New(effect.diamondstroke, r, g, b)
                    New(effect.magic, boss_arua_img)
                    New(pic_show)
                    New(effect.spell_attack, r, g, b)
                    tasker(function()
                        task.Wait(30)
                        for _ = 1, 6 do
                            for _ = 1, 2 do
                                New(effect.diamondstroke, r, g, b)
                                task.Wait(3)
                            end
                            task.Wait(10)
                        end
                    end)
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
                    --self.cast("revolve")
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
            system.spellcard.auxiliary.setChainBonusBase(system.spellcard.BONUS_CHAIN_BASE_S1) -- 修改为2倍
            boss.class.changeAuraImg(self, boss_arua_img)
            --改变开符立绘展开方式
            self.changePicShowMode = function(mode)
                if mode == 2 then
                    pic_show = pic_show2
                else
                    pic_show = pic_show1
                end
            end
            self.changePicShowMode(1) --默认使用1立绘
            --雨伞递给妖精
            self.throwUmbrella = function()
                self.cast("release_umbrella", true) --等待
                T.changeWalkImage(self, WalkImage2) --行走图切换
                self.changePicShowMode(2) --使用2立绘
            end
            --召唤拿伞妖精
            self.spawnFairyAndChangeWalkImage = spawn_fairy
        end--sp func
)
return BossRes
