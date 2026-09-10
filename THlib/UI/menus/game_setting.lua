-------------------------game_setting--------------------------------------

local function other_setting_default()
    local cs = cur_setting
    local ds = default_setting
    cs.bgmvolume = ds.bgmvolume
    cs.sevolume = ds.sevolume

    cs.ReplayFastSpeed = ds.ReplayFastSpeed
    cs.ReplaySlowSpeed = ds.ReplaySlowSpeed
   -- cs.FakeGameFPS = ds.FakeGameFPS
    cs.RepNoGameFps = ds.RepNoGameFps

    cs.displaykey = ds.displaykey
    cs.windowed = ds.windowed
    cs.vsync = cs.vsync
    cs.frameskip = ds.frameskip

    cs.SCAutoRetry = ds.SCAutoRetry

    cs.displayBG = ds.displayBG
    cs.auradistortion = ds.auradistortion
    cs.easyrender = ds.easyrender

end

local setting_bar = plus.Class()
---@param display_way fun(t:number):string
function setting_bar:init(display_name, set_name, small_index, big_index, min, max, min_unit, x1, x2, y1, y2, display_way)
    self.display_name = display_name
    self.name = set_name
    self.small = small_index
    self.big = big_index
    self.max = max
    self.min = min
    self.min_unit = min_unit
    self.choosing = false
    if x1 > x2 then
        x1, x2 = x2, x1
    end
    if y1 > y2 then
        y1, y2 = y2, y1
    end
    self.x1, self.x2, self.y1, self.y2 = x1, x2, y1, y2
    self.display_way = display_way
    self.locked = true
    if cur_setting[self.name] == nil then
        cur_setting[self.name] = default_setting[self.name]
    end
end
function setting_bar:frame()
    if not self.locked then
        if self.choosing then
            local mouse = ext.mouse
            local key = GetLastKey()
            local value = 0
            if key == setting.keys.left then
                value = -1
            end
            if key == setting.keys.right then
                value = 1
            end
            if value ~= 0 then
                value = value * (GetKeyState(KEY.SHIFT) and self.big or self.small)
                cur_setting[self.name] = Forbid(cur_setting[self.name] + value, self.min, self.max)
                PlaySound('select00')
            end
            if key == KEY.R then
                cur_setting[self.name] = default_setting[self.name]
            end
            local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
            local width = x2 - x1
            local height = y2 - y1
            if mouse:isPress(1) then
                if sp.math.PointBoundCheck(mouse.x, mouse.y, x1 + width / 12 - 4, x2 - width / 12 + 4, y1 + height / 3 - 4, y1 + height / 3 + 4) then
                    local _x1, _x2 = x1 + width / 12, x2 - width / 12
                    local index = (_x2 - _x1) / (self.max - self.min)
                    local part = index * self.min_unit
                    local nx = self.align(mouse.x, _x1, part)
                    local before = cur_setting[self.name]
                    local after = self.min + (nx - _x1) / (_x2 - _x1) * (self.max - self.min)
                    if before ~= after then
                        cur_setting[self.name] = Forbid(after, self.min, self.max)
                        PlaySound("select00")
                    end
                end
            end
        end
    end
end

function setting_bar:render(alpha)
    if alpha ~= 0 then
        local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
        local width = x2 - x1
        local height = y2 - y1
        local r, g, b
        if self.choosing then
            SetImageState("white", "", alpha * 78, 255, 227, 132)
            r, g, b = 255, 255, 255
        else
            SetImageState("white", "", alpha * 78, 0, 0, 0)
            r, g, b = 180, 180, 180
        end
        RenderRect("white", x1 - 1, x2 + 1, y1 - 1, y2 + 1)
        RenderRect("white", x1 + 1, x2 - 1, y1 + 1, y2 - 1)
        SetImageState("white", "", alpha * 255, r, g, b)
        RenderRect("white", x1 + width / 12 - 1, x2 - width / 12 + 1, y1 + height / 3 - 1.4, y1 + height / 3 + 1.4)
        SetImageState("white", "", alpha * 200, 10, 10, 10)
        RenderRect("white", x1 + width / 12, x2 - width / 12, y1 + height / 3 - 0.7, y1 + height / 3 + 0.7)

        local percent = (cur_setting[self.name] - self.min) / (self.max - self.min)
        SetImageState("white", "", alpha * 255, r, g, b)
        misc.SectorRender(x1 + width / 12 + (x2 - x1 - width / 6) * percent, y1 + height / 3, 0, 4, 0, 360, 10)
        ui:RenderText("title", self.display_name, x1 + width / 12, y1 + height / 3 * 2,
                height / 3 * 1.8 / 32, Color(alpha * 255, r, g, b), "left", "vcenter")
        ui:RenderText("title", self.display_way(cur_setting[self.name]), x2 - width / 12, y1 + height / 3 * 2,
                height / 3 * 1.8 / 32, Color(alpha * 255, r, g, b), "right", "vcenter")
    end
end
function setting_bar.align(x, start, part)
    local align = (x - start) % part
    if abs(-align) > abs(part - align) then
        x = x + part - align
    else
        x = x - align
    end--对齐
    return x
end

local setting_button = plus.Class()
function setting_button:init(display_name, set_name, x1, x2, y1, y2, opposite, otherfunction)
    self.display_name = display_name
    self.name = set_name
    if x1 > x2 then
        x1, x2 = x2, x1
    end
    if y1 > y2 then
        y1, y2 = y2, y1
    end
    self.x1, self.x2, self.y1, self.y2 = x1, x2, y1, y2
    self.choosing = false
    self.locked = true
    self.opposite = opposite
    self.otherfunction = otherfunction or load("")
    if cur_setting[self.name] == nil then
        cur_setting[self.name] = default_setting[self.name]
    end
end
function setting_button:frame()
    if not self.locked then
        if self.choosing then
            local mouse = ext.mouse
            local key = GetLastKey()
            if (key == setting.keys.left) or (key == setting.keys.right) or key == setting.keys.shoot or key == KEY.ENTER then
                cur_setting[self.name] = not cur_setting[self.name]
                self.otherfunction()
                PlaySound('select00')
            end
            if key == KEY.R then
                cur_setting[self.name] = default_setting[self.name]
                self.otherfunction()
            end
            local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
            local width = x2 - x1
            local height = y2 - y1
            if mouse:isDown(1) then
                if sp.math.PointBoundCheck(mouse.x, mouse.y, x2 - width / 12 - height / 3 * 2, x2 - width / 12, y1 + height / 6, y2 - height / 6) then
                    cur_setting[self.name] = not cur_setting[self.name]
                    self.otherfunction()
                    PlaySound('select00')
                end
            end
        end
    end
end
function setting_button:render(alpha)
    if alpha ~= 0 then
        local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
        local width = x2 - x1
        local height = y2 - y1
        local r, g, b
        if self.choosing then
            SetImageState("white", "", alpha * 78, 255, 227, 132)
            r, g, b = 255, 255, 255
        else
            SetImageState("white", "", alpha * 78, 0, 0, 0)
            r, g, b = 180, 180, 180
        end
        RenderRect("white", x1 - 1, x2 + 1, y1 - 1, y2 + 1)
        RenderRect("white", x1 + 1, x2 - 1, y1 + 1, y2 - 1)
        ui:RenderText("big_text", self.display_name, x1 + width / 12, y1 + height / 2,
                height * 0.7 / 80, Color(alpha * 255, r, g, b), "left", "vcenter")
        SetImageState("white", "", alpha * 255, 0, 0, 0)
        misc.SectorRender(x2 - width / 12 - height / 3 + 1, y1 + height / 2 - 1, height / 3, height / 2.7, 0, 360, 6)
        SetImageState("white", "", alpha * 255, r, g, b)
        misc.SectorRender(x2 - width / 12 - height / 3, y1 + height / 2, height / 3, height / 2.7, 0, 360, 6)
        local flag
        if self.opposite then
            flag = not cur_setting[self.name]
        else
            flag = cur_setting[self.name]
        end
        if flag then
            SetImageState("white", "", alpha * 255, 0, 0, 0)
            misc.SectorRender(x2 - width / 12 - height / 3 + 1, y1 + height / 2 - 1, 0, height / 4, 0, 360, 6)
            if self.choosing then
                SetImageState("white", "", alpha * 255, 189, 252, 201)
            else
                SetImageState("white", "", alpha * 255, 189 / 2, 252 / 2, 201 / 2)
            end
            misc.SectorRender(x2 - width / 12 - height / 3, y1 + height / 2, 0, height / 4, 0, 360, 6)

        end
    end
end

local small_menu = plus.Class()
function small_menu:init(display_name, x1, x2, y1, y2, setting_item)
    self.display_name = display_name
    self.setting_item = setting_item
    if x1 > x2 then
        x1, x2 = x2, x1
    end
    if y1 > y2 then
        y1, y2 = y2, y1
    end
    self.x1, self.x2, self.y1, self.y2 = x1, x2, y1, y2
    self.choosing = false
    self.item_alpha = 0
end
function small_menu:frame()
    if self.choosing then
        self.item_alpha = min(self.item_alpha + max((-self.item_alpha + 1) * 0.1, 0.05), 1)
        for _, item in ipairs(self.setting_item) do
            item.locked = false
            item:frame()
        end
    else
        self.item_alpha = max(self.item_alpha + min((-self.item_alpha) * 0.1, -0.05), 0)
        for _, item in ipairs(self.setting_item) do
            item.locked = true
        end
    end
end
function small_menu:render(alpha)
    if alpha ~= 0 then
        local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
        local width = x2 - x1
        local height = y2 - y1
        local r, g, b
        if self.choosing then
            SetImageState("white", "", alpha * 78, 189, 252, 201)
            r, g, b = 255, 255, 255
        else
            SetImageState("white", "", alpha * 78, 0, 0, 0)
            r, g, b = 180, 180, 180
        end
        RenderRect("white", x1, x2, y1, y2)
        RenderRect("white", x1 - 1, x2 + 1, y1 - 1, y2 + 1)
        ui:RenderText("big_text", self.display_name, x1 + width / 2, y1 + height / 2,
                height * 0.9 / 80, Color(alpha * 255, r, g, b), "centerpoint")
        for _, item in ipairs(self.setting_item) do
            item:render(self.item_alpha * alpha)
        end
    end
end

---@param display_way fun(t:number):string
local function Newsetting_bar(display_name, set_name, small_index, big_index, min, max, min_unit, x1, x2, y1, y2, display_way)
    return setting_bar(display_name, set_name, small_index, big_index, min, max, min_unit, x1, x2, y1, y2, display_way)
end

local function Newsetting_button(display_name, set_name, x1, x2, y1, y2, opposite, otherfunction)
    return setting_button(display_name, set_name, x1, x2, y1, y2, opposite, otherfunction)
end

local function Newsmall_menu(display_name, x1, x2, y1, y2, setting_item)
    return small_menu(display_name, x1, x2, y1, y2, setting_item)
end

game_setting = Class(object)
function game_setting:init(exit)
    self.alpha = 0
    self.layer = LAYER.TOP
    self.group = GROUP.GHOST
    self.bound = false
    self.locked = true
    self.exit_func = exit
    self.pos1 = 1
    self.pos2 = 1
    self.x1, self.x2, self.y1, self.y2 = 100, 860, 40, 450
    self.dpline = 270
    self.h1, self.h2 = 70, 50
    local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
    local _line = self.dpline
    local h1, h2 = self.h1, self.h2
    self.menus = {
        Newsmall_menu("声音", x1, _line, y2 - h1 * 1, y2 - h1 * 0, {
            Newsetting_bar("音乐音量", "bgmvolume", 5, 10,
                    0, 100, 1, _line, x2, y2 - h2 * 1, y2 - h2 * 0, function(t)
                        return ("%d%%"):format(t)
                    end),
            Newsetting_bar("音效音量", "sevolume", 5, 10,
                    0, 100, 1, _line, x2, y2 - h2 * 2, y2 - h2 * 1, function(t)
                        return ("%d%%"):format(t)
                    end),
        }),
        Newsmall_menu("倍速", x1, _line, y2 - h1 * 2, y2 - h1 * 1, {
            Newsetting_bar("录像加速倍速", "ReplayFastSpeed", 15, 30,
                    15, 960, 1, _line, x2, y2 - h2 * 1, y2 - h2 * 0, function(t)
                        return ("x%0.2f"):format(t / 60)
                    end),
            Newsetting_bar("录像减速倍速", "ReplaySlowSpeed", 5, 10,
                    5, 60, 1, _line, x2, y2 - h2 * 2, y2 - h2 * 1, function(t)
                        return ("x%0.2f"):format(t / 60)
                    end),
            Newsetting_button("录像永远常速(无视游戏变速)", "RepNoGameFps", _line, x2, y2 - h2 * 3, y2 - h2 * 2)
        }),
        Newsmall_menu("画面", x1, _line, y2 - h1 * 3, y2 - h1 * 2, {
            Newsetting_button("显示按键状态", "displaykey", _line, x2, y2 - h2 * 1, y2 - h2 * 0),
            Newsetting_button("全屏模式", "windowed", _line, x2, y2 - h2 * 2, y2 - h2 * 1,
                    true, function()
                        ChangeVideoMode2(cur_setting)
                    end),
            Newsetting_button("垂直同步", "vsync", _line, x2, y2 - h2 * 3, y2 - h2 * 2,
                    nil, function()
                        ChangeVideoMode2(cur_setting)
                    end),
            Newsetting_button("跳帧模式(游玩时)", "frameskip", _line, x2, y2 - h2 * 4, y2 - h2 * 3),
        }),
        Newsmall_menu("其他", x1, _line, y2 - h1 * 4, y2 - h1 * 3, {
            Newsetting_button("符卡练习自动重开", "SCAutoRetry", _line, x2, y2 - h2 * 1, y2 - h2 * 0),
        }),
        Newsmall_menu("性能", x1, _line, y2 - h1 * 5, y2 - h1 * 4, {
            Newsetting_button("3D背景", "displayBG", _line, x2, y2 - h2 * 1, y2 - h2 * 0),
            Newsetting_button("Boss法阵特效", "auradistortion", _line, x2, y2 - h2 * 2, y2 - h2 * 1),
            Newsetting_button("简单UI渲染（减少动态渲染）", "easyrender", _line, x2, y2 - h2 * 3, y2 - h2 * 2),
        }),
    }
    self.menus[self.pos1].choosing = true
    self.menus[self.pos1].setting_item[self.pos2].choosing = true
    self.curb_size = 0
    self.maxb_size = 0
end
function game_setting:frame()
    task.Do(self)
    SetSEVolume(cur_setting.sevolume / 100)
    SetBGMVolume(cur_setting.bgmvolume / 100)

    self.curb_size = self.curb_size + (-self.curb_size + self.maxb_size) * 0.12
    if self.locked then
        return
    end
    menu:Updatekey()
    local mouse = ext.mouse
    menu:ControlExit(0, 30, 540, 510)
    save_setting()
    loadConfigure()
    if mouse._wheel ~= 0 then
        self.menus[self.pos1].choosing = false
        self.menus[self.pos1].setting_item[self.pos2].choosing = false
        self.pos2 = self.pos2 - sign(mouse._wheel)
        if self.pos2 == 0 then
            self.pos1 = sp:TweakValue(self.pos1 - 1, #self.menus, 1)
            self.pos2 = #self.menus[self.pos1].setting_item
        end
        if self.pos2 == #self.menus[self.pos1].setting_item + 1 then
            self.pos1 = sp:TweakValue(self.pos1 + 1, #self.menus, 1)
            self.pos2 = 1
        end
        self.menus[self.pos1].choosing = true
        self.menus[self.pos1].setting_item[self.pos2].choosing = true
        PlaySound("select00")
        task.New(self, function()
            for i = 1, 30 do
                self.tri_alpha = sin(i * 3)
                task.Wait()
            end
        end)
    end
    local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
    local _line = self.dpline
    local h1, h2 = self.h1, self.h2
    if mouse:isDown(1) then
        local x, y = mouse.x, mouse.y
        if sp.math.PointBoundCheck(x, y, x1, x2, y1, y2) then
            if x < _line then
                for p = 1, #self.menus do
                    if y > y2 - p * h1 and y < y2 - (p - 1) * h1 then
                        self.menus[self.pos1].choosing = false
                        self.menus[self.pos1].setting_item[self.pos2].choosing = false
                        self.pos1 = p
                        self.pos2 = Forbid(self.pos2, 1, #self.menus[self.pos1].setting_item)
                        self.menus[self.pos1].choosing = true
                        self.menus[self.pos1].setting_item[self.pos2].choosing = true
                        PlaySound("select00")
                        break
                    end
                end
            else
                for p = 1, #self.menus[self.pos1].setting_item do
                    if y > y2 - p * h2 and y < y2 - (p - 1) * h2 then
                        self.menus[self.pos1].choosing = false
                        self.menus[self.pos1].setting_item[self.pos2].choosing = false
                        self.pos2 = p
                        self.menus[self.pos1].choosing = true
                        self.menus[self.pos1].setting_item[self.pos2].choosing = true
                        PlaySound("select00")
                        break
                    end
                end
            end
        end

    end
    if menu:keyUp() then
        self.menus[self.pos1].choosing = false
        self.menus[self.pos1].setting_item[self.pos2].choosing = false
        self.pos2 = self.pos2 - 1
        if self.pos2 == 0 then
            self.pos1 = sp:TweakValue(self.pos1 - 1, #self.menus, 1)
            self.pos2 = #self.menus[self.pos1].setting_item
        end
        self.menus[self.pos1].choosing = true
        self.menus[self.pos1].setting_item[self.pos2].choosing = true
        task.New(self, function()
            for i = 1, 10 do
                self.tri_alpha = sin(i * 9)
                task.Wait()
            end
        end)
        PlaySound('select00', 0.3)
    end
    if menu:keyDown() then
        self.menus[self.pos1].choosing = false
        self.menus[self.pos1].setting_item[self.pos2].choosing = false
        self.pos2 = self.pos2 + 1
        if self.pos2 == #self.menus[self.pos1].setting_item + 1 then
            self.pos1 = sp:TweakValue(self.pos1 + 1, #self.menus, 1)
            self.pos2 = 1
        end
        self.menus[self.pos1].choosing = true
        self.menus[self.pos1].setting_item[self.pos2].choosing = true
        task.New(self, function()
            for i = 1, 10 do
                self.tri_alpha = sin(i * 9)
                task.Wait()
            end
        end)
        PlaySound('select00', 0.3)
    end
    if menu:keyNo() then
        self.exit_func()
        PlaySound('cancel00', 0.3)
    end
    for _, item in ipairs(self.menus) do
        item:frame()
    end
    if sp.math.PointBoundCheck(mouse.x, mouse.y, x1 + 12, _line - 12, y2 + 5, y2 + 25) then
        self.maxb_size = 1
        if mouse:isDown(1) then
            other_setting_default()
            PlaySound("select00")
        end
    else
        self.maxb_size = 0
    end
end
function game_setting:render()
    if self.alpha == 0 then
        return
    end

    ui:DrawBack(self.alpha, self.timer)
    for _, item in ipairs(self.menus) do
        item:render(self.alpha)
    end
    local x1, x2, y1, y2 = self.x1, self.x2, self.y1, self.y2
    local _line = self.dpline
    local h1, h2 = self.h1, self.h2
    SetImageState("white", "", self.alpha * 255, 255, 255, 255)
    misc.RenderOutLine("white", x1, x2, y2, y1, 0, 2)
    RenderRect("white", _line - 1, _line + 1, y2, y1)
    ui:RenderText("title", "[ R ]：单个恢复默认设置\n[ LShift ]：数量调整幅度增大",
            x2 - 1, y2 + 1, 0.8, Color(255 * self.alpha, 200, 200, 200), "right", "bottom")
    SetImageState("white", "", self.alpha * 255, 255, 255, 255)
    local s = self.curb_size
    misc.RenderOutLine("white", x1 + 12 - s * 5, _line - 12 + s * 5, y2 + 25 + s * 5, y2 + 5 - s * 5, 0, 2)
    ui:RenderText("title", "全部恢复默认设置",
            (x1 + _line) / 2, y2 + 15, 0.6 + s * 0.12, Color(255 * self.alpha, 250, 128, 114), "centerpoint")
    menu:RenderExit(0, 30, 540, 510, self.alpha)
end