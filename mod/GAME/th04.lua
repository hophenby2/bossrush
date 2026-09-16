---=====================================
---TH04  彼岸：西行寺幽幽子 · 第二版
---
---  这是 th03「白玉楼」的重制版。母题还是扇 / 蝶 / 樱，
---  但每一张卡的**限位层**都改成按 AGENTS.md 第 10 节的量化规范来写：
---    · 参数回到项目惯例 (1,1,60) 档、hp 700~900（th03 的 hp 1400~2000 偏高了一档）
---    · 每张卡 init 里 2~4 个独立循环：一层管限位、一层管实弹，只靠 boss 坐标耦合
---    · 限位用「弹幕几何」而不是夹自机；每个限位都标出
---        ——缺口宽度、转换容错时间、预警帧数
---    · 转换容错时间 ≥ 需要移动的距离 ÷ 4（玩家 4 px/帧），再留 2~4 倍余量
---    · 限位生效前一定先有一段「只画不判」的预警（60~190 帧）
---    · 光效三件套：before 走位 → init 先 Wait(60) 再 Newcharge_in →
---        每个展开点 boss.cast + Newcharge_out
---
---  各卡块的注释里写了 [限位/缺口/容错/预警] 四个数，那是设计意图，改动前先看它。
---
---  回收规则同 th03：NewSimpleBullet 造的弹引擎自己收；自己 Class(object, ...) 造的
---  只要把 bound 关掉了，就必须在 frame 里自己 RawDel。
---=====================================

local class = {}
_editor_class["TH04"] = class

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
    _SC_BG.AddLayer(self, "th04_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        --符卡背景：一层偏绯红的暮色
        l.r, l.g, l.b = 236, 138, 150
    end)
end

boss.Define("1a", "西行寺幽幽子", "TH04_0", TH04_bg, { 0, 300 }, class["SCBG1"], "Yuyuko", 24)

--============================
--公用小工具（与 th03 一致，只是把常量都标了出来）
--============================

---加算细线（自绘，不生成对象，所以没有判定）
local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then
        return
    end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

---画一段圆弧（画限位预警用）
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

---画一颗带光晕的光玉（自绘）
local function draw_orb(x, y, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ball_huge6", "mul+add", 62 * a, r * 0.55, g * 0.55, b * 0.8)
    Render("ball_huge6", x, y, 0, size * 1.45, size * 1.45)
    SetImageState("ball_big6", "mul+add", 175 * a, r, g, b)
    Render("ball_big6", x, y, 0, size * 0.52, size * 0.52)
    SetImageState("ball_mid6", "mul+add", 210 * a, 255, 255, 255)
    Render("ball_mid6", x, y, 0, size * 0.20, size * 0.20)
end

---画一片花瓣
local function draw_petal(x, y, rot, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ellipse6", "mul+add", a, r, g, b)
    Render("ellipse6", x, y, rot, size * 1.55, size)
end

---画一只蝶（翅膀一开一合）
local function draw_butterfly(x, y, rot, size, a, flap, col)
    if a <= 0 then
        return
    end
    local img = "butterfly" .. (Forbid(col or 2, 1, 8))
    local k = 0.55 + 0.45 * abs(sin(flap))
    SetImageState(img, "mul+add", a, 255, 200, 236)
    Render(img, x, y, rot, size * 2.2, size * 2.2 * k)
end

---boss 起舞时身后的大扇。**逐行照抄 th07.lua:2259 的 `fan` 类**：
---  ① 前 30 帧不显示（hscale = vscale = 0）；
---  ② 第 31~60 帧**横向**张开：hscale = sin(i*3)，i = 1..30 → 0→1；
---  ③ 第 61~90 帧**纵向**张开：vscale = 0.1 + 0.9*sin(i*3) → 0.1→1；
---  ④ 之后本体做「呼吸」：_s 每 120 帧从 1 涨到 1.35、再停 60 帧；
---     上面再叠一层 40 帧一次的闪光：_a 用 10 帧涨到 1、再用 30 帧落回 0；
---  ⑤ 渲染时 **rot 恒等于 0** —— 原卡这把扇子**不旋转**，只有开合 + 呼吸 + 闪光。
---  ⚠ `sin` 是**角度制**（Lapi.lua:110 `sin = lstg.sin`）：`sin(i*3)` 里 i 是帧号，
---    30 帧正好走完 0→90°。写成弧度的 `sin(t*0.05)` 周期是 7200 帧，等于不动。
---  ⚠ **不要** `object.Connect` 挂到 boss 身上：`boss_system:refresh(1)` 会调
---    `object.KillServants` 把 con_death 的挂件全清掉。原卡也是自己在 frame 里
---    判 `IsValid(self.master)`、master 没了就自删。
---  尺寸：原卡场地 640 宽、贴图原尺寸放；我们 384 宽 → 整体乘 0.6。
class["th04_dancefan"] = Class(object, {
    init = function(self, master, hold)
        self.master = master
        self.hold = hold or 0
        self.t = 0
        self.hscale, self.vscale = 0, 0
        self._a, self._s, self.fade = 0, 1, 1
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY - 1
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.x, self.y = self.master.x, self.master.y
        local t = self.t
        if t <= 30 then
            --① 还没长出来
        elseif t <= 60 then
            --② 横向张开（这时纵向还是 0.1 的细缝，和原卡一样）
            self.vscale = 0.1
            self.hscale = sin((t - 30) * 3)
        elseif t <= 90 then
            --③ 纵向张开
            self.hscale = 1
            self.vscale = 0.1 + 0.9 * sin((t - 60) * 3)
        else
            --④ 呼吸（120 帧一轮：涨 60 帧、停 60 帧）+ 闪光（40 帧一轮）
            local u = t - 90
            local p = u % 120
            self._s = 1 + 0.35 * sin((p < 60 and p + 1 or 60) * 1.5)
            local v = u % 40
            self._a = v < 10 and sin((v + 1) * 9) or sin((39 - v) * 3)
        end
        --⑤ hold 之后整体淡出（不突然消失）
        if self.hold > 0 and t > self.hold then
            self.fade = self.fade - 0.02
            if self.fade <= 0 then
                object.RawDel(self)
            end
        end
    end,
    render = function(self)
        if self.hscale <= 0 then
            return
        end
        local S = 0.6 * self.fade
        SetImageState("fan", "mul+add", 255, 255, 255, 255)
        Render("fan", self.x, self.y, 0, self.hscale * S, self.vscale * S)
        if self._a > 0 then
            --闪光层：整体等比 (_s 倍) 再压一遍，就是原卡的 `Render("fan", x, y, 0, self._s)`
            SetImageState("fan", "mul+add", 255 * self._a, 255, 255, 255)
            Render("fan", self.x, self.y, 0, self._s * S, self._s * S)
        end
    end,
}, true)

---`before()` 走位时开一把舞扇。hold 之后自己淡出。
local function open_dance_fan(boss_obj, hold)
    return New(class["th04_dancefan"], boss_obj, hold)
end

---立刻起飞的普通弹：stay = false，一出膛就走，不在原地悬停
local function fly(style, col, x, y, v, a, omiga, glow)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga or 0, false)
    if glow ~= false then
        o._blend = "mul+add"
    end
    return o
end

---发射点安全距离：出膛到命中至少要有 20 帧。
---  挪开一发弹 = 反应(≈15 帧) + 横移出判定圈(≈2 帧)，再留一点余量 = 20。
---  ⚠ **不要用这个来挖洞**（AGENTS.md §10.10）。挖洞会在墙上开个缺口，
---    玩家看得见「墙少了一块」，限位也被自己废掉一半。正解是下面三条：
---      ① 改展开：换成不会在自机身上生成的形式（自机贴脸就改发散开 / 整圈）
---      ② 改弹速：把速度压到 ≤ 距离/20
---      ③ 改生成位置：挪到**对面**去（`mirror_spawn`）
---  这两个函数只用来**做①②③的判断**，不用来决定「这一格不发」。
local SPAWN_REACT = 20
local function near_player(x, y, v)
    return Dist(x, y, player.x, player.y) < SPAWN_REACT * (v or 0)
end

---③「改生成位置」：自机贴得太近时，把发射点挪到**圆周的对面**。
---  不挖洞、不少发弹，只是换个地方生成。对**中心对称**的图形（六边形、六条射线、
---  偶数个点的环）来说，对面那个点在图案上是合法的，对称性不破。
local function mirror_spawn(cx, cy, x, y, v)
    if not near_player(x, y, v) then
        return x, y
    end
    return cx * 2 - x, cy * 2 - y
end

---把自己的弹挂到 boss 名下。
---  引擎在换卡时走 boss_system:refresh(1)，里面有一句 object.KillServants(boss)。
---  挂上去的弹会被一起收掉；**不挂的话，卡打完了它们还在天上飘** ——
---  尤其花瓣落到底还会再炸成 5 把刀，玩家看到的就是「击破了还在发弹」。
local function attach(master, obj)
    if IsValid(master) and obj then
        object.Connect(master, obj, 0, true)
    end
    return obj
end

---通用「路径弹」：位置由 path(self, t) 每帧算，bound 关掉所以要自己回收
local path_bullet = Class(bullet, {
    init = function(self, style, col, x, y, a, path)
        bullet.init(self, style, col, false, true)
        self.x, self.y, self.rot = x, y, a or 0
        self.path = path
        self.bound = false
        self.max_life = 720
        self.max_r2 = 640 * 640
    end,
    frame = function(self)
        bullet.frame(self)
        local t = self.timer
        if t > self.max_life or self.x * self.x + self.y * self.y > self.max_r2 then
            object.RawDel(self)
            return
        end
        self.path(self, t)
    end,
    render = function(self)
        bullet.render(self)
    end,
})

---限位墙的标准做法（见 AGENTS.md 10.4）：高密度的一条墙 + 挖掉一段缺口。
---
---  这里用**四边内向墙**而不是圆环，有两个理由：
---    · 场地是 384×448 的竖长方形，圆环围不住它（上下两个角会漏出去）
---    · 弹的回收边界是 ±224/±256，从半径比这更大的地方生成的弹
---      会在**生成的那一帧**就被引擎收掉 —— 墙会缺掉一大块，缺口逻辑全废
---  所以墙贴着 ±(HW, HH) 生成，两个方向都留在边界内侧，再朝内推。
---
---  ⚠ 墙**永远来不及躲**，除非压速度：回收边界 ±224/±256 比自机的活动边界
---    ±192/±224 只大 32 px，所以墙生成时离自机**最近就是 24~26 px**，推远推不出去。
---    按「出膛到命中 20 帧」算 ⇒ **墙速必须 ≤ 1.2 px/帧**。
---    本文件两张墙卡都用 **WALL_V = 1.15**（24/1.15 = 20.9 帧）。
---    压不下去的话就只剩「缺口跟着自机走」或「开火前先把墙画出来」两条路。

---  缺口用「周长参数」定位：s ∈ [0,1) 沿着墙绕一圈（上→右→下→左），
---  落在 [gap_s, gap_s+gap_w) 里的那段不放弹。这样缺口能沿墙一格一格地转。
---
---  ⚠⚠ 每条边必须走满**半周长**：`2*hw` 对应 s 的 0.25，所以系数是 **8** 不是 4。
---     写成 4 的话上边只画到 x=cx（左半条），右边只画到 y=cy（上半条）……
---     四条边各自只画了一半、彼此不接，**墙根本没闭合**，四个角各开一个口子。
---     这是 th04 卡 1 / 卡 10 的限位一直形同虚设的真正原因。
local function wall_point(cx, cy, hw, hh, s)
    s = s % 1
    if s < 0.25 then                       -- 上边：从左到右
        return cx - hw + 8 * hw * s, cy + hh, 0, -1
    elseif s < 0.5 then                    -- 右边：从上到下
        return cx + hw, cy + hh - 8 * hh * (s - 0.25), -1, 0
    elseif s < 0.75 then                   -- 下边：从右到左
        return cx + hw - 8 * hw * (s - 0.5), cy - hh, 0, 1
    else                                   -- 左边：从下到上
        return cx - hw, cy - hh + 8 * hh * (s - 0.75), 1, 0
    end
end

local function wall_with_gap(style, col, cx, cy, hw, hh, n, v, gap_s, gap_w)
    for i = 1, n do
        local s = (i - 1) / n
        -- 到缺口中心的周长距离
        local d = (s - gap_s) % 1
        if d > 0.5 then
            d = 1 - d
        end
        if d > gap_w * 0.5 then
            local x, y, dx, dy = wall_point(cx, cy, hw, hh, s)
            local o = fly(style, col, x, y, v, Angle(0, 0, dx, dy), 0)
            o._r, o._g, o._b = 255, 176, 210
        end
    end
end

--============================
--道中的装饰魂火（main_stage 里用）
--  无判定、不循环，飘出上边界即回收
--============================
class["th04_wisp"] = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 40
        self.bound, self.colli = false, false
        self.vy = ran:Float(0.5, 1.5)
        self.sway = ran:Float(0, 360)
        self.sway_v = ran:Float(4, 13) * ran:Sign()
        self.size = ran:Float(0.35, 0.9)
        self.a = ran:Int(60, 150)
        self.k = 0
    end,
    frame = function(self)
        self.y = self.y + self.vy
        self.sway = self.sway + self.sway_v
        self.x = self.x + sin(self.sway) * 0.7
        self.k = min(1, self.timer / 30)
        if self.y > lstg.world.boundt + 30 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local k = self.a * self.k
        SetImageState("ball_light5", "mul+add", k * 0.5, 120, 200, 255)
        Render("ball_light5", self.x, self.y, 0, self.size * 0.9, self.size * 0.9)
        SetImageState("ball_mid6", "mul+add", k, 226, 246, 255)
        Render("ball_mid6", self.x, self.y, 0, self.size * 0.22, self.size * 0.22)
    end,
}, true)

--============================
--[符卡1] 蝶符「胡蝶之栅」
--  限位：四面内向墙（不是圆环——场地 384×448 是竖长的，圆环围不住它）
--  缺口：2.2 格 / 共 16 格，周长 1820 px → 缺口约 250 px
--  容错：缺口每 90 帧沿墙挪一格（114 px 周长）。要走 114 px → 114/4 ≈ 29 帧，余量 3.1 倍
--        墙 58 帧穿完全场，两波之间有 ~37 帧静默 —— **这一段静默才是玩家的呼吸口**。
--        （实测：墙慢(2.2)+密(每 40 帧一面)时，场上永远有 2~3 面墙在收，
--          「必须移动」高达 3.5 次/秒；改成快墙+拉开间隔后见下方实测）
--  预警：每轮开头的 36 帧只画墙不判；整面墙出现前另有 90 帧预热（亮的缺口段就是提示）
--  实弹：boss 每 40 帧朝玩家放 12 路扇形（v=2.2），逼你在缺口里还要动
--============================
do
    local SLOTS = 16                 -- 墙的周长切几格
    local GAP_W = 2.2 / SLOTS        -- 缺口占 2.2 格（≈250 px 周长；1.5 格时太挤）
    local WALL_N = 56                -- 整圈几颗（周长 1820 px → 33 px 一颗）
    -- ⚠ 墙必须**以场地中心(0,0)为心**、且尽量贴近回收边界：
    --   自机活动到 ±192/±224，墙贴到 ±220/±252 才留下 28 px 余量，
    --   按 1.15 px/帧 算 24 帧 > 20 —— 这才是「贴着边站也来得及躲」。
    --   原来写 208/244 且以 boss(y=40) 为心：下边压在 y=-204（离自机只有 20 px），
    --   上边到 y=284（越过回收边界 ±256，**生成当帧就被引擎收掉**）。
    local HW, HH = 220, 252          -- 墙的半宽/半高：都在回收边界(±224/±256)内侧
    -- ⚠ 墙速被回收边界卡死在 1.15：墙贴着 ±208/±244 生成，而自机活动到 ±192/±224，
    --   离自机最近只有 24 px —— 按「出膛到命中 20 帧」算，速度快过 1.2 就是**必中**。
    --   （原来写 3.6：24/3.6 只有 7 帧，贴着边站必死。）
    local WALL_V = 1.15              -- 朝内推的速度：慢，但这是唯一公平的速度
    local CYCLE = 340                -- 补墙间隔：要 > 穿场时间(≈243 帧) 且留足静默
    local JUMP = 200                 -- 每 200 帧缺口挪一格
    local WARN = 36                  -- 每轮开头 36 帧只画预警
    local START_WARN = 90            -- 整面墙出现前的预热
    local AIM_GAP = 40               -- 实弹间隔
    local AIM_WAYS = 12
    local AIM_V = 2.2
    local BOSS_X, BOSS_Y = 0, 40

    class["th04_ring_cage"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.gap_s = 0               -- 缺口中心（周长参数 0~1）
            self.t = 0
            self.ready = false
            self.cx, self.cy = 0, 0      -- 墙以场地中心为心（不是 boss），四边余量才对称
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            if IsValid(m) then
                self.cx, self.cy = m.x, m.y
            end
            self.t = self.t + 1
            if self.t < START_WARN then
                return                      -- 预热期：只画不判
            end
            if not self.ready then
                self.ready = true
                self.t = 0
                PlaySound("kira00", 0.2, 0, true)
            end
            --缺口每 JUMP 帧沿墙挪一格（1/SLOTS 周长 ≈ 114 px）
            if self.t % JUMP == 1 then
                self.gap_s = (self.gap_s + 1 / SLOTS) % 1
                PlaySound("tan00", 0.05, 0, true)
            end
            --每 CYCLE 帧补一面墙；每轮开头 WARN 帧不发实体，只留预警
            if self.t % CYCLE == 1 and (self.t % JUMP) > WARN then
                wall_with_gap(butterfly, 2, self.cx, self.cy, HW, HH, WALL_N,
                        WALL_V, self.gap_s, GAP_W)
            end
        end,
        render = function(self)
            --整面墙：暗线；缺口那一段：亮线（这就是预警）
            local seg = 96
            for i = 1, seg do
                local s1 = (i - 1) / seg
                local s2 = i / seg
                local d1 = (s1 - self.gap_s) % 1
                if d1 > 0.5 then d1 = 1 - d1 end
                local in_gap = d1 <= GAP_W * 0.5
                local x1, y1 = wall_point(self.cx, self.cy, HW, HH, s1)
                local x2, y2 = wall_point(self.cx, self.cy, HW, HH, s2)
                thin_line(x1, y1, x2, y2, in_gap and 190 or 40,
                        in_gap and 255 or 226, in_gap and 210 or 150, 240, 0.08)
            end
            if self.t < START_WARN then
                local k = 1 - self.t / START_WARN
                local gx, gy = wall_point(self.cx, self.cy, HW, HH, self.gap_s)
                thin_line(self.cx, self.cy, gx, gy, 100 * k, 255, 210, 240, 0.10)
            end
            draw_orb(self.cx, self.cy, 0.9, 0.85, 255, 205, 238)
        end,
    }, true)

    do
        local name = "蝶符「胡蝶之栅」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 276)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__cage = New(class["th04_ring_cage"], self)
            --实弹层：朝玩家放 12 路扇形
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                boss.cast(self, 90)
                task.Wait(90)
                Newcharge_out(self.x, self.y, 255, 255, 100)
                while true do
                    --① 改展开：自机贴着 boss 时（发射点就是 boss 自己）这一轮改成**整圈**，
                    --   而不是把弹删掉 —— 弹一发不少，只是不再朝自机扎。
                    local aimed = not near_player(self.x, self.y, AIM_V)
                    local a0 = aimed and Angle(self, player) or 0
                    for i = 1, AIM_WAYS do
                        local o = fly(ball_mid, 4, self.x, self.y, AIM_V,
                                a0 + (i - 1) * 360 / AIM_WAYS, 0)
                        o._r, o._g, o._b = 255, 186, 220
                    end
                    PlaySound("tan00", 0.06, self.x / 256, true)
                    task.Wait(AIM_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__cage) then
                object.RawDel(self.__cage)
            end
            self.__cage = nil
        end
    end
end

--============================
--[卡2] 樱符「墨染之川」
--  限位：三途川的**潮汐**——水位在 -209 ~ +95 之间涨落，把玩家顶在它上面（th07:819 的做法）
--  不做「缺口」：试过在幕布上留 5 条缝，结果玩家只要站进缝里就完全不受力，
--  限位形同虚设。潮汐是单调的上下界，没有可以「躲进去」的位置。
--  容错：涨落周期 300 帧，半个周期 150 帧里水位走完 304 px；
--        水位最快 3.2 px/帧，玩家 4 px/帧 追得上，所以是「压缩活动空间」而不是「推着走」，
--        真正的死线是水位到顶时上方只剩 129 px 的带子。
--        推力限速 6 px/帧（连续），不要写成硬夹 —— 会变成单帧瞬移几十 px。
--  预警：潮汐启动前 90 帧，在起潮线上画一条闪烁的提示线（水位还没动）
--  实弹：上方落下的花瓣（v=1.8，每 22 帧一片），落到 -60 炸开成 5 向
--============================
do
    local TIDE_PERIOD = 300          -- 潮汐周期（帧）
    -- ⚠ 水位顶必须**离 boss 至少 20×实弹弹速 px**，否则限位就是把自机顶到 boss 脸上，
    -- 自机狙变成贴脸狙（必中）。卡 2 的 boss 在 y=160、实弹弹速 3.0 →
    -- 水位顶不能超过 160 − 60 = 100。写在 +140 时实测出膛离自机 39 px、只 13 帧。
    -- 改成 -65±160（顶 +95，离 boss 65 px = 21.7 帧），同时仍然伸进自机活动带（0~186）里。
    local TIDE_MID, TIDE_AMP = -57, 152  -- 水位 = MID + AMP·sin → 在 -209 ~ +95 之间
    -- ⚠ 潮底必须留在**画面内**：原来写 -225 已经越过 world.b(-224)，
    -- 于是预警线（画在起潮位置）整个跑到屏幕外面去，玩家什么都看不到。
    local FLOOR_WARN = 90            -- 预警多少帧
    local FALL_V = 1.8               -- 花瓣下落速度
    local FALL_SWAY = 44
    local SPLIT_Y = -60
    local SPLIT_N = 5
    local SPLIT_V = 2.6
    local BOSS_X, BOSS_Y = 0, 160

    ---水位：自绘的抬升地板 + 把玩家往上顶
    class["th04_water"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.x, self.y = 0, -260
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t < FLOOR_WARN then
                return                       -- 预警期：水位还没动
            end
            --潮汐：单调的上下界，没有可以「躲进去」的缺口
            --相位 -90°：从最低点(-210)平滑起步，不然预警结束那一帧水位会跳 150 px
            self.y = TIDE_MID + TIDE_AMP * sin((self.t - FLOOR_WARN) * 360 / TIDE_PERIOD - 90)
            -- 把玩家顶到水面之上（这就是限位）。
            -- ⚠ 不能直接写 player.y = self.y：自机被弹压到水下很深时，
            -- 那一帧会被瞬移几十 px（实测峰值 90 px/帧），对手感来说等于没得躲。
            -- 改成「最多每帧推 6 px」：比水位涨得快，几帧就追平，且全程连续。
            if player.y < self.y then
                player.y = min(self.y, player.y + 6)
            end
        end,
        render = function(self)
            if self.t < FLOOR_WARN then
                --预警：水位还没动，先在**起潮线**上画一条闪烁的提示线
                --（起潮位置 = MID + AMP·sin(-90°) = -209，和下面 frame 的第一帧严格对上；
                --  写死成一个和实际不符的数，玩家就会看到「线在这里、水却从别处冒出来」）
                local wy = TIDE_MID - TIDE_AMP
                local k = 0.4 + 0.6 * sin(self.t * 9)
                SetImageState("white", "mul+add", 110 * k, 255, 214, 236)
                RenderRect("white", -192, 192, wy - 2.5, wy + 2.5)
                return
            end
            local y = self.y
            --水面：一条带起伏的长线
            local segs = 48
            for i = 1, segs do
                local x1 = -192 + 384 * (i - 1) / segs
                local x2 = -192 + 384 * i / segs
                local w1 = y + sin(self.t * 3.4 + x1 * 1.7) * 3
                local w2 = y + sin(self.t * 3.4 + x2 * 1.7) * 3
                thin_line(x1, w1, x2, w2, 190, 236, 96, 130, 0.16)
            end
            SetImageState("ball_light5", "mul+add", 40, 255, 130, 150)
            Render("ball_light5", 0, y, 0, 3.6, 0.28)
        end,
    }, true)

    ---花瓣：落下 → 到线炸开
    local function petal_path(self, t)
        self.y = self.sy - FALL_V * t
        self.x = self.sx + sin(t * 2.3 + self.ph) * FALL_SWAY
        self.rot = self.spin0 + t * 1.3
        if self.y <= SPLIT_Y then
            for k = 1, SPLIT_N do
                --炸开的是**蝶**不是刀：这一关的母题是蝶 / 扇 / 樱
                local a = 90 + (k - (SPLIT_N + 1) / 2) * 13
                local o = fly(butterfly, 2 + (k % 2) * 2, self.x, self.y, SPLIT_V, a, 0)
                o._r, o._g, o._b = 255, 176, 208
            end
            PlaySound("tan00", 0.02, self.x / 256, true)
            object.RawDel(self)
        end
    end

    class["th04_petal"] = Class(path_bullet, {
        init = function(self, x, y)
            path_bullet.init(self, ellipse, 4, x, y, -90, petal_path)
            self.sx, self.sy = x, y
            self.ph = ran:Float(0, 360)
            self.spin0 = ran:Float(0, 360)
            self._blend = "mul+add"
        end,
    }, true)

    do
        local name = "樱符「墨染之川」"
        local card = boss.card.New(name, 1, 1, 60, 750)
        boss.card.add({ { card, "1a" } }, 24, name, 277)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__water = New(class["th04_water"], self)
            --实弹层：花瓣雨
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 236, 96, 130)
                boss.cast(self, 60)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 236, 96, 130)
                while true do
                    attach(self, New(class["th04_petal"],
                            ran:Float(lstg.world.l, lstg.world.r), 236))
                    task.Wait(22)
                end
            end)
            --boss 自己补一轮，免得只顾着看水
            task.New(self, function()
                task.Wait(240)
                while true do
                    --① 改展开：自机贴着 boss 时（发射点就是 boss 自己）这一轮改成**整圈**，
                    --   而不是把弹删掉 —— 弹一发不少，只是不再朝自机扎。
                    local aimed = not near_player(self.x, self.y, 3.0)
                    for k = 1, 7 do
                        --朝自机时是 7 路扇（±33°）；改成整圈时铺满 360°
                        local ang = aimed and (Angle(self, player) + (k - 4) * 11)
                                or ((k - 1) * 360 / 7)
                        local o = fly(ball_mid, 2, self.x, self.y, 3.0, ang, 0)
                        o._r, o._g, o._b = 255, 178, 212
                    end
                    PlaySound("tan00", 0.07, self.x / 256, true)
                    task.Wait(150)
                end
            end)
        end

        function card:del()
            if IsValid(self.__water) then
                object.RawDel(self.__water)
            end
            self.__water = nil
        end
    end
end

--============================
--[卡3] 扇符「胡蝶扇舞」
--  照着 **th08「蝴蝶梦之舞」（mod/GAME/th08-boss_lastword.lua:1539）** 写。
--  **先搞明白人家是怎么实现的**（这几条是读 th07.lua:2259 的 `fan` 类得到的）：
--    ① 扇是**分两步张开**的：先 `vscale`，再 `hscale`，各 30 帧 —— 不是直接把贴图放大。
--    ② 张开之后一直在**脉动**：`_s = 1 + 0.35*sin(i*1.5)`（缩放）、`_a = sin(i*9)`（光晕 alpha）。
--    ③ 渲染是**两遍**：本体一遍 + 加算光晕一遍 —— 这就是「扇子光效」。
--    ④ 贴图的旋转映射：**上=0° / 下=180° / 左=-90° / 右=90°**（我原来写成 dir-90，反了 180°）。
--    ⑤ 位移是 `task.CRMoveTo(240, 1, -180d,150, 0,60, 180d,150)` ——
--       **但那是 640×480 的场地**；我们只有 384×448，直接照抄等于横跨半个屏、boss 一直跑，
--       玩家根本没法输出。所以按场地宽度的比例缩到 ±95。
--  限位：**左右两侧 + 顶部**的扇幕（不含底部：底部会盖在自机惯常待的那一片上）。
--        每把扇走完整生命周期：**张开 → 摆几帧 → 炸开同时吐 5 way → 淡出 → 隔几帧再生成新扇**。
--        「炸开」和吐弹是同一帧，玩家看到的是「扇子炸出弹」。
--  实弹：**蝶弹**（butterfly）—— 刀弹跟蝶/扇/樱的母题无关，全部换掉。
--  容错：华尔兹 240 帧走完 190 px，≈0.8 px/帧，比自机慢四倍。
--  预警：扇的张开过程本身就是预警（24 帧）。
--============================
do
    local FAN_WAYS = 5                -- 每把扇一次吐几发（和原来一样）
    local FAN_SPREAD = 30
    local FAN_V = 2.2
    local FAN_OPEN = 24               -- 张开的帧数（两步张开，参考卡是 12+12）
    local FAN_HOLD = 110              -- 张开之后摆多久才炸
    local FAN_FADE = 16               -- 炸开之后淡出几帧
    local FAN_CYCLE = 210             -- 同一个槽位隔多久再长一把新扇
    -- 扇子在屏幕上的大小：参考卡是 Lfan 的 0.30 倍（它的场地 640 宽，我们 384）
    -- → 按 384/640 = 0.6 缩到 0.18。
    local FAN_SIZE = 0.18
    -- 布局**照抄参考卡**（Little_Fan_Green 的排法），按场地比例缩：
    --   参考：上下各 9 把（x 铺满 ±320，间距 80）、左右各 7 列（y 铺满 ±230）
    --   我们：±192 宽 → 间距 80*0.6 = 48 → 9 把；±224 高 → 7 列
    local FAN_TOP, FAN_SIDE = 9, 7
    local FAN_EDGE = 10               -- 扇锚点离可见边界几 px（参考卡是 10）
    -- 华尔兹：参考卡是 ±180（640 宽的场地），我们 384 宽 → 按比例缩到 ±95
    local WALTZ_T = 240
    local WALTZ_X, WALTZ_Y1, WALTZ_Y2 = 95, 130, 58
    local WALTZ_REST = 110            -- 走完之后停多久（参考卡是 80，这里留长一点好输出）
    local RING_V0, RING_DV = 1.2, 0.6
    local RING_T0, RING_DT, RING_TMAX = 12, 2, 16
    local ORBIT_N0, ORBIT_DN = 6, 0.5
    local BOSS_X, BOSS_Y = 0, 130

    -- Lfan.png 是 mod/GAME/th08.lua 里 LoadImageGroup 进来的（5 帧，Lfan1..Lfan5）：
    --   Lfan2 = 绿扇（围场那 32 把）  Lfan3 = 蓝扇  Lfan4 = 金扇
    -- 三把各自的类名见下面 class["th04_fan"] / th04_goldenfan / th04_bluefan 的头注释。
    local FAN_IMG = "Lfan2"

    ---边缘扇：**照抄 Little_Fan_Green（mod/GAME/th08.lua:1966）**
    ---  ① 张开分两步：先竖 12 帧（vscale 0→1），再横 12 帧（hscale 0.27→1）。
    ---     参考卡写的是 `sin(s)*0.3` / `0.08 + 0.22*sin(s)`，比值一样，
    ---     我是整体缩到我们场地的大小（FAN_SIZE）。
    ---  ② 张开之后**一直绕锚点摆 ±16~23°**（参考卡 task2：`self.rot = sin(s)*a + r`，
    ---     `s` 每帧 +1.5° → 周期 240 帧）。锚点钉在场地边缘，扇子以它为轴摇 —— 这就是「在动」。
    ---     ⚠ 这里的 sin 是**角度制**（Lapi.lua:110 `sin = lstg.sin`），
    ---       写成 `sin(t * 0.05)` 这种弧度系数的话周期是 7200 帧，等于不动。
    ---  ③ 摆够 FAN_HOLD 帧**炸开、同时吐 5 way**，再淡出 → 槽位隔 FAN_CYCLE 帧长新的。
    ---  ④ 渲染两遍（本体 + 加算光晕），就是参考卡的「扇子光效」。
    ---**两个角度是分开的**（这是之前写错的地方）：
    ---  `rot`  —— 画出来时的朝向（扇面开口的方向）
    ---  `fdir` —— 真发弹时的方向（朝场地内侧）
    ---参考卡的映射（`Little_Fan_Green` 的 `r` 参数）是：
    ---  下边 y=w.b → rot **0**、上边 y=w.t → rot **180**、
    ---  左边 x=w.l → rot **-90**、右边 x=w.r → rot **90**，
    ---  也就是**四边的开口统统朝场内**（贴图在 rot=0 时开口朝 +y）。
    ---  发弹方向同理统统朝场内：下 **+90** / 上 **-90** / 左 **0** / 右 **180**。
    ---  ⚠ 这两个数正好差 90° —— 混用同一个值的话，要么扇子是躺着的，要么弹朝屏幕外飞。
    ---摆动幅度是 ±16~23°，**镜像成对的两把符号相反**（参考卡里就是 `ran` 和 `-ran`）。
    class["th04_fan"] = Class(object, {
        init = function(self, x, y, rot, fdir, ssign, fires)
            self.x, self.y = x, y
            self.rot0 = rot             -- 基准朝向（摆动的中心）
            self.rot = rot
            self.fdir = fdir
            -- fires=false：只当扇框（**照参考卡**，边缘那圈扇本身不发弹，只负责围住场地）
            self.fires = fires and true or false
            self.t = 0
            self.hscale, self.vscale = 0, 0
            self.swing = ran:Float(16, 23) * (ssign or 1)
            self._a, self.burst = 0, 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 22
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            local t = self.t
            local half = FAN_OPEN / 2
            --① 两步张开
            if t <= half then
                local u = sin(t / half * 90)
                self.vscale = u
                self.hscale = u * 0.27
            elseif t <= FAN_OPEN then
                local u = sin((t - half) / half * 90)
                self.vscale = 1
                self.hscale = 0.27 + 0.73 * u
            else
                self.vscale, self.hscale = 1, 1
            end
            --② 张开之后一直摆（在基准朝向 rot0 上叠一个 ±swing 的正弦）
            self.rot = self.rot0 + sin((t - FAN_OPEN) * 1.5) * self.swing
            if t <= FAN_OPEN then
                return
            end
            self._a = min(self._a + 10, 150)
            --③ 发弹的那 14 把：炸开**同时**吐弹（弹朝 fdir = 场内，不是扇面的朝向）
            if self.fires and t == FAN_OPEN + FAN_HOLD then
                self.burst = 1
                for i = 1, FAN_WAYS do
                    local off = (i - (FAN_WAYS + 1) / 2) * FAN_SPREAD / 2
                    local o = fly(butterfly, 2 + (i % 2) * 2, self.x, self.y, FAN_V,
                            self.fdir + off, 0)
                    o._r, o._g, o._b = 255, 214, 236
                end
                PlaySound("tan00", 0.02, self.x / 256, true)
            end
            --④ 到寿命就淡出 —— **不能写在 `if self.fires` 里面**：
            --   只当扇框的 18 把（上下两排）不发弹，如果跟着 return 掉就永远走不到这里，
            --   `bound = false` 又不会被边界回收 → 每 210 帧泄 18 个对象，
            --   一张 60 秒的卡下来泄 300 多个（自检里的「峰值同屏 对象」就是这么涨上去的）。
            if t > FAN_OPEN + FAN_HOLD then
                self.burst = self.burst + 1
                --炸完淡出（不突然消失），淡干净了自己收
                self._a = self._a - 16
                self.hscale = self.hscale * 1.05
                if self._a <= 0 then
                    object.RawDel(self)
                end
            end
        end,
        render = function(self)
            if self.hscale <= 0 then
                return
            end
            --④ 两遍
            SetImageState(FAN_IMG, "mul+add", 205, 255, 255, 255)
            Render(FAN_IMG, self.x, self.y, self.rot,
                    self.hscale * FAN_SIZE, self.vscale * FAN_SIZE)
            if self._a > 0 then
                local k = self._a / 150
                SetImageState(FAN_IMG, "mul+add", 130 * k, 255, 244, 210)
                Render(FAN_IMG, self.x, self.y, self.rot,
                        self.hscale * FAN_SIZE * (1 + 0.22 * k),
                        self.vscale * FAN_SIZE * (1 + 0.22 * k))
            end
            --炸开那一下：一圈外扩亮环
            if self.burst > 0 then
                local u = 1 - min(self.t - (FAN_OPEN + FAN_HOLD), FAN_FADE) / FAN_FADE
                arc(self.x, self.y, 10 + 40 * (1 - u), self.rot - 55, self.rot + 55, 16,
                        190 * u, 255, 236, 246, 0.10)
            end
        end,
    }, true)

    -- ============ 会转的两种扇子（金扇 / 蓝扇）============
    -- ⚠ 参考卡 mod/GAME/th08-boss_lastword.lua:1539 里一共**三种**小扇，动法完全不同：
    --   Little_Fan_Green  （Lfan2，围场 32 把）—— **不转**，只摆 ±16~23°     → class["th04_fan"]
    --   Little_Fan_Golden （Lfan4，每轮 2 把） —— **会转**，绕 boss 转三圈多  → class["th04_goldenfan"]
    --   Little_Fan_Blue   （Lfan3，每轮 int(n) 把）—— **会转**，转整整两圈    → class["th04_bluefan"]
    -- 再加上 boss 身后那把大扇（th07 的 `fan`，rot 恒为 0，只开合+呼吸，**不转**）
    --     → class["th04_dancefan"]
    -- 之前只搬了 Green 和大扇，把 Golden / Blue 整个漏了 —— 那两把才是「会转的扇子」。

    ---扇子两步张开（Green / Golden / Blue 三把**都是这个**）：
    ---前 12 帧纵着张（vscale 0→1），后 12 帧横着张（hscale 0.27→1）。返回 0~1 的比例。
    local function fan_unfold(t)
        if t <= 12 then
            local u = sin((t - 1) / 11 * 90)
            return u * 0.27, u
        elseif t <= 24 then
            local u = sin((t - 13) / 11 * 90)
            return 0.27 + 0.73 * u, 1
        end
        return 1, 1
    end

    ---扇子收起来（24 帧）：先把横的收回成 0.08，再整体缩没。返回 0~1 的比例。
    ---收完 hscale / vscale 正好到 0，然后才 RawDel —— 不会「突然消失」。
    local function fan_close(t)
        if t <= 12 then
            return (0.30 - 0.22 * sin((t - 1) / 11 * 90)) / 0.30, 1
        end
        local u = sin((24 - t) / 11 * 90)
        return 0.08 * u / 0.30, u
    end

    local GOLD_IMG, GOLD_SIZE = "Lfan4", 0.18
    local GOLD_R, GOLD_R2 = 70, 10          -- 环绕半径 / 转起来之后往外涨的余量
    local GOLD_SPIN, GOLD_T = 10, 240       -- 每帧自转角度 / 转多少帧
    local BLUE_IMG, BLUE_SIZE = "Lfan3", 0.18
    local BLUE_R, BLUE_T = 50, 150          -- 出生点离 boss 的距离 / 一去一回的帧数

    ---金扇：**会转的那把**（照抄 Little_Fan_Golden，mod/GAME/th08.lua:1803）
    ---① 沿 a 方向飞到 r = GOLD_R（30 帧，sin 缓动）；② 在 r 上停 30 帧；
    ---③ **转 240 帧**：`rot = rot + 10*d*sin(as)`，`as` 从 0 走到 180，
    ---   累加 ≈ 1146°（三圈多），而且是「先慢→最快→再慢」的 sin 包络，不是匀速；
    ---   同时半径从 70 涨到 80；每 6 帧朝 `rot±50°` 撒 4 发，弹速 3→1 递减；
    ---④ 30 帧收回到 r=70；⑤ 24 帧收扇 → 自删。
    ---⚠ 渲染用 `self.rot = spin - 90` —— 贴图开口才朝外（见 §9「rot 是标准数学角」）。
    class["th04_goldenfan"] = Class(object, {
        init = function(self, master, a, d)
            self.master, self.a, self.d = master, a, d
            self.t = 0
            self.spin = a
            self.rot = a - 90
            self.hscale, self.vscale = 0, 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if not IsValid(self.master) then
                object.RawDel(self)
                return
            end
            local m, t = self.master, self.t
            if t <= 30 then
                --① 飞出去
                local u = sin((t - 1) / 29 * 90)
                self.x = m.x + cos(self.a) * u * GOLD_R
                self.y = m.y + sin(self.a) * u * GOLD_R
                local h, v = fan_unfold(t)
                self.hscale, self.vscale = h * GOLD_SIZE, v * GOLD_SIZE
            elseif t <= 60 then
                --② 停在 r = GOLD_R 上
                self.x = m.x + cos(self.a) * GOLD_R
                self.y = m.y + sin(self.a) * GOLD_R
                self.hscale, self.vscale = GOLD_SIZE, GOLD_SIZE
            elseif t <= 60 + GOLD_T then
                --③ 转 + 撒弹
                local i = t - 60
                local as = (i - 1) / (GOLD_T - 1) * 180
                self.spin = self.spin + GOLD_SPIN * self.d * sin(as)
                local L = GOLD_R + sin(min((i - 1) * 90 / 19, 90)) * GOLD_R2
                self.x = m.x + cos(self.spin) * L
                self.y = m.y + sin(self.spin) * L
                self.rot = self.spin - 90
                self.hscale, self.vscale = GOLD_SIZE, GOLD_SIZE
                if i % 24 == 1 then
                    local bv = 3 - 2 * (i - 1) / (GOLD_T - 1)
                    local ba = self.spin - 50
                    for _ = 1, 4 do
                        local o = fly(butterfly, 8,
                                m.x + cos(ba) * 100, m.y + sin(ba) * 100, bv, ba, 0)
                        o._r, o._g, o._b = 255, 226, 120
                        ba = ba + 100 / 3
                    end
                end
            elseif t <= 90 + GOLD_T then
                --④ 收回来
                local u = sin((t - 61 - GOLD_T) / 29 * 90)
                local L = GOLD_R + GOLD_R2 - u * GOLD_R2
                self.x = m.x + cos(self.spin) * L
                self.y = m.y + sin(self.spin) * L
                self.rot = self.spin - 90
            else
                --⑤ 收扇（缩到 0 才自删）
                local j = t - (90 + GOLD_T)
                if j > 24 then
                    object.RawDel(self)
                    return
                end
                local h, v = fan_close(j)
                self.hscale, self.vscale = h * GOLD_SIZE, v * GOLD_SIZE
            end
        end,
        render = function(self)
            if self.hscale <= 0 then
                return
            end
            SetImageState(GOLD_IMG, "mul+add", 235, 255, 236, 160)
            Render(GOLD_IMG, self.x, self.y, self.rot, self.hscale, self.vscale)
        end,
    }, true)

    ---蓝扇：**也会转**（照抄 Little_Fan_Blue，mod/GAME/th08.lua:1900）
    ---出生在「离 boss 半径 50、角度 A」处，并记下**出生那一刻**的自机坐标；
    ---然后 150 帧里用 `sin` 缓动飞过去再飞回来（`sin(u*180)` 正好走一个来回）。
    ---同时 `rot = A - 90 + sin(u*90) * 720 * d` —— **整整转两圈**，`d` 每轮翻号。
    ---每 6 帧朝 `rot + 90` 吐一发（弹速 1→3 递增）。
    ---⚠ 发弹方向是 `rot + 90`，和金扇的撒弹角不是一套，别互相照抄。
    class["th04_bluefan"] = Class(object, {
        init = function(self, master, d, A)
            self.master, self.d, self.A = master, d, A
            self.x = master.x + cos(A) * BLUE_R
            self.y = master.y + sin(A) * BLUE_R
            self.x1, self.y1 = player.x, player.y   -- 出生瞬间的自机位置
            self.x2, self.y2 = self.x, self.y
            self.t = 0
            self.rot = A - 90
            self.hscale, self.vscale = 0, 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            local t = self.t
            if t <= 24 then
                local h, v = fan_unfold(t)
                self.hscale, self.vscale = h * BLUE_SIZE, v * BLUE_SIZE
                return
            end
            local i = t - 24
            if i <= BLUE_T then
                local u = (i - 1) / (BLUE_T - 1)
                self.x = self.x2 + (self.x1 - self.x2) * sin(u * 180)
                self.y = self.y2 + (self.y1 - self.y2) * sin(u * 180)
                self.rot = self.A - 90 + sin(u * 90) * 720 * self.d
                self.hscale, self.vscale = BLUE_SIZE, BLUE_SIZE
                if i % 14 == 1 then
                    local o = fly(butterfly, 12, self.x, self.y, 1 + 2 * u, self.rot + 90, 0)
                    o._r, o._g, o._b = 150, 214, 255
                end
            elseif i <= BLUE_T + 24 then
                local h, v = fan_close(i - BLUE_T)
                self.hscale, self.vscale = h * BLUE_SIZE, v * BLUE_SIZE
            else
                object.RawDel(self)
            end
        end,
        render = function(self)
            if self.hscale <= 0 then
                return
            end
            SetImageState(BLUE_IMG, "mul+add", 215, 210, 236, 255)
            Render(BLUE_IMG, self.x, self.y, self.rot, self.hscale, self.vscale)
        end,
    }, true)

    do
        local name = "扇符「胡蝶扇舞」"
        local card = boss.card.New(name, 1, 1, 60, 850)
        boss.card.add({ { card, "1a" } }, 24, name, 278)

        function card:before()
            --⚠ 这里**不要**再开一把舞扇：init 里那把是常驻的（hold = 0），
            --   两把叠在同一个位置会互相盖住，看起来像在乱闪。
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__fans = {}
            --限位层：**顶部 + 左右**的扇幕。每把扇走完整生命周期，
            --同一槽位隔 FAN_CYCLE 帧再长一把新的（扇子炸掉 → 过几帧新扇子）。
            task.New(self, function()
                local w = lstg.world
                local slots = {}
                --锚点钉在场地边上，扇子以它为轴摆 —— 和参考卡一样
                --槽位表：{ x, y, rot, fdir, ssign, fires }
                --  rot / fdir 的区别见 class["th04_fan"] 头注释：
                --  四边的 rot 一律让**扇面开口朝场内**，fdir 一律是**朝场内的发射方向**。
                --  ssign 是摆动符号 —— 参考卡里镜像成对的两把是 +ran / -ran。
                --上下两排：**扇框**，只摆不发（参考卡的边缘扇本来就是围场用的）
                for i = 0, FAN_TOP - 1 do
                    local x = w.l + (w.r - w.l) * i / (FAN_TOP - 1)
                    slots[#slots + 1] = { x, w.t - FAN_EDGE, 180, -90, -1, false }
                    slots[#slots + 1] = { x, w.b + FAN_EDGE, 0, 90, 1, false }
                end
                --左右两侧：**5 way 发弹**（这就是「侧面 5 way」，弹朝场内）
                for i = 0, FAN_SIDE - 1 do
                    local y = w.b + FAN_EDGE + (w.t - w.b - FAN_EDGE * 2) * i / (FAN_SIDE - 1)
                    slots[#slots + 1] = { w.l, y, -90, 0, 1, true }
                    slots[#slots + 1] = { w.r, y, 90, 180, -1, true }
                end
                PlaySound("kira00", 0.25, 0, true)
                while true do
                    for i = 1, #slots do
                        local s = slots[i]
                        self.__fans[#self.__fans + 1] =
                                New(class["th04_fan"], s[1], s[2], s[3], s[4], s[5], s[6])
                    end
                    task.Wait(FAN_CYCLE)
                    --清掉已经自收的引用，别让表无限涨
                    for i = #self.__fans, 1, -1 do
                        if not IsValid(self.__fans[i]) then
                            table.remove(self.__fans, i)
                        end
                    end
                end
            end)
            --实弹层：金扇转 + 华尔兹 + 蝶弹环 + 蓝扇转（**照参考卡的顺序**）
            task.New(self, function()
                local d = 1
                local t = RING_T0
                local n = ORBIT_N0
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                task.Wait(FAN_OPEN + FAN_HOLD)
                while true do
                    Newcharge_in(self.x, self.y, 255, 246, 190)
                    --① 两只金扇（**会转的那把**），一正一反开场转起来
                    --   —— 参考卡就是每轮开头先放金扇，再走位
                    local ga = ran:Float(0, 360)
                    for _ = 1, 2 do
                        attach(self, New(class["th04_goldenfan"], self, ga, d))
                        ga = ga + 180
                    end
                    task.Wait(60)
                    --② 华尔兹：按场地宽度缩过的端点（参考卡是 ±180 / 640 宽）
                    task.CRMoveTo(WALTZ_T, VALUE_SET.DECEL,
                            -WALTZ_X * d, WALTZ_Y1, 0, WALTZ_Y2, WALTZ_X * d, WALTZ_Y1)
                    PlaySound("tan00", 0.1, self.x / 256, true)
                    --③ 自机方向轮盘
                    local a = Angle(self, player)
                    for _ = 1, t do
                        for v = 1, 3 do
                            local o = fly(butterfly, 2 + (v - 1) * 2, self.x, self.y,
                                    RING_V0 + (v - 1) * RING_DV, a, 0)
                            o._r, o._g, o._b = 255, 200, 232
                        end
                        a = a + 360 / t
                    end
                    Newcharge_out(self.x, self.y, 255, 255, 100)
                    --④ 蓝扇（**也会转**）：绕 boss 一圈放出去，各飞向自机再飞回
                    local A = a
                    for i = 1, int(n) do
                        attach(self, New(class["th04_bluefan"], self, d, A))
                        A = A + 360 / int(n)
                    end
                    d = -d
                    n = min(n + ORBIT_DN, 10)
                    t = min(t + RING_DT, RING_TMAX)
                    task.Wait(WALTZ_REST)
                end
            end)
            --起舞动画：boss 身后那把随开随合的大扇（常驻）
            task.New(self, function()
                task.Wait(FAN_OPEN)
                self.__dancefan = New(class["th04_dancefan"], self, 0)
            end)
        end

        function card:del()
            local fans = self.__fans or {}
            for i = 1, #fans do
                if IsValid(fans[i]) then
                    object.RawDel(fans[i])
                end
            end
            self.__fans = {}
            if IsValid(self.__dancefan) then
                object.RawDel(self.__dancefan)
            end
            self.__dancefan = nil
        end
    end
end

--============================
--[卡4] 死符「无寿之栏」
--  限位：直接夹住自机的方框，分三档收缩（蝴蝶梦之舞的做法，但把档位标出来）
--  缺口：无（整块缩小）
--  容错：每档之间留 300 帧。第一档只夹纵向（224→173），第二三档才夹横向；
--        最坏一次要从 (192,173) 挪到 (136,122)，走 56 px → 14 帧，余量 21 倍。
--        夹的速度限在 6 px/帧（连续推），不要写成硬 min/max —— 那是单帧瞬移。
--  预警：第一档生效前 90 帧先闪框；之后每次收缩前 60 帧闪下一档的框
--  预警：每次收缩前 60 帧，用亮框画出「下一档的边界」
--  实弹：同心环，每环留一个旋转缺口（缺口每环前进 5 格）
--============================
do
    -- ⚠ 半宽必须小于可视区半宽 192，否则夹了等于没夹（th08 的蝴蝶梦之舞只有纵向生效）
    local STEPS = { 192, 164, 136 }   -- 三档半宽（都在 192 以内，真的会夹住）
    local STEP_RATIO = 0.9            -- 半高 = 半宽 × 这个（224 → 173/148/122）
    local STEP_T = 300                -- 每档撑多少帧
    local START_WARN = 90             -- 第一档生效前的预热（框只画不夹）
    local FRAME_WARN = 60             -- 之后每次收缩前提前多少帧画预警
    local RING_GAP = 34
    local RING_N = 38
    local GAP_W = 7
    local GAP_STEP = 5
    local RING_V = 3.1
    local AIM_GAP = 150
    local BOSS_X, BOSS_Y = 0, 150

    ---当前处在第几档（预热期算第 1 档）。
    ---注意：卡的 before/init/frame/render/del 才是被引擎按名字调用的，
    ---其余方法挂在卡表上、用 self 取不到（self 是 boss），所以只能做成局部函数
    local function cur_step(t)
        local k = max(0, t - START_WARN)
        return min(int(k / STEP_T) + 1, #STEPS)
    end

    do
        local name = "死符「无寿之栏」"
        local card = boss.card.New(name, 1, 1, 60, 750)
        boss.card.add({ { card, "1a" } }, 24, name, 279)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        ---画一个方框（预警用）
        local function draw_box(hw, hh, alpha)
            SetImageState("white", "mul+add", alpha, 255, 160, 180)
            Render("white", 0, hh, 0, hw / 8, 0.06)
            Render("white", 0, -hh, 0, hw / 8, 0.06)
            Render("white", -hw, 0, 90, hh / 8, 0.06)
            Render("white", hw, 0, 90, hh / 8, 0.06)
        end

        ---限速夹：一帧最多推 PUSH_V px。
        ---直接写 min/max 会在收缩那一帧把自机瞬移几十 px（实测峰值 32 px/帧），
        ---手感上是「被打飞了一下」，不是「被框住」。
        local PUSH_V = 6
        local function clamp_axis(v, lim)
            if v > lim then
                return max(lim, v - PUSH_V)
            elseif v < -lim then
                return min(-lim, v + PUSH_V)
            end
            return v
        end

        function card:frame()
            --自己的计时器（不能用 self.ani：那是 boss 出生以来的总帧数）
            self.__t = (self.__t or 0) + 1
            if self.__t < START_WARN then
                return                    -- 预热期：框只画不夹
            end
            local step = cur_step(self.__t)
            self.__hw = STEPS[step]
            local hh = self.__hw * STEP_RATIO
            player.x = clamp_axis(player.x, self.__hw)
            player.y = clamp_axis(player.y, hh)
        end

        function card:render()
            local t = self.__t or 0
            if t < START_WARN then
                --预热：第一档的框先闪 90 帧，玩家看清要收到哪儿
                local k = 0.4 + 0.6 * sin(t * 9)
                draw_box(STEPS[1], STEPS[1] * STEP_RATIO, 100 * k)
                return
            end
            local step = cur_step(t)
            local left = STEP_T - ((t - START_WARN) % STEP_T)
            if step < #STEPS and left <= FRAME_WARN then
                --下一档的框：收缩前 60 帧开始闪
                local k = 0.4 + 0.6 * sin(t * 17)
                local nh = STEPS[step + 1]
                draw_box(nh, nh * STEP_RATIO, 90 * k)
            end
        end

        function card:init()
            self.__t = 0
            task.New(self, function()
                local gap = 0
                task.Wait(60)
                Newcharge_in(self.x, self.y, 226, 178, 246)
                boss.cast(self, 60)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 226, 178, 246)
                while true do
                    for i = 1, RING_N do
                        if not ((i - gap) % RING_N < GAP_W) then
                            local a = (i - 1) * 360 / RING_N
                            local o = fly(ball_mid, 12, self.x, self.y, RING_V, a, 0)
                            o._r, o._g, o._b = 226, 178, 246
                        end
                    end
                    PlaySound("tan00", 0.05, self.x / 256, true)
                    gap = gap + GAP_STEP
                    task.Wait(RING_GAP)
                end
            end)
            task.New(self, function()
                task.Wait(200)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 5 do
                        local o = fly(ball_big, 2, self.x, self.y, 3.4, a0 + (k - 3) * 9, 0)
                        o._r, o._g, o._b = 255, 168, 200
                    end
                    task.Wait(AIM_GAP)
                end
            end)
        end
    end
end

--============================
--[卡5] 幽符「西行妖」
--  限位：用「沿半径排成一条线」的子弹拼出六芒星结界（樱花结界的做法）
--  缺口：6 条射线之间 60° 的角缝；在 R=140 处每条缝约 146 px
--  实测：60px 内峰值 49 发 —— 峰值出现在射线收敛到中心那一瞬，
--        但自动机 3000 帧里只被贴身 7 帧，说明窗口够躲
--  容错：结界每 200 帧张缩一次，**张到最大半径时才吐弹，弹朝内飞**。
--        原来在中间半径吐，线的最内端正好落在自机头上（实测 60px 内峰值 53 发）
--  预警：结界出现前先画 6 条暗线，第 90 帧才落成实弹
--  实弹：枝端绽放的 7 向花瓣 + 从上方飘落的花雨（每 18 帧一片）
--  实测：60px 内峰值 19 发、最大空隙 90° —— 是全十张里最松的一张，
--        所以花雨从 26 帧加密到 18 帧
--============================
do
    local ARMS = 6                    -- 六条射线
    local LINE_N = 12                 -- 每条线排几颗（6×12=72 发/轮）
    -- ⚠ 线要整条落在回收边界(±224/±256)内侧：boss 在 y=60，
    -- 所以 最远半径 R_OUT + LINE_HALF 必须 ≤ 196
    local R_IN, R_OUT = 80, 140       -- 张缩半径
    local PULSE = 200                 -- 一次张缩
    local LINE_HALF = 38              -- 每条线以 self.r 为中心、上下各排这么长
    local LINE_V = 1.6                -- 线的漂移速度
    local TREE_WARN = 90
    local BLOOM_N = 7
    local BLOOM_V = 2.3
    local BOSS_X, BOSS_Y = 0, 60

    class["th04_hexagram"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.rot = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(m) then
                cx, cy = m.x, m.y
            end
            self.cx, self.cy = cx, cy
            self.t = self.t + 1
            self.rot = (self.rot + 0.35) % 360
            local ph = self.t * 360 / PULSE
            self.r = (R_IN + R_OUT) * 0.5 + (R_OUT - R_IN) * 0.5 * sin(ph)
            --整面结界出现前只画不判
            if self.t < TREE_WARN then
                return
            end
            if self.t == TREE_WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            --张到最大半径时才把这一轮的线放出去：吐弹点离自机越远，玩家越有反应时间
            if self.t % PULSE == int(PULSE * 0.25) then
                --每条臂 = 沿半径 a 从 (r - LINE_HALF) 排到 (r + LINE_HALF) 的一列弹；
                --六条这样的径向线就拼成一个六芒星（樱花结界的做法）
                for k = 1, ARMS do
                    local a = self.rot + (k - 1) * 360 / ARMS
                    for i = 1, LINE_N do
                        local f = (i - 1) / (LINE_N - 1) - 0.5   -- -0.5 ~ 0.5
                        local rr = self.r + f * 2 * LINE_HALF
                        local px, py = cx + cos(a) * rr, cy + sin(a) * rr
                        --自机站在线上时，这个点挪到对面那条臂上（六条臂 180° 对径，
                        --图案仍是六重对称；不挖洞、不少发）
                        px, py = mirror_spawn(cx, cy, px, py, LINE_V)
                        local o = fly(ellipse, 6, px, py, LINE_V, a + 180, 0)
                        o._r, o._g, o._b = 255, 206, 230
                    end
                end
                --枝端绽放
                for k = 1, ARMS do
                    local a = self.rot + (k - 1) * 360 / ARMS
                    local bx, by = cx + cos(a) * self.r, cy + sin(a) * self.r
                    --枝端离自机太近就整簇挪到对面那条臂上（不挖洞、不少发）
                    bx, by = mirror_spawn(cx, cy, bx, by, BLOOM_V)
                    for j = 1, BLOOM_N do
                        local ang = a + (j - (BLOOM_N + 1) / 2) * 20
                        local o = fly(butterfly, 2 + (j % 2) * 2,
                                bx, by, BLOOM_V, ang, 1.4)
                        o._r, o._g, o._b = 255, 190, 224
                    end
                end
                PlaySound("tan00", 0.06, 0, true)
            end
        end,
        render = function(self)
            local r = self.r or R_IN
            local alpha = self.t < TREE_WARN and (60 + 90 * sin(self.t * 7)) or 130
            for k = 1, ARMS do
                local a = self.rot + (k - 1) * 360 / ARMS
                thin_line(self.cx, self.cy, self.cx + cos(a) * r, self.cy + sin(a) * r,
                        alpha, 220, 170, 230, 0.09)
            end
            draw_orb(self.cx, self.cy, 0.8, 0.8, 255, 210, 240)
        end,
    }, true)

    do
        local name = "幽符「西行妖」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 280)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__hex = New(class["th04_hexagram"], self)
            --实弹层：花雨
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 214, 244)
                boss.cast(self, 90)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 214, 244)
                while true do
                    attach(self, New(class["th04_petal"],
                            ran:Float(lstg.world.l, lstg.world.r), 236))
                    task.Wait(18)
                end
            end)
        end

        function card:del()
            if IsValid(self.__hex) then
                object.RawDel(self.__hex)
            end
            self.__hex = nil
        end
    end
end

--============================
--[卡6] 蝶符「凤蝶圆舞」
--  限位：四条旋转的蝶臂，臂间 90° 的角缝
--  缺口：90°（在 R=120 处弧长约 188 px，是全项目最宽的「规律型」缺口）
--  容错：臂以 0.8°/帧 转，扫过 90° 要 112 帧 → 容错 112 帧（余量 7 倍，偏宽松）
--  预警：前 60 帧只画出四条臂的骨架，之后才挂上蝶
--  实弹：臂上的蝶沿切向排开，越靠外越快（v 从 2.2 插值到 3.0），另有 boss 的瞄准轮
--============================
do
    local ARMS = 4
    local ARM_SPIN = 0.8              -- 臂的角速度
    local ARM_R0, ARM_R1 = 60, 150    -- 臂上的弹从内往外排
    local ARM_N = 7                   -- 一条臂上几颗
    -- ⚠ sin/cos 改成角度制之后臂的自转相位变了，同样参数下弹会挤到一起
    --   （实测 4.5 次/秒 → 拉开间隔收到同档）
    local ARM_GAP = 40                -- 发一轮的间隔
    local ARM_V0, ARM_DV = 2.2, 0.8
    local WARN = 60
    local AIM_GAP = 170
    local BOSS_X, BOSS_Y = 0, 40

    class["th04_wheel"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.rot = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            self.cx, self.cy = BOSS_X, BOSS_Y
            if IsValid(m) then
                self.cx, self.cy = m.x, m.y
            end
            self.t = self.t + 1
            self.rot = (self.rot + ARM_SPIN) % 360
            if self.t < WARN then
                return
            end
            if self.t % ARM_GAP == 0 then
                for k = 1, ARMS do
                    local a = self.rot + (k - 1) * 360 / ARMS
                    --一条臂上的弹从内到外排开，越外面越快 → 臂被拉成一道弧
                    for i = 1, ARM_N do
                        local r = ARM_R0 + (ARM_R1 - ARM_R0) * (i - 1) / (ARM_N - 1)
                        local o = fly(butterfly, 2 + (k % 2) * 2,
                                self.cx + cos(a) * r, self.cy + sin(a) * r,
                                ARM_V0 + (i - 1) / (ARM_N - 1) * ARM_DV, a + 90, 1.5)
                        o._r, o._g, o._b = 255, 176, 214
                    end
                end
                PlaySound("tan00", 0.04, self.cx / 256, true)
            end
        end,
        render = function(self)
            local k = self.t < WARN and (0.35 + 0.65 * sin(self.t * 8)) or 0.5
            for i = 1, ARMS do
                local a = self.rot + (i - 1) * 360 / ARMS
                thin_line(self.cx + cos(a) * ARM_R0, self.cy + sin(a) * ARM_R0,
                        self.cx + cos(a) * ARM_R1, self.cy + sin(a) * ARM_R1,
                        90 * k, 226, 150, 220, 0.09)
            end
            draw_butterfly(self.cx, self.cy, self.rot, 0.7, 220, self.t * 0.2, 2)
        end,
    }, true)

    do
        local name = "蝶符「凤蝶圆舞」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 281)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__wheel = New(class["th04_wheel"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                task.Wait(WARN)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 6 do
                        local o = fly(ball_small, 4, self.x, self.y, 2.6,
                                a0 + (k - 4) * 9, 0)
                        o._r, o._g, o._b = 255, 180, 214
                    end
                    task.Wait(AIM_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__wheel) then
                object.RawDel(self.__wheel)
            end
            self.__wheel = nil
        end
    end
end

--============================
--[卡7] 樱符「樱吹雪」
--  题眼是「风」，不是「雪」。风每 360 帧反向，把**已经在空中的花瓣**整体吹歪。
--
--  实弹（主）：boss 每 72 帧放一轮 18 路 × 3 档速度（2.0 / 2.7 / 3.4）。
--    操作频率 = 72 帧/决策，落在 AGENTS.md 10.6 的舒适区（20~100）里。
--  限位（风 + 花幕）：花瓣每 20 帧 2 片从上游进来（约 6 片/秒），v=1.3，
--    半透明（_a=170）、小尺寸、**不自转**（自转会让轨迹读不出来，是纯噪声）。
--    风顺着吹的时候花幕被拉疏，风逆着吹的时候新花顶着风挤成一团 ——
--    这个疏密变化就是「吹雪」的可读节奏，也是给玩家的呼吸口。
--  容错：风反向的瞬间外力为 0，那 ±20 帧是自由窗口（th095 的做法）。
--  预警：两侧风柱的亮度直接显示当前风向；反转前 60 帧开始渐变压向另一边。
--
--  同屏量：花瓣 ~20 + 扇形 ~50 ≈ 70。**别把 BLOW_GAP 调回个位数** ——
--  那会让这张卡从「读风的节奏」退化成「持续 60 秒的噪声微操」。
--============================
do
    local WIND_PERIOD = 360
    local WIND_MAX = 1.5
    local BLOW_GAP = 20              -- 每 20 帧放一撮（2 片）→ 约 6 片/秒
    local BLOW_N = 2
    local BLOW_V = 1.3
    local BLOW_SPREAD = 22
    local AIM_GAP = 72               -- 实弹轮的间隔：这就是玩家的操作频率
    local AIM_WAYS = 18
    local AIM_V0, AIM_DV = 2.0, 0.7
    local BOSS_X, BOSS_Y = 0, 150

    local wind_vx = 0
    local wind_dead = {}

    local function blow(o)
        if o.th04_wind then
            o.x = o.x + wind_vx
            o.th04_age = (o.th04_age or 0) + 1
            if o.th04_age > 300 then
                wind_dead[#wind_dead + 1] = o
            end
        end
    end

    class["th04_windwall"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function() end,
        render = function(self)
            --两侧的风柱：哪边亮，风就从哪边吹过来
            local w = lstg.world
            local k = wind_vx / WIND_MAX           -- -1 ~ 1
            --哪边的风柱亮，风就是从哪边吹过来的
            if k < -0.02 then
                SetImageState("white", "mul+add", -k * 110, 190, 226, 255)
                RenderRect("white", w.l, w.l + 26, w.b, w.t)
            elseif k > 0.02 then
                SetImageState("white", "mul+add", k * 110, 190, 226, 255)
                RenderRect("white", w.r - 26, w.r, w.b, w.t)
            end
        end,
    }, true)

    do
        local name = "樱符「樱吹雪」"
        local card = boss.card.New(name, 1, 1, 60, 750)
        boss.card.add({ { card, "1a" } }, 24, name, 282)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:frame()
            self.__t = (self.__t or 0) + 1
            wind_vx = WIND_MAX * sin(self.__t * 360 / WIND_PERIOD)
            object.BulletDo(blow)
            if #wind_dead > 0 then
                for i = #wind_dead, 1, -1 do
                    object.RawDel(wind_dead[i])
                    wind_dead[i] = nil
                end
            end
        end

        function card:init()
            wind_vx = 0
            self.__t = 0
            for i = #wind_dead, 1, -1 do wind_dead[i] = nil end
            self.__wall = New(class["th04_windwall"])
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 190, 226, 255)
                boss.cast(self, 60)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 190, 226, 255)
                while true do
                    local from_left = wind_vx >= 0
                    local x = from_left and (lstg.world.l - 16) or (lstg.world.r + 16)
                    for _ = 1, BLOW_N do
                        -- 不自转：轨迹要能一眼读出来，否则就是噪声
                        local o = fly(ellipse, 4, x,
                                ran:Float(lstg.world.b - 10, lstg.world.t + 10),
                                BLOW_V, ran:Float(-BLOW_SPREAD, BLOW_SPREAD)
                                + (from_left and 0 or 180), 0)
                        o._r, o._g, o._b = 255, 194, 224
                        o._a = 170               -- 半透明，别糊住屏幕
                        o.th04_wind = true
                    end
                    task.Wait(BLOW_GAP)
                end
            end)
            task.New(self, function()
                task.Wait(120)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, AIM_WAYS do
                        for v = 1, 3 do
                            local o = fly(ball_mid, 2, self.x, self.y,
                                    AIM_V0 + (v - 1) * AIM_DV, a0 + (k - 1) * 360 / AIM_WAYS, 0)
                            o._r, o._g, o._b = 255, 178, 212
                        end
                    end
                    PlaySound("tan00", 0.07, self.x / 256, true)
                    task.Wait(AIM_GAP)
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
--[卡8] 灵符「亡灵之渡」
--  限位：三途川上的三条摆渡船——**只有船周围 85 px 圆内，敌弹才有判定**
--        （th12「血バサミ女」的圆环判定做法，把「哪里危险」变成可移动的区域）
--  缺口：船外全是安全区，等于是「跟着船走」的反向限位
--  容错：船 100 帧横穿 520 px（5.2 px/帧，比玩家 4 px/帧 还快）。
--        四条船的判定圈总覆盖约 4×π×85² / (384×448) ≈ 53%，
--        留下的是会移动的缝，所以必须跟着缝走，不能站定
--  预警：船出现前 90 帧先画出三条航线和判定圈
--  实弹：① 全屏铺一层「平时无判定」的慢速花弹（只有进圈才致命）
--        ② 每 90 帧一轮 16 路瞄准环（v=2.4）
--
--  ⚠ 两个坑，都是实测（tools/check_stage.lua --threat）才看出来的：
--    · 三条船必须**纵向铺满**场地。原来挤在 y=-240/-150/-60，上半屏永远是安全区，
--      机器人直接停在上边：60px 内全程 0 发。
--    · **只有限位层是不够的**。没有实弹层时，最优解是「站到圈外不动」，
--      实测仍然是 60px 内全程 0 发 —— 那张卡等于空的。瞄准环就是为了逼玩家动，
--      一动就得在圈与圈之间穿，限位才真正生效。
--============================
do
    local BOAT_R = 105                -- 判定半径（原来 70；太小的话绕开就没事）
    local BOAT_N = 5                  -- 5 条船把判定圈铺到覆盖全场（实测 3~4 条都留了太大的安全区）
    local CROSS_T = 100               -- 横渡耗时（原来 300；扫得越快，越逼你跟着挪）
    local SHIP_WARN = 90
    -- 每波铺几颗 / 多久一波。这两个数直接决定同屏对象数：
    --   峰值 ≈ FIELD_N × (穿场帧数 / FIELD_GAP)，穿场约 600 帧，所以取 22/150 → 峰值 ~170
    -- 船圈总覆盖面积约 3×π×85² ≈ 全场 40%，所以 170 颗里随时有 ~65 颗在圈内
    local FIELD_N = 22
    local FIELD_GAP = 150
    local FIELD_V = 0.6               -- 极慢，会长时间滞留在圈里
    local BOSS_X, BOSS_Y = 0, 150

    ---摆渡船：只负责移动和画圈；判定由它给全场的花弹打标
    class["th04_boat"] = Class(object, {
        init = function(self, dir, phase)
            self.dir = dir
            self.phase = phase
            self.t = 0
            self.x = -dir * 260
            self.base_y = -180 + phase * 90       -- 五条船纵向铺满
            self.y = self.base_y
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t < SHIP_WARN then
                return
            end
            local k = ((self.t - SHIP_WARN) % CROSS_T) / CROSS_T
            self.x = (-260 + 520 * k) * self.dir
            -- 上下慢摆：让「安全高度」也一直在挪
            self.y = self.base_y + sin((self.t - SHIP_WARN) * 0.018 + self.phase) * 50
        end,
        render = function(self)
            local warn = self.t < SHIP_WARN
            local k = warn and (0.4 + 0.6 * sin(self.t * 8)) or 1
            --航线
            thin_line(-260 * self.dir, self.base_y, 260 * self.dir, self.base_y,
                    70 * k, 190, 226, 255, 0.06)
            --判定圈
            arc(self.x, self.y, BOAT_R, 0, 360, 32, 130 * k, 255, 170, 200, 0.10)
            draw_orb(self.x, self.y, 0.7, 0.9 * k, 226, 240, 255)
        end,
    }, true)

    ---花弹：平时 colli = false，进圈才 lethal
    class["th04_lilybullet"] = Class(object, {
        init = function(self, x, y, v, a, boats)
            self.x, self.y = x, y
            self.vx, self.vy = v * cos(a), v * sin(a)
            self.boats = boats
            --INDES：打不掉，但 colli 为真时会撞自机 —— 正合适这种「时有时无的判定」
            self.group, self.layer = GROUP.INDES, LAYER.ENEMY_BULLET
            self.bound, self.colli = true, false
            self.hscale, self.vscale = 1.2, 0.8
            self._blend, self._a = "mul+add", 200
            self._r, self._g, self._b = 255, 190, 222
        end,
        frame = function(self)
            local lethal = false
            for i = 1, #self.boats do
                local b = self.boats[i]
                if IsValid(b) and b.t >= SHIP_WARN then
                    if Dist(self.x, self.y, b.x, b.y) < BOAT_R then
                        lethal = true
                        break
                    end
                end
            end
            self.colli = lethal
            self._a = lethal and 255 or 90
        end,
        render = function(self)
            draw_petal(self.x, self.y, 0, 1.0, self._a, 255, 190, 222)
        end,
    }, true)

    do
        local name = "灵符「亡灵之渡」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 283)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__boats = {}
            for i = 1, BOAT_N do
                self.__boats[#self.__boats + 1] =
                        New(class["th04_boat"], (i % 2 == 0) and 1 or -1, i - 1)
            end
            -- 实弹层：没有它，这张卡就是「站圈外不动」
            task.New(self, function()
                task.Wait(120)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 16 do
                        local o = fly(ball_mid, 4, self.x, self.y, 2.4,
                                a0 + (k - 1) * 360 / 16, 0)
                        o._r, o._g, o._b = 255, 186, 220
                    end
                    PlaySound("tan00", 0.06, self.x / 256, true)
                    task.Wait(90)
                end
            end)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 170, 200)
                task.Wait(SHIP_WARN)
                while true do
                    for _ = 1, FIELD_N do
                        attach(self, New(class["th04_lilybullet"],
                                ran:Float(lstg.world.l, lstg.world.r),
                                ran:Float(lstg.world.b, lstg.world.t),
                                FIELD_V * ran:Float(0.6, 1.4),
                                ran:Float(0, 360), self.__boats))
                    end
                    PlaySound("tan00", 0.06, 0, true)
                    task.Wait(FIELD_GAP)
                end
            end)
        end

        function card:del()
            local bs = self.__boats or {}
            for i = 1, #bs do
                if IsValid(bs[i]) then object.RawDel(bs[i]) end
            end
            self.__boats = {}
        end
    end
end

--============================
--[卡9] 结界「生死之境」
--  限位：两个反向旋转、且反相张缩的六边形结界（樱花结界的立体版）
--  缺口：张的时候半径 168，缝在六个角之间；缩到 70 时缝收窄但两环错开 30°，
--        所以「一个缩进去的时候另一个正张开」，永远有一条路
--  容错：一次张缩 150 帧。**每个六边形在自己张到最大时才吐弹、弹朝内飞**，
--        两个六边形错开半个周期（每 75 帧一发）→ 有节奏也留足反应时间。
--        原来是在缩到最小时吐，等于贴着自机吐弹（实测 60px 内峰值 60 发、只剩 15° 缝）
--  预警：结界出现前 90 帧只画两个六边形的骨架
--  实弹：每 190 帧补一轮玩家方向的轮盘（18 路起，封顶 48）
--============================
do
    local HEX_CX, HEX_CY = 0, -6
    local R_IN, R_OUT = 70, 168
    local PULSE = 200                 -- 原来 150：两个六边形每 75 帧就轮着收一次，太密
    local EMIT_A = int(PULSE * 0.25)          -- A 张到最大时
    local EMIT_B = int(PULSE * 0.75)          -- B 张到最大时（错开半个周期）
    local HEX_STEPS = 7              -- 每条边排几颗（6×7=42 发/轮；原来 9 → 54 发）
    local HEX_V = 2.4
    local HEX_WARN = 90
    local WHEEL_GAP = 190
    local WHEEL_T0, WHEEL_TMAX = 18, 48
    local BOSS_X, BOSS_Y = 0, 150

    local function emit_hex(cx, cy, R, rot, col)
        for k = 1, 6 do
            local a0 = rot + (k - 1) * 60
            local a1 = rot + k * 60
            local x0, y0 = cx + cos(a0) * R, cy + sin(a0) * R
            local x1, y1 = cx + cos(a1) * R, cy + sin(a1) * R
            for i = 0, HEX_STEPS - 1 do
                local f = i / HEX_STEPS
                local px, py = x0 + (x1 - x0) * f, y0 + (y1 - y0) * f
                -- 朝内飞：吐弹点在最大半径上，离自机最远
                -- 自机正好站在结界边上时，这个点挪到对边（六边形中心对称，图案不破）
                px, py = mirror_spawn(cx, cy, px, py, HEX_V)
                local o = fly(square, col, px, py, HEX_V, Angle(cx, cy, px, py) + 180, 0)
                o._r, o._g, o._b = 224, 192, 255
            end
        end
    end

    local function draw_hex(cx, cy, R, rot, a)
        local px, py
        for k = 1, 6 do
            local ang = rot + (k - 1) * 60
            local nx, ny = cx + cos(ang) * R, cy + sin(ang) * R
            if px then
                thin_line(px, py, nx, ny, a, 200, 190, 255, 0.075)
            end
            px, py = nx, ny
        end
        thin_line(px, py, cx + cos(rot) * R, cy + sin(rot) * R, a, 200, 190, 255, 0.075)
    end

    class["th04_barrier"] = Class(object, {
        init = function(self)
            self.t = 0
            self.rot_a, self.rot_b = 0, 60
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            self.rot_a = (self.rot_a + 0.55) % 360
            self.rot_b = (self.rot_b - 0.55) % 360
            local ph = self.t * 360 / PULSE
            self.r_a = (R_IN + R_OUT) * 0.5 + (R_OUT - R_IN) * 0.5 * sin(ph)
            self.r_b = (R_IN + R_OUT) * 0.5 - (R_OUT - R_IN) * 0.5 * sin(ph)
            if self.t < HEX_WARN then
                return
            end
            if self.t % PULSE == EMIT_A then
                emit_hex(HEX_CX, HEX_CY, self.r_a, self.rot_a, 6)
                PlaySound("tan00", 0.07, 0, true)
            elseif self.t % PULSE == EMIT_B then
                emit_hex(HEX_CX, HEX_CY, self.r_b, self.rot_b, 10)
                PlaySound("tan00", 0.05, 0, true)
            end
        end,
        render = function(self)
            local k = self.t < HEX_WARN and (0.4 + 0.6 * sin(self.t * 7.5)) or 1
            draw_hex(HEX_CX, HEX_CY, self.r_a, self.rot_a, 150 * k)
            draw_hex(HEX_CX, HEX_CY, self.r_b, self.rot_b, 110 * k)
            draw_orb(HEX_CX, HEX_CY, 0.55, 0.7 * k, 255, 214, 244)
        end,
    }, true)

    do
        local name = "结界「生死之境」"
        local card = boss.card.New(name, 1, 1, 60, 850)
        boss.card.add({ { card, "1a" } }, 24, name, 284)

        function card:before()
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__barrier = New(class["th04_barrier"])
            task.New(self, function()
                local t = WHEEL_T0
                task.Wait(60)
                Newcharge_in(HEX_CX, HEX_CY, 200, 190, 255)
                task.Wait(HEX_WARN)
                while true do
                    local a0 = Angle(self, player)
                    --① 改展开：自机贴上来时，轮盘从「朝自机的扇形」改成**整圈均匀**，
                    --   弹数一发不少，只是不再对着自机扎（不挖洞）
                    local aimed = not near_player(self.x, self.y, 2.7)
                    for i = 1, t do
                        for v = 1, 2 do
                            local sp = 1.2 + (v - 1) * 1.5
                            --朝自机时是 t 路；改成整圈时把两档交错铺满 360°（共 2t 路）
                            local ang
                            if aimed then
                                ang = a0 + (i - 1) * 360 / t
                            else
                                ang = ((i - 1) * 2 + (v - 1)) * 360 / (t * 2)
                            end
                            local o = fly(ball_mid, 4, self.x, self.y, sp, ang, 0)
                            o._r, o._g, o._b = 255, 184, 218
                        end
                    end
                    PlaySound("tan00", 0.08, self.x / 256, true)
                    t = min(t + 3, WHEEL_TMAX)
                    task.Wait(WHEEL_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__barrier) then
                object.RawDel(self.__barrier)
            end
            self.__barrier = nil
        end
    end
end

--============================
--[终符] 「彼岸无余涅槃」
--  血量驱动四阶段，只追加不替换（th01 镜花水月的路子）：
--    ① 蝶环 + 花雨        ② 追加六芒结界
--    ③ 追加摆渡船（判定圈） ④ 追加风 + 全屏花幕
--  ⚠ 用了 ToBigScreen，场地变成 ±320/±240，但**回收边界还是 ±224/±256**，
--     所以墙的半宽/半高必须取 216/250（都在边界内侧），不能按大屏尺寸去撑。
--     缺口用周长参数定位，跟着墙一起走，不受横竖比例影响。
--  难度递进：四阶段**把缺口从 1.8 格逐档收窄到 1.0 格**（而不是再叠一面墙 ——
--     试过叠墙，同屏弹数会从 ~370 冲到 980）。转阶段时缺口当帧就变窄，
--     所以「阶段推进了」玩家立刻能感觉到，不用等新那一层的 90 帧预警走完。
--============================
do
    -- ⚠ 阈值必须落在**本张卡的血量之内**。
    --   原来写 700/1400/2100，而卡的血只有 1200 —— 于是三、四阶段**永远不可能
    --   靠掉血触发**，只能干等兜底计时器。玩家看到的就是「我把血打下去了，
    --   却没有新弹幕」。现在按血量的 25/50/75% 分，四个阶段各占约 300 血。
    local CARD_HP = 1200
    local HP_P2, HP_P3, HP_P4 = CARD_HP * 0.25, CARD_HP * 0.50, CARD_HP * 0.75
    -- 兜底计时：打不动也推进，但都要落在 t3 = 60s 之内
    local PH_P2, PH_P3, PH_P4 = 15 * 60, 28 * 60, 41 * 60
    local BOSS_X, BOSS_Y = 0, 60

    -- 大屏下场地是 ±320/±240，回收边界 ±224/±256 —— 注意横竖的关系翻过来了！
    -- 所以墙的半宽取 216（<224）、半高取 250（<256），仍然全在边界内侧
    -- 同上：以场地中心为心，贴到 ±220/±252，给自机留 28 px（1.15 px/帧 → 24 帧）
    local WALL_HW, WALL_HH = 220, 252
    local WALL_N = 52                -- 原来 72：收敛到中心时会挤成一团
    -- ⚠ 同上：墙速上限 1.2（24 px ÷ 20 帧），3.4 时贴着边站就是必中
    local WALL_V = 1.15              -- 压到公平速度，靠缺口节拍而不是速度给压力
    local WALL_CYCLE = 340           -- 补墙间隔（穿场约 243 帧 → 约 97 帧静默）
    local WALL_CYCLE_RAGE = 300      -- 四阶段加快（仍然留出静默）
    local WALL_JUMP = 200
    local WALL_WARN = 90
    local SLOTS = 16
    -- 每个阶段的缺口宽度与补墙间隔。**转阶段时立刻生效**：
    -- 新加的那一层（结界/摆渡船/风）需要 90 帧预警才吐弹，
    -- 但缺口收窄是当帧就能看见、能感觉到的 —— 否则玩家会觉得「转阶段没反应」。
    local GAP_SLOTS_BY_PHASE = { 1.8, 1.5, 1.2, 1.0 }
    local CYC_BY_PHASE = { WALL_CYCLE, 330, 315, WALL_CYCLE_RAGE }
    local PETAL_GAP = 26
    local BARRIER_R_OUT = 168

    local wind_vx = 0
    local wind_dead = {}

    local function blow(o)
        if o.th04_wind then
            o.x = o.x + wind_vx
            o.th04_age = (o.th04_age or 0) + 1
            if o.th04_age > 300 then
                wind_dead[#wind_dead + 1] = o
            end
        end
    end

    class["th04_nirvana"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.phase = 1
            self.t = 0
            self.gap_s = 0
            self.wind_t = 0
            wind_vx = 0
            self.orbs = {}
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            self.t = self.t + 1
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(m) then
                cx, cy = m.x, m.y
            end
            --阶段推进：血量（或兜底时间）驱动
            local left = 0
            if m and m._sp_point_auto then
                left = #m._sp_point_auto
            end
            local done = 3 - left
            if done >= 1 and self.phase < 2 then
                self.phase = 2
                Newcharge_out(cx, cy, 200, 190, 255)
            end
            if done >= 2 and self.phase < 3 then
                self.phase = 3
                Newcharge_out(cx, cy, 255, 170, 200)
            end
            if done >= 3 and self.phase < 4 then
                self.phase = 4
                PlaySound("kira00", 0.3, 0, true)
            end

            --① 蝶墙（全程）：四边内向墙，缺口 1.5 格，每 90 帧挪一格
            if self.t > WALL_WARN then
                if self.t % WALL_JUMP == 1 then
                    self.gap_s = (self.gap_s + 1 / SLOTS) % 1
                end
                local cyc = CYC_BY_PHASE[self.phase] or WALL_CYCLE
                local gw = (GAP_SLOTS_BY_PHASE[self.phase] or 1.5) / SLOTS
                if self.t % cyc == 1 and (self.t % WALL_JUMP) > 30 then
                    wall_with_gap(butterfly, (self.phase >= 4) and 4 or 2, 0, 0,
                            WALL_HW, WALL_HH, WALL_N, WALL_V, self.gap_s, gw)
                end
            end
            --① 花雨
            if self.t % PETAL_GAP == 0 then
                attach(m, New(class["th04_petal"], ran:Float(lstg.world.l, lstg.world.r),
                        lstg.world.t + 20))
            end

            --② 六芒结界（二阶段起）
            if self.phase >= 2 and not self.hex then
                -- 挂到 boss 名下：换卡时 refresh(1) 的 KillServants 会连带收掉，
                -- 不必只依赖「自己的 del 有没有被回调」这一条链
                self.hex = attach(m, New(class["th04_hexagram"], m))
            end

            --③ 摆渡船（三阶段起）
            if self.phase >= 3 and not self.boats then
                self.boats = {}
                for i = 1, 3 do
                    self.boats[#self.boats + 1] =
                            attach(m, New(class["th04_boat"], (i % 2 == 0) and 1 or -1, i - 1))
                end
            end

            --④ 风（四阶段起）
            if self.phase >= 4 then
                self.wind_t = self.wind_t + 1
                wind_vx = 1.7 * sin(self.wind_t * 360 / 460)
                object.BulletDo(blow)
                if #wind_dead > 0 then
                    for i = #wind_dead, 1, -1 do
                        object.RawDel(wind_dead[i])
                        wind_dead[i] = nil
                    end
                end
                -- 每 18 帧一片（约 3.3 片/秒）。**别调回个位数** ——
                -- 那会重演「樱吹雪」的毛病：持续几十秒的噪声微操，没有决策点
                if self.t % 18 == 0 then
                    local from_left = wind_vx >= 0
                    local o = fly(ellipse, 4,
                            from_left and (lstg.world.l - 16) or (lstg.world.r + 16),
                            ran:Float(lstg.world.b - 10, lstg.world.t + 10),
                            1.6, from_left and 0 or 180, 0)
                    o._r, o._g, o._b = 255, 196, 226
                    o._a = 170
                    o.th04_wind = true
                end
            end
        end,
        render = function() end,
        del = function(self)
            if IsValid(self.hex) then object.RawDel(self.hex) end
            local bs = self.boats or {}
            for i = 1, #bs do
                if IsValid(bs[i]) then object.RawDel(bs[i]) end
            end
            self.boats = nil
            self.hex = nil
        end,
    }, true)

    do
        local name = "「彼岸无余涅槃」"
        local card = boss.card.New(name, 1, 1, 60, CARD_HP)
        boss.card.add({ { card, "1a" } }, 24, name, 285)

        function card:before()
            ToBigScreen(60)
            open_dance_fan(self, 150)   --走位时身后展开的舞扇
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            --最后一个 true = 用本张符卡的计时器做兜底
            self._bosssys:addAutoSPPoint(HP_P2, PH_P2, true)
            self._bosssys:addAutoSPPoint(HP_P3, PH_P3, true)
            self._bosssys:addAutoSPPoint(HP_P4, PH_P4, true)
            self.__nir = New(class["th04_nirvana"], self)
        end

        function card:del()
            if IsValid(self.__nir) then
                object.RawDel(self.__nir)
            end
            self.__nir = nil
        end
    end
end
