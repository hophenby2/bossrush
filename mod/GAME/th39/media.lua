local M=dofile('mod/GAME/ports/scene_media.lua')
local cues={}
for i=1,8 do
    local cue=i>=7 and 16+(i-7)*2 or i*2
    cues[i]={road=cue,boss=i>=7 and 17 or cue+1,eirin=19,sakuya=20}
end
return M.music(39,cues)
