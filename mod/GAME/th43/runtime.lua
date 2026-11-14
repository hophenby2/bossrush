-- 栖霞园脚本的全局量、资源名和对象生命周期归此模块管理。
local R={root='mod/GAME/th43/source/',objects=setmetatable({},{__mode='k'})}
local E=setmetatable({}, {__index=_G})
R.env=E
E._G=E
E._connect=function(owner,child,damage,onDeath,deathAttack)
    object.Connect(owner,child,damage,onDeath)
    if IsValid(owner) and IsValid(child) and onDeath then
        owner.servant_death_attack=deathAttack
    end
end
E._set_rel_pos=object.SetRelPos
E._kill_servants=object.KillServants
E._del_servants=object.DelServants
E._Kill_,E._Del_=Kill,Del
E.PreserveObject=object.Preserve
function E._del(o,trigger) if trigger then Del(o) else object.RawDel(o) end end
local function noop() end
local function overlay(base,items) return setmetatable(items or {},{__index=base}) end
local function valid(o) return o and IsValid(o) end
R.noop=noop
local stg=overlay(lstg)
E.stg,E.lstg=stg,stg
E.MOVE_RANDOM,E.MOVE_X_TOWARDS_PLAYER=3,1
E.EGGlib={TextObject={mainTextObject={addToInit=noop,addToFrame=noop,addToRender=noop}}}
E.EISlib={stage={path='EISlib/stage/'},Bullet={},Enemy={},BossDefinition={path='EISlib/boss/definition/'},Effect={}}
E.config={preview_version=false,final_war_machine=true}
E.achievement={unlock=noop,unlock2=noop}
E.sp=overlay(sp)
E.sp.misc=overlay(misc)
E.math=overlay(math,{inrange=function(x,a,b) return a<=x and x<=b end})
for name,id in pairs(GROUP) do E['GROUP_'..name]=id end
for name,layer in pairs(LAYER) do E['LAYER_'..name]=layer end
local colorNames={'DEEP_RED','RED','DEEP_PURPLE','PURPLE','DEEP_BLUE','BLUE','ROYAL_BLUE','CYAN',
    'DEEP_GREEN','GREEN','CHARTREUSE','YELLOW','GOLDEN_YELLOW','ORANGE','DEEP_GRAY','GRAY'}
for i,name in ipairs(colorNames) do E['COLOR_'..name]=i end
E.COLOR_WHITE,E.COLOR_BLACK=Color(0xffffffff),Color(0xff000000)
stg.globalimagescale=0.5
stg.object=object
-- LuaSTG-x 的绑定可能把 WELL512 的 -1 当成无符号数交给 Lua。
local function wrapRandom(generator)
    return {
        Float=function(_,a,b) return generator:Float(a,b) end,
        Int=function(_,a,b) return generator:Int(a,b) end,
        Sign=function() return generator:Sign()==1 and 1 or -1 end,
    }
end
E.ran=wrapRandom(ran)
stg.Rand=function() return wrapRandom(lstg.Rand()) end
stg.SetV,stg.sin,stg.cos,stg.tan=SetV,sin,cos,tan
stg.DefaultRenderFunc=function(o)
    local key=o.img
    if key and key:find('^th43/') then
        if CheckRes('ani',key) then
            RenderAnimation(key,o.ani,o.x,o.y,o.rot,o.hscale*.5,o.vscale*.5)
        else
            Render(key,o.x,o.y,o.rot,o.hscale*.5,o.vscale*.5)
        end
    else
        DefaultRenderFunc(o)
    end
end
E.DefaultRenderFunc=stg.DefaultRenderFunc
local function run(path)
    local chunk,message=loadfile(R.root..path)
    if not chunk then error(message,2) end
    return setfenv(chunk,E)()
end
R.load=run
E.DoFile=run
stg.DoFile=run
local translated=run('names.lua')
E.i18n={get=function(key) return translated[key] or key end}
R.translate=E.i18n.get

local callbacks={'init','del','frame','render','colli','kill'}
local function compile(class)
    assert(class,'栖霞园对象类为空')
    if class._th43_compiled then return end
    if class.init then
        for i,k in ipairs(callbacks) do class[i]=class[k] or noop end
    end
    class._th43_compiled=true
    if AndroidRegisterClass then AndroidRegisterClass(class) end
end
function E.New(class,...)
    if not class then error(debug.traceback('栖霞园对象类为空',2),2) end
    compile(class)
    local o=New(class,...)
    if class.take_damage then o._th43_take_damage=class.take_damage end
    if o.group==GROUP.ENEMY_BULLET or o.group==GROUP.INDES then o.th43_bullet=true end
    local owner=task.stack[#task.stack]
    if owner and owner.IsBoss and owner.class.StageLevel==41 and not owner._sequence_road_carrier then
        R.objects[o]=owner
    else
        R.objects[o]=owner and R.objects[owner] or R.scope or false
    end
    return o
end
stg.New=E.New
stg.RegisterClass=compile
function R.clear(scope)
    local objects={}
    for o,owner in pairs(R.objects) do
        if not scope or owner==scope then
            objects[#objects+1]=o
            R.objects[o]=nil
        end
    end
    for _,o in ipairs(objects) do
        if valid(o) then object.RawDel(o) end
    end
end
local function image(name) return 'th43/'..name end
local function asset(path)
    if path:match('^res/bullet/[^/]+%.png$') then
        local filename=path:match('[^/]+$')
        if R.secondBullet[filename] then return 'Resources/th43/bullet2/'..filename end
    end
    path=path:gsub('^res/boss/LilyWhite/','res/boss/LilyBlack/')
    return path:gsub('^res/','Resources/th43/')
end
R.secondBullet={}
for _,name in ipairs({'ball_big_b','ball_big_c','ball_wool','bird','feather','grain_e','jewel','star_big_b'}) do
    R.secondBullet[name..'.png']=true
end
local function has(kind,name) return CheckRes(kind,name)~=nil end
local function loadTexture(name,path,mipmap)
    local key=image(name)
    if not has('tex',key) then LoadTexture(key,asset(path),mipmap) end
end
local function loadImage(name,texture,...)
    local key=image(name)
    if not has('img',key) then LoadImage(key,image(texture),...) end
    if not has('img',name) and not has('ani',name) then LoadImage(name,image(texture),...) end
end
local function loadAnimation(name,texture,...)
    local key=image(name)
    if not has('ani',key) then LoadAnimation(key,image(texture),...) end
    if not has('ani',name) and not has('img',name) then LoadAnimation(name,image(texture),...) end
end
local function resolve(kind,name)
    if name and has(kind,image(name)) then return image(name) end
    return name
end
E.LoadTexture,E.LoadImage,E.LoadAnimation=loadTexture,loadImage,loadAnimation
stg.LoadTexture,stg.LoadImage=loadTexture,loadImage
stg.IsValid=IsValid
function E.LoadImageFromFile(name,path,mipmap,a,b,rect)
    loadTexture(name,path,mipmap)
    local w,h=GetTextureSize(image(name))
    loadImage(name,name,0,0,w,h,a,b,rect)
end
function E.LoadImageGroup(name,tex,x,y,w,h,n,m,a,b,rect)
    for row=0,m-1 do
        for col=0,n-1 do
            local index=row*n+col+1
            local key=type(name)=='table' and name[index] or name..index
            loadImage(key,tex,x+col*w,y+row*h,w,h,a,b,rect)
        end
    end
end
function E.LoadImageGroupFromFile(name,path,mipmap,n,m,a,b,rect)
    loadTexture(name,path,mipmap)
    local w,h=GetTextureSize(image(name))
    E.LoadImageGroup(name,name,0,0,w/n,h/m,n,m,a,b,rect)
end
function E.LoadAniFromFile(name,path,mipmap,n,m,interval)
    loadTexture(name,path,mipmap)
    local w,h=GetTextureSize(image(name))
    loadAnimation(name,name,0,0,w/n,h/m,n,m,interval)
end
stg.LoadAniFromFile=E.LoadAniFromFile
function E.SetImageState(name,...) return SetImageState(resolve('img',name),...) end
function E.SetAnimationState(name,...) return SetAnimationState(resolve('ani',name),...) end
function E.SetImageCenter(name,...) return SetImageCenter(resolve('img',name),...) end
function E.SetAnimationCenter(name,...) return SetAnimationCenter(resolve('ani',name),...) end
function E.SetImageScale(scale) R.sourceScale=scale end
stg.SetImageScale=E.SetImageScale
function E.Render(name,x,y,rot,h,v,...)
    local scale=R.sourceScale or stg.globalimagescale
    local key=resolve('img',name)
    if key~=name or key and key:find('^th43/') then
        h=h or 1
        h,v=h*scale,(v or h)*scale
    end
    return Render(key,x,y,rot,h,v,...)
end
function E.RenderAnimation(name,...) return RenderAnimation(resolve('ani',name),...) end
stg.Render,stg.RenderAnimation=E.Render,E.RenderAnimation
stg.SetImageState=E.SetImageState
function stg.SetImgState(o,blend,a,r,g,b)
    local name=o.img
    if name and has('ani',name) then SetAnimationState(name,blend,a,r,g,b)
    elseif name then SetImageState(name,blend,a,r,g,b) end
end
local res={}
local function imageState(name,blend,color)
    if type(color)=='number' then color=Color(color) end
    if color then lstg.SetImageState(image(name),blend or '',color)
    else SetImageState(image(name),blend or '',255,255,255,255) end
end
function res:addTexture(...) loadTexture(...) end
function res:addSprite(...) loadImage(...) end
function res:addSpriteFromFile(...) E.LoadImageFromFile(...) end
function res:addSpriteSequence(...) E.LoadImageGroup(...) end
function res:addAnimation(...) loadAnimation(...) end
function res:setSpriteCenter(...) E.SetImageCenter(...) end
function res:setAnimationCenter(...) E.SetAnimationCenter(...) end
function res:setSpriteState(...) imageState(...) end
function res:setSpriteSequenceCenter(name,n,m,x,y)
    for i=1,n*m do self:setSpriteCenter(name..i,x,y) end
end
function res:setSpriteSequenceState(name,n,m,blend,color)
    for i=1,n*m do self:setSpriteState(name..i,blend,color) end
end
function res:setAnimationState(name,blend,color)
    if color then lstg.SetAnimationState(image(name),blend or '',color)
    else SetAnimationState(image(name),blend or '',255,255,255,255) end
end
-- 每段环形贴图使用其原始 UV，避免为每一帧分配新的精灵。
function E.sp.misc.RenderRing3(tex,x,y,inner,outer,n,repeats,rot,length,blend,color,z)
    local key=resolve('tex',tex)
    local w,h=GetTextureSize(key)
    local sweep=(length or 360)/(n*repeats)
    z=z or .5
    local function point(r,angle,u,v)
        return {x+r*cos(angle),y+r*sin(angle),z,u,v,color}
    end
    for i=0,n*repeats-1 do
        local a=rot+i*sweep
        local u0,u1=w*(i%n)/n,w*(i%n+1)/n
        RenderTexture(key,blend,point(inner,a,u0,h),point(outer,a,u0,0),
            point(outer,a+sweep,u1,0),point(inner,a+sweep,u1,h))
    end
end
stg.ResourceSet={create=function() return res end,find=function() return res end}
E.BulletLibrary={addBulletStyles=noop,usingBulletStyles=noop,classCreatorBase=noop}
E.Add_bentlaser_texture_16=function(_,tex) bent_laser.Add_texture('th43_bent4',image(tex)) end
E.Add_bentlaser_envelope=noop
E.Add_bentlaser_texture=function(_,tex) bent_laser.Add_texture(tex,image(tex)) end

E.task=overlay(task)
function E.task.MoveTo(o,x,y,t,mode)
    local dx,dy=x-o.x,y-o.y
    local x0,y0=o.x,o.y
    t=math.max(1,math.floor(t or 1))
    for i=1,t do
        local s=i/t
        if mode==E.MOVE_ACCEL then s=s*s
        elseif mode==E.MOVE_DECEL then s=2*s-s*s
        elseif mode==E.MOVE_ACC_DEC then s=s<.5 and 2*s*s or 1-2*(1-s)*(1-s) end
        o.x,o.y=x0+dx*s,y0+dy*s
        E.task.Wait()
    end
end
E.MOVE_NORMAL,E.MOVE_ACCEL,E.MOVE_DECEL,E.MOVE_ACC_DEC=0,1,2,3
function E.task.MoveToPlayer(o,t,x1,x2,y1,y2,dxmin,dxmax,dymin,dymax,mmode,dmode)
    local x,y=o.x,o.y
    local dx=ran:Float(dxmin,dxmax)
    local dy=ran:Float(dymin,dymax)
    if dmode==E.MOVE_X_TOWARDS_PLAYER then
        if player.x<x then dx=-dx end
    elseif ran:Int(0,1)==0 then dx=-dx end
    if ran:Int(0,1)==0 then dy=-dy end
    E.task.MoveTo(o,math.max(x1,math.min(x2,x+dx)),math.max(y1,math.min(y2,y+dy)),t,mmode)
end
E.task.wait=task.Wait
E.task.clear=task.Clear
local music=run('music.lua')
function E.LoadMusicRecord(key)
    local loop=music[key]
    if not loop then return end
    local name='th43/'..key
    musicList[name]={loop[2],loop[2]-loop[1]}
    if not has('bgm',name) then
        LoadMusic(name,'Resources/th43/music/bgm_'..key..'.ogg',loop[2],loop[2]-loop[1])
    end
    return name
end
function R.playMusic(key,time)
    local name=E.LoadMusicRecord(key)
    if not name then return end
    if R.music==name and not time and GetMusicState(name)=='playing' then return end
    if R.music and has('bgm',R.music) then StopMusic(R.music) end
    R.music=name
    PlayMusic(name,1,time or 0)
end
function R.stopMusic()
    if R.music and has('bgm',R.music) then StopMusic(R.music) end
    R.music=nil
end
function E.PlaySound(name,...)
    if not has('snd',name) then
        local path='Resources/th43/soundeffect/se_'..name..'.wav'
        if not FileExist(path) then return end
        LoadSound(name,path)
    end
    return PlaySound(name,...)
end
E.audio={playMusic=function(key,_,time) R.playMusic(key,time) end,stopMusic=R.stopMusic,playSound=E.PlaySound}
stg.PlaySound=E.PlaySound
E.EISlib.stage.playMusic=R.playMusic
E.EISlib.stage.addStoryScoreAchievementListener=noop
E.EISlib.stage.addExtraScoreAchievementListener=noop
E.dialog={utility={cacheResource=noop},scene=setmetatable({},{__index=function()
    return function(fn) if type(fn)=='function' then fn() end end
end})}
E.system={
    DROP_NORMAL={0,0},DROP_SPELL={50,30},DROP_NONE={0,0},DROP_SMALL_ENEMY={1,1},
    DROP_MID_ENEMY={5,3},DROP_BIG_ENEMY={10,8},DEFAULT_TIMET={3,3,40},
    SMALL_POWER_SCORE=10000,card={ALL=0,DEFAULT_ATTRIBUTE={}},
    getDifficulty=function() return E.difficulty end,
    isNoMiss=function() return (lstg.var.dead or 0)==0 end,
    isNoBomb=function() return (lstg.var.bomb_used or 0)==0 end,
    isDoubleGetSpellCardBonus=function() return false end,
    makeSettlement=noop,
    record={markHighScore=noop,setPlayerClearGroup=noop,unlockExtra=noop,unlockGroup=noop,unlockPerformer=noop},
    gamemode={isSpellCardPractice=function() return R.practice end},
}
local power={rank=0}
local function resources() return NativePlayers and NativePlayers.state() end
local function updateRank(rank)
    power.rank=rank
    local s=resources()
    if s then s.rank=rank end
    local road=lstg.tmpvar.current_road
    if valid(road) and road.class.updateByRankChange then road.class.updateByRankChange() end
end
function power.getRank() return power.rank end
function power.setRankWithEvent(rank) updateRank(rank) end
function power.isInHyper() return power.hyper or false end
function power.getHyperMaxTime() return 27*60 end
function power.setHyperTime(t) power.time=t end
function power.clear_bullet_circle(x,y,r,t,index)
    return E.EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(x,y,r,index,0,t,nil,true)
end
function power.hyperStart()
    if power.hyper then return end
    power.hyper,power.time=true,power.getHyperMaxTime()
    local s=resources()
    if s then s.rankChips,s.hyperChips=0,0 end
    updateRank(4)
    if valid(player) then
        player.protect=math.max(player.protect,121)
        for _,o in ObjList(GROUP.ENEMY_BULLET) do Del(o) end
        E.EISlib.Bullet.Laser.delAllLasers()
    end
end
function power.hyperNormalEnd(p)
    if not power.hyper then return end
    power.hyper,power.time=false,nil
    updateRank(0)
    if valid(p) then p.protect=math.max(p.protect,120) end
end
function power.openInfiniteHyperMode() power.infinite=true end
function power.closeInfiniteHyperMode() power.infinite=false end
function power.pauseHyper() power.paused=true end
function power.resumeHyper() power.paused=false end
function R.addRankChip(n)
    local s=resources()
    if not s then return end
    if power.hyper then s.hyperChips=math.min(6,(s.hyperChips or 0)+n);return end
    local value=(s.rankChips or 0)+n
    local rank=power.rank
    while value>=6 and rank<3 do rank=rank+1;value=value-6 end
    while value<0 and rank>0 do rank=rank-1;value=value+6 end
    s.rankChips=math.max(0,math.min(value,6))
    if rank~=power.rank then updateRank(rank) end
end
function R.gainRankValue(n)
    local s=resources()
    if not s then return end
    s.rankValue=(s.rankValue or 0)+n
    while s.rankValue>=5000 and (power.rank<3 or (s.rankChips or 0)<6 or power.hyper) do
        s.rankValue=s.rankValue-5000
        if power.hyper then s.hyperChips=math.min(6,(s.hyperChips or 0)+1)
        else R.addRankChip(3) end
    end
    s.rankValue=math.min(5000,s.rankValue)
end
function R.tryHyper()
    local s=resources()
    if s and power.rank==3 and s.rankChips==6 then power.hyperStart() end
end
function R.playerMiss()
    local s=resources()
    if not s then return end
    if power.hyper then power.hyperNormalEnd(player)
    elseif power.rank>0 then updateRank(power.rank-1)
    else s.rankChips=0 end
end
E.system.PowerRank=power

E.robject={
    set_color=function(o,blend,a,r,g,b) o._blend,o._a,o._r,o._g,o._b=blend,a,r,g,b end,
    render=function(o)
        E.SetImageState(o.img,o._blend,o._a,o._r,o._g,o._b)
        E.Render(o.img,o.x,o.y,o.rot,o.hscale,o.vscale)
    end,
}
E.player_class={
    changeSpeed=function(p,h,l) p.hspeed,p.lspeed=h,l end,
    lockMovement=function(p,locked) p.lock=locked end,
    setHUDhide=function(o) lstg.tmpvar.th43_hide_hud=o end,
    getColliSize=function(p) return p.a or 0 end,
    getGrazeRange=function(p) return p.grazer and p.grazer.a or 0 end,
    isInBomb=function(p) return p and (p.bombTime or (p.nextspell or 0)>0) end,
}
E._spellcard_background=_SC_BG or object
E.plus=overlay(plus)
E.plus.Class=function()
    local cls={}
    cls.__index=cls
    return setmetatable(cls,{__call=function(_,...) local o=setmetatable({},cls);o:init(...);return o end})
end
E.luaclass=function() return {} end
E.bossface={}
E.r18g={findfile=function() return nil end}
E.laser_bent=overlay(bent_laser,{
    init=function(o,_,x,y,len,width,texture,node)
        bent_laser.init(o,1,x,y,len,width,texture,false)
    end,
    render=function(o) o.node=nil;bent_laser.render(o) end,
    getLength=function(o) return o.l end,
    setLength=function(o,n) o.l=math.max(2,math.floor(n)) end,
    getAlpha=function(o) return o.alpha end,
    setAlpha=function(o,a) o.alpha=a end,
})
E.effect={}
E.effect.shakeScreen=misc.ShakeScreen
function E.RenderStrokeTTF(_,text,left,right,bottom,top,scale,color)
    ui:RenderText('title',text,(left+right)/2,(bottom+top)/2,scale*.6,color,'center')
end
function E.RenderTexture(tex,...) return RenderTexture(resolve('tex',tex),...) end
E.sp.UnitListUpdate=function(list)
    for i=#list,1,-1 do if not valid(list[i]) then table.remove(list,i) end end
end
E.stage=overlay(stage,{})
function E.stage.CurrentStage() return stage.current_stage end
local backdrops={'stage1/far_blue_1.png','stage2/part1/far1.png','stage3/part0/cave1.png',
    'stage4/part2/sky.png','stage5/purple/far.png','stage6/purple/far.png','stage7/part2/far.png'}
local sourceBackground=Class(background)
function sourceBackground:init(n,scenery)
    self.chapter,self.sight=n,scenery
    self.group,self.layer=GROUP.GHOST,LAYER.BG-.1
    self.bound=false
    local previous=lstg.tmpvar.bg
    if valid(previous) then background.DelBG() end
    lstg.tmpvar.bg=self
    if setting.displayBG then
        loadTexture('scene'..n,'res/background/'..backdrops[n])
        if n==1 then loadTexture('scene1_red','res/background/stage1/far_red_1.png') end
        if n==7 then loadTexture('stage7_moon','res/background/stage7/part2/moon.png') end
    end
end
function sourceBackground:render()
    if not setting.displayBG then return end
    SetViewMode('world')
    local n=self.chapter
    local tex=n==1 and self.sight and 'scene1_red' or 'scene'..n
    local w=lstg.world
    local opacity=Color(255,self.red and 230 or 155,self.red and 83 or 155,self.red and 88 or 165)
    local tw,th=GetTextureSize(image(tex))
    local travel=.07*sin(self.timer/20)
    local y=(self.sky and -.12 or 0)+travel
    RenderTexture(image(tex),'',
        {w.l,w.t,.5,tw*.06,th*(.13+y),opacity},
        {w.r,w.t,.5,tw*.94,th*(.13+y),opacity},
        {w.r,w.b,.5,tw*.94,th*(.87+y),opacity},
        {w.l,w.b,.5,tw*.06,th*(.87+y),opacity})
    if n==7 and self.red then
        misc.RenderTexInSize(image('stage7_moon'),0,145,0,.17,.17,'mul+add',Color(145,255,165,165))
    end
end
function sourceBackground.changeToRed(o) o.red=true end
function sourceBackground.flyToSky(o) o.sky=true end
function sourceBackground.moonAppear(o) o.sky=true end
function sourceBackground.Sence3(o) o.sight=true end
sourceBackground.Sence3And4=sourceBackground.Sence3
for i=1,7 do
    local chapter=i
    E['stage'..i..'_background']=Class(sourceBackground,{init=function(o,scenery)
        sourceBackground.init(o,chapter,scenery and scenery~=0)
    end})
    local cls=E['stage'..i..'_background']
    for _,name in ipairs({'changeToRed','flyToSky','moonAppear','Sence3','Sence3And4'}) do cls[name]=sourceBackground[name] end
end
E.boss_death_ef=Class(object,{
    init=function(o,x,y)
        o.x,o.y=x,y
        for i=1,12 do
            E.New(boss_death_ef_unit,x,y,2+i*.2,i*30,48,1.2,'cherry_bullet')
        end
        object.RawDel(o)
    end,
})
E.boss_death_circle=E.boss_death_ef
E.enemy_death_ef=Class(object,{
    init=function(o,color,x,y)
        enemy.death_ef(x,y,30,(tonumber(color) or 1)%4+1)
        object.RawDel(o)
    end,
})

for _,name in ipairs({'Math','Class','ObjectEvent','BulletGroup','Road','RenderEffect'}) do
    run('EISlib/EGGlib/'..name..'.lua')
end
for _,name in ipairs({'bullet_define_normal','bullet2','bullet_shooter','laser'}) do
    run('EISlib/bullet/'..name..'.lua')
end
E.BulletBreak=Class(object,{
    init=function(o,x,y,color)
        o.x,o.y=x,y
        o.img='th43/etbreak'..(color or 1)
        o.layer=LAYER.ENEMY_BULLET_EF
    end,
    frame=function(o) if o.timer>=24 then object.RawDel(o) end end,
    render=E.DefaultRenderFunc,
})
run('EISlib/enemy/enemy_style.lua')
run('EISlib/EGGlib/Particle.lua')
run('EISlib/effect/effect_draw.lua')
run('EISlib/effect/encounters.lua')
for _,color in ipairs({'green','blue','purple','orange'}) do
    local key='boom_'..color
    loadTexture(key,'res/effect/'..key..'.png')
end
run('THlib/DNHWalkImageSystem.lua')
run('EISlib/boss/boss_type.lua')
run('EISlib/boss/aura.lua')
function E.EISlib.BossDefinition.Type.changeWalkImage(o,prototype)
    local walk=setmetatable({}, {__index=prototype})
    walk.obj=o
    walk:setAction('normal')
    o.th43_wisys=walk
    o.ActionGroups=walk.ActionGroups
    o.cast=function(name,wait)
        if walk.ActionGroups[name] then walk.ActionGroups[name](walk,wait) end
    end
    o.setAction=function(name,t) walk:setAction(name,t) end
end
E.item=overlay(item)
local Blood=Class(item)
Blood.Small,Blood.Mid,Blood.Big,Blood.Huge=1,2,3,4
function Blood:init(x,y,kind)
    item.init(self,x,y,9)
    self.type,self.native_pickup=kind or 1,true
end
function Blood:collect()
    R.addRankChip(({1,2,3,6})[self.type])
end
function Blood.create(...) return E.New(Blood,...) end
function Blood.killAllChip()
    for _,o in ObjList(GROUP.ITEM) do if o.class==Blood then Del(o) end end
end
E.item.Blood=Blood
function E.item.DropItem(x,y,drop)
    if R.dropItems then return R.dropItems(x,y,drop[1] or 0,drop[2] or 0) end
    return {}
end
E.item.PointSmall={create=function(x,y) if R.dropItems then R.dropItems(x,y,0,1) end end}
E.item.PlayerBomb={create=function(x,y) if R.dropItems then R.dropItems(x,y,0,0,false,true) end end}
E.item.PlayerLife={create=function(x,y) if R.dropItems then R.dropItems(x,y,0,0,true) end end}
E.system.spellcard={auxiliary={setChainBonusBase=noop}}


function R.reset(diff,practice)
    R.sourceScale=nil
    E.difficulty=diff
    R.practice=practice
    lstg.var.coun_num=lstg.var.coun_num or 0
    local s=resources()
    if s then s.difficulty=diff end
    power.rank,power.hyper,power.infinite,power.time=s and s.rank or 0,false,false,nil
    power.paused=false
    lstg.tmpvar.current_road=nil
    E.EISlib.Bullet.Laser.init()
end
function R.update()
    if power.hyper and not power.paused and not power.infinite and power.time then
        power.time=power.time-1
        if power.time<=0 then power.hyperNormalEnd(player) end
    end
    E.EISlib.Bullet.Laser.update()
end
return R
