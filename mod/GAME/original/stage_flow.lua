-- 原作练习与整关共用阶段顺序；不重排原注册数组，保留历史录像和随机池索引。
if rawget(_G,'OriginalStageFlow') then return OriginalStageFlow end
local F={VERSION=1,installed=false}
OriginalStageFlow=F
local ids=dofile('mod/GAME/original/card_ids.lua')
local function sequenceContext()
    local s=rawget(_G,'OriginalSequence')
    return s and s.enabled() and s.context()
end
local function context()
    if not task.stack or not task.stack[#task.stack] then return end
    local owner=task.GetSelf()
    return owner and owner._original_road_window
end
local function cursor(c)
    local co=coroutine.running()
    return co,c.times[co] or 0
end
function F.roadActive()
    local c=context()
    if not c then return true end
    if c.native then return not c.preroll end
    local _,t=cursor(c)
    return t>=c.first and t<c.last
end
-- 只包装道中生成协程；敌机自身的移动、枪、出生动画仍逐帧执行原实现。
function F.roadWait(frames)
    local q=sequenceContext()
    if q and q.native then return q:nativeWait(frames) end
    local c=context()
    if not c or c.native then return task.Wait(frames) end
    local co,t=cursor(c)
    local target=t+frames
    c.times[co]=target
    local wait=math.max(0,math.min(target,c.last)-math.max(t,c.first))
    if wait>0 then task.Wait(wait) end
    if target>=c.last then while true do task.Wait(10000) end end
end
function F.roadAsync(owner,fn,primary)
    local q=owner._sequence_road_context
    if q and q.native then
        local co=task.New(owner,fn);q:nativeAsync(co,primary);return co
    end
    local c=owner._original_road_window
    if not c or c.native then return task.New(owner,fn) end
    local _,t=cursor(c)
    local co
    co=task.New(owner,function()
        c.times[coroutine.running()]=t+1
        return fn()
    end)
    return co
end
-- 旧练习仍使用固定窗口；顺序模式的生成器与中Boss共存，按各自原作时钟运行。
function F.roadEach(owner,waves,spawn)
    local q=owner._sequence_road_context
    if q then return q:eachWave(owner,waves,spawn) end
    for _,w in ipairs(waves) do
        F.roadWait(w[1])
        if F.roadActive() then spawn(w) end
    end
end
function F.roadCanSpawn(opcode)
    local q=sequenceContext()
    return not q or q:canSpawn(opcode)
end
function F.roadBossWait()
    local q=sequenceContext()
    if q and q.native then q:nativeBossWait() end
end
-- 完整流程保留同步子程序在末次生成至RETURN之间的空白；旧练习录像沿用原先窗口。
function F.roadTailWait(frames)
    local q=sequenceContext()
    if q and q.native then q:nativeWait(frames) end
end
function F.roadMid()
    local q=sequenceContext()
    if q then for _,marker in ipairs(q.markers) do if not marker.fired then q:fire(marker);break end end end
end
function F.roadFinish(length)
    local q=sequenceContext()
    if not q or not q.native then return end
    if not q.mainCo then q.mainCo=coroutine.running() end
    local time=q.times[q.primary] or 0
    if time<length then q:nativeWait(length-time) end
    q:nativeBossWait()
    q.done=true
end
function F.roadEnd()
    local q=sequenceContext()
    if q then q.done=true end
end
local function find(level,id)
    id=ids.resolve(level,id)
    for index,unit in ipairs(_sc_pr_table[level] or {}) do
        if unit.sc_group[1].card.card_id==id then return {index=index,unit=unit} end
    end
    error('原作阶段未注册：'..level..':'..id)
end
function F.install()
    if F.installed then return end
    local order=dofile('mod/GAME/original/stage_order.lua')
    F.order=order
    F.hidden={}
    for _,split in ipairs(order.splits) do
        local level,source=split.level,find(split.level,split.source)
        F.hidden[source.unit.sc_group[1].card]=true
        local base=source.unit.sc_group[1]
        for _,part in ipairs(split.parts) do
            local card={}
            for key,value in pairs(base.card) do card[key]=value end
            card.card_id,card.source_card_id,card.phase_name=nil,nil,nil
            card.practice_only=true
            card.name=part.title;card.is_sc=false
            card.t1,card.t2,card.t3=part.last-part.first,part.last-part.first,part.last-part.first
            card.phase_name,card.phase_kind,card.phase_part=part.title,'road',part.part
            card.road_window={first=part.first,last=part.last,source=split.source}
            local function begin(o)
                o._original_road_window={first=part.first,last=part.last,times=setmetatable({},{__mode='k'})}
            end
            card.before=function(o) begin(o);return base.card.before(o) end
            card.init=function(o) begin(o);return base.card.init(o) end
            card.del=function(o)
                local result=base.card.del(o)
                o._original_road_window=nil
                return result
            end
            local band=base.boss.id:sub(1,-#tostring(level)-1)
            boss.card.add({{card,band}},level,part.title,part.id)
        end
    end
    F.installed=true
end
function F.units(level)
    F.install()
    local out,seen={},{}
    for _,chapter in ipairs(assert(F.order[level],'不支持的原作练习关卡')) do
        local role='boss'
        for _,id in ipairs(chapter.cards) do
            local row=find(level,id)
            assert(not seen[row.index],'原作流程重复：'..level..':'..id)
            seen[row.index]=true;row.chapter=chapter.name
            local kind=row.unit.sc_group[1].card.phase_kind
            if kind=='road' then row.role='road';role='boss'
            else role=kind or role;row.role=role end
            out[#out+1]=row
        end
    end
    for index,unit in ipairs(_sc_pr_table[level] or {}) do
        local card=unit.sc_group[1].card
        -- TH32的克罗里是旧自制卡，保留注册供旧录像读取，不进入原作入口。
        local custom=level==30 and card.card_id==368
        assert(seen[index] or F.hidden[card] or custom,'原作阶段缺少顺序：'..level..':'..card.card_id)
    end
    return out
end
function F.run(level)
    local units=F.units(level)
    local index=1
    while index<=#units do
        local first=units[index].unit
        local actors={}
        -- 同一面、同一角色的连续战斗阶段共用宿主；道中独立，避免继承上一战的立绘和附属物。
        if #first.sc_group==1 then
            local cls,cards=first.sc_group[1].boss,{}
            local chapter,role=units[index].chapter,units[index].role
            repeat
                cards[#cards+1]=units[index].unit.sc_group[1].card
                index=index+1
                local nextUnit=units[index] and units[index].unit
                if role=='road' or not nextUnit or units[index].chapter~=chapter or units[index].role~=role
                    or #nextUnit.sc_group~=1 or nextUnit.sc_group[1].boss~=cls then break end
            until false
            actors[1]=New(cls,cards)
        else
            for _,part in ipairs(first.sc_group) do actors[#actors+1]=New(part.boss,{part.card}) end
            for i,o in ipairs(actors) do
                for j,other in ipairs(actors) do if i~=j then o.otherboss[#o.otherboss+1]=other end end
            end
            index=index+1
        end
        for _,o in ipairs(actors) do while IsValid(o) do task.Wait() end end
        task.Wait(60)
    end
end
return F
