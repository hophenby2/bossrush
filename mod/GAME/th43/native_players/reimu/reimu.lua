---------------------------------------
---灵梦自机
---author:S7P
---------------------------------------

local res_path = "res/player/reimu/"
local player_name = "reimu" -- 自机名字
local res_name = "_" .. player_name -- 与本自机相关的素材名字（注意前面加一个下划线，是要和同名的boss素材分开）
local switch1 = EGGlib.Math.spSwitch1

local scale = EISlib.Player.scale --贴图尺寸
local cur_path = EISlib.Player.path.."reimu/"

local hspeed = 4.4 --初始高速移动速度
local lspeed = 2.1 --初始低速移动速度
local hyper_hspeed = 4.4
local hyper_lspeed = 2.1

local graze_range = 50
local hyper_graze_range = 70

local hcollect_range = 50
local lcollect_range = 90

local equips = lstg.DoFile(cur_path.."equip.lua")

local function setupPlayerAnimation(self)
    local normal = {}
    for i = 1, 12 do
        normal[i] = res_name.."_normal"..i
    end
    local left1 = {}
    for i = 1, 4 do
        left1[i] = res_name.."_left"..i
    end
    local left2 = {}
    for i = 5, 12 do
        left2[i-4] = res_name.."_left"..i
    end
    local right1 = {}
    for i = 1, 4 do
        right1[i] = res_name.."_right"..i
    end
    local right2 = {}
    for i = 5, 12 do
        right2[i - 4] = res_name.."_right"..i
    end
    self._wisys = PlayerWalkImageSystem(self, normal, left1, left2, right1, right2, 4, 4)
end

--region PlayerClass 自机本体定义

local PlayerClass = Class(player_class)
function PlayerClass:init()
    self.name = "reimu"
    -- 加载资源
    equips.loadRes()
    -- 加载自己装备
    self.spellFunc = equips.spell
    player_class.init(self, player_name)
    self.max_nextspell = 240 --持续时间中等的雷
    player_class.changeSpeed(self, hspeed, lspeed) --移动速度
    player_class.changeGrazeRange(self, graze_range, graze_range) --正常的擦弹范围
    system.PowerRank.setMaxHitedCount(self, 2) --灵梦有两次被弹的机会
    PlayerClass.recoveredCollectRange(self)
    self.vscale = scale
    self.hscale = scale
    self.check = 20 --统一到20
    self.graze_bonus_rate = switch1(difficulty, {
        2.5, 2.5, 2.0, 2.0, 2.0
    }) --灵梦擦弹给的最大得点倍率翻倍
    setupPlayerAnimation(self)
    if system.PowerRank.isInHyper() then --装备初始化
        PlayerClass.hyperStart(self)
    end
    PlayerClass.changeEquip(self, system.PowerRank.getRank())
    self.component.DarkMask.class.setColor(self.component.DarkMask, 255, 150, 255, 150)
end
function PlayerClass:spell()
    player_class.spell(self) --触发无敌时间、符卡cd、音效等事件
    self.spellFunc(self)
end
function PlayerClass:frame()
    player_class.frame(self)
end
function PlayerClass:render()
    player_class.render(self)
end
--依据传入rank等级更换装备
function PlayerClass:changeEquip(rank)
    self._shoot_equip = equips[rank+1](self)
end
--启动hyper时特殊事件
function PlayerClass:hyperStart()
    player_class.changeSpeed(self, hyper_hspeed, hyper_lspeed)
    player_class.changeGrazeRange(self, hyper_graze_range, hyper_graze_range) --擦弹范围变大
    self.hyperBoundary = New(equips.hyperBoundary)
    if system.PowerRank.getHyperTime() == system.PowerRank.getHyperMaxTime() then
        tasker(function()
            New(EGGlib.RenderEffect.Player_AbsorbEffect, self.x, self.y, 'tree_leaf_white', 'Cherry_eff', 255, 100, 100)
            effect.shakeScreen(90, 10)
            EGGlib.ObjectEvent.moveWithTask(New(EGGlib.RenderEffect.AbsorbEffect2, self.x, self.y, 255, 0, 255, "mul+add"), self, 0, 0, _infinite)
        end)
    end
end
--hyper期间被弹事件
function PlayerClass:hyperHited()
    equips.hyperBoundary.breakOneBoundary(self.hyperBoundary)
end
--结束hyper时事件
function PlayerClass:hyperEnd()
    PlaySound("enep04")
    --effect.shakeScreen(30, 10)
    player_class.changeSpeed(self, hspeed, lspeed) --速度恢复
    player_class.changeGrazeRange(self, graze_range, graze_range) --擦弹范围恢复
    New(EGGlib.RenderEffect.BreakEffect, self.x, self.y, 'tree_leaf_white', 'Cherry_eff', 255, 100, 100)
    Del(self.hyperBoundary)
end
function PlayerClass:changeSpeedWhenBomb()
    player_class.changeSpeed(self, 1, 1)
end
function PlayerClass:recoveredSpeed()
    if system.PowerRank.getRank() < 4 then
        player_class.changeSpeed(self, hspeed, lspeed)
    else
        player_class.changeSpeed(self, hyper_hspeed, hyper_lspeed)
    end
end
function PlayerClass:recoveredCollectRange()
    self._collecter:setCollectRange(hcollect_range, lcollect_range)
    self._collecter:setCollectChipRange(hcollect_range, lcollect_range)
end

--endregion

return PlayerClass
