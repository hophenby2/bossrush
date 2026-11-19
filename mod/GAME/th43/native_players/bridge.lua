-- 原作装备与 PowerRank 在独立环境中运行，宿主负责录像、输入与残机。
local R=...
local B={}
local E=R.env
local env=setmetatable({}, {__index=E})
local api=setmetatable({}, {__index=E.lstg})
local base=Class(object)
env.lstg,env.player_class=api,base
env.enemybase=setmetatable({damage=Damage},{__index=enemybase})
env.EISlib=setmetatable({Player={path='EISlib/player/',scale=.85}}, {__index=E.EISlib})
env.database={setting={gameplay={show_powerup_popup=false}}}
env.source_interpolation={balance=function(v,a,b,d,up)
    return math.max(a,math.min(b,v+(up and d or -d)))
end}
env.KeyIsDown=function(key) return player and player._playersys.keyState[key] or false end
env.KeyPress=env.KeyIsDown
env.tasker=function(f) return E.New(tasker,f) end
env.New=function(class,...)
    local o=E.New(class,...)
    if o.group==GROUP.PLAYER_BULLET then
        o.native_th43,o.native_alpha=true,255
        if player and player.native_level==41 then player.bdb_emitted=(player.bdb_emitted or 0)+1 end
    end
    return o
end
api.New=env.New
api.Print=lstg.SystemLog
api.Class=Class
env.boss=setmetatable({action={Type={Card='card'}},GetFirstBoss=function()
    local b=boss.GetFirstBoss and boss.GetFirstBoss() or _boss
    if b and IsValid(b) and b._bosssys then
        b._bosssys.getCurrentCard=function()
            local c=b.current_card
            return c and {type='card',mode=c.t1==c.t3 and 'timespell' or 'spell'}
        end
    end
    return b
end}, {__index=E.boss})
local function load(path)
    local rel=path:gsub('^EISlib/player/','')
    local chunk=assert(loadfile('mod/GAME/th43/native_players/'..rel))
    return setfenv(chunk,env)()
end
env.DoFile,api.DoFile=load,load
local originalPower=E.system.PowerRank
load('auxiliary.lua')
load('bomb_effect.lua')
load('PowerRank.lua')
local power=E.system.PowerRank
-- 已载入的道具/敌机脚本持有原表，原表本身保留，函数统一换成发行版。
for k,v in pairs(power) do originalPower[k]=v end
E.system.PowerRank=originalPower
B.power=originalPower
originalPower._original=true
local function sync()
    local s=NativePlayers.state()
    originalPower.rank,originalPower.hyper,originalPower.time=power.getRank(),power.isInHyper(),power.getHyperTime()
    if s then
        s.rank,s.rankChips,s.rankValue=power.getRank(),power.getChip(),power.getValue()
        s.hyperChips=power.getHyperChipLeft()
    end
end
B.sync=sync
function R.addRankChip(n) power.addChip(n);sync() end
function R.gainRankValue(n) power.addValue(n);sync() end
function R.tryHyper()
    if power.canHyper() and not power.isInHyper() and player.nextspell<=0 then power.hyperStart();sync();return true end
end
function R.playerMiss() power.missEvent();sync() end
function base.init(p)
    p.lh,p.shift,p.lock_player_shift=0,1,0
    p.lockshoot,p.lockspell,p.max_nextspell=0,0,360
    p.attack_speed,p.speed_rate,p.fire_buff,p.laser_rate=1,1,1,1
    p.graze_bonus_rate,p.minor_bonus_rate,p.chip_bonus_rate=1,1,1
    p._collecter={setCollectRange=function(_,h,l) p.bdb_collect={h,l} end,
        setCollectChipRange=function(_,h,l) p.bdb_collect_chip={h,l} end}
    p.component={Move={setSpeed=function(_,h,l) p.hspeed,p.lspeed=h,l end,
        setLock=function(_,v) p.bdb_move_lock=v end}}
    p.component.DarkMask=E.New(B.darkmask)
    p.component.DarkMask:setPlayer(p)
    power.Init(p)
end
function base.spell(p)
    E.PlaySound('cat00');p.nextspell=p.max_nextspell
    p.protect=math.max(p.protect,p.max_nextspell+60)
end
function base.changeSpeed(p,h,l) p.component.Move:setSpeed(h,l) end
function base.changeGrazeRange(p,h,l) p.bdb_graze={h,l};p.grazeRadius=h end
function base.isInDeathSentence(p) return p.hit~=nil end
function base.isInRevive(p) return p.native_death_clock~=nil or p.death>0 end
function base.isInBomb(p) return p.nextspell>0 end
function base.isUseSpell(p) return p.nextspell==p.max_nextspell-1 end
function base.isMiss() return false end -- miss() 已在扣残机的同一帧通知 PowerRank。
env.PlayerWalkImageSystem=function(p) return p._wisys end
load('resources.lua')
B.darkmask=load('darkmask.lua')
load('equip_system.lua')
E.EISlib.Player=env.EISlib.Player
local classes={}
function B.bind(p)
    env.player,api.player=p,p
    local pool=GetResourceStatus();SetResourceStatus('global')
    E.LoadImageFromFile('board_ch','res/player/board_ch.png')
    local c=classes[p.machine.id]
    if not c then c=load(p.machine.id..'/'..p.machine.id..'.lua');classes[p.machine.id]=c end
    SetResourceStatus(pool)
    local delegates={}
    for name,value in pairs(p.class) do delegates[name]=value end
    for _,name in ipairs({'changeEquip','hyperStart','hyperHited','hyperEnd','changeSpeedWhenBomb','recoveredSpeed','recoveredCollectRange'}) do
        delegates[name]=c[name]
    end
    local class=Class(p.class,delegates);api.RegisterClass(class);p.class=class
    p.bdb_source=c
    power.init()
    local status=GetResourceStatus();SetResourceStatus('global');c.init(p);SetResourceStatus(status)
    p.hscale,p.vscale=.85*.5,.85*.5
    sync()
end
function B.shoot(p) p._shoot_equip:shoot() end
function B.spell(p) p.bdb_source.spell(p) end
function B.frame(p)
    env.player,api.player=p,p
    p.lh=math.max(0,math.min(1,p.lh+(p.slow==1 and 1/6 or -1/6)))
    p.shift=1-p.lh
    if p.bdb_graze then
        local r=p.bdb_graze[1]+(p.bdb_graze[2]-p.bdb_graze[1])*p.lh
        p.grazer.a,p.grazer.b=r,r
    end
    p.lock_player_shift=math.max(0,p.lock_player_shift-1)
    p.lockshoot,p.lockspell=math.max(0,p.lockshoot-1),math.max(0,p.lockspell-1)
    p._shoot_equip:update()
    power.Frame(p)
    sync()
end
function B.hit(p)
    local death=p.death
    p.death=91
    local caught=false
    if power.isInHyper() then
        if power.getHyperTime()>power.getHyperMaxTime()-120 then caught=true
        elseif power.isHyperPaused() then power.hyperPauseHit(p);caught=p.death==0
        else power.hyperHit(p);caught=p.death==0 end
    else
        power.normalHit(p)
        if power.isHitedToHyper() then power.hyperStart();power.closeHitedToHyper();caught=true end
    end
    p.death=death
    sync();return caught
end
function B.render(p) p._shoot_equip:draw() end
return B
