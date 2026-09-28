---=====================================
---TH34  东方妖妖梦（TH07）第 6 关道中 —— 成群亡灵
---
---把原作 `data/ecldata6.ecl` **时间轴 0（偏移 0xE050）** 里 t=720..1614 的那一段
---道中（47 只幽灵）复刻成一张符卡，挂在一个**空 boss** 上。
---
---数据来源（逐字节读的字节码，没有用 decl）：
---  · 时间轴 0（0xE050）  47 条 spawn_enemy：sub / 坐标 / life / itemdrop / score
---  · 子程序（ECL sub）
---      8       0x7b0   烟尘（80 帧，飘到出生点）
---      4       0x480   残火（120 帧，向上飘 150 px）
---      5       0x698   残火被击破时的回调（原作走不到 —— 残火 CAN_DIE 0）
---      9/11/13/15      生成器：SUB_CALL 8 → SPAWN_ENEMY_REL 10/12/14/16 → 自毁
---      10/12/14/16     小怪本体：漂移 + 每 5 帧一轮同心环，共 28 轮
---      6/7     0x6c0/0x728  小怪死亡回调：生成残火（7 号额外撒 4 能量 + 3 点）
---  反汇编脚本在 `/tmp/eclwork/{d.py,tls.py,ecl.py}`；语义按
---  `/Users/happyelements/th07/src/th07/EclManager.cpp` 的 RunEcl 还原，
---  弹的参数按同目录 `BulletManager.cpp` 的 SpawnBulletPattern / SpawnSingleBullet 还原。
---
---坐标（两边场地都是 384x448，比例 1:1，长度一律不缩放）
---  TH07 的原点在**左上**、y 轴朝下（BulletManager.cpp:889 判 x∈[0,384)、y∈[0,448)）；
---  我们的原点在中心、y 轴朝上（lstg.world.l/r/b/t = -192/192/-224/224）。纯翻转：
---      我们的 x = TH07 的 x − 192
---      我们的 y = 224 − TH07 的 y
---  位置本身就是硬证据：这 47 个出生点的 x 落在 {32,64,…,352}、**恰好关于 192 对称**
---  （64↔320、96↔288、128↔256、160↔224），y∈{64,80,96,112} 全在画面上方。
---  角度取反（θ → −θ）。这一段只有**整圈的环**，环的集合取反之后不变，
---  唯一要跟着取反的是「第二层相对第一层转 90°」那一处（见 VOL_LAYER_DEG）。
---
---这段道中在干什么（自然语言版）
---  时间轴每 10 帧（最后一批每 6 帧）在一个**固定出生点**放一只「种子幽灵」。
---  每只种子先原地当 **80 帧烟尘**：贴图是烟/光晕，位置沿一条 Hermite 曲线从
---  「出生点**下方 161 px、偏右 14 px**」飘到出生点，横向还会左右摆 ±30 px 左右
---  （两条独立的 ±144 随机切线）。80 帧一到，它**原地变成幽灵**：换成 4 帧循环的
---  灵体贴图、开判定、出生后 10 帧无敌，从此按 0.02 px/帧² 匀加速朝一个**固定**方向
---  平移 —— 出生在左半边的向右、右半边的向左，正好都朝画面中间走。
---  同时开始**每 5 帧放一轮弹**，一共 28 轮（第 0 帧就放第一轮 ⇒ t=0,5,…,135）。
---
---  一轮弹 =「共用同一个基准角的两层同心环」（原作一条 op67 就是这两层）：
---    · 基准角 angle1 = $10060 = ECL_VAR_RNG_RADIAN ⇒ 每轮重掷一次 [−π,π)
---    · 第一层 5 枚（count1=5），间隔 360/5 = 72°，速度 v = ran(0,3)+0.5 ∈ [0.5,3.5]
---    · 第二层 5 枚，基准角再转 angle2 = π/2（⇒ 我们 −90°），
---      速度 = speed1 − (speed1 − speed2) * 1/2 = (v + 0.5) / 2（speed2 = 0.5）
---    · 两层的 v 与基准角是**同一个**（都由那一条 op67 读一次）
---  子弹是**直线弹**：从出生点算起固定角度、飞出去就不管自机了（不瞄自机）。
---  颜色按漂移方向分：**向右的蓝、向左的红**（原作 spriteOffset 6 / 2 两种箭头色）。
---  小怪血 80、无体术判定（碰到自机不掉血，原作 HAS_CONTACT_HITBOX 0）。
---  被击破时原地留一团**残火**（120 帧，向上飘 150 px 后消失），掉 1~2 个道具
---  （原作 itemdrop 0=小能量 1=点 2=大能量；本仓库没有能量类道具，见差异 4）。
---  t≥1530 那一批（原作 sub 13/15）的残火额外再撒 4 个小能量 + 3 个点。
---  最后一只在 t=1614 出现，它的本体到 1614+80+140 = 1834 帧才打完，之后是幽幽子登场。
---
---  ★ 同屏弹池：原作全游戏共用 **1024** 个弹槽（TH07 `BulletManager.hpp:254`），这一段
---  在真机上**长期顶着上限**（47 只 × 28 轮 × 10 发 = 13160 发要往外挤）——池满时
---  整波不生、生到一半见底就丢剩下的（`BulletManager.cpp:635-663`）。移植版照做了
---  （见下面的 `POOL_SIZE`），不这么做的话同屏会堆到 4500 发、自检报「墙 + 死局 9%」。
---
---与原作的不同（代码里按「差异 N」引用；每条都写了为什么）
---  1  拖影是代理：原作 SET_TRAIL 0x19,48,16,1（enemy trail vm），移植版用
---     object.smear_add/frame/render 三件套，衰减 13（≈20 帧尾巴）。
---  2  载体与小怪**合成一个对象**。原作是两个实体：时间轴放出载体（sub 9/11/13/15）
---     先 `SUB_CALL 8` 当 80 帧烟尘，再 `SPAWN_ENEMY_REL` 在原地生一只真幽灵、自己自毁。
---     两者位置/朝向/血量/掉落完全一致 ⇒ 移植版第 80 帧换贴图开判定；代价是少一次
---     0x300 死亡特效（载体那一份）。
---  3  不做 rank 缩放。符卡阶段原作整段跳过 rank 分支
---     （EclManager.cpp:1305-1320 的 `if (!spellcardInfo.isActive)`），所以本卡固定取
---     **Lunatic 那一行**（count1=5、count2=2 ⇒ 每轮 10 发）；Easy/Normal/Hard 是 5 发。
---  4  道具是近似：原作 itemdrop 0/1/2 = 小能量/点/大能量，而本仓库 item.obj 里没有
---     「能量(power)」类道具 ⇒ 0/2 折成信仰道具（小能量 1 个、大能量 2 个）。
---  5  不做 SPAWN_FAST：原作这四条 op67 的 flags = 0x203 都带 0x2（出生位置先退
---     `velocity*4`、再播 10 帧塞弹动画，BulletManager.cpp:297-302）；移植版弹直接以
---     全速出膛，观感差别只是「少了那 10 帧的出生动画」。
---  6  SUB_CALL 8 是**阻塞**调用 ⇒ 原作小怪比时间轴晚 80 帧出生（载体已经死了）。
---     移植版同一帧生载体、第 80 帧变幽灵（就是差异 2 的那个合成对象）。
---  7  插值按引擎的「初始化那一刻快照 + 逐帧递推」实现：INIT_INTERP
---     （EclManager.cpp:1070-1088）在 t=0 就把 `p1 = POS_X / POS_Y` 求值冻成出生点，
---     不是每帧重读。
---  8  环**不瞄自机**（原作 aimMode = RING_ABSOLUTE），所以这一段不吃自机位置 ——
---     自检的「被打频率」偏低是正常的。
---  9  贴图是**代理**：本体借 style 31（`ghost_fire_r` 红焰粒子 + `Ghost1` 的 8 帧幽灵
---     本体 + aura1 光环），烟尘阶段与残火借 style 27（同一团红焰、不叠本体）
---     —— WalkImageSystem.lua:325-340 的实际渲染规则见常量段。原作 sprite 27 是橙白
---     4 帧幽灵、sprite 30 是烟，灰阶遮罩那一层没有对应资源，颜色不保证一样。
--- 10  残火末 20 帧淡出（原作 t=120 的 UNIMP 是硬销毁）——7.8-4「不许子弹突然消失」的精神。
--- 11  加速 0.02/帧² ⇒ 幽灵约 100 帧后漂出场地，最后几轮（28 轮里约 8 轮）打不完 —— 原作
---     同样如此，不是移植的疏漏。
--- 12  空 boss 用 `img_void`（THlib/misc/misc.lua:523 的 2×2 透明图）不显形，放在场地外。
--- 13  小怪**只在被击破时**掉道具（原作 time line 的 itemdrop 就挂在它身上）；自机不打
---     就一颗都没有。
--- 14  原作一条 op67 一次生完「5 + 5」两层，移植版按引擎的双重循环顺序生（层先、环后）——
---     同一轮的弹共用一个基准角/速度，看不出差别。
--- 15  时间轴 t 从**卡开始**算（原作 t=720 映射成 0）。
---
---实测（`luajit tools/check_stage.lua mod/GAME/th34.lua 1800 --threat`，场地 384×448）
---  · 60px 内弹数 平均 12.5 / 峰值 30（AGENTS §7.2 的「标准符卡 5~14」档）
---  · 死局 1.1%（20 帧，全是 5+5 两层叠在一处的瞬间）；安全角度均 8.9/24
---  · 峰值同屏 弹 **1024**（= 原作弹池上限，说明池子在正确地丢弹）/ 对象 23 / 拖影 2
---  · 6 个种子（20260916/11111/98765/55555/31415/777）跑最坏：平均 11.1~12.5、
---    死局 0.1%~1.1%、峰值弹 1023~1024 —— 没有种子把池子挤爆或出现空档。
---  · 泄漏扫描：3600 帧与 7200 帧的峰值完全一致（对象 23 / 弹 1024）⇒ 没有漏回收。
---  · `tools/threat.lua`（独立的第二把尺）：威胁度 1.52、威胁组数 1.00（最多 5）、
---    安全区有周期 —— 文档的 0.5~1.5 是**符卡**的标尺，这一段是道中；同目录 th33 的
---    三张 boss 卡实测是 15.2 / 12.1 / 2.2，所以 1.52 属于偏轻的一档。
---  · `tools/check_fields.lua` 通过；`check_stage.lua --all` 通过（boss 241 / 符卡 491）。
---  · ★ 本文件**还没挂进 StageID**（`mod/_editor_output.lua:47` 只到 "33"），所以游戏现在
---    根本不会载入它 —— 要真进游戏得按 AGENTS §8 把 9 处一起改（`core.lua` 的
---    STAGE_COUNT 31→32、StageID 加 "34"、stage_pic 循环、UI 的 difftext/sntext、
---    main_stage 的 NewStage、music、成就、素材）。**只把 "34" 塞进 StageID 是不行的**：
---    th16AEX 现在占着 `STAGE_COUNT + 1` = 32 这一档、editname 也是 "1a"，而它**最后载入**
---    （_editor_output.lua:1228），会把 `_editor_boss["1a32"]` 整条盖掉 ⇒ 这张卡会挂到
---    一个没人用的空 boss 类上。动 STAGE_COUNT 之后 AEX 顺延到 33，32 才是 th34 的档。
---
---逐波表（47 只；dt = 相对上一只的帧间隔；x/y 已经是**我们的坐标**；
---        R = 向右漂（蓝）、L = 向左漂（红）；末位 * = 这一批的残火额外掉道具）
---  A t=720    dt 10 : L( 128,112) L( 112,128) L(  96,144) L( 64,160)
---  B t=950    dt 10 : R(-128,112) R(-112,128) R( -96,144) R(-64,160)
---  C t=1180   dt 10 : L( 32,112) R(-128,112) L( 96,128) R( -64,128)
---                     L(128,144) R( -96,144) L( 64,160) R( -32,160)
---  D t=1310   dt 10 : 同 C 的形状
---  E t=1440   dt 10 : L( 32,112) R(-160,112) L( 96,128) R( -64,160)
---                     L(160,144) R(-128,144) L( 64,160) R( -32,160)
---  F t=1530   dt  6 : L( 32,112)* R(-128,112)* … 15 只，全是 sub 13/15
--------------------------------------------------------------

local class = {}
_editor_class["TH34"] = class

local task, object, enemy, New = task, object, enemy, New
local Class = Class
local PlaySound, Render = PlaySound, Render
local SetImageState = SetImageState
local ran, cos, sin, min, max, int = ran, cos, sin, min, max, int
local item = item
local arrow_small, COLOR = arrow_small, COLOR
local NewSimpleBullet = NewSimpleBullet
local boss, TH07_bg = boss, TH07_bg
local IsValid, lstg = IsValid, lstg

---Hermite 插值（原作 EclManager.cpp:630 `MathCubicInterp` 就是这四个基函数，
---t 已经归一化过：t = min(timer, n) / n）。
---注意原作 INIT_INTERP（EclManager.cpp:1070-1088）在**初始化那一刻**就把
---p0/p1/m0/m1 各求值一次存成数字，之后逐帧递推 —— 所以下面这一族参数是**常量**，
---不是每帧重读的表达式（`p1 = POS_X` 在那个时刻就被冻结成出生点坐标了）。
local function hermite(t, p0, p1, m0, m1)
    local h00 = (t - 1) * (t - 1) * (2 * t + 1)
    local h01 = t * t * (3 - 2 * t)
    local h10 = (1 - t) * (1 - t) * t
    local h11 = (t - 1) * t * t
    return h00 * p0 + h01 * p1 + h10 * m0 + h11 * m1
end

---原作 ECL_RAND_SIGN_FLOAT：50% 掷 +1 / −1（EclManager.cpp:989）。
local function rnd_sign()
    if ran:Int(0, 1) == 0 then
        return 1
    end
    return -1
end

---原作 sub 7 的 SPAWN_ITEMS / SPAWN_POINT_ITEMS：在敌人位置**周围 ±64 px 内**
---随机撒（EclManager.cpp 的 `GetRandomFloatInRange(128.0f) - 64.0f`）。
local function scatter_items(obj, n, x, y)
    for _ = 1, n do
        New(obj, x + ran:Float(-64, 64), y + ran:Float(-64, 64))
    end
end

---=================== 这一卡的全部数值（改手感只动这一段） ===================
---代理贴图（见差异 9）。本仓库 style 27..34 的**实际渲染**（WalkImageSystem.lua:325-340）：
---  · 27     = `ghost_fire_r` 粒子，**不叠幽灵本体**（28/29/30 才叠 `Ghost2/3/4`）
---  · 31..34 = `ghost_fire_r/b/g/y` + 叠 `Ghost1/2/3/4` 的 8 帧本体
---所以：**本体**要能看见 ⇒ 幽灵用 31（红焰 + Ghost1，还自带一圈光环 aura1）；
---纯火焰（烟尘阶段、残火）用 27（只有焰、没身体）。两边都是红焰 ⇒ 一张卡一个色系。
local GHOST_STYLE, PUFF_STYLE, FLAME_STYLE = 31, 27, 27
local GHOST_HP = 80             -- 原作时间轴的 life=80（EnemyManager.cpp:885 里 life 就是血）
local GHOST_INVUL = 10          -- 原作 ECL_SET_INVINCIBILITY_TIMER 10
local PUFF_FRAMES = 80          -- 原作 sub 8 的 SUB_RET 落在 t=80
local DRIFT_ACCEL = 0.02        -- 原作 ECL_SET_MOVE_ACCEL 0.02（匀加速，不是匀速）
local VOLLEY_N = 28             -- 原作 SET_INT i10012=28（DEC_JUMP 先减后跳 ⇒ 正好 28 轮）
local VOLLEY_GAP = 5            -- 原作 DEC_JUMP 落在 t=5
local VOL_COUNT = 5             -- Lunatic 行 count1 = 5（一圈 5 枚）
local VOL_LAYER = 2             -- Lunatic 行 count2 = 2（两层；Easy/Normal/Hard 都是 1）
local VOL_LAYER_DEG = -90       -- 原作 angle2 = π/2（TH07 y 朝下）⇒ 我们 −90°
local VOL_SPEED_MAX, VOL_SPEED_ADD = 3, 0.5   -- Lunatic 行 RAND_FLOAT_ADD 3, 0.5
local VOL_SPEED2 = 0.5          -- 原作 speed2 = 0.5（第二层的落点速度）
local PUFF_M = 144              -- 原作 RAND_SIGN_FLOAT 144（X 的 m0、m1 各掷一次）
local PUFF_X0, PUFF_Y0 = 14, -161   -- p0 = (X₀+14, Y₀+161)（TH07 y 朝下 ⇒ 我们 −161）
local PUFF_Y_M0, PUFF_Y_M1 = -16, 32  -- Y 的 m0 = +16（TH07）⇒ 我们 −16；m1 = ±32
local FLAME_FRAMES = 120        -- 原作 t=120 的 UNIMP 就是销毁
local FLAME_M = 144             -- X 的 m0、m1 各 ±144
local FLAME_X1, FLAME_Y1 = -8, 150  -- p1 = (X₀−8, Y₀−150) ⇒ 我们 (−8, +150)
local FLAME_Y_M0, FLAME_Y_M1 = -35, 32  -- Y 的 m0 = +35（TH07）⇒ 我们 −35；m1 = ±32
local FLAME_FADE = 20           -- 原作是硬销毁；末 20 帧淡出，免得「啪」一下没了（差异 10）
local TRAIL_DECAY = 13          -- 原作 SET_TRAIL 0x19,48,16,1 的代理（差异 1）

---原作同屏弹幕上限：全游戏共用 **1024** 个弹槽（TH07 `BulletManager.hpp:254`
---`#define MAX_BULLETS 1024`）。丢弹规则（`BulletManager.cpp:635-663`）：
---  · `bulletCount >= MAX_BULLETS` ⇒ **整波不生**（连第一颗都不生）
---  · 生到一半槽位见底 ⇒ `SpawnSingleBullet` 返回 1、`goto stop` **放弃整波剩下的**
---    （已经生出来的那几颗留着）
---  · 两条路径**都照放 0x200 的音效** —— `stop:` 标签排在音效之前
---这一段道中在真机上**长期顶着上限**：47 只幽灵、每只每 5 帧 10 发，整段一共要 13160 发。
---本仓库的引擎对象池是动态的（LuaSTG-Sub 源码里没有任何弹数上限），所以本卡自己
---维护一张登记表 —— 与 th31.lua 的 Last Word 移植同一套做法（那边是 1536）。
local POOL_SIZE = 1024
local pool = {}

local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

---还占着槽位的弹有几颗。原作每帧边扫边数（`BulletManager.cpp:942` 那段），
---这里只在出弹帧数一次 —— 出弹帧之外池子不会变。
local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---同一帧里同一种音效只响一声：原作 `SoundPlayer.cpp:589-612` 的队列**按 idx 去重**
---（8 只幽灵在同一帧各出一轮，真机只会响一次）。tick 由卡的 frame 每帧推一格，
---这样不管协程谁先醒，同一帧里的第二只幽灵就响了。
local sound_tick, sound_stamp = 0, -1

---原作 itemdrop：0 = ITEM_POWER_SMALL、1 = ITEM_POINT、2 = ITEM_POWER_BIG
---（ItemManager.hpp:9-11）。本仓库没有「能量」类道具（item.obj 只有 faith / point /
---sakura / …），所以 0/2 都折成信仰道具：小能量给 1 个、大能量给 2 个（差异 4）。
local DROP_FAITH = { [0] = 1, [1] = 0, [2] = 2 }
local DROP_POINT = { [0] = 0, [1] = 1, [2] = 0 }

---一次发弹（原作 sub 10/12/14/16 里那 4 条 op67 的 **Lunatic 行**）。
---角度：`angle = 环序 * 2π/count1 + 层序 * angle2 + angle1`
---     （BulletManager.cpp:184-202 的 BULLET_AIM_RING_ABSOLUTE）
---速度：`count2 > 1` 时第 k 层 = `speed1 − (speed1 − speed2) * k / count2`，否则恒为 speed1
---     （BulletManager.cpp:169-176）⇒ Lunatic 第二层 = (v + 0.5) / 2。
---生成顺序是**外层（层）先、内层（环）后**（BulletManager.cpp:642-651 的双重循环：
---外层走 count2、内层走 count1）—— 池子见底时先被丢掉的正是靠后的层。
local function volley(self)
    local v = ran:Float(0, VOL_SPEED_MAX) + VOL_SPEED_ADD
    local base = ran:Float(0, 360)          -- ECL_VAR_RNG_RADIAN：每轮读一次就是新角
    ---向右漂的用蓝箭头、向左漂的用红箭头（原作 spriteOffset 6 / 2 就是这两种色）
    local col = (self.dir > 0) and COLOR.DEEP_BLUE or COLOR.RED
    ---★ 掷随机数发生在 op9、出弹在 op67，而丢弹的判定在 SpawnBulletPattern **里面** ——
    ---  所以「整波不生」也照样把这一轮的 v 与 base 消耗掉了（顺序不能颠倒）。
    local room = POOL_SIZE - pool_used()
    if room > 0 then
        local step = 360 / VOL_COUNT
        local total, k = VOL_COUNT * VOL_LAYER, 0
        while k < total and room > 0 do
            local layer = int(k / VOL_COUNT)
            local ring = k % VOL_COUNT
            local spd = (layer == 0) and v or v - (v - VOL_SPEED2) * layer / VOL_LAYER
            local a = base + layer * VOL_LAYER_DEG + ring * step
            pool[#pool + 1] = NewSimpleBullet(arrow_small, col, self.x, self.y, spd, a, false, 0, false)
            room, k = room - 1, k + 1
        end
    end
    ---原作 flags 0x203 含 0x200 PLAY_SPAWN_SOUND（BulletManager.cpp:657）：整波响一次、
    ---整波没生出来也照响。soundIdx 是敌人出厂时的默认值 7（`EnemyManager.hpp:346`
    ---`SOUND_BOMB_MARISA_A_FOCUS`，每题都是这个默认）⇒ `SOUND_BUFFER_IDX_VOL[7]`
    ---= buffer 5 = `se_tan00.wav`、音量 −15 dB（`SoundPlayer.cpp:11-15`）。
    if sound_stamp ~= sound_tick then
        sound_stamp = sound_tick
        PlaySound("tan00", 0.08, self.x / 256)
    end
end

---──────────────────── 小怪：烟尘 80 帧 → 幽灵 140 帧 ────────────────────
---原作是**两个实体**：时间轴放出来的载体敌人（sub 9/11/13/15）先跑 `SUB_CALL 8`
---当 80 帧烟尘，然后 `SPAWN_ENEMY_REL 10/12/14/16` 在原地生出一只新的幽灵敌人，
---最后把自己的 LIFE 置 0 自毁。两者位置、朝向、血量、掉落完全一致，
---所以移植版**合成一个对象**、第 80 帧换贴图开判定 —— 少一次 0x300 死亡特效（差异 2）。
class["TH34_ghost"] = Class(enemy, {
    ---@param dir number +1 向右漂、−1 向左漂（原作 sub 10/14 是 0、sub 12/16 是 π）
    ---@param drop number 原作时间轴的 itemdrop（0/1/2）
    ---@param extra boolean 原作 sub 13/15 ⇒ 残火额外掉道具（sub 7）
    init = function(self, x, y, dir, drop, extra)
        ---前 80 帧是 style 27（红焰粒子、**没有身体**）——「鬼火升起」；第 80 帧换成
        ---style 31（同一团红焰，但叠上 Ghost1 的 8 帧幽灵本体）——「幽灵现身」（差异 9）。
        ---nontaijutsu = true ⇒ group 是 NONTJT：能被打、**碰到自机不掉血**
        ---（对应原作 HAS_CONTACT_HITBOX 0，ext.lua:210 只把 NONTJT 配给自机子弹）
        enemy.init(self, PUFF_STYLE, GHOST_HP, false, true, true)
        self.x, self.y = x, y
        self.hx, self.hy = x, y             -- 出生点：INIT_INTERP 快照的基准
        self.dir, self.extra = dir, extra
        self.spd = 0
        self.protect = true                 -- 出生 10 帧无敌（原作 INVINCIBILITY_TIMER）
        self.colli = false                  -- 烟尘阶段不可打（原作 IS_HITTABLE 0）
        self.drop = { 0, DROP_FAITH[drop], DROP_POINT[drop] }
        ---两条 Hermite 的常量（原作 t=0 那一帧求值一次后冻结，见文件头的说明）
        self.px0, self.px1 = PUFF_X0, 0
        self.py0, self.py1 = PUFF_Y0, 0
        self.mx0, self.mx1 = rnd_sign() * PUFF_M, rnd_sign() * PUFF_M
        self.my0, self.my1 = PUFF_Y_M0, rnd_sign() * PUFF_Y_M1
        ---贴图名再显式写一次：真机上 `_wisys:SetImage`（WalkImageSystem.lua:362-377）会写
        ---`obj.img`，但自检桩件里的 `enemy` 是简化 mock（不建行走图系统那一层），而
        ---`smear_add` 读的正是 `self.img`（AGENTS §9 A4：漏了就是 `SetImageState(nil,…)`）。
        self.img = "ghost_fire_r"
        object.smear_add(self, 120)         -- 原作 SET_TRAIL 0x19,48,16,1 的代理
        ---★ 生命周期写在单个协程里：前 80 帧什么都不做（烟尘由 frame 里的插值驱动），
        ---第 80 帧（= task.Wait(80) 醒来的那一帧）换装开火。
        task.New(self, function()
            task.Wait(PUFF_FRAMES)
            self._wisys:SetImage(GHOST_STYLE)
            self.smear = nil                -- 换了贴图，别把烟尘的残影拖到幽灵身上
            self.colli = true
            task.New(self, function()
                task.Wait(GHOST_INVUL)
                self.protect = false
            end)
            for _ = 1, VOLLEY_N do
                volley(self)
                task.Wait(VOLLEY_GAP)
            end
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        if self.timer <= PUFF_FRAMES then
            ---烟尘阶段：位置 = 出生点 + 插值（原作 INIT_INTERP 每帧往 POS_X/POS_Y 写值）
            local t = self.timer / PUFF_FRAMES
            self.x = self.hx + hermite(t, self.px0, self.px1, self.mx0, self.mx1)
            self.y = self.hy + hermite(t, self.py0, self.py1, self.my0, self.my1)
        else
            ---幽灵阶段：原作 MOVE_DIR_TIME(角度) + SET_MOVE_ACCEL 0.02 的匀加速直线
            self.spd = self.spd + DRIFT_ACCEL
            object.SetV(self, self.spd, (self.dir > 0) and 0 or 180, false)
        end
        object.smear_frame(self, TRAIL_DECAY)
    end,
    render = function(self)
        object.smear_render(self, "mul+add", { 190, 210, 255 })
        enemy.render(self)
    end,
    ---击破：原作 SCORE_ONLY(1) + DEATH_CALLBACK_SUB 6（sub 7）—— 原地生成残火，
    ---14/16 那一支（extra）还额外撒道具。
    kill = function(self)
        New(class["TH34_flame"], self.x, self.y)
        if self.extra then
            scatter_items(item.obj.faith, 4, self.x, self.y)
            scatter_items(item.obj.point, 3, self.x, self.y)
        end
        enemy.kill(self)
    end,
})

---──────────────────── 残火（原作 sub 4）：120 帧，向上飘 150 px ────────────────────
---原作 SET_ANM 31 + CAN_DIE 0 + IS_HITTABLE 0：纯演出、打不掉、t=80 切 VM 中断、
---t=120 UNIMP 销毁。两条 Hermite 的常量同样是初始化时冻结的。
---（我们的代理是 style 27 = 只有红焰粒子、不叠幽灵本体 —— 残火就该是一团火，见差异 9。）
class["TH34_flame"] = Class(enemy, {
    init = function(self, x, y)
        enemy.init(self, FLAME_STYLE, 1, false, false, true)
        self.x, self.y = x, y
        self.hx, self.hy = x, y
        self.fx0, self.fx1 = rnd_sign() * FLAME_M, rnd_sign() * FLAME_M
        self.fy1 = rnd_sign() * FLAME_Y_M1
        self.colli = false
        self.img = "ghost_fire_r"           -- 同 style 27/31（WalkImageSystem.lua:367）
        object.smear_add(self, 130)
    end,
    frame = function(self)
        enemy.frame(self)
        local t = min(self.timer, FLAME_FRAMES) / FLAME_FRAMES
        self.x = self.hx + hermite(t, 0, FLAME_X1, self.fx0, self.fx1)
        self.y = self.hy + hermite(t, 0, FLAME_Y1, FLAME_Y_M0, self.fy1)
        ---原作 t=80 切中断、t=120 直接销毁；这里用末 20 帧淡出代替「切图」
        if self.timer > FLAME_FRAMES - FLAME_FADE then
            self._a = max(0, 255 * (FLAME_FRAMES - self.timer) / FLAME_FADE)
        end
        object.smear_frame(self, TRAIL_DECAY)
        if self.timer >= FLAME_FRAMES then
            object.RawDel(self)
        end
    end,
    render = function(self)
        object.smear_render(self, "mul+add", { 255, 200, 140 })
        enemy.render(self)
    end,
})

---==================== 挂到空 boss 的一张符卡上 ====================
---本卡是「道中搬运卡」：boss 本体什么都不做 —— `img_void` 是不显形的空图
---（THlib/misc/misc.lua:523 注册的 2x2 透明图），位置放在场地外 (0,400)，
---所以画面上只有 47 只幽灵和它们的弹。符卡本身是**耐久卡**
---（t1 = t2 = t3 ⇒ boss_system.lua:161 判成耐久卡、伤害恒 0），
---它只负责把这段道中的时间轴按帧跑完。
do
    local BOSS_NAME = "亡灵"
    ---原作这一段是 t=720..1614（最后一只的本体打到 1834 帧、残火到 1954 帧），约 17 秒；
    ---给 24 秒留够收尾的余量。
    local CARD_NAME = "六面道中「成群的亡灵」"
    local CARD_TIME = 24
    ---关卡号 32 = 现在 `core.lua` 的 STAGE_COUNT(31) + 1，注册成正式关卡后就是 th34 自己的档
    ---（th16AEX 用 `STAGE_COUNT + 1`，会顺延到 33）。⚠ 注册之前 32 这一档是 th16AEX 占着的，
    ---而它在 `_editor_output.lua:1228` **最后载入**、editname 也是 "1a" ⇒ 只把 "34" 塞进
    ---StageID 的话，`_editor_boss["1a32"]` 会被它的 `boss.Define` 盖掉。见文件头的说明。
    local LEVEL = 32
    ---符卡历史槽位（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
    ---实测：把全项目 `boss.card.add` 的末参**和 th31.lua 的 LIST 表第 3 项**一起数，
    ---1..409 已被占满（409 = th31 的「秘術「天文密葬法」」那行）、th33 占 410..416、
    ---th31 占 417..425 ⇒ 这张取 426。
    ---⚠ 只扫 `boss.card.add` 的末参会漏掉 th31 的 LIST（它的 id 写在表里、由变量传进 add），
    ---  照那种扫法挑出来的"空号"一注册就会被 `check_stage.lua --all` 报「card_id 跨组重复」。
    local CARD_ID = 426

    ---逐条生成表：{ 距上一只的帧数, 漂移方向, x, y, itemdrop, 残火是否额外掉道具 }
    ---（x/y 已经换算成我们的坐标；每一条都对过 ECL 时间轴 0 的 spawn_enemy 指令）
    local WAVE = {
{   0, "L",  128,  112, 2, false },
{  10, "L",  112,  128, 0, false },
{  10, "L",   96,  144, 1, false },
{  10, "L",   64,  160, 1, false },   -- t=750
{ 200, "R", -128,  112, 2, false },
{  10, "R", -112,  128, 0, false },
{  10, "R",  -96,  144, 1, false },
{  10, "R",  -64,  160, 1, false },   -- t=980
{ 200, "L",   32,  112, 2, false },
{  10, "R", -128,  112, 2, false },
{  10, "L",   96,  128, 0, false },
{  10, "R",  -64,  128, 0, false },   -- t=1210
{  10, "L",  128,  144, 1, false },
{  10, "R",  -96,  144, 1, false },
{  10, "L",   64,  160, 1, false },
{  10, "R",  -32,  160, 1, false },   -- t=1250
{  60, "L",   32,  112, 1, false },
{  10, "R", -128,  112, 1, false },
{  10, "L",   96,  128, 1, false },
{  10, "R",  -64,  128, 1, false },   -- t=1340
{  10, "L",  128,  144, 1, false },
{  10, "R",  -96,  144, 1, false },
{  10, "L",   64,  160, 2, false },
{  10, "R",  -32,  160, 2, false },   -- t=1380
{  60, "L",   32,  112, 1, false },
{  10, "R", -160,  112, 1, false },
{  10, "L",   96,  128, 1, false },
{  10, "R",  -64,  160, 1, false },   -- t=1470
{  10, "L",  160,  144, 1, false },
{  10, "R", -128,  144, 1, false },
{  10, "L",   64,  160, 2, false },
{  10, "R",  -32,  160, 2, false },   -- t=1510
{  20, "L",   32,  112, 1, true },
{   6, "R", -128,  112, 1, true },
{   6, "L",   96,  128, 1, true },
{   6, "R",  -64,  128, 1, true },   -- t=1548
{   6, "L",  128,  144, 1, true },
{   6, "R",  -96,  144, 1, true },
{   6, "L",   64,  160, 2, true },
{   6, "R",  -32,  160, 2, true },   -- t=1572
{   6, "R", -128,  112, 1, true },
{   6, "L",   96,  128, 1, true },
{   6, "R",  -64,  128, 1, true },
{   6, "L",  128,  144, 1, true },   -- t=1596
{   6, "R",  -96,  144, 1, true },
{   6, "L",   64,  160, 2, true },
{   6, "R",  -32,  160, 2, true },
    }

    ---BGM 用 TH07_1「幽雅に咲かせ、墨染の桜」= 原作第 6 面的主题曲（mod/music.lua:25）；
    ---背景沿用 TH07 的第六面背景。
    boss.Define("1a", BOSS_NAME, "TH07_1", TH07_bg, { 0, 400 }, nil, "img_void", LEVEL)

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        ---耐久卡：不打超时音、关掉本体的判定与血条（照 th31.lua 的 Last Word 写法）
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        ---弹池登记表与音效去重的帧号都是跨局的模块级状态：这卡可以被重打（符卡练习的
        ---重开），开卡时清一次，免得上一局的残留影响第一帧的判定。
        pool = {}
        sound_tick, sound_stamp = 0, -1
        ---WAVE 的 dt 是**相对上一只**的帧间隔，所以用一条协程顺着等下去；
        ---时间轴从卡开始算（原作的 t=720 映射成 0）。
        task.New(self, function()
            for _, w in ipairs(WAVE) do
                task.Wait(w[1])
                New(class["TH34_ghost"], w[3], w[4], (w[2] == "R") and 1 or -1, w[5], w[6])
            end
        end)
    end
    ---音效去重的时钟：一帧推一格（幽灵那边拿它跟自己记住的帧号比）。
    function card:frame()
        sound_tick = sound_tick + 1
    end
    function card:render() end
    ---★ 这里不需要清理：幽灵/残火是**独立对象**（没有 object.Connect 到 boss），而且都会自己退场 ——
    ---幽灵按 auto_delete 飞出回收边界（0.02/帧² 加速下最远的 x=±160 要 196 帧），残火自己
    ---t=120 时 RawDel。最后一只幽灵在卡内 t=894 出生（最晚 t≈1144 出界），就算它临走前被
    ---击破，那团残火也只活到 t≈1264 —— 都在卡长 1440 之内，所以 del 里没事可做。
    ---（也正因为它们不挂 _servants，boss_system:refresh(1) 的 KillServants 不会误杀它们。）
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end
