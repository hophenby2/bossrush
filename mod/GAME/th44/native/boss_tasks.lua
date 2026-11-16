-- 0x15877c 按槽号推进任务。刚分配的任务先走初始化入口。
local M = {}

function M.attach(bank, index, fields)
    local empty
    for i = 1, bank.limit do
        local task = bank[i]
        if not task and not empty then empty = i end
        if bank.unique and task and task.index == index then return end
    end
    if empty then
        local task = fields or {}
        task.index, task.slot = index, empty
        bank[empty] = task
        return task
    end
end

function M.contains(bank, index)
    for i = 1, bank.limit do
        if bank[i] and bank[i].index == index then return true end
    end
    return false
end

function M.stop(bank, index)
    for i = 1, bank.limit do
        if bank[i] and bank[i].index == index then bank[i] = nil end
    end
end

function M.clear(bank)
    for i = 1, bank.limit do bank[i] = nil end
end

function M.tick(o, bank)
    for i = 1, bank.limit do
        local task = bank[i]
        if task then
            local handlers = assert(bank.handlers[task.index],
                ('尚未翻译%s回调 %02x'):format(bank.label, task.index))
            local entry = task.running and 2 or 1
            task.running = true
            handlers[entry](o, task)
        end
    end
end

return M
