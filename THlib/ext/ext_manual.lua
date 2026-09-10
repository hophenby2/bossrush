LoadImageFromFile("black_mask", "THlib\\UI\\black.png")
local manual = {}
---@class ext.manual
---弃用
ext.manual = manual
local ext, lstg = ext, lstg
function manual:init()
    self.kill = true
    self.locked = true
    self.mask_alpha = 0
    self.alpha = 0
    self.timer = 0
    self.changing = false
    self.content = {}
    self.now = 1
end
function manual:frame()
    task.Do(self)
    if self.locked or ext.replay.IsReplay() then
        return
    end
    menu:Updatekey()
    if self.content then
        if not self.changing then
            self.alpha = min(self.alpha + 1 / 30, 1)
            if self.alpha == 1 and menu:keyYes() then
                self:change()
            end
        end
    end
    self.timer = self.timer + 1
end
function manual:render()
    if self.kill or ext.replay.IsReplay() then
        return
    end
    SetViewMode("ui")
    SetImageState("black_mask", "", 255 * self.mask_alpha, 255, 255, 255)
    Render("black_mask", 480, 270)
    local text = self.content[self.now]
    for i = 1, 8 do
        RenderTTF("title", text, 480 + cos(i * 45), 270 + sin(i * 45),
                Color(255 * self.alpha, 0, 0, 0), "centerpoint")
    end
    RenderTTF("title", text, 480, 270,
            Color(255 * self.alpha, 255, 255, 255), "centerpoint")
    SetViewMode("world")
end
---@param id number
---@param re boolean
function manual:FlyIn(id, re)
    if not self.kill then
        return
    end
    if not re and scoredata["Manual"][id] then
        return
    end
    if ext.sc_pr or lstg.var.is_practice or ext.replay.IsReplay() then
        return
    end
    scoredata["Manual"][id] = true
    self.now = 1
    self.content = self.text[id]
    self.timer = 0
    self.alpha = 0
    self.mask_alpha = 0
    self.changing = false
    self.kill = false
    self.bgmlist = {}
    self:PauseSound()
    PlaySound("se_notice", 1)
    task.New(self, function()
        for i = 1, 20 do
            self.mask_alpha = sin(i * 4.5)
            task.Wait()
        end
        self.locked = false
    end)
end
function manual:FlyOut()
    self.locked = true
    task.New(self, function()
        for i = 1, 20 do
            self.mask_alpha = 1 - sin(i * 4.5)
            task.Wait()
        end
        self.kill = true
        self:ResumeSound()
        self.content = {}
    end)
end
function manual:change()
    self.changing = true
    PlaySound("ok00")
    task.New(self, function()
        for _ = 1, 30 do
            self.alpha = max(self.alpha - 1 / 30, 0)
            task.Wait()
        end
        self.now = self.now + 1
        if self.now > #self.content then
            self:FlyOut()
            self.now = #self.content
        else
            self.changing = false
        end
    end)
end
function manual:PauseSound()
    if not ext.sc_pr then
        self.bgmlist = {}--先清空列表
        for _, v in pairs(EnumRes2('bgm')) do
            if GetMusicState(v) == "playing" then
                PauseMusic(v)
                self.bgmlist[v] = true--标记
            end
        end
    end
end

function manual:ResumeSound()
    for _, v in pairs(EnumRes2('bgm')) do
        if GetMusicState(v) ~= 'stopped' and self.bgmlist[v] then
            ResumeMusic(v)
        end
    end
end

function manual:IsKilled()
    return self.kill
end

ext.manual:init()