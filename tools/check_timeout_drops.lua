-- 超时奖励执行当前正式掉落入口。
lstg={var={}}
stage={current_stage={is_menu=false}}
Rand=function() return {Seed=function() end,Int=function(_,a) return a end} end
local D=dofile('THlib/drops.lua')
local count=0
local function check(v,label) assert(v,label);count=count+1 end
local function reset()
    lstg.var={__drops_version=D.VERSION,dead=3,ran_seed=123};D.reset()
end
local function boss(id)
    local card={card_id=id,is_combat=true}
    local b={current_card=card,is_combat=true,timeout=true,otherboss={}}
    D.beginCard(b,card);return b
end
-- 正式结算先清空收卡标记，再发强化；验证此顺序不会重新引入中弹限制。
local f=assert(io.open('THlib/enemy/boss_system.lua','rb'));local source=f:read('*a');f:close()
local first=assert(source:find('function system:kill()',1,true))
local last=assert(source:find('function system:del()',first,true))
local system={};assert(loadstring('local system=...\n'..source:sub(first,last-1)))(system)
local function noop() end
for _,missed in ipairs({false,true}) do
    reset();local b=boss(11);b.ui={};b.__NoPlayerProtect=true;b.current_card.del=noop
    if missed then lstg.var.dead=4 end
    local s=setmetatable({boss=b,clearBonus=function() b.chip_bonus=false end,
        KillBonus=noop,refresh=noop,popSpellResult=noop,popResult=noop},{__index=system})
    s:kill()
    check(#lstg.var.upgrades.queue==1,'正式Boss超时结算不依赖失误计数')
end
print(('超时掉落回归通过：%d 项。'):format(count))
