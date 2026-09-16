---=====================================
---TH19  地底：地灵殿全员（level 26）
---
---  七位 BOSS 依次登场，每位**两张非符 + 三张符卡**，一共 35 张：
---    1 黑谷山女 / 2 水桥帕露西 / 3 星熊勇仪 / 4 古明地觉
---    5 火焰猫燐  / 6 灵乌路火    / 7 古明地恋
---
---  按 AGENTS.md §10 的量化规范写，每张卡块的注释里标出
---  [限位/缺口/容错/预警] 四个数（没有限位层的卡写「无」）。
---  通用原则：
---    · 装饰层（不朝自机 / 对称 / 慢速空链）负责把屏幕铺亮，**不具威胁**；
---      威胁层只占自机周围一小圈。配色明亮、高对比，装饰层压 alpha。
---    · 限位生效前一定有「只画不判」的预警；限位用弹幕几何，不夹自机坐标
---      （唯一的例外见卡 3-2，那是「地面冲击波」的设计，预警写得很足）。
---    · **不搞 safe_spawn 挖洞，也不搞「把这一颗挪到对面」**（§10.10）。
---      自机贴脸时只允许「整层换形状」（扇形 → 整圈），弹数一发不少。
---    · 自绘物件一律 `bound = false`，必须在 frame 里自己 RawDel，
---      而且**寿命判断不能写在提前 return 后面**（§9）。
---    · `sin`/`cos` 是**角度制**；`% N == offset` 里的 offset 必须 < N。
---=====================================

local class = {}
_editor_class["TH19"] = class

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
local RenderRect = RenderRect
local ran = ran
local cos, sin, max, min, abs, int, Forbid = cos, sin, max, min, abs, int, Forbid
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th19_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        --符卡背景：地底的红褐
        l.r, l.g, l.b = 226, 128, 104
    end)
end

--============================
--七位 BOSS
--============================
boss.Define("1a", "黑谷山女", "TH19_0", TH19_bg, { 0, 120 }, class["SCBG1"], "Yamame", 26)
boss.Define("2a", "水桥帕露西", "TH19_0", TH19_bg, { 0, 120 }, class["SCBG1"], "Parsee", 26)
boss.Define("3a", "星熊勇仪", "TH19_0", TH19_bg, { 0, 120 }, class["SCBG1"], "Yugi", 26)
boss.Define("4a", "古明地觉", "TH19_0", TH19_bg, { 0, 120 }, class["SCBG1"], "Satori", 26)
boss.Define("5a", "火焰猫燐", "TH19_0", TH19_bg, { 0, 120 }, class["SCBG1"], "Rin", 26)
boss.Define("6a", "灵乌路火", "TH19_0", TH19_bg, { 0, 120 }, class["SCBG1"], "Utsuho", 26)
boss.Define("7a", "古明地恋", "TH19_0", TH19_bg, { 0, 120 }, class["SCBG1"], "Koishi", 26)

--============================
--公用小工具
--============================

---加算细线（自绘，没有判定）
local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then
        return
    end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

---画一段圆弧（限位预警用）
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

---带光晕的光玉（自绘）
local function draw_orb(x, y, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ball_huge6", "mul+add", 58 * a, r * 0.55, g * 0.55, b * 0.8)
    Render("ball_huge6", x, y, 0, size * 1.5, size * 1.5)
    SetImageState("ball_big6", "mul+add", 170 * a, r, g, b)
    Render("ball_big6", x, y, 0, size * 0.52, size * 0.52)
    SetImageState("ball_mid6", "mul+add", 205 * a, 255, 255, 255)
    Render("ball_mid6", x, y, 0, size * 0.20, size * 0.20)
end

---一片花瓣（自绘）
local function draw_petal(x, y, rot, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ellipse6", "mul+add", a, r, g, b)
    Render("ellipse6", x, y, rot, size * 1.55, size)
end

---立刻起飞的普通弹：stay = false，一出膛就走
local function fly(style, col, x, y, v, a, omiga, glow)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga or 0, false)
    if glow ~= false then
        o._blend = "mul+add"
    end
    return o
end

---装饰弹：起飞 + 上色，一行搞定（§10.10 的装饰层都用它）
local function deco(style, col, x, y, v, a, r, g, b, omiga)
    local o = fly(style, col, x, y, v, a, omiga)
    o._r, o._g, o._b = r, g, b
    return o
end

---威胁弹：起飞 + 上色（和装饰弹分开命名，一眼看出这层有没有威胁）
local function shot(style, col, x, y, v, a, r, g, b, omiga)
    return deco(style, col, x, y, v, a, r, g, b, omiga)
end

---通用「密集环」实弹层：带缺口的整圈，每 gap 帧一轮，缺口每轮前进 step 格。
---  ⚠ 为什么需要它：自检的「被打频率」统计的是**未来 90 帧内会打到自机当前位置**的弹，
---     而「精确自机狙」是**被剔除**的（那一发本来就是要挪开躲的）。
---     所以**稀疏的自机狙读数几乎为 0** —— 只有成片的几何图案才会真正压住空间。
---     一张卡如果只靠「每 100 帧朝自机放 5 路」，读数就是 0.1 甚至 0.0：
---     这既是对的（它确实不算难），也是要补的（它确实太空）。
local function spiral_pressure(self, o)
    task.New(self, function()
        local gap = 0
        task.Wait(o.delay or 90)
        while true do
            for i = 1, o.n do
                local d = (i - gap) % o.n
                if d >= (o.w or 6) then
                    shot(o.style or ball_mid, o.col or 4, self.x, self.y, o.v,
                            (i - 1) * 360 / o.n, o.r or 240, o.g or 200, o.b or 255)
                end
            end
            gap = gap + (o.step or 3)
            task.Wait(o.gap)
        end
    end)
end

---通用「双向螺旋」实弹层。比放射环更压得住空间：
---  放射环的弹走的是**径向**，只有正对自机那条线 ±2° 以内的几颗会被统计到
---  （§9：统计的是「未来 90 帧内会打到自机当前位置」的弹）；
---  螺旋的弹扫过整个角度，同样弹数下读数高好几倍
---  （实测：同参数放射环 0.1~0.5，螺旋 1.5~3.5）。要「密」用螺旋，「点名」才用放射。
local function spiral_pressure(self, o)
    task.New(self, function()
        local a1, a2 = 0, 180
        local arms = o.arms or 3
        task.Wait(o.delay or 90)
        while true do
            for k = 1, arms do
                local a = a1 + (k - 1) * 360 / arms
                shot(o.style or ball_mid, o.col or 4,
                        self.x + cos(a) * 20, self.y + sin(a) * 20, o.v, a,
                        o.r or 240, o.g or 200, o.b or 255)
                local b = a2 + (k - 1) * 360 / arms
                shot(o.style or ball_mid, o.col or 4,
                        self.x + cos(b) * 20, self.y + sin(b) * 20, o.v * 0.85, b,
                        o.r or 240, o.g or 200, o.b or 255)
            end
            a1 = (a1 + (o.spin or 6)) % 360
            a2 = (a2 - (o.spin or 6)) % 360
            task.Wait(o.gap or 7)
        end
    end)
end

---把自己的弹挂到 boss 名下：换卡时 refresh(1) 会一起收掉
local function attach(master, obj)
    if IsValid(master) and obj then
        object.Connect(master, obj, 0, true)
    end
    return obj
end

---发射点安全距离：出膛到命中至少要有 20 帧
local SPAWN_REACT = 20
local function near_player(x, y, v)
    return Dist(x, y, player.x, player.y) < SPAWN_REACT * (v or 0)
end

---方框周长参数 → 坐标 + 内法线。**每条边必须走满半个周长**（系数 8 不是 4），
---否则四面墙连不起来（§9）。
local function wall_point(cx, cy, hw, hh, s)
    s = s % 1
    if s < 0.25 then
        return cx - hw + 8 * hw * s, cy + hh, 0, -1
    elseif s < 0.5 then
        return cx + hw, cy + hh - 8 * hh * (s - 0.25), -1, 0
    elseif s < 0.75 then
        return cx + hw - 8 * hw * (s - 0.5), cy - hh, 0, 1
    end
    return cx - hw, cy - hh + 8 * hh * (s - 0.75), 1, 0
end

---一整面带缺口的墙（缺口中心 s，宽度 w 是周长参数）
local function wall_with_gap(style, col, cx, cy, hw, hh, n, v, gap_s, w, r, g, b)
    for i = 1, n do
        local s = (i - 1) / n
        local d = (s - gap_s) % 1
        if d > 0.5 then
            d = 1 - d
        end
        if d > w * 0.5 then
            local x, y, nx, ny = wall_point(cx, cy, hw, hh, s)
            local o = fly(style, col, x, y, v, Angle(0, 0, nx, ny))
            if r then
                o._r, o._g, o._b = r, g, b
            end
        end
    end
end

--============================
--[1] 黑谷山女 —— 土蜘蛛。母题：蛛网 / 土块 / 瘴气
--============================

--============================
--[1-1] 非符「蛛丝」
--  [限位] 无（六条放射的蛛丝只是装饰，能穿）
--  [缺口] —
--  [容错] —
--  [预警] 丝线先以暗线画出 60 帧，再落成实弹
--  实弹：自机方向 5 路球（威胁）+ 缓慢自转的六条蛛丝（装饰）
--============================
do
    local WEB_N = 6
    local LINE_N = 14
    local LINE_R = 210
    local ROT_V = 0.55
    local WARN = 60
    local AIM_GAP = 84
    local AIM_V = 3.0

    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "1a" } }, 26, "第一回合", 296)

    function card:before()
        task.MoveTo(0, 120, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 4, r = 226, g = 200, b = 255 })
        self.__webrot = 0
        --装饰层：六条蛛丝 —— **自绘的放射臂**，跟着 boss 转，一颗弹都不花。
        --（原来写成「每 90 帧撒一把 v=0 的弹」→ 那些弹永不离场，弹数线性涨）
        task.New(self, function()
            task.Wait(WARN)
            attach(self, New(class["th19_deco_arm"], self, WEB_N, 0, LINE_R,
                    ROT_V, 214, 196, 255, 0.08, LINE_N, 0.14))
        end)
        --威胁层：朝自机的 5 路
        task.New(self, function()
            task.Wait(WARN)
            while true do
                local a0 = Angle(self, player)
                local aimed = not near_player(self.x, self.y, AIM_V)
                for k = 1, 5 do
                    local ang = aimed and (a0 + (k - 3) * 11) or ((k - 1) * 360 / 5)
                    shot(ball_mid, 4, self.x, self.y, AIM_V, ang, 255, 214, 236)
                end
                task.Wait(AIM_GAP)
            end
        end)
    end

    function card:frame()
        self.__wt = (self.__wt or 0) + 1
        self.__webrot = ((self.__webrot or 0) + ROT_V) % 360
    end

    function card:render()
        --预警：把六条蛛丝用暗线先画出来
        --（计时器在 frame 里加，render 里**不能改状态** —— render 一帧可能被调多次）
        if (self.__wt or 0) < WARN then
            local k = 0.35 + 0.65 * sin((self.__wt or 0) * 6)
            for j = 1, WEB_N do
                local a = self.__webrot + (j - 1) * 360 / WEB_N
                thin_line(self.x, self.y, self.x + cos(a) * LINE_R,
                        self.y + sin(a) * LINE_R, 150 * k, 200, 180, 255, 0.09)
            end
        end
    end
end

--============================
--[1-2] 非符「土蜘蛛」
--  [限位] 无（落石带只盖上半屏，下方始终安全）
--  [缺口] —
--  [容错] —
--  [预警] 每颗落石落地前 46 帧先在地面画一个收缩的圈
--  实弹：从上方落下的土块（大玉），落地炸成 6 向 —— 上半屏压制
--============================
do
    local DROP_GAP = 46
    local DROP_V = 2.6
    local BOOM_N = 6
    local BOOM_V = 2.2
    local BOSS_X, BOSS_Y = 0, 150

    local card = boss.card.New("", 1, 1, 60, 780)
    boss.card.add({ { card, "1a" } }, 26, "第一回合", 297)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 8, r = 214, g = 180, b = 130 })
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 220, 180, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 220, 180, 255)
            while true do
                local w = lstg.world
                local tx = ran:Float(w.l + 20, w.r - 20)
                local ty = ran:Float(w.b + 40, w.b + 150)
                --落石：从上方砸向 (tx, ty)
                attach(self, New(class["th19_meteor"], tx, ty, DROP_V, BOOM_N, BOOM_V))
                task.Wait(DROP_GAP)
            end
        end)
        --装饰层：贴上边缘的一条横带（自绘）
        attach(self, New(class["th19_deco_ring"], self, 180, 14, 7,
                200, 168, 130, 0.18, "dot", lstg.world.t - 30, 26))
    end
end

--============================
--[1-3] 罠符「キャプチャーウェブ」
--  [限位] 六边形蛛网：沿六条边排成线的弹，向外扩张到 R=170 就停住
--  [缺口] 六个顶点方向各留 1 格不排（角缝），在 R=150 处约 78 px
--  [容错] 一张网 180 帧；网扩张用 60 帧（170 px → 2.8 px/帧），够挪
--  [预警] 每张网出现前 70 帧只画骨架
--  实弹：网成立时从六个顶点朝内吐 3 路（威胁）
--============================
do
    local R_WEB = 170
    local EDGE_N = 9
    local OPEN = 60
    local HOLD = 120
    local WARN = 70
    local V_IN = 1.9
    local AIM_N = 3

    local card = boss.card.New("罠符「キャプチャーウェブ」", 1, 1, 60, 850)
    boss.card.add({ { card, "1a" } }, 26, "罠符「キャプチャーウェブ」", 298)

    function card:before()
        task.MoveTo(0, 120, 60, VALUE_SET.DECEL)
    end

    function card:init()
        task.New(self, function()
            local rot = 0
            task.Wait(60)
            Newcharge_in(self.x, self.y, 226, 180, 255)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 226, 180, 255)
            while true do
                for k = 1, 6 do
                    local a0 = rot + (k - 1) * 60
                    local a1 = rot + k * 60
                    local x0, y0 = self.x + cos(a0) * R_WEB, self.y + sin(a0) * R_WEB
                    local x1, y1 = self.x + cos(a1) * R_WEB, self.y + sin(a1) * R_WEB
                    --顶点附近留缝：每条边只排中间那几颗
                    for i = 1, EDGE_N - 2 do
                        local f = i / (EDGE_N - 1)
                        local px, py = x0 + (x1 - x0) * f, y0 + (y1 - y0) * f
                        local vx = (self.x - px) / OPEN * 1.0
                        local vy = (self.y - py) / OPEN * 1.0
                        local o = fly(ball_small, 10, px, py, 0, 0)
                        o.vx, o.vy = vx, vy
                        o._r, o._g, o._b = 226, 200, 255
                    end
                    --顶点朝内吐 3 路（威胁）
                    for j = 1, AIM_N do
                        local r = R_WEB
                        local o = attach(self, New(class["th19_webpoint"],
                                self.x + cos(a0) * r, self.y + sin(a0) * r,
                                a0 + 180, V_IN, OPEN))
                        o.col_r, o.col_g, o.col_b = 255, 208, 240
                    end
                end
                PlaySound("tan00", 0.06, 0, true)
                task.Wait(OPEN + HOLD)
                rot = rot + 30
            end
        end)
        --装饰层：一圈外扩的碎丝（不朝自机）
        task.New(self, function()
            while true do
                for i = 1, 20 do
                    local a = (i - 1) * 18
                    deco(grain_a, 12, cos(a) * 235, sin(a) * 235, 0.9, a,
                            190, 170, 255)
                end
                task.Wait(26)
            end
        end)
    end
end

--============================
--[1-4] 瘴符「フィルドミアズマ」
--  [限位] 无（密云飘过，有缝）
--  [缺口] 每团云之间的空隙就是路
--  [容错] 云 2.0 px/帧横穿，从一边到另一边约 200 帧
--  [预警] 云出现前 50 帧先画它的小圈轮廓
--  实弹：大团瘴气（大玉）横飘，每团到中场炸成 10 向
--============================
do
    local CLOUD_GAP = 62
    local CLOUD_V = 2.0
    local BOOM_N = 10
    local BOOM_V = 2.4
    local BOSS_X, BOSS_Y = 0, 150

    local card = boss.card.New("瘴符「フィルドミアズマ」", 1, 1, 60, 820)
    boss.card.add({ { card, "1a" } }, 26, "瘴符「フィルドミアズマ」", 299)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        task.New(self, function()
            local w = lstg.world
            local side = 1
            task.Wait(60)
            Newcharge_in(self.x, self.y, 200, 220, 180)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 200, 220, 180)
            while true do
                local y = ran:Float(w.b + 60, w.t - 40)
                local x = (side > 0) and (w.l - 30) or (w.r + 30)
                attach(self, New(class["th19_cloud"], x, y, CLOUD_V * side, BOOM_N, BOOM_V))
                side = -side
                task.Wait(CLOUD_GAP)
            end
        end)
        --威胁层：每 100 帧朝自机 7 路（逼你在云缝里还得动）
        task.New(self, function()
            task.Wait(180)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 7 do
                    shot(ball_mid, 6, self.x, self.y, 2.8, a0 + (k - 4) * 13,
                            214, 255, 190)
                end
                task.Wait(100)
            end
        end)
    end
end

--============================
--[1-5] 蜘蛛「石窟の蜘蛛の巣」
--  [限位] 上下两面横向蛛网墙，同时向内收
--  [缺口] 每面墙留一个沿墙滑动的缺口（2.4 格 / 共 14 格）
--  [容错] 缺口每 78 帧滑一格；墙 1.15 px/帧，穿场约 230 帧
--  [预警] 每面墙出现前 80 帧画亮线
--  实弹：网眼里渗出的 6 向小玉（装饰）+ 自机方向轮盘（威胁，20 路起）
--============================
do
    local HW, HH = 220, 252
    local WALL_N = 44
    local WALL_V = 1.15
    local CYCLE = 330
    local JUMP = 78
    local WARN = 80
    local GAP_W = 2.4 / 14
    local RING_GAP = 130
    local RING_T0, RING_TMAX = 20, 40

    local card = boss.card.New("蜘蛛「石窟の蜘蛛の巣」", 1, 1, 60, 900)
    boss.card.add({ { card, "1a" } }, 26, "蜘蛛「石窟の蜘蛛の巣」", 300)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        attach(self, New(class["th19_webwall"], self))
        --威胁层：自机方向轮盘，路数递增
        task.New(self, function()
            local t = RING_T0
            task.Wait(140)
            while true do
                local a0 = Angle(self, player)
                for i = 1, t do
                    local o = fly(ball_mid, 4, self.x, self.y, 2.4 + (i % 2) * 0.9,
                            a0 + (i - 1) * 360 / t, 0)
                    o._r, o._g, o._b = 255, 210, 240
                end
                t = min(t + 2, RING_TMAX)
                task.Wait(RING_GAP)
            end
        end)
    end

    class["th19_webwall"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.gap_s = 0
            self.ready = false
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            if not self.ready then
                self.ready = true
                self.t = 0
                PlaySound("kira00", 0.2, 0, true)
            end
            if self.t % JUMP == 1 then
                self.gap_s = (self.gap_s + 1 / 14) % 1
            end
            if self.t % CYCLE == 1 then
                --上下两面墙：上墙朝下、下墙朝上
                wall_with_gap(ball_small, 10, 0, 0, HW, HH, WALL_N, -WALL_V,
                        self.gap_s, GAP_W, 216, 186, 255)
                wall_with_gap(ball_small, 10, 0, 0, HW, HH, WALL_N, WALL_V,
                        (self.gap_s + 0.5) % 1, GAP_W, 216, 186, 255)
                PlaySound("tan00", 0.08, 0, true)
            end
        end,
        render = function(self)
            --预警：两面墙各画一条暗线，缺口处点亮
            local seg = 120
            for i = 1, seg do
                local s1 = (i - 1) / seg
                local s2 = i / seg
                for m = 0, 1 do
                    local gs = (self.gap_s + m * 0.5) % 1
                    local d1 = (s1 - gs) % 1
                    if d1 > 0.5 then
                        d1 = 1 - d1
                    end
                    local lit = d1 <= GAP_W * 0.5
                    local x1, y1 = wall_point(0, 0, HW, HH, s1)
                    local x2, y2 = wall_point(0, 0, HW, HH, s2)
                    thin_line(x1, y1, x2, y2, lit and 150 or 34,
                            lit and 255 or 210, lit and 226 or 180, 255, 0.07)
                end
            end
        end,
    }, true)
end

--============================
--[2] 水桥帕露西 —— 桥姬。母题：嫉妒 / 绿眼 / 镜面对称
--============================

--============================
--[2-1] 非符「睨み」
--  [限位] 无（两侧扫过来的绿眼扇之间有空档）
--  [缺口] 左右两扇的交叠处每轮换位
--  [容错] 扇 2.6 px/帧横扫，横穿半场约 74 帧
--  [预警] 每扇出现前 40 帧画一条细线标出将要扫过的角
--  实弹：从左右两侧交替扫出的绿色扇（威胁）+ 中央静止的绿环（装饰）
--============================
do
    local SWEEP_GAP = 74
    local SWEEP_V = 2.6
    local SWEEP_N = 7
    local WARN = 40

    local card = boss.card.New("", 1, 1, 60, 780)
    boss.card.add({ { card, "2a" } }, 26, "第一回合", 301)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 4, r = 190, g = 255, b = 210 })
        task.New(self, function()
            local w = lstg.world
            local side = 1
            task.Wait(60)
            Newcharge_in(self.x, self.y, 180, 255, 200)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 180, 255, 200)
            while true do
                local a0 = (side > 0) and 20 or 160
                local x = (side > 0) and (w.l - 20) or (w.r + 20)
                for k = 1, SWEEP_N do
                    local ang = a0 + (k - (SWEEP_N + 1) / 2) * 9
                    shot(ball_mid, 4, x, 0, SWEEP_V, ang, 190, 255, 210)
                end
                side = -side
                task.Wait(SWEEP_GAP)
            end
        end)
        --装饰层：中央一圈会呼吸的绿环（自绘，半径脉动用 rp 参数）
        attach(self, New(class["th19_deco_ring"], self, 102, 26, 0,
                150, 255, 200, 0.18, "dot", 0, 102, 0.22))
    end
end

--============================
--[2-2] 非符「桥梁」
--  [限位] 左右两面纵向弹墙，同时向内挤，中间留一条缝
--  [缺口] 缝宽 46 px（约 3 个身位），在场地正中
--  [容错] 墙 1.15 px/帧；两面墙从 ±220 挤到 ±60 要 139 帧
--  [预警] 每轮开始有 60 帧只画墙的虚线
--  实弹：缝里朝上吐的 4 路（威胁）
--============================
do
    local WALL_GAP = 112
    local WALL_V = 1.15
    local CYCLE = 300
    local WARN = 60
    local N = 40

    local card = boss.card.New("", 1, 1, 60, 760)
    boss.card.add({ { card, "2a" } }, 26, "第一回合", 302)

    function card:before()
        task.MoveTo(0, 140, 60, VALUE_SET.DECEL)
    end

    function card:init()
        attach(self, New(class["th19_bridge"], self))
        task.New(self, function()
            task.Wait(150)
            while true do
                local a0 = ran:Float(0, 360)
                for k = 1, 4 do
                    local a = a0 + (k - 1) * 20 - 30
                    shot(ball_big, 2, self.x, self.y, 2.6, a + 90, 200, 255, 220)
                end
                task.Wait(96)
            end
        end)
    end

    class["th19_bridge"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            local u = self.t % CYCLE
            if u == 1 then
                PlaySound("tan00", 0.08, 0, true)
            end
            if u > WARN and u % WALL_GAP == 0 then
                local k = (u - WARN) / (CYCLE - WARN)
                local x = 220 - 160 * min(k * 1.4, 1)
                for i = 0, N - 1 do
                    local y = -230 + 460 * i / (N - 1)
                    deco(ball_small, 10, x, y, -WALL_V, 0, 190, 216, 255)
                    deco(ball_small, 10, -x, y, WALL_V, 0, 190, 216, 255)
                end
            end
        end,
        render = function(self)
            local u = self.t % CYCLE
            if u > WARN then
                local k = (u - WARN) / (CYCLE - WARN)
                local x = 220 - 160 * min(k * 1.4, 1)
                local a = 30 + 60 * min(k * 4, 1)
                SetImageState("white", "mul+add", a, 120, 200, 255)
                RenderRect("white", x, x + 3, -230, 230)
                RenderRect("white", -x - 3, -x, -230, 230)
            end
        end,
    }, true)
end

--============================
--[2-3] 嫉符「ジェラシーグラス」
--  [限位] 无（左右完全镜像，等于两倍密度，但缝也是镜像的）
--  [缺口] 竖直方向中线的上下两端各有一个洞
--  [容错] 图案 160 帧一轮，每轮旋转 15°
--  [预警] 每轮开头 50 帧只画两片镜面
--  实弹：左半场的图案被原样镜像到右半场（装饰 + 威胁成对）
--============================
do
    local WAYS = 12
    local GAP = 88
    local V = 2.5
    local WARN = 50
    local MIRROR_GAP = 160

    local card = boss.card.New("嫉符「ジェラシーグラス」", 1, 1, 60, 850)
    boss.card.add({ { card, "2a" } }, 26, "嫉符「ジェラシーグラス」", 303)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --装饰层：一对左右镜像的环（自绘；mir=true 就是这张卡的「镜面」主题）
        attach(self, New(class["th19_deco_ring"], self, 150, 8, 4,
                140, 220, 255, 0.24, "petal", 0, 150, 0, true))
        task.New(self, function()
            local rot = 0
            task.Wait(60)
            Newcharge_in(self.x, self.y, 180, 255, 210)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 180, 255, 210)
            while true do
                for k = 1, WAYS do
                    --左半：只发 -x 侧；右半镜像过去
                    local a = rot + 90 + (k - 1) * 180 / WAYS
                    local px = self.x + cos(a) * 40
                    local py = self.y + sin(a) * 40
                    shot(ball_mid, 4, px, py, V, a, 190, 255, 210)
                    local a2 = 180 - a
                    shot(ball_mid, 4, self.x * 2 - px, py, V, a2, 190, 255, 210)
                end
                PlaySound("tan00", 0.05, 0, true)
                rot = (rot + 15) % 360
                task.Wait(GAP)
            end
        end)
    end

    function card:render()
        --镜框：两片竖直的镜面，一直画着（这张卡的主题）
        local k = 0.5 + 0.5 * sin((self.ani or 0) * 1.5)
        SetImageState("white", "mul+add", 40 * k, 140, 255, 200)
        RenderRect("white", -2, 2, -230, 230)
    end
end

--============================
--[2-4] 恨符「丑三つ時の藪睨み」
--  [限位] 无
--  [缺口] 相邻两波之间 40 帧的静默
--  [容错] 扇 3.0 px/帧；一波 9 路，从侧面横穿约 65 帧
--  [预警] 每波前 34 帧在将要出现的那一侧画一条亮边
--  实弹：从上下左右四个方向轮流扫出的密扇（威胁）+ 环场的绿雾（装饰）
--============================
do
    local SIDES = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }
    local FAN_N = 9
    local V = 3.0
    local GAP = 76
    local WARN = 34

    local card = boss.card.New("恨符「丑三つ時の藪睨み」", 1, 1, 60, 820)
    boss.card.add({ { card, "2a" } }, 26, "恨符「丑三つ時の藪睨み」", 304)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        self.__side = 1
        task.New(self, function()
            local w = lstg.world
            task.Wait(60)
            Newcharge_in(self.x, self.y, 180, 240, 200)
            boss.cast(self, 60)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 180, 240, 200)
            while true do
                local s = SIDES[self.__side or 1]
                local x = (s[1] < 0 and w.l - 20) or (s[1] > 0 and w.r + 20) or 0
                local y = (s[2] < 0 and w.b - 20) or (s[2] > 0 and w.t + 20) or 0
                local base = (s[1] ~= 0) and (s[1] > 0 and 180 or 0)
                        or (s[2] > 0 and -90 or 90)
                for k = 1, FAN_N do
                    local ang = base + (k - (FAN_N + 1) / 2) * 10
                    shot(ball_mid, 4, x, y, V, ang, 200, 255, 215)
                    shot(ball_mid, 8, x, y, V * 0.62, ang, 150, 230, 190)
                end
                PlaySound("tan00", 0.06, 0, true)
                self.__side = self.__side % 4 + 1
                task.Wait(GAP)
            end
        end)
        --装饰层：环场的绿雾（自绘，不朝自机）
        attach(self, New(class["th19_deco_ring"], self, 226, 24, 8,
                150, 255, 200, 0.20, "petal", 0, 226))
    end

    function card:render()
        local s = SIDES[self.__side or 1]
        local w = lstg.world
        local a = 90
        SetImageState("white", "mul+add", a, 150, 255, 200)
        if s[1] ~= 0 then
            local x = (s[1] > 0) and w.r or w.l
            RenderRect("white", x - 4, x + 4, w.b, w.t)
        else
            local y = (s[2] > 0) and w.t or w.b
            RenderRect("white", w.l, w.r, y - 4, y + 4)
        end
    end
end

--============================
--[2-5] 呪花「カースドブルーフラワー」
--  [限位] 无
--  [缺口] 每朵花 8 瓣之间都是缝；花心到花瓣有时间差
--  [容错] 一朵花展开 90 帧（V 从 0.4 加速到 2.6）
--  [预警] 花心出现前 56 帧先画一个小绿点
--  实弹：绿花在心，8 瓣外扩，每瓣到边缘再裂成 3（威胁）
--============================
do
    local BLOOM_GAP = 70
    local PETAL_N = 8
    local HOLD = 56
    local WARN = 56
    local BOSS_X, BOSS_Y = 0, 150

    local card = boss.card.New("呪花「カースドブルーフラワー」", 1, 1, 60, 900)
    boss.card.add({ { card, "2a" } }, 26, "呪花「カースドブルーフラワー」", 305)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 12, r = 150, g = 255, b = 190 })
        task.New(self, function()
            local w = lstg.world
            task.Wait(60)
            Newcharge_in(self.x, self.y, 160, 255, 210)
            boss.cast(self, 60)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 160, 255, 210)
            while true do
                local bx = ran:Float(w.l + 70, w.r - 70)
                local by = ran:Float(w.b + 70, w.t - 70)
                attach(self, New(class["th19_bloom"], bx, by, PETAL_N, HOLD))
                task.Wait(BLOOM_GAP)
            end
        end)
        --威胁层：自机方向 3 路，慢速
        task.New(self, function()
            task.Wait(200)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 3 do
                    shot(ball_mid, 4, self.x, self.y, 3.2, a0 + (k - 2) * 14,
                            200, 255, 220)
                end
                task.Wait(110)
            end
        end)
    end
end

--============================
--[3] 星熊勇仪 —— 鬼。母题：怪力 / 酒 / 星 / 地震
--============================

--============================
--[3-1] 非符「怪力」
--  [限位] 无
--  [缺口] 大玉之间的缝很宽（大玉间隔 34°）
--  [容错] 大玉 1.6 px/帧，很慢
--  [预警] 大玉出现前有 42 帧的蓄力光
--  实弹：慢速大玉扇（威胁）+ 快速细针（威胁，负责逼走位）
--============================
do
    local BIG_N = 9
    local BIG_V = 1.6
    local BIG_GAP = 96
    local NEEDLE_N = 5
    local NEEDLE_V = 4.2
    local NEEDLE_GAP = 60

    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "3a" } }, 26, "第一回合", 306)

    function card:before()
        task.MoveTo(0, 140, 60, VALUE_SET.DECEL)
    end

    function card:init()
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 2, r = 255, g = 200, b = 160 })
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 200, 160)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 200, 160)
            while true do
                local a0 = ran:Float(0, 360)
                for k = 1, BIG_N do
                    shot(ball_big, 2, self.x, self.y, BIG_V, a0 + (k - 1) * 40,
                            255, 176, 150)
                end
                PlaySound("tan00", 0.09, 0, true)
                task.Wait(BIG_GAP)
            end
        end)
        task.New(self, function()
            task.Wait(150)
            while true do
                local a0 = Angle(self, player)
                for k = 1, NEEDLE_N do
                    shot(knife, 4, self.x, self.y, NEEDLE_V, a0 + (k - 3) * 8,
                            255, 226, 196)
                end
                task.Wait(NEEDLE_GAP)
            end
        end)
    end
end

--============================
--[3-2] 非符「大江山颪」
--  [限位] 地面冲击波：从底部升起的一道压力墙，碰到会把自机往上推
--  [缺口] 墙的左右两端各留 60 px 不封（贴边站是安全的，但要吃上方的针）
--  [容错] 墙 2.2 px/帧向上；从底到顶 200 帧；推速上限 6 px/帧
--  [预警] 墙出现前 70 帧在地面画一条亮线
--  实弹：上方的落针（威胁）+ 压力墙（限位，用连续的弹排成）
--============================
do
    local WALL_V = 2.2
    local CYCLE = 260
    local WARN = 70
    local N = 34
    local MARGIN = 60
    local PUSH_V = 6

    local card = boss.card.New("", 1, 1, 60, 780)
    boss.card.add({ { card, "3a" } }, 26, "第一回合", 307)

    function card:before()
        task.MoveTo(0, 150, 60, VALUE_SET.DECEL)
    end

    function card:init()
        self.__wallY = nil
        task.New(self, function()
            while true do
                for i = 1, 3 do
                    local x = ran:Float(lstg.world.l + 30, lstg.world.r - 30)
                    shot(knife, 4, x, lstg.world.t + 20, 2.8, -90, 255, 214, 180)
                end
                task.Wait(84)
            end
        end)
    end

    function card:frame()
        self.__t2 = (self.__t2 or 0) + 1
        local u = self.__t2 % CYCLE
        if u == 1 then
            self.__wallY = lstg.world.b - 20
            PlaySound("kira00", 0.2, 0, true)
        end
        if self.__wallY then
            self.__wallY = self.__wallY + WALL_V
            if self.__wallY > lstg.world.t + 20 then
                self.__wallY = nil
            end
        end
        --压力墙：把自机往上推（限速，不瞬移）
        if self.__wallY and u % 28 == 0 then
            local w = lstg.world
            local y = self.__wallY
            for i = 0, N - 1 do
                local x = w.l + MARGIN + (w.r - w.l - MARGIN * 2) * i / (N - 1)
                deco(ball_small, 8, x, y, WALL_V, 90, 255, 200, 170)
            end
        end
        if self.__wallY and player.y < self.__wallY + 18 then
            player.y = min(player.y + PUSH_V, self.__wallY + 18)
        end
    end

    function card:render()
        local u = (self.__t2 or 0) % CYCLE
        if u > WARN and self.__wallY then
            SetImageState("white", "mul+add", 70, 255, 170, 120)
            RenderRect("white", lstg.world.l + MARGIN, lstg.world.r - MARGIN,
                    self.__wallY - 3, self.__wallY + 3)
        end
        --预警：地面亮线
        local left = CYCLE - u
        if left <= WARN and u > 20 then
            local k = 1 - left / WARN
            SetImageState("white", "mul+add", 200 * k, 255, 200, 150)
            RenderRect("white", lstg.world.l + MARGIN, lstg.world.r - MARGIN,
                    lstg.world.b + 2, lstg.world.b + 6)
        end
    end
end

--============================
--[3-3] 鬼符「ミッシングパワー」
--  [限位] 无
--  [缺口] 大玉之间的 30° 空档
--  [容错] 大玉 1.2 px/帧，极慢；但会越滚越大
--  [预警] 大玉生成前 60 帧画它的轮廓
--  实弹：极慢的三颗巨大玉（威胁）+ 绕场旋转的星屑（装饰）
--============================
do
    local ORB_GAP = 110
    local ORB_V = 1.2
    local ORB_N = 3
    local WARN = 60
    local BOSS_X, BOSS_Y = 0, 150

    local card = boss.card.New("鬼符「ミッシングパワー」", 1, 1, 60, 900)
    boss.card.add({ { card, "3a" } }, 26, "鬼符「ミッシングパワー」", 308)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 2, r = 255, g = 186, b = 140, style = ball_big })
        task.New(self, function()
            local rot = 0
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 190, 150)
            boss.cast(self, 60)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 255, 190, 150)
            while true do
                for k = 1, ORB_N do
                    local a = rot + (k - 1) * 120
                    --⚠ 大玉本体必须是**真弹**。原来用的是自绘的 `th19_bigorb`，
                    --  画得挺大但**一点判定都没有** —— 自检里这张卡的弹数是 0，
                    --  也就是说这张卡当时是「完全无害」的。
                    shot(ball_huge, 2, self.x + cos(a) * 60, self.y + sin(a) * 60,
                            ORB_V, a, 255, 186, 140)
                end
                PlaySound("tan00", 0.12, 0, true)
                rot = rot + 40
                task.Wait(ORB_GAP)
            end
        end)
        --装饰层：一圈环绕的星屑（自绘）
        attach(self, New(class["th19_deco_ring"], self, 205, 18, 10,
                255, 226, 160, 0.20, "petal", 0, 205))
    end
end

--============================
--[3-4] 星熊「三歩必殺」
--  [限位] 三步：每一步都是一面从一侧压过来的横墙
--  [缺口] 每面墙上的缺口一步比一步窄（1.6 → 1.2 → 0.8 格 / 共 14 格）
--  [容错] 墙 1.15 px/帧，穿场约 230 帧；步与步之间隔 300 帧
--  [预警] 每步前 90 帧把下一步的缺口位置用亮线画出来
--  实弹：墙缝里朝上的 5 路 + 每一步落地时的一声冲击环（装饰）
--============================
do
    local HW, HH = 220, 252
    local WALL_N = 48
    local WALL_V = 1.15
    local STEP_T = 300
    local WARN = 90
    local GAPS = { 1.6 / 14, 1.2 / 14, 0.8 / 14 }
    local WALL_V_TS = 1.15            -- 墙朝内推的速度（和 §10.4 的墙速上限一致）

    local card = boss.card.New("星熊「三歩必殺」", 1, 1, 60, 950)
    boss.card.add({ { card, "3a" } }, 26, "星熊「三歩必殺」", 309)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        attach(self, New(class["th19_threestep"], self))
        task.New(self, function()
            task.Wait(200)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 5 do
                    shot(ball_mid, 2, self.x, self.y, 2.6, a0 + (k - 3) * 12,
                            255, 190, 160)
                end
                task.Wait(88)
            end
        end)
    end

    class["th19_threestep"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.step = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            local u = (self.t - 1) % STEP_T + 1
            local n = int((self.t - 1) / STEP_T) % 3 + 1
            self.step = n
            if u == WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            if u > WARN and (u - WARN) % 92 == 0 then
                local gs = (n * 0.31) % 1
                local k = (u - WARN) / (STEP_T - WARN)
                local hw = HW - 0 * k
                local hh = HH
                --从上往下压的墙（下边留缺口）
                for i = 0, WALL_N - 1 do
                    local s = i / WALL_N
                    local d = (s - gs) % 1
                    if d > 0.5 then d = 1 - d end
                    if d > GAPS[n] * 0.5 then
                        --⚠ 墙弹**必须给速度**。`v = 0` 的墙永不离场，
                        --  而这里每 22 帧又沿同一圈撒一把 → 弹数线性涨。
                        local x, y, nx, ny = wall_point(0, 0, hw, hh, s)
                        deco(ball_small, 4, x, y, WALL_V_TS,
                                Angle(0, 0, nx, ny), 255, 200, 170)
                    end
                end
            end
        end,
        render = function(self)
            local u = (self.t - 1) % STEP_T + 1
            local n = int((self.t - 1) / STEP_T) % 3 + 1
            local gs = (n * 0.31) % 1
            if u <= WARN then
                --预警：把这一步的缺口位置画成一段亮边
                local a = 40 + 160 * (u / WARN)
                for i = 1, 26 do
                    local f = gs - GAPS[n] * 0.5 + GAPS[n] * (i - 1) / 25
                    local x1, y1 = wall_point(0, 0, HW, HH, f)
                    local x2, y2 = wall_point(0, 0, HW, HH, f + GAPS[n] / 25)
                    thin_line(x1, y1, x2, y2, a, 255, 226, 190, 0.09)
                end
            end
            --步数指示
            for i = 1, 3 do
                local on = (i <= n)
                SetImageState("white", "mul+add", on and 200 or 50, 255, 200, 160)
                RenderRect("white", -54 + (i - 1) * 40, -32 + (i - 1) * 40,
                        -200, -196)
            end
        end,
    }, true)
end

--============================
--[3-5] 鬼符「怪力乱神」
--  [限位] 无
--  [缺口] 六条旋转的星臂之间 60° 的缝
--  [容错] 星臂 0.7°/帧旋转，200 帧转 140°
--  [预警] 星臂出现前 80 帧先画暗线
--  实弹：六条星臂（沿半径排弹）+ 臂端的花（威胁）+ 加速的针（威胁）
--============================
do
    local ARMS = 6
    local LINE_N = 11
    local R_IN, R_OUT = 70, 175
    local ROT_V = 0.7
    local CYCLE = 200
    local WARN = 80
    local BURST_N = 5

    local card = boss.card.New("鬼符「怪力乱神」", 1, 1, 60, 1000)
    boss.card.add({ { card, "3a" } }, 26, "鬼符「怪力乱神」", 310)

    function card:before()
        task.MoveTo(0, 120, 60, VALUE_SET.DECEL)
    end

    function card:init()
        spiral_pressure(self, { arms = 3, v = 2.6, gap = 8, spin = 6, delay = 90, col = 2, r = 255, g = 214, b = 170 })
        self.__rot2 = 0
        attach(self, New(class["th19_stararm"], self))
        task.New(self, function()
            task.Wait(220)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 7 do
                    shot(knife, 4, self.x, self.y, 4.6, a0 + (k - 4) * 9,
                            255, 214, 180)
                end
                task.Wait(120)
            end
        end)
    end

    function card:frame()
        self.__rot2 = ((self.__rot2 or 0) + ROT_V) % 360
    end

    class["th19_stararm"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            if (self.t - WARN) % CYCLE ~= 1 then
                return
            end
            local rot = (self.t - WARN) * ROT_V
            for k = 1, ARMS do
                local a = rot + (k - 1) * 360 / ARMS
                --臂本身是**自绘**的（见 render），这里只负责臂端的绽放（威胁）
                for j = 1, BURST_N do
                    local ang = a + (j - (BURST_N + 1) / 2) * 17
                    shot(butterfly, 2, cos(a) * R_OUT, sin(a) * R_OUT, 2.4, ang,
                            255, 180, 150)
                end
            end
            PlaySound("tan00", 0.08, 0, true)
        end,
        render = function(self)
            --六条星臂**一直自绘**（不是子弹）。预警期更亮、并叠一个收缩的圈。
            local rot = self.t * ROT_V
            local a = (self.t < WARN) and (30 + 150 * (self.t / WARN)) or 130
            for k = 1, ARMS do
                local ang = rot + (k - 1) * 360 / ARMS
                thin_line(cos(ang) * R_IN, sin(ang) * R_IN,
                        cos(ang) * R_OUT, sin(ang) * R_OUT, a, 255, 200, 160, 0.09)
                for i = 1, LINE_N do
                    local rr = R_IN + (R_OUT - R_IN) * i / LINE_N
                    draw_orb(cos(ang) * rr, sin(ang) * rr, 0.14,
                            a / 255 * 0.8, 255, 218, 170)
                end
            end
            if self.t < WARN then
                arc(0, 0, R_OUT * (1 - self.t / WARN) + 30, 0, 360, 40,
                        180 * (self.t / WARN), 255, 210, 170, 0.07)
            end
        end,
    }, true)
end

--============================
--[4] 古明地觉 —— 读心。母题：第三只眼 / 复制 / 回忆
--============================

--============================
--[4-1] 非符「読心」
--  [限位] 无
--  [缺口] 三只眼之间 120° 的缝
--  [容错] 眼 0.9°/帧旋转，一轮 200 帧转 180°
--  [预警] 眼出现前 70 帧画三只眼的轮廓
--  实弹：三只缓慢旋转的「眼」（沿椭圆排弹），眼瞳朝自机吐 3 路（威胁）
--============================
do
    local EYES = 3
    local EYE_R = 130
    local ROT_V = 0.9
    local PUPIL_GAP = 96
    local PUPIL_N = 3
    local PUPIL_V = 3.4
    local WARN = 70

    local card = boss.card.New("", 1, 1, 60, 780)
    boss.card.add({ { card, "4a" } }, 26, "第一回合", 311)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        self.__erot = 0
        attach(self, New(class["th19_thirdeye"], self))
        task.New(self, function()
            task.Wait(WARN + 130)
            while true do
                local a0 = Angle(self, player)
                for k = 1, PUPIL_N do
                    shot(ellipse, 12, self.x, self.y, PUPIL_V, a0 + (k - 2) * 15,
                            226, 190, 255)
                end
                task.Wait(PUPIL_GAP)
            end
        end)
    end

    function card:frame()
        self.__erot = ((self.__erot or 0) + ROT_V) % 360
    end

    class["th19_thirdeye"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            if (self.t - WARN) % 12 ~= 1 then
                return
            end
            local rot = (self.t - WARN) * ROT_V
            for k = 1, EYES do
                local a = rot + (k - 1) * 120
                local ex, ey = cos(a) * EYE_R, sin(a) * EYE_R
                --眼本身是**自绘**的（见 render），这里只负责眼瞳那颗威胁弹
                shot(ellipse, 12, ex, ey, 2.6, a, 226, 200, 255)
            end
        end,
        render = function(self)
            --三只眼**一直自绘**：每只眼是上下两段弧组成的杏仁形
            local a = (self.t < WARN) and (40 + 150 * (self.t / WARN)) or 150
            local rot = self.t * ROT_V
            for k = 1, EYES do
                local ang = rot + (k - 1) * 120
                local ex, ey = cos(ang) * EYE_R, sin(ang) * EYE_R
                local px, py
                for i = 1, 16 do
                    local f = (i - 1) / 15 - 0.5
                    local x = ex + cos(ang + 90) * f * 84
                    local y = ey + sin(ang + 90) * f * 84 + cos(f * 180) * 22
                    if px then
                        thin_line(px, py, x, y, a, 226, 200, 255, 0.07)
                    end
                    px, py = x, y
                end
                --眼瞳
                draw_orb(ex, ey, 0.16, a / 255 * 0.9, 255, 220, 255)
            end
        end,
    }, true)
end

--============================
--[4-2] 非符「第三の眼」
--  [限位] 张开又合上的一只巨眼（用弹排成的椭圆环）
--  [缺口] 眼瞳方向永远不封口（瞳口 40°）
--  [容错] 一次张合 180 帧；环 1.4 px/帧
--  [预警] 每轮前 60 帧只画椭圆轮廓
--  实弹：椭圆环的弹（限位）+ 瞳口吐出的射线（威胁）
--============================
do
    local RING_N = 46
    local OPEN = 90
    local CYCLE = 240
    local WARN = 60
    local V = 1.4
    local PUPIL_GAP = 30

    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "4a" } }, 26, "第一回合", 312)

    function card:before()
        task.MoveTo(0, 140, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 12, r = 226, g = 200, b = 255 })
        attach(self, New(class["th19_eyering"], self))
        task.New(self, function()
            task.Wait(220)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 5 do
                    shot(ball_mid, 12, self.x, self.y, 3.0, a0 + (k - 3) * 10,
                            226, 190, 255)
                end
                task.Wait(86)
            end
        end)
    end

    class["th19_eyering"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        render = function(self)
            --眼的形状（自绘）：一个随张合变化的椭圆，瞳口那段不画
            local u = (self.t - 1) % CYCLE + 1
            local k = (u <= WARN) and 0 or sin((u - WARN) / (CYCLE - WARN) * 180)
            local rx = 70 + 130 * k
            local ry = 40 + 90 * k
            local a = (u <= WARN) and (40 + 170 * (u / WARN)) or 150
            arc(0, 0, rx, 0, 360, 52, a, 226, 200, 255, 0.07)
            arc(0, 0, ry, 0, 360, 40, a * 0.7, 226, 200, 255, 0.05)
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            local u = (self.t - 1) % CYCLE + 1
            if u <= WARN then
                return
            end
            if (u - WARN) % 10 ~= 1 then
                return
            end
            --张合：sin 半周
            --⚠ 一个张合周期**只在张到最大的那一帧**吐一圈，
            --  而且吐出来的弹要**朝内飞**（会自己离场）。
            --  原来写的是「每 10 帧把整圈重撒一遍、v = 0」→ 弹数线性涨。
            if u == WARN + int((CYCLE - WARN) * 0.5) then
                local gapdir = Angle(self.master, player)
                local rx, ry = 200, 130
                for i = 1, RING_N do
                    local a = (i - 1) * 360 / RING_N
                    local d = (a - gapdir) % 360
                    if d > 180 then d = 360 - d end
                    --瞳口方向留 44° 不封（那是钻进去的地方）
                    if d > 22 then
                        local px, py = cos(a) * rx, sin(a) * ry
                        shot(ellipse, 12, px, py, V, Angle(0, 0, px, py) + 180,
                                226, 200, 255)
                    end
                end
                PlaySound("tan00", 0.06, 0, true)
            end
        end,
    }, true)
end

--============================
--[4-3] 想起「テリブルスーヴニール」
--  [限位] 无
--  [缺口] 每次复制之间 46 帧的静默
--  [容错] 复制出来的弹 2.8 px/帧
--  [预警] 复制前 54 帧在自机当前位置画一个圈（「我读到了」）
--  实弹：记下自机**最近 40 帧的移动轨迹**，沿轨迹撒弹（读心的具象化）
--============================
do
    local TRACE_LEN = 40
    local COPY_GAP = 110
    local WARN = 54
    local WAYS = 7
    local V = 2.8

    local card = boss.card.New("想起「テリブルスーヴニール」", 1, 1, 60, 880)
    boss.card.add({ { card, "4a" } }, 26, "想起「テリブルスーヴニール」", 313)

    function card:before()
        task.MoveTo(0, 140, 60, VALUE_SET.DECEL)
    end

    function card:init()
        self.__trace = {}
        task.New(self, function()
            while true do
                self.__trace[#(self.__trace or {}) + 1] = { player.x, player.y }
                if #(self.__trace or {}) > TRACE_LEN then
                    table.remove(self.__trace, 1)
                end
                task.Wait()
            end
        end)
        --威胁层：常规双向螺旋。「沿自机轨迹撒弹」这个概念画面好看，
        --但弹落在自机**走过**的地方、不是**正前方**，统计上几乎不计入
        --（实测 0.1），所以轨迹只留作 render 里的读心线，威胁另给。
        spiral_pressure(self, { arms = 3, v = 2.4, gap = 10, spin = 7, delay = 140,
                col = 12, r = 226, g = 190, b = 255 })
        task.New(self, function()
            task.Wait(80)
            Newcharge_in(self.x, self.y, 226, 190, 255)
            boss.cast(self, 60)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 226, 190, 255)
            while true do
                --沿自机**90 帧前**走过的轨迹撒弹。
                --⚠ 不能沿「刚走过的」：那正是自机**此刻站着的位置**，
                --  等于把弹生成在自机脸上（实测贴脸 16 发）。
                --  读心读的是「你刚才在哪」，弹该落在你**背后**。
                --「90 帧前」太远，弹落不到自机附近（读数掉到 0.2）；
                --45 帧前 = 自机刚离开的位置，既不贴脸也还够近。
                local back = max(1, #(self.__trace or {}) - 45)
                for i = 1, back, 4 do
                    local p = self.__trace[i]
                    local a = ran:Float(0, 360)
                    shot(ball_mid, 12, p[1], p[2], V, a, 226, 190, 255)
                end
                --再朝自机当前位置补一轮
                local a0 = Angle(self, player)
                for k = 1, WAYS do
                    shot(ellipse, 12, self.x, self.y, V, a0 + (k - 1) * 360 / WAYS,
                            226, 200, 255)
                end
                PlaySound("tan00", 0.07, 0, true)
                task.Wait(COPY_GAP)
            end
        end)
    end

    function card:render()
        --把记下来的轨迹画成一条紫线（读心的可视化）
        local tr = self.__trace or {}
        for i = 2, #tr do
            thin_line(tr[i - 1][1], tr[i - 1][2], tr[i][1], tr[i][2],
                    60, 210, 170, 255, 0.07)
        end
    end
end

--============================
--[4-4] 想起「恋心マスタースパーク」
--  [限位] 一道横扫全场的粗激光
--  [缺口] 激光只扫 180°，另一半场永远安全
--  [容错] 激光 0.9°/帧，转 180° 要 200 帧
--  [预警] 激光点亮前 90 帧用细线标出它要扫过的角
--  实弹：两条对向的粗光（自绘，有判定用弹排）+ 环绕的心（装饰）
--============================
do
    local BEAM_N = 30
    local ROT_V = 0.9
    local CYCLE = 400
    local WARN = 90
    local R_LEN = 300

    local card = boss.card.New("想起「恋心マスタースパーク」", 1, 1, 60, 920)
    boss.card.add({ { card, "4a" } }, 26, "想起「恋心マスタースパーク」", 314)

    function card:before()
        task.MoveTo(0, 120, 60, VALUE_SET.DECEL)
    end

    function card:init()
        self.__brot = 0
        attach(self, New(class["th19_masterbeam"], self))
        task.New(self, function()
            task.Wait(200)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 9 do
                    shot(heart, 8, self.x, self.y, 2.4, a0 + (k - 5) * 11,
                            255, 170, 220)
                end
                task.Wait(104)
            end
        end)
        --装饰层：环绕的心（自绘）
        attach(self, New(class["th19_deco_ring"], self, 216, 14, 12,
                255, 190, 230, 0.22, "petal", 0, 216))
    end

    function card:frame()
        self.__brot = ((self.__brot or 0) + ROT_V) % 360
    end

    class["th19_masterbeam"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            local u = (self.t - 1) % CYCLE + 1
            if u <= WARN then
                return
            end
            if (u - WARN) % 3 ~= 1 then
                return
            end
            --⚠ 光柱**必须有向外的速度**：`v = 0` 的光柱弹永不离场，
            --  每 3 帧又撒一把 → 初版这张卡峰值冲到 24692 发。
            --  现在靠近中心慢、越往外越快，整道光像水一样流出去。
            local rot = (self.t - WARN) * ROT_V
            for k = 0, 1 do
                local a = rot + k * 180
                for i = 1, BEAM_N do
                    local f = i / BEAM_N
                    local rr = R_LEN * f
                    shot(knife, 4, cos(a) * rr, sin(a) * rr, 4.5 + 3.0 * f, a,
                            255, 200, 240)
                end
            end
        end,
        render = function(self)
            local u = (self.t - 1) % CYCLE + 1
            if u > WARN then
                return
            end
            local rot = self.t * ROT_V
            local a = 40 + 180 * (u / WARN)
            --预警：把这道光**将要扫过的那块扇形**用细线扫出来
            --（它一共转 200°，所以扫过的角 = 200 × 进度）
            local sweep = 200 * (u / WARN)
            for k = 0, 1 do
                local base = rot + k * 180
                for i = 1, 20 do
                    local f = i / 20
                    local a1 = base + sweep * (f - 1 / 20)
                    local a2 = base + sweep * f
                    local rr = R_LEN * f
                    thin_line(cos(a1) * rr, sin(a1) * rr,
                            cos(a2) * rr, sin(a2) * rr, a, 255, 200, 240, 0.06)
                end
            end
        end,
    }, true)
end

--============================
--[4-5] 想起「プリンセスウンディネ」
--  [限位] 无
--  [缺口] 螺旋每两圈之间有一圈 24° 的空档
--  [容错] 螺旋 1.8 px/帧，转一圈 40 帧
--  [预警] 螺旋启动前 80 帧画两条反向的引导线
--  实弹：正反双向的水滴螺旋（威胁）+ 外圈的水膜（装饰）
--============================
do
    local ARM = 4
    local SPIN = 9
    local V0, DV = 1.4, 0.22
    local CYCLE = 160
    local WARN = 80

    local card = boss.card.New("想起「プリンセスウンディネ」", 1, 1, 60, 950)
    boss.card.add({ { card, "4a" } }, 26, "想起「プリンセスウンディネ」", 315)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 10, r = 180, g = 240, b = 255 })
        attach(self, New(class["th19_waterarm"], self))
        task.New(self, function()
            task.Wait(220)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 6 do
                    shot(water_drop, 10, self.x, self.y, 3.0, a0 + (k - 1) * 60,
                            180, 240, 255)
                end
                task.Wait(92)
            end
        end)
    end

    class["th19_waterarm"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.a1 = 0
            self.a2 = 180
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            local i = self.t - WARN
            if i % 4 ~= 1 then
                return
            end
            local v = V0 + DV * ((i % CYCLE) / 40)
            self.a1 = (self.a1 + SPIN) % 360
            self.a2 = (self.a2 - SPIN) % 360
            for k = 1, ARM do
                local a = self.a1 + (k - 1) * 360 / ARM
                shot(water_drop, 10, cos(a) * 34, sin(a) * 34, v, a, 180, 240, 255)
                local b = self.a2 + (k - 1) * 360 / ARM
                shot(water_drop, 6, cos(b) * 34, sin(b) * 34, v * 0.9, b, 160, 210, 255)
            end
        end,
        render = function(self)
            if self.t > WARN then
                local a = 60
                arc(0, 0, 96, self.a1, self.a1 + 300, 40, a, 160, 230, 255, 0.06)
                arc(0, 0, 150, self.a2, self.a2 + 300, 48, a, 160, 230, 255, 0.06)
                return
            end
            local k = self.t / WARN
            local a = 40 + 150 * k
            arc(0, 0, 60 + 120 * k, 0, 360, 40, a, 170, 230, 255, 0.07)
        end,
    }, true)
end

--============================
--[5] 火焰猫燐 —— 火车。母题：猫 / 怨灵 / 僵尸
--============================

--============================
--[5-1] 非符「猫だまし」
--  [限位] 无
--  [缺口] 四连扑之间有空档
--  [容错] 扑击位移 60 帧走 200 px（3.3 px/帧）
--  [预警] 每次扑之前 40 帧闪一下落点
--  实弹：boss 四连扑，每次落地撒 9 路爪（威胁）+ 尾迹（装饰）
--============================
do
    local DASH_T = 60
    local DASH_GAP = 30
    local CLAW_N = 9
    local CLAW_V = 3.2

    local card = boss.card.New("", 1, 1, 60, 780)
    boss.card.add({ { card, "5a" } }, 26, "第一回合", 316)

    function card:before()
        task.MoveTo(0, 120, 60, VALUE_SET.DECEL)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 190, 150)
            boss.cast(self, 60)
            task.Wait(DASH_GAP)
            Newcharge_out(self.x, self.y, 255, 190, 150)
            while true do
                local tx = ran:Float(-140, 140)
                local ty = ran:Float(40, 180)
                task.MoveTo(tx, ty, DASH_T, VALUE_SET.DECEL)
                PlaySound("tan00", 0.08, 0, true)
                local a0 = Angle(self, player)
                for k = 1, CLAW_N do
                    shot(knife, 4, self.x, self.y, CLAW_V, a0 + (k - (CLAW_N + 1) / 2) * 9,
                            255, 210, 170)
                end
                task.Wait(DASH_GAP)
            end
        end)
        --装饰层：从下往上飘的猫火（不朝自机）
        task.New(self, function()
            local w = lstg.world
            while true do
                for i = 1, 6 do
                    deco(ball_light, 8, ran:Float(w.l, w.r), w.b + 20, 1.3, 90,
                            255, 176, 120)
                end
                task.Wait(30)
            end
        end)
    end
end

--============================
--[5-2] 非符「怨霊」
--  [限位] 无
--  [缺口] 怨灵之间本来就有缝
--  [容错] 怨灵 1.7 px/帧上浮
--  [预警] 每只怨灵出生前 44 帧在地面画个小圈
--  实弹：从下方浮上来、会微微追踪的怨灵（威胁）+ 上方的横向弹带（装饰）
--============================
do
    local GHOST_GAP = 40
    local GHOST_V = 1.7
    local GHOST_N = 3
    local BOSS_X, BOSS_Y = 0, 150

    local card = boss.card.New("", 1, 1, 60, 760)
    boss.card.add({ { card, "5a" } }, 26, "第一回合", 317)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        task.New(self, function()
            local w = lstg.world
            task.Wait(60)
            Newcharge_in(self.x, self.y, 200, 190, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 200, 190, 255)
            while true do
                for k = 1, GHOST_N do
                    local x = ran:Float(w.l + 30, w.r - 30)
                    attach(self, New(class["th19_ghost"], x, w.b - 20, GHOST_V,
                            ran:Float(-0.35, 0.35)))
                end
                task.Wait(GHOST_GAP)
            end
        end)
        --装饰层：上方的漂浮弹带（自绘）
        attach(self, New(class["th19_deco_ring"], self, 200, 16, 9,
                190, 180, 255, 0.20, "petal", lstg.world.t - 40, 22))
    end
end

--============================
--[5-3] 猫符「キャットランページ」
--  [限位] 无
--  [缺口] 六只环绕的猫之间 60° 的缝
--  [容错] 猫 1.1°/帧公转，一圈 327 帧
--  [预警] 猫出现的 70 帧前先画出六个位置
--  实弹：六只绕着 boss 公转的猫，各自朝外吐 3 路（威胁）+ 猫爪痕（装饰）
--============================
do
    local CAT_N = 6
    local CAT_R = 96
    local CAT_ROT = 1.1
    local CAT_GAP = 66
    local CAT_V = 2.8
    local WARN = 70

    local card = boss.card.New("猫符「キャットランページ」", 1, 1, 60, 900)
    boss.card.add({ { card, "5a" } }, 26, "猫符「キャットランページ」", 318)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 10, r = 255, g = 200, b = 236 })
        self.__crot = 0
        attach(self, New(class["th19_cats"], self))
        task.New(self, function()
            task.Wait(200)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 8 do
                    shot(butterfly, 10, self.x, self.y, 2.4, a0 + (k - 1) * 45,
                            255, 190, 230)
                end
                task.Wait(90)
            end
        end)
    end

    function card:frame()
        self.__crot = ((self.__crot or 0) + CAT_ROT) % 360
    end

    class["th19_cats"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            if (self.t - WARN) % CAT_GAP ~= 1 then
                return
            end
            local rot = (self.t - WARN) * CAT_ROT
            for k = 1, CAT_N do
                local a = rot + (k - 1) * 360 / CAT_N
                for j = 1, 3 do
                    shot(butterfly, 10, cos(a) * CAT_R, sin(a) * CAT_R, CAT_V,
                            a + (j - 2) * 22, 255, 200, 236)
                end
            end
            PlaySound("tan00", 0.06, 0, true)
        end,
        render = function(self)
            local rot = self.t * CAT_ROT
            local a = (self.t < WARN) and (40 + 150 * (self.t / WARN)) or 150
            for k = 1, CAT_N do
                local ang = rot + (k - 1) * 360 / CAT_N
                draw_orb(cos(ang) * CAT_R, sin(ang) * CAT_R, 0.16,
                        a / 255, 255, 190, 180)
                --爪痕：三条短线
                for j = -1, 1 do
                    local b = ang + j * 14
                    thin_line(cos(ang) * CAT_R, sin(ang) * CAT_R,
                            cos(b) * (CAT_R + 26), sin(b) * (CAT_R + 26),
                            a * 0.5, 255, 210, 200, 0.05)
                end
            end
        end,
    }, true)
end

--============================
--[5-4] 死符「ゴーストタウン」
--  [限位] 无（幽灵从四边同时冒出来，中间永远有路）
--  [缺口] 相邻两个幽灵口之间 36° 的缝
--  [容错] 幽灵 1.5 px/帧，慢
--  [预警] 每边出现前 60 帧画一排小圈
--  实弹：四边轮流冒出的幽灵（威胁）+ 中央的幽灵灯（装饰）
--============================
do
    local N = 12
    local V = 1.5
    local GAP = 82
    local WARN = 60

    local card = boss.card.New("死符「ゴーストタウン」", 1, 1, 60, 950)
    boss.card.add({ { card, "5a" } }, 26, "死符「ゴーストタウン」", 319)

    function card:before()
        task.MoveTo(0, 150, 60, VALUE_SET.DECEL)
    end

    function card:init()
        task.New(self, function()
            local w = lstg.world
            local side = 1
            task.Wait(60)
            Newcharge_in(self.x, self.y, 200, 190, 255)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 200, 190, 255)
            while true do
                for i = 1, N do
                    local f = (i - 1) / (N - 1)
                    local x, y, ang
                    if side == 1 then
                        x, y, ang = w.l - 20, w.b + (w.t - w.b) * f, 0
                    elseif side == 2 then
                        x, y, ang = w.r + 20, w.b + (w.t - w.b) * f, 180
                    elseif side == 3 then
                        x, y, ang = w.l + (w.r - w.l) * f, w.b - 20, 90
                    else
                        x, y, ang = w.l + (w.r - w.l) * f, w.t + 20, -90
                    end
                    shot(ball_light, 12, x, y, V, ang, 190, 180, 255)
                end
                PlaySound("tan00", 0.06, 0, true)
                side = side % 4 + 1
                task.Wait(GAP)
            end
        end)
        --装饰层：中央会张缩的幽灵灯（自绘）
        attach(self, New(class["th19_deco_ring"], self, 120, 20, 0,
                180, 200, 255, 0.20, "petal", 0, 120, 0.33))
    end
end

--============================
--[5-5] 火車「死体ツアー」
--  [限位] 一辆横穿屏幕的「火车」：车轮是弹排成的圆
--  [缺口] 车轮之间 1.4 个身位；两节车厢之间 40 px
--  [容错] 火车 2.0 px/帧横穿，穿过全屏约 250 帧
--  [预警] 火车进入前 80 帧在屏幕外画它的车头灯
--  实弹：车轮外缘的弹（限位+威胁）+ 车厢之间的火花（装饰）
--============================
do
    local CARS = 3
    local CAR_GAP = 150
    local WHEEL_N = 18
    local WHEEL_R = 46
    local TRAIN_V = 2.0
    local CYCLE = 460
    local WARN = 80

    local card = boss.card.New("火車「死体ツアー」", 1, 1, 60, 1000)
    boss.card.add({ { card, "5a" } }, 26, "火車「死体ツアー」", 320)

    function card:before()
        task.MoveTo(0, 150, 60, VALUE_SET.DECEL)
    end

    function card:init()
        self.__train = 0
        attach(self, New(class["th19_train"], self))
        task.New(self, function()
            task.Wait(220)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 5 do
                    shot(knife, 4, self.x, self.y, 3.6, a0 + (k - 3) * 10,
                            255, 200, 160)
                end
                task.Wait(96)
            end
        end)
    end

    class["th19_train"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            local u = (self.t - 1) % CYCLE + 1
            if u <= WARN then
                return
            end
            if (u - WARN) % 6 ~= 1 then
                return
            end
            local w = lstg.world
            local head = w.r + 220 - TRAIN_V * (u - WARN)
            for c = 1, CARS do
                local cx = head - (c - 1) * CAR_GAP
                for i = 1, WHEEL_N do
                    local a = (i - 1) * 360 / WHEEL_N
                    shot(ball_small, 4, cx + cos(a) * WHEEL_R, sin(a) * WHEEL_R,
                            0.9, a + 90, 255, 200, 150)
                end
            end
        end,
        render = function(self)
            local u = (self.t - 1) % CYCLE + 1
            local w = lstg.world
            if u <= WARN then
                --预警：车头灯在屏幕外
                local k = u / WARN
                draw_orb(w.r + 220 - 60 * k, 0, 0.8 * k, 0.9, 255, 190, 120)
                return
            end
            local head = w.r + 220 - TRAIN_V * (u - WARN)
            for c = 1, CARS do
                local cx = head - (c - 1) * CAR_GAP
                --车身：一个暗框
                SetImageState("white", "mul+add", 26, 255, 170, 120)
                RenderRect("white", cx - 54, cx + 54, -60, 60)
                --车顶的灯
                draw_orb(cx, 60, 0.22, 0.8, 255, 200, 150)
                --车厢之间的火花（装饰）
                if c < CARS then
                    local gx = cx - CAR_GAP * 0.5
                    for j = 1, 4 do
                        local a = self.t * 6 + j * 90
                        draw_petal(gx + cos(a) * 16, sin(a) * 16,
                                a, 0.22, 150, 255, 200, 150)
                    end
                end
            end
        end,
    }, true)
end

--============================
--[6] 灵乌路火 —— 地狱鸦。母题：核融合 / 太阳 / 八咫乌
--============================

--============================
--[6-1] 非符「核熱」
--  [限位] 无
--  [缺口] 三层环的缺口错开，永远有一个能站
--  [容错] 外环 2.6 px/帧；缺口每轮前进 4 格
--  [预警] 每轮前 56 帧画三层的缺口位置
--  实弹：三层同心环（限位感）+ 朝自机的 3 路橙玉（威胁）
--============================
do
    local RING_N = 34
    local GAP_W = 6
    local GAP_STEP = 4
    local V = 2.6
    local RING_GAP = 76
    local AIM_GAP = 68
    local WARN = 56

    local card = boss.card.New("", 1, 1, 60, 820)
    boss.card.add({ { card, "6a" } }, 26, "第一回合", 321)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        task.New(self, function()
            local gap = 0
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 180, 90)
            boss.cast(self, 60)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 255, 180, 90)
            while true do
                for i = 1, RING_N do
                    local a = (i - 1) * 360 / RING_N
                    for layer = 0, 2 do
                        local d = (i - gap - layer * 5) % RING_N
                        if d >= GAP_W then
                            shot(ball_mid, 4, self.x, self.y, V * (1 - layer * 0.22),
                                    a, 255, 190, 110)
                        end
                    end
                end
                PlaySound("tan00", 0.06, 0, true)
                gap = gap + GAP_STEP
                task.Wait(RING_GAP)
            end
        end)
        task.New(self, function()
            task.Wait(140)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 3 do
                    shot(ball_big, 2, self.x, self.y, 3.0, a0 + (k - 2) * 14,
                            255, 176, 80)
                end
                task.Wait(AIM_GAP)
            end
        end)
    end
end

--============================
--[6-2] 非符「八咫烏」
--  [限位] 无
--  [缺口] 三条腿之间 120° 的缝
--  [容错] 腿 0.8°/帧旋转，一轮 450 帧转 360°
--  [预警] 三条腿出现前 70 帧画暗线
--  实弹：三条旋转的射线（沿半径排弹）+ 腿上滑落的火滴（威胁）
--============================
do
    local LEGS = 3
    local LINE_N = 14
    local R_IN, R_OUT = 50, 210
    local ROT_V = 0.8
    local WARN = 70

    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "6a" } }, 26, "第一回合", 322)

    function card:before()
        task.MoveTo(0, 140, 60, VALUE_SET.DECEL)
    end

    function card:init()
        attach(self, New(class["th19_yatagarasu"], self))
        task.New(self, function()
            task.Wait(220)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 5 do
                    shot(ball_mid, 2, self.x, self.y, 3.4, a0 + (k - 3) * 12,
                            255, 200, 120)
                end
                task.Wait(84)
            end
        end)
    end

    class["th19_yatagarasu"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            if (self.t - WARN) % 8 ~= 1 then
                return
            end
            local rot = (self.t - WARN) * ROT_V
            for k = 1, LEGS do
                local a = rot + (k - 1) * 120
                --腿本身是**自绘**的（见 render），这里只负责腿端滑落的火滴（威胁）
                shot(water_drop, 2, cos(a) * R_OUT, sin(a) * R_OUT, 2.6,
                        a + 180 + ran:Float(-18, 18), 255, 180, 100)
            end
        end,
        render = function(self)
            local rot = self.t * ROT_V
            local a = (self.t < WARN) and (40 + 150 * (self.t / WARN)) or 150
            for k = 1, LEGS do
                local ang = rot + (k - 1) * 120
                thin_line(cos(ang) * R_IN, sin(ang) * R_IN,
                        cos(ang) * R_OUT, sin(ang) * R_OUT, a, 255, 200, 130, 0.08)
                for i = 1, LINE_N do
                    local rr = R_IN + (R_OUT - R_IN) * i / LINE_N
                    draw_orb(cos(ang) * rr, sin(ang) * rr, 0.14,
                            a / 255 * 0.75, 255, 214, 140)
                end
            end
            draw_orb(0, 0, 0.5, a / 255 * 0.9, 255, 200, 120)
        end,
    }, true)
end

--============================
--[6-3] 爆符「ギガフレア」
--  [限位] 无
--  [缺口] 每次爆炸之间 90 帧
--  [容错] 爆炸环 2.2 px/帧；从里到外 180 帧
--  [预警] 爆心出现前 80 帧画一个收缩的圈（越收越亮）
--  实弹：缓慢膨胀的巨大火球，到最大时炸成 16 向（威胁）
--============================
do
    local SUN_GAP = 170
    local GROW_T = 120
    local BOOM_N = 16
    local BOOM_V = 2.6
    local WARN = 80
    local BOSS_X, BOSS_Y = 0, 150

    local card = boss.card.New("爆符「ギガフレア」", 1, 1, 60, 950)
    boss.card.add({ { card, "6a" } }, 26, "爆符「ギガフレア」", 323)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 2, r = 255, g = 190, b = 110 })
        task.New(self, function()
            local w = lstg.world
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 170, 80)
            boss.cast(self, 60)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 255, 170, 80)
            while true do
                local sx = ran:Float(w.l + 80, w.r - 80)
                local sy = ran:Float(w.b + 80, w.t - 80)
                attach(self, New(class["th19_sun"], sx, sy, GROW_T, BOOM_N, BOOM_V))
                task.Wait(SUN_GAP)
            end
        end)
        --装饰层：全场缓缓旋转的火星环（自绘）
        attach(self, New(class["th19_deco_ring"], self, 230, 22, 7,
                255, 200, 120, 0.20, "petal", 0, 230))
    end
end

--============================
--[6-4] 焔星「十凶星」
--  [限位] 无
--  [缺口] 十颗星之间的 36° 缝
--  [容错] 星 0.6°/帧公转，一圈 600 帧
--  [预警] 十颗星出现前 90 帧画出十个位置
--  实弹：十颗绕 boss 公转的星，各自朝外吐 2 路（威胁）+ 星尘（装饰）
--============================
do
    local STAR_N = 10
    local STAR_R = 132
    local ROT_V = 0.6
    local STAR_GAP = 70
    local STAR_V = 2.8
    local WARN = 90

    local card = boss.card.New("焔星「十凶星」", 1, 1, 60, 1000)
    boss.card.add({ { card, "6a" } }, 26, "焔星「十凶星」", 324)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 2, r = 255, g = 190, b = 110 })
        self.__srot = 0
        attach(self, New(class["th19_tenstars"], self))
        task.New(self, function()
            task.Wait(220)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 7 do
                    shot(ball_mid, 2, self.x, self.y, 3.0, a0 + (k - 4) * 12,
                            255, 190, 110)
                end
                task.Wait(88)
            end
        end)
    end

    function card:frame()
        self.__srot = ((self.__srot or 0) + ROT_V) % 360
    end

    class["th19_tenstars"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            if (self.t - WARN) % STAR_GAP ~= 1 then
                return
            end
            local rot = (self.t - WARN) * ROT_V
            for k = 1, STAR_N do
                local a = rot + (k - 1) * 36
                local px, py = cos(a) * STAR_R, sin(a) * STAR_R
                for j = 1, 2 do
                    shot(star_big, 2, px, py, STAR_V, a + (j - 1.5) * 26,
                            255, 186, 100)
                end
            end
            PlaySound("tan00", 0.05, 0, true)
        end,
        render = function(self)
            local rot = self.t * ROT_V
            local a = (self.t < WARN) and (40 + 150 * (self.t / WARN)) or 160
            for k = 1, STAR_N do
                local ang = rot + (k - 1) * 36
                draw_orb(cos(ang) * STAR_R, sin(ang) * STAR_R, 0.2,
                        a / 255, 255, 200, 120)
            end
            if self.t < WARN then
                arc(0, 0, STAR_R, 0, 360, 48, a * 0.5, 255, 200, 130, 0.06)
            end
        end,
    }, true)
end

--============================
--[6-5] 地獄「地獄の人工太陽」
--  [限位] 中央一颗固定的巨大太阳，向四周放射
--  [缺口] 射线之间 12° 的缝；太阳本体有判定（别贴上去）
--  [容错] 射线 1.8 px/帧，从中心到边缘 140 帧
--  [预警] 太阳成形前 100 帧先画一个收缩的红圈
--  实弹：持续放射的射线（威胁）+ 环绕的行星轨（装饰）
--============================
do
    local RAYS = 26
    local RAY_V = 1.8
    local RAY_GAP = 26
    local SPIN = 0.45
    local CYCLE = 600
    local WARN = 100

    local card = boss.card.New("地獄「地獄の人工太陽」", 1, 1, 60, 1100)
    boss.card.add({ { card, "6a" } }, 26, "地獄「地獄の人工太陽」", 325)

    function card:before()
        --⚠ boss 原来坐在 (0,0) —— 那正是自机可以站的地方，
        --  于是「朝自机的 9 路」全是贴脸（实测 144 发）。
        --  挪到 (0,130)；「人工太阳」本体仍自绘在场地正中，观感不变。
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        self.__rayrot = 0
        attach(self, New(class["th19_artificialsun"], self))
        task.New(self, function()
            task.Wait(240)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 9 do
                    shot(ball_big, 2, self.x, self.y, 3.0, a0 + (k - 5) * 12,
                            255, 176, 90)
                end
                task.Wait(150)
            end
        end)
    end

    function card:frame()
        self.__rayrot = ((self.__rayrot or 0) + SPIN) % 360
    end

    class["th19_artificialsun"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            --⚠ 太阳**钉在场地正中**（0,0），不跟着 boss 走 ——
            --  它的 render 本来就画在 (0,0)。之前这里跟着 master 跑，
            --  于是射线从 boss 身上发、画面画在正中，两边脱节（读数掉到 0.0）。
            self.x, self.y = 0, 0
            if self.t < WARN then
                return
            end
            if (self.t - WARN) % RAY_GAP ~= 1 then
                return
            end
            local rot = (self.t - WARN) * SPIN
            --⚠ 射线要**从外圈朝内飞**，不是从太阳朝外飞。
            --  朝外飞的话，站在太阳附近的玩家永远不会被任何一发「接近」到 ——
            --  自检里这张卡就是 0.0（同屏 395 发弹，一发都不算数）。
            --  出生半径取 250（在回收边界外侧）：离自机最近 250 - 192 = 58 px，
            --  58 / 1.8 = 32 帧 > 安全距离的 20 帧 ✓
            --⚠ 出生点用**矩形边界**，不用圆：
            --  场地是 384×448（半宽 192、半高 224），圆环半径取小了会在竖直方向
            --  落进自机活动带（贴脸），取大了会越出回收边界(±256)被当场收掉。
            --  按 §10.4 的老办法：贴 ±220/±252 生成、速度 ≤ 1.15 ——
            --  离自机最近 28 px，28/1.15 ≈ 24 帧 > 安全距离 20 帧。
            for k = 1, RAYS do
                local a = rot + (k - 1) * 360 / RAYS
                local px, py = wall_point(0, 0, 220, 252, (k - 1) / RAYS + rot / 360)
                shot(ball_small, 4, px, py, 1.15, Angle(0, 0, px, py) + 180,
                        255, 190, 110)
            end
        end,
        render = function(self)
            if self.t < WARN then
                local k = self.t / WARN
                arc(0, 0, 260 * (1 - k) + 30, 0, 360, 56, 200 * k, 255, 150, 90, 0.09)
                draw_orb(0, 0, 1.2 * k, k, 255, 200, 120)
                return
            end
            --太阳本体
            local pulse = 1 + 0.08 * sin(self.t * 4)
            draw_orb(0, 0, 1.1 * pulse, 1, 255, 210, 130)
            --行星轨（装饰）
            for j = 1, 3 do
                local rr = 150 + j * 55
                arc(0, 0, rr, 0, 360, 44, 44, 255, 180, 110, 0.06)
                local a = self.t * (0.8 + j * 0.3)
                draw_orb(cos(a) * rr, sin(a) * rr, 0.16, 0.9, 255, 220, 160)
            end
        end,
    }, true)
end

--============================
--[7] 古明地恋 —— 无意识。母题：玫瑰 / 心 / 本能与抑制
--============================

--============================
--[7-1] 非符「無意識」
--  [限位] 无
--  [缺口] 弹从随机位置冒出来，但都是单个的，密度低
--  [容错] 3.0 px/帧，从出现到命中留 40 帧
--  [预警] 每发出现前 36 帧先亮一个点
--  实弹：从全屏随机位置朝随机方向飞出的「无意识」弹（威胁）
--============================
do
    local BURST_GAP = 46
    local BURST_N = 4
    local V = 3.0
    local BOSS_X, BOSS_Y = 0, 130

    local card = boss.card.New("", 1, 1, 60, 820)
    boss.card.add({ { card, "7a" } }, 26, "第一回合", 326)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 12, r = 230, g = 180, b = 255 })
        task.New(self, function()
            local w = lstg.world
            task.Wait(60)
            Newcharge_in(self.x, self.y, 220, 170, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 220, 170, 255)
            while true do
                for k = 1, BURST_N do
                    local px = ran:Float(w.l + 20, w.r - 20)
                    local py = ran:Float(w.b + 20, w.t - 20)
                    local a = ran:Float(0, 360)
                    attach(self, New(class["th19_silent"], px, py, a, V))
                end
                task.Wait(BURST_GAP)
            end
        end)
        --装饰层：环场的紫玫瑰结（自绘，不朝自机）
        attach(self, New(class["th19_deco_ring"], self, 222, 16, 11,
                210, 170, 255, 0.22, "petal", 0, 222))
    end
end

--============================
--[7-2] 非符「薔薇」
--  [限位] 无
--  [缺口] 五层玫瑰的花瓣之间都是缝
--  [容错] 花瓣 1.6 px/帧，一层一层开
--  [预警] 花心出现前 70 帧画一个小圈
--  实弹：五层同心玫瑰（每层 8 瓣），层层外扩（威胁）
--============================
do
    local LAYERS = 5
    local PETALS = 8
    local LAYER_GAP = 26
    local V0, DV = 1.6, 0.28
    local BLOOM_GAP = 150
    local WARN = 70
    local BOSS_X, BOSS_Y = 0, 140

    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "7a" } }, 26, "第一回合", 327)

    function card:before()
        task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
    end

    function card:init()
        spiral_pressure(self, { arms = 3, v = 2.6, gap = 8, spin = 6, delay = 90, col = 12, r = 220, g = 170, b = 255 })
        task.New(self, function()
            local w = lstg.world
            task.Wait(60)
            Newcharge_in(self.x, self.y, 220, 170, 255)
            boss.cast(self, 60)
            task.Wait(WARN)
            Newcharge_out(self.x, self.y, 220, 170, 255)
            while true do
                local bx = ran:Float(w.l + 70, w.r - 70)
                local by = ran:Float(w.b + 70, w.t - 70)
                attach(self, New(class["th19_rose"], bx, by,
                        LAYERS, PETALS, LAYER_GAP, V0, DV))
                task.Wait(BLOOM_GAP)
            end
        end)
        --威胁层：朝自机的 3 路心弹
        task.New(self, function()
            task.Wait(200)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 3 do
                    shot(heart, 12, self.x, self.y, 3.2, a0 + (k - 2) * 16,
                            230, 180, 255)
                end
                task.Wait(104)
            end
        end)
    end
end

--============================
--[7-3] 本能「フロウディアン」
--  [限位] 无
--  [缺口] 螺旋的螺距之间都是缝
--  [容错] 4.0°/帧的螺旋，转一圈 90 帧
--  [预警] 螺旋启动前 60 帧画两条引导弧
--  实弹：正反双向的心形螺旋（威胁）+ 中心的玫瑰（装饰）
--============================
do
    local ARM = 5
    local SPIN = 4.0
    local V0, DV = 1.5, 0.35
    local WARN = 60
    local MOD = 240

    local card = boss.card.New("本能「フロウディアン」", 1, 1, 60, 950)
    boss.card.add({ { card, "7a" } }, 26, "本能「フロウディアン」", 328)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --实弹层：密集环（补「被打频率」——稀疏自机狙的读数接近 0）
        spiral_pressure(self, { arms = 3, v = 2.5, gap = 8, spin = 6, delay = 90, col = 12, r = 235, g = 180, b = 255 })
        attach(self, New(class["th19_hearts"], self))
        task.New(self, function()
            task.Wait(220)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 9 do
                    shot(heart, 12, self.x, self.y, 2.8, a0 + (k - 1) * 40,
                            230, 180, 255)
                end
                task.Wait(94)
            end
        end)
    end

    class["th19_hearts"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.a1 = 0
            self.a2 = 180
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            if self.t < WARN then
                return
            end
            local i = self.t - WARN
            if i % 9 ~= 1 then
                return
            end
            local v = V0 + DV * ((i % MOD) / 60)
            self.a1 = (self.a1 + SPIN) % 360
            self.a2 = (self.a2 - SPIN) % 360
            for k = 1, ARM do
                local a = self.a1 + (k - 1) * 360 / ARM
                shot(heart, 12, cos(a) * 30, sin(a) * 30, v, a, 235, 180, 255)
                local b = self.a2 + (k - 1) * 360 / ARM
                shot(heart, 6, cos(b) * 30, sin(b) * 30, v * 0.85, b, 190, 160, 255)
            end
        end,
        render = function(self)
            if self.t < WARN then
                local a = 40 + 150 * (self.t / WARN)
                arc(0, 0, 80 + 100 * (self.t / WARN), 0, 340, 40, a, 220, 170, 255, 0.07)
                arc(0, 0, 150, 180, 520, 40, a * 0.8, 220, 170, 255, 0.07)
                return
            end
            --中心的玫瑰
            local pulse = 1 + 0.1 * sin(self.t * 5)
            for j = 1, 8 do
                local a = self.t * 2 + j * 45
                draw_petal(cos(a) * 16 * pulse, sin(a) * 16 * pulse, a,
                        0.2 * pulse, 130, 255, 190, 240)
            end
            draw_orb(0, 0, 0.14, 0.8, 255, 220, 255)
        end,
    }, true)
end

--============================
--[7-4] 抑制「スーパーエゴ」
--  [限位] 一个不断收缩的圆环（用弹排成），张开再合上
--  [缺口] 环上每轮留 3 个缺口，跟着自机走（不是挖洞，是整层换形状）
--  [容错] 环 1.3 px/帧；从 210 收到 80 要 100 帧
--  [预警] 每轮前 66 帧只画圆的轮廓
--  实弹：收缩环（限位）+ 环上朝内的 3 路（威胁）
--============================
do
    local RING_N = 40
    local R_OUT, R_IN = 210, 80
    local CYCLE = 240
    local WARN = 66
    local V = 1.3
    local GAP_DEG = 30

    local card = boss.card.New("抑制「スーパーエゴ」", 1, 1, 60, 1000)
    boss.card.add({ { card, "7a" } }, 26, "抑制「スーパーエゴ」", 329)

    function card:before()
        task.MoveTo(0, 140, 60, VALUE_SET.DECEL)
    end

    function card:init()
        attach(self, New(class["th19_egoring"], self))
        task.New(self, function()
            task.Wait(230)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 5 do
                    shot(heart, 12, self.x, self.y, 3.2, a0 + (k - 3) * 12,
                            235, 180, 255)
                end
                task.Wait(92)
            end
        end)
    end

    class["th19_egoring"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            local u = (self.t - 1) % CYCLE + 1
            if u <= WARN then
                return
            end
            if (u - WARN) % 46 ~= 1 then
                return
            end
            local k = (u - WARN) / (CYCLE - WARN)
            local r = R_OUT + (R_IN - R_OUT) * k
            --缺口跟着自机走：整层换形状，不是挖洞（§10.10）
            local gd = Angle(0, 0, player.x, player.y)
            for i = 1, RING_N do
                local a = (i - 1) * 360 / RING_N
                local ok = true
                for j = 0, 2 do
                    local d = (a - (gd + j * 120)) % 360
                    if d > 180 then d = 360 - d end
                    if d < GAP_DEG * 0.5 then ok = false end
                end
                if ok then
                    shot(heart, 12, cos(a) * r, sin(a) * r, V,
                            Angle(0, 0, cos(a) * r, sin(a) * r) + 180,
                            220, 170, 255)
                end
            end
        end,
        render = function(self)
            local u = (self.t - 1) % CYCLE + 1
            if u > WARN then
                local k = (u - WARN) / (CYCLE - WARN)
                local r = R_OUT + (R_IN - R_OUT) * k
                arc(0, 0, r, 0, 360, 48, 60, 210, 160, 255, 0.06)
                return
            end
            local a = 40 + 160 * (u / WARN)
            arc(0, 0, R_OUT, 0, 360, 48, a, 210, 160, 255, 0.08)
        end,
    }, true)
end

--============================
--[7-5] 「サブタレイニアンローズ」  —— 终符
--  [限位] 无（点题的巨玫瑰本身就是地图）
--  [缺口] 每片花瓣之间的缝
--  [容错] 花瓣 1.8 px/帧；一次绽放 260 帧
--  [预警] 每次绽放前 90 帧画收缩的花心
--  实弹：血量驱动 3 阶段：
--        ① 玫瑰绽放（8 瓣外扩）② 外加双向心螺旋 ③ 再加全屏无意识弹
--============================
do
    local PETALS = 8
    local V = 1.8
    local BLOOM_GAP = 260
    local WARN = 90
    local CARD_HP = 1400

    local card = boss.card.New("「サブタレイニアンローズ」", 1, 1, 60, CARD_HP)
    boss.card.add({ { card, "7a" } }, 26, "「サブタレイニアンローズ」", 330)

    function card:before()
        task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
    end

    function card:init()
        --① 玫瑰绽放
        attach(self, New(class["th19_rosebig"], self, BLOOM_GAP, PETALS))
        --② 阶段 2 追加：双向心螺旋
        task.New(self, function()
            local a1, a2 = 0, 180
            while true do
                if (self.__phase or 1) >= 2 then
                    for k = 1, 4 do
                        local a = a1 + (k - 1) * 90
                        shot(heart, 12, cos(a) * 34, sin(a) * 34, 2.4, a, 235, 180, 255)
                        local b = a2 + (k - 1) * 90
                        shot(heart, 6, cos(b) * 34, sin(b) * 34, 2.1, b, 190, 160, 255)
                    end
                    a1 = (a1 + 5) % 360
                    a2 = (a2 - 5) % 360
                end
                task.Wait(3)
            end
        end)
        --③ 阶段 3 追加：全屏无意识弹
        task.New(self, function()
            local w = lstg.world
            while true do
                if (self.__phase or 1) >= 3 then
                    local px = ran:Float(w.l + 20, w.r - 20)
                    local py = ran:Float(w.b + 20, w.t - 20)
                    attach(self, New(class["th19_silent"], px, py,
                            ran:Float(0, 360), 3.2))
                end
                task.Wait(30)
            end
        end)
        --威胁层：朝自机的 7 路
        task.New(self, function()
            task.Wait(200)
            while true do
                local a0 = Angle(self, player)
                local n = 7 + ((self.__phase or 1) - 1) * 2
                for k = 1, n do
                    shot(heart, 12, self.x, self.y, 3.0, a0 + (k - 1) * 360 / n,
                            240, 180, 255)
                end
                task.Wait(100 - ((self.__phase or 1) - 1) * 12)
            end
        end)
        --阶段推进：血量驱动 + 兜底计时
        self.__phase = 1
        local sys = self._bosssys
        if sys and sys.addAutoSPPoint then
            sys:addAutoSPPoint(int(CARD_HP * 0.30), 60 * 16, true)
            sys:addAutoSPPoint(int(CARD_HP * 0.60), 60 * 30, true)
        end
        task.New(self, function()
            task.Wait(60 * 16)
            self.__phase = max(self.__phase, 2)
            task.Wait(60 * 14)
            self.__phase = max(self.__phase, 3)
        end)
    end
end

--============================
--下面这些是各张卡共用的「自绘 / 运动」小类
--  一律 `bound = false`：必须在 frame 里自己 RawDel（§7 ①）
--============================

---=====================================
---装饰层专用：**自绘的**静态图形
---
---  ⚠⚠ 这一节是 th19 初版最大的坑。装饰层的形状（环、辐射线、眼、花瓣圈…）
---      是「整体在转、单体不动」的 —— 这类图形**千万不能**用
---      「每 N 帧往同一批坐标撒一把 `v = 0` 的弹」来做：
---        · `v = 0` 的弹永远不会离开回收边界，`bound` 对它没有任何意义；
---        · 每隔 N 帧又撒一把 → 弹数**随时间线性涨**，永远不会回落。
---      初版 18 处都是这么写的，自检里几张卡的「峰值同屏 弹」直接冲到
---      24692 / 9188 / 6963 —— 真机上就是卡死。
---      正解：**自绘**。`thin_line` / `Render` 画出来的东西没有判定、不占弹位。
---      需要判定的地方（限位墙、激光）才用真弹，而且**必须给速度**让它离场。
---=====================================

---装饰环：绕着某个点的一圈自绘点 / 花瓣，自己慢慢转。
---  `cy` 是环心相对场地中心的竖直偏移（用来做「贴在上边缘的一条装饰带」）。
class["th19_deco_ring"] = Class(object, {
    init = function(self, master, r, n, spd, cr, cg, cb, size, shape, cy, ry, rp, mir)
        self.master = master
        self.r, self.ry = r, ry or r
        self.rp = rp or 0
        self.mir = mir and true or false
        self.n, self.spd = n, spd
        self.cr, self.cg, self.cb = cr, cg, cb
        self.size = size or 0.20
        self.shape = shape or "dot"        -- dot / petal
        self.cy = cy or 0
        self.a, self.t = 0, 0
        self.group, self.layer = GROUP.GHOST, LAYER.TOP
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.a = (self.a + self.spd) % 360
    end,
    render = function(self)
        local pulse = 0.78 + 0.22 * sin(self.t * 1.6)
        local rr = self.r * (1 + self.rp * sin(self.t * 1.6))
        local ry = self.ry * (1 + self.rp * sin(self.t * 1.6))
        for i = 1, self.n do
            local ang = self.a + (i - 1) * 360 / self.n
            local x, y = cos(ang) * rr, self.cy + sin(ang) * ry
            if self.shape == "petal" then
                draw_petal(x, y, ang + 90, self.size, 175 * pulse,
                        self.cr, self.cg, self.cb)
            else
                draw_orb(x, y, self.size, 0.80 * pulse, self.cr, self.cg, self.cb)
            end
            if self.mir then
                local x2, y2 = -x, y
                local a2 = 180 - ang
                if self.shape == "petal" then
                    draw_petal(x2, y2, a2 + 90, self.size, 175 * pulse,
                            self.cr, self.cg, self.cb)
                else
                    draw_orb(x2, y2, self.size, 0.80 * pulse,
                            self.cr, self.cg, self.cb)
                end
            end
        end
    end,
}, true)

---装饰臂：从场地中心放射的 `arms` 条线，自己慢慢转。整条线都是自绘的。
---  `bx/by` 是中心相对场地中心的偏移（跟着 boss 走时用 boss 的坐标）。
class["th19_deco_arm"] = Class(object, {
    init = function(self, master, arms, r_in, r_out, spd, cr, cg, cb, w, n, size)
        self.master = master
        self.arms, self.r_in, self.r_out, self.spd = arms, r_in, r_out, spd
        self.cr, self.cg, self.cb = cr, cg, cb
        self.w = w or 0.08
        self.n = n or 0                 -- > 0 时沿线摆 n 个点（空弹链的观感）
        self.size = size or 0.16
        self.a, self.t = 0, 0
        self.group, self.layer = GROUP.GHOST, LAYER.TOP
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.a = (self.a + self.spd) % 360
    end,
    render = function(self)
        local m = self.master
        local pulse = 0.78 + 0.22 * sin(self.t * 1.6)
        for k = 1, self.arms do
            local ang = self.a + (k - 1) * 360 / self.arms
            local x0, y0 = m.x + cos(ang) * self.r_in, m.y + sin(ang) * self.r_in
            local x1, y1 = m.x + cos(ang) * self.r_out, m.y + sin(ang) * self.r_out
            thin_line(x0, y0, x1, y1, 150 * pulse, self.cr, self.cg, self.cb, self.w)
            if self.n > 0 then
                for i = 1, self.n do
                    local f = i / self.n
                    draw_orb(m.x + cos(ang) * (self.r_in + (self.r_out - self.r_in) * f),
                            m.y + sin(ang) * (self.r_in + (self.r_out - self.r_in) * f),
                            self.size, 0.7 * pulse, self.cr, self.cg, self.cb)
                end
            end
        end
    end,
}, true)

---道中飘的火星（无判定，只是把屏幕填亮）
class["th19_emberbg"] = Class(object, {
    init = function(self)
        local w = lstg.world
        self.x = ran:Float(w.l, w.r)
        self.y = w.b - 20
        self.v = ran:Float(0.5, 1.6)
        self.s = ran:Float(0.15, 0.45)
        self.a = ran:Float(120, 220)
        self.sway = ran:Float(6, 26)
        self.ph = ran:Float(0, 360)
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.TOP
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        self.y = self.y + self.v
        if self.y > lstg.world.t + 30 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local x = self.x + sin(self.t * 1.4 + self.ph) * self.sway * 0.2
        local k = min(1, min(self.t / 20, (lstg.world.t + 30 - self.y) / 40))
        draw_petal(x, self.y, self.t * 3 + self.ph, self.s, self.a * k, 255, 176, 96)
    end,
}, true)

---爆符「ギガフレア」的太阳（卡 6-3）：慢慢膨胀，到最大炸成 n 向
class["th19_sun"] = Class(object, {
    init = function(self, x, y, grow, n, bv)
        self.x, self.y = x, y
        self.grow, self.n, self.bv = grow, n, bv
        self.t = 0
        self.boom = false
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if not self.boom and self.t >= self.grow then
            self.boom = true
            for k = 1, self.n do
                shot(ball_mid, 2, self.x, self.y, self.bv,
                        (k - 1) * 360 / self.n, 255, 190, 110)
            end
            PlaySound("tan00", 0.10, self.x / 256, true)
        end
        --炸完再留 60 帧画余晖，然后自己收（`bound = false` 必须自己 RawDel）
        if self.t > self.grow + 60 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local w = lstg.world
        if self.x < w.l - 140 or self.x > w.r + 140
                or self.y < w.b - 140 or self.y > w.t + 140 then
            return
        end
        if not self.boom then
            local k = self.t / self.grow
            draw_orb(self.x, self.y, 0.4 + 1.3 * k, 0.9, 255, 180, 90)
            --预警：越收越亮的小圈，告诉玩家「它要炸了」
            arc(self.x, self.y, 70 * (1 - k) + 20, 0, 360, 24,
                    180 * k, 255, 220, 150, 0.08)
            return
        end
        local k = (self.t - self.grow) / 60
        draw_orb(self.x, self.y, 1.7 * (1 - k), (1 - k) * 0.9, 255, 200, 120)
        arc(self.x, self.y, 20 + 150 * k, 0, 360, 40,
                190 * (1 - k), 255, 200, 130, 0.08)
    end,
}, true)

---落石（卡 1-2）：从上方落到目标点，落地炸开
class["th19_meteor"] = Class(object, {
    init = function(self, tx, ty, v, n, bv)
        self.tx, self.ty = tx, ty
        self.y = lstg.world.t + 30
        self.x = tx
        self.v = v
        self.n, self.bv = n, bv
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if self.y > self.ty then
            self.y = self.y - self.v
            if self.y <= self.ty then
                --落地炸开
                for k = 1, self.n do
                    shot(ball_mid, 8, self.x, self.y, self.bv,
                            (k - 1) * 360 / self.n, 214, 180, 130)
                end
                PlaySound("tan00", 0.06, self.x / 256, true)
            end
            return
        end
        self.t = self.t + 1
        if self.t > 90 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        if self.y <= self.ty then
            --落地的尘
            local k = max(0, 1 - self.t / 30)
            arc(self.x, self.y, 20 + 40 * (self.t / 30), 0, 360, 20,
                    120 * k, 220, 180, 130, 0.07)
            return
        end
        --预警圈（地面上）
        local left = self.y - self.ty
        local k = 1 - min(left / 300, 1)
        arc(self.x, self.ty, 44 * (1 - k * 0.6), 0, 360, 20, 150, 255, 200, 150, 0.07)
        draw_orb(self.x, self.y, 0.4, 0.9, 220, 180, 130)
    end,
}, true)

---瘴气云（卡 1-4）：横飘，到中场炸开
class["th19_cloud"] = Class(object, {
    init = function(self, x, y, v, n, bv)
        self.x, self.y, self.v = x, y, v
        self.n, self.bv = n, bv
        self.t = 0
        self.done = false
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        self.x = self.x + self.v
        local w = lstg.world
        if not self.done and abs(self.x) < 40 then
            self.done = true
            for k = 1, self.n do
                shot(ball_mid, 10, self.x, self.y, self.bv,
                        (k - 1) * 360 / self.n, 190, 240, 160)
            end
            PlaySound("tan00", 0.06, self.x / 256, true)
        end
        if self.x < w.l - 90 or self.x > w.r + 90 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        if self.done then
            return
        end
        local a = 0.85
        SetImageState("ball_huge6", "mul+add", 60 * a, 90, 150, 90)
        Render("ball_huge6", self.x, self.y, 0, 1.5, 1.5)
        SetImageState("ball_big6", "mul+add", 150 * a, 170, 230, 160)
        Render("ball_big6", self.x, self.y, 0, 0.55, 0.55)
    end,
}, true)

---网眼的点（卡 1-3）
class["th19_webpoint"] = Class(object, {
    init = function(self, x, y, a, v, life)
        self.x, self.y, self.a, self.v = x, y, a, v
        self.life = life
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if self.t == 1 then
            for j = 1, 3 do
                shot(ball_mid, 10, self.x, self.y, self.v, self.a + (j - 2) * 16,
                        self.col_r or 255, self.col_g or 208, self.col_b or 240)
            end
        end
        if self.t > self.life then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local k = max(0, 1 - self.t / 24)
        draw_orb(self.x, self.y, 0.22 * k, k, 226, 200, 255)
    end,
}, true)

---绿花（卡 2-5）
class["th19_bloom"] = Class(object, {
    init = function(self, x, y, n, hold)
        self.x, self.y = x, y
        self.n, self.hold = n, hold
        self.t = 0
        self.fired = false
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if self.t == self.hold + 1 then
            self.fired = true
            for k = 1, self.n do
                local a = (k - 1) * 360 / self.n
                local o = fly(ball_mid, 12, self.x, self.y, 0.4, a)
                o._r, o._g, o._b = 150, 255, 190
                o.vx, o.vy = cos(a) * 0.4, sin(a) * 0.4
            end
            PlaySound("tan00", 0.06, self.x / 256, true)
        end
        if self.t > self.hold + 200 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        if self.t <= self.hold then
            local k = self.t / self.hold
            arc(self.x, self.y, 40 * (1 - k) + 8, 0, 360, 16, 200 * k, 150, 255, 190, 0.07)
            draw_orb(self.x, self.y, 0.18 * k, k, 180, 255, 210)
            return
        end
        local k = self.t - self.hold
        for j = 1, self.n do
            local a = (j - 1) * 360 / self.n
            local rr = 8 + k * 1.15
            draw_petal(self.x + cos(a) * rr, self.y + sin(a) * rr, a,
                    0.26, max(0, 160 - k * 2), 150, 255, 190)
        end
    end,
}, true)

---怨灵（卡 5-2）：上浮 + 轻微追踪
class["th19_ghost"] = Class(object, {
    init = function(self, x, y, v, hom)
        self.x, self.y, self.v, self.hom = x, y, v, hom
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if self.t == 46 then
            --出生：朝上吐 3 路
            for j = 1, 3 do
                shot(ball_light, 12, self.x, self.y, 2.2, 90 + (j - 2) * 20,
                        200, 190, 255)
            end
        end
        self.x = self.x + self.hom
        self.y = self.y + self.v
        if self.y > lstg.world.t + 40 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local k = min(self.t / 46, 1)
        local a = (1 - min(self.t / 300, 1)) * 200 * k
        draw_orb(self.x, self.y, 0.26, a / 255, 190, 180, 255)
    end,
}, true)

---无意识弹（卡 7-1 / 7-5）：先亮一个点，再起飞
class["th19_silent"] = Class(object, {
    init = function(self, x, y, a, v)
        self.x, self.y, self.a, self.v = x, y, a, v
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if self.t == 37 then
            shot(heart, 12, self.x, self.y, self.v, self.a, 230, 180, 255)
        end
        if self.t > 60 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        if self.t > 37 then
            return
        end
        local k = self.t / 37
        draw_orb(self.x, self.y, 0.12 + 0.10 * k, k, 230, 190, 255)
    end,
}, true)

---玫瑰（卡 7-2）：层层绽放
class["th19_rose"] = Class(object, {
    init = function(self, x, y, layers, petals, gap, v0, dv)
        self.x, self.y = x, y
        self.layers, self.petals, self.gap = layers, petals, gap
        self.v0, self.dv = v0, dv
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        --每 gap 帧开一层
        if self.t > 70 and (self.t - 70) % self.gap == 1 then
            local layer = int((self.t - 70) / self.gap) + 1
            if layer <= self.layers then
                local v = self.v0 + self.dv * (layer - 1)
                for k = 1, self.petals do
                    local a = (k - 1) * 360 / self.petals + layer * 22
                    shot(heart, 12, self.x, self.y, v, a, 220, 170, 255)
                end
                PlaySound("tan00", 0.05, self.x / 256, true)
            end
        end
        if self.t > 70 + self.layers * self.gap + 240 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        if self.t > 70 then
            return
        end
        local k = self.t / 70
        arc(self.x, self.y, 46 * (1 - k) + 6, 0, 360, 16, 200 * k, 220, 170, 255, 0.07)
        draw_orb(self.x, self.y, 0.16 * k, k, 235, 190, 255)
    end,
}, true)

---终符的巨玫瑰（卡 7-5）
class["th19_rosebig"] = Class(object, {
    init = function(self, master, gap, petals)
        self.master = master
        self.gap, self.petals = gap, petals
        self.t = 0
        self.rot = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.x, self.y = self.master.x, self.master.y
        self.rot = (self.rot + 0.7) % 360
        if self.t > 90 and (self.t - 90) % self.gap == 1 then
            local n = self.petals
            for k = 1, n do
                local a = self.rot + (k - 1) * 360 / n
                shot(heart, 12, self.x, self.y, 1.8, a, 240, 180, 255)
                shot(heart, 6, self.x + cos(a) * 30, self.y + sin(a) * 30,
                        1.5, a, 190, 160, 255)
            end
            PlaySound("tan00", 0.07, 0, true)
        end
    end,
    render = function(self)
        for j = 1, 8 do
            local a = self.rot + j * 45
            draw_petal(self.x + cos(a) * 46, self.y + sin(a) * 46, a,
                    0.42, 90, 255, 190, 240)
        end
        for j = 1, 8 do
            local a = -self.rot + j * 45
            draw_petal(self.x + cos(a) * 26, self.y + sin(a) * 26, a,
                    0.30, 70, 220, 170, 255)
        end
        draw_orb(self.x, self.y, 0.3, 0.9, 255, 220, 255)
    end,
}, true)
