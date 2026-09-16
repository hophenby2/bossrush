---=====================================
---符卡脚本静态自检（不是游戏的一部分，引擎不会载入这个文件）
---
---  这台机器上没有 Windows，跑不起 LuaSTGSub.exe，所以写了个桩件：
---    1) 把关卡文件真跑一遍载入流程，检查 boss.Define / boss.card.add 的注册
---    2) 实现一个最小的对象表 + 协程调度，按帧驱动所有对象的 frame，
---       看十张符卡各自的运行时逻辑会不会炸
---
---  用法：
---    luajit tools/check_stage.lua mod/GAME/th03.lua          # 默认模拟 1800 帧
---    luajit tools/check_stage.lua mod/GAME/th01.lua 4000     # 模拟 4000 帧
---    TH03_DEBUG=1 luajit tools/check_stage.lua mod/GAME/th03.lua   # 打每 60 帧的任务状态
---
---  它查不出来的：贴图名拼错（要真跑引擎才知道）、手感、演出观感、
---  以及引擎侧的被弹/擦弹/结算逻辑。这些只能进游戏看。
---=====================================

local path = arg[1]
local FRAMES = tonumber(arg[2]) or 1800
local DEBUG = os.getenv("STAGE_DEBUG")

if not path then
    print("用法: luajit tools/check_stage.lua <关卡文件> [帧数]")
    os.exit(1)
end

local failures = 0
local function fail(msg)
    failures = failures + 1
    print("FAIL: " .. msg)
end
local function pass(msg) print("  OK  " .. msg) end

----------------------------------------------------------------------
-- 1. 引擎桩件
----------------------------------------------------------------------
local function Forbid(v, lo, hi)
    if v < lo then return lo elseif v > hi then return hi else return v end
end
local function Angle(a, b, c, d)
    if d then return math.deg(math.atan2(d - b, c - a))
    else return math.deg(math.atan2(b.y - a.y, b.x - a.x)) end
end
local function Dist(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

local objects, bullets, tasks, current_task = {}, {}, {}, nil

local function Class(base, define)
    local c = {}
    if base then
        c.base = base
        setmetatable(c, { __index = base })
    end
    for k, v in pairs(define or {}) do c[k] = v end
    return c
end
_G.Class = Class

-- 关卡文件在载入时会把一批全局函数抓成本地，所以这些必须挂在 _G 上。
-- 没实现的全局一律返回一个「什么都能干」的桩，免得因为桩件不全误报。
local function stub_table(name)
    return setmetatable({}, {
        __index = function(_, k)
            local f = function() return stub_table(name .. "." .. tostring(k)) end
            return f
        end,
        __call = function() return stub_table(name) end,
    })
end
_G.Forbid, _G.Angle, _G.Dist = Forbid, Angle, Dist
-- ★ sin/cos/tan 是**角度制**（THlib/lib/Lapi.lua:110 `sin = lstg.sin`，
--   引擎的 legacy/DegreesMath.lua）。桩件原来给的是 math.sin（弧度），
--   于是「动画系数按弧度写」这种错在自检里完全看不见 —— 实机里全部慢几十倍。
_G.cos = function(t) return math.cos(math.rad(t or 0)) end
_G.sin = function(t) return math.sin(math.rad(t or 0)) end
_G.tan = function(t) return math.tan(math.rad(t or 0)) end
_G.max, _G.min = math.max, math.min
_G.abs, _G.sqrt, _G.int = math.abs, math.sqrt, math.floor
-- Lmath.lua 里的角度版三角函数（注意是大写）
_G.Cos = function(t) return math.cos(math.rad(t)) end
_G.Sin = function(t) return math.sin(math.rad(t)) end
_G.Tan = function(t) return math.tan(math.rad(t)) end
_G.hypot = function(x, y) return math.sqrt(x * x + y * y) end
_G.sign = function(x) if x > 0 then return 1 elseif x < 0 then return -1 else return 0 end end

_G.CREATED_BULLETS = 0
_G.CREATED_OBJECTS = 0
-- 诊断用：卡结束之后到底是谁在造东西
_G.LOG_NEW, _G.LOG_BULLET = {}, {}
local _styleNames = {}      -- bulletStyle 表 → 名字
-- 自机判定半径 = **自机半宽 + 弹半宽**，不是拍脑袋的 4。
--   引擎的碰撞是「两个椭圆求交」（GameObjectIntersectDetect.cpp），两边都用各自贴图登记的
--   a/b：自机在 THlib/player/*/[自机].lua 里写 A/B（灵梦 0.5、魔理沙/文 1），
--   弹在 THlib/bullet/bulletStyle.lua 的 LoadImageGroup 里带 a,b（ball_mid/knife 4、ellipse 4.5）。
--   所以实际间隙 ≈ 0.75 + 4.25 ≈ 5 px，比 4 大一档。
local HIT_R = 5
-- 「挪开」需要多久：人类反应 ≈15 帧，再横移出判定圈（自机半径 + 弹半径 ≈8 px，4 px/帧）≈2 帧。
-- 出膛到命中少于这个帧数，玩家根本没时间动 —— 那不是自机狙，是**必中**。
_G.SPAWN_REACT = 20
-- ★ 精确自机狙：出膛那一刻，弹道会在**未来某个时刻**打到自机**现在所在的位置**，
--   而且**留足了挪开的时间**。这类弹你「该挪开」，把它计进「被打频率」
--   等于用同义反复刷分 —— 玩家对自机狙的应对本来就是挪开，它不反映这张卡密不密。
--
-- ★★ 但前提是**来得及挪**。出膛到命中只剩几帧的「贴脸狙」不能算自机狙：
--   挪开需要 反应(≈15帧) + 横移出判定圈(≈2帧)，来不及就是**必中**，
--   必中当然是难度。所以贴脸狙**照常计入被打频率**，并且单独报出来当设计缺陷看。
--   （th04 卡 2 的 boss 停在 BOSS_Y=160、自机活动带 0~186 —— boss 骑在自机脸上，
--    7 路自机狙全是贴脸打的，这类卡要先修 boss 站位，不是修统计。）
--
--   判据在**出膛那一刻**做（之后不再改）：一发朝你 30 帧前的位置飞来的弹，
--   早就不是自机狙了，但按出膛意图算，它本来也是「该挪开」的那一发。
--
--   ⚠ 判据必须**按时间**，不能按角度、更不能按「出膛点离自机多远」：
--     · 按角度（|出膛角 − 指向自机的角| < 3°）在远处会放宽成十几 px 的偏差，
--       贴脸时角度又抖得没有意义；
--     · 「出膛点离自机 < 40 px 就不判」这种距离门槛更糟 —— 它会把贴脸那批
--       **整批**漏掉，而贴脸恰好是最该看见的那一批。
--     · 正确做法：解最近点 t* = −(r·v)/(v·v)。t* > 0 才是「飞向自机」（而不是飞离），
--       再看最近点落不落在判定圈内。全程只看时间 + 最近点，出膛点在哪都无所谓。
_G.aimed_bullets, _G.pointblank_bullets = 0, 0
-- 最糟的一次贴脸：出膛距离 / 弹速，用来看该动「限位」还是「弹速」
_G.pb_t, _G.pb_d, _G.pb_v = 1e9, 0, 0
-- 出膛到命中最短的帧数（诊断用：看这张卡到底有没有「贴脸」）
_G.min_aim_t = 1e9
local function markAimed(b, x, y, vx, vy, aimflag)
    if aimflag then
        b._aimed = true
        _G.aimed_bullets = _G.aimed_bullets + 1
        return
    end
    local sp2 = vx * vx + vy * vy
    if sp2 < 1e-9 then
        return                      -- 出膛速度 0（stay 弹），「飞向谁」没有意义
    end
    -- r = 出膛点相对自机的位移。最近点 t* = −(r·v)/(v·v)：
    -- 飞向自机时 r 和 v 反向 → r·v < 0 → t* > 0。
    -- ⚠ 符号别写反：用「自机 − 出膛点」的话 t* 会整批变成负数，
    -- 每发弹都被判成「在飞离自机」，自机狙一个都标不出来。
    local rx, ry = x - player.x, y - player.y
    local t = -(rx * vx + ry * vy) / sp2
    if t <= 0 then
        return                      -- 最近点在过去 → 这发是在飞离自机
    end
    local cx, cy = rx + vx * t, ry + vy * t     -- 最近点相对自机的位置
    if cx * cx + cy * cy > HIT_R * HIT_R then
        return                      -- 打不到自机，是散弹
    end
    if t <= _G.SPAWN_REACT then
        -- 贴脸：从出膛到命中只有几帧，玩家来不及挪 → 必中，算难度
        b._pointblank = true
        _G.pointblank_bullets = _G.pointblank_bullets + 1
        if t < _G.pb_t then
            _G.pb_t = t
            _G.pb_d = math.sqrt(rx * rx + ry * ry)   -- 出膛点离自机多远
            _G.pb_v = math.sqrt(sp2)                 -- 这一发多快
        end
    else
        b._aimed = true
        _G.aimed_bullets = _G.aimed_bullets + 1
    end
    if t < _G.min_aim_t then _G.min_aim_t = t end
end
local function classKey(c)
    for ek, ev in pairs(_editor_class) do
        if type(ev) == "table" then
            for kk, vv in pairs(ev) do
                if vv == c then return ek .. "." .. tostring(kk) end
            end
        end
    end
    return "(匿名类)"
end
_G.NewSimpleBullet = function(style, col, x, y, v, a, aim, omiga, stay, destroyable)
    -- ★ style 必须是**弹样式对象**（ball_mid / knife / ellipse …），不是字符串。
    --   `bullet.init` 里有 `self.class = imgclass`，引擎要求 class 是 luastg 对象类，
    --   传字符串会在**实机**里当场抛 "invalid argument for property 'class'" ——
    --   而桩件原来什么都收，所以静态自检放行了。这类错必须在这儿拦下来。
    if type(style) == "string" then
        error(("NewSimpleBullet 的 style 是字符串 %q —— 要传弹样式对象（%s），见 AGENTS.md §5.2")
                :format(style, style), 2)
    end
    _G.CREATED_BULLETS = _G.CREATED_BULLETS + 1
    do
        local nm = _styleNames[style] or "(弹样式)"
        _G.LOG_BULLET[nm] = (_G.LOG_BULLET[nm] or 0) + 1
    end
    local av = math.rad(a or 0)
    local b = { x = x, y = y, rot = a or 0,
                vx = (v or 0) * math.cos(av), vy = (v or 0) * math.sin(av),
                _index = Forbid(col or 1, 1, 16), timer = 0, ani = 0,
                group = 1, _live = true, bound = true, style = style }
    markAimed(b, x, y, b.vx, b.vy, aim)
    bullets[#bullets + 1] = b
    return b
end

_G.SetImageState = function() end
_G.Render = function() end
_G.RenderRect = function() end
_G.Render4V = function() end
_G.PlaySound = function() end
_G.Newcharge_in = function() end
_G.Newcharge_out = function() end
_G.ToBigScreen = function() end
_G.DefaultRenderFunc = function() end
_G.SetViewMode = function() end

-- 引擎里 status='del' 之后，manager 会回调该对象的 del（LuaBinding/modern/GameObject.cpp
-- 的 onQueueToDestroy）。桩件必须照做，否则「卡结束了但派生的东西没被清掉」这类 bug 测不出来。
local function rawdel(o)
    if o == nil or o._queued then return end
    o._queued = true
    if o.del then pcall(o.del, o) end
    o._live = false
end
---Connect / KillServants 也要照引擎实现，否则「挂到 boss 名下的东西会不会
---随卡片结束被清掉」这条链等于没测（refresh(1) 里就有一句 KillServants）。
local function connects(master, servant, dmg_transfer, con_death)
    if not master or not servant then return end
    servant._master = master
    servant._dmg_transfer = dmg_transfer
    if con_death ~= false then
        master._servants = master._servants or {}
        master._servants[#master._servants + 1] = servant
    end
end
local function killServants(master)
    local sv = master and master._servants
    if not sv then return end
    for i = 1, #sv do rawdel(sv[i]) end
    master._servants = {}
end

_G.object = { RawDel = rawdel, Del = rawdel,
              Kill = rawdel, Connect = connects,
              KillServants = killServants, DelServants = killServants,
              Preserve = function() end,
              BulletDo = function(fn)
                  for i = 1, #bullets do
                      if bullets[i]._live ~= false then fn(bullets[i]) end
                  end
              end,
              IndesDo = function() end }
-- ★ 桩件的 bullet.init 必须照引擎写：**真实弹的 group / colli 是在这里赋的**
--   （THlib/bullet/bullet.lua:85 `self.group = destroyable and 1 or 5`，隔壁一行 `self.colli = true`）。
--   写成空函数的话，用 `Class(bullet, ...)` 造的自定义弹**根本没有 group**，
--   于是不满足 each_threat 的 `group == 1/2/5`，整层威胁被无声漏掉 ——
--   th04 卡 2 的樱花花瓣（th04_petal）就是这么被漏成「被打频率 0」的。
_G.bullet = {
    init = function(self, imgclass, index, stay, destroyable, fogtime)
        self.imgclass, self.stay = imgclass, stay
        self.group = destroyable and 1 or 5
        self.colli = true
        self._index = index
        self.fogtime = fogtime or 11
    end,
    frame = function() end,
    render = function() end,
}
-- 激光：真实 init 里写 `self.group = GROUP.LASER`(10)。
--   但 each_threat 只认 1/2/5 —— 激光是**线段**不是点，
--   拿激光原点的坐标去跑「点弹命中预测」会算出垃圾，所以这里故意不收。
--   （th04 不用激光；th01 用了，那几张卡的激光威胁不在统计里，属于已知局限。）
_G.laser = {
    init = function(self) self.group = _G.GROUP.LASER self.colli = true end,
    frame = function() end, render = function() end,
}
_G._SC_BG = { init = function() end, frame = function() end, render = function() end,
              AddLayer = function(self) self.layers = self.layers or {} end }
_G.GROUP = { GHOST = 0, ENEMY_BULLET = 1, ENEMY = 2, PLAYER_BULLET = 3, PLAYER = 4,
             INDES = 5, ITEM = 6, NONTJT = 7, SPELL = 8, LASER = 10, ENEMY_BULLET2 = 12 }
_G.LAYER = { BG = -700, ENEMY = -600, PLAYER_BULLET = -500, PLAYER = -400,
             ITEM = -300, ENEMY_BULLET = -200, ENEMY_BULLET_EF = -100, TOP = 0 }
_G.COLOR = { DEEP_RED = 1, RED = 2, DEEP_PURPLE = 3, PURPLE = 4, DEEP_BLUE = 5, BLUE = 6,
             ROYAL_BLUE = 7, CYAN = 8, DEEP_GREEN = 9, GREEN = 10, CHARTREUSE = 11,
             YELLOW = 12, GOLDEN_YELLOW = 13, ORANGE = 14, DEEP_GRAY = 15, GRAY = 16 }
_G.VALUE_SET = { NORMAL = 0, ACCEL = 1, DECEL = 2, ACC_DEC = 3, OVER = 4, SIN_DEC = 5, SIN_ACC = 6 }
_G.lstg = { world = { l = -192, r = 192, b = -224, t = 224,
                      boundl = -224, boundr = 224, boundb = -256, boundt = 256,
                      pl = -192, pr = 192, pb = -224, pt = 224 },
            tmpvar = {}, var = {}, view3d = { eye = {0,0,0}, at = {0,0,0}, up = {0,1,0} } }
_G.player = { x = 0, y = 0, name = "Reimu" }
_G.player_list = { { "Reimu", 1 } }
-- ★ 随机数桩件必须是**真的随机**。
--   原来写成 `Float = function(self, a, b) return (a or 0) end` —— 返回下界，
--   于是关卡里每一处 `ran:Float(...)` 都退化成常量，所有「随机撒开」的弹幕
--   全挤在同一个位置。th04 卡 2 的花瓣是 `ran:Float(w.l, w.r)`（x 撒满整屏），
--   桩件下 153 片全落在 x=-192 那一列 —— 整张卡量出来「空得离谱」，
--   而实机是满满一屏花瓣。**这类误差不会报错，只会让读数安静地错掉。**
--   用固定种子的 32 位 LCG：可复现（每次跑同一张卡结果一样），
--   且不用 math.random（LuaJIT 的种子随启动变，会毁掉可复现性）。
local _rs = 20260915
local function _rand()
    _rs = (_rs * 1664525 + 1013904223) % 4294967296
    return _rs / 4294967296
end
_G.ran = {
    Float = function(self, a, b)
        a, b = a or 0, b or 0
        return a + (b - a) * _rand()
    end,
    Int = function(self, a, b)
        a, b = a or 0, b or 0
        if b < a then a, b = b, a end
        local v = math.floor(a + (b - a + 1) * _rand())
        return v > b and b or v
    end,
    Sign = function(self) return _rand() < 0.5 and -1 or 1 end,
}
_G.sp = {
    math = { AngleIterator = function(a) return function() return nil end end },
    CopyTable = function(_, t) return t end,
    TweakValue = function(_, v, max, min) return v end,
    GetListSection = function(_, t) return t, 1 end,
    UnitListAppend = function() end,
    UnitListUpdate = function() end,
}
_G.STAGE_COUNT = 23
_G.scoredata = { UnlockSC = {}, stage_practice = {} }
_G.spell_card_data = {}

local function New(class, ...)
    _G.CREATED_OBJECTS = _G.CREATED_OBJECTS + 1
    do
        local nm = classKey(class)
        _G.LOG_NEW[nm] = (_G.LOG_NEW[nm] or 0) + 1
    end
    local o = setmetatable({}, { __index = class })
    o.class = class
    o.timer, o.ani = 0, 0
    o.hscale, o.vscale = 1, 1
    o.x, o.y, o.rot = 0, 0, 0
    o._live = true
    objects[#objects + 1] = o
    if o.init then o.init(o, ...) end
    return o
end
_G.New = New
_G.IsValid = function(o) return o ~= nil and o._live ~= false end
_G.Del = function(o) if o then o._live = false end end
_G.Kill = function(o) if o then o._live = false end end

local task = {}
_G.task = task
task.New = function(obj, fn)
    local co = coroutine.create(fn)
    tasks[#tasks + 1] = { co = co, obj = obj, wait = 0 }
    return co
end
task.Wait = function(n) coroutine.yield(math.max(0, math.floor(n or 1))) end
task.Wait2 = task.Wait
task.GetSelf = function() return current_task and current_task.obj or nil end
task.Do = function() end
---照引擎实现：清掉挂在某个对象名下的所有协程。
---（boss_system:refresh(1) 在换卡时会 task.Clear(boss)，所以挂在 boss 上的
--- while true 循环不需要卡片自己清。桩件不模拟这一步的话会误报。）
task.Clear = function(obj)
    if obj == nil then return end
    for i = #tasks, 1, -1 do
        if tasks[i].obj == obj then table.remove(tasks, i) end
    end
end
task.init_left_wait = function() end
task.MoveTo = function(x, y, t)
    local o = task.GetSelf()
    if o then o.x, o.y = x, y end
    if t and t > 0 then coroutine.yield(t) end
end
task.MoveToPlayer = task.MoveTo
task.CRMoveTo = function(t, mode, ...)
    local o, a = task.GetSelf(), { ... }
    if o and #a >= 2 then o.x, o.y = a[#a - 1], a[#a] end
    if t and t > 0 then coroutine.yield(t) end
end
task.BezierMoveTo = task.CRMoveTo
task.MoveToEx = task.MoveTo

_editor_class = {}
_editor_boss = {}
_G._editor_class, _G._editor_boss = _editor_class, _editor_boss

----------------------------------------------------------------------
-- 1b. 项目里用到的其余引擎 API
--     （这份清单是拿 tools/check_stage.lua 跑遍 mod/GAME/th*.lua 收集出来的，
--       有了它们才能关掉「什么都当桩」的兜底，好让打错的 API 名真的报错）
----------------------------------------------------------------------

local function make_stub(name)
    return setmetatable({}, {
        __index = function(_, k)
            if type(k) == "string" then return make_stub(name .. "." .. k) end
        end,
        __call = function() return make_stub(name) end,
    })
end

-- 弹样式：本桩件不渲染，只要能被调用 / 取字段
local function styleStub(size)
    return { size = size or 1,
             init = function() end, del = function() end, frame = function() end,
             render = function() end,
             New = function(_, x, y)
                 return _G.NewSimpleBullet(_G.ball_mid, 1, x or 0, y or 0, 0, 0)
             end,
             SetColorFunc = function() end, RenderFunc = function() end }
end
for _, n in ipairs({ "arrow_big", "arrow_big_b", "arrow_big_c", "arrow_mid", "arrow_small",
                     "ball_small", "ball_mid", "ball_mid_c", "ball_big", "ball_huge", "ball_light",
                     "grain_a", "grain_b", "grain_c", "grain_d", "butterfly", "ellipse",
                     "knife", "knife_b", "square", "star_small", "star_big", "heart", "diamond",
                     "silence", "music", "water_drop", "money", "money_big", "gun_bullet",
                     "mildew", "flower2", "sakura", "sakura_big" }) do
    _G[n] = styleStub()
    _styleNames[_G[n]] = n
end

local function setv(o, v, a, rot)
    o.vx = (v or 0) * math.cos(math.rad(a or 0))
    o.vy = (v or 0) * math.sin(math.rad(a or 0))
    if rot then o.rot = a end
end
local function getv(o)
    return math.sqrt((o.vx or 0) ^ 2 + (o.vy or 0) ^ 2),
            math.deg(math.atan2(o.vy or 0, o.vx or 0))
end
_G.SetV, _G.GetV = setv, getv
local O = _G.object
O.SetV, O.GetV = setv, getv
O.SetA = function() end
O.SetG = function() end
O.ForbidV = function() end
O.StopMoving = function(o) o.vx, o.vy = 0, 0 end
O.ChangingV = function() end
O.ChangingA = function() end
O.ChangingVA = function() end
O.SetRelPos = function() end
O.SetSize = function() end
O.SetColli = function() end
O.SetSizeColli = function() end
O.SetGroup = function(o, g) o.group = g end
O.SetLayer = function(o, l) o.layer = l end
-- ★ 拖影（残影）：**照 THlib/lib/LObjectEvents.lua:221 抄，不能写成空函数**。
--   写成空函数的话，「忘了设 self.img」这种错就永远查不出来 ——
--   真机上 `SetImageState(nil, ...)` 是直接崩的，而自检会全绿，所以在这里查。
--   同时统计**所有对象拖影条数之和的峰值**：拖影忘了 `smear_frame` 衰减的话
--   会无限涨，那和「峰值对象线性增长」是同一类漏，看这个数最快。
_G.SMEAR_TOTAL = 0
local function smear_track(self)
    if self.smear then
        _G.SMEAR_TOTAL = _G.SMEAR_TOTAL + #self.smear
    end
end
O.smear_add = function(self, alpha)
    if self.img == nil then
        error("smear_add 时 self.img 是 nil —— 要先把贴图名存下来（`self.img = self.__img`）", 2)
    end
    if not self.smear then
        self.smear = {}
    end
    table.insert(self.smear, { x = self.x, y = self.y, rot = self.rot, alpha = alpha,
                               img = self.img, hscale = self.hscale, vscale = self.vscale })
end
O.smear_frame = function(self, dealpha)
    if self.smear then
        for i = #self.smear, 1, -1 do
            local s = self.smear[i]
            s.alpha = math.max(s.alpha - dealpha, 0)
            if s.alpha == 0 then
                table.remove(self.smear, i)
            end
        end
        -- 只在这里统计（add 和 frame 每帧都各调一次，两边都算会翻倍）
        smear_track(self)
    end
end
O.smear_render = function(self, mode, color)
    if self.smear then
        for _, s in ipairs(self.smear) do
            _G.SetImageState(s.img, mode, s.alpha, color[1], color[2], color[3])
            _G.Render(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
        end
    end
end
O.ReBound = function() end
O.Shuttle = function() end
_G.bullet.ReBound = function() end
_G.bullet.Shuttle = function() end
_G.bullet.SetLayer = function() end
_G.bullet.ChangeImage = function() end
_G.bullet.GetNavi = function() return true end
_G.bullet.RemoveFog = function() end
_G.bullet.RestartFog = function() end

-- _object：misc.lua 里那个带 set_color 的对象基类
_G._object = Class(O, {
    init = function(self, img, x, y)
        self.img = img
        self.x, self.y = x or 0, y or 0
        self._blend, self._a, self._r, self._g, self._b = "", 255, 255, 255, 255
    end,
    frame = function() end,
    render = function() end,
    del = function() end,
    set_color = function(self, blend, a, r, g, b)
        self._blend, self._a = blend or "", a or 255
        self._r, self._g, self._b = r or 255, g or 255, b or 255
    end,
})
O.set_color = _G._object.set_color

-- 激光。两种 init 的参数顺序不一样，宽度都要接住：
--   laser:init(index, x, y, rot, l1, l2, l3, w, node, head)   -> w 是第 8 个
--   bent :init(index, x, y, l, w, sample, node)               -> w 是第 5 个
local function laserStub() return Class(O, {
    init = function(self, index, x, y, a4, a5, a6, a7, a8)
        self.index = index
        self.x, self.y, self.rot = x or 0, y or 0, 0
        self.w = a8 or a5 or 0
        self.w0 = self.w
        self.alpha, self.counter, self.da, self.dw = 0, 0, 0, 0
        self.l1, self.l2, self.l3 = a5 or 0, a6 or 0, a7 or 0
        self.bound = true
    end,
    frame = function() end, render = function() end, del = function() end, kill = function() end,
    setWidth = function(self, w) self.w, self.w0 = w, w end, ChangeImage = function() end,
    _TurnOn = function() end, _TurnOff = function() end, _TurnHalfOn = function() end,
    CyGrow = function() end, CutOnRadius = function() return 0, 0 end, CutOnUnit = function() end,
}) end
_G.bent_laser = laserStub()
_G.WideLaser = laserStub()
local L = _G.laser
for _, k in ipairs({ "_TurnOn", "_TurnOff", "_TurnHalfOn", "CyGrow", "ChangeImage",
                     "CutOnUnit", "setWidth", "RemoveFog" }) do
    L[k] = function() end
end
L.CutOnRadius = function() return 0, 0 end

-- 杂项类
_G.enemy = Class(O, { init = function(self, hp, drop, ...) self.hp = hp or 1 end,
                      frame = function() end, render = function() end })
_G.enemybase = _G.enemy
for _, n in ipairs({ "bullet_cleaner", "charge_out", "SmearScreen", "SimpleServant",
                     "_death_ef_tb", "_enemy_aura_tb", "WhiteScreen" }) do
    _G[n] = Class(O, { init = function() end, frame = function() end,
                       render = function() end, del = function() end })
end
_G.NewObject = function() return {} end
_G.NewSimpleServant = function() return New(_G.SimpleServant) end

-- 行走图系统：真身是 plus.Class 造的，既能当类用也能直接「构造」调用
-- （th095 就是 BossWalkImageSystemRotate(self)），所以给个可调用空壳
local function constructibleStub(name)
    return setmetatable({}, {
        __index = function(_, k) return make_stub(name .. "." .. tostring(k)) end,
        __call = function() return make_stub(name .. "()") end,
    })
end
_G.BossWalkImageSystem = constructibleStub("BossWalkImageSystem")
_G.BossWalkImageSystemRotate = constructibleStub("BossWalkImageSystemRotate")

-- background（关卡背景 / 符卡背景的基类）
_G.background = Class(O, {
    init = function(self, sc) self.group, self.layer, self.alpha = 0, -700, 1 end,
    frame = function() end, render = function() end,
    RanFloat = function(_, a) return a end,
    RanInt = function(_, a) return math.floor(a) end,
    RanSign = function() return 1 end,
    Create = function() return New(_G.background) end,
    DelBG = function() end, Capture = function() end, ClearToFogColor = function() end,
})

-- 其余零散的引擎函数与表
_G.Create = setmetatable({}, { __index = function()
    return function(x, y)
        return _G.NewSimpleBullet(_G.ball_mid, 1, x or 0, y or 0, 0, 0)
    end
end })
_G.ext = setmetatable({}, { __index = function(_, k) return make_stub("ext." .. tostring(k)) end })
_G.stage = setmetatable({}, { __index = function(_, k) return make_stub("stage." .. tostring(k)) end })
_G.misc = setmetatable({}, { __index = function() return function() end end })
_G.item = { obj = setmetatable({}, { __index = function() return {} end }),
            Dropitem = function() end, Dropitem_PFP = function() end, _init_item = function() end }
_G.WANDER_MODE = { TO_PLAYER = 0, TO_PLAYER_X = 1, TO_PLAYER_Y = 2, RANDOM = 3 }
_G._infinite = 4294967296
_G.CollisionCheck = function() end
_G.CreateRenderTarget = function() end
_G.PlayMusic = function() end
_G.StopMusic = function() end
_G.SetBGMVolume = function() end
_G.LoadMusic = function() end
_G.LoadAnimation = function() end
_G.LoadImage = function() end
_G.LoadImageGroup = function() end
_G.LoadImageGroupFromFile = function() end
_G.LoadImageFromFile = function() end
_G.LoadImageFromFile2 = function() end
_G.LoadTexture = function() end
_G.LoadTexture2 = function() end
_G.LoadFont = function() end
_G.LoadFX = function() end
_G.LoadAniFromFile = function() end
_G.SetImageCenter = function() end
_G.SetImageScale = function() end
_G.SetTextureSamplerState = function() end
_G.Color = function(a, r, g, b)
    return setmetatable({}, { __index = function() return function() return 255 end end })
end
_G.global_obj = setmetatable({}, { __index = function() return make_stub("global_obj") end })
_G.DoFile = function() end
_G.IncludeLuaFile = function() end   -- 真身会把文件塞进 LoadRes 延后载；这里由 --all 显式点名
_G.Include = function() end
_G.ObjList = function() return {} end
_G.boss_group = {}
_G.LoadRes = {}          -- THlib.lua 里定义；_editor_output.lua 会往里面塞延后载入的任务
_G.musicList = {}
_G.musicBarList = {}
_G.AchievementInfo = {}
_G.SearchStageLevel = {}  -- Lstage.lua 里建的，按关卡号索引
_G.SQRT2 = math.sqrt(2)
_G.SQRT2_2 = _G.SQRT2 / 2
_G.FileExist = function() return false end
_G.CheckRes = function() return false end
_G.Set3D = function() end
_G.RenderTexture = function() end
_G.SaveSpellCardData = function() end
_G.SaveScoreData = function() end
_G.InitSpellCardData = function() end
_G.InitScoreData = function() end
_G.InitAllClass = function() end

-- 兜底：还是没桩件的全局
--   · THxx_bg / SCBG* —— 关卡背景类，给个空表就够（它只被当作参数传来传去）
--   · 其它 —— 记下来；permissive 模式给个「什么都能干」的空壳，
--     严格模式返回 nil（这样才能把打错的 API 名当错误报出来）
local missing = {}
local permissive = os.getenv("STAGE_PERMISSIVE") == "1"
setmetatable(_G, { __index = function(_, k)
    if type(k) ~= "string" then return nil end
    if k:match("_bg$") or k:match("^SCBG") then return {} end
    missing[k] = (missing[k] or 0) + 1
    if permissive then return make_stub(k) end
    return nil
end })
_G.__report_missing = function()
    local names = {}
    for k in pairs(missing) do names[#names+1] = k end
    table.sort(names)
    return names
end

local registered = {}
_G.boss = {
    Define = function(editname, name, BGM, BG, xy, SCBG, img, level, scale)
        -- 注意 SCBG 允许为 nil（原版 th11 就是这样），所以只检查背景类
        if BG == nil then fail(("boss.Define(%s): 背景类为 nil —— 是不是忘了先载入 mod/BG/THxx/THxx_bg.lua？"):format(editname)) end
        if type(img) ~= "string" then fail(("boss.Define(%s): 行走图名不是字符串"):format(editname)) end
        _editor_boss[editname .. level] = Class(boss, {
            cards = {}, name = name, StageLevel = level, bgm = BGM, _bg = BG,
            difficulty = "All", id = editname .. level, img = img,
            init = function() end,
        })
    end,
    DefineGroup = function(index, group, BGM, BG, SCBG, level)
        for _, b in ipairs(index) do
            _editor_boss[group .. b.id .. level] = Class(boss, {
                cards = {}, name = b.name, StageLevel = level, bgm = BGM,
                _bg = BG, difficulty = "All", id = group .. b.id .. level,
                img = b.img, init = function() end,
            })
        end
    end,
    Create = function(n) return _editor_boss[n] end,
    CreateGroup = function() end,
    -- boss 上那几个常在符卡里用的方法
    cast = function() end,
    violent = function() end,
    show_aura = function() end,
    SetUIDisplay = function() end,
    card = {},
}
-- Card 上除了 New/add 之外还会被用到的几个
boss.ns_group = { init = function() end, del = function() end, nextcard = function() end }
boss.card.ns_group = boss.ns_group
boss.card.PublicHP = function() end
boss.card.UnlockOD = function() end
boss.card.addRunEvent = function() end
boss.card.GetCardNums = function() return 0 end

-- 和真实的 Card.New 一样补默认值（不填就是 60 秒的时非），
-- 所以「不传参数」是合法用法，不能当成错误
boss.card.New = function(name, t1, t2, t3, hp, drop, is_extra)
    name = name or ""
    t1, t2, t3 = t1 or 60, t2 or 60, t3 or 60
    if t1 > t2 or t2 > t3 then
        fail(("Card.New(%q): 必须 t1<=t2<=t3（单位是秒），实际 %s/%s/%s")
                :format(tostring(name), tostring(t1), tostring(t2), tostring(t3)))
    end
    return { name = tostring(name), t1 = t1, t2 = t2, t3 = t3, hp = hp or 600,
             is_sc = (name ~= "") }
end
-- 复用了同一个 card_id 的卡（正常情况：同一组里的双 boss 共用一张符卡）
local global_ids = {}
boss.card.add = function(sc_group, level, CardName, data_id, OD, inotherstage)
    if type(sc_group) ~= "table" or #sc_group < 1 then fail("Card.add: sc_group 为空") return end
    -- 同一次 add 里多张卡共用 data_id 是正常的（双 boss 同一张符卡）；
    -- 只有「跨组」重复才会让 spell_card_data 串掉
    local in_this_call = false
    for _, u in ipairs(sc_group) do
        local card, bossid = u[1], u[2]
        local key = tostring(bossid) .. tostring(level)
        if _editor_boss[key] == nil then
            fail(("Card.add(%q): 找不到 boss %q（level=%s）—— Define 和 add 的 level 对不上？")
                    :format(tostring(CardName), key, tostring(level)))
        end
        card.card_id = data_id
        if not in_this_call then
            in_this_call = true
            if global_ids[data_id] then
                fail(("card_id 跨组重复：%s（spell_card_data 会串）"):format(tostring(data_id)))
            end
            global_ids[data_id] = true
        end
        registered[#registered + 1] = { name = CardName, card = card, level = level,
                                        card_id = data_id, bosskey = key }
    end
end

----------------------------------------------------------------------
-- 2. 调度
----------------------------------------------------------------------
local function step_tasks()
    for i = #tasks, 1, -1 do
        local t = tasks[i]
        if t.wait > 0 then
            t.wait = t.wait - 1
        elseif coroutine.status(t.co) == "dead" then
            table.remove(tasks, i)
        else
            current_task = t
            local ok, delay = coroutine.resume(t.co)
            current_task = nil
            if not ok then error("task 里报错: " .. tostring(delay), 0) end
            if coroutine.status(t.co) == "dead" then
                table.remove(tasks, i)
            else
                t.wait = delay or 0
            end
        end
    end
end

local function step_objects()
    local n = #objects
    for i = 1, n do
        local o = objects[i]
        if o._live ~= false then
            o.timer = o.timer + 1
            o.ani = o.ani + 1
            -- 引擎每帧会替所有对象积分速度与自转（不是只有 bullet 才走）
            o.x = o.x + (o.vx or 0)
            o.y = o.y + (o.vy or 0)
            o.rot = o.rot + (o.omiga or 0)
        end
    end
    for i = 1, n do
        local o = objects[i]
        if o._live ~= false and o.frame then o.frame(o) end
    end
    for i = #objects, 1, -1 do
        local o = objects[i]
        if o._live == false then
            table.remove(objects, i)
        elseif o.bound ~= false
                and (o.x < -224 or o.x > 224 or o.y < -256 or o.y > 256) then
            -- bound 在引擎里的默认值是 true（「离开边界自动回收」），
            -- 所以没显式关掉它的自绘物件飞出边界也会被收掉
            table.remove(objects, i)
        end
    end
    -- 模拟引擎的位移积分与「离开边界自动回收」（bound = true 的弹）
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b._live == false then
            table.remove(bullets, i)
        else
            b.x = b.x + b.vx
            b.y = b.y + b.vy
            b.timer = b.timer + 1
            if b.bound and (b.x < -224 or b.x > 224 or b.y < -256 or b.y > 256) then
                table.remove(bullets, i)
            end
        end
    end
end

local function drain(fn, obj)
    local co = coroutine.create(fn)
    -- 第一次 resume 之前就要设好 current_task，否则 before() 里的
    -- task.MoveTo 找不到 self（引擎里 before 跑在 task.New(b, ...) 里）
    current_task = { co = co, obj = obj }
    local ok, err = coroutine.resume(co)
    current_task = nil
    if not ok then error(err, 0) end
    local guard = 0
    while coroutine.status(co) ~= "dead" do
        guard = guard + 1
        if guard > 20000 then error("task 跑不完", 0) end
        step_tasks()
        current_task = { co = co, obj = obj }
        local ok2, err2 = coroutine.resume(co)
        current_task = nil
        if not ok2 then error(err2, 0) end
    end
end

----------------------------------------------------------------------
-- 4. 全项目载入模式：按引擎的载入顺序把每个关卡文件过一遍
--    （有些文件依赖别的文件里的类，比如 th08-boss_lastword 要用 _editor_class.TH08，
--      单跑一个文件会误报，这个模式才是它们正确的检查方式）
----------------------------------------------------------------------
if path == "--all" then
    local ids = {}
    local f = io.open("mod/_editor_output.lua")
    if f then
        local s = f:read("*a")
        f:close()
        local block = s:match("StageID = {(.-)}")
        -- 列表里混着单引号（'08'），所以两种引号都要认
        for w in (block or ""):gmatch("[\"']([^\"']+)[\"']") do ids[#ids + 1] = w end
    end
    if #ids == 0 then
        print("FAIL: 没能从 mod/_editor_output.lua 里读出 StageID 列表（路径不对？在游戏根目录跑）")
        os.exit(1)
    end
    print(("=== 全项目载入（StageID 共 %d 关）==="):format(#ids))

    local function tryLoad(p)
        local fh = io.open(p)
        if not fh then return end          -- 文件不存在就跳过
        fh:close()
        local c, cerr = loadfile(p)
        if not c then
            fail(("%s: 语法错误 %s"):format(p, tostring(cerr)))
            return
        end
        local ok, err = pcall(c)
        if ok then
            print("  OK  " .. p)
        else
            fail(("%s -> %s"):format(p, tostring(err)))
        end
    end

    -- _editor_output.lua 要先载：全局的 global_obj / Create / WhiteScreen / _bullet
    -- 以及 _editor_class、_editor_boss 都在它里面建
    tryLoad("mod/_editor_output.lua")
    for _, id in ipairs(ids) do
        tryLoad("mod/BG/TH" .. id .. "/TH" .. id .. "_bg.lua")
        tryLoad("mod/GAME/th" .. id .. ".lua")
    end
    tryLoad("mod/main_stage.lua")
    tryLoad("mod/summary.lua")
    -- th16AEX 的 root.lua 是用 DoFile 逐个拉进来的，桩件里 DoFile 是空的，所以直接点名
    tryLoad("mod/th16AEX/bg.lua")
    tryLoad("mod/th16AEX/stage.lua")
    tryLoad("mod/th16AEX/class.lua")

    print("")
    local nb = 0
    for _ in pairs(_editor_boss) do nb = nb + 1 end
    print(("注册结果：boss %d 个 / 符卡 %d 张"):format(nb, #registered))
    local miss = __report_missing()
    if #miss > 0 then
        print("")
        print("以下全局没有真实桩件：")
        print("  " .. table.concat(miss, " "))
    end
    print("")
    if failures == 0 then
        print("通过：整个项目能按顺序载入，注册无误")
    else
        print(("有 %d 处不合格"):format(failures))
        os.exit(1)
    end
    os.exit(0)
end

----------------------------------------------------------------------
-- 5. 单文件模式
----------------------------------------------------------------------
print("=== 载入 " .. path .. " ===")
local chunk, cerr = loadfile(path)
if not chunk then
    print("FAIL: 语法错误 -> " .. tostring(cerr))
    os.exit(1)
end
local ok, err = pcall(chunk)
if not ok then
    print("FAIL: 载入就炸了 -> " .. tostring(err))
    os.exit(1)
end

if os.getenv("STAGE_MISSING") then
    print("缺少桩件的全局：" .. table.concat(__report_missing(), " "))
    os.exit(0)
end

print("=== boss ===")
local bkeys = {}
for k in pairs(_editor_boss) do bkeys[#bkeys + 1] = k end
table.sort(bkeys)
for _, k in ipairs(bkeys) do
    local b = _editor_boss[k]
    print(("  %-8s %-12s level=%-3s bgm=%-10s img=%s")
            :format(k, b.name or "?", tostring(b.StageLevel), tostring(b.bgm), tostring(b.img)))
end
if #bkeys == 0 then print("  （没有 boss.Define）") end

print("=== 符卡 ===")
for i, r in ipairs(registered) do
    print(("  %2d. id=%-4s lv=%-3s hp=%-5s %s / %s / %ss  %s")
            :format(i, tostring(r.card_id), tostring(r.level), tostring(r.card.hp),
                    r.card.t1, r.card.t2, r.card.t3, r.name))
end
if #registered == 0 then print("  （没有 boss.card.add）") end

----------------------------------------------------------------------
-- 威胁度量：把「自机周围到底有多少弹要同时处理」量出来
--   光数全屏弹数是没用的 —— 350 发全在屏幕另一头不等于难。
--   这里：① 让一个简易躲避机器人真的去躲；② 每帧按角度分 24 个扇区，
--   统计自机周围 60 px 内的弹数与「被堵死的方向数」。
----------------------------------------------------------------------
local THREAT = (arg[3] == "--threat") or os.getenv("STAGE_THREAT") == "1"
local THREAT_R, SECT = 60, 24        -- HIT_R 在上面（出膛判定也要用）
-- REACT：留给玩家「反应 + 移动」的帧数。TTH 掉到这个以内 = 现在必须动
-- HORIZON：预测多少帧以内；超过就算「暂时没威胁」
local REACT, HORIZON = 30, 90
-- Y_SPLIT：分区域统计用的分界（自机 y 高于它算「屏幕上方」）
local Y_SPLIT = 96
-- STAGE_HIGH=<y>：诊断用，把自机**强行压在 y 以上**，看「卡片在屏幕上方到底难不难」。
--   不设这个开关时机器人会自己挑好走的路（绕开难的地方），只看它的轨迹会低估难度。
local STAGE_HIGH = tonumber(os.getenv("STAGE_HIGH"))
-- STAGE_DUMP=<帧号>：诊断用，把那一帧**场上真正有什么**全部打出来
--   （有什么弹、在哪、多快）。用来分清「卡真的空」和「桩件漏了一层」。
local STAGE_DUMP = tonumber(os.getenv("STAGE_DUMP"))
-- HIT_HORIZON：「这个位置会被打到」的预测窗口（帧）。
--   窗口 = REACT(30) 时只剩「马上要死」，非自机狙那部分几乎是 0，分不出卡与卡的区别；
--   放宽到 90 帧（1.5 秒）才是「这片位置会不会被弹覆盖到」。
local HIT_HORIZON = 90

---遍历场上有判定的东西（弹 + 有碰撞的敌方 object）
---  判定依据是**引擎的碰撞组配对表**（THlib/ext/ext.lua:203-208）：
---    PLAYER 只和 { ENEMY_BULLET=1, ENEMY_BULLET2=12, ENEMY=2, INDES=5, LASER=10 } 碰。
---  NewSimpleBullet 造的弹一律收（它们在 bullets 里，组是 1 还是被卡改成 12 都无所谓）；
---  只有 `Class(object, ...)` 造的东西要看 group —— 引擎里那种对象的默认组是 0(GHOST)，
---  不在配对表里，**打不到自机**，所以不收（th04 的船、水、笼子都是这一类）。
---  唯一的例外是 LASER：它确实是 10，但激光是线段不是点，拿原点跑点弹预测会算出垃圾，
---  所以故意不收（已知局限，见 AGENTS.md §9）。
local function each_threat(fn)
    for i = 1, #bullets do
        local b = bullets[i]
        if b._live ~= false then fn(b) end
    end
    for i = 1, #objects do
        local o = objects[i]
        if o._live ~= false and o.colli ~= false
                and (o.group == 1 or o.group == 2 or o.group == 5 or o.group == 12) then
            fn(o)
        end
    end
end

---简易躲避机器人：被 60 px 内的弹斥开，60~180 px 的弹轻推，另外别贴边
local function bot_move()
    local fx, fy = 0, 0
    each_threat(function(t)
        local dx, dy = player.x - t.x, player.y - t.y
        local d2 = dx * dx + dy * dy
        if d2 < 1 then d2 = 1 end
        if d2 < THREAT_R * THREAT_R then
            fx = fx + dx / d2
            fy = fy + dy / d2
        elseif d2 < (THREAT_R * 3) ^ 2 then
            fx = fx + dx / d2 * 0.15
            fy = fy + dy / d2 * 0.15
        end
    end)
    -- 别贴边：**只在离边界 40 px 以内才推**。
    -- 之前写成「一直往屏幕中心吸」，权重比躲避还大 4 倍，
    -- 结果机器人根本不躲、就停在中心 —— 测出来的数字全是假的。
    local w = lstg.world
    local M = 40
    if player.x < w.l + M then fx = fx + (w.l + M - player.x) * 0.02 end
    if player.x > w.r - M then fx = fx + (w.r - M - player.x) * 0.02 end
    if player.y < w.b + M then fy = fy + (w.b + M - player.y) * 0.02 end
    if player.y > w.t - M then fy = fy + (w.t - M - player.y) * 0.02 end
    local m = math.sqrt(fx * fx + fy * fy)
    if m > 1e-9 then
        player.x = player.x + fx / m * 4
        player.y = player.y + fy / m * 4
    end
    -- 诊断：强行把自机压在某个高度以上，用来回答「屏幕上方到底难不难」
    if STAGE_HIGH and player.y < STAGE_HIGH then
        player.y = STAGE_HIGH
    end
end

---核心度量：**自机当前所在的位置，每秒会被打到多少次**。
---  不是数周围密度（一发朝你飞来的弹和一堆远处打转的弹密度一样），
---  也不是数「必须换位」的转换次数（那个只反映抖动，跟挨不挨打没关系）。
---  要的就是字面意思：**站在这个位置上，多久会被打中一次**。
---  每发弹用「上一帧位置差分」求速度，解析解出它什么时候会进入自机判定圈：
---    |p + v·k|² < r²  →  (v·v)k² + 2(p·v)k + (p·p - r²) < 0
---  取所有弹里最早的那个 = TTH（time to hit），TTH ≤ REACT 就是「会打到」。
---  每发弹只在**第一次**进入「会打到」时记一笔，避免同一发弹在窗口里被连记几十帧。
---dry = true 时只读不写：不动 _mx/_my 的前一帧缓存。
---   measure_frame 顺带把 t._mx/_my 更新成当前位置，作为下一帧求速度的差分基准；
---   同一帧里调用两次的话，第二次会因为基准刚被刷新而把每发弹的速度算成 0，
---   TTH 全变成「已经贴脸」—— 读数直接废掉。要额外偷看一次就用 dry。
local function measure_frame(prev_alert, dry)
    local tth = HORIZON + 1
    local n, used, alive, hits, aim_hits, pb_hits = 0, 0, 0, 0, 0, 0
    local sect = {}
    each_threat(function(t)
        alive = alive + 1
        -- 速度：上一帧位置差分（对 path 驱动的自绘弹也有效）
        local vx, vy = 0, 0
        if t._mx then
            vx, vy = t.x - t._mx, t.y - t._my
        end
        if not dry then
            t._mx, t._my = t.x, t.y
        end
        local px, py = t.x - player.x, t.y - player.y
        local d2 = px * px + py * py
        if d2 < THREAT_R * THREAT_R then
            n = n + 1
            local k = int(((math.deg(math.atan2(py, px)) + 360) % 360) / (360 / SECT)) + 1
            if k > SECT then k = SECT end
            sect[k] = true
        end
        -- 命中预测：这发弹多少帧后会打到自机**当前**的位置
        local bh = nil
        local a = vx * vx + vy * vy
        if a < 1e-9 then
            if d2 <= HIT_R * HIT_R then bh = 0 end
        else
            local b2 = 2 * (px * vx + py * vy)
            local c = d2 - HIT_R * HIT_R
            local disc = b2 * b2 - 4 * a * c
            if disc >= 0 then
                local sq = math.sqrt(disc)
                if (-b2 + sq) / (2 * a) >= 0 then       -- 未来会进圈
                    local k1 = (-b2 - sq) / (2 * a)
                    if k1 < 0 then k1 = 0 end
                    bh = k1
                end
            end
        end
        if bh then
            -- ★ 精确自机狙（留足了挪开时间的）不计入难度：它打中你是构造上的必然。
            --   贴脸狙（_pointblank）**算**难度 —— 来不及挪就是必中，必中就是难度。
            if t._aimed then
                if not dry and bh <= HIT_HORIZON and not t._aim_mark then
                    t._aim_mark = true
                    aim_hits = aim_hits + 1
                end
            else
                if bh < tth then tth = bh end
                -- 被打频率：这发弹会打到自机当前的位置，每发只记一次
                if not dry and bh <= HIT_HORIZON and not t._hit_mark then
                    t._hit_mark = true
                    hits = hits + 1
                    if t._pointblank then pb_hits = pb_hits + 1 end
                end
            end
        end
    end)
    for i = 1, SECT do if sect[i] then used = used + 1 end end
    -- 最大连续空隙
    local best, cur, besti, curi = 0, 0, 1, 1
    for i = 1, SECT * 2 do
        local j = (i - 1) % SECT + 1
        if not sect[j] then
            if cur == 0 then curi = i end
            cur = cur + 1
            if cur > best and cur <= SECT then best, besti = cur, curi end
        else
            cur = 0
        end
    end
    local center = ((besti - 1 + best * 0.5) % SECT) * (360 / SECT)
    local alert = tth <= REACT
    return tth, n, used, best, center, alert, alive, hits, aim_hits, pb_hits
end

---★ 安全角度范围：**往哪个方向跑能活**。
---
---  前面那些指标量的都是「站在原地会不会被打」；这一条量的是**能不能躲**。
---  对每个方向 θ（共 SECT 个），假设自机以 4 px/帧 一直朝 θ 跑，看会不会撞上任何一发弹：
---     相对位移 r = 弹 − 自机，相对速度 w = 4·(cosθ,sinθ) − v
---     最近点 t* = −(r·w)/(w·w)；t* > 0 且 |r + w·t*| ≤ HIT_R → 这个方向会撞死
---  一个安全方向都没有 = 这一帧是**死局**：不是难，是躲不掉。
---
---  ⚠ 这里**必须把自机狙算进去**。躲自机狙靠的就是垂直于弹道跑，
---    把狙剔掉之后「安全角度」会虚高 —— 看着到处都是路，其实正对着你的那发躲不开。
---    （自机狙被剔除只对「被打频率」成立：那个量的是「这个位置会不会被弹覆盖」。）
---  ⚠ 已知局限：没模拟「跑到边界会被挡住」。朝墙跑的方向按「继续跑」算，
---    所以贴边时安全角度会偏少。
local PLAYER_SPD = 4
local function measure_safe_angles(skip_aimed)
    local list = {}
    each_threat(function(t)
        if skip_aimed and t._aimed then return end
        local vx, vy = 0, 0
        if t._mx then
            vx, vy = t.x - t._mx, t.y - t._my
        else
            -- 刚出膛那一帧还没有差分基准，退回用出膛速度（桩件存了 vx/vy）
            vx, vy = t.vx or 0, t.vy or 0
        end
        list[#list + 1] = { t.x, t.y, vx, vy }
    end)
    local safe, nsafe = {}, 0
    for i = 1, SECT do
        local th = math.rad((i - 1) * 360 / SECT)
        local ux, uy = PLAYER_SPD * math.cos(th), PLAYER_SPD * math.sin(th)
        local ok = true
        for k = 1, #list do
            local b = list[k]
            local rx, ry = b[1] - player.x, b[2] - player.y
            local wx, wy = ux - b[3], uy - b[4]
            local w2 = wx * wx + wy * wy
            if w2 < 1e-9 then
                if rx * rx + ry * ry <= HIT_R * HIT_R then ok = false break end
            else
                local ts = -(rx * wx + ry * wy) / w2
                if ts > 0 and ts <= HORIZON then
                    local cx, cy = rx + wx * ts, ry + wy * ts
                    if cx * cx + cy * cy <= HIT_R * HIT_R then ok = false break end
                end
            end
        end
        if ok then
            safe[i] = true
            nsafe = nsafe + 1
        end
    end
    -- 最宽的一段连续安全角度，以及它的中心方向
    local best, cur, besti, curi = 0, 0, 1, 1
    for i = 1, SECT * 2 do
        local j = (i - 1) % SECT + 1
        if safe[j] then
            if cur == 0 then curi = i end
            cur = cur + 1
            if cur > best and cur <= SECT then best, besti = cur, curi end
        else
            cur = 0
        end
    end
    local center = ((besti - 1 + best * 0.5) % SECT) * (360 / SECT)
    return nsafe, best, center
end

---在**任意一点**上量「有多少发弹正朝这里飞来」（HIT_HORIZON 帧内会打中它）。
---  measure_frame 量的是自机**实际走过**的那条线；这条量的是**整个屏幕的难度场**。
---  差别很大：机器人绕开了难的地方，只看它走过的轨迹会得出「这张卡很松」。
local function measure_point(px, py)
    local hits = 0
    each_threat(function(t)
        local vx, vy = 0, 0
        if t._mx then
            vx, vy = t.x - t._mx, t.y - t._my
        else
            vx, vy = t.vx or 0, t.vy or 0
        end
        local rx, ry = t.x - px, t.y - py
        local a = vx * vx + vy * vy
        local bh
        if a < 1e-9 then
            if rx * rx + ry * ry <= HIT_R * HIT_R then bh = 0 end
        else
            local b2 = 2 * (rx * vx + ry * vy)
            local c = rx * rx + ry * ry - HIT_R * HIT_R
            local disc = b2 * b2 - 4 * a * c
            if disc >= 0 then
                local sq = math.sqrt(disc)
                if (-b2 + sq) / (2 * a) >= 0 then
                    local k1 = (-b2 - sq) / (2 * a)
                    if k1 < 0 then k1 = 0 end
                    bh = k1
                end
            end
        end
        if bh and bh <= HIT_HORIZON then hits = hits + 1 end
    end)
    return hits
end

---难度场：在自机**合法活动范围**里铺一张格子，逐格量「有多少发弹正朝这里飞来」。
---  自机跑得开的地方才是它真能待的地方，所以格子按 ±192/±224 铺。
local GRID_X = { -160, -80, 0, 80, 160 }
local GRID_Y = { -192, -96, 0, 96, 192 }
local function measure_field()
    local worst, best, sum, n = -1, 1e9, 0, 0
    local wy = 0
    for iy = 1, #GRID_Y do
        for ix = 1, #GRID_X do
            local v = measure_point(GRID_X[ix], GRID_Y[iy])
            sum = sum + v
            n = n + 1
            if v > worst then worst, wy = v, GRID_Y[iy] end
            if v < best then best = v end
        end
    end
    return worst, sum / n, wy
end


print("=== 逐卡模拟（每张 " .. FRAMES .. " 帧）===")
for idx, entry in ipairs(registered) do
    local card = entry.card
    objects, bullets, tasks = {}, {}, {}
    local boss_obj = {
        x = 0, y = 300, timer = 0, ani = 0, hscale = 1, vscale = 1,
        diff = "All", hp = 9999, _live = true, _sp_point_auto = {},
        StageLevel = entry.level,
    }
    boss_obj._bosssys = {
        addAutoSPPoint = function(_, hp) table.insert(boss_obj._sp_point_auto, hp) end,
        setStatus = function() end,
    }
    player.x, player.y = 0, 0

    local peak_obj, peak_bul = 0, 0
    local peak_smear = 0            -- 一帧里所有对象的拖影条数之和
    -- 自机狙统计是全局累计的，按卡清零后才能读出这一张卡的数
    _G.aimed_bullets, _G.pointblank_bullets, _G.min_aim_t = 0, 0, 1e9
    _G.pb_t, _G.pb_d, _G.pb_v = 1e9, 0, 0
    local tm_sum, tm_peak, tm_frames, tm_nogo, tm_replan, tm_lastc = 0, 0, 0, 0, 0, nil
    local tm_alive, tm_push_sum, tm_push_peak = 0, 0, 0
    local tm_tth_sum, tm_tth_min, tm_alert_n, tm_hits, tm_aim_hits, tm_pb_hits =
            0, HORIZON, 0, 0, 0, 0
    -- 安全角度范围（往哪个方向跑能活）
    -- 安全角度 / 分区域统计。**打包成一张表**：
    --   LuaJIT 对每个函数有 60 个 upvalue 的硬上限，摊成一堆 tm_xxx 会直接编译不过
    --   （"function has more than 60 upvalues"）。
    local sa = { sum = 0, min = SECT, gap = SECT, dead = 0, c = 0,
                 tf = 0, th = 0, tsa = 0, tdead = 0,
                 bf = 0, bh = 0, bsa = 0, bdead = 0,
                 fw = 0, fa = 0, fy = 0, fn = 0 }
    -- 分区域（自机 y 高于/低于 Y_SPLIT）
    local tm_top_f, tm_top_h, tm_top_sa, tm_top_dead = 0, 0, 0, 0
    local tm_bot_f, tm_bot_h, tm_bot_sa, tm_bot_dead = 0, 0, 0, 0
    local tm_alert = false
    local tm_leak_b, tm_leak_o = 0, 0
    -- 诊断（STAGE_PROBE）：自机 y 区间 / 限位面 y 区间 / 自机待在合法区外的帧数
    local tm_py_min, tm_py_max, tm_py_sum = 1e9, -1e9, 0
    local tm_px_min, tm_px_max = 1e9, -1e9
    -- 强制位移（卡片直接改 player.x/y）的诊断
    local tm_pushed_frames, tm_pre_alert_n, tm_push_to_danger = 0, 0, 0
    local tu_peak, tg_min = 0, SECT
    local label = ("[%d] %s (id=%s)"):format(idx, entry.name, tostring(entry.card_id))
    local good, msg = pcall(function()
        if card.before then drain(function() card.before(boss_obj) end, boss_obj) end
        if card.init then drain(function() card.init(boss_obj) end, boss_obj) end
        -- ★ 阶段阈值必须落在本卡血量之内，否则那个阶段**永远触发不了**
        --   （只能等兜底计时器，玩家看到的就是「血打下去了却没新弹幕」）
        if card.init and boss_obj._sp_point_auto then
            local hp = entry.card.hp or 600
            for _, d in ipairs(boss_obj._sp_point_auto) do
                if type(d) == "number" and d > hp then
                    fail(("%s：addAutoSPPoint 阈值 %s > 本卡血量 %s —— 这个阶段靠掉血永远触发不了")
                            :format(label, tostring(d), tostring(hp)))
                end
            end
        end
        for f = 1, FRAMES do
            if THREAT then bot_move() end
            -- 记录机器人走完之后的位置：之后卡片再动自机 = 强制位移
            local p1x, p1y = player.x, player.y
            if card.frame then card.frame(boss_obj) end
            if card.render then card.render(boss_obj) end
            boss_obj.timer = boss_obj.timer + 1
            boss_obj.ani = boss_obj.ani + 1
            step_tasks()
            step_objects()
            if THREAT then
                -- 强制位移：卡片（clamp / 水位 / 推力）改动了自机多少
                local dx, dy = player.x - p1x, player.y - p1y
                local push = math.sqrt(dx * dx + dy * dy)
                tm_push_sum = tm_push_sum + push
                tm_push_peak = math.max(tm_push_peak, push)

                -- ★ 强制位移（水位、夹框、推力）就是卡片直接改 player.x/y。
                --   卡片是**限速推**的（水位 6 px/帧），所以自机可以在界外待几十帧 ——
                --   但那不是测量误差：**游戏里自机真的就在那个位置上**，
                --   下面 measure_frame 量的正是这个真实位置，不需要再人为吸附到哪。
                --   这里额外对比「卡片插手之前（p1x,p1y）」和「插手之后」两个位置，
                --   回答一个设计问题：是限位器把人**推进**了危险区，还是本来就危险？
                local push_pre_alert = nil
                if os.getenv("STAGE_PROBE") then
                    tm_py_min = math.min(tm_py_min, player.y)
                    tm_py_max = math.max(tm_py_max, player.y)
                    tm_py_sum = tm_py_sum + player.y
                    tm_px_min = math.min(tm_px_min, player.x)
                    tm_px_max = math.max(tm_px_max, player.x)
                    if push > 0.01 then
                        tm_pushed_frames = tm_pushed_frames + 1
                        -- 把自机挪回卡片插手前的位置量一次（dry：不动速度差分基准）
                        local px, py = player.x, player.y
                        player.x, player.y = p1x, p1y
                        local _, _, _, _, _, a = measure_frame(tm_alert, true)
                        player.x, player.y = px, py
                        push_pre_alert = a and true or false
                        if push_pre_alert then tm_pre_alert_n = tm_pre_alert_n + 1 end
                    end
                end

                local tth, n, used, gap, center, alert, alive, hits, aim_hits, pb_hits =
                        measure_frame(tm_alert)
                tm_alive = tm_alive + alive
                tm_sum = tm_sum + n
                tm_peak = math.max(tm_peak, n)
                tu_peak = math.max(tu_peak, used)
                tg_min = math.min(tg_min, gap)
                tm_frames = tm_frames + 1
                tm_hits = tm_hits + hits
                tm_aim_hits = tm_aim_hits + aim_hits
                tm_pb_hits = tm_pb_hits + pb_hits
                -- ★ 安全角度：往哪个方向跑能活
                local sa_n, sa_best, sa_c = measure_safe_angles(false)
                local sa_na, sa_besta = measure_safe_angles(true)
                sa.sum = sa.sum + sa_n
                sa.min = math.min(sa.min, sa_n)
                sa.gap = math.min(sa.gap, sa_best)
                sa.c = sa_c
                if sa_n == 0 then sa.dead = sa.dead + 1 end
                -- 难度场：整个屏幕铺格子量，和「自机实际走过的那条线」对照
                local fw, fa, fy = measure_field()
                sa.fw = math.max(sa.fw, fw)
                sa.fa = sa.fa + fa
                sa.fy = sa.fy + fy
                sa.fn = sa.fn + 1
                -- 按自机在屏幕上的位置分桶：上半场 / 下半场各自的难度
                --   （「这张卡是不是只在某个区域难」靠平均值是看不出来的）
                if player.y > Y_SPLIT then
                    sa.tf = sa.tf + 1
                    sa.th = sa.th + hits
                    sa.tsa = sa.tsa + sa_n
                    if sa_n == 0 then sa.tdead = sa.tdead + 1 end
                else
                    sa.bf = sa.bf + 1
                    sa.bh = sa.bh + hits
                    sa.bsa = sa.bsa + sa_n
                    if sa_n == 0 then sa.bdead = sa.bdead + 1 end
                end
                tm_tth_sum = tm_tth_sum + math.min(tth, HORIZON)
                tm_tth_min = math.min(tm_tth_min, tth)
                if alert then tm_alert_n = tm_alert_n + 1 end
                -- 被限位器推进危险区的帧：卡片插手前是安全的、插手后才进危险区
                if push_pre_alert == false and alert then tm_push_to_danger = tm_push_to_danger + 1 end
                tm_alert = alert
                if used >= SECT then tm_nogo = tm_nogo + 1 end
                if tm_lastc and math.abs(((center - tm_lastc + 540) % 360) - 180) > 135 then
                    tm_replan = tm_replan + 1
                end
                tm_lastc = center
            end
            if STAGE_DUMP and f == STAGE_DUMP then
                local rows = {}
                each_threat(function(t)
                    rows[#rows + 1] = ("    %-22s (%.0f,%.0f)  v=(%.2f,%.2f)")
                            :format(classKey(t.class), t.x, t.y,
                                    (t._mx and t.x - t._mx) or t.vx or 0,
                                    (t._my and t.y - t._my) or t.vy or 0)
                end)
                print(("  [dump] f=%d 自机 (%.0f,%.0f)  有判定物件 %d 个："):format(
                        f, player.x, player.y, #rows))
                table.sort(rows)
                for i = 1, #rows do print(rows[i]) end
            end
            peak_obj = math.max(peak_obj, #objects)
            peak_bul = math.max(peak_bul, #bullets)
            peak_smear = math.max(peak_smear, _G.SMEAR_TOTAL)
            _G.SMEAR_TOTAL = 0
            -- 走到一半把阶段点吃掉，逼终符那种血量驱动的卡推进阶段
            if f == math.floor(FRAMES * 0.5) then boss_obj._sp_point_auto = {} end
            if DEBUG and f % 120 == 0 then
                print(("      f=%-5d 对象=%-3d 弹=%-4d 任务=%d")
                        :format(f, #objects, #bullets, #tasks))
            end
        end
        if card.del then card.del(boss_obj) end
        -- ★「这张卡一共造了什么」**必须打在 `if card.del` 外面**：
        --   计数器原来是在里面清零的，于是**没写 del 的卡**（如 th04 卡 4 死符「无寿之栏」）
        --   会把上一张卡的账整个算到下一张头上 —— 看起来像下一张多造了一份东西。
        --   桩件漏掉一层弹时读数会莫名其妙地低，看这张清单最快：
        --   卡里应该有的东西没出现，就说明它没进威胁统计（th04 卡 2 的花瓣就是这样）。
        if os.getenv("STAGE_PROBE") then
            local listed = {}
            for k, v in pairs(_G.LOG_BULLET) do listed[#listed + 1] = ("弹:%s×%d"):format(k, v) end
            for k, v in pairs(_G.LOG_NEW) do listed[#listed + 1] = ("对象:%s×%d"):format(k, v) end
            table.sort(listed)
            print("      [probe] 本卡共造：" .. table.concat(listed, "  "))
        end
        _G.LOG_NEW, _G.LOG_BULLET = {}, {}
        -- ★ 卡结束后再跑一会儿：看派生的东西有没有被清干净。
        --   注意先 task.Clear(boss)：引擎的 refresh(1) 在换卡时会这么做，
        --   否则会把「挂在 boss 上的循环」当成泄漏（假报警）。
        --   ⚠ 没写 del 的卡会跳过这一段，它的 tm_leak 恒为 0 —— 那是「没测」不是「干净」。
        if card.del then
            task.Clear(boss_obj)
            object.KillServants(boss_obj)
            local b0, o0 = _G.CREATED_BULLETS, _G.CREATED_OBJECTS
            for f = 1, 180 do
                step_tasks()
                step_objects()
            end
            tm_leak_b = _G.CREATED_BULLETS - b0
            tm_leak_o = _G.CREATED_OBJECTS - o0
        end
    end)
    if good then
        if THREAT and tm_frames > 0 then
            local sec = tm_frames / 60
            print(("  %s"):format(label))
            print(("      ★被打频率    %.1f 次/秒（自机**当前所在位置**上，%d 帧内会打到它的弹数；精确自机狙已剔除）")
                    :format(tm_hits / sec, HIT_HORIZON))
            print(("      ★危险时间占比 %.0f%%  |  精确自机狙另计 %.1f 次/秒（留足了挪开时间，不计入难度）")
                    :format(tm_alert_n / tm_frames * 100, tm_aim_hits / sec))
            if tm_pb_hits > 0 then
                print(("      ⚠ 其中**贴脸狙** %d 发（%.2f 次/秒）—— 出膛到命中不足 %d 帧，来不及挪 = 必中，已计入难度")
                    :format(tm_pb_hits, tm_pb_hits / sec, _G.SPAWN_REACT))
            print(("      [probe] 自机狙判定：出膛即瞄准的弹 %d 发，其中 %d 发贴脸；最短出膛→命中 %.0f 帧")
                    :format(_G.aimed_bullets + _G.pointblank_bullets,
                            _G.pointblank_bullets,
                            _G.min_aim_t < 1e9 and _G.min_aim_t or -1))
            if _G.pb_t < 1e9 then
                -- 最糟那一次：把它拆成「距离」和「弹速」两个旋钮，指明该动哪个
                print(("      [probe] 最糟一次：出膛点离自机 %.0f px、弹速 %.2f px/帧 → 只 %.0f 帧。" ..
                        "想 >%d 帧：距离得 > %.0f px（或把弹速压到 ≤ %.2f）")
                        :format(_G.pb_d, _G.pb_v, _G.pb_t, _G.SPAWN_REACT,
                                _G.pb_v * _G.SPAWN_REACT, _G.pb_d / _G.SPAWN_REACT))
            end
            end
            print(("      命中预告TTH  中位 %.0f 帧  最小 %.0f 帧（越小越急）")
                    :format(tm_tth_sum / tm_frames, tm_tth_min))
            print(("      60px 内弹数  平均 %.1f 峰值 %d  |  被堵 %d/%d 格  空隙最少 %d 格（%.0f°）")
                    :format(tm_sum / tm_frames, tm_peak, tu_peak, SECT, tg_min, tg_min * 360 / SECT))
            print(("      ★安全角度    平均 %.1f/%d 个方向能活  最少 %d  |  最窄处最宽安全扇区 %d 格（%.0f°，朝 %.0f°）  |  死局 %d 帧（%.1f%%）")
                    :format(sa.sum / tm_frames, SECT, sa.min,
                            sa.gap, sa.gap * 360 / SECT, sa.c,
                            sa.dead, sa.dead / tm_frames * 100))
            print(("      ★分区域      上方(y>%d) %.1f 次/秒（占 %d/%d 帧，安全角度均 %.1f，死局 %d）  |  下方 %.1f 次/秒（均 %.1f，死局 %d）")
                    :format(Y_SPLIT,
                            sa.tf > 0 and sa.th / (sa.tf / 60) or 0, sa.tf, tm_frames,
                            sa.tf > 0 and sa.tsa / sa.tf or 0, sa.tdead,
                            sa.bf > 0 and sa.bh / (sa.bf / 60) or 0,
                            sa.bf > 0 and sa.bsa / sa.bf or 0, sa.bdead))
            print(("      ★难度场      全场最坏格子 %.1f 发正飞来（在 y≈%.0f）  全场平均 %.1f  |  自机走过的那条线 %.1f")
                    :format(sa.fw, sa.fn > 0 and sa.fy / sa.fn or 0,
                            sa.fn > 0 and sa.fa / sa.fn or 0, tm_hits / tm_frames))
            print(("      强制位移     平均 %.2f 峰值 %.2f px/帧  |  全场有判定 %.0f 发  |  峰值同屏 对象 %d / 弹 %d / 拖影 %d")
                    :format(tm_push_sum / tm_frames, tm_push_peak, tm_alive / tm_frames, peak_obj, peak_bul, peak_smear))
            if os.getenv("STAGE_PROBE") then
                print(("      [probe] 自机 y %.0f~%.0f（均 %.0f）  |  自机 x %.0f~%.0f")
                        :format(tm_py_min, tm_py_max, tm_py_sum / tm_frames,
                                tm_px_min, tm_px_max))
                print(("      [probe] 卡片改了自机坐标 %d/%d 帧（%.0f%%）  |  其中卡片插手前进危险区 %d 帧")
                        :format(tm_pushed_frames, tm_frames, tm_pushed_frames / tm_frames * 100,
                                tm_pre_alert_n))
                print(("      [probe] ★ 卡片**把自机推进**危险区 %d 帧（插手前安全、插手后危险）")
                        :format(tm_push_to_danger))
            end
            if os.getenv("STAGE_DEBUG") then
                local detail = {}
                for k, v in pairs(_G.LOG_BULLET) do detail[#detail + 1] = ("弹:%s×%d"):format(k, v) end
                for k, v in pairs(_G.LOG_NEW) do detail[#detail + 1] = ("对象:%s×%d"):format(k, v) end
                table.sort(detail)
                print(("      卡结束后 180 帧：新建 弹 %d / 对象 %d   %s")
                        :format(tm_leak_b, tm_leak_o, table.concat(detail, " ")))
            end
            if tm_leak_b > 0 or tm_leak_o > 0 then
                fail(("%s  卡结束后的 180 帧里还在新建 弹 %d / 对象 %d —— del 没清干净")
                        :format(label, tm_leak_b, tm_leak_o))
            end
        else
            pass(("%s  峰值 对象 %d / 弹 %d / 拖影 %d"):format(label, peak_obj, peak_bul, peak_smear))
        end
    else
        fail(("%s -> %s"):format(label, tostring(msg)))
    end
end

----------------------------------------------------------------------
local miss = __report_missing()
if #miss > 0 then
    print("")
    print("注意：以下全局没有真实桩件，只给了空壳，相关调用没有被真正检查：")
    print("  " .. table.concat(miss, " "))
end

print("")
if failures == 0 then
    print("通过：注册无误，各卡模拟无运行时错误")
else
    print(("有 %d 处不合格"):format(failures))
    os.exit(1)
end
