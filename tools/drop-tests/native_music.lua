-- 使用正式九首音源和真实播放/暂停/停止API；快进逻辑音乐时钟检验完整三轮切换。
-- 不缩短loopend元数据，不把计时快进等同于实际听完歌曲。
local history,seen={},{}
local pausedChecked,resultCaptured=false,false
local function record(s)
    local id=s.current;local i=#history+1
    if (i-1)%#s.tracks==0 then seen={} end
    assert(not seen[id],'同一轮不能重复歌曲')
    assert(i==1 or history[i-1]~=id,'跨轮也不能连续播放同一首')
    seen[id]=true;history[i]=id
    local f=assert(io.open('music-native.jsonl','a'))
    f:write(Serialize({index=i,song=id,cycle=s.cycle,playing=GetMusicState(id),remaining=#s.remaining}),'\n');f:close()
end
local endScene=EndScene
EndScene=function()
    local result=endScene();local scene=stage.current_stage
    if scene and scene.stage_name==RogueTen.RESULT and scene.timer>=45 and not resultCaptured then
        local s=lstg.var.rogue_run.music
        assert(#history==27 and s.plays==27 and s.cycle==3,'实际完成三轮九首')
        assert(not s.active and not CheckRes('bgm',s.current),'结算停止并卸载战斗歌曲')
        assert(GetMusicState('SCORE')=='playing','结算曲正常播放，不参与随机曲库')
        local f=assert(io.open('music-result.json','w'))
        f:write(Serialize({history=history,cycle=s.cycle,plays=s.plays,stopped=true,pausedChecked=pausedChecked,score=GetMusicState('SCORE')}));f:close()
        Snapshot('snapshot/music-result.png');resultCaptured=true
    end
    return result
end
return function(host,frames,current)
    RogueTen.MISS_LIMIT=10
    local s=assert(lstg.var.rogue_run.music)
    if frames==1 then
        assert(#s.tracks==9 and s.plays==1 and s.current==host.class.bgm,'曲库九首，首曲沿用当前Boss')
        assert(GetMusicState(s.current)=='playing','真实音源已开始播放')
        record(s)
    end
    if frames%60~=0 or s.plays>=27 then return end
    if not pausedChecked then
        local id=s.current;local elapsed=s.elapsed
        PauseMusic(id)
        assert(GetMusicState(id)=='paused','真实音源暂停')
        ext.MusicFrame('timer',math.ceil(musicList[id][1]*120))
        assert(s.current==id and s.elapsed==elapsed,'暂停不扣播放时间、不切曲')
        ResumeMusic(id);assert(GetMusicState(id)=='playing','真实音源恢复')
        pausedChecked=true
    end
    local id=s.current;local ending=math.ceil(musicList[id][1]*60)
    ext.MusicFrame('timer',ending-s.elapsed-1)
    assert(s.current==id,'循环点前一帧仍播放当前曲')
    ext.MusicFrame('timer')
    assert(s.current~=id and GetMusicState(s.current)=='playing','循环点切到另一真实音源')
    assert(not CheckRes('bgm',id),'前一首音源已卸载，不叠播')
    record(s)
end
