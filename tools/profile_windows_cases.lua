-- Windows 原生定点采样。目录由 Python 驱动隔离，不读取源码目录的玩家数据。
local f=assert(io.open('case.json','rb'));local config=DeSerialize(f:read('*a'));f:close()
local result={case=config.case,frames={},stacks={}}
local finished,active=false,false
local watch=lstg.StopWatch()
local previous,clock=0,0
local BG,scene,R,controller,host
local frameFile=assert(io.open('frames.jsonl','wb'));frameFile:setvbuf('full',262144)
local checkpointFile=assert(io.open('checkpoints.jsonl','wb'));checkpointFile:setvbuf('full',262144)
local currentRow
local function flushRow()
    if currentRow then frameFile:write(Serialize(currentRow),'\n');currentRow=nil end
end
local function save(err)
    finished=true;result.error=err;flushRow();frameFile:close();checkpointFile:close()
    local out=assert(io.open('result.json','wb'));out:write(Serialize(result));out:close()
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
        initialize()
        setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting))
        Include('mod/root.lua');InitAllClass();InitGameSaveData();stage.next_stage=stage.stages.init
        local frame,render=FrameFunc,RenderFunc
        if config.full_game then
            assert(config.case=='th39-39060','完整练习采样目前只对应天月祝鸣')
            FrameFunc=function()
                if finished then return true end
                flushRow()
                local good,quit=xpcall(function()
                    if player and IsValid(player) then player.protect=120 end
                    local begin=watch:GetElapsed();local stop=frame();local elapsed=(watch:GetElapsed()-begin)*1000
                    local current=stage.current_stage
                    if not active and current and current.stage_name=='menu' and current.timer>=45 then
                        local index
                        for _,row in ipairs(TH39.units()) do if row.unit.sc_group[1].card.card_id==39060 then index=row.index end end
                        assert(index,'未注册天月祝鸣练习')
                        lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
                        lstg.var.sc_index,lstg.var.sc_group=index,{37,index}
                        assert(stage.group.PracticeStart('Spell Practice@Spell Practice',true)~=false)
                        active=true;SetFPS(config.fps)
                    elseif active and current and current.stage_name=='Spell Practice@Spell Practice' then
                        clock=clock+1
                        currentRow={frame=clock,stage_frame=current.timer,logic_ms=elapsed,
                            bullets=TH39.runtime.bulletCount,fps=GetFPS()}
                        if clock>=config.frames then save();return true end
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
                if R and config.checkpoints and clock%600==0 then
                    local states={}
                    local function rounded(n) return math.floor(n*1000000+.5)/1000000 end
                    for object,s in pairs(controller.bullets) do
                        if IsValid(object) then
                            states[#states+1]={s.serial,s.type,s.age,rounded(s.fx),rounded(s.fy),
                                rounded(s.sonspeed or 0),rounded(s.sonspeedd or 0)}
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
    if not ok then save(err) end
end
function GameExit() end
function FocusLoseFunc() end
function FocusGainFunc() end
