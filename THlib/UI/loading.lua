local function EnumPNG(list, searchPath, func)
    for _, v in ipairs(lstg.FileManager.EnumFiles(searchPath, "png", true)) do
        local path = v[1]
        local name = path:sub(searchPath:len() + 1, -5)
        table.insert(list, function()
            func(name, path)
        end)
    end
end

local function LoadingImage()

    local list = {}
    EnumPNG(list, "Resources\\BossBackGround\\", LoadTexture2)
    EnumPNG(list, "Resources\\BossImage\\", LoadTexture)
    EnumPNG(list, "Resources\\Special\\", LoadImageFromFile)
    table.insert(list, function()
        Include('Resources\\System\\system.lua')
    end)
    for _, v1 in pairs(LoadRes) do
        table.insert(list, v1)
    end
    table.insert(list, function()
        InitAllClass()
    end)
    return list
end
LoadImageFromFile("loading", "THlib\\UI\\loading.png")

local string = string
local clock = os.clock

local SetImageState = SetImageState
local SetFontState = SetFontState

local Render = Render
local RenderTTF = RenderTTF
local RenderText = RenderText
local RenderRect = RenderRect

local Color = Color
local time = 1 / 60



local stage_init = stage.New('init', false, true)
function stage_init:init()
    math.randomseed(os.time())
    self.start_time = clock()
    self.res = LoadingImage()
    self.index = 1
    self.maxindex = #self.res
    self.textindex = math.random(1, #TIP)
    self.text = TIP[self.textindex]
    self.settime = self.timer
    SetResourceStatus("global")
    task.New(self, function()
        while not self.jump do
            coroutine.yield()
        end
        mask_fader:Do("close")
        task.Wait(30)
        SetResourceStatus("stage")
        if not scoredata.PlayerBrand then
            stage.Set('none', "setname")
        else
            stage.Set('none', "menu")
        end
    end)
end
function stage_init:frame()

    self.timer = int((clock() - self.start_time) * 60)
    if self.timer - self.settime > 150 then
        local t = self.textindex
        while self.textindex == t do
            self.textindex = math.random(1, #TIP)
        end
        self.text = TIP[self.textindex]
        self.settime = self.timer
    end
    if self.index > self.maxindex then
        self.jump = true
    elseif not self.jump then
        local res
        local start_time, end_time = clock(), clock()
        while end_time - start_time < time do
            if self.index > self.maxindex then
                return
            end
            res = self.res[self.index]
            res()
            self.index = self.index + 1
            end_time = clock()
        end
    end
end
function stage_init:render()
    Render("loading", 480, 270)
    ui:RenderText('title', "少女折寿中" .. string.rep(".", int(self.timer / 20 % 6) + 1),
            480, 25, 1, Color(255, 255, 227, 132), "centerpoint")
    --SetImageState("title", "mul+add", min(self.timer, 45) / 45 * 255, 200, 200, 200)
    --Render("title", 480, 270 + sin(self.timer) * 2, 0, 0.5 + sin(self.timer * 4) * 0.001)

    local length = min(self.index / self.maxindex, 1)
    SetImageState("white", "", 255, 255, 255, 255)
    RenderRect("white", 150, 810, 50, 75)
    SetImageState("white", "", 255, 0, 0, 0)
    RenderRect("white", 152, 808, 52, 73)
    SetImageState("white", "",
            Color(180, 255 - 155 * length, 255 * length, 0 + 100 * length))
    RenderRect("white", 152, 152 + length * 656, 52, 73)
    SetFontState("Score", "",
            Color(255, 255 * length, 255 - 28 * length, 100 + 32 * length))
    ui:RenderText('sc_menu', "Tips : " .. self.text, 480, 170, 1,
            Color(255, 250, 128, 114 + 50 * sin(self.timer * 2)), "centerpoint")
    ui:RenderText("title", ("%0.2f%% ( %d / %d ) "):format(length * 100, min(self.index, self.maxindex), self.maxindex),
            480, 62.5, 0.8, Color(255, 255 * length, 255 - 28 * length, 100 + 32 * length), "centerpoint")
end

local _keyboard = {}
do
    for i = 65, 90 do
        table.insert(_keyboard, i)
    end
    for i = 97, 122 do
        table.insert(_keyboard, i)
    end
    for i = 48, 57 do
        table.insert(_keyboard, i)
    end
    for _, i in ipairs({ 43, 45, 61, 46, 44, 33, 63, 64, 58, 59, 91, 93, 40, 41, 95, 47, 123, 125, 124, 126, 94 }) do
        table.insert(_keyboard, i)
    end
    for i = 35, 38 do
        table.insert(_keyboard, i)
    end
    for _, i in ipairs({ 42, 92, 127, 34 }) do
        table.insert(_keyboard, i)
    end
end

local stage_other = stage.New('setname', false, true)
function stage_other:init()
    mask_fader:Do("open")
    self.state2CursorX = 0
    self.state2CursorY = 0
    self.shakeValue = 0
    self.alpha = 1
    self.x, self.y = 480, 200
    self.state2UserName = ""
    function self:exitCallback()
        self.jump = true
        scoredata.PlayerBrand = self.state2UserName
        task.New(self, function()
            mask_fader:Do("close")
            task.Wait(30)
            stage.Set('none', "menu")
        end)
    end
end
function stage_other:frame()
    if not self.jump then
        local mouse = ext.mouse
        local Yes = function()
            if self.state2CursorX == 12 and self.state2CursorY == 6 then
                if #self.state2UserName < 4 then
                    PlaySound("invalid")
                else
                    self:exitCallback()
                    PlaySound("extend", 0.5)
                end
            else
                if self.state2CursorX == 10 and self.state2CursorY == 6 then
                    local char = string.char(0x20)
                    self.state2UserName = self.state2UserName .. char
                    PlaySound('ok00', 0.3)
                elseif self.state2CursorX == 11 and self.state2CursorY == 6 then
                    if #self.state2UserName == 0 then
                        self.state = 0
                    else
                        self.state2UserName = string.sub(self.state2UserName, 1, -2)
                    end
                    PlaySound('cancel00', 0.3)
                elseif #self.state2UserName == 20 then
                    self.state2CursorX = 12
                    self.state2CursorY = 6
                else
                    local char = string.char(_keyboard[self.state2CursorY * 13 + self.state2CursorX + 1])
                    self.state2UserName = self.state2UserName .. char
                    PlaySound('ok00', 0.3)
                end
            end
        end
        menu:Updatekey()
        if self.shakeValue > 0 then
            self.shakeValue = self.shakeValue - 1
        end
        if menu:keyYes() then
            Yes()
        elseif menu:keyNo() then
            if #self.state2UserName == 0 then
                stage.QuitGame()
            else
                self.state2UserName = string.sub(self.state2UserName, 1, -2)
            end
            PlaySound('cancel00', 0.3)
        else
            if menu:keyUp() then
                self.state2CursorY = self.state2CursorY - 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if menu:keyDown() then
                self.state2CursorY = self.state2CursorY + 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if menu:keyLeft() then
                self.state2CursorX = self.state2CursorX - 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if menu:keyRight() then
                self.state2CursorX = self.state2CursorX + 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if mouse:isDown(1) then
                local width, height = ui.menu.char_width, ui.menu.line_height
                local x, y = (function()
                    for x = 0, 12 do
                        for y = 0, 6 do
                            if abs(mouse.x - (self.x + (x - 5.5) * width)) < width / 2 and abs(mouse.y - (self.y - (y - 3.5) * height)) < height / 2 then
                                return x, y
                            end
                        end
                    end
                end)()
                if x and y then
                    self.state2CursorX = x
                    self.state2CursorY = y
                    Yes()
                    PlaySound('select00', 0.3)
                end
            end
            if mouse._wheel ~= 0 then
                self.ctri()
                self.state2CursorX = self.state2CursorX - sign(mouse._wheel)
                if self.state2CursorX == 13 then
                    self.state2CursorY = self.state2CursorY + 1
                    self.state2CursorX = 0
                end
                if self.state2CursorX == -1 then
                    self.state2CursorY = self.state2CursorY - 1
                    self.state2CursorX = 12
                end
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            self.state2CursorX = sp:TweakValue(self.state2CursorX, 13, 0)
            self.state2CursorY = sp:TweakValue(self.state2CursorY, 7, 0)
        end
    end

end
function stage_other:render()
    local text = [[正式开始游戏前
    你需要输入一个具有象征性*（象征你）的标签
    它将在一些重要地方里显示
    字符长度为4~20，仅限英文字符
    尽量避免大众化，如果实在想不出来可以乱打一通（
    ----确定结果后将无法修改----]]
    RenderTTF("title", text, self.x, 430, Color(255, 255, 255, 255), "center")
    local font = "replay"
    -- 标题
    SetFontState(font, "", 255 * self.alpha, unpack(ui.menu.title_color))
    RenderText(font, self.state2UserName, self.x, self.y - 5.5 * ui.menu.line_height + 320 - self.alpha * 320, ui.menu.font_size, "centerpoint")

    ---- 绘制键盘
    -- 未选中按键
    SetFontState(font, "", 255 * self.alpha, unpack(ui.menu.unfocused_color))
    for x = 0, 12 do
        for y = 0, 6 do
            if x ~= self.state2CursorX or y ~= self.state2CursorY then
                RenderText(font, string.char(_keyboard[y * 13 + x + 1]),
                        self.x + (x - 5.5) * ui.menu.char_width, self.y - (y - 3.5) * ui.menu.line_height + 320 - self.alpha * 320,
                        ui.menu.font_size, 'centerpoint')
            end
        end
    end
    -- 激活按键
    local color = {}
    local k = cos(self.timer * ui.menu.blink_speed) ^ 2
    for i = 1, 3 do
        color[i] = ui.menu.focused_color1[i] * k + ui.menu.focused_color2[i] * (1 - k)
    end
    SetFontState(font, "", 255 * self.alpha, unpack(color))
    RenderText(font, string.char(_keyboard[self.state2CursorY * 13 + self.state2CursorX + 1]),
            self.x + (self.state2CursorX - 5.5) * ui.menu.char_width + ui.menu.shake_range * sin(ui.menu.shake_speed * self.shakeValue),
            self.y - (self.state2CursorY - 3.5) * ui.menu.line_height + 320 - self.alpha * 320,
            ui.menu.font_size, "centerpoint")

end
