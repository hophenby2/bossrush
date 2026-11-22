-- 天舞宝轮：重放原始 C# 点弹轨迹，核对数量、消失时间及位置；激光轨迹不在此夹具内。
arg={'th37-wheel'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
ran.Float=function(_,a,b)return (a+b)/2 end
local R=dofile('mod/GAME/th37/runtime.lua')
R.sound=function() end
player.protect,player.death=999,0
local expected={}
for line in io.lines('tools/th37-tests/oracle/wheel/wheel.tsv') do
 local a={};for word in line:gmatch('%S+') do a[#a+1]=tonumber(word) or word end
 local key=table.concat({a[3],a[4],a[5],a[6]},':')
 local group=expected[key] or {};expected[key]=group;group[#group+1]={a[7],a[8]}
end
local objects,raw={},New
New=function(cls,s,...)local o=raw(cls,s,...);objects[#objects+1]=o;return o end
local c=R.controller({_live=true,x=-2,y=52},'587');player.x,player.y=0,-180
local count,maximum=0,0
for tick=1,5400 do
 R.tick(c)
 local born=#objects
 for i=1,born do local o=objects[i];if IsValid(o) then o.class.frame(o) end end
 if tick%300==0 or tick==90 then
  for _,o in ipairs(objects) do local s=o.mhj
   if IsValid(o) and s.kind~='laser' then
    local key=table.concat({tick,s.layerid,s.parentid,s.age},':')
    local group=assert(expected[key],'多出了原作没有的点弹：'..key)
    local nearest,distance
    for i,point in ipairs(group) do
     local delta=((point[1]-s.fx)^2+(point[2]-s.fy)^2)^.5
     if not distance or delta<distance then nearest,distance=i,delta end
    end
    assert(distance and distance<.01,'点弹位置偏离原作：'..key..' / '..tostring(distance))
    table.remove(group,nearest);if #group==0 then expected[key]=nil end
    count=count+1;maximum=math.max(maximum,distance)
   end
  end
 end
 if tick%60==0 then local live={};for _,o in ipairs(objects)do if IsValid(o)then live[#live+1]=o end end;objects=live end
end
assert(not next(expected),'漏掉了原作仍存活的点弹')
R.clear(c)
print(('天舞宝轮 5400 帧：%d 个原作点弹采样全部匹配，最大位置误差 %.8f 像素，无多弹或漏弹。'):format(count,maximum))
