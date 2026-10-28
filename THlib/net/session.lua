-- 房主权威双人联机：客户端只上传输入，关卡、伤害与 Rank 由房主计算。
local C,T=assert(SaveCodec),assert(SaveTransport)
local N={VERSION=1,phase='idle',players={},keys={{},{}},pause={false,false},alpha=0.65,tick=0,nextObject=0}
local actions={'up','down','left','right','slow','shoot','spell','special'}
local heroes={reimu_player='Reimu',marisa_player='Marisa',aya_player='Aya',chiruno_player='Chiruno'}
local function clone(v) return DeSerialize(Serialize(v)) end
local function finite(v,limit) return type(v)=='number' and v==v and math.abs(v)<(limit or 1e12) end
local function endpoint(text)
    assert(type(text)=='string' and #text<=64,'请输入 IPv4:端口')
    local ip,p=text:match('^%s*(%d+%.%d+%.%d+%.%d+):(%d+)%s*$');p=tonumber(p)
    assert(ip and p and p>=1024 and p<=65535 and p%1==0,'请输入有效 IPv4:端口，端口范围 1024–65535')
    for n in ip:gmatch('%d+') do assert(tonumber(n)<=255,'IPv4 地址无效') end
    assert(ip~='0.0.0.0','加入地址不能为 0.0.0.0');return ip,p
end
function N.contentHash()
    if N.hash then return N.hash end
    if AndroidPlatform then
        local f=assert(io.open('android/net-version.txt','rb'),'安装包缺少联机版本指纹');N.hash=f:read('*a');f:close()
    else
        local files={'core.lua','launch.lua'}
        local function walk(dir)
            for _,e in ipairs(plus.EnumFiles(dir)) do
                local name=e.real_name or e.name:match('([^/\\]+)$')
                if e.isDirectory then if name~='.' and name~='..' then walk(dir..'/'..name) end
                elseif name:sub(-4)=='.lua' then files[#files+1]=dir..'/'..name end
            end
        end
        walk('THlib');walk('mod');walk('Resources/System');table.sort(files);local parts={}
        for _,path in ipairs(files) do local f=assert(io.open(path,'rb'));local s=f:read('*a'):gsub('^\239\187\191',''):gsub('\r\n','\n');f:close();parts[#parts+1]=path..':'..#s..':'..C.sha256(s) end
        N.hash=C.sha256(table.concat(parts,'\n'))
    end
    assert(#N.hash==64 and not N.hash:find('[^0-9a-f]'),'联机版本指纹无效');return N.hash
end
function N.active() return N.match==true end
function N.client() return N.match and N.role=='client' end
function N.host() return N.match and N.role=='host' end
local function send(v) if N.peer and not N.peer.closed then return N.peer:send('J',Serialize(v)) end end
local function notify(text) N.error=text;if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_NET: '..text) end end
local function mask(keys)
    local n=0;for i,k in ipairs(actions) do if keys[k] then n=n+2^(i-1) end end;return n
end
local function keys(value)
    assert(finite(value,256) and value>=0 and value%1==0,'联机按键无效');local out={}
    for i,k in ipairs(actions) do out[k]=math.floor(value/2^(i-1))%2==1 end;return out
end
function N.localKeys()
    local out={};for _,k in ipairs(actions) do out[k]=GetKeyState(setting.keys[k])==true end;return out
end
function N.readKeys(out)
    local localKeys=N.localKeys();for _,k in ipairs(actions) do out[k]=localKeys[k] end
end
local function clearPeer(reason)
    N.connected=false;N.ready=false;N.keys[2]={};N.lastInput=0
    if reason then notify(reason) end
end
local function onClose(reason)
    clearPeer(reason);if N.role=='client' then N.phase='disconnected' end
end
local function validHero(hero) assert(heroes[hero],'自机类型无效');return hero end
local function control(v,connection)
    assert(type(v)=='table' and type(v.t)=='string','联机消息格式无效')
    if v.t=='relay-heartbeat' then return end
    if v.t=='relay-error' then error(v.message or '中继拒绝连接') end
    if v.t=='reject' then connection:close(v.message or '房主拒绝连接');return end
    if v.t=='relay-ready' then N.phase='hosting';return end
    if v.t=='relay-peer-left' then clearPeer(v.message or '对方已离开');return end
    if v.t=='relay-paired' then
        if N.role=='client' then send({t='hello',version=N.VERSION,hash=N.contentHash(),key=N.key,hero=N.hero}) end
        return
    end
    if v.t=='hello' then
        assert(N.role=='host' and not N.connected,'房间已满')
        assert(v.version==N.VERSION and v.hash==N.contentHash(),'双方游戏版本不同，请使用相同功能包')
        assert(type(v.key)=='string' and C.equal(v.key,N.key),'房间口令错误')
        validHero(v.hero)
        assert(not N.match or v.hero==N.guestHero,'重连时请使用原来的自机')
        N.peer=connection;N.connected=true;N.ready=false;N.guestHero=v.hero;N.lastInput=T.now();N.inputSeq=-1
        connection.authorized=true;send({t='welcome',version=N.VERSION,hero=N.hero,mode=N.mode,rejoin=N.match==true})
        return
    end
    if v.t=='welcome' then
        assert(N.role=='client' and v.version==N.VERSION,'房主协议不匹配')
        N.connected=true;N.hostHero=validHero(v.hero);N.mode=v.mode;N.phase=v.rejoin and 'syncing' or 'joined'
        N.ready=true;send({t='ready',hero=N.hero})
        return
    end
    assert(N.connected and (N.role=='client' or connection.authorized),'尚未完成房间验证')
    if v.t=='ready' then
        assert(N.role=='host','准备消息方向无效');N.ready=true;N.lastInput=T.now()
        if N.match then send({t='start',mode=N.mode,heroes={N.hero,N.guestHero}});N.Capture.sendResources(true);send({t='paused',flags=N.pause}) end
    elseif v.t=='start' then
        assert(N.role=='client' and type(v.heroes)=='table','开局消息无效')
        N.hostHero=validHero(v.heroes[1]);assert(validHero(v.heroes[2])==N.hero,'房间角色不匹配')
        N.mode=v.mode;N.beginClient()
    elseif v.t=='input' then
        assert(N.role=='host' and N.match and finite(v.seq,2^31) and v.seq>=0 and v.seq%1==0,'输入序号无效')
        if v.seq>(N.inputSeq or -1) then N.inputSeq=v.seq;N.keys[2]=keys(v.keys);N.lastInput=T.now() end
    elseif v.t=='pause' then
        assert(type(v.value)=='boolean','暂停消息无效')
        if N.role=='host' then N.pause[2]=v.value;send({t='paused',flags=N.pause}) end
    elseif v.t=='paused' then
        assert(N.role=='client' and type(v.flags)=='table','暂停状态无效');N.pause={v.flags[1]==true,v.flags[2]==true}
    elseif v.t=='ping' then send({t='pong',clock=v.clock})
    elseif v.t=='pong' then if finite(v.clock) then N.ping=math.max(0,(T.now()-N.epoch-v.clock)*1000) end
    elseif v.t=='summary' then
        assert(N.role=='client' and type(v.value)=='table','结算消息无效')
        local s=v.value;assert(finite(s.score,1e15) and finite(s.misses,1e6) and finite(s.captures,1e6) and type(s.won)=='boolean','结算数值无效');N.summary=s
    else error('未知联机消息：'..v.t) end
end
local function onMessage(kind,body,connection)
    if connection.rejected then return end
    if kind=='J' then
        assert(#body<=16384,'联机控制消息过大');local v=DeSerialize(body)
        -- 中继房主的 socket 会复用；拒绝一个不兼容加入者不能销毁整个房间。
        if N.role=='host' and type(v)=='table' and v.t=='hello' then
            local ok,err=pcall(control,v,connection)
            if not ok then
                connection:send('J',Serialize({t='reject',message=tostring(err)}))
                if not N.relay then connection.rejected=true end
            end
        else control(v,connection) end
    elseif N.role=='client' and N.connected and N.match then
        if kind=='R' then
            N.pendingResources=N.pendingResources or {};assert(#N.pendingResources<4,'资源同步积压');N.pendingResources[#N.pendingResources+1]=body
        elseif kind=='F' then N.pendingFrame=body
        else error('未知联机报文') end
    else error('未授权联机数据') end
end
function N.info()
    local positions={}
    local objects=N.host() and N.players or (N.Capture and N.Capture.latest and N.Capture.latest.players) or {}
    for i=1,2 do local p=objects[i];if p and (not N.host() or IsValid(p)) then positions[i]={x=p.x,y=p.y,death=p.death,protect=p.protect} end end
    return {phase=N.phase,role=N.role or false,connected=N.connected==true,ready=N.ready==true,mode=N.mode or 'dual',hero=N.hero or 'reimu_player',guestHero=N.guestHero or false,
        code=N.code or '',error=N.error or '',ping=math.floor(N.ping or 0),paused=N.pause,match=N.match==true,addresses=T.addresses(),alpha=N.alpha,frames=N.receivedFrames or 0,summary=N.summary or false,
        tick=N.tick,players=positions,snapshotBytes=N.Capture and N.Capture.bytes or 0,renderCommands=N.Capture and N.Capture.drawCount or 0}
end
function N.create(options)
    assert(not N.match,'请先退出当前联机');N.leave();options=options or {}
    N.role='host';N.phase='hosting';N.hero=validHero(options.hero or 'reimu_player');N.mode=options.mode or 'dual'
    assert(N.mode=='dual' or N.mode=='single' or N.mode=='main','联机关卡类型无效')
    N.key=C.base64(C.random(24));N.epoch=T.now();N.connections={};N.pause={false,false};N.error=nil
    local ip,port
    if options.relay and options.relay~='' then
        ip,port=endpoint(options.relay);N.relay=true;N.room=C.id()
        N.peer=T.tcpConnect(ip,port,onMessage,onClose);N.connections[1]=N.peer
        N.peer:send('J',Serialize({t='relay-host',room=N.room,auth=C.sha256(N.key)}))
    else
        N.relay=false;port=tonumber(options.port) or 39777;assert(port%1==0 and port>=1024 and port<=65535,'房主端口无效')
        N.server=T.tcpListen(port,function(socket,wrap)
            if #N.connections>=4 then
                local c=wrap(socket,function() end);c:close('房间繁忙');return
            end
            local c;c=wrap(socket,onMessage,function(reason) if c==N.peer then onClose(reason);N.peer=nil end end)
            c.accepted=T.now();N.connections[#N.connections+1]=c
        end)
        ip=options.address and options.address~='' and options.address or T.addresses()[1] or '127.0.0.1'
        endpoint(ip..':'..port)
    end
    N.code='BRM1.'..C.base64(Serialize({version=N.VERSION,ip=ip,port=port,key=N.key,relay=N.relay,room=N.room}))
    return N.info()
end
function N.join(options)
    options=options or {}
    local reconnect=N.client() and not N.connected and options.code==N.code
    assert(not N.match or reconnect,'请先退出当前联机')
    if reconnect then
        for _,c in ipairs(N.connections or {}) do c:close() end
        N.connections={};N.match=false
    else N.leave() end
    local code=assert(options.code,'请输入房间口令'):gsub('%s','');assert(#code<=2048,'房间口令过长')
    local v=DeSerialize(C.unbase64(assert(code:match('^BRM1%.([%w_-]+)$'),'房间口令格式无效')))
    assert(type(v)=='table' and v.version==N.VERSION and type(v.key)=='string' and #v.key==32,'房间口令不兼容')
    local ip,port=endpoint((options.address and options.address~='' and options.address) or (tostring(v.ip)..':'..tostring(v.port)))
    N.hero=validHero(options.hero or 'reimu_player');N.role='client';N.phase='joining';N.epoch=T.now();N.key=v.key;N.relay=v.relay==true;N.room=v.room;N.error=nil;N.code=code
    N.peer=T.tcpConnect(ip,port,onMessage,onClose);N.connections={N.peer};N.pause={false,false}
    if N.relay then assert(type(v.room)=='string' and #v.room==32,'中继房间无效');send({t='relay-join',room=v.room,auth=C.sha256(v.key)})
    else send({t='hello',version=N.VERSION,hash=N.contentHash(),key=N.key,hero=N.hero}) end
    return N.info()
end
function N.start()
    assert(N.role=='host' and N.connected and N.ready and not N.match,'需要另一位玩家加入并准备')
    assert(stage.current_stage and stage.current_stage.is_menu and not stage.next_stage,'请先返回标题再联机')
    N.match=true;N.phase='playing';N.tick=0;N.nextObject=0;N.summary=nil;N.recorded=false;N.players={};N.keys={{},{}};N.pause={false,false};N.inputSeq=-1
    N.Capture.reset();N.stats={score=scoredata,spell=spell_card_data,money=GetSaveMoneyState()}
    scoredata=clone(scoredata);spell_card_data=DeSerialize(Serialize(EncodeSpellCardData()));scoredata.money=0;SetSaveMoneyState({fraction=0,offset=N.stats.money.offset})
    lstg.var.player_name=N.hero;lstg.var.rep_player=heroes[N.hero];lstg.var.current_system=''
    lstg.var.__coop=true;lstg.var.__resume_version=nil
    N.lastInput=T.now();send({t='start',mode=N.mode,heroes={N.hero,N.guestHero}})
    if N.mode=='main' then stage.group.Start(stage.groups.BossRush) else RogueTen.start(N.mode) end
    N.Capture.sendResources();SaveSync.close()
    return N.info()
end
function N.beginClient()
    N.Capture.reset()
    N.match=true;N.phase='playing';N.tick=0;N.receivedFrames=0;N.recorded=false;N.summary=nil;N.pause={false,false};N.players={};N.predict=nil;N.pendingResources={};N.pendingFrame=nil;N.predictAt=nil
    lstg.var.__resume_version=nil;lstg.var.__rank_version=nil;lstg.var.__coop=true
    replayWriter=nil;replayReader=nil
    if not stage.stages.NetClient then
        local s=stage.New('NetClient',true,false);s.init=function() ext.notUIdraw=true end;s.frame=function() end;s.render=function() end
    end
    stage.Set('none','NetClient');SaveSync.close()
end
function N.finish(won)
    if not N.host() or N.summary then return end
    N.summary={won=won==true,score=lstg.var.score or 0,misses=lstg.var.dead or 0,captures=lstg.var.getsc or 0}
    send({t='summary',value=N.summary})
end
function N.leave()
    local playing=N.match
    if N.host() then N.finish(false) end
    if playing and not N.summary and N.Capture.latest and N.Capture.latest.team then N.summary=clone(N.Capture.latest.team);N.summary.won=false end
    if playing and stage and stage.stages.menu then stage.Set('none','menu') end
    N.match=false;N.connected=false;N.ready=false
    if N.connections then for _,c in ipairs(N.connections) do c:close() end end
    if N.server then N.server:close() end
    N.connections={};N.peer=nil;N.server=nil
    if N.stats then scoredata=N.stats.score;spell_card_data=N.stats.spell;SetSaveMoneyState(N.stats.money);N.stats=nil end
    if playing and N.summary and not N.recorded then
        local record=scoredata.coop or {played=0,cleared=0,best_score=0}
        record.played=(record.played or 0)+1;record.cleared=(record.cleared or 0)+(N.summary.won and 1 or 0);record.best_score=math.max(record.best_score or 0,N.summary.score)
        scoredata.coop=record;N.recorded=true;SaveScoreData()
    end
    N.phase='idle';N.role=nil;N.code=nil;N.key=nil;N.players={};N.pause={false,false};N.keys={{},{}};N.predict=nil
    N.clientSeq=0;N.inputSeq=-1;N.lastPing=nil;N.lastSent=nil;N.guestHero=nil;N.hostHero=nil
    if lstg.var then lstg.var.__coop=nil;lstg.var.__resume_version=nil end
    if N.Capture then N.Capture.reset() end
    N.error=nil
end
function N.poll()
    if N.server then N.server:poll() end
    local now=T.now()
    for i=#(N.connections or {}),1,-1 do
        local c=N.connections[i];c:poll()
        if c.rejected and not c.output and #c.queue==0 then c:close('验证失败') end
        if N.role=='host' and not N.relay and not c.authorized and c.accepted and now-c.accepted>8 then c:close('验证超时') end
        if c.closed then table.remove(N.connections,i) end
    end
    if N.connected and N.peer and not N.peer.closed and now-(N.lastPing or 0)>1 then N.lastPing=now;send({t='ping',clock=now-N.epoch}) end
    if N.client() and N.connected and now-(N.lastSent or 0)>1/60 then
        N.lastSent=now;N.clientSeq=(N.clientSeq or 0)+1;send({t='input',seq=N.clientSeq,keys=mask(N.localKeys())})
    end
end
function N.readyForLogic()
    if not N.host() then return true end
    if not N.connected or not N.ready or T.now()-(N.lastInput or 0)>1.5 then return false end
    if N.pause[1] or N.pause[2] then return false end
    return true
end
function N.togglePause(value)
    if not N.match then return end
    local slot=N.role=='host' and 1 or 2
    if value==nil then value=not N.pause[slot] end
    N.pause[slot]=value==true
    if slot==1 then send({t='paused',flags=N.pause}) else send({t='pause',value=N.pause[2]}) end
end
function N.open() SaveSync.open('coop') end
function N.beforeLogic()
    if not N.host() then return end
    N.tick=N.tick+1;N.keys[1]=clone(KeyState)
    for i,p in ipairs(N.players) do if IsValid(p) then p.key=N.keys[i] end end
    player=N.players[1] or player;lstg.player=player
end
function N.trackNew(o)
    if not N.host() or not IsValid(o) then return o end
    if not o._net_uid then N.nextObject=N.nextObject+1;o._net_uid=N.nextObject end
    if not o._net_slot then
        local parent=o.master or o._master or o.player
        o._net_slot=(parent and parent._net_slot) or N.contextSlot or 0
    end
    if o.class==System or o.class==BulletBreak_Table then o._net_slot=0 end
    return o
end
function N.registerPlayer(p,slot)
    if not N.host() then return end
    p._net_slot=slot;N.players[slot]=p;p.key=N.keys[slot] or {};player=p;lstg.player=p
end
function N.spawnPlayers()
    if not N.host() then return New(_G[lstg.var.player_name]) end
    N.players={}
    for i,hero in ipairs({N.hero,N.guestHero}) do
        N.creatingSlot=i;N.contextSlot=i
        local p=New(_G[hero]);p.x=i==1 and -28 or 28;p.y=-176;p.protect=120
    end
    N.creatingSlot=nil;N.contextSlot=0;player=N.players[1];lstg.player=player
    return player
end
function N.target(o)
    local chosen,distance
    for _,p in ipairs(N.players) do
        if IsValid(p) and not p.realrealreal_lock and (p.death or 0)==0 then
            local d=((o.x or 0)-p.x)^2+((o.y or 0)-p.y)^2
            if not distance or d<distance then chosen,distance=p,d end
        end
    end
    return chosen or N.players[1]
end
function N.callback(fn,kind)
    if type(fn)~='function' then return fn end
    return function(o,...)
        if not N.host() then return fn(o,...) end
        local slot=o._net_slot or N.contextSlot or N.creatingSlot or 0
        local oldPlayer,oldLstg,oldSlot=player,lstg.player,N.contextSlot
        local other=select(1,...)
        local collided=kind=='colli' and type(other)=='table' and other.group==4 and (other.player or other)
        local owner=slot>0 and N.players[slot] or collided or (kind~='render' and N.target(o))
        if owner then player=owner;lstg.player=owner end
        N.contextSlot=slot
        local oldRender
        if kind=='render' then oldRender=N.Capture.context;N.Capture.context={slot=slot,uid=o._net_uid or 0,role=(o.group==4) and 1 or 2,index=0} end
        local result={pcall(fn,o,...)}
        if result[1] and kind=='init' then N.trackNew(o) end
        if kind=='render' then N.Capture.context=oldRender end
        N.contextSlot=oldSlot;player=oldPlayer;lstg.player=oldLstg
        if not result[1] then error(result[2],0) end
        return unpack(result,2)
    end
end
function N.miss(p)
    if not N.host() then return end
    N.lastMissSlot=p._net_slot or 1
    for _,b in ipairs(boss_group or {}) do if IsValid(b) and b._bosssys then b._bosssys:clearBonus('hit') end end
end
function N.quiz(fn,scene)
    if not N.host() then return fn(scene) end
    local slot=N.lastMissSlot or 1;local p=N.players[slot]
    if not p or not IsValid(p) then return fn(scene) end
    local old,oldLstg=player,lstg.player;local current,previous={},{}
    for _,k in ipairs(actions) do current[k]=KeyState[k];previous[k]=KeyStatePre[k];KeyState[k]=N.keys[slot][k];KeyStatePre[k]=(N.quizKeys or {})[k] end
    player=p;lstg.player=p;local result={pcall(fn,scene)}
    N.quizKeys=clone(N.keys[slot]);for _,k in ipairs(actions) do KeyState[k]=current[k];KeyStatePre[k]=previous[k] end
    player=old;lstg.player=oldLstg;if not result[1] then error(result[2],0) end;return unpack(result,2)
end
-- 激光的手动碰撞也逐个玩家检查，但任务、宽度变化和寿命每帧只运行一次。
function N.forEachPlayer(fn,...)
    if not N.host() then return fn(player,...) end
    local old,oldLstg,slot=player,lstg.player,N.contextSlot
    for i,p in ipairs(N.players) do
        if IsValid(p) then
            player=p;lstg.player=p;N.contextSlot=i
            local ok,err=pcall(fn,p,...)
            if not ok then player=old;lstg.player=oldLstg;N.contextSlot=slot;error(err,0) end
        end
    end
    player=old;lstg.player=oldLstg;N.contextSlot=slot
end
function N.clientFrame()
    local ok,err=pcall(function()
        for _,bytes in ipairs(N.pendingResources or {}) do N.Capture.receiveResources(bytes) end
        if N.pendingFrame then N.Capture.receiveFrame(N.pendingFrame) end
    end)
    N.pendingResources={};N.pendingFrame=nil
    if not ok then
        notify('同步数据无效：'..tostring(err));if N.peer then N.peer:close(N.error) end
        N.Capture.latest=nil;return
    end
    local now=T.now();local dt=math.min(1/15,math.max(0,now-(N.predictAt or now)));N.predictAt=now
    local p,w=N.predict,lstg.world
    if p and N.connected and not N.pause[1] and not N.pause[2] and not p.lock and not p.dialog and (p.death or 0)==0 then
        local k=N.localKeys();local x=(k.right and 1 or 0)-(k.left and 1 or 0);local y=(k.up and 1 or 0)-(k.down and 1 or 0)
        local v=(k.slow and p.lspeed or p.hspeed) or 4;if x*y~=0 then v=v*0.70710678 end
        p.x=math.max(w.pl+8,math.min(w.pr-8,p.x+x*v*60*dt));p.y=math.max(w.pb+16,math.min(w.pt-32,p.y+y*v*60*dt))
    end
    N.Capture.updateParticles()
end
function N.clientRender()
    local ok,err=pcall(N.Capture.render)
    if not ok then
        notify('画面同步失败：'..tostring(err));if N.peer then N.peer:close(N.error) end
        N.Capture.latest=nil
    end
end
function N.controls()
    if not stage or not stage.current_stage or stage.current_stage.stage_name=='init' or stage.current_stage.stage_name=='setname' then return end
    local key=GetLastKey()
    if key==120 then N.open() end
    if N.match and key==setting.keysys.menu and not SaveSync.visible then N.togglePause() end
    local down=GetMouseState and GetMouseState(0)
    if down and not N.mouseDown then
        local x,y=GetMousePosition();x=(x-screen.dx)/screen.scale;y=(y-screen.dy)/screen.scale
        if x>=480 and x<=630 and y>=510 and y<=538 then N.open() end
    end
    N.mouseDown=down
end
function N.render()
    if not ui or not stage.current_stage or stage.current_stage.stage_name=='init' then return end
    local old=N.Capture.suppress;N.Capture.suppress=true
    SetViewMode('ui');SetImageState('white','',210,15,30,52)
    if N.client() and N.Capture.raw.OriginalSetImageState then N.Capture.raw.OriginalSetImageState('white','',Color(210,15,30,52)) end
    RenderRect('white',480,630,510,538)
    ui:RenderText('title','联机合作 F9',555,524,0.6,Color(255,210,235,255),'centerpoint')
    if N.match then
        local text=(N.role=='host' and '房主 P1' or '加入方 P2')..'  '..math.floor(N.ping or 0)..' ms'
        if not N.connected or (N.host() and not N.ready) then text='对方已断开，请用 F9 重连或退出'
        elseif N.pause[1] or N.pause[2] then text='联机已暂停 · ESC 继续 · F9 联机大厅'
        elseif N.host() and not N.readyForLogic() then text='等待对方输入…' end
        if N.summary then text=(N.summary.won and '合作通关' or '合作结束')..' · F9 退出房间' end
        ui:RenderText('title',text,480,478,0.5,Color(255,180,230,255),'centerpoint')
    end
    N.Capture.suppress=old
end
GameNet=N
return N
