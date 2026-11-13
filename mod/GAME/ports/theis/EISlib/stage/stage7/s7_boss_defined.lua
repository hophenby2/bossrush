--祈华梦exboss
local path = "EISlib/stage/stage7/"
--boss相关的素材全部在以下脚本文件里
Include(path.."Iwabuchi_boss.lua")

--exboss蓄力特效
local eff, dark_eff, bkeff, laser_eff = s5_boss.eff, s5_boss.dark_eff, s5_boss.bkeff, s5_boss.laser_eff
local simeff = s7_boss.simeff

--设置出屏等待
local function boundWait(self, t)
    self.bound = false
    t = t or 90
    --出屏
    task.New(self, function()
        task.Wait(t)
        self.bound = true
    end)
end
--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t, indes)
    local obj = stg.newBulletStraight(st, co, true, x, y, 0, a, indes)
    egg.AddSimStrChV(obj, 0, v, a, t)
    return obj
end

--exboss默认的随机x朝向自机移动函数
local move_rd
do
    function move_rd(t, y0, dy, self, xmin, xmax, xr)
        y0 = y0 or 144
        dy = dy or 25
        xmin, xmax = xmin or 10, xmax or 20
        xr = xr or -40
        if self then
            task.New(self, function()
                task.MoveToPlayer(t or 60, -xr, xr, y0 - dy, y0 + dy, xmin, xmax, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
            end)
        else
            task.MoveToPlayer(t or 60, -xr, xr, y0 - dy, y0 + dy, xmin, xmax, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
        end
    end
end

--激光特效
local lasereff = Class(object)
function lasereff:init(x, y, a, r, g, b, w)
    r, g, b = r or 177, g or 255, b or 97
    w = w or 1
    self.bound = false
    self.x, self.y = x + 300*cos(a), y + 300*sin(a)
    self.rot = a
    self.layer = LAYER_ENEMY_BULLET-1
    self.hscale, self.vscale = 75, 0
    self.img = "white"
    _object.set_color(self, "mul+add", 100, r, g, b)
    task.New(self, function()
        local ds, d_a = 1/50*w, -100/30
        for _ = 1, 20 do
            self.vscale = self.vscale + 2*ds
            task.Wait(1)
        end
        for _ = 1, 30 do
            self.vscale = self.vscale + ds
            self._a = self._a + d_a
            task.Wait(1)
        end
        Del(self)
    end)
end
function lasereff:frame()
    task.Do(self)
end
function lasereff:render()
    local rate, v = 1, 1
    for _ = 1, 3 do
        SetImgState(self, self._blend, self._a*rate, self._r*rate, self._g*rate, self._b*rate)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale*v)
        rate = rate - 0.2
        v = v + 0.3
    end
end

local function clearAllBullet()
    New(tasker, function()
        for _, unit in ObjList(GROUP_INDES) do
            _del(unit, true)
        end
        for _, unit in ObjList(GROUP_ENEMY_BULLET) do
            _del(unit, true)
        end
    end)
end
--虚影特效
local function shadow(x, y, img, s)
    local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0, true)
    obj.img = img
    obj.group = GROUP_GHOST
    obj.hscale, obj.vscale = 0.75*s, 0.75*s
    _object.set_color(obj, "mul+add", 150, 255, 255, 255)
    task.New(obj, function()
        egg.SimSizeCh(obj, 0.75*s, 1.5*s, 20)
        egg.SimAlpCh(obj, 150, 0, 20)
        task.Wait(20)
        Del(obj)
    end)
end

--拖影特效
local trail2 = Class(object)
function trail2:init(master, maxnum, frame, img, size, blend, times, _a_rate, Isdsize)
    self.layer = master.layer
    self.bound = false
    self.master = master
    self.alpha = 80
    self.img = img
    self.size = size or 1
    self.trail = {} --拖影表
    self.max = maxnum or 10
    self.frame = frame or 3
    self.co = {255, 255, 255} --留一个可以外部操作的接口co
    self.blend = blend or "mul+alpha"
    self.times = times or 99999
    self._a_rate = _a_rate or 1
    self.Isdsize = Isdsize
end
function trail2:frame()
    if IsValid(self.master) then
        self.x, self.y = self.master.x, self.master.y
    end
    if self.frame == 1 or self.timer%self.frame == 1  then
        if IsValid(self.master) and self.timer < self.times then
            local master = self.master
            table.insert(self.trail, 1, {master.x, master.y, master.rot, master.hscale*self.size, master.vscale*self.size}) --更新主人当前图像状态
            if #self.trail > self.max then table.remove(self.trail) end
        else--即便主人不存在了，拖影也会保留一段时间渐渐消失
            if #self.trail == 0 then
                Del(self)
            else
                table.remove(self.trail)
            end
        end
    end
end
function trail2:render()
    local co = self.co
    local size = 1
    local dsize
    if self.Isdsize then
        dsize = 0.5/self.max
    else
        dsize = 0
    end
    if IsValid(self.master) then
        self.alpha = 255*self._a_rate
    end
    local alpha, d, n = 0.2*self.alpha, 0.8*self.alpha/self.max, #self.trail
    for i = n, 1, -1 do
        local obj = self.trail[i]
        SetImgState(self, self.blend, alpha, co[1], co[2], co[3])
        Render(self.img, obj[1], obj[2], obj[3], obj[4]*size, obj[5]*size)
        alpha = alpha + d
        --alpha = 255
        size = size + dsize
    end
    SetImgState(self, "", 255, 255, 255, 255) -- 记得恢复渲染状态
end

--5符的方向预警激光
local dir_warn_obj = Class(object)
function dir_warn_obj:init(master)
    self.bound = false
    self.colli = false
    self.group = GROUP_INDES
    self.x = master.x
    self.y = master.y
    self.rot = master.rot
    self.vscale = 0
    task.New(self, function()
        for i = 1, 30 do
            self.vscale = lstg.sin((i / 30) * 90)
            task.Wait(1)
        end
        while lstg.IsValid(master) or (not self.dead) do
            task.Wait(1)
        end
        for i = 9, 0, -1 do
            self.vscale = lstg.sin((i / 10) * 90)
            task.Wait(1)
        end
        self.status = "del"
    end)
    task.New(self, function()
        while lstg.IsValid(master) do
            self.x = master.x
            self.y = master.y
            self.rot = master.rot
            task.Wait(1)
        end
    end)
end
function dir_warn_obj:frame()
    local emmy
    task.Do(self)
end
function dir_warn_obj:render()
    local oldscale = lstg.globalimagescale
    lstg.SetImageScale(1) -- 懒得用 0.5 缩放，算起来麻烦死了

    local color1 = lstg.Color(120, 255, 0, 0)
    local color2 = lstg.Color(0, 255, 0, 0)
    local size = 16
    local cosv, sinv = lstg.cos(self.rot), lstg.sin(self.rot)
    local lerpt = (self.timer * 4) % 60 / 60
    lstg.SetImageState("white", "mul+add", color2, color1, color1, color2)
    for i = 0, 19 do
        if i == 0 then
            lstg.Render("white",
                    self.x + (i - 1 + lerpt) * (size * 2) * cosv,
                    self.y + (i - 1 + lerpt) * (size * 2) * sinv,
                    self.rot, 4 * (lerpt), 0.6 * self.vscale)
        else
            lstg.Render("white",
                    self.x + (i - 1 + lerpt) * (size * 2) * cosv,
                    self.y + (i - 1 + lerpt) * (size * 2) * sinv,
                    self.rot, 4, 0.6 * self.vscale)
        end
    end
    lstg.SetImageState("white", "", lstg.Color(255, 255, 255, 255))

    lstg.SetImageScale(oldscale)
end

local function clear_bullets(x, y, range)
    New(tasker, function()
        for _, o in ObjList(GROUP_ENEMY_BULLET) do
            local d = Dist(x, y, o.x, o.y)
            if d < range and o.colli then --本身没有判定的弹幕是不会被消掉的
                Kill(o)
            end
        end
    end)
end

--判断主人是否存在来决定是否自删
local function IsValidMst(obj, self)
    if not IsValid(self) then
        Del(obj)
    end
end

local atks, scs = {}, {}  --存放非符和符卡函数的表
--开幕演出
local function boss_show(self, x, y, IsDialog)
    self.aura_alpha = 0
    boss.show_aura(self, false)
    task.Wait(60)
    x, y = x or 0, y or 144
    task.MoveTo(0, 144, 60, MOVE_DECEL)
    if not IsDialog then
        boss.show_aura(self, true)
    end
end
local function boss_scpr_show(self, x, y)
    boss.show_aura(self, false)
    for _ = 1, 3 do
        eff(x, y, 20)
    end
    task.Wait(20)
    self.x, self.y = x, y
    boss.show_aura(self, true)
end

--一非
local function boss_atk1_normal_show(self)
    if EISlib.stage.canDialog() then
        -- 第一段对话
        dialog.cacheResource("StageEX")
        dialog.player.playScene("StageEX")
        dialog.player.waitSignal("boss fly in", dialog.enum.on)
        -- 出场
        boss_show(self)
        dialog.player.setSignal("boss fly in complete", dialog.enum.on)
        -- 第二段对话
        dialog.player.waitSignal("fade out BGM", dialog.enum.on)
        EISlib.stage.musicFadeOut("s7", 120)
        dialog.player.waitSignal("play BGM", dialog.enum.on)
        LoadMusicRecord("s7_boss")
        EISlib.stage.playMusic("s7_boss", 0, true)
        dialog.player.waitUntilFinish()
        boss.show_aura(self, true) --打开法阵
    else
        -- 出场
        boss_show(self)
        -- 放音乐
        EISlib.stage.musicFadeOut("s7", 120)
        LoadMusicRecord("s7_boss")
        EISlib.stage.playMusic("s7_boss", 0, true)
        -- 开打
        task.Wait(60)
        boss.show_aura(self, true) --打开法阵
    end
end
local function boss_atk1_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk1(self)
    local f1, f1_1, f1_2
    do
        function f1(x, y, r, a, v)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 3 do
                    f1_1(x + r*dx, y + r*dy, 1.5 + 0.125*i, a, 0)
                    task.Wait(5)
                    r = r + 15
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 3, v, a, 15)
            egg.AddSimStrChV(obj, 0, 1, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 220, 220, 220)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        while true do
            for u = -1, 1, 2 do
                task.New(self, function()
                    task.Wait(30)
                    move_rd(90)
                end)
                for k = 1, 12 do
                    for i = 0, 15 do
                        f1(self.x, self.y, 10*(12-k), 22.5*i + 9*k*u, 1)
                    end
                    PlaySound("tan00")
                    task.Wait(10)
                end
                task.Wait(120)
            end
        end
    end
end
table.insert(atks, {boss_atk1, boss_atk1_normal_show, boss_atk1_scpr_show})
--二非
local function boss_atk2_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk2_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk2(self)
    local f1, f1_1, f1_2, f2, f3
    do
        function f1(x, y, r, a, u, v)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 3 do
                    f1_1(x + r*dx, y + r*dy, 1 + 0.15*i, a, 5*i*u)
                    task.Wait(5)
                    r = r + 15
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 3, v, a, 15)
            egg.AddSimStrChV(obj, 0, 1, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, v, a, 60)
            _object.set_color(obj, "", 255, 220, 220, 220)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        while true do
            for u = -1, 1, 2 do
                for k = 1, 12 do
                    for i = 0, 15 do
                        f1(self.x, self.y, 10*(12-k), 22.5*i + 9*k*u, u, 1)
                    end
                    PlaySound("tan00")
                    task.Wait(10)
                end
                task.Wait(30)
                move_rd(60)
                task.Wait(30)
            end
        end
    end
end
table.insert(atks, {boss_atk2, boss_atk2_normal_show, boss_atk2_scpr_show})
--三非
local function boss_atk3_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk3_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk3(self)
    local f1, f1_1, f1_2
    do
        function f1(x, y, r, a, u, v, da)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 3 do
                    f1_1(x + r*dx, y + r*dy, 1 + 0.2*i, a + da, 10*i*u)
                    task.Wait(3)
                    PlaySound("tan00")
                    r = r + 15
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a + da)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 3, v, a, 15)
            egg.AddSimStrChV(obj, 0, 1, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, v, a, 60)
            _object.set_color(obj, "", 255, 220, 220, 220)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        while true do
            for u = -1, 1, 2 do
                for k = 1, 12 do
                    for i = 0, 15 do
                        f1(self.x, self.y, 10*(12-k), 22.5*i + 9*k*u, u, 1.5, 90*u)
                    end
                    task.Wait(6)
                end
                --task.Wait(30)
                move_rd(45)
                --task.Wait(30)
            end
        end
    end
end
table.insert(atks, {boss_atk3, boss_atk3_normal_show, boss_atk3_scpr_show})
--四非
local function boss_atk4_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk4_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk4(self)
    local f1, f1_1, f1_2, f2, f3
    do
        function f1(x, y, r, a, u, v, da)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 3 do
                    f1_1(x + r*dx, y + r*dy, 2.25 + 0.4*i, a + da, 10*i*u)
                    task.Wait(4)
                    PlaySound("tan00")
                    r = r + 15
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a + da)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 3, v, a, 15)
            egg.AddSimStrChV(obj, 0, 1, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, v, a, 60)
            _object.set_color(obj, "", 255, 220, 220, 220)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        while true do
            for u = -1, 1, 2 do
                for k = 1, 12 do
                    for i = 0, 15 do
                        f1(self.x, self.y, 10*(12-k), 22.5*i + 9*k*u, u, 1.8, 90*u)
                    end
                    task.Wait(10)
                end
                --task.Wait(30)
                move_rd(60)
                task.Wait(30)
            end
        end
    end
end
table.insert(atks, {boss_atk4, boss_atk4_normal_show, boss_atk4_scpr_show})
--五非
local function boss_atk5_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk5_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk5(self)
    local f1, f1_1, f1_2
    do
        function f1(x, y, r, a, v, u)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 3 do
                    f1_1(x + r*dx, y + r*dy, 0.9 + 0.125*i, a, (20 + 15*i)*u)
                    task.Wait(5)
                    r = r + 10
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 3, v, a, 15)
            egg.AddSimStrChV(obj, 0, 1, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 220, 220, 220)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        while true do
            for u = -1, 1, 2 do
                for k = 1, 10 do
                    for i = 0, 15 do
                        f1(self.x, self.y, 10*(12-k), 22.5*i + 10*k*u, 1, u)
                    end
                    PlaySound("tan00")
                    task.Wait(20)
                end
                task.Wait(30)
                move_rd(60)
            end
        end
    end
end
table.insert(atks, {boss_atk5, boss_atk5_normal_show, boss_atk5_scpr_show})
--六非
local function boss_atk6_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk6_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk6(self)
    local f1, f1_1, f1_2
    do
        function f1(x, y, r, a, v, u)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 3 do
                    f1_1(x + r*dx, y + r*dy, 2 + 0.25*i, a, 90*u)
                    task.Wait(5)
                    r = r + 15
                    u = -u
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 3, v, a, 15)
            egg.AddSimStrChV(obj, 0, 1, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 220, 220, 220)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        while true do
            for u = -1, 1, 2 do
                task.New(self, function()
                    move_rd(60)
                    move_rd(60)
                end)
                for k = 1, 12 do
                    for i = 0, 11 do
                        f1(self.x, self.y, 15*(6-k), 30*i + 12*k*u, 2.5, u)
                    end
                    PlaySound("tan00")
                    task.Wait(10)
                end
                task.Wait(120)
            end
        end
    end
end
table.insert(atks, {boss_atk6, boss_atk6_normal_show, boss_atk6_scpr_show})
--七非
local function boss_atk7_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk7_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk7(self)
    local f1, f1_1, f1_2
    do
        function f1(x, y, r, a, v, u)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 3 do
                    f1_1(x + r*dx, y + r*dy, 1.5 + 0.175*i, a, 30*u)
                    task.Wait(5)
                    r = r + 15
                    u = -u
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 220, 220, 220)
            egg.AddSimStrChV(obj, 3, 0, a, 15)
            egg.AddSimStrChV(obj, 0, v, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        local a
        while true do
            for u = -1, 1, 2 do
                task.New(self, function()
                    move_rd(60)
                    move_rd(60)
                end)
                for k = 1, 12 do
                    a = Angle(self, player)
                    for i = 0, 17 do
                        f1(self.x, self.y, 15*(12-k), 20*i + 0*(k%2) + a, 3, u)
                    end
                    PlaySound("tan00")
                    task.Wait(10)
                end
                task.Wait(120)
            end
        end
    end
end
table.insert(atks, {boss_atk7, boss_atk7_normal_show, boss_atk7_scpr_show})
--八非
local function boss_atk8_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk8_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_atk8(self)
    local f1, f1_1, f1_2
    do
        function f1(x, y, r, a, v, u)
            local dx, dy = cos(a), sin(a)
            New(tasker, function()
                for i = 0, 1 do
                    f1_1(x + r*dx, y + r*dy, 1.5 + 0*i, a, 30*u)
                    task.Wait(5)
                    r = r + 15
                    u = -u
                end
            end)
            f1_2(x + r*dx, y + r*dy, v, a)
        end
        function f1_1(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 220, 220, 220)
            egg.AddSimStrChV(obj, 3, 0, a, 15)
            egg.AddSimStrChV(obj, 0, v, a + da, 30, 15)
        end
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_big, 16, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
    end

    do
        boss.show_aura(self, true)
        eff(self.x, self.y, 60)
        local a
        task.New(self, function()
            move_rd(60)
            move_rd(60)
        end)
        for k = 1, 12 do
            a = Angle(self, player)
            for i = 0, 17 do
                f1(self.x, self.y, 15*(13-k), 20*i + 0*(k%2) + a, 3, 1)
            end
            PlaySound("tan00")
            task.Wait(15)
        end
        while true do
            for u = -1, 1, 2 do
                task.New(self, function()
                    move_rd(60)
                    move_rd(60)
                end)
                for k = 1, 12 do
                    a = Angle(self, player)
                    for i = 0, 17 do
                        f1(self.x, self.y, 15, 20*i + 0*(k%2) + a, 3, u)
                    end
                    PlaySound("tan00")
                    task.Wait(15)
                end
            end
        end
    end
end
table.insert(atks, {boss_atk8, boss_atk8_normal_show, boss_atk8_scpr_show})

--一符
local function boss_sc1_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc1_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc1(self)
    local drop_stone, f1, f1_1, f1_2, f1_3, f1_4
    do
        function drop_stone(u)
            for i = 0, 5 do
                f1((-192 + 40*i)*u, 224)
                PlaySound("kira00")
                task.Wait(8)
            end
        end
        --正上方落石
        function f1(x, y)
            task.New(self, function()
                simeff(x, y)
                task.Wait(60)
                New(lasereff, x, y, -90, 255, 0, 0, 10)
                task.Wait(30)
                f1_1(x, y)
                task.Wait(10)
                for i = 0, 4 do
                    f1_4(x, y, 1.2 + 0.3*i, -90)
                end
            end)
        end
        function f1_1(x, y)
            local obj = stg.newBulletStraight(stg.ball_huge, 16, true, x, y, 0, -90, true)
            obj.timer = 11
            --obj.omiga = 3
            obj.img = "pointed_stone"
            New(trail2, obj, 10, 2, obj.img, 1, "mul+add", 9999, 0.5, true)
            obj.rot = -90
            egg.SimSizeCh(obj, 0, 1, 30, true)
            egg.AddSimStrChV(obj, 1, 6, -90, 60)
            task.New(obj, function()
                while obj.y > -224 do
                    task.Wait(1)
                end
                PlaySound("kira00")
                for _ = 1, 3 do
                    f1_2(obj.x, obj.y)
                end
                for _ = 1, 9 do
                    f1_3(obj.x, obj.y)
                end
                Del(obj)
            end)
        end
        --中玉
        function f1_2(x, y)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, x, y, 0, ran:Float(0, 360))
            obj.img = "stone_big"
            --obj.timer = 11
            obj.omiga = 3
            SetV(obj, ran:Float(3, 7), ran:Float(85, 95))
            obj.ay = -0.02
        end
        --小玉
        function f1_3(x, y)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, true, x, y, 0, ran:Float(0, 360))
            obj.img = "stone_mid"
            --obj.timer = 11
            obj.omiga = 3
            SetV(obj, ran:Float(3, 8), ran:Float(85, 95))
            obj.ay = -0.02
        end
        --限制走位的石头
        function f1_4(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_big, 15, true, x, y, 0, 0, true)
            --_object.set_color(obj, "", 255, 161, 183, 197)
            _object.set_color(obj, "", 255, 255, 255, 255)
            local t = 30
            egg.AddSimStrChV(obj, 0, v, a, t)
        end
    end

    do
        self.minFps(45)
        s7_boss.pic_show()
        task.Wait(90)
        eff(self.x,  self.y, 60)
        local u = 1
        while true do
            drop_stone(u)
            task.Wait(90)
            drop_stone(-u)
            task.Wait(150)
            drop_stone(-u)
            task.Wait(90)
            drop_stone(u)
            task.Wait(240)
            u = -u
        end
    end
end
table.insert(scs, {boss_sc1, boss_sc1_normal_show, boss_sc1_scpr_show})

--二符（抄jix的
local function boss_sc2_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc2_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc2(self)
    local f1, f1_1, f2, f2_1
    do
        --以自身为中心，以角度a, 半径r，确定的点作为狙点，发出一坨分裂大光玉
        function f1(n, way, la, r, v, a, t, ts)
            local x, y, da, a0 = self.x + r*cos(a), self.y + r*sin(a), 360/n
            --stg.newBulletStraight(stg.ball_mid, 1, true, x, y, 0, 0)
            for i = 1, n do
                a0 = a + i*da
                f1_1(self.x + 30*cos(a0), self.y + 30*sin(a0), v, a0, r, way, la)
            end
            task.New(self, function()
                task.Wait(t)
                self.addTimes(ts)
            end)
        end
        --会分裂的大光玉
        function f1_1(x, y, v, a, r, way, la)
            local obj = stg.newBulletStraight(stg.ball_light, 16, true, x, y, 0, a, true)
            obj.bound = false
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            task.New(obj, function()
                egg.AddAccDecChV(obj, v, a, 1, 40, 20)
                task.Wait(60)
                PlaySound("kira00")
                local a0, da = Angle(obj.x, obj.y, player.x, player.y), 360/way
                if IsValid(_boss) then
                    local a = Angle(_boss.x, _boss.y, player.x, player.y)
                    a0 = Angle(obj.x, obj.y, _boss.x + r*cos(a), _boss.y + r*sin(a))
                    for i = 1, way do
                        for j = 0, la - 1 do
                            boundWait(accbullet(stg.grain_b, 5, obj.x, obj.y, 5 - 2*j, a0 + da*(i + 0.5*j), 45, true), 120)
                        end
                    end
                end
                obj.hide = true
                obj.colli = false
                for i = 0, 2 do
                    boundWait(stg.newBulletStraight(stg.arrow_big, 2, true, obj.x, obj.y, 1.5 + 0.225*i, a + 180), 180)
                    PlaySound("kira00")
                    task.Wait(4)
                end
                f2(obj.x, obj.y, a + ran:Float(-5, 5))
                Del(obj)
            end)
        end
        --散出花瓣
        function f2(x, y, a)
            for i = 1, 2 do
                f2_1(x, y, a + 180*i)
            end
        end
        --光玉花的花瓣
        function f2_1(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_big, 3, false, x, y, 0, a)
            obj.timer = 11
            --obj.vx, obj.vy = vx, vy
            obj.img = "Lily_Cherry_bullet"
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2, 2
            obj.rot = a
            boundWait(obj, 120)
            --减速生成
            egg.AddSimStrChV(obj, 3, 1.25 + ran:Float(-0.25, 0.25), a, 60)
        end
    end
    --本符卡特殊的移动方式
    local function sp_move_rd()
        --move_rd(30, 144, 5, nil, 20, 30, 100)
        move_rd(30)
        move_rd(30, 144, 5, nil, 10, 20, 40)
    end

    do
        self.minFps(45) --减速到30
        s7_boss.pic_show()
        task.Wait(90)
        for j = 0, 1 do
            self:cast(60)
            eff(self.x, self.y, 60)
            for i = 0, j do
                f1(40, 20, 1, 360 - 50*i, 1.5, Angle(self, player), 120 - 10*i, max(0, 45*(i-1)))
                task.Wait(45)
                sp_move_rd()
            end
            task.Wait(45)
        end
        while true do
            self:cast(100)
            for _ = 1, 2 do
                eff(self.x, self.y, 20)
            end
            task.Wait(40)
            for i = 0, 3 do
                f1(40, 20, 1, 330 - 15*i, 1.5, Angle(self, player), 120 - 15*i, max(0, 90*(i-2)))
                task.Wait(30)
                sp_move_rd()
            end
            task.Wait(60)
            for _ = 1, 3 do
                eff(self.x, self.y, 20)
            end
            f1(60, 20, 2, 300, 2, -90, 100, 75)
            task.Wait(180)
        end
    end
end
table.insert(scs, {boss_sc2, boss_sc2_normal_show, boss_sc2_scpr_show})

--region
--[[三符(祖玛
local color = {{255, 0, 0}, {0, 0, 255}, {0, 255, 0}, {255, 255, 255}} --祖玛球的四种颜色
--生成路径
local zumaRoads = {}
local boundtimes = 0 --出屏时间
local dpos = 40 --规定每个球距离10个单位
do
    --从左边出来到右边
    local x, dx, y, dy = -224, 1.2, 120, -1.2
    local a, b, c, d = int((224 + 170)/dx), int(-(120 + 224)/dy), int((170 + 170)/dx), int(-(120 + 224 + 130)/dy)
    boundtimes = a + b + c + d
    for _ = 1, a do
        table.insert(zumaRoads, {x, y})
        x = x + dx
    end
    --往下走
    for _ = 1, b do
        y = y + dy
        table.insert(zumaRoads, {x, y})
    end
    --往左走
    dx, dy = -dx, -dy
    for _ = 1, c do
        x = x + dx
        table.insert(zumaRoads, {x, y})
    end
    --往上走
    for _ = 1, d do
        y = y + dy
        table.insert(zumaRoads, {x, y})
    end
end
local function zumaBall(co)
    local obj = stg.newBulletStraight(stg.ball_big, 16, true, 0, 0, 0, 0, true)
    _object.set_color(obj, "", 255, color[co][1], color[co][2], color[co][3])
    obj.img = "stone_unclear"
    --obj.layer = LAYER_ENEMY_BULLET-1
    obj.bound = false
    obj.timer = 11
    obj.colli = false
    obj.omiga = 6
    obj.hscale, obj.vscale = 0.2, 0.2
    obj.a, obj.b = 4, 4
    egg.SimSizeCh(obj, 0.2, 0.1, 30)
    --egg.simSizeChFrom0(obj, 0.1, 30, true)
    return obj
end


local Zuma
local zumaEnemy = Class(enemy)
function zumaEnemy:init(x, y, co, i, pos, mst)
    enemy.init(self, 44, 25, false, true, false, false, co, 0, 1)
    --self.a, self.b = 8, 8
    self.group = GROUP_NONTJT
    self.x, self.y = x, y
    self.mst = mst
    self.ball = zumaBall(co) --每个妖精都会携带一个祖玛球
    _connect(self, self.ball, 0, true)
    self.ball.rot = 0
    self.ball.alpha = 0
    self.place_num = i --自身在祖玛队列的排号下标
    self.pos = pos --祖玛位置表下标
    self.stoptime = 0 --停滞量
    self.backtime = 0 --倒退量
    self.bound = false
    self.color = co --颜色
    self.deltimes = -1 --被清除的倒计时
    self.ball_alpha_max = 255
    --攻击
    task.New(self, function()
        self.layer = LAYER_ENEMY_BULLET + 1
        while IsValid(mst) and mst.stop do
            task.Wait(1)
        end
        task.Wait((i%6)*30)
        if co == 1 then
            co = 2
        elseif co == 2 then
            co = 6
        elseif co == 3 then
            co = 10
        end
        local a]]
        --[[while true do
            a = -90
            for i = 0, 0 do
                for j = 0, 2 do
                    accbullet(stg.grain_b, co, self.x, self.y, 1 + 0.1*j, a, 60)
                end
                --PlaySound("tan00")
                task.Wait(3)
            end
            task.Wait(30*6)
        end]]
    --[[end)
end
function zumaEnemy:frame()
    enemy.frame(self)
    if IsValid(self.ball) then
        self.ball.x, self.ball.y = self.x, self.y

        if player.slow == 1 then
            self.ball._a = min(self.ball_alpha_max, self.ball._a + 10)
        else
            self.ball._a = max(0, self.ball._a - 10)
        end
        if self.ball._a >= 255 then
            self.ball.colli = true
        else
            self.ball.colli = true
        end
        self.ball.rot = self.ball.rot + 6
    else
        _del(self, false)
    end
end
function zumaEnemy:render()
    enemy.render(self)
    --RenderText("ui_font_42green", self.deltimes, self.x, self.y, 0.5)
end
function zumaEnemy:kill()
    enemy.kill(self)
    if IsValid(_boss) then
        _boss.hp = _boss.hp - _boss.maxhp/45
    end
    local a = Angle(self, player)
    for i = -3, 3 do
        accbullet(stg.arrow_small, 2, self.x, self.y, 3, a + 45*i, 120)
        --stg.newBulletStraight(stg.arrow_small, 2, true, self.x, self.y, 0.75, a + 45*i)
    end
end
function zumaEnemy:addDelTime(t)
    if self.deltime == -1 then
        self.deltimes = t
    else
        self.deltimes = self.deltimes + t
    end
end
function zumaEnemy:setBackTime(t)
    self.backtime = t
end
function zumaEnemy:addStopTime(t)
    self.stoptime = self.stoptime + t
end

Zuma = Class(object)
function Zuma:init()
    self.balls = {} --存储球
    self.stop = false
end
function Zuma:frame()
    local delcount, checkhead, obj = 0
    local flag --是否有在倒退的flag

    if player.protect <= 0 and not self.stop then
        for i = #self.balls, 1, -1 do
            obj = self.balls[i]
            if IsValid(obj) then
                --停滞与前进逻辑处理
                if obj.stoptime > 0 then
                    obj.stoptime = obj.stoptime - 1
                    flag = true
                else
                    --倒退处理
                    if obj.backtime > 0 then
                        obj.pos = obj.pos - 1
                        obj.backtime = obj.backtime - 1
                        flag = true
                    else
                        obj.pos = obj.pos + 1
                    end
                    if zumaRoads[obj.pos] then
                        obj.x, obj.y = zumaRoads[obj.pos][1], zumaRoads[obj.pos][2] --更新位置
                    else
                        Del(obj)
                    end
                end
                if obj.deltimes > 0 then
                    obj.deltimes = obj.deltimes - 1 --回收已标记击破的祖玛
                end
                if obj.deltimes > -1 and obj.deltimes <= 0 then
                    zumaEnemy.kill(obj)
                    Zuma.removeBalls(self, i)
                    delcount = delcount + 1
                    checkhead = i --检查碰撞起始点
                end
            else
                Zuma.removeBalls(self, i) --因非消除因素被剔除的ball也要删掉
                Zuma.checkChain(self, i, 1)
                if checkhead then
                    checkhead = checkhead - 1
                end
                if IsValid(_boss) then
                    PlaySound("kira00")
                    local a, da = ran:Float(0, 360), 360/_boss.attack_way
                    for i = 1, _boss.attack_way do
                        for j = 0, 1 do
                            accbullet(stg.ball_mid, 2, _boss.x, _boss.y, 0.5 + j, a + i*da, 60)
                        end
                    end
                    _boss.attack_way = _boss.attack_way + 5
                end
            end
        end
    end

    if delcount > 0 and checkhead then
        Zuma.checkChain(self, checkhead, delcount, true)  --被消了之后肯定要检查一下的
        if delcount >= 2 then
            --clear_bullets(self.balls[checkhead].x, self.balls[checkhead].y, 50 + 10*delcount)
            --clear_bullets(player.x, player.y, 90 + 10*delcount)
            PlaySound("bonus2")
        end
    end

    --倒退或者放b完全无敌
    if flag or player.protect > 0 or self.stop then
        for i = 1, #self.balls do
            obj = self.balls[i]
            if IsValid(obj) then
                obj.ball_alpha_max = max(obj.ball_alpha_max - 10, 50)
                obj.dmgrate = 0
                obj.hp = obj.maxhp
            end
        end
    else
        for i = 1, #self.balls do
            obj = self.balls[i]
            if IsValid(obj) then
                obj.ball_alpha_max = min(obj.ball_alpha_max + 10, 255)
                obj.dmgrate = min(1, obj.dmgrate + 0.02)
            end
        end
    end
end
function Zuma:render()
    local obj]]
    --[[for i = 1, #self.balls do
        obj = self.balls[i]
        if IsValid(obj) then
            RenderText("ui_font_42green", i, obj.x, obj.y, 0.5)
        end
    end]]
--[[end
function Zuma:addBalls(co, pos)
    pos = pos or 1
    local obj = New(zumaEnemy, zumaRoads[pos][1], zumaRoads[pos][2], co, #self.balls, pos, self)
    table.insert(self.balls, obj)
end
function Zuma:removeBalls(i)
    local n, obj = #self.balls - 1
    for j = i, n do
        obj = self.balls[j + 1] --选取后一位对象
        obj.place_num = obj.place_num - 1 --自己的位置计数一定要前移
        self.balls[j] = obj
    end
    table.remove(self.balls)
end
--检测前后是否有配对的(n表示检查的两边距离差了多少个球
function Zuma:checkChain(i, num, IsBack)
    local n, t = #self.balls, 0.5*dpos*num
    if i > 1 and i <= n then
        t = 0.5*(self.balls[i-1].pos - self.balls[i].pos - dpos)
        local obj1, obj2 = self.balls[i-1], self.balls[i]
        if obj1.color == obj2.color then
            local j, count, obj = i-2, 2 --连破计数
            --找前面同色
            local front = 0
            while j > 0  do
                obj = self.balls[j]
                if IsValid(obj) and obj.color == obj1.color then
                    count = count + 1
                    zumaEnemy.addDelTime(obj, t)
                    j = j - 1
                    front = front + 1
                else
                    break
                end
            end
            j = i + 1
            --找后面同色
            while j <= n  do
                obj = self.balls[j]
                if obj.color == obj2.color then
                    count = count + 1
                    zumaEnemy.addDelTime(obj, t)
                    j = j + 1
                else
                    break
                end
            end
            --达成连击条件后原本被比较的两个也要设置消除
            if count > 2 then
                if IsValid(obj1) then
                    zumaEnemy.addDelTime(obj1, t)
                end
                if IsValid(obj2) then
                    zumaEnemy.addDelTime(obj2, t)
                end
            end
            --前面的要回来的！
            for j = i - 1, i - front - 1, -1 do
                zumaEnemy.setBackTime(self.balls[j], t) --你给我回来！
            end
            --if front >= 1 then
            for j = i - front - 2, 1, -1 do
                --i = i - 1
                zumaEnemy.setBackTime(self.balls[j], t) --你给我回来！
            end
            --end

        else
            local origin_color, flag = self.balls[i].color, true]]
            --[[if IsBack then
                while i > 1 do
                    i = i - 1
                    if not (self.balls[i].color == origin_color and flag) then
                        flag = false
                        zumaEnemy.setBackTime(self.balls[i], t) --你给我回来！
                    end
                    --if self.balls[i].deltimes == -1 then --考虑倒退连破情况

                    --end
                end
            else
                while i > 1 do
                    i = i - 1
                    zumaEnemy.addStopTime(self.balls[i], 2*t) --冻住，不许走！
                end
            end]]
            --[[while i > 1 do
                i = i - 1
                --if self.balls[i].deltimes == -1 then --考虑倒退连破情况
                zumaEnemy.setBackTime(self.balls[i], t) --你给我回来！
                --end
            end
        end
    end
end
local function boss_sc3_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 170, 60, MOVE_NORMAL)
end
local function boss_sc3_scpr_show(self)
    boss_scpr_show(self, 0, 170)
end
local function boss_sc3(self)

    local f1
    do
        --中玉墙
        function f1(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_big, 8, true, x, y, 0.25, a)
            egg.AddSimStrChV(obj, 0, 2, a, 180, 480)
        end

    end

    local function Wait(t)
        for _ = 1, t do
            while player.protect > 0 do
                task.Wait(1)
            end
            task.Wait(1)
        end
    end
    local function isRepeat(rate)
        local i = ran:Float(0, 1)
        if i < rate then
            return true
        else
            return false
        end
    end
    do
        self.attack_way = 15
        s7_boss.pic_show()
        task.Wait(90)
        eff(self.x, self.y)
        self:cast(60)
        misc.ShakeScreen(60, 5)
        task.Wait(30)
        --self.addTimes(90)
        local zumaSpawner = New(Zuma)
        _connect(self, zumaSpawner, 0, true) --祖玛生成器
        zumaSpawner.stop = true
        local co, rate = ran:Int(1, 3), 0.6
        for i = 30, 1, -1 do
            Zuma.addBalls(zumaSpawner, co, (dpos) *i)
            rate = rate - 0.1 --概率会越来越小
            if not isRepeat(rate) then
                local co2 = ran:Int(1, 3)
                while co2 == co do
                    co2 = ran:Int(1, 3)
                end
                co = co2
                rate = 0.6
            end
            PlaySound("kira00")
            task.Wait(2)
        end
        zumaSpawner.stop = false
        --上避封死
        task.New(self, function()
            while true do
                for i = -10, 10 do
                    for j = 0, 2 do
                        _object.set_color(stg.newBulletStraight(stg.ball_huge, 8, true, self.x, self.y, 3 + 0.5*j, 90 + 15*i), "mul+add", 255, 255, 255, 255)
                    end
                end]]
                --[[for i = 0, 23 do
                    for j = 0, 2 do
                        stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 0.5 + 0.125*j, 90 + 15*i + 5*j)
                    end
                end]]
                --[[PlaySound("kira00")
                move_rd(60, 170, 10)
                task.Wait(120)
            end
        end)]]
        --[[自机狙
        task.New(self, function()
            local a
            while true do
                a = Angle(self, player)
                for i = -18, 18 do
                    f1(self.x, self.y, a + 2.5*i)
                end
                task.Wait(120)
            end
        end)]]
        --[[生成球
        local rate = 0.6
        local chains, last_co, chain_co, chains_flag = 0, ran:Int(1, 3), nil
        while true do
            Zuma.addBalls(zumaSpawner, co, 1)
            rate = rate - 0.1
            --在一串连续的球后面只会出现一个连续的不同色球
            if last_co and  chains_flag then
                chains_flag = false
                --Wait(dpos)
                --Zuma.addBalls(zumaSpawner, co, 1)
                last_co = co
                if isRepeat(1) then
                    co = chain_co
                else
                    co = ran:Int(1, 3)
                    while co == chain_co or co == last_co do
                        co = ran:Int(1, 3)
                    end
                end
                chain_co = nil
                last_co = nil
                --3个以上同色球后如果跟了一个异色球，下一个球与除异色球外颜色相同的概率会提高
            else
                if not isRepeat(rate) then
                    local co2 = ran:Int(1, 3)
                    while co2 == co do
                        co2 = ran:Int(1, 3)
                    end
                    chain_co = co --记录前一个球颜色
                    co = co2
                    last_co = co --记录当前球颜色
                    rate = 0.6
                    if chains >= 2 then
                        chains_flag = true
                    end
                    chains = 1
                else
                    chains = chains + 1
                end
            end
            Wait(dpos)
        end
    end
end
table.insert(scs, {boss_sc3, boss_sc3_normal_show, boss_sc3_scpr_show})]]
--endregion
--新sc3凑数
local function boss_sc3_normal_show(self)
    task.Wait(30)
    self.colli = true
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc3_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc3(self)
    local f1, f1_1, f1_2, f1_3, f1_4, f1_5, f3, f4
    do
        --弹幕生成器
        function f1(x, y, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 1, true, x, y, 3, a, true)
            obj.colli = false
            obj.hide = true
            egg.AddSimStrChV(obj, 0, 3, a + 90*u, 240)
            --产生光玉特效
            task.New(obj, function()
                while true do
                    f1_1(obj.x, obj.y)
                    task.Wait(2)
                end
            end)
            --产生小弹幕
            task.New(obj, function()
                local k, a = 0
                while true do
                    a = Angle(0, 0, obj.vx, obj.vy)
                    for u = -1, 1, 2 do
                        for i = 0, 1 do
                            accbullet(stg.grain_b, 10, obj.x, obj.y, 1.25 + 0.25*i, a + (4 + 2*i)*k*u + 90*u, 180)
                        end
                    end
                    task.Wait(2)
                    k = k + 1
                end
            end)
            --产生大弹幕
            task.New(obj, function()
                local i, a = 1
                while true do
                    a = Angle(0, 0, obj.vx, obj.vy)
                    f1_2(obj.x, obj.y, 3, a - 90*u)
                    if i % 2 == 0 then
                        a = ran:Float(0, 360)
                        for i = 0, 5 do
                            accbullet(stg.ellipse, 8, obj.x, obj.y, 1.25 + ran:Float(-0.1, 0.1), a + 60*i, 180)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(10)
                    i = i + 1
                end
            end)
        end
        --放大的光玉特效
        function f1_1(x, y)
            local obj = stg.newBulletStraight(stg.ball_light, 10, true, x, y, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            _object.set_color(obj, "mul+add", 0, 150, 150, 255)
            obj.timer = 11
            obj.hscale, obj.vscale = 0, 0
            egg.SimSizeCh(obj, 0, 4, 30)
            egg.SimAlpCh(obj, 150, 0, 30)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+3
                task.Wait(30)
                Del(obj)
            end)
        end
        --生成石头
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.star_big, 1, true, x, y, 1, 90, true)
            obj.timer = 11
            obj.img = "stone_big"
            obj.omiga = 3
            egg.AddSimStrChV(obj, 0, v, a, 240)
        end
    end

    do
        s7_boss.pic_show()
        task.Wait(90)
        while true do
            for u = -1, 1, 2 do
                for i = 0, 3 do
                    f1(-224*u, -50 + 100*i, 90*(1-u), u)
                end
                task.Wait(210)
            end
            --task.Wait(300)
        end
    end
end
table.insert(scs, {boss_sc3, boss_sc3_normal_show, boss_sc3_scpr_show})


--四符
local function boss_sc4_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc4_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc4(self)
    local f1, f1_1, f1_2, f1_3, f2, f2_1, f2_2, f3, f3_1, f4_1, f5
    do
        --生成一排石头
        function f1(t0, t1)
            task.New(self, function()
                local dx = 448/6
                for i = 0, 6 do
                    for u = -1, 1, 2 do
                        f1_1((224 - dx*i)*u, 245 + 30*u, 3 + ran:Float(-0.1, 0.1), -90 + ran:Float(-1, 1), t0 - 3*i, t1)
                        f1_2((224 - dx*i)*u + 0.3*dx, 245 + 30*u, 3 + ran:Float(-0.1, 0.1), -90 + ran:Float(-2, 2), t0 - 3*i, t1)
                        f1_3((224 - dx*i)*u + 0.6*dx, 245 + 30*u, 3 + ran:Float(-0.1, 0.1), -90 + ran:Float(-3, 3), t0 - 3*i, t1)
                        f3_1((224 - dx*i)*u + ran:Float(0, 1)*dx, 245 + 30*u, 2 + ran:Float(-0.25, 0.25), -90 + ran:Float(-2, 2), stg.star_small, 10)
                        f3_1((224 - dx*i)*u + ran:Float(0, 1)*dx, 245 + 30*u, 2 + ran:Float(-0.25, 0.25), -90 + ran:Float(-2, 2), stg.star_small, 6)
                        f3_1((224 - dx*i)*u + ran:Float(0, 1)*dx, 245 + 30*u, 1.75 + ran:Float(-0.25, 0.25), -90 + ran:Float(-1, 1), stg.star_big, 3)
                    end
                    PlaySound("kira00")
                    task.Wait(3)
                end
            end)
        end
        --更大的石头
        function f1_1(x, y, v, a, t0, t1)
            local obj = stg.newBulletStraight(stg.ball_huge, 16, true, x, y, 0, ran:Float(0, 360), true)
            obj.img = "stone_huge"
            --obj.timer = 11
            boundWait(obj, 120)
            obj.omiga = 3
            --egg.AddSimStrChV(obj, 0, v, a, 60)
            egg.AddAccDecChV(obj, v, a, 30, t0, 20)
            egg.AddSimStrChV(obj, 0, v, a, 60, 60 + t0 + t1)
        end
        --大石头
        function f1_2(x, y, v, a, t0, t1)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, x, y, 0, ran:Float(0, 360), true)
            obj.img = "stone_big"
            --obj.timer = 11
            boundWait(obj, 120)
            obj.omiga = 3
            --egg.AddSimStrChV(obj, 0, v, a, 60)
            egg.AddAccDecChV(obj, v, a, 30, t0, 15)
            egg.AddSimStrChV(obj, 0, v, a, 60, 60 + t0 + t1)
        end
        --小石头
        function f1_3(x, y, v, a, t0, t1)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, true, x, y, 0, ran:Float(0, 360), true)
            obj.img = "stone_mid"
            --obj.timer = 11
            boundWait(obj, 120)
            obj.omiga = 3
            --egg.AddSimStrChV(obj, 0, v, a, 60)
            egg.AddAccDecChV(obj, v, a, 30, t0, 10)
            egg.AddSimStrChV(obj, 0, v, a, 60, 60 + t0 + t1)
        end
        --生成一颗大石头
        function f2()
            local obj = stg.newBulletStraight(stg.ball_light, 1, true, self.x, self.y, 0, 0, true)
            obj.img = "stone_unclear"
            obj.timer = 11
            obj.x, obj.y = self.x, self.y
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.hscale, obj.vscale = 0, 0
            obj.colli = false
            --停止
            local function stop()
                for _, o in ObjList(GROUP_ENEMY_BULLET) do
                    if o ~= obj then
                        egg.StopCurrentV(o, 60)
                    end
                end
            end
            local function clearBullet()
                for _, o in ObjList(GROUP_INDES) do
                    if o ~= obj then
                        if Dist(o, obj) < o.a + obj.a then
                            Del(o)
                        end
                    end
                end
            end
            local function reboundBullet()
                for _, o in ObjList(GROUP_INDES) do
                    if o ~= obj then
                        if Dist(o, obj) < o.a + obj.a and not o.flag then
                            egg.AddSimStrChV(o, 4, 1.5 + ran:Float(-0.25, 0.25), Angle(obj, o) + ran:Float(-5, 5), 20)
                            o.flag = true
                            PlaySound("kira00")
                        end
                    end
                end
            end
            --动作
            task.New(obj, function()
                egg.SimSizeCh(obj, 0, 0.25, 30)
                obj.colli = true
                obj.a, obj.b = 42, 42
                task.Wait(30)
                eff(obj.x, obj.y, 30)
                local a = Angle(obj, player)
                New(lasereff, obj.x, obj.y, a, 255, 0, 0, 15)
                task.Wait(60)
                self.addTimes(120)
                --扔出去
                --
                New(trail2, obj, 10, 2, obj.img, 1, "mul+add", 9999, 0.5, true)
                egg.AddSimStrChO(obj, 0, 1, 120)
                egg.AddSimStrChV(obj, 0, 4, a, 30)
                task.Wait(30)
                local p0, dp, dx, dy, a0 = 0, 7.5
                while true do
                    for u = -1, 1, 2 do
                        for i = -1, 1 do
                            a0 = a + 20*sin(p0*u) + 180 + 20*i
                            dx, dy = 60*cos(a0), 60*sin(a0)
                            --f4_1(obj.x + dx, obj.y + dy, 60*sin((60*i + p0)*u), 1)
                            f4_1(obj.x + dx, obj.y + dy, a0, 1)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(1)
                    p0 = p0 + dp
                end
            end)
            --反弹石头
            task.New(obj, function()
                for _ = 1, 30 do
                    clearBullet()
                    task.Wait(1)
                end
                while true do
                    reboundBullet()
                    task.Wait(1)
                end
            end)
        end
        --星星
        function f3_1(x, y, v, a, st, co)
            local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
            obj.omiga = 3
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
        --大石头拖影弹幕
        function f4_1(x, y, a, co)
            local obj = stg.newBulletStraight(stg.grain_a, co, true, x, y, 0, a)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, -1, 6, a, 30)
        end
    end

    do
        self.minFps(45)
        s7_boss.pic_show()
        task.Wait(90)
        self:cast(600)
        while true do
            eff(self.x,  self.y, 60)
            --生成四层石头，要求同时停下来，然后后生成的先动
            misc.ShakeScreen(240, 2)
            --140f后延迟
            task.New(self, function()
                task.Wait(140)
                self.addTimes(180)
            end)
            for i = 1, 6 do
                f1(40*(6-i), 360 + 40*(6-i))
                task.Wait(40)
            end
            task.Wait(60)
            eff(self.x, self.y, 60)
            misc.ShakeScreen(60, 5)
            f2()
            task.Wait(300)
        end
    end
end
table.insert(scs, {boss_sc4, boss_sc4_normal_show, boss_sc4_scpr_show})

--五符
local function boss_sc5_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc5_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc5(self)
    local lines = {}  --预警线
    local arrow_stone = {} --锥形石头
    local f1, f1_1, f1_2, f1_3, f1_4, f1_5, f2, f2_1, f2_2, f2_3, f2_4, f3, f4, f4_1
    local function laserAttack()
        local obj
        for i = 1, #lines do
            obj = lines[i]
            if IsValid(obj) then
                task.New(obj, function()
                    for _ = 1, 3 do
                        f1_5(obj, 100, 100, 255)
                        task.Wait(10)
                    end
                end)
            end
        end
        task.New(self, function()
            local dr, dg = (50 - 255)/20, (50 - 255)/20
            for _ = 1, 20 do
                for i = 1, #lines do
                    obj = lines[i]
                    if IsValid(obj) then
                        obj._r, obj._g = obj._r + dr, obj._g + dg
                    end
                end
                task.Wait(1)
            end
            PlaySound("lazer01")
            for _ = 1, 3 do
                for i = 1, #lines do
                    obj = lines[i]
                    if IsValid(obj) then
                        f1_5(obj, 50, 50, 255)
                    end
                end
                task.Wait(5)
            end
            --task.Wait(15)
            --self.addTimes(60)
            task.Wait(15)
            for i = 1, #lines do
                obj = lines[i]
                if IsValid(obj) then
                    f3(obj)
                end
            end
            dr, dg = -dr, -dg
            for _ = 1, 20 do
                for i = 1, #lines do
                    obj = lines[i]
                    if IsValid(obj) then
                        obj._r, obj._g = obj._r + dr, obj._g + dg
                    end
                end
                task.Wait(1)
            end
        end)
    end
    do
        --石头阵中心
        function f1()
            local obj = stg.newBulletStraight(stg.grain_a, 16, true, 0, 0, 0, 0, true)
            obj.img = "stone_unclear"
            obj.bound = false
            obj.timer = 11
            obj.colli = false
            obj.hscale, obj.vscale = 0, 0
            _object.set_color(obj, "", 150, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 0.325, 20)
            --锥形石头碰到这个会裂掉的
            local function delBullet()
                for _, o in ipairs(arrow_stone) do
                    if IsValid(o) and Dist(o, obj) < 0.5*o.a + obj.a then
                        f4(o.x, o.y, o.rot + 180)
                        Del(o)
                    end
                end
                for _, o in ObjList(GROUP_ENEMY_BULLET) do
                    if IsValid(o) and Dist(o, obj) < obj.a then
                        Del(o)
                    end
                end
            end
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
                task.Wait(90)
                egg.SimAlpCh(obj, 150, 255, 30)
                obj.a, obj.b = 42, 42
                task.Wait(30)
                obj.colli = true
            end)
            for i = -9, 9, 2 do
                f1_1(obj, 35*i, 0, true) --横向
                f1_1(obj, 35*i, 90) --纵向
            end
            task.New(obj, function()
                task.Wait(90)
                --self.addTimes(30)
                task.Wait(150)
                egg.AddSimStrChO(obj, 0, 0.5, 180)
                while true do
                    delBullet()
                    task.Wait(1)
                end
            end)
            return obj
        end
        --石头阵每排每列的中心控制器
        function f1_1(mst, r, a, spawnStone)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, mst.x + r*cos(mst.rot + a), mst.y + r*sin(mst.rot + a), 0, mst.rot + a, true)
            obj.hide = true
            obj.colli = false
            obj.rot = mst.rot + a
            obj.bound = false
            --跟着中心动
            task.New(obj, function()
                local a0
                while true do
                    if IsValid(mst) then
                        a0 = mst.rot + a
                        obj.x, obj.y, obj.rot = mst.x + r*cos(a0), mst.y + r*sin(a0), a0
                    else
                        Del(obj)
                    end
                    task.Wait(1)
                end
            end)

            task.New(obj, function()
                if spawnStone then
                    task.New(obj, function()
                        for i = -9, 9, 2 do
                            f1_3(obj, 35*i)
                            PlaySound("kira00")
                            task.Wait(5)
                        end
                    end)
                end
                task.Wait(90)
                --生成一排石头以及线
                local li = f1_2(obj)
                table.insert(lines, li)
                task.New(li, function()
                    for _ = 1, 3 do
                        f1_5(li, 255, 255, 255)
                        task.Wait(5)
                    end
                    task.Wait(30)
                    PlaySound("lazer01")
                    f3(li)
                end)
            end)
        end
        --石头阵的线
        function f1_2(mst)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, mst.x, mst.y, 0, mst.rot + 90, true)
            --obj.hide = false
            obj.bound = false
            obj.img = "white"
            _object.set_color(obj, "", 150, 255, 255, 255)
            obj.colli = false
            obj.hscale, obj.vscale = 75, 0
            --生成时变大
            task.New(obj, function()
                local dv = 0.25/60
                for _ = 1, 60 do
                    obj.vscale = obj.vscale + dv
                    task.Wait(1)
                end
            end)
            --跟随主人移动
            task.New(obj, function()
                while IsValid(mst) do
                    obj.x, obj.y, obj.rot = mst.x, mst.y, mst.rot + 90
                    task.Wait(1)
                end
                Del(obj)
            end)
            return obj
        end
        --石头阵的石头
        function f1_3(mst, r)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, mst.x + r*cos(mst.rot + 90), mst.y + r*sin(mst.rot + 90), 0, mst.rot + 90, true)
            obj.img = "stone_big"
            obj.bound = false
            obj.colli = false
            obj.timer = 11
            obj.hscale, obj.vscale = 0, 0
            _object.set_color(obj, "", 150, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 20)
            task.New(obj, function()
                task.Wait(90)
                egg.SimAlpCh(obj, 150, 255, 30)
                f1_4(obj.x, obj.y, 1)
                task.Wait(30)
                obj.colli = true
            end)
            --跟随主人移动
            task.New(obj, function()
                local a
                while IsValid(mst) do
                    a = mst.rot + 90
                    obj.x, obj.y, obj.rot = mst.x + r*cos(a), mst.y + r*sin(a), a
                    task.Wait(1)
                end
                Del(obj)
            end)
        end
        --石头虚影
        function f1_4(x, y, s)
            local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0, true)
            obj.img = "stone_huge"
            obj.group = GROUP_GHOST
            obj.hscale, obj.vscale = 0.75*s, 0.75*s
            _object.set_color(obj, "mul+add", 150, 255, 255, 255)
            task.New(obj, function()
                egg.SimSizeCh(obj, 0.75*s, 1.5*s, 20)
                egg.SimAlpCh(obj, 150, 0, 20)
                task.Wait(20)
                Del(obj)
            end)
        end
        --石头阵的线虚影
        function f1_5(mst, r, g, b)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, mst.x, mst.y, 0, mst.rot, true)
            --obj.hide = false
            obj.bound = false
            obj.img = "white"
            _object.set_color(obj, "", 255, r, g, b)
            obj.colli = false
            obj.timer = 11
            obj.hscale, obj.vscale = 75, 0
            --生成时变大
            task.New(obj, function()
                egg.SimAlpCh(obj, 255, 0, 30)
                local dv = 4/30
                for _ = 1, 30 do
                    obj.vscale = obj.vscale + dv
                    task.Wait(1)
                end
                Del(obj)
            end)
            --跟随主人移动
            task.New(obj, function()
                while IsValid(mst) do
                    obj.x, obj.y, obj.rot = mst.x, mst.y, mst.rot
                    task.Wait(1)
                end
                Del(obj)
            end)
        end

        --跟随石头阵的激光发射器
        function f2_1(mst, a, u)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, -999, 999, 0, mst.rot + a, true)
            --obj.hide = true
            obj.colli = false
            obj.rot = mst.rot + a
            obj.bound = false
            --生成扫描线
            local line = f2_2(obj)
            --跟着中心动
            task.New(obj, function()
                local r, d, dd, a0 = 300, 360*u, -0.9*u
                --跟随主人运动
                local function moveWithMst()
                    if IsValid(mst) then
                        a0 = mst.rot + a
                        d = d + dd
                        obj.x, obj.y, obj.rot = mst.x + r*cos(a0) - d*sin(a0), mst.y + r*sin(a0) + d*cos(a0), a0 + 180
                    else
                        Del(obj)
                    end
                end
                while true do
                    moveWithMst()
                    if abs((Angle(obj, player) - obj.rot)%360) < 5 then --激光碰到了
                        break
                    end
                    task.Wait(1)
                end
                if IsValid(line) then Del(line) end
                --self.addTimes(30)
                PlaySound("kira00")
                misc.ShakeScreen(30, 2)
                f2_3(obj) --生成真正的预警线
                f2_4(obj) --生成能杀人的锥形石头
                local a = Angle(obj, player)
                for i = 1, 20 do
                    boundWait(accbullet(stg.ball_mid_c, 5, obj.x, obj.y, 1 + ran:Float(-0.1, 0.1), a + 18*i, 30), 120)
                end
                for i = 1, 15 do
                    boundWait(accbullet(stg.ball_big, 6, obj.x, obj.y, 1.25 + ran:Float(-0.1, 0.1), a + 24*i, 30), 120)
                end
                for i = 1, 20 do
                    boundWait(accbullet(stg.ball_mid_c, 5, obj.x, obj.y, 2 + ran:Float(-0.1, 0.1), a + 18*i, 30), 120)
                end
                for i = 1, 24 do
                    boundWait(accbullet(stg.ball_big, 6, obj.x, obj.y, 2.25 + ran:Float(-0.1, 0.1), a + 15*i, 30), 120)
                end
                for _ = 1, 240 do
                    moveWithMst()
                    task.Wait(1)
                end
                Del(obj)
            end)
        end
        --激光扫描线
        function f2_2(mst) -- 这个是老的特效，不容易看清，下面重新写了一个
            PlaySound("lazer00")
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, mst.x, mst.y, 0, mst.rot, true)
            --obj.hide = false
            obj.bound = false
            obj.img = "white"
            _object.set_color(obj, "mul+add", 0, 255, 0, 0)
            obj.colli = false
            obj.hscale, obj.vscale = 0, 0.75
            --生成时变大
            task.New(obj, function()
                egg.SimAlpCh(obj, 0, 120, 60)
                task.Wait(60)
                local dh, dv = 150/240, 0.75/180
                for _ = 1, 240 do
                    obj.hscale = obj.hscale + dh
                    --obj.vscale = obj.vscale + dv
                    task.Wait(1)
                end
            end)
            --跟随主人移动
            task.New(obj, function()
                while IsValid(mst) do
                    obj.x, obj.y, obj.rot = mst.x, mst.y, mst.rot
                    task.Wait(1)
                end
                Del(obj)
            end)
            return obj
        end
        function f2_2(mst)
            PlaySound("lazer00")
            local obj = lstg.New(dir_warn_obj, mst)
            return obj
        end
        --激光预警线
        function f2_3(mst)
            local obj = New(lasereff, mst.x, mst.y, mst.rot, 255, 0, 0, 6) --预警
            --obj.hide = false
            obj.bound = false
            --obj.img = "white"
            --_object.set_color(obj, "", 150, 255, 150, 150)
            obj.colli = false
            obj.hscale = 150
            --[[生成时变大
            task.New(obj, function()
                local dv = 0.25/30
                for _ = 1, 30 do
                    obj.vscale = obj.vscale + dv
                    task.Wait(1)
                end
            end)]]
            --跟随主人移动
            task.New(obj, function()
                while IsValid(mst) do
                    obj.x, obj.y, obj.rot = mst.x, mst.y, mst.rot
                    task.Wait(1)
                end
                Del(obj)
            end)
            --return obj
        end
        --尖尖的石头
        function f2_4(mst)
            local obj = stg.newBulletStraight(stg.ball_huge, 16, true, mst.x, mst.y, 0, -90)
            obj.timer = 11
            obj.bound = false
            obj.img = "pointed_stone"
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.bound = false
            --跟随主人移动
            task.New(obj, function()
                --New(egg.trail, obj, 10, 2, nil, 1, "mul+add", nil, nil, false)
                New(trail2, obj, 10, 1, obj.img, 1, "mul+add", 9999, 0.5, true)
                local r, t, a = 0, 0
                while IsValid(mst) do
                    r, a = r + 10, mst.rot
                    obj.x, obj.y, obj.rot = mst.x + r*cos(a), mst.y + r*sin(a), a
                    --碰到边缘也会炸的
                    if t > 30 and (obj.x > 192 or obj.x < -192 or obj.y > 224 or obj.y < -224) then
                        f4(obj.x, obj.y, obj.rot + 180)
                        break
                    end
                    task.Wait(1)
                    t = t + 1
                end
                Del(obj)
            end)
            table.insert(arrow_stone, obj)
        end
        --大*激光
        function f3(mst)
            local obj = stg.newBulletStraight(stg.ball_light, 5, true, mst.x, mst.y, 0, mst.rot, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.undestoryable = true --真正不可消除
            obj.hscale, obj.vscale = 0, 0.35
            obj.a, obj.b = 0, 0.35*obj.b
            obj.bound = false
            obj.timer = 11
            --变长
            task.New(obj, function()
                --PlaySound("lazer01")
                task.New(obj, function()
                    local dh = 0.75
                    for _ = 1, 20 do
                        obj.hscale = obj.hscale + dh
                        obj.a = obj.a + 12*dh
                        task.Wait(1)
                    end
                    task.Wait(120)
                    obj.bound = true
                end)
            end)
            --沿线走
            task.New(obj, function()
                local r, a = -300
                for _ = 1, 120 do
                    r = r + 10
                    if IsValid(mst) then
                        a = mst.rot
                        obj.x, obj.y, obj.rot = mst.x + r*cos(a), mst.y + r*sin(a), a
                    else
                        Del(obj)
                    end
                    task.Wait(1)
                end
                Del(obj)
            end)
        end

        --搞出一堆不知道什么东西
        function f4(x, y, a)
            for _ = 1, 20 do
                f4_1(x, y, ran:Float(1.5, 5), a + ran:Float(-45, 45))
                stg.newBulletStraight(stg.ball_mid, 2, true, x, y, ran:Float(1.5, 5), a + ran:Float(-45, 45))
            end
            for _ = 1, 10 do
                stg.newBulletStraight(stg.ball_big, 2, true, x, y, ran:Float(1.5, 5), a + ran:Float(-45, 45))
            end
        end
        --炎弹
        function f4_1(x, y, v, a)
            local obj = stg.newBulletStraight(stg.water_drop, 1, true, x, y, v, a)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
        end
    end

    do
        self.minFps(45)
        s7_boss.pic_show()
        task.Wait(90)
        eff(self.x, self.y, 60)
        self:cast(120)
        local mid = f1()
        task.Wait(30)
        task.New(self, function()
            task.Wait(600)
            while true do
                eff(self.x, self.y, 30)
                laserAttack()
                task.Wait(480)
            end
        end)
        while true do
            --[[for u = 1, -1, -2 do
                for i = 0, 1 do
                    f2_1(mid, 90*i, 1)
                    task.Wait(180)
                end
            end]]
            for i = 0, 3 do
                f2_1(mid, 90*i + 90, 1)
                task.Wait(60)
                f2_1(mid, 90*i, 1)
                task.Wait(240)
            end
        end
    end
end
table.insert(scs, {boss_sc5, boss_sc5_normal_show, boss_sc5_scpr_show})

--六符
local function boss_sc6_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc6_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc6(self)
    local huge_stones = {}  --装大石头的表（可以被击碎的大石头
    local f1, f2, f2_1, f2_2, f2_3, f3, f4, f5, f5_1
    do
        --生成大巴掌
        function f1(x, y, u, isTrace)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 1,  true, self.x - 30*u, self.y, 0, 0, true)
            local function clearBullet()
                for _, o in ipairs(huge_stones) do
                    if IsValid(o) and Dist(o, obj) < o.a + obj.a then
                        f3(o.x, o.y, 90*(1-u))
                        Del(o)
                    end
                end
            end
            obj.bound = false
            obj.img = "hand"
            obj.timer = 11
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.hscale = -u*obj.hscale
            egg.simSizeChFrom0(obj, 1, 30, true)
            obj.colli = false
            --追人
            task.New(obj, function()
                for _ = 1, 6 do
                    shadow(obj.x, obj.y, obj.img, obj.hscale)
                    task.Wait(5)
                end
                obj.colli = true
                task.MoveTo(obj.x - 260*u, obj.y, 80, MOVE_ACC_DEC)
                obj.hscale = -obj.hscale --反转
                if isTrace then
                    --x变换
                    task.New(obj, function()
                        local dx = -(obj.x + 180*u)/60
                        for _ = 1, 60 do
                            obj.x = obj.x + dx
                            task.Wait(1)
                        end
                    end)
                    for _ = 1, 150 do
                        obj.vy = max(-3, min(3, 0.05*(player.y + 30 - obj.y)))
                        task.Wait(1)
                    end
                else
                    task.Wait(60)
                    task.MoveTo(x, y, 60, MOVE_DECEL)
                end
                eff(obj.x, obj.y)
                egg.AddSimStrChV(obj, 0, -obj.vy, 90, 10)
                task.Wait(10)
                task.Wait(20)
                PlaySound("kira00")
                New(lasereff, obj.x, obj.y, 90*(1-u), 255, 0, 0, 10)
                --self.addTimes(20)
                egg.AddSimStrChV(obj, 0, 10, 90*(1-u), 15)
                New(trail2, obj, 20, 1, obj.img, 0.75, "mul+add", 9999, 0.4, true)
                for t = 1, 25 do
                    clearBullet()
                    if t%4 == 0 then
                        for i = 0, 8 do
                            for u0 = -1, 1, 2 do
                                f4(obj.x - 5*u, obj.y, 1 + 0.5*i + ran:Float(-0.1, 0.1), 90*u0)
                            end
                        end
                    end
                    task.Wait(1)
                end
                misc.ShakeScreen(60, 5)
                f5(0, obj.y)
                if IsValid(self) then
                    task.New(self, function()
                        task.Wait(120)
                        for _ = 1, 2 do
                            f2(u)
                            task.Wait(30)
                        end
                    end)
                end
                Del(obj)
            end)
        end
        --生成一排石头
        function f2(u)
            --u决定从左还是从右开始生成
            task.New(self, function()
                local dx = 384/9
                for i = 0, 9 do
                    f2_1((-192 + dx*i)*u, 245, 0.75 + ran:Float(-0.075, 0.075))
                    PlaySound("kira00")
                    task.Wait(1)
                end
            end)
        end
        --巨大石头（可以被拍碎
        function f2_1(x, y, v)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, x, y, 0, ran:Float(0, 360), true)
            obj.img = "stone_huge"
            --obj.bound = false
            obj.timer = 11
            obj.omiga = 3
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.simSizeChFrom0(obj, 1, 30, true)
            egg.AddSimStrChV(obj, 0, v, -90 + ran:Float(-5, 5), 60)
            table.insert(huge_stones, obj)
        end
        --大石头
        function f2_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_big, 16, true, x, y, 0, ran:Float(0, 360), true)
            obj.img = "stone_big"
            --obj.bound = false
            obj.timer = 11
            obj.omiga = 3
            egg.simSizeChFrom0(obj, 1, 10, true)
            egg.AddSimStrChV(obj, 6, v, a, 30)
        end
        --小石头
        function f2_3(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 16, true, x, y, 0, ran:Float(0, 360), true)
            obj.img = "stone_mid"
            --obj.bound = false
            obj.timer = 11
            obj.omiga = 3
            egg.simSizeChFrom0(obj, 1, 10, true)
            egg.AddSimStrChV(obj, 6, v, a, 30)
        end
        --巨大石头破碎生成大石头和小石头
        function f3(x, y, a0)
            local a = ran:Float(-5, 5) + a0
            for i = -1, 1 do
                f2_2(x, y, 2.5 + ran:Float(-0.2, 0.2), a + 18*i)
            end
            a = ran:Float(-5, 5) + a0
            for i = -2, 2 do
                f2_3(x, y, 2.9 + ran:Float(-0.2, 0.2), a + 12*i)
            end
        end
        --封位炎弹
        function f4(x, y, v, a)
            local obj = stg.newBulletStraight(stg.water_drop, 3, true, x, y, 0, a)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 30)
        end
        --星
        function f5(x, y)
            for i = 1, 12 do
                for j = 0, 1 do
                    f5_1(x, y, 1 + 1*j + ran:Float(-0.5, 0.5), 30*i + ran:Float(-7.5, 7.5), stg.star_big, 1)
                end
            end
            for i = 1, 18 do
                for j = 0, 4 do
                    f5_1(x, y, 0.75 + 0.4*j + ran:Float(-0.25, 0.25), 20*i + ran:Float(-5, 5), stg.star_small, 10)
                end
            end
        end
        --星星
        function f5_1(x, y, v, a, st, co)
            local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
            obj.omiga = 3
            egg.AddSimStrChV(obj, 0, v, a, 30)
        end
    end

    do
        s7_boss.pic_show()
        task.Wait(90)
        self:cast(60)
        eff(self.x, self.y, 30)
        misc.ShakeScreen(120, 5)
        for u = -1, 1, 2 do
            f1(180*u, 90, -u, false)
        end
        task.Wait(60)
        f2(1)
        --生成其他石头
        task.New(self, function()
            task.Wait(150)
            while true do
                f2_1(ran:Float(-192, 192), 245, 1.25 + ran:Float(-0.25, 0.25))
                task.Wait(10)
            end
        end)
        --循环拍人
        task.Wait(240 + 60)
        while true do
            self:cast(60)
            eff(self.x, self.y, 30)
            for u = -1, 1, 2 do
                f1(180*u, 30, -u, true)
            end
            task.Wait(300 + 120)
        end
    end
end
table.insert(scs, {boss_sc6, boss_sc6_normal_show, boss_sc6_scpr_show})

--七符(滴水穿石
local function boss_sc7_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 50, 60, MOVE_NORMAL)
end
local function boss_sc7_scpr_show(self)
    boss_scpr_show(self, 0, 50)
end
local function boss_sc7(self)
    local rebounds = {}
    local f1, f1_1, f2, f2_1, f3, f4, f5
    do
        --地爆天星
        function f1()
            local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0, true)
            obj.img = "stone_unclear"
            obj.timer = 11
            obj.x, obj.y = self.x, self.y
            _object.set_color(obj, "", 150, 255, 255, 255)
            obj.hscale, obj.vscale = 0, 0
            obj.colli = false
            --吸入的速度参数与方法
            local function rebound()
                local v, a, a0
                for _, o in ipairs(rebounds) do
                    if IsValid(o) and Dist(o, obj) < o.a + obj.a and o.reboundtime <= 0 then
                        --Del(o)
                        --obj.reboundtime = 60
                        v, a = 0.8*Dist(0, 0, o.vx, o.vy), Angle(0, 0, o.vx, o.vy)
                        a0 = Angle(o, obj)
                        a = -a + 2*a0 + 180 --圆反弹公式
                        SetV(o, v, a) --反弹
                        o.reboundtime = 20
                    end
                end
            end
            --变大
            task.New(obj, function()
                misc.ShakeScreen(60, 5)
                egg.SimAlpCh(obj, 0, 255, 60)
                egg.SimSizeCh(obj, 0, 0.8, 60)
                obj.colli = true
                obj.a, obj.b = 42*3, 42*3
                f1_1(obj.x, obj.y, 0.8)

                task.Wait(60)
                misc.ShakeScreen(120, 3)
                for _ = 1, 3 do
                    eff(obj.x, obj.y, 20)
                end
                task.Wait(60)
                for _ = 1, 5 do
                    f1_1(obj.x, obj.y, 1)
                    task.Wait(5)
                end
                for i = 1, 8 do
                    f3(45*i)
                end
                Del(obj)
            end)
            --反弹子弹
            task.New(obj, function()
                while true do
                    rebound()
                    task.Wait(1)
                end
            end)

        end
        --地爆天星虚影
        function f1_1(x, y, s)
            local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0, true)
            obj.img = "stone_unclear"
            obj.group = GROUP_GHOST
            obj.hscale, obj.vscale = 0.75*s, 0.75*s
            _object.set_color(obj, "mul+add", 150, 255, 255, 255)
            task.New(obj, function()
                egg.SimSizeCh(obj, 0.75*s, 1.5*s, 20)
                egg.SimAlpCh(obj, 150, 0, 20)
                task.Wait(20)
                Del(obj)
            end)
        end
        function f2(x, y)
            for i = -5, 5 do
                f2_1(x, y, -90 + 4*i)
            end
        end
        --碰到石头会反弹的子弹
        function f2_1(x, y, v, ay, a, co)
            local obj = stg.newBulletStraight(stg.water_drop, co, true, x, y, v, a)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.ay = ay
            obj.navi = true
            obj.reboundtime = 20
            boundWait(obj, 60)
            table.insert(rebounds, obj)
            task.New(obj, function()
                while true do
                    obj.reboundtime = max(0, obj.reboundtime - 1)
                    task.Wait(1)
                end
            end)
        end
        --较小的挡雨球
        function f3(a)
            local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0, true)
            obj.img = "stone_unclear"
            obj.timer = 11
            obj.x, obj.y = self.x, self.y
            _object.set_color(obj, "", 150, 255, 255, 255)
            obj.hscale, obj.vscale = 0, 0
            obj.colli = false
            --反弹子弹
            local function rebound()
                local v, a, a0, d
                for _, o in ipairs(rebounds) do
                    if IsValid(o) then
                        d = Dist(o, obj)
                        if d < 0.75*obj.a then
                            _del(o, true)
                        end
                        if d < o.a + obj.a and o.reboundtime <= 0 then
                            v, a = max(0.6*Dist(0, 0, o.vx, o.vy), 1), Angle(0, 0, o.vx, o.vy)
                            a0 = Angle(o, obj)
                            a = -a + 2*a0 + 180 --圆反弹公式
                            SetV(o, v, a) --反弹
                            o.reboundtime = 20
                        end
                    end
                end
            end
            --消除内部子弹
            local function clearbullet()
                for _, o in ipairs(rebounds) do
                    if IsValid(o) and Dist(o, obj) < -o.a + obj.a and o.reboundtime <= 0 then
                        Del(o)
                    end
                end
            end
            --变大
            task.New(obj, function()
                egg.AddAccDecChV(obj, 1.5, a, 1, 60, 30)
                --egg.AddSimStrChV(obj, 2, 0.5, a, 30)
                SetV(obj, 0.5, a)
                --misc.ShakeScreen(60, 5)
                egg.SimAlpCh(obj, 0, 255, 30)
                --egg.SimSizeCh(obj, 0, 0.25, 30)
                obj.colli = true
                obj.a, obj.b = 42, 42
                local ds = 0.25/90
                for _ = 1, 90 do
                    obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                    obj.a, obj.b = 168*obj.hscale, 168*obj.vscale
                    task.Wait(1)
                end
            end)
            --反弹子弹
            task.New(obj, function()
                while true do
                    rebound()
                    task.Wait(1)
                end
            end)
        end
    end

    do
        --self.minFps(60)
        s7_boss.pic_show()
        task.Wait(90)
        self:cast(600)
        eff(self.x, self.y, 60)
        f1()
        --丢球
        task.New(self, function()
            task.Wait(240)
            task.MoveTo(0, 144, 60, MOVE_NORMAL)
            task.Wait(60)
            local a
            while true do
                eff(self.x, self.y, 30)
                for j = -3, 3, 2 do
                    f3(-90 + 22.5*j)
                end
                PlaySound("kira00")
                task.Wait(30)
                self.addTimes(180)
                for k = 1, 15 do
                    a = ran:Float(0, 360)
                    for i = 1, 20 do
                        f2_1(self.x, self.y, 3 + 0.2*k, 0, a + 18*i, 5)
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                task.Wait(270)
                eff(self.x, self.y, 30)
                for j = -1, 1 do
                    f3(-90 + 45*j)
                end
                PlaySound("kira00")
                task.Wait(30)
                self.addTimes(180)
                for k = 1, 15 do
                    a = ran:Float(0, 360)
                    for i = 1, 20 do
                        f2_1(self.x, self.y, 3 + 0.2*k, 0, a + 18*i, 5)
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                task.Wait(270)
            end
        end)
        --下雨
        while true do
            for i = -2, 2 do
                f2_1(90*i + ran:Float(-45, 45), 245 + ran:Float(-20, 20), ran:Float(1.5, 1.75), -0.0075, -90 + ran:Float(-15, 15), 7)
            end
            PlaySound("kira00")
            task.Wait(10)
        end
    end
end
table.insert(scs, {boss_sc7, boss_sc7_normal_show, boss_sc7_scpr_show})

--八符(指数爆炸
local function boss_sc8_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 50, 60, MOVE_NORMAL)
end
local function boss_sc8_scpr_show(self)
    boss_scpr_show(self, 0, 50)
end
local function boss_sc8(self)
    local f1, f1_1, f2, f2_1, f2_2, f3, f4, f5
    do
        --地爆天星
        function f1()
            local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0, true)
            obj.img = "stone_unclear"
            obj.timer = 11
            obj.x, obj.y = self.x, self.y
            _object.set_color(obj, "", 150, 255, 255, 255)
            obj.hscale, obj.vscale = 0, 0
            obj.colli = false
            --吸入的速度参数与方法
            local v = 0
            local function addV(dv, t)
                task.New(obj, function()
                    dv = dv/t
                    for _ = 1, t do
                        v = v + dv
                        task.Wait(1)
                    end
                end)
            end
            local function clearBullet()
                for _, o in ObjList(GROUP_INDES) do
                    if o ~= obj then
                        if Dist(o, obj) < o.a + obj.a then
                            Del(o)
                        end
                    end
                end
            end
            local function absorb()
                local a
                for _, o in ObjList(GROUP_INDES) do
                    if o ~= obj then
                        if Dist(o, obj) < o.a + obj.a then
                            Del(o)
                        end
                        a = Angle(o, obj)
                        o.x, o.y = o.x + v*cos(a), o.y + v*sin(a)
                    end
                end
                --a = Angle(player, obj)
                --player.x, player.y = player.x + v*cos(a), player.y + v*sin(a)
            end
            --停止
            local function stop()
                for _, o in ObjList(GROUP_INDES) do
                    if o ~= obj then
                        egg.StopCurrentV(o, 60)
                    end
                end
            end
            --把场上其他石头变成随机弹
            local function random()
                for _, o in ObjList(GROUP_INDES) do
                    if o ~= obj then
                        egg.AddSimStrChV(o, 0, ran:Float(0.75, 1.5), ran:Float(0, 360), 120)
                    end
                end
            end
            --变大
            task.New(obj, function()
                misc.ShakeScreen(15, 5)
                egg.SimAlpCh(obj, 0, 255, 30)
                egg.SimSizeCh(obj, 0, 0.25, 30)
                obj.colli = true
                obj.a, obj.b = 42, 42
                f1_1(obj.x, obj.y, 0.25)
                --task.Wait(15)
                addV(0.35, 30) --加强吸入速度
                local size = {1*0.25, 1.5*0.25, 2*0.25, 2.5*0.25, 3*0.25}
                for i = 1, #size - 1 do
                    eff(obj.x, obj.y)
                    addV(0.15, 30) --加强吸入速度
                    f5(obj.x, obj.y, int(1 + 0.5*i))
                    task.Wait(30)
                    self.addTimes(90)
                    task.Wait(90)
                    --misc.ShakeScreen(15, 5)
                    egg.SimSizeCh(obj, size[i], size[i+1], 30, true)
                    f1_1(obj.x, obj.y, size[i+1])
                end
                --task.Wait(60)
                misc.ShakeScreen(120, 5)
                stop()
                addV(-v, 60)
                task.Wait(120)
                eff(obj.x, obj.y, 30)
                local a = Angle(obj, player)
                New(lasereff, obj.x, obj.y, a, 255, 0, 0, 30)
                task.Wait(30)
                --扔出去
                self.addTimes(240)
                egg.AddSimStrChO(obj, 0, 1, 120)
                egg.AddSimStrChV(obj, 0, 2, a, 120)
                while (obj.x < 192 - obj.a) and (obj.x > -192 + obj.a) and (obj.y < 224 - obj.b) and (obj.y > -224 + obj.b) do
                    task.Wait(1)
                end
                misc.ShakeScreen(30, 10)
                random()
                New(tasker, function()
                    local x, y = obj.x, obj.y
                    for i = -1, 1 do
                        f3(x, y, 1.25, a + 180 + 60*i, 1)
                    end
                    f4(x, y, 24, 30)
                    for i = 0, 9 do
                        f1_1(x, y, 0.75 + 0.25*i)
                        task.Wait(1)
                    end
                end)
                Del(obj)
            end)
            --吸入惹
            task.New(obj, function()
                while true do
                    if v ~= 0 then
                        absorb()
                    else
                        clearBullet()
                    end
                    task.Wait(1)
                end
            end)
        end
        --地爆天星虚影
        function f1_1(x, y, s)
            local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0, true)
            obj.img = "stone_unclear"
            obj.group = GROUP_GHOST
            obj.hscale, obj.vscale = 0.75*s, 0.75*s
            _object.set_color(obj, "mul+add", 150, 255, 255, 255)
            task.New(obj, function()
                egg.SimSizeCh(obj, 0.75*s, 1.5*s, 20)
                egg.SimAlpCh(obj, 150, 0, 20)
                task.Wait(20)
                Del(obj)
            end)
        end
        --生成一圈石头
        function f2(r, a)
            PlaySound("kira00")
            local a0, dx, dy
            --生成一圈大石头
            for i = 1, 16 do
                a0 = a + 22.5*i
                dx, dy = self.x + r*cos(a0), self.y + r*sin(a0)
                if Dist(dx, dy, player.x, player.y) > 30 then
                    f2_1(dx, dy, 0.5 + ran:Float(-0.05, 0.05), a0 + 180)
                end
            end
            --生成小石头
            for i = 1, 20 do
                a0 = a + 18*i
                dx, dy = self.x + r*cos(a0), self.y + r*sin(a0)
                if Dist(dx, dy, player.x, player.y) > 30 then
                    f2_2(dx, dy, 1 + ran:Float(-0.25, 0.25), a0 + 180 + ran:Float(-5, 5))
                end
            end
        end
        --大石头
        function f2_1(x, y, v, a)
            local obj = stg.newBulletStraight(stg.star_big, 1, true, x, y, 0, ran:Float(0, 360), true)
            --obj.img = "stone_big"
            obj.bound = false
            obj.omiga = 3
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
        --小石头
        function f2_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.star_small, 9, true, x, y, 0, ran:Float(0, 360), true)
            --obj.img = "stone_mid"
            obj.bound = false
            obj.omiga = 3
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
        --地爆天星套娃石头
        function f3(x, y, v, a, s)
            local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, ran:Float(0, 360), true)
            obj.img = "stone_unclear"
            obj.timer = 11
            obj.x, obj.y = x, y
            local size
            if s == 1 then
                size = 0.75
                _object.set_color(obj, "", 255, 255, 255, 255)
            elseif s == 2 then
                size = 0.45
                _object.set_color(obj, "", 255, 255, 255, 255)
            elseif s == 3 then
                size = 0.325
                _object.set_color(obj, "", 255, 255, 255, 255)
            elseif s == 4 then
                size = 0.2
                _object.set_color(obj, "", 255, 255, 255, 255)
            end
            obj.hscale, obj.vscale = 0.25*size, 0.25*size
            obj.a, obj.b = 36*size, 36*size
            obj.rot = ran:Float(0, 360)
            obj.omiga = 2
            task.New(obj, function()
                egg.SimSizeCh(obj, 0.25*size, 0.45*size, 15, true)
                task.Wait(15)
                SetV(obj, v, a)
                while true do
                    while (obj.x < 192 - obj.a) and (obj.x > -192 + obj.a) and (obj.y < 224 - obj.b) and (obj.y > -224 + obj.b) do
                        task.Wait(1)
                    end
                    a = a + 180 + ran:Float(-5, 5)
                    if s == 1 then
                        for i = -1, 1, 2 do
                            f3(obj.x, obj.y, 1.25, a + 60*i, s + 1)
                        end
                        New(tasker, function()
                            local x, y = obj.x, obj.y
                            for i = 0, 2 do
                                f1_1(x, y, 0.5 + 0.2*i)
                                task.Wait(1)
                            end
                        end)
                        f4(obj.x, obj.y, 12, 15)
                        --misc.ShakeScreen(10, 5)
                        Del(obj)
                    elseif s == 2 then
                        for i = -1, 1 do
                            f3(obj.x, obj.y, 1.5, a + 60*i, s + 1)
                        end
                        New(tasker, function()
                            local x, y = obj.x, obj.y
                            for i = 0, 2 do
                                f1_1(x, y, 0.4 + 0.15*i)
                                task.Wait(1)
                            end
                        end)
                        f4(obj.x, obj.y, 6, 9)
                        --misc.ShakeScreen(10, 5)
                        Del(obj)
                    elseif s == 3 then
                        for i = -1, 1 do
                            f3(obj.x, obj.y, 1.75, a + 60*i, s + 1)
                        end
                        New(tasker, function()
                            local x, y = obj.x, obj.y
                            for i = 0, 2 do
                                f1_1(x, y, 0.3 + 0.125*i)
                                task.Wait(1)
                            end
                        end)
                        f4(obj.x, obj.y, 4, 6)
                        --misc.ShakeScreen(10, 5)
                        Del(obj)
                    elseif s == 4 then
                        SetV(obj, v, a)
                    end
                    task.Wait(1)
                end
            end)
        end
        --石头撞墙产生弹幕
        function f4(x, y, way0, way1)
            PlaySound("kira00")
            local a, a0, da, dx, dy = ran:Float(0, 360)
            --生成一圈大石头
            da = 360/way0
            for i = 1, way0 do
                a0 = a + da*i
                for j = 0, 1 do
                    f2_1(x, y, 1 + ran:Float(-0.05, 0.05) + 0.5*j, a0 + 180)
                end
            end
            --生成小石头
            da = 360/way1
            for i = 1, way1 do
                a0 = a + da*i
                for j = 0, 1 do
                    f2_2(x, y, 1 + ran:Float(-0.25, 0.25) + 0.5*j, a0 + 180 + ran:Float(-5, 5))
                end
            end
        end
        --boss地爆天星蓄力时发的弹幕
        function f5(x, y, layer)
            for i = 1, layer do
                for j = 1, 18 do
                    stg.newBulletStraight(stg.ball_big, 16, true, x, y, 2 + 0.5*i, 20*j + 10*i)
                    stg.newBulletStraight(stg.ball_mid, 16, true, x, y, 2 + 0.5*i, 20*j + 10*(i + 1))
                end
            end
        end
    end

    do
        self.minFps(45)
        s7_boss.pic_show()
        task.Wait(90)
        self:cast(600)
        eff(self.x,  self.y, 60)
        local r, a = 60, ran:Float(0, 360)
        for _ = 1, 6 do
            f2(r, a)
            r = r + 60
            a = a + 5
            task.Wait(15)
        end
        f1()
        --boss半透明，取消判定
        task.New(self, function()
            task.Wait(60)
            self.colli = false
            egg.SimAlpCh(self, 255, 100, 60)
        end)
        for _ = 1, 10 do
            f2(r, a)
            a = a + 5
            task.Wait(45)
        end
        for _ = 1, 6 do
            f2(r, a)
            a = a + 5
            task.Wait(15)
        end
        task.Wait(270)
        --[[for _ = 1, 5 do
            eff(self.x, self.y, 60)
            self.addTimes(120)
            task.Wait(120)
        end]]
    end
end
table.insert(scs, {boss_sc8, boss_sc8_normal_show, boss_sc8_scpr_show})

--原六boss五符，打算挪到ex里
--九符
local function boss_sc9_normal_show(self)
    self.colli = true
    egg.SimAlpCh(self, 100, 255, 60)
    task.Wait(30)
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
end
local function boss_sc9_scpr_show(self)
    boss_scpr_show(self, 0, 100)
end
local function boss_sc9(self)
    local f1, f1_1, f1_2, f2, f2_1, f2_2, f3
    do
        --仅仅左右运动的使魔
        function f1()
            local obj = stg.newBulletStraight(stg.ball_mid_c, 1, true, 0, 100, 0, 0, true)
            obj.hide = true
            obj.bound = false
            task.New(obj, function()
                local a, da = 22.5, 0
                --封位
                for _ = 1, 15 do
                    for i = 1, 8 do
                        f1_1(obj.x, obj.y, 45*i + a)
                        f1_2(obj.x, obj.y, 45*i + a)
                    end
                    PlaySound("tan00")
                    task.Wait(4)
                end
                --开始摆动
                for _ = 1, 20 do
                    for i = 1, 8 do
                        f1_1(obj.x, obj.y, 45*i + a)
                        f1_2(obj.x, obj.y, 45*i + a)
                    end
                    PlaySound("tan00")
                    task.Wait(4)
                    da = da + 0.15
                    a = a + da
                end
                --循环摇摆
                da = -da
                while true do
                    for _ = 1, 20 do
                        for i = 1, 8 do
                            f1_1(obj.x, obj.y, 45*i + a)
                            f1_2(obj.x, obj.y, 45*i + a)
                        end
                        PlaySound("tan00")
                        task.Wait(4)
                        a = a + da
                    end
                    da = -da
                end
            end)
        end
        function f1_1(x, y, a)
            local obj = stg.newBulletStraight(stg.water_drop, 5, true, x, y, 0, a, true)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, 6, a, 20)
            --obj.img = "stone_big"
            --obj.omiga = 6
            --obj.navi = true
        end
        function f1_2(x, y, a)
            local obj = stg.newBulletStraight(stg.water_drop, 3, true, x, y, 0, a, true)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, 8, a, 20)
            --obj.img = "stone_huge"
            --obj.hscale, obj.vscale = 0.5, 0.5
            --obj.a, obj.b = obj.hscale*obj.a, obj.vscale*obj.b
            --obj.omiga = 6
            --obj.navi = true
        end
        function f2(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_light, 10, false, x, y, 4, a)
            obj.group = GROUP_GHOST
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.bound = false
            task.New(obj, function()
                task.Wait(120)
                obj.bound = true
            end)
            task.New(obj, function()
                for _ = 1, 5 do
                    f2_1(obj.x, obj.y)
                    task.Wait(15)
                end
            end)
        end
        function f2_1(x, y)
            local obj = stg.newBulletStraight(stg.ball_light, 10, false, x, y, 0, 0)
            obj.group = GROUP_GHOST
            obj.bound = false
            obj.timer = 11
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 90, 45)
            egg.SimSizeCh(obj, 0, 6, 45)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                task.Wait(120)
                egg.SimAlpCh(obj, 90, 0, 60)
                task.Wait(60)
                Del(obj)
            end)
        end
        function f2_2(x, y)
            local obj = stg.newBulletStraight(stg.ball_light, 10, false, x, y, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.bound = false
            obj.timer = 11
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 90, 45)
            egg.SimSizeCh(obj, 0, 4, 45)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+2
            end)
        end
        --石头
        function f3(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 10, false, x, y, v, a, true)
            obj.img = "stone_mid"
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = 8, 8
            obj.omiga = 6
        end
    end

    do
        --self.x, self.y = 0, 100
        s7_boss.pic_show()
        eff(self.x, self.y, 60)
        self.colli = false
        egg.SimAlpCh(self, 255, 100, 60)
        task.Wait(90)
        --这才是主体攻击
        task.New(self, function ()
            local frame, way, a, da = 20, 6
            task.Wait(180)
            f1()
            task.Wait(360)
            eff(self.x, self.y, 60)
            --偶数弹攻击频率改变
            task.New(self, function()
                for _ = 1, 3 do
                    task.Wait(320)
                    eff(self.x, self.y, 60)
                    frame = frame - 5
                    way = way + 1
                end
            end)
            --偶数弹出现
            while true do
                da = 360/way
                a = Angle(self, player) - 0.5*da
                for i = 1, way do
                    stg.newBulletStraight(stg.ellipse, 10, false, self.x, self.y, 1.55, a + da*i, true)
                    stg.newBulletStraight(stg.ellipse, 9, false, self.x, self.y, 1.65, a + da*i, true)
                end
                PlaySound("kira00")
                task.Wait(frame)
            end
        end)

        do
            local a
            for i = 1, 8 do
                a = 45*i
                f2(400*cos(a), -50 + 400*sin(a), a + 170)
                f2(400*cos(a), -50 + 400*sin(a), a + 190)
            end
            PlaySound("kira00")
            task.Wait(120)
            --偷偷在四周都布满光玉
            do
                local x, dx, y, dy = -245, 490/11, -270, 540/13
                for _ = 1, 12 do
                    f2_2(x, 260)
                    f2_2(x, -260)
                    x = x + dx
                end
                for _ = 1, 14 do
                    f2_2(-240, y)
                    f2_2(240, y)
                    y = y + dy
                end
            end
            task.Wait(1200)
            eff(self.x, self.y, 60)
            local dx, dy
            --眩晕强化
            task.New(self, function()
                local r, a, da, t = 0, 0, 0.5, 0
                for _ = 1, 600 do
                    r = r + 0.05
                    a = a + da
                    dx, dy = r*(cos(a) - cos(a-1)), r*(sin(a) - sin(a-1))
                    task.Wait(1)
                end
                eff(self.x, self.y)
                for _ = 1, 1200 do
                    r = r + 0.025
                    da = da + 0.0004
                    a = a + da
                    dx, dy = r*(cos(a) - cos(a-1)), r*(sin(a) - sin(a-1))
                    if t > 120 and t%60 == 1 then
                        PlaySound("kira00")
                        for i = 1, 12 do
                            f3(self.x, self.y, 1.5, a + 30*i)
                            --stg.newBulletStraight(stg.water_drop, 4, false, self.x, self.y, 1.5, a + 30*i, true)
                        end
                    end
                    --self.addTimes(1)
                    task.Wait(1)
                    t = t + 1
                end
                while true do
                    a = a + 1
                    dx, dy = r*(cos(a) - cos(a-1)), r*(sin(a) - sin(a-1))
                    if t%60 == 1 then
                        PlaySound("kira00")
                        for i = 1, 12 do
                            --stg.newBulletStraight(stg.water_drop, 4, false, self.x, self.y, 1.5, a + 30*i, true)
                            f3(self.x, self.y, 1.5, a + 30*i)
                        end
                    end
                    --self.addTimes(1)
                    task.Wait(1)
                    t = t + 1
                end
            end)
            --更新boss，子弹的位置
            task.New(self, function()
                while true do
                    for _, o in ObjList(GROUP_ENEMY_BULLET) do
                        o.x, o.y = o.x + dx, o.y + dy
                    end
                    for _, o in ObjList(GROUP_INDES) do
                        o.x, o.y = o.x + dx, o.y + dy
                    end
                    self.x, self.y = self.x + dx, self.y + dy
                    task.Wait(1)
                end
            end)
        end
    end
end
table.insert(scs, {boss_sc9, boss_sc9_normal_show, boss_sc9_scpr_show})

--终符
local function boss_sc10_normal_show(self)
    self.colli = true
    egg.SimAlpCh(self, 100, 255, 60)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc10_scpr_show(self)
    boss_scpr_show(self, 0, 120)
end
local function boss_sc10(self)
    local p1, p2, p3, p4, f1, f2, f3, f4
    do
        --[[function p1()
            local obj = stg.newBulletStraight(stg.ball_mid, 1, true, 0, 0, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.hide = true
            task.New(obj, function()
                local a
                for i = 1, 4 do
                    for _ = 1, i do
                        a = ran:Float(85, 95)
                        for j = 1, 80 do
                            --stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 5, a + 2.4*j)
                            f2(self.x, self.y, 4, a + 4.5*j)
                        end
                        PlaySound("tan00")
                        task.Wait(10)
                    end
                    task.Wait(20)
                    self.addTimes(60)
                    task.Wait(50)
                end
                while IsValid(self) do
                    for u = -1, 1, 2 do
                        for _ = 1, 4 do
                            a = ran:Float(85, 95)
                            for j = 1, 80 do
                                --stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 5, a + 2.4*j)
                                f2(self.x, self.y, 4, a + 4.5*j)
                            end
                            PlaySound("tan00")
                            task.Wait(10)
                        end
                        task.Wait(20)
                        self.addTimes(60)
                        task.Wait(50)
                    end
                end
                Del(obj)
            end)
            return obj
        end]]
        function p1()
            local obj = stg.newBulletStraight(stg.ball_mid, 1, true, 0, 0, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.hide = true
            task.New(obj, function()
                local a
                local la1, la2 = 1, 1
                while IsValid(self) do
                    for u = -1, 1, 2 do
                        a = ran:Float(85, 95)
                        for i = 0, la1 do
                            for j = 1, 30 do
                                --stg.newBulletStraight(stg.ball_big, 6, true, self.x, self.y, 3.5 - 0.75*i, a + 6 + 12*j - 4*i*u)
                                f3(self.x, self.y, 3.5 - 0.75*i, a + 6 + 12*j - 4*i*u)
                            end
                        end
                        for _ = 1, la2 do
                            a = ran:Float(85, 95)
                            for j = 1, 60 do
                                --stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 5, a + 2.4*j)
                                f2(self.x, self.y, 4.5, a + 6*j)
                            end
                            PlaySound("tan00")
                            task.Wait(10)
                        end
                        task.Wait(20)
                        self.addTimes(50, 2)
                        task.Wait(50)
                        la1 = min(3, la1+1)
                        la2 = min(4, la2+1)
                    end
                end
                Del(obj)
            end)
            return obj
        end
        function f1(x, y, v, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 6, true, x, y, v, a, true)
        end
        function f2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 10, true, x, y, v, a, true)
            obj.timer = 11
            --obj.img = "stone_mid"
            obj.omiga = 3
        end
        function f3(x, y, v, a)
            local obj = stg.newBulletStraight(stg.star_big, 1, true, x, y, v, a)
            obj.timer = 11
            --obj.img = "stone_big"
            obj.omiga = 3
        end
        function f4(x, y, v, a)
            local obj = stg.newBulletStraight(stg.water_drop, 5, true, x, y, v, a, true)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
            end)
        end
        function p2()
            local obj = stg.newBulletStraight(stg.ball_mid, 1, true, 0, 0, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.hide = true
            task.New(obj, function()
                local a
                while IsValid(self) do
                    for u = -1, 1, 2 do
                        --a = ran:Float(0, 360)
                        a = ran:Float(85, 95)
                        for j = 1, 60 do
                            --stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 5, a + 2.4*j)
                            f2(self.x, self.y, 4, a + 6*j)
                        end

                        for i = 0, 2 do
                            for j = 1, 30 do
                                --stg.newBulletStraight(stg.ball_big, 6, true, self.x, self.y, 4 - 0.5*i, a + 6 + 12*j - 4*i*u)
                                --f1(self.x, self.y, 4 + 0.2*i, a + (12*j + 0.9*i)*u)
                                f3(self.x, self.y, 3.5 - 0.6*i, a + 6 + 12*j - 4*i*u)
                            end
                        end

                        for i = 1, 15 do
                            for j = 1, 30 do
                                f1(self.x, self.y, 4 + 0.2*i, a + (12*j + 0.9*i)*u)
                            end
                            PlaySound("tan00")
                            task.Wait(3)
                        end
                        task.Wait(15)
                        self.addTimes(35, 2)
                        task.Wait(30)
                    end
                end
                Del(obj)
            end)
            return obj
        end
        function p3()
            local obj = stg.newBulletStraight(stg.ball_mid, 1, true, 0, 0, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.hide = true
            --一圈圈小玉
            task.New(obj, function()
                local a
                while IsValid(self) do
                    a = ran:Float(85, 95)
                    for j = 1, 60 do
                        f2(self.x, self.y, 2, a + 6*j)
                    end
                    PlaySound("tan00")
                    task.Wait(15)
                end
                Del(obj)
            end)
            --蓝弹
            task.New(obj, function()
                local a, k = 0, 1
                while IsValid(self) do
                    for u = -1, 1, 2 do
                        for i = 0, 5 do
                            for j = 1, 20 do
                                f1(self.x, self.y, 2 + 0.075*i, a + (18*j + 1*i)*u + 2*k)
                            end
                            PlaySound("tan00")
                            task.Wait(3)
                        end
                        task.Wait(9)
                        k = k + 1
                    end
                end
            end)
            --随机中玉
            task.New(obj, function()
                local a
                while IsValid(self) do
                    for u = -1, 1, 2 do
                        a = ran:Float(0, 360)
                        for j = 1, 30 do
                            f3(self.x, self.y, 2 + ran:Float(-0.05, 0.05), a + 6 + 12*j)
                        end
                        PlaySound("kira00")
                        task.Wait(30)
                    end
                end
            end)
            return obj
        end
        function p4()
            local obj = stg.newBulletStraight(stg.ball_mid, 1, true, 0, 0, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.hide = true
            --一圈圈小玉
            task.New(obj, function()
                local a, a0
                while IsValid(self) do
                    a = ran:Float(85, 95)
                    for j = 1, 36 do
                        a0 = a + 10*j
                        for u = -1, 1, 2 do
                            f2(self.x + 30*cos(a0), self.y + 30*sin(a0), 2.5, a0 + 90*u)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(15)
                end
                Del(obj)
            end)
            --蓝弹
            task.New(obj, function()
                local a, k, a0 = 0, 1
                while IsValid(self) do
                    for u = -1, 1, 2 do
                        for i = 0, 5 do
                            for j = 1, 24 do
                                a0 = a + (15*j + 1*i)*u + 2*k
                                f1(self.x + 30*cos(a0), self.y + 30*sin(a0), 2 + 0.075*i, a0 + 120*u)
                            end
                            PlaySound("tan00")
                            task.Wait(3)
                        end
                        task.Wait(9)
                        k = k + 1
                    end
                end
            end)
            --随机中玉
            task.New(obj, function()
                local a
                while IsValid(self) do
                    for u = -1, 1, 2 do
                        a = ran:Float(0, 360)
                        for j = 1, 30 do
                            f3(self.x, self.y, 2 + ran:Float(-0.05, 0.05), a + 6 + 12*j)
                        end
                        PlaySound("kira00")
                        task.Wait(30)
                    end
                end
            end)
            return obj
        end
    end

    do
        self.minFps(45)
        s7_boss.pic_show()
        task.Wait(90)
        eff(self.x,  self.y, 60)
        local bullet_spawner
        --p1
        do
            bullet_spawner = p1()
            while self.hp > 0.8*self.maxhp and self.timer < 30*60 do
                task.Wait(1)
            end
            if IsValid(bullet_spawner) then Del(bullet_spawner) end
            PlaySound("tan00")
            clearAllBullet()
            self.reFresh()
            eff(self.x, self.y, 60)
        end
        --p2
        do
            self.minFps(45)
            bullet_spawner = p2()
            while self.hp > 0.6*self.maxhp and self.timer < 60*60 do
                task.Wait(1)
            end
            if IsValid(bullet_spawner) then Del(bullet_spawner) end
            PlaySound("tan00")
            clearAllBullet()
            self.reFresh()
            eff(self.x, self.y, 60)
        end
        --p3
        do
            self.dmgrate = 0.1
            self.minFps(45)
            for _ = 1, 3 do
                eff(self.x, self.y, 20)
            end
            misc.ShakeScreen(60, 5)
            task.Wait(40)
            for i = 0, 6 do
                for j = 1, 30 do
                    f3(self.x, self.y, 6 - 0.5*i + ran:Float(-0.15, 0.15), ran:Float(-6, 6) + 6 + 12*j - 4*i)
                end
            end
            task.Wait(20)
            bullet_spawner = p3()
            task.New(self, function()
                task.Wait(90)
                self.dmgrate = 1
            end)
            self.addTimes(1)
            while self.hp > 0.35*self.maxhp and self.timer < 90*60 do
                self.addTimes(1)
                task.Wait(1)
            end
            if IsValid(bullet_spawner) then Del(bullet_spawner) end
            PlaySound("tan00")
            clearAllBullet()
            self.reFresh()
            --eff(self.x, self.y, 60)
        end
        --p4
        do
            self.dmgrate = 0.1
            self.minFps(45)
            bullet_spawner = p4()
            task.Wait(60)
            self.dmgrate = 1
            self.addTimes(1)
            while true do
                self.addTimes(1)
                task.Wait(1)
            end
        end
    end
end
table.insert(scs, {boss_sc10, boss_sc10_normal_show, boss_sc10_scpr_show})


-- 创建一个 boss 类
local function create_boss_class(class_name, group_name)
    local cls = Class(boss)
    _editor_class[class_name] = cls
    cls.cards = {}
    cls._name = class_name
    cls.name = "Iwabuchi"
    cls.bgm = "s7_boss"
    cls._bg = function() return stage7_background end
    cls.difficulty = group_name
    function cls:init(cards)
        boss.init(self, 224, 256, "Iwabuchi", cards, New(s7_boss.scbg), group_name)
        lstg.wis.Iwabuchi(self)
    end
    return cls
end
-- 创建一个符卡
local function create_card_class(index, name, timet, hp, dropt, mode, advance)
    if mode == "normal" then
        local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
        _sc.perform = advance
        function _sc:init()
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
        return _sc
    elseif mode == "spellcard" then
        local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, true, mode)
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            self.reFresh()
            bkeff(self.x, self.y)
        end
        return _sc
    end
    --table.insert(boss_class.cards, _sc)
    --table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, advance })
end
-- 创建一个符卡练习
local function create_cardpr_class(index, name, timet, hp, dropt, mode, boss_class)
    local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, true, mode)
    _sc.perform = true
    if mode == "normal" then
        function _sc:init()
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            bkeff(self.x, self.y)
            self.reFresh()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    end
    table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards+1, true })
    --table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, advance })
    return _sc
end
-- 创建一个正常的演出
local function create_normal_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][2](self)
            elseif mode == "spellcard" then
                scs[index][2](self)
            end
        end)
    end
    return _show
end
-- 创建一个符卡练习的演出
local function create_scpr_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][3](self)
            elseif mode == "spellcard" then
                scs[index][3](self)
            end
        end)
    end
    return _show
end

--符卡相关信息定义
local card_info = {
    {"常规攻击1", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"祀符「薄命者垂怜」", {2, 5, 60}, 2000, {25,25,50}, "spellcard", false},
    {"常规攻击2", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"命符「木花移落的诅咒」", {2, 5, 80}, 3000, {25,25,50}, "spellcard", false},
    {"常规攻击3", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"源符「信浓的山葵」", {2, 5, 60}, 2400, {25,25,50}, "spellcard", false},
    {"常规攻击4", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"姊神「凭依富士的信仰」", {2, 10, 60}, 2500, {25,25,50}, "spellcard", false},
    {"常规攻击5", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"永苦「织姬渊的遗恨」", {6, 15, 60}, 2500, {25,25,50}, "spellcard", false},
    {"常规攻击6", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"生符「侘向近道论」", {2, 15, 60}, 3000, {25,25,50}, "spellcard", false},
    {"常规攻击7", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"变石「风雨千年，磐石亦转」", {2, 15, 60}, 2000, {25,25,50}, "spellcard", false},
    {"常规攻击8", {2, 6, 40}, 900, {0,0,0}, "normal", false},
    {"时魔法「Exponential Entropy」", {30, 30, 30}, 1500, {25,25,50}, "spellcard", false},
    {"「人生无常，柳枝何需惆」", {60, 60, 60}, 1500, {25,25,50}, "spellcard", false},
    {"石符「无拘无待的不二之神」", {2, 2, 120}, 5000, {0,0,0}, "spellcard", false},
}
--boss定义
local stage7boss
do
    stage7boss = create_boss_class("stage7boss", "Extra")
    stage7boss.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage7boss.cards
    for index = 1, 8 do
        info = card_info[i]
        table.insert(stage7boss.cards, create_normal_show_class(index, info[5]))
        table.insert(stage7boss.cards, create_card_class(index, info[1], info[2], info[3], info[4], info[5], info[6]))
        i = i + 1
        info = card_info[i]
        table.insert(stage7boss.cards, create_normal_show_class(index, info[5]))
        table.insert(stage7boss.cards, create_card_class(index, info[1], info[2], info[3], info[4], info[5], info[6]))
        i = i + 1
    end
    --最后两张卡
    for index = 9, 10 do
        info = card_info[i]
        table.insert(stage7boss.cards, create_normal_show_class(index, info[5]))
        table.insert(stage7boss.cards, create_card_class(index, info[1], info[2], info[3], info[4], info[5], info[6]))
        i = i + 1
    end

    local _sc
    _sc = stage7boss.cards[n+32] --定位到第一张时符，不需要爆炸效果，同时boss重新有判定
    function _sc:del()
        self.colli = true
        self._wisys:setAction("normal")
    end
    _sc = stage7boss.cards[n+34] --定位到第二张时符，不需要爆炸效果，同时boss重新有判定
    function _sc:del()
        self.colli = true
        self._wisys:setAction("normal")
    end
    _sc = stage7boss.cards[n+36]  --定位到终符，不需要爆炸效果，爆炸效果额外弄
    function _sc:del()
        self.reFresh()
        self._wisys:setAction("normal")
    end
    --最后boss的爆炸演出
    do
        local _tmp_sc = boss.dialog.New(true)
        function _tmp_sc:init()
            player.dialog=false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                lstg.var.timeslow = 2
                move_rd(60, self.y, 20)
                PlaySound("enep00")
                misc.ShakeScreen(60, 5)
                for _ = 1, 3 do
                    bkeff(self.x, self.y)
                    task.Wait(10)
                end
                lstg.var.timeslow = nil
                item.DropItem(self.x, self.y, {0, 0, 100})
                Del(self)
            end)
        end
        table.insert(stage7boss.cards,_tmp_sc)
    end
    --防止boss直接自爆的工具非
    do
        local _tmp_sc = boss.card.New("", 2, 4, 40, 900, {0,0,0}, false)
        function _tmp_sc:init()
        end
        function _tmp_sc:del()
        end
        _tmp_sc.perform=false
        table.insert(stage7boss.cards,_tmp_sc)
    end
end
_editor_class["stage7boss"] = stage7boss

--符卡练习定义
local stage7bossScpr
do
    stage7bossScpr = create_boss_class("stage7bossScpr", "Extra")
    stage7bossScpr.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage7bossScpr.cards
    --exboss比较特殊，手动插入
    for index = 1, 8 do
        info = card_info[i]
        table.insert(stage7bossScpr.cards, create_scpr_show_class(index, info[5]))
        table.insert(stage7bossScpr.cards, create_cardpr_class(index, info[1], info[2], info[3], info[4], info[5], stage7bossScpr))
        i = i + 1
        info = card_info[i]
        table.insert(stage7bossScpr.cards, create_scpr_show_class(index, info[5]))
        table.insert(stage7bossScpr.cards, create_cardpr_class(index, info[1], info[2], info[3], info[4], info[5], stage7bossScpr))
        i = i + 1
    end
    --最后两张卡
    for index = 9, 10 do
        info = card_info[i]
        table.insert(stage7bossScpr.cards, create_scpr_show_class(index, info[5]))
        table.insert(stage7bossScpr.cards, create_cardpr_class(index, info[1], info[2], info[3], info[4], info[5], stage7bossScpr))
        i = i + 1
    end

    local _sc
    _sc = stage7bossScpr.cards[n+36]  --定位到终符，不需要爆炸效果，爆炸效果额外弄
    function _sc:del()
        self.reFresh()
        self._wisys:setAction("normal")
    end
    --最后boss的爆炸演出
    do
        local _tmp_sc = boss.dialog.New(true)
        function _tmp_sc:init()
            player.dialog=false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                lstg.var.timeslow = 2
                move_rd(60, self.y, 20)
                PlaySound("enep00")
                misc.ShakeScreen(60, 5)
                for _ = 1, 3 do
                    bkeff(self.x, self.y)
                    task.Wait(10)
                end
                lstg.var.timeslow = nil
                item.DropItem(self.x, self.y, {0, 0, 50})
                Del(self)
            end)
        end
        table.insert(stage7bossScpr.cards,_tmp_sc)
    end
    --防止boss直接自爆的工具非
    do
        local _tmp_sc = boss.card.New("", 2, 4, 40, 900, {0,0,0}, false)
        function _tmp_sc:init()
        end
        function _tmp_sc:del()
        end
        _tmp_sc.perform=false
        table.insert(stage7bossScpr.cards,_tmp_sc)
    end
end
_editor_class["stage7bossScpr"] = stage7bossScpr

function s7_boss.main()
    local boss = New(_editor_class["stage7boss"], _editor_class["stage7boss"].cards)
    while IsValid(boss) do
        task.Wait(1)
    end
    if EISlib.stage.canDialog() then
        task.Wait(120)
        dialog.player.playScene("StageEX_after", true)
    end
end
