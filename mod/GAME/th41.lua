-- 东方祈华梦：原道中协程、弹型和 Boss 攻击回调在独立的 Lua 环境运行。
local register=dofile('mod/GAME/ports/register.lua')
local W=register.work('TH41',39)
W.ownHud=true
local P=NativePlayers
if P then dofile('mod/GAME/ports/theis/player.lua') end
local function resources() return P and P.enabled(nil,W.level) and P.state() end
local function drop(x,y,kind,count)
    if count and count>0 then P.pickup(x,y,kind,count) end
end
local env,load,assets=dofile('mod/GAME/ports/environment.lua')('theis')
local api=env.lstg
local objects
local empty=function() end
local function new(class,...)
    local o=New(assert(class,'祈华梦对象类缺失'),...)
    if objects then objects[#objects+1]=o end
    return o
end
env.New,api.New=new,new
env.GROUP_GHOST,env.GROUP_ENEMY,env.GROUP_NONTJT=GROUP.GHOST,GROUP.ENEMY,GROUP.NONTJT
env.GROUP_PLAYER,env.GROUP_PLAYER_BULLET=GROUP.PLAYER,GROUP.PLAYER_BULLET
env.GROUP_ENEMY_BULLET,env.GROUP_INDES,env.GROUP_ITEM=GROUP.ENEMY_BULLET,GROUP.INDES,GROUP.ITEM
env.GROUP_SPELL=GROUP.SPELL
env.GROUP_ALL=GROUP
for key,value in pairs(LAYER) do env['LAYER_'..key]=value end
env.LAYER_ENEMY_BULLET_EF=LAYER.ENEMY_BULLET_EF
env.math.clamp=function(x,a,b) return math.max(a,math.min(x,b)) end
env.math.lerp=function(a,b,t) return a+(b-a)*t end
env.math.inrange=function(x,a,b) return x>=a and x<=b end
env.math.mod=math.fmod
env.rnd=function(...) return ran:Float(...) end
env.INFINITE=2147483647
env.etc={}
env.misc=setmetatable({}, {__index=misc})
env.sp={misc={}}
env.scoredata={}
env.EISlib={path='EISlib/'}
env._editor_class,env._editor_tasks,env._editor_cards,env._sc_table={},{},{},{}
env.config={main_mod=false,preview_version=false,debug_mode=false}
env.theisRoutePlayer=function()
    if lstg.var.theis_route=='mokou' then return 'theis_mokou_player' end
    if lstg.var.player_name=='marisa_player' then return 'theis_marisa_player' end
    return 'theis_reimu_player'
end
env.ext=setmetatable({}, {__index=ext})
env.stage={group={}}
env.achievement={unlock=empty}
env.item=setmetatable({StartChipBonus=empty,EndChipBonus=empty,DropItem=item.Dropitem_PFP},{__index=item})
env.item_faith_minor=item.obj.faith_minor
env.item_faith=item.obj.faith
env.item_point=item.obj.point
env.item_bomb=item.obj.addcharge
env.item_bombchip=item.obj.addcharge
env.item_extend=item.obj.revdead
env.item_chip=item.obj.revdead
env.item_power=item.obj.faith
env.item_power_large=item.obj.faith
env.item_power_full=item.obj.faith
env.wabisabi_item=Class(object,{
    init=function(o,x,y,color)
        if resources() then
            local pickup=P.pickup(x,y,'night',1)
            pickup.img=color==1 and 'sabi_item' or 'wabi_item'
        end
        object.RawDel(o)
    end,
})
env.dialog={cacheResource=empty,reader={matchScene=empty},player={}}
env.system={
    setTargetChain=function(n)
        local s=resources()
        if s then s.dyeTarget=n end
    end,setCurDamageEnemy=empty,
    damageEnemyBonus=function() if resources() then env.system.addScore(10) end end,
    setContinueMode=empty,
    addEnemyCreateCount=function(n)
        local s=resources()
        if s then s.enemiesCreated=s.enemiesCreated+n end
    end,
    addEnemyKillCount=function(n)
        local s=resources()
        if s then s.enemiesKilled=s.enemiesKilled+n end
    end,
    makeSettlement=function(chapter,allClear,multiplier)
        local s=resources()
        if not s or s.enemiesCreated==0 then return end
        local base=chapter*10000000+(s.stageChain+s.stageBlue)*100000
        if allClear and not lstg.var.is_practice then base=base+s.life*50000000+s.bombs*40000000 end
        local ratio=math.floor(s.enemiesKilled*100/s.enemiesCreated)*.01
        env.system.addScore(math.floor(base*ratio*(multiplier or 2)/10)*10)
    end,
    addChain=function(n)
        local s=resources()
        if s then s.dyeChain=s.dyeChain+n;s.stageChain=s.stageChain+n end
    end,
    addBonus=function(n)
        local s=resources()
        if s then s.pointrate=math.min(5000000,s.pointrate+n) end
    end,
    addScore=function(score) lstg.var.score=(lstg.var.score or 0)+score end,
    getBonus=function() local s=resources();return s and s.pointrate or 0 end,
    getBossCardScore=function(mode,t1,_,t3,t,base,maximum)
        local s=resources()
        if not s or mode=='normal' then return 0 end
        local chain=s.stageChain
        local score=10000000+100000*chain
        if base and maximum and base>=0 and maximum>=0 then
            if base~=maximum then score=maximum*.01*chain end
        elseif mode=='lastspell' then
            score=100000000
        elseif mode=='spellcard' and t3>t1 then
            score=score*(1-.5*math.max(0,math.min(1,(t-t1)/(t3-t1))))
        end
        return math.floor(score/10)*10
    end,
    checkChainAchieve=function()
        local s=resources()
        return s and s.dyeTarget and s.stageChain>=s.dyeTarget
    end,
    getTotalChain=function() local s=resources();return s and s.dyeChain or 0 end,
    getScore=function() return lstg.var.score or 0 end,
    isNoMiss=function() return (lstg.var.dead or 0)==0 end,
    isNoBomb=function() return (lstg.var.bomb_used or 0)==0 end,
    record={
        markHighScore=empty,markPlayerClearGroup=empty,unlockLunatic=empty,unlocExtra=empty,
        isAllPlayerClearGroup=function() return false end,
    },
}
env.setting=setmetatable({background=true,background_mask=0},{__index=setting})
env.EventDispatcher={AddListener=empty}
env.EVENT={ON_GAME_STAGE_INIT=1,STAGE_CHANGE_BEFORE=2}
api.EventDispatcher=env.EventDispatcher
api.globalimagescale=.5
api.SetImageScale=function(scale) api.globalimagescale=scale end
api.wis={}
api.RegisterClass=function(class)
    for i,k in ipairs({'init','del','frame','render','colli','kill'}) do class[i]=class[k] or class[i] or empty end
    if AndroidRegisterClass then AndroidRegisterClass(class) end
end
env.RenderClass=Class
api.RenderClass=Class
api.RawDel,api.RawKill,api.PreserveObject=object.RawDel,object.RawKill,object.Preserve
env.PreserveObject=object.Preserve
api.Log=function(_,message) if lstg.SystemLog then lstg.SystemLog(message) end end
api.SetImgState=function(o,...) return env.SetImgState(o,...) end
env.SetImgState=function(o,blend,a,r,g,b)
    if lstg.CheckRes(2,o.img) then SetImageState(o.img,blend or '',a or 255,r or 255,g or 255,b or 255)
    elseif lstg.CheckRes(3,o.img) then SetAnimationState(o.img,blend or '',a or 255,r or 255,g or 255,b or 255) end
end
api.SetImageState,api.SetAnimationState=SetImageState,SetAnimationState
env.LoadTexture=function(name,path,...) return LoadTexture(name,assets..path,...) end
env.LoadImageFromFile=function(name,path,...) return LoadImageFromFile(name,assets..path,...) end
env.LoadImageGroupFromFile=function(name,path,...) return LoadImageGroupFromFile(name,assets..path,...) end
env.LoadAniFromFile=function(name,path,...) return LoadAniFromFile(name,assets..path,...) end
env.LoadPS=function(name,path,...) return LoadPS(name,assets..path,...) end
env.LoadFX=function(name,path) return LoadFX(name,assets..path) end
env.SetA=SetA
env.WorldToUI=function(x,y)
    local w=lstg.world
    return w.scrl+(w.scrr-w.scrl)*(x-w.l)/(w.r-w.l),
        w.scrb+(w.scrt-w.scrb)*(y-w.b)/(w.t-w.b)
end
env.RenderStrokeTTF=function(_,text,left,_,bottom,_,scale,color,_,_,...)
    ui:RenderText('pretty',text,left,bottom,scale*.5,color,...)
end
env.SetViewMode=function(mode)
    SetViewMode(mode=='worldui' and 'world' or mode)
end
-- 原作普通贴图以半尺寸绘制，取景仍由宿主负责。
env.Render=function(img,x,y,rot,sx,sy,...)
    if lstg.viewmode=='3d' then return Render(img,x,y,rot,sx,sy,...) end
    local scale=api.globalimagescale
    return Render(img,x,y,rot,(sx or 1)*scale,(sy or sx or 1)*scale,...)
end
api.Render=env.Render
env.RenderText=function(font,text,x,y,scale,...)
    return RenderText(font,text,x,y,(scale or 1)*api.globalimagescale,...)
end
env.DefaultRenderFunc=function(o)
    local previous=GetImageScale()
    SetImageScale(api.globalimagescale)
    DefaultRenderFunc(o)
    SetImageScale(previous)
end
api.DefaultRenderFunc=env.DefaultRenderFunc
env.object=setmetatable({render=env.DefaultRenderFunc},{__index=object})
env.RenderClear=function(color)
    -- RenderClear 会清空整张 Metal framebuffer，覆盖战斗区外的 HUD。
    RenderClearViewMode(color)
end
api.RenderClear=env.RenderClear

local fonts=api.ResourceSet.Create('THEIS.HUD','global')
fonts:AddTexture('THEIS_hud','res/ui/ui_item_16_9_2.png',false)
for i=1,16 do
    local id='_ui_16_9_bossname'..i
    fonts:AddSprite(id,'THEIS_hud',(i-1)*64,1520,64,346)
    fonts:SetSpriteCenter(id,64,0)
end
for _,name in ipairs({'ui_font_42blue','ui_font_42red','ui_font_42green','ui_font_42black','ui_font_80green'}) do
    fonts:add(7,name,LoadFont,assets..'res/ui/'..name..'.fnt',false)
end
local modules={}
env.require=function(name)
    if name=='EISlib.egg.eggmath' then
        if not modules[name] then modules[name]=load('EISlib/egg/eggmath.lua') end
        return modules[name]
    end
    return require(name)
end

local function resourceInfo(name)
    local source=api.LoadTextFile('EISlib/lib/'..name..'.info')
    local data={}
    setfenv(assert(loadstring(source:gsub('^\239\187\191',''),'@祈华梦/'..name)),data)()
    return data.info
end
local tracks, volumes = {},{}
for _,entry in ipairs(resourceInfo('music')) do
    if entry.name:match('^s[1-7]') then
        local id='THEIS_'..entry.name
        local loop=entry.loop
        local ending=loop.ending or loop.beginning+loop.length
        local length=loop.length or ending-loop.beginning
        tracks[entry.name]={id,assets..'res/music/'..entry.filename,ending,length}
        AddMusic(id,ending,length,id,true)
    end
end
local sounds=api.ResourceSet.Create('THEIS.SE','global')
for _,entry in ipairs(resourceInfo('soundeffect')) do
    local id='THEIS_'..entry.name
    volumes[entry.name]={id,entry.volume}
    sounds:AddSound(id,'res/soundeffect/'..entry.filename)
end
local effects=api.ResourceSet.Create('THEIS.StageEffects','global')
effects:AddSpriteFromFile('theis_board_color','res/effect/player_board_ch.png',false)
effects:AddTexture('theis_item_tex','res/item/item.png',false)
effects:AddSprite('item_red1','theis_item_tex',0,768,40,40)
effects:AddSprite('item_blue1','theis_item_tex',0,808,40,40)
effects:AddSprite('item_green1','theis_item_tex',0,848,40,40)
effects:AddSprite('item_night','theis_item_tex',128,888,64,64)
effects:AddTexture('theis_point_tex','res/item/bullet_killed_eff.png',false)
effects:AddSprite('sabi_item','theis_point_tex',0,0,40,40)
effects:AddSprite('wabi_item','theis_point_tex',40,0,40,40)
env.player_board_ch=Class(object,{
    init=function(o,r,g,b,duration)
        o.img='theis_board_color'
        o.group,o.layer=GROUP.GHOST,LAYER.ENEMY-2
        o.bound,o.colli=false,false
        o.r,o.g,o.b,o.duration=r,g,b,duration
    end,
    frame=function(o) if o.timer>=o.duration then object.Del(o) end end,
    render=function(o)
        local alpha=math.max(0,math.min(1,o.timer/30,(o.duration-o.timer)/60))
        SetImageState(o.img,'mul+rev',math.floor(255*alpha),o.r,o.g,o.b)
        Render(o.img,0,0,0,4,4)
    end,
})
env.PlaySound=function(name,volume,pan,...)
    local s=volumes[name]
    return PlaySound(s and s[1] or name,(volume or 1)*(s and s[2] or 1),pan,...)
end
api.PlaySound=env.PlaySound
local function loadMusic(name)
    local m=tracks[name]
    if m and not lstg.CheckRes(4,m[1]) then LoadMusic(unpack(m)) end
end
env.LoadMusicRecord=loadMusic
local function playMusic(name,volume,position)
    local m=tracks[name]
    if not m then return end
    if W.music and W.music~=m[1] then StopMusic(W.music) end
    loadMusic(name)
    PlayMusic(m[1],volume,position)
    W.music=m[1]
end
env.PlayMusic,api.PlayMusic=playMusic,playMusic
local function musicAPI(name)
    return function(id,...)
        local track=tracks[id]
        if track then return _G[name](track[1],...) end
    end
end
for _,name in ipairs({'GetMusicState','SetBGMVolume','StopMusic','ResumeMusic','SetBGMSpeed'}) do
    env[name]=musicAPI(name)
    api[name]=env[name]
end
api.CheckRes=function(kind,name)
    local track=tracks[name]
    return lstg.CheckRes(api.ResourceSet.kinds[kind] or kind,track and track[1] or name)
end

load('src/core/flat_class.lua')
load('src/core/eis_class.lua')
load('src/core/task.lua')
load('src/core/callback.lua')
load('src/core/tasks.lua')
load('src/core/values.lua')
load('THlib/background/background.lua')
load('THlib/WalkImageSystem.lua')
load('THlib/DNHWalkImageSystem.lua')
load('THlib/enemy/enemy.lua')
load('THlib/bullet/bullet.lua')
load('THlib/laser/laser.lua')
load('THlib/editor.lua')
load('src/core/render.lua')
load('src/core/tiles.lua')
load('EISlib/effect/effect.lua')
load('EISlib/enemy/enemy.lua')
local bonusDisplay=env.bonus_display
env.bonus_display=function(x,y,red,blue,green,night,kills,score,...)
    if not resources() then return bonusDisplay(x,y,red,blue,green,night,kills,score,...) end
    drop(x,y,'red',red)
    drop(x+12,y,'blue',blue)
    drop(x-12,y,'green',green)
    drop(x,y-12,'night',night)
    if kills and kills>0 then
        env.system.addChain(kills)
        env.system.addBonus(500*kills)
        env.system.addScore(score or 0)
    end
end
local dropItem=env.item.DropItem
env.item.DropItem=function(x,y,items)
    if not resources() then return dropItem(x,y,items) end
    if items then
        drop(x,y,'red',items[1])
        drop(x+12,y,'green',items[2])
        drop(x-12,y,'blue',items[3])
    end
    return {}
end
load('EISlib/bullet/bullet.lua')
load('EISlib/boss/boss.lua')
if P then
    local adapter=P.adapters[W.level]
    adapter.clearBonus=function() env.boss.ClearBonus(true,true) end
end
load('EISlib/egg/egg.lua')
load('EISlib/background/background.lua')
load('EISlib/stage/stage.lua')
env.EISlib.stage.canDialog=function() return false end
env.EISlib.stage.playMusic=function(name,position) playMusic(name,1,position) end
env.EISlib.stage.musicFadeOut=function(name,time)
    local track=tracks[name]
    if not track or W.music~=track[1] then return end
    local id=track[1]
    env.New(tasker,function()
        local frames=math.max(1,time or 60)
        for i=1,frames do
            if W.music~=id then return end
            SetBGMVolume(id,1-i/frames)
            env.task.Wait()
        end
        if W.music==id then StopMusic(id);W.music=nil end
    end)
end

-- 原引擎的 dialog 卡承担移动和等待，保留其协程，只跳过对话文本。
for number=1,7 do
    load('EISlib/background/stage'..number..'bg.lua')
    env.EISlib.stage.loadStage(number)
    local controller=env['s'..number..'_boss']
    local main=controller.main
    controller.main=function(...)
        local owner=env.task.GetSelf()
        if owner.theis_road_practice then
            owner.done=true
            return env.task.Wait(1)
        end
        return main(...)
    end
end
W.source=env

local function clear()
    if objects then
        for _,o in ipairs(objects) do if IsValid(o) then object.RawDel(o) end end
    end
    objects=nil
    env._boss=nil
    if player and IsValid(player) then player.dialog=false end
    if W.music then StopMusic(W.music);W.music=nil end
end
W.stop=clear
local Guard=Class(object,{
    init=function(o) o.bound=false;o.hide=true;o.colli=false end,
    del=clear,
})

local function start()
    clear()
    objects={}
    env.difficulty=4
    env.ext.sc_pr=false
    env.setting.background=setting.displayBG~=false
    env._boss_table={}
    local s=resources()
    if s then
        s.stageChain,s.dyeTarget=0,nil
        s.stageBlue,s.enemiesCreated,s.enemiesKilled=0,0,0
    end
    lstg.tmpvar._WLS_IMG_CHECK=nil
    api.ResourceSet.LoadByTag(false,'global')
    return New(Guard)
end
local function finish(guard)
    clear()
    object.RawDel(guard)
end
local Road=Class(object,{
    init=function(o,func)
        o.bound=false;o.hide=true;o.colli=false
        env.task.New(o,function() func(o);o.done=true end)
    end,
    frame=env.task.Do,
})
local function road(number, practice)
    local guard=start()
    local owner=New(Road,env['s'..number..'_road'].main)
    owner.theis_road_practice=practice
    while not owner.done do
        local seq=lstg.var.sequence_run
        if seq and OriginalSequence.enabled() then seq.road_time=owner.timer end
        if owner.timer%120==0 then
            local count=0
            for _,o in ipairs(objects) do
                if IsValid(o) then count=count+1;objects[count]=o end
            end
            for i=#objects,count+1,-1 do objects[i]=nil end
        end
        task.Wait()
    end
    object.RawDel(owner)
    finish(guard)
end

local classKeys={}
for key,class in pairs(env._editor_class) do
    if type(class)=='table' and class.cards and (key:match(':Lunatic$') and not key:find('Scpr',1,true)
        or key=='stage7boss' or key=='stage7mid_boss') then
        classKeys[#classKeys+1]=key
    end
end
table.sort(classKeys)
for number=1,7 do
    local chapter=register.chapter(W,number==7 and 'EX' or number,'祈华梦 '..(number==7 and 'Extra' or '第'..number..'面'),'THEIS_s'..number)
    chapter.number=number
    register.card(W,chapter,70000+number*100,chapter.title..' 道中','road',
        function() road(number,true) end,{stage=number})
    local nextId=70000+number*100
    for _,key in ipairs(classKeys) do
        if tonumber(key:match('(%d+)'))==number then
            local class=env._editor_class[key]
            for index,source in ipairs(class.cards) do
                if source.is_combat then
                    nextId=nextId+1
                    local name=source.name~='' and source.name or ('非符 '..index)
                    local role=key:find('mid',1,true) and 'mid' or 'boss'
                    local title=(class.name or key)..' · '..name
                    local card=register.card(W,chapter,nextId,title,role,function()
                        local guard=start()
                        env.ext.sc_pr=true
                        local music=class.bgm or 's'..number..'_boss'
                        if not tracks[music] then music='s'..number end
                        playMusic(music)
                        local bg=env['stage'..number..'_background']
                        if bg then new(bg,true) end
                        local cards={}
                        if source.perform and class.cards[index-1] then cards[1]=class.cards[index-1] end
                        cards[#cards+1]=source
                        local actor=new(class,cards)
                        while IsValid(actor) do task.Wait() end
                        finish(guard)
                    end,{stage=number,class=key,index=index,card=source},source.is_sc)
                    card.hp=source.hp
                end
            end
        end
    end
end

function W.runChapter(_,chapter)
    road(chapter.number or assert(W.chapters[chapter.name]).number)
end
return W
