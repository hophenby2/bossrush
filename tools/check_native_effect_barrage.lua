-- 在真实桥接片段上检查永夜妹红B使用的火焰尺寸和速度写回。
local file=assert(io.open('mod/GAME/ports/mhj/native_players/bridge.lua','rb'))
local source=file:read('*a');file:close()
local begin=assert(source:find('local function refreshEffects()',1,true))
local finish=assert(source:find('\ngame.LanternStatus',begin,true))
local CS={List=function()
    return {Add=function(t,v)t[#t+1]=v end}
end,Rectangle=function(x,y,w,h)return {X=x,Y=y,Width=w,Height=h}end}
local bullet={_live=true}
local state={is_projectile=true,age=30,type=1,parentid=2,fx=50,fy=70,head=90,
    wscale=1.7,hscale=.8,speed=3}
local effects={{controller={bullets={[bullet]=state}}}}
local B,game={csm={}},{Crazystorms={}}
local env={B=B,game=game,effects=effects,CS=CS,night=true,
    R={weaponProfile=function() return {0,0,24,48} end},valid=function(o)return o._live end,
    pairs=pairs,ipairs=ipairs,setmetatable=setmetatable,rawset=rawset,math=math,
    cos=function(a)return math.cos(math.rad(a))end,sin=function(a)return math.sin(math.rad(a))end}
local chunk=assert(loadstring(source:sub(begin,finish-1)..'\nreturn refreshEffects'))
setfenv(chunk,env);chunk()()
local view=effects[1].layerm.LayerArray[1].Barrages[1]
assert(view.wscale==1.7 and view.hscale==.8 and view.speed==3)
view.speed=.4
assert(state.speed==.4 and state.motion_dirty)
assert(view:Judge(0,0,0,0,90,20,20))
print('永夜火焰尺寸/速度桥接检查通过')

local body=assert(source:match('function fx:IsClosing%(%) (.-) end'))
local closing=assert(loadstring('return function(self) '..body..' end'))()
local effect={clock=601,time={total=600},specialnotkill=true}
assert(not closing(effect),'原作持续模板循环超过总时长仍须运行')
effect.specialnotkill=false;assert(closing(effect),'单次效果仍按模板结束')
effect.specialnotkill,effect.closed=true,true;assert(closing(effect),'显式关闭仍结束持续效果')
print('永夜持续火焰模板循环检查通过')
