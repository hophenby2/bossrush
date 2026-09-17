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
---所以 **1:1、中心 (320,240)**，只做平移加一次 y 翻转。
local function CX(x) return x - 320 end
local function CY(y) return 240 - y end
local function CA(a) return -a end

---发一发（出膛即走）
local function fly(style, x, y, v, a, r, g, b, omiga, sw, sh, alpha, head, wsd)
    local o = NewSimpleBullet(style, 1, x, y, v, a, false, omiga or 0, false)
    o._v0 = v or 0                        --出膛速度（子事件可能改它）
    o._sp, o._dir = v or 0, a or 0        --子事件「子弹速度/方向」读写的就是这两个
    o._r, o._g, o._b = r or 255, g or 255, b or 255
    o._blend = "mul+add"
    if sw then o.hscale, o.vscale = sw, (sh or sw) end
    o._a = (alpha or 100) * 2.55          --CS 的 alpha 是 0..100
    --`Barrage.cs:399`：Withspeedd 时贴图朝向跟着速度方向，否则是批次自己的 head
    o.rot = wsd and (a or 0) or (head or 0)
    return o
end

---★ 子事件组用的代理：在事件里读写 `p.w / p.h / p.alpha / p.rot / p.speed / p.dir`
---就等于读写子弹自己的字段。速度/方向改完必须 `object.SetV` 才真的拐弯。
---（子弹的属性表是 `CSManager.cs:133-155` 的 `results2`，和批次的**不是同一张**）
local function bullet_proxy(bb)
    return setmetatable({}, {
        __index = function(_, k)
            if k == "speed" then return bb._sp end
            if k == "dir" then return bb._dir end
            if k == "alpha" then return bb._a / 2.55 end
            if k == "w" then return bb.hscale end
            if k == "h" then return bb.vscale end
            return bb[k]
        end,
        __newindex = function(_, k, v)
            if k == "speed" then bb._sp = v
            elseif k == "dir" then bb._dir = v
            elseif k == "alpha" then bb._a = v * 2.55
            elseif k == "w" then bb.hscale = v
            elseif k == "h" then bb.vscale = v
            else bb[k] = v end
            if k == "speed" or k == "dir" then object.SetV(bb, bb._sp, bb._dir, false) end
        end,
    })
end

---★ Crazy Storm 的事件组 → 每帧回调。
---  spec = { at=触发帧（默认1）, every=重复间隔（事件组的 t/addtime）, key="r",
---           how=0/1/2, mode=0/1/2, v=数值, rand=随机幅度, frames=帧数 }
---    how ：0=设为目标值  1=增加  2=减少
---    mode：0=正比  1=固定  2=正弦      （`Execution.cs:77 / 529 / 981`）
---  触发那一刻把该属性的当前值记成 `region`（正弦绕它振荡），并掷一次随机。
---  ⚠ 属性名（中文）到字段的映射**分四张表**（`CSManager.cs:88-215`）：
---    父事件组用 `results`（半径2 半径方向3 角度6 速度8 生命12 宽比14 高比15 不透明度19 子弹速度21），
---    子事件组用 `results2`（宽比2 高比3 不透明度7 朝向8 子弹速度9 子弹速度方向10）。
---    所以「子弹速度」在批次上是 `sonspeed`、在子弹上是 `speed`，是**两个**字段。
local function events(specs)
    local st = {}
    return function(b, time)
        for i = 1, #specs do
            local s = specs[i]
            local e = st[i]
            local due = time >= (s.at or 1)
            if due and s.every then due = (time - (s.at or 1)) % s.every == 0 end
            if not e and due then
                e = { region = b[s.key], ctime = s.frames,
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
--  一个「批次」表长这样（坐标/角度**已经换算过**）：
--    { id, bind, begin, life, t, tiao, spr,
--      ax, ay,            -- 根的发射锚点（= CS 的 fx/fy）
--      r, rd,             -- 扇形半径 / 扇形中心角（事件会改它 → 枝条）
--      fa, spread,        -- 射击方向中心角 / 张角
--      v, omi,            -- 子弹速度 / 角速度（CS 的 sonspeed / sonaspeed）
--      sw, sh, head, wsd, -- 贴图缩放 / 朝向 / Withspeedd
--      cr,cg,cb, alpha,   -- 颜色与不透明度
--      speed, sd,         -- 批次自身每帧位移（CS 的 speed / speedd）
--      sonlife, dispel, mist,
--      extra,             -- 「当前帧=1：额外发射」→ 时间 1 也发一轮
--      evspec = {...},    -- 父事件组：改批次自己的属性
--      sevspec = {...},   -- 子事件组：改**每颗子弹**自己的属性
--      ev2(bb)            -- 需要写代码的子弹回调时用它 }
--==================================================================
local function run_cs(self, total, layers)
    local st, idx = {}, {}
    local SAVE = { "r", "rd", "fa", "spread", "tiao", "t", "life", "speed", "sd",
                   "ax", "ay", "x", "y", "sw", "sh", "alpha", "v", "omi" }
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
    ---回到「原始数据 + 哨兵重算」（`Time.cs:74` 每个循环 `copys = Copy()` 一次）。
    ---少了这一步，事件对 r / speed 的累加会跨循环越滚越大，几圈之后就不是这张卡了。
    local function rewind()
        for i = 1, #st do
            local s = st[i]
            for k, v in pairs(s.orig) do s.b[k] = v end
            s.carriers = {}
            if s.b.fxp then s.b.ax = player.x end      --fx=-99999 → 自机的 X（每个循环取一次）
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
                    if b.ev then b.ev(b, time, now) end
                    --⑤ 每 t 帧发一次（Batch.cs:1547），外加「额外发射」
                    if (b.t > 0 and time % b.t == 0) or (b.extra and time == 1) then
                        local n, spread = b.tiao or 1, b.spread or 360
                        local function volley(ox, oy)
                            for g = 0, n - 1 do
                                --位置与方向**共用**同一条扇形（Batch.cs:1740-1742）
                                local k = g - (n - 1) / 2
                                local pa = (b.rd or 0) + k * spread / n
                                local da = (b.fa or 0) + k * spread / n
                                local o = fly(b.spr, ox + (b.r or 0) * cos(pa),
                                        oy + (b.r or 0) * sin(pa), b.v or 0, da,
                                        b.cr or 255, b.cg or 255, b.cb or 255,
                                        b.omi or 0, b.sw, b.sh, b.alpha, b.head, b.wsd)
                                --★ 每颗子弹都有寿命：`time > add + sonlife` 之后
                                --  淡出 20 帧再删（`Barrage.cs:1530-1545`，前提 Dispel）。
                                --  ⚠ 少了这一步，`sonlife=1` 的**运载弹会永远赖着不走**，
                                --    炮塔就一直挂在它身上发弹 —— 数量会指数级爆掉。
                                local lt = b.sonlife + (b.mist and 15 or 0)
                                local f2, sev = b.ev2, b.sev
                                local d0 = b.mist and 15 or 0   --Mist 的子弹事件晚 15 帧起算
                                if o then
                                    o.frame_other = function(bb)
                                        if f2 then f2(bb) end
                                        local t = bb.timer
                                        if sev then
                                            local p = bb._proxy
                                            if not p then p = bullet_proxy(bb); bb._proxy = p end
                                            sev(p, t - d0)
                                        end
                                        if t > lt then
                                            if b.dispel then
                                                local k = max(100 - (t - lt) * 5, 0)
                                                bb._a = k * 2.55
                                                bb.hscale = max((b.sw or 1) * (k / 100), 0.01)
                                                bb.vscale = max((b.sh or b.sw or 1) * (k / 100), 0.01)
                                                if t > lt + 20 then object.RawDel(bb) end
                                            else
                                                object.RawDel(bb)      --不淡出，直接到期
                                            end
                                        end
                                    end
                                end
                                if b.bind < 0 then s.carriers[#s.carriers + 1] = o end
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
--  这一张的骨架就是**一棵树**，全部靠「根批次 + 骑在它身上的炮塔」搭出来：
--
--  Layer2 三根枝条（`bindid=-1`，`type=240`→本卡[11]=「阵」）：
--    根批次自己 `speedd=90`，`t=4`、`life=13`，事件把**自己的**半径
--    从 0 推到 440、半径方向扫几十度 —— 于是它每 4 帧在弧线上一个更远的点
--    吐一颗「阵」（`sonlife=1`，闪一下就没）。这几颗「阵」就是**载体**，
--    连起来正是一根向外的枝条。
--    ⚠ 根批次带「当前帧=1：额外发射」，所以第一个节点在第 1 帧就有了 —— 一根枝条 4 个节点。
--  · 枝条一 id=1  x=136 y=124  rd=11  → 骑它的是 id=0/2/7/12/13（大头，樱花 6/7/9/9 发）
--  · 枝条二 id=8  x=489 y=68   rd=185 → 骑它的是 id=9/10/11
--  · 枝条三 id=14 x=170 y=105  rd=5   → id=3（二级载体）→ id=4/5/6
--
--  骑在枝条上的炮塔（`bindid=N`）在**每个节点**开一朵花：
--    `r` 是花心到节点的距离，`rdirection` 是花朝哪边，`range` 是花瓣张角，
--    位置和方向共用同一条扇形 —— 所以「花瓣」是从节点向外**射出去**的。
--    ⚠ 花瓣的**张开**是子事件组做的：「宽比/高比变化到0.8，正比，24帧」——
--      子弹出生时只有 0.1，24 帧里长到 0.8。漏了子事件组，花就只有一粒芝麻大。
--
--  Layer1 三条光柱 + 三向转轮 + 两次爆闪；Layer3 一颗看不见的载体拖着两条尾迹。
--
--  ⚠ Totalframe=600：整套每 600 帧**重来一遍**，而樱花 `sonlife=3413` 跨循环累积
--    —— 「千本桜図」的那一屏花就是这么攒出来的。id=12/13 的樱花出生时 `alpha=0`，
--    到第 601 / 1201 帧才「不透明度变化到100」现身，是**第二、第三圈**的花。
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
        task.New(self, function()
            task.Wait(50)
            Newcharge_in(self.x, self.y, 255, 190, 236)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 190, 236)
        end)

        --三个图层分开装：`bindid` 只在**本图层**里找，混在一起会串线
        local L1, L2, L3 = {}, {}, {}
        local function add(t, layer)
            local dest = (layer == 1) and L1 or (layer == 2) and L2 or L3
            dest[#dest + 1] = t
            return t
        end

        --======== Layer1：三条光柱 + 三向转轮 + 两次爆闪 ========
        --`fx = -99999` → **每个循环开始时**取一次自机 X（`Time.cs:79-83`），之后不再跟随，
        --靠 speed 沿 speedd 自己飞；「速度增加3，正比，60帧」把 speed 越加越快。
        for _, e in ipairs({
            { id = 0, sd = 266, sp = 2, r = -20, sw = 1.2, sh = 2.0, sv = 0.5, hv = 0.4, sf = 280, gv = 55, gh = 1, head = 270 },
            { id = 3, sd = 270, sp = 1, r =  30, sw = 0.7, sh = 1.5, sv = 0.2, hv = 0.3, sf = 240, gv = 60, gh = 2, head = 290 },
            { id = 4, sd = 260, sp = 1, r = -30, sw = 0.6, sh = 1.5, sv = 0.3, hv = 0.3, sf = 300, gv = 55, gh = 1, head = 230 },
        }) do
            add({ id = e.id, bind = -1, begin = 71, life = 120, t = 2, tiao = 1, spr = S_beam,
                fxp = true, ay = CY(480), r = e.r, rd = 0, fa = 0, spread = 360, v = 0.01,
                speed = e.sp, sd = CA(e.sd), sw = e.sw, sh = e.sh, head = CA(e.head),
                alpha = 100, sonlife = 600,
                evspec = {
                    { at = 1, key = "speed", how = 1, mode = 0, v = 3, frames = 60 },
                    { at = 1, key = "r",  how = e.gh, mode = 2, v = e.gv, rand = 10, frames = 180 },
                    { at = 1, key = "sh", how = 2, mode = 2, v = e.hv, frames = e.sf },
                    { at = 1, key = "sw", how = 2, mode = 2, v = e.sv, frames = e.sf },
                } }, 1)
        end
        --[1] 三向转轮：半径 360 的圆上摆三个点，方向也是三向；事件组 `t=20 add=20`
        --    「半径方向/角度增加360，正比，20帧」= 每 20 帧转一整圈 → 连续自转 18°/帧
        add({ id = 1, bind = -1, begin = 1, life = 120, t = 1, tiao = 3, spr = S_beam,
            fxp = true, ay = CY(490), r = 360, rd = CA(270), fa = CA(90), spread = 360, v = 5,
            speed = 0, sd = CA(270), sw = 0.3, sh = 1, head = CA(270), wsd = true,
            alpha = 1, sonlife = 65,
            evspec = {
                { at = 1, every = 20, key = "rd", how = 1, mode = 0, v = 360, frames = 20 },
                { at = 1, every = 20, key = "fa", how = 1, mode = 0, v = 360, frames = 20 },
            },
            --子事件：「不透明度变化到30+10，正弦，120帧」绕出生值(1)荡到 30
            sevspec = { { at = 1, key = "alpha", how = 0, mode = 2, v = 30, rand = 10, frames = 120 } } }, 1)
        --[2] 巨闪：半径 0、宽高比 55，只活 1 帧；子事件把它在 180 帧里收成 1
        add({ id = 2, bind = -1, begin = 1, life = 1, t = 1, tiao = 1, spr = S_beam,
            fxp = true, ay = CY(490), r = 0, rd = 0, fa = CA(90), spread = 360, v = 0,
            speed = 0, sw = 55, sh = 55, head = CA(270), wsd = true, alpha = 1, sonlife = 180,
            sevspec = {
                { at = 1, key = "h", how = 0, mode = 0, v = 1, frames = 180 },
                { at = 1, key = "w", how = 0, mode = 0, v = 1, frames = 180 },
                { at = 1, key = "alpha", how = 0, mode = 0, v = 80, frames = 180 },
            } }, 1)
        --[5] 爆闪
        add({ id = 5, bind = -1, begin = 66, life = 1, t = 1, tiao = 1, spr = S_beam,
            fxp = true, ay = CY(470), r = 1, rd = 0, fa = 0, spread = 360, v = 0.01,
            speed = 0, sw = 1, sh = 1, head = CA(230), alpha = 80, sonlife = 60,
            sevspec = {
                { at = 1, key = "w", how = 0, mode = 0, v = 15, frames = 60 },
                { at = 1, key = "h", how = 0, mode = 0, v = 15, frames = 60 },
                { at = 1, key = "alpha", how = 0, mode = 0, v = 1, frames = 60 },
            } }, 1)

        --======== Layer2：三根枝条 ========
        --根批次（`bindid=-1`）就是**枝条**：它自己 `speedd=90`，事件把**自己的**半径
        --从小推到大、半径方向来回摆，于是它每 4 帧在弧线上一个更远的点吐一颗「阵」
        --（`sonlife=1`，闪一下就没）。那几颗「阵」就是**载体**，连起来就是一根枝条。
        --⚠ life 只有 12~13 帧，所以「当前帧=17/18/22」那些事件在本体上**永远不会触发**
        --  —— 编辑器里留下的死事件，别照着写（`Deepbind=False`，没有克隆体去跑它们）。
        for _, e in ipairs({
            --      id   x    y   begin life  rd   ξgv  gframes  wv  wrand wframes  [第二条摆动]
            { id = 1,  x = 136, y = 124, begin = 181, life = 13, rd = 11,  gv = 440, gf = 16, wv = 17, wr = 5, wf = 8, a2 = 9, v2 = 10 },
            { id = 8,  x = 489, y =  68, begin = 186, life = 12, rd = 185, gv = 420, gf = 16, wv = 12, wr = 0, wf = 12 },
            { id = 14, x = 170, y = 105, begin = 181, life = 13, rd = 5,   gv = 500, gf = 16, wv = 5,  wr = 5, wf = 8, fx = 100 },
        }) do
            local spec = {
                { at = 1, key = "r",  how = 1, mode = 0, v = e.gv, frames = e.gf },
                { at = 1, key = "rd", how = 1, mode = 2, v = e.wv, rand = e.wr, frames = e.wf },
            }
            --「当前帧=9：半径方向增加10，正弦，8帧」——枝条一在生长中途再补摆一次
            if e.a2 then spec[#spec + 1] = { at = e.a2, key = "rd", how = 1, mode = 2, v = e.v2, frames = 8 } end
            add({ id = e.id, bind = -1, begin = e.begin, life = e.life, t = 4, tiao = 1,
                spr = S_jin,
                --fx/fy：-99998 → x−4 / y+16（`Time.cs:79-90`）；枝条三是字面量 fx=100
                ax = CX(e.fx or (e.x - 4)), ay = CY(e.y + 16),
                r = 0, rd = CA(e.rd), fa = CA(0), spread = 360, v = 0,
                speed = 0, sd = CA(90), sw = 0.1, sh = 0.1, head = 0, wsd = true, alpha = 30,
                cr = 255, cg = 1, cb = 121, sonlife = 1, dispel = false, mist = false,
                extra = true, evspec = spec }, 2)
        end

        --======== 炮塔：在每个节点周围开一朵花 ========
        --位置和方向**共用**同一条扇形（`Batch.cs:1740-1742` / `Barrage.cs:375-379`）：
        --  位置 = 节点 + r·(cos,sin)(rdirection + 半宽偏移)
        --  方向 = fdirection + 同一个偏移
        --所以「花瓣」是从节点向外**射出去**的，`r` 是花心到节点的距离。
        --⚠ `extra` 只有数据里带「当前帧=1：额外发射」的批次才有 —— id=4/5/6 没有。
        local TURRETS = {
            --id  bind  begin life  t tiao   r   rd   fa spread  贴图        sw    sh    v     sonlife dispel alpha head wsd
            { 0,   1,  182, 299, 4,  1,   0,   0,   0,  360, S_bigfan, 0.1, 0.7, 0.01,  315,  false, 100, 270, false },
            { 2,   1,  182, 299, 4,  6,  50,  90,  90,  220, S_sakura, 0.1, 0.1, 0.01, 3413, true,  100, 270, false },
            { 7,   1,  182, 299, 4,  7,  30,  90,  90,  260, S_sakura, 0.1, 0.1, 0.01, 1413, true,  100, 270, false },
            { 12,  1,  182, 299, 4,  9,  60,  90,  90,  290, S_sakura, 0.1, 0.1, 0.01, 3413, true,  0,   270, false },
            { 13,  1,  182, 299, 4,  9,  70,  90,  90,  290, S_sakura, 0.1, 0.1, 0.01, 3413, true,  0,   270, false },
            { 9,   8,  187, 299, 4,  1,   0,   0,   0,  360, S_bigfan, 0.1, 0.7, 0.01,  315,  false, 100, 270, false },
            { 10,  8,  187, 299, 4,  7,  40,  90,  90,  220, S_sakura, 0.1, 0.1, 0.01, 1413, true,  100, 270, false },
            { 11,  8,  187, 299, 4,  8,  75, 270, 270, 220, S_sakura, 0.1, 0.1, 0.01, 1413, true,  100, 270, false },
            --枝条三：先挂一个二级载体（id=3）到枝条上，再让三个炮塔骑那个二级载体
            { 3,  14,  182,  16, 4,  2,  40,  90,   0,  220, S_beam,   0.7, 0.7, 1.9,   136,  false, 90,  270, true  },
            { 4,   3,  181, 120, 5,  1,   0,   0,   0,  360, S_beam,   0.06, 0.5, 0.01, 350,  true,  100, 0,   true  },
            { 5,   3,  181, 136, 8,  1,   0,   0,  60,  360, S_dot,    1.2, 1.2, 0.5,  1200, true,  100, 0,   true  },
            { 6,   3,  181, 136, 8,  1,   0,   0, -60,  360, S_dot,    1.2, 1.2, 0.5,  1200, true,  100, 0,   true  },
        }
        --子事件组：花瓣的张开、旋转、加速 —— 漏了这块花就只有一粒芝麻大
        local SEV = {
            [0]  = { { at = 1, key = "w", how = 0, mode = 0, v = 0.7, frames = 12 },
                     { at = 300, key = "w", how = 0, mode = 0, v = 0.1, frames = 15 },
                     { at = 1, every = 140, key = "rot", how = 1, mode = 2, v = 5, frames = 139 } },
            [2]  = { { at = 1, key = "h", how = 0, mode = 0, v = 0.8, frames = 24 },
                     { at = 1, key = "w", how = 0, mode = 0, v = 0.8, frames = 24 },
                     { at = 261, key = "speed", how = 1, mode = 0, v = 0.45, frames = 360 },
                     { at = 1, every = 140, key = "rot", how = 1, mode = 0, v = 120, frames = 140 } },
            [7]  = { { at = 1, key = "h", how = 0, mode = 0, v = 0.8, frames = 18 },
                     { at = 1, key = "w", how = 0, mode = 0, v = 0.8, frames = 18 },
                     { at = 261, key = "speed", how = 1, mode = 0, v = 0.8, frames = 360 },
                     { at = 1, every = 140, key = "rot", how = 1, mode = 0, v = 120, frames = 140 } },
            --id=12/13 出生时 alpha=0，第 601 / 1201 帧才现身 —— 第二、第三圈的花
            [12] = { { at = 601, key = "h", how = 0, mode = 0, v = 0.8, frames = 18 },
                     { at = 601, key = "w", how = 0, mode = 0, v = 0.8, frames = 18 },
                     { at = 861, key = "speed", how = 1, mode = 0, v = 0.4, frames = 360 },
                     { at = 601, key = "alpha", how = 0, mode = 0, v = 100, frames = 1 },
                     { at = 1, every = 140, key = "rot", how = 1, mode = 0, v = 120, frames = 140 } },
            [13] = { { at = 1201, key = "h", how = 0, mode = 0, v = 0.8, frames = 18 },
                     { at = 1201, key = "w", how = 0, mode = 0, v = 0.8, frames = 18 },
                     { at = 1461, key = "speed", how = 1, mode = 0, v = 1, frames = 360 },
                     { at = 1201, key = "alpha", how = 0, mode = 0, v = 100, frames = 1 },
                     { at = 1, every = 140, key = "rot", how = 1, mode = 0, v = 120, frames = 140 } },
            [9]  = { { at = 1, key = "w", how = 0, mode = 0, v = 0.7, frames = 12 },
                     { at = 300, key = "w", how = 0, mode = 0, v = 0.1, frames = 15 },
                     { at = 1, every = 140, key = "rot", how = 2, mode = 2, v = 5, frames = 139 } },
            [10] = { { at = 1, key = "h", how = 0, mode = 0, v = 0.8, frames = 24 },
                     { at = 1, key = "w", how = 0, mode = 0, v = 0.8, frames = 24 },
                     { at = 281, key = "speed", how = 1, mode = 0, v = 1, frames = 360 },
                     { at = 1, every = 140, key = "rot", how = 1, mode = 0, v = 120, frames = 140 } },
            [11] = { { at = 1, key = "h", how = 0, mode = 0, v = 0.8, frames = 36 },
                     { at = 1, key = "w", how = 0, mode = 0, v = 0.8, frames = 36 },
                     { at = 281, key = "speed", how = 1, mode = 0, v = 1, frames = 240 },
                     { at = 1, every = 140, key = "rot", how = 1, mode = 0, v = 120, frames = 140 } },
            [3]  = { { at = 1, key = "w", how = 0, mode = 0, v = 0.3, frames = 130 },
                     { at = 1, key = "h", how = 0, mode = 0, v = 0.3, frames = 130 },
                     { at = 1, key = "dir", how = 0, mode = 0, v = 90, frames = 1 },
                     { at = 2, key = "dir", how = 1, mode = 0, v = 15, frames = 220 },
                     { at = 110, key = "alpha", how = 0, mode = 0, v = 1, frames = 20 } },
            [5]  = { { at = 1, key = "speed", how = 0, mode = 0, v = 0.01, frames = 30 } },
            [6]  = { { at = 1, key = "speed", how = 0, mode = 0, v = 0.01, frames = 30 } },
        }
        --「当前帧=1：额外发射」：数据里只有这些批次有
        local EXTRA = { [0] = 1, [1] = 1, [2] = 1, [7] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1, [14] = 1 }
        for _, t in ipairs(TURRETS) do
            local b = { id = t[1], bind = t[2], begin = t[3], life = t[4], t = t[5], tiao = t[6],
                spr = t[11], r = t[7], rd = CA(t[8]), fa = CA(t[9]), spread = t[10],
                v = t[14], sw = t[12], sh = t[13], cr = 255, cg = 255, cb = 255,
                sonlife = t[15], dispel = t[16], mist = (t[1] == 5 or t[1] == 6),
                alpha = t[17], head = CA(t[18]), wsd = t[19],
                extra = EXTRA[t[1]], sevspec = SEV[t[1]] }
            if t[1] == 3 then b.cg, b.cb = 125, 155 end
            if t[1] == 4 then b.cg, b.cb = 95, 155
                b.evspec = { { at = 1, key = "life", how = 0, mode = 0, v = 90, frames = 120 } } end
            --[5]/[6] 的「角度减少/增加60，正比，136帧」= fdirection 从 ±60 扫回 0
            if t[1] == 5 then b.evspec = { { at = 1, key = "fa", how = 2, mode = 0, v = 60, frames = 136 } } end
            if t[1] == 6 then b.evspec = { { at = 1, key = "fa", how = 1, mode = 0, v = 60, frames = 136 } } end
            add(b, 2)
        end

        --======== Layer3：一颗看不见的载体 + 两个炮塔（会拐的尾迹）========
        --根 id=0：`type=0` → 子弹 type −1 = −1 → **不可见**；`sonspeed=8` 飞出去。
        --它的**子事件**「子弹速度方向增加360，正比，23帧」让载体自己一直转 ——
        --方向一直转 + 一直往前飞 = 走一个圆，两个炮塔沿路吐小弹，画出**环形**尾迹。
        --父事件「子弹速度减少1.1，正比，120帧」让**越晚发的弹越慢**（尾迹被拉长）；
        --子事件「子弹速度方向变化到360」+「增加120，正比，120帧」让每颗子弹自己拐 120°。
        add({ id = 0, bind = -1, begin = 510, life = 1, t = 1, tiao = 1,
            spr = S_beam, ax = CX(288 - 4), ay = CY(32 + 16), r = 0, rd = CA(90),
            fa = CA(0), spread = 360, v = 8, speed = 0, sd = CA(0),
            sw = 0.001, sh = 0.001, head = 0, wsd = true, alpha = 100,
            cr = 255, cg = 255, cb = 255, sonlife = 1200, dispel = false, mist = false,
            extra = true,
            sevspec = { { at = 1, every = 23, key = "dir", how = 1, mode = 0, v = 360, frames = 23 } } }, 3)
        for _, t in ipairs({
            { id = 1, begin = 181, spr = S_b138, rd = 0 },
            { id = 2, begin = 183, spr = S_b140, rd = 90 },
        }) do
            add({ id = t.id, bind = 0, begin = t.begin, life = 120, t = 1, tiao = 1,
                spr = t.spr, r = 0, rd = CA(t.rd), fa = CA(0), spread = 360, v = 2,
                sw = 0.9, sh = 0.8, head = 0, wsd = true,
                cr = 226, cg = 190, cb = 255, sonlife = 2200, dispel = true, mist = true,
                evspec = { { at = 1, key = "v", how = 2, mode = 0, v = 1.1, frames = 120 } },
                sevspec = {
                    { at = 1, every = 15, key = "w", how = 1, mode = 2, v = 0.3, frames = 14 },
                    { at = 1, key = "speed", how = 1, mode = 0, v = 0.3, frames = 1 },
                    { at = 1, key = "dir", how = 0, mode = 0, v = 360, frames = 1 },
                    { at = 2, key = "dir", how = 1, mode = 0, v = 120, frames = 120 },
                } }, 3)
        end

        run_cs(self, 600, { L1, L2, L3 })
    end
end
