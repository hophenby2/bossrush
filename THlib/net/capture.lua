-- 将房主的逻辑绘制指令发送给另一端，避免两种原生引擎分别模拟而发生弹幕分歧。
-- 接收端只分派固定白名单的绘制/资源 API，绝不执行对方提供的 Lua。
local N=assert(GameNet)
local W=assert(NetCodec)
local C={raw={},states={},registry={},properties={},targets={},version=0,serial=0,context=nil,MAX_CALLS=40000,audio={},music={}}
local unpack=unpack
local function args(...) return {n=select('#',...),...} end
local function copy(v,depth)
    if type(v)~='table' then return v end
    assert((depth or 0)<12,'绘制状态层次过深');local out={}
    for k,value in pairs(v) do out[k]=copy(value,(depth or 0)+1) end;return out
end
local drawNames={'Render','RenderRect','Render4V','RenderAnimation','RenderTexture','RenderTTF','RenderTTF2','RenderText',
    'RenderClear','PushRenderTarget','PopRenderTarget','PostEffect','PostEffectCapture','PostEffectApply',
    'SetImageScale','SetFog','SetViewMode','Set2D','Set3Dwithmode','SetOrtho','SetPerspective','SetViewport','SetScissorRect','SetWorldFlag','ClearZBuffer','SetZBufferEnable'}
local resources={'LoadTexture','LoadImage','LoadAnimation','LoadPS','LoadFont','LoadTTF','LoadFX','CopyImage','CopyAnimation','CreateRenderTarget',
    'SetImageCenter','SetAnimationCenter','SetTextureSamplerState','SetAnimationScale','LoadSound','LoadMusic'}
local op,byId={},{}
for _,name in ipairs(drawNames) do op[name]=#byId+1;byId[#byId+1]=name end
op.Default=#byId+1;byId[#byId+1]='Default'
op.Bent=#byId+1;byId[#byId+1]='Bent'
local resourceOps={};for _,name in ipairs(resources) do resourceOps[name]=true end
local function safePath(path)
    assert(type(path)=='string' and #path<=256,'资源路径无效')
    path=path:gsub('\\','/');assert(not path:find('..',1,true) and not path:find(':',1,true) and path:sub(1,1)~='/','资源路径越界')
    assert(path:match('^THlib/') or path:match('^Resources/') or path:match('^mod/') or path:match('^shader/') or path:match('^music/'),'只能加载游戏资源')
end
local function key(name,a) return name..':'..tostring(a[1]) end
local function resource(name,a)
    local k=key(name,a);local encoded=W.encode(a)
    local old=C.registry[k]
    if old and old.signature==encoded then return end
    C.serial=C.serial+1;C.version=C.version+1
    C.registry[k]={name=name,params=copy(a),signature=encoded,order=C.serial,version=C.version,pool=GetResourceStatus and GetResourceStatus() or 'global'}
end
local function state(kind,name,blend,a,r,g,b)
    local previous=C.states[kind..':'..name] or {'',255,255,255,255}
    if a~=nil and type(a)~='number' then a,r,g,b=a:ARGB() end
    if (blend or '')==previous[1] and (a==nil or (a==previous[2] and (r or 255)==previous[3] and (g or 255)==previous[4] and (b or 255)==previous[5])) then C.states[kind..':'..name]=previous;return end
    if a~=nil then
        if type(a)=='number' then previous={blend or '',a,r or 255,g or 255,b or 255}
        else local A,R,G,B=a:ARGB();previous={blend or '',A,R,G,B} end
    else previous={blend or '',previous[2],previous[3],previous[4],previous[5]} end
    C.states[kind..':'..name]=previous
end
local function emit(name,a,style,metadata)
    if not C.active or C.suppress then return end
    assert(#C.calls<C.MAX_CALLS,'本帧绘制指令过多')
    local owner=C.context
    if owner then owner.index=owner.index+1 end
    local call={op[name],owner and owner.slot or 0,owner and owner.role or 0,owner and owner.uid or 0,owner and owner.index or #C.calls+1,a,style}
    if metadata then call[8]=metadata;call.n=8 end;C.calls[#C.calls+1]=call
end
local function fade(slot) return slot>0 and slot~=(N.role=='client' and 2 or 1) and N.alpha or 1 end
local function setStyle(kind,name,s,factor)
    if not s then return end
    local fn=kind=='ani' and C.raw.OriginalSetAnimationState or kind=='font' and C.raw.OriginalSetFontState or C.raw.OriginalSetImageState
    if fn then fn(name,s[1],Color(math.max(0,math.min(255,s[2]*(factor or 1))),s[3],s[4],s[5])) end
end
local function camera()
    return {world=copy(lstg.world),offset=copy(lstg.worldoffset),view=copy(lstg.view3d),billboard=copy(lstg.viewbillboard)}
end
local function imageKind(name)
    if CheckRes('ani',name) then return 'ani' elseif CheckRes('psi',name) then return 'psi' end;return 'img'
end
local function targetSize(name)
    -- 框架的全局 GetTextureSize 只缓存 LoadTexture，渲染目标须查询底层 API。
    return (lstg.GetTextureSize or GetTextureSize)(name)
end
local function default(o)
    if not N.host() and not C.active then return C.raw.DefaultRenderFunc(o) end
    local image=o.img
    if type(image)~='string' or image=='' or o.hide then return C.raw.DefaultRenderFunc(o) end
    local kind=imageKind(image);local style=C.states[kind..':'..image]
    local slot=C.context and C.context.slot or 0;local factor=N.host() and fade(slot) or 1
    if factor~=1 and kind~='psi' then setStyle(kind,image,style,factor) end
    C.raw.DefaultRenderFunc(o)
    if factor~=1 and kind~='psi' then setStyle(kind,image,style,1) end
    emit('Default',{image,o.x,o.y,o.rot,o.hscale,o.vscale,o.ani,kind,o._net_uid or 0},style)
end
function C.install()
    for _,kind in ipairs({'Image','Animation','Font'}) do
        local prefix=kind=='Image' and 'img' or kind=='Animation' and 'ani' or 'font'
        for _,original in ipairs({false,true}) do
            local name=(original and 'OriginalSet' or 'Set')..kind..'State'
            if type(_G[name])=='function' then
                local raw=_G[name];C.raw[name]=raw
                _G[name]=function(...)
                    local image,blend,a,r,g,b=...
                    state(prefix,image,blend,a,r,g,b)
                    -- Color 重载是 3 个参数，数字分量重载是 6 个；必须原样转发参数个数。
                    return raw(...)
                end
            end
        end
    end
    C.raw.DefaultRenderFunc=DefaultRenderFunc;DefaultRenderFunc=default;lstg.DefaultRenderFunc=default
    if object then object.render=default;object[4]=default end
    for _,name in ipairs(resources) do
        if type(_G[name])=='function' then
            local raw=_G[name];C.raw[name]=raw
            _G[name]=function(...)
                local a=args(...);local result={raw(...)}
                local permitted=true
                if name=='LoadTexture' or name=='LoadPS' or name=='LoadTTF' or name=='LoadFont' or name=='LoadFX' or name=='LoadSound' or name=='LoadMusic' then permitted=pcall(safePath,a[2]) end
                if name=='LoadImage' then C.states['img:'..a[1]]={'',255,255,255,255}
                elseif name=='LoadAnimation' then C.states['ani:'..a[1]]={'',255,255,255,255} end
                if name=='CreateRenderTarget' then C.targets[a[1]]=true end
                if permitted then resource(name,a) end
                return unpack(result)
            end
            if lstg[name]==raw then lstg[name]=_G[name] end
        end
    end
    for _,name in ipairs(drawNames) do
        if type(_G[name])=='function' then
            local raw=_G[name];C.raw[name]=raw
            _G[name]=function(...)
                if C.suppress or (not C.active and (not N.host() or not C.context or C.context.slot~=2)) then
                    if name=='SetImageScale' and type((...))=='string' then resource(name,args(...)) end
                    return raw(...)
                end
                local a=args(...);local style,kind
                if name=='SetViewMode' or name=='Set2D' or name=='Set3Dwithmode' then
                    local old=C.suppress;C.suppress=true;local result={raw(...)};C.suppress=old
                    emit(name,{a,camera()});return unpack(result)
                end
                if name=='SetViewport' or name=='SetScissorRect' then
                    a={(a[1]-screen.dx)/screen.scale,(a[2]-screen.dx)/screen.scale,(a[3]-screen.dy)/screen.scale,(a[4]-screen.dy)/screen.scale}
                end
                if name=='SetImageScale' and type(a[1])=='string' then resource(name,a) end
                if name=='Render' or name=='RenderRect' or name=='Render4V' then kind='img'
                elseif name=='RenderAnimation' then kind='ani'
                elseif name=='RenderText' then kind='font' end
                if kind then style=C.states[kind..':'..a[1]] end
                local factor=N.host() and C.context and fade(C.context.slot) or 1
                if factor~=1 and kind then setStyle(kind,a[1],style,factor) end
                local values=(name=='SetViewport' or name=='SetScissorRect') and args(...) or a
                if name=='RenderTexture' and factor~=1 then
                    values=copy(a)
                    for i=3,6 do local v=values[i];if type(v)=='table' and v[6] then local A,R,G,B=v[6]:ARGB();v[6]=Color(A*factor,R,G,B) end end
                end
                local result={raw(unpack(values,1,values.n or #values))}
                if factor~=1 and kind then setStyle(kind,a[1],style,1) end
                local metadata
                if name=='RenderTexture' and C.targets[a[1]] then
                    local w,h=targetSize(a[1]);local full=setting and w==setting.resx and h==setting.resy
                    metadata={w,h,screen.dx,screen.dy,screen.scale,full==true}
                end
                emit(name,a,style,metadata);return unpack(result)
            end
            if lstg[name]==raw then lstg[name]=_G[name] end
        end
    end
    for _,name in ipairs({'PlaySound','PlayMusic','StopMusic','PauseMusic','ResumeMusic','SetBGMVolume'}) do
        if type(_G[name])=='function' then
            local raw=_G[name];C.raw[name]=raw
            _G[name]=function(...)
                local a=args(...)
                if N.host() then
                    if name=='PlaySound' then C.audio[a[1]]=a
                    elseif name=='PlayMusic' then C.music[a[1]]={params=a,state='playing'}
                    elseif name=='StopMusic' then C.music[a[1]]={state='stopped'}
                    elseif name=='PauseMusic' and C.music[a[1]] then C.music[a[1]].state='paused'
                    elseif name=='ResumeMusic' and C.music[a[1]] then C.music[a[1]].state='playing'
                    elseif name=='SetBGMVolume' and C.music[a[1]] then C.music[a[1]].volume=a[2] end
                end
                return raw(...)
            end
            if lstg[name]==raw then lstg[name]=_G[name] end
        end
    end
    C.installBent()
end
function C.installBent()
    if type(lstg.BentLaserData)~='function' then return end
    local factory=lstg.BentLaserData;C.raw.BentLaserData=factory
    lstg.BentLaserData=function(...)
        local real=factory(...);if not N.host() then return real end;local self={real=real,points={},width=0,limit=0}
        return setmetatable(self,{__index=function(_,name)
            if name=='Update' then return function(_,o,length,width,inactive,...)
                real:Update(o,length,width,inactive,...);self.limit=math.min(1024,math.max(2,length));self.width=width
                self.points[#self.points+1]={o.x,o.y,(inactive and inactive>0) and 0 or width};while #self.points>self.limit do table.remove(self.points,1) end
            end end
            if name=='SetAllWidth' then return function(_,width) self.width=width;for _,p in ipairs(self.points) do p[3]=width end;return real:SetAllWidth(width) end end
            if name=='UpdatePositionByList' then return function(_,list,length,width,...)
                real:UpdatePositionByList(list,length,width,...);self.points={};self.width=width
                for i=1,math.min(length,1024) do self.points[i]={list[i].x,list[i].y,width} end
            end end
            if name=='Render' then return function(_,...)
                local a=args(...);local values=a;local factor=C.context and fade(C.context.slot) or 1
                if factor~=1 and a[3] then values=copy(a);local A,R,G,B=a[3]:ARGB();values[3]=Color(A*factor,R,G,B) end
                real:Render(unpack(values,1,values.n or #values));emit('Bent',{a,copy(self.points),self.width})
            end end
            if name=='Release' then return function(_) self.points={};return real:Release() end end
            local value=real[name]
            if type(value)=='function' then return function(_,...) return value(real,...) end end
            return value
        end})
    end
    BentLaserData=lstg.BentLaserData
end
function C.sendResources(force)
    if not N.peer or N.peer.closed then return end
    local items={};for _,v in pairs(C.registry) do if force or not C.sentVersion or (v.version or 0)>C.sentVersion then items[#items+1]=v end end
    table.sort(items,function(a,b) return a.order<b.order end)
    local result={};for _,v in ipairs(items) do result[#result+1]={v.name,v.params,v.pool} end
    if #result>0 then N.peer:send('R',W.encode(result)) end;C.sentVersion=C.version
end
local assetType={LoadTexture='tex',LoadImage='img',LoadAnimation='ani',LoadPS='psi',LoadFont='fnt',LoadTTF='ttf',LoadFX='fx',CopyImage='img',CopyAnimation='ani',CreateRenderTarget='tex',LoadMusic='bgm',LoadSound='snd'}
function C.receiveResources(bytes)
    local items=W.decode(bytes,Color);assert(type(items)=='table' and #items<=16000,'资源表无效')
    local changedTextures={}
    for _,v in ipairs(items) do
        assert(type(v)=='table' and type(v[1])=='string' and type(v[2])=='table','资源消息无效')
        local name,a=v[1],v[2];assert(resourceOps[name] or name=='SetImageScale','资源操作不允许')
        if name=='CreateRenderTarget' then C.targets[a[1]]=true end
        assert(type(a[1])=='string' and #a[1]<=128 and not a[1]:find('%z'),'资源名称无效')
        assert((a.n or #a)<=16,'资源参数过多')
        for _,arg in pairs(a) do if type(arg)=='number' then assert(arg==arg and math.abs(arg)<=65536,'资源参数越界') end end
        if name=='LoadTexture' or name=='LoadPS' or name=='LoadTTF' or name=='LoadFont' or name=='LoadFX' or name=='LoadMusic' or name=='LoadSound' then safePath(a[2]) end
        if name=='LoadImage' or name=='LoadAnimation' then
            for i=3,6 do assert(type(a[i])=='number' and math.abs(a[i])<=16384,'图像区域无效') end
            assert(a[5]>=0 and a[6]>=0,'图像尺寸无效')
            if name=='LoadAnimation' then assert(type(a[7])=='number' and type(a[8])=='number' and a[7]>=1 and a[8]>=1 and a[7]*a[8]<=4096,'动画数量越界') end
        end
        local raw=C.raw[name];assert(raw,'本引擎不支持资源操作：'..name)
        local previous=C.registry[key(name,a)];local signature=W.encode(a);local kind=assetType[name]
        local changed=not previous or previous.signature~=signature
        local dependent=(name=='LoadImage' or name=='LoadAnimation') and changedTextures[a[2]]
        if not kind or changed or dependent or not CheckRes(kind,a[1]) then
            local found=kind and CheckRes(kind,a[1])
            if found and (changed or dependent) then
                local types={tex=1,img=2,ani=3,bgm=4,snd=5,psi=6,fnt=7,ttf=8,fx=9}
                RemoveResource(found,types[kind],a[1]);found=nil
            end
            if not found then
                local pool=GetResourceStatus and GetResourceStatus()
                if SetResourceStatus then SetResourceStatus(v[3]=='stage' and 'stage' or 'global') end
                raw(unpack(a,1,a.n or #a))
                if name=='LoadImage' or name=='CopyImage' then C.states['img:'..a[1]]={'',255,255,255,255}
                elseif name=='LoadAnimation' or name=='CopyAnimation' then C.states['ani:'..a[1]]={'',255,255,255,255}
                elseif name=='LoadFont' then C.states['font:'..a[1]]={'',255,255,255,255} end
                if pool then SetResourceStatus(pool) end
            end
            if name=='LoadTexture' then changedTextures[a[1]]=true end
            C.serial=C.serial+1;C.registry[key(name,a)]={name=name,params=copy(a),pool=v[3],order=C.serial,signature=signature}
        end
    end
end
function C.begin()
    C.active=false
    if not N.host() or not N.connected or not N.ready or not N.peer then return end
    local now=SaveTransport.now()
    if now-(C.last or 0)<1/(N.fps or 20) or N.peer.output then return end
    C.last=now;C.calls={};C.context=nil;C.active=true
end
function C.finish()
    if not C.active then return end
    C.active=false
    local players={}
    for i,p in ipairs(N.players) do if IsValid(p) then players[i]={x=p.x,y=p.y,hspeed=p.hspeed,lspeed=p.lspeed,slow=p.slow,death=p.death,protect=p.protect,lock=p.lock,dialog=p.dialog} end end
    local sounds={};for _,a in pairs(C.audio) do if #sounds<32 then sounds[#sounds+1]=a end end;C.audio={}
    local value={tick=N.tick,time=SaveTransport.now()-N.epoch,players=players,calls=C.calls,world=copy(lstg.world),paused=N.pause,ack=N.inputSeq or 0,sounds=sounds,music=C.music,team={score=lstg.var.score or 0,misses=lstg.var.dead or 0,captures=lstg.var.getsc or 0}}
    local ok,bytes=pcall(W.encode,value)
    if not ok then N.pause[1]=true;N.error='画面同步失败：'..tostring(bytes);return end
    C.bytes=#bytes;C.drawCount=#C.calls
    if C.sentVersion~=C.version then C.sendResources() end
    N.peer:send('F',bytes,true)
end
local function validArguments(a,depth)
    assert(type(a)=='table' and (depth or 0)<=12,'绘制参数无效')
    for _,v in pairs(a) do
        if type(v)=='table' then validArguments(v,(depth or 0)+1)
        elseif type(v)=='number' then assert(v==v and math.abs(v)<=1e12,'绘制数值越界')
        else assert(v==nil or type(v)=='boolean' or type(v)=='string' or type(v)=='userdata','绘制参数类型无效') end
    end
end
function C.receiveFrame(bytes)
    local frame=W.decode(bytes,Color)
    assert(type(frame)=='table' and type(frame.tick)=='number' and type(frame.time)=='number' and type(frame.calls)=='table' and #frame.calls<=C.MAX_CALLS,'画面报文无效')
    if C.latest and frame.tick<C.latest.tick then return end
    local targets=0
    for _,call in ipairs(frame.calls) do
        assert(type(call)=='table' and byId[call[1]] and call[2]>=0 and call[2]<=2 and (call[3]==1 or call[3]==2 or call[3]==0),'画面操作无效')
        validArguments(call[6]);assert(call[7]==nil or (type(call[7])=='table' and #call[7]==5),'图像状态无效')
        if call[7] then for i=2,5 do assert(type(call[7][i])=='number' and call[7][i]>=0 and call[7][i]<=255,'图像颜色越界') end end
        if call[8] then
            assert(byId[call[1]]=='RenderTexture' and type(call[8])=='table','渲染目标尺寸无效')
            for i=1,2 do assert(type(call[8][i])=='number' and call[8][i]>0 and call[8][i]<=16384,'渲染目标尺寸越界') end
            if call[8][6] then
                for i=3,5 do assert(type(call[8][i])=='number' and math.abs(call[8][i])<=16384,'渲染目标视口无效') end
                assert(call[8][5]>0,'渲染目标缩放无效')
            end
        end
        if byId[call[1]]=='PushRenderTarget' then targets=targets+1 elseif byId[call[1]]=='PopRenderTarget' then targets=targets-1 end
        assert(targets>=0 and targets<=16,'画面目标栈无效')
    end
    assert(targets==0,'画面目标栈未闭合')
    validArguments(frame)
    assert(type(frame.players)=='table' and type(frame.world)=='table','自机与世界数据无效')
    for _,k in ipairs({'pl','pr','pt','pb','l','r','t','b'}) do assert(type(frame.world[k])=='number' and math.abs(frame.world[k])<1e6,'世界边界无效') end
    for i=1,2 do local p=frame.players[i];if p then assert(type(p.x)=='number' and type(p.y)=='number' and math.abs(p.x)<1e6 and math.abs(p.y)<1e6,'自机坐标无效') end end
    C.previous=C.latest;C.latest=frame;C.receivedAt=SaveTransport.now();N.receivedFrames=(N.receivedFrames or 0)+1;N.tick=frame.tick
    if frame.world then lstg.world=frame.world end
    -- 暂停以可靠控制报文为准，旧画面可能在最新暂停指令之后才被处理。
    local p=frame.players and frame.players[2]
    if p then
        local prediction=N.predict or {};local x,y=prediction.x,prediction.y
        for k,v in pairs(p) do prediction[k]=v end;N.predict=prediction
        if x and y then prediction.x=p.x+(x-p.x)*0.25;prediction.y=p.y+(y-p.y)*0.25 end
        player=N.predict;lstg.player=player
    end
    C.previousCalls={}
    if C.previous then for _,call in ipairs(C.previous.calls) do C.previousCalls[tostring(call[4])..':'..call[5]..':'..call[1]]=call end end
    for _,a in ipairs(frame.sounds or {}) do if C.raw.PlaySound and CheckRes('snd',a[1]) then C.raw.PlaySound(unpack(a,1,a.n or #a)) end end
    C.remoteMusic=C.remoteMusic or {}
    for name,m in pairs(frame.music or {}) do
        local old=C.remoteMusic[name]
        if CheckRes('bgm',name) then
            if m.params and (not old or old.state=='stopped') then C.raw.PlayMusic(unpack(m.params,1,m.params.n or #m.params)) end
            if not old or old.state~=m.state then
                local fn=m.state=='paused' and C.raw.PauseMusic or m.state=='stopped' and C.raw.StopMusic or C.raw.ResumeMusic
                if fn then fn(name) end
            end
            if m.volume and C.raw.SetBGMVolume then C.raw.SetBGMVolume(name,m.volume) end
        end
    end
    C.remoteMusic=frame.music
end
local function applyCamera(a,name)
    local params,data=a[1],a[2]
    assert(type(data)=='table' and type(data.world)=='table','摄像机数据无效')
    lstg.world=data.world;lstg.worldoffset=data.offset;lstg.view3d=data.view
    if data.billboard then lstg.viewbillboard=data.billboard end
    C.raw[name](unpack(params,1,params.n or #params))
end
local function bent(a,factor)
    local r,points,width=a[1],a[2],a[3];assert(type(points)=='table' and #points<=1024 and type(r[1])=='string','曲线光数据无效')
    local texture,blend,color=r[1],r[2],r[3];if not CheckRes('tex',texture) then return end
    if factor~=1 and color then local A,R,G,B=color:ARGB();color=Color(A*factor,R,G,B) end
    local u0,v0,w,h=r[4] or 0,r[5] or 0,r[6] or 256,r[7] or 32
    for i=2,#points do
        local p,q=points[i-1],points[i];local dx,dy=q[1]-p[1],q[2]-p[2];local length=math.sqrt(dx*dx+dy*dy)
        if length>0.001 then
            local nx,ny=-dy/length*(q[3] or width)/2,dx/length*(q[3] or width)/2
            local left,right=u0+w*(i-2)/math.max(1,#points-1),u0+w*(i-1)/math.max(1,#points-1)
            C.raw.RenderTexture(texture,blend,{p[1]+nx,p[2]+ny,0.5,left,v0,color},{q[1]+nx,q[2]+ny,0.5,right,v0,color},
                {q[1]-nx,q[2]-ny,0.5,right,v0+h,color},{p[1]-nx,p[2]-ny,0.5,left,v0+h,color})
        end
    end
end
function C.render()
    local frame=C.latest
    if not frame then SetViewMode('ui');RenderClear(Color(255,8,16,30));return end
    for _,call in ipairs(frame.calls) do
        local name,a,s=byId[call[1]],call[6],call[7];local kind
        if name=='SetViewMode' or name=='Set2D' or name=='Set3Dwithmode' then applyCamera(a,name)
        elseif name=='Default' then
            local image,x,y,rot,hs,vs,ani,typeName=unpack(a)
            if typeName=='img' or typeName=='ani' then
                if CheckRes(typeName,image) then
                    setStyle(typeName,image,s,fade(call[2]));local px,py=C.predictionOffset(call)
                    if typeName=='ani' then C.raw.RenderAnimation(image,ani,x+px,y+py,rot,hs,vs) else C.raw.Render(image,x+px,y+py,rot,hs,vs) end
                end
            elseif typeName=='psi' and CheckRes('psi',image) then
                C.particles=C.particles or {}
                if not C.particleClass then C.particleClass=Class(object,{init=function(o,img) o.img=img;o.group=0;o.layer=0;o.bound=false;o.colli=false end,frame=function() end},true) end
                local uid=a[9];local entry=C.particles[uid]
                if not entry or not IsValid(entry.obj) then entry={obj=New(C.particleClass,image)};C.particles[uid]=entry end
                local p=entry.obj;p.x=x;p.y=y;p.rot=rot;p.hscale=hs;p.vscale=vs;entry.seen=SaveTransport.now();C.raw.DefaultRenderFunc(p)
            end
        elseif name=='Bent' then bent(a,fade(call[2]))
        else
            local raw=C.raw[name];assert(raw,'本引擎缺少绘制操作：'..name)
            if name=='Render' or name=='RenderRect' or name=='Render4V' then kind='img'
            elseif name=='RenderAnimation' then kind='ani' elseif name=='RenderText' then kind='font' end
            if not kind or CheckRes(kind=='font' and 'fnt' or kind,a[1]) then
                if kind then setStyle(kind,a[1],s,fade(call[2])) end
                local values=a
                if name=='SetViewport' or name=='SetScissorRect' then values={a[1]*screen.scale+screen.dx,a[2]*screen.scale+screen.dx,a[3]*screen.scale+screen.dy,a[4]*screen.scale+screen.dy}
                elseif name=='RenderTexture' and (call[8] or fade(call[2])~=1) then
                    values=copy(a)
                    local sx,sy,ox,oy=1,1,0,0
                    if call[8] then local w,h=targetSize(a[1]);sx=w/call[8][1];sy=h/call[8][2] end
                    if call[8] and call[8][6] then
                        sx=screen.scale/call[8][5];sy=sx;ox=screen.dx-call[8][3]*sx;oy=screen.dy-call[8][4]*sy
                    end
                    for i=3,6 do
                        local vertex=values[i]
                        if type(vertex)=='table' then
                            vertex[4]=vertex[4]*sx+ox;vertex[5]=vertex[5]*sy+oy
                            if vertex[6] then local A,R,G,B=vertex[6]:ARGB();vertex[6]=Color(A*fade(call[2]),R,G,B) end
                        end
                    end
                elseif name=='Render' or name=='RenderAnimation' then
                    values=copy(a);local ix=name=='Render' and 2 or 3;local ox,oy=C.predictionOffset(call)
                    local old=C.previousCalls[tostring(call[4])..':'..call[5]..':'..call[1]]
                    local dt=C.previous and frame.time-C.previous.time or 0
                    if old and dt>0.001 and a[1]==old[6][1] and call[3]~=1 then
                        local age=math.min(0.08,math.max(0,SaveTransport.now()-C.receivedAt))
                        local dx,dy=a[ix]-old[6][ix],a[ix+1]-old[6][ix+1]
                        if dx*dx+dy*dy<4096 then ox=ox+dx/dt*age;oy=oy+dy/dt*age end
                    end
                    values[ix]=values[ix]+ox;values[ix+1]=values[ix+1]+oy
                end
                raw(unpack(values,1,values.n or #values))
            end
        end
    end
end
function C.updateParticles()
    if C.particles then
        for id,v in pairs(C.particles) do if SaveTransport.now()-(v.seen or 0)>2 then if IsValid(v.obj) then Del(v.obj) end;C.particles[id]=nil end end
    end
    ObjFrame();UpdateXY();AfterFrame()
end
function C.predictionOffset(call)
    if call[2]==2 and call[3]==1 and N.predict and C.latest.players[2] then
        return N.predict.x-C.latest.players[2].x,N.predict.y-C.latest.players[2].y
    end
    return 0,0
end
function C.reset()
    -- 客机直接重放了原生状态；离开时让原生贴图重新匹配本地 Lua 颜色缓存。
    for key,s in pairs(C.states) do
        local kind,name=key:match('^([^:]+):(.+)$')
        if kind and CheckRes(kind=='font' and 'fnt' or kind,name) then setStyle(kind,name,s,1) end
    end
    C.latest=nil;C.previous=nil;C.previousCalls={};C.sentVersion=nil;C.last=nil;C.active=false;C.calls={};C.context=nil;C.audio={};C.music={};C.remoteMusic={};C.particles={}
end
N.Capture=C
return C
