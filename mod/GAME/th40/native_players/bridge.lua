-- 夏夜祭原始发弹及子机布局；桥接处只转换坐标、原图和宿主对象。
local M,Laser=...
local P=NativePlayers
local CS=dofile('mod/GAME/ports/source_csharp.lua').new()
local E=CS.env;CS.PointF=CS.Vector2
local model=dofile('mod/GAME/th40/native_players/source.lua')(CS)
local atlas=dofile('mod/GAME/th40/native_players/atlas.lua')
local textures={}
local function image(name)
    if textures[name] and CheckRes('img',textures[name]) then return textures[name] end
    local d=assert(atlas[name],name);local tex='summer_source_'..d[1];local id='summer_source_'..name
    local pool=GetResourceStatus();SetResourceStatus('global')
    if not CheckRes('tex',tex) then LoadTexture(tex,'Resources/th40/MyPlane/'..d[1]..'.png') end
    LoadImage(id,tex,d[2],d[3],d[4],d[5]);SetImageCenter(id,d[4]/2+d[6],d[5]/2+d[7]);SetResourceStatus(pool)
    textures[name]=id;return id
end
local current
local function proxy(o,direction)
    local values={Angle=math.pi/2,Damage=21,TransparentValueF=180,ScaleWidth=1,ScaleLength=1,Mirrored=false}
    return setmetatable({}, {__index=function(_,k) return values[k] end,__newindex=function(_,k,v)
        values[k]=v
        if k=='Damage' then o.dmg=v elseif k=='Angle' then o.rot=-math.deg(direction+v-math.pi/2)
        elseif k=='TransparentValueF' then o.native_alpha=v elseif k=='ScaleWidth' then o.hscale=v elseif k=='ScaleLength' then o.vscale=v end
    end})
end
local function shot(_,name,where,speed,direction,homing)
    local p=current.player
    local o=P.emit(p,image(name),where.X-p.x,-where.Y-p.y,speed,-math.deg(direction),21,15,1,nil,true)
    o.native_alpha=180;o.native_summer=true;o.rot=-math.deg(direction)
    if homing then o.summerGuidance=true;o.maxAge=101 end
    return proxy(o,direction)
end
E.BaseMyBullet_Touhou={__new=shot}
E.BulletGuidance={__new=function(a,b,c,d,e) return shot(a,b,c,d,e,true) end}
E.MarisaLaser={__new=function(_,name,where,speed,direction)
    local p=current.player;local o=New(Laser,p,where.X-p.x,-where.Y-p.y,-math.deg(direction))
    return {SetBinding=function(_,sub) o.binding=sub end}
end}
local ids={A='Reimu',B='Marisa',C='Sanae',D='Koishi'}
local function subCtrl(o)
    local old=o.Position
    o.Position=old+(o.velocity or CS.Vector2())
    o.OriginalPosition=CS.copy(o.Position)
    local delta=o.DestPoint-o.Position;local length=delta:Length()
    o.velocity=length==0 and CS.Vector2() or delta*(length>2 and 1/2.5 or .5/length)
end
local function bind(p)
    p.summerTime=270
    local name=ids[p.machine.id]
    local q={player=p,name=name,OriginalPosition=CS.Vector2(p.x,-p.y),Position=CS.Vector2(p.x,-p.y),KClass={Key_Shift=false},PowerLevel=4,BoundRect={Width=384},SpellList=CS.List(),SubPlanePoint=CS.array(4,CS.Vector2),SubPlaneList=CS.List()}
    q.StageData={SoundPlay=function() PlaySound('plst00',.16,p.x/384) end}
    for i=0,3 do
        local sub={Position=CS.Vector2(p.x,-p.y),OriginalPosition=CS.Vector2(p.x,-p.y),ShootDirection=-math.pi/2,KClass=q.KClass,StageData=q.StageData,Mirrored=false,Ctrl=subCtrl}
        sub.Shoot=model['SubPlane_'..name].Shoot;q.SubPlaneList:Add(sub)
    end
    p.summer_source=q
end
local function update(p,s)
    local q=p.summer_source;if q.frame==p.timer then return end;q.frame=p.timer;current=q
    q.Time=p.summerTime or p.timer;q.OriginalPosition=CS.Vector2(p.x,-p.y);q.Position=CS.copy(q.OriginalPosition)
    q.PowerLevel=math.min(4,math.floor(s.power/100));q.KClass.Key_Shift=p.slow==1
    model['MyPlane_'..q.name].SubPlaneCtrl(q)
end
local oldBind,oldFrame,oldRender=M.bind,M.frame,M.render
function M.bind(p) oldBind(p);bind(p) end
function M.frame(p,s) oldFrame(p,s);update(p,s);if p.summerTime then p.summerTime=p.summerTime+1 end end
function M.shoot(p,t,s)
    update(p,s);current=p.summer_source
    if current.Time>70 then model['MyPlane_'..current.name].Shoot(current) end
end
function M.render(p,s)
    update(p,s)
    local q=p.summer_source
    for i=0,q.PowerLevel-1 do
        local sub=q.SubPlaneList[i];local name=q.name..(q.name=='Koishi' and (p.slow==1 and 'SubPlane00' or 'SubPlane01') or 'SubPlane')
        local img=image(name);local alpha=q.name=='Reimu' and p.slow==1 and 0 or 255
        local size=(q.name=='Sanae' or q.name=='Koishi') and 1+.1*math.sin(p.timer/40*2*math.pi) or 1
        SetImageState(img,'',alpha,255,255,255);Render(img,sub.Position.X,-sub.Position.Y,p.timer*5,size)
        if s.power>=400 then SetImageState(img,'',alpha*.6,255,255,255);Render(img,sub.Position.X,-sub.Position.Y,-p.timer*5,1.3) end
    end
    oldRender(p,s,true)
end
local oldShotFrame=M.shotClass.frame or P.Shot.frame
M.shotClass.frame=function(o)
    oldShotFrame(o)
    if not o.summerGuidance then return end
    local target=o.summerTarget
    if not target and not o.summerAcquired then
        o.summerAcquired=true
        for _,b in ipairs(boss_group) do if IsValid(b) and b.colli then target=b;break end end
        if not target then local distance=300;object.EnemyNontjtDo(function(t)
            if t.colli and Dist(o,t)<distance then target,distance=t,Dist(o,t) end
        end) end
        o.summerTarget=target
    end
    if target and IsValid(target) and target.hp>0 then
        local desired=math.atan2(o.y-target.y,target.x-o.x);local angle=-math.rad(o.dir)
        if desired>math.pi then desired=desired-2*math.pi end;if angle>math.pi then angle=angle-2*math.pi end
        local delta=desired-angle;if delta>math.pi then delta=delta-2*math.pi end
        if math.abs(delta)>.019999999552965164 and Dist(o,target)>50 then delta=delta/5 end
        o.dir=-math.deg(angle+delta);o.rot=o.dir;o.vx,o.vy=o.v*cos(o.dir),o.v*sin(o.dir)
    end
end
M.lateFrame,M.lateControl=true,true
return M
