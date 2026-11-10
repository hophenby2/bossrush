-- 从旧TH06独立保留的共享符卡背景；不登记旧关卡、Boss或符卡。
local class = {}
_editor_class["TH06"] = class

local cos, sin, abs, min, max, sign = cos, sin, abs, min, max, sign
local bullet, object, laser, boss = bullet, object, laser, boss
local task, ran, Create, sp = task, ran, Create, sp
local table = table
local GROUP, LAYER, COLOR = GROUP, LAYER, COLOR
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out
local servant = SimpleServant

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_1", true, 0, 0, 0, -0.04, 0.07, 0, "mul+add", 1, 1)
    _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, 0, -0.07, 0, "", 1, 1)
end
class["SCBG2"] = Class(_SC_BG)
class["SCBG2"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_3", false, 0, 0, 0, 0, 0, 0.3, "mul+add", 3, 3)
    _SC_BG.AddLayer(self, "th06_4", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1)
    _SC_BG.AddLayer(self, "th06_2", true, 0, 0, 0, 0, 0, 0, "", 1, 1)
end
class["SCBG3"] = Class(_SC_BG)
class["SCBG3"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_5", false, 0, 0, 0, 0, 0, -0.5, "", 2.3, 2.3)
    _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2, 2)
    _SC_BG.AddLayer(self, "th06_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
end
class["SCBG4"] = Class(_SC_BG)
class["SCBG4"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2, 2)
    _SC_BG.AddLayer(self, "th06_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
end
class["SCBG5"] = Class(_SC_BG)
class["SCBG5"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 3, 3)
    _SC_BG.AddLayer(self, "th06_7_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1, function(unit)
        unit.r = 128
        unit.g = 128
        unit.b = 128
    end)
end
