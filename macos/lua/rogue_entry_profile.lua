-- 仅显式诊断入口启用；真实 RogueTen、正常速度，分开记录逻辑/绘制与显示帧间隔。
local T={frames={},events={},cases={},ops={},calls={},seeks={},counters={},stacks={},parts={}}
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
    local speed=tonumber(os.getenv('BOSSRUSH_ENTRY_SPEED') or '1')
    local selected=os.getenv('BOSSRUSH_ENTRY_CARDS')
    local scan=os.getenv('BOSSRUSH_ENTRY_RUNTIME')=='1'
    local sampling=os.getenv('BOSSRUSH_ENTRY_RUNTIME_SAMPLE')=='1'
    local profile=sampling and require('jit.profile')
    local profileRunning=false
    if scan then
        local seed=tonumber(os.getenv('BOSSRUSH_ENTRY_SEED') or '20261120')
        local originalTime=os.time
        os.time=function(value) return value and originalTime(value) or seed end
        for _,name in ipairs({'ObjFrame','ObjRender','CollisionCheck','BoundCheck','UpdateXY','AfterFrame'}) do
            local fn=_G[name]
            _G[name]=function(...)
                local started=clock();local result={fn(...)}
                local row=T.parts[tostring(frameNumber)] or {};T.parts[tostring(frameNumber)]=row
                row[name]=(row[name] or 0)+(clock()-started)*1000
                return unpack(result)
            end
        end
    end
    local function stackSample(thread,n,state)
        local c=T.stacks[tostring(planIndex)] or {};T.stacks[tostring(planIndex)]=c
        local key=state..' '..profile.dumpstack(thread,'pl;',9)
        c[key]=(c[key] or 0)+n
    end
    if sampling then jit.off(stackSample,true) end
    local function stopSampling()
        if profileRunning then profile.stop();profileRunning=false end
    end
    local function counters()
        local row={case=planIndex,age=fightAge,groups={},objects=0,lua_kb=collectgarbage('count')}
        for group=0,15 do
            local n=0;for _,o in ObjList(group) do n=n+1 end
            row.groups[tostring(group)]=n;row.objects=row.objects+n
        end
        local run=_boss and IsValid(_boss) and _boss.th38_run
        if run then
            row.summer={objects=#run.objects,bullets=#run.bullets,enemies=#run.enemies,effects=#run.effects}
        end
        if lstg.AndroidDrawCounts then row.draws,row.vertices=lstg.AndroidDrawCounts() end
        T.counters[#T.counters+1]=row
    end
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
    local function verifyNativeSync()
        if not scan or not lstg.AndroidProjectBullet then return end
        local a,b=New(object),New(object)
        local count=0
        for i=1,240 do
            local img=i%3==0 and 'white' or 'ball_mid1'
            local x,y=i*.17-23,71-i*.23
            local rot,sx,sy=i*13.13,i%7*.17,i%11*.13
            local ra,rb=i%13*.19,i%17*.21
            local layer,group,collidable=-200+i%3,i%2==0 and GROUP.GHOST or GROUP.ENEMY_BULLET,i%4~=0
            a.img=img;a.x,a.y=x,y;a.vx,a.vy=0,0;a.rot=rot;a.hscale,a.vscale=sx,sy
            a.a,a.b=ra,rb;a.rect=false;a.layer,a.group,a.colli=layer,group,collidable
            b.vx,b.vy=17,-23
            lstg.AndroidProjectBullet(b,img,x,y,rot,sx,sy,ra,rb,layer,group,collidable)
            for _,key in ipairs({'img','x','y','vx','vy','rot','hscale','vscale','a','b','rect','layer','group','colli'}) do
                assert(a[key]==b[key],'批量同步与原setter不一致：'..i..'/'..key..' '..tostring(a[key])..'/'..tostring(b[key]))
                count=count+1
            end
        end
        object.RawDel(a);object.RawDel(b)
        T.native_sync_checks=count
    end
    local function build()
        verifyNativeSync()
        installContentHooks()
        local filters=RogueTen.defaultFilters()
        filters.difficulties.extra=true
        if selected or scan then filters.cards.survival=true end
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
        if selected then
            for id in selected:gmatch('%d+') do
                local chosen
                for _,bucket in ipairs(pool) do for _,e in ipairs(bucket.cards) do
                    if e.cardId==tonumber(id) then chosen=e end
                end end
                assert(chosen,'卡池没有指定卡号：'..id);plan[#plan+1]=chosen
            end
        else
            local codes=only and {only} or {'TH31','TH37','TH38','TH39','TH40','TH41','TH42','TH43'}
            for _,code in ipairs(codes) do
                local e=choose(code)
                for _=1,scan and 1 or only and 3 or 2 do
                    local copy={};for k,v in pairs(e) do copy[k]=v end
                    plan[#plan+1]=copy
                end
                if scan and code~='TH31' then
                    local last
                    for _,bucket in ipairs(pool) do if bucket.code==code then
                        for _,card in ipairs(bucket.cards) do
                            if card.kind=='boss' and (card.spell or code=='TH42') and not card.survival
                                and card.originalDifficulty=='lunatic' then last=card end
                        end
                    end end
                    if last and last.cardId~=e.cardId then plan[#plan+1]=last end
                end
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
    local function save(passed)

        local file=assert(io.open('User/rogue-entry-profile.json','wb'))
        file:write(Serialize({passed=passed,retain_resources=retain,window_frames=window,
            cases=T.cases,frames=T.frames,events=T.events,operations=T.ops,calls=T.calls,seeks=T.seeks,
            counters=T.counters,stacks=T.stacks,parts=T.parts,runtime_scan=scan,speed=speed,sampling=sampling,native_sync_checks=T.native_sync_checks}));file:close()
    end
    local function finish()
        stopSampling();save(true)
        lstg.SystemLog('ROGUE_ENTRY: 完成 '..#T.cases..' 个入场样本')
    end
    local originalFrame,originalRender=FrameFunc,RenderFunc
    local previousStart,previousRow
    local function step()
        AndroidFocus=function() end
        AndroidInput.keys={};AndroidInput.toggles={}
        frameNumber=frameNumber+1
        local started=clock()
        if previousRow then previousRow.wall_ms=(started-previousStart)*1000 end
        previousStart=started
        if IsValid(player) then player.protect=600 end
        if sampling and entry and fightAge>=180 and not RogueEncounter.preloading() and not profileRunning then
            profile.start('li10',stackSample);profileRunning=true
        end
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
                stopSampling()
                if scan and entry then save(false) end
                entry,age,fightAge=run.encounter,0,0
                if entry then
                    planIndex=planIndex+1
                    T.cases[#T.cases+1]={index=planIndex,source=entry.source,key=entry.key,
                        card_id=entry.cardId,title=entry.name or entry.title,first_frame=frameNumber}
                    lstg.SystemLog('ROGUE_ENTRY: '..planIndex..' '..entry.key)
                end
            end
            if entry then
                age=age+1
                if not run.preparing then fightAge=fightAge+1 end
                if scan and not run.preparing and fightAge%60==0 then counters() end
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
    function FrameFunc()
        for _=1,speed do if step() then return true end end
        return false
    end
    function RenderFunc()
        local started=clock()
        local result=originalRender()
        if previousRow then previousRow.render_ms=(clock()-started)*1000 end
        return result
    end
end
return T
