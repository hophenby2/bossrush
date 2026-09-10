local ext = ext
local PostEffect = PostEffect
local PopRenderTarget = PopRenderTarget
local PushRenderTarget = PushRenderTarget
local Render4V = Render4V
local SetImageState = SetImageState
local Render = Render
local Color = Color
local RenderClear = RenderClear
local SetFontState = SetFontState
local RenderText = RenderText
local lstg = lstg
local Forbid = Forbid
local IsValid = IsValid
local achievement = ext.achievement

--游玩时长相关

function ext.InputDuration()
    --frame,second,minute,hour,day
    local time = scoredata["Duration"]
    time[1] = time[1] + 1
    for i = 1, 3 do
        if time[i] >= 60 then
            time[i] = time[i] - 60
            time[i + 1] = time[i + 1] + 1
        end
    end
    if time[4] >= 24 then
        time[4] = time[4] - 24
        time[5] = time[5] + 1
    end
end
function ext.DurationAchievement()
    --frame,second,minute,hour,day
    local time = scoredata["Duration"]
    if time[3] >= 30 or time[4] > 0 or time[5] > 0 then
        achievement:get(14)
    end--30分钟，一个成就
    if time[4] >= 1 or time[5] > 0 then
        achievement:get(15)
    end--1小时，一个成就
    if time[4] >= 12 or time[5] > 0 then
        achievement:get(16)
    end--12小时，一个成就
    if time[5] >= 1 then
        achievement:get(17)
    end--1天，一个成就
end
do
    local t, err = io.open("testing.lua", "r")
    local now
    if not err then
        now = #t:read("*a") + 1
        t:close()
        t = nil
    end
    ---开发者模式
    function ext.Debugging()
        --DEBUGGER
        if DEBUG then
            local key, KEY = GetLastKey(), KEY
            if key == KEY.A then
                New(Circle_Attack, player.x, player.y, 250, nil, 300, 0.1)
            end--快速灵击
            if key == KEY.BACKSPACE then
                object.EnemyNontjtDo(function(u)
                    if BoxCheck(u, lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t) and u.is_combat ~= false then
                        u.hp = 0
                    end
                end)
            end--快速击破boss
            if key == KEY.G then
                for luafile in pairs(package.loaded) do
                    package.loaded[luafile] = nil
                end
                DoFile("mod\\_editor_output.lua")
                --DoFile("THlib\\UI\\UI.lua")
                DoFile("THlib\\ext\\ext_boss.lua")
                DoFile("Resources\\System\\system.lua")
                --DoFile("THlib\\player\\aya\\aya_system.lua")
                InitAllClass()
                stage.Restart()
            end--快速加载并重开
            if key == KEY.ADD then
                for _ = 1, 120 do
                    DoFrame()
                    ext.MusicFrame("timer")
                end
                ext.FastMusic()
            end--快进
            do
                local testing = io.open("testing.lua", "r")
                if testing then
                    local text = testing:read("*a")
                    if string.match(text, "\n", now) then
                        t = string.sub(text, now)
                        now = #text + 1
                        Print(t)
                        load(t)()
                    end
                    testing:close()
                end
            end--控制台
        end
    end
end

--超前渲染和超后渲染（？

CreateRenderTarget("PauseMenuBlur")
function ext.BeforeRender()
    if not ext.pause_menu:IsKilled() then
        PushRenderTarget("PauseMenuBlur")
        RenderClear(Color(0, 0, 0, 0))
    end
end

function ext.AfterRender()
    --暂停菜单渲染
    ext.boss_ui:render()
    if not ext.pause_menu:IsKilled() then
        PopRenderTarget("PauseMenuBlur")
    end
    ext.pause_menu:render()
    ext.manual:render()
    achievement:render()
    SetViewMode("ui")
    ext.RenderFPS()
    SetViewMode("world")
end

---文文拍照系统
CreateRenderTarget("temp")
function ext.CameraBefore()
    if IsValid(player) and player.camera and player.camera.photoing then
        PushRenderTarget("PhotoTexture")
        RenderClear(Color(0xFF000000))
        PushRenderTarget("temp")
        RenderClear(Color(0xFF000000))
    end
end

function ext.CameraAfter()
    if IsValid(player) and player.camera and player.camera.photoing then
        local c = player.camera
        PopRenderTarget("temp")
        PostEffect("fx:SaveScreen", "temp", 6, "one", {}, {})
        PopRenderTarget("PhotoTexture")
        local WorldToScreen = WorldToScreen
        local x1, y1 = WorldToScreen(c.A.x, c.A.y)
        local x2, y2 = WorldToScreen(c.B.x, c.B.y)
        local x3, y3 = WorldToScreen(c.C.x, c.C.y)
        local x4, y4 = WorldToScreen(c.D.x, c.D.y)
        PostEffect("fx:lilyBlur", "PhotoTexture", 6, "mul+add", {
            { 100.0, 0.0, 0.0, 0.0 }, -- sigma未使用？, 未使用, 未使用, 未使用
            { x1, x2, x3, x4 }, -- Ax, Bx, Cx, Dx
            { y1, y2, y3, y4 }, -- Ay, By, Cy, Dy
        }, {})

        Render4V("photoa", c.A.x, c.A.y, 0.5, c.B.x, c.B.y, 0.5, c.C.x, c.C.y, 0.5, c.D.x, c.D.y, 0.5)
        SetImageState("photoc", "mul+add", 155, 250, 128, 250 - c.circleR * 100)
        Render("photoc", c.centerx, c.centery, 0, c.circleR)
    end
end

---保存游戏图像
CreateRenderTarget("LittleSnapShot")
ext.saveScreenFlag = false
ext.FRAMECOUNT = 0
ext.saveScreenToFile = nil
function ext.saveScreenBefore()
    if ext.saveScreenToFile then
        ext.saveScreenFlag = true
        ext.saveScreenToFile = nil
    end
    if ext.saveScreenFlag then
        PushRenderTarget("LittleSnapShot")
        RenderClear(Color(0xFF000000))
    end
end
function ext.saveScreenAfter()
    if ext.saveScreenFlag then
        PopRenderTarget("LittleSnapShot")
        PostEffect("fx:SaveScreen", "LittleSnapShot", 6, "", {}, {})
        if not ext.replay.IsReplay() then
            ext.needSaveToFile = true
        end
        ext.saveScreenFlag = nil
    end
end

function ext.RenderFPS()
    if ext.replay.IsReplay() then
        SetFontState("Score", "", 255, 190, 190, 190)
        RenderText("Score", "Replaying..", 956, 19, 0.25, "right", "bottom")
    end
    SetFontState("Score", "", 255, 255, 255, 255)
    RenderText("Score", ui.version, 956, 10, 0.25, "right", "bottom")
    local fps = GetFPS()
    if fps >= 59 then
        SetFontState("Score", "", 255, 189, 252, 201)
    elseif fps > 55 then
        SetFontState("Score", "", 255, 255, 227, 132)
    else
        SetFontState("Score", "", 255, 250, 128, 114)
    end
    RenderText("Score", string.format("%.1ffps", fps), 956, 1, 0.25, "right", "bottom")
end

function ext.GetFakeFPS()
    local player = player
    local v = lstg.var
    return ext.time_slow_level[Forbid(lstg.var.timeslow or 1, 1, 4)] *
            ((IsValid(player) and player.camera and player.camera.fpsing) and (player.camera.fps / 60) or 1) *
            ((v.CYFPS or 60) / 60)
end

CreateRenderTarget("mask_fader")
---@class mask_fader
mask_fader = {
    name = "mask_fader",
    time = 0,
    maxtime = 30,
    color = Color(255, 255, 255, 255),
    blend = "one",
    tox = function(t, x)
        return t * x
    end,
    toy = function(t, y)
        return t * (540 - y)
    end,
}
function mask_fader:BeforeRender()
    if self.time > 0 then
        PushRenderTarget(self.name)
        RenderClear(Color(255, 0, 0, 0))
    end
end
function mask_fader:frame()
    self.time = self.time - 1
end
function mask_fader:AfterRender()
    if self.time > 0 then
        PopRenderTarget(self.name)
        SetViewMode("ui")
        local k = screen.scale
        local index
        if self.mode then
            index = 1 - task.SetMode[1](self.time / self.maxtime)
        else
            index = task.SetMode[2](self.time / self.maxtime)
        end
        local rot = 90 - index * 90
        local cosr, sinr = cos(rot), sin(rot)
        local RenderTexture = RenderTexture
        local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
        uv1[6] = self.color
        uv2[6] = self.color
        uv3[6] = self.color
        uv4[6] = self.color
        for x = 0.5, 47.5 do
            for y = 0.5, 27.5 do
                uv1[4], uv1[5] = self.tox(k, x * 20 - 10), self.toy(k, y * 20 + 10)
                uv2[4], uv2[5] = self.tox(k, x * 20 + 10), self.toy(k, y * 20 + 10)
                uv3[4], uv3[5] = self.tox(k, x * 20 + 10), self.toy(k, y * 20 - 10)
                uv4[4], uv4[5] = self.tox(k, x * 20 - 10), self.toy(k, y * 20 - 10)
                uv1[1], uv1[2] = x * 20 - 10 * index * cosr - 10 * sinr, y * 20 + 10 * cosr - 10 * index * sinr
                uv2[1], uv2[2] = x * 20 + 10 * index * cosr - 10 * sinr, y * 20 + 10 * cosr + 10 * index * sinr
                uv3[1], uv3[2] = x * 20 + 10 * index * cosr + 10 * sinr, y * 20 - 10 * cosr + 10 * index * sinr
                uv4[1], uv4[2] = x * 20 - 10 * index * cosr + 10 * sinr, y * 20 - 10 * cosr - 10 * index * sinr
                RenderTexture(self.name, self.blend, uv1, uv2, uv3, uv4)
            end
        end
    end
end
function mask_fader:Do(mode, time)
    self.time = time or 30
    self.time = self.time + 1
    self.maxtime = time or 30
    self.mode = mode == "open"
end

LoadFX("fx:gray_color", "shader\\gray.hlsl")

function PostEffectGrayColor(tex, alpha, flag)
    flag = flag or 0.0
    PostEffect("fx:gray_color", tex, 6, (flag == 1) and "mul+add" or "", {
        { alpha, flag, 0.0, 0.0 }
    }, {})
end

---@class Failed_Show
Failed_Show = {
    alpha = 0,
    timer = 0,
    x = 480, y = 270,
    tex = "Final_SHOW_tex"
}
CreateRenderTarget(Failed_Show.tex)
function Failed_Show:Do(time)
    self.timer = 0
    self.alpha = 0
    task.New(self, function()
        for i = 1, time do
            i = task.SetMode[2](i / time)
            self.alpha = i
            task.Wait()
        end
        for i = 1, 30 do
            i = task.SetMode[2](i / 30)
            self.alpha = 1 - i
            task.Wait()
        end
    end)

end
function Failed_Show:frame()
    task.Do(self)
    self.timer = self.timer + 1
end
function Failed_Show:BeforeRender()
    if self.alpha > 0 then
        PushRenderTarget(self.tex)
        RenderClear(Color(0, 0, 0, 0))
    end
end
function Failed_Show:AfterRender()
    local A = self.alpha
    if A > 0 then
        PopRenderTarget(self.tex)
        PostEffectGrayColor(self.tex, A)
        SetImageState("white", "", A * 120, 0, 0, 0)
        RenderRect("white", 0, 960, 0, 540)
    end
end

---@class ui_drawing
ui_drawing = {}
function ui_drawing:init()
    self.timer = 0

    self.keyname = KeyCodeToName()
    self.pos = { { "up", 0, 0 }, { "down", 0, -1 }, { "left", -1, -1 }, { "right", 1, -1 },
                 { "slow", 0, 2 }, { "shoot", -1, 1 }, { "spell", 0, 1 }, { "special", 1, 1 } }
    self.used_color = {
        Color(120, 50, 50, 50),
        Color(180, 150, 150, 150),
        Color(120, 125, 64, 57),
        Color(180, 255, 227, 132)
    }
    for _, i in ipairs(self.pos) do
        i[4] = self.used_color[1]
        i[5] = self.used_color[2]
    end
end
function ui_drawing:frame()
    self.timer = self.timer + 1
    if not setting.displaykey then
        return
    end
    local KeyIsDown = KeyIsDown
    for _, i in ipairs(self.pos) do
        if KeyIsDown(i[1]) then
            i[4] = self.used_color[3]
            i[5] = self.used_color[4]
        else
            i[4] = self.used_color[1]
            i[5] = self.used_color[2]
        end
    end
end
function ui_drawing:Beforerender()
    if lstg.var.init_player_data and not stage.current_stage.is_menu and not ext.notUIdraw then
        SetViewMode 'ui'
        RenderClearViewMode(Color(255, 0, 0, 0))
        ui.DrawFrame(self)

    end
end
function ui_drawing:Afterrender()
    if lstg.var.init_player_data and not stage.current_stage.is_menu and not ext.notUIdraw then
        if lstg.var.init_player_data then

            ui.DrawScore(self)
        end
        lstg.system:render()
        if not setting.displaykey then
            return
        end

        SetViewMode("ui")
        local w = lstg.world
        local size = 1.5 - (w.scrr - 672) / 128 * 0.5
        local x, y = (w.scrr + 960) / 2, w.scrb + size * 25 + 5

        for _, i in ipairs(self.pos) do

            SetImageState("white", "", i[4])
            SetFontState("Score", "", i[5])
            Render("white", x + i[2] * size * 20, y + i[3] * size * 20, 0, size * 20 / 16)
            Render("white", x + i[2] * size * 20, y + i[3] * size * 20, 0, size * 15 / 16)
            RenderText("Score", self.keyname[cur_setting.keys[i[1]]], x + i[2] * size * 20, y + i[3] * size * 20, 0.15 * size, "centerpoint")
        end
        SetViewMode("world")

    end
end
ui_drawing:init()


--音乐相关
local CheckRes = CheckRes
local LoadMusic = LoadMusic
local RemoveResource = RemoveResource

local SetBGMSpeed = SetBGMSpeed
local int = int
local GetBGMSpeed = GetBGMSpeed
local pairs = pairs

local path = "music\\"
local play = PlayMusic
local stop = StopMusic
local get = GetMusicState
local set = SetBGMVolume
local function PlayMusic(bgm, v, start_time)
    if not CheckRes("bgm", bgm) then
        local musicList = musicList
        SetResourceStatus("global")
        LoadMusic(bgm, path .. bgm .. ".ogg", musicList[bgm][1], musicList[bgm][2])
        SetResourceStatus("stage")
    end
    play(bgm, v, start_time)
end
local function StopMusic(bgm)
    if CheckRes("bgm", bgm) then
        stop(bgm)
    end
    RemoveResource("global", 4, bgm)
end
function SetBGMVolume(bgm, v)
    if not v then
        set(bgm)
    else
        if CheckRes("bgm", bgm) then
            set(bgm, v)
        end
    end
end
function GetMusicState(bgm)
    if not CheckRes("bgm", bgm) then
        return false
    else
        return get(bgm)
    end
end

ext.PlayMusic = PlayMusic
ext.StopMusic = StopMusic
ext.ResumeMusic = ResumeMusic
ext.PauseMusic = PauseMusic
ext.music = {}
function _G.PlayMusic(bgm, v, start_time, force)
    local musicList = musicList
    start_time = start_time or 0
    start_time = start_time - int(start_time / musicList[bgm][1]) * musicList[bgm][2]
    ext.PlayMusic(bgm, v, start_time)
    SetBGMSpeed(bgm, 1)
    ext.music[bgm] = { faketimer = int(start_time * 60), timer = int(start_time * 60), paused = false, force = force }
end
function _G.StopMusic(bgm)
    ext.StopMusic(bgm)
    ext.music[bgm] = nil
end
function _G.ResumeMusic(bgm)
    ext.ResumeMusic(bgm)
    ext.music[bgm].paused = false
end
function _G.PauseMusic(bgm)
    ext.PauseMusic(bgm)
    ext.music[bgm].paused = true
end

function ext.SetMusicSpeed(speed)
    for p in pairs(ext.music) do
        if GetMusicState(p) == "playing" then
            if GetBGMSpeed(p) ~= speed then
                SetBGMSpeed(p, speed)
            end
        end
    end
end
function ext.DefaultMusic()
    for p, t in pairs(ext.music) do
        if not t.force then
            _G.StopMusic(p)
        end
    end
end
function ext.MusicFrame(k, i)
    i = i or 1
    for _, m in pairs(ext.music) do
        m[k] = m[k] + i
    end
end
function ext.FastMusic()
    for bgm, m in pairs(ext.music) do
        if m.timer ~= m.faketimer then
            m.faketimer = m.timer
            local loopend = musicList[bgm][1] * 60
            local looplength = musicList[bgm][2] * 60
            if m.timer <= loopend then
                PlayMusic(bgm, 1, m.timer / 60)
            else
                while m.timer > loopend do
                    m.timer = -looplength + m.timer
                end
                PlayMusic(bgm, 1, m.timer / 60)
            end

        end
    end
end
