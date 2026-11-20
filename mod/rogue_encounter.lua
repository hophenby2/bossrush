-- 新作每场使用独立对象/关卡资源作用域，宿主自机与整局强化继续保留。
local M={}
local rawNew=New
local ports=dofile('mod/rogue_ports.lua')
function M.enabled(level)
    local run=lstg.var.rogue_run
    return run and run.source_hp and run.encounter and (not level or run.encounter.level==level)
end
local function stageResources()
    local out={}
    for kind=1,9 do
        local _,names=lstg.EnumRes(kind)
        out[kind]={}
        for _,name in ipairs(names or {}) do out[kind][name]=true end
    end
    return out
end
function M.stop(scene)
    local scope=M.scope
    if not scope then return end
    M.scope=nil
    if IsValid(lstg.tmpvar.bg) and scope.objects[lstg.tmpvar.bg] then background.DelBG() end
    -- RawDel 只标记删除；本帧后续的物理更新仍可能枚举到这些对象。
    -- 先隔离碰撞和回调，防止已清理的道中协程继续出生对象/读取纹理音效。
    for o in pairs(scope.objects) do if IsValid(o) then
        o.colli,o.hide=false,true
        SetAttr(o,'colli',false)
        o.group=GROUP.GHOST
        task.Clear(o)
        o.class=object
    end end
    local level=scope.entry.level
    local work=GameContent.ports[level] or _editor_class[scope.entry.source]
    if work and work.stop then work.stop() end
    local r=work and work.runtime
    if r and r.clearAll then r.clearAll() end
    if level==35 and TH37 then TH37.runtime.clearAll();TH37.background.endSpell() end
    if level==36 and TH38 then TH38.runtime.clearAll() end
    if level==37 and TH39 then TH39.runtime.clearAll() end
    for o in pairs(scope.objects) do
        if level==38 and IsValid(o) and o.th38_run then _editor_class.TH40.native.stop(o) end
        if IsValid(o) then object.RawDel(o) end
    end
    for i=#boss_group,1,-1 do
        if scope.objects[boss_group[i]] or not IsValid(boss_group[i]) then table.remove(boss_group,i) end
    end
    if NativeTime then NativeTime.reset() end
    if scene.sequence_music then StopMusic(scene.sequence_music);scene.sequence_music=nil end
    if scene.now_music then StopMusic(scene.now_music);scene.now_music=nil end
    -- 必须先释放对象，再卸载其纹理；全局缓存仍由各作品按 CheckRes 复用。
    local current=stageResources()
    for kind=9,1,-1 do for name in pairs(current[kind]) do
        if not scope.resources[kind][name] then lstg.RemoveResource('stage',kind,name) end
    end end
    if IsValid(player) then player.dialog=false;player.lock=false;player.ldX,player.ldY=nil,nil end
    lstg.tmpvar.boss=nil;_boss=nil
    scope.run.source_hp=false
end
function M.begin(scene,entry)
    M.stop(scene)
    local run=lstg.var.rogue_run
    local enabled=run.poolVersion>=10 and entry.level>=35 and entry.level<=41
    run.encounter,run.source_hp=entry,enabled
    run.source_damage=enabled and assert(ports.damageUnits[entry.level]) or nil
    run.source_boss_damage=enabled and ports.bossDamageUnits[entry.level] or nil
    if not enabled then return false end
    if IsValid(lstg.tmpvar.bg) then background.DelBG() end
    M.scope={entry=entry,run=run,objects={},resources=stageResources()}
    return true
end
function M.frame(timer)
    if M.scope and timer%120==0 then
        for o in pairs(M.scope.objects) do if not IsValid(o) then M.scope.objects[o]=nil end end
    end
end
local function new(class,...)
    local o=rawNew(class,...)
    -- _drop_owner 标记宿主自机弹与 Bomb；它们使用宿主资源，跨卡继续原来的寿命。
    if M.scope and not o._drop_owner then M.scope.objects[o]=true end
    return o
end
New,lstg.New=new,new
RogueEncounter=M
return M
