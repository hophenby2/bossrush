-- 关内续玩：保存关卡初态和逻辑输入，恢复时有预算地重建场景，校验后交还控制。
-- 新录像带版本标记；旧录像继续使用原来的随机数和时钟行为。
local C,P,N=assert(SaveCodec),assert(SaveProfiles),assert(SaveTransport)
local R={VERSION=1,INTERVAL=120,MAX_FRAMES=1000000,MAX_INPUT=8*1024*1024}
local rawKey,rawLast=GetKeyState,GetLastKey
local rawRan,randomFactory=ran,Rand
local rawRandom,rawRandomSeed=math.random,math.randomseed
local rawWatch=StopWatch
local rawSE,rawBGM=SetSEVolume,SetBGMVolume
local simMath,visualRan=randomFactory(),randomFactory()
local function clone(value) return DeSerialize(Serialize(value)) end
local function log(text) if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_RESUME: '..text) end end
local function clock() return N.now() end
local function money() return GetSaveMoneyState and GetSaveMoneyState() or {fraction=0,offset=CurrentVerifiableOffset or 0} end
local function stats()
    return {score=Serialize(scoredata),spell=Serialize(EncodeSpellCardData()),money=money()}
end
local function applyStats(value)
    scoredata=DeSerialize(value.score);spell_card_data=DeSerialize(value.spell)
    if SetSaveMoneyState then SetSaveMoneyState(value.money) else CurrentMoney=scoredata.money+(CurrentVerifiableOffset or 0) end
    if ext.achievement then
        ext.achievement.getcount=0;ext.achievement.achievement={};ext.achievement.gold={}
        for _,v in pairs(scoredata.Achievement or {}) do if v==true then ext.achievement.getcount=ext.achievement.getcount+1 end end
    end
end
local contextGlobals={'ContinueGame','ExecuteFlag','RetryCountToUnlockAchievement','GlobalAddAchievement','cheat'}
local function context()
    local out={globals={},sc_pr=ext.sc_pr==true,notUIdraw=ext.notUIdraw==true}
    for _,key in ipairs(contextGlobals) do local v=_G[key];if type(v)=='number' or type(v)=='boolean' or type(v)=='string' then out.globals[key]=v end end
    return out
end
local function applyContext(value)
    ext.sc_pr=value.sc_pr;ext.notUIdraw=value.notUIdraw or nil
    for _,key in ipairs(contextGlobals) do _G[key]=value.globals[key] end
end
local function gameplay() return R.enabled and R.inLogic end
-- 仅把显示与菜单的随机消耗从新格式的逻辑随机序列中隔离；使用引擎原来的 Rand 算法。
local proxy={}
for _,method in ipairs({'Seed','GetSeed','Int','Float','Sign'}) do
    proxy[method]=function(_,...) local target=not R.enabled and rawRan or (R.inLogic and rawRan or visualRan);return target[method](target,...) end
end
ran=proxy
math.random=function(a,b)
    if not gameplay() then if a==nil then return rawRandom() elseif b==nil then return rawRandom(a) else return rawRandom(a,b) end end
    if a==nil then return simMath:Float(0,1) end
    if b==nil then return simMath:Int(1,a) end
    return simMath:Int(a,b)
end
math.randomseed=function(seed)
    if gameplay() then simMath:Seed(seed) else rawRandomSeed(seed) end
end
local function getKey(key)
    if gameplay() then
        if R.recovering then return R.inputDown and R.inputDown[key]==true end
        local value=rawKey(key)
        if value and type(key)=='number' and key>=0 and key<=255 and key%1==0 and R.inputDown then R.inputDown[key]=true end
        return value
    end
    return rawKey(key)
end
local function getLast() if gameplay() and R.recovering then return R.inputLast or 0 end;return rawLast() end
GetKeyState,lstg.GetKeyState=getKey,getKey
GetLastKey,lstg.GetLastKey=getLast,getLast
local function stopwatch(...)
    if not gameplay() then return rawWatch(...) end
    local source=R.logicClock;local watch={base=source.ticks,elapsed=0,paused=false}
    function watch:GetElapsed() return self.elapsed+(self.paused and 0 or (source.ticks-self.base)/60) end
    function watch:Pause() if not self.paused then self.elapsed=self:GetElapsed();self.paused=true end end
    function watch:Resume() if self.paused then self.base=source.ticks;self.paused=false end end
    function watch:Reset() self.base=source.ticks;self.elapsed=0 end
    return watch
end
StopWatch,lstg.StopWatch=stopwatch,stopwatch
function R.runtime()
    if R.runtimeId then return R.runtimeId end
    local probe=randomFactory();probe:Seed(13579)
    local parts={AndroidPlatform and 'LuaSTG-x-20260913' or 'LuaSTG-Sub',require('jit').os,require('jit').arch}
    for _,name in ipairs({'GetVersionNumber','GetVersionName'}) do
        if type(lstg[name])=='function' then local ok,value=pcall(lstg[name]);if ok then parts[#parts+1]=tostring(value) end end
    end
    for i=1,8 do parts[#parts+1]=string.format('%.17g',probe:Float(-1,1)) end
    R.runtimeId=C.sha256(table.concat(parts,'|'));return R.runtimeId
end
function R.codeHash()
    if R.sourceHash then return R.sourceHash end
    if AndroidPlatform then
        -- APK 为只读资产；构建时对实际入包源码计算指纹，避免战斗首帧逐个解压源码。
        local f=assert(io.open('android/resume-version.txt','rb'),'安装包缺少续玩版本指纹，请重新安装完整版本')
        local hash=f:read('*a');f:close()
        assert(#hash==64 and not hash:find('[^0-9a-f]'),'安装包续玩版本指纹损坏')
        R.sourceHash=hash;return hash
    end
    local files={'core.lua','launch.lua'}
    local function walk(dir)
        for _,entry in ipairs(plus.EnumFiles(dir)) do
            local name=entry.real_name or entry.name:match('([^/\\]+)$')
            if entry.isDirectory then if name~='.' and name~='..' then walk(dir..'/'..name) end
            elseif name:sub(-4)=='.lua' then files[#files+1]=dir..'/'..name end
        end
    end
    walk('THlib');walk('mod');walk('Resources/System');table.sort(files)
    local parts={}
    for _,path in ipairs(files) do
        local f=assert(io.open(path,'rb'),'无法读取续玩校验源码：'..path)
        local text=f:read('*a'):gsub('^\239\187\191',''):gsub('\r\n','\n');f:close()
        parts[#parts+1]=path..':'..#text..':'..C.sha256(text)
    end
    R.sourceHash=C.sha256(table.concat(parts,'\n'));return R.sourceHash
end
local function numeric(value) return type(value)=='number' and value==value and math.abs(value)<1e18 end
local function quantize(value) return numeric(value) and math.floor(value*1000+0.5) or 0 end
local signatureFields={'x','y','vx','vy','rot','timer','hp','life','protect','power'}
function R.signature()
    local output={tostring(stage.current_stage.timer)}
    for _,key in ipairs({'score','dead','getsc','graze','lifeleft','bomb','power','faith','pointrate'}) do output[#output+1]=key..'='..quantize(lstg.var[key]) end
    local revive=lstg.var.revive
    if revive then
        output[#output+1]='revive='..table.concat({revive.used or 0,revive.credits or 0,revive.failedAt or -1},',')
        output[#output+1]='asked='..table.concat(revive.asked or {},',')
        local q=revive.quiz
        if q then output[#output+1]='quiz='..table.concat({q.index,q.age,q.choice,q.correct,q.feedback or -1,tostring(q.result)},',') end
    end
    -- 不记录引擎指针、资源句柄、对象池编号或墙钟；同逻辑步的物理对象顺序参与校验。
    for group=0,15 do
        local count=0
        for index,obj in ObjList(group) do
            obj=obj or index;count=count+1
            local row={tostring(group)}
            for _,key in ipairs(signatureFields) do row[#row+1]=tostring(quantize(obj[key])) end
            output[#output+1]=table.concat(row,',')
        end
        output[#output+1]='g'..group..'='..count
    end
    return C.sha256(table.concat(output,';'))
end
local function statsValid(value)
    assert(type(value)=='table' and type(value.score)=='string' and type(value.spell)=='string' and type(value.money)=='table','续玩成长数据无效')
    assert(numeric(value.money.fraction) and numeric(value.money.offset),'续玩金币校验数据无效')
    local score,spell=DeSerialize(value.score),DeSerialize(value.spell)
    assert(type(score)=='table' and type(spell)=='table','续玩成长格式无效')
    if P.validateGrowth then P.validateGrowth(score,spell) end
end
function R.validate(data)
    assert(type(data)=='table' and data.format=='BossRushResume' and data.version==1,'续玩版本不兼容')
    assert(type(data.stage)=='string' and #data.stage>0 and #data.stage<=256 and not data.stage:find('[/\\%z]'),'续玩关卡无效')
    assert(type(data.run)=='string' and #data.run==32 and not data.run:find('[^0-9a-f]'),'续玩批次无效')
    assert(type(data.code)=='string' and #data.code==64 and type(data.runtime)=='string' and #data.runtime==64,'续玩校验标记无效')
    assert(numeric(data.frames) and data.frames%1==0 and data.frames>=0 and data.frames<=R.MAX_FRAMES,'续玩帧数无效')
    assert(numeric(data.savedAt) and type(data.signature)=='string' and #data.signature==64,'续玩终点无效')
    assert(type(data.start)=='table' and type(data.start.var)=='string' and type(data.start.input)=='table' and type(data.start.context)=='table','续玩初态无效')
    local var=DeSerialize(data.start.var);assert(type(var)=='table' and var.stage_name==data.stage and var.__resume_version==1 and var.__resume_run==data.run,'续玩初态不匹配')
    assert(numeric(var.ran_seed),'续玩随机种子无效')
    assert(type(data.target)=='table' and type(data.start.context.globals)=='table','续玩上下文无效')
    assert(type(data.start.context.sc_pr)=='boolean' and type(data.start.context.notUIdraw)=='boolean','续玩模式无效')
    for key,value in pairs(data.start.context.globals) do
        local known=false;for _,name in ipairs(contextGlobals) do if key==name then known=true end end
        assert(known and (type(value)=='boolean' or type(value)=='string' or numeric(value)),'续玩上下文字段无效')
    end
    for key,value in pairs(data.start.input) do assert(type(key)=='string' and #key<=64 and type(value)=='boolean','续玩初始按键无效') end
    statsValid(data.start.stats);statsValid(data.target.stats)
    assert(type(data.target.var)=='string','续玩终态无效')
    local target=DeSerialize(data.target.var)
    assert(type(target)=='table' and target.stage_name==data.stage and target.__resume_run==data.run,'续玩终态不匹配')
    P.validateState(var);P.validateState(target)
    assert(type(data.target.music)=='table','续玩音乐数据无效')
    for name,value in pairs(data.target.music) do
        assert(type(name)=='string' and #name<=256 and type(value)=='table' and numeric(value.timer) and value.timer>=0,'续玩音乐位置无效')
    end
    if data.target.fader then
        local f=data.target.fader
        assert(type(f)=='table' and numeric(f.time) and f.time>=0 and numeric(f.maxtime) and f.maxtime>0 and type(f.mode)=='boolean','续玩转场状态无效')
    end
    assert(type(data.inputs)=='string','续玩输入缺失')
    local bytes=C.unbase64(data.inputs);assert(#bytes<=R.MAX_INPUT,'续玩输入超出容量')
    local position=1
    for _=1,data.frames do
        assert(position+2<=#bytes,'续玩输入不完整');local count=bytes:byte(position+2)
        position=position+3+count;assert(position<=#bytes+1,'续玩按键记录不完整')
    end
    assert(position==#bytes+1,'续玩输入数量不匹配');return data,bytes
end
function R.encode(data) return (C.pack(data):gsub('^BRS1%.','BRR1.')) end
function R.decode(bytes)
    assert(type(bytes)=='string' and bytes:sub(1,5)=='BRR1.','关内续玩文件格式无效')
    return R.validate(C.unpack((bytes:gsub('^BRR1%.','BRS1.'))))
end
function R.has() for _,suffix in ipairs({'','.bak'}) do local f=io.open(P.path('resume.dat')..suffix,'rb');if f then f:close();return true end end;return false end
function R.peek()
    local path=P.path('resume.dat');if R.memo and R.memo.path==path then return R.memo.data end
    local problem
    for _,source in ipairs({path,path..'.bak'}) do
        local bytes=P.readFile(source)
        if bytes then
            local ok,data=pcall(R.decode,bytes)
            if ok then
                if source~=path then
                    os.remove(path..'.corrupt');os.rename(path,path..'.corrupt');P.atomic(path,bytes)
                end
                R.memo={path=path,data=data};return data
            end
            problem=tostring(data)
        end
    end
    return nil,problem
end
function R.clear()
    if R.recovering then return end
    os.remove(P.path('resume.dat'));os.remove(P.path('resume.dat')..'.bak');R.session=nil;R.memo=nil
end
function R.beforeStageSet(mode)
    if R.recovering and mode~='resume' then R.failure='重建在保存时点前发生了切关';return false end
    if R.session and not R.inLogic then R.flush('离开关卡') end
    return true
end
function R.prepareStage()
    local nextStage=stage.next_stage
    R.inLogic=false;R.session=nil;R.pauseAfterRender=nil
    if not nextStage or nextStage.is_menu then R.enabled=false;return end
    if R.pending then
        local data=R.pending;applyStats(data.start.stats);applyContext(data.start.context)
        lstg.var=DeSerialize(data.start.var)
        if LoadSaveInputState then LoadSaveInputState(data.start.input) end
    end
    R.enabled=lstg.var.__resume_version==1
    if not R.enabled then return end
    R.logicClock={ticks=0};R.inLogic=true;simMath:Seed((lstg.var.ran_seed+104729)%2147483647)
    if R.pending then
        R.session={stage=R.pending.stage,run=R.pending.run,start=clone(R.pending.start),frames=0,packets={},size=0}
    elseif replayWriter and not replayReader then
        R.session={stage=nextStage.stage_name,run=lstg.var.__resume_run,start={var=Serialize(lstg.var),stats=stats(),input=clone(KeyState),context=context()},frames=0,packets={},size=0}
    end
end
function R.afterStageInit()
    R.inLogic=false
    if R.pending and R.pending.frames==0 then R.complete() end
end
function R.beforeLogic()
    if R.failure then return false end
    if R.pauseAfterRender then return false end
    if R.recoveryStopped then R.recoveryStopped=nil;return false end
    if not R.enabled then return true end
    R.inLogic=true;R.inputDown={};R.inputLast=rawLast() or 0
    if R.recovering then
        local bytes=R.playback;local p=R.position
        R.actionByte,R.inputLast=bytes:byte(p,p+1)
        local count=assert(bytes:byte(p+2),'续玩输入已结束')
        for i=p+3,p+2+count do R.inputDown[bytes:byte(i)]=true end
        R.position=p+3+count
    end
    return true
end
function R.readInput(state)
    if not R.recovering then return false end
    Byte2KeyState(state,R.actionByte);if replayWriter then replayWriter:Record(state) end;return true
end
function R.afterLogic()
    if not R.enabled then return end
    R.inLogic=false;R.logicClock.ticks=R.logicClock.ticks+1
    local session=R.session
    if not session or stage.next_stage or stage.current_stage.stage_name~=session.stage then return end
    session.frames=session.frames+1
    local keys={};for key in pairs(R.inputDown) do keys[#keys+1]=key end;table.sort(keys)
    local packet=string.char(R.recovering and R.actionByte or KeyState2Byte(KeyState),math.max(0,math.min(255,R.inputLast)),#keys)
    for _,key in ipairs(keys) do packet=packet..string.char(key) end
    session.packets[#session.packets+1]=packet;session.size=session.size+#packet
    if R.recovering then
        if session.frames==R.pending.frames then R.complete() end
    elseif session.frames==1 or session.frames%R.INTERVAL==0 then R.flush('自动') end
end
function R.flush(reason)
    local session=R.session
    if R.recovering or R.inLogic or not session or stage.next_stage or not stage.current_stage or stage.current_stage.stage_name~=session.stage then return false end
    local began=clock()
    local captured,encoded,committed
    local ok,err=pcall(function()
        assert(session.frames<=R.MAX_FRAMES and session.size<=R.MAX_INPUT,'续玩记录已达到容量上限')
        local data={format='BossRushResume',version=1,stage=session.stage,run=session.run,frames=session.frames,savedAt=os.time(),
            code=R.codeHash(),runtime=R.runtime(),start=session.start,target={stats=stats(),var=Serialize(lstg.var),music=clone(ext.music or {})},
            inputs=C.base64(table.concat(session.packets)),signature=R.signature()}
        if mask_fader then data.target.fader={time=math.max(0,mask_fader.time),maxtime=math.max(1,mask_fader.maxtime),mode=mask_fader.mode==true} end
        captured=clock();local token=R.encode(data);encoded=clock()
        P.atomic(P.path('resume.dat'),token);committed=clock()
        -- 成长内容已在终点快照内序列化；复用它，避免每两秒重复补齐并编码整张符卡表。
        local previous=R.lastGrowth or {};local root=P.userRoot()
        for _,item in ipairs({{'Score.dat','score'},{'Spellcard.dat','spell'}}) do
            local value=data.target.stats[item[2]]
            if previous.root~=root or previous[item[2]]~=value then P.write(item[1],C.lock(value)) end
        end
        R.lastGrowth={root=root,score=data.target.stats.score,spell=data.target.stats.spell}
        R.memo={path=P.path('resume.dat'),data=data};R.lastSaved=session.frames
    end)
    if not ok then R.message='续玩保存失败：'..tostring(err);log(R.message);return false end
    R.lastWriteMs=(clock()-began)*1000
    R.message='已保存关内位置（'..string.format('%.1f',session.frames/60)..' 秒）';R.messageUntil=clock()+4
    if reason~='自动' or R.lastWriteMs>50 then
        log(string.format('saved reason=%s frame=%d ms=%.1f capture=%.1f encode=%.1f commit=%.1f growth=%.1f',tostring(reason),session.frames,R.lastWriteMs,
            (captured-began)*1000,(encoded-captured)*1000,(committed-encoded)*1000,R.lastWriteMs-(committed-began)*1000))
    end
    return true
end
function R.request()
    local data,err=R.peek();assert(data,err or '没有关内续玩记录')
    assert(data.runtime==R.runtime(),'该关内续玩点来自不同引擎或平台，请使用关卡检查点继续')
    assert(data.code==R.codeHash(),'游戏脚本已更新，请使用关卡检查点继续；原续玩文件已保留')
    assert(stage.stages[data.stage] and not stage.stages[data.stage].is_menu,'保存的关卡尚未加载或已经移除')
    assert(not stage.next_stage,'正在切换场景，请稍后重试')
    local checked,bytes=R.validate(data);R.pending=clone(checked);R.playback=bytes;R.position=1;R.recovering=true;R.failure=nil;R.pauseAfterRender=nil
    R.savedAudio={se=setting.sevolume or 100,bgm=setting.bgmvolume or 100}
    local ok,message=pcall(stage.Set,'resume',data.stage)
    if not ok then R.recovering=false;R.pending=nil;R.playback=nil;error(message,0) end
    if rawSE then rawSE(0) end;if rawBGM then rawBGM(0) end
    ext.pause_menu:init();ext.pop_pause_menu=nil
    log('restore begin stage='..data.stage..' frames='..data.frames)
end
function R.complete()
    if R.failure then return end
    if R.signature()~=R.pending.signature then R.failure='重建状态与保存记录不一致，已停止恢复并保留原记录';return end
    applyStats(R.pending.target.stats)
    local function merge(target,source)
        for key in pairs(target) do if source[key]==nil then target[key]=nil end end
        for key,value in pairs(source) do
            if type(value)=='table' and type(target[key])=='table' then merge(target[key],value) else target[key]=value end
        end
    end
    merge(lstg.var,DeSerialize(R.pending.target.var))
    -- 转场按显示帧推进，重建逻辑时没有执行它；恢复保存时的状态，避免把入场遮罩缓存为暂停背景。
    if mask_fader then
        local f=R.pending.target.fader or {time=0,maxtime=30,mode=true}
        mask_fader.time,mask_fader.maxtime,mask_fader.mode=f.time,f.maxtime,f.mode
    end
    scoredata.resume_count=(scoredata.resume_count or 0)+1
    R.pendingMusic=R.pending.target.music
    R.recovering=false;R.pending=nil;R.playback=nil;R.recoveryStopped=nil
    if AndroidInput then AndroidInput.reset() end
    for name,value in pairs(R.pendingMusic or {}) do if PlayMusic then PlayMusic(name,1,(value.timer or 0)/60) end end
    if rawSE then rawSE((R.savedAudio and R.savedAudio.se or 100)/100) end;if rawBGM then rawBGM((R.savedAudio and R.savedAudio.bgm or 100)/100) end
    ext.pause_menu:init();ext.pop_pause_menu=nil;R.pauseAfterRender=true
    if AndroidPauseCache then AndroidPauseCache.invalidate() end
    if not R.flush('恢复完成') then SaveScoreData();SaveSpellCardData() end
    log('restore verified frame='..R.session.frames)
end
function R.afterRender()
    if not R.pauseAfterRender then return end
    -- 首次完整绘制提交后再启用暂停离屏缓存；此间不推进逻辑帧。
    R.pauseAfterRender=nil;ext.pause_menu:FlyIn()
    if AndroidPauseCache then AndroidPauseCache.invalidate() end
end
function R.cancel(message)
    local data=R.pending
    R.recovering=false;R.inLogic=false;R.enabled=false;R.pending=nil;R.session=nil;R.playback=nil;R.failure=nil;R.pauseAfterRender=nil
    if data then applyStats(data.target.stats) end
    if rawSE then rawSE((R.savedAudio and R.savedAudio.se or 100)/100) end;if rawBGM then rawBGM((R.savedAudio and R.savedAudio.bgm or 100)/100) end
    R.message=message or '已取消重建，原续玩记录仍保留';R.messageUntil=clock()+20
    ext.pause_menu:init();ext.pop_pause_menu=nil;stage.Set('none','menu');log(R.message)
end
function R.pump(step)
    if rawLast()==27 then R.cancel();return end
    local start=clock();local count=0
    while R.recovering and not R.failure and count<240 and clock()-start<0.016 do
        local ok,err=pcall(step)
        if not ok then R.failure='重建出错：'..tostring(err) end
        count=count+1
    end
    if R.failure then R.cancel(R.failure) end
end
function R.controls()
    if R.recovering then return end
    local key=rawLast()
    if key==116 then R.flush('手动') end
end
function R.draw()
    if not ui then return end
    if R.session and not R.recovering then
        SetImageState('white','',210,15,30,52);RenderRect('white',640,790,510,538)
        ui:RenderText('title','保存续玩点 F5',715,524,0.55,Color(255,210,235,255),'centerpoint')
    end
    if R.message and (not R.messageUntil or clock()<R.messageUntil) then ui:RenderText('title',R.message,480,490,0.5,Color(255,255,227,170),'centerpoint') end
end
function R.renderRecovery()
    BeginScene();SetViewMode('ui');RenderClear(Color(255,8,16,30))
    local done=R.session and R.session.frames or 0;local total=R.pending and R.pending.frames or 0
    ui:RenderText('title','正在重建关内续玩位置',480,300,1,Color(255,230,245,255),'centerpoint')
    ui:RenderText('title',string.format('%d / %d 帧 · %.0f%%',done,total,total>0 and done/total*100 or 100),480,250,0.7,Color(255,160,220,220),'centerpoint')
    ui:RenderText('title','按 ESC 取消；完成后停在暂停画面',480,200,0.55,Color(255,200,210,225),'centerpoint');EndScene()
end
R.applyStats,R.captureStats,R.applyContext=applyStats,stats,applyContext
SaveResume=R
return R
