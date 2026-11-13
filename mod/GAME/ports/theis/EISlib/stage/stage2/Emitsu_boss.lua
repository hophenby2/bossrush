lstg.wis = lstg.wis or {}
s2_boss = s2_boss or {}

--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Emitsu_boss"
local texFile = "res/stage/stage2/Emitsu_boss.png"
local tex_u, tex_v, tex_n = 160, 190, 9

local function load_res()
	--载入行走图资源
	LoadTexture(tex, texFile)
	local path = ""
	--二面boss符卡背景
	path = "res/background/boss2/"
	LoadImageFromFile("s2_boss_scbg1", path .. "scbg1.png", true, 0, 0, false, 0)
	LoadImageFromFile("s2_boss_scbg2", path .. "scbg2.png", true, 0, 0, false, 0)
	LoadImageFromFile("s2_boss_scbg3", path .. "scbg3.png", true, 0, 0, false, 0)
	--立绘加载
	path = "res/stage/stage2/"
	LoadImageFromFile("s2boss_pic", path .. "s2boss_pic.png", true, 0, 0, false, 0)
	--二boss道具
	_LoadImageGroupFromFile('image:' .. "mgmk", path .. "mgmk.png", true, 4, 1, 0, 0, 0)
	LoadAniFromFile('ani:' .. "s2_fire_drop", path .. "s2_fire_drop.png", true, 1, 4, 4, 0, 0, false)
	LoadAniFromFile('ani:' .. "s2_water_drop", path .. "s2_water_drop.png", true, 1, 4, 4, 0, 0, false)
end
load_res()

local _ACT_NONE_AUTO_Emitsu, _ACT_CAST_Emitsu
--通常
do
	local id, anime, list
	local cutFrame = 8
	local wi = {
		["normal"] = {
			id = { 1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9 },
		},
		["left"] = {
			id = { 19, 20, 21, 22, 23, 24, 25 },
			loop = 3,
		},
		["right"] = {
			id = { 10, 11, 12, 13, 14, 15, 16 },
			loop = 3,
		},
	}
	function _ACT_NONE_AUTO_Emitsu(wisys, self, actionCount, actionCountMax)
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
	local id = { 28, 29, 30, 31, 32, 33 }
	local loop = 4
	local tran = #id - loop
	function _ACT_CAST_Emitsu(wisys, self, actionCount, actionCountMax)
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

--二面立绘演出
local pic = Class(object)
function pic:init()
	self.x, self.y = 0, 100
	self.img = "s2boss_pic"
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
	Render(self.img, self.x, self.y, 0, self.size, self.size)
	for _, o in ipairs(self.trails) do
		SetImgState(self, "", o[5], 255, 255, 255)
		Render(self.img, o[1], o[2], 0, o[3], o[4])
	end
end

function s2_boss.pic_show()
	New(tasker, function()
		New(pic)
		task.Wait(20)
		New(spell_open_circle_eff, -80, 100, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')  --配合开卡立绘的特效
		misc.ShakeScreen(10, 3)
	end)
end

--二面符卡背景
local scbg = Class(_spellcard_background)
s2_boss.scbg = scbg
function scbg:init()
	_spellcard_background.init(self)
	_spellcard_background.AddLayer(self, "s2_boss_scbg1", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
			function(self)
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
			end
	)
	_spellcard_background.AddLayer(self, "s2_boss_scbg3", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
			function(self)
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
				self.a = 170 + 40 * sin(self.timer)
			end
	)
	_spellcard_background.AddLayer(self, "s2_boss_scbg2", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
			function(self)
			end,
			function(self)
				task.Do(self)
			end,
			function(self)
			end
	)
end

--设置行走图
function lstg.wis.Emitsu(self)
	self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
	self._wisys:connectAction("normal", _ACT_NONE_AUTO_Emitsu)
	self._wisys:connectAction("cast", _ACT_CAST_Emitsu)
	self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 255, "mul+add"
	self.saoqi = New(boss_saoqi, self)
end
