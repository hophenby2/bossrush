-- Rebound.cs：线段起点、相对位移、单面和次数限制。正式运行时的同一 field 函数。
arg={'th39-rebound'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th39/runtime.lua')
local field
for i=1,100 do local name,value=debug.getupvalue(R.tick,i);if not name then break end;if name=='field' then field=value end end
assert(field,'未找到正式反弹路径')
local checks=0
for _,oneSide in ipairs({false,true}) do
 for _,direction in ipairs({-1,1}) do
  for _,height in ipairs({-21,-10,0,10,21}) do
   for _,count in ipairs({0,1}) do
    local b={alive=true}
    local s={layerid=0,Rebound=true,age=20,fx=-direction*.5,fy=height,mx=2*direction,my=0,
        sonspeedd=direction==1 and 0 or 180,sonspeed=2,reboundCount=count,xscale=1,yscale=1}
    local c={visual=true,offsetx=0,offsety=0,bullets={[b]=s}}
    local o={kind='rebound',parentid=0,x=0,y=-20,longs=40,angle=90,time=1,mx=0,my=0,oneSide=oneSide}
    field(o,c,1)
    local hit=height>=-20 and height<=20 and count<1 and (not oneSide or direction<0)
    assert(s.reboundCount==count+(hit and 1 or 0),'反弹面或次数不同')
    assert(math.abs(s.fx-(hit and -direction*1.5 or -direction*.5))<.0001,'反射后的剩余位移不同')
    assert(math.abs(s.mx-(hit and -2*direction or 2*direction))<.0001,'反射方向不同')
    checks=checks+1
   end
  end
 end
end
print('PASS 永夜反弹 '..checks..' 组端点、单面和次数边界')
