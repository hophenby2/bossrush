-- 两作的资源表转成当前资源池的加载操作。关卡退出由引擎释放 stage 池。
return function(assetRoot)
    local sets = {}
    local CheckRes = lstg.CheckRes
    local kinds = {tex=1,img=2,ani=3,bgm=4,snd=5,psi=6,fnt=7,ttf=8,fx=9}
    local function file(path)
        return assetRoot .. path:gsub('\\', '/')
    end

    local Set = {}
    Set.__index = Set

    function Set:add(kind, name, load, ...)
        local args = {...}
        self.entries[#self.entries+1] = {kind, name, function()
            load(name, unpack(args))
        end}
    end
    function Set:AddTexture(name, path, mipmap)
        self:add(1, name, LoadTexture, file(path), mipmap)
    end
    function Set:AddSprite(name, tex, x, y, w, h)
        self:add(2, name, LoadImage, tex, x, y, w, h)
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
        self:add(2, name, function(id)
            local w,h = GetTextureSize(id)
            LoadImage(id, id, 0, 0, w, h)
        end)
    end
    function Set:AddAnimation(name, tex, x, y, w, h, columns, rows, interval)
        self:add(3, name, LoadAnimation, tex, x, y, w, h, columns, rows, interval)
    end
    function Set:AddParticle(name, path, img)
        self:add(6, name, LoadPS, file(path), img)
    end
    function Set:AddSound(name, path)
        self:add(5, name, LoadSound, file(path))
    end
    function Set:AddMusic(name, path, ending, length)
        self:add(4, name, LoadMusic, file(path), ending, length)
        AddMusic(name, ending, length, name, true)
    end
    function Set:AddEffect(name, path)
        self:add(9, name, LoadFX, file(path))
    end
    function Set:AddRenderTarget(name)
        self:add(1, name, CreateRenderTarget)
    end
    function Set:SetSpriteCenter(name, x, y)
        self.options[#self.options+1] = function() SetImageCenter(name, x, y) end
    end
    function Set:SetSpriteState(name, ...)
        local args = {...}
        self.options[#self.options+1] = function() SetImageState(name, unpack(args)) end
    end
    function Set:SetSpriteSequenceCenter(prefix, columns, rows, x, y)
        for i=1,columns*rows do self:SetSpriteCenter(prefix..i, x, y) end
    end
    function Set:SetSpriteSequenceState(prefix, columns, rows, ...)
        for i=1,columns*rows do self:SetSpriteState(prefix..i, ...) end
    end
    function Set:SetAnimationCenter(name, x, y)
        self.options[#self.options+1] = function() SetAnimationCenter(name, x, y) end
    end
    function Set:SetAnimationState(name, ...)
        local args = {...}
        self.options[#self.options+1] = function() SetAnimationState(name, unpack(args)) end
    end
    function Set:IsLoaded()
        for _, entry in ipairs(self.entries) do
            if not self.pool or CheckRes(entry[1], entry[2])~=self.pool then return false end
        end
        return true
    end
    function Set:Load()
        if self:IsLoaded() then return end
        local pool = GetResourceStatus()
        self.pool = pool
        for _, entry in ipairs(self.entries) do
            if CheckRes(entry[1], entry[2])~=pool then entry[3]() end
        end
        for _, option in ipairs(self.options) do option() end
    end
    function Set:Unload()
        if not self.pool then return end
        for i=#self.entries,1,-1 do
            local entry = self.entries[i]
            if CheckRes(entry[1], entry[2])==self.pool then
                RemoveResource(self.pool, entry[1], entry[2])
            end
        end
    end

    return {
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
