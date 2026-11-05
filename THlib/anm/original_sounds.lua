-- DirectSound单位为百分之一dB；保留原波形和逻辑SoundIdx，避免用同一弹声代替所有提示。
local S={played={}}
local entries=dofile('mod/GAME/original/sounds.lua')
function S.play(game,id,x)
    local entry=entries[game] and entries[game][id]
    if not entry then return end
    local scope=stage and stage.current_stage
    local timer=scope and scope.timer
    if S.scope~=scope or S.timer~=timer then S.scope,S.timer,S.played=scope,timer,{} end
    local key='th3x.original.'..game..'.'..id
    if S.played[key] then return end
    S.played[key]=true
    if not CheckRes('snd',key) then LoadSound(key,entry[1]) end
    PlaySound(key,10^(entry[2]/2000),math.max(-1,math.min(1,(x or 0)/192)))
end
return S
