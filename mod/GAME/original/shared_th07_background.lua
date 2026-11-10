-- 从旧TH07独立保留的共享符卡背景；不登记旧关卡、Boss或符卡。
local class = {}
_editor_class["TH07"] = class

local cos, sin, min, max, int, tan, sign = cos, sin, min, max, int, tan, sign
local bullet, object, laser, boss = bullet, object, laser, boss
local task, ran, Create, sp = task, ran, Create, sp
local table = table
local GROUP, LAYER, COLOR = GROUP, LAYER, COLOR
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local IsValid = IsValid
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

do

    class["SCBG1"] = Class(_SC_BG)
    class["SCBG1"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, 0, 0.01, 0, "", 1, 1)
    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_0", true, 0, 0, 0, 0, -0.8, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, -0.1, 0.2, 0, "", 1, 1)
    end
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_1", true, 0, 0, 0, 0, 0.6, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th07_1", true, -128, 0, 0, 0, -0.6, 0, "", 1, 1)
    end
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_3", false, 0, 0, 0, 0, 0, 0, "", 1.5, 1.5)
        _SC_BG.AddLayer(self, "th07_2", false, 0, 0, 0, 0, 0, 0.3, "", 2.3, 2.3)
    end
    class["youmu_slash"] = {
        init = function(self)
            self.task = {}
            self.a = 120
            setmetatable(self, {
                __index = function(mytable, key)
                    if key == "slash_time" then
                        if mytable.a == 255 then
                            return true
                        else
                            return false
                        end
                    end
                end,
                __newindex = function(mytable, key, value)
                    if key == "slash_time" then
                        task.New(mytable, function()
                            local unit = task.GetSelf()
                            PlaySound("kira00")
                            unit.a = 255
                            for i = 1, value do
                                unit.omiga = -sin(90 - i / value * 90) * (1 / value * 160)
                                task.Wait()
                            end
                            unit.a = 120
                            unit.omiga = 0.3
                        end)
                    else
                        rawset(mytable, key, value)
                    end
                end
            })
        end,
        frame = task.Do,
        render = function(self)
            if self.slash_time then
                SetImageState("white", "mul+rev", 250, 100, 100, 100)
                RenderRect('white', lstg.world.l, lstg.world.r, lstg.world.t, lstg.world.b)
            end
        end
    }
    class["SCBG5"] = Class(_SC_BG)
    class["SCBG5"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_4", false, 0, 0, 0, 0, 0, 0.3, "", 2.3, 2.3,
                class["youmu_slash"].init,
                class["youmu_slash"].frame, nil,
                class["youmu_slash"].render)
        _SC_BG.AddLayer(self, "th07_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "", 1, 1)
    end
    class["SCBG6"] = Class(_SC_BG)
    class["SCBG6"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_0", true, 0, 0, 0, 0, -0.8, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th07_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "", 1, 1)
    end
    class["SCBG7"] = Class(_SC_BG)
    class["SCBG7"].init = function(self)
        _SC_BG.init(self)
        local b = _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2.3, 2.3)
        b.Beforeframe = function(unit)
            unit.a = 150 + 100 * sin(unit.timer / 2)
        end
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0, -0.1, "", 2, 2)
        _SC_BG.AddLayer(self, "th07_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG8"] = Class(_SC_BG)
    class["SCBG8"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0, -0.1, "", 2, 2)
        _SC_BG.AddLayer(self, "th07_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG9"] = Class(_SC_BG)
    class["SCBG9"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0, -0.1, "mul+rev", 2.8, 2.8)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "mul+add", 1, 1, function(unit)
            unit.a = 100
        end)
        _SC_BG.AddLayer(self, "th07_7_n", false, 0, 0, 0, 0, 0, 0, "", 0.5, 0.5, function(unit)
            unit.r, unit.g, unit.b = 150, 150, 150
        end)
    end
end--_SC_BG
