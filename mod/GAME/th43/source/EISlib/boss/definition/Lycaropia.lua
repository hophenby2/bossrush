-----------------------------------------------
---东方栖霞园 五面boss点图动作及特效
-----------------------------------------------

local T = EISlib.BossDefinition.Type
local newSimpleClass = EGGlib.Class.newSimpleClass
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local renderImg = EGGlib.RenderEffect.renderImg
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange

--行走图设置
local boss_name = "Lycaropia"  --以boss名来作为其相关素材的前缀
local path = "res/boss/"..boss_name.."/"

local boss_arua_img = boss_name.."boss_arua"

--符卡背景
local scbg_imgs = {}
for i = 1, 3 do
    scbg_imgs[i] = boss_name.."_scbg"..i
end
local cleft_imgs = {}
for i = 1, 21 do
    cleft_imgs[i] = boss_name.."cleft"..(i - 1)
end

local fog_img = boss_name.."fog"

local wolf_eff_purple_ani = boss_name.."wolf_eff_purple_ani"
local wolf_eff_red_ani = boss_name.."wolf_eff_red_ani"

local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.addLayer(self, scbg_imgs[3],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, 1, 0, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
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
            0, -1, 0, "mul+rev", --vx, vy, omiga, blend
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
            -1, 0, 0, "", --vx, vy, omiga, blend
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

--立绘演出
local pic_show_img = boss_name.."pic_show"

local pic_show = Class(object)
function pic_show:init()
    self.img = pic_show_img
    self.layer = LAYER_BG + 3
    self.x, self.y = 100, 150
    local size = 0.4
    self.hscale, self.vscale = size, size
    robject.set_color(self, "", 0, 255, 255, 255)
    alphaChangeTask(self, 0, 255, 60)
    task.New(self, function()
        --圈
        EGGlib.RenderEffect.createScOpenShowCircle("", 175, 255, 255, 30, 30, 30)
        --闪虚影
        EGGlib.RenderEffect.createBossPicShowTrail(self, 1,--dlayer
                9, --maxnum
                3, --frame
                self.img, --img,
                1, --size,
                30, --times,
                175, 255, 255 --r, g, b
        )
        --立绘移动
        task.MoveTo(self, -50, 0, 60, MOVE_DECEL)
        alphaChangeTask(self, 255, 0, 45)
        task.MoveTo(self, -200, -50, 45, MOVE_ACCEL)
        Del(self)
    end)
end
function pic_show:frame()
    task.Do(self)
end
function pic_show:render()
    defaultRenderImg(self)
end

--region 五boss的光背
local head_img = boss_name.."head"
local hand_img = boss_name.."hand"
local head, hand = newSimpleClass(), newSimpleClass()
local flash = Class(object)
--光背控制器
local backlight = Class(object)
do
    local this = backlight
    function this:init(boss)
        self.layer = LAYER_ENEMY - 1
        self.obj_list = {}
        self.bound = false
        self.boss = boss
        self.x, self.y = boss.x, boss.y
        self.ddx, self.ddy = 0, 0
        self.head = head.new(self.x, self.y)
        self.left_hand = hand.new(self.x - 120, self.y - 50, true)
        self.right_hand = hand.new(self.x + 120, self.y - 50, false)
        table.insert(self.obj_list, self.head)
        table.insert(self.obj_list, self.left_hand)
        table.insert(self.obj_list, self.right_hand)
        this.forEach(self, function(k, obj)
            obj:appear() --调用出现动画效果
        end)
        self.isDel = false
    end
    function this:frame()
        task.Do(self)
        local boss = self.boss
        if IsValid(boss) then --跟随
            self.ddx, self.ddy = boss.x - self.x, boss.y - self.y
            self.x, self.y = boss.x, boss.y
            --子部件跟随
            this.forEach(self, function(k, obj)
                obj.x, obj.y = obj.x + self.ddx, obj.y + self.ddy
                obj:update()
            end)
        else
            this.destructor(self)
        end
    end
    function this:render()
        this.forEach(self, function(k, obj)
            obj:draw()
        end)
    end
    function this:forEach(func)
        for k, obj in pairs(self.obj_list) do
            if obj:isValid() then
                func(k, obj)
            else
                table.remove(self.obj_list, k)
            end
        end
    end
    function this:destructor()
        --仅首次有效
        if not self.isDel then
            self.isDel = true
            this.forEach(self, function(k, obj)
                --调用解构方法
                obj:destructor()
            end)
        else --已经激活，开始判断其它组件是否已结束生命周期
            if #self.obj_list > 0 then
                this.forEach(self, function(k, obj)
                    obj.x, obj.y = obj.x + self.dx, obj.y + self.dy
                    obj:update()
                end)
            else
                Del(self) --回收自己
            end
        end
    end
end

--头
do
    local this = head
    function this.constructor(self, x, y)
        self.x, self.y = x, y
        self.rot = 0
        self.hscale, self.vscale = 1, 1
        self.a, self.b = 16, 16
        self.img = head_img
        robject.set_color(self, "", 255, 255, 255, 255)
        self.isDel = false
        self.timer = 0
        task.New(self, function()
            while true do
                task.Wait(60)
                New(flash, self.x, self.y, head_img)
            end
        end)
    end
    function this.update(self)
        task.Do(self)
        self.timer = self.timer + 3
    end
    function this.draw(self)
        --defaultRenderImg(self)
        local dy = -5*sin(self.timer)
        local r = (0.85 + 0.15*sin(self.timer))
        renderImg(self.img, self.x, self.y + dy, self.rot, self.hscale, self.vscale, self._blend, Color(self._a*r, self._r, self._g, self._b))
    end
    function this.isValid(self)
        return not self.isDel
    end
    function this.appear(self)
        setSize(self, 0.1, 0.1)
        spSizeAndColliChangeTask(self, 0.65, 60, 120)
        alphaChangeTask(self, 0, 200, 30)
    end
    function this.destructor(self)
        task.New(self, function()
            alphaAndSizeChange(self, -200, -0.75, 60)
            self.isDel = true
        end)
    end
end

--手
do
    local this = hand
    function this.constructor(self, x, y, isLeft)
        self.x, self.y = x, y
        self.rot = 0
        local u = 1
        if isLeft then
            u = -u
        end
        self.hscale, self.vscale = u, 1
        self.a, self.b = 16, 16
        self.img = hand_img
        robject.set_color(self, "", 255, 255, 255, 255)
        self.isDel = false
        self.timer = 0
        task.New(self, function()
            while true do
                task.Wait(60)
                New(flash, self.x, self.y, hand_img, isLeft)
            end
        end)
    end
    function this.update(self)
        task.Do(self)
        self.timer = self.timer + 3
    end
    function this.draw(self)
        --defaultRenderImg(self)
        local dy = 5*sin(self.timer)
        local r = (0.85 + 0.15*sin(self.timer))
        renderImg(self.img, self.x, self.y + dy, self.rot, self.hscale, self.vscale, self._blend, Color(self._a*r, self._r, self._g, self._b))
    end
    function this.isValid(self)
        return not self.isDel
    end
    function this.appear(self)
        local u = sign(self.hscale)
        setSize(self, 0.1*u, 0.1)
        spSizeAndColliChangeTask(self, 0.65, 60, 120)
        alphaChangeTask(self, 0, 200, 30)
    end
    function this.destructor(self)
        task.New(self, function()
            alphaAndSizeChange(self, -200, -0.75, 60)
            self.isDel = true
        end)
    end
end

--光背闪光
do
    local this = flash
    function this:init(x, y, img, isLeft)
        self.layer = LAYER_ENEMY - 1
        self.x, self.y = x, y
        self.img = img
        local u = 1
        if isLeft then
            u = -u
        end
        setSize(self, 0.75*u, 0.75)
        robject.set_color(self, "mul+add", 100, 255, 255, 255)
        task.New(self, function()
            alphaAndSizeChange(self, -self._a, 0.75, 30)
            Del(self)
        end)
    end
    function this:frame()
        task.Do(self)
    end
    function this:render()
        defaultRenderImg(self)
    end
end
--endregion

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s5_boss", --theme_music,
        stage5_background, --background,
        --资源载入函数
        function()
            --符卡背景
            for i = 1, 3 do
                LoadImageFromFile(scbg_imgs[i], path .. "scbg"..i..".png", true, 0, 0, false, 0)
            end
            --行走图
            LoadTexture(boss_name.."_BossWalkImage", path .. "BossWalkImage.png")--载入行走图资源
            --立绘
            do
                local sp_path = "res/performer/Hearn/"
                LoadImageFromFile(pic_show_img, sp_path .. "normal.png", true, 0, 0, false, 0)
            end
            for i = 0, 20 do
                LoadImageFromFile(cleft_imgs[i + 1], path .. "cleft/"..i..".png")
            end
            LoadImageFromFile(fog_img, path.."fog.png")
            --狼头
            LoadTexture("wolf_eff", path.."wolf_eff.png")
            LoadAnimation(wolf_eff_purple_ani, "wolf_eff", 0, 0, 250, 148, 1, 6, 4)
            LoadAnimation(wolf_eff_red_ani, "wolf_eff", 250, 0, 250, 148, 1, 6, 4)
            --魔法阵
            LoadImageFromFile(boss_arua_img, path.."boss_arua.png")
            --彩虹屁
            LoadTexture("Gluttony_rainbow", "res/boss/Gluttony/rainbow.png")
            Add_bentlaser_texture("Gluttony_rainbow", "Gluttony_rainbow") --添加至曲线激光
            --光背
            do
                local sp_path = path.."backlight/"
                LoadImageFromFile(head_img, sp_path.."head.png")
                LoadImageFromFile(hand_img, sp_path.."hand.png")
            end
        end,
        --行走图动作函数
        T.createWalkImage(
                boss_name.."_BossWalkImage", 240, 240, 6, --tex, u, v, n
        --normalMovementFunc,
                T.createNormalMovementFunc(
                        T.createActionTable({1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9}), --normal
                        T.createActionTable({25, 26, 27, 28, 29, 30, 31}, 4), --left
                        T.createActionTable({37, 38, 39, 40, 41, 42, 43}, 4), --right
                        8, --cutFrame,
                        0.5  --size,
                ),
                {
                    --站立示威
                    {"absorb", T.createSpecialActionFunc(
                            {32, 33, 34, 35, 36}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                if n > 1 then
                                    n = 2 + (n - 2)%4
                                end
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                    --普通出刀动作
                    {"cast1", T.createSpecialActionFunc(
                            {13, 14, 15, 16, 17, 18, 19, 20, 21, 22}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 10)
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                    --快速出刀动作（减去第五帧
                    {"cast2", T.createSpecialActionFunc(
                            {13, 14, 15, 16, 18, 19, 20, 21, 22}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 9)
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                    --快速出刀但不旋转动作
                    {"cast3", T.createSpecialActionFunc(
                            {14, 15, 16, 21, 22, 13}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 6)
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                    --手臂张开直接砍出
                    {"cast4", T.createSpecialActionFunc(
                            {13, 13, 17, 17, 21, 22}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 6)
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                    --转了好久
                    {"cast5", T.createSpecialActionFunc(
                            {13, 14, 15, 16, 17,
                             18, 19, 20, --这三帧是循环帧（根据时间来决定到底转了多久）
                             21, 22}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                local nmax = int(actionCountMax/cutFrame) + 1
                                if n > 5 and n <= nmax - 2 then --在循环范围内的话
                                    n = 6 + (n - 6)%3
                                end
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                },
        --spActionFuncTable,
                {
                    --向上攻击
                    --攻击前摇
                    {"attack_up_before",
                     function(self, time)
                         time = time or 0
                         self:setAction("attack_up_before", 32 + time)
                     end},
                }),
        --boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 100, 255, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                end,
                --scOpenEffect,
                function(self)
                    --New(pic_show)
                    EGGlib.RenderEffect.createScOpenShowCircle("", 255, 0, 255, 30, 30, 30)
                    effect.generalSpellShow(pic_show_img, 0.6, boss_arua_img, 255, 0, 255)
                    task.Wait(60) --模拟默认立绘演出90f
                    self.absorbAction(self, 60)
                end,
                --absorbEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 0, 255)
                    if t then task.Wait(t) end
                end,
                --breakEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 0, 255)
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
                    EGGlib.RenderEffect.scBreakEffect(self.x, self.y, 255, 0, 255, 'tree_leaf_white', 'Cherry_eff')
                end
        ),
        scbg, --scbg
        pic_show, --pic_show
        function(self)
            system.spellcard.auxiliary.setChainBonusBase(system.spellcard.BONUS_CHAIN_BASE_S5S6) -- 修改为2倍
            boss.class.changeAuraImg(self, boss_arua_img)

            local b
            self.show_backlight = function()
                b = New(backlight, self)
            end
            self.close_backlight = function()
                if IsValid(b) then
                    backlight.destructor(b)
                end
            end
        end
)
return BossRes
