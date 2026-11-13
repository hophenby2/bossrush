---=====================================
--- luastg task system
--- author: Xiliusha
--- email : Xiliusha@outlook.com
---=====================================

local ipairs = ipairs
local insert = table.insert
local remove = table.remove
local status = coroutine.status
local create = coroutine.create
local resume = coroutine.resume
local yield = coroutine.yield
local max = math.max
local floor = math.floor

----------------------------------------
--- task

-- unit.task
-- unit.taskself

---@class task
local M = {}
---@type task
task = M

---@type table[]
local _stack = {}
---@type thread[]
local _costk = {}

---@param target
---@param f fun(self)
---@return thread
function M.New(target, f)
	if not target.task then
		target.task = {}
	end
	local co = create(f)
	insert(target.task, co)
	return co
end

---@param target
---@param unit
function M.Do(target, unit)
	if target.task then
		unit = unit or target
		local ret, msg
		for _, co in ipairs(target.task) do
			if status(co) ~= "dead" then
				insert(_stack, unit)
				insert(_costk, co)
				ret, msg = resume(co, unit)
				if not ret then
					error(debug.traceback(co, msg))
				end
				remove(_stack)
				remove(_costk)
			end
		end
	end
end

---@param target table
---@param keepcur boolean @keep cur task
function M.Clear(target, keepcur)
	local tt = target.task
	if tt then
		local flag = false
		if keepcur then
			local co = _costk[#_costk]
			for i = (#tt), 1, -1 do
				if tt[i] == co then
					flag = true
				else
					remove(tt, i)
				end
			end
		end
		if not flag then
			target.task = nil
		end
	end
end

---@param t number
function M.Wait(t)
	t = max(0, floor(t or 1))
	for _ = 1, t do
		yield()
	end
end

---@param t thread
function M.WaitFinish(t)
	while status(t) ~= "dead" do
		yield()
	end
end

--- unit or unit.taskself
---@return table
function M.GetSelf()
	local c = _stack[#_stack]
	if c.taskself then
		return c.taskself
	else
		return c
	end
end
