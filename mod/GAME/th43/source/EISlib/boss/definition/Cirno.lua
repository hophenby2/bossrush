-----------------------------------------------
---东方栖霞园 ⑨点图动作及特效
-----------------------------------------------

local T = EISlib.BossDefinition.Type
--行走图设置
local boss_name = "Cirno"  --以boss名来作为其相关素材的前缀
local path = "res/boss/"..boss_name.."/"
local Bclass = {}
EISlib.BossDefinition.Cirno = Bclass

--导入其他包
local alphaChange = EGGlib.ObjectEvent.alphaChange --透明度变化事件
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local Particle_Manager = EGGlib.Particle.Manager
local Particle_Image = EGGlib.Particle.Particle_Image
local sizeChange = EGGlib.ObjectEvent.sizeChange
local alphaChange = EGGlib.ObjectEvent.alphaChange
local sin = EGGlib.Math.phaseToSin
local cos = EGGlib.Math.phaseToCos

--region 符卡背景
local scbg1_img = boss_name.."_scbg1"
local scbg2_img = boss_name.."_scbg2"
local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.addLayer(self, scbg2_img, true, 0, 0, 0, 0.75, 0.75, 0, "mul+rev", 1, 1,
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
--endregion

--region 立绘演出
local pic_show_img = boss_name.."pic_show"
local snow_img = boss_name.."snow"
Bclass.snow_img = snow_img
--雪花道具
local snow = Class(object)
function snow:init()
    local size = ran:Float(1, 2)
    self.hscale, self.vscale = size, size
    self.img = snow_img
    self.layer = LAYER_ENEMY_BULLET + 6
    self.omiga = ran:Float(1, 6)
    self.x, self.y = 0, 0
    robject.set_color(self, "", 0, 255, 255, 255)
    velchTask(self, ran:Float(1, 10), 1, ran:Float(0, 360), 40, 10)
    self.rot = ran:Float(0, 360)
    --透明度变化
    task.New(self, function()
        alphaChange(self, 0, 255, 30)
        task.Wait(ran:Int(0, 45))
        alphaChange(self, 255, 0, 30)
    end)
end
function snow:frame()
    task.Do(self)
end
function snow:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

local pic_show = Class(object)
function pic_show:init()
    self.img = pic_show_img
    self.layer = LAYER_ENEMY_BULLET + 5
    self.x, self.y = -150, 150
    local size = 0.4
    self.hscale, self.vscale = size, size
    robject.set_color(self, "", 0, 255, 255, 255)
    alphaChangeTask(self, 0, 255, 60)
    for _ = 1, 60 do
        New(snow)
    end
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
        task.MoveTo(self, 50, 0, 60, MOVE_DECEL)
        self.vx, self.vy = 0.1, -0.1
        task.Wait(45)
        alphaChangeTask(self, 255, 0, 45)
        task.MoveTo(self, 200, -100, 45, MOVE_ACCEL)
        Del(self)
    end)
end
function pic_show:frame()
    task.Do(self)
end
function pic_show:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
--endregion

--region 粒子效果
local function createParticle(x, y)
    local s = ran:Float(0.2, 0.3)
    local particle = Particle_Image.new(snow_img, x, y, ran:Int(0, 360), 0, 0)
    particle.omiga = 6*ran:Sign()
    particle._blend = "mul+add"
    particle.vx, particle.vy = ran:Float(-0.05, 0.05), ran:Float(-0.5, -0.55)
    particle._a = 200
    task.New(particle, function()
        sizeChange(particle, s, 10)
        task.Wait(60)
        alphaChange(particle, 200, 0, 15)
        particle:del()
    end)
    return particle
end
local function createParticleManager(boss)
    local particle_manager = New(Particle_Manager)
    --生成小粒子
    task.New(particle_manager, function()
        local r, a
        while IsValid(boss) and Particle_Manager.isValid(particle_manager) do
            r, a = ran:Float(20, 50), ran:Int(0, 360)
            Particle_Manager.addParticle(particle_manager, createParticle(boss.x + r*cos(a), boss.y + r*sin(a)))
            task.Wait(3)
        end
        Particle_Manager.del(particle_manager)
    end)
end
--endregion

local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s1", --theme_music,
        stage1_background, --background,
        --资源载入函数
        function()
            --符卡背景
            LoadImageFromFile(scbg1_img, path .. "scbg1.png", true, 0, 0, false, 0)
            LoadImageFromFile(scbg2_img, path .. "scbg2.png", true, 0, 0, false, 0)
            --行走图
            LoadTexture(boss_name.."_BossWalkImage", path .. "BossWalkImage.png")--载入行走图资源
            --立绘
            do
                local sp_path = "res/performer/Cirno/"
                LoadImageFromFile(pic_show_img, sp_path .. "normal.png", true, 0, 0, false, 0)
            end
            --小雪花道具
            LoadImageFromFile(snow_img, path .. "snow.png")
        end,
        --行走图动作函数
        T.createWalkImage(
                boss_name.."_BossWalkImage", 160, 160, 5, --tex, u, v, n
        --normalMovementFunc,
                T.createNormalMovementFunc(
                        T.createActionTable({1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9}), --normal
                        T.createActionTable({10, 11, 12, 13, 14}, 3), --left
                        nil, --right
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
                    local r, g, b = 0, 255, 255
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
                    New(pic_show)
                    task.Wait(60) --模拟默认立绘演出90f
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
                    self.cast("revolve")
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
            system.spellcard.auxiliary.setChainBonusBase(system.spellcard.BONUS_CHAIN_BASE_S1) -- 修改为2倍
            createParticleManager(self) --为自己创建一个雪花粒子生成器
            boss.setUInameDisplay(self, true) -- 笨蛋没对话，而且大家都知道这比是谁
        end
)
return BossRes
