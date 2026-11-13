lstg.wis = lstg.wis or {}
s1_boss = s1_boss or {} --一boss内容表

--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Kaguya_boss"
local tex_u, tex_v, tex_n = 150, 174, 8

--加载其他资源
local function load_res()
	local path = ""
	--一面boss符卡背景
	path = "res/background/boss1/"
	LoadImageFromFile("s1_boss_scbg1", path .. "scbg1.png", true, 0, 0, false, 0)
	LoadImageFromFile("s1_boss_scbg2", path .. "scbg2.png", true, 0, 0, false, 0)
	LoadImageFromFile("s1_boss_scbg3", path .. "scbg3.png", true, 0, 0, false, 0)
	path = "res/stage/stage1/"
	LoadTexture(tex, path .. "Kaguya_boss.png")--载入行走图资源
	LoadImageFromFile("s1boss_pic", path .. "s1boss_pic.png", true, 0, 0, false, 0)--立绘加载
end
load_res()

local _ACT_NONE_AUTO_Kaguya, _ACT_CAST_Kaguya, _ACT_CAST_Kaguya1, _ACT_CAST_Kaguya2, _ACT_CAST_Kaguya3
--通常
do
	local id, anime, list
	local cutFrame = 8
	local wi = {
		["normal"] = {
			id = { 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 6, 7, 8 },
		},
		["left"] = {
			id = { 17, 18, 19, 20, 21 },
			loop = 3,
		},
		["right"] = {
			id = { 9, 10, 11, 12, 13 },
			loop = 3,
		},
	}
	function _ACT_NONE_AUTO_Kaguya(wisys, self, actionCount, actionCountMax)
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
			hscale = list.hscale or hscale
		elseif self.lr == -28 then
			list = wi["left"]
			anime = int(self.ani / cutFrame) % list.loop + 1
			id = list.id[#list.id - list.loop + anime]
			hscale = list.hscale or hscale
		elseif self.lr > 1 then
			list = wi["right"]
			anime = int((self.lr / 28) * #list.id) + 1
			id = list.id[anime]
			hscale = list.hscale or hscale
		elseif self.lr < -1 then
			list = wi["left"]
			anime = int((self.lr / 28) * #list.id) + 1
			id = list.id[anime]
			hscale = list.hscale or hscale
		end
		return id, hscale, vscale
	end
end
--施法
do
	local cutFrame = 8
	local id = { 25, 26, 27, 28, 29, 30, 31, 33, 32, 33, 31, 36, 34, 36 }
	local loop = 7
	local tran = #id - loop
	function _ACT_CAST_Kaguya(wisys, self, actionCount, actionCountMax)
		local anime = int(actionCount / cutFrame)
		local anime_max = int((actionCountMax - actionCount) / cutFrame)
		local n
		if anime_max < tran then
			n = anime_max + 1
		elseif anime >= tran then
			n = tran + (anime - tran) % loop
		else
			n = anime + 1
		end
		return id[n], hscale, vscale
	end
end
--加快1
do
	local cutFrame = 6
	local id = { 31, 33, 32, 33, 31, 36, 34, 36 }
	local loop = 7
	local tran = #id - loop
	function _ACT_CAST_Kaguya1(wisys, self, actionCount, actionCountMax)
		local anime = int(actionCount / cutFrame)
		local anime_max = int((actionCountMax - actionCount) / cutFrame)
		local n
		if anime_max < tran then
			n = anime_max + 1
		elseif anime >= tran then
			n = tran + (anime - tran) % loop
		else
			n = anime + 1
		end
		return id[n], hscale, vscale
	end
end
--加快2
do
	local cutFrame = 4
	local id = { 31, 33, 32, 33, 31, 36, 34, 36 }
	local loop = 7
	local tran = #id - loop
	function _ACT_CAST_Kaguya2(wisys, self, actionCount, actionCountMax)
		local anime = int(actionCount / cutFrame)
		local anime_max = int((actionCountMax - actionCount) / cutFrame)
		local n
		if anime_max < tran then
			n = anime_max + 1
		elseif anime >= tran then
			n = tran + (anime - tran) % loop
		else
			n = anime + 1
		end
		return id[n], hscale, vscale
	end
end
--把箱子收起来
do
	local cutFrame = 8
	local id = { 31, 30, 29, 28, 27, 26, 25, 25, 25, 25, 25 }
	local loop = 10
	local tran = #id - loop
	function _ACT_CAST_Kaguya3(wisys, self, actionCount, actionCountMax)
		local anime = int(actionCount / cutFrame)
		local anime_max = int((actionCountMax - actionCount) / cutFrame)
		local n
		if anime_max < tran then
			n = anime_max + 1
		elseif anime >= tran then
			n = tran + (anime - tran) % loop
		else
			n = anime + 1
		end
		return id[n], hscale, vscale
	end
end

--一面符卡背景
local scbg = Class(_spellcard_background)
function scbg:init()
	_spellcard_background.init(self)
	_spellcard_background.AddLayer(self, "s1_boss_scbg3", true, 0, 0, 0, 0.4, 0.4, 0, "mul+add", 1, 1,
			function(self)
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
				self.a = 64 + 64 * (0.5 * (1 + sin(self.timer / 2 + 180)))
			end
	)
	_spellcard_background.AddLayer(self, "s1_boss_scbg2", false, 0, 0, 0, 0, 0, 0.5, "mul+add", 1, 1,
			function(self)
				self.vscale = 1.15
				self.hscale = 1.15
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
				self.a = 120 + 50 * sin(self.timer / 2)
			end
	)
	_spellcard_background.AddLayer(self, "s1_boss_scbg1", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
			function(self)
				self.vscale = 1.05
				self.hscale = 1.05
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
			end
	)
end
s1_boss.scbg = scbg

local pic = Class(object)
function pic:init()
	self.x, self.y = 0, 100
	self.img = "s1boss_pic"
	self.layer = LAYER_TOP + 1
	self.group = GROUP_GHOST
	_object.set_color(self, "", 0, 255, 255, 255)
	self.x, self.y = 120, 50
	self.bound = false
	self.hscale, self.vscale = 1, 1
	self.size = 1
	self.trails = {}
	task.New(self, function()
		egg.AddSimStrChV(self, 8, 1, 200, 30)
		egg.AddSimStrChV(self, 0, 4, 170, 70, 60)
		egg.SimAlpCh(self, 0, 255, 30)
		for _ = 1, 60 do
			table.insert(self.trails, { self.x, self.y, self.size, self.size, 20 }) --x, y, hscale, vscale, _a
			task.Wait(1)
		end
		task.Wait(20)
		egg.SimAlpCh(self, 255, 0, 20)
		task.Wait(20)
		Del(self)
	end)
end
function pic:frame()
	task.Do(self)
	for _, o in ipairs(self.trails) do
		o[3] = o[3] + 0.01
		o[4] = o[4] + 0.01
		o[5] = o[5] - 1.5
		if o[5] <= 0 then
			table.remove(self.trails, 1)
		end
	end
end
function pic:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	--SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
	Render(self.img, self.x, self.y, 0, self.size, self.size)
	for _, o in ipairs(self.trails) do
		SetImgState(self, "", o[5], 255, 255, 255)
		Render(self.img, o[1], o[2], 0, o[3], o[4])
	end
end

-- 一面立绘演出
local function pic_show()
	New(tasker, function()
		New(pic)
		task.Wait(20)
		New(spell_open_circle_eff, 0, 0, 70, 150, 90, "bamboo_leaf_white", "tree_leaf_white")  --配合开卡立绘的特效
		misc.ShakeScreen(10, 3)
	end)
end
s1_boss.pic_show = pic_show

--设置行走图
function lstg.wis.Kaguya(self)
	self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
	self._wisys:connectAction("normal", _ACT_NONE_AUTO_Kaguya)
	self._wisys:connectAction("cast", _ACT_CAST_Kaguya)
	self._wisys:connectAction("cast1", _ACT_CAST_Kaguya1)
	self._wisys:connectAction("cast2", _ACT_CAST_Kaguya2)
	self._wisys:connectAction("cast3", _ACT_CAST_Kaguya3)
	self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 0, "mul+add"
	self.saoqi = New(boss_saoqi, self)
end
