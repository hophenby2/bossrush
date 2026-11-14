-----------------------------------------------
---东方栖霞园 莉莉黑 点图动作及特效
---啊？你问我为什么文件命名是LilyWhite？ 这是*秘密*哦！~
-----------------------------------------------

local T = EISlib.BossDefinition.Type
local Bclass = {}
EISlib.BossDefinition.LilyWhite = Bclass

--导入其它包
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask

--行走图设置
local boss_name = "LilyBlack"  --以boss名来作为其相关素材的前缀
local path = "res/boss/"..boss_name.."/"

--符卡背景
local scbg1_img = boss_name.."_scbg1"
local scbg2_img = boss_name.."_scbg2"
--莉莉白符卡背景
local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.addLayer(self, scbg2_img, true, 0, 0, 0, 0.5, 0.5, 0, "mul+rev", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, scbg1_img, false, 0, 0, 0, 0, 0, 0, "", 1, 1,
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
    self.layer = LAYER_ENEMY_BULLET + 5
    self.x, self.y = 0, 250
    local size = 0.5
    self.hscale, self.vscale = size, size
    robject.set_color(self, "", 0, 255, 255, 255)
    alphaChangeTask(self, 0, 255, 60)
    --[[for _ = 1, 60 do
        New(snow)
    end]]
    task.New(self, function()
        --圈
        EGGlib.RenderEffect.createScOpenShowCircle("", 255, 100, 255, 30, 30, 30)
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
        task.MoveTo(self, 0, 0, 45, MOVE_DECEL)
        self.vy = -0.1
        task.Wait(45)
        alphaChangeTask(self, 255, 0, 45)
        task.MoveTo(self, 0, -250, 45, MOVE_ACCEL)
        Del(self)
    end)
end
function pic_show:frame()
    task.Do(self)
end
function pic_show:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

--粉拖尾
local pink_light_tex = boss_name.."_light_pink"
Bclass.pink_light_tex = pink_light_tex

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s4", --theme_music,
        stage4_background, --background,
--资源载入函数
        function()
            --行走图
            LoadTexture(boss_name.."_BossWalkImage", path .. "BossWalkImage.png")--载入行走图资源
            --立绘
            LoadImageFromFile(pic_show_img, "res/performer/Lily/normal.png", false, 0, 0, false, 0)

            --莉莉白符卡背景
            LoadImageFromFile(scbg1_img, path .. "scbg1.png", true, 0, 0, false, 0)
            LoadImageFromFile(scbg2_img, path .. "scbg2.png", true, 0, 0, false, 0)
            --莉莉白行走图
            LoadTexture(boss_name.."_BossWalkImage", path .. "BossWalkImage.png")--载入行走图资源
            --LoadImageFromFile("s5midboss_pic", path .. "s5midboss_pic.png", true, 0, 0, false, 0)--立绘加载

            --彩虹屁
            LoadTexture(pink_light_tex, path.."light_pink.png")
            Add_bentlaser_texture(pink_light_tex, pink_light_tex) --添加至曲线激光
        end,
--行走图动作函数
        T.createWalkImage(
                boss_name.."_BossWalkImage", 180, 180, 5, --tex, u, v, n
        --normalMovementFunc,
                T.createNormalMovementFunc(
                        T.createActionTable({1, 2, 3, 4, 5, 6, 7, 1, 5, 6, 7}), --normal
                        T.createActionTable({8, 9, 10, 11, 12, 13, 14}, 4), --left
                        T.createActionTable({15, 16, 17, 18, 19, 20, 21}, 4), --right
                        8, --cutFrame,
                        0.5  --size,
                ),
                {
                    --摆臂旋转
                    {"revolve", T.createSpecialActionFunc(
                            {15, 16, 17, 18, 19, 20, 21, 22}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                if n > 4 then
                                    n = 5 + int(n - 5)%4 --19 20 21 22循环
                                end
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                },
        --spActionFuncTable,
                {
                    {"revolve",
                     function(self, isWait)
                         self:setAction("revolve", 64)
                     end}
                }),
--boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 0, 0, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                    -- 魔法阵减色效果
                    self.fxa = 255
                    self.fxr = 192
                    self.fxg = 160
                    self.fxb = 64
                end,
        --scOpenEffect,
                function(self)
                    local r, g, b = 255, 0, 255
                    New(effect.lattice, r, g, b)
                    New(effect.diamond, r, g, b)
                    New(effect.diamondstroke, r, g, b)
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
                    task.Wait(60)
                    self.absorbAction(self, 60)
                end,
        --absorbEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 168, 114, 235)
                    if t then task.Wait(t) end
                end,
        --breakEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 168, 114, 235)
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
                    EGGlib.RenderEffect.scBreakEffect(self.x, self.y, 255, 0, 255, 'tree_leaf_white', 'Cherry_eff')
                end
        ),
        scbg, --scbg
        pic_show, --pic_show
        function(self)
            boss.setUInameDisplay(self, true) -- 这个也一直显示名称吧
        end
)
return BossRes

