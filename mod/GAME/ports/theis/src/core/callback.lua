---=====================================
--- callback system
--- simplified event dispatcher
--- author: Xiliusha
--- email : Xiliusha@outlook.com
---=====================================

local DEBUG = false

local pairs, ipairs = pairs, ipairs
local insert, remove = table.insert, table.remove

---@class callback
local M = {}
---@type callback
callback = M

M.GROUP_DEFAULT = -1
M.GROUP_UPDATE = 1
M.GROUP_TRIGGER = 2
M.GROUP_DESTROY = 3

local group_default = {
	M.GROUP_UPDATE,
	M.GROUP_TRIGGER,
	M.GROUP_DESTROY,
}
local tag_type = {["bool"] = true, ["number"] = true, ["string"] = true}

if DEBUG then
	function M.initialize(self, ...)
		local args = { ... }
		self._callback_fun = {}
		self._callback_tag = {}
		if args[1] == M.GROUP_DEFAULT then
			for _, v in ipairs(group_default) do
				self._callback_fun[v] = {}
				self._callback_tag[v] = {}
			end
		else
			local _t
			for _, v in ipairs(args) do
				_t = type(v)
				if not tag_type[_t] then
					error(string.format("Invalid callback group tag type %q.", _t), 2)
				end
				self._callback_fun[v] = {}
				self._callback_tag[v] = {}
			end
		end
	end

	function M.clear(self)
		local _cb = self._callback_fun
		if not _cb then
			error("The object does not initialize the callback.", 2)
		end
		for k, _ in pairs(self._callback_fun) do
			_cb[k] = {}
			self._callback_tag[k] = {}
		end
	end

	function M.execute(self, group, ...)
		local _cb = self._callback_fun
		if not _cb then
			error("The object does not initialize the callback.", 2)
		end
		local _g = _cb[group]
		if not _g then
			error(string.format("The object does not have callback group %q.", tostring(group)), 2)
		end
		for _, v in ipairs(_g) do
			v(self, ...)
		end
	end

	function M.attach(self, group, tag, cb)
		local _cb = self._callback_fun
		if not _cb then
			error("The object does not initialize the callback.", 2)
		end
		local _g = _cb[group]
		if not _g then
			error(string.format("The object does not have callback group %q.", tostring(group)), 2)
		end
		local _t = type(cb)
		if _t == "function" then
			insert(_g, cb)
			insert(self._callback_tag[group], tag)
		else
			error(string.format("Invalid callback type %q.", _t), 2)
		end
		return cb
	end

	function M.detach(self, group, tag)
		local _cb = self._callback_fun
		if not _cb then
			error("The object does not initialize the callback.", 2)
		end
		local _g = _cb[group]
		if not _g then
			error(string.format("The object does not have callback group %q.", tostring(group)), 2)
		end
		local _t = self._callback_tag[group]
		for i = (#_g), 1, -1 do
			if _t[i] == tag then
				remove(_g, i)
				remove(_t, i)
				break
			end
		end
	end
else
	---@param self table
	---@vararg boolean | number | string
	function M.initialize(self, ...)
		local args = { ... }
		self._callback_fun = {}
		self._callback_tag = {}
		if args[1] == M.GROUP_DEFAULT then
			for _, v in ipairs(group_default) do
				self._callback_fun[v] = {}
				self._callback_tag[v] = {}
			end
		else
			for _, v in ipairs(args) do
				self._callback_fun[v] = {}
				self._callback_tag[v] = {}
			end
		end
	end

	---@param self table
	function M.clear(self)
		for k, _ in pairs(self._callback_fun) do
			self._callback_fun[k] = {}
			self._callback_tag[k] = {}
		end
	end

	---@param self table
	---@param group boolean | number | string
	function M.execute(self, group, ...)
		for _, v in ipairs(self._callback_fun[group]) do
			v(self, ...)
		end
	end

	---@param self table
	---@param group boolean | number | string
	---@param tag boolean | number | string
	---@param cb fun(self:table)
	function M.attach(self, group, tag, cb)
		insert(self._callback_fun[group], cb)
		insert(self._callback_tag[group], tag)
		return cb
	end

	---@param self table
	---@param group boolean | number | string
	---@param tag boolean | number | string
	function M.detach(self, group, tag)
		local _t = self._callback_tag[group]
		local _g = self._callback_fun[group]
		for i = (#_t), 1, -1 do
			if _t[i] == tag then
				remove(_t, i)
				remove(_g, i)
				break
			end
		end
	end
end

return M
