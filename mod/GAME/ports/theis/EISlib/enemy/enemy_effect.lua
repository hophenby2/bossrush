local respath = "res/effect/"

local function load_res()
	--死亡特效
	local S = lstg.ResourceSet.Find("EISlib.enemy")
	S:AddTexture("_enemy_death_effect_texture", respath .. "enemy_death_effect.png", false)
	S:AddSpriteSequence("_enemy_death_effect_", "_enemy_death_effect_texture", 0, 0, 250, 250, 4, 2)
end
load_res()

----------------------------------------
--region death effect

enemy_death_ef = Class(object)
function enemy_death_ef:init(index, x, y, scale, silence)
	self.img = "_enemy_death_effect_" .. index
	self.layer = LAYER_ENEMY + 50
	self.group = GROUP_GHOST
	self.x = x
	self.y = y
	self.rot = 45
	if not silence then PlaySound("enep00", 0.3, self.x / 768) end
end
function enemy_death_ef:frame()
	if self.timer == 30 then
		self.status="del"
	end
end
function enemy_death_ef:render()
	local alpha = 1 - self.timer / 30
	alpha = 160 * alpha ^ 2
	SetImageState(self.img, "", Color(alpha, 255, 255, 255))
	Render(self.img, self.x, self.y, 15, 0.4 - self.timer * 0.01, self.timer * 0.05 + 0.7)
	Render(self.img, self.x, self.y, 75, 0.4 - self.timer * 0.01, self.timer * 0.05 + 0.7)
	Render(self.img, self.x, self.y, 135, 0.4 - self.timer * 0.01, self.timer * 0.05 + 0.7)
end

--endregion
----------------------------------------
--region item display

--获取的道具数量显示
local item_display = Class(object)
function item_display:init(pos, i, type, fnt, number, size)
	self.x, self.y = pos[i][1], pos[i][2] --定位
	self.bound = false
	self.txt = '' .. number
	self.fnt = fnt or "ui_font_42blue"
	self.size = 0
	self.scale = 1 --图标大小比率
	self._a = 0
	local imgs = { 'item_red1', 'item_blue1', 'item_green1', "sabi_item", "wabi_item", "item_night" }
	self.img = imgs[type]
	egg.AddSimStrChV(self, 1.5, -0.5, 90, 50)
	task.New(self, function()
		size = size or 1
		local ds = size / 20
		if type == 4 then
			self.scale = 0.6 * self.scale
		end
		local d_a = 200 / 20
		for _ = 1, 20 do
			self.size = self.size + ds
			self._a = self._a + d_a
			task.Wait(1)
		end
		task.Wait(10)
		for _ = 1, 20 do
			self._a = self._a - d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function item_display:frame()
	task.Do(self)
end
function item_display:render()
	SetFontState(self.fnt, "", Color(self._a, 255, 255, 255))
	RenderText(self.fnt, self.txt, self.x + 6 * self.size, self.y + 8 * self.size, 0.75 * self.size, 'left')
	SetImgState(self, "", self._a, 255, 255, 255)
	Render(self.img, self.x - 6 * self.size, self.y, 0, self.scale * self.size, self.scale * self.size)
end

--连击分数显示
local score_display = Class(object)
function score_display:init(x, y, number, score, size)
	self.x, self.y = x + 8 * size, y - 8 * size
	self.img = "item_maxpoint"
	self.bound = false
	self.num = number --本次二重染色消灭的妖精数
	self.txt = string.format_number(score) -- 优化过的
	self.fnt = "effect_font"
	self.size = 0
	self.scale = 1 --图标大小比率
	self._a = 0
	egg.AddSimStrChV(self, 1.5, -0.5, 90, 50)
	task.New(self, function()
		size = size or 1
		local ds = size / 20
		local d_a = 200 / 20
		for _ = 1, 20 do
			self.size = self.size + ds
			self._a = self._a + d_a
			task.Wait(1)
		end
		task.Wait(10)
		for _ = 1, 20 do
			self._a = self._a - d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function score_display:frame()
	task.Do(self)
end
function score_display:render()
	SetImgState(self, "", self._a, 255, 255, 255)
	Render(self.img, self.x - 3 * self.size, self.y, 0, 0.5 * self.size)
	SetFontState("ui_font_42blue", "", Color(self._a, 255, 255, 255))
	RenderText("ui_font_42blue", self.num .. '*500', self.x + 6 * self.size, self.y + 8 * self.size, 0.75 * self.size, 'left')
	SetFontState(self.fnt, "", Color(self._a, 255, 255, 255))
	RenderText(self.fnt, self.txt, self.x - 20 * self.size, self.y - 6 * self.size, 0.75 * self.size, 'left')
end

function bonus_display(x, y, life_num, point_num, bomb_num, night_num, kill_num, score, range, co)
	x, y = min(max(x, lstg.world.l + 25), lstg.world.r - 25), min(max(y, lstg.world.b + 25), lstg.world.t - 25) --防止出屏
	range = range or 0 --道具奖励掉落范围
	co = max(1, min(3, co or 3))
	local flag, count, pos, size = 0, 0
	--pos赋值
	do
		if life_num and life_num > 0 then
			flag = flag + 1
			count = count + life_num
		end
		if bomb_num and bomb_num > 0 then
			flag = flag + 1
			count = count + bomb_num
		end
		if point_num and point_num > 0 then
			flag = flag + 1
			count = count + point_num
		end
		if night_num and night_num > 0 then
			flag = flag + 1
			--count = count + night_num --夜点还是不计资源数好了
		end
		size = min(2, max(1, 0.05 * count + 0.85))
		if flag == 1 then
			pos = { { x, y }, nil,
			        nil, nil,
			        { x, y - 10 * size } }
		elseif flag == 2 then
			pos = { { x - 20 * size, y }, { x + 20 * size, y },
			        nil, nil,
			        { x - 20 * size, y - 10 * size } }
		elseif flag == 3 then
			pos = { { x, y + 10 * size },
			        { x - 20 * size, y - 10 * size }, { x + 20 * size, y - 10 * size }, nil,
			        { x - 20 * size, y - 20 * size } }
		elseif flag == 4 then
			pos = { { x - 20 * size, y + 10 * size }, { x + 20 * size, y + 10 * size },
			        { x - 20 * size, y - 10 * size }, { x + 20 * size, y - 10 * size },
			        { x - 20 * size, y - 20 * size } }
		end
	end
	flag = 0
	local r, a
	if life_num and life_num > 0 then
		flag = flag + 1
		New(item_display, pos, flag, 1, 'ui_font_42red', life_num, size)
		for _ = 1, life_num do
			r, a = ran:Float(0, range), ran:Float(0, 360)
			New(item_power, x + r * cos(a), y + r * sin(a), 2, 90)
			--item_power.collect()
		end
	end
	if bomb_num and bomb_num > 0 then
		flag = flag + 1
		New(item_display, pos, flag, 3, 'ui_font_42green', bomb_num, size)
		for _ = 1, bomb_num do
			r, a = ran:Float(0, range), ran:Float(0, 360)
			New(item_faith, x + r * cos(a), y + r * sin(a), 2, 90)
			--item_faith.collect()
		end
	end
	if point_num and point_num > 0 then
		flag = flag + 1
		New(item_display, pos, flag, 2, 'ui_font_42blue', point_num, size)
		for _ = 1, point_num do
			r, a = ran:Float(0, range), ran:Float(0, 360)
			New(item_point, x + r * cos(a), y + r * sin(a), 2, 90)
			--item_point.collect()
		end
	end
	if night_num and night_num > 0 then
		flag = flag + 1
		New(item_display, pos, flag, 3 + co, 'ui_font_42black', night_num, size)
		--[[for _ = 1, night_num do
			item_night_minor.collect()
		end]]
	end
	--最大得点加成显示
	if kill_num and kill_num > 0 and score and score > 0 then
		New(score_display, pos[5][1], pos[5][2], kill_num, score, size)
		system.addBonus(500 * kill_num) -- pointrate
		system.addScore(score)
		system.addChain(kill_num)
	end
end

--endregion
----------------------------------------
