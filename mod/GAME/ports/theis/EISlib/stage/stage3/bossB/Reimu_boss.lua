lstg.wis = lstg.wis or {}

local _ACT_NONE_AUTO_Reimu, _ACT_CAST_Reimu

--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Reimu_boss"
local texFile = "res/stage/stage3/Reimu_boss.png"
local tex_u, tex_v, tex_n = 220, 240, 10

--载入行走图资源
LoadTexture(tex, texFile)
--加载其他资源
do
	local path = ""
	--三面结界组B线boss符卡背景
	path = "res/background/boss3b/"
	LoadImageFromFile("s3B_boss_scbg1", path .. "scbgB1.png", true, 0, 0, false, 0)
	LoadImageFromFile("s3B_boss_scbg2", path .. "scbgB2.png", true, 0, 0, false, 0)
	LoadImageFromFile("s3B_boss_scbg3", path .. "scbgB3.png", true, 0, 0, false, 0)
	--立绘加载
	path = "res/stage/stage3/"
	LoadImageFromFile("s3B1boss_pic", path .. "s3B1boss_pic.png", true, 0, 0, false, 0)
	LoadImageFromFile("s3B2boss_pic", path .. "s3B2boss_pic.png", true, 0, 0, false, 0)
end
--通常
do
	local id, anime, list
	local cutFrame = 8
	local wi = {
		["normal"] = {
			id = { 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 8, 9, 10 },
		},
		["left"] = {
			id = { 21, 22, 23, 24, 25, 26, 27 },
			loop = 3,
		},
		["right"] = {
			id = { 11, 12, 13, 14, 15, 16, 17 },
			loop = 3,
		},
	}
	function _ACT_NONE_AUTO_Reimu(wisys, self, actionCount, actionCountMax)
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
	local id = { 31, 32, 33, 34, 35, 36 }
	local loop = 5
	local tran = #id - loop
	function _ACT_CAST_Reimu(wisys, self, actionCount, actionCountMax)
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

--三面B线立绘演出
local pic_show1, pic_show2, pic_show3
do
	local pic1 = Class(object)
	function pic1:init()
		self.img = "s3B1boss_pic"
		self.layer = LAYER_TOP + 1
		self.group = GROUP_GHOST
		_object.set_color(self, "", 0, 255, 255, 255)
		self.x, self.y = -90, 50
		self.bound = false
		self.hscale, self.vscale = 1, 1
		self.size = 1
		self.trails = {}
		task.New(self, function()
			egg.AddSimStrChV(self, 10, 1, -20, 30)
			egg.AddSimStrChV(self, 0, 4, 10, 70, 60)
			egg.SimAlpCh(self, 0, 255, 10)
			for _ = 1, 40 do
				table.insert(self.trails, { self.x, self.y, self.size, self.size, 20 }) --x, y, hscale, vscale, _a
				task.Wait(1)
			end
			task.Wait(30)
			egg.SimAlpCh(self, 255, 0, 60)
			task.Wait(60)
			Del(self)
		end)
	end
	function pic1:frame()
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
	function pic1:render()
		SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
		Render(self.img, self.x, self.y, 0, self.size, self.size)
		for _, o in ipairs(self.trails) do
			SetImgState(self, "", o[5], 255, 255, 255)
			Render(self.img, o[1], o[2], 0, o[3], o[4])
		end
	end
	function pic_show1()
		New(tasker, function()
			New(pic1)
			task.Wait(20)
			New(spell_open_circle_eff, 0, 0, 255, 0, 0, 'yukari_star', 'reimu_leaf')  --配合开卡立绘的特效
			misc.ShakeScreen(10, 3)
		end)
	end
	local pic2 = Class(object)
	function pic2:init(IsSingle)
		self.img = "s3B2boss_pic"
		self.layer = LAYER_TOP + 1
		self.group = GROUP_GHOST
		_object.set_color(self, "", 0, 255, 255, 255)
		self.bound = false
		self.hscale, self.vscale = 1, 1
		self.size = 1
		self.trails = {}
		task.New(self, function()
			if IsSingle then
				self.x, self.y = 120, 50
				egg.AddSimStrChV(self, 8, 1, 200, 30)
				egg.AddSimStrChV(self, 0, 4, 170, 70, 60)
			else
				self.x, self.y = 90, 50
				egg.AddSimStrChV(self, 10, 1, 200, 30)
				egg.AddSimStrChV(self, 0, 4, 170, 70, 60)
			end
			egg.SimAlpCh(self, 0, 255, 10)
			for _ = 1, 40 do
				table.insert(self.trails, { self.x, self.y, self.size, self.size, 20 }) --x, y, hscale, vscale, _a
				task.Wait(1)
			end
			task.Wait(30)
			egg.SimAlpCh(self, 255, 0, 60)
			task.Wait(60)
			Del(self)
		end)
	end
	function pic2:frame()
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
	function pic2:render()
		SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
		Render(self.img, self.x, self.y, 0, self.size, self.size)
		for _, o in ipairs(self.trails) do
			SetImgState(self, "", o[5], 255, 255, 255)
			Render(self.img, o[1], o[2], 0, o[3], o[4])
		end
	end
	function pic_show2()
		New(tasker, function()
			New(pic2, true)
			task.Wait(20)
			New(spell_open_circle_eff, 0, 0, 255, 0, 255, 'yukari_star', 'reimu_leaf')  --配合开卡立绘的特效
			misc.ShakeScreen(10, 3)
		end)
	end
	--双人开卡
	function pic_show3()
		New(tasker, function()
			New(pic1)
			New(pic2)
			task.Wait(20)
			New(spell_open_circle_eff, 0, 0, 200, 0, 200, 'yukari_star', 'reimu_leaf')  --配合开卡立绘的特效
			misc.ShakeScreen(10, 3)
		end)
	end
end
s3B_boss.pic_show1 = pic_show1
s3B_boss.pic_show2 = pic_show2
s3B_boss.pic_show3 = pic_show3

--三面B线符卡背景
local scbg = Class(_spellcard_background)
function scbg:init()
	_spellcard_background.init(self)
	_spellcard_background.AddLayer(self, "s3B_boss_scbg2", false, 0, 0, 0, 0, 0, 0.8, "", 1, 1,
			function(self)
				self.vscale = 1
				self.hscale = 1
				self.a = 160
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
			end
	)
	_spellcard_background.AddLayer(self, "s3B_boss_scbg1", false, 0, 0, 0, 0, 0, 0, "", 0.5, 0.5,
			function(self)
				self.vscale = 0.6
				self.hscale = 0.6
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
			end
	)
end
s3B_boss.scbg = scbg

--设置行走图
function lstg.wis.Reimu(self)
	self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
	self._wisys:connectAction("normal", _ACT_NONE_AUTO_Reimu)
	self._wisys:connectAction("cast", _ACT_CAST_Reimu)
	self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 0, 0, "mul+add"
	self.saoqi = New(boss_saoqi, self)
end
