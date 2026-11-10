-- 私有性能诊断：按逻辑帧记录真实对象/弹池/ANM，并可做采样和仅绘制消融。
-- 消融不是玩家选项；正常启动不加载本模块，不改发弹、运动、判定或回收。
local P={rows={},slots={calls=0,scanned=0,failed=0,max_scan=0,seconds=0},births=0,stacks={},states={},aborts={},abort_reasons={},flushes=0}
local clock=lstg.AndroidClock
local utils=require('jit.util')
local function sorted(map,limit)
    local rows={}
    for key,count in pairs(map) do rows[#rows+1]={key=key,count=count} end
    table.sort(rows,function(a,b) return a.count>b.count or a.count==b.count and a.key<b.key end)
    while #rows>(limit or 100) do rows[#rows]=nil end
    return rows
end
function P.install(mode)
    P.mode=mode
    if mode:match('batch=1') and lstg.AndroidBatchProfile then
        lstg.AndroidBatchProfile(true);P.batches=true
    end
    if mode:match('jit=off') then jit.off();jit.flush() end
    P.jit_version=jit.version;P.jit_enabled=jit.status()
    local cls=_editor_class.TH35
    local free=cls.t10_free_bullet_slot
    cls.t10_free_bullet_slot=function()
        local cursor=cls.t10_bullet_cursor
        local start=clock();local slot=free();local elapsed=clock()-start
        local scanned=slot and ((slot-cursor)%2000+1) or 2000
        local s=P.slots
        s.calls=s.calls+1;s.scanned=s.scanned+scanned;s.seconds=s.seconds+elapsed
        s.max_scan=math.max(s.max_scan,scanned)
        if not slot then s.failed=s.failed+1 end
        return slot
    end
    local new=OriginalANM.new
    OriginalANM.new=function(...)
        P.births=P.births+1
        return new(...)
    end
    if mode:match('draw=native_off') then lstg.AndroidRenderSprite=function() end
    elseif mode:match('draw=anm_off') then OriginalANM.draw=function() end end
    if mode:match('sampling=1') then
        local ok,profile=pcall(require,'jit.profile')
        if ok then
            P.profile=profile
            local callback=function(thread,n,state)
                local key=state..' '..profile.dumpstack(thread,'pl;',6)
                P.stacks[key]=(P.stacks[key] or 0)+n;P.states[state]=(P.states[state] or 0)+n
            end
            jit.off(callback,true);profile.start('li10',callback)
        else P.sampling_error=tostring(profile) end
    end
    if mode:match('trace=') then
        P.trace=function(event,number,fn,pc,reason,extra)
            if event=='flush' then P.flushes=P.flushes+1;return end
            if event~='abort' then return end
            local error_key=tostring(reason)
            P.abort_reasons[error_key]=(P.abort_reasons[error_key] or 0)+1
            if not mode:match('trace=1') then return end
            local info=utils.funcinfo(fn,pc)
            local key=(info and info.source or '?')..':'..tostring(info and info.currentline)..' pc='..tostring(pc)..' reason='..tostring(reason)..' extra='..tostring(extra)
            P.aborts[key]=(P.aborts[key] or 0)+1
        end
        jit.off(P.trace,true)
        jit.attach(P.trace,'trace')
    end
    lstg.SystemLog('BOSSRUSH_PROBE_BEGIN: jit='..tostring(jit.status())..' sampling='..tostring(P.profile~=nil))
end
function P.after(scene)
    if not scene or scene.stage_name~='RogueTen@RogueTen' or scene.timer%60~=0 then return end
    local row={frame=scene.timer,objects=0,bullets=0,active=0,polar=0,cull_delayed=0,outside=0,
        despawning=0,effects=0,vm={},groups={},lua_kb=collectgarbage('count'),births=P.births}
    local b=_boss and IsValid(_boss) and _boss
    row.card=b and b.current_card and b.current_card.card_id;row.hp=b and b.hp
    for group=0,15 do
        local count=0
        for _,o in ObjList(group) do
            count=count+1;row.objects=row.objects+1
            if o._original_despawning then row.despawning=row.despawning+1 end
            local tb=o.tb
            if tb then
                row.bullets=row.bullets+1
                if tb.spawn==0 then row.active=row.active+1 end
                if tb.af.polar then row.polar=row.polar+1 end
                if tb.cull>0 then row.cull_delayed=row.cull_delayed+1 end
                if o.x < -192 or o.x>192 or o.y< -224 or o.y>224 then row.outside=row.outside+1 end
            end
            local vm=o._native_anm or o.vm
            if vm and vm.data and vm.data.key and vm.id then
                local key=vm.data.key..':'..vm.id
                row.vm[key]=(row.vm[key] or 0)+1
                if not tb then row.effects=row.effects+1 end
            end
        end
        row.groups[tostring(group)]=count
    end
    row.vm=sorted(row.vm,12)
    if P.batches then row.batches=lstg.AndroidBatchProfile(true) end
    if P.batches and lstg.AndroidSpriteClipStats then
        row.clip_tested,row.clip_culled=lstg.AndroidSpriteClipStats()
    end
    if P.batches and lstg.AndroidDrawCounts then row.draws,row.vertices=lstg.AndroidDrawCounts() end
    P.rows[#P.rows+1]=row
    lstg.SystemLog('BOSSRUSH_PROBE: '..Serialize(row))
end
function P.finish()
    if P.batches then lstg.AndroidBatchProfile(false) end
    if P.profile then P.profile.stop() end
    if P.trace then jit.attach(P.trace) end
    local report={mode=P.mode,jit_version=P.jit_version,jit_enabled=P.jit_enabled,rows=P.rows,slots=P.slots,anm_births=P.births,vm_states=P.states,
        stacks=sorted(P.stacks,80),trace_aborts=sorted(P.aborts,80),abort_reasons=P.abort_reasons,trace_flushes=P.flushes,sampling_error=P.sampling_error}
    if lstg.AndroidJitMcodeStats then report.mcode=lstg.AndroidJitMcodeStats() end
    local maps=io.open('/proc/self/maps','rb')
    if maps then report.process_maps=maps:read('*a');maps:close() end
    local file=assert(io.open('User/android-performance-probe.json','wb'))
    file:write(Serialize(report));file:close()
    lstg.SystemLog('BOSSRUSH_PROBE_DONE: rows='..#P.rows..' births='..P.births..' slot_scans='..P.slots.scanned)
end
return P
