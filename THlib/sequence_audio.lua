-- 顺序模式按原作SoundIdx发声；UI仍使用项目菜单音，不把不同作品的波形混用。
local P=SequenceResources
local common={shoot=0,death=4,pickup=21,powerup=31,extend=28,graze=30,damage=20,damage_low=20,cast=14,countdown=29,countdown_low=29,cardget=false}
local modern={pickup=20,powerup=29,extend=44,graze=false,damage=19,damage_low=35,countdown=27,countdown_low=36,cardget=33}
function P.playOriginalSound(id,x)
    local s=P.state();if not s then return false end
    local sound=OriginalStageVisual and OriginalStageVisual.presentation and OriginalStageVisual.presentation.sound
    if sound then sound.play(s.game,id,x or player and player.x or 0);return true end
    return false
end
function P.systemSound(event,x)
    local game=P.game();if not game then return false end
    local id=common[event]
    if game==10 or game==95 then
        if modern[event]~=nil then id=modern[event] end
        if game==95 and event=='graze' then id=28 end
    end
    if game==8 then
        if event=='damage_low' then id=37 elseif event=='countdown_low' then id=38 elseif event=='cardget' then id=35 end
    end
    if event=='pickup_max' then id=game==8 and 44 or (game==10 and 20 or 21) end
    if id==false then return true end
    if id~=nil then return P.playOriginalSound(id,x) end
    return false
end
function P.loopOriginalSound(id,active,x)
    local game=P.game();if not game then return false end
    local key='th3x.original.'..game..'.'..id
    local loaded=CheckRes('snd',key)
    if active then
        if not loaded or GetSoundState(key)=='stopped' then P.playOriginalSound(id,x) end
    elseif loaded and GetSoundState(key)=='playing' then StopSound(key) end
    return true
end
function P.powerLevel(power,game)
    if game==10 then return math.floor(power/20) end
    local thresholds=game==8 and {8,24,48,80,128} or {8,16,32,48,64,80,96,128}
    local n=0;for _,limit in ipairs(thresholds) do if power>=limit then n=n+1 end end
    return n
end
function P.bombSound(p,b)
    local game,key,t=p.original_game,b.spec.key,b.time
    if game==10 then if t==0 then P.playOriginalSound(38,b.x) end;return end
    if game==6 or game==7 then
        if key=='reimua' and game==6 or key=='reimua_slow' then
            if t>=60 and t<180 and t%16==0 and math.floor((t-60)/16)>0 then P.playOriginalSound(13,p.x) end
        elseif key=='reimua' then
            if t>=8 and t<80 and t%6==0 then P.playOriginalSound(13,p.x) end
        elseif key=='sakuyaa_slow' then
            if t==0 then P.playOriginalSound(5,p.x) end
            if t>=20 and t<116 then P.playOriginalSound(6,p.x) end
        elseif key=='marisaa_slow' then
            if t%6==0 and t/6<24 then P.playOriginalSound(7,p.x) end
        elseif t==0 then
            local ids={reimub=6,reimub_slow=6,marisaa=6,marisab=19,marisab_slow=19,
                sakuyaa=5,sakuyaa_slow=5,sakuyab=19,sakuyab_slow=19}
            local id=ids[key]
            if id then P.playOriginalSound(id,p.x) end
        end
    elseif game==8 then
        local c=b.spec.character
        if t==0 then
            if c==1 then
                if b.spec.death then P.playOriginalSound(13,p.x) end;P.playOriginalSound(19,p.x)
            elseif c==2 or c==7 then P.playOriginalSound(5,p.x)
            else
                P.playOriginalSound(13,p.x)
                if c==3 or c==6 or c==5 and not b.spec.death then P.playOriginalSound(6,p.x) end
            end
        end
        if c==3 and t==70 then P.playOriginalSound(42,p.x) end
        if c==2 and t>=20 and t<(b.spec.death and 148 or 116) then P.playOriginalSound(6,p.x) end
    end
end
return P
