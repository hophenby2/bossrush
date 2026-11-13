lstg.wis = lstg.wis or {}

local _ACT_NONE_AUTO_Keine, _ACT_CAST_Keine

--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Keine_boss"
local texFile = "res/stage/stage3/Keine_boss.png"
local tex_u, tex_v, tex_n = 174, 174, 8

--载入行走图资源
LoadTexture(tex, texFile)

--通常
do
	local id, anime, list
	local cutFrame = 8
	local wi = {
		["normal"] = {
			id = { 1, 2, 3, 4, 5, 1, 2, 6, 7, 8 },
		},
		["left"] = {
			id = { 17, 18, 19, 20, 21, 22 },
			loop = 2,
		},
		["right"] = {
			id = { 9, 10, 11, 12, 13, 14 },
			loop = 2,
		},
	}
	function _ACT_NONE_AUTO_Keine(wisys, self, actionCount, actionCountMax)
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
	local id = { 25, 26, 27, 28, 29, 30 }
	local loop = 3
	local tran = #id - loop
	function _ACT_CAST_Keine(wisys, self, actionCount, actionCountMax)
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


--设置行走图
function lstg.wis.Keine(self)
	self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
	self._wisys:connectAction("normal", _ACT_NONE_AUTO_Keine)
	self._wisys:connectAction("cast", _ACT_CAST_Keine)
    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 255, "mul+add"
    self.saoqi = New(boss_saoqi, self)
end
