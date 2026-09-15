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
_G.cos, _G.sin, _G.tan = math.cos, math.sin, math.tan
_G.max, _G.min = math.max, math.min
_G.abs, _G.sqrt, _G.int = math.abs, math.sqrt, math.floor
-- Lmath.lua 里的角度版三角函数（注意是大写）
_G.Cos = function(t) return math.cos(math.rad(t)) end
_G.Sin = function(t) return math.sin(math.rad(t)) end
_G.Tan = function(t) return math.tan(math.rad(t)) end
_G.hypot = function(x, y) return math.sqrt(x * x + y * y) end
_G.sign = function(x) if x > 0 then return 1 elseif x < 0 then return -1 else return 0 end end

_G.NewSimpleBullet = function(style, col, x, y, v, a, aim, omiga, stay, destroyable)
    local av = math.rad(a or 0)
    local b = { x = x, y = y, rot = a or 0,
                vx = (v or 0) * math.cos(av), vy = (v or 0) * math.sin(av),
                _index = Forbid(col or 1, 1, 16), timer = 0, ani = 0,
                group = 1, _live = true, bound = true, style = style }
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

_G.object = { RawDel = function(o) o._live = false end, Del = function(o) o._live = false end,
              Kill = function(o) o._live = false end, Connect = function() end,
              Preserve = function() end,
              BulletDo = function(fn)
                  for i = 1, #bullets do
                      if bullets[i]._live ~= false then fn(bullets[i]) end
                  end
              end,
              IndesDo = function() end }
_G.bullet = { init = function() end, frame = function() end, render = function() end }
_G.laser = { init = function() end, frame = function() end, render = function() end }
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
_G.ran = { Float = function(self, a, b) return (a or 0) end,
           Int = function(self, a, b) return math.floor(a or 0) end,
           Sign = function(self) return 1 end }
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
task.Clear = function() end
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
O.smear_add = function() end
O.smear_frame = function() end
O.smear_render = function() end
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
local THREAT_R, HIT_R, SECT = 60, 4, 24
-- REACT：留给玩家「反应 + 移动」的帧数。TTH 掉到这个以内 = 现在必须动
-- HORIZON：预测多少帧以内；超过就算「暂时没威胁」
local REACT, HORIZON = 30, 90

---遍历场上有判定的东西（弹 + 有碰撞的敌方 object）
local function each_threat(fn)
    for i = 1, #bullets do
        local b = bullets[i]
        if b._live ~= false then fn(b) end
    end
    for i = 1, #objects do
        local o = objects[i]
        if o._live ~= false and o.colli ~= false
                and (o.group == 1 or o.group == 2 or o.group == 5) then
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
end

---核心度量：**用「原地不动第几帧会中弹」来算**，而不是数周围的密度。
---  一发朝你飞来的弹和一堆远处打转的弹，密度一样但压力完全不同。
---  每发弹用「上一帧位置差分」求速度，然后解析解出它什么时候会进入自机判定圈：
---    |p + v·k|² < r²  →  (v·v)k² + 2(p·v)k + (p·p - r²) < 0
---  取所有弹里最早的那个 = TTH（time to hit）。TTH 越小越急。
local function measure_frame(prev_alert)
    local tth = HORIZON + 1
    local n, used, alive = 0, 0, 0
    local sect = {}
    each_threat(function(t)
        alive = alive + 1
        -- 速度：上一帧位置差分（对 path 驱动的自绘弹也有效）
        local vx, vy = 0, 0
        if t._mx then
            vx, vy = t.x - t._mx, t.y - t._my
        end
        t._mx, t._my = t.x, t.y
        local px, py = t.x - player.x, t.y - player.y
        local d2 = px * px + py * py
        if d2 < THREAT_R * THREAT_R then
            n = n + 1
            local k = int(((math.deg(math.atan2(py, px)) + 360) % 360) / (360 / SECT)) + 1
            if k > SECT then k = SECT end
            sect[k] = true
        end
        -- 命中预测
        local a = vx * vx + vy * vy
        if a < 1e-9 then
            if d2 <= HIT_R * HIT_R then tth = 0 end
        else
            local b2 = 2 * (px * vx + py * vy)
            local c = d2 - HIT_R * HIT_R
            local disc = b2 * b2 - 4 * a * c
            if disc >= 0 then
                local sq = math.sqrt(disc)
                if (-b2 + sq) / (2 * a) >= 0 then       -- 未来会进圈
                    local k1 = (-b2 - sq) / (2 * a)
                    if k1 < 0 then k1 = 0 end
                    if k1 < tth then tth = k1 end
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
    return tth, n, used, best, center, alert, alive
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
    local tm_sum, tm_peak, tm_frames, tm_nogo, tm_replan, tm_lastc = 0, 0, 0, 0, 0, nil
    local tm_alive, tm_push_sum, tm_push_peak = 0, 0, 0
    local tm_tth_sum, tm_tth_min, tm_alert_n, tm_mustmove = 0, HORIZON, 0, 0
    local tm_alert = false
    local tu_peak, tg_min = 0, SECT
    local label = ("[%d] %s (id=%s)"):format(idx, entry.name, tostring(entry.card_id))
    local good, msg = pcall(function()
        if card.before then drain(function() card.before(boss_obj) end, boss_obj) end
        if card.init then drain(function() card.init(boss_obj) end, boss_obj) end
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

                local tth, n, used, gap, center, alert, alive = measure_frame(tm_alert)
                tm_alive = tm_alive + alive
                tm_sum = tm_sum + n
                tm_peak = math.max(tm_peak, n)
                tu_peak = math.max(tu_peak, used)
                tg_min = math.min(tg_min, gap)
                tm_frames = tm_frames + 1
                tm_tth_sum = tm_tth_sum + math.min(tth, HORIZON)
                tm_tth_min = math.min(tm_tth_min, tth)
                if alert then tm_alert_n = tm_alert_n + 1 end
                -- 「必须移动」事件：从安全掉进 REACT 窗口的那一下
                if alert and not tm_alert then tm_mustmove = tm_mustmove + 1 end
                tm_alert = alert
                if used >= SECT then tm_nogo = tm_nogo + 1 end
                if tm_lastc and math.abs(((center - tm_lastc + 540) % 360) - 180) > 135 then
                    tm_replan = tm_replan + 1
                end
                tm_lastc = center
            end
            peak_obj = math.max(peak_obj, #objects)
            peak_bul = math.max(peak_bul, #bullets)
            -- 走到一半把阶段点吃掉，逼终符那种血量驱动的卡推进阶段
            if f == math.floor(FRAMES * 0.5) then boss_obj._sp_point_auto = {} end
            if DEBUG and f % 120 == 0 then
                print(("      f=%-5d 对象=%-3d 弹=%-4d 任务=%d")
                        :format(f, #objects, #bullets, #tasks))
            end
        end
        if card.del then card.del(boss_obj) end
    end)
    if good then
        if THREAT and tm_frames > 0 then
            local sec = tm_frames / 60
            print(("  %s"):format(label))
            print(("      ★必须移动    %.1f 次/秒（原地不动会在 %d 帧内中弹的次数）   |  危险时间占比 %.0f%%")
                    :format(tm_mustmove / sec, REACT, tm_alert_n / tm_frames * 100))
            print(("      命中预告TTH  中位 %.0f 帧  最小 %.0f 帧（越小越急）")
                    :format(tm_tth_sum / tm_frames, tm_tth_min))
            print(("      60px 内弹数  平均 %.1f 峰值 %d  |  被堵 %d/%d 格  空隙最少 %d 格（%.0f°）")
                    :format(tm_sum / tm_frames, tm_peak, tu_peak, SECT, tg_min, tg_min * 360 / SECT))
            print(("      强制位移     平均 %.2f 峰值 %.2f px/帧  |  全场有判定 %.0f 发  |  峰值同屏 对象 %d / 弹 %d")
                    :format(tm_push_sum / tm_frames, tm_push_peak, tm_alive / tm_frames, peak_obj, peak_bul))
        else
            pass(("%s  峰值 对象 %d / 弹 %d"):format(label, peak_obj, peak_bul))
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
