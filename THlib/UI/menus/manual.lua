local function loadtxt()
    local keyname = KeyCodeToName()
    local k = cur_setting.keys
    local list, tmp = {}
    for str in io.lines("manual") do
        if str == "--manual" then
            tmp = {}
            table.insert(list, tmp)
        elseif tmp then
            table.insert(tmp, str)
        end
    end
    local match = '^.- %-%- (.-)$'
    local t = string.match(list[2][3], match)
    list[2][3] = "(1) [" .. keyname[k.up] .. "]  [" .. keyname[k.down] .. "]  [" .. keyname[k.left] .. "]  [" .. keyname[k.right] .. "]  --  " .. t
    t = string.match(list[2][4], match)
    list[2][4] = "(2) [" .. keyname[k.shoot] .. "]  [" .. keyname[k.spell] .. "]  [" .. keyname[k.special] .. "]  --  " .. t
    t = string.match(list[2][5], match)
    list[2][5] = "(3) [" .. keyname[k.slow] .. "]  --  " .. t
    t = string.match(list[2][6], match)
    k = cur_setting.keysys
    list[2][6] = "(4) [" .. keyname[k.menu] .. "]  --  " .. t
    t = string.match(list[2][16], match)
    list[2][16] = "(1) [" .. keyname[k.repfast] .. "]  --  " .. t
    t = string.match(list[2][17], match)
    list[2][17] = "(2) [" .. keyname[k.repslow] .. "]  --  " .. t
    t = string.match(list[2][18], match)
    list[2][18] = "(3) [" .. keyname[k.snapshot] .. "]  --  " .. t
    return list
end

---@class manual
manual = Class(object)
function manual:refresh()
    self.content = loadtxt()
end
function manual:init(exitFunc)
    self.x, self.y = screen.width / 2, screen.height / 2
    self.alpha = 0
    self.bound = false
    self.locked = true
    self.text_hscale = 0
    self.text_vscale = 0
    self.changeState = function(c)
        task.New(self, function()
            if c == "out" then
                for i = 1, 20 do
                    self.tri_alpha = 1 - sin(i * 4.5)
                    coroutine.yield()
                end
            else
                for i = 1, 20 do
                    self.tri_alpha = sin(i * 4.5)
                    coroutine.yield()
                end
            end
        end)
    end
    self.text = {
        "1.游戏的进行方式",
        "2.操作方法",
        "3.界面与机制",
        "4.射命丸文和拍照模式",
        "5.琪露诺和冻结模式",
        "6.特色系统相关",
        "7.关于bossrush",
    }
    self.content = loadtxt()
    self.pos = 1
    self.alpha = 0
    self.tri_alpha = 1
    self.state = 1
    self.exit_func = exitFunc
    self.pos_pre = 1
    self.pos_changed = 0
    self.no_pos_change = false
end
function manual:frame()
    task.Do(self)
    if self.locked then
        return
    end
    menu:Updatekey()
    menu:ControlExit(0, 30, 540, 510)
    if menu:keyNo() then
        PlaySound("cancel00", 0.3)
        if self.state == 1 then
            if self.exit_func then
                self.exit_func()
            end
        elseif self.state == 2 then
            task.New(self, function()
                self.locked = true
                self.changeState("out")
                task.MoveTo(screen.width / 2, screen.height / 2, 20, 2)
                self.state = 1
                self.locked = false
            end)
        end
    elseif menu:keyYes() and self.state ~= 2 then
        self.state = 2
        task.New(self, function()
            self.locked = true
            self.changeState()
            task.MoveTo(-screen.width / 2, screen.height / 2, 20, 2)
            self.locked = false
        end)
        PlaySound("ok00", 0.3)
    else
        if menu:keyUp() and (not self.no_pos_change) then
            self.pos = sp:TweakValue(self.pos - 1, #self.text, 1)
            self.changeState()
            PlaySound('select00', 0.3)
        end
        if menu:keyDown() and (not self.no_pos_change) then
            self.pos = sp:TweakValue(self.pos + 1, #self.text, 1)
            self.changeState()
            PlaySound('select00', 0.3)
        end
        local mouse = ext.mouse
        if mouse:isDown(1) then
            if self.state == 2 then
                if self.pos == 7 then
                    if sp.math.PointBoundCheck(mouse.x, mouse.y, 117 + 620 + self.x, 167 + 620 + self.x, 354+60, 379+60) then
                        os.execute("explorer \"https://space.bilibili.com/24053931\"")
                        PlaySound("ok00", 0.3)
                    end
                end
            else
                local height = ui.menu.line_height
                local selected = menu:mouseCheck(self.y + (#self.text + 1) * height * 0.5, 0, height, #self.text)
                if selected then
                    if selected ~= self.pos then
                        PlaySound("select00")
                        self.pos = selected
                        self.changeState()
                    else
                        self.state = 2
                        task.New(self, function()
                            self.locked = true
                            self.changeState()
                            task.MoveTo(-screen.width / 2, screen.height / 2, 20, 2)
                            self.locked = false
                        end)
                        PlaySound("ok00", 0.3)
                    end
                end
            end
        end
        if mouse._wheel ~= 0 then
            self.pos = sp:TweakValue(self.pos - sign(mouse._wheel), #self.text, 1)
            self.changeState()
            PlaySound("select00")
        end
    end
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
    if self.pos_pre ~= self.pos then
        self.pos_changed = ui.menu.shake_time
    end
    self.pos_pre = self.pos
end
function manual:render()
    if self.alpha == 0 then
        return
    end
    ui:DrawBack(self.alpha, self.timer)
    ui:DrawMenu("", self.text, self.pos, self.x - 150, self.y + 320 - self.alpha * 320,
            self.alpha, self.timer, self.pos_changed, "left", self.tri_alpha)
    if self.state == 2 then
        if self.pos == 7 then
            SetImageState("white", "", self.alpha * self.tri_alpha * 255, 255, 255, 255)
            RenderRect("white", 117 + 620 + self.x, 167 + 620 + self.x, 354.5+60, 354+60)
        end
        ui:RenderText("manual", string.format("--%s\n%s", self.text[self.pos], table.concat(self.content[self.pos], "\n")),
                self.x + 700, 400+60, 1,
                Color(self.alpha * self.tri_alpha * 255, 255, 255, 255), "left")
    end
    menu:RenderExit(0, 30, 540, 510, self.alpha)
end