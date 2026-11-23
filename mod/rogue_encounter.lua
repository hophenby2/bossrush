-- 新作每场回收攻击对象；资源预加载复用，首个关卡背景、宿主自机与强化整局保留。
local M={}
local preload=dofile('mod/rogue_preload.lua')
function M.checkpoint() if not M.constructingBackground then preload.checkpoint() end end
M.copyPrepared=preload.copy
M.preloadFrame=preload.frame
M.preloading=preload.active
function M.prepareTexture(path)
    -- 整批预加载沿用旧作的直接纹理加载；按整批时间预算让出，不为每张小图启动线程并等显示帧。
    if not M.warming and not M.constructingBackground then preload.texture(path) end
end
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
    if cached.level==36 and TH38 and not (M.background and M.background.level==36) then TH38.background.releaseMeshes() end
    release(cached.resources);cached=nil
end
local rawNew=New
local ports=dofile('mod/rogue_ports.lua')
-- 与旧作一样，资源开局加载后复用。首个真实背景有整局独立的对象作用域。
local setPool=SetResourceStatus
local function resourcePool(value)
    if M.warming or M.backgroundActive then value='global' end
    return setPool(value)
end
SetResourceStatus,lstg.SetResourceStatus=resourcePool,resourcePool
function M.enabled(level)
    local run=lstg.var.rogue_run
    return run and run.source_hp and run.encounter and (not level or run.encounter.level==level)
end
function M.spellOnly(level) return M.enabled(level) and not M.backgroundActive end
function M.retainResources() return M.warming or M.residentReady end
function M.keepsBackground(o)
    local scope=M.backgroundActive or M.background
    return scope and scope.objects[o] or false
end
local backgroundClasses=setmetatable({},{__mode='k'})
local function protectBackground(o,scope)
    scope.objects[o]=true
    o.rogueBackgroundScope=scope
    local class=o.class
    if backgroundClasses[class] then o.class=backgroundClasses[class];return end
    local function callback(fn,tick)
        return function(o)
            local previous=M.backgroundActive
            local pool=GetResourceStatus()
            M.backgroundActive=o.rogueBackgroundScope
            if tick and o.rogueBackgroundTick then o.rogueBackgroundTick(o) end
            if fn then fn(o) end
            M.backgroundActive=previous
            setPool(pool)
        end
    end
    local function finish(fn)
        local wrapped=callback(fn)
        return function(o)
            local scope=o.rogueBackgroundScope
            local root=scope and scope.root
            if root and (o==root or o==root.Capturer1 or o==root.Capturer2) then object.Preserve(o);return end
            wrapped(o)
            -- 背景粒子仍按原寿命回收，只有主背景和捕获器保留到整局结束。
            if scope and o.status~='normal' then scope.objects[o]=nil;o.rogueBackgroundScope=nil end
        end
    end
    local proxy=Class(class,{
        frame=callback(class.frame or class[3],true),
        render=callback(class.render or class[4]),
        del=finish(class.del or class[2]),
        kill=finish(class.kill or class[6]),
    },true)
    if AndroidRegisterClass then AndroidRegisterClass(proxy) end
    backgroundClasses[class]=proxy
    o.class=proxy
end
local function restoreBackground()
    local bg=M.background and M.background.root
    if IsValid(bg) then lstg.tmpvar.bg=bg;bg.hide=false end
end
local function prepareResources(entry,unit)
    local work=GameContent.ports[entry.level] or _editor_class[entry.source]
    if work and work.prepareRogue then work.prepareRogue(entry,unit) end
    for _,part in ipairs(unit.sc_group) do
        if part.boss.prepareRogue then part.boss.prepareRogue() end
        if part.card.prepareRogue then part.card.prepareRogue() end
    end
end
local function prepareOnce(entry,unit,seen)
    local work=GameContent.ports[entry.level] or _editor_class[entry.source]
    if work and work.prepareRogue then
        local key=work.roguePreloadKey and work.roguePreloadKey(unit) or unit
        local keys=seen.works[work]
        if not keys then keys={};seen.works[work]=keys end
        if not keys[key] then work.prepareRogue(entry,unit);keys[key]=true end
    end
    for _,part in ipairs(unit.sc_group) do
        if part.boss.prepareRogue and not seen.bosses[part.boss] then
            part.boss.prepareRogue();seen.bosses[part.boss]=true
        end
        if part.card.prepareRogue and not seen.cards[part.card] then
            part.card.prepareRogue();seen.cards[part.card]=true
        end
    end
end
local function createBackground(entry,unit)
    local part=unit.sc_group[1]
    local work=GameContent.ports[entry.level] or _editor_class[entry.source]
    local create=part.card.createRogueBackground or part.boss.createRogueBackground or work and work.createRogueBackground
    local scope={objects={},level=entry.level}
    scope.anchor=rawNew(object)
    scope.anchor.group,scope.anchor.bound,scope.anchor.colli,scope.anchor.hide=GROUP.GHOST,false,false,true
    scope.objects[scope.anchor]=true
    M.backgroundActive=scope
    local bg
    if create then bg=create(entry,unit)
    elseif part.boss._bg then bg=background.Create(part.boss._bg) end
    scope.root=bg or lstg.tmpvar.bg
    M.backgroundActive=nil
    M.background=scope
end
function M.warmup(scene)
    local run=lstg.var.rogue_run
    local first=run.cards[1]
    -- 旧录像没有预加载标记，保持同步入口，不增加资源准备等待帧。
    if lstg.var.__rogue_preload_version~=1 then
        run.encounter,run.source_hp=first,false
        createBackground(first,assert(_sc_pr_table[first.level][first.index]))
        run.encounter=nil
        restoreBackground()
        return
    end
    local pool=GetResourceStatus()
    local started=lstg.AndroidClock and lstg.AndroidClock()
    run.preparing=true
    M.warming=true;SetResourceStatus('global')
    preload.run(function()
        local seen={works={},bosses={},cards={}}
        for i,entry in ipairs(run.cards) do
            run.preloadIndex,run.preloadTotal=i,#run.cards
            run.encounter,run.source_hp=entry,entry.level>=35 and entry.level<=41
            local unit=assert(_sc_pr_table[entry.level][entry.index],'随机卡片已移除')
            if run.source_hp then prepareOnce(entry,unit,seen) end
            M.checkpoint()
        end
        run.encounter,run.source_hp=first,first.level>=35 and first.level<=41
        createBackground(first,assert(_sc_pr_table[first.level][first.index]))
    end)
    M.warming=false;SetResourceStatus(pool)
    M.residentReady=true
    run.preparing,run.preloadIndex,run.preloadTotal=nil,nil,nil
    run.encounter,run.source_hp=nil,false
    restoreBackground()
    if started and lstg.SystemLog then
        lstg.SystemLog(('BOSSRUSH_ROGUE_PRELOAD: cards=%d elapsed_ms=%.1f background=%s'):format(#run.cards,
            (lstg.AndroidClock()-started)*1000,first.key))
    end
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
        if level==36 and TH38 and not (M.background and M.background.level==36) then TH38.background.releaseMeshes() end
        release(owned);cached=nil
    end
    if IsValid(player) then player.dialog=false;player.lock=false;player.ldX,player.ldY=nil,nil end
    restoreBackground()
    lstg.tmpvar.boss=nil;_boss=nil
    scope.run.source_hp=false
end
function M.begin(scene,entry)
    M.stop(scene)
    if cached and cached.level~=entry.level then discardCache() end
    restoreBackground()
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
    -- 开局已将资源放入 global。这里只更新当前卡的轻量入口状态，不再插入加载帧。
    if M.residentReady then
        for _,part in ipairs(unit.sc_group) do
            if part.card.enterRogue then part.card.enterRogue() end
        end
        return
    end
    local run=lstg.var.rogue_run
    local p=IsValid(player) and player
    local dialog,lock=p and p.dialog,p and p.lock
    if p then p.dialog,p.lock=true,true end
    run.preparing=true
    preload.run(function()
        prepareResources(entry,unit)
    end)
    run.preparing=nil
    if p and IsValid(p) then p.dialog,p.lock=dialog,lock end
end
function M.release()
    preload.clear()
    discardCache()
    if M.background then
        for o in pairs(M.background.objects) do
            if IsValid(o) then o.rogueBackgroundScope=nil;o.class=object;object.RawDel(o) end
        end
    end
    M.background,M.backgroundActive,M.residentReady=nil,nil,nil
    M.warming,M.constructingBackground=nil,nil
    backgroundClasses=setmetatable({},{__mode='k'})
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
    if M.background and IsValid(M.background.root) then lstg.tmpvar.bg=M.background.root end
    if M.scope and timer%120==0 then
        for o in pairs(M.scope.objects) do if not IsValid(o) then M.scope.objects[o]=nil end end
    end
end
local function new(class,...)
    -- 原作道中入口也可能直接创建背景；跳过其构造器，保留可安全回收的空对象。
    local skip=class and class.rogue_stage_background and M.spellOnly(class.rogue_stage_background)
    if skip then class=object end
    local constructing=M.constructingBackground
    if M.backgroundActive then M.constructingBackground=true end
    local o=rawNew(class,...)
    M.constructingBackground=constructing
    if skip then o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true end
    -- _drop_owner 标记宿主自机弹与 Bomb；它们使用宿主资源，跨卡继续原来的寿命。
    if M.backgroundActive then protectBackground(o,M.backgroundActive)
    elseif M.scope and not o._drop_owner then M.scope.objects[o]=true end
    return o
end
New,lstg.New=new,new
RogueEncounter=M
return M
