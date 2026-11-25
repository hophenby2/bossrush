-- 东方祈华梦：原道中协程、弹型和 Boss 攻击回调在独立的 Lua 环境运行。
local register=dofile('mod/GAME/ports/register.lua')
local W=register.work('TH41',39)
W.ownHud=true
local P=NativePlayers
if P then dofile('mod/GAME/ports/theis/player.lua') end
local function resources() return P and P.enabled(nil,W.level) and P.state() end
local function drop(x,y,kind,count)
    if not count or count<1 then return end
    local r=math.sqrt(count-1)*5
    for _=1,count do
        local radius=math.sqrt(ran:Float(1,4))*r;local angle=ran:Float(0,360)
        P.pickup(x+radius*cos(angle),y+radius*sin(angle),kind,1)
    end
end
local env,load,assets=dofile('mod/GAME/ports/environment.lua')('theis')
local api=env.lstg
local resolve=api.ResourceSet.Resolve
local resourceName=api.ResourceSet.Name
local objectResources=dofile('mod/GAME/ports/object_resources.lua')
local prepareObject
local function objectImage(name)
    local key=resolve(2,name)
    if key==name then key=resolve(3,name) end
    return key
end
env.Class,prepareObject=objectResources.factory(objectImage)
api.Class=env.Class
local objects
local empty=function() end
local function new(class,...)
    if resources() and class and class.theis_pickup then
        local x,y=...;return P.pickup(x,y,class.theis_pickup,1)
    end
    assert(class,'祈华梦对象类缺失');prepareObject(class)
    local o=New(class,...)
    -- Sub 的 false 是椭圆；x 的 false 是只取 a 的圆。竹干/竹节会继续修改 a、b，
    -- 即使出生时两轴相等也必须保留椭圆类型，否则生长后会出现大块圆形判定。
    if AndroidPlatform and o.rect==false then o.rect='ellipse' end
    o.theis_port_object=true
    -- 三面等原作背景直接继承 object，未经过 background.init；
    -- 在桥接层统一登记，练习加载页才能在场景建好后退出。
    if class.rogue_stage_background==W.level then lstg.tmpvar.bg=o end
    if o.group==GROUP.ENEMY or o.group==GROUP.NONTJT then
        (NativeActorCollision or dofile('THlib/native_actor_collision.lua')).preserve(o)
    end
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
env.item_faith_minor=Class(item.obj.faith_minor);env.item_faith_minor.theis_pickup='theisSmall'
env.item_night_minor=Class(item.obj.faith_minor);env.item_night_minor.theis_pickup='night'
env.item_faith=Class(item.obj.faith);env.item_faith.theis_pickup='green'
env.item_point=Class(item.obj.point);env.item_point.theis_pickup='blue'
env.item_bomb=item.obj.addcharge
env.item_bombchip=item.obj.addcharge
env.item_extend=item.obj.revdead
env.item_chip=item.obj.revdead
env.item_power=Class(item.obj.faith);env.item_power.theis_pickup='red'
env.item_power_large=item.obj.faith
env.item_power_full=item.obj.faith
env.wabisabi_item=Class(object,{
    init=function(o,x,y,color)
        if resources() then
            local pickup=P.pickup(x,y,'night',1)
            pickup.img=color==1 and 'sabi_item' or 'wabi_item'
            pickup.size=.7
        end
        object.RawDel(o)
    end,
})
env.dialog={cacheResource=empty,reader={matchScene=empty},player={}}
env.system={
    setTargetChain=function(n)
        local s=resources()
        if s then s.dyeTarget=n end
    end,setCurDamageEnemy=function(o) env.lastHitEnemy=o end,
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
    -- bullet2直接登记数组回调类，也要在第一次数值回调赋img前绑定作品命名空间。
    prepareObject(class,true)
    for i,k in ipairs({'init','del','frame','render','colli','kill'}) do class[i]=class[k] or class[i] or empty end
    if AndroidRegisterClass then AndroidRegisterClass(class) end
end
env.RenderClass=env.Class
api.RenderClass=env.Class
api.RawDel,api.RawKill,api.PreserveObject=object.RawDel,object.RawKill,object.Preserve
env.PreserveObject=object.Preserve
api.Log=function(_,message) if lstg.SystemLog then lstg.SystemLog(message) end end
api.SetImgState=function(o,...) return env.SetImgState(o,...) end
env.SetImgState=function(o,blend,a,r,g,b)
    if lstg.CheckRes(2,resolve(2,o.img)) then env.SetImageState(o.img,blend or '',a or 255,r or 255,g or 255,b or 255)
    elseif lstg.CheckRes(3,resolve(3,o.img)) then env.SetAnimationState(o.img,blend or '',a or 255,r or 255,g or 255,b or 255) end
end
for _,spec in ipairs({{'SetImageState',2},{'SetImageCenter',2},{'SetAnimationState',3},
    {'SetAnimationCenter',3},{'GetTextureSize',1},{'SetTextureSamplerState',1},{'RenderTexture',1},
    {'RenderRect',2},{'Render4V',2},{'PushRenderTarget',1},{'PopRenderTarget',1},{'PostEffect',1}}) do
    local name,kind=spec[1],spec[2]
    env[name]=function(key,...) return _G[name](resolve(kind,key),...) end
    api[name]=env[name]
end
-- 宿主 RenderRing 内部持有自己的 Render4V，不会经过本作的绘图包装。
-- 先按第一片解析组名前缀，保留宿主的分片、顶点和原作混合状态。
env.misc.RenderRing=function(img,...)
    return misc.RenderRing(resolve(2,img..'1'):sub(1,-2),...)
end
env.LoadTexture=function(name,path,...) return LoadTexture(resourceName(1,name),assets..path,...) end
env.LoadImageFromFile=function(name,path,...) return LoadImageFromFile(resourceName(2,name),assets..path,...) end
env.LoadImageGroupFromFile=function(name,path,...) return LoadImageGroupFromFile(resourceName(2,name),assets..path,...) end
env.LoadAniFromFile=function(name,path,...) return LoadAniFromFile(resourceName(3,name),assets..path,...) end
env.LoadImage=function(name,tex,...)return LoadImage(resourceName(2,name),resourceName(1,tex),...)end
env.LoadAnimation=function(name,tex,...)return LoadAnimation(resourceName(3,name),resourceName(1,tex),...)end
api.LoadTexture,api.LoadImage,api.LoadAnimation=env.LoadTexture,env.LoadImage,env.LoadAnimation
env.LoadImageGroup=function(name,tex,...)return LoadImageGroup(resourceName(2,name),resourceName(1,tex),...)end
env.CopyImage=function(name,img)return CopyImage(resourceName(2,name),resolve(2,img))end
env.GetImageSize=function(name)return GetImageSize(resolve(2,name))end
api.LoadImageGroup,api.CopyImage,api.GetImageSize=env.LoadImageGroup,env.CopyImage,env.GetImageSize
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
    if mode=='worldui' then
        local w=lstg.world
        SetViewMode('world')
        SetRenderRect(w.l,w.r,w.b,w.t,w.scrl,w.scrr,w.scrb,w.scrt)
    else
        SetViewMode(mode)
    end
end
-- 原作普通贴图以半尺寸绘制，取景仍由宿主负责。
env.Render=function(img,x,y,rot,sx,sy,...)
    if lstg.viewmode=='3d' then return Render(resolve(2,img),x,y,rot,sx,sy,...) end
    local scale=api.globalimagescale
    return Render(resolve(2,img),x,y,rot,(sx or 1)*scale,(sy or sx or 1)*scale,...)
end
api.Render=env.Render
env.RenderAnimation=function(img,t,x,y,rot,sx,sy)
    local scale=api.globalimagescale
    return RenderAnimation(resolve(3,img),t,x,y,rot,(sx or 1)*scale,(sy or sx or 1)*scale)
end
api.RenderAnimation=env.RenderAnimation
env.RenderText=function(font,text,x,y,scale,...)
    return RenderText(font,text,x,y,(scale or 1)*api.globalimagescale,...)
end
env.DefaultRenderFunc=function(o)
    -- 使用原作高清切片；宿主同名弹图尺寸更小，不能再对宿主图应用原作的半尺寸比例。
    local key=o.img
    local previous=GetImageScale()
    SetImageScale(api.globalimagescale)
    if key and lstg.CheckRes(2,resolve(2,key)) then
        Render(resolve(2,key),o.x,o.y,o.rot,o.hscale,o.vscale)
    elseif key and lstg.CheckRes(3,resolve(3,key)) then
        RenderAnimation(resolve(3,key),o.ani,o.x,o.y,o.rot,o.hscale,o.vscale)
    else
        DefaultRenderFunc(o)
    end
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
        AddMusic(id,ending,length,id,true,tracks[entry.name][2])
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
for kind,y in pairs({red=768,blue=808,green=848}) do
    for n=1,3 do effects:AddSprite('item_'..kind..n,'theis_item_tex',(n-1)*40,y,40,40) end
end
effects:AddSprite('item_night','theis_item_tex',128,888,64,64)
effects:AddSprite('item_small','theis_item_tex',128,952,64,64)
effects:AddTexture('theis_point_tex','res/item/bullet_killed_eff.png',false)
effects:AddSprite('sabi_item','theis_point_tex',0,0,40,40)
effects:AddSprite('wabi_item','theis_point_tex',40,0,40,40)
-- 自机可在 Boss 的练习入场任务之前射击；缓存的自机类也会跨关卡复用。
-- 这些资源随自机绑定同步加载到全局池，不能依赖延迟执行的 start()。
function W.loadPlayerResources()
    local pool=GetResourceStatus()
    SetResourceStatus('global')
    sounds:Load()
    effects:Load()
    SetResourceStatus(pool)
end
env.player_board_ch=Class(object,{
    init=function(o,r,g,b,duration)
        o.img=resourceName(2,'theis_board_color')
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
    kind=api.ResourceSet.kinds[kind] or kind
    return lstg.CheckRes(kind,track and track[1] or resolve(kind,name))
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
-- 曲线激光直接把纹理名传给原生BentLaserData.Render，不经过图片赋值/Render包装。
-- 注册时资源尚未加载，须使用确定的作品名称，不能依赖CheckRes进行回退探测。
for _,name in ipairs({'Add_bentlaser_texture','Add_bentlaser_texture_16','Add_bentlaser_thunder_texture_single'}) do
    local addTexture=env[name]
    env[name]=function(id,texture,...) return addTexture(id,resourceName(1,texture),...) end
end
load('THlib/editor.lua')
load('src/core/render.lua')
load('src/core/tiles.lua')
load('EISlib/effect/effect.lua')
load('EISlib/enemy/enemy.lua')
local sourceCollision=env.enemybase.colli
env.enemybase.colli=function(o,shot)
    if not (shot.dmg and GameDrops and GameDrops.enabled()) then return sourceCollision(o,shot) end
    -- 原作碰撞入口没有随机模式的火力成长；只换算命中伤害，仍走原作递归转伤与命中演出。
    env.enemybase.damage(o,GameDrops.damage(shot.dmg,shot))
    shot.killerenemy=o
    if not shot.killflag then api.Kill(shot) end
    if not shot.mute then env.EISlib.Effect.DamageEnemyEffect(o) end
end
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
    local result={}
    if not items then return result end
    local n=(items[1] or 0)+(items[2] or 0)+(items[3] or 0)
    local r=math.sqrt(math.max(0,n-1))*5
    for i,kind in ipairs({'red','green','blue'}) do for _=1,items[i] or 0 do
        local radius=math.sqrt(ran:Float(1,4))*r;local a=ran:Float(0,360)
        result[#result+1]=P.pickup(x+radius*cos(a),y+radius*sin(a),kind,1)
    end end
    return result
end
load('EISlib/bullet/bullet.lua')
load('EISlib/boss/boss.lua')
if P then
    local adapter=P.adapters[W.level]
    adapter.clearBonus=function() env.boss.ClearBonus(true,true) end
end
load('EISlib/egg/egg.lua')
load('EISlib/background/background.lua')
dofile('mod/GAME/ports/spell_background.lua')(env,'theis_spell_composite',env._spellcard_background)
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
    env['stage'..number..'_background'].rogue_stage_background=39
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
        for _,o in ipairs(objects) do
            if IsValid(o) and not (RogueEncounter and RogueEncounter.keepsBackground(o)) then object.RawDel(o) end
        end
    end
    objects=nil
    env._boss=nil
    env.lastHitEnemy=nil
    if player and IsValid(player) then player.dialog=false end
    if W.music then StopMusic(W.music);W.music=nil end
end
W.stop=clear
function W.prepareRogue() api.ResourceSet.LoadByTag(false,'global') end
function W.roguePreloadKey() return 'global' end
function W.createRogueBackground(_,unit)
    local number=unit.sc_group[1].card.port_source.stage
    return new(env['stage'..number..'_background'],true)
end
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
        lstg.tmpvar._system_items={red=0,blue=0,green=0,night=0}
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

-- 原作登记表的第五项决定练习入场。有独立 Scpr 类的面使用自己的出场动作。
local practiceCards={}
for _,info in ipairs(env._sc_table) do practiceCards[info[3]]=info end
local function practiceBoss(key,index)
    local stageClass=env._editor_class[key]
    local practiceKey=key:gsub(':','Scpr:',1)
    local class=env._editor_class[practiceKey] or stageClass
    local source=stageClass.cards[index]
    local card=class.cards[index]
    if not card or card.name~=source.name or card.is_combat~=source.is_combat then
        class,card=stageClass,source
    end
    local entry=practiceCards[card]
    local enter=card.perform
    if entry then enter=entry[5] end
    local previous=class.cards[(entry and entry[4] or index)-1]
    return class,enter and previous and {previous,card} or {card}
end
local classKeys={}
for key,class in pairs(env._editor_class) do
    if type(class)=='table' and class.cards and (key:match(':Lunatic$') and not key:find('Scpr',1,true)
        or key=='stage7boss' or key=='stage7mid_boss') then
        classKeys[#classKeys+1]=key
    end
end
table.sort(classKeys)
-- 原作退场后的保护卡，以及二面尚未实现的后续非符，都没有发弹。
-- 保留注册编号供旧录像/存档读取，练习和随机模式的候选入口统一隐藏。
local placeholderIndex={
    ['stage1mid_boss:Lunatic']=4,['stage2mid_boss:Lunatic']=6,
    ['stage6boss:Lunatic']=22,stage7boss=38,
}
for _,route in ipairs({'A','B','C'}) do for actor=1,2 do
    placeholderIndex['stage3'..route..'mid_boss'..actor..':Lunatic']=4
end end
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
                if source.is_combat then nextId=nextId+1 end
                -- 第六项是原作退场前的空占位，不是可练习攻击。
                if source.is_combat and not (key=='stage5mid_boss:Lunatic' and index==6) then
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
                        if bg and not (RogueEncounter and RogueEncounter.spellOnly(39)) then new(bg,true) end
                        local practiceClass,cards=practiceBoss(key,index)
                        local actor=new(practiceClass,cards)
                        while IsValid(actor) do task.Wait() end
                        finish(guard)
                    end,{stage=number,class=key,index=index,card=source},source.is_sc)
                    card.hp=source.hp
                    if placeholderIndex[key]==index then card.practice_hidden,card.random_empty=true,true end
                end
            end
        end
    end
end

function W.runChapter(_,chapter)
    road(chapter.number or assert(W.chapters[chapter.name]).number)
end
return W
