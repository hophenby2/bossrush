-- 正式流星花火弹体与共用消弹入口：重叠Bomb、0帧消散标记、原寿命和安全退组。
arg={'fireworks-bomb-cancel'}
local f=assert(io.open('tools/check_stage.lua'));local source=f:read('*a');f:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
local R=dofile('mod/GAME/th39/runtime.lua');R.sound=function()end
math.randomseed(739)
local rawNew=New
local objects,example={},nil
New=function(class,...)
 local o=rawNew(class,...);objects[#objects+1]=o
 if o.mhj and o.mhj.type==52 then example=example or o.mhj end
 return o
end
local c=R.controller({_live=true,x=0,y=100},'143',false,{[1]={10,5400,54},[4]={2,2100}})
for tick=1,375 do
 R.tick(c)
 local i=1
 while i<=#objects do local o=objects[i];if IsValid(o) and o.class.frame then o.class.frame(o)end;i=i+1 end
end
assert(example,'没有生成流星花火散弹')
local f=assert(io.open('THlib/bullet/visual_match.lua'));local v=f:read('*a');f:close()
local a=assert(v:find('local function spawn_left(',1,true));local b=assert(v:find('function V.sync_spawn(',a,true))
OriginalBulletVisual=assert(loadstring("local V={is_cancelling=dofile('THlib/bullet/cancel_state.lua')};"..v:sub(a,b-1)..'return V'))()
dofile('THlib/bullet/clearbullet.lua')
local rawDist=Dist
Dist=function(a,b,c,d)if type(a)=='table' and type(b)=='table' then return rawDist(a.x,a.y,b.x,b.y)end;return rawDist(a,b,c,d)end
local test,calls={},0
object.LaserDo,object.IndesDo=function()end,function()end
object.BulletDo=function(fn)for _,o in ipairs(test)do if IsValid(o)then fn(o)end end end
object.Kill=function(o)calls=calls+1;o.class.kill(o)end
object.Del=function(o)calls=calls+1;o.class.del(o)end
for _,mode in ipairs({'host','source'})do
 test={};calls=0
 for i=1,10 do
  local s={};for k,v in pairs(example)do s[k]=v end
  s.dis,s.cancelAlpha,s.counted,s.bucket=nil,nil,false,nil
  s.changes,s.limits={},{};s.fx,s.fy=481,360;s.wscale,s.hscale=1,1
  test[#test+1]=rawNew(R.classes.projectile,s)
 end
 local initial={};for _,o in ipairs(test)do initial[o]=o.group end
 local killer=rawNew(bomb_bullet_killer,0,0,10000,10000,false)
 local function cancel()
  if mode=='host' then bomb_bullet_killer.frame(killer)
  else for _,o in ipairs(test)do if IsValid(o) and not o.mhj.dis then object.Del(o)end end end
 end
 cancel();cancel() -- 同帧两个范围重叠也只允许第一次进入消散。
 assert(calls==10,'重叠消弹重复触发回调')
 for _,o in ipairs(test)do assert(o.group==initial[o],'消弹回调内提前换组')end
 for tick=1,31 do
  for _,o in ipairs(test)do if IsValid(o)then o.class.frame(o)end end
  cancel()
  if tick==1 then for _,o in ipairs(test)do assert(o.group==GROUP.GHOST and not o.colli,'淡出更新未安全退组')end end
  if tick==30 then for _,o in ipairs(test)do assert(IsValid(o),'30帧淡出被提前删除')end end
 end
 local alive=0;for _,o in ipairs(test)do if IsValid(o)then alive=alive+1 end end
 assert(calls==10 and alive==0,'持续消弹重复触发或原淡出寿命改变')
 print('PASS '..mode..': 10颗弹体只取消10次，31帧后回收')
end

-- 春雪的真实弹体同样保留20帧原消散，第二次消弹不能重置动画。
local Spring=dofile('mod/GAME/th37/runtime.lua');Spring.sound=function()end
local springShots={}
New=function(class,...)local o=rawNew(class,...);if class==Spring.classes.projectile then springShots[#springShots+1]=o end;return o end
local sc=Spring.controller({_live=true,x=0,y=100},'191',true)
for i=1,60 do Spring.tick(sc)end
assert(#springShots==2)
test=springShots;calls=0
local killer=rawNew(bomb_bullet_killer,0,0,10000,10000,false)
bomb_bullet_killer.frame(killer);bomb_bullet_killer.frame(killer)
assert(calls==2)
for i=1,20 do
 for _,o in ipairs(test)do if IsValid(o)then o.class.frame(o)end end
 bomb_bullet_killer.frame(killer)
 if i==1 then for _,o in ipairs(test)do assert(o.group==GROUP.GHOST)end end
 if i==19 then for _,o in ipairs(test)do assert(IsValid(o))end end
end
assert(calls==2);for _,o in ipairs(test)do assert(not IsValid(o))end
print('PASS 春雪：两颗只取消两次，保留20帧淡出')
-- 已开始消散的源激光不再重置age，旧作/栖霞园标记及待删除对象也被统一排除。
for _,runtime in ipairs({R,Spring})do
 local o={_live=true,x=0,y=0,class=runtime.classes.beam,mhj={age=50,life=100}}
 object.Kill(o);o.mhj.age=105
 for i=1,30 do if not OriginalBulletVisual.is_cancelling(o)then object.Kill(o)end end
 assert(o.mhj.age==105,'激光淡出计时被重复重置')
end
for _,fields in ipairs({{mhj={dis=0}},{mhj={dis=true}},{fade_out=true},{_native_cancelled=true},
 {_original_despawning=true},{status='del'},{status='kill'},{_live=false}})do
 assert(OriginalBulletVisual.is_cancelling(fields),'未跳过既有退场状态')
 assert(not OriginalBulletVisual.can_cancel(fields,true),'强制清场重新触发退场回调')
end
assert(not OriginalBulletVisual.is_cancelling({_live=true,mhj={dis=false}}))
print('PASS 同类状态、激光计时与强制消弹边界')

local V=OriginalBulletVisual
for _,o in ipairs({{imgclass={native_game=6},th06_spawn=10},{imgclass={native_game=7},c_spawn_left=10},
 {imgclass={native_game=8},ex_flags=4096},{imgclass={native_game=10},tb={cancel=20}}})do
 assert(not V.can_cancel(o,false) and V.can_cancel(o,true),'首次消弹的出生/免疫规则改变')
end
local pending={imgclass={native_game=8},ex_flags=0,ex_spawn=4}
local before=calls;V.cancel_bullet(pending,'Del');V.cancel_bullet(pending,'Del')
assert(calls==before and pending._original_cancel_pending=='Del','永夜抄弹雾待处理规则改变')
assert(not V.can_cancel({_original_enemy_projectile=true},true),'妖妖梦敌机弹体被误消')
print('PASS 首次消弹免疫、出生期与强制清场规则')

-- 实际旧式持续消弹也不能重复生成掉落或重新启动动画。
local function section(path,first,last)
 local f=assert(io.open(path));local s=f:read('*a');f:close()
 local a=assert(s:find(first,1,true));local b=assert(s:find(last,a,true))
 return s:sub(a,b-1)
end
local hzc=assert(loadstring(section('Resources/System/system.lua','local hzc_bullet_cleaner = Class','_G.hzc_bullet_cleaner =')..'return hzc_bullet_cleaner'))()
local beast=assert(loadstring('local Beast={};'..section('Resources/System/Beast.lua','local bullet_killer = Class','Beast.bullet_killer =')..'return bullet_killer'))()
local season=assert(loadstring('local Attack={};'..section('Resources/System/Season.lua','function Attack:frame()','function Attack:render()')..'return Attack'))()
for _,class in ipairs({hzc,beast,season})do
 local rewards=0;New=function()rewards=rewards+1;return{}end
 local o={_live=true,x=0,y=0,class={del=function(b)b.fade_out=true end,kill=function(b)b.fade_out=true end}}
 test={o};calls=0
 local cleaner={x=0,y=0,a=100,timer=10,colli=true,drop_item=function()rewards=rewards+1 end}
 class.frame(cleaner);class.frame(cleaner)
 assert(calls==1 and rewards<=1,'旧式消弹重复回调/掉落')
end
print('PASS 花映冢、兽系统、季节释放不重复消弹/掉落')

-- 一帧辅助对象退出时不再扫描；持续范围下一帧的新对象仍能处理新弹。
local scans=0
object.BulletDo=function(fn)scans=scans+1;for _,o in ipairs(test)do if IsValid(o)then fn(o)end end end
local function shot(x,y)
 return {_live=true,x=x,y=y,class={kill=function(o)o.fade_out=true end}}
end
test={shot(3,4),shot(6,8)};calls=0
local first=rawNew(bomb_bullet_killer,0,0,10,10,false);first.timer=0
bomb_bullet_killer.frame(first)
assert(calls==1 and test[1].fade_out and not test[2].fade_out,'严格半径边界改变')
test[#test+1]=shot(0,0)
first.timer=1;bomb_bullet_killer.frame(first)
assert(scans==1 and calls==1 and not IsValid(first),'辅助对象退出时仍重复扫描')
local nextFrame=rawNew(bomb_bullet_killer,0,0,10,10,false);nextFrame.timer=0
bomb_bullet_killer.frame(nextFrame)
assert(scans==2 and calls==2 and test[3].fade_out,'下一帧范围未处理新出生子弹')
local immune={_live=true,imgclass={native_game=10},tb={cancel=3}}
assert(not V.can_cancel(immune,false))
immune.tb.cancel=0;assert(V.can_cancel(immune,false),'实时解除免疫被缓存')
immune.status='kill';assert(not V.can_cancel(immune,true),'强制消弹重复处理待删除弹')
print('PASS 单帧扫描、半径边界、新弹与实时免疫')
