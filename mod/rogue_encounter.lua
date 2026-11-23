-- 新作每场使用独立对象/关卡资源作用域，宿主自机与整局强化继续保留。
local M={}
local preload=dofile('mod/rogue_preload.lua')
M.checkpoint=preload.checkpoint
M.copyPrepared=preload.copy
M.preloadFrame=preload.frame
M.preloading=preload.active
M.prepareTexture=preload.texture
M.preloadIdle=preload.idle
local cached
-- 只保留最近一作，切换作品前全部释放，避免原作未加前缀的别名互相覆盖。
local cacheBudget=192*1024*1024
local function release(resources)
    for kind=9,1,-1 do for name in pairs(resources[kind] or {}) do
        lstg.RemoveResource('stage',kind,name)
    end end
end
local function discardCache()
    if not cached then return end
    if cached.level==36 and TH38 then TH38.background.releaseMeshes() end
    release(cached.resources);cached=nil
end
local rawNew=New
local ports=dofile('mod/rogue_ports.lua')
-- 随机模式整局使用同一底图；作品只叠加当前符卡背景。
local Backdrop=Class(object,{
    init=function(o)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.BG-1,false,false
        o.rogue_background,o.alpha=true,1
    end,
    render=function(o)
        SetViewMode('world')
        SetImageState('white','',255,9,13,22)
        local w=lstg.world;RenderRect('white',w.l,w.r,w.b,w.t)
        SetImageState('white','',255,255,255,255)
    end,
})
function M.enabled(level)
    local run=lstg.var.rogue_run
    return run and run.source_hp and run.encounter and (not level or run.encounter.level==level)
end
function M.spellOnly(level) return M.enabled(level) end
local function ensureBackground()
    local bg=lstg.tmpvar.bg
    if IsValid(bg) and bg.rogue_background then return end
    if IsValid(bg) then background.DelBG() end
    -- 不属于某一张卡的作用域，切卡回收不能把整局底图删除。
    lstg.tmpvar.bg=rawNew(Backdrop)
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
    M.stopping=true
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
    M.stopping=nil
    -- 必须先释放对象，再卸载其纹理；全局缓存仍由各作品按 CheckRes 复用。
    local current=stageResources()
    local owned=cached and cached.level==level and cached.resources or {}
    local bytes=0
    for kind=1,9 do
        owned[kind]=owned[kind] or {}
        for name in pairs(current[kind]) do
            if not scope.resources[kind][name] then owned[kind][name]=true end
        end
        for name in pairs(owned[kind]) do
            if not current[kind][name] then owned[kind][name]=nil
            elseif kind==1 then local w,h=GetTextureSize(name);bytes=bytes+w*h*4
            else bytes=bytes+1024 end
        end
    end
    if bytes<=cacheBudget then cached={level=level,resources=owned,bytes=bytes}
    else
        if level==36 and TH38 then TH38.background.releaseMeshes() end
        release(owned);cached=nil
    end
    if IsValid(player) then player.dialog=false;player.lock=false;player.ldX,player.ldY=nil,nil end
    if IsValid(lstg.tmpvar.bg) then
        lstg.tmpvar.bg.hide=false
        if lstg.tmpvar.bg.rogue_background then lstg.tmpvar.bg.alpha=1 end
    end
    lstg.tmpvar.boss=nil;_boss=nil
    scope.run.source_hp=false
end
function M.begin(scene,entry)
    M.stop(scene)
    if cached and cached.level~=entry.level then discardCache() end
    ensureBackground()
    local run=lstg.var.rogue_run
    local enabled=run.poolVersion>=10 and entry.level>=35 and entry.level<=41
    run.encounter,run.source_hp=entry,enabled
    run.source_damage=enabled and assert(ports.damageUnits[entry.level]) or nil
    run.source_boss_damage=enabled and ports.bossDamageUnits[entry.level] or nil
    if not enabled then return false end
    M.scope={entry=entry,run=run,objects={},resources=stageResources()}
    return true
end
function M.prepare(scene,entry,unit)
    if not M.scope then return end
    -- 无标记的既有录像/续玩继续原有同步入口，不插入等待用的逻辑帧。
    if lstg.var.__rogue_preload_version~=1 then return end
    local run=lstg.var.rogue_run
    local p=IsValid(player) and player
    local dialog,lock=p and p.dialog,p and p.lock
    if p then p.dialog,p.lock=true,true end
    run.preparing=true
    preload.run(function()
        local work=GameContent.ports[entry.level] or _editor_class[entry.source]
        if work and work.prepareRogue then work.prepareRogue(entry,unit) end
        for _,part in ipairs(unit.sc_group) do
            if part.boss.prepareRogue then part.boss.prepareRogue() end
            if part.card.prepareRogue then part.card.prepareRogue() end
        end
    end)
    run.preparing=nil
    if p and IsValid(p) then p.dialog,p.lock=dialog,lock end
end
function M.release()
    preload.clear()
    discardCache()
    for _,work in pairs({TH37,TH38,TH39,_editor_class.TH40}) do
        if work and work.background and work.background.clearPrepared then work.background.clearPrepared() end
    end
end
function M.deferBackground(fn)
    if not M.enabled(37) or lstg.var.__rogue_preload_version~=1 or preload.active() then return false end
    local run=lstg.var.rogue_run
    local p=IsValid(player) and player
    local dialog,lock=p and p.dialog,p and p.lock
    if p then p.dialog,p.lock=true,true end
    run.preparing=true
    preload.defer(function()
        fn()
        run.preparing=nil
        if p and IsValid(p) then p.dialog,p.lock=dialog,lock end
    end)
    return true
end
function M.frame(timer)
    if M.scope and timer%120==0 then
        for o in pairs(M.scope.objects) do if not IsValid(o) then M.scope.objects[o]=nil end end
    end
end
local function new(class,...)
    -- 原作道中入口也可能直接创建背景；跳过其构造器，保留可安全回收的空对象。
    local skip=class and class.rogue_stage_background and M.spellOnly(class.rogue_stage_background)
    if skip then class=object end
    local o=rawNew(class,...)
    if skip then o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true end
    -- _drop_owner 标记宿主自机弹与 Bomb；它们使用宿主资源，跨卡继续原来的寿命。
    if M.scope and not o._drop_owner then M.scope.objects[o]=true end
    return o
end
New,lstg.New=new,new
RogueEncounter=M
return M
