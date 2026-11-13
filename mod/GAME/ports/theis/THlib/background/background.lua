---=====================================
---luastg stage background
---=====================================

local path="THlib/background/"

----------------------------------------
---background

background=Class(object)

function background:init(is_sc_bg)
	self.group=GROUP_GHOST
	if is_sc_bg then
		self.layer=LAYER_BG
		self.alpha=0
	else
		self.layer=LAYER_BG-0.1
		self.alpha=1
		if lstg.tmpvar.bg and IsValid(lstg.tmpvar.bg) then Del(lstg.tmpvar.bg) end
		lstg.tmpvar.bg=self
	end
end

function background:render()
	SetViewMode'world'
	RenderClear(Color(0x00000000))
end

----------------------------------------
---res

-- Boss Rush uses its own render pipeline.
background.AddWarpEffect = function() end
background.RemoveWarpEffect = function() end
background.WarpEffectCapture = function() return false end
background.WarpEffectApply = function() end
Include(path .. "spellcard.lua")
