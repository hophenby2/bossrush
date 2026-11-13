---=====================================
---东方祈华梦敌对单位实现
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

---@type EISlib
local lib = EISlib

---@class EISlib.Enemy
local M = {}

---@type EISlib.Enemy
lib.Enemy = M

M.PRELOAD = true

M.path = lib.path .. "enemy/"
local path = M.path

local sin, cos = lstg.sin, lstg.cos
local inrange = math.inrange
local lerp = math.lerp
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil
local New = lstg.New
local GetAttr = lstg.GetAttr
local SetAttr = lstg.SetAttr
local IsValid = lstg.IsValid
local BoxCheck = lstg.BoxCheck
local Color = lstg.Color
local SetImageState = lstg.SetImageState
local SetAnimationState = lstg.SetAnimationState
local Render = lstg.Render
local RenderAnimation = lstg.RenderAnimation
local DefaultRenderFunc = lstg.DefaultRenderFunc
local RenderTexture = lstg.RenderTexture

local AUTO_SET_COLOR = true

----------------------------------------
---res

local function load_res()
	local S = lstg.ResourceSet.Create("EISlib.enemy", "global")
	S:AddTexture("_enemy_small_lifebar_texture", "res/effect/enemy_small_lifebar.png", false)
	S:AddSprite("_enemy_small_lifebar", "_enemy_small_lifebar_texture", 0, 10, 100, 10)
end
load_res()

lstg.DoFile(path .. "enemy_style.lua")
lstg.DoFile(path .. "enemy_effect.lua")
lstg.DoFile(path .. "enemy_system.lua")

---@type EISlib.Enemy.StyleManager
local stylemgr = lstg.DoFile(path .. "enemy_render.lua")

----------------------------------------
---enemy lifebar

local LX, LY, LW, LH = 1, 2, 98, 6

---@param x number
---@param y number
---@param rate number
---@param scale number
---@param coodscale number
---@param _a number
local function draw_lifebar(x, y, rate, scale, coodscale, _a)
	scale = scale or 1
	coodscale = coodscale or 0.5
	local c = Color(_a, 255, 255, 255)
	SetImageState("_enemy_small_lifebar", "", c)
	Render("_enemy_small_lifebar", x, y, 0, scale)
	local w2, h2 = LW * 0.5, LH * 0.5
	local u1, u2 = LX, LX + LW * rate
	local v1, v2 = LY, LY + LH
	local x1, x2 = x - w2 * coodscale, x - w2 * coodscale + LW * coodscale * rate
	local y1, y2 = y + h2 * coodscale, y - h2 * coodscale
	RenderTexture("_enemy_small_lifebar_texture", "",
			{ x1, y1, 0.5, u1, v1, c },
			{ x2, y1, 0.5, u2, v1, c },
			{ x2, y2, 0.5, u2, v2, c },
			{ x1, y2, 0.5, u1, v2, c })
end

----------------------------------------
---dye circle renderer

---@param x number
---@param y number
---@param index number
---@param r number
---@param color lstg.Color
local function _render_circle(x, y, index, r, color)
end
do
	---@type number[][]
	local dye_circle_vertex = {}
	for t = 1, 100 do
		dye_circle_vertex[t] = {}
		local rate = (t * 0.01) % 1
		local split = 16
		local rep = 2
		local total = split * rep
		local as = 90
		local da = 360 / total
		local index = 1
		for _ = 1, rep do
			local vs = 0
			local dv = 512 / split
			for _ = 1, split do
				dye_circle_vertex[t][index] = {}
				local vt = dye_circle_vertex[t][index]
				local r1, r2, r3 = 0, rate, 1
				local u1, u2, u3, u4 = (1 - rate) * 512, (1) * 512, (0) * 512, (1 - rate) * 512
				local a1, a2 = as, as - da
				local v1, v2 = vs, vs + dv
				vt[1] = { 0, 0, 0.5, u1, v1 }
				vt[2] = { r2 * cos(a1), r2 * sin(a1), 0.5, u2, v1 }
				vt[3] = { r2 * cos(a2), r2 * sin(a2), 0.5, u2, v2 }
				vt[4] = { 0, 0, 0.5, u1, v2 }
				vt[5] = { r2 * cos(a1), r2 * sin(a1), 0.5, u3, v1 }
				vt[6] = { r3 * cos(a1), r3 * sin(a1), 0.5, u4, v1 }
				vt[7] = { r3 * cos(a2), r3 * sin(a2), 0.5, u4, v2 }
				vt[8] = { r2 * cos(a2), r2 * sin(a2), 0.5, u3, v2 }
				as = as - da
				vs = vs + dv
				index = index + 1
			end
		end
	end
	function _render_circle(x, y, index, r, color)
		local v = dye_circle_vertex[index]
		local vt1, vt2, vt3, vt4, vt5, vt6, vt7, vt8
		for _, vt in ipairs(v) do
			vt1, vt2, vt3, vt4, vt5, vt6, vt7, vt8 = vt[1], vt[2], vt[3], vt[4], vt[5], vt[6], vt[7], vt[8]
			RenderTexture("_flowing_light_texture", "",
					{ x + 0, y + 0, 0.5, vt1[4], vt1[5], color },
					{ x + r * vt2[1], y + r * vt2[2], 0.5, vt2[4], vt2[5], color },
					{ x + r * vt3[1], y + r * vt3[2], 0.5, vt3[4], vt3[5], color },
					{ x + 0, y + 0, 0.5, vt4[4], vt4[5], color })
			RenderTexture("_flowing_light_texture", "",
					{ x + r * vt5[1], y + r * vt5[2], 0.5, vt5[4], vt5[5], color },
					{ x + r * vt6[1], y + r * vt6[2], 0.5, vt6[4], vt6[5], color },
					{ x + r * vt7[1], y + r * vt7[2], 0.5, vt7[4], vt7[5], color },
					{ x + r * vt8[1], y + r * vt8[2], 0.5, vt8[4], vt8[5], color })
		end
	end
end

---@type lstg.Color[]
local dye_circle_color = {
	Color(160, 255, 125, 160),
	Color(160, 107, 163, 255),
	Color(160, 121, 255, 100),
}

---@class EISlib.Enemy.Class.DyeCircle : lstg.Class
local dye_circle_class = Class(object)

---@class EISlib.Enemy.Object.DyeCircle : lstg.GameObject

---@param self EISlib.Enemy.Object.DyeCircle
function dye_circle_class.init(self, master)
	self.bound = false
	self.alpha = 0
	self.maxlife = 20
	self.life = self.maxlife
	self.dead = 0
	if IsValid(master) then
		self.master = master
		self.x = master.x
		self.y = master.y
		self.layer = master.layer - 0.1
		self.c_img = master.c_img
		self._type = master._type
		self.dye_range = master.dye_range
		self.sys_co = master.sys_co
	end
end

---@param self EISlib.Enemy.Object.DyeCircle
function dye_circle_class.frame(self)
	local master = self.master
	if IsValid(master) then
		--同步
		self.x = master.x
		self.y = master.y
		self.layer = master.layer - 0.1
		self.c_img = master.c_img
		self._type = master._type
		self.dye_range = master.dye_range
		self.sys_co = master.sys_co
		--透明度和计时器
		if master.sys_co > 0 then
			self.alpha = min(1, self.alpha + (1 / self.maxlife))
		else
			self.alpha = max(0, self.alpha - (1 / self.maxlife))
		end
		self.life = self.maxlife
		self.dead = 0
	else
		if self.life == self.maxlife then
			-- 运动惯性
			self.vx = self.dx
			self.vy = self.dy
		end
		self.alpha = max(0, self.alpha - (1 / self.maxlife))
		if self.life <= 0 or self.dead > 60 then
			self.status = "del"
		end
		self.life = self.life - 1
		self.dead = self.dead + 1
	end
end

---@param self EISlib.Enemy.Object.DyeCircle
function dye_circle_class.render(self)
	if self.c_img and self._type and self.dye_range > 0 then --不大于0也不渲染的！
		--local C0 = Color(self.alpha * 128, 255, 255, 255)
		dye_circle_color[self.sys_co].a = self.alpha * 160
		local CR = sin(self.alpha * 90) * self.dye_range
		local rscale = 16 / 30 -- 所需宽度/ 实际宽度
		--[=[
		local sr = CR - 30 * rscale -- 内圈需要内缩一些
		if sr > 0.00001 then
			--_render_circle(self.x, self.y, (self.ani % 100) + 1, sr, C1[self.sys_co])
			--[[
			SetImageState("_surrounding_light", "", C1[self.sys_co])
			Render("_surrounding_light", self.x, self.y, self.ani / 2, sr / 128)
			--]]
		end
		--]=]
		---[[
		local c_img = "white_circle"; --c_img = "black_circle";
		--0, 630, 512, 744
		if lstg.RenderTextureAnnulus then
			lstg.RenderTextureAnnulus(
					"_color_effect_texture", 512, 744, 0, 630, true, -- tex, u1, v1, u2, v2, tran
					"", dye_circle_color[self.sys_co], dye_circle_color[self.sys_co],
					self.x, self.y, -- x, y
					-self.ani / 2, -- rot
					CR - 74 * rscale, CR + 40 * rscale, -- r1, r2
					64, 2 -- div, rep
			)
		else
			EISlib.Render.RenderImageGroupRingH(c_img, 32, "", dye_circle_color[self.sys_co],
					self.x, self.y,
					CR - 74 * rscale, CR + 40 * rscale, -- 外圈位置偏移
					-self.ani / 2,
					2, true)
		end
		--]]
	end
end

----------------------------------------
---enemy system

---@class EISlib.Enemy.System : etc.class
local enemy_system = etc.class(false, false)

---@type table<boolean, string[]>
local color_index = {
	[true] = { "black_circle", "white_circle", "white_circle", nil }, -- red(black), blue(white), green, none
	[false] = { "enemy_color_red", "enemy_color_blue", "enemy_color_green", nil } -- red(black), blue(white), green, none
}

---@type string[]
local color_effect_index = {
	"enemy_color_red",
	"enemy_color_blue",
	"enemy_color_green"
}

---@param obj enemy.object
---@param type boolean @is dyeing unit or unit to dyed
---@param color number @form 1 to 4, red, blue, green, none
---@param range number
---@param drops number
---@return EISlib.Enemy.System
function enemy_system:constructor(obj, type, color, range, drops)
	self.obj = obj
	self.lastcolor = color or 4
	self.init = true --(color ~= nil)
	self:config(type or false, color or 4, range or 0, drops or 0)
	return self
end

---@param type boolean @is dyeing unit or unit to dyed
---@param color number @form 1 to 4, red, blue, green, none
---@param range number
---@param drops number
function enemy_system:config(type, color, range, drops)
	local obj = self.obj
	if self.init then
		-- 标志
		obj._type = type -- 大小怪类型
		obj.sys_co = color -- 系统颜色
		obj.dye_range = range --染色圈半径
		obj.nodrop = false
		obj._drop_num = drops --只填数字，代表掉落的道具数，如果该单位为大怪则不执行特殊的染色掉落
		obj.sys_co_alpha = 0 --法阵透明度变化
		if inrange(obj.sys_co, 1, 3) then
			--颜色4代表无色，不在范围之内
			obj.c_img = color_index[obj._type][obj.sys_co]
		end
		-- 染色状态
		obj.IsDye = (obj.c_img ~= nil) -- 是否被染色
		obj.bonus = 0 --现在用这个来计算连击奖励
		if not obj.IsDye then
			obj.bonus = 2
		else
			obj.bonus = 1
		end
		obj.double_dye = false -- 是否被二重染色
		-- 样式和染色圈
		if type and (not IsValid(obj._dye_circle_instance)) then
			obj._dye_circle_instance = New(dye_circle_class, obj)
		end
		if AUTO_SET_COLOR then
			obj._stylemgr:setStyle(M.ChangeStyleColor(obj._stylemgr:getStyle(), obj.sys_co))
		end
	end
end

function enemy_system:update()
	local obj = self.obj
	if self.init then
		if inrange(obj.sys_co, 1, 4) then
			if not obj._type then
				obj._stylemgr:setAlpha(0.6 + (player.lh * 0.4)) -- 同步人侧妖侧
			end
			obj.sys_co_alpha = min(obj.sys_co_alpha + 1 / 60, 1)
		else
			obj.sys_co_alpha = max(obj.sys_co_alpha - 1 / 60, 0)
		end
		if self.lastcolor ~= obj.sys_co and AUTO_SET_COLOR then
			obj._stylemgr:setStyle(M.ChangeStyleColor(obj._stylemgr:getStyle(), obj.sys_co))
		end
		--修改：就算是高速放b也要能清理全屏的小妖精
		if player.slow == 0 and (player.nextspell <= 0 or player.shield) then
			--if (not obj._type) and inrange(obj.sys_co, 1, 3) then
			if (not obj._type) and inrange(obj.sys_co, 1, 4) then
				--现在4代表无色，被包括进来了
				obj.colli = false
			end
		else
			obj.colli = true
		end
	else
		obj._stylemgr:setAlpha(1)
		--obj.sys_co_alpha = max(obj.sys_co_alpha - 1 / 60, 0)
	end
end

function enemy_system:draw_color()
	local obj = self.obj
	if self.init then
		if (not obj._type) and inrange(obj.sys_co, 1, 3) then
			local ani = color_effect_index[obj.sys_co]
			local scale = 0.6
			-- color
			local blend = ""
			local color = Color(obj.sys_co_alpha * 255, 255, 255, 255)
			if obj._blend then
				blend = obj._blend
				color = Color(obj.sys_co_alpha * obj._a, obj._r, obj._g, obj._b)
			end
			SetAnimationState(ani, blend, color)
			-- render
			if RenderAnimation then
				RenderAnimation(ani, obj.ani, obj.x, obj.y, obj.rot, obj.hscale * scale, obj.vscale * scale)
			else
				local lastimg = obj.img
				-- set
				obj.img = ani
				obj.hscale = obj.hscale * scale
				obj.vscale = obj.vscale * scale
				-- draw
				DefaultRenderFunc(obj)
				-- recover
				obj.img = lastimg
				obj.hscale = obj.hscale / scale
				obj.vscale = obj.vscale / scale
			end
		end
	end
end

function enemy_system:draw_hpbar()
	local obj = self.obj
	if self.init then
		if obj._type then
			draw_lifebar(obj.x, obj.y + 32, (obj.hp / obj.maxhp), nil, nil, self.obj._a or 255)
		end
	end
end

function enemy_system:drop_item()
	local obj = self.obj
	if self.init and not obj.double_dye then
		if inrange(obj.sys_co, 1, 3) then
			if obj.sys_co == 1 then
				--obj.drop = { obj._drop_num, 0, 0 }
				bonus_display(obj.x, obj.y, obj._drop_num, 0, 0, 0, 0, obj.sys_co)
			elseif obj.sys_co == 2 then
				--obj.drop = { 0, 0, obj._drop_num }
				bonus_display(obj.x, obj.y, 0, obj._drop_num, 0, 0, 0, obj.sys_co)
			else
				--obj.drop = { 0, obj._drop_num, 0 }
				bonus_display(obj.x, obj.y, 0, 0, obj._drop_num, 0, 0, 3)
			end
		else
			--obj.drop = { 0, obj._drop_num, 0 }
			bonus_display(obj.x, obj.y, 0, 0, obj._drop_num, 0, 0, 3)
		end
		--[[if obj.drop then
			local items = item.DropItem(obj.x, obj.y, obj.drop) -- {power, faith, point}
			if obj.double_dye == true then
				--判断是否为二重染色并自动收取道具
				for i = 1, #items do
					items[i].collected = true
					items[i].attract = max(items[i].attract, 3)
					items[i].target = player
				end
			end
		end]]
	end
end

function enemy_system:onkill()
	local obj = self.obj
	if self.init then
		if not obj.nodrop then
			if inrange(obj.sys_co, 1, 3) and obj._type and obj.dye_range > 0 then
				--判断是不是有色大怪
				local _drop = { 0, 0, 0, 0 }
				if obj.drop then
					_drop[1] = _drop[1] + obj.drop[1]
					_drop[2] = _drop[2] + obj.drop[3]
					_drop[3] = _drop[3] + obj.drop[2]
				end
				_drop[obj.sys_co] = _drop[obj.sys_co] + obj._drop_num
				obj.double_dye = true --这里是取消原本单个大怪被击破后显示的奖励
				EISlib.Enemy.CreateDyeCircle(obj.x, obj.y, obj.dye_range, obj.sys_co, _drop)
			end
			self:drop_item()
		end
	else
		if obj.drop then
			item.DropItem(obj.x, obj.y, obj.drop)
		end
	end
end

function enemy_system:oncolli()
	local obj = self.obj
	if self.init then
		if obj._type then
			-- system.setCurDamageEnemy(obj) -- 底端血条现在只显示boss的血量了
		end
	end
end

---@param dmg number
---@return number
function enemy_system:onDamage(dmg)
	local obj = self.obj
	if self.init then
		if player.slow == 0 then
			if (not obj._type) and inrange(obj.sys_co, 1, 3) then
				dmg = 0 -- 无法击中被染色小怪
			elseif obj._type and inrange(obj.sys_co, 1, 2) then
				-- 对染色大怪不受影响
			elseif not obj._type then
				dmg = min(dmg, 10) -- 其他情况伤害削减
			else
				-- 对普通大怪不受影响
			end
		else
			if (not obj._type) and inrange(obj.sys_co, 1, 2) then
				dmg = 2.5 * dmg -- 染色小怪受到伤害*2.5倍
			elseif obj._type and inrange(obj.sys_co, 1, 2) then
				dmg = min(dmg, 10) -- 对染色大怪伤害削减
			elseif not obj._type then
				-- 对普通小怪不受影响
			else
				-- 对普通大怪不受影响
			end
		end
	end
	return dmg
end

---[未使用]
function enemy_system:setDyeColor(color)
	local obj = self.obj
	if self.init then
		-- 大怪和暂时无判定的怪不被染色
		local double = false
		if (not obj._type) and obj.colli then
			if obj.IsDye then
				obj.sys_co = color -- 染色总是要最先执行
				obj.c_img = color_effect_index[color]
				obj.double_dye = true
				double = true
				Kill(obj)
			else
				obj.IsDye = true
				obj.sys_co = color --染色总是要最先执行
				obj.c_img = color_effect_index[color]
				task.New(obj, function()
					local limit = obj.maxhp
					for i = 1, 60 do
						limit = lerp(obj.maxhp, 10, i / 60)
						obj.hp = min(obj.hp, limit) -- 削弱
						task.Wait(1)
					end
				end)
			end
		end
		return double
	else
		return false
	end
end

----------------------------------------
---enemy base class

local enemybase_mt = {
	__index = function(t, k)
		if k == "colli" then
			return rawget(t, "_colli")
		else
			return GetAttr(t, k)
		end
	end,
	__newindex = function(t, k, v)
		if k == "colli" then
			rawset(t, "_colli", v)
		else
			SetAttr(t, k, v)
		end
	end,
}

---@class enemybase.class : lstg.Class
local enemybase_t = Class(object)
---@class enemybase.object : lstg.GameObject
enemybase_t._object = {}

---@param self enemybase.object
---@param hp number
---@param nontaijutsu boolean
function enemybase_t.init(self, hp, nontaijutsu)
	self.layer = LAYER_ENEMY
	if nontaijutsu then
		self.group = GROUP_NONTJT
	else
		self.group = GROUP_ENEMY
	end
	self.bound = false
	self.colli = false
	self._colli = true
	self.dmgrate = 1 -- only used in enemy define and boss define, not in enemy base
	self.maxhp = hp or 1
	self.hp = hp or 1
	self._master = nil
	self._servants = {}
	---@type number
	self._dmg_transfer = nil
	self.colli = true
end

---@param self enemybase.object
function enemybase_t.frame(self)
	local w = lstg.world
	if self.hp <= 0 then
		Kill(self)
	end
	task.Do(self)
end

---@param self enemybase.object
---@param other object
function enemybase_t.colli(self, other)
	if other.dmg then
		enemybase_t.damage(self, other.dmg)
	end
	other.killerenemy = self
	if not (other.killflag) then
		Kill(other)
	end
	if not other.mute then
		EISlib.Effect.DamageEnemyEffect(self)
	end
end

---@param self enemybase.object
function enemybase_t.del(self)
	_del_servants(self)
end

---@param self enemybase.object
function enemybase_t.kill(self)
	_kill_servants(self)
end

---@param obj enemybase.object
---@param dmg number
function enemybase_t.damage(obj, dmg)
	-- find callback function in object.class
	local take_damage
	local class = obj.class
	while class do
		if class.take_damage then
			take_damage = class.take_damage
			break
		else
			class = class.base -- switch to base
		end
	end
	-- callback
	if take_damage then
		take_damage(obj, dmg)
	end
	-- damage master
	if obj._master and IsValid(obj._master) and obj._dmg_transfer then
		enemybase_t.damage(obj._master, dmg * obj._dmg_transfer)
	end
end

---[即将弃用的方法，请使用 enemybase.damage ]
---@param obj enemybase.object
---@param dmg number
function Damage(obj, dmg)
	enemybase_t.damage(obj, dmg)
end

----------------------------------------
---enemy class

---@class enemy.class : enemybase.class
local enemy_t = Class(enemybase_t)
---@class enemy.object : enemybase.object
enemy_t._object = {}

---@param self enemy.object
---@param style number
---@param hp number
---@param clear_bullet boolean
---@param auto_delete boolean
---@param nontaijutsu boolean
function enemy_t.init(self, style, hp, clear_bullet, auto_delete, nontaijutsu, dye_type, dye_color, dye_range, drop, no_count)
	--基本参数
	enemybase_t.init(self, hp, nontaijutsu)
	self.clear_bullet = clear_bullet
	self.auto_delete = auto_delete
	self.no_count = no_count
	--行走图系统
	self.dmgt = 0--可以赋值为nil取消伤害闪烁
	self.dmgmaxt = 8--可以赋值为nil取消伤害闪烁
	--小怪外观样式
	self._stylemgr = stylemgr.new():constructor(self)
	enemy_t.change_style(self, style)
	--系统相关
	self._system = enemy_system.new():constructor(self, dye_type, dye_color, dye_range, drop, 0)
	if not self.no_count then
		system.addEnemyCreateCount(1)
	end
end

---@param self enemy.object
function enemy_t.frame(self)
	enemybase_t.frame(self)
	self._stylemgr:update()
	if self.dmgt and self.dmgmaxt then
		self.dmgt = max(0, self.dmgt - 1)
	end
	if self.auto_delete then
		local w = lstg.world
		if BoxCheck(self, w.boundl, w.boundr, w.boundb, w.boundt) then
			self.auto_delete = false--跳过判断
			self.bound = true
		end
	end
	--qhm system
	self._system:update()
end

---@param self enemy.object
function enemy_t.render(self)
	self._stylemgr:draw()
	self._system:draw_color()
	self._system:draw_hpbar()
end

---普通的击破小怪（其实就是以前的kill复制过来
local function normal_kill(self)
	enemybase_t.kill(self)
	self._system:onkill()
	--local w = lstg.world
	--if BoxCheck(self, w.l, w.r, w.b, w.t) then
	--	New(enemy_death_ef, self._death_color, self.x, self.y, max(self.hscale, self.vscale), false)
	--end
	New(enemy_death_ef, self._death_color, self.x, self.y, max(self.hscale, self.vscale), false)
	if not self.no_count then
		system.addEnemyKillCount(1)
	end
	if self.clear_bullet then
		New(bullet_killer, self.x, self.y, false)
	end
end

---正常死亡
---@param self enemy.object
function enemy_t.kill(self)
	normal_kill(self)
end

---被二重染色所击杀
---@param self enemy.object
function enemy_t.dyeKill(self)
	normal_kill(self)
end

---@param self enemy.object
function enemy_t.del(self)
	enemybase_t.del(self)
	local w = lstg.world
	if BoxCheck(self, w.l, w.r, w.b, w.t) then
		New(enemy_death_ef, self._death_color, self.x, self.y, max(self.hscale, self.vscale), false)
	end
end

---@param self enemy.object
---@param other object
function enemy_t.colli(self, other)
	enemybase_t.colli(self, other)
	self._system:oncolli()
end

---@param self enemy.object
---@param dmg number
function enemy_t.take_damage(self, dmg)
	if self.dmgmaxt then
		self.dmgt = self.dmgmaxt
	end
	if not self.protect then
		local _dmg = dmg * self.dmgrate
		_dmg = self._system:onDamage(_dmg)
		system.damageEnemyBonus(_dmg)
		self.hp = self.hp - _dmg
	end
end

---@param self enemy.object
---@param style number
function enemy_t.change_style(self, style)
	if AUTO_SET_COLOR then
		local c = M.GetStyleColor(self._stylemgr:getStyle())
		local s = M.ChangeStyleColor(style, c)
		self._stylemgr:setStyle(s)
	else
		self._stylemgr:setStyle(style)
	end
end

----------------------------------------
---simple enemy class

---@class enemy.simple.class : enemy.class
local enemy_simple = Class(enemy_t)
---@class enemy.simple.object : enemy.object
enemy_simple._object = {}

---@param self enemy.simple.object
---@param style number
---@param hp number
---@param x number
---@param y number
---@param drop number[]
---@param pro number @protect time
---@param clr boolean @auto clear bullet
---@param bound boolean @auto delete
---@param tjt boolean @body can't damage player
---@param tf fun(self:enemy.simple.object)
function enemy_simple.init(self, style, hp, x, y, drop, pro, clr, bound, tjt, tf)
	enemy_t.init(self, style, hp, clr, bound, tjt)
	self.x, self.y = x, y
	self.drop = drop
	self.protect = true
	task.New(self, function()
		task.Wait(pro)
		self.protect = false
	end)
	tf(self)
end

----------------------------------------
---out

---@type enemybase.class
enemybase = enemybase_t
---@type enemy.class
enemy = enemy_t
---@type enemy.simple.class
EnemySimple = enemy_simple

----------------------------------------
---interface

stg = stg or {}

---@param style number
---@param hp number
---@param x number
---@param y number
---@param auto_delete boolean
---@param no_physical_attack boolean
---@return enemy.object
function stg.newEnemy(style, hp, x, y, auto_delete, no_physical_attack)
	local obj = New(enemy_t, style, hp, false, auto_delete, no_physical_attack,
			false, 4, 0, 0, 0)
	obj.x = x
	obj.y = y
	return obj
end

---@param style number
---@param hp number
---@param x number
---@param y number
---@param protect number
---@param clear_bullet boolean
---@param auto_delete boolean
---@param no_physical_attack boolean
---@param init_callback fun(self:enemy.simple.object)
---@return enemy.simple.object
function stg.newSimpleEnemy(style, hp, x, y, protect, clear_bullet, auto_delete, no_physical_attack, init_callback)
	return New(enemy_simple,
			style, hp, x, y, { 0, 0, 0 }, protect, clear_bullet, auto_delete, no_physical_attack, init_callback)
end

---@param obj enemy.object
---@param style number
---@return enemy.object
function stg.setEnemyStyle(obj, style)
	enemy_t.change_style(obj, style)
	return obj
end

---@param obj enemy.object
---@param dye_type boolean
---@param sys_color number
---@param dye_range number
---@param drop_items number
---@return enemy.object
function stg.setEnemySystemData(obj, dye_type, sys_color, dye_range, drop_items)
	obj._system:config(dye_type, sys_color, dye_range, drop_items, 0)
	return obj
end
