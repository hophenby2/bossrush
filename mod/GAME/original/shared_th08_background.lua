-- 从旧TH08独立保留的共享符卡背景；不登记旧关卡、Boss或符卡。
local class = {}
_editor_class["TH08"] = class

local cos, sin, min, max, int = cos, sin, min, max, int
local bullet, object, laser, enemy = bullet, object, laser, enemy
local task, ran, Create = task, ran, Create
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

do
    do
        class["SCBG1"] = Class(_SC_BG)
        class["SCBG1"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_3", true, 0, 0, 0, 0, -0.3, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_1", true, 0, 0, 0, 0.4, 1, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_0", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_2", true, 0, 0, 0, -0.4, 1.5, 0, "", 1, 1)
        end
        class["SCBG2"] = Class(_SC_BG)
        class["SCBG2"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_5", true, 0, 0, 0, -1, 2, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_4", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_1", true, 0, 0, 0, 0.4, 1, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_2", true, 0, 0, 0, -0.4, 1.5, 0, "", 1, 1)
        end
        class["SCBG3"] = Class(_SC_BG)
        class["SCBG3"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_7", false, 0, 0, 0, 0, 0, -0.3, "", 2.1, 2.1)
            _SC_BG.AddLayer(self, "th08_9", true, 0, 0, 0, 0, 1.5, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_8", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_6", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        end
        class["SCBG3+"] = Class(_SC_BG)
        class["SCBG3+"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_7", false, 0, 0, 0, 0, 0, -0.3, "", 3, 3)
            _SC_BG.AddLayer(self, "th08_9", true, 0, 0, 0, 0, 1.5, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_8_n", false, 0, 0, 0, 0, 0, 0, "", 0.5, 0.5)
        end
        class["SCBG4"] = Class(_SC_BG)
        class["SCBG4"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_11", false, 0, 0, 0, 0, 0, -0.5, "", 2.5, 2.5,
                    nil,
                    function(unit)
                        if lstg.var.eye then
                            unit.omiga = -1.5
                        else
                            unit.omiga = -0.5
                        end
                    end)
            _SC_BG.AddLayer(self, "th08_12", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_10", false, 0, 0, 0, 0, 0, 0.5, "", 1.2, 1.2)
        end
        class["SCBG5"] = Class(_SC_BG)
        class["SCBG5"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
                    function(unit)
                        unit.a = 170
                    end)
            _SC_BG.AddLayer(self, "th08_13", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_14", true, 0, 0, 0, 0, 2, 0, "", 1, 1)
        end
        class["SCBG6"] = Class(_SC_BG)
        class["SCBG6"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_19", true, 0, 0, 0, -1, 2, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
                    function(unit)
                        unit.task = {}
                        unit.a = 180
                    end)
            _SC_BG.AddLayer(self, "th08_18", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        end
        class["SCBG7"] = Class(_SC_BG)
        class["SCBG7"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0, "mul+sub", 1, 1)
            _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0, 0, 2, 0, "", 1, 1)
        end
    end--before lw
    class["SCBG-LW1"] = Class(_SC_BG)
    class["SCBG-LW1"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_1", true,
                0, 0, 0, 0.4, 1, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.a = 120
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
        _SC_BG.AddLayer(self, "th08_2", true,
                0, 0, 0, -0.4, 1.5, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.a = 120
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
        _SC_BG.AddLayer(self, "th08_3", true,
                0, 0, 0, 0, -0.3, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
        _SC_BG.AddLayer(self, "th08_0", true,
                0, 0, 0, 0, 1, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
    end
    class["SCBG-LW3"] = Class(_SC_BG)
    class["SCBG-LW3"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_5", true, 0, 0, 0, -1, 2, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th08_4_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG-LW4"] = Class(_SC_BG)
    class["SCBG-LW4"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_11", false, 0, 0, 0, 0, 0, -0.5, "", 2.5, 2.5,
                nil,
                function(unit)
                    if lstg.var.eye then
                        unit.omiga = -1.5
                    else
                        unit.omiga = -0.5
                    end
                end)
        _SC_BG.AddLayer(self, "th08_10", false, 0, 0, 0, 0, 0, 0.5, "", 1.8, 1.8)
    end
    class["SCBG-LW5"] = Class(_SC_BG)
    class["SCBG-LW5"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_14", true, 0, 0, 0,
                0, 2, 0, "mul+add", 1, 1,
                function(unit)
                    unit.a = 150
                end)
        _SC_BG.AddLayer(self, "th08_13_n", false, 0, 0, 0,
                0, 0, 0, "", 1, 1)

    end
    class["SCBG-LW6"] = Class(_SC_BG)
    class["SCBG-LW6"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_17", false, 0, 0, 0,
                0, 0, 0.5, "mul+add", 1.5, 1.5,
                function(unit)
                    unit.a = 150
                end,
                function(unit)
                    unit.g, unit.b = sin(unit.timer / 2) * 255 / 2 + 255 / 2, sin(unit.timer / 2) * 255 / 2 + 255 / 2
                end)

        _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0,
                0, 2, 0, "mul+add", 1, 1,
                function(unit)
                    unit.r = 150
                    unit.g = 150
                    unit.b = 150
                end,
                function(unit)
                    unit.a = sin(unit.timer / 2) * 100 + 155
                end)
        _SC_BG.AddLayer(self, "th08_15_n", false, 0, 0, 0,
                0, 0, 0, "", 1, 1,
                nil,
                function(unit)
                    unit.a = cos(unit.timer / 2) * 100 + 155
                end)
    end
    class["SCBG-LW8"] = Class(_SC_BG)
    class["SCBG-LW8"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_12", false, 0, 0, 0, 0, 0, 0, "", 2, 2,
                function(unit)
                    unit.task = {}
                end,
                function(unit)
                    task.Do(unit)
                    unit.r, unit.g, unit.b = 255 / 2 + sin(unit.timer * 0.3) * 255 / 2, 255 / 2 + sin(unit.timer * 0.3) * 255 / 2, 255 / 2 + sin(unit.timer * 0.3) * 255 / 2
                end)
        _SC_BG.AddLayer(self, "th08_22", true, 0, 0, 0, 0, 1, 0, "", 1, 1)
    end
    class["SCBG-LW9"] = Class(_SC_BG)
    class["SCBG-LW9"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_19", true, 0, 0, 0, -1, 2, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th08_18_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG-LW10"] = Class(_SC_BG)
    class["SCBG-LW10"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_5", false, 0, 0, 0, 0, 0, 0.5, "", 3.3, 3.3)
        _SC_BG.AddLayer(self, "th08_21", false, 0, 0, 0, 0, 0, -0.8, "", 3.2, 3.2)
    end
    class["SCBG-LW11"] = Class(_SC_BG)
    class["SCBG-LW11"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_4", true, 100, 100, 0, 0, 0, 0.3, "", 1.5, 1.5,
                _editor_class["TH07"]["youmu_slash"].init,
                _editor_class["TH07"]["youmu_slash"].frame, nil,
                _editor_class["TH07"]["youmu_slash"].render)
        _SC_BG.AddLayer(self, "th09_0_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1, function(unit)
            unit.r = 128
            unit.g = 128
            unit.b = 128
        end)
    end
    class["SCBG-LW12"] = Class(_SC_BG)
    class["SCBG-LW12"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_1", true, 0, 0, 0, 0, 0.6, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th07_1", true, -128, 0, 0, 0, -0.6, 0, "", 1, 1)
    end
    class["SCBG-LW13"] = Class(_SC_BG)
    class["SCBG-LW13"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 3, 3)
        _SC_BG.AddLayer(self, "th06_7_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1, function(unit)
            unit.r = 128
            unit.g = 128
            unit.b = 128
        end)
    end
    class["SCBG-LW14"] = Class(_SC_BG)
    class["SCBG-LW14"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "", 1, 1)
    end
end
