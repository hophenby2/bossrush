-- 永夜篇的原生对象。逻辑使用原坐标，渲染和碰撞按 2/3 投影到项目场地。
local SOURCE_BULLET_CAP=10000
local allocateTable
do
    local available,factory=pcall(require,'table.new')
    allocateTable=available and factory or function() return {} end
end
-- 原作在载入时建立 10000 格 BarragePool；热路径索引也提前预留，避免集中生成时重哈希。
local R={patterns={},classes={},assets={},objects=setmetatable(allocateTable(0,SOURCE_BULLET_CAP),{__mode='k'}),bulletCount=0,overflow=0,controllers=setmetatable({},{__mode='k'})}
local D=dofile('mod/GAME/th39/catalogue.lua')
local patternAudio=dofile('mod/GAME/th39/pattern_audio.lua')
local Mask=dofile('mod/GAME/th39/background_mask.lua')
local Bindings=dofile('mod/GAME/ports/binding_index.lua')
local floor,abs,min,max=math.floor,math.abs,math.min,math.max
local SCALE=2/3
-- Rebound.cs 的交点和反射使用单精度，不改变其他弹幕的现有积分路径。
local floatBox=require('ffi').new('float[1]')
local function f32(x) floatBox[0]=x;return floatBox[0] end
local radians=f32(math.pi/180)
local function sourceCos(a) return f32(math.cos(f32(a*radians))) end
local function sourceSin(a) return f32(math.sin(f32(a*radians))) end
function R.project(x,y) return (x-336)*SCALE,(360-y)*SCALE end
local function projectBullet(x,y) return R.project(x-145,y) end
local function unproject(o) return o.x/SCALE+481,360-o.y/SCALE end
local function trunc(x) return x<0 and math.ceil(x) or floor(x) end
local function valid(o) return o and IsValid(o) end
local function random(c)
    if not c.visual then return ran:Float(0,1) end
    -- 背景有自己的随机状态，练习回放背景时不会改动弹幕的随机序列。
    c.seed=c.seed*16807%2147483647
    return c.seed/2147483647
end
local function rnd(a,o)
    if a==0 then return 0 end
    local c=o.controller
    if not c or not c.visual then return ran:Float(-a,a) end
    return (random(c)*2-1)*a
end
local function live(c,b)
    if c.visual then return b.alive end
    return valid(b)
end
local copySizes=setmetatable({},{__mode='k'})
local nativeCopy=lstg.CopySourceTable
local nativeGeometry=lstg.SyncSourceBulletGeometry
local stateReserve={}
local reserveReady=false
local RESERVE_LIMIT,RESERVE_REFILL=1024,16
local function refillStates(limit)
    for _=1,min(limit,RESERVE_LIMIT-#stateReserve) do
        local state=allocateTable(0,128)
        state.changes,state.limits={},{}
        stateReserve[#stateReserve+1]=state
    end
end
local function prepareStates()
    if not reserveReady then refillStates(RESERVE_LIMIT);reserveReady=true end
end
local function copy(s,projectile)
    -- 原作 Barrage.Get 复用容器。Lua 状态仍可能被绑定快照引用，不能直接回池复用；
    -- 按源表的实际字段数预分配哈希区，保持浅拷贝语义并避免同一帧大量重复扩容。
    local storage,changes,limits
    if projectile then
        local count=#stateReserve
        storage=stateReserve[count];stateReserve[count]=nil
        if storage then changes,limits=storage.changes,storage.limits end
    end
    local o,count
    if nativeCopy then o,count=nativeCopy(s,copySizes[s] or 128,storage)
    else
        o,count=storage or allocateTable(0,copySizes[s] or 128),0
        for k,v in pairs(s) do o[k]=v;count=count+1 end
    end
    copySizes[s]=count+8
    o.changes=changes or {};o.limits=limits or {};return o
end
local changePool={}
local function takeChange()
    local count=#changePool
    if count==0 then return allocateTable(0,12) end
    local change=changePool[count];changePool[count]=nil
    return change
end
local function returnChange(change)
    -- 对应原作 BExecution/Execution.Return；仅在本次插值结束或宿主销毁后归还。
    for key in pairs(change) do change[key]=nil end
    if #changePool<100000 then changePool[#changePool+1]=change end
end
local function clearChanges(o)
    local changes=o.changes
    if not changes then o.changes={};return end
    for i=#changes,1,-1 do returnChange(changes[i]);changes[i]=nil end
end
function R.player(context)
    local c=context and (context.controller or context);local t=c and c.weaponTarget
    if t then return t.X+145,t.Y end
    if c and c.previewPlayer then return c.previewPlayer[1],c.previewPlayer[2] end
    if valid(player) then return unproject(player) end
    return 481,560
end
local function angle(x,y,tx,ty) return math.deg(math.atan2(ty-y,tx-x)) end
local function direction(v,o,x,y,point)
    if v==-99999 then local px,py=R.player(o);return angle(x,y,px,py)
    elseif v==-99998 then return angle(x,y,o.x or x,o.y or y)
    elseif v==-100000 and point then return angle(x,y,point[1],point[2]) end
    return v or 0
end
local intFields={t=true,tiao=true,range=true,life=true,sonlife=true}
local function integer(o,key) return intFields[key] or key=='type' and o.is_projectile end
local boolFields={Mist=true,Dispel=true,Blend=true,Afterimage=true,Outdispel=true,Invincible=true}
local function set(o,key,v)
    if integer(o,key) then v=trunc(v) end
    if key=='type' and v~=o.type then o.typeChanged=o.age end
    if boolFields[key] then v=v~=0 end
    if o.controller and o.controller.visual and (key=='Blend' or key=='layerid') and o[key]~=v then o.controller.drawDirty=true end
    o[key]=v
    if key=='speed' or key=='speedd' then o.motion_dirty=true end
    if key=='xscale' or key=='yscale' then o.motion_dirty,o.sonmotion_dirty,o.accel_dirty,o.sonaccel_dirty=true,true,true,true end
    if key=='sonspeed' or key=='sonspeedd' then o.sonmotion_dirty=true end
    if key=='aspeed' or key=='aspeedd' then o.accel_dirty=true end
    if key=='sonaspeed' or key=='sonaspeedd' then o.sonaccel_dirty=true end
end
function R.once(o,id,count)
    local n=o.limits[id] or 0;if n>=tonumber(count) then return false end
    o.limits[id]=n+1;return true
end
function R.change(o,key,value,random,op,mode,duration)
    local initial=o[key] or 0;if type(initial)=='boolean' then initial=initial and 1 or 0 end
    if type(value)=='boolean' then value=value and 1 or 0 end
    -- Barrage.type为零基，Batch.type为一基；这里的精灵表统一使用一基。
    if key=='type' and op==0 and type(value)=='number' then value=value+1 end
    if value=='自机' or value=='中心' then
        local c=o.controller
        local x,y
        if value=='中心' then x,y=c.center.ox,c.center.oy else x,y=R.player(o) end
        local ox,oy=0,0
        if c and not o.is_projectile and not o.bound_source then ox,oy=c.offsetx,c.offsety end
        local bx,by=o.fx or o.x or o.ox,o.fy or o.y or o.oy
        if o.bound_source then bx,by=o.bound_source.fx,o.bound_source.fy end
        if key=='fx' then value=x-ox elseif key=='fy' then value=y-oy
        else value=angle(bx+ox,by+oy,x,y) end
    elseif value=='自身' then value=initial end
    value=value+rnd(random,o)
    local change=takeChange()
    change.key,change.value,change.initial,change.op,change.mode=key,value,initial,op,mode
    change.duration,change.left=max(1,duration),max(1,duration)
    o.changes[#o.changes+1]=change
end
local function centerMove(o,x,y,slow,duration)
    if not o.is_center or not valid(o.host) or o.controller.road then return end
    local x0,y0=o.ox,o.oy
    duration=duration or (slow and max(10,floor(math.sqrt((x-x0)^2+(y-y0)^2)/1.5)) or 60)
    local change=takeChange()
    change.mode,change.x,change.y,change.x0,change.y0,change.slow='move',x,y,x0,y0,slow
    change.left,change.duration=duration,duration
    o.changes[#o.changes+1]=change
end
function R.move(o,slow,x1,x2,y1,y2)
    centerMove(o,x1+(x2-x1)*ran:Float(0,1),y1+(y2-y1)*ran:Float(0,1),slow)
end
function R.follow(o,axis)
    if not o.is_center then return end
    local x,y=R.player(o.controller and o.controller.visual and o or nil)
    if axis:find('X',1,true) then y=o.oy elseif axis:find('Y',1,true) then x=o.ox end
    centerMove(o,x,y,axis:find('慢',1,true)~=nil,90)
end
function R.hide(o,value) if valid(o.host) then o.host.mhj3_hidden=value end end
function R.state(o,status) o.controller.status=status;o.controller.statusFrame=0 end
local function control(o,mode,options)
    if not o.controller or not valid(player) then return end
    local old=o.controller.control
    if not old then options.previous=player.lock else options.previous=old.previous end
    options.player,options.mode,options.age=player,mode,0
    o.controller.control=options
    player.lock=true
end
function R.petrify(o,kind,count)
    if R.sourceStatus then o.controller.playerStatus=true;R.sourceStatus('Petrify',count and kind or 0,count or kind);return end
    control(o,'petrify',{presses=count or kind})
end
function R.lockdown(o,duration,effect)
    if R.sourceStatus then o.controller.playerStatus=true;R.sourceStatus('Lockdown',duration,effect);return end
    control(o,'lockdown',{duration=duration})
end
function R.control(o,startup,x,y,duration,tail,effect)
    if R.sourceStatus then o.controller.playerStatus=true;R.sourceStatus('Control',startup,x,y,duration,tail,effect);return end
    if not valid(player) then return end
    x,y=projectBullet(x,y)
    control(o,'move',{startup=startup,duration=duration,tail=tail,x=x,y=y,fromX=player.x,fromY=player.y})
end
function R.gettingold(o) if R.sourceStatus then R.sourceStatus('GettingOld') end end
function R.returnyouth(o) if R.sourceStatus then R.sourceStatus('ReturnYouth') end end
local function releaseControl(c)
    local control=c.control
    if not control then return end
    if valid(control.player) then control.player.lock=control.previous end
    c.control=nil
end
local function stepControl(c)
    local s=c.control
    if not s then return end
    if not valid(s.player) then c.control=nil;return end
    s.age=s.age+1
    s.player.__shoot_flag=false
    if s.mode=='petrify' then
        if KeyIsPressed('up') or KeyIsPressed('down') or KeyIsPressed('left') or KeyIsPressed('right') then
            s.presses=s.presses-1
        end
        if s.presses<=0 then releaseControl(c) end
    elseif s.mode=='lockdown' then
        if s.age>=s.duration then releaseControl(c) end
    else
        local t=min(1,max(0,(s.age-s.startup)/max(1,s.duration)))
        local k=(1-math.cos(math.pi*(1-(1-t)^1.5)))/2
        s.player.x,s.player.y=s.fromX+(s.x-s.fromX)*k,s.fromY+(s.y-s.fromY)*k
        if s.age>=s.startup+s.duration+s.tail then releaseControl(c) end
    end
end
function R.select(o,layer,kind,...)
    local choices={...}
    local selected=choices[min(#choices,1+floor(o.controller.visual and random(o.controller)*#choices or ran:Float(0,#choices)))]
    local layerKind=({'batch','laser','cover','rebound','force'})[kind+1]
    for _,e in ipairs(o.controller.emitters) do
        if e.parentid==layer and e.kind==layerKind then
            for _,id in ipairs(choices) do if e.id==id-1 then e.unselected=id~=selected end end
        end
    end
end
local audio=dofile('mod/GAME/ports/mhj/source_audio.lua').new(39)
function R.sound(name,x) audio.play(name,x) end
function R.stopSound(name) audio.stop(name) end
function R.fadeEnvironment(seconds,fadeIn) audio.fadeEnvironment(seconds,fadeIn) end
function R.playEventSound(o,name)
    local c=o.controller
    if not (c.ownerScene and c.ownerScene.seeking) then R.sound(name,(o.fx or c.center.ox)-145) end
end
local function interpolate(o)
    local i=1
    while i<=#o.changes do
        local c=o.changes[i]
        if c.mode=='move' then
            if c.slow then
                local k=(1-math.cos(math.pi*(1-(c.left/c.duration)^1.5)))/2
                o.ox,o.oy=c.x0+(c.x-c.x0)*k,c.y0+(c.y-c.y0)*k
            else
                o.ox,o.oy=(o.ox*19+c.x)/20,(o.oy*19+c.y)/20
            end
        else
            local old=o[c.key] or 0;if type(old)=='boolean' then old=old and 1 or 0 end
            local v
            if c.mode=='正弦' or c.mode=='无缝正弦' then
                local delta=c.op==0 and c.value-c.initial or c.op==1 and c.value or -c.value
                local phase=(c.duration-c.left+(c.mode=='无缝正弦' and 1 or 0))/c.duration
                v=c.initial+delta*sin(360*phase)
            elseif c.mode=='固定' then
                local value=integer(o,c.key) and trunc(c.value) or c.value
                v=c.op==0 and c.value or old+(c.op==1 and value or -value)
            elseif c.op==0 then v=(old*(c.left-1)+c.value)/c.left
            else
                local delta=c.value/c.duration
                if integer(o,c.key) then delta=trunc(delta) end
                v=old+(c.op==1 and delta or -delta)
            end
            set(o,c.key,v)
        end
        c.left=c.left-1
        if c.left<=((c.mode=='正弦' or c.mode=='无缝正弦') and -1 or 0) then
            table.remove(o.changes,i);returnChange(c)
        else i=i+1 end
    end
end
local function motion(o,son,scale)
    scale=scale or 1
    local s=son and 'sonspeed' or 'speed';local d=son and 'sonspeedd' or 'speedd'
    local a=son and 'sonaspeed' or 'aspeed';local ad=son and 'sonaspeedd' or 'aspeedd'
    local dirty=son and 'sonmotion_dirty' or 'motion_dirty';local accel=son and 'sonaccel_dirty' or 'accel_dirty'
    if o[dirty] or o.mx==nil then
        o.mx=(son and o.xscale or 1)*(o[s] or 0)*cos(o[d] or 0);o.my=(son and o.yscale or 1)*(o[s] or 0)*sin(o[d] or 0);o[dirty]=false
    end
    if o[accel] or o.ax==nil then
        o.ax=(son and o.xscale or 1)*(o[a] or 0)*cos(o[ad] or 0);o.ay=(son and o.yscale or 1)*(o[a] or 0)*sin(o[ad] or 0);o[accel]=false
    end
    o.mx=o.mx+o.ax*scale;o.my=o.my+o.ay*scale
    return o.mx*scale,o.my*scale
end
-- Lua模块缓存跨练习重试保留；动态切出的精灵也必须放全局池，避免关卡池清除后留下假缓存。
local function globalResource(fn)
    local pool=GetResourceStatus()
    SetResourceStatus('global');fn();SetResourceStatus(pool)
end
local function loadTexture(key)
    local name='mhj3_tex_'..key
    if not R.assets[name] then
        globalResource(function() LoadTexture(name,'Resources/th39/'..key..'.png') end)
        R.assets[name]=true
    end
    return name
end
function R.sprite(name,key,x,y,w,h,cx,cy)
    if not R.assets[name] then
        local tex=loadTexture(key)
        globalResource(function()
            LoadImage(name,tex,x,y,w,h)
            SetImageCenter(name,cx,cy)
        end)
        R.assets[name]=true
    end
    return name
end
local function profile(p,index)
    index=max(1,trunc(index))
    return index<=#D.bulletTypes and D.bulletTypes[index] or p.types[min(index-#D.bulletTypes,#p.types)]
end
function R.weaponProfile(s) return profile(s.pattern,s.type) end
local textureFrames=setmetatable({},{__mode='k'})
local function texture(s)
    local p=profile(s.pattern,s.type)
    if not p or p[3]<=0 or p[4]<=0 or p[16]=='' then return 'img_void' end
    local n=floor(max(0,s.age-(s.typeChanged or 0))/(1+(p[10] or 0)))%max(1,p[9] or 1)
    local key=p[16] or 'barrages'
    local c=s.controller
    local height=(c.textureHeights and c.textureHeights[key]) or D.textureHeights[key] or p[4]
    local columns=max(1,floor(height/p[4]))
    local frames=textureFrames[p]
    if not frames then frames={};textureFrames[p]=frames end
    local columnFrames=frames[columns]
    if not columnFrames then columnFrames={};frames[columns]=columnFrames end
    local frame=columnFrames[n]
    if not frame then
        local name='mhj3_b_'..key..'_'..p[1]..'_'..p[2]..'_'..p[3]..'_'..p[4]..'_'..p[5]..'_'..p[6]..'_'..n
        frame={name,'mhj3_tex_'..key,p[1]+floor(n/columns)*p[3],p[2]+n%columns*p[4]}
        columnFrames[n]=frame
    end
    local name,tex,x,y=frame[1],frame[2],frame[3],frame[4]
    if c.visual and key:sub(1,6)=='scene/' then
        local store=c.resources
        -- 场景图片仍逐次核对资源池，练习退出后可按原路径重新载入。
        if not CheckRes('tex',tex) then
            LoadTexture(tex,'Resources/th39/'..key..'.png')
            if store then store.tex[tex]=GetResourceStatus() end
        end
        if not CheckRes('img',name) then
            LoadImage(name,tex,x,y,p[3],p[4])
            SetImageCenter(name,p[5],p[6])
            if store then store.img[name]=GetResourceStatus() end
        end
        return name,tex,x,y,p
    end
    return R.sprite(name,key,x,y,p[3],p[4],p[5],p[6]),tex,x,y,p
end
function R.loadPattern(id)
    if not R.patterns[id] then R.patterns[id]=dofile('mod/GAME/th39/'..(id:sub(1,1)=='e' and 'player_patterns/' or 'patterns/')..id..'.lua') end
    R.patterns[id].audio=patternAudio[id:sub(1,1)=='e' and id or 'b'..id]
    return R.patterns[id]
end
local function bindingTargets(o)
    local layer=o.controller.parents[o.parentid]
    return Bindings.snapshot(layer and layer[o.bindid])
end
local function targetable(c,pair)
    local b,s=pair[1],pair[2]
    return b and live(c,b) and s.kind~='laser' and (not s.Mist or s.age>15)
end
local function projected(b)
    local s=b.mhj
    local x,y=projectBullet(s.fx,s.fy)
    local p=profile(s.pattern,s.type)
    local r=p and p[7] or 0
    local a,bb=r*abs(s.wscale)*SCALE,r*abs(s.hscale)*SCALE
    local rot=-((s.Withspeedd and math.deg(math.atan2(s.my or 0,s.mx or 0)) or s.head or 0)+90)
    local hscale,vscale=s.wscale*SCALE,s.hscale*SCALE
    if nativeGeometry then nativeGeometry(b,x,y,a,bb,rot,hscale,vscale)
    else
        b.x,b.y=x,y;b.vx,b.vy=0,0;b.a,b.b=a,bb
        b.rect,b.rot=false,rot;b.hscale,b.vscale=hscale,vscale
    end
    local born=s.Mist and min(1,s.age/15) or 1
    b._a=max(0,min(255,(s.alpha or 100)*2.55*born*(s.controller.friendlyAlpha or 1)));b._r,b._g,b._b=s.colorR or 255,s.colorG or 255,s.colorB or 255
    b._blend=s.Blend and 'mul+add' or ''
    local layer=(s.controller.effectLayer or LAYER.ENEMY_BULLET)+(s.controller.pattern.order==1 and .1 or 0)
    local group=s.controller.effectLayer and GROUP.GHOST or (s.Invincible or p and p.invincible) and GROUP.INDES or GROUP.ENEMY_BULLET
    -- 按实际引擎属性确认层与分组，仅在变化时同步。
    if b.layer~=layer then b.layer=layer end
    if b.group~=group then b.group=group end
    b.colli=not s.controller.effectLayer and s.age>(s.Mist and 15 or 0) and s.type>1 and r>0 and (s.alpha or 100)>99 and s.wscale~=0 and s.hscale~=0
end
local function clean(b)
    local s=b.mhj
    if s then clearChanges(s) end
    if s and s.controller and s.controller.host==b then R.stopEmitter(s.controller) end
    if s and s.controller and s.controller.bullets then
        s.controller.bullets[b]=nil
        Bindings.remove(s.bucket,b)
        if s.counted then R.bulletCount=R.bulletCount-1;s.counted=false end
    end
    if s and s.familiar and s.controller then
        if s.controller.familiars[s.familiar]==b then s.controller.familiars[s.familiar]=nil end
        if s.killed then s.controller.deadFamiliars[s.familiar]=(s.controller.deadFamiliars[s.familiar] or 0)+1 end
    end
    R.objects[b]=nil;object.RawDel(b)
end
local function updateParticle(s)
    s.age=s.age+1
    if s.age>(s.life or 1)+(s.Mist and 15 or 0) then return false end
    local t=s.age-(s.Mist and 15 or 0)
    s.status,s.statusFrame=s.controller.status,s.controller.statusFrame
    if t>0 then
        if t==1 and not s.controller.visual and not s.controller.effectLayer and not s.banSound and s.life>2 and s.alpha>60 then
            local sounds=s.pattern.audio and s.pattern.audio.sounds
            local name=sounds and sounds[tostring(s.type)]
            if not name and s.type<=#D.bulletTypes then name=s.controller.usekira and 'kira' or 'tan' end
            if name and name~='' then R.sound(name,s.fx-145) end
        end
        -- 原Barrage.Update先积分，再更新事件；速度变化从下一运动帧生效。
        local dx,dy=motion(s,true,s.controller.slow or 1)
        s.fx,s.fy=s.fx+dx,s.fy+dy
        if s.Sonevents then s.Sonevents(s,t,R) end
        if s.covers then
            -- 原作复制到 Barrage.Events 的覆盖事件在 Cover 停止更新后继续生效。
            -- Cover 按进入顺序把事件追加到 Barrage.Events；不能让表地址决定同帧覆盖顺序。
            for _,source in ipairs(s.coverOrder) do s.covers[source](s,s.controller.time,R) end
        end
        s.maskEntered=0
        interpolate(s)
        if t>s.life then return false end
    end
    return true
end
local function outOfBounds(s)
    return s.Outdispel and (s.fx<118 or s.fx>844 or s.fy< -51 or s.fy>771)
end
R.classes.projectile=Class(bullet,{
    init=function(b,s)
        -- 不经过通用雾化类；CrazyStorm自己有15帧出生与事件时钟。
        -- projected 会一次写入完整位置、分组、层次和颜色，避免出生时先写默认值再重复改写。
        s.is_projectile=true;b.mhj=s;b.bound=false
        s.age=0;clearChanges(s);s.limits=s.limits or {};s.object=nil;s.renderImage=nil
        R.objects[b]=true;s.controller.bullets[b]=s;projected(b)
    end,
    frame=function(b)
        local s=b.mhj
        if s.dis then
            s.dis=s.dis+1;s.alpha=max(0,(s.cancelAlpha or 100)-s.dis*4)
            s.wscale=max(0,s.wscale-.06);s.hscale=max(0,s.hscale-.06)
            projected(b);b.colli=false
            if s.dis>30 then clean(b) end
            return
        end
        if not updateParticle(s) then clean(b);return end
        projected(b)
        if s.controller.friendly and R.playerWeaponHit then R.playerWeaponHit(b,s) end
        if outOfBounds(s) then clean(b) end
    end,
    render=function(b)
        if b._a<=0 then return end
        local s=b.mhj;local img=texture(s)
        if s.renderImage~=img then b.img=img;s.renderImage=img end
        if RenderSourceObjectImage then RenderSourceObjectImage(img,b,b._blend,b._a,b._r,b._g,b._b)
        else
            SetImageState(img,b._blend,b._a,b._r,b._g,b._b)
            Render(img,b.x,b.y,b.rot,b.hscale,b.vscale)
        end
    end,
    del=function(b)
        if not b.mhj.dis then b.mhj.cancelAlpha=b.mhj.alpha;b.mhj.dis=0 end
        b.colli=false;object.Preserve(b)
    end,
    kill=function(b)
        if not b.mhj.dis then b.mhj.cancelAlpha=b.mhj.alpha;b.mhj.dis=0 end
        b.colli=false;object.Preserve(b)
    end,
})
local function laserWidth(s)
    local p=profile(s.pattern,s.type)
    return max(0,s.wscale)*(p and p[3]>0 and p[3] or 18)*SCALE
end
local function laserColor(s)
    local p=profile(s.pattern,s.type)
    return ({2,4,6,10,12,14,16,8})[((p and p[8] or 0)%8)+1]
end
local function laserInit(b,s)
    s.is_projectile=true;b.mhj=s;b.bound=false;b.vx,b.vy=0,0
    s.age=0;s.rlongs=0;s.rwscale=s.wscale;s.laserGraze={count=0,grazed={}}
    b.IsLaser,b._inf_graze=true,true
    clearChanges(s);R.objects[b]=true;s.controller.bullets[b]=s
end
local function laserBirthSound(s)
    if s.age==1 and not s.controller.effectLayer and not s.controller.banLaser then
        R.sound((s.Ray=='Ray' or s.Ray==true) and s.type==8 and 'lazerwarning' or s.controller.laserSound or 'lazer00',s.fx-145)
    end
end
local function beamGrazeGrid(s)
    if s.life<=10 then return end
    local g=s.laserGraze
    if s.rlongs-g.count*5>0 then g.count=math.ceil(s.rlongs/5)
    else g.x,g.y,g.direction,g.ready=s.fx,s.fy,s.sonspeedd,g.count end
end
local function grazeBeam(b,s)
    if s.life<=2 or s.Invincible and s.age<20 or not valid(player.grazer) then return end
    local g=s.laserGraze
    if not g.ready or g.ready==0 then return end
    local px,py=R.player();local ca,sa=cos(g.direction),sin(g.direction)
    local dx,dy=px-g.x,py-g.y
    local along,across=dx*ca+dy*sa,dy*ca-dx*sa
    if across*across>980 then return end
    local reach=math.sqrt(980-across*across)
    for i=max(1,math.ceil((along-reach)/5)),min(g.ready,floor((along+reach)/5)) do
        if not g.grazed[i] then
            g.grazed[i]=true
            local x,y=projectBullet(g.x+i*5*ca,g.y+i*5*sa)
            player.grazer.class.colli(player.grazer,b,true,x,y)
        end
    end
end
local function laserStep(b)
    local s=b.mhj;s.age=s.age+1
    laserBirthSound(s)
    if s.age>s.life then clean(b);return end
    s.status,s.statusFrame=s.controller.status,s.controller.statusFrame
    if s.Sonevents then s.Sonevents(s,s.age,R) end
    interpolate(s)
    local dx,dy=motion(s,true,s.controller.slow or 1);s.fx,s.fy=s.fx+dx,s.fy+dy
    b.x,b.y=projectBullet(s.fx,s.fy);b.vx,b.vy=0,0
    b.w=laserWidth(s);b.alpha=max(0,min(1,(s.alpha or 100)/100));b.colli=not s.controller.effectLayer and s.wscale>=.5 and b.alpha>=1
    if s.controller.effectLayer then b.group,b.layer=GROUP.GHOST,s.controller.effectLayer end
    if s.Outdispel and (s.fx<118-s.longs or s.fx>844+s.longs or s.fy< -51-s.longs or s.fy>771+s.longs) then clean(b);return end
    return s
end
local advanceStraight=dofile('mod/GAME/ports/mhj/straight_laser.lua')(R,interpolate,{
    firstType=1,tailFrames=10,fadeEventsFirst=true,
    outside=function(s)
        return s.Outdispel and (s.fx<118-s.longs or s.fx>844+s.longs or s.fy< -51-s.longs or s.fy>771+s.longs)
    end,
})
R.classes.beam=Class(laser,{
    init=function(b,s)
        local x,y=projectBullet(s.fx,s.fy)
        laser.init(b,laserColor(s),x,y,-s.sonspeedd,0,max(1,s.longs*SCALE),0,laserWidth(s),0,0)
        laserInit(b,s)
    end,
    frame=function(b)
        local s=b.mhj;s.age=s.age+1
        beamGrazeGrid(s)
        s.status,s.statusFrame=s.controller.status,s.controller.statusFrame
        laserBirthSound(s)
        if advanceStraight(s) then clean(b);return end
        b.x,b.y=projectBullet(s.fx,s.fy);b.vx,b.vy=0,0
        b.rot,b.l2,b.w=-(s.head or s.sonspeedd),s.rlongs*SCALE,laserWidth(s)
        b.alpha=math.max(0,math.min(1,s.alpha/100));b.colli=false
        if s.controller.effectLayer then b.group,b.layer=GROUP.GHOST,s.controller.effectLayer end
        if not s.controller.effectLayer and not s.dis and s.age<=s.life and s.wscale>=.5 and s.alpha>99 and valid(player) then
            local px,py=R.player();local dir=s.sonspeedd
            local cx,cy=s.fx+s.rlongs*cos(dir)/2,s.fy+s.rlongs*sin(dir)/2
            local dx,dy=px-cx,py-cy;local ca,sa=cos(s.head),sin(s.head)
            local along,across=dx*ca+dy*sa,dy*ca-dx*sa
            local character=player.mhj_source and player.mhj_source.character
            local vulnerable=not cheat and player.protect<=0 and not player.hit and player.death<=0
                and not (character and character.Wudi)
            if vulnerable and s.rlongs>0 and along^2/(s.rlongs*3/8)^2+across^2/(s.wscale*1.5)^2<=1 then
                player.class.colli(player,b)
                if not s.Invincible then s.dis=true;s.age=s.life+1 end
            else
                grazeBeam(b,s)
            end
        elseif not s.controller.effectLayer and not s.dis and s.age<=s.life and s.alpha>99 and valid(player) then
            grazeBeam(b,s)
        end
    end,
    render=function(b)
        local s=b.mhj;local img,_,_,_,p=texture(s)
        if not p then return end
        local ray=s.Ray=='Ray' or s.Ray==true
        if ray and s.type==8 then
            loadTexture('warning')
            SetTextureSamplerState('mhj3_tex_warning','linear+wrap')
            local scale=.23076923;local from=(s.vspeed or 0)==0 and trunc(-s.age/scale) or -trunc(s.age*s.vspeed)
            local to=from+trunc(s.rlongs/scale)
            local co,si=cos(s.head),sin(s.head);local width=scale*s.wscale*SCALE
            local color=Color(s.alpha*2.55,s.colorR or 255,s.colorG or 255,s.colorB or 255)
            local function vertex(u,v)
                local side=(u-39.5)*width;local along=(v-from)*scale*SCALE
                return {b.x+co*along+si*side,b.y-si*along+co*side,.5,u,v,color}
            end
            RenderTexture('mhj3_tex_warning',s.Blend and 'mul+add' or '',vertex(0,from),vertex(78,from),vertex(78,to),vertex(0,to))
            return
        end
        if s.age<=s.life and (s.rlongs<s.longs and not s.alreadyLong or ray) then
            local mist=R.sprite('mhj3_laser_mist_'..p[8],'mist',p[8]*32,0,32,30,16,15)
            SetImageState(mist,'',204,s.colorR or 255,s.colorG or 255,s.colorB or 255)
            Render(mist,b.x,b.y,-s.age*5*(180/math.pi)^2,1.5*SCALE)
        end
        if ray then
            img=R.sprite('mhj3_ray_'..s.type,'barrages',(s.type-1)*18,1100,18,18,9,0)
            SetImageState(img,s.Blend and 'mul+add' or '',s.alpha*2.55,s.colorR or 255,s.colorG or 255,s.colorB or 255)
            Render(img,b.x,b.y,90-s.head,s.wscale*SCALE,s.rlongs/9*SCALE)
            return
        end
        SetImageCenter(img,p[3]/2,p[4])
        SetImageState(img,s.Blend and 'mul+add' or '',(s.alpha or 100)*2.55,s.colorR or 255,s.colorG or 255,s.colorB or 255)
        Render(img,b.x,b.y,-90-s.head,s.wscale*SCALE,s.rlongs*SCALE/p[4])
        SetImageCenter(img,p[5],p[6])
    end,
    del=function(b) b.mhj.dis=true;b.mhj.age=b.mhj.life+1;object.Preserve(b) end,
    kill=function(b) R.classes.beam.del(b) end,
})
R.classes.curve=Class(bent_laser,{
    init=function(b,s)
        local x,y=projectBullet(s.fx,s.fy)
        bent_laser.init(b,laserColor(s),x,y,max(4,(s.segment or 64)),laserWidth(s),4,0)
        laserInit(b,s)
    end,
    frame=function(b) if laserStep(b) then bent_laser.frame(b) end end,
    render=function(b)
        local s=b.mhj;local _,tex,x,y,p=texture(s);if not p then return end
        b.data:Render(tex,s.Blend and 'mul+add' or '',Color((s.alpha or 100)*2.55,s.colorR or 255,s.colorG or 255,s.colorB or 255),x,y,p[3],p[4])
    end,
    del=clean,kill=clean,
})
local function fairySprite(b,config,age)
    local n=floor(age/((config[19] or 6)+1))%max(1,config[7])
    local key=config[1];local name='mhj3_enemy_'..key..'_'..config[2]..'_'..config[3]..'_'..n
    R.sprite(name,key,config[2]+n*config[4],config[3],config[4],config[5],config[12],config[13])
    SetImageState(name,'',min(255,age*13),255,255,255)
    Render(name,b.x,b.y,0,config[16]*SCALE)
end
-- 147–150 是使魔槽位；它们沿用弹体轨迹，使用可受击的原生敌机对象。
R.classes.familiar=Class(enemy,{
    init=function(b,s,slot,config)
        enemybase.init(b,config[2]);b.mhj=s;s.familiar=slot;s.familiarConfig=config
        s.is_projectile=true;b.bound=false;b.vx,b.vy=0,0;b.layer=LAYER.ENEMY
        s.age=0;R.objects[b]=true;s.controller.bullets[b]=s;s.controller.familiars[slot]=b
        b.x,b.y=projectBullet(s.fx,s.fy);b.colli=false
        local p=D.enemyTypes[config[1]]
        local collision=NativeActorCollision or dofile('THlib/native_actor_collision.lua')
        collision.bind(b,p[14]/2*SCALE,p[15]/2*SCALE,'box',p[14]/7*SCALE,p[15]/7*SCALE,'ellipse',true).noContact=true
    end,
    frame=function(b)
        local s=b.mhj
        if b.hp<=0 then object.Kill(b);return end
        -- 使魔的底层仍是 Barrage，覆盖事件、状态帧与普通弹共用同一更新顺序。
        if not updateParticle(s) then
            -- 原作寿命耗尽写 NeedDeleteType.Dead，Familiar.Die 同样触发 BossCard 的使魔换段条件。
            s.killed=true;R.enemyDeathEffect(b,s.familiarConfig[1],s.familiarConfig[3]);clean(b);return
        end
        local t=s.age-(s.Mist and 15 or 0)
        b.x,b.y=projectBullet(s.fx,s.fy);b.vx,b.vy=0,0
        local collidable=s.age>=20 and t>0 and (s.alpha or 100)>99
        b.colli=collidable
        b.native_actor_collision.noContact=s.age<=60
        SetAttr(b,'colli',collidable)
    end,
    render=function(b) fairySprite(b,D.enemyTypes[b.mhj.familiarConfig[1]],b.mhj.age) end,
    del=clean,kill=function(b)
        R.enemyDeathEffect(b,b.mhj.familiarConfig[1],b.mhj.familiarConfig[3])
        b.mhj.killed=true;clean(b)
    end,
})
local function emit(o,bound)
    if o.unselected then return end
    local c=o.controller;local p=c.pattern;local rr=o.rand or {}
    local n=trunc((o.tiao or 1)+trunc(rnd(rr.tiao or 0,o)));if n<=0 then return end
    local ox,oy=c.offsetx,c.offsety
    local fx,fy=o.fx or o.x,o.fy or o.y
    if bound then fx,fy=bound.fx-ox,bound.fy-oy end
    local r=(o.r or 0)+trunc(rnd(rr.r or 0,o));local spread=(o.range or 0)+trunc(rnd(rr.range or 0,o))
    local baseRandom=rnd(rr.fdirection or 0,o)
    local radial=direction(o.rdirection,o,fx+ox,fy+oy,o.rdirections)+rnd(rr.rdirection or 0,o)
    local speed=(o.sonspeed or 0)+rnd(rr.sonspeed or 0,o);local accel=(o.sonaspeed or 0)+rnd(rr.sonaspeed or 0,o)
    local accelRandom=rnd(rr.sonaspeedd or 0,o)
    local ws,hs=rnd(rr.wscale or 0,o),rnd(rr.hscale or 0,o)
    local jx,jy=trunc(rnd(rr.fx or 0,o)),trunc(rnd(rr.fy or 0,o))
    local shotType=trunc(o.type)
    local slot=shotType-147
    local config=c.configs[slot]
    local bucket=o.bucket
    local origin={x=o.x+ox,y=o.y+oy,previewPlayer=c.visual and c.previewPlayer or nil}
    for i=0,n-1 do
        local fan=(i-(n-1)/2)*spread/n
        if not c.visual and R.bulletCount>=SOURCE_BULLET_CAP then R.overflow=R.overflow+1;return end
        local s=copy(o,not c.visual)
        s.type=shotType
        s.controller,s.pattern,s.bucket=c,p,bucket
        s.parentid,s.layerid=o.id,o.parentid
        if not c.visual then
            s.counted=true
            R.bulletCount=R.bulletCount+1
        end
        s.fx,s.fy=fx+r*cos(radial+fan)+jx+ox,fy+r*sin(radial+fan)+jy+oy
        -- 发射器的积分缓存不能传给弹体；否则静止发射器会把子弹的3.5速度覆盖成0。
        s.mx,s.my,s.ax,s.ay=nil,nil,nil,nil
        s.sonmotion_dirty,s.sonaccel_dirty=true,true
        s.sonspeed,s.sonaspeed=speed,accel
        local fd=o.sourceFdirection and o.sourceFdirection< -99997 and o.sourceFdirection or o.fdirection
        local ad=o.sourceAdirection and o.sourceAdirection< -99997 and o.sourceAdirection or o.sonaspeedd
        s.sonaspeedd=direction(ad,origin,s.fx,s.fy,o.sonaspeedds)+accelRandom
        s.sonspeedd=direction(fd,origin,s.fx,s.fy,o.fdirections)+baseRandom+fan+(o.Bindwithspeedd and bound and bound.sonspeedd or 0)
        s.wscale=(s.wscale or 1)+ws;s.hscale=o.syncScale and s.wscale or (s.hscale or 1)+hs
        c.serial=c.serial+1;s.serial=c.serial
        s.life=o.sonlife;s.age=0;s.head=(o.head or 0)+trunc(rnd(rr.head or 0,o))
        s.banSound=c.banSound or o.life<20 and o.shot
        local b
        if c.visual then
            b=s
            s.is_projectile,s.alive=true,true
            c.bullets[s]=s
            c.particles[#c.particles+1]=s
            c.drawDirty=true
        elseif o.kind=='laser' then b=New(s.Ray=='Curve' and R.classes.curve or R.classes.beam,s)
        elseif config then b=New(R.classes.familiar,s,slot,config)
        else b=New(R.classes.projectile,s) end
        if bucket then Bindings.add(bucket,b,s) end
        o.shot=true
    end
end
function R.fire(o)
    if o.bound_source then emit(o,o.bound_source)
    elseif o.bindid and o.bindid>=0 and (o.kind~='batch' or o.bindid~=o.id) then
        for _,pair in ipairs(bindingTargets(o)) do
            if targetable(o.controller,pair) then emit(o,pair[2]) end
        end
    else emit(o) end
end
function R.recover(o)
    local spec=o.spec
    if not spec then return end
    for _,key in ipairs({'fx','fy','r','rdirection','tiao','t','fdirection','range','speed','speedd','aspeed','aspeedd','life','type','wscale','hscale','alpha','head','sonspeed','sonspeedd','sonaspeed','sonaspeedd','xscale','yscale'}) do
        if spec[key]~=nil and (key~='fx' and key~='fy' or spec[key]>-99998) then set(o,key,spec[key]) end
    end
end
local bindingChildrenMode={__mode='k'}
local function emitter(spec,c,boundChild)
    local o=copy(spec);o.spec=spec.spec or spec;o.controller=c;o.host=c.host;o.pattern=c.pattern
    o.sourceFdirection=spec.sourceFdirection or spec.fdirection
    o.sourceAdirection=spec.sourceAdirection or spec.sonaspeedd
    -- 深绑定副本只由 step 推进，不再管理下一层 children；保留根发射器的绑定索引即可。
    o.children=not boundChild and setmetatable({},bindingChildrenMode) or nil
    -- Batch.Copy是浅拷贝，原EventRead的次数限制跨Totalframe循环保留。
    -- 只重置运动/插值状态；不能每轮重新启用括号(1)的开场事件。
    local key=spec.kind..':'..spec.parentid..':'..spec.id
    c.eventLimits[key]=c.eventLimits[key] or {};o.limits=c.eventLimits[key]
    local rr=o.rand
    if o.kind=='batch' then
        c.parents[o.parentid]=c.parents[o.parentid] or {}
        local layer=c.parents[o.parentid]
        layer[o.id]=layer[o.id] or Bindings.new()
        o.bucket=layer[o.id]
    end
    for _,key in ipairs({'speed','speedd','aspeed','aspeedd'}) do o[key]=(o[key] or 0)+rnd(rr[key] or 0,o) end
    if o.fx==-99998 then o.fx=o.x elseif o.fx==-99999 then o.fx=R.player(c.visual and o or nil) end
    if o.fy==-99998 then o.fy=o.y elseif o.fy==-99999 then local _,y=R.player(c.visual and o or nil);o.fy=y end
    o.speedd=direction(o.speedd,o,o.fx or o.x,o.fy or o.y,o.speedds)
    o.aspeedd=direction(o.aspeedd,o,o.fx or o.x,o.fy or o.y,o.aspeedds)
    return o
end
local function area(o,s,c,center)
    if s.layerid~=o.parentid then return false end
    if o.type==1 and s.parentid~=o.controlid-1 then return false end
    local x,y=o.x+c.offsetx,o.y+c.offsety
    if center then x,y=center.fx,center.fy end
    local dx,dy=s.fx-x,s.fy-y
    if o.degree and o.degree~=0 then
        local ca,sa=cos(o.degree),sin(o.degree)
        dx,dy=dx*ca+dy*sa,-dx*sa+dy*ca
    end
    if o.Circle then return dx*dx/max(1,o.halfw^2)+dy*dy/max(1,o.halfh^2)<=1 end
    return abs(dx)<=o.halfw and abs(dy)<=o.halfh
end
local function field(o,c,t)
    if o.unselected then return end
    if o.kind=='cover' then
        if not o.Sonevents then return end
        local layer=c.parents[o.parentid]
        local sources=o.bindid and o.bindid>=0 and layer and layer[o.bindid]
        local targetBucket=o.type==1 and layer and layer[o.controlid-1]
        local targets=targetBucket and targetBucket.members or c.bullets
        if o.type==1 and (not layer or not layer[o.controlid-1]) then return end
        local function contains(s)
            if not sources then return (not o.bindid or o.bindid<0) and area(o,s,c) end
            for b,center in pairs(sources.members) do
                if s~=center and live(c,b) and (not center.Mist or center.age>=15) and area(o,s,c,center) then return true end
            end
            return false
        end
        for b,s in pairs(targets) do
            if live(c,b) and s.Cover and (not s.Mist or s.age>15) and s.layerid==o.parentid then
                if s.kind~='laser' and contains(s) then
                    if not s.covers then s.covers,s.coverOrder={},{} end
                    local enter=s.covers[o]==nil
                    s.covers[o]=o.Sonevents
                    if enter then s.coverOrder[#s.coverOrder+1]=o end
                    if enter then s.maskEntered=1 end
                elseif s.covers and s.covers[o] then
                    s.covers[o]=nil
                    for i=#s.coverOrder,1,-1 do if s.coverOrder[i]==o then table.remove(s.coverOrder,i);break end end
                end
            end
        end
    elseif o.kind=='rebound' then
        -- Rebound 从端点出发，按下一帧相对位移检查交点；oneSide 取法线与位移的点积。
        local x,y=f32(o.x),f32(o.y)
        local ex,ey=f32(x+f32(o.longs*sourceCos(o.angle))),f32(y+f32(o.longs*sourceSin(o.angle)))
        local rx,ry=f32(ex-x),f32(ey-y)
        for b,s in pairs(c.bullets) do
          if s and s.layerid==o.parentid and s.Rebound and not s.dis and (not s.Mist or s.age>15) and ((s.reboundCount or 0)<o.time or o.time==0) and live(c,b) then
            local mx,my=s.mx or 0,s.my or 0;local ax,ay=s.ax or 0,s.ay or 0
            local nx=f32(s.fx+f32(f32(mx+ax)-(o.mx or 0)))
            local ny=f32(s.fy+f32(f32(my+ay)-(o.my or 0)))
            local dx,dy=f32(s.fx-nx),f32(s.fy-ny)
            local den=f32(f32(rx*dy)-f32(ry*dx))
            if den~=0 and (not o.oneSide or f32(f32(ry*f32(nx-s.fx))-f32(rx*f32(ny-s.fy)))<0) then
                local qx,qy=f32(nx-x),f32(ny-y)
                local u=f32(f32(f32(qx*dy)-f32(qy*dx))/den)
                local v=f32(f32(f32(qx*ry)-f32(qy*rx))/den)
                if u>=0 and u<=1 and v>=0 and v<=1 then
                    -- 按 Rebound.cs 原式逐项舍入；改用参数方程会改变近水平交点的原作轨迹。
                    local denominator=f32(f32(ry*dx)-f32(dy*rx))
                    local ix=f32(f32(f32(f32(f32(rx*dx)*f32(ny-y))+f32(f32(ry*dx)*x))-f32(f32(dy*rx)*nx))/denominator)
                    local iy=f32(f32(f32(f32(f32(ry*dy)*f32(nx-x))+f32(f32(rx*dy)*y))-f32(f32(dx*ry)*ny))/f32(-denominator))
                    s.sonspeedd=f32(2*o.angle-s.sonspeedd)
                    local distance=math.sqrt(f32(f32(f32(ix-nx)^2)+f32(f32(iy-ny)^2)))
                    local radiansValue=f32(f32(s.sonspeedd)*radians)
                    s.fx=f32(ix+f32((s.xscale or 1)*f32(distance*math.cos(radiansValue))))
                    s.fy=f32(iy+f32((s.yscale or 1)*f32(distance*math.sin(radiansValue))))
                    s.mx=f32((s.xscale or 1)*f32((s.sonspeed or 0)*sourceCos(s.sonspeedd)))
                    s.my=f32((s.yscale or 1)*f32((s.sonspeed or 0)*sourceSin(s.sonspeedd)));s.sonmotion_dirty=false
                    s.reboundCount=(s.reboundCount or 0)+1
                    if o.Parentevents then
                        o.Parentevents(s,t,R)
                        -- 原作反弹事件在碰撞处立即写入，不延迟到弹体积分后。
                        interpolate(s)
                    end
                end
            end
        end end
    elseif o.kind=='force' then
        for b,s in pairs(c.bullets) do if live(c,b) and s.Force and area(o,s,c) then
            local a=o.addaspeedd or 0
            if o.Suction or o.Repulsion then a=angle(s.fx,s.fy,o.x+c.offsetx,o.y+c.offsety)+(o.Repulsion and 180 or 0) end
            s.mx=(s.mx or 0)+(o.addaspeed or 0)*cos(a);s.my=(s.my or 0)+(o.addaspeed or 0)*sin(a)
        end end
    end
end
local function reset(c)
    for _,e in ipairs(c.emitters or {}) do e.active=false end
    c.emitters={};c.center=copy{fx=c.pattern.center[1],fy=c.pattern.center[2],speed=c.pattern.center[3],speedd=c.pattern.center[4],aspeed=c.pattern.center[5],aspeedd=c.pattern.center[6],is_center=true,host=c.host}
    if c.visual then c.center.ox,c.center.oy=c.originX,c.originY end
    for _,spec in ipairs(c.pattern.emitters) do c.emitters[#c.emitters+1]=emitter(spec,c) end
end
function R.controller(host,id,road,configs)
    local p=R.loadPattern(id)
    prepareStates()
    local c={host=host,pattern=p,road=road,time=0,offsetx=0,offsety=0,bullets=setmetatable(allocateTable(0,road and 128 or SOURCE_BULLET_CAP),{__mode='k'}),jumps={},eventLimits={},serial=0,status=0,statusFrame=0,configs=configs or {},familiars={},deadFamiliars={},parents={}}
    c.usekira,c.banSound,c.banLaser,c.laserSound=p.audio and p.audio.useKira,p.audio and p.audio.banSound,p.audio and p.audio.banLaser,p.audio and p.audio.laserSound
    reset(c);R.controllers[c]=true;return c
end
function R.backgroundEffect(id,x,y,seed,textureHeights,resources,previewPlayer)
    local p=R.patterns[id]
    if not p then
        p=dofile('mod/GAME/th39/scenes/'..id..'.lua')
        R.patterns[id]=p
    end
    p.audio=patternAudio[id]
    local c={pattern=p,visual=true,road=true,originX=x,originY=y,seed=seed,previewPlayer=previewPlayer,
        textureHeights=textureHeights,resources=resources,time=0,offsetx=0,offsety=0,
        bullets={},particles={},jumps={},eventLimits={},serial=0,status=0,statusFrame=0,
        configs={},familiars={},deadFamiliars={},parents={},drawList={}}
    reset(c)
    return c
end
function R.tick(c)
    if c.closed then return end
    local reserved=#stateReserve
    c.time=c.time+1;c.statusFrame=c.statusFrame+1
    if c.time>c.pattern.total then c.time=1;reset(c) end
    local t=c.time;local center=c.center
    if c.pattern.globalEvents then c.pattern.globalEvents(c,t,R) end
    t=c.time
    if not c.visual then
        if valid(c.host) then center.ox,center.oy=unproject(c.host)
        else center.ox,center.oy=center.fx,center.fy end
    end
    center.controller=c;center.status,center.statusFrame=c.status,c.statusFrame
    if c.pattern.centerAvailable then
        local dx,dy=motion(center,false)
        center.ox,center.oy=center.ox+dx,center.oy+dy
    end
    c.pattern.centerEvents(center,t,R)
    if c.pattern.audio then c.pattern.audio.centerEvents(center,t,R) end
    interpolate(center)
    stepControl(c)
    if c.pattern.centerAvailable then
        if valid(c.host) and not c.road then c.host.x,c.host.y=projectBullet(center.ox,center.oy) end
        c.offsetx,c.offsety=center.ox-center.fx,center.oy-center.fy
    else c.offsetx,c.offsety=0,0 end
    c.targets=bindingTargets
    local function step(o,ot,bound)
        o.active=ot>=1 and ot<=o.life
        if not o.active then return end
        if o.kind~='rebound' then o.time=ot end
        o.status,o.statusFrame=c.status,c.statusFrame
        local mx,my=motion(o,false);o.x,o.y=o.x+mx,o.y+my
        if o.fx then o.fx=o.fx+mx end;if o.fy then o.fy=o.fy+my end
        o.bound_source=bound
        if o.kind~='rebound' and o.Parentevents then o.Parentevents(o,ot,R) end
        interpolate(o)
        if o.kind=='batch' or o.kind=='laser' then
            if o.t>0 and ot%o.t+trunc(rnd(o.rand.t or 0,o))==0 then
                if bound then emit(o,bound)
                elseif o.bindid and o.bindid>=0 and (o.kind~='batch' or o.bindid~=o.id) then
                    for _,pair in ipairs(bindingTargets(o)) do
                        if targetable(c,pair) then emit(o,pair[2]) end
                    end
                else emit(o) end
            end
        else field(o,c,ot) end
    end
    for _,o in ipairs(c.emitters) do
        if o.Deepbind and o.bindid and o.bindid>=0 and (o.kind~='batch' or o.bindid~=o.id) then
            for _,pair in ipairs(bindingTargets(o)) do if targetable(c,pair) then
                local child=o.children[pair[1]]
                if not child then
                    child=emitter(o,c,true);child.bindid=-1;child.Deepbind=false;child.limits={};child.localTime=0
                    o.children[pair[1]]=child
                else
                    child.localTime=child.localTime+1
                    child.x,child.y=pair[2].fx-c.offsetx,pair[2].fy-c.offsety
                    child.fx,child.fy=child.x,child.y
                    step(child,child.localTime-(child.begin or 1)+1,pair[2])
                end
            end end
        else step(o,t-(o.begin or 1)+1) end
    end
    -- 原作预置 BarragePool。这里分帧补充尚未使用的新状态，绝不复用仍可能被绑定引用的旧弹体。
    -- 集中生成帧只消耗储备，不在同帧补分配；储备不足仍按原规则完整发弹。
    if not c.visual and reserved-#stateReserve<RESERVE_REFILL*2 then refillStates(RESERVE_REFILL) end
end
function R.tickBackground(c)
    if not c.closing then R.tick(c) end
    local list,n=c.particles,0
    for i=1,#list do
        local s=list[i]
        if updateParticle(s) and not outOfBounds(s) then
            if s.drawLayer~=s.layerid or s.drawBlend~=s.Blend then
                c.drawDirty=true;s.drawLayer,s.drawBlend=s.layerid,s.Blend
            end
            n=n+1;list[n]=s
        else
            c.drawDirty=true
            s.alive=false
            c.bullets[s]=nil
            Bindings.remove(s.bucket,s)
        end
    end
    for i=#list,n+1,-1 do list[i]=nil end
end

function R.prepareBackground(c)
    loadTexture('barrages')
    loadTexture('bosses')
    if not CheckRes('img','mhj3_original_aura') then
        globalResource(function()
            LoadTexture('mhj3_original_aura','Resources/th39/hud/bosslist.png')
            LoadImage('mhj3_original_aura','mhj3_original_aura',316,280,640,640)
            SetImageCenter('mhj3_original_aura',320,320)
        end)
    end
    local base=#D.bulletTypes
    for i in ipairs(c.pattern.types) do
        texture({pattern=c.pattern,type=base+i,age=0,controller=c})
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
end
function R.prepareFamiliars(configs)
    for _,config in pairs(configs) do loadTexture(D.enemyTypes[config[1]][1]) end
end
local sharedSpritesPrepared=false
local preparedPatterns={}
function R.preparePattern(id)
    if preparedPatterns[id] then return end
    prepareStates()
    local pattern=R.loadPattern(id);local context={}
    for _,name in ipairs({'kira','tan','lazer00','ch02','cat'}) do audio.prepare(name) end
    if pattern.audio then
        -- 原弹幕表保留 tan00.wav 等未注册的表项，不是音效库中的 cue。
        -- 预加载只收集已注册资源；真正播放仍由 audio.play/prepare 严格检查。
        for _,name in pairs(pattern.audio.sounds) do if audio.hasCue(name) then audio.prepare(name) end end
        if audio.hasCue(pattern.audio.laserSound) then audio.prepare(pattern.audio.laserSound) end
    end
    loadTexture('barrages');loadTexture('bosses')
    -- 原作的公共弹型在战斗前已就绪，公共动画也提前建立切片，避免中途换型时卡住绘制。
    if not sharedSpritesPrepared then
        for i,p in ipairs(D.bulletTypes) do for frame=0,max(1,p[9] or 1)-1 do
            texture({pattern=pattern,type=i,age=frame*(1+(p[10] or 0)),controller=context})
        end end
        sharedSpritesPrepared=true
    end
    -- 原作进入战斗前载入自定义贴图；阶段切换和动画换帧不再临时读取 PNG、创建切片。
    for i,p in ipairs(pattern.types) do
        for frame=0,max(1,p[9] or 1)-1 do
            texture({pattern=pattern,type=#D.bulletTypes+i,age=frame*(1+(p[10] or 0)),controller=context})
        end
    end
    preparedPatterns[id]=true
end
local function visualOrder(a,b)
    if a.layerid~=b.layerid then return a.layerid<b.layerid end
    if a.Blend~=b.Blend then return not a.Blend end
    if a.pattern.order==1 then return a.serial>b.serial end
    return a.serial<b.serial
end
local backgroundWhite={255,255,255,1}
local function backgroundVisible(p,x,y,rot,hs,vs,w,scale)
    local ca,sa=cos(rot),sin(rot)
    hs,vs=hs*scale,vs*scale
    local ox,oy=(p[3]/2-p[5])*hs,(p[6]-p[4]/2)*vs
    local cx,cy=x+ox*ca-oy*sa,y+ox*sa+oy*ca
    local hx,hy=(abs(ca*hs)*p[3]+abs(sa*vs)*p[4])/2,(abs(sa*hs)*p[3]+abs(ca*vs)*p[4])/2
    return cx+hx>=w.l-.01 and cx-hx<=w.r+.01 and cy+hy>=w.b-.01 and cy-hy<=w.t+.01
end
function R.drawBackground(c,opacity,dx,dy)
    local list=c.drawList
    -- 运动与透明度不改变这里的排序键，只在成员或排序键变化时重排。
    if c.drawDirty~=false or c.drawOrder~=c.pattern.order then
        for i,s in ipairs(c.particles) do list[i]=s end
        for i=#list,#c.particles+1,-1 do list[i]=nil end
        table.sort(list,visualOrder);c.drawDirty=false;c.drawOrder=c.pattern.order
    end
    local function project(x,y)
        local px,py=projectBullet(x,y)
        return px+(dx or 0),py+(dy or 0)
    end
    local masks=Mask.layers(c,project)
    local world=lstg.world
    local offset=lstg.worldoffset
    if offset then
        local hx,hy=abs((world.r-world.l)/offset.hscale/2),abs((world.t-world.b)/offset.vscale/2)
        local x,y=offset.centerx-offset.dx/offset.hscale,offset.centery-offset.dy/offset.vscale
        world={l=x-hx,r=x+hx,b=y-hy,t=y+hy}
    end
    local imageScale=GetImageScale and GetImageScale() or 1
    local rgb=c.color or backgroundWhite
    for _,s in ipairs(list) do
        local alpha=(s.alpha or 100)*.01*opacity*(s.Mist and min(1,s.age/15) or 1)
        if alpha>0 and s.type>0 then
            local p=profile(s.pattern,s.type)
            local light=rgb[4] or 1
            local a,r,g,b=min(255,alpha*255),s.colorR or 255,s.colorG or 255,s.colorB or 255
            r,g,b=min(255,r*rgb[1]*light/255),min(255,g*rgb[2]*light/255),min(255,b*rgb[3]*light/255)
            local x,y=project(s.fx,s.fy)
            local rot=-((s.Withspeedd and math.deg(math.atan2(s.my or 0,s.mx or 0)) or s.head or 0)+90)
            local hs,vs=s.wscale*SCALE,s.hscale*SCALE
            local layerMasks=masks[s.layerid]
            local scale=layerMasks and #layerMasks>0 and 1 or imageScale
            -- 只裁去整个图像都在视口外的提交，保留对象更新和遮罩事件。
            if not p or backgroundVisible(p,x,y,rot,hs,vs,world,scale) then
                local img,tex,u,v,profile=texture(s)
                local blend=s.Blend and 'mul+add' or ''
                if tex and layerMasks and #layerMasks>0 then
                    local color=Color(a,r,g,b)
                    local ca,sa=cos(rot),sin(rot)
                    local w,h=profile[3],profile[4]
                    local function vertex(px,py)
                        local dx,dy=(px-profile[5])*hs,(profile[6]-py)*vs
                        return {x+dx*ca-dy*sa,y+dx*sa+dy*ca,.5,u+px,v+py,color}
                    end
                    Mask.draw(layerMasks,tex,blend,{vertex(0,0),vertex(w,0),vertex(w,h),vertex(0,h)})
                else
                    SetImageState(img,blend,a,r,g,b)
                    Render(img,x,y,rot,hs,vs)
                end
            end
        end
    end
end

function R.jump(c,index,count,target)
    c.jumps[index]=(c.jumps[index] or 0)+1
    if count==0 or c.jumps[index]<=count then c.time=target end
end
function R.quake(c,duration,level)
    if c.visual then
        if c.onQuake then c.onQuake(duration,level) end
    elseif misc and misc.ShakeScreen then misc.ShakeScreen(duration,level/8) end
end
function R.slow(c,duration,mode,t,start)
    local elapsed=t-start+1
    c.slow=1
    if duration==0 or elapsed<=duration then
        c.slow=mode==1 and .01 or max(.01,.5+.5*max(0,(elapsed/max(1,duration)-.8)/.2)^3)
    end
end
function R.clear(c)
    if not c then return end
    if c.playerStatus and R.sourceStatusClear then R.sourceStatusClear();c.playerStatus=nil end
    releaseControl(c);R.controllers[c]=nil
    for b in pairs(c.bullets) do
        if valid(b) then clean(b) end
    end
    c.closed=true;c.emitters={};c.parents={}
end
function R.replace(c,host,id,road,configs)
    -- 同一符卡内的时间/血量/使魔阈值只替换弹幕，不解除自机控制或石化。
    -- BossCard 在整张卡结束时才调用 FreeControl / ClearNegativeStatus。
    local status,control=c and c.playerStatus,c and c.control
    if c then c.playerStatus,c.control=nil,nil;R.clear(c) end
    local next=R.controller(host,id,road,configs)
    next.playerStatus,next.control=status,control
    return next
end
function R.stopEmitter(c)
    if c then releaseControl(c);c.closed=true;c.emitters={};R.controllers[c]=nil end
end
local deathHeights
local DeathEffect=Class(object,{
    init=function(o,p)
        deathHeights=deathHeights or dofile('mod/GAME/th39/scenes/death.lua')
        o.group,o.bound,o.colli,o.layer=GROUP.GHOST,false,false,LAYER.TOP-1
        o.effects={};local x,y=R.player()
        for _,id in ipairs(p.hitWindow==60 and {'e80','e82'} or {'e79','e81'}) do
            local c=R.backgroundEffect(id,x,y,7919,deathHeights,{tex={},img={}})
            c.status=({reimu=0,marisa=1,sanae=2,mokou=3})[p.machine.art]
            o.effects[#o.effects+1]=c
        end
        R.objects[o]=true
    end,
    frame=function(o)
        local alive=false
        for _,c in ipairs(o.effects) do
            if c.time>=c.pattern.total then c.closing=true end
            R.tickBackground(c);if not c.closing or #c.particles>0 then alive=true end
        end
        if not alive then R.objects[o]=nil;object.RawDel(o) end
    end,
    render=function(o) for _,c in ipairs(o.effects) do R.drawBackground(c,1,0,0) end end,
},true)
function R.playerDeathEffect(p) New(DeathEffect,p) end
local enemyDeathHeights
local EnemyDeathEffect=Class(object,{
    init=function(o,p,type,effect)
        o.source_enemy_death=true
        enemyDeathHeights=enemyDeathHeights or dofile('mod/GAME/th39/scenes/enemy_death.lua')
        o.group,o.bound,o.colli,o.layer=GROUP.GHOST,false,false,LAYER.PLAYER_BULLET-1
        local s=p.mhj;local config=D.enemyTypes[type or s.type]
        local familiar=s.familiarConfig
        local id=effect and effect>0 and effect or config[17]
        o.effect=R.backgroundEffect('e'..id,familiar and s.fx or s.x,familiar and s.fy or s.y,7919,enemyDeathHeights,{tex={},img={}})
        if familiar and familiar[6]==1 then o.layer=LAYER.TOP end
        o.speed,o.direction,o.motionX,o.motionY=familiar and s.sonspeed or s.speed or 0,familiar and s.sonspeedd or s.speedf or 0,0,0
        R.objects[o]=true
    end,
    frame=function(o)
        local c=o.effect
        o.speed=o.speed-o.speed/30;o.motionX,o.motionY=o.motionX+o.speed*cos(o.direction),o.motionY-o.speed*sin(o.direction)
        if c.time>=c.pattern.total then c.closing=true end
        R.tickBackground(c)
        if c.closing and #c.particles==0 then R.objects[o]=nil;object.RawDel(o) end
    end,
    render=function(o) R.drawBackground(o.effect,1,o.motionX*SCALE,o.motionY*SCALE) end,
},true)
function R.enemyDeathEffect(p,type,effect) return New(EnemyDeathEffect,p,type,effect) end
local sourceEffectHeights=dofile('mod/GAME/th39/scenes/pattern_effect_textures.lua')
for name,height in pairs(dofile('mod/GAME/th39/scenes/presentation.lua').textureHeights) do sourceEffectHeights[name]=height end
local SourceEffect=Class(object,{
    init=function(o,host,id,background,stick)
        o.owner,o.stick,o.startX,o.startY=host,stick,host.x,host.y
        o.group,o.bound,o.colli=GROUP.GHOST,false,false
        o.layer=background and LAYER.PLAYER_BULLET+.01 or LAYER.ENEMY_BULLET-.01
        local x,y=unproject(host)
        o.effect=R.backgroundEffect('e'..id,x,y,7919,sourceEffectHeights,{tex={},img={}})
        o.effect.gatherHost=host
        o.motionX,o.motionY=0,0;R.objects[o]=true
    end,
    frame=function(o)
        local c=o.effect
        if not o.fixed and valid(o.owner) then
            if o.stick then o.motionX,o.motionY=o.owner.x-o.startX,o.owner.y-o.startY
            else c.originX,c.originY=unproject(o.owner);c.center.ox,c.center.oy=c.originX,c.originY end
        end
        if c.time>=c.pattern.total then c.closing=true end
        R.tickBackground(c)
        if c.closing and #c.particles==0 then R.objects[o]=nil;object.RawDel(o) end
    end,
    render=function(o) R.drawBackground(o.effect,1,o.motionX,o.motionY) end,
},true)
function R.gather(center,...)
    local host=center.host or center.controller.gatherHost
    assert(valid(host),'原作 Gather 缺少 Boss 实例')
    local n=select('#',...);local a={...}
    local animation,effect,background,stick,sound,frames=nil,nil,false,true,nil,0
    if n==0 then effect,sound='100','ch02'
    elseif n==2 then animation,frames=a[1],a[2]
    elseif n==3 then effect,background,stick=a[1],a[2],a[3]
    elseif n==5 then animation,effect,background,stick,frames=a[1],a[2],a[3],a[4],a[5]
    elseif n==6 then animation,effect,background,stick,sound,frames=unpack(a)
    else error('原作 Gather 参数数量不支持：'..n) end
    local state={animation=animation,frames=frames,left=frames,sound=sound,pending=true}
    if effect and effect~='' then state.effect=New(SourceEffect,host,effect,background,stick) end
    host.mhj3_gather=state
    if sound and sound~='' then R.sound(sound,host.x/SCALE+336) end
end
function R.spellWarning(host)
    local o=New(SourceEffect,host,'901',false,false)
    o.fixed=true
    local c=o.effect
    c.originX,c.originY=481,350;c.center.ox,c.center.oy=481,350
    c.status,c.statusFrame=5,0
    return o
end
function R.endGather(host)
    local g=host.mhj3_gather
    if not g then return end
    if valid(g.effect) then g.effect.effect.closing=true end
    if g.sound and g.sound~='' and g.frames>0 then R.stopSound(g.sound) end
    host.mhj3_gather=nil
end
function R.deathClear(x,y,r)
    for b in pairs(R.objects) do
        local s=b.mhj
        if valid(b) and s and s.is_projectile and not s.Invincible and not s.controller.indestructible
            and b.group~=GROUP.INDES and Dist(x,y,b.x,b.y)<r and not s.dis then Del(b) end
    end
end
function R.deathDamage(x,y,r,damage)
    for b in pairs(R.objects) do
        local s=b.mhj
        if valid(b) and s and not s.is_projectile and b.colli and not b.protect and Dist(x,y,b.x,b.y)<r then b.hp=b.hp-damage end
    end
end
function R.clearAll()
    audio.clear()
    for c in pairs(R.controllers) do R.clear(c) end
    for b in pairs(R.objects) do if valid(b) then clean(b) end end
    R.bulletCount=0
    if R.sourceViewReset then R.sourceViewReset() end
end
-- 道中敌机的时钟、复制模板和目标标签来自 StageManager。
local function range(value)
    local base,spread=value:match('^(.-)%+(.+)$')
    return tonumber(base or value) or base or value,tonumber(spread) or 0
end
local function randomValue(value)
    local base,spread=range(value)
    return spread==0 and base or base+ran:Float(0,1)*spread
end
local function playerAim(x,y)
    local px,py=R.player()
    return angle(x,y,px-145,py)
end
local function enemyEvent(o,s,e,t)
    if t<e.at or t>=e.at+e.duration then return end
    local host=e.key=='hp' and o or s
    if e.origin==nil then
        e.origin=host[e.key]
        if e.value=='自机' then e.target=playerAim(s.x,s.y)
        elseif e.relative then e.target=e.origin+e.value
        else e.target=e.value end
        if e.spread~=0 then e.target=e.target+ran:Float(0,1)*e.spread end
    end
    if e.mode==1 then host[e.key]=host[e.key]+(e.target-e.origin)/e.duration
    elseif e.mode==2 then host[e.key]=e.target
    else host[e.key]=e.origin+(e.target-e.origin)*sin(360*t/e.duration) end
end
R.classes.fairy=Class(enemy,{
    init=function(o,state,spec)
        enemybase.init(o,spec.hp)
        local s=copy(spec);o.mhj=s;s.age=0
        s.events={};for i,e in ipairs(spec.events) do s.events[i]=copy(e) end
        o.bound=false;o.vx,o.vy=0,0;o.group=GROUP.ENEMY;o.layer=LAYER.ENEMY;o.colli=false
        o.x,o.y=R.project(s.x,s.y);o.maxhp=spec.hp
        local p=D.enemyTypes[s.type]
        local collision=NativeActorCollision or dofile('THlib/native_actor_collision.lua')
        collision.bind(o,p[14]/2*SCALE,p[15]/2*SCALE,'box',p[14]/7*SCALE,p[15]/7*SCALE,'ellipse',true)
        s.controller=s.pattern and R.controller(o,s.pattern,true,state.familiars) or nil
        state.enemies[spec.id]=o;R.objects[o]=true
    end,
    frame=function(o)
        local s=o.mhj
        local c=s.controller
        if s.deadCondition and c then
            local dead=0
            for _,n in pairs(c.deadFamiliars) do dead=dead+n end
            if dead>=s.deadCondition then o.hp=0 end
        end
        if o.hp<=0 then object.Kill(o);return end
        if s.age>=s.life then object.Del(o);return end
        for _,e in ipairs(s.events) do enemyEvent(o,s,e,s.age) end
        s.x,s.y=s.x+s.speed*cos(s.speedf),s.y+s.speed*sin(s.speedf);s.age=s.age+1
        local collidable=s.age>max(s.noharm or 0,s.hide or 0,30) and not s.underneath
        o.colli=collidable;SetAttr(o,'colli',collidable);o.layer=s.underneath and LAYER.ENEMY-2 or LAYER.ENEMY
        if c and s.age>=s.delay then R.tick(c) end
        o.x,o.y=R.project(s.x,s.y);o.vx,o.vy=0,0
    end,
    render=function(o)
        local s=o.mhj
        if s.age>(s.hide or 0) then fairySprite(o,D.enemyTypes[s.type],s.age) end
    end,
    kill=function(o)
        local s=o.mhj;R.stopEmitter(s.controller)
        R.enemyDeathEffect(o)
        if s.items and not s.mana then R.sound('enep00',o.x*1.5+336) end
        if not s.mana then
            local config=D.enemyTypes[s.type]
            if NativePlayers and NativePlayers.enabled(nil,37) then
                NativePlayers.drop(37,o.x,o.y,s.items,false,false,max(config[14],config[15]))
            elseif s.items and item and item.DropItem then item.DropItem(o.x,o.y,{tonumber(s.items[2]),tonumber(s.items[4]),0}) end
        end
        clean(o)
    end,
    del=function(o) R.stopEmitter(o.mhj.controller);clean(o) end,
})
function R.stageState(stage)
    return {stage=stage,enemies={},templates={},labels={},familiars={},id=0}
end
local function target(s,label)
    local id=label and s.labels[label] or s.current
    local o=s.enemies[id]
    if valid(o) then return o end
end
local function spawn(s,spec,label)
    s.id=s.id+1;spec.id=s.id;s.current=spec.id;s.templates[spec.id]=spec
    if label then s.labels[label]=spec.id end
    if not s.preroll then New(R.classes.fairy,s,spec) end
end
local function setMotion(spec)
    spec.speed=randomValue(spec.speedSource)
    local base,spread=range(spec.directionSource)
    if base=='自机' then base=playerAim(spec.x,spec.y) end
    spec.speedf=base+(spread==0 and 0 or ran:Float(0,1)*spread)
end
function R.stage_SetEnemy(s,kind,x,y,speed,dir,life,hp,pattern,delay,label)
    local spec={type=trunc(randomValue(kind)),x=randomValue(x),y=randomValue(y),life=tonumber(life),
        hp=tonumber(hp),pattern=pattern~='-1' and tostring(s.stage)..pattern or nil,
        delay=trunc(randomValue(delay or '0')),speedSource=speed,directionSource=dir,events={}}
    setMotion(spec);spawn(s,spec,label)
end
function R.stage_CopyEnemy(s,x,y,delay,relative,count,label)
    local id=label and s.labels[label] or s.current
    local base=s.templates[id]
    if not base or not s.preroll and not target(s,label) then return end
    local spec=copy(base)
    spec.x,spec.y=x=='nul' and base.x or randomValue(x),y=='nul' and base.y or randomValue(y)
    spec.delay=trunc(randomValue(delay or '0'));spec.events={}
    setMotion(spec)
    for i,e in ipairs(base.events) do
        if count~='all' and i>(tonumber(count) or 0) then break end
        local event=copy(e)
        event.relative=relative=='true' and event.value~='自机'
        spec.events[#spec.events+1]=event
    end
    spawn(s,spec)
end
function R.stage_AddEvent(s,at,key,value,duration,mode)
    local spec=s.templates[s.current]
    if not spec then return end
    local base,spread=range(value)
    local e={at=tonumber(at),key=key,value=base,spread=spread,duration=max(1,tonumber(duration)),mode=tonumber(mode)}
    spec.events[#spec.events+1]=e
    local o=target(s)
    if o then o.mhj.events[#o.mhj.events+1]=copy(e) end
end
local function stageField(s,k,v)
    local spec=s.templates[s.current]
    if spec then spec[k]=v end
    local o=target(s)
    if o then o.mhj[k]=v end
end
function R.stage_SetNoHarmTime(s,n) stageField(s,'noharm',tonumber(n)) end
function R.stage_SetHideTime(s,n) stageField(s,'hide',tonumber(n)) end
function R.stage_SetEnemyItems(s,...) stageField(s,'items',{...}) end
function R.stage_SetEnemyUnderneath(s) stageField(s,'underneath',true) end
function R.stage_SetEnemyDeadCondition(s,n) stageField(s,'deadCondition',tonumber(n)) end
function R.stage_SetEnemyBarrageDispel(s,n) stageField(s,'highlightDispel',n=='1') end
function R.stage_BindFamiliar(s,slot,kind,hp)
    s.familiars[max(1,min(4,tonumber(slot)))]={tonumber(kind),tonumber(hp)}
end
function R.stage_PauseByEnemy(s,label) s.waitEnemy=target(s,label) end
function R.stage_Pause(s,time) s.pause=tonumber(time) end
function R.stage_Goto(s,t) s.gotoTick=t end
R.data=D
return R
