lstg.wis = lstg.wis or {}
s1_mid_boss = {}
local _ACT_NONE_AUTO_Mid_Fairy

--行走图设置
local hscale, vscale = 0.65, 0.65
local tex = 'Fairy_boss'
local texFile = 'res/stage/stage1/Fairy_boss.png'
local tex_u, tex_v, tex_n = 120, 120, 8
--载入行走图资源
LoadTexture(tex, texFile)

--通常
do
	local id, anime, list
	local cutFrame = 8
	local wi = {
		["normal"] = {
			id = { 1, 2, 3, 4, 3, 2 },
			loop = 5,
		},
		["right"] = {
			id = { 5, 6, 7, 8, 9 },
			loop = 3,
		},
	}
	function _ACT_NONE_AUTO_Mid_Fairy(wisys, self, actionCount, actionCountMax)
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
			hscale = abs(list.hscale or hscale)
		elseif self.lr == 28 then
			list = wi["right"]
			anime = int(self.ani / cutFrame) % list.loop + 1
			id = list.id[#list.id - list.loop + anime]
			hscale = abs(list.hscale or hscale)
		elseif self.lr == -28 then
			--左
			list = wi["right"]
			anime = int(self.ani / cutFrame) % list.loop + 1
			id = list.id[#list.id - list.loop + anime]
			hscale = -abs(list.hscale or hscale)
		elseif self.lr > 1 then
			list = wi["right"]
			anime = int((self.lr / 28) * #list.id) + 1
			id = list.id[anime]
			hscale = abs(list.hscale or hscale)
		elseif self.lr < -1 then
			--左
			list = wi["right"]
			anime = int((self.lr / 28) * #list.id) + 1
			id = list.id[anime]
			hscale = -abs(list.hscale or hscale)
		end
		return id, hscale, vscale
	end
end

--设置行走图
function lstg.wis.Mid_Fairy(self)
	self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
	self._wisys:connectAction("normal", _ACT_NONE_AUTO_Mid_Fairy)
	self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 0, "mul+add"
	self.saoqi = New(boss_saoqi, self)
end
