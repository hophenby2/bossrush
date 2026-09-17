---=====================================
---TH21  西行庭：西行寺幽幽子（东方幕华祭 Part II 复刻，Lunatic）
---
---  来源：`/Users/happyelements/crack/THMHJ.PartII.Restored`
---    C#/XNA 的东方幕华祭 Part II 还原工程，引擎是 **Crazy Storm**。
---    定位、解码、以及从 C# 读出来的全部语义，都记在 `mod/GAME/THMHJ/NOTES.md`
---    （第十二~十五节尤其重要，含四处已被推翻的旧结论的更正）。
---
---  写法：**按原版数据重写行为**，不照搬 Crazy Storm 的批次树 / 事件组 / 属性代理。
---    每张卡一组具名 `Class(bullet/object, {...})`，行为用 `task` 协程或 `frame`
---    顺序写，和本仓库其它关卡（`th08.lua` 等）一个风格。
---    原版数据的用途是**取值**：各处常量后面都注了它是原版的哪条事件。
---    `tools/thmhj_tolua.py` 能把 `b<id>.xna` 导出成批次表，作为取值时的参照。
---==================================================================

local class = {}
_editor_class["TH21"] = class

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

--============================
--贴图登记（全局图集按**行号**取；本卡图集用 Types 段给的矩形）
--============================
LoadTexture("THMHJ_G", "mod\\GAME\\THMHJ\\barrages.png")
LoadImageSetCenter("Tg138", "THMHJ_G", 72, 128, 24, 24, 12, 13)
LoadImageSetCenter("Tg140", "THMHJ_G", 120, 128, 24, 24, 12, 13)
LoadImageSetCenter("Tg151", "THMHJ_G", 274, 360, 18, 18, 8, 7)
--★ 全局图集按**文件行序**取，不是按第一个字段的数字：
-- `CSManager.cs:231-249` 逐行 ReadLine() 顺序存进 List<BarrageType>，只读字段 [1]~[8]，
-- 第一个字段（标签号）引擎根本不看；`Barrage.cs` 又是 `csm.bgset[type]` 直接下标。
-- `global_types.txt` 里标签是 0..230（有 8 处行号≠标签），按标签查会错。
-- 这里 226→子弹225→bgset[225]→第 226 行 = 标签 228 的矩形，正确。
LoadImageSetCenter("Tg225", "THMHJ_G", 447, 592, 64, 64, 32, 32)

LoadTexture("THMHJ_660", "mod\\GAME\\THMHJ\\b660.png")
LoadImageSetCenter("T660_11", "THMHJ_660", 0, 102, 388, 388, 194, 194)   --阵
LoadImageSetCenter("T660_28", "THMHJ_660", 388, 180, 248, 141, 124, 110) --大扇粉
LoadImageSetCenter("T660_32", "THMHJ_660", 307, 0, 60, 60, 30, 30)       --樱花

local function styleOf(img, size)
    local u = Class(bulletStyle)
    u.size = size
    u._imgname = img          -- 贴图名（自检工具把弹幕渲成图时要用）
    u.init = function(self) self.img = img end
    u.RenderFunc = Render
    u.SetColorFunc = SetImageState
    return u
end
local S_beam = styleOf("Tg225", 0.9)
local S_dot = styleOf("Tg151", 18 / 40)
local S_b138 = styleOf("Tg138", 0.55)
local S_b140 = styleOf("Tg140", 0.55)
local S_sakura = styleOf("T660_32", 0.85)
local S_bigfan = styleOf("T660_28", 0.8)
local S_jin = styleOf("T660_11", 0.9)

---道中飘落的花瓣（装饰，无判定，自己回收）
class["th21_petaldeco"] = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.spd = ran:Float(0.6, 2.0)
        self.s = ran:Float(0.18, 0.42)
        self.a = ran:Int(90, 190)
        self.spin = ran:Float(-4, 4)
        self.rot = ran:Float(0, 360)
        self.sway = ran:Float(0, 360)
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 40
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.y = self.y - self.spd
        self.sway = self.sway + 3
        self.rot = self.rot + self.spin
        self.x = self.x + sin(self.sway) * 0.6
        if self.y < lstg.world.b - 30 then object.RawDel(self) end
    end,
    render = function(self)
        SetImageState("ellipse6", "mul+add", self.a, 255, 190, 226)
        Render("ellipse6", self.x, self.y, self.rot, self.s * 1.6, self.s)
    end,
}, true)

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th04_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        l.r, l.g, l.b = 236, 138, 150
    end)
end

boss.Define("1a", "西行寺幽幽子", "TH21_0", TH21_bg, { 0, 300 }, class["SCBG1"], "Yuyuko", 27)

---XNA(Crazy Storm) → LuaSTG
---CS 的逻辑窗口是 640×480，场地就是正中那块 384×448；LuaSTG 的 world 也是 384×448
---（`THlib/lib/Lscreen.lua:51`）。所以 **1:1、中心 (315,240)**（`Center.cs:76-77`
---的默认值），只做平移加一次 y 翻转。CS 的 `+y` 向下，所以角度要取负。
local function CX(x) return x - 315 end
local function CY(y) return 240 - y end

--============================
--[符卡1] 「西行庭千本桜図」    (原版 b660, Lunatic)
--==================================================================
--  原版是 TIME 耐久卡。整套图案每 600 帧重来一遍（`LOOP`），而**子弹跨圈存活** ——
--  「千本桜図」那一屏花就是这么攒出来的。四块内容：
--
--  ① 三根光柱（71~190 帧）：从屏幕底边升起，落点横坐标取**开卡那一刻的自机 X**，
--     速度 1→2 一路加；每 2 帧落一颗几乎不动的光斑，连起来就是一根柱子。
--     三根共用一个光斑贴图，「竖」靠的是竖向拉长而不是贴图本身，
--     再各自偏 0°/20°/−40° 张成扇形；宽高比同时按正弦缓慢呼吸。
--  ② 一棵树（181 帧起）：三条枝条沿弧线扫出去，每条落 4 个节点，节点上开花。
--     花瓣出生只有芝麻大（0.1），24 帧绽开到 0.8，之后**永远慢慢自转**
--     （每 140 帧转 120°），第 261 帧起再缓缓外飘。
--  ③ 第二、三层花出生时 `alpha = 0`。原版只在 `alpha > 95` 时才做自机判定
--     （`Barrage.cs:1487`），所以它们**出生时无害**，到第 601 / 1201 帧才变得致命。
--  ④ 两条拐弯尾迹：一颗看不见的载体在屏幕外绕扁椭圆飞，两个发射口只在
--     每圈的 181~300 帧开火；载体跨圈存活，所以尾迹**从第二圈才出现**。
--
--  数值全部来自原版数据，出处见 `mod/GAME/THMHJ/NOTES.md` 第十二~十五节。
--  这里没有照搬 Crazy Storm 的批次树 / 事件组 / 属性代理那一套，直接按行为写。
--==================================================================
do
    local LOOP = 600            --原版的图案周期：整套每 600 帧重来一遍
    local WHITE = { 255, 255, 255 }
    local PINK = { 255, 125, 125 }      --光柱
    local VIOLET = { 255, 125, 155 }    --枝条三的二级光带
    local MAGENTA = { 255, 1, 155 }     --转轮与巨闪

    ------------------------------------------------------------------
    --小工具
    ------------------------------------------------------------------
    ---原版的离屏回收框**比屏幕大得多**（`Barrage.cs:1586-1599`，已换算到 Lua 坐标）：
    ---默认 `x∈[−631,452] y∈[−575,573]`，`Outdispel` 时用紧框
    ---`x∈[−331,230] y∈[−275,273]`。所以子弹出屏之后还会活着飞一段，靠寿命到期才消失。
    local function offscreen(o, tight)
        if tight then
            return o.x < -331 or o.x > 230 or o.y < -275 or o.y > 273
        end
        return o.x < -631 or o.x > 452 or o.y < -575 or o.y > 573
    end

    ---统一收尾（`Barrage.cs:1530-1599`）：寿命到 → `dispel` 的话先淡出 20 帧再删，
    ---否则直接删；最后按原版的框离屏回收。`extra(o, t)` 是各自的每帧逻辑。
    local function keeper(life, dispel, tight, extra)
        return function(o)
            if extra then extra(o) end
            local t = o.timer
            if dispel and t > life then
                if not o._fade then
                    o._fade, o._hs0, o._vs0 = 0, o.hscale, o.vscale
                end
                o._fade = o._fade + 1
                local k = max(100 - o._fade * 5, 0)
                o._a = k * 2.55
                o.hscale, o.vscale = max(o._hs0 * k / 100, 0.01), max(o._vs0 * k / 100, 0.01)
                o.colli = false
                if o._fade >= 20 then object.RawDel(o) end
            elseif t > life then
                object.RawDel(o)
            end
            if offscreen(o, tight) then object.RawDel(o) end
        end
    end

    ---原版的 `Mist`：前 15 帧**画的不是子弹本身**，而是一团从 1.5 倍缩下来、渐显的雾
    ---（`Barrage.cs:1623-1632`）。本移植没有那张雾贴图，用同一张图放大 + 渐显近似。
    ---⚠ 判定不受影响：原版看的是 `alpha` 字段，雾只是画法。
    local function mist(o, t, sw, sh, a)
        if t <= 15 then
            local k = t / 15
            o._a = a * 2.55 * k
            o.hscale, o.vscale = sw * (1 + 1.5 * (1 - k)), sh * (1 + 1.5 * (1 - k))
        elseif t == 16 then
            o._a = a * 2.55
            o.hscale, o.vscale = sw, sh
        end
    end

    ---落一颗子弹。原版全卡的子弹出膛速度都≈0，轨迹是**发射点自己移动**画出来的
    ---（光柱、枝条、花瓣都是这么来的），所以这里也不去模拟速度积分。
    local function spawn(style, x, y, dir, v, sw, sh, rot, col, a)
        local o = NewSimpleBullet(style, 1, x, y, v or 0, dir or 0, false, 0, false)
        o.x, o.y = x, y
        o.rot = rot or 0
        o.hscale, o.vscale = sw, sh
        o._r, o._g, o._b = col[1], col[2], col[3]
        o._a = (a or 100) * 2.55
        o.colli = (a or 100) > 95
        o.bound = false                 --离屏不删，交给 `offscreen`（原版的框比屏幕大得多）
        return o
    end

    ---只当发射点用、自己不画东西的物体。`hide` 是引擎字段，自检里模拟不到，
    ---所以干脆把 `render` 写成空的 —— 两条路都稳。
    ---只当发射点用、自己不画东西的物体。
    ---⚠ **必须 `bound = false`**：引擎的 `bound` 默认 true = 飞出边界自动回收，
    ---  而这几样（尤其绕到屏幕外的载体）本来就该活在屏幕外。原版能跨圈存活，
    ---  正是因为 CS 的回收框比屏幕大得多（见 `offscreen`）。
    ---`hide` 是引擎字段、自检里模拟不到，所以干脆把 `render` 写成空的 —— 两条路都稳。
    local emitter = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound = false
        end,
        render = function() end,
    })

    ------------------------------------------------------------------
    --① 三根光柱
    ------------------------------------------------------------------
    --原版 `speedd` 266/270/260（≈正上方）、`head` 270/290/230（长轴偏 0°/20°/−40°，
    --换算到 Lua 就是下面这三个 `rot`）、`speed` 2/1/1，再按「速度增加3，正比，60帧」越推越快。
    --宽高比的呼吸周期 280/240/300 帧，摆幅 0.5/0.4、0.2/0.3、0.3/0.3。
    local BEAM = {
        --   方向  初速  半径   宽比  高比  倾角  宽摆幅 高摆幅 周期
        { dir = 94,  sp = 2, r = -20, sw = 1.2, sh = 2.0, rot =   0, wa = 0.5, ha = 0.4, wf = 280, ra = 55 },
        { dir = 90,  sp = 1, r =  30, sw = 0.7, sh = 1.5, rot = -20, wa = 0.2, ha = 0.3, wf = 240, ra = 60 },
        { dir = 100, sp = 1, r = -30, sw = 0.6, sh = 1.5, rot =  40, wa = 0.3, ha = 0.3, wf = 300, ra = 55 },
    }
    class["th21b_beam"] = Class(emitter, {
        init = function(self, cfg)
            emitter.init(self)
            self.cfg, self.t, self.sp = cfg, 0, cfg.sp
            self.x, self.y = player.x, CY(480)
        end,
        frame = function(self)
            self.t = self.t + 1
            --★ 时间轴必须按 `LOOP` 回卷，而且**每轮开头重新锚在自机 X** 上。
            --  原版两处会重算这个哨兵：`Time.Init`（开卡）和**回卷时**
            --  （`Time.cs:1932-1939` 的 `item2.copys.fx = Player.X`）。
            --  少了回卷 → 光柱只在开卡时扫一次，之后整张卡 28 秒里再没有光柱。
            --  少了重新锚定 → 光柱永远停在开卡那一刻的自机 x，不跟着人走。
            local n = ((self.t - 1) % LOOP) + 1
            if n == 1 then
                self.sp = self.cfg.sp
                self.x, self.y = player.x, CY(480)
            end
            n = n - 70                            --原版 `begin=71 life=120`
            if n < 1 or n > 120 then return end
            local c = self.cfg
            self.sp = self.sp + 3 / 60            --「速度增加3，正比，60帧」
            if n % 2 == 0 then                    --原版 `t=2`：每 2 帧落一颗光斑
                --半径按正弦来回摆（原版「半径增加55+10，正弦，180帧」）
                local rr = c.r + (c.ra + ran:Float(-10, 10)) * sin(n * 360 / 180)
                local g = spawn(S_beam, self.x + rr, self.y, c.dir, 0.01,
                        c.sw, c.sh, c.rot, PINK, 100)
                g.frame_other = keeper(600, false, false, function(o)
                    mist(o, o.timer, c.sw, c.sh, 100)
                end)
            end
            self.x = self.x + self.sp * cos(c.dir)
            self.y = self.y + self.sp * sin(c.dir)
        end,
    })

    ------------------------------------------------------------------
    --② 三向转轮 + 巨闪 + 爆闪
    ------------------------------------------------------------------
    ---三向转轮：半径 360 的圆上摆三个点，方向也是三向，每 20 帧转一整圈
    ---（原版事件组 `t=20 add=20` +「半径方向/角度增加360，正比，20帧」）。
    ---三个点在圆周上均匀分布（`tiao=3 spread=360`），贴图朝速度方向（`Withspeedd`）。
    class["th21b_wheel"] = Class(emitter, {
        init = function(self)
            emitter.init(self)
            self.t, self.a = 0, 0
            self.x, self.y = player.x, CY(490)
        end,
        frame = function(self)
            self.t = self.t + 1
            --★ 同样要按 `LOOP` 回卷：原版**每个批次**在回卷时都会重新激活
            --  （`Time.cs` 里 `time = now - begin + 1`，回卷后 `now` 从 1 重来）。
            --  `self.t > 120` 直接 return 的话，转轮也只转开头那一轮。
            local n = ((self.t - 1) % LOOP) + 1
            if n == 1 then self.a = 0 end
            if n > 120 then return end
            self.a = self.a - 18                  --每 20 帧转一整圈 = 18°/帧
            local amp = 30 + ran:Float(-10, 10)   --「不透明度变化到30+10，正弦，120帧」
            for i = 0, 2 do
                local pa = self.a + i * 120        --位置和方向共用这条扇形
                local o = spawn(S_beam, self.x + 360 * cos(pa), self.y + 360 * sin(pa),
                        pa, 5, 0.3, 1, pa, MAGENTA, 1)
                o.frame_other = keeper(65, false, false, function(bb)
                    local t = bb.timer
                    if t <= 120 then
                        bb._a = (1 + (amp - 1) * sin(t * 360 / 120)) * 2.55
                    end
                end)
            end
        end,
    })

    ---巨闪 / 爆闪：都是只活一帧、把一颗子弹放大再收掉。
    ---巨闪出生宽高比 55、收到 1，同时不透明度 1 → 80（180 帧）；
    ---爆闪反过来，1 → 15、80 → 1（60 帧）。
    local function flash(self, at, y, s0, s1, a0, a1, time, life)
        task.New(self, function()
            task.Wait(at)
            local o = spawn(S_beam, player.x, y, 0, 0, s0, s0, 0, MAGENTA, a0)
            o.frame_other = keeper(life, false, false, function(bb)
                local t = bb.timer
                if t <= time then
                    local k = t / time
                    local s = s0 + (s1 - s0) * k
                    bb.hscale, bb.vscale = s, s
                    bb._a = (a0 + (a1 - a0) * k) * 2.55
                end
            end)
        end)
    end

    ------------------------------------------------------------------
    --③ 一棵树：枝条 + 花
    ------------------------------------------------------------------
    --原版的枝条是 `bindid=-1` 的根批次：`r` 16 帧里从 0 推到全长，方向带正弦摆动，
    --每 4 帧在弧线上吐一颗「阵」当路标（`alpha=30` ≤ 95，所以**没有判定**）。
    --每条只落 4 个点，直接算出这 4 个点就行，不必逐帧模拟。
    --采样帧 1/4/8/12 来自原版 `t=4` 加上「当前帧=1：额外发射」。
    local NODE_T = { 1, 4, 8, 12 }
    ---`wob` 是半径方向的正弦摆动：原版是「正比」摆一个整周，所以第 t 帧的值
    ---= 初值 + 幅度·sin((t − 首帧)·360/周期)。`rnd` 对应原版数值里的「+N」（基准±随机）。
    local function nodes(c)
        local out = {}
        for _, t in ipairs(NODE_T) do
            local rd = c.rd
            for _, w in ipairs(c.wob) do
                if t >= w.from then
                    local a = w.a + (w.rnd and ran:Float(-w.rnd, w.rnd) or 0)
                    rd = rd + a * sin((t - w.from) * 360 / w.per)
                end
            end
            out[#out + 1] = { t = t, r = c.len / 16 * t, rd = rd }
        end
        return out
    end

    ---一片花瓣 / 一朵花的一瓣。原版的行为都写在「子事件组」里，这里直接按时间表写：
    ---  · 出生 `宽比/高比 = 0.1`，从 `grow_at` 起 `grow` 帧里**绽开**到 `gw/gh`
    ---  · `spin`：「朝向增加120，正比，140帧」且每 140 帧重来 → **永远慢慢自转**
    ---  · `wob` ：「朝向增加5，正弦，139帧」每 140 帧一次 → 小幅摆动（大扇用这个）
    ---  · `drift_at` 起「子弹速度增加…，正比，360帧」→ 缓缓外飘
    ---  · `lethal_at`：在那之前 `alpha = 0`，也就是**没有判定**（第二、三层花）
    ---⚠ 自转改的是**贴图朝向**，不改速度方向（原版里这是两个量），
    ---  所以速度用 `vx/vy` 单独写，不能靠 `SetV(..., true)` 让 rot 跟着速度走。
    local function petal(x, y, dir, f)
        local a0 = f.lethal_at and 0 or (f.a or 100)
        local o = spawn(f.style, x, y, dir, 0.01, f.sw, f.sh, 0, f.tint or WHITE, a0)
        o.frame_other = keeper(f.life, f.dispel, true, function(bb)
            local t = bb.timer
            --绽开（原版是「变化到」，逐帧渐近）
            if f.grow then
                if t > f.grow_at - 1 and t <= f.grow_at - 1 + f.grow then
                    local k = (t - f.grow_at + 1) / f.grow
                    bb.hscale = f.sw + (f.gw - f.sw) * k
                    bb.vscale = f.sh + (f.gh - f.sh) * k
                elseif t > f.grow_at - 1 + f.grow then
                    bb.hscale, bb.vscale = f.gw, f.gh
                end
            end
            --大扇在第 300 帧收回去（原版「宽比变化到0.1，正比，15帧」）
            if f.shrink_at and t > f.shrink_at then
                local k = min((t - f.shrink_at) / f.shrink, 1)
                bb.hscale = f.gw + (f.shrink_to - f.gw) * k
            end
            --永远慢慢自转 / 小幅摆动
            if f.spin then
                bb.rot = (f.spin * 120 / 140) * (t - 1)
            elseif f.wob then
                local j = (t - 1) % 140
                if j <= 139 then
                    bb.rot = f.wob * sin(j * 360 / 139)
                end
            end
            --缓缓外飘
            if f.drift_at and t > f.drift_at then
                local k = min((t - f.drift_at) / 360, 1)
                local v = 0.01 + f.drift * k
                bb.vx, bb.vy = v * cos(dir), v * sin(dir)
            end
            --第二、三层花：到点才现身，也就是到点才**变得致命**
            if f.lethal_at then
                if t >= f.lethal_at then
                    bb._a = 100 * 2.55
                    bb.colli = true
                else
                    bb._a = 0
                    bb.colli = false
                end
            end
        end)
        return o
    end

    --每朵花：`n` 发、离节点 `r`、挂在 `rd` 方向、朝 `fa` 方向射出、张角 `sp`。
    --位置和方向**共用同一条扇形**（原版 `Batch.cs:1740-1742`），所以花瓣是从节点
    --向外射出去的。角度已是 Lua 坐标（原版 +y 向下，这里 y 向上，所以取了负）。
    local FLOWER = {
        { --枝条一
            { n = 1, r = 0,  rd =  0, fa =  0, sp = 360, style = S_bigfan, life = 315,
              sw = 0.1, sh = 0.7, grow_at = 1, grow = 12, gw = 0.7, gh = 0.7,
              wob = 5, shrink_at = 300, shrink = 15, shrink_to = 0.1 },
            { n = 6, r = 50, rd = -90, fa = -90, sp = 220, style = S_sakura, life = 3413,
              sw = 0.1, sh = 0.1, grow_at = 1, grow = 24, gw = 0.8, gh = 0.8,
              spin = 120, drift_at = 261, drift = 0.45, dispel = true },
            { n = 7, r = 30, rd = -90, fa = -90, sp = 260, style = S_sakura, life = 1413,
              sw = 0.1, sh = 0.1, grow_at = 1, grow = 18, gw = 0.8, gh = 0.8,
              spin = 120, drift_at = 261, drift = 0.80, dispel = true },
            { n = 9, r = 60, rd = -90, fa = -90, sp = 290, style = S_sakura, life = 3413,
              sw = 0.1, sh = 0.1, grow_at = 601, grow = 18, gw = 0.8, gh = 0.8,
              spin = 120, drift_at = 861, drift = 0.40, lethal_at = 601, dispel = true },
            { n = 9, r = 70, rd = -90, fa = -90, sp = 290, style = S_sakura, life = 3413,
              sw = 0.1, sh = 0.1, grow_at = 1201, grow = 18, gw = 0.8, gh = 0.8,
              spin = 120, drift_at = 1461, drift = 1.00, lethal_at = 1201, dispel = true },
        },
        { --枝条二：它的花也朝下，只有第三层朝上（原版 `rd=270`）
            { n = 1, r = 0,  rd =   0, fa =   0, sp = 360, style = S_bigfan, life = 315,
              sw = 0.1, sh = 0.7, grow_at = 1, grow = 12, gw = 0.7, gh = 0.7,
              wob = -5, shrink_at = 300, shrink = 15, shrink_to = 0.1 },
            { n = 7, r = 40, rd = -90, fa = -90, sp = 220, style = S_sakura, life = 1413,
              sw = 0.1, sh = 0.1, grow_at = 1, grow = 24, gw = 0.8, gh = 0.8,
              spin = 120, drift_at = 281, drift = 1.00, dispel = true },
            { n = 8, r = 75, rd =  90, fa =  90, sp = 220, style = S_sakura, life = 1413,
              sw = 0.1, sh = 0.1, grow_at = 1, grow = 36, gw = 0.8, gh = 0.8,
              spin = 120, drift_at = 281, drift = 1.00, dispel = true },
        },
        { --枝条三：这一条**没有花**，节点上挂的是二级载体（见 `twig`）
            { n = 2, r = 40, rd = -90, fa = 0, sp = 220, twig = true },
        },
    }

    local BRANCH = {
        --    出弹锚点（CS 坐标）   方向     长度   摆动
        { ax = 132, ay = 140, rd = -11, len = 440,   --原版 id=1，分两段摆 ±17±5 与 ±10
          wob = { { from = 1, a = 17, rnd = 5, per = 8 }, { from = 9, a = 10, per = 8 } } },
        { ax = 485, ay =  84, rd = -185, len = 420,  --原版 id=8，±12 摆 12 帧
          wob = { { from = 1, a = 12, per = 12 } } },
        { ax = 100, ay = 121, rd = -5, len = 500,    --原版 id=14，注意 `fx` 是字面量 100
          wob = { { from = 1, a = 5, rnd = 5, per = 8 } } },
    }

    ---枝条三专用的二级载体：沿节点下方飞出去的一对「光带」，各自带着发射口。
    ---原版是「炮塔骑在载体上」，这里让载体自己按时间表吐弹 —— 出来的子弹一模一样，
    ---只是生成顺序不同（省掉整套挂载关系）。
    local function twig(x, y, dir)
        local o = spawn(S_beam, x, y, dir, 1.9, 0.7, 0.7, dir, VIOLET, 90)
        o.frame_other = keeper(136, false, true, nil)     --原版 `sonlife=136`
        local d = -90                        --「子弹速度方向变化到90，正比，1帧」→ 立刻朝下
        local drift = ran:Float(-15, 15)     --「子弹速度方向增加0+15，正比，220帧」
        task.New(o, function()
            for t = 2, 220 do
                d = d - drift / 220
                SetV(o, 1.9, d, false)
                o.rot = d
                task.Wait()
            end
        end)
        task.New(o, function()               --细光带：每 5 帧一发
            task.New(o, function()
                for _ = 1, 20 do
                    task.Wait(5)
                    if not IsValid(o) then break end
                    local g = spawn(S_beam, o.x, o.y, d, 0.01, 0.06, 0.5, d, { 255, 95, 155 }, 100)
                    g.frame_other = keeper(350, true, true, nil)
                end
            end)
            --小点：每 8 帧一对，各偏 ±60°；出膛 0.5，30 帧里刹到 0.01
            task.New(o, function()
                for _ = 1, 16 do
                    task.Wait(8)
                    if not IsValid(o) then break end
                    for _, side in ipairs({ -60, 60 }) do
                        local a = d + side
                        local g = spawn(S_dot, o.x, o.y, a, 0.5, 1.2, 1.2, a, WHITE, 100)
                        local v = 0.5
                        g.frame_other = keeper(1200, true, true, function(bb)
                            mist(bb, bb.timer, 1.2, 1.2, 100)
                            if bb.timer <= 30 then
                                v = v + (0.01 - 0.5) / 30
                                bb.vx, bb.vy = v * cos(a), v * sin(a)
                            end
                            --原版「角度减少/增加60，正比，136帧」→ fdirection 从 ±60 扫回 0
                            bb.rot = a - side * (1 - min(bb.timer / 136, 1))
                        end)
                    end
                end
            end)
            --「不透明度变化到1，正比，20帧」：后半程淡出，然后寿命到
            task.Wait(110)
            for _ = 1, 20 do
                o._a = o._a - 90 * 2.55 / 20
                task.Wait()
            end
        end)
        return o
    end

    ---一棵树：把三条枝条摆出来，每个节点开花；整套每 600 帧重来一遍。
    ---⚠ 重来的时候**在飞的子弹不回收**（原版 `Time.cs` 只重抄批次）——
    ---  「千本桜図」那一屏花就是靠跨圈累积攒出来的。
    class["th21b_tree"] = Class(emitter, {
        init = function(self)
            emitter.init(self)
            task.New(self, function()
                while true do
                    self:grow()
                    task.Wait(LOOP)
                end
            end)
        end,
        grow = function(self)
            for bi, c in ipairs(BRANCH) do
                local ax, ay = CX(c.ax), CY(c.ay)
                for _, nd in ipairs(nodes(c)) do
                    task.New(self, function()
                        task.Wait(180 + nd.t)        --原版 `begin=181`
                        local nx = ax + nd.r * cos(nd.rd)
                        local ny = ay + nd.r * sin(nd.rd)
                        --节点上的「阵」路标：只闪一下，`alpha=30` 所以没有判定
                        local m = spawn(S_jin, nx, ny, nd.rd, 0, 0.1, 0.1, 0, { 255, 1, 121 }, 30)
                        m.frame_other = function(o)
                            if o.timer > 1 then object.RawDel(o) end
                        end
                        for _, f in ipairs(FLOWER[bi]) do
                            for i = 1, f.n do
                                local k = (i - 1) - (f.n - 1) / 2
                                local pa, da = f.rd + k * f.sp / f.n, f.fa + k * f.sp / f.n
                                local px = nx + f.r * cos(pa)
                                local py = ny + f.r * sin(pa)
                                if f.twig then twig(px, py, da) else petal(px, py, da, f) end
                            end
                        end
                    end)
                end
            end
        end,
    })

    ------------------------------------------------------------------
    --④ 两条拐弯尾迹
    ------------------------------------------------------------------
    ---发射口：每帧吐一颗小弹，只在「全局帧 ≡ 181…300 (mod 600)」的窗口里开火。
    ---「出膛速度从 2 线性压到 0.9」让**越晚发的越慢**，尾迹因此被拉长；
    ---每颗子弹**自己**随机一个方向、再各自拐 120 帧 —— 原版写的是
    ---`子弹速度方向变化到0+360` 和 `增加0+120`，那个 `0+N` 就是「基准 0、随机 ±N」，
    ---所以这是每颗一份的随机，不是整批共用。
    ---⚠ 载体出生在第 510 帧，而窗口是 181~300 —— **第一圈那个窗口已经过去了**，
    ---  所以尾迹从第二圈才出现。这不是 bug，是原版就有的跨圈节奏。
    local function nozzle(cruiser, style, delay)
        task.New(cruiser, function()
            task.Wait(271 + delay)           --(600−510) + 181：等到下一个窗口
            --⚠ 载体到寿（或离开回收框）之后必须收工：引擎里 `task.New(self, …)` 的
            --  协程挂在对象身上，对象没了协程就成孤儿，会**继续无限吐弹**。
            --  这一条漏了会让弹数线性增长（每圈多 120 发 × 累积的孤儿数）。
            while IsValid(cruiser) do
                for t = 1, 120 do
                    if not IsValid(cruiser) then break end
                    local v = 2 - 1.1 / 120 * t
                    local a = ran:Float(0, 360)
                    local g = spawn(style, cruiser.x, cruiser.y, a, v, 0.9, 0.8, a, WHITE, 100)
                    local turn = ran:Float(-120, 120)
                    g.frame_other = keeper(2200, true, true, function(bb)
                        mist(bb, bb.timer, 0.9, 0.8, 100)
                        local n = bb.timer - 1
                        if n >= 1 and n <= 120 then
                            local na = a + turn * n / 120
                            bb.vx, bb.vy = v * cos(na), v * sin(na)
                            bb.rot = na
                        end
                        --「宽比增加0.3，正弦，14帧」每 15 帧一次 → 呼吸
                        local j = (bb.timer - 1) % 15
                        if j < 14 then
                            local w = 0.3 * sin(j * 360 / 14)
                            bb.hscale, bb.vscale = 0.9 + w, 0.8 + w
                        end
                    end)
                    task.Wait()
                end
                task.Wait(LOOP - 120)
            end
        end)
    end

    ---看不见的载体：在屏幕外绕一条**扁椭圆**飞（原版 `横比=9`，所以 x 方向的速度
    ---是 y 方向的 9 倍），每 23 帧转一整圈。
    ---原版载体在第 510 帧出生一次、`sonlife=1200`，而图案周期只有 600 ——
    ---所以**它跨圈存活，同时在飞的有 1~2 颗**，每颗都带着自己的发射口。
    class["th21b_cruiser"] = Class(emitter, {
        init = function(self)
            emitter.init(self)
            self.x, self.y = CX(284), CY(48)
            self.dir = 0
            nozzle(self, S_b138, 0)          --原版 `begin=181`
            nozzle(self, S_b140, 2)          --原版 `begin=183`
        end,
        frame = function(self)
            self.dir = self.dir - 360 / 23
            self.x = self.x + 9 * 8 * cos(self.dir)
            self.y = self.y + 8 * sin(self.dir)
            if self.timer > 1200 then object.RawDel(self) end
        end,
    })

    ------------------------------------------------------------------
    local name = "「西行庭千本桜図」"
    local card = boss.card.New(name, 38, 38, 38, 1000000)   --原版是 TIME 耐久卡
    boss.card.add({ { card, "1a" } }, 27, name, 331)

    function card:before()
        task.New(self, function()
            task.MoveTo(0, 120, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -70, 70, 96, 140, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(50)
            Newcharge_in(self.x, self.y, 255, 190, 236)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 190, 236)
        end)

        local parts = {}
        local function keep(o)
            parts[#parts + 1] = o
            return o
        end
        for i = 1, #BEAM do keep(New(class["th21b_beam"], BEAM[i])) end
        keep(New(class["th21b_wheel"]))
        keep(New(class["th21b_tree"]))
        task.New(self, function()
            task.Wait(510)                   --原版载体在第 510 帧出生
            while true do
                keep(New(class["th21b_cruiser"]))
                task.Wait(LOOP)
            end
        end)
        flash(self, 1, CY(490), 55, 1, 1, 80, 180, 180)   --巨闪
        flash(self, 66, CY(470), 1, 15, 80, 1, 60, 60)    --爆闪
        self.__parts = parts
    end

    function card:del()
        for _, o in ipairs(self.__parts or {}) do
            if IsValid(o) then object.RawDel(o) end
        end
        self.__parts = nil
    end
end
