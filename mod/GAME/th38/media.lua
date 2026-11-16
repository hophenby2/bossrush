local M=dofile('mod/GAME/ports/scene_media.lua')
local cues={}
for i=1,7 do
    local cue=i==7 and 16 or i*2
    cues[i]={road=cue,boss=cue+1,last=i==6 and 18 or nil}
end
return M.music(38,cues)
