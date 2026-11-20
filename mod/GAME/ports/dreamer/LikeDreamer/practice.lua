-- 直接恢复目标攻击的开放初态，不播放先前攻击及其超时转场。
return function(entries)
local M={}
LikeDreamer.Practice=M
local function copy(value,objects)
    if type(value)~='table' then return value end
    if value.__enemy_id then return assert(objects[value.__enemy_id],'练习节点引用缺失') end
    local result={};for key,item in pairs(value) do result[key]=copy(item,objects) end
    return result
end
function M.inCombat(actor)
    if actor.spawnType==0x14c then return actor.targetable end
    return actor._bmCombat or actor._bePhaseMode==1
end
function M.start(rt,source)
    local entry=assert(entries[source.type] and entries[source.type][source.phase],'缺少攻击练习初态')
    local objects={}
    for _,fields in ipairs(entry.objects) do
        rt.nextEntityId=fields.entityId
        objects[fields.entityId]=assert(rt:spawn(fields.spawnType,fields.maxhp,fields.ldX,fields.ldY,'原作攻击练习初态'))
    end
    local alive=0
    for _,fields in ipairs(entry.objects) do
        local actor=objects[fields.entityId]
        for key,value in pairs(fields) do actor[key]=copy(value,objects) end
        actor.parent=objects[fields.parentEntityId]
        if fields.active then alive=alive+1 else
            rt.enemiesById[actor.entityId]=nil;object.RawDel(actor)
        end
    end
    local root=assert(objects[entry.root_id])
    rt.nextEntityId,rt.enemyCount=entry.next_id,alive
    rt.boss,rt.gate,rt.complete=root,true,false
    rt.frame=source.first+entry.spawn_delay+entry.elapsed
    if entry.world then
        local context=LikeDreamer.Recovered.context(rt,root)
        for key,value in pairs(entry.world) do context.state[key]=copy(value,objects) end
        context.state.rootObject,context.state.rootEntityId=root,root.entityId
    end
    return root
end
return M
end
