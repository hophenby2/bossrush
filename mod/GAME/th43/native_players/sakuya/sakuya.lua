---------------------------------------
---咲夜自机
---author:S7P
---------------------------------------

local res_path = "res/player/sakuya/"
local player_name = "sakuya" -- 机名字
local res_name = "_" .. player_name -- 与本自机相关的素材名字（注意前面加一个下划线，是要和同名的boss素材分开）

local cur_path = EISlib.Player.path.."sakuya/"
local scale = EISlib.Player.scale --贴图尺寸

local hspeed = 4 --初始高速移动速度
local lspeed = 2 --初始低速移动速度
local hyper_hspeed = 4
local hyper_lspeed = 2

local graze_range = 30
local hyper_graze_range = 50

local hcollect_range = 50
local lcollect_range = 80

local equips = lstg.DoFile(cur_path.."equip.lua")

local function setupPlayerAnimation(self)
    local normal = {}
    for i = 1, 12 do
        normal[i] = res_name .. "_normal" .. i
    end
    local left1 = {}
    for i = 1, 4 do
        left1[i] = res_name .. "_left" .. i
    end
    local left2 = {}
    for i = 5, 12 do
        left2[i - 4] = res_name .. "_left" .. i
    end
    local right1 = {}
    for i = 1, 4 do
        right1[i] = res_name .. "_right" .. i
    end
    local right2 = {}
    for i = 5, 12 do
        right2[i - 4] = res_name .. "_right" .. i
    end
    self._wisys = PlayerWalkImageSystem(self, normal, left1, left2, right1, right2, 4, 4)
end

--region PlayerClass 自机本体定义

local PlayerClass = Class(player_class)
function PlayerClass:init()
    self.name = "sakuya"
    -- 加载资源
    equips.loadRes()
    -- 加载自己装备
    self.spellFunc = equips.spell
    player_class.init(self, player_name)
    player_class.changeSpeed(self, hspeed, lspeed) --移动速度
    PlayerClass.recoveredCollectRange(self)
    self.max_nextspell = 300 --持续时间很短的雷
    --
    item.Power.setDropVelocity(-1) --power道具掉落速度
    item.Point.setDropVelocity(-1) --蓝点道具掉落速度
    system.spellcard.auxiliary.setSpellBonusDropRate(0.5) --符卡分数随时间损失速率只有正常的一半
    if difficulty == 1 then
        self.chip_bonus_rate = 1.2 --Easy难度中主线回收碎片类道具时获得的最大得点是正常的1.2倍
    elseif difficulty == 2 then
        self.chip_bonus_rate = 1.4 --Normal难度中主线回收碎片类道具时获得的最大得点是正常的1.4倍
    elseif difficulty == 3 then
            self.chip_bonus_rate = 1.7 --Hard难度中主线回收碎片类道具时获得的最大得点是正常的1.6倍
    elseif difficulty == 4 then
        self.chip_bonus_rate = 2.0 --Lunatic难度中主线回收碎片类道具时获得的最大得点是正常的1.8倍
    elseif difficulty == 5 then
        self.chip_bonus_rate = 1.7 --ex关中回收碎片类道具时获得的最大得点是正常的1.7倍
    else
        self.chip_bonus_rate = 1
    end
    --
    player_class.changeGrazeRange(self, graze_range, graze_range) --默认擦弹范围
    self.vscale = scale
    self.hscale = scale
    self.check = 20 --统一到20
    setupPlayerAnimation(self)
    if system.PowerRank.isInHyper() then --装备初始化
        PlayerClass.hyperStart(self)
    end
    PlayerClass.changeEquip(self, system.PowerRank.getRank())
    self.component.DarkMask.class.setColor(self.component.DarkMask, 255, 212, 200, 0)
end
function PlayerClass:spell()
    player_class.spell(self)
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
    self.hyperBoundary = New(equips.hyperBoundary)
    player_class.changeGrazeRange(self, hyper_graze_range, hyper_graze_range) --擦弹范围增大
    if system.PowerRank.getHyperTime() == system.PowerRank.getHyperMaxTime() then
        tasker(function()
            New(EGGlib.RenderEffect.Player_AbsorbEffect, self.x, self.y, 'tree_leaf_white', 'Cherry_eff', 100, 100, 255)
            effect.shakeScreen(90, 10)
            EGGlib.ObjectEvent.moveWithTask(New(EGGlib.RenderEffect.AbsorbEffect2, self.x, self.y, 100, 100, 255, "mul+add"), self, 0, 0, _infinite)
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
    New(EGGlib.RenderEffect.BreakEffect, self.x, self.y, 'tree_leaf_white', 'Cherry_eff', 100, 100, 255)
    Del(self.hyperBoundary)
    player_class.changeGrazeRange(self, graze_range, graze_range) --擦弹范围恢复
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
