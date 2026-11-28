-- 两名独立Boss错帧击破：各自完整播放60帧死亡演出，旧task/卡片frame不再发弹。
local noop=function() end
max,min,int=math.max,math.min,math.floor
cos=function(a) return math.cos(math.rad(a)) end
sin=function(a) return math.sin(math.rad(a)) end
ran={Float=function(_,a,b) return (a+b)/2 end,Int=function(_,a) return a end,Sign=function() return 1 end}
lstg={world={boundl=-224,boundr=224,boundb=-256,boundt=256}}
player={x=0,y=-176,protect=0,nextspell=0}
boss={};object={};plus={Class=function() return {} end};item={}
PlaySound,SetAttr=noop,noop;BoxCheck=function() return true end
IsValid=function(o) return o and o._live end
object.Preserve=function(o) o._live=true end
object.KillServants=noop
object.Del=function(o) o._live=false end
object.Kill=function(o) o._bosssys:kill() end
dofile('THlib/lib/Ltask.lua')
local flashes,particles={},{}
boss_explode_cherry,boss_death_ef_unit,bullet_cleaner={},{},{}
New=function(class,x,y)
    if class==boss_explode_cherry then flashes[#flashes+1]={x,y}
    elseif class==boss_death_ef_unit then particles[#particles+1]={x,y} end
end
dofile('THlib/enemy/boss_system.lua')
local function make(x)
    local b={_live=true,x=x,y=100,timer=0,maxhp=100,hp=100,is_combat=true,is_final=true,
        __card_timer=0,sc_pro=0,t1=0,t2=0,t3=3600,_colli=true,__NoCleanBullet=true,ui={_live=true}}
    local fired,deleted=0,0
    b.current_card={frame=function() fired=fired+1 end,del=function() deleted=deleted+1 end}
    local sys={boss=b}
    for _,name in ipairs({'clearBonus','KillBonus','checkAutoSPPoint','updateHPFlags','updatePosition','updateBG','checkBonus','popSpellResult'}) do sys[name]=noop end
    sys.popResult=function() object.Del(b) end
    setmetatable(sys,{__index=boss.system});b._bosssys=sys
    task.New(b,function() while true do fired=fired+1;task.Wait() end end)
    task.New(sys,function() while true do fired=fired+1;task.Wait() end end)
    return b,function() return fired,deleted end
end
local a,ac=make(-96);local b,bc=make(96)
local function step(o) if IsValid(o) then o._bosssys:frame();o.timer=o.timer+1 end end
step(a);step(b)
local fa,fb=ac(),bc()
a.hp=0;step(a)
assert(a.is_exploding and IsValid(a),'第一名Boss没有保留死亡演出')
for _=1,9 do step(a);step(b) end
assert(ac()==fa and bc()>fb,'死亡Boss继续发弹，或错误停止另一名活着的Boss')
b.hp=0;step(b);fb=bc()
-- 重复击破不能重新执行del或叠加一条死亡协程。
object.Kill(a);object.Kill(b)
for _=1,51 do step(a);step(b) end
assert(not IsValid(a) and IsValid(b) and b.is_exploding,'第一名结束时截断了第二名的演出')
for _=1,9 do step(b) end
assert(not IsValid(b) and #flashes==2 and #particles==120,'两名Boss没有各自完整演出')
local _,da=ac();local _,db=bc()
assert(da==1 and db==1 and ac()==fa and bc()==fb,'死亡期间恢复攻击或重复结算')
-- 双体卡只有一个流程宿主；卡片del立即回收身体，演出仍必须保留两个实际位置。
flashes,particles={},{}
local host=make(0)
host.hide=true;host.dropitem={1,2,3}
local left={_live=true,x=-75,y=80};local right={_live=true,x=95,y=120}
host.asl_controller={linked=true,entities={{kind='boss',main=true,alive=true,native=left},{kind='boss',alive=true,native=right}}}
host.current_card.del=function()
    object.Del(left);object.Del(right);host.asl_controller=nil;host.hide=false
end
host.hp=0;step(host)
assert(host.hide and host.dropitem,'死亡时显示了隐藏流程宿主，或提前丢失结算掉落')
for _=1,60 do step(host) end
assert(#particles==120 and #flashes==2,'双体卡只在流程宿主播放了一次死亡演出')
assert(flashes[1][1]==-75 and flashes[1][2]==80 and flashes[2][1]==95 and flashes[2][2]==120,'死亡演出没有取两个真实身体的位置')
print('双Boss独立完整死亡演出、停火、重复击破及错帧回收检查通过')
