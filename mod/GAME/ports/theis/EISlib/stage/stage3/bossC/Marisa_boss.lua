lstg.wis = lstg.wis or {}

local _ACT_NONE_AUTO_Marisa, _ACT_CAST_Marisa

--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Marisa_boss"
local texFile = "res/stage/stage3/Marisa_boss.png"
local tex_u, tex_v, tex_n = 210, 210, 10

--加载资源
local function load_pic()
	--立绘加载
	local path = "res/stage/stage3/"
	if not lstg.CheckRes(2, "s3C1boss_pic") then
		LoadImageFromFile("s3C1boss_pic", path .. "s3C1boss_pic.png", false)
		LoadImageFromFile("s3C2boss_pic", path .. "s3C2boss_pic.png", false)
	end
end
local function load_res()
	load_pic()
	if not lstg.CheckRes(1, tex) then
		--载入行走图资源
		LoadTexture(tex, texFile)
		local path = ""
		--三面结界组C线boss符卡背景
		path = "res/background/boss3c/"
		LoadImageGroupFromFile("s3C_boss_scbg1_", path .. "s3C_boss_scbg1.png", true, 1, 32, 0, 0, 0)
		for n = 1, 32 do
			SetImageState("s3C_boss_scbg1_" .. n, "mul+sub", Color(0xc0ffffff))
		end
		LoadImageFromFile("s3C_boss_scbg2", path .. "s3C_boss_scbg2.png", true, 0, 0, false, 0)
		--阿卡斯的素材加载（名字我也不敢乱动
		path = "res/stage/stage3/season_res/"
		_LoadImageFromFile('image:' .. "seasons_effectcircle1", path .. "seasons_effectcircle1.png", true, 0, 0, false, 0)
		_LoadImageFromFile('image:' .. "seasons_forge_circle1", path .. "seasons_forge_circle1.png", true, 0, 0, false, 0)
		_LoadImageFromFile('image:' .. "seasons_forge_ring1", path .. "seasons_forge_ring1.png", true, 0, 0, false, 0)
		_LoadImageFromFile('image:' .. "seasons_forge_ring2", path .. "seasons_forge_ring2.png", true, 0, 0, false, 0)
		_LoadImageFromFile('image:' .. "seasons_forge_ring3", path .. "seasons_forge_ring3.png", true, 0, 0, false, 0)
		_LoadImageFromFile('image:' .. "seasons_forge_ring4", path .. "seasons_forge_ring4.png", true, 0, 0, false, 0)
		_LoadImageFromFile('image:' .. "seasons_forge_ring5", path .. "seasons_forge_ring5.png", true, 0, 0, false, 0)
		_LoadImageFromFile('image:' .. "seasons_forge_ring6", path .. "seasons_forge_ring6.png", true, 0, 0, false, 0)
		LoadTexture('texture:' .. "qhm_nuclear", path .. "qhm_nuclear.png", true)
		LoadImage("qhm_nuclear01", 'texture:' .. "qhm_nuclear", 0, 0, 512, 512, 160, 160)
		LoadImage("qhm_nuclear02", 'texture:' .. "qhm_nuclear", 0, 512, 512, 512, 160, 160)
	end
end
load_res()

--通常
do
	local id, anime, list
	local cutFrame = 8
	local wi = {
		["normal"] = {
			id = { 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 8, 9, 10 },
		},
		["left"] = {
			id = { 11, 12, 13, 14, 15, 16, 17 },
			loop = 3,
		},
		["right"] = {
			id = { 21, 22, 23, 24, 25, 26, 27 },
			loop = 3,
		},
	}
	function _ACT_NONE_AUTO_Marisa(wisys, self, actionCount, actionCountMax)
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
	local id = { 31, 32, 33, 34, 35, 36, 37 }
	local loop = 7
	local tran = #id - loop
	function _ACT_CAST_Marisa(wisys, self, actionCount, actionCountMax)
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
		self.img = "s3C1boss_pic"
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
			New(spell_open_circle_eff, 0, 0, 255, 255, 0, 'marisa_star', 'yuyuko_ghost')  --配合开卡立绘的特效
			misc.ShakeScreen(10, 3)
		end)
	end
	local pic2 = Class(object)
	function pic2:init(IsSingle)
		self.img = "s3C2boss_pic"
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
			New(spell_open_circle_eff, 0, 0, 255, 50, 255, 'marisa_star', 'yuyuko_ghost')  --配合开卡立绘的特效
			misc.ShakeScreen(10, 3)
		end)
	end
	--双人开卡
	function pic_show3()
		New(tasker, function()
			New(pic1)
			New(pic2)
			task.Wait(20)
			New(spell_open_circle_eff, 0, 0, 255, 255, 0, 'marisa_star', 'yuyuko_ghost')  --配合开卡立绘的特效
			misc.ShakeScreen(10, 3)
		end)
	end
end
s3C_boss.pic_show1 = pic_show1
s3C_boss.pic_show2 = pic_show2
s3C_boss.pic_show3 = pic_show3

--符卡背景
local scbg = Class(_spellcard_background)
function scbg:init()
	_spellcard_background.init(self)
	_spellcard_background.AddLayer(self, "img_void", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
			function(self)
				self.edge = 0
				self.edge_inc = 2
				self.radius = 192
				self.angle = 0
				self.angle_inc = -0.3
				self.u = 0
				self.v = 64
			end,
			function(self)
				task.Do(self)
				self.edge = (self.edge + self.edge_inc) % self.radius
				self.angle = self.angle + self.angle_inc
			end,
			function(self)
				misc.RenderRing("s3C_boss_scbg1_", self.u, self.v, 0, self.edge, self.angle, 64, 32)
				for i = 0, 2 do
					misc.RenderRing("s3C_boss_scbg1_", self.u, self.v, self.edge + self.radius * i, self.edge + self.radius * (i + 1), self.angle, 64, 32)
				end
			end
	)
	_spellcard_background.AddLayer(self, "s3C_boss_scbg2", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
			function(self)
				self.a = 96
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
			end
	)
end
s3C_boss.scbg = scbg

--设置行走图
function lstg.wis.Marisa(self)
	self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
	self._wisys:connectAction("normal", _ACT_NONE_AUTO_Marisa)
	self._wisys:connectAction("cast", _ACT_CAST_Marisa)
	self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 255, 0, "mul+add"
	self.saoqi = New(boss_saoqi, self)
end
