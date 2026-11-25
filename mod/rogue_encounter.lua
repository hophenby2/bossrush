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
-- 同一局保留多个作品的缓存，只在总预算超限时按最近使用顺序淘汰。
local cached,cacheClock={},0
local cacheBudget=192*1024*1024
local resourcePrefixes={
    [35]={'mhj2_'},[36]={'asl_','th38_unity_'},[37]={'mhj3_'},
    [38]={'th38.','TH40_scene_'},[39]={'theis/','theis_'},[40]={'ld_'},[41]={'th43/'},
}
local function ownedResource(level,name)
    for _,prefix in ipairs(resourcePrefixes[level] or {}) do
        if name:sub(1,#prefix)==prefix then return true end
    end
    return false
end
local function releaseCache(level)
    local entry=cached[level]
    if not entry then return end
    if level==36 and TH38 and not (M.background and M.background.level==36) then TH38.background.releaseMeshes() end
    for kind=9,1,-1 do for name in pairs(entry.resources[kind] or {}) do
        lstg.RemoveResource('stage',kind,name)
    end end
    cached[level]=nil
end
local function trimCache(level,current)
    cacheClock=cacheClock+1
    local entry=cached[level] or {resources={}}
    entry.used=cacheClock;cached[level]=entry
    -- 只接管本作前缀内的资源；宿主、旧作ANM及其他作品的跨卡特效不归当前卡所有。
    for kind=1,9 do
        entry.resources[kind]={}
        for name in pairs(current[kind]) do
            if ownedResource(level,name) then entry.resources[kind][name]=true end
        end
    end
    local total=0
    for _,item in pairs(cached) do
        item.bytes=0
        for kind=1,9 do for name in pairs(item.resources[kind] or {}) do
            if not current[kind][name] then item.resources[kind][name]=nil
            elseif kind==1 then local w,h=GetTextureSize(name);item.bytes=item.bytes+w*h*4
            else item.bytes=item.bytes+1024 end
        end end
        total=total+item.bytes
    end
    while total>cacheBudget do
        local oldest
        for id,item in pairs(cached) do
            if not oldest or item.used<cached[oldest].used then oldest=id end
        end
        if not oldest then break end
        total=total-cached[oldest].bytes;releaseCache(oldest)
    end
end
local rawNew=New
local ports=dofile('mod/rogue_ports.lua')
-- 与旧作一样，资源在主菜单前加载后复用。首个真实背景有整局独立的对象作用域。
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
function M.spellOnly(level)
    local startup=M.startupLevel and (not level or M.startupLevel==level)
    return (startup or M.enabled(level)) and not M.backgroundActive
end
function M.retainResources() return M.warming or M.startupReady or M.residentReady end
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
            setPool('global') -- 首个背景后续创建的素材也归背景驻留池。
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
function M.appendStartup(list)
    if M.startupReady then return end
    local seen={works={},bosses={},cards={}}
    local count,started=0
    list[#list+1]=function() started=(lstg.AndroidClock or os.clock)() end
    local function append(entry,unit)
        list[#list+1]=function()
            local pool=GetResourceStatus()
            -- 只准备共享素材，不创建自机、Boss或场景，也不建立虚假的随机对局。
            M.warming,M.startupLevel=true,entry.level
            SetResourceStatus('global')
            prepareOnce(entry,unit,seen)
            M.warming,M.startupLevel=nil,nil
            SetResourceStatus(pool)
        end
        count=count+1
    end
    for _,source in ipairs(ports.sources) do
        for index,unit in ipairs(_sc_pr_table[source.level] or {}) do
            append({level=source.level,index=index,source=source.code},unit)
        end
    end
    list[#list+1]=function()
        -- ready 是某一次入场的临时状态，不能让启动阶段的最后一张卡影响首次练习。
        for _,work in pairs({TH37,TH38,TH39,_editor_class.TH40}) do
            if work and work.background and work.background.clearPrepared then work.background.clearPrepared() end
        end
        M.startupReady=true
        if lstg.SystemLog then
            lstg.SystemLog(('BOSSRUSH_STARTUP: native_resources_ready cards=%d elapsed_ms=%.1f'):format(count,
                ((lstg.AndroidClock or os.clock)()-started)*1000))
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
    local pool=GetResourceStatus()
    local started=lstg.AndroidClock and lstg.AndroidClock()
    run.preparing=true
    M.warming=true;SetResourceStatus('global')
    preload.run(function()
        -- 正式启动已完成全部新作资源准备；省略开局再遍历几百张卡。
        -- 独立开发入口若绕过启动页，仍保留本局资源的准备回退。
        if not M.startupReady then
            local seen={works={},bosses={},cards={}}
            for i,entry in ipairs(run.cards) do
                run.preloadIndex,run.preloadTotal=i,#run.cards
                run.encounter,run.source_hp=entry,entry.level>=35 and entry.level<=41
                local unit=assert(_sc_pr_table[entry.level][entry.index],'随机卡片已移除')
                if run.source_hp then prepareOnce(entry,unit,seen) end
                M.checkpoint()
            end
        end
        run.encounter,run.source_hp=first,first.level>=35 and first.level<=41
        createBackground(first,assert(_sc_pr_table[first.level][first.index]))
    end)
    M.warming=false;SetResourceStatus(pool)
    M.residentReady=true
    run.preparing,run.preloadIndex,run.preloadTotal=nil,nil,nil
    run.encounter,run.source_hp=nil,false
    restoreBackground()
    if ui.ResourceLoading then ui.ResourceLoading.ready() end
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
        if IsValid(o) then
            -- RawDel不调用del；震屏对象须先还原共享偏移并清除tmpvar中的单例引用。
            if o==lstg.tmpvar.shaker then shaker_maker.del(o) end
            object.RawDel(o)
        end
    end
    for i=#boss_group,1,-1 do
        if scope.objects[boss_group[i]] or not IsValid(boss_group[i]) then table.remove(boss_group,i) end
    end
    if NativeTime then NativeTime.reset() end
    if scene.sequence_music then StopMusic(scene.sequence_music);scene.sequence_music=nil end
    if scene.now_music then StopMusic(scene.now_music);scene.now_music=nil end
    M.stopping=nil
    -- 全部攻击对象已经结束；换作不卸载，只有缓存总量超预算才回收闲置资源。
    trimCache(level,stageResources())
    if IsValid(player) then player.dialog=false;player.lock=false;player.ldX,player.ldY=nil,nil end
    restoreBackground()
    lstg.tmpvar.boss=nil;_boss=nil
    scope.run.source_hp=false
end
function M.begin(scene,entry)
    M.stop(scene)
    restoreBackground()
    local run=lstg.var.rogue_run
    local enabled=entry.level>=35 and entry.level<=41
    run.encounter,run.source_hp=entry,enabled
    run.source_damage=enabled and assert(ports.damageUnits[entry.level]) or nil
    run.source_boss_damage=enabled and ports.bossDamageUnits[entry.level] or nil
    if not enabled then return false end
    M.scope={entry=entry,run=run,objects={}}
    return true
end
function M.prepare(scene,entry,unit)
    if not M.scope then return end
    -- 启动时已将资源放入 global。这里只更新当前卡的轻量入口状态，不再插入加载帧。
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
    cached={} -- 真正离开战斗时由框架统一释放stage池。
    if M.background then
        for o in pairs(M.background.objects) do
            if IsValid(o) then
                if o==lstg.tmpvar.shaker then shaker_maker.del(o) end
                o.rogueBackgroundScope=nil;o.class=object;object.RawDel(o)
            end
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
    if not M.enabled(37) or preload.active() then return false end
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
    -- 宿主自机弹、Bomb与手动控制的选项文字/遮罩使用宿主资源，跨卡保留各自寿命。
    if M.backgroundActive then protectBackground(o,M.backgroundActive)
    elseif M.scope and not o._drop_owner and not o._rogue_host_overlay then M.scope.objects[o]=true end
    return o
end
New,lstg.New=new,new
RogueEncounter=M
return M
