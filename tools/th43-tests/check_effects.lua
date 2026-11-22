-- 使用正式 Lua 类和协程，检查原作特效数量、开卡计时、换卡存活与自然回收。
arg={'th43-effects'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local originalClass=Class
Class=function(...) local c=originalClass(...);c.is_class=true;return c end
dofile('THlib/lib/Ltask.lua')
bent_laser.RenderFunc,bent_laser.RenderFuncDeath={},{}
CheckRes=function() return nil end -- Sub 对未加载资源返回 nil，通用桩件的 false 不能用于本作资源加载。
dofile('tools/th43_registry.lua')
local R=TH43.runtime;local E=R.env;local Fx=E.EGGlib.RenderEffect
local objects,counts,sounds={},{},{}
local originalNew=New
New=function(class,...)
    local o=originalNew(class,...);objects[#objects+1]=o;counts[class]=(counts[class] or 0)+1
    o.timer,o.ani=0,0
    o.ax,o.ay=o.ax or 0,o.ay or 0 -- 引擎加速度属性的初始值。
    return o
end
E.PlaySound=function(name) sounds[#sounds+1]=name end
local tick=0
local function step()
    tick=tick+1
    local n=#objects
    for i=1,n do
        local o=objects[i]
        if IsValid(o) then
            if o.class.frame then o.class.frame(o) end
            o.timer,o.ani=o.timer+1,o.ani+1
        end
    end
end
local function assertEnded()
    for _=1,220 do step() end
    for _,o in ipairs(objects) do assert(not IsValid(o),'原作视觉对象没有按寿命结束') end
    R.clear();objects,counts,sounds={},{},{}
end
local function host()
    local o=originalNew(object);o.x,o.y=24,-36
    o.saoqiR,o.saoqiG,o.saoqiB=40,80,120
    o.absorbAction=E.boss.defaultAbsorbAction
    return o
end
local owner=host()
-- 默认开卡恰好等待 90 帧，然后创建蓄力；不是固定等待 120 帧的空实现。
local completed
task.New(owner,function() E.boss.defaultScOpenEffect(owner);completed=tick end)
for i=1,90 do tick=i;task.Do(owner);assert(not completed) end
tick=91;task.Do(owner);assert(completed==91 and counts[Fx.AbsorbEffect]==1)
object.RawDel(owner)
for _=1,50 do step() end
assert(counts[Fx.ItemFlyIn]==90 and counts[Fx.AbsorbCircle]==1,'蓄力粒子数量不同')
assert(sounds[1]=='ch01')
assertEnded()

owner=host();R.scope=owner
E.boss.defaultBreakEffect(owner,nil,50,60)
step()
assert(counts[Fx.ItemFlyIn]==60 and counts[Fx.AbsorbCircle]==2,'放能粒子或光圈数量不同')
assert(sounds[1]=='power02')
local visual
for _,o in ipairs(objects) do if IsValid(o) and o.class==Fx.ItemFlyIn then visual=o;break end end
assert(visual,'没有生成可见的放能粒子')
local attack=E.New(Class(object,{init=function(o) o.group=GROUP.ENEMY_BULLET end}))
local tasker=E.New(Class(object,{init=function(o) o.group=GROUP.GHOST end}))
R.clear(owner)
assert(IsValid(visual) and R.objects[visual]==false,'换卡提前删除了原作视觉特效')
assert(not IsValid(attack) and not IsValid(tasker),'攻击或未分类的协程被错误保留')
assertEnded()

local Card=E.EGGlib.BossCard
for _,kind in ipairs({'normal','spellcard','timespell','extra','finalspell','extrafinal'}) do
    local finished,broken=0,0
    local card=Card.createFullCard('测试',kind,{0,0,10},100,nil,function() end,function() end,function() end,function() finished=finished+1 end).main
    owner.scBreakEffect=function(o) broken=broken+1;E.boss.defaultScBreakEffect(o) end
    card.del(owner)
    local expected=kind~='normal' and kind~='timespell'
    assert(finished==1 and broken==(expected and 1 or 0),'符卡击碎回调模式不同：'..kind)
    if expected then assert(counts[Fx.ScBreakItem]==120 and counts[Fx.ScBreakCircle]==2) end
    assertEnded()
end
E.boss.defaultScBreakEffect(owner)
assert(#objects==122)
R.clear()
for _,o in ipairs(objects) do assert(not IsValid(o),'退出作品残留特效') end
print('PASS 栖霞园原作 90 帧开卡、90/60/120 粒子、六种卡型、换卡保留与自然回收、退出清理')
