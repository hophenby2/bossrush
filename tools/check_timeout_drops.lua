-- 超时奖励执行正式掉落入口，覆盖Bomb、复活计数、重复结算与旧录像。
lstg={var={}}
stage={current_stage={is_menu=false}}
Rand=function() return {Seed=function() end,Int=function(_,a) return a end} end
local D=dofile('THlib/drops.lua')
local count=0
local function check(v,label) assert(v,label);count=count+1 end
local function reset(version)
    lstg.var={__drops_version=version,dead=3,ran_seed=123};GameRevive=nil;D.reset()
end
local function boss(id)
    local card={card_id=id,is_combat=true}
    local b={current_card=card,is_combat=true,timeout=true,otherboss={}}
    D.beginCard(b,card);return b
end
for version=1,7 do
    reset(version)
    local b=boss(1);D.startCard(b);b.chip_bonus=false
    check(D.award(b)==(version>=7),'使用Bomb后无中弹超时按录像版本发奖：'..version)
    if version>=7 then
        check(#lstg.var.upgrades.queue==1 and not D.award(b),'全避奖励只发放一次')
    end
end
reset(7)
local b=boss(2);D.startCard(b);lstg.var.dead=4
check(not D.award(b),'阶段内中弹后超时没有奖励')
reset(7)
local misses=12;GameRevive={misses=function() return misses end}
b=boss(3);D.startCard(b);lstg.var.dead=0;misses=13
check(not D.award(b),'复活清零死亡数后仍按累计失误拒绝奖励')
reset(7)
b=boss(4);lstg.var.dead=9;D.startCard(b)
check(D.award(b),'before演出结束前的失误不计入本阶段')
reset(7)
b=boss(5);D.startCard(b);D.beginCard(b,b.current_card);lstg.var.dead=4;D.startCard(b)
check(D.award(b),'同一Boss下一阶段重新记录失误起点')
reset(7)
local a,c=boss(6),boss(6);a.otherboss={c};c.otherboss={a}
D.startCard(a);D.startCard(c)
check(D.award(a) and not D.award(c) and #lstg.var.upgrades.queue==1,'同卡多Boss超时只奖励一次')
for _,version in ipairs({6,7}) do
    reset(version);b=boss(7);b.time_sc=true
    check(D.award(b),'耐久卡完成仍能获得奖励：'..version)
end
reset(7);b=boss(8);b.cannot_kill=true;D.startCard(b)
check(not D.award(b),'伪击破不奖励')
reset(7);b=boss(9);b.is_combat=false;D.startCard(b)
check(not D.award(b),'过场不奖励')
print(('超时全避掉落回归通过：%d 项。'):format(count))
