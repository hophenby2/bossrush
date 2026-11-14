local M=dofile('mod/GAME/ports/scene_media.lua')
local sets={
    {road={{'1sky'},{'1lake',.27,255,{0,0,1,.65}},{'1ice',.65,175},{'1cloud',.09,120}},spells={[2]={{'1boss'}}}},
    {road={{'2sky'},{'2snow',.45,255,{0,0,1,.72}},{'2tree',.32,220,{-.14,.13,.45,1}}},spells={[2]={{'2boss',.2}}}},
    {road={{'3sky'},{'3star',.24,197},{'3lotus',.55,235}},spells={[2]={{'3boss'}}}},
    {road={{'4far'},{'4middle',.30,220},{'4near',.61,240}},spells={[2]={{'4near',.25}}}},
    {road={{'5sky'},{'5styx',.58},{'5shore',.45,220}},spells={[2]={{'5boss',.22}}}},
    {road={{'6sky'},{'6styx',.3,235},{'6lotus',.45,220}},spells={[2]={{'6boss',.2}}}},
    {road={{'7sky'},{'7ground',.3,255,{0,0,1,.52}},{'7star',.42,220}},spells={[2]={{'7boss',.23}}}},
}
local cues={}
for i=1,7 do
    local cue=i==7 and 16 or i*2
    cues[i]={road=cue,boss=cue+1,last=i==6 and 18 or nil}
end
return M.install(38,sets,cues)
