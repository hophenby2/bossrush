---=====================================
---TH21  西行庭：西行寺幽幽子（东方幕华祭 Part II 复刻，Lunatic）
---
---  来源：`/Users/happyelements/crack/THMHJ.PartII.Restored`
---    C#/XNA 的东方幕华祭 Part II 还原工程，引擎是 **Crazy Storm**。
---    定位、解码、语义出处全部记在 `mod/GAME/THMHJ/NOTES.md`，本文件只放关卡内容。
---
---==================================================================
---  Crazy Storm 的模型（全部从 C# 源码读出来的，见 NOTES 第十二节）
---==================================================================
---  ① **时间会循环**：`Times.now` 从 1 涨到 `Totalframe` 就绕回 1
---     （`Time.cs:1904-1907`）。整套图案**无限重复**，子弹跨循环累积 ——
---     「千本桜図」就是靠这个攒出一屏樱花的。
---  ② **一个批次 = 一个会动的物体**，不是「一份发射器配置」。
---     它在全局时间 [begin, begin+life-1] 内活着（`Batch.cs:390`），
---     自己的帧计数 `time = now - begin + 1`，每帧按 speed/speedd 移动。
---  ③ **批次是一棵挂载树**（`Batch.cs:1703`）：`bindid = -1` → 根，自己造载体；
---     `bindid = N` → **炮塔**，每 t 帧对**每一颗**活着的、由批次 N 造的载体，
---     在它周围半径 r 的扇形上吐 tiao 发（`Batch.cs:1740-1742`：位置和方向**共用**一条扇形）。
---  ④ **根批次的发射锚点是 (fx, fy)，不是 (x, y)**。子弹落在
---     `(fx,fy) + r·(cos,sin)(扇形角)`（`Batch.cs:1637-1638`）。
---     事件里的「半径增加 / 半径方向增加」改的是**批次自己的 r / rdirection**，
---     所以载体能沿一条弧线依次摆开 —— 这就是「开树、长枝条」的做法。
---     `fx=-99998 → x-4`、`fx=-99999 → 自机的 X`（`Time.cs:79-90`，每个循环重算一次）。
---  ⑤ 子弹贴图：批次 type T → 子弹 type = T−1 → `<228` 用全局表、`>=228` 用本卡表[−228]
---     （`Batch.cs:1638` + `Barrage.cs:1625`）。
---  ⑥ 坐标：Crazy Storm 是 XNA（+y 向下）。换算 `lua_x = cs_x−315`、`lua_y = 175−cs_y`、
---     `lua_angle = −cs_angle`。不做这一步整张卡会上下镜像、方向全错。
---  ⑦ 事件的三种「方式」（`Execution.cs:77 / 529 / 981`）：
---       正比 changetype0  `x += value/time` 每帧，共 time 帧
---       固定 changetype1  `x = value` 一次性
---       正弦 changetype2  `x = region + value·sin(360/time·(time−ctime))`，绕原值振荡一周
---     下标的属性表见 `NOTES.md` 第十二节。
---=====================================

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
---「不可见载体」用：CS 里 `type=0` → 子弹 type −1 = −1 → **根本不画**
---（`Barrage.cs:1620-1621` 直接 return），但它照样能当炮塔的挂载点。
---这里把一张现成贴图缩到 0.001 倍——屏幕上不到一个像素，等于没有。
local S_none = styleOf("Tg225", 0.001)

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

--============================
--小工具
--============================
local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then return end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

local function arc(cx, cy, r, a0, a1, segs, alpha, gr, gg, gb, w)
    if r <= 0 or alpha <= 0 then return end
    local step = (a1 - a0) / segs
    for i = 1, segs do
        local s1, s2 = a0 + step * (i - 1), a0 + step * i
        thin_line(cx + cos(s1) * r, cy + sin(s1) * r,
                cx + cos(s2) * r, cy + sin(s2) * r, alpha, gr, gg, gb, w)
    end
end

---XNA(Crazy Storm) → LuaSTG
---CS 的逻辑窗口是 640×480，场地就是正中那块 384×448（Touhou 场地的标准尺寸）；
---LuaSTG 的 world 也是 384×448（`THlib/lib/Lscreen.lua:51`）。
---所以 **1:1、中心 (315,240)**（`Center` 的默认值，`Center.cs:76-77`），
---只做平移加一次 y 翻转。
local function CX(x) return x - 315 end
local function CY(y) return 240 - y end
local function CA(a) return -a end

---CS 的离屏回收框（`Barrage.cs:1586-1599`，已换算到 Lua 坐标）。
---⚠ 它比屏幕**大得多**：默认框 lua x∈[−631, 452]、y∈[−575, 573]；
---`Outdispel=true` 时换成紧框 x∈[−331, 230]、y∈[−275, 273]（也还是比场地大）。
---所以 CS 里子弹出屏之后**还会活着飞一段**，靠 `sonlife` 到期才消失 —— 照做。
local function offscreen(bb, tight)
    if tight then
        return bb.x < -331 or bb.x > 230 or bb.y < -275 or bb.y > 273
    end
    return bb.x < -631 or bb.x > 452 or bb.y < -575 or bb.y > 573
end

---把子弹的「速度 + 方向」写进引擎真正读的 vx/vy。
---⚠ 不能只用 `object.SetV`：CS 的速度是 `speedx = 横比·speed·cos(方向)`、
---`speedy = 纵比·speed·sin(方向)`（`Barrage.cs:396-397`），**两个轴各有一个缩放**，
---所以 `横比≠1` 的子弹走的是椭圆（b660 那颗看不见的载体 `横比=9`，就是靠这个
---把圆周压成一条扁椭圆）。`SetV` 写不出椭圆，这里直接算 vx/vy。
local function setv(bb)
    bb.vx = bb._xs * bb._sp * cos(bb._dir)
    bb.vy = bb._ys * bb._sp * sin(bb._dir)
end

---发一发（出膛即走）
local function fly(style, x, y, v, a, r, g, b, omiga, sw, sh, alpha, head, wsd, xs, ys, asp, aspd)
    local o = NewSimpleBullet(style, 1, x, y, v, a, false, omiga or 0, false)
    o._v0 = v or 0                        --出膛速度（子事件可能改它）
    o._sp, o._dir = v or 0, a or 0        --子事件「子弹速度/方向」读写的就是这两个
    o._xs, o._ys = xs or 1, ys or 1       --横比/纵比（速度椭圆的半轴比例）
    o._r, o._g, o._b = r or 255, g or 255, b or 255
    --加速度：**只在出生这一帧**换算成 aspeedx/aspeedy（`Barrage.cs:396-397`），
    --之后每帧 `speedx += aspeedx`（`:423-424`）。子事件改它是无效的（原版如此）。
    o._asp0, o._aspd0 = asp or 0, aspd or 0
    o._asx = o._xs * (asp or 0) * cos(aspd or 0)
    o._asy = o._ys * (asp or 0) * sin(aspd or 0)
    o._blend = "mul+add"
    --★ 离屏回收**交给 CS 自己的框**，不要让引擎提前删：
    --  CS 的框比屏幕大得多（`Barrage.cs:1586-1599`，换算见 `cs_offscreen`），
    --  所以子弹飞出屏幕后**依然活着**，靠 `sonlife` 到期才消失。
    --  b660 的 Layer3 载体就是靠这个活到第二圈（`sonlife=1200` 而它一直在屏幕外绕圈），
    --  引擎默认的 bound 会把它在第一圈就删掉，那两条尾迹就永远不会出现。
    o.bound = false
    if sw then o.hscale, o.vscale = sw, (sh or sw) end
    o._a = (alpha or 100) * 2.55          --CS 的 alpha 是 0..100
    setv(o)
    --★ 判定：CS 只在 `alpha > 95` 时才做自机判定（`Barrage.cs:1487`）。
    --  所以「不透明度」在数据里不只是外观 —— b660 的花瓣出生 `alpha=0`，
    --  到第 601 帧「不透明度变化到100」才**变得致命**，那条事件就是干这个的。
    o.colli = o._a > 242.25               --95 × 2.55
    --★ 贴图旋转 = `-(head + 90)`：
    --  引擎画的时候是 `ToRadians(head) + π/2`（`Barrage.cs:1637`），**固定多加了 90°**；
    --  再按 y 翻转取负。所以数据里满地的 `head=270` 意思是 270+90=360 —— **完全不转**，
    --  保持贴图原本的方向。
    --  ⚠ 光柱的「竖」**不是贴图自带的**：`Tg225` 实测是 64×64 的各向同性光斑
    --    （长宽比 1.0），竖起来靠的是 `hscale 2.0 > wscale 1.2` 这种非等比缩放；
    --    而缩放是在**贴图本地坐标系**里做的，所以 `rot` 一转，被拉长的那根轴跟着转 ——
    --    id 0/3/4 的 `head 270/290/230` 正是让三根柱子的长轴偏 0°/20°/−40°，张成扇形。
    --  `Barrage.cs:399`：Withspeedd 时贴图朝向跟着速度方向，否则是批次自己的 head
    o._head = wsd and (a or 0) or (head or 0)
    o.rot = (wsd and (a or 0) or (head or 0)) - 90
    return o
end

---★ 子事件组用的代理：在事件里读写 `p.w / p.h / p.alpha / p.rot / p.speed / p.dir`
---就等于读写子弹自己的字段。速度/方向改完要重算 vx/vy 才真的拐弯。
---（子弹的属性表是 `Barrage.cs:481-501` 的 `results`，和批次的**不是同一张**）
local function bullet_proxy(bb)
    return setmetatable({}, {
        __index = function(_, k)
            if k == "speed" then return bb._sp end
            if k == "dir" then return bb._dir end
            if k == "alpha" then return bb._a / 2.55 end
            if k == "w" then return bb.hscale end
            if k == "h" then return bb.vscale end
            if k == "rot" then return bb._head end
            if k == "r" then return bb._r end
            if k == "g" then return bb._g end
            if k == "b" then return bb._b end
            --⚠ CS 里 `aspeed`/`aspeedd` **只在子弹出生的那一帧**算成 aspeedx/aspeedy
            --  （`Barrage.cs:396-397` 在 `time==1` 块里），之后子事件再改它是**无效**的。
            --  所以这里只读不生效，读了也返回出生值。
            if k == "aspeed" then return bb._asp0 end
            if k == "aspeedd" then return bb._aspd0 end
            return bb[k]
        end,
        __newindex = function(_, k, v)
            if k == "speed" then bb._sp = v
            elseif k == "dir" then bb._dir = v
            elseif k == "alpha" then bb._a = v * 2.55; bb.colli = bb._a > 242.25
            elseif k == "w" then bb.hscale = v
            elseif k == "h" then bb.vscale = v
            elseif k == "rot" then bb._head = v; bb.rot = v - 90
            elseif k == "r" then bb._r = v
            elseif k == "g" then bb._g = v
            elseif k == "b" then bb._b = v
            else bb[k] = v end
            if k == "speed" or k == "dir" then setv(bb) end
        end,
    })
end

---★ Crazy Storm 的事件组 → 每帧回调。
---  spec = { at=触发帧（默认1）, every=重复间隔（事件组的 t/addtime）, key="r",
---           how=0/1/2, mode=0/1/2, v=数值, rand=随机幅度, frames=帧数 }
---    how ：0=设为目标值  1=增加  2=减少
---    mode：0=正比  1=固定  2=正弦      （`Execution.cs:77 / 529 / 981`）
---  触发那一刻把该属性的当前值记成 `region`（正弦绕它振荡），并掷一次随机。
---  ⚠ **状态 `st` 是「每个持有者一份」，不是每组事件一份**：
---    父事件作用在批次上，一个批次一份；子事件作用在**每颗子弹**上，
---    而 CS 里 `Shoot` 给每颗子弹都 `barrage.Events.Add(Event.Get()...)`（`Batch.cs:1690-1695`），
---    也就是**每颗子弹各自克隆了一套事件组**。
---    共用一个 `st` 的后果很隐蔽：`ctime` 会被同批次的几百颗子弹每帧各扣一次，
---    于是「持续 140 帧」的事件在十几帧内就耗尽 —— 花瓣只会抖一下就不再自转。
---  ⚠ 属性名（中文）到字段的映射**分两张表**（`Batch.cs:408-452` / `Barrage.cs:481-501`）：
---    父事件用批次的 `results`（半径2 半径方向3 角度6 速度8 生命12 宽比14 高比15 不透明度19 子弹速度21），
---    子事件用子弹的 `results`（宽比2 高比3 不透明度7 朝向8 子弹速度9 子弹速度方向10）。
---    所以「子弹速度」在批次上是 `sonspeed`、在子弹上是 `speed`，是**两个**字段。
local function events(specs)
    return function(b, time, st)
        for i = 1, #specs do
            local s = specs[i]
            local e = st[i]
            local due = time >= (s.at or 1)
            if due and s.every then due = (time - (s.at or 1)) % s.every == 0 end
            if not e and due then
                --⚠ 生成的数据只写出**非零**的字段，所以事件引用的键可能压根没在表里
                --  （例如 `sonaspeedd` 数据是 0）。缺键当 0，并且落一个 0 上去，
                --  否则后面的 `region ± …` 会对 nil 做算术。
                local reg = b[s.key]
                if reg == nil then reg = 0; b[s.key] = 0 end
                e = { region = reg, ctime = s.frames,
                      v = s.v + (s.rand or 0) * ran:Float(-1, 1) }
                st[i] = e
            end
            if e then
                local ct, key, how = e.ctime, s.key, s.how
                if s.mode == 2 then                       -- 正弦：绕 region 一整周
                    local k = s.frames - ct
                    local base, amp, sgn = e.region, e.v, 1
                    if how == 0 then amp = e.v - e.region
                    elseif how == 2 then sgn = -1 end
                    b[key] = base + sgn * amp * sin(k * 360 / s.frames)
                    e.ctime = ct - 1
                    if e.ctime < 0 then st[i] = nil end
                elseif s.mode == 1 then                   -- 固定：一次性
                    if how == 0 then b[key] = e.v
                    elseif how == 1 then b[key] = b[key] + e.v
                    else b[key] = b[key] - e.v end
                    e.ctime = ct - 1
                    if e.ctime == 0 then st[i] = nil end
                else                                      -- 正比
                    if how == 0 then b[key] = (b[key] * (ct - 1) + e.v) / ct
                    elseif how == 1 then b[key] = b[key] + e.v / s.frames
                    else b[key] = b[key] - e.v / s.frames end
                    e.ctime = ct - 1
                    if e.ctime == 0 then st[i] = nil end
                end
            end
        end
    end
end

--============================
--★ Crazy Storm 图案播放器
--==================================================================
--  一个「批次」表长这样（坐标/角度**已经换算过**）。字段由
--  `tools/thmhj_tolua.py` 从原版数据机械生成，键名一一对应 `Batch` 的字段：
--    { id, bind, begin, life, t, tiao, spr,
--      ax, ay, fxp,       -- 根的发射锚点（CS 的 fx/fy）；fxp = 「fx 取自机的 X」
--      r, rd,             -- 扇形半径 / 扇形中心角（事件会改它 → 枝条）
--      fa, spread,        -- 射击方向中心角 / 张角
--      v,                 -- 子弹速度（CS 的 sonspeed）
--      sw, sh, head, wsd, -- 贴图宽比/高比/朝向 / Withspeedd（朝向跟速度）
--      xs, ys,            -- 横比/纵比：**速度**椭圆的半轴比例
--      sonaspeed, sonaspeedd, -- 子弹加速度 / 加速度方向
--      cr,cg,cb, alpha,   -- 颜色与不透明度（alpha ≤ 95 时**没有判定**）
--      speed, sd,         -- 批次自身每帧位移（CS 的 speed / speedd）
--      sonlife, dispel, mist, invisible,
--      extra,             -- 「当前帧=1：额外发射」→ 时间 1 也发一轮
--      evspec = {...},    -- 父事件组（p[51]）：改批次自己的属性
--      sevspec = {...},   -- 子事件组（p[52]）：改**每颗子弹**自己的属性
--      ev2(bb)            -- 需要写代码的子弹回调时用它 }
--  ⚠ `outdispel` / `invincible` 这两个旗标**不影响判定**：前者只影响离屏回收的边界，
--    后者是「子弹不会被自机打掉」（`Barrage.cs:1474`）。有判定与否只看 `alpha`。
--==================================================================
local function run_cs(self, total, layers)
    local st, idx = {}, {}
    --哪些批次被别的批次当父（`bind` 指向它）——只有这些需要记载体。
    --不筛的话，花瓣类炮塔（一张卡几千颗）也会攒一份没人查的载体表。
    local parentof = {}
    --循环回卷时要复位的字段（事件改过哪个就得存哪个，否则跨圈越滚越大）
    local SAVE = { "r", "rd", "fa", "spread", "tiao", "t", "life", "speed", "sd",
                   "ax", "ay", "x", "y", "sw", "sh", "alpha", "v", "omi",
                   "head", "sonaspeed", "sonaspeedd", "xs", "ys" }
    for L, list in ipairs(layers) do
        idx[L] = {}
        for _, b in ipairs(list) do
            --批次自身位置（x/y）和发射锚点（fx/fy）在 CS 里是两个变量，每帧一起走。
            --根批次只给了锚点，这里把 x/y 补上，免得 speed 积分时对 nil 做加法。
            b.x = b.x or b.ax or 0
            b.y = b.y or b.ay or 0
            b.ax = b.ax or b.x
            b.ay = b.ay or b.y
            local o = {}
            for _, k in ipairs(SAVE) do o[k] = b[k] end
            st[#st + 1] = { b = b, L = L, carriers = {}, orig = o }
            --⚠ `bindid` 只在**本图层**里找（`Batch.cs:1703` 搜的是
            --  `LayerArray[parentid].Barrages`，而 parentid 就是图层号）。
            --  三个图层里都有 id=1，按全局索引会让枝条一的炮塔挂到第三层的载体上。
            idx[L][b.id] = #st
        end
    end
    --第二遍：算出「哪些批次被当父」——`bindid` 可以前向引用（枝条三的 `id=3` 挂在
    --后面的 `id=14` 上），所以不能在同一个循环里就地判定。
    for i = 1, #st do
        local s = st[i]
        if s.b.bind and s.b.bind >= 0 then
            parentof[s.L] = parentof[s.L] or {}
            parentof[s.L][s.b.bind] = true
        end
    end
    ---回到「原始数据 + 哨兵重算」（`Time.cs:74` 每个循环 `copys = Copy()` 一次）。
    ---少了这一步，事件对 r / speed 的累加会跨循环越滚越大，几圈之后就不是这张卡了。
    local function rewind()
        for i = 1, #st do
            local s = st[i]
            for k, v in pairs(s.orig) do s.b[k] = v end
            --⚠ **不要清 `s.carriers`**。CS 回卷时只重抄批次，在飞的子弹一律留着
            --  （`Time.cs`），而炮塔扫描的是图层里所有活着的子弹（`Batch.cs:1703`）——
            --  所以**上一圈打出去的载体，这一圈照样能被炮塔挂上**。
            --  b660 的 Layer3 正是靠这个：根 `begin=510`、炮塔 `181~300`，第一圈永不相交，
            --  载体 `sonlife=1200` 跨过 600 帧的回卷点，从**第二圈**起才被炮塔找到。
            --  清了之后那两条尾迹就永远不会出现。
            if s.b.fxp then s.b.ax = player.x end      --fx=-99999 → 自机的 X（每个循环取一次）
            --父事件作用在批次上 → 一个批次一份状态；子事件是每颗子弹一份（见 `events`）
            s.b._st = {}
            if s.b.evspec then s.b.ev = events(s.b.evspec) end
            if s.b.sevspec then s.b.sev = events(s.b.sevspec) end
        end
    end
    rewind()

    task.New(self, function()
        local now = 0
        while true do
            --① 时间循环（Time.cs:1904）：跑到 total 就绕回 1
            now = now + 1
            if now > total then now = 1; rewind() end

            for i = 1, #st do
                local s, b = st[i], st[i].b
                --② 清理死掉的载体
                for k = #s.carriers, 1, -1 do
                    if not IsValid(s.carriers[k]) then table.remove(s.carriers, k) end
                end
                --③ 激活窗口 [begin, begin+life-1]（Batch.cs:390）
                if now >= b.begin and now <= b.begin + b.life - 1 then
                    local time = now - b.begin + 1
                    --④ 每帧按 speed/speedd 移动（Batch.cs:400-405）：
                    --  x/y 和 fx/fy **一起**走（源码里两条都加）
                    if b.speed and b.speed ~= 0 then
                        local dx, dy = b.speed * cos(b.sd or 0), b.speed * sin(b.sd or 0)
                        b.x, b.y = b.x + dx, b.y + dy
                        b.ax, b.ay = b.ax + dx, b.ay + dy
                    end
                    if b.ev then b.ev(b, time, b._st) end
                    --⑤ 每 t 帧发一次（Batch.cs:1547），外加「额外发射」
                    if (b.t > 0 and time % b.t == 0) or (b.extra and time == 1) then
                        local n, spread = b.tiao or 1, b.spread or 360
                        local spr = b.invisible and S_none or b.spr
                        local mist_a = (b.alpha or 100) * 2.55
                        local function volley(ox, oy)
                            for g = 0, n - 1 do
                                --位置与方向**共用**同一条扇形（Batch.cs:1740-1742）
                                local k = g - (n - 1) / 2
                                local pa = (b.rd or 0) + k * spread / n
                                local da = (b.fa or 0) + k * spread / n
                                local o = fly(spr, ox + (b.r or 0) * cos(pa),
                                        oy + (b.r or 0) * sin(pa), b.v or 0, da,
                                        b.cr or 255, b.cg or 255, b.cb or 255,
                                        b.omi or 0, b.sw, b.sh, b.alpha, b.head, b.wsd,
                                        b.xs, b.ys, b.sonaspeed, b.sonaspeedd)
                                --★ 每颗子弹都有寿命：`time > add + sonlife` 之后
                                --  淡出 20 帧再删（`Barrage.cs:1530-1545`，前提 Dispel）。
                                --  ⚠ 少了这一步，`sonlife=1` 的**运载弹会永远赖着不走**，
                                --    炮塔就一直挂在它身上发弹 —— 数量会指数级爆掉。
                                local lt = b.sonlife + (b.mist and 15 or 0)
                                local f2, sev = b.ev2, b.sev
                                local d0 = b.mist and 15 or 0   --Mist 的子弹事件晚 15 帧起算
                                local asx, asy = o and o._asx, o and o._asy
                                if o then
                                    o.frame_other = function(bb)
                                        if f2 then f2(bb) end
                                        local t = bb.timer
                                        --加速度：出生时算好，每帧加到速度上（`Barrage.cs:423-424`）
                                        if asx ~= 0 or asy ~= 0 then
                                            bb.vx, bb.vy = bb.vx + asx, bb.vy + asy
                                        end
                                        --★ Mist：前 15 帧**画的不是子弹本身**，而是一团逐渐收小、
                                        --  渐显的雾（`Barrage.cs:1623-1632`：透明度 `t/15·alpha`，
                                        --  缩放额外 `+1.5·(15−t)/15`）。原版用的是另一张叫 mist 的
                                        --  贴图；本移植没有那张图，用同一张图放大 + 渐显近似。
                                        --  ⚠ 判定**不受影响**：CS 的判定看的是 `alpha` 字段
                                        --  （`Barrage.cs:1487`），而雾只是画法。
                                        if d0 > 0 then
                                            if t <= d0 then
                                                local g2 = 1 + 1.5 * (1 - t / d0)
                                                bb._a = mist_a * (t / d0)
                                                bb.hscale = (b.sw or 1) * g2
                                                bb.vscale = (b.sh or b.sw or 1) * g2
                                            elseif t == d0 + 1 then
                                                bb._a = mist_a
                                                bb.hscale, bb.vscale = b.sw or 1, b.sh or b.sw or 1
                                            end
                                        end
                                        if sev then
                                            local p = bb._proxy
                                            if not p then
                                                p = bullet_proxy(bb); bb._proxy = p
                                                bb._st = {}   --★ 每颗子弹各自一份事件状态
                                            end
                                            sev(p, t - d0, bb._st)
                                        end
                                        bb.colli = bb._a > 242.25   --CS：alpha>95 才有判定
                                        if b.dispel and t > lt then
                                            local k = max(100 - (t - lt) * 5, 0)
                                            bb._a = k * 2.55
                                            bb.hscale = max((b.sw or 1) * (k / 100), 0.01)
                                            bb.vscale = max((b.sh or b.sw or 1) * (k / 100), 0.01)
                                            bb.colli = false
                                            if t > lt + 20 then object.RawDel(bb) end
                                        elseif t > lt then
                                            object.RawDel(bb)      --不淡出，直接到期
                                        end
                                        --离屏回收：CS 的框（比屏幕大得多，见 `offscreen`）
                                        if offscreen(bb, b.outdispel) then object.RawDel(bb) end
                                    end
                                end
                                --★ **每个**批次都把自己发的子弹挂进图层表，不只是根：
                                --  CS 两条分支都做 `barrage.parentid = id` 再 Add
                                --  （根 `Batch.cs:1695`、炮塔分支同样），炮塔扫描的也是
                                --  「`parentid == bindid` 的所有活子弹」。所以挂载树可以有三层
                                --  甚至更多层：根 → 二级载体 → 三级炮塔。
                                --  b660 的枝条三就是三层（枝条 `id=14` → 二级载体 `id=3` → `id=4/5/6`），
                                --  只在 `bind < 0` 时记录的话，第三层永远找不到载体。
                                if parentof[s.L] and parentof[s.L][b.id] then
                                    s.carriers[#s.carriers + 1] = o
                                end
                            end
                        end
                        --根：锚点是 (ax, ay)（= CS 的 fx/fy），子弹落在它周围半径 r 的扇形上
                        if b.bind < 0 then
                            volley(b.ax, b.ay)
                        else
                            --炮塔：对**每一颗**活着的载体各来一轮
                            local p = st[idx[s.L][b.bind]]
                            if p then
                                for ci = 1, #p.carriers do
                                    local c = p.carriers[ci]
                                    volley(c.x, c.y)
                                end
                            end
                        end
                    end
                end
            end
            task.Wait()
        end
    end)
end

--============================
--[符卡1] 「西行庭千本桜図」   (b660, Lunatic, Totalframe=600)
--==================================================================
--  原版是 **TIME 耐久卡**（不掉血，撑时间），本移植照做。
--  骨架 = 一棵树：**根批次**沿弧线扫出「枝条」，**炮塔**（骑在节点上）在每个节点开花。
--  批次表由 `tools/thmhj_tolua.py 660` 从原版数据生成，下面是读数据得出的设计：
--
--  Layer1（6 个批次）—— 底部升起三条光柱 + 三向转轮 + 两次爆闪
--   · id 0/3/4 三条光柱：`fx=-99999` → 锚点 X 取**每个循环开始时的自机 X**，
--     `fy=480` 贴屏幕底边；`speed 2/1/1` 沿 `speedd 266/270/260`（≈正上方）飞，
--     再被「速度增加3，正比，60帧」越推越快 → 三根柱子从底部窜上去。
--     三根用的是同一张 `Tg225`，靠 `head 270/290/230`（= 相对原朝向 0°/20°/−40°）
--     张开成扇形。注意 `head` 在 CS 里要 +90° 再取负才是引擎的画法（见 `fly`）。
--   · id 1 三向转轮 / id 2 巨闪：事件组 `t=20 add=20` 的
--     「半径方向/角度增加360，正比，20帧」= **每 20 帧转一整圈**（18°/帧）→ 持续自转。
--
--  Layer2（15 个批次）—— 三根枝条 + 12 个炮塔
--   · 枝条 id 1/8/14：`bindid=-1`，`t=4 tiao=1 sonlife=1 alpha=30` —— 每 4 帧在
--     弧线上吐一颗「阵」，`alpha=30 ≤ 95` 所以**没有判定**，只是路标；一串点连起来
--     就是一根枝条。`r` 在 16 帧里从 0 推到 440/420/500，方向 `rd=11/185/5`。
--     ⚠ 数据里 id 1/14 还挂着「当前帧=17/18/22」的事件，但 `life` 只有 13 帧 ——
--       **永远不会触发**（编辑器留下的死事件），别去实现它们。
--   · 炮塔：id 0/2/7/12/13 骑枝条一、id 9/10/11 骑枝条二、id 3 骑枝条三。
--     位置和方向**共用同一条扇形**，`r` 是花心到节点的距离、`rd=90` 把花挂在节点
--     **下方**、`fa=90` 让花瓣往**下**射。`head=270 + Withspeedd=False` → 贴图不跟
--     速度转（270+90=360 = 原朝向），这是它躺不躺倒的关键。
--   · 花瓣的子事件：「宽比/高比变化到0.8」（从 0.1 **绽开**）、
--     「朝向增加120，正比，140帧」+ `t=140 add=140` 每 140 帧重来 → **永远慢慢自转**；
--     第 261/281/601/861/1201/1461 帧起「子弹速度增加…，正比，360帧」→ 缓慢外飘。
--   · id 12/13 出生 `alpha=0` → **没有判定**，到第 601/1201 帧
--     「不透明度变化到100」才**变得致命** —— 那是第二、第三圈的花。
--
--  Layer3（3 个批次）—— 跨循环的两条拐弯尾迹
--   · 根 id 0：`type=0` → 子弹不可见（`Barrage` 直接 return），但它照样当挂载点。
--     `横比=9` 把圆周压成扁椭圆、`sonspeed=8`；子事件
--     「子弹速度方向增加360，正比，23帧」→ 它自己 23 帧转一圈地飞。
--   · 炮塔 id 1/2：每帧沿载体吐一颗小弹。父事件把出膛速度从 2 线性压到 0.9
--     （越晚发的越慢 → 尾迹被拉长）；子事件先给每颗子弹
--     **随机一个方向**（`子弹速度方向变化到0+360`），再让**各自**拐 120 帧
--     （`增加0+120，正比，120帧`）—— 那个 `0+N` 就是「基准 0、随机 ±N」。
--   · ⚠ 根 `begin=510` 而炮塔 `181~300`，**第一圈根本不相交**；但载体 `sonlife=1200`
--     大于 `Totalframe=600`，**跨循环存活** —— 所以这两条尾迹是**第二圈才开始出现**
--     并逐圈累积的。这正是 CS「时间循环、子弹跨循环存活」的直接体现，不是 bug。
--==================================================================
do
    local name = "「西行庭千本桜図」"
    local card = boss.card.New(name, 38, 38, 38, 1000000)   --原数据是 TIME 耐久卡
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
        --★ 以下由 `tools/thmhj_tolua.py 660` 从原版数据生成，**不要手改**
        --   要改请改生成器再重跑；手抄 40 字段 × N 批次一定会出错。
        local CS = {
            {   -- Layer1（begin=1 end=520）
                { id=0, bind=-1, begin=71, life=120, t=2, tiao=1, fxp=true, ay=CY(480), r=-20, rd=0, fa=0, spread=360, speed=2, sd=CA(266), v=0.01, sw=1.2, sh=2, head=CA(270), cr=255, cg=125, cb=125, alpha=100, sonlife=600, mist=true, outdispel=true, invincible=true, spr=S_beam, evspec={
            { at=1, key="speed", how=1, mode=0, v=3, frames=60 },
            { at=1, key="r", how=1, mode=2, v=55, rand=10, frames=180 },
            { at=1, key="sh", how=1, mode=2, v=-0.4, frames=280 },
            { at=1, key="sw", how=1, mode=2, v=-0.5, frames=280 },
        } },
                { id=1, bind=-1, begin=1, life=120, t=1, tiao=3, fxp=true, ay=CY(490), r=360, rd=CA(270), fa=CA(90), spread=360, speed=0, sd=CA(270), v=5, sw=0.3, sh=1, head=CA(270), wsd=true, cr=255, cg=1, cb=155, alpha=1, sonlife=65, invincible=true, spr=S_beam, evspec={
            { at=1, key="rd", how=1, mode=0, v=-360, frames=20, every=20 },
            { at=1, key="fa", how=1, mode=0, v=-360, frames=20, every=20 },
        }, sevspec={
            { at=1, key="alpha", how=0, mode=2, v=30, rand=10, frames=120 },
        } },
                { id=2, bind=-1, begin=1, life=1, t=1, tiao=1, fxp=true, ay=CY(490), r=0, rd=0, fa=CA(90), spread=360, speed=0, sd=CA(270), v=0, sw=55, sh=55, head=CA(270), wsd=true, cr=255, cg=1, cb=155, alpha=1, sonlife=180, invincible=true, spr=S_beam, evspec={
            { at=1, key="rd", how=1, mode=0, v=360, frames=20, every=20 },
            { at=1, key="fa", how=1, mode=0, v=360, frames=20, every=20 },
        }, sevspec={
            { at=1, key="h", how=0, mode=0, v=1, frames=180 },
            { at=1, key="w", how=0, mode=0, v=1, frames=180 },
            { at=1, key="alpha", how=0, mode=0, v=80, frames=180 },
        } },
                { id=3, bind=-1, begin=71, life=120, t=2, tiao=1, fxp=true, ay=CY(480), r=30, rd=0, fa=0, spread=360, speed=1, sd=CA(270), v=0.01, sw=0.7, sh=1.5, head=CA(290), cr=255, cg=125, cb=125, alpha=100, sonlife=600, mist=true, outdispel=true, invincible=true, spr=S_beam, evspec={
            { at=1, key="speed", how=1, mode=0, v=3, frames=60 },
            { at=1, key="r", how=1, mode=2, v=-60, rand=10, frames=180 },
            { at=1, key="sh", how=1, mode=2, v=-0.3, frames=240 },
            { at=1, key="sw", how=1, mode=2, v=-0.2, frames=240 },
        } },
                { id=4, bind=-1, begin=71, life=120, t=2, tiao=1, fxp=true, ay=CY(480), r=-30, rd=0, fa=0, spread=360, speed=1, sd=CA(260), v=0.01, sw=0.6, sh=1.5, head=CA(230), cr=255, cg=125, cb=125, alpha=100, sonlife=600, mist=true, outdispel=true, invincible=true, spr=S_beam, evspec={
            { at=1, key="speed", how=1, mode=0, v=3, frames=60 },
            { at=1, key="r", how=1, mode=2, v=55, rand=10, frames=180 },
            { at=1, key="sh", how=1, mode=2, v=-0.3, frames=300 },
            { at=1, key="sw", how=1, mode=2, v=-0.3, frames=300 },
        } },
                { id=5, bind=-1, begin=66, life=1, t=1, tiao=1, fxp=true, ay=CY(470), r=1, rd=0, fa=0, spread=360, speed=0, sd=0, v=0.01, sw=1, sh=1, head=CA(230), cr=255, cg=125, cb=125, alpha=80, sonlife=60, outdispel=true, invincible=true, spr=S_beam, sevspec={
            { at=1, key="w", how=0, mode=0, v=15, frames=60 },
            { at=1, key="h", how=0, mode=0, v=15, frames=60 },
            { at=1, key="alpha", how=0, mode=0, v=1, frames=60 },
        } },
            },
            {   -- Layer2（begin=1 end=600）
                { id=0, bind=1, begin=182, life=299, t=4, tiao=1, r=0, rd=0, fa=0, spread=360, speed=0, sd=0, v=0.01, sw=0.1, sh=0.7, head=CA(270), cr=255, cg=255, cb=255, alpha=100, sonlife=315, invincible=true, spr=S_bigfan, extra=true, sevspec={
            { at=300, key="w", how=0, mode=0, v=0.1, frames=15 },
            { at=1, key="w", how=0, mode=0, v=0.7, frames=12 },
            { at=1, key="rot", how=1, mode=2, v=-5, frames=139, every=140 },
        } },
                { id=1, bind=-1, begin=181, life=13, t=4, tiao=1, ax=CX(136 - 4), ay=CY(124 + 16), r=0, rd=CA(11), fa=0, spread=360, speed=0, sd=CA(90), v=0, sw=0.1, sh=0.1, head=0, wsd=true, cr=255, cg=1, cb=121, alpha=30, sonlife=1, invincible=true, spr=S_jin, extra=true, evspec={
            { at=9, key="rd", how=1, mode=2, v=-10, frames=8 },
            { at=17, key="rd", how=1, mode=0, v=-90, frames=16 },
            { at=1, key="rd", how=1, mode=2, v=-17, rand=5, frames=8 },
            { at=1, key="r", how=1, mode=0, v=440, frames=16 },
            { at=22, key="r", how=1, mode=0, v=-70, frames=8 },
            { at=18, key="r", how=1, mode=0, v=130, frames=4 },
        } },
                { id=2, bind=1, begin=182, life=299, t=4, tiao=6, r=50, rd=CA(90), fa=CA(90), spread=220, speed=0, sd=0, v=0.01, sw=0.1, sh=0.1, head=CA(270), cr=255, cg=255, cb=255, alpha=100, sonlife=3413, dispel=true, outdispel=true, invincible=true, spr=S_sakura, extra=true, sevspec={
            { at=1, key="h", how=0, mode=0, v=0.8, frames=24 },
            { at=261, key="speed", how=1, mode=0, v=0.45, frames=360 },
            { at=1, key="w", how=0, mode=0, v=0.8, frames=24 },
            { at=1, key="rot", how=1, mode=0, v=-120, frames=140, every=140 },
        } },
                { id=3, bind=14, begin=182, life=16, t=4, tiao=2, r=40, rd=CA(90), fa=0, spread=220, speed=0, sd=0, v=1.9, sw=0.7, sh=0.7, head=CA(270), wsd=true, cr=255, cg=125, cb=155, alpha=90, sonlife=136, outdispel=true, invincible=true, spr=S_beam, extra=true, sevspec={
            { at=2, key="dir", how=1, mode=0, v=0, rand=15, frames=220 },
            { at=1, key="h", how=0, mode=0, v=0.3, frames=130 },
            { at=1, key="dir", how=0, mode=0, v=-90, frames=1 },
            { at=110, key="alpha", how=0, mode=0, v=1, frames=20 },
            { at=1, key="w", how=0, mode=0, v=0.3, frames=130 },
        } },
                { id=4, bind=3, begin=181, life=120, t=5, tiao=1, r=0, rd=0, fa=0, spread=360, speed=0, sd=0, v=0.01, sw=0.06, sh=0.5, head=0, wsd=true, cr=255, cg=95, cb=155, alpha=100, sonlife=350, dispel=true, outdispel=true, invincible=true, spr=S_beam, evspec={
            { at=1, key="life", how=0, mode=0, v=90, frames=120 },
        } },
                { id=5, bind=3, begin=181, life=136, t=8, tiao=1, r=0, rd=0, fa=CA(60), spread=360, speed=0, sd=0, v=0.5, sw=1.2, sh=1.2, head=0, wsd=true, cr=255, cg=255, cb=255, alpha=100, sonlife=1200, mist=true, dispel=true, outdispel=true, invincible=true, spr=S_dot, evspec={
            { at=1, key="sonaspeedd", how=1, mode=0, v=-120, frames=136 },
            { at=1, key="fa", how=1, mode=0, v=60, frames=136 },
        }, sevspec={
            { at=1, key="speed", how=0, mode=0, v=0.01, frames=30 },
        } },
                { id=6, bind=3, begin=181, life=136, t=8, tiao=1, r=0, rd=0, fa=CA(-60), spread=360, speed=0, sd=0, v=0.5, sw=1.2, sh=1.2, head=0, wsd=true, cr=255, cg=255, cb=255, alpha=100, sonlife=1200, mist=true, dispel=true, outdispel=true, invincible=true, spr=S_dot, evspec={
            { at=1, key="sonaspeedd", how=1, mode=0, v=120, frames=136 },
            { at=1, key="fa", how=1, mode=0, v=-60, frames=136 },
        }, sevspec={
            { at=1, key="speed", how=0, mode=0, v=0.01, frames=30 },
        } },
                { id=7, bind=1, begin=182, life=299, t=4, tiao=7, r=30, rd=CA(90), fa=CA(90), spread=260, speed=0, sd=0, v=0.01, sw=0.1, sh=0.1, head=CA(270), cr=255, cg=255, cb=255, alpha=100, sonlife=1413, dispel=true, invincible=true, spr=S_sakura, extra=true, sevspec={
            { at=1, key="h", how=0, mode=0, v=0.8, frames=18 },
            { at=261, key="speed", how=1, mode=0, v=0.8, frames=360 },
            { at=1, key="w", how=0, mode=0, v=0.8, frames=18 },
            { at=1, key="rot", how=1, mode=0, v=-120, frames=140, every=140 },
        } },
                { id=8, bind=-1, begin=186, life=12, t=4, tiao=1, ax=CX(489 - 4), ay=CY(68 + 16), r=0, rd=CA(185), fa=0, spread=360, speed=0, sd=CA(90), v=0, sw=0.1, sh=0.1, head=0, wsd=true, cr=255, cg=1, cb=121, alpha=30, sonlife=1, invincible=true, spr=S_jin, extra=true, evspec={
            { at=1, key="rd", how=1, mode=2, v=-12, frames=12 },
            { at=1, key="r", how=1, mode=0, v=420, frames=16 },
        } },
                { id=9, bind=8, begin=187, life=299, t=4, tiao=1, r=0, rd=0, fa=0, spread=360, speed=0, sd=0, v=0.01, sw=0.1, sh=0.7, head=CA(270), cr=255, cg=255, cb=255, alpha=100, sonlife=315, invincible=true, spr=S_bigfan, extra=true, sevspec={
            { at=300, key="w", how=0, mode=0, v=0.1, frames=15 },
            { at=1, key="w", how=0, mode=0, v=0.7, frames=12 },
            { at=1, key="rot", how=1, mode=2, v=5, frames=139, every=140 },
        } },
                { id=10, bind=8, begin=187, life=299, t=4, tiao=7, r=40, rd=CA(90), fa=CA(90), spread=220, speed=0, sd=0, v=0.01, sw=0.1, sh=0.1, head=CA(270), cr=255, cg=255, cb=255, alpha=100, sonlife=1413, dispel=true, invincible=true, spr=S_sakura, extra=true, sevspec={
            { at=1, key="h", how=0, mode=0, v=0.8, frames=24 },
            { at=281, key="speed", how=1, mode=0, v=1, frames=360 },
            { at=1, key="w", how=0, mode=0, v=0.8, frames=24 },
            { at=1, key="rot", how=1, mode=0, v=-120, frames=140, every=140 },
        } },
                { id=11, bind=8, begin=187, life=299, t=4, tiao=8, r=75, rd=CA(270), fa=CA(270), spread=220, speed=0, sd=0, v=0.01, sw=0.1, sh=0.1, head=CA(270), cr=255, cg=255, cb=255, alpha=100, sonlife=1413, dispel=true, invincible=true, spr=S_sakura, extra=true, sevspec={
            { at=1, key="h", how=0, mode=0, v=0.8, frames=36 },
            { at=281, key="speed", how=1, mode=0, v=1, frames=240 },
            { at=1, key="w", how=0, mode=0, v=0.8, frames=36 },
            { at=1, key="rot", how=1, mode=0, v=-120, frames=140, every=140 },
        } },
                { id=12, bind=1, begin=182, life=299, t=4, tiao=9, r=60, rd=CA(90), fa=CA(90), spread=290, speed=0, sd=0, v=0.01, sw=0.1, sh=0.1, head=CA(270), cr=255, cg=255, cb=255, alpha=0, sonlife=3413, dispel=true, outdispel=true, invincible=true, spr=S_sakura, extra=true, sevspec={
            { at=601, key="h", how=0, mode=0, v=0.8, frames=18 },
            { at=861, key="speed", how=1, mode=0, v=0.4, frames=360 },
            { at=601, key="w", how=0, mode=0, v=0.8, frames=18 },
            { at=601, key="alpha", how=0, mode=0, v=100, frames=1 },
            { at=1, key="rot", how=1, mode=0, v=-120, frames=140, every=140 },
        } },
                { id=13, bind=1, begin=182, life=299, t=4, tiao=9, r=70, rd=CA(90), fa=CA(90), spread=290, speed=0, sd=0, v=0.01, sw=0.1, sh=0.1, head=CA(270), cr=255, cg=255, cb=255, alpha=0, sonlife=3413, dispel=true, outdispel=true, invincible=true, spr=S_sakura, extra=true, sevspec={
            { at=1201, key="h", how=0, mode=0, v=0.8, frames=18 },
            { at=1461, key="speed", how=1, mode=0, v=1, frames=360 },
            { at=1201, key="w", how=0, mode=0, v=0.8, frames=18 },
            { at=1201, key="alpha", how=0, mode=0, v=100, frames=1 },
            { at=1, key="rot", how=1, mode=0, v=-120, frames=140, every=140 },
        } },
                { id=14, bind=-1, begin=181, life=13, t=4, tiao=1, ax=CX(100), ay=CY(105 + 16), r=0, rd=CA(5), fa=0, spread=360, speed=0, sd=CA(90), v=0, sw=0.1, sh=0.1, head=0, wsd=true, cr=255, cg=1, cb=121, alpha=30, sonlife=1, invincible=true, spr=S_jin, extra=true, evspec={
            { at=17, key="rd", how=1, mode=0, v=-90, frames=16 },
            { at=1, key="rd", how=1, mode=2, v=-5, rand=5, frames=8 },
            { at=1, key="r", how=1, mode=0, v=500, frames=16 },
            { at=22, key="r", how=1, mode=0, v=-70, frames=8 },
            { at=18, key="r", how=1, mode=0, v=130, frames=4 },
        } },
            },
            {   -- Layer3（begin=1 end=520）
                { id=0, bind=-1, begin=510, life=1, t=1, tiao=1, ax=CX(288 - 4), ay=CY(32 + 16), r=0, rd=CA(90), fa=0, spread=360, speed=0, sd=0, v=8, sw=1, sh=1, head=0, wsd=true, cr=255, cg=255, cb=255, alpha=100, sonlife=1200, xs=9, invincible=true, invisible=true, sevspec={
            { at=1, key="dir", how=1, mode=0, v=-360, frames=23, every=23 },
        } },
                { id=1, bind=0, begin=181, life=120, t=1, tiao=1, r=0, rd=0, fa=0, spread=360, speed=0, sd=0, v=2, sw=0.9, sh=0.8, head=0, wsd=true, cr=255, cg=255, cb=255, alpha=100, sonlife=2200, mist=true, dispel=true, outdispel=true, spr=S_b138, evspec={
            { at=1, key="v", how=1, mode=0, v=-1.1, frames=120 },
        }, sevspec={
            { at=1, key="w", how=1, mode=2, v=0.3, frames=14, every=15 },
            { at=1, key="speed", how=1, mode=0, v=0, rand=0.3, frames=1 },
            { at=1, key="dir", how=0, mode=0, v=0, rand=360, frames=1 },
            { at=2, key="dir", how=1, mode=0, v=0, rand=120, frames=120 },
        } },
                { id=2, bind=0, begin=183, life=120, t=1, tiao=1, r=0, rd=CA(90), fa=0, spread=360, speed=0, sd=0, v=2, sw=0.9, sh=0.8, head=0, wsd=true, cr=255, cg=255, cb=255, alpha=100, sonlife=2200, mist=true, dispel=true, outdispel=true, spr=S_b140, evspec={
            { at=1, key="v", how=1, mode=0, v=-1.1, frames=120 },
        }, sevspec={
            { at=1, key="w", how=1, mode=2, v=0.3, frames=14, every=15 },
            { at=1, key="speed", how=1, mode=0, v=0, rand=0.3, frames=1 },
            { at=1, key="dir", how=0, mode=0, v=0, rand=360, frames=1 },
            { at=2, key="dir", how=1, mode=0, v=0, rand=120, frames=120 },
        } },
            },
        }

        run_cs(self, 600, CS)
    end
end
