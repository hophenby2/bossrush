-- 私有content诊断：验证精简版五作的整关/符卡入口，不参与正常开局。
local T={}
local function installAudio(mode)
    lstg.SystemLog('BOSSRUSH_CONTENT_BEGIN: '..mode)
    local fu=cc.FileUtils:getInstance()
    local files=assert(loadstring(fu:getStringFromFile('game/asset_index.lua')))()
    local sounds,rows={},{}
    for _,path in ipairs(files) do if path:lower():match('%.wav$') then sounds[#sounds+1]=path end end
    local frame,index,done=FrameFunc,1,false
    local key='__android_audio_check'
    FrameFunc=function()
        local quit=frame()
        if not done and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=45 then
            if index>1 then StopSound(key);RemoveResource('global',5,key) end
            local path=sounds[index]
            if path then
                SetResourceStatus('global');LoadSound(key,path)
                local sound=assert(FindResSound(key),path)
                local info=sound:getInfo()
                assert(not info.no_source,'音效没有可用的解码源：'..path)
                rows[#rows+1]=table.concat({path,info.frames,info.channel,info.sample_rate,info.time},'\t')
                PlaySound(key,.01)
                index=index+1
            else
                local file=assert(io.open('User/android-audio-check.tsv','wb'))
                file:write(table.concat(rows,'\n'));file:close();done=true
                lstg.SystemLog('BOSSRUSH_CONTENT_DONE: audio='..#rows..' '..mode)
            end
        end
        return quit
    end
end
function T.install(mode)
    if mode:match('images=1') then dofile('android/image_probe.lua').install(mode);return end
    if mode:match('audio=1') then installAudio(mode);return end
    local sequenceKey=mode:match('sequence=([%w_]+)')
    local sequence=sequenceKey and assert(dofile('mod/sequence_catalog.lua').get(sequenceKey),'未知顺序验证入口')
    local level=sequence and sequence.level or assert(tonumber(mode:match('level=(%d+)')))
    local target=tonumber(mode:match('frames=(%d+)')) or 300
    local whole=mode:match('whole=1')~=nil
    local replayCheck=mode:match('replay=1')~=nil
    local shoot=mode:match('shoot=1')~=nil
    local afterMidboss=mode:match('after_midboss=1')~=nil
    local codes={[29]='TH31',[30]='TH32',[31]='TH33',[32]='TH34',[33]='TH35'}
    assert(codes[level],'不支持的内容验证关卡')
    scoredata.PlayerBrand=scoredata.PlayerBrand or 'Android内容验证';scoredata.version=ui.version
    local originalTime=os.time
    os.time=function(t) return t and originalTime(t) or 20261109 end
    local frame,after=FrameFunc,AfterFrame
    local started,done,replaying=false,false,false
    local snapshotComplete
    local name=sequence and sequence.battle or whole and codes[level]..'@BossRush' or 'Spell Practice@Spell Practice'
    FrameFunc=function()
        if player and IsValid(player) then player.protect=120 end
        AndroidInput.toggles.shoot=shoot;AndroidInput.keys[setting.keys.shoot]=shoot
        local quit=frame()
        if not started and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=45 then
            started=true
            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            lstg.var.current_system='';lstg.var.rogue_run=nil;lstg.var.timeslow=nil
            if sequence then assert(OriginalSequence.start(sequenceKey),'顺序入口拒绝验证请求')
            else
                if not whole then lstg.var.sc_group={level,1} end
                assert(stage.group.PracticeStart(name,not whole)~=false,'练习入口拒绝验证请求')
            end
            lstg.SystemLog('BOSSRUSH_CONTENT_BEGIN: '..mode)
        end
        return quit
    end
    AfterFrame=function(...)
        after(...)
        local scene=stage.current_stage
        if snapshotComplete and scene.timer>=snapshotComplete then
            snapshotComplete=nil
            lstg.SystemLog('BOSSRUSH_CONTENT_DONE: level='..level..' whole='..tostring(whole)..' frames='..scene.timer)
            ext.pop_pause_menu=true
        end
        if replaying and ext.replay.IsReplay() and scene.stage_name==name and scene.timer>=180 and scene.timer<target then
            done=true
            lstg.SystemLog('BOSSRUSH_CONTENT_DONE: replay=true level='..level..' frames='..scene.timer)
            ext.pop_pause_menu=true
        end
        if started and not done and scene.stage_name==name and scene.timer>=target then
            if sequence then
                assert(not GameHPScale.enabled() and GameHPScale.factor()==1,'顺序模式不能启用血量倍率')
                local upgrades=lstg.var.upgrades
                assert(not upgrades or upgrades.count==0 and #upgrades.queue==0,'顺序模式不能获得强化')
                if afterMidboss then
                    local run=lstg.var.sequence_run
                    local reached=(run.completed or 0)>0
                    local chapters=OriginalSequence.catalog.chapters(sequenceKey,lstg.var.player_name)
                    for _,row in ipairs(chapters[run.chapter].units) do if row.role=='boss' then
                        local id=row.unit.sc_group[1].card.card_id
                        for _,boss in ipairs(boss_group) do if boss.current_card and boss.current_card.card_id==id then reached=true end end
                    end end
                    assert(reached,'未从中Boss与连续道中推进到关底')
                    lstg.SystemLog('BOSSRUSH_SEQUENCE_POST_MIDBOSS: chapter='..run.chapter..' road_time='..run.road_time)
                end
            end
            if replayCheck and not replaying then
                local path='replay/__slim-content-check.rpy'
                plus.CreateDirectory('replay')
                local save=plus.ReplayManager.SaveReplayInfo
                plus.ReplayManager.SaveReplayInfo=function(_,info) return save(path,info) end
                ext.replay.SaveReplay({name},1,'SlimCheck',0)
                plus.ReplayManager.SaveReplayInfo=save
                assert(GameContent.supportsReplay(plus.ReplayManager.ReadReplayInfo(path)),'当前录像被内容边界错误拒绝')
                assert(stage.Set('load',path,name)~=false,'当前录像无法进入播放')
                replaying=true;return
            end
            if replaying then return end
            done=true
            if not plus.DirectoryExists('snapshot') then plus.CreateDirectory('snapshot') end
            Snapshot('snapshot/android-content.png')
            -- Snapshot在下一次RenderFunc执行；等它完成后再开暂停，避免截图被暂停模糊覆盖。
            snapshotComplete=scene.timer+3
            if sequence then
                local bg=scene.sequence_background
                lstg.SystemLog('BOSSRUSH_SEQUENCE_STATE: '..scene.sequence_background_key..' hidden='..tostring(bg.hide)..
                    ' position='..table.concat(bg.position,',')..' direction='..table.concat(bg.direction,',')..' time='..bg.time)
            end
        end
    end
end
return T
