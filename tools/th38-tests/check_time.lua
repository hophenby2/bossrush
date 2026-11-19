-- 使用原始 slow0 的时间点，验证隐藏控制器、持续/恢复、整场逻辑预算和清场。
arg={'th38-time'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th38/runtime.lua');local T=NativeTime
local c=R.controller(nil,'L/stage6/boss1/9')
local actualNew=New;local visibleControllers=0
New=function(cls,s,...) if s.enemyType==21 then visibleControllers=visibleControllers+1 end;return actualNew(cls,s,...) end
local slow
for _=1,181 do R.step(c) end
for _,s in ipairs(c.entities) do if s.kind=='time' then slow=s end end
assert(slow and slow.slowLeft==270 and not slow.native,'原作180tick必须生成不可见的减速控制器')
R.step(c);assert(math.abs(T.scale-.33)<1e-6 and slow.slowLeft==269)
for _=1,269 do R.step(c);assert(math.abs(T.scale-.33)<1e-6) end
assert(slow.slowLeft==0)
local ramps=0
while slow.alive do R.step(c);ramps=ramps+1;assert(ramps<72) end
assert(ramps==69 and T.scale==1,'没有按Unity单精度每tick +0.01 恢复')
assert(visibleControllers==0,'把时间控制器生成了有贴图/碰撞的普通敌机')
local scheduled={}
while c.time<=1200 do
    R.step(c)
    for _,s in ipairs(c.entities) do if s.kind=='time' and not scheduled[s.birth] then scheduled[s.birth]=s.slowLeft end end
end
assert(scheduled[781]==120 and scheduled[1151]==240,'后两次原始减速时间点/持续时间没有执行')
local start=c.time;T.set(c,.33)
local frames=0
for _=1,300 do if T.allowFrame() then frames=frames+1 end end
assert(frames==99,'300真实帧必须只推进99游戏帧：'..frames)
assert(c.time==start,'时间预算本身不能额外推进弹幕')
R.clear(c);assert(T.scale==1 and T.budget==0 and not T.owner,'结束符卡后减速泄漏')
for _=1,60 do assert(T.allowFrame()) end
print('霜寒亿万劫：180/780/1150tick、270/120/240tick持续、69tick恢复、全局0.33预算与清场通过。')
