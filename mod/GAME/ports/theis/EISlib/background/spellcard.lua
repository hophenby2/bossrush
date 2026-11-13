---=====================================
---东方祈华梦符卡背景调整
---=====================================

local path = "res/background/spellcard/"

local S = lstg.ResourceSet.Create("EISlib.background.spellcard.default", "global")
S:AddSpriteFromFile("_scbg_1", path .. "default_scbg1.png", false)
S:AddSpriteFromFile("_scbg_mask_2", path .. "default_scbg2.png", false)

----------------------------------------
---sc bg

function _spellcard_background:render()
	SetViewMode 'world'
	if self.alpha > 0 then
		background.WarpEffectCapture()
		for i = (#self.layers), 1, -1 do
			local l = self.layers[i]
			local alpha = l.a--*self.alpha
			if l.tile then
				misc.RnderTileSCBG(l.img, l.blend, Color(alpha, l.r, l.g, l.b),
						l.x, l.y, l.rot, l.hscale, l.vscale)
			else
				SetImageState(l.img, l.blend, Color(alpha, l.r, l.g, l.b))
				Render(l.img, l.x, l.y, l.rot, l.hscale, l.vscale)
			end
			if l.render then
				l.render(l)
			end
		end
		background.WarpEffectApply(self.alpha)
	end
end

----------------------------------------
---default style

spellcard_background = Class(_spellcard_background)

function spellcard_background:init(boss)
	_spellcard_background.init(self, boss)
	_spellcard_background.AddLayer(self, "_scbg_mask_2",
			true,
			0, 0, 0,
			0, -0.2, 0,
			"",
			0.5, 0.5,
			function(self)
				self.a = 128;
				self.r = 0;
				self.g = 0;
				self.b = 0
			end,
			nil, nil)
	_spellcard_background.AddLayer(self, "_scbg_1",
			false,
			0, 0, 0,
			0, 0, 0,
			"",
			2, 2,
			nil, nil, nil)
end
