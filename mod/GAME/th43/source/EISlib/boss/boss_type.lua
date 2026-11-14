-------------------------------------------------
---东方栖霞园 boss 种类定义
-------------------------------------------------

local M = {}
EISlib.BossDefinition.Type = M

---@class Action 动作对象
---@param num_table table 存放播放贴图序号顺序的表，如{1, 2, 3}将按顺序循环播放1 2 3贴图
---@param loop number 循环节，如果填2，则先播放一次1 2 3，然后2 3 2 3 ...循环
---@return Action
function M.createActionTable(num_table, loop)
	return { id = num_table, loop = loop or #num_table }
end

---@param normal Action boss不动时的动作
---@param left Action boss左移动作(若只有左移动作没右移动作，会默认将右移动作变成左移动作的反向
---@param right Action boss右移动作(若只有右移动作没左移动作，会默认将左移动作变成右移动作的反向
function M.createNormalMovementFunc(normal, left, right, cutFrame, size)
	cutFrame = cutFrame or 8
	size = size or 0.5
	--创建静止时的贴图播放动作
	local wi
	if left and right then
		wi = { ["normal"] = normal, ["left"] = left, ["right"] = right }
	elseif left and not right then
		wi = { ["normal"] = normal, ["move"] = left }
	elseif not left and right then
		wi = { ["normal"] = normal, ["move"] = right }
	else
		error("一个移动的动作都没有你填你马呢？")
	end
	local normalMovement, id, anime, list
	if left and right then
		function normalMovement(wisys, self, actionCount, actionCountMax)
			self.lr = self.lr or 1
			if self.dx > 0.005 then
				self.lr = min(self.lr + 2, 28)
			elseif self.dx < -0.005 then
				self.lr = max(self.lr - 2, -28)
			end
			if self.lr == 0 then
				if self.dx < 0 then
					self.lr = self.lr - 2
				else
					self.lr = self.lr + 2
				end
			end
			if self.dx == 0 then
				self.lr = sign(self.lr) * max(1, abs(self.lr) - 1)
			end
			if abs(self.lr) == 1 then
				list = wi["normal"]
				anime = int(self.ani / cutFrame) % #list.id + 1
				id = list.id[anime]
			elseif self.lr == 28 then
				list = wi["right"]
				anime = int(self.ani / cutFrame) % list.loop + 1
				id = list.id[#list.id - list.loop + anime]
			elseif self.lr == -28 then
				list = wi["left"]
				anime = int(self.ani / cutFrame) % list.loop + 1
				id = list.id[#list.id - list.loop + anime]
			elseif self.lr > 1 then
				list = wi["right"]
				anime = int((self.lr / 28) * #list.id) + 1
				id = list.id[anime]
			elseif self.lr < -1 then
				list = wi["left"]
				anime = int((self.lr / 28) * #list.id) + 1
				id = list.id[anime]
			end
			return id, size, size
		end
	elseif left and not right then
		function normalMovement(wisys, self, actionCount, actionCountMax)
			local u = 1 --决定朝向
			self.lr = self.lr or 1
			if self.dx > 0.005 then
				self.lr = min(self.lr + 2, 28)
			elseif self.dx < -0.005 then
				self.lr = max(self.lr - 2, -28)
			end
			if self.lr == 0 then
				if self.dx < 0 then
					self.lr = self.lr - 2
				else
					self.lr = self.lr + 2
				end
			end
			if self.dx == 0 then
				self.lr = sign(self.lr) * max(1, abs(self.lr) - 1)
			end
			if abs(self.lr) == 1 then
				list = wi["normal"]
				anime = int(self.ani / cutFrame) % #list.id + 1
				id = list.id[anime]
			elseif self.lr == 28 then
				list = wi["move"]
				anime = int(self.ani / cutFrame) % list.loop + 1
				id = list.id[#list.id - list.loop + anime]
				u = -1
			elseif self.lr == -28 then
				list = wi["move"]
				anime = int(self.ani / cutFrame) % list.loop + 1
				id = list.id[#list.id - list.loop + anime]
			elseif self.lr > 1 then
				list = wi["move"]
				anime = int((self.lr / 28) * #list.id) + 1
				id = list.id[anime]
				u = -1
			elseif self.lr < -1 then
				list = wi["move"]
				anime = int((self.lr / 28) * #list.id) + 1
				id = list.id[anime]
			end
			return id, size * u, size
		end
	elseif not left and right then
		function normalMovement(wisys, self, actionCount, actionCountMax)
			local u = 1 --决定朝向
			self.lr = self.lr or 1
			if self.dx > 0.005 then
				self.lr = min(self.lr + 2, 28)
			elseif self.dx < -0.005 then
				self.lr = max(self.lr - 2, -28)
			end
			if self.lr == 0 then
				if self.dx < 0 then
					self.lr = self.lr - 2
				else
					self.lr = self.lr + 2
				end
			end
			if self.dx == 0 then
				self.lr = sign(self.lr) * max(1, abs(self.lr) - 1)
			end
			if abs(self.lr) == 1 then
				list = wi["normal"]
				anime = int(self.ani / cutFrame) % #list.id + 1
				id = list.id[anime]
			elseif self.lr == 28 then
				list = wi["move"]
				anime = int(self.ani / cutFrame) % list.loop + 1
				id = list.id[#list.id - list.loop + anime]
			elseif self.lr == -28 then
				list = wi["move"]
				anime = int(self.ani / cutFrame) % list.loop + 1
				id = list.id[#list.id - list.loop + anime]
				u = -1
			elseif self.lr > 1 then
				list = wi["move"]
				anime = int((self.lr / 28) * #list.id) + 1
				id = list.id[anime]
			elseif self.lr < -1 then
				list = wi["move"]
				anime = int((self.lr / 28) * #list.id) + 1
				id = list.id[anime]
				u = -1
			end
			return id, size * u, size
		end
	end
	return normalMovement
end

---@param action_table Action
---@param func function
---@param cutFrame number
---@param size number
function M.createSpecialActionFunc(action_table, func, cutFrame, size)
	cutFrame = cutFrame or 8
	size = size or 0.5
	--创建静止时的贴图播放动作
	local function specialAction(wisys, self, actionCount, actionCountMax)
		local id = func(wisys, self, actionCount, actionCountMax, cutFrame)
		return action_table[id], size, size
	end
	return specialAction
end

function M.addSpecialActionFunc(WalkImage, action_name, specialActionFunc)
	WalkImage:connectAction(action_name, specialActionFunc)
end

--添加动作组合函数
---@param name string 标示符
---@param Func function 执行的函数块
function M.addActionGroup(WalkImage, name, Func)
	WalkImage.ActionGroups["" .. name] = Func
end

--创建一个行走图对象
function M.createWalkImage(tex, u, v, n, normalMovementFunc, spActionFuncTable, ActionGroupFuncTable)
	local WalkImage = DNHWalkImageSystem(self, tex, 0, 0, u, v, n)
	--普通动作
	WalkImage:connectAction("normal", normalMovementFunc)
	--特殊动作
	for _, vv in ipairs(spActionFuncTable) do
		M.addSpecialActionFunc(WalkImage, vv[1], vv[2])
	end
	--特殊动作组合
	WalkImage.ActionGroups = {}
	for _, vv in ipairs(ActionGroupFuncTable) do
		M.addActionGroup(WalkImage, vv[1], vv[2])
	end
	--施法函数
	WalkImage.cast = function(name, isWait)
		WalkImage.ActionGroups["" .. name](WalkImage, isWait)
	end
	return WalkImage
end

--将行走图对象与boss绑定
---@param self boss.object
function M.changeWalkImage(self, WalkImage)
	WalkImage.obj = self --绑定
	self._wisys = WalkImage --绑定
	self.ActionGroups = WalkImage.ActionGroups
	self.cast = WalkImage.cast
	self.setAction = function(act_name, t)
		WalkImage:setAction(act_name, t)
	end
end

---@param r number 骚气的r g b blend值
---@param g number
---@param b number
---@param blend string
---@param scOpenEffect function 开卡特效函数
---@param absorbEffect function 蓄力特效函数
---@param breakEffect function 炸出函数
---@param absorbAction function 蓄力外加boss动作函数
---@param scBreakEffect function sc击破特效函数
function M.createBossEffectFunc(createSaoQiFunc, scOpenEffect, absorbEffect, breakEffect, absorbAction, scBreakEffect)
	local function init(self)
		--添加骚气
		createSaoQiFunc(self)
		--boss开卡演出(默认只是停滞60f，每一个特定的开卡演出由boss定义时自己定义）
		self.scOpenEffect = scOpenEffect or boss.defaultScOpenEffect
		--boss蓄力特效
		self.absorbEffect = absorbEffect or boss.defaultAbsorbEffect
		--boss蓄力爆炸特效
		self.breakEffect = breakEffect or boss.defaultBreakEffect
		--boss带动作的蓄力特效(一般用于开卡
		self.absorbAction = absorbAction or boss.defaultAbsorbAction
		--boss符卡击破特效
		self.scBreakEffect = scBreakEffect or boss.defaultScBreakEffect
	end
	return init
end

--创建一个boss及其相关素材资源
---@param boss_name string boss名字
---@param theme_music string boss主题曲
---@param background table boss背景
---@param loadResFunc function 资源载入函数
---@param WalkImageFunc function 设置行走图及动作函数
---@param BossEffectFunc function 设置boss相关特效函数
function M.createBossRes(boss_name, theme_music, background, loadResFunc, WalkImageFunc, BossEffectFunc, scbg, pic_show, otherFunc)
	local BossRes = {}
	--行走图设置
	BossRes.boss_name = boss_name  --以boss名来作为其相关素材的前缀
	BossRes.bgm = theme_music --boss的主题曲
	BossRes.background = background --boss的主题背景
	local path = "res/boss/" .. BossRes.boss_name .. "/"
	--加载其他资源
	function BossRes.bossLoadRes()
		loadResFunc(BossRes.boss_name, path)
	end
	function BossRes.bossInitial(self)
		M.changeWalkImage(self, WalkImageFunc) --设置行走图
		BossEffectFunc(self) --boss特效模块初始化
		if otherFunc then
			otherFunc(self)
		end
	end
	--符卡背景
	BossRes.scbg = scbg
	--立绘演出
	BossRes.pic_show = pic_show
	return BossRes
end
