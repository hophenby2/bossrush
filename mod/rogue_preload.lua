-- 只在随机模式的入场协程分摊准备工作；对象回调及战斗时间轴不在这里推进。
local M={}
local owner,deadline,pool,job
local clock=lstg.AndroidClock or os.clock
local idle=0
local function suspend()
    local started=clock()
    coroutine.yield()
    idle=idle+clock()-started
end
function M.idle() return idle end
function M.checkpoint()
    if owner and coroutine.running()==owner and clock()>=deadline then
        local current=GetResourceStatus()
        SetResourceStatus(pool)
        suspend()
        SetResourceStatus(current)
        deadline=clock()+.008
    end
end
function M.run(fn)
    M.defer(fn)
    while job do task.Wait(1) end
end
function M.defer(fn)
    assert(not job,'已有未完成的入场准备')
    pool=GetResourceStatus()
    job=coroutine.create(fn)
end
function M.active() return job~=nil end
function M.frame()
    if not job then return false end
    owner=job;deadline=clock()+.008
    local ok,message=coroutine.resume(job)
    SetResourceStatus(pool)
    if not ok then job,owner=nil,nil;error(message) end
    if coroutine.status(job)=='dead' then job,owner=nil,nil end
    return true
end
function M.clear()
    job,owner=nil,nil
    if lstg.AndroidClearPreparedTextures then lstg.AndroidClearPreparedTextures() end
end
function M.texture(path)
    if not job or coroutine.running()~=owner or not lstg.AndroidPrepareTexture then return end
    local state=lstg.AndroidPrepareTexture(path)
    -- 小图往往在1ms内解码完成，不必让每张图都占用一个完整显示帧。
    local untilTime=math.min(deadline,clock()+.001)
    while state==0 and clock()<untilTime do state=lstg.AndroidPrepareTexture(path) end
    while state==0 do
        local current=GetResourceStatus();SetResourceStatus(pool)
        suspend()
        SetResourceStatus(current);deadline=clock()+.008
        state=lstg.AndroidPrepareTexture(path)
    end
end
-- 背景快照包含循环引用；保留模式定义，复制全部可变粒子、随机数及插值状态。
function M.copy(value,memo)
    if type(value)~='table' then return value end
    memo=memo or {}
    if memo[value] then return memo[value] end
    local out={};memo[value]=out
    for key,item in pairs(value) do
        out[M.copy(key,memo)]=key=='pattern' and item or M.copy(item,memo)
    end
    M.checkpoint()
    return out
end
return M
