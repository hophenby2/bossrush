local cos, sin, abs, min, int, sign = cos, sin, abs, min, int, sign
local bullet, object, boss = bullet, object, boss
local task, ran, Create, sp = task, ran, Create, sp
local table = table
local GROUP, LAYER = GROUP, LAYER
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local IsValid = IsValid
local SetImageState = SetImageState
local Angle = Angle
local Render = Render
local Class = Class
local Newcharge_in = Newcharge_in

local card_start = function()
    if ext.sc_pr then
        task.MoveTo(0, 120, 60, 2)
    else
        task.Wait(60)
    end
end
local class = {}
_editor_class.TH165 = class
class.SCBG = Class(_SC_BG)
function class.SCBG:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "th15_5", false, 150, -180, 0, 0, 0, -0.1, "mul+add", 2, 2)
    b.a = 100
    b = _SC_BG.AddLayer(self, "th15_5", false, -180, 200, 0, 0, 0, -0.1, "mul+add", 2.5, 2.5)
    b.a = 100
    b = _SC_BG.AddLayer(self, "th15_4", true, 0, 0, 0, 0, 0.5)
end
function class.SCBG:frame()
    _SC_BG.frame(self)
    self.alpha = min(self.alpha, 0.5)
end

local name = ""
boss.Define("1a", "宇佐见堇子", "TH16_5_0", TH165_bg, { 0, 500 }, class.SCBG, "Sumireko", 16)
do
    local non1 = boss.card.New("", 1, 1, 40, 800)
    boss.card.add({ { non1, "1a" } }, 16, "非符一", 173)
    function non1:before()
        task.MoveTo(0, 80, 60, 2)
    end
    function non1:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local center = Class(bullet, {
                init = function(self, x, y, vx, vy)
                    bullet.init(self, ball_huge, 2, true, false)
                    self.x, self.y = x, y
                    self.vx, self.vy = vx, vy
                    self.omiga = self.vx
                    task.New(self, function()
                        local t = 0
                        local v, b
                        while true do
                            for z = -5, 5 do
                                v = 4 - abs(z) * 0.08 - t % 2 * 0.5
                                b = NewSimpleBullet(square, 8 + t % 2 * 6, self.x, self.y, v, t * 16 + z * 1.5, nil, nil, false)
                                b.t = t
                                b.v = v
                                task.New(b, function()
                                    local unit = task.GetSelf()
                                    object.ChangingV(unit, unit.v, 0.1, unit.rot, 100)
                                    task.Wait(30 + unit.t % 2 * 20)
                                    object.ChangingV(unit, 0.1, unit.v + unit.t % 2 * 2, unit.rot, 80)
                                end)
                            end
                            PlaySound("tan00")
                            t = t - sign(self.vx)
                            task.Wait()
                        end
                    end)
                end
            }, true)
            local d = 1
            while true do
                New(center, self.x, self.y, -3 * d, 1)
                for i = 1, 3 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 20 + i * 5) do
                        for v = 1, 3 do
                            bullet.SetLayer(NewSimpleBullet(square, 2, self.x, self.y, 3 - v * 0.1, a), LAYER.ENEMY_BULLET + 1)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(30)
                end
                d = -d
                task.Wait(60)
                task.MoveToPlayer(60, -96, 96, 70, 90, 20, 40, 10, 20, 2, 1)
                task.Wait(60)
            end
        end)
    end
end--non_sc1

do
    name = "恼「为什么我的手机不能录像」"
    local sc1 = boss.card.New(name, 2, 3, 60, 900)
    sc1.before = card_start
    function sc1:init()
        task.New(self, function()
            local camera = Class(object, {
                init = function(self, x, y)
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET_EF
                    self.x, self.y = x, y
                    self.img = "photoOFF"
                    self.hscale = 1.5
                    self.vscale = 1.5
                    self.a = 96 * 1.5
                    self.b = 128 * 1.5
                    self.rect = true
                    self.colli = false
                    self.bound = false
                    self.rot = 0
                    task.New(self, function()
                        PlaySound("shutter")
                        for i = 1, 30 do
                            self._a = 255 * sin(i * 3)
                            self.hscale = 1.5 - 0.6 * sin(i * 3)
                            self.vscale = self.hscale
                            self.a = 96 * self.hscale
                            self.b = 128 * self.hscale
                            task.Wait()
                        end
                        while true do
                            task.Wait(60)
                            Newcharge_in(self.x, self.y, 200, 200, 200)
                            task.Wait(60)
                            self.colli = true
                            self.on = true
                            PlaySound("kira00")
                            local angle = Angle(self, player)
                            for i = 1, 180 do
                                object.SetV(self, sin(i) * 2, angle)
                                task.Wait()
                            end
                            self.on = false
                            self.colli = false
                        end
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    self.rot = self.rot + sin(self.timer / 2)
                    CollisionCheck(self.group, GROUP.ENEMY_BULLET)
                end,
                colli = function(_, other)
                    if other.group == GROUP.ENEMY_BULLET then
                        object.Del(other)
                    end
                end,
                render = function(self)
                    SetImageState(self.img, "mul+add", self._a, 255, 255, 255)
                    DefaultRenderFunc(self)
                    if self.on then
                        SetImageState("photoON", "mul+add", self._a * 150, 255, 255, 255)
                        Render("photoON", self.x, self.y, self.rot, self.hscale * self._a / 255 * 0.95)
                        SetFontState("Score", "", 200, 255, 100, 100)
                        RenderText("Score", "Rec...", self.x, self.y, 0.4, "bottom", "left")
                    end
                end,
                kill = function(self)
                    object.Preserve(self)
                    lstg.var.timeslow = 1
                    task.New(self, function()
                        for i = 1, 15 do
                            self._a = 255 - 255 * sin(i * 6)
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                end,
                del = function(self)
                    self.class.kill(self)
                end
            }, true)
            Newcharge_in(self.x, self.y, 200, 200, 200)
            task.Wait(60)
            New(camera, self.x, self.y)
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 19) do
                    for v = 1, 3 do
                        NewSimpleBullet(square, 6, self.x, self.y, 1 + v * 0.3, a + v * 9)
                    end
                end
                PlaySound("tan00")
                task.Wait(60)
            end
        end)
    end
    function sc1:del()
        object.LaserDo(function(p)
            if IsValid(p) then
                object.RawDel(p)
            end
        end)
    end
    boss.card.add({ { sc1, "1a" } }, 16, name, 174)

end--sc1
do
    name = "恼「为什么我的卡背是哆来咪」"
    local sc2 = boss.card.New(name, 1, 1, 30, 500)
    sc2.before = card_start
    function sc2:init()
        task.New(self, function()
            task.MoveTo(0, 120, 60, 2)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local d = 1

            while true do
                local A = Angle(self, player)
                for da, r, v in sp.math.Advanced.Iterator(90, { "Increment", A, 23 * d }, { "Increment", 90, -4 * d }, { "SetValue", 4, 2, 1 }) do
                    for a in sp.math.AngleIterator(r, 2) do
                        for ra in sp.math.AngleIterator(da, 2) do
                            NewSimpleBullet(ball_big, 4, self.x + cos(ra) * 60, self.y + sin(ra) * 60, v, a)
                        end
                    end
                    for a in sp.math.AngleIterator(r, 3) do
                        for ra in sp.math.AngleIterator(da, 3) do
                            NewSimpleBullet(ball_mid, 2, self.x + cos(ra) * 60, self.y + sin(ra) * 60, v * 0.7, a)
                        end
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(3)
                end
                d = -d
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
                task.Wait(100)
            end
        end)
    end
    boss.card.add({ { sc2, "1a" } }, 16, name, 175)

end--sc2
do
    local non2 = boss.card.New("", 1, 1, 40, 800)
    boss.card.add({ { non2, "1a" } }, 16, "非符二", 198)
    function non2:before()
        task.MoveTo(0, 100, 60, 2)
    end
    function non2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local center = Class(bullet, {
                init = function(self, x, y, vx, vy)
                    bullet.init(self, ball_huge, 2, true, false)
                    self.x, self.y = x, y
                    self.vx, self.vy = vx, vy
                    self.omiga = self.vx
                    task.New(self, function()
                        local t = 0
                        local v, b
                        while true do
                            for z = -3, 3 do
                                v = 3 - abs(z) * 0.08 - t % 2 * 0.5
                                b = NewSimpleBullet(square, 4 + t % 2 * 6, self.x, self.y,
                                        v, t * 16 + z * 1.3, nil, nil, false)
                            end
                            PlaySound("tan00")
                            t = t - sign(self.vx)
                            task.Wait()
                        end
                    end)
                end
            }, true)
            local d = 1
            while true do
                New(center, self.x, self.y, -3 * d, -1)
                task.New(self, function()
                    local A = ran:Float(0, 360)
                    for i = 1, 3 do
                        for a in sp.math.AngleIterator(A + ran:Float(-5, 5), 16) do
                            for v = 1, 8 do
                                local b = NewSimpleBullet(square, 6, self.x, self.y, 3.6 - v * 0.2 - i * 0.2, a)
                                bullet.SetLayer(b, LAYER.ENEMY_BULLET + 1)
                            end
                        end
                        PlaySound("kira00")
                        task.Wait(60)
                    end
                end)
                task.Wait(120)
                d = -d
                task.MoveToPlayer(60, -96, 96, 90, 110,
                        20, 40, 10, 20, 2, 1)
                task.Wait(60)
            end
        end)
    end
end--non_sc2
do
    name = "「超人高中生们即便在异世界也能从容生存！」"
    local sc3 = boss.card.New(name, 2, 3, 60, 760)
    sc3.before = card_start
    boss.card.add({ { sc3, "1a" } }, 16, name, 180)
    function sc3:init()
        boss.card.UnlockOD(self, 18)
        task.New(self, function()
            local camera = Class(object, {
                init = function(self, x, y, rot, v, t)
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET_EF
                    self.x, self.y = x, y
                    self.img = "photoOFF"
                    self._a = 255
                    self.hscale = 0.5
                    self.vscale = 0.5
                    self.a = 96 * 1
                    self.b = 128 * 1
                    self.rect = true
                    self.colli = false
                    self.rot = rot
                    self.bound = false
                    object.SetV(self, v, rot)
                    task.New(self, function()
                        for i = 1, t do
                            self.hscale = 0.5 - 0.2 * sin(i / t * 90)
                            self.vscale = self.hscale
                            self.a = 96 * self.hscale
                            self.b = 128 * self.hscale
                            task.Wait()
                        end
                        PlaySound("shutter", 1)
                        self.colli = true
                        self.on = true
                        task.Wait()
                        self.colli = false
                        object.Del(self)
                    end)
                end,
                frame = function(self)
                    task.Do(self)

                end,
                colli = function(_, other)
                    if other.group == GROUP.ENEMY_BULLET then
                        object.Del(other)
                    end
                end,
                render = function(self)
                    SetImageState(self.img, "mul+add", self._a, 255, 255, 255)
                    DefaultRenderFunc(self)
                    if self.on then
                        SetImageState("photoON", "mul+add", self._a, 255, 255, 255)
                        Render("photoON", self.x, self.y, self.rot, self.hscale * self._a / 255 * 1.2)
                    end
                end,
                kill = function(self)
                    object.Preserve(self)
                    lstg.var.timeslow = 1
                    task.New(self, function()
                        for i = 1, 15 do
                            self._a = 255 - 255 * sin(i * 6)
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                end,
                del = function(self)
                    self.class.kill(self)
                end
            }, true)
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 227, 132)
            task.Wait(60)
            while true do
                task.New(self, function()
                    task.Wait(160)
                    local x = player.x
                    for i = 1, 10 do
                        New(camera, x, 250, -90 + ran:Float(-6, 6), 5, 100 - 6 * i)
                        task.Wait(8)
                    end
                end)
                for v = 1, 16 do
                    for x = -2.5, 2.5 do
                        local b = NewSimpleBullet(money, 14, x * 70, 224, 0.5, -90)
                        b.ag = 0.025
                        b.omiga = ran:Float(2, 3) * ran:Sign()
                        b.maxv = 3.5 - v * 0.05

                    end
                    PlaySound("tan00", 0.2, 0, true)
                    task.Wait(5)
                end
                PlaySound("tan00", 0.2, 0, true)
                task.Wait(100)
            end
        end)
        task.New(self, function()
            task.Wait(200)
            task.New(self, function()
                task.Wait(100)
                while true do
                    task.MoveToPlayer(60, -96, 96, 100, 144,
                            20, 40, 10, 20, 2, 1)
                    task.Wait(180)
                end
            end)
            local frame_new = function(self)
                bullet.frame(self)
                object.smear_add(self, 80)
                object.smear_frame(self, 8)
            end
            local blend, color = "mul+add", { 250, 250, 250 }
            local render_new = function(self)
                object.smear_render(self, blend, color)
                bullet.render(self)
            end
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    for v = 1, 2 do
                        local b = Create.bullet_accel(self.x, self.y, knife, 2, 0.5, 7 + v * 3, a)
                        b.frame_new = frame_new
                        b.render_new = render_new
                    end
                end
                PlaySound("tan00", 0.2, 0, true)
                task.Wait(60)
            end
        end)
    end
    function sc3:frame()
        CollisionCheck(GROUP.INDES, GROUP.ENEMY_BULLET)
    end

end--sc3

do
    name = "恼「要高考了姐妹们-Special」"
    local sc_od = boss.card.New(name, 45, 45, 45, 600)
    sc_od.before = card_start
    boss.card.add({ { sc_od, "1a" } }, 16, name, 176, 18)
    function sc_od:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(128)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            _object.set_color(self, "", 255, 120, 120, 120)
            self.colli = false
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            task.New(self, function()
                task.Wait(100)
                while true do
                    task.MoveToPlayer(60, -96, 96, 100, 144,
                            20, 40, 10, 20, 2, 1)
                    task.Wait(180)
                end
            end)
            task.New(self, function()
                while true do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                        for v = 1, 2 do
                            NewSimpleBullet(square, 6, self.x, self.y, 2 + v * 0.1, a)
                        end
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(120)
                end
            end)
            local YES
            local fall_y = 460
            local Time = 500
            local move_set = function(n)
                if n < 0.5 then
                    return n * 1.3
                else
                    return -1.2 * n * n + 2.5 * n - 0.3
                end
            end
            local Question = Class(object, {
                init = function(self, text)
                    self.y = 358
                    self.x = 0
                    self.bound = false
                    self.colli = false
                    self.layer = 0
                    self.alpha = 1
                    self.text = text
                    task.New(self, function()
                        task.MoveToEx(0, -fall_y, Time, move_set)
                        task.SmoothSetValueTo("alpha", 0, 60, 0)
                        Del(self)
                    end)
                end,
                frame = task.Do,
                render = function(self)
                    ui:RenderText("title", self.text, self.x, self.y, 0.9,
                            Color(self.alpha * 255, 255, 255, 255), "centerpoint")
                end
            }, true)
            local Choice = Class(object, {
                init = function(self, pos, text)
                    self.bound = false
                    self.colli = false
                    self.layer = 0
                    self.alpha = 1
                    self.levels = { "A", "B", "C", "D" }
                    self.pos = pos
                    self.text = text
                    self.y = 282
                    self.x = (pos - 2.5) * 192 / 2
                    task.New(self, function()
                        task.MoveToEx(0, -fall_y, Time, move_set)
                        task.SmoothSetValueTo("alpha", 0, 60, 0)
                        Del(self)
                    end)
                end,
                frame = task.Do,
                render = function(self)
                    ui:RenderText("title", ("%s. %s"):format(self.levels[self.pos], self.text), self.x, self.y, 0.85,
                            Color(self.alpha * 255, 255, 255, 255), "centerpoint")
                end
            }, true)
            local wall = function(x, y)
                local self = NewObject(bullet)
                bullet.init(self, ball_mid, 2, false, false)
                self.fogtime = 0
                self.x, self.y = x, y
                self.a, self.b = self.a * 1.5, self.b * 1.5
                self.bound = false
                task.New(self, function()
                    task.MoveToEx(0, -fall_y, Time, move_set)
                    self.bound = true
                end)
                return self
            end
            --把正确答案填在第一个
            local function NewQuestion(q, c1, c2, c3, c4)
                local _true
                YES = nil
                New(Question, q)
                local in_k, out_k = { 1, 2, 3, 4 }, {}
                for _ = 1, 4 do
                    local t = table.remove(in_k, ran:Int(1, #in_k))
                    table.insert(out_k, t)
                end
                _true = out_k[1]
                New(Choice, out_k[1], c1)
                New(Choice, out_k[2], c2)
                New(Choice, out_k[3], c3)
                New(Choice, out_k[4], c4)
                local walls = {}
                for x = -16, 16 do
                    table.insert(walls, wall(x / 16 * 192, 330))
                end
                for x = -1, 1 do
                    for y = 1, 8 do
                        table.insert(walls, wall(x / 2 * 192, 330 - y / 16 * 192))
                    end
                end
                task.Wait(Time)
                sp:UnitListUpdate(walls)
                local answer = 3 + int(player.x / 96)
                if _true == answer then
                    PlaySound("bonus")
                    for _, w in ipairs(walls) do
                        Del(w)
                    end
                else
                    PlaySound("invalid")
                    for _, w in ipairs(walls) do
                        w.ag = 0.05
                    end
                end
            end
            local Questions = {
                function()
                    NewQuestion("已知lg x+lg y=2,则x+y的最小值为？", "20", "2", "40", "-20")
                end,
                function()
                    NewQuestion("已知(x-3)²+(y-4)²=9,则x²+y²的最大值为？", "64", "2", "4", "32")
                end,
                function()
                    NewQuestion("已知z=2-i,则5/z为？", "2+i", "(10+5i)/3", "2.5+5i", "2-i")
                end,
                function()
                    NewQuestion("已知tanx=3,则(sin2x+cos2x+1)/2=?", "2/5", "6/5", "5/6", "1/5")
                end,
                function()
                    NewQuestion("已知y=f(x)的图像在点M(0,f(0))处的切线方程为y=-2x,\n则f(0)+f'(0)=?", "-2", "0", "2", "1")
                end,
                function()
                    NewQuestion("已知向量AB=(3,8),A(-1,5),则B的坐标为？", "(2,13)", "(4,3)", "(4,13)", "(2,3)")
                end,
                function()
                    NewQuestion("|lgx|=2的两个根的等比中项为？", "±1", "±100", "±10", "±1000")
                end,
                function()
                    NewQuestion("已知向量a,b满足条件|a|=8,|b|=3,a·b=12,a与b的夹角为？", "60°", "30°", "45°", "120°")
                end,
            }
            local in_k, out_k = {}, {}
            for i = 1, #Questions do
                in_k[i] = i
            end
            for _ = 1, #in_k do
                local t = table.remove(in_k, ran:Int(1, #in_k))
                table.insert(out_k, t)
            end
            --每次选5道题
            for i = 1, 5 do
                Questions[out_k[i]]()
            end
        end)
    end
    function sc_od:del()
        _object.set_color(self, "", 255, 255, 255, 255)
        self.colli = true
    end

end--scod

