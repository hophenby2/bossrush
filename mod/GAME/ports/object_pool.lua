-- 原作对象池的 Lua 存储层；退役后等调用方推进一次，再归还无引用的状态。
-- 引擎对象本身仍由原生池分配，Lua 实例表必须等宿主帧结束后才能重新绑定。
local M={}
-- 关卡 timer 会在 ObjFrame 前递增，不能代表上一帧的原生实例已经释放。
-- 共用一个完成计数；只在真正调用 AfterFrame 后推进，跨作品加载也不重复包裹。
if not lstg.SourceObjectPoolEpoch then
    local completed=0
    local afterFrame=AfterFrame
    lstg.SourceObjectPoolEpoch=function() return completed end
    AfterFrame=function(...) afterFrame(...);completed=completed+1 end
end
M.epoch=lstg.SourceObjectPoolEpoch
local clear
do
    local ok,fn=pcall(require,'table.clear')
    clear=ok and fn or function(t) for k in pairs(t) do t[k]=nil end end
end
local ok,newTable=pcall(require,'table.new')
if not ok then newTable=function() return {} end end
function M.new(limit,reserve)
    local free,pending,bodies,bodyPending={},{},{},{}
    local bodyFrame
    local entries=setmetatable({},{__mode='k'})
    local stats={created=0,reused=0,returned=0,pending=0,bodyCreated=0,bodyReused=0}
    local P={}
    local function create()
        local s=newTable(0,128)
        entries[s]={refs=0,scratch={changes={},limits={},shadows={},vars={}}}
        stats.created=stats.created+1
        return s
    end
    for _=1,reserve or 0 do free[#free+1]=create() end
    function P.owns(s) return s and entries[s]~=nil end
    function P.take()
        local n=#free;local s=free[n];free[n]=nil
        if not s then s=create() end
        local e=entries[s]
        if e.used then stats.reused=stats.reused+1 end
        e.used,e.retired=true,false
        return s,e.scratch
    end
    function P.pin(s)
        local e=s and entries[s]
        if e then e.refs=e.refs+1 end
    end
    function P.unpin(s)
        local e=s and entries[s]
        if e then assert(e.refs>0,'原作对象池引用计数不匹配');e.refs=e.refs-1 end
    end
    function P.retire(s)
        local e=s and entries[s]
        if not e or e.retired then return end
        e.retired=true;pending[#pending+1]=s;stats.pending=stats.pending+1
    end
    function P.advance()
        local n=0
        for i=1,#pending do
            local s=pending[i];local e=entries[s]
            if e.refs==0 then
                if P.onRecycle then P.onRecycle(s) end
                setmetatable(s,nil);clear(s)
                for _,v in pairs(e.scratch) do clear(v) end
                stats.returned=stats.returned+1;stats.pending=stats.pending-1
                if #free<limit then free[#free+1]=s else entries[s]=nil end
            else n=n+1;pending[n]=s end
        end
        for i=#pending,n+1,-1 do pending[i]=nil end
    end
    local function syncBodyFrame()
        local timer=M.epoch()
        if timer and timer~=bodyFrame then
            -- 同帧回收的实例尚未经过引擎 AfterFrame；不能挡住较早归还的可用实例。
            for i=1,#bodyPending do
                bodies[#bodies+1]=bodyPending[i];bodyPending[i]=nil
            end
            bodyFrame=timer
        end
        return timer
    end
    function P.newObject(cls,s,...)
        local api=lstg.AndroidNewSourceObjectFromTable
        local timer=syncBodyFrame()
        local index=#bodies;local body=bodies[index]
        local b
        if api and timer and body then
            bodies[index]=nil
            clear(body)
            b=api(cls,body,s,...);stats.bodyReused=stats.bodyReused+1
            if RogueEncounter and RogueEncounter.track then RogueEncounter.track(b) end
        else b=New(cls,s,...);stats.bodyCreated=stats.bodyCreated+1 end
        b._sourcePoolOwner=P
        return b
    end
    function P.retireObject(b)
        if b._sourcePoolOwner~=P then return end
        b._sourcePoolOwner=nil
        if lstg.AndroidNewSourceObjectFromTable and syncBodyFrame() and #bodies+#bodyPending<limit then
            bodyPending[#bodyPending+1]=b
        end
    end
    function P.clearBodies() bodies,bodyPending,bodyFrame={},{},nil end
    function P.stats()
        local out={};for k,v in pairs(stats) do out[k]=v end
        out.available,out.bodyAvailable,out.bodyPending=#free,#bodies+#bodyPending,#bodyPending
        return out
    end
    return P
end
function M.records(limit)
    local free={}
    return function()
        local n=#free;local t=free[n];free[n]=nil
        return t or {}
    end,function(t)
        clear(t)
        if #free<limit then free[#free+1]=t end
    end
end
return M
