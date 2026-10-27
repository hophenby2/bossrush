-- 本机管理页面与限时局域网配对。接收到的存档先预览，用户选择后才写入。
local C,P,N=assert(SaveCodec),assert(SaveProfiles),assert(SaveTransport)
local S={visible=false,pending={},jobs={},requests={}}
local static={['/']={'index.html','text/html; charset=utf-8'},['/app.js']={'app.js','text/javascript; charset=utf-8'},
    ['/style.css']={'style.css','text/css; charset=utf-8'},['/vendor/qrcode.js']={'vendor/qrcode.js','text/javascript'},
    ['/vendor/jsQR.js']={'vendor/jsQR.js','text/javascript'}}
local function snapshot() if SaveResume then SaveResume.flush('管理或导出') end;if scoredata then SaveSpellCardData();SaveScoreData() end end
local function code(ip,port,key)
    local bytes={}; for v in ip:gmatch('%d+') do bytes[#bytes+1]=string.char(tonumber(v)) end
    bytes[#bytes+1]=string.char(math.floor(port/256),port%256)
    return 'BRP1-'..C.base64(table.concat(bytes)..key)
end
local function decodeCode(value)
    assert(type(value)=='string' and #value<256,'配对码无效')
    value=value:gsub('%s',''):gsub('^bossrush%-pair:','')
    local raw=C.unbase64(assert(value:match('^BRP1%-([%w_-]+)$'),'不是 Boss Rush 配对码'))
    assert(#raw==22,'配对码长度无效')
    local a,b,c,d,p,q=raw:byte(1,6); local ip=string.format('%d.%d.%d.%d',a,b,c,d); local port=p*256+q
    assert(N.private(ip) and port>=1024,'配对地址无效')
    return {ip=ip,port=port,key=C.base64(raw:sub(7))}
end
local function json(body)
    assert(type(body)=='string' and #body<=N.MAX_BODY,'请求过大')
    local value=DeSerialize(body); assert(type(value)=='table','请求格式无效'); return value
end
local function stageImport(token,origin)
    local count=0; for _ in pairs(S.pending) do count=count+1 end
    assert(count<4,'请先处理或关闭已有的导入预览')
    local bundle=C.unpack(token); local preview=P.preview(bundle); local id=C.id()
    S.pending[id]={bundle=bundle,preview=preview,origin=origin or '口令 / 二维码',expires=N.now()+600}
    return {pending=id,entries=preview,origin=S.pending[id].origin}
end
local function operation(path,body,callback)
    assert(S.peer,'请先输入配对码或扫描对方二维码'); assert(#S.requests<2,'请等待当前传输完成')
    local which=C.id(); S.jobs[which]={state='working',created=N.now()}
    local request=N.request(S.peer.ip,S.peer.port,path,S.peer.key,body and Serialize(body),function(response,err)
        local job=S.jobs[which]
        if err then job.state='error'; job.error=err; return end
        local ok,value=pcall(json,response.body)
        if not ok then job.state='error'; job.error='对方返回了无效数据'; return end
        if response.status~=200 then job.state='error'; job.error=value.error or '配对已过期，请重新配对'; return end
        local worked,result=pcall(callback or function(v) return v end,value)
        job.state=worked and 'done' or 'error'; job.result=worked and result or nil; job.error=not worked and tostring(result) or nil
    end)
    if request then S.requests[#S.requests+1]=request end
    return {job=which}
end
function S.requestSwitch(which)
    assert(not SaveResume or not SaveResume.recovering,'正在重建续玩位置，请先完成或取消恢复')
    P.entry(which)
    if which==P.index.active then return end
    assert(not P.pending,'正在切换存档，请稍候')
    assert(stage and stage.current_stage and stage.stages.menu and not stage.next_stage,'当前正在加载或切关，请稍后切换')
    -- stage.Set 先结算旧场景，ChangeGameStage 再保存旧槽、激活新槽并加载标题。
    stage.Set('none','menu'); P.pending=which
    ext.pause_menu:init(); ext.pop_pause_menu=nil
    if AndroidInput then AndroidInput.reset() end
end
function S.close()
    S.visible=false; S.pairExpires=0
end
function S.info()
    local pairing={}
    if S.pairExpires and S.pairExpires>N.now() then
        for _,ip in ipairs(N.addresses()) do pairing[#pairing+1]={ip=ip,code=code(ip,S.server.port,S.pairRaw)} end
    end
    local incoming={}; for id,item in pairs(S.pending) do incoming[#incoming+1]={pending=id,entries=item.preview,origin=item.origin} end
    return {profiles=P.list(),active=P.index.active,backups=P.index.backups,addresses=pairing,
        expiresIn=math.max(0,math.floor((S.pairExpires or 0)-N.now())),incoming=incoming,
        connected=S.peer and (S.peer.ip..':'..S.peer.port) or false,version=1}
end
local function dispatch(request)
    if request.method=='GET' and static[request.path] then
        local item=static[request.path]; local f=assert(io.open('THlib/save/web/'..item[1],'rb')); local body=f:read('*a'); f:close()
        return 200,body,item[2]
    end
    local auth=request.headers.authorization or ''
    local peer=request.path:sub(1,6)=='/peer/'
    local expected=peer and S.pairToken or S.localToken
    if peer and (not S.pairExpires or N.now()>=S.pairExpires) then return 403,Serialize({error='配对已关闭或过期，请重新打开存档同步'}) end
    if not C.equal(auth,'Bearer '..(expected or '')) then return 403,Serialize({error='配对码或管理密钥无效'}) end
    local origin=request.headers.origin
    if origin and origin~='http://127.0.0.1:'..S.server.port and origin~='http://localhost:'..S.server.port then
        return 403,Serialize({error='请求来源无效'})
    end
    if not peer then S.heartbeat=N.now() end
    local path=request.path
    if request.method=='GET' then
        if path=='/api/status' then return 200,Serialize(S.info()) end
        if path=='/peer/list' then snapshot(); return 200,Serialize({profiles=P.list()}) end
        local id=path:match('^/api/job/([0-9a-f]+)$')
        if id then return 200,Serialize((assert(S.jobs[id],'传输记录已过期'))) end
        return 404,Serialize({error='接口不存在'})
    end
    local body=json(request.body)
    local result={ok=true}
    if path=='/api/create' then result.id=P.create(body.name,body.clone)
    elseif path=='/api/rename' then P.rename(body.id,body.name)
    elseif path=='/api/archive' then P.archive(body.id)
    elseif path=='/api/switch' then S.requestSwitch(body.id)
    elseif path=='/api/export' or path=='/peer/export' then snapshot(); result.token=C.pack(P.export(body.ids,body.checkpoint==true))
    elseif path=='/api/preview' or path=='/peer/offer' then result=stageImport(body.token,peer and '局域网传入，等待选择' or nil)
    elseif path=='/api/import' then
        local pending=assert(S.pending[body.pending],'预览已过期，请重新导入')
        result=P.import(pending.bundle,body.selection,body.policy); S.pending[body.pending]=nil
    elseif path=='/api/dismiss' then S.pending[body.pending]=nil
    elseif path=='/api/restore' then P.restore(body.id)
    elseif path=='/api/pair' then
        S.peer=decodeCode(body.code); result=operation('/peer/list',nil)
    elseif path=='/api/remote' then result=operation('/peer/list',nil)
    elseif path=='/api/pull' then result=operation('/peer/export',{ids=body.ids,checkpoint=body.checkpoint==true},function(value) return stageImport(value.token,'从已配对设备拉取') end)
    elseif path=='/api/push' then snapshot(); result=operation('/peer/offer',{token=C.pack(P.export(body.ids,body.checkpoint==true))})
    elseif path=='/api/renew' then S.pairRaw=C.random(16); S.pairToken=C.base64(S.pairRaw); S.pairExpires=N.now()+600
    elseif path=='/api/close' then S.close()
    else return 404,Serialize({error='接口不存在'}) end
    return 200,Serialize(result)
end
function S.start(port)
    if S.server then return end
    S.localToken=C.base64(C.random(24)); S.pairRaw=C.random(16); S.pairToken=C.base64(S.pairRaw); S.pairExpires=0
    S.server=N.server(dispatch,port)
end
function S.open()
    if SaveResume and SaveResume.recovering then return end
    if S.visible then return end
    local ok,err=pcall(function()
        snapshot(); S.start(); S.visible=true; S.heartbeat=N.now()+100
        S.pairRaw=C.random(16); S.pairToken=C.base64(S.pairRaw); S.pairExpires=N.now()+600
        if stage.current_stage and not stage.current_stage.is_menu and ext.pause_menu:IsKilled() then ext.pause_menu:FlyIn() end
        local url='http://127.0.0.1:'..S.server.port..'/#token='..S.localToken
        if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_SAVE_OPEN: port='..S.server.port) end
        if AndroidPlatform then
            local worked,message=require('cocos.cocos2d.luaj').callStaticMethod('org/bossrush/hd/BossRushActivity','openSaveManager',{url},'(Ljava/lang/String;)V')
            assert(worked,message or '无法打开存档管理')
        else assert(lstg.Execute(url,'','',false,true),'无法打开浏览器，请使用 F10 重试') end
    end)
    if not ok then S.visible=false; S.error=tostring(err); if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_SAVE_ERROR: '..S.error) end end
end
function S.poll()
    if not S.server then return end
    if S.server then S.server:poll() end
    for i=#S.requests,1,-1 do if S.requests[i]:poll() then table.remove(S.requests,i) end end
    local now=N.now()
    for id,item in pairs(S.pending) do if item.expires<now then S.pending[id]=nil end end
    for id,item in pairs(S.jobs) do if item.created+600<now then S.jobs[id]=nil end end
    -- Android 文件选择器会暂时挂起 Activity，由原生对话框关闭回调结束管理状态。
    if S.visible and not AndroidPlatform and now-(S.heartbeat or now)>20 then S.close() end
end
function S.frame()
    if SaveResume then SaveResume.controls() end
    S.poll()
    if not stage or not stage.current_stage or stage.current_stage.stage_name=='init' or stage.current_stage.stage_name=='setname' then return end
    local key=GetLastKey()
    local down=GetMouseState and GetMouseState(0)
    if key==121 then S.open() end
    if down and not S.mouseDown then
        local x,y=GetMousePosition(); x=(x-screen.dx)/screen.scale; y=(y-screen.dy)/screen.scale
        if x>=800 and x<=956 and y>=510 and y<=538 then S.open() end
    end
    S.mouseDown=down
end
function S.render()
    if not ui or not stage.current_stage or stage.current_stage.stage_name=='init' then return end
    SetViewMode('ui'); SetImageState('white','',210,15,30,52); RenderRect('white',800,956,510,538)
    ui:RenderText('title','存档 / 同步  F10',878,524,0.6,Color(255,210,235,255),'centerpoint')
    if SaveResume then SaveResume.draw() end
    if S.error then ui:RenderText('title',S.error,480,490,0.5,Color(255,255,170,140),'centerpoint') end
end
S.stageImport,S.decodeCode,S.code=stageImport,decodeCode,code
SaveSync=S
BossRushSaveClose=function() S.close() end
return S
