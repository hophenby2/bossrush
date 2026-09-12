---=====================================
---TH00
---=====================================

local class = {}
_editor_class["TH00"] = class

local Class = Class
local boss = boss
local task = task
local enemy = enemy
local object = object
local item = item
local sp = sp
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local Angle = Angle
local IsValid = IsValid
local GROUP, LAYER = GROUP, LAYER
local SetImageState = SetImageState
local Render = Render
local lstg = lstg

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th00_0", true, 0, 0, 0, 0, -0.07, 0, "", 1, 1, function(l)
        --BOSS 战已经来到宇宙，把云层染成星云色
        l.r, l.g, l.b = 96, 132, 200
    end)
end


--============================
--道中敌机
--============================
do
    --小妖精：移动到指定位置后瞄准自机三连射，再向下离场
    class.th00_fairy = Class(enemy, {
        init = function(self, x, y, mx, my)
            enemy.init(self, 8, 10, false)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 70, 2)
                task.New(self, function()
                    for _ = 1, 3 do
                        local A = Angle(self, player)
                        for i = -1, 1 do
                            NewSimpleBullet(ball_mid, 2, self.x, self.y, 2, A + i * 12)
                        end
                        PlaySound("tan00", 0.05, self.x / 200, true)
                        task.Wait(40)
                    end
                end)
                object.ChangingV(self, 0, 2.4, -90, 60, false)
                task.Wait(180)
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 2, self.x, self.y)
        end
    })

    --编队妖精：斜向切入后停留，打出一圈弹幕再从上方离场
    class.th00_wave = Class(enemy, {
        init = function(self, x, y, mx, my, a)
            enemy.init(self, 9, 40, false)
            self.x, self.y = x, y
            self.protect = true
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                self.protect = false
                for w = 1, 2 do
                    for b in sp.math.AngleIterator(a, 10) do
                        NewSimpleBullet(ball_mid_c, 3, self.x, self.y, 1.5, b + w * 5)
                    end
                    PlaySound("tan00", 0.06, 0, true)
                    task.Wait(50)
                end
                object.ChangingV(self, 0, 4, 90, 90, false)
                task.Wait(120)
                if IsValid(self) then
                    object.RawDel(self)
                end
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 5, self.x, self.y)
        end
    })

    --中型妖精：中央停留，环形弹幕，再从上方离场
    class.th00_mid = Class(enemy, {
        init = function(self, x, y, mx, my, a)
            enemy.init(self, 12, 150, false)
            self.x, self.y = x, y
            self.protect = true
            task.New(self, function()
                task.MoveTo(mx, my, 80, 2)
                self.protect = false
                for w = 1, 3 do
                    for b in sp.math.AngleIterator(a + w * 20, 14) do
                        NewSimpleBullet(ball_mid, 5, self.x, self.y, 1.8, b)
                    end
                    PlaySound("kira00", 0.08, 0, true)
                    task.Wait(60)
                end
                task.Wait(60)
                object.ChangingV(self, 0, 4, 90, 90, false)
                task.Wait(120)
                if IsValid(self) then
                    object.RawDel(self)
                end
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 8, self.x, self.y)
        end
    })
end


--============================
--大气层预设弹
--  * 与背景云层严格同速下坠，看起来像钉在天空中
--  * 透明度跟背景一致：背景（云层）淡出，子弹跟着淡出
--  * 透明度 >= 50 时在 GROUP.INDES 里有判定（会撞自机，但打不掉），
--    低于 50 自动关掉碰撞，透明到 0 就完全没威胁
--  * 不循环：飞出下边界即回收
--============================
class.th00_sky_bullet = Class(object, {
    init = function(self, img, x, y, size, k, a, r, g, b)
        self.img = img
        self.x, self.y = x, y
        self.group = GROUP.INDES
        self.layer = LAYER.ENEMY_BULLET - 30
        self.colli = true
        self.bound = false
        self.rot = -90
        local s = size or 1
        self.hscale, self.vscale = s, s
        self.a, self.b = 5 * s, 5 * s
        self.k = k or 1
        self._a = a or 255
        self._r, self._g, self._b = r or 255, g or 255, b or 255
        self.vy = 0
        self.alpha = 255
    end,
    frame = function(self)
        --每帧从云层读速度和透明度：背景多快子弹就多快，背景多淡子弹就多淡
        local bg = TH00_bg.current
        local speed, ba = 1.2, 255
        if bg and IsValid(bg) then
            speed, ba = bg.speed, bg.opacity
        end
        self.vy = -speed * self.k
        self.alpha = ba
        --透明到看不见了就不再有判定
        self.colli = ba >= 50
        --不循环：飞出下边界就回收
        if self.y < lstg.world.boundb - 90 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        SetImageState(self.img, "mul+add", self._a * self.alpha / 255, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    end
})

boss.Define("1a", "未命名Boss", "TH00_0", TH00_bg, { 0, 300 }, class["SCBG1"], "Rumia", 20)
do
    local non1 = boss.card.New("", 1, 1, 60, 600)
    boss.card.add({ { non1, "1a" } }, 20, "非符一", 243)
    function non1:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function non1:init()
        task.New(self, function()
            task.Wait(60)
        end)
    end
end

--============================
--宇宙主题符卡
--  * 不使用引擎的 3D 渲染（Render4V / SetViewMode "3d"）
--    全部在 world 视图下用 2D 绘制 + 纯 Lua 旋转矩阵模拟三维投影
--  * 3x3 行主序矩阵：M[1..9]
--============================
do
    local D2R = math.pi / 180

    ------------------------------------------------------------------
    --3x3 旋转矩阵
    ------------------------------------------------------------------
    local function mat_unit()
        return { 1, 0, 0, 0, 1, 0, 0, 0, 1 }
    end

    local function mat_mul(A, B)
        local C = {}
        for i = 0, 2 do
            local a1, a2, a3 = A[i * 3 + 1], A[i * 3 + 2], A[i * 3 + 3]
            for j = 1, 3 do
                C[i * 3 + j] = a1 * B[j] + a2 * B[j + 3] + a3 * B[j + 6]
            end
        end
        return C
    end

    --绕任意轴旋转 deg 度（罗德里格斯公式）
    local function mat_axis(ax, ay, az, deg)
        local n = sqrt(ax * ax + ay * ay + az * az)
        if n < 1e-6 then
            return mat_unit()
        end
        ax, ay, az = ax / n, ay / n, az / n
        local c, s = math.cos(deg * D2R), math.sin(deg * D2R)
        local t = 1 - c
        return {
            t * ax * ax + c,      t * ax * ay - s * az, t * ax * az + s * ay,
            t * ax * ay + s * az, t * ay * ay + c,      t * ay * az - s * ax,
            t * ax * az - s * ay, t * ay * az + s * ax, t * az * az + c,
        }
    end

    local function mat_apply(M, x, y, z)
        return M[1] * x + M[2] * y + M[3] * z,
                M[4] * x + M[5] * y + M[6] * z,
                M[7] * x + M[8] * y + M[9] * z
    end

    ------------------------------------------------------------------
    --绘制工具
    ------------------------------------------------------------------
    --加算细线（自绘，不生成激光对象）
    local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
        local len = Dist(x1, y1, x2, y2)
        if a <= 0 or len < 1 then
            return
        end
        SetImageState("white", "mul+add", a, r, g, b)
        Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
    end

    --直接画一颗星（纯装饰，无判定）
    local function draw_star(x, y, rot, scale, color, a)
        local img = "star_big" .. int(Forbid(color, 1, 16))
        SetImageState(img, "mul+add", a or 255, 255, 255, 255)
        Render(img, x, y, rot, scale, scale)
    end

    --生成一颗不会被世界边界回收的星弹（由脚本自己清理）
    local function star_bullet(style, col, x, y, v, a, omiga)
        local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga)
        o.bound = false
        task.New(o, function()
            while true do
                task.Wait(30)
                if not IsValid(o) then
                    return
                end
                if abs(o.x) > 280 or abs(o.y) > 320 then
                    object.RawDel(o)
                    return
                end
            end
        end)
        return o
    end

    ------------------------------------------------------------------
    --[符卡1] 星空之匣：三维星盒
    --  * 12 条棱边 = 粗激光（laser4 纯色贴图）
    --  * 盒内星弹用同一旋转矩阵投影到屏幕，近大远小
    --  * 部分星弹之间有细激光连线
    --  * 每隔一段时间绕随机轴旋转一定角度（=投影矩阵反向旋转），
    --    旋转过程中棱边粗激光变为半开
    ------------------------------------------------------------------
    local BOX_EDGES = {
        { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 1 },
        { 5, 6 }, { 6, 7 }, { 7, 8 }, { 8, 5 },
        { 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 },
    }
    local BOX_VERT = {
        { -1, -1, -1 }, { 1, -1, -1 }, { 1, 1, -1 }, { -1, 1, -1 },
        { -1, -1, 1 }, { 1, -1, 1 }, { 1, 1, 1 }, { -1, 1, 1 },
    }

    class["th00_starbox"] = Class(object, {
        init = function(self, r, cx, cy, nstar)
            self.r = r or 96
            self.cx, self.cy = cx or 0, cy or 50
            self.focal = self.r * 4.4
            self.bound = false
            self.colli = false
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET - 30

            self.M = mat_unit()
            self.M0 = self.M
            self.phase, self.tick, self.wait = 0, 0, 100
            self.cd = 90
            self.axis = { 0, 1, 0 }
            self.ang, self.rot_len, self.rot_t = 0, 0, 0

            --8 个顶点
            self.verts = {}
            for i = 1, 8 do
                local v = BOX_VERT[i]
                self.verts[i] = { v[1] * self.r, v[2] * self.r, v[3] * self.r }
            end
            self.proj = {}
            for i = 1, 8 do
                self.proj[i] = { self.cx, self.cy, 0, 1 }
            end

            --盒内星弹（三维坐标固定，每帧重新投影）
            self.stars = {}
            local n = nstar or 14
            local guard = 0
            while #self.stars < n and guard < 800 do
                guard = guard + 1
                local p = {
                    ran:Float(-0.82, 0.82) * self.r,
                    ran:Float(-0.82, 0.82) * self.r,
                    ran:Float(-0.82, 0.82) * self.r,
                }
                local ok = true
                for _, s in ipairs(self.stars) do
                    local dx, dy, dz = p[1] - s[1], p[2] - s[2], p[3] - s[3]
                    if dx * dx + dy * dy + dz * dz < (self.r * 0.4) ^ 2 then
                        ok = false
                        break
                    end
                end
                if ok then
                    self.stars[#self.stars + 1] = p
                end
            end

            self.starobj = {}
            for i = 1, #self.stars do
                local o = NewSimpleBullet(star_big, ran:Int(1, 16), self.cx, self.cy, 0, 0, false, 0, false, false)
                o.bound = false
                o._blend = "mul+add"
                o._a = 230
                o.hscale, o.vscale = 0.7, 0.7
                o.rot = ran:Float(0, 360)
                o._spin = ran:Float(-1.8, 1.8)
                self.starobj[i] = o
            end

            --部分星弹之间的细连线
            self.links = {}
            for i = 1, #self.stars do
                local cand = {}
                for j = 1, #self.stars do
                    if i ~= j then
                        local dx = self.stars[i][1] - self.stars[j][1]
                        local dy = self.stars[i][2] - self.stars[j][2]
                        local dz = self.stars[i][3] - self.stars[j][3]
                        cand[#cand + 1] = { j, dx * dx + dy * dy + dz * dz }
                    end
                end
                table.sort(cand, function(A, B)
                    return A[2] < B[2]
                end)
                local k = ran:Int(1, 2)
                for m = 1, k do
                    if cand[m] and cand[m][1] > i then
                        self.links[#self.links + 1] = { i, cand[m][1] }
                    end
                end
            end

            --12 条棱边：粗激光
            self.lasers = {}
            for i = 1, 12 do
                local l = New(laser, 8, self.cx, self.cy, 0, 0, 0, 0, self.r * 0.16)
                l.bound = false
                l.colli = true
                l.layer = LAYER.ENEMY_BULLET - 40
                laser.ChangeImage(l, 4)
                laser._TurnOn(l, 30, false, false)
                self.lasers[i] = l
            end
        end,
        frame = function(self)
            --旋转调度：静止 -> 随机轴旋转 -> 静止
            if self.phase == 0 then
                self.tick = self.tick + 1
                if self.tick >= self.wait then
                    self.tick = 0
                    self.phase = 1
                    self.rot_t = 0
                    self.rot_len = ran:Int(80, 130)
                    self.ang = (ran:Int(0, 1) == 0 and -1 or 1) * ran:Float(60, 150)
                    local ax, ay, az = ran:Float(-1, 1), ran:Float(-1, 1), ran:Float(-1, 1)
                    if abs(ax) + abs(ay) + abs(az) < 0.4 then
                        ax = ax + 0.8
                    end
                    self.axis[1], self.axis[2], self.axis[3] = ax, ay, az
                    self.M0 = self.M
                    --旋转过程中棱边变半开
                    for i = 1, 12 do
                        laser._TurnHalfOn(self.lasers[i], 12, false)
                    end
                end
            else
                self.rot_t = self.rot_t + 1
                local t = min(self.rot_t / self.rot_len, 1)
                t = t * t * (3 - 2 * t)
                local R = mat_axis(self.axis[1], self.axis[2], self.axis[3], self.ang * t)
                self.M = mat_mul(R, self.M0)
                if self.rot_t >= self.rot_len then
                    self.phase = 0
                    self.wait = ran:Int(70, 130)
                    --旋转结束恢复满开
                    for i = 1, 12 do
                        laser._TurnOn(self.lasers[i], 12, false, false)
                    end
                end
            end

            --投影 8 个顶点
            local M, f, cx, cy = self.M, self.focal, self.cx, self.cy
            local proj = self.proj
            for i = 1, 8 do
                local v = self.verts[i]
                local x, y, z = mat_apply(M, v[1], v[2], v[3])
                local k = f / (f + z)
                local p = proj[i]
                p[1], p[2], p[3], p[4] = cx + x * k, cy + y * k, z, k
            end

            --12 条棱边跟随投影端点
            for i = 1, 12 do
                local e = BOX_EDGES[i]
                local p1, p2 = proj[e[1]], proj[e[2]]
                local l = self.lasers[i]
                l.x, l.y = p1[1], p1[2]
                l.rot = Angle(p1[1], p1[2], p2[1], p2[2])
                l.l1, l.l2, l.l3 = 0, Dist(p1[1], p1[2], p2[1], p2[2]), 0
            end

            --星弹按同一矩阵投影
            for i = 1, #self.stars do
                local o = self.starobj[i]
                if IsValid(o) then
                    local v = self.stars[i]
                    local x, y, z = mat_apply(M, v[1], v[2], v[3])
                    local k = f / (f + z)
                    local s = k * 0.52
                    o.x, o.y = cx + x * k, cy + y * k
                    o.hscale, o.vscale = s, s
                    o.rot = o.rot + o._spin
                    o.layer = LAYER.ENEMY_BULLET - 20 + (self.r - z) / (2 * self.r) * 8
                end
            end

            --盒内星弹每隔一段时间反击
            self.cd = self.cd - 1
            if self.cd <= 0 then
                self.cd = ran:Int(35, 55)
                local o = self.starobj[ran:Int(1, #self.starobj)]
                if IsValid(o) then
                    local base = Angle(o.x, o.y, player.x, player.y)
                    for k = -1, 1 do
                        NewSimpleBullet(star_small, 14, o.x, o.y, 2.6, base + k * 16, false, 0)
                    end
                    PlaySound("tan00", 0.04, 0, false)
                end
            end
        end,
        render = function(self)
            local links = self.links
            for i = 1, #links do
                local o1 = self.starobj[links[i][1]]
                local o2 = self.starobj[links[i][2]]
                if IsValid(o1) and IsValid(o2) then
                    thin_line(o1.x, o1.y, o2.x, o2.y, 165, 130, 205, 255, 0.18)
                end
            end
        end,
        del = function(self)
            for i = 1, #self.starobj do
                if IsValid(self.starobj[i]) then
                    object.RawDel(self.starobj[i])
                end
            end
            for i = 1, #self.lasers do
                if IsValid(self.lasers[i]) then
                    object.RawDel(self.lasers[i])
                end
            end
            self.starobj, self.lasers, self.links = {}, {}, {}
        end,
    }, true)

    do
        local card = boss.card.New("星空之匣", 1, 2, 60, 1500)
        boss.card.add({ { card, "1a" } }, 20, "星空之匣", 244)

        function card:before()
            task.MoveTo(0, 90, 60, 2)
        end

        function card:init()
            local b = self
            b.__starbox = New(class["th00_starbox"], 100, 0, 60, 14)
            task.New(b, function()
                task.Wait(70)
                while true do
                    for _ = 1, 3 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 5) do
                            NewSimpleBullet(star_big, ran:Int(1, 16), b.x, b.y, 2.3, a, false, 2.4)
                        end
                        PlaySound("tan00", 0.05, 0, true)
                        task.Wait(24)
                    end
                    task.Wait(80)
                end
            end)
        end

        function card:del()
            if IsValid(self.__starbox) then
                object.RawDel(self.__starbox)
            end
            self.__starbox = nil
        end
    end

    ------------------------------------------------------------------
    --[符卡2] 星屑回廊：旋转四臂星屑
    ------------------------------------------------------------------
    do
        local card = boss.card.New("星屑回廊", 1, 2, 45, 1200)
        boss.card.add({ { card, "1a" } }, 20, "星屑回廊", 245)

        function card:before()
            task.MoveTo(0, 90, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                local rot = ran:Float(0, 360)
                local cnt = 0
                while true do
                    cnt = cnt + 1
                    for i = 1, 6 do
                        for a in sp.math.AngleIterator(rot, 4) do
                            NewSimpleBullet(star_big, 8, b.x, b.y, 1.7 + i * 0.12, a, false, 1.3)
                        end
                        rot = rot + 9
                        task.Wait(10)
                    end
                    if cnt % 2 == 0 then
                        for a in sp.math.AngleIterator(Angle(b, player), 3) do
                            star_bullet(star_small, 16, b.x, b.y, 3.4, a, 0)
                        end
                        PlaySound("tan00", 0.05, 0, false)
                    end
                    task.Wait(30)
                end
            end)
        end
    end

    ------------------------------------------------------------------
    --[符卡3] 星座の糸：星星连线，沿连线射出星弹
    ------------------------------------------------------------------
    do
        local card = boss.card.New("星座の糸", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 20, "星座の糸", 246)

        function card:before()
            task.MoveTo(0, 135, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                for _ = 1, 6 do
                    local n = 6
                    local pts = {}
                    for i = 1, n do
                        pts[i] = { ran:Float(-185, 185), ran:Float(-130, 200) }
                    end
                    b.__const = pts
                    PlaySound("kira00", 0.08, 0, false)
                    task.Wait(70)
                    for i = 1, n do
                        local p1, p2 = pts[i], pts[i % n + 1]
                        local a = Angle(p1[1], p1[2], p2[1], p2[2])
                        for k = 1, 3 do
                            star_bullet(star_small, 8, p1[1], p1[2], 1.1 + k * 0.7, a, 0)
                            star_bullet(star_small, 14, p2[1], p2[2], 1.1 + k * 0.7, a + 180, 0)
                        end
                    end
                    PlaySound("tan00", 0.06, 0, false)
                    task.Wait(80)
                end
                b.__const = nil
            end)
        end

        function card:render()
            local pts = self.__const
            if not pts then
                return
            end
            local n = #pts
            for i = 1, n do
                local p1, p2 = pts[i], pts[i % n + 1]
                thin_line(p1[1], p1[2], p2[1], p2[2], 150, 140, 200, 255, 0.2)
                draw_star(p1[1], p1[2], self.timer * 2, 0.75, 16, 220)
            end
        end

        function card:del()
            self.__const = nil
        end
    end

    ------------------------------------------------------------------
    --[符卡4] 銀河の腕：旋臂
    ------------------------------------------------------------------
    do
        local card = boss.card.New("銀河の腕", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 20, "銀河の腕", 247)

        function card:before()
            task.MoveTo(0, 110, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                local a0 = ran:Float(0, 360)
                local t = 0
                while true do
                    t = t + 1
                    a0 = a0 + 6.5
                    for arm = 0, 2 do
                        local a = a0 + arm * 120
                        star_bullet(star_big, 7, b.x + cos(a) * 26, b.y + sin(a) * 26, 2.6, a, 0.42)
                    end
                    if t % 26 == 0 then
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 12) do
                            star_bullet(star_small, 16, b.x, b.y, 3.2, a, 0)
                        end
                        PlaySound("tan00", 0.05, 0, false)
                    end
                    task.Wait(5)
                end
            end)
        end
    end

    ------------------------------------------------------------------
    --[符卡5] 彗星の尾：横向掠过的彗星
    ------------------------------------------------------------------
    do
        local card = boss.card.New("彗星の尾", 1, 2, 45, 1200)
        boss.card.add({ { card, "1a" } }, 20, "彗星の尾", 248)

        function card:before()
            task.MoveTo(0, 150, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                for k = 1, 6 do
                    local dir = (k % 2 == 0) and 1 or -1
                    local y0 = ran:Float(-80, 170)
                    local amp = ran:Float(0, 45)
                    for t = 0, 130 do
                        local x = (0 - 215 * dir) + t * (430 / 130) * dir
                        local y = y0 + sin(t * 3.2) * amp
                        b.__comet = { x = x, y = y, t = t }
                        if t % 2 == 0 then
                            star_bullet(star_small, 12, x + ran:Float(-10, 10), y + ran:Float(-10, 10),
                                    1.1, ran:Float(0, 360), 0)
                        end
                        task.Wait(1)
                    end
                    task.Wait(24)
                end
                b.__comet = nil
            end)
        end

        function card:render()
            local c = self.__comet
            if not c then
                return
            end
            draw_star(c.x, c.y, c.t * 6, 1.5, 13, 255)
            draw_star(c.x, c.y, -c.t * 4, 0.9, 16, 200)
        end

        function card:del()
            self.__comet = nil
        end
    end

    ------------------------------------------------------------------
    --[符卡6] 超新星：蓄力后爆发
    ------------------------------------------------------------------
    do
        local card = boss.card.New("超新星", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 20, "超新星", 249)

        function card:before()
            task.MoveTo(0, 100, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                task.Wait(40)
                while true do
                    Newcharge_in(b.x, b.y, 255, 210, 140)
                    task.Wait(50)
                    PlaySound("kira00", 0.12, 0, true)
                    for w = 1, 3 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 10 + w * 5) do
                            star_bullet(star_big, 13, b.x, b.y, 4.4 - w * 0.5, a, 0)
                        end
                        task.Wait(14)
                    end
                    for a in sp.math.AngleIterator(Angle(b, player), 3) do
                        star_bullet(star_big, 2, b.x, b.y, 3.4, a, 0)
                    end
                    task.Wait(140)
                end
            end)
        end
    end

    ------------------------------------------------------------------
    --[符卡7] 黒洞の引力：星弹被中心吸引后回摆
    ------------------------------------------------------------------
    do
        local card = boss.card.New("黒洞の引力", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 20, "黒洞の引力", 250)

        function card:before()
            task.MoveTo(0, 80, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                local a0 = ran:Float(0, 360)
                while true do
                    a0 = a0 + 17
                    for a in sp.math.AngleIterator(a0, 14) do
                        local o = star_bullet(star_big, 15, b.x + cos(a) * 150, b.y + sin(a) * 150, 2.9, a, 0.4)
                        object.SetA(o, -0.05, a)
                    end
                    PlaySound("tan00", 0.05, 0, false)
                    task.Wait(46)
                end
            end)
        end
    end

    ------------------------------------------------------------------
    --[符卡8] 流星群：从上方向下倾泻
    ------------------------------------------------------------------
    do
        local card = boss.card.New("流星群", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 20, "流星群", 251)

        function card:before()
            task.MoveTo(0, 170, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                while true do
                    local n = ran:Int(24, 34)
                    for i = 1, n do
                        star_bullet(star_big, ran:Int(12, 16), ran:Float(-215, 215), 250,
                                ran:Float(3.4, 5.6), ran:Float(-118, -62), 0)
                        if i % 4 == 0 then
                            task.Wait(1)
                        end
                    end
                    for a in sp.math.AngleIterator(Angle(b, player), 5) do
                        star_bullet(star_small, 16, b.x, b.y, 2.8, a, 0)
                    end
                    PlaySound("tan00", 0.05, 0, false)
                    task.Wait(70)
                end
            end)
        end
    end

    ------------------------------------------------------------------
    --[符卡9] 星雲のゆりかご：漂浮的星云弹，一会儿裂开
    ------------------------------------------------------------------
    do
        local card = boss.card.New("星雲のゆりかご", 1, 2, 55, 1350)
        boss.card.add({ { card, "1a" } }, 20, "星雲のゆりかご", 252)

        function card:before()
            task.MoveTo(0, 120, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                while true do
                    local a0 = ran:Float(0, 360)
                    for i in sp.math.AngleIterator(a0, 9) do
                        local o = NewSimpleBullet(star_big, 4, b.x, b.y, 1.5, i, false, 0.35)
                        o.bound = false
                        task.New(o, function()
                            task.Wait(46)
                            if not IsValid(o) then
                                return
                            end
                            local ox, oy = o.x, o.y
                            for k in sp.math.AngleIterator(ran:Float(0, 360), 5) do
                                star_bullet(star_small, 3, ox, oy, 2.4, k, 0)
                            end
                            PlaySound("tan00", 0.04, 0, false)
                            object.RawDel(o)
                        end)
                    end
                    task.Wait(100)
                end
            end)
        end
    end

    ------------------------------------------------------------------
    --[符卡10] 終焉の星図：终符
    ------------------------------------------------------------------
    do
        local card = boss.card.New("終焉の星図", 1, 2, 60, 1600)
        boss.card.add({ { card, "1a" } }, 20, "終焉の星図", 253)

        function card:before()
            task.MoveTo(0, 110, 60, 2)
        end

        function card:init()
            local b = self
            task.New(b, function()
                task.Wait(30)
                local a0 = ran:Float(0, 360)
                local t = 0
                while true do
                    t = t + 1
                    a0 = a0 + 11
                    for arm = 0, 3 do
                        local a = a0 + arm * 90
                        star_bullet(star_big, 8, b.x + cos(a) * 30, b.y + sin(a) * 30, 2.8, a, 0.5)
                    end
                    for _ = 1, 2 do
                        star_bullet(star_small, 16, b.x, b.y, 3.6, Angle(b, player) + ran:Float(-28, 28), 0)
                    end
                    if t % 33 == 0 then
                        for i in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                            star_bullet(star_small, 13, b.x, b.y, 4.2, i, 0)
                        end
                        PlaySound("kira00", 0.1, 0, false)
                    end
                    task.Wait(9)
                end
            end)
        end
    end
end
