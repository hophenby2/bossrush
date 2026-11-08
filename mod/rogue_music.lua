-- 随机模式的原有配乐按不重复袋轮播；计时沿用音频层的逻辑时钟，不借用弹幕随机源。
local M={VERSION=1}
local function state()
    local run=lstg.var.rogue_run
    return lstg.var.__rogue_music_version==M.VERSION and run and run.music
end
function M.tracks(pool)
    local seen,tracks={},{}
    for _,bucket in ipairs(pool) do for _,entry in ipairs(bucket.cards) do
        local unit=_sc_pr_table[entry.level][entry.index]
        for _,part in ipairs(unit.sc_group) do
            local id=part.boss.bgm
            if id and musicList[id] and musicList[id][1]>0 and not seen[id] then
                seen[id]=true;tracks[#tracks+1]=id
            end
        end
    end end
    table.sort(tracks)
    return tracks
end
function M.init(run,pool)
    if lstg.var.__rogue_music_version~=M.VERSION then return end
    run.music={tracks=M.tracks(pool),remaining={},seed=run.seed,draws=0,cycle=1,plays=0,active=false}
    for i,id in ipairs(run.music.tracks) do run.music.remaining[i]=id end
end
local function play(scene,s,id)
    PlayMusic(id)
    s.current,s.active,s.elapsed,s.last_timer=id,true,0,0
    s.plays=s.plays+1;scene.now_music=id
    if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_ROGUE_BGM: cycle='..s.cycle..' song='..id) end
end
function M.start(scene,id)
    local s=state();if not s or not id then return false end
    for i,track in ipairs(s.remaining) do
        if track==id then table.remove(s.remaining,i);play(scene,s,id);return true end
    end
    return false
end
function M.pick(s)
    if #s.remaining==0 then
        s.cycle=s.cycle+1
        for i,id in ipairs(s.tracks) do s.remaining[i]=id end
    end
    local choices={}
    for i,id in ipairs(s.remaining) do if id~=s.current then choices[#choices+1]=i end end
    if #choices==0 then return end -- 仅一首的历史/测试曲库保持原曲循环，不能制造不存在的曲目。
    s.draws=s.draws+1
    local gen=Rand();gen:Seed((s.seed+s.draws*104729)%2147483647)
    return table.remove(s.remaining,choices[gen:Int(1,#choices)])
end
function M.frame()
    local s=state();local scene=stage.current_stage
    if not s or not s.active or not scene or scene.is_menu or scene.rogue_finished or stage.next_stage then return end
    local run=lstg.var.rogue_run
    if run.finished then return end
    local clock=ext.music[s.current]
    if not clock then return end
    local now=clock.timer or 0
    local delta=math.max(0,now-(s.last_timer or now));s.last_timer=now
    local status=GetMusicState(s.current)
    if clock.paused or status=='paused' then return end
    if status~='playing' and status~='stopped' then return end
    s.elapsed=s.elapsed+delta
    -- 原引擎会在loopend自动回环，不能等待playing变成stopped才换曲。
    local ending=math.ceil(musicList[s.current][1]*60)
    if s.elapsed<ending and status~='stopped' then return end
    local id=M.pick(s)
    if id then StopMusic(s.current);play(scene,s,id)
    else s.elapsed=s.elapsed%ending end
end
function M.stop(scene)
    local s=state();if not s or not s.active then return end
    s.active=false
    StopMusic(s.current)
end
RogueMusic=M
return M
