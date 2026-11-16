local M=dofile('mod/GAME/ports/scene_media.lua')
local cues={}
for i=1,8 do
    local cue=i<=6 and i*2 or i==7 and 16 or 19
    cues[i]={road=cue,boss=cue+1,last=14}
end
return M.music(37,cues)
