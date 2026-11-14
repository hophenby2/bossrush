-----------------------------------------------
---东方栖霞园 二面boss点图动作及特效
-----------------------------------------------
--导入其他函数
local halfMoveLengthWithPar = EGGlib.ObjectEvent.halfMoveLengthWithPar
local alphaChange = EGGlib.ObjectEvent.alphaChange --透明度变化事件
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local velch = EGGlib.ObjectEvent.velocityChange
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local disappearByAlpha = EGGlib.ObjectEvent.disappearByAlpha
local setSize = EGGlib.ObjectEvent.setSize
local sizeChange_task = EGGlib.ObjectEvent.sizeChangeTask

local Bclass = {}
EISlib.BossDefinition.Artemina = Bclass

local T = EISlib.BossDefinition.Type
--行走图设置
local boss_name = "Artemina"  --以boss名来作为其相关素材的前缀
local path = "res/boss/"..boss_name.."/"

--符卡背景
local scbg_imgs = {}
for i = 1, 3 do
    scbg_imgs[i] = boss_name.."_scbg"..i
end

local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    self.layer = LAYER_BG + 10
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

--立绘演出
local pic_show_img = boss_name.."pic_show"
local boss_arua_img = boss_name.."boss_arua"

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
    EGGlib.RenderEffect.defaultRenderImg(self)
end

--region 二面boss特制药箭
local star_effect

--箭的爆炸效果
local boom_effect = Class(object)
function boom_effect:init(x, y)
    self.x, self.y = x, y
    self.range = 0
    self.rate = 0
    self.layer = LAYER_ENEMY - 1
    task.New(self, function()
        local dr = 40/10
        for _ = 1, 10 do
            self.range = self.range + dr
            task.Wait(1)
        end
        dr = 1/30
        for _ = 1, 30 do
            self.rate = self.rate + dr
            task.Wait(1)
        end
        Del(self)
    end)
end
function boom_effect:frame()
    task.Do(self)
end
function boom_effect:render()
    sp.misc.RenderRing3("boom_orange",
            self.x, self.y,
            self.rate*self.range, self.range,
            60, 1, 0, 360,
            "mul+add", Color(255, 255, 255, 255))
end
Bclass.boom_effect = boom_effect
--主要函数：创建特殊的弓箭
local function createSpArrow(target, x, y, a, color, targetFunc)
    local obj = stg.newBullet(x, y, stg.arrow_mid, color, true)
    obj.rot = a
    obj.navi = true
    obj.bound = false
    EGGlib.RenderEffect.newTrail(obj,
            1, 10, 1, --dlayer, maxnum, frame,
            obj.img, 1, "mul+add", --img, size, blend,
            1, 999, false --times, _a_rate, Isdsize
    )
    --移动
    task.New(obj, function()
        if IsValid(target) then
            halfMoveLengthWithPar(obj, target.x, target.y, 0, a, 30, 20, 40, 0) --x, y, vy, a, t0, t1, t2, t3
        else
            Del(obj)
        end

        New(boom_effect, obj.x, obj.y) --爆炸效果
        if IsValid(target) then
            targetFunc(obj, target)
        else
            Del(obj)
        end
    end)
    --拖尾
    task.New(obj, function()
        while true do
            star_effect(obj.x, obj.y, obj.rot  + 180 + ran:Float(-5, 5), color)
            task.Wait(1)
        end
    end)
end
--流星箭尾

function star_effect(x, y, a, co)
    local obj = stg.newSimpleBullet(x, y, stg.star_small, co)
    local size = ran:Float(0.5, 0.75)
    setSize(obj, size, size)
    obj.colli = false
    obj.group = GROUP_GHOST
    robject.set_color(obj, "mul+add", 200, 255, 255, 255)
    obj.rot = ran:Float(0, 360)
    obj.omiga = 3
    task.New(obj, function()
        sizeChange_task(obj, -size, 30)
        velch(obj, 3, 0.5, a, 10, 0)
        disappearByAlpha(obj, 20)
        obj.colli = false
        _del(obj, false)
    end)
end

--endregion

local light_tex = boss_name.."_light"
local light_red_tex = boss_name.."_light_red"

--苹果
local apple_imgs = {}

--ex道中boss背景变化
local bgch_img_list = {}
for i = 1, 9 do
    bgch_img_list[i] = boss_name.."_bgch_"..i
end
Bclass.bgch_img_list = bgch_img_list

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s2_boss", --theme_music,
        stage2_background, --background,
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
                local sp_path = "res/performer/Artemina/"
                LoadImageFromFile(pic_show_img, sp_path .. "sweat.png", true, 0, 0, false, 0)
            end
            --魔法阵
            LoadImageFromFile(boss_arua_img, path.."boss_arua.png")
            --苹果
            local apple_tex = boss_name.."_apple"
            local state = {"_normal", "_bad", "_cyan", "_golden"}
            for r = 0, 1 do
                for c = 1, 2 do
                    apple_imgs = boss_name.."_apple"..state[c+2*r]
                    LoadTexture(apple_tex, path.."apple.png")
                    LoadImage(apple_imgs, apple_tex, 128*(c - 1), 128*r, 128, 128)
                end
            end
            --绿光拖尾
            LoadTexture(light_tex, path.."light.png")
            Add_bentlaser_texture(light_tex, light_tex) --添加至曲线激光
            --红光拖尾
            LoadTexture(light_red_tex, path.."light_red.png")
            Add_bentlaser_texture(light_red_tex, light_red_tex) --添加至曲线激光
            --ex道中boss背景变化
            for i = 1, 9 do
                LoadImageFromFile(bgch_img_list[i], path .. "bgch/"..i..".png")
            end
        end,
        --行走图动作函数
        T.createWalkImage(
                boss_name.."_BossWalkImage", 240, 240, 6, --tex, u, v, n
        --normalMovementFunc,
                T.createNormalMovementFunc(
                        T.createActionTable({1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9}), --normal
                        T.createActionTable({10, 11, 12, 13, 14, 15, 16}, 4), --left
                        T.createActionTable({17, 18, 19, 20, 21, 22, 23}, 4), --right
                        8, --cutFrame,
                        0.5  --size,
                ),
                {
                    --向上攻击
                    --向上射箭攻击前摇
                    {"attack_up_before", T.createSpecialActionFunc(
                            {24, 25, 26, 27}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 4) --最后一帧为停顿帧，以增加前摇之用
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                    --连射！！
                    {"attack_up_ing", T.createSpecialActionFunc(
                            {27, 28, 29}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 3) --最后一帧为停顿帧，以增加前摇之用
                                return n
                            end, --func,
                            4, 0.5)}, --cutFrame, size
                    --向上射箭攻击后摇
                    {"attack_up_after", T.createSpecialActionFunc(
                            {28, 29, 30}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 3)
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size

                    --向下攻击
                    --攻击前摇
                    {"attack_down_before", T.createSpecialActionFunc(
                            {31, 32, 33, 34, 35, 36}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 6) --最后一帧为停顿帧，以增加前摇之用
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                    --连射！！
                    {"attack_down_ing", T.createSpecialActionFunc(
                            {36, 37, 38}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                n = min(n, 3) --最后一帧为停顿帧，以增加前摇之用
                                return n
                            end, --func,
                            4, 0.5)}, --cutFrame, size
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
                    --连射
                    {"attack_up_ing",
                     function(self)
                         self:setAction("attack_up_ing", 12)
                     end},
                    --攻击后摇
                    {"attack_up_after",
                     function(self)
                         self:setAction("attack_up_after", 24)
                     end},

                    --向下攻击
                    --前摇
                    {"attack_down_before",
                     function(self, time)
                         time = time or 0
                         self:setAction("attack_down_before", 48 + time)
                     end},
                    --连射
                    {"attack_down_ing",
                     function(self)
                         self:setAction("attack_down_ing", 12)
                     end},
                }),
        --boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 100, 255, 255, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                end,
                --scOpenEffect,
                function(self)
                    EGGlib.RenderEffect.createScOpenShowCircle("", 0, 255, 175, 30, 30, 30)
                    effect.generalSpellShow(pic_show_img, 0.75, boss_arua_img, 0, 255, 0)
                    task.Wait(60) --模拟默认立绘演出120f
                    self.absorbAction(self, 60)
                end,
                --absorbEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 0, 255, 0)
                    if t then task.Wait(t) end
                end,
                --breakEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 0, 255, 0)
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
                    EGGlib.RenderEffect.scBreakEffect(self.x, self.y, 0, 255, 0, 'tree_leaf_white', 'Cherry_eff')
                end
        ),
        scbg, --scbg
        pic_show, --pic_show
        function(self)
            boss.class.changeAuraImg(self, boss_arua_img)
            self.createSpArrow = createSpArrow
        end
)
return BossRes
