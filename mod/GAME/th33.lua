---=====================================
---TH33  西行寺幽幽子「死符「醉人之生、死之梦幻」」
---（原作 = TH095（東方文花帖）第 7 关第 5 幕，日文卡名 死符「酔人の生、死の夢幻」）
---
---数据来源：`ecl17_c.ecl` —— th095/src/SceneSelect.cpp:143 的
---`TH095_SCENE(75, 7, 5, "world08.std", "enm17.anm", "ecl17_c.ecl", "bgm/th095_04.wav", …)`。
---本文件按它的 Sub2（本体）/ Sub3（扫动循环）/ Sub7 / Sub8（两股交替的整圈弹）
---逐条移植；每个数值都标了它在反汇编里的出处，改动前先回去核对。
---
---坐标系与角度（换算的理由）
---  TH095 的场地同样是 384x448，但原点在**左上**、y 轴**朝下**：世界坐标 (x,y) 画到
---  屏幕上要先加 (320,16)（th095/src/GameCoordinates.cpp 的 PhotoToScreen），也就是
---  x∈[-192,192]、y∈[0,448] 正好铺满场地。
---  我们的场地原点在中心、y 轴**朝上**（lstg.world.l/r/b/t = -192/192/-224/224）。
---  两边边长相同 ⇒ 换算是纯翻转：
---      我们的 x = TH095 的 x
---      我们的 y = 224 − TH095 的 y
---  TH095 的角度是弧度、顺时针为正；我们是 360 度制、逆时针为正。
---  这张卡只有一处角度：每圈抽一个随机基准角（ins_89 的 angle 操作数是 float 选择子
---  0x2751 = random(−π,π)，th095/src/EclOperandsFloat.cpp:121）。**整圈一起取反得到的
---  还是同一组方向**（{a + 2πk/n} 取反 = {−a + 2πk/n}），所以直接抽 [0,360) 就等价，
---  不必像逐发自机狙那样逐个取反。
---
---本卡的形状（三句话）
---  本体在**中轴 x=0** 上按 1600 帧一轮上下扫（256→448→256→64，每段 400 帧，
---  缓动 加速/减速/加速/减速），两条并行上下文**每 14 帧交替放一整圈**弹
---  （每条各每 28 帧一圈），每圈 32+拍照数 发、速度 1.3 定速直线、基准角每圈重抽。
---  圈与圈之间靠「发射点在动 + 基准角重抽」错开，玩家穿的是相邻两圈之间的径向缝。
---
---与原作的差异（都交代在这）
---  1) 原作是拍照关：玩家按快门，`camera.photoIndex`（已拍张数）决定每圈弹数，
---     即 Sub7/Sub8 的 `ins_20(intV0, 0x2761, 32)` —— 0x2761 = camera.photoIndex
---     （th095/src/EclOperandsInt.cpp:186），上限由 Sub2 的 ins_141(10) 设定
---     （同文件 EclRunTargetHigh.inl:449）。我们没有相机，改成
---     **每完成一次上下扫动（400 帧）＝ 按一次快门**（快门音 + 白光 + 逐帧计数），
---     上限同样 10 张 —— 弹数曲线 32→42 与原作一致，只是推进方式不同。
---  2) 弹种 15 / 18 的判定：`g_PhotoBulletCollisionSizes`（th095/src/BulletManager.cpp:118-122）
---     存的是**直径**、命中框取 ±size/2（同文件 :1155），所以 15 号 = 8.0/2 = 半径 4.0、
---     18 号 = 6.0/2 = 半径 3.0。我们用 `ball_mid`（半径 4）打两种弹：15 号完全相等、
---     18 号大 1 px。原作两种弹的贴图同为 30x30 的小玉（bullet.anm 的 script239 =
---     sprite264、script296 = sprite310~313，配 etama2.png），所以画成同尺寸、只换
---     色系深浅 —— 保住「两股交替」这件事的可读性。
---  3) transformFlags = 0x202：0x2 = SPAWN_FAST、0x200 = PLAY_SPAWN_SOUND
---     （th095/src/BulletManager.hpp:133,141）。原作弹出生时先播一小段出场动画、
---     并把位置往回退 4 帧的运动量（同文件 :445-457）；移植版让它出膛就飞
---     （NewSimpleBullet 的 stay=false）。音效原作也是整波响一次（:717-723），一致。
---  4) 原作 Sub4 是 ins_83 生成的**寄生敌机**：它的 ANM 12 是一张 512x255 的整屏叠图
---     （enm17.anm 的 entry3 = boss17b.png，script12 里在 `fsetDiv(128,4,0,±8,0)`
---     之间来回晃），Sub5 每帧把自己挪到拍照目标的位置（ins_63 + 自跳）。
---     我们拿不到那张图，改用**符卡背景 + 花瓣雨**承担「跟着本体动的整屏装饰」。
---  5) 原作的 104/105（拍照会话）、143（拍照标记）、118(0)（死亡照片 VM）、
---     149（分数倍率 1.9）、114（10208 帧的卡计时）都是 TH095 的相机 / 计分机制，
---     我们没有对应系统；卡时限改用本仓库的惯例秒数（见 CARD_TIME）。
---  6) 回收边界：原作是**弹心一越过场地边就回收**（PhotoBulletIsOutsidePlayfield，
---     th095/src/BulletManager.cpp:759-765，判据是「弹心 ± 半宽」出 384x448 的框），
---     而且全游戏共用 640 个弹槽、扫不到空槽就不发（同文件 :310-345）。
---     我们的回收边界是引擎全局的 ±224/±256（= 场地外 32 px，THlib/lib/Lscreen.lua:90-97，
---     bullet.lua:36 用的是 `lstg.world.bound*`，**弹不能单独设**）。后果：同一颗弹多活
---     ~10%，稳态同屏 692 发，比原作的 640 槽多一点。**屏幕上看不出区别** ——
---     两种回收都发生在屏幕外（场地是 x±192 / y±224，边界都在它外面），差的只是场外
---     那几十颗的寿命，所以没有为它去改引擎的全局边界。
---  7) 判定框：Sub2 的 `ins_77(24,24)`（Sub4 的寄生敌机是 `77(8,8)`）设的是敌人判定框
---     （EclRunLow.inl:663-670 → hitboxDimensions）。TH095 没有自机子弹（th095/src 里
---     没有 PlayerBullet 一类文件，「射击键」就是快门），这个框在拍照关里读不出用处；
---     我们这边本体是要用子弹打掉的 HP Boss，判定框交给 boss_system 的默认值
---     —— 全仓库没有任何一张卡自己设过判定框，为一张卡破例反而不一致。
---=====================================

---实测（2026-09-24，本机 luajit）
---  · `luajit tools/check_stage.lua mod/GAME/th33.lua 7200`：峰值 对象 1 / 弹 726，
---    5000~9000 帧稳定在 726（12000 帧 730，差值是花瓣的随机寿命）。3600→7200 会从
---    679 涨到 726，那是 photo_count 到 4130 帧才爬到上限 10（一圈 42 发）的爬坡，
---    不是漏回收 —— 把 petal_stream 注释掉量到不涨的 692 ⇒ 花瓣稳态只占 ~34 发。
---    ① 泄漏扫描 ✅
---  · 多种子（1200 帧 × 6 个种子、3000 帧 × 4 个种子）：`60px 内平均` 8.4~14.2，
---    最坏 `死局 36/3000 = 1.2%`（② 的判据是 > 3% 才要改）✅
---  · `luajit tools/threat.lua mod/GAME/th33.lua 3000`：威胁度 2.69（4 个种子最坏 3.69）、
---    被弹帧 10~13%、安全区 7/25 格且质心横移 320 px ⇒ 「有周期」、不属于墙。
---    文档的区间（《什么是好的弹设.md》：0.5~1.5）是同工具量**自制卡**定出来的；
---    拿它量本仓库的样板关卡 th20.lua 的 35 张：中位 1.15、8 张 > 1.5、最高 3.99，
---    所以 2.7~3.7 是「原作这张本来就这么挤」的读数，不为了凑这个数去改原作的
---    （32+photoIndex 发 / 14 帧一圈 / 1.3 定速都从反汇编里读出来，见上面各常量）。
---    真嫌挤就调 PHOTO_INTERVAL 或 RING_SPEED —— 那就不是移植了，改前先想清楚。
---=====================================

local object, boss = object, boss
local task, ran = task, ran
local New, NewSimpleBullet = New, NewSimpleBullet
local PlaySound, IsValid = PlaySound, IsValid
local SetImageState, Render, RenderRect = SetImageState, Render, RenderRect
local Class = Class
local sqrt = sqrt
local lstg = lstg

local class = {}
_editor_class["TH33"] = class

---TH095 的世界 y → 我们的 y。理由见文件头「坐标系与角度」。
local FIELD_HALF_H = 224
local function field_y(y)
    return FIELD_HALF_H - y
end

do  -- 符卡背景
    ---和 th095.lua 的 ran_bg 用同一套白玉楼贴图（th07_8 / th07_10），但层数、
    ---转速、缩放都换一组 —— 两张卡共用一个背景会让人以为走进了同一张卡。
    ---两张同图反向自转 + 一层正片叠底是 §7.5 推荐的最省事做法。
    class.scbg = Class(_SC_BG)
    function class.scbg:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 0, 0, 0, 0.35, "mul+add", 2.4, 2.4,
                function(l) l.a = 165; l.r, l.g, l.b = 255, 228, 255 end)
        _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 180, 0, 0, -0.22, "mul+rev", 2.6, 2.6,
                function(l) l.r, l.g, l.b = 214, 178, 236 end)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 0, 0, 0, 0, "", 1.8, 1.8,
                function(l) l.a = 200 end)
    end
end

do  -- 死符「醉人之生、死之梦幻」
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 第一帧是 ins_63(-128,-64)（绝对设位置，EclRunLow.inl 的 63 分支），
    ---t=100 的 ins_64(30,4,0,128) 用 30 帧走到 (0,128)。
    ---（ins_64 = ConfigureRelativeMotion，EclHelpers.cpp:43：以「插值到绝对目标点」
    ---的方式移动、顺带把速度清零；第 2 个操作数是缓动，1 = 二次加速、4 = 二次减速，
    ---见 th095/src/PhotoEnemyControl.hpp:18-24。）
    local BOSS_X = -128
    local BOSS_START_Y = field_y(-64)       -- 288：场地之外（上边界是 224）
    local BOSS_HOME_Y = field_y(128)        -- 96
    local ENTRY_WAIT = 100                  -- 原作 t=100 才动
    local ENTRY_TIME = 30

    ---扫动循环（Sub3）：四条腿、每条 400 帧、缓动 1/4/1/4、目标 y = 256/448/256/64，
    ---末尾 ins_4(0,-112) 跳回第一条腿（EclRunLow.inl:242-246：JUMP 把 time 设成
    ---第 1 个操作数、再按第 2 个操作数按字节跳转）。
    local LEG_TIME = 400
    local SWEEP_MID = field_y(256)          -- -32
    local SWEEP_BOTTOM = field_y(448)       -- -224（场地下沿）
    local SWEEP_TOP = field_y(64)           -- 160
    local EASE_IN = VALUE_SET.ACCEL         -- th095 缓动 1 = 二次加速（= n²）
    local EASE_OUT = VALUE_SET.DECEL        -- th095 缓动 4 = 二次减速（= 2n-n²）

    ---两股整圈弹（Sub7 / Sub8）：同一份循环体、循环头的 time 分别是 14 与 0，
    ---所以都是每 28 帧一圈、相位差 14 帧 ⇒ 合起来每 14 帧一圈。
    local RING_PERIOD = 28
    local RING_PHASE = 14
    ---ins_89 的 aimMode = opcode − 0x56 = 3 = CIRCLE（EnemyShotDispatch.cpp:145、
    ---BulletManager.hpp:165-174）：angle = index1*2π/count1 + index2*angleStep + angle，
    ---速度 = speed1（count2 = 1 时 speed2 不参与，BulletManager.cpp:345-350）。
    ---操作数里的 angleStep = 0.18479957（= 2π/34）在这张卡里**没用**：它乘的是 index2，
    ---而 count2 = 1 ⇒ index2 恒为 0。
    local RING_SPEED = 1.3
    local RING_BASE_COUNT = 32              -- ins_20：count1 = camera.photoIndex + 32
    local PHOTO_LIMIT = 10                  -- ins_141(10) ⇒ count1 上限 42
    local PHOTO_INTERVAL = LEG_TIME         -- 移植版的快门节拍（见文件头差异 1）

    ---两股弹的样式/颜色：原作两股是 type18/color0 与 type15/color4 两道不同的 ANM
    ---脚本，贴图配色也不同。我们用同一色系的深浅两档区分（§7.6：一张卡一个色系），
    ---因为这两股是交替出现的，需要一眼看出「这一圈和上一圈不是同一批」。
    local RING_STYLE = ball_mid
    local RING_COLOR_A = COLOR.PURPLE         -- Sub8 那圈：原作 type15（半径 4.0）
    local RING_COLOR_B = COLOR.DEEP_PURPLE    -- Sub7 那圈：原作 type18（半径 3.0）

    ---底帘（§7.3.1）：樱花瓣。§7.5 的母题表里幽幽子＝樱（cherry_bullet.png 的 sakura
    ---样式），速度取「装饰真弹」档 0.5~1.1 px/帧、不朝自机；每片自己缓慢拐弯，
    ---落出场地由引擎回收（bound 默认 true），所以不会越积越多，也不构成墙。
    local PETAL_STYLE = sakura
    local PETAL_COLOR = COLOR.PURPLE
    local PETAL_INTERVAL = 12
    local PETAL_SPEED_MIN, PETAL_SPEED_MAX = 0.5, 1.1
    local PETAL_TURN = 0.35                 -- 每片每帧最多拐这么多度（走弧线）

    ---快门演出的长度与强度（纯演出，原作没有）。
    local SHUTTER_TIME = 20
    local SHUTTER_FLASH = 0.22              -- 整屏白闪的不透明度上限，压得很淡

    local CARD_NAME = "死符「醉人之生、死之梦幻」"
    ---原作卡计时是 ins_114(10208) ≈ 170 秒 —— 那是拍照关留给玩家取景用的。
    ---我们按本仓库符卡惯例取 50 秒（th095.lua 的卡是 45~55 秒）。
    local CARD_TIME = 50
    ---原作 Timeline0 生成本体时给的生命是 150（life；我们这边的 HP 量级见 th095.lua
    ---的 550~900）。
    local CARD_HP = 900
    ---符卡历史的槽位号（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
    ---实测：把全项目的 boss.card.add 末参 **和 th31.lua 的 LIST 表第 3 项**一起数，
    ---1..408 全满了（th31 占 351..367 与 370..408、th32 占 368/369），所以取 409。
    ---⚠ 只扫字面量会漏掉 th31 的 LIST（它的 id 写在表里、由变量传进 add），
    ---  照那种扫法写出来的"空号"一注册就被 `check_stage.lua --all` 报
    ---  「card_id 跨组重复：N（spell_card_data 会串）」——踩过。
    local CARD_ID = 409

    ---拍照计数：原作是 camera.photoIndex（0 → 10），本移植版按扫动次数推进。
    local photo_count = 0
    ---本卡生成的快门演出对象；卡结束时统一收掉（§7.9 第 9 条）。
    local shutters = {}

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---快门：整屏白闪 + 一圈 photoON + 快门音。贴图与写法照 th143.lua:1451-1453
    ---（那一关的相机闪光）——「白闪 / 装饰用 RenderRect」是 §7.5 的 B 类装饰，
    ---只做提示，不当墙用。
    class.shutter = Class(object, {
        init = function(self, x, y)
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET_EF
            self.x, self.y = x, y
            self.colli = false
            self.bound = false
            self.rot = 0
            self._a = 255
            self.scale = 1
            task.New(self, function()
                PlaySound("shutter", 1)
                for i = 1, SHUTTER_TIME do
                    local k = i / SHUTTER_TIME
                    self._a = 255 * (1 - k) * (1 - k)
                    self.scale = 1.1 + 0.7 * k
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState("white", "mul+add", self._a * SHUTTER_FLASH, 255, 255, 255)
            RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
            SetImageState("photoON", "mul+add", self._a, 255, 255, 255)
            Render("photoON", self.x, self.y, self.rot, self.scale * 1.2)
        end,
    })

    ---Sub7 / Sub8 的一次发弹：一整圈、定速直线。
    ---count1 的操作数是变量（ins_20 把 camera.photoIndex + 32 写进 intV0），
    ---所以每圈都在发弹那一刻重读一次 —— 两条上下文读的是同一个值，永远一致。
    local function fire_ring(owner, color)
        local count = RING_BASE_COUNT + photo_count
        local base = ran:Float(0, 360)      -- 原作 ins_89 的 angle = random(−π,π)
        local x, y = owner.x, owner.y
        for i = 0, count - 1 do
            NewSimpleBullet(RING_STYLE, color, x, y, RING_SPEED,
                    base + i * 360 / count, false, 0, false)
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整圈只响一声（BulletManager.cpp:717-723），
        -- 与逐发的出场音不同。
        PlaySound("tan00", 0.1, x / 256, false)
    end

    ---一条发弹上下文（Sub7 或 Sub8）：先等自己的相位，然后每 28 帧一圈。
    local function ring_stream(owner, phase, color)
        task.New(owner, function()
            task.Wait(phase)
            while true do
                fire_ring(owner, color)
                task.Wait(RING_PERIOD)
            end
        end)
    end

    ---底帘：从上沿往下飘的花瓣。frame 钩子只收一个参数（§5.2），
    ---所以「这一片拐多少」在第一次进钩子时抽一次、存在自己身上。
    local function new_petal()
        local petal = NewSimpleBullet(PETAL_STYLE, PETAL_COLOR,
                ran:Float(lstg.world.l - 32, lstg.world.r + 32), lstg.world.t + 24,
                ran:Float(PETAL_SPEED_MIN, PETAL_SPEED_MAX),
                270 + ran:Float(-18, 18), false, 0, false,
                nil, nil, nil,
                function(unit)
                    if unit.petal_turn == nil then
                        unit.petal_turn = ran:Float(-PETAL_TURN, PETAL_TURN)
                    end
                    -- 速度大小不变、方向每帧转一点 ⇒ 花瓣走成弧线（不是直线下落）。
                    object.SetV(unit, sqrt(unit.vx * unit.vx + unit.vy * unit.vy),
                            unit.rot + unit.petal_turn, true)
                end)
        return petal
    end

    local function petal_stream(owner)
        task.New(owner, function()
            while true do
                new_petal()
                task.Wait(PETAL_INTERVAL)
            end
        end)
    end

    ---移植版的快门（见文件头差异 1）：每完成一次上下扫动＝拍一张。
    local function photo_clock(owner)
        task.New(owner, function()
            while photo_count < PHOTO_LIMIT do
                task.Wait(PHOTO_INTERVAL)
                photo_count = photo_count + 1
                local s = New(class.shutter, owner.x, owner.y)
                shutters[#shutters + 1] = s
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        ---photo_count 是模块内的变量，重打这张卡（或进练习）必须回到 0，
        ---否则第二次进来直接就是 42 发一圈。
        photo_count = 0
        shutters = {}
    end

    function card:init()
        ---入场点：原作本体第一帧就把自己定到 (-128,-64)（场地外），第 100 帧才起步。
        self.x, self.y = BOSS_X, BOSS_START_Y
        petal_stream(self)
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 在 t=130 CALL Sub3，而 Sub3 的 t=0 同时
            ---起两股整圈弹、开扫动循环、响一声（ins_106(5)，一个定位置的音效）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            ring_stream(self, 0, RING_COLOR_A)
            ring_stream(self, RING_PHASE, RING_COLOR_B)
            photo_clock(self)
            while true do
                task.MoveTo(0, SWEEP_MID, LEG_TIME, EASE_IN)
                task.MoveTo(0, SWEEP_BOTTOM, LEG_TIME, EASE_OUT)
                task.MoveTo(0, SWEEP_MID, LEG_TIME, EASE_IN)
                task.MoveTo(0, SWEEP_TOP, LEG_TIME, EASE_OUT)
            end
        end)
    end

    ---本体的逐帧逻辑：**原作没有**。它的移动、发弹、位置跟随全在 ECL 上下文里
    ---（Sub3 的 ins_64、Sub7/Sub8 的 ins_89），我们照抄成协程；frame 留空是刻意的，
    ---不是漏写。（挂在本体上的协程由 boss_system 的 task.Clear 在换卡时统一清掉。）
    function card:frame()
    end

    function card:del()
        for i = #shutters, 1, -1 do
            if IsValid(shutters[i]) then
                object.RawDel(shutters[i])
            end
        end
        shutters = {}
    end

    ---关卡号 31（= STAGE_COUNT + 1）。2026-09-24 已按 AGENTS.md §8 注册完，一处都别漏：
    ---  core.lua:54              STAGE_COUNT 30 → 31
    ---  _editor_output.lua:47   StageID 加 "33"（顺便决定载入顺序：在 "32" 之后）
    ---  _editor_output.lua:49   不建自己的 BG 目录（和 TH30/31/32 一样复用别人的）
    ---  _editor_output.lua:1213 stage_pic 纹理循环 30 → 31
    ---  UI.lua:56 的 difftext   第 31 项 = "醉生梦死"（下标必须等于 level，AEX 顺延到 32）
    ---  UI.lua:77 的 sntext     TH33 = "醉生梦死"
    ---  main_stage.lua          NewStage("TH33", …) + self:Next(166)
    ---  defachievement.lua      成就 166
    --- 素材 mod/GAME/stage_pic31.png 是**占位图**（用本卡 SCBG 的 th07_8 / th07_10 拼的；
    --- 顺便一提：23~30 关现在也共用同一张占位图，md5 都是 96ce7b2…），
    --- 要换成真立绘直接覆盖这个文件就行。
    local LEVEL = 31
    boss.Define("1a", "西行寺幽幽子", "TH07_1", TH095_bg,
            { BOSS_X, BOSS_START_Y }, class.scbg, "Yuyuko", LEVEL)
    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--死符「醉人之生、死之梦幻」
