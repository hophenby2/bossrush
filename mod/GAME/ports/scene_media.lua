-- 同人作品的原曲登记、切换和淡出。
local M={}
function M.bgm(scene,id,seconds)
    if scene.sequence_music==id then return end
    if scene.sequence_music then StopMusic(scene.sequence_music) end
    scene.sequence_music=id
    if id and (not GetMusicState or GetMusicState(id)~='playing') then PlayMusic(id,1,seconds) end
end

function M.music(game,cues)
    local prefix=('TH%d_'):format(game)
    for id,track in pairs(dofile(('mod/GAME/th%d/media_tracks.lua'):format(game))) do
        AddMusic(prefix..('%02d'):format(id),track[1],track[2],prefix..id,true)
    end
    local T={}
    function T.track(number,kind)
        local cue=cues[number]
        return prefix..('%02d'):format(assert(cue[kind] or cue.boss))
    end
    function T.play(scene,number,kind,seconds)
        M.bgm(scene,T.track(number,kind),seconds)
    end
    function T.fade(scene,seconds)
        local id=scene.sequence_music
        if not id then return end
        task.New(scene,function()
            local frames=math.max(1,math.floor(seconds*60))
            for i=1,frames do
                if scene.sequence_music~=id then return end
                SetBGMVolume(id,1-i/frames)
                task.Wait()
            end
            if scene.sequence_music==id then M.bgm(scene,nil) end
        end)
    end
    return T
end
return M
