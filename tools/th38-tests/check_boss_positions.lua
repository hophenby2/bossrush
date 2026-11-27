-- 四面A/B全部双Boss阶段：出生位置来自prefab，弹幕坐标只作120tick移动目标。
arg={'th38-boss-positions'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th38/runtime.lua')
local A=dofile('mod/GAME/th38/actor.lua');R.actor=A
-- Boss_in.chushix/y + Bossmove.danmu_chushiweizhi，主副体独立导出。
local expected={
 A={{{3.85,-2.5},{5.15,-2.5}},{{4.5,-1.5},{4.5,-3}},{{4.5,3},{4.5,-2.5}},
    {{4.5,3},{4.5,-2.5}},{{4.5,-3},{-1.5,2.5}},{{6.5,-2.5},{2.5,-2.5}},{{4.5,-4.75},{4.5,-4.75}}},
 B={{{5.15,-2.5},{3.85,-2.5}},{{4.5,-3},{4.5,-1.5}},{{4.5,-2.5},{4.5,3}},
    {{4.5,-2.5},{4.5,3}},{{-1.5,2.5},{4.5,-3}},{{6.5,-2.5},{2.5,-2.5}},{{4.5,-4.75},{4.5,-4.75}}},
}
local function near(a,b,label)assert(math.abs(a-b)<1e-7,label..': '..a..' / '..b)end
local checked,moving=0,0
for _,route in ipairs({'A','B'})do for phase,positions in ipairs(expected[route])do
 local key='L/stage4/boss'..route..'/'..phase
 local host={_live=true,x=0,y=110,hp=100000}
 local c=R.controller(host,key)
 local bosses={}
 for _,s in ipairs(c.entities)do if s.kind=='boss'then bosses[#bosses+1]=s end end
 assert(#bosses==2,'双Boss数量不符：'..key)
 for i,s in ipairs(bosses)do
  near(s.x,positions[i][1],key..'初始x');near(s.y,positions[i][2],key..'初始y')
  local o=s.native or s.main and host;local x,y=R.project(s.x,s.y)
  near(o.x,x,key..'出生投影x');near(o.y,y,key..'出生投影y')
  assert(o.asl_actor and o.asl_actor.profile==A.data.phases[key][i],'主副体绑定错位')
 end
 -- 无坐标事件的两个代表阶段，独立积分原作Bossmove的正弦入场速度。
 if phase==1 or phase==3 then
  local positionsNow={{unpack(positions[1])},{unpack(positions[2])}}
  for tick=0,120 do
   R.step(c)
   for i,s in ipairs(bosses)do
    local p=positionsNow[i];local initial=positions[i];local e=s.settings
    if e.a51_4==1 then
     local k=math.pi*.00417*math.sin(.0261694659*tick)
     p[1],p[2]=p[1]+(e.a2_1-initial[1])*k,p[2]+(e.a2_3-initial[2])*k
    end
    near(s.x,p[1],key..'校准x');near(s.y,p[2],key..'校准y')
   end
  end
  for _,s in ipairs(bosses)do assert(not s.entryMotion,'120tick校准没有结束')end
  moving=moving+2
 end
 R.clear(c);checked=checked+1
end end
-- 卡内阈值转阶段仅换发射器，不重复从prefab瞬移或重新校准。
local c=R.controller({_live=true,x=0,y=110,hp=100000},'L/stage6/boss1/10')
for _=1,40 do R.step(c)end
local x,y=c.entities[1].x,c.entities[1].y
R.transition(c,'L/stage6/boss1/10/p2',true,true)
local s=c.entities[1];near(s.x,x,'转阶段x');near(s.y,y,'转阶段y');assert(not s.entryMotion)
R.clear(c)
print(('PASS 雪莲华双Boss：%d阶段、28个出生位置/角色绑定，%d条120tick轨迹、卡内转阶段不瞬移'):format(checked,moving))
