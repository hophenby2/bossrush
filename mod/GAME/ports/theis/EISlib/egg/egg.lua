egg = {}
egg.path = EISlib.path .. "egg/"

local path = egg.path

lstg.DoFile(path .. "obj_event.lua")
lstg.DoFile(path .. "mul_bullet_attack.lua")
lstg.DoFile(path .. "eggbg.lua")

--用来在游戏内部运行脚本文件的obj
local updateFileObject = Class(object)
function updateFileObject:init(path)
	self.timer = 0
	self.path = path
end
function updateFileObject:frame()
	if KeyIsDown 'spell' and self.timer > 60 then
		dofile(self.path)
		self.timer = 0
	end
end
egg.updateFileObject = updateFileObject
