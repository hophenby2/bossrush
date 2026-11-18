local respath = "res/effect/"
local ran = lstg.Rand() --给特效专门配发的随机种子生成器
--击破样式
local ani_names = {}
local function load_res()
	--死亡特效
	LoadTexture("_enemy_death_effect_texture", respath .. "enemy_death_effect.png", false)
	for i = 1, 8 do
		ani_names[i] = "_enemy_death_effect_"..i
		LoadAnimation(ani_names[i], "_enemy_death_effect_texture", 0, 256*(i-1), 256, 256, 10, 1, 4)
		SetAnimationState(ani_names[i], "mul+add", Color(200, 255, 255, 255))
	end
	--LoadImageGroup("_enemy_death_effect_", "_enemy_death_effect_texture", 0, 0, 250, 250, 4, 2)
end

load_res()

----------------------------------------
--region death effect


local break_type_table = {
	--small
	{{ani_names[1], 1}}, --红
	{{ani_names[2], 1}}, --紫
	{{ani_names[3], 1}}, --蓝
	{{ani_names[4], 1}}, --青
	{{ani_names[5], 1}}, --绿
	{{ani_names[6], 1}}, --黄
	{{ani_names[7], 1}}, --橙
	{{ani_names[8], 1}}, --灰
	--middle
	{{ani_names[1], 1.5}, {ani_names[7], 1.25}},
	{{ani_names[2], 1.5}, {ani_names[3], 1.25}},
	{{ani_names[3], 1.5}, {ani_names[2], 1.25}},
	{{ani_names[4], 1.5}, {ani_names[5], 1.25}},
	{{ani_names[5], 1.5}, {ani_names[6], 1.25}},
	{{ani_names[6], 1.5}, {ani_names[1], 1.25}},
	{{ani_names[7], 1.5}, {ani_names[6], 1.25}},
	{{ani_names[8], 1.5}, {ani_names[8], 1.25}},
	--large
	{{ani_names[1], 1.75}, {ani_names[3], 1.5}, {ani_names[5], 1.25}},
	{{ani_names[2], 1.75}, {ani_names[4], 1.5}, {ani_names[6], 1.25}},
	{{ani_names[3], 1.75}, {ani_names[5], 1.5}, {ani_names[1], 1.25}},
	{{ani_names[4], 1.75}, {ani_names[6], 1.5}, {ani_names[2], 1.25}},
	{{ani_names[5], 1.75}, {ani_names[1], 1.5}, {ani_names[3], 1.25}},
	{{ani_names[6], 1.75}, {ani_names[2], 1.5}, {ani_names[4], 1.25}},
	{{ani_names[7], 1.75}, {ani_names[3], 1.5}, {ani_names[5], 1.25}},
	{{ani_names[8], 1.75}, {ani_names[8], 1.5}, {ani_names[8], 1.25}},
}


enemy_death_ef = Class(object)
function enemy_death_ef:init(type, x, y, scale, silence)
	self.break_type = break_type_table[type]
	self.da = 360/#self.break_type*ran:Sign()
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_GHOST
	self.size = 1*scale
	self.x = x
	self.y = y
	self.rot = ran:Float(0, 360)
	if not silence then
		PlaySound("enep00", 0.3, self.x / 768)
	end
end
function enemy_death_ef:frame()
	if self.timer >= 39 then
		self.status="del"
	end
end
function enemy_death_ef:render()
	for k, imgs in pairs(self.break_type) do
		RenderAnimation(imgs[1], self.ani, self.x, self.y, self.rot + k*self.da, imgs[2]*self.size, imgs[2]*self.size)
	end
end

--endregion
----------------------------------------