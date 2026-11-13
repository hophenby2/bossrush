---=====================================
---flat class
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

local setmetatable = setmetatable
local pairs = pairs

----------------------------------------
---base class

---@class etc.class
local etc_class = {}

---constructor, called when a new instance is created
---@return etc.class
function etc_class:constructor()
	return self
end

---**[static method]** create a new instance
---@return etc.class
function etc_class.new()
	return etc_class
end

----------------------------------------
---class creator

---create a flat class
---@param mt boolean @using metatable
---@param im boolean @immediately construction
---@return etc.class
function etc.class(mt, im)
	---@type etc.class
	local cls = {}
	function cls:constructor() return self end
	function cls.new(...)
		local instance = {}
		if mt then
			setmetatable(instance, {__index = cls})
		else
			for k, v in pairs(cls) do
				instance[k] = v
			end
		end
		if im then
			instance:constructor(...)
		end
		return instance
	end
	return cls
end

----------------------------------------
---test

--[[

---@class myclass : etc.class
local M = etc.class()

---@param ip string
---@param port number
---@param timeout number
---@return myclass
function M:constructor(ip, port, timeout)
end

---@param msg string
function M:send(msg)
end

---@return string
function M:receive()
end

local tcp = M

local instance = tcp.new():constructor("127.0.0.1", 10492, 10)
instance:send("[U]Hello socket.")
print(instance:receive())

--]]
