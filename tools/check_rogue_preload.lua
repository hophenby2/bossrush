-- 比较完整预演与分帧快照；原作粒子、插值、随机数和引用保持一致。
arg={'rogue-preload'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local P=dofile('mod/rogue_preload.lua')
RogueEncounter={checkpoint=P.checkpoint,copyPrepared=P.copy}
local R=dofile('mod/GAME/th39/runtime.lua')
local B=dofile('mod/GAME/th39/background.lua')
setting={displayBG=true}
local chapter,group,meta
for _,ch in ipairs(R.data.chapters)do for _,g in ipairs(ch.bosses)do for _,m in ipairs(g.cards)do
 if m.id==39001 then chapter,group,meta=ch,g,m end
end end end
-- show(0) 仅初始化模块的运行时引用，随后直接比较相同 Boss 时刻。
B.show(R,chapter,0)
local baseline=B.seek(chapter,group.time)
local actualWait=task.Wait;task.Wait=function()coroutine.yield()end
local function prepare()
 local co=coroutine.create(function()P.run(function()B.prepare(R,chapter,group.time,group,meta)end)end)
 assert(coroutine.resume(co));local slices=0
 while P.active()do P.frame();slices=slices+1;assert(slices<10000)end
 assert(coroutine.resume(co));return slices
end
local function compare(a,b,seen)
 if type(a)~='table' then if type(a)~='function' then assert(a==b,tostring(a)..' / '..tostring(b))end;return end
 seen=seen or {};if seen[a] then assert(seen[a]==b,'快照内部引用不一致');return end;seen[a]=b
 for k,v in pairs(a)do
  -- 图定义和装载记录不属于运动状态；索引映射在下面逐粒子核对。
  if k~='pattern' and k~='script' and k~='resources' and k~='bullets' and k~='parents' and k~='bucket' and k~='onQuake' then
   if type(k)~='table' then compare(v,b[k],seen)end
  end
 end
end
local slices=prepare()
local scene=New(B.show(R,chapter,0).class,chapter,group.time)
compare(baseline,scene.state)
local count=0
for _,c in ipairs(scene.state.effects)do for _,s in ipairs(c.particles)do
 assert(s.controller==c and c.bullets[s]==s,'粒子所属关系丢失')
 if s.bucket then assert(s.bucket[s]==s,'绑定索引丢失')end
 count=count+1
end end
-- 修改运行实例后，再次准备必须恢复未被污染的入口快照。
scene.state.effects[1].seed=0
local repeated=prepare()
local other=New(scene.class,chapter,group.time);compare(baseline,other.state)
-- 入场期间移动会使旧快照失效；延迟构造仍应使用原回调当时的自机位置。
prepare()
player.x,player.y=23,-157
local x,y=R.player();local expected=B.seek(chapter,group.time,{x,y})
RogueEncounter.deferBackground=function(fn)P.defer(fn);return true end
local moving=New(scene.class,chapter,group.time)
assert(not moving.state and P.active(),'移动后仍错误使用旧位置快照')
B.tick(group.time)
local actualBg=lstg.tmpvar.bg
lstg.tmpvar.bg={_live=true,class=moving.class,chapter=chapter,state=expected};B.tick(group.time);lstg.tmpvar.bg=actualBg
player.x,player.y=47,-153
moving.class.frame(moving);moving.class.frame({state=expected})
-- 同一原回调内排队的符卡背景事件也必须重放，并清除临时瞄准点。
B.card(chapter,group,meta)
lstg.tmpvar.bg={_live=true,class=moving.class,chapter=chapter,state=expected};B.card(chapter,group,meta);lstg.tmpvar.bg=actualBg
player.x,player.y=-40,-190
local movedSlices=0
while P.active()do P.frame();movedSlices=movedSlices+1;assert(movedSlices<10000)end
compare(expected,moving.state)
print(('自机改变位置后，后台预演与原回调位置、排队时钟完全一致：%d帧。'):format(movedSlices))
task.Wait=actualWait
print(('永夜背景：%d个原作粒子与全部可变状态一致；首次分摊%d帧，快照复用%d帧，引用与实例隔离通过。'):format(count,slices,repeated))
