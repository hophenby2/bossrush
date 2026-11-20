-- 原作 BossCard 仅在整卡结束时解除控制；使魔寿命耗尽与击破均产生 Die 通知。
arg={'th39-control'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
-- 本专项直接调用正式清理函数；RawDel 按真实引擎语义不再次分派 del，避免桩件重复计数。
object.RawDel=function(o) o._live=false end
local R=dofile('mod/GAME/th39/runtime.lua')
local config
for _,chapter in ipairs(R.data.chapters) do for _,group in ipairs(chapter.bosses) do
    for _,meta in ipairs(group.cards) do if meta.id==39088 then
        config={};for k,v in pairs(meta.familiars) do config[tonumber(k)]=v end
    end end
end end
local host={_live=true,x=0,y=70}
local c=R.controller(host,'7271',false,assert(config))
local emitter
for _,e in ipairs(c.emitters) do if e.kind=='batch' and e.parentid==0 and e.id==20 then emitter=e end end
-- 原 b7271 用短寿命的第4槽使魔通知换段，单独触发该发射器，不预滚前面的机关。
emitter.bindid=-1;emitter.Deepbind=false;emitter.Mist=false
R.fire(emitter)
local familiar=assert(c.familiars[4])
assert(familiar.mhj.life==2,'原作换段使魔寿命不同')
for _=1,2 do familiar.class.frame(familiar) end
assert(IsValid(familiar),'换段使魔提前死亡')
familiar.class.frame(familiar)
assert(not IsValid(familiar) and c.deadFamiliars[4]==1,'寿命结束没有产生原作 Die 换段通知')
local clears=0
R.sourceStatusClear=function() clears=clears+1 end
local p={_live=true,lock=true}
c.playerStatus=true;c.control={player=p,previous=false}
local next=R.replace(c,host,'7272',false,config)
assert(clears==0 and next.playerStatus and next.control and p.lock,'同卡换段解除了控制/异常状态')
R.clear(next)
assert(clears==1 and not p.lock,'整卡结束没有解除控制/异常状态')
print('胡桃钳：原作2帧使魔自然结束通知、同卡换段保持控制、整卡结束解除控制均通过。')
