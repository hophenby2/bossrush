local C=dofile('mod/GAME/ports/source_csharp.lua').new()
local factory=dofile('mod/GAME/ports/mhj/native_players/target_collision.lua')
local seed=12779
local function number() seed=seed*16807%2147483647;return (seed/2147483647-.5)*1000 end
local checked=0
for _,scale in ipairs({1,2/3}) do
    local cx,cy=scale==1 and 224 or 336,scale==1 and 240 or 360
    local valid=function(o) return o and not o.dead end
    local fast=factory(C,valid,scale,cx,cy)
    local function reference(o,p,extend,ray)
        if not valid(o) or not o.colli then return false end
        local c=o.native_actor_collision
        if c and c.noDamage then return false end
        local t=C.Vector2(o.x/scale+cx,cy-o.y/scale)
        local a,b=c and c.damage[1] or o.a,c and c.damage[2] or o.b
        if ray then a,b=a*2,b*2 end
        return math.abs(p.X-t.X)<=a/scale+extend and math.abs(p.Y-t.Y)<=b/scale+extend
    end
    for i=1,10000 do
        local o={x=number(),y=number(),a=math.abs(number())/20,b=math.abs(number())/20,colli=i%13~=0,dead=i%17==0}
        if i%2==0 then o.native_actor_collision={noDamage=i%19==0,damage={o.a/2,o.b/3}} end
        local p=C.Vector2(number(),number());local extend=i%9;local ray=i%3==0
        if i%4==0 then p.X=C.f(o.x/scale+cx)+o.a/scale+extend;p.Y=C.f(cy-o.y/scale) end
        assert(fast(o,p,extend,ray)==reference(o,p,extend,ray),'受弹边界或坐标舍入改变')
        checked=checked+1
    end
end
print(('春雪/永夜目标碰撞 %d 组坐标、边界、无敌和形状切换一致。'):format(checked))
