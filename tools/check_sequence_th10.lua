-- 用真实道中生成器验证中Boss仍在场时的条件增援、异步时间轴和等待点。
-- 不执行敌机AI，不访问玩家存档；原来的波表/弹幕回归由check_original_practice覆盖。
local f=assert(io.open('tools/sequence_registry.lua','rb'));local setup=f:read('*a');f:close()
setup=setup:sub(1,assert(setup:find('for _,id in ipairs({3400',1,true))-1)
assert(loadstring(setup))()
local Clock=dofile('mod/sequence_clock.lua')
local class=_editor_class.TH35
local source={}
for _,unit in ipairs(_sc_pr_table[33]) do
    local card=unit.sc_group[1].card
    if card.card_id>=3680 and card.card_id<=3685 then source[#source+1]=card end
end
table.sort(source,function(a,b) return a.card_id<b.card_id end)
local native=assert(rawget(_G,'t10mid'),'未找到真实道中生成器')
local function run(card,duration)
    local frame,active,events,skipped,seen,controllers=0,nil,{},0,0,{}
    local marker=({[3680]=2520,[3681]=2552,[3682]=4120,[3683]=3601,[3684]=3801,[3685]=5047})[card.card_id]
    local clock=Clock.new{native=true,length=card.t3,explicitEnd=card.card_id>=3684,
        presence=card.card_id==3682 and {{3700,3880}} or nil,
        markers={{time=marker}},onMid=function()
            active={live=duration>0,born=frame};return {active}
        end}
    if os.getenv('SEQUENCE_CLOCK_TRACE') then
        clock.nativeBossWait=function(c)
            print('等待点',card.card_id,frame,c.times[c.primary],active and active.born)
            return Clock.nativeBossWait(c)
        end
    end
    IsValid=function(o) return o and o.live~=false end
    OriginalSequence={enabled=function() return true end,context=function()
        local owner=task.stack[#task.stack];return owner and owner._sequence_road_context
    end}
    class.t10_start_road=function(owner,main)
        local p={class={},timer=0,I0=0,I1=0,I2=0,I3=0,F0=0,F1=0,F2=0,F3=0,
            _sequence_road_context=owner._sequence_road_context}
        task.New(p,function() main(p) end);controllers[#controllers+1]=p;return p
    end
    native.spawn=function(hp,x,y,mirror,drop,beh,owner,inv,key)
        events[#events+1]={frame=frame,key=key,alive=clock:midAlive()}
        return {x=x,y=y,live=true}
    end
    local originalCanSpawn=OriginalStageFlow.roadCanSpawn
    OriginalStageFlow.roadCanSpawn=function(op)
        local allowed=originalCanSpawn(op)
        if op and op>=265 and op<=268 then
            seen=seen+1
            local time=clock.times[clock.primary] or 0
            local dummy=card.card_id==3682 and time>=3700 and time<3880
            assert(allowed~=(clock:midAlive() or dummy),'条件创建与原作BossPresent条件不符')
            if not allowed then skipped=skipped+1 end
        end
        return allowed
    end
    card.init({_sequence_road_context=clock})
    while not clock.done or clock:midAlive() do
        if active and frame>=active.born+duration then active.live=false end
        for _,p in ipairs(controllers) do task.Do(p);p.timer=p.timer+1 end
        frame=frame+1
        assert(frame<50000,'连续道中没有结束：'..card.card_id)
    end
    OriginalStageFlow.roadCanSpawn=originalCanSpawn
    assert(active,'原作道中Boss没有出现：'..card.card_id)
    return {frames=frame,events=#events,skipped=skipped,conditions=seen,
        blocked=(function() local n=0;for _,v in pairs(clock.blocked) do n=n+v end;return n end)()}
end
local checks=0
for _,card in ipairs(source) do
    local fast=run(card,0)
    assert((card.card_id==3682 or fast.skipped==0) and fast.blocked==0,'立即击破不应漏掉增援或等待Boss')
    for _,duration in ipairs({300,2000,6000}) do
        local slow=run(card,duration)
        assert(slow.frames>=fast.frames,'等待Boss不能提前结束道中')
        if duration>=2000 and (card.card_id==3680 or card.card_id==3681) then
            assert(slow.skipped>0 and slow.events<fast.events,'击破较慢应跳过错过的条件增援')
        end
        if duration==6000 then assert(slow.blocked>0,'长时间Boss战必须到达原作等待点') end
        checks=checks+1
        print(('原作道中 %d，中Boss %d 帧：结束 %d，创建 %d，跳过 %d，等待 %d'):format(
            card.card_id,duration,slow.frames,slow.events,slow.skipped,slow.blocked))
    end
end
assert(#source==6,'六段连续道中全部验证')
print('风神录条件增援/中Boss等待验证通过：'..checks..' 组，含全部六段连续道中')
