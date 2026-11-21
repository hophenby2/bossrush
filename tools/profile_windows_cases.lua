-- Windows 原生定点采样。目录由 Python 驱动隔离，不读取源码目录的玩家数据。
local f=assert(io.open('case.json','rb'));local config=DeSerialize(f:read('*a'));f:close()
-- JSON null 代表未指定选项，不能把 cjson.null 当成机体 ID 或关卡编号传给正式入口。
for key,value in pairs(config) do if value==cjson.null then config[key]=nil end end
local result={case=config.case,frames={},stacks={}}
local finished,active=false,false
local watch=lstg.StopWatch()
local previous,clock=0,0
local BG,scene,R,controller,host
local frameFile=assert(io.open('frames.jsonl','wb'));frameFile:setvbuf('full',262144)
local checkpointFile=assert(io.open('checkpoints.jsonl','wb'));checkpointFile:setvbuf('full',262144)
local currentRow
local targetLevel=config.level or 37
local targetCard=config.card or 39060
local targetStage='Spell Practice@Spell Practice'
local function audioLevels()
    local bgm,se=lstg.GetBGMVolume(),lstg.GetSEVolume()
    assert(bgm==0 and se==0,'测试音量被重新开启')
    return bgm,se
end
local function flushRow()
    if currentRow then
        if config.engine_stats then
            assert(lstg.GetSourceFrameStatistics,'引擎缺少完整帧计时接口')
            currentRow.engine_wait_ms,currentRow.engine_update_ms,currentRow.engine_render_ms,
                currentRow.engine_present_ms,currentRow.engine_total_ms,currentRow.engine_pacer_ms,
                currentRow.engine_gpu_render_ms,currentRow.engine_present_busy=lstg.GetSourceFrameStatistics()
        end
        frameFile:write(Serialize(currentRow),'\n');currentRow=nil
    end
end
local function save(err)
    finished=true;result.error=err;flushRow();frameFile:close();checkpointFile:close()
    local out=assert(io.open('result.json','wb'));out:write(Serialize(result));out:close()
end
if config.case=='target-query' then
    local C=dofile('mod/GAME/ports/source_csharp.lua').new()
    local actorCollision=dofile('THlib/native_actor_collision.lua')
    local native=assert(lstg.FindSourceTargetInList,'缺少目标列表查询接口')
    local noop=function() end
    local class={is_class=true,noop,noop,noop,noop,noop,noop}
    function GameInit()
        local list={};local seed=21971
        local function value() seed=seed*16807%2147483647;return (seed/2147483647-.5)*1000 end
        for i=0,31 do
            local o=New(class);o.x,o.y=value(),value();o.a,o.b=2+i,3+i;o.bound=false;o.colli=true
            list[i]={object=o,index=i}
        end
        list[32]={object={},index=32}
        local custom=list[0].object;local meta=getmetatable(custom)
        local customMeta={};for k,v in pairs(meta) do customMeta[k]=v end
        customMeta.__index=function(o,k) if k=='x' then return lstg.GetAttr(o,k)+17.25 end;return lstg.GetAttr(o,k) end
        setmetatable(custom,customMeta)
        local checks=0;local views=setmetatable({},{__mode='k'})
        for _,scale in ipairs({1,2/3}) do
            local cx,cy=scale==1 and 224 or 336,scale==1 and 240 or 360
            local function reference(px,py,extend)
                for i=0,32 do local w=list[i];local o=w.object
                    if IsValid(o) and o.colli then
                        local c=o.native_actor_collision
                        if not (c and c.noDamage) then
                            local p=C.Vector2(o.x/scale+cx,cy-o.y/scale)
                            local a,b=c and c.damage[1] or o.a,c and c.damage[2] or o.b
                            if math.abs(px-p.X)<=a/scale+extend and math.abs(py-p.Y)<=b/scale+extend then return w end
                        end
                    end
                end
            end
            for n=1,12000 do
                local i=n%32;local o=list[i].object
                o.x,o.y=value(),value();o.colli=n%7~=0
                o.native_actor_collision=n%2==0 and {noDamage=n%11==0,damage={o.a/2,o.b/3}} or nil
                if n%10==0 and lstg.SetSourceActorDamageShape then
                    local c=o.native_actor_collision
                    actorCollision.bind(o,c.damage[1],c.damage[2],'box')
                end
                -- 标准元表上的原始同名字段也必须优先于引擎值。
                if i==1 then rawset(o,'x',n%3==0 and 99.123456789 or nil) end
                local mt=getmetatable(o);local shape=o.native_actor_collision
                list[i].nativeQueryFields=mt and mt.__index==lstg.GetAttr and rawget(o,'x')==nil and rawget(o,'y')==nil and rawget(o,'colli')==nil
                    and shape and getmetatable(shape)==nil or false
                list[i].nativeQueryShape=shape
                local extend=n%5;local px,py=value(),value()
                if n%3==0 then
                    local c=o.native_actor_collision
                    local a,b=c and c.damage[1] or o.a,c and c.damage[2] or o.b
                    px=C.f(o.x/scale+cx)+(n%2==0 and -1 or 1)*(a/scale+extend)
                    py=C.f(cy-o.y/scale)+(b/scale+extend)*(n%4==0 and 1 or 0)
                    if n%13==0 then px=px+1e-10 end
                end
                if n%131==0 then px=0/0 elseif n%137==0 then py=math.huge end
                assert(reference(px,py,extend)==native(list,33,px,py,extend,scale,cx,cy),'原生目标顺序或判定边界不同：'..n)
                assert(reference(px,py,extend)==native(list,33,px,py,extend,scale,cx,cy,true),'准备列表的目标顺序或判定边界不同：'..n)
                if lstg.CreateSourceTargetView then
                    local view=lstg.CreateSourceTargetView(list,33);views[view]=true
                    assert(reference(px,py,extend)==native(view,33,px,py,extend,scale,cx,cy,true),'原生目标视图的顺序或判定边界不同：'..n)
                    checks=checks+1
                end
                checks=checks+2
            end
        end
        assert(native({},0,0,0,0,1,0,0)==nil)
        collectgarbage('collect');collectgarbage('collect');assert(next(views)==nil,'目标视图没有回收')
        result.target_query_checks=checks
        result.audio_bgm,result.audio_se=audioLevels()
    end
    local check=GameInit
    GameInit=function() local good,err=xpcall(check,debug.traceback);if not good then save(err) end end
    function FrameFunc() if finished then return true end;clock=clock+1;if clock>=config.frames then save();return true end;return false end
    function RenderFunc() BeginScene();RenderClear(Color(255,20,30,40));EndScene() end
    function GameExit() end
    function FocusLoseFunc() end
    function FocusGainFunc() end
    return
end
if config.case=='frame-pacing' then
    local ffi=require('ffi');ffi.cdef('void __stdcall Sleep(unsigned long);')
    result.recovery_min_ms,result.fast_recovery_frames=1e9,0
    function GameInit() SetFPS(config.fps);previous=watch:GetElapsed() end
    function FrameFunc()
        flushRow();clock=clock+1
        local now=watch:GetElapsed();local elapsed=(now-previous)*1000;previous=now
        currentRow={frame=clock,interval_ms=elapsed}
        if clock>=62 and clock<=67 or clock>=102 and clock<=107 or clock>=142 and clock<=147 then
            result.recovery_min_ms=math.min(result.recovery_min_ms,elapsed)
            if elapsed<12 then result.fast_recovery_frames=result.fast_recovery_frames+1 end
        end
        if clock>=config.frames then save();return true end
        return false
    end
    function RenderFunc()
        BeginScene();RenderClear(Color(255,30,40,60));EndScene()
        if clock==60 or clock==100 then ffi.C.Sleep(90) end
        if clock==140 then ffi.C.Sleep(240) end
    end
    function GameExit() end
    function FocusLoseFunc() end
    function FocusGainFunc() end
    return
end
if config.case=='image-state' or config.case=='object-image-state' then
    local native=assert(lstg.SetSourceImageStateRGBA,'缺少数字颜色接口')
    result.rgba_calls=0
    lstg.SetSourceImageStateRGBA=function(...)
        result.rgba_calls=result.rgba_calls+1;return native(...)
    end
    dofile('THlib/lib/Lresources.lua')
    local probeObject
    local colors={{255,255,255,255},{255,255,178.5,178.5},{0,0,0,0},{127.9,90.2,166.7,211.3},
        {-1,300,99.99,33.4},{300,-40,256,128.8},{1,1,1,1},{254.99,222.8,18.7,70.1}}
    function GameInit()
        SetFPS(config.fps);SetResourceStatus('global')
        LoadTexture('probe','Resources/th43/effect/white.png')
        local w,h=GetTextureSize('probe')
        for _,name in ipairs({'old','new'}) do LoadImage(name,'probe',0,0,w,h) end
        if config.case=='object-image-state' then
            assert(RenderSourceObjectImage,'缺少对象绘制接口')
            local noop=function() end
            local class={is_class=true,noop,noop,noop,noop,noop,noop}
            probeObject=New(class);probeObject.bound=false;probeObject.colli=false;probeObject.group=0
            SetImageCenter('old',5,11);SetImageCenter('new',5,11)
        end
        for i=1,2000 do SetImageState('new','',127+i%100,123.4,201.8,77.9) end
        collectgarbage('collect');collectgarbage('stop')
        local before=collectgarbage('count')
        for i=1,10000 do SetImageState('new','',127+i%100,123.4,201.8,77.9) end
        result.rgba_heap_kb=collectgarbage('count')-before;collectgarbage('restart')
        assert(result.rgba_heap_kb<32,'数字颜色接口仍逐次创建临时对象')
    end
    function FrameFunc() clock=clock+1;if clock>=config.frames then save();return true end;return false end
    function RenderFunc()
        BeginScene();SetViewport(0,960,0,720);SetScissorRect(0,960,0,720);SetOrtho(0,960,0,720)
        SetZBufferEnable(0);RenderClear(Color(255,25,39,55))
        for i=0,95 do
            local c=colors[i%#colors+1];local blend=({'','mul+add','add+alpha'})[math.floor(i/8)%3+1]
            OriginalSetImageState('old',blend,Color(unpack(c)))
            if not probeObject then
                if math.floor(i/24)%2==0 then SetImageState('new',blend,unpack(c))
                else SetImageState('new',blend,Color(unpack(c)));SetImageState('new',blend,unpack(c)) end
            end
            local x,y=224+(i%8)*64,72+math.floor(i/8)*48
            if probeObject then
                probeObject.x,probeObject.y=x+12,y+12
                probeObject.rot=({0,13.3333333,-180.2,359.999,2532.1234567})[i%5+1]
                probeObject.hscale=(i%2==0 and 1 or -1)*(0.8+i%4*.07)
                probeObject.vscale=(i%3==0 and -1 or 1)*(.9+i%4*.04)
                for side=0,1 do
                    if clock==3 then Render('old',probeObject.x,probeObject.y,probeObject.rot,probeObject.hscale,probeObject.vscale)
                    else RenderSourceObjectImage('new',probeObject,blend,unpack(c)) end
                    probeObject.x=probeObject.x+32
                end
            else
                RenderRect(clock==3 and 'old' or 'new',x,x+24,y,y+24);RenderRect('new',x+32,x+56,y,y+24)
            end
        end
        EndScene()
        if clock==3 then Snapshot('snapshot/image-state-old.png')
        elseif clock==4 then Snapshot('snapshot/image-state-new.png') end
    end
    function GameExit() end
    function FocusLoseFunc() end
    function FocusGainFunc() end
    return
end
if config.case=='window' then
    local input=assert(io.open('launcher.lua','rb'));local source=input:read('*a');input:close()
    local first=assert(source:find('function ChangeVideoMode2(set)',1,true))
    local last=assert(source:find('local function start_game()',first,true))
    assert(loadstring(source:sub(first,last-1)))()
    result.states={}
    local function state(label)
        local window=lstg.Window.getMain()
        local size=window:getClientAreaSize()
        result.states[#result.states+1]={label=label,width=size.width,height=size.height,style=window:getStyle()}
    end
    function GameInit() state('initial') end
    function FrameFunc()
        clock=clock+1
        if clock==60 then result.fullscreen=ChangeVideoMode2({resx=480,resy=640,windowed=false,vsync=false})
        elseif clock==70 then state('fullscreen')
        elseif clock==120 then result.windowed=ChangeVideoMode2({resx=480,resy=640,windowed=true,vsync=false})
        elseif clock==130 then state('windowed') end
        if clock>=config.frames then
            local last=result.states[#result.states]
            local full=result.states[2]
            save(not (result.windowed and result.fullscreen and last.style~=0 and last.width==480 and last.height==640) and '未从全屏恢复为指定尺寸窗口' or nil)
            return true
        end
        return false
    end
    function RenderFunc() BeginScene();RenderClear(Color(255,30,40,60));EndScene() end
    function GameExit() end
    function FocusLoseFunc() end
    function FocusGainFunc() end
    return
end
lstg.DoFile('game-core.lua')
local initialize=GameInit
local function start()
    SetResourceStatus('global');lstg.ResetPool()
    stage.current_stage=nil
    if config.case=='th37-stage6' then
        if config.cpu then lstg.CreateSourceModelMesh=nil;lstg.RenderSourceModelMeshes=nil end
        BG=dofile('mod/GAME/th37/background.lua')
        if config.warm then BG.prepare(6,config.clock) end
        scene={state=BG.State.new(6,config.clock)}
        result.nativeMesh=type(lstg.RenderSourceModelMeshes)=='function'
        result.meshCalls,result.meshCommands=0,0
        if result.nativeMesh then
            local native=lstg.RenderSourceModelMeshes
            lstg.RenderSourceModelMeshes=function(list)
                result.meshCalls=result.meshCalls+1;result.meshCommands=result.meshCommands+#list
                return native(list)
            end
        end
    elseif config.case=='th39-39060' then
        ran:Seed(20261121)
        local function timed(name,fn)
            return function(...)
                local begin=watch:GetElapsed();local a,b=fn(...)
                if clock>0 then
                    local key=tostring(clock);local ops=result.operations[key] or {};result.operations[key]=ops
                    local op=ops[name] or {calls=0,ms=0};ops[name]=op
                    op.calls=op.calls+1;op.ms=op.ms+(watch:GetElapsed()-begin)*1000
                end
                return a,b
            end
        end
        if config.operations then
            result.operations={};New=timed('new',New)
            if lstg.CopySourceTable then lstg.CopySourceTable=timed('copy',lstg.CopySourceTable) end
        end
        R=dofile('mod/GAME/th39/runtime.lua');InitAllClass()
        if config.operations then
            for i=1,100 do
                local name,value=debug.getupvalue(R.tick,i);if not name then break end
                if name=='emitter' or name=='field' or name=='emit' then debug.setupvalue(R.tick,i,timed(name,value)) end
            end
        end
        -- 固定靶位仅用于对比弹幕更新/绘制，不模拟自机碰撞结算。
        player=New(object);player.x,player.y=0,-160
        player.grazer=New(object);player.grazer.a=0
        host=New(object);host.x,host.y=0,90
        R.prepareFamiliars({{51,99900}})
        controller=R.controller(host,'64991',false,{{51,99900}})
        result.checkpoints={}
    end
    if config.sample then
        local profiler=require('jit.profile')
        profiler.start('li1',function(thread,samples,state)
            local stack=state..' '..profiler.dumpstack(thread,'pl',12)
            result.stacks[stack]=(result.stacks[stack] or 0)+samples
        end)
    end
    if config.trace then
        result.traces={};local pending={};local util=require('jit.util')
        jit.attach(function(event,id,fn)
            if event=='start' then
                local info=util.funcinfo(fn)
                pending[id]={frame=clock,begin=watch:GetElapsed(),source=info.source,line=info.linedefined}
            elseif event=='stop' or event=='abort' then
                local row=pending[id]
                if row then
                    row.event=event;row.ms=(watch:GetElapsed()-row.begin)*1000;row.begin=nil
                    result.traces[#result.traces+1]=row;pending[id]=nil
                end
            end
        end,'trace')
    end
    SetFPS(config.fps);active=true;previous=watch:GetElapsed()
end
function GameInit()
    local ok,err=xpcall(function()
        if config.jit_default then require('jit.opt').start('maxtrace=1000','maxmcode=2048','maxside=100')
        elseif config.jit_cache then require('jit.opt').start('maxtrace=8192','maxmcode=16384','maxside=1024') end
        if config.full_game and config.trace then
            result.traces={};local pending={};local util=require('jit.util')
            jit.attach(function(event,id,fn,pc,reason,detail)
                if event=='flush' then result.traces[#result.traces+1]={frame=clock,event='flush'}
                elseif event=='start' then
                    local info=util.funcinfo(fn)
                    pending[id]={frame=clock,begin=watch:GetElapsed(),source=info.source,line=info.linedefined,id=id}
                elseif event=='stop' or event=='abort' then
                    local row=pending[id]
                    if row then
                        row.event=event;row.ms=(watch:GetElapsed()-row.begin)*1000;row.begin=nil
                        if event=='abort' then row.reason=reason;row.detail=type(detail)=='number' and detail or nil
                        else local info=util.traceinfo(id);row.linktype=info and info.linktype end
                        result.traces[#result.traces+1]=row;pending[id]=nil
                    end
                end
            end,'trace')
        end
        initialize()
        setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting))
        Include('mod/root.lua');InitAllClass();InitGameSaveData();stage.next_stage=stage.stages.init
        local frame,render=FrameFunc,RenderFunc
        if config.full_game then
            assert(config.case=='th39-39060' or config.case=='practice' or config.case=='catalogue' or config.case=='sequence','未知完整练习采样')
            local phases,hookRuntime,profileStarted,lanternHooked,practiceEntered
            local shootingKeys={shoot=true}
            local heldHp=setmetatable({},{__mode='k'})
            local function keepHp(b)
                if not b or not IsValid(b) or type(b.hp)~='number' or b.hp<=0 then return end
                local phase=b.current_card or b.portPhase
                local record=heldHp[b]
                if not record or record.phase~=phase then record={phase=phase,hp=b.hp};heldHp[b]=record end
                b.hp=record.hp
            end
            if config.shoot then
                local input=GetInput
                GetInput=function(...)
                    input(...)
                    if active then KeyState.shoot=true end
                end
            end
            if config.frame_detail then
                local function wrap(owner,key,label)
                    local fn=owner and owner[key];if type(fn)~='function' then return end
                    owner[key]=function(...)
                        local begin=watch:GetElapsed();local a,b=fn(...)
                        if phases then phases[label]=(phases[label] or 0)+(watch:GetElapsed()-begin)*1000 end
                        return a,b
                    end
                end
                for _,key in ipairs({'ObjFrame','CollisionCheck','BoundCheck','UpdateXY','AfterFrame'}) do wrap(_G,key,key) end
                for _,key in ipairs({'beforeLogic','afterLogic'}) do wrap(SaveResume,key,'resume.'..key) end
                for _,key in ipairs({'beforeObjects','afterObjects'}) do wrap(GameRank,key,'rank.'..key) end
                for _,key in ipairs({'begin','shots','finish'}) do wrap(NativeActorCollision,key,'actor.'..key) end
                local attached37,attached38,attached39,attachedPlayer
                hookRuntime=function()
                    if TH37 and TH37.runtime and not attached37 then
                        wrap(TH37.runtime,'beginCollisions','th37.begin');wrap(TH37.runtime,'finishCollisions','th37.finish');attached37=true
                    end
                    if TH38 and TH38.runtime and not attached38 then
                        wrap(TH38.runtime,'tick','th38.tick');attached38=true
                    end
                    if TH39 and TH39.runtime and not attached39 then
                        wrap(TH39.runtime,'tick','th39.tick');wrap(TH39.runtime,'tickBackground','th39.background');attached39=true
                    end
                    if not attachedPlayer and NativePlayers.adapters[targetLevel] then
                        wrap(NativePlayers.adapters[targetLevel],'frame','native.player');attachedPlayer=true
                    end
                end
                wrap(GameDrops,'frame','drops')
            end
            FrameFunc=function()
                if finished then return true end
                flushRow()
                local good,quit=xpcall(function()
                    if player and IsValid(player) then
                        player.protect=120
                        if config.shield and clock==600 then
                            -- 原 Protect 将计时设为 90；隔离夹具只固定触发时刻，不改消弹算法。
                            player.mhj_source.lantern.protectTime=90
                        end
                        if config.shoot then
                            player.key=shootingKeys
                            keepHp(_boss)
                            for _,b in ObjList(GROUP.ENEMY) do
                                if b.current_card and b.maxhp then keepHp(b) end
                            end
                            if targetLevel==40 then
                                local source=GameContent.ports[40].source
                                if source.runtime then keepHp(source.runtime.boss) end
                            end
                            if targetLevel==37 and TH39 and TH39.runtime then for c in pairs(TH39.runtime.controllers) do
                                local o=c.host
                                if o and IsValid(o) then local b=o.owner or o
                                    if IsValid(b) and b.mhj3_card then keepHp(b) end
                                end
                            end end
                        end
                    end
                    if config.lantern and not lanternHooked and NativePlayers and NativePlayers.adapters[37] then
                        local bridge
                        for i=1,20 do
                            local key,value=debug.getupvalue(NativePlayers.adapters[37].frame,i)
                            if not key then break end;if key=='B' then bridge=value;break end
                        end
                        if bridge then
                            local main=bridge.CS.env.Main;local charge=bridge.CS.env.InputKeys.Charge
                            local pressed,up=main.IsKeyPressed,main.IsKeyUp
                            main.IsKeyPressed=function(key) if key==charge and clock>=600 and clock<604 then return true end;return pressed(key) end
                            main.IsKeyUp=function(key) if key==charge and clock>=600 and clock<604 then return false end;return up(key) end
                            lanternHooked=true
                        end
                    end
                    if hookRuntime then hookRuntime() end
                    phases=config.frame_detail and {} or nil
                    local begin=watch:GetElapsed();local stop=frame();local elapsed=(watch:GetElapsed()-begin)*1000
                    local current=stage.current_stage
                    if active and practiceEntered and ext.pause_menu and not ext.pause_menu:IsKilled() then
                        result.ended_at=clock;result.end_reason='正式练习已进入结算/暂停菜单';save();return true
                    end
                    if not active and current and current.stage_name=='menu' and current.timer>=45 then
                        local practice=dofile('mod/original_practice.lua')
                        if config.case=='catalogue' then
                            result.catalogue={}
                            for _,game in ipairs(practice.stages) do
                                local entry={code=game.code,level=game.level,title=game.title,cards={},machines={}}
                                for _,m in ipairs(NativePlayers.machines(game.level) or {}) do entry.machines[#entry.machines+1]={id=m.id,name=m.name} end
                                for _,row in ipairs(practice.cards(game.level)) do
                                    local u=row.unit;local card=u.sc_group[1].card
                                    entry.cards[#entry.cards+1]={index=row.index,id=card.card_id,name=card.name,title=u.CardName,
                                        t1=card.t1,t2=card.t2,t3=card.t3,hp=card.hp,spell=card.is_sc,chapter=row.chapter,difficulty=row.difficulty}
                                end
                                result.catalogue[#result.catalogue+1]=entry
                            end
                            result.audio_bgm,result.audio_se=audioLevels();save();return true
                        end
                        if config.case=='sequence' then
                            local route=assert(OriginalSequence.catalog.get(config.sequence))
                            assert(route.level==targetLevel,'顺序路线与 level 不一致')
                            targetStage=route.battle
                            OriginalSequence.start(config.sequence,config.machine,nil,config.chapter)
                        else
                            local index
                            for _,row in ipairs(practice.cards(targetLevel)) do if row.unit.sc_group[1].card.card_id==targetCard then index=row.index end end
                            assert(index,'未注册练习 '..targetLevel..':'..targetCard)
                            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
                            lstg.var.sc_index,lstg.var.sc_group=index,{targetLevel,index}
                            assert(stage.group.PracticeStart(targetStage,true,config.machine)~=false)
                        end
                        lstg.var.ran_seed=20261121
                        if lstg.nextvar then lstg.nextvar.ran_seed=20261121 end
                        active=true;SetFPS(config.fps)
                    elseif active and current and current.stage_name==targetStage then
                        practiceEntered=true
                        clock=clock+1
                        if config.sample and not profileStarted and clock>=300 then
                            local profiler=require('jit.profile');profileStarted=true
                            profiler.start('li1',function(thread,samples,state)
                                local stack=state..' '..profiler.dumpstack(thread,'pl',12)
                                result.stacks[stack]=(result.stacks[stack] or 0)+samples
                            end)
                        end
                        currentRow={frame=clock,stage_frame=current.timer,logic_ms=elapsed,
                            bullets=targetLevel==37 and TH39.runtime.bulletCount or nil,objects=GetnObj(),fps=GetFPS(),
                            level=targetLevel,card=config.case~='sequence' and targetCard or nil,
                            native_machine=lstg.var.native_player_id,sequence_machine=lstg.var.sequence_player,
                            sequence_resources=SequenceResources.enabled(),heap_kb=collectgarbage('count')}
                        currentRow.phases=phases
                        currentRow.player_shoot=player and IsValid(player) and
                            (player._playersys and player._playersys.keyState.shoot or KeyState.shoot) or false
                        local lantern=player and IsValid(player) and player.mhj_source and player.mhj_source.lantern
                        if lantern then
                            currentRow.lantern_status,currentRow.lantern_power,currentRow.lantern_energy=lantern.Status,lantern.Power,lantern.Energy
                        end
                        currentRow.score=lstg.var.score
                        currentRow.audio_bgm,currentRow.audio_se=audioLevels()
                        if clock%300==0 then
                            currentRow.patterns={}
                            for c in pairs(targetLevel==37 and TH39.runtime.controllers or {}) do
                                local card=c.host and IsValid(c.host) and (c.host.current_card or c.host.owner and c.host.owner.current_card)
                                currentRow.patterns[#currentRow.patterns+1]={id=c.pattern.id,time=c.time,
                                    card=card and card.card_id,card_clock=c.host and IsValid(c.host) and c.host.mhj3_card and c.host.mhj3_card.clock}
                            end
                            if targetLevel==40 then
                                local rt=GameContent.ports[40].source.runtime
                                if rt then
                                    currentRow.source_runtime={frame=rt.frame,complete=rt.complete,enemy_count=rt.enemyCount}
                                    local b=rt.boss
                                    if b and IsValid(b) then
                                        currentRow.source_runtime.boss={kind=b.spawnType,phase=b.portPhase,age=b.age,
                                            hp=b.hp,maxhp=b.maxhp,countdown=b.countdown,combat=b._bmCombat,targetable=b.targetable,active=b.active}
                                    end
                                end
                            end
                        end
                        if clock>=config.frames then save();return true end
                    elseif active and practiceEntered then
                        result.ended_at=clock;result.end_stage=current and current.stage_name
                        save();return true
                    end
                    return stop
                end,debug.traceback)
                if not good then save(quit);return true end
                return quit
            end
            RenderFunc=function()
                if finished then return end
                local begin=watch:GetElapsed();local good,err=xpcall(render,debug.traceback)
                if not good then save(err);return end
                local row=currentRow
                if active and row then row.render_ms=(watch:GetElapsed()-begin)*1000 end
                if config.capture and active and row and (clock==120 or clock%600==0) then
                    Snapshot('snapshot/frame'..clock..'.png')
                end
            end
            return
        end
        FrameFunc=function()
            if finished then return true end
            flushRow()
            local good,quit=xpcall(function()
                if not active then
                    local stop=frame()
                    if stage.current_stage and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=45 then start() end
                    return stop
                end
                clock=clock+1
                if clock>config.frames then save();return true end
                local now=watch:GetElapsed()
                local row={frame=clock,wall_ms=(now-previous)*1000};previous=now
                currentRow=row
                local begin=watch:GetElapsed()
                if config.gc_probe then
                    if clock==1300 or clock==3230 or clock==5150 then collectgarbage('stop') end
                    if clock==1340 or clock==3260 or clock==5180 then collectgarbage('restart') end
                    row.heap_kb=collectgarbage('count')
                end
                if BG then
                    BG.State.step(scene.state,false)
                    if scene.state.mode=='music' then scene.state.mode='boss' end
                    row.background_time=scene.state.time;row.particles=#scene.state.particles
                elseif R then
                    if clock==961 then controller=R.replace(controller,host,'64992',false,{{51,99900}}) end
                    R.tick(controller)
                    row.controller_ms=(watch:GetElapsed()-begin)*1000
                    ObjFrame();AfterFrame(1)
                    row.bullets=R.bulletCount
                elseif clock==90 then result.fullscreen=ChangeVideoMode(960,720,false,false)
                elseif clock==150 then result.windowed=ChangeVideoMode(960,720,true,false) end
                row.logic_ms=(watch:GetElapsed()-begin)*1000
                local burstCheckpoint=config.rich_checkpoints and
                    (clock>=1320 and clock<=1323 or clock>=3239 and clock<=3242 or clock>=5159 and clock<=5162)
                if R and config.checkpoints and (clock%(config.checkpoint_step or 600)==0 or burstCheckpoint) then
                    local states={}
                    local function rounded(n) return math.floor(n*1000000+.5)/1000000 end
                    for object,s in pairs(controller.bullets) do
                        if IsValid(object) then
                            local entry={s.serial,s.type,s.age,rounded(s.fx),rounded(s.fy),
                                rounded(s.sonspeed or 0),rounded(s.sonspeedd or 0)}
                            if config.rich_checkpoints then
                                local state={}
                                for _,key in ipairs({'parentid','layerid','life','mx','my','ax','ay','head','wscale','hscale',
                                    'colorR','colorG','colorB','alpha','sonaspeed','sonaspeedd','xscale','yscale',
                                    'Mist','Dispel','Blend','Afterimage','Outdispel','Invincible','status','statusFrame','dis','typeChanged'}) do
                                    local value=s[key];state[key]=type(value)=='number' and rounded(value) or value
                                end
                                local attributes={}
                                for _,key in ipairs({'x','y','vx','vy','a','b','rot','hscale','vscale','group','layer','rect','colli','_a','_r','_g','_b','_blend','img'}) do
                                    local value=object[key];attributes[key]=type(value)=='number' and rounded(value) or value
                                end
                                entry.state,entry.attributes,entry.changes,entry.limits=state,attributes,s.changes,s.limits
                            end
                            states[#states+1]=entry
                        end
                    end
                    table.sort(states,function(a,b) return a[1]<b[1] end)
                    checkpointFile:write(Serialize({frame=clock,serial=controller.serial,states=states}),'\n')
                end
                return false
            end,debug.traceback)
            if not good then save(quit);return true end
            return quit
        end
        RenderFunc=function()
            if finished then return end
            local good,message=xpcall(function()
                if not active then render();return end
                local row=currentRow;if not row then return end
                local begin=watch:GetElapsed()
                BeginScene();SetViewMode('world');RenderClearViewMode(Color(255,0,0,0))
                if not config.no_draw then
                    if BG then BG.class.render(scene) elseif R then ObjRender() end
                end
                EndScene();row.render_ms=(watch:GetElapsed()-begin)*1000
                if config.capture and clock==120 then Snapshot('snapshot/frame120.png') end
                row.fps=GetFPS()
            end,debug.traceback)
            if not good then save(message) end
        end
    end,debug.traceback)
    if not ok then save(err);FrameFunc=function() return true end end
end
function GameExit() end
function FocusLoseFunc() end
function FocusGainFunc() end
