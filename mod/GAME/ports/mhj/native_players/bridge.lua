-- 原作自机武器在原坐标内计算；仅在对象与绘制出口换算一次。
local level,R=...
local B={level=level}
local CS=dofile('mod/GAME/ports/source_csharp.lua').new()
local E=CS.env
local night=level==37
local scale=night and 2/3 or 1
local cx,cy=night and 336 or 224,night and 360 or 240
local model=dofile('mod/GAME/ports/mhj/native_players/'..(night and 'night' or 'spring')..'.lua')(CS)
for k,v in pairs(model) do E[k]=v end
if night then
    local curve=dofile('mod/GAME/ports/mhj/native_players/night_curve.lua')(CS).Curve
    E.Curve={__static=true,Get=function(p,n)
        local c=setmetatable({},curve);curve.defaults(c)
        c.points=CS.array(n+1,function() return CS.copy(p) end)
        c.indices=CS.array(n*6,function() return 0 end)
        c.vertices=CS.array(n*2+2,function() return {Position=CS.Vector3(),TextureCoordinate=CS.Vector2()} end)
        c.current,c.actualLength=0,0
        return c
    end,Return=function() end}
end
setmetatable(model.Equipment,{__index=model.EquipShoot})
setmetatable(model.Equipment.__get,{__index=model.EquipShoot.__get})
setmetatable(model.Equipment.__set,{__index=model.EquipShoot.__set})
local function pos(o) return CS.Vector2(o.x/scale+cx,cy-o.y/scale) end
local function valid(o) return o and IsValid(o) end
local function spriteDraw(o,offset,add)
    if not o.shape or not o.rect or o.rect.Width<=0 or o.rect.Height<=0 then return end
    local r=o.rect;local origin=o.origin or CS.Vector2()
    local id=NativePlayers.visual.image(o.shape,r.X,r.Y,r.Width,r.Height,origin.X,origin.Y)
    local p=o.position or o.Position;local s=o.scale or CS.Vector2(1,1);local c=o.color or CS.Colors(1,1,1,1)
    local x,y=(p.X+(offset and offset.X or 0)-cx)*scale,(cy-p.Y-(offset and offset.Y or 0))*scale
    SetImageState(id,add and 'mul+add' or '',math.max(0,math.min(255,c.a*255)),c.r*255,c.g*255,c.b*255)
    Render(id,x,y,-(o.rotation or 0)-(o.Position and 90 or 0),s.X*scale,s.Y*scale)
end
local makeSprite=CS.Sprite
CS.Sprite=function(...)
    local s=makeSprite(...)
    s.depth,s.label=0,0
    s.Draw=function(o,batch)
        if batch and batch.Sprite then return batch:Sprite(o) end
        if o.animation then
            local x,y=o.animation:GetXIndex(),o.animation:GetYIndex()
            if x>=0 then
                local r=CS.copy(o.rect);o.rect.X=r.X+x*r.Width;o.rect.Y=r.Y+y*r.Height
                spriteDraw(o);o.rect=r;return
            end
        end
        spriteDraw(o)
    end
    s.AddClip=function(o,clip) o.animation=o.animation or CS.new('AnimationMachine');o.animation:AddClip(clip) end
    s.Play=function(o,name) o.animation:Play(name) end
    s.Update=function(o) if o.animation then o.animation:Update() end end
    s.GetClip=function(o,name) return o.animation and o.animation:Get(name) end
    s.GetCurrentClip=function(o) return o.animation and o.animation:GetCurrent() end
    s.Connect=function(o,a,b) o.animation:Connect(a,b) end
    return s
end
E.ClipMode={Loop=0,Once=1}
E.Keys={Z='shoot',LeftShift='slow',RightShift='slow'}
E.InputKeys={Shoot='shoot',Slow='slow',MoveLeft='left',MoveRight='right',MoveUp='up',MoveDown='down'}
E.JOYKEYS={}
local key,previous={},{}
E.Main={__static=true,Replay=true,Level=4,Character=1}
function E.Main.IsKeyDown(k) return key[k] or false end
function E.Main.IsKeyUp(k) return not key[k] end
function E.Main.IsPreKeyDown(k) return previous[k] or false end
function E.Main.IsKeyPressed(k) return key[k] and not previous[k] or false end
E.InputKeys.Charge,E.InputKeys.Bomb,E.InputKeys.Switch='special','spell','switch'
local function input(p)
    if B.inputTimer==p.timer then return end
    B.inputTimer=p.timer;previous=key;key={}
    for k,v in pairs(p._playersys.keyState) do key[k]=v end
end
function E.Main.Twopointangle(x,y,px,py) return math.atan2(y-py,x-px) end
E.PadState={__static=true,IsKeyDown=function() return false end,IsKeyUp=function() return true end}
E.Time={Stop=1}
E.Cname={REIMU=1,MARISA=2,SANAE=3,YOUMU=4,MOKOU=4}
E.EquipType={A=0,B=1}
E.LanternStatus={CLOSED=0,OPENING=1,LOSINGCONTROL=2,LOSTCONTROL=3,RELEASING=4,BREAKCLOSING=5,OVERCLOSING=6}
E.CrazyStorm={DefaultCenter=CS.Vector2(336,360)}
E.CrazyStorm.Order={Default=0,UnderActorEquip=1,UnderActor=2,UnderBarrage=3,Overtop=4,Underneath=5,Underneath2=6}
E.CharacterState={Idle1=0,Left1=1,Right1=2,Idle2=3,Left2=4,Right2=5,IdleOld1=6,LeftOld1=7,RightOld1=8,IdleOld2=9,LeftOld2=10,RightOld2=11,Shift=12,ShiftOld=13,Petrify1=14,Petrify2=15,Petrify3=16}
E.Shadows={__new=function() return {x=0,y=0,d=0,alpha=0} end}
E.SpriteEffects={None=0,FlipHorizontally=1,FlipVertically=2}
E.Order={Default=0,Bottom=1,Underneath=2,UnderActor=3,Overtop=4}
E.BlendState={Additive=1,NonPremultiplied=0}
E.SpriteSortMode={Deferred=0}
E.ushort={MaxValue=65535}
E.Controller={__static=true,Rumble=function() end}
E.Game={ScreenRange=CS.Rectangle(48,24,576,672)}
local inside=dofile('mod/GAME/ports/mhj/native_players/target_collision.lua')(CS,valid,scale,cx,cy)
local function rayHit(o,start,dir,damage)
    if not valid(o) or not o.colli then return false end
    local p=pos(o);local c=o.native_actor_collision
    if c and c.noDamage then return false end
    local a,b=(o.IsBoss and 45 or (c and c.damage[1] or o.a)*2/scale),(o.IsBoss and 50 or (c and c.damage[2] or o.b)*2/scale)
    local x,y=start.X-dir.X*24,start.Y-dir.Y*24
    local lo,hi=0,1000
    for _,v in ipairs({{x,dir.X,p.X-a,p.X+a},{y,dir.Y,p.Y-b,p.Y+b}}) do
        if math.abs(v[2])<1e-8 then if v[1]<v[3] or v[1]>v[4] then return false end
        else
            local first,last=(v[3]-v[1])/v[2],(v[4]-v[1])/v[2]
            lo,hi=math.max(lo,math.min(first,last)),math.min(hi,math.max(first,last))
            if lo>hi then return false end
        end
    end
    if type(damage)=='number' then Damage(o,damage) end;return true
end
local wrappers,pruneTargets,clearTargets=dofile('mod/GAME/ports/object_cache.lua')(valid,128)
local function damage(o,amount,limited)
    if night and o.IsBoss and limited and B.lantern then
        -- 原 BossStage.DamageRecord 由同一张卡的多个本体共用。
        local receiver=o.owner and o.owner.mhj3_card and o.owner or o
        if receiver.native_mhj_damage_frame~=B.player.timer then receiver.native_mhj_damage_frame=B.player.timer;receiver.native_mhj_damage=0 end
        amount=math.min(amount,math.max(0,B.lantern.BossDamageLimit-receiver.native_mhj_damage))
        receiver.native_mhj_damage=receiver.native_mhj_damage+amount
    end
    if amount>0 then Damage(o,amount) end
end
local function target(o)
    if not valid(o) then return nil end
    local w=wrappers[o]
    if not w then
        w={object=o,__type=o.IsBoss and 'Boss' or 'Enemy'};wrappers[o]=w
        w.GetPos=function() return pos(o) end
        w.IsTarget=function() return valid(o) and o.colli and not (o.native_actor_collision and o.native_actor_collision.noDamage) end
        w.IsDead=function() return not valid(o) or o.hp<=0 end
        w.IsInWudi=function() return not valid(o) or not o.colli end
        w.DecreasingHp=function(_,power) if valid(o) then damage(o,power,true) end end
        w.JudgeRay=function(_,start,dir,damage) return rayHit(o,start,dir,night and nil or damage) end
        w.Judge=function(_,p,power,extend)
            if night then extend,power=power,nil end
            extend=extend or 0
            if not inside(o,p,extend) then return o.IsBoss and night and -1 or 0 end
            if not night then
                if o.IsBoss then
                    if p.Y<=16 or p.Y>=463 or p.X<=31 or p.X>=416 then return 0 end
                elseif p.Y<=26 or p.Y>=453 or p.X<=30 or p.X>=417 then return 0 end
                Damage(o,power)
            end
            return o.hp
        end
    end
    w.Position,w.X,w.Y=pos(o),o.x/scale+cx,cy-o.y/scale
    w.Scale,w.ScaleFactor=CS.Vector2(1,1),1
    local c=o.native_actor_collision
    w.judgesize=CS.Vector2((c and c.damage[1] or o.a)*2/scale,(c and c.damage[2] or o.b)*2/scale)
    w.JudgeSize=w.judgesize
    if o.IsBoss then w.Scale=1 end
    w.hp,w.ohp,w.die,w.Die,w.Dying,w.leave=o.hp,o.maxhp,false,false,false,not o.colli
    w.DamagedTime=o.timer or 0
    -- 只标记桥接自有的标准引擎属性；自定义元表或遮蔽字段仍由原查询处理。
    local mt=getmetatable(o)
    w.nativeQueryFields=mt and mt.__index==GetAttr and rawget(o,'x')==nil and rawget(o,'y')==nil and rawget(o,'colli')==nil
        and c and getmetatable(c)==nil or false
    w.nativeQueryShape=c
    return w
end
local em={EnemyArray=CS.List()}
function em:Judge(p,power,extend)
    if night and self.EnemyArray.Count==0 then return end
    if night and lstg.FindSourceTargetInList then
        return lstg.FindSourceTargetInList(self.nativeQueryView or self.EnemyArray.items,self.EnemyArray.Count,p.X,p.Y,power,scale,cx,cy,true)
    end
    for _,w in CS.each(self.EnemyArray) do
        if night then if inside(w.object,p,power) then return w end
        elseif w:Judge(p,power,extend)~=0 and w.object.hp>0 then return w.object.maxhp/w.object.hp end
    end
    if not night then return 0 end
end
function em:JudgeRay(start,dir,damage)
    if night then
        local result,distance=nil,math.huge
        for _,w in CS.each(self.EnemyArray) do
            local d=(w.Position-start):LengthSquared()
            if d<=distance and rayHit(w.object,start,dir) then result,distance=w,d end
        end
        return result
    end
    for _,w in CS.each(self.EnemyArray) do if rayHit(w.object,start,dir,damage) and w.object.hp>0 then return end end
end
local bosses={Bosses=CS.List(),CardArray=CS.List()}
function bosses:GetNearestTarget(p)
    local result,dist=nil,math.huge
    for _,w in CS.each(self.Bosses) do
        local d=(w.Position-p):LengthSquared()
        if w:IsTarget() and d<dist then result,dist=w,d end
    end
    return result
end
local familiar={Familiars=CS.List()}
familiar.FamiliarArray=familiar.Familiars
E.FamiliarManager={Instance=familiar}
local function nearestIn(list,p)
    local result,distance=nil,math.huge
    for _,w in CS.each(list) do
        local q=w.Position;local d=(q-p):LengthSquared()
        if not w.Die and not w.Dying and not w.die and not w:IsInWudi() and q.X>=48 and q.X<624 and q.Y>=24 and q.Y<696 and d<=distance then
            result,distance=w,d
        end
    end
    return result
end
function em:MinDistance(p) return nearestIn(self.EnemyArray,p) end
function familiar:MinDistance(p) return nearestIn(self.Familiars,p) end
function familiar:Judge(p,extend)
    if self.Familiars.Count==0 then return end
    if night and lstg.FindSourceTargetInList then
        local w=lstg.FindSourceTargetInList(self.nativeQueryView or self.Familiars.items,self.Familiars.Count,p.X,p.Y,extend,scale,cx,cy,true)
        if w then self.LastDamaged=w end
        return w
    end
    for _,w in CS.each(self.Familiars) do if inside(w.object,p,extend) then self.LastDamaged=w;return w end end
end
function familiar:JudgeRay(start,dir)
    local result,distance=nil,math.huge
    for _,w in CS.each(self.Familiars) do
        local d=(w.Position-start):LengthSquared()
        if d<=distance and rayHit(w.object,start,dir) then result,distance=w,d end
    end
    self.LastDamaged=result;return result
end
local currentBoss,nearest,nearestFamiliar
local function updateTargets(p)
    em.EnemyArray:Clear();bosses.Bosses:Clear();familiar.Familiars:Clear();currentBoss,nearest=nil,nil
    local distance=math.huge
    object.EnemyNontjtDo(function(o)
        if o.IsBoss then
            if not o._sequence_road_carrier and o.is_combat then local w=target(o);bosses.Bosses:Add(w);currentBoss=currentBoss or w end
        elseif o.mhj and o.mhj.familiar then
            local w=target(o);w.__type='Familiar';w.LikeEnemy=o.mhj.familiarConfig[5]==true
            familiar.Familiars:Add(w)
        elseif not o.owner and o.colli then
            local w=target(o);em.EnemyArray:Add(w)
            local d=Dist(p,o);if d<distance then distance,nearest=d,w end
        end
    end)
    if night then nearest,nearestFamiliar=em:MinDistance(pos(p)),familiar:MinDistance(pos(p)) end
    if night and lstg.CreateSourceTargetView then
        em.nativeQueryView=em.EnemyArray.Count>1 and lstg.CreateSourceTargetView(em.EnemyArray.items,em.EnemyArray.Count) or nil
        familiar.nativeQueryView=familiar.Familiars.Count>1 and lstg.CreateSourceTargetView(familiar.Familiars.items,familiar.Familiars.Count) or nil
    end
    bosses.CardArray:Clear()
    if currentBoss then bosses.CardArray:Add({DeHp=function(_,power,selfShot,limited)
        damage(currentBoss.object,power,limited)
    end}) end
end
local shots=CS.List()
local function shotDraw(b)
    if night then
        b.displayTime=b.displayTime+1
        if b.displayTime<b.displayInterval then return end
        b.displayTime=0
        if b.enableShadow then for _,s in CS.each(b.shadows) do if s.alpha>0 then
            s.alpha=s.alpha-1/b.shadows.Length
            spriteDraw({shape=b.shape,rect=b.rect,origin=b.origin,Position=CS.Vector2(s.x,s.y),scale=b.scale,color=CS.Colors(b.color.r,b.color.g,b.color.b,s.alpha),rotation=s.d},nil,b.additive)
        end end end
    end
    if b.curve then
        local c=b.curve;local r=b.rect
        local tex=NativePlayers.visual.texture(c.tex)
        local color=Color(math.max(0,b.color.a*255),b.color.r*255,b.color.g*255,b.color.b*255)
        local function vertex(i)
            local v=c.vertices[i];local p,u=v.Position,v.TextureCoordinate
            return {(p.X-cx)*scale,(cy-p.Y)*scale,.5,r.X+u.X*r.Width,r.Y+u.Y*r.Height,color}
        end
        for i=0,c.vertices.Length/2-2 do
            local a=c.vertices[i*2].TextureCoordinate.Y
            local v=c.vertices[i*2+2].TextureCoordinate.Y
            if a==a and v==v then RenderTexture(tex,b.additive and 'mul+add' or '',vertex(i*2),vertex(i*2+1),vertex(i*2+3),vertex(i*2+2)) end
        end
    else
        local r=CS.copy(b.rect)
        if night then
            if b.uv.X~=0 then r.X=CS.trunc(b.position.X+b.uv.X) end
            if b.uv.Y~=0 then r.Y=CS.trunc(b.position.Y+b.uv.Y) end
        end
        local size=CS.copy(b.scale)
        if b.effect==E.SpriteEffects.FlipHorizontally then size.X=-size.X end
        spriteDraw({shape=b.shape,rect=r,origin=b.origin,Position=b.position or b.Position,scale=size,color=b.color,rotation=b.rotation},nil,b.additive~=false)
    end
end
local Shot=Class(object,{
    init=function(o,b)
        o.source=b;o.group=GROUP.PLAYER_BULLET;o.layer=LAYER.PLAYER_BULLET
        o.bound,o.colli=false,false;o.native_alpha=255;o.a,o.b=math.max(1,b.extend),math.max(1,b.extend)
    end,
    frame=function(o)
        local b=o.source
        if not B.player or not valid(B.player) or b.needDelete then object.RawDel(o);return end
        if night then b:Update(em,nearest,nearestFamiliar,bosses,B.character) else b:Update(em,nearest,currentBoss,B.character) end
        local p=b.position or b.Position;o.x,o.y=(p.X-cx)*scale,(cy-p.Y)*scale
        if b.needDelete then object.RawDel(o) end
    end,
    render=function(o)
        shotDraw(o.source)
    end,
})
E.SelfBarrageManager={__static=true,SBArray=shots}
function E.SelfBarrageManager.Get(tex,r,origin,p,extend,alpha,size)
    local b=CS.new('SelfBarrage')
    b.shape,b.rect,b.origin,b.scale=tex,CS.copy(r),CS.copy(origin),CS.copy(size)
    if night then b.position=CS.copy(p);b.deadRect,b.deadOrigin=CS.copy(r),CS.copy(origin) else b.Position=CS.copy(p) end
    b.extend,b.alpha=extend,alpha;b.sourceObject=New(Shot,b)
    shots:Add(b);return b
end
function E.SelfBarrageManager.Return(b) if b then b.needDelete=true end end
function E.SelfBarrageManager.Clear() for _,b in CS.each(shots) do b.needDelete=true end;shots:Clear() end
local effects={}
do
    function R.playerWeaponHit(b,s)
        local fx=s.controller.friendly
        if not fx or s.dis or s.type<=0 or not ((s.alpha or 100)>95 or fx.allpan) then return end
        local index
        if night then
            for i=0,fx.shoot.Count/3-1 do if s.layerid==fx.shoot[i*3] and s.parentid==fx.shoot[i*3+1] then index=i*3+2;break end end
        else for i=0,fx.shoot.Count/2-1 do if s.parentid==fx.shoot[i] then index=i;break end end end
        if not index then return end
        local profile=night and R.weaponProfile(s) or (s.type<=228 and R.data.bulletTypes[s.type] or s.pattern.types[s.type-228])
        if not profile then return end
        local x,y=s.fx+math.floor(profile[3]/2)-profile[5],s.fy+math.floor(profile[4]/2)-profile[6]
        x,y=x+(s.controller.positionx or 0),y+(s.controller.positiony or 0)
        local function contains(px,py)
            local dx,dy=px-x,py-y
            local a=90-(s.head or 0)
            local w,h=profile[3]*s.wscale,profile[4]*s.hscale
            if night then w,h=math.abs(w),math.abs(h) end
            return math.abs(dx*cos(a)+dy*sin(a))<=w/2
                and math.abs(dy*cos(a)-dx*sin(a))<=h/2
        end
        if fx.clearb then for o in pairs(R.objects) do
            local v=o.mhj
            if valid(o) and v and v.is_projectile and not v.controller.effectLayer and not v.dis and not v.Invincible
                and (not v.Mist or v.age>15) and contains(v.fx,v.fy) then
                    if v.life>2 and v.alpha>=70 then B.game:SmallItem(pos(o)) end
                    Del(o)
                end
        end end
        local amount=fx.shoot[night and index or index+fx.shoot.Count/2]
        local hit=false
        local function apply(w,factor,limited)
            local o=w.object;local v=pos(o)
            if o.colli and not o.protect and contains(v.X+(night and 145 or 93),v.Y+(night and 0 or -13)) then
                damage(o,amount*factor,limited);hit=true;return true
            end
        end
        -- 原作先遍历全部敌机与使魔，普通弹命中它们后不再命中 Boss。
        for _,w in CS.each(em.EnemyArray) do apply(w,fx.shootFactorForEnemy or 1,false) end
        if night then for _,w in CS.each(familiar.Familiars) do
            apply(w,w.LikeEnemy and (fx.shootFactorForEnemy or 1) or (fx.shootFactorForFamiliar or 1),false)
        end end
        if not hit or s.Invincible then for _,w in CS.each(bosses.Bosses) do
            local card=w.object.current_card
            local factor=fx.bomb and not fx.isforshoot and card and card.nativeBombFactor or 1
            if apply(w,(factor or 1)*(fx.shootFactorForBoss or 1),not fx.bomb) then break end
        end end
        if hit and not s.Invincible then Del(b) end
    end
end
local game={Crazystorms=CS.List(),Score=0,bgcolor=CS.Colors(),bombcolor=CS.Colors()}
B.csm={esc=game.Crazystorms,stockCount=0}
local function refreshEffects()
    B.csm.esc=game.Crazystorms
    for _,fx in ipairs(effects) do
        fx.layerm={LayerArray=CS.List()};fx.bgset={}
        local list=CS.List();fx.layerm.LayerArray:Add({Barrages=list})
        for o,s in pairs(fx.controller.bullets) do if valid(o) and s.is_projectile then
            local profile=night and R.weaponProfile(s)
            if profile then fx.bgset[s.type]={rect=CS.Rectangle(0,0,profile[3],profile[4])} end
            list:Add({Dis=s.dis~=nil,time=s.age,Mist=s.Mist,NeedDelete=0,parentid=s.parentid,type=s.type,x=s.fx,y=s.fy,head=s.head,
                Judge=function(_,x,y,px,py,a,w,h)
                    local dx,dy=px-x,py-y;a=90-a
                    return math.abs(dx*cos(a)+dy*sin(a))<=math.abs(w)/2 and math.abs(dy*cos(a)-dx*sin(a))<=math.abs(h)/2
                end})
        end end
    end
end
game.LanternStatus,game.LanternLighting,game.ProtectChance=0,false,0
E.Program={main={game=game}}
function game:PlaySound(name,_,x) R.sound(name) end
function game:StopSound() end
function game:Quake(t,n) if misc.ShakeScreen then misc.ShakeScreen(t,n) end end
function game:Rand() return ran:Float(0,1) end
function game:RandRange(a,b) return ran:Float(a,b) end
function game:SmallItem(first,second)
    local v=type(first)=='table' and first or second
    return NativePlayers.pickup((v.X-cx)*scale,(cy-v.Y)*scale,'points',1)
end
function game:SmallItemFromFamliar(_,v) return self:SmallItem(v) end
E.Sound={__static=true,FadeInFadeable=function() end,FadeOutFadeable=function() end}
local Effect=Class(object,{init=function(o,x,y) o.x,o.y=x,y;o.group=GROUP.GHOST;o.colli,o.bound,o.hide=false,false,true end})
function game:PlayEffect(add,id,p)
    id=tostring(id):gsub('^e','')
    local anchor=New(Effect,(p.X-(night and 336 or 317))*scale,((night and 360 or 227)-p.Y)*scale)
    local c=R.controller(anchor,'e'..id,false);c.effectLayer=LAYER.PLAYER_BULLET
    local fx={Id='e'..id,shoot=CS.List(),time={total=c.pattern.total},controller=c,anchor=anchor,auto=add,clock=0,opos=CS.copy(p)}
    fx.layerm={LayerArray=CS.List()};fx.bgset={}
    function fx:BanSound() end
    function fx:StopSound() end
    function fx:UnderBarrage() c.effectLayer=LAYER.ENEMY_BULLET-1 end
    function fx:UnderActor() c.effectLayer=LAYER.PLAYER-1 end
    function fx:SetOPos(v) self.opos=CS.copy(v) end
    function fx:SetPos(v,all)
        if all and not night then
            -- 原作 ppos 平移整份效果的显示/命中，不改中心与弹体事件坐标。
            R.setEffectOffset(c,v.X-self.opos.X,v.Y-self.opos.Y)
            return
        end
        local x,y=v.X,v.Y
        if all then x,y=x-self.opos.X+p.X,y-self.opos.Y+p.Y end
        anchor.x,anchor.y=(x-(night and 336 or 317))*scale,((night and 360 or 227)-y)*scale
    end
    function fx:IsClosing() return self.closed or self.clock>=self.time.total end
    function fx:Run() self.stopped=false;return not self:IsClosing() end
    function fx:EndStart() self.stopped=true end
    function fx:Break()
        self.closed=true;R.stopEmitter(c)
        for o in pairs(c.bullets) do if valid(o) then Del(o) end end
    end
    function fx:Close() self.closed=true;R.stopEmitter(c) end
    function fx:BarrageCount() local n=0;for o in pairs(c.bullets) do if valid(o) then n=n+1 end end;return n end
    function fx:ReturnComponentToPool() self:Break();if valid(anchor) then object.RawDel(anchor) end end
    function fx:Update(player,target)
        if self:IsClosing() or self.stopped then return end
        c.status=self.Status or c.status;c.friendlyAlpha=self.alpha or 1
        c.weaponTarget=player and player.body and CS.copy(player.body.position)
        self.clock=self.clock+1;R.tick(c)
    end
    c.friendly=fx
    effects[#effects+1]=fx;game.Crazystorms:Add(fx);return fx
end
function game:FindEffect(id) for _,fx in ipairs(effects) do if fx.Id==id and not fx:IsClosing() then return fx end end end
local function character(p)
    local c=B.character
    c.body.position=pos(p);c.Dis=p.hit~=nil or p.native_death_clock~=nil;c.Ban=p.dialog
    c.slow=p.slow==1;c.Wudi=p.protect>0
    c.Position=function() return pos(p) end
    E.Character.IsPlayerShoot=key.shoot or game.LanternStatus==3
    c.IsControling,c.IsPetrifying=c.controling or false,c.petrifying or false
    c.LanternPos,c.LanternDisplayPos,c.LanternControlPos=pos(p),pos(p),pos(p)
    c.EquipType=p.mhj_source and p.mhj_source.equipType or (p.machine.id:find('_b') and 1 or 0)
    c.equipType=c.EquipType
    if night and B.equipment then
        c.LanternPos=B.equipment:GetLanternPos(c.configSet.scale,false)
        c.LanternDisplayPos=B.equipment:GetLanternPos(c.configSet.scale*.875,true)
    end
    c.Spawning,c.Leaving,c.BanShoot=p.death>0,false,p.hit~=nil or p.death>0 or c.BBanShoot or c.PBanShoot or c.SBanShoot or c.CBanShoot or c.LBanShoot
    c.Moving=(p.__move_dx or 0)~=0 or (p.__move_dy or 0)~=0
    c.DashTime,c.NoDashTime,c.NoShootTime=c.dashTime or 0,c.noDashTime or 0,c.noShootTime or 0
end
E.Character={SpawnPoint=CS.Vector2(cx,night and 560 or 420),SelfPowerAlpha=1,
    __new=function(s) return {body=s} end}
local names={reimu=1,marisa=2,sanae=3,youmu=4,mokou=4}
local EquipmentPass=Class(object,{
    init=function(o,p,source,method,layer)
        o.owner,o.source,o.method=p,source,method
        o.group,o.layer,o.colli,o.bound=GROUP.GHOST,layer,false,false
    end,
    frame=function(o)
        if not valid(o.owner) or o.owner.mhj_source~=o.source then object.RawDel(o) end
    end,
    render=function(o)
        if valid(o.owner) and o.owner.mhj_source==o.source then
            SetViewMode('world')
            local equipment=o.source.equipment
            equipment[o.method](equipment,nil,CS.Vector2(),.8,1)
        end
    end,
})
function B.bind(p)
    clearTargets()
    em.nativeQueryView,familiar.nativeQueryView=nil,nil
    key,previous={},{};B.inputTimer=-1;B.bomb=nil
    B.equipment=nil
    B.player=p;E.SelfBarrageManager.Clear();effects={};game.Crazystorms:Clear()
    B.character={body=CS.Sprite(),speedadd=CS.Vector2(1,1),BanBEShoot=false,BanEShoot=false,BWudi=false,BBanShoot=false}
    if night then
        local d=dofile('mod/GAME/ports/mhj/native_players/night_data.lua')[p.machine.art]
        B.character.damageSet={A=d.A,B=d.B,bombEnemy=d.header[9],bombBoss=d.header[10],bombEnemyJue=d.header[11],bombBossJue=d.header[12]}
        B.character.configSet=B.makeConfig(p.machine.art)
        B.character.state=0
    end
    character(p)
    local o=setmetatable({},model.Equipment);model.EquipShoot.defaults(o);model.Equipment.defaults(o)
    o:ctor(night and CS.List({[0]='39_selfbarrage1',[1]='39_selfbarrage2',[2]='39_selfbarrage3',[3]='39_selfbarrage4',[4]='39_selfbarrage5'}) or '37_selfbarrage')
    if night then o:Reinit() else o:Init() end
    p.mhj_source={equipment=o,type=names[p.machine.art],model=model,character=B.character,equipType=p.machine.id:find('_b') and 1 or 0};B.equipment=o
    if night then
        -- 原作按深度分四次绘制装备。控制时灯笼 depth=-1，不能只调用 depth=0 的 Draw。
        New(EquipmentPass,p,p.mhj_source,'DrawUnderneath',LAYER.BG+1)
        New(EquipmentPass,p,p.mhj_source,'DrawUnderActor',LAYER.PLAYER-.1)
        New(EquipmentPass,p,p.mhj_source,'DrawOverTop',LAYER.TOP-1)
    end
    B.character.type,B.character.Equip,B.character.equip=p.mhj_source.type,o,o
    B.character.SelectChaseTarget=function(_,_,_,affect,position)
        local boss=bosses:GetNearestTarget(position);if boss then return CS.copy(boss.Position) end
        local result,distance=nil,math.huge
        for _,list in ipairs({em.EnemyArray,affect and familiar.Familiars or CS.List()}) do
            for _,w in CS.each(list) do local d=(w.Position-position):LengthSquared();if d<distance then result,distance=w,d end end
        end
        return result and CS.copy(result.Position) or CS.Vector2()
    end
end
function B.makeConfig(name,raw)
        local d=dofile('mod/GAME/ports/mhj/native_players/night_data.lua')[name]
        local result={highSpeed=d.header[7],lowSpeed=d.header[8],scale=d.header[6],parts=CS.Dictionary()}
        local config=NativePlayers.visual.data.players['37_'..name]
        for _,part in ipairs(config.parts) do
            local item={anims=CS.Dictionary(),currentPos=CS.Vector2(),currentOffset=CS.Vector2(),currentRotate=0}
            for state,a in pairs(part.states) do
                if E.CharacterState[state] then
                    local sp=CS.Sprite(a.tex,CS.Rectangle(a.x,a.y,config.w,config.h))
                    sp.origin=CS.Vector2(config.ox,config.oy);sp.scale=CS.Vector2(config.scale/scale)
                    if not raw then
                        local clip=CS.new('AnimationClip');clip.name='Default';clip.mode=0;clip.interval=a.interval
                        for i=0,6 do clip.frames:Add(i);clip.frames:Add(0) end
                        sp:AddClip(clip);sp:Play('Default')
                    end
                    item.anims[E.CharacterState[state]]={sprite=sp,offset=CS.Vector2(a.dx,a.dy),rotate=a.rotation,playInterval=a.interval,followDelay=a.follow,changeTime=a.change}
                end
            end
            result.parts[part.name]=item
        end
        return result
end
function B.frame(p,s)
    pruneTargets()
    input(p);character(p);updateTargets(p)
    local source=p.mhj_source
    if night then
        local c=B.character
        c.dashTime=c.Moving and not c.slow and (c.dashTime or 0)+1 or 0
        c.noDashTime=c.dashTime>0 and 0 or (c.noDashTime or 0)+1
        c.noShootTime=not c.BanShoot and not c.Dis and E.Character.IsPlayerShoot and 0 or (c.noShootTime or 0)+1
        if c.state<12 then c.state=math.floor(c.state/3)*3+((p.__move_dx or 0)>0 and 2 or (p.__move_dx or 0)<0 and 1 or 0) end
        for _,entry in CS.each(c.configSet.parts) do
            local part=entry.Value
            if not p.native_death_clock or p.native_death_clock>50 then
                for _,entry in CS.each(part.anims) do entry.Value.sprite:Update() end
            end
            local a=part.anims[c.state]
            if a then
                part.currentPos=part.currentPos+(c.body.position-part.currentPos)/math.max(1,a.followDelay)
                part.currentOffset=part.currentOffset+(a.offset*c.configSet.scale*.875-part.currentOffset)/math.max(1,a.changeTime)
                part.currentRotate=part.currentRotate+(a.rotate-part.currentRotate)/math.max(1,a.changeTime)
            else part.currentPos=CS.copy(c.body.position) end
        end
        source.equipment:UpdateSprite()
    end
    if B.bomb and B.bombBornFrame~=p.timer then
        B.bomb:Update(B.character,nil,em,night and bosses or currentBoss)
        if B.bomb.Die then B.bomb=nil;B.character.BWudi=false end
    end
    if night then
        refreshEffects()
        source.equipment:Update(bosses,em,B.csm,source.type,source.equipType,B.character,B.character.Dis or B.character.BanShoot or B.character.petrifying or p.dialog)
    else
        source.equipment:Update(currentBoss,em,source.type,math.floor(s.power/100),pos(p),B.character.BanEShoot or B.character.Dis or p.dialog)
    end
    for _,fx in ipairs(effects) do if fx.auto and not fx:IsClosing() then fx:Update() end end
    for i=shots.Count-1,0,-1 do if shots[i].needDelete then shots:RemoveAt(i) end end
    if night and B.character.BWudi then p.protect=math.max(p.protect,2) end
end
function B.shoot(p)
    input(p);character(p)
    if not B.character.BanBEShoot and not (night and (B.character.BanShoot or B.character.petrifying)) then
        local s=p.mhj_source
        if night then model.EquipShoot.BEquipShoot(s.equipment,s.equipment.tex,s.type,s.equipType,pos(p),B.character.damageSet)
        else model.EquipShoot.BEquipShoot(s.equipment,'37_selfbarrage',s.type,pos(p)) end
    end
end
function B.render(p)
    if not night then p.mhj_source.equipment:Draw(nil,CS.Vector2())
    else p.mhj_source.equipment:Draw(nil,CS.Vector2(),.8,1) end
end
function B.spell(p,special)
    input(p);character(p);B.character.BWudi=true
    if night then B.bomb=CS.new('SingleBomb','39_bosslist',B.character,bosses,p.mhj_source.type,pos(p),special or false)
    else B.bomb=CS.new('SingleBomb',B.character,p.mhj_source.type,pos(p)+CS.Vector2(93,-13)) end
    B.bombBornFrame=p.timer
    local duration=B.bomb.cs.time.total+(night and 120 or 40)
    p.bombTime,p.nextspell,p.cancelOnlyBomb=duration,duration,true
    if night then p.protect=math.max(p.protect,duration) end
end
function B.speeds(p) local v=B.character.speedadd;return scale+(p.hspeed-scale)*v.Y,p.lspeed*v.X end
function bosses:OpenSideTeammate(id) B.sideTeammate={id=id,time=0} end
B.CS,B.model,B.game,B.input=CS,model,game,input
function B.pressed(action) return key[action] and not previous[action] end
B.bosses,B.enemies= bosses,em
return B
