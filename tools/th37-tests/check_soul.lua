-- 只对照彷徨的空蝉的灯笼、影子和追踪魂；按原始C#记录重放同一组自机输入。
arg={'th37-soul'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th37/runtime.lua');local expected,inputs={},{}
R.sound=function() end
player.protect,player.death=999,0
for line in io.lines('tools/th37-tests/oracle/soul/soul.tsv') do
 local v={};for w in line:gmatch('%S+') do v[#v+1]=tonumber(w) or w end
 if v[1]=='P' then inputs[v[2]]=inputs[v[2]] or {};inputs[v[2]][v[3]]={v[4],v[5]}
 else expected[table.concat({v[2],v[3],v[4],v[5]},':')]={unpack(v,6)} end
end
local objects,actualNew={},New
New=function(cls,s,...)local o=actualNew(cls,s,...);objects[#objects+1]=o;return o end
for mode=1,3 do
 local host={_live=true,x=-2,y=52};player.x,player.y=0,-180
 local c=R.controller(host,'652');objects={};local maximum={0};local count,extra=0,0
 for tick=1,880 do
  local px,py=unpack(inputs[mode][tick]);player.x,player.y=px-224,240-py
  R.tick(c)
  for _,o in ipairs(objects) do if IsValid(o) then o.class.frame(o) end end
  for _,o in ipairs(objects) do local s=o.mhj
   if IsValid(o) and s.layerid==2 and (s.parentid==5 or s.parentid==6 or s.parentid==8) then
    local key=table.concat({mode,tick,s.parentid,s.age},':');local e=expected[key]
    if e then
     count=count+1;local delta=((e[1]-s.fx)^2+(e[2]-s.fy)^2)^.5
     if delta>maximum[1] then maximum={delta,key,e[1],e[2],s.fx,s.fy} end
     assert(delta<.05,'魂轨迹与原始C#偏差超过0.05像素：'..key..' / '..delta)
     assert(math.abs(e[5]-s.sonspeed)<1e-6 and e[8]==s.life,'魂的速度阶段或生命时长不同：'..key)
     expected[key]=nil
    else extra=extra+1 end
   end
  end
 end
 assert(extra==0,'多出了原作没有的魂');print(('魂轨迹场景%d：%d个原作坐标，最大误差%.8f像素'):format(mode,count,maximum[1]));R.clear(c)
end
assert(not next(expected),'遗漏原作的魂轨迹记录');print('静止、移动和追灯三种输入，共3655个原始C#坐标全部通过；无多弹、漏弹或消失时间差异。')
