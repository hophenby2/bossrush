-- Like Dreamer：复原版战斗回调与原作帧坐标。碰撞、射击与存档由 Boss Rush 管理。
local register=dofile('mod/GAME/ports/register.lua')
local W=register.work('TH42',40)
local env,load=dofile('mod/GAME/ports/environment.lua')('dreamer')
local api=env.lstg
local L=env.LikeDreamer or {}
env.LikeDreamer=L
local objects
local function new(class,...)
    local object=New(class,...)
    if objects then objects[#objects+1]=object end
    return object
end
env.New,api.New=new,new
env.GROUP_GHOST=GROUP.GHOST
env.GROUP_ENEMY=GROUP.ENEMY
env.GROUP_ENEMY_BULLET=GROUP.ENEMY_BULLET
env.GROUP_ENEMY_BULLET2=GROUP.ENEMY_BULLET2
env.GROUP_NONTJT=GROUP.NONTJT
env.GROUP_INDES=GROUP.INDES
env.GROUP_PLAYER=GROUP.PLAYER
env.GROUP_PLAYER_BULLET=GROUP.PLAYER_BULLET
env.GROUP_SPELL=GROUP.SPELL
env.GROUP_ITEM=GROUP.ITEM
env.LAYER_BG=LAYER.BG
env.LAYER_ENEMY=LAYER.ENEMY
env.LAYER_ENEMY_BULLET=LAYER.ENEMY_BULLET
env.LAYER_PLAYER=LAYER.PLAYER
env.LAYER_PLAYER_BULLET=LAYER.PLAYER_BULLET
env.LAYER_ITEM=LAYER.ITEM
env.LAYER_TOP=LAYER.TOP
api.CheckRes=lstg.CheckRes
api.SetImageState=SetImageState
api.Render=Render
env.Render=function(name,x,y,angle,sx,sy,...)
    local a,b=L.Core.renderScale()
    return Render(name,x,y,angle,(sx or 1)*a,(sy or sx or 1)*b,...)
end
api.PlaySound=function(...) return PlaySound(...) end
api.RenderClear=function(color)
    SetImageState('white','',color)
    RenderRect('white',lstg.world.l,lstg.world.r,lstg.world.b,lstg.world.t)
end
env.LoadSound=false -- 音效按本作关卡池加载。
for _,module in ipairs({
    'core','viewport','resources','projectile','reward','enemy_visual_common','enemy_visual_stage01',
    'enemy_visual_early','enemy_visual_mid','enemy_visual_late','boss_early','boss_middle_visual',
    'boss_middle','boss_late','boss_hud','presentation','enemy','enemy_late','background','stages/schedules',
}) do load('LikeDreamer/'..module..'.lua') end
L.PlayerClass=load('LikeDreamer/player.lua')
env.player=nil
local P=NativePlayers
if P then
    P.adapters[W.level]={
        spawn=function()
            L.Resources.loadPlayer()
            local machine=assert(P.machine(W.level,lstg.var.native_player_id))
            local config=lstg.var.like_dreamer_loadout or {}
            L.runtime={
                setupGroup=machine.character,optionSlots={unpack(config,1,4)},specialMode=config[5],
                specialGauge=lstg.var.like_dreamer_special_gauge,
            }
            local p=New(L.PlayerClass)
            p.machine,p.native_level,p.name=machine,W.level,machine.name
            return p
        end,
    }
end
W.source=L
W.ownHud=true

local checkpoints={
    {0,2700,3750,5700}, {0,5200,6420,9700}, {0,2860,4350,9500},
    {0,3590,4990,8580,11700}, {0,3560,6340,8240,11800},
    {0,1099,6000,8190,12500}, {0,4000,7980,9310,12500},
    {0,6840,8350,10700,17300,21420}, {0,4080,5960,8980,11840,13880,17900},
    {0,4700,8800,11900,18000},
}
local function clear()
    if objects then
        for _,o in ipairs(objects) do
            if IsValid(o) then object.RawDel(o) end
        end
    end
    if W.music then StopMusic(W.music);W.music=nil end
    if W.bossMusic then StopMusic(W.bossMusic);W.bossMusic=nil end
    if L.runtime and lstg.tmpvar.bg==L.runtime.background then lstg.tmpvar.bg=nil end
    objects,L.runtime=nil,nil
end
W.stop=clear

local Guard=Class(object,{
    init=function(o) o.bound=false;o.hide=true;o.colli=false end,
    del=clear,
})

local function play(name, seconds)
    if W.music and W.music~=name then StopMusic(W.music) end
    PlayMusic(name,1,seconds)
    W.music=name
end
env.PlayMusic=play
local function start(number, first)
    clear()
    L.Resources.load(number)
    env.player=player
    local oldPractice = lstg.var.is_practice
    local native = P and P.enabled(nil,W.level)
    -- 复用关卡逻辑，保留 Boss Rush 自机、资源和重试设置。
    lstg.var.is_practice=false
    env.difficulty=lstg.var.sequence_key=='likedreamer_chaos' and 4 or 3
    local rt=L.Enemy.Runtime.new(number)
    lstg.var.is_practice=oldPractice
    rt.frame,rt.rawStartFrame,rt.portManaged=first,first,true
    if not native then rt.counterMode=0 end
    if native then
        local p=player
        p.shotCount,p.specialObjectCount=0,0
        p.sharedOptionTarget,p.optionTargets=nil,{false,false,false,false}
        rt.player,rt.cameraX,rt.optionSlots=p,p.ldX,p.optionSlots
        rt.setupGroup,rt.specialMode=p.setupGroup,p.specialMode
        rt.specialGauge=p.specialGauge
        rt.onPlayerMiss=function() lstg.var.dead=(lstg.var.dead or 0)+1 end
        rt.onGameOver=function()
            lstg.var.lifeleft=-1
            lstg.var.dead=(lstg.var.dead or 0)+1
        end
    end
    L.runtime=rt
    objects={}
    local guard=New(Guard)
    guard.runtime=rt
    if lstg.tmpvar.bg and IsValid(lstg.tmpvar.bg) then background.DelBG() end
    rt.background=L.Background.create(rt)
    lstg.tmpvar.bg=rt.background
    if L.BossHud then L.BossHud.create(rt) end
    if L.Presentation then L.Presentation.create(rt) end
    W.bossMusic='ld_bgm_Boss'..math.min(5,math.floor((number+1)/2))
    if first>=checkpoints[number][#checkpoints[number]] then
        play(W.bossMusic,0)
    else
        play('ld_bgm_Stage'..number,first/60)
    end
    return rt,guard
end

local function playRange(number, first, last, practice)
    local rt,guard=start(number,first)
    local finalBossPractice=number==10 and first==18000
    if finalBossPractice then
        rt:spawn(0x141,100000,360,320,'原作最终 Boss 练习入口')
    end
    local target
    while not rt.complete and (not last or rt.frame<last) do
        if practice then
            local actor=rt.boss
            if actor and IsValid(actor) and actor.spawnType==practice.type and actor.portPhase then
                if actor.portPhase<practice.phase then
                    -- 走原有超时分支，保留相位转换与部件创建。
                    actor.countdown=1
                elseif actor.portPhase==practice.phase then
                    target=actor
                else
                    break
                end
            end
            if target and (not IsValid(target) or not target.active) then break end
        end
        local p=player
        if p and IsValid(p) and p.class~=L.PlayerClass then
            p.ldX,p.ldY=L.Core.playerWorldPosition(p.x,p.y)
            rt.cameraX=p.ldX
        end
        local seq=lstg.var.sequence_run
        if seq and OriginalSequence.enabled() then seq.road_time=rt.frame end
        if not finalBossPractice then L.Schedules.run(number,rt,rt.frame) end
        rt.frame=rt.frame+1
        task.Wait()
        local state=P and P.state()
        if state and state.level==W.level then state.life,state.bombs=lstg.var.lifeleft,lstg.var.bomb end
        if rt.frame%120==0 then
            local count=0
            for _,object in ipairs(objects) do
                if IsValid(object) then count=count+1;objects[count]=object end
            end
            for i=#objects,count+1,-1 do objects[i]=nil end
        end
    end
    if practice then assert(target,'Like Dreamer 未到达攻击练习阶段') end
    clear()
    object.RawDel(guard)
    task.Wait()
    if player and IsValid(player) and player.class~=L.PlayerClass then player.ldX,player.ldY=nil,nil end
end

-- Like Dreamer 原作把攻击作为 Boss 状态编号。练习按状态组列出。
local phases={3,4,4,4,6,5,5,7,4,16}
for number,frames in ipairs(checkpoints) do
    local chapter=register.chapter(W,number,'Like Dreamer 第'..number..'面','ld_bgm_Stage'..number)
    for index,first in ipairs(frames) do
        local last=frames[index+1]
        local title=chapter.title..(last and (' 道中 '..index) or ' 关底')
        register.card(W,chapter,71000+number*100+index,title,last and 'road' or 'boss',
            function() playRange(number,first,last) end,{stage=number,first=first,last=last})
    end
    local function registerAttacks(typeId,first,count,base,title)
        for phase=1,count do
            local source={stage=number,first=first,type=typeId,phase=phase}
            register.card(W,chapter,71000+number*100+base+phase,
                chapter.title..' '..title..' '..phase,'boss',
                function() playRange(number,first,nil,source) end,source)
        end
    end
    if number==10 then
        registerAttacks(0x14c,11900,3,20,'前哨攻击')
        registerAttacks(0x141,18000,phases[number],30,'最终 Boss 攻击')
    else
        registerAttacks(0x137+number,frames[#frames],phases[number],20,'关底攻击')
    end
end

function W.runChapter(_,chapter)
    playRange(tonumber(chapter.name),0)
end

return W
