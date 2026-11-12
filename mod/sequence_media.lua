-- 顺序流程的原作STD、符卡背景与原曲。所有曲目独立注册，不改变随机局/菜单曲库。
local M={}
OriginalSequenceMedia=M
M.background=dofile('mod/sequence_background.lua')
M.music=dofile('mod/GAME/original/std/music.lua')
M.cues=dofile('mod/GAME/original/std/cues.lua')
for name,m in pairs(M.music) do AddMusic('ORIG_'..name,m.loop_end/m.rate,(m.loop_end-m.loop_start)/m.rate,name,true) end
local works={[29]=8,[30]=6,[31]=95,[32]=7,[33]=10}
local function location(chapter,row)
    local game=assert(works[chapter.level]);local name=chapter.name
    if game==95 then
        local c=row and row.unit.sc_group[1].card
        local file=c and c.original_ecl and c.original_ecl.file
        local enemy=file and tonumber(file:match('ecl(%d+)_'))
        local world=({[22]=5,[23]=6,[24]=9,[25]=10})[enemy]
        local index=world or tonumber(name) or 5
        local track=name=='EX' and 'th095_03' or index<=2 and 'th095_01' or index<=5 and 'th095_02' or index<=7 and 'th095_03' or 'th095_04'
        if file=='ecl21_d.ecl' then track='th09_08_2' end
        return game,('world%02d'):format(index),track,track
    end
    local index=name=='EX' and (game==8 and 8 or 7) or name=='PH' and 8 or tonumber(name)
    local key
    if game==8 then
        key=({['4A']='stage4a',['4B']='stage4b',['6A']='stage6',['6B']='stage7'})[name]
    end
    key=key or ('stage'..(game==10 and ('%02d'):format(index) or index))
    local data=dofile('mod/GAME/original/std/'..game..'_'..key..'.lua')
    local stageTrack,bossTrack
    -- 风神录的文件名顺序不同于曲目序号：th10_02是标题曲；原作StageDescriptor指定路径。
    if game==10 then
        local routes={{'th10_00','th10_01'},{'th10_03','th10_04'},{'th10_05','th10_06'},
            {'th10_07','th10_08'},{'th10_09','th10_10'},{'th10_11','th10_12'},{'th10_15','th10_16'}}
        stageTrack,bossTrack=unpack(assert(routes[index]))
    else stageTrack,bossTrack=data.music[1],data.music[2] end
    return game,key,stageTrack,bossTrack
end
local function play(scene,track)
    local id='ORIG_'..track
    assert(M.music[track],'顺序模式缺少原作音乐：'..track)
    if scene.sequence_music==id then return end
    if scene.sequence_music then StopMusic(scene.sequence_music) end
    PlayMusic(id)
    scene.sequence_music=id
    scene.sequence_music_fade=nil
end
function M.enter(scene,chapter,kind,row)
    if chapter.level==35 then return _editor_class.TH38.media(scene,chapter,kind,row) end
    local game,key,stageTrack,bossTrack=location(chapter,row)
    local changed=scene.sequence_background_key~=game..'/'..key or not scene.sequence_background or not IsValid(scene.sequence_background)
    -- 文花帖每幕独立启动原场景，EX的四个地点也各自取SceneSelect指定背景。
    if changed or game==95 and row then
        scene.sequence_background=New(M.background.class,game,key)
        scene.sequence_background_key=game..'/'..key
    end
    scene.sequence_chapter=chapter
    scene.sequence_default_music=kind=='boss' and bossTrack or stageTrack
    scene.sequence_last_card=nil
    play(scene,scene.sequence_default_music)
end
function M.frame(scene)
    if scene.level==35 then return _editor_class.TH38.mediaFrame(scene) end
    local chapter=scene.sequence_chapter
    if not chapter then return end
    for _,b in ipairs(boss_group) do
        local c=b.current_card
        if c and c~=scene.sequence_last_card and c.phase_kind~='road' then
            scene.sequence_last_card=c
            local id=c.source_card_id or c.card_id
            if chapter.level==30 and chapter.name=='3' and (id==3914 or id==3916 or id==3918) then
                M.background.signal(scene.sequence_background)
            elseif chapter.level==32 and chapter.name=='6' and id==4390 then
                M.background.signal(scene.sequence_background,1)
            elseif chapter.level==29 and ((chapter.name=='6B' and id>=392 and id<=396) or chapter.name=='6A' and id==408) then
                play(scene,'th08_13b')
            end
        end
    end
    local fade=scene.sequence_music_fade
    if fade then
        fade.time=fade.time+1;SetBGMVolume(scene.sequence_music,math.max(0,1-fade.time/fade.duration))
        if fade.time>=fade.duration then scene.sequence_music_fade=nil end
    end
end
function M.advance(owner,clock,state)
    local rows=M.cues[state.game] and M.cues[state.game][state.key]
    if not rows then return end
    local current=owner._sequence_media_cue
    if not current or current.state~=state then current={state=state,index=1};owner._sequence_media_cue=current end
    local scene=stage.current_stage
    while rows[current.index] and rows[current.index][1]<=clock do
        local cue=rows[current.index]
        if cue[2]=='signal' then M.background.signal(scene.sequence_background,cue[3])
        elseif cue[2]=='fade' then scene.sequence_music_fade={time=0,duration=cue[3]}
        elseif cue[2]=='resurrection' then play(scene,'th07_13b') end
        current.index=current.index+1
    end
end
function M.stop(scene)
    lstg.tmpvar.th38_random=nil;lstg.tmpvar.th38_phase=nil
    if scene.sequence_music then StopMusic(scene.sequence_music);scene.sequence_music=nil end
    scene.sequence_background=nil
    scene.sequence_background_key=nil
    scene.sequence_music_fade=nil
end
M.location=location
return M
