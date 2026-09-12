---=====================================
---TH00
---=====================================

local class = {}
_editor_class["TH00"] = class

local Class = Class
local boss = boss
local task = task

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th00_0", true, 0, 0, 0, 0, -0.07, 0, "", 1, 1)
end

boss.Define("1a", "未命名Boss", "TH00_0", TH00_bg, { 0, 300 }, class["SCBG1"], "Rumia", 20)
do
    local non1 = boss.card.New("", 1, 1, 60, 600)
    boss.card.add({ { non1, "1a" } }, 20, "非符一", 243)
    function non1:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function non1:init()
        task.New(self, function()
            task.Wait(60)
        end)
    end
end
