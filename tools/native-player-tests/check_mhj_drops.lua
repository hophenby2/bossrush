-- ItemManager.Shoot / ItemMass.Shoot：库存项、满 P 转点、难度限制和散布单位。
local file=assert(io.open('THlib/native_players.lua'));local text=file:read('*a');file:close()
local first=assert(text:find('function P.drop(',1,true))
local last=assert(text:find('function P.hitShot(',first,true))
local state={power=400};local rows={}
local env={P={adapters={},enabled=function() return true end,state=function() return state end},
    ResourceItem={},stage={current_stage={group={difficulty=4}}},tonumber=tonumber,math=math,
    cos=function(a) return math.cos(math.rad(a)) end,sin=function(a) return math.sin(math.rad(a)) end,
    ran={Float=function(_,a,b) return (a+3*b)/4 end},
    New=function(_,x,y,kind,amount) rows[#rows+1]={x=x,y=y,kind=kind,amount=amount} end}
setfenv(assert(loadstring(text:sub(first,last-1),'@THlib/native_players.lua/drop')),env)()
local function counts()
    local c={};for _,r in ipairs(rows) do c[r.kind]=(c[r.kind] or 0)+1 end
    return c
end
local items={100,2,100,3,1,100,4,100,6}
env.P.drop(35,0,0,items,true,false)
local c=counts()
assert(#rows==9 and c.bigPoints==2 and c.points==5 and c.life==1 and c.bombs==1 and not c.power)
assert(rows[1].x==35 and rows[1].y==-35 and rows[2].x==17.5 and rows[2].y==-17.5)
assert(rows[8].amount==5 and rows[9].amount==5)
rows={};state.power=200
env.P.drop(35,10,20,{0,0,100,1,4,6},false,false,80)
assert(#rows==2 and rows[1].kind=='power' and rows[1].amount==100 and rows[2].amount==5)
assert(rows[1].x==50 and rows[1].y==-20 and rows[2].x==30 and rows[2].y==0)
rows={};env.stage.current_stage.group.difficulty=5
env.P.drop(35,0,0,items,true,false)
c=counts();assert(#rows==20 and c.life==5 and c.bombs==7 and c.power==5)
rows={};env.P.drop(37,0,0,items,true,true)
c=counts();assert(#rows==16 and c.bigPoints==1 and c.points==5 and c.bombs==10 and not c.life)
for _,r in ipairs(rows) do if r.kind=='bombs' then
    assert(r.amount==1 and math.abs((r.x*r.x+r.y*r.y)^.5-44*2/3)<1e-8)
end end
rows={};env.P.drop(37,0,0,items,true,false)
c=counts();assert(#rows==18 and c.life==5 and c.bombs==7)
print('春雪满 P/非满 P、L/Extra、永夜符卡/非符的掉落数量、概率项和散布通过')
