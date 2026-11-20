-- 仅显式诊断入口启用；真实 RogueTen、正常速度，分开记录逻辑/绘制与显示帧间隔。
local T={frames={},events={},cases={},ops={},calls={},seeks={}}
local clock=lstg.AndroidClock
local active,frameNumber=false,0
local contexts,main={},{}
local function idle() return RogueEncounter and RogueEncounter.preloadIdle() or 0 end
local retaining=false
local retain=os.getenv('BOSSRUSH_ENTRY_RETAIN')=='1'
local moving=os.getenv('BOSSRUSH_ENTRY_MOVE')=='1'
local function operation(name,fn)
    return function(...)
        if not active then return fn(...) end
        if (name=='Spring.Background.seek' or name=='Night.Background.seek') and RogueEncounter.preloading and RogueEncounter.preloading() then return fn(...) end
        if retain and retaining and name=='RemoveResource' then return end
        local thread=coroutine.running() or main
        local context=contexts[thread] or {depth=0,child={}};contexts[thread]=context
        context.depth=context.depth+1;local level=context.depth;context.child[level]=0
        local started,paused=clock(),idle()
        local result={fn(...)}
        local elapsed=(clock()-started-idle()+paused)*1000
        local own=elapsed-context.child[level]
        context.depth=context.depth-1
        if context.depth>0 then context.child[context.depth]=context.child[context.depth]+elapsed end
        local row=T.ops[name] or {count=0,ms=0,self_ms=0,max_ms=0}
        T.ops[name]=row
        row.count=row.count+1;row.ms=row.ms+elapsed;row.self_ms=row.self_ms+own
        row.max_ms=math.max(row.max_ms,elapsed)
        local frameKey=tostring(frameNumber)
        T.calls[frameKey]=T.calls[frameKey] or {}
        local calls=T.calls[frameKey]
        calls[name]=calls[name] or {count=0,ms=0,self_ms=0}
        calls[name].count=calls[name].count+1
        calls[name].ms=calls[name].ms+elapsed
        calls[name].self_ms=calls[name].self_ms+own
        if elapsed>=1 then
            local args={...}
            T.events[#T.events+1]={frame=frameNumber,op=name,ms=elapsed,self_ms=own,
                name=tostring(args[1]),path=type(args[2])=='string' and args[2] or nil}
        end
        return unpack(result)
    end
end
function T.boot()
    -- 在原作资源表保存函数引用之前安装，才能测到闭包内部的同步加载。
    for _,name in ipairs({'LoadTexture','LoadImage','LoadAnimation','LoadSound','LoadMusic',
        'LoadPS','LoadFX','LoadFont','LoadTTF','CreateRenderTarget','RemoveResource','DoFile',
        'CreateShaderProgramFromPath','AndroidCreateModelMesh'}) do
        if lstg[name] then
            local fn=operation(name,lstg[name]);lstg[name],_G[name]=fn,fn
            if name=='DoFile' then dofile=fn end
        end
    end
end
function T.install()
    ext.Debugging=function() end
    AndroidFocus=function() end
    -- 采集进程不接受真实菜单操作，避免键鼠改变固定路线。
    GetLastKey,lstg.GetLastKey=function() return KEY.NULL end,function() return KEY.NULL end
    local function syntheticKey(key) return AndroidInput.keys[key]==true end
    GetKeyState,lstg.GetKeyState=syntheticKey,syntheticKey
    GetMouseState,lstg.GetMouseState=function() return false end,function() return false end
    local phase,entry,age,fightAge=0,nil,0,0
    local plan={}
    local only=os.getenv('BOSSRUSH_ENTRY_SOURCE')
    local window=tonumber(os.getenv('BOSSRUSH_ENTRY_FRAMES') or '480')
    local planIndex=0
    local function installContentHooks()
        for _,name in ipairs({'begin','stop'}) do
            local fn=RogueEncounter[name]
            local wrapped=operation('encounter.'..name,fn)
            RogueEncounter[name]=function(...)
                local old=retaining
                if name=='stop' then retaining=true end
                local result={wrapped(...)}
                retaining=old
                return unpack(result)
            end
        end
        if RogueEncounter.deferBackground then
            local defer=RogueEncounter.deferBackground
            RogueEncounter.deferBackground=function(fn)
                local accepted=defer(fn)
                local c=T.cases[#T.cases]
                if accepted and c then c.background_reprepares=(c.background_reprepares or 0)+1 end
                return accepted
            end
        end
        local theis=GameContent.ports[39].source.lstg.ResourceSet
        theis.LoadByTag=operation('THEIS.LoadByTag',theis.LoadByTag)
        local dreamer=GameContent.ports[40].source.Resources
        dreamer.load=operation('Dreamer.Resources.load',dreamer.load)
        local spring=TH37.background.State
        spring.new=operation('Spring.Background.seek',spring.new)
        -- 永夜的背景模块为闭包；只给正式回调引用的同一个模块加计时，不替换其算法。
        local night
        for _,unit in ipairs(_sc_pr_table[37]) do
            local before=unit.sc_group[1].card.before
            if type(before)=='function' then
                for index=1,100 do
                    local name,value=debug.getupvalue(before,index)
                    if not name then break end
                    if name=='BG' then night=value;break end
                end
            end
            if night then break end
        end
        assert(night,'未找到永夜背景入口')
        local ticks,seeking=0,false
        local tick=TH39.runtime.tickBackground
        TH39.runtime.tickBackground=function(...)
            if seeking then ticks=ticks+1 end
            return tick(...)
        end
        local show=operation('Night.Background.seek',night.show)
        night.show=function(runtime,chapter,start)
            local c=T.cases[#T.cases]
            -- 在准备完成与真正创建场景之间强制改变坐标，确保覆盖失效快照路径。
            if moving and c and not c.position_change and IsValid(player) then
                c.position_change={from=player.x,to=player.x+24}
                player.x=player.x+24
            end
            local ok,profile=pcall(require,'jit.profile')
            local stacks={}
            local callback=function(thread,n,state)
                local key=state..' '..profile.dumpstack(thread,'pl;',7)
                stacks[key]=(stacks[key] or 0)+n
            end
            local sampling=ok and os.getenv('BOSSRUSH_ENTRY_SAMPLE')=='1'
            if sampling then jit.off(callback,true);profile.start('li10',callback) end
            local began=clock();ticks,seeking=0,true
            local result=show(runtime,chapter,start)
            seeking=false
            if sampling then profile.stop() end
            T.seeks[#T.seeks+1]={frame=frameNumber,start=start,background_ticks=ticks,
                ms=(clock()-began)*1000,stacks=stacks}
            return result
        end
    end
    local function build()
        installContentHooks()
        local filters=RogueTen.defaultFilters()
        filters.difficulties.extra=true
        local pool=RogueTen.buildPool(filters)
        local function choose(code)
            for _,bucket in ipairs(pool) do if bucket.code==code then
                for _,e in ipairs(bucket.cards) do
                    if e.kind=='boss' and (e.spell or code=='TH42') and not e.survival
                        and e.originalDifficulty=='lunatic' then return e end
                end
            end end
            error('没有入场样本：'..code)
        end
        local codes=only and {only} or {'TH31','TH37','TH38','TH39','TH40','TH41','TH42','TH43'}
        for _,code in ipairs(codes) do
            local e=choose(code)
            for _=1,only and 3 or 2 do
                local copy={};for k,v in pairs(e) do copy[k]=v end
                plan[#plan+1]=copy
            end
        end
        RogueTen.draw=function()
            local out={};for i,e in ipairs(plan) do out[i]=e end;return out
        end
        return filters
    end
    local function endCard()
        local scope=RogueEncounter.scope
        if entry.level==40 then
            local rt=GameContent.ports[40].source.runtime
            if rt and rt.boss and IsValid(rt.boss) then rt.boss.countdown=0 end
        elseif entry.level==39 and scope then
            for o in pairs(scope.objects) do
                if IsValid(o) and o.hp and o.hp<999999 and o.group~=GROUP.PLAYER then o.hp=0 end
            end
        else
            for _,b in ipairs(boss_group) do if IsValid(b) then b.hp=0 end end
        end
    end
    local function finish()
        local file=assert(io.open('User/rogue-entry-profile.json','wb'))
        file:write(Serialize({passed=true,retain_resources=retain,speed=1,window_frames=window,
            cases=T.cases,frames=T.frames,events=T.events,operations=T.ops,calls=T.calls,seeks=T.seeks}));file:close()
        lstg.SystemLog('ROGUE_ENTRY: 完成 '..#T.cases..' 个入场样本')
    end
    local originalFrame,originalRender=FrameFunc,RenderFunc
    local previousStart,previousRow
    function FrameFunc()
        AndroidFocus=function() end
        AndroidInput.keys={};AndroidInput.toggles={}
        frameNumber=frameNumber+1
        local started=clock()
        if previousRow then previousRow.wall_ms=(started-previousStart)*1000 end
        previousStart=started
        if IsValid(player) then player.protect=600 end
        local quit=originalFrame()
        local elapsed=(clock()-started)*1000
        local scene=stage.current_stage
        if phase==0 and scene and scene.is_menu and scene.timer>=90 and GameDebug.title and not GameDebug.title.locked then
            local filters=build()
            lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
            active=true;assert(RogueTen.start('single',filters));phase=1
        elseif phase==1 and scene and scene.stage_name==RogueTen.BATTLE then
            local run=lstg.var.rogue_run
            if run.completed>=#plan then finish();active=false;return true end
            if run.encounter~=entry then
                entry,age,fightAge=run.encounter,0,0
                if entry then
                    planIndex=planIndex+1
                    T.cases[#T.cases+1]={index=planIndex,source=entry.source,key=entry.key,
                        card_id=entry.cardId,first_frame=frameNumber}
                    lstg.SystemLog('ROGUE_ENTRY: '..planIndex..' '..entry.key)
                end
            end
            if entry then
                age=age+1
                if not run.preparing then fightAge=fightAge+1 end
                if fightAge>=window then endCard() end
            end
        end
        if active then
            local row={frame=frameNumber,case=planIndex,age=age,fight_age=fightAge,
                preparing=lstg.var.rogue_run and lstg.var.rogue_run.preparing or false,
                stage_timer=scene and scene.timer,player_timer=IsValid(player) and player.timer,logic_ms=elapsed}
            T.frames[#T.frames+1]=row;previousRow=row
        else previousRow=nil end
        return quit
    end
    function RenderFunc()
        local started=clock()
        local result=originalRender()
        if previousRow then previousRow.render_ms=(clock()-started)*1000 end
        return result
    end
end
return T
