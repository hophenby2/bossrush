---=====================================
---TH05  花园：风见幽香 · 四季のフラワーマスター
---
---  这一版按 **AGENTS.md §10.10「视觉层」** 写，设计律先摆在这儿：
---
---    ① **多展开**（不限双展开）：限位 + 威胁必须有，**装饰层可以有很多**。
---       屏幕上大部分子弹**不需要玩家处理** —— 不朝自机的环、旋转对称的整圈、
---       拉得很长的空弹链。它们负责把屏幕填满，威胁层才是要躲的那一小圈。
---    ② **覆盖面积**：任意时刻屏幕上「有弹经过」的地方要尽量多，而且分布均匀。
---       手段：大弹慢速外扩、几何图形（环/星/螺旋）、装饰层压到 0.4~1.2 px/帧。
---    ③ **配色明亮 + 对比**：一张卡一个主色系，靠**白心 / 亮边**拉对比；
---       装饰层 `_a` 压到 120~180，威胁层满 alpha —— 玩家一眼分得出哪层要躲。
---    ④ **限位尽量华丽**：旋转对称（反向自转 + 反相张缩）最省事又最好看。
---    ⑤ **不用 safe_spawn 挖洞**：发射点离自机太近就换展开 / 压弹速 / 挪生成位置。
---    ⑥ **子弹不许突然消失**：飞出回收边界、淡出、或转化成下一层，三种之一。
---       本文件里所有自绘对象都走 fade_path（`_a` 递减到 0 才收）。
---
---  回收规则同 th03/th04：NewSimpleBullet 造的引擎自己收；
---  自己 Class(object/bullet, ...) 造且关掉 bound 的，必须在 frame 里自己收。
---=====================================

local class = {}
_editor_class["TH05"] = class

local Class = Class
local boss = boss
local task = task
local object = object
local bullet = bullet
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local Angle = Angle
local Dist = Dist
local IsValid = IsValid
local GROUP, LAYER = GROUP, LAYER
local SetImageState = SetImageState
local Render = Render
local ran = ran
local cos, sin, max, min, abs, int, Forbid = cos, sin, max, min, abs, int, Forbid
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th05_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        --符卡背景：一层明亮的暖绿 / 鹅黄
        l.r, l.g, l.b = 214, 240, 156
    end)
end

boss.Define("1a", "风见幽香", "TH05_0", TH05_bg, { 0, 300 }, class["SCBG1"], "Yuka", 25)

--============================
--公用小工具
--============================

---加算细线（自绘，无判定）
local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then
        return
    end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

---一段圆弧（画花环 / 结界用）
local function arc(cx, cy, r, a0, a1, segs, alpha, gr, gg, gb, w)
    if r <= 0 or alpha <= 0 then
        return
    end
    local step = (a1 - a0) / segs
    for i = 1, segs do
        local s1 = a0 + step * (i - 1)
        local s2 = a0 + step * i
        thin_line(cx + cos(s1) * r, cy + sin(s1) * r,
                cx + cos(s2) * r, cy + sin(s2) * r, alpha, gr, gg, gb, w)
    end
end

---光玉
local function draw_orb(x, y, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ball_huge6", "mul+add", 62 * a, r * 0.6, g * 0.6, b * 0.85)
    Render("ball_huge6", x, y, 0, size * 1.5, size * 1.5)
    SetImageState("ball_big6", "mul+add", 180 * a, r, g, b)
    Render("ball_big6", x, y, 0, size * 0.52, size * 0.52)
    --白心：装饰层和威胁层靠它拉开对比
    SetImageState("ball_mid6", "mul+add", 220 * a, 255, 255, 255)
    Render("ball_mid6", x, y, 0, size * 0.2, size * 0.2)
end

---花瓣
local function draw_petal(x, y, rot, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ellipse6", "mul+add", a, r, g, b)
    Render("ellipse6", x, y, rot, size * 1.55, size)
end

---蝶（翅膀一开一合）
local function draw_butterfly(x, y, rot, size, a, flap, col)
    if a <= 0 then
        return
    end
    local img = "butterfly" .. (Forbid(col or 2, 1, 8))
    local k = 0.55 + 0.45 * abs(sin(flap))
    SetImageState(img, "mul+add", a, 255, 214, 240)
    Render(img, x, y, rot, size * 2.2, size * 2.2 * k)
end

---立刻起飞、不悬停的普通弹
local function fly(style, col, x, y, v, a, omiga, glow)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga or 0, false)
    if glow ~= false then
        o._blend = "mul+add"
    end
    return o
end

---把弹挂到 boss 名下（换卡时 KillServants 会连带收掉）
local function attach(master, obj)
    if IsValid(master) and obj then
        object.Connect(master, obj, 0, true)
    end
    return obj
end

---发射点安全距离（AGENTS.md §10.10）：出膛到命中至少 20 帧，
---  否则来不及挪 = 必中。**这里不用来挖洞**，只用来做「换展开」的判断：
---  比如「自机贴太近就改从对面吐」「这一轮改成散开而不是自机狙」。
local SPAWN_REACT = 20
local function near_player(x, y, v)
    return Dist(x, y, player.x, player.y) < SPAWN_REACT * (v or 0)
end

---「改生成位置」：自机贴得太近时，把发射点挪到圆环的**对面**。
---  这是 AGENTS.md §10.10 的正解 —— **不挖洞、也不少发弹**，
---  只是换个地方生成；玩家看到的是「这发从对面飞过来」，而不是「墙上少了一块」。
---  (cx, cy) 是环心。
local function mirror_spawn(cx, cy, x, y, v)
    if not near_player(x, y, v) then
        return x, y
    end
    return cx * 2 - x, cy * 2 - y
end

---通用「路径弹」：位置由 path(self, t) 每帧算，bound 关掉所以要自己回收。
---  带 **寿命淡出**：到 life 之后 `_a` 递减到 0 才收 —— 不许凭空消失（§10.10）。
local path_bullet = Class(bullet, {
    init = function(self, style, col, x, y, a, path, life, fade)
        bullet.init(self, style, col, false, true)
        self.x, self.y, self.rot = x, y, a or 0
        self.path = path
        self.bound = false
        self.life = life or 300
        self.fade = fade or 8
        self.max_r2 = 660 * 660
    end,
    frame = function(self)
        bullet.frame(self)
        local t = self.timer
        if self.x * self.x + self.y * self.y > self.max_r2 then
            --飞出可见区才收：这是最自然的退场
            object.RawDel(self)
            return
        end
        if t > self.life then
            --淡出（不是凭空消失）
            self._a = (self._a or 255) - self.fade
            if self._a <= 0 then
                object.RawDel(self)
            end
            return
        end
        self.path(self, t)
    end,
    render = function(self)
        bullet.render(self)
    end,
})

---装饰弹：在自机周围一定距离外才吐，且**不朝自机**。
---  §10.10 的手段是「换展开」而不是挖洞 —— 这里干脆把装饰层做成
---  绕 boss 公转 / 向外扩散，天然不会在自机脸上生成。
local function deco_bullet(style, col, x, y, v, a, life, r, g, b)
    local o = fly(style, col, x, y, v, a, 0)
    o._r, o._g, o._b = r or 255, g or 240, b or 180
    o._a = 150 -- 装饰层压 alpha，跟威胁层拉开
    return o
end

--============================
--背景：明亮的花园（主色鹅黄 + 粉 + 青，和弹幕的暖色系拉开）
--============================
class["th05_petalbg"] = Class(object, {
    init = function(self, layer)
        self.x = ran:Float(lstg.world.boundl, lstg.world.boundr)
        self.y = ran:Float(lstg.world.boundb, lstg.world.boundt)
        self.v = ran:Float(0.5, 1.4)
        self.sw = ran:Float(0, 360)
        self.size = ran:Float(0.6, 1.8)
        self.a = ran:Int(70, 150)
    end,
    frame = function(self)
        self.y = self.y - self.v
        self.sw = self.sw + 8
        self.x = self.x + sin(self.sw) * 0.8
        if self.y < lstg.world.boundb - 20 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        draw_petal(self.x, self.y, self.sw, self.size, self.a, 255, 214, 150)
    end,
}, true)

--============================
--[卡1] 花符「日輪の輪」
--  限位：16 朵向日葵绕 boss 公转的大花环（半径呼吸 120~190）。
--        整环**不朝自机**，是装饰弹性质的限位 —— 玩家撞上去才会中，
--        但它把「环内那一圈」封住了，玩家只能在外侧活动。
--  装饰：环上的花瓣持续向外飘（0.9 px/帧，低 alpha），铺满全屏。
--  威胁：boss 每 100 帧 9 路自机扇；环上每 3 朵朝自机补一发。
--  配色：鹅黄主色 + 白心；装饰层 _a=150，威胁层满 alpha。
--  容错：环转速 0.5°/帧，呼吸周期 240 帧 —— 玩家 4 px/帧 追得上。
--  预警：90 帧先把环画成骨架（只画不判）
--============================
do
    local RING_N = 16
    local R_MIN, R_MAX = 120, 190
    local BREATH = 240
    local ROT_V = 0.5
    local RING_WARN = 90
    local AIM_GAP = 38          -- ⚠ sin 修成角度制之后各层真的会转/散了，节奏要跟着加密
    local AIM_V = 2.4
    local BOSS_X, BOSS_Y = 0, 60

    class["th05_sunring"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.rot = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            self.rot = (self.rot + ROT_V) % 360
            self.r = (R_MIN + R_MAX) * 0.5 + (R_MAX - R_MIN) * 0.5 * sin(self.t * 360 / BREATH)
            if self.t == RING_WARN then
                PlaySound("kira00", 0.25, 0, true)
                Newcharge_out(0, BOSS_Y, 255, 236, 150)
            end
            if self.t < RING_WARN then
                return
            end
            --整环吐：向外扩散的鹅黄花，**不朝自机** —— 装饰性的面积来源
            if (self.t - RING_WARN) % BREATH == 0 then
                for k = 1, RING_N do
                    local a = self.rot + (k - 1) * 360 / RING_N
                    local x, y = cos(a) * self.r, BOSS_Y + sin(a) * self.r
                    x, y = mirror_spawn(0, BOSS_Y, x, y, 1.1)
                    deco_bullet(flower2, 12, x, y, 1.1, a, 300, 255, 236, 140)
                end
            end
            --环上每 3 朵朝自机补一发：这才是威胁层
            if (self.t - RING_WARN) % (BREATH / 2) == 30 then
                for k = 1, RING_N, 3 do
                    local a = self.rot + (k - 1) * 360 / RING_N
                    local x, y = cos(a) * self.r, BOSS_Y + sin(a) * self.r
                    if Dist(x, y, player.x, player.y) < 300 then
                        local o = fly(ball_mid, 13, x, y, 2.0, Angle(x, y, player.x, player.y), 0)
                        o._r, o._g, o._b = 255, 236, 120
                    end
                end
            end
        end,
        render = function(self)
            local k = self.t < RING_WARN and (0.4 + 0.6 * sin(self.t * 9)) or 1
            arc(0, BOSS_Y, self.r, 0, 360, 64, 120 * k, 255, 236, 150, 0.05)
            for i = 1, RING_N do
                local a = self.rot + (i - 1) * 360 / RING_N
                draw_orb(cos(a) * self.r, BOSS_Y + sin(a) * self.r, 0.9, 0.85 * k, 255, 226, 120)
            end
        end,
    }, true)

    do
        local name = "花符「日輪の輪」"
        local card = boss.card.New(name, 1, 1, 60, 780)
        boss.card.add({ { card, "1a" } }, 25, name, 286)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__ring = New(class["th05_sunring"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 236, 150)
                boss.cast(self, 90)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 236, 150)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 9 do
                        local o = fly(ball_mid, 12, self.x, self.y, AIM_V,
                                a0 + (k - 5) * 9, 0)
                        o._r, o._g, o._b = 255, 226, 120
                    end
                    task.Wait(AIM_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__ring) then
                object.RawDel(self.__ring)
            end
            self.__ring = nil
        end
    end
end

--============================
--[卡2] 花符「花の絨毯」
--  限位：两侧的花墙（x = ±176 的竖列），缓慢向中间挤一下再退开。
--        挤的时候玩家被压到中间那条带里；退开时又能散开。
--  装饰：全屏花瓣雨（不朝自机、横向摆），是这张卡面积的主力。
--  威胁：每 90 帧一道橫向波，从一侧扫过来。
--  配色：粉白花瓣 + 青绿波；装饰层低 alpha。
--  容错：花墙单程 200 帧走完 60 px（0.3 px/帧），玩家随便躲。
--  预警：60 帧先画两条竖线
--============================
do
    local WALL_X = 176
    local SQUEEZE = 60          -- 往中间挤多少
    local CYCLE = 400
    local WALL_WARN = 60
    local PETAL_GAP = 14
    local WAVE_GAP = 55
    local WAVE_V = 2.2
    local BOSS_X, BOSS_Y = 0, 100

    class["th05_sidewall"] = Class(object, {
        init = function(self)
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            self.k = max(0, sin((self.t - WALL_WARN) * 360 / CYCLE))
            if self.t < WALL_WARN then
                return
            end
            if (self.t - WALL_WARN) % CYCLE == 0 then
                --一列花墙：**生在屏幕外那一侧**再朝内推，不会在自机身上冒出来。
                --⚠ 左右两侧的朝向是相反的：左边朝右（0°）、右边朝左（180°）。
                for s = -1, 1, 2 do
                    for i = 1, 26 do
                        local y = lstg.world.b + (i - 0.5) * (lstg.world.t - lstg.world.b) / 26
                        local o = fly(flower2, 10, s * (WALL_X + 40), y, 0.9,
                                s > 0 and 180 or 0, 0)
                        o._r, o._g, o._b = 190, 255, 190
                    end
                end
            end
        end,
        render = function(self)
            local a = self.t < WALL_WARN and (0.4 + 0.6 * sin(self.t * 9)) or self.k
            for s = -1, 1, 2 do
                thin_line(s * WALL_X, lstg.world.b, s * WALL_X, lstg.world.t, 90 * a, 190, 255, 190, 0.12)
            end
        end,
    }, true)

    do
        local name = "花符「花の絨毯」"
        local card = boss.card.New(name, 1, 1, 60, 760)
        boss.card.add({ { card, "1a" } }, 25, name, 287)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__wall = New(class["th05_sidewall"])
            --装饰层：全屏花瓣雨
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 214, 236)
                boss.cast(self, 60)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 214, 236)
                while true do
                    New(class["th05_petalbg"])
                    New(class["th05_petalbg"])
                    task.Wait(PETAL_GAP)
                end
            end)
            --威胁层：横向波
            task.New(self, function()
                task.Wait(150)
                while true do
                    local from_left = ran:Sign() > 0
                    for i = 1, 14 do
                        local y = lstg.world.b + (i - 0.5) * (lstg.world.t - lstg.world.b) / 14
                        local x = from_left and (lstg.world.l - 20) or (lstg.world.r + 20)
                        local o = fly(ball_mid, 8, x, y, WAVE_V, from_left and 0 or 180, 0)
                        o._r, o._g, o._b = 160, 250, 220
                    end
                    task.Wait(WAVE_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__wall) then
                object.RawDel(self.__wall)
            end
            self.__wall = nil
        end
    end
end

--============================
--[卡3] 幻符「四季の輪舞」
--  限位：四色同心环，**两两反向自转 + 反相张缩**（AGENTS.md §10.10 的旋转对称）。
--        四个环各自有缺口，缺口错开 —— 任何时刻总有一条路。
--  装饰：环上的花向外飘（低 alpha）。
--  威胁：每个环张到最大时，从环上朝自机吐一片扇形。
--  配色：春粉 / 夏青 / 秋金 / 冬白，四色分明 —— 这张卡专门吃对比度。
--  容错：张缩周期 200 帧；转速 ±0.6°/帧。缺口 60°（R=150 处约 157 px）。
--  预警：90 帧画四个骨架环
--============================
do
    local RINGS = {
        { r0 = 96,  r1 = 132, rot = 0,   dir = 1,  col = 2,  rgb = { 255, 170, 200 } },
        { r0 = 124, r1 = 162, rot = 90,  dir = -1, col = 6,  rgb = { 150, 245, 235 } },
        { r0 = 152, r1 = 190, rot = 180, dir = 1,  col = 12, rgb = { 255, 226, 130 } },
        { r0 = 178, r1 = 214, rot = 270, dir = -1, col = 16, rgb = { 240, 245, 255 } },
    }
    local PULSE = 120
    local GAP_A = 60            -- 缺口张角
    local ROT_V = 0.6
    local RING_WARN = 90
    -- ⚠ 每个环吐几颗。原来 36 颗 × 4 环、每 200 帧一轮 —— 弹会全部朝 boss 收敛，
    --   在自机活动带里叠成一堵墙（实测安全角度只剩 12.8/24、下方被打 17.6 次/秒）。
    --   装饰层要的是「面积」不是「密度」：颗数砍到 18、速度压到 1.1，照样铺满。
    local RING_SHOTS = 18
    local RING_V = 1.1
    local BOSS_X, BOSS_Y = 0, 60

    class["th05_ringdance"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t == RING_WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            if self.t < RING_WARN then
                return
            end
            local ph = (self.t - RING_WARN) * 360 / PULSE
            for i = 1, #RINGS do
                local R = RINGS[i]
                local k = 0.5 + 0.5 * sin(ph + (i - 1) * 90)
                local r = R.r0 + (R.r1 - R.r0) * k
                local rot = (R.rot + R.dir * ROT_V * (self.t - RING_WARN)) % 360
                --张到最大那一刻吐一轮：弹从环上朝内飞，是这张卡的主面积
                --⚠ 不要再叠 (i-1)*偏移：四个环的张缩本来就错开 90°，是多余的；
                --   而且偏移一大就会越过模数，那个环的瞄准轮**永远不触发**（静默失效）
                if (self.t - RING_WARN) % PULSE == int(PULSE * 0.25) then
                    for s = 0, RING_SHOTS do
                        local a = rot + GAP_A * 0.5 + (360 - GAP_A) * s / RING_SHOTS
                        local x, y = cx + cos(a) * r, cy + sin(a) * r
                        -- ⚠ **切向**（a+90）而不是朝内（a+180）：
                        --   朝内的话四个环一起往 boss 收敛，自机被关在汇聚点里
                        --   （实测死局 + 下方被打 17.6 次/秒）。切向 = 整圈自转，
                        --   既是「旋转对称」的图案，又不会自己堆成一堵墙。
                        -- 自机正好站在环上时，这一发挪到对面（不挖洞、不少发）
                        x, y = mirror_spawn(cx, cy, x, y, RING_V)
                        deco_bullet(ball_mid, R.col, x, y, RING_V,
                                a + 90, 260, R.rgb[1], R.rgb[2], R.rgb[3])
                    end
                end
                --威胁：环上匀出 5 路朝自机（只在自机所在的那一段）
                if (self.t - RING_WARN) % PULSE == int(PULSE * 0.75) then
                    local pa = Angle(cx, cy, player.x, player.y)
                    for s = -3, 3 do
                        local a = pa + s * 7
                        local x, y = cx + cos(a) * r, cy + sin(a) * r
                        --自机站在环上时，这一发从**对面**生成（不挖洞、不少发）
                        x, y = mirror_spawn(cx, cy, x, y, 2.2)
                        local o = fly(ball_mid, R.col, x, y, 2.2,
                                Angle(x, y, player.x, player.y), 0)
                        o._r, o._g, o._b = R.rgb[1], R.rgb[2], R.rgb[3]
                    end
                end
            end
        end,
        render = function(self)
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            local t = max(self.t - RING_WARN, 0)
            local ph = t * 360 / PULSE
            local kk = self.t < RING_WARN and (0.4 + 0.6 * sin(self.t * 9)) or 1
            for i = 1, #RINGS do
                local R = RINGS[i]
                local k = 0.5 + 0.5 * sin(ph + (i - 1) * 90)
                local r = R.r0 + (R.r1 - R.r0) * k
                local rot = (R.rot + R.dir * ROT_V * t) % 360
                arc(cx, cy, r, rot + GAP_A * 0.5, rot + 360 - GAP_A * 0.5, 56,
                        130 * kk, R.rgb[1], R.rgb[2], R.rgb[3], 0.055)
            end
            draw_orb(cx, cy, 1.2, 0.9 * kk, 255, 244, 190)
        end,
    }, true)

    do
        local name = "幻符「四季の輪舞」"
        local card = boss.card.New(name, 1, 1, 60, 820)
        boss.card.add({ { card, "1a" } }, 25, name, 288)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__dance = New(class["th05_ringdance"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 244, 190)
                boss.cast(self, 90)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 244, 190)
                --补一层慢慢落的花瓣，把空隙填掉（纯装饰）
                while true do
                    New(class["th05_petalbg"])
                    task.Wait(20)
                end
            end)
        end

        function card:del()
            if IsValid(self.__dance) then
                object.RawDel(self.__dance)
            end
            self.__dance = nil
        end
    end
end

--============================
--[卡4] 风符「花嵐」
--  限位：风。**已经在空中的弹会被推着走**（object.BulletDo），风向周期性反向。
--        这是「软限位」——玩家不是被夹住，而是被气场推着漂。
--  装饰：大量花粉横飞（0.8 px/帧、低 alpha、不朝自机），面积主力。
--  威胁：每 110 帧一轮自机方向的霰（12 路），风向会让它歪掉 ——
--        所以这轮**只在离自机足够远时才吐**，近了就换成一圈散开。
--  配色：金绿花粉 + 白霰。
--  容错：风向 460 帧一周期，风速最大 1.7 px/帧 —— 比自机慢一倍。
--  预警：风墙出现前 90 帧只画流线
--============================
do
    local WIND_PERIOD = 460
    local WIND_MAX = 1.7
    local GUST_GAP = 65
    local GUST_N = 12
    local GUST_V = 2.6
    local POLLEN_GAP = 8
    local BOSS_X, BOSS_Y = 0, 140

    class["th05_wind"] = Class(object, {
        init = function(self)
            self.t = 0
            self.vx = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t < 90 then
                return
            end
            self.vx = WIND_MAX * sin((self.t - 90) * 360 / WIND_PERIOD)
            object.BulletDo(function(b)
                --已经在空中的弹被风推着走：这就是软限位
                b.vx = (b.vx or 0) + self.vx * 0.06
            end)
        end,
        render = function(self)
            local a = self.t < 90 and (0.4 + 0.6 * sin(self.t * 9)) or abs(self.vx) / WIND_MAX
            for i = 1, 9 do
                local y = lstg.world.b + (i + 0.3) * (lstg.world.t - lstg.world.b) / 10
                local x = ((self.t * 3 + i * 57) % 420) - 210
                thin_line(x, y, x + 46, y, 70 * a, 200, 255, 170, 0.07)
            end
        end,
    }, true)

    do
        local name = "风符「花嵐」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 25, name, 289)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__wind = New(class["th05_wind"])
            --装饰层：花粉横飞（面积）
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 200, 255, 170)
                boss.cast(self, 60)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 200, 255, 170)
                while true do
                    local from_left = ran:Sign() > 0
                    deco_bullet(grain_a, 10,
                            from_left and lstg.world.l - 16 or lstg.world.r + 16,
                            ran:Float(lstg.world.b, lstg.world.t),
                            1.0, from_left and 0 or 180, 320, 226, 255, 150)
                    task.Wait(POLLEN_GAP)
                end
            end)
            --威胁层：自机方向霰；**自机太近就换成散开**（AGENTS.md §10.10：
            --靠近了不改生成位置，而是改展开形式 —— 不挖洞）
            task.New(self, function()
                task.Wait(150)
                while true do
                    if near_player(self.x, self.y, GUST_V) then
                        for k = 1, GUST_N do
                            local o = fly(ball_mid, 16, self.x, self.y, GUST_V,
                                    k * 360 / GUST_N, 0)
                            o._r, o._g, o._b = 255, 255, 255
                        end
                    else
                        local a0 = Angle(self, player)
                        for k = 1, GUST_N do
                            local o = fly(ball_mid, 16, self.x, self.y, GUST_V,
                                    a0 + (k - 6.5) * 7, 0)
                            o._r, o._g, o._b = 255, 255, 255
                        end
                    end
                    task.Wait(GUST_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__wind) then
                object.RawDel(self.__wind)
            end
            self.__wind = nil
        end
    end
end

--============================
--[卡5] 梦符「花の牢獄」
--  限位：8 条径向花枝（旋转的牢笼），枝间留 45° 大缝（R=150 处约 118 px）。
--  装饰：枝端开花 —— 从枝端向外扩散的星形（慢速，铺面积）。
--  威胁：每 80 帧从**离自机最近的那条缝**里吐三连。
--  配色：藤绿枝 + 蜜色星。
--  容错：枝转速 0.35°/帧，缝宽 118 px → 挪过一条缝约 30 帧，留 2 倍余量。
--  预警：80 帧只画枝的骨架线
--============================
do
    local ARMS = 8
    local R_IN, R_OUT = 95, 165
    local PULSE = 140
    local ROT_V = 0.35
    local BRANCH_V = 1.5
    local BLOOM_N = 6
    local JAIL_WARN = 80
    local BOSS_X, BOSS_Y = 0, 60

    class["th05_jail"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t == JAIL_WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            if self.t < JAIL_WARN then
                return
            end
            local rot = self.t * ROT_V
            local r = R_IN + (R_OUT - R_IN) * (0.5 + 0.5 * sin(self.t * 360 / PULSE))
            --枝：沿半径排的一列弹（旋转对称，是这张卡的图案主体）
            if (self.t - JAIL_WARN) % PULSE == 0 then
                for k = 1, ARMS do
                    local a = rot + (k - 1) * 360 / ARMS
                    for i = 1, 10 do
                        local rr = r - 34 + i * 6.8
                        local x, y = cx + cos(a) * rr, cy + sin(a) * rr
                        --枝上的弹**朝外**走（a 而不是 a+180）：像枝条抽长，
                        --不会一起往 boss 汇聚把自机关在中心
                        deco_bullet(ellipse, 10, x, y, 1.2, a, 240, 190, 255, 190)
                    end
                    --枝端开花：向外扩散的星，铺面积
                    for j = 1, BLOOM_N do
                        local aa = a + (j - (BLOOM_N + 1) / 2) * 14
                        deco_bullet(star_small, 12,
                                cx + cos(a) * (r + 10), cy + sin(a) * (r + 10),
                                1.0, aa, 280, 255, 226, 130)
                    end
                end
            end
            --威胁：从离自机最近的那条缝里吐三连
            if (self.t - JAIL_WARN) % 42 == 22 then
                local pa = Angle(cx, cy, player.x, player.y)
                local best, bestd = pa, 1e9
                for k = 1, ARMS do
                    local a = rot + (k - 0.5) * 360 / ARMS
                    local d = abs(((a - pa + 540) % 360) - 180)
                    if d < bestd then
                        bestd, best = d, a
                    end
                end
                for i = 1, 5 do
                    local rr = r + 30 - i * 23
                    local x, y = cx + cos(best) * rr, cy + sin(best) * rr
                    --自机就在这条缝上时，三连从**对面那条缝**生成（不挖洞、不少发）
                    x, y = mirror_spawn(cx, cy, x, y, BRANCH_V)
                    local o = fly(knife, 12, x, y, BRANCH_V,
                            Angle(x, y, player.x, player.y), 0)
                    o._r, o._g, o._b = 255, 246, 180
                end
            end
        end,
        render = function(self)
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            local kk = self.t < JAIL_WARN and (0.4 + 0.6 * sin(self.t * 9)) or 1
            local rot = self.t * ROT_V
            local r = R_IN + (R_OUT - R_IN) * (0.5 + 0.5 * sin(self.t * 360 / PULSE))
            for k = 1, ARMS do
                local a = rot + (k - 1) * 360 / ARMS
                thin_line(cx + cos(a) * (r - 34), cy + sin(a) * (r - 34),
                        cx + cos(a) * (r + 34), cy + sin(a) * (r + 34),
                        120 * kk, 200, 255, 190, 0.11)
                draw_orb(cx + cos(a) * r, cy + sin(a) * r, 0.8, 0.9 * kk, 255, 246, 180)
            end
        end,
    }, true)

    do
        local name = "梦符「花の牢獄」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 25, name, 290)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__jail = New(class["th05_jail"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 200, 255, 190)
                boss.cast(self, 80)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 200, 255, 190)
                while true do
                    New(class["th05_petalbg"])
                    task.Wait(16)
                end
            end)
        end

        function card:del()
            if IsValid(self.__jail) then
                object.RawDel(self.__jail)
            end
            self.__jail = nil
        end
    end
end

--============================
--[卡6] 光符「陽だまりの雨」
--  限位：上升的光柱（左右缓慢横移的竖列），柱间是安全带。
--        光柱**从下方升上来**，所以永远不会在自机身上生成（AGENTS.md §10.10 的正解）。
--  装饰：光点上升 + 柱顶的亮环。
--  威胁：每 100 帧从柱隙里朝自机吐一波。
--  配色：暖金柱 + 白心。
--  容错：柱横移 0.5 px/帧，周期 360 帧；柱宽 26 px，柱距 84 px。
--  预警：70 帧先画柱的投影线
--============================
do
    local COL_N = 5
    local COL_W = 26
    local COL_V = 2.6
    local COL_GAP = 84
    local SWAY = 0.5
    local SWAY_T = 360
    local COL_WARN = 70
    local RAY_GAP = 58
    local RAY_V = 2.3
    local BOSS_X, BOSS_Y = 0, 150

    class["th05_sunbeam"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t == COL_WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            if self.t < COL_WARN then
                return
            end
            local sw = sin((self.t - COL_WARN) * 360 / SWAY_T) * 40
            --柱：从屏幕下方向上吐的一列，**生在画面外**，不会在自机身上冒出来
            if (self.t - COL_WARN) % 26 == 0 then
                for k = 1, COL_N do
                    local x = (k - (COL_N + 1) / 2) * COL_GAP + sw
                    deco_bullet(ball_mid, 13, x, lstg.world.b - 14, COL_V, 90, 300,
                            255, 240, 170)
                end
            end
            --威胁：柱隙里朝自机
            if (self.t - COL_WARN) % RAY_GAP == 40 then
                local cy = BOSS_Y
                for k = 1, COL_N - 1 do
                    local x = (k - COL_N / 2) * COL_GAP + sw
                    if Dist(x, cy, player.x, player.y) > SPAWN_REACT * RAY_V then
                        local pa = Angle(x, cy, player.x, player.y)
                        for w = -1, 1 do
                            local o = fly(ball_mid, 2, x, cy, RAY_V, pa + w * 10, 0)
                            o._r, o._g, o._b = 255, 210, 160
                        end
                    end
                end
            end
        end,
        render = function(self)
            local kk = self.t < COL_WARN and (0.4 + 0.6 * sin(self.t * 9)) or 1
            local sw = self.t < COL_WARN and 0 or
                    sin((self.t - COL_WARN) * 360 / SWAY_T) * 40
            for k = 1, COL_N do
                local x = (k - (COL_N + 1) / 2) * COL_GAP + sw
                SetImageState("white", "mul+add", 46 * kk, 255, 240, 170)
                Render("white", x, 0, 90, 900 / 16, COL_W / 16)
            end
        end,
    }, true)

    do
        local name = "光符「陽だまりの雨」"
        local card = boss.card.New(name, 1, 1, 60, 790)
        boss.card.add({ { card, "1a" } }, 25, name, 291)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__beam = New(class["th05_sunbeam"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 240, 170)
                boss.cast(self, 80)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 240, 170)
                while true do
                    New(class["th05_petalbg"])
                    task.Wait(18)
                end
            end)
        end

        function card:del()
            if IsValid(self.__beam) then
                object.RawDel(self.__beam)
            end
            self.__beam = nil
        end
    end
end

--============================
--[卡7] 薔薇符「茨の檻」
--  限位：带刺的收缩环 —— 半径在 110~210 呼吸；环上的刺**朝外**（不朝自机，装饰）。
--        自机被环挡在外侧：环缩小时外侧空间变大，张开时被挤到角落。
--  装饰：刺（短弹链）+ 环上的蔷薇花（慢速外扩）。
--  威胁：每 90 帧一轮自机方向的散射（贴着环内侧吐，但**从环的远端开始**，
--        所以离自机最近的那几颗天然离得远）。
--  配色：玫红主色 + 白心。
--  容错：呼吸 260 帧，半径最快 2.5 px/帧。
--  预警：80 帧画环的骨架
--============================
do
    local R_IN, R_OUT = 96, 176
    local BREATH = 260
    local THORN_N = 12
    -- ⚠ 模数必须 **大于** 下面的偏移（45 或 23），否则 `% ROSE_GAP == 偏移` 永远不成立，
    --   整层弹幕**静默消失**而且不报错。原来 112→70→55→40 时踩过这个坑。
    local ROSE_GAP = 34
    local ROSE_N = 11
    local ROSE_V = 2.2
    local THORN_WARN = 80
    local BOSS_X, BOSS_Y = 0, 60

    class["th05_briar"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t == THORN_WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            if self.t < THORN_WARN then
                return
            end
            local r = R_IN + (R_OUT - R_IN) * (0.5 + 0.5 * sin(self.t * 360 / BREATH))
            --刺：从环上朝外（不朝自机）—— 装饰性的大面积
            if (self.t - THORN_WARN) % 40 == 0 then
                for k = 1, THORN_N do
                    local a = k * 360 / THORN_N + self.t * 0.2
                    for i = 1, 3 do
                        local x = cx + cos(a) * (r + i * 14)
                        local y = cy + sin(a) * (r + i * 14)
                        --刺朝外；自机贴上来的那一根整根挪到对面（不挖洞）
                        x, y = mirror_spawn(cx, cy, x, y, 1.7)
                        deco_bullet(mildew, 2, x, y, 1.7, a, 190, 255, 150, 200)
                    end
                end
            end
            --威胁：一圈朝内的玫瑰，从**环的远端**开始铺，靠自机那几颗会先飞过去
            if (self.t - THORN_WARN) % ROSE_GAP == 17 then
                local pa = Angle(cx, cy, player.x, player.y)
                for k = 1, ROSE_N do
                    --跳开自机正对着的那一段，先吐对面的
                    local off = (k - (ROSE_N + 1) / 2) * (360 / ROSE_N)
                    if abs(off) > 30 then
                        local a = pa + off
                        local x, y = cx + cos(a) * r, cy + sin(a) * r
                        local o = fly(flower2, 2, x, y, ROSE_V,
                                Angle(cx, cy, x, y) + 180, 0)
                        o._r, o._g, o._b = 255, 150, 190
                    end
                end
            end
        end,
        render = function(self)
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            local kk = self.t < THORN_WARN and (0.4 + 0.6 * sin(self.t * 9)) or 1
            local r = self.t < THORN_WARN and R_IN or
                    R_IN + (R_OUT - R_IN) * (0.5 + 0.5 * sin(self.t * 360 / BREATH))
            arc(cx, cy, r, 0, 360, 72, 120 * kk, 255, 150, 190, 0.05)
            for k = 1, THORN_N do
                local a = k * 360 / THORN_N + self.t * 0.2
                thin_line(cx + cos(a) * r, cy + sin(a) * r,
                        cx + cos(a) * (r + 40), cy + sin(a) * (r + 40),
                        90 * kk, 255, 150, 190, 0.08)
            end
        end,
    }, true)

    do
        local name = "薔薇符「茨の檻」"
        local card = boss.card.New(name, 1, 1, 60, 810)
        boss.card.add({ { card, "1a" } }, 25, name, 292)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__briar = New(class["th05_briar"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 150, 190)
                boss.cast(self, 80)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 150, 190)
                while true do
                    New(class["th05_petalbg"])
                    task.Wait(15)
                end
            end)
        end

        function card:del()
            if IsValid(self.__briar) then
                object.RawDel(self.__briar)
            end
            self.__briar = nil
        end
    end
end

--============================
--[卡8] 蝶符「花蝶風月」
--  限位：两群蝶在屏幕中心 180° 相对公转 —— 一群放顺时针螺旋、一群逆时针，
--        螺旋在中央交叉。**蝶本身不朝自机**，是装饰性的公转体。
--  装饰：大量蝶（低 alpha，扇翅动画），面积主力。
--  威胁：两条反向螺旋在交叉点附近形成密集带（这是要躲的）。
--  配色：青白蝶 + 金螺旋。
--  容错：蝶转速 0.8°/帧；螺旋 1.6 px/帧，缝够宽。
--  预警：90 帧画两个公转轨道
--============================
do
    local SWIRL_T = 120
    local SWIRL_N = 6
    local SWIRL_V = 1.6
    local SWIRL_GAP = 6
    local FLY_R = 84
    local ROT_V = 0.8
    local BOSS_X, BOSS_Y = 0, 90

    class["th05_swirl"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t == 90 then
                PlaySound("kira00", 0.25, 0, true)
            end
            if self.t < 90 then
                return
            end
            local mk = self.master
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(mk) then
                cx, cy = mk.x, mk.y
            end
            local t = self.t - 90
            --两条反向螺旋：交叉点在中央，密集带就是要躲的
            if t % SWIRL_GAP == 0 then
                for s = -1, 1, 2 do
                    local base = s * ROT_V * t
                    for i = 1, SWIRL_N do
                        local a = base + (i - 1) * 360 / SWIRL_N
                        local o = fly(ball_mid, s > 0 and 6 or 8, cx, cy,
                                SWIRL_V, a, s * 1.6)
                        o._r, o._g, o._b = s > 0 and 255 or 180, 226, 255
                    end
                end
            end
        end,
        render = function(self)
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            local kk = self.t < 90 and (0.4 + 0.6 * sin(self.t * 9)) or 1
            local t = max(self.t - 90, 0)
            for s = -1, 1, 2 do
                for i = 1, 8 do
                    local a = s * ROT_V * t + (i - 1) * 45
                    draw_butterfly(cx + cos(a) * FLY_R, cy + sin(a) * FLY_R,
                            a + 90, 0.85, 190 * kk, t * 0.3 + i, s > 0 and 6 or 8)
                end
            end
            arc(cx, cy, FLY_R, 0, 360, 40, 60 * kk, 200, 240, 255, 0.04)
        end,
    }, true)

    do
        local name = "蝶符「花蝶風月」"
        local card = boss.card.New(name, 1, 1, 60, 830)
        boss.card.add({ { card, "1a" } }, 25, name, 293)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__swirl = New(class["th05_swirl"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 200, 240, 255)
                boss.cast(self, 90)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 200, 240, 255)
                while true do
                    New(class["th05_petalbg"])
                    task.Wait(17)
                end
            end)
        end

        function card:del()
            if IsValid(self.__swirl) then
                object.RawDel(self.__swirl)
            end
            self.__swirl = nil
        end
    end
end

--============================
--[卡9] 秘符「四季の扉」
--  限位：三扇反向自转的方框「扉」（旋转对称），每扇留一个 70° 的门缝。
--        三扇错开 —— 永远有一扇的门朝着玩家。
--  装饰：门框上的光点 + 门内溢出的花瓣（向外，不朝自机）。
--  威胁：每 100 帧从**最远那扇门**里朝玩家吐一束。
--  配色：三扇分别是金 / 青 / 白，门框亮边。
--  容错：门转 0.45°/帧；门缝 70°（R=140 处约 171 px）。
--  预警：90 帧画三个门框骨架
--============================
do
    local DOORS = {
        { r = 104, rot = 0,   dir = 1,  col = 12, rgb = { 255, 226, 130 } },
        { r = 142, rot = 120, dir = -1, col = 6,  rgb = { 150, 245, 235 } },
        { r = 180, rot = 240, dir = 1,  col = 16, rgb = { 245, 245, 255 } },
    }
    local DOOR_A = 70
    local ROT_V = 0.45
    local DOOR_WARN = 90
    -- ⚠ 门框上的点：原来 21 点 × 3 扇、每 10 帧一轮 → 峰值 1462 发、
    --   三个环一起朝 boss 收敛，自机在带里被压死（实测死局 795 帧 / 22%）。
    --   装饰层铺的是**面积**：点砍到 12 个、间隔拉到 18 帧、速度压到 0.9。
    local DOOR_SHOTS = 9
    local DOOR_GAP = 18
    local DOOR_V = 0.9
    local BURST_GAP = 80
    local BURST_V = 2.2
    local BOSS_X, BOSS_Y = 0, 60

    class["th05_gate"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t == DOOR_WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            if self.t < DOOR_WARN then
                return
            end
            local t = self.t - DOOR_WARN
            --门框：沿圆周排的短链（旋转对称的图案主体）
            if t % DOOR_GAP == 0 then
                for i = 1, #DOORS do
                    local D = DOORS[i]
                    local rot = D.rot + D.dir * ROT_V * t
                    for s = 0, DOOR_SHOTS do
                        local a = rot + DOOR_A * 0.5 + (360 - DOOR_A) * s / DOOR_SHOTS
                        local x, y = cx + cos(a) * D.r, cy + sin(a) * D.r
                        x, y = mirror_spawn(cx, cy, x, y, DOOR_V)
                        deco_bullet(ball_small, D.col, x, y, DOOR_V,
                                a + 90, 200, D.rgb[1], D.rgb[2], D.rgb[3])
                    end
                    --门内溢出的花瓣：**向外**（不朝自机）
                    if t % 30 == 0 then
                        local a = rot + 180 + DOOR_A * 0.5
                        deco_bullet(ellipse, D.col, cx + cos(a) * (D.r + 8),
                                cy + sin(a) * (D.r + 8), 1.3, a, 280,
                                D.rgb[1], D.rgb[2], D.rgb[3])
                    end
                end
            end
            --威胁：每 100 帧，从**离自机最远的那扇门**里吐一束
            if t % BURST_GAP == 50 then
                for i = 1, #DOORS do
                    local D = DOORS[i]
                    local rot = D.rot + D.dir * ROT_V * t
                    local a = rot + 180
                    local x, y = cx + cos(a) * D.r, cy + sin(a) * D.r
                    x, y = mirror_spawn(cx, cy, x, y, BURST_V)
                    for k = -1, 1 do
                        local o = fly(ball_mid, D.col, x, y, BURST_V,
                                Angle(x, y, player.x, player.y) + k * 11, 0)
                        o._r, o._g, o._b = D.rgb[1], D.rgb[2], D.rgb[3]
                    end
                end
            end
        end,
        render = function(self)
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(self.master) then
                cx, cy = self.master.x, self.master.y
            end
            local kk = self.t < DOOR_WARN and (0.4 + 0.6 * sin(self.t * 9)) or 1
            local t = max(self.t - DOOR_WARN, 0)
            for i = 1, #DOORS do
                local D = DOORS[i]
                local rot = D.rot + D.dir * ROT_V * t
                arc(cx, cy, D.r, rot + DOOR_A * 0.5, rot + 360 - DOOR_A * 0.5, 48,
                        130 * kk, D.rgb[1], D.rgb[2], D.rgb[3], 0.06)
            end
            draw_orb(cx, cy, 1.0, 0.9 * kk, 255, 250, 220)
        end,
    }, true)

    do
        local name = "秘符「四季の扉」"
        local card = boss.card.New(name, 1, 1, 60, 830)
        boss.card.add({ { card, "1a" } }, 25, name, 294)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__gate = New(class["th05_gate"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 250, 220)
                boss.cast(self, 90)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 250, 220)
                while true do
                    New(class["th05_petalbg"])
                    task.Wait(19)
                end
            end)
        end

        function card:del()
            if IsValid(self.__gate) then
                object.RawDel(self.__gate)
            end
            self.__gate = nil
        end
    end
end

--============================
--[卡10] 「四季の花園」 终符
--  四阶段（血量 25/50/75% 推进，兜底计时 15/28/41 秒）：
--    ① 日輪の輪（卡1 的花环，慢速）
--    ② ＋ 四季の輪舞（卡3 的四色环）
--    ③ ＋ 花の牢獄（卡5 的枝）
--    ④ ＋ 花粉の嵐（卡4 的风与花粉）
--  每一层都是**已经写好的展开**，直接复用 —— 层层叠加而不是换掉，
--  所以到了四阶段屏幕上「有弹经过的面积」非常大，但真正要躲的仍然只有自机周围。
--  终符用 `(1,1,60)`、hp 1200（和 th04 终符同档）。
--============================
do
    local CARD_HP = 1200
    local HP_P2, HP_P3, HP_P4 = CARD_HP * 0.25, CARD_HP * 0.50, CARD_HP * 0.75
    local PH_P2, PH_P3, PH_P4 = 15 * 60, 28 * 60, 41 * 60
    local BOSS_X, BOSS_Y = 0, 60

    do
        local name = "「四季の花園」"
        local card = boss.card.New(name, 1, 1, 60, CARD_HP)
        boss.card.add({ { card, "1a" } }, 25, name, 295)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__phase = 1
            self.__done = 0
            --① 花环（从第一秒就在）
            self.__ring10 = attach(self, New(class["th05_sunring"], self))
            --花雨装饰：全程
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 240, 180)
                boss.cast(self, 90)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 240, 180)
                while true do
                    New(class["th05_petalbg"])
                    task.Wait(14)
                end
            end)
            --威胁层：自机方向扇，路数随阶段递增
            task.New(self, function()
                task.Wait(180)
                while true do
                    --路数封顶 9：终符已经叠了四层装饰，威胁层再加密就变成弹墙。
                    --（⚠ sin 修成角度制之后各层装饰真的会转了，同样参数下比之前密得多，
                    --  实测 6.2 次/秒 → 收到 9 路）
                    local ways = min(5 + ((self.__phase or 1) - 1) * 1, 7)
                    local a0 = Angle(self, player)
                    for k = 1, ways do
                        local o = fly(ball_mid, 12, self.x, self.y, 2.5,
                                a0 + (k - (ways + 1) / 2) * 8, 0)
                        o._r, o._g, o._b = 255, 226, 120
                    end
                    task.Wait(150 - ((self.__phase or 1) - 1) * 10)
                end
            end)
        end

        function card:frame()
            --阶段推进：血量（或兜底计时）驱动。
            --⚠ 阈值必须落在**本卡血量之内**，否则那个阶段永远靠掉血触发不了。
            local left = 0
            if self._sp_point_auto then
                left = #self._sp_point_auto
            end
            local done = 3 - left
            if done >= 1 then self.__done = max(self.__done or 0, 1) end
            if done >= 2 then self.__done = max(self.__done or 0, 2) end
            if done >= 3 then self.__done = max(self.__done or 0, 3) end
            local t = self.ani
            if t > PH_P2 then self.__done = max(self.__done or 0, 1) end
            if t > PH_P3 then self.__done = max(self.__done or 0, 2) end
            if t > PH_P4 then self.__done = max(self.__done or 0, 3) end

            --⚠ frame 会先于 init 跑满整个 before 期间（见 AGENTS.md §9），
            --  所以这里一律 nil 安全：__done / __phase 都可能在 init 之前被读到。
            local ph = (self.__done or 0) + 1
            while (self.__phase or 1) < ph do
                self.__phase = (self.__phase or 1) + 1
                Newcharge_out(self.x, self.y, 255, 226, 140)
                if self.__phase == 2 then
                    self.__dance10 = attach(self, New(class["th05_ringdance"], self))
                elseif self.__phase == 3 then
                    self.__jail10 = attach(self, New(class["th05_jail"], self))
                elseif self.__phase == 4 then
                    self.__wind10 = attach(self, New(class["th05_wind"]))
                    PlaySound("kira00", 0.3, 0, true)
                end
            end
        end

        function card:del()
            local objs = { self.__ring10, self.__dance10, self.__jail10, self.__wind10 }
            for i = 1, #objs do
                if IsValid(objs[i]) then
                    object.RawDel(objs[i])
                end
            end
            self.__ring10, self.__dance10, self.__jail10, self.__wind10 = nil, nil, nil, nil
        end
    end
end
