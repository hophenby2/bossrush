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
local clock = lstg.AndroidClock or os.clock

local SetImageState = SetImageState
local SetFontState = SetFontState

local Render = Render
local RenderTTF = RenderTTF
local RenderText = RenderText
local RenderRect = RenderRect

local Color = Color
-- 手机留出绘制时间；单次资源加载完成后再检查墙钟预算，不在一帧内持续占满线程。
local time = AndroidPlatform and 1 / 120 or 1 / 60



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
        stage.Set('none', "menu")
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
        if AndroidPlatform and not self.jump then
            lstg.SystemLog(string.format('BOSSRUSH_STARTUP: resources_ready %.1f ms', (clock()-self.start_time)*1000))
        end
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
    if AndroidPortrait and AndroidPortrait.enabled() and not AndroidPortrait.rendering then return AndroidPortrait.loading(self,stage_init.render) end
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
