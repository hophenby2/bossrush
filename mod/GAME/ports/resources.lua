-- 两作的资源表转成当前资源池的加载操作。关卡退出由引擎释放 stage 池。
return function(assetRoot,prefix)
    local sets = {}
    local rawCheckRes = lstg.CheckRes
    local function id(kind,name)
        return prefix and kind>=1 and kind<=3 and prefix..name or name
    end
    local function CheckRes(kind,name) return rawCheckRes(kind,id(kind,name)) end
    local function resolve(kind,name)
        if not name or not prefix or kind<1 or kind>3 or name:sub(1,#prefix)==prefix then return name end
        local key=id(kind,name)
        -- 原作动画和宿主静态图也可能同名，不能在资源类型探测时回退到另一作。
        local owned=rawCheckRes(kind,key) or (kind==2 or kind==3) and rawCheckRes(5-kind,key)
        return owned and key or name
    end
    local kinds = {tex=1,img=2,ani=3,bgm=4,snd=5,psi=6,fnt=7,ttf=8,fx=9}
    local function file(path)
        return assetRoot .. path:gsub('\\', '/')
    end

    local Set = {}
    Set.__index = Set

    function Set:add(kind, name, load, ...)
        self.rogue_resident_ready=nil
        local args = {...}
        self.entries[#self.entries+1] = {kind, name, function()
            load(id(kind,name), unpack(args))
            -- 对象的 img 赋值仍需有效资源；只给尚不存在的名字建别名，绝不覆盖宿主弹型。
            if prefix and (kind==2 or kind==3) and not rawCheckRes(2,name) and not rawCheckRes(3,name) then
                load(name,unpack(args))
            end
        end}
    end
    function Set:AddTexture(name, path, mipmap)
        self:add(1, name, LoadTexture, file(path), mipmap)
    end
    function Set:AddSprite(name, tex, x, y, w, h)
        self:add(2, name, LoadImage, id(1,tex), x, y, w, h)
    end
    function Set:AddSpriteSequence(prefix, tex, x, y, w, h, columns, rows)
        for row=0,rows-1 do
            for column=0,columns-1 do
                local index = row*columns+column+1
                local name = type(prefix)=='table' and prefix[index] or prefix..index
                self:AddSprite(name, tex, x+column*w, y+row*h, w, h)
            end
        end
    end
    function Set:AddSpriteFromFile(name, path, mipmap)
        self:AddTexture(name, path, mipmap)
        self:add(2, name, function(key)
            local tex=id(1,name)
            local w,h = GetTextureSize(tex)
            LoadImage(key, tex, 0, 0, w, h)
        end)
    end
    function Set:AddAnimation(name, tex, x, y, w, h, columns, rows, interval)
        self:add(3, name, LoadAnimation, id(1,tex), x, y, w, h, columns, rows, interval)
    end
    function Set:AddParticle(name, path, img)
        self:add(6, name, LoadPS, file(path), id(2,img))
    end
    function Set:AddSound(name, path)
        self:add(5, name, LoadSound, file(path))
    end
    function Set:AddMusic(name, path, ending, length)
        self:add(4, name, LoadMusic, file(path), ending, length)
        AddMusic(name, ending, length, name, true, file(path))
    end
    function Set:AddEffect(name, path)
        self:add(9, name, LoadFX, file(path))
    end
    function Set:AddRenderTarget(name)
        self:add(1, name, CreateRenderTarget)
    end
    function Set:SetSpriteCenter(name, x, y)
        self.options[#self.options+1] = function() SetImageCenter(id(2,name), x, y) end
    end
    function Set:SetSpriteState(name, ...)
        local args = {...}
        self.options[#self.options+1] = function() SetImageState(id(2,name), unpack(args)) end
    end
    function Set:SetSpriteSequenceCenter(prefix, columns, rows, x, y)
        for i=1,columns*rows do self:SetSpriteCenter(prefix..i, x, y) end
    end
    function Set:SetSpriteSequenceState(prefix, columns, rows, ...)
        for i=1,columns*rows do self:SetSpriteState(prefix..i, ...) end
    end
    function Set:SetAnimationCenter(name, x, y)
        self.options[#self.options+1] = function() SetAnimationCenter(id(3,name), x, y) end
    end
    function Set:SetAnimationState(name, ...)
        local args = {...}
        self.options[#self.options+1] = function() SetAnimationState(id(3,name), unpack(args)) end
    end
    function Set:IsLoaded()
        for _, entry in ipairs(self.entries) do
            if not self.loaded or not self.loaded[entry] or CheckRes(entry[1], entry[2])~=self.loaded[entry] then return false end
        end
        return true
    end
    function Set:Load()
        -- 已驻留 global 的资源集不允许 Unload；切卡无需逐项再扫数千个图片切片。
        if self.rogue_resident_ready then return end
        local resident=RogueEncounter and RogueEncounter.retainResources()
        if resident then self.rogue_resident=true end
        if self:IsLoaded() and (not resident or self.pool=='global') then
            if resident then self.rogue_resident_ready=true end
            return
        end
        local previous=GetResourceStatus()
        if resident then SetResourceStatus('global') end
        local pool = GetResourceStatus()
        self.pool = pool
        self.loaded=self.loaded or {}
        for _, entry in ipairs(self.entries) do
            local found=CheckRes(entry[1], entry[2])
            if not self.loaded[entry] or found~=self.loaded[entry] or resident and found~='global' then
                if found~=pool then entry[3]() end
                -- CheckRes 优先返回 global；同名 stage 副本不能让有效的共享素材永久失去命中。
                self.loaded[entry]=CheckRes(entry[1], entry[2])
            end
            if RogueEncounter then RogueEncounter.checkpoint() end
        end
        for _, option in ipairs(self.options) do option() end
        if resident and pool=='global' then self.rogue_resident_ready=true end
        if resident then SetResourceStatus(previous) end
    end
    function Set:Unload()
        if self.rogue_resident then return end
        if not self.pool then return end
        for i=#self.entries,1,-1 do
            local entry = self.entries[i]
            if CheckRes(entry[1], entry[2])==self.pool then
                RemoveResource(self.pool, entry[1], id(entry[1],entry[2]))
            end
        end
    end

    return {
        Resolve=resolve,
        kinds=kinds,
        Create=function(name)
            local set = setmetatable({entries={},options={}},Set)
            sets[name] = set
            return set
        end,
        Find=function(name) return sets[name] end,
        LoadByName=function(_, ...)
            for _, name in ipairs({...}) do assert(sets[name], name):Load() end
        end,
        UnloadByName=function(...)
            for _, name in ipairs({...}) do assert(sets[name], name):Unload() end
        end,
        LoadByTag=function()
            for _, set in pairs(sets) do set:Load() end
        end,
    }
end
