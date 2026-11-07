---------------------------------------
---启动器
---------------------------------------

-- 分辨率界面只需要一组字体、一个色块和三种按键音；战斗框架等确认后再载入。
SetResourceStatus('global')
local load_text=dofile('THlib/UI/font_loader.lua')
load_text('launcher_title',32)
LoadTexture('launcher_misc','THlib\\misc\\misc.png')
LoadImage('launcher_white','launcher_misc',56,8,16,16)
for _,name in ipairs({'select00','ok00','cancel00'}) do
    LoadSound('launcher_'..name,'THlib\\se\\se_'..name..'.wav')
end
local function PlaySound(name,volume)
    lstg.PlaySound('launcher_'..name,volume or .3)
end
local background=FileExist('User\\menu_bg_2.png')
if background then LoadImageFromFile('launcher_bg','User\\menu_bg_2.png') end
local background_angle=ran:Float(-85,85)
local background_x,background_y=198+ran:Float(-120,120),264+ran:Float(-120,120)
local launcher_mouse={}
function launcher_mouse:frame()
    local x,y=GetMousePosition()
    self.x,self.y=(x-screen.dx)/screen.scale,(y-screen.dy)/screen.scale
    self.previous,self.down=self.down,GetMouseState(0)
end
function launcher_mouse:isUp() return self.previous and not self.down end
launcher_mouse:frame()
local launch_pending,launch_drawn=false,false

local settingfile = "User\\setting"

function save_setting()
    local f, msg
    f, msg = io.open(settingfile, 'w')
    if f == nil then
        error(msg)
    else
        f:write(format_json(Serialize(cur_setting)))--新方法by Xrysnow
        f:close()
    end
end

function setting_keys_default()
    cur_setting.keys.up = default_setting.keys.up
    cur_setting.keys.down = default_setting.keys.down
    cur_setting.keys.left = default_setting.keys.left
    cur_setting.keys.right = default_setting.keys.right
    cur_setting.keys.slow = default_setting.keys.slow
    cur_setting.keys.shoot = default_setting.keys.shoot
    cur_setting.keys.special = default_setting.keys.special
    cur_setting.keys.spell = default_setting.keys.spell
    cur_setting.keysys.repfast = default_setting.keysys.repfast
    cur_setting.keysys.repslow = default_setting.keysys.repslow
    cur_setting.keysys.menu = default_setting.keysys.menu
    cur_setting.keysys.snapshot = default_setting.keysys.snapshot
    cur_setting.keysys.retry = default_setting.keysys.retry
end
---------------------------------------

---------------------------------------
local key_state = {}
---@type table<string, boolean>
local last_key_state = {}
---@type table<string, number>
local key_map = {
    ["enter"] = 0x0D,
    ["esc"] = 0x1B,
    ["z"] = 0x5A,
    ["x"] = 0x58,
    ["F1"] = 0x70,
    ["F2"] = 0x71,
    ["F3"] = 0x72,
    ["F4"] = 0x73,
    ["F5"] = 0x74,
    ["TAB"] = 0x09,
}

local function UpdateInput()
    for k, v in pairs(key_map) do
        last_key_state[k] = key_state[k]
        key_state[k] = GetKeyState(v)
    end
    last_key_state["mouse left"] = key_state["mouse left"]
    last_key_state["mouse right"] = key_state["mouse right"]
    key_state["mouse left"] = GetMouseState(0)
    key_state["mouse right"] = GetMouseState(2)
end

---@param k string
---@return boolean
local function KeyPressing(k)
    return key_state[k]
end

---@param k string
---@return boolean
local function KeyUp(k)
    return last_key_state[k] and (not key_state[k])
end

local curresx, curresy
function ChangeVideoMode2(set)
    return ChangeVideoMode(setting.resx, setting.resy, set.windowed, set.vsync)

end

local function start_game()
    local watch=lstg.StopWatch()
    save_setting()
    loadConfigure()
    SetSplash(true)
    SetTitle(setting.mod)
    curresx = setting.resx
    curresy = setting.resy
    if not ChangeVideoMode2(setting) then
        error(setting.windowed and "Invalid Resolution" or "Failed to FullScreen")
        --stage.QuitGame()
        --return
    end
    SetSEVolume(setting.sevolume / 100)
    SetBGMVolume(setting.bgmvolume / 100)
    ResetScreen()--Lscreen
    SetResourceStatus 'global'
    Include("mod\\root.lua")
    --SetResourceStatus 'stage'
    InitAllClass()--Lobject
    InitGameSaveData()
    stage.Set('none', 'init')
    if lstg.SystemLog then lstg.SystemLog(('[启动] 确认分辨率后的初始化 %.1fms'):format(watch:GetElapsed()*1000)) end
end

local Sign = Class(object)
function Sign:init(boss, x, y, h, v, text, func, onFrame, keyfunc, otherkey)
    self.boss = boss
    self.x = x
    self.y = y
    self.func = func
    self.bound = false
    self.blk = 0
    self.d_r, self.d_g, self.d_b = 0, 0, 0
    self.layer = LAYER.TOP + 1000
    self.text = text
    self.scale = 1
    self.alpha = 0
    self.select = false
    self.h, self.v = h, v
    if onFrame then
        self.onFrame = onFrame
    end
    if keyfunc then
        self.keyfunc = keyfunc
    end
    if otherkey then
        self.otherkey = otherkey
    else
        self.otherkey = function()
            return false
        end
    end
    task.New(self, function()
        for i = 1, 30 do
            self.alpha = sin(i * 3)
            task.Wait()
        end
    end)
end
function Sign:frame()
    if launch_pending then return end
    task.Do(self)

    if self.onFrame then
        self.onFrame(self)
    end
    if (launcher_mouse.x>=self.x-self.h and launcher_mouse.x<=self.x+self.h
        and launcher_mouse.y>=self.y-self.v and launcher_mouse.y<=self.y+self.v) or self.otherkey() then
        if not self.select then
            PlaySound('select00', 0.3)
            task.New(self, function()
                for i = 1, 9 do
                    self.scale = 1 + 0.2 * sin(i * 10)
                    self.blk = 100 * sin(i * 10)
                    task.Wait()
                end
            end)
        end
        self.select = true
    else
        if self.select then
            task.New(self, function()
                for i = 8, 0, -1 do
                    self.scale = 1 + 0.2 * sin(i * 10)
                    self.blk = 100 * sin(i * 10)
                    task.Wait()
                end
            end)
        end
        self.select = false
    end
    if self.select then
        if launcher_mouse:isUp() and self.func then
            self.func(self.boss)
            PlaySound('ok00', 0.3)
        end
    end
    if self.keyfunc then
        if self.keyfunc() then
            self.func(self.boss)
            PlaySound('ok00', 0.3)
        end
    end
end
function Sign:render()
    SetViewMode "ui"
    for p = 0, 7 do
        SetImageState("launcher_white", "", (80 - p * 10) * self.alpha, 0, 0, 0)
        RenderRect("launcher_white", self.x - self.h + p, self.x + self.h + p, self.y - self.v - p, self.y + self.v - p)
    end
    local rgb = 230 - self.blk
    SetImageState("launcher_white", "mul+add", 140 * self.alpha, rgb - self.d_r, rgb - self.d_g, rgb - self.d_b)
    RenderRect("launcher_white", self.x - self.h, self.x + self.h, self.y - self.v, self.y + self.v)

    RenderTTF("launcher_title", self.text, self.x, self.y, Color(255 * self.alpha, self.blk * 2, self.blk * 2, self.blk * 2), "centerpoint")
    SetViewMode("world")
end

local OldResolution = { { 640, 480 }, { 900, 600 }, { 960, 720 }, { 1024, 768 }, { 1280, 960 } }
local Resolution = { { 960, 540 }, { 1200, 675 }, { 1440, 810 }, { 1680, 945 }, { 1920, 1080 } }
stage_launcher = stage.New('settings', true, true)

function stage_launcher:init()

    self.smear = {}
    --
    local f, msg
    f, msg = io.open(settingfile, 'r')
    if f == nil then
        cur_setting = DeSerialize(Serialize(default_setting))
    else
        cur_setting = DeSerialize(f:read('*a'))
        f:close()
    end
    for i = 1, 5 do

        if cur_setting.resx == OldResolution[i][1] and cur_setting.resy == OldResolution[i][2] then
            cur_setting.resx = Resolution[i][1]
            cur_setting.resy = Resolution[i][2]
            --老版本兼容
            --break
        end
    end
    --
    local function ExitGame()
        task.New(self, function()
            task.Wait(30)
            stage.QuitGame()
        end)
    end
    --
    New(Sign, self, 98, 204, 50, 18, "开启(Z,Enter)",
            function()
                cur_setting.mod = "TouHou Boss Rush"
                launch_pending=true
            end,
            nil,
            function()
                return (KeyUp("enter") or KeyUp("z"))
            end,
            function()
                return (KeyPressing("enter") or KeyPressing("z"))
            end)
    New(Sign, self, 298, 204, 50, 18, "退出(X,Esc)",
            function()
                ExitGame()
            end,
            nil,
            function()
                return (KeyUp("esc") or KeyUp("x"))
            end,
            function()
                return (KeyPressing("esc") or KeyPressing("x"))
            end)
    for i = 1, #Resolution do
        New(Sign, self, 198, 464 - (i - 1) * 30, 57, 10, ("%d*%d(F%d)"):format(Resolution[i][1], Resolution[i][2], i),
                function()
                    cur_setting.resx = Resolution[i][1]
                    cur_setting.resy = Resolution[i][2]
                    save_setting()
                end,
                function(self)
                    if cur_setting.resx == Resolution[i][1] and cur_setting.resy == Resolution[i][2] then
                        self.d_r, self.d_g, self.d_b = 40, 70, 40
                    else
                        self.d_r, self.d_g, self.d_b = 0, 0, 0
                    end
                end,
                function()
                    return (KeyUp("F" .. i))
                end,
                function()
                    return (KeyPressing("F" .. i))
                end)
    end
    New(Sign, self, 198, 300, 55, 14, "全屏模式(Tab)",
            function()
                cur_setting['windowed'] = not cur_setting['windowed']
                save_setting()
            end,
            function(self)
                if not cur_setting['windowed'] then
                    self.d_r, self.d_g, self.d_b = 40, 70, 40
                else
                    self.d_r, self.d_g, self.d_b = 0, 0, 0
                end
            end,
            function()
                return (KeyUp("TAB"))
            end,
            function()
                return (KeyPressing("TAB"))
            end)

end
function stage_launcher:frame()
    task.Do(self)
    UpdateInput()
    launcher_mouse:frame()
end
function stage_launcher:render()
    if launch_pending then RenderClear(Color(255,0,0,0));return end
    SetViewMode "ui"
    if background then
        SetImageState('launcher_bg','',255,90,90,90)
        Render('launcher_bg',background_x,background_y,background_angle)
    end
    RenderTTF('launcher_title','请选择分辨率',198,492,Color(255,255,255,255),'centerpoint')
    SetViewMode "world"
end

-- 启动器独立更新，避免首次显示前加载弹幕、激光、暂停菜单和原作ANM数据。
-- 确认后由THlib/ext/ext.lua替换这两个回调；先画一帧黑屏再执行同步初始化。
function FrameFunc()
    if launch_pending and launch_drawn then
        start_game()
        return lstg.quit_flag
    end
    if stage.next_stage then
        stage.current_stage=stage.next_stage;stage.next_stage=nil
        stage.current_stage.timer=0
        stage.current_stage:init()
    end
    local current=stage.current_stage
    if current then current:frame();current.timer=current.timer+1 end
    ObjFrame()
    UpdateXY()
    AfterFrame()
    return lstg.quit_flag
end
function RenderFunc()
    BeginScene()
    RenderClear(Color(255,0,0,0))
    if launch_pending then
        launch_drawn=true
    else
        if stage.current_stage then stage.current_stage:render() end
        ObjRender()
    end
    EndScene()
end
function FocusLoseFunc() end
