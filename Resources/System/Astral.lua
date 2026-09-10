local lstg, item, object, task, int, ran, cos, sin = lstg, item, object, task, int, ran, cos, sin
local New = New
local unpack = unpack
local Forbid = Forbid
local max, min = max, min
local SetImageState = SetImageState
local Render = Render
local PlaySound = PlaySound
local Color = Color
local manual = ext.manual

---@class Astral
Astral = {}
local Astral = Astral
Astral.color = { { 0, 127, 0 }, { 63, 0, 63 }, { 63, 63, 0 }, { 63, 63, 63 } }
Astral.color2 = { { 255, 32, 255 }, { 32, 255, 32 }, { 80, 80, 255 }, { 128, 128, 128 } }
Astral.name = { "purple", "green", "blue", "white" }
Astral.size = { 1.5, 1.5, 1, 1 }

local soul_base = Class(object)
Astral.soul_base = soul_base
function soul_base:init(x, y, v, a, id)
    self.IsAstral = true
    self.x = Forbid(x, lstg.world.l + 12, lstg.world.r - 12)
    self.y = Forbid(y, lstg.world.b + 12, lstg.world.t - 12)
    New(Astral.DropEffect, self.x, self.y)
    self.a, self.b = 8, 8
    self.group = GROUP.ITEM2
    self.layer = LAYER.ITEM
    self.bound = false
    self.v = v or ran:Float(2.5, 3.6)
    self.angle = a or ran:Float(0, 360)
    self.attract = 0

    object.SetV(self, self.v, self.angle)

    self.scale = 1.5
    self.scale2 = 0.7
    self.normal_img = "astral_soul_normal"

    id = id or 3
    self.astral_img = "astral_soul_" .. Astral.name[id]
    self.color = Astral.color[id]
    self.color2 = Astral.color2[id]
    self.size = Astral.size[id]
end
local Smooth = task.Smooth
function soul_base:frame()
    self.x = Forbid(self.x, lstg.world.l + 12, lstg.world.r - 12)
    self.y = Forbid(self.y, lstg.world.b + 12, lstg.world.t - 12)
    self.v = max(self.v - self.v * 0.05, 0.1)
    object.SetV(self, self.v, self.angle)
    if lstg.var.ON_astral then
        self.timer = 0
    else
        local t = (self.timer - 1) % 40 + 1
        local s
        if t <= 20 then
            s = Smooth(t / 20)
            self.scale = 1.5 + 0.1 * s
            self.scale2 = 0.7 + 0.2 * s
        else
            t = t - 20
            s = Smooth(t / 20)
            self.scale = 1.6 - 0.1 * s
            self.scale2 = 0.9 - 0.2 * s
        end
    end
    if self.attract > 0 then
        local a = Angle(self, player)
        self.vx = self.attract * cos(a)
        self.vy = self.attract * sin(a)
    else
        self.hscale = 1 - self.timer / 480
        if player.grazer.grazed > 0 then
            local a = Angle(self, player)
            self.vx = cos(a) * 0.2
            self.vy = sin(a) * 0.2
        else
            object.SetV(self, self.v, self.angle)
        end
    end
    if self.hscale < 0.1 then
        object.RawDel(self)
    end
end
function soul_base:render()
    if lstg.var.ON_astral then
        SetImageState(self.astral_img .. 1, "mul+add", 255, 255, 255, 255)
        SetImageState(self.astral_img .. 2, "mul+add", 255, 255, 255, 255)
        Render(self.astral_img .. 1, self.x, self.y)
        Render(self.astral_img .. 2, self.x, self.y, self.ani * 3)
    else
        SetImageState(self.normal_img .. 1, "mul+rev", 255, unpack(self.color))
        Render(self.normal_img .. 1, self.x, self.y, 0, self.hscale * self.scale * self.size)
        SetImageState(self.normal_img .. 2, "mul+add", 255, unpack(self.color2))
        Render(self.normal_img .. 2, self.x, self.y, 0, self.hscale * self.scale2 * self.size)
    end

end
function soul_base:colli(other)
    if other == player then
        if self.class.collect then
            self.class.collect(self, other)
        end
        object.Kill(self)
        PlaySound('lgodsget', 0.3, self.x / 200)
    end
end

local DropEffect = Class(object)
Astral.DropEffect = DropEffect
function DropEffect:init(x, y)
    self.x, self.y = x, y
    self.group = GROUP.GHOST
    self.layer = LAYER.ITEM + 1
    self.img = "circle_charge"
    self.hscale=0
end
function DropEffect:frame()
    self.hscale = min(self.timer * 1.5, 15) / 256
    self.vscale = self.hscale
    if self.timer == 35 then
        object.RawDel(self)
    end
end
function DropEffect:render()
    if self.timer < 35 then
        SetImageState(self.img, "mul+add", 240 - max(self.timer - 15, 0) * 12, 32, 128, 32)
        DefaultRenderFunc(self)
    end
end

function Astral.GetAstral(x)
    if lstg.var.astral == 300 or lstg.var.ON_astral then
        return
    end
    local before = lstg.var.astral
    lstg.var.astral = min(lstg.var.astral + x, 300)
    if int(lstg.var.astral / 100) - int(before / 100) > 0 then
        PlaySound("opshow")
        local text = ""
        if int(lstg.var.astral / 100) <= 2 then
            text = "A x " .. int(lstg.var.astral / 100)
        else
            text = "A Max"
        end
        New(float_text, "Score", text, player.x, player.y + 6, 0.75, 90, 90, 0.5, 0.3, Color(255, 255, 227, 132), Color(0, 0, 0, 0))
    end
end

local soul_item = {}
Astral.soul_item = soul_item

local blue = Class(Astral.soul_base)
soul_item.blue = blue
function blue:init(x, y, v, a)
    PlaySound("lgods2")
    Astral.soul_base.init(self, x, y, v, a, 3)
    local l = lstg.var
    if l.blue_combo < 9 then
        l.blue_combo = l.blue_combo + 1
    end
    l.blue_time = 60
    if l.blue_combo == 9 then
        Astral.drop(self.x, self.y, 4, 1)
    end
end
local col1 = Color(0x400000FF)
local col2 = Color(0x000000FF)
function blue:collect()
    local l = lstg.var
    local score = item.TweakScore((l.ON_sakura and 1200 or 200) * l.grazetimes * 10) * (l.ON_astral and 2 or 1)
    New(float_text, "Score", score, self.x, self.y + 6, 0.75, 90, 60, 0.3, 0.3, col1, col2)
    l.score = l.score + score
    if SearchStageLevel[5] then
        l.grazetimes = l.grazetimes + 0.02
        if l.grazerevp > 30 then
            l.grazerevp = 30
        end
    end
    item.Additembar("blue", 1)
end

local white = Class(Astral.soul_base)
soul_item.white = white
function white:init(x, y, v, a)
    PlaySound("lgods4")
    Astral.soul_base.init(self, x, y, v, a, 4)
end
function white:collect()
    Astral.GetAstral(2.5)
    local score = item.TweakScore(10000 * lstg.var.grazetimes) * (lstg.var.ON_astral and 2 or 1)
    New(float_text, "Score", score, self.x, self.y + 6, 0.75, 90, 60, 0.3, 0.3, col1, col2)
    lstg.var.score = lstg.var.score + score
    item.Additembar("green", 1.5)
end

function Astral.drop(x, y, id, num)
    local i = Astral.soul_item[Astral.name[id]]
    for _ = 1, num do
        New(i, x, y)
    end
end
