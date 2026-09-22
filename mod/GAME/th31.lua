---=====================================
---TH31  永夜 Last Word
---  TH08（东方永夜抄）官方 17 张 Last Word（卡 205..221）的逐条移植。
---
---移植方法（与 th32「红色的幻想乡」同一套）：直接读 th08full —— reccmp 复原的
---TH08 1.00d 反编译源码 —— 与 data/ecldata*.ecl 的原始字节，逐条对齐节拍、
---参数与副作用。下面每一条「文件:行号」都能在本机复查；实测数字与推断分开标注。
---
---★ 与旧版 th31.lua 的关系：旧版是「按反汇编手写 17 张卡」，这一版**整个废弃**它。
---  17 张 Last Word 合计 83 个子程序、2607 条 ECL 指令，手写一份等于手抄一份
---  反汇编：参数错一位、条件跳转错一格就是另一张卡，而且没法核对。
---  这一版改成 **把 ECL 字节码导出成数据表（L.RAW）+ 在 Lua 里实现一个忠于
---  原作语义的 ECL 虚拟机**。节拍、参数、条件跳转、子程序调用全部来自原始字节，
---  虚拟机负责把原作的那套语义（时间比较、难度掩码、调用栈、插值槽、
---  context 栈、每帧顺序）一比一复刻出来。
---
---  导出器（tools 之外的一次性脚本）从 .ecl 二进制直接读指令，对每张卡的根
---  子程序做一次闭包（CALL 52 / SPAWN 90..94 / CHILD_ECL 135），生成文件末尾
---  的那张 RAW 表；格式见数据表开头。它是生成物，不要手改。
---
---  与原作对齐的几条关键事实（后面的每一处实现都靠它们）：
---   · 只有 activeEclContext->time == instruction->time 才执行一条指令
---     （EclRun.cpp:66-73），time 每帧 +1（EclRun.cpp:188）。
---     被难度挡掉的指令会 goto low_advance_instruction → **同一帧里继续往后跑**
---     （EclRun.cpp:74-80/102-104）。
---   · Last Word 的 difficulty 是 5（AllDifficulties 那一档，Spellcard.cpp:226-235）
---     → g_GameManager.difficultyMask = 0xf（GameManager.cpp:709-711）。
---     判据是「指令的 mask 必须覆盖当前 mask」，于是 E/N/H/L 四档的变体
---     （mask 241/242/244/248，本数据里各有几条）全部被跳过，只有 255 执行。
---     虚拟机在**运行期**判（不是导出时过滤，否则跳转下标会错位）。
---   · CALL(52)：调用方 context 整份存栈、pc 先推进到 CALL 的下一条，
---     子程序从 time=0 起跑，期间调用方 time 冻结；RETURN(53) 恢复
---     （EclDependencies.cpp:472-540）。子程序里的 time = 子程序内的第几帧。
---   · 10061..10068（SHARED_CALL_*）是**全局共享**的 g_EclCallParameters；
---     10053..10060（CALL_*）是每个 context 自己的副本；CALL 的那一刻把共享的
---     那份整块拷进被调 context 的 10053..10068（EclDependencies.cpp:491-493，
---     EclCallParameterCopy 是 0x20 字节 = 4 int + 4 float）。
---   · context 0 跑完再跑 childEclBlocks[0..3]，每个 context 一帧跑完都会走
---     同一段「收尾」：perFrameCallback(ins_137) → 8 个插值槽 → time++
---     （EclRun.cpp:118-190/194-215）。
---   · 出弹参数**没有 rank 修正**：DispatchShotInstruction 的 rank 段被
---     `!g_Spellcard.IsActive()` 挡住（EclDependencies.cpp:735-761），
---     而 Last Word 全程是符卡。移植版同样不缩放。
---   · 同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455 的
---     `Bullet bullets[0x601]`），activeBulletCount >= 0x600 时**整波不生**
---     （BulletManager.cpp:686-690）；某一颗生不出来 → 整波剩下的都放弃，
---     但音效照响（:700-709）。
---   · 出生动画：flags 带 SPAWN_FAST/NORMAL/SLOW 的小弹进入 SPAWNING_* 状态，
---     那段时间**不跑 transform**，每帧只走 velocity/2、/2.5、/3；出生瞬间位置
---     已经先减去 velocity*4（BulletManager.cpp:212-241、955-1013）。
---     动画长度 = etama.anm 里对应 spawn 脚本的长度（SPAWN_FRAMES 实测）。
---   · 小弹的每帧顺序：AdvanceTransformProgram → 各 Update* → cull 计时 →
---     position += velocity（`scriptedUpdateFreeze` 时跳过）→ 出界回收 → 判定
---     （BulletManager.cpp:820-952）。
---   · 敌方每帧顺序（EnemyManagerUpdate.cpp:159-192）：
---     UpdateYoukaiAlignment → RunEcl（含所有 context）→ ClampPosition →
---     IntegrateVelocity → ClampPosition → 有 parent 且 inheritParentPosition 时
---     positionOffset = parent.position → worldPosition = position + positionOffset。
---   · 每张卡的时长 = ins_134 的 timerCallbackThresholdFrames / 60 秒
---     （Spellcard.cpp:739 把 timeLimit 直接取成这个数）。
---
---坐标：TH08 是 384×448、左上原点、y 朝下；我们原点在中心、y 朝上，
---      所以 x' = x-192、y' = 224-y，角度整体取反。
---
---以下所有推断都标注了依据；无法从源码确认的地方（贴图/音效/粒子）按观感近似，
---并明确写出「近似」二字。
---=====================================

local class = {}
_editor_class["TH31"] = class

local boss, task, object = boss, task, object
local New, Del = New, Del
local NewSimpleBullet, PlaySound = NewSimpleBullet, PlaySound
local cos, sin, sqrt = cos, sin, sqrt
local abs, min, max, floor = abs, math.min, math.max, math.floor
local atan2 = math.atan2
local Class, IsValid = Class, IsValid
local ran, player, lstg = ran, player, lstg
local ball_small, ball_mid, ball_huge = ball_small, ball_mid, ball_huge
local PI = 3.141592653589793
local TWO_PI = 6.283185307179586
local DEG = 57.29577951308232

local TH08_SC = _editor_class["TH08"] or {}
local TH07_SC = _editor_class["TH07"] or {}

---------------------------------------------------------------
---跨模块共享表。
---主 chunk 的 local 上限是 200（实测第 201 条就报 "main function has more
---than 200 local variables"），所以下面每个模块都用 `do ... end` 包起来、
---模块内部互相可见，跨模块的东西只经这张表 L 传递。
---------------------------------------------------------------
local L = {}
---ECL 字节码数据表（文件末尾的 RAW 段往里填）。
L.RAW = {}

---TH08 世界坐标 → 我们的世界坐标。
local function X2L(x) return x - 192 end
local function Y2L(y) return 224 - y end
---TH08 角度（弧度，y 朝下）→ 我们的度（y 朝上）。
local function A2L(a) return -a * DEG end
---我们的世界坐标 → TH08 坐标。
local function L2X(x) return x + 192 end
local function L2Y(y) return 224 - y end
L.X2L, L.Y2L, L.A2L, L.L2X, L.L2Y = X2L, Y2L, A2L, L2X, L2Y

---self 在 TH08 坐标系里的位置（g_Player.position 是 TH08 的 384×448 坐标系，
---Player.cpp 里玩家位置与游戏区同系）。
local function pcx() return player.x + 192 end
local function pcy() return 224 - player.y end
L.pcx, L.pcy = pcx, pcy

---整数截断（C 的 (i32) 强制转换）：向零取整。
local function toint(x) return x >= 0 and floor(x) or -floor(-x) end
L.toint = toint

---------------------------------------------------------------
---TH08 的 SoundIdx → LuaSTG 的音效名 + 线性音量（近似）。
---映射表来自 SoundPlayer.cpp:20-38 的 g_SoundBufferIdxVol：每个 SoundIdx
---给 (SFXList 下标, 音量「百分之一 dB」)；g_SFXList 给文件名；
---LuaSTG 的音效名 = 文件名去掉 se_ 与 .wav（THlib/se/se.lua）。
---音量换算：gain = 10^(dB/200)（表里是百分之一 dB，-1900 → -19dB）。
---本文件实际用到的是 SoundIdx 5/13/15/16/19/25/33/36/42（实测 grep
---数据表里所有 ins_124 与三处「子机出生音」）。
---------------------------------------------------------------
local SFX = {}
do
    local vol = {
        [5] = { 3, -700 },  [7] = { 5, -1900 }, [13] = { 11, -1500 },
        [15] = { 5, -1100 }, [16] = { 13, -1300 }, [19] = { 16, -400 },
        [25] = { 19, -1100 }, [33] = { 19, -500 }, [36] = { 19, -400 },
        [42] = { 34, 0 },
    }
    local file = {
        [3] = "power0", [5] = "tan00", [11] = "gun00", [13] = "lazer00",
        [16] = "nep00", [19] = "kira00", [34] = "slash",
    }
    for idx, entry in pairs(vol) do
        local name = file[entry[1]]
        if name then
            SFX[idx] = { name = name, gain = 10 ^ (entry[2] / 200) }
        end
    end
end

---PlaySoundPositionedByIdx(idx, position.x)：pan 按 TH08 的 x 算
---（SoundPlayer.cpp 里 `panAsInt = ((pan - 192) * 1000) / 192`），
---而 LuaSTG 的 pan 是 -1..1（THlib/se/se.lua 的 `pan / 1024`）。
local function sfx_at(idx, x)
    local s = SFX[idx]
    if s == nil then return end
    local pan = (x - 192) * 1000 / 192 / 1024
    if pan < -1 then pan = -1 elseif pan > 1 then pan = 1 end
    PlaySound(s.name, s.gain, pan, true)
end

---PlaySoundByIdx(idx, 0)：无方位。
local function sfx(idx)
    local s = SFX[idx]
    if s == nil then return end
    PlaySound(s.name, s.gain, 0, true)
end
L.sfx, L.sfx_at = sfx, sfx_at
L.SFX = SFX

L.TH08_bg = TH08_bg
L._SC_BG = _SC_BG
L.boss_card = boss.card
L.boss_Define = boss.Define
L.class = class
L.TH08_SC, L.TH07_SC = TH08_SC, TH07_SC

---------------------------------------------------------------
---g_Supervisor / g_GameManager 里被 ECL 读到的全局量。
---framerateMultiplier：ex28/ex29（Enter/ExitScaledBulletTime）会改它，
---  小弹的创建速度、每个 Update*、以及位置积分都要乘它。
---scriptedUpdateFreeze：ex26 设置，非 0 时小弹不积分位置
---  （BulletManager.cpp:864-865）。
---difficulty / rank：ECL 操作数 10040/10041。
---  Last Word 的 difficulty = 5（AllDifficulties），rank 固定取 32（实测值，
---  见本文件头部说明「rank 取 32」）。
---------------------------------------------------------------
L.game = {
    framerateMultiplier = 1,
    scriptedUpdateFreeze = false,
    difficulty = 5,
    rank = 32,
    ---g_EclCallParameters（EclGlobals.cpp:105）：SHARED_CALL_INT_0..3 / FLOAT_0..3。
    sharedI = { 0, 0, 0, 0 },
    sharedF = { 0, 0, 0, 0 },
    ---本帧要生成的子敌（RunEcl 期间登记，帧末统一创建，见 e_actor）。
    pendingSpawns = {},
}
L.reset_game = function()
    local g = L.game
    g.framerateMultiplier = 1
    g.scriptedUpdateFreeze = false
    g.sharedI[1], g.sharedI[2], g.sharedI[3], g.sharedI[4] = 0, 0, 0, 0
    g.sharedF[1], g.sharedF[2], g.sharedF[3], g.sharedF[4] = 0, 0, 0, 0
end

---------------------------------------------------------------
---数学与共享工具（ZunMath.hpp:132-133）。
---AddNormalizeAngle / VectorAngle 的**实现**没有被复原（这两个函数在
---th08full 里只有声明），按标准语义写：
---  VectorAngle(y, x)   = atan2(y, x)，归一化到 [0, 2π)（TH08 的 atan2 是 y 朝下系）
---  AddNormalizeAngle(a, b) = 归一化(a + b)，同样落回 [0, 2π)
---两者都只被喂给 cos/sin 或再归一化，所以归一到哪个同余区间不影响弹幕。
---------------------------------------------------------------
do
    local function AddNormalizeAngle(a, b)
        local v = ((a or 0) + (b or 0)) % TWO_PI
        if v < 0 then v = v + TWO_PI end
        return v
    end
    local function VectorAngle(y, x)
        if y == 0 and x == 0 then return PI / 2 end
        local v = atan2(y, x)
        if v < 0 then v = v + TWO_PI end
        return v
    end

    ---g_Rng.GetRandomF32InRange(a) = a * GetRandomF32()，GetRandomF32 ∈ [0,1)。
    ---（EclOperandsFloat.cpp:56 的 ECL_OPERAND_RANDOM_ANGLE 就是这么用的。）
    local function RAN_F32(a) return (a or 0) * ran:Float(0, 1) end
    ---g_Rng.GetRandomU16() & 1（ins_8/9 的随机符号，EclRunLow.inl:253-264）。
    local function rand_sign() return (ran:Int(0, 65535) % 2 == 1) and 1 or -1 end

    ---g_Player.IsYoukai()。本文件 17 张卡里没有任何 ONLY_WHEN_PLAYER_YOUKAI /
    ---ONLY_WHEN_PLAYER_HUMAN 的出弹位（实测所有出弹指令的 flags 里都没有
    ---0x8000 / 0x10000，也没有 0x8000 的子弹 transform），它只影响子机外形、
    ---子机画层与 alignment effect 的观感。这里固定取「人类」。
    local function player_is_youkai() return false end

    L.TWO_PI = TWO_PI
    L.VectorAngle, L.AddNormalizeAngle = VectorAngle, AddNormalizeAngle
    L.RAN_F32, L.rand_sign = RAN_F32, rand_sign
    L.player_is_youkai = player_is_youkai
end
do
---------------------------------------------------------------
-- 弹：类型 → 样式 / 尺寸 / 出生动画长度
---------------------------------------------------------------
---TH08 的 bulletType 是 etama.anm 的行号 0..20，每行 16 个色版。
---每个类型用 5 个脚本：bulletVm / spawnFast / spawnNormal / spawnSlow / despawn，
---表在 BulletManager.cpp:299-307（g_BulletSpriteScripts）。出生动画长度 =
---对应脚本里 ins_1 的 time（下面是 etama.decl 实测值）：
---   script18=10 19=15 20=30（类型 0）
---   script21=10 22=15 23=32（类型 1-6、11-13、16-17）
---   script24=30（类型 7-9、14-15、18-20）  script27=24（类型 10）
---   despawn 15/16/17 都是 12 帧。
---LuaSTG 没有逐像素对应的图集，按「档位」映射到最近的样式（观感近似）。
---g_Supervisor.framerateMultiplier（ex28/ex29 会改）。
local function gm() return L.game.framerateMultiplier end

local BT_STYLE, BT_PX = {}, {}
do
    local function set(list, style, px)
        for _, i in ipairs(list) do
            BT_STYLE[i] = style
            BT_PX[i] = px
        end
    end
    set({ 0, 1, 2, 3, 4, 5, 6, 11, 12, 13, 14, 15, 16 }, ball_small, 16)
    set({ 7, 8, 9, 17, 18, 19, 20 }, ball_mid, 32)
    set({ 10 }, ball_huge, 64)
end

---TH08 的 16 个色版 → LuaSTG 的 16 色（序号直接对应，观感近似）。
local function ECOLOR(c) return (c % 16) + 1 end

local SPAWN_FRAMES = {}
do
    local fast, normal, slow = {}, {}, {}
    local function put(i, f, n, s) fast[i], normal[i], slow[i] = f, n, s end
    put(0, 10, 15, 30)
    for i = 1, 6 do put(i, 10, 15, 32) end
    for i = 7, 9 do put(i, 30, 30, 30) end
    put(10, 24, 24, 24)
    for i = 11, 13 do put(i, 10, 15, 32) end
    put(14, 30, 30, 30)
    put(15, 30, 30, 30)
    put(16, 10, 15, 32)
    put(17, 10, 15, 32)
    for i = 18, 20 do put(i, 30, 30, 30) end
    SPAWN_FRAMES = { fast = fast, normal = normal, slow = slow }
end

---------------------------------------------------------------
-- 同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455
-- `Bullet bullets[0x601]`，末格是哨兵）。
---SpawnSingleBullet 从游标处环形扫 0x600 个槽找 UNUSED，扫不到就 return 1
---（BulletManager.cpp:91-100）；SpawnBulletPattern 一发现某颗生不出来就整波
---放弃、但音效照响（:693-712）。
---移植版没有全局弹池，就用本卡自己的登记表当池子（每张卡开始时都会清场）。
---计数用 O(1) 的 pool_live：弹「出界回收」那一帧自己减一。
---------------------------------------------------------------
local POOL_SIZE = 1536
local POOL, pool_live = {}, 0

---⚠ 池表**永不换对象**：L.POOL 是所有模块共享的引用（ex12/ex14/ex27 的全池扫描），
---换表会让它们扫到一张空的旧表。清空一律就地做。
local function pool_reset()
    for i = #POOL, 1, -1 do POOL[i] = nil end
    pool_live = 0
end
local function pool_count() return pool_live end
---等价于 activeBulletCount >= 0x600（BulletManager.cpp:688-690）。
local function pool_full() return pool_live >= POOL_SIZE end

---回收一颗弹（官方 = memset 该槽 / Deactivate）。
local function kill_bullet(b)
    if b._dead then return end
    b._dead = true
    pool_live = pool_live - 1
    if pool_live < 0 then pool_live = 0 end
    Del(b)
end

---ins_112 CLEAR_BULLETS_FOR_TRANSITION（Spellcard.cpp:887-890 → RemoveAllBullets(1)）：
---把全池还活着的弹全部清掉（原作顺带掉道具，我们只清弹），激光槽一并清空。
---17 张卡的字节码里**没有**这条（实测 0 条），保留实现以防以后加回来。
local function clear_bullets()
    for i = 1, #POOL do
        local b = POOL[i]
        if b ~= nil and not b._dead then kill_bullet(b) end
    end
end

---弹中心是否还在游戏区里（GameManager::IsWithinPlayfield，GameManager.cpp:132-152：
---按精灵宽高各外扩一半）。我们的坐标：TH08 的 x∈[0,384] ↔ 我们 x∈[-192,192]；
---y∈[0,448] ↔ y∈[-224,224]。
local function in_field(x, y, r)
    return x >= -192 - r and x <= 192 + r and y >= -224 - r and y <= 224 + r
end

---------------------------------------------------------------
-- Bullet::AdvanceTransformProgram + 各 Update*（BulletManager.cpp:310-490、
-- 1180-1465）
---------------------------------------------------------------
---BulletTransformKind（BulletManager.hpp:110-135）。
local K_DECEL, K_SPAWN_FAST, K_SPAWN_NORMAL, K_SPAWN_SLOW = 0x1, 0x2, 0x4, 0x8
local K_ACC_VEC, K_ACC_POLAR = 0x10, 0x20
local K_DIR_REL, K_DIR_AIM, K_DIR_ABS = 0x40, 0x80, 0x100
local K_SPAWN_SOUND, K_BOUNCE_ALL, K_BOUNCE_BOTTOM = 0x200, 0x400, 0x800
local K_CANCEL_IMMUNE, K_CULL, K_SPRITE, K_WAIT = 0x1000, 0x2000, 0x4000, 0x20000
local K_DESPAWN, K_SOUND, K_EX_MARKER = 0x40000, 0x80000, 0x100000

---位测试。⚠ 只对**非负**的 flags 成立：active 一旦变负（见下面 bounce 的清位），
---floor(负数/kind) % 2 会算出 1，于是每个 has() 都判真。这里顺手挡一道。
local function has(flags, kind)
    if kind <= 0 then return false end
    if flags < 0 then flags = -flags end
    return floor(flags / kind) % 2 ~= 0
end

local function norm(a)
    a = a % (PI * 2)
    if a >= PI then a = a - PI * 2 end
    return a
end

---ins_111 写的一条记录（槽位 0 基）。官方是 memcpy 一份 transforms 进弹里
---（BulletManager.cpp:262），已经在飞的弹不会被后来的 ins_111 改掉。
local function tr(slot, kind, allow, i0, i1, f0, f1)
    return { slot = slot + 1, kind = kind, allow = (allow or 0) ~= 0,
             i0 = i0 or 0, i1 = i1 or 0, f0 = f0 or 0, f1 = f1 or 0 }
end

---造一颗弹。px/py 是 TH08 坐标，a 是 TH08 弧度，speed 是每帧像素。
---flags = 本次出弹的 transformFlags（ShotArgs.transformFlags）。
---返回值 = 弹对象，nil = 没生出来（池满；调用方要立刻放弃整波）。
local function make_bullet(gun, px, py, bt, color, speed, a, flags)
    if pool_full() then return nil end
    local spawn_frames = 0
    if has(flags, K_SPAWN_FAST) then spawn_frames = SPAWN_FRAMES.fast[bt] or 0
    elseif has(flags, K_SPAWN_NORMAL) then spawn_frames = SPAWN_FRAMES.normal[bt] or 0
    elseif has(flags, K_SPAWN_SLOW) then spawn_frames = SPAWN_FRAMES.slow[bt] or 0 end

    local style = BT_STYLE[bt] or ball_small
    local recs = gun.records
    local tsnd = gun.transform_sound
    -- 每颗弹自己的 transform 状态（官方 memcpy 一份 records 进弹）
    local local_recs = {}
    for i = 1, 18 do local_recs[i] = recs[i] end

    local idx, active = 1, 0
    local st = {}
    local ba, bs = a, speed
    local cull, spawn, despawn, offscreen = 0, spawn_frames, 0, 0
    local state = 0
    if has(flags, K_SPAWN_FAST) then state = 1
    elseif has(flags, K_SPAWN_NORMAL) then state = 2
    elseif has(flags, K_SPAWN_SLOW) then state = 3 end
    local first = true

    local self
    ---速度 = FromAngleMagnitude(angle, speed * framerateMultiplier)。
    ---原作里**每一处** FromAngleMagnitude 都乘了 g_Supervisor.framerateMultiplier
    ---（BulletManager.cpp:237/1186/1236/1279/1313/1348/1366），所以这里统一乘。
    local function vel(a2, s2)
        local m = gm()
        self.vx = cos(a2) * s2 * m
        self.vy = -sin(a2) * s2 * m
        self.rot = A2L(a2)
    end
    local function setv(a2, s2) ba, bs = a2, s2; vel(a2, s2) end

    ---官方 AdvanceTransformProgram：每次调用最多消费一条「有效」记录
    ---（CULL / SPRITE / SOUND 三条会 goto nextRecord 继续往后找）。
    local function advance()
        while idx <= 18 do
            local r = local_recs[idx]
            if r == nil or r.kind == 0 then return end
            if not r.allow and active ~= 0 then return end
            if not has(flags, r.kind) then
                idx = idx + 1
            elseif r.kind == K_CULL then
                cull = r.i0
                idx = idx + 1
            elseif r.kind == K_SOUND then
                --BULLET_TRANSFORM_PLAY_SOUND（BulletManager.cpp:466-472）：
                --按 record->payload.sound.soundIndex 在子弹位置上放一次音。
                if r.i0 >= 0 then sfx_at(r.i0, self.x + 192) end
                idx = idx + 1
            elseif r.kind == K_SPRITE then
                --SET_SPRITE 换弹的类型与色版（纯观感）。我们没有 TH08 的弹图集，
                --按「档位近似」不动贴图，只跳过这条记录。
                idx = idx + 1
            elseif r.kind == K_DESPAWN then
                despawn, state = 12, 4
                idx = idx + 1
                return
            elseif r.kind == K_DECEL then
                active = active + K_DECEL
                st[K_DECEL] = { timer = 0 }
                idx = idx + 1
                return
            elseif r.kind == K_ACC_VEC then
                active = active + K_ACC_VEC
                --vector.FromAngleMagnitude(accelAngle, fm * magnitude)
                --在**激活那一次**算好（BulletManager.cpp:349-353），
                --之后每次 Update 只再乘一次当时的 fm（:1215）。
                local ang0 = r.f1 > -990 and r.f1 or ba
                local m0 = gm()
                st[K_ACC_VEC] = { timer = 0, mag = r.f0, ang = ang0,
                                  avx = cos(ang0) * r.f0 * m0,
                                  avy = -sin(ang0) * r.f0 * m0,
                                  duration = r.i0 }
                if idx ~= 1 and tsnd >= 0 then sfx(tsnd) end
                idx = idx + 1
                return
            elseif r.kind == K_ACC_POLAR then
                active = active + K_ACC_POLAR
                st[K_ACC_POLAR] = { timer = 0, ds = r.f0, da = r.f1,
                                    duration = r.i0 }
                if idx ~= 1 and tsnd >= 0 then sfx(tsnd) end
                idx = idx + 1
                return
            elseif r.kind == K_DIR_REL or r.kind == K_DIR_AIM or r.kind == K_DIR_ABS then
                local kind = r.kind
                active = active + kind
                st[kind] = { timer = 0, da = r.f0,
                             spd = r.f1 > -999 and r.f1 or bs,
                             interval = r.i0, rep = r.i1, done = 0 }
                idx = idx + 1
                return
            elseif r.kind == K_BOUNCE_ALL or r.kind == K_BOUNCE_BOTTOM then
                local kind = r.kind
                active = active + kind
                st[kind] = { spd = r.f0 >= 0 and r.f0 or bs,
                             limit = r.i0, done = 0 }
                idx = idx + 1
                return
            elseif r.kind == K_WAIT then
                active = active + K_WAIT
                st[K_WAIT] = { timer = r.i0 }
                idx = idx + 1
                return
            else
                -- 官方 default（含 SPAWN_* / EX_MARKER / CANCEL_IMMUNE / SPAWN_SOUND）
                idx = idx + 1
                return
            end
        end
    end

    local function update()
        if has(active, K_DECEL) then
            local s = st[K_DECEL]
            if s.timer <= 16 then
                -- magnitude = 5 - timer*5/16，速度字段本身不变（:1180-1201）
                vel(ba, (5 - s.timer * 5 / 16) + bs)
            else
                active = active - K_DECEL
            end
            s.timer = s.timer + 1
        end
        if has(active, K_ACC_VEC) then
            local s = st[K_ACC_VEC]
            if s.timer >= s.duration then
                active = active - K_ACC_VEC
            else
                local m = gm()
                self.vx = self.vx + s.avx * m
                self.vy = self.vy + s.avy * m
                if abs(self.vx) > 0.0001 or abs(self.vy) > 0.0001 then
                    ba = atan2(-self.vy, self.vx)
                    self.rot = A2L(ba)
                end
            end
            s.timer = s.timer + 1
        end
        if has(active, K_ACC_POLAR) then
            local s = st[K_ACC_POLAR]
            if s.timer >= s.duration then
                active = active - K_ACC_POLAR
            else
                setv(norm(ba + s.da), bs + s.ds)
            end
            s.timer = s.timer + 1
        end
        local function dir(kind)
            local s = st[kind]
            local mag
            if s.timer >= s.interval then
                if tsnd >= 0 then sfx(tsnd) end
                s.done = s.done + 1
                if s.done >= s.rep then active = active - kind end
                if kind == K_DIR_REL then ba = ba + s.da
                elseif kind == K_DIR_AIM then
                    ba = norm(atan2(pcy() - L2Y(self.y), pcx() - L2X(self.x)) + s.da)
                else ba = s.da end
                bs = s.spd
                mag = bs
                s.timer = 0
            else
                mag = bs - s.timer * bs / s.interval
            end
            vel(ba, mag)
            s.timer = s.timer + 1
        end
        if has(active, K_DIR_REL) then dir(K_DIR_REL) end
        if has(active, K_DIR_ABS) then dir(K_DIR_ABS) end
        if has(active, K_DIR_AIM) then dir(K_DIR_AIM) end
        if has(active, K_BOUNCE_ALL) or has(active, K_BOUNCE_BOTTOM) then
            local r = (BT_PX[self._bx_type or 0] or 16) / 2
            if not in_field(self.x, self.y, r) then
                if tsnd >= 0 then sfx(tsnd) end
                if self.x < -192 or self.x >= 192 then ba = norm(-ba - PI) end
                if self.y < -224 or
                   (self.y >= 224 and has(active, K_BOUNCE_ALL)) then ba = -ba end
                local kind = has(active, K_BOUNCE_ALL) and K_BOUNCE_ALL or K_BOUNCE_BOTTOM
                local s = st[kind] or st[K_BOUNCE_ALL]
                bs = s.spd
                vel(ba, bs)
                s.done = s.done + 1
                if s.done >= s.limit then
                    ---原作是 activeTransformFlags &= ~(BOUNCE_ALL|BOUNCE_EXCEPT_BOTTOM)
                    ---（BulletManager.cpp:1423-1427）——**清位**，不是减两个数。
                    ---一条记录只带一个位，减两个会把没设的那个也减掉 →
                    ---active 变负 → has() 全判真（踩过：卡 210 崩在 WAIT 分支）。
                    if has(active, K_BOUNCE_ALL) then active = active - K_BOUNCE_ALL end
                    if has(active, K_BOUNCE_BOTTOM) then active = active - K_BOUNCE_BOTTOM end
                end
            end
        end
        if has(active, K_WAIT) then
            local s = st[K_WAIT]
            if s.timer <= 0 then active = active - K_WAIT
            else s.timer = s.timer - 1 end
        end
    end

    ---出界回收（BulletManager.cpp:855-897）。bound=false 让引擎不要插手。
    ---注意 cull（SET_CULL_DELAY）非 0 时官方**跳过**整套越界判断（:857-862）。
    local function out_of_field()
        if cull ~= 0 then return false end
        local r = (BT_PX[self._bx_type or 0] or 16) / 2
        if in_field(self.x, self.y, r) then offscreen = 0; return false end
        if has(active, K_DIR_REL) or has(active, K_DIR_AIM) or has(active, K_DIR_ABS)
           or has(active, K_BOUNCE_ALL) or has(active, K_BOUNCE_BOTTOM) then
            offscreen = offscreen + 1
            return offscreen >= 0x80
        end
        if offscreen == 0 then return true end
        offscreen = offscreen - 1
        return false
    end

    ---弹的每帧钩子（= BulletManager::OnUpdate 里这颗弹那一段）。
    ---引擎的调用顺序是「先 frame_other、后 x += vx」，所以这里只补差额。
    local function hook(b)
        self = b
        ---scriptedUpdateFreeze（ex26）的还原：上一帧为了拦住引擎的 x += vx
        ---而把速度临时清零，这一帧开头先放回去。
        if b._fz then
            b.vx, b.vy = b._fzvx, b._fzvy
            b._fz = false
        end
        if first then
            first = false
            advance()          -- SpawnSingleBullet 末尾那一次（BulletManager.cpp:264）
        end
        ---ex14 的「解冻」：alpha 0 → 255 走 15 帧（AnmInterpMode_Linear）。
        if b._bx_fade then
            b._bx_fade = b._bx_fade - 1
            b.alpha = 1 - b._bx_fade / 15
            if b._bx_fade <= 0 then b._bx_fade = nil; b.alpha = 1 end
        end
        local ovx, ovy = b.vx, b.vy
        if state == 4 then
            --DESPAWNING：position += velocity/2（:1044-1049），播完回收
            b.x = b.x - ovx * 0.5
            b.y = b.y - ovy * 0.5
            despawn = despawn - 1
            if despawn <= 0 then kill_bullet(b) end
            return
        end
        if state ~= 0 then
            --SPAWNING_FAST/NORMAL/SLOW：position += velocity/2、/2.5、/3
            --（:953-1011）。引擎随后还会按整速积分一次，所以这里只补差额。
            local m = 2
            if state == 2 then m = 2.5 elseif state == 3 then m = 3 end
            spawn = spawn - 1
            if spawn <= 0 then
                --动画播完那一帧：先按**旧**速度走 1/m，再跑 FIRED 的全套
                --（:953-1011 的 position += velocity/m 在 AdvanceTransformProgram 之前）
                b.x = b.x + ovx / m
                b.y = b.y + ovy / m
                state = 0
                advance()
                update()
                if out_of_field() then kill_bullet(b) end
            else
                b.x = b.x - ovx * (1 - 1 / m)
                b.y = b.y - ovy * (1 - 1 / m)
            end
            return
        end
        --FIRED
        advance()
        update()
        if cull ~= 0 then cull = cull - 1 end
        if out_of_field() then kill_bullet(b) end
        ---BulletManager.cpp:864-865：FIRED 的弹在 scriptedUpdateFreeze 时不积分位置
        ---（出生/消失动画两段不受影响，:955/:978/:1001/:1023）。
        ---引擎是在 frame_other 之后按 b.vx 积分的，所以只能先把速度藏起来。
        if L.game.scriptedUpdateFreeze then
            b._fz, b._fzvx, b._fzvy = true, b.vx, b.vy
            b.vx, b.vy = 0, 0
        end
    end

    self = NewSimpleBullet(style, ECOLOR(color), X2L(px), Y2L(py), 0, 0, false, 0,
            false, false, false, false, hook)
    self._bx_type = bt
    self._bx_flags = flags
    self._bx_a, self._bx_s = a, speed
    self._bx_phase = 0        -- ex14（铃仙冻结弹）的状态：0 正常 / 1 冻结 / 2 解冻中
    self.bound = false
    if state ~= 0 then
        --出生瞬间位置被扣掉 velocity*4（BulletManager.cpp:226/235/247）
        setv(a, speed)
        self.x = self.x - self.vx * 4
        self.y = self.y - self.vy * 4
    end
    POOL[#POOL + 1] = self
    pool_live = pool_live + 1
    return self
end

---本卡还在场上的弹数（= 官方 activeBulletCount）。
local function bullets_alive() return pool_count() end

L.BT_STYLE, L.BT_PX, L.ECOLOR, L.SPAWN_FRAMES = BT_STYLE, BT_PX, ECOLOR, SPAWN_FRAMES
L.POOL_SIZE = POOL_SIZE
---全池扫描用的登记表（ex12/ex14/ex27 要按 transformFlags 扫全场小弹）。
---死弹留在数组里、用 _dead 判，调用方要自己跳过。
L.POOL = POOL
L.pool_reset, L.pool_full, L.kill_bullet = pool_reset, pool_full, kill_bullet
L.clear_bullets = clear_bullets
L.bullets_alive = pool_count
L.in_field = in_field
L.has, L.norm, L.tr = has, norm, tr
L.make_bullet = make_bullet
L.K = {
    DECEL = K_DECEL, SPAWN_FAST = K_SPAWN_FAST, SPAWN_NORMAL = K_SPAWN_NORMAL,
    SPAWN_SLOW = K_SPAWN_SLOW, ACC_VEC = K_ACC_VEC, ACC_POLAR = K_ACC_POLAR,
    DIR_REL = K_DIR_REL, DIR_AIM = K_DIR_AIM, DIR_ABS = K_DIR_ABS,
    SPAWN_SOUND = K_SPAWN_SOUND, BOUNCE_ALL = K_BOUNCE_ALL,
    BOUNCE_BOTTOM = K_BOUNCE_BOTTOM, CANCEL_IMMUNE = K_CANCEL_IMMUNE,
    CULL = K_CULL, SPRITE = K_SPRITE, WAIT = K_WAIT, DESPAWN = K_DESPAWN,
    SOUND = K_SOUND, EX_MARKER = K_EX_MARKER,
}
end
do
local has, make_bullet, pool_full = L.has, L.make_bullet, L.pool_full
local player_is_youkai = L.player_is_youkai
local VectorAngle, RAN_F32 = L.VectorAngle, L.RAN_F32

---------------------------------------------------------------
-- 出弹：DispatchShotInstruction（EclDependencies.cpp:693-788）
--      + SpawnBulletPattern / SpawnSingleBullet（BulletManager.cpp:685-712、84-280）
---------------------------------------------------------------
---descriptor->aimMode = opcode - 96（EclDependencies.cpp:722-723），
---也就是 BulletAimMode 的 9 个值（BulletManager.hpp:167-177）。
local AIM_FAN_AIMED, AIM_FAN = 0, 1
local AIM_CIRCLE_AIMED, AIM_CIRCLE = 2, 3
local AIM_OFFCIRCLE_AIMED, AIM_OFFCIRCLE = 4, 5
local AIM_RAND_ANGLE, AIM_RAND_SPEED, AIM_RANDOM = 6, 7, 8

---一个出弹者的持久状态 = Enemy::bulletSpawnDescriptor 里被
---ins_110/111/113 改的那部分（shootOffset、18 个 transform 槽、音效）。
---出厂默认值见 EnemyManager.cpp:187-188。
local function new_gun()
    return { ox = 0, oy = 0, records = {},
             spawn_sound = 7, transform_sound = 25 }
end

---出弹的三道「不开火」闸门：
---   · life <= 0 不出弹（EclRunHigh.inl:219-220，在跑 DispatchShotInstruction 之前）
---   · 弹 flags 带 ONLY_WHEN_PLAYER_YOUKAI / ONLY_WHEN_PLAYER_HUMAN 而自机状态不符
---   · minimumPlayerDistanceSquared > 0 且自机比它更近
---（后两道在 DispatchShotInstruction 里，EclDependencies.cpp:700-712；第三道由
---ins_82 设置。17 张卡都是打不破的耐久卡、life 恒 > 0，且 ins_82 一次没用过，
---所以这三道实际上都不会拦下任何一波 —— 照原作写全而已。）
local function shot_allowed(a, flags)
    if a.life <= 0 then return false end
    if has(flags, 0x8000) and not player_is_youkai() then return false end
    if has(flags, 0x10000) and player_is_youkai() then return false end
    if a.minplayer2 > 0 then
        local dx = a.wx - pcx()
        local dy = a.wy - pcy()
        if dx * dx + dy * dy < a.minplayer2 then return false end
    end
    return true
end

---一整波出弹（BulletManager::SpawnBulletPattern，:685-712）。
---gun 是出弹者的描述符；ax/ay 是出弹者的 worldPosition（TH08 坐标）。
---mode = opcode-96；bt/color/c1/c2 是整数；sp1/sp2 是每帧像素；
---ang/step 是 TH08 弧度；flags 是本次波次的 transformFlags。
local function shoot(gun, ax, ay, mode, bt, color, c1, c2, sp1, sp2, ang, step, flags)
    --descriptor->position = enemy->worldPosition + shootOffset（:717-720）
    local px = ax + gun.ox
    local py = ay + gun.oy
    --AngleToPoint（Player.cpp:965-982 的 VectorAngle(py-y, px-x)）
    local a2p = VectorAngle(pcy() - py, pcx() - px)

    --池满时整波连一颗都不生、音效也不响（:688-690 的提前 return）
    if pool_full() then return end
    for j = 0, c2 - 1 do
        for i = 0, c1 - 1 do
            --speed = sp1 - (sp1-sp2)*j/c2（count2 > 1 时；:103-107）
            local speed
            if c2 > 1 then speed = sp1 - (sp1 - sp2) * j / c2 else speed = sp1 end
            local angle = 0
            if mode == AIM_FAN_AIMED or mode == AIM_FAN then
                --Fan 的奇偶规则见 BulletManager.cpp:110-121（整数除法！）
                if (c1 % 2) ~= 0 then
                    angle = angle + floor((i + 1) / 2) * step
                else
                    angle = angle + floor(i / 2) * step + step * 0.5
                end
                if (i % 2) ~= 0 then angle = -angle end
                if mode == AIM_FAN_AIMED then angle = angle + a2p end
                angle = angle + ang
            elseif mode == AIM_CIRCLE_AIMED or mode == AIM_CIRCLE then
                if mode == AIM_CIRCLE_AIMED then angle = angle + a2p end
                angle = angle + i * (PI * 2) / c1
                angle = angle + j * step + ang
            elseif mode == AIM_OFFCIRCLE_AIMED or mode == AIM_OFFCIRCLE then
                if mode == AIM_OFFCIRCLE_AIMED then angle = angle + a2p end
                angle = angle + PI / c1
                angle = angle + i * (PI * 2) / c1
                angle = angle + ang
            elseif mode == AIM_RAND_ANGLE then
                angle = RAN_F32(ang - step) + step
            elseif mode == AIM_RAND_SPEED then
                speed = RAN_F32(sp1 - sp2) + sp2
                angle = angle + i * (PI * 2) / c1
                angle = angle + j * step + ang
            elseif mode == AIM_RANDOM then
                angle = RAN_F32(ang - step) + step
                speed = RAN_F32(sp1 - sp2) + sp2
            end
            --某一颗生不出来 → 整波剩下的放弃（:700-703 的 goto doneSpawning）
            if make_bullet(gun, px, py, bt, color, speed, angle, flags) == nil then
                goto done_spawning
            end
        end
    end
    ::done_spawning::
    --音效是整波一次、而且失败也照响（:707-709）
    if has(flags, 0x200) then sfx_at(gun.spawn_sound, px) end
end

L.AIM_FAN_AIMED, L.AIM_FAN = AIM_FAN_AIMED, AIM_FAN
L.AIM_CIRCLE_AIMED, L.AIM_CIRCLE = AIM_CIRCLE_AIMED, AIM_CIRCLE
L.AIM_OFFCIRCLE_AIMED, L.AIM_OFFCIRCLE = AIM_OFFCIRCLE_AIMED, AIM_OFFCIRCLE
L.shoot, L.new_gun, L.shot_allowed = shoot, new_gun, shot_allowed
end

---------------------------------------------------------------
---ECL 虚拟机
---------------------------------------------------------------
---把 L.RAW[card] 的程序文本解析成子程序表，然后按 th08full 的 RunEcl 语义执行。
---一条指令在内部分成三个平行数组（下标从 1）：
---  T[i] 时间（帧）      O[i] opcode      M[i] difficultyMask
---  A[i][k] 第 k 个操作数的原始值（k 从 0）  V[i][k] 该操作数是否「带变量标志」
---  J[i][k] 跳转类操作数换算成的子程序内指令下标（1 基）
---规则来自 EclRawInstruction 的 wire 格式：操作数原始值 + operandFlags 位掩码，
---第 k 位 = 第 k 个操作数是否要走 EclOperands 解析（EclRunLow.inl:88-135）。
---------------------------------------------------------------
do
local RAW = L.RAW
local floor, abs, sqrt, cos, sin, atan2 = floor, abs, sqrt, cos, sin, atan2
local PI, TWO_PI = PI, TWO_PI
local toint = L.toint
local VectorAngle, AddNormalizeAngle = L.VectorAngle, L.AddNormalizeAngle
local RAN_F32 = L.RAN_F32
local game = L.game

---g_GameManager.difficultyMask：Last Word 是 AllDifficulties → 0xf
---（GameManager.cpp:709-711，difficulty >= EXTRA 时 mask = 0xf）。
local DMASK = 15
L.DMASK = DMASK

---------------------------------------------------------------------
-- 1. 解析器
---------------------------------------------------------------------
local PROG = {}
local function parse_prog(text)
    local subs, cur = {}, nil
    for line in text:gmatch('[^\n]+') do
        if line:sub(1, 1) == '#' then
            cur = { n = 0, T = {}, O = {}, M = {}, A = {}, V = {}, J = {} }
            subs[tonumber(line:sub(2))] = cur
        elseif cur ~= nil then
            local n = cur.n + 1
            cur.n = n
            local k, av, vv, jv = -1, {}, {}, {}
            for w in line:gmatch('%S+') do
                k = k + 1
                if k == 0 then cur.T[n] = tonumber(w)
                elseif k == 1 then cur.O[n] = tonumber(w)
                elseif k == 2 then cur.M[n] = tonumber(w)
                else
                    local o, c = k - 3, w:sub(1, 1)
                    if c == 'v' then
                        av[o], vv[o] = tonumber(w:sub(2)), true
                    elseif c == '@' then
                        jv[o], av[o] = tonumber(w:sub(2)) + 1, 0
                    else
                        av[o] = tonumber(w)
                    end
                end
            end
            cur.A[n], cur.V[n], cur.J[n] = av, vv, jv
        end
    end
    return subs
end

local function get_prog(card)
    local p = PROG[card]
    if p == nil then
        p = parse_prog(RAW[card])
        PROG[card] = p
    end
    return p
end
L.get_prog = get_prog
---子程序不存在时返回一个空程序（原作 subTable[subId] 为 NULL 会直接崩，
---这里返回空表只是防御；正常情况下不会走到）。
local function sub_of(card, id)
    local p = get_prog(card)
    return p[id] or { n = 0, T = {}, O = {}, M = {}, A = {}, V = {}, J = {} }
end
L.sub_of = sub_of

---------------------------------------------------------------------
-- 2. 变量读写（EclOperandsInt.cpp / EclOperandsFloat.cpp）
---------------------------------------------------------------------
---id 常量（EclManager.hpp:400-506）。只写本文件会碰到的。
---  10000-10007 LOCAL_INT          10008-10015 ENEMY_INT
---  10016-10023 LOCAL_FLOAT        10024-10031 ENEMY_FLOAT
---  10032..10035 随机数            10036-10039 EXTRA_INT
---  10040 DIFFICULTY  10041 RANK   10042/43/44 ENEMY_POSITION_XYZ（float 版读 worldPosition）
---  10045/46/47 PLAYER_POSITION    10048 ANGLE_TO_PLAYER  10049 BOSS_TIMER
---  10050 DISTANCE_TO_PLAYER       10051 LIFE            10052 SHOT_TYPE
---  10053-10056 CALL_INT           10057-10060 CALL_FLOAT
---  10061-10064 SHARED_CALL_INT    10065-10068 SHARED_CALL_FLOAT
---  10069 MOVEMENT_ANGLE 10070 ANGULAR_VELOCITY 10071 SPEED 10072 ACCELERATION
---  10073 ORBIT_RADIUS 10074/75/76 INTERPOLATION_ORIGIN_XYZ
---  10077 ORBIT_ANGLE 10078 ORBIT_ANGULAR_VELOCITY
---  10079/80/81 INTERPOLATION_DELTA_XYZ 10082 RANDOM_ANGLE 10083 LAST_DAMAGE
---  10084 BOSS_SLOT 10085/86/87 LAST_FRAME_DISPLACEMENT_XYZ
---  10088..10091 LIFE_CALLBACK_THRESHOLD_0..3  10092 ITEM_DROP_TYPE 10093 SCORE
---  10094/95 EXTRA_FLOAT 10096 PARENT_CHAIN_DEPTH 10097 PLAYER_IS_YOUKAI
---  10098 TIME_ORB_THRESHOLD_STATE 10099 SPELL_CAPTURE_STATE 10100 SPELL_TIMER_FRAMES
---未列出的 id：Resolve* 的 default 分支**原样返回操作数**（EclOperandsInt.cpp:148）。
local function angle_to_player(act)
    local dx, dy = L.pcx() - act.wx, L.pcy() - act.wy
    if dy == 0 and dx == 0 then return PI / 2 end
    return VectorAngle(dy, dx)
end
local function dist_to_player(act)
    local dx, dy = L.pcx() - act.wx, L.pcy() - act.wy
    return sqrt(dx * dx + dy * dy)
end

local function geti(act, ctx, id)
    if id >= 10000 and id <= 10007 then return ctx.iv[id - 9999] end
    if id >= 10008 and id <= 10015 then return act.eiv[id - 10007] end
    if id >= 10016 and id <= 10023 then return toint(ctx.fv[id - 10015]) end
    if id >= 10024 and id <= 10031 then return toint(act.efv[id - 10023]) end
    if id == 10032 then return toint(ran:Int(0, 2147483647)) end
    if id == 10033 then return toint(ran:Float(0, 1)) end
    if id == 10034 then return toint(ran:Int(-2147483648, 2147483647)) end
    if id == 10035 then return toint(ran:Float(-1, 1)) end
    if id >= 10036 and id <= 10039 then return ctx.eiv[id - 10035] end
    if id == 10040 then return game.difficulty end
    if id == 10041 then return game.rank end
    if id == 10042 then return toint(act.wx) end
    if id == 10043 then return toint(act.wy) end
    if id == 10044 then return toint(act.wz) end
    if id == 10045 then return toint(L.pcx()) end
    if id == 10046 then return toint(L.pcy()) end
    if id == 10047 then return 0 end
    if id == 10048 then return toint(angle_to_player(act)) end
    if id == 10049 then return toint(act.bossTimer) end
    if id == 10050 then return toint(dist_to_player(act)) end
    if id == 10051 then return act.life end
    if id == 10052 then return 0 end
    if id >= 10053 and id <= 10056 then return ctx.cpi[id - 10052] end
    if id >= 10057 and id <= 10060 then return toint(ctx.cpf[id - 10056]) end
    if id >= 10061 and id <= 10064 then return game.sharedI[id - 10060] end
    if id >= 10065 and id <= 10068 then return toint(game.sharedF[id - 10064]) end
    if id == 10069 then return toint(act.mangle) end
    if id == 10070 then return toint(act.angvel) end
    if id == 10071 then return toint(act.speed) end
    if id == 10072 then return toint(act.accel) end
    if id == 10073 then return toint(act.orbitR) end
    if id == 10074 then return toint(act.iox) end
    if id == 10075 then return toint(act.ioy) end
    if id == 10076 then return toint(act.ioz) end
    if id == 10077 then return toint(act.orbitAngle) end
    if id == 10078 then return toint(act.orbitAngvel) end
    if id == 10079 then return toint(act.lfx) end
    if id == 10080 then return toint(act.lfy) end
    if id == 10081 then return toint(act.lfz) end
    if id == 10082 then return toint(RAN_F32(TWO_PI) - PI) end
    if id == 10083 then return toint(act.lastDamage) end
    if id == 10084 then return act.bossSlot end
    if id == 10085 then return toint(act.lfx) end
    if id == 10086 then return toint(act.lfy) end
    if id == 10087 then return toint(act.lfz) end
    if id >= 10088 and id <= 10091 then return act.lifeCb[id - 10087] end
    if id == 10092 then return act.itemDrop end
    if id == 10093 then return act.score end
    if id == 10094 then return toint(ctx.efv[1]) end
    if id == 10095 then return toint(ctx.efv[2]) end
    if id == 10096 then return act.chainDepth or 0 end
    if id == 10097 then return L.player_is_youkai() and 1 or 0 end
    if id == 10098 then return 0 end
    if id == 10099 then return 1 end
    if id == 10100 then return act.timer end
    return id
end
L.geti = geti

local function getf(act, ctx, id)
    if id >= 10000 and id <= 10007 then return ctx.iv[id - 9999] end
    if id >= 10008 and id <= 10015 then return act.eiv[id - 10007] end
    if id >= 10016 and id <= 10023 then return ctx.fv[id - 10015] end
    if id >= 10024 and id <= 10031 then return act.efv[id - 10023] end
    if id == 10032 then return floor(ran:Float(0, 2147483647)) end
    if id == 10033 then return ran:Float(0, 1) end
    if id == 10034 then return toint(ran:Int(-2147483648, 2147483647)) end
    if id == 10035 then return ran:Float(-1, 1) end
    if id >= 10036 and id <= 10039 then return ctx.eiv[id - 10035] end
    if id == 10040 then return game.difficulty end
    if id == 10041 then return game.rank end
    if id == 10042 then return act.wx end
    if id == 10043 then return act.wy end
    if id == 10044 then return act.wz end
    if id == 10045 then return L.pcx() end
    if id == 10046 then return L.pcy() end
    if id == 10047 then return 0 end
    if id == 10048 then return angle_to_player(act) end
    if id == 10049 then return act.bossTimer end
    if id == 10050 then return dist_to_player(act) end
    if id == 10051 then return act.life end
    if id == 10052 then return 0 end
    if id >= 10053 and id <= 10056 then return ctx.cpi[id - 10052] end
    if id >= 10057 and id <= 10060 then return ctx.cpf[id - 10056] end
    if id >= 10061 and id <= 10064 then return game.sharedI[id - 10060] end
    if id >= 10065 and id <= 10068 then return game.sharedF[id - 10064] end
    if id == 10069 then return act.mangle end
    if id == 10070 then return act.angvel end
    if id == 10071 then return act.speed end
    if id == 10072 then return act.accel end
    if id == 10073 then return act.orbitR end
    if id == 10074 then return act.iox end
    if id == 10075 then return act.ioy end
    if id == 10076 then return act.ioz end
    if id == 10077 then return act.orbitAngle end
    if id == 10078 then return act.orbitAngvel end
    if id == 10079 then return act.idx_ end
    if id == 10080 then return act.idy end
    if id == 10081 then return act.idz end
    if id == 10082 then return RAN_F32(TWO_PI) - PI end
    if id == 10083 then return act.lastDamage end
    if id == 10084 then return act.bossSlot end
    if id == 10085 then return act.lfx end
    if id == 10086 then return act.lfy end
    if id == 10087 then return act.lfz end
    if id >= 10088 and id <= 10091 then return act.lifeCb[id - 10087] end
    if id == 10092 then return act.itemDrop end
    if id == 10093 then return act.score end
    if id == 10094 then return ctx.efv[1] end
    if id == 10095 then return ctx.efv[2] end
    if id == 10096 then return act.chainDepth or 0 end
    if id == 10097 then return L.player_is_youkai() and 1 or 0 end
    if id == 10098 then return 0 end
    if id == 10099 then return 1 end
    if id == 10100 then return act.timer end
    return id
end
L.getf = getf

---ResolveIntLValue 的可写集合（EclOperandsInt.cpp:160-197）。
local function seti(act, ctx, id, v)
    if id >= 10000 and id <= 10007 then ctx.iv[id - 9999] = v
    elseif id >= 10008 and id <= 10015 then act.eiv[id - 10007] = v
    elseif id >= 10053 and id <= 10056 then ctx.cpi[id - 10052] = v
    elseif id >= 10036 and id <= 10039 then ctx.eiv[id - 10035] = v
    elseif id == 10040 then game.difficulty = v
    elseif id == 10041 then game.rank = v
    elseif id == 10049 then act.bossTimer = v
    elseif id == 10051 then act.life = v
    elseif id == 10092 then act.itemDrop = v
    elseif id == 10093 then act.score = v
    elseif id >= 10061 and id <= 10064 then game.sharedI[id - 10060] = v
    end
end

---ResolveFloatLValue 的可写集合（EclOperandsFloat.cpp:158-210）。
local function setf(act, ctx, id, v)
    if id >= 10016 and id <= 10023 then ctx.fv[id - 10015] = v
    elseif id >= 10024 and id <= 10031 then act.efv[id - 10023] = v
    elseif id >= 10057 and id <= 10060 then ctx.cpf[id - 10056] = v
    elseif id == 10042 then act.x = v
    elseif id == 10043 then act.y = v
    elseif id == 10044 then act.z = v
    elseif id == 10045 then player.x = v - 192
    elseif id == 10046 then player.y = 224 - v
    elseif id == 10047 then
    elseif id == 10094 then ctx.efv[1] = v
    elseif id == 10095 then ctx.efv[2] = v
    elseif id >= 10065 and id <= 10068 then game.sharedF[id - 10064] = v
    elseif id == 10074 then act.iox = v
    elseif id == 10075 then act.ioy = v
    elseif id == 10076 then act.ioz = v
    elseif id == 10079 then act.idx_ = v
    elseif id == 10080 then act.idy = v
    elseif id == 10081 then act.idz = v
    elseif id == 10069 then act.mangle = v
    elseif id == 10070 then act.angvel = v
    elseif id == 10071 then act.speed = v
    elseif id == 10072 then act.accel = v
    elseif id == 10073 then act.orbitR = v
    elseif id == 10077 then act.orbitAngle = v
    elseif id == 10078 then act.orbitAngvel = v
    end
end
L.seti, L.setf = seti, setf

---------------------------------------------------------------------
-- 3. 操作数读取 / 写入
---------------------------------------------------------------------
---ReadInt/ReadFloat：带标志才解析，否则用原始值（EclRunLow.inl:100-128）。
local function RI(act, ctx, sub, i, k)
    local a = sub.A[i]
    local v = a[k]
    if v == nil then return 0 end
    if sub.V[i][k] then return geti(act, ctx, v) end
    return v
end
local function RF(act, ctx, sub, i, k)
    local a = sub.A[i]
    local v = a[k]
    if v == nil then return 0 end
    if sub.V[i][k] then return getf(act, ctx, v) end
    return v
end
---WriteInt/WriteFloat：未带标志时原作写进**指令内存**（等于没效果），
---所以这里直接忽略（EclOperandsInt.cpp:161-164）。
local function WI(act, ctx, sub, i, k, v)
    if sub.V[i][k] then seti(act, ctx, sub.A[i][k], v) end
end
local function WF(act, ctx, sub, i, k, v)
    if sub.V[i][k] then setf(act, ctx, sub.A[i][k], v) end
end
L.RI, L.RF, L.WI, L.WF = RI, RF, WI, WF
local RAWI = function(sub, i, k) return sub.A[i][k] or 0 end

---------------------------------------------------------------------
-- 4. context
---------------------------------------------------------------------
local function new_slots()
    local s = {}
    for j = 1, 8 do s[j] = nil end
    return s
end

local function new_ctx(sub, act, slot)
    return {
        sub = sub, n = sub.n, act = act,
        pc = 1, t = 0, sec = 0,
        iv = { 0, 0, 0, 0, 0, 0, 0, 0 },
        fv = { 0, 0, 0, 0, 0, 0, 0, 0 },
        eiv = { 0, 0, 0, 0 },
        efv = { 0, 0 },
        cpi = { 0, 0, 0, 0 }, cpf = { 0, 0, 0, 0 },
        cb = nil, cbi = nil,
        slots = new_slots(),
        stack = {}, depth = 0,
        slot = slot or 0,
    }
end
L.new_ctx = new_ctx

local function copy_slots(dst, src)
    for j = 1, 8 do
        local e = src[j]
        if e == nil then dst[j] = nil
        else
            dst[j] = { timer = e.timer, duration = e.duration, easing = e.easing,
                       cb = e.cb, affected = e.affected,
                       p0 = e.p0, p1 = e.p1, p2 = e.p2, p3 = e.p3 }
        end
    end
end

---CALL：整份 context 存栈（EclDependencies.cpp:472-503）。
local function do_call(act, ctx, subId, parent_sub)
    ---currentInstr 先推进到 CALL 的下一条。
    ctx.pc = ctx.pc + 1
    if not act.disableCallStack then
        local e = {
            sub = ctx.sub, pc = ctx.pc, t = ctx.t, sec = ctx.sec,
            iv = { unpack(ctx.iv) }, fv = { unpack(ctx.fv) },
            eiv = { unpack(ctx.eiv) }, efv = { unpack(ctx.efv) },
            cpi = { unpack(ctx.cpi) }, cpf = { unpack(ctx.cpf) },
            cb = ctx.cb, cbi = ctx.cbi, slots = new_slots(),
        }
        copy_slots(e.slots, ctx.slots)
        ctx.stack[ctx.depth] = e
        if ctx.depth < 15 then ctx.depth = ctx.depth + 1 end
    end
    ---CallEclSub：只换 currentInstr / time / secondaryTime / subId，
    ---**不动 intVariables 等**（EclManager.cpp:69-79）。
    local sub = L.sub_of(act.card, subId)
    ctx.sub, ctx.n = sub, sub.n
    ctx.pc, ctx.t, ctx.sec = 1, 0, 0
    ---CALL 的瞬间把 g_EclCallParameters 整份拷进本 context 的 10053..10068。
    for j = 1, 4 do ctx.cpi[j] = game.sharedI[j]; ctx.cpf[j] = game.sharedF[j] end
end

---RETURN：弹出（EclDependencies.cpp:505-538）。
---返回 "restart"（恢复了调用方）或 "next_context"（释放了一个 child context）。
local function do_return(act, ctx)
    ctx.depth = ctx.depth - 1
    if ctx.depth < 0 then
        if ctx.slot > 0 and act.childs[ctx.slot] == ctx then
            act.childs[ctx.slot] = nil
            return "next_context"
        end
        return "frame_end"
    end
    local e = ctx.stack[ctx.depth]
    ctx.sub, ctx.n = e.sub, e.sub.n
    ctx.pc, ctx.t, ctx.sec = e.pc, e.t, e.sec
    for j = 1, 8 do ctx.iv[j], ctx.fv[j] = e.iv[j], e.fv[j] end
    for j = 1, 4 do ctx.eiv[j] = e.eiv[j]; ctx.cpi[j] = e.cpi[j] end
    for j = 1, 2 do ctx.efv[j] = e.efv[j] end
    for j = 1, 4 do ctx.cpf[j] = e.cpf[j] end
    ctx.cb, ctx.cbi = e.cb, e.cbi
    copy_slots(ctx.slots, e.slots)
    return "restart"
end

---------------------------------------------------------------------
-- 5. 插值槽（EclRun.cpp:118-172 / EclDependencies.cpp:285-383）
---------------------------------------------------------------------
local function ease(progress, mode)
    if mode == 1 then return progress * progress
    elseif mode == 2 then return progress * progress * progress
    elseif mode == 3 then return progress * progress * progress * progress
    elseif mode == 4 then return 1 - (1 - progress) * (1 - progress)
    elseif mode == 5 then
        local q = 1 - progress; return 1 - q * q * q
    elseif mode == 6 then
        local q = 1 - progress; return 1 - q * q * q * q
    end
    return progress
end

---InterpolateLinear（EclDependencies.cpp:303-319）：参数总是走 ResolveFloat。
local function slot_linear(act, ctx, e, t)
    local a, b = getf(act, ctx, e.p0), getf(act, ctx, e.p1)
    setf(act, ctx, e.affected, (b - a) * t + a)
end
local function slot_hermite(act, ctx, e, t)
    local P = { e.p0, e.p1, e.p2, e.p3 }
    local par = {}
    for k = 1, 4 do
        par[k] = getf(act, ctx, P[k])
    end
    local w0 = (t - 1) * (t - 1) * (2 * t + 1)
    local w1 = t * t * (3 - 2 * t)
    local w2 = (1 - t) * (1 - t) * t
    local w3 = (t - 1) * t * t
    setf(act, ctx, e.affected, w0 * par[1] + w1 * par[2] + w2 * par[3] + w3 * par[4])
end

local function ins_36(act, ctx, i, sub)
    ---affectedVariable 用的是**操作数 0 的原始位**（EclDependencies.cpp:372），
    ---不是解析后的值；数据里它写成 v10042 只是「带标志的字面 10042.0」。
    local affected = RAWI(sub, i, 0)
    local slot
    for j = 1, 8 do
        local e = ctx.slots[j]
        if e == nil or e.cb == nil or e.affected == affected then slot = j; break end
    end
    if slot == nil then return end
    local e = ctx.slots[slot] or {}
    ctx.slots[slot] = e
    e.affected = affected
    e.timer = 0
    e.duration = RI(act, ctx, sub, i, 1)
    local cbi = RI(act, ctx, sub, i, 2)
    e.easing = RI(act, ctx, sub, i, 3)
    e.cbi = cbi
    e.cb = (cbi == 7) and slot_hermite or slot_linear
    e.p0 = RAWI(sub, i, 4)
    e.p1 = RAWI(sub, i, 5)
    e.p2 = RAWI(sub, i, 6)
    e.p3 = RAWI(sub, i, 7)
end

local function tail(act, ctx)
    if act.life > 0 then
        if ctx.cb then ctx.cb(act, ctx, ctx.cbi) end
        local savedX, savedY = act.x, act.y
        local restore = false
        for j = 1, 8 do
            local e = ctx.slots[j]
            if e and e.cb then
                e.timer = e.timer + 1
                if e.timer >= e.duration then e.timer = e.duration end
                local progress
                if e.duration > 0 then progress = e.timer / e.duration else progress = 1 end
                progress = ease(progress, e.easing)
                e.cb(act, ctx, e, progress)
                if e.timer >= e.duration then e.cb = nil end
                if e.affected == 10042 or e.affected == 10043 or e.affected == 10044 then
                    restore = true
                end
            end
        end
        if restore then
            act.vx = act.x - savedX
            act.vy = act.y - savedY
            act.mangle = VectorAngle(act.vy, act.vx)
            act.x, act.y = savedX, savedY
        end
    end
    ctx.t = ctx.t + 1
end
L.tail = tail

---------------------------------------------------------------------
-- 6. 场地/移动辅助
---------------------------------------------------------------------
local function clamp_position(act)
    if act.clampPos then
        if act.x < act.bounds.x1 then act.x = act.bounds.x1
        elseif act.x > act.bounds.x2 then act.x = act.bounds.x2 end
        if act.y < act.bounds.y1 then act.y = act.bounds.y1
        elseif act.y > act.bounds.y2 then act.y = act.bounds.y2 end
    end
end
L.clamp_position = clamp_position

---ConfigureRelativeMotion（EclHelpers.cpp:66-90）：ins_64。
local function conf_relative(act, ctx, sub, i)
    act.idx_ = RF(act, ctx, sub, i, 2) - act.wx
    act.idy = RF(act, ctx, sub, i, 3) - act.wy
    act.idz = 0
    act.iox, act.ioy, act.ioz = act.x, act.y, act.z
    act.moveDuration = RI(act, ctx, sub, i, 0)
    act.moveTimer = act.moveDuration
    act.moveEasing = RI(act, ctx, sub, i, 1)
    act.moveMode = 2
    act.vx, act.vy, act.vz = 0, 0, 0
    if act.mirrorX then act.idx_ = -act.idx_ end
end

---ConfigurePolarMotion（EclHelpers.cpp:34-64）：ins_66/69 的有限极坐标段。
local function conf_polar(act, ctx, sub, i)
    local angle = AddNormalizeAngle(RF(act, ctx, sub, i, 2), 0)
    local dur = RI(act, ctx, sub, i, 0)
    local spd = RF(act, ctx, sub, i, 3)
    act.idx_ = cos(angle) * spd * dur
    act.idy = sin(angle) * spd * dur
    act.idz = 0
    act.iox, act.ioy, act.ioz = act.wx, act.wy, act.wz
    act.moveDuration = dur
    act.moveTimer = dur
    act.moveEasing = RI(act, ctx, sub, i, 1)
    act.moveMode = 2
    if act.mirrorX then act.idx_ = -act.idx_ end
end

---BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：ins_67。
local function begin_boundary_move(act, ctx, sub, i)
    local angle
    if L.pcx() < act.x then
        angle = AddNormalizeAngle(RAN_F32(1.5707964) + 2.3561945, 0)
    else
        angle = RAN_F32(1.5707964) - 0.78539819
    end
    if act.x < act.bounds.x1 + 96 then
        if angle > 1.5707964 then angle = PI - angle
        elseif angle < -1.5707964 then angle = -PI - angle end
    end
    if act.x > act.bounds.x2 - 96 then
        if angle < 1.5707964 and angle >= 0 then angle = PI - act.mangle
        elseif angle > -1.5707964 and angle <= 0 then angle = -PI - angle end
    end
    if act.y < act.bounds.y1 + 48 and angle < 0 then angle = -angle end
    if act.y > act.bounds.y2 - 48 and angle > 0 then angle = -angle end
    if RI(act, ctx, sub, i, 0) <= 0 then
        act.mangle = angle
        act.speed = RF(act, ctx, sub, i, 2)
        act.moveMode = 1
        act.moveDuration, act.moveTimer = 0, 0
    else
        ---StartTimedPolarDisplacement（EclDependencies.cpp:105-125）
        local dur = RI(act, ctx, sub, i, 0)
        local spd = RF(act, ctx, sub, i, 2)
        act.idx_ = cos(angle) * spd * dur
        act.idy = sin(angle) * spd * dur
        act.idz = 0
        act.iox, act.ioy, act.ioz = act.wx, act.wy, act.wz
        act.moveDuration, act.moveTimer = dur, dur
        act.moveEasing = RI(act, ctx, sub, i, 1)
        act.moveMode = 2
    end
end
L.conf_relative, L.conf_polar, L.begin_boundary_move = conf_relative, conf_polar, begin_boundary_move
L.new_slots, L.copy_slots = new_slots, copy_slots
L.do_call, L.do_return, L.ins_36, L.ease = do_call, do_return, ins_36, ease
end

---------------------------------------------------------------
---ECL 指令体（原作对应代码在 EclRunLow.inl / EclRunHigh.inl / EclDependencies.cpp）
---------------------------------------------------------------
do
local RI, RF, WI, WF = L.RI, L.RF, L.WI, L.WF
local cos, sin, sqrt, floor = cos, sin, sqrt, floor
local PI, TWO_PI, DEG = PI, TWO_PI, DEG
local toint = L.toint
local VectorAngle, AddNormalizeAngle, RAN_F32 = L.VectorAngle, L.AddNormalizeAngle, L.RAN_F32
local rand_sign = L.rand_sign
local game = L.game

---C 的整数除法/取模（向零截断）。
local function idiv(a, b) if b == 0 then return 0 end; return toint(a / b) end
local function imod(a, b) if b == 0 then return 0 end; return a - toint(a / b) * b end

---g_Player.AngleToPoint(pos)（Player.cpp:965-982）。
local function a2p(x, y)
    local dx, dy = L.pcx() - x, L.pcy() - y
    if dy == 0 and dx == 0 then return PI / 2 end
    return VectorAngle(dy, dx)
end

---ScaleIntBasedOnRank（GameManager.cpp）：rank 0..32 在 low..high 之间线性插值。
---17 张卡的 ins_105 全是 0，所以只是语义完整。
local function scale_int_on_rank(low, high)
    return floor(low + (high - low) * game.rank / 32 + 0.5)
end
L.scale_int_on_rank = scale_int_on_rank

local function op_shot(act, ctx, sub, i, op)
    local flags = RI(act, ctx, sub, i, 8)
    if not L.shot_allowed(act, flags) then return end
    L.shoot(act.gun, act.wx, act.wy, op - 96,
            RI(act, ctx, sub, i, 0), RI(act, ctx, sub, i, 1),
            RI(act, ctx, sub, i, 2), RI(act, ctx, sub, i, 3),
            RF(act, ctx, sub, i, 4), RF(act, ctx, sub, i, 5),
            RF(act, ctx, sub, i, 6), RF(act, ctx, sub, i, 7), flags)
end

---------------------------------------------------------------------
-- 指令主分派
---------------------------------------------------------------------
local function exec(ctx, i)
    local act, sub = ctx.act, ctx.sub
    local op = sub.O[i]

    --======= 1..39：流程与算术（EclRunLow.inl:224-383）=======
    if op == 1 then
        ---TERMINATE：RunEcl 返回 ZUN_ERROR → 这个敌机被 Deactivate
        ---（EnemyManagerUpdate.cpp:170-174）。17 张卡里它只出现在**子敌**的
        ---子程序里（实测：205 的 37/38、207 的 58…），根子程序从不 terminate。
        act.dead = true
        return "terminate"
    elseif op == 2 then
        ---SET_SECONDARY_TIME：接下来的 N 帧这个 context 时间冻结。
        ctx.sec = RI(act, ctx, sub, i, 0)
    elseif op == 3 then
        ---NOP（84/85 也落在这里）
    elseif op == 4 or op == 5 then
        if op == 5 then
            ---JUMP_DEC：先自减，>0 才跳（EclRunLow.inl:234-243）
            WI(act, ctx, sub, i, 2, RI(act, ctx, sub, i, 2) - 1)
            if RI(act, ctx, sub, i, 2) > 0 then
                ctx.t = sub.A[i][0]
                ctx.pc = sub.J[i][1]
                return "jumped"
            end
        else
            ---JUMP：time = 操作数 0（原始 int），pc 跳到操作数 1
            ctx.t = sub.A[i][0]
            ctx.pc = sub.J[i][1]
            return "jumped"
        end
    elseif op == 6 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 1))
    elseif op == 7 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 1))
    elseif op == 8 then
        WI(act, ctx, sub, i, 0, rand_sign() * RI(act, ctx, sub, i, 1))
    elseif op == 9 then
        WF(act, ctx, sub, i, 0, rand_sign() * RF(act, ctx, sub, i, 1))
    elseif op == 10 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 0) + RI(act, ctx, sub, i, 1))
    elseif op == 11 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 0) - RI(act, ctx, sub, i, 1))
    elseif op == 12 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 0) * RI(act, ctx, sub, i, 1))
    elseif op == 13 then
        WI(act, ctx, sub, i, 0, idiv(RI(act, ctx, sub, i, 0), RI(act, ctx, sub, i, 1)))
    elseif op == 14 then
        WI(act, ctx, sub, i, 0, imod(RI(act, ctx, sub, i, 0), RI(act, ctx, sub, i, 1)))
    elseif op == 15 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 0) + RF(act, ctx, sub, i, 1))
    elseif op == 16 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 0) - RF(act, ctx, sub, i, 1))
    elseif op == 17 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 0) * RF(act, ctx, sub, i, 1))
    elseif op == 18 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 0) / RF(act, ctx, sub, i, 1))
    elseif op == 19 then
        WF(act, ctx, sub, i, 0, math.fmod(RF(act, ctx, sub, i, 0), RF(act, ctx, sub, i, 1)))
    elseif op == 20 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 1) + RI(act, ctx, sub, i, 2))
    elseif op == 21 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 1) - RI(act, ctx, sub, i, 2))
    elseif op == 22 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 1) * RI(act, ctx, sub, i, 2))
    elseif op == 23 then
        WI(act, ctx, sub, i, 0, idiv(RI(act, ctx, sub, i, 1), RI(act, ctx, sub, i, 2)))
    elseif op == 24 then
        WI(act, ctx, sub, i, 0, imod(RI(act, ctx, sub, i, 1), RI(act, ctx, sub, i, 2)))
    elseif op == 25 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 1) + RF(act, ctx, sub, i, 2))
    elseif op == 26 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 1) - RF(act, ctx, sub, i, 2))
    elseif op == 27 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 1) * RF(act, ctx, sub, i, 2))
    elseif op == 28 then
        WF(act, ctx, sub, i, 0, RF(act, ctx, sub, i, 1) / RF(act, ctx, sub, i, 2))
    elseif op == 29 then
        WF(act, ctx, sub, i, 0, math.fmod(RF(act, ctx, sub, i, 1), RF(act, ctx, sub, i, 2)))
    elseif op == 30 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 0) + 1)
    elseif op == 31 then
        WI(act, ctx, sub, i, 0, RI(act, ctx, sub, i, 0) - 1)
    elseif op == 32 then
        WF(act, ctx, sub, i, 0, sin(RF(act, ctx, sub, i, 1)))
    elseif op == 33 then
        WF(act, ctx, sub, i, 0, cos(RF(act, ctx, sub, i, 1)))
    elseif op == 34 then
        ---POINT_ANGLE：VectorAngle(y2 - y1, x2 - x1)
        WF(act, ctx, sub, i, 0,
           VectorAngle(RF(act, ctx, sub, i, 4) - RF(act, ctx, sub, i, 2),
                       RF(act, ctx, sub, i, 3) - RF(act, ctx, sub, i, 1)))
    elseif op == 35 then
        ---INTERPOLATE_VALUE：dst = (a - b) * t + b
        WF(act, ctx, sub, i, 0,
           (RF(act, ctx, sub, i, 1) - RF(act, ctx, sub, i, 2)) * RF(act, ctx, sub, i, 3)
           + RF(act, ctx, sub, i, 2))
    elseif op == 36 then
        L.ins_36(act, ctx, i, sub)
    elseif op == 37 then
        WF(act, ctx, sub, i, 0, AddNormalizeAngle(RF(act, ctx, sub, i, 0), 0))
    elseif op == 38 then
        local ang = AddNormalizeAngle(RF(act, ctx, sub, i, 2), 0)
        local mag = RF(act, ctx, sub, i, 3)
        WF(act, ctx, sub, i, 0, cos(ang) * mag)
        WF(act, ctx, sub, i, 1, sin(ang) * mag)
    elseif op == 39 then
        local dx = RF(act, ctx, sub, i, 1) - RF(act, ctx, sub, i, 3)
        local dy = RF(act, ctx, sub, i, 2) - RF(act, ctx, sub, i, 4)
        WF(act, ctx, sub, i, 0, sqrt(dx * dx + dy * dy))
    elseif op >= 40 and op <= 51 then
        ---条件跳转（CompareOperands，EclDependencies.cpp:386-452 与
        ---EclRunLow.inl:396-415）。比较顺序是 ==,!=,<,<=,>,>=，int/float 交替；
        ---成功时 time = 操作数 2（原始 int）、pc 跳到操作数 3。
        local k = op - 40
        local cmp, isf = floor(k / 2), (k % 2 == 1)
        local a, b
        if isf then a, b = RF(act, ctx, sub, i, 0), RF(act, ctx, sub, i, 1)
        else a, b = RI(act, ctx, sub, i, 0), RI(act, ctx, sub, i, 1) end
        local yes
        if cmp == 0 then yes = (a == b)
        elseif cmp == 1 then yes = (a ~= b)
        elseif cmp == 2 then yes = (a < b)
        elseif cmp == 3 then yes = (a <= b)
        elseif cmp == 4 then yes = (a > b)
        else yes = (a >= b) end
        if yes then
            ctx.t = sub.A[i][2]
            ctx.pc = sub.J[i][3]
            return "jumped"
        end
    elseif op == 52 then
        L.do_call(act, ctx, sub.A[i][0])
        return "restart"
    elseif op == 53 then
        return L.do_return(act, ctx)

    --======= 54..62：ANM（纯观感；我们没有 TH08 的敌机 ANM，全部只记不画）=======
    elseif op == 54 or op == 55 or op == 56 or op == 57 or op == 58
        or op == 59 or op == 60 or op == 61 or op == 62 then
        if op == 54 then act.anmIdle = RI(act, ctx, sub, i, 0)
        elseif op == 55 then act.anmSeq = RI(act, ctx, sub, i, 0)
        elseif op == 58 then act.anmAlt = RI(act, ctx, sub, i, 0)
        elseif op == 59 then act.anmSeqAlt = RI(act, ctx, sub, i, 0)
        elseif op == 62 then act.anmSpecial = true end

    --======= 63..76：位置与移动（EclRunLow.inl:497-650）=======
    elseif op == 63 then
        act.x = RF(act, ctx, sub, i, 0)
        act.y = RF(act, ctx, sub, i, 1)
        act.z = 0
        L.clamp_position(act)
    elseif op == 64 then
        L.conf_relative(act, ctx, sub, i)
    elseif op == 65 then
        act.mangle = AddNormalizeAngle(RF(act, ctx, sub, i, 0), 0)
        act.speed = RF(act, ctx, sub, i, 1)
        act.moveMode, act.moveDuration, act.moveTimer = 1, 0, 0
    elseif op == 66 then
        if RI(act, ctx, sub, i, 0) <= 0 then
            act.mangle = AddNormalizeAngle(RF(act, ctx, sub, i, 2), 0)
            act.speed = RF(act, ctx, sub, i, 3)
            act.moveMode, act.moveDuration, act.moveTimer = 1, 0, 0
        else
            L.conf_polar(act, ctx, sub, i)
        end
    elseif op == 67 then
        L.begin_boundary_move(act, ctx, sub, i)
    elseif op == 68 then
        act.mangle = AddNormalizeAngle(RF(act, ctx, sub, i, 0), a2p(act.x, act.y))
        act.speed = RF(act, ctx, sub, i, 1)
    elseif op == 69 then
        if RI(act, ctx, sub, i, 0) <= 0 then
            act.mangle = AddNormalizeAngle(RF(act, ctx, sub, i, 2), a2p(act.x, act.y))
            act.speed = RF(act, ctx, sub, i, 3)
            act.moveMode = 1
            act.moveDuration = RI(act, ctx, sub, i, 0)
            act.moveTimer = act.moveDuration
        else
            L.conf_polar(act, ctx, sub, i)
        end
    elseif op == 70 then
        act.angvel = RF(act, ctx, sub, i, 0)
        act.moveMode = 1
    elseif op == 71 then
        act.accel = RF(act, ctx, sub, i, 0)
        act.moveMode = 1
    elseif op == 72 then
        act.moveDuration = RI(act, ctx, sub, i, 0)
        act.moveTimer = act.moveDuration
        act.iox = RF(act, ctx, sub, i, 1)
        act.ioy = RF(act, ctx, sub, i, 2)
        act.orbitAngle = RF(act, ctx, sub, i, 3)
        act.orbitAngvel = RF(act, ctx, sub, i, 4)
        act.orbitR = RF(act, ctx, sub, i, 5)
        act.radialVel = RF(act, ctx, sub, i, 6)
        act.moveMode = 3
    elseif op == 73 then
        act.moveDuration = RI(act, ctx, sub, i, 0)
        act.moveTimer = act.moveDuration
        act.iox, act.ioy, act.ioz = act.x, act.y, act.z
        act.orbitAngle = RF(act, ctx, sub, i, 1)
        act.orbitAngvel = RF(act, ctx, sub, i, 2)
        act.orbitR = 0
        act.radialVel = RF(act, ctx, sub, i, 3)
        act.moveMode = 3
    elseif op == 74 then
        act.moveDuration = RI(act, ctx, sub, i, 0)
        act.moveTimer = act.moveDuration
        act.orbitAngvel = RF(act, ctx, sub, i, 1)
        act.radialVel = RF(act, ctx, sub, i, 2)
        act.moveMode = 3
    elseif op == 75 then
        act.bounds.x1 = RF(act, ctx, sub, i, 0)
        act.bounds.y1 = RF(act, ctx, sub, i, 1)
        act.bounds.x2 = RF(act, ctx, sub, i, 2)
        act.bounds.y2 = RF(act, ctx, sub, i, 3)
        act.clampPos = true
    elseif op == 76 then
        act.clampPos = false
    elseif op == 77 then
        act.hitboxW = RF(act, ctx, sub, i, 0)
        act.hitboxH = RF(act, ctx, sub, i, 1)
    elseif op == 78 then
        act.hitbox2W = RF(act, ctx, sub, i, 0)
        act.hitbox2H = RF(act, ctx, sub, i, 1)
    elseif op == 79 or op == 80 or op == 81 then
        local f = RI(act, ctx, sub, i, 0)
        act.interact = f
    elseif op == 82 then
        local d = RF(act, ctx, sub, i, 0)
        act.minplayer2 = d * d
    elseif op == 83 then
        ---SET_FORM_EFFECT_ENABLED：子机外形的特效开关，纯观感。
    elseif op == 87 then
        ---SET_REMOTE_FLOAT：写 bosses[RI(2)] 的某个 float 变量。bosses[0] = 根敌机。
        local idx = RI(act, ctx, sub, i, 2)
        if idx == 0 and L.root_actor ~= nil then
            local v
            if sub.V[i][1] then v = L.getf(L.root_actor, L.root_actor.main, sub.A[i][1])
            else v = sub.A[i][1] end
            WI(act, ctx, sub, i, 0, v)
            WF(act, ctx, sub, i, 0, v)
        end

    --======= 90..95：子敌 =======
    elseif op == 90 or op == 91 or op == 92 or op == 93 or op == 94 then
        ---两组操作数布局**不一样**，别混：
        ---  90/91/92 走 SpawnChildAtScriptPosition/ParentOffset（EclDependencies.cpp:585-654）
        ---    → 0=subId, 1=x, 2=y, 3=life, 4=itemDrop, 5=score，**z 硬编码 0**。
        ---  93/94 走 EclRunHigh.inl:783-855 的 SpawnPacketTyped
        ---    → 0=subId, 1=x, 2=y, **3=z**, 4=life, 5=itemDrop, 6=score。
        ---（93 在 17 张卡里出现 56 次、94 出现 17 次，是主力；写错一位整套卡都不对。）
        if act.life > 0 then
            local sx, sy = RF(act, ctx, sub, i, 1), RF(act, ctx, sub, i, 2)
            local sz, li, idp, sc
            if op >= 93 then
                sz = RF(act, ctx, sub, i, 3)
                li, idp, sc = RI(act, ctx, sub, i, 4), RI(act, ctx, sub, i, 5),
                              RI(act, ctx, sub, i, 6)
            else
                sz = 0
                li, idp, sc = RI(act, ctx, sub, i, 3), RI(act, ctx, sub, i, 4),
                              RI(act, ctx, sub, i, 5)
            end
            if op == 91 then
                --SpawnChildAtParentOffset：position += parent->worldPosition
                sx, sy = sx + act.wx, sy + act.wy
            elseif op == 94 then
                --SPAWN_ENEMY_RELATIVE：position += enemy->position
                sx, sy = sx + act.x, sy + act.y
            end
            --90/92/93 都是「脚本坐标就是绝对坐标」
            L.spawn_sub(act, ctx, sub.A[i][0], sx, sy, sz, li, idp, sc,
                        (op == 90 or op == 91) and 1 or (op == 92 and 2 or 0))
        end
    elseif op == 95 then
        ---KILL_ALL_NON_BOSS_ENEMIES(8000, 0)：清掉所有子敌。
        L.kill_sub_actors(act)

    --======= 96..113：出弹配置 =======
    elseif op >= 96 and op <= 104 then
        op_shot(act, ctx, sub, i, op)
    elseif op == 105 then
        ---SET_SHOOT_INTERVAL（EclRunHigh.inl:269-279）。17 张卡都是 105(0)。
        local n = RI(act, ctx, sub, i, 0)
        act.shootIntervalFrames = n
        if n ~= 0 then
            act.shootIntervalFrames = n + scale_int_on_rank(idiv(n, 5), -idiv(n, 5))
            act.shootIntervalTimer = 0
        end
    elseif op == 106 then
        local n = RI(act, ctx, sub, i, 0)
        act.shootIntervalFrames = n
        if n ~= 0 then
            act.shootIntervalFrames = n + scale_int_on_rank(idiv(n, 5), -idiv(n, 5))
            act.shootIntervalTimer = floor(ran:Float(0, act.shootIntervalFrames))
        end
    elseif op == 107 or op == 108 then
        act.deferShot = (op == 107)
    elseif op == 109 then
        ---SHOOT_NOW：用当前描述符立刻出一次
        act.gun.ox, act.gun.oy = act.gun.ox, act.gun.oy
        local d = act.gun.desc
        if d then
            L.shoot(act.gun, act.wx, act.wy, d.mode, d.bt, d.color, d.c1, d.c2,
                    d.sp1, d.sp2, d.ang, d.step, d.flags)
        end
    elseif op == 110 then
        ---SET_SHOOT_OFFSET（EclRunHigh.inl:309-317）
        act.gun.ox = RF(act, ctx, sub, i, 0)
        act.gun.oy = RF(act, ctx, sub, i, 1)
        act.gun.oz = 0
    elseif op == 111 then
        ---SET_BULLET_TRANSFORM（EclRunHigh.inl:243-262）：写描述符的第 slot 条记录。
        act.gun.records[RI(act, ctx, sub, i, 0) + 1] =
            L.tr(RI(act, ctx, sub, i, 0), RI(act, ctx, sub, i, 1),
                 RI(act, ctx, sub, i, 2), RI(act, ctx, sub, i, 3),
                 RI(act, ctx, sub, i, 4), RF(act, ctx, sub, i, 5),
                 RF(act, ctx, sub, i, 6))
    elseif op == 112 then
        L.clear_bullets()
    elseif op == 113 then
        ---SET_BULLET_SOUNDS（EclRunHigh.inl:857-870）。实测 17 张卡全是 (-1,-1)：
        ---spawnSound 保持出厂值 7、transformSound = -1（= 不放变换音）。
        local s0 = RI(act, ctx, sub, i, 0)
        if s0 >= 0 then
            act.gun.spawn_sound = s0
            act.gun.spawn_sound_on = true
        else
            act.gun.spawn_sound_on = false
        end
        act.gun.transform_sound = RI(act, ctx, sub, i, 1)

    --======= 114..121：激光 =======
    elseif op == 114 or op == 115 then
        L.laser_create(act, ctx, sub, i, op == 115)
    elseif op == 116 then
        act.selectedLaserSlot = RI(act, ctx, sub, i, 0)
    elseif op == 117 then
        local l = act.laserSlots[RI(act, ctx, sub, i, 0)]
        if l then l.angle = AddNormalizeAngle(l.angle, RF(act, ctx, sub, i, 1)) end
    elseif op == 118 then
        local l = act.laserSlots[RI(act, ctx, sub, i, 0)]
        if l then l.angle = a2p(l.x, l.y) + RF(act, ctx, sub, i, 1) end
    elseif op == 119 then
        local l = act.laserSlots[RI(act, ctx, sub, i, 0)]
        if l then
            l.x = act.wx + RF(act, ctx, sub, i, 1)
            l.y = act.wy + RF(act, ctx, sub, i, 2)
            l.z = act.wz + RF(act, ctx, sub, i, 3)
        end
    elseif op == 120 then
        ---TEST_LASER_ACTIVE：把 inUse 写进 extraIntVariables[2]（0 基 → eiv[3]）。
        ---注意 Lua 里 0 是真值，必须显式比 0。
        local l = act.laserSlots[RI(act, ctx, sub, i, 0)]
        ctx.eiv[3] = (l ~= nil and l.inUse ~= 0) and 1 or 0
    elseif op == 121 then
        ---CANCEL_LASER：STARTING/ACTIVE 的直接转 DESPAWNING、计时归零，
        ---并把 width 锁成 currentWidth（EclRunHigh.inl:405-420）。
        local l = act.laserSlots[RI(act, ctx, sub, i, 0)]
        if l ~= nil and l.inUse ~= 0 and l.state < 2 then
            l.state, l.ltimer = 2, 0
            l.width = l.currentWidth or l.width
        end

    --======= 122..124 =======
    elseif op == 122 then
        ---START_SPELL：只给 bonus、不给时限（EclDependencies.cpp:45-56）。
        ---本文件每张卡的开头都跑一次；真实的时长来自 ins_134。
        act.spellCard = sub.A[i][1]
        act.spellBonus = sub.A[i][2]
    elseif op == 123 then
        ---END_SPELL
        act.spellCard = nil
    elseif op == 124 then
        L.sfx_at(RI(act, ctx, sub, i, 0), act.x)

    --======= 129..183：其余 =======
    elseif op == 129 then
        act.deathMode = RI(act, ctx, sub, i, 0)
    elseif op == 130 then
        act.deathCallbackSubId = RI(act, ctx, sub, i, 0)
    elseif op == 132 then
        act.bossTimer = RI(act, ctx, sub, i, 0)
    elseif op == 134 then
        ---SET_TIMER_CALLBACK：threshold 就是符卡时限（Spellcard.cpp:739）。
        act.timerCallbackThresholdFrames = RI(act, ctx, sub, i, 0)
        act.timerCallbackSubId = RI(act, ctx, sub, i, 1)
    elseif op == 135 then
        L.child_ecl(act, ctx, RI(act, ctx, sub, i, 0), RI(act, ctx, sub, i, 1))
    elseif op == 136 then
        local f = L.ex[RI(act, ctx, sub, i, 0)]
        if f then f(act, ctx, i, sub) end
    elseif op == 137 then
        ---SET_REPEATING_EX_INSTRUCTION：挂到 perFrameCallback
        ---（EclRunHigh.inl:760-771，每帧在插值槽之前调用）。
        local idx = RI(act, ctx, sub, i, 0)
        if idx >= 0 and L.ex[idx] then ctx.cb, ctx.cbi = L.ex[idx], i
        else ctx.cb, ctx.cbi = nil, nil end
    elseif op == 139 then
        ---SPAWN_EFFECT（EclExIns/EffectManager）：TH08 的 effect 17 我们没有素材，
        ---只推进参数（`*WriteInt(ctx,2)` 在数据里是 -1，等于原地不动）。
    elseif op == 145 then
        act.anmRotate = RI(act, ctx, sub, i, 0)
    elseif op == 153 then
        ---RESET_BOSS_TIMER_CALLBACK（EclRunHigh.inl:896-900）
        act.timerCallbackSubId = act.deathCallbackSubId
        act.bossTimer = 0
    elseif op == 155 then
        act.timeoutSpell = true
    elseif op == 157 then
        act.trail = RI(act, ctx, sub, i, 0)
    elseif op == 159 then
        act.drawGroup = RI(act, ctx, sub, i, 0)
    elseif op == 160 then
        act.damageReductionTimer = RI(act, ctx, sub, i, 0)
    elseif op == 165 then
        act.mainAnmRotation = RF(act, ctx, sub, i, 0)
    elseif op == 182 then
        act.extraAnmOffX = RF(act, ctx, sub, i, 0)
        act.extraAnmOffY = RF(act, ctx, sub, i, 1)
    elseif op == 183 then
        act.noDamageDuringStop = RI(act, ctx, sub, i, 0)
    else
        ---其余 opcode（1 张卡都没用到）不实现，静默跳过。
    end
    return "next"
end
L.exec = exec
end

---------------------------------------------------------------
---敌机（EnemyManager 里的 Enemy，一个 ECL 执行体）
---------------------------------------------------------------
---一个敌机 = 一份 ECL context 集合（主 context + 4 个 child ECL block）+
---一组移动/出弹状态。每帧的顺序照 EnemyManagerUpdate.cpp:120-196 与
---EclRun.cpp:34-212 抄：
---   RunEcl（主 context → child 0..3，每个 context：dispatch 循环 → 收尾）
---   → UpdateMovement → UpdateShotAndAnm
---   → ClampPosition → IntegrateVelocity → ClampPosition
---   → 有 parent 且 inheritParentPosition 时 positionOffset = parent.position
---   → worldPosition = position + positionOffset
---坐标一律用 TH08 的 384×448、左上原点、y 朝下系（与出弹/激光一致），
---只在「画到屏幕上」这一刻才经 X2L/Y2L 换算。
do
local RI, RF, WI, WF = L.RI, L.RF, L.WI, L.WF
local game = L.game
local AddNormalizeAngle, VectorAngle = L.AddNormalizeAngle, L.VectorAngle
local new_ctx, sub_of = L.new_ctx, L.sub_of
local cos, sin = cos, sin

---EnemyManager.hpp:455 的 enemies[480]：SpawnEnemy2 从 0 开始找第一个空闲槽
---（EnemyTimeline.cpp:70-100），480 个都占着就 lastSpawnFailed。
local ACTOR_POOL = 480
---SoundPlayer 的 SOUND_FAMILIAR_SPAWN（EclRunLow.inl:817/887/925）。
local SOUND_FAMILIAR_SPAWN = 36

---在场的敌机（1 = 根 boss）。顺序 = 池子下标顺序。
local list = {}
---根敌机（每张卡一个）。原作里根 boss 不在 enemies[480] 池子里，见 kill_sub_actors。
local root = nil

---Enemy 的出厂值（EnemyManager.cpp:131-193 的 spawnTemplate）。
local function new_actor(card, x, y)
    return {
        card = card,
        x = x, y = y, z = 0, wx = x, wy = y, wz = 0,
        vx = 0, vy = 0, vz = 0,           -- velocity（每帧像素）
        px0 = x, py0 = y, pz0 = 0,        -- previousPosition（算 lastFrameDisplacement）
        iox = 0, ioy = 0, ioz = 0,        -- positionOffset
        idx_ = 0, idy = 0, idz = 0,        -- movementInterpolationDelta
        lfx = 0, lfy = 0, lfz = 0,        -- lastFrameDisplacement
        mangle = 0, angvel = 0, speed = 0, accel = 0,
        orbitR = 0, orbitAngle = 0, orbitAngvel = 0, radialVel = 0,
        moveMode = 0, moveTimer = 0, moveDuration = 0, moveEasing = 0,
        mirrorX = false, clampPos = false,
        bounds = { x1 = 0, y1 = 0, x2 = 0, y2 = 0 },
        hitboxW = 24, hitboxH = 24, hitbox2W = 0, hitbox2H = 0,
        interact = 0, minplayer2 = 1024.0,   -- minimumPlayerDistanceSquared 的出厂值
        eiv = { 0, 0, 0, 0, 0, 0, 0, 0 },    -- Enemy::eclIntVariables[8]
        efv = { 0, 0, 0, 0, 0, 0, 0, 0 },    -- Enemy::eclFloatVariables[8]
        life = 1, maxLife = 1,
        lifeCb = { -1, -1, -1, -1 },
        score = 100, itemDrop = 0,
        bossTimer = 0, timer = 0,
        spellCard = nil, spellBonus = 0,
        timerCallbackThresholdFrames = -1, timerCallbackSubId = -1,
        deathCallbackSubId = -1, deathMode = 0,
        shootIntervalFrames = 0, shootIntervalTimer = 0,
        deferShot = false, pendingShot = nil,
        selectedLaserSlot = 0,
        gun = L.new_gun(), laserSlots = {},
        childs = {},                          -- childEclBlocks[0..3]（Lua 里 1..4）
        parent = nil, inheritParentPosition = false, linkedChild = false,
        marker = nil,                         -- 观感用的小圆（见 spawn_sub 上面的说明）
        again = false,                        -- 本帧还要再跑一次（见 tick_all）
        dead = false,
        main = nil,
        ---观感字段（ANM 我们不复原，只记下来）
        anmIdle = 0, anmSeq = 0, anmAlt = 0, anmSeqAlt = 0, anmSpecial = false,
        anmRotate = 0, mainAnmRotation = 0, drawGroup = 0,
        extraAnmOffX = 0, extraAnmOffY = 0,
        damageReductionTimer = 0, noDamageDuringStop = 0, trail = 0,
        timeoutSpell = false,
    }
end
L.new_actor = new_actor

---------------------------------------------------------------------
-- context 的每帧执行（EclRun.cpp:34-212）
---------------------------------------------------------------------
---收尾（EclRun.cpp:116-188）：perFrameCallback(ins_137) → 8 个插值槽 → time++。
---这一段在 d_vm 的 tail 里。
local update_movement, update_shot_and_anm

local function run_context(act, ctx)
    local sub = ctx.sub
    while true do
        local i = ctx.pc
        if i > sub.n then break end
        ---low_redispatch_instruction：每次重新派发前都会刷一次 worldPosition
        ---（EclRun.cpp:56-58）。
        act.wx = act.x + act.iox
        act.wy = act.y + act.ioy
        act.wz = act.z + act.ioz
        if ctx.sec > 0 then
            ---secondaryTime > 0：这一帧什么都不做（time 也 -1，抵消收尾的 +1）
            ctx.sec = ctx.sec - 1
            ctx.t = ctx.t - 1
            break
        end
        if sub.T[i] ~= ctx.t then break end
        ---难度闸门（EclRun.cpp:69-76）：(mask & 当前掩码) == 当前掩码 才执行，
        ---否则 low_advance_instruction 同帧继续往后跑。Last Word 是 AllDifficulties，
        ---当前掩码只看低 4 位（GameManager.cpp:709-711）。
        if (sub.M[i] % 16) ~= 15 then
            ctx.pc = i + 1
        else
            local r = L.exec(ctx, i)
            if r == "terminate" then return "terminate" end
            if r == "free" or r == "frame_end" then return "free" end
            if r ~= "jumped" and r ~= "restart" then
                ---普通指令 / CALL 之外的：推进到下一跳
                ctx.pc = i + 1
            end
            ---jumped：条件跳转与 JUMP 已把 pc/time 设好；
            ---restart：CALL 已把 pc 指到子程序第一条（do_call 里 +1 过了）。
        end
        sub = ctx.sub          -- CALL 可能换了子程序
    end
    ---收尾（d_vm 的 tail）：perFrameCallback → 8 个插值槽 → time++。
    ---⚠ time++ 在 tail **里面**，这里不要再加一次（加过，结果是每帧 +2，
    ---所有 time 驱动的指令全部错位，卡在 JUMP_DEC 上死循环）。
    L.tail(act, ctx)
    return nil
end

---EclManager::RunEcl。返回 -1 = TERMINATE（这个敌机被 Deactivate）。
local function run_ecl(act)
    local i = 0
    while i <= 4 do
        local ctx
        if i == 0 then ctx = act.main else ctx = act.childs[i] end
        if ctx ~= nil then
            if run_context(act, ctx) == "terminate" then return -1 end
        end
        i = i + 1
    end
    update_movement(act)
    update_shot_and_anm(act)
    return 0
end
L.run_ecl = run_ecl

---------------------------------------------------------------------
-- 移动（Enemy::UpdateMovement，EnemyManager.cpp:32-120）
---------------------------------------------------------------------
update_movement = function(act)
    local fm = game.framerateMultiplier
    if act.moveMode == 3 then                 -- ENEMY_MOVEMENT_MODE_ORBIT
        act.orbitAngle = AddNormalizeAngle(act.orbitAngle, fm * act.orbitAngvel)
        act.orbitR = fm * act.radialVel + act.orbitR
        ---FromAngleMagnitude 在 TH08 的 y 朝下系里就是 (cos, sin)
        act.vx = cos(act.orbitAngle) * act.orbitR + act.iox - act.x
        act.vy = sin(act.orbitAngle) * act.orbitR + act.ioy - act.y
        act.mangle = VectorAngle(act.vy, act.vx)
        if act.moveDuration > 0 then
            act.moveTimer = act.moveTimer - 1
            if act.moveTimer <= 0 then act.moveMode = 0 end
        end
    elseif act.moveMode == 1 then             -- ENEMY_MOVEMENT_MODE_POLAR
        act.mangle = AddNormalizeAngle(act.mangle, fm * act.angvel)
        act.speed = fm * act.accel + act.speed
        act.vx = cos(act.mangle) * act.speed
        act.vy = sin(act.mangle) * act.speed
        act.vz = 0
        if act.moveDuration > 0 then
            act.moveTimer = act.moveTimer - 1
            if act.moveTimer <= 0 then act.moveMode = 0 end
        end
    elseif act.moveMode == 2 then             -- ENEMY_MOVEMENT_MODE_INTERPOLATED
        act.moveTimer = act.moveTimer - 1
        local progress
        if act.moveDuration > 0 then
            progress = 1 - act.moveTimer / act.moveDuration
        else
            progress = 1
        end
        if progress < 0 then progress = 0 end
        progress = L.ease(progress, act.moveEasing)
        act.vx = act.iox + act.idx_ * progress - act.x
        act.vy = act.ioy + act.idy * progress - act.y
        act.vz = act.ioz + act.idz * progress - act.z
        if act.mirrorX then act.vx = -act.vx end
        act.mangle = VectorAngle(act.vy, act.vx)
        if act.moveTimer <= 0 then
            act.moveMode = 0
            act.x, act.y, act.z = act.iox + act.idx_, act.ioy + act.idy, act.ioz + act.idz
            act.vx, act.vy, act.vz = 0, 0, 0
        end
    end
end

---Enemy::IntegrateVelocity（EnemyManager.cpp:936-950）。
local function integrate(act)
    local fm = game.framerateMultiplier
    act.lfx = act.x - act.px0
    act.lfy = act.y - act.py0
    act.lfz = act.z - act.pz0
    act.px0, act.py0, act.pz0 = act.x, act.y, act.z
    if act.mirrorX then act.x = act.x - fm * act.vx
    else act.x = act.x + fm * act.vx end
    act.y = act.y + fm * act.vy
    act.z = act.z + fm * act.vz
end

---EnemyManagerUpdate.cpp:164-181 的收尾：夹框 → 积分 → 夹框 → 位置偏移 → worldPosition。
local function sync_world(act)
    local cl = L.clamp_position
    cl(act)
    integrate(act)
    cl(act)
    if act.parent ~= nil and act.inheritParentPosition then
        act.iox, act.ioy = act.parent.x, act.parent.y
    end
    act.wx = act.x + act.iox
    act.wy = act.y + act.ioy
    act.wz = 0
end

---------------------------------------------------------------------
-- 每帧的出弹计时（Enemy::UpdateShotAndAnm，EclDependencies.cpp:791-830）
---------------------------------------------------------------------
update_shot_and_anm = function(act)
    if act.life <= 0 then return end
    ---按间隔自动出弹。17 张卡的 ins_105 全是 0（实测），而 ins_107/108 的
    ---「延后出弹」一次都没用到，所以这段实际上是空转；照原作写全。
    if act.shootIntervalFrames > 0 then
        act.shootIntervalTimer = act.shootIntervalTimer + 1
        if act.shootIntervalTimer >= act.shootIntervalFrames then
            if act.pendingShot then
                local f = act.pendingShot
                act.pendingShot = nil
                f()
            end
            act.shootIntervalTimer = 0
        end
    end
end

---------------------------------------------------------------------
-- 子程序/子敌相关的指令实现
---------------------------------------------------------------------
---把 src 的 intVariables..callParameterFloats 整份拷进 dst
---（0x18..0x90 共 0x78 字节，EclManager.hpp:603-619 的字段顺序）。
---报文操作数是**按字拷**的，所以父敌机的 float 变量会成为子敌机的 float 变量。
local function copy_slots78(src, dst)
    for j = 1, 8 do dst.iv[j] = src.iv[j]; dst.fv[j] = src.fv[j] end
    for j = 1, 4 do dst.eiv[j] = src.eiv[j]; dst.cpi[j] = src.cpi[j] end
    for j = 1, 2 do dst.efv[j] = src.efv[j] end
    for j = 1, 4 do dst.cpf[j] = src.cpf[j] end
    dst.slots = L.new_slots()
end

---ins_135 SET_CHILD_ECL（EclRunHigh.inl:646-679）。
local function child_ecl(act, src_ctx, slot, subId)
    local key = slot + 1
    act.childs[key] = nil
    if subId >= 0 then
        local ctx = new_ctx(sub_of(act.card, subId), act, key)
        copy_slots78(src_ctx, ctx)
        act.childs[key] = ctx
    end
end
L.child_ecl = child_ecl

---给子敌/子机一个可见、可撞的小圆。原作这里画的是敌机的 ANM（我们不复原），
---用一个「速度为 0 的弹」代替：可见、会被自机撞到、也会进入自检的威胁统计，
---但它**不登记进 L.POOL**，所以不占 TH08 那 1536 个弹槽，也不会被 ex12/ex14/ex27
---的全池扫描扫到。
local function make_marker(act)
    local r = act.hitboxW or 24
    local style, col = ball_mid, 1
    if r >= 40 then style = ball_huge end
    local b = NewSimpleBullet(style, col, L.X2L(act.wx), L.Y2L(act.wy), 0, 0,
            false, 0, false, false, false, false)
    b.bound = false
    b.layer = LAYER.ENEMY_BULLET or b.layer
    act.marker = b
    return b
end

---SpawnEnemy2（EnemyTimeline.cpp:64-110）+ ins_90..94 的收尾（EclRunLow.inl:790-926）。
---kind：1 = ins_90/91（子机）、2 = ins_92（子机，且继承父位置）、0 = ins_93/94（普通子敌）。
---x/y/z 是 TH08 脚本坐标（90/92/93 是绝对坐标，91 加父 worldPosition、94 加父 position，
---这两种在 d2_exec 里已经加好）。
local function spawn_sub(act, src_ctx, subId, x, y, z, life, itemDrop, score, kind)
    if #list >= ACTOR_POOL then return nil end      -- 480 槽满了：生成失败
    local child = new_actor(act.card, x, y)
    child.z = z or 0
    child.px0, child.py0, child.pz0 = child.x, child.y, child.z
    child.parent = act
    if life ~= nil and life >= 0 then child.life = life end
    child.maxLife = child.life
    child.itemDrop = itemDrop or 0
    child.score = score or 0
    child.main = new_ctx(sub_of(act.card, subId), child, 0)
    ---SpawnEnemy2 把父 context 的 0x78 字节整份拷进子 context
    ---（EnemyTimeline.cpp:96-99，注意是**按字**拷 —— float 变量也会带过去）。
    copy_slots78(src_ctx or act.main, child.main)
    if kind == 1 or kind == 2 then
        child.linkedChild = true
        if kind == 2 then
            ---ins_92 生成后立刻把 positionOffset 设成父机 position
            ---（EclRunLow.inl:897-902），worldPosition = positionOffset + position。
            child.inheritParentPosition = true
            child.iox, child.ioy = act.x, act.y
            child.wx, child.wy = child.x + child.iox, child.y + child.ioy
        end
        ---ins_90/91/92 无条件放子机出生音（EclRunLow.inl:816-818/886-888/924-926）
        L.sfx_at(SOUND_FAMILIAR_SPAWN, act.x)
    end
    list[#list + 1] = child
    ---SpawnEnemy2 当帧就跑一次完整 RunEcl（EnemyTimeline.cpp:100-102）
    if run_ecl(child) == -1 then child.dead = true end
    ---敌人的扫描循环是按池子下标递增的，新子敌的槽位在父后面 →
    ---本帧还会再被跑到一次（tick_all 的 again 轮）。
    child.again = not child.dead
    return child
end
L.spawn_sub = spawn_sub

---ins_95 KILL_ALL_NON_BOSS_ENEMIES（EnemyManager.cpp:1426-1460）：清掉所有
---非 boss 的敌机。原作判的是 ENEMY_FLAG_BOSS；Last Word 的这 17 个根子程序里
---没有 ins_127 SET_BOSS（实测 0 条），但 ins_95 在每张卡的 time=0 都跑，
---所以**根敌机必然不会被它清掉** —— 移植版据此「只清根以外的敌机」。
local function kill_sub_actors(act)
    for i = 1, #list do
        local a = list[i]
        if a ~= root then a.dead = true end
    end
end
L.kill_sub_actors = kill_sub_actors

---------------------------------------------------------------------
-- 一帧
---------------------------------------------------------------------
local function step_one(a)
    if a.dead then return end
    if run_ecl(a) == -1 then a.dead = true; return end
    if a.life <= 0 then a.dead = true; return end
    sync_world(a)
    a.timer = a.timer + 1
    ---bossTimer 也吃 scriptedUpdateFreeze（EnemyManagerUpdate.cpp:665-666：
    ---`if (!g_GameManager.scriptedUpdateFreeze) enemy->bossTimer++;`）。
    ---17 张卡里只有 216 用了 ex26，而 216 不读 bossTimer，所以实际无差；
    ---照原作写全，防止以后加卡。
    if not game.scriptedUpdateFreeze then a.bossTimer = a.bossTimer + 1 end
    if a ~= root then
        if a.marker == nil or not IsValid(a.marker) then make_marker(a) end
        a.marker.x, a.marker.y = L.X2L(a.wx), L.Y2L(a.wy)
    end
end

---本卡一帧。boss 是 boss 系统给的对象；根敌机的位置会写回它。
function L.tick_all(boss)
    local i = 1
    while true do
        local a = list[i]
        if a == nil then break end
        step_one(a)
        i = i + 1
    end
    ---本帧新生的敌机：敌人的循环（下标递增）还会再跑到它们一次。
    ---反复扫到没有 again 为止，覆盖「子敌在它自己的第一帧又生出东西」的情况。
    local guard = 0
    while true do
        local again = false
        for k = 1, #list do
            local a = list[k]
            if a.again and not a.dead then
                a.again = false
                step_one(a)
                again = true
            end
        end
        if not again then break end
        guard = guard + 1
        if guard > 32 then break end
    end
    ---回收
    for k = #list, 1, -1 do
        local a = list[k]
        if a.dead then
            if a.marker ~= nil and IsValid(a.marker) then L.kill_bullet(a.marker) end
            table.remove(list, k)
        end
    end
    ---根敌机 → boss 对象（TH08 坐标 → 我们的屏幕坐标）
    if root ~= nil and not root.dead and boss ~= nil then
        boss.x, boss.y = L.X2L(root.wx), L.Y2L(root.wy)
    end
end

---开局：清场、建根敌机。cardnum = TH08 的卡号（= L.RAW 的下标，205..221），
---subId = 这张卡的根子程序（LW*.decl 的 roots[0]）。bx/by = boss 在世界里的位置。
---⚠ 原作里**根 boss 不在 enemies[480] 池子里**（见 kill_sub_actors 的说明），
---所以我们把它单独挂在这张卡自己的 list[1] 上。
function L.reset_actors(cardnum, subId, bx, by)
    list = {}
    local a = new_actor(cardnum, L.L2X(bx), L.L2Y(by))
    a.main = new_ctx(sub_of(cardnum, subId), a, 0)
    root = a
    L.root_actor = a
    list[1] = a
    return a
end
L.actor_list = function() return list end
L.actor_root = function() return root end
end

---------------------------------------------------------------
---激光（BulletManager::lasers[256]，BulletManager.hpp:313-341）
---------------------------------------------------------------
---ins_114 CREATE_LASER / ins_115 CREATE_LASER_AIMED（EclRunHigh.inl:319-394）：
---操作数就是 LaserSpawnArgs 的 14 个字，**不是**逐个 Resolve 的普通参数：
---  0 bulletType(u16)  1 color(i16)  2 angle  3 speed  4 startOffset  5 endOffset
---  6 startLength      7 width       8 startTime  9 duration  10 despawnDuration
---  11 hitboxStartTime 12 hitboxEndDelay        13 transformFlags
---（2..7 是 f32，8..12 是 i32；带 operandFlags 时各自走 ResolveFloat/ResolveInt。）
---出生点 = worldPosition + shootOffset（EclDependencies 里 laserSpawnDescriptor.position）。
---AIMED 时 angle += g_Player.AngleToPoint(出生点)（BulletManager.cpp:749-750）。
---每个敌机自己有 32 个槽（enemy->laserSlots[32]，**0 基**），
---SpawnLaserPattern 把新激光原地放进去、返回槽指针；旧的那颗**不会**被销毁，
---只是没人再引用它（所以这里也不 Del 旧的）。
---每帧逻辑照 BulletManager.cpp:1055-1155 抄：endOffset 走 speed*fm、
---startOffset 追着 endOffset 保持 startLength、STARTING→ACTIVE→DESPAWNING 状态机、
---startOffset >= 640 回收。我们让「槽」**就是**那颗可见激光对象本身。
do
local RF, RI = L.RF, L.RI
local cos, sin, floor = cos, sin, floor
local PCX, PCY = L.pcx, L.pcy
local VectorAngle, AddNormalizeAngle = L.VectorAngle, L.AddNormalizeAngle
local X2L, Y2L = L.X2L, L.Y2L
local game = L.game
local PI = PI

---g_Player.AngleToPoint（Player.cpp:965-982）：TH08 坐标系里的 atan2，
---重合时返回 π/2。d2_exec 里有一份同名局部函数，这里是激光自己要用。
local function angle_to_point(x, y)
    local dx, dy = PCX() - x, PCY() - y
    if dy == 0 and dx == 0 then return PI / 2 end
    return VectorAngle(dy, dx)
end
L.angle_to_point = angle_to_point

---TH08 角度（y 朝下）→ LuaSTG 的弧度（y 朝上）：rot = -angle。
local function rot_of(a) return -a end

local LaserObj = Class(laser, {
    ---init 只用来占位：真正的参数由 laser_create 直接写字段。
    init = function(self)
        laser.init(self, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0)
        self.bound = false           -- 光柱会伸出屏外，别让引擎按出界回收
        self.colli = false
        self.inUse = 1
        self.state = 0               -- 0 STARTING / 1 ACTIVE / 2 DESPAWNING
        self.ltimer = 0
        self.currentWidth = 0
        self.alpha = 1
    end,
    frame = function(self)
        local fm = game.framerateMultiplier
        ---BulletManager.cpp:1059-1064
        self.endOffset = self.endOffset + fm * self.speed
        if self.endOffset - self.startOffset > self.startLength then
            self.startOffset = self.endOffset - self.startLength
        end
        if self.startOffset < 0 then self.startOffset = 0 end

        ---BulletManager.cpp:1066-1083：命中盒（我们只用来决定 colli 与观感宽度）
        local len = self.endOffset - self.startOffset
        local hbLen
        if self.startOffset <= 0 then hbLen = len else hbLen = len * 0.7 end

        local hit = false
        local state = self.state
        if state == 0 then                      -- LASER_STATE_STARTING
            if (self.flags % 2) == 1 then       -- flags & 1：整条一起淡入
                local a = self.ltimer * 255 / self.startTime
                if a > 255 then a = 255 end
                self.alpha = a / 255
                self.currentWidth = self.width
            else
                local ramp = self.startTime > 30 and 30 or self.startTime
                if self.startTime - ramp < self.ltimer then
                    self.currentWidth = self.ltimer * self.width / self.startTime
                else
                    self.currentWidth = 1.2
                end
            end
            hit = self.ltimer >= self.hitboxStartTime
            if self.ltimer >= self.startTime then
                self.ltimer = 0
                self.state = 1
                self.currentWidth = self.width
                self.alpha = 1
            end
        elseif state == 1 then                  -- LASER_STATE_ACTIVE
            hit = true
            self.currentWidth = self.width
            self.alpha = 1
            if self.ltimer >= self.duration then
                self.ltimer = 0
                self.state = 2
                if self.despawnDuration == 0 then
                    self.inUse = 0
                end
            end
        end
        if self.state == 2 then                 -- LASER_STATE_DESPAWNING
            if (self.flags % 2) == 1 then
                local a = self.ltimer * 255 / self.startTime
                if a > 255 then a = 255 end
                self.alpha = a / 255
            elseif self.despawnDuration > 0 then
                self.currentWidth = self.width -
                        self.ltimer * self.width / self.despawnDuration
            end
            hit = self.ltimer < self.hitboxEndDelay
            if self.ltimer >= self.despawnDuration then
                self.inUse = 0
            end
        end

        if self.startOffset >= 640 then self.inUse = 0 end

        ---摆到屏幕上：光柱从 startOffset 起、长 len，沿 angle 方向。
        ---TH08 是 y 朝下，我们的 y 朝上，所以 dir = (cos, -sin)。
        local dx, dy = cos(self.angle), -sin(self.angle)
        local bx = self.px + dx * self.startOffset
        local by = self.py + dy * self.startOffset
        self.x, self.y = X2L(bx), Y2L(by)
        self.rot = rot_of(self.angle)
        self.l1, self.l2, self.l3 = 0, len, 0
        self.w = self.currentWidth or self.width
        self.w0 = self.width
        self.alpha = self.alpha or 1
        self.colli = (self.inUse ~= 0) and hit

        laser.frame(self)
        if self.inUse == 0 then Del(self) end
        self.ltimer = self.ltimer + 1
    end,
})

---ins_114/115。返回新建的激光对象（槽里也是它）。
local function laser_create(act, ctx, sub, i, aimed)
    local angle = RF(act, ctx, sub, i, 2)
    local px = act.wx + act.gun.ox
    local py = act.wy + act.gun.oy
    if aimed then angle = angle + angle_to_point(px, py) end

    local l = New(LaserObj)
    l.slotIndex = act.selectedLaserSlot
    l.px, l.py = px, py
    l.pz = act.wz + (act.gun.oz or 0)
    l.angle = angle
    l.speed = RF(act, ctx, sub, i, 3)
    l.startOffset = RF(act, ctx, sub, i, 4)
    l.endOffset = RF(act, ctx, sub, i, 5)
    l.startLength = RF(act, ctx, sub, i, 6)
    l.width = RF(act, ctx, sub, i, 7)
    l.startTime = RI(act, ctx, sub, i, 8)
    l.duration = RI(act, ctx, sub, i, 9)
    l.despawnDuration = RI(act, ctx, sub, i, 10)
    l.hitboxStartTime = RI(act, ctx, sub, i, 11)
    l.hitboxEndDelay = RI(act, ctx, sub, i, 12)
    l.flags = RI(act, ctx, sub, i, 13)
    l.bt = RI(act, ctx, sub, i, 0)
    l.color = RI(act, ctx, sub, i, 1)
    l.state = (l.startTime == 0) and 1 or 0
    l.ltimer = 0
    l.currentWidth = (l.state == 1) and l.width or 0
    l.alpha = (l.state == 1) and 1 or 0
    l.inUse = 1

    ---SpawnLaserPattern 在槽里原地覆盖（BulletManager.cpp:757-759）
    act.laserSlots[act.selectedLaserSlot] = l
    return l
end
L.laser_create = laser_create

---ex25（UpdateWideRotatingLaserHitbox，EclExIns.cpp:527-597）用的
---「跟着敌机转的长光柱」。原作不生成任何对象，只是每帧把一条 590×W 的
---命中盒交给自机的激光判定；我们用一个真的 laser 近似它（看得见、也能撞到）。
---命中盒的几何：原点 = worldPosition - (fv0, fv1)，从原点沿 vm.rotation.z
---伸出 590，宽 W（295 是半宽 → 288 是全宽；内外两条分别是 288/224）。
local RotHit = Class(laser, {
    init = function(self)
        laser.init(self, 8, 0, 0, 0, 0, 590, 0, 288, 0, 0)
        self.bound = false
        self.alpha = 1
        self.keep = 2
    end,
    frame = function(self)
        ---ex25 每帧刷新 keep；回调停了就关判定（光柱本体留着，观感更像原作）。
        self.keep = (self.keep or 0) - 1
        self.colli = self.keep > 0
        laser.frame(self)
    end,
})

---摆一条 590 长的光柱：x/y 是 TH08 坐标的原点，rot 是 TH08 弧度。
local function rot_hitbox(act, x, y, w, rot)
    local o = act.rotHit
    if o == nil or not IsValid(o) then
        o = New(RotHit)
        act.rotHit = o
    end
    o.x, o.y = X2L(x), Y2L(y)
    o.rot = rot_of(rot)
    o.l1, o.l2, o.l3 = 0, 590, 0
    o.w0, o.w = w, w
    o.alpha = 1
    o.keep = 2
    return o
end
L.rot_hitbox = rot_hitbox

---ins_154 CLEAR_LASER_SLOTS：把本敌机的 32 个槽全部作废。
---17 张卡的字节码里没有这条（实测 0 条），保留给以后。
local function laser_slots_clear(act)
    for k, l in pairs(act.laserSlots) do
        if l ~= nil and l.inUse ~= 0 then
            l.inUse = 0
            Del(l)
        end
        act.laserSlots[k] = nil
    end
end
L.laser_slots_clear = laser_slots_clear
end

---------------------------------------------------------------
---ECL 的 ex 指令（ins_136 CALL_EX_INSTRUCTION / ins_137
---SET_REPEATING_EX_INSTRUCTION，EclRunHigh.inl:754-771）
---------------------------------------------------------------
---⚠ EclExInstruction 是**把原始指令整个重新解释**出来的：
---   struct { i32 time; i16 opcode; i16 nextOffset; u8 rsv08; u8 difficultyMask;
---            u16 operandFlags; u8 rsv0C[4]; union { i32 value; i8 byteValue; }; }
---   原始指令头是 12 字节（operands 从 0xC 开始），所以 `value`（偏移 0x10）
---   = **operand 1** 的原始 dword，`byteValue` = 它的最低字节。
---   （不是 operand 0 —— operand 0 是 ex 的**下标**，由 READ_I(ctx,0) 解析。）
---   用 ex26 反证：`136 255 26 1` 的 byteValue 必须来自 operand 1，
---   否则 26 恒非 0、冻结永远开着。
---g_EclExInsn 的 32 项见 EclGlobals.cpp:65-97。17 张卡的字节码里实际用到的只有：
---   206: 0/1   208: 14(+137 的 13)   215: 10(+137 的 25)
---   216: 26/27   217: 28/29
---其余下标（本文件没有）留空，d2_exec 会跳过。
---观感类（闪屏/震动/夜盲/背景染色）按 LuaSTG 现有素材近似，节拍不变。
do
local RI, RF = L.RI, L.RF
local cos, sin, floor = cos, sin, floor
local game = L.game

---(flags & mask) ~= 0。mask 一定是 2 的幂（transformFlags 是位域），
---用除法取位避免依赖 bit 库。
local function has(f, m) return m > 0 and floor(f / m) % 2 ~= 0 end

---取 operand 1 的原始值（EclExInstruction.value）。
local function raw_value(sub, i) return sub.A[i][1] or 0 end
---...的 byteValue（最低 8 位，按 C 的 i8 语义）。
local function raw_byte(sub, i)
    local v = raw_value(sub, i) % 256
    if v >= 128 then v = v - 256 end
    return v
end

---EX 回调的标准签名 = f(act, ctx, i, sub)。
local ex = {}

---0 ConfigureNightBlindness（EclExIns.cpp:30-35）：夜盲参数。
---g_AsciiManager 的观感量，移植版只记下来（没有对应的绘制层）。
ex[0] = function(act, ctx)
    act.nightAlpha = ctx.iv[1]
    act.nightRadius = ctx.fv[1]
end

---1 TriggerShortScreenPulse（:38-41）：SCREEN_EFFECT_ARCADE_PULSE,60,1,-1,0。
ex[1] = function()
    New(WhiteScreen, LAYER.TOP, 60)
end

---10 TriggerScreenPulseAndShake（:513-519）：
---PULSE 30,5,0x40ffffff,0 + SHAKE_ENVELOPE 4,120,190,60。
ex[10] = function()
    New(WhiteScreen, LAYER.TOP, 30)
    misc.ShakeScreen(60, 4)
end

---13 ApplyRedBackgroundTint（:719-722）：AccumulateTint(0xffc03030)。
---ins_137 把它挂成**每帧回调**（208 从第 52 帧挂到 -1），原作是背景的
---累积染色。移植版只累计计数（背景类不开放 AccumulateTint）。
ex[13] = function(act)
    act.tintAccum = (act.tintAccum or 0) + 1
end

---14 AdvanceReisenBulletPhase（:669-714）：铃仙的「冻结/解冻小弹」。
---扫**全池**（0x600 颗），凡是 `transformFlags & intVariables[0]` 非 0 的弹
---就推进一个状态（0→2→1→0）：
---  type==1 → type=0：alpha 0、加算混合、贴图 +16、关判定、
---             速度 = FromAngleMagnitude(angle, fm * floatVariables[1])
---  type==0 → type=2：alpha 0 → 255（15 帧线性插值）
---  否则     → type=1：正常混合、贴图 -16、开判定、速度回到 fm * speed
---贴图档位我们没有对应，只复刻 alpha / 判定开关 / 速度三件事。
ex[14] = function(act, ctx)
    local mask = ctx.iv[1]
    local frost = ctx.fv[2]                 -- floatVariables[1]（1 基）
    local fm = game.framerateMultiplier
    local P = L.POOL
    for k = 1, #P do
        local b = P[k]
        if b ~= nil and not b._dead and has(b._bx_flags or 0, mask) then
            local ph = b._bx_phase or 0
            if ph == 1 then
                b._bx_phase = 0
                b.alpha = 0
                b.colli = false
                b.vx = cos(b._bx_a) * frost * fm
                b.vy = -sin(b._bx_a) * frost * fm
            elseif ph == 0 then
                b._bx_phase = 2
                b.alpha = 0
                b._bx_fade = 15
            else
                b._bx_phase = 1
                b.alpha = 1
                b._bx_fade = nil
                b.colli = true
                b.vx = cos(b._bx_a) * b._bx_s * fm
                b.vy = -sin(b._bx_a) * b._bx_s * fm
            end
        end
    end
end

---25 UpdateWideRotatingLaserHitbox（:527-597）：
---origin = worldPosition - (fv0, fv1)，一条 590×288 的光柱按敌机的
---vm.rotation.z 摆好；`bossTimer % 12 == 0` 的帧再加一条 590×224 的内侧判定。
---移植版用一条真的 laser 对象近似（见 f_lasers 的 rot_hitbox）。
ex[25] = function(act, ctx)
    local ox = act.wx - ctx.fv[1]
    local oy = act.wy - ctx.fv[2]
    local rot = act.mainAnmRotation or 0
    L.rot_hitbox(act, ox, oy, 288, rot)
    if act.bossTimer % 12 == 0 then
        act.rotHitInner = true
    else
        act.rotHitInner = false
    end
end

---26 SetScriptedUpdateFreeze（:815-830）：冻结小弹的位置积分
---（BulletManager.cpp:864-865）。byteValue 非 0 = 冻结。
ex[26] = function(act, ctx, i, sub)
    game.scriptedUpdateFreeze = raw_byte(sub, i) ~= 0
end

---27 SpawnEnemiesFromMarkedBullets（:835-855）：扫全池，把带
---BULLET_TRANSFORM_ECL_EX_TRIGGER_MARKER(0x100000) 的弹变成子敌。
---子敌位置 = 那颗弹的位置（TH08 坐标），life 800、itemDrop -2、score 10，
---int 变量整份继承当前 context；生成后把那颗弹的 marker 位清掉。
ex[27] = function(act, ctx)
    local P = L.POOL
    for k = 1, #P do
        local b = P[k]
        if b ~= nil and not b._dead and has(b._bx_flags or 0, L.K.EX_MARKER) then
            ctx.fv[1] = b._bx_a                  -- floatVariables[0] = bullet->angle
            L.spawn_sub(act, ctx, ctx.eiv[3], L.L2X(b.x), L.L2Y(b.y), 0,
                        800, -2, 10, 0)
            b._bx_flags = (b._bx_flags or 0) - L.K.EX_MARKER
        end
    end
end

---28 EnterScaledBulletTime（:859-882）：fm = 1/value，全池速度 *= fm。
ex[28] = function(act, ctx, i, sub)
    local v = raw_value(sub, i)
    if v == 0 then return end
    game.framerateMultiplier = 1 / v
    local m = game.framerateMultiplier
    local P = L.POOL
    for k = 1, #P do
        local b = P[k]
        if b ~= nil and not b._dead then
            b.vx = (b.vx or 0) * m
            b.vy = (b.vy or 0) * m
        end
    end
end

---29 ExitScaledBulletTime（:886-913）：速度 *= 1/fm，然后 fm 归 1
---（原作先写 1/value 再立刻写成 1，净效果就是把时间倍率还原）。
ex[29] = function()
    local fm = game.framerateMultiplier
    if fm > 0 then
        local s = 1 / fm
        local P = L.POOL
        for k = 1, #P do
            local b = P[k]
            if b ~= nil and not b._dead then
                b.vx = (b.vx or 0) * s
                b.vy = (b.vy or 0) * s
            end
        end
    end
    game.framerateMultiplier = 1
end

L.ex = ex
L.ex_raw_value = raw_value
end

---------------------------------------------------------------
---17 张 Last Word 的注册（卡号 205..221）
---------------------------------------------------------------
---每张卡 = 一个 TH08 的 ecldata*sp 文件 + 一个根子程序（LW*.decl 的 roots[0]）。
---时长 = ins_134 的 timerCallbackThresholdFrames / 60 秒
---（Spellcard.cpp:739 `this->timeLimit = ...timerCallbackThresholdFrames`），
---t1 = t2 = t3：boss_system.lua:158-163 里 `t1 == t3` 被判成**耐久阶段**
---（dmg_factor 恒 0 → 打不到、也没有符卡分数流失，b.time_sc = true），
---正是原作 Last Word「只能躲、不能打」的行为；hp 只是占位，耐久卡不看它。
---（th32.lua 的两张卡、旧 th08-boss_lastword.lua 也都是 t1 == t3。）
---每张卡的 ECL 自己会做：清场（ins_95）→ 关自动出弹（ins_105）→ 设时限
---（ins_134）→ 把 bossTimer 归零（ins_153/ins_132）→ 用 ins_64 的 90~110 帧
---缓动把敌机挪到 TH08 的 (192,128) = 我们的 (0,96) → START_SPELL（ins_122）。
---移植版只负责把虚拟机开起来，节拍全交给 ECL 字节码。
---
---⚠ boss.Define 必须**先于** boss.card.add：add 会当场按 "<字母><level>" 查
---_editor_boss，Define 晚一行就报「找不到 boss」（踩过）。
do
local U = L
local class = U.class
local _SC_BG, TH08_bg = U._SC_BG, U.TH08_bg
local TH08_SC, TH07_SC = U.TH08_SC, U.TH07_SC

class["SCBG1"] = Class(_SC_BG)
class["SCBG2"] = Class(_SC_BG)

U.boss_Define("1a", "莉格露·奈特巴格", "TH08_NEW_0", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW1"], "Nightbug", 29)
U.boss_Define("1b", "米斯蒂娅·萝蕾拉", "TH08_NEW_0", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW1"], "Lorelei", 29)
U.boss_Define("1c", "上白泽慧音", "TH08_NEW_0", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW3"], "Kamishirasawa", 29)
U.boss_Define("1d", "铃仙·优昙华院·因幡", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW4"], "Reisen", 29)
U.boss_Define("1e", "八意永琳", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW5"], "Yagokoro", 29)
U.boss_Define("1f", "蓬莱山辉夜", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW6"], "Neet", 29)
U.boss_Define("1g", "藤原妹红", "TH08_NEW_1", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW6"], "Mokou", 29)
U.boss_Define("1h", "因幡帝", "TH08_NEW_2", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW8"], "Tewi", 29)
U.boss_Define("1i", "上白泽慧音", "TH08_NEW_2", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW9"], "Kamishirasawa2", 29)
U.boss_Define("1j", "博丽灵梦", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, class["SCBG1"], "Reimu", 29)
U.boss_Define("1k", "雾雨魔理沙", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, class["SCBG2"], "Marisa", 29)
U.boss_Define("1l", "十六夜咲夜", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW10"], "Sakuya", 29)
U.boss_Define("1m", "魂魄妖梦", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW11"], "Youmu", 29, 0.6)
U.boss_Define("1n", "爱丽丝·玛格特洛依德", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW12"], "Alice", 29)
U.boss_Define("1o", "蕾米莉亚·斯卡蕾特", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW13"], "Remilia", 29)
U.boss_Define("1p", "西行寺幽幽子", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH08_SC["SCBG-LW14"], "Yuyuko", 29)
U.boss_Define("1q", "八云紫", "TH08_NEW_3", TH08_bg,
        { 0, 420 }, TH07_SC["SCBG8"], "Yukari", 29)

class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_0", true, 0, 0, 0, 0, 0.3, 0, "", 1, 1)
    _SC_BG.AddLayer(self, "th08_3", true, 0, 0, 0, -0.2, 0, 0, "mul+add", 1, 1)
end

class["SCBG2"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0, "mul+sub", 1, 1)
    _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0, 0, 1.5, 0, "", 1, 1)
end

---{卡号, 字母, 中文卡名, 卡 id, 秒数, 根子程序}
---秒数 = ins_134 的 threshold/60：5940/60=99、2220/60=37、2160/60=36、7860/60=131。
---根子程序 = 各 LW*.decl 第一行 roots[] 的第一个（208→40、210→79、214→43，
---注意不是文件里最小的那个子程序号）。
local LIST = {
    { 205, "1a", "「季节外调的蝴蝶风暴」",   351,  99,  36 },
    { 206, "1b", "「盲夜鸟」",               352,  99,  46 },
    { 207, "1c", "「日出之国的天子」",       353,  99,  56 },
    { 208, "1d", "「幻胧月睨」",             354,  99,  40 },
    { 209, "1e", "「天网蛛网捕蝶之法」",     355,  99,  76 },
    { 210, "1f", "「蓬莱之树海」",           356,  99,  79 },
    { 211, "1g", "「不死鸟再诞」",           357,  99, 110 },
    { 212, "1h", "「远古的欺骗者」",         358,  99,  43 },
    { 213, "1i", "「无何有净化」",           359,  99, 113 },
    { 214, "1j", "「梦想天生」",             360,  37,  43 },
    { 215, "1k", "「炽热之星」",             361,  36,  60 },
    { 216, "1l", "「紧缩世界」",             362,  99,   1 },
    { 217, "1m", "「待宵反射卫星斩」",       363,  99,   1 },
    { 218, "1n", "「格兰吉纽尔剧场的怪人」", 364,  99,   1 },
    { 219, "1o", "「猩红命运」",             365,  99,   1 },
    { 220, "1p", "「西行寺无余涅槃」",       366,  99,   1 },
    { 221, "1q", "「深弹幕结界 -梦幻泡影-」", 367, 131,   4 },
}

for _, e in ipairs(LIST) do
    local cardnum, letter, name, id, seconds, subid = e[1], e[2], e[3], e[4], e[5], e[6]
    local card = U.boss_card.New(name, seconds, seconds, seconds, 10000000)
    ---boss.card.add(sc_group, level, CardName, data_id)：level 29 = TH31 的关卡号。
    U.boss_card.add({ { card, letter } }, 29, name, id)
    card.before = function(self)
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    card.init = function(self)
        task.New(self, function()
            ---一张卡一个「世界」：清弹池、复位全局量（framerateMultiplier 等），
            ---再建根敌机。此后每帧推进一次虚拟机，敌机的位置写回 boss 对象。
            U.pool_reset()
            U.reset_game()
            U.reset_actors(cardnum, subid, self.x, self.y)
            while true do
                U.tick_all(self)
                task.Wait(1)
            end
        end)
    end
end
end
---由工具从 th08 的 ecldata*.ecl 原始字节导出（见文件头说明），不要手改。
---格式：每个 '#' 开头的一行是子程序号；其余每行是
---  <time> <opcode> <difficultyMask> <操作数...>
---操作数记号：v<N> 变量、@<i> 子程序内第 i 条指令、其余为数值。
L.RAW[205] = [[
#36
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 40
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 205 99999990
110 81 255 4
110 160 255 120
110 6 255 v10038 0
110 6 255 v10039 6
110 7 255 v10020 0.0392699093
110 7 255 v10023 1.57079637
110 28 255 v10022 v10023 2.5
110 94 255 38 0 0 0 9000 -2 10
110 62 255
110 7 255 v10065 v10020
110 52 255 37
240 67 255 60 4 0
240 6 255 v10053 130
240 7 255 v10058 128
240 25 255 v10057 v10048 v10023
240 6 255 v10036 6
240 62 255
240 27 255 v10023 -1 v10023
240 27 255 v10022 -1 v10022
240 27 255 v10020 -1 v10020
240 30 255 v10038
240 44 255 v10038 3 240 @35
240 6 255 v10038 0
240 30 255 v10039
300 4 255 110 @19
#37
0 6 255 v10036 8
0 7 255 v10016 v10082
0 7 255 v10018 v10057
0 27 255 v10017 v10057 0.100000001
0 7 255 v10023 1.20000005
0 15 255 v10023 1
0 111 255 0 8192 1 400 -1 -1 -1
0 111 255 1 131072 1 60 -1 -1 -1
0 51 255 v10057 0 0 @11
0 111 255 2 64 0 30 1 -1.57079637 -999
0 4 255 0 @12
0 111 255 2 64 0 30 1 1.57079637 -999
0 111 255 3 16384 0 3 0 -1 -1
0 111 255 4 64 0 60 1 3.14159274 0
0 111 255 5 16384 0 0 13 -1 -1
0 111 255 6 131072 1 10 -1 -1 -1
0 111 255 9 524288 0 27 -1 -1 -1
0 111 255 7 64 0 10 1 2.09439516 2.79999995
0 111 255 8 16384 0 8 6 -1 -1
0 99 255 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
0 111 255 7 64 0 10 1 2.09439516 2.4000001
0 99 244 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
0 99 248 0 0 v10039 2 v10023 0.5 v10016 0.261799395 680516
0 16 255 v10023 0.00600000005
0 15 255 v10016 v10018
0 111 255 7 64 0 10 1 3.14159274 1.89999998
0 111 255 8 16384 0 8 5 -1 -1
3 99 255 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
3 111 255 7 64 0 10 1 3.14159274 2.4000001
3 99 244 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
3 99 248 0 0 v10039 2 v10023 0.5 v10016 0.261799395 680516
3 16 255 v10023 0.00600000005
3 15 255 v10016 v10018
3 111 255 7 64 0 10 1 -2.09439516 2
3 111 255 8 16384 0 8 4 -1 -1
5 99 255 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
5 111 255 7 64 0 10 1 -2.09439516 2.5999999
5 99 244 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
5 99 248 0 0 v10039 2 v10023 0.5 v10016 0.261799395 680516
5 16 255 v10023 0.00600000005
5 15 255 v10016 v10018
5 15 255 v10018 v10017
7 5 255 0 @17 v10036
7 6 255 v10036 8
7 111 255 7 64 0 10 1 2.09439516 2.79999995
7 111 255 8 16384 0 8 6 -1 -1
7 99 255 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
7 111 255 7 64 0 10 1 2.09439516 2.4000001
7 99 244 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
7 99 248 0 0 v10039 2 v10023 0.5 v10016 0.261799395 680516
7 16 255 v10023 0.00600000005
7 15 255 v10016 v10018
7 111 255 7 64 0 10 1 3.14159274 1.89999998
7 111 255 8 16384 0 8 5 -1 -1
9 99 255 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
9 111 255 7 64 0 10 1 3.14159274 2.4000001
9 99 244 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
9 99 248 0 0 v10039 2 v10023 0.5 v10016 0.261799395 680516
9 16 255 v10023 0.00600000005
9 15 255 v10016 v10018
9 111 255 7 64 0 10 1 -2.09439516 2
9 111 255 8 16384 0 8 4 -1 -1
12 99 255 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
12 111 255 7 64 0 10 1 -2.09439516 2.5999999
12 99 244 0 0 v10039 1 v10023 0.5 v10016 0.261799395 680516
12 99 248 0 0 v10039 2 v10023 0.5 v10016 0.261799395 680516
12 16 255 v10023 0.00600000005
12 15 255 v10016 v10018
12 16 255 v10018 v10017
14 5 255 7 @44 v10036
14 53 255
#38
0 80 255 8
300 7 255 v10016 v10048
300 6 255 v10036 13
300 111 255 0 32 0 120 -1 0 0.00698131695
300 99 255 8 8 24 1 4.5 0.5 v10016 0.261799395 544
305 5 255 300 @3 v10036
305 6 255 v10036 13
305 111 255 0 32 0 120 -1 0 -0.00698131695
305 99 255 8 8 24 1 4.5 0.5 v10016 0.261799395 544
310 5 255 305 @7 v10036
310 4 255 300 @1
]]
L.RAW[206] = [[
#46
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 50
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 206 99999990
110 81 255 4
110 160 255 240
110 136 255 1 0
110 124 255 15
140 135 255 3 47
170 135 255 0 48
370 4 255 170 @17
#47
0 36 255 v10017 10 4 0 0 255 0 0
0 36 255 v10016 120 4 0 320 96 0 0
0 6 255 v10036 125
0 6 255 v10000 v10017
0 136 255 0 0
1 5 255 0 @3 v10036
1 36 255 v10016 1800 0 0 96 64 0 0
1 6 255 v10000 255
1 136 255 0 0
2 4 255 1 @8
#48
0 6 255 v10039 32
0 7 255 v10016 8
0 7 255 v10019 v10048
0 25 255 v10017 v10019 1.57079637
0 6 255 v10036 24
0 28 255 v10018 v10016 4
0 97 255 6 6 1 8 v10016 v10018 v10017 0 514
0 16 255 v10016 0.25
0 16 255 v10017 0.130899698
0 37 255 v10017
1 5 255 0 @5 v10036
1 7 255 v10016 8
1 26 255 v10017 v10019 1.57079637
1 6 255 v10036 24
1 28 255 v10018 v10016 4
1 97 255 6 6 1 8 v10016 v10018 v10017 0 514
1 16 255 v10016 0.25
1 15 255 v10017 0.130899698
1 37 255 v10017
2 5 255 1 @14 v10036
2 7 255 v10016 8
2 25 255 v10017 v10019 1.57079637
2 6 255 v10036 24
2 28 255 v10018 v10016 4
2 97 255 6 6 1 8 v10016 v10018 v10017 0 514
2 16 255 v10016 0.25
2 16 255 v10017 0.130899698
2 37 255 v10017
3 5 255 2 @23 v10036
3 7 255 v10016 8
3 26 255 v10017 v10019 1.57079637
3 6 255 v10036 24
3 28 255 v10018 v10016 4
3 97 255 6 6 1 8 v10016 v10018 v10017 0 514
3 16 255 v10016 0.25
3 15 255 v10017 0.130899698
3 37 255 v10017
4 5 255 3 @32 v10036
4 67 255 60 4 1
4 6 255 v10036 15
4 99 255 1 1 v10039 2 1.29999995 0.5 v10082 0 512
24 5 255 4 @40 v10036
24 50 255 v10039 64 24 @44
24 10 255 v10039 6
24 4 255 0 @1
]]
L.RAW[207] = [[
#56
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 61
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 207 99999990
110 81 255 4
110 160 255 120
110 62 255
110 7 255 v10016 -1.57079637
110 7 255 v10017 0.0785398185
110 7 255 v10018 0.800000012
110 90 255 58 96 128 1200 -2 100
110 15 255 v10016 2.09439516
110 90 255 58 96 128 1200 -2 100
110 15 255 v10016 2.09439516
110 90 255 58 96 128 1200 -2 100
110 7 255 v10016 -1.57079637
110 7 255 v10017 -0.0785398185
110 7 255 v10018 0.800000012
110 90 255 58 288 128 1200 -2 100
110 15 255 v10016 2.09439516
110 90 255 58 288 128 1200 -2 100
110 15 255 v10016 2.09439516
110 90 255 58 288 128 1200 -2 100
110 7 255 v10016 0
110 7 255 v10017 -0.0785398185
110 7 255 v10018 0.800000012
110 90 255 58 192 224 500 -2 100
110 15 255 v10016 3.14159274
110 90 255 58 192 224 500 -2 100
110 7 255 v10017 0.0785398185
110 7 255 v10016 3.14159274
110 90 255 58 192 224 500 -2 100
110 15 255 v10016 3.14159274
110 90 255 58 192 224 500 -2 100
110 135 255 0 57
110 30 255 v10039
290 4 255 110 @42
#57
120 6 255 v10000 190
120 124 255 16
120 26 255 v10016 v10048 1.57079637
120 6 255 v10036 60
120 37 255 v10016
120 114 255 0 0 v10016 0 0 640 640 12 v10000 30 20 190 20 0
120 16 255 v10016 0.104719758
120 11 255 v10000 2
121 5 255 120 @4 v10036
121 6 255 v10000 190
121 124 255 16
121 15 255 v10016 3.19395256
121 6 255 v10036 60
121 37 255 v10016
121 114 255 0 0 v10016 0 0 640 640 12 v10000 30 20 190 20 0
121 15 255 v10016 0.104719758
121 11 255 v10000 2
122 5 255 121 @13 v10036
322 4 255 120 @0
#58
0 54 255 53
0 83 255 1
0 145 255 1
0 77 255 24 24
0 160 255 30
0 80 255 8192
0 7 255 v10094 v10042
0 7 255 v10095 v10043
0 72 255 41 v10042 v10043 v10016 v10017 0 v10018
40 135 255 0 59
40 74 255 3600 0 0
40 18 255 v10017 16
100 74 255 3600 v10017 0
3700 1 255
#59
300 96 255 8 8 1 1 0.899999976 2.5 0 0.0261799395 16912
300 34 255 v10016 v10042 v10043 v10094 v10095
300 97 255 8 8 1 1 1.10000002 2.5 v10016 0.0261799395 16912
320 34 255 v10016 v10042 v10043 v10094 v10095
320 97 255 8 8 1 1 1.10000002 2.5 v10016 0.0261799395 16912
340 34 255 v10016 v10042 v10043 v10094 v10095
340 97 255 8 8 1 1 1.10000002 2.5 v10016 0.0261799395 16912
360 4 255 300 @0
360 53 255
]]
L.RAW[208] = [[
#38
0 11 255 v10036 25
0 124 255 42
0 137 255 13 0
0 93 255 39 v10094 v10095 0 10 -2 10
2 5 255 0 @3 v10036
52 137 255 -1 0
52 124 255 25
52 53 255
#39
0 80 255 3
0 58 255 5
60 1 255
#40
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 50
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 208 99999990
110 81 255 4
110 160 255 240
110 7 255 v10016 v10082
110 6 241 v10007 80
110 6 242 v10007 128
110 6 244 v10007 130
110 6 248 v10007 144
110 99 255 16 16 v10007 1 5 1 v10016 0.0981747732 1049088
140 6 255 v10036 50
140 7 255 v10094 192
140 7 255 v10095 244
140 135 255 0 38
140 6 255 v10000 1048576
140 7 255 v10016 2.3561945
140 7 255 v10017 0.100000001
140 6 255 v10001 0
140 136 255 14 0
140 6 255 v10000 2097152
140 7 255 v10016 0.785398185
140 136 255 14 0
230 6 255 v10000 1048576
230 136 255 14 0
230 6 255 v10000 2097152
230 136 255 14 0
260 6 255 v10000 1048576
260 6 255 v10001 1
260 136 255 14 0
260 6 255 v10000 2097152
260 136 255 14 0
270 7 255 v10016 v10082
270 6 255 v10007 44
270 99 255 16 16 v10007 2 5.4000001 2.79999995 v10016 0.0981747732 1049088
270 15 255 v10016 0.0654498488
270 99 255 16 16 v10007 2 5.4000001 2.79999995 v10016 0.0981747732 2097664
280 7 255 v10016 v10082
280 99 255 16 16 v10007 2 5.19999981 2.5999999 v10016 0.0981747732 1049088
280 15 255 v10016 0.0654498488
280 99 255 16 16 v10007 2 5.19999981 2.5999999 v10016 0.0981747732 2097664
280 67 255 120 0 0.5
280 6 255 v10036 24
280 7 255 v10016 v10048
280 7 255 v10017 4
280 91 255 42 0 0 200 -2 100
280 15 255 v10016 0.261799395
280 37 255 v10016
280 5 255 280 @53 v10036
290 4 255 110 @13
#41
0 111 255 0 131072 0 180 -1 -1 -1
0 111 255 1 16384 0 7 1 -1 -1
0 111 255 2 16 0 60 -1 0.0333333351 -999
0 97 255 7 7 1 1 0 0.600000024 v10069 0.0981747732 147984
10 4 255 0 @3
#42
0 54 255 53
0 83 255 1
0 145 255 1
0 77 255 24 24
0 160 255 30
0 135 255 0 41
0 65 255 v10016 v10017
30000 1 255
]]
L.RAW[209] = [[
#76
0 129 255 2
0 130 255 24
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 24
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 209 99999990
110 81 255 4
110 160 255 420
110 6 255 v10005 0
110 124 255 16
110 7 255 v10016 v10048
110 6 255 v10036 0
110 27 255 v10023 v10033 -0.392699093
110 15 255 v10023 1.2566371
110 94 255 79 0 0 0 10 -2 10
290 67 255 60 4 1
290 30 255 v10005
350 4 255 110 @16
#79
0 54 255 53
0 80 255 8
0 80 255 16
0 6 255 v10007 6
0 114 255 0 v0 v10016 0 0 600 600 10 110 50 20 110 20 4
0 33 255 v10094 v10016
0 17 255 v10094 70
0 32 255 v10095 v10016
0 17 255 v10095 70
0 15 255 v10094 v10042
0 15 255 v10095 v10043
0 7 255 v10017 v10016
0 64 255 14 0 v10094 v10095
0 111 255 0 262144 0 -1 -1 -1 -1
0 6 255 v10037 7
0 99 255 3 v3 1 1 0.100000001 1 v10082 0.0981747732 262660
2 5 255 0 @15 v10037
2 30 255 v10036
2 44 255 v10036 8 2 @20
2 1 255
2 25 255 v10016 v10017 v10023
2 94 255 79 0 0 0 10 -2 10
2 26 255 v10016 v10017 v10023
2 94 255 79 0 0 0 10 -2 10
2 44 255 v10005 1 92 @26
92 99 255 3 3 2 1 1 1 1.57079637 0 514
92 1 255
]]
L.RAW[210] = [[
#33
0 6 255 v10036 32
0 139 255 17 4 -1
1 5 255 0 @1 v10036
1 53 255
#79
0 129 255 3
0 130 255 0
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 21
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 210 99999990
110 81 255 4
110 160 255 180
110 62 255
110 52 255 33
130 6 255 v10036 12
130 64 255 240 0 v10042 64
130 6 255 v10007 5
130 7 255 v10020 -1.57079637
130 33 255 v10016 v10020
130 17 255 v10016 32
130 32 255 v10017 v10020
130 17 255 v10017 32
130 15 255 v10016 192
130 15 255 v10017 288
130 7 255 v10018 0
130 7 255 v10019 400
130 6 255 v10000 2
130 91 255 80 0 0 4000 -2 100
130 15 255 v10020 0.897597909
130 37 255 v10020
130 16 255 v10018 0.897597909
130 37 255 v10018
130 33 255 v10016 v10020
130 17 255 v10016 32
130 32 255 v10017 v10020
130 17 255 v10017 32
130 15 255 v10016 192
130 15 255 v10017 288
130 7 255 v10019 400
130 6 255 v10000 4
130 91 255 80 0 0 2100 -2 100
130 15 255 v10020 0.897597909
130 37 255 v10020
130 16 255 v10018 0.897597909
130 37 255 v10018
130 33 255 v10016 v10020
130 17 255 v10016 32
130 32 255 v10017 v10020
130 17 255 v10017 32
130 15 255 v10016 192
130 15 255 v10017 288
130 7 255 v10019 400
130 6 255 v10000 6
130 91 255 80 0 0 1000 -2 100
130 15 255 v10020 0.897597909
130 37 255 v10020
130 16 255 v10018 0.897597909
130 37 255 v10018
130 33 255 v10016 v10020
130 17 255 v10016 32
130 32 255 v10017 v10020
130 17 255 v10017 32
130 15 255 v10016 192
130 15 255 v10017 288
130 7 255 v10019 400
130 6 255 v10000 8
130 91 255 80 0 0 1000 -2 100
130 15 255 v10020 0.897597909
130 37 255 v10020
130 16 255 v10018 0.897597909
130 37 255 v10018
130 33 255 v10016 v10020
130 17 255 v10016 32
130 32 255 v10017 v10020
130 17 255 v10017 32
130 15 255 v10016 192
130 15 255 v10017 288
130 7 255 v10019 400
130 6 255 v10000 10
130 91 255 80 0 0 1000 -2 100
130 15 255 v10020 0.897597909
130 37 255 v10020
130 16 255 v10018 0.897597909
130 37 255 v10018
130 33 255 v10016 v10020
130 17 255 v10016 32
130 32 255 v10017 v10020
130 17 255 v10017 32
130 15 255 v10016 192
130 15 255 v10017 288
130 7 255 v10019 400
130 6 255 v10000 13
130 91 255 80 0 0 2100 -2 100
130 15 255 v10020 0.897597909
130 37 255 v10020
130 16 255 v10018 0.897597909
130 37 255 v10018
130 33 255 v10016 v10020
130 17 255 v10016 32
130 32 255 v10017 v10020
130 17 255 v10017 32
130 15 255 v10016 192
130 15 255 v10017 288
130 7 255 v10018 0
130 7 255 v10019 400
130 6 255 v10000 14
130 91 255 80 0 0 4000 -2 100
130 135 255 0 81
290 4 255 130 @111
#80
0 54 255 54
0 77 255 24 24
0 80 255 16
0 83 255 1
0 80 255 3
0 82 255 0
0 33 255 v10059 v10018
0 17 255 v10059 v10019
0 32 255 v10060 v10018
0 17 255 v10060 v10019
0 7 255 v10094 v10042
0 7 255 v10095 v10043
0 9 255 v10018 400
0 36 255 v10042 120 7 0 v10094 v10016 v10059 v10018
0 9 255 v10018 400
0 36 255 v10043 120 7 0 v10095 v10017 v10060 v10018
0 7 255 v10030 v10022
0 7 255 v10031 v10023
120 65 255 0 0
120 83 255 0
120 2 255 v10037
120 81 255 3
120 111 255 0 2048 0 0 -1 -999.900024 0
120 111 255 1 128 0 1 1 0 2.4000001
120 111 255 2 16384 0 2 v10000 -1 -1
150 135 255 0 82
30150 4 255 150 @26
#81
600 7 255 v10016 0
600 7 255 v10017 0
600 6 255 v10038 15
600 7 255 v10023 2.5
600 99 255 3 3 16 1 v10023 0.5 v10016 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10017 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10016 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10017 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10016 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10017 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10016 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10017 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10016 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10017 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10016 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10017 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10016 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 99 255 3 3 16 1 v10023 0.5 v10017 0.0490873866 514
600 15 255 v10016 0.0122718466
600 16 255 v10017 0.0122718466
600 37 255 v10016
600 37 255 v10017
600 2 255 v10038
600 4 255 600 @4
#82
0 7 255 v10017 3.14159274
0 7 255 v10018 0.0785398185
0 7 255 v10016 2.0999999
0 99 255 17 v17 2 1 v10016 0.5 v10017 0.0981747732 19074
0 15 255 v10017 v10018
0 37 255 v10017
8 4 255 0 @3
]]
L.RAW[211] = [[
#110
0 129 255 2
0 130 255 24
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 26
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 211 99999990
110 81 255 4
110 160 255 240
110 183 255 1
110 182 255 1
110 61 255 0 13
110 61 255 1 14
170 78 255 256 24
170 6 255 v10007 20
170 7 255 v10021 3
170 7 255 v10016 3.14159274
170 27 255 v10017 v10035 16
170 62 255
170 6 255 v10007 2
170 6 255 v10006 1
190 7 255 v10016 v10048
190 52 255 111
200 52 255 111
210 52 255 111
220 52 255 111
230 52 255 111
230 51 255 v10021 4 230 @35
230 15 255 v10021 0.200000003
260 67 255 60 4 1
320 62 255
340 7 255 v10016 v10048
340 52 255 111
350 7 255 v10016 v10048
350 52 255 111
360 7 255 v10016 v10048
360 52 255 111
370 7 255 v10016 v10048
370 52 255 111
380 7 255 v10016 v10048
380 52 255 111
380 51 255 v10021 4 380 @49
380 15 255 v10021 0.200000003
440 67 255 60 4 1
490 62 255
500 26 255 v10016 v10048 1.57079637
500 52 255 111
510 26 255 v10016 v10048 1.17809725
510 52 255 111
520 26 255 v10016 v10048 0.785398185
520 52 255 111
530 7 255 v10016 v10048
530 52 255 111
540 25 255 v10016 v10048 0.785398185
540 52 255 111
550 25 255 v10016 v10048 1.17809725
550 52 255 111
560 25 255 v10016 v10048 1.57079637
560 52 255 111
560 6 255 v10007 4
560 6 255 v10006 3
570 25 255 v10016 v10048 1.57079637
570 52 255 111
580 25 255 v10016 v10048 1.17809725
580 52 255 111
590 25 255 v10016 v10048 0.785398185
590 52 255 111
600 7 255 v10016 v10048
600 52 255 111
610 26 255 v10016 v10048 0.785398185
610 52 255 111
620 26 255 v10016 v10048 1.17809725
620 52 255 111
630 26 255 v10016 v10048 1.57079637
630 52 255 111
630 6 255 v10007 6
630 6 255 v10006 5
640 26 255 v10016 v10048 1.57079637
640 52 255 111
650 26 255 v10016 v10048 1.17809725
650 52 255 111
660 26 255 v10016 v10048 0.785398185
660 52 255 111
670 7 255 v10016 v10048
670 52 255 111
680 25 255 v10016 v10048 0.785398185
680 52 255 111
690 25 255 v10016 v10048 1.17809725
690 52 255 111
700 25 255 v10016 v10048 1.57079637
700 52 255 111
700 51 255 v10021 4 700 @99
700 15 255 v10021 0.200000003
700 44 255 v10007 2 700 @101
700 31 255 v10007
700 2 255 v10007
850 4 255 170 @22
#111
0 111 255 0 8192 0 120 -1 -1 -1
0 111 255 1 16 0 120 -1 0.141666666 -999.900024
0 94 255 112 0 0 0 1000 -2 0
0 38 255 v10094 v10095 v10016 32
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 3.14159274
0 38 255 v10094 v10095 v10017 32
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 32
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 32
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 38 255 v10094 v10095 v10016 16
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 3.14159274
0 38 255 v10094 v10095 v10017 16
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 16
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 16
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 64
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 64
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 64
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 64
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.51327419
0 38 255 v10094 v10095 v10017 96
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.51327419
0 38 255 v10094 v10095 v10017 96
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 96
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 96
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 48
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 48
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 48
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.09439516
0 38 255 v10094 v10095 v10017 48
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.51327419
0 38 255 v10094 v10095 v10017 80
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.51327419
0 38 255 v10094 v10095 v10017 80
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 25 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 80
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 26 255 v10017 v10016 2.3561945
0 38 255 v10094 v10095 v10017 80
0 110 255 v10094 v10095
0 97 255 19 19 1 1 0.5 0.5 v10016 0 8722
0 110 255 0 0
0 97 255 7 7 1 1 0.5 0.5 v10016 0 8722
0 97 255 10 10 1 1 0.5 0.5 v10016 0 8724
0 99 255 5 v5 23 1 v10021 0.5 v10082 0 514
0 99 255 5 v5 23 1 2 0.5 v10082 0 514
0 53 255
#112
0 80 255 8
0 65 255 v10016 0.300000012
20 71 255 0.0250000004
20 111 255 0 8192 0 120 -1 -1 -1
20 111 255 1 131072 0 120 -1 -1 -1
20 111 255 2 16 0 120 -1 0.0416666679 -999.900024
20 113 255 -1 -1
20 7 255 v10017 32
50 6 255 v10036 150
50 38 255 v10094 v10095 v10082 v10017
50 110 255 v10094 v10095
50 51 255 v10017 64 50 @13
50 15 255 v10017 1
51 5 255 50 @9 v10036
51 1 255
]]
L.RAW[212] = [[
#43
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 50
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 212 99999990
110 81 255 4
110 160 255 240
110 75 255 32 112 352 192
110 7 255 v10023 0.392699093
110 6 255 v10039 30
110 6 255 v10038 60
110 7 255 v10022 4
110 7 255 v10016 v10048
110 135 255 0 45
110 6 255 v10008 0
110 135 255 1 47
110 17 255 v10023 -1
170 25 255 v10017 v10016 1.57079637
170 7 255 v10065 v10016
170 52 255 44
200 26 255 v10017 v10016 1.57079637
200 7 255 v10065 v10016
200 52 255 44
230 25 255 v10017 v10016 1.57079637
230 7 255 v10065 v10016
230 52 255 44
260 26 255 v10017 v10016 1.57079637
260 7 255 v10065 v10016
260 52 255 44
500 6 255 v10008 1
500 135 255 1 -1
500 67 255 v10038 4 1.5
500 46 255 v10039 16 500 @40
500 11 255 v10039 1
500 2 255 v10038
500 44 255 v10038 30 500 @43
500 11 255 v10038 3
500 51 255 v10022 6 500 @45
500 15 255 v10022 0.400000006
500 4 255 110 @18
#44
0 27 255 v10019 v10033 16
0 15 255 v10019 64
0 7 255 v10021 v10057
0 38 255 v10094 v10095 v10021 v10019
0 25 255 v10016 v10021 1.57079637
0 37 255 v10016
0 38 255 v10023 v10022 v10016 64
0 26 255 v10016 v10021 3.14159274
0 37 255 v10016
0 7 255 v10017 -0.052359879
0 91 255 48 v10023 v10022 2000 -2 100
0 7 255 v10016 v10021
0 25 255 v10020 v10021 3.14159274
0 37 255 v10020
0 38 255 v10094 v10095 v10020 v10019
0 7 255 v10017 0.052359879
0 91 255 48 v10023 v10022 2000 -2 100
0 27 255 v10019 v10033 16
0 15 255 v10019 64
0 7 255 v10021 v10057
0 38 255 v10094 v10095 v10021 v10019
0 26 255 v10016 v10021 1.57079637
0 37 255 v10016
0 38 255 v10023 v10022 v10016 64
0 26 255 v10016 v10021 3.14159274
0 37 255 v10016
0 7 255 v10017 0.052359879
0 91 255 48 v10023 v10022 2000 -2 100
0 7 255 v10016 v10021
0 25 255 v10020 v10021 3.14159274
0 37 255 v10020
0 38 255 v10094 v10095 v10020 v10019
0 7 255 v10017 -0.052359879
0 91 255 48 v10023 v10022 2000 -2 100
0 53 255
#45
0 26 255 v10017 v10016 1.57079637
0 25 255 v10018 v10016 1.57079637
0 124 255 16
0 38 255 v10094 v10095 v10018 64
0 110 255 v10094 v10095
0 116 255 0
0 114 255 0 0 v10018 0 0 512 512 32 60 6000 60 60 60 4
0 116 255 1
0 114 255 0 0 v10018 0 0 512 512 32 60 6000 60 60 60 4
0 38 255 v10094 v10095 v10017 64
0 110 255 v10094 v10095
0 116 255 2
0 114 255 0 0 v10017 0 0 512 512 32 60 6000 60 60 60 4
0 116 255 3
0 114 255 0 0 v10017 0 0 512 512 32 60 6000 60 60 60 4
0 110 255 0 0
60 6 255 v10036 20
60 117 255 0 -0.0785398185
60 117 255 1 0.0785398185
60 117 255 2 0.0785398185
60 117 255 3 -0.0785398185
61 5 255 60 @17 v10036
61 6 255 v10008 0
61 42 255 v10008 1 61 @25
61 4 255 62 @26
62 4 255 61 @23
62 121 255 0
62 121 255 1
62 121 255 2
62 121 255 3
62 53 255
#46
2 6 255 v10038 200
2 111 255 0 131072 0 v10038 -1 -1 -1
2 111 255 1 16384 0 2 2 -1 -1
2 111 255 2 16 0 60 -1 0.0666666701 -999
2 99 255 2 2 1 1 0 0 v10069 0.0981747732 147986
2 46 255 v10038 2 2 @7
2 11 255 v10038 2
4 4 255 2 @1
#47
60 27 255 v10021 v10022 0.699999988
60 98 255 3 3 15 5 v10022 v10021 0 0.0392699093 514
60 2 255 v10039
60 98 255 3 3 15 5 v10022 v10021 0 -0.0392699093 514
60 2 255 v10039
60 4 255 60 @1
#48
0 54 255 53
0 83 255 1
0 145 255 1
0 77 255 24 24
0 160 255 30
0 82 255 0
0 80 255 16
0 25 255 v10023 v10094 v10042
0 25 255 v10022 v10095 v10043
0 72 255 60 v10023 v10022 v10016 v10017 v10019 0
0 135 255 0 46
1 81 255 3
60 15 255 v10023 v10094
60 15 255 v10022 v10095
60 15 255 v10023 v10094
60 15 255 v10022 v10095
60 72 255 60 v10023 v10022 v10016 v10017 v10019 0
120 15 255 v10023 v10094
120 15 255 v10022 v10095
120 15 255 v10023 v10094
120 15 255 v10022 v10095
120 72 255 60 v10023 v10022 v10016 v10017 v10019 0
180 15 255 v10023 v10094
180 15 255 v10022 v10095
180 15 255 v10023 v10094
180 15 255 v10022 v10095
180 72 255 60 v10023 v10022 v10016 v10017 v10019 0
240 15 255 v10023 v10094
240 15 255 v10022 v10095
240 15 255 v10023 v10094
240 15 255 v10022 v10095
240 72 255 60 v10023 v10022 v10016 v10017 v10019 0
240 1 255
]]
L.RAW[213] = [[
#113
0 129 255 1
0 130 255 54
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 26
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 213 99999990
110 81 255 4
110 160 255 60
110 6 255 v10039 0
110 7 255 v10016 v10082
110 7 255 v10017 0.0261799395
110 6 255 v10000 6
110 94 255 114 0 0 0 1000 -2 10
110 7 255 v10017 -0.0224399474
110 6 255 v10000 4
110 94 255 114 0 0 0 1000 -2 10
110 15 255 v10016 1.57079637
110 37 255 v10016
110 7 255 v10017 0.0261799395
110 6 255 v10000 6
110 94 255 114 0 0 0 1000 -2 10
110 7 255 v10017 -0.0224399474
110 6 255 v10000 4
110 94 255 114 0 0 0 1000 -2 10
110 15 255 v10016 1.57079637
110 37 255 v10016
110 7 255 v10017 0.0261799395
110 6 255 v10000 6
110 94 255 114 0 0 0 1000 -2 10
110 7 255 v10017 -0.0224399474
110 6 255 v10000 4
110 94 255 114 0 0 0 1000 -2 10
110 15 255 v10016 1.57079637
110 37 255 v10016
110 7 255 v10017 0.0261799395
110 6 255 v10000 6
110 94 255 114 0 0 0 1000 -2 10
110 7 255 v10017 -0.0224399474
110 6 255 v10000 4
110 94 255 114 0 0 0 1000 -2 10
510 67 255 60 4 1
570 7 255 v10016 v10048
570 124 255 15
570 97 255 10 10 1 1 4 0.800000012 v10016 0.130899698 514
590 97 255 10 10 2 1 4 0.800000012 v10016 0.130899698 514
610 97 255 10 10 3 1 4 0.800000012 v10016 0.130899698 514
630 97 255 10 10 4 1 4 0.800000012 v10016 0.130899698 514
690 4 255 510 @47
#114
0 80 255 8
0 7 255 v10094 v10042
0 7 255 v10095 v10043
0 72 255 6000 v10042 v10043 v10016 v10017 0 3
0 135 255 0 115
0 18 255 v10017 1
0 6 255 v10006 50
0 6 255 v10036 8
0 7 255 v10016 0
0 111 255 0 8192 0 v10006 -1 -1 -1
0 111 255 1 131072 1 v10006 -1 -1 -1
0 111 255 2 262144 0 -1 -1 -1 -1
0 25 255 v10018 v10077 3.14159274
0 15 255 v10018 v10016
0 37 255 v10018
0 97 255 2 v2 1 1 3 0.800000012 v10018 0.130899698 401922
0 15 255 v10016 v10017
2 5 255 0 @12 v10036
2 10 255 v10006 6
2 46 255 v10006 150 2 @21
2 6 255 v10006 150
2 4 255 0 @7
#115
120 72 255 6000 v10094 v10095 v10016 v10017 380 0
120 53 255
]]
L.RAW[214] = [[
#16
0 6 255 v10036 32
0 139 255 17 4 -1
1 5 255 0 @1 v10036
1 53 255
#43
0 76 255
0 80 255 3
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 2220 38
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 90 4 192 224
0 122 255 0 214 60000000
0 155 255 1
90 81 255 4
90 160 255 480
90 75 255 128 144 256 304
90 124 255 13
90 52 255 16
120 59 255 6
170 157 255 5 90 0 6
170 6 255 v10001 0
170 7 255 v10016 1.57079637
170 6 255 v10000 61
170 92 255 44 0 0 500 1 100
170 6 241 v10002 6
170 6 242 v10002 6
170 6 244 v10002 16
170 6 248 v10002 20
170 10 255 v10001 v10002
170 15 255 v10016 0.785398185
170 6 255 v10000 65
170 92 255 44 0 0 300 1 100
170 10 255 v10001 v10002
170 15 255 v10016 0.785398185
170 6 255 v10000 64
170 92 255 44 0 0 500 1 100
170 10 255 v10001 v10002
170 15 255 v10016 0.785398185
170 6 255 v10000 68
170 92 255 44 0 0 300 1 100
170 10 255 v10001 v10002
170 15 255 v10016 0.785398185
170 6 255 v10000 63
170 92 255 44 0 0 500 1 100
170 10 255 v10001 v10002
170 15 255 v10016 0.785398185
170 6 255 v10000 67
170 92 255 44 0 0 300 1 100
170 10 255 v10001 v10002
170 15 255 v10016 0.785398185
170 6 255 v10000 62
170 92 255 44 0 0 500 1 100
170 10 255 v10001 v10002
170 15 255 v10016 0.785398185
170 6 255 v10000 62
170 92 255 44 0 0 300 1 100
170 67 255 120 0 0.5
230 4 255 170 @57
#44
0 54 255 v10000
0 77 255 24 24
0 160 255 30
0 80 255 16
0 80 255 3
0 73 255 100 1176272896 -1105143428 1059313418
99 74 255 6000 -0.0785398185 0
99 135 255 0 45
99 135 255 1 46
6099 1 255
#45
0 7 255 v10016 -0.0785398185
0 7 255 v10017 0
0 33 255 v10018 v10017
0 27 255 v10078 v10018 -0.0785398185
0 15 255 v10017 0.0130899698
0 37 255 v10017
1 4 255 0 @2
#46
0 10 255 v10001 20
0 2 255 v10001
0 111 255 0 8192 1 200 -1 -1 -1
0 111 255 1 128 1 50 1 0 0
0 111 255 2 16384 0 3 15 -1 -1
0 111 255 3 131072 0 10 -1 -1 -1
0 111 255 4 16384 0 3 2 -1 -1
0 111 255 5 131072 0 10 -1 -1 -1
0 111 255 6 524288 0 25 -1 -1 -1
0 111 255 7 16384 0 11 2 -1 -1
0 111 255 8 128 0 1 1 0 1.5
0 111 255 9 128 0 50 1 0 0
0 111 255 10 16384 0 3 2 -1 -1
0 111 255 11 131072 0 10 -1 -1 -1
0 111 255 12 16384 0 3 4 -1 -1
0 111 255 13 524288 0 25 -1 -1 -1
0 111 255 14 131072 0 10 -1 -1 -1
0 111 255 15 16384 0 11 4 -1 -1
0 111 255 16 128 0 1 1 0 6
0 6 255 v10001 200
0 97 255 11 11 2 16 9 3.79999995 v10069 0.0261799395 680578
0 2 255 v10001
0 46 255 v10001 60 0 @24
0 11 255 v10001 10
0 4 255 0 @20
]]
L.RAW[215] = [[
#60
0 157 255 5 15 0 1
0 76 255
0 80 255 16
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 2160 68
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 90 4 192 160
0 122 255 0 215 60000000
0 155 255 1
90 81 255 4
90 160 255 300
90 64 255 60 4 v10042 -64
150 6 255 v10000 4
150 7 255 v10022 0.00833333377
150 124 255 16
150 124 255 19
150 7 255 v10023 v10045
150 34 255 v10094 v10023 640 v10042 v10043
150 33 255 v10016 v10094
150 17 255 v10016 295
150 32 255 v10017 v10094
150 17 255 v10017 295
150 94 255 63 0 0 0 500 -2 100
150 94 255 64 0 0 0 500 -2 100
150 94 255 65 0 0 0 500 -2 100
150 94 255 66 0 0 0 500 -2 100
150 136 255 10 0
150 135 255 0 61
210 64 255 60 1 v10023 640
330 27 255 v10023 v10033 192
330 63 255 v10023 -64
330 15 255 v10022 0.00249999994
340 124 255 16
340 124 255 19
340 7 255 v10023 v10045
340 34 255 v10094 v10023 640 v10042 v10043
340 33 255 v10016 v10094
340 17 255 v10016 295
340 32 255 v10017 v10094
340 17 255 v10017 295
340 94 255 63 0 0 0 500 -2 100
340 94 255 64 0 0 0 500 -2 100
340 94 255 65 0 0 0 500 -2 100
340 94 255 66 0 0 0 500 -2 100
340 136 255 10 0
340 135 255 0 61
400 64 255 60 1 v10023 640
520 27 255 v10023 v10033 192
520 15 255 v10023 192
520 63 255 v10023 -64
520 15 255 v10022 0.00249999994
520 10 255 v10000 3
530 4 255 150 @20
#61
60 6 255 v10036 18
60 7 255 v10016 0
60 111 255 0 64 0 60 1 -999.900024 0
60 111 255 1 131072 0 180 -1 -1 -1
60 111 255 2 16 0 200 -1 v10022 -999.900024
60 99 255 14 14 v10000 1 3 0.899999976 v10016 0.0490873866 131666
60 16 255 v10016 0.130899698
68 99 255 15 15 v10000 1 3 0.899999976 v10016 0.0490873866 131666
68 16 255 v10016 0.130899698
76 5 255 60 @5 v10036
76 53 255
#62
60 87 255 v10018 v10042 0
60 87 255 v10019 v10043 0
60 25 255 v10042 v10018 v10016
60 25 255 v10043 v10019 v10017
61 4 255 60 @0
#63
0 58 255 22
0 159 255 3
0 77 255 24 24
0 160 255 30
0 80 255 16
0 80 255 3
0 165 255 v10094
0 25 255 v10018 v10042 v10016
0 25 255 v10019 v10043 v10017
0 64 255 60 1 v10018 v10019
0 135 255 0 62
60 137 255 25 0
180 137 255 -1 0
240 1 255
#64
0 58 255 23
0 159 255 3
0 77 255 24 24
0 160 255 30
0 80 255 16
0 80 255 3
0 165 255 v10094
0 25 255 v10018 v10042 v10016
0 25 255 v10019 v10043 v10017
0 64 255 60 1 v10018 v10019
0 135 255 0 62
370 1 255
#65
0 58 255 24
0 159 255 3
0 77 255 24 24
0 160 255 30
0 80 255 16
0 80 255 3
0 165 255 v10094
0 25 255 v10018 v10042 v10016
0 25 255 v10019 v10043 v10017
0 64 255 60 1 v10018 v10019
0 135 255 0 62
370 1 255
#66
0 58 255 25
0 159 255 3
0 77 255 24 24
0 160 255 30
0 80 255 16
0 80 255 3
0 165 255 v10094
0 25 255 v10018 v10042 v10016
0 25 255 v10019 v10043 v10017
0 64 255 60 1 v10018 v10019
0 135 255 0 62
370 1 255
]]
L.RAW[216] = [[
#1
0 75 255 32 64 352 128
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 7
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 216 99999990
110 81 255 4
110 160 255 120
110 6 255 v10039 5
110 135 255 0 2
110 124 255 5
110 52 255 5
200 67 255 60 4 1
260 136 255 26 1
260 6 255 v10038 3
260 136 255 27 0
260 67 255 120 4 1
260 124 255 33
260 135 255 0 -1
360 136 255 26 0
360 96 255 20 20 v10039 2 0.800000012 0.400000006 0 0.196349546 514
360 30 255 v10039
380 4 255 110 @15
#2
0 7 255 v10016 0
0 6 255 v10036 15
0 111 255 0 64 0 60 1 1.57079637 2.5
0 97 255 20 20 1 1 2.5 1 v10016 0.392699093 1049154
0 15 255 v10016 0.448798954
0 37 255 v10016
1 5 255 0 @3 v10036
1 7 255 v10016 3.14159274
1 6 255 v10036 15
1 111 255 0 64 0 60 1 -1.57079637 2.5
1 97 255 20 20 1 1 2.5 1 v10016 0.392699093 1049154
1 16 255 v10016 0.448798954
1 37 255 v10016
2 5 255 1 @10 v10036
2 6 255 v10036 50
2 96 255 20 20 1 1 3 1 0 0.392699093 1049090
10 5 255 2 @15 v10036
10 53 255
#5
0 6 255 v10036 30
0 139 255 17 4 -1
1 5 255 0 @1 v10036
1 53 255
]]
L.RAW[217] = [[
#1
0 76 255
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 8
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 217 99999990
110 81 255 4
110 160 255 120
110 6 255 v10038 0
110 6 255 v10039 6
110 7 255 v10020 0.0392699093
110 7 255 v10023 1.57079637
110 28 255 v10022 v10023 2.5
110 7 255 v10021 4000
110 58 255 6
110 136 255 28 3
110 52 255 6
130 136 255 29 1
130 63 255 v10042 420
130 58 255 5
130 135 255 0 3
190 64 255 60 4 v10045 128
190 47 255 v10021 500 190 @30
190 16 255 v10021 300
250 4 255 110 @20
#2
0 58 255 7
0 77 255 24 1
0 80 255 49
0 81 255 2
0 63 255 v10042 224
4 77 255 16 1024
64 1 255
#3
0 135 255 1 4
0 124 255 42
0 27 255 v10095 v10033 14
0 6 255 v10038 16
0 7 255 v10016 -2.7488935
0 93 255 5 v10042 v10095 0 10 -2 10
0 7 255 v10016 -0.392699093
0 93 255 5 v10042 v10095 0 10 -2 10
0 15 255 v10095 29.8666668
1 5 255 0 @4 v10038
1 53 255
#4
0 94 255 2 0 0 0 10 -2 10
8 94 255 2 -8 0 0 10 -2 10
8 94 255 2 8 0 0 10 -2 10
16 94 255 2 -16 0 0 10 -2 10
16 94 255 2 16 0 0 10 -2 10
16 53 255
#5
0 58 255 7
0 80 255 8
0 65 255 v10016 10
0 111 255 0 131072 0 10 -1 -1 -1
0 6 255 v10038 10
0 111 255 1 16 0 60 -1 0.00833333377 -999
0 28 255 v10016 v10082 v10021
0 111 255 2 32 0 120 -1 0.00833333377 v10016
0 111 255 3 16 0 120 -1 0.00833333377 -999
0 99 255 6 6 2 1 0 0.400000006 1.57079637 0.196349546 131634
6 5 255 0 @5 v10038
6 1 255
#6
0 6 255 v10036 30
0 139 255 17 4 -1
1 5 255 0 @1 v10036
1 53 255
]]
L.RAW[218] = [[
#1
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 6
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 218 99999990
110 81 255 4
110 160 255 120
110 6 255 v10038 0
110 6 255 v10039 6
110 7 255 v10020 0.0392699093
110 7 255 v10023 1.57079637
110 28 255 v10022 v10023 2.5
110 7 255 v10018 0.104719758
110 7 255 v10016 -3.14159274
110 7 255 v10017 0.00490873866
110 6 255 v10036 8
110 6 255 v10000 2
110 7 255 v10019 0
110 92 255 2 0 0 9000 -2 10
110 15 255 v10016 0.785398185
110 5 255 110 @24 v10036
110 7 255 v10018 -0.104719758
110 7 255 v10016 -3.14159274
110 7 255 v10017 -0.00490873866
110 6 255 v10036 8
110 6 255 v10000 4
110 92 255 2 0 0 9000 -2 10
110 15 255 v10016 0.785398185
110 5 255 110 @32 v10036
710 67 255 60 4 1
770 67 255 60 4 1
830 67 255 60 4 1
890 67 255 60 4 1
950 67 255 60 4 1
1010 64 255 60 4 192 128
1010 4 255 110 @35
#2
0 55 255 12
0 80 255 16
0 77 255 24 24
0 160 255 30
0 82 255 0
0 72 255 60 0 0 v10016 v10017 0 1.60000002
0 135 255 0 3
60 74 255 12000 v10017 0
660 135 255 0 4
660 17 255 v10017 1.02999997
660 74 255 12000 v10017 0
960 135 255 0 3
1560 135 255 0 4
1560 17 255 v10017 1.02999997
1560 74 255 12000 v10017 0
1860 135 255 0 3
2460 135 255 0 4
2460 17 255 v10017 1.02999997
2460 74 255 12000 v10017 0
2760 135 255 0 3
3360 135 255 0 4
3360 17 255 v10017 1.02999997
3360 74 255 12000 v10017 0
3660 135 255 0 3
4260 135 255 0 4
4260 17 255 v10017 1.02999997
4260 74 255 12000 v10017 0
4560 135 255 0 3
5160 135 255 0 4
5160 17 255 v10017 1.02999997
5160 74 255 12000 v10017 0
5460 135 255 0 3
6060 135 255 0 4
6060 17 255 v10017 1.02999997
6060 74 255 12000 v10017 0
6360 135 255 0 3
6960 135 255 0 4
7260 135 255 0 3
19260 1 255
#3
60 111 255 0 131072 0 120 -1 -1 -1
60 51 255 v10018 0 60 @4
60 111 255 1 64 0 60 1 2.51327419 2.9000001
60 4 255 60 @5
60 111 255 1 64 0 60 1 -2.51327419 2.9000001
60 25 255 v10020 v10077 v10019
60 37 255 v10020
60 99 255 2 v2 1 1 1 0.5 v10020 0.261799395 514
60 15 255 v10019 v10018
60 37 255 v10019
64 25 255 v10020 v10077 v10019
64 37 255 v10020
64 99 255 2 v2 1 1 1 0.5 v10020 0.261799395 131650
64 15 255 v10019 v10018
64 37 255 v10019
68 4 255 60 @5
#4
120 96 255 6 v6 3 1 8 0.5 0 0.261799395 514
128 4 255 120 @0
]]
L.RAW[219] = [[
#1
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 6
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 219 99999990
110 81 255 4
110 160 255 120
110 6 255 v10038 0
110 6 255 v10039 6
110 7 255 v10020 0.0392699093
110 7 255 v10023 1.57079637
110 28 255 v10022 v10023 2.5
110 7 255 v10018 0.184799567
110 7 255 v10022 4
110 25 255 v10016 v10048 1.57079637
110 135 255 0 2
110 26 255 v10016 v10048 1.57079637
110 135 255 1 3
110 25 255 v10016 v10048 3.14159274
110 135 255 2 4
110 17 255 v10018 -1
240 67 255 60 4 1
240 51 255 v10022 10 240 @30
240 15 255 v10022 1
300 4 255 110 @20
#2
0 6 255 v10036 64
0 7 255 v10017 64
0 38 255 v10094 v10095 v10016 v10017
0 110 255 v10094 v10095
0 16 255 v10017 2
0 99 255 20 20 1 4 v10022 0.5 v10016 -0.261799395 1049090
0 15 255 v10016 0.184799567
2 5 255 0 @2 v10036
2 53 255
#3
0 6 255 v10036 64
0 7 255 v10017 64
0 38 255 v10094 v10095 v10016 v10017
0 110 255 v10094 v10095
0 16 255 v10017 2
0 99 255 20 20 1 4 v10022 0.5 v10016 0.261799395 1049090
0 16 255 v10016 0.184799567
2 5 255 0 @2 v10036
2 53 255
#4
60 6 255 v10036 16
60 7 255 v10017 64
60 38 255 v10094 v10095 v10016 v10017
60 110 255 v10094 v10095
60 16 255 v10017 2
60 28 255 v10023 v10018 1.5
60 99 255 10 10 1 4 v10022 0.5 v10016 v10023 1049090
60 15 255 v10016 v10018
62 5 255 60 @2 v10036
62 53 255
]]
L.RAW[220] = [[
#1
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 5940 9
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 110 4 192 128
0 122 255 0 220 99999990
110 81 255 4
110 160 255 120
110 6 255 v10038 0
110 6 255 v10039 6
110 7 255 v10020 0.0392699093
110 7 255 v10023 1.57079637
110 28 255 v10022 v10023 2.5
110 124 255 15
110 182 255 1
110 61 255 0 6
110 78 255 320 32
110 59 255 0
110 7 255 v10016 -0.0981747732
110 7 255 v10017 0.600000024
110 6 255 v10000 0
110 113 255 7 25
110 64 255 60 4 192 112
170 75 255 128 96 256 128
170 6 255 v10039 0
170 7 255 v10016 0
170 6 255 v10002 0
170 7 255 v10017 0
170 7 255 v10018 0.5
170 6 255 v10002 20
170 6 255 v10003 6
170 7 255 v10016 v10082
170 23 255 v10053 v10003 2
170 94 255 5 0 0 0 10 -2 10
170 94 255 6 0 0 0 10 -2 10
170 6 255 v10061 v10002
170 6 255 v10062 3
170 7 255 v10065 v10016
170 7 255 v10066 v10017
170 7 255 v10067 v10018
170 52 255 2
170 28 255 v10020 3.14159274 v10002
180 15 255 v10016 v10020
180 37 255 v10016
180 6 255 v10061 v10002
180 6 255 v10062 2
180 7 255 v10065 v10016
180 7 255 v10066 v10017
180 7 255 v10067 v10018
180 52 255 3
190 15 255 v10016 v10020
190 37 255 v10016
190 6 255 v10061 v10002
190 6 255 v10062 3
190 7 255 v10065 v10016
190 7 255 v10066 v10017
190 7 255 v10067 v10018
190 52 255 2
200 15 255 v10016 v10020
200 37 255 v10016
200 6 255 v10061 v10002
200 6 255 v10062 2
200 7 255 v10065 v10016
200 7 255 v10066 v10017
200 7 255 v10067 v10018
200 52 255 3
210 15 255 v10016 v10020
210 37 255 v10016
210 6 255 v10061 v10002
210 6 255 v10062 3
210 7 255 v10065 v10016
210 7 255 v10066 v10017
210 7 255 v10067 v10018
210 52 255 2
220 15 255 v10016 v10020
220 37 255 v10016
220 6 255 v10061 v10002
220 6 255 v10062 2
220 7 255 v10065 v10016
220 7 255 v10066 v10017
220 7 255 v10067 v10018
220 52 255 3
340 7 255 v10022 3.14159274
340 7 255 v10023 0.0628318563
340 6 255 v10061 24
340 6 255 v10062 1
340 7 255 v10065 v10082
340 7 255 v10066 0.00523598772
340 7 255 v10067 0.800000012
340 52 255 4
370 7 255 v10022 0
370 7 255 v10023 -0.0628318563
370 6 255 v10061 26
370 6 255 v10062 1
370 7 255 v10065 v10082
370 7 255 v10066 -0.00523598772
370 7 255 v10067 0.800000012
370 52 255 4
400 7 255 v10022 3.14159274
400 7 255 v10023 0.0628318563
400 6 255 v10061 28
400 6 255 v10062 1
400 7 255 v10065 v10082
400 7 255 v10066 0.0104719754
400 7 255 v10067 0.800000012
400 52 255 4
430 7 255 v10022 3.14159274
430 7 255 v10023 0.0628318563
430 6 255 v10061 30
430 6 255 v10062 1
430 7 255 v10065 v10082
430 7 255 v10066 -0.0104719754
430 7 255 v10067 0.800000012
430 52 255 4
430 67 255 60 0 0.200000003
490 6 255 v10061 24
490 6 255 v10062 0
490 7 255 v10065 1.57079637
490 7 255 v10066 0
490 7 255 v10067 v10018
490 52 255 7
490 15 255 v10018 0.0799999982
490 10 255 v10002 3
490 10 255 v10003 2
585 4 255 170 @36
#2
0 111 255 0 32 0 120 -1 0.00999999978 v10058
0 111 255 1 8192 1 200 -1 -1 -1
0 6 255 v10036 4
0 7 255 v10016 0.159999996
0 111 255 2 16 0 80 -1 v10016 -999
0 99 255 8 v8 v10053 1 v10059 1 v10057 0.785398185 8752
0 16 255 v10016 0.0816666633
0 5 255 0 @4 v10036
0 53 255
#3
0 111 255 0 32 0 120 -1 0.00999999978 v10058
0 111 255 1 8192 1 200 -1 -1 -1
0 6 255 v10036 4
0 7 255 v10016 0.159999996
0 111 255 2 16 0 80 -1 v10016 -999
0 99 255 8 v8 v10053 1 v10059 1 v10057 0.785398185 8752
0 16 255 v10016 0.0816666633
0 5 255 0 @4 v10036
0 53 255
#4
0 111 255 0 32 0 120 -1 0.00999999978 v10058
0 111 255 1 8192 1 200 -1 -1 -1
0 6 255 v10036 5
0 7 255 v10016 0.159999996
0 111 255 2 16 0 80 -1 v10016 -999
0 99 255 8 v8 v10053 2 v10059 0.300000012 v10057 0 8752
0 16 255 v10016 0.0540000014
0 5 255 0 @4 v10036
0 53 255
#5
0 80 255 8
0 6 255 v10036 v10053
0 28 255 v10017 3.14159274 v10053
0 28 255 v10018 v10017 2
0 25 255 v10016 v10018 1.57079637
0 15 255 v10017 v10017
0 124 255 13
0 6 255 v10001 0
0 116 255 v10001
0 30 255 v10001
0 25 255 v10018 v10016 1.04719758
0 37 255 v10018
0 114 255 1 1 v10018 0 64 448 448 16 120 120 60 90 30 0
0 15 255 v10016 v10017
0 37 255 v10016
0 5 255 0 @8 v10036
0 6 255 v10037 60
0 36 255 v10016 60 0 4 0 -1.04719758 0 0
0 7 255 v10016 0
0 7 255 v10017 0
0 6 255 v10036 v10053
0 6 255 v10001 0
0 26 255 v10018 v10016 v10017
0 7 255 v10017 v10016
0 117 255 v10001 v10018
0 30 255 v10001
0 5 255 0 @24 v10036
1 5 255 0 @20 v10037
1 1 255
#6
0 80 255 8
0 6 255 v10036 v10053
0 28 255 v10017 3.14159274 v10053
0 28 255 v10018 v10017 2
0 26 255 v10016 1.57079637 v10018
0 15 255 v10017 v10017
0 124 255 16
0 6 255 v10001 0
0 116 255 v10001
0 30 255 v10001
0 26 255 v10018 v10016 1.04719758
0 37 255 v10018
0 114 255 1 1 v10018 0 64 448 448 16 120 120 60 90 30 0
0 15 255 v10016 v10017
0 37 255 v10016
0 5 255 0 @8 v10036
0 6 255 v10037 60
0 36 255 v10016 60 0 4 0 1.04719758 0 0
0 7 255 v10016 0
0 7 255 v10017 0
0 6 255 v10036 v10053
0 6 255 v10001 0
0 26 255 v10018 v10016 v10017
0 7 255 v10017 v10016
0 117 255 v10001 v10018
0 30 255 v10001
0 5 255 0 @24 v10036
1 5 255 0 @20 v10037
1 1 255
#7
0 111 255 0 32 0 120 -1 0.00999999978 v10058
0 111 255 1 8192 1 200 -1 -1 -1
0 6 255 v10036 3
0 7 255 v10016 0.159999996
0 111 255 2 16 0 80 -1 v10016 -999
0 101 255 10 v10 v10053 1 v10059 1 v10057 0.785398185 8752
0 16 255 v10016 0.0825000033
0 5 255 0 @4 v10036
0 53 255
]]
L.RAW[221] = [[
#4
0 105 255 0
0 95 255
0 113 255 -1 -1
0 80 255 4
0 110 255 0 0
0 134 255 7860 2
0 153 255
0 132 255 0
0 6 255 v10039 0
0 64 255 90 4 192 128
0 122 255 0 221 10000000
0 155 255 1
90 81 255 4
90 160 255 120
90 6 255 v10038 0
90 6 255 v10039 6
90 7 255 v10020 0.0392699093
90 7 255 v10023 1.57079637
90 28 255 v10022 v10023 2.5
90 182 255 1
90 61 255 0 15
90 59 255 2
90 76 255
90 80 255 3
90 7 255 v10016 -0.0981747732
90 7 255 v10017 0.600000024
90 6 255 v10000 0
90 64 255 60 4 192 224
150 58 255 16
160 7 255 v10016 3.14159274
160 7 255 v10017 0.0261799395
160 7 255 v10018 224
160 7 255 v10019 1.57079637
160 7 255 v10020 0.00261799386
160 6 255 v10000 520
160 6 255 v10001 3
160 6 255 v10002 4
160 94 255 5 0 0 0 240 -2 10
160 7 255 v10016 0
160 7 255 v10017 0.0261799395
160 7 255 v10018 224
160 7 255 v10019 1.57079637
160 7 255 v10020 0.00261799386
160 6 255 v10000 520
160 6 255 v10001 3
160 6 255 v10002 6
160 94 255 5 0 0 0 240 -2 10
960 7 255 v10016 3.14159274
960 7 255 v10017 -0.0174532924
960 7 255 v10018 192
960 7 255 v10019 -1.04719758
960 7 255 v10020 -0.00785398204
960 6 255 v10000 520
960 6 255 v10001 3
960 6 255 v10002 4
960 94 255 7 0 0 0 240 -2 10
960 7 255 v10016 0
960 7 255 v10017 -0.0174532924
960 7 255 v10018 192
960 7 255 v10019 -1.04719758
960 7 255 v10020 -0.00785398204
960 6 255 v10000 520
960 6 255 v10001 3
960 6 255 v10002 6
960 94 255 7 0 0 0 240 -2 10
1760 7 255 v10016 3.14159274
1760 7 255 v10017 -0.0174532924
1760 7 255 v10018 224
1760 7 255 v10019 -1.57079637
1760 7 255 v10020 -0.00261799386
1760 6 255 v10000 520
1760 6 255 v10001 3
1760 6 255 v10002 4
1760 94 255 6 0 0 0 240 -2 10
1760 7 255 v10016 0
1760 7 255 v10017 -0.0174532924
1760 7 255 v10018 224
1760 7 255 v10019 -1.57079637
1760 7 255 v10020 -0.00261799386
1760 6 255 v10000 520
1760 6 255 v10001 3
1760 6 255 v10002 6
1760 94 255 6 0 0 0 240 -2 10
1780 7 255 v10016 3.14159274
1780 7 255 v10017 0.0261799395
1780 7 255 v10018 192
1780 7 255 v10019 1.57079637
1780 7 255 v10020 0.00261799386
1780 6 255 v10000 520
1780 6 255 v10001 3
1780 6 255 v10002 4
1780 94 255 6 0 0 0 240 -2 10
1780 7 255 v10016 0
1780 7 255 v10017 0.0261799395
1780 7 255 v10018 192
1780 7 255 v10019 1.57079637
1780 7 255 v10020 0.00261799386
1780 6 255 v10000 520
1780 6 255 v10001 3
1780 6 255 v10002 6
1780 94 255 6 0 0 0 240 -2 10
2610 7 255 v10016 3.14159274
2610 7 255 v10017 0.0174532924
2610 7 255 v10018 224
2610 7 255 v10019 0.785398185
2610 7 255 v10020 0.0104719754
2610 6 255 v10000 520
2610 6 255 v10001 3
2610 6 255 v10002 4
2610 94 255 8 0 0 0 240 -2 10
2610 7 255 v10016 0
2610 7 255 v10017 0.0174532924
2610 7 255 v10018 224
2610 7 255 v10019 0.785398185
2610 7 255 v10020 0.0104719754
2610 6 255 v10000 520
2610 6 255 v10001 3
2610 6 255 v10002 6
2610 94 255 8 0 0 0 240 -2 10
2630 7 255 v10016 3.14159274
2630 7 255 v10017 -0.0314159282
2630 7 255 v10018 208
2630 7 255 v10019 -0.785398185
2630 7 255 v10020 -0.0104719754
2630 6 255 v10000 520
2630 6 255 v10001 3
2630 6 255 v10002 4
2630 94 255 8 0 0 0 240 -2 10
2630 7 255 v10016 0
2630 7 255 v10017 -0.0314159282
2630 7 255 v10018 208
2630 7 255 v10019 -0.785398185
2630 7 255 v10020 -0.0104719754
2630 6 255 v10000 520
2630 6 255 v10001 3
2630 6 255 v10002 6
2630 94 255 8 0 0 0 240 -2 10
2650 7 255 v10016 3.14159274
2650 7 255 v10017 0.0261799395
2650 7 255 v10018 192
2650 7 255 v10019 0.785398185
2650 7 255 v10020 0.0104719754
2650 6 255 v10000 520
2650 6 255 v10001 3
2650 6 255 v10002 4
2650 94 255 8 0 0 0 240 -2 10
2650 7 255 v10016 0
2650 7 255 v10017 0.0261799395
2650 7 255 v10018 192
2650 7 255 v10019 0.785398185
2650 7 255 v10020 0.0104719754
2650 6 255 v10000 520
2650 6 255 v10001 3
2650 6 255 v10002 6
2650 94 255 8 0 0 0 240 -2 10
3540 7 255 v10016 3.14159274
3540 7 255 v10017 -0.0314159282
3540 7 255 v10018 224
3540 7 255 v10019 -1.57079637
3540 7 255 v10020 -0.00448798947
3540 6 255 v10000 520
3540 6 255 v10001 3
3540 6 255 v10002 4
3540 94 255 9 0 0 0 240 -2 10
3540 7 255 v10016 0
3540 7 255 v10017 -0.0314159282
3540 7 255 v10018 224
3540 7 255 v10019 -1.57079637
3540 7 255 v10020 -0.00448798947
3540 6 255 v10000 520
3540 6 255 v10001 3
3540 6 255 v10002 6
3540 94 255 9 0 0 0 240 -2 10
4430 7 255 v10016 -1.57079637
4430 7 255 v10017 0.0314159282
4430 7 255 v10018 224
4430 7 255 v10019 1.57079637
4430 7 255 v10020 0.00448798947
4430 6 255 v10000 480
4430 6 255 v10001 3
4430 6 255 v10002 2
4430 94 255 10 0 0 0 240 -2 10
4430 7 255 v10016 1.57079637
4430 7 255 v10017 0.0314159282
4430 7 255 v10018 224
4430 7 255 v10019 1.57079637
4430 7 255 v10020 0.00448798947
4430 6 255 v10000 480
4430 6 255 v10001 3
4430 6 255 v10002 4
4430 94 255 10 0 0 0 240 -2 10
4430 7 255 v10016 -1.57079637
4430 7 255 v10017 -0.0314159282
4430 7 255 v10018 224
4430 7 255 v10019 -1.53152645
4430 7 255 v10020 0.00448798947
4430 6 255 v10000 520
4430 6 255 v10001 3
4430 6 255 v10002 6
4430 94 255 11 0 0 0 240 -2 10
4430 7 255 v10016 1.57079637
4430 7 255 v10017 -0.0314159282
4430 7 255 v10018 224
4430 7 255 v10019 -1.53152645
4430 7 255 v10020 0.00448798947
4430 6 255 v10000 520
4430 6 255 v10001 3
4430 6 255 v10002 6
4430 94 255 11 0 0 0 240 -2 10
5120 7 255 v10016 -1.57079637
5120 7 255 v10017 0.0314159282
5120 7 255 v10018 224
5120 7 255 v10019 1.53152645
5120 7 255 v10020 0.00448798947
5120 6 255 v10000 480
5120 6 255 v10001 3
5120 6 255 v10002 2
5120 94 255 12 0 0 0 240 -2 10
5120 7 255 v10016 1.57079637
5120 7 255 v10017 0.0314159282
5120 7 255 v10018 224
5120 7 255 v10019 1.53152645
5120 7 255 v10020 0.00448798947
5120 6 255 v10000 480
5120 6 255 v10001 3
5120 6 255 v10002 4
5120 94 255 12 0 0 0 240 -2 10
5120 7 255 v10016 0
5120 7 255 v10017 -0.0314159282
5120 7 255 v10018 224
5120 7 255 v10019 -1.53152645
5120 7 255 v10020 0.00157079636
5120 6 255 v10000 520
5120 6 255 v10001 3
5120 6 255 v10002 6
5120 94 255 13 0 0 0 240 -2 10
5120 7 255 v10016 3.14159274
5120 7 255 v10017 -0.0314159282
5120 7 255 v10018 224
5120 7 255 v10019 -1.53152645
5120 7 255 v10020 0.00157079636
5120 6 255 v10000 520
5120 6 255 v10001 3
5120 6 255 v10002 6
5120 94 255 13 0 0 0 240 -2 10
5810 7 255 v10016 -1.57079637
5810 7 255 v10017 0.0314159282
5810 7 255 v10018 224
5810 7 255 v10019 1.53152645
5810 7 255 v10020 0
5810 6 255 v10000 280
5810 6 255 v10001 3
5810 6 255 v10002 2
5810 94 255 14 0 0 0 240 -2 10
5810 7 255 v10016 1.57079637
5810 7 255 v10017 0.0314159282
5810 7 255 v10018 224
5810 7 255 v10019 1.53152645
5810 7 255 v10020 0
5810 6 255 v10000 280
5810 6 255 v10001 3
5810 6 255 v10002 4
5810 94 255 14 0 0 0 240 -2 10
6300 7 255 v10016 -1.57079637
6300 7 255 v10017 0.0314159282
6300 7 255 v10018 224
6300 7 255 v10019 1.57079637
6300 7 255 v10020 0
6300 6 255 v10000 280
6300 6 255 v10001 3
6300 6 255 v10002 2
6300 94 255 15 0 0 0 240 -2 10
6300 7 255 v10016 1.57079637
6300 7 255 v10017 0.0314159282
6300 7 255 v10018 224
6300 7 255 v10019 1.57079637
6300 7 255 v10020 0
6300 6 255 v10000 280
6300 6 255 v10001 3
6300 6 255 v10002 4
6300 94 255 15 0 0 0 240 -2 10
6990 52 255 16
7050 124 255 15
7050 6 255 v10037 220
7050 6 255 v10036 6
7050 111 255 0 8192 0 v10000 -1 -1 -1
7050 111 255 1 16 0 90 -1 0 -999
7050 111 255 2 64 0 1 1 0 0
7050 111 255 3 16 0 90 -1 0 -999
7050 111 255 4 16 0 90 -1 0.00111111114 -999
7050 27 255 v10094 v10035 192
7050 27 255 v10095 v10035 224
7050 27 255 v10016 v10094 v10094
7050 27 255 v10017 v10095 v10095
7050 15 255 v10016 v10017
7050 45 255 v10016 1024 7050 @299
7050 110 255 v10094 v10095
7050 34 255 v10016 v10094 v10095 0 0
7050 97 255 11 11 1 1 0 2 v10016 0 8788
7050 5 255 7050 @290 v10036
7051 5 255 7050 @284 v10037
8051 4 255 90 @28
#5
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 60 -1 0.0333333351 -999
120 23 255 v10036 v10000 4
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 50 255 v10037 6 120 @25
120 110 255 0 0
120 97 255 6 v6 1 1 2.5 2 v10023 0 8788
120 4 255 120 @27
120 46 255 v10037 7 120 @27
120 6 255 v10037 -1
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 6 v6 3 1 0.5 2 v10077 v10023 0
120 11 255 v10000 4
120 10 255 v10001 1
120 15 255 v10019 v10020
124 5 255 120 @15 v10036
124 1 255
#6
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0333333351 -999
120 23 255 v10036 v10000 3
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 50 255 v10037 3 120 @25
120 110 255 0 0
120 97 255 6 v6 1 1 2 2 v10023 0 8788
120 4 255 120 @27
120 46 255 v10037 7 120 @27
120 6 255 v10037 -1
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 6 v6 2 1 0.5 2 v10077 v10023 0
120 11 255 v10000 3
120 24 255 v10003 v10037 2
120 42 255 v10003 0 120 @40
120 10 255 v10001 1
120 15 255 v10019 v10020
123 5 255 120 @15 v10036
123 1 255
#7
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0333333351 -999
120 23 255 v10036 v10000 3
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 50 255 v10037 15 120 @25
120 110 255 0 0
120 97 255 6 v6 1 1 2 2 v10023 0 8788
120 4 255 120 @27
120 46 255 v10037 20 120 @27
120 6 255 v10037 -1
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 6 v6 2 1 0.5 2 v10077 v10023 0
120 11 255 v10000 3
120 24 255 v10003 v10037 2
120 42 255 v10003 0 120 @40
120 10 255 v10001 1
120 15 255 v10019 v10020
123 5 255 120 @15 v10036
123 1 255
#8
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0188888889 -999
120 23 255 v10036 v10000 3
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 50 255 v10037 3 120 @25
120 110 255 0 0
120 97 255 6 v6 1 1 2 2 v10023 0 8788
120 4 255 120 @27
120 46 255 v10037 9 120 @27
120 6 255 v10037 -1
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 6 v6 2 1 0.5 2 v10077 v10023 0
120 11 255 v10000 3
120 24 255 v10003 v10037 2
120 42 255 v10003 0 120 @40
120 10 255 v10001 1
120 15 255 v10019 v10020
123 5 255 120 @15 v10036
123 1 255
#9
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0266666673 -999
121 23 255 v10036 v10000 2
121 6 255 v10037 0
121 111 255 0 8192 0 v10000 -1 -1 -1
121 111 255 1 16 0 v10001 -1 0 -999
121 21 255 v10003 v10000 v10001
121 111 255 3 16 0 v10000 -1 0 -999
121 25 255 v10023 v10069 v10019
121 37 255 v10023
121 110 255 0 0
121 97 255 6 v6 1 2 2 1 v10023 0 8788
121 6 255 v10037 -1
121 30 255 v10037
121 33 255 v10057 v10023
121 32 255 v10058 v10023
121 17 255 v10057 16
121 17 255 v10058 16
121 27 255 v10023 v10033 0.392699093
121 15 255 v10023 0.0349065848
121 110 255 v10057 v10058
121 97 255 6 v6 2 1 0.5 2 v10077 v10023 0
121 11 255 v10000 3
121 24 255 v10003 v10037 4
121 42 255 v10003 0 121 @37
121 10 255 v10001 1
121 15 255 v10019 v10020
123 5 255 121 @15 v10036
123 1 255
#10
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0377777778 -999
121 23 255 v10036 v10000 2
121 6 255 v10037 0
121 111 255 0 8192 0 v10000 -1 -1 -1
121 111 255 1 16 0 v10001 -1 0 -999
121 21 255 v10003 v10000 v10001
121 111 255 3 16 0 v10000 -1 0 -999
121 25 255 v10023 v10069 v10019
121 37 255 v10023
121 110 255 0 0
121 97 255 11 v11 1 2 4 1 v10023 0 8788
121 6 255 v10037 -1
121 30 255 v10037
121 33 255 v10057 v10023
121 32 255 v10058 v10023
121 17 255 v10057 16
121 17 255 v10058 16
121 27 255 v10023 v10033 0.392699093
121 15 255 v10023 0.0349065848
121 110 255 v10057 v10058
121 97 255 11 v11 2 1 0.5 2 v10077 v10023 0
121 11 255 v10000 3
121 24 255 v10003 v10037 4
121 42 255 v10003 0 121 @37
121 10 255 v10001 1
121 15 255 v10019 v10020
123 5 255 121 @15 v10036
123 1 255
#11
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0411111116 -999
120 23 255 v10036 v10000 3
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 50 255 v10037 3 120 @25
120 110 255 0 0
120 97 255 11 v11 1 1 2 2 v10023 0 8788
120 4 255 120 @27
120 46 255 v10037 9 120 @27
120 6 255 v10037 -1
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 11 v11 2 1 0.5 2 v10077 v10023 0
120 11 255 v10000 3
120 24 255 v10003 v10037 2
120 42 255 v10003 0 120 @40
120 10 255 v10001 1
120 15 255 v10019 v10020
123 5 255 120 @15 v10036
123 1 255
#12
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0377777778 -999
121 23 255 v10036 v10000 2
121 6 255 v10037 0
121 111 255 0 8192 0 v10000 -1 -1 -1
121 111 255 1 16 0 v10001 -1 0 -999
121 21 255 v10003 v10000 v10001
121 111 255 3 16 0 v10000 -1 0 -999
121 25 255 v10023 v10069 v10019
121 37 255 v10023
121 110 255 0 0
121 97 255 11 v11 1 1 6 1 v10023 0 8788
121 6 255 v10037 -1
121 30 255 v10037
121 33 255 v10057 v10023
121 32 255 v10058 v10023
121 17 255 v10057 16
121 17 255 v10058 16
121 27 255 v10023 v10033 0.392699093
121 15 255 v10023 0.0349065848
121 110 255 v10057 v10058
121 97 255 11 v11 2 1 0.5 2 v10077 v10023 0
121 11 255 v10000 3
121 24 255 v10003 v10037 4
121 42 255 v10003 0 121 @37
121 10 255 v10001 1
121 15 255 v10019 v10020
123 5 255 121 @15 v10036
123 1 255
#13
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0411111116 -999
120 23 255 v10036 v10000 3
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 50 255 v10037 5 120 @25
120 110 255 0 0
120 97 255 11 v11 1 1 2 2 v10023 0 8788
120 4 255 120 @27
120 46 255 v10037 11 120 @27
120 6 255 v10037 -1
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 11 v11 2 1 0.5 2 v10077 v10023 0
120 11 255 v10000 3
120 24 255 v10003 v10037 2
120 42 255 v10003 0 120 @40
120 10 255 v10001 1
120 15 255 v10019 v10020
123 5 255 120 @15 v10036
123 1 255
#14
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0411111116 -999
120 23 255 v10036 v10000 2
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 110 255 0 0
120 97 255 11 v11 1 2 5 2 v10023 0 8788
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 11 v11 2 1 0.5 2 v10077 v10023 0
120 11 255 v10000 2
120 24 255 v10003 v10037 2
120 42 255 v10003 0 120 @36
120 10 255 v10001 1
120 15 255 v10019 v10020
122 5 255 120 @15 v10036
122 1 255
#15
0 54 255 48
0 82 255 0
0 80 255 19
0 28 255 v10023 v10018 120
0 7 255 v10021 v10042
0 7 255 v10022 v10043
0 72 255 120 v10021 v10022 v10016 v10017 0 v10023
0 27 255 v10023 v10017 120
0 15 255 v10023 v10016
0 37 255 v10023
120 72 255 0 v10021 v10022 v10023 v10017 v10018 0
120 111 255 2 64 0 1 1 0 0
120 111 255 4 16 0 90 -1 0.0188888889 -999
120 23 255 v10036 v10000 2
120 6 255 v10037 0
120 111 255 0 8192 0 v10000 -1 -1 -1
120 111 255 1 16 0 v10001 -1 0 -999
120 21 255 v10003 v10000 v10001
120 111 255 3 16 0 v10000 -1 0 -999
120 25 255 v10023 v10069 v10019
120 37 255 v10023
120 50 255 v10037 31 120 @25
120 110 255 0 0
120 97 255 11 v11 1 2 5 1 v10023 0 8788
120 4 255 120 @27
120 46 255 v10037 33 120 @27
120 6 255 v10037 -1
120 30 255 v10037
120 33 255 v10057 v10023
120 32 255 v10058 v10023
120 17 255 v10057 16
120 17 255 v10058 16
120 27 255 v10023 v10033 0.392699093
120 15 255 v10023 0.0349065848
120 110 255 v10057 v10058
120 97 255 11 v11 2 1 0.5 2 v10077 v10023 0
120 11 255 v10000 2
120 24 255 v10003 v10037 2
120 42 255 v10003 0 120 @40
120 10 255 v10001 1
120 15 255 v10019 v10020
122 5 255 120 @15 v10036
122 1 255
#16
0 6 255 v10036 30
0 139 255 17 4 -1
1 5 255 0 @1 v10036
1 53 255
]]
