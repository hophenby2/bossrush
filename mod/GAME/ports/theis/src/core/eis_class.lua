---=====================================
---class instance creator
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

----------------------------------------
---EISlib.Class

---@class EISlib.Class
local EISlib_Class={}

---初始化方法，必须有
function EISlib_Class:init() end

----------------------------------------
---EISlib.New

---实例化一个对象
---@param cc EISlib.Class
---@vararg any
---@return EISlib.Class
function EISlib.New(cc, ... )
	local ret={}
	for k,v in pairs(cc) do
		ret[k]=v
	end
	ret:init( ... )
	return ret
end
