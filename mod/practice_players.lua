-- 练习统一只选一次机体；带来源的key区分项目灵梦与各作灵梦。
local P={}
function P.candidates(level)
    local rows={}
    for _,m in ipairs(player_list) do
        rows[#rows+1]={key='project:'..m[2],id=m[2],name='项目机体 · '..m[1],kind='project',route=m[2],replay=m[3]}
    end
    local game=SequenceResources.gameByLevel[level]
    local native=game and SequenceResources.machines(game) or NativePlayers.machines(level) or {}
    for _,m in ipairs(native) do
        rows[#rows+1]={key='original:'..m.id,id=m.id,name='原作机体 · '..m.name,kind=game and 'classic' or 'native',machine=m}
    end
    return rows
end
function P.resolve(level,key)
    for _,m in ipairs(P.candidates(level)) do if m.key==key or m.kind~='project' and m.id==key then return m end end
    error('练习机体不属于当前作品：'..tostring(level)..'/'..tostring(key))
end
function P.default(level,previous)
    local first
    for _,m in ipairs(P.candidates(level)) do
        if m.key==previous then return m.key end
        if not first and m.kind~='project' then first=m.key end
    end
    return assert(first,'练习缺少原作机体：'..tostring(level))
end
function P.route(level,group)
    local chapter
    if group then for _,row in ipairs(OriginalStageFlow.units(level)) do if row.index==group[2] then chapter=row.chapter;break end end end
    for _,entry in ipairs(OriginalSequence.catalog.entries) do
        if entry.level==level and (not chapter or OriginalSequence.catalog.chapterAllowed(entry,chapter,'reimu_player')
            or OriginalSequence.catalog.chapterAllowed(entry,chapter,'marisa_player')) then return entry.key end
    end
    error('练习缺少原作路线：'..level)
end
function P.configure(level,key,loadout,route)
    local v=lstg.var
    local m=P.resolve(level,key)
    v.practice_player=m.key
    v.__original_practice_version,v.__sequence_system_version,v.original_resources=nil,nil,nil
    v.th38_route,v.theis_route=nil,nil
    NativePlayers.configure(nil)
    v.current_system=''
    if m.kind=='project' then
        v.player_name,v.rep_player,v.sequence_player=m.route,m.replay,nil
    elseif m.kind=='native' then
        NativePlayers.configure(level,m.id,loadout)
        v.sequence_player=m.id
    else
        v.sequence_key=route or P.route(level,v.sc_group)
        v.sequence_player=m.id
        v.player_name,v.rep_player=m.machine.route,m.machine.name
        v.__sequence_system_version=SequenceResources.VERSION
        v.__original_practice_version=1
        v.__drops_version=0
    end
    return m
end
return P
