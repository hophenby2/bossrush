---=====================================
---TH00 关卡背景
---=====================================

local SetViewMode = SetViewMode
local Color = Color
local background = background
local misc = misc
local lstg = lstg

TH00_bg = Class(background)

function TH00_bg:init()
    background.init(self, false)
    self.speed = 0.5
end

function TH00_bg:render()
    SetViewMode 'world'
    local world = lstg.world
    misc.RenderTexInRect("th00_0", world.l, world.r, world.b, world.t,
            0, self.timer * self.speed, 0, 1, 1, "", Color(255, 255, 255, 255))
end
