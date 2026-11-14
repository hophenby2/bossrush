local M=dofile('mod/GAME/ports/scene_media.lua')
local Background=dofile('mod/GAME/th38/background.lua')
local sets={}
local spells={{'1boss'},{'2boss',.2},{'3boss'},{'4near',.25},{'5boss',.22},{'6boss',.2},{'7boss',.23}}
for i,spell in ipairs(spells) do
    sets[i]={road=Background.load(i),drawRoad=Background.road(i),spells={[2]={spell}}}
end
local cues={}
for i=1,7 do
    local cue=i==7 and 16 or i*2
    cues[i]={road=cue,boss=cue+1,last=i==6 and 18 or nil}
end
return M.install(38,sets,cues)
