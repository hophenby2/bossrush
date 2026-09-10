stage.group.New('menu', {}, "Bad Apple!!", true, 1)
stage.group.AddStage('Bad Apple!!', 'Loading@Bad Apple!!', true)
---@param self stage
stage.group.DefStageValue('Loading@Bad Apple!!', 'init', function(self)
    item._init_item(self)
    mask_fader:Do("open")
    New(_G[lstg.var.player_name])
    self.level = 1
    --Del(_lstg_system)
    ToBigScreen()
    player.realrealreal_lock = true
    task.New(self, function()
        local cao = New(Bad_Apple_Loading)
        while not cao.continue do
            task.Wait()
        end
    end)
    self:Next()
end)
stage.group.AddStage('Bad Apple!!', 'Bad Apple!!@Bad Apple!!', true)
---@param self stage
stage.group.DefStageValue('Bad Apple!!@Bad Apple!!', 'init', function(self)
    lstg.var.current_system = ""
    --ext.notUIdraw = true
    item._init_item(self)
    mask_fader:Do("open")
    New(_G[lstg.var.player_name])
    self.level = 1

    --Del(_lstg_system)
    ToBigScreen()
    PlayMusic("Bad Apple!!")
    New(Bad_Apple)
    task.New(self, function()
        task.Wait(13144)
        if lstg.var.dead < 40 then
            ext.achievement:get(43)
        end
    end)
    self:Next()
end)
Bad_Apple_Loading = Class(object)
function Bad_Apple_Loading:init()
    ext.notUIdraw = true
    DataBackUp()
    self.layer = LAYER.TOP
    self.unit = 1
    self.read = io.lines("BadApple\\file" .. self.unit)
    self['start'] = os.clock()
    self["end"] = os.clock()
    if Bad_Apple.load == "finish" then
        self.continue = true
    else
        self.continue = nil
        Bad_Apple.Pixel = {}
        Bad_Apple.Pixel[self.unit] = {}
    end
end
function Bad_Apple_Loading:frame()
    if not self.continue then
        local start_time, end_time = os.clock(), os.clock()
        while end_time - start_time < 1 / 60 do
            self.str = self.read()
            if self.str then
                self.tmp = nil
                local _init, s
                for i = 1, #self.str do
                    s = self.str:sub(i, i)
                    if s == "S" then
                        self.tmp = {}
                        table.insert(Bad_Apple.Pixel[self.unit], self.tmp)
                    elseif self.tmp then
                        if s == "[" then
                            _init = i + 1
                        end
                        if s == "]" then
                            table.insert(self.tmp, { self.str:sub(_init, i - 1):match("^(.-) (.-) (.-)$") })
                        end
                    end
                end
            else
                self.unit = self.unit + 1
                if self.unit > 7 then
                    Bad_Apple.load = "finish"
                    self.continue = true
                    return
                end
                Bad_Apple.Pixel[self.unit] = {}
                self.read = io.lines("BadApple\\file" .. self.unit)
            end
            end_time = os.clock()
        end
        self["end"] = os.clock()
    end
end
function Bad_Apple_Loading:render()
    SetViewMode("ui")
    SetImageState("white", "", 255, 0, 0, 0)
    RenderRect("white", 0, 960, 0, 540)
    RenderTTF('title', "少女折寿中" .. ("."):rep(int(self.timer / 10 % 6) + 1),
            480, 270, Color(255, 255, 255, 255), "centerpoint")
    RenderTTF('title', [[--性能耗用较高--
    --可能会引起崩坏，损坏游戏数据--
    --因此为你备份了存档，方便恢复--
    --请做好心理准备--]],
            480, 465, Color(255, 200, 200, 200), "centerpoint")
    RenderTTF('title', ("%0.2f"):format(self["end"] - self['start']),
            480, 315,
            Color(255, 255, 227, 132), "centerpoint")
end
Bad_Apple = Class(object)
Bad_Apple.Pixel = {}
Bad_Apple.text = {}
for w in io.lines("BadApple\\lyrics") do
    if w:match("^(.-)%-%-(.-)%-%-(.-)$") then
        table.insert(Bad_Apple.text, { w:match("^(.-)%-%-(.-)%-%-(.-)$") })
    end
end
function Bad_Apple:init()
    self.layer = LAYER.BG
    self.n = 1
    self.cao = {}
    self.group = GROUP.GHOST

    self.content = {  }
    for _, w in ipairs(self.class.text) do
        table.insert(self.content, w)
    end
    --Print(Serialize((self.song)))
    self.text = ""
    player.nextshoot = 99999
end
function Bad_Apple:New(rgb, x, y)
    table.insert(self.cao, { (x * 20 + 10) - 320, 240 - (y * 20 + 10), 0, (rgb == "A" and 255 or rgb) })
end
function Bad_Apple:frame()
    if self.n > 6572 then
        object.Del(self)
        return
    end
    lstg.var.score = lstg.var.score + 100
    AddMoney(max(0, 0.35 - player.protect))
    if self.timer % 2 == 1 then
        for _, p in pairs(self.class.Pixel[min(7, math.ceil(self.n / 1000))][self.n - 1000 * int((self.n - 1) / 1000)]) do
            self.class.New(self, unpack(p))
        end
        self.n = self.n + 1
    end
    local c
    for i = #self.cao, 1, -1 do
        c = self.cao[i]
        if tonumber(c[4]) > 200 and Dist(player.x, player.y, c[1], c[2]) < 16 then
            if player.class.colli(player, self) then
                lstg.var.score = lstg.var.score - 10000
            end
        end
        c[3] = c[3] + 1
        if c[3] > 2 then
            table.remove(self.cao, i)
        end
    end
    c = nil
    for i = #self.content, 1, -1 do
        c = self.content[i]
        if c[1] then
            if self.timer == int(tonumber(c[1]) * 60) then
                self.text = c[2] .. "\n" .. c[3]
                table.remove(self.content, i)
            end
        else
            table.remove(self.content, i)
        end
    end


end
function Bad_Apple:render()
    local img = "ball_big6"
    for _, c in ipairs(self.cao) do
        SetImageState(img, "add+alpha", tonumber(c[4]), sp:HSVtoRGB(c[1] * 0.5625 + self.timer / 2, 0.8, 0.8))
        Render(img, c[1], c[2], 0, 0.7)
    end
    local len = min(1, self.timer / 13144)
    SetImageState("white", "mul+add", 128, 255 - 155 * len, 100 + 155 * len, 100)
    RenderRect("white", -320, -320 + 640 * len, -240, -238)
    for i = 1, 4 do
        RenderTTF("title", self.text, cos(i * 90 + 45), -180 + sin(i * 90 + 45),
                Color(255, 0, 0, 0), "centerpoint")
    end
    RenderTTF("title", self.text, 0, -180, Color(255, 255, 255, 255), "centerpoint")
end
