-- 与未改动的 Damage1 语法树产物比较伤害、擦除、效果和目标选择，覆盖严格边界及双命中。
local C=dofile('mod/GAME/ports/source_csharp.lua').new()
C.env.setmetatable=setmetatable;C.env.setfenv=setfenv
local original=dofile('mod/GAME/th38/native_players/source.lua')(C).Damage1.FixedUpdate
local S={};C.env.Sincos=S
local events={}
local function instantiate(asset,p,r) events[#events+1]='fx:'..asset..':'..p.x..':'..p.y end
local function destroy(o) events[#events+1]='del:'..o.id;o.dead=true end
C.env.Object={__static=true,Instantiate=instantiate}
C.env.UnityEngine={Object={__static=true,Destroy=destroy}}
local fast=dofile('mod/GAME/th38/native_players/damage.lua')(C,S,function(t) return t.position.x,t.position.y end,instantiate,destroy)
local function run(fn,n)
    events={};S.enemy,S.boss=C.List(),C.List()
    S.fenshu_now,S.jiejiefanghu_val,S.se_enemy_hurt_count,S.effect_cut=0,299960,0,n%3
    S.zhuqiang_aim=nil
    local targets={}
    local function target(i,isBoss)
        local t={position={x=(n+i)%7-3,y=(n*i)%7-3}}
        local o={transform=t,life=1000+i*10,wudi_time=(n+i)%3-1,zidanwudi=(n+i)%5==0,
            panding_off=(n+i)%4==0,xuruo=(n+i)%2==0,sdbj=i*.125,id=i}
        t.GetComponent=function() return o end
        o.GetComponent=t.GetComponent
        targets[#targets+1]=o
        if isBoss then S.boss:Add(o) else S.enemy:Add(t) end
    end
    for i=1,4 do target(i,false) end
    for i=5,7 do target(i,true) end
    local self={damage=n%5==0 and 0 or 9,damage_r=n%8*.25,reset_aim=n%2==0,add_jiejie=n%3==0,a='hit',
        transform={position={x=n%3-1,y=n%4-2},rotation={}},gameObject={id='shot'}}
    fn(self)
    local result={table.concat(events,','),S.fenshu_now,S.jiejiefanghu_val,S.se_enemy_hurt_count,
        self.bm and self.bm.id or 0,self.bm2 and self.bm2.id or 0,self.gameObject.dead or false}
    for _,o in ipairs(targets) do result[#result+1]=o.life end
    for _,o in ipairs(targets) do if o.transform==S.zhuqiang_aim then result[#result+1]='aim:'..o.id end end
    for i,v in ipairs(result) do result[i]=tostring(v) end
    return table.concat(result,'|')
end
for n=1,5000 do assert(run(original,n)==run(fast,n),'Damage1 行为不同：'..n) end
print('雪莲华 Damage1 5000 组伤害、边界、无敌、目标顺序、效果与销毁结果一致。')
