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
---  小怪血 16（原作 80，但那是原作的伤害口径，见下面 GHOST_HP 的换算）、
---  无体术判定（碰到自机不掉血，原作 HAS_CONTACT_HITBOX 0）。
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
---     ⚠ 拖影贴图**只能是精灵**：smear_render 走 LRresources 的 SetImageState，
---     粒子名（ghost_fire_r）不在 ImageColor 里 ⇒ 统一用 `enemy_aura1`（TRAIL_SPRITE）。
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
--- 16  小怪血量按**本仓库的伤害口径**重新折算成 16（原作 80）—— 原作的 80 是
---     第 5/6 面「非 boss 伤害 ÷2 + 单帧上限 70」口径下的值，本仓库的灵梦输出只有它
---     的约 1/5。推导写在 `GHOST_HP` 那里。
---
---本卡的弹幕、时间轴、掉道具与丢弹规则都照 ECL 原样；同屏对象/弹数由引擎的
---对象池与 1024 弹槽上限自然决定。
---
---关卡号 32（= STAGE_COUNT + 1），2026-09-28 已按 AGENTS.md §8 注册完，一处都别漏：
---  core.lua:54              STAGE_COUNT 31 → 32
---  _editor_output.lua:47   StageID 加 "34"（顺便决定载入顺序：在 "33" 之后）
---  _editor_output.lua:49   不建自己的 BG 目录（和 TH30/31/32/33 一样复用别人的，本关用 TH07_bg）
---  _editor_output.lua:1213 stage_pic 纹理循环 31 → 32
---  UI.lua:77 的 difftext   第 32 项 = "成群亡灵"（下标必须等于 level，AEX 顺延到 33）
---  UI.lua:101 的 sntext    TH34 = "成群亡灵"
---  main_stage.lua           NewStage("TH34", …) + self:Next(167)
---  defachievement.lua      成就 167
---  music                    不新增：BGM 复用 mod/music.lua:25 的 TH07_1
--- 素材 mod/GAME/stage_pic32.png 是**占位图**（用本关 SCBG6 的 th07_5 / th07_6 / th07_0 拼的），
--- 要换成真立绘直接覆盖这个文件就行。
---★ 注意注册的**前提是 STAGE_COUNT 一起改**：th16AEX 占着 `STAGE_COUNT + 1` 这一档、
---  editname 也是 "1a"，且它在 `_editor_output.lua:1228` **最后载入** —— 只把 "34" 塞进
---  StageID 而不动 STAGE_COUNT 的话，`_editor_boss["1a32"]` 会被 AEX 的 `boss.Define`
---  整条盖掉，这张卡就挂到一个没人用的空 boss 类上了。现在 AEX 顺延到 33。
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
---==================== 第 4 面道中（第二张「道中搬运卡」，2026-09-28 增补） ====================
---把原作 `data/ecldata4.ecl` **时间轴 0（偏移 0x1AA1C，420 条指令）** 里 t=200..6622 的
---第一段道中（293 只）复刻成**同一张关卡上的第二张符卡**：挂法、坐标换算、
---「逐帧跑时间轴」的结构、弹池丢弹规则都照抄上面那张第六面道中卡。
---
---数据和读法（同样是逐字节读的字节码，没有用 decl）：
---  · 时间轴 0 只有 op 0/2（普通 spawn，op2 额外置 mirror）——它就是「道中」。
---    t=7122 那一条是道中 BOSS（sub 35，进 sub 后 SET_LIFE 13000），跳过；
---    t=11122 之后是后半段（sub 11 / 24..27 / 29..33），本卡不要。
---  · 指令头 = i16 time / i16 arg0(sub) / i16 opcode / i16 size + 6×4B args；
---    args[0..2] 是 Float3 出生点、args[3]=life、args[4]=itemdrop、args[5]=score。
---    **spawn 是当帧立刻把 sub 跑到第一条 time>0 的指令**，所以 t=0 的指令出生即生效。
---  · 用到的子程序：4=炮台本体（sub 5/6/7/8 各自 SUB_CALL 4）、9=大幽灵、10=大幽灵的散射、
---    12=厚血怪的死亡回调、13/14=厚血怪本体、15=旋环妖精本体（17/19/21 各自 SUB_CALL 15）、
---    16/18/20=三种妖精的死亡弹。（反汇编脚本 /tmp/eclwork/vd.py；语义按同目录
---    EclManager.cpp / BulletManager.cpp 还原。）
---
---这一段道中在干什么（自然语言版）
---  t=200 起，画面**左右两个屏幕边缘外一点**（原作 x=−16 / 400 ⇒ 我们的 ±208）
---  按 4 帧（后面加快到 2 帧）一只的节奏冒出一排「炮台」，一共 72 只。
---  炮台原地不动（原作 MOVE_DIR_TIME 的帧数是 0 ⇒ 空操作），出生后第 50..114 帧
---  慢慢自转，并且**每 20 帧朝自机打一圈 25 发**（首轮延迟 1..20 帧随机）——
---  5 层同心环、每层 5 发，层与层再错开 ±3.75°（第二组 ±5.625°），
---  5 层的速度 4 / 3.4 / 2.8 / 2.2 / 1.6。打到第 114 帧停火，本体 2114 帧后自毁。
---  这一段的弹数**长期顶着原作 1024 的上限**（72 只 × 5~6 轮 × 25 发 ≈ 9000 发），
---  所以「池满整波不生」在这里是看得见的。
---  t=2008 起两批各 5 只**大幽灵**：出生 30 帧无敌，每 10 帧朝自机撒一把 14 发随机散射
---  （半角从 11.25° 线性收到 0°，速度 1.5~3.8），撒满 10 把就只是飘着、自转。
---  t=3088 起左右各 7 只**厚血怪**：60 帧里从上往下滑 180 px（ease-out-quad），
---  到位那一帧把自机角冻结下来，然后打**20 轮 7 路扇**：第 1 轮是直线、之后每轮的
---  两翼张角从 60°（右半边 90°）线性收到 11.25°（右半边 15°）；速度两档 4 / 2。
---  被击破时撒 6 个道具、消掉半径 96 内的弹（弹变成点道具）。
---  t=4348 起是 144 只**旋环妖精**（sub 17/19/21 三色交错），原地自转（三种速度），
---  出生后第 134 帧朝自机打一圈 24 发，然后原地飘着。三种的**死亡弹**各不相同
---  （原作 sub 16/18/20，见下面的 `fairy4_death_a/b/c`）。
---  最后一只在 t=6622 出现，它的那一圈在 t=6756 打完。
---
---与原作的不同（承上面那张卡的编号继续排）
---  17  血量按**这一关的伤害系数**重算：原作第 4 面非 boss 是 ×(1−1/4−1/16) = 0.6875
---      （EnemyManager.cpp:820-845；只有第 5/6 面才是 ÷2），按灵梦 DPS 比
---      （本仓库 106.4 / 原作 744.6）折 life × 0.1429 ⇒ 10→1、100→14、300→43、
---      400→57、500→71（见 `hp4`）。
---  18  不做 rank 缩放：原作 `SET_SHOOT_INTERVAL_RAND` 会按 rank 加减 `shootInterval/5`
---      （Lunatic 的 rank 在 10..32 之间漂，间隔会在 16~24 之间抖），本仓库没有 rank，
---      固定用时间轴里的值 20 帧；count/speed 的 rank 分支本来就被符卡阶段跳过。
---  19  `SET_SHOOT_INTERVAL_RAND` 用协程 + 首轮随机延迟复刻（原作首轮延迟 1..n 帧，
---      之后每 n 帧一发，到 t=114 把间隔置 0 停火）。
---  20  弹的**颜色是代理**：TH07 的 spriteOffset(1..16) 直接是色档、弹型由 sprite 决定，
---      本仓库用 `COLOR.*` 取同号色近似；弹型 PELLET/RICE→`grain_a`、
---      BALL/RING_BALL→`ball_small`、ARROWHEAD→`arrow_small`。
---  21  `INIT_BULLET_CMD` 的两条运动（0x10 每帧往速度上加一个固定向量、0x80 用 60 帧
---      线性减速到 0 再拐向自机）本仓库没有 API，用 `TH34_cmdbullet` 逐帧复刻。
---  22  炮台/妖精的 x=±208 忠实取自原作：原作的屏幕比场地宽，它们是**看得见**的；
---      本仓库的 `SetWorld(288,46,384,448)` 也在场地外侧留了黑边，同样看得见
---      （只有窗口特别窄的极端情况才会被裁掉）。
---  23  道具是近似：原作 itemdrop 0/2 是能量道具、−1 是 1/3 概率掉随机道具；
---      本仓库没有能量类道具 ⇒ 一律折成信仰/点道具。
---  24  `DEATH_ANM 0x300`（那团亡灵特效）没有 1:1 资源，用本类自带的死亡特效代替。
---  25  弹池 `POOL4_SIZE = 1024`，丢弹规则与上一张卡一致。
---  26  原作 sub 5..8 / 17..21 靠**写全局变量再 SUB_CALL** 传参（SUB_CALL 会把
---      `g_GlobalEclVars` 快照进 context 的 globalVars，sub 4/15 再从 $10029/$10033 读），
---      移植版直接按各子程序写死常量，不复刻这层全局泄漏。
---  27  sub 13/14 的扇是 **20 轮**（DEC_JUMP 先减后跳），而且 DEC_JUMP 的落点是
---      **第一条 op65**（不是 t=60 的块首）⇒ INIT_INTERP 只注册一次、张角连着 20 轮
---      单调收窄；第 1 轮 $10005 还没被写过 ⇒ 张角是 0（直线）。这两点都照做了。
---  28  敌人不夹框（原作这段没有 SET_MOVEMENT_BOUNDS）⇒ 厚血怪停在 y=76（画面上方）；
---      出屏也不回收（我们的回收边界 ±224 比屏幕大），各自靠寿命帧自毁。
---  29  sub 9 的半角是**每 10 帧读一次插值**：INIT_INTERP 的 fn 索引是 0
---      ⇒ MathLerp（不是上面那张卡的 Hermite）⇒ 半角 = 11.25° × (1 − min(t,100)/100)。
---  30  sub 16 的 ②③④ 是 Easy/Normal/Hard 行，Lunatic 只跑 ①⑤⑥⑦ 四条
---      ⇒ 死亡弹是 6+10+6+6 = 28 发。
---==================== 第 3 面道中（第三张「道中搬运卡」，2026-09-29 增补） ====================
---把原作 `data/ecldata3.ecl` **时间轴 0** 的 t=450..3023 那一段道中（265 只）
---复刻成同一关上的第三张符卡（id 3402「三道中『青之骚灵』」，130 秒）。
---挂法、坐标换算（我们的 x = th07 的 x − 192、y = 224 − th07 的 y、角度取反）、
---逐帧跑时间轴的骨架、「弹池 1024、池满整波不生」的丢弹规则都照抄上面两张卡。
---
---数据和读法（逐字节读字节码，没有用 decl）：
---  · 时间轴 0 = 265 条普通 spawn（op 0/2）：args[0..2] 出生点、args[3] life、
---    args[4] itemdrop、args[5] score、args[7] 是 op2 才置的 mirror 位。
---  · 子程序：3/4/5/6 = 小妖精（SET_ANM 0/5）、7/8/9/11/12 = 大幽灵（SET_ANM 31）、
---    10 是 sub 9 内部的 SUB_CALL。反汇编脚本 /tmp/eclwork。
---
---这一段道中在干什么（自然语言版）
---  t=450 起，画面上方（我们的 y=240）成对冒出**小妖精**，一只在左、一只在右
---  （mirror 把速度的 x 分量取反），一路往下或斜着飘：
---    · sub 3 垂直下坠（θ=π/2 ⇒ 我们 −90°，匀速 2）；
---    · sub 4/5 斜落，θ 每只随机 ∈ [0.0982, 1.62) 弧度，匀速 1.5；
---    · sub 6 先沿随机 θ 做 60 帧 ease-out-quad 直线冲出 180 px（3 px/帧），
---      t=60 掉头朝正上方（我们 +90°）匀速 2 继续飞。
---  每只小妖精带一个**固定齐射**（4~10 发的 SPREAD/RING/RANDOM，见 W3_VOLLEY），
---  出生当帧就打第一轮；之后按 `SET_SHOOT_INTERVAL_RAND`（sub3=200、sub4=40、
---  sub5=100 帧）**首轮延迟 1..n 帧随机、之后每 n 帧重打同一轮**，到 t=150 停火。
---  sub3/4/5 在 t=2150 自毁、sub6 在 t=2060。小怪成对地来、节奏越来越密，
---  t=2409 起还夹着大幽灵（sub 3/5 的齐射也跟着换行）。
---
---  **大幽灵**（sub 7/8/9/11/12）从左右屏幕外（我们的 x=±208）出生，先用 120 帧
---  Hermite（MathCubicInterp、ease-out-quad）横穿到对侧 x=∓64、同时降到 y=96；
---  t=240（sub 11 是 270）改 POLAR、朝 ±180° 匀速 2 平飞出屏，t=4240
---  （sub 11 是 4270）自毁。t=120 各自打一轮固定弹幕：
---    · sub 7 四连扇（ball_small 5×2 / 4×2 / 2×2，外加 1 发 ball_big）；
---    · sub 8 一圈 24×4 的同心环；
---    · sub 9 → SUB_CALL 10：1×10 的「瞄自机 10 层环」，4 次调用（相隔 20 帧）
---      把 $10004 在 ±π/128 之间来回翻；
---    · sub 11 t=120 一轮无声慢环（0x200）、t=150 一轮 32×2；
---    · sub 12 t=120/180/240 三连 RANDOM（角 = 自机角 + rand(−c,+c)、速 = rand[v2,v1)）。
---
---与原作的不同（接着上面第 4 面卡的编号继续排）
---  31  血量按**这一关的伤害系数**重算。原作非 boss 的伤害折扣只给第 4/5/6 面
---      （EnemyManager.cpp:820-845），第 3 面**没有**减伤 ⇒ 同样 life 的杂鱼要比
---      第 4/5 面多折一半血：life × 0.09825（= hp5 的 0.1965 × 0.5），保底 1 点，
---      见 `hp3`。⇒ 30→3、50→5、80→8、150→15。
---  其余（不做 rank、色档/弹型代理、弹池 1024、道具折叠、贴图代理、不清理）都沿用
---  上面的差异 3/18/19/20/23/25。
---==================== 第 5 面道中（第四张「道中搬运卡」，2026-09-29 增补） ====================
---把原作 `data/ecldata5.ecl` **时间轴 0（偏移 0xAEA8）** 里 t=500..5713 的 94 条
---spawn 复刻成同一关上的第四张符卡（id 3404「五道中『幽明之径』」，120 秒）。
---
---数据和读法（逐字节读字节码，没有用 decl；解释器 /tmp/eclwork）：
---  · 时间轴 0 = 94 条普通 spawn，字段与第 3 面那张卡相同。
---  · 绝大多数 spawn 放出的是**载体**（sub 10/12/14/16/18/20 与 25/27/29/31/33/35）：
---    载体先演 80 帧烟尘（sub 9），第 80 帧在原地 `SPAWN_ENEMY_REL` 生出真正
---    的幽灵（sub 11/13/…/36）后自毁；**本体子程序号 = 载体号 + 1**。
---  · 时间轴另有直接放的 sub 22/23/24（没有载体、也不带烟尘），照做。
---  · **跳过**：t=4820 的 sub 37 与 t=6114 的 sub 47 —— 那是道中 BOSS 占位
---    （SET_BOSS 0、分数 200000、life 1、SET_CAN_BE_DAMAGED 0），不属于道中。
---
---这一段道中在干什么（自然语言版）
---  t=500 起，左右两侧（我们的 x=∓128/∓96/∓64…、y=128..240）不断冒出幽灵。
---  每只登场前先当 **80 帧烟尘**：贴图是黄焰（style 30），从出生点**下方 147 px、
---  偏左 3 px** 沿一条 Hermite 曲线飘到出生点（X 的两条切线各 ±144 随机、Y 的
---  m0=−1、m1=±32），最后 16 帧淡出。第 80 帧原地变成**本体**：换红焰（style 27）、
---  开判定、起各自的无敌计时，然后开始打弹（本体脚本的 t 从这一帧数起）。
---
---  三种本体的行为：
---    · 平移族（sub 11..21）：出生即沿 θ 匀加速（accel 0.02）平移 ——
---      11/15/19 往 +x、13/17/21 往 −x；无敌 11/13=10、15/17=0、19/21=30。
---      发弹：11/13 打「22 轮环，每轮 11 发、每 10 帧把 $10004 转 ∓π/64」；
---      15/17/19/21 打「n 轮 5 发扇（每 4 帧一轮、速度每轮 +dv、首轮 0.8）」——
---      15/17 是 16 轮 dv=0.475、19/21 是 12 轮 dv=0.375。
---    · 俯冲族（时间轴直放的 22/23/24）：前 60 帧 ease-out-quad 俯冲 120 px，
---      t=120 改 POLAR（22 走镜像后的水平方向、23/24 继续下潜）；无敌 22=30、
---      23=40、24=30。t=60 打弹：
---      · 22：三连扇，②③各挂 ±0.25°/帧、60 帧的自旋；
---      · 23/24：六连扇（前三条 spr6/off2 张角 π/8、后三条 spr6/off14 张角 π/4），
---        ②⑤与③⑥各挂反向自旋。
---    · 偏移族（26/28/30/32/34/36）：先打完弹、到 t=4/61/122 才朝正上方（+90°）
---      匀加速飞走；无敌 26/28=20、32/34=4、30/36=10。
---      · 26/28：32 轮、每 4 帧一轮，$10004 从 π/2 起每轮 ∓π/16，偏移半径 32、aimed；
---      · 30：16 轮 × 2 发（t=0 用 $10004 往减、t=2 用 $10009 往加），偏移半径 32；
---      · 32/34：32 轮、每 1 帧一轮，一个方向 4 发（a1 = |$10004|），偏移半径 32；
---      · 36：16 轮 × 2 发（偏移半径 64），两条 a1 都取 $10004。
---  最后一只（载体 35）在 t=5713 出生、本体 t=5793 起用 122 帧飞走。
---
---与原作的不同（接着上面第 3 面卡的编号继续排）
---  32  血量按**这一关的伤害系数**重算。原作第 5/6 面非 boss 的伤害是 ÷2
---      （EnemyManager.cpp:820-845），按灵梦 DPS 比 106.4 / 541.5 折 life × 0.1965，
---      保底 1 点 ⇒ 80→16、110→22、160→31、200→39，见 `hp5`。第 3 面的 hp3、
---      第 4 面的 hp4 都从这同一个 0.1965 再乘各自系数。
---  33  INIT_BULLET_CMD 的**命令门控**。原作 enemy 的 `bulletProps.commands[]` **只在
---      出生时重置一次**（EnemyManager.cpp:401，另一次在 callbacks 前 :1033），所以
---      INIT_BULLET_CMD 写进 commands[0] 的东西会**一直留着**，后续每一轮齐射都带
---      这条命令；而 `RunCommands` 只在 `(moreFlags & cmd->type) == 0` 时跳过它
---      （enemy 每帧的 flags 会被重置，`Bullet::AddCommand` 只改 moreFlags）。
---      ⇒ sub 11/13 的 22 轮、26/28/30 的每一轮**都**带 Burst（flags 0x202/0x203/0x222
---      含 bit 1）；sub 32/34/36 的 flags 是 0x205（**不含** bit 1）⇒ Burst 当场被
---      跳过，所以那一族干脆不挂命令。Burst 本身：前 17 帧速度 = 5 − timer·5/16 +
---      自身速度、沿自身朝向，之后回落到自身速度并清位（BulletManager.cpp:724-741），
---      移植版用 `TH34_cmdbullet` 的 `{ type = 1 }` 复刻。同理 0x20 TargetAngle
---      （每帧 angle += cmd.angle、speed += cmd.speed 再重算 velocity，够 60 帧清位，
---      BulletManager.cpp:759-777）只在 flags 含 bit 5 时生效：sub 22/23/24 里只有带
---      0x222 的齐射挂得上自旋，0x202/0x205 的挂上也白搭 —— 移植版按这条门控逐条
---      决定挂不挂命令。
---  34  载体与小怪**合成一个对象**：原作是两个实体（载体 sub 9 + `SPAWN_ENEMY_REL`），
---      移植版让一个 `TH34_mid5` 前 80 帧只渲染烟尘、第 80 帧换贴图并开判定；
---      烟尘的两条 Hermite（原作直接写 POS_X/POS_Y）也在 frame 里逐帧算。
---      代价是少一次 0x300 死亡特效（同差异 2）。
---  35  `SET_DEATH_TYPE 1`（SCORE_ONLY）**照样掉道具**：原作从 `goto END_BOSS` 落进
---      `ENEMY_DEATH_DROP_ITEMS`（EnemyManager.cpp:948-990），会照着时间轴的 itemdrop
---      调 `SpawnItem`；移植版因此把 itemdrop 折成信仰/点保留（同差异 23：
---      ECL_SPAWN_ITEMS 首颗大能量、其余小能量，SPAWN_POINT_ITEMS 撒点道具，
---      都是 pos + rand[0,128)−64 的散射）。死亡回调 sub 6=无、7=4 信仰+3 点、
---      8=4 信仰+1 点，也照做。
---  36  跳过 midboss 占位：原作时间轴 t=4820 的 sub 37 与 t=6114 的 sub 47 是
---      道中 BOSS（SET_BOSS、SET_CAN_BE_DAMAGED 0），本卡不收。
---  其余（不做 rank、色档/弹型代理、弹池 1024、贴图代理、不清理、SET_VM_AUTO_ROTATE
---  空操作、DEATH_ANM 0x300 无对应资源所以用本类死亡特效、拖影代理）都用上面的
---  差异 1/3/9/18/19/20/24/25。
---==================== 第 1 面道中（第五张「道中搬运卡」，2026-09-29 增补） ====================
---把原作 `data/ecldata1.ecl` 的**两条时间轴**（tl0 偏移 0x8A00、tl1 偏移 0xA98C）合起来
---复刻成同一关上的第五张符卡（id 3400「一道中『初雪之妖精』」，120 秒）。
---原作这两条时间轴**同时跑、各数各的帧**（EnemyManager.cpp:637-645 对每条 timeline 各跑
---一遍 RunEclTimeline，timelineCount = 2）；移植版把两边的 spawn 按 t 归并成一张 WAVE1。
---挂法、坐标换算（我们的 x = th07 的 x − 192、y = 224 − th07 的 y、角度取反）、逐帧跑
---时间轴的骨架、「弹池 1024、池满整波不生」的丢弹规则都照抄上面几张卡。
---
---数据和读法（逐字节读字节码，没有用 decl；解释器 /tmp/eclwork）：
---  · 时间轴指令头是 8 字节（time/arg0/opcode/size，EclManager.hpp:313），op 0/1 = 普通
---    spawn、op 2/3 = 带 mirror、op 4..7 = 坐标 ≤ −990 时当场重掷的版本
---    （EnemyManager.cpp:198-330）；args[0..2] 出生点、args[3] life、args[4] itemdrop、
---    args[5] score。
---  · tl0 = 250 条 spawn，t=600..4558：sub 3（72）、sub 18（38）、sub 19（140）。
---  · tl1 = 43 条 spawn，t=1401..4642：sub 4..17。
---  · **跳过**：tl1 的 t=1 sub 1 是开幕特效（背景着色 + 粒子，CAN_DIE 0、无判定）、
---    t=5042..5047 的 sub 31 是 boss 占位（life 1、itemdrop −2、score 200000）与同一段的
---    op8/9/10/12（对白与 boss 中断）；tl0 里 t=2667 的 sub 20 是道中 boss（SET_BOSS 0、
---    life 10000、score 100000）—— 都不搬（同差异 36）。
---  · 两条时间轴都**没有载体这一层**：直接放本体（没有 SUB_CALL、没有 SPAWN_ENEMY_REL），
---    所以 sub 号就是本体号、也没有烟尘/换装阶段。
---  · mirror 位（op2）成对出现：同一批妖精在 op2 段与 op0 段各来一份，出生点关于 192 对称、
---    速度 x 分量取反 ⇒ 左右镜像入场；移植版折算成 `deg = 180 − deg`（`w1_move`/`w1_dir`）。
---  · sub 4..15 的齐射数/速度不是常量：先 `SET_INT`/`SET_FLOAT` 给底，再按难度位
---    （`skip` 字节：01=Easy、02=Normal、04=Hard、08=Lunatic；`(skip & difficultyMask) == 0`
---    才执行，EclManager.cpp:934）做一串 `ADD`/`SUB`/`ADD_FLOAT`；移植版固定取
---    **Lunatic 那一行**。
---
---这一段道中在干什么（自然语言版）
---  t=600 起，画面上方成对冒出**小妖精**（sub 3）：t=600..1208 里共 48 只（每 8 帧一只、
---  6 只一组；同组稍后由镜像位再放一遍，左右成对）。每只先 60 帧 ease-out-quad 下滑 168 px
---  （`MOVE_DIR_TIME(60, eas 4, π/2, 2.8)`），t=60
---  重掷 θ∈[0.1309, 0.4574)、速度∈[0.8,1.7) 后直线飞走（`MOVE_DIR_TIME(0,0,…)`），同时打
---  一发 2×1 的自机狙扇（SPREAD_AIMED、张角 ±5.625°、速度 2→1）；t=2121..2167 又来一波
---  「每 2 帧一只、共 24 只」的密集版。每只都在自己出生后 2060 帧走 UNIMP 自毁。
---
---  t=1608 起，左右两侧屏幕外（我们的 x=∓224）轮流放出**环妖精**（sub 18，life 10）：
---  出生即朝画面内匀速 4 平移，t=0 打一圈 12 发 RING_ABS，之后每 90 帧重打同一圈
---  （`SET_SHOOT_INTERVAL_RAND 90`，首轮延迟 1..90 帧随机）；t=60..179 本体绕一整圈
---  （`SET_ANGULAR_VEL 0.05236`），出生后 2180 帧走 UNIMP 自毁。
---
---  t=1401..4642（来自 tl1）是**折线妖精**（sub 4..15，life 10/30/100）：一只接一只从
---  画面上方斜插进来，先 60 帧下滑，再按 `MOVE_DIR_TIME(40, eas 4, θ, 0.8)` 折两次
---  （各位移 32 px），最后 `MOVE_DIR_TIME(0,0,θ,2)` 直线飞出；t=60 打一轮 2×n 或 1×1 的
---  自机狙扇（张角 45° 或 5.625°、速度∈[1.2,4.4]）。13/14/15 没有折线，只有 t=110 的收尾。
---  t=4162/4322/4482/4642 的是**大妖精**（sub 16/17，life 300、score 2000）：80 帧下滑
---  200 px，t=90 起朝自机方向打 8 轮旋转扇（每轮 2×5 = 10 发、每 2 帧一轮），t=142 收尾
---  向下；两条 sub 的扇股转法相反（一条 SUB_FLOAT、一条 ADD_FLOAT）。
---
---  t=3167..4558 是**长龙**：sub 19 每 10 帧一只、共 140 只，从上方直落（θ=π/2、速度 3、
---  life 1、score 300），x 从 32 扫到 352 再扫回来 —— 纯过场小怪、不出弹，出生后 2000 帧自毁。
---
---与原作的不同（接着上面第 5 面卡的编号继续排）
---  37  血量按**这一关的伤害系数**重算（同差异 31/32 的口径）。原作第 1..3 面非 boss 没有
---      减伤（EnemyManager.cpp:820-845），按灵梦自机的 DPS 比 106.4 / 744.6 × 0.6875 折
---      `life × 0.09825`、保底 1 点 ⇒ 10→1、30→3、80→8、100→10、300→29，见 `hp1`。
---  38  贴图代理：原作 SET_ANM 0/5 是 stg1enm.anm 的两种妖精、10 是环妖精/长龙；移植版用
---      本仓库的 enemy1（32×32 小妖精）/ enemy5（48×32 妖精）两套 sprite（W1_STYLE_S = 1 /
---      W1_STYLE = 5），弹型统一用 grain_a 加色档代理（col16）。
---  39  道具折算（同差异 23/35）：原作 itemdrop 0 = 小能量、2 = 大能量、7 = 樱点、
---      −1 = 1/3 概率掉随机道具（EnemyManager.cpp:948-990）；本仓库 item.obj 里没有
---      「能量」类 ⇒ 0/2 折成信仰道具、7 折成樱点、−1 折成 1/3 概率的信仰，见 `w1_drop`。
---  40  两条时间轴合并成一张波表、且**不做载体层**：原作 tl0/tl1 同时跑、各放各的；移植版
---      按 t 归并，本体就是时间轴直接放的那只（没有 SUB_CALL / SPAWN_ENEMY_REL / 烟尘
---      阶段），代价是少一次死亡特效（同差异 2）。
---  41  sub 18 的 t=60 `RAND_FLOAT_ADD $10004 …` 是**死代码**：op67 在 t=0 就把 angle1 存成
---      数值快照，`SET_SHOOT_INTERVAL_RAND` 的自动重发读的是那份快照
---      （EclManager.cpp:1276-1289 与 :2095-2105）⇒ 24 圈同一个基准角；移植版照做
---      （`self.ring_base` 只算一次）。
---  42  sub 16/17 的循环是 `DEC_JUMP 90 -200 $0`（$0 = 8）：先减后跳、计数到 0 不跳 ⇒
---      **8 轮、每 2 帧一轮**（EclManager.cpp:945-954），且基准角在 t=90 那帧从
---      ANGLE_TO_PLAYER 冻结、之后只按 ±0.628319 rad（36°）逐轮转，不再重读自机角；移植版照做。
---  其余（不做 rank / SET_SHOOT_INTERVAL_RAND 的 rank 缩放、色档与弹型代理、弹池 1024、
---  SET_VM_AUTO_ROTATE 空操作、DEATH_ANM 0x300 无对应资源）都用上面的差异 3/18/19/25。
---==================== 第 2 面道中（第六张「道中搬运卡」，2026-09-29 增补） ====================
---把原作 `data/ecldata2.ecl` 的**三条时间轴**（tl0 偏移 0xDDA4、tl1 偏移 0xEE70、tl2 偏移
---0x100F4）合起来复刻成同一关上的第六张符卡（id 3401「二道中『雪之回廊』」，170 秒）。
---三条同样**同时跑**（timelineCount = 3），移植版按 t 归并成一张 WAVE2。
---挂法、坐标换算、逐帧跑时间轴、「弹池 1024、池满整波不生」都照抄上面几张卡。
---
---数据和读法（逐字节读字节码，没有用 decl；解释器 /tmp/eclwork）：
---  · tl0 = 128 条 spawn（t=450..7650）：会飘的「种子」sub 4/5/6/11/13/15/17（103 条）
---    与下落的杂鱼 sub 38（24 条）。
---  · tl1 = 147 条 spawn（t=600..7260）：sub 36（38）、37（11）、39（98）。
---  · tl2 = 49 条 spawn（t=600..2620）：sub 36（38）、37（11）—— tl1 的**镜像孪生**。
---  · **跳过**：tl0 的 t=1 sub 1 是开幕特效（同第 1 面）、t=2826 的 sub 40 是道中 boss
---    （SET_BOSS 0、life 17000、score 60000）、t=7647 的 sub 48 是 boss 占位（life 1、
---    itemdrop −2、score 200000）与 t=7646..7651 的 op8/9/10/12（对白/boss 中断）；tl0 里
---    坐标写成 ≤ −990 的 op4..7 随机位本文件没用到。
---  · 时间轴放的是**载体**（种子，不可打）：`INIT_INTERP` 两条分别在 180 帧里把 POS_X/POS_Y
---    从出生点拉到随机目标（目标变量就是 $10018/$10019 = ECL_VAR_POS_X/POS_Y，
---    EclManager.hpp:32-33），两端切线各 ±144；t=180 在自己**当时**的位置
---    `SPAWN_ENEMY_REL` 生出会打弹的子体（offsets 全 0、life 80、score 1500），t=210 走
---    UNIMP（原作是 EclManager 返回 ZUN_ERROR ⇒ Despawn）⇒ 移植版用 `object.RawDel`。
---  · `SET_DESPAWN_ON_OOB 1`（sub 4..17）⇒ 不出屏销毁；本卡载体一直在场内，无影响。
---  · 6 条打弹子体（sub 18..23）的弹幕按难度行分支（`skip`：01/02/04/08），移植版取
---    **Lunatic 那一行**：18 = 6×7 张角 2.8125°、19 = 24 发整圆随机 + t=30 的 48 发、
---    20 = 4×5 张角 120°、21 = 9×1 张角 4.5°、22 = 32×3 反向扇 + 1×5 连发、
---    23 = 13×2 张角 5.625°。
---
---这一段道中在干什么（自然语言版）
---  t=450 起，画面里开始出现**会飘的种子**（sub 4..17）：出生位置大多当场重掷（时间轴把
---  life 写成 9999 当信号），贴图是会飘的 SET_ANM 13；本体**打不到、碰到也不掉血**
---  （SET_IS_HITTABLE 0 + SET_HAS_CONTACT_HITBOX 0 + SET_PRIORITY 2）。两条 Hermite 在
---  180 帧里把它从出生点拉到随机终点，横向还会左右摆（两端切线各 ±144 随机）；180 帧一到，
---  它在自己**当时**的位置生出 1~3 只**小子体**（sub 18..23），再 30 帧后自毁。子体出生即
---  按各自脚本打一轮弹（18/20/21 是自机狙扇、19 是整圆随机 + t=30 再来一轮、22/23 是反向
---  扇 + 连发），然后 t=80/110/130 转头朝自机、速度用 90 帧 ease-out-quad 从 0 加到 2.5
---  直线扑向自机，2080..2130 帧后自毁。种子表还能**级联**：sub 10..17 生出的子体又是
---  sub 4..17（种子本身），最多再叠一层 —— 所以同屏对象数会到几百。
---
---  t=1380..1426 是一批**下落的杂鱼**（sub 38，life 10）：每 2 帧一只、左右成对，先 80 帧
---  ease-out-quad 下落 160 px，再朝随机 θ∈[0.19635, 0.589049)、速度∈[1.7,2.2) 飘走，
---  不出弹，2080 帧后自毁。
---
---  t=600..7260（tl1/tl2）是**左右对飞的两族妖精**：36/37 从画面左右两侧的 x=±208 进场
---  （原作屏幕比场地宽 ⇒ 看得见，同差异 22），沿 θ=0 直线横穿（tl2 那一半带镜像位 ⇒
---  反向）；39 从画面上方沿 θ=π/2 直落。三条都是 t=0 打一发固定扇，之后靠
---  `SET_SHOOT_INTERVAL_RAND`（36/37 = 100、39 = 120 帧）重打同一发；t=60..179 挂着
---  ±0.05236 的本体角速度画弧，到 t=180 停（37/39 同帧把间隔置 0 停火），2180 帧后自毁。
---
---与原作的不同（接着上面第 1 面卡的编号继续排）
---  43  血量同第 1 面口径（差异 37 的 0.09825），见 `hp2` —— 第 2 面原作也没有非 boss 减伤。
---      种子的 life 一律 1（不可打，血量无意义）；打弹子体的 life 80 ⇒ 8 点血。
---  44  贴图代理：原作 SET_ANM 13 = 会飘的种子、10 = 妖精、0/5 = 更小的杂鱼；移植版用本仓库
---      的 enemy_orb1（23，带光环的光球）/ enemy5（5，48×32 妖精）/ enemy1（1，32×32）当代理。
---  45  时间轴的 life 位是**随机位置的信号**：`JUMP_IF_EQ $10027(=LIFE), 9999` 命中时跳过
---      `SET_FLOAT $10004, $10018`（EclManager.hpp:41）⇒ p0 不再是 POS_X、而是随机的
---      `rand(0,256)+64` / `rand(0,160)+32`。表里 life = 9999 那批行的 x/y 只是**占位**
---      （被父载体 SPAWN_ENEMY_REL 生出来时 life = 80 ⇒ 用父机当时的位置）。
---  46  载体级联：载体 sub 4..17 不可打（IS_HITTABLE 0 + HAS_CONTACT_HITBOX 0 + PRIORITY 2）、
---      t=180 生子体、t=210 走 UNIMP；原作 UNIMP = EclManager 返回 ZUN_ERROR ⇒ EnemyManager
---      把该敌机 `Despawn()`（**不掉道具**）⇒ 移植版对应 `object.RawDel`。
---  47  sub 36/37/39 的 `SET_ANGULAR_VEL ±0.05236` 是**本体画弧**（POLAR 分支里
---      `angle += angleVel`，EclManager.cpp:2018-2023），不是自转贴图 —— 这三条都没有
---      `SET_VM_AUTO_ROTATE`；移植版在 frame 里转 `self.dir` 再 `object.SetV`。
---  其余（不做 rank / SET_SHOOT_INTERVAL_RAND 的 rank 缩放、色档/弹型代理、弹池 1024、
---  SET_BULLET_SOUND / DEATH_ANM 0x300 无对应资源、不清理）都用上面的差异 3/18/19/25。
---==================== 第 7 面（EX）/ 第 8 面（PH）道中（第七/八张「道中搬运卡」，2026-09-29 增补） ====================
---把原作 `data/ecldata7.ecl`（tl0 偏移 0xDE18，284 条 spawn）与 `data/ecldata8.ecl`
---（tl0 偏移 0x11234，374 条 spawn）各复刻成一张符卡（id 3406「EX 道中『妖妖梦・Extra』」、
---id 3407「PH 道中『妖妖梦・Phantasm』」，各 185 秒）。
---★ 这两个面没有「3 条时间轴」的结构：tl0 就是整段道中，tl1 只是开局的一个特效敌人（跳过）；
---  tl0 里除 spawn 外只有 boss 对白/中断（op 8/9/10/12），一律跳过；末尾各有一条**道中 boss
---  占位**要剔掉（EX 的 t=8799 sub 67、PH 的 t=9259 sub 69）⇒ 取 EX 282 条、PH 372 条。
---代码在文件末尾的 `TH34_add_stage78()` 里（两个面共用同一批类，差异由 `mk78(ph)` 给）；
---逐条差异 60..66 写在那个函数开头的注释里。
---=====================================================================================
---======================================================================================
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
    ---★ 原作 RAND_SIGN / RAND_SIGN_FLOAT 是 `(g_Rng.GetRandomU16() & 1) ? +1 : -1`
    ---（EclManager.cpp:984-991）——**只抽 1 个 u16**。原来写成 `ran:Int(0,1)`
    ---（= _u32()%2，抽 2 个 u16），每个符号就多抽 1 个 u16，整条随机流从这里错位。
    return ran:Sign()
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
---★ 原作时间轴的 life 是 80（`EnemyManager.cpp:885` 里 life 就是血），但**不能直接搬**：
---原作对第 5/6 面的**非 boss** 敌人伤害要 ÷2（`EnemyManager.cpp:822-828`），
---且单帧伤害上限 70（`:836-839`）。按这个口径，原作满 P 的灵梦打这段杂鱼只有
---420（灵梦A）~714（灵梦B）DPS（TH07 `data/ply00*.sht` 的 128 档），而本仓库的灵梦
---是 96~117 DPS（`reimu.lua:43-62`，2 / 0.3 / 0.65）。等比折算
---80 × 106.4 / 541.5 ≈ 15.7 ⇒ 取 16，击杀耗时与原作一致（约 9 帧 / 0.15 秒）。
---不改的话是 50 帧（0.83 秒）才打死一只，手感上就是「打不死」。
local GHOST_HP = 16
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
---拖影用的贴图**必须是精灵**。`smear_render`（LObjectEvents.lua:242）走的是
---LRresources 的 `SetImageState`/`Render`，而它只认 `LoadImage` 登记过的名字
---（`ImageColor`，Lresources.lua:81）；而本卡所有对象的 `self.img` 都是**粒子**
---`ghost_fire_r`（style 27/31，WalkImageSystem.lua:367）—— 直接沿用就是
---`ImageColor[img]` 为 nil，真机第一帧崩 `attempt to index local 'i'`（Lresources.lua:112）。
---原作这条 SET_TRAIL 画的是对象自己的运动残像，移植版统一借 aura 光环当代理
---（style 31 本来就会画这一张，同一套色系、也确实跟着对象飘）。
local TRAIL_SPRITE = "enemy_aura1"

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

---★ 「还在场」的判据必须是**原作 TH07 的回收线**，不是 LuaSTG 的。
---   原作 `GameManager::IsInBounds(x,y,w,h)`（GameManager.cpp:40）判的是**384x448 的
---   场地**再各让出半个贴图：x ∈ [-192-w/2, 192+w/2]、y ∈ [-224-h/2, 224+h/2]
---   （TH07 左上原点 0..384/0..448 换到我们坐标就是 ±192/±224，见文件头）。
---   LuaSTG 自己的 `bound*` 是 **±224/±256**（`THlib/lib/Lscreen.lua:90`）——
---   比原作的回收线各宽 32 px，用它当判据会让弹在「原作早就回收了」的地方
---   还占着槽位，池子提前灌满、无谓地丢后面的波。
---   （贴图半宽无从逐颗取得，这里取场地本身；比原作只紧不松，而在会顶到上限的
---    那几张卡上实测两种口径都远未回到 1024，故对发弹条数无影响。）
local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.l and unit.x <= lstg.world.r
            and unit.y >= lstg.world.b and unit.y <= lstg.world.t
end

---还占着槽位的弹有几颗。原作每帧边扫边数（`BulletManager.cpp:942` 那段），
---这里只在出弹帧数一次 —— 出弹帧之外池子不会变。
local function pool_used()
    for i = #pool, 1, -1 do
        ---★ 本帧刚生出来（timer == 0）的弹还没被引擎积分 —— 出生点在界外就等于还没出界，
        ---   收掉槽位会让这一帧后面的几波把「其实还在场的弹」当成已消失（见 pool4_used）。
        local u = pool[i]
        if not IsValid(u) then
            ---同上：死引用先移出池，避免读 u.timer 抛 'invalid lstg object'。
            table.remove(pool, i)
        elseif u.timer > 0 and not in_bound(u) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---加一条拖影。★ 别直接调 `object.smear_add`：它抓的是 `self.img`（见 TRAIL_SPRITE 的说明），
---这里在 add 前后把 `self.img` 换成精灵 —— 不换就是上面那个 `ImageColor` 空索引，真机必崩。
local function smear_add(self, alpha)
    ---先换成精灵再 add：`smear_add` 是**当场**把 `self.img` 抄进那条拖影里的，
    ---add 完再改这张表也行，但那样一来「抄进去的到底是什么」就散在两处了。
    local keep = self.img
    self.img = TRAIL_SPRITE
    object.smear_add(self, alpha)
    self.img = keep
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
        smear_add(self, 120)                -- 原作 SET_TRAIL 0x19,48,16,1 的代理（差异 1）
        ---★ 生命周期写在单个协程里：前 80 帧什么都不做（烟尘由 frame 里的插值驱动），
        ---第 80 帧（= task.Wait(80) 醒来的那一帧）换装开火。
        task.New(self, function()
            task.Wait(PUFF_FRAMES)
            self._wisys:SetImage(GHOST_STYLE)
            self.smear = nil                -- 换了贴图，别把烟尘的残影拖到幽灵身上
            self.colli = true
            ---原作幽灵是 `SET_HITBOX_SIZE 24,24`（sub 10/12/14/16），烟尘才是 `8,8`（sub 8）。
            ---不写这两行的话，a/b 会一直是粒子贴图 `ghost_fire_r` 自带的半宽 8
            ---（GameObject.cpp:264 换 img 时按资源半宽覆盖 a/b）—— 幽灵只有 16×16 的判定箱，
            ---真机上子弹擦着身体过都不算命中，看起来就像「打不死」。
            self.A, self.B = 24, 24
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
        smear_add(self, 130)
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
    ---关卡号 32 = `core.lua` 的 STAGE_COUNT(32) + 1（已注册），th16AEX 顺延到 33。
    ---th16AEX 的 editname 也是 "1a" 且最后载入，所以 STAGE_COUNT 必须跟着改，
    ---否则 `_editor_boss["1a32"]` 会被它盖掉。见文件头的注册清单。
    local LEVEL = 32
    ---符卡历史槽位（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
    ---实测：把全项目 `boss.card.add` 的末参**和 th31.lua 的 LIST 表第 3 项**一起数，
    ---th31 用到 452（409 是「秘術「天文密葬法」」、417..425 是 6A 那批）、th33 占
    ---410..416 与 453..460 ⇒ 463 之前没有空号（原来插空的 426 夹在 th31 的 417..452
    ---中间，2026-09-29 已挪走）。本关（th34）改用自己**独立的一段 3400..3407**，
    ---按面序排：一道中 3400、二道中 3401、三道中 3402、四面 3403、五面 3404、六面 3405、
    ---EX 道中 3406、PH 道中 3407。这张是第六面 ⇒ 3405。
    ---⚠ 只扫 `boss.card.add` 的末参会漏掉 th31 的 LIST（它的 id 写在表里、由变量传进 add），
    ---  照那种扫法挑出来的"空号"一注册就会被 `check_stage.lua --all` 报「card_id 跨组重复」。
    local CARD_ID = 3405

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

---==================== 第 4 面道中：代码 ====================
---自然语言说明与逐条差异都在文件头的「第 4 面道中」单元里。
local ball_small, grain_a = ball_small, grain_a
local bullet = bullet
local Angle, Dist = Angle, Dist
---★ 不用全局的 `PI`/`atan2`：自检桩件（tools/check_stage.lua）只导出 `abs/sqrt/int/Angle/Dist`，
---没有这两个全局（引擎里倒是有，见 THlib/lib/Lmath.lua:8 与 Lapi.lua:72）——
---本文件其它地方也是 `math.atan2`/字面量 PI 的写法（th31.lua:368）。
local atan2 = math.atan2
local PI = math.pi

---TH07 的角度是弧度、y 轴朝下；我们的 sin/cos 是角度制、y 轴朝上。
---整段只用「弧度 → 角度」这一个换算；方向（取反）按角度**集合**处理（见文件头差异 20）。
local RAD2DEG = 180 / PI

---第 4 面非 boss 的血量折算（文件头差异 17）：life × 0.1429，保底 1 点。
local function hp4(life)
    return max(1, int(life * 0.1429 + 0.5))
end

---原作同屏弹幕上限 1024（TH07 `BulletManager.hpp` 的 MAX_BULLETS）。
---丢弹规则与上一张卡一致：池满 ⇒ 整波不生；生到一半见底 ⇒ 丢剩下的；两条路径都响音效。
local POOL4_SIZE = 1024
local pool4 = {}
local sound_tick4, sound_stamp4 = 0, -1

local function pool4_used()
    for i = #pool4, 1, -1 do
        ---★ 本帧刚生出来的弹（timer == 0）还**没被引擎积分、也没判过界**：它的出生点
        ---   可能在界外（悬在屏幕外的小怪开火），但下一帧就飞回界内并活下来。
        ---   若此刻按出生点收槽位，这一帧后面的几波就会把「其实还在场的弹」误判成
        ---   已消失 ⇒ 多生，同屏弹数会冲过 1024（原作 `BulletManager.cpp:994-1022`
        ---   是**先 `pos += velocity`、后 `IsInBounds`**）。
        local u = pool4[i]
        if not IsValid(u) then
            ---已被引擎回收 / 被 RawDel 杀掉的对象留在池里会拿到死引用，
            ---再读 u.timer 就会抛 'invalid lstg object' —— 先清掉。
            table.remove(pool4, i)
        elseif u.timer > 0 and not in_bound(u) then
            table.remove(pool4, i)
        end
    end
    return #pool4
end

---同一帧里同一种音效只响一声（原作 SoundPlayer 的队列按 idx 去重）。
local function sound4(self)
    if sound_stamp4 ~= sound_tick4 then
        sound_stamp4 = sound_tick4
        PlaySound("tan00", 0.08, self.x / 256)
    end
end

---一次「波」：gen(i) 依次给出发射参数。
local function volley4(self, total, gen)
    local room = POOL4_SIZE - pool4_used()
    local i = 1
    while i <= total and room > 0 do
        local style, col, v, a = gen(i)
        pool4[#pool4 + 1] = NewSimpleBullet(style, col, self.x, self.y, v, a, false, 0, false)
        room, i = room - 1, i + 1
    end
    sound4(self)
end

---同上，但由 gen 自己 New（给带 INIT_BULLET_CMD 的 TH34_cmdbullet 用）。
local function volley4_raw(self, total, gen)
    local room = POOL4_SIZE - pool4_used()
    local i = 1
    while i <= total and room > 0 do
        pool4[#pool4 + 1] = gen(i)
        room, i = room - 1, i + 1
    end
    sound4(self)
end

---op65 SPREAD 的展开（TH07 `BulletManager.cpp:180-202`）：count1 决定偏移、x 奇数取负。
---返回的是每发的**相对角**（度）；这一族两翼对称，所以取反与否是同一个集合。
local function spread_offsets(count1, a2)
    local out = {}
    for x = 0, count1 - 1 do
        local a
        if count1 % 2 == 1 then
            a = a2 * int((x + 1) / 2)
        else
            a = int(x / 2) * a2 + a2 * 0.5
        end
        if x % 2 == 1 then
            a = -a
        end
        out[x + 1] = a
    end
    return out
end

---sub 12 的 REMOVE_BULLETS_RADIUS：半径内的弹变成点道具（`BulletManager.cpp:602-627`）。
---只扫本卡自己的弹池（这张卡的所有弹都登记在 pool4 里，见文件头差异 25）。
local function clear4_radius(x, y, r)
    local r2 = r * r
    for i = #pool4, 1, -1 do
        local b = pool4[i]
        if IsValid(b) and (b.x - x) * (b.x - x) + (b.y - y) * (b.y - y) <= r2 then
            table.remove(pool4, i)
            New(item.obj.point, b.x, b.y)
            object.RawDel(b)
        end
    end
end

---INIT_BULLET_CMD 的运动（TH07 `BulletManager.cpp:410-421 / 721-775 / 845-875`）：
---  0x10 TargetVelocity：出生时把（朝向, 速度）冻结成一个向量，之后每帧 velocity += 该向量，
---       并把朝向重新对齐到速度方向（速度过零后会自己反过来）。
---  0x20 TargetAngle：每帧把朝向转过 cmd.angle、速度加 cmd.speed，够 dur 帧清位
---       （第 5 面 sub 22/23/24 的两翼扇就靠它反向自旋）。
---  1    Burst：出生后 17 帧内速度 = 5 − timer*5/16 + 自身速度（沿自身朝向），之后清位
---       （第 5 面 sub 11/13/26/28/30/32/34/36 的「一出生冲出去再收住」）。
---  0x80 DirChangeAim：用 dur 帧沿当前朝向把速度线性减到 0，dur 帧后
---       朝向 = 自机方向 + cmd.angle、速度 = cmd.speed，重复 loopCount 次
---       （跟 0x40 同一套字段；原作的「ZUN 交换」只发生在指令字段
---        cmd.speed→commandStates[3].angle 那一层，见帧循环里 0x40 的注释）。
---本仓库没有对应 API，所以逐帧自己算（差异 21）。bound 留默认 true ⇒ 出屏照常回收。
---（★ 角度/角速度都按「我们」的口径传进来：TH07 的弧度已经转成度、并且取过反，
---  见第 3 面/第 5 面那两段代码里的 `rad2our`。）
---一发弹可以挂**一串**指令：`cmd.stages = { 段1, 段2, ... }` 会按顺序逐段跑
---（原作 RunCommands 沿 curCmdIdx 依次激活；EX 的 sub107/108 就是
---「刹车 120 帧 → 原地自旋 180 帧并加速 → 沿冻结方向再加速 120 帧」三段）。
---进入一段指令：角度/速度都按**弹此刻的状态**起算
---（原作 RunCommands 取 this->angle / this->speed 当各段的初值）。
---★ 必须写成模块级 local function：引擎的 Class 只把 init/frame/render/del 这些
---  回调挂到实例上，类表里的普通方法实例读不到（`self:_cmd_enter` 会 nil）。
local function cmdbullet_enter(self, c)
    self.c_type, self.c_dur, self.c_loop = c.type, c.dur, c.loop
    self.c_timer, self.c_done = 0, 0
    self.c_angle = c.angle
    self.c_ang = self.rot
    self.c_spd = sqrt(self.vx * self.vx + self.vy * self.vy)
    ---0x40/0x80/0x100 的「恢复速度」在 ECL 里是 `cmd.angle > -999 ? cmd.angle : this->speed`
    ---（`BulletManager.cpp:414`）；cmd.angle 传 -999 时用**弹自己此刻的速率**。
    ---`resume_own` 即这一支（原作 sub34 的 `INIT_BULLET_CMD 0 64 0 60 1 3.14159 -999`）。
    self.c_speed = c.resume_own and self.c_spd or c.speed
    if c.vec_x or c.vec_y then
        self.c_vx, self.c_vy = c.vec_x or 0, c.vec_y or 0
    elseif c.accel then
        self.c_vx, self.c_vy = c.accel * cos(self.rot), c.accel * sin(self.rot)
    else
        self.c_vx, self.c_vy = 0, 0
    end
end

---一段跑完：有下一段就换过去（返回 true ⇒ 本帧剩下的动作不再做）；没有就清掉指令位。
local function cmdbullet_next(self)
    local st = self.c_stages
    if st and self.c_idx < #st then
        self.c_idx = self.c_idx + 1
        cmdbullet_enter(self, st[self.c_idx])
        return true
    end
    self.c_type = 0
    return false
end

---★ 并发指令：原作一发弹可以同时挂多段命令 —— `RunCommands` 每帧最多再激活一段
---（激活顺序 = commands[] 的顺序，`cmd->flag == 0` 的段只有「还没有别的段激活」时才跑），
---`Bullet::Update` 再按 1→0x10→0x20→0x40→0x100→0x80 的固定顺序把已激活的每段各跑一遍。
---`cmds4(flags, 段1, 段2, ...)` 就是这一支：`flags` 是 ECL 里这条波写的 flags，
---用来决定哪几段的 type 位会被激活（`moreFlags & cmd->type`）。
local CMD_RANK = { [1] = 0, [0x10] = 1, [0x20] = 2, [0x40] = 3, [0x100] = 4, [0x80] = 5 }

---f 里是否含 2 的幂 t（Lua 5.1 没有位运算，t 一律是 1/0x10/0x20/0x40/0x80/0x100）。
local function cmdbullet_hasbit(f, t)
    return math.floor(f / t) % 2 == 1
end

---`cmds4(flags, 段1, 段2, ...)` 只把段表和这条波写的 flags 打包装起来；
---**激活时刻由弹自己逐帧跑原作 `Bullet::RunCommands` 决定**（见 class 的 frame），
---所以「type1 爆速段跑完清掉 exFlags 位 → 后面 `flag == 0` 的段才轮到」这种写法
---也能原样复现（原作里很多卡就靠它做「先弹出、再接管」）。
local function cmds4(flags, ...)
    return { list = { ... }, flags = flags }
end

local cmdsub_new   --- 前置声明：cmdbullet_runcommands 会用到（Lua 局部量按声明点生效）

---原作 `Bullet::RunCommands`：从 curCmdIdx 往下找，**最多激活一段**；type 位不在
---moreFlags 里的段直接跳过（同一帧可以连跳好几条），`flag == 0` 的段只在 exFlags
---还是 0（没有任何段激活）时才轮到；type 0x2000 只记 spawnDelay 并继续往下。
local function cmdbullet_runcommands(self)
    local list = self.c_list
    if not list then return end
    while true do
        local c = list[self.c_cur]
        if not c or c.type == 0 then break end
        if (c.flag or 0) == 0 and self.c_exf ~= 0 then break end
        if not cmdbullet_hasbit(self.c_flags, c.type) then
            self.c_cur = self.c_cur + 1
        elseif c.type == 0x2000 then
            ---原作 `RunCommands` case 0x2000（`BulletManager.cpp:437`）：记下
            ---spawnDelay（只影响「出屏回收」的延迟，本仓无此原语 —— 差异 67）、
            ---**不设 exFlags**、curCmdIdx++ 后同帧继续往下判定。
            self.c_spawn_delay = c.dur
            self.c_cur = self.c_cur + 1
        else
            self.cs[self.c_cur] = cmdsub_new(self, c)
            if not cmdbullet_hasbit(self.c_exf, c.type) then
                self.c_exf = self.c_exf + c.type
            end
            self.c_cur = self.c_cur + 1
            break
        end
    end
end

---一段并发指令的运行时状态（原作 Bullet::commandStates[i]）。
cmdsub_new = function(self, c)
    local s = { type = c.type, dur = c.dur or 0, loop = c.loop or -1,
                angle = c.angle or 0, speed = c.speed or 0, timer = 0, done = 0 }
    if c.type == 0x40 or c.type == 0x80 or c.type == 0x100 then
        ---原作的交换：commandStates.angle 取 ECL 的 cmd->speed、.speed 取 cmd->angle；
        ---cmd->angle > -999 才覆盖速率，否则用弹**此刻**的速率（`resume_own`）。
        s.speed = c.resume_own and self.spd or (c.speed or 0)
    elseif c.type == 0x10 then
        ---vec3 在激活那一刻按（朝向, cmd.speed）冻住（`Bullet::RunCommands` case 0x10）。
        local a0 = c.accel_angle or self.rot
        local mag = c.speed or 0
        s.ax, s.ay = mag * cos(a0), mag * sin(a0)
    end
    return s
end

local function cmdsub_run(self, s)
    local t = s.type
    if t == 1 then
        if s.timer <= 16 then
            local spd = 5 - s.timer * 5 / 16 + self.spd
            self.vx, self.vy = spd * cos(self.rot), spd * sin(self.rot)
        else
            s.finished = 1
        end
        s.timer = s.timer + 1
    elseif t == 0x10 then
        if s.timer >= s.dur then
            s.finished = 1
        else
            self.vx, self.vy = self.vx + s.ax, self.vy + s.ay
            if abs(self.vx) > 0.0001 or abs(self.vy) > 0.0001 then
                self.rot = math.deg(atan2(self.vy, self.vx))
            end
        end
        s.timer = s.timer + 1
    elseif t == 0x20 then
        if s.timer < s.dur then
            self.rot = self.rot + s.angle
            self.spd = self.spd + s.speed
            self.vx, self.vy = self.spd * cos(self.rot), self.spd * sin(self.rot)
        else
            s.finished = 1
        end
        s.timer = s.timer + 1
    elseif t == 0x40 or t == 0x80 or t == 0x100 then
        local spd
        if s.timer >= s.dur then
            s.done = s.done + 1
            if t == 0x100 then
                self.rot = s.angle
            elseif t == 0x80 then
                self.rot = Angle(self, player) + s.angle
            else
                self.rot = self.rot + s.angle
            end
            self.spd = s.speed
            spd = self.spd
            s.timer = 0
            if s.done >= s.loop then s.finished = 1 end
        else
            spd = self.spd - s.timer * self.spd / s.dur
        end
        self.vx, self.vy = spd * cos(self.rot), spd * sin(self.rot)
        s.timer = s.timer + 1
    end
end

class["TH34_cmdbullet"] = Class(bullet, {
    ---@param cmd table { type, dur, loop, angle(度), speed, vec_x, vec_y, accel,
    ---                    stages = { 同上单段, ... } }
    ---带 `stages` 时按顺序逐段执行（原作 RunCommands 靠 curCmdIdx 依次往下走），
    ---否则只跑 cmd 本身那一段。`accel` 供 0x10 段用：进入该段时按弹**此刻**的朝向
    ---冻结一个加速度向量（原作 `FromAngleMagnitude(this->angle, cmd.speed)`）。
    init = function(self, style, col, x, y, v, a, cmd)
        bullet.init(self, style, col, false, true)
        self.x, self.y = x, y
        self.rot = a
        self.vx, self.vy = v * cos(a), v * sin(a)
        self.c_stages, self.c_idx = cmd.stages, 1
        self.c_type, self.c_dur, self.c_loop = 0, 0, 0
        self.c_timer, self.c_done = 0, 0
        self.c_angle, self.c_speed, self.c_ang, self.c_spd = 0, 0, 0, 0
        self.c_vx, self.c_vy = 0, 0
        ---★ 并发指令（原作一发弹可以同时挂多段命令）：`cmd.list` 由 `cmds4` 生成，
        ---激活完全照抄 `Bullet::RunCommands` 的状态机（见 frame 的第一段）。
        self.spd = v
        self.cs = nil
        self.c_exf, self.c_cur = 0, 1
        self.c_flags, self.c_list = 0, nil
        if cmd.list then
            self.cs = {}                 -- 每段激活后的运行时状态（未激活为 nil）
            self.c_exf = 0               -- 原作 Bullet::exFlags（运行期命令位）
            self.c_cur = 1               -- 原作 Bullet::curCmdIdx（下一条待判定命令）
            self.c_flags = cmd.flags     -- 原作 Bullet::moreFlags
            self.c_list = cmd.list
            self.c_type = 0
            ---★ 原作 `SpawnSingleBullet` 在 memcpy 之后**立刻调一次 RunCommands**
            ---（BulletManager.cpp:327-330）⇒ 第一条可激活的段在**出生当帧**就被激活。
            ---少了这一下，本仓会把「出生帧该激活的下一段」推迟一帧，
            ---凡「type1 爆速段 + 同帧接管的 0x20」这类组合都会差一帧的速度。
            cmdbullet_runcommands(self)
            return
        end
        cmdbullet_enter(self, self.c_stages and self.c_stages[1] or cmd)
    end,
    frame = function(self)
        if self.cs then
            ---原作 `Bullet::RunCommands`：每帧最多再激活一段（出生帧那次见 init）。
            local list = self.c_list
            cmdbullet_runcommands(self)
            ---再按原作 Update 的固定顺序（1→0x10→0x20→0x40→0x100→0x80）各跑一遍；
            ---跑完（原作清掉 exFlags 位）的段要真的把位清掉，后面的段才可能接管。
            for rank = 0, 5 do
                for i = 1, #list do
                    local st = self.cs[i]
                    if st and not st.finished and CMD_RANK[st.type] == rank then
                        cmdsub_run(self, st)
                        if st.finished and cmdbullet_hasbit(self.c_exf, st.type) then
                            self.c_exf = self.c_exf - st.type
                        end
                    end
                end
            end
            bullet.frame(self)
            return
        end
        if self.c_type == 0x10 then
            if self.c_timer < self.c_dur then
                self.vx, self.vy = self.vx + self.c_vx, self.vy + self.c_vy
                if abs(self.vx) > 0.0001 or abs(self.vy) > 0.0001 then
                    ---TH07 的 this->angle 是弧度，而我们的 `rot` 是角度（LuaSTG 的 Render 吃角度）
                    self.rot = math.deg(atan2(self.vy, self.vx))
                end
            elseif cmdbullet_next(self) then
                bullet.frame(self); return
            end
            self.c_timer = self.c_timer + 1
        elseif self.c_type == 0x20 then
            ---TH07 `UpdateBulletTargetAngle`：每帧 angle += cmd.angle、speed += cmd.speed，
            ---速度重新按（朝向, 速度）算，够 dur 帧就把命令位清掉。
            if self.c_timer < self.c_dur then
                self.c_ang = self.c_ang + self.c_angle
                self.c_spd = self.c_spd + self.c_speed
                self.rot = self.c_ang
                self.vx, self.vy = self.c_spd * cos(self.c_ang), self.c_spd * sin(self.c_ang)
            elseif cmdbullet_next(self) then
                bullet.frame(self); return
            end
            self.c_timer = self.c_timer + 1
        elseif self.c_type == 1 then
            ---TH07 `UpdateBulletBurstSpeed`：前 17 帧速度 = 5 − timer*5/16 + 自身速度，
            ---沿**自己的**朝向（不是 cmd.angle）；第 17 帧之后把命令位清掉。
            if self.c_timer <= 16 then
                local spd = 5 - self.c_timer * 5 / 16 + self.c_spd
                self.vx, self.vy = spd * cos(self.rot), spd * sin(self.rot)
            elseif cmdbullet_next(self) then
                bullet.frame(self); return
            end
            self.c_timer = self.c_timer + 1
        elseif self.c_type == 0x40 then
            ---TH07 `UpdateBulletDirChangeAndResume`（BulletManager.cpp:779）：先沿当前朝向
            ---用 dur 帧把速度线性刹到 0，然后角度 += cmd.angle、速度 = cmd.speed 再来一轮，
            ---共 loop 轮。原作 ph sub101 就是靠它做「直线→停→拐弯再飞」的曲线弹。
            local spd
            if self.c_timer >= self.c_dur then
                self.c_done = self.c_done + 1
                self.c_ang = self.c_ang + self.c_angle
                self.c_spd = self.c_speed
                spd = self.c_spd
                ---原作抬速帧末尾仍跑 `commandStates[3].timer++`（snap 时先清 0 再 ++ ⇒ 1），
                ---所以下一轮 ramp 要从 timer=1 起算；写 0 会让整个下一轮慢一帧。
                self.c_timer = 1
                ---原作的抬速帧（`BulletManager.cpp:786`）**先按新角度/新速度算出速度再清位**，
                ---下一帧才由 RunCommands 接到下一段；所以这里也要在本帧落地新速度，
                ---不能提前 return（否则少飞一帧）。
                self.rot = self.c_ang
                self.vx, self.vy = spd * cos(self.c_ang), spd * sin(self.c_ang)
                if self.c_done >= self.c_loop then cmdbullet_next(self) end
                bullet.frame(self); return
            else
                spd = self.c_spd - self.c_timer * self.c_spd / self.c_dur
            end
            self.rot = self.c_ang
            self.vx, self.vy = spd * cos(self.c_ang), spd * sin(self.c_ang)
            self.c_timer = self.c_timer + 1
        elseif self.c_type == 0x80 then
            local spd
            if self.c_timer >= self.c_dur then
                self.c_done = self.c_done + 1
                self.c_ang = Angle(self, player) + self.c_angle
                self.c_spd = self.c_speed
                spd = self.c_spd
                self.c_timer = 1     -- 原作 snap 后 timer 0→++ ⇒ 1（见 0x40 的注释）
                self.rot = self.c_ang
                self.vx, self.vy = spd * cos(self.c_ang), spd * sin(self.c_ang)
                if self.c_done >= self.c_loop then cmdbullet_next(self) end
                bullet.frame(self); return
            else
                spd = self.c_spd - self.c_timer * self.c_spd / self.c_dur
            end
            self.rot = self.c_ang
            self.vx, self.vy = spd * cos(self.c_ang), spd * sin(self.c_ang)
            self.c_timer = self.c_timer + 1
        elseif self.c_type == 0x100 then
            ---TH07 `UpdateBulletDirChangeAbsoluteAndResume`（BulletManager.cpp:811）：与
            ---0x40 一样先用 dur 帧把速度线性刹到 0，但到点后**绝对**把朝向设成
            ---commandStates.angle（= ECL cmd.speed，激活那刻冻结）、速度设成 cmd.angle
            ---（> -999；否则用弹此刻速率），共 loop 轮。原作 stage3 sub59 的 T100 弹
            ---就是靠它「刹停 → 瞬间转向自机方向再飞」。
            local spd
            if self.c_timer >= self.c_dur then
                self.c_done = self.c_done + 1
                self.c_ang = self.c_angle
                self.c_spd = self.c_speed
                spd = self.c_spd
                self.c_timer = 1     -- 原作 snap 后 timer 0→++ ⇒ 1（见 0x40 的注释）
                self.rot = self.c_ang
                self.vx, self.vy = spd * cos(self.c_ang), spd * sin(self.c_ang)
                if self.c_done >= self.c_loop then cmdbullet_next(self) end
                bullet.frame(self); return
            else
                spd = self.c_spd - self.c_timer * self.c_spd / self.c_dur
            end
            self.rot = self.c_ang
            self.vx, self.vy = spd * cos(self.c_ang), spd * sin(self.c_ang)
            self.c_timer = self.c_timer + 1
        end
        bullet.frame(self)
    end,
})

---──────────────────── 炮台（原作 sub 5/6/7/8 → SUB_CALL 4） ────────────────────
---原地不动、t=50..114 自转、每 20 帧打一圈 25 发；sprite 0/3 的差别用弹型代理体现。
---（下面这一大段 stage4 三姐妹的常量 / 发弹函数只在紧邻的类定义里用；
--- 塞进 do..end 让它们出了块就失效，免得顶层 local 撞 Lua 的 200 上限。）
do
local TUR4_STYLE = 24                       -- 原作 SET_ANM 24；用 enemy_orb2 当代理
local TUR4_GAP = 20                         -- SET_SHOOT_INTERVAL_RAND 20（Lunatic 行）
local TUR4_STOP = 114                       -- t=114 把间隔置 0 ⇒ 停火
local TUR4_LIFE = 2114                      -- t=2114 UNIMP ⇒ 自毁
local TUR4_INVUL = 10
local TUR4_SPIN = 0.0981748 * RAD2DEG       -- ANGULAR_VELOCITY = π/32
local TUR4_C1, TUR4_C2 = 5, 5
local TUR4_S1, TUR4_S2 = 4, 1
---sub5/6 的 sprite=0（PELLET）、sub7/8 的 sprite=3（BALL）；spriteOffset 都是 6。
---★ 层间偏移角的**符号四种各不相同**（sub5 +π/48、sub6 −π/48、sub7 −π/32、sub8 +π/32）——
---不能只按「弹型」分两组，否则 sub6/sub7 的五层会朝反方向叠（原作 sub5..8 靠
---`$10041` 传进 sub4 的 `angle2`，四种各写各的）。
local TUR4_A2 = {
    [5] = 0.0654498 * RAD2DEG,      -- +π/48
    [6] = -0.0654498 * RAD2DEG,     -- −π/48
    [7] = -0.0981748 * RAD2DEG,     -- −π/32
    [8] = 0.0981748 * RAD2DEG,      -- +π/32
}

local function turret4_volley(self)
    local p = Angle(self, player)
    local step = 360 / TUR4_C1
    volley4(self, TUR4_C1 * TUR4_C2, function(i)
        local k = i - 1
        local layer, ring = int(k / TUR4_C1), k % TUR4_C1
        local v = TUR4_S1 - (TUR4_S1 - TUR4_S2) * layer / TUR4_C2
        return self.bstyle, self.bcol, v, p + ring * step + layer * self.a2
    end)
end

class["TH34_turret4"] = Class(enemy, {
    ---@param sub number 原作的子程序号 5/6/7/8（决定 sprite 0/3 与层间偏移角的符号）
    init = function(self, x, y, life, sub)
        enemy.init(self, TUR4_STYLE, hp4(life), false, true, true)
        self.x, self.y = x, y
        self.kind = sub
        self.a2 = TUR4_A2[sub]
        self.bstyle = (sub >= 7) and ball_small or grain_a   -- sub7/8 的 sprite=3（BALL）
        self.bcol = COLOR.BLUE               -- spriteOffset 6
        self.protect = true                  -- SET_INVINCIBILITY_TIMER 10
        task.New(self, function()
            task.Wait(TUR4_INVUL)
            self.protect = false
        end)
        ---开火：首轮延迟 1..20 帧（SET_SHOOT_INTERVAL_RAND 的 0..n 随机初值），到 t=114 停。
        task.New(self, function()
            task.Wait(ran:Int(1, TUR4_GAP))
            while self.timer < TUR4_STOP do
                turret4_volley(self)
                task.Wait(TUR4_GAP)
            end
        end)
        task.New(self, function()
            task.Wait(TUR4_LIFE)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        if self.timer > 50 and self.timer <= TUR4_STOP then
            self.rot = self.rot + TUR4_SPIN
        end
    end,
    kill = function(self)
        ---itemdrop = −1：原作 1/3 概率掉随机道具（差异 23 折成信仰）。
        if ran:Int(0, 2) == 0 then
            New(item.obj.faith, self.x, self.y)
        end
        enemy.kill(self)
    end,
})

---──────────────────── 大幽灵（原作 sub 9 + sub 10） ────────────────────
---出生 30 帧无敌、每 10 帧朝自机撒 14 发；半角从 11.25° 线性收到 0（差异 29）。
local GH4_STYLE = 31
local GH4_INVUL = 30
local GH4_SPIN = 0.0314159 * RAD2DEG        -- ANGULAR_VELOCITY = −π/100（我们取 −）
local GH4_HALO = 0.19635 * RAD2DEG          -- INIT_INTERP 的 p0 = π/16
local GH4_N = 14                            -- Lunatic 行 count1
local GH4_S1, GH4_S2 = 3.8, 1.5
local GH4_LIFE = 2100

local function ghost4_volley(self)
    local p = Angle(self, player)
    local halo = GH4_HALO * (1 - min(self.timer, 100) / 100)
    volley4(self, GH4_N, function()
        local a = p + ran:Float(-halo, halo)     -- RANDOM：角度先抽
        return ball_small, COLOR.BLUE, ran:Float(GH4_S2, GH4_S1), a
    end)
end

class["TH34_ghost4"] = Class(enemy, {
    init = function(self, x, y, life)
        enemy.init(self, GH4_STYLE, hp4(life), false, true, false)
        self.x, self.y = x, y
        self.protect = true
        self.drop = { 0, 0, 1 }              -- itemdrop 1 = 点道具
        task.New(self, function()
            task.Wait(GH4_INVUL)
            self.protect = false
        end)
        task.New(self, function()
            for _ = 1, 10 do
                task.Wait(10)
                ghost4_volley(self)
            end
        end)
        task.New(self, function()
            task.Wait(GH4_LIFE)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        if self.timer > 50 and self.timer <= 100 then
            self.rot = self.rot - GH4_SPIN
        end
    end,
})

---──────────────────── 厚血怪（原作 sub 13/14） ────────────────────
---60 帧 ease-out-quad 下滑 180 px ⇒ 到位后 20 轮 7 路扇，张角逐轮收窄；
---被击破时撒 6 个道具 + 消掉半径 96 内的弹（原作死亡回调 sub 12）。
local TANK4_STYLE = 31
local TANK4_INVUL = 40
local TANK4_RISE_T = 60
local TANK4_RISE = 180
local TANK4_C1, TANK4_C2 = 7, 2
local TANK4_S1, TANK4_S2 = 4, 2
local TANK4_ROUNDS = 20
local TANK4_GAP = 9
local TANK4_LIFE = 2129

---第 r 轮的张角：第 1 轮 $10005 还没被写过（=0），之后是 INIT_INTERP 的
---MathLerp(9(r−1)/180) —— 落点是第一条 op65，所以插值只注册一次、不重置（差异 27）。
local function tank4_a2(self, r)
    if r <= 1 then
        return 0
    end
    local t = min(TANK4_GAP * (r - 1), 180) / 180
    return (self.a2_1 - self.a2_0) * t + self.a2_0
end

local function tank4_volley(self, r)
    local off = spread_offsets(TANK4_C1, tank4_a2(self, r))
    volley4(self, TANK4_C1 * TANK4_C2, function(i)
        local k = i - 1
        local layer, ring = int(k / TANK4_C1), k % TANK4_C1
        local v = TANK4_S1 - (TANK4_S1 - TANK4_S2) * layer / TANK4_C2
        return ball_small, self.bcol, v, self.aim + off[ring + 1]
    end)
end

class["TH34_tank4"] = Class(enemy, {
    ---@param kind string "l"（sub13，spriteOffset 10）/ "r"（sub14，spriteOffset 13）
    init = function(self, x, y, life, kind)
        enemy.init(self, TANK4_STYLE, hp4(life), false, true, true)
        self.x, self.y = x, y
        self.y0 = y
        self.kind = kind
        self.bcol = (kind == "l") and COLOR.GREEN or COLOR.GOLDEN_YELLOW
        ---INIT_INTERP 的 p0/p1：左（Lunatic 行）60°→11.25°，右（唯一一行）90°→15°
        self.a2_0 = ((kind == "l") and 1.0472 or 1.5708) * RAD2DEG
        self.a2_1 = ((kind == "l") and 0.19635 or 0.261799) * RAD2DEG
        self.aim = 0
        self.protect = true
        self.drop = { 0, 0, 1 }              -- itemdrop 1 = 点道具
        task.New(self, function()
            task.Wait(TANK4_INVUL)
            self.protect = false
        end)
        task.New(self, function()
            task.Wait(TANK4_RISE_T)
            self.aim = Angle(self, player)   -- $10004 在到位这一帧冻结
            for r = 1, TANK4_ROUNDS do
                tank4_volley(self, r)
                task.Wait(TANK4_GAP)
            end
        end)
        task.New(self, function()
            task.Wait(TANK4_LIFE)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        ---位置先更新，再让 task 用新位置发弹（子弹必须从到位后的位置出去）。
        if self.timer <= TANK4_RISE_T then
            local u = self.timer / TANK4_RISE_T
            self.y = self.y0 - TANK4_RISE * (1 - (1 - u) * (1 - u))
        end
        enemy.frame(self)
    end,
    kill = function(self)
        ---sub 12：4 个随机道具 + 2 个点道具 + 消弹（差异 23）。
        scatter_items(item.obj.faith, 4, self.x, self.y)
        scatter_items(item.obj.point, 2, self.x, self.y)
        clear4_radius(self.x, self.y, 96)
        enemy.kill(self)
    end,
})

---──────────────────── 旋环妖精（原作 sub 17/19/21 → SUB_CALL 15） ────────────────────
---原地自转（三种速度）、出生第 134 帧打一圈 24 发；死亡弹按 sub 16/18/20 分三种。
local FA4_STYLE = 5                          -- 用 kedama/enemy5 的蓝色小人当代理
local FA4_INVUL = 10
local FA4_LIFE = 2134
local FA4_SHOT_T = 134
local FA4_N = 24
local FA4_S = 4
local FA4_SPIN = { a = 0.0981748 * RAD2DEG, b = 0.0654498 * RAD2DEG, c = 0.0654498 * RAD2DEG }

---sub 16（Lunatic 实际发射 ①+⑤+⑥+⑦ 四条，差异 30）
local function fairy4_death_a(self)
    local p = Angle(self, player)
    ---① count1=3,count2=2,s1=2,s2=1,a1=π,a2=2.8125°，flags 0x210（0x10：每帧反向加速）
    local off1 = spread_offsets(3, 0.0490874 * RAD2DEG)
    local vx, vy = -0.1 * cos(p + 180), -0.1 * sin(p + 180)
    volley4_raw(self, 3 * 2, function(i)
        local k = i - 1
        local layer, ring = int(k / 3), k % 3
        local v = 2 - (2 - 1) * layer / 2
        local a = p + 180 + off1[ring + 1]
        return New(class["TH34_cmdbullet"], ball_small, COLOR.BLUE, self.x, self.y, v, a,
                   { type = 0x10, dur = 60, loop = 1, angle = 0, speed = -0.1,
                     vec_x = cos(a) * -0.1, vec_y = sin(a) * -0.1 })
    end)
    ---⑤ count1=5,count2=2,s1=3.5,s2=1,a1=0,a2=6.43°
    local off2 = spread_offsets(5, 0.1122 * RAD2DEG)
    volley4(self, 5 * 2, function(i)
        local k = i - 1
        local layer, ring = int(k / 5), k % 5
        local v = 3.5 - (3.5 - 1) * layer / 2
        return ball_small, COLOR.DEEP_BLUE, v, p + off2[ring + 1]
    end)
    ---⑥⑦ 各 count1=3,count2=2,s1=2,s2=1,a2=5.625°，a1 = ±120°
    for _, a1 in ipairs({ 120, -120 }) do
        local off3 = spread_offsets(3, 0.0981748 * RAD2DEG)
        volley4(self, 3 * 2, function(i)
            local k = i - 1
            local layer, ring = int(k / 3), k % 3
            local v = 2 - (2 - 1) * layer / 2
            return ball_small, COLOR.DEEP_BLUE, v, p + a1 + off3[ring + 1]
        end)
    end
end

---sub 18：count1=7,count2=3,s1=距离/128+0.8,s2=0.8,a2=3.6°
local function fairy4_death_b(self)
    local p = Angle(self, player)
    local s1 = Dist(self, player) / 128 + 0.8
    local off = spread_offsets(7, 0.0628319 * RAD2DEG)
    volley4(self, 7 * 3, function(i)
        local k = i - 1
        local layer, ring = int(k / 7), k % 7
        local v = s1 - (s1 - 0.8) * layer / 3
        return ball_small, COLOR.RED, v, p + off[ring + 1]
    end)
end

---sub 20：三组 RING_ABS 各 12 发（Lunatic），**每组各挂自己那条 INIT_BULLET_CMD 0x80**
---（原始字节码是 INIT→spawn 交替三次，不是一条槽被覆盖）：
---  组1 cmd(speed=0,      angle=1  ) → 朝自机偏移 0°  / 到点后速度 1
---  组2 cmd(speed=+2.0944, angle=1.5) → 偏移 +120°（我们 −120°）/ 速度 1.5
---  组3 cmd(speed=−2.0944, angle=1.5) → 偏移 −120°（我们 +120°）/ 速度 1.5
---（0x80 的读取有个 ZUN 交换：`commandStates[3].angle = cmd.speed`（自机偏移）、
--- `commandStates[3].speed = cmd.angle`（到点后的速度）——见 BulletManager.cpp:410-420。）
local FAIRY4_C_CMD = {
    { off = 0, mag = 1 },
    { off = -2.0944 * RAD2DEG, mag = 1.5 },
    { off = 2.0944 * RAD2DEG, mag = 1.5 },
}
local function fairy4_death_c(self)
    for g = 0, 2 do
        local a1 = (g * 0.174533) * RAD2DEG   -- Lunatic 行：0° / 10° / 20°
        local cmd = FAIRY4_C_CMD[g + 1]
        volley4_raw(self, 12, function(i)
            local a = (i - 1) * (360 / 12) - a1
            return New(class["TH34_cmdbullet"], grain_a, COLOR.RED, self.x, self.y, 4.2, a,
                       { type = 0x80, dur = 60, loop = 1, angle = cmd.off, speed = cmd.mag })
        end)
    end
end

class["TH34_fairy4"] = Class(enemy, {
    ---@param kind string "a"（sub17）/ "b"（sub19）/ "c"（sub21）
    ---@param drop number 原作时间轴的 itemdrop（0 = 小能量 / 1 = 点）
    init = function(self, x, y, life, kind, drop)
        enemy.init(self, FA4_STYLE, hp4(life), false, true, true)
        self.x, self.y = x, y
        self.kind = kind
        self.protect = true
        self.drop = { 0, DROP_FAITH[drop], DROP_POINT[drop] }
        task.New(self, function()
            task.Wait(FA4_INVUL)
            self.protect = false
        end)
        task.New(self, function()
            task.Wait(FA4_SHOT_T)
            local p = Angle(self, player)
            volley4(self, FA4_N, function(i)
                return arrow_small, COLOR.GREEN, FA4_S, p + (i - 1) * (360 / FA4_N)
            end)
        end)
        task.New(self, function()
            task.Wait(FA4_LIFE)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        if self.timer > 50 and self.timer <= TUR4_STOP then
            self.rot = self.rot + FA4_SPIN[self.kind]
        end
    end,
    kill = function(self)
        if self.kind == "a" then
            fairy4_death_a(self)
        elseif self.kind == "b" then
            fairy4_death_b(self)
        else
            fairy4_death_c(self)
        end
        enemy.kill(self)
    end,
})

---==================== 挂到空 boss 的第二张符卡 ====================
---这一张和上面的「六面道中」共用同一个空 boss：`boss.Define` 只能调一次、且必须早于
---`boss.card.add`，但 `boss.card.add` 可以重复调 —— 每调一次就往 `_editor_boss["1a32"]`
---的 `cards` 里追加一张，所以这就是「th34 的另一张符卡」。
---BGM 沿用 boss.Define 时定的 TH07_1（一个 boss 只能有一首），背景仍是第六面。
do
    local CARD_NAME = "四面道中「骚灵们的合奏」"
    ---原作这一段 t=200..6622（约 110 秒），最后一只妖精的死亡弹到 t≈6756；
    ---给 150 秒留够收尾（所有小怪的寿命帧都在卡内跑完，del 里没事可做）。
    local CARD_TIME = 150
    ---关卡号 32 = core.lua 的 STAGE_COUNT(32) + 1（和上一张卡同一个 boss）。
    local LEVEL = 32
    ---符卡历史槽位（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
    ---本关（th34）自己的一段是 3400..3407（按面序，见第六面那张卡的注释），
    ---这张是第四面 ⇒ 3403。
    ---⚠ 只扫 `boss.card.add` 的末参会漏掉 th31 的 LIST（它的 id 写在表里、由变量传进 add）——
    ---  照那种扫法挑出来的"空号"（本卡原来取的 433 就是）一注册就报「card_id 跨组重复」。
    local CARD_ID = 3403

    ---逐条生成表：{ 距上一只的帧数, 子程序号, x, y, itemdrop, life }
    ---（x/y 已按「我们 x = TH07 x − 192 / 我们 y = 224 − TH07 y」换算；293 条全部用
    --- /tmp/eclwork 的解释器逐值对过时间轴 0，dt 也对过一遍。）
    ---子程序号决定挂哪个类：5..8=炮台、9=大幽灵、13/14=厚血怪、17/19/21=旋环妖精。
    local WAVE4 = {
    {   0,  5, -208,  144, -1,  10}, {   4,  5, -208,  144, -1,  10}, {   4,  5, -208,  144, -1,  10}, {   4,  5, -208,  144, -1,  10},
    {   4,  5, -208,  144, -1,  10}, {   4,  5, -208,  144, -1,  10}, {   4,  5, -208,  144, -1,  10}, {   4,  5, -208,  144, -1,  10},
    {   4,  5, -208,  144, -1,  10}, { 200,  6,  208,  144, -1,  10}, {   4,  6,  208,  144, -1,  10}, {   4,  6,  208,  144, -1,  10},
    {   4,  6,  208,  144, -1,  10}, {   4,  6,  208,  144, -1,  10}, {   4,  6,  208,  144, -1,  10}, {   4,  6,  208,  144, -1,  10},
    {   4,  6,  208,  144, -1,  10}, {   4,  6,  208,  144, -1,  10}, {  80,  5, -208,  160, -1,  10}, {   4,  5, -208,  160, -1,  10},
    {   4,  5, -208,  160, -1,  10}, {   4,  5, -208,  160, -1,  10}, {   4,  5, -208,  160, -1,  10}, {   4,  5, -208,  160, -1,  10},
    {   4,  5, -208,  160, -1,  10}, {   4,  5, -208,  160, -1,  10}, {   4,  5, -208,  160, -1,  10}, {  80,  6,  208,   96, -1,  10},
    {   4,  6,  208,   96, -1,  10}, {   4,  6,  208,   96, -1,  10}, {   4,  6,  208,   96, -1,  10}, {   4,  6,  208,   96, -1,  10},
    {   4,  6,  208,   96, -1,  10}, {   4,  6,  208,   96, -1,  10}, {   4,  6,  208,   96, -1,  10}, {   4,  6,  208,   96, -1,  10},
    {  90,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10}, {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10},
    {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10}, {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10},
    {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10}, {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10},
    {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10}, {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10},
    {   2,  6,  208,  160, -1,  10}, {   2,  5, -208,   96, -1,  10}, { 120,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10},
    {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10}, {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10},
    {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10}, {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10},
    {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10}, {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10},
    {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10}, {   2,  6,  208,  112, -1,  10}, {   2,  5, -208,  128, -1,  10},
    { 120,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, { 120,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10},
    {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144,  2,  10}, {   2,  7, -208,  144,  2,  10},
    {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10},
    {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10},
    {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10},
    {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144, -1,  10}, {   2,  7, -208,  144, -1,  10}, {   2,  8,  208,  144,  2,  10},
    {   2,  7, -208,  144,  2,  10}, { 700,  9,  176,  240,  1, 100}, {  60,  9, -176,  256,  1, 100}, {  60,  9,  -96,  272,  1, 100},
    {  60,  9,   64,  240,  1, 100}, {  60,  9,    0,  256,  1, 100}, { 300,  9,  176,  240,  1, 100}, {  60,  9, -176,  256,  1, 100},
    {  60,  9,  -96,  272,  1, 100}, {  60,  9,   64,  240,  1, 100}, {  60,  9,    0,  256,  1, 100}, { 300, 13, -160,  256,  1, 500},
    { 100, 14,  160,  256,  1, 500}, { 100, 13, -128,  256,  1, 500}, { 100, 14,  128,  256,  1, 500}, {  90, 13,  -96,  256,  1, 500},
    {  90, 14,   96,  256,  1, 500}, {  80, 13, -128,  256,  1, 500}, {  80, 14,  160,  256,  1, 500}, {  70, 13, -128,  256,  1, 500},
    {  70, 14,  128,  256,  1, 400}, {  60, 13,  -96,  256,  1, 400}, {  60, 14,   96,  256,  1, 400}, {  60, 13, -128,  256,  1, 300},
    {   0, 14,  128,  256,  1, 300}, { 300, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  0,  10},
    {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  0,  10}, {   8, 17,  208,  144,  1,  10},
    {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  0,  10}, {  50, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  1,  10},
    {   8, 17, -208,  144,  0,  10}, {   8, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  0,  10},
    {   8, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  0,  10}, {  50, 17,  208,  144,  1,  10},
    {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  0,  10}, {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  1,  10},
    {   8, 17,  208,  144,  0,  10}, {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  1,  10}, {   8, 17,  208,  144,  0,  10},
    {  50, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  0,  10}, {   8, 17, -208,  144,  1,  10},
    {   8, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  0,  10}, {   8, 17, -208,  144,  1,  10}, {   8, 17, -208,  144,  1,  10},
    {   8, 17, -208,  144,  0,  10}, { 100, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  0,  10},
    {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  0,  10}, {   8, 19,  208,  144,  1,  10},
    {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  0,  10}, {  50, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10},
    {   8, 19, -208,  144,  0,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  0,  10},
    {   8, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  0,  10}, {  50, 19,  208,  144,  1,  10},
    {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  0,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10},
    {   8, 19,  208,  144,  0,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 19,  208,  144,  0,  10},
    {  50, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  0,  10}, {   8, 19, -208,  144,  1,  10},
    {   8, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  0,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10},
    {   8, 19, -208,  144,  0,  10}, { 100, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10},
    {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10}, {   8, 21,  208,  144,  1,  10},
    {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10}, {  50, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  1,  10},
    {   8, 21, -208,  144,  0,  10}, {   8, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10},
    {   8, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10}, { 100, 21,  208,  144,  1,  10},
    {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10}, {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  1,  10},
    {   8, 21,  208,  144,  0,  10}, {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10},
    {  50, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10}, {   8, 21, -208,  144,  1,  10},
    {   8, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10}, {   8, 21, -208,  144,  1,  10}, {   8, 21, -208,  144,  1,  10},
    {   8, 21, -208,  144,  0,  10}, { 300, 17,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10},
    {   8, 17,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10}, {   8, 17,  208,  144,  1,  10},
    {   8, 19,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10}, {  50, 17, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10},
    {   8, 21, -208,  144,  0,  10}, {   8, 17, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10},
    {   8, 17, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10}, { 150, 17,  208,  144,  1,  10},
    {   8, 19,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10}, {   8, 17,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10},
    {   8, 21,  208,  144,  0,  10}, {   8, 17,  208,  144,  1,  10}, {   8, 19,  208,  144,  1,  10}, {   8, 21,  208,  144,  0,  10},
    {  50, 17, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10}, {   8, 17, -208,  144,  1,  10},
    {   8, 19, -208,  144,  1,  10}, {   8, 21, -208,  144,  0,  10}, {   8, 17, -208,  144,  1,  10}, {   8, 19, -208,  144,  1,  10},
    {   8, 21, -208,  144,  0,  10},

    }

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        ---耐久卡：不打超时音、关掉本体的判定与血条（照上面那张卡与 th31 的 Last Word 写法）
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        ---弹池登记表与音效去重的帧号都是跨局的模块级状态：重开这张卡（符卡练习）时清一次，
        ---免得上一局的残留影响第一帧的判定。
        pool4 = {}
        sound_tick4, sound_stamp4 = 0, -1
        ---WAVE4 的 dt 是**相对上一只**的帧间隔，所以用一条协程顺着等下去；
        ---spawn 当帧就把子程序跑到第一条 time>0 的指令（原作同样如此，见文件头）。
        task.New(self, function()
            for _, w in ipairs(WAVE4) do
                task.Wait(w[1])
                local sub = w[2]
                if sub <= 8 then
                    New(class["TH34_turret4"], w[3], w[4], w[6], sub)
                elseif sub == 9 then
                    New(class["TH34_ghost4"], w[3], w[4], w[6])
                elseif sub <= 14 then
                    New(class["TH34_tank4"], w[3], w[4], w[6], (sub == 13) and "l" or "r")
                else
                    New(class["TH34_fairy4"], w[3], w[4], w[6],
                            (sub == 17) and "a" or (sub == 19) and "b" or "c", w[5])
                end
            end
        end)
    end
    ---音效去重的时钟：一帧推一格（各小怪拿它跟自己记住的帧号比）。
    function card:frame()
        sound_tick4 = sound_tick4 + 1
    end
    function card:render() end
    ---★ 这里不需要清理：所有小怪都是**独立对象**（没有 object.Connect 到 boss），
    ---寿命最长的妖精是 t=6622 出生、t=8756 自毁，都在 150 秒（9000 帧）的卡内跑完。
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end

end

---==================== 第 3 面道中：代码 ====================
---自然语言说明与逐条差异在文件头的「第 3 面道中」单元里。
---和上面的四/六面卡一样是「道中搬运卡」：空 boss + 一张耐久符卡，按帧把
---`ecldata3.ecl` 时间轴 0 的 t=450..3023 搬进来（子程序号 3/4/5/6=小怪、7..12=大幽灵）。
local ball_big = ball_big

---第 3 面非 boss 的血量折算（文件头差异 31）：life × 0.09825，保底 1 点。
---0.09825 = 0.1965 × 0.5 / 1.0 —— 第 5/6 面非 boss 是 ÷2、第 3 面**没有**减伤
---（EnemyManager.cpp:820-845 只给 STAGE4 和 STAGE5/6 打折），所以同样 life 的杂鱼
---在第 3 面要多折一半血，击杀耗时才与原作一致（照 hp4 = 0.1965 × 0.5 / 0.6875 同一套折算）。
local function hp3(life)
    return max(1, int(life * 0.09825 + 0.5))
end

---TH07 的 spriteOffset(1..16) 就是 16 档色号；本仓库 COLOR.* 的编号与它同序
---（THlib/bullet/bulletStyle.lua:267），所以同号映射即可（差异 20 已说明色档是近似）。
local COL16 = { COLOR.DEEP_RED, COLOR.RED, COLOR.DEEP_PURPLE, COLOR.PURPLE,
                COLOR.DEEP_BLUE, COLOR.BLUE, COLOR.ROYAL_BLUE, COLOR.CYAN,
                COLOR.DEEP_GREEN, COLOR.GREEN, COLOR.CHARTREUSE, COLOR.YELLOW,
                COLOR.GOLDEN_YELLOW, COLOR.ORANGE, COLOR.DEEP_GRAY, COLOR.GRAY }
local function col16(off)
    return COL16[off] or COLOR.BLUE
end

---一次「波」（照 volley4，但带一个 plays 开关：flags 0x200 才响音效，
---第 3 面小怪的 flags=0x2 是**无声**的 spawn-fast）。
local function volley3(self, total, gen, plays)
    local room = POOL4_SIZE - pool4_used()
    local i = 1
    while i <= total and room > 0 do
        local style, col, v, a = gen(i)
        pool4[#pool4 + 1] = NewSimpleBullet(style, col, self.x, self.y, v, a, false, 0, false)
        room, i = room - 1, i + 1
    end
    if plays then sound4(self) end
end

---op65 SPREAD（BulletManager.cpp:180-202）：th07 第 i 发的相对角是 ±(…)·a2，
---整段取反后就是 ∓(…)·a2 —— offset 对 a2 线性，所以调 spread_offsets 时传 −a2 即可。
local function spread3(count1, a2_deg)
    return spread_offsets(count1, -a2_deg)
end

---把一条 SPREAD 打出去（sprite/offset/count/speed/angle 全照 Lunatic 行）。
---a1/a2 传 th07 的**弧度**，函数里换算成我们的角度制并取反。
local function w3_spread(self, style, off, c1, c2, v1, v2, a1_th, a2_th, aim, plays)
    local base = (aim and Angle(self, player) or 0) - a1_th * RAD2DEG
    local offs = spread3(c1, a2_th * RAD2DEG)
    volley3(self, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        local v = v1 - (v1 - v2) * layer / c2
        return style, col16(off), v, base + offs[ring + 1]
    end, plays)
end

---RING（op66/op67）：th07 angle = ±(x·2π/c1 + y·a2 + a1)；取反后 x 那一项还是整圈，
---于是我们的角 = base + x·360/c1 + y·(−a2)，base 里带 (−a1) 或自机角。
local function w3_ring(self, style, off, c1, c2, v1, v2, a1_th, a2_th, aim, plays)
    local base = (aim and Angle(self, player) or 0) - a1_th * RAD2DEG
    local step = 360 / c1
    local a2 = -a2_th * RAD2DEG
    volley3(self, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        local v = v1 - (v1 - v2) * layer / c2
        return style, col16(off), v, base + ring * step + layer * a2
    end, plays)
end

---RANDOM（op72）：th07 angle = rand[0, a1−a2) + a2、speed = rand[0, v1−v2) + v2。
---第 3 面 sub 12 把 a1/a2 取成 Aim±c ⇒ 我们的角 = 自机角 + rand(−c, +c)。
local function w3_random(self, style, off, c1, v1, v2, c_th, plays)
    local base = Angle(self, player)
    local lim = c_th * RAD2DEG
    volley3(self, c1, function()
        ---★ 原作 op72 RANDOM 逐发**先抽角、后抽速**（BulletManager.cpp:215-231）；
        ---  顺序反了同一条 RNG 流就整段错位。
        local a = base + ran:Float(-lim, lim)
        local v = ran:Float(v2, v1)
        return style, col16(off), v, a
    end, plays)
end

---──────────────────── 道中小怪（原作 sub 3/4/5/6） ────────────────────
---全部从 y=240（画面上方）出生：sub3 垂直下坠、sub4/5 斜落、sub6 先沿 θ
---ease-out-quad 冲 60 帧再掉头向上。开火只有 t=0（sub6 是 t=60）那一轮是固定的，
---其余靠 SET_SHOOT_INTERVAL_RAND 每 n 帧重打同一轮，到 t=150 停火、t=2150 自毁。
local W3_STYLE = 5                        -- SET_ANM 0/5：kedama 蓝色小人当代理
local W3_STOP = 150                       -- SET_SHOOT_INTERVAL 0
local W3_LIFE = 2150                      -- sub 3/4/5 的 UNIMP
local W3_LIFE6 = 2060                     -- sub 6 的 UNIMP
local W3_RISE_T = 60                      -- sub 6 的 MOVE_DIR_TIME(60,4,…)
local W3_RISE_D = 180                     -- 3 px/帧 × 60 帧

---RAND_FLOAT_ADD $10004, 0.0981748, 1.52171 ⇒ θ ∈ [0.0982, 1.62) 弧度
local function w3_theta()
    return ran:Float(0.0981748, 0.0981748 + 1.52171)
end

---每只小怪的固定齐射（Lunatic 行）：{ sprite, offset, c1, c2, v1, v2, a1, a2, aim }
local W3_VOLLEY = {
    [3] = { grain_a,    6, 4, 1, 2.1, 0.5, 0,        0.392699,  true  },
    [4] = { grain_a,    6, 5, 2, 3,   1.3, 0,        0.0654498, true  },
    [5] = { grain_a,    2, 1, 4, 3.3, 1,   0,        0.0981748, true  },
    [6] = { ball_small, 2, 2, 3, 3.2, 1,   1.5708,   0.314159,  false },
}
local W3_INTERVAL = { [3] = 200, [4] = 40, [5] = 100 }

local function w3_fire(self)
    local p = W3_VOLLEY[self.kind]
    if p then
        w3_spread(self, p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], false)
    end
end

class["TH34_walker3"] = Class(enemy, {
    ---@param sub number 原作的子程序号 3/4/5/6
    ---@param mirror number 时间轴的 mirror 位（1 = 速度的 x 分量取反，原作 Enemy::Move）
    init = function(self, x, y, life, sub, mirror)
        enemy.init(self, W3_STYLE, hp3(life), false, true, false)
        self.x, self.y = x, y
        self.A, self.B = 24, 24           -- SET_HITBOX_SIZE 24,24,32
        self.kind, self.mirror = sub, mirror or 0
        ---先给默认值：真机第一帧 frame 就会读这四个（分支里再覆盖）。
        self.dx, self.dy, self.x0, self.y0 = 0, 0, x, y
        object.SetV(self, 0, 0, false)
        local th = (sub == 3) and (PI / 2) or w3_theta()
        if sub == 6 then
            ---MOVE_DIR_TIME(60,4,θ,3)：ease-out-quad 直线，总位移 3×60 px；
            ---mirror 只把 x 分量取反（Enemy::Move / MoveDirTime 的两处镜像）。
            local sx = (self.mirror == 1) and -1 or 1
            self.dx = sx * cos(th * RAD2DEG) * W3_RISE_D
            self.dy = -sin(th * RAD2DEG) * W3_RISE_D
            self.x0, self.y0 = x, y
            self.rise = false
        else
            ---MOVE_DIR_TIME(0,0,θ,spd)：POLAR 匀速直线（th07 的 θ 取反）
            local spd = (sub == 3) and 2 or 1.5
            local deg = (self.mirror == 1) and (180 + th * RAD2DEG) or (-th * RAD2DEG)
            object.SetV(self, spd, deg, false)
        end
        ---SET_SHOOT_INTERVAL_RAND n：初值 rand(0,n)（原作首轮延迟 1..n 帧）
        self.interval = W3_INTERVAL[sub] or 0
        self.itimer = (self.interval > 0) and ran:Int(0, self.interval) or 0
        if sub ~= 6 then
            w3_fire(self)                 -- t=0 那一轮（原作 spawn 当帧就打）
        end
        task.New(self, function()
            if sub == 6 then
                task.Wait(W3_RISE_T)
                w3_fire(self)             -- t=60 那一轮
                object.SetV(self, 2, 90, false)   -- MOVE_DIR_TIME(0,0,−π/2,2) ⇒ 我们 +90°
                self.rise = true
            else
                task.Wait(W3_STOP)
                self.interval = 0         -- SET_SHOOT_INTERVAL 0
            end
        end)
        task.New(self, function()
            task.Wait((sub == 6) and W3_LIFE6 or W3_LIFE)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        ---sub 6 的头 60 帧是脚本插值（原作 ENEMY_MOVE_INTERP 的 ease-out-quad；
        ---插值期间速度保持 0，别和后面的 POLAR 抢位置）
        if self.kind == 6 and not self.rise then
            local u = min(self.timer, W3_RISE_T) / W3_RISE_T
            local e = 1 - (1 - u) * (1 - u)
            self.x = self.x0 + self.dx * e
            self.y = self.y0 + self.dy * e
        end
        ---SET_SHOOT_INTERVAL_RAND 的复刻：每帧 ++，到 n 就把**上一轮**重打一次
        if self.interval > 0 then
            self.itimer = self.itimer + 1
            if self.itimer >= self.interval then
                self.itimer = 0
                w3_fire(self)
            end
        end
    end,
    kill = function(self)
        ---itemdrop −1：原作按 g_ItemDropTable 1/3 概率掉随机道具（表里以小能量为主）
        ---⇒ 折成信仰（与第 4 面炮台同一条近似，差异 23）。
        if ran:Int(0, 2) == 0 then
            New(item.obj.faith, self.x, self.y)
        end
        enemy.kill(self)
    end,
})

---──────────────────── 大幽灵（原作 sub 7/8/9/11/12，sub 10 是 9 的子调用） ────────────────────
---出生在左右两条竖线的外侧（我们的 x=±208，th07 x=16/400），先用 120 帧 Hermite
---（INIT_INTERP，interpType 7 = MathCubicInterp、easing 4 = ease-out-quad）横穿到
---对侧 x=∓64、同时下降到 y=96；t=240（sub 11 是 270）改 POLAR、朝 ±π 匀速 2 平移；
---t=4240/4270 自毁。t=120 起按各自子程序打一轮固定弹幕。
local GH3_STYLE = 31
local GH3_RISE = 120
local GH3_Y1 = 96                        -- p1 = 128(th07) ⇒ 224 − 128
local GH3_Y_M0, GH3_Y_M1 = -64, -144     -- th07 的 +64/+144 取反
local GH3_EXIT, GH3_EXIT11 = 240, 270
local GH3_LIFE, GH3_LIFE11 = 4240, 4270

---sub 7：t=120 四连扇（只有第一条 flags=0x202 带音效）
local function gh3_fire7(self)
    w3_spread(self, ball_small, 2, 5, 2, 1.8, 1,   0, 0.1122, true, true)
    w3_spread(self, ball_small, 2, 4, 2, 2.2, 1.6, 0, 0.1122, true, false)
    w3_spread(self, ball_small, 2, 2, 2, 2.7, 2,   0, 0.1122, true, false)
    w3_spread(self, ball_big,   1, 1, 1, 3.2, 2,   0, 0.1122, true, false)
end

---sub 8：24×4 的环（a2=$10004，但那条 RAND_SIGN 0 是无意义的 ±0，略去）
local function gh3_fire8(self)
    w3_ring(self, ball_small, 6, 24, 4, 3.5, 0.8, 0, 0, false, true)
end

---sub 9 → SUB_CALL 10：c1=1、c2=10 的 RING_AIMED —— 10 层共享同一个自机角、
---每层再转 $10004；4 次调用把 $10004 在 ±π/128 之间来回翻。
local function gh3_ring10(self, a2_th)
    w3_ring(self, arrow_small, 2, 1, 10, 3, 0.8, 0, a2_th, true, true)
end

---sub 11：t=120 一轮无声慢环（0x200）、t=150 一轮 32×2（0x202）
local function gh3_fire11a(self, a1_our)
    w3_ring(self, ball_small, 6, 24, 1, 0.8, 0.8, -a1_our / RAD2DEG, 0, false, false)
end
local function gh3_fire11b(self, a1_our)
    w3_ring(self, ball_small, 6, 32, 2, 2.8, 2, -a1_our / RAD2DEG, 0, false, true)
end

---sub 12：t=120/180/240 三连 RANDOM（角 = 自机角 + rand(−c,+c)、速 = rand[v2,v1)）
local function gh3_fire12(self, c_th, v1)
    w3_random(self, arrow_small, 2, 32, v1, 0.8, c_th, false)
end

class["TH34_bigghost3"] = Class(enemy, {
    ---@param sub number 原作的子程序号 7/8/9/11/12
    init = function(self, x, y, life, sub)
        enemy.init(self, GH3_STYLE, hp3(life), false, true, false)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.kind = sub
        ---先给默认值：真机第一帧 frame 就会读这两个（分支里再覆盖）。
        self.x1, self.m1x = 0, 0
        object.SetV(self, 0, 0, false)
        ---INIT_INTERP 的 p0/p1/m0/m1 在 t=0 求值一次后冻结；X 的两支按 POS_X≷192 分叉。
        self.x0, self.y0 = x, y
        if x >= 0 then                       -- 原作 POS_X >= 192（右半边）
            self.x1, self.m1x = -64, 144     -- p1 = 128(th07)、m1 = +144
            self.exit = 180                  -- th07 −π ⇒ 我们 +π
        else
            self.x1, self.m1x = 64, -144     -- p1 = 256(th07)、m1 = −144
            self.exit = -180                 -- th07 +π ⇒ 我们 −π
        end
        self.mode = 0
        task.New(self, function()
            task.Wait((sub == 11) and GH3_EXIT11 or GH3_EXIT)
            object.SetV(self, 2, self.exit, false)
            self.mode = 2
        end)
        task.New(self, function()
            task.Wait(120)
            if sub == 7 then
                gh3_fire7(self)
            elseif sub == 8 then
                gh3_fire8(self)
            elseif sub == 9 then
                gh3_ring10(self, 0.0245437)
                task.Wait(20); gh3_ring10(self, -0.0245437)
                task.Wait(20); gh3_ring10(self, 0.0245437)
                task.Wait(20); gh3_ring10(self, -0.0245437)
            elseif sub == 11 then
                gh3_fire11a(self, ran:Float(-180, 180))
                task.Wait(30)                -- t=150：重掷一次 $10004
                gh3_fire11b(self, ran:Float(-180, 180))
            elseif sub == 12 then
                gh3_fire12(self, 0.19635, 2.5)   -- t=120
                task.Wait(60); gh3_fire12(self, 0.314159, 3.5)
                task.Wait(60); gh3_fire12(self, 0.523599, 3.5)
            end
        end)
        task.New(self, function()
            task.Wait((sub == 11) and GH3_LIFE11 or GH3_LIFE)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        if self.mode == 0 then
            local u = min(self.timer, GH3_RISE) / GH3_RISE
            local e = 1 - (1 - u) * (1 - u)
            self.x = hermite(e, self.x0, self.x1, 0, self.m1x)
            self.y = hermite(e, self.y0, GH3_Y1, GH3_Y_M0, GH3_Y_M1)
            if self.timer >= GH3_RISE then
                self.mode = 1
            end
        end
    end,
    kill = function(self)
        ---SET_DEATH_CALLBACK_SUB 0：SPAWN_ITEMS 4（首颗大能量）→ $10003/=2 →
        ---SPAWN_POINT_ITEMS 2 ⇒ 折成 4 信仰 + 2 点（差异 23）。
        scatter_items(item.obj.faith, 4, self.x, self.y)
        scatter_items(item.obj.point, 2, self.x, self.y)
        enemy.kill(self)
    end,
})

---==================== 挂到空 boss 的第三张符卡 ====================
do
    local CARD_NAME = "三道中「青之骚灵」"
    ---原作 t=450..3023（约 50 秒）；最晚退场的是 t=2943 的 sub 11 大幽灵
    ---（2943+4270 = 7213 帧），所以给 130 秒把收尾也包进来。
    local CARD_TIME = 130
    local LEVEL = 32
    ---符卡历史槽位：本关（th34）自己的一段 3400..3407（按面序）；这张是第三面 ⇒ 3402。
    local CARD_ID = 3402

    ---逐条生成表：{ 距上一只的帧数, 子程序号, x, y, itemdrop, life, mirror }
    ---（x/y 已换算成我们的坐标；265 条全部用 /tmp/eclwork 的解释器逐值对过时间轴 0）
    ---子程序号决定挂哪个类：3/4/5/6=小怪、7/8/9/11/12=大幽灵（10 是 9 的内部调用）。
    local WAVE3 = {
        {    0,   3,    -142,     240,  -1,   80, 0 },  -- gsub 3 t=450
        {    0,   3,     142,     240,  -1,   80, 1 },  -- gsub 3 t=450
        {   10,   3,    -112,     240,  -1,   80, 0 },  -- gsub 3 t=460
        {    0,   3,     112,     240,  -1,   80, 1 },  -- gsub 3 t=460
        {   10,   3,     -52,     240,  -1,   80, 0 },  -- gsub 3 t=470
        {    0,   3,      52,     240,  -1,   80, 1 },  -- gsub 3 t=470
        {   10,   3,    -162,     240,  -1,   80, 0 },  -- gsub 3 t=480
        {    0,   3,     162,     240,  -1,   80, 1 },  -- gsub 3 t=480
        {   10,   3,     -72,     240,  -1,   80, 0 },  -- gsub 3 t=490
        {    0,   3,      72,     240,  -1,   80, 1 },  -- gsub 3 t=490
        {   10,   3,     -32,     240,  -1,   80, 0 },  -- gsub 3 t=500
        {    0,   3,      32,     240,  -1,   80, 1 },  -- gsub 3 t=500
        {   10,   3,    -152,     240,  -1,   80, 0 },  -- gsub 3 t=510
        {    0,   3,     152,     240,  -1,   80, 1 },  -- gsub 3 t=510
        {   10,   3,    -112,     240,  -1,   80, 0 },  -- gsub 3 t=520
        {    0,   3,     112,     240,  -1,   80, 1 },  -- gsub 3 t=520
        {  394,   4,    -160,     240,  -1,   50, 0 },  -- gsub 4 t=914
        {   10,   4,    -128,     240,  -1,   50, 0 },  -- gsub 4 t=924
        {   10,   4,     -96,     240,  -1,   50, 0 },  -- gsub 4 t=934
        {   20,   4,     160,     240,  -1,   50, 1 },  -- gsub 4 t=954
        {   10,   4,     128,     240,  -1,   50, 1 },  -- gsub 4 t=964
        {   10,   4,      96,     240,  -1,   50, 1 },  -- gsub 4 t=974
        {   20,   5,     -64,     240,  -1,   50, 0 },  -- gsub 5 t=994
        {   10,   4,     -96,     240,  -1,   50, 0 },  -- gsub 4 t=1004
        {   10,   5,    -128,     240,  -1,   50, 0 },  -- gsub 5 t=1014
        {   20,   4,      64,     240,  -1,   50, 1 },  -- gsub 4 t=1034
        {   10,   5,      96,     240,  -1,   50, 1 },  -- gsub 5 t=1044
        {   10,   4,     128,     240,  -1,   50, 1 },  -- gsub 4 t=1054
        {    7,   3,    -160,     240,  -1,   50, 0 },  -- gsub 3 t=1061
        {    7,   3,    -128,     240,  -1,   50, 0 },  -- gsub 3 t=1068
        {    7,   3,     -96,     240,  -1,   50, 0 },  -- gsub 3 t=1075
        {    7,   3,     160,     240,  -1,   50, 1 },  -- gsub 3 t=1082
        {    7,   3,     128,     240,  -1,   50, 1 },  -- gsub 3 t=1089
        {    7,   3,      96,     240,  -1,   50, 1 },  -- gsub 3 t=1096
        {   20,   6,     -32,     240,  -1,  150, 0 },  -- gsub 6 t=1116
        {   10,   4,     -64,     240,  -1,   50, 0 },  -- gsub 4 t=1126
        {   10,   6,    -112,     240,  -1,  150, 0 },  -- gsub 6 t=1136
        {   20,   4,      32,     240,  -1,   50, 1 },  -- gsub 4 t=1156
        {   10,   6,      64,     240,  -1,  150, 1 },  -- gsub 6 t=1166
        {   10,   4,     112,     240,  -1,   50, 1 },  -- gsub 4 t=1176
        {    7,   3,    -160,     240,  -1,   50, 0 },  -- gsub 3 t=1183
        {    7,   5,    -128,     240,  -1,   50, 0 },  -- gsub 5 t=1190
        {    7,   3,     -96,     240,  -1,   50, 0 },  -- gsub 3 t=1197
        {    7,   5,     160,     240,  -1,   50, 1 },  -- gsub 5 t=1204
        {    7,   3,     128,     240,  -1,   50, 1 },  -- gsub 3 t=1211
        {    7,   5,      96,     240,  -1,   50, 1 },  -- gsub 5 t=1218
        {   20,   4,     -64,     240,  -1,   50, 0 },  -- gsub 4 t=1238
        {   10,   5,     -96,     240,  -1,   50, 0 },  -- gsub 5 t=1248
        {   10,   6,    -128,     240,  -1,   50, 0 },  -- gsub 6 t=1258
        {   20,   4,      64,     240,  -1,   50, 1 },  -- gsub 4 t=1278
        {   10,   5,      96,     240,  -1,   50, 1 },  -- gsub 5 t=1288
        {   10,   6,     128,     240,  -1,   50, 1 },  -- gsub 6 t=1298
        {    7,   6,    -160,     240,  -1,  150, 0 },  -- gsub 6 t=1305
        {    7,   3,    -128,     240,  -1,   50, 0 },  -- gsub 3 t=1312
        {    7,   6,     -96,     240,  -1,  150, 0 },  -- gsub 6 t=1319
        {    7,   3,     160,     240,  -1,   50, 1 },  -- gsub 3 t=1326
        {    7,   6,     128,     240,  -1,  150, 1 },  -- gsub 6 t=1333
        {    7,   3,      96,     240,  -1,   50, 1 },  -- gsub 3 t=1340
        {   20,   4,     -32,     240,  -1,   50, 0 },  -- gsub 4 t=1360
        {   10,   5,     -64,     240,  -1,   50, 0 },  -- gsub 5 t=1370
        {   10,   6,    -112,     240,  -1,   50, 0 },  -- gsub 6 t=1380
        {   20,   4,      32,     240,  -1,   50, 1 },  -- gsub 4 t=1400
        {   10,   5,      64,     240,  -1,   50, 1 },  -- gsub 5 t=1410
        {   10,   6,     112,     240,  -1,   50, 1 },  -- gsub 6 t=1420
        {    7,   4,    -160,     240,  -1,   50, 0 },  -- gsub 4 t=1427
        {    7,   5,    -128,     240,  -1,   50, 0 },  -- gsub 5 t=1434
        {    7,   6,     -96,     240,  -1,   50, 0 },  -- gsub 6 t=1441
        {    7,   4,     160,     240,  -1,   50, 1 },  -- gsub 4 t=1448
        {    7,   5,     128,     240,  -1,   50, 1 },  -- gsub 5 t=1455
        {    7,   6,      96,     240,  -1,   50, 1 },  -- gsub 6 t=1462
        {    6,   3,    -142,     240,  -1,   50, 0 },  -- gsub 3 t=1468
        {    0,   3,     142,     240,  -1,   50, 1 },  -- gsub 3 t=1468
        {    6,   3,    -112,     240,  -1,   50, 0 },  -- gsub 3 t=1474
        {    0,   3,     112,     240,  -1,   50, 1 },  -- gsub 3 t=1474
        {    6,   3,     -52,     240,  -1,   50, 0 },  -- gsub 3 t=1480
        {    0,   3,      52,     240,  -1,   50, 1 },  -- gsub 3 t=1480
        {    6,   3,    -162,     240,  -1,   50, 0 },  -- gsub 3 t=1486
        {    0,   3,     162,     240,  -1,   50, 1 },  -- gsub 3 t=1486
        {    6,   3,     -72,     240,  -1,   50, 0 },  -- gsub 3 t=1492
        {    0,   3,      72,     240,  -1,   50, 1 },  -- gsub 3 t=1492
        {    6,   3,     -32,     240,  -1,   50, 0 },  -- gsub 3 t=1498
        {    0,   3,      32,     240,  -1,   50, 1 },  -- gsub 3 t=1498
        {    6,   3,    -152,     240,  -1,   50, 0 },  -- gsub 3 t=1504
        {    0,   3,     152,     240,  -1,   50, 1 },  -- gsub 3 t=1504
        {    6,   3,    -112,     240,  -1,   50, 0 },  -- gsub 3 t=1510
        {    0,   3,     112,     240,  -1,   50, 1 },  -- gsub 3 t=1510
        {    6,   3,    -142,     240,  -1,   50, 0 },  -- gsub 3 t=1516
        {    0,   3,     142,     240,  -1,   50, 1 },  -- gsub 3 t=1516
        {    6,   3,    -112,     240,  -1,   50, 0 },  -- gsub 3 t=1522
        {    0,   3,     112,     240,  -1,   50, 1 },  -- gsub 3 t=1522
        {    6,   3,     -52,     240,  -1,   50, 0 },  -- gsub 3 t=1528
        {    0,   3,      52,     240,  -1,   50, 1 },  -- gsub 3 t=1528
        {    6,   3,    -162,     240,  -1,   50, 0 },  -- gsub 3 t=1534
        {    0,   3,     162,     240,  -1,   50, 1 },  -- gsub 3 t=1534
        {    6,   3,     -72,     240,  -1,   50, 0 },  -- gsub 3 t=1540
        {    0,   3,      72,     240,  -1,   50, 1 },  -- gsub 3 t=1540
        {    6,   3,     -32,     240,   2,   50, 0 },  -- gsub 3 t=1546
        {    0,   3,      32,     240,   2,   50, 1 },  -- gsub 3 t=1546
        {    6,   3,    -152,     240,   2,   50, 0 },  -- gsub 3 t=1552
        {    0,   3,     152,     240,   2,   50, 1 },  -- gsub 3 t=1552
        {    6,   3,    -112,     240,   2,   50, 0 },  -- gsub 3 t=1558
        {    0,   3,     112,     240,   2,   50, 1 },  -- gsub 3 t=1558
        {  307,   3,    -142,     240,  -1,   30, 0 },  -- gsub 3 t=1865
        {    0,   3,     142,     240,  -1,   30, 1 },  -- gsub 3 t=1865
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=1871
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=1871
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=1877
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=1877
        {    6,   3,    -162,     240,  -1,   30, 0 },  -- gsub 3 t=1883
        {    0,   3,     162,     240,  -1,   30, 1 },  -- gsub 3 t=1883
        {    6,   3,     -72,     240,  -1,   30, 0 },  -- gsub 3 t=1889
        {    0,   3,      72,     240,  -1,   30, 1 },  -- gsub 3 t=1889
        {    6,   3,     -32,     240,  -1,   30, 0 },  -- gsub 3 t=1895
        {    0,   3,      32,     240,  -1,   30, 1 },  -- gsub 3 t=1895
        {    6,   3,    -152,     240,  -1,   30, 0 },  -- gsub 3 t=1901
        {    0,   3,     152,     240,  -1,   30, 1 },  -- gsub 3 t=1901
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=1907
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=1907
        {    6,   3,    -142,     240,  -1,   30, 0 },  -- gsub 3 t=1913
        {    0,   3,     142,     240,  -1,   30, 1 },  -- gsub 3 t=1913
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=1919
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=1919
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=1925
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=1925
        {    6,   5,    -162,     240,  -1,   30, 0 },  -- gsub 5 t=1931
        {    0,   5,     162,     240,  -1,   30, 1 },  -- gsub 5 t=1931
        {    6,   5,     -72,     240,  -1,   30, 0 },  -- gsub 5 t=1937
        {    0,   5,      72,     240,  -1,   30, 1 },  -- gsub 5 t=1937
        {    0,   7,    -208,     160,  -2,  500, 0 },  -- gsub 7 t=1937
        {    0,   6,    -160,     240,  -1,   50, 0 },  -- gsub 6 t=1937
        {    0,   6,    -128,     240,  -1,   50, 0 },  -- gsub 6 t=1937
        {    0,   6,     128,     240,  -1,   50, 0 },  -- gsub 6 t=1937
        {    0,   6,     160,     240,  -1,   50, 0 },  -- gsub 6 t=1937
        {  120,   3,    -160,     240,  -1,   30, 0 },  -- gsub 3 t=2057
        {    7,   3,    -128,     240,  -1,   30, 0 },  -- gsub 3 t=2064
        {    7,   3,     -96,     240,  -1,   30, 0 },  -- gsub 3 t=2071
        {   60,   5,    -142,     240,  -1,   30, 0 },  -- gsub 5 t=2131
        {    0,   5,     142,     240,  -1,   30, 1 },  -- gsub 5 t=2131
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=2137
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=2137
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=2143
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=2143
        {    6,   3,    -162,     240,  -1,   30, 0 },  -- gsub 3 t=2149
        {    0,   3,     162,     240,  -1,   30, 1 },  -- gsub 3 t=2149
        {    6,   3,     -72,     240,  -1,   30, 0 },  -- gsub 3 t=2155
        {    0,   3,      72,     240,  -1,   30, 1 },  -- gsub 3 t=2155
        {    6,   3,     -32,     240,  -1,   30, 0 },  -- gsub 3 t=2161
        {    0,   3,      32,     240,  -1,   30, 1 },  -- gsub 3 t=2161
        {    6,   3,    -152,     240,  -1,   30, 0 },  -- gsub 3 t=2167
        {    0,   5,     152,     240,  -1,   30, 1 },  -- gsub 5 t=2167
        {    6,   5,    -112,     240,  -1,   30, 0 },  -- gsub 5 t=2173
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=2173
        {    6,   3,    -142,     240,  -1,   30, 0 },  -- gsub 3 t=2179
        {    0,   3,     142,     240,  -1,   30, 1 },  -- gsub 3 t=2179
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=2185
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=2185
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=2191
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=2191
        {    6,   3,    -162,     240,  -1,   30, 0 },  -- gsub 3 t=2197
        {    0,   5,     162,     240,  -1,   30, 1 },  -- gsub 5 t=2197
        {    6,   5,     -72,     240,  -1,   30, 0 },  -- gsub 5 t=2203
        {    0,   3,      72,     240,  -1,   30, 1 },  -- gsub 3 t=2203
        {    0,   8,     208,     160,  -2,  500, 0 },  -- gsub 8 t=2203
        {    0,   6,    -112,     240,  -1,   50, 0 },  -- gsub 6 t=2203
        {    0,   6,     -64,     240,  -1,   50, 0 },  -- gsub 6 t=2203
        {    0,   6,      64,     240,  -1,   50, 0 },  -- gsub 6 t=2203
        {    0,   6,     112,     240,  -1,   50, 0 },  -- gsub 6 t=2203
        {  120,   3,     160,     240,  -1,   50, 1 },  -- gsub 3 t=2323
        {    7,   3,     128,     240,  -1,   50, 1 },  -- gsub 3 t=2330
        {    7,   3,      96,     240,  -1,   50, 1 },  -- gsub 3 t=2337
        {    6,   5,    -112,     240,  -1,   30, 0 },  -- gsub 5 t=2343
        {    0,   5,     112,     240,  -1,   30, 1 },  -- gsub 5 t=2343
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=2349
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=2349
        {    6,   3,    -162,     240,  -1,   30, 0 },  -- gsub 3 t=2355
        {    0,   3,     162,     240,  -1,   30, 1 },  -- gsub 3 t=2355
        {    6,   3,     -72,     240,  -1,   30, 0 },  -- gsub 3 t=2361
        {    0,   3,      72,     240,  -1,   30, 1 },  -- gsub 3 t=2361
        {    6,   5,     -32,     240,  -1,   30, 0 },  -- gsub 5 t=2367
        {    0,   5,      32,     240,  -1,   30, 1 },  -- gsub 5 t=2367
        {    6,   3,    -152,     240,  -1,   30, 0 },  -- gsub 3 t=2373
        {    0,   3,     152,     240,  -1,   30, 1 },  -- gsub 3 t=2373
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=2379
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=2379
        {    6,   3,    -142,     240,  -1,   30, 0 },  -- gsub 3 t=2385
        {    0,   3,     142,     240,  -1,   30, 1 },  -- gsub 3 t=2385
        {    6,   5,    -112,     240,  -1,   30, 0 },  -- gsub 5 t=2391
        {    0,   5,     112,     240,  -1,   30, 1 },  -- gsub 5 t=2391
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=2397
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=2397
        {    6,   3,    -162,     240,  -1,   30, 0 },  -- gsub 3 t=2403
        {    0,   3,     162,     240,  -1,   30, 1 },  -- gsub 3 t=2403
        {    6,   3,     -72,     240,  -1,   30, 0 },  -- gsub 3 t=2409
        {    0,   3,      72,     240,  -1,   30, 1 },  -- gsub 3 t=2409
        {    0,   9,    -208,     160,  -2,  500, 0 },  -- gsub 9 t=2409
        {    0,   6,    -176,     240,  -1,   50, 0 },  -- gsub 6 t=2409
        {    0,   6,    -128,     240,  -1,   50, 0 },  -- gsub 6 t=2409
        {    0,   6,     -80,     240,  -1,   50, 0 },  -- gsub 6 t=2409
        {    0,   6,     -32,     240,  -1,   50, 0 },  -- gsub 6 t=2409
        {   60,   3,    -160,     240,  -1,   50, 0 },  -- gsub 3 t=2469
        {    7,   3,    -128,     240,  -1,   50, 0 },  -- gsub 3 t=2476
        {    7,   3,     -96,     240,  -1,   50, 0 },  -- gsub 3 t=2483
        {    6,   5,    -112,     240,  -1,   30, 0 },  -- gsub 5 t=2489
        {    0,   5,     112,     240,  -1,   30, 1 },  -- gsub 5 t=2489
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=2495
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=2495
        {    6,   3,    -162,     240,  -1,   30, 0 },  -- gsub 3 t=2501
        {    0,   3,     162,     240,  -1,   30, 1 },  -- gsub 3 t=2501
        {    6,   5,     -72,     240,  -1,   30, 0 },  -- gsub 5 t=2507
        {    0,   5,      72,     240,  -1,   30, 1 },  -- gsub 5 t=2507
        {    6,   3,     -32,     240,  -1,   30, 0 },  -- gsub 3 t=2513
        {    0,   3,      32,     240,  -1,   30, 1 },  -- gsub 3 t=2513
        {    6,   3,    -152,     240,  -1,   30, 0 },  -- gsub 3 t=2519
        {    0,   3,     152,     240,  -1,   30, 1 },  -- gsub 3 t=2519
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=2525
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=2525
        {    6,   5,    -142,     240,  -1,   30, 0 },  -- gsub 5 t=2531
        {    0,   5,     142,     240,  -1,   30, 1 },  -- gsub 5 t=2531
        {    6,   3,    -112,     240,  -1,   30, 0 },  -- gsub 3 t=2537
        {    0,   3,     112,     240,  -1,   30, 1 },  -- gsub 3 t=2537
        {    6,   3,     -52,     240,  -1,   30, 0 },  -- gsub 3 t=2543
        {    0,   3,      52,     240,  -1,   30, 1 },  -- gsub 3 t=2543
        {    6,   3,    -162,     240,  -1,   30, 0 },  -- gsub 3 t=2549
        {    0,   3,     162,     240,  -1,   30, 1 },  -- gsub 3 t=2549
        {    6,   5,     -72,     240,  -1,   30, 0 },  -- gsub 5 t=2555
        {    0,   5,      72,     240,  -1,   30, 1 },  -- gsub 5 t=2555
        {    0,  11,     208,     160,  -2,  500, 0 },  -- gsub 11 t=2555
        {    0,   6,     176,     240,  -1,   50, 0 },  -- gsub 6 t=2555
        {    0,   6,     128,     240,  -1,   50, 0 },  -- gsub 6 t=2555
        {    0,   6,      80,     240,  -1,   50, 0 },  -- gsub 6 t=2555
        {    0,   6,      32,     240,  -1,   50, 0 },  -- gsub 6 t=2555
        {   60,   5,    -160,     240,  -1,   50, 0 },  -- gsub 5 t=2615
        {    7,   5,    -128,     240,  -1,   50, 0 },  -- gsub 5 t=2622
        {    7,   5,     -96,     240,  -1,   50, 0 },  -- gsub 5 t=2629
        {    0,  12,    -208,     160,  -2,  500, 0 },  -- gsub 12 t=2629
        {   60,   5,     160,     240,  -1,   50, 1 },  -- gsub 5 t=2689
        {    7,   5,     128,     240,  -1,   50, 1 },  -- gsub 5 t=2696
        {    7,   5,      96,     240,  -1,   50, 1 },  -- gsub 5 t=2703
        {   60,   7,    -208,     208,  -2,  400, 0 },  -- gsub 7 t=2763
        {   60,   8,     208,     176,  -2,  400, 0 },  -- gsub 8 t=2823
        {   60,   9,    -208,      96,  -2,  400, 0 },  -- gsub 9 t=2883
        {   60,  11,     208,      64,  -2,  400, 0 },  -- gsub 11 t=2943
        {   60,   6,    -176,     240,  -1,   50, 0 },  -- gsub 6 t=3003
        {    0,   6,    -128,     240,  -1,  150, 0 },  -- gsub 6 t=3003
        {    0,   6,     -80,     240,  -1,   50, 0 },  -- gsub 6 t=3003
        {    0,   6,     -32,     240,  -1,  150, 0 },  -- gsub 6 t=3003
        {    0,   6,     176,     240,  -1,   50, 0 },  -- gsub 6 t=3003
        {    0,   6,     128,     240,  -1,  150, 0 },  -- gsub 6 t=3003
        {    0,   6,      80,     240,  -1,   50, 0 },  -- gsub 6 t=3003
        {    0,   6,      32,     240,  -1,  150, 0 },  -- gsub 6 t=3003
        {   10,   6,    -160,     240,  -1,  150, 0 },  -- gsub 6 t=3013
        {    0,   6,    -112,     240,  -1,   50, 0 },  -- gsub 6 t=3013
        {    0,   6,     -64,     240,  -1,  150, 0 },  -- gsub 6 t=3013
        {    0,   6,       0,     240,  -1,   50, 0 },  -- gsub 6 t=3013
        {    0,   6,     160,     240,  -1,  150, 0 },  -- gsub 6 t=3013
        {    0,   6,     112,     240,  -1,   50, 0 },  -- gsub 6 t=3013
        {    0,   6,      64,     240,  -1,  150, 0 },  -- gsub 6 t=3013
        {   10,   6,    -176,     240,  -1,   50, 0 },  -- gsub 6 t=3023
        {    0,   6,    -128,     240,  -1,  150, 0 },  -- gsub 6 t=3023
        {    0,   6,     -80,     240,  -1,   50, 0 },  -- gsub 6 t=3023
        {    0,   6,     -32,     240,  -1,  150, 0 },  -- gsub 6 t=3023
        {    0,   6,     176,     240,  -1,   50, 0 },  -- gsub 6 t=3023
        {    0,   6,     128,     240,  -1,  150, 0 },  -- gsub 6 t=3023
        {    0,   6,      80,     240,  -1,   50, 0 },  -- gsub 6 t=3023
        {    0,   6,      32,     240,  -1,  150, 0 },  -- gsub 6 t=3023
    }

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        ---耐久卡：不打超时音、关掉本体的判定与血条（照上面两张卡）
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        pool4 = {}
        sound_tick4, sound_stamp4 = 0, -1
        task.New(self, function()
            for _, w in ipairs(WAVE3) do
                task.Wait(w[1])
                local sub = w[2]
                if sub <= 6 then
                    New(class["TH34_walker3"], w[3], w[4], w[6], sub, w[7])
                else
                    New(class["TH34_bigghost3"], w[3], w[4], w[6], sub)
                end
            end
        end)
    end
    function card:frame()
        sound_tick4 = sound_tick4 + 1
    end
    function card:render() end
    ---★ 不用清理：所有小怪都是独立对象（没有 object.Connect 到 boss），
    ---寿命最长的 sub 11 大幽灵 t=7213 自毁，在 130 秒（7800 帧）内跑完。
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end

---==================== 第 5 面道中：代码 ====================
---自然语言说明与逐条差异都在文件头的「第 5 面道中」单元里。
---和其它三张道中卡一样：空 boss + 一张耐久符卡，逐帧把 `ecldata5.ecl` 时间轴 0
---（偏移 0xAEA8）t=500..5713 的 94 条 spawn 搬进来。
---原作每条 spawn 放出来的是「载体」：载体先演 80 帧烟尘（sub 9）、第 80 帧在
---原地生出真正的幽灵（sub 11/13/…/36）后自毁；移植版把这两段**合成一个对象**
---（第 80 帧换贴图、开判定，差异 34）。时间轴直接放的 sub 22/23/24 没有载体、
---也不带烟尘，照做。

---第 5 面非 boss 的血量折算（差异 32）：life × 0.1965，保底 1 点。
---0.1965 = 灵梦 DPS 比 106.4 / 541.5，也就是「第 5/6 面非 boss 的伤害 ÷2」那一档
---（EnemyManager.cpp:820-845）；第 3/4 面在同一套折算里再乘各自系数
---（hp3 = 0.1965 × 0.5/1.0、hp4 = 0.1965 × 0.5/0.6875）。
---⇒ 80→16、110→22、160→31、200→39。
local function hp5(life)
    return max(1, int(life * 0.1965 + 0.5))
end

---th07 的角度（弧度、y 朝下）折成我们的角度制（y 朝上）：取反即可。
local function a5(th)
    return -th * RAD2DEG
end

---原作 sprite 1/3/6 → 代理弹型（差异 20）：1 = grain_a、3 = ball_small、6 = arrow_small；
---spriteOffset(1..16) 同号映射到 col16()（第 3 面那一段的 COL16）。
local function p5_style(spr)
    if spr == 6 then
        return arrow_small
    end
    if spr == 3 then
        return ball_small
    end
    return grain_a
end

---烟尘 / 本体贴图（差异 34）：原作载体的 sub 9 是 SET_ANM 30（黄焰 `ghost_fire_y`
---+ 叠 Ghost4 的 8 帧本体）、本体 sub 11 起是 SET_ANM 27（红焰 `ghost_fire_r`，
---不再叠本体）—— 直接沿用本仓库 style 27/30 的渲染（WalkImageSystem.lua:325-340/367）。
local P5_DUST_STYLE, P5_BODY_STYLE = 30, 27
local P5_DUST_FRAMES = 80
---烟尘的起终点：原作 t=0 把 (POS_X−3, POS_Y+147) 和 (POS_X, POS_Y) 快照进两条
---INIT_INTERP（`EclManager.cpp:1070`）。th07 y 朝下 ⇒ 我们 224−y，所以起点的
---y 偏移是 **−147**；X 的 m0/m1 各 ±144、Y 的 m0 = +1（⇒ −1）、m1 = ±32。
local P5_DUST_X0, P5_DUST_Y0 = -3, -147
local P5_DUST_M = 144
local P5_DUST_Y_M0, P5_DUST_Y_M1 = -1, 32
local P5_DUST_FADE = 16
local P5_ACCEL = 0.02             -- 原作 SET_MOVE_ACCEL 0.02（匀加速，不是匀速）

---INIT_BULLET_CMD 的 Burst（type 1，`BulletManager.cpp:724-741`）：前 17 帧速度
---= 5 − timer·5/16 + 自身速度、沿自己的朝向，之后回到自身速度并清位。
---★ enemy 的 `bulletProps` **只在出生时重置一次**（`EnemyManager.cpp:401`，另一次是
---callbacks 前 `:1033`），INIT_BULLET_CMD 写进 `commands[0]` 的东西会**一直留着** ——
---所以 sub 11/13 的 22 轮、sub 26/28/30 的 32 轮**每一轮**都带 Burst。
---sub 32/34/36 的 flags 是 0x205（不含 bit 1）⇒ `RunCommands` 当场跳过（差异 33），
---所以那一族干脆不挂命令。
local P5_BURST = { type = 1 }

---0x20 TargetAngle（`BulletManager.cpp:759-777`）：每帧 angle += cmd.angle、speed += cmd.speed，
---重新按（朝向, 速度）算 velocity，够 duration(60) 帧清位。传进来的是 th07 的
---弧度/帧 ⇒ 取反并换成度/帧（y 翻转，角速度跟着反号）。
local function spin5(rate_th)
    return { type = 0x20, dur = 60, loop = -1, speed = 0, angle = -rate_th * RAD2DEG }
end

---th07 的极坐标偏移 (R·sin a, R·cos a)（y 朝下）⇒ 我们的 (R·sin a, −R·cos a)。
local function off5(a_th, r)
    local d = a_th * RAD2DEG
    return r * sin(d), -r * cos(d)
end

---shootOffset 那一点到自机的角。原作 `AngleToPlayer(&bulletProps->pos)` 用的是
---**偏移点**（`bulletProps->pos = enemy->pos + shootOffset`），不是敌人中心。
local function aim5(x, y)
    return atan2(player.y - y, player.x - x) * RAD2DEG
end

---本卡的一次「波」：把弹登记进 pool4（丢弹规则与上一张卡一致：池满整波不生、
---半途见底丢剩下的、两条路径都响音效）。`cmd` 非空 ⇒ 走 TH34_cmdbullet。
local function volley5(self, ox, oy, total, gen)
    local room = POOL4_SIZE - pool4_used()
    local i = 1
    while i <= total and room > 0 do
        local style, col, v, a, cmd = gen(i)
        if cmd then
            pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], style, col,
                                    self.x + ox, self.y + oy, v, a, cmd)
        else
            pool4[#pool4 + 1] = NewSimpleBullet(style, col, self.x + ox, self.y + oy,
                                                v, a, false, 0, false)
        end
        room, i = room - 1, i + 1
    end
    sound4(self)
end

---SPREAD（op64/65，`BulletManager.cpp:180-202`）：base 是**我们**的基准角（度），
---a2_th 是 th07 的弧度（spread3 内部取反）。层序只改速度、不改角度（与 RING 不同）。
local function w5_spread(self, spr, off, c1, c2, v1, v2, base, a2_th, ox, oy, cmd)
    local offs = spread3(c1, a2_th * RAD2DEG)
    volley5(self, ox, oy, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        local v = (c2 == 1) and v1 or (v1 - (v1 - v2) * layer / c2)
        return p5_style(spr), col16(off), v, base + offs[ring + 1], cmd
    end)
end

---RING_ABS（op67）：angle = 环序·2π/c1 + 层序·a2 + a1（a1 是绝对值，不瞄自机）。
---环序那一项是整圈，取反与否是同一个集合；层序那一项要取反。
local function w5_ring(self, spr, off, c1, c2, v1, v2, base, a2_th, cmd)
    local step = 360 / c1
    local a2 = -a2_th * RAD2DEG
    volley5(self, 0, 0, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        local v = (c2 == 1) and v1 or (v1 - (v1 - v2) * layer / c2)
        return p5_style(spr), col16(off), v, base + ring * step + layer * a2, cmd
    end)
end

---──────────────────── 各 sub 的发弹脚本（全部照 Lunatic 行） ────────────────────

---sub 11/13：一圈 11 发，每 10 帧把 $10004 转 ∓π/64 再打，共 22 轮（DEC_JUMP 在 t=10）。
---a0/da 是 th07 弧度：11 从 π 往减、13 从 0 往加；两者都不瞄自机。
local function p5_f11(self, a0, da, v1)
    local a = a0
    for _ = 1, 22 do
        a = a + da
        w5_ring(self, 6, 2, 11, 1, v1, 1.3, a5(a), 1.5708, P5_BURST)
        task.Wait(10)
    end
end

---sub 15/17/19/21：瞄准自机的 5 发扇（a1 = ANGLE_TO_PLAYER、a2 = 各自的张角），
---每 4 帧一轮、速度每轮 +dv（首轮 0.8）。DEC_JUMP 的落点在 SPREAD 上 ⇒ 先打后加。
local function p5_f15(self, n, dv, a2_th)
    local v = 0.8
    for _ = 1, n do
        w5_spread(self, 1, 6, 5, 1, v, 1, Angle(self, player), a2_th, 0, 0, nil)
        v = v + dv
        task.Wait(4)
    end
end

---sub 22：t=60 的三连扇。第 ①条没有命令（INIT_BULLET_CMD 排在它后面才写），
---②③条各挂 ±0.25°/帧、60 帧的自旋（flags 0x222 含 bit 5 ⇒ 命令生效；
---① 的 0x202 不含 ⇒ 就算挂着也会被跳过）。
local function p5_f22(self)
    local aim = Angle(self, player)
    w5_spread(self, 3, 2, 3, 3, 2.4, 1, aim,      0,         0, 0, nil)
    w5_spread(self, 3, 2, 3, 3, 3,   1, aim + 45, -0.392699, 0, 0, spin5(0.00436332))
    w5_spread(self, 3, 2, 3, 3, 3,   1, aim - 45,  0.392699, 0, 0, spin5(-0.00436332))
end

---sub 23/24：t=60 的六连扇 —— 前三条 spr6/off2 张角 π/8、后三条 spr6/off14 张角 π/4；
---两条各三个方向（a1 = π/2、π/4、3π/4），①④没有命令、②⑤与③⑥各挂反向自旋。
---（④ 的 flags 是 0x202：就算 ③ 写的命令还在，也会被 flag 门挡掉。）
local function p5_f23(self)
    w5_spread(self, 6, 2,  5, 5, 3,   1, a5(1.5708),   0.392699, 0, 0, nil)
    w5_spread(self, 6, 2,  3, 5, 2.8, 1, a5(0.785398), 0.392699, 0, 0, spin5(0.01309))
    w5_spread(self, 6, 2,  3, 5, 2.8, 1, a5(2.356194), 0.392699, 0, 0, spin5(-0.01309))
    w5_spread(self, 6, 14, 3, 4, 2.4, 1, a5(1.5708),   0.785398, 0, 0, nil)
    w5_spread(self, 6, 14, 3, 4, 2.4, 1, a5(0),        0.785398, 0, 0, spin5(0.0261799))
    w5_spread(self, 6, 14, 3, 4, 2.4, 1, a5(3.14159),  0.785398, 0, 0, spin5(-0.0261799))
end

---sub 26/28：32 轮、每 4 帧一轮；$10004 从 π/2 起每轮 ∓ π/16，极坐标偏移半径 32，
---弹一律瞄**偏移点**的自机角（SPREAD_AIMED、a1=0）。da = ∓0.19635。
local function p5_f26(self, da, off)
    local a = 1.5708
    for _ = 1, 32 do
        a = a + da
        local ox, oy = off5(a, 32)
        w5_spread(self, 1, off, 3, 4, 4.2, 1, aim5(self.x + ox, self.y + oy),
                  0.0785398, ox, oy, P5_BURST)
        task.Wait(4)
    end
end

---sub 30：16 轮 × 2 发（t=0 用 $10004 从 −π/2 往减、t=2 用 $10009 从 −π/2 往加），
---偏移半径 32、v1 = 2、aimed。DEC_JUMP 在 t=4。
local function p5_f30(self)
    local a, b = -1.5708, -1.5708
    for _ = 1, 16 do
        a = a - 0.19635
        local ox, oy = off5(a, 32)
        w5_spread(self, 1, 8, 3, 4, 2, 1, aim5(self.x + ox, self.y + oy),
                  0.0785398, ox, oy, P5_BURST)
        task.Wait(2)
        b = b + 0.19635
        ox, oy = off5(b, 32)
        w5_spread(self, 1, 8, 3, 4, 2, 1, aim5(self.x + ox, self.y + oy),
                  0.0785398, ox, oy, P5_BURST)
        task.Wait(2)
    end
end

---sub 32/34：32 轮、每 1 帧一轮；偏移半径 32，一个方向 4 发（a1 = $10004 绝对值）。
---flags 0x205 ⇒ Burst 被跳过，所以不带命令。
local function p5_f32(self, off)
    local a = 1.5708
    for _ = 1, 32 do
        a = a - 0.19635
        local ox, oy = off5(a, 32)
        w5_spread(self, 6, off, 4, 1, 1.2, 1, a5(a), 0.785398, ox, oy, nil)
        task.Wait(1)
    end
end

---sub 36：16 轮 × 2 发（t=0 用 $10004、t=1 用 $10009 做偏移），偏移半径 64；
---两条的 a1 都是 $10004（同一个值），spr3。
local function p5_f36(self)
    local a, b = -1.5708, -1.5708
    for _ = 1, 16 do
        a = a - 0.19635
        local ox, oy = off5(a, 64)
        w5_spread(self, 3, 2, 4, 1, 1, 1, a5(a), 0.785398, ox, oy, nil)
        task.Wait(1)
        b = b + 0.19635
        ox, oy = off5(b, 64)
        w5_spread(self, 3, 6, 4, 1, 1, 1, a5(a), 0.785398, ox, oy, nil)
        task.Wait(1)
    end
end

---──────────────────── 道中幽灵（载体烟尘 + 本体，合成一个对象） ────────────────────
---生命周期的两个阶段写在协程里：前 80 帧只有烟尘（由 frame 里的 Hermite 驱动），
---第 80 帧换贴图、开判定、起无敌计时，然后跑本体的发弹脚本。
class["TH34_mid5"] = Class(enemy, {
    ---@param life number 时间轴的 life（折 HP 见 hp5）
    ---@param sub number 本体子程序号 11/13/15/…/36
    ---@param mirror number 时间轴 op2/3 的镜像位（只有 sub 22 用得到）
    ---@param drop number 时间轴的 itemdrop（0=小能量、1=点、2=大能量）
    init = function(self, x, y, life, sub, mirror, drop)
        local dust = (sub ~= 22 and sub ~= 23 and sub ~= 24)
        ---nontaijutsu = true（原作 SET_HAS_CONTACT_HITBOX 0）：能被打、碰到自机不掉血。
        enemy.init(self, dust and P5_DUST_STYLE or P5_BODY_STYLE, hp5(life), false, true, true)
        self.x, self.y = x, y
        self.hx, self.hy = x, y
        self.sub, self.mirror, self.dr = sub, mirror or 0, drop
        self.delay = dust and P5_DUST_FRAMES or 0
        self.phase = dust and 0 or 1
        ---★ 第一帧 frame 就会读这些，先在**顶层**给默认值（分支里再覆盖）。
        self.A, self.B = 24, 24
        self.dive_t, self.t_move = 0, 0
        self.ddx, self.ddy = 0, 0
        self.spd, self.accel, self.dir = 0, P5_ACCEL, 0
        self.protect, self.colli = true, false
        self.invul = 0
        self.cb = 6
        ---烟尘两条 Hermite 的常量（原作 t=0 求值一次后冻结）
        self.px0, self.py0 = P5_DUST_X0, P5_DUST_Y0
        self.pmx0, self.pmx1 = rnd_sign() * P5_DUST_M, rnd_sign() * P5_DUST_M
        self.pmy0, self.pmy1 = P5_DUST_Y_M0, rnd_sign() * P5_DUST_Y_M1
        ---按 sub 分派移动 / 无敌 / 掉落回调（数值逐条对过 ECL 的 Lunatic 行）
        if sub <= 21 then
            ---MOVE_DIR_TIME(0,0,θ,0) + SET_MOVE_ACCEL 0.02：spawn 当帧起沿 θ 匀加速
            ---（11/15/19 的 θ=0 往 +x、13/17/21 的 θ=π 往 −x）。
            self.dir = ((sub == 11 or sub == 15 or sub == 19)) and 0 or 180
            self.invul = ((sub == 11 or sub == 13) and 10)
                      or ((sub == 15 or sub == 17) and 0) or 30
            self.cb = (sub == 11 or sub == 13) and 6 or 8
        elseif sub <= 24 then
            ---MOVE_DIR_TIME(60,4,π/2,2)：ease-out-quad 俯冲 120 px（t=0..59），
            ---t=120 改 POLAR：22 是 θ=0（镜像位把 x 反过来 ⇒ 往画面中间走）、
            ---23/24 是 θ=π/2（继续下潜）。accel 不写 ⇒ 0。
            self.dive_t, self.t_move = 60, 120
            self.ddy = -120
            self.spd, self.accel = 2, 0
            self.dir = (sub == 22) and ((self.mirror == 1) and 180 or 0) or -90
            self.invul = (sub == 23) and 40 or 30
            self.cb = 7
        else
            ---打完之后 t=4/61/122 的 MOVE_DIR_TIME(0,0,−π/2,0) + ACCEL 0.02 ⇒ 往上飞。
            self.t_move = (sub == 36) and 122 or ((sub == 32 or sub == 34) and 61 or 4)
            self.dir = 90
            self.invul = ((sub == 26 or sub == 28) and 20)
                      or ((sub == 32 or sub == 34) and 4) or 10
            self.cb = ((sub == 30 or sub == 36) and 8) or 6
        end
        ---烟尘阶段的拖影（原作 sub 9 的 SET_TRAIL 0x19,48,16,1）。
        self.img = "ghost_fire_y"
        if dust then
            smear_add(self, 120)
        end
        task.New(self, function()
            if self.delay > 0 then
                task.Wait(self.delay)
            end
            ---本体登场：换贴图（style 27 的 ghost_fire_r）、开判定、开无敌计时。
            self.phase = 1
            self._wisys:SetImage(P5_BODY_STYLE)
            self.img = "ghost_fire_r"
            self.smear = nil
            self.colli = true
            self.A, self.B = 24, 24
            self._a = 255
            if self.invul > 0 then
                task.New(self, function()
                    task.Wait(self.invul)
                    self.protect = false
                end)
            else
                self.protect = false
            end
            ---本体脚本（t 的零点就是本体的出生帧）
            if sub == 11 then
                p5_f11(self, PI, -0.0490874, 2.2)
            elseif sub == 13 then
                p5_f11(self, 0, 0.0490874, 2)
            elseif sub == 15 then
                p5_f15(self, 16, 0.475, 0.698132)
            elseif sub == 17 then
                p5_f15(self, 16, 0.475, 0.628319)
            elseif sub == 19 then
                p5_f15(self, 12, 0.375, 0.448799)
            elseif sub == 21 then
                p5_f15(self, 12, 0.375, 0.448799)
            elseif sub == 22 then
                task.Wait(60); p5_f22(self)
            elseif sub == 23 or sub == 24 then
                task.Wait(60); p5_f23(self)
            elseif sub == 26 then
                p5_f26(self, -0.19635, 2)
            elseif sub == 28 then
                p5_f26(self, 0.19635, 6)
            elseif sub == 30 then
                p5_f30(self)
            elseif sub == 32 then
                p5_f32(self, 2)
            elseif sub == 34 then
                p5_f32(self, 6)
            elseif sub == 36 then
                p5_f36(self)
            end
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        if self.phase == 0 then
            ---烟尘：位置直接由两条 Hermite 写（原作 INIT_INTERP 写 POS_X/POS_Y）。
            local t = min(self.timer, P5_DUST_FRAMES) / P5_DUST_FRAMES
            self.x = self.hx + hermite(t, self.px0, 0, self.pmx0, self.pmx1)
            self.y = self.hy + hermite(t, self.py0, 0, self.pmy0, self.pmy1)
            if self.timer > P5_DUST_FRAMES - P5_DUST_FADE then
                self._a = max(0, 255 * (P5_DUST_FRAMES - self.timer) / P5_DUST_FADE)
            end
            object.smear_frame(self, TRAIL_DECAY)
        else
            local bt = self.timer - self.delay
            if self.dive_t > 0 and bt <= self.dive_t then
                ---ENEMY_MOVE_INTERP 的 ease-out-quad：pos = 出生点 + e(u)·位移
                local u = min(bt, self.dive_t) / self.dive_t
                local e = 1 - (1 - u) * (1 - u)
                self.x = self.hx + self.ddx * e
                self.y = self.hy + self.ddy * e
            elseif bt >= self.t_move then
                ---ENEMY_MOVE_POLAR：speed += accel 后 velocity = speed·(cosθ, sinθ)；
                ---镜像位在 Enemy::Move 里把 velocity.x 取反（EnemyManager.hpp:79）。
                self.spd = self.spd + self.accel
                object.SetV(self, self.spd, self.dir, false)
            end
        end
    end,
    render = function(self)
        object.smear_render(self, "mul+add", { 200, 210, 255 })
        enemy.render(self)
    end,
    kill = function(self)
        ---时间轴的 itemdrop 照掉（差异 35）：原作 SET_DEATH_TYPE 1（SCORE_ONLY）
        ---用 `goto END_BOSS` **落进** DROP_ITEMS 分支（EnemyManager.cpp:968-983），
        ---所以 SCORE_ONLY 一样会 SpawnItem。0=小能量→1 信仰、1=点→1 点、2=大能量→2 信仰。
        if self.dr == 1 then
            New(item.obj.point, self.x, self.y)
        elseif self.dr == 2 then
            New(item.obj.faith, self.x, self.y)
            New(item.obj.faith, self.x, self.y)
        elseif self.dr == 0 then
            New(item.obj.faith, self.x, self.y)
        end
        ---再跑 SET_DEATH_CALLBACK_SUB：6 = 什么都不做、7 = 4 能量 + 3 点、8 = 4 能量 + 1 点。
        if self.cb == 7 then
            scatter_items(item.obj.faith, 4, self.x, self.y)
            scatter_items(item.obj.point, 3, self.x, self.y)
        elseif self.cb == 8 then
            scatter_items(item.obj.faith, 4, self.x, self.y)
            scatter_items(item.obj.point, 1, self.x, self.y)
        end
        enemy.kill(self)
    end,
})

---==================== 挂到空 boss 的第四张符卡 ====================
do
    local CARD_NAME = "五道中「幽明之径」"
    ---原作 t=500..5713（约 87 秒）；最晚一只 sub 36 的本体落在 5713+80 = 5793 帧、
    ---t=122 起飞、再飞约 120 帧出上边界 ⇒ 约 6035 帧收干净。给 120 秒余量。
    local CARD_TIME = 120
    local LEVEL = 32
    ---符卡历史槽位：本关（th34）自己的一段 3400..3407（按面序）；这张是第五面 ⇒ 3404。
    local CARD_ID = 3404

    ---逐条生成表：{ 距上一条的帧数, 本体子程序号, x, y, itemdrop, life, mirror }
    ---（x/y 已换算成我们的坐标；94 条全部用 /tmp/eclwork 的解释器逐值对过时间轴 0）。
    ---★ sub 是**本体**号（时间轴的载体号 = 本体号 − 1）；22/23/24 是时间轴直接放的，
    ---所以没有烟尘（见 init 里的 dust 判断）。时间轴的 sub 37（t=4820）和 sub 47
    ---（t=6114）是道中 boss 占位（SET_BOSS 0、score 200000、life 1），不搬（差异 36）。
    local WAVE5 = {
        {    0, 11,   -128,     96,   0,   80, 0 },  -- t=500 载体 10
        {   10, 11,   -112,    112,   0,   80, 0 },  -- t=510 载体 10
        {   10, 11,    -96,    120,   1,   80, 0 },  -- t=520 载体 10
        {  380, 13,    128,    112,   0,   80, 0 },  -- t=900 载体 12
        {   10, 13,    112,    128,   0,   80, 0 },  -- t=910 载体 12
        {   10, 13,     96,    144,   1,   80, 0 },  -- t=920 载体 12
        {   10, 13,     64,    160,   1,   80, 0 },  -- t=930 载体 12
        {  100, 11,   -160,     96,   2,   80, 0 },  -- t=1030 载体 10
        {   10, 11,   -144,    112,   0,   80, 0 },  -- t=1040 载体 10
        {   10, 11,   -128,    120,   0,   80, 0 },  -- t=1050 载体 10
        {   10, 11,   -112,    128,   1,   80, 0 },  -- t=1060 载体 10
        {   10, 11,    -96,    136,   1,   80, 0 },  -- t=1070 载体 10
        {  200, 17,    128,    128,   1,   80, 0 },  -- t=1270 载体 16
        {  100, 15,   -128,     96,   1,   80, 0 },  -- t=1370 载体 14
        {  100, 15,    -96,    160,   1,   80, 0 },  -- t=1470 载体 14
        {  100, 13,    128,    112,   1,   80, 0 },  -- t=1570 载体 12
        {   10, 13,    112,    128,   1,   80, 0 },  -- t=1580 载体 12
        {   10, 13,     96,    144,   1,   80, 0 },  -- t=1590 载体 12
        {   10, 13,     64,    160,   1,   80, 0 },  -- t=1600 载体 12
        {  200, 21,    128,    128,   1,   80, 0 },  -- t=1800 载体 20
        {   10, 11,   -128,    112,   0,   80, 0 },  -- t=1810 载体 10
        {   30, 19,   -128,     96,   1,   80, 0 },  -- t=1840 载体 18
        {   10, 13,    112,    128,   0,   80, 0 },  -- t=1850 载体 12
        {   30, 21,     96,    160,   1,   80, 0 },  -- t=1880 载体 20
        {   10, 11,    -96,    144,   0,   80, 0 },  -- t=1890 载体 10
        {   30, 19,   -128,     96,   1,   80, 0 },  -- t=1920 载体 18
        {   10, 13,     64,    160,   0,   80, 0 },  -- t=1930 载体 12
        {   60, 13,    128,    128,   1,   80, 0 },  -- t=1990 载体 12
        {   10, 11,   -128,    112,   0,   80, 0 },  -- t=2000 载体 10
        {   30, 11,   -128,     96,   1,   80, 0 },  -- t=2030 载体 10
        {   10, 13,    112,    128,   0,   80, 0 },  -- t=2040 载体 12
        {   30, 13,     96,    160,   1,   80, 0 },  -- t=2070 载体 12
        {   10, 11,    -96,    144,   0,   80, 0 },  -- t=2080 载体 10
        {   30, 11,   -128,     96,   1,   80, 0 },  -- t=2110 载体 10
        {   10, 13,     64,    160,   0,   80, 0 },  -- t=2120 载体 12
        {   60, 21,    128,    128,   1,   80, 0 },  -- t=2180 载体 20
        {   10, 11,   -128,    112,   0,   80, 0 },  -- t=2190 载体 10
        {   30, 19,   -128,     96,   1,   80, 0 },  -- t=2220 载体 18
        {   10, 13,    112,    128,   0,   80, 0 },  -- t=2230 载体 12
        {   30, 17,     96,    160,   1,   80, 0 },  -- t=2260 载体 16
        {   10, 11,    -96,    144,   0,   80, 0 },  -- t=2270 载体 10
        {   30, 15,   -128,     96,   1,   80, 0 },  -- t=2300 载体 14
        {   10, 13,     64,    160,   0,   80, 0 },  -- t=2310 载体 12
        {  300, 22,    128,    240,   1,  160, 1 },  -- t=2610 载体 22
        {  100, 22,   -128,    240,   1,  160, 0 },  -- t=2710 载体 22
        {  100, 22,    128,    240,   0,  160, 1 },  -- t=2810 载体 22
        {  100, 22,   -128,    240,   0,  160, 0 },  -- t=2910 载体 22
        {  100, 22,    128,    240,   0,  160, 1 },  -- t=3010 载体 22
        {  100, 22,   -128,    240,   0,  160, 0 },  -- t=3110 载体 22
        {  100, 22,     96,    240,   1,  160, 1 },  -- t=3210 载体 22
        {    0, 22,    -96,    240,   1,  160, 0 },  -- t=3210 载体 22
        {  300, 24,      0,    240,   2,  160, 0 },  -- t=3510 载体 24
        {  100, 22,     96,    240,   1,  160, 1 },  -- t=3610 载体 22
        {    0, 22,    -96,    240,   1,  160, 0 },  -- t=3610 载体 22
        {  200, 13,    128,    128,   1,   80, 0 },  -- t=3810 载体 12
        {   10, 11,   -128,    112,   0,   80, 0 },  -- t=3820 载体 10
        {   30, 11,   -128,     96,   1,   80, 0 },  -- t=3850 载体 10
        {   10, 13,    112,    128,   0,   80, 0 },  -- t=3860 载体 12
        {   30, 13,     96,    160,   1,   80, 0 },  -- t=3890 载体 12
        {   10, 11,    -96,    144,   0,   80, 0 },  -- t=3900 载体 10
        {   30, 11,   -128,     96,   1,   80, 0 },  -- t=3930 载体 10
        {   10, 13,     64,    160,   0,   80, 0 },  -- t=3940 载体 12
        {   30, 11,   -128,     96,   1,   80, 0 },  -- t=3970 载体 10
        {   10, 13,     64,    160,   0,   80, 0 },  -- t=3980 载体 12
        {   30, 11,   -128,     96,   1,   80, 0 },  -- t=4010 载体 10
        {   10, 13,     64,    160,   0,   80, 0 },  -- t=4020 载体 12
        {  300, 23,      0,    240,   1,  160, 0 },  -- t=4320 载体 23
        {  100, 24,     64,    240,   2,  160, 0 },  -- t=4420 载体 24
        {    0, 24,    -64,    240,   2,  160, 0 },  -- t=4420 载体 24
        {  523, 26,   -128,    192,   1,  160, 0 },  -- t=4943 载体 25
        {   30, 28,    -96,    160,   0,  160, 0 },  -- t=4973 载体 27
        {   30, 26,    -64,    128,   1,  160, 0 },  -- t=5003 载体 25
        {   30, 28,    -32,     96,   0,  160, 0 },  -- t=5033 载体 27
        {   30, 26,      0,     64,   1,  160, 0 },  -- t=5063 载体 25
        {   30, 28,     32,     32,   0,  160, 0 },  -- t=5093 载体 27
        {   30, 26,     64,      0,   1,  160, 0 },  -- t=5123 载体 25
        {   30, 30,     96,    -32,   0,  160, 0 },  -- t=5153 载体 29
        {  240, 32,    128,    112,   0,  110, 0 },  -- t=5393 载体 31
        {   20, 34, 110.866, 66.078,   1,  110, 0 },  -- t=5413 载体 33
        {   20, 32, 79.196, 32.804,   0,  110, 0 },  -- t=5433 载体 31
        {   20, 34, 39.7991, 15.9165,   1,  110, 0 },  -- t=5453 载体 33
        {   20, 32,      0,     16,   0,  110, 0 },  -- t=5473 载体 31
        {   20, 34, -33.6761, 30.6986,   1,  110, 0 },  -- t=5493 载体 33
        {   20, 32, -56.5685, 55.4315,   0,  110, 0 },  -- t=5513 载体 31
        {   20, 34, -66.5193, 84.4468,   1,  110, 0 },  -- t=5533 载体 33
        {   20, 32,    -64,    112,   0,  110, 0 },  -- t=5553 载体 31
        {   20, 34, -51.7373, 133.43,   1,  110, 0 },  -- t=5573 载体 33
        {   20, 32, -33.9411, 145.941,   0,  110, 0 },  -- t=5593 载体 31
        {   20, 34, -15.3073, 148.955,   1,  110, 0 },  -- t=5613 载体 33
        {   20, 32,      0,    144,   0,  110, 0 },  -- t=5633 载体 31
        {   20, 34, 9.1844, 134.173,   1,  110, 0 },  -- t=5653 载体 33
        {   20, 32, 11.3137, 123.314,   0,  110, 0 },  -- t=5673 载体 31
        {   20, 34, 7.39104, 115.061,   2,  110, 0 },  -- t=5693 载体 33
        {   20, 36,      0,    112,   0,  200, 0 },  -- t=5713 载体 35
    }

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        ---耐久卡：不打超时音、关掉本体的判定与血条（照上面三张卡）
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        pool4 = {}
        sound_tick4, sound_stamp4 = 0, -1
        task.New(self, function()
            for _, w in ipairs(WAVE5) do
                task.Wait(w[1])
                New(class["TH34_mid5"], w[3], w[4], w[6], w[2], w[7], w[5])
            end
        end)
    end
    function card:frame()
        sound_tick4 = sound_tick4 + 1
    end
    function card:render() end
    ---★ 不用清理：所有幽灵都是独立对象（没有 object.Connect 到 boss），
    ---最晚的一只在 120 秒内飞出场地自毁。
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end


---★ 下面两段（第 1 / 2 面）整段包在一个局部函数里再调用：LuaJIT 每个函数的局部
---变量上限是 200（LJ_MAX_LOCVAR），本文件的主 chunk 已经贴着上限，这两个面的
---工具函数 + 波表再摊在顶层就编不过（"main function has more than 200 local
---variables"）。这样主 chunk 只多一个 local。
local function TH34_add_stage12()
---==================== 第 1 面道中：代码 ====================
---自然语言说明与逐条差异在文件头的「第 1 面道中」单元里。
---代码按「文件里 6 → 4 → 3 → 5 → 1 → 2」的顺序排在最后：这一段直接借用第 3 面那段
---定义的工具（col16 / spread3 / volley3 / pool4），放在它们之后最省事。
---第 1 面非 boss 的血量折算（文件头差异 37）：life × 0.09825，保底 1 点 ——
---和 hp3 同一口径（第 1..3 面原作都没有非 boss 减伤，EnemyManager.cpp:820-845）。
local function hp1(life)
    return max(1, int(life * 0.09825 + 0.5))
end

---贴图代理（差异 38）：原作 SET_ANM 0/5 是 stg1enm.anm 里的两种妖精，移植版用本仓库
---的 enemy1（32×32 的小妖精）/ enemy5（48×32 的妖精）两套 sprite 当代理。
local W1_STYLE_S, W1_STYLE = 1, 5

---一条 SPREAD（base 直接用**我们**的角度制；a2_deg 是 th07 的弧度换成角度后的值）
local function w1_spread(self, style, off, c1, c2, v1, v2, base, a2_deg, plays)
    local offs = spread3(c1, a2_deg)
    volley3(self, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        local v = v1 - (v1 - v2) * layer / c2
        return style, col16(off), v, base + offs[ring + 1]
    end, plays)
end

---一条 RING（base 同样用我们的角度制；层间偏移 a2_deg 已经换成我们的符号）
local function w1_ring(self, style, off, c1, c2, v1, v2, base, a2_deg, plays)
    local step = 360 / c1
    volley3(self, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        local v = v1 - (v1 - v2) * layer / c2
        return style, col16(off), v, base + ring * step + layer * a2_deg
    end, plays)
end

---MOVE_DIR_TIME 的一段（原作的 ENEMY_MOVE_INTERP）：
---  n > 0 ⇒ Hermite（eas 4 = ease-out-quad；位移 = spd×n 沿 th07 的 θ，落地后速度归零）
---  n = 0 ⇒ 匀速直线（原文里的 θ + 速度，就是我们说的 POLAR）
---mirror 把速度的 x 分量取反 ⇒ 我们的角度 a 变成 180−a（对 θ=0 就是「向左」）。
local function w1_move(self, n, th, spd)
    local deg = -th * RAD2DEG
    if self.mirror == 1 then
        deg = 180 - deg
    end
    if n > 0 then
        self.mv_n, self.mv_t = n, 0
        self.mv_x0, self.mv_y0 = self.x, self.y
        self.mv_dx, self.mv_dy = cos(deg) * spd * n, sin(deg) * spd * n
        object.SetV(self, 0, 0, false)
    else
        self.mv_n = 0
        object.SetV(self, spd, deg, false)
    end
end

---每帧推一段 Hermite（frame 里调用；位置写 x/y 就够，速度保持 0 免得两套系统打架）
local function w1_advance(self)
    if self.mv_n > 0 then
        local u = min(self.mv_t, self.mv_n) / self.mv_n
        local e = 1 - (1 - u) * (1 - u)
        self.x = self.mv_x0 + self.mv_dx * e
        self.y = self.mv_y0 + self.mv_dy * e
        self.mv_t = self.mv_t + 1
    end
end

---道具折算（差异 39）：原作 itemdrop 0 = 小能量、1 = 点、2 = 大能量、7 = 樱点、
---−1 = 1/3 概率掉 g_ItemDropTable 里的随机道具（EnemyManager.cpp:948-990）。
---本仓库没有能量类道具 ⇒ 0/2 折成信仰道具、7 折成樱点、−1 折成 1/3 概率的信仰。
local function w1_drop(self)
    if self.dropcode == 7 then
        New(item.obj.sakura, self.x, self.y)
    elseif self.dropcode == -1 and ran:Int(0, 2) == 0 then
        New(item.obj.faith, self.x, self.y)
    end
end

---顺便把 0/1/2 交给框架的 self.drop（其余在 kill 里自己撒）
local function w1_setdrop(self, drop)
    self.dropcode = drop
    local f, p = DROP_FAITH[drop], DROP_POINT[drop]
    self.drop = { 0, f or 0, p or 0 }
end

---──────────── 小怪（原作 sub 3 / 4..15 / 19） ────────────
---sub 4..15 的齐射 + 蛇形（Lunatic 行）。列：
---{ c1, c2, v1, v2, 第一折 θ, 第二折 θ, 收尾 θ, 收尾速度, life }
---折线是 MOVE_DIR_TIME(40, eas 4, θ, 0.8)（位移 32 px、ease-out-quad），
---收尾是 MOVE_DIR_TIME(0, 0, θ, spd)（匀速直线）。13/14/15 没有折线，只有 t=110 的收尾。
local W1_ZIG = {
    [4]  = { 5, 4, 3.0, 1.0, -0.392699, 1.96349, -2.74889, 2, 2160 },
    [5]  = { 3, 4, 3.0, 1.0,  0.392699, -1.96349, 2.74889, 2, 2160 },
    [6]  = { 3, 4, 3.0, 1.0,  0,        -2.74889, 1.1781,  2, 2160 },
    [7]  = { 1, 1, 1.2, 1.0, -0.392699, 1.96349, -2.74889, 2, 2160 },
    [8]  = { 1, 1, 1.2, 1.0,  0.392699, -1.96349, 2.74889, 2, 2160 },
    [9]  = { 1, 1, 1.2, 1.0,  0,        -2.74889, 1.1781,  2, 2160 },
    [10] = { 3, 6, 4.4, 2.2, -0.392699, 1.96349, -2.74889, 2, 2160 },
    [11] = { 3, 6, 4.4, 2.2,  0.392699, -1.96349, 2.74889, 2, 2160 },
    [12] = { 3, 6, 4.4, 2.2,  0,        -2.74889, 1.1781,  2, 2160 },
    [13] = { 8, 6, 4.3, 1.0,  nil, nil, -1.5708,  1, 2110 },
    [14] = { 8, 6, 4.3, 1.0,  nil, nil, -1.5708,  1, 2110 },
    [15] = { 8, 6, 4.3, 1.0,  nil, nil, -1.5708,  1, 2110 },
}
local W1_A2 = 0.785398 * RAD2DEG          -- subs 4..6 / 10..15 的 a2 = π/4
---subs 7/8/9 的 a2 短得多：0.0981748 rad = 5.625°（ECL 里就是字面量）。
local W1_A2_OF = { [7] = 0.0981748 * RAD2DEG,
                   [8] = 0.0981748 * RAD2DEG,
                   [9] = 0.0981748 * RAD2DEG }

class["TH34_fairy1"] = Class(enemy, {
    ---@param sub number 原作的子程序号 3 / 4..15 / 19（16/17 走另一个类）
    ---@param mirror number 时间轴的 mirror 位（1 = 速度的 x 分量取反）
    init = function(self, x, y, life, sub, mirror, drop)
        local style = (sub == 3 or sub == 19) and W1_STYLE_S or W1_STYLE
        enemy.init(self, style, hp1(life), false, true, false)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.kind, self.mirror = sub, mirror or 0
        ---先给默认值：真机第一帧的 frame 就会读这几个（w1_advance / w1_move）
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        object.SetV(self, 0, 0, false)
        w1_setdrop(self, drop)
        local Z = W1_ZIG[sub]
        if Z then
            w1_move(self, 60, PI / 2, 2.5)                  -- 出生：60 帧下滑 150 px
            task.New(self, function()
                task.Wait(60)
                w1_spread(self, grain_a, 6, Z[1], Z[2], Z[3], Z[4],
                          Angle(self, player), W1_A2_OF[sub] or W1_A2, true)
                if Z[5] then
                    w1_move(self, 40, Z[5], 0.8)            -- t=60
                    task.Wait(50)
                    w1_move(self, 40, Z[6], 0.8)            -- t=110
                    task.Wait(50)                           -- t=160
                else
                    task.Wait(50)                           -- t=110（13/14/15 只有收尾）
                end
                w1_move(self, 0, Z[7], Z[8])
            end)
        elseif sub == 3 then
            w1_move(self, 60, PI / 2, 2.8)                  -- 出生：60 帧下滑 168 px
            task.New(self, function()
                task.Wait(60)
                ---MOVE_DIR_TIME(0,0,$10004,$10005)：θ、速度都是当场重掷的
                w1_move(self, 0, ran:Float(0.1309, 0.1309 + 0.327249), ran:Float(0.8, 2.5))
                w1_spread(self, grain_a, 6, 2, 1, 2, 1,
                          Angle(self, player), 0.0981748 * RAD2DEG, true)
            end)
        else                                               -- sub 19：只是直着走下来
            w1_move(self, 0, PI / 2, 3)
        end
        task.New(self, function()
            task.Wait(Z and Z[9] or ((sub == 3) and 2060 or 2000))
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        w1_advance(self)
    end,
    kill = function(self)
        w1_drop(self)
        enemy.kill(self)
    end,
})

---──────────── 环妖精（原作 sub 18） ────────────
---出生后向右平移（MOVE_DIR_TIME(0,0,0,4) ⇒ POLAR：θ=0、速 4），t=0 打一圈 12 发
---RING_ABS，之后每 90 帧重打同一圈（SET_SHOOT_INTERVAL_RAND 90，首轮延迟 1..90 帧随机）。
---★ t=60..179 的 `SET_ANGULAR_VEL 0.05236` **不是自转贴图**：这四条 sub 都没有
---`SET_VM_AUTO_ROTATE`，angleVel 只在 POLAR 分支里加 `enemy->angle`
---（EclManager.cpp:2018-2023）⇒ 本体真的会绕一整圈（0.05236×120 ≈ 2π）。
---th07 是 +3°/帧、y 朝下 ⇒ 我们 −3°/帧。
---★ 原作 t=60 重掷 $10004 是**死代码**：op67 在 t=0 就把 angle1 存成数字了，
---自动重发读的是那份快照（EclManager.cpp:1276-1289 与 :2095-2105），所以 24 圈同一个角。
class["TH34_ring1"] = Class(enemy, {
    init = function(self, x, y, life, sub, mirror, drop)
        enemy.init(self, W1_STYLE_S, hp1(life), false, true, false)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.kind, self.mirror = sub, mirror or 0
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        self.dir, self.spd, self.spin = 0, 4, 0
        w1_setdrop(self, drop)
        w1_move(self, 0, 0, 4)
        ---$10004 = ECL_VAR_RNG_RADIAN ∈ [−π, π)（RING_ABS 的 a1）
        self.ring_base = -ran:Float(-180, 180)
        self.ring_t = ran:Int(0, 90)
        w1_ring(self, grain_a, 9, 12, 1, 2, 1, self.ring_base, 0, true)
        task.New(self, function()
            task.Wait(60)
            self.spin = -3
            task.Wait(120)
            self.spin = 0
        end)
        task.New(self, function()
            task.Wait(2180)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        w1_advance(self)
        if self.spin ~= 0 then
            self.dir = self.dir + self.spin
            object.SetV(self, self.spd, self.dir, false)
        end
        if self.ring_t >= 0 then
            self.ring_t = self.ring_t + 1
            if self.ring_t >= 90 then
                self.ring_t = 0
                w1_ring(self, grain_a, 9, 12, 1, 2, 1, self.ring_base, 0, true)
            end
        end
    end,
    kill = function(self)
        w1_drop(self)
        enemy.kill(self)
    end,
})

---──────────── 大妖精（原作 sub 16/17） ────────────
---80 帧下滑 200 px，t=90 起朝自机方向打 8 轮旋转扇（每轮 2×5 = 10 发），
---t=142 收尾向下（MOVE_DIR_TIME(0,0,π/2,2)）。
---★ DEC_JUMP 的落点是 t=90 的循环体、计数 8 ⇒ **每 2 帧一轮、共 8 轮**
---（先减后跳，最后一下不跳 —— EclManager.cpp:945-954）。基准角在 t=90 那帧
---从 ANGLE_TO_PLAYER 冻结，之后只按 ±0.628319 rad（36°）逐轮转，不再重读自机角。
local W1_BIG_LIFE = 2142

class["TH34_bigfairy1"] = Class(enemy, {
    init = function(self, x, y, life, sub, mirror, drop)
        enemy.init(self, W1_STYLE, hp1(life), false, true, false)
        self.x, self.y = x, y
        self.A, self.B = 48, 48          -- SET_HITBOX_SIZE 48,48,32
        self.kind, self.mirror = sub, mirror or 0
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        object.SetV(self, 0, 0, false)
        w1_setdrop(self, drop)
        w1_move(self, 80, PI / 2, 2.5)
        ---sub 16 用 off=6、sub 17 用 off=10；两条的转法相反（一条 SUB_FLOAT、一条 ADD_FLOAT）
        local off = (sub == 17) and 10 or 6
        local rot = (sub == 17) and -36 or 36
        task.New(self, function()
            task.Wait(90)
            local base = Angle(self, player) + 180          -- th07 $10004 = 自机角 − π
            for k = 0, 7 do
                if k > 0 then
                    task.Wait(2)                           -- DEC_JUMP 每 2 帧一轮
                end
                w1_spread(self, grain_a, off, 2, 5, 4, 1,
                          base + rot * k, 0.0981748 * RAD2DEG, true)
            end
            task.Wait(142 - 90 - 2 * 7)                    -- 收尾回到时间轴上的 t=142
            w1_move(self, 0, PI / 2, 2)
        end)
        task.New(self, function()
            task.Wait(W1_BIG_LIFE)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        w1_advance(self)
    end,
    kill = function(self)
        w1_drop(self)
        enemy.kill(self)
    end,
})

---==================== 挂到空 boss 的第五张符卡 ====================
do
    local CARD_NAME = "一道中「初雪之妖精」"
    ---原作时间轴 0 的 spawn 从 t=600 排到 t=4558（最后一只 sub 19 的本体到
    ---4558+2000 = 6558 帧才自毁）；t=4642 还有最后一只大妖精（sub 17），
    ---它 t=142 的收尾弹在 4784 打完、本体到 4642+2142 = 6784 帧才消失 ⇒ 约 6800 帧
    ---收干净。给 120 秒余量。
    local CARD_TIME = 120
    local LEVEL = 32
    ---符卡历史槽位：本关（th34）自己的一段 3400..3407（按面序）；这张是第一面 ⇒ 3400。
    local CARD_ID = 3400

    ---逐条生成表：{ 距上一条的帧数, 本体子程序号, x, y, itemdrop, life, mirror }
    ---（x/y 已换算成我们的坐标；293 条全部用 /tmp/eclwork 的解释器逐值对过时间轴 0/1）。
    ---★ 这一段原作**没有载体这一层**：时间轴直接放本体（没有 SUB_CALL、
    ---没有 SPAWN_ENEMY_REL），所以 sub 号就是本体号、也没有烟尘/换装阶段。
    local WAVE1 = {
--- stage1 : 293 rows
        {     0,   3,  142.00,  240.00,   -1,    10, 1 },  -- t=600
        {     8,   3,  102.00,  240.00,   -1,    10, 1 },  -- t=608
        {     8,   3,  152.00,  256.00,   -1,    10, 1 },  -- t=616
        {     8,   3,  112.00,  256.00,   -1,    10, 1 },  -- t=624
        {     8,   3,  162.00,  272.00,   -1,    10, 1 },  -- t=632
        {     8,   3,  122.00,  272.00,   -1,    10, 1 },  -- t=640
        {    32,   3,  142.00,  240.00,   -1,    10, 1 },  -- t=672
        {     8,   3,  102.00,  240.00,   -1,    10, 1 },  -- t=680
        {     8,   3,  152.00,  256.00,   -1,    10, 1 },  -- t=688
        {     8,   3,  112.00,  256.00,   -1,    10, 1 },  -- t=696
        {     8,   3,  162.00,  272.00,   -1,    10, 1 },  -- t=704
        {     8,   3,  122.00,  272.00,   -1,    10, 1 },  -- t=712
        {    64,   3, -142.00,  240.00,   -1,    10, 0 },  -- t=776
        {     8,   3, -102.00,  240.00,   -1,    10, 0 },  -- t=784
        {     8,   3, -152.00,  256.00,   -1,    10, 0 },  -- t=792
        {     8,   3, -112.00,  256.00,   -1,    10, 0 },  -- t=800
        {     8,   3, -162.00,  272.00,   -1,    10, 0 },  -- t=808
        {     8,   3, -122.00,  272.00,   -1,    10, 0 },  -- t=816
        {    32,   3, -142.00,  240.00,   -1,    10, 0 },  -- t=848
        {     8,   3, -102.00,  240.00,   -1,    10, 0 },  -- t=856
        {     8,   3, -152.00,  256.00,   -1,    10, 0 },  -- t=864
        {     8,   3, -112.00,  256.00,   -1,    10, 0 },  -- t=872
        {     8,   3, -162.00,  272.00,   -1,    10, 0 },  -- t=880
        {     8,   3, -122.00,  272.00,   -1,    10, 0 },  -- t=888
        {    64,   3,  142.00,  240.00,   -1,    10, 1 },  -- t=952
        {     8,   3,  102.00,  240.00,   -1,    10, 1 },  -- t=960
        {     8,   3,  152.00,  256.00,   -1,    10, 1 },  -- t=968
        {     8,   3,  112.00,  256.00,   -1,    10, 1 },  -- t=976
        {     8,   3,  162.00,  272.00,   -1,    10, 1 },  -- t=984
        {     8,   3,  122.00,  272.00,   -1,    10, 1 },  -- t=992
        {    32,   3,  142.00,  240.00,   -1,    10, 1 },  -- t=1024
        {     8,   3,  102.00,  240.00,   -1,    10, 1 },  -- t=1032
        {     8,   3,  152.00,  256.00,   -1,    10, 1 },  -- t=1040
        {     8,   3,  112.00,  256.00,   -1,    10, 1 },  -- t=1048
        {     8,   3,  162.00,  272.00,   -1,    10, 1 },  -- t=1056
        {     8,   3,  122.00,  272.00,   -1,    10, 1 },  -- t=1064
        {    32,   3, -142.00,  240.00,   -1,    10, 0 },  -- t=1096
        {     8,   3, -102.00,  240.00,   -1,    10, 0 },  -- t=1104
        {     8,   3, -152.00,  256.00,   -1,    10, 0 },  -- t=1112
        {     8,   3, -112.00,  256.00,   -1,    10, 0 },  -- t=1120
        {     8,   3, -162.00,  272.00,   -1,    10, 0 },  -- t=1128
        {     8,   3, -122.00,  272.00,   -1,    10, 0 },  -- t=1136
        {    32,   3, -142.00,  240.00,   -1,    10, 0 },  -- t=1168
        {     8,   3, -102.00,  240.00,   -1,    10, 0 },  -- t=1176
        {     8,   3, -152.00,  256.00,   -1,    10, 0 },  -- t=1184
        {     8,   3, -112.00,  256.00,   -1,    10, 0 },  -- t=1192
        {     8,   3, -162.00,  272.00,   -1,    10, 0 },  -- t=1200
        {     8,   3, -122.00,  272.00,   -1,    10, 0 },  -- t=1208
        {   193,   4,  -32.00,  272.00,    0,    30, 0 },  -- t=1401
        {    30,   8,  160.00,  272.00,    0,    10, 1 },  -- t=1431
        {    30,   9, -160.00,  272.00,    0,    10, 0 },  -- t=1461
        {    30,   8,   32.00,  272.00,    0,    30, 1 },  -- t=1491
        {    30,   7,  -96.00,  272.00,    0,    10, 0 },  -- t=1521
        {    30,   9,   96.00,  272.00,    0,    10, 1 },  -- t=1551
        {    30,   7, -160.00,  272.00,    0,    30, 0 },  -- t=1581
        {    27,  18, -224.00,   96.00,   -1,    10, 0 },  -- t=1608
        {     3,   8,  160.00,  272.00,    0,    10, 1 },  -- t=1611
        {     5,  18, -224.00,   96.00,   -1,    10, 0 },  -- t=1616
        {     8,  18, -224.00,   96.00,   -1,    10, 0 },  -- t=1624
        {     8,  18, -224.00,   96.00,   -1,    10, 0 },  -- t=1632
        {     8,  18, -224.00,   96.00,   -1,    10, 0 },  -- t=1640
        {     1,   9,    0.00,  272.00,    0,    10, 0 },  -- t=1641
        {     7,  18, -224.00,   96.00,   -1,    10, 0 },  -- t=1648
        {     8,  18, -224.00,   96.00,   -1,    10, 0 },  -- t=1656
        {     8,  18, -224.00,   96.00,    7,    10, 0 },  -- t=1664
        {     7,   5,  160.00,  272.00,    0,    30, 1 },  -- t=1671
        {    30,   7,  -32.00,  272.00,    0,    10, 0 },  -- t=1701
        {    23,  18,  224.00,   96.00,   -1,    10, 1 },  -- t=1724
        {     7,   9,   32.00,  272.00,    0,    10, 1 },  -- t=1731
        {     1,  18,  224.00,   96.00,   -1,    10, 1 },  -- t=1732
        {     8,  18,  224.00,   96.00,   -1,    10, 1 },  -- t=1740
        {     8,  18,  224.00,   96.00,   -1,    10, 1 },  -- t=1748
        {     8,  18,  224.00,   96.00,   -1,    10, 1 },  -- t=1756
        {     8,  18,  224.00,   96.00,   -1,    10, 1 },  -- t=1764
        {     8,  18,  224.00,   96.00,   -1,    10, 1 },  -- t=1772
        {     8,  18,  224.00,   96.00,    7,    10, 1 },  -- t=1780
        {    60,  18,  224.00,   64.00,   -1,    10, 1 },  -- t=1840
        {     8,  18,  224.00,   64.00,   -1,    10, 1 },  -- t=1848
        {     8,  18,  224.00,   64.00,   -1,    10, 1 },  -- t=1856
        {     8,  18,  224.00,   64.00,   -1,    10, 1 },  -- t=1864
        {     8,  18,  224.00,   64.00,   -1,    10, 1 },  -- t=1872
        {     8,  18,  224.00,   64.00,   -1,    10, 1 },  -- t=1880
        {     8,  18,  224.00,   64.00,   -1,    10, 1 },  -- t=1888
        {     8,  18,  224.00,   64.00,    7,    10, 1 },  -- t=1896
        {     5,  18, -224.00,   80.00,   -1,    10, 0 },  -- t=1901
        {     5,  18, -224.00,   80.00,   -1,    10, 0 },  -- t=1906
        {     5,  18, -224.00,   80.00,   -1,    10, 0 },  -- t=1911
        {     5,  18, -224.00,   80.00,   -1,    10, 0 },  -- t=1916
        {     5,  18, -224.00,   80.00,   -1,    10, 0 },  -- t=1921
        {     5,  18, -224.00,   80.00,   -1,    10, 0 },  -- t=1926
        {     5,  18, -224.00,   80.00,    7,    10, 0 },  -- t=1931
        {    60,  18, -224.00,   96.00,    7,    10, 0 },  -- t=1991
        {     5,  18,  224.00,   96.00,    7,    10, 1 },  -- t=1996
        {     5,  18, -224.00,   96.00,    7,    10, 0 },  -- t=2001
        {     5,  18,  224.00,   96.00,    7,    10, 1 },  -- t=2006
        {     5,  18, -224.00,   96.00,    7,    10, 0 },  -- t=2011
        {     5,  18,  224.00,   96.00,    7,    10, 1 },  -- t=2016
        {     5,  18, -224.00,   96.00,    7,    10, 0 },  -- t=2021
        {   100,   3, -160.00,  240.00,   -1,    10, 0 },  -- t=2121
        {     2,   3,  148.00,  240.00,   -1,    10, 1 },  -- t=2123
        {     2,   3, -136.00,  256.00,   -1,    10, 0 },  -- t=2125
        {     2,   3,  124.00,  256.00,   -1,    10, 1 },  -- t=2127
        {     2,   3, -112.00,  272.00,   -1,    10, 0 },  -- t=2129
        {     2,   3,  100.00,  272.00,   -1,    10, 1 },  -- t=2131
        {     0,  10, -160.00,  272.00,    0,   100, 0 },  -- t=2131
        {     0,  11,  160.00,  272.00,    0,   100, 1 },  -- t=2131
        {     0,  12,    0.00,  272.00,    0,   100, 0 },  -- t=2131
        {     0,  10,  -64.00,  272.00,    0,   100, 0 },  -- t=2131
        {     0,  12,   64.00,  272.00,    0,   100, 1 },  -- t=2131
        {     2,   3,  -88.00,  240.00,   -1,    10, 0 },  -- t=2133
        {     2,   3,   76.00,  240.00,   -1,    10, 1 },  -- t=2135
        {     2,   3,  -64.00,  256.00,   -1,    10, 0 },  -- t=2137
        {     2,   3,   52.00,  256.00,   -1,    10, 1 },  -- t=2139
        {     2,   3,  -40.00,  272.00,   -1,    10, 0 },  -- t=2141
        {     2,   3,   28.00,  272.00,   -1,    10, 1 },  -- t=2143
        {     2,   3, -160.00,  240.00,    7,    10, 0 },  -- t=2145
        {     2,   3,  148.00,  240.00,   -1,    10, 1 },  -- t=2147
        {     2,   3, -136.00,  256.00,   -1,    10, 0 },  -- t=2149
        {     2,   3,  124.00,  256.00,   -1,    10, 1 },  -- t=2151
        {     2,   3, -112.00,  272.00,    7,    10, 0 },  -- t=2153
        {     2,   3,  100.00,  272.00,    7,    10, 1 },  -- t=2155
        {     2,   3,  -88.00,  240.00,    7,    10, 0 },  -- t=2157
        {     2,   3,   76.00,  240.00,   -1,    10, 1 },  -- t=2159
        {     2,   3,  -64.00,  256.00,   -1,    10, 0 },  -- t=2161
        {     2,   3,   52.00,  256.00,   -1,    10, 1 },  -- t=2163
        {     2,   3,  -40.00,  272.00,    7,    10, 0 },  -- t=2165
        {     2,   3,   28.00,  272.00,    7,    10, 1 },  -- t=2167
        {   114,  10, -160.00,  272.00,    0,   100, 0 },  -- t=2281
        {     0,  11,  160.00,  272.00,    0,   100, 1 },  -- t=2281
        {     0,  12,    0.00,  272.00,    0,   100, 0 },  -- t=2281
        {     0,  10,  -64.00,  272.00,    0,   100, 0 },  -- t=2281
        {     0,  12,   64.00,  272.00,    0,   100, 1 },  -- t=2281
        {   150,  10, -160.00,  272.00,    0,   100, 0 },  -- t=2431
        {     0,  11,  160.00,  272.00,    0,   100, 1 },  -- t=2431
        {     0,  12,    0.00,  272.00,    0,   100, 0 },  -- t=2431
        {     0,  10,  -64.00,  272.00,    0,   100, 0 },  -- t=2431
        {     0,  12,   64.00,  272.00,    0,   100, 1 },  -- t=2431
        {   100,  13, -160.00,  272.00,    7,   300, 0 },  -- t=2531
        {     0,  14,  160.00,  272.00,    7,   300, 1 },  -- t=2531
        {     0,  15,    0.00,  272.00,    7,   300, 0 },  -- t=2531
        {     0,  13,  -64.00,  272.00,    7,   300, 0 },  -- t=2531
        {     0,  15,   64.00,  272.00,    7,   300, 1 },  -- t=2531
        {   636,  19, -160.00,  256.00,   -1,     1, 0 },  -- t=3167
        {    10,  19, -128.00,  256.00,   -1,     1, 0 },  -- t=3177
        {    10,  19,  -96.00,  256.00,   -1,     1, 0 },  -- t=3187
        {    10,  19,  -64.00,  256.00,   -1,     1, 0 },  -- t=3197
        {    10,  19,  -32.00,  256.00,   -1,     1, 0 },  -- t=3207
        {    10,  19,    0.00,  256.00,   -1,     1, 0 },  -- t=3217
        {    10,  19,   32.00,  256.00,   -1,     1, 0 },  -- t=3227
        {    10,  19,   64.00,  256.00,   -1,     1, 0 },  -- t=3237
        {    10,  19,   96.00,  256.00,   -1,     1, 0 },  -- t=3247
        {    10,  19,  128.00,  256.00,   -1,     1, 0 },  -- t=3257
        {    10,  19,  160.00,  256.00,   -1,     1, 1 },  -- t=3267
        {    10,  19,  128.00,  256.00,   -1,     1, 1 },  -- t=3277
        {    10,  19,   96.00,  256.00,   -1,     1, 1 },  -- t=3287
        {    10,  19,   64.00,  256.00,   -1,     1, 1 },  -- t=3297
        {    10,  19,   32.00,  256.00,   -1,     1, 1 },  -- t=3307
        {    10,  19,    0.00,  256.00,   -1,     1, 1 },  -- t=3317
        {    10,  19,  -32.00,  256.00,   -1,     1, 1 },  -- t=3327
        {    10,  19,  -64.00,  256.00,   -1,     1, 1 },  -- t=3337
        {    10,  19,  -96.00,  256.00,   -1,     1, 1 },  -- t=3347
        {    10,  19, -128.00,  256.00,   -1,     1, 1 },  -- t=3357
        {    10,  19, -160.00,  256.00,   -1,     1, 0 },  -- t=3367
        {    10,  19, -128.00,  256.00,   -1,     1, 0 },  -- t=3377
        {    10,  19,  -96.00,  256.00,   -1,     1, 0 },  -- t=3387
        {    10,  19,  -64.00,  256.00,   -1,     1, 0 },  -- t=3397
        {    10,  19,  -32.00,  256.00,   -1,     1, 0 },  -- t=3407
        {    10,  19,    0.00,  256.00,   -1,     1, 0 },  -- t=3417
        {    10,  19,   32.00,  256.00,   -1,     1, 0 },  -- t=3427
        {    10,  19,   64.00,  256.00,   -1,     1, 0 },  -- t=3437
        {    10,  19,   96.00,  256.00,   -1,     1, 0 },  -- t=3447
        {    10,  19,  128.00,  256.00,   -1,     1, 0 },  -- t=3457
        {    10,  19,  160.00,  256.00,   -1,     1, 1 },  -- t=3467
        {    10,  19,  128.00,  256.00,   -1,     1, 1 },  -- t=3477
        {    10,  19,   96.00,  256.00,   -1,     1, 1 },  -- t=3487
        {    10,  19,   64.00,  256.00,   -1,     1, 1 },  -- t=3497
        {    10,  19,   32.00,  256.00,   -1,     1, 1 },  -- t=3507
        {    10,  19,    0.00,  256.00,   -1,     1, 1 },  -- t=3517
        {    10,  19,  -32.00,  256.00,   -1,     1, 1 },  -- t=3527
        {     4,   4, -160.00,  272.00,    0,   100, 0 },  -- t=3531
        {     6,  19,  -64.00,  256.00,   -1,     1, 1 },  -- t=3537
        {    10,  19,  -96.00,  256.00,   -1,     1, 1 },  -- t=3547
        {    10,  19, -128.00,  256.00,   -1,     1, 1 },  -- t=3557
        {    10,  19, -160.00,  256.00,   -1,     1, 0 },  -- t=3567
        {    10,  19, -128.00,  256.00,   -1,     1, 0 },  -- t=3577
        {    10,  19,  -96.00,  256.00,   -1,     1, 0 },  -- t=3587
        {    10,  19,  -64.00,  256.00,   -1,     1, 0 },  -- t=3597
        {    10,  19,  -32.00,  256.00,   -1,     1, 0 },  -- t=3607
        {    10,  19,    0.00,  256.00,   -1,     1, 0 },  -- t=3617
        {    10,  19,   32.00,  256.00,   -1,     1, 0 },  -- t=3627
        {     4,   5,  160.00,  272.00,    0,    30, 1 },  -- t=3631
        {     6,  19,   64.00,  256.00,   -1,     1, 0 },  -- t=3637
        {    10,  19,   96.00,  256.00,   -1,     1, 0 },  -- t=3647
        {    10,  19,  128.00,  256.00,   -1,     1, 0 },  -- t=3657
        {    10,  19,  160.00,  256.00,   -1,     1, 1 },  -- t=3667
        {    10,  19,  128.00,  256.00,   -1,     1, 1 },  -- t=3677
        {    10,  19,   96.00,  256.00,   -1,     1, 1 },  -- t=3687
        {    10,  19,   64.00,  256.00,   -1,     1, 1 },  -- t=3697
        {    10,  19,   32.00,  256.00,   -1,     1, 1 },  -- t=3707
        {    10,  19,    0.00,  256.00,   -1,     1, 1 },  -- t=3717
        {    10,  19,  -32.00,  256.00,   -1,     1, 1 },  -- t=3727
        {     4,   6,    0.00,  272.00,    0,    30, 0 },  -- t=3731
        {     6,  19,  -64.00,  256.00,   -1,     1, 1 },  -- t=3737
        {    10,  19,  -96.00,  256.00,   -1,     1, 1 },  -- t=3747
        {    10,  19, -128.00,  256.00,   -1,     1, 1 },  -- t=3757
        {    10,  19, -160.00,  256.00,   -1,     1, 0 },  -- t=3767
        {    10,  19, -128.00,  256.00,   -1,     1, 0 },  -- t=3777
        {    10,  19,  -96.00,  256.00,   -1,     1, 0 },  -- t=3787
        {    10,  19,  -64.00,  256.00,   -1,     1, 0 },  -- t=3797
        {    10,  19,  -32.00,  256.00,   -1,     1, 0 },  -- t=3807
        {    10,  19,    0.00,  256.00,   -1,     1, 0 },  -- t=3817
        {    10,  19,   32.00,  256.00,   -1,     1, 0 },  -- t=3827
        {     4,   5,  160.00,  272.00,    0,   100, 1 },  -- t=3831
        {     6,  19,   64.00,  256.00,   -1,     1, 0 },  -- t=3837
        {    10,  19,   96.00,  256.00,   -1,     1, 0 },  -- t=3847
        {    10,  19,  128.00,  256.00,   -1,     1, 0 },  -- t=3857
        {    11,  19,  160.00,  256.00,   -1,     1, 1 },  -- t=3868
        {    10,  19,  128.00,  256.00,   -1,     1, 1 },  -- t=3878
        {    10,  19,   96.00,  256.00,   -1,     1, 1 },  -- t=3888
        {    10,  19,   64.00,  256.00,   -1,     1, 1 },  -- t=3898
        {    10,  19,   32.00,  256.00,   -1,     1, 1 },  -- t=3908
        {    10,  19,    0.00,  256.00,   -1,     1, 1 },  -- t=3918
        {    10,  19,  -32.00,  256.00,   -1,     1, 1 },  -- t=3928
        {     3,   4,  -32.00,  272.00,    0,    30, 0 },  -- t=3931
        {     7,  19,  -64.00,  256.00,   -1,     1, 1 },  -- t=3938
        {    10,  19,  -96.00,  256.00,   -1,     1, 1 },  -- t=3948
        {    10,  19, -128.00,  256.00,   -1,     1, 1 },  -- t=3958
        {    10,  19, -160.00,  256.00,   -1,     1, 0 },  -- t=3968
        {    10,  19, -128.00,  256.00,   -1,     1, 0 },  -- t=3978
        {    10,  19,  -96.00,  256.00,   -1,     1, 0 },  -- t=3988
        {    10,  19,  -64.00,  256.00,   -1,     1, 0 },  -- t=3998
        {    10,  19,  -32.00,  256.00,   -1,     1, 0 },  -- t=4008
        {    10,  19,    0.00,  256.00,   -1,     1, 0 },  -- t=4018
        {    10,  19,   32.00,  256.00,   -1,     1, 0 },  -- t=4028
        {     4,   6,   32.00,  272.00,    0,    30, 1 },  -- t=4032
        {     6,  19,   64.00,  256.00,   -1,     1, 0 },  -- t=4038
        {    10,  19,   96.00,  256.00,   -1,     1, 0 },  -- t=4048
        {    10,  19,  128.00,  256.00,   -1,     1, 0 },  -- t=4058
        {    10,  19,  160.00,  256.00,   -1,     1, 1 },  -- t=4068
        {    10,  19,  128.00,  256.00,   -1,     1, 1 },  -- t=4078
        {    10,  19,   96.00,  256.00,   -1,     1, 1 },  -- t=4088
        {    10,  19,   64.00,  256.00,   -1,     1, 1 },  -- t=4098
        {    10,  19,   32.00,  256.00,   -1,     1, 1 },  -- t=4108
        {    10,  19,    0.00,  256.00,   -1,     1, 1 },  -- t=4118
        {    10,  19,  -32.00,  256.00,   -1,     1, 1 },  -- t=4128
        {     4,   4, -160.00,  272.00,    0,   100, 0 },  -- t=4132
        {     6,  19,  -64.00,  256.00,   -1,     1, 1 },  -- t=4138
        {    10,  19,  -96.00,  256.00,   -1,     1, 1 },  -- t=4148
        {    10,  19, -128.00,  256.00,   -1,     1, 1 },  -- t=4158
        {     4,  16, -128.00,  272.00,    0,   300, 0 },  -- t=4162
        {     6,  19, -160.00,  256.00,   -1,     1, 0 },  -- t=4168
        {    10,  19, -128.00,  256.00,   -1,     1, 0 },  -- t=4178
        {    10,  19,  -96.00,  256.00,   -1,     1, 0 },  -- t=4188
        {    10,  19,  -64.00,  256.00,   -1,     1, 0 },  -- t=4198
        {    10,  19,  -32.00,  256.00,   -1,     1, 0 },  -- t=4208
        {    10,  19,    0.00,  256.00,   -1,     1, 0 },  -- t=4218
        {    10,  19,   32.00,  256.00,   -1,     1, 0 },  -- t=4228
        {    10,  19,   64.00,  256.00,   -1,     1, 0 },  -- t=4238
        {    10,  19,   96.00,  256.00,   -1,     1, 0 },  -- t=4248
        {    10,  19,  128.00,  256.00,   -1,     1, 0 },  -- t=4258
        {    10,  19,  160.00,  256.00,   -1,     1, 1 },  -- t=4268
        {    10,  19,  128.00,  256.00,   -1,     1, 1 },  -- t=4278
        {    10,  19,   96.00,  256.00,   -1,     1, 1 },  -- t=4288
        {    10,  19,   64.00,  256.00,   -1,     1, 1 },  -- t=4298
        {    10,  19,   32.00,  256.00,   -1,     1, 1 },  -- t=4308
        {    10,  19,    0.00,  256.00,   -1,     1, 1 },  -- t=4318
        {     4,  17,  128.00,  272.00,    0,   300, 1 },  -- t=4322
        {     6,  19,  -32.00,  256.00,   -1,     1, 1 },  -- t=4328
        {    10,  19,  -64.00,  256.00,   -1,     1, 1 },  -- t=4338
        {    10,  19,  -96.00,  256.00,   -1,     1, 1 },  -- t=4348
        {    10,  19, -128.00,  256.00,   -1,     1, 1 },  -- t=4358
        {    10,  19, -160.00,  256.00,   -1,     1, 0 },  -- t=4368
        {    10,  19, -128.00,  256.00,   -1,     1, 0 },  -- t=4378
        {    10,  19,  -96.00,  256.00,   -1,     1, 0 },  -- t=4388
        {    10,  19,  -64.00,  256.00,   -1,     1, 0 },  -- t=4398
        {    10,  19,  -32.00,  256.00,   -1,     1, 0 },  -- t=4408
        {    10,  19,    0.00,  256.00,   -1,     1, 0 },  -- t=4418
        {    10,  19,   32.00,  256.00,   -1,     1, 0 },  -- t=4428
        {    10,  19,   64.00,  256.00,   -1,     1, 0 },  -- t=4438
        {    10,  19,   96.00,  256.00,   -1,     1, 0 },  -- t=4448
        {    10,  19,  128.00,  256.00,   -1,     1, 0 },  -- t=4458
        {    10,  19,  160.00,  256.00,   -1,     1, 1 },  -- t=4468
        {    10,  19,  128.00,  256.00,   -1,     1, 1 },  -- t=4478
        {     4,  16,  -96.00,  272.00,    0,   300, 0 },  -- t=4482
        {     6,  19,   96.00,  256.00,   -1,     1, 1 },  -- t=4488
        {    10,  19,   64.00,  256.00,   -1,     1, 1 },  -- t=4498
        {    10,  19,   32.00,  256.00,   -1,     1, 1 },  -- t=4508
        {    10,  19,    0.00,  256.00,   -1,     1, 1 },  -- t=4518
        {    10,  19,  -32.00,  256.00,   -1,     1, 1 },  -- t=4528
        {    10,  19,  -64.00,  256.00,   -1,     1, 1 },  -- t=4538
        {    10,  19,  -96.00,  256.00,   -1,     1, 1 },  -- t=4548
        {    10,  19, -128.00,  256.00,   -1,     1, 1 },  -- t=4558
        {    84,  17,   96.00,  272.00,    0,   300, 1 },  -- t=4642
    }

    ---本体子程序号 → 类。3/4..15/19 是小妖精、18 是环妖精、16/17 是大妖精。
    local W1_CLASS = {
        [3] = "TH34_fairy1", [4] = "TH34_fairy1", [5] = "TH34_fairy1",
        [6] = "TH34_fairy1", [7] = "TH34_fairy1", [8] = "TH34_fairy1",
        [9] = "TH34_fairy1", [10] = "TH34_fairy1", [11] = "TH34_fairy1",
        [12] = "TH34_fairy1", [13] = "TH34_fairy1", [14] = "TH34_fairy1",
        [15] = "TH34_fairy1", [19] = "TH34_fairy1",
        [18] = "TH34_ring1", [16] = "TH34_bigfairy1", [17] = "TH34_bigfairy1",
    }

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        ---耐久卡：不打超时音、关掉本体的判定与血条（照上面四张卡）
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        pool4 = {}
        sound_tick4, sound_stamp4 = 0, -1
        task.New(self, function()
            for _, w in ipairs(WAVE1) do
                task.Wait(w[1])
                New(class[W1_CLASS[w[2]]], w[3], w[4], w[6], w[2], w[7], w[5])
            end
        end)
    end
    function card:frame()
        sound_tick4 = sound_tick4 + 1
    end
    function card:render() end
    ---★ 不用清理：所有妖精都是独立对象（没有 object.Connect 到 boss），
    ---最晚的一只在 120 秒内自毁。
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end

---==================== 第 2 面道中：代码 ====================
---自然语言说明与逐条差异在文件头的「第 2 面道中」单元里。
---按 `ecldata2.ecl` 的三条时间轴（tl0 = 道中、tl1/tl2 = 左右镜像的一对）把
---t=600..7260 整段搬进来。
---★ 血量口径与第 1 面完全相同（差异 37/43）：第 2 面原作也没有非 boss 减伤，
---所以还是 life × 0.09825、保底 1 点。
local function hp2(life)
    return hp1(life)
end

---贴图代理（差异 44）：原作 SET_ANM 13 = 会飘的「种子」、SET_ANM 10 = 妖精、
---SET_ANM 0/5 = 更小的杂鱼；移植版用 enemy_orb1（23，带光环的光球）/ enemy5（5，
---48×32 的妖精）/ enemy1（1，32×32 的小妖精）当代理。
local W2_WISP_STYLE, W2_FAIRY_STYLE, W2_BODY_STYLE = 23, 5, 1

---种子（sub 4..17）的两条 Hermite 走 180 帧，t=180 生子体、t=210 自毁。
local W2_WISP_T = 180

---MOVE_DIR_TIME 的 θ（弧度、y 朝下）+ 时间轴 mirror 位 → 我们角度制的朝向
---（和 w1_move 里的换算完全一致：deg = −θ + 镜像位取 180−deg）。
local function w1_dir(self, th)
    local deg = -th * RAD2DEG
    if self.mirror == 1 then
        deg = 180 - deg
    end
    return deg
end

---sub → 子体表 { 子程序号, itemdrop }：逐条照 `SPAWN_ENEMY_REL` 的参数抄
---（offsets 全是 0 ⇒ 子体生在载体**当时**的位置上；life 一律 80；score 1500）。
local W2_CHILD = {
    [4]  = { { 18, -1 } },
    [5]  = { { 20, -1 } },
    [6]  = { { 21, -1 } },
    [7]  = { { 22, -1 } },
    [8]  = { { 23, -1 } },
    [9]  = { { 19, -1 } },
    [10] = { { 4, 1 }, { 5, 0 }, { 6, 1 } },
    [11] = { { 10, 1 }, { 10, 0 }, { 10, 1 } },
    [12] = { { 9, 1 },  { 9, 0 },  { 9, 1 } },
    [13] = { { 12, 1 }, { 12, 0 }, { 12, 1 } },
    [14] = { { 7, 1 },  { 7, 0 },  { 7, 1 } },
    [15] = { { 14, 1 }, { 14, 0 }, { 14, 1 } },
    [16] = { { 8, 1 },  { 8, 0 },  { 8, 1 } },
    [17] = { { 16, 1 }, { 16, 0 }, { 16, 1 } },
}

---本体子程序号 → 类。
local W2_CLASS = {
    [4] = "TH34_wisp2",  [5] = "TH34_wisp2",  [6] = "TH34_wisp2",
    [7] = "TH34_wisp2",  [8] = "TH34_wisp2",  [9] = "TH34_wisp2",
    [10] = "TH34_wisp2", [11] = "TH34_wisp2", [12] = "TH34_wisp2",
    [13] = "TH34_wisp2", [14] = "TH34_wisp2", [15] = "TH34_wisp2",
    [16] = "TH34_wisp2", [17] = "TH34_wisp2",
    [18] = "TH34_shoot2", [19] = "TH34_shoot2", [20] = "TH34_shoot2",
    [21] = "TH34_shoot2", [22] = "TH34_shoot2", [23] = "TH34_shoot2",
    [36] = "TH34_fairy2", [37] = "TH34_fairy2",
    [38] = "TH34_fairy2", [39] = "TH34_fairy2",
}

---──────────── 飘动的种子（原作 sub 4..17） ────────────
---本体**打不到、碰到也不掉血**（SET_IS_HITTABLE 0 + SET_HAS_CONTACT_HITBOX 0 +
---SET_PRIORITY 2），两条独立的 Hermite 在 180 帧里把 POS_X/POS_Y 从出生点拉到
---随机目标（INIT_INTERP 的目标变量就是 10018/10019 = POS_X/POS_Y；p1 = rand(64,320)
---对 X、rand(32,192) 对 Y，两端切线各 ±144）。t=180 在自己**当前**位置生子体，
---t=210 走 UNIMP（原作是 EclManager 返回 ZUN_ERROR ⇒ Despawn，不掉道具，
---移植版用 object.RawDel 对应）。
---★ 时间轴的 life 位是**随机位置的信号**（差异 45）：`JUMP_IF_EQ $10027(=LIFE),9999`
---命中时跳过 `SET_FLOAT $10004,$10018` ⇒ p0 不再是 POS_X、而是随机的
---rand(64,320)/rand(32,192)。所以表里 life=9999 那批行的 x/y 只是**占位**，
---真正的位置当场重掷（被父载体 SPAWN_ENEMY_REL 生出来时 life=80 ⇒ 用父机位置）。
class["TH34_wisp2"] = Class(enemy, {
    init = function(self, x, y, life, sub, mirror, drop)
        enemy.init(self, W2_WISP_STYLE, 1, false, false, true)
        self.colli = false
        self.protect = true
        if life == 9999 then
            self.x = ran:Float(64, 320) - 192
            self.y = 224 - ran:Float(32, 192)
        else
            self.x, self.y = x, y
        end
        self.kind, self.mirror = sub, mirror or 0
        self.dropcode = drop
        self.hx, self.hy = self.x, self.y
        self.tx = ran:Float(64, 320) - 192
        self.ty = 224 - ran:Float(32, 192)
        self.mx0, self.mx1 = rnd_sign() * 144, rnd_sign() * 144
        self.my0, self.my1 = rnd_sign() * 144, rnd_sign() * 144
        w1_setdrop(self, drop)
        task.New(self, function()
            task.Wait(W2_WISP_T)
            for _, k in ipairs(W2_CHILD[sub]) do
                New(class[W2_CLASS[k[1]]], self.x, self.y, 80, k[1], 0, k[2])
            end
            task.Wait(30)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        local t = min(self.timer, W2_WISP_T) / W2_WISP_T
        self.x = hermite(t, self.hx, self.tx, self.mx0, self.mx1)
        self.y = hermite(t, self.hy, self.ty, self.my0, self.my1)
    end,
    kill = function(self)
        w1_drop(self)
        enemy.kill(self)
    end,
})

---──────────── 打弹的子体（原作 sub 18..23） ────────────
---能打（SPAWN_ENEMY_REL 给的 life 80 ⇒ hp2(80) = 8），出生即按各自脚本打一轮弹，
---然后 t=80/110/130 转头朝自机、速度用 90 帧从 0 ease-out-quad 加到 2.5
---（`SET_MOVE_INTERP_TIMER_POLAR 61` ⇒ 61 帧后 moveMode 转 AXIS、速度冻结在
---2.5×(1−(1−61/90)²) ≈ 2.244 上直线飞向自机）。
---Lunatic 行逐条（每条的 skip=08 那一条）：
---  18 t=0   SPREAD aimed c1=6 c2=7 v=4→1.3 a2=2.8125°
---  19 t=0   RANDOM c1=24 v=2.3→0.8（a1=π、a2=−π ⇒ 整圆随机）+ Burst 命令
---  19 t=30  RANDOM c1=48 v=2→0.8 + Burst 命令
---  20 t=50  SPREAD aimed c1=4 c2=5 v=4.2→1 a2=120°
---  21 t=30  SPREAD aimed c1=9 c2=1 v=2.2→0.5 a2=4.5°
---  22 t=0   32×3 的**反向**扇（a1=π、a2=9°）+ 1×5 的 aimed 连发（0..3 帧错开）
---  23 t=0   13×2 的 aimed 扇（a2=5.625°，0..3 帧错开）
local W2_VOLLEY = {
    [18] = { spr = grain_a, off = 6, c1 = 6, c2 = 7, v1 = 4,   v2 = 1.3,
             a1 = 0, a2 = 0.0490874 },
    [20] = { spr = grain_a, off = 5, c1 = 4, c2 = 5, v1 = 4.2, v2 = 1,
             a1 = 0, a2 = 2.0944 },
    [21] = { spr = grain_a, off = 2, c1 = 9, c2 = 1, v1 = 2.2, v2 = 0.5,
             a1 = 0, a2 = 0.0785398 },
    [22] = { spr = grain_a, off = 2, c1 = 32, c2 = 3, v1 = 3.4, v2 = 1.5,
             a1 = PI, a2 = 0.15708 },
}
local W2_VOLLEY22B = { spr = grain_a, off = 2, c1 = 1, c2 = 5, v1 = 2, v2 = 0.5,
                       a1 = 0, a2 = 0 }
local W2_VOLLEY23 = { spr = grain_a, off = 13, c1 = 13, c2 = 2, v1 = 1.7, v2 = 1,
                      a1 = 0, a2 = 0.0981748 }

---一条 SPREAD_AIMED（base 是自机角减 a1；a2 是我们口径的度）。
local function w2_aimed(self, p)
    w1_spread(self, p.spr, p.off, p.c1, p.c2, p.v1, p.v2,
              Angle(self, player) - p.a1 * RAD2DEG, p.a2 * RAD2DEG, true)
end

---sub 19 的整圆随机：speed = rand[v2,v1)、角 = rand[−180,180)（th07 的
---rand(0, a1−a2)+a2 取反后是同一个集合）。flags 0x203 含 bit 1 ⇒ 每发都带 Burst。
local function w2_random19(self, c1, v1, v2)
    volley4_raw(self, c1, function()
        ---★ 原作 sub19 的就是 op72 RANDOM：逐发**先抽角、后抽速**（BulletManager.cpp:215-231）。
        local a = ran:Float(-180, 180)
        local v = ran:Float(v2, v1)
        return New(class["TH34_cmdbullet"], grain_a, col16(6),
                   self.x, self.y, v, a, { type = 1 })
    end)
end

class["TH34_shoot2"] = Class(enemy, {
    init = function(self, x, y, life, sub, mirror, drop)
        enemy.init(self, W2_BODY_STYLE, hp2(life), false, true, false)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.kind, self.mirror = sub, mirror or 0
        self.dropcode = drop
        ---第一帧 frame 就会读这三个（dive 段），先在顶层给默认值。
        self.dir, self.spd = 0, 0
        self.dive = 0
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        object.SetV(self, 0, 0, false)
        w1_setdrop(self, drop)
        ---t=80/110/130 转头的时刻（sub 22/23/18 是 80、21 是 110、20 是 130）。
        local tdive = ({ [20] = 130, [21] = 110 })[sub] or 80
        task.New(self, function()
            if sub == 22 or sub == 23 then
                ---RAND $10012 + SET_WAIT_TIMER：0..3 帧的随机错开
                task.Wait(ran:Int(0, 4))
                if sub == 22 then
                    w2_aimed(self, W2_VOLLEY[22])
                    w2_aimed(self, W2_VOLLEY22B)
                else
                    w2_aimed(self, W2_VOLLEY23)
                end
            elseif sub == 19 then
                w2_random19(self, 24, 2.3, 0.8)
                task.Wait(30)
                w2_random19(self, 48, 2, 0.8)
            else
                local p = W2_VOLLEY[sub]
                task.Wait(p and (({ [20] = 50, [21] = 30 })[sub] or 0) or 0)
                if p then
                    w2_aimed(self, p)
                end
            end
        end)
        task.New(self, function()
            task.Wait(tdive)
            self.dir = Angle(self, player)
            self.dive = 1
        end)
        task.New(self, function()
            task.Wait(({ [20] = 2130, [21] = 2110 })[sub] or 2080)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        if self.dive > 0 then
            self.dive = self.dive + 1
            if self.dive <= 62 then
                local u = min(self.dive, 90) / 90
                self.spd = 2.5 * (1 - (1 - u) * (1 - u))
                object.SetV(self, self.spd, self.dir, false)
            end
        end
    end,
    kill = function(self)
        w1_drop(self)
        enemy.kill(self)
    end,
})

---──────────── 左右对飞的两族妖精（原作 sub 36/37/39）与下落的杂鱼（sub 38） ────────────
---36/37 从画面左右两侧的 x=±208 进场（原作屏幕比场地宽 ⇒ 看得见，同差异 22），
---沿 θ=0 直线横穿（tl2 那一半带镜像位 ⇒ 反向）；39 从画面上方沿 θ=π/2 直落。
---三条都是：t=0 打一发固定扇（之后靠 SET_SHOOT_INTERVAL_RAND 每 90/120 帧重打同一发），
---t=60..179 挂 `SET_ANGULAR_VEL ±0.05236` ⇒ **本体画弧**（POLAR 分支里
---angle += angleVel，不是自转贴图），到 t=180 停；37/39 同帧还把间隔置 0 停火；
---全员 2180 帧自毁。38 不出弹，只是 80 帧 ease-out-quad 下落 160 px 再随机飘。
local W2_FAIRY = {
    [36] = { iv = 100, spr = grain_a, off = 10, c1 = 2, c2 = 5, v1 = 3.5, v2 = 1.5,
             a1 = 0, a2 = 0.0245437, theta = 0, spd = 4, spin = -3, stop = false },
    [37] = { iv = 100, spr = grain_a, off = 10, c1 = 7, c2 = 1, v1 = 1.5, v2 = 0.5,
             a1 = 0, a2 = 0.523599, theta = 0, spd = 4, spin = -3, stop = true },
    [39] = { iv = 120, spr = grain_a, off = 2, c1 = 4, c2 = 1, v1 = 1.4, v2 = 0.5,
             a1 = 0, a2 = 0.523599, theta = PI / 2, spd = 3, spin = 3, stop = true },
}

class["TH34_fairy2"] = Class(enemy, {
    init = function(self, x, y, life, sub, mirror, drop)
        enemy.init(self, (sub == 38) and W2_BODY_STYLE or W2_FAIRY_STYLE,
                   hp2(life), false, true, false)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.kind, self.mirror = sub, mirror or 0
        self.dropcode = drop
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        self.dir, self.spd, self.spin = 0, 0, 0
        self.iv, self.shoot_t = 0, 0
        object.SetV(self, 0, 0, false)
        w1_setdrop(self, drop)
        local p = W2_FAIRY[sub]
        if p then
            self.dir, self.spd = w1_dir(self, p.theta), p.spd
            self.iv = p.iv
            self.shoot_t = ran:Int(0, p.iv)
            w1_move(self, 0, p.theta, p.spd)
            ---t=0 的固定那一发（Interval 的自动重发会一直用这份快照）
            w2_aimed(self, p)
            task.New(self, function()
                task.Wait(60)
                self.spin = p.spin
                task.Wait(120)
                self.spin = 0
                if p.stop then
                    self.iv = 0
                end
            end)
        else
            w1_move(self, 80, PI / 2, 2)
            task.New(self, function()
                task.Wait(80)
                w1_move(self, 0, ran:Float(0.19635, 0.19635 + 0.392699), ran:Float(1.7, 2.2))
            end)
        end
        task.New(self, function()
            task.Wait((sub == 38) and 2080 or 2180)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        w1_advance(self)
        if self.spin ~= 0 then
            self.dir = self.dir + self.spin
            object.SetV(self, self.spd, self.dir, false)
        end
        local p = W2_FAIRY[self.kind]
        if p and self.iv > 0 then
            self.shoot_t = self.shoot_t + 1
            if self.shoot_t >= self.iv then
                self.shoot_t = 0
                w2_aimed(self, p)
            end
        end
    end,
    kill = function(self)
        w1_drop(self)
        enemy.kill(self)
    end,
})

---==================== 挂到空 boss 的第六张符卡 ====================
do
    local CARD_NAME = "二道中「雪之回廊」"
    ---原作时间轴 0/1/2 的 spawn 从 t=450 排到 t=7260（最后一批 sub 39 的本体到
    ---7260+2180 = 9440 帧才自毁）⇒ 约 9440 帧收干净。给 170 秒余量。
    local CARD_TIME = 170
    local LEVEL = 32
    ---符卡历史槽位：本关（th34）自己的一段 3400..3407（按面序）；这张是第二面 ⇒ 3401。
    local CARD_ID = 3401

    ---逐条生成表：{ 距上一条的帧数, 本体子程序号, x, y, itemdrop, life, mirror }
    ---（x/y 已换算成我们的坐标；324 条全部用 /tmp/eclwork 的解释器逐值对过时间轴 0/1/2）。
    ---★ 这一段原作**有载体这一层**：时间轴放的是不可打的「种子」（sub 4..17），
    ---种子 t=180 再 `SPAWN_ENEMY_REL` 生出会打弹的子体（sub 18..23）；
    ---36/37/38/39 是时间轴直接放的本体。
    local WAVE2 = {
--- stage2 : 324 rows
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=450
        {   150,  36, -208.00,  128.00,   -1,    30, 0 },  -- t=600
        {     0,  36,  208.00,  128.00,   -1,    30, 1 },  -- t=600
        {    10,  37, -208.00,  128.00,   -1,    30, 0 },  -- t=610
        {     0,  37,  208.00,  128.00,   -1,    30, 1 },  -- t=610
        {    10,  36, -208.00,  128.00,   -1,    30, 0 },  -- t=620
        {     0,  36,  208.00,  128.00,   -1,    30, 1 },  -- t=620
        {    10,   6, -128.00,  128.00,    0,    80, 0 },  -- t=630
        {     0,  37, -208.00,  128.00,   -1,    30, 0 },  -- t=630
        {     0,  37,  208.00,  128.00,   -1,    30, 1 },  -- t=630
        {    10,  36, -208.00,  128.00,   -1,    30, 0 },  -- t=640
        {     0,  36,  208.00,  128.00,   -1,    30, 1 },  -- t=640
        {    10,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=650
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=650
        {     0,  37, -208.00,  128.00,   -1,    30, 0 },  -- t=650
        {     0,  37,  208.00,  128.00,   -1,    30, 1 },  -- t=650
        {    10,  36, -208.00,  128.00,   -1,    30, 0 },  -- t=660
        {     0,  36,  208.00,  128.00,   -1,    30, 1 },  -- t=660
        {    10,   5,  -96.00,  128.00,    0,    80, 0 },  -- t=670
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=690
        {    20,   5,  -64.00,  128.00,    0,    80, 0 },  -- t=710
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=730
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=730
        {   130,  37, -208.00,  160.00,   -1,    30, 0 },  -- t=860
        {     0,  37,  208.00,   96.00,   -1,    30, 1 },  -- t=860
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=870
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=870
        {    10,  37, -208.00,  160.00,   -1,    30, 0 },  -- t=880
        {     0,  37,  208.00,   96.00,   -1,    30, 1 },  -- t=880
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=890
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=890
        {    10,  37, -208.00,  160.00,   -1,    30, 0 },  -- t=900
        {     0,  37,  208.00,   96.00,   -1,    30, 1 },  -- t=900
        {    10,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=910
        {     0,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=910
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=910
        {    10,  37, -208.00,  160.00,   -1,    30, 0 },  -- t=920
        {     0,  37,  208.00,   96.00,   -1,    30, 1 },  -- t=920
        {    10,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=930
        {    60,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=990
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=1010
        {    60,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=1070
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=1090
        {     0,   5,  128.00,  128.00,    0,    80, 0 },  -- t=1090
        {    20,   5,   96.00,  128.00,    0,    80, 0 },  -- t=1110
        {    10,  37, -208.00,   96.00,   -1,    30, 0 },  -- t=1120
        {     0,  37,  208.00,  160.00,   -1,    30, 1 },  -- t=1120
        {    10,   5,   64.00,  128.00,    0,    80, 0 },  -- t=1130
        {     0,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1130
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1130
        {    10,  37, -208.00,   96.00,   -1,    30, 0 },  -- t=1140
        {     0,  37,  208.00,  160.00,   -1,    30, 1 },  -- t=1140
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1150
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1150
        {    10,  37, -208.00,   96.00,   -1,    30, 0 },  -- t=1160
        {     0,  37,  208.00,  160.00,   -1,    30, 1 },  -- t=1160
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1170
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1170
        {    10,  37, -208.00,   96.00,    2,    30, 0 },  -- t=1180
        {     0,  37,  208.00,  160.00,    2,    30, 1 },  -- t=1180
        {   200,  38, -160.00,  240.00,   -1,    10, 0 },  -- t=1380
        {     2,  38,  148.00,  240.00,   -1,    10, 1 },  -- t=1382
        {     2,  38, -136.00,  256.00,   -1,    10, 0 },  -- t=1384
        {     2,  38,  124.00,  256.00,   -1,    10, 1 },  -- t=1386
        {     2,  38, -112.00,  272.00,   -1,    10, 0 },  -- t=1388
        {     2,  38,  100.00,  272.00,   -1,    10, 1 },  -- t=1390
        {     2,  38,  -88.00,  240.00,   -1,    10, 0 },  -- t=1392
        {     2,  38,   76.00,  240.00,   -1,    10, 1 },  -- t=1394
        {     2,  38,  -64.00,  256.00,   -1,    10, 0 },  -- t=1396
        {     2,  38,   52.00,  256.00,   -1,    10, 1 },  -- t=1398
        {     2,  38,  -40.00,  272.00,   -1,    10, 0 },  -- t=1400
        {     2,  38,   28.00,  272.00,   -1,    10, 1 },  -- t=1402
        {     2,  38, -160.00,  240.00,   -1,    10, 0 },  -- t=1404
        {     2,  38,  148.00,  240.00,   -1,    10, 1 },  -- t=1406
        {     2,  38, -136.00,  256.00,   -1,    10, 0 },  -- t=1408
        {     2,  38,  124.00,  256.00,   -1,    10, 1 },  -- t=1410
        {     2,  38, -112.00,  272.00,   -1,    10, 0 },  -- t=1412
        {     2,  38,  100.00,  272.00,   -1,    10, 1 },  -- t=1414
        {     2,  38,  -88.00,  240.00,   -1,    10, 0 },  -- t=1416
        {     2,  38,   76.00,  240.00,   -1,    10, 1 },  -- t=1418
        {     2,  38,  -64.00,  256.00,   -1,    10, 0 },  -- t=1420
        {     2,  38,   52.00,  256.00,   -1,    10, 1 },  -- t=1422
        {     2,  38,  -40.00,  272.00,   -1,    10, 0 },  -- t=1424
        {     2,  38,   28.00,  272.00,   -1,    10, 1 },  -- t=1426
        {   154,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1580
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1580
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1590
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1590
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1600
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1600
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1610
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1610
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1620
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1620
        {     6,  11,  -64.00,   96.00,    0,  9999, 0 },  -- t=1626
        {     4,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=1630
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=1630
        {    10,  36, -208.00,   96.00,    2,    30, 0 },  -- t=1640
        {     0,  36,  208.00,  160.00,    2,    30, 1 },  -- t=1640
        {   200,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=1840
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=1840
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=1850
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=1850
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=1860
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=1860
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=1870
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=1870
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=1880
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=1880
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=1890
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=1890
        {    10,  36, -208.00,  160.00,    2,    30, 0 },  -- t=1900
        {     0,  36,  208.00,   96.00,    2,    30, 1 },  -- t=1900
        {   226,  13,  -64.00,   96.00,    0,  9999, 0 },  -- t=2126
        {   174,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=2300
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=2300
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=2310
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=2310
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=2320
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=2320
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=2330
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=2330
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=2340
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=2340
        {    10,  36, -208.00,   96.00,   -1,    30, 0 },  -- t=2350
        {     0,  36,  208.00,  160.00,   -1,    30, 1 },  -- t=2350
        {    10,  36, -208.00,   96.00,    2,    30, 0 },  -- t=2360
        {     0,  36,  208.00,  160.00,    2,    30, 1 },  -- t=2360
        {   200,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=2560
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=2560
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=2570
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=2570
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=2580
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=2580
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=2590
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=2590
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=2600
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=2600
        {    10,  36, -208.00,  160.00,   -1,    30, 0 },  -- t=2610
        {     0,  36,  208.00,   96.00,   -1,    30, 1 },  -- t=2610
        {    10,  36, -208.00,  160.00,    2,    30, 0 },  -- t=2620
        {     0,  36,  208.00,   96.00,    2,    30, 1 },  -- t=2620
        {   806,   5, -128.00,  128.00,    0,    80, 0 },  -- t=3426
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=3446
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3446
        {    20,   5,  -96.00,  128.00,    0,    80, 0 },  -- t=3466
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=3486
        {    20,   5,  -64.00,  128.00,    0,    80, 0 },  -- t=3506
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=3526
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3526
        {   180,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3706
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3726
        {    60,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3786
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3806
        {    14,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=3820
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=3830
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=3840
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=3850
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=3860
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3866
        {     4,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=3870
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=3880
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=3886
        {     0,   5,  128.00,  128.00,    0,    80, 0 },  -- t=3886
        {    20,   5,   96.00,  128.00,    0,    80, 0 },  -- t=3906
        {    20,   5,   64.00,  128.00,    0,    80, 0 },  -- t=3926
        {   154,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=4080
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=4090
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=4100
        {     6,   5, -128.00,  128.00,    0,    80, 0 },  -- t=4106
        {     4,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=4110
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=4120
        {     6,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=4126
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4126
        {     4,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=4130
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=4140
        {     6,   5,  -96.00,  128.00,    0,    80, 0 },  -- t=4146
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=4166
        {    20,   5,  -64.00,  128.00,    0,    80, 0 },  -- t=4186
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=4206
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4206
        {   134,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=4340
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=4350
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=4360
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=4370
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=4380
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4386
        {     4,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=4390
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=4400
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4406
        {    60,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4466
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4486
        {    60,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4546
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4566
        {     0,   5,  128.00,  128.00,    0,    80, 0 },  -- t=4566
        {    20,   5,   96.00,  128.00,    0,    80, 0 },  -- t=4586
        {    14,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=4600
        {     6,   5,   64.00,  128.00,    0,    80, 0 },  -- t=4606
        {     4,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=4610
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=4620
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=4630
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=4640
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=4650
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=4660
        {   126,   5, -128.00,  128.00,    0,    80, 0 },  -- t=4786
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=4806
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4806
        {    20,   5,  -96.00,  128.00,    0,    80, 0 },  -- t=4826
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=4846
        {    14,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=4860
        {     6,   5,  -64.00,  128.00,    0,    80, 0 },  -- t=4866
        {     4,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=4870
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=4880
        {     6,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=4886
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=4886
        {     0,  11,  -64.00,   96.00,    0,  9999, 0 },  -- t=4886
        {     4,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=4890
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=4900
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=4910
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=4920
        {   146,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5066
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5086
        {    34,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=5120
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=5130
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=5140
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5146
        {     4,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=5150
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=5160
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5166
        {     4,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=5170
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=5180
        {    46,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5226
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5246
        {     0,   5,  128.00,  128.00,    0,    80, 0 },  -- t=5246
        {    20,   5,   96.00,  128.00,    0,    80, 0 },  -- t=5266
        {    20,   5,   64.00,  128.00,    0,    80, 0 },  -- t=5286
        {    94,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=5380
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=5390
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=5400
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=5410
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=5420
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=5430
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=5440
        {    26,   5, -128.00,  128.00,    0,    80, 0 },  -- t=5466
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=5486
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5486
        {    20,   5,  -96.00,  128.00,    0,    80, 0 },  -- t=5506
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=5526
        {    20,   5,  -64.00,  128.00,    0,    80, 0 },  -- t=5546
        {    20,   4, -142.00,  240.00,    0,  9999, 0 },  -- t=5566
        {     0,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5566
        {     0,  11,  -64.00,   96.00,    0,  9999, 0 },  -- t=5566
        {    74,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=5640
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=5650
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=5660
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=5670
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=5680
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=5690
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=5700
        {    46,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5746
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5766
        {    60,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5826
        {    20,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5846
        {    54,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=5900
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5906
        {     4,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=5910
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=5920
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=5926
        {     0,   5,  128.00,  128.00,    0,    80, 0 },  -- t=5926
        {     4,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=5930
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=5940
        {     6,   5,   96.00,  128.00,    0,    80, 0 },  -- t=5946
        {     4,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=5950
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=5960
        {     6,   5,   64.00,  128.00,    0,    80, 0 },  -- t=5966
        {     0,  11,  -64.00,   96.00,    0,  9999, 0 },  -- t=5966
        {   180,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=6146
        {    14,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=6160
        {     6,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=6166
        {     4,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=6170
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=6180
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=6190
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=6200
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=6210
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=6220
        {    26,   6, -142.00,  240.00,    0,  9999, 0 },  -- t=6246
        {   174,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=6420
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=6430
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=6440
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=6450
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=6460
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=6470
        {    10,  39,   64.00,  240.00,   -1,    30, 1 },  -- t=6480
        {   200,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=6680
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=6690
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=6700
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=6710
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=6720
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=6730
        {    10,  39,  -64.00,  240.00,   -1,    30, 0 },  -- t=6740
        {   106,  15,  -64.00,   96.00,    0,  9999, 0 },  -- t=6846
        {     0,  17,  -64.00,   96.00,    0,  9999, 0 },  -- t=6846
        {     0,   4, -176.00,  160.00,    0,    80, 0 },  -- t=6846
        {    10,   4,  176.00,  160.00,    0,    80, 0 },  -- t=6856
        {    10,   4, -128.00,  160.00,    0,    80, 0 },  -- t=6866
        {    10,   4,  128.00,  160.00,    0,    80, 0 },  -- t=6876
        {    10,   4,  -80.00,  160.00,    0,    80, 0 },  -- t=6886
        {    10,   4,   80.00,  160.00,    0,    80, 0 },  -- t=6896
        {    10,   4,  -32.00,  160.00,    0,    80, 0 },  -- t=6906
        {    10,   4,   32.00,  160.00,    0,    80, 0 },  -- t=6916
        {    24,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=6940
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=6950
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=6960
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=6970
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=6980
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=6990
        {    10,  39,  128.00,  240.00,   -1,    30, 1 },  -- t=7000
        {   200,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=7200
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=7210
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=7220
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=7230
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=7240
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=7250
        {    10,  39, -128.00,  240.00,   -1,    30, 0 },  -- t=7260
    }

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        ---耐久卡：不打超时音、关掉本体的判定与血条（照上面几张卡）
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        pool4 = {}
        sound_tick4, sound_stamp4 = 0, -1
        task.New(self, function()
            for _, w in ipairs(WAVE2) do
                task.Wait(w[1])
                New(class[W2_CLASS[w[2]]], w[3], w[4], w[6], w[2], w[7], w[5])
            end
        end)
    end
    function card:frame()
        sound_tick4 = sound_tick4 + 1
    end
    function card:render() end
    ---★ 不用清理：所有妖精都是独立对象（没有 object.Connect 到 boss），
    ---最晚的一只在 170 秒内自毁。
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end
end

---==================== 第 7 面（EX）/ 第 8 面（PH）道中：代码 ====================
---【自然语言说明 · 第 7/8 面道中】
---原作的 EX / PH 面没有「道中 3 条时间轴」的结构：`ecldata7.ecl` 与 `ecldata8.ecl`
---的 **tl0** 就是整段道中（偏移 0xDE18 / 0x11234），tl1 只是开局一个特效敌人
---（t=1 放 1 只），所以只搬 tl0。tl0 里除 spawn 外只有 boss 对话/中断（op 8/9/10/12），
---一并跳过。末尾各有一条**道中 boss 占位**要剔掉：EX 是 t=8799 的 sub 67、
---PH 是 t=9259 的 sub 69（`ecldata7` 的 sub 54 与 `ecldata8` 的 sub 56 也是）。
---
---    EX（面 7）  284 条 spawn，t=545..8799 ⇒ 取 282 条、最后一只 t=8298
---    PH（面 8）  374 条 spawn，t=545..9259 ⇒ 取 372 条、最后一只 t=8758
---
---道中的结构（两面高度同构，下面以 EX 的参数说，PH 的差异单列）：
---  · 前半段是**「载体 + 打弹小精灵」**：载体 sub 10/12/14/16/18/20/22/24/26/28 出生
---    后先当 80 帧烟尘（sub 9：贴图 29、不可打、碰到自机不掉血；沿一条 Hermite 从
---    「出生点下方 179 px、偏左 17 px」飘到出生点，X 的两条切线各 ±144、Y 的
---    m0=24、m1=±32），80 帧一到在原地生出**本体** sub 11/13/15/…/29 并自毁。
---    本体是**匀加速直线**（MOVE_DIR_TIME(0,0,θ,0) 定朝向 + SET_MOVE_ACCEL 0.02）：
---    sub 11/15/19/23/27 朝 +x、sub 13/17/21/25/29 朝 −x；出生后 10 帧无敌，之后
---    **每 4 帧一轮 SPREAD_AIMED**（v1=5、v2=1，a1=0 ⇒ 每轮重读自机角）：
---      sub 11/13 → 1 发；15/17 → 2 发（36°）；19/21 → 3 发（36°）；
---      23/25 → 1 发；27/29 → 2 发（36°）；轮数 $10012 = 32 / 32 / 12（后三条）。
---    本体打到循环结束**没有终止指令**（子程序末尾就是表尾）⇒ 真机上它带着 0.02 的
---    加速度一直飞；移植版靠 `enemy.init` 的 auto_delete（出屏即回收）收尾（差异 61）。
---  · 中段 sub 31/32/34/35/37/38（各 24/24/12/10/…只）：先 SET 一批
---    $10037/$10041/$10038 —— **写的是 GLOBAL_INT_1/GLOBAL_FLOAT_1，而 sub 30/33/36
---    读的是从没被赋值过的 $10029/$10030/$10033（LOCAL_INT3_1/2、LOCAL_FLOAT3_1）
---    ⇒ 运行时恒 0**，全是死代码 —— 然后 SUB_CALL 30/33/36（原地展开，不新开敌人）。
---      sub 30：60 帧 ease-out 插值位移 120 px（θ=1.76715），t=60 打一发 SPREAD_AIMED
---        （EX 5×3/v1=4、PH 5×3/v1=5；a2=0、off=0 ⇒ 只有速度分层的「速度墙」），
---        t=90 改 POLAR（θ=0.3927、速 3），t=2090 自毁。
---      sub 33/36：POLAR 沿 +x 速 5 平移、且不自转（SET_ANGULAR_VEL $10033=0）；
---        先 DISABLE_BULLETS 把 t=0 那一发吞掉（只留 bulletProps 快照），再用
---        SET_SHOOT_INTERVAL_RAND 5 ⇒ **每 5 帧重打同一轮 RING_AIMED**（每次重瞄自机），
---        t=120 停火，t=2120 自毁。33：EX 4×5/v1=4、PH 5×5/v1=6；36：都是 6×4，
---        EX v1=4、PH v1=6。（a2=0 ⇒ 每层 c1 发重叠的「速度墙」。）
---  · sub 41/42/43/44（各 16 只）→ SUB_CALL 39/40（同样原地展开）：
---    60 帧 ease-out 插值位移 120 px 后，t=60 起**每 4 帧一发 RING_ABS**，共 32 发；
---    每发的 a1 冻结在 t=60 那一刻的自机角（原代码 ADD $10004,$10004,$10033 加 0），
---    速度 = $10006 − rand(0.8)，$10006 从 1 起每发 +0.046875 ⇒ 一环环比一环快；
---    c1=6、spr=2。sub 40 同构但 c1=3、24 发、收尾 θ=0.3927。PH 把这一段整体提速：
---    40 帧走 80 px、t=40 起、无敌 30 帧、速度 = 2.5 − rand(1.5) 每发 +0.078125，
---    c1 = 6（39）/ 4（40）；死时掉 6 信仰 + 3 点（原作 DEATH_CALLBACK_SUB 0 + $10003=6）。
---  · sub 45/47/49（各 4/2/3 只）→ 又是载体（sub 9 的烟尘）生出 sub 46/48/50：
---      sub 46/50：**每 4（EX）/3（PH）帧一发 RING_ABS**，a1 = rand[−π,π)、
---        v1 = rand(0,2)+0.3（EX）/ rand(0,3)+2 或 +0.3（PH）、c1=5、off=14/12，
---        共 50/60 发；sub 48：每 60 帧一发 RING_AIMED（c1=6、v1=2（EX）/3（PH）），3 发。
---      三条打完都转头向上（MOVE_DIR_TIME(0,0,−π/2,0) + SET_MOVE_ACCEL 0.02），
---      t≈3004 自毁；被击破掉 4 信仰 + 3 点（原作 DEATH_CALLBACK_SUB 7）。
---  · sub 52/53（EX 各 26/41 只，PH 各 36/49 只）＋ PH 另有 sub 54/55（各 16/24 只）：
---    短命的「开幕烟花」：不可打、碰到自机不掉血，t=0 用 8 次 SUB_CALL 51 各打 1 发
---    （sub 51：SET_SHOOT_OFFSET($10034×32,$10035×32) + RING_ABS spr=0,off=$10029,
---    c1=1,c2=1,v1=2,v2=1,a1=$10033,a2=0.628319、flags=0x2a8），t=90 再打一发
---    SPREAD_AIMED（EX 5×3/v1=5、PH 4×3/v1=7）当场 UNIMP。这条弹挂着两条命令
---    （flags 0x2a8 含 bit 0x20/0x80）：cmd0 = 0x20 每帧转 ∓6°、30 帧转半圈；
---    cmd1 = 0x80 用 60 帧沿当前朝向把速度线性减到 0，然后**重新瞄准自机**、
---    以速 4（EX）/7（PH）再飞出去。
---    ★ 原作 sub 51 读的 $10033/$10034/$10035 从没被赋值（sub 52 写的
---      $10041/$10042/$10043 是另外的变量、而且是只写不读）⇒ 真机上这 8 发
---      **完全重叠**在 (0,0)、角 0、速度 2（等于 1 发）。移植版照抄这个运行时行为，
---      不「修正」成真机看不到的八方向（差异 60）。
---  · 血量：EX/PH 面原作对非 boss **不减伤**（EnemyManager.cpp:820-845 只管 4/5/6 面）
---    ⇒ 一律 life × 0.09825、保底 1（同 hp1）。本体出生时继承载体的 LIFE
---    （SPAWN_ENEMY_REL 的第 5 参就是 $10027）⇒ 前半段小妖精 1 HP（life 10）、
---    sub 46/48/50 的载体 life=400 ⇒ 39 HP；而 SPAWN_ENEMY_REL 的子体**不继承 mirror**
---    （SpawnEnemyEx 拿的是模板）⇒ 本体的朝向完全由自己的 θ 决定。
---  · itemdrop：−2 = 不掉（`DROP_FAITH[−2]`/`DROP_POINT[−2]` 都是 nil ⇒ 写成 {0,0,0}）、
---    0/1/2 = 信仰/点/双信仰、7 = 樱点、−1 = 1/3 概率信仰（同 1/2 面）。
---
---与原作的不同（延续 1/2 面的编号，每条都写了为什么）
---  60  sub 51 的 8 发按运行时（读未赋值的局部量）**重叠成 1 发**，不臆改成八方向；
---      仍然生 8 个对象，好让弹池占用与原作一致。
---  61  本体（sub 11..29）循环打完后原作没有终止指令（子程序末尾就是表尾），真机上
---      它带着 SET_MOVE_ACCEL 一直飞、出屏也不注销（默认 DESPAWN_ON_OOB=0）。移植版
---      用 `enemy.init` 的 auto_delete 出屏回收，免得几百只永久滞留在更新列表里。
---  62  贴图代理沿用 1/2 面：ANM 29（烟尘）→ style 27 的 ghost_fire_r 粒子、
---      ANM 0/27（小妖精）→ style 1（enemy1，32×32）、ANM 24（中载体 / 39/40）→
---      style 24（enemy_orb2）、ANM 32（开幕）→ style 27。
---  63  弹型 sprite 0/1/2/3/7 与 spriteOffset 色档按 1/2 面近似（`col16`）：
---      0→ball_small、1/2→grain_a、3→ball_small、7→arrow_small。
---  64  SET_SHOOT_INTERVAL_RAND 的 rank 缩放（ShootInterval = ±20%）不做，直接用 n。
---  65  残火直接复用第一面的 `TH34_flame`（原作第 7/8 面 sub 4 的 Hermite 常量是
---      X−11、Y−133、m0=46，第 6 面是 X−8、Y−150、m0=35；差 11 px，纯演出）。
---  66  道具/音效沿用 1/2 面的折算（0/2→信仰、7→樱点、`tan00` 每帧去重）。

local function TH34_add_stage78()

---EX/PH 面非 boss 不减伤 ⇒ life × 0.09825、保底 1（同 hp1/hp2/hp3）。
local function hp78(life)
    return max(1, int(life * 0.09825 + 0.5))
end

---th07 弧度（y 朝下）+ 时间轴的 mirror 位 → 我们的角度制（同 w1_dir）。
local function d78(self, th)
    local deg = -th * RAD2DEG
    if self.mirror == 1 then
        deg = 180 - deg
    end
    return deg
end

---MOVE_DIR_TIME 的一段：n>0 ⇒ Hermite（ease-out-quad，60/40 帧走 spd×n）；
---n<=0 ⇒ POLAR（定朝向 θ、速度 spd，之后靠 SET_MOVE_ACCEL 匀加速）。
local function move78(self, n, th, spd)
    if n > 0 then
        local deg = d78(self, th)
        self.mv_n, self.mv_t = n, 0
        self.mv_x0, self.mv_y0 = self.x, self.y
        self.mv_dx, self.mv_dy = cos(deg) * spd * n, sin(deg) * spd * n
        self.dir, self.spd, self.accel = deg, 0, 0
        object.SetV(self, 0, 0, false)
    else
        self.mv_n = 0
        self.dir, self.spd = d78(self, th), spd
        object.SetV(self, spd, self.dir, false)
    end
end

---每帧推 Hermite；没有插值时按 SET_MOVE_ACCEL 给 POLAR 加速。
local function adv78(self)
    if self.mv_n > 0 then
        local u = min(self.mv_t, self.mv_n) / self.mv_n
        local e = 1 - (1 - u) * (1 - u)
        self.x = self.mv_x0 + self.mv_dx * e
        self.y = self.mv_y0 + self.mv_dy * e
        self.mv_t = self.mv_t + 1
    elseif self.accel ~= 0 then
        self.spd = self.spd + self.accel
        object.SetV(self, self.spd, self.dir, false)
    end
end

---itemdrop：−2 = 不掉（DROP_FAITH[−2]/DROP_POINT[−2] 都是 nil ⇒ {0,0,0}）；
---0/1/2 交给框架的 self.drop；7 与 −1 在 kill 里自己撒（同 1/2 面）。
local function setdrop78(self, drop)
    self.dropcode = drop
    local f, p = DROP_FAITH[drop], DROP_POINT[drop]
    self.drop = { 0, f or 0, p or 0 }
end

local function drop78(self)
    if self.dropcode == 7 then
        New(item.obj.sakura, self.x, self.y)
    elseif self.dropcode == -1 and ran:Int(0, 2) == 0 then
        New(item.obj.faith, self.x, self.y)
    end
end

---th07 弹型索引 → 本仓库弹型代理（差异 62/63）。
local W78_BS = { [0] = ball_small, [1] = grain_a, [2] = grain_a, [3] = ball_small, [7] = arrow_small }
local function bs78(spr)
    return W78_BS[spr] or grain_a
end

---一条 SPREAD（base 用我们的角度制；a2_th 是 th07 的弧度，交给 spread3 取反）。
local function spread78(self, style, off, c1, c2, v1, v2, base, a2_th, plays)
    local offs = spread3(c1, a2_th * RAD2DEG)
    volley3(self, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        return style, col16(off), v1 - (v1 - v2) * layer / c2, base + offs[ring + 1]
    end, plays)
end

---一条 RING（base 用我们的角度制；层间偏移 −a2_th·RAD2DEG，见差异 20 的取反规则）。
local function ring78(self, style, off, c1, c2, v1, v2, base, a2_th, plays)
    local step = 360 / c1
    local a2 = -a2_th * RAD2DEG
    volley3(self, c1 * c2, function(i)
        local k = i - 1
        local layer, ring = int(k / c1), k % c1
        return style, col16(off), v1 - (v1 - v2) * layer / c2, base + ring * step + layer * a2
    end, plays)
end

---同上，但由 gen 自己 New（给带 INIT_BULLET_CMD 的 TH34_exbigbullet78 用）。
local function volley78(self, total, gen)
    local room = POOL4_SIZE - pool4_used()
    local i = 1
    while i <= total and room > 0 do
        pool4[#pool4 + 1] = gen(i)
        room, i = room - 1, i + 1
    end
    sound4(self)
end

---──────────────────── 开幕烟花的两段弹（原作 sub 52/53/54/55 的 INIT_BULLET_CMD） ────────────────────
---flags 0x2a8 同时命中了 0x20 与 0x80：弹上挂了两条命令，而 `RunCommands`
---每帧只启一条（BulletManager.cpp:351-445）⇒ 0x20 先起一帧、两条之后**同时**生效：
---  cmd0 = 0x20 TargetAngle：30 帧里每帧 angle += turn（本卡输入 6°/帧 ⇒ 半圈）、
---        速度增量 0（BulletManager.cpp:759-777）；
---  cmd1 = 0x80 DirChangeAim：60 帧里把速度从原速线性降到 0（每帧都用**原速**算，
---        所以不会滚雪球），第 61 帧把朝向改成「自机方向 + 0」、
---        速度设为 reaim 直飞（BulletManager.cpp:843-878）。
class["TH34_exbigbullet78"] = Class(bullet, {
    init = function(self, style, col, x, y, v, a, turn, reaim)
        bullet.init(self, style, col, false, true)
        self.x, self.y = x, y
        self.rot, self.spd = a, v
        self.turn, self.reaim = turn, reaim
        self.t0, self.t1 = 0, -1        -- t1 = −1 ⇒ 0x80 还没起步
        self.vx, self.vy = v * cos(a), v * sin(a)
    end,
    frame = function(self)
        if self.t0 < 30 then
            self.rot = self.rot + self.turn
            self.t0 = self.t0 + 1
        end
        if self.t1 >= 0 then
            if self.t1 < 60 then
                local spd = self.spd - self.t1 * self.spd / 60
                self.t1 = self.t1 + 1
                self.vx, self.vy = spd * cos(self.rot), spd * sin(self.rot)
                bullet.frame(self)
                return
            elseif self.t1 == 60 then
                self.t1 = 61
                self.rot = Angle(self, player)
                self.spd = self.reaim
            end
        else
            self.t1 = 0                   -- 第 2 帧起步
        end
        self.vx, self.vy = self.spd * cos(self.rot), self.spd * sin(self.rot)
        bullet.frame(self)
    end,
})

---──────────────────── 载体 + 烟尘（原作 sub 10/12/…/28、45/47/49 → sub 9） ────────────────────
---`puff` = { x0 偏移, y0 偏移, y 的 m0 }（都已换算成我们的坐标与符号）；
---`body_cls`/`body_cfg` 决定 80 帧后生出来的本体。
class["TH34_excarrier78"] = Class(enemy, {
    init = function(self, x, y, life, sub, mirror, drop, puff, body_cls, body_cfg)
        enemy.init(self, 27, 1, false, true, true)
        self.x, self.y = x, y
        self.A, self.B = 8, 8
        self.kind, self.mirror = sub, mirror or 0
        self.colli = false
        self.dropcode = drop
        self.hx, self.hy = x, y
        ---烟尘的 X 位移在 mirror 下整体取反（EnemyManager.hpp:79 的 Move() 把 velocity.x 取反，
        ---而 interp 写→pos 的改动又会被当成 velocity）；Y 不受影响。
        self.px0, self.px1 = ((mirror == 1) and -puff[1] or puff[1]), 0
        self.py0, self.py1 = puff[2], 0
        self.mx0, self.mx1 = rnd_sign() * 144, rnd_sign() * 144
        self.my0, self.my1 = puff[3], rnd_sign() * 32
        self.img = "ghost_fire_r"
        smear_add(self, 120)
        task.New(self, function()
            task.Wait(80)
            New(body_cls, self.x, self.y, life, body_cfg, 0, drop)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        local t = min(self.timer, 80) / 80
        self.x = self.hx + hermite(t, self.px0, self.px1, self.mx0, self.mx1)
        self.y = self.hy + hermite(t, self.py0, self.py1, self.my0, self.my1)
        object.smear_frame(self, TRAIL_DECAY)
    end,
    render = function(self)
        object.smear_render(self, "mul+add", { 190, 210, 255 })
        enemy.render(self)
    end,
    kill = function(self)
        enemy.kill(self)
    end,
})

---──────────────────── 打弹小精灵（原作 sub 11..29） ────────────────────
---cfg = { th, off, c1, c2, a2, spr, plays, rounds }。
class["TH34_exbody78"] = Class(enemy, {
    init = function(self, x, y, life, cfg, mirror, drop)
        enemy.init(self, 1, hp78(life), false, true, true)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.mirror = 0
        setdrop78(self, drop)
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        self.spd, self.accel, self.dir = 0, 0, d78(self, cfg.th)
        move78(self, 0, cfg.th, 0)          -- MOVE_DIR_TIME(0,0,θ,0)：只定朝向
        self.accel = 0.02                   -- SET_MOVE_ACCEL 0.02（匀加速直线）
        self.protect = true
        task.New(self, function()
            task.Wait(10)                   -- SET_INVINCIBILITY_TIMER 10
            self.protect = false
        end)
        task.New(self, function()
            for k = 0, cfg.rounds - 1 do
                if k > 0 then
                    task.Wait(4)            -- DEC_JUMP 落在 t=4
                end
                spread78(self, bs78(cfg.spr), cfg.off, cfg.c1, cfg.c2,
                         cfg.v1, cfg.v2, Angle(self, player), cfg.a2, cfg.plays)
            end
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        adv78(self)
    end,
    kill = function(self)
        New(class["TH34_flame"], self.x, self.y)   -- 原作 DEATH_CALLBACK_SUB 6
        drop78(self)
        enemy.kill(self)
    end,
})

---──────────────────── 中载体（原作 sub 30/33/36） ────────────────────
---cfg.kind == 30：t=fire_t 打一发 SPREAD_AIMED（a2=0）；33/36：每 interval 帧
---重打同一轮 RING_AIMED（首轮随机延迟，stop_t 停火）。wrapper 的死参数不实现。
local function mid78_fire(self, cfg)
    if cfg.kind == 30 then
        spread78(self, bs78(cfg.spr), cfg.off, cfg.c1, cfg.c2, cfg.v1, cfg.v2,
                 Angle(self, player), 0, true)
    else
        ring78(self, bs78(cfg.spr), cfg.off, cfg.c1, cfg.c2, cfg.v1, cfg.v2,
               Angle(self, player), 0, true)
    end
end

class["TH34_exmid78"] = Class(enemy, {
    init = function(self, x, y, life, cfg, mirror, drop)
        enemy.init(self, 24, hp78(life), false, true, true)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.mirror = mirror or 0
        setdrop78(self, drop)
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        self.spd, self.accel, self.dir = 0, 0, 0
        self.protect = true
        move78(self, cfg.move_n, cfg.move_th, cfg.move_spd)
        task.New(self, function()
            task.Wait(10)
            self.protect = false
        end)
        if cfg.kind == 30 then
            task.New(self, function()
                task.Wait(cfg.fire_t)
                mid78_fire(self, cfg)
                task.Wait(30)
                move78(self, 0, cfg.then_th, cfg.then_spd)
            end)
        else
            task.New(self, function()
                task.Wait(ran:Int(0, cfg.interval - 1))  -- SET_SHOOT_INTERVAL_RAND
                while self.timer < cfg.stop_t do
                    mid78_fire(self, cfg)
                    task.Wait(cfg.interval)
                end
            end)
        end
        task.New(self, function()
            task.Wait(cfg.life)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        adv78(self)
    end,
    kill = function(self)
        drop78(self)
        enemy.kill(self)
    end,
})

---──────────────────── 扫射载体（原作 sub 39/40，经 sub 41..44） ────────────────────
---t=t0 起每 4 帧一发 RING_ABS：a1 冻结成 t0 那一刻的自机角（原代码加的是 0），
---速度 = base_v + 累计 inc + rand(rnd)（原作 RAND_FLOAT_ADD 是**加**）。死时掉 6 信仰 + 3 点（DEATH_CALLBACK_SUB 0）。
class["TH34_exring78"] = Class(enemy, {
    init = function(self, x, y, life, cfg, mirror, drop)
        enemy.init(self, 24, hp78(life), false, true, true)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.mirror = mirror or 0
        setdrop78(self, drop)
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        self.spd, self.accel, self.dir = 0, 0, 0
        self.protect = true
        move78(self, cfg.move_n, 0, cfg.move_spd)
        task.New(self, function()
            task.Wait(cfg.invul)
            self.protect = false
        end)
        task.New(self, function()
            task.Wait(cfg.t0)
            local base = Angle(self, player)
            local v = cfg.base_v
            for _ = 1, cfg.rounds do
                ring78(self, bs78(2), 0, cfg.c1, 1, v + ran:Float(0, cfg.rnd), 1, base, 0, true)
                v = v + cfg.inc
                task.Wait(4)
            end
            move78(self, 0, cfg.then_th, cfg.then_spd)
        end)
        task.New(self, function()
            task.Wait(cfg.life)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        adv78(self)
    end,
    kill = function(self)
        scatter_items(item.obj.faith, 6, self.x, self.y)
        scatter_items(item.obj.point, 3, self.x, self.y)
        drop78(self)
        enemy.kill(self)
    end,
})

---──────────────────── 随机扫射本体（原作 sub 46/48/50） ────────────────────
---mode == "rand"：每 gap 帧一发 RING_ABS，v1 = rand(0,rnd)+base、a1 = rand[−π,π)；
---mode == "aim"：每 gap 帧一发 RING_AIMED（a1=0 ⇒ 每次重瞄自机）。
---循环打完 MOVE_DIR_TIME(0,0,−π/2,0) + SET_MOVE_ACCEL 0.02（转头向上）。
class["TH34_exbomb78"] = Class(enemy, {
    init = function(self, x, y, life, cfg, mirror, drop)
        enemy.init(self, 1, hp78(life), false, true, true)
        self.x, self.y = x, y
        self.A, self.B = 24, 24
        self.mirror = 0
        setdrop78(self, drop)
        self.mv_n, self.mv_t = 0, 0
        self.mv_x0, self.mv_y0, self.mv_dx, self.mv_dy = x, y, 0, 0
        self.spd, self.accel, self.dir = 0, 0, 0
        self.protect = true
        task.New(self, function()
            task.Wait(10)
            self.protect = false
        end)
        task.New(self, function()
            for k = 0, cfg.rounds - 1 do
                if k > 0 then
                    task.Wait(cfg.gap)
                end
                if cfg.mode == "rand" then
                    ring78(self, bs78(3), cfg.off, cfg.c1, 1,
                           ran:Float(0, cfg.rnd) + cfg.base, 1,
                           ran:Float(-180, 180), 0.628319, true)
                else
                    ring78(self, bs78(7), cfg.off, cfg.c1, 1, cfg.v1, 1,
                           Angle(self, player), 0.628319, true)
                end
            end
            task.Wait(cfg.gap)
            move78(self, 0, -1.5708, 0)
            self.accel = 0.02
        end)
        task.New(self, function()
            task.Wait(cfg.life)
            object.RawDel(self)
        end)
    end,
    frame = function(self)
        enemy.frame(self)
        adv78(self)
    end,
    kill = function(self)
        New(class["TH34_flame"], self.x, self.y)             -- DEATH_CALLBACK_SUB 7
        scatter_items(item.obj.faith, 4, self.x, self.y)
        scatter_items(item.obj.point, 3, self.x, self.y)
        drop78(self)
        enemy.kill(self)
    end,
})

---──────────────────── 开幕烟花（原作 sub 52/53/54/55） ────────────────────
---cfg = { turn, reaim, c1, v1, v2 }。
class["TH34_exbig78"] = Class(enemy, {
    init = function(self, x, y, life, cfg, mirror, drop)
        enemy.init(self, 27, 1, false, true, true)
        self.x, self.y = x, y
        self.A, self.B = 0, 0
        self.mirror = mirror or 0
        self.colli = false
        setdrop78(self, drop)
        ---t=0 的 8 次 SUB_CALL 51（差异 60：运行时八个偏移/角都是 0 ⇒ 八发重叠）
        for _ = 1, 8 do
            volley78(self, 1, function()
                return New(class["TH34_exbigbullet78"], bs78(0), col16(0), self.x, self.y,
                           2, 0, cfg.turn, cfg.reaim)
            end)
        end
        task.New(self, function()
            task.Wait(90)
            ---t=90 的 SPREAD_AIMED（flags 0x200 不含 0x20/0x80 ⇒ 不带命令）
            spread78(self, bs78(0), 6, cfg.c1, 3, cfg.v1, cfg.v2,
                     Angle(self, player), 0.03927, true)
            object.RawDel(self)                              -- t=90 的 UNIMP
        end)
    end,
    frame = function(self)
        enemy.frame(self)
    end,
    kill = function(self)
        enemy.kill(self)
    end,
})

---==================== 每面的参数（EX / PH 的同构差异全部集中在这里） ====================
---`ph == false` 是 EX（第 7 面）、`true` 是 PH（第 8 面）。两个面共用**同一批子程序号**，
---只有数值不同；下面每个数字都对着 /tmp/S7.txt、/tmp/S8.txt 的转储核过。
local function mk78(ph)
    ---烟尘（原作 sub 9 的两条 INIT_INTERP）的常量：{ X 的 p0、Y 的 p0、Y 的 m0 }。
    ---已换算成我们的坐标（th07 的 Y 取反；m0 是 25−1 / 17−1 ⇒ 24 / 16，同样取反）。
    ---X 的 m0/m1 一律 ±144（类里各掷一次），m1 的 Y 一律 ±32。
    local puff = ph and { 28, -160, -16 } or { -17, -179, -24 }

    ---打弹本体 sub 11..29：th07 的角度 θ（弧度）、spriteOffset、count1/2、a2。
    ---一律 v1=5、v2=1、a1=0（每轮重瞄自机）、间隔 4 帧、出生无敌 10 帧。
    local B = {
        [11] = { th = 0.0,     off = 2, c1 = 1, c2 = 1, a2 = 1.5708,   spr = 1, rounds = 32 },
        [13] = { th = 3.14159, off = 6, c1 = 1, c2 = 1, a2 = 1.5708,   spr = 1, rounds = 32 },
        [15] = { th = 0.0,     off = 2, c1 = 2, c2 = 1, a2 = 0.628319, spr = 1, rounds = 32 },
        [17] = { th = 3.14159, off = 6, c1 = 2, c2 = 1, a2 = 0.628319, spr = 1, rounds = 32 },
        [19] = { th = 0.0,     off = 2, c1 = 3, c2 = 1, a2 = 0.628319, spr = 1, rounds = 32 },
        [21] = { th = 3.14159, off = 6, c1 = 3, c2 = 1, a2 = 0.628319, spr = 1, rounds = 32 },
        [23] = { th = 0.0,     off = 2, c1 = 1, c2 = 1, a2 = 1.5708,   spr = 1, rounds = 12 },
        [25] = { th = 3.14159, off = 6, c1 = 1, c2 = 1, a2 = 1.5708,   spr = 1, rounds = 12 },
        [27] = { th = 0.0,     off = 2, c1 = 2, c2 = 1, a2 = 0.628319, spr = 1, rounds = 12 },
        [29] = { th = 3.14159, off = 6, c1 = 2, c2 = 1, a2 = 0.628319, spr = 1, rounds = 12 },
    }
    if ph then
        B[15].a2, B[17].a2 = 0.897598, 0.897598
        B[19].off, B[19].c1, B[19].spr = 1, 5, 7
        B[21].off, B[21].c1, B[21].spr = 3, 5, 7
    end
    for _, b in pairs(B) do b.v1, b.v2 = 5, 1 end

    ---中载体 sub 30/33/36（经 wrapper 31/32、34/35、37/38 **原地**展开，不新开敌人）。
    ---30：60 帧 ease-out 漂 120 px（θ=1.76715、速 2），t=60 打一发「速度墙」SPREAD，
    ---t=90 改 POLAR（θ=0.392699、速 3），t=2090 自毁。
    ---33/36：POLAR 沿 +x 速 5 平移，每 5 帧重瞄自机打一轮 RING（首轮随机延迟），
    ---t=120 停火、t=2120 自毁；a2=0 ⇒ 每层 count1 发完全重叠，就是一道「速度墙」。
    local M = {
        [30] = { kind = 30, move_n = 60, move_th = 1.76715, move_spd = 2,
                 fire_t = 60, then_th = 0.392699, then_spd = 3, life = 2090,
                 spr = 3, off = 0, c1 = 5, c2 = 3, v1 = 4, v2 = 1, a2 = 0 },
        [33] = { kind = 33, move_n = 0, move_th = 0, move_spd = 5,
                 interval = 5, stop_t = 120, life = 2120,
                 spr = 0, off = 0, c1 = 4, c2 = 5, v1 = 4, v2 = 1, a2 = 0 },
        [36] = { kind = 33, move_n = 0, move_th = 0, move_spd = 5,
                 interval = 5, stop_t = 120, life = 2120,
                 spr = 0, off = 0, c1 = 6, c2 = 4, v1 = 4, v2 = 1, a2 = 0 },
    }
    if ph then
        M[30].v1 = 5
        M[33].c1, M[33].v1 = 5, 6
        M[36].v1 = 6
    end

    ---扫射载体 sub 39/40（经 wrapper 41/42、43/44 原地展开）：静立 t0 帧后每 4 帧一发
    ---RING_ABS，a1 冻结成 t0 那一刻的自机角，速度 = base_v + 累计 inc + rand(rnd)
    ---（原作 RAND_FLOAT_ADD 是**加**）。死时掉 6 信仰 + 3 点（DEATH_CALLBACK_SUB 0）。
    local R = {
        [39] = { move_n = 60, move_spd = 2, invul = 40, t0 = 60,
                 base_v = 1, rnd = 0.8, inc = 0.046875, rounds = 32, c1 = 6,
                 then_th = 1.5708, then_spd = 2, life = 2064 },
        [40] = { move_n = 60, move_spd = 2, invul = 40, t0 = 60,
                 base_v = 1, rnd = 0.8, inc = 0.046875, rounds = 24, c1 = 3,
                 then_th = 0.392699, then_spd = 2, life = 2062 },
    }
    if ph then
        R[39].move_n, R[39].invul, R[39].t0 = 40, 30, 40
        R[39].base_v, R[39].rnd, R[39].inc = 2.5, 1.5, 0.078125
        R[39].life = 2044
        R[40].move_n, R[40].invul, R[40].t0 = 40, 30, 40
        R[40].base_v, R[40].rnd, R[40].inc = 2.5, 1.5, 0.078125
        R[40].c1, R[40].life = 4, 2042
    end

    ---随机扫射本体 sub 46/48/50（经载体 45/47/49，载体 life=400 ⇒ 39 点血）。
    ---46/50 = 每 gap 帧一发 RING_ABS（v1 = rand(0,rnd)+base、a1 = rand[−π,π)，
    ---RNG_CUSTOM_BOUND / RNG_RADIAN 都在 EclManager.cpp:466-472 定义）；
    ---48 = 每 60 帧一发 RING_AIMED（v1=2/3、spr=7）。三条打完都转头向上。
    local K = {
        [46] = { mode = "rand", gap = 4, off = 14, c1 = 5, rnd = 2, base = 0.3,
                 rounds = 50, spr = 3, life = 3004 },
        [48] = { mode = "aim", gap = 60, off = 3, c1 = 6, v1 = 2,
                 rounds = 3, spr = 7, life = 3060 },
        [50] = { mode = "rand", gap = 4, off = 12, c1 = 5, rnd = 2, base = 0.3,
                 rounds = 50, spr = 3, life = 3004 },
    }
    if ph then
        K[46].gap, K[46].rnd, K[46].base, K[46].rounds, K[46].life = 3, 3, 2, 60, 3003
        K[48].v1 = 3
        K[50].rnd = 3
    end

    ---开幕烟花 sub 52/53（PH 另有 54/55）：t=0 八次 SUB_CALL 51（运行时八个偏移全是 0
    ---⇒ 八发重叠，差异 60）、t=90 再打一发 SPREAD_AIMED 就 UNIMP。
    ---turn 已换成我们的角度制（th07 的 −0.10472 rad ⇒ +6°）。
    local G = {
        [52] = { turn = 6,  reaim = 4, c1 = 5, v1 = 5, v2 = 2 },
        [53] = { turn = -6, reaim = 4, c1 = 5, v1 = 5, v2 = 2 },
    }
    if ph then
        G[54] = { turn = 6,  reaim = 7, c1 = 4, v1 = 7, v2 = 3 }
        G[55] = { turn = -6, reaim = 7, c1 = 4, v1 = 7, v2 = 3 }
    end

    ---子程序号 → 类 + 配置：载体类多带一份 puff 和「80 帧后生出来的本体」。
    local W = {}
    for _, s in ipairs({ 10, 12, 14, 16, 18, 20, 22, 24, 26, 28 }) do
        W[s] = { cls = "TH34_excarrier78", puff = puff, body = "TH34_exbody78", cfg = B[s + 1] }
    end
    for _, s in ipairs({ 45, 47, 49 }) do
        W[s] = { cls = "TH34_excarrier78", puff = puff, body = "TH34_exbomb78", cfg = K[s + 1] }
    end
    W[31] = { cls = "TH34_exmid78", cfg = M[30] }
    W[32] = { cls = "TH34_exmid78", cfg = M[30] }
    W[34] = { cls = "TH34_exmid78", cfg = M[33] }
    W[35] = { cls = "TH34_exmid78", cfg = M[33] }
    W[37] = { cls = "TH34_exmid78", cfg = M[36] }
    W[38] = { cls = "TH34_exmid78", cfg = M[36] }
    W[41] = { cls = "TH34_exring78", cfg = R[39] }
    W[42] = { cls = "TH34_exring78", cfg = R[39] }
    W[43] = { cls = "TH34_exring78", cfg = R[40] }
    W[44] = { cls = "TH34_exring78", cfg = R[40] }
    for _, s in ipairs({ 52, 53 }) do
        W[s] = { cls = "TH34_exbig78", cfg = G[s] }
    end
    if ph then
        W[54] = { cls = "TH34_exbig78", cfg = G[54] }
        W[55] = { cls = "TH34_exbig78", cfg = G[55] }
    end
    return W
end

---波表的一行 → New。w = { 距上一只的帧数, sub, x, y, drop, life, mirror }。
---（载体的额外参数是 puff / 本体类 / 本体配置；其余类的额外参数只有 cfg。）
local function spawn78(W, w)
    local e = W[w[2]]
    if e.puff then
        New(class[e.cls], w[3], w[4], w[6], w[2], w[7], w[5], e.puff, class[e.body], e.cfg)
    else
        New(class[e.cls], w[3], w[4], w[6], e.cfg, w[7], w[5])
    end
end

    local W7 = {
--- W7 : 282 rows（已剔掉道中 boss 占位）
        {     0,  10, -128.00,   96.00,    0,    10, 0 },  -- t=545
        {     0,  10, -112.00,  128.00,    0,    10, 0 },  -- t=545
        {     0,  10,  -96.00,  160.00,    0,    10, 0 },  -- t=545
        {     0,  10,  -80.00,  192.00,    0,    10, 0 },  -- t=545
        {     0,  12,  128.00,   96.00,    0,    10, 0 },  -- t=545
        {     0,  12,  112.00,  128.00,    0,    10, 0 },  -- t=545
        {     0,  12,   96.00,  160.00,    0,    10, 0 },  -- t=545
        {     0,  12,   80.00,  192.00,    0,    10, 0 },  -- t=545
        {   200,  14, -128.00,   96.00,    0,    10, 0 },  -- t=745
        {     0,  14, -112.00,  128.00,    0,    10, 0 },  -- t=745
        {     0,  14,  -96.00,  160.00,    0,    10, 0 },  -- t=745
        {     0,  14,  -80.00,  192.00,    2,    10, 0 },  -- t=745
        {     0,  16,  128.00,   96.00,    0,    10, 0 },  -- t=745
        {     0,  16,  112.00,  128.00,    0,    10, 0 },  -- t=745
        {     0,  16,   96.00,  160.00,    0,    10, 0 },  -- t=745
        {     0,  16,   80.00,  192.00,    2,    10, 0 },  -- t=745
        {   350,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1095
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1105
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1115
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1125
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1135
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1145
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1155
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1165
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1175
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1185
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1195
        {    80,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1275
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1285
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1295
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1305
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1315
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1325
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1335
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1345
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1355
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1365
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1375
        {   120,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1495
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1505
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1515
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1525
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1535
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1545
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1555
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1565
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1575
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1585
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1595
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1605
        {   180,  31,   96.00,  256.00,    0,    30, 1 },  -- t=1785
        {    10,  32,  160.00,  256.00,    0,    30, 1 },  -- t=1795
        {    10,  31,   32.00,  256.00,    0,    30, 1 },  -- t=1805
        {    10,  32,  128.00,  256.00,    0,    60, 1 },  -- t=1815
        {    10,  31,  -64.00,  256.00,    0,    40, 1 },  -- t=1825
        {    10,  32,   64.00,  256.00,    0,    60, 1 },  -- t=1835
        {    10,  31, -160.00,  256.00,    2,    50, 1 },  -- t=1845
        {    10,  32,    0.00,  256.00,    7,    60, 1 },  -- t=1855
        {    10,  31,  -96.00,  256.00,    7,    80, 1 },  -- t=1865
        {    10,  32,  -32.00,  256.00,    7,    60, 1 },  -- t=1875
        {    10,  31,    0.00,  256.00,    7,    30, 1 },  -- t=1885
        {    10,  32, -128.00,  256.00,    2,   100, 1 },  -- t=1895
        {   120,  31,  -96.00,  256.00,    0,    30, 0 },  -- t=2015
        {    10,  32, -160.00,  256.00,    0,    30, 0 },  -- t=2025
        {    10,  31,  -32.00,  256.00,    0,    30, 0 },  -- t=2035
        {    10,  32, -128.00,  256.00,    0,    60, 0 },  -- t=2045
        {    10,  31,   64.00,  256.00,    0,    40, 0 },  -- t=2055
        {    10,  32,  -64.00,  256.00,    0,    60, 0 },  -- t=2065
        {    10,  31,  160.00,  256.00,    2,    50, 0 },  -- t=2075
        {    10,  32,    0.00,  256.00,    7,    60, 0 },  -- t=2085
        {    10,  31,   96.00,  256.00,    7,    80, 0 },  -- t=2095
        {    10,  32,   32.00,  256.00,    7,    60, 0 },  -- t=2105
        {    10,  31,    0.00,  256.00,    7,    30, 0 },  -- t=2115
        {    10,  32,  128.00,  256.00,    2,    60, 0 },  -- t=2125
        {   100,  31,   96.00,  256.00,    0,    30, 1 },  -- t=2225
        {    10,  32,  160.00,  256.00,    0,    30, 1 },  -- t=2235
        {    10,  31,   32.00,  256.00,    0,    30, 1 },  -- t=2245
        {    10,  32,  128.00,  256.00,    0,    60, 1 },  -- t=2255
        {    10,  31,  -64.00,  256.00,    0,    40, 1 },  -- t=2265
        {    10,  32,   64.00,  256.00,    0,    60, 1 },  -- t=2275
        {    10,  31, -160.00,  256.00,    2,    50, 1 },  -- t=2285
        {    10,  32,    0.00,  256.00,    7,    60, 1 },  -- t=2295
        {    10,  31,  -96.00,  256.00,    7,    80, 1 },  -- t=2305
        {    10,  32,  -32.00,  256.00,    7,    60, 1 },  -- t=2315
        {    10,  31,    0.00,  256.00,    7,    30, 1 },  -- t=2325
        {    10,  32, -128.00,  256.00,    2,    60, 1 },  -- t=2335
        {    50,  31,  -96.00,  256.00,    0,    30, 0 },  -- t=2385
        {    10,  32, -160.00,  256.00,    0,    30, 0 },  -- t=2395
        {    10,  31,  -32.00,  256.00,    0,    30, 0 },  -- t=2405
        {    10,  32, -128.00,  256.00,    2,    60, 0 },  -- t=2415
        {    10,  31,   64.00,  256.00,    2,    40, 0 },  -- t=2425
        {    10,  32,  -64.00,  256.00,    2,    60, 0 },  -- t=2435
        {    10,  31,  160.00,  256.00,    2,    50, 0 },  -- t=2445
        {    10,  32,    0.00,  256.00,    7,    60, 0 },  -- t=2455
        {    10,  31,   96.00,  256.00,    7,    80, 0 },  -- t=2465
        {    10,  32,   32.00,  256.00,    7,    60, 0 },  -- t=2475
        {    10,  31,    0.00,  256.00,    7,    30, 0 },  -- t=2485
        {    10,  32,  128.00,  256.00,    2,    60, 0 },  -- t=2495
        {   180,  41,  -96.00,  256.00,    0,   160, 0 },  -- t=2675
        {     0,  41,   96.00,  256.00,    0,   160, 1 },  -- t=2675
        {   120,  42, -128.00,  256.00,    0,   160, 0 },  -- t=2795
        {   100,  42,  128.00,  256.00,    0,   160, 1 },  -- t=2895
        {   100,  41, -128.00,  256.00,    0,   160, 0 },  -- t=2995
        {    80,  41,  128.00,  256.00,    0,   160, 1 },  -- t=3075
        {    80,  42,  -64.00,  256.00,    0,   160, 0 },  -- t=3155
        {    30,  42,   64.00,  256.00,    0,   160, 1 },  -- t=3185
        {   180,  43, -128.00,  256.00,    0,   160, 0 },  -- t=3365
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=3365
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=3365
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=3365
        {   100,  44,  128.00,  256.00,    0,   160, 1 },  -- t=3465
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=3465
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=3465
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=3465
        {   100,  43, -128.00,  256.00,    0,   160, 0 },  -- t=3565
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=3565
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=3565
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=3565
        {   100,  44,  128.00,  256.00,    0,   160, 1 },  -- t=3665
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=3665
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=3665
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=3665
        {   200,  18, -128.00,   96.00,    0,    10, 0 },  -- t=3865
        {     0,  18, -112.00,  128.00,    0,    10, 0 },  -- t=3865
        {     0,  18,  -96.00,  160.00,    0,    10, 0 },  -- t=3865
        {     0,  18,  -80.00,  192.00,    0,    10, 0 },  -- t=3865
        {     0,  20,  128.00,   96.00,    0,    10, 0 },  -- t=3865
        {     0,  20,  112.00,  128.00,    0,    10, 0 },  -- t=3865
        {     0,  20,   96.00,  160.00,    0,    10, 0 },  -- t=3865
        {     0,  20,   80.00,  192.00,    0,    10, 0 },  -- t=3865
        {    23,  22, -128.00,   96.00,    0,    80, 0 },  -- t=4088
        {    80,  24,  128.00,   96.00,    0,    80, 0 },  -- t=4168
        {     0,  43, -128.00,  256.00,    0,   160, 0 },  -- t=4168
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=4168
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=4168
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=4168
        {    80,  22, -112.00,  128.00,    0,    80, 0 },  -- t=4248
        {    80,  24,  112.00,  128.00,    0,    80, 0 },  -- t=4328
        {    80,  26,  -96.00,  160.00,    0,    80, 0 },  -- t=4408
        {    80,  28,   96.00,  160.00,    0,    80, 0 },  -- t=4488
        {    80,  22,  -80.00,  192.00,    0,    80, 0 },  -- t=4568
        {    80,  24,   80.00,  192.00,    0,    80, 0 },  -- t=4648
        {     0,  44,  128.00,  256.00,    0,   160, 1 },  -- t=4648
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=4648
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=4648
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=4648
        {    80,  22, -128.00,   96.00,    0,    80, 0 },  -- t=4728
        {    80,  24,  128.00,   96.00,    0,    80, 0 },  -- t=4808
        {    80,  22, -112.00,  128.00,    0,    80, 0 },  -- t=4888
        {    80,  24,  112.00,  128.00,    0,    80, 0 },  -- t=4968
        {     0,  43, -128.00,  256.00,    0,   160, 0 },  -- t=4968
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=4968
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=4968
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=4968
        {    80,  26,  -96.00,  160.00,    0,    80, 0 },  -- t=5048
        {    80,  28,   96.00,  160.00,    0,    80, 0 },  -- t=5128
        {     0,  44,  128.00,  256.00,    0,   160, 1 },  -- t=5128
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=5128
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=5128
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=5128
        {    80,  18,  -80.00,  192.00,    0,    80, 0 },  -- t=5208
        {    80,  20,   80.00,  192.00,    0,    80, 0 },  -- t=5288
        {   200,  34,  224.00,  128.00,    0,    10, 1 },  -- t=5488
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=5498
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=5508
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=5518
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=5528
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=5538
        {    10,  34,  224.00,  128.00,    1,    10, 1 },  -- t=5548
        {    10,  35,  224.00,  128.00,    1,    10, 1 },  -- t=5558
        {    10,  34,  224.00,  128.00,    1,    10, 1 },  -- t=5568
        {    10,  35,  224.00,  128.00,    1,    10, 1 },  -- t=5578
        {    10,  34,  224.00,  128.00,    1,    10, 1 },  -- t=5588
        {    60,  34, -224.00,  128.00,    0,    10, 0 },  -- t=5648
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=5658
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=5668
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=5678
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=5688
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=5698
        {    10,  34, -224.00,  128.00,    1,    10, 0 },  -- t=5708
        {    10,  35, -224.00,  128.00,    1,    10, 0 },  -- t=5718
        {    10,  34, -224.00,  128.00,    1,    10, 0 },  -- t=5728
        {    10,  35, -224.00,  128.00,    1,    10, 0 },  -- t=5738
        {    10,  34, -224.00,  128.00,    1,    10, 0 },  -- t=5748
        {   120,  45, -160.00,  192.00,    0,   400, 0 },  -- t=5868
        {    40,  47,  128.00,  128.00,    0,   400, 0 },  -- t=5908
        {    40,  49,   64.00,   96.00,    0,   400, 0 },  -- t=5948
        {    40,  49, -128.00,  160.00,    0,   400, 0 },  -- t=5988
        {    40,  45,  -64.00,  144.00,    0,   400, 0 },  -- t=6028
        {    40,  47,  128.00,  128.00,    0,   400, 0 },  -- t=6068
        {    40,  45,   64.00,   96.00,    0,   400, 0 },  -- t=6108
        {    40,  49, -128.00,  160.00,    0,   400, 0 },  -- t=6148
        {    40,  45,  -64.00,  144.00,    0,   400, 0 },  -- t=6188
        {   400,  37, -224.00,  128.00,    0,    10, 0 },  -- t=6588
        {    10,  38, -224.00,  128.00,    0,    10, 0 },  -- t=6598
        {    10,  37, -224.00,  128.00,    0,    10, 0 },  -- t=6608
        {    10,  38, -224.00,  128.00,    0,    10, 0 },  -- t=6618
        {    10,  37, -224.00,  128.00,    0,    10, 0 },  -- t=6628
        {    10,  38, -224.00,  128.00,    0,    10, 0 },  -- t=6638
        {    10,  37, -224.00,  128.00,    1,    10, 0 },  -- t=6648
        {    10,  38, -224.00,  128.00,    1,    10, 0 },  -- t=6658
        {    10,  37, -224.00,  128.00,    1,    10, 0 },  -- t=6668
        {    10,  38, -224.00,  128.00,    1,    10, 0 },  -- t=6678
        {    10,  37, -224.00,  128.00,    1,    10, 0 },  -- t=6688
        {    60,  37,  224.00,  128.00,    0,    10, 1 },  -- t=6748
        {    10,  38,  224.00,  128.00,    0,    10, 1 },  -- t=6758
        {    10,  37,  224.00,  128.00,    0,    10, 1 },  -- t=6768
        {    10,  38,  224.00,  128.00,    0,    10, 1 },  -- t=6778
        {    10,  37,  224.00,  128.00,    0,    10, 1 },  -- t=6788
        {    10,  38,  224.00,  128.00,    0,    10, 1 },  -- t=6798
        {    10,  37,  224.00,  128.00,    1,    10, 1 },  -- t=6808
        {    10,  38,  224.00,  128.00,    1,    10, 1 },  -- t=6818
        {    10,  37,  224.00,  128.00,    1,    10, 1 },  -- t=6828
        {    10,  38,  224.00,  128.00,    1,    10, 1 },  -- t=6838
        {    10,  37,  224.00,  128.00,    1,    10, 1 },  -- t=6848
        {   300,  52,    0.00,   96.00,   -2,    10, 0 },  -- t=7148
        {    60,  52,  -64.00,   96.00,   -2,    10, 0 },  -- t=7208
        {     0,  53,   64.00,   96.00,   -2,    10, 1 },  -- t=7208
        {    60,  52,  -96.00,   96.00,   -2,    10, 0 },  -- t=7268
        {     0,  53,  -48.00,   96.00,   -2,    10, 0 },  -- t=7268
        {     0,  52,   48.00,   96.00,   -2,    10, 1 },  -- t=7268
        {     0,  53,   96.00,   96.00,   -2,    10, 1 },  -- t=7268
        {   250,  52, -160.00,  192.00,   -2,    10, 0 },  -- t=7518
        {    10,  53, -128.00,  208.00,   -2,    10, 0 },  -- t=7528
        {    10,  52,  -96.00,  192.00,   -2,    10, 0 },  -- t=7538
        {    10,  53,  -64.00,  208.00,   -2,    10, 0 },  -- t=7548
        {    10,  52,  -32.00,  192.00,   -2,    10, 0 },  -- t=7558
        {    10,  53,    0.00,  208.00,   -2,    10, 0 },  -- t=7568
        {    10,  52,   32.00,  192.00,   -2,    10, 0 },  -- t=7578
        {    10,  53,   64.00,  208.00,   -2,    10, 0 },  -- t=7588
        {    10,  52,   96.00,  192.00,   -2,    10, 0 },  -- t=7598
        {    60,  52,  164.00,  192.00,   -2,    10, 0 },  -- t=7658
        {    10,  53,  132.00,  160.00,   -2,    10, 0 },  -- t=7668
        {    10,  52,  100.00,  130.00,   -2,    10, 0 },  -- t=7678
        {    10,  53,   68.00,  102.00,   -2,    10, 0 },  -- t=7688
        {    10,  52,   36.00,   76.00,   -2,    10, 0 },  -- t=7698
        {    10,  53,    4.00,   52.00,   -2,    10, 0 },  -- t=7708
        {    10,  52,  -28.00,   30.00,   -2,    10, 0 },  -- t=7718
        {    10,  53,  -60.00,   10.00,   -2,    10, 0 },  -- t=7728
        {    10,  52,  -92.00,   -8.00,   -2,    10, 0 },  -- t=7738
        {    60,  52, -160.00,   32.00,   -2,    10, 0 },  -- t=7798
        {    10,  53, -128.00,   48.00,   -2,    10, 0 },  -- t=7808
        {    10,  52,  -96.00,   32.00,   -2,    10, 0 },  -- t=7818
        {    10,  53,  -64.00,   48.00,   -2,    10, 0 },  -- t=7828
        {    10,  52,  -32.00,   32.00,   -2,    10, 0 },  -- t=7838
        {    10,  52,    0.00,   32.00,   -2,    10, 0 },  -- t=7848
        {    10,  53,  -32.00,   64.00,   -2,    10, 0 },  -- t=7858
        {     0,  53,   32.00,   64.00,   -2,    10, 0 },  -- t=7858
        {     0,  53,  -32.00,    0.00,   -2,    10, 0 },  -- t=7858
        {     0,  53,   32.00,    0.00,   -2,    10, 0 },  -- t=7858
        {    10,  52,  -64.00,   96.00,   -2,    10, 0 },  -- t=7868
        {     0,  52,   64.00,   96.00,   -2,    10, 0 },  -- t=7868
        {     0,  52,  -64.00,  -32.00,   -2,    10, 0 },  -- t=7868
        {     0,  52,   64.00,  -32.00,   -2,    10, 0 },  -- t=7868
        {    10,  53,  -96.00,  128.00,   -2,    10, 0 },  -- t=7878
        {     0,  53,   96.00,  128.00,   -2,    10, 0 },  -- t=7878
        {     0,  53,  -96.00,  -64.00,   -2,    10, 0 },  -- t=7878
        {     0,  53,   96.00,  -64.00,   -2,    10, 0 },  -- t=7878
        {    10,  52, -128.00,  160.00,   -2,    10, 0 },  -- t=7888
        {     0,  52,  128.00,  160.00,   -2,    10, 0 },  -- t=7888
        {     0,  52, -128.00,  -96.00,   -2,    10, 0 },  -- t=7888
        {     0,  52,  128.00,  -96.00,   -2,    10, 0 },  -- t=7888
        {    10,  53, -160.00,  192.00,   -2,    10, 0 },  -- t=7898
        {     0,  53,  160.00,  192.00,   -2,    10, 0 },  -- t=7898
        {     0,  53, -160.00, -128.00,   -2,    10, 0 },  -- t=7898
        {     0,  53,  160.00, -128.00,   -2,    10, 0 },  -- t=7898
        {   200,  53, -160.00,  192.00,   -2,    10, 0 },  -- t=8098
        {     0,  53,  160.00,  192.00,   -2,    10, 1 },  -- t=8098
        {     0,  53, -160.00, -192.00,   -2,    10, 0 },  -- t=8098
        {     0,  53,  160.00, -192.00,   -2,    10, 1 },  -- t=8098
        {   100,  53, -160.00,    0.00,   -2,    10, 0 },  -- t=8198
        {     0,  53,  160.00,    0.00,   -2,    10, 1 },  -- t=8198
        {     0,  53,    0.00,  192.00,   -2,    10, 0 },  -- t=8198
        {     0,  53,    0.00, -192.00,   -2,    10, 1 },  -- t=8198
        {   100,  53, -160.00,  192.00,   -2,    10, 0 },  -- t=8298
        {     0,  53,  160.00,  192.00,   -2,    10, 1 },  -- t=8298
        {     0,  53, -160.00, -192.00,   -2,    10, 0 },  -- t=8298
        {     0,  53,  160.00, -192.00,   -2,    10, 1 },  -- t=8298
        {     0,  53, -160.00,    0.00,   -2,    10, 0 },  -- t=8298
        {     0,  53,  160.00,    0.00,   -2,    10, 1 },  -- t=8298
        {     0,  53,    0.00,  192.00,   -2,    10, 0 },  -- t=8298
        {     0,  53,    0.00, -192.00,   -2,    10, 1 },  -- t=8298
    }

    local W8 = {
--- W8 : 372 rows（已剔掉道中 boss 占位）
        {     0,  10, -128.00,   96.00,    0,    10, 0 },  -- t=545
        {     0,  10, -112.00,  128.00,    0,    10, 0 },  -- t=545
        {     0,  10,  -96.00,  160.00,    0,    10, 0 },  -- t=545
        {     0,  10,  -80.00,  192.00,    0,    10, 0 },  -- t=545
        {     0,  12,  128.00,   96.00,    0,    10, 0 },  -- t=545
        {     0,  12,  112.00,  128.00,    0,    10, 0 },  -- t=545
        {     0,  12,   96.00,  160.00,    0,    10, 0 },  -- t=545
        {     0,  12,   80.00,  192.00,    0,    10, 0 },  -- t=545
        {   100,  14, -128.00,   96.00,    0,    10, 0 },  -- t=645
        {     0,  14, -112.00,  128.00,    1,    10, 0 },  -- t=645
        {     0,  14,  -96.00,  160.00,    0,    10, 0 },  -- t=645
        {     0,  14,  -80.00,  192.00,    1,    10, 0 },  -- t=645
        {     0,  16,  128.00,   96.00,    0,    10, 0 },  -- t=645
        {     0,  16,  112.00,  128.00,    1,    10, 0 },  -- t=645
        {     0,  16,   96.00,  160.00,    0,    10, 0 },  -- t=645
        {     0,  16,   80.00,  192.00,    1,    10, 0 },  -- t=645
        {    80,  14, -128.00,   96.00,    0,    10, 0 },  -- t=725
        {     0,  14, -112.00,  128.00,    0,    10, 0 },  -- t=725
        {     0,  14,  -96.00,  160.00,    0,    10, 0 },  -- t=725
        {     0,  14,  -80.00,  192.00,    2,    10, 0 },  -- t=725
        {     0,  16,  128.00,   96.00,    0,    10, 0 },  -- t=725
        {     0,  16,  112.00,  128.00,    0,    10, 0 },  -- t=725
        {     0,  16,   96.00,  160.00,    0,    10, 0 },  -- t=725
        {     0,  16,   80.00,  192.00,    2,    10, 0 },  -- t=725
        {    50,  10, -128.00,   96.00,    1,    10, 0 },  -- t=775
        {     0,  10, -112.00,  128.00,    1,    10, 0 },  -- t=775
        {     0,  10,  -96.00,  160.00,    1,    10, 0 },  -- t=775
        {     0,  10,  -80.00,  192.00,    1,    10, 0 },  -- t=775
        {     0,  12,  128.00,   96.00,    1,    10, 0 },  -- t=775
        {     0,  12,  112.00,  128.00,    1,    10, 0 },  -- t=775
        {     0,  12,   96.00,  160.00,    1,    10, 0 },  -- t=775
        {     0,  12,   80.00,  192.00,    1,    10, 0 },  -- t=775
        {   250,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1025
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1033
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1041
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1049
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1057
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1065
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1073
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1081
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1089
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1097
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1105
        {    70,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1175
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1183
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1191
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1199
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1207
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1215
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1223
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1231
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1239
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1247
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1255
        {    54,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1309
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1317
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1325
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1333
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1341
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1349
        {     8,  35,  224.00,  128.00,    0,    10, 1 },  -- t=1357
        {     8,  34,  224.00,  128.00,    0,    10, 1 },  -- t=1365
        {    54,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1419
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1427
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1435
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1443
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1451
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1459
        {     8,  34, -224.00,  128.00,    0,    10, 0 },  -- t=1467
        {     8,  35, -224.00,  128.00,    0,    10, 0 },  -- t=1475
        {   180,  31,  -96.00,  256.00,    0,    30, 0 },  -- t=1655
        {    10,  32, -160.00,  256.00,    0,    30, 0 },  -- t=1665
        {    10,  31,  -32.00,  256.00,    0,    30, 0 },  -- t=1675
        {    10,  32, -128.00,  256.00,    0,    60, 0 },  -- t=1685
        {    10,  31,   64.00,  256.00,    0,    40, 0 },  -- t=1695
        {    10,  32,  -64.00,  256.00,    0,    60, 0 },  -- t=1705
        {    10,  31,  160.00,  256.00,    2,    50, 0 },  -- t=1715
        {    10,  32,    0.00,  256.00,    7,    60, 0 },  -- t=1725
        {    10,  31,   96.00,  256.00,    7,    80, 0 },  -- t=1735
        {    10,  32,   32.00,  256.00,    7,    60, 0 },  -- t=1745
        {    10,  31,    0.00,  256.00,    7,    30, 0 },  -- t=1755
        {    10,  32,  128.00,  256.00,    2,    60, 0 },  -- t=1765
        {     0,  32,    0.00,  256.00,    2,    60, 0 },  -- t=1765
        {     0,  32, -128.00,  256.00,    2,    60, 0 },  -- t=1765
        {   120,  31,   96.00,  256.00,    0,    30, 1 },  -- t=1885
        {    10,  32,  160.00,  256.00,    0,    30, 1 },  -- t=1895
        {    10,  31,   32.00,  256.00,    0,    30, 1 },  -- t=1905
        {    10,  32,  128.00,  256.00,    0,    60, 1 },  -- t=1915
        {    10,  31,  -64.00,  256.00,    0,    40, 1 },  -- t=1925
        {    10,  32,   64.00,  256.00,    0,    60, 1 },  -- t=1935
        {    10,  31, -160.00,  256.00,    2,    50, 1 },  -- t=1945
        {    10,  32,    0.00,  256.00,    7,    60, 1 },  -- t=1955
        {    10,  31,  -96.00,  256.00,    7,    80, 1 },  -- t=1965
        {    10,  32,  -32.00,  256.00,    7,    60, 1 },  -- t=1975
        {    10,  31,    0.00,  256.00,    7,    30, 1 },  -- t=1985
        {    10,  32, -128.00,  256.00,    2,   100, 1 },  -- t=1995
        {     0,  32,    0.00,  256.00,    2,    60, 1 },  -- t=1995
        {     0,  32,  128.00,  256.00,    2,    60, 1 },  -- t=1995
        {   100,  31,   96.00,  256.00,    0,    30, 1 },  -- t=2095
        {    10,  32,  160.00,  256.00,    0,    30, 1 },  -- t=2105
        {    10,  31,   32.00,  256.00,    0,    30, 1 },  -- t=2115
        {    10,  32,  128.00,  256.00,    0,    60, 1 },  -- t=2125
        {    10,  31,  -64.00,  256.00,    0,    40, 1 },  -- t=2135
        {    10,  32,   64.00,  256.00,    0,    60, 1 },  -- t=2145
        {    10,  31, -160.00,  256.00,    2,    50, 1 },  -- t=2155
        {    10,  32,    0.00,  256.00,    7,    60, 1 },  -- t=2165
        {    10,  31,  -96.00,  256.00,    7,    80, 1 },  -- t=2175
        {    10,  32,  -32.00,  256.00,    7,    60, 1 },  -- t=2185
        {    10,  31,    0.00,  256.00,    7,    30, 1 },  -- t=2195
        {    10,  32, -128.00,  256.00,    2,    60, 1 },  -- t=2205
        {     0,  32,    0.00,  256.00,    2,    60, 1 },  -- t=2205
        {     0,  32,  128.00,  256.00,    2,    60, 1 },  -- t=2205
        {    50,  31,  -96.00,  256.00,    0,    30, 0 },  -- t=2255
        {    10,  32, -160.00,  256.00,    0,    30, 0 },  -- t=2265
        {    10,  31,  -32.00,  256.00,    0,    30, 0 },  -- t=2275
        {    10,  32, -128.00,  256.00,    2,    60, 0 },  -- t=2285
        {    10,  31,   64.00,  256.00,    2,    40, 0 },  -- t=2295
        {    10,  32,  -64.00,  256.00,    2,    60, 0 },  -- t=2305
        {    10,  31,  160.00,  256.00,    2,    50, 0 },  -- t=2315
        {    10,  32,    0.00,  256.00,    7,    60, 0 },  -- t=2325
        {    10,  31,   96.00,  256.00,    7,    80, 0 },  -- t=2335
        {    10,  32,   32.00,  256.00,    7,    60, 0 },  -- t=2345
        {    10,  31,    0.00,  256.00,    7,    30, 0 },  -- t=2355
        {    10,  32,  128.00,  256.00,    2,    60, 0 },  -- t=2365
        {     0,  32,    0.00,  256.00,    2,    60, 0 },  -- t=2365
        {     0,  32, -128.00,  256.00,    2,    60, 0 },  -- t=2365
        {   180,  41,  -96.00,  256.00,    0,   160, 0 },  -- t=2545
        {     0,  41,   96.00,  256.00,    0,   160, 1 },  -- t=2545
        {   120,  42, -128.00,  256.00,    0,   160, 0 },  -- t=2665
        {   100,  42,  128.00,  256.00,    0,   160, 1 },  -- t=2765
        {   100,  41, -128.00,  256.00,    0,   160, 0 },  -- t=2865
        {    80,  41,  128.00,  256.00,    0,   160, 1 },  -- t=2945
        {    80,  42,  -64.00,  256.00,    0,   160, 0 },  -- t=3025
        {    30,  42,   64.00,  256.00,    0,   160, 1 },  -- t=3055
        {   180,  43, -128.00,  256.00,    0,   160, 0 },  -- t=3235
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=3235
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=3235
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=3235
        {    90,  44,  128.00,  256.00,    0,   160, 1 },  -- t=3325
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=3325
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=3325
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=3325
        {    80,  43, -128.00,  256.00,    0,   160, 0 },  -- t=3405
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=3405
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=3405
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=3405
        {    70,  44,  128.00,  256.00,    0,   160, 1 },  -- t=3475
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=3475
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=3475
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=3475
        {    60,  44,  128.00,  256.00,    0,   160, 1 },  -- t=3535
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=3535
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=3535
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=3535
        {   230,  18, -128.00,   96.00,    0,    10, 0 },  -- t=3765
        {     0,  18, -112.00,  128.00,    0,    10, 0 },  -- t=3765
        {     0,  18,  -96.00,  160.00,    0,    10, 0 },  -- t=3765
        {     0,  18,  -80.00,  192.00,    0,    10, 0 },  -- t=3765
        {     0,  20,  128.00,   96.00,    0,    10, 0 },  -- t=3765
        {     0,  20,  112.00,  128.00,    0,    10, 0 },  -- t=3765
        {     0,  20,   96.00,  160.00,    0,    10, 0 },  -- t=3765
        {     0,  20,   80.00,  192.00,    0,    10, 0 },  -- t=3765
        {    23,  22, -128.00,   96.00,    0,    80, 0 },  -- t=3988
        {    80,  24,  128.00,   96.00,    0,    80, 0 },  -- t=4068
        {     0,  43, -128.00,  256.00,    0,   160, 0 },  -- t=4068
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=4068
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=4068
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=4068
        {    80,  22, -112.00,  128.00,    0,    80, 0 },  -- t=4148
        {    80,  24,  112.00,  128.00,    0,    80, 0 },  -- t=4228
        {    80,  26,  -96.00,  160.00,    0,    80, 0 },  -- t=4308
        {    80,  28,   96.00,  160.00,    0,    80, 0 },  -- t=4388
        {    80,  22,  -80.00,  192.00,    0,    80, 0 },  -- t=4468
        {    80,  24,   80.00,  192.00,    0,    80, 0 },  -- t=4548
        {     0,  44,  128.00,  256.00,    0,   160, 1 },  -- t=4548
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=4548
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=4548
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=4548
        {    80,  22, -128.00,   96.00,    0,    80, 0 },  -- t=4628
        {    80,  24,  128.00,   96.00,    0,    80, 0 },  -- t=4708
        {    80,  22, -112.00,  128.00,    0,    80, 0 },  -- t=4788
        {    80,  24,  112.00,  128.00,    0,    80, 0 },  -- t=4868
        {     0,  43, -128.00,  256.00,    0,   160, 0 },  -- t=4868
        {     0,  43,  -64.00,  256.00,    0,   160, 0 },  -- t=4868
        {     0,  43,    0.00,  256.00,    0,   160, 0 },  -- t=4868
        {     0,  43,   64.00,  256.00,    0,   160, 0 },  -- t=4868
        {    80,  26,  -96.00,  160.00,    0,    80, 0 },  -- t=4948
        {    80,  28,   96.00,  160.00,    0,    80, 0 },  -- t=5028
        {     0,  44,  128.00,  256.00,    0,   160, 1 },  -- t=5028
        {     0,  44,   64.00,  256.00,    0,   160, 1 },  -- t=5028
        {     0,  44,    0.00,  256.00,    0,   160, 1 },  -- t=5028
        {     0,  44,  -64.00,  256.00,    0,   160, 1 },  -- t=5028
        {    80,  18,  -80.00,  192.00,    0,    80, 0 },  -- t=5108
        {    80,  20,   80.00,  192.00,    0,    80, 0 },  -- t=5188
        {   200,  34,  224.00,  128.00,    0,    10, 1 },  -- t=5388
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=5398
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=5408
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=5418
        {    10,  34,  224.00,  128.00,    0,    10, 1 },  -- t=5428
        {    10,  35,  224.00,  128.00,    0,    10, 1 },  -- t=5438
        {    10,  34,  224.00,  128.00,    1,    10, 1 },  -- t=5448
        {    10,  35,  224.00,  128.00,    1,    10, 1 },  -- t=5458
        {    10,  34,  224.00,  128.00,    1,    10, 1 },  -- t=5468
        {    10,  35,  224.00,  128.00,    1,    10, 1 },  -- t=5478
        {    10,  34,  224.00,  128.00,    1,    10, 1 },  -- t=5488
        {    60,  34, -224.00,  128.00,    0,    10, 0 },  -- t=5548
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=5558
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=5568
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=5578
        {    10,  34, -224.00,  128.00,    0,    10, 0 },  -- t=5588
        {    10,  35, -224.00,  128.00,    0,    10, 0 },  -- t=5598
        {    10,  34, -224.00,  128.00,    1,    10, 0 },  -- t=5608
        {    10,  35, -224.00,  128.00,    1,    10, 0 },  -- t=5618
        {    10,  34, -224.00,  128.00,    1,    10, 0 },  -- t=5628
        {    10,  35, -224.00,  128.00,    1,    10, 0 },  -- t=5638
        {    10,  34, -224.00,  128.00,    1,    10, 0 },  -- t=5648
        {   120,  45, -160.00,  192.00,    0,   400, 0 },  -- t=5768
        {    40,  47,  128.00,  128.00,    0,   400, 0 },  -- t=5808
        {    40,  49,   64.00,   96.00,    0,   400, 0 },  -- t=5848
        {    40,  49, -128.00,  160.00,    0,   400, 0 },  -- t=5888
        {    40,  45,  -64.00,  144.00,    0,   400, 0 },  -- t=5928
        {    40,  47,  128.00,  128.00,    0,   400, 0 },  -- t=5968
        {    40,  45,   64.00,   96.00,    0,   400, 0 },  -- t=6008
        {    40,  49, -128.00,  160.00,    0,   400, 0 },  -- t=6048
        {    40,  45,  -64.00,  144.00,    0,   400, 0 },  -- t=6088
        {   400,  37, -224.00,  128.00,    0,    10, 0 },  -- t=6488
        {    10,  38, -224.00,  128.00,    0,    10, 0 },  -- t=6498
        {    10,  37, -224.00,  128.00,    0,    10, 0 },  -- t=6508
        {    10,  38, -224.00,  128.00,    0,    10, 0 },  -- t=6518
        {    10,  37, -224.00,  128.00,    0,    10, 0 },  -- t=6528
        {    10,  38, -224.00,  128.00,    0,    10, 0 },  -- t=6538
        {    10,  37, -224.00,  128.00,    1,    10, 0 },  -- t=6548
        {    10,  38, -224.00,  128.00,    1,    10, 0 },  -- t=6558
        {    10,  37, -224.00,  128.00,    1,    10, 0 },  -- t=6568
        {    10,  38, -224.00,  128.00,    1,    10, 0 },  -- t=6578
        {    10,  37, -224.00,  128.00,    1,    10, 0 },  -- t=6588
        {    60,  37,  224.00,  128.00,    0,    10, 1 },  -- t=6648
        {    10,  38,  224.00,  128.00,    0,    10, 1 },  -- t=6658
        {    10,  37,  224.00,  128.00,    0,    10, 1 },  -- t=6668
        {    10,  38,  224.00,  128.00,    0,    10, 1 },  -- t=6678
        {    10,  37,  224.00,  128.00,    0,    10, 1 },  -- t=6688
        {    10,  38,  224.00,  128.00,    0,    10, 1 },  -- t=6698
        {    10,  37,  224.00,  128.00,    1,    10, 1 },  -- t=6708
        {    10,  38,  224.00,  128.00,    1,    10, 1 },  -- t=6718
        {    10,  37,  224.00,  128.00,    1,    10, 1 },  -- t=6728
        {    10,  38,  224.00,  128.00,    1,    10, 1 },  -- t=6738
        {    10,  37,  224.00,  128.00,    1,    10, 1 },  -- t=6748
        {   300,  52,    0.00,   96.00,   -2,    10, 0 },  -- t=7048
        {    60,  52,  -64.00,   96.00,   -2,    10, 0 },  -- t=7108
        {     0,  53,   64.00,   96.00,   -2,    10, 1 },  -- t=7108
        {    60,  52,  -96.00,   96.00,   -2,    10, 0 },  -- t=7168
        {     0,  53,  -48.00,   96.00,   -2,    10, 0 },  -- t=7168
        {     0,  52,   48.00,   96.00,   -2,    10, 1 },  -- t=7168
        {     0,  53,   96.00,   96.00,   -2,    10, 1 },  -- t=7168
        {   250,  52, -160.00,  192.00,   -2,    10, 0 },  -- t=7418
        {    10,  53, -128.00,  208.00,   -2,    10, 0 },  -- t=7428
        {    10,  52,  -96.00,  192.00,   -2,    10, 0 },  -- t=7438
        {    10,  53,  -64.00,  208.00,   -2,    10, 0 },  -- t=7448
        {    10,  52,  -32.00,  192.00,   -2,    10, 0 },  -- t=7458
        {    10,  53,    0.00,  208.00,   -2,    10, 0 },  -- t=7468
        {    10,  52,   32.00,  192.00,   -2,    10, 0 },  -- t=7478
        {    10,  53,   64.00,  208.00,   -2,    10, 0 },  -- t=7488
        {    10,  52,   96.00,  192.00,   -2,    10, 0 },  -- t=7498
        {    60,  52,  164.00,  192.00,   -2,    10, 0 },  -- t=7558
        {    10,  53,  132.00,  160.00,   -2,    10, 0 },  -- t=7568
        {    10,  52,  100.00,  130.00,   -2,    10, 0 },  -- t=7578
        {    10,  53,   68.00,  102.00,   -2,    10, 0 },  -- t=7588
        {    10,  52,   36.00,   76.00,   -2,    10, 0 },  -- t=7598
        {    10,  53,    4.00,   52.00,   -2,    10, 0 },  -- t=7608
        {    10,  52,  -28.00,   30.00,   -2,    10, 0 },  -- t=7618
        {    10,  53,  -60.00,   10.00,   -2,    10, 0 },  -- t=7628
        {    10,  52,  -92.00,   -8.00,   -2,    10, 0 },  -- t=7638
        {    60,  52, -160.00,   32.00,   -2,    10, 0 },  -- t=7698
        {    10,  53, -128.00,   48.00,   -2,    10, 0 },  -- t=7708
        {    10,  52,  -96.00,   32.00,   -2,    10, 0 },  -- t=7718
        {    10,  53,  -64.00,   48.00,   -2,    10, 0 },  -- t=7728
        {    10,  52,  -32.00,   32.00,   -2,    10, 0 },  -- t=7738
        {    10,  52,    0.00,   32.00,   -2,    10, 0 },  -- t=7748
        {    10,  53,  -32.00,   64.00,   -2,    10, 0 },  -- t=7758
        {     0,  53,   32.00,   64.00,   -2,    10, 0 },  -- t=7758
        {     0,  53,  -32.00,    0.00,   -2,    10, 0 },  -- t=7758
        {     0,  53,   32.00,    0.00,   -2,    10, 0 },  -- t=7758
        {    10,  52,  -64.00,   96.00,   -2,    10, 0 },  -- t=7768
        {     0,  52,   64.00,   96.00,   -2,    10, 0 },  -- t=7768
        {     0,  52,  -64.00,  -32.00,   -2,    10, 0 },  -- t=7768
        {     0,  52,   64.00,  -32.00,   -2,    10, 0 },  -- t=7768
        {    10,  53,  -96.00,  128.00,   -2,    10, 0 },  -- t=7778
        {     0,  53,   96.00,  128.00,   -2,    10, 0 },  -- t=7778
        {     0,  53,  -96.00,  -64.00,   -2,    10, 0 },  -- t=7778
        {     0,  53,   96.00,  -64.00,   -2,    10, 0 },  -- t=7778
        {    10,  52, -128.00,  160.00,   -2,    10, 0 },  -- t=7788
        {     0,  52,  128.00,  160.00,   -2,    10, 0 },  -- t=7788
        {     0,  52, -128.00,  -96.00,   -2,    10, 0 },  -- t=7788
        {     0,  52,  128.00,  -96.00,   -2,    10, 0 },  -- t=7788
        {    10,  53, -160.00,  192.00,   -2,    10, 0 },  -- t=7798
        {     0,  53,  160.00,  192.00,   -2,    10, 0 },  -- t=7798
        {     0,  53, -160.00, -128.00,   -2,    10, 0 },  -- t=7798
        {     0,  53,  160.00, -128.00,   -2,    10, 0 },  -- t=7798
        {   200,  53, -160.00,  192.00,   -2,    10, 0 },  -- t=7998
        {     0,  53,  160.00,  192.00,   -2,    10, 1 },  -- t=7998
        {     0,  53, -160.00, -192.00,   -2,    10, 0 },  -- t=7998
        {     0,  53,  160.00, -192.00,   -2,    10, 1 },  -- t=7998
        {   100,  53, -160.00,    0.00,   -2,    10, 0 },  -- t=8098
        {     0,  53,  160.00,    0.00,   -2,    10, 1 },  -- t=8098
        {     0,  53,    0.00,  192.00,   -2,    10, 0 },  -- t=8098
        {     0,  53,    0.00, -192.00,   -2,    10, 1 },  -- t=8098
        {   100,  53, -160.00,  192.00,   -2,    10, 0 },  -- t=8198
        {     0,  53,  160.00,  192.00,   -2,    10, 1 },  -- t=8198
        {     0,  53, -160.00, -192.00,   -2,    10, 0 },  -- t=8198
        {     0,  53,  160.00, -192.00,   -2,    10, 1 },  -- t=8198
        {     0,  53, -160.00,    0.00,   -2,    10, 0 },  -- t=8198
        {     0,  53,  160.00,    0.00,   -2,    10, 1 },  -- t=8198
        {     0,  53,    0.00,  192.00,   -2,    10, 0 },  -- t=8198
        {     0,  53,    0.00, -192.00,   -2,    10, 1 },  -- t=8198
        {   100,  52, -160.00, -192.00,   -2,    10, 0 },  -- t=8298
        {     0,  52, -128.00, -192.00,   -2,    10, 0 },  -- t=8298
        {     0,  52,  -64.00, -192.00,   -2,    10, 0 },  -- t=8298
        {     0,  52,  160.00, -192.00,   -2,    10, 1 },  -- t=8298
        {     0,  52,  128.00, -192.00,   -2,    10, 1 },  -- t=8298
        {     0,  52,   64.00, -192.00,   -2,    10, 1 },  -- t=8298
        {    60,  53,  -64.00,  -32.00,   -2,    10, 0 },  -- t=8358
        {     0,  53,    0.00,  -32.00,   -2,    10, 0 },  -- t=8358
        {     0,  53,   64.00,  -32.00,   -2,    10, 0 },  -- t=8358
        {     0,  53,  128.00,  -32.00,   -2,    10, 0 },  -- t=8358
        {    60,  52,   64.00,  -96.00,   -2,    10, 1 },  -- t=8418
        {     0,  52,    0.00,  -96.00,   -2,    10, 1 },  -- t=8418
        {     0,  52,  -64.00,  -96.00,   -2,    10, 1 },  -- t=8418
        {     0,  52, -128.00,  -96.00,   -2,    10, 1 },  -- t=8418
        {    60,  53,  -64.00,   96.00,   -2,    10, 0 },  -- t=8478
        {     0,  53,    0.00,   96.00,   -2,    10, 0 },  -- t=8478
        {     0,  53,   64.00,   96.00,   -2,    10, 0 },  -- t=8478
        {     0,  53,  128.00,   96.00,   -2,    10, 0 },  -- t=8478
        {   100,  55, -160.00,  192.00,   -2,    10, 0 },  -- t=8578
        {     0,  55,  160.00,  192.00,   -2,    10, 1 },  -- t=8578
        {     0,  55, -160.00, -192.00,   -2,    10, 0 },  -- t=8578
        {     0,  55,  160.00, -192.00,   -2,    10, 1 },  -- t=8578
        {     0,  55, -160.00,   96.00,   -2,    10, 0 },  -- t=8578
        {     0,  55,  160.00,  -96.00,   -2,    10, 1 },  -- t=8578
        {     0,  55,  -64.00,  192.00,   -2,    10, 0 },  -- t=8578
        {     0,  55,   64.00, -192.00,   -2,    10, 1 },  -- t=8578
        {    50,  54, -160.00,  192.00,   -2,    10, 0 },  -- t=8628
        {     0,  54,  160.00,  192.00,   -2,    10, 1 },  -- t=8628
        {     0,  54, -160.00, -192.00,   -2,    10, 0 },  -- t=8628
        {     0,  54,  160.00, -192.00,   -2,    10, 1 },  -- t=8628
        {     0,  54, -160.00,  -96.00,   -2,    10, 0 },  -- t=8628
        {     0,  54,  160.00,   96.00,   -2,    10, 1 },  -- t=8628
        {     0,  54,   64.00,  192.00,   -2,    10, 0 },  -- t=8628
        {     0,  54,  -64.00, -192.00,   -2,    10, 1 },  -- t=8628
        {    50,  55, -160.00,  192.00,   -2,    10, 0 },  -- t=8678
        {     0,  55,  160.00,  192.00,   -2,    10, 1 },  -- t=8678
        {     0,  55, -160.00, -192.00,   -2,    10, 0 },  -- t=8678
        {     0,  55,  160.00, -192.00,   -2,    10, 1 },  -- t=8678
        {     0,  55, -160.00,   96.00,   -2,    10, 0 },  -- t=8678
        {     0,  55,  160.00,  -96.00,   -2,    10, 1 },  -- t=8678
        {     0,  55,  -64.00,  192.00,   -2,    10, 0 },  -- t=8678
        {     0,  55,   64.00, -192.00,   -2,    10, 1 },  -- t=8678
        {    40,  54, -160.00,  192.00,   -2,    10, 0 },  -- t=8718
        {     0,  54,  160.00,  192.00,   -2,    10, 1 },  -- t=8718
        {     0,  54, -160.00, -192.00,   -2,    10, 0 },  -- t=8718
        {     0,  54,  160.00, -192.00,   -2,    10, 1 },  -- t=8718
        {     0,  54, -160.00,  -96.00,   -2,    10, 0 },  -- t=8718
        {     0,  54,  160.00,   96.00,   -2,    10, 1 },  -- t=8718
        {     0,  54,   64.00,  192.00,   -2,    10, 0 },  -- t=8718
        {     0,  54,  -64.00, -192.00,   -2,    10, 1 },  -- t=8718
        {    40,  55, -160.00,  192.00,   -2,    10, 0 },  -- t=8758
        {     0,  55,  160.00,  192.00,   -2,    10, 1 },  -- t=8758
        {     0,  55, -160.00, -192.00,   -2,    10, 0 },  -- t=8758
        {     0,  55,  160.00, -192.00,   -2,    10, 1 },  -- t=8758
        {     0,  55, -160.00,   96.00,   -2,    10, 0 },  -- t=8758
        {     0,  55,  160.00,  -96.00,   -2,    10, 1 },  -- t=8758
        {     0,  55,  -64.00,  192.00,   -2,    10, 0 },  -- t=8758
        {     0,  55,   64.00, -192.00,   -2,    10, 1 },  -- t=8758
    }

---子程序号 → 配置的两张表（EX / PH 各一份）。
local W78EX = mk78(false)
local W78PH = mk78(true)

---==================== 挂到空 boss 的第七张符卡（EX 道中） ====================
do
    local CARD_NAME = "EX 道中「妖妖梦・Extra」"
    ---EX 最后一只 spawn 在 t=8298（sub 53 的开幕弹 t=8388 收干净）；再往前 t≈6188 还有
    ---一只 sub 45，它的子体要打到 6188+3004 = 9192 帧才自毁 ⇒ 约 9200 帧 = 153 秒，
    ---给到 185 秒留足余量。
    local CARD_TIME = 185
    local LEVEL = 32
    ---符卡历史槽位：本关（th34）自己的一段 3400..3407（按面序）；这张是 EX 面 ⇒ 3406。
    local CARD_ID = 3406

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        ---耐久卡：不打超时音、关掉本体的判定与血条（照前面几张卡）
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        pool4 = {}
        sound_tick4, sound_stamp4 = 0, -1
        task.New(self, function()
            for _, w in ipairs(W7) do
                task.Wait(w[1])
                spawn78(W78EX, w)
            end
        end)
    end
    function card:frame()
        sound_tick4 = sound_tick4 + 1
    end
    function card:render() end
    ---★ 不用清理：所有小怪都是独立对象（没有 object.Connect 到 boss），最晚的一只
    ---在 185 秒内自毁。
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end

---==================== 挂到空 boss 的第八张符卡（PH 道中） ====================
do
    local CARD_NAME = "PH 道中「妖妖梦・Phantasm」"
    ---PH 最后一只 spawn 在 t=8758（sub 55）；t≈6088 那只 sub 45 的子体打到 6088+3003
    ---= 9091 帧 ⇒ 约 9100 帧 = 152 秒，同样给 185 秒。
    local CARD_TIME = 185
    local LEVEL = 32
    ---符卡历史槽位：本关（th34）自己的一段 3400..3407（按面序）；这张是 PH 面 ⇒ 3407。
    local CARD_ID = 3407

    local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
    function card:before()
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
    end
    function card:init()
        pool4 = {}
        sound_tick4, sound_stamp4 = 0, -1
        task.New(self, function()
            for _, w in ipairs(W8) do
                task.Wait(w[1])
                spawn78(W78PH, w)
            end
        end)
    end
    function card:frame()
        sound_tick4 = sound_tick4 + 1
    end
    function card:render() end
    function card:del() end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end
end

---=====================================
---TH07 EX/PH boss 战 —— 八雲紫（符卡 + 非符，逐张）
---=====================================
---把 `ecldata8.ecl`（PH）/ `ecldata7.ecl`（EX）里紫的每一张**符卡**与**非符**逐张翻成
---原生 LuaSTG 卡片（不用 ECL VM、不用 decl），挂在 th34 这个 boss 组的另一批卡上。
---`main_stage.lua` 只 `boss.CreateGroup(1, 32)`，所以新卡一律登记到同一组的 "1a"
---（改别的组需要动 main_stage.lua，超出本次范围）。
---
---原作这张 boss 战的结构（`th07/src/th07/EclManager.cpp` + `EnemyManager.cpp`）：
---  · boss 主 sub（PH = 69、EX = 67）：SET_POS(-32,32) → MOVE_POS_TIME(60,4,192,128)
---    → SET_INTERRUPT 到「卡序列」sub（PH = 70、EX = 68），本体不可打。
---  · 一张**非符** = 一个 SET_LIFE + `SET_LIFE_CALLBACK(0, 阈值, 下一张符卡的 sub)` +
---    `SET_TIMER_CALLBACK_SUB 下一张` 的 sub；在一个 320×80 的小框里随机漂移，
---    每 N 帧调一次周期回调打一组弹。血降到阈值 / 超时 60 秒 ⇒ **调用**下一张卡的 sub
---    （`Enemy::HandleLifeCallback` / `HandleTimerCallback`：life 被夹到阈值，弹池清空）。
---  · 一张**符卡** = BEGIN_SPELLCARD + 自己的弹幕 + 自己的计时器；卡结束时
---    `timerCallbackSub` 被换成 `deathCallbackSub`（= 下一张非符）⇒ 一路串下去。
---  · **符卡自己带不带 life**：符卡 sub 一般**不写 SET_LIFE**，而 `BeginSpellcard`
---    （EclManager.cpp:658）也**不重置 life** ⇒ 符卡开始时 life 就是上一张非符被
---    `HandleLifeCallback` 夹到的那个阈值（2000~2800）。只有 PH 的 85/86/87 与 EX 的
---    83/84 这种「先 SET_LIFE、再 SUB_CALL 一张符卡 sub」的包壳才自带 life
---    （3000 / 8000 / 8000）。移植版每张符卡都按**开卡时的那个 life**折算。
---  · **开卡后的「打不动」窗口**：原作每张符卡先 120 帧 `SET_CAN_BE_DAMAGED 0`
---    （就是进场动画），紧接着 `SET_INVINCIBILITY_TIMER 240` 把伤害再 ÷9（boss 专属，
---    EnemyManager.cpp:872-880）⇒ 等效再少 213 帧。移植版用一段等长的**全程免伤**
---    顶上（框架只有 t1/t2 两档，见 `CARD_FREEZE`），总击杀时长与原作一致。
---  · 移植版不串这条链：每张卡自带进场、漂移/弹幕、时限。Boss Rush 与符卡练习里
---    每张卡本来就是**独立挑战**的（`boss.card.add` 的 data_id 就是练习解锁号）。
---
---坐标（同道中）：TH07 384×448、左上原点、y 朝下 ⇒ 我们 x−192 / 224−y、角度取反。
---血量：按**本仓库的伤害口径**重算（文件头差异 16 的同一套推导）——
---  · 非符：原作 boss 吃满伤害（第 4/5/6 面对**非 boss** 的那两级减伤都不适用，
---    EnemyManager.cpp:820-845）⇒ 用「无折扣」系数 0.09825（= hp1/hp3 同口径）；
---    例：life 20000、阈值 2600 ⇒ 17400 × 0.09825 ≈ 1709。
---  · 符卡：原作符卡期间**伤害 ÷7**（EnemyManager.cpp:838-845 的 `damage/7`）⇒
---    系数 0.09825 × 7 ≈ 0.6878；输入是**符卡实际持有的 life**（见上面那条：多数
---    符卡 = 上一张非符的阈值 2000~2800，包壳卡用 3000 / 8000），例：阈值 2600 ⇒
---    hpS(2600) = 1788（与 th07.lua 的 600~1500 同档）。
---  · 耐久卡（原作无 SET_LIFE 或 SET_IS_SURVIVAL_SPELLCARD）给 10000000、关判定。
---弹型/色档是代理（同差异 62/63）：sprite 4/5/6/8 → ball_small、10 → grain_a、
---  7/9 → arrow_small、2 → 米弹；色档走 col16（同号近似）。
local function TH34_add_stage78_boss()
    local LEVEL = 32
    local ball_small, grain_a, arrow_small = ball_small, grain_a, arrow_small
    local RAD = 180 / PI

    ---TH07 弹型（sprite）→ 本仓库代理。
    local BS = { [0] = ball_small, [1] = grain_a, [2] = grain_a, [3] = ball_small,
                 [4] = ball_small, [5] = ball_small, [6] = ball_small, [7] = arrow_small,
                 [8] = ball_small, [9] = arrow_small, [10] = grain_a }
    local function bs(spr) return BS[spr] or grain_a end

    ---非符/符卡的血量折算（见文件头的推导）。
    local function hpB(x) return max(1, int(x * 0.09825 + 0.5)) end
    local function hpS(x) return max(1, int(x * 0.6878 + 0.5)) end

    ---ECL_VAR_RNG_RADIAN（$10060）：每读一次重掷一个 [−π,π) 的角（EclManager.cpp:466）。
    local function rngrad() return ran:Float(-PI, PI) end

    ---MOVE_POS_TIME / MOVE_DIR_TIME（引擎的 ENEMY_MOVE_INTERP，EnemyManager.cpp 的
    ---更新在 EclManager.cpp:2044）：每帧 pos = 起点 + e(u)·位移，u = 已走/总帧。
    ---ease 4 = ease-out-quad；原作那些 8 落在引擎 switch 之外 ⇒ 线性，这里照做。
    local function bmove(self, t, ease, x, y)
        self._mv = { t = max(1, t), n = 0, x0 = self.x, y0 = self.y,
                     dx = x - self.x, dy = y - self.y, ease = ease }
    end
    local function bstep(self)
        local m = self._mv
        if not m then return end
        m.n = m.n + 1
        local u = min(1, m.n / m.t)
        local e = u
        if m.ease == 4 then
            e = 1 - (1 - u) * (1 - u)
        elseif m.ease == 1 then
            e = u * u
        elseif m.ease == 2 then
            e = u * u * u
        elseif m.ease == 3 then
            e = u * u * u * u
        elseif m.ease == 5 then
            local v = 1 - u; e = 1 - v * v * v
        elseif m.ease == 6 then
            local v = 1 - u; e = 1 - v * v * v * v
        end
        self.x, self.y = m.x0 + m.dx * e, m.y0 + m.dy * e
        if m.n >= m.t then self._mv = nil end
    end

    ---MOVE_ORBIT（op56 在 EclManager.cpp:1560 赋值、更新在 1998-2020 的 ENEMY_MOVE_ORBIT）：
    ---每帧 角 += ω、半径 += rw，位置直接放到 圆心 + 半径·(cos,sin)（引擎先算 velocity
    ---再积分，净效果就是瞬移到位）。半径/角速度和角度一样要取反。
    local function borbit(self, cx, cy, deg, w, r, rw)
        self._orb = { cx = cx, cy = cy, a = deg, w = w, r = r, rw = rw }
    end
    local function borbstep(self)
        local o = self._orb
        if not o then return end
        o.a, o.r = o.a + o.w, o.r + o.rw
        self.x, self.y = o.cx + math.cos(o.a) * o.r, o.cy + math.sin(o.a) * o.r
    end
    ---MOVE_ORBIT 的 moveAngle（原作 exit 里 `velocity = (圆心+半径·新方向) − 旧位置`、
    ---`angle = atan2(velocity)`；EclManager.cpp:1997-2006）。所以 enemy->angle 就是
    ---**上一帧位移的方向**。本文件的任务(task)在卡 frame(bframe) 之前跑（boss_system
    ---的 doTask 在 `current_card.frame` 之前，boss_system.lua:119/133），而原作的
    ---周期子程也在 exit 的移动更新之前跑（EclManager.cpp:904-921）⇒ 两边读到的都是
    ---「上一帧 exit 写入的 angle」。因此这里直接回报 bframe 缓存的「上一帧位移方向」，
    ---而不是用轨道参数现推切线（现推会在段切换那一帧差半拍/差一整段）。
    ---返回我们的口径、角度制。
    local function orbdir(self)
        return self._angdir or self._orbdir or 0
    end

    ---每帧运动 + 位置夹框（原作 SET_MOVEMENT_BOUNDS + EnemyManagerUpdate 的 ClampPosition）。
    ---同时推进 sound_tick4：sound4 用它做「同帧同音效只响一声」的去重（原作
    ---SoundPlayer 的队列按 idx 去重）。boss 卡的 frame 只有这一个入口，不推的话
    ---整张卡只会响一声。
    local function bframe(self)
        sound_tick4 = sound_tick4 + 1
        local _fx, _fy = self.x, self.y
        if self._orb then borbstep(self) else bstep(self) end
        ---enemy->angle 的复刻：本帧位移的方向（原作 exit 的 atan2(velocity)）。
        local _dx, _dy = self.x - _fx, self.y - _fy
        if abs(_dx) > 1e-9 or abs(_dy) > 1e-9 then
            self._angdir = math.deg(atan2(_dy, _dx))
        end
        local b = self._box
        if b then
            self.x = min(max(self.x, b[1]), b[2])
            self.y = min(max(self.y, b[3]), b[4])
        end
    end

    ---RAND_EXIT_ANGLE（EclManager.cpp:1590）：自机在左边就朝左半（rand(π/2)+3π/4），
    ---否则朝右半（rand(π/2)−π/4）。这条「背对自机」的随机方向取反后落在同一对
    ---象限里（{135°..225°} 与 {−45°..45°} 都关于 y 轴对称），所以直接用我们的角度。
    local function exang(self)
        ---原作条件：(自机在左且 x>96) 或 x>288（TH07 绝对坐标；换算成我们的 −96/96）。
        if (player.x < self.x and self.x > -96) or self.x > 96 then
            return ran:Float(135, 225)
        end
        return ran:Float(-45, 45)
    end
    ---一段 exang 方向的漂移：MOVE_DIR_TIME(60, ease, θ, spd) ⇒ 总位移 spd×60 px。
    local function exdrift(self, spd, ease)
        local a = exang(self)
        bmove(self, 60, ease or 4, self.x + cos(a) * 60 * spd, self.y + sin(a) * 60 * spd)
    end

    ---op64..72 的通用发弹（语义 = BulletManager.cpp:180 的 SpawnBulletPattern）。
    ---spr/off = sprite/spriteOffset，c1/c2 = count1/count2，v1/v2 = speed1/speed2，
    ---a1/a2 = angle1/angle2（弧度、TH07 口径），plays = flags 的 0x200（响不响音效）。
    ---展开交给第 3 面那张卡的 w3_spread / w3_ring / w3_random（同一套取反推导）。
    local function shoot(self, op, spr, off, c1, c2, v1, v2, a1, a2, plays)
        local style = bs(spr)
        if op == 64 or op == 65 then
            w3_spread(self, style, off, c1, c2, v1, v2, a1, a2, op == 64, plays)
        elseif op == 66 or op == 67 then
            w3_ring(self, style, off, c1, c2, v1, v2, a1, a2, op == 66, plays)
        elseif op == 72 then
            w3_random(self, style, off, c1, v1, v2, a2, plays)
        end
    end

    ---原作 boss 主 sub 的进场：SET_POS(-32,32) → MOVE_POS_TIME(60,4,192,128)。
    local function enter(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = -224, 192
        bmove(self, 60, 4, 0, 96)
    end

    ---BossImage 里的 "Yukari" 立绘（th07.lua 的 7b/8b/9od 都用它；中 boss 组默认是
    ---img_void 不显形，所以符卡一开就把立绘换回来）。
    local function yukari(self)
        if self._wisys then self._wisys:SetImageInList("Yukari") end
    end

    ---boss 卡的公共皮肤：hittable（真符卡）/ 耐久卡另说。
    local function skin(self)
        self.NotPlayTimeOutSound = false
        self.colli = true
        self.no_hp_render = false
        yukari(self)
    end
    local function skin_wall(self)
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
        yukari(self)
    end

    ---──────────────────── 非符：公共骨架（原作 sub 70/72/73/75/77/79/81/83） ────────────────────
    ---进场后在 opt.box（默认 x∈[−160,160]、y∈[96,176]）里漂：每 120 帧重掷一次 exang 方向、
    ---60 帧走 spd×60 px（原作 t0 的 SET_PERIODIC_CALLBACK + RAND_EXIT_ANGLE +
    ---MOVE_DIR_TIME(60, ease,…)，t0+120 的 INC+JUMP 回到 t0）；periodic callback 每
    ---gap 帧打一组弹。life/threshold 直接用原作数值，血量按 hpB(life−thr) 折算。
    ---  · opt.t0  周期回调与漂移的起始帧（默认 60）
    ---  · opt.ease MOVE_DIR_TIME 的缓动（默认 4；sub72 起都是 0）
    ---  · opt.drift_t 两次随机漂移的间隔（默认 120；sub83/sub81 的循环长 150 帧）
    ---  · opt.burst { 每组发数 n, 组后静默帧 pause }：周期回调不再是「一路每 gap 帧一发」，
    ---    而是「gap 帧后首发 → 连打 n 发（间隔 gap）→ 静默 pause 帧」循环。
    ---    原作 sub83/sub81 每轮 t=160 起打到 t=280（12 发），t=280 把周期改成 300，
    ---    t=310 又 JUMP 回 t=160 把周期重置成 10 —— 净效果就是 12 发 + 40 帧空档。
    ---  · fire 传函数就直接用；传 { make = f } 则每次开局调 f() 造一个带累加器的新函数
    ---    （sub78/80/82 的基准角是跨回调累加的，不能每次重掷）。
    local function nonspell(menu, id, life, thr, gap, fire, opt)
        opt = opt or {}
        local card = boss.card.New("", 1, 1, 60, hpB(life - thr))
        card.before = skin
        card.init = function(self)
            pool4 = {}
            sound_tick4, sound_stamp4 = 0, -1
            enter(self)
            local t0 = opt.t0 or 60
            local ease = opt.ease or 4
            local f = (type(fire) == "table") and fire.make() or fire
            self._box = opt.box or { -160, 160, 96, 176 }
            task.New(self, function()
                task.Wait(t0)
                task.New(self, function()
                    if opt.burst then
                        local n, pause = opt.burst[1], opt.burst[2]
                        task.Wait(gap)
                        while true do
                            for _ = 1, n do f(self); task.Wait(gap) end
                            task.Wait(pause)
                        end
                    else
                        while true do
                            task.Wait(gap)
                            f(self)
                        end
                    end
                end)
                while true do
                    exdrift(self, 1, ease)
                    task.Wait(opt.drift_t or 120)
                end
            end)
        end
        card.frame = bframe
        card.del = function() end
        boss.card.add({ { card, "1a" } }, LEVEL, menu, id)
    end

    ---原作 sub 71（非符 1、2 共用）：32 发整圈 ×2 层（速度 2.8→1）+ 一整圈
    ---（速度 1.8、基准角每次重掷）。
    local function f71(self)
        shoot(self, 66, 4, 4, 32, 2, 2.8, 1, 0, 0, true)
        shoot(self, 66, 4, 3, 32, 1, 1.8, 1, rngrad(), 0, true)
    end
    ---原作 sub 74：同形，速度换成 3.2 / 1.8，色档 8 / 3。
    local function f74(self)
        shoot(self, 66, 4, 8, 32, 2, 3.2, 1, 0, 0, true)
        shoot(self, 66, 4, 3, 32, 1, 1.8, 1, rngrad(), 0, true)
    end
    ---原作 sub 76：64 发整圈 ×2 层（速度 3.2→1）。
    local function f76(self)
        shoot(self, 66, 4, 8, 64, 2, 3.2, 1, 0, 0, true)
    end
    ---原作 sub 78：两圈 8 发 ×1 层（速度 3 / 2.5），两个基准角 lf0/lf1 初值 0、
    ---每次回调分别 +0.0560999 / −0.0785398（所以是两条缓慢反向自转的环）。
    ---原作 sub 80：8 发 ×3 层（速度 3→1），基准角 lf0 从 0 起每次 +0.0668424。
    ---原作 sub 82：两圈 8 发 ×1 层（速度 4 / 0.8），lf0 每次 −0.0951998、lf1 每次 +0.1309。
    ---这三支的基准角是**累加**的，用 make 工厂保证每次开局都从 0 起。
    ---原作 sub 84：24 发整圈 ×2 层（速度 6→1）—— 非符 8 的「重炮」。
    local function f84(self)
        shoot(self, 66, 4, 10, 24, 2, 6, 1, 0, 0, true)
    end

    ---────────── 中 boss 的那张非符（原作 sub 57，life 13500 / 阈值 2000） ──────────
    ---「机关枪扇」（sub 58）与「螺旋环」（sub 59）交替：
    ---  · sub 58：18 组 7 发 ×2 层扇，每 2 帧一组；速度 v1 = 2+0.5i、张角 60°−3.09°i
    ---    （DEC_JUMP 的 `time == instr->time` 语义 ⇒ 一组真的落在两帧上，共 36 帧）。
    ---  · sub 59：16 组 7 发 ×5 层整圈，每 3 帧一组；速度 2+0.1875i、基准角每轮转
    ---    gF0（±0.06545 = ±3.75°）—— 两遍反向，合起来是一条来回扫的螺旋。
    do
        local card = boss.card.New("", 1, 1, 60, hpB(13500 - 2000))
        card.before = skin
        card.init = function(self)
            pool4 = {}
            sound_tick4, sound_stamp4 = 0, -1
            enter(self)
            self._box = { -160, 160, 96, 176 }
            ---原作 sub58：18 组 7 发×2 层瞄准扇，每 2 帧一组（共 36 帧）。
            ---SUB_CALL 是**同步**的：这 36 帧里母体原地不动，之后才轮到最后那一段
            ---MOVE_DIR_TIME；所以这里必须直接在主协程里 task.Wait，不能用 task.New 并发。
            local function burst()
                for i = 0, 17 do
                    shoot(self, 64, 6, 6, 7, 2, 2 + 0.5 * i, 3.8, 0,
                          1.0472 - 0.0539793 * i, true)
                    task.Wait(2)
                end
            end
            ---原作 sub59：16 组 7 发×5 层整圈，每 3 帧一组（共 48 帧），同样同步。
            local function spiral(g)
                for i = 0, 15 do
                    shoot(self, 67, 2, 2, 7, 5, 2 + 0.1875 * i, 0.5, g * i, 0, true)
                    task.Wait(3)
                end
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    burst(); exdrift(self, 1, 8); task.Wait(100)
                    burst(); exdrift(self, 2, 8); task.Wait(100)
                    spiral(0.0654498); exdrift(self, 1, 8); task.Wait(100)
                    spiral(-0.0654498); exdrift(self, 2, 4); task.Wait(60)
                end
            end)
        end
        card.frame = bframe
        card.del = function() end
        boss.card.add({ { card, "1a" } }, LEVEL, "紫 非符 0", 3408)
    end

    ---────────── 主 boss 的八张非符（原作 sub 70/72/73/75/77/79/81/83） ──────────
    ---{ t0 = 160, ease = 0, box = … } 是 sub72 起七张共用的进场参数（原作 t=160 起周期）。
    local NP2 = { t0 = 160, ease = 0, box = { -128, 128, 96, 176 } }
    nonspell("紫 非符 1", 3411, 20000, 2600, 28, f71)
    nonspell("紫 非符 2", 3413, 18000, 1700, 18, f71, NP2)
    nonspell("紫 非符 3", 3415, 20000, 2400, 24, f74, NP2)
    nonspell("紫 非符 4", 3417, 20000, 2800, 60, f76, NP2)
    nonspell("紫 非符 5", 3419, 20000, 1400, 10, { make = function()
        local lf0, lf1 = 0, 0
        return function(self)
            shoot(self, 66, 4, 8, 8, 2, 3, 1, lf0, 0, true)
            lf0 = lf0 + 0.0560999
            shoot(self, 66, 4, 10, 8, 2, 2.5, 1, lf1, 0, true)
            lf1 = lf1 - 0.0785398
        end
    end }, NP2)
    nonspell("紫 非符 6", 3421, 20000, 2700, 10, { make = function()
        local lf0 = 0
        return function(self)
            shoot(self, 66, 4, 8, 8, 3, 3, 1, lf0, 0, true)
            lf0 = lf0 + 0.0668424
        end
    end }, NP2)
    nonspell("紫 非符 7", 3423, 20000, 2700, 8, { make = function()
        local lf0, lf1 = 0, 0
        return function(self)
            shoot(self, 66, 4, 10, 8, 1, 4, 1, lf0, 0, true)
            lf0 = lf0 - 0.0951998
            shoot(self, 66, 4, 9, 8, 1, 0.8, 1, lf1, 0, true)
            lf1 = lf1 + 0.1309
        end
    end }, NP2)
    ---原作 sub83 的周期回调：t=160 起每 10 帧一发打到 t=280（12 发），t=280 把周期改成 300、
    ---t=310 又 JUMP 回 t=160 把周期重置成 10 —— 净效果就是「12 发（间隔 10 帧）+ 40 帧空档」
    ---的 150 帧循环，随机漂移也在每个循环开头重掷一次（所以 drift_t=150）。
    nonspell("紫 非符 8", 3425, 20000, 2000, 10, f84, {
        t0 = 160, ease = 0, drift_t = 150, burst = { 12, 30 },
        box = { -128, 128, 96, 176 } })

    ---════════════════════════════════════════════════════════════════════════
    --- 符卡：原作 PH 面 13 张（sub 129→60，逆序实现）
    ---
    --- 从 `ecldata8.ecl` 逐 sub 反汇编出来的原生 LuaSTG 版本；弹型/发数/速度/张角/
    --- 节奏照抄，只有「激光段」和「子弹指令（INIT_BULLET_CMD）的曲线」用近似。
    --- 每张都是独立挑战（挂 boss.card.add 的 data_id 就是符卡练习的解锁 id）。
    ---════════════════════════════════════════════════════════════════════════
    ---通用「子机」：原作 SPAWN_ENEMY_REL/ABS 出来的辅助单位（不可打、无体术、不画立绘）。
    ---script(self, a) 是协程体（可 task.Wait / 发弹），跑完自毁。
    local PSCRIPT = Class(enemy, {
        init = function(self, x, y, fn, a)
            enemy.init(self, 12, 1, false, true, true)
            self.x, self.y = x, y
            ---★ 原作这些「会飞出屏幕的发射体」（sub62 炮台、sub126 幽灵、sub130 音符串…）
            ---都带 `SET_HAS_NO_COLLISION 1`。TH07 的 OOB 回收要求 `hasNoCollision == 0`
            ---（EnemyManager.cpp:700-722），所以它们**飞出屏外也不会被回收**、照常发弹。
            ---LuaSTG 的 `enemy.auto_delete`（THlib/enemy/enemy.lua:211）却把它绑到
            ---`world.bound` 上直接回收 ⇒ 子机一飞出边界就停摆（`bstep` 不再被调用，
            ---`bmove` 停在半路）。关掉自动回收，改由脚本自己 RawDel。
            self.auto_delete, self.bound = false, false
            self.colli, self.protect = false, true
            self.A, self.B = 8, 8
            task.New(self, function()
                fn(self, a)
                object.RawDel(self)
            end)
        end,
        ---引擎在 RawDel 时会回调 del（GameObject::dispatchOnQueueToDestroy）。
        ---派生物自己的协程是挂在**派生物**名下的（THlib Ltask 的 task 表在对象上），
        ---对象一删协程就没了；桩件的对象表不清 task，所以要在这里显式清一次，
        ---否则「卡片结束时轮子/魂还在打」会被泄漏扫描判成 FAIL（id=4408/4410）。
        del = function(self) task.Clear(self) end,
        render = function() end,
    })

    ---当前符卡登记的子机（del 时统一清场）。
    local spell_live
    local function pspawn(x, y, fn, a)
        local o = New(PSCRIPT, x, y, fn, a)
        if spell_live then spell_live[#spell_live + 1] = o end
        return o
    end

    ---TH07 的「段式激光」（SpawnLaserPattern + 每帧更新，BulletManager.cpp:1123）。
    ---一条激光 = pos 处沿 angle 的**线段** [startOffset, endOffset]，w 是垂直粗细。
    ---  · 每帧 endOffset += spd；若 startLength < endOffset−startOffset 就令
    ---    startOffset = endOffset−startLength（光束从远端长出来），最后夹到 >= 0；
    ---    所以 sOff 一般给 0、eOff=640、sLen=640 就是「从 pos 长到 640」。
    ---  · tStart 帧展开（前 min(tStart,30) 帧只有 1.2px 细线预警）→ dur 帧满宽
    ---    （全程有判定）→ tEnd 帧收束；判定窗口另有 hbStart / hbEnd。
    ---  · hide=true 等价 SET_LASER_HIDE_WARNING：只藏激光头的节点贴图，
    ---    激光本体的展开曲线不变（本实现不画节点，故实际不影响外观）。
    ---ang 用**我们的**弧度（THlib 的 rot 是角度制，这里乘 RAD）。
    ---返回对象，调用方可以直接改 o.pl_ang / o.pl_sOff / o.pl_eOff 来复刻
    ---ADD_LASER_ANGLE / SET_LASER_OFFSETS / SET_LASER_POS_REL。
    local PLASER
    PLASER = Class(laser, {
        init = function(self, x, y, ang, s)
            laser.init(self, s.spr or 4, x, y, ang * RAD, 0, 1, 0, s.w or 8, 0, 0)
            self.pl_x, self.pl_y = x, y
            self.pl_ang = ang
            self.pl_spd = s.spd or 0
            self.pl_sOff, self.pl_eOff = s.sOff or 0, s.eOff or 640
            self.pl_sLen, self.pl_lw = s.sLen or 640, s.w or 8
            self.pl_tStart, self.pl_dur = s.tStart or 0, s.dur or 60
            self.pl_tEnd = s.tEnd or 30
            self.pl_hbStart = s.hbStart or (s.tStart or 0)
            self.pl_hbEnd = s.hbEnd or 0
            self.pl_hide = s.hide and true or false
            self.pl_t, self.pl_state, self.pl_w = 0, 0, 0
            self.alpha, self.colli = 1, false
            PLASER._pl_sync(self)
        end,
        ---把 [sOff, eOff] 段映射到 THlib laser 的 (x, y, rot, l1..l3, w)。
        _pl_sync = function(self)
            local a, d = self.pl_ang, self.pl_eOff - self.pl_sOff
            self.x = self.pl_x + math.cos(a) * self.pl_sOff
            self.y = self.pl_y + math.sin(a) * self.pl_sOff
            self.rot = a * RAD
            self.l1, self.l2, self.l3 = 0, max(1, d), 0
            self.w0, self.w = self.pl_lw, self.pl_w
        end,
        frame = function(self)
            self.pl_eOff = self.pl_eOff + self.pl_spd
            if self.pl_sLen < self.pl_eOff - self.pl_sOff then
                self.pl_sOff = self.pl_eOff - self.pl_sLen
            end
            if self.pl_sOff < 0 then self.pl_sOff = 0 end
            local t, full = self.pl_t, self.pl_lw
            if self.pl_state == 0 then
                ---原作 SET_LASER_HIDE_WARNING 只藏掉激光头的「节点」贴图（vm1），
                ---激光本体（vm0）照样从 1.2px 细线长到满宽（BulletManager.cpp:1146-1170
                ---与 1322-1344），所以这里的宽度曲线与 hide 无关。
                local warn = min(self.pl_tStart, 30)
                if self.pl_tStart - warn < t then
                    self.pl_w = t * full / max(1, self.pl_tStart)
                else
                    self.pl_w = 1.2
                end
                self.colli = t >= self.pl_hbStart
                if t >= self.pl_tStart then self.pl_state, t = 1, 0 end
            end
            if self.pl_state == 1 then
                self.pl_w, self.colli = full, true
                if t >= self.pl_dur then self.pl_state, t = 2, 0 end
            end
            if self.pl_state == 2 then
                self.pl_w = full * max(0, 1 - t / max(1, self.pl_tEnd))
                self.colli = t < self.pl_hbEnd
                if t >= self.pl_tEnd then object.RawDel(self); return end
            end
            self.pl_t = t + 1
            PLASER._pl_sync(self)
            laser.frame(self)
        end,
    })

    ---登记式激光：与 pspawn 一样把对象挂进当前符卡的 live 表，卡片结束时统一清掉，
    ---避免预警/满宽阶段的激光跨卡残留（THlib 的 laser 自带收束，但可能横跨到下一张卡）。
    local function plaser(x, y, ang, s)
        local o = New(PLASER, x, y, ang, s)
        if spell_live then spell_live[#spell_live + 1] = o end
        return o
    end

    ---PH/EX 两张生存卡共用的「中心激光星」（原作 ph sub125/126 与 ex sub121/122 参数完全相同）：
    ---一次放 6 条长激光（角 i·60°、长 192），每帧沿径向收 1.86667px（120 帧 320→96），
    ---之后 0.08px/帧；60 帧展开、16 帧收束、判定从第 60 帧起。
    local function laser_star(x, y)
        local ls = {}
        ---原作 sub125 #6 / sub121 #6：激光星一出现就响 se_lazer00。
        PlaySound("lazer00", 0.13, (x or 0) / 256)
        ---原作 sub125 一共插 12 条（li0=0..11，角度 60°·li0）：前 6 条的 spriteOffset=14、
        ---后 6 条 =1，两层角度相同、但 sub126 每帧把它们**反向**拧 0.01309°，于是两两错开。
        for k = 0, 5 do
            for _, sgn in ipairs({ 1, -1 }) do
                local o = plaser(x or 0, y or 0, k * PI / 3, {
                    spr = 4, w = 24, sOff = 320, eOff = 512, sLen = 192,
                    tStart = 60, dur = 360000, tEnd = 16, hbStart = 60, hbEnd = 16,
                    spd = -1.86667 })
                o.pl_dang = 0.01309 * sgn
                ls[#ls + 1] = o
            end
        end
        ---每帧拧一点；前 120 帧同时以 1.86667px/帧把 [sOff,eOff] 从 [320,512] 收到 [96,288]，
        ---接着**原地停 3000 帧**（原作 sub121/125 的 3000 次空转），之后才改成 0.08px/帧
        ---慢慢收到半径 40 为止。
        local function spin()
            for i = 1, #ls do ls[i].pl_ang = ls[i].pl_ang + ls[i].pl_dang end
        end
        for _ = 1, 120 do spin(); task.Wait(1) end
        for _ = 1, 3000 do spin(); task.Wait(1) end
        for i = 1, #ls do ls[i].pl_spd = -0.08 end
        while true do spin(); task.Wait(1) end
    end

    ---SPREAD（TH07 op64/65），角度用**我们的**角度制（度）。
    ---TH07 的第 x 发相对角 = ±round((x+1)/2)·a2（奇数）/ ±(x/2·a2 + a2/2)（偶数）；
    ---这一族两翼对称，所以把 a2 取负代进 spread_offsets 就是取反后的结果。
    local function gspread(self, style, off, c1, c2, v1, v2, a1, a2, plays)
        local offs = spread_offsets(c1, -a2)
        volley3(self, c1 * c2, function(i)
            local k = i - 1
            local layer, ring = int(k / c1), k % c1
            local v = v1 - (v1 - v2) * layer / c2
            return style, col16(off), v, a1 + offs[ring + 1]
        end, plays)
    end
    ---RING（op66/67）：angle = ring·360/c1 + layer·a2 + a1。
    local function gring(self, style, off, c1, c2, v1, v2, a1, a2, plays)
        local step = 360 / c1
        volley3(self, c1 * c2, function(i)
            local k = i - 1
            local layer, ring = int(k / c1), k % c1
            local v = v1 - (v1 - v2) * layer / c2
            return style, col16(off), v, a1 + ring * step + layer * a2
        end, plays)
    end
    ---RANDOM（op70/71/72）：角度 = a1 + rand(0, a2)，速度 = rand(v2, v1)。
    local function grandom(self, style, off, c1, v1, v2, a1, a2, plays)
        volley3(self, c1, function()
            ---★ 原作 op72 RANDOM 逐发**先抽角、后抽速**（BulletManager.cpp:215-231）。
            local a = a1 + ran:Float(0, a2)
            local v = ran:Float(v2, v1)
            return style, col16(off), v, a
        end, plays)
    end

    ---随机角（度）——原作 ECL_VAR_RNG_RADIAN 的度数版。
    local function rngdeg() return ran:Float(-180, 180) end
    ---清屏（原作 REMOVE_ALL_BULLETS_NO_ITEMS 的近似）：只清本卡的弹池。
    local function pclear()
        for i = #pool4, 1, -1 do
            local b = pool4[i]
            if IsValid(b) then object.RawDel(b) end
        end
        pool4 = {}
    end

    ---原作符卡「开卡后打不动」的等效时长（秒）——每张卡开卡时的两段：
    ---  · t=0..120 帧 `SET_CAN_BE_DAMAGED 0` ⇒ 完全免伤（这 120 帧就是进场动画）；
    ---  · 紧接着 `SET_INVINCIBILITY_TIMER 240` ⇒ 伤害再 ÷9（EnemyManager.cpp:872-880，
    ---    boss 的 ÷9，跟符卡阶段的 ÷7 叠乘），240 帧 ÷9 等效 240×8/9 ≈ 213.3 帧。
    ---框架（boss_system.lua:147-154 的 t1/t2）只有「完全免伤 → 线性升到 1」两档，
    ---没有 ÷9，所以这里把「等效时长」直接换成一段**全程免伤**（t1 = t2）——
    ---总击杀时长与原作一致，形状上只是把「几乎打不动」压成「打不动」。
    ---非符的 60 帧 ÷9（等效 0.89 s）沿用原来的 1 s，不在这张表里。
    local CARD_FREEZE_DEFAULT = 5.555556          -- 120 + 240×8/9 = 333.33 帧
    local CARD_FREEZE = {
        [3450] = 2.0,                             -- 原作 PH sub88：INV 紧接着被清 0 ⇒ 只免伤 120 帧
        [3452] = 2.0,                             -- 原作 PH sub60：同上
        [3462] = 2.0,                             -- 原作 EX sub85（与 PH sub88 同型）：同上
        [3451] = 7.185185,                        -- 原作 PH sub63：0..110 帧 ÷9、110..230 帧免伤、230..470 帧 ÷9
        [3461] = 7.185185,                        -- 原作 EX sub61：同上
        [3443] = 10.888889,                       -- 原作 PH sub114：120 帧免伤 + INV 600 帧 ÷9
        [3469] = 10.888889,                       -- 原作 EX sub110：同上
    }

    ---符卡公共骨架。wall=true ⇒ 耐久卡（不可打、不唱超时音、血量极大，life 被忽略）。
    ---life = 该符卡在原作里**开卡那一刻的 life**（多数 = 上一张非符被夹到的阈值，
    ---自带 SET_LIFE 的包壳卡用自身值 3000/8000；详见文件头的结构说明）——
    ---**不是**上一张非符的 SET_LIFE 值，别再填 20000。
    ---initfn(self) 里可以用 pspawn 放子机；卡片结束时它们会被统一清掉。
    local function spellcard(name, id, t3, life, wall, initfn)
        local live = {}
        local freeze = wall and t3 or (CARD_FREEZE[id] or CARD_FREEZE_DEFAULT)
        local card = boss.card.New(name, freeze, freeze, t3,
                                   wall and 10000000 or hpS(life))
        card.before = wall and skin_wall or skin
        card.init = function(self)
            pool4 = {}
            sound_tick4, sound_stamp4 = 0, -1
            live = {}
            spell_live = live
            enter(self)
            initfn(self)
        end
        card.frame = bframe
        card.del = function()
            for i = #live, 1, -1 do
                if IsValid(live[i]) then object.RawDel(live[i]) end
            end
            live = {}
            spell_live = nil
        end
        boss.card.add({ { card, "1a" } }, LEVEL, name, id)
    end

    ---────────── sc140 紫奥義「弾幕結界」（原作 sub 129 + 130..134，生存卡 74s） ──────────
    ---本体先进场、再走到画面正中；接着每 4450 帧一轮的「发射环」：在中点放两个子机
    ---（色档 4/6），子机从半径 0 盘旋外扩 120 帧到 rmax，随后每隔 step 帧跑一次扫射
    ---循环（共 n 次），之后继续盘旋到卡片结束。每个循环：
    ---  · 快弹（原作 SPREAD_ABS (6,li2)）：从子机本体沿「轨道切线方向 + lf3」打出；
    ---  · 慢弹（c1=3/2、速度 0.5，无声）：在外移 16px 处、以轨道角为基准做一圈随机散射。
    ---子机在轨道上的朝向 moveAngle 就是切线方向（EnemyManager 的 ENEMY_MOVE_ORBIT 分支
    ---每帧算 atan2(velocity)），换算到我们（y 轴朝上）就是「轨道角 ± 90°」。
    do
        local NAME = "紫奥義「弾幕結界」"
        ---a = { ang0, w, rmax, c, f3, f4, step, n, fast, gate, c1, v1, c2, v2 }
        ---ang0/w 是我们的角度/角速度；f3/f4 是原作 lf3/lf4 的同号量；fast = 允许打快弹的
        ---迭代上限（nil = 每轮都打）、gate = 迭代计数器回绕点（nil = 不更新，同原作里
        ---li1 卡在 1 的几支）。
        local function ring(a)
            return function(self)
                local ang, r = a.ang0, 0
                ---★ 原作 moveAngle（exit 分支 `enemy->angle = atan2(velocity)`，而
                ---`velocity = moveVec + startPos − pos`）就是**本帧位移方向**——外扩段
                ---径向速度 1.867px/帧 与切向 5.81px/帧 同量级，方向比纯切线偏 ~0.32rad。
                ---原来用「轨道角 ± 90°」（纯切向）当 moveAngle，第一拍的方向就差了 0.32。
                local vx, vy = 0, 0
                local function orbit(nr)
                    local nx, ny = math.cos(ang) * nr, math.sin(ang) * nr
                    vx, vy = nx - self.x, ny - self.y
                    self.x, self.y = nx, ny
                end
                for _ = 1, 120 do
                    ang = ang + a.w
                    r = min(a.rmax, r + a.rmax / 120)
                    orbit(r)
                    task.Wait(1)
                end
                local li1, f3 = 0, a.f3
                ---★ 原作 sub130..134 每轮都给「快弹」重发一套 INIT_BULLET_CMD（#15/#16 与
                ---#19..#22），命令的 duration 是**本轮**的 *i0/*i1 快照（子机初值 520/3，
                ---由 sub129 的 SET_INT 交给它）：*i0 每轮 −a.i0dec、*i1 每 a.i1mod 轮 +1
                ---（sub130：每轮 +1、−4；sub131..133：计数器偶数轮 +1、−3；sub134 的
                ---i2_1 每轮被 SET -1 再 INC ⇒ 恒 0 ⇒ 也是每轮 +1、−3）。
                ---五条命令连起来（`cmds4`/`TH34_cmdbullet` 逐帧跑原作 Bullet::RunCommands）：
                ---  cmd0 0x2000 spawnDelay = *i0（只影响出屏回收延迟）
                ---  cmd1 0x10 dur=*i1、speed 0 ⇒ 空转 *i1 帧
                ---  cmd2 0x40 dur=1 loop=1 speed=0 angle=0 ⇒ 再过 1 帧把速率线性压到 0
                ---  cmd3 0x10 dur=*i0、speed 0 ⇒ 定住 *i0 帧
                ---  cmd4 0x10 dur=60/90、speed 0.0333333/0.0188889/0.0266667 ⇒ 沿原方向匀加速
                ---flags = 0x2254（原作这条 SPREAD_ABS 写的 8788）。
                local i0, i1 = 520, 3
                for _ = 1, a.n do
                    local fire = atan2(vy, vx) - f3
                    if a.fast == nil or li1 < a.fast then
                        local n2 = a.c2 or 1
                        local cmds = cmds4(0x2254,
                            { type = 0x2000, dur = i0 },
                            { type = 0x10, dur = i1, speed = 0 },
                            { type = 0x40, dur = 1, loop = 1, angle = 0, speed = 0 },
                            { type = 0x10, dur = i0, speed = 0 },
                            { type = 0x10, dur = a.d4 or 90, speed = a.d4v or 0.0333333 })
                        volley4_raw(self, n2, function(j)
                            return New(class["TH34_cmdbullet"], bs(6), col16(a.c), self.x, self.y,
                                       a.v1 - (a.v1 - (a.v2 or 1)) * (j - 1) / n2,
                                       fire * RAD2DEG, cmds)
                        end)
                    end
                    local bx, by = self.x, self.y
                    self.x, self.y = bx + math.cos(fire) * 16, by + math.sin(fire) * 16
                    gspread(self, bs(6), a.c, a.c1, 1, 0.5, 1, ang * RAD2DEG,
                            (0.0349066 + ran:Float(0, 0.392699)) * RAD2DEG, false)
                    self.x, self.y = bx, by
                    ---★ 原作 #39/#40..#42（sub134 是 #36..#39）：*i0 递减、*i1 递增。
                    ---*i1 的 MOD 用的是计数器 **INC 之后**的值（sub134 里恒为 0 ⇒ 每轮都加）。
                    i0 = i0 - (a.i0dec or 3)
                    if not a.i1mod then
                        i1 = i1 + 1
                    else
                        local c = li1 + 1
                        if a.gate and c > a.gate then c = 0 end
                        if c % a.i1mod == 0 then i1 = i1 + 1 end
                    end
                    if a.gate then
                        li1 = li1 + 1
                        if li1 > a.gate then li1 = 0 end
                    end
                    f3 = f3 + a.f4
                    for _ = 1, a.step do
                        ang = ang + a.w
                        orbit(a.rmax)
                        task.Wait(1)
                    end
                end
                while true do
                    ang = ang + a.w
                    orbit(a.rmax)
                    task.Wait(1)
                end
            end
        end
        ---每一波 = { 距上一波的帧数, { 子机参数... } }。原作 t=4660 的 JUMP 跳到 instr#29
        ---（t=270）但把母体时间写成 210，每轮开头因此空转 60 帧 —— 墙钟一轮是 4450 帧。
        ---sub130..133 的循环体：l2i1 < fast 时先打一发「快弹」（#26/#27）再 JUMP 到 #31；
        ---否则从 #29 走（先做计数回绕）——两条路都会落到 #31 之后，所以**慢弹每轮都打**，
        ---快弹只看计数器。fast = 计数器上限（nil = 每轮都打快弹），
        ---gate = 计数器回绕值（原作 #29 的 JUMP_IF_LEQ 阈值 +1；nil = 不回绕，sub134 无此支）。
        local WAVES = {
            { 0, { { ang0 = PI, w = -0.0261799, rmax = 224, c = 4, f3 =  1.5708, f4 =  0.00261799, step = 4, n = 130, fast = 6, gate = 8, c1 = 3, v1 = 2.5, i0dec = 4, d4 = 60, d4v = 0.0333333 },
                   { ang0 =  0, w = -0.0261799, rmax = 224, c = 6, f3 =  1.5708, f4 =  0.00261799, step = 4, n = 130, fast = 6, gate = 8, c1 = 3, v1 = 2.5, i0dec = 4, d4 = 60, d4v = 0.0333333 } } },
            { 800, { { ang0 = PI, w =  0.0174533, rmax = 192, c = 4, f3 = -1.0472, f4 = -0.00785398, step = 3, n = 173, fast = 15, gate = 21, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0333333 },
                     { ang0 =  0, w =  0.0174533, rmax = 192, c = 6, f3 = -1.0472, f4 = -0.00785398, step = 3, n = 173, fast = 15, gate = 21, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0333333 } } },
            { 800, { { ang0 = PI, w =  0.0174533, rmax = 224, c = 4, f3 = -1.5708, f4 = -0.00261799, step = 3, n = 173, fast = 3, gate = 8, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0333333 },
                     { ang0 =  0, w =  0.0174533, rmax = 224, c = 6, f3 = -1.5708, f4 = -0.00261799, step = 3, n = 173, fast = 3, gate = 8, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0333333 } } },
            {  20, { { ang0 = PI, w = -0.0261799, rmax = 192, c = 4, f3 =  1.5708, f4 =  0.00261799, step = 3, n = 173, fast = 3, gate = 8, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0333333 },
                     { ang0 =  0, w = -0.0261799, rmax = 192, c = 6, f3 =  1.5708, f4 =  0.00261799, step = 3, n = 173, fast = 3, gate = 8, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0333333 } } },
            { 830, { { ang0 = PI, w = -0.0174533, rmax = 224, c = 4, f3 =  0.785398, f4 =  0.010472, step = 3, n = 173, fast = 3, gate = 10, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0188889 },
                     { ang0 =  0, w = -0.0174533, rmax = 224, c = 6, f3 =  0.785398, f4 =  0.010472, step = 3, n = 173, fast = 3, gate = 10, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0188889 } } },
            {  20, { { ang0 = PI, w =  0.0314159, rmax = 208, c = 4, f3 = -0.785398, f4 = -0.010472, step = 3, n = 173, fast = 3, gate = 10, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0188889 },
                     { ang0 =  0, w =  0.0314159, rmax = 208, c = 6, f3 = -0.785398, f4 = -0.010472, step = 3, n = 173, fast = 3, gate = 10, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0188889 } } },
            {  20, { { ang0 = PI, w = -0.0261799, rmax = 192, c = 4, f3 =  0.785398, f4 =  0.010472, step = 3, n = 173, fast = 3, gate = 10, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0188889 },
                     { ang0 =  0, w = -0.0261799, rmax = 192, c = 6, f3 =  0.785398, f4 =  0.010472, step = 3, n = 173, fast = 3, gate = 10, c1 = 2, v1 = 2, i0dec = 3, i1mod = 2, d4 = 90, d4v = 0.0188889 } } },
            { 890, { { ang0 = PI, w =  0.0314159, rmax = 224, c = 4, f3 = -1.5708, f4 = -0.00448799, step = 2, n = 260, c1 = 2, v1 = 2, c2 = 2, v2 = 1, i0dec = 3, d4 = 90, d4v = 0.0266667 },
                     { ang0 =  0, w =  0.0314159, rmax = 224, c = 6, f3 = -1.5708, f4 = -0.00448799, step = 2, n = 260, c1 = 2, v1 = 2, c2 = 2, v2 = 1, i0dec = 3, d4 = 90, d4v = 0.0266667 } } },
        }
        spellcard(NAME, 3440, 74, nil, true, function(self)
            task.New(self, function()
                task.Wait(210)
                bmove(self, 60, 4, 0, 0)
            end)
            task.New(self, function()
                task.Wait(280)
                while true do
                    local cur = 0
                    for _, wv in ipairs(WAVES) do
                        task.Wait(wv[1]); cur = cur + wv[1]
                        for _, p in ipairs(wv[2]) do
                            pspawn(0, 0, ring(p))
                        end
                    end
                    task.Wait(4450 - cur)
                end
            end)
        end)
    end

    ---────────── sc139 結界「生と死の境界」（原作 sub 127 + 周期 128，120s） ──────────
    ---周期回调在 t=210 挂上、10 帧后才第一次触发（t=220），此后每 10 帧一轮：
    ---第 1 层无条件、第 2..6 层随血量下降逐层解锁（原作门槛是 TH07 血量的
    ---7000/6000/4000/3000/1500，换算见 hpS）；血量 < 800 再补一发 8 发瞄准扇。
    ---回调每次把 li1 加 10，li1 >= 5700（＝第 571 次回调，t=5920）之后换成「全解锁
    ---加强版」：第 1 层照旧、第 2..6 层速度提高、末发瞄准扇改成 9 发（原作 #0 在
    ---难度分支之前，所以加强版**也**打第 1 层）。每层的基准角只在它真正开火的那一轮才自转。
    ---本体在 {−64..64, 96..160} 的小框里每 300 帧随机漂一次（原作 t=810 的 300 帧循环）；
    ---那次 RAND_EXIT_ANGLE 写的就是 lf0，也就是第 1 层的基准角，所以每 300 帧会被重掷。
    do
        local NAME = "結界「生と死の境界」"
        ---{血量门槛, sprite, 色档, c1, c2, v1, v2, 每轮基准角增量, a2}。at 用 hpS 折算
        ---（本卡的开卡 life 是 8000 ⇒ 门槛 7000/6000/4000/3000/1500 才有意义）。
        ---第 1 层永远打、不看 at（原作 sub128 的血量分支在它之后），20000 只是占位。
        local LAYER = {
            { at = hpS(20000), spr =  2, off = 6, c1 = 7, c2 = 1, v1 = 2.0, v2 = 1, d = -0.349066, a2 = 0.392699 },
            { at = hpS(7000),  spr =  8, off = 2, c1 = 5, c2 = 1, v1 = 1.5, v2 = 1, d =  0.392699, a2 = 0.196350 },
            { at = hpS(6000),  spr = 10, off = 0, c1 = 2, c2 = 1, v1 = 1.2, v2 = 1, d = -0.448799, a2 = 0.785398 },
            { at = hpS(4000),  spr =  6, off = 5, c1 = 4, c2 = 2, v1 = 1.7, v2 = 1, d = -0.130900, a2 = 0.392699 },
            { at = hpS(3000),  spr =  7, off = 6, c1 = 5, c2 = 1, v1 = 2.5, v2 = 1, d =  0.130900, a2 = 0.392699 },
            { at = hpS(1500),  spr =  7, off = 4, c1 = 5, c2 = 2, v1 = 3.5, v2 = 2, d = -0.523599, a2 = 0.392699 },
        }
        ---t >= 5700 之后那一整套「加强版」（原作 sub128 的 #52..#72）：用的还是 lf1..lf5 的角。
        local RAGE = {
            { spr =  8, off = 2, c1 = 5, c2 = 1, v1 = 2.5, v2 = 1, d =  0.392699, a2 = 0.196350 },
            { spr = 10, off = 0, c1 = 2, c2 = 1, v1 = 2.2, v2 = 1, d = -0.448799, a2 = 0.785398 },
            { spr =  6, off = 5, c1 = 4, c2 = 2, v1 = 2.7, v2 = 1, d = -0.130900, a2 = 0.392699 },
            { spr =  7, off = 6, c1 = 5, c2 = 1, v1 = 3.5, v2 = 1, d =  0.130900, a2 = 0.392699 },
            { spr =  7, off = 4, c1 = 5, c2 = 2, v1 = 4.5, v2 = 2, d = -0.523599, a2 = 0.392699 },
        }
        spellcard(NAME, 3441, 120, 8000, false, function(self)
            self._box = { -64, 64, 96, 160 }
            ---★ 原作开卡时连抽 7 个 RNGRAD（*f0..*f6）。最后那个 *f6 的初值**从不被读**
            ---（它一进回调就被 RAND_FLOAT_ADD 覆盖），但它**照样要抽**——少抽一次，
            ---从 t=810 的 RAND_EXIT_ANGLE 起整条随机流就错位，全卡的弹道跟着全错。
            ---acc 存的是**我们的角度制**（顺指针为正）：原作 f0..f5 是 CCW 弧度，取负。
            local acc = { -rngrad(), -rngrad(), -rngrad(), -rngrad(), -rngrad(), -rngrad() }
            local _ = rngrad()
            task.New(self, function()
                task.Wait(220)                    -- 原作 #36 在 t=210 挂回调、10 帧后才首发
                ---原作 sub128 每 10 帧回调一次：li1 每次 +10，>= 5700（第 571 次、t=5920）
                ---就换成「全解锁加强版」；否则按剩余 life 逐层解锁，血量 < 800 才补那发瞄准扇。
                local t, lv = 0, 0
                while true do
                    ---第 1 层（原作 sub128 #0）：在难度/血量分支之前，两段都打。
                    local L1 = LAYER[1]
                    gspread(self, bs(L1.spr), L1.off, L1.c1, L1.c2, L1.v1, L1.v2,
                            acc[1] * RAD2DEG, L1.a2 * RAD2DEG, true)
                    acc[1] = acc[1] + L1.d
                    if t >= 5700 then
                        if lv < 6 then
                            lv = 6
                            PlaySound("tan00", 0.1, self.x / 256)   -- 原作 sub128 #54 PLAY_SOUND 0xf
                        end
                        for k, R in ipairs(RAGE) do
                            gspread(self, bs(R.spr), R.off, R.c1, R.c2, R.v1, R.v2,
                                    acc[k + 1] * RAD2DEG, R.a2 * RAD2DEG, true)
                            acc[k + 1] = acc[k + 1] + R.d
                        end
                        shoot(self, 64, 8, 4, 9, 1, 5, 2, 0,
                              0.19635 + ran:Float(0, 0.392699), true)
                    else
                        for k = 2, #LAYER do
                            local L = LAYER[k]
                            if self.hp <= L.at then
                                if lv < k then
                                    lv = k
                                    PlaySound("tan00", 0.1, self.x / 256)   -- 原作 sub128 #7/#15/#23/#31/#39 解锁音
                                end
                                gspread(self, bs(L.spr), L.off, L.c1, L.c2, L.v1, L.v2,
                                        acc[k] * RAD2DEG, L.a2 * RAD2DEG, true)
                                acc[k] = acc[k] + L.d
                            end
                        end
                        if self.hp <= hpS(800) then
                            if lv < 6 then
                                lv = 6
                                PlaySound("tan00", 0.1, self.x / 256)   -- 原作 sub128 #47 PLAY_SOUND 0xf
                            end
                            shoot(self, 64, 8, 4, 8, 1, 4, 2, 0,
                                  0.19635 + ran:Float(0, 0.392699), true)
                        end
                    end
                    t = t + 10
                    task.Wait(10)
                end
            end)
            task.New(self, function()
                task.Wait(810)
                while true do
                    ---原作 sub127 #38/#39：RAND_EXIT_ANGLE *f0 + MOVE_DIR_TIME(60,0,*f0,1)。
                    ---★ 这个 *f0 是**主 sub 自己的 f0**，只驱动本体漂移；周期回调 sub128/sub124
                    ---用的是它自己那份 f0（开卡初值 + 每次回调 +0.349066），两者互不影响。
                    ---早先把重掷结果写回 acc[1]，会让第 1 层的基准角从 t=810 起整段错位。
                    local a = exang(self)
                    bmove(self, 60, 0, self.x + cos(a / RAD2DEG) * 60, self.y - sin(a / RAD2DEG) * 60)
                    task.Wait(300)
                end
            end)
        end)
    end

    ---────────── sc138 「人間と妖怪の境界」（原作 sub 119，生存卡 76s） ──────────
    ---与 EX「狐狗狸さんの契約」同构（差别只在炮台间隔 36 帧 / 弹速 1.4 / 角炮速度与角步进）。
    ---本体（原作 sub119）：
    ---  · t=210 用 120 帧 ease-in 飘到「t=210 那一刻的自机位置」（原作 #28），随后 120 帧
    ---    每帧把 posX/posY 写成自机当前坐标（原作 #34..#36 的循环），即「贴住自机」两秒；
    ---    第一段插值走完（≈t=331，原作 #29..#31 只是空转 120 帧）时，在**当时的本体坐标**
    ---    放出中心激光星（原作 sub125）——所以激光星以 t=210 的自机位置为中心展开。
    ---  · 贴住结束（≈t=451）响 #37 的音、用 120 帧线性飘回正中，并在同一帧放出四角炮台
    ---    （原作 #41..#47 被前面的循环压后到这里；之后 t=851/1451/1951 三波按绝对时间）。
    ---  · t=845/1151 在下方左右横穿、t=1851 到**异侧** (∓160,64)、t=2551 到同侧 (±160,0)、
    ---    t=2951 回正中。
    ---  · t=3051 起 16 波角炮：每发 3 颗（v1 从 0.8 起每发 +0.2、v2 恒 0.8、张角 30°），
    ---    基准角每发前进 lf1（前三波 0.15708、第 4..6 波 0.19635、之后 0.261799；翻面取反），
    ---    4 个角按「左上→右下→右上→左下」轮转，基准角 = 0 / 180 / −90 / 90 再 −rand(0,5.625°)。
    do
        local NAME = "「人間と妖怪の境界」"
        ---边缘炮台（原作 sub120..123）：一次性 MOVE_POS_TIME 走到 (tx,ty)，边飞边每 36 帧
        ---打一发速度 1.4 的慢弹；spriteOffset 取父体继承下来的 li0 = 6。
        local function turret(self, a)
            bmove(self, a.mv, 0, a.tx, a.ty)
            local t = 0
            while true do
                if t % 36 == 0 then
                    volley3(self, 1, function() return bs(1), col16(6), 1.4, a.a end, true)
                end
                bstep(self)
                t = t + 1
                task.Wait(1)
            end
        end
        ---角炮（原作 sub124）：每 8 帧一发、共 10 发、每发 3 颗（速度 v1 从 0.8 起每发
        ---+0.2、v2 恒 0.8、张角 30°），基准角每发前进 a.f（原作 `ADD_FLOAT *f0 *f0 *f1`
        ---是**弧度/发**；a.f 此后仍按原作弧度存，进 `gspread`（度）前 ×RAD2DEG 换算 ——
        ---漏换算时每发只转 0.157°，整条角阶梯全是错的）。
        local function corner(self, a)
            local ang, v = a.a, 0.8
            for _ = 1, 10 do
                gspread(self, bs(8), 3, 1, 3, v, 0.8, ang, 30, true)
                ang, v = ang - a.f * RAD2DEG, v + 0.2
                task.Wait(8)
            end
        end
        spellcard(NAME, 3442, 76, nil, true, function(self)
            ---本体轨迹（原作 sub119）。
            task.New(self, function()
                task.Wait(210)
                local px, py = player.x, player.y
                bmove(self, 120, 1, px, py)          -- 原作 #28：120 帧 ease-in 到自机位置
                task.Wait(120)                       -- 原作 #29..#31：空转 120 帧
                self._mv = nil
                self.x, self.y = px, py              -- 收尾那一帧的插值补正
                pspawn(self.x, self.y, function(o) laser_star(o.x, o.y) end)   -- 原作 sub125
                for _ = 1, 120 do                    -- 原作 #34..#36：本体贴住自机 120 帧
                    self.x, self.y = player.x, player.y
                    task.Wait(1)
                end
                PlaySound("power0", 0.35, self.x / 256)    -- 原作 #37 PLAY_SOUND 5
                bmove(self, 120, 0, 0, 0)            -- 原作 #38：线性回正中
                ---原作 sub119 的 #29..#31 / #34..#36 两段各 120 次整数的 DEC_JUMP 空转
                ---不推进母体时间，却实打实走了 238 帧 ⇒ 此后所有绝对时间都要 +238。
                task.Wait(633)                       -- ≈t=450 → t=1083
                local sx = (player.x >= 0) and 1 or -1
                bmove(self, 300, 0, 128 * sx, 128)   -- 原作 #52/#55
                task.Wait(306)                       -- → t=1151
                bmove(self, 400, 0, 128 * sx, -160)  -- 原作 #67/#69
                task.Wait(700)                       -- → t=1851
                bmove(self, 480, 0, -160 * sx, 64)   -- 原作 #80/#82：换到**异侧**
                task.Wait(700)                       -- → t=2551
                bmove(self, 380, 0, 160 * sx, 0)     -- 原作 #94/#96
                task.Wait(400)                       -- → t=2951
                bmove(self, 300, 0, 0, 0)            -- 原作 #98：回正中
            end)
            ---原作 PLAY_SOUND 5（se_power0）共 6 次：#37 被压到 ≈t=450，
            ---#48/#64/#77/#91/#97 按绝对时间 1023/1329/2029/2729/3129 响。
            task.New(self, function()
                local cur = 450
                PlaySound("power0", 0.35, self.x / 256)
                for _, tw in ipairs({ 1023, 1329, 2029, 2729, 3129 }) do
                    task.Wait(tw - cur); cur = tw
                    PlaySound("power0", 0.35, self.x / 256)
                end
            end)
            ---四边炮台：{帧, {sub120/121/122/123 的 {出生点,目标点,发射角,波内延迟}}}（我们的坐标）。
            ---第一波（原作 t=212/223/234/245）被 sub119 的循环压到 ≈t=450 同时出现；
            ---之后三波的原作指令时刻 t=851/1451/1951 也同样落在墙钟 1089/1689/2189。
            ---第 6 项 = 本波内的额外延迟：第一波的原作四条指令分别落在
            ---内部 t=212/223/234/245（墙钟 450/461/472/483），后三波同帧。
            ---★ 出生点必须**逐波**照抄 ECL 的 `SPAWN_ENEMY_ABS` 坐标（第 2/3 个参数）：
            ---  第一波（t=212/223/234/245）与第二波（t=851）四条全是常数 ⇒ 从四角出生；
            ---  但第三波（t=1451）与第四波（t=1951）的坐标里各有一项是 `*f0`
            ---  （= 紧邻的 `SET_FLOAT *f0`，其值又常是**上一波**最后留下的那个），
            ---  而子敌在 `SPAWN_ENEMY_ABS` 那一刻**继承调用方的局部 f 变量**
            ---  （spawn 会把调用方的 eclContextArgs 拷给新敌）⇒ 于是
            ---  `MOVE_POS_TIME` 的终点 (= (0,f0) / (384,f0) / (f0,0) / (f0,448))
            ---  恰好与出生点重合 —— 那两波炮台**原地不动**（原作墙钟 1689/2189 起）。
            ---  旧实现一律从四角出生再飞过去，于是从 1689 帧起位置整段错开
            ---  （每 44 帧一轮、每轮 4 发的错位就是这里来的）。
            ---每条 = { 出生 x, 出生 y, 目标 x, 目标 y, 发射角, 波内延迟 }（我们的坐标）。
            local BAT = {
                {  450, { { -192,  224, -192,  -96,   0,  0 }, { 192, -224, 192,   96, 180, 11 },
                          {  192,  224,  -64,  224, -90, 22 }, { -192, -224,  64, -224,  90, 33 } } },
                { 1089, { { -192,  224, -192, -128,   0 }, { 192, -224, 192,  128, 180 },
                          {  192,  224,  -96,  224, -90 }, { -192, -224,  96, -224,  90 } } },
                { 1689, { { -192,  -64, -192,  -64,   0 }, { 192,   64, 192,   64, 180 },
                          {  -32,  224,  -32,  224, -90 }, {   32, -224,  32, -224,  90 } } },
                { 2189, { { -192, -160, -192, -160,   0 }, { 192,  160, 192,  160, 180 },
                          { -128,  224, -128,  224, -90 }, {  128, -224, 128, -224,  90 } } },
            }
            local MV = { 400, 400, 300, 300 }
            task.New(self, function()
                local now = 0
                local function at(t) if t > now then task.Wait(t - now); now = t end end
                for _, b in ipairs(BAT) do
                    for k = 1, 4 do
                        local e = b[2][k]
                        at(b[1] + (e[6] or 0))
                        pspawn(e[1], e[2], turret,
                               { tx = e[3], ty = e[4], a = e[5], mv = MV[k] })
                    end
                end
            end)
            ---角炮：t=3051 起 16 波（间隔 150→…→40 帧），4 个角轮转、基准角见上。
            do
                local C = { { -192,  224,   0 },
                            {  192, -224, 180 },
                            {  192,  224, -90 },
                            { -192, -224,  90 } }
                local SW = { 3289, 3439, 3589, 3739, 3839, 3939, 4029, 4109,
                             4169, 4219, 4259, 4299, 4339, 4379, 4419, 4459 }
                task.New(self, function()
                    task.Wait(SW[1])
                    for k = 1, #SW do
                        if k > 1 then task.Wait(SW[k] - SW[k - 1]) end
                        local c = C[((k - 1) % 4) + 1]
                        ---原作 sub119 每波 `SET_FLOAT *f1`：0.15708 / 0.19635 / 0.261799 弧度
                        ---（= 9° / 11.25° / 15°，前 3 波 / 中 3 波 / 后 10 波）。
                        local f = k <= 3 and 0.15708 or (k <= 6 and 0.19635 or 0.261799)
                        pspawn(c[1], c[2], corner, { a = c[3] - ran:Float(0, 5.625), f = f })
                    end
                end)
            end
        end)
    end
    ---────────── sc137 式神「八雲藍」（原作 sub 114..118，80s） ──────────
    ---t=280 本体走到 (0,160) 并放出一只「蓝」子机（原作 sub115）；此后本体每轮打一圈
    ---24 发瞄准环（速度 1.8），轮间隔 l2i1 从 90 帧每轮 −2、到 40 帧后固定。
    ---「蓝」子机在 6 个驻点间循环：每轮 70 帧插值到下一个点，到点后打「20 发环 ×2 层」
    ---+「上下两扇 8 发瞄准弹 ×2 层」并响一次音；色档按状态奇偶取 3/1。
    do
        local NAME = "式神「八雲藍」"
        ---「蓝」子机（原作 sub115 的 li0 状态机；坐标已翻面）。
        local function ran_you(self)
            local st = 0
            while true do
                local tx, ty
                ---六个驻点（原作 sub115 的 li0 状态机；坐标已按 x−192 / 224−y 换算）：
                ---  0:(16, 160+rand128)  1:(plX, 448)  2:(plX, 16)
                ---  3:(368,160+rand128)  4:(plX, 448)  5:(plX, 16)
                if st == 0 then
                    tx, ty = -176, 64 - ran:Float(0, 128)
                elseif st == 1 or st == 4 then
                    tx, ty = player.x, -224
                elseif st == 2 or st == 5 then
                    tx, ty = player.x, 208
                else
                    tx, ty = 176, 64 - ran:Float(0, 128)
                end
                bmove(self, 70, 4, tx, ty)
                ---★ 本作用域的 `PSCRIPT`（5991 行）没有挂 `frame`，子机的 `bstep` 得自己推
                ---（同 sub120 炮台 6468 行的写法）。漏了这一步「蓝」就永远停在出生点，
                ---三环全从本体位置发出（原作 MOVE_POS_TIME 70 是真在飞 70 帧）。
                for _ = 1, 70 do bstep(self); task.Wait(1) end
                ---色档：原作 li3 = (已 +1 的 li0) % 2，li3==1 时 spriteOffset = 3，否则 1。
                local c = (st % 2 == 0) and 3 or 1
                local aim = Angle(self, player)
                gring(self, bs(8), c, 20, 2, 2, 1, 0, 0, true)
                gspread(self, bs(8), c, 8, 2, 8, 1, aim - 90, 0.19635 * RAD2DEG, true)
                gspread(self, bs(8), c, 8, 2, 8, 1, aim + 90, 0.19635 * RAD2DEG, true)
                PlaySound("tan00", 0.1, self.x / 256)    -- 原作 sub115 #53 PLAY_SOUND 0xf
                st = (st + 1) % 6
            end
        end
        spellcard(NAME, 3443, 80, 2000, false, function(self)
            self._box = { -128, 128, 96, 176 }
            task.New(self, function()
                task.Wait(210)                            -- 母体 t=210
                PlaySound("power0", 0.35, self.x / 256)   -- 原作 SUB_CALL 2（gI0=15 ⇒ 冻结 60 帧）
                task.Wait(60)
                task.Wait(70)                             -- 冻结结束后再从 t=210 走到 t=280
                bmove(self, 60, 4, 0, 160)                -- 原作 MOVE_POS_TIME(60,4,192,64)
            end)
            task.New(self, function()
                task.Wait(210)
                PlaySound("power0", 0.35, self.x / 256)   -- 同上
                task.Wait(60)
                task.Wait(70)                             -- 母体 t=280
                pspawn(self.x, self.y, ran_you)           -- 原作 #29 SPAWN_ENEMY_REL 115
                local gap = 90
                while true do
                    gring(self, bs(2), 6, 24, 1, 1.8, 1, Angle(self, player), 0, true)
                    task.Wait(gap)
                    if gap > 40 then gap = gap - 2 end
                end
            end)
        end)
    end

    ---────────── sc136 魍魎「二重黒死蝶」（原作 sub 109 + 110..113，80s） ──────────
    ---本体每轮打两批「黑死蝶」（相隔 180 帧、每批前等 l2i1 帧）：
    ---  · 第一批：sub110（spr8/色3，28+l2i3 组）+ sub111（spr8/色1，20+l2i3 组）；
    ---  · 第二批：sub112（spr9/色4，20+l2i3）+ sub113（spr9/色2，28+l2i3）。
    ---每组 = 同一帧连打「4 发环」（90° 间隔、基准角随机、速度 rand(2,7)），子弹随后
    ---每帧转 1°、速度 +0.0111111（原作 INIT_BULLET_CMD 0x20，左右两批反向）。
    ---l2i3 每轮 +4（弹数逐轮变多）；等待 l2i1 从 78 每段 −4、到 40 以下就固定。
    do
        local NAME = "魍魎「二重黒死蝶」"
        ---一批「黑死蝶」：rings 组 4 发环；curve = 每帧角度增量（度，我们的口径）。
        ---原件那几条 RING_ABS 的 flags = 0x2270 同时挂着三条指令：先 0x40 沿原朝向
        ---120 帧把速度线性刹到 0（cmd.spd=0 当角增量、cmd.ang=0 当刹后速度 ⇒ 停住），
        ---再 0x20 每帧转 curve、速度 +0.0111111（180 帧），最后 0x10 沿此刻朝向每帧
        ---再 +0.00666667（120 帧，TargetVelocity ⇒ 本文件的 accel 字段）。
        local function flock(self, spr, col, rings, curve)
            for _ = 1, rings do
                ---★ 原作 sub110/111/112/113 的循环体是「先 `RAND_FLOAT_ADD *f0 5 2`（速度），
                ---再 `RING_ABS ... *f0 2 *RNGRAD ...`」——速度那一次抽样发生在**前一条指令**，
                ---而 *RNGRAD（角度）是在 RING_ABS 求值时抽的。所以随机数顺序是「先速度、后角度」；
                ---写反会让每一圈的速度/角度互换，整张卡的弹速全错。
                local v = ran:Float(2, 7)
                ---*RNGRAD 是 TH07 口径的弧度角（y 朝下），本仓库角度取反 ⇒ 取负。
                local a0 = -rngdeg()
                local cmd = { stages = {
                    { type = 0x40, dur = 120, loop = 1, angle = 0, speed = 0 },
                    { type = 0x20, dur = 180, loop = -1, angle = curve, speed = 0.0111111 },
                    { type = 0x10, dur = 120, loop = -1, accel = 0.00666667 },
                } }
                for k = 0, 3 do
                    pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(spr), col16(col),
                                            self.x, self.y, v, a0 + k * 90, cmd)
                end
            end
            sound4(self)
        end
        spellcard(NAME, 3444, 80, 2700, false, function(self)
            self._box = { -128, 128, 96, 176 }
            task.New(self, function()
                task.Wait(210)                            -- 母体 t=210：第一批
                local k, gap = 0, 78
                while true do
                    flock(self, 8, 3, 28 + k, -1)         -- 原作 sub110（spr8/色3、−1°/帧）
                    flock(self, 8, 1, 20 + k,  1)         -- 原作 sub111（spr8/色1、+1°/帧）
                    task.Wait(60)                         -- t=210 → t=270
                    PlaySound("power0", 0.35, self.x / 256)   -- SUB_CALL 2（gI0=30 ⇒ 冻结 120 帧）
                    task.Wait(120)
                    task.Wait(120)                        -- 冻结后再从 t=270 走到 t=390
                    exdrift(self, 1, 0)                   -- 原作 MOVE_DIR_TIME(60,0,lf0,1)
                    task.Wait(gap)                        -- 原作 SET_WAIT_TIMER(l2i1)
                    if gap > 40 then gap = gap - 4 end
                    k = k + 2
                    flock(self, 9, 4, 20 + k, -1)         -- 原作 sub112（spr9/色4）
                    flock(self, 9, 2, 28 + k,  1)         -- 原作 sub113（spr9/色2）
                    task.Wait(60)                         -- t=390 → t=450
                    PlaySound("power0", 0.35, self.x / 256)   -- SUB_CALL 2（gI0=30 ⇒ 冻结 120 帧）
                    task.Wait(120)
                    task.Wait(120)                        -- 冻结后再从 t=450 走到 t=570
                    exdrift(self, 1, 0)
                    task.Wait(gap)
                    if gap > 40 then gap = gap - 4 end
                    k = k + 2
                end
            end)
        end)
    end

    ---原作 PH sub107（= EX sub104）的「激光风车」：半径 122、色档 6、每帧 +0.36°（我们的口径）。
    ---四臂 = 一条径向段（sOff=16,eOff=122,sLen=122）+ 一条根部落在半径 122 圆周上、沿
    ---切线射出的段（sOff=0,eOff=122,sLen=122）；切线段的根部每帧随臂角在圆周上滑
    ---动（原作 SET_LASER_POS_REL），所以两段始终接成 L 形。
    ---f=0 放 4 条径向段（tStart=60,dur=340,tEnd=16,判定 60..16）；f=100 放 4 条切线段
    ---（120,180,16,判定 120..16）并转入 300 帧的「旋转程」；f=400 两组一起换成
    ---tStart=630/dur=338/tEnd=32/判定 600..32 的下一轮，再转 1000 帧，随后回到 f=400
    ---无限循环（每轮 lf7 恰好 −360°）。
    ---★ 原作有**两套反向累积**的相位：臂角靠 ADD_LASER_ANGLE 每帧 −w（我们的口径 +w ⇒ a7），
    ---lf7 每帧 +w（我们的口径 −w ⇒ lf7）。循环段开头用的是 **lf7**（原作 #55/#56 的
    ---`NORMALIZE_ANGLE lf7` + `lf0 = lf7`，#76 又拿它当切线段位置基准），不是臂角的平滑续接；
    ---两套相位每帧差 2w ⇒ 循环接管的那一帧（f=400）比「臂角续接」多转 2·400·w ≡ −0.4π
    ---（mod 2π），又因 1000·w 恰好一整圈，此后每一轮都固定差这 −0.4π。所以循环段必须用 lf7，
    ---a7 只管开局那两波。旧激光不被新生成顶掉（原作只覆写 enemy->lasers 槽位指针，
    ---池里的老激光仍活到自己寿终），所以这里也不主动删。
    local function laser_rig107(self)
        local W, R = 0.00628319, 122
        local a7 = -PI / 4        -- 臂角（我们的口径，每帧 +w）：开局两波的 spawn 基准
        local lf7 = -PI / 4       -- 原作 lf7 的取反版（每帧 −w）：循环段的 spawn 基准
        local live = {}
        local function spawn(radial, sOff, eOff, ts, dur, te, hbS, hbE, base)
            base = base or a7
            for k = 0, 3 do
                local arm = base - k * PI / 2
                local o = plaser(0, 0, radial and arm or (arm + PI / 2), {
                    spr = 6, w = 24, sOff = sOff, eOff = eOff, sLen = eOff,
                    tStart = ts, dur = dur, tEnd = te, hbStart = hbS, hbEnd = hbE })
                if not radial then
                    o._tang = true
                    o.pl_x, o.pl_y = math.cos(arm) * R, math.sin(arm) * R
                end
                live[#live + 1] = o
            end
        end
        local function rot()
            for i = #live, 1, -1 do
                local o = live[i]
                if IsValid(o) then
                    o.pl_ang = o.pl_ang + W
                    if o._tang then
                        local aa = o.pl_ang - PI / 2
                        o.pl_x, o.pl_y = math.cos(aa) * R, math.sin(aa) * R
                    end
                else
                    table.remove(live, i)
                end
            end
            a7, lf7 = a7 + W, lf7 - W
        end
        spawn(true, 16, 122, 60, 340, 16, 60, 16)        -- f=0
        rot()
        for _ = 1, 99 do task.Wait(1); rot() end         -- f=1..99
        spawn(false, 0, 122, 120, 180, 16, 120, 16)      -- f=100
        rot()
        for _ = 1, 299 do task.Wait(1); rot() end        -- f=101..399
        while true do                                    -- f=400、1400、…（每轮 1000 帧）
            spawn(true, 16, 122, 630, 338, 32, 600, 32, lf7)
            spawn(false, 0, 122, 630, 338, 32, 600, 32, lf7)
            rot()
            for _ = 1, 999 do task.Wait(1); rot() end    -- f=401..1399
        end
    end

    ---原作 PH sub108（= EX sub105）的第二台「激光风车」：半径 152、色档 2、每帧 −1°（我们的口径）。
    ---径向段 sOff=16,eOff=152,sLen=152；切线段 sOff=0,eOff=320,sLen=320；
    ---8 条一起在 f=0 放（tStart=430,dur=538,tEnd=32,判定 600..32），
    ---转 1000 帧后整个子程序从 #0 重来（角度复位）。
    local function laser_rig108(self)
        local W, R, BASE = -0.0174533, 152, -PI / 4
        while true do
            local live = {}
            for k = 0, 3 do
                local arm = BASE - k * PI / 2
                live[#live + 1] = plaser(0, 0, arm, {
                    spr = 2, w = 24, sOff = 16, eOff = 152, sLen = 152,
                    tStart = 430, dur = 538, tEnd = 32, hbStart = 600, hbEnd = 32 })
                local o = plaser(math.cos(arm) * R, math.sin(arm) * R, arm + PI / 2, {
                    spr = 2, w = 24, sOff = 0, eOff = 320, sLen = 320,
                    tStart = 430, dur = 538, tEnd = 32, hbStart = 600, hbEnd = 32 })
                o._tang = true
                live[#live + 1] = o
            end
            for _ = 0, 999 do
                for i = 1, #live do
                    local o = live[i]
                    if IsValid(o) then
                        o.pl_ang = o.pl_ang + W
                        if o._tang then
                            local aa = o.pl_ang - PI / 2
                            o.pl_x, o.pl_y = math.cos(aa) * R, math.sin(aa) * R
                        end
                    end
                end
                task.Wait(1)
            end
        end
    end
    ---────────── sc135 罔両「禅寺に棲む妖蝶」（原作 sub 104 + 105..108，80s） ──────────
    ---本体停在正中（关掉移动框）。原作的 SUB_CALL 2 会把主 sub 冻结 gI0×4 帧
    ---（主 sub 的 time 在子程序里不推进，EclManager.cpp:105 的 CallEclSub 把 time 置 0、
    ---返回时再整个恢复），t=210 冻 64 帧、t=480 与 t=980 各冻 100 帧，
    ---一轮真实长度 800+264 = 1064 帧：
    ---  · 真实 274 放出两台「妖蝶」激光台（sub107/108），并把周期回调设成每 8 帧一波
    ---    乱射（sub105）——回调独立于主 sub，冻结期间照样开火，再被下一波清屏带走；
    ---  · 真实 544 爆闪（原作 t=480）→ 644 清屏并关掉回调；
    ---  · 真实 704 改成每 10 帧一波的三组 5 发瞄准环（sub106；三组的 flags 是
    ---    0x202/0x2222/0x2222 ⇒ 第 2、3 环的子弹挂 0x20，60 帧里朝 ∓0.9°/帧）；
    ---  · 真实 1144 爆闪（原作 t=980）→ 1244 清屏、改成每 20 帧一波乱射；真实 1274 跳回 t=210。
    do
        local NAME = "罔両「禅寺に棲む妖蝶」"
        ---乱射（原作 sub105 的 RANDOM pk=(8,3) c1=2）：sprite8/色3、速度 rand(1,4)、
        ---方向全周随机；flags=8802 含 bit 0x40/0x20 ⇒ 每发挂「120 帧刹到停、
        ---再以 0.1 直飞」的 0x40 与随后的 0x20（再花 60 帧每帧 −0.00666667）。
        local function volley105(self)
            volley4_raw(self, 2, function()
                ---★ 原作 sub105 就是 op72 RANDOM：逐发**先抽角、后抽速**（BulletManager.cpp:215-231）。
                ---角度是 TH07 口径（y 朝下），本仓库取反 ⇒ 取负。
                local th = -rngdeg()
                local v = ran:Float(1, 4)
                return New(class["TH34_cmdbullet"], bs(8), col16(3), self.x, self.y,
                           v, th, { stages = {
                               { type = 0x40, dur = 120, loop = 1, angle = 0, speed = 0.1 },
                               { type = 0x20, dur = 60, loop = -1, angle = 0, speed = -0.00666667 },
                           } })
            end)
        end
        ---瞄准环（原作 sub106 的 RING_AIMED pk=(8,1) c1=5）：三组同帧、朝自机、速度 4。
        ---★ 三组的 flags（第 8 个参数）分别是 0x202 / 0x2222 / 0x2222 —— args[7] 是**真字段**
        ---（指令长 44 字节；EclManager.cpp `bulletProps->flags = bulletInstrArgs[7].u`），
        ---不是「下一条指令的 time」。0x2222 含 0x20 位 ⇒ 第 2、3 环的子弹挂得上
        ---INIT_BULLET_CMD idx=1 的 0x20：60 帧里朝向每帧 ∓0.9°、速度不变。
        ---（第 1 环 0x202 没有 0x20 位，所以不挂指令 —— 移植版原来把三环都当成了这种。）
        local function ring106(self)
            local aim = Angle(self, player)
            gring(self, bs(8), 1, 5, 1, 4, 1, aim, 0, false)
            for _, dth in ipairs({ -0.9, 0.9 }) do
                for k = 0, 4 do
                    pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(8), col16(1),
                                            self.x, self.y, 4, aim + k * 72,
                                            { type = 0x20, dur = 60, loop = -1,
                                              angle = dth, speed = 0 })
                end
            end
            sound4(self)
        end
        spellcard(NAME, 3445, 80, 2700, false, function(self)
            task.New(self, function()
                bmove(self, 120, 4, 0, 0)
            end)
            ---周期回调：duty = 间隔（0 = 关）；原作每次 SET_PERIODIC_CALLBACK 都把
            ---计数器清零（EclManager.cpp:1740），所以 set_duty 也要重置 counter。
            local duty, fire, counter = 0, nil, 0
            local function set_duty(d, f) duty, fire, counter = d, f, 0 end
            task.New(self, function()
                while true do
                    task.Wait(1)
                    if duty > 0 then
                        counter = counter + 1
                        if counter >= duty then counter = 0; fire() end
                    end
                end
            end)
            task.New(self, function()
                task.Wait(210)
                ---★ 原作 sub104 的 JUMP 是 `JUMP 210 -280`：落点是 **#31 `SET_PERIODIC_CALLBACK 8 105`**
                ---（off 41448），**跳过** #22..#30 的 OP0/SET_INT/SUB_CALL 2/SPAWN 107/108。
                ---所以只有第一轮才做 SUB_CALL 2 的 64 帧冻结与两台激光台出生；
                ---之后每轮从 `SET_PERIODIC 8 105` 直接续上（本轮起再从头跑一遍是错的）。
                PlaySound("power0", 0.35, self.x / 256)       -- 原作 SUB_CALL 2（gI0=16 ⇒ 64 帧）
                task.Wait(64)
                pspawn(0, 0, laser_rig107)                   -- 原作 sub107
                pspawn(0, 0, laser_rig108)                   -- 原作 sub108
                set_duty(8, function() volley105(self) end)
                while true do
                    task.Wait(270)                           -- 真实 274 → 544（原作 t=480）
                    PlaySound("nep00", 0.5, self.x / 256)    -- 原作 #32 PLAY_SOUND 0x13（se_nep00）
                    PlaySound("power0", 0.35, self.x / 256)  -- 原作 #35 SUB_CALL 2（gI0=25 ⇒ 100 帧）
                    task.Wait(100)
                    PlaySound("tan00", 0.1, self.x / 256)    -- 原作 #36 PLAY_SOUND 0xf
                    pclear()
                    set_duty(0, nil)
                    task.Wait(60)                            -- 真实 644 → 704（原作 t=540）
                    set_duty(10, function() ring106(self) end)
                    task.Wait(440)                           -- 真实 704 → 1144（原作 t=980）
                    PlaySound("nep00", 0.5, self.x / 256)    -- 原作 #40 PLAY_SOUND 0x13（se_nep00）
                    PlaySound("power0", 0.35, self.x / 256)  -- 原作 #43 SUB_CALL 2（gI0=25 ⇒ 100 帧）
                    task.Wait(100)
                    PlaySound("tan00", 0.1, self.x / 256)    -- 原作 #44 PLAY_SOUND 0xf
                    pclear()
                    set_duty(20, function() volley105(self) end)
                    task.Wait(30)                            -- 真实 1244 → 1274（t=1010 的 JUMP）
                    set_duty(8, function() volley105(self) end)  -- JUMP 落点 #31：直接续上周期 8
                end
            end)
        end)
    end

    ---────────── sc134 罔両「八雲紫の神隠し」（原作 sub 102 + 103，75s） ──────────
    ---本体走到 (0,128)（原作 MOVE_POS_TIME(120,4,192,96)）。每轮（原作 #28..#59）：
    ---  · t=210 先爆闪一次（原作 SUB_CALL 2，gI0=4 ⇒ 主 sub 冻结 16 帧、音效 + 粒子）；
    ---  · t=240（母体时间）朝自机方向的三个「定向散弹」（sub103，相隔 120°、各 25 发 /
    ---    5 帧；母体逐个 SUB_CALL，每个再冻结 4 帧）+ 6 条 60° 间隔的长激光
    ---    （同帧一起 spawn：60 帧蓄力、60 帧满宽、30 帧收束，color4）；
    ---  · t=243 / t=246 各等一下，t=246 打一圈 28 发 ×4 层瞄准环（速度 3→1）；
    ---  · t=266 先隐身（SET_HAS_NO_COLLISION 1）、等 l2i1 帧后瞬移到自机身上，
    ---    再爆闪一次（SUB_CALL 2，gI0=10 ⇒ 冻结 40 帧）后现身、回到 t=210。
    ---SUB_CALL 不推进母体时间，但真实帧照走：一轮真实长度 = 124 + l2i1 帧
    ---（16 + 30 + 3×4 + 3 + 3 + 20 + l2i1 + 40）；l2i1 从 100 每轮 −6、到 40 为止。
    do
        local NAME = "罔両「八雲紫の神隠し」"
        ---一次「定向散弹」（原作 sub103；由母体 SUB_CALL，耗 4 帧）：5 帧里朝 base 打 25 发
        ---（±5.625° 各 4+8 发、±22.5° 各 4+8 发，再用一发直的补满）。
        local function shotgun(self, base)
            gspread(self, bs(10), 0, 1, 1, 4.5, 1, base, 0.19635, true)   -- t=0 SPREAD_ABS(1 发，无随机)
            task.Wait(1)
            grandom(self, bs(7), 2, 4, 3.5, 2,
                    base + 0.0981748 * RAD2DEG, -0.1963496 * RAD2DEG, true)
            task.Wait(1)
            grandom(self, bs(3), 4, 8, 4.5, 3,
                    base + 0.0981748 * RAD2DEG, -0.1963496 * RAD2DEG, true)
            task.Wait(1)
            grandom(self, bs(7), 2, 4, 2, 1,
                    base + 0.392699 * RAD2DEG, -0.785398 * RAD2DEG, true)
            task.Wait(1)
            grandom(self, bs(3), 4, 8, 2, 1,
                    base + 0.392699 * RAD2DEG, -0.785398 * RAD2DEG, true)
        end
        spellcard(NAME, 3446, 75, 1400, false, function(self)
            bmove(self, 120, 4, 0, 128)
            task.New(self, function()
                task.Wait(210)
                local gap = 100
                while true do
                    PlaySound("power0", 0.35, self.x / 256)  -- 原作 SUB_CALL 2（gI0=4 ⇒ 16 帧）
                    task.Wait(16)
                    task.Wait(30)                            -- 母体 t=240
                    local aim = Angle(self, player)
                    ---原作 #33/#36/#39：三次 SUB_CALL 103，f0 依次 = A2P → A2P+2.0944 → A2P−4.18879，
                    ---即我们的 aim → aim−120° → aim+120°（顺序不能换，随机流按序发放）。
                    shotgun(self, aim)                       -- 原作 SUB_CALL 103（各 4 帧）
                    shotgun(self, aim - 120)
                    shotgun(self, aim + 120)
                    PlaySound("lazer00", 0.13, self.x / 256)  -- 原作 sub102 #42 PLAY_SOUND 0xd
                    for k = 0, 5 do                          -- 6 条长激光（60° 间隔）
                        plaser(self.x, self.y, aim / RAD2DEG - k * PI / 3, {
                            spr = 4, w = 8, sOff = 0, eOff = 640, sLen = 640,
                            tStart = 60, dur = 60, tEnd = 30, hbStart = 60, hbEnd = 30 })
                    end
                    task.Wait(3)                             -- t=243
                    task.Wait(3)                             -- t=246
                    gring(self, bs(8), 2, 28, 4, 3, 1, Angle(self, player), 0, true)
                    task.Wait(20)                            -- t=266
                    self.hide = true                         -- SET_HAS_NO_COLLISION 1（隐身）
                    task.Wait(gap)                           -- 等 l2i1 帧
                    self.x, self.y = player.x, player.y       -- 神隐：瞬移到自机身上
                    PlaySound("power0", 0.35, self.x / 256)  -- SUB_CALL 2（gI0=10 ⇒ 40 帧）
                    task.Wait(40)
                    self.hide = false                        -- 原作 #56：爆闪结束后才现身
                    if gap > 40 then gap = gap - 6 end
                end
            end)
        end)
    end

    ---────────── sc133 罔両「ストレートとカーブの夢郷」（原作 sub 100 + 周期子机 101，65s） ──────────
    ---本体先走到 (0,160)，此后每 l2i1 帧挑一个「背对自机」的随机方向漂移 60 帧
    ---（l2i1 从 100 每轮 −4、降到 52 后固定）。每次换向之后打：
    ---  · 两条「曲线扇」（原作 INIT_BULLET_CMD idx0 type0x20 + SPREAD_AIMED）：各 6 发、
    ---    出生速度 5、基准角 = 自机角 + a1（a1 随机落在 ±[78.75°,101.25°)；两扇每帧
    ---    转 ∓1.5°、速度 −0.055/帧，共 60 帧 ⇒ 一边自转一边减速）；
    ---  · 一对激光（角 lf1 与 180°−lf1）；lf1 每轮 +18°、越过 80° 归零。
    ---另有一支周期子机（原作 sub101，每 8 帧一次）：一轮连打 8 对单发「曲线弹」，
    ---基准角 = lf5 ± lf0；lf0 从 60° 每发 +lf6、子弹「刹停后再飞」的速度从 4 每发
    ---+0.125、角增量系数 lf4 从 −0.2 每发 −0.225。lf6 是周期 60 次、幅值
    ---0.0625°/帧² 的三角波；基准角 lf5 恒 90°（原作序言每拍把它写回 1.5708，
    ---所以 #24..#30 那段「朝自机拨 ±0.9°」是死代码）。
    do
        local NAME = "罔両「ストレートとカーブの夢郷」"
        ---把 TH07 弧度归一化到 [−π,π)。
        local function norm(a)
            a = a % (2 * PI)
            return a >= PI and a - 2 * PI or a
        end
        ---一条「曲线弹」（原作 cmd 0x40：沿当前朝向用 dur 帧把速度线性刹到 0，
        ---再按 spd 转一次向、速度换成 new_spd，共 loop 轮）。原作 0x40 有个 ZUN 交换
        ---（cmd.spd 当角增量、cmd.ang 当刹停后的速度），这里照实翻译成
        ---表字段 angle = 角增量（**我们的**角度制）、speed = 刹停后的新速度。
        local function curve(self, ang_our, v0, dth_our, new_spd, spr, col)
            pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(spr), col16(col),
                                    self.x, self.y, v0, ang_our,
                                    { type = 0x40, dur = 60, loop = 1,
                                      angle = dth_our, speed = new_spd })
        end
        ---一条「曲线扇」弹（原作 cmd 0x20 TargetAngle：每帧朝向 += cmd.angle、
        ---速度 += cmd.speed，够 dur 帧清位 —— 一边自转一边减速，两扇反向）。
        ---原作 spd=−0.055/帧、ang=∓1.5°/帧（TH07 口径），到我们这边角增量取反。
        local function fan(self, ang_our, dth_our)
            pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(10), col16(0),
                                    self.x, self.y, 5, ang_our,
                                    { type = 0x20, dur = 60, loop = -1,
                                      angle = dth_our, speed = -0.055 })
        end
        spellcard(NAME, 3447, 65, 2800, false, function(self)
            self._box = { -128, 128, 128, 176 }
            bmove(self, 120, 4, 0, 160)
            ---周期子机（原作 SET_PERIODIC_CALLBACK period=8 sub=101）：
            ---第一次回调在 t=218（设回调后整 8 帧）。
            task.New(self, function()
                task.Wait(218)
                ---★ 原作 sub101 的序言 #0..#5 **每拍都会重跑**（周期回调每次都从 sub 的 #0
                ---开始），其中 #4 就是 `SET_FLOAT lf5 = 1.5708`。所以 #24..#30 那段
                ---「lf0 = lf5 − angToPl，|差| 超 30° 就把 lf5 拨 0.9°」在本条调用路径上
                ---**是死代码**：每拍吐弹用的 lf5 恒为 90°，拨完下一拍又被打回 1.5708。
                ---（lf6 不在此列 —— 序言不碰它，所以它跨拍累加，三角波是真的。）
                local lf5, lf6, li0 = 1.5708, 0.19635, 0
                while true do
                    lf5 = 1.5708
                    local lf0, lf1, lf4 = 1.0472, 4, -0.2
                    for _ = 1, 8 do
                        local dth = lf0 * lf4
                        ---原作 #7 的 0x40 角增量 = lf3、#12 的 = −lf3（0x40 把 cmd.spd 当
                        ---角增量用），换到我们口径整体取反 ⇒ 分别是 −dth / +dth。
                        curve(self, -(lf5 + lf0) * RAD2DEG, 6, -dth * RAD2DEG, lf1, 5, 8)
                        curve(self, -(lf5 - lf0) * RAD2DEG, 6, dth * RAD2DEG, lf1, 5, 8)
                        sound4(self)
                        lf0 = lf0 + lf6
                        lf1 = lf1 + 0.125
                        lf4 = lf4 - 0.225
                    end
                    if li0 >= 30 then lf6 = lf6 + 0.00109083
                    else lf6 = lf6 - 0.00109083 end
                    li0 = (li0 + 1) % 60
                    task.Wait(8)
                end
            end)
            ---本体：漂移 + 每次换向后的那一对曲线扇和激光。
            task.New(self, function()
                task.Wait(210)
                local lf1, wait = 0, 100
                while true do
                    exdrift(self, 1, 0)
                    task.Wait(wait)
                    ---两条曲线扇：原作 SPREAD_AIMED(pk=(10,0), c1=6,c2=1,v1=5,v2=1,
                    ---a2=π/8)，a1 = rand(0.392699) + 1.37445 与 rand(0.392699) − 1.76715，
                    ---后者的每帧角增量取反。
                    for _, s in ipairs({ { 1, -0.0261799 }, { -1, 0.0261799 } }) do
                        local a1 = s[1] > 0 and ran:Float(1.37445, 1.76715)
                                              or ran:Float(-1.76715, -1.37445)
                        local base = Angle(self, player) - a1 * RAD2DEG
                        local offs = spread_offsets(6, -PI / 8 * RAD2DEG)
                        for k = 1, 6 do
                            fan(self, base + offs[k], -s[2] * RAD2DEG)
                        end
                        sound4(self)
                    end
                    ---一对激光：原作 SPAWN_LASER_FIXED(packed spr=0,off=6) a1 = lf1 / π−lf1。
                    plaser(self.x, self.y, -lf1, {
                        spr = 6, w = 8, sOff = 0, eOff = 640, sLen = 640,
                        tStart = 20, dur = 30, tEnd = 30, hbStart = 20, hbEnd = 30 })
                    plaser(self.x, self.y, -(PI - lf1), {
                        spr = 6, w = 8, sOff = 0, eOff = 640, sLen = 640,
                        tStart = 20, dur = 30, tEnd = 30, hbStart = 20, hbEnd = 30 })
                    lf1 = lf1 + 0.314159
                    if lf1 > 1.39626 then lf1 = 0 end
                    if wait > 52 then wait = wait - 4 end
                end
            end)
        end)
    end

    ---────────── sc132 結界「光と闇の網目」（原作 sub 97 + 子机 98/99，75s） ──────────
    ---本体走到 (0,160)（原作 MOVE_POS_TIME(120,4,192,64)），移动框 x∈[−128,128]、y∈[96,176]
    ---（原作 SET_MOVEMENT_BOUNDS(64,48,320,128)，y 上下限换算成 224−y 后是 176/96）。
    ---此后每「半轮」（母体 #28..#98）：
    ---  · 一次「網目」爆闪（原作 SUB_CALL 2，gI0=10 ⇒ 主 sub 冻结 40 帧：音效 + 粒子）；
    ---  · 一整套「網目」弹幕（原作 #31..#42）：1 发直线弹（速 4.5）+ 4 组 RANDOM 扇
    ---    ——8 发(2~3.5)、16 发(3~4.5) 两张角在 ±5.625°、8 发(1~2)、56 发(1~3) 两张角
    ---    在 ±22.5° / ±45°；基准角 lf0 = 自机角 ± 30°；
    ---  · 24 帧后在原地挂一只「光」子机（原作 sub98），再 10 帧打一整套「暗」弹幕
    ---    （弹型/张角一样，只换 sprite/色档）；又 20 帧挂「暗」子机（sub99）；
    ---    然后朝 RAND_EXIT_ANGLE 方向漂移 60 帧（1px/帧）、lf5 += 3.6°；
    ---  · 等 l2i1 帧（每半轮 −7、降到 130 后固定）后进入下一半轮。
    ---四段弹幕的基准角依次是「自机角+30°、−30°、−30°、+30°」再循环（原作 #31/#44/#66/#79）；
    ---sprite/色档固定「光 = 10/1、7/3、3/6」「暗 = 10/0、7/1、3/2」。
    ---子机（原作 sub98/99；SET_HAS_NO_COLLISION ⇒ 隐形；MOVE_DIR_TIME(0,0,lf0,4) 的 t=0
    ---⇒ 位移 = spd×t = 0，所以子机**原地不动**）：每 16 帧一轮共 8 轮（活 128 帧），
    ---每轮先朝「lf0+90°±lf5/2」放一条激光（w=wA）并打 2 发扇（速 1.5、±5.625°），
    ---8 帧后再朝「lf0−90°±lf5/2」放一条（w=wB）并打 2 发扇。激光 90 帧展开、200 帧
    ---满宽、30 帧收束，判定从第 80 帧起。
    do
        local NAME = "結界「光と闇の網目」"
        ---一次「網目」弹幕（light/dark 只差 sprite 与色档）。lf0 传**原作口径的弧度**
        ---（基准角 = angToPl_TH07 ± 0.523599）。
        ---第 i 发的相对角：RANDOM 用 rand(a1−a2)+a2 ⇒ 我们的 rand(2θ)−θ 相对 L。
        local function web(self, lf0, dark)
            local L = -lf0 * RAD2DEG
            local S = dark and { { 10, 0 }, { 7, 1 }, { 3, 2 } }
                            or { { 10, 1 }, { 7, 3 }, { 3, 6 } }
            ---★ 原作 #34 是 `SPREAD_ABS 10:1 1 1 4.5 1 *f0 0.19635 516`（c1=1 ⇒ 只有 1 发，
            ---  相对角 = 0）——**不是 RANDOM**，一颗随机数都不抽。早先套用 grandom
            ---  会凭空多抽 2 个 float，此后整条随机流错位，四段扇的落点全对不上。
            volley3(self, 1, function()
                return bs(S[1][1]), col16(S[1][2]), 4.5, L
            end, true)
            task.Wait(1)
            ---原作 #35 RANDOM：角 = rand(f3−f4) + f4，f3 = f0+0.0981748、f4 = f0−0.0981748。
            ---我们的角度制 = 取负 ⇒ a1 = −f4 = L + 0.0981748、a2 = −(f3−f4) = −0.1963496。
            grandom(self, bs(S[2][1]), S[2][2], 8, 3.5, 2,
                    L + 0.0981748 * RAD2DEG, -0.1963496 * RAD2DEG, true)
            task.Wait(1)
            grandom(self, bs(S[3][1]), S[3][2], 16, 4.5, 3,
                    L + 0.0981748 * RAD2DEG, -0.1963496 * RAD2DEG, true)
            task.Wait(1)
            grandom(self, bs(S[2][1]), S[2][2], 8, 2, 1,
                    L + 0.392699 * RAD2DEG, -0.785398 * RAD2DEG, true)
            task.Wait(1)
            grandom(self, bs(S[3][1]), S[3][2], 56, 3, 1,
                    L + 0.785398 * RAD2DEG, -1.570796 * RAD2DEG, true)
        end
        ---「網目」子机（原作 sub98/99）。a = { ang0(原作弧度), lf5, spr, col, wA, wB }。
        ---原作用 MOVE_DIR_TIME(0,0,ang0,4) 起手：t=0 ⇒ 位移 0（引擎把 moveInterp 算成
        ---方向×速度×t），子机只是原地当隐形发射台。
        local function node(self, a)
            local offs = spread_offsets(2, -0.19635 * RAD2DEG)
            local function fire(sign, w)
                plaser(self.x, self.y, -a.ang0 + sign * PI / 2
                       + ran:Float(-a.lf5 / 2, a.lf5 / 2), {
                    spr = a.spr, w = w, sOff = 0, eOff = 640, sLen = 640,
                    tStart = 90, dur = 200, tEnd = 30, hbStart = 80, hbEnd = 30 })
                local base = -a.ang0 * RAD2DEG
                for k = 1, 2 do
                    volley3(self, 1, function()
                        return bs(3), col16(a.col), 1.5, base + offs[k]
                    end, true)
                end
            end
            ---★ 原作 sub98/99 #4 是 `MOVE_DIR_TIME 0 0 *f0 4`：t ≤ 0 时引擎直接
            ---  把 angle=f0、speed=4、moveMode=POLAR（EclManager.cpp:1537-1547），
            ---  **子机每帧沿 f0 飞 4px**（不是「位移 0」）——它是边飘边放的隐形炮台。
            ---  漏掉这段，所有激光/扇的落点都停在出生点，全卡位置全错。
            local mvx, mvy = math.cos(a.ang0) * 4, -math.sin(a.ang0) * 4
            local function advance(n)
                for _ = 1, n do
                    self.x, self.y = self.x + mvx, self.y + mvy
                    task.Wait(1)
                end
            end
            for _ = 1, 8 do
                fire(-1, a.wA)
                advance(8)
                fire(1, a.wB)
                advance(8)
            end
        end
        spellcard(NAME, 3448, 75, 2400, false, function(self)
            self._box = { -128, 128, 96, 176 }
            bmove(self, 120, 4, 0, 160)
            task.New(self, function()
                task.Wait(210)
                local lf5, wait, sgn = 0.523599, 200, 1
                while true do
                    PlaySound("power0", 0.35, self.x / 256)   -- 原作 SUB_CALL 2（gI0=10 ⇒ 40 帧）
                    task.Wait(40)
                    local lf0 = -Angle(self, player) / RAD2DEG + sgn * 0.523599
                    web(self, lf0, false)
                    task.Wait(20)                      -- 相对 4 → 24
                    pspawn(self.x, self.y, node,
                           { ang0 = lf0, lf5 = lf5, spr = 6, col = 6, wA = 16, wB = 14 })
                    task.Wait(10)                      -- 相对 24 → 34
                    local lf0b = -Angle(self, player) / RAD2DEG - sgn * 0.523599
                    web(self, lf0b, true)
                    task.Wait(20)                      -- 相对 38 → 58
                    pspawn(self.x, self.y, node,
                           { ang0 = lf0b, lf5 = lf5, spr = 2, col = 2, wA = 14, wB = 16 })
                    exdrift(self, 1, 0)
                    lf5 = lf5 + 0.0628319
                    task.Wait(wait)
                    if wait > 130 then wait = wait - 7 end
                    sgn = -sgn
                end
            end)
        end)
    end
    ---────────── sc131 結界「動と静の均衡」（原作 sub 93 + 子机 95/96，65s） ──────────
    ---本体走到 (0,128) 后原地不动，每 l2i1 帧（从 120 每轮 −2、降到 60）放一只式神：
    ---先出「动」式神（原作 sub95），隔 l2i1 帧再出「静」式神（sub96）——两只都在
    ---**出生当帧自机所在的位置**落脚。式神（原作 sub95/96 调用共用子程序 94）：
    ---  · 出生当帧：PLAY_SOUND 15（se_tan00）+ 3 发瞄准扇（速度 4、±60°）
    ---    + 8 发朝正上方的大扇（速度 8、±11.25/33.75/56.25/78.75°）；
    ---  · 用 80 帧 ease-out-quad 飘到目标点；
    ---  · 之后每 6 帧打一发「慢弹」：速度 0.8、角从正上方起每发 +0.253354 弧度
    ---    （「动」，sprite/色 1/6）或 −0.234447（「静」，1/5），共 33 发。
    ---子机寿命 240 帧（33 发打完即停）。
    do
        local NAME = "結界「動と静の均衡」"
        ---一只式神（原作 sub95/96）。a = { tx, ty, col, dth }。
        local function spirit(self, a)
            ---sub94：音效 + 两轮出场弹幕（都从出生点打出）。
            PlaySound("tan00", 0.1, self.x / 256)
            local aim = Angle(self, player)
            local off3 = spread_offsets(3, -60)
            for k = 1, 3 do
                volley3(self, 1, function()
                    return bs(10), col16(1), 4, aim + off3[k]
                end, false)
            end
            local off8 = spread_offsets(8, -22.5)
            for k = 1, 8 do
                volley3(self, 1, function()
                    return bs(7), col16(3), 8, 90 + off8[k]
                end, false)
            end
            ---sub94 的 MOVE_POS_TIME(80, ease4) 飘到出生瞬间记下的自机位置。
            local x0, y0 = self.x, self.y
            for i = 1, 80 do
                local u = i / 80
                local e = 1 - (1 - u) * (1 - u)
                self.x, self.y = x0 + (a.tx - x0) * e, y0 + (a.ty - y0) * e
                task.Wait(1)
            end
            ---33 发慢弹（原作 SPREAD_ABS c1=1、速度 0.8、角度每发 ±0.253/0.234 弧度）。
            local th = 1.5708
            for _ = 1, 33 do
                local ang = -th * RAD2DEG
                volley3(self, 1, function()
                    return bs(1), col16(a.col), 0.8, ang
                end, true)
                th = th + a.dth
                task.Wait(6)
            end
        end
        spellcard(NAME, 3449, 65, 1700, false, function(self)
            self._box = { -128, 128, 96, 176 }
            bmove(self, 120, 4, 0, 128)
            task.New(self, function()
                task.Wait(210)
                local wait = 120
                while true do
                    ---原作 t=210 的 l2i1/l2i0 初值分别是 120/40；l2i0 在 loop 里没用。
                    ---「動」子机先出，等 l2i1 帧后「静」子机落在**那时**的自机位置；
                    ---母体的 JUMP 排在 t=250 ⇒ 「静」之后再等 40 帧才开始下一轮。
                    pspawn(self.x, self.y, spirit,
                           { tx = player.x, ty = player.y, col = 6, dth = 0.253354 })
                    task.Wait(wait)
                    pspawn(self.x, self.y, spirit,
                           { tx = player.x, ty = player.y, col = 5, dth = -0.234447 })
                    task.Wait(40)
                    if wait > 60 then wait = wait - 2 end
                end
            end)
        end)
    end

    ---────────── sc130 結界「夢と現の呪」（原作 sub 88 + 子机 89/90/91/92，60s） ──────────
    ---本体走到 (0,128)，循环（母体 t=210 的 #26..#46）：
    ---  · SUB_CALL 89（占 40 帧）：打一对「大弹」（sprite/色 10/1、速度 12、张角 90°）；
    ---    基准角 = 自机角（原作 angToPl）；但若**自机不在** 22.5°..157.5° 的「正下方」
    ---    扇里，就改成随机 78.75°..101.25°（原作 #0..#3：RAND_FLOAT_ADD 是
---    rand[0,0.392699)+1.37445，不是区间两端）。这对弹挂 0x40 指令：20 帧内
    ---    把速度线性刹到 0 并停在空中；
    ---  · 子程序跑到 t=40 时用 ex-ins 4 依次抓「≥60px 的大弹」：先后各抓一颗、原地
    ---    生成「梦现」子机（sub89 先 91 后 92；sub90 先 92 后 91），大弹随即消失；
    ---  · 等 l2i1 帧（从 48 每半轮 −4、降到 20）；
    ---  · 朝随机「背离自机」方向 ease-out 漂移 l2i0 帧（3.5 px/帧；l2i0 从 48 降到 28）；
    ---  · 再等 l2i0（已 −4）帧，然后同样一轮 SUB_CALL 90（漂移速度 2.2）+ 两组子机。
    ---大子机（原作 sub91）：出现当帧先放 4 圈 8 发环（色 9、速 0.5），环心在
    ---48·(自机方向 / 垂直方向 / 各自反向)；10 帧后再放 8 圈 8 发（色 10），环心在
    ---96·(自机方向 / 垂直方向 / 各自反向) 与 ±48·(两对角和 / 两对角差)。
    ---每发弹挂 0x10 指令：120 帧里沿出生方向每帧加速 0.00583333。
    ---小子机（原作 sub92）：每 5 帧放一圈 4 发（色 8、速 4、随机基准角、90° 间隔），
    ---共 10 圈；每发挂 0x80 指令：30 帧刹到停，再朝自机以 2.2 直飞。
    do
        local NAME = "結界「夢と現の呪」"
        ---TH07 口径的「自机角」（弧度，y 朝下）。
        local function th_aim(self)
            return -Angle(self, player) / RAD2DEG
        end
        ---sub89/90 的一对「冻结大弹」（原作指令 0x40：20 帧刹停、停在原地）。
        ---返回这两颗弹，40 帧后由调用方依次换成「梦现」子机。
        local function freeze(self)
            local aim = th_aim(self)
            ---原作 #0 无条件先掷一枚角（RAND_FLOAT_ADD f2 0.392699 1.37445），
            ---#1/#2 只在 A2P 落进 (0.392699, 2.74889) 时由 #3 覆盖成 A2P。掷数必须照抽。
            local a1 = ran:Float(1.37445, 1.767149)
            if aim > 0.392699 and aim < 2.74889 then a1 = aim end
            local base = -a1 * RAD2DEG
            local offs = spread_offsets(2, -PI / 2 * RAD2DEG)
            local out = {}
            for k = 1, 2 do
                local ang = base + offs[k]
                out[k] = New(class["TH34_cmdbullet"], bs(10), col16(1), self.x, self.y, 12, ang,
                             { type = 0x40, dur = 20, loop = 1, angle = 0, speed = 0 })
                pool4[#pool4 + 1] = out[k]
            end
            return out
        end
        ---「大梦现」子机（原作 sub91）。出来当帧放 4 圈、10 帧后再放 8 圈，然后自毁。
        local function dream(self)
            ---★ aim 是**弧度**（TH07 口径），而本工程的 cos/sin 是角度制（Lmath.lua 里
            ---`Cos/Sin` 用 1..360 的整数度建表即可看出），所以这里必须用 math.cos/math.sin，
            ---否则 48/96 的环心会全挤在 0° 附近、0x10 的加速方向也全错。
            local aim = th_aim(self)
            local ux, uy = math.cos(aim), math.sin(aim)
            local px, py = math.cos(aim + PI / 2), math.sin(aim + PI / 2)
            local function ring(cx, cy, col)
                for k = 0, 7 do
                    local th = aim + k * PI / 4
                    local ang = -th * RAD2DEG
                    pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(6), col16(col),
                                            self.x + cx, self.y - cy, 0.5, ang,
                                            { type = 0x10, dur = 120, loop = -1,
                                              vec_x = math.cos(th) * 0.00583333,
                                              vec_y = -math.sin(th) * 0.00583333 })
                end
                sound4(self)
            end
            ring( 48 * ux,  48 * uy, 9)
            ring( 48 * px,  48 * py, 9)
            ring(-48 * ux, -48 * uy, 9)
            ring(-48 * px, -48 * py, 9)
            task.Wait(10)
            local dx, dy = 48 * (ux + px), 48 * (uy + py)
            local ex, ey = 48 * (ux - px), 48 * (uy - py)
            ring( 96 * ux,  96 * uy, 10)
            ring( 96 * px,  96 * py, 10)
            ring(-96 * ux, -96 * uy, 10)
            ring(-96 * px, -96 * py, 10)
            ring( dx,  dy, 10)
            ring(-dx, -dy, 10)
            ring( ex,  ey, 10)
            ring(-ex, -ey, 10)
        end
        ---「小梦现」子机（原作 sub92）：10 圈 4 发刹车弹（色 8、速 4）。
        local function dream92(self)
            for _ = 1, 10 do
                ---原作 sub92 是 RING_ABS angle1=*RNGRAD（TH07 口径）⇒ 本仓库取反。
                local base = -rngdeg()
                for k = 0, 3 do
                    pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(2), col16(8),
                                            self.x, self.y, 4, base + k * 90,
                                            { type = 0x80, dur = 30, loop = 1,
                                              angle = 0, speed = 2.2 })
                end
                sound4(self)
                task.Wait(5)
            end
        end
        ---SUB_CALL 89/90 的可阻塞版：打一对大弹 → 等 40 帧 → 依次换成一只大子机 + 一只
        ---小子机（first91=true 表示「先大后小」，false 表示「先小后大」）。
        local function freeze_to_dream(self, first91)
            local b = freeze(self)
            task.Wait(40)
            for k = 1, 2 do
                if IsValid(b[k]) then
                    local bx, by = b[k].x, b[k].y
                    object.RawDel(b[k])
                    local fn
                    if first91 then fn = (k == 1) and dream or dream92
                    else fn = (k == 1) and dream92 or dream end
                    pspawn(bx, by, fn)
                end
            end
        end
        spellcard(NAME, 3450, 60, 2600, false, function(self)
            self._box = { -128, 128, 96, 176 }
            bmove(self, 120, 4, 0, 128)
            task.New(self, function()
                task.Wait(210)
                local w1, w2 = 48, 48
                while true do
                    freeze_to_dream(self, true)       -- SUB_CALL 89（40 帧）
                    task.Wait(w1)
                    local a = exang(self)
                    bmove(self, w2, 4, self.x + cos(a) * w2 * 3.5, self.y + sin(a) * w2 * 3.5)
                    if w1 > 20 then w1 = w1 - 4 end
                    if w2 > 30 then w2 = w2 - 4 end
                    task.Wait(w2)
                    freeze_to_dream(self, false)      -- SUB_CALL 90（40 帧）
                    task.Wait(w1)
                    local b = exang(self)
                    bmove(self, w2, 4, self.x + cos(b) * w2 * 2.2, self.y + sin(b) * w2 * 2.2)
                    if w1 > 20 then w1 = w1 - 4 end
                    if w2 > 30 then w2 = w2 - 4 end
                    task.Wait(w2)
                end
            end)
        end)
    end

    ---两面的中 boss 都带一只「式神」子机（原作 sub65/sub63）：ANM 12、SET_IS_HITTABLE 0
    ---（不可打）、原地不动，到场后第 600 帧起**每 100 帧永久**朝自机打一发 9 发、1.5 速、
    ---半角 30° 的瞄准扇（SPREAD_AIMED pk=(7,2) c1=9 v1=1.5 a2=0.523599、flags=0x2 不带
    ---0x200，音效由紧接的 PLAY_SOUND 15 单独播放）。
    ---★ 原作 #15 的 `JUMP time=600`（t=700 处）把 time 倒回 600 再落到 #13 的 SPREAD 上，
    ---循环周期 = 700−600 = 100 帧；**JUMP 之后的 t=800 SET_PRIMARY_VM_INTERRUPT /
    ---SET_EX_INS −1 与 t=840 UNIMP 永远到不了（死代码）**，所以式神不是「只打两发就自毁」，
    ---而是打到整张卡结束为止（sim.py 实测 wall=600,700,800,… 一直发）。
    local function shiki(self)
        task.Wait(600)
        while true do
            gspread(self, bs(7), 2, 9, 1, 1.5, 1, Angle(self, player), 30, false)
            PlaySound("tan00", 0.1, self.x / 256)   -- 原作 #14 PLAY_SOUND 15
            task.Wait(100)
        end
    end

    ---────────── sc129 式神「憑依荼吉尼天」（原作 sub 63 + 周期 64 + 子机 65，55s） ──────────
    ---本体 t=110 起用 120 帧 ease-out 移到画面下方 (0,−160)，t=320 起绕 (0,0)、半径 160 的
    ---圆公转：8 段 MOVE_ORBIT 各 120 帧，角速度 ±1.5°/帧，「张开的大圆」与「收成一点」
    ---交替（半径速度 ∓1.33333/帧，120 帧正好走完 160）。同时 t=320 放出式神子机 sub65。
    ---本体自己的弹幕由周期回调 sub64（period=7，t=327 首次）负责：每 7 帧打一对 5 发扇
    ---（半角 15°），基准角分别是「当前公转切线方向」与它的反方向（原作 SPREAD_ABS 的
    ---a1 = moveAngle 与 moveAngle+π），速度 lf2 = rand(0,0.5)+lf1 ∈ [lf1, lf1+0.5)，
    ---lf1 从 1.8 起每次 +0.005。
    do
        local NAME = "式神「憑依荼吉尼天」"
        spellcard(NAME, 3451, 55, 1000, false, function(self)
            ---进场：原作 t=0 的 MOVE_POS_TIME(60, ease4, 64, 128)（我们 (−128,96)）。
            bmove(self, 60, 4, -128, 96)
            ---原作 t=320..1280 的 8 段 MOVE_ORBIT：{ 起始角, 角速度, 半径, 半径速度 }，
            ---整组都已取到我们的口径（角度与角速度取反，半径量不变）。
            local ORB = {
                { -1.5708,  0.0261799, 160,  0 },
                {  1.5708,  0.0261799, 160, -1.33333 },
                {  1.5708, -0.0261799,   0,  1.33333 },
                { -1.5708, -0.0261799, 160,  0 },
                {  1.5708, -0.0261799, 160,  0 },
                { -1.5708, -0.0261799, 160, -1.33333 },
                { -1.5708,  0.0261799,   0,  1.33333 },
                {  1.5708,  0.0261799, 160,  0 },
            }
            task.New(self, function()
                task.Wait(110)
                bmove(self, 120, 4, 0, -160)
                ---原作 #40 的 MOVE_ORBIT 在 t=320 才生效：先等这 120 帧的进场插值走完
                ---（t=110→230），再空转 90 帧才到 t=320。
                task.Wait(210)
                while true do
                    for _, o in ipairs(ORB) do
                        borbit(self, 0, 0, o[1], o[2], o[3], o[4])
                        task.Wait(120)
                    end
                end
            end)
            task.New(self, function()
                task.Wait(320)
                pspawn(0, -160, shiki)
            end)
            task.New(self, function()
                task.Wait(327)
                local lf1 = 1.8
                while true do
                    local lf2 = lf1 + ran:Float(0, 0.5)
                    local d = orbdir(self)
                    gspread(self, bs(6), 6, 5, 1, lf2, 1, d, 15, true)
                    gspread(self, bs(6), 2, 5, 1, lf2, 1, d + 180, 15, true)
                    lf1 = lf1 + 0.005
                    task.Wait(7)
                end
            end)
        end)
    end

    ---────────── sc128 式神「前鬼後鬼の守護」（原作 sub 60 + 61/62，60s） ──────────
    ---本体定点在 (0,128)。t=210 起循环四发：前鬼(sub61)/後鬼(sub62)/前鬼/後鬼，
    ---发与发之间 SET_WAIT_TIMER li0,li0,li0,li1（初值 50/220）；每轮 li0 −2（止于 38）、
    ---li1 −10（止于 160）⇒ 越来越密。两种鬼都是「先按初速直飞、60 帧内线性刹到 0、
    ---再精确拐向自机以 3.5 飞出」的一发弹（INIT_BULLET_CMD type 0x80 DirChangeAim，loop=1）。
    ---  · sub61（前鬼）：初角 TH07 rand(0,3.6°)−1.8°（≈0°，向右）、初速 rand[3.2,4.2)、色档 (10,3)；
    ---  · sub62（後鬼）：初角 TH07 rand(0,3°)+178°（≈π，向左）、初速 rand[3.2,4.2)、色档 (10,2)。
    do
        local NAME = "式神「前鬼後鬼の守護」"
        ---一发守护弹。cmd.angle 是拐向自机后的偏角、cmd.speed 是拐后的新速度
        ---（原作 0x40/0x80/0x100 的 `commandStates[3].angle = cmd->speed` quirk）。
        local function guard(self, back)
            ---TH07 初角 = rand(0,A)+B（A>0）；换成我们的口径整体取反、再转成角度制
            ---（TH34_cmdbullet 的朝向是 LuaSTG 角度）：
            ---  前鬼 rand(0,0.0628319)−0.0314159（≈0°，向右）；後鬼 rand(0,0.0523599)+3.11018（≈π，向左）。
            local a = back and -(ran:Float(0, 0.0523599) + 3.11018) * RAD2DEG
                            or -(ran:Float(0, 0.0628319) - 0.0314159) * RAD2DEG
            local cmd = { type = 0x80, dur = 60, loop = 1, angle = 0, speed = 3.5 }
            ---原作 t=0 就 SET_BULLET_SOUND 0xffffffff ⇒ 全程无声。
            pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(10), col16(back and 2 or 3),
                                    self.x, self.y, ran:Float(3.2, 4.2), a, cmd)
        end
        spellcard(NAME, 3452, 60, 2000, false, function(self)
            ---本体进场：原作 t=0 移到 TH07(192,96)（我们 (0,128)）之后不再动。
            task.New(self, function()
                bmove(self, 120, 4, 0, 128)
            end)
            task.New(self, function()
                task.Wait(210)
                local li0, li1 = 50, 220
                while true do
                    guard(self, false); task.Wait(li0)
                    guard(self, true);  task.Wait(li0)
                    guard(self, false); task.Wait(li0)
                    guard(self, true);  task.Wait(li1)
                    if li0 > 38 then li0 = li0 - 2 end
                    if li1 > 160 then li1 = li1 - 10 end
                end
            end)
        end)
    end

    ---EX 的「仙狐」子机（原作 sub 87）：原地打 4 组 8 发环（速度 0.5，逐组挪一点）。
    local function shinko(self, a)
        for k = 0, 2 do
            local ox, oy = cos(k * 45) * 32, sin(k * 45) * 32
            for j = 0, 3 do
                volley3(self, 8, function(i)
                    return bs(6), col16(9), 0.5, (i - 1) * 45 + j * 11.25
                end, true)
                task.Wait(2)
            end
            task.Wait(2)
        end
    end

    ---────────── sc127 幻神「飯綱権現降臨」（原作 sub 123 + 周期 124，120s） ──────────
    ---与 PH「生と死の境界」同一套 10 帧周期回调（t=210 挂上、t=220 首发），区别：血量门槛
    ---7000/5500/3000/2000/1000、且**没有**最后那发瞄准扇；到第 571 次回调（t=5920）之后
    ---换成 5 层加强版（第 1 层照旧，也不带瞄准扇）。
    ---本体在 {−64..64, 96..160} 的小框里每 300 帧随机漂一次（原作 t=810 的 300 帧循环）；
    ---那次 RAND_EXIT_ANGLE 写的就是 lf0，也就是第 1 层的基准角。
    do
        local NAME = "幻神「飯綱権現降臨」"
        ---{血量门槛, sprite, 色档, c1, c2, v1, v2, 每轮基准角增量, a2}；at 用 hpS 折算
        ---（本卡的开卡 life 是 8000 ⇒ 门槛 7000/5500/3000/2000/1000 才有意义）。
        ---第 1 层永远打、不看 at（原作 sub124 的血量分支在它之后），20000 只是占位。
        local LAYER = {
            { at = hpS(20000), spr =  2, off = 6, c1 = 7, c2 = 1, v1 = 2.0, v2 = 1, d = -0.349066, a2 = 0.392699 },
            { at = hpS(7000),  spr =  8, off = 2, c1 = 5, c2 = 1, v1 = 1.5, v2 = 1, d =  0.392699, a2 = 0.196350 },
            { at = hpS(5500),  spr = 10, off = 0, c1 = 2, c2 = 1, v1 = 1.2, v2 = 1, d = -0.448799, a2 = 0.785398 },
            { at = hpS(3000),  spr =  6, off = 5, c1 = 4, c2 = 2, v1 = 1.7, v2 = 1, d = -0.130900, a2 = 0.392699 },
            { at = hpS(2000),  spr =  7, off = 6, c1 = 5, c2 = 1, v1 = 2.5, v2 = 1, d =  0.130900, a2 = 0.392699 },
            { at = hpS(1000),  spr =  7, off = 4, c1 = 5, c2 = 2, v1 = 3.5, v2 = 2, d = -0.523599, a2 = 0.392699 },
        }
        ---t >= 5700 之后的「加强版」：第 2..6 层（原作 sub124 的 #45..#63），速度提高。
        local RAGE = {
            { spr =  8, off = 2, c1 = 5, c2 = 1, v1 = 2.5, v2 = 1, d =  0.392699, a2 = 0.196350 },
            { spr = 10, off = 0, c1 = 2, c2 = 1, v1 = 2.2, v2 = 1, d = -0.448799, a2 = 0.785398 },
            { spr =  6, off = 5, c1 = 4, c2 = 2, v1 = 2.7, v2 = 1, d = -0.130900, a2 = 0.392699 },
            { spr =  7, off = 6, c1 = 5, c2 = 1, v1 = 3.5, v2 = 1, d =  0.130900, a2 = 0.392699 },
            { spr =  7, off = 4, c1 = 5, c2 = 2, v1 = 4.5, v2 = 2, d = -0.523599, a2 = 0.392699 },
        }
        spellcard(NAME, 3471, 120, 8000, false, function(self)
            self._box = { -64, 64, 96, 160 }          -- 原作 SET_MOVEMENT_BOUNDS(128,64,256,128)
            bmove(self, 120, 4, 0, 96)                -- 原作 #13 MOVE_POS_TIME(120,4,192,128)
            ---★ 原作开卡时连抽 7 个 RNGRAD（*f0..*f6）。最后那个 *f6 的初值**从不被读**
            ---（它一进回调就被 RAND_FLOAT_ADD 覆盖），但它**照样要抽**——少抽一次，
            ---从 t=810 的 RAND_EXIT_ANGLE 起整条随机流就错位，全卡的弹道跟着全错。
            ---acc 存的是**我们的角度制**（顺指针为正）：原作 f0..f5 是 CCW 弧度，取负。
            local acc = { -rngrad(), -rngrad(), -rngrad(), -rngrad(), -rngrad(), -rngrad() }
            local _ = rngrad()
            task.New(self, function()
                task.Wait(220)                    -- 原作 #36 在 t=210 挂回调、10 帧后才首发
                local t, lv = 0, 0
                while true do
                    ---第 1 层（原作 sub124 #0）：在难度/血量分支之前，两段都打。
                    local L1 = LAYER[1]
                    gspread(self, bs(L1.spr), L1.off, L1.c1, L1.c2, L1.v1, L1.v2,
                            acc[1] * RAD2DEG, L1.a2 * RAD2DEG, true)
                    acc[1] = acc[1] + L1.d
                    if t >= 5700 then
                        if lv < 6 then
                            lv = 6
                            PlaySound("tan00", 0.1, self.x / 256)   -- 原作 sub124 #47 PLAY_SOUND 0xf
                        end
                        for k, R in ipairs(RAGE) do
                            gspread(self, bs(R.spr), R.off, R.c1, R.c2, R.v1, R.v2,
                                    acc[k + 1] * RAD2DEG, R.a2 * RAD2DEG, true)
                            acc[k + 1] = acc[k + 1] + R.d
                        end
                    else
                        for k = 2, #LAYER do
                            local L = LAYER[k]
                            if self.hp <= L.at then
                                if lv < k then
                                    lv = k
                                    PlaySound("tan00", 0.1, self.x / 256)   -- 原作 sub124 #7/#15/#23/#31/#39 解锁音
                                end
                                gspread(self, bs(L.spr), L.off, L.c1, L.c2, L.v1, L.v2,
                                        acc[k] * RAD2DEG, L.a2 * RAD2DEG, true)
                                acc[k] = acc[k] + L.d
                            end
                        end
                    end
                    t = t + 10
                    task.Wait(10)
                end
            end)
            task.New(self, function()
                task.Wait(810)
                while true do
                    ---原作 sub123 #39/#40：RAND_EXIT_ANGLE *f0 + MOVE_DIR_TIME(60,0,*f0,1)。
                    ---★ 这个 *f0 是**主 sub 自己的 f0**，只驱动本体漂移；周期回调 sub128/sub124
                    ---用的是它自己那份 f0（开卡初值 + 每次回调 +0.349066），两者互不影响。
                    ---早先把重掷结果写回 acc[1]，会让第 1 层的基准角从 t=810 起整段错位。
                    local a = exang(self)
                    bmove(self, 60, 0, self.x + cos(a / RAD2DEG) * 60, self.y - sin(a / RAD2DEG) * 60)
                    task.Wait(300)
                end
            end)
        end)
    end

    ---────────── sc126 「狐狗狸さんの契約」（原作 sub 115 + 116..122，生存卡 76s） ──────────
    ---与 PH「人間と妖怪の境界」同构（只有速度/间隔/角步进略不同）。本体（原作 sub115）：
    ---  · t=210 用 120 帧 ease-in 飘到「t=210 那一刻的自机位置」（原作 #28
    ---    MOVE_POS_TIME(120,1,plX,plY)），之后 120 帧每帧把 posX/posY 直接写成自机当前
    ---    坐标（原作 #34..#36 的循环）——也就是「贴住自机」两秒；本体此时无碰撞判定。
    ---  · 第一段插值走完的瞬间（≈t=331，原作 #29..#31 那对整数 SUB 只是空转 120 帧）
    ---    在**当时的本体坐标**放出中心激光星（原作 sub121）——所以激光星的中心是
    ---    t=210 那一刻的自机位置，而不是本体最终停留的地方。
    ---  · 贴住结束（≈t=451）才响 #37 的音（PLAY_SOUND 5）、用 120 帧线性飘回画面正中，
    ---    并在同一帧一次性放出四角炮台（原作 #41..#47 被前面的循环压后到这里；其后
    ---    t=851/1451/1951 的三波不受影响，按绝对时间照常执行）。
    ---  · t=845/1151 在下方左右横穿、t=1851 到 (0,128)、t=2551 再横穿、t=2951 回正中。
    ---  · t=3051 起 16 波角炮：4 个角按「左上→右下→右上→左下」轮转，每波基准角 =
    ---    该角朝屏内那一侧的「±5.625° 弧」里随机取（原作 lf0 = RAND_FLOAT_ADD(0.0981748,
    ---    base)，base 依次为 0 / π / π/2 / −π/2，翻面后就是 0 / 180 / −90 / 90 再 −rand）。
    do
        local NAME = "「狐狗狸さんの契約」"
        ---边缘炮台（原作 sub116..119）：一次性 MOVE_POS_TIME 走到 (tx,ty)，边飞边每 44 帧
        ---打一发速度 1.0 的弹；spriteOffset 取父体继承下来的 li0 = 6（原作插的是变量）。
        local function turret(self, a)
            bmove(self, a.mv, 0, a.tx, a.ty)
            local t = 0
            while true do
                if t % 44 == 0 then
                    volley3(self, 1, function() return bs(1), col16(6), 1.0, a.a end, true)
                end
                bstep(self)
                t = t + 1
                task.Wait(1)
            end
        end
        ---角炮（原作 sub120）：每 8 帧一发、共 10 发；每发 2 颗（c1=1、c2=2：两颗同角、
        ---速度 v1 从 0.8 起每发 +0.15、v2 恒 1；a2=30° 对单发不产生影响），
        ---基准角每发**减** 0.15708 —— 原作 `ADD_FLOAT *f0 *f0 *f1` 的 f1 是**弧度**
        ---（0.15708 rad = 9°），本仓库的角是度 ⇒ 必须 ×RAD2DEG；漏算时每发只转
        --- 0.157°、整条角阶梯全错（墙钟 3297 起每 8 帧一发全歪）。
        local function corner(self, a)
            local ang, v = a.a, 0.8
            for _ = 1, 10 do
                gspread(self, bs(3), 6, 1, 2, v, 1, ang, 30, true)
                ang, v = ang - 0.15708 * RAD2DEG, v + 0.15
                task.Wait(8)
            end
        end
        spellcard(NAME, 3470, 76, nil, true, function(self)
            ---本体轨迹（原作 sub115）。
            task.New(self, function()
                task.Wait(210)
                local px, py = player.x, player.y
                bmove(self, 120, 1, px, py)          -- 原作 #28：120 帧 ease-in 到自机位置
                task.Wait(120)                       -- 原作 #29..#31：空转 120 帧
                self._mv = nil
                self.x, self.y = px, py              -- 收尾那一帧的插值补正
                pspawn(self.x, self.y, function(o) laser_star(o.x, o.y) end)   -- 原作 sub121
                for _ = 1, 120 do                    -- 原作 #34..#36：本体贴住自机 120 帧
                    self.x, self.y = player.x, player.y
                    task.Wait(1)
                end
                PlaySound("power0", 0.35, self.x / 256)    -- 原作 #37 PLAY_SOUND 5
                bmove(self, 120, 0, 0, 0)            -- 原作 #38：线性回正中
                ---原作 sub115 的 #29..#31 / #34..#36 两段各 120 次整数的 DEC_JUMP 空转
                ---不推进母体时间，却实打实走了 238 帧 ⇒ 此后所有绝对时间都要 +238。
                task.Wait(633)                       -- ≈t=450 → t=1083
                local sx = (player.x >= 0) and 1 or -1
                bmove(self, 300, 0, 128 * sx, -160)  -- 原作 #52/#55：横穿到下半屏同侧
                task.Wait(306)                       -- → t=1151
                bmove(self, 300, 0, -128 * sx, -160) -- 原作 #67/#69：反向横穿
                task.Wait(700)                       -- → t=1851
                bmove(self, 600, 0, 0, 128)          -- 原作 #78：600 帧飘到 (0,128)
                task.Wait(700)                       -- → t=2551
                bmove(self, 300, 0, 160 * sx, 0)     -- 原作 #90/#92
                task.Wait(400)                       -- → t=2951
                bmove(self, 300, 0, 0, 0)            -- 原作 #94：回正中
            end)
            ---原作 PLAY_SOUND 5（se_power0）共 6 次：#37 被压到 ≈t=450，
            ---#48/#64/#77/#87/#93 按绝对时间 1023/1329/2029/2729/3129 响。
            task.New(self, function()
                local cur = 450
                PlaySound("power0", 0.35, self.x / 256)
                for _, tw in ipairs({ 1023, 1329, 2029, 2729, 3129 }) do
                    task.Wait(tw - cur); cur = tw
                    PlaySound("power0", 0.35, self.x / 256)
                end
            end)
            ---四边炮台：{帧, {sub116/117/118/119 的 {出生点,目标点,发射角,波内延迟}}}（我们的坐标）。
            ---第一波（原作 t=212/223/234/245）被 sub115 的循环压到 ≈t=450 同时出现；
            ---之后三波的原作指令时刻 t=851/1451/1951 也同样落在墙钟 1089/1689/2189。
            ---第 6 项 = 本波内的额外延迟：第一波的原作四条指令分别落在
            ---内部 t=212/223/234/245（墙钟 450/461/472/483），后三波同帧。
            ---★ 出生点必须**逐波**照抄 ECL 的 `SPAWN_ENEMY_ABS` 坐标（第 2/3 个参数）：
            ---  第一波（t=212/223/234/245）与第二波（t=851）四条全是常数 ⇒ 从四角出生；
            ---  但第三波（t=1451）与第四波（t=1951）的坐标里各有一项是 `*f0`
            ---  （= 紧邻的 `SET_FLOAT *f0`，其值又常是**上一波**最后留下的那个），
            ---  而子敌在 `SPAWN_ENEMY_ABS` 那一刻**继承调用方的局部 f 变量**
            ---  （spawn 会把调用方的 eclContextArgs 拷给新敌）⇒ 于是
            ---  `MOVE_POS_TIME` 的终点 (= (0,f0) / (384,f0) / (f0,0) / (f0,448))
            ---  恰好与出生点重合 —— 那两波炮台**原地不动**（原作墙钟 1689/2189 起）。
            ---  旧实现一律从四角出生再飞过去，于是从 1689 帧起位置整段错开
            ---  （每 44 帧一轮、每轮 4 发的错位就是这里来的）。
            ---每条 = { 出生 x, 出生 y, 目标 x, 目标 y, 发射角, 波内延迟 }（我们的坐标）。
            local BAT = {
                {  450, { { -192,  224, -192,  -96,   0,  0 }, { 192, -224, 192,   96, 180, 11 },
                          {  192,  224,  -64,  224, -90, 22 }, { -192, -224,  64, -224,  90, 33 } } },
                { 1089, { { -192,  224, -192, -128,   0 }, { 192, -224, 192,  128, 180 },
                          {  192,  224,  -96,  224, -90 }, { -192, -224,  96, -224,  90 } } },
                { 1689, { { -192,  -64, -192,  -64,   0 }, { 192,   64, 192,   64, 180 },
                          {  -32,  224,  -32,  224, -90 }, {   32, -224,  32, -224,  90 } } },
                { 2189, { { -192, -160, -192, -160,   0 }, { 192,  160, 192,  160, 180 },
                          { -128,  224, -128,  224, -90 }, {  128, -224, 128, -224,  90 } } },
            }
            local MV = { 400, 400, 300, 300 }
            task.New(self, function()
                local now = 0
                local function at(t) if t > now then task.Wait(t - now); now = t end end
                for _, b in ipairs(BAT) do
                    for k = 1, 4 do
                        local e = b[2][k]
                        at(b[1] + (e[6] or 0))
                        pspawn(e[1], e[2], turret,
                               { tx = e[3], ty = e[4], a = e[5], mv = MV[k] })
                    end
                end
            end)
            ---角炮：t=3051 起 16 波（间隔 150→…→40 帧），4 个角轮转、基准角见上。
            do
                local C = { { -192,  224,   0 },
                            {  192, -224, 180 },
                            {  192,  224, -90 },
                            { -192, -224,  90 } }
                local SW = { 3289, 3439, 3589, 3739, 3839, 3939, 4029, 4109,
                             4169, 4219, 4259, 4299, 4339, 4379, 4419, 4459 }
                task.New(self, function()
                    task.Wait(SW[1])
                    for k = 1, #SW do
                        if k > 1 then task.Wait(SW[k] - SW[k - 1]) end
                        local c = C[((k - 1) % 4) + 1]
                        pspawn(c[1], c[2], corner, { a = c[3] - ran:Float(0, 5.625) })
                    end
                end)
            end
        end)
    end
    ---────────── sc125 式神「橙」（原作 sub 110 + 111/112/114，80s） ──────────
    ---本体进场到 (0,96)，活动框 x∈[−128,128]、y∈[96,176]（原作 SET_MOVEMENT_BOUNDS）。
    ---t=210 爆闪（原作 gI0=15 → 60 帧）；t=280 放出一只「橙」式神（原作 sub111）
    ---并把本体用 60 帧 ease-out 移到 (0,160)（原作 MOVE_POS_TIME(60,4,192,64)）。
    ---此后本体每轮打一圈 24 发瞄准环（原作 sub110 RING_AIMED：sprite2/色6、速 1.8），
    ---轮间隔 l2i1 从 90 帧每轮 −2、减到 40 帧后固定。
    ---「橙」式神（原作 sub111）每 120 帧一轮：先原地停 30 帧，再用 90 帧 ease-out
    ---飘到下一个落点；到点后打「28 发 ×2 层整圈环（速 2→1）」+「上下两扇 8 发 ×2 层
    ---瞄准弹（以自机方向 ±90° 为中心、张角 ±11.25°、速 8→1）」并响一次音（se_tan00）。
    ---弹色档按本轮落点的「上下状态」取 1 或 3（原作 li0/li1）。
    ---落点：x 在左右两端（原作 16 与 368，即我们的 ∓176）交替；y 在上一个落点上
    ---随机走 64~128 px（原作两条 RAND_FLOAT_ADD 分支，TH07 往下走 ⇒ 我们的 y 减小），
    ---走出界就把 y 夹到边界（我们 −224 / 96）并翻一次上下状态。
    ---原作每轮还在落点生一个存活 120 帧的「橙」贴图（sub112）；本仓库的式神不画立绘
    ---（与 PH「八雲藍」同一处理），这条纯演出差异记在案。
    do
        local NAME = "式神「橙」"
        ---「橙」式神（原作 sub111）；self.y 换算：TH07 的 posY = 224 − self.y。
        local function orange(self)
            local sx, side = -176, 0
            while true do
                local y
                if side == 0 then
                    ---原作：lf1 = posY + 64 + rand(0,64)，>448 才夹（= 我们的 y <= −224）
                    y = self.y - 64 - ran:Float(0, 64)
                    if y <= -224 then y, side = -224, 1 end
                else
                    ---原作：lf1 = posY − 96 − rand(0,64)，<=128 才夹（= 我们的 y >= 96）
                    y = self.y + 96 + ran:Float(0, 64)
                    if y >= 96 then y, side = 96, 0 end
                end
                task.Wait(30)
                bmove(self, 90, 4, sx, y)          -- 原作 t=30 的 MOVE_POS_TIME(90, ease4)
                ---★ 同本作用域 sub120 炮台（6468 行）：`PSCRIPT` 没挂 `frame`，
                ---子机的 `bstep` 得自己推，否则式神永远停在出生点（原作是真在飞 90 帧）。
                for _ = 1, 90 do bstep(self); task.Wait(1) end   -- 一轮共 120 帧
                local col = (side == 1) and 3 or 1
                gring(self, bs(8), col, 28, 2, 2, 1, 0, 0, true)
                local aim = Angle(self, player)
                gspread(self, bs(8), col, 8, 2, 8, 1, aim + 90, 0.19635 * RAD2DEG, true)
                gspread(self, bs(8), col, 8, 2, 8, 1, aim - 90, 0.19635 * RAD2DEG, true)
                PlaySound("tan00", 0.1, self.x / 256)    -- 原作 sub111 #36 PLAY_SOUND 0xf
                sx = -sx
            end
        end
        spellcard(NAME, 3469, 80, 3000, false, function(self)
            self._box = { -128, 128, 96, 176 }
            task.New(self, function()
                task.Wait(210)
                PlaySound("power0", 0.35, self.x / 256)     -- 原作 SUB_CALL 2（gI0=15 ⇒ 冻结 60 帧）
                task.Wait(60)
                task.Wait(70)                               -- 冻结结束后再从 t=210 走到 t=280
                pspawn(self.x, self.y, orange)              -- 原作 #29 SPAWN_ENEMY_REL sub111
                bmove(self, 60, 4, 0, 160)                  -- 原作 MOVE_POS_TIME(60,4,192,64)
                local gap = 90
                while true do
                    gring(self, bs(2), 6, 24, 1, 1.8, 1, Angle(self, player), 0, true)
                    task.Wait(gap)
                    if gap > 40 then gap = gap - 2 end
                end
            end)
        end)
    end

    ---────────── sc124 式弾「ユーニラタルコンタクト」（原作 sub 106 + 107/108/109，80s） ──────────
    ---本体进场到 (0,96)，活动框 x∈[−128,128]、y∈[96,176]（原作 SET_MOVEMENT_BOUNDS）。
    ---t=210 起每一整轮（#28..#54 循环）：
    ---  · 先甩一整套「自旋银河」（原作 sub107）：一次性打出 64+l2i3 圈「四发随机环」，
    ---    每圈四发同速（sprite5/色6、速 rand(2,7)）、整圈起角各掷一次 rngRadian；
    ---    每发挂三段指令 —— 120 帧沿原方向刹车到停 → 原地自旋 180 帧（+1°/帧）
    ---    同时把速度加回 0.0111111/帧 → 再沿冻结方向匀加速 0.0208333/帧、共 120 帧。
    ---  · 接 6 组「七发瞄准扇」（原作 sub109）：sprite8/色2、速 4，张角依次
    ---    ±22.5°/±45°/±67.5°（成对出现，故 7 发），每 10 帧一组。
    ---  · 之后朝 RAND_EXIT_ANGLE 方向漂 60 帧，每段漂移前爆闪一次（原作 gI0=30 的
    ---    粒子闪、120 帧）；第二段漂移之后再来一套「反向自旋银河」（sub108：sprite5/色2、
    ---    自旋 −1°/帧）+ 6 组瞄准扇，然后回到本轮开头。
    ---  · l2i1（两段漂移后的等待时长）从 70 每半轮 −5，减到 35 后固定；l2i3 则每半轮 +2，
    ---    所以银河的圈数（=每次甩出的环数）越来越厚。
    do
        local NAME = "式弾「ユーニラタルコンタクト」"
        ---原作 sub107/108：count 圈四发随机环 + 每发三段指令（dir=+1 逆时针 / −1 顺时针）。
        ---自旋角速度原作 ±0.0174533 rad/帧（1°/帧），换到我们（取反）就是 −dir。
        local function swirl(self, spr, col, count, dir)
            ---★ 原作 sub107/108 每一圈的循环体是 `RAND_FLOAT_ADD *f0 5 2`（速度）在前、
            ---`RING_ABS ... *f0 2 *RNGRAD ...`（角度）在后 ⇒ 随机数顺序是「先速度、后角度」。
            ---另外 *RNGRAD 是 TH07 口径的弧度角，本仓库角度取反 ⇒ 取负。
            local rings = {}
            for i = 1, count do rings[i] = { ran:Float(2, 7), -rngdeg() } end
            volley4_raw(self, count * 4, function(i)
                local r = rings[int((i - 1) / 4) + 1]
                return New(class["TH34_cmdbullet"], bs(spr), col16(col),
                           self.x, self.y, r[1], r[2] + ((i - 1) % 4) * 90,
                           { stages = {
                               { type = 0x40, dur = 120, loop = 1, angle = 0, speed = 0 },
                               { type = 0x20, dur = 180, loop = -1,
                                 angle = -dir, speed = 0.0111111 },
                               { type = 0x10, dur = 120, loop = -1, accel = 0.0208333 },
                           } })
            end)
        end
        ---原作 sub109：6 组七发瞄准扇，每 10 帧一组（共 60 帧）。
        local function fan(self)
            for _ = 1, 6 do
                gspread(self, bs(8), 2, 7, 1, 4, 1, Angle(self, player), 22.5, true)
                task.Wait(10)
            end
        end
        spellcard(NAME, 3468, 80, 2700, false, function(self)
            self._box = { -128, 128, 96, 176 }
            task.New(self, function()
                task.Wait(210)
                local wait, extra = 70, 0
                while true do
                    swirl(self, 5, 6, 64 + extra, 1)          -- sub107
                    fan(self)
                    task.Wait(60)                             -- ECL 210 → 270
                    PlaySound("power0", 0.35, self.x / 256)   -- t=270 爆闪（gI0=30）
                    task.Wait(120)
                    exdrift(self, 1, 0)                       -- t=270 第一段漂移
                    task.Wait(120)                            -- ECL 270 → 390
                    exdrift(self, 1, 0)                       -- t=390 第二段漂移
                    task.Wait(wait)
                    if wait >= 40 then wait = wait - 5 end
                    extra = extra + 2
                    swirl(self, 5, 2, 64 + extra, -1)         -- sub108
                    fan(self)
                    task.Wait(60)                             -- ECL 390 → 450
                    PlaySound("power0", 0.35, self.x / 256)   -- t=450 爆闪（gI0=30）
                    task.Wait(120)
                    exdrift(self, 1, 0)                       -- t=450 第一段漂移
                    task.Wait(120)                            -- ECL 450 → 570
                    exdrift(self, 1, 0)                       -- t=570 第二段漂移
                    task.Wait(wait)
                    if wait >= 40 then wait = wait - 5 end
                    extra = extra + 2                         -- → 跳回 t=210
                end
            end)
        end)
    end

    ---────────── sc123 式弾「アルティメットブディスト」（原作 sub 101 + 102/103/104/105，80s） ──────────
    ---本体停在画面正中 (0,0)。和 PH 的 3445 同构（同一组激光台 sub104/105 =
    ---PH sub107/108、同样的 SUB_CALL 2 冻结时间轴），只是乱射/瞄准环换成
    ---sub102/sub103、前段周期是 10 帧：
    ---  · 真实 274 放出两台激光台，并把周期回调设成每 10 帧一波的刹车乱星
    ---    （sub102：2 发、sprite3/色6、速度 rand(1,4)、方向全周随机，每发挂 0x40：
    ---    120 帧刹到停、再以 0.1 直飞）；回调独立于主 sub，冻结期间照样开火；
    ---  · 真实 544 爆闪（t=480）→ 644 清屏并关回调；
    ---  · 真实 704 改成每 10 帧一波的五发瞄准环（sub103：sprite7/色1、速 4）；
    ---  · 真实 1144 爆闪（t=980）→ 1244 清屏、改回每 20 帧一波乱星；真实 1274 跳回 t=210。
    do
        local NAME = "式弾「アルティメットブディスト」"
        ---原作 sub102：一波 2 发刹车乱星（0x40 指令：120 帧刹到停、然后
        ---按 cmd.angle=0.1 继续直飞；作者把 ZUN 的 spd/ang 交换实现在
        ---TH34_cmdbullet 里，所以这里 angle=转向量、speed=刹停后的新速度）。
        local function star(self)
            volley4_raw(self, 2, function()
                ---★ 原作 sub102 就是 op72 RANDOM：逐发**先抽角、后抽速**（BulletManager.cpp:215-231）。
                ---角度是 TH07 口径（y 朝下），本仓库取反 ⇒ 取负。
                local th = -rngdeg()
                local v = ran:Float(1, 4)
                return New(class["TH34_cmdbullet"], bs(3), col16(6), self.x, self.y,
                           v, th, {
                               type = 0x40, dur = 120, loop = 1, angle = 0, speed = 0.1 })
            end)
        end
        spellcard(NAME, 3467, 80, 2700, false, function(self)
            bmove(self, 120, 4, 0, 0)
            ---周期回调（同 3445）：duty = 间隔（0 = 关），重设时 counter 归零。
            local duty, fire, counter = 0, nil, 0
            local function set_duty(d, f) duty, fire, counter = d, f, 0 end
            task.New(self, function()
                while true do
                    task.Wait(1)
                    if duty > 0 then
                        counter = counter + 1
                        if counter >= duty then counter = 0; fire() end
                    end
                end
            end)
            task.New(self, function()
                task.Wait(210)
                ---★ 同 3445：原作 sub101 的 `JUMP 210 -280` 落点是 #31 `SET_PERIODIC_CALLBACK 10 102`
                ---（off 39208），跳过 #22..#30 的 SUB_CALL 2 与两台激光台出生——
                ---所以这些只在第一轮做一次，之后每轮直接从 `SET_PERIODIC 10 102` 续。
                PlaySound("power0", 0.35, self.x / 256)      -- 原作 SUB_CALL 2（gI0=16 ⇒ 64 帧）
                task.Wait(64)
                pspawn(self.x, self.y, laser_rig107)         -- 原作 sub104
                pspawn(self.x, self.y, laser_rig108)         -- 原作 sub105
                set_duty(10, function() star(self) end)
                while true do
                    task.Wait(270)                               -- 真实 274 → 544（原作 t=480）
                    PlaySound("nep00", 0.5, self.x / 256)        -- 原作 #32 PLAY_SOUND 0x13（se_nep00）
                    PlaySound("power0", 0.35, self.x / 256)      -- 原作 #35 SUB_CALL 2（gI0=25 ⇒ 100 帧）
                    task.Wait(100)
                    PlaySound("tan00", 0.1, self.x / 256)        -- 原作 #36 PLAY_SOUND 0xf
                    pclear()
                    set_duty(0, nil)
                    task.Wait(60)                                -- 真实 644 → 704（原作 t=540）
                    set_duty(10, function()
                        gring(self, bs(7), 1, 5, 1, 4, 1, Angle(self, player), 0, true)
                    end)
                    task.Wait(440)                               -- 真实 704 → 1144（原作 t=980）
                    PlaySound("nep00", 0.5, self.x / 256)    -- 原作 #40 PLAY_SOUND 0x13（se_nep00）
                    PlaySound("power0", 0.35, self.x / 256)  -- 原作 #43 SUB_CALL 2（gI0=25 ⇒ 100 帧）
                    task.Wait(100)
                    PlaySound("tan00", 0.1, self.x / 256)    -- 原作 #44 PLAY_SOUND 0xf
                    pclear()
                    set_duty(20, function() star(self) end)
                    task.Wait(30)                                -- 真实 1244 → 1274（t=1010 的 JUMP）
                    set_duty(10, function() star(self) end)      -- JUMP 落点 #31：直接续上周期 10
                end
            end)
        end)
    end

    ---────────── sc122 式輝「プリンセス天狐 -Illusion-」（原作 sub 99 + 齐射 sub 100，75s） ──────────
    ---本体进场到 (0,128)；t=210 起每轮循环（原作 sub99 的 #28..#41）：
    ---  · 原地爆闪一下（原作 SUB_CALL 2：音效 + 每 4 帧一发粒子、共 4 次）；
    ---  · 30 帧后打一整套「大齐射」（原作 sub100 的 14 条指令，逐帧打出 177 发）：
    ---      t=0   1 发直弹（sprite10/色1、速 4.5、朝自机）；
    ---      t=1   8 发随机扇（sprite7/色3、速 2~3.5、以自机方向为中心 ±5.625°）；
    ---      t=2   16 发随机扇（sprite3/色6、速 3~4.5、±5.625°）；
    ---      t=2   把两条随机扇的中心张角放大到 ±15°；
    ---      t=3   8 发随机扇（sprite7/色3、速 1~2、±15°）；
    ---      t=4   16 发随机扇（sprite3/色6、速 1~2、±15°）；
    ---      t=11  开接触判定、t=14 打 32 发 ×4 层瞄准环（sprite8/色4、速 2→1）后关掉。
    ---  · 齐射收尾后「隐身」瞬移到**自机当前坐标**上，再爆闪一次；之后隔 l2i1 帧
    ---    回到本轮开头。l2i1 初值 100、每轮 −10，减到 10 后固定不再减。
    ---（原作在瞬移前后的 3 帧里给本体开了接触判定（撞到自机即中弹），本仓库的 boss
    ---没有「撞到自机判伤」的通道，这条差异记在案。）
    do
        local NAME = "式輝「プリンセス天狐　-Illusion-」"
        ---原作 sub100 的整套齐射（角度一律以「自机方向」为中心，± 是双侧对称量）。
        local function volley(self)
            local aim = Angle(self, player)
            gspread(self, bs(10), 1, 1, 1, 4.5, 1, aim, 0, true)              -- 原作 t=0
            task.Wait(1)
            grandom(self, bs(7), 3, 8, 3.5, 2, aim + 5.625, -11.25, false)     -- t=1
            task.Wait(1)
            grandom(self, bs(3), 6, 16, 4.5, 3, aim + 5.625, -11.25, false)    -- t=2
            task.Wait(1)
            grandom(self, bs(7), 3, 8, 2, 1, aim + 15, -30, false)             -- t=3
            task.Wait(1)
            grandom(self, bs(3), 6, 16, 2, 1, aim + 15, -30, false)            -- t=4
            task.Wait(10)
            gring(self, bs(8), 4, 32, 4, 2, 1, aim, 0, false)                  -- t=14
        end
        spellcard(NAME, 3466, 75, 1400, false, function(self)
            bmove(self, 120, 4, 0, 128)
            task.New(self, function()
                task.Wait(210)                               -- 母体 t=210（循环回跳的落点是 #28）
                local wait, flash = 100, 16
                while true do
                    PlaySound("power0", 0.35, self.x / 256)      -- 原作 #28 SUB_CALL 2（gI0；首轮 4 ⇒ 16 帧）
                    task.Wait(flash)
                    task.Wait(30)                                -- t=210 → t=240
                    volley(self)                                 -- 原作 SUB_CALL 100（14 帧，不推进母体时间）
                    task.Wait(20)                                -- 母体 t 仍停在 240 ⇒ 等到 t=260
                    self.hide = true                             -- 原作 #32 SET_HAS_NO_COLLISION 1
                    task.Wait(wait)                              -- 原作 #33 SET_WAIT_TIMER(l2i1)
                    self.x, self.y = player.x, player.y          -- 原作 #34 SET_POS(plX, plY)
                    PlaySound("power0", 0.35, self.x / 256)      -- 原作 #37 SUB_CALL 2（gI0=10 ⇒ 40 帧）
                    task.Wait(40)
                    self.hide = false                            -- 原作 #38 SET_HAS_NO_COLLISION 0
                    ---原作 JUMP 落点是 #28（`SET_INT *gi0 4` 之前），所以每轮 flash 恒为 16 帧。
                    if wait > 10 then wait = wait - 10 end
                end
            end)
        end)
    end

    ---────────── sc121 式輝「四面楚歌チャーミング」（原作 sub 97 + 周期 98，65s） ──────────
    ---本体走到 (0,160) 后，每 l2i1 帧（初值 100、每轮 −5、止于 40）：
    ---  · 朝 RAND_EXIT_ANGLE 方向线性漂 60 帧（速度 1）；
    ---  · 两圈各 12 发整圈（速度 2、基准角各掷一枚 rngRadian），第 1 圈的 12 发装
    ---    「角速度 +3°/帧、速度 −0.00833333/帧、共 60 帧」的自转命令（原作
    ---    INIT_BULLET_CMD type 0x20），第 2 圈反向。
    ---周期回调 sub98（period 8、t=218 首次）：每拍 16 发「刹车拐弯弹」——8 组、每组
    ---两颗，分别朝 lf5 ± lf0 打出（速度 6、sprite 5/色档 8），60 帧内沿原朝向把速度
    ---线性刹到 0，再按 ±lf0·lf4 转一次向（0x40 的角增量）、速度换成 lf1；lf0 每拍 +lf6、lf1 +0.125、
    ---lf4 −0.125（lf6 初值 11.25°，按 li0<30 每拍微增/微减 0.0625°）。li0 每拍 +1 模 60。
    ---★ 原作 #24..#30 还有一段「lf5 与自机角之差超过 30° 就拨 ∓0.9°」，但序言 #4
    ---每拍都把 lf5 写回 1.5708，所以这段拨角在真机上是**死代码** —— 基准角恒 90°。
    ---（原作这两组弹的 flags 0x2242 带 0x2000 ⇒ idx1 的 0x2000 指令会把 spawnDelay 设成
    ---200，但那只是「200 帧内即使出屏也不回收」（BulletManager.cpp:995 的出屏判定）；
    ---命中判定完全不受影响，且这些弹刹在敌机旁不动，所以本文件不模拟 spawnDelay 没有差异。）
    do
        local NAME = "式輝「四面楚歌チャーミング」"
        ---一圈 12 发（原作 RING_ABS pk=(10,0) c1=12 v1=2 + INIT_BULLET_CMD 0x20）。
        ---a1th = 原作基准角（弧度）；dth = 我们口径的每帧角增量（度）。
        local function ring20(self, a1th, dth)
            local base = -a1th * RAD2DEG
            for k = 0, 11 do
                pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(10), col16(0),
                                        self.x, self.y, 2, base + k * 30,
                                        { type = 0x20, dur = 60, loop = -1,
                                          angle = dth, speed = -0.00833333 })
            end
            sound4(self)
        end
        ---一发「刹车拐弯弹」（原作 SPREAD_ABS pk=(5,8) + INIT_BULLET_CMD 0x40）：
        ---a1th = 发射角（原作弧度）、na = **角增量**（＝原作 INIT_BULLET_CMD 的 spd 字段，
        ---弧度：0x40 把 cmd.spd 当 `angle +=` 的增量用，见 BulletManager.cpp:410 的 ZUN
        ---交换）、spd = 拐后新的速度。角增量取反后才是我们口径。
        local function brake(self, a1th, na, spd)
            local ang = -a1th * RAD2DEG
            pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(5), col16(8),
                                    self.x, self.y, 6, ang,
                                    { type = 0x40, dur = 60, loop = 1,
                                      angle = -na * RAD2DEG, speed = spd })
        end
        spellcard(NAME, 3465, 65, 2800, false, function(self)
            self._box = { -128, 128, 96, 176 }
            ---进场：原作 t=0 的 MOVE_POS_TIME(120, ease4, 192, 64)。
            bmove(self, 120, 4, 0, 160)
            ---周期回调（原作 SET_PERIODIC_CALLBACK period=8 sub=98，t=218 首次）。
            task.New(self, function()
                task.Wait(218)
                ---★ 原作 sub98 的序言 #0..#5 **每拍都会重跑**（周期回调每次都从 sub 的 #0
                ---开始），其中 #4 就是 `SET_FLOAT lf5 = 1.5708`。所以 #24..#30 那段
                ---「lf0 = lf5 − angToPl，|差| 超 30° 就把 lf5 拨 0.9°」在本条调用路径上
                ---**是死代码**：每拍吐弹用的 lf5 恒为 90°，拨完下一拍又被打回 1.5708。
                ---（lf6 不在此列 —— 序言不碰它，所以它跨拍累加，三角波是真的。）
                local lf5, lf6, li0 = 1.5708, 0.19635, 0
                while true do
                    lf5 = 1.5708
                    for i = 0, 7 do
                        local lf0 = 0.785398 + i * lf6
                        local lf1 = 2 + i * 0.125
                        local lf3 = lf0 * (-0.75 - i * 0.125)
                        brake(self, lf5 + lf0, lf3, lf1)
                        brake(self, lf5 - lf0, -lf3, lf1)
                    end
                    sound4(self)
                    if li0 >= 30 then lf6 = lf6 + 0.00109083
                    else lf6 = lf6 - 0.00109083 end
                    li0 = (li0 + 1) % 60
                    task.Wait(8)
                end
            end)
            ---本体：漂 → 停 l2i1 帧 → 两圈。
            task.New(self, function()
                task.Wait(210)
                local wait = 100
                while true do
                    local d = exang(self)
                    bmove(self, 60, 0, self.x + cos(d) * 60, self.y + sin(d) * 60)
                    task.Wait(wait)
                    ring20(self, rngrad(), -3)
                    ring20(self, rngrad(), 3)
                    if wait > 40 then wait = wait - 5 end
                end
            end)
        end)
    end

    ---────────── sc120 式輝「狐狸妖怪レーザー」（原作 sub 94 + 子机 95/96，75s） ──────────
    ---本体 t=0 用 120 帧 ease-out 移到 TH07(192,64)（我们 (0,160)）。此后每轮：
    ---  · 两套「狐狸弹」（原作 #31..#40 / #48..#57，各 5 个击发点、间隔 1 帧）：
    ---    1 发瞄准直线弹（速 4.5）+ 8 发(2~3.5) + 16 发(3~4.5) 两张角在 ±5.625°、
    ---    8 发(1~2) + 16 发(1~2) 两张角在 ±15°（角度都是 rand(a1−a2)+a2）；
    ---    上半场色档 (10,1)(7,3)(3,6)、下半场 (10,0)(7,1)(3,2)；
    ---  · t=234 在原地挂「激光扫射子机」sub95、t=258 再挂 sub96；两轮之间本体朝
    ---    RAND_EXIT_ANGLE 方向线性漂 60 帧（速度 1）；
    ---  · SET_WAIT_TIMER 让循环停顿 l2i1 帧（初值 170、每轮 −7、止于 114），停顿在
    ---    子机挂出之后、后一套狐狸弹之前。
    ---子机（sub95/96，寿命 240 帧，实际 8 轮后 UNIMP 自毁）沿 spawn 时继承的 lf0 方向
    ---匀速 4 平移（lf0 比本体当轮的漂移方向**慢一拍**：sub95 用上一轮 t=258 的值、
    ---sub96 用本轮 t=234 的值）。每 16 帧一轮共 8 轮，每轮两张：
    ---  先朝「lf0 + 90° + rand(−lf5/2, lf5/2)」放一条激光（w=16）并打 2 发扇
    ---  （速度 1.5、相对 lf0 ±5.625°），8 帧后再朝「lf0 − 90° + rand(−lf5/2, lf5/2)」放一条。
    ---lf5 由本体继承（初值 π/6，每轮 +3.6°）。激光 90 帧展开、200 帧满宽、30 帧收束，
    ---判定从第 80 帧起；sub95 色档 6、sub96 色档 2。
    do
        local NAME = "式輝「狐狸妖怪レーザー」"
        ---一套「狐狸弹」（原作 #34..#40 / #51..#57）：5 个击发点，间隔 1 帧。
        local function volley(self, A)
            local aim = Angle(self, player)
            local S = A and { { 10, 1 }, { 7, 3 }, { 3, 6 }, { 7, 3 }, { 3, 6 } }
                        or { { 10, 0 }, { 7, 1 }, { 3, 2 }, { 7, 1 }, { 3, 2 } }
            volley3(self, 1, function() return bs(S[1][1]), col16(S[1][2]), 4.5, aim end, true)
            task.Wait(1)
            grandom(self, bs(S[2][1]), S[2][2], 8, 3.5, 2, aim + 5.625, -11.25, true)
            task.Wait(1)
            grandom(self, bs(S[3][1]), S[3][2], 16, 4.5, 3, aim + 5.625, -11.25, true)
            task.Wait(1)
            grandom(self, bs(S[2][1]), S[2][2], 8, 2, 1, aim + 15, -30, true)
            task.Wait(1)
            grandom(self, bs(S[3][1]), S[3][2], 16, 2, 1, aim + 15, -30, true)
            return aim
        end
        ---激光扫射子机（原作 sub95/96）。a = { dir(我们的角度制), lf5(原作弧度), col, spr }。
        ---dir = 生成瞬间父程的 *f0，由 sub94 `SET_FLOAT *f0 *A2P` 写入 ⇒ 就是「本体→自机」方向
        ---（子机继承父程的 eclContextArgs，`EnemyManager.cpp:122`）。
        ---原作 sub95/96 时序（每轮 16 帧、共 8 轮 ⇒ 16 条激光）：
        ---  idx 4 : MOVE_DIR_TIME(0, 0, *f0, 4)。time=0 ⇒ 引擎走 `EclManager.cpp:1537` 的
        ---           POLAR 分支（angle=f0、speed=4、每帧沿 f0 飞 4px），**不是**原地不动。
        ---  idx 6 : *f1 = rand(0,*f5) + *f0 → idx7/8 算出 *f7 = (π−*f5)/2 → idx9/10 *f1 += *f7
        ---           ⇒ 第一条激光角 = f0 + rand(0,f5) + (π−f5)/2。
        ---  idx 11: LASER_FIXED（角 = *f1、固定速度 0、sOff0/eOff640/sLen640、宽16、
        ---           展开90/满200/收30、判定80..30）。
        ---  idx 12: SPREAD_ABS（spr3/色档 a.col、count1=2、速度1.5、中心角 *f0、张角 0.19635）
        ---           ⇒ 2 发围绕 **f0**（不是激光角）±5.625°。
        ---  idx13..18: *f6 = −*f5；*f1 = f0 + rand(0,−f5) − (π−f5)/2 ⇒ 第二条激光角。
        ---  idx19: DEC_JUMP 回 idx6，*i2_0 递减（8 次）。
        ---我们的角度制 = −(TH07 弧度)，所以两条激光角写成 dir − (rand(0,f5)+(π−f5)/2)
        ---与 dir + (rand(0,f5)+(π−f5)/2)、弹扇中心 = dir。
        local function sweeper(self, a)
            local offs = spread_offsets(2, -0.19635 * RAD2DEG)
            local dx, dy = cos(a.dir) * 4, sin(a.dir) * 4
            local half = (PI - a.lf5) / 2
            local function fire(ang)
                plaser(self.x, self.y, ang, {
                    spr = a.spr, w = 16, sOff = 0, eOff = 640, sLen = 640,
                    tStart = 90, dur = 200, tEnd = 30, hbStart = 80, hbEnd = 30 })
                for k = 1, 2 do
                    volley3(self, 1, function()
                        return bs(3), col16(a.col), 1.5, a.dir + offs[k]
                    end, true)
                end
            end
            for _ = 1, 8 do
                fire(a.dir / RAD2DEG - (ran:Float(0, a.lf5) + half))
                for _ = 1, 8 do
                    self.x, self.y = self.x + dx, self.y + dy
                    task.Wait(1)
                end
                fire(a.dir / RAD2DEG + (ran:Float(0, a.lf5) + half))
                for _ = 1, 8 do
                    self.x, self.y = self.x + dx, self.y + dy
                    task.Wait(1)
                end
            end
        end
        spellcard(NAME, 3464, 75, 2000, false, function(self)
            self._box = { -128, 128, 96, 176 }
            ---进场：原作 t=0 的 MOVE_POS_TIME(120, ease4, 192, 64)。
            bmove(self, 120, 4, 0, 160)
            task.New(self, function()
                task.Wait(210)
                local lf5, wait = 0.523599, 170
                while true do
                    PlaySound("power0", 0.35, self.x / 256)   -- 原作 #30 SUB_CALL 2（gI0=10 ⇒ 冻结 40 帧）
                    task.Wait(40)
                    ---原作 #31 `SET_FLOAT *f0 *A2P`：#34..#40 的扇心与 #41 生成的
                    ---sub95 都读这份「t=210 的快照」。
                    local aim1 = volley(self, true)      -- t=210..214
                    task.Wait(20)                -- → t=234
                    ---sub95：继承本轮 t=210 的 *f0 = A2P。
                    pspawn(self.x, self.y, sweeper,
                           { dir = aim1, lf5 = lf5, col = 6, spr = 6 })
                    local d1 = exang(self)
                    bmove(self, 60, 0, self.x + cos(d1) * 60, self.y + sin(d1) * 60)
                    task.Wait(wait)              -- 原作 #44 SET_WAIT_TIMER(l2i1)；#44 执行完本帧即止
                    PlaySound("power0", 0.35, self.x / 256)   -- 原作 #47 SUB_CALL 2（冻结 40 帧）
                    task.Wait(40)
                    ---原作 #48 `SET_FLOAT *f0 *A2P`：本条快照供 #58 生成的 sub96。
                    local aim2 = volley(self, false)     -- t=234..238
                    task.Wait(20)                -- → t=258
                    ---sub96：继承本轮 t=234 的 *f0 = A2P。
                    pspawn(self.x, self.y, sweeper,
                           { dir = aim2, lf5 = lf5, col = 2, spr = 2 })
                    local d2 = exang(self)
                    bmove(self, 60, 0, self.x + cos(d2) * 60, self.y + sin(d2) * 60)
                    task.Wait(wait)              -- 原作 #62 SET_WAIT_TIMER(l2i1)
                    lf5 = lf5 + 0.0628319
                    if wait > 120 then wait = wait - 7 end
                end
            end)
        end)
    end

    ---────────── sc119 式神「十二神将の宴」（原作 sub 88 + 89..93，65s） ──────────
    ---本体 t=210..430 每 20 帧放一只「神将」（共 12 只，各自飞向场内一个固定点），
    ---随后 t=530/630/…/1030 边漂边打 11 发×2 层的瞄准扇，t=1130 回到 t=210 循环。
    do
        local NAME = "式神「十二神将の宴」"
        ---「神将」子机（原作 sub89..93）：从本体位置飞到 (tx,ty)（120 帧 ease-out），途中每 10 帧
        ---朝上打一发（速度 0.8+0.1i，共 12 发；色档是继承来的 l3i0 = 0）；飞到位后按变体循环：
        ---  kind1/2（sub90/91）：每 6 帧单发、角度逐次 ∓0.191561（100 次）；
        ---  kind3/4（sub92/93）：每 20 帧 4 发环、基准角恒为 π/2 / 3π/4（30 次；lf0 的
        ---  累加是原作死代码，a1 是字面量）。
        local function genbu(self, a)
            bmove(self, 120, 4, a.tx, a.ty)
            for i = 0, 11 do
                ---原作 sub89 的 SPREAD_ABS pk=(6,10029)：色档取 l3i0（= gI0），
                ---由调用者 sub90/91 设 2、sub92 设 4、sub93 设 6。
                volley3(self, 1, function() return bs(6), col16(a.col), 0.8 + 0.1 * i, -90 end, true)
                for _ = 1, 10 do bstep(self); task.Wait(1) end
            end
            if a.kind <= 2 then
                local d, ang = a.kind == 1 and 0.191561 or -0.191561, 1.5708
                for _ = 1, 100 do
                    volley3(self, 1, function() return bs(6), col16(8), 1, -ang * RAD2DEG end, true)
                    ang = ang + d
                    for _ = 1, 6 do task.Wait(1) end
                end
            else
                local c, base = (a.kind == 3) and 4 or 6, (a.kind == 3) and 1.5708 or 2.35619
                for _ = 1, 30 do
                    gring(self, bs(6), c, 4, 1, 1.5, 1, -base * RAD2DEG, 0, true)
                    for _ = 1, 20 do task.Wait(1) end
                end
            end
        end
        ---{帧, 变体, 目标 x, 目标 y}（原作 lf0 = rand(32) + 基准，已换算到我们的坐标）。
        local G = {
            { 210, 1, -192, -160 }, { 230, 2,  160,  -96 },
            { 250, 2, -192,  -32 }, { 270, 1,  176,   32 },
            { 290, 3,  -64,   64 }, { 310, 3,   32,   64 },
            { 330, 4, -160,    0 }, { 350, 4,  128,    0 },
            { 370, 3, -160, -128 }, { 390, 3,  160, -128 },
            { 410, 4,  -64,  128 }, { 430, 4,   64,  128 },
        }
        spellcard(NAME, 3463, 65, 2400, false, function(self)
            self._box = { -128, 128, 96, 176 }
            ---进场：原作 t=0 的 MOVE_POS_TIME(120, ease4, 192, 96)（我们 (0,128)）。
            bmove(self, 120, 4, 0, 128)
            task.New(self, function()
                task.Wait(210)
                while true do
                    ---12 只神将相隔 20 帧（t=210,230,…,430），最后一只之后不再等 20 帧；
                    ---随后 100 帧到 t=530 才是第一次漂移。
                    for i, g in ipairs(G) do
                        pspawn(self.x, self.y, genbu,
                               { tx = g[3] + ran:Float(0, 32), ty = g[4], kind = g[2],
                                 col = (g[2] == 3) and 4 or ((g[2] == 4) and 6 or 2) })
                        if i < #G then task.Wait(20) end
                    end
                    task.Wait(100)                     -- → t=530
                    exdrift(self, 1, 4)
                    for _ = 1, 4 do
                        task.Wait(100)
                        exdrift(self, 1, 4)
                        shoot(self, 64, 8, 3, 11, 2, 2.5, 1, 0, 0.19635, true)
                    end
                    task.Wait(100)                     -- → t=1030
                    ---原作 t=1030 的 `RAND_EXIT_ANGLE *f0` 结果被后面的 `MOVE_POS_TIME`
                    ---覆盖（死代码），但它照样消耗一次 rand(0,π/2) ⇒ 必须照抽。
                    exang(self)
                    bmove(self, 60, 4, 0, self.y)
                    shoot(self, 64, 8, 3, 11, 2, 2.5, 1, 0, 0.19635, true)
                    task.Wait(100)                     -- → t=1130，回到 t=210
                end
            end)
        end)
    end

    ---────────── sc118 式神「仙狐思念」（原作 sub 85 + 86 + 87，60s） ──────────
    ---t=0 用 120 帧 ease-out 移到 TH07(192,96)（我们 (0,128)），之后在
    ---{−128..128, 96..176} 的小框里打转。t=210 起循环（li1 60→10、li0 60→20，各每轮 −10）：
    ---  · sub86：打一发速度 12 的大弹（0x40：20 帧内线性刹停、之后原地不动）。
    ---    方向——原作 angToPl 落在 (22.5°,157.5°) 之外（自机在画面左右两侧）时取
    ---    rand(0,22.5°)+78.8°（≈朝下），否则正对自机；
    ---  · 40 帧后把弹消掉、在**弹停住的位置**放一只仙狐（sub87）；
    ---  · 本体再朝 RAND_EXIT_ANGLE 的方向漂 li0 帧（速度 3.5）。
    ---仙狐（sub87）：不可打、无体判定的 12 号贴图点；3 拍（t=0/10/20）在
    ---|i|+|j| = 1/2/3 的方格壳的 4/8/12 个起点上各打一圈 8 发（速度 0.5，
    ---基准角 = 弹的朝向，色档 9/10/11）。
    do
        local NAME = "式神「仙狐思念」"
        ---仙狐的一拍：在 |i|+|j| = shell 的所有格点上各打一圈 8 发，拍间停 10 帧。
        ---每发除初速 0.5 外还挂 INIT_BULLET_CMD 0x10（spd 0.0166667、dur 120、loop −1、
        ---flags 0x212 里含 0x10）：沿出生朝向每帧加速 1/60，120 帧后速度涨到 0.5+2.0 = 2.5。
        local function shinko(self, a)
            for shell = 1, 3 do
                local col = col16(8 + shell)
                for i = -shell, shell do
                    for j = -shell, shell do
                        if abs(i) + abs(j) == shell then
                            local ox = (i * cos(a) + j * cos(a + 90)) * 32
                            local oy = (i * sin(a) + j * sin(a + 90)) * 32
                            local ox0, oy0 = self.x, self.y
                            self.x, self.y = ox0 + ox, oy0 + oy
                            for n = 0, 7 do
                                local th = a + n * 45
                                pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(6), col,
                                                        self.x, self.y, 0.5, th,
                                                        { type = 0x10, dur = 120, loop = -1,
                                                          vec_x = cos(th) * 0.0166667,
                                                          vec_y = sin(th) * 0.0166667 })
                            end
                            sound4(self)
                            self.x, self.y = ox0, oy0
                        end
                    end
                end
                task.Wait(10)
            end
        end
        spellcard(NAME, 3462, 60, 2600, false, function(self)
            self._box = { -128, 128, 96, 176 }
            ---进场：原作 t=0 的 MOVE_POS_TIME(120, ease4, 192, 96)（我们 (0,128)）。
            bmove(self, 120, 4, 0, 128)
            task.New(self, function()
                task.Wait(210)
                local li1, li0 = 60, 60
                while true do
                    ---sub86：一发速度 12 的大弹（0x40，20 帧刹停）。
                    local aim = Angle(self, player)
                    local th = -aim / RAD2DEG                 -- 原作 angToPl（弧度）
                    ---原作 #0 无条件先掷（RAND_FLOAT_ADD f2 0.392699 1.37445），#3 才按 A2P 覆盖。
                    local a = -(ran:Float(0, 0.392699) + 1.37445) * RAD2DEG
                    if th > 0.392699 and th < 2.74889 then a = aim end
                    local b = New(class["TH34_cmdbullet"], bs(10), col16(1),
                                  self.x, self.y, 12, a,
                                  { type = 0x40, dur = 20, loop = 1, angle = 0, speed = 0 })
                    pool4[#pool4 + 1] = b
                    sound4(self)
                    task.Wait(40)                     -- 原作 SUB_CALL 86 同步占 40 帧（弹飞到点后生仙狐）
                    local bx, by = b.x, b.y
                    if IsValid(b) then object.RawDel(b) end
                    pspawn(bx, by, shinko, a)
                    task.Wait(li1)
                    local d = exang(self)
                    bmove(self, li0, 4, self.x + cos(d) * li0 * 3.5, self.y + sin(d) * li0 * 3.5)
                    if li1 > 10 then li1 = li1 - 10 end
                    if li0 > 20 then li0 = li0 - 10 end
                    task.Wait(li0)
                end
            end)
        end)
    end

    ---────────── sc117 鬼神「飛翔毘沙門天」（原作 sub 61 + 周期 62 + 子机 63，55s） ──────────
    ---中 boss 的符卡：t=110 用 120 帧 ease-out 移到画面下方 (0,−160)，t=320 起绕 (0,0)、
    ---半径 160 的公转——8 段 MOVE_ORBIT 各 120 帧（角速度 ±1.5°/帧），「张开的大圆」与
    ---「收成一点」交替（半径速度 ∓1.33333/帧，120 帧正好走完 160）。同时 t=320 在
    ---(0,−160) 放一只式神子机（sub63）。本体自己的弹幕由周期回调 sub62（period=7，
    ---t=327 首次）负责：每 7 帧沿**当前公转切线方向**打一扇 7 发（半角 22.5°），
    ---速度 lf2 = rand(0,0.5)+lf1 ∈ [lf1, lf1+0.5)，lf1 从 0.8 起每次 +0.005。
    do
        local NAME = "鬼神「飛翔毘沙門天」"
        ---原作 sub61 的 8 段 MOVE_ORBIT（已取我们的口径：角度与角速度都取反，半径量不变）。
        local ORB = {
            { -1.5708, -0.0261799, 160,  0 },
            {  1.5708, -0.0261799, 160, -1.33333 },
            {  1.5708,  0.0261799,   0,  1.33333 },
            { -1.5708,  0.0261799, 160,  0 },
            {  1.5708,  0.0261799, 160,  0 },
            { -1.5708,  0.0261799, 160, -1.33333 },
            { -1.5708, -0.0261799,   0,  1.33333 },
            {  1.5708, -0.0261799, 160,  0 },
        }
        spellcard(NAME, 3461, 55, 1580, false, function(self)
            ---进场：原作 t=0 的 MOVE_POS_TIME(60, ease4, 64, 128)（我们 (−128,96)）。
            bmove(self, 60, 4, -128, 96)
            task.New(self, function()
                task.Wait(110)
                bmove(self, 120, 4, 0, -160)
            end)
            task.New(self, function()
                task.Wait(320)
                while true do
                    for _, o in ipairs(ORB) do
                        borbit(self, 0, 0, o[1], o[2], o[3], o[4])
                        task.Wait(120)
                    end
                end
            end)
            task.New(self, function()
                task.Wait(320)
                pspawn(0, -160, shiki)
            end)
            task.New(self, function()
                task.Wait(327)
                local lf1 = 0.8
                while true do
                    local lf2 = lf1 + ran:Float(0, 0.5)
                    gspread(self, bs(6), 6, 7, 1, lf2, 1, orbdir(self), 22.5, true)
                    lf1 = lf1 + 0.005
                    task.Wait(7)
                end
            end)
        end)
    end

    ---────────── sc116 鬼符「青鬼赤鬼」（原作 sub 58 + 59/60，55s） ──────────
    ---中 boss 的符卡：t=0 用 120 帧 ease-out 移到 TH07(192,64)（我们 (0,160)）。
    ---t=210 起「青鬼/赤鬼」成对交替：59、60、59、60 为一轮，发与发之间
    ---SET_WAIT_TIMER li0,li0,li0,li1（初值 40/180）；每轮 li0 −2（止于 20）、
    ---li1 −20（止于 60）⇒ 越来越密，形成一条左右横扫的弹链。
    ---两种鬼都是「先按初速直飞、60 帧内线性刹到 0、再拐 90° 以 4 速飞出」的一发弹
    ---（INIT_BULLET_CMD type 0x40 DirChangeAndResume，loop=1；TH07 的 ±π/2 取反成
    ---我们的 ∓90°）。原作 t=0 SET_BULLET_SOUND 0xffffffff ⇒ 全程无声。
    ---  · sub59（青鬼）：初角 TH07 rand(0,3.6°)−1.8°（≈0°，向右）、初速 rand[3.2,4.2)、色档 (10,1)；
    ---  · sub60（赤鬼）：初角 TH07 rand(0,3°)+178°（≈π，向左）、初速 rand[3.2,4.2)、色档 (10,0)。
    do
        local NAME = "鬼符「青鬼赤鬼」"
        ---一发「鬼弹」：a 是 TH07 初角（弧度）、dth 是 0x40 的角增量（我们的角度制）。
        local function oni(self, off, a, dth)
            local cmd = { type = 0x40, dur = 60, loop = 1, angle = dth, speed = 4 }
            pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(10), col16(off),
                                    self.x, self.y, ran:Float(3.2, 4.2), -a * RAD2DEG, cmd)
        end
        spellcard(NAME, 3460, 55, 2000, false, function(self)
            ---进场：原作 t=0 的 MOVE_POS_TIME(120, ease4, 192, 64)。
            bmove(self, 120, 4, 0, 160)
            task.New(self, function()
                task.Wait(210)
                local li0, li1 = 40, 180
                while true do
                    oni(self, 1, ran:Float(0, 0.0628319) - 0.0314159, -90)
                    task.Wait(li0)
                    oni(self, 0, ran:Float(0, 0.0523599) + 3.11018, 90)
                    task.Wait(li0)
                    oni(self, 1, ran:Float(0, 0.0628319) - 0.0314159, -90)
                    task.Wait(li0)
                    oni(self, 0, ran:Float(0, 0.0523599) + 3.11018, 90)
                    task.Wait(li1)
                    if li0 > 20 then li0 = li0 - 2 end
                    if li1 > 60 then li1 = li1 - 20 end
                end
            end)
        end)
    end

    ---────────── EX 非符 0..7（原作 sub 68/70/71/73/75/77/79/81） ──────────
    ---骨架与 PH 非符一致：小框里随机漂 + 每 gap 帧一组环。弹型统一 spr4（原作 EX 全是 4）。
    ---★ 全部是 RING_AIMED（op66）：0° 那一发指向自机，不是从 +x 起算。
    local function e69(self)
        shoot(self, 66, 4, 4, 32, 2, 2.2, 1, 0, 0, true)
        shoot(self, 66, 4, 3, 32, 1, 1.8, 1, rngrad(), 0, true)
    end
    local function e72(self)
        shoot(self, 66, 4, 8, 28, 2, 3.2, 1, 0, 0, true)
        shoot(self, 66, 4, 3, 28, 1, 1.8, 1, rngrad(), 0, true)
    end
    local function e74(self)
        shoot(self, 66, 4, 8, 52, 2, 3.2, 1, 0, 0, true)
    end
    local function e82(self)
        shoot(self, 66, 4, 10, 24, 2, 6, 1, 0, 0, true)
    end
    ---{ t0 = 160, ease = 0, box = … } 是 sub70 起七张共用的进场参数。
    local NE = { t0 = 160, ease = 0, box = { -128, 128, 96, 176 } }
    nonspell("EX 非符 1", 3480, 20000, 2600, 28, e69)
    nonspell("EX 非符 2", 3481, 20000, 2400, 18, e69, NE)
    nonspell("EX 非符 3", 3482, 20000, 2000, 24, e72, NE)
    nonspell("EX 非符 4", 3483, 20000, 2800, 60, e74, NE)
    ---sub76：两圈 8 发 ×2 层（速度 3 / 2.5），基准角从 0 起 +0.0698132 / −0.0981748。
    nonspell("EX 非符 5", 3484, 20000, 1400, 10, { make = function()
        local lf0, lf1 = 0, 0
        return function(self)
            shoot(self, 66, 4, 8, 8, 2, 3, 1, lf0, 0, true)
            lf0 = lf0 + 0.0698132
            shoot(self, 66, 4, 10, 8, 2, 2.5, 1, lf1, 0, true)
            lf1 = lf1 - 0.0981748
        end
    end }, NE)
    ---sub78：8 发 ×3 层（速度 3→1），基准角从 0 起每次 +0.0805537。
    nonspell("EX 非符 6", 3485, 20000, 2700, 10, { make = function()
        local lf0 = 0
        return function(self)
            shoot(self, 66, 4, 8, 8, 3, 3, 1, lf0, 0, true)
            lf0 = lf0 + 0.0805537
        end
    end }, NE)
    ---sub80：两圈 8 发 ×1 层（速度 4 / 0.8），lf0 每次 −0.0951998、lf1 每次 +0.1309。
    nonspell("EX 非符 7", 3486, 20000, 2700, 8, { make = function()
        local lf0, lf1 = 0, 0
        return function(self)
            shoot(self, 66, 4, 10, 8, 1, 4, 1, lf0, 0, true)
            lf0 = lf0 - 0.0951998
            shoot(self, 66, 4, 9, 8, 1, 0.8, 1, lf1, 0, true)
            lf1 = lf1 + 0.1309
        end
    end }, NE)
    ---原作 sub81 与 PH sub83 同构（同样 12 发 + 40 帧空档的 150 帧循环；只有最后一发的
    ---环数不同：sub82 是 24 发）。e82 即 sub82。
    nonspell("EX 非符 8", 3487, 20000, 3000, 10, e82, {
        t0 = 160, ease = 0, drift_t = 150, burst = { 12, 30 },
        box = { -128, 128, 96, 176 } })

    ---────────── EX 中 boss 的非符（原作 sub 55，life 13500 / 阈值 2000） ──────────
    ---与 PH 中 boss 同构：18 组 7 发 ×2 层瞄准扇（速度 4+0.214i）+ 16 组 8 发 ×3 层
    ---整圈（速度 2+0.1875i，基准角 ±3.75° 来回）。
    do
        local card = boss.card.New("", 1, 1, 60, hpB(13500 - 2000))
        card.before = skin
        card.init = function(self)
            pool4 = {}
            sound_tick4, sound_stamp4 = 0, -1
            enter(self)
            self._box = { -160, 160, 96, 176 }
            ---原作 sub56：18 组 7 发×2 层瞄准扇，每 2 帧一组（共 36 帧）——SUB_CALL 同步，
            ---母体在打完这 36 帧后才走 MOVE_DIR_TIME（所以这里直接 task.Wait，不并发）。
            ---扇心就是自机角（原作 SPREAD_AIMED，a1=0），所以 gspread 的 a1 传 +Angle；
            ---单条 SPREAD 关于扇心对称，a2 的正负只影响镜像、不影响弹幕集合，照原作取正。
            local function burst()
                for i = 0, 17 do
                    gspread(self, bs(6), 6, 7, 2, 4 + 0.214286 * i, 3.8,
                            Angle(self, player), (1.0472 - 0.0539793 * i) * RAD2DEG, true)
                    task.Wait(2)
                end
            end
            ---原作 sub57：16 组 8 发×3 层整圈 RING_ABS，每 3 帧一组（共 48 帧），同样同步。
            ---RING_ABS 的 a1 是 TH07 口径的 lf1（= i·gF0），翻到我们的角度制要取反。
            local function spiral(g)
                for i = 0, 15 do
                    gring(self, bs(2), 2, 8, 3, 2 + 0.1875 * i, 0.5, -g * i * RAD2DEG, 0, true)
                    task.Wait(3)
                end
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    burst(); exdrift(self, 1, 8); task.Wait(100)
                    burst(); exdrift(self, 2, 8); task.Wait(100)
                    spiral(0.0654498); exdrift(self, 1, 8); task.Wait(100)
                    spiral(-0.0654498); exdrift(self, 2, 4); task.Wait(60)
                end
            end)
        end
        card.frame = bframe
        card.del = function() end
        boss.card.add({ { card, "1a" } }, LEVEL, "EX 紫 非符 0", 3488)
    end
end

---════════════════════════════════════════════════════════════════════════
---以下：stage6（西行寺幽々子）与 stage5（魂魄妖夢）的符卡/非符移植。
---
---原作 sub 链（全部取 Lunatic 行；`ecldata6.ecl` / `ecldata5.ecl`）：
---  stage6: 非符1(19)→六道剣(23)→非符2(29)→亡郷(43)
---          →非符3(34) / 非符4(36)→亡舞(50)→華霊(52)
---          →非符5(38)→幽曲(55)→桜符(58)→「反魂蝶」(62，生存卡)
---  stage5: 非符1(38)→幽鬼剣(42)→非符2(48)→獄界剣(57)
---          →非符3(52)→修羅剣(62)→畜趣剣(66)
---          →人界剣(55/70)→天上剣(75)
---
---血量口径同本文件文件头（非符 hpB(life−收尾阈值)、符卡 hpS(开卡 life)）；
---坐标/角度换算也同文件头（x−192、224−y、θ 取反）。
---ECL 的 gI0/gI1/gF0.. 传给子程序后，子程序按 l3i0/l3i1/l3f0.. 读 —— 下面注释里
---出现「l3i0 = 调用方 gI0」这类说明时就是指这个。
---
---卡 id 段：4390..4410。已扫全项目 `boss.card.add` 末参与 `th31.lua` 的 LIST 第 3 项，
---4390..4419 无任何引用。
---════════════════════════════════════════════════════════════════════════
local function TH34_add_stage56_boss()
    local LEVEL = 32
    local RAD = 180 / PI
    local ball_small, grain_a, arrow_small = ball_small, grain_a, arrow_small

    ---TH07 弹型（sprite）→ 本仓库代理（同 78 面那张表）。
    local BS = { [0] = ball_small, [1] = grain_a, [2] = grain_a, [3] = ball_small,
                 [4] = ball_small, [5] = ball_small, [6] = ball_small, [7] = arrow_small,
                 [8] = ball_small, [9] = arrow_small, [10] = grain_a }
    local function bs(spr) return BS[spr] or grain_a end
    local function hpB(x) return max(1, int(x * 0.09825 + 0.5)) end
    local function hpS(x) return max(1, int(x * 0.6878 + 0.5)) end
    local function rngrad() return ran:Float(-PI, PI) end
    ---自机方向，TH07 口径的弧度（y 朝下）。
    local function aimth(self) return -Angle(self, player) * PI / 180 end

    local function bmove(self, t, ease, x, y)
        self._mv = { t = max(1, t), n = 0, x0 = self.x, y0 = self.y,
                     dx = x - self.x, dy = y - self.y, ease = ease }
    end
    local function bstep(self)
        local m = self._mv
        if not m then return end
        m.n = m.n + 1
        local u = min(1, m.n / m.t)
        local e = u
        if m.ease == 4 then e = 1 - (1 - u) * (1 - u)
        elseif m.ease == 1 then e = u * u
        elseif m.ease == 2 then e = u * u * u
        elseif m.ease == 3 then e = u * u * u * u
        elseif m.ease == 5 then local v = 1 - u; e = 1 - v * v * v
        elseif m.ease == 6 then local v = 1 - u; e = 1 - v * v * v * v end
        self.x, self.y = m.x0 + m.dx * e, m.y0 + m.dy * e
        if m.n >= m.t then self._mv = nil end
    end
    local function bframe(self)
        sound_tick4 = sound_tick4 + 1
        bstep(self)
        local b = self._box
        if b then
            self.x = min(max(self.x, b[1]), b[2])
            self.y = min(max(self.y, b[3]), b[4])
        end
    end
    ---原作 `GET_EXIT_ANGLE`（EclManager.cpp:1592-1638）。返回值是**我们口径**的
    ---角度（度）：th07 的 `exitAngle` 取反即我们这边绕行方向。
    ---th07 抽的是 rand(0,π/2) 的 ±45°/±135° 扇区，再按上下左右限位折返四次。
    ---`self.angle`（`enemy->angle`）本文件只在极坐标移动里才会变，这里不追；
    ---只在「贴右壁」那一支用到它，而它此时恒为 0（同原作 sub29 的移动方式）。
    local function exang(self)
        local a
        if player.x < self.x then
            a = ran:Float(135, 225)                 -- rand(0,π/2) + 3π/4
            ---★ 原作这一支外面套了 `AddNormalizeAngle(·,0)`（EclManager.cpp:1592）：
            ---抽到的角先归一化到 (−180,180] 再进下面的限位折返。漏掉归一化时
            ---a∈(180,225] 会带着 +180 的余量去比限位，折返结果与原作差 180°
            ---（整段漂移的 y 方向反掉）。
            if a > 180 then a = a - 360 end
        else
            a = ran:Float(-45, 45)                  -- rand(0,π/2) − π/4
        end
        local bx2, by2 = self._box and self._box[2], self._box and self._box[4]
        local bx1, by1 = self._box and self._box[1], self._box and self._box[3]
        if bx1 then
            if self.x < bx1 + 96 then
                if a > 90 then a = 180 - a
                elseif a < -90 then a = -180 - a end
            end
            if bx2 - 96 < self.x then
                if a >= 0 and a < 90 then a = 180 - (self.angle or 0)
                elseif a <= 0 and a > -90 then a = -180 - a end
            end
            ---y 限位在我们这边是翻过号的：th07 的 (下界+48, 上界−48) 折返，
            ---对应我们坐标里的 (box[4]−48, box[3]+48)（box[3] 是 y 上界）。
            if by2 - 48 < self.y and a < 0 then a = -a end
            if self.y < by1 + 48 and a > 0 then a = -a end
        end
        return -a
    end
    local function exdrift(self, spd, ease)
        local a = exang(self)
        bmove(self, 60, ease or 4, self.x + cos(a) * 60 * spd, self.y + sin(a) * 60 * spd)
    end
    ---同上，但可以指定帧数（原作 non-60 的 MOVE_DIR_TIME，位移 = spd×t）。
    local function drift(self, spd, t, ease)
        t = t or 60
        local a = exang(self)
        bmove(self, t, ease or 4, self.x + cos(a) * t * spd, self.y + sin(a) * t * spd)
    end

    ---本体的 ORBR / ORBAV 排程（原作 sub50 / sub52 的 `INIT_INTERP`）：
    ---ORBR 用 ease-out-quad（ECL type 4）、ORBAV 线性（type 0），走满 dur 帧后解绑
    ---（EclManager.cpp:1069 建、2173 每帧推进）。
    local function kyorbit(self)
        local interps = {}
        self._kR, self._kW = 0, 0
        return function(field, dur, to, ease)
                   interps[#interps + 1] = { f = field, a = self[field], b = to,
                                             dur = dur, t = 0, ease = ease }
               end,
               function(n)
                   for _ = 1, n do
                       for i = #interps, 1, -1 do
                           local it = interps[i]
                           it.t = min(it.t + 1, it.dur)
                           local u = it.t / it.dur
                           if it.ease == 4 then u = 1 - (1 - u) * (1 - u) end
                           self[it.f] = it.a + (it.b - it.a) * u
                           if it.t >= it.dur then table.remove(interps, i) end
                       end
                       task.Wait(1)
                   end
               end
    end

    ---自机到 boss 的距离（原作 $10026 distToPl）。
    local function pdist(self)
        return sqrt((self.x - player.x) ^ 2 + (self.y - player.y) ^ 2)
    end
    ---SET_MOVEMENT_BOUNDS（TH07 口径）→ 我们的 {xmin,xmax,ymin,ymax}（前向声明）。
    local box5

    ---op64..67 的通用发弹（语义 = BulletManager::SpawnBulletPattern）。
    local function shoot(self, op, spr, off, c1, c2, v1, v2, a1, a2, plays)
        local style = bs(spr)
        if op == 64 or op == 65 then
            w3_spread(self, style, off, c1, c2, v1, v2, a1, a2, op == 64, plays)
        elseif op == 66 or op == 67 then
            w3_ring(self, style, off, c1, c2, v1, v2, a1, a2, op == 66, plays)
        end
    end
    ---同上，但从 boss 的相对偏移 (ox, oy) 处发（原作 SET_SHOOT_OFFSET）。
    ---oy 用我们的口径（+y 朝上），调用方负责把 TH07 的偏移换算过来。
    local function shoot_at(self, ox, oy, op, spr, off, c1, c2, v1, v2, a1, a2, plays)
        local sx, sy = self.x, self.y
        self.x, self.y = sx + ox, sy + oy
        shoot(self, op, spr, off, c1, c2, v1, v2, a1, a2, plays)
        self.x, self.y = sx, sy
    end

    ---立绘 / 进场。
    local function setface(self, img)
        if self._wisys then self._wisys:SetImageInList(img) end
    end
    local function skin6(self)
        self.NotPlayTimeOutSound = false
        self.colli = true
        self.no_hp_render = false
        setface(self, "Yuyuko")
    end
    local function skin5(self)
        self.NotPlayTimeOutSound = false
        self.colli = true
        self.no_hp_render = false
        setface(self, "Youmu")
    end
    local function skin6_wall(self)
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
        setface(self, "Yuyuko")
    end
    local function skin5_wall(self)
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
        setface(self, "Youmu")
    end
    ---原作 sub18：幽幽子从左外进场，落到 (192,128)（我们 (0,96)）。
    local function enter6(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = -224, 192
        bmove(self, 60, 4, 0, 96)
    end
    ---原作 sub37：妖夢从下方升起，落到 (192,112)（我们 (0,112)）。
    local function enter5(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 256
        bmove(self, 60, 4, 0, 112)
    end

    ---符卡登记的子机（卡片结束时统一清场）；fn(self, a) 是协程体。
    local spell_live
    local PSCRIPT = Class(enemy, {
        init = function(self, x, y, fn, a)
            enemy.init(self, 12, 1, false, true, true)
            self.x, self.y = x, y
            ---★ 原作这些「会飞出屏幕的发射体」（sub62 炮台、sub126 幽灵、sub130 音符串…）
            ---都带 `SET_HAS_NO_COLLISION 1`。TH07 的 OOB 回收要求 `hasNoCollision == 0`
            ---（EnemyManager.cpp:700-722），所以它们**飞出屏外也不会被回收**、照常发弹。
            ---LuaSTG 的 `enemy.auto_delete`（THlib/enemy/enemy.lua:211）却把它绑到
            ---`world.bound` 上直接回收 ⇒ 子机一飞出边界就停摆（`bstep` 不再被调用，
            ---`bmove` 停在半路）。关掉自动回收，改由脚本自己 RawDel。
            self.auto_delete, self.bound = false, false
            self.colli, self.protect = false, true
            self.A, self.B = 8, 8
            task.New(self, function()
                fn(self, a)
                object.RawDel(self)
            end)
        end,
        ---子机自己的协程挂在**子机**名下；THlib 的 task 表在对象上，对象一删协程就没了。
        ---桩件的对象表不清 task，所以要显式清一次，否则「卡片结束时轮子/魂还在打」
        ---会被泄漏扫描判成 FAIL（id=4408 的轮子、4410 的魂）。
        del = function(self) task.Clear(self) end,
        ---子机的自绘运动（`bmove`/`bstep`）没有别的地方驱动：挂在 boss 上的卡有
        ---`card.frame`，子机没有。不补这一帧钩子 `bmove` 永远不动（原作 sub76 的
        ---魂是 `MOVE_DIR_TIME t=0 spd=4.2` 的匀速直线，必须真的走）。
        frame = function(self)
            bstep(self)
            enemy.frame(self)
        end,
        render = function() end,
    })
    local function pspawn(x, y, fn, a)
        local o = New(PSCRIPT, x, y, fn, a)
        if spell_live then spell_live[#spell_live + 1] = o end
        return o
    end

    ---开卡免伤时长（原作 t=0..120 SET_CAN_BE_DAMAGED 0 + 240 帧 ÷9）。
    local CARD_FREEZE_DEFAULT = 5.555556
    local CARD_FREEZE = {}

    ---非符骨架：initfn(self) 自己起协程逐帧演。
    local function ncard(name, id, life, thr, initfn, opt)
        opt = opt or {}
        local live = {}
        local card = boss.card.New("", 1, 1, 60, hpB(life - thr))
        card.before = opt.skin or skin6
        card.init = function(self)
            pool4 = {}
            sound_tick4, sound_stamp4 = 0, -1
            ---非符也会用 `pspawn` 放子机（stage1/2 的「冰桌」「凤凰火」等）：
            ---和符卡一样登记，卡片结束时统一清场，否则子机协程会活过卡尾继续发弹。
            live = {}
            spell_live = live
            local go = opt.enter or enter6
            go(self)
            initfn(self)
        end
        card.frame = bframe
        card.del = function()
            for i = #live, 1, -1 do
                if IsValid(live[i]) then object.RawDel(live[i]) end
            end
            live = {}
            spell_live = nil
        end
        boss.card.add({ { card, "1a" } }, LEVEL, name, id)
    end

    ---符卡骨架（wall=true ⇒ 生存/耐久卡，血量极大、关判定）。
    local function scard(name, id, t3, life, wall, initfn, opt)
        opt = opt or {}
        local live = {}
        local freeze = wall and t3 or (CARD_FREEZE[id] or CARD_FREEZE_DEFAULT)
        local card = boss.card.New(name, freeze, freeze, t3,
                                   wall and 10000000 or hpS(life))
        card.before = wall and (opt.wallskin or skin6_wall) or (opt.skin or skin6)
        card.init = function(self)
            pool4 = {}
            sound_tick4, sound_stamp4 = 0, -1
            live = {}
            spell_live = live
            local go = opt.enter or enter6
            go(self)
            initfn(self)
        end
        card.frame = bframe
        card.del = function()
            for i = #live, 1, -1 do
                if IsValid(live[i]) then object.RawDel(live[i]) end
            end
            live = {}
            spell_live = nil
        end
        boss.card.add({ { card, "1a" } }, LEVEL, name, id)
    end


    ---──────────────────── 通用：带 INIT_BULLET_CMD 的发弹 ────────────────────
    ---op64..69 的角度语义与第 3 面的 w3_spread/w3_ring 完全一致（同一套「TH07 角取反」
    ---推导），这里补两样原作里很关键、w3_* 没有的东西：
    ---  · (ox, oy)——炸开位置相对 boss 的偏移（**我们的坐标**，y 已翻转过）；
    ---  · cmd——INIT_BULLET_CMD 的指令串，交给 class["TH34_cmdbullet"] 逐帧模拟。
    local function shoot6(self, ox, oy, op, spr, off, c1, c2, v1, v2, a1_th, a2_th, cmd, plays)
        local style, col = bs(spr), col16(off)
        local total, room, i = c1 * c2, POOL4_SIZE - pool4_used(), 1
        if _G.__DBG4 then print('ROOM4\t'..tostring(_G.__frame)..'\t'..tostring(total)..'\t'..tostring(room)) end
        ---SPREAD_AIMED / RING_AIMED 的瞄准角取的是**出膛点**（原作
        ---`AngleToPlayer(&bulletProps->pos)`，而 `pos = enemy->pos + shootOffset`；
        ---BulletManager.cpp:643）。偏移为 0 时与自机到本体中心等价，偏移大时差很多。
        local aim = 0
        if op == 64 or op == 66 or op == 68 then
            aim = atan2(player.y - (self.y + oy), player.x - (self.x + ox)) * RAD2DEG
        end
        local made = {}                    -- 本波新建的弹（蝶弹要登记，见 sub52 的 bd 表）
        while i <= total and room > 0 do
            local k = i - 1
            local layer, ring = int(k / c1), k % c1
            local v = v1 - (v1 - v2) * layer / c2
            local a
            if op == 64 or op == 65 then
                local base = ((op == 64) and aim or 0) - a1_th * RAD2DEG
                a = base + spread_offsets(c1, -a2_th * RAD2DEG)[ring + 1]
            else
                local base = ((op == 66 or op == 68) and aim or 0) - a1_th * RAD2DEG
                a = base + ring * (360 / c1)
                if op == 66 or op == 67 then a = a - a2_th * RAD2DEG * layer
                else a = a + 180 / c1 end
            end
            local o
            if cmd then
                o = New(class["TH34_cmdbullet"], style, col,
                        self.x + ox, self.y + oy, v, a, cmd)
            else
                o = NewSimpleBullet(style, col, self.x + ox, self.y + oy,
                                    v, a, false, 0, false)
            end
            pool4[#pool4 + 1] = o
            made[#made + 1] = o
            room, i = room - 1, i + 1
        end
        if plays then sound4(self) end
        return made
    end
    ---同上，但 (ax, ay) 是**绝对**坐标（原作 SET_SHOOT_OFFSET x=目标x−posX 的绝对定位用法）。
    local function shoot_abs6(self, ax, ay, op, spr, off, c1, c2, v1, v2, a1_th, a2_th, cmd, plays)
        shoot6(self, ax - self.x, ay - self.y, op, spr, off, c1, c2, v1, v2, a1_th, a2_th, cmd, plays)
    end
    ---VEC_FROM_ANGLE_MAG：TH07 的 (mag·cosθ, mag·sinθ) 翻到我们这边 = (mag·cosθ, −mag·sinθ)。
    local function voff(ang, mag) return mag * math.cos(ang), -mag * math.sin(ang) end

    ---INIT_BULLET_CMD 0x20 TargetAngle（`BulletManager.cpp:759-777`）：每帧
    ---angle += cmd.angle、speed += cmd.speed，够 duration 帧清位。传 TH07 弧度/帧 ⇒ 取反并转度。
    ---`loop=-1` 的原作靠 0x2000 的 spawnDelay 与 flag 位反复重置，这里直接做成常驻。
    local function spin6(rate_th, dec, dur)
        return { type = 0x20, dur = dur or 30, loop = -1,
                 speed = -(dec or 0), angle = -rate_th * RAD2DEG }
    end
    ---INIT_BULLET_CMD 0x10 TargetVelocity：把（当前朝向, cmd.speed）冻成向量，之后每帧
    ---velocity += 该向量（速度过零后自己反过来）。spd 传 TH07 的 px/帧²。
    local function accel6(spd, dur)
        return { type = 0x10, dur = dur or 80, loop = -1, speed = 0, angle = -999,
                 accel = spd }
    end
    ---INIT_BULLET_CMD 0x80 DirChangeAimAtPlayer：先沿当前朝向把速度线性减到 0，
    ---dur 帧后朝向 = 自机方向（+cmd.angle）、速度 = cmd.speed，重复 loop 次。
    ---（ZUN 交换：state.angle 取 ECL 的 spd、state.speed 取 ECL 的 ang。）
    local function brake_aim6(dur, ang_th, spd, loop)
        return { type = 0x80, dur = dur or 60, loop = loop or 1,
                 angle = -ang_th * RAD2DEG, speed = spd }
    end
    ---INIT_BULLET_CMD 0x80/0x64 一族在 ECL 里就写成「沿当前朝向减速再转向」，
    ---幽々子非符 5/6 面几张卡都用它把慢弹「停住再慢慢飘向自机」。
    local function stop_then_aim(spd, dur)
        return { type = 0x80, dur = dur or 60, loop = 1, angle = 0, speed = spd }
    end

    ---BEGIN_SPELLCARD 的计时（t=480 起算 th 帧）= 本框架 t3（秒）的换算基准：
    ---原作 t3 一律取 SET_TIMER_CALLBACK_THRESHOLD/60（见各卡注释）。
    ---──────────────────── 幽々子 非符 1（原作 sub19/20/21/22） ────────────────────
    ---sub19（全局一行）：t=60 设限位框、gF0=112 / gI0=8 / gI1=13 → SUB_CALL 20（螺旋），
    ---此后按「调用方时间」排布（SUB_CALL 冻结调用方时间轴，故实际墙钟 = 调用方时间 + 子程帧数）：
    ---  t=160 漂移 60 帧（1.5）→ t=220 再 SUB_CALL 20（gF0=96 / gI0=11 / gI1=14）→
    ---  t=310 漂移 60 帧（1.5）→ t=370/420/450/460 依次 SUB_CALL 21 / 22 / 21 / 22，
    ---  各自后面接 50 / 30 / 10 / 60 帧、速度 2.5 / 2.5 / 2.5 / 1.5 的漂移；t=560 JUMP 回 #18。
    ---sub20（螺旋）：半径 l3f0（= 调用方 gF0）从满半径每拍收 1/16，同时以 R*sin(相位) 的
    ---垂直摆动打整圈；每拍 t=0 与 t=5 各一圈（颜色 l3i0 / l3i1 = gI0 / gI1），圈数 li0 从 1 起
    ---每拍 +5、24 封顶，共 16 拍（160 帧、32 圈）。
    ---sub21/22（左右屏外齐射）：x = rand(0,32) + 368（右）/ −16（左），y = rand(0,128) − 64，
    ---每 2 帧一发、共 16 发：x 每次 −24、y 每次 −(y0/8)；SPREAD_AIMED c1=1 / c2=2、
    ---速度 5→1、瞄准自机；右用 spr6/col6/张角 π/8，左用 spr6/col2/张角 π/6。
    ncard("幽々子 非符 1", 4390, 15000, 1500, function(self)
      task.New(self, function()
        local function spiral(radius, colA, colB)
            local a1 = aimth(self)
            local ca, sa = math.cos(a1), math.sin(a1)
            local pa = -sa
            local r, dr, ph, c1 = radius, radius / 16, 0, 1
            for _ = 1, 16 do
                for step = 0, 1 do
                    local ox, oy = r * ca, r * sa
                    r = r - dr
                    local wob = math.sin(ph) * radius
                    if step == 1 then wob = -wob end
                    ph = ph + 0.0981748
                    shoot6(self, ox + wob * pa, -(oy + wob * ca), 67, 3,
                           (step == 0) and colA or colB, c1, 1, 2, 1, a1, 0.261799, nil, true)
                    task.Wait(5)
                end
                if c1 < 24 then c1 = c1 + 5 end
            end
        end
        local function shotgun(right)
            ---原作 sub21（右）/sub22（左）：t=0 先 SUB_CALL 2（gi0=4 → 16 帧阻塞），
            ---之后每 2 帧一发、共 16 发（自机狙 SPREAD_AIMED）；L 行 c1×c2 = 右 1×4 /
            ---左 2×4；打完 t=2 的空跳 + t=3 的 SUB_RET ⇒ 子程墙钟 49 帧。
            local x0 = ran:Float(0, 32) + (right and 368 or -16)
            local y0 = ran:Float(0, 128) - 64
            local dy = y0 / 8
            task.Wait(16)
            for _ = 1, 16 do
                shoot_abs6(self, x0 - 192, self.y - y0, 64, 6, right and 6 or 2,
                           right and 1 or 2, 4, 5, 1, 0,
                           right and 0.392699 or 0.523599, nil, true)
                x0 = x0 + (right and -24 or 24)
                y0 = y0 - dy
                task.Wait(2)
            end
            task.Wait(1)
        end
        task.Wait(60)
        while true do
            spiral(112, 8, 13)
            task.Wait(100)
            drift(self, 1.5, 60); task.Wait(60)
            spiral(96, 11, 14)
            task.Wait(90)
            drift(self, 1.5, 60); task.Wait(60)
            shotgun(true);  drift(self, 2.5, 50); task.Wait(50)
            shotgun(false); drift(self, 2.5, 30); task.Wait(30)
            shotgun(true);  drift(self, 2.5, 10); task.Wait(10)
            shotgun(false); drift(self, 1.5, 60); task.Wait(100)
        end
      end)
    end)

    ---──────────────────── 符卡 六道剣「一念無量劫 -Lunatic-」（原作 sub23/24/25） ────────────────────
    ---原作 sub23（顶层）：
    ---  · t=0 起 MOVE_POS_TIME(120,4,192,180)——本体由当前所在直线飘到 (192,180)，
    ---    我们落到 (0,44)；同帧 SET_MOVEMENT_BOUNDS(64,48,320,256)。
    ---  · t=480 装 timerCallback 子程 27（本体计时 2400 帧后 END_SPELLCARD + 撤场）
    ---    并 SET_ANM 128，随即进入「四波」死循环（四波走完 JUMP 回 t=480）。
    ---每波把 gf0 = 角步、gi0 = 子机数写进全局，再 SUB_CALL 24。★ 原作引擎在
    ---SUB_CALL 时会把 g_GlobalEclVars 拷进被调子程的上下文（EclManager.cpp:1174
    ---`eclContextArgs.globalVars = g_GlobalEclVars`），所以子程里读到的 i3_0/f3_0
    ---**就是**调用方刚写的 gi0/gf0（差异 22）。
    ---  · sub24：先 gi0=4、gi1=12，再 SUB_CALL 2（4 次 × 4 帧 = 16 帧粒子阻塞）；
    ---    t=50 起以 3 帧间隔生成 gi0 只 sub25「壁」——
    ---      壁位置 = 本体 + (cos f5, sin f5)·112，f5 从 0 起每只 += gf0；
    ---      壁的开火角 f4 = f5 + π/2（切向）。
    ---    t=155 SUB_RET。子机在墙钟 16+50+3k = 66+3k 帧出生；子程总长 168+3n 帧。
    ---  · sub25「壁」：不可打（SET_IS_HITTABLE 0 / SET_HAS_CONTACT_HITBOX 0 /
    ---    SET_CAN_BE_DAMAGED 0）、判定框 384×32、SET_DEATH_ANM(0,3,0)。t=60 起每 3 帧
    ---    打一发 SPREAD_ABS（spr6/色档4、角 = f4、张角 0.392699、L 行 4 发、速度 1.8），
    ---    共 14 发；DEC_JUMP 落空后游标停在 t=73 的 UNIMP，等 ctx.time 爬到 73 才执行
    ---    ⇒ 壁在 t=112 自毁（vm 实测）。
    ---    SET_SHOOT_OFFSET(f4, f5)：出膛点 = 壁位置 + (f4, f5) 像素；f4/f5 被下面的两条
    ---    INIT_INTERP 从 0 扫到 ±128 ⇒ 出膛点沿「壁的长轴」扫过 256px（不是常量！）。
    ---四波（角步 / 子机数）：45°/8、−45°/8、54°/12、−77.14°/16，循环往复。
    ---壁的每发弹 = 4 发绝对扇（绝对角 f4、张角 22.5°、速度 1.8）。
    ---TH07 `AddNormalizeAngle`（Global.cpp:946）：加完再折进 (−π, π]。
    ---sub24 每生成一只都对 f4/f5 各折一次；不折的话 SET_SHOOT_OFFSET(f4,f5)
    ---会把「绕出去的 2π 整数倍」也算进像素偏移，出膛点整片错位。
    local function norms6(a) return math.atan2(math.sin(a), math.cos(a)) end
    ---「壁」（原作 sub25）。a = { f4, f5 }——生成瞬间 sub24 上下文里的两个角（TH07 弧度）。
    ---★ 原作 t=60 起建两条 `INIT_INTERP`（fn 7 = MathCubicInterp、42 帧、easing 0、
    ---  两端切线 m0=m1=RAND_SIGN_FLOAT(0)=±0），把 f4/f5 从「生成时的角」一路插到
    ---  「该角的 128 倍取负」（sub25 idx14..19/22/25）：
    ---    f0=cos(f4)·128、f1=sin(f4)·128、f2=0−f0、f3=0−f1
    ---    interp1: dst=f4, p0=f0, p1=f2 ; interp2: dst=f5, p0=f1, p1=f3
    ---  h00+h01=1 且切线为 0 ⇒ 值 = K·(h00−h01) = K·(1−2·t²(3−2t))，K = 128·cos/sin(f4)。
    ---  这两条插值同时决定了**出膛点**（SET_SHOOT_OFFSET f4 f5）与**开火角**（angle1=*f4）：
    ---  f4/f5 在 0..±128 之间横扫 ⇒ 子弹沿壁的长轴扫出一串，且每发朝向 f4（弧度、模 2π）。
    ---  ★ 旧实现把 f4/f5 当常量（既不出膛点扫、朝向也不变），与原作完全不是一回事。
    ---  时序：t=60 当帧先按**原值**打第 1 发（插值同帧才建、帧末才推进），之后每 3 帧一发，
    ---        第 j 发读到的是 timer=3(j−1) 处的插值（t = 3(j−1)/42）。
    ---  计数：i2_0=14 ⇒ 共 14 发（末发在 t=99）；DEC_JUMP 落空后游标停在 t=73 的 UNIMP，
    ---        等 ctx.time 爬到 73 才执行 ⇒ 壁在 t=112 自毁（用 vm 实测）。
    local function six_wall(self, a)
      local f4, f5 = a[1], a[2]
      task.Wait(60)                    ---sub25 的 t=60 开打
      ---★ 原作 sub25 #20/#21/#23/#24：建两条 INIT_INTERP 之前各有两发
      ---  `RAND_SIGN_FLOAT *f6 0`（幅值 0 ⇒ 结果恒 0，切线 m0/m1 全 0），
      ---  但这 4 次抽样是真实消耗的，必须照抽，否则后续随机流整段错位。
      local _s1, _s2, _s3, _s4 = ran:Sign(), ran:Sign(), ran:Sign(), ran:Sign()
      local k4, k5 = 128 * math.cos(f4), 128 * math.sin(f4)
      local function val(u, k) return k * (1 - 2 * (u * u * (3 - 2 * u))) end
      local f4t, f5t = f4, f5          ---第 1 发用生成时的原值
      for j = 1, 14 do
        ---弹从壁位置 + (f4, −f5) 出膛（TH07 → 我们：y 取反），角 = f4（取反成我们口径）。
        shoot6(self, f4t, -f5t, 65, 6, 4, 4, 1, 1.8, 1, f4t, 0.3926990926265717, nil, true)
        local u = (3 * j) / 42
        f4t, f5t = val(u, k4), val(u, k5)
        if j < 14 then task.Wait(3) end  ---每拍间隔 3 帧；打满 14 发
      end
      task.Wait(13)                    ---原作壁活到 t=112（末发 t=99 后又等 ~13 帧才撞 UNIMP）
    end
    scard("六道剣「一念無量劫 -Lunatic-」", 4391, 40, 1500, false, function(self)
      task.New(self, function()
        task.Wait(120)                     ---MOVE_POS_TIME(120,4,192,180) 的进场
        local waves = { { 0.7853981852531433, 8 }, { -0.7853981852531433, 8 },
                           { 0.942477822303772, 12 }, { -1.346396803855896, 16 } }
        while true do
            for _, w in ipairs(waves) do
                local step, n = w[1], w[2]
                task.Wait(16)                      ---sub24：SUB_CALL 2 的 4×4 帧
                task.Wait(50)                      ---到 sub24 的 t=50
                local f5, f4 = 0, 1.5707963705062866   ---f32(π/2)
                for _ = 1, n do
                    local wx, wy = voff(f5, 112)
                    pspawn(self.x + wx, self.y + wy, six_wall, { f4, f5 })
                    f5 = norms6(f5 + step)         ---原作 NORMALIZE_ANGLE f5
                    f4 = norms6(f4 + step)         ---原作 NORMALIZE_ANGLE f4
                    task.Wait(3)                   ---sub24 的 DEC_JUMP：每只 3 帧
                end
                task.Wait(102)                     ---到 sub24 的 t=155：66+3n + 102 = 168+3n
            end
        end
      end)
    end, { enter = function(self)
      ---原作 SET_MOVEMENT_BOUNDS(64,48,320,256) → 我们 (−128,−32)…(128,176)。
      self._box = { -128, 128, -32, 176 }
      bmove(self, 120, 4, 0, 44)               ---MOVE_POS_TIME(120,4,192,180)
    end })

    ---──────────────────── 幽々子 非符 2（原作 sub29/30/31/32/33） ────────────────────
    ---两条反向自转的螺旋臂：从自机角 ±90° 的偏移点（半径 32/64 或 64/16 或 24/96）
    ---打「扇 + 环」，每 4 帧一拍；自机会在 64px 内时额外补一圈 16 发。
    ---速度基准 = 2.1/3.0 + 0.2×(第几轮)，每轮 l2i3 递增。
    ncard("幽々子 非符 2", 4392, 21000, 2100, function(self)
      task.New(self, function()
        ---原作 sub29 的时间轴（L 行）：
        ---  t=60 SUB_CALL 30（15 拍）→ t=160 MOVE_DIR_TIME(1.5)＋SUB_CALL 31（15 拍）
        ---  → t=260 MOVE_DIR_TIME(1.5)＋`gi0=8 gi1=12`＋SUB_CALL 2（8×4=32 帧）
        ---    ＋SUB_CALL 33 / 32 / 33 / 32（各 30 拍）→ t=360 MOVE_DIR_TIME(1.5)＋INC i2_3
        ---  → t=460 JUMP 回 t=60。parent time 在子程调用期间冻结，所以每段之间还要补
        ---    100 帧才到下一个 time 值（墙钟 = 子程时长 + 100）。
        ---  · sub30..33 都是「一拍 4 帧：t=0 从 VEC(f0,magA) 打一扇 SPREAD_ABS（16 发），
        ---    t=2 从另一个偏移打第二扇（贴图 7:6 / 7:4，5–6 发），自机距离 DIST<64 时
        ---    再补第三扇（offset 回 0）」。f0=A2P−π/2、f1=A2P+π/2，每拍 f0+=0.20944、
        ---    f1−=0.20944；速度 = i2_3×0.2 + base（i2_3 每轮 +1）。
        ---  · 四个子程只在「偏移/角度/贴图/条数/速度基准/减速」上不同：
        ---      sub30: v1 off=f0·32 spr2:8 16发 a1=f1 a2=0.1848；v2 off=f1·64 spr7:6 6发
        ---             a1=f1 a2=0.314159；v3 RING 2:2×16；base 2.1 dec 0.5
        ---      sub31: v1 off=f0·32 spr2:13；v2 off=f1·16 spr7:4 a1=f0；base 3.0 dec 0.5
        ---      sub32: v1 off=f0·64 spr2:8 a1=f0−π/2 a2=0.19635；v2 off=f0·16 spr7:6 5发
        ---             a1=f1+π/2；v3 RING 3:2×16；base 3.0 dec 0.3
        ---      sub33: v1 off=f0·24 spr2:13 a1=f1+π/2 a2=0.19635；v2 off=f0·96 spr7:4 5发
        ---             a1=f0−π/2；v3 SPREAD_AIMED 2:2×7（自机狙）；base 2.4 dec 0.1
        local cyc = 0
        local function arm(sp)
            local a = aimth(self)
            local f0, f1 = a - 1.5708, a + 1.5708
            local v1 = cyc * 0.2 + sp.base
            local v2 = v1 - sp.dec
            local function ref(r, x0, x1)
                return (r.f == 1) and (x1 + (r.d or 0)) or (x0 + (r.d or 0))
            end
            for _ = 1, sp.iter do
                local ox, oy = voff(ref(sp.o1, f0, f1), sp.m1)
                shoot6(self, ox, oy, sp.op1, sp.s1, sp.off1, sp.c1, 1, v1, 1,
                       ref(sp.a1, f0, f1), sp.a2_1, nil, true)
                task.Wait(2)
                ox, oy = voff(ref(sp.o2, f0, f1), sp.m2)
                shoot6(self, ox, oy, sp.op2, sp.s2, sp.off2, sp.c2, 1, v2, 1,
                       ref(sp.a2, f0, f1), sp.a2_2, nil, true)
                if pdist(self) < 64 then
                    shoot6(self, 0, 0, sp.op3, sp.s3, sp.off3, sp.c3, 1, 4, 1,
                           rngrad(), 0.0392699, nil, true)
                end
                f0, f1 = f0 + 0.20944, f1 - 0.20944
                task.Wait(2)
            end
        end
        local S30 = { iter = 15, base = 2.1, dec = 0.5,
                      o1 = {f = 0}, m1 = 32, s1 = 2,  off1 = 8,  c1 = 16,
                      a1 = {f = 1}, a2_1 = 0.1848, op1 = 65,
                      o2 = {f = 1}, m2 = 64, s2 = 7,  off2 = 6,  c2 = 6,
                      a2 = {f = 1}, a2_2 = 0.314159, op2 = 67,
                      op3 = 67, s3 = 2, off3 = 2, c3 = 16 }
        local S31 = { iter = 15, base = 3.0, dec = 0.5,
                      o1 = {f = 0}, m1 = 32, s1 = 2,  off1 = 13, c1 = 16,
                      a1 = {f = 1}, a2_1 = 0.1848, op1 = 65,
                      o2 = {f = 1}, m2 = 16, s2 = 7,  off2 = 4,  c2 = 6,
                      a2 = {f = 0}, a2_2 = 0.314159, op2 = 67,
                      op3 = 67, s3 = 2, off3 = 2, c3 = 16 }
        ---sub32 的 i0 有第二条 `SET_INT *i0 8`（skip=ff，覆盖难度行）⇒ 首扇只有 8 发。
        local S32 = { iter = 30, base = 3.0, dec = 0.3,
                      o1 = {f = 0}, m1 = 64, s1 = 2,  off1 = 8,  c1 = 8,
                      a1 = {f = 0, d = -1.5708}, a2_1 = 0.19635, op1 = 65,
                      o2 = {f = 0}, m2 = 16, s2 = 7,  off2 = 6,  c2 = 5,
                      a2 = {f = 1, d = 1.5708}, a2_2 = 0.314159, op2 = 65,
                      op3 = 67, s3 = 3, off3 = 2, c3 = 16 }
        local S33 = { iter = 30, base = 2.4, dec = 0.1,
                      o1 = {f = 0}, m1 = 24, s1 = 2,  off1 = 13, c1 = 16,
                      a1 = {f = 1, d = 1.5708}, a2_1 = 0.19635, op1 = 65,
                      o2 = {f = 0}, m2 = 96, s2 = 7,  off2 = 4,  c2 = 5,
                      a2 = {f = 0, d = -1.5708}, a2_2 = 0.314159, op2 = 65,
                      op3 = 64, s3 = 2, off3 = 2, c3 = 7 }
        task.Wait(60)                                  -- t=60
        self._box = box5(32, 48, 352, 128)   -- sub29 t=60 的 SET_MOVEMENT_BOUNDS
        while true do
            arm(S30)
            task.Wait(100); drift(self, 1.5, 60)       -- t=160
            arm(S31)
            task.Wait(100)                             -- t=260
            drift(self, 1.5, 60)
            task.Wait(32)                              -- SUB_CALL 2（gi0=8 ⇒ 32 帧）
            arm(S33); arm(S32); arm(S33); arm(S32)
            task.Wait(100); drift(self, 1.5, 60)       -- t=360
            task.Wait(100)                             -- t=460 jump 回 t=60
            cyc = cyc + 1
        end
      end)
    end)

    ---──────────────────── 段式激光（TH07 SPAWN_LASER_FIXED 的移植，同 78 面那张表） ────────────────────
    ---一条激光 = pos 处沿 angle 的线段 [sOff, eOff]，w 是垂直粗细：
    ---tStart 帧展开（前 min(tStart,30) 帧只有 1.2px 细线预警）→ dur 帧满宽（全程有判定）
    ---→ tEnd 帧收束；判定窗口另有 hbStart / hbEnd。ang 用**我们的**弧度。
    local PLASER
    PLASER = Class(laser, {
        init = function(self, x, y, ang, s)
            laser.init(self, s.spr or 4, x, y, ang * RAD, 0, 1, 0, s.w or 8, 0, 0)
            self.pl_x, self.pl_y = x, y
            self.pl_ang = ang
            self.pl_spd = s.spd or 0
            self.pl_sOff, self.pl_eOff = s.sOff or 0, s.eOff or 640
            self.pl_sLen, self.pl_lw = s.sLen or 640, s.w or 8
            self.pl_tStart, self.pl_dur = s.tStart or 0, s.dur or 60
            self.pl_tEnd = s.tEnd or 30
            self.pl_hbStart = s.hbStart or (s.tStart or 0)
            self.pl_hbEnd = s.hbEnd or 0
            self.pl_t, self.pl_state, self.pl_w = 0, 0, 0
            self.alpha, self.colli = 1, false
            PLASER._pl_sync(self)
        end,
        _pl_sync = function(self)
            local a, d = self.pl_ang, self.pl_eOff - self.pl_sOff
            self.x = self.pl_x + math.cos(a) * self.pl_sOff
            self.y = self.pl_y + math.sin(a) * self.pl_sOff
            self.rot = a * RAD
            self.l1, self.l2, self.l3 = 0, max(1, d), 0
            self.w0, self.w = self.pl_lw, self.pl_w
        end,
        frame = function(self)
            self.pl_eOff = self.pl_eOff + self.pl_spd
            if self.pl_sLen < self.pl_eOff - self.pl_sOff then
                self.pl_sOff = self.pl_eOff - self.pl_sLen
            end
            if self.pl_sOff < 0 then self.pl_sOff = 0 end
            local t, full = self.pl_t, self.pl_lw
            if self.pl_state == 0 then
                local warn = min(self.pl_tStart, 30)
                if self.pl_tStart - warn < t then
                    self.pl_w = t * full / max(1, self.pl_tStart)
                else
                    self.pl_w = 1.2
                end
                self.colli = t >= self.pl_hbStart
                if t >= self.pl_tStart then self.pl_state, t = 1, 0 end
            end
            if self.pl_state == 1 then
                self.pl_w, self.colli = full, true
                if t >= self.pl_dur then self.pl_state, t = 2, 0 end
            end
            if self.pl_state == 2 then
                self.pl_w = full * max(0, 1 - t / max(1, self.pl_tEnd))
                self.colli = t < self.pl_hbEnd
                if t >= self.pl_tEnd then object.RawDel(self); return end
            end
            self.pl_t = t + 1
            PLASER._pl_sync(self)
            laser.frame(self)
        end,
    })
    local function plaser(x, y, ang, s)
        local o = New(PLASER, x, y, ang, s)
        if spell_live then spell_live[#spell_live + 1] = o end
        return o
    end
    ---原作 sub48/sub49 的 5 连激光（逐条照抄，含 t=120 的 5 条 `INIT_INTERP`）：
    ---  · t=0  `SET_LASER_SOUND 7` + 逐条 `SET_LASER_IDX k` + `LASER_FIXED`：
    ---    5 条激光**全部同角度**（sub48 = −π、sub49 = 0）、spr1/off2（sub48）/spr1/off4（sub49）、
    ---    speed 0、sOff 24 / eOff 540 / sLen 540 / w 32、
    ---    start 120 / **dur 270+10k**（`laserInstrArgs[8]`，5 条各不相同）/ end 30 / hb 100..20。
    ---  · t=120 建 5 条 `INIT_INTERP`（300 帧、fn 0 = MathLerp、easing 5 = ease-out-cubic）：
    ---    p0 = −π（sub48）/ 0（sub49）、p1 = f5_k；
    ---      f5 初值 = i2_3·(∓0.0654498)
    ---                +（sub48: 1.5708+0.785398 ／ sub49: −4.71239−3.92699）
    ---      每建一条 `INIT_INTERP` 之后 **f5 += 0.19635**（所以 5 条的落点相差 11.25°）。
    ---    同帧 f0..f4 先被 `SET_FLOAT` 压回 p0，再 `i2_0 = 300`；随后 300 帧的 `DEC_JUMP`
    ---    循环（`ctx.time` 每轮被 JUMP 拽回 120 ⇒ 一帧一轮）每帧执行
    ---    `ECL_SET_LASER_ANGLE k *f_k` —— 也就是**每帧**把 5 条激光的角度刷成当前插值。
    ---      ⇒ 第 j 帧（j = 0..299）的角度 = Lerp(p0, p1_k, ease5(j/300))：5 条从**重叠**开始，
    ---        一边整体甩一边张开到 11.25° 间隔。
    ---  · `i2_3` **不是随机数**：sub43 在 t=480 把它清零，每次 `SUB_CALL 48/49` 返回后 `INC`，
    ---    而 t=480 的 JUMP 落在 `INC` 之后的 `SET_FLOAT *f0 -1.5708` 上 ⇒ 它一轮一轮单调递增。
    local function laser5(self, i23, mirror)
        local ls = {}
        local p0 = mirror and 0.0 or -PI
        local f5 = i23 * (mirror and -0.0654498 or 0.0654498)
                   + (mirror and (-4.71239 - 3.92699) or (1.5708 + 0.785398))
        local p1 = {}
        for k = 0, 4 do
            p1[k + 1] = f5
            f5 = f5 + 0.19635
        end
        for k = 0, 4 do
            ls[#ls + 1] = plaser(self.x, self.y, -p0 * RAD2DEG, {
                spr = 1, w = 32, sOff = 24, eOff = 540, sLen = 540,
                tStart = 120, dur = 270 + 10 * k, tEnd = 30, hbStart = 100, hbEnd = 20 })
        end
        PlaySound("lazer00", 0.13, self.x / 256)      -- 原作 sub48/sub49 的 PLAY_SOUND 13
        task.New(self, function()
            for _ = 1, 120 do task.Wait(1) end         -- sub48/49 的 t=0..119
            for j = 0, 299 do                          -- t=120 起 300 轮 SET_LASER_ANGLE
                local u = j / 300
                local e = 1 - (1 - u) * (1 - u) * (1 - u)   -- easing 5 = ease-out-cubic
                for k = 1, 5 do
                    local o = ls[k]
                    if IsValid(o) then
                        ---TH07 的角 θ → 我们的角 −θ（同文件头口径）。
                        o.pl_ang = -(p0 + (p1[k] - p0) * e) * RAD2DEG
                    end
                end
                task.Wait(1)
            end
        end)
        return ls
    end

    ---──────────────────── 符卡 亡郷「亡我郷 -自尽-」（原作 sub43/44/45/46/47/48/49） ────────────────────
    ---逐条照抄原作 sub43 的 L 行。原作把四种难度串在同一个 sub 里，用
    ---`JNEQ *DIFF 0/1/2/3` 链把 ctx.time 一次性推到 360 再落到 L 行的块 —— 也就是说
    ---L 行的 "t=360" 其实是**第 0 帧**，后面的 480/510/540 都要减去 360 才是墙钟：
    ---  · 帧 0   ：块头（SET_INVINCIBILITY_TIMER 300 / SET_ANM 147 / 限位框 /
    ---             `f0 = -0.0981748`、`f1 = 0.6`、`MOVE_POS_TIME 60 4 192 70`）；
    ---  · 帧 120 ：`f0 = -1.5708`、`f3 = 0`、`SET_PERIODIC_CALLBACK 9 44`（t=480）；
    ---  · 帧 150 ：`SUB_CALL 48`（420 帧激光，t=510）；
    ---  · 帧 570 ：`f0 = 0`、`f3 = -1.5708`、`SET_PERIODIC_CALLBACK 9 46`（t=510）；
    ---  · 帧 600 ：`SUB_CALL 49`（420 帧，t=540）；
    ---  · 帧 1020：`JUMP 480` 回帧 120 —— 一轮 900 帧，周期回调**全程不停**，
    ---            所以每 9 帧必有一拍（ECL 实测 0..2200 帧共 231 拍、每拍 8 发 = 1848）。
    ---每拍 = sub44（或镜像的 sub46）本体 5 发 + `SUB_CALL 47`（或 45）的 3 发 = **8 发**：
    ---  · 本体：`SPREAD_ABS 6:8 3 1 v` ＋ `6:13 2 1 v`，v = rand(0.3)+4.2，扇心 f0；
    ---  · 子程：`SPREAD_ABS 6:8 1 1 v` ＋ `6:10 2 1 v`，v = rand(0.3)+3.7，扇心 f3；
    ---  · 相 A（sub44）：`f3 = 3.14159 − f0` 后 `f0 -= rand(0.0392699)+0.0392699`；
    ---    相 B（sub46）：镜像 —— `f0 = 3.14159 − f3` 后 `f3 += rand(0.0392699)+0.0392699`。
    scard("亡郷「亡我郷 -自尽-」", 4393, 65, 2100, false, function(self)
        task.New(self, function()
            task.Wait(120)
            self._box = { -128, 128, 96, 176 }
            ---原作 sub44/45/46/47 的 INIT_BULLET_CMD 共 **4 段**：
            ---  #0 `0 8192 0 120 -1 -1 -1`            → 0x2000 只记 spawnDelay=120；
            ---  #1 `1 32 1 30 -1 -0.0333333 ∓0.0523599` → 0x20（flag=1，dur30、spd −1/30、角 ∓0.0523599）；
            ---  #2 `2 32 0 20 -1 -0.05 ±0.0523599`     → 0x20（flag=0，dur20、spd −0.05、角 ±0.0523599）；
            ---  #3 `3 32 0 20 -1 0 ∓0.0785398`         → 0x20（flag=0，dur20、spd 0、角 ∓0.0785398）。
            ---#2/#3 的 flag 是 0 ⇒ 按 `RunCommands` 的旗标闸，只有前一段 0x20 跑完清掉 exFlags 位
            ---之后才轮到下一段（原作正是靠这个做「先减速右旋 30 帧、再反向左旋 20 帧、再纯转 20 帧」）。
            ---角一律按「我们的角 = −TH07 角」换算成度。flags 8736 = 0x2220（0x2000|0x200|0x20）。
            local function ringcmd(a1_deg, a2_deg, a3_deg)
                return cmds4(8736,
                    { type = 0x2000, dur = 120 },
                    { type = 0x20, flag = 1, dur = 30, loop = -1, speed = -0.0333333, angle = a1_deg },
                    { type = 0x20, flag = 0, dur = 20, loop = -1, speed = -0.05,      angle = a2_deg },
                    { type = 0x20, flag = 0, dur = 20, loop = -1, speed = 0,          angle = a3_deg })
            end
            ---组 A：sub44/45（#1 角 −0.0523599 ⇒ 我们 +3°）；组 B：sub46/47（#1 角 +0.0523599 ⇒ 我们 −3°）。
            local spinA = ringcmd(3, -3, 4.5)
            local spinB = ringcmd(-3, 3, -4.5)
            local lf0, lf3 = -1.5708, 0
            ---一拍：5 发扇心 a（周期子程的本体组，指令组 sA）＋ 3 发扇心 b（被调子程组，指令组 sB）。
            ---相 A 周期 = sub44（角 −）、被调 = sub47（角 +）；相 B 周期 = sub46（角 +）、被调 = sub45（角 −）。
            local function beat(a, b, sA, sB)
                local v5 = ran:Float(0, 0.3) + 4.2   -- 原作 RAND_FLOAT_ADD f2 0.3 4.2
                shoot6(self, 0, 0, 65, 6, 8, 3, 1, v5, 1, a, 0.523599, sA, true)
                shoot6(self, 0, 0, 65, 6, 13, 2, 1, v5, 1, a, 0.523599, sA, true)
                local v3 = ran:Float(0, 0.3) + 3.7   -- 原作 RAND_FLOAT_ADD f2 0.3 3.7
                shoot6(self, 0, 0, 65, 6, 8, 1, 1, v3, 1, b, 0.523599, sB, true)
                shoot6(self, 0, 0, 65, 6, 10, 2, 1, v3, 1, b, 0.523599, sB, true)
                ---★ 子程（sub47/sub45）末尾还有一条 `RAND_FLOAT_ADD *f1 0.0392699 0.0392699`
                ---（把子程的扇心 += f1）。调用方下一拍会用 `3.14159 − f0` 重算子程扇心、
                ---所以这条结果**没人读**，但必须照抽 —— 否则整条随机流每拍错 1 个 float。
                ran:Float(0, 0.0392699)
            end
            task.New(self, function()
                while true do
                    -- 相 A：sub44 挂 450 帧（SET_PERIODIC_CALLBACK 9 44 到切 9 46）
                    lf0, lf3 = -1.5708, 0
                    for _ = 1, 50 do
                        task.Wait(9)
                        lf3 = 3.14159 - lf0
                        beat(lf0, lf3, spinA, spinB)
                        lf0 = lf0 - (ran:Float(0, 0.0392699) + 0.0392699)
                    end
                    -- 相 B：sub46 镜像
                    lf0, lf3 = 0, -1.5708
                    for _ = 1, 50 do
                        task.Wait(9)
                        lf0 = 3.14159 - lf3
                        beat(lf3, lf0, spinB, spinA)
                        lf3 = lf3 + (ran:Float(0, 0.0392699) + 0.0392699)
                    end
                end
            end)
            ---激光段：原作 t=510 起 `SUB_CALL 48`（420 帧）→ `INC i2_3` → t=540
            ---`SUB_CALL 49`（420 帧）→ `INC i2_3` → t=480 的 JUMP 回 sub48，
            ---所以两段交替、每段 420 帧、中间夹 30 帧空档（一轮 900 帧），i2_3 单调递增。
            task.New(self, function()
                task.Wait(30)                       -- ⇒ 原作 t=510（port 帧 150）
                local i23, mirror = 0, false
                while true do
                    laser5(self, i23, mirror)       -- SUB_CALL 48（偶数拍）/ 49（奇数拍）
                    task.Wait(420)                  -- 整段长度
                    i23 = i23 + 1                   -- 原作 SUB_CALL 之后的 INC *i2_3
                    task.Wait(30)                   -- t=510 → t=540 的空档
                    mirror = not mirror
                end
            end)
        end)
    end)

    ---──────────────────── 幽々子 非符 3（原作 sub34/35） ────────────────────
    ---本体每 13 帧从随机点打一组 3 发自机狙（带「自旋 + 加速」两条指令），
    ---同时主时间轴从「13 发自机狙扇」开始、间隔由 120 帧一路缩到 65 帧（越打越快）。
    ncard("幽々子 非符 3", 4394, 32000, 3000, function(self)
        ---★ 原作 `SET_SHOOT_OFFSET` 是**敌人的常驻属性**：sub35 每拍写入后，
        ---本体主时间轴的 SPREAD_AIMED 也吃同一份 `enemy->pos + shootOffset`
        ---（EclManager.cpp:1283）。而且 TH07 的 periodic callback 在同一帧里
        ---**先于**主指令流运行（EclManager.cpp:908 的 restart 段），所以周期子程必须
        ---排在主任务**前面**——否则两拍重合的帧（955/…）主体会吃到上一拍的偏移。
        local ox, oy = 0, 0
        ---sub35：一条随机点 + 三扇 3 发瞄准弹（3:4 无 cmd，3:1 挂 cmd1 正/负自转），
        ---合计 9 发；cmd0 = 0x20 spd0 ang0 dur80，cmd1 = 0x20 spd0.01 ang±0.0261799 dur60。
        task.New(self, function()
            task.Wait(416)                  -- 原作 t=165 起手 + 11 帧相位
            while true do
                ox = ran:Float(-176, 176)
                ---原作 sub35 #0/#1 把偏移写进 TH07 空间的 SET_SHOOT_OFFSET；
                ---本文件口径 y 要取反（同 sub36 的 OFFS 表）。漏掉 ⇒ 整卡偏 2·oy。
                oy = -ran:Float(-24, 24)
                ---★ 三扇的 flags 不同：3:4 那扇是 516（0x204，**没有** 0x20 位）⇒ 不挂任何指令；
                ---两条 3:1 是 36（0x24）⇒ 挂 `commands[0]`+`commands[1]` 两段。
                ---commands[0] 是 `INIT_BULLET_CMD 0 32 0 80 -1 0 0`（0x20、dur 80、spd 0、ang 0）
                ---＝ 80 帧空转；commands[1] 才是 `… 1 32 0 60 -1 0.01 ∓0.0261799`
                ---（注意 cmd.speed = **+0.01 = 每帧加速**，早年写成 spin6(...,0.01,…) 被 spin6 的
                ---「传减速量」口径篡改成了 −0.01；角也要按「我们的角 = −TH07 角」换算）。
                shoot6(self, ox, oy, 64, 3, 4, 3, 1, 1, 1, 0, 0.523599, nil, true)
                shoot6(self, ox, oy, 64, 3, 1, 3, 1, 1, 1, 0, 0.523599,
                       cmds4(36, { type = 0x20, dur = 80, loop = -1, speed = 0, angle = 0 },
                                 { type = 0x20, dur = 60, loop = -1, speed = 0.01,
                                   angle = -0.0261799 * RAD2DEG }), true)
                shoot6(self, ox, oy, 64, 3, 1, 3, 1, 1, 1, 0, 0.523599,
                       cmds4(36, { type = 0x20, dur = 80, loop = -1, speed = 0, angle = 0 },
                                 { type = 0x20, dur = 60, loop = -1, speed = 0.01,
                                   angle = 0.0261799 * RAD2DEG }), true)
                task.Wait(11)
            end
        end)
        task.New(self, function()
            ---★ 原作 sub34 t=0 `MOVE_POS_TIME 60 4 192 112`（LuaSTG 落点 (0,112)）；
            ---enter6 的默认落点 (0,96)（TH07 (192,128)）会整体偏 16px y。
            bmove(self, 60, 4, 0, 112)
            ---原作 sub34 进场：MOVE_POS_TIME(60) 与 2×SUB_CALL 2（各 120 帧粒子/音）
            ---＋t=30/45/105/165 的四段等待 = 405 帧后才设周期子程与主时间轴。
            task.Wait(405)
            ---主时间轴：i0 从 120 起，每拍 SET_WAIT_TIMER i0 → 打 13 发 → i0-=5；
            ---i0<=60 后不再递减（原作 JLEQ i0 60 跳过 SUB），但**继续开火**。
            local li0 = 120
            while true do
                task.Wait(li0)
                shoot6(self, ox, oy, 64, 10, 1, 13, 1, 3.2, 1, 0, 0.1848, nil, true)
                if li0 > 60 then li0 = li0 - 5 end
            end
        end)
    end)

    ---──────────────────── 幽々子 非符 4（原作 sub36/37） ────────────────────
    ---原作 sub36（L 行）：t=60 设限位框、i1=0、f0..f5=0，挂 `SET_PERIODIC_CALLBACK 11 37`
    ---（周期子程的局部变量就由这份父程初值接管，f6/f7 未写 = 0），i0=200 起主时间轴。
    ---主时间轴：每拍 `SET_WAIT_TIMER i0` → 打一条 11 发自机狙扇（10:1，v=1.2→1，
    ---张角 0.19635）→ `i0 -= 5`，`i0<=80` 后不再缩短但**继续开火**。
    ---sub37（每 11 帧一拍）：i2 = i1 + K、i3 = i2 % 8，`i3<4` 才开火；K 按炮口序
    ---（A..H）= 0/2/4/6/1/7/3/5 ⇒ 每拍恰好 4 个炮口、i1%8 决定是哪 4 个：
    ---  i1%8=0,1 → A + 3 口慢口 = 16 发；2,3 → A+D + 2 口 = 20 发；
    ---  4,5 → D + 3 口 = 16 发；6,7 → 无大炮口、4 口 = 12 发（= 实测 16/16/20/20/16/16/12/12）。
    ---每一口：`SET_SHOOT_OFFSET` 固定偏移 + `RING_ABS 9:4 count 1 v=2.5→1 a1=炮口角/张角 0.523599`，
    ---并给它挂 `INIT_BULLET_CMD 0 32 0 80 -1 -0 *fN`（type0x20：每帧转 fN）、duration=80。
    ---A/D 口的 count 按难度另存三份（E 3 / N 3 / H 5 / L 7，L 只保留 skip=8 的那条）。
    ---拍末按 i1 的区间给 8 个 f 加减 0.000490874，i1>120 后回 1（原作 SET_INT i1 0 + INC）。
    ncard("幽々子 非符 4", 4395, 32000, 3000, function(self)
        task.New(self, function()
            ---★ 原作 sub36 进场：t=0 的 MOVE_POS_TIME(60,4,192,112) 走满 60 帧后才到
            ---t=60（LuaSTG 落点 (0,112)）。原先只等 60 帧却没真的位移，本体停在
            ---enter6 的默认 (0,96)，全卡的弹都偏 16px y。
            bmove(self, 60, 4, 0, 112)
            task.Wait(60)
            ---(ox, oy) 已是我们的坐标（原作 SET_SHOOT_OFFSET 的 y 取反）；
            ---第 3 列 = RING_ABS 的基准角 a1（TH07 弧度）；第 4 列 = L 行 count1。
            local OFFS = { { 128, 16, 0.785398, 7 }, { 96, 0, 1.1781, 3 },
                           { 64, -16, 1.5708, 3 }, { -128, 16, 2.35619, 7 },
                           { -96, 0, 1.9635, 3 }, { -64, -16, 1.5708, 3 },
                           { 160, 0, 1.5708, 3 }, { -160, 0, 1.5708, 3 } }
            local K = { 0, 2, 4, 6, 1, 7, 3, 5 }
            local f = { 0, 0, 0, 0, 0, 0, 0, 0 }   -- 原作 f0..f7（0x20 指令的每帧转角）
            local d = 0.000490874
            task.New(self, function()
                task.Wait(11)   -- 原作周期子程比本体起手（t=60）晚 11 帧
                local li1 = 0
                while true do
                    for k = 1, 8 do
                        if (li1 + K[k]) % 8 < 4 then
                            local o = OFFS[k]
                            shoot6(self, o[1], o[2], 67, 9, 4, o[4], 1, 2.5, 1,
                                   o[3], 0.523599, spin6(f[k], 0, 80), true)
                        end
                    end
                    ---原作拍末的 4 段区间（#61-68 / #73-76 / #79-84，其余区间空转）。
                    if li1 >= 20 and li1 < 40 then
                        f[1] = f[1] + d; f[2] = f[2] + d; f[3] = f[3] + d
                        f[4] = f[4] - d; f[5] = f[5] - d; f[6] = f[6] - d
                        f[7] = f[7] + d; f[8] = f[8] - d
                    elseif li1 >= 60 and li1 < 100 then
                        f[1] = f[1] - d; f[3] = f[3] - d
                        f[4] = f[4] + d; f[6] = f[6] + d
                    elseif li1 >= 100 and li1 < 120 then
                        f[1] = f[1] + d; f[2] = f[2] - d; f[3] = f[3] + d
                        f[4] = f[4] - d; f[5] = f[5] + d; f[6] = f[6] - d
                    end
                    li1 = li1 + 1
                    if li1 > 120 then li1 = 1 end   -- 原作 #86 SET_INT i1 0 + #87 INC
                    task.Wait(11)
                end
            end)
            local li0 = 200
            ---原作 JLEQ i0 80 命中后跳过 `SUB i0 5`（不再缩间隔），但仍继续开火；
            ---所以墙钟上 i0=80 的那一拍也要打，且此后每 80 帧一拍打到卡结束。
            while true do
                task.Wait(li0)
                shoot6(self, 0, 0, 64, 10, 1, 11, 1, 1.2, 1, 0, 0.19635, nil, true)
                if li0 > 80 then li0 = li0 - 5 end
            end
            task.Wait(200)
        end)
    end)

    ---──────────────────── 符卡 亡舞「生者必滅の理 -魔境-」（原作 sub50/51，L 行） ────────────────────
    ---原作 sub50（L 行）：t=360 开卡 + 把本体 120 帧内移到 (192,112)，
    ---t=480 设限位框 64/48/320/128 并挂 `SET_PERIODIC_CALLBACK 3 51` —— 每 3 帧跑一次 sub51。
    ---sub51 每一拍：li0++、相位 = li0 % 4：
    ---  0 → 整圈 4 发（spr8/col4，速度 1.4）；
    ---  1 → 每 8 拍里打 7 拍「大弹」（spr10/col1，速度 3.7），且先空过 16 拍才开火；
    ---      大弹挂 0x80：刹停 100 帧后瞄准自机、以速度 3 直飞（L 行 cmd.angle=3.0）；
    ---  2 → 2 发（spr8/col3，速度 3.2），挂 0x40：刹停 100 帧后角度 +π/2、恢复速度 1.1；
    ---  3 → 2 发（spr8/col2，速度 3.0），挂 0x40：刹停 100 帧后角度 −π/2、恢复速度 1.1。
    ---每拍末尾：li2++、基准角 lf0 ± 0.0475999 rad（li2 % 600 ≥ 300 时取负号）。
    scard("亡舞「生者必滅の理 -魔境-」", 4396, 65, 3000, false, function(self)
        task.New(self, function()
            ---★ 原作 sub50 t=0 `SET_FLOAT f3_0/f3_1 = 192/112` + `MOVE_POS_TIME 120 4`
            ---（L 行从 t=360 的 `JUMP` 起只等满到 t=480 的 120 帧）⇒ 本体在
            ---(192,112) TH07 = (0,112) 我们。enter6 的默认落点 (0,96) 会让整张卡
            ---的所有弹都偏 16px y。
            bmove(self, 120, 4, 0, 112)
            ---L 行从 t=360 沿 time:=480 的跳转只等满 120 帧（不是从 0 等到 480）。
            task.Wait(120)
            self._box = box5(64, 48, 320, 128)
            ---`SET_PERIODIC_CALLBACK 3 51` 在 t=480 设下后，计数器当帧不增；
            ---第一次 sub51 落在 120+3 帧（= ECL 的 123），移植版把这 3 帧补上。
            local lf0, li0, li2, li3, l2i1 = 0, 0, 0, 0, 0
            task.Wait(3)
            while true do
                li0 = li0 + 1
                local ph = li0 % 4
                if ph == 0 then
                    shoot6(self, 0, 0, 67, 8, 4, 4, 1, 1.4, 1, lf0, 0, nil, true)
                elseif ph == 1 then
                    li3 = li3 + 1
                    l2i1 = l2i1 + 1
                    if l2i1 >= 16 then
                        li3 = li3 % 8
                        if li3 < 7 then
                            shoot6(self, 0, 0, 67, 10, 1, 1, 1, 3.7, 1, lf0, 1,
                                   brake_aim6(100, 0, 3.0, 1), true)
                        end
                    end
                elseif ph == 2 then
                    shoot6(self, 0, 0, 67, 8, 3, 2, 1, 3.2, 1, lf0, 2,
                           { type = 0x40, dur = 100, loop = 1, angle = -90, speed = 1.1 }, true)
                else
                    shoot6(self, 0, 0, 67, 8, 2, 2, 1, 3.0, 1, lf0, 3,
                           { type = 0x40, dur = 100, loop = 1, angle = 90, speed = 1.1 }, true)
                end
                li2 = li2 + 1
                if (li2 % 600) >= 300 then lf0 = lf0 - 0.0475999
                else lf0 = lf0 + 0.0475999 end
                task.Wait(3)
            end
        end)
    end)

    ---──────────────────── 符卡 華霊「バタフライディルージョン」（原作 sub52/53/54） ────────────────────
    ---L 行时间轴（帧号 = 原作 t − 360；sub52 全篇就是一条 200 帧的大循环）：
    ---  frame 120（t=480）：SET_MOVEMENT_BOUNDS 64 48 320 128、MOVE_POS_TIME 60 4 (192,112)、
    ---    f0=0（前一条 −0.0981748 当场被覆盖）、f1=0.6、i0=0、SET_BULLET_SOUND 7、i2=0、
    ---    i2_3=0、INIT_BULLET_CMD 0 = {0x2000, flag 1, dur 300}（蝶弹的 spawnDelay）；
    ---  frame 180（t=540）：RING_ABS `8:4` 8 发（v=0.5、a2=30°、a1=f0=0、flags 0x3204）、
    ---    i2_0=8、RUN_EX_INS 16 —— 8 只 LBLUE 蝶弹每只再炸 5 颗普通弹（spr0/off6、速度 f1、
    ---    a1=原角+π、a2=22.5°、flags 2）⇒ 本波 8+40=48 发；
    ---  frame 190..250（每 10 帧）：DEC_JUMP i2_0 ⇒ 只跑 ex16（8 只蝶弹还在场，每波 +40）；
    ---  frame 260：ex17（每只 LBLUE 蝶弹**在弹位置**生一只 sub53 子机，继承原弹角 f0 与相位 f7；
    ---    再清掉全部蝶弹）、f4=RNGRAD、i2=60、SET_PERIODIC_CALLBACK i2 54、f1=0.75、
    ---    i2_0=12、ex18（只数 LBLUE 写 i0）；
    ---  frame 270..380（每 10 帧）：DEC_JUMP i2_0 ⇒ ex18（不产弹）；
    ---  frame 380（idx86 链归零后）：f1+=0.25、i2_0=8、ex18；i0==0 ⇒ idx92 **同帧** JUMP 回环帧
    ---    （⇒ 下一个环仍在 +200 帧）；i0!=0 时改走 idx93 链（再数 12 次 + ex17 + i2−=4 并重装
    ---    周期回调 + 再跑一次 12×10 帧的 ex18 链，见 tail()）。
    ---周期子程 sub54（每 i2 帧一次，L 行只跑第 4 条）：RING_ABS `7:3` 18 发 ×3 层
    ---  （v=2.5→0.8、a2=11.25°、a1=自身的 f4）⇒ 54 发/次；打完 f4 += 0.0261799。
    ---sub53 蝶子机（ex17 生）：t=0 起用 INIT_INTERP（Cubic、ease 0）分别把 X/Y 插值到
    ---  **自机当前位置**（p0/p1/m0/m1 每帧实时取值 ⇒ 一路追踪），切向量 m0 = cos/sin(f0)·720、
    ---  m1 = cos/sin(f0)·180（f0 = 原蝶弹角）；t=120 原地打 4 波带自旋的蝶弹
    ---  （v=0.8/1.46/2.4/3.2、a1=f7 相位、a2=30°/11.25°、flags 0x3224 + 0x2000 spawnDelay），
    ---  随后 UNIMP 自毁。
    ---蝶弹登记表：ex-ins 16/17/18 扫的是 BulletManager 的**全表**（原作这些弹带 spawnDelay 300，
    ---飞出屏外也不回收），本仓 pool4 会按出屏回收 —— 所以这群蝶弹另记一份（位置随对象走，
    ---对象没了就用最后位置），按原作语义存活到 ex17 清场。
    scard("華霊「バタフライディルージョン」", 4397, 65, 3000, false, function(self)
        local bd = {}                    -- 蝶弹：{ o = 弹对象, off = 色档, x, y, rot = 我们的角度 }
        local lf0, lf1, lf4 = 0, 0, 0    -- sub52 的 floatVars1[0]/[1]/[4]
        local lf4p = 0                   -- 周期子程 sub54 里那份 f4（arm 时从 lf4 复制一份）
        local li0, li2, li2_0 = 0, 0, 0  -- intVars1[0] / intVars1[2] / intVars2[0]
        ---周期回调（SET_PERIODIC_CALLBACK i2 54）的计数器；原作在**每帧 RunEcl 开头**检查。
        local ptim, pcnt, armed = 0, 0, false

        ---蝶弹当前位置（我们的角度）：对象还在就现取，没了就用最后记下的。
        local function bd_pos(e)
            if IsValid(e.o) then e.x, e.y, e.rot = e.o.x, e.o.y, e.o.rot end
            return e.x, e.y, e.rot
        end
        local function bd_add(o, off)
            bd[#bd + 1] = { o = o, off = off, x = o.x, y = o.y, rot = o.rot }
        end
        local function bd_clear()
            for i = 1, #bd do
                if IsValid(bd[i].o) then object.RawDel(bd[i].o) end
            end
            bd = {}
        end

        ---ex-ins 16 YuyukoTransformButterflyBullets：每颗蝶弹（色档 0..7）再炸 5 颗普通弹
        ---（spr0/off6、v = 调用方 floatVars1[1] = f1、a1 = 原角+π、a2=22.5°、flags 2），
        ---原蝶弹保留（留到 ex17 清）。
        local function ex16()
            local style, col = bs(0), col16(6)
            local offs = spread_offsets(5, -22.5)
            for i = 1, #bd do
                if POOL4_SIZE - pool4_used() < 5 then break end
                local x, y, rot = bd_pos(bd[i])
                local base = rot - 180
                for k = 1, 5 do
                    pool4[#pool4 + 1] = NewSimpleBullet(style, col, x, y, lf1,
                                                        base + offs[k], false, 0, false)
                end
            end
        end

        ---sub53 蝶子机协程（ex17 用 pspawn 生；f0 = 原蝶弹的 TH07 角，ph = 相位）。
        local function butterfly6(self2, a)
            local f0, ph = a.f0, a.ph
            local cf, sf = cos(f0 * RAD2DEG), sin(f0 * RAD2DEG)
            local mx0, mx1 = cf * 720, cf * 180
            ---TH07 的 y 朝下：换成我们的 y 时等于 X 那条插值整体取反（h00+h01 == 1）。
            local my0, my1 = -sf * 720, -sf * 180
            ---★原作 t=0 的 `INIT_INTERP *X 120 7 0 *X *PX *f2 *f3`（Y 同型）——
            ---  p0/p1/m0/m1 在**建立那一刻各求值一次**就冻成数字（EclManager.cpp:1084-1087），
            ---  p0 = 当时的 *X/*Y、p1 = 当时的 *PX/*PY，之后逐帧只用这四个定值。
            ---  旧实现把 `self2.x`/`player.x` 写进求值位置 ⇒ 每帧重读（见文件头第 7 条），
            ---  路形与原作不同（p1 更会在自机动的时候整条偏掉）。
            local x0, y0 = self2.x, self2.y
            local px, py = player.x, player.y
            for n = 1, 120 do
                local t = n / 120
                self2.x = hermite(t, x0, px, mx0, mx1)
                self2.y = hermite(t, y0, py, my0, my1)
                task.Wait(1)
            end
            local function volley(op, spr, off, c1, c2, v, a2, spin)
                local cmd = cmds4(0x3224, spin6(spin, 0, 80),
                                  { type = 0x2000, flag = 1, dur = 300, loop = -1,
                                    speed = -1, angle = -1 })
                local objs = shoot6(self2, 0, 0, op, spr, off, c1, c2, v, 1, ph, a2, cmd, true)
                for i = 1, #objs do bd_add(objs[i], off) end
            end
            volley(67, 8, 4, 1, 1, 0.8,  0.523599,  0.0785398)
            volley(67, 8, 3, 1, 1, 1.46, 0.523599, -0.0785398)
            volley(65, 8, 2, 2, 1, 2.4,  0.19635,   0.0897598)
            volley(65, 8, 1, 2, 1, 3.2,  0.19635,  -0.0897598)
        end

        ---ex-ins 17 YuyukoButterflySpawnEnemy：LBLUE（色档 4）蝶弹就地生一只 sub53 子机
        ---（floatVars1[0]=原弹角、[7]=相位，每只 +45°），然后清掉**全部**蝶弹。
        local function ex17()
            local ph = -PI
            for i = 1, #bd do
                local e = bd[i]
                if e.off == 4 then
                    local x, y, rot = bd_pos(e)
                    pspawn(x, y, butterfly6, { f0 = -rot * PI / 180, ph = ph })
                    ph = ph + PI / 4
                end
            end
            bd_clear()
        end

        ---ex-ins 18 YuyukoCountButterflyBullets：数 LBLUE 蝶弹写 intVars1[0]（不产弹）。
        local function ex18()
            li0 = 0
            for i = 1, #bd do
                if bd[i].off == 4 then li0 = li0 + 1 end
            end
        end

        ---周期子程 sub54（4 条 RING_ABS 按难度四选一，L 只跑第 4 条）。
        local function sub54()
            shoot6(self, 0, 0, 67, 7, 3, 18, 3, 2.5, 0.8, lf4p, 0.19635, nil, true)
            lf4p = lf4p + 0.0261799
        end
        ---SET_PERIODIC_CALLBACK（op144）：装表、计数清零、周期子程的局部变量取一份拷贝。
        local function arm(t)
            ptim, pcnt, armed = t, 0, true
            lf4p = lf4
        end
        ---每帧 RunEcl 开头：周期计数器 ++，到点就跑 sub54。
        local function tick()
            if armed then
                pcnt = pcnt + 1
                if pcnt >= ptim then pcnt = 0; sub54() end
            end
        end

        ---环帧：RING_ABS `8:4` 8 发（v=0.5、a2=30°、a1=f0、flags 0x3204 + spawnDelay 300）。
        local function ring()
            local objs = shoot6(self, 0, 0, 67, 8, 4, 8, 1, 0.5, 1, lf0, 0.523599,
                                cmds4(0x3204, { type = 0x2000, flag = 1, dur = 300,
                                                loop = -1, speed = -1, angle = -1 }), true)
            for i = 1, #objs do bd_add(objs[i], 4) end
        end

        ---从当前帧起推进 n 帧（每帧帧首先走周期回调），到第 n 帧执行 fn。
        local function stepf(n, fn)
            for _ = 1, n do
                task.Wait(1)
                tick()
            end
            if fn then fn() end
        end

        ---idx87..idx92 的收尾：返回 true ⇒ 本帧已同帧跳回环帧（idx92）。
        local function tail()
            if lf1 < 2 then lf1 = lf1 + 0.25 end    -- idx87/88 JGEQ_F *f1 2
            li2_0 = 8                               -- idx89
            ex18()                                  -- idx90
            while true do
                if li0 == 0 then return true end    -- idx91 → idx92（同帧 JUMP 回 idx75）
                li2_0 = li2_0 - 1                   -- idx93 DEC_JUMP
                if li2_0 <= 0 then break end        -- 落 idx94
                ex18()                              -- idx90
            end
            ex17()                                  -- idx94
            if li2 > 40 then li2 = li2 - 4; arm(li2) end   -- idx95/96/97
            li2_0 = 12                              -- idx99 → idx84
            ex18()                                  -- idx85
            for _ = 1, 11 do stepf(10, ex18) end    -- idx86 DEC_JUMP 链
            stepf(10, nil)
            return false
        end

        task.New(self, function()
            task.Wait(120)                              -- 原作 L 行 t=360 BEGIN_SPELLCARD ⇒ frame 0
            self._box = box5(64, 48, 320, 128)          -- SET_MOVEMENT_BOUNDS 64 48 320 128
            bmove(self, 60, 4, 0, 112)                  -- MOVE_POS_TIME 60 4 (192,112)
            lf0, lf1, lf4 = 0, 0.6, 0
            li0, li2, li2_0 = 0, 0, 0
            task.Wait(60)                               -- frame 180 = 第一个环帧
            tick(); ring(); li2_0 = 8; ex16()
            while true do
                for _ = 1, 7 do stepf(10, ex16) end     -- frame F+10 .. F+70
                stepf(10, function()                    -- frame F+80
                    ex17()
                    lf4 = rngrad(); li2 = 60; arm(60); lf1 = 0.75; ex18()
                end)
                for _ = 1, 11 do stepf(10, ex18) end    -- frame F+90 .. F+190
                stepf(10, nil)                          -- frame F+200：idx86 链归零
                while not tail() do end                 -- idx87..idx92（可能跨多帧）
                ring(); li2_0 = 8; ex16()               -- idx92 同帧回环帧
            end
        end)
    end)

    ---──────────────────── 幽々子 非符 5（原作 sub38/39/40/41/42） ────────────────────
    ---原作 sub38 主时间轴（L 行）：
    ---  t=180 清零 i1/f0..f5、i0=200，f7=4.1，挂 `SET_PERIODIC_CALLBACK 8 39`；
    ---  t=200/280/360/440 各打一圈「8:5，32 发 × 3 层、v=2.8→2.2→1.6、a1=RNGRAD」的大环
    ---        （flags=0x200 **不含**任何指令位 ⇒ 不吃 INIT_BULLET_CMD），
    ---        并 `MOVE_DIR_TIME 60 4 (exitAngle) 1.5` 漂移 60 帧；
    ---  t=260/340/420 依次把周期子程换成 sub40/41/42；t=520 `JUMP` 回 t=180。
    ---周期子程（8 帧一拍）每支＝若干条「2 发瞄准扇」，条数 1/2/3/4（⇒ 每拍 2/4/6/8 发）：
    ---  sub39：6:6，a1=0，a2=45°；  sub40：6:8，a1=∓22.5°；
    ---  sub41：6:6 a1=0 + 6:10 a1=∓22.5°；  sub42：6:8 a1=∓22.5°/∓67.5°。
    ---每条扇前先写两条指令：`INIT_BULLET_CMD 0 128 0 60 1 <瞄准偏移> 0.1`
    ---（0x80＝先用 60 帧刹到 0、再拐向自机 + 偏移、以 0.1 续航）与
    ---`INIT_BULLET_CMD 1 16 0 80 -1 0.038 -999`（0x10＝沿当前朝向每帧 +0.038 加速 80 帧）。
    ---两条 flag 都是 0 ⇒ 按 `RunCommands` 的门控，0x80 跑满 60 帧清位后 0x10 才接上；
    ---扇各自的 flags（0x292 / 0x92）都含 0x80|0x10 位，所以每条扇的弹都吃得到这两条指令。
    ncard("幽々子 非符 5", 4398, 22000, 2200, function(self)
        task.New(self, function()
            ---★ 原作 sub38 t=0 `MOVE_POS_TIME 60 4 192 112`（LuaSTG 落点 (0,112)）。
            bmove(self, 60, 4, 0, 112)
            self._box = box5(32, 48, 352, 128)          -- sub38 的 SET_MOVEMENT_BOUNDS
            local lf7 = 4.1                             -- 原作 f7（L 行 instr#34）
            ---0x10 在并发指令（cmds4）里走 `speed` 字段（cmdsub_new 用它冻结向量），
            ---不能用单指令口径的 accel6。
            local function ac10(spd, dur) return { type = 0x10, dur = dur or 80, speed = spd } end
            ---0x80 刹车后朝自机拐弯：off = 瞄准偏移（TH07 弧度）、恢复速度 0.1。
            local function brake80(off)
                return { type = 0x80, dur = 60, loop = 1, angle = -off * RAD2DEG, speed = 0.1 }
            end
            ---各条扇：spr, off, a1, a2, flags, 该扇 0x80 的瞄准偏移。
            local SPREADS = {
                { { 6, 6, 0, 0.785398, 658, 0 } },
                { { 6, 8, -0.392699, 0.785398, 658, 0.392699 },
                  { 6, 8, 0.392699, 0.785398, 146, -0.392699 } },
                { { 6, 6, 0, 1.5708, 658, 0 },
                  { 6, 10, -0.392699, 0.785398, 146, 0.523599 },
                  { 6, 10, 0.392699, 0.785398, 146, -0.523599 } },
                { { 6, 8, -0.392699, 0.785398, 658, 0.785398 },
                  { 6, 8, 0.392699, 0.785398, 146, -0.785398 },
                  { 6, 8, -1.1781, 0.785398, 146, 0.261799 },
                  { 6, 8, 1.1781, 0.785398, 146, -0.261799 } },
            }
            local function burst(stage)
                for _, s in ipairs(SPREADS[stage + 1]) do
                    shoot6(self, 0, 0, 64, s[1], s[2], 2, 1, lf7, 1, s[3], s[4],
                           cmds4(s[5], brake80(s[6]), ac10(0.038, 80)), true)
                end
            end
            ---周期子程时间表：39 十拍 → 40 十拍 → 41 十拍 → 42 十二拍 → 回到 39。
            ---原作 t=520 的 `SET_PERIODIC_CALLBACK 8 39` 落在一个非拍点上（拍点 516/524），
            ---把 8 帧计数清零 ⇒ 下一拍从 524 推到 528（比常拍晚 4 帧）。
            task.New(self, function()
                task.Wait(188)      -- 原作 t=180 挂回调，第一拍在 +8 帧
                while true do
                    for _ = 1, 10 do burst(0); task.Wait(8) end
                    for _ = 1, 10 do burst(1); task.Wait(8) end
                    for _ = 1, 10 do burst(2); task.Wait(8) end
                    for _ = 1, 12 do burst(3); task.Wait(8) end
                    task.Wait(4)
                end
            end)
            ---大环时间轴：t=200 起，每 80 帧一圈；第 4 圈后接 t=520 的回跳 ⇒ 间隔 100。
            task.Wait(200)
            while true do
                for i = 1, 4 do
                    drift(self, 1.5, 60)
                    shoot6(self, 0, 0, 67, 8, 5, 32, 3, 2.8, 1,
                           ran:Float(-PI, PI), 0, nil, true)
                    task.Wait((i == 4) and 100 or 80)
                end
            end
        end)
    end)

    ---──────────────────── 符卡 幽曲「リポジトリ・オブ・ヒロカワ -神霊-」（原作 sub55/56/57） ────────────────────
    ---L 行（其余难度的分支在 sub55 里全被 `JNEQ DIFF` 跳过）：开卡 180 帧后（原作 t=540）
    ---进入 407 帧一循环的主时间轴（t=540 → t=947 `JUMP 540`）：
    ---  t=540/541  shootOffset=(0,0)（本体处）连打两轮 sub56（gi0=14 发、色档 gi1=4、自转 ±）；
    ---  t=549~552  换成 gi0=10（色档 6/6/5/5），并把 shootOffset 依次设成绝对坐标
    ---             (80,128)→(304,128)→(136,144)→(248,144)（SET 排在 SUB_CALL 之后 ⇒ 滞后一拍生效）；
    ---  t=612      shootOffset 复位、开始 60 帧漂移（此后每轮前都漂一次）；
    ---  t=672/742/807/867  四轮 sub57（gi0 = 10/12/18/16、色档 3/3/2/3、自转 ±）；
    ---  t=867 另接 `MOVE_POS_TIME 80 4 (192,112)`，80 帧后 t=947 回跳。
    ---sub56：8 拍，每拍重写 cmd2（0x10、dur80、speed = f0；从 0.047 每拍 −0.00871429）后
    ---  从 shootOffset 打一圈 gi0 发（spr8、色档 gi1、v=0.5、张角 45°、a1=0）；
    ---  弹上挂 cmd0（0x20、dur120、每帧 +0.01 速、转角 ±0.0261799）与
    ---  cmd1（0x2000、spawnDelay 200 —— 本仓库没有出屏延迟原语，略，见差异 67）。
    ---sub57：8 拍，每拍重写 cmd3（0x10、dur80、speed = f0；L 从 0.049 每拍 −0.00942857）后
    ---  打一条 gi0 发的绝对扇（spr8、色档 gi1、v=0.5、a1 = A2P+π、张角 0.224399 ——
    ---  背对自机散开）；弹上挂 cmd0（0x20、dur120、每帧 +0.013 速、转角 ±0.0261799）、
    ---  cmd2（0x80、dur1、loop1、`resume_own` ⇒ 120 帧自转结束后拐向自机、保持原速率）
    ---  与 cmd1（0x2000，略）。三段的激活顺序 = commands[] 槽位序（0→2→3），
    ---  且 flag 都是 0 ⇒ 靠 `RunCommands` 的 exFlags 门控天然串行。
    scard("幽曲「リポジトリ・オブ・ヒロカワ -神霊-」", 4399, 65, 2200, false, function(self)
        task.New(self, function()
            task.Wait(120)
            self._box = box5(64, 48, 320, 128)      -- 原作 t=480 的 SET_MOVEMENT_BOUNDS
            bmove(self, 60, 4, 0, 112)              -- 原作 t=480 的 MOVE_POS_TIME 60 4 (192,112)
            ---0x20（TargetAngle）的入口：每帧转角 rate（TH07 弧度）、速度增量 dv。
            ---（`spin6` 的口径是 |减速量| 取负，这里直接用 ECL 的 cmd.speed 原值。）
            local function spin20(rate_th, dv, dur)
                return { type = 0x20, dur = dur, loop = -1,
                         angle = -rate_th * RAD2DEG, speed = dv }
            end
            ---0x10（并发指令口径）：沿弹此刻朝向每帧 +spd，跑满 dur 帧。
            local function ac10(spd, dur) return { type = 0x10, dur = dur or 80, speed = spd } end
            ---0x80 的 `angle=-999` 支：刹 dur 帧后拐向自机、速度用弹**此刻**的速率。
            local function aim80(dur)
                return { type = 0x80, dur = dur, loop = 1, angle = 0, resume_own = true }
            end
            ---原作 sub56：(ox, oy) 是 SET_SHOOT_OFFSET 定下的出膛点（我们的相对坐标）。
            local function sub56(n, col, rot, ox, oy)
                local d = 0.047
                for _ = 1, 8 do
                    shoot6(self, ox, oy, 67, 8, col, n, 1, 0.5, 1, 0, 0.785398,
                           cmds4(8752, spin20(rot, 0.01, 120), ac10(d, 80)), true)
                    d = d - 0.00871429
                end
            end
            ---原作 sub57：f1 = A2P + π 在整支子程里只算一次（8 拍共用同一基准角）。
            local function sub57(n, col, rot)
                local d = 0.049
                local a1 = aimth(self) + PI
                for _ = 1, 8 do
                    shoot6(self, 0, 0, 65, 8, col, n, 1, 0.5, 1, a1, 0.224399,
                           cmds4(8880, spin20(rot, 0.013, 120), aim80(1), ac10(d, 80)), true)
                    d = d - 0.00942857
                end
            end
            task.Wait(60)                           -- 到原作 t=540
            while true do
                sub56(14, 4, 0.0261799, 0, 0)       -- t=540
                task.Wait(1)
                sub56(14, 4, -0.0261799, 0, 0)      -- t=541
                task.Wait(8)
                -- t=549/550/551/552：四个绝对出膛点（80,128）(304,128)(136,144)(248,144)
                sub56(10, 6, 0.0261799, -112, -16)
                task.Wait(1)
                sub56(10, 6, -0.0261799, 112, -16)
                task.Wait(1)
                sub56(10, 5, -0.0261799, -56, -32)
                task.Wait(1)
                sub56(10, 5, 0.0261799, 56, -32)
                task.Wait(60)
                -- t=612：漂移 60 帧 + shootOffset 复位
                drift(self, 1.5, 60); task.Wait(60)
                sub57(10, 3, 0.0261799)             -- t=672
                task.Wait(10)
                drift(self, 1.5, 60); task.Wait(60)
                sub57(12, 3, -0.0261799)            -- t=742
                task.Wait(5)
                drift(self, 1.5, 60); task.Wait(60)
                sub57(18, 2, 0.0261799)             -- t=807
                drift(self, 1.5, 60); task.Wait(60)
                sub57(16, 3, -0.0261799)            -- t=867
                bmove(self, 80, 4, 0, 112); task.Wait(80)
            end
        end)
    end)

    ---──────────────────── 符卡 桜符「完全なる墨染の桜 -開花-」（原作 sub58/59/60/61） ────────────────────
    ---原作 sub58（`ecldata6.ecl`，Lunatic 行；skipInstrOnDifficulty 0x01/0x02/0x04 的三条
    ---SUB_CALL 60 分别只在 Easy/Normal/Hard 跑，Lunatic 只执行 skip=0x08 的 gi0=42 那条
    ---—— `EclManager.cpp:944`）。时间轴（t = 原作 ECL 时间）：
    ---  t=120  MOVE_POS_TIME(120,ease4,192,96) → 我们 (0,128)（sub58 开场进场）
    ---  t=600  SET_MOVEMENT_BOUNDS 64 48 320 96、SET_BULLET_SOUND 7 25、
    ---         MOVE_POS_TIME(60,ease4,192,96)（已到位，空动作）、SET_SHOOT_INTERVAL 0
    ---  t=660  SUB_CALL 60(gi0=42)：5 圈 42 发整圈环（每圈 0x10 段的加速度递减
    ---         0.04 / 0.028 / 0.016 / 0.004 / −0.008）
    ---  —— 之后每轮 320 帧，k=0,1,2,…（t=820+320k 起）——
    ---  t=820+320k   SUB_CALL 59 ×3（gi0=2、基准角 1.39626 → +2.0944 → +2.0944）
    ---  t=880+320k   GET_EXIT_ANGLE f0 + MOVE_DIR_TIME(60,ease4,f0,1.5)（只挪 Boss）
    ---  t=1020+320k  SUB_CALL 59 ×3（gi0=4、基准角 −1.39626 起）
    ---               i2_3 为奇数时再 SUB_CALL 60(gi0=20)
    ---               SET_PERIODIC_CALLBACK(9−k, 61)（每轮周期 −1，i3<5 后固定在 4）
    ---  t=1140+320k  JUMP 回 t=820
    ---
    ---sub59（原作 sub59）：4 层 ×6 速（8/6.5/5/3.5/2/0.5）的**瞄准两连扇**——count1=2、
    ---count2=1、speed2=0.5、angle2=π/2（⇒ 相对自机 ±45°）、angle1=0、flags=8304；
    ---每层打完把基准角 +8·gf2（±0.2094）再取模。弹上挂 cmd0 = 0x40(dur 80, loop 1,
    ---speed=当层基准角, angle=0.2)：沿向线性刹停 80 帧后「角度 += 基准角、速度改 0.2」；
    ---之后依次轮到 cmd2 = 0x20(dur 120, speed 0.006, angle gf2)、cmd3 = 0x10(dur 60,
    ---speed 0.03)（`Bullet::RunCommands` 里 flag==0 的段要等 exFlags 清空才激活）。
    ---cmd1 是 0x2000 spawnDelay（`BulletManager.cpp:437`），本仓库无此原语，略（差异 67）。
    ---
    ---sub60（原作 sub60）：RING_ABS 整圈 count1=gi0 发（count2=1、angle1=angle2 里只用
    ---angle1=0、速度 0.5、flags=8240），弹上 cmd0 = 0x20(dur 80, speed 0.02, angle 0) 与
    ---cmd2 = 0x10(dur 80, speed f0)：先 80 帧「速度 +0.02/帧」，再沿当前朝向以 f0 加速 80 帧。
    ---
    ---sub61（原作 sub61，周期回调）：随机位置（TH07 x∈[0,384)、y∈[64,224) ⇒ 我们
    ---x∈[−192,192)、y∈(0,160]）打一对上下直飞的弹（angle1=π/2、count1=2、flags=36，
    ---速度 rand(0.7)+0.4）。
    scard("桜符「完全なる墨染の桜 -開花-」", 4400, 99, 6000, false, function(self)
        ---sub60：整圈 count1=n 的两段指令弹。
        local function ring60(n, acc)
            sound4(self)                                  -- 原作 sub60 的 PLAY_SOUND 7
            shoot6(self, 0, 0, 67, 10, 1, n, 1, 0.5, 1, 0, 0.785398,
                   cmds4(8240,
                     { type = 0x20, flag = 0, dur = 80, loop = -1, speed = 0.02, angle = 0 },
                     { type = 0x10, flag = 0, dur = 80, loop = -1, speed = acc }), false)
        end
        ---sub59：4 层瞄准两连扇。base/rot 是 TH07 的弧度（rot = gf2）。
        local function fan59(off, base, rot)
            sound4(self)                                  -- 原作 sub59 的 PLAY_SOUND 7
            ---原作 sub59 的时间轴：每轮开始时 `SET_FLOAT *f1 *f3_1` **把 f1 复位成 gf1**，
            ---然后每发一炮就 `ADD_FLOAT *f1 *f1 *f2`（f2 = 8·gf2）——即 0x40 的转向量
            ---**逐发**递增（-80°、-92°、…、-140°），不是逐轮递增。旧代码把复位放在
            ---循环外、把递增放在内层之外，导致每轮 6 发共用同一转向量、且只用到 4 个值。
            ---cmd3（0x10，激活后沿冻结朝向加速）的 speed 是 ECL 的 `*f0`，而 sub59 在每轮
            ---末尾 `SUB_FLOAT *f0 *f0 0.01`（`#33`，L 行）——所以 4 轮的 0x10 加速度是
            ---0.03 / 0.02 / 0.01 / 0.0（E/N/H 是 `SUB_FLOAT *f0 *f0 0.008`，从 0.016 起）。
            local step = -rot * 8 * RAD2DEG               -- 每发 +8·gf2
            local a20 = -rot * RAD2DEG                    -- cmd2 0x20 的角速度
            local acc = 0.03                              -- cmd3 0x10 的加速度（L 行起手值）
            for _ = 1, 4 do
                local f1 = -base * RAD2DEG                -- 0x40 的转向量（我们的角度制）
                for _, v in ipairs({ 8, 6.5, 5, 3.5, 2, 0.5 }) do
                    shoot6(self, 0, 0, 64, 8, off, 2, 1, v, 0.5, 0, 1.5708,
                           cmds4(8304,
                             { type = 0x40, flag = 0, dur = 80, loop = 1,
                               angle = f1, speed = 0.2 },
                             { type = 0x20, flag = 0, dur = 120, loop = -1,
                               speed = 0.006, angle = a20 },
                             { type = 0x10, flag = 0, dur = 60, loop = -1, speed = acc }),
                           false)
                    f1 = (f1 + step + 180) % 360 - 180
                end
                acc = acc - 0.01
            end
        end
        ---GET_EXIT_ANGLE（`EclManager.cpp:1592`）：按自机相对位置随机挑一个飞行角，再按
        ---移动边界（我们这里的 `self._box`）修正；返回**我们的**角度制。原作
        ---「enemy->angle」取的是上一段移动的朝向（移植版用 _mv 的 dx/dy；`_mv` 已跑完
        ---时退回 0）。乱数用本仓 RNG，相位与原作不同（差异 68）。
        local function exit_angle(self)
            local a
            if player.x < self.x then
                a = (ran:Float(0, PI / 2) + 3 * PI / 4 + PI) % (2 * PI) - PI
            else
                a = ran:Float(0, PI / 2) - PI / 4
            end
            local b = self._box
            local ea = 0
            local mv = self._mv
            if mv and (mv.dx ~= 0 or mv.dy ~= 0) then
                ea = atan2(mv.dy, mv.dx) / RAD2DEG      -- 我们的角度制 → TH07 弧度
            end
            if self.x < b[1] + 96 then
                if a > PI / 2 then a = PI - a
                elseif a < -PI / 2 then a = -PI - a end
            end
            if b[2] - 96 < self.x then
                if a < PI / 2 and a >= 0 then a = PI - ea
                elseif a > -PI / 2 and a <= 0 then a = -PI - a end
            end
            if b[3] + 48 > self.y and a < 0 then a = -a end
            if b[4] - 48 < self.y and a > 0 then a = -a end
            return -a * RAD2DEG
        end
        ---sub61：一次周期回调 = 一对随机位置的上下直飞弹（TH07 x=rand(384)、
        ---y=rand(160)+64、speed=rand(0.7)+0.4，随机数顺序 i0→f6/f7→x→y→speed）。
        ---原作逐条（stage6 sub61）：
        ---  #0 `RAND_ADD *i0 4 1`（=rand(4)+1）——**死变量但必须照抽**；
        ---  #6/#10 `JLT *i2_3 6 / 3` 按轮数选 f6/f7（**小于才跳过**）：
        ---      轮>=6：f6=rand(0.02)、f7=rand(0.00628319)−0.00314159；
        ---      3<=轮<6：f6=0、f7=rand(0.00523599)−0.00261799；否则都 0；
        ---  #16 `INIT_BULLET_CMD 0 32 0 50 −1 *f6 *f7`（0x20：每帧 angle+=f7、speed+=f6，50 帧）；
        ---  #17..#22 x/y/speed；#23 `RING_ABS flags=36(0x24)` ⇒ 这发挂得上 0x20。
        ---原来只抽 x/y/speed 三次、也没挂 0x20，随机流从第一次 tick 起就与原作错位。
        local function tick61(k)
            ran:Int(1, 4)                              -- #0 RAND_ADD *i0 4 1
            local f6, f7 = 0, 0
            if k >= 6 then                             -- #6 `JLT *i2_3 6 → #10`（<6 才跳过）
                f6 = ran:Float(0, 0.02)                -- #7
                f7 = ran:Float(-0.00314159, 0.00314159) -- #8 RAND_FLOAT_ADD *f7 0.00628319 -0.00314159
            elseif k >= 3 then                         -- #10 `JLT *i2_3 3 → #14`（<3 才跳过）
                f7 = ran:Float(-0.00261799, 0.00261799) -- #12
            end                                        -- 否则 #14/#15：f6=f7=0（不抽）
            local ox = ran:Float(0, 384) - 192 - self.x
            local oy = 160 - ran:Float(0, 160) - self.y
            local spd = 0.4 + ran:Float(0, 0.7)
            shoot6(self, ox, oy, 67, 2, 4, 2, 1, spd, 1, 1.5708, 0,
                   cmds4(36, { type = 0x20, flag = 0, dur = 50, loop = -1,
                               speed = f6, angle = -f7 * RAD2DEG }), false)
        end
        ---周期回调 sub61：第 k 轮周期 = max(4, 9−k)，从 t=660+320k 起每周期打一次；
        ---第 k 轮的 tick 只落在 (660+320k, 660+320(k+1)] 区间里（落在下一轮重设帧上的
        ---那一次仍按**旧**周期，因为原作在帧首先做周期判定再执行 SET_PERIODIC_CALLBACK）。
        task.New(self, function()
            local now = 0
            local function at(t) task.Wait(t - now); now = t end
            for k = 0, 4000 do
                local F = 660 + 320 * k
                local per = 9 - k
                if per < 4 then per = 4 end
                local M = int(320 / per)
                for m = 1, M do
                    at(F + per * m)
                    tick61(k)
                end
            end
        end)
        ---★ 注意：cmp2 比的是**墙钟帧**。原作 t=120 处连跳三次难度分支（EclManager.cpp:944
        ---的 JNEQ 链），一口气把 ctx.time 推到 481 —— 所以「t=660 的第一次发弹」实际发生在
        ---第 300 帧（t − 360），「t=1020 的 SET_PERIODIC_CALLBACK」在第 660 帧。下面的
        ---task.Wait 一律按墙钟帧写（t=120 之后的偏移 = t − 360）。
        task.New(self, function()
            task.Wait(120)
            bmove(self, 120, 4, 0, 128)           -- 原作 t=120 MOVE_POS_TIME(120,ease4,192,96)
            task.Wait(119)                        -- → 墙钟第 239 帧（原作 t=600）
            self._box = box5(64, 48, 320, 96)
            bmove(self, 60, 4, 0, 128)            -- 原作 t=600 MOVE_POS_TIME(60,ease4,192,96)
            task.Wait(61)                         -- → 墙钟第 300 帧 = 原作 t=660 的第一次发弹
            do
                local acc = 0.04
                for _ = 1, 5 do ring60(42, acc); acc = acc - 0.012 end
            end
            task.Wait(160)                        -- 墙钟 460 = t=820（本轮第一组扇）
            local k = 0
            while true do
                fan59(2, 1.39626, 0.0261799)
                fan59(2, 1.39626 + 2.0944, 0.0261799)
                fan59(2, 1.39626 + 4.1888, 0.0261799)
                task.Wait(60)                     -- 墙钟 +60 = t=880：GET_EXIT_ANGLE + MOVE_DIR_TIME
                local ea = exit_angle(self)
                bmove(self, 60, 4, self.x + cos(ea) * 90, self.y + sin(ea) * 90)
                task.Wait(140)                    -- 墙钟 +200 = t=1020（本轮第二组扇）
                fan59(4, -1.39626, -0.0261799)
                fan59(4, -1.39626 + 2.0944, -0.0261799)
                fan59(4, -1.39626 + 4.1888, -0.0261799)
                if k % 2 == 1 then
                    local acc = 0.04
                    for _ = 1, 5 do ring60(20, acc); acc = acc - 0.012 end
                end
                task.Wait(120)                    -- 墙钟 +320 = 下一轮 t=820
                k = k + 1
            end
        end)
    end)

    ---──────────────────── 生存符卡「反魂蝶 -八分咲-」（原作 sub62 → 64/65/66/69 ＋ 67/68/70/71） ──────
    ---原作是 SURVIVAL 卡（`SET_IS_SURVIVAL_SPELLCARD 1`、`SET_TIMER_CALLBACK_THRESHOLD 4020`
    ---= 67s，打不死、只算撑满时限），移植成 wall=true（血量极大、关判定）。
    ---Lunatic 行的完整时间轴（墙钟＝原作 t：sub62 的难度链在 t=480 那一帧里连跳三次、
    ---L 行整块都落在同一帧，所以移植版帧号直接等于原作的 t）：
    ---  t=0    上一张卡的死亡回调起点（sub72 的开场演出；本卡从该点起算，演出不移植）；
    ---  t=480  MOVE_POS_TIME(120,ease4,192,96) → BEGIN_SPELLCARD「反魂蝶 -八分咲-」；
    ---  t=600  MOVE_POS_TIME(60,ease4,192,112)、SET_BULLET_SOUND 7 25；
    ---  t=660  主循环头：i2=28、i3=6、f2=0.5、f0=RNGRAD、i3_0=i3/2=3，
    ---         SPAWN_ENEMY_REL 67/68（左右两把挥刀子机），SUB_CALL 64（3 拍 × i2 发）；
    ---  t=670/680/690/700/710：f0 += π/i2 后交替 SUB_CALL 65（2 拍）/ 64（3 拍）；
    ---  t=830/860：SPAWN_ENEMY_REL 70（掉道具），gi0=32、gf1=±0.00523599、gf2=0.8 → SUB_CALL 66；
    ---  t=890/920：SPAWN_ENEMY_REL 71、gi0=38/40、gf1=±0.010472 → SUB_CALL 66；
    ---  t=920  GET_EXIT_ANGLE f0 ＋ MOVE_DIR_TIME(60,ease0,f0,0.2)（位移 0.2×60 = 12px）；
    ---  t=980  SUB_CALL 69（RING_SHIFT_ABS、sprite 10、count1=24）；f2+=0.08、i2+=3、i3+=2；
    ---  t=1075 JUMP 回 t=660 —— 一轮 415 帧。i2 每轮 +3（84/56 → 93/62 → 102/68 …）、
    ---         i3 每轮 +2、f2 每轮 +0.08；gi0 在 t=830..920 每轮被重置成 32/32/38/40，
    ---         所以 sub66 那四波每轮都是 162/162/198/210 发（= 3 拍 × (gi0−5) × 2 层）。
    ---sub64/65/66/69 挂同三条 INIT_BULLET_CMD（`EclManager.cpp:1329`）：
    ---  cmd0＝0x20：每帧 angle += 调用方放在 gf1 的值、speed += 0.01，跑满 120 帧清位；
    ---  cmd1＝0x2000：spawnDelay 200 —— 本仓没有「延迟出屏判定」的原语，略（差异 67）；
    ---  cmd2＝0x10：激活后每帧沿**激活时**的朝向加速 f0（`BulletManager.cpp:741`）。
    ---三段 flag 全 0、exFlags 初值 0 ⇒ cmd0 先生效；cmd0 清位后 cmd2 才被激活
    ---（`BulletManager.cpp:349` RunCommands）。flags=8752（0x2230）含 0x200 ⇒ 每波出生响一次。
    scard("「反魂蝶 -八分咲-」", 4401, 67, nil, true, function(self)
        ---GET_EXIT_ANGLE（`EclManager.cpp:1592`）：同 4400 的移植（差异 68：乱数用本仓 RNG，
        ---相位与原作不同）。
        local function exit_angle(self)
            local a
            if player.x < self.x then
                a = (ran:Float(0, PI / 2) + 3 * PI / 4 + PI) % (2 * PI) - PI
            else
                a = ran:Float(0, PI / 2) - PI / 4
            end
            local b = self._box
            local ea = 0
            local mv = self._mv
            if mv and (mv.dx ~= 0 or mv.dy ~= 0) then
                ea = atan2(mv.dy, mv.dx) / RAD2DEG
            end
            if self.x < b[1] + 96 then
                if a > PI / 2 then a = PI - a
                elseif a < -PI / 2 then a = -PI - a end
            end
            if b[2] - 96 < self.x then
                if a < PI / 2 and a >= 0 then a = PI - ea
                elseif a > -PI / 2 and a <= 0 then a = -PI - a end
            end
            if b[3] + 48 > self.y and a < 0 then a = -a end
            if b[4] - 48 < self.y and a > 0 then a = -a end
            return -a * RAD2DEG
        end

        ---sub64/65/66/69 的三条 INIT_BULLET_CMD（差异 67：0x2000 那条略）。
        ---gf1 是调用方放在 gf1 的常量（= 子程看到的 f3_1，0x20 的每帧转量，TH07 弧度）；
        ---f0 是这一拍 cmd2 的加速度。
        local function slash_cmds(gf1, f0)
            return cmds4(8752,
                { type = 0x20, flag = 0, dur = 120, loop = -1, speed = 0.01,
                  angle = -gf1 * RAD2DEG },
                { type = 0x10, flag = 0, dur = 80, loop = -1, speed = f0 })
        end

        ---sub64：RING_ABS（sprite 8 / 色档 3、count1=i2、count2=1、速度 gf2、扇心 gf0、
        ---张角 π/4）3 拍 —— 原作 DEC_JUMP 在同一帧里连跑 3 次；每拍 cmd2 的 f0 减 0.0325。
        local function sub64(i2, gf0, gf2)
            local f0 = 0.06
            for _ = 1, 3 do
                shoot6(self, 0, 0, 67, 8, 3, i2, 1, gf2, 1, gf0, 0.785398,
                       slash_cmds(0, f0), true)
                f0 = f0 - 0.0325
            end
        end

        ---sub65：同 sub64，但只有 2 拍、每拍 −0.065。
        local function sub65(i2, gf0, gf2)
            local f0 = 0.06
            for _ = 1, 2 do
                shoot6(self, 0, 0, 67, 8, 3, i2, 1, gf2, 1, gf0, 0.785398,
                       slash_cmds(0, f0), true)
                f0 = f0 - 0.065
            end
        end

        ---sub66：Lunatic 只跑 sd=08 的那条 RING_ABS（色档 1、count2=2、速度 0.8→0.3、
        ---张角 0）；sd=07 的前一条是 E/N/H 专用，按原作 gate 不移植。
        ---调用方的 gi0 先被 `SUB *i3_0 *i3_0 5` 减 5 才是 count1。
        local function sub66(gi0, gf0, gf1)
            local n = gi0 - 5
            local f0 = 0.06
            for _ = 1, 3 do
                shoot6(self, 0, 0, 67, 8, 1, n, 2, 0.8, 0.3, gf0, 0,
                       slash_cmds(gf1, f0), true)
                f0 = f0 - 0.0325
            end
        end

        ---sub69：RING_SHIFT_ABS（op69 = RING_ABS 再叠加起始偏置 π/count1）、sprite 10 /
        ---色档 0、count1=24、速度 gf2→1、扇心 π/2、张角 π/4、3 拍。
        local function sub69(gf2)
            local f0 = 0.06
            for _ = 1, 3 do
                shoot6(self, 0, 0, 69, 10, 0, 24, 1, gf2, 1, 1.5708, 0.785398,
                       slash_cmds(0, f0), true)
                f0 = f0 - 0.0325
            end
        end

        ---原作 sub67/68（挥刀子机）：在 boss 位置放 3 条 LASER_FIXED，之后 60 帧里
        ---每帧把这 3 条一起拧一点。逐条照抄（`i3_0 = 3` 由 sub62 的 `DIV *i3_0 *i3 2` 给出）：
        ---  · t=0  `f1 = π/i3_0`、`f2 = f1/2`、
        ---         `f0 = (sub67: f2+π/2 ／ sub68: π/2−f2)`、`f1 = 2·f1`；
        ---    循环 i3_0 次：`f2 = (sub67: f0+π/3 ／ sub68: f0−π/3)` → `NORMALIZE_ANGLE`
        ---                 → `LASER_FIXED(angle1 = *f2)`，再 `f0 = NORMALIZE(f0 + f1)`。
        ---    ⇒ sub67 的三条角 = π、5π/3、π/3；sub68 = 0、2π/3、4π/3（TH07 角）。
        ---  · t=0  `INIT_INTERP *f0 60 0 4 0 ∓π/3`（fn 0 = MathLerp、easing 4 = ease-out-quad），
        ---    随后 `i2_1 = 60` 帧的循环每帧先算 **本帧 f0 − 上帧 f0**（`f2 = f0 − f1`、
        ---    `f1 = f0`，这只做一次），再对内圈 `i2_0 = i3_0` 条激光各
        ---    `ADD_LASER_ANGLE k, *f2` —— 即三条**同时**按同一份「逐帧差分」拧。
        ---    ⇒ 总转角 = ∓π/3，但按 ease-out-quad 分布（先快后慢），不是匀速。
        ---LASER_FIXED 的固定参数（`EclManager.cpp:1378`）：speed 0、sOff 64、eOff/sLen 448、
        ---宽 16、展开 120 → 满 120 → 收 60 帧、判定 90..30。音：原作 sub67 PLAY_SOUND 13、
        ---sub68 PLAY_SOUND 16，都落在 se_lazer00 那一档（差异 71）。
        local function slash_sword(mirror)
            local live = {}
            local i30 = 3
            local f1 = PI / i30
            local f2 = f1 / 2
            local f0 = mirror and (PI / 2 - f2) or (f2 + PI / 2)
            f1 = f1 + f1
            for k = 1, i30 do
                local ang = mirror and (f0 - PI / 3) or (f0 + PI / 3)
                ang = norms6(ang)
                live[k] = plaser(self.x, self.y, -ang * RAD2DEG, {
                    spr = 1, w = 16, sOff = 64, eOff = 448, sLen = 448,
                    tStart = 120, dur = 120, tEnd = 60, hbStart = 90, hbEnd = 30 })
                f0 = norms6(f0 + f1)
            end
            PlaySound("lazer00", 0.13, self.x / 256)
            ---t=0 的 `INIT_INTERP`：dst f0、60 帧、fn0、easing 4、p0 = 0、p1 = ∓π/3。
            ---外圈共 60 轮（i2_1=60，DEC_JUMP 先减后跳）；第 0 轮的差分是 0
            ---（同帧 `SET_FLOAT *f0 0` 把 f0 压回 0，插值要到帧末才写回）。
            local target = mirror and (PI / 3) or (-PI / 3)
            task.New(self, function()
                local prev = 0
                for j = 0, 59 do
                    local u = j / 60
                    local e = 1 - (1 - u) * (1 - u)      -- easing 4 = ease-out-quad
                    local cur = target * e
                    local d = cur - prev
                    prev = cur
                    for k = 1, i30 do
                        local o = live[k]
                        if IsValid(o) then o.pl_ang = o.pl_ang + d * RAD2DEG end
                    end
                    task.Wait(1)
                end
            end)
        end

        ---原作 sub70/71（掉道具的子机）：`MOVE_ORBIT(120, X, Y, Z, f6, f7, 0, 1)` ——
        ---以出生点为中心、半径每帧 +1、起始角 f6、角速度 f7 地螺旋外飞；
        ---t=30 掉第一个、之后每 5 帧一个（DEC_JUMP 的 time=30、指令自身 t=35）——
        ---sub70 掉 30 个、sub71 掉 10 个。差异 70：道具类别按本仓口径折
        ---（8=小樱点→sakura、0=小能量→faith、1=点→point）。
        local function dropper(i0, f6, f7, n)
            local it = (i0 == 8) and item.obj.sakura
                    or (i0 == 0) and item.obj.faith or item.obj.point
            local cx, cy = self.x, self.y
            local da = f7 * RAD2DEG
            pspawn(cx, cy, function(o)
                local r, a = 0, f6 * RAD2DEG
                for _ = 1, 30 do
                    r = r + 1; a = a - da
                    o.x, o.y = cx + cos(a) * r, cy + sin(a) * r
                    task.Wait(1)
                end
                for k = 1, n do
                    New(it, o.x, o.y)
                    if k < n then
                        for _ = 1, 5 do
                            r = r + 1; a = a - da
                            o.x, o.y = cx + cos(a) * r, cy + sin(a) * r
                            task.Wait(1)
                        end
                    end
                end
            end)
        end

        ---主时间轴（墙钟 = 原作 t）。
        task.New(self, function()
            ---★ 原作 sub62 #2 `SUB_CALL 72` 的第一条就是 `RAND_FLOAT_ADD *f0 6.28319 -3.14159`
            ---  （接着 MOVE_DIR_TIME 60 4 *f0 0.15 让本体漂 9px）。粒子的演出无所谓，
            ---  但这枚角是真实消耗的，必须抽。
            local _ = rngrad()
            task.Wait(540)   -- 原作 sub62 先跑 t=0 的 SUB_CALL 72（60 帧演出）再等 480
            bmove(self, 120, 4, 0, 128)       -- 原作 t=480 MOVE_POS_TIME(120,4,192,96)
            task.Wait(120)                    -- → t=600
            bmove(self, 60, 4, 0, 112)        -- 原作 t=600 MOVE_POS_TIME(60,4,192,112)
            task.Wait(60)                     -- → t=660：主循环头
            local i2, i3, f2 = 28, 6, 0.5
            while true do
                self._box = box5(128, 96, 256, 128)   -- 原作 t=660 SET_MOVEMENT_BOUNDS
                local f0 = rngrad()
                local f4 = PI / i2
                slash_sword(false)            -- 原作 SPAWN_ENEMY_REL 67（左）
                slash_sword(true)             -- 原作 SPAWN_ENEMY_REL 68（右）
                sub64(i2, f0, f2)             -- t+0
                task.Wait(10)
                f0 = f0 + f4
                sub65(i2, f0, f2)             -- t+10
                task.Wait(10)
                f0 = f0 + f4
                sub64(i2, f0, f2)             -- t+20
                task.Wait(10)
                f0 = f0 + f4
                sub65(i2, f0, f2)             -- t+30
                task.Wait(10)
                f0 = f0 + f4
                sub64(i2, f0, f2)             -- t+40
                task.Wait(10)
                f0 = f0 + f4
                sub65(i2, f0, f2)             -- t+50
                task.Wait(120)                -- → t+170
                dropper(8, 3.14159, 0.0628319, 30)     -- 原作 t=830 SPAWN_ENEMY_REL 70
                sub66(32, rngrad(), 0.00523599)        -- t+170
                task.Wait(30)
                dropper(8, 0, -0.0628319, 30)          -- 原作 t=860 SPAWN_ENEMY_REL 70
                sub66(32, rngrad(), -0.00523599)       -- t+200
                task.Wait(30)
                dropper(0, 3.14159, 0.0628319, 10)     -- 原作 t=890 SPAWN_ENEMY_REL 71
                sub66(38, rngrad(), 0.010472)          -- t+230
                task.Wait(30)
                dropper(1, 3.14159, 0.0628319, 10)     -- 原作 t=920 SPAWN_ENEMY_REL 71
                sub66(40, rngrad(), -0.010472)         -- t+260
                local ea = exit_angle(self)            -- 原作 t=920 GET_EXIT_ANGLE → f0
                bmove(self, 60, 0, self.x + cos(ea) * 12, self.y + sin(ea) * 12)
                task.Wait(60)                          -- → t+320
                sub69(f2)                              -- 原作 t=980 SUB_CALL 69
                f2 = f2 + 0.08
                i2 = i2 + 3
                i3 = i3 + 2
                task.Wait(95)                          -- → 下一轮 t+660（一轮 415 帧）
            end
        end)
    end)


    ---════════════════════════════════════════════════════════════════════
    ---以下：stage5（魂魄妖夢）的符卡/非符移植（与原作 `ecldata5.ecl` 对齐）。
    ---
    ---原作 sub 链（全取 Lunatic 行；→ 左边是"入口"，括号里是它调用的子程序）：
    ---  进场(37) → 非符1(38→39+40+41) → 幽鬼剣/餓王剣(42→43+44) → 非符2(48→49+50+51)
    ---  → 獄神剣(57→58 周期 + 59/60) → 非符3(52→53+54) → 修羅剣(62→63+64+65)
    ---  → 畜趣剣(66→69→67/68) → 人神剣(70→71+72+73+74) → 天神剣(75→77→76)
    ---
    ---妖夢的招都是「本体 + 挥剑」：子程序先把斩击特效瞬移到某侧（SET_POS，只影响演出），
    ---在 TH07 (192,y) 处生成一条 384×32 的横斩判定（sub61；人神剣是 4412×32 的 sub74），
    ---再从屏幕另一端起每 2 帧炸开一环弹、或每 6 帧从顶上打一发。
    ---坐标/角度换算同文件头（x−192、224−y、θ 取反）。
    ---血量口径同文件头（非符 hpB(life−收尾阈值)、符卡 hpS(开卡 life)）。
    ---卡 id 段沿用 4390..4410：stage6 占 4390..4401，stage5 从 4402 起。
    ---
    ---**ECL 的 SUB_CALL 会冻结调用方 context 的 time**（`EclManager.cpp:2242` 只在当前
    ---context 走时间；sub 用的是它自己的 time）。所以「主时间轴 t=160 的 MOVE_DIR_TIME」
    ---在 sub 返回后还要再等 (160 − 调用点) 帧。移植版用 `task.Wait` 把这些空档补齐，
    ---各卡的循环周期因此与原作一致：非符 1 = 820 帧、非符 2 = 1076、非符 3 = 401、
    ---餓王剣 = 挥砍 206 帧 ×2 + 90×2、獄神剣 = 挥砍每 320 帧一组、修羅剣 = 260、
    ---畜趣剣 = 122×2、人神剣 = 42、天神剣 = 120。
    ---
    ---实测（6 种子 20260916/11111/98765/55555/31415/777，`2400 --threat` 取最坏）：
    ---  4402 6.1~7.1 / 死局 2.8%   4403 7.5~7.7 / 0.5%   4404 4.4~6.6 / 0.2%
    ---  4405 0.6 / 0%   4406 7.2~8.0 / 0.4%   4407 4.5~5.9 / 0.4%
    ---  4408 8.5 / 0.5%   4409 8.9~10.0 / 1.3%   4410 5.6~7.0 / 0.2%
    ---   （格式：60px 内弹数平均 / 死局；全部 ≤ 3% 死局。）
    ---4405 的「60px 内平均」只有 0.6 是**原作就这样**：它每 6 帧才从画面顶端打一发慢弹
    ---（速度在 3.0 / 0.6 之间跳），压迫感来自 5 条 384×32 的横斩判定（`slash5`，
    ---实测「峰值同屏 对象 5」），而判定条不算「弹」，`--threat` 的弹数栏量不到。
    ---
    ---逐张与原作的差异（都是「本仓库场地 384 宽 / 弹样式代理」逼出来的近似）：
    ---  · 本仓库没有 TH07 那种「敌方判定条」，sub61/sub74/sub65 的横斩判定移植成一条
    ---    短命激光（`slash5`：宽 384 = 整屏；dur 默认 56 帧 = 原作 sub61 的寿命，
    ---    人神剣 sub74 传 30000 = 整张卡常驻）。
    ---  · 原作 INIT_BULLET_CMD 的 0x2000 段是 spawnDelay（`BulletManager.cpp:437`），
    ---    本仓库的 TH34_cmdbullet 没有这一支（写进 stages 会卡在第一段），故一律略去；
    ---    表现是「弹幕比原作稍早出现」。
    ---  · 本体瞬移（幽鬼剣 sub43/44、獄神剣 sub59/60 的 SET_POS）只搬弹幕与斩击判定，
    ---    本体留在原地（同 stage6 各卡）。
    ---  · 畜趣剣 L 行**原作就没有弹**：sub67/68 的发弹指令 `skipInstrOnDifficulty` 只置了
    ---    E/N 两位（`d=E`/`d=N`，`EclManager.cpp:934`），H/L 上两只轮子一枪不发。
    ---    移植照 L 行原样搬（只搬轮子出场/收场的演出，不补任何弹，详见该卡注释）。
    ---  · 修羅剣的「斩」（sub64）在原作里**一发弹都没有**，是 200 帧的挥刀音效演出，
    ---    移植版照此只保留「顿一下再朝自机突进」，不再伪造一组自机狙。
    ---════════════════════════════════════════════════════════════════════
    ---stage5 的默认立绘/进场（妖夢从下方升起，同原作 sub37）。
    local OPT5 = { skin = skin5, enter = enter5 }
    ---带起点/终点的进场（原作 MOVE_POS_TIME 的移植，参数是**我们的**坐标）。
    local function enter5at(x0, y0, t, x, y)
        return function(self)
            self._orb, self._mv = nil, nil
            self.x, self.y = x0, y0
            bmove(self, t, 4, x, y)
        end
    end
    ---TH07 `RAND_FLOAT_ADD v,lo,hi` = rand(0,lo) + hi（EclManager.cpp:990）。
    local function rf(lo, hi) return hi + ran:Float(0, lo) end
    ---SET_MOVEMENT_BOUNDS（TH07 口径）→ 我们的 {xmin,xmax,ymin,ymax}。
    function box5(lx, ly, ux, uy)
        return { lx - 192, ux - 192, 224 - uy, 224 - ly }
    end
    ---原作 sub61/sub74：TH07 (192,y) 处的一条横向斩击判定（打不到、只压自机）。
    ---原作是 384×32（人神剣 sub74 是 4412×32）的接触判定条，移植成一条短命激光：
    ---两侧各长出 width/2，所以 width ≥ 384 就盖满我们的场地。
    ---dur 默认 56 帧 = 原作 sub61 的寿命（`UNIMP` 在 t=56）；人神剣 sub74 是 30000。
    local function slash5(y, width, dur)
        width = width or 384
        plaser(-width / 2, y, 0, { spr = 4, w = 32, sOff = 0, eOff = width,
                                   sLen = width, tStart = 0, dur = dur or 56, tEnd = 12,
                                   hbStart = 0, hbEnd = 4 })
    end
    ---INIT_BULLET_CMD 0x20（`BulletManager.cpp:759 UpdateBulletTargetAngle`）：
    ---每帧 angle += rate（原作弧度/帧，本仓库取反并转度）、speed += spd（px/帧²，**不取反**）。
    ---注意 spin6 是「传减速量、内部写 speed=-(dec)」，对 0x20 这种**带号**的加速段不合适 ——
    ---幽鬼剣那两条指令一条 +0.015、一条 −0.01，符号必须照搬，所以单开一个。
    local function acc20(rate_th, spd, dur)
        return { type = 0x20, dur = dur or 90, loop = -1,
                 speed = spd, angle = -rate_th * RAD2DEG }
    end

    ---──────────────────── 妖夢 非符 1（原作 sub38/39/40/41） ────────────────────
    ---两次「收缩螺旋 + 自机狙扇」：从半径 128 / 160 的轨道上边收半径、边左右摆动
    ---（两条相反的 ±sin 切线）地，每 6 帧一组（第 0/3 帧各一发）打一组以自机
    ---方向为心的扇；扇内弹数 li0 从 1 起每拍 +3、到 13 封顶。
    ---之后四段「屏幕外的点爆发」（sub40 从右半 / sub41 从左半）：各 16 个随机点，
    ---每个点打 4 层自机狙（sub40 每层 1 发、sub41 每层 2 发、张角 18°/22.5°），
    ---点沿屏幕横向滑 24px、纵向每步收 lf2/8。
    ncard("妖夢 非符 1", 4402, 15000, 1500, function(self)
      task.New(self, function()
        ---原作 sub39：半径 l3f0、双色档（gI0/gI1）的收缩螺旋 + 自机狙扇。
        local function spiral(radius, colA, colB)
            local a1 = aimth(self)
            local ca, sa = math.cos(a1), math.sin(a1)
            local pa = -sa
            local r, dr, ph, c1 = radius, radius / 16, 0, 1
            for _ = 1, 16 do
                for step = 0, 1 do
                    local wob = math.sin(ph) * radius
                    if step == 1 then wob = -wob end
                    shoot6(self, r * ca + wob * pa, -(r * sa + wob * ca), 65, 3,
                           (step == 0) and colA or colB, c1, 1, 1.4, 1, a1, 0.174533,
                           nil, true)
                    r, ph = r - dr, ph + 0.0981748
                    task.Wait(3)
                end
                if c1 < 12 then c1 = c1 + 3 end
            end
        end
        ---原作 sub40/sub41：屏幕外 16 个随机点，每个 4 层的自机狙。
        local function burst(right, c1, a2)
            ---原作 sub40/sub41：t=0 先 SUB_CALL 2（16 帧阻塞），再每 2 帧一发共 16 发，
            ---t=2 空跳 + t=3 SUB_RET ⇒ 子程墙钟 49 帧（和幽幽子非符 1 的 sub21/22 同型）。
            task.Wait(16)
            ---★ 原作 sub40/sub41 的 #7/#8（两个 RAND_FLOAT_ADD）排在 #3 的 SUB_CALL 2
            ---（16 帧阻塞）**之后**，所以抽头也要等 16 帧才发生。
            local x0 = rf(32, right and 368 or -16)
            local y0 = rf(128, -64)
            local dy = y0 / 8
            for _ = 1, 16 do
                ---★ 原作是 SPREAD_AIMED（op 64，加自机狙角），不是 SPREAD_ABS。
                shoot_abs6(self, x0 - 192, self.y - y0, 64, 6, right and 6 or 2,
                           c1, 4, 5, 1, 0, a2, nil, true)
                x0, y0 = x0 + (right and -24 or 24), y0 - dy
                task.Wait(2)
            end
            task.Wait(1)
        end
        task.Wait(60)
        self._box = box5(32, 48, 352, 128)
        ---原作 sub38 的主时间轴（一轮 820 帧）：两次螺旋各 96 帧，中间的主时间空档
        ---100/60/90/60/50/30/10/100 帧照抄（SUB_CALL 期间主 context 的 time 不走，
        ---所以这些空档是**额外**的，移植版用 task.Wait 补上）。
        while true do
            spiral(128, 8, 13)              -- t=60 起，96 帧
            task.Wait(100)                  -- 到 t=160
            drift(self, 1.5, 60)            -- t=160..220
            task.Wait(60)                   -- 到 t=220
            spiral(160, 11, 14)             -- 96 帧
            task.Wait(90)                   -- 到 t=310
            drift(self, 1.5, 60)            -- t=310..370
            task.Wait(60)                   -- 到 t=370
            burst(true, 1, 0.392699)        -- sub40，32 帧
            drift(self, 2.5, 50)
            task.Wait(50)                   -- 到 t=420
            burst(false, 2, 0.523599)       -- sub41
            drift(self, 2.5, 30)
            task.Wait(30)                   -- 到 t=450
            burst(true, 1, 0.392699)
            drift(self, 2.5, 10)
            task.Wait(10)                   -- 到 t=460
            burst(false, 2, 0.523599)
            drift(self, 1.5, 60)
            task.Wait(100)                  -- 到 t=560，JUMP 回 t=60
        end
      end)
    end, OPT5)

    ---──────────────────── 符卡 餓王剣「餓鬼十王の報い」（原作 sub42 → 43/44） ────────────────────
    ---Lunatic 行：sub42 的 t=0 三连 JNEQ 在同一帧里跳到 t=360（所以 t=360 那一整块
    ---的墙钟起点就是 sub42 的 t=0），本体 MOVE_POS_TIME(120,4,320,256) 落到画面右侧，
    ---t=480 进主循环。主循环那 8 条 SET_FLOAT/SUB_CALL 里只有两条是 L 行的
    ---（skipdiff 0xc）：gf0=64 → SUB_CALL 44（左挥砍）、gf0=320 → SUB_CALL 43（右挥砍）；
    ---其余（skipdiff 0x3）是 E/N 行的 SET_WAIT_TIMER 90 + 镜像两次，L 上整段不执行 ——
    ---所以 L 的一轮 = 44 + 43 两个子程，中间**没有**停顿。
    ---sub43/44 的墙钟（实测 vm，相对子程起点）：t=0 先 SUB_CALL 2（sub2 的 i3_0 读的是
    ---刚写进 gI0 的 30 ⇒ 30×4 = 120 帧的音效/粒子）→ t=120 RUN_EX_INS 10（妖夢挥刀减速）
    ---→ t=170 SET_POS + SPAWN_ENEMY_ABS 61（TH07 (192,posY−7) 的 384×32 横斩判定）
    ---+ RUN_EX_INS 11（恢复速）→ t=200..230 共 16 拍、每拍 2 帧 → SUB_RET（+232 帧）。
    ---每拍两环：18 发（v=0.5、flags 8724 = 无 0x20 位 ⇒ RunCommands 跳过该段、直飞）
    ---+ 12 发（v=0.3、flags 8738 = 挂 slot1 的 0x20 段：每帧 angle += rngRadian/600、
    ---speed += 0.015，90 帧后清位）。两环的扇心各取一次新的 *RNGRAD。
    ---每拍的出膛 x 依次 ±24：sub43 从 rand(0,32)−16 起 **+24**（向 x 正方向扫），
    ---sub44 从 rand(0,32)+368 起 **−24**（向 x 负方向扫）—— 左右两个子程连 f0 的
    ---起步值和增量符号都是反的（原作 SUB_FLOAT/ADD_FLOAT 的差别）。
    ---差异 72：RUN_EX_INS 10/11（原作靠改游戏速度做的挥刀减速演出）本仓无原语，不移植；
    ---差异 67：INIT_BULLET_CMD slot0 的 `0x2000 spawnDelay 160` 略（只影响出屏回收）。
    scard("餓王剣「餓鬼十王の報い」", 4403, 50, 1500, false, function(self)
        ---sub43/44 的共用骨架（`startOff`/`step` 区分左右两个子程的 f0）。
        local function sweep(startOff, step)
            task.Wait(170)                     -- 子程 +0：SUB_CALL 2（120）+ t=20 + t=50
            slash5(self.y + 7)                 -- 原作 SPAWN_ENEMY_ABS 61 (192, posY−7)
            task.Wait(30)                      -- → 子程 +200
            local f0 = rf(32, startOff)        -- 原作 RAND_FLOAT_ADD f0 32 startOff
            for _ = 1, 16 do
                ---原作 SET_SHOOT_OFFSET(f0−posX)：出膛点是绝对 TH07 x = f0、y = posY。
                local ox = (f0 - 192) - self.x
                ---★ 随机流顺序：原作每拍是 #24（cmd 的 f7=RNGRAD/600）**先于** #29
                ---（RING 的 a1=RNGRAD），第二环同理 #33 先于 #38。原来把 a1 写在
                ---cmd 前面，两边的随机流虽同长却互相换了值 ⇒ 整卡扇心偏 ~0.12。
                local k1 = rngrad()                         -- #24
                local a1 = rngrad()                         -- #29
                shoot6(self, ox, 0, 67, 6, 6, 18, 1, 0.5, 1, a1, 0.392699,
                       cmds4(8724, acc20(k1 / 600, 0.015, 90)), true)
                local k2 = rngrad()                         -- #33
                local a2 = rngrad()                         -- #38
                shoot6(self, ox, 0, 67, 6, 6, 12, 1, 0.3, 1, a2, 0.392699,
                       cmds4(8738, acc20(k2 / 600, 0.015, 90)), true)
                f0 = f0 + step
                task.Wait(2)
            end
        end
        task.New(self, function()
            task.Wait(120)                     -- 原作 t=480 的 SUB_CALL 44
            while true do
                sweep(368, -24)                -- 原作 SUB_CALL 44（gf0=64，左挥砍）
                sweep(-16, 24)                 -- 原作 SUB_CALL 43（gf0=320，右挥砍）
            end
        end)
    end, { skin = skin5, enter = enter5at(0, 112, 120, 128, -32) })

    ---──────────────────── 妖夢 非符 2（原作 sub48/49/50/51） ────────────────────
    ---和 non-spell 1 同骨架，但起始半径是 l3f0 + l3f0/2 = 144（不是 96）、迭代 32 次、
    ---每拍弹数 +1，上限由调用方的 gI2 给（L 取 15 / 18）；爆发段速度 5.2。
    ---第二段（sub48 在 t=160 置 l2i3=1 之后）每个子拍多 `SET_WAIT_TIMER 2`，
    ---所以 sub49 的时长第一段 32×6、第二段 32×8 帧。
    ncard("妖夢 非符 2", 4404, 19000, 2000, function(self)
      task.New(self, function()
        ---原作 sub49：起始半径 144、每子拍收 6，li0 上限 = l3i2（L 取 15 / 18）；
        ---切向摆动在 X 方向额外乘 1.4（#8），Y 方向不乘 —— 照抄这个不对称。
        local function spiral(colA, colB, cap, tail)
            local a1 = aimth(self)
            local ca, sa = math.cos(a1), math.sin(a1)
            local r, dr, ph, c1 = 144, 6, 0, 1
            for _ = 1, 32 do
                for step = 0, 1 do
                    local wob = math.sin(ph) * 96
                    if step == 1 then wob = -wob end
                    shoot6(self, r * ca - 1.4 * wob * sa, -(r * sa + wob * ca), 65, 3,
                           (step == 0) and colA or colB, c1, 1, 1.6, 1, a1, 0.20944,
                           nil, true)
                    r, ph = r - dr, ph + 0.0981748
                    task.Wait(tail and 5 or 3)
                end
                if c1 < cap then c1 = c1 + 1 end
            end
        end
        local function burst(right, c1)
            ---原作 sub50/sub51：t=0 先 SUB_CALL 2（gI0=4 ⇒ 4×4=16 帧阻塞），
            ---再每 2 帧一发（t=0 的 SPREAD_AIMED、L 行只跑第 4 条 skipdiff 0x8：
            ---sprite 6:6 / 6:2、count1 = 3（sub50）/ 4（sub51）、count2 = 4、v=5.2→1、
            ---a1=0（自机狙）、a2=18°、flags 516）共 16 发，t=3 SUB_RET ⇒ 子程墙钟 49 帧。
            ---sub50 的 f0 = rand(0,32)+368、f0 **−=** 24；sub51 的 f0 = rand(0,32)−16、f0 **+=** 24；
            ---f2 = rand(0,128)−64、每拍 −= f2/8，出膛点是 (f0, posY+f2) 的绝对值。
            task.Wait(16)
            ---★ 原作 sub50/sub51 的 #7/#8 同样排在 SUB_CALL 2（16 帧阻塞）之后。
            local x0 = rf(32, right and 368 or -16)
            local y0 = rf(128, -64)
            local dy = y0 / 8
            for _ = 1, 16 do
                shoot_abs6(self, x0 - 192, self.y - y0, 64, 6, right and 6 or 2,
                           c1, 4, 5.2, 1, 0, 0.314159, nil, true)
                x0, y0 = x0 + (right and -24 or 24), y0 - dy
                task.Wait(2)
            end
            task.Wait(1)
        end
        task.Wait(60)
        self._box = box5(32, 48, 352, 128)
        ---原作 sub48 的主时间轴（一轮 1076 帧），空档与 non-spell 1 同型。
        while true do
            spiral(8, 13, 15, true)         -- t=60 起：i2_3=0 ⇒ 每拍 10 帧，320 帧
            task.Wait(100)                  -- 到 t=160
            drift(self, 1.5, 60)            -- t=160..220
            task.Wait(60)                   -- 到 t=220
            spiral(10, 14, 18, false)       -- i2_3=1 ⇒ 每拍 6 帧，192 帧
            task.Wait(90)                   -- 到 t=310
            drift(self, 1.5, 60)            -- t=310..370
            task.Wait(60)                   -- 到 t=370
            burst(true, 3)                  -- sub50，32 帧
            drift(self, 2.5, 50)
            task.Wait(50)                   -- 到 t=420
            burst(false, 4)                 -- sub51
            drift(self, 2.5, 30)
            task.Wait(30)                   -- 到 t=450
            burst(true, 3)
            drift(self, 2.5, 10)
            task.Wait(10)                   -- 到 t=460
            burst(false, 4)
            drift(self, 1.5, 60)
            task.Wait(100)                  -- 到 t=560，JUMP 回 t=60
        end
      end)
    end, OPT5)

    ---──────────────────── 符卡 獄神剣「業風神閃斬」（原作 sub57/58/59/60） ────────────────────
    ---本体落到左侧 (48,192)→(−144,32)。除「五连横斩」外，还有一条常驻周期子程序
    ---（L 的 period=6）：每 6 帧从画面顶端正中 (192,32)→(0,192) 打一发沿 lf0 缓慢
    ---转动的弹。原作 sub58 每次调用都做 `lf1 = 3.6 − lf1`（首值 0.6 ⇒ 3.0 / 0.6
    ---交替，**慢弹几乎停在原地**）；`li0 = li0 % 64` 每调用 +1 ⇒ 前 32 发基准角
    ---每拍 +0.104311、后 32 发 −0.104311（转到头再转回来）。
    ---五连横斩（原作 sub59/60）在 TH07 posY+{7,49,−63,105,−119} 五个高度各生成
    ---一条 384×32 判定；一次挥砍含 120 帧蓄力（sub2 音效特效），两侧各一次、
    ---同一侧的两组相隔 320 帧（= 挥砍 202 + SET_WAIT_TIMER 90 折算）。
    scard("獄神剣「業風神閃斬」", 4405, 55, 2000, false, function(self)
        task.New(self, function()
            ---L 行沿难度链在 t=360→480 只等满 120 帧（同 stage6 各卡）。
            task.Wait(120)                       -- 原作 t=360→480
            ---原作 sub58：从画面顶端打单发旋转弹（period=6，L 速在 3.0/0.6 间跳）。
            task.New(self, function()
                local lf0, lf1, li0 = -0.0981748, 0.6, 0
                task.Wait(6)                     -- SET_PERIODIC_CALLBACK 6 58 后第 6 帧首调
                while true do
                    lf1 = 3.6 - lf1
                    shoot_abs6(self, 0, 192, 67, 10, 1, 1, 1, lf1, 1, lf0, 0.392699,
                               nil, true)
                    lf0 = lf0 + (((li0 % 64) < 32) and 0.104311 or -0.104311)
                    li0 = li0 + 1
                    task.Wait(6)
                end
            end)
            bmove(self, 60, 4, -144, 32)         -- 原作 t=480 MOVE_POS_TIME(60,4,48,192)
            local OFFS = { -7, -49, 63, -105, 119 }
            ---原作主循环（`JUMP 570 -112`）：t=570 SUB_CALL 59（110 帧，内部 t=50 落斩）
            ---→ 等 90 帧 → t=660 SUB_CALL 60（同样 110 帧 / t=50 落斩）→ 等 90 帧 → 回 t=570。
            local function slashbar()
                task.Wait(50)                    -- sub59/60 的 t=50
                for _, o in ipairs(OFFS) do slash5(self.y + o) end
                task.Wait(60)                    -- sub59/60 的 t=110 SUB_RET
            end
            task.Wait(90)                        -- t=480 → 570
            while true do
                slashbar()                       -- sub59
                task.Wait(90)                    -- t=570 → 660
                slashbar()                       -- sub60
                task.Wait(90)                    -- t=660 → 750 JUMP 回 570
            end
        end)
    end, OPT5)

    ---──────────────────── 妖夢 非符 3（原作 sub52/53/54） ────────────────────
    ---t=40 瞬移到自机所在那一侧（X≥192 ⇒ TH07 (256,96)，否则 (128,96)）；t=100 起
    ---循环（一轮 422 帧）：SUB_CALL 53 → 漂移 60 帧 → SUB_CALL 53 → SUB_CALL 54
    ---→ SUB_CALL 53 → 漂移，到 t=280 JUMP 回 t=100。gi0/gi1 在每次 SUB_CALL 前
    ---设好，就是 sub53 里 i3_0/i3_1 两个色档（8/13 → 2/6 → 2/6）。
    ---sub53（扇）：8 拍 × 8 帧，i0 从 1 涨到 8。每拍 t=0 用两色各射 i0 发速度 2、
    ---张角 A2P±0.448799±0.261799；t=4 同两色各射 i0 发「5.3→1 四层」速度、
    ---张角 A2P±0.448799±0.0981748，再补一圈 16 发速度 4、角度 A2P−π、张角 0.19635
    ---（0x01/0x02/0x04 的三档低难度指令在 Lunatic 被跳过，只剩 0x08 那一档）。
    ---sub54：先跑 sub2 等 4×4=16 帧，再自 −32 偏移**每帧 1 发**连射 8 发
    ---（速度 1.2+0.25k），然后自 +32 偏移**每 2 帧 1 发**连射 8 发，最后归零偏移。
    ncard("妖夢 非符 3", 4406, 15000, 2000, function(self)
      task.New(self, function()
        ---原作 sub53：两侧各一串「逐渐长大的扇」+ 背后 16 发环。
        local function fan(colA, colB)
            local a0 = aimth(self)
            local aL, aR, aB = a0 + 0.448799, a0 - 0.448799, a0 - 3.14159
            local c1 = 1
            for _ = 1, 8 do
                shoot6(self, 0, 0, 65, 3, colA, c1, 1, 2, 1, aL, 0.261799, nil, true)
                shoot6(self, 0, 0, 65, 3, colB, c1, 1, 2, 1, aR, 0.261799, nil, true)
                task.Wait(4)
                shoot6(self, 0, 0, 65, 3, colB, c1, 4, 5.3, 1, aL, 0.0981748, nil, true)
                shoot6(self, 0, 0, 65, 3, colA, c1, 4, 5.3, 1, aR, 0.0981748, nil, true)
                shoot6(self, 0, 0, 65, 3, colA, 16, 1, 4, 1, aB, 0.19635, nil, true)
                c1 = c1 + 1
                task.Wait(4)
            end
        end
        ---原作 sub54：sub2 的 16 帧 + t=10 的 10 帧 → 314 帧起两串自机狙。
        local function volley()
            task.Wait(26)
            for k = 0, 7 do                     -- 左串：−32 偏移，每帧 1 发
                shoot6(self, -32, 0, 64, 9, 3, 1, 1, 1.2 + 0.25 * k, 1, 0, 0.261799, nil, true)
                task.Wait(1)
            end
            for k = 0, 7 do                     -- 右串：+32 偏移，每 2 帧 1 发
                shoot6(self, 32, 0, 64, 9, 1, 1, 1, 1.2 + 0.25 * k, 1, 0, 0.261799, nil, true)
                task.Wait(2)
            end
        end
        task.Wait(40)                           -- t=40 位移
        bmove(self, 40, 4, (self.x >= 0) and 64 or -64, 128)
        task.Wait(60)                           -- 到 t=100
        self._box = box5(32, 48, 352, 128)
        while true do
            fan(8, 13)                          -- SUB_CALL 53（t=100，64 帧）
            drift(self, 1.5, 60)                -- t=100 的 MOVE_DIR_TIME(60,4,f0,1.5)
            task.Wait(60)                       -- 到 t=160
            fan(2, 6)                           -- SUB_CALL 53（64 帧）
            volley()                            -- SUB_CALL 54（50 帧）
            fan(2, 6)                           -- SUB_CALL 53（64 帧）
            drift(self, 1.5, 60)                -- t=160 的 MOVE_DIR_TIME(60,4,f0,1.5)
            task.Wait(120)                      -- 到 t=280，JUMP 回 t=100
        end
      end)
    end, OPT5)

    ---──────────────────── 符卡 修羅剣「現世妄執 -Lunatic-」（原作 sub62/63/64） ────────────────────
    ---本体在场上横向游走。真正会「打人」的只有常驻的 sub63：一架不动的发射器
    ---（t=330 出生，`SET_HAS_NO_COLLISION 1`、不会消失）每 4 帧从 TH07 x=−4 / x=388
    ---各射一发水平弹（高度各自随机 ∈[0,448)、L 速 0.5+rand(0,0.9)；两发相隔 2 帧），
    ---把整屏切成一条条水平扫描线。
    ---每 260 帧一次的「斩」（原作 sub64）**一发弹都没有**：它是 120 帧蓄力（sub2 音效
    ---特效）+ 210 帧挥刀音效/演出（`RUN_EX_INS`），只把一条 24×24 的装饰判定（sub65）
    ---落在本体处；随后 `MOVE_POS_TIME 60` 朝自机突进。移植版照此只保留「顿一下再突进」。
    scard("修羅剣「現世妄執 -Lunatic-」", 4407, 60, 2000, false, function(self)
        task.New(self, function()
            ---原作 t=330 出生（L 行 t=240 在难度链跳转后落在第 120 帧，故 t=330 = 第 210 帧）。
            task.Wait(210)
            task.New(self, function()
                while true do
                    ---★ 原作 sub63 的 t=0 三条随机数**同帧**抽：#6 X 左、#9 速度 左、#12 X 右
                    ---（#12/#13 都在 t=0）；只有右侧那一环是 t=2 才打（#16）。
                    ---旧版把 #12 挪到 t=2 才抽，逐帧随机流错位。
                    local xl = ran:Float(0, 448)
                    local vl = 0.5 + ran:Float(0, 0.9)
                    local xr = ran:Float(0, 448)
                    shoot_abs6(self, -196, 224 - xl, 67, 1, 6, 1, 1,
                               vl, 1, 0, 0.392699, nil, true)
                    task.Wait(2)
                    shoot_abs6(self, 196, 224 - xr, 67, 1, 2, 1, 1,
                               0.5 + ran:Float(0, 0.9), 1, 3.14159, 0.392699, nil, true)
                    task.Wait(2)
                end
            end)
            ---原作 t=450 SUB_CALL 64：实测子程 340 帧（t=0 的 SUB_CALL 2 =120、
            ---t=10 的 DEC_JUMP 11 拍 ×10、t=20 的 DEC_JUMP 5 拍 ×10、t=80 前再等 60）。
            ---之后 MOVE_POS_TIME(60,4,*PX,*Y)，再等 60 帧到 t=510 的 `JUMP 450 -48`：
            ---一轮 340+60=400 帧，首次落在第 330 帧（t=450）。
            task.Wait(120)                        -- t=330 → 450
            while true do
                task.Wait(340)                    -- sub64 的 340 帧演出（无弹）
                bmove(self, 60, 4, player.x, self.y)
                task.Wait(60)
            end
        end)
    end, OPT5)

    ---──────────────────── 符卡 畜趣剣「無為無策の冥罰」（原作 sub66/69） ────────────────────
    ---原作 sub66 的 **Lunatic 行**既不声明符卡、轮子也一枪不发：sub67/sub68 的发弹指令
    ---（SPREAD_ABS）`skipInstrOnDifficulty` 只置了 E/N 两位（0x01/0x02，`EclManager.cpp:934`），
    ---H/L 上整条跳过；原作 H/L 这一格走的是「修羅剣」那一支（sub52 的
    ---`SET_*_CALLBACK_SUB` 0x0c → 62），畜趣剣本体只在 E/N 出现。本移植沿用文件头
    ---「全取 Lunatic 行」的口径，照抄 L 行的行为：轮子的出场/收场演出全搬，**不补原作
    ---H/L 没有的弹**（此前的「按 N 行补 4×2×5」是伪作，已删）。
    ---时间轴（原作 sub66 L 分支）：
    ---  t=240 SET_CAN_BE_DAMAGED 1 / SET_INVINCIBILITY_TIMER 240,360 / SET_ANM 128 /
    ---        f0=−0.0981748 / f1=0.6 / i0=0；
    ---  t=260 起无限循环：gf0=64 → SUB_CALL 69 → gf0=320 → SUB_CALL 69 → JUMP 回 t=260。
    ---sub69：SUB_CALL 2（gi0=30 ⇒ 等 30×4=120 帧）→ SET_POS(gf0,224) 把本体挪到目标点，
    ---再从「进 sub69 那一刻本体的 X」到 gf0 之间、以 (gf0−X)/8 为步长每 6 帧交替
    ---spawn sub67/sub68 共 5 对 10 只；最后一对落位再等 12 帧（t=122）SUB_RET。
    ---sub67/68（轮子）：出生贴图 146/147，t=120 起每 12 帧一拍共 5 拍（L 行每拍只把
    ---`shootOffset.y` ±32，无弹），t=180 `UNIMP` 自毁。
    scard("畜趣剣「無為無策の冥罰」", 4408, 60, 2000, false, function(self)
        task.New(self, function()
            ---原作 sub67/68：只留下「活 180 帧」的时间轴（L 行无弹）。
            local function wheel()
                task.Wait(120)                      -- t=120 装上发弹偏移（L 行不发射）
                ---★ 原作 sub67 #8 的 `RAND_FLOAT_ADD *f1 -0.1309 0.523599` 是 sd=ALL，
                ---  E/N 的 SPREAD 才被 gate；L 行不发弹但**这枚角照抽**（每条命都抽）。
                local _ = ran:Float(0.392699, 0.523599)
                for _ = 1, 5 do task.Wait(12) end   -- t=132/144/156/168/180
            end
            ---原作 sub69：从 x0=进 sub69 时的本体 X 到 gf0 铺一排轮子。
            local function wheels(gx, gy)
                local x0 = self.x                   -- 原作 #5：f0 = X
                task.Wait(120)                      -- 原作 SUB_CALL 2
                self.x, self.y = gx, gy             -- 原作 SET_POS(gf0, gf1)
                local step = (gx - x0) / 8          -- 原作 f1 = (gf0 − X)/8
                local x = x0
                for _ = 1, 5 do
                    pspawn(x, 0, wheel)             -- SPAWN_ENEMY_ABS 67 @(f0,224)
                    x = x + step
                    task.Wait(6)                    -- 原作 t=50 → 56
                    pspawn(x, 0, wheel)             -- SPAWN_ENEMY_ABS 68 @(f0,224)
                    x = x + step
                    task.Wait(6)                    -- 原作 t=62 的 DEC_JUMP ⇒ 下一拍
                end
                task.Wait(12)                       -- 原作 t=110 → 122（PLAY_SOUND/SUB_RET）
            end
            task.Wait(260)                          -- 原作 t=240 的装填 + 到 t=260
            while true do
                wheels(-128, 0)                     -- gf0=64  (TH07) → 我们 −128
                wheels(128, 0)                      -- gf0=320 (TH07) → 我们 +128
            end
        end)
    end, OPT5)

    ---──────────────────── 符卡 人神剣「俗諦常住」（原作 sub55/70/71/72/73） ────────────────────
    ---原作 sub70：t=540 在 (192,posY+16)（我们 self.y−16）落一条**4412×32 的常驻判定**
    ---（sub74，`UNIMP` 在 t=30000 ⇒ 整张卡都在），等于把屏幕在那一行切成上下两半；
    ---随后本体落到左上 (48,96)→(−144,128)。
    ---常驻一条「底部雨」（sub72）：每 3 帧从屏幕**下边缘之外**（TH07 y∈[420,452)）
    ---随机 x 打一发向上的弹（速度 0.3 + rand(0,lf3)，lf3 从 0.8 起每发 +0.001）。
    ---再有一组 sub73：从 t=720 起每 42 帧一次（32 帧 16 拍 + 10 帧空档），
    ---每拍「3 发 + 6 发」，速度 0.5 起每拍 +0.3（L）、张角每拍 −0.0272708。
    scard("人神剣「俗諦常住」", 4409, 66, 4400, false, function(self)
        task.New(self, function()
            ---L 行：t=480 落在第 120 帧；t=540 SUB_CALL 71（126 帧）**阻塞**，
            ---所以 t=540 剩下的 MOVE_POS_TIME / SPAWN_ENEMY_ABS 72 都在第 306 帧才执行
            ---（sub74 的判定条在 sub71 内部 t=50 ⇒ 第 230 帧）。
            task.Wait(180)                        -- t=540
            task.Wait(50)
            slash5(self.y - 16, 448, 30000)       -- 原作 sub71 t=50 的 SPAWN_ENEMY_ABS 74
            task.Wait(76)                         -- sub71 余下 76 帧 → 第 306 帧
            bmove(self, 120, 4, -144, 128)        -- 原作 t=540 MOVE_POS_TIME(120,4,48,96)
            ---原作 sub72：每 3 帧从底部（屏幕外）随机 x 打一发向上的弹。
            task.New(self, function()
                ---原作 sub72 的等待是**两条 SET_WAIT_TIMER 叠加**：`SET_WAIT_TIMER *i0`
                ---（i0 初值 4、每 60 发 `DEC` 一次、到 0 为止）之后还有 `SET_WAIT_TIMER 3`，
                ---所以间隔 = i0 + 3（首 60 发 7 帧，逐档 6/5/4，之后恒 3）。
                local lf3, li0, li3 = 0.8, 4, 0
                while true do
                    ---原作 sub72 每轮先抽两个**用不着的**随机数（#12 `RAND_FLOAT *f0 448`、
                    ---#14 `RAND_FLOAT_ADD *f2 0.5 0.5`，随后都被覆盖），再抽真正的 x
                    ---（#15）、y（#16）、速度（#18）。少抽这两个会让随机流与原作错位，必须补上。
                    ran:Float(0, 448)
                    ran:Float(0, 0.5)
                    local xth = ran:Float(0, 384)
                    local yth = 420 + ran:Float(0, 32)
                    shoot_abs6(self, xth - 192, 224 - yth, 67, 2, 6, 1, 1,
                               0.3 + ran:Float(0, lf3), 1, -1.5708, 0.392699, nil, true)
                    li3 = li3 + 1
                    lf3 = lf3 + 0.001
                    if (li3 % 60) == 0 and li0 > 0 then li0 = li0 - 1 end
                    task.Wait(li0 + 3)
                end
            end)
            task.Wait(120)                        -- t=660 → 第 426 帧
            self._box = box5(32, 48, 352, 112)
            drift(self, 1.5, 60)                  -- 原作 t=660 GET_EXIT_ANGLE + MOVE_DIR_TIME 60
            task.Wait(60)                         -- t=720 → 第 486 帧
            ---原作主循环：SUB_CALL 73（62 帧）→ 等 10 帧到 t=730 → `JUMP 660 -68`
            ---回到 t=660（GET_EXIT_ANGLE + MOVE_DIR_TIME 60）→ 等 60 帧到 t=720。一轮 132 帧。
            while true do
                local a0 = aimth(self)            -- 原作 sub73 t=30 的 SET_FLOAT *f0 *A2P
                local sp, a2 = 0.5, 0.785398
                task.Wait(30)                     -- sub73 t=0→30 的演出
                for _ = 1, 16 do
                    shoot6(self, 0, 0, 65, 7, 1, 3, 1, sp, 1, a0, a2, nil, true)
                    shoot6(self, 0, 0, 65, 7, 1, 6, 1, sp, 1, a0 + PI, 0.523599, nil, true)
                    sp, a2 = sp + 0.3, a2 - 0.0272708
                    task.Wait(2)
                end
                task.Wait(10)                     -- t=730 → JUMP 回 t=660
                drift(self, 1.5, 60)
                task.Wait(60)
            end
        end)
    end, OPT5)

    ---──────────────────── 符卡 天神剣「三魂七魄」（原作 sub75/76/77） ────────────────────
    ---原作 sub75 的四个难度分支是**同一帧连跳三次**（每次 JNEQ 都把 context 的 t 重置成
    ---目标行自己的 t），所以 L 行整段设置在卡片第 60 帧就跑完（MOVE_POS_TIME 120 帧到
    ---(192,96) → 我们 (0,128)）；真正的循环从 t=540（第 180 帧）起，**180 帧一轮**：
    ---  SUB_CALL 77（60 帧）→ t=600 GET_EXIT_ANGLE + MOVE_DIR_TIME 60 4 f0 1.5 →
    ---  t=660 JUMP 回 t=540。每次 SUB_CALL 77 里 8 只魂在它的 t=20 同帧出生。
    ---sub77：先等 gi0=10×4=40 帧，再从本体同一点按自机方向 ±0 / ±0.628319 / ±1.25664 /
    ---  ±1.88496 八个角度各 spawn 一只 sub76（li0 色档 2/4/4/6/14/13/8/11），
    ---  L 行最后再补一组 3×2 自机狙（速度 3.5→1、张角 0.628319）。
    ---sub76（魂）：`MOVE_DIR_TIME t=0 spd=4.2` ⇒ 沿自己的方向**匀速直飞**（45 帧内是直线），
    ---  同时每帧一发：`i2` 先取 3−i2 再发射，所以层数从 2 起在 2/1 之间跳；
    ---  出膛点在「半径 f4（60 起每帧 −0.5）× 随机角」上，弹沿该随机角 +π、速度 1→0.4，
    ---  0x20 段 spd=+0.025（原作另有一条 0x2000 spawnDelay，本仓库无此原语，略，差异 67）。
    scard("天神剣「三魂七魄」", 4410, 66, 2000, false, function(self)
        task.New(self, function()
            task.Wait(60)                           -- 原作 t=420 的装填（同帧跳完）
            bmove(self, 120, 4, 0, 128)             -- 原作 MOVE_POS_TIME 120 4 *f3_0 *f3_1
            task.Wait(120)                          -- 到 t=540（第 180 帧）
            self._box = box5(64, 48, 320, 128)      -- SET_MOVEMENT_BOUNDS 64 48 320 128
            ---原作 sub76：一只「魂」。
            local function spirit(o, lf0, col)
                local dx, dy = math.cos(lf0), -math.sin(lf0)
                bmove(o, 45, 0, o.x + dx * 4.2 * 45, o.y + dy * 4.2 * 45)
                local lf4, li2 = 60, 1
                for _ = 1, 45 do                    -- i2_0 = 45（L 行）
                    ---★ 原作 sub76 #14 `RAND_SIGN_FLOAT *f5 0.0261799` 虽不参与发弹
                    ---   （f5 无人读），但它**要抽 1 个 u16**（EclManager.cpp:989-991）。
                    ---   漏掉它，本卡每帧的随机流就整体错位一格，从此所有子弹的
                    ---   落点全对不上（子机每帧 `RNGRAD` 抽的那一下会拿到下一格）。
                    local _ = ran:Sign()
                    local lf1 = rngrad()
                    li2 = 3 - li2                   -- 原作 #24 在 #25 之前
                    shoot6(o, math.cos(lf1) * lf4, -math.sin(lf1) * lf4, 65, 6, col,
                           1, li2, 1, 0.4, lf1 + PI, 0, acc20(0, 0.025, 60), true)
                    lf4 = lf4 - 0.5
                    task.Wait(1)
                end
            end
            ---★ 原作 sub77 的 f0 每条都从**基点 f1=A2P** 重算（不是逐条累加）：
            ---   #12 0 → #14 f1−0.628319 → #18 f1−1.25664 → #21 f1+0.628319 →
            ---   #24 f1+1.25664 → #28 f1−1.88496 → #31 f1+1.88496。
            local ANG = { 0, -0.628319, -0.628319, -1.25664,
                          0.628319, 1.25664, -1.88496, 1.88496 }
            local COL = { 2, 4, 4, 6, 14, 13, 8, 11 }
            task.Wait(60)                           -- 原作 sub77 的 SUB_CALL 2 + t=20
            while true do
                local a0 = aimth(self)
                for i = 1, 8 do
                    local a, col = a0 + ANG[i], COL[i]
                    pspawn(self.x, self.y, function(o) spirit(o, a, col) end)
                end
                ---原作 L 的最后一段：3×2 自机狙。
                shoot6(self, 0, 0, 64, 10, 0, 3, 2, 3.5, 1, 0, 0.628319, nil, true)
                task.Wait(60)                       -- 到 caller t=600
                drift(self, 1.5, 60)                -- GET_EXIT_ANGLE + MOVE_DIR_TIME 60
                task.Wait(120)                      -- 到 caller t=660 → JUMP 回 t=540
            end
        end)
    end, OPT5)

    ---════════════════════════════════════════════════════════════════════
    ---以下：stage3（爱丽丝·玛格特洛依德）的符卡/非符移植（原作 `ecldata3.ecl`）。
    ---
    ---原作 sub 链（全取 Lunatic 行）：
    ---  中 boss 非符(22→23→24/25/26) → 操符「乙女文楽 -Lunatic-」(27→28→29/30/31)
    ---  本体 非符1(32→33→34/35) → 蒼符「博愛のオルレアン人形」(42→43→44/45)
    ---       → 非符2(36→38/39/40) → 白符「白亜の露西亜人形 -Lunatic-」(48→49)
    ---       → 非符3(37→38/39/40) → 雅符「春の京人形」(54→55) → 咒詛「首吊り蓬莱人形」(56→57/58/59)
    ---
    ---坐标/角度/血量口径同文件头。**ECL 的 SUB_CALL 会冻结调用方的时间轴**（EclManager.cpp
    ---只在当前 context 走时间），所以各卡的循环周期不能用「ECL 里写的 t」直接读，一律
    ---用 /tmp/br34 的逐帧模拟器实测：非符1(中 boss)=600 帧、非符1(本体)=600、
    ---非符2=420、非符3=580；符卡的子机（蒼符/雅符/咒詛）在 boss 死后由 `spell_live` 一起清。
    ---卡 id 段：stage3 = 4430..4438。
    ---
    ---逐张与原作的差异（本仓库场地 384 宽 / 弹样式代理逼出来的近似）：
    ---  · 原作 BEGIN_SPELLCARD 的 Easy/Normal/Hard 行一律不用，只取 Lunatic 行的名字与数值；
    ---    蒼符在 L 上是「博愛のオルレアン人形」、白符是「-Lunatic-」、雅符「春の京人形」、
    ---    咒詛是「首吊り蓬莱人形」——都是原作 L 行的原名。
    ---  · 爱丽丝本体在符卡里会「瞬移换位」（原作 MOVE_POS_TIME / SET_POS），移植版只搬弹幕
    ---    与子机，本体留在原地（同 stage5/6 各卡）。
    ---  · 原作 3 面本体 sub36/sub37 的「非符」其实很短（sub36 的 SET_LIFE 只有 2000），
    ---    这里是把它按一般非符的规模补成可独立挑战的一张卡（血量沿用非符1 的口径）。
    ---════════════════════════════════════════════════════════════════════
    ---爱丽丝的立绘（`THlib/BossImageList.lua` 有 "Alice"）。
    local function skin3(self)
        self.NotPlayTimeOutSound = false
        self.colli = true
        self.no_hp_render = false
        setface(self, "Alice")
    end
    local function skin3_wall(self)
        self.NotPlayTimeOutSound = true
        self.colli = false
        self.no_hp_render = true
        setface(self, "Alice")
    end
    ---原作 sub22（中 boss）：从左侧 (低 x) 进场到 (192,128) ⇒ 我们 (-224,96)→(0,96)。
    local function enter3(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = -224, 96
        bmove(self, 60, 4, 0, 96)
    end
    ---原作 sub32/sub42（本体）：从下方升到 (192,128) ⇒ 我们 (0,224)→(0,96)。
    local function enter3b(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 224
        bmove(self, 60, 4, 0, 96)
    end
    ---原作 sub48（白符）：t=120 起 `MOVE_POS_TIME 120 4 192 112` ⇒ 我们 (0,112)。
    local function enter3c(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 224
        bmove(self, 120, 4, 0, 112)
    end
    ---原作 RING_ABS（op67）：以 (ox,oy)（我们的坐标）为圆心打 c1 发整圈；
    ---c2>1 时是多层同心环（速度 v1→v2）。th 传 TH07 弧度，shoot6 内部取反。
    local function ring3(self, ox, oy, spr, col, n, c2, v1, v2, th, a2)
        shoot6(self, ox, oy, 67, spr, col, n, c2 or 1, v1, v2 or 1.2, th, a2 or 0,
               nil, false)
    end
    ---原作 SPREAD_ABS（op65）：以 th 为心的 n 发扇（半张角 a2）。
    local function fan3(self, spr, col, n, v1, v2, th, a2)
        shoot6(self, 0, 0, 65, spr, col, n, 1, v1, v2 or 1.2, th, a2 or 0, nil, false)
    end
    ---原作 0x20 TargetAngle 段（每帧 angle += rate），TH07 弧度/帧 ⇒ 取反。
    local function rot3(rate_th, dur) return acc20(rate_th, 0, dur or 60) end

    ---原作 op72 RANDOM（`BulletManager.cpp:232`）：**每一发**各自掷角度与速度 ——
    ---  角度 = rand(0, a1−a2) + a2、速度 = rand(0, v1−v2) + v2（a1/a2 传 TH07 弧度）。
    ---本仓库原来的 w3_random 只会绕自机角掷，这一段要「全角随机」，所以单开一支。
    local function rand3(self, spr, col, n, v1, v2, a1_th, a2_th, cmd, plays)
        local room, i = POOL4_SIZE - pool4_used(), 1
        while i <= n and room > 0 do
            ---★ 原作 op72 RANDOM 逐发**先抽角、后抽速**（BulletManager.cpp:215-231）。
            local a = ran:Float(a2_th, a1_th)
            local v = ran:Float(v2, v1)
            if cmd then
                pool4[#pool4 + 1] = New(class["TH34_cmdbullet"], bs(spr), col16(col),
                                        self.x, self.y, v, -a * RAD2DEG, cmd)
            else
                pool4[#pool4 + 1] = NewSimpleBullet(bs(spr), col16(col), self.x, self.y,
                                                    v, -a * RAD2DEG, false, 0, false)
            end
            room, i = room - 1, i + 1
        end
        if plays then sound4(self) end
    end

    ---──────────────────── アリス 非符 1（原作 sub22/23/24，3 面**中 boss**） ────────────────────
    ---原作 sub22 进场到 (192,128)（我们 (0,96)）、t=60 设限位框并 SUB_CALL 23；
    ---sub23 以 **600 帧**为一轮（/tmp/br34 逐帧模拟实测），一轮里四次 SUB_CALL 24：
    ---  · 每段的「拍数」gI1 = 12 / 12 / 8 / 8；每拍打**两**轮环（sub24 的 t=0 与 t=3 各一轮），
    ---    偏移点绕半径 gF2 = 80 / 100 / 80 / 80、按 gF1 = ∓0.1309 rad 转（起始角 gF0 = π / 0 / π / 0）；
    ---  · 每段每轮的**环数** = gI2 = li0，Lunatic 行再 +3（sub24 #1..#3 的三条难度分支
    ---    只走 d=L 那一条）⇒ 7 / 7 / 12 / 12，li0 每轮 +2；色档 gI0 = 2 / 6 / 10 / 8；
    ---  · t=0 那一轮：RING_ABS c1=环数、c2=1、v=2.7（flags 0x202 = 响音效 + spawn-fast）；
    ---    t=3 那一轮：c1=环数、c2=2、v 0.5→0.2、第二层再转 0.392699 rad（flags 0x213），
    ---    并挂 INIT_BULLET_CMD [type1 起爆 17 帧 → type0x10 之后 90 帧 +0.0255556/帧²]；
    ---  · 第 1→2 段之间无停顿；第 2 段后空 60 帧、再「GET_EXIT_ANGLE 漂 60 帧（速度 1）」；
    ---    第 3 段后同样漂 60 帧；第 4 段后 MOVE_POS_TIME(60,4,192,128) 回场地中心。
    ---差异 3：GET_EXIT_ANGLE 沿用本文件既有的 `drift`（exang 代理）近似（同其它卡）。
    ncard("アリス 非符 1", 4430, 11000, 1200, function(self)
        task.New(self, function()
            task.Wait(60)                        -- 原作 sub22 的 60 帧进场
            self._box = box5(32, 48, 352, 128)   -- sub22 t=60 的 SET_MOVEMENT_BOUNDS
            ---sub24 #19/#20 的两条 INIT_BULLET_CMD（只在 t=3 那一轮生效）。
            local BURST = { stages = { { type = 1 },
                                       { type = 0x10, dur = 90, accel = 0.0255556 } } }
            ---sub23 交给 sub24 的四组参数（**只取 Lunatic 行**）。
            local SEG = {
                { cnt = 12, col = 2,  a0 = PI, da = -0.1309, r = 80,  li0 = 4 },
                { cnt = 12, col = 6,  a0 = 0,  da = 0.1309,  r = 100, li0 = 4 },
                { cnt = 8,  col = 10, a0 = PI, da = -0.1309, r = 80,  li0 = 9 },
                { cnt = 8,  col = 8,  a0 = 0,  da = 0.1309,  r = 80,  li0 = 9 },
            }
            local add = 0                        -- l2i3：每轮 +2
            while true do
                for k = 1, 4 do
                    local s = SEG[k]
                    local n, th = s.li0 + add + 3, s.a0
                    for _ = 1, s.cnt do
                        local ox, oy = cos(th * RAD2DEG) * s.r, -sin(th * RAD2DEG) * s.r
                        shoot6(self, ox, oy, 67, 6, s.col, n, 1, 2.7, 1.2,
                               th, 0.392699, nil, true)
                        th = th + s.da
                        task.Wait(3)
                        ox, oy = cos(th * RAD2DEG) * s.r, -sin(th * RAD2DEG) * s.r
                        shoot6(self, ox, oy, 67, 6, s.col, n, 2, 0.5, 0.2,
                               th, 0.392699, BURST, true)
                        th = th + s.da
                        task.Wait(3)
                    end
                    task.Wait(30)                -- sub24 的 SUB_RET 在 t=36：最后一拍之后还要等 30 帧
                    if k == 2 then task.Wait(60) end
                    if k == 2 or k == 3 then
                        drift(self, 1.0, 60)     -- 原作 MOVE_DIR_TIME(60,4,GET_EXIT_ANGLE,1)
                        task.Wait(60)
                    elseif k == 4 then
                        bmove(self, 60, 4, 0, 96)  -- MOVE_POS_TIME(60,4,192,128)
                        task.Wait(60)
                    end
                end
                add = add + 2
            end
        end)
    end, { skin = skin3, enter = enter3 })

    ---──────────────────── 操符「乙女文楽　-Lunatic-」（原作 sub27/28/29/30/31） ────────────────────
    ---原作是 3 面中 boss 被打到 1200 残血时由 `SET_LIFE_CALLBACK` 接上的符卡（sub27）。
    ---Lunatic 行（sub27 #2 的 `JUMP_IF_NEQ difficulty 2` 让 E/N/L 都走 t=120 那一支，
    ---Hard 才用「操符「乙女文楽」」那一张）：
    ---  · 进场 MOVE_POS_TIME(120,4,192,112) ⇒ 我们 (0,112)；随后 120 帧的变身特效
    ---    （sub27 的 SUB_CALL 2）把 ECL 冻到墙钟 240；
    ---  · 每 **350 帧**一轮（顶点 = sub27 t=240）：
    ---      SUB_CALL 28 打一发「大玉」（sprite 10 / 色档 1、速度 7、
    ---        方向 1.37445+rand(0,0.392699) = 90°±11.25°，挂 INIT_BULLET_CMD
    ---        type 0x40：30 帧里把速度 7 线性刹到 0 ⇒ 共走 108.5 px）；
    ---      60 帧后 RUN_EX_INS 4 把那颗大玉抹掉（还喷一下特效），并**在它停下的那一点**
    ---        一次性炸出 16 只人形（sub29），同一帧全部出现；
    ---      t=360  MOVE_DIR_TIME(100,4,GET_EXIT_ANGLE,1.25)
    ---      t=480  MOVE_DIR_TIME(100,4,GET_EXIT_ANGLE,1.25)（并把 l2i3 +1）
    ---      t=530  JUMP 回 t=240
    ---    （第二段漂移长 100 帧、循环点落在它的第 50 帧 ⇒ 它跨过循环点，照抄。）
    ---  · 每只人形（sub29）：方向 −2.35619+rand(0,1.5708)（−135°..−45°）、
    ---    速度 v = 1.5+rand(0,4)；MOVE_DIR_TIME(⌊9v⌋, 4, 方向, v) 突进 ⌊9v⌋ 帧，
    ---    再用 SET_WAIT_TIMER ⌊9v⌋ 把 ECL 冻同样帧数 ⇒ t=20 那一组开火落在墙钟 ⌊9v⌋+20：
    ---      · **L 行**的 SPREAD_ABS：c1=3、c2=8、v 3→1.2、a1 = 取反之后的方向、
    ---        a2 = π/2（flags 0x202）；H 行那一发（c1=1、a2=0）不取；
    ---      · SPAWN_LASER_FIXED：sprite 0 / 色档 2，从人形处沿同一方向伸出 500 px、宽 16，
    ---        90 帧展开（前 60 帧只有 1.2 px 的细线）→ 60 帧满宽 → 16 帧收束，判定 70..+16；
    ---      · **L 行**的 RANDOM（op72）：14 发，角度 rand(−π,π)、速度 rand(0.2,1.4)，
    ---        挂 [type1 起爆 17 帧 → type0x10 之后 120 帧 +0.02/帧²]（flags 0x213）；
    ---    t=270 起人形不再有判定，t=330 的 UNIMP 自毁。
    ---差异 3：GET_EXIT_ANGLE 沿用 `drift`（exang 代理）；激光贴图与「人形被打死」暂缺
    ---（原作每只人形 hp=10、可打，死亡回调 sub30 只是停激光 —— 本文件的 `pspawn` 子机
    ---一律无判定，见 4433/4435 同一口径）。
    scard("操符「乙女文楽　-Lunatic-」", 4431, 50, 2000, false, function(self)
        task.New(self, function()
            ---大玉：sprite 10 / 色档 1 / 速度 7，方向 90°±11.25°。
            ---INIT_BULLET_CMD 0 64 0 30 1 0 0 = type 0x40、dur 30、loop 1
            ---⇒ 30 帧里把速度线性刹到 0（BulletManager.cpp UpdateBulletDirChangeAndResume）。
            local SLOW = { type = 0x40, dur = 30, loop = 1, angle = 0, speed = 0 }
            ---sub29 #24/#25 的两条 INIT_BULLET_CMD：
            ---  commands[0] = `1 16 0 120 -1 0.02 1.5708`（0x10、flag=0、dur=120、
            ---                 **方向固定 1.5708**、速率 0.02/帧）；
            ---  commands[1] = `1 16 0 120 -1 0.02 1.5708`（0x10、**flag=1**、dur=120、
            ---                 方向固定 1.5708、速率 0.02/帧）。
            ---★ 原作 `flag` 是 1 不是 0（`EclManager.cpp` 的 `INIT_BULLET_CMD`：第 4 参
            ---  = flag）——`RunCommands` 里 `flag == 0 && exFlags != 0` 才拦，
            ---  所以这条 0x10 **出生后第 2 帧就会激活**、和 type1 爆速段并发相加，
            ---  而不是等 type1 清位（第 18 帧）才接管。配上 `flag` 才是原作的时序。
            ---★ 段的顺序 = **commands[] 的下标顺序**（idx0 = type1、idx1 = 0x10），
            ---不是 ECL 里两条 INIT_BULLET_CMD 的书写顺序。
            local DOLLCMD = cmds4(531,
                { type = 1, flag = 0, dur = -1, loop = -1, speed = -1, angle = -1 },
                { type = 0x10, flag = 1, dur = 120, loop = -1,
                  speed = 0.02, accel_angle = -90 })
            ---一只人形（原作 sub29）。a = TH07 弧度（突进方向）、v = 速度。
            local function doll(ox, oy, a, v)
                local t = int(9 * v)                 -- lf2 = (int)(9·lf1)
                local dist = t * v                   -- MOVE_DIR_TIME：速度 × 帧数
                pspawn(ox, oy, function(o)
                    bmove(o, t, 4, o.x + cos(a * RAD2DEG) * dist,
                          o.y - sin(a * RAD2DEG) * dist)
                    task.Wait(t)                 -- SET_WAIT_TIMER t：人形出生后冻 t 帧，t=0 组开火
                    shoot6(o, 0, 0, 65, 1, 6, 3, 8, 3, 1.2, -a, 1.5708, nil, true)  -- L 行 SPREAD（t=0）
                    plaser(o.x, o.y, a, { spr = 4, w = 16, sOff = 0, eOff = 500,
                                          sLen = 500, tStart = 90, dur = 60, tEnd = 16,
                                          hbStart = 70, hbEnd = 16 })             -- SPAWN_LASER
                    task.Wait(20)                -- t=0 → t=20
                    rand3(o, 1, 2, 14, 1.4, 0.2, PI, -PI, DOLLCMD, true)            -- L 行 RANDOM（t=20）
                    task.Wait(310)               -- t=20 → t=270 → t=330 的 UNIMP
                end)
            end
            task.Wait(120)                       -- MOVE_POS_TIME(120,4,192,112)
            task.Wait(120)                       -- SUB_CALL 2（变身特效）占掉的 120 帧
            while true do
                ---SUB_CALL 28：大玉飞 60 帧后停下、被抹掉，并在那一点炸出 16 只人形。
                local a = 1.37445 + ran:Float(0, 0.392699)
                local bx = self.x + cos(a * RAD2DEG) * 108.5
                local by = self.y - sin(a * RAD2DEG) * 108.5
                local big = New(class["TH34_cmdbullet"], bs(10), col16(1),
                                self.x, self.y, 7, -a * RAD2DEG, SLOW)
                pool4[#pool4 + 1] = big
                sound4(self)
                task.Wait(60)
                if IsValid(big) then object.RawDel(big) end
                for _ = 1, 16 do
                    doll(bx, by, -2.35619 + ran:Float(0, 1.5708), 1.5 + ran:Float(0, 4))
                end
                task.Wait(120)                   -- sub27 t=240 → t=360（跳过了大玉占的 60 帧）
                drift(self, 1.25, 100)           -- MOVE_DIR_TIME(100,4,GET_EXIT_ANGLE,1.25)
                task.Wait(120)                   -- t=360 → t=480
                drift(self, 1.25, 100)           -- 同上（跨过循环点）
                task.Wait(50)                    -- t=480 → t=530
            end
        end)
    end, { skin = skin3, enter = enter5at(0, 96, 120, 0, 112) })

    ---──────────────────── アリス 非符 1（原作 sub32/33/34/35，本体） ────────────────────
    ---**一轮 480 帧**（= 调用方 sub32 的 430 帧 + SUB_CALL 33 冻结的 50 帧）。
    ---  · sub33（每次进 loop 的 t=60）每 10 帧放一只「人形」共 6 只
    ---    （SPAWN_ENEMY_REL 35，方向 l3f0 = 0 / π / 15° / 165° / −15° / −165°），
    ---    人形跑 sub35：`MOVE_DIR_TIME 0 0 l3f0 2` ⇒ 以 2 px/帧 沿该方向匀速直飞，
    ---    并在自己的 t=30 / 60 / 90 各打一圈（**只取 L 行**）：
    ---      t=30 `RING_ABS spr2 col6 c1=32 c2=1 1.5→1.2 a2=22.5°`、
    ---      t=60 `… c1=16 c2=3 1.5→0.8`、t=90 `… c1=32 c2=1 2.3→1.2`，
    ---      三圈共用同一个随机 a1=lf0，flags 0x203（响音效 + spawn-fast）⇒ cmd {type=1}。
    ---  · sub34 在调用方 t=300 / t=480 各来一次：`RING_ABS spr3 col2 c1=48 c2=5 4.5→1.2
    ---    a2=1.875°`（flags 0x202，无 cmd），随后两圈 `RING_ABS spr6 col2 c1=40 c2=4 3→0.5`
    ---    （a2=∓2.8125°，flags 0x260）——这两圈吃两条 INIT_BULLET_CMD：
    ---      cmd0 = `0 64 0 60 1 3.14159 -999`：0x40 段先 60 帧把速度线性刹到 0，
    ---            再「角度 += π、速度恢复成出膛速度」；
    ---      cmd1 = `1 32 0 60 -1 0 ±0.0261799`：0x20 段接着 60 帧 ×(±1.5°/帧) 自旋。
    ---    L 行两圈的 a2 与 cmd1 的旋向都是「左圈负、右圈正」。
    ncard("アリス 非符 1", 4432, 19000, 2000, function(self)
        task.New(self, function()
            task.Wait(60)                        -- 原作 sub32 t=0..50 进场特效 / t=60 起
            self._box = box5(32, 48, 352, 128)   -- sub32 t=60 的 SET_MOVEMENT_BOUNDS
            ---原作 sub36 的「人形」（sub35）：本体位置处出生，沿 f3_0 以 f3_1=2 px/帧
            ---**匀速直飞**。`MOVE_DIR_TIME 0 0 *f3_0 *f3_1` 的时间参数 ≤0 ⇒ 走
            ---`ENEMY_MOVE_POLAR` 那一支（EclManager.cpp:1537-1547：angle=arg2、speed=arg3），
            ---并不是「原地不动」；一路飞到 t=3090 的 UNIMP 才自毁。
            local function puppet(o, a0)
                ---`ENEMY_MOVE_POLAR` 在 TH07 里是**逐帧 pos += speed·(cos θ, sin θ)**（θ 朝下）；
                ---翻到我们坐标（y 取反）就是沿 a0（已取反的度数）以 2 px/帧 直飞。
                bmove(o, 3090, 0, o.x + cos(a0) * 2 * 3090,
                                  o.y + sin(a0) * 2 * 3090)
                ---t=0 抽一次 f0 并装 cmd0（`INIT_BULLET_CMD 0 1 0 -1 -1 -1 -1` ⇒ type=1）；
                ---t=30 / 60 / 90 各打一环（a1=f0）——**每环打完就再抽一次 f0** 给下一环
                ---（原作 instr14/instr19 就在那两组的末尾）。L 行每组只取 `skip=0x8`
                ---的那一环：32发 / 16×3发 / 32发。
                local cmd = { type = 1 }
                local th = rngrad()
                task.Wait(30)
                shoot6(o, 0, 0, 67, 2, 6, 32, 1, 1.5, 1.2, th, 0.392699, cmd, true)
                th = rngrad()
                task.Wait(30)
                shoot6(o, 0, 0, 67, 2, 6, 16, 3, 1.5, 0.8, th, 0.392699, cmd, true)
                th = rngrad()
                task.Wait(30)
                shoot6(o, 0, 0, 67, 2, 6, 32, 1, 2.3, 1.2, th, 0.392699, cmd, true)
                task.Wait(3000)
            end
            -- 原作 sub34 的「大白弹花」：只有 L 行那一条（48 发 ×5 层 + 40 发 ×4 层 ×2）。
            local function bigflower(self)
                local th = rngrad()
                local cmd0 = { type = 0x40, dur = 60, loop = 1, angle = -180, resume_own = true }
                shoot6(self, 0, 0, 67, 3, 2, 48, 5, 4.5, 1.2, th, 0.0327249, nil, true)
                shoot6(self, 0, 0, 67, 6, 2, 40, 4, 3.0, 0.5, th, -0.0490874,
                       { stages = { cmd0, { type = 0x20, dur = 60, loop = -1,
                                            speed = 0, angle = -1.5 } } }, true)
                shoot6(self, 0, 0, 67, 6, 2, 40, 4, 3.0, 0.5, th, 0.0490874,
                       { stages = { cmd0, { type = 0x20, dur = 60, loop = -1,
                                            speed = 0, angle = 1.5 } } }, true)
            end
            ---原作 sub33 的六个方向（TH07 弧度，y 朝下 ⇒ 取反成本仓库角制）。
            local ANG = { 0, PI, 0.261799, 2.87979, -0.261799, -2.87979 }
            while true do
                task.Wait(120)                      -- sub33 开头的 SUB_CALL 2（gi0=30 ⇒ 120 帧）
                for i = 1, 6 do
                    if i > 1 then task.Wait(10) end     -- SPAWN 间隔 10 帧
                    pspawn(self.x, self.y, puppet, -ANG[i] * RAD2DEG)
                end
                task.Wait(120)                      -- 调用方 t=60 → t=180
                drift(self, 0.7, 100)               -- t=180 的 MOVE_DIR_TIME 100
                task.Wait(120)                      -- → t=300
                bigflower(self)                     -- SUB_CALL 34
                task.Wait(60)                       -- → t=360
                drift(self, 0.7, 100)               -- t=360 的 MOVE_DIR_TIME 100
                task.Wait(120)                      -- → t=480
                bigflower(self)                     -- SUB_CALL 34
                task.Wait(10)                       -- → t=490，JUMP 回 t=60
            end
        end)
    end, { skin = skin3, enter = enter3b })

    ---──────────────────── 蒼符「博愛のオルレアン人形」（原作 sub42/43/44/45，L 行） ────────────────────
    ---**原作 sub42 的 L 行**：符卡在 t=360 开（本体 MOVE_POS_TIME 120 帧 到 (192,112)）；
    ---t=480 起主循环（t=1363 的 JUMP 回 t=540，一轮 823 帧）：
    ---  · t=480 一次放 **8 只**人形（sub43）：起始角 l3f0 = rand[0,π/4) + i·2π/8；
    ---    `MOVE_ORBIT 0 posX posY posZ l3f0 l3f1 0 0` ⇒ 绕**本体当时的位置**公转。
    ---    半径/角速每帧由 ex-ins 5（CopyMainBossMovement）从本体抄来 —— 本体用
    ---    INIT_INTERP 遥控全体：t=480 半径 0→96、角速 0→π/30（各 60 帧 ease-out-quad），
    ---    t=541 半径→48、角速→−π/120，t=661 再抄一次，t=1173 半径→96、角速→π/30。
    ---  · 本体 t=601 / t=1113 各 `MOVE_DIR_TIME 60 4 lf0 2`，
    ---    t=661 / t=1173 各 `MOVE_POS_TIME 60 4 192 128`。
    ---  · 人形每帧 `GET_BOSS_INT l2i2` 读本体模式；模式 2/3 的那一帧 `SUB_CALL 45`
    ---    （L 行；sub44 是 E/N/H 用）。本体只在 t=540 / t=791 / t=1052 各置 1 帧
    ---    ⇒ 每一轮每个方向打 **3 次**。
    ---    （原作还把角度写进 gF0 = $10041，但 sub44/45 的 a1 读的是 l3f0 = $10033 ——
    ---     两个不同的变量；移植版照原作，射击方向恒为 l3f0。）
    ---
    ---**sub45（L）的一次开花**（原作靠 spriteOffset 6/15/2/10 认弹）：
    ---  t=0   1 发「种子」：SPREAD_ABS spr6 col6 v=2.5 a1=l3f0（flags 0x2208）。
    ---  t=50  ex-ins 6(arg0)：每发 col6 → 就地在原地变成 5 发 col15：2 发 v×1.1、张角 π/2；
    ---        2 发 v×0.7、张角 π/3；1 发 v×0.85 —— 方向都是「原弹此刻朝向 + π」，原弹销毁。
    ---  t=100 ex-ins 6(arg1)：col15 → 5 发 col2；t=150 ex-ins 6(arg2)：col2 → 5 发 col10。
    ---  ⇒ 1 发种子 50/100/150 帧后变成 5 / 25 / 125 发。
    ---差异：本仓库没有 spawnDelay 原语（原作 flags 0x2000），略去 —— 只影响子弹出屏后的
    ---存活帧数，不影响数量/方向/速度。
    scard("蒼符「博愛のオルレアン人形」", 4433, 50, 3000, false, function(self)
        ---一发 SPREAD_ABS（c2=1）：n 发、速度 v、基准角 a1_th（TH07 弧度）、半张角 a2_th。
        ---返回每发的记录 {b=弹对象, a=我们的角, v=速率}（供 ex-ins 6 就地分裂用）。
        local function spawn_spread(px, py, spr, off, n, v, a1_th, a2_th)
            local out = {}
            local style, col = bs(spr), col16(off)
            local room = POOL4_SIZE - pool4_used()
            local base = -a1_th * RAD2DEG
            local offs = spread3(n, a2_th * RAD2DEG)
            for i = 1, n do
                if room <= 0 then break end
                local a = base + offs[i]
                local b = NewSimpleBullet(style, col, px, py, v, a, false, 0, false)
                pool4[#pool4 + 1] = b
                out[#out + 1] = { b = b, a = a, v = v }
                room = room - 1
            end
            return out
        end
        ---ex-ins 6 的一支：parents 每发就地换成 5 发（色档 off）。
        local function split(parents, off)
            local nextg = {}
            for i = 1, #parents do
                local p = parents[i]
                if IsValid(p.b) then
                    local px, py, v = p.b.x, p.b.y, p.v
                    local a1_th = -p.a * PI / 180 + PI    -- TH07 角 = −我们的角，再 +π
                    object.RawDel(p.b)
                    local q = spawn_spread(px, py, 6, off, 2, v * 1.1, a1_th, PI / 2)
                    for k = 1, #q do nextg[#nextg + 1] = q[k] end
                    q = spawn_spread(px, py, 6, off, 2, v * 0.7, a1_th, PI / 3)
                    for k = 1, #q do nextg[#nextg + 1] = q[k] end
                    q = spawn_spread(px, py, 6, off, 1, v * 0.85, a1_th, PI / 3)
                    for k = 1, #q do nextg[#nextg + 1] = q[k] end
                end
            end
            return nextg
        end
        ---一只人形（sub43+45）：公转 + 模式触发开花。
        ---公转（原作 sub43 `MOVE_ORBIT 0 *X *Y *Z *f3_0 *f3_1 0 0` + `SET_EX_INS 5`）：
        ---  · `MOVE_ORBIT` 半径 0、圆心 = 出生点、起始绕角 f3_0、角速度 f3_1；
        ---    `SET_EX_INS 5`（CopyMainBossMovement）从第 2 帧起每帧把**主 boss** 的
        ---    ORBR / ORBAV 抄进来 ⇒ 半径 = 本体 ORBR、绕角每帧 += 本体 ORBAV。
        ---  · 位置 = 本体 + (cos(−θ), sin(−θ))·ORBR（θ 是 TH07 口径的 orbitAngle）。
        ---  · `host._orbW` 存的是 **−ORBAV×180/π**（本仓库角取反、度制），故这里是「加」；
        ---    `ang` 也是度，喂 math.cos/sin 前必须 ×π/180 —— 之前漏了这步，等于把「度」
        ---    当「弧度」用，8 只人形的落点全是错的。
        local function puppet(o, a)
            local host, a0_th = a.host, a.a0
            ---初值要含子机自己的 f3_1（本体 t=480 写的 **+0.0523599**）：
            ---第 1 帧 `SET_EX_INS 5` 还没生效，走的是 `MOVE_ORBIT` 的角速度。
            local ang = -(a0_th + 0.0523599) * RAD2DEG
            local ox, oy = o.x, o.y
            local job, gen = nil, nil
            local first = true
            local lastR = nil
            while true do
                    ---★ 半径也要用**上一帧**的 ORBR：原作子机位置
                    ---  `P(f) = boss.pos(f-1) + polar(orbitA(f), ORBR(f-1))`
                    ---  （`SET_EX_INS 5` 抄进来的 ORBR 到下一帧才用），而本移植的轨道角
                    ---  恰好也落后一帧 ⇒ 半径必须一起落后，否则「半径正在变」的那几帧
                    ---  位置会整体偏一个半径增量（96→94.4 那帧就偏 1.6px）。
                    local r = lastR or (host._orbR or 0)
                    lastR = host._orbR or 0
                    local rad = ang * PI / 180
                    local nx = host.x + math.cos(rad) * r
                    local ny = host.y + math.sin(rad) * r
                    o._angdx, o._angdy = nx - ox, ny - oy
                    ox, oy = nx, ny
                    o.x, o.y = nx, ny
                    local m = host._mode or 0
                    if m > 0 and not job then
                        ---原作 sub43 每帧 `GET_BOSS_INT *i2_2` 后按模式 `SET_FLOAT *gf0 *ANG`
                        ---（mode 2 是 `*ANG + π/2`）再 `SUB_CALL 45`；SUB_CALL 会把 gf 同步进
                        ---子程的 `*f3_0`（EclManager.cpp:1176），所以 sub45 的 a1 **不是**出生角，
                        ---而是 `*ANG`。★ 相位：`*ANG` 是 `RunEcl` 的**出口**里用
                        ---`enemy->angle = atan2(velocity)` 写的，而 sub43 的 `SET_FLOAT *gf0 *ANG`
                        ---在**指令循环**里读 —— 指令循环在出口之前 ⇒ 读到的 `*ANG` 是
                        ---**上一帧**出口算出的朝向。移植里人形位置天然比原作晚一帧
                        ---（见下），所以「本帧位移方向」正好等于原作读到的 `*ANG`。
                        local a1_th = -atan2(o._angdy or 0, o._angdx or 0)
                        if m == 2 then a1_th = a1_th + 1.5708 end
                        gen = { spawn_spread(o.x, o.y, 6, 6, 1, 2.5, a1_th, 0)[1] }
                        job = 1
                    elseif job then
                        job = job + 1
                        ---原作 sub45 的 t=0 打种子、t=50/100/150 各 RUN_EX_INS 6 一次；
                        ---job 在种子那一帧就 =1，所以这三处要写成 51/101/151。
                        if job == 51 then
                            gen = split(gen, 15)
                        elseif job == 101 then
                            gen = split(gen, 2)
                        elseif job == 151 then
                            gen = split(gen, 10)
                            job = nil
                        end
                    end
                    ---★ 相位：人形比原作晚一帧推进轨道角（位置对齐原作的上一帧），
                    ---  所以本帧位移方向恰好 = 原作 `*ANG`。但**出生帧**不能加 ORBAV：
                    ---  原作子机在出生帧只跑 `MOVE_ORBIT` 的初值（f3_0），
                    ---  从第 2 帧起才吃 `SET_EX_INS 5` 抄进来的 ORBAV。
                    if not first then ang = ang + (host._orbW or 0) end
                    first = false
                    task.Wait(1)
            end
        end
        ---本体（ECL t=360 → 移植 t=0）。
        task.New(self, function()
            ---原作 t=360 的 L 行开局（MOVE_POS_TIME 120 帧 + 开卡）在墙钟 0..120 跑完，
            ---t=480 的 SUB_CALL 2（120 帧）才在墙钟 120 起步 ⇒ 桩件里先补这 120 帧序奏。
            task.Wait(120)
            local host = self
            host._orbR, host._orbW, host._mode = 0, 0, 0
            local interps = {}
            ---`INIT_INTERP` 的 easing 要照抄：原作 sub42 的 ORBR 是 `*ORBR 60 0 4 ...`
            ---（fn 0 = MathLerp、easing **4** = ease-out-quad），ORBAV 是
            ---`*ORBAV 60 0 0 ...`（easing **0** ⇒ **线性**）。两者不能都按 ease-out-quad 算。
            local function add_interp(field, dur, to, ease)
                interps[#interps + 1] = { field = field, from = host[field],
                                          to = to, dur = dur, t = 0, ease = ease or 0 }
            end
            local function wait(n)
                for _ = 1, n do
                    for i = #interps, 1, -1 do
                        local it = interps[i]
                        it.t = min(it.t + 1, it.dur)
                        local u = it.t / it.dur
                        if it.ease == 4 then u = 1 - (1 - u) * (1 - u) end
                        ---★ 原作 `INIT_INTERP` 的第 5 参在**声明那一刻**取值
                        ---  （`interp->args[3].f = GET_FLOAT_VALUE(enemy, 4)`，
                        ---  EclManager.cpp:1084）⇒ 即便写的是 `*ORBR`，插值起点也是
                        ---  声明时的快照，不是逐帧自引用递推（实测原作是等差线性）。
                        host[it.field] = it.from + (it.to - it.from) * u
                        if it.t >= it.dur then table.remove(interps, i) end
                    end
                    task.Wait(1)
                end
            end
            ---原作 sub42 t=360 的 MOVE_POS_TIME(120,4,192,112) ⇒ 我们 (0,112)。
            bmove(self, 120, 4, 0, 112)
            wait(120)                                   -- ⇒ t=120（原作 t=480）
            local a0 = ran:Float(0, 0.785398)
            for i = 1, 8 do
                pspawn(self.x, self.y, puppet,
                       { host = host, a0 = a0 + (i - 1) * 2 * PI / 8 })
            end
            add_interp("_orbR", 60, 96, 4)
            add_interp("_orbW", 60, -0.0523599 * RAD2DEG, 0)
            wait(60)                                    -- ⇒ t=180（原作 t=540）
            while true do
                host._mode = 3
                wait(1)
                host._mode = 0
                add_interp("_orbR", 60, 48, 4)
                add_interp("_orbW", 60, 0.0261799 * RAD2DEG, 0)
                wait(60)                                -- ⇒ 241
                drift(self, 2, 60)                      -- MOVE_DIR_TIME(60,4,lf0,2)
                wait(60)                                -- ⇒ 301
                add_interp("_orbR", 60, 48, 4)
                add_interp("_orbW", 60, 0.0261799 * RAD2DEG, 0)
                bmove(self, 60, 4, 0, 96)               -- MOVE_POS_TIME(60,4,192,128)
                wait(60)                                -- ⇒ 361
                wait(70)                                -- ⇒ 431（原作 t=791 模式 2）
                host._mode = 2
                wait(1)
                host._mode = 0
                wait(260)                               -- ⇒ 692（原作 t=1052 模式 3）
                host._mode = 3
                wait(1)
                host._mode = 0
                wait(60)                                -- ⇒ 753
                drift(self, 2, 60)
                wait(60)                                -- ⇒ 813
                bmove(self, 60, 4, 0, 96)
                add_interp("_orbR", 60, 96, 4)
                add_interp("_orbW", 60, -0.0523599 * RAD2DEG, 0)
                wait(60)                                -- ⇒ 873
                ---原作 t=1363 的 `JUMP 480 … -> sub42+1816`：跳回的目标是
                ---**t=540 的 `SET_INT i2_2 3`**（rel 1816），而 JUMP 把子程时间设成
                ---**480** ⇒ 跳回后还要再空转 60 帧（480→540）才到下一个「模式 3」拍。
                ---少这 60 帧，第二轮起每一拍的墙钟都会提前 60（首拍 1123 而非 1183）。
                wait(190)                               -- ⇒ 原作 t=1363 的 JUMP + 480→540
            end
        end)
    end, { skin = skin3, enter = enter3b })

    ---──────────────────── アリス 非符 2（原作 sub36 的非符段 + sub39，L 行） ────────────────────
    ---原作 sub36 是本体「非符 2」这一个攻击槽的**顶层脚本**（sub32 的死亡回调接过来的）：
    ---  · t=0 `END_SPELLCARD`、`SET_LIFE 2000`、`SET_BOSS_HEALTH 0 0 2000`、接触判定开；
    ---    `SET_CAN_BE_DAMAGED 0`，**到 t=340 才 = 1** ⇒ 这 340 帧本体免伤；
    ---  · t=180 只 `SUB_CALL 39` 一次 —— 这是整段非符**唯一**的发弹；
    ---  · t=340 把免伤关掉，同时 `SUB_CALL 46`（紅符，E/N 行）/`SUB_CALL 48`
    ---    （白符 -Lunatic-，H/L 行）——那是**下一张符卡**（4439/4435），不属于本段非符。
    ---    （原作非符 2 的血只有 2000，本来就是一个「一发大环撑 340 帧」的短非符。）
    ---sub39 的 L 行（spr3 与 spr6 各一圈，共用同一个 `RAND_FLOAT_ADD` 随机角 lf0）：
    ---  · spr3 / col2：RING_ABS c1=40、c2=6、v 3.2→1.2、a2=+0.0392699（+2.25°）、
    ---    flags 0x2222；先 `INIT_BULLET_CMD 0 32 0 60 -1 0 0.0261799`
    ---    （0x20 每帧 +2.25°、速度不变），再 `INIT_BULLET_CMD 1 8192 1 120 …`
    ---    （spawnDelay 120 —— 本仓库没有该原语，略去，见 4433 的同一处差异）。
    ---  · spr6 / col2：同样 40×6、v 3.2→1.2、a2=+0.0392699、flags 0x260；
    ---    先 `INIT_BULLET_CMD 0 64 0 60 1 3.14159 -999`
    ---    （0x40 刹停 60 帧 → 掉头 π → 用自身速率续飞），
    ---    再 `INIT_BULLET_CMD 1 32 0 60 -1 0.005 -0.0261799`（0x20 每帧 −1.5°、+0.005 加速）。
    ---  两圈的 a1 都是同一个随机角；cmd 的角度按本仓库口径取反。
    ncard("アリス 非符 2", 4434, 2000, 0, function(self)
        ---sub39 的 spr6 圈：0x40 掉头 + 0x20 自旋。
        local C40 = { type = 0x40, dur = 60, loop = 1, angle = -180, resume_own = true }
        local SPIN6 = { type = 0x20, dur = 60, loop = -1, speed = 0.005, angle = 1.5 }
        task.New(self, function()
            self._box = box5(32, 48, 352, 128)
            task.Wait(180)                          -- sub36 t=180 SUB_CALL 39（整段非符只发这一次）
            local th = rngrad()                     -- sub39 t=0 RAND_FLOAT_ADD lf0 2π −π
            shoot6(self, 0, 0, 67, 3, 2, 40, 6, 3.2, 1.2, th, 0.0392699,
                   { stages = { { type = 0x20, dur = 60, loop = -1, speed = 0,
                                  angle = -1.5 } } }, true)
            shoot6(self, 0, 0, 67, 6, 2, 40, 6, 3.2, 1.2, th, 0.0392699,
                   { stages = { C40, SPIN6 } }, true)
        end)
    end, { skin = skin3, enter = enter3b })

    ---──────────────────── 白符「白亜の露西亜人形 -Lunatic-」（原作 sub48/49，L 行） ────────────────────
    ---sub48 的 L 行直接跳到 t=120 那一支（名字取 -Lunatic-）：
    ---  · t=120 `MOVE_POS_TIME 120 4 192 112`（我们 (0,112)）并开卡（t=240 起可打）。
    ---    t=120 的 `JUMP 240` 把子程时间拉到 240 ⇒ t=120..240 只是原地等 120 帧，
    ---    所以**第一只人形在 t=240 才出生**、第一次开火在 t=300。
    ---  · t=240 起主循环 —— **一轮 460 帧**。原作这几组 `DEC_JUMP 240/250/320/330` 的
    ---    第一参是**跳回点的时间**：每跳一次，子程内部时间被拉回起点再走满 10 帧，
    ---    所以逻辑上写着 t=240/250/320/330 的四批 `SPAWN_ENEMY_ABS 49`（人形），
    ---    **实测墙钟**（/tmp/br34 逐帧模拟）是**顺序**发生、两批之间不交叠：
    ---      (a) 第   0.. 60 帧（每 10 帧一只，共 7 只）：
    ---          x=32,80,…,320，y=rand(160)+32，色档 6，环步进 ±0.0373999；
    ---      (b) 第  70..130 帧（7 只）：
    ---          x=rand(64)+304，y=128,176,…,416，色档 6，环步进 ±0.0187；
    ---      (c) 第 200..260 帧（7 只）：
    ---          x=352,304,…,64，y=rand(160)+32，色档 2，环步进 ±0.0373999；
    ---      (d) 第 270..330 帧（7 只）：
    ---          x=rand(64)+16，y=128,…,416，色档 2，环步进 ±0.0187。
    ---    （原文 `rngCustom`=$10056 = `rand(globalVars.floatVars[0]) + globalVars.floatVars[1]`
    ---      —— 这是**上下文局部**的 l3f0/l3f1（EclManager.cpp:468 的
    ---      `eclContextArgs.globalVars`），所以 (a)(c) 的随机量是 y=rand(160)+32、
    ---      (b)(d) 的随机量是 x=rand(64)+304 / rand(64)+16。每次 spawn 后 `l3f3 *= -1`。）
    ---  · 第 200 与第 400 帧各 `GET_EXIT_ANGLE + MOVE_DIR_TIME 60 4 lf0 1`（漂 60 帧）；
    ---    第 460 帧 `JUMP` 回 t=240 ⇒ 下一轮。
    ---sub49（人形）：
    ---  · t=0..59 不可打；t=60 起可打（原作 life=20）并打一圈音效；
    ---  · t=60 起步进 1 帧、共 6 圈：RING_ABS spr2、色档 = l3i0、c1=6、c2=1、a2=0（整圆 60°），
    ---    速度**每圈重新** rand(0.3)+0.9（= rand 0.9..1.2）、v2=1.5，圈心角 lf0 初值 0、每圈 += l3f3；
    ---  · t=161 换死亡动画，t=221 自毁。
    ---差异：本文件的 `pspawn` 子机无判定（原作人形可被打死），同 4431/4433 口径。
    scard("白符「白亜の露西亜人形 -Lunatic-」", 4435, 60, 3600, false, function(self)
        ---一只人形（原作 sub49）：t=60 起 1 帧一圈、共 6 圈。
        local function puppet(px, py, col, step)
            pspawn(px, py, function(o)
                task.Wait(60)
                local a = 0
                for _ = 1, 6 do
                    ring3(o, 0, 0, 2, col, 6, 1, ran:Float(0.9, 1.2), 1.5, a)
                    a = a + step
                    task.Wait(1)
                end
                task.Wait(160)                  -- t=61 → t=221 自毁
            end)
        end
        task.New(self, function()
            self._box = box5(32, 48, 352, 128)
            task.Wait(240)                      -- t=0..120 MOVE_POS_TIME + t=120..240 JUMP 等待
            while true do
                ---(a) 第 0..60 帧：7 只，x=32+48k，y=rand(160)+32，色档 6。
                local sa = 0.0373999
                for k = 0, 6 do
                    puppet(32 + k * 48 - 192, 224 - (ran:Float(0, 160) + 32), 6, sa)
                    sa = -sa
                    task.Wait(10)
                end
                ---(b) 第 70..130 帧：7 只，x=rand(64)+304，y=128+48k，色档 6。
                local sb = 0.0187
                for k = 0, 6 do
                    puppet(ran:Float(0, 64) + 304 - 192, 224 - (128 + k * 48), 6, sb)
                    sb = -sb
                    task.Wait(10)
                end
                ---第 140..200 帧空档；第 200 帧 GET_EXIT_ANGLE + MOVE_DIR_TIME 60 4 lf0 1。
                task.Wait(60)
                drift(self, 1, 60)
                ---(c) 第 200..260 帧：7 只，x=352−48k，y=rand(160)+32，色档 2。
                local sc = 0.0373999
                for k = 0, 6 do
                    puppet(352 - k * 48 - 192, 224 - (ran:Float(0, 160) + 32), 2, sc)
                    sc = -sc
                    task.Wait(10)
                end
                ---(d) 第 270..330 帧：7 只，x=rand(64)+16，y=128+48k，色档 2。
                local sd = 0.0187
                for k = 0, 6 do
                    puppet(ran:Float(0, 64) + 16 - 192, 224 - (128 + k * 48), 2, sd)
                    sd = -sd
                    task.Wait(10)
                end
                ---第 340..400 帧空档；第 400 帧漂移；再空 60 帧到第 460 帧回到循环头。
                task.Wait(60)
                drift(self, 1, 60)
                task.Wait(60)
            end
        end)
    end, { skin = skin3, enter = enter3c })

    ---──────────────────── アリス 非符 3（原作 sub37/38/39/40） ────────────────────
    ---sub37 的一轮 = **508 帧**（墙钟 = 调用方逻辑时间 + 各 SUB_CALL 的子程帧数）：
    ---  t=120 SUB_CALL 40（24 帧）×2 → t=240 MOVE_DIR_TIME(60,4,GET_EXIT_ANGLE,0.7) →
    ---  t=320 SUB_CALL 38（0 帧）→ t=380 同款漂移 → t=460 SUB_CALL 39（0 帧，并把 l2i3+1）→
    ---  t=580 JUMP 回 t=120。
    ---sub40（一次 24 帧；被调两次，l3f0/l3f1/l3i0 = π/4,π,6 与 π,0,2）：
    ---  · t=0 —— 7 拍，第 k 拍 i0 = 7 + (7−k) = 14…8 ⇒ 张角 a2 = π/i0（由 π/14 收到 π/8）；
    ---    每拍 8 条 SPREAD_ABS（spr1、色档 l3i0）：c1 = 5/6/10/12、
    ---    速度 1.7/2/2.2/2.5，a1 = f0 与 f0+π 各四条；f0 每拍按 f1 的符号 ∓0.448799；
    ---  · t=12 —— 14 拍，每拍 8 条：c1 = 3/6/16/16、速度同前、
    ---    张角 0.224399（前两条）/0.15708（后两条），挂 `INIT_BULLET_CMD 0 32 0 60 -1 0 f3`
    ---    （0x20 自旋 60 帧）；每拍 f0 += f1、f3 += f2（f2 = f1/−120），两者再 NORMALIZE_ANGLE。
    ---sub38 / sub39（各 0 帧）：spr3（色档 2）四圈 24/28/32/40 发、层数 3/5/5/6、
    ---  速度 1.8/2.4/2.8/3.2→1.2，a2 = ∓0.0392699；spr6（色档 2）同样的四圈，
    ---  挂 `0x40 刹停 60 帧（角度 += π、速度取弹自身）→ 0x20 自旋`；
    ---  sub38 的 spr3 用 cmd −0.0261799 / spr6 用 +0.0261799，
    ---  sub39 相反（spr3 +0.0261799 / spr6 −0.0261799）。
    ---差异：原作这两支的 cmd1 是 `0x2000 spawnDelay`，弹上还挂 0x2/0x200/0x2000 等 flags；
    ---  本仓库的弹工厂没有 spawnDelay 原语（同 4433 的口径），略去。
    ncard("アリス 非符 3", 4436, 25000, 3300, function(self)
        local function nrm(a) return (a + PI) % (2 * PI) - PI end
        ---sub40 的一次投放。base/total 是角度区间两端，col 是色档（l3i0）。
        ---★ 每「拍」原作是 7 条 SPREAD_ABS，其中 #8/#9/#10/#11 是 **E/N/H/L 四行**
        ---（skip 01/02/04/08）：Lunatic 只发 count1=12、v=2.5 那一条；第二组（f0+π）
        ---同理。移植版原先把四行误当成「4 层扇」全发（8 发/拍），这里只留 Lunatic 行。
        ---★ 原作 DEC_JUMP 在 t=12（先减后跳、计到 0 不跳）⇒ 两拍之间 **12 帧**；
        ---移植版原先漏了每拍之间的 `task.Wait(12)`，把整组拍子压在同一帧里。
        local function sub40(self, base, total, col)
            local f0 = base
            local f1 = (total - base) / 14
            for i2 = 7, 1, -1 do
                local a2 = PI / (i2 + 7)
                local g = f0 + PI
                shoot6(self, 0, 0, 65, 1, col, 12, 1, 2.5, 1.2, f0, a2, nil, true)
                shoot6(self, 0, 0, 65, 1, col, 12, 1, 2.5, 1.2, g, a2, nil, true)
                f0 = f0 + (f1 >= 0 and 0.448799 or -0.448799)
                task.Wait(12)
            end
            local f2 = f1 / -120
            local f3 = 0
            for _ = 1, 14 do
                local cmd = acc20(f3, 0, 60)
                local g = f0 + PI
                shoot6(self, 0, 0, 65, 1, col, 16, 1, 2.5, 1.2, f0, 0.15708, cmd, true)
                shoot6(self, 0, 0, 65, 1, col, 16, 1, 2.5, 1.2, g, 0.15708, cmd, true)
                f0, f3 = nrm(f0 + f1), nrm(f3 + f2)
                task.Wait(12)
            end
        end
        ---sub38 / sub39：sgn = −1（sub38）/ +1（sub39）。
        ---★ 原作每条 RING_ABS 也是 E/N/H/L 四行（24/28/32/40 发）⇒ Lunatic 只有
        ---40×6 那一条；移植版原先把四行当成「四圈」全发（8 条/次 ⇒ 应 2 条/次）。
        local C40 = { type = 0x40, dur = 60, loop = 1, angle = -180, resume_own = true }
        local function rings(self, sgn)
            local th = rngrad()
            local own = acc20(sgn * 0.0261799, 0, 60)
            local doll = { stages = { C40, acc20(-sgn * 0.0261799, 0.005, 60) } }
            shoot6(self, 0, 0, 67, 3, 2, 40, 6, 3.2, 1.2, th, sgn * 0.0392699, own, true)
            shoot6(self, 0, 0, 67, 6, 2, 40, 6, 3.2, 1.2, th, sgn * 0.0392699, doll, true)
        end
        task.New(self, function()
            self._box = box5(32, 48, 352, 128)
            task.Wait(120)                       -- 原作 sub37 t=0..120
            while true do
                sub40(self, 0.785398, 3.14159, 6)    -- l3f0/l3f1/l3i0 = π/4, π, 6
                sub40(self, 3.14159, 0, 2)           -- l3f0/l3f1/l3i0 = π, 0, 2
                task.Wait(120)                       -- t=120 → t=240
                drift(self, 0.7, 60)                 -- MOVE_DIR_TIME(60,4,GET_EXIT_ANGLE,0.7)
                task.Wait(80)                        -- t=240 → t=320
                rings(self, -1)                      -- SUB_CALL 38
                task.Wait(60)                        -- t=320 → t=380
                drift(self, 0.7, 60)                 -- MOVE_DIR_TIME(60,4,GET_EXIT_ANGLE,0.7)
                task.Wait(80)                        -- t=380 → t=460
                rings(self, 1)                       -- SUB_CALL 39
                task.Wait(120)                       -- t=460 → t=580，JUMP 回 t=120
            end
        end)
    end, { skin = skin3, enter = enter3b })

    ---──────────────────── 雅符「春の京人形」（原作 sub54/55） ────────────────────
    ---sub54（本体）：
    ---  · t=0 `MOVE_POS_TIME 120 4 192 112`（我们 (0,112)）；t=120 起 `SUB_CALL 2`
    ---    （gi0=30、gi1=4 ⇒ 等 120 帧）—— **墙钟 t=240** 时一次性放 14 只人形。
    ---    子程时间被 SUB_CALL 推后 120 帧，所以 sub54 里写 t=120 的指令都在墙钟 240 执行。
    ---  · 放人形前 `RAND_FLOAT f3_0 0.785398` 只掷**一个**基准角（[0,π/4)），
    ---    然后每只 `f3_0 += 2π/14`、NORMALIZE_ANGLE —— 14 只的起始角等分整圆。
    ---  · 之后本体只做「归位」：t=301（墙钟 421）与 t=813（墙钟 933）
    ---    各 `MOVE_POS_TIME 60 4 192 128`（我们 (0,128)），t=1003（墙钟 1123）JUMP 回 t=180
    ---    ⇒ 此后每 **823 帧**重复这段归位（本体不发弹，只影响人形的锚点）。
    ---    （t=241 / t=753 的 `GET_EXIT_ANGLE *f0` 写进去的 f0 没有任何指令读，是死代码，略。）
    ---sub55（人形）：
    ---  · `MOVE_ORBIT 0 *X *Y *Z *f3_0 *f3_1 0 0`：**半径 0**、角速度 f3_1=-0.0523599 rad/帧，
    ---    圆心 = 出生点；再挂 `SET_EX_INS 5`（CopyMainBossMovement，每帧把圆心改成主 boss 的位置）
    ---    ⇒ 人形就叠在本体身上、跟着本体走（不是绕本体转圈）。
    ---  · `SET_FLOAT f0 *ORBA`（= 起始角 f3_0）、f1=1.1；`INIT_BULLET_CMD 0 1 …`（type1 起爆？无实际指令）。
    ---  · 四段各 20 拍、每拍一条 `RING_ABS 2:off c1 1 f1 1.5 f0 0 flags`
    ---    （spr2；c1=2 时两发相对、c1=3 时三发 120°；v1=f1、v2=1.5）：
    ---      ① off=10、c1=2、步 9 帧：f0 += 0.165347、f1 += 0.05（flags 514）
    ---      ② off=6、 c1=3、步 9 帧：f0 −= 0.314159、f1 −= 0.05（flags 515）
    ---      ③ off=11、c1=2、步 7 帧：f0 = 0 重新开始、再 += 0.314159、f1 += 0.05（flags 514）
    ---      ④ off=8、 c1=3、步 7 帧：f0 −= 0.314159、f1 −= 0.05（flags 515）
    ---    然后 JUMP 回 ①（i2_0 重置为 20；**f0/f1 不回卷**，从上一轮的值续着走）。
    ---    ① 20 拍打完（t=171）→ ② 第一拍在 t=180；② 打完（t=351）→ 空 30 帧 → ③ 第一拍 t=390；
    ---    ③ 打完（t=523）→ ④ 第一拍 t=530；④ 打完（t=663）→ ① 下一轮 t=670。
    scard("雅符「春の京人形」", 4437, 45, 2700, false, function(self)
        ---一只人形（原作 sub55）：`MOVE_ORBIT 0 *X *Y *Z *f3_0 *f3_1 0 0` ＋ `SET_EX_INS 5`。
        ---`SET_EX_INS 5`（`ExInsCopyMainBossMovement`，EnemyEclInstr.cpp:227）每帧把**主 boss** 的
        ---pos / ORBR / ORBAV 抄进子机的 moveInterpStartPos / orbitRadius / orbitAngleVel
        ---（**不抄 orbitAngle**）。子机自己是 `ENEMY_MOVE_ORBIT`：
        ---  · 每帧 `orbitAngle += orbitAngleVel`、半径取 `orbitRadius`（= 本体的 ORBR），
        ---    位置 = moveInterpStartPos (= 本体位置) + FromAngle(orbitAngle, ORBR)。
        ---  ⇒ 人形**绕本体公转**（半径 = 本体 ORBR、角速度 = 本体 ORBAV），不是叠在本体身上。
        ---四段 20 拍，打完从 ① 重新来。
        local function doll(a0)
            pspawn(self.x, self.y, function(o)
                ---★ 第 1 帧 `SET_EX_INS 5` 还没生效：走子机自己的 `MOVE_ORBIT` 角速度
                ---  f3_1（sub54 t=120 写的 **−0.0523599**）⇒ θ 先转一拍、ang = −(θ0+f3_1)。
                local ang = -(a0 + (-0.0523599))    -- 我们的弧度（TH07 角取反）
                local f, v = a0, 1.1
                task.New(o, function()
                    while true do
                        local r = self._kR or 0
                        o.x = self.x + math.cos(ang) * r
                        o.y = self.y + math.sin(ang) * r
                        task.Wait(1)
                        ---本体 ORBAV 是 TH07 口径，本仓库角度取反 ⇒ 每帧「减」。
                        ang = ang - (self._kW or 0)
                    end
                end)
                while true do
                    for _ = 1, 20 do        -- ① spr2 色档 10，2 发，9 帧一拍
                        shoot6(o, 0, 0, 67, 2, 10, 2, 1, v, 1.5, f, 0, nil, true)
                        f = f + 0.165347
                        v = v + 0.05
                        task.Wait(9)
                    end
                    for _ = 1, 20 do        -- ② spr2 色档 6，3 发，9 帧一拍
                        shoot6(o, 0, 0, 67, 2, 6, 3, 1, v, 1.5, f, 0, nil, true)
                        f = f - 0.314159
                        v = v - 0.05
                        task.Wait(9)
                    end
                    f = 0
                    task.Wait(30)           -- ② → ③ 之间的 30 帧空档
                    for _ = 1, 20 do        -- ③ spr2 色档 11，2 发，7 帧一拍
                        shoot6(o, 0, 0, 67, 2, 11, 2, 1, v, 1.5, f, 0, nil, true)
                        f = f + 0.314159
                        v = v + 0.05
                        task.Wait(7)
                    end
                    for _ = 1, 20 do        -- ④ spr2 色档 8，3 发，7 帧一拍，打完回 ①
                        shoot6(o, 0, 0, 67, 2, 8, 3, 1, v, 1.5, f, 0, nil, true)
                        f = f - 0.314159
                        v = v - 0.05
                        task.Wait(7)
                    end
                end
            end)
        end
        task.New(self, function()
            self._box = box5(32, 48, 352, 128)
            local add, wait = kyorbit(self)
            task.Wait(240)                      -- t=0..120 MOVE_POS_TIME + t=120..240 SUB_CALL 2
            local a0 = ran:Float(0, 0.785398)   -- 原作 RAND_FLOAT f3_0 0.785398（只掷一次）
            for i = 1, 14 do
                doll(a0)
                a0 = a0 + 6.28319 / 14          -- 原作 f3_0 += 2π/14 再 NORMALIZE_ANGLE
            end
            ---原作 t=120 的 `SET_FLOAT *ORBR 0` ＋ 两条 `INIT_INTERP`
            ---（ORBR 0→96 ease-out-quad、ORBAV 0→**+0.01309** 线性）。
            add("_kR", 60, 96, 4)
            add("_kW", 60, 0.01309, 0)
            wait(61)                            -- 原作 t=181（墙钟 301）
            add("_kR", 60, 48, 4)
            add("_kW", 60, -0.00654498, 0)
            wait(60)                            -- 原作 t=241（墙钟 361）
            ---原作 t=241 的 `GET_EXIT_ANGLE *f0` 结果**没人读**（后面没有 MOVE_DIR_TIME），
            ---但它照样消耗掉一次 rand(0,π/2) ⇒ 必须照抽，否则整条随机流错位。
            exang(self)
            wait(60)                            -- 原作 t=301（墙钟 421）
            add("_kR", 60, 48, 4)
            add("_kW", 60, -0.00654498, 0)
            bmove(self, 60, 4, 0, 96)           -- MOVE_POS_TIME(60,4,192,128) ⇒ 我们 (0,96)
            wait(452)                           -- 原作 t=753（墙钟 873）
            exang(self)                         -- 同上：死代码的 GET_EXIT_ANGLE 仍要抽
            wait(60)                            -- 原作 t=813（墙钟 933）
            ---原作 t=1003 的 `JUMP 120`（rel 落点是 **t=180 的 `SET_INT *i2_2 3`**，不是 t=120）
            ---⇒ 一轮 883 帧（t=180→1003），t=120 的「放 14 只人形」只在第一次跑。
            while true do
                bmove(self, 60, 4, 0, 96)       -- t=813 的 MOVE_POS_TIME(60,4,192,128)
                add("_kR", 60, 96, 4)
                add("_kW", 60, 0.01309, 0)
                wait(250)                       -- 原作 t=180（墙钟 1183）
                add("_kR", 60, 48, 4)
                add("_kW", 60, -0.00654498, 0)
                wait(61)                        -- 原作 t=241（墙钟 1244）
                exang(self)                     -- 死代码：GET_EXIT_ANGLE 仍要抽
                wait(60)                        -- 原作 t=301（墙钟 1304）
                add("_kR", 60, 48, 4)
                add("_kW", 60, -0.00654498, 0)
                bmove(self, 60, 4, 0, 96)
                wait(452)                       -- 原作 t=753（墙钟 1756）
                exang(self)                     -- 死代码：GET_EXIT_ANGLE 仍要抽
                wait(60)                        -- 原作 t=813（墙钟 1816）
            end
        end)
        ---原作 sub54 t=0 的 `MOVE_POS_TIME 120 4 192 112`（= 我们 (0,112)），
        ---不是 `enter3b` 的 (0,96)：人形挂在本体身上，本体差 16px 就等于所有出膛点差 16px。
    end, { skin = skin3, enter = enter3c })

    ---──────────────────── 咒詛「首吊り蓬莱人形」（原作 sub56/57/58/59，L 行） ────────────────────
    ---墙钟 = ECL 时间：
    ---  · t=80 `MOVE_POS_TIME 120 4 192 112`（本仓库 enter3c 同款）；
    ---  · t=200 `SET_MOVEMENT_BOUNDS 144 96 240 128`（box5 ⇒ x∈[−48,48]、y∈[96,128]）
    ---    ＋ `SUB_CALL 2`（120 帧）；
    ---  · t=320 的 `DEC_JUMP` 循环在**同一帧**连放 5 只「人形」sub58；
    ---  · t=620 起进入 **308 帧一轮**的主循环（t=928 `JUMP` 回 t=620）：
    ---      i2_2：t=620 置 1（人形打 spr13）→ t=652 置 0 → t=682 置 2（人形打 spr14）
    ---             → t=714 置 0 → t=804 置 1 → t=836 置 0 → t=866 置 2 → t=898 置 0；
    ---      t=714 L 行写 commands[0] = `INIT_BULLET_CMD 0 32 0 120 -1 0 0.0261799`
    ---             → `SUB_CALL 57`（本体 11 根「针」spr10 色档 1、v=1.5；起始角
    ---             rand(−π,π)、每根再 +2π/11，同一帧全出）→ `MOVE_DIR_TIME 60 4 f0 0.75`；
    ---      t=774 `RING_ABS 6:6 i0 1 1 0.8 rand(−π,π) 0 514`（i0 = i2_3*3+32）；
    ---      t=836 再来一次 `MOVE_DIR_TIME 60 4 f0 0.75`；
    ---      t=898 L 行把 commands[0] 换成 `0x20 dur70 loop−1 speed−999 angle−0.0261799`
    ---             → `SUB_CALL 57` → `RING_ABS 6:6 i0 2 1.4 0.8 rand(−π,π) 0 514`（两层）
    ---             → `i2_3++`。
    ---  · 原作 `INIT_BULLET_CMD` 写的是**本体 `bulletProps.commands[0]`**（EclManager.cpp:1329），
    ---    写完一直跟着后面所有本体弹，直到被下一次覆盖 —— 所以 t=714 的 0x20 会同时挂到
    ---    针和 t=774 的环上，t=898 的那条只挂到该帧的针与环。
    ---人形 sub58：`MOVE_ORBIT 0 *X *Y *Z *f3_0 *f3_1 0 0`（半径 0、圆心 = 出生点）＋
    ---  `SET_EX_INS 5`（CopyMainBossMovement：每帧把**主 boss 的 pos / ORBR / ORBAV**
    ---  抄进子机的 moveInterpStartPos / orbitRadius / orbitAngleVel，**不抄 orbitAngle**）
    ---  ⇒ 5 只**绕本体公转**（半径 = 本体 ORBR、角速度 = 本体 ORBAV），不是叠在本体身上。
    ---  主循环每帧 `GET_BOSS_INT *i2_2 *i2_2 0` 读本体：非 1/2 时 1 帧一轮，
    ---  是 1/2 时 `SUB_CALL 59`（占 4 帧 = 该帧 + sub59 的 SUB_RET 在 t=3）。
    ---人形 sub59（L 行，一帧内两发；spr = gi0 = 13/14）：
    ---  ① `SPREAD_ABS 6:*i3_0 1 1 1.2 1.5 *f3_0 0.261799 576`
    ---     ＋ `INIT_BULLET_CMD 0 64 0 70 2 *f3_1 -999`（0x40：刹停 70 帧后角度 += f3_1
    ---       = −0.0523599 rad、速度取弹自身，2 轮）；
    ---  ② `SPREAD_ABS 6:*i3_0 1 1 3 1.5 *f3_0 0.261799 768`
    ---     ＋ `INIT_BULLET_CMD 0 256 0 70 1 *A2P 1.1`（0x100：70 帧后角度 = 自机方向、速度 1.1）。
    ---  （`*f3_0` / `*f3_1` 是 sub56 在 t=80 设、随 SPAWN_ENEMY_REL 继承下来的：
    ---    f3_0 = 该人形的出生角，f3_1 = −0.0523599。sub58 里 `SET_FLOAT *gf0 *ANG` /
    ---    `*gf1 ±2.51327` 在 sub59 里没有被读，原作里是死代码。）
    scard("咒詛「首吊り蓬莱人形」", 4438, 55, 3300, false, function(self)
        ---本体 `commands[0]`（t=714 L 行写的 0x20）。
        ---★ 角度一律按「TH07 弧度 → 本仓角度」取反（本仓 angle = −TH07 angle），
        ---  原作 cmd.angle = +0.0261799 ⇒ 我们 −0.0261799·RAD2DEG。
        local CMD_NEEDLE = { type = 0x20, dur = 120, loop = -1, speed = 0,
                             angle = -0.0261799 * RAD2DEG }
        ---本体 `commands[0]`（t=898 L 行换上的 0x20；原作 cmd.angle = −0.0261799）。
        local CMD_RING2 = { type = 0x20, dur = 70, loop = -1, speed = -999,
                            angle = 0.0261799 * RAD2DEG }
        ---原作 sub57（L 行）：11 根「针」在同一帧打完。这条波的 flags = 0x222
        ---（L 行的 `SPREAD_ABS 10:*i3_0 1 1 1.5 1.5 *f0 0 546`），含 0x20 位 ⇒
        ---本体 t=714/898 写进 `commands[0]` 的 0x20 会在针上激活；用 `cmds4(546, …)`
        ---把「哪条命令能被激活」交给 `RunCommands` 的 `flags & type` 判定。
        local function needle(cmd)
            local f0 = rngrad()                      -- RAND_FLOAT_ADD *f0 2π −π
            for _ = 1, 11 do
                shoot6(self, 0, 0, 65, 10, 1, 1, 1, 1.5, 1.5, f0, 0, cmds4(546, cmd), true)
                f0 = f0 + 6.28319 / 11               -- 原作 *f1 = 2π/11
            end
        end
        ---原作 sub58 + sub59（L 行）。a0 = 该人形继承到的 f3_0（出生角）。
        local function doll(a0)
            pspawn(self.x, self.y, function(o)
                ---★ 第 1 帧 `SET_EX_INS 5` 还没生效：走子机自己的 `MOVE_ORBIT` 角速度
                ---  f3_1（sub56 t=560 写的 **−0.0523599**）⇒ ang = −(θ0+f3_1)。
                local ang = -(a0 + (-0.0523599))      -- 我们的弧度（TH07 角取反）
                o._angdx, o._angdy = 0, 0
                task.New(o, function()
                    local ox, oy = o.x, o.y
                    while true do
                        local r = self._kR or 0
                        local nx = self.x + math.cos(ang) * r
                        local ny = self.y + math.sin(ang) * r
                        ---原作 `enemy->angle`（ENEMY_MOVE_ORBIT 的 exit 段，EclManager.cpp:1997）
                        ---= 本帧位置 − 上一帧位置的方向；ECL 里 `SET_FLOAT *gf0 *ANG`
                        ---（sub58）就是把它作为 sub59 的 a1。
                        o._angdx, o._angdy = nx - ox, ny - oy
                        ox, oy = nx, ny
                        o.x, o.y = nx, ny
                        task.Wait(1)
                        ---本体 ORBAV 是 TH07 口径，本仓库角度取反 ⇒ 每帧「减」。
                        ang = ang - (self._kW or 0)
                    end
                end)
                ---★ sub58 的三条 `SET_FLOAT/SET_INT *gf0/*gf1/*gi0` 是**给子程的参数**：
                ---  原作 `ECL_SUB_CALL` 会做
                ---  `enemy->currentContext.eclContextArgs.globalVars = g_GlobalEclVars`
                ---  （EclManager.cpp:1176），所以 `SUB_CALL 59` 里读到的 `*f3_0` **就是**
                ---  刚写的 gf0 = 该人形**此刻的朝向 `*ANG`**（= 上一帧位移方向），
                ---  `*f3_1` = ±2.513274、`*i3_0` = 13/14。
                ---  （`*ANG` 由 ENEMY_MOVE_ORBIT 的 exit 段每帧算：`angle = atan2(vx,vy)`
                ---    of `velocity = 目标轨道点 − 当前位置`，见 EclManager.cpp:1997。）
                local function sub59(spr, gf1)
                    local C40 = { type = 0x40, dur = 70, loop = 2,
                                  angle = -gf1 * RAD2DEG, resume_own = true }
                    local C100 = { type = 0x100, dur = 70, loop = 1,
                                   angle = Angle(o, player), speed = 1.1 }
                    ---原作 sub59 的 a1 = *f3_0 = 人形上一帧的位移方向（TH07 弧度）。
                    local a1 = -atan2(o._angdy or 0, o._angdx or 0)
                    shoot6(o, 0, 0, 65, 6, spr, 1, 1, 1.2, 1.5, a1, 0.261799, C40, true)
                    shoot6(o, 0, 0, 65, 6, spr, 1, 1, 3, 1.5, a1, 0.261799, C100, true)
                end
                while true do
                    local v = self._i2_2          -- GET_BOSS_INT *i2_2 *i2_2 0
                    if v == 1 then sub59(13, 2.513274)
                    elseif v == 2 then sub59(14, -2.513274) end
                    task.Wait((v == 1 or v == 2) and 4 or 1)
                end
            end)
        end
        task.New(self, function()
            task.Wait(80)                             -- 原作 t=0..80 的 prelude
            bmove(self, 120, 4, 0, 112)               -- t=80 MOVE_POS_TIME 120 4 192 112
            task.Wait(120)                            -- t=80..200
            self._box = box5(144, 96, 240, 128)       -- SET_MOVEMENT_BOUNDS
            self._i2_2 = 0
            task.Wait(120)                            -- 原作 SUB_CALL 2（wall 200..320）
            local add, wait = kyorbit(self)
            local a0 = ran:Float(0, 0.785398)         -- RAND_FLOAT *f3_0 0.785398
            for _ = 1, 5 do                           -- t=560 的 DEC_JUMP 循环（同一帧放完 5 只）
                doll(a0)
                a0 = a0 + 6.28319 / 5                 -- *f3_0 += 2π/5、NORMALIZE_ANGLE
            end
            ---原作 t=560 的 `SET_FLOAT *ORBR 0` ＋ 两条 `INIT_INTERP`
            ---（ORBR 0→96 ease-out-quad、ORBAV 0→**−0.0523599** 线性）。
            add("_kR", 60, 96, 4)
            add("_kW", 60, -0.0523599, 0)
            wait(60)                                  -- 原作 t=620（轮首）
            local c1 = 32                             -- i0 = i2_3*3 + 32
            ---★ 主循环必须用 `wait`（= 逐帧推进 ORBR/ORBAV 的两条 `INIT_INTERP` 再等 1 帧），
            ---  不能用裸 `task.Wait`：裸等不会推进插值 —— 原作 `INIT_INTERP` 是
            ---  **每帧**在 RunEcl 的 exit 段推进的（EclManager.cpp:2173），与主程用哪种等待无关。
            while true do
                self._i2_2 = 1; wait(32)              -- t=620 → 652
                self._i2_2 = 0
                add("_kR", 60, 48, 4)                 -- t=652：ORBR 96→48、ORBAV →+0.0261799
                add("_kW", 60, 0.0261799, 0)
                wait(30)                              -- 652 → 682
                self._i2_2 = 2; wait(32)              -- 682 → 714
                self._i2_2 = 0
                needle(CMD_NEEDLE)                    -- t=714 SUB_CALL 57
                drift(self, 0.75, 60)                 -- MOVE_DIR_TIME 60 4 *f0 0.75
                wait(60)                              -- 714 → 774
                add("_kR", 60, 48, 4)                 -- t=774：48→48、ORBAV →−0.0261799
                add("_kW", 60, -0.0261799, 0)
                ---原作这条 RING_ABS 的 flags = 0x202（无 0x20 位）⇒ 本体 commands[0]
                ---虽仍是 t=714 的 0x20，但 `moreFlags & 0x20 == 0` 永不激活，环不转。
                shoot6(self, 0, 0, 67, 6, 6, c1, 1, 1, 0.8, rngrad(), 0,
                       cmds4(514, CMD_NEEDLE), true)
                wait(30)                              -- 774 → 804
                self._i2_2 = 1; wait(32)              -- 804 → 836
                self._i2_2 = 0
                add("_kR", 60, 96, 4)                 -- t=836：48→96、ORBAV →+0.0523599
                add("_kW", 60, 0.0523599, 0)
                drift(self, 0.75, 60)                 -- t=836 的 MOVE_DIR_TIME
                wait(30)                              -- 836 → 866
                self._i2_2 = 2; wait(32)              -- 866 → 898
                self._i2_2 = 0
                add("_kR", 60, 96, 4)                 -- t=898：ORBR →96、ORBAV →−0.0523599
                add("_kW", 60, -0.0523599, 0)
                needle(CMD_RING2)                     -- t=898 SUB_CALL 57
                ---同上：flags = 0x202，t=898 写进 commands[0] 的 0x20 不激活。
                shoot6(self, 0, 0, 67, 6, 6, c1, 2, 1.4, 0.8, rngrad(), 0,
                       cmds4(514, CMD_RING2), true)
                c1 = c1 + 3                           -- INC *i2_3
                wait(30)                              -- 898 → 928（JUMP）
            end
        end)
    end, { skin = skin3, enter = function(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 224
    end })

--- @STAGE56_CARDS
    ---════════════════════════════════════════════════════════════════════
    ---以下：stage4（普莉兹姆利巴三姐妹 · 露娜萨 / 梅露兰 / 莉莉卡）的符卡与非符移植
    ---（原作 `ecldata4.ecl`）。
    ---
    ---原作结构：一只不可见的「母亲」sub42（`SET_BOSS 0`，血量 = 三姐妹血量之和）
    ---同时生成三只姐妹副 BOSS —— sub53 露娜萨(bossId 1)、sub71 梅露兰(bossId 2)、
    ---sub88 莉莉卡(bossId 3) —— 再由 sub43..sub51 用 `SET_BOSS_RUN_INTERRUPT`
    ---逐个「点名」某个 interrupt slot（= 一段非符或一张符卡），此外每只姐妹还会
    ---生成一只「乐器灵」（sub108/115/118，bossId 4/5/6）做演出。本仓库是
    ---「一卡一独立挑战」的口径，所以把 Lunatic 行里有名字的符卡、以及三姐妹
    ---各自那一套表里的非符，各拆成一张卡，并把被点名的那只姐妹放到场地中央。
    ---
    ---原作 sub 对照（只取 Lunatic 行）：
    ---  露娜萨 非符        = sub58 → sub59 / sub60 / sub62
    ---  騒符「ライブポルターガイスト -Lunatic-」 = sub121 → sub124 / sub126
    ---  梅露兰 非符        = sub76（+ sub60 漂移）
    ---  管霊「ゴーストクリフォード -Lunatic-」 = sub138 → sub139 / sub140
    ---  莉莉卡 非符        = sub95
    ---  鍵霊「ベーゼンドルファー神奏 -Lunatic-」 = sub145 → sub146 / sub147 / sub148 / sub149
    ---  偽弦「スードストラディヴァリウス」 = sub128 → sub130
    ---  騒葬「スティジャンリバーサイド -Lunatic-」 = sub133 → sub134
    ---  大合葬「霊車コンチェルトグロッソ怪」 = sub135 → sub136
    ---
    ---原作的 `DEC_JUMP` 循环**不消耗帧**（JUMP 把 time 设回已经过去的 t，同帧内把
    ---整圈打完），所以「30 圈 × 12 发」这种写法在真机上是一帧几百发 —— 照抄即可，
    ---本仓库的弹池满 1024 就按原作规则丢弹。
    ---
    ---坐标 / 角度 / 血量口径同文件头（x−192、224−y、θ 取反）。三姐妹的立绘
    ---（`THlib/BossImageList.lua` 有 "Lunasa"/"Merlin"/"Lyrica"）。
    ---卡 id 段：stage4 = 4440..4448（已扫过全项目 `boss.card.add` 末参无冲突）。
    ---════════════════════════════════════════════════════════════════════
    ---三姐妹各自的立绘 / 进场（从下方升到场地中央，同 stage3 的 enter3b）。
    local function skin4of(img, wall)
        return function(self)
            self.NotPlayTimeOutSound = wall and true or false
            self.colli = not wall
            self.no_hp_render = wall and true or false
            setface(self, img)
        end
    end
    local skin4L, skin4Lw = skin4of("Lunasa", false), skin4of("Lunasa", true)
    local skin4M, skin4Mw = skin4of("Merlin", false), skin4of("Merlin", true)
    local skin4R, skin4Rw = skin4of("Lyrica", false), skin4of("Lyrica", true)
    local function enter4(self)
        self._orb, self._mv = nil, nil
        ---原作三姐妹由 sub42 `SPAWN_ENEMY_ABS 53/71/88 0 0 0`（= 绝对 (0,0)）生成，
        ---之后各自的 SET_MOVEMENT_BOUNDS 才把她们夹进框里 ⇒ 起点就是 TH07 (0,0)。
        self.x, self.y = -192, 224
    end
    ---从**绝对点** (ax, ay) 打一发；th 用 TH07 口径的弧度（y 朝下、逆时针正），
    ---内部转成我们的角度（取反）。cmd 可省（= 普通直线弹）。
    local function dot4(ax, ay, spr, col, v, th, cmd)
        local b
        if cmd then
            b = New(class["TH34_cmdbullet"], bs(spr), col16(col), ax, ay, v,
                    -th * RAD2DEG, cmd)
        else
            b = NewSimpleBullet(bs(spr), col16(col), ax, ay, v, -th * RAD2DEG,
                                false, 0, false)
        end
        pool4[#pool4 + 1] = b
    end
    ---以**绝对点** (ax, ay) 为心的 n 发扇（op65 SPREAD_ABS，c2 层从 v1 减速到 v2）。
    local function fan4(self, ax, ay, spr, col, n, c2, v1, v2, a1, a2, cmd)
        shoot6(self, ax - self.x, ay - self.y, 65, spr, col, n, c2 or 1, v1,
               v2 or 0.5, a1, a2 or 0, cmd, false)
    end
    ---以**绝对点** (ax, ay) 为心的整圈（op67 RING_ABS；a2 是逐层旋转量）。
    local function ring4(self, ax, ay, spr, col, n, c2, v1, v2, a1, a2, cmd)
        shoot6(self, ax - self.x, ay - self.y, 67, spr, col, n, c2 or 1, v1,
               v2 or 0.5, a1 or 0, a2 or 0, cmd, false)
    end
    ---INIT_BULLET_CMD 0x20 TargetAngle：每帧角度 += rate（TH07 弧度/帧 ⇒ 取反转度）。
    ---`flag` 是 ECL 的第 3 个参数：`RunCommands` 里 `flag == 0 && exFlags != 0` 会把
    ---**整段扫描停住**（不只跳过这一条），所以「0x40 先激活、0x20 之后才轮到」的卡
    ---必须把 0x20 写成 flag=1（原作 sub51 的 `INIT_BULLET_CMD 1 32 1 …`）。
    local function spin4(rate_th, dur, flag)
        return { type = 0x20, dur = dur or 60, loop = -1,
                 speed = 0, angle = -rate_th * RAD2DEG, flag = flag }
    end
    ---INIT_BULLET_CMD 0x40 DirChangeAndResume：先刹停 dur 帧，再转 rate 弧度、回到
    ---speed 重复 loop 轮（莉莉卡非符的「停一下拐 60° 再飞」就是这个）。
    local function turn4(rate_th, speed, dur, loop)
        return { type = 0x40, dur = dur or 60, loop = loop or 3,
                 angle = -rate_th * RAD2DEG, speed = speed }
    end
    ---──────────────────── 露娜萨 非符 1（原作 sub58 → sub59 / sub60 / sub62） ────────────────────
    ---逐条照抄 `ecldata4.ecl` 的 Lunatic 行（不做任何密度/手感调整）：
    ---  · sub58（本体，一轮 1580 帧）：SET_MOVEMENT_BOUNDS(32,48,352,128)；
    ---    t=50/210/370/530/690/720/780×2/840×2 各 SUB_CALL 59，参数依次
    ---    gF0=±128/±64/±112/±160、gI0∈{0,1,3}、gI1∈{2,6,13}、gI2=4、gI3∈{3..7}；
    ---    t=110/270/430/1140 各 SUB_CALL 60；t=590 MOVE_POS_TIME(100,4,192,112)；
    ---    t=1240 JUMP 回 t=50。
    ---  · SUB_CALL 在 TH07 里是**阻塞**的（`EclManager.cpp:1173` 先存 currentContext，
    ---    SUB_RET 再取回）：子程跑掉多少帧，本体的时间轴就整体往后顶多少帧。所以
    ---    sub59 的 39 帧、sub3 的 8 帧必须真的把后面的 t 顶后 —— 这一版用
    ---    「直接调用 + task.Wait」复刻，而不是 task.New 平行跑。
    ---  · sub3（8 帧）：把本体沿 (gF0,0) 推一下再推回来（净位移 0）+ 两批 16 粒粒子
    ---    （本仓库没有粒子接口，只保留 8 帧时长与净位移 0）。
    ---  · sub59（39 帧）：t=1 调 sub3；t=31 从 boss+(gF0,0) 朝「自机∓128」打 1 发
    ---    sprite10（v:4→0.5、色档 gI0、flags 0x3204），同帧在 boss+(gF0,0) 生成炮台
    ---    sub62（继承 i0=gI1、i1=gI2、i2=gI3，f3 = 该瞄准角）。
    ---  · sub60（0 帧）：GET_EXIT_ANGLE 取一个「背对自机」的随机角 →
    ---    MOVE_DIR_TIME(100,4,θ,0.8)。
    ---  · sub62（炮台，活 260 帧）：以 4/帧 沿 f3 飞 120 帧；t=20 起每 8 帧一扇 5 发
    ---    sprite0（v:3→0.5、半张角 0.19635、a1=f3+π、flags 0x204）共 15 扇；t=28 起
    ---    反向再飞 120 帧，并每 4 帧一轮 i2(=gI3) 发「全角随机」sprite3
    ---    （v:0.8→0.2、a1=f3+π/2、a2=f3−π/2、flags 0x214、挂 0x10 减速命令
    ---    −0.015/帧）共 30 轮，随后 UNIMP 自毁。
    ---
    ---原作 sub3：8 帧的位移抖动（净位移 0 ⇒ 这里只等 8 帧）。
    local function luna_jolt(self)
        task.Wait(8)
    end
    ---原作 op72 RANDOM（`BulletManager.cpp:215`）：每发 angle=rand(a1−a2)+a2、
    ---speed=rand(v1−v2)+v2（逐发各抽两次随机数，与 vm 桩件同序）。
    local function rnd4(self, spr, off, n, v1, v2, a1_th, a2_th, cmd, plays)
        local style, col = bs(spr), col16(off)
        local room = POOL4_SIZE - pool4_used()
        for _ = 1, min(n, room) do
            ---★ 原作 op72 RANDOM 逐发**先抽角、后抽速**
            ---（`BulletManager.cpp:227-231`：bulletAngle 先 frange(angle1−angle2)，
            ---再 bulletSpeed = frange(speed1−speed2)）。顺序反了随机流整条错位。
            local a = -(ran:Float(a2_th, a1_th)) * RAD2DEG
            local v = ran:Float(v2, v1)
            local o
            if cmd then
                ---原作这两批随机弹的 flags = 0x214（含 0x10 位）⇒ sub62 t=28 写进
                ---`commands[0]` 的 0x10（dur160、speed −0.015/帧、angle −999 ⇒
                ---沿弹自身朝向）会在每发上激活，做 160 帧的线性减速。
                o = New(class["TH34_cmdbullet"], style, col, self.x, self.y, v, a, cmd)
            else
                o = NewSimpleBullet(style, col, self.x, self.y, v, a, false, 0, false)
            end
            pool4[#pool4 + 1] = o
        end
        if plays then sound4(self) end
    end
    ---原作 sub62 炮台。a = { 瞄准角(TH07 弧度), 首扇色档 gI1, 随机弹色档 gI2, 随机弹条数 gI3 }。
    local function luna_turret(self, a)
        local ang, off0, off1, cnt = a[1], a[2], a[3], a[4]
        local dir = -ang                       -- TH07 角 → 我们的角（y 轴取反）
        task.Wait(20)                          -- t=20
        bmove(self, 120, 0, self.x + cos(dir * RAD2DEG) * 480,
              self.y + sin(dir * RAD2DEG) * 480)
        for _ = 1, 15 do
            shoot6(self, 0, 0, 65, 0, off0, 5, 1, 3, 0.5,
                   ang + PI, 0.19635, nil, true)
            task.Wait(8)
        end
        bmove(self, 120, 0, self.x - cos(dir * RAD2DEG) * 480,
              self.y - sin(dir * RAD2DEG) * 480)
        for _ = 1, 30 do
            ---0x10：原作 L 行 `INIT_BULLET_CMD 0 16 0 160 -1 -0.015 -999`
            ---（`-0.015` 是每帧速率增量、`-999` 表示方向沿用弹自身朝向）。
            rnd4(self, 3, off1, cnt, 0.8, 0.2, ang + PI / 2, ang - PI / 2,
                 { type = 0x10, dur = 160, loop = -1, speed = 0, angle = -999,
                   accel = -0.015 }, true)
            task.Wait(4)
        end
    end
    ---原作 sub59（阻塞调用，共 39 帧）。参数 = (gF0, gI0, gI1, gI2, gI3)。
    local function luna_sub59(self, f0, off0, gi1, gi2, gi3)
        task.Wait(1)                           -- t=1
        luna_jolt(self)                        -- SUB_CALL 3：8 帧
        task.Wait(30)                          -- t=31
        ---瞄点：f0>0 ⇒ PX−128，否则 PX+128（原作 sub59 t=31 的 JLEQ_F 分支）。
        local aimx = player.x + ((f0 > 0) and -128 or 128)
        local th = atan2(self.y - player.y, aimx - (self.x + f0))
        shoot6(self, f0, 0, 65, 10, off0, 1, 1, 4, 0.5, th, 0, nil, true)
        pspawn(self.x + f0, self.y, luna_turret, { th, gi1, gi2, gi3 })
    end
    ncard("露娜萨 非符 1", 4440, 16000, 1600, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            local function c59(f0, off0, gi1, gi2, gi3)
                luna_sub59(self, f0, off0, gi1, gi2, gi3)
            end
            local function c60()
                drift(self, 0.8, 100, 4)
            end
            task.Wait(50)                          -- t=50
            while true do
                c59( 128, 1,  6, 4, 5)             -- t=50
                task.Wait(60);  c60()              -- t=110
                task.Wait(100); c59(-128, 0,  2, 4, 6)   -- t=210
                task.Wait(60);  c60()              -- t=270
                task.Wait(100); c59( 128, 1,  6, 4, 6)   -- t=370
                task.Wait(60);  c60()              -- t=430
                task.Wait(100); c59(-128, 0,  2, 4, 7)   -- t=530
                task.Wait(60)                      -- t=590
                bmove(self, 100, 4, 0, 112)        -- MOVE_POS_TIME(100,4,192,112)
                task.Wait(100); c59(  64, 1,  6, 4, 3)   -- t=690
                task.Wait(30);  c59( -64, 1,  6, 4, 3)   -- t=720
                task.Wait(60);  c59( 112, 0,  2, 4, 4)   -- t=780
                                c59(-112, 0,  2, 4, 4)   -- t=780（同帧第二组）
                task.Wait(60);  c59( 160, 3, 13, 4, 5)   -- t=840
                                c59(-160, 3, 13, 4, 5)   -- t=840（同帧第二组）
                task.Wait(300); c60()              -- t=1140
                task.Wait(100)                     -- t=1240 → JUMP 回 t=50
            end
        end)
    end, { skin = skin4L, enter = enter4 })

    ---──────────────────── 騒符「ライブポルターガイスト -Lunatic-」 ────────────────────
    ---原作 sub121 → sub124 → sub126，Lunatic 行逐条照抄：
    ---  · sub121：t=0 MOVE_POS_TIME(120,4,192,128)（= 我们 (0,96)，与 enter4 同点）；
    ---    t=120 SET_MOVEMENT_BOUNDS(32,48,352,128) 后 SUB_CALL 2（16 帧粒子）；
    ---    t=190 同帧连做 4 组 SUB_CALL 124，参数依次
    ---      k=0: i0=0 i2=3 f4=2.5 f5=1.5 f3=0        gF0=0  gF1= 3π/2
    ---      k=1: i0=1 i2=3 f4=3   f5=1.5 f3=0        gF0=π  gF1=−3π/2
    ---      k=2: i0=2 i2=3 f4=3.4 f5=1.6 f3=0        gF0=0  gF1= 3π/2
    ---      k=3: i0=3 i2=3 f4=3.6 f5=1.7 f3=0.19635  gF0=π  gF1=−2π
    ---    之后 SET_WAIT_TIMER 40、JUMP 回 t=150（再走 40 帧到 t=190）
    ---    ⇒ 一轮 = 4×108 + 40 + 40 = 512 帧。
    ---  · sub124（108 帧）：36 次「生成 sub126」，每 3 帧一次；每次把 f0 沿 gF1/36
    ---    推进并叠一个 ±0.0490874 的随机相位（这条 f0 只喂非 Lunatic 行的
    ---    SPREAD_ABS，L 行的 SPREAD_AIMED 用不到）。
    ---  · sub126（幽灵，静止）：MOVE_DIR_TIME 的时间参数是 0，所以它一步都不走；
    ---    按传入的 i0 选一套 ANM 并把 i0 换成色档（0→2、1→10、2→6、3→13）；
    ---    120 帧后打一扇 SPREAD_AIMED（sprite6、count1=i1=1、count2=i2=3、
    ---    v: f4→f5、瞄准自机、半张角 f3、flags 0x204），随即 UNIMP 自毁 ——
    ---    L 行那条 RING_ABS 排在 JUMP 之后，原作根本不会执行。
    ---sub126 的 i0 分支 → 弹色档。
    local PG_I0 = { [0] = 2, [1] = 10, [2] = 6, [3] = 13 }
    ---原作 sub126：t=0 `MOVE_DIR_TIME 0 0 *f0 *f1` —— **timer=0 ⇒ 极坐标持续飞行**
    ---（EclManager.cpp:1537-1547：angle = normalize(*f0)、speed = *f1，不是「不动」）；
    ---t=60 `SET_ANGULAR_VEL *f2` 起转向；t=120 原地一扇 SPREAD_AIMED 后自毁。
    ---a = { 色档, count2, v1, v2, 半张角, 初角(TH07 rad), 速度, 自转角速度 }。
    local function pg_ghost(self, a)
        local col, c2, v1, v2, a2th, f0, f1, av = a[1], a[2], a[3], a[4], a[5],
                                                  a[6], a[7], a[8]
        local ang = f0
        for i = 1, 120 do
            if i > 60 then ang = ang + av end          -- t=60 起每帧 += *f2
            self.x, self.y = self.x + math.cos(ang) * f1, self.y - math.sin(ang) * f1
            task.Wait(1)
        end
        shoot6(self, 0, 0, 64, 6, col, 1, c2, v1, v2, 0, a2th, nil, true)
    end
    ---原作 sub124：36 只幽灵、每 3 帧一只（共 108 帧）。每只：
    ---  f0 = rand(0.0981748) − 0.0490874 + gF0（NORMALIZE_ANGLE 只影响符号，角函数同值）、
    ---  f2 = rand(父 f2) − 父 f2/2（每只独立的自转角速度）。
    local function pg_wave(self, i0, c2, v1, v2, a2th, gf0, f2, gf1)
        ---原作 sub124 的 `DEC_JUMP 0 -104 *i2_0` 跳回 instr@136
        ---（`RAND_FLOAT_ADD *f2 *f7 *f6`）——循环体是 [6..9]，所以 `*f0` 的随机初值
        ---**只在循环外抽一次**，循环里每只只重掷自转角速度 f2，`*f0` 按
        ---`*f3_1 = *gF1 / 36` 逐只累加（36 只跨 3π/2 或 2π 扫过一圈）。
        local f0 = ran:Float(0, 0.0981748) - 0.0490874 + gf0
        local step = gf1 / 36
        for _ = 1, 36 do
            local av = ran:Float(0, f2) - f2 / 2
            pspawn(self.x, self.y, pg_ghost,
                   { PG_I0[i0], c2, v1, v2, a2th, f0, 1.2, av })
            f0 = f0 + step
            task.Wait(3)
        end
    end
    scard("騒符「ライブポルターガイスト -Lunatic-」", 4441, 60, 3000, false, function(self)
        task.New(self, function()
            bmove(self, 120, 4, 0, 96)                  -- t=0 MOVE_POS_TIME(120,4,192,128)
            task.Wait(120)                              -- t=120
            self._box = box5(32, 48, 352, 128)
            task.Wait(16)                               -- SUB_CALL 2：16 帧
            ---SUB_CALL 是阻塞的：sub2 吃掉 16 帧，本体的 t 被整体顶后，
            ---所以 t=150 落在第 166 帧、t=190 落在第 206 帧。
            task.Wait(30)                               -- t=150（SET_ANM 演出）
            task.Wait(40)                               -- t=190 → 第一波在 206
            while true do
                pg_wave(self, 0, 3, 2.5, 1.5, 0,       0, 0,        4.71239)   -- 108 帧
                pg_wave(self, 1, 3, 3.0, 1.5, 0,   3.14159, 0,       -4.71239)   -- 108 帧
                pg_wave(self, 2, 3, 3.4, 1.6, 0,       0, 0.00392699, 4.71239)   -- 108 帧
                pg_wave(self, 3, 3, 3.6, 1.7, 0.19635, 3.14159, 0.015708,-6.28319) -- 108 帧
                task.Wait(40)                               -- SET_WAIT_TIMER 40
                task.Wait(40)                               -- JUMP t=150 → t=190
            end
        end)
    end, { skin = skin4L, wallskin = skin4Lw, enter = enter4 })

    ---──────────────────── 梅露兰 非符 1（原作 sub76 → sub77 / sub60） ────────────────────
    ---逐条照抄 `ecldata4.ecl` 的 Lunatic 行：
    ---  · sub76（本体，一轮 320+w 帧）：t=0 SET_MOVEMENT_BOUNDS(32,48,352,128)；
    ---    t=35..85 六发 SPAWN_EFFECT（纯演出，本仓库无粒子接口，略）；t=85
    ---    SET_BULLET_RANK_PARAMS 0 0 0 0 0 0（L 行 rank 修正全 0）+ SET_ANM 135
    ---    + `SET_INT *i1 100`，同帧生成两只「乐器灵」sub77（i0=0/1）；t=145 一扇
    ---    spider 自机狙 1×8（v:5→0.5、半张角 0.0392699）+ SUB_CALL 60；t=205 一扇
    ---    3×8（半张角 0.0785398）+ 再生成两只 sub77 + `SET_WAIT_TIMER *i1`
    ---    （i1 从 100 起每轮 `SUB *i1 *i1 20` 减 20；JUMP 回 t=85 时**跳过**
    ---    `SET_INT *i1 100`，所以空等逐轮变短：100/80/60/40/20/0/0/…）；
    ---    t=265 一扇 1×8（v:4）、t=285 2×8（v:4.2）、t=305 2×8（v:4.4）+ SUB_CALL 60、
    ---    t=325 3×8（v:4.6）、t=345 3×8（v:4.8），t=405 JUMP 回 t=85（不消耗帧）。
    ---  · sub60（0 帧）：GET_EXIT_ANGLE 取一个「背对自机」的随机角 →
    ---    MOVE_DIR_TIME(gI0=30, 4, θ, gF0=1) ⇒ 沿该角以 1 px/帧漂 30 帧。
    ---  · sub77（乐器灵）：MOVE_ORBIT 120 帧绕出生点公转（半径 0.8/帧 → 96 px、
    ---    角速度 ±0.0392699、起始角 π/2）；t=119 朝自机打一扇 sprite1 48×4
    ---    （v:2.5→1、flags 0x200），随即 JUMP 回 t=119 —— 只发这一发，
    ---    之后纯属自转演出（SET_AXIS_SPEED 那段不产弹）。
    ---原作 sub77：一只「乐器灵」，公转 120 帧后朝自机打一发 48×4 环。
    local function merlin_orb(self, i0)
        local cx, cy = self.x, self.y
        pspawn(cx, cy, function(o)
            local av = (i0 == 0) and 0.0392699 or -0.0392699
            local ang, r = math.pi / 2, 0
            for _ = 1, 119 do
                ang, r = ang + av, r + 0.8
                o.x, o.y = cx + math.cos(ang) * r, cy - math.sin(ang) * r
                task.Wait(1)
            end
            shoot6(o, 0, 0, 66, 1, 2, 48, 4, 2.5, 1, 0, 0, nil, false)
            while true do task.Wait(1) end
        end)
    end
    ncard("梅露兰 非符 1", 4442, 16000, 1600, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            task.Wait(85)                               -- t=0..85（含六发 SPAWN_EFFECT）
            local i1 = 100
            while true do
                merlin_orb(self, 0)                     -- t=85
                merlin_orb(self, 1)
                task.Wait(60)                           -- t=145
                shoot6(self, 0, 0, 64, 6, 6, 1, 8, 5, 0.5, 0, 0.0392699, nil, true)
                drift(self, 1, 30)                      -- SUB_CALL 60
                task.Wait(60)                           -- t=205
                shoot6(self, 0, 0, 64, 6, 6, 3, 8, 5, 0.5, 0, 0.0785398, nil, true)
                merlin_orb(self, 0)                     -- t=205
                merlin_orb(self, 1)
                if i1 > 0 then task.Wait(i1) end        -- SET_WAIT_TIMER *i1
                i1 = i1 - 20                            -- SUB *i1 *i1 20
                task.Wait(60)                           -- t=265
                shoot6(self, 0, 0, 64, 6, 6, 1, 8, 4, 0.5, 0, 0.0392699, nil, true)
                task.Wait(20)                           -- t=285
                shoot6(self, 0, 0, 64, 6, 6, 2, 8, 4.2, 0.5, 0, 0.0448799, nil, true)
                task.Wait(20)                           -- t=305
                shoot6(self, 0, 0, 64, 6, 6, 2, 8, 4.4, 0.5, 0, 0.0523599, nil, true)
                drift(self, 1, 30)                      -- SUB_CALL 60
                task.Wait(20)                           -- t=325
                shoot6(self, 0, 0, 64, 6, 6, 3, 8, 4.6, 0.5, 0, 0.0628319, nil, true)
                task.Wait(20)                           -- t=345
                shoot6(self, 0, 0, 64, 6, 6, 3, 8, 4.8, 0.5, 0, 0.0785398, nil, true)
                task.Wait(60)                           -- t=405 JUMP → t=85
            end
        end)
    end, { skin = skin4M, enter = enter4 })

    ---──────────────────── 管霊「ゴーストクリフォード -Lunatic-」 ────────────────────
    ---逐条照抄 `ecldata4.ecl` 的 Lunatic 行（sub138 → sub139 → sub140）：
    ---  · sub138（本体，一轮 868 帧）：t=0 MOVE_POS_TIME(120,4,192,104)；
    ---    t=150 `SUB_CALL 2`（阻塞 16 帧）→ 之后所有 t 整体 +16；t=180/188/196/204/212
    ---    各 `SUB_CALL 139` 生一只「管灵」（同一帧先 `*f0 = *RNGRAD`、再 `*f0 += 2π/5`，
    ---    五只的 gF0=64、gF1=160/188/216/244/272、gF3=−0.0981748、gF2=f0）；
    ---    t=312 `SUB_CALL 60`（gI0=60、gF0=1.5 ⇒ drift 1.5/帧×60）；t=372 再 `SUB_CALL 2`；
    ---    t=402..434 第二波（gF0=352、gF1=320/292/264/236/208、gF3=−2.35619、
    ---    方向 *f7=−0.0523599）；t=534 `SUB_CALL 60`；t=594 `SUB_CALL 2`；
    ---    t=624..656 第三波（gF0=32、gF1=48..160、gF3=1.5708/1.37445/0.589049/
    ---    0.392699/0）；t=676 `SUB_CALL 2`（**中间没有 SUB_CALL 60**）；
    ---    t=706..738 第四波（gF0=352、gF1=48..160、gF3=1.5708/1.76715/2.55254/
    ---    2.74889/3.14159）；t=838 `SUB_CALL 60`（gI0=100、gF0=1.5）；t=938 `SUB_CALL 2`；
    ---    t=938 JUMP 回 t=150（一次 JUMP 同帧起算，所以下一轮 t=180 再空 16+30 帧）。
    ---  · sub139（0 帧）：把 gF0/gF1/gF2/gF3 抄进局部 f0/f3_0/f1/f2，再抽一个随机角 f3，
    ---    然后生一只 sub140（子机继承这套局部变量）。
    ---  · sub140（管灵）：t=0 MOVE_ORBIT(60, 出生点, 起始角 f1, 角速度 f3_1=±0.0523599,
    ---    半径 0→1.6/帧)；t=60 INIT_INTERP 120 帧飞到本波固定落点；t=180 打一发
    ---    16 发环（sprite6、v:2→0.5、flags 0x202），随后 SET_MOVE_ACCEL 0.0333333
    ---    改沿 f2 加速漂走，并进入 `SET_WAIT_TIMER *i0(=32)` 的循环：
    ---    每 32 帧一扇 SPREAD_AIMED（1×4、v:2.2→0.5、半张角 0.392699、
    ---    a1=f3 且每轮 f3 += f4，f4 = (f2<=0 ? +0.314159 : −0.314159)）——
    ---    **第一扇在 t=212**（先等 32 帧再打），扇上挂 0x80 指令（50 帧刹停、1.8 速重复）。
    scard("管霊「ゴーストクリフォード -Lunatic-」", 4443, 60, 3200, false, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            bmove(self, 120, 4, 0, 120)             -- t=0 MOVE_POS_TIME(120,4,192,104)
            ---ang0 公转初角、av 公转角速度、tx/ty 落点（我们的坐标）、th 漂移方向（TH07 弧度）。
            ---th = 漂移方向（TH07 弧度）、f3 = 原作 sub139 #4 在**生成本子机的当帧**抽的 RNGRAD。
            local function ghost(ang0, av, tx, ty, th, f3)
                local sx, sy = self.x, self.y
                pspawn(sx, sy, function(o)
                    local ang, r, px, py = ang0, 0, sx, sy
                    for _ = 1, 60 do
                        px, py = o.x, o.y
                        ang, r = ang + av, r + 1.6
                        o.x, o.y = sx + math.cos(ang) * r, sy - math.sin(ang) * r
                        task.Wait(1)
                    end
                    ---t=60 的 INIT_INTERP（120 帧）：X 的切线取 Δx*144 与
                    ---cos(gF3)*244，Y 取 Δy*144 与 sin(gF3)*244（我们的 y 取反）。
                    local x0, y0 = o.x, o.y
                    local mx0, my0 = (o.x - px) * 144, (o.y - py) * 144
                    local mx1, my1 = math.cos(th) * 244, -math.sin(th) * 244
                    ---★原作 sub140 t=60 的 `INIT_INTERP *X 120 7 0 *X *f0 *f1 *f4`（Y 同型）
                    ---  的 easing 字段是 **0 ⇒ 线性**（EclManager.cpp:1078/2200 的 switch 没有
                    ---  case 0，t 原样送进 MathCubicInterp）——不是 ease-out-quad。p0/p1/m0/m1
                    ---  同样在建立时冻结；目标 tx/ty 由调用方在生成本子机的那一刻算好。
                    for i = 1, 120 do
                        local u = i / 120
                        o.x = hermite(u, x0, tx, mx0, mx1)
                        o.y = hermite(u, y0, ty, my0, my1)
                        task.Wait(1)
                    end
                    ---t=180：一发 16 环 + 转成「沿 f2 加速漂走」。
                    ring4(o, o.x, o.y, 6, 2, 16, 1, 2, 0.5, 0, 0.0785398, nil)
                    ---★ 原作 sub140 的 `INIT_BULLET_CMD 0 128 0 50 1 0 1.8` 虽然写了，
                    ---但两条波（RING_ABS / SPREAD_AIMED）的 flags 都是 514=0x202，
                    ---**不含 0x80 位** ⇒ `RunCommands` 里 `moreFlags & 0x80 == 0` 直接跳过，
                    ---这条指令在任何一发上都激活不了。早年给 SPREAD_AIMED 挂上
                    ---`brake_aim6(50,1.8,0,1)` 是多余的 ⇒ 弹平白每帧掉 2.2/50 速度。
                    ---★ 原作 sub139 #4 的 `SET_FLOAT *f3 *RNGRAD` 在**生成管灵那一帧**就抽了；
                    ---  搬到这里补抽会把整条随机流往后拖 180 帧，从此全卡随机全错位。
                    ---原作 #26 `*f2 += π/2`→#27 归一化→#28 `JLEQ_F *f2 0` 跳 #31：
                    ---f2<=0 取 −0.314159、否则 +0.314159（比较的是**加过 π/2 的值**）。
                    local f4 = (((th + 1.5708) % (2 * PI) + PI) % (2 * PI) - PI) <= 0
                            and -0.314159 or 0.314159
                    local dx, dy, spd = math.cos(th), -math.sin(th), 0
                    while true do
                        for _ = 1, 32 do
                            spd = spd + 0.0333333
                            o.x, o.y = o.x + dx * spd, o.y + dy * spd
                            task.Wait(1)
                        end
                        ---原作 sub140 #43（L 行）SPREAD_AIMED 的 a1 = 0（#39 的 a1=*f3 是 N 行）。
                        shoot6(o, 0, 0, 64, 6, 2, 1, 4, 2.2, 0.5, 0, 0.392699, nil, false)
                        f3 = f3 + f4
                    end
                end)
            end
            local W3 = { 1.5708, 1.37445, 0.589049, 0.392699, 0 }
            local W4 = { 1.5708, 1.76715, 2.55254, 2.74889, 3.14159 }
            task.Wait(150)                          -- t=150
            while true do
                task.Wait(16)                       -- SUB_CALL 2（16 帧）
                task.Wait(30)                       -- t=180（帧 196）
                local a = rngrad()                  -- t=180 的 *f0 = *RNGRAD
                for k = 0, 4 do                     -- 第一波：t=180..212（帧 196..228）
                    ghost(a + k * 1.25664, 0.0523599, -128, 64 - 28 * k, -0.0981748, rngrad())
                    if k < 4 then task.Wait(8) end
                end
                task.Wait(100)                      -- t=312（帧 328）
                drift(self, 1.5, 60)                -- SUB_CALL 60
                task.Wait(60)                       -- t=372（帧 388）
                task.Wait(16)                       -- SUB_CALL 2
                task.Wait(30)                       -- t=402（帧 434）
                a = rngrad()
                for k = 0, 4 do                     -- 第二波：t=402..434（帧 434..466）
                    ghost(a + k * 1.25664, -0.0523599, 160, -96 + 28 * k, -2.35619, rngrad())
                    if k < 4 then task.Wait(8) end
                end
                task.Wait(100)                      -- t=534（帧 566）
                drift(self, 1.5, 60)                -- SUB_CALL 60
                task.Wait(60)                       -- t=594（帧 626）
                task.Wait(16)                       -- SUB_CALL 2
                task.Wait(30)                       -- t=624（帧 672）
                a = rngrad()
                for k = 0, 4 do                     -- 第三波：t=624..656（帧 672..704）
                    ghost(a + k * 1.25664, 0.0523599, -160, 176 - 28 * k, W3[k + 1], rngrad())
                    if k < 4 then task.Wait(8) end
                end
                task.Wait(20)                       -- t=676（帧 724）
                task.Wait(16)                       -- SUB_CALL 2
                task.Wait(30)                       -- t=706（帧 770）
                a = rngrad()
                for k = 0, 4 do                     -- 第四波：t=706..738（帧 770..802）
                    ghost(a + k * 1.25664, 0.0523599, 160, 176 - 28 * k, W4[k + 1], rngrad())
                    if k < 4 then task.Wait(8) end
                end
                task.Wait(100)                      -- t=838（帧 902）
                drift(self, 1.5, 100)               -- SUB_CALL 60
                task.Wait(100)                      -- t=938（帧 1002）
                task.Wait(16)                       -- SUB_CALL 2 → 下一轮 t=150 组
            end
        end)
    end, { skin = skin4M, wallskin = skin4Mw, enter = enter4 })

    ---──────────────────── 莉莉卡 非符 1（原作 sub95） ────────────────────
    ---逐条照抄 `ecldata4.ecl` 的 Lunatic 行：
    ---  · t=0 SET_MOVEMENT_BOUNDS(32,48,352,128)；t=0..50 六发 SPAWN_EFFECT（演出）；
    ---    t=50 `SET_INT *gi0 4 / *gi1 32` + `SUB_CALL 2`（阻塞 16 帧）。
    ---  · t=80 的 A 段（30 轮、每轮 4 帧）：`*f0=1.5`、`*f1=*RNGRAD`（**整段只抽一次**，
    ---    之后每轮 `*f1 -= 0.1848`）；`INIT_BULLET_CMD 0 64 0 60 3 1.0472 -999`
    ---    （0x40：沿当前朝向刹停 60 帧 → angle += cmd.speed = 1.0472、速度 = 弹自身速率、
    ---    重复 3 轮）→ `RING_ABS 6:2 6 1 *f0 1.5 *f1 0`（6 发）；
    ---    `INIT_BULLET_CMD 0 64 0 50 1 1.0472 1`（0x40：刹停 50 帧 → angle += 1.0472、
    ---    速度 = cmd.angle = 1、1 轮）→ `RING_ABS 6:3 8 1 2.5 1 *f1 0`（L 行 8 发）；
    ---    随后 `*f0 += 0.0333333`、`DEC_JUMP 80`（i2_0 从 30 递减到 0）。
    ---  · t=84 的 B 段（30 轮、每轮 4 帧）：同 A 段但两条 0x40 的旋转量取 −1.0472、
    ---    `*f1 += 0.1848`、6 发环的色档换成 `6:1`；`DEC_JUMP 84`。
    ---  · t=188 `JUMP 50`（不消耗帧）⇒ 一轮 = 30×4 + 30×4 + 150 帧（JUMP 后时间轴要从
    ---    88 走到 188 共 100 帧，再加 t=50 的 SUB_CALL 2 十六帧与 t=80 前的三十帧）。
    ---0x40 = `BulletManager.cpp:779` UpdateBulletDirChangeAndResume；ECL 里速度参数写
    ---−999 ⇒ 走 `cmd.angle > -999 ? cmd.angle : this->speed` 的「沿用自身速率」分支。
    ncard("莉莉卡 非符 1", 4444, 16000, 1600, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            local function cmd40(rot_th, dur, loop, spd, own)
                return { type = 0x40, flag = 0, dur = dur, loop = loop,
                         angle = -rot_th * RAD2DEG, speed = spd, resume_own = own }
            end
            local A6 = cmd40(1.0472, 60, 3, 0, true)
            local A8 = cmd40(1.0472, 50, 1, 1, false)
            local B6 = cmd40(-1.0472, 60, 3, 0, true)
            local B8 = cmd40(-1.0472, 50, 1, 1, false)
            task.Wait(50)                               -- t=50
            task.Wait(16)                               -- SUB_CALL 2（16 帧）
            task.Wait(30)                               -- t=80（帧 96）
            while true do
                local f0, f1 = 1.5, rngrad()            -- A 段：*f0=1.5、*f1=*RNGRAD
                for _ = 1, 30 do
                    ring4(self, self.x, self.y, 6, 2, 6, 1, f0, 1.5, f1, 0, A6)
                    ring4(self, self.x, self.y, 6, 3, 8, 1, 2.5, 1, f1, 0, A8)
                    f0, f1 = f0 + 0.0333333, f1 - 0.1848
                    task.Wait(4)
                end
                f0, f1 = 1.5, rngrad()                  -- B 段：*f0=1.5、*f1=*RNGRAD
                for _ = 1, 30 do
                    ring4(self, self.x, self.y, 6, 1, 6, 1, f0, 1.5, f1, 0, B6)
                    ring4(self, self.x, self.y, 6, 3, 8, 1, 2.5, 1, f1, 0, B8)
                    f0, f1 = f0 + 0.0333333, f1 + 0.1848
                    task.Wait(4)
                end
                task.Wait(146)                          -- t=188 JUMP 回 t=50 → 下一轮
            end
        end)
    end, { skin = skin4R, enter = enter4 })

    ---──────────────────── 鍵霊「ベーゼンドルファー神奏 -Lunatic-」 ────────────────────
    ---逐条照抄 `ecldata4.ecl` sub145 的 Lunatic 行（本体 + sub148/sub149）：
    ---  · t=0 `MOVE_POS_TIME 120 4 192 104` ⇒ 我们 (0,224) → (0,120)；
    ---    t=120 `SET_MOVEMENT_BOUNDS 32 48 352 128` + `SUB_CALL 2`（阻塞 16 帧）。
    ---  · t=150 起每轮 370 帧的大循环（`JUMP 150` 回跳；t=150 的 `SET_INT *i0 12`
    ---    每轮重跑一次 ⇒ 传给子程的 gi1 恒为 12）：
    ---      t=150 `SUB_CALL 149`（10 拍 × 5 帧，gi0=13）→ `SUB_CALL 148`（15 拍 × 5 帧、
    ---            gi0=2）→ `SUB_CALL 60`（0 帧漂移）；
    ---      t=210 `SUB_CALL 149`（gi0=13）→ `SUB_CALL 148`（gi0=6）→ `SUB_CALL 60`、
    ---            `INC *i0`；再 60 帧 `JUMP 150`。
    ---  · sub146/sub147（30 圈螺旋，RING_ABS）的 skip 位是 0x3 = Easy/Normal/Hard，
    ---    Lunatic 行**不跑**；本卡只剩 sub148/sub149 的 SPREAD_ABS（绝对角、不瞄自机，
    ---    每拍开头 `*f1 = *A2P` 读一次自机方向）。
    ---  · sub149：每拍两条对开扇（a1 = f1 与 f1 + π），各 12 发 × 1 层（v:2→1）、
    ---    半张角 0.261799；f1 每拍 −0.1309（−7.5°）。
    ---  · sub148：同形但 v:3.3→1、f1 每拍 +0.019635（+1.125°），色档由调用方给（2 / 6）。
    ---  · 两条扇的弹上各挂一份 0x20 链（原作 sub148/sub149 的 4 条 INIT_BULLET_CMD）：
    ---    cmd0 = `0x2000 160`（spawnDelay，本仓无此原语，略 —— 差异 67）、
    ---    cmd1 = `0x20 dur30 spd 0      ang ∓0.10472`、
    ---    cmd2 = `0x20 dur30 spd −0.0175 ang ±0.10472`、
    ---    cmd3 = `0x20 dur60 spd +0.005  ang ∓0.10472`；
    ---    flags = 0x2222（第一条扇，带 0x200 音效）/ 0x2022（第二条）。
    ---★ 对齐核对：把 POOL4_SIZE 临时放开成 100000 时 cmp2 在 3600 帧内 **0 mismatch**、
    ---总弹数 15282 = 原作（说明条数/节奏逐帧一致）；按原作 1024 上限跑时，从相对第
    ---1960 帧（绝对 2126）起因为池满开始自然少发 —— 原作同屏上限也是 1024（差异 25），
    ---VM 不建模这个上限，所以那之后的差额是工具口径而非移植误差。
    scard("鍵霊「ベーゼンドルファー神奏 -Lunatic-」", 4445, 60, 3000, false, function(self)
        ---原作 t=0 MOVE_POS_TIME 120 4 192 104 ⇒ 我们 (0,224) → (0,120)。
        bmove(self, 120, 4, 0, 120)
        ---一段 0x20（`angle` 按 TH07 弧度/帧给，内部取反并转度；`spd` = 每帧速度增量）。
        local function spin3(ang, spd, dur)
            return { type = 0x20, dur = dur, loop = -1, speed = spd,
                     angle = -ang * RAD2DEG }
        end
        local C149A = cmds4(0x2222, spin3(-0.10472, 0, 30),
                            spin3(0.10472, -0.0175, 30), spin3(-0.10472, 0.005, 60))
        local C149B = cmds4(0x2022, spin3(-0.10472, 0, 30),
                            spin3(0.10472, -0.0175, 30), spin3(-0.10472, 0.005, 60))
        local C148A = cmds4(0x2222, spin3(0.10472, 0, 30),
                            spin3(-0.10472, -0.0175, 30), spin3(0.10472, 0.005, 60))
        local C148B = cmds4(0x2022, spin3(0.10472, 0, 30),
                            spin3(-0.10472, -0.0175, 30), spin3(0.10472, 0.005, 60))
        ---sub149（10 拍 × 每拍 n 发 × 2 扇）：a1 = 自机方向（整个子程只在 t=0 读一次），
        ---每拍 −0.1309。n = 调用方 gi1 = *i0（12 起、每轮 +1，见下）。
        local function sub149(col, n)
            local f1 = aimth(self)
            for _ = 1, 10 do
                shoot6(self, 0, 0, 65, 6, col, n, 1, 2, 1, f1, 0.261799, C149A, true)
                shoot6(self, 0, 0, 65, 6, col, n, 1, 2, 1, f1 + PI, 0.261799, C149B, false)
                f1 = f1 - 0.1309
                task.Wait(5)
            end
        end
        ---sub148（15 拍）：v:3.3→1，每拍 +0.019635。
        local function sub148(col, n)
            local f1 = aimth(self)
            for _ = 1, 15 do
                shoot6(self, 0, 0, 65, 6, col, n, 1, 3.3, 1, f1, 0.261799, C148A, true)
                shoot6(self, 0, 0, 65, 6, col, n, 1, 3.3, 1, f1 + PI, 0.261799, C148B, false)
                f1 = f1 + 0.019635
                task.Wait(5)
            end
        end
        task.New(self, function()
            task.Wait(120)                            -- t=0..120（MOVE_POS_TIME）
            self._box = box5(32, 48, 352, 128)        -- t=120 SET_MOVEMENT_BOUNDS
            task.Wait(46)                             -- SUB_CALL 2（16 帧）+ 30 帧 → t=150（帧 166）
            ---★ t=270 的 `JUMP 150 -576` 落点是 instr@636（t=150 的 `SET_INT *gi0 2`），
            ---**不是** t=150 段的开头 —— 开头的 `SET_INT *i0 12` 只在第一轮执行一次，
            ---之后 `INC *i0` 每轮 +1 且不再被重置 ⇒ 每轮每扇的发数 12,13,14,…。
            local i0 = 12
            while true do
                sub149(13, i0)                        -- t=150：10 拍（帧 166..215）
                sub148(2, i0)                         --        15 拍（帧 216..290）
                ---原作 t=150 的 `SET_INT *gi0 60` + `SET_FLOAT *gf0 1` + `SUB_CALL 60`：
                ---sub60 = `GET_EXIT_ANGLE *f0` + `MOVE_DIR_TIME *i3_0 4 *f0 *f3_0`
                ---⇒ 抽一次 exit 角、沿该方向 60 帧漂 1 px/帧（阻塞子程不额外占帧）。
                exdrift(self, 1, 4)
                task.Wait(60)                         -- t=210（帧 351）
                sub149(13, i0)
                sub148(6, i0)
                ---同上，t=210 的 `SET_FLOAT *gf0 1.3` ⇒ 这一轮漂 1.3 px/帧。
                exdrift(self, 1.3, 4)
                task.Wait(60)                         -- t=270（帧 536）JUMP → t=150 中段
                i0 = i0 + 1                           -- INC *i0
            end
        end)
    end, { skin = skin4R, wallskin = skin4Rw, enter = enter4 })

    ---──────────────────── 偽弦「スードストラディヴァリウス」 ────────────────────
    ---原作 sub128 → sub130 → sub129，Lunatic 行逐条照抄：
    ---  · sub128（本体）：t=0 MOVE_POS_TIME(120,4,192,104)（我们 (0,224)→(0,120)）；
    ---    t=120 SET_MOVEMENT_BOUNDS(32,48,352,128) 后 SUB_CALL 2（16 帧粒子）；
    ---    t=150 起进 4 拍循环。一拍 = [24 帧「音符串」＋ 2×(i2_1/2) 帧等待]。
    ---    i2_1 从 150 起每拍 −5、≤60 后不再变（`JUMP 150 -2080` 落到 instr@392，
    ---    跳过 `SET_INT *i2_1 150`，所以只有第一轮把它复位）。
    ---  · 每拍开头 `JGEQ_F *DIST 128` 跳过那一圈：自机离本体 <128 px 才打
    ---    `RING_AIMED 3:2 32 3 2.8 0.5 0 0.261799 516`（32 发 × 3 层、半张角 15°、
    ---    sprite3／色档 2、flags 0x204）。四拍 a2 依次 +,+,−,+（只有第 3 拍是
    ---    −0.261799，即内层反向转）。
    ---  · 同帧起 8 次 `SPAWN_ENEMY_REL 130`（每 3 帧一串，含末尾一次 = 24 帧）：
    ---    f2 从「A2P ∓1.74533 / ∓1.5708」起、每串 ∓0.785398；四拍
    ---    f0 = ±π/2、f4 = ±0.015708、i0 = 0/2/2/0（音符色档 2/6/6/2）。
    ---  · sub130（音符串）：朝 f2 以 6 px/帧 飞出、同时自转 f4；i2_1 = 4,6,…,26，
    ---    每 i2_1 帧在**自己当前位置**放一只 sub129（共 12 只、180 帧），
    ---    并把 f0 叠成 f0_本体 + f2_串 传给音符。
    ---  · sub129（音符）：朝 f0 以 0.5 px/帧 直线飞；t=60 记下 boss 坐标、
    ---    t=120 朝 ATAN2(boss→自己) 打一发 sprite3 单弹（v:1.2、半张角 π/2、
    ---    flags 0x284），Lunatic 行把该角取反。i0=0→色档 2、i0=2→色档 6。
    local D4466 = {
        --  i0   f0        f4           f2 增量     环的 a2      f2 基准（A2P 之上）
        { i0 = 0, f0 =  1.5708, av =  0.015708, da =  0.785398, a2 =  0.261799, f2 = -1.74533 },
        { i0 = 2, f0 = -1.5708, av = -0.015708, da = -0.785398, a2 =  0.261799, f2 =  1.74533 },
        { i0 = 2, f0 =  1.5708, av =  0.015708, da =  0.785398, a2 = -0.261799, f2 = -1.5708  },
        { i0 = 0, f0 = -1.5708, av = -0.015708, da = -0.785398, a2 =  0.261799, f2 =  1.5708  },
    }
    local N4466 = { [0] = 2, [2] = 6 }
    scard("偽弦「スードストラディヴァリウス」", 4446, 66, 3600, false, function(self)
        local B = self                      -- sub129 的 GET_BOSS_FLOAT 读的就是这只 boss
        ---原作 sub129：音符（a = { 色档, 飞行方向(TH07 rad), 速度 }）。
        local function note(me, a)
            local col, f0, spd = a[1], a[2], a[3]
            for _ = 1, 60 do
                me.x, me.y = me.x + cos(f0 * RAD2DEG) * spd,
                             me.y - sin(f0 * RAD2DEG) * spd
                task.Wait(1)
            end
            local bx, by = B.x, B.y          -- t=60 `GET_BOSS_FLOAT f6/f7`
            for _ = 1, 60 do
                me.x, me.y = me.x + cos(f0 * RAD2DEG) * spd,
                             me.y - sin(f0 * RAD2DEG) * spd
                task.Wait(1)
            end
            ---★ Lunatic 行**不执行** `ATAN2 *f0 *f6 *f7 *X *Y`：那条的 sd=0x07
            ---（只给 Easy/Normal/Hard），Lunatic 只有下一条 `MUL_FLOAT *f0 *f0 -1`
            ---（sd=0x08）。所以自机弹向 = **音符自身飞行方向取负**，与自机/boss 位置无关
            ---（第 41/42 两条 GET_BOSS_FLOAT 仍照跑，只是值没人用）。
            local th = -f0
            ---★ 原作 sub129 在打这一发前有 `JLEQ_F *DIST 32`（sd=ALL）：自机距离
            ---≤32 时直接跳去 UNIMP（音符消失、不发弹）。漏掉这道闸会多出几发
            ---贴在自机身边的弹。
            if sqrt((me.x - player.x) ^ 2 + (me.y - player.y) ^ 2) > 32 then
                ---★ 这发弹带 `INIT_BULLET_CMD 0 128 0 60 1 0 1`（type 0x80、dur 60、loop 1、
                ---cmd.speed=0、cmd.angle=1；波 flags=644=0x284 含 0x80 位）：60 帧内沿当前
                ---朝向线性刹到 0，然后 rot = A2P + state.angle(=cmd.speed=0)、速度 =
                ---state.speed(=cmd.angle=1)。漏掉 ⇒ 弹不刹车。
                shoot6(me, 0, 0, 65, 3, col, 1, 1, 1.2, 0.5, th, 1.5708,
                       brake_aim6(60, 0, 1, 1), true)
            end
        end
        ---原作 sub130：音符串（a = { 方向, 角速, 速度, 音符方向, 音符色档 }）。
        local function chain(me, a)
            local ang, av, spd, d, col = a[1], a[2], a[3], a[4], a[5]
            local gap = 4
            for _ = 1, 12 do
                for _ = 1, gap do
                    ---★ 原作 ENEMY_MOVE_POLAR 每帧是「先 angle += angleVel，再按 angle
                    ---走 speed」（EclManager.cpp:2018-2026）。先走再转会让整条音符串
                    ---的路径整整少转一步，末端偏移可达十几 px。
                    ang = ang + av
                    me.x, me.y = me.x + cos(ang * RAD2DEG) * spd,
                                 me.y - sin(ang * RAD2DEG) * spd
                    task.Wait(1)
                end
                pspawn(me.x, me.y, note, { col, d, 0.5 })
                gap = gap + 2                -- SET_WAIT_TIMER *i2_1 → `ADD *i2_1 *i2_1 2`
            end
        end
        task.New(self, function()
            bmove(self, 120, 4, 0, 120)                   -- t=0 MOVE_POS_TIME(120,4,192,104)
            task.Wait(120)                                -- t=120
            self._box = box5(32, 48, 352, 128)            -- SET_MOVEMENT_BOUNDS
            task.Wait(16)                                 -- SUB_CALL 2（16 帧）
            task.Wait(30)                                 -- t=150 前的 OP0 空等（136→166）
            local i2_1 = 150
            while true do
                for b = 1, 4 do
                    local c = D4466[b]
                    local f2 = aimth(self) + c.f2
                    if pdist(self) < 128 then             -- JGEQ_F *DIST 128 → 跳过环
                        shoot6(self, 0, 0, 66, 3, 2, 32, 3, 2.8, 0.5, 0, c.a2, nil, true)
                    end
                    for _ = 1, 8 do                       -- DEC_JUMP *i2_0 8 次、每 3 帧
                        pspawn(self.x, self.y, chain,
                               { f2, c.av, 6, c.f0 + f2, N4466[c.i0] })
                        f2 = f2 + c.da                    -- ADD/SUB_FLOAT *f2 0.785398
                        task.Wait(3)
                    end
                    local w = int(i2_1 / 2)               -- DIV *i0 *i2_1 2
                    task.Wait(w)                          -- SET_WAIT_TIMER *i0
                    task.Wait(w)                          -- SET_WAIT_TIMER *i0（第二段）
                    if i2_1 > 60 then i2_1 = i2_1 - 5 end -- JLEQ *i2_1 60 / SUB
                end
            end
        end)
    end, { skin = skin4L, wallskin = skin4Lw, enter = enter4 })

    ---──────────────────── 騒葬「スティジャンリバーサイド -Lunatic-」 ────────────────────
    ---原作 sub133 → sub134（周期回调，每 10 帧一次），Lunatic 行逐条照抄：
    ---  · sub133 本体：t=120 MOVE_POS_TIME(120,4,192,96)（我们 (0,96)→(0,128)）；
    ---    t=240 SET_MOVEMENT_BOUNDS(128,96,256,128)、SUB_CALL 2（16 帧粒子）、
    ---    i0=13 / f0=*RNGRAD / f1=−0.0981748、SET_PERIODIC_CALLBACK 10 134。
    ---    t=440/640/…/1640 每 200 帧一档：gi0/gf0 → SUB_CALL 60（GET_EXIT_ANGLE
    ---    + MOVE_DIR_TIME(30,4,θ,0.8)，**不冻结时间轴**，只是启动一段 30 帧位移）、
    ---    更新 i0（色档 11/10/8/6/4/2/14）、f0=*RNGRAD、f1=±0.0981748、重设周期回调；
    ---    t=1840 只漂移不更新；JUMP 回 t=240（时间轴重置）。
    ---  · sub134（每 10 帧一次）：RING_AIMED 2:色档 8 3 1.5 0.5 *f0 0 flags513
    ---    ——8 发 × 3 层（1.5→0.5 px/帧）、基准角 f0 朝自机；随后 f0 += f1。
    scard("騒葬「スティジャンリバーサイド -Lunatic-」", 4447, 60, 3600, false, function(self)
        local i0, f0, f1
        task.New(self, function()                          -- sub134（周期回调）
            task.Wait(266)                                 -- t=240 设回调后第 10 帧首触发（ECL t=266）
            while true do
                shoot6(self, 0, 0, 66, 2, i0, 8, 3, 1.5, 0.5, f0, 0, nil, true)
                f0 = f0 + f1
                task.Wait(10)
            end
        end)
        task.New(self, function()                          -- sub133（本体时间轴）
            task.Wait(120)                                 -- t=0..120 前奏（SET_POS 等）
            bmove(self, 120, 4, 0, 128)                    -- t=120 MOVE_POS_TIME(120,4,192,96)
            task.Wait(120)                                 -- t=120 → t=240
            self._box = box5(128, 96, 256, 128)            -- SET_MOVEMENT_BOUNDS
            task.Wait(16)                                  -- SUB_CALL 2
            i0, f0, f1 = 13, rngrad(), -0.0981748          -- t=240 设定
            local K = { 11, 10, 8, 6, 4, 2, 14 }           -- t=440…1640 的色档
            ---★ f1 的符号**逐档硬编码**（原作 #37/#44/#51/#58/#65/#72/#79）：
            ---  t=440 +、640 −、840 +、1040 −、1240 +、1440 −、**1640 −**（最后一档
            ---  不换号）。原来按 `b % 2` 交替 ⇒ b=7 给成 +，f0 从此永久差 2×0.0981748
            ---  （≈11.25°）——实测 4447 的整圈瞄准环从真实帧 1676 起整体歪 11.25°。
            local SGN = { 1, -1, 1, -1, 1, -1, -1 }
            while true do
                for b = 1, 7 do
                    task.Wait(200)
                    drift(self, 0.8, 30)                   -- SUB_CALL 60
                    i0 = K[b]
                    f0 = rngrad()
                    f1 = 0.0981748 * SGN[b]
                end
                task.Wait(200)                             -- t=1640 → t=1840
                drift(self, 0.8, 30)                       -- t=1840（只漂移）
                i0, f0, f1 = 13, rngrad(), -0.0981748      -- JUMP 回 t=240
            end
        end)
    end, { skin = skin4L, wallskin = skin4Lw, enter = enter4 })

    ---──────────────────── 大合葬「霊車コンチェルトグロッソ怪」 ────────────────────
    ---原作 sub135 → sub136（周期回调，每 10 帧一次），Lunatic 行逐条照抄：
    ---  · sub135：t=0 MOVE_POS_TIME(120,4,192,96)（我们 (0,224)→(0,128)）；t=120
    ---    SET_BOSS_RUN_INTERRUPT 4 / SUB_CALL 2（16 帧）；t=150
    ---    MOVE_ORBIT(300, 192,160, 0, −π/2, 0.010472, 64, 0.213333)、f0=*RNGRAD、
    ---    i0=0、SET_PERIODIC_CALLBACK 10 136；t=450 MOVE_ORBIT(0, 192,160, 0, +π/2,
    ---    0.010472, 128, 0)、f0=4.18879、LASER_FIXED(spr1:off10, sOff=16, eOff=224,
    ---    sLen=224, w=16, 展开 120, 满宽 252000, 收束 16, 判定 16..16, flags 4)；
    ---    t=451 拉第二条（f0=6.70206），随后两条激光进入不断加速的转台循环。
    ---  · sub136（每 10 帧一次）：先把 shootOffset 定到 (192−X, 160−Y)（⇒ 弹从**固定的**
    ---    (192,160)=我们 (0,64) 打出），再按 i0 打 3 圈或 4 圈 RING_ABS 2:col 3 2 2 0.5
    ---    f0 0.0785398（每圈 f0 += 0.0261799）；i0%4==0 时补一圈 RING_AIMED 2:13 20 2
    ---    1.7 0.5 0 0.0785398；末尾 f0 += 3×0.0392699、i0 += 1。
    scard("大合葬「霊車コンチェルトグロッソ怪」", 4448, 60, 3600, false, function(self)
        local f0, i0
        local R3, R4 = { 1, 2, 4 }, { 1, 2, 4, 6 }
        task.New(self, function()                          -- sub136（周期回调）
            task.Wait(176)                                 -- t=150 设回调后第 10 帧首触发
            while true do
                local ring = (i0 < 30) and R3 or R4
                ---★ 原作 sub136：每打一圈 `SUB_FLOAT *f0 *f0 0.0261799`（**减**），
                ---   而且**最后那圈后面不减**（idx5/7 只在第 1、2 圈后，idx9 直接 JUMP）。
                for k = 1, #ring do
                    ring4(self, 0, 64, 2, ring[k], 3, 2, 2, 0.5, f0, 0.0785398, nil)
                    if k < #ring then f0 = f0 - 0.0261799 end
                end
                if i0 % 4 == 0 then
                    shoot6(self, -self.x, 64 - self.y, 66, 2, 13, 20, 2, 1.7, 0.5,
                           0, 0.0785398, nil, true)
                end
                f0 = f0 - 0.0392699 * 3          -- idx31..33（三连 SUB_FLOAT）
                i0 = i0 + 1
                task.Wait(10)
            end
        end)
        task.New(self, function()                          -- sub135（本体时间轴）
            bmove(self, 120, 4, 0, 128)                    -- t=0 MOVE_POS_TIME(120,4,192,96)
            task.Wait(120)                                 -- t=120
            task.Wait(16)                                  -- SUB_CALL 2（墙钟 136，time 仍 120）
            task.Wait(30)                                  -- time 120 → 150（墙钟 166）
            f0, i0 = rngrad(), 0                           -- t=150 设定
            ---公转（原作 MOVE_ORBIT；t=450 之后半径停在 128、角速度不变）
            local ang, r = -PI / 2, 64
            task.New(self, function()
                task.Wait(166)
                self._orb, self._mv = nil, nil
                while true do
                    ang = ang + 0.010472
                    r = min(128, r + 0.213333)
                    self.x, self.y = math.cos(ang) * r, 64 - math.sin(ang) * r
                    task.Wait(1)
                end
            end)
            ---两条长激光（原作 LASER_FIXED；SET_LASER_POS_REL 每帧把激光原点拉回本体）
            local L = { spr = 1, w = 16, sOff = 16, eOff = 224, sLen = 224,
                        tStart = 120, dur = 252000, tEnd = 16, hbStart = 16, hbEnd = 16 }
            local l1, l2
            task.New(self, function()
                task.Wait(466)                             -- t=450
                l1 = plaser(self.x, self.y, -4.18879, L)
                for _ = 1, 300 do                          -- ADD_LASER_ANGLE 0 0.010472 ×300
                    l1.pl_ang, l1.pl_x, l1.pl_y = l1.pl_ang - 0.010472, self.x, self.y
                    task.Wait(1)
                end
                l2 = plaser(self.x, self.y, -6.70206, L)   -- t=451
                local orbav = 0
                while true do
                    orbav = orbav + 2.61799e-05            -- ADD_FLOAT *ORBAV *ORBAV 2.61799e-05
                    l1.pl_ang, l1.pl_x, l1.pl_y = l1.pl_ang - orbav, self.x, self.y
                    l2.pl_ang, l2.pl_x, l2.pl_y = l2.pl_ang - orbav, self.x, self.y
                    task.Wait(1)
                end
            end)
        end)
    end, { skin = skin4R, wallskin = skin4Rw, enter = enter4 })

    ---════════════════════════════════════════════════════════════════════
    ---以下：stage1（レティ・ホワイトロック）与 stage2（橙）的符卡/非符移植
    ---（原作 `ecldata1.ecl` / `ecldata2.ecl`）。
    ---
    ---原作结构同 stage3/4/5/6：boss 主 sub（`SET_BOSS`）挂在「打一套非符 → 掉血到
    ---阈值切符卡 → 再回非符」的时间轴上，符卡由 `SET_LIFE_CALLBACK_SUB` /
    ---`SET_TIMER_CALLBACK_SUB` 点名。本仓库是「一卡一独立挑战」口径，所以把每张
    ---有名字的 Lunatic 符卡、以及每一套非符，各拆成一张卡。
    ---
    ---sub 对照（只取 Lunatic 行；原作各卡把 Easy/Normal/Hard/Lunatic 四种设置
    ---用 `JUMP_IF_NEQ a=difficulty` 串在同一个 sub 里，这里只搬 Lunatic 的那一段）：
    ---  stage1 非符1 = sub26（循环调 25/22/21/23/24）
    ---         霜符「フロストコラムス -Lunatic-」= sub29 → sub30（6 根冰柱）
    ---         非符2 = sub38（32/33/33/32/34）
    ---         寒符「リンガリングコールド -Lunatic-」= sub42 → sub43（轨道冰晶）＋ sub47（锥弹）
    ---         非符3 = sub39（40/40/33/32）
    ---         白符「アンデュレイションレイ」= sub52 → sub53 → sub54
    ---         怪符「テーブルターニング」= sub55 → sub56 → sub57
    ---  stage2 非符1 = sub41 → sub43（三向加速扇）＋ sub42
    ---         仙符「鳳凰展翅 -Lunatic-」= sub45 → sub30..33（凤凰火）
    ---         非符2 = sub49（51/50）
    ---         式符「飛翔晴明」= sub56 → sub57（渐开扇＋整圈）
    ---         陰陽「晴明大紋」= sub58 → sub59（渐开扇＋整圈）
    ---         非符3 = sub53（54/55）
    ---         天符「天仙鳴動」= sub64 → sub65（随机爆）＋本体扇
    ---         童符「護法天童乱舞」= sub66 → sub67
    ---         仙符「屍解永遠」= sub68 → sub69
    ---         方符「奇門遁甲」= sub75 → sub73 / sub74
    ---
    ---坐标 / 角度 / 血量口径同文件头（x−192、224−y、θ 取反；`ring4`/`fan4` 收的是
    ---TH07 口径的弧度，内部自动取反）。卡 id 段：stage1 = 4450..4457、stage2 = 4460..4469。
    ---
    ---★ 逐帧校准记录（对着 /tmp/br34 的 ECL 解释器与 TH07 C++ 源码逐条核过）：
    ---  · 禁用弹：原作常用「DISABLE_BULLETS … ENABLE_BULLETS」把某一发夹住，那发**不发**。
    ---    已按此修正 4450 的 sub22 RANDOM 与 sub23 的首发（首发改由 SET_SHOOT_INTERVAL 8
    ---    的自动连发在 7 帧后打出，共 11 发）；4453 的 sub36 也补回了它漏掉的一层 rand 判定。
    ---  · 指令激活：一发弹的命令槽照 `Bullet::RunCommands` **逐帧**判定（每帧最多激活一段，
    ---    `flag == 0` 的段要等 exFlags 归零），所以「type1 爆速段跑完 → 后面 flag=0 的段接管」
    ---    这类写法必须动态模拟；`cmds4` 现在就是这套状态机（见 class["TH34_cmdbullet"]）。
    ---  · 卡时限：`scard` 的 t3 一律 = 原作 `SET_TIMER_CALLBACK_THRESHOLD / 60`。
    ---  · 进场：`enter1b` 原作是 `MOVE_POS_TIME 120 4 192 112` ⇒ 120 帧（原先写成 60 帧）。
    ---立绘用 `THlib/BossImageList.lua` 的 "Whiterock" / "Chen"，进场沿用 stage3/4 的
    ---「从下方升到场中央」。
    ---════════════════════════════════════════════════════════════════════
    local skin1, skin1w = skin4of("Whiterock", false), skin4of("Whiterock", true)
    local skin2, skin2w = skin4of("Chen", false), skin4of("Chen", true)
    ---从下方升到 (0,96)（原作 (192,128)）。
    local function enter1(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 224
        bmove(self, 60, 4, 0, 96)
    end
    ---同上，落到 (0,112)（原作把本体摆到 (192,112) 的几张卡）。
    ---原作这些卡都是 `MOVE_POS_TIME 120 4 192 112` ⇒ 120 帧（不是 60 帧）进场。
    local function enter1b(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 224
        bmove(self, 120, 4, 0, 112)
    end
    ---原作 sub64/66 的入场：本体从 (192,112)（我们 (0,112)）起步，120 帧 ease-out-quad
    ---横滑到 (336,112)（我们 (144,112)）。这两张卡的主循环都从那个点起算 MOVE_POS_TIME，
    ---所以不能用 enter1b 的 (0,112)——否则第一段的位移方向会变、扇的基准角跟着错。
    local function enter1r(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 112
        bmove(self, 120, 4, 144, 112)
    end
    ---原作 sub68 的入场：本体接上一张卡（sub64/66 的收尾点）停在 (336,112)
    ---（我们 (144,112)），墙钟 10 起 120 帧 ease-out-quad 滑回场中央 (192,112)。
    local function enter1c(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 144, 112
    end
    ---原作 sub44/sub70 的入场：`MOVE_POS_TIME 120 4 192 112`（我们 (0,224)→(0,112)）。
    local function enter1e(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 224
        bmove(self, 120, 4, 0, 112)
    end
    ---原作 sub29（霜符的 L 行）：t=120 起 `MOVE_POS_TIME 120 4 192 140`（我们 (0,84)；
    ---移动框 [32,352]×[48,128] 会把 y 夹到 128 ⇒ 实际停在 (0,96)）。
    local function enter1f(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 0, 224
        bmove(self, 120, 4, 0, 84)
    end
    ---以**绝对点**为心的 SPREAD_AIMED（op64，a1 是相对自机方向的偏移）。
    local function aim4(self, ax, ay, spr, col, n, c2, v1, v2, a1, a2, cmd)
        shoot6(self, ax - self.x, ay - self.y, 64, spr, col, n, c2 or 1, v1,
               v2 or 0.5, a1 or 0, a2 or 0, cmd, false)
    end
    ---以**绝对点**为心的 RING_ABS（op67）。
    local function rabs(self, ax, ay, spr, col, n, c2, v1, v2, a1, a2, cmd)
        shoot6(self, ax - self.x, ay - self.y, 67, spr, col, n, c2 or 1, v1,
               v2 or 0.5, a1 or 0, a2 or 0, cmd, false)
    end
    ---原作 sub20/38/39 的移动是 `MOVE_DIR_TIME`（60 帧、0.7~1.25 px/帧）＋
    ---`GET_EXIT_ANGLE`，移植版直接用 stage3/4 的 `drift`。
    ---──────────────────── レティ 非符 1（原作 sub26 的循环 = 25/22/21/23/24） ────────────────────
    ---逐条照抄原作 sub26 的时间轴。TH07 的 `SUB_CALL` 是**阻塞**的（`CallEclSub` 把子程序的
    ---time 归零、跑完才 `SUB_RET` 恢复调用者，调用者那一刻的 time 被冻住），所以下面每段
    ---子程序的时长都直接累加到墙钟上；`SUB_CALL 2`（gI0=30 / gI1=1）是「音效 ＋ 每 4 帧
    ---一发粒子、共 30 发」的 120 帧冻结（和本文件其它卡同一口径）。
    ---  · sub25：同一帧打 4 组「12 发 × 6 层（3.2→1）」环 —— L 行四组的基准角 / 层旋 /
    ---    指令分别是 (a1=0, a2=−0.19635, 自旋 +π/60 ∞)、(a1=+0.19635, a2=−0.19635,
    ---    自旋 −π/60 ∞ ＋ 转 +157.5° 一轮)、(a1=0, a2=+0.19635, 转 −157.5° 一轮)、
    ---    (a1=+0.19635, a2=+0.19635, 自旋 +π/120)（后两组第三段 type0x20 的 flag=0，
    ---    在已有一段激活时永远轮不到）；再补两圈 4 发 × 5 层（3.5→1，a1=0.589049 / 0.981748）；
    ---  · sub22：RANDOM 弹（L 行 16 发全向、速度 1~1.5）被同一帧的 DISABLE_BULLETS…
    ---    ENABLE_BULLETS 夹住 ⇒ 原作**不发**；只有 t=60 的 SET_SHOOT_INTERVAL 0；
    ---  · sub21：t=0 两圈 32 发 × 2 层（2 / 1.5 →1）；t=1 两圈 shifted 32 发 × 2 层
    ---    （3 / 3.5 →1，相位 +π/32）＋ 两圈 4 发 × 5 层；
    ---  · sub23：RING_AIMED（以自机为心的 10 发环）同样被 DISABLE/ENABLE 夹住 ⇒
    ---    第一发不发；`SET_SHOOT_INTERVAL 8` 让自动连发在 t=7,15,…,87 各打一次
    ---    （共 11 发；Lunatic 的 rank=16 时 ShootInterval 修正恰为 0），t=90 停；
    ---  · sub24：8×3（2.5→1）＋ 10×3（2→1）＋ 14×3（3.5→1）＋ 16×3（3→1）＋ 两圈 4×5。
    ---四段 MOVE_POS_TIME 都是**绝对**坐标：(256,160)/(128,160)/(192,128)
    ---⇒ 我们 (64,64)/(−64,64)/(0,96)。
    ncard("レティ 非符 1", 4450, 16000, 1600, function(self)
        self._box = box5(32, 48, 352, 128)
        ---INIT_BULLET_CMD 的三段原型（角度一律换成我们的度数口径 = TH07 取反）。
        local function CLR() return { type = 1, flag = 0, dur = -1, loop = -1, speed = -1, angle = -1 } end
        local function SP20(rate_th, flag)                 -- 0x20 TargetAngle
            return { type = 0x20, flag = flag or 1, dur = 60, loop = -1,
                     speed = 0, angle = -rate_th * RAD2DEG }
        end
        local function T40(rot_th, own)                    -- 0x40 DirChangeAndResume
            return { type = 0x40, flag = 1, dur = 60, loop = 1,
                     angle = -rot_th * RAD2DEG, speed = 0, resume_own = own }
        end
        task.New(self, function()
            while true do
                ---①sub25：SUB_CALL 2（120 帧）＋ 4 组环 ＋ SUB_RET 前的 60 帧
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
                ---★★★ 原作 sub25 的每一「组」都是 **E/N/H/L 四行**（同一 t=0、只差
                ---skipInstrOnDifficulty：索引 6/7/8/9、13/14/15/16、20/21/22/23、27/28/29/30）。
                ---TH07 只执行「当前难度那一行」：Easy=(4,4)、Normal=(6,5)、Hard=(8,6)、
                ---Lunatic=(12,6)。移植版原先把四行误当成「一帧内叠 4 圈同心环」全发了出来
                ---（=700 发），这里按 Lunatic 只发 (12,6) 那一圈（4 组 × 72 + 两圈 4×5 = 328）。
                ---三条 INIT_BULLET_CMD（索引 3/4/5、10/11/12、17/18/19、24/25/26）都是 sk=ff
                ---（全难度），照抄；`RING_ABS` 的 flags=101/100 决定哪几段被激活。
                rabs(self, self.x, self.y, 6, 6, 12, 6, 3.2, 1.0, 0, -0.19635,
                     cmds4(101, CLR(), SP20(0.0523599), T40(2.74889, true)))
                rabs(self, self.x, self.y, 6, 6, 12, 6, 3.2, 1.0, 0.19635, -0.19635,
                     cmds4(100, SP20(-0.0523599), T40(-1.9635, true), SP20(0.0261799, 0)))
                ---★ 第三环的 0x20 角度是 **+0.0261799**（idx18），
                ---SP20 内部会取反 ⇒ 这里必须传正的 0.0261799（写反了整环会镜像）。
                rabs(self, self.x, self.y, 6, 6, 12, 6, 2.0, 1.0, 0, 0.19635,
                     cmds4(101, CLR(), SP20(0.0261799), T40(-2.74889, true)))
                ---★ 第四环（idx24/26）：0x20 角度 **−0.0261799 / +0.01309**。
                rabs(self, self.x, self.y, 6, 6, 12, 6, 2.0, 1.0, 0.19635, 0.19635,
                     cmds4(100, SP20(-0.0261799), T40(1.9635, true), SP20(0.01309, 0)))
                ---最后两圈 flags=4（0x04）：type 位不含任何命令类型 ⇒ **不激活任何段**。
                rabs(self, self.x, self.y, 3, 5, 4, 5, 3.5, 1.0, 0.589049, 0)
                rabs(self, self.x, self.y, 3, 5, 4, 5, 3.5, 1.0, 0.981748, 0)
                sound4(self)
                task.Wait(60)
                ---②MOVE_POS_TIME 60 4 (256,160) ＋ sub22（110 帧）
                ---sub22 的 RANDOM 弹（L 行 16 发）被 DISABLE_BULLETS…ENABLE_BULLETS
                ---夹在同一帧 ⇒ 原作**一发都不发**（BulletManager.cpp 的 disableBullets 判定）。
                bmove(self, 60, 4, 64, 64)
                task.Wait(110)
                ---③MOVE 之后紧接着 sub21（SUB_CALL 2 的 120 帧 ＋ 61 帧）
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
                ---★ sub21 前两圈 flags=3（0x03 含 T1）⇒ 挂 `INIT_BULLET_CMD 0 1 0 -1 -1 -1 -1`
                ---（爆速段）。后四圈 flags=0/2 不含 T1 ⇒ 不挂。
                local burst1 = cmds4(3,
                    { type = 1, flag = 0, dur = -1, loop = -1, speed = -1, angle = -1 })
                rabs(self, self.x, self.y, 3, 6, 32, 2, 2.0, 1.0, 0, 0, burst1)
                rabs(self, self.x, self.y, 3, 6, 32, 2, 1.5, 1.0, 0.0490874, 0, burst1)
                task.Wait(1)
                shoot6(self, 0, 0, 69, 3, 6, 32, 2, 3.0, 1.0, 0, 0, nil, false)
                shoot6(self, 0, 0, 69, 3, 6, 32, 2, 3.5, 1.0, 0.0490874, 0, nil, false)
                rabs(self, self.x, self.y, 3, 5, 4, 5, 3.5, 1.0, 0.589049, 0)
                rabs(self, self.x, self.y, 3, 5, 4, 5, 3.5, 1.0, 0.981748, 0)
                sound4(self)
                task.Wait(60)
                ---④MOVE_POS_TIME 90 0 (128,160) ＋ sub23（90 帧）
                bmove(self, 90, 0, -64, 64)
                ---sub23 的 RING_AIMED 也被 DISABLE/ENABLE 夹住 ⇒ 原作**不发**这一发；
                ---真正的射击由 SET_SHOOT_INTERVAL 8 的自动连发在 7 帧后打出（共 11 发）。
                task.Wait(7)
                for k = 1, 11 do
                    shoot6(self, 0, 0, 66, 5, 6, 10, 1, 1.5, 1.0, 0, 0, nil, false)
                    if k < 11 then task.Wait(8) end
                end
                task.Wait(3)
                ---⑤sub24（SUB_CALL 2 的 120 帧 ＋ 60 帧）
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
                ---★ sub24 前两圈 flags=5=0x05（含 T1、不含其它命令位）⇒ 挂爆速段
                ---`INIT_BULLET_CMD 0 1 0 -1 -1 -1 -1`（前 17 帧 speed = 5 − t·5/16 + 自身速率）。
                ---后两圈 flags=2、末尾两圈 flags=4 都不含命令位 ⇒ 不挂。
                rabs(self, self.x, self.y, 2, 6, 8, 3, 2.5, 1.0, 0, 0,
                     cmds4(5, CLR()))
                rabs(self, self.x, self.y, 2, 6, 10, 3, 2.0, 1.0, 0, 0,
                     cmds4(5, CLR()))
                rabs(self, self.x, self.y, 2, 6, 14, 3, 3.5, 1.0, 0.19635, 0)
                rabs(self, self.x, self.y, 2, 6, 16, 3, 3.0, 1.0, 0.19635, 0)
                rabs(self, self.x, self.y, 3, 5, 4, 5, 3.5, 1.0, 0.589049, 0)
                rabs(self, self.x, self.y, 3, 5, 4, 5, 3.5, 1.0, 0.981748, 0)
                sound4(self)
                task.Wait(60)
                ---MOVE_POS_TIME 60 4 (192,128) ⇒ (0,96)，再把 t 走到 120 跳回 t=0
                bmove(self, 60, 4, 0, 96)
                task.Wait(120)
            end
        end)
    end, { skin = skin1, enter = enter1 })

    ---──────────────────── 霜符「フロストコラムス -Lunatic-」 ────────────────────
    ---原作 sub29（L 行从 t=120 起）+ sub30。
    ---本体：`MOVE_POS_TIME 120 4 192 140` 摆位 → t=240 起每 60 帧放一根「冰柱」，
    ---六根一组共 75° 扇形：基准角 = 自机方向 + {0, +15°, +30°}，第 3 根时先按
    ---GET_EXIT_ANGLE 漂 60 帧（1.25 px/帧）并把基准角 −75° ⇒ 后三根是 {−45°,−30°,−15°}；
    ---第 1、3 根那两拍本体也漂一次。整组开头有 80 帧「粒子+音效」冻结（SUB_CALL 2，gI0=20），
    ---组末停 40 帧；t=580 跳回 t=240。
    ---冰柱 sub30：60 帧里沿 spawn 角匀速飞出 160 px（MOVE_POS_TIME 60 0）；**出生当帧**起
    ---每 6 帧打一组「sprite6 8 发整圈（v=2.6）+ sprite15 4 发整圈（v=2.6，相位 = spawn 角
    ---±0.224399）」——v 每拍换成 3.4−v（2.6/0.8 交替），共 10 拍，t=6 的第 11 次判停后自毁。
    scard("霜符「フロストコラムス -Lunatic-」", 4451, 38, 3000, false, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            local OFF = { 0, 0.261799, 0.523599, -0.785398, -0.523599, -0.261799 }
            task.Wait(120)                                   -- t=120 → t=240
            while true do
                PlaySound("power0", 0.35, self.x / 256)       -- SUB_CALL 2（gI0=20 ⇒ 80 帧）
                task.Wait(80)
                local a = aimth(self)
                for k = 1, 6 do
                    if k == 1 or k == 3 then drift(self, 1.25, 60) end
                    local ang = a + OFF[k]
                    pspawn(self.x, self.y, function(o)
                        bmove(o, 60, 0, o.x + math.cos(ang) * 160, o.y - math.sin(ang) * 160)
                        ---原作 `RAND_SIGN_FLOAT *f0 0.224399`：sign() 只抽 1 个 u16。
                        local off = ran:Sign() * 0.224399
                        local v = 2.6
                        for _ = 1, 10 do
                            ring4(o, o.x, o.y, 5, 6, 8, 1, v, 1, ang, 0, nil)
                            ring4(o, o.x, o.y, 5, 15, 4, 1, v, 1, ang + off, 0, nil)
                            v = 3.4 - v
                            task.Wait(6)
                        end
                    end)
                    if k == 6 then task.Wait(40) else task.Wait(60) end
                end
            end
        end)
    end, { skin = skin1, wallskin = skin1w, enter = enter1f })

    ---──────────────────── レティ 非符 2（原作 sub38 = 32/33/33/32/34） ────────────────────
    ---sub38 的时间轴（L 行）：t=60 起 `gF0=0.523599` → SUB_CALL 32（128 帧）→ GET_EXIT_ANGLE
    ---＋漂 60 帧 ×0.8；t=120 `gF0=−1.5708` → SUB_CALL 33（240 帧）→ 漂 60 帧；
    ---t=180 `gF0=+1.5708` → SUB_CALL 33（240 帧）→ `MOVE_POS_TIME 60 4 192 64`（我们 (0,160)）
    ---＋等 80 帧；t=260 `gF0=−0.523599` → SUB_CALL 32（128 帧）→ `gF0=+0.523599` →
    ---SUB_CALL 34（128 帧）→ 等 100 帧；t=360 跳回 t=60。
    ---  · sub32（g = gF0）：16 拍、每 8 帧一组「7 发 × 2 层（2.5→1.5）+ 1 发 × 5 层（4→1）」
    ---    的双扇，两个基准角每拍反向转 g（第一/第四次是 ±0.523599，第二/第三次是 ±1.5708）；
    ---  · sub33：SUB_CALL 2（120 帧）后 60 拍、每 2 帧在本体周围半径 32~64 处生成一个雪点
    ---    （角度 = 自机方向 + gF0，每拍转 gF0/30）；雪点匀速漂 i3_0（100~119）帧后朝外打
    ---    2 发窄扇（半张角 0.448799、速度 rand(1.2)+1），弹挂 0x10（沿自身朝向加速 π/120、120 帧）；
    ---  · sub34：同 sub32，但第二扇速度 2.2；`i2_0 % 4 == 0`（第 1/5/9/13 拍）时再补一圈
    ---    16 发自机狙（1 px/帧、基准角 = 第二扇的 f1）。
    ncard("レティ 非符 2", 4452, 16000, 1600, function(self)
        self._box = box5(32, 48, 352, 128)
        ---原作 sub35：雪点本体。等 wait 帧后打 2 发窄扇，再活 40 帧自毁（UNIMP）。
        local function snowbody(o, a0, spd, wait)
            local vx, vy = math.cos(a0) * spd, -math.sin(a0) * spd
            for _ = 1, wait do
                o.x, o.y = o.x + vx, o.y + vy
                task.Wait(1)
            end
            local a = ran:Float(0, PI) - PI / 2 + a0
            local v = ran:Float(0, 1.2) + 1
            ---原作 sub35 挂 commands[0]=type1（爆速段，flag=0）、commands[1]=type0x10
            ---（沿自身朝向 +0.00833333/帧、120 帧，flag=0）：爆速段的 exFlags 位 17 帧
            ---后自己清掉，加速段才轮得到（这条波的 flags=533 同时含这两个 type 位）。
            shoot6(o, 0, 0, 65, 3, ran:Int(0, 1) + 5, 2, 1, v, 1, a, 0.448799,
                   cmds4(533,
                         { type = 1, flag = 0, dur = -1, loop = -1, speed = -1, angle = -1 },
                         { type = 0x10, flag = 0, dur = 120, loop = -1,
                           speed = 0.00833333, angle = -999 }),
                   false)
            for _ = 1, 40 do task.Wait(1) end
        end
        ---★ 原作 sub32/34 的 `INIT_BULLET_CMD 0 1 0 -1 -1 -1 -1`（爆速段）是否生效
        ---看**每条波自己的 flags**（`moreFlags & cmd->type`）：
        ---  · sub32 首扇 flags=517（0x205 含 T1）⇒ 生效；
        ---  · sub32 次扇 flags=4、sub34 两扇 flags=516/4 ⇒ 不含 T1，永不激活；
        ---  · sub34 末圈 flags=5（含 T1）⇒ 生效。
        local function burst1(flags) return cmds4(flags,
            { type = 1, flag = 0, dur = -1, loop = -1, speed = -1, angle = -1 }) end
        ---原作 sub32：16 拍双扇（第二扇 v1 = 4）。
        local function sub32(g)
            local f0, f1 = 0, -1.5708
            for _ = 1, 16 do
                fan4(self, self.x, self.y, 2, 10, 7, 2, 2.5, 1.5, f0, 0.19635,
                     burst1(517))
                f0 = f0 + g
                shoot6(self, 0, 0, 65, 3, 6, 1, 5, 4.0, 1.0, f1, 0, burst1(4), false)
                f1 = f1 - g
                task.Wait(8)
            end
        end
        ---原作 sub34：第二扇 v1 = 2.2，且第 1/5/9/13 拍补一圈 16 发自机狙。
        local function sub34(g)
            local f0, f1 = 0, -1.5708
            for i = 1, 16 do
                fan4(self, self.x, self.y, 2, 10, 7, 2, 2.5, 1.5, f0, 0.19635,
                     burst1(516))
                f0 = f0 + g
                shoot6(self, 0, 0, 65, 3, 6, 1, 5, 2.2, 1.0, f1, 0, burst1(4), false)
                f1 = f1 - g
                if (17 - i) % 4 == 0 then
                    shoot6(self, 0, 0, 66, 1, 6, 16, 1, 1.0, 1.0, f1, 0, burst1(5), false)
                end
                task.Wait(8)
            end
        end
        ---原作 sub33：SUB_CALL 2（120 帧）＋ 60 拍、每 2 帧放一个雪点。
        local function sub33(g)
            PlaySound("power0", 0.35, self.x / 256)
            task.Wait(120)
            local step = g / 30
            local a0 = aimth(self) + g
            for _ = 1, 60 do
                local spd = ran:Float(0, 1.5) - 0.4
                local wait = ran:Int(0, 19) + 100
                local r = ran:Float(0, 32) + 32
                ---★ a0 是循环外的 upvalue，pspawn 的协程体要到下一帧才跑；
                ---若直接捕获 a0，读到的已经是 `a0 = a0 - step` 之后的值（雪点朝向、
                ---发弹角各差一个 step）。必须先拷一份本拍的角再进闭包。
                local aa = a0
                pspawn(self.x + math.cos(a0) * r, self.y - math.sin(a0) * r, function(o)
                    snowbody(o, aa, spd, wait)
                end)
                a0 = a0 - step
                task.Wait(2)
            end
        end
        task.New(self, function()
            ---原作 sub38 末尾 `JUMP 60 -296`（ins35 @776 → +480 = ins21 GET_EXIT_ANGLE），
            ---跳转目标是 **t=60 的 GET_EXIT_ANGLE**，不含 ins20 的 `SUB_CALL 32`：
            ---首轮的那次 sub32(0.523599) 只执行一次，之后每轮都从 `drift(GET_EXIT_ANGLE)` 起算。
            ---sub38 的 t=0..60 前奏：SET_ANM/SPAWN_EFFECT×6（本仓库无粒子接口，
            ---只保留这 60 帧的时长）——首轮 sub32 落在 sub38 的 t=60。
            task.Wait(60)
            sub32(0.523599)                               -- t=60（仅首轮）
            while true do
                drift(self, 0.8, 60)                      -- ins21/22（GET_EXIT_ANGLE + 漂 60）
                task.Wait(60)                             -- t=60 → t=120
                sub33(-1.5708)                            -- t=120
                drift(self, 0.8, 60)                      -- ins25/26
                task.Wait(60)                             -- → t=180
                sub33(1.5708)                             -- t=180
                bmove(self, 60, 4, 0, 160)                -- ins29/30（MOVE_POS_TIME，(192,64) ⇒ (0,160)）
                task.Wait(80)                             -- → t=260
                sub32(-0.523599)                          -- t=260
                sub34(0.523599)
                task.Wait(100)                            -- t=360 jump 回 t=60
            end
        end)
    end, { skin = skin1, enter = enter1 })

    ---──────────────────── 寒符「リンガリングコールド -Lunatic-」 ────────────────────
    ---原作 sub42 的 L 行（时间轴 t=480 起算；SUB_CALL 2 各冻结 120 帧 ⇒ 墙钟 = 时间轴 + 240）：
    ---  480 `gI0=30 gI1=4`＋SUB_CALL 2（120 帧粒子冻结）；510 在**当前位置**放一颗冰晶（sub43，
    ---  `f3_0 = rand(0.392699)+1.1781`、`f3_1 = +0.0349066`）；540 GET_EXIT_ANGLE＋漂 60 帧 ×0.7
    ---  ＋SUB_CALL 47（齐射）；600 SUB_CALL 47＋再放一颗冰晶（`f3_0 = 1.9635−rand(0.392699)`、
    ---  `f3_1 = −0.0349066`）；660 SUB_CALL 47；680 GET_EXIT_ANGLE＋漂；740 再漂＋SUB_CALL 2（120 帧）；
    ---  770 放第三颗冰晶（负向）；800 GET_EXIT_ANGLE＋漂＋放第四颗冰晶（正向）＋SUB_CALL 47；
    ---  860 / 920 SUB_CALL 47；980 漂＋JUMP 回 480。一轮 740 帧。
    ---  · sub43（冰晶）：绕**生成点**以 f3_0 为初角、f3_1 为角速度、半径 0 起、0.78 px/帧 外扩
    ---    320 帧（80 拍 × 4 帧），每拍在半径 rand(64)−32 的随机角上放一个雪点；随后半径冻结、
    ---    再活 ~4000 帧（`SET_DESPAWN_ON_OOB 0`）；
    ---  · sub36（雪点）：以（rand(2π)−π 方向、速度 rand(0.05)−0.025）几乎原地漂 80 帧
    ---    （`SET_WAIT_TIMER gI0=80`），随后「rand2==0 × rand2==0 × rand4!=0」才朝 `f3_2`
    ---    （每拍 +0.20944）方向打 3 发 ±1.406° 的散射（速度 rand(0.7)+0.8；弹挂
    ---    commands[0]=type1 爆速段 + commands[1]=type0x10 沿自身 −0.025/帧、120 帧）；
    ---    打完 `SET_PRIMARY_VM_INTERRUPT 1`、40 帧后消失；
    ---  · sub47（齐射）：1 发正对自机、速度 3.5（挂 type0x40：剎停 50 帧后速度 = 1、角度 +0）；
    ---    随后 6 拍、每拍 6 发正对自机：速度 f0 从 3 每拍 −0.4；每发挂 type0x40（剎停 50 帧后
    ---    角度 += f2 或 0−f2、速度 = f1 或 f1−0.4 或 f1−0.8；f1 从 1.1 每拍 +0.6、
    ---    f2 每拍 +0.1309）。每拍内 6 发的 cmd 参数依次为
    ---    (f2,f1)(f2,f1−0.4)(f2,f1−0.8)(0−f2,f1)(0−f2,f1−0.4)(0−f2,f1−0.8)。
    scard("寒符「リンガリングコールド -Lunatic-」", 4453, 50, 3600, false, function(self)
        self._box = box5(32, 48, 352, 128)
        ---原作 sub47：本体齐射。
        local function fire47()
            shoot6(self, 0, 0, 64, 7, 4, 1, 1, 3.5, 1.0, 0, 0.261799,
                   turn4(0, 1, 50, 1), true)
            local f0, f1, f2 = 3, 1.1, 0
            for _ = 1, 6 do
                for s = 0, 1 do
                    local g2 = (s == 0) and f2 or (0 - f2)
                    shoot6(self, 0, 0, 64, 1, 8, 1, 1, f0, 1.0, 0, 0, turn4(g2, f1, 50, 1), false)
                    shoot6(self, 0, 0, 64, 1, 8, 1, 1, f0, 1.0, 0, 0, turn4(g2, f1 - 0.4, 50, 1), false)
                    shoot6(self, 0, 0, 64, 1, 8, 1, 1, f0, 1.0, 0, 0, turn4(g2, f1 - 0.8, 50, 1), false)
                end
                f0, f1, f2 = f0 - 0.4, f1 + 0.6, f2 + 0.1309
            end
        end
        ---原作 sub36：雪点。`th0`/`spd` 是 MOVE_DIR_TIME 的方向与速度，`fan0` 是 f3_2（散射基准角）。
        local function snow(o, th0, spd, fan0)
            local vx, vy = math.cos(th0) * spd, -math.sin(th0) * spd
            for _ = 1, 80 do
                o.x, o.y = o.x + vx, o.y + vy
                task.Wait(1)
            end
            ---原作 sub36 的 L 行判定链（六条 RAND **每条都必抽**、顺序固定，否则
            ---全局随机流与后续雪点错位）：
            ---  instr14 f1 = rand(0.7)+0.8；instr15 i0 = rand(2)+5；
            ---  instr16 i1=rand(2)（≠0 ⇒ 只跳过 bullet-command 段，仍发弹）；
            ---  instr29 i1=rand(2)（≠0 ⇒ 跳过 instr31，那是 E 行）；
            ---  instr32 i1=rand(3)（==0 ⇒ 跳过 instr34，那是 N 行）；
            ---  instr35 i1=rand(4)（==0 ⇒ 跳过 instr38 ⇒ **本拍一颗不发**）。
            local v = ran:Float(0, 0.7) + 0.8
            local off = ran:Int(0, 1) + 5
            local skipcmd = ran:Int(0, 1) ~= 0
            ran:Int(0, 1)
            ran:Int(0, 2)
            if ran:Int(0, 3) ~= 0 then
                ---commands[0] = type1 爆速段（flag=0）、commands[1] = type0x10、
                ---方向 -0.025/帧、120 帧；只在 instr16 的 rand2==0 时才挂。
                local cmd = nil
                if not skipcmd then
                    cmd = cmds4(533,
                          { type = 1, flag = 0, dur = -1, loop = -1, speed = -1, angle = -1 },
                          { type = 0x10, flag = 0, dur = 120, loop = -1,
                            speed = -0.025, angle = -999 })
                end
                shoot6(o, 0, 0, 65, 3, off, 3, 1, v, 0.5, fan0, 0.0245437, cmd, false)
            end
            for _ = 1, 40 do task.Wait(1) end
        end
        ---原作 sub43：冰晶。
        ---`MOVE_ORBIT 180 X Y Z f3_0 f3_1 0 0.78`：以**生成点**为心、f3_0 为初角、
        ---f3_1 为角速度、半径从 0 每帧 +0.78，绕 180 帧（正好一整圈）后 moveMode 转
        ---`ENEMY_MOVE_AXIS` —— 之后改为**直线**漂，速度 = 第 180 帧的轨道增量
        ---（`EclManager.cpp` 的 ENEMY_MOVE_ORBIT 分支）。雪点是 `SPAWN_ENEMY_REL 36`
        ---（相对**晶体此刻**的位置），所以 180 帧后雪点跟着晶体一起飞出去。
        local function ice(a0, av)
            local cx, cy = self.x, self.y
            pspawn(cx, cy, function(o)
                local fan0 = 1.5708
                local th, r = a0, 0
                local vx, vy = 0, 0
                for k = 0, 79 do
                    local sa = rngrad()
                    local spd = ran:Float(0, 0.05) - 0.025
                    local rr = ran:Float(0, 64) - 32
                    ---★ fan0 是循环外唯一的「可变被捕获上值」：pspawn 起的协程
                    ---   在**下一帧**才跑第一拍，那时 fan0 已被本轮回加过一次 ⇒
                    ---   雪点扇角会整整偏一档。快照成局部量后再交出去。
                    local fa = fan0
                    pspawn(o.x + math.cos(sa) * rr, o.y - math.sin(sa) * rr,
                           function(p) snow(p, sa, spd, fa) end)
                    fan0 = fan0 + 0.20944
                    for f = 1, 4 do
                        local px, py = o.x, o.y
                        if k * 4 + f <= 180 then
                            th, r = th + av, r + 0.78
                            o.x, o.y = cx + math.cos(th) * r, cy - math.sin(th) * r
                            vx, vy = o.x - px, o.y - py
                        else
                            o.x, o.y = px + vx, py + vy
                        end
                        task.Wait(1)
                    end
                end
                for _ = 1, 4000 do task.Wait(1) end
            end)
        end
        task.New(self, function()
            ---原作 t=360 的 L 行开局（MOVE_POS_TIME 120 帧 + 开卡）在墙钟 0..120 跑完，
            ---t=480 的 SUB_CALL 2 才在墙钟 120 起步 ⇒ 桩件里先补这 120 帧序奏。
            task.Wait(120)
            while true do
                PlaySound("power0", 0.35, self.x / 256)     -- 480: SUB_CALL 2（120 帧）
                task.Wait(120)
                task.Wait(30)                              -- → 510
                ice(ran:Float(0, 0.392699) + 1.1781, 0.0349066)
                task.Wait(30)                              -- → 540
                drift(self, 0.7, 60)
                fire47()                                   -- 540
                task.Wait(60)                              -- → 600
                fire47()                                   -- 600
                ice(1.9635 - ran:Float(0, 0.392699), -0.0349066)
                task.Wait(60)                              -- → 660
                fire47()                                   -- 660
                task.Wait(20)                              -- → 680
                drift(self, 0.7, 60)                       -- 680
                task.Wait(60)                              -- → 740
                drift(self, 0.7, 60)                       -- 740
                PlaySound("power0", 0.35, self.x / 256)     -- 740: SUB_CALL 2（120 帧）
                task.Wait(120)
                task.Wait(30)                              -- → 770
                ice(1.9635 - ran:Float(0, 0.392699), -0.0349066)
                task.Wait(30)                              -- → 800
                drift(self, 0.7, 60)
                ice(ran:Float(0, 0.392699) + 1.1781, 0.0349066)
                fire47()                                   -- 800
                task.Wait(60)                              -- → 860
                fire47()                                   -- 860
                task.Wait(60)                              -- → 920
                fire47()                                   -- 920
                task.Wait(60)                              -- → 980
                drift(self, 0.7, 60)                       -- 980 → 跳回 480
            end
        end)
    end, { skin = skin1, wallskin = skin1w, enter = enter1b })

    ---──────────────────── レティ 非符 3（原作 sub39 = 40/40/33/32） ────────────────────
    ---sub39 的时间轴（L 行）：t=0 `f3=1`、`f0=rand` → `gF0=f0, gF1=+0.0314159, gF2=f3` →
    ---SUB_CALL 40（360 帧）→ `f3+=0.15`、GET_EXIT_ANGLE、漂 60 帧 ×0.7、`f0=rand`；
    ---t=60 `gF0=f0, gF1=−0.0314159, gF2=f3` → SUB_CALL 40（360）→ 同上；
    ---t=120 `gF0=+1.5708` → SUB_CALL 33（240）→ `MOVE_POS_TIME 60 4 192 64`（我们 (0,160)）；
    ---t=200 `gF0=+0.523599` → SUB_CALL 32（128）→ 等 100 帧；t=300 跳回 t=0。
    ---  · sub40：SUB_CALL 2（120 帧）后在本体处放 3 个「冰桌」（sub41），互隔 120°；
    ---    随后 GET_EXIT_ANGLE 漂 90 帧 ×0.6，t=240 返回（合计 360 帧）；
    ---  · sub41：以初始角 gF0、角速度 gF1、径向速度 gF2（= f3 = 1 / 1.15 / …）往外旋 120 帧，
    ---    之后半径冻结、角速度每 3 帧再加 gF1/30；每 3 帧打一组 3 发随机慢弹
    ---    （速度 rand(0.8)+0.2、方向 [−π,π)、sprite 1，挂 0x10 沿自身加速 π/75、120 帧），
    ---    共 60 组后自毁。原作那条 `i2_0 % 2` 的奇偶判断因为 JNEQ 跳进了「难度组」中间，
    ---    在四个难度上都不起作用，所以这里照抄成「每组都打」。
    ncard("レティ 非符 3", 4454, 15000, 1500, function(self)
        self._box = box5(32, 48, 352, 128)
        ---原作 sub35 的雪点（sub33 生）：匀速漂 wait 帧后朝外打 2 发窄扇。
        local function snowbody(o, a0, spd, wait)
            local vx, vy = math.cos(a0) * spd, -math.sin(a0) * spd
            for _ = 1, wait do
                o.x, o.y = o.x + vx, o.y + vy
                task.Wait(1)
            end
            local a = ran:Float(0, PI) - PI / 2 + a0
            local v = ran:Float(0, 1.2) + 1
            ---原作 sub35 挂 commands[0]=type1（爆速段，flag=0）、commands[1]=type0x10
            ---（沿自身朝向 +0.00833333/帧、120 帧，flag=0）：爆速段的 exFlags 位 17 帧
            ---后自己清掉，加速段才轮得到（这条波的 flags=533 同时含这两个 type 位）。
            shoot6(o, 0, 0, 65, 3, ran:Int(0, 1) + 5, 2, 1, v, 1, a, 0.448799,
                   cmds4(533,
                         { type = 1, flag = 0, dur = -1, loop = -1, speed = -1, angle = -1 },
                         { type = 0x10, flag = 0, dur = 120, loop = -1,
                           speed = 0.00833333, angle = -999 }),
                   false)
            for _ = 1, 40 do task.Wait(1) end
        end
        ---原作 sub33：SUB_CALL 2（120 帧）＋ 60 拍、每 2 帧一个雪点。
        local function sub33(g)
            PlaySound("power0", 0.35, self.x / 256)
            task.Wait(120)
            local step = g / 30
            local a0 = aimth(self) + g
            for _ = 1, 60 do
                local spd = ran:Float(0, 1.5) - 0.4
                local wait = ran:Int(0, 19) + 100
                local r = ran:Float(0, 32) + 32
                ---★ a0 是循环外的 upvalue，pspawn 的协程体要到下一帧才跑；
                ---若直接捕获 a0，读到的已经是 `a0 = a0 - step` 之后的值（雪点朝向、
                ---发弹角各差一个 step）。必须先拷一份本拍的角再进闭包。
                local aa = a0
                pspawn(self.x + math.cos(a0) * r, self.y - math.sin(a0) * r, function(o)
                    snowbody(o, aa, spd, wait)
                end)
                a0 = a0 - step
                task.Wait(2)
            end
        end
        ---原作 sub32：16 拍双扇。
        local function sub32(g)
            local f0, f1 = 0, -1.5708
            for _ = 1, 16 do
                ---★ sub32 第一扇 flags=517=0x205（含 T1）⇒ 挂爆速段
                ---`INIT_BULLET_CMD 0 1 0 -1 -1 -1 -1`（前 17 帧 speed = 5 − t·5/16 + 自身速率）。
                fan4(self, self.x, self.y, 2, 10, 7, 2, 2.5, 1.5, f0, 0.19635,
                     cmds4(517, { type = 1, flag = 0, dur = -1, loop = -1,
                                  speed = -1, angle = -1 }))
                f0 = f0 + g
                shoot6(self, 0, 0, 65, 3, 6, 1, 5, 4.0, 1.0, f1, 0, nil, false)
                f1 = f1 - g
                task.Wait(8)
            end
        end
        ---原作 sub41：绕本体外旋的冰桌。
        local function orbit41(o, cx, cy, a0, av, rv)
            local ang, r = a0, 0
            for _ = 1, 120 do
                ang, r = ang + av, r + rv
                o.x, o.y = cx + math.cos(ang) * r, cy - math.sin(ang) * r
                task.Wait(1)
            end
            local avv = av
            for _ = 1, 60 do
                avv = avv + av / 30
                for _ = 1, 3 do
                    ---★ 原作 op72 `RANDOM`（BULLET_AIM_RANDOM）每发**先抽角度再抽速度**
                    ---（BulletManager.cpp:225-232），这里必须按同一顺序抽，否则随机流对不上。
                    local th = ran:Float(0, 2 * PI) - PI
                    local v = ran:Float(0, 0.8) + 0.2
                    ---★ 这里走的是**单段**口径（cmd 表没有 `.list`）⇒ 0x10 的加速度必须
                    ---写成 `accel`（`cmdbullet_enter` 只在 `c.accel` 分支里冻结 vec3）；
                    ---只写 `speed` 会得到零向量 = 完全不加速。原作 sub41 的
                    ---`INIT_BULLET_CMD 0 16 0 120 -1 0.0133333 -999` 是 120 帧 +1/75 速度。
                    dot4(o.x, o.y, 1, 6, v, th, accel6(0.0133333, 120))
                end
                for _ = 1, 3 do
                    ang = ang + avv
                    o.x, o.y = cx + math.cos(ang) * r, cy - math.sin(ang) * r
                end
                task.Wait(3)
            end
            for _ = 1, 40 do task.Wait(1) end
        end
        ---原作 sub40：SUB_CALL 2（120 帧）后放 3 个冰桌，再漂 90 帧 ×0.6（t=240 返回）。
        local function sub40(g0, g1, g2)
            PlaySound("power0", 0.35, self.x / 256)
            task.Wait(120)
            local cx, cy = self.x, self.y
            for k = 0, 2 do
                local aa = g0 + k * 2.0944
                pspawn(cx, cy, function(o)
                    orbit41(o, cx, cy, aa, g1, g2)
                end)
            end
            task.Wait(120)                    -- t=0 → t=120
            drift(self, 0.6, 90)              -- t=120 的 MOVE_DIR_TIME
            task.Wait(120)                    -- t=120 → t=240（漂移在前 90 帧内跑完）
        end
        task.New(self, function()
            local f3 = 1
            while true do
                local a = rngrad()                         -- t=0 idx22 RAND_FLOAT_ADD → gf0
                sub40(a, 0.0314159, f3)                    -- t=0
                f3 = f3 + 0.15
                drift(self, 0.7, 60)                       -- t=0 idx28 GET_EXIT_ANGLE
                a = rngrad()                               -- t=0 idx30 RAND_FLOAT_ADD（t=0 的收尾，
                                                           --   下轮 t=60 的 SUB_CALL 40 用 gf0=它）
                task.Wait(60)                              -- → t=60
                sub40(a, -0.0314159, f3)                   -- t=60
                f3 = f3 + 0.15
                drift(self, 0.7, 60)
                task.Wait(60)                              -- → t=120
                sub33(1.5708)                              -- t=120
                bmove(self, 60, 4, 0, 160)                 -- (192,64) ⇒ (0,160)
                task.Wait(80)                              -- → t=200
                sub32(0.523599)                            -- t=200
                task.Wait(100)                             -- t=300 跳回 t=0
            end
        end)
    end, { skin = skin1, enter = enter1 })

    ---──────────────────── 白符「アンデュレイションレイ」 ────────────────────
    ---原作 sub52/53/54（L 行）。`SUB_CALL` 是**阻塞**调用（调用方的 time 在子程序跑完
    ---前被冻住），所以墙钟 = 调用方 t 差 + 子程序时长；下面把两者都写成等待。
    ---  · sub52 先 `MOVE_POS_TIME 120 4 192 112`（我们 (0,112)）摆位，再进 **710 帧**主循环：
    ---      t=120  gF0=π/2 gF1=+0.0349066 gF2=0.8 gI0=5 gI1=1 lf3=+0.00369599 → SUB_CALL 53
    ---      t=240  gF1=−0.0349066 lf3=−0.00369599（其余同上）               → SUB_CALL 53
    ---      t=270  GET_EXIT_ANGLE ＋ MOVE_DIR_TIME 60 4 · 1.5，再
    ---             gF1=+0.0349066 gF2=0.8 gI0=4 lf3=+0.00349066             → SUB_CALL 53
    ---      t=290  GET_EXIT_ANGLE ＋ MOVE_DIR_TIME 60 4 · 1.5
    ---      t=350  gF1=−0.0349066 gF2=0.8 gI0=4 lf3=−0.00349066             → SUB_CALL 53
    ---      t=410  MOVE_POS_TIME 60 4 192 112，再
    ---             gF1=+0.0369599 gF2=0.8 gI0=3 gI1=1 lf3=+0.00392699       → SUB_CALL 53
    ---             紧接着 gF1=−0.0369599 gF2=0.8 gI0=3 gI1=0 lf3=−0.00392699 → SUB_CALL 53
    ---      t=590  JUMP → t=120
    ---  · sub53：`gI1==1` 时先跑「PLAY_SOUND 5 ＋ 每 4 帧一发 `SPAWN_PARTICLES 17 4`、
    ---    共 12 发」= **48 帧冻结**；随后 `PLAY_SOUND 16`、`SET_ANM 137`，按 gI0 只涟漪点，
    ---    每只的 orbitAngleVel = gF1 + (k−1)·lf3（gF0 恒 π/2、半径从 0 起、径速 gF2）。
    ---  · sub54：`MOVE_ORBIT 120 X Y Z gF0 gF1 0 gF2`（X/Y/Z = 波纹出生点），出生当帧起
    ---    每 8 帧（共 12 次）打一组 `SPREAD_ABS 5:6 c1=3 c2=2 1.8→0.5 a2=π/4`，
    ---    基准角 a1 = **ANG+π**；ANG = `enemy->angle`（ECL_VAR_ANGLE）就是 MOVE_ORBIT 的
    ---    **运动方向** —— EnemyManager 的 ENEMY_MOVE_ORBIT 分支每帧
    ---    `angle = atan2(velocity)`，velocity = 本帧轨道点 − 上一帧 pos，所以这里逐帧
    ---    按离散差分重算 ANG（不是拿轨道角）。
    ---  · H/L 行只差 count2（H: c2=1、L: c2=2），移植版取 L 行。
    ---差异 64：sub54 每组前的 `DIV_FLOAT ANGVEL ANGVEL 1.4` 里 ANGVEL 是
    ---  `ECL_VAR_ANGULAR_VELOCITY`（= enemy->angleVel），MOVE_ORBIT 从不写它 ⇒ 这条除法
    ---  是**恒等**。旧版把它当成「公转角速度 ÷1.4」是错的，朝向跟着全错。
    ---差异 65：涟漪点是 `SET_IS_PROJECTILE 1`＋8×8×32 体术判定的实体，本仓库的 pspawn
    ---  子机无判定、无贴图（同 4439/4451 口径）。
    scard("白符「アンデュレイションレイ」", 4455, 50, 3000, false, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            ---原作 sub54：一只涟漪点。th0 = orbitAngle、w = orbitAngleVel、rv = 径速。
            ---出生当帧先打一组（ANG 还是模板初值 0），再走 8 帧轨道；如此 12 次。
            local function ripple(cx, cy, th0, w, rv)
                pspawn(cx, cy, function(o)
                    local a, rad, px, py, ang = th0, 0, 0, 0, 0
                    for _ = 1, 12 do
                        fan4(o, o.x, o.y, 5, 6, 3, 2, 1.8, 0.5, ang + PI, 0.785398)
                        for _ = 1, 8 do
                            a, rad = a + w, rad + rv
                            local nx, ny = math.cos(a) * rad, math.sin(a) * rad
                            local vx, vy = nx - px, ny - py
                            if vx ~= 0 or vy ~= 0 then ang = atan2(vy, vx) end
                            px, py = nx, ny
                            o.x, o.y = cx + nx, cy - ny
                            task.Wait(1)
                        end
                    end
                end)
            end
            ---原作 sub53：一次 SUB_CALL 53。charge（gI1==1）⇒ 48 帧蓄力；随后在**这一刻的
            ---本体位置**放出 n 只涟漪点，角速度逐只 +f3。
            local function wave(w, f3, n, charge)
                if charge then
                    PlaySound("power0", 0.35, self.x / 256)
                    task.Wait(48)
                end
                PlaySound("lazer00", 0.13, self.x / 256)
                local ww = w
                for _ = 1, n do
                    ripple(self.x, self.y, PI / 2, ww, 0.8)
                    ww = ww + f3
                end
            end
            task.Wait(120)                                   -- t=0 MOVE_POS_TIME 120 4 (192,112)
            while true do
                wave(0.0349066, 0.00369599, 5, true)         -- t=120
                task.Wait(120)                               -- t=240
                wave(-0.0349066, -0.00369599, 5, true)
                task.Wait(30)                                -- t=270
                drift(self, 1.5, 60)
                wave(0.0349066, 0.00349066, 4, true)         -- 漂 60 帧 + 蓄力 48 帧（本体还在漂）
                task.Wait(20)                                -- t=290
                drift(self, 1.5, 60)
                task.Wait(60)                                -- t=350（漂 60 帧后到位）
                wave(-0.0349066, -0.00349066, 4, true)
                task.Wait(60)                                -- t=410
                bmove(self, 60, 4, 0, 112)
                wave(0.0369599, 0.00392699, 3, true)         -- 移动 60 帧 + 蓄力 48 帧
                wave(-0.0369599, -0.00392699, 3, false)      -- gI1=0：不蓄力，同帧再放
                task.Wait(180)                               -- t=590 → JUMP t:=120
            end
        end)
    end, { skin = skin1, wallskin = skin1w, enter = enter1e })

    ---──────────────────── 怪符「テーブルターニング」 ────────────────────
    ---原作 sub55/56/57（L 行）。主循环 **814 帧**（t 差 + 子程序 48 帧冻结）：
    ---  t=0    MOVE_POS_TIME 120 4 192 112（我们 (0,112)）
    ---  t=120  lf3=+0.00369599 gF0=−π/2 gF1=+0.0261799 gF2=0.5 gI0=5 gI1=1 → SUB_CALL 56
    ---  t=240  lf3=−0.00369599（**没有** SUB_CALL；gF0..gI1 沿用 t=120 那一组）
    ---  t=270  GET_EXIT_ANGLE ＋ MOVE_DIR_TIME 60 4 · 1.0 ；t=270 另设 lf3=+0.00349066
    ---  t=370  gF0=−π/2 gF1=+0.0261799 gF2=0.5 gI0=5 gI1=1 → SUB_CALL 56
    ---  t=390  GET_EXIT_ANGLE ＋ MOVE_DIR_TIME 60 4 · 1.0
    ---  t=450  lf3=−0.00349066
    ---  t=510  MOVE_POS_TIME 60 4 192 112 ；lf3=+0.00392699
    ---  t=610  gF0=−π/2 gF1=+0.0261799 gF2=0.5 gI0=3 gI1=1 → SUB_CALL 56
    ---  t=610  gF0=−π/2 gF1=−0.0261799 gF2=0.5 gI0=3 gI1=0 → SUB_CALL 56
    ---  t=790  JUMP → t=120
    ---  · sub56 与 sub53 同型：gI1==1 时先 48 帧「音效＋粒子×12」，随后按 gI0 只齿轮、
    ---    每只 orbitAngleVel = gF1 + (k−1)·lf3。
    ---  · sub57：`MOVE_ORBIT 320 X Y Z gF0 gF1 0 gF2`（径速 0.5、跑 320 帧），每 **24 帧**
    ---    里发两圈（t=0 与 t=12），共 15 拍：
    ---      第 1 圈 `RING_ABS 6:6 c1=5 1.8→0.5 a1=−ANG a2=π`（flags 512）
    ---      第 2 圈 `RING_ABS 6:5 c1=5 0.5→0.5 a1=−ANG a2=π`（flags 529）
    ---    ⇒ 30 圈、每圈 5 发；360 帧后 `SET_DESPAWN_ON_OOB 0`。
    ---  · ANG 同 4455：MOVE_ORBIT 的**运动方向**（离散差分），a1 = −ANG。
    ---差异 64/65 同 4455（`DIV_FLOAT ANGVEL ANGVEL 1.4` 是恒等；pspawn 无判定无贴图）。
    scard("怪符「テーブルターニング」", 4456, 50, 3000, false, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            ---原作 sub57：一只冰齿轮。th0 = orbitAngle、w = orbitAngleVel、rv = 径速。
            local function gear(cx, cy, th0, w, rv)
                pspawn(cx, cy, function(o)
                    local a, rad, px, py, ang = th0, 0, 0, 0, 0
                    local vx, vy, n = 0, 0, 0
                    local function step(cnt)
                        for _ = 1, cnt do
                            n = n + 1
                            if n <= 320 then
                                a, rad = a + w, rad + rv
                                local nx, ny = math.cos(a) * rad, math.sin(a) * rad
                                vx, vy = nx - px, ny - py
                                if vx ~= 0 or vy ~= 0 then ang = atan2(vy, vx) end
                                px, py = nx, ny
                                o.x, o.y = cx + nx, cy - ny
                            else
                                ---★ `MOVE_ORBIT 320 …` 的 moveInterpTimer 到点后原作切
                                ---`ENEMY_MOVE_AXIS`（EclManager.cpp:2018-2026）：速度**不清零**，
                                ---沿用最后一帧的 velocity 一路直线飞（AXIS 分支在 exit 里没有
                                ---任何代码 ⇒ 每帧只剩下 `Enemy::Move` 的 pos += velocity）。
                                o.x, o.y = o.x + vx, o.y - vy
                            end
                            task.Wait(1)
                        end
                    end
                    for _ = 1, 15 do
                        ring4(o, o.x, o.y, 6, 6, 5, 1, 1.8, 0.5, -ang, PI)
                        step(12)
                        ---★ 第二圈 flags=529=0x211（含 0x1 与 0x10）⇒ 挂两段 INIT_BULLET_CMD：
                        ---#0 `0 1 0 -1 -1 -1 -1`（type1 爆速：前 17 帧 speed = 5 − t·5/16 + 自身速率）、
                        ---#1 `1 16 0 60 -1 0.0166667 -999`（0x10：沿**激活那一刻的朝向**每帧 +1/60
                        ---速度；angle=−999 ⇒ 用弹自己的朝向）。第一圈 flags=512=0x200 没有这两个位。
                        ring4(o, o.x, o.y, 6, 5, 5, 1, 0.5, 0.5, -ang, PI,
                              cmds4(529, { type = 1 },
                                        { type = 0x10, dur = 60, loop = -1, speed = 0.0166667 }))
                        step(12)
                    end
                end)
            end
            ---原作 sub56：一次 SUB_CALL 56。
            local function wave(w, f3, n, charge)
                if charge then
                    PlaySound("power0", 0.35, self.x / 256)
                    task.Wait(48)
                end
                PlaySound("lazer00", 0.13, self.x / 256)
                local ww = w
                for _ = 1, n do
                    gear(self.x, self.y, -PI / 2, ww, 0.5)
                    ww = ww + f3
                end
            end
            task.Wait(120)                                   -- t=0 MOVE_POS_TIME 120 4 (192,112)
            while true do
                wave(0.0261799, 0.00369599, 5, true)         -- t=120
                task.Wait(120)                               -- t=240（只改 lf3）
                task.Wait(30)                                -- t=270
                drift(self, 1.0, 60)                         -- t=270 起 MOVE_DIR_TIME 60（只下令、不阻塞）
                task.Wait(100)                               -- t=270 → 370（原作 100 帧）
                wave(0.0261799, 0.00349066, 5, true)
                task.Wait(20)                                -- t=390
                drift(self, 1.0, 60)
                task.Wait(60)                                -- t=450（漂 60 帧，只改 lf3）
                task.Wait(60)                                -- t=510
                bmove(self, 60, 4, 0, 112)
                task.Wait(100)                               -- t=610（移动 60 帧 + 空 40 帧）
                wave(0.0261799, 0.00392699, 3, true)
                wave(-0.0261799, -0.00392699, 3, false)      -- gI1=0：不蓄力
                task.Wait(180)                               -- t=790 → JUMP t:=120
            end
        end)
    end, { skin = skin1, wallskin = skin1w, enter = enter1e })

    ---──────────────────── 橙 非符 1（原作 sub41 的循环 = 43/43/43/42） ────────────────────
    ---逐条照抄原作 sub41 的时间轴（墙钟按解释器实测，一次循环 = 421 帧）：
    ---  · t=0 起三段 `MOVE_DIR_TIME 30 4 f0 (1 / 1.5 / 2)` —— 每段**移动 30 帧之后**
    ---    才在下一帧调用 sub43（`SUB_CALL` 阻塞调用方 1 帧）；实测三段扇分别落在
    ---    墙钟 30 / 61 / 92，扇之后紧接下一段移动；
    ---  · t=90 的 `MOVE_POS_TIME 40 4 192 96`（我们 (0,128)）与第三段扇同帧开始；
    ---  · t=130 `SUB_CALL 42`：先 `SUB_CALL 2`（gi0=10 / gi1=3 ⇒ 40 帧粒子），
    ---    再从 t=0 起**每 6 帧**放一只凤凰火（34/35 交替，共 8 只，实测墙钟 173..215），
    ---    sub42 共 88 帧，返回后调用方再等 200 帧才 JUMP 回 t=0。
    ---  · sub43（Lunatic）：先 12 组 `3:10` 扇（朝自机 0° / ±120° 三个方向各 4 组、
    ---    count1 = 1..4、速度 1.3 / 1.0 / 0.7 / 0.4、层间距 15°、指令 0x10 dur 90
    ---    speed 0.0155556），再 10 组 `3:10` 扇（只有 ±18° 两个方向、count1 = 1..5、
    ---    速度 1.9..0.7、层间距 18°、指令 0x10 dur 120 speed 0.000833333）。
    ---    22 组里只有第 3 方向 count1=3 那一组带 flags 0x200 ⇒ 本帧响一次弹音。
    ---  · 凤凰火本体（sub34/35）：t=0..180 用 `INIT_INTERP` 插值 —— 但目标 (f0,f1)
    ---    在 life≠9999 时被 `SET_FLOAT f0 *X` / `SET_FLOAT f1 *Y` 覆盖成出生点，
    ---    所以**原地不动**；t=180 生成本体的爆裂（sub28 / sub29）后自毁。
    ---  · sub28（大）：`2:6` 四圈同心环 5×2 / 8×3 / 12×3 / 20×3（2.5/2.5/2.7/3.2→1.5）；
    ---    sub29（小）：`2:10` 四圈 4×4 / 6×4 / 10×4 / 10×4（3.1/3.1/3.3/3.3→1.6）。
    ---    两者的基准角都是同一帧重掷的 RNG 角。
    local function enter2(self)
        self._orb, self._mv = nil, nil
        self.x, self.y = 224, 96
        bmove(self, 60, 4, 0, 96)
    end
    ncard("橙 非符 1", 4460, 15000, 1500, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            ---原作 sub43（Lunatic 行）：22 组 `3:10` 自机狙扇。
            local function volley()
                for _, d in ipairs({ 0, 2.0944, -2.0944 }) do
                    for n = 1, 4 do
                        shoot6(self, 0, 0, 64, 3, 10, n, 1, 1.3 - 0.3 * (n - 1), 0.5,
                               d, 0.261799, accel6(0.0155556, 90), false)
                    end
                end
                for _, d in ipairs({ 0.314159, -0.314159 }) do
                    for n = 1, 5 do
                        shoot6(self, 0, 0, 64, 3, 10, n, 1, 1.9 - 0.3 * (n - 1), 0.5,
                               d, 0.314159, accel6(0.000833333, 120), false)
                    end
                end
                sound4(self)                 -- sub43 里只有第 3 方向 count1=3 那组带 0x200
            end
            ---一只凤凰火（sub34 → 爆裂 sub28 / sub35 → sub29）。
            ---★原作 sub34 的 t=0 用 INIT_INTERP 把位置从**出生点** Hermite 到随机目标
            ---（p0 被 idx13 `SET_FLOAT *f0 *X` 覆盖成出生 X、p1 = rand(256)+64；
            --- Y 同理 p0=*Y、p1=rand(160)+32；两条切线各 ±144），**不是** 180 帧原地不动。
            ---随机流顺序（务必逐条照抄）：X 起点(死抽)、X 终点、X 两切线、
            ---Y 起点(死抽)、Y 终点、Y 两切线。
            local function head(big)
                local x0, y0 = self.x, self.y
                ran:Float(0, 256)
                local tx = ran:Float(64, 320) - 192
                local mx0, mx1 = rnd_sign() * 144, rnd_sign() * 144
                ran:Float(0, 160)
                local ty = 224 - ran:Float(32, 192)
                local my0, my1 = -rnd_sign() * 144, -rnd_sign() * 144
                pspawn(x0, y0, function(o)
                    task.Wait(1)
                    for k = 1, 180 do
                        local u = k / 180
                        o.x = hermite(u, x0, tx, mx0, mx1)
                        o.y = hermite(u, y0, ty, my0, my1)
                        if k == 180 then
                            local a = rngrad()
                            ---★原作 sub28/sub29 的四条 RING_ABS 是**四选一**难度掩码
                            ---（0x01/0x02/0x04/0x08），Lunatic 只出最后那一条：
                            ---  sub28：`RING_ABS 2:6 20 3 3.2 1.5 *f0 0 513`
                            ---  sub29：`RING_ABS 2:10 10 4 3.3 1.6 *f0 0 513`
                            ---flags=513=0x201 ⇒ 含 0x1 位：挂 `INIT_BULLET_CMD 0 1 0 -1 -1 -1 -1`
                            ---（type1 爆速：前 17 帧 speed = 5 − t·5/16 + 自身速率）。缺了它
                            ---环上弹的初速只有 3.2/3.3，而原作是 8.2/8.3 起步。
                            if big then
                                ring4(o, o.x, o.y, 2, 6, 20, 3, 3.2, 1.5, a, 0,
                                      cmds4(513, { type = 1 }))
                            else
                                ring4(o, o.x, o.y, 2, 10, 10, 4, 3.3, 1.6, a, 0,
                                      cmds4(513, { type = 1 }))
                            end
                        end
                        task.Wait(1)
                    end
                end)
            end
            while true do
                ---t=0..30：MOVE_DIR 30 帧、速度 1.0（`GET_EXIT_ANGLE` 的随机方向）
                drift(self, 1.0, 30)
                task.Wait(30)
                volley()                                 -- 墙钟 30
                task.Wait(1)                             -- SUB_CALL 43 阻塞的 1 帧
                drift(self, 1.5, 30)
                task.Wait(30)
                volley()                                 -- 墙钟 61
                task.Wait(1)
                drift(self, 2.0, 30)
                task.Wait(30)
                volley()                                 -- 墙钟 92
                task.Wait(1)
                bmove(self, 40, 4, 0, 128)               -- MOVE_POS_TIME 40 4 192 96
                task.Wait(40)
                ---SUB_CALL 42：先 SUB_CALL 2（gi0=10 / gi1=3 ⇒ 每 4 帧一发粒子、共 10 发
                ---+ PLAY_SOUND 5，冻结 40 帧），返回后再每 6 帧一只凤凰火（共 8 只）。
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(40)
                for k = 1, 8 do
                    head(k % 2 == 1)                     -- 34(大,sub28) / 35(小,sub29)
                    task.Wait(6)
                end
                task.Wait(200)
            end
        end)
    end, { skin = skin2, enter = enter2 })

    ---──────────────────── 仙符「鳳凰展翅 -Lunatic-」 ────────────────────
    ---原作 sub45：L 行在 t=120 摆到 (192,112)=我们 (0,112) 并开卡，t=240 起进入循环
    ---（`JUMP t:=240`），一次循环的墙钟 = **420 帧**（`SET_TIMER_CALLBACK_THRESHOLD`
    ---2400 ⇒ 本框架 t3 = 40 秒）。
    ---  · 每轮放 8 只凤凰火（32/33 交替），出生时刻（相对循环起点，含 SUB_CALL 2 的
    ---    40 帧阻塞）：0 / 60 / 70 / 190 / 200 / 280 / 380 / 400；
    ---  · 凤凰火（sub32/33）：`INIT_INTERP` 的目标 (f0,f1) 在 life≠9999 时被
    ---    `SET_FLOAT f0 *X` / `f1 *Y` 覆盖成出生点 ⇒ **原地不动** 180 帧；
    ---    t=180 生成本体的爆裂（32→sub26、33→sub27），t=210 自毁。
    ---  · sub26（大，贴图 `6:6`）：同一帧叠 9 圈 `RING_ABS`，共享同一个随机基准角；
    ---    4 组「20 发(2.4→1.5) + 22 发(3.0→1.5)」+ 收尾 22 发(3.0→1.5)，
    ---    每组各带一条 `0x40`（60 帧刹到停、再转 +1.5708 / +1.66897 / +1.76715 /
    ---    +1.86532 / +1.9635 弧度、速度换成 2.0 / 1.9 / 1.8 / 1.7 / 1.6）；
    ---  · sub27（小，贴图 `6:10`）：同上但 0x40 的角增量取负、收尾是 **28 发(3.2→1.5)**。
    scard("仙符「鳳凰展翅　-Lunatic-」", 4461, 40, 3000, false, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            ---原作 `INIT_BULLET_CMD 0 64 0 60 1 <拐角> <复速>`：0x40 DirChangeAndResume
            ---（state.angle = ECL 的 cmd.speed、state.speed = cmd.angle，见 BulletManager.cpp:410）。
            local function C40(th, sp)
                return { type = 0x40, flag = 0, dur = 60, loop = 1,
                         angle = -th * RAD2DEG, speed = sp }
            end
            ---一只凤凰火：沿 INIT_INTERP 从出生点 Hermite 到随机目标（同 sub34），
            ---t=180 炸成 sub26（大）/ sub27（小）。随机流顺序逐条照抄。
            local function head(big)
                local x0, y0 = self.x, self.y
                ran:Float(0, 256)
                local tx = ran:Float(64, 320) - 192
                local mx0, mx1 = rnd_sign() * 144, rnd_sign() * 144
                ran:Float(0, 160)
                local ty = 224 - ran:Float(32, 192)
                local my0, my1 = -rnd_sign() * 144, -rnd_sign() * 144
                pspawn(x0, y0, function(o)
                    task.Wait(1)
                    for k = 1, 180 do
                        local u = k / 180
                        o.x = hermite(u, x0, tx, mx0, mx1)
                        o.y = hermite(u, y0, ty, my0, my1)
                        if k == 180 then break end
                        task.Wait(1)
                    end
                    local a = rngrad()
                    local G = { { 1.5708, 2.0 }, { 1.66897, 1.9 }, { 1.76715, 1.8 },
                                { 1.86532, 1.7 }, { 1.9635, 1.6 } }
                    for i = 1, 5 do
                        ---★原作是**难度二选一**：`RING_ABS 6:6 20 ... [skip=0x04]`（Hard）
                        ---与 `RING_ABS 6:6 22 1 3 1.5 ... [skip=0x08]`（Lunatic）。本卡
                        ---走 L 行 ⇒ 每段只有 22 发那一环（旧版把 Hard 的 20 发也发了）。
                        local g = G[i]
                        local th = big and g[1] or -g[1]
                        local cmd = cmds4(0x40, C40(th, g[2]))
                        if big then
                            ring4(o, o.x, o.y, 6, 6, 22, 1, 3.0, 1.5, a, 0, cmd)
                        else
                            ---小凤凰：第 5 段收尾换成 28 发 / 速度 3.2（instr18 无难度掩码）。
                            local n, v1 = (i < 5) and 22 or 28, (i < 5) and 3.0 or 3.2
                            ring4(o, o.x, o.y, 6, 10, n, 1, v1, 1.5, a, 0, cmd)
                        end
                    end
                end)
            end
            ---原作 t=120 的 MOVE_POS_TIME 120 4 192 112（= enter1b）走完 120 帧，
            ---紧接 t=240 的 SUB_CALL 2（gi0=30 / gi1=4 ⇒ 30×4 帧粒子 + PLAY_SOUND 5）
            ---再冻 120 帧；JUMP 的落点（t=240 的 SPAWN_ENEMY_REL 32）才从 f=240 起算。
            task.Wait(120)
            PlaySound("power0", 0.35, self.x / 256)
            task.Wait(120)
            while true do
                ---相对循环起点的出生时刻：0/60/70/190/200/280/380/400（一次 420 帧）
                head(true)
                task.Wait(60)
                head(false)
                task.Wait(10)
                head(true)                   -- t=310 的发（在原作排在 SUB_CALL 2 之前）
                PlaySound("power0", 0.35, self.x / 256)   -- 原作 t=310 SUB_CALL 2（gi0=10 ⇒ 40 帧）
                task.Wait(120)               -- 含 SUB_CALL 2 的 40 帧
                head(false)
                task.Wait(10)
                head(true)
                task.Wait(80)
                head(false)                  -- t=480 的发（同样排在 SUB_CALL 2 之前）
                PlaySound("power0", 0.35, self.x / 256)   -- 原作 t=480 SUB_CALL 2（gi0=10 ⇒ 40 帧）
                task.Wait(100)               -- 含 SUB_CALL 2 的 40 帧
                head(true)
                task.Wait(20)
                head(false)
                task.Wait(20)
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1b })

    ---──────────────────── 橙 非符 2（原作 sub49 的循环 = 51/50/50/50/51） ────────────────────
    ---逐条照抄原作 sub49（`SET_LIFE 17000` / `SET_TIMER_CALLBACK_THRESHOLD 2100`）。
    ---解释器实测的墙钟（起点 = `SET_MOVEMENT_BOUNDS` 那一帧，一次循环 **587 帧**）：
    ---  · 开场先 `SUB_CALL 51`（164 帧），返回后调用方还要等到 t=180 ⇒ 再空 120 帧；
    ---  · t=180 / 240 / 300 三段 `MOVE_DIR_TIME 60 4 f0 1.5`，每段前接一次 sub50
    ---    （`SUB_CALL` 阻塞 1 帧 ⇒ 实测扇落在 344 / 405 / 466）；
    ---  · t=420 `MOVE_POS_TIME 60 4 192 80`（我们 (0,144)）；
    ---  · t=480 `SUB_CALL 51` + `INC i2_3`，然后 `JUMP t:=60` 到 t=180 的指令 ⇒ 再空 120 帧。
    ---  · sub50（Lunatic 行）：指令 0x10 dur 90 speed 0.0255556，12 组 `3:10` 扇
    ---    （朝自机 0°/±120° 三个方向各 4 组、count1 = 1..4、速度 1.3/1.0/0.7/0.4、
    ---    层间距 15°）。只有第 3 方向 count1=3 那组带 flags 0x200 ⇒ 每拍一声弹音。
    ---  · sub51：先 `SUB_CALL 2`（gi0=20 / gi1=1 ⇒ **80 帧粒子**），再在 t=0..84
    ---    连打 **12 圈**：前六圈贴图 `6:2`、后六圈 `6:6`；count1 依次读 i2/i2/i3/i3
    ---    （sub51 在 t=0 把 i2 定成 32、i3 定成 24）、E/F 与 K/L 是显式 24 发；
    ---    速度 0.5/1.0/1.5/2.0（前四圈）与 0.5/1.0/1.5/2.0（后四圈），
    ---    基准角每圈 ±0.0654498；每圈带一条 0x40（120 帧刹停→拐一次→复速
    ---    2.0/1.7/1.4/1.1 或 ±2.24399），前八圈另带一条 0x20 自旋（±0.0261799 /
    ---    ∓0.0392699 / ±0.0523599 / ∓0.0314159）。
    ncard("橙 非符 2", 4462, 17000, 1700, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            ---原作 sub51 的一整段（含 80 帧粒子），共 164 帧。
            ---开头 `SUB_CALL 2`（gi0=20 / gi1=1 ⇒ 20 发粒子、冻结 80 帧 + PLAY_SOUND 5）。
            local function rings()
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(80)
                local function C40(th, sp)
                    return { type = 0x40, flag = 0, dur = 120, loop = 1,
                             angle = -th * RAD2DEG, speed = sp }
                end
                local function R(spr, col, n, c2, v1, v2, a1, a2, cmd)
                    ring4(self, self.x, self.y, spr, col, n, c2, v1, v2, a1, a2, cmd)
                end
                local a = rngrad()
                R(6, 2, 32, 1, 0.5, 0.5, a, 0.1309,
                  cmds4(610, C40(-1.5708, 2.0), spin4(-0.0261799, 120, 1)))
                task.Wait(4)
                a = a + 0.0654498
                R(6, 2, 32, 1, 1.0, 0.5, a, 0.1309,
                  cmds4(610, C40(1.5708, 1.7), spin4(0.0261799, 120, 1)))
                task.Wait(4)
                a = a + 0.0654498
                R(6, 2, 24, 1, 1.5, 0.5, a, 0.1309,
                  cmds4(610, C40(-1.5708, 1.4), spin4(-0.0392699, 120, 1)))
                task.Wait(4)
                a = a + 0.0654498
                R(6, 2, 24, 1, 2.0, 0.5, a, 0.1309,
                  cmds4(610, C40(1.5708, 1.1), spin4(0.0392699, 120, 1)))
                ---★原作那两条 `RING_ABS 6:2 24 3 … [skip=0x04]`（Hard）与
                ---`… 24 4 … [skip=0x08]`（Lunatic）是**二选一**，L 行只出后者。
                R(6, 2, 24, 4, 3.5, 0.5, a, -0.0654498,
                  cmds4(66, C40(2.24399, 2.1)))
                a = rngrad()
                task.Wait(60)
                R(6, 6, 32, 1, 0.5, 0.5, a, 0.1309,
                  cmds4(610, C40(1.5708, 2.0), spin4(0.0523599, 120, 1)))
                task.Wait(4)
                a = a - 0.0654498
                R(6, 6, 32, 1, 1.0, 0.5, a, 0.1309,
                  cmds4(610, C40(-1.5708, 1.7), spin4(-0.0523599, 120, 1)))
                task.Wait(4)
                a = a - 0.0654498
                R(6, 6, 32, 1, 1.5, 0.5, a, 0.1309,
                  cmds4(610, C40(1.5708, 1.4), spin4(0.0314159, 120, 1)))
                task.Wait(4)
                a = a - 0.0654498
                R(6, 6, 32, 1, 2.0, 0.5, a, 0.1309,
                  cmds4(610, C40(-1.5708, 1.1), spin4(-0.0314159, 120, 1)))
                ---同上：L 行只出 `[skip=0x08]` 的 24 4 那一条。
                R(6, 6, 24, 4, 3.5, 1.5, a, 0.0654498,
                  cmds4(66, C40(-2.24399, 2.1)))
            end
            ---原作 sub50（Lunatic 行）：12 组 `3:10` 扇 + 每拍一声弹音。
            local function fan5()
                for _, d in ipairs({ 0, 2.0944, -2.0944 }) do
                    for n = 1, 4 do
                        shoot6(self, 0, 0, 64, 3, 10, n, 1, 1.3 - 0.3 * (n - 1), 0.5,
                               d, 0.261799, accel6(0.0255556, 90), false)
                    end
                end
                sound4(self)
            end
            task.Wait(60)                         -- 原作 sub49 t=60 才 SUB_CALL 51
            rings()                              -- 开场 SUB_CALL 51（164 帧，t=60..224）
            task.Wait(120)                        -- 到 t=180 的空档
            while true do
                drift(self, 1.5, 60)
                task.Wait(60)
                fan5()                            -- 墙钟 344
                task.Wait(1)                      -- SUB_CALL 50 阻塞的 1 帧
                drift(self, 1.5, 60)
                task.Wait(60)
                fan5()                            -- 墙钟 405
                task.Wait(1)
                drift(self, 1.5, 60)
                task.Wait(60)
                fan5()                            -- 墙钟 466
                task.Wait(1)
                task.Wait(60)                     -- t=420 MOVE_POS_TIME 60 4 192 80
                bmove(self, 60, 4, 0, 144)
                task.Wait(60)                     -- t=480 SUB_CALL 51 + INC i2_3
                rings()
                task.Wait(120)                    -- JUMP t:=60 → t=180 的空档
            end
        end)
    end, { skin = skin2, enter = enter2 })

    ---──────────────────── 式符「飛翔晴明」 ────────────────────
    ---原作 sub56/57：本体 DISABLE_MOVEMENT_BOUNDS 后在五角形五个顶点间瞬移
    ---（每段 MOVE_POS_TIME 10 帧），到一点就放一通渐开扇弹幕（sub57），
    ---两趟之后回场中央，再从头循环。逐条墙钟（解释器实测，同一循环 520 帧）：
    ---  f=120 循环头 SUB_CALL 2（gi0=30 ⇒ 冻结 120 帧）→ f=240 起
    ---  f=250/260/270/280/290 第 1 趟五个顶点各一发，
    ---  MOVE_POS_TIME 50 回场中央到 f=340；又 SUB_CALL 2（120 帧）
    ---  → f=470/480/490/500/510 第 2 趟（顺序 P4/P3/P2/P1/P5），
    ---  MOVE_POS_TIME 50 + t=400..480 的收尾 ≈ 130 帧，再 JUMP 回 t=240。
    ---（原作每个 t=240/t=380 还 SPAWN_ENEMY_REL 62 生一只 ANM 12 的演出对象 ——
    --- 纯贴图+拖尾（SET_IS_HITTABLE 0、无发弹），本仓库无对应资源，故省略；它不影响
    --- 任何弹/判定，只少一层光环特效。sub58/59/60/61 同理。）
    ---TH07 顶点 → 我们口径（x−192、224−y）：
    ---  P1 (135.573,205.666)→(-56.427, 18.334)  基准角 2.19911
    ---  P2 (283.301, 98.334)→( 91.301,125.666)  基准角 -0.314159
    ---  P3 (100.699, 98.334)→(-91.301,125.666)  基准角 -2.82743
    ---  P4 (248.427,205.666)→( 56.427, 18.334)  基准角 0.942478
    ---  P5 (192, 32)→(0,192)                    基准角 -1.5708
    ---sub57：朝基准角打 1/2/3/4/5 发渐开扇（起始速度 gF1=2.2 或 1.8、每段 −0.3、
    ---半张角 22.5°），第 2、3 段之间补一圈 16 发 × 2 层（1.6→0.5）。
    ---环的色档取 gI0（一趟 6/2/6/2/6，二趟 6/2/6/2/6）。
    scard("式符「飛翔晴明」", 4463, 45, 3300, false, function(self)
        task.New(self, function()
            self._box = nil                 -- 原作 t=240 的 DISABLE_MOVEMENT_BOUNDS
            local P = { { -56.427, 18.334 }, { 91.301, 125.666 },
                        { -91.301, 125.666 }, { 56.427, 18.334 }, { 0, 192 } }
            local A = { 2.19911, -0.314159, -2.82743, 0.942478, -1.5708 }
            local G = { 6, 2, 6, 2, 6 }
            ---原作 sub57：a1 基准角、v0 起始速度、col 环的色档（gI0）。
            local function sub57(a1, v0, col)
                local v = v0
                fan4(self, self.x, self.y, 6, 6, 1, 1, v, 0.5, a1, 0.392699)
                v = v - 0.3
                fan4(self, self.x, self.y, 6, 2, 2, 1, v, 0.5, a1, 0.392699)
                v = v - 0.3
                ---这一圈原作读的是未初始化的 lf0（恒 0），整圈的相位本就不影响形状。
                ring4(self, self.x, self.y, 6, col, 16, 2, v, 0.5, 0, 0.1309)
                fan4(self, self.x, self.y, 6, 6, 3, 1, v, 0.5, a1, 0.392699)
                v = v - 0.3
                fan4(self, self.x, self.y, 6, 2, 4, 1, v, 0.5, a1, 0.392699)
                v = v - 0.3
                fan4(self, self.x, self.y, 6, 6, 5, 1, v, 0.5, a1, 0.392699)
                sound4(self)        -- 第 5 发的 flags=512（0x200）⇒ 响一声
            end
            local function pass(ord, v0)
                for i = 1, 5 do
                    local k = ord[i]
                    bmove(self, 10, 4, P[k][1], P[k][2])
                    task.Wait(10)
                    sub57(A[k], v0, G[i])
                end
                bmove(self, 50, 4, 0, 96)
                task.Wait(50)
            end
            ---原作 SUB_CALL 2（sub56 里 gi0=30 / gi1=4）：音效 + 每 4 帧一发粒子、
            ---共 30 发，把调用方冻结 30×4 = 120 帧（本文件统一按 PlaySound + 等 120 帧建模）。
            local function sub2()
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
            end
            task.Wait(120)              -- 原作 t=0..120 的 MOVE_POS_TIME 120（enter1b 同帧）
            while true do
                sub2()                  -- 原作循环头 f=120 SUB_CALL 2
                pass({ 1, 2, 3, 4, 5 }, 2.2)
                sub2()                  -- 原作 f=340 SUB_CALL 2
                pass({ 4, 3, 2, 1, 5 }, 1.8)
                PlaySound("power0", 0.35, self.x / 256)
                                        -- ↑ 原作 t=390 的第三次 SUB_CALL 2（gi0=10 / gi1=8 ⇒ 40 帧）
                task.Wait(80)           -- 原作 t=400..480（RUN_EX_INS / JUMP 回 t=240）
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1b })

    ---──────────────────── 陰陽「晴明大紋」 ────────────────────
    ---原作 sub58/59（Lunatic 在 sub58 的 JNEQ *DIFF 2 分支；tail 从 t=240 起）：
    ---与「飛翔晴明」同一套五角形瞬移＋弹幕，但每点打 1..6 发渐开扇
    ---（2.0/1.7/1.4/1.1/0.8/0.5、半张角 22.5°）＋一圈 24 发 × 2 层（1.5→0.5），
    ---色档 = 该趟的 gI0（一趟 8、二趟 4）；第 6 发的 flags=0x2200 带 0x200 ⇒ 响一声。
    ---逐条墙钟（解释器实测，同一循环 550 帧）：
    ---  f=120 循环头 SUB_CALL 2（gi0=30 ⇒ 冻结 120 帧）→ f=250..290 第 1 趟，
    ---  MOVE_POS_TIME 50 回场中央（第 20 帧、即 f=310 生两只 sub60 式神）到 f=340；
    ---  t=340 RUN_EX_INS；t=380 又 SUB_CALL 2（120 帧）→ f=510..550 第 2 趟
    ---  （顺序 P4/P3/P2/P1/P5；第 20 帧 f=570 生两只 sub61），
    ---  t=480 RUN_EX_INS + t=500 OP0/INIT_BULLET_CMD ⇒ 到 f=670 JUMP 回 t=240。
    ---两趟之间（本体回场中央时）各放两只绕 spawn 点公转的「式神」（sub60/61）：
    ---出生时从本体 context 继承 gf0（随机角）/gf1（±0.0314159 角速度）/gf2=1；
    ---MOVE_ORBIT 半径 0→每帧 +1、角度每帧 ±0.0314159；t=120 起半径冻结，
    ---并连续 40 拍、每拍 3 帧：角速度再 += gf1/30，压一颗 0x20 自旋弹（±0.0261799），
    ---sub60 每拍 3 发（速度 rand[1.2,1.4]；0x04/0x08 两行同值，只发一条）、
    ---sub61 每拍 5 发[1.2,1.8]（L 行；H 行是 2 发[1.2,1.4]），
    ---全部 sprite `1:6`、flags 546（0x200 响一声 + 0x20 自旋 + 0x2 快生特效）；t=240 自毁。
    scard("陰陽「晴明大紋」", 4464, 50, 3600, false, function(self)
        task.New(self, function()
            self._box = nil                 -- 原作 t=240 的 DISABLE_MOVEMENT_BOUNDS
            local P = { { -56.427, 18.334 }, { 91.301, 125.666 },
                        { -91.301, 125.666 }, { 56.427, 18.334 }, { 0, 192 } }
            local A = { 2.19911, -0.314159, -2.82743, 0.942478, -1.5708 }
            ---原作 sub59：a1 基准角、col 色档（gI0 = 一趟 8 / 二趟 4）。
            ---sub59 开头还 INIT_BULLET_CMD 0 8192 0 300 -1 -1 -1（0x2000 spawn-delay 300，
            ---让这圈弹 300 帧内不因出界被回收）；本框架没有该口径，故略（见差异 33 同族）。
            ---所有 SPREAD_ABS/RING_ABS 的 sprite offset 字段都是 `6:*i3_0`（不是常数 6），
            ---即扇和圈**共用**当趟的 gI0（8 / 4）。
            local function sub59(a1, col)
                for n = 1, 6 do
                    fan4(self, self.x, self.y, 6, col, n, 1, 2.0 - 0.3 * (n - 1), 0.5,
                         a1, 0.392699)
                end
                ring4(self, self.x, self.y, 6, col, 24, 2, 1.5, 0.5, 0, 0.1309)
                sound4(self)        -- 第 6 发的 flags=0x2200 带 0x200
            end
            ---原作 sub60/sub61：一对绕本体公转的式神（相位差 π，由 sub58 的
            ---SPAWN_ENEMY_REL 生出并继承本体 context 的 gf0/gf1/gf2）。
            ---av = gf1 = ±0.0314159（公转角速度）、avb = 弹的 0x20 自旋 ±0.0261799。
            local function shiki(av, avb, is61)
                local cx, cy = self.x, self.y
                local a0 = ran:Float(-PI, PI)
                local cmd = spin4(avb, 60)
                ---op72 RANDOM：每发随机方向 rand[−π,π) + 随机速度 rand[v2,v1]。
                ---★原作 op72 逐发抽的随机数顺序是**先角度后速度**（vm 桩件
                ---`RANDOM` 也是先 frange(a1−a2) 再 frange(v1−v2)）；这里必须同序，
                ---否则随机流错位。
                local function rnd(o, n, v1, v2)
                    for _ = 1, n do
                        local th = rngrad()
                        local v = ran:Float(v2, v1)
                        dot4(o.x, o.y, 1, 6, v, th, cmd)
                    end
                end
                for k = 0, 1 do
                    pspawn(cx, cy, function(o)
                        local th, r, avv = a0 + k * PI, 0, av
                        for _ = 1, 120 do                  -- MOVE_ORBIT：半径 +1、角 +av
                            r = r + 1
                            th = th + avv
                            o.x, o.y = cx + math.cos(th) * r, cy - math.sin(th) * r
                            task.Wait(1)
                        end
                        local av0 = av / 30             -- ADD_FLOAT ORBAV + gf1/30
                        for _ = 1, 40 do                -- 40 拍、每拍 3 帧 = 120 帧
                            avv = avv + av0
                            ---★原作同样是**难度二选一**：sub60 的 #18(0x04)/#19(0x08) 都是
                            ---3 发[1.2,1.4]（只发一条）；sub61 的 #17(0x04)=2 发[1.2,1.4]、
                            ---#18(0x08)=5 发[1.2,1.8]。本卡走 L 行 ⇒ sub60 3 发、sub61 5 发。
                            if is61 then
                                rnd(o, 5, 1.8, 1.2)
                            else
                                rnd(o, 3, 1.4, 1.2)
                            end
                            sound4(o)                   -- flags 546 的 0x200
                            for _ = 1, 3 do
                                th = th + avv
                                o.x, o.y = cx + math.cos(th) * r, cy - math.sin(th) * r
                                task.Wait(1)
                            end
                        end
                    end)
                end
            end
            local function pass(ord, col, onCenter)
                for i = 1, 5 do
                    local k = ord[i]
                    bmove(self, 10, 4, P[k][1], P[k][2])
                    task.Wait(10)
                    sub59(A[k], col)
                end
                bmove(self, 50, 4, 0, 96)
                task.Wait(20)
                if onCenter then onCenter() end
                task.Wait(30)
            end
            ---原作 SUB_CALL 2（sub58 的 gi0=30 ⇒ 冻结 120 帧：音效 + 粒子）。
            local function sub2()
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
            end
            task.Wait(120)              -- 原作 t=0..120 的 MOVE_POS_TIME 120（enter1b 同帧）
            while true do
                sub2()                  -- 原作循环头 f=120 SUB_CALL 2
                pass({ 1, 2, 3, 4, 5 }, 8,
                     function() shiki(0.0314159, 0.0261799, false) end)
                task.Wait(40)           -- 原作 t=340..380 的 RUN_EX_INS 空档
                sub2()                  -- 原作 t=380 SUB_CALL 2
                pass({ 4, 3, 2, 1, 5 }, 4,
                     function() shiki(-0.0314159, -0.0261799, true) end)
                task.Wait(70)           -- 原作 t=480..550（RUN_EX_INS / OP0 / JUMP）
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1b })

    ---──────────────────── 橙 非符 3（原作 sub53 的循环 = 54/55/55/55/54） ────────────────────
    ---原作 sub53：`SET_LIFE 13000`、`SET_TIMER_CALLBACK_THRESHOLD 2700`。开场 t=120
    ---`SUB_CALL 54`（84 帧），到 t=240 进入循环；循环里三段 `MOVE_DIR_TIME 60 4 f0 2`
    ---（每段前一次 sub55），第四段 `MOVE_POS_TIME 60 4 192 80`（我们 (0,144)），
    ---t=540 `SUB_CALL 54` + `INC i2_3` 后 `JUMP t:=120` ⇒ 到 t=240 再空 120 帧。
    ---  · sub54（84 帧，t=0..84）：8 圈 + 4 圈，count1 依次读 i3/i2（sub54 在 t=0 把
    ---    i3 定成 24、i2 定成 28）⇒ 24/28/24/28 与 24/28/24/28；
    ---    贴图前四圈 `3:2`+`6:2`、后四圈 `3:6`+`6:6`；基准角每圈 ±0.0654498。
    ---    `3:x` 圈带 0x40（120 帧刹停→拐 ±1.5708→复速 2.0 / 1.4，flags 578）；
    ---    `6:x` 圈带 0x80（120 帧刹停→转向自机→复速 3.0 / 2.2，flags 642）；
    ---    每段末再补 `2:x` 的 20×3（3.0→0.5）与 32×5（3.4→0.5）（flags 2，无指令）。
    ---  · sub55：`INIT_BULLET_CMD 0 16 0 120 -1 0.016 1.5708`（0x10 指令，**固定**朝
    ---    1.5708 弧度加速 0.016/帧）后一发 `RANDOM`（op72）弹云：贴图 `1:gi0`、
    ---    count1 = gi1+22（sub55 里先 −16 再 +16、再 +22）、方向 rand[−π,π)、
    ---    速度 rand[0.2,1.4]，flags 531（响一声）。三次 gi0/gi1 = (12,16) / (13,40) / (14,52)。
    ncard("橙 非符 3", 4465, 13000, 1300, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            ---原作 sub54 的一整段（84 帧）。
            local function rings()
                local function C40(th, sp)
                    return { type = 0x40, flag = 0, dur = 120, loop = 1,
                             angle = -th * RAD2DEG, speed = sp }
                end
                local function C80(sp)
                    return { type = 0x80, flag = 0, dur = 120, loop = 1,
                             angle = 0, speed = sp }
                end
                local a = rngrad()
                ring4(self, self.x, self.y, 3, 2, 24, 1, 0.5, 0.5, a, 0.1309,
                      cmds4(578, C40(-1.5708, 2.0)))              -- t=0
                task.Wait(4)
                a = a + 0.0654498
                ring4(self, self.x, self.y, 6, 2, 20, 1, 1.0, 0.5, 0, 0.1309,
                      cmds4(642, C80(3.0)))                       -- t=4
                task.Wait(4)
                a = a + 0.0654498
                ring4(self, self.x, self.y, 3, 2, 28, 1, 1.5, 0.5, a, 0.1309,
                      cmds4(578, C40(-1.5708, 1.4)))              -- t=8
                task.Wait(4)
                a = a + 0.0654498
                ring4(self, self.x, self.y, 6, 2, 20, 1, 2.0, 0.5, 0, 0.1309,
                      cmds4(642, C80(2.2)))                       -- t=12
                ---★原作 `RING_ABS 2:2 20 3 … [skip=0x04]`（Hard）与
                ---`RING_ABS 2:2 32 5 … [skip=0x08]`（Lunatic）二选一，只出后者。
                ring4(self, self.x, self.y, 2, 2, 32, 5, 3.4, 0.5, 0, 0.1309)
                a = rngrad()
                task.Wait(60)                                     -- t=72
                ring4(self, self.x, self.y, 3, 6, 24, 1, 0.5, 0.5, a, 0.1309,
                      cmds4(578, C40(1.5708, 2.0)))
                task.Wait(4)
                a = a - 0.0654498
                ring4(self, self.x, self.y, 6, 6, 20, 1, 1.0, 0.5, 0, 0.1309,
                      cmds4(642, C80(3.0)))                       -- t=76
                task.Wait(4)
                a = a - 0.0654498
                ring4(self, self.x, self.y, 3, 6, 28, 1, 1.5, 0.5, a, 0.1309,
                      cmds4(578, C40(1.5708, 1.4)))               -- t=80
                task.Wait(4)
                a = a - 0.0654498
                ring4(self, self.x, self.y, 6, 6, 20, 1, 2.0, 0.5, 0, 0.1309,
                      cmds4(642, C80(2.2)))                       -- t=84
                ---同上：L 行只出 `[skip=0x08]` 的 32 5 那一条。
                ring4(self, self.x, self.y, 2, 6, 32, 5, 3.4, 0.5, 0, 0.1309)
            end
            ---原作 sub55 的弹云（op72 RANDOM）：count1 = n+22，方向 rand[−π,π)、
            ---速度 rand[0.2,1.4]，每发挂 0x10「固定朝 1.5708 弧度加速 0.016/帧」。
            local function cloud(col, n)
                ---★ `accel_angle` 在本仓是**角度制**（`cmdsub_new` 直接喂 cos/sin）；
                ---原作的 1.5708 rad 要取反再转度 = −1.5708·RAD2DEG（= −90°、正上方）。
                local cmd = { type = 0x10, flag = 0, dur = 120, loop = -1,
                              speed = 0.016, accel_angle = -1.5708 * RAD2DEG }
                for _ = 1, n + 22 do
                    ---★ 原作 sub55 就是 op72 RANDOM：逐发**先抽角、后抽速**（BulletManager.cpp:215-231）。
                    local th = rngrad()
                    local v = 0.2 + ran:Float(0, 1.2)
                    dot4(self.x, self.y, 1, col, v, th, cmds4(531, cmd))
                end
                sound4(self)
            end
            task.Wait(120)                    -- 原作 sub53 t=120 才 SUB_CALL 54
            rings()                          -- 开场 SUB_CALL 54（84 帧，t=120..204）
            task.Wait(120)                    -- 到 t=240（原作 sub53 t=120→240）
            while true do
                drift(self, 2.0, 60)
                task.Wait(60)
                cloud(12, 16)                -- t=300
                task.Wait(1)                 -- SUB_CALL 55 阻塞的 1 帧
                drift(self, 2.0, 60)
                task.Wait(60)
                cloud(13, 40)                -- t=360
                task.Wait(1)
                drift(self, 2.0, 60)
                task.Wait(60)
                cloud(14, 52)                -- t=420
                task.Wait(1)
                task.Wait(60)                -- 原作 t=420..480 的空档（三次 MOVE_DIR_TIME 都只到 t=420）
                bmove(self, 60, 4, 0, 144)   -- MOVE_POS_TIME 60 4 192 80（t=480..540）
                task.Wait(60)
                rings()                      -- t=540 SUB_CALL 54 + INC i2_3
                task.Wait(120)               -- JUMP t:=120 → t=240
            end
        end)
    end, { skin = skin2, enter = enter2 })

    ---──────────────────── 天符「天仙鳴動」 ────────────────────
    ---原作 sub64/65（L 行 = `JUMP_IF_NEQ difficulty 0` 跳去的那一支；墙钟帧用
    ---`/tmp/br34/tr.py 64` 逐帧跑出来）。
    ---入场：本体从 (192,112)（我们 (0,112)）用 120 帧 ease-out-quad 横滑到 (336,112)
    ---（我们 (144,112)）并 BEGIN_SPELLCARD；t=240（墙钟 120）起 DISABLE_MOVEMENT_BOUNDS、
    ---SET_CAN_BE_DAMAGED 1，随后 SUB_CALL 2（音效/粒子）阻塞 120 帧。
    ---t=240 之后是一条 1444 帧的循环：每段先 SET_POS 瞬移到场外端点、再直线冲出去，
    ---落点放一只「天童」（sub65：SET_EX_INS 0 = ExInsSetPosToBoss 每帧跟住本体，
    ---t=100 SET_PRIMARY_VM_INTERRUPT 1、t=140 UNIMP ⇒ 活 140 帧）。本体自己发弹：
    ---SPREAD_ABS pk=0x20001（spr 1、色档 2）的 10 连扇与 RING_ABS pk=0x20001 的整圈。
    ---  墙钟 240  天童；冲 100 帧 ease=1 到 (-224,-160)；5 发 10 连扇
    ---            a1 = 0, -0.392699, -0.785398, -1.178097, -1.570796（原作 SUB_FLOAT 递减）
    ---            a2 = 0.19635，在 240/260/280/300/320
    ---  墙钟 370  SET_POS(-224,256)；冲 60 帧 ease=0 到 (224,-160)；3 发 10 连扇
    ---            a1 = π, π+0.523599, π+1.047198（ADD_FLOAT 递增）在 370/390/410
    ---  墙钟 460  SET_POS(224,176)；冲 60 帧 ease=0 到 (-224,176)；6 盘 10 连整圈
    ---            （a1 = RAND_FLOAT_ADD(6.28319,-3.14159)）在 460..510
    ---  墙钟 530  SET_POS(-224,112)；冲 60 帧 ease=0 到 (0,112)；6 盘整圈在 530..580
    ---  墙钟 590  SUB_CALL 2（120 帧）；710 起 RUN_EX_INS ×4（ExIns 2）
    ---  墙钟 822  冲 60 帧 ease=4 到 (-144,32)；882 SUB_CALL 2 → 1002
    ---  墙钟 1002 天童；冲 100 帧 ease=1 到 (224,96)；5 发 10 连扇
    ---            a1 = 0, +0.15708, …（ADD_FLOAT）、a2 = 0.314159 在 1002..1082
    ---  墙钟 1132 SET_POS(224,0)；冲 60 帧 ease=0 到 (-224,160)；3 发 10 连扇
    ---            a1 = π, π-0.15708, π-0.314159（SUB_FLOAT）、a2 = 0.314159 在 1132..1172
    ---  墙钟 1222 SET_POS(-224,176)；冲 60 帧 ease=0 到 (224,176)；6 盘整圈在 1222..1272
    ---  墙钟 1292 SET_POS(224,112)；冲 60 帧 ease=0 到 (0,112)；6 盘整圈在 1292..1342
    ---  墙钟 1352 SUB_CALL 2 → 1472；RUN_EX_INS ×4；1584 冲 60 帧 ease=4 到 (144,112)
    ---  墙钟 1684 回到 240（周期 1444 帧）。
    scard("天符「天仙鳴動」", 4466, 60, 4000, false, function(self)
        task.New(self, function()
            task.Wait(120)
            self._box = nil                  -- 原作 t=240（墙钟 120）DISABLE_MOVEMENT_BOUNDS
            ---原作 SUB_CALL 2（sub64 的 gi0=30 ⇒ 冻结 120 帧：音效 + 粒子）。
            ---它是**循环头**（JUMP 落点是 SET_INT *gi0 30），所以每个周期都要走一遍。
            local function sub2()
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
            end
            ---jump(sx,sy)：SET_POS 到绝对点。
            local function jump(sx, sy) self.x, self.y = sx, sy end
            ---本体一次 10 连渐开扇：pk=0x20001、v1=1、v2=0.5、c2=1、flags 512（响音效）。
            local function spread(a1, a2)
                shoot6(self, 0, 0, 65, 1, 2, 10, 1, 1.0, 0.5, a1, a2, nil, true)
            end
            ---本体一圈 10 连：pk=0x20001、a1 = RAND_FLOAT_ADD(6.28319,-3.14159)、a2=0.1309。
            local function ring()
                shoot6(self, 0, 0, 67, 1, 2, 10, 1, 1.0, 0.5, rngrad(), 0.1309, nil, true)
            end
            ---「天童」（sub65）：跟住本体；t=140 UNIMP ⇒ 活 140 帧。
            local function tendou()
                pspawn(self.x, self.y, function(o)
                    for _ = 1, 140 do
                        o.x, o.y = self.x, self.y
                        task.Wait(1)
                    end
                end)
            end
            while true do
                sub2()                          -- 原作循环头 t=240 SUB_CALL 2（120 帧）
                tendou()
                bmove(self, 100, 1, -224, -160)
                for k = 0, 4 do spread(-k * 0.392699, 0.19635); task.Wait(20) end
                task.Wait(30)
                jump(-224, 256)
                tendou()
                bmove(self, 60, 0, 224, -160)
                for k = 0, 2 do spread(PI + k * 0.523599, 0.19635); task.Wait(20) end
                task.Wait(30)
                jump(224, 176)
                tendou()
                bmove(self, 60, 0, -224, 176)
                for _ = 1, 6 do ring(); task.Wait(10) end
                task.Wait(10)
                jump(-224, 112)
                tendou()
                bmove(self, 60, 0, 0, 112)
                for _ = 1, 6 do ring(); task.Wait(10) end
                task.Wait(120)          -- SUB_CALL 2（590..710）
                task.Wait(112)          -- RUN_EX_INS 之后的空档（710..822）
                bmove(self, 60, 4, -144, 32)
                task.Wait(60)
                task.Wait(120)          -- SUB_CALL 2（882..1002）
                tendou()
                bmove(self, 100, 1, 224, 96)
                for k = 0, 4 do spread(k * 0.15708, 0.314159); task.Wait(20) end
                task.Wait(30)
                jump(224, 0)
                tendou()
                bmove(self, 60, 0, -224, 160)
                for k = 0, 2 do spread(PI - k * 0.15708, 0.314159); task.Wait(20) end
                task.Wait(30)
                jump(-224, 176)
                tendou()
                bmove(self, 60, 0, 224, 176)
                for _ = 1, 6 do ring(); task.Wait(10) end
                task.Wait(10)
                jump(224, 112)
                tendou()
                bmove(self, 60, 0, 0, 112)
                for _ = 1, 6 do ring(); task.Wait(10) end
                task.Wait(120)          -- SUB_CALL 2（1352..1472）
                task.Wait(112)          -- RUN_EX_INS 之后的空档
                bmove(self, 60, 4, 144, 112)
                task.Wait(100)          -- 移动 60 帧 + 原作 t=844..884 的 40 帧空档
                                        -- （一个周期 = 1564 帧，解释器实测 label240→label240 = 1444 + 前导 120）
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1r })

    ---──────────────────── 童符「護法天童乱舞」 ────────────────────
    ---原作 sub66/67（L 行 = `JUMP_IF_NEQ difficulty 2` 跳去的那一支；墙钟用
    ---`/tmp/br34/tr.py 66` 跑）。入场与「天仙鳴動」同型（120 帧滑到 (144,112) +
    ---BEGIN_SPELLCARD；t=240/墙钟 120 起 DISABLE_MOVEMENT_BOUNDS，再 SUB_CALL 2 阻塞
    ---120 帧），之后是一条 1230 帧的循环：
    ---  墙钟 240  天童；冲 100 帧 ease=1 到 (-224,-224)；20 拍（每 5 帧）SPREAD_ABS
    ---            pk=0x60006（spr 6、色档 6）10 发、v1=1.3、a2=0.523599
    ---  墙钟 350  SET_POS(-224,256)；冲 60 帧 ease=0 到 (224,-224)；12 拍（色档 2）
    ---  墙钟 420  自机在左半场 ⇒ SET_POS(-112,256)、冲 60 帧到 (-122,-256)；否则
    ---            SET_POS(112,256)、冲 60 帧到 (122,-256)；12 拍（色档 13）
    ---  墙钟 490  SET_POS(-224,112)；冲 40 帧 ease=0 到 (0,64)；8 拍（色档 13）
    ---  墙钟 530  SUB_CALL 2（120 帧）→ 650；655..675 五盘 RING_ABS pk=0xE0006
    ---            （spr 6、色档 14）16 连：a1 起点 = RAND_FLOAT_ADD(6.28319,-3.14159)、
    ---            每盘 +0.0981748；v = 0.9/1.2/1.5/1.8/2.1（每盘 +0.3）
    ---  墙钟 675  SUB_CALL 2（120 帧）→ 795；冲 100 帧 ease=1 到 (192,-272)；20 拍（色档 6）
    ---  墙钟 905  SET_POS(-224,256)；冲 30 帧 ease=0 到 (0,64)；6 拍（色档 6）
    ---  墙钟 945  COS/SIN：MOVE_POS_TIME(60,1) 到 (380cos(angToPl), 380sin(angToPl))
    ---            （原作把极坐标当绝对目标；我们 = (380cos-192, 224-380sin)）；12 拍（色档 2）
    ---  墙钟 1015 SET_POS(224,256)；冲 30 帧 ease=0 到 (0,64)；6 拍（色档 6）
    ---  墙钟 1055 冲 60 帧 ease=1 到 (192,-272)；12 拍（色档 6）
    ---  墙钟 1125 SET_POS(-224,64)；冲 40 帧 ease=0 到 (0,64)；8 拍（色档 13）
    ---  墙钟 1165 SUB_CALL 2（120 帧）→ 1285；1290..1310 五盘 16 连整圈（a1 每盘 −0.0981748）
    ---  墙钟 1410 冲 60 帧 ease=4 回到 (144,112)；1470 回到 240（周期 1230 帧）
    ---每拍的 a1 = moveAngle + π + RAND_FLOAT_ADD(0.1309,-0.0654498)：朝「冲来的方向」。
    ---原作 moveAngle 要到该帧的移动处理结束才刷新，所以每段**第一拍**用的还是上一段的方向。
    ---「天童」sub67 与 sub65 同型但更短：t=60 SET_PRIMARY_VM_INTERRUPT 1、t=100 UNIMP。
    scard("童符「護法天童乱舞」", 4467, 60, 3600, false, function(self)
        task.New(self, function()
            task.Wait(120)
            self._box = nil                  -- 原作 t=240（墙钟 120）DISABLE_MOVEMENT_BOUNDS
            ---原作 SUB_CALL 2（sub66 的 gi0=30 ⇒ 冻结 120 帧：音效 + 粒子）。
            ---它是**循环头**（JUMP 落点是 SET_INT *gi0 30），每个周期都要走一遍。
            local function sub2()
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
            end
            ---原作 moveAngle（10045）：上一帧移动处理后的方向（我们的口径）。
            local ma = 0
            ---「天童」（sub67）：跟住本体；t=100 UNIMP ⇒ 活 100 帧。
            local function tendou()
                pspawn(self.x, self.y, function(o)
                    for _ = 1, 100 do
                        o.x, o.y = self.x, self.y
                        task.Wait(1)
                    end
                end)
            end
            ---本体一拍 = 一条 op65 SPREAD_ABS（Lunatic 行；Hard 的那条见下）。
            ---基准角 f1 = `ADD *f1 *ANG 3.14159`（#50，全难度）→ ANG + π
            ---（#51 的「再 +π」是 Hard 专属，Lunatic 不执行）+ rand[−0.0654, +0.0654)；
            ---ANG 要到该帧移动处理结束后才刷新，所以每段**第一拍**用的还是上一段的方向
            ---（`ma` 的更新时机正是照这个来）。每段开头的
            ---`INIT_BULLET_CMD 0 32 0 100 -1 0.01 ±0.0523599`（每帧转 ±3°、速度 +0.01/帧）
            ---写的命令位是 0x20，而 Lunatic 弹的 flags 是 512（无 0x20）⇒ 命令不激活。
            ---★ Lunatic 行只发**一条** op65：#55（10 发、v1=1.3、a2=0.523599、flags 512）；
            ---#54（9 发、v1=0.1、a2=0.628319、flags 544）与 #51 的「再 +π」都是 **Hard 专属**
            ---（`skip=0x04`），Lunatic 上不执行 —— 所以基准角是 ANG+π 而不是 ANG，
            ---而且 flags 512 里没有 0x20 位 ⇒ #49 的 0x20 自旋指令在 Lunatic 上根本不激活。
            local function volley(col)
                local a1 = -ma + PI + ran:Float(0, 0.1309) - 0.0654498
                shoot6(self, 0, 0, 65, 6, col, 10, 1, 1.3, 0.5, a1, 0.523599,
                       nil, true)
            end
            ---n 拍、每拍 5 帧；第一拍之后才把 ma 刷成这一段的移动方向（见上）。
            local function burst(n, col)
                for _ = 1, n do
                    volley(col)
                    local m = self._mv
                    ma = m and atan2(m.dy, m.dx) or 0
                    task.Wait(5)
                end
            end
            ---本体一盘 16 连整圈（pk=0xE0006、flags 中含 0x200 ⇒ 响音效）。
            local function ring16(a1, v)
                shoot6(self, 0, 0, 67, 6, 14, 16, 1, v, 0.5, a1, 0.1309, nil, true)
            end
            while true do
                sub2()                          -- 原作循环头 t=240 SUB_CALL 2（120 帧）
                tendou()
                bmove(self, 100, 1, -224, -224)
                burst(20, 6)                  -- 墙钟 240..340（自旋 +3°/帧）
                task.Wait(10)
                self.x, self.y = -224, 256
                tendou()
                bmove(self, 60, 0, 224, -224)
                burst(12, 2)                 -- 350..410
                task.Wait(10)
                ---原作 `JLT_F *PX 192`：自机在 TH07 的 x<192（我们 px<0）时
                ---SET_POS(304,-32)、冲向 (314,480) ⇒ 我们 (112,256)→(122,-256)。
                if player.x < 0 then
                    self.x, self.y = 112, 256
                    bmove(self, 60, 0, 122, -256)
                else
                    self.x, self.y = -112, 256
                    bmove(self, 60, 0, -122, -256)
                end
                tendou()
                burst(12, 13)                -- 420..480
                task.Wait(10)
                self.x, self.y = -224, 112
                tendou()
                bmove(self, 40, 0, 0, 64)
                burst(8, 13)                 -- 490..530
                task.Wait(120)                   -- SUB_CALL 2（530..650）
                local a1, v = rngrad(), 0.6
                task.Wait(5)                     -- 原作的 RING 在 local 295，比 ADD 晚 5 帧
                for i = 1, 5 do
                    a1, v = a1 + 0.0981748, v + 0.3
                    ring16(a1, v)                -- 655/660/665/670/675
                    if i < 5 then task.Wait(5) end
                end
                task.Wait(120)                   -- SUB_CALL 2（675..795）
                tendou()
                bmove(self, 100, 1, 192, -272)
                burst(20, 6)                  -- 795..895
                task.Wait(10)
                self.x, self.y = -224, 256
                tendou()
                bmove(self, 30, 0, 0, 64)
                burst(6, 6)                   -- 905..935
                task.Wait(10)
                ---原作 COS/SIN 后直接把 (380cos, 380sin) 当 MOVE_POS_TIME 的绝对目标。
                local ap = aimth(self)
                bmove(self, 60, 1, 380 * math.cos(ap) - 192, 224 - 380 * math.sin(ap))
                burst(12, 2)                 -- 945..1005
                task.Wait(10)
                self.x, self.y = 224, 256
                tendou()
                bmove(self, 30, 0, 0, 64)
                burst(6, 6)                   -- 1015..1045
                task.Wait(10)
                bmove(self, 60, 1, 192, -272)
                burst(12, 6)                 -- 1055..1115
                task.Wait(10)
                self.x, self.y = -224, 64
                tendou()
                bmove(self, 40, 0, 0, 64)
                burst(8, 13)                  -- 1125..1165
                task.Wait(120)                   -- SUB_CALL 2（1165..1285）
                a1, v = rngrad(), 0.6
                task.Wait(5)
                for i = 1, 5 do
                    a1, v = a1 - 0.0981748, v + 0.3
                    ring16(a1, v)                -- 1290/1295/1300/1305/1310
                    if i < 5 then task.Wait(5) end
                end
                task.Wait(100)                   -- 1310..1410
                bmove(self, 60, 4, 144, 112)
                task.Wait(60)                    -- 1470 = 下一周期的 240（周期 1230 帧）
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1r })

    ---──────────────────── 仙符「屍解永遠」（原作 sub68/69，E/N 行） ────────────────────
    ---原作 sub68 是本体主 sub53 用 `SET_LIFE_CALLBACK_SUB` 按难度点名挂上去的
    ---（sub53 #10/#11：d=3 = Easy/Normal 点 sub64、d=12 = Hard/Lunatic 点 sub66
    ---「護法天童乱舞」）⇒ 这是一张 **E/N 专属**卡；按本文件口径取**能拿到的最高行**
    ---＝ Normal 行（sub69 的 `SET_INT li1 11`，skip=0x02）。墙钟帧用
    ---`/tmp/br34/tr.py 68 <n> 1`（difficulty 1 = Normal）逐帧跑出来。
    ---
    ---入场：本体接上一张卡停在 (336,112)（我们 (144,112)），墙钟 10 起
    ---`MOVE_POS_TIME(120, ease 4, 192, 112)` 横滑回场中央 (192,112)（我们 (0,112)）。
    ---同一批指令（sub68 t=130 那一支）里还有 BEGIN_SPELLCARD、SET_CAN_BE_DAMAGED 0、
    ---SET_TIMER_CALLBACK_THRESHOLD 2700、SET_SHOOT_OFFSET 0。墙钟 130（原作 t=250）：
    ---SET_CAN_BE_DAMAGED 1 + SET_INVINCIBILITY_TIMER 300，然后进循环。
    ---
    ---循环（周期 180 帧）：本体被两条 `INIT_INTERP`（fn 7 = MathCubicInterp、180 帧、
    ---easing 0）牵着在场上无规则游走 —— X 目标 ∈ [128,256]、Y 目标 ∈ [32,160]
    ---（TH07 绝对坐标；我们 x−192 / 224−y）、两端切线各 ±144。每 180 帧重掷一次：
    ---重掷时 p0 冻结成**当时的位置**、并把上一条的**末切线**留作下一条的**首切线**
    ---（C1 连续）；两条插值都直接写 POS_X/POS_Y（EclManager.cpp:2225 那段），所以本体
    ---真的在动、弹也从当前位置出膛。同一循环里每 30 帧调一次 sub69、共 6 次，然后重掷
    ---⇒ 每 180 帧 6 拍齐射。
    ---
    ---sub69（Normal 行，li1 = 11）：`RAND_SIGN_FLOAT` 掷 ±0.392699 当基准角、按符号取
    ---色档 6（≥0）/ 2（<0）、速度 `RAND_FLOAT_ADD(0.5, 3.4)`；然后 **11 次**「2 发一对
    ---（RING_ABS count1=2、相隔 180°）」：基准角每拍 +π/22、速度每拍 −3/11；再 **11 次**：
    ---基准角继续 +π/22、速度每拍 +3/11 加回来（DEC_JUMP 先减后跳、计数到 0 不跳 ⇒ 恰好
    ---li1 次）。弹型 spr 6、flags 512 ⇒ 每帧响一次音效（sound4 去重）。
    scard("仙符「屍解永遠」", 4468, 45, 3200, false, function(self)
        task.New(self, function()
            self._box = nil                  -- 原作承接 sub64 的 DISABLE_MOVEMENT_BOUNDS
            task.Wait(10)                    -- 原作 sub68 t=130 那一支在墙钟 10 执行
            bmove(self, 120, 4, 0, 112)      -- MOVE_POS_TIME(120, ease 4, 192, 112)
            task.Wait(120)                   -- 墙钟 130（原作 t=250）：SET_CAN_BE_DAMAGED 1
            ---一次 sub69（Normal 行）：22 拍「2 发一对」。
            local function volley()
                local a = rnd_sign() * 0.392699
                local col = (a >= 0) and 6 or 2
                local v = 3.4 + ran:Float(0, 0.5)
                local da, dv = PI / 22, 3 / 11
                for _ = 1, 11 do
                    shoot6(self, 0, 0, 67, 6, col, 2, 1, v, 0.5, a, 0.1309, nil, true)
                    a, v = a + da, v - dv
                end
                for _ = 1, 11 do
                    shoot6(self, 0, 0, 67, 6, col, 2, 1, v, 0.5, a, 0.1309, nil, true)
                    a, v = a + da, v + dv
                end
            end
            ---原作 t=250 的首次重掷：X/Y 目标各掷一次、两条新切线也当场掷（±144）。
            local x0, tx = self.x, ran:Float(128, 256) - 192
            local mx0, mx1 = rnd_sign() * 144, rnd_sign() * 144
            local y0, ty = self.y, 192 - ran:Float(0, 128)
            local my0, my1 = -rnd_sign() * 144, -rnd_sign() * 144
            while true do
                local nf = 0
                for _ = 1, 6 do
                    volley()                             -- 原作 SUB_CALL 69
                    for _ = 1, 30 do
                        nf = nf + 1
                        local t = min(nf, 180) / 180
                        self.x = hermite(t, x0, tx, mx0, mx1)
                        self.y = hermite(t, y0, ty, my0, my1)
                        task.Wait(1)
                    end
                end
                ---原作 t=280 的重掷：p0 = 当前的位置、首切线 = 上一条的末切线。
                x0, tx = self.x, ran:Float(128, 256) - 192
                mx0, mx1 = mx1, rnd_sign() * 144
                y0, ty = self.y, 192 - ran:Float(0, 128)
                my0, my1 = my1, -rnd_sign() * 144
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1c })

    ---──────────────────── 方符「奇門遁甲」 ────────────────────
    ---原作 sub75/73/74：本体在 180 帧的 Hermite 插值里移动到新的奇门中心
    ---（fn 7 = MathCubicInterp、easing 0 线性；X 目标 = rand(0,128)+128 ∈ [128,256]、
    ---Y 目标 = rand(0,128)+32 ∈ [32,160] 的绝对值，两条切线各 ±144；重掷时
    ---`SET_FLOAT f3_2 f2` 把上一条的末切线留作下一条的首切线 ⇒ C1 连续）。
    ---到位期间在四个基准角（0°/45°/90°/135°）各放一扇「奇门」；每 30 帧一轮
    ---（DEC_JUMP t=160 → 跳回 t=130，`SET_INT i2_0 6` ⇒ 一轮 6 次），
    ---6 轮（=180 帧）之后才在 t=160 的块里重掷中心（外层 JUMP 回到 632）。
    ---奇门 = sub74（从基准角起每 15° 一对、共 12 对，速度 1.5+rand(0,0.5)，
    ---先 −1/6×6 再 +1/6×6，色档 6 / 10；RING_ABS flags=528）或
    ---sub73（每 10° 一对、共 18 对，速度 1.5+rand(0,0.5)，先 −2/9×9 再 +2/9+1/9 各 9 次，
    ---色档 8；flags=512）。每一对 = 2 发相隔 180°。
    ---★ sub74 刷第一扇前 `INIT_BULLET_CMD 0 16 0 90 -1 0.0222222 -999`（0x10 加速，
    ---90 帧内沿出生朝向给速度 +2.0）。但 RING_ABS 每次都会把 `bulletProps->flags`
    ---**整个覆盖**成自己的 arg7（EclManager.cpp:1313），所以只有 sub74 那些
    ---flags 带 0x10（528=0x210）的弹会激活这条指令；sub73 的 flags=0x200
    ---在 `RunCommands` 里 `moreFlags & type == 0` 直接跳过 ⇒ **不吃加速**。
    scard("方符「奇門遁甲」", 4469, 45, 3600, false, function(self)
        ---★ sub66（妖蝶？）在 t=240 已经 `DISABLE_MOVEMENT_BOUNDS`，而
        ---`SET_LIFE_CALLBACK_SUB 75` 接在同一条链上（sub75 自己从不重开边界）
        ---⇒ 本卡全程 **没有**移动边界（`HandleLifeCallback` 不重置它）。
        ---原来照抄 sub53 的 `SET_MOVEMENT_BOUNDS(32,48,352,128)` 是错的：
        ---会把本体钳在 y≤128，而原作允许它压到场中央以下（y 最大到 ≈161），
        ---弹幕从本体发射的位置也跟着差一整段（墙钟 370/400/430/460/880/1390/1420）。
        ---同链的 H 行卡 4471（sub70）在本文件里已经是 `_box = nil`。
        self._box = nil
        task.New(self, function()
            local acc = accel6(0.0222222, 90)
            local function gate74(base, col)
                local v = 1.5 + ran:Float(0, 0.5)
                for _ = 1, 6 do
                    ring4(self, self.x, self.y, 6, col, 2, 1, v, 0.5, base, 0.1309, acc)
                    base, v = base + 0.261799, v - 0.166667
                end
                for _ = 1, 6 do
                    ring4(self, self.x, self.y, 6, col, 2, 1, v, 0.5, base, 0.1309, acc)
                    base, v = base + 0.261799, v + 0.166667
                end
            end
            local function gate73(base, col)
                ---原作 sub73 逐条：
                ---  #1 `RAND_FLOAT_ADD f1 0.5 2.8` [skip 0x04 = 仅 H] / #2 `… 0.5 1.5` [仅 L]
                ---     ——两条是**不同难度行**，L 上只跑 #2 ⇒ f1 = 1.5 + rand(0,0.5)。
                ---  #4 `RING_ABS 6:*i3_0 2 1 *f1 0.5 *f0 0.1309 512`；#5 `f0 += 0.174533`（10°）。
                ---  #6 `SUB_FLOAT f1 0.222222` [仅 H] / #7 `… 0.111111` [仅 L] ⇒ **L 上每拍只减
                ---     0.111111**（H 才是 0.222222，E/N 不减）。第二段 #12/#13 同理只加 0.111111。
                ---此前把两条难度行当成「连续两条」叠成 0.333333，速度会一路掉到 ≈0.08
                ---（近乎静止的弹永不离开场地）⇒ 同屏假性顶到 1024、后面整片波被丢掉。
                local v = 1.5 + ran:Float(0, 0.5)
                for _ = 1, 9 do
                    ring4(self, self.x, self.y, 6, col, 2, 1, v, 0.5, base, 0.1309)
                    base, v = base + 0.174533, v - 0.111111
                end
                for _ = 1, 9 do
                    ring4(self, self.x, self.y, 6, col, 2, 1, v, 0.5, base, 0.1309)
                    base, v = base + 0.174533, v + 0.111111
                end
            end
            task.Wait(130)              -- 原作 t=10 起算：t=130 才掷随机并开始奇门循环
            local tx = ran:Float(0, 128) + 128 - 192
            local ty = 192 - ran:Float(0, 128)
            local mx0, mx1 = rnd_sign() * 144, rnd_sign() * 144
            local my0, my1 = -rnd_sign() * 144, -rnd_sign() * 144
            while true do
                local x0, y0 = self.x, self.y
                local nf = 0
                for _ = 1, 6 do
                    gate74(0, 6)
                    gate73(0.785398, 8)
                    gate74(1.5708, 10)
                    gate73(2.35619, 8)
                    for _ = 1, 30 do
                        nf = nf + 1
                        local t = nf / 180
                        self.x = hermite(t, x0, tx, mx0, mx1)
                        self.y = hermite(t, y0, ty, my0, my1)
                        task.Wait(1)
                    end
                end
                ---原作 t=160 的重掷：p0 = 当前位置、首切线 = 上一条的末切线。
                tx, mx0 = ran:Float(0, 128) + 128 - 192, mx1
                mx1 = rnd_sign() * 144
                ty, my0 = 192 - ran:Float(0, 128), my1
                my1 = -rnd_sign() * 144
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1b })

    ---════════════════════════════════════════════════════════════════════
    ---以下：补齐「原作只在非 Lunatic 行出现」的符卡。这些 sub 的
    ---`JUMP_IF_NEQ a=difficulty` 链里没有 Lunatic 那一段（子机型的钟点卡则是 H
    ---分支），所以前面几批按「只取 Lunatic 行」筛选时整张漏掉了。原作本体同样是靠
    ---`SET_LIFE_CALLBACK_SUB` 按难度点名才把不同的 sub 挂上去的
    ---（stage1 sub39、stage2 sub40/66、stage3 sub36/37、stage4 sub53/68）。
    ---口径同前：拿得到的**最高难度行**（E/N ⇒ N 行、只到 H ⇒ H 行），名字照那一行。
    ---  stage1 sub48  冬符「フラワーウィザラウェイ」   （E/N；id 4457）
    ---  stage2 sub44  仙符「鳳凰卵」                   （E/N；id 4470）
    ---  stage2 sub70  鬼符「鬼門金神」                 （H；  id 4471）
    ---  stage3 sub46  紅符「紅毛の和蘭人形」           （E/N；id 4439）
    ---  stage3 sub50  闇符「霧の倫敦人形」             （E/N；id 4472）
    ---  stage3 sub52  廻符「輪廻の西蔵人形」           （H；  id 4473）
    ---  stage4 sub127 弦奏「グァルネリ・デル・ジェス」 （E/N；id 4475）
    ---  stage4 sub132 合葬「プリズムコンチェルト」     （E/N；id 4476）
    ---════════════════════════════════════════════════════════════════════

    ---──────────────────── 冬符「フラワーウィザラウェイ」（原作 sub48/49/50，E/N 行） ────────────────────
    ---取 N 行（这张符卡原作只有 Easy/Normal 两行，`JNEQ $DIFF` 链在 L 直接跳过）。
    ---  · sub48：t=0 `MOVE_POS_TIME 120 4 192 112`（我们 (0,112)）；主循环 **1090 帧**：
    ---      t=240  gF0=0      gF1=+0.0523599 gF2=5 gI0=5 → SUB_CALL 49
    ---      t=340  gF0=π      gF1=−0.0523599 gF2=5 gI0=5 → SUB_CALL 49
    ---      t=400  `RING_AIMED 3:6 16 2 1.5→0.8 a1=0(自机) a2=0.19635`（flags 514）
    ---      t=450  gF0=−π/3    gF1=+0.0523599 gF2=5 gI0=3 → SUB_CALL 49
    ---      t=450  gF0=+π/3    gF1=−0.0523599 gF2=5 gI0=3 → SUB_CALL 49
    ---      t=530  gF0=−π/3    gF1=+0.0523599 gF2=**4** gI0=3 → SUB_CALL 49
    ---      t=530  gF0=+π/3    gF1=−0.0523599 gF2=5 gI0=3 → SUB_CALL 49
    ---      t=610  JUMP → t=240
    ---    （每次 SUB_CALL 的调用方 t 差与子程序的 120 帧都算进墙钟。）
    ---  · sub49：`PLAY_SOUND 5` ＋ 每 4 帧一发 `SPAWN_PARTICLES 17 4`、共 30 发
    ---    = **120 帧冻结**；随后按 gI0 朵花、f3_0（gF0）逐朵 += 2π/gI0（整圈均分）。
    ---  · sub50（花）：t=0 `MOVE_DIR_TIME 0 0 gF0 gF2` —— time≤0 的原作走的是
    ---    `enemy->angle = gF0; enemy->speed = gF2; moveMode = POLAR`（**不是插值**）；
    ---    再 `SET_ANGULAR_VEL gF1`（±3°/帧）、`SET_MOVE_ACCEL gF2/−180`（120 帧内匀减）。
    ---    t=120 把加速度改成 `gF2/+120`，同时进 12 拍、每 5 帧一组 3 扇（a1 = ANG+π，
    ---    ANG = 花的当前朝向）：
    ---      A `SPREAD_ABS 2:6 c1=3 1.2→0.5 a2=π/4`（flags 514，不挂指令）
    ---      B `SPREAD_ABS 2:6 c1=1 0.8  a1+π/4 a2=π/4`（flags 578）
    ---        ＋`INIT_BULLET_CMD 0x40 dur=60 loop=1 angle=−135° cmd.angle=−999`
    ---      C `SPREAD_ABS 2:6 c1=1 0.8  a1−π/2 a2=π/2`（flags 578）
    ---        ＋`INIT_BULLET_CMD 0x40 dur=60 loop=1 angle=+135° cmd.angle=−999`
    ---    （E 行把 A 的 v1 换成 1.0、且没有 B/C；这里按 N 行。）
    ---差异 66：`0x40` 的 `cmd.angle = −999` ⇒ 停下后「沿用**弹此刻**的速率」，本仓库的
    ---  TH34_cmdbullet 用 `resume_own = true` 表达。B/C 出生后以当前速率沿原方向匀减到 0
    ---  （60 帧），再拐 ±135°、以原速继续。
    ---差异 65：花是 `SET_IS_PROJECTILE 1` 的实体；pspawn 子机无判定无贴图。
    scard("冬符「フラワーウィザラウェイ」", 4457, 50, 3000, false, function(self)
        self._box = box5(32, 48, 352, 128)
        task.New(self, function()
            ---差异 66 的两段 0x40 指令（角度已按 TH07 取反换成度数）。
            local CB = { type = 0x40, dur = 60, loop = 1,
                         angle = 2.35619 * RAD2DEG, resume_own = true }
            local CC = { type = 0x40, dur = 60, loop = 1,
                         angle = -2.35619 * RAD2DEG, resume_own = true }
            ---原作 sub50：一朵花。th0 = 出发朝向、av = 角速度、v = 初速（同时是 120 帧后
            ---的恢复速度）。每帧 angle += av、speed += accel、pos += dir(angle)·speed。
            local function flower(cx, cy, th0, av, v)
                pspawn(cx, cy, function(o)
                    local th, spd, acc = th0, v, -v / 180
                    local function step(n)
                        for _ = 1, n do
                            th, spd = th + av, spd + acc
                            o.x, o.y = o.x + math.cos(th) * spd, o.y - math.sin(th) * spd
                            task.Wait(1)
                        end
                    end
                    step(120)                                -- t=0..119：减速度 −v/180
                    acc = v / 120                            -- t=120：SET_MOVE_ACCEL +v/120
                    for _ = 1, 12 do                         -- t=120、125、…、175
                        ---★ #18 `DIV_FLOAT *ANGVEL *ANGVEL 1.4` 在**每次循环里**都执行
                        ---（t=120 的 DEC_JUMP 跳回 idx18），所以角速度每拍都 ÷1.4。
                        av = av / 1.4
                        local f = th + PI
                        shoot6(o, 0, 0, 65, 2, 6, 3, 1, 1.2, 0.5, f, 0.785398, nil, false)
                        shoot6(o, 0, 0, 65, 2, 6, 1, 1, 0.8, 0.8,
                               f + 0.785398, 0.785398, CB, false)
                        ---★ #26 `SUB_FLOAT *f0 *f0 1.5708` 是在 #23 的 +0.785398 之后
                        ---再减 ⇒ 这一组的 a1 = (f+0.785398)−1.5708 = f−0.785398，
                        ---不是 f−1.5708（旧版漏了那个 +0.785398）。
                        shoot6(o, 0, 0, 65, 2, 6, 1, 1, 0.8, 0.8,
                               f + 0.785398 - 1.5708, 1.5708, CC, false)
                        step(5)
                    end
                end)
            end
            ---原作 sub49：一次 SUB_CALL 49（120 帧冻结后放 n 朵花，朝向整圈均分）。
            local function wave(th0, av, v, n)
                PlaySound("power0", 0.35, self.x / 256)
                task.Wait(120)
                PlaySound("lazer00", 0.13, self.x / 256)
                local d = 2 * PI / n
                for k = 0, n - 1 do
                    flower(self.x, self.y, th0 + k * d, av, v)
                end
            end
            task.Wait(120)                                   -- t=0 MOVE_POS_TIME 120 4 (192,112)
            ---★ 原作在**每次** SUB_CALL 49 之后、以及 t=400 的 RING_AIMED 之后，
            ---  都紧跟一条 `RAND_FLOAT_ADD *f0 6.28319 -3.14159`（结果无人读，
            ---  但必须照抽，否则整条随机流错位）。这里逐条补齐 5 次/轮。
            while true do
                wave(0, 0.0523599, 5, 5)                     -- t=240
                local _ = rngrad()                           -- 原作 #37
                task.Wait(100)                               -- t=340
                wave(PI, -0.0523599, 5, 5)
                task.Wait(60)                                -- t=400
                shoot6(self, 0, 0, 66, 3, 6, 16, 2, 1.5, 0.8, 0, 0.19635, nil, true)
                local _ = rngrad()                           -- 原作 #44
                task.Wait(50)                                -- t=450
                wave(-1.0472, 0.0523599, 5, 3)
                local _ = rngrad()                           -- 原作 #50
                wave(1.0472, -0.0523599, 5, 3)
                local _ = rngrad()                           -- 原作 #56
                task.Wait(80)                                -- t=530
                wave(-1.0472, 0.0523599, 4, 3)
                local _ = rngrad()                           -- 原作 #62
                wave(1.0472, -0.0523599, 5, 3)
                task.Wait(80)                                -- t=610 → JUMP t:=240
            end
        end)
    end, { skin = skin1, wallskin = skin1w, enter = enter1e })

    ---──────────────────── 紅符「紅毛の和蘭人形」（原作 sub46/47；L 行 = 无后缀那张） ────────────────────
    ---sub46：t=240 起本体摆到 (192,112)（我们 (0,112)），主循环一轮 **288 帧**：
    ---  · t=240 起 **7 只人形**（sub47）每 10 帧一只，x = 32,80,…,320（我们 −160…128），
    ---    y = rand(160)+32（我们 224−它），弹色档 i3_0 = 8；
    ---  · t=400 起再 7 只，每 8 帧一只，x = 352,304,…,64，y 同式，色档 i3_0 = 4；
    ---  · t=400 / t=468 各 `MOVE_DIR_TIME 60 4 GET_EXIT_ANGLE 1`；
    ---  · t=528 JUMP 回 t=240。
    ---  每只人形出生时把 `l3f3 = ±0.0218166` 翻一次符号（交替旋向）。
    ---sub47（人形）：t=60 起可打（原作 life=20、itemdrop −1、score 100）并打一圈音效；
    ---  随后 6 帧各打两圈 RING_ABS（spr2，c1 = 4 与 7、速度 = rand(0.3)+0.9、
    ---  基准角从 0 起每帧 += l3f3）；t=161 换死亡动画、t=221 自毁。
    ---差异：`pspawn` 子机无判定（原作人形可被打死），同 4431/4433/4435 口径；
    ---  原作 flags 0x3 的出生特效略。
    scard("紅符「紅毛の和蘭人形」", 4439, 60, 3600, false, function(self)
        ---一只人形（原作 sub47）。col = l3i0、step = l3f3（±0.0218166）。
        ---★ 原作的两条 `RING_ABS` 是 E 行（c1=4）/ N 行（c1=7）**二选一**，
        ---本卡取 N 行 ⇒ 每帧只有 1 环 c1=7（旧版把两条都发，变成 4+7=11 发）。
        ---★ 原作 `RAND_FLOAT_ADD *f1` 在 `DEC_JUMP` 的回跳目标上 ⇒ **每帧重掷**。
        local function doll(px, py, col, step)
            pspawn(px, py, function(o)
                task.Wait(60)
                local a = 0
                for _ = 1, 6 do
                    local v = 0.9 + ran:Float(0, 0.3)
                    ring3(o, 0, 0, 2, col, 7, 1, v, 1.5, a)
                    a = a + step
                    task.Wait(1)
                end
                task.Wait(155)                  -- t=66 → t=221 自毁
            end)
        end
        task.New(self, function()
            self._box = box5(32, 48, 352, 128)
            task.Wait(240)
            while true do
                ---(a) t=240：x = 32,80,…,320，y = rand(160)+32，色档 8。
                local s = 0.0218166
                doll(32 - 192, 224 - (ran:Float(0, 160) + 32), 8, s); s = -s
                for k = 1, 6 do
                    task.Wait(10)
                    doll(32 + k * 48 - 192, 224 - (ran:Float(0, 160) + 32), 8, s); s = -s
                end
                task.Wait(160)                  -- 原作调用方 t=240→400（含 SUB_CALL 后的 150 帧）
                drift(self, 1.0, 60)            -- t=400 MOVE_DIR_TIME(60,4,GET_EXIT_ANGLE,1)
                ---(b) t=400：x = 352,304,…,64，y = rand(160)+32，色档 4。
                ---★ 原作第二拨**不重设** lf3_3：第一拨 7 只各翻转一次，翻完停在
                ---−0.0218166，所以第二拨第一只的旋向与第一拨第一只相反（`s` 接续）。
                local t = s
                doll(352 - 192, 224 - (ran:Float(0, 160) + 32), 4, t); t = -t
                for k = 1, 6 do
                    task.Wait(8)
                    doll(352 - k * 48 - 192, 224 - (ran:Float(0, 160) + 32), 4, t); t = -t
                end
                task.Wait(68)                   -- 原作调用方 t=408→468
                drift(self, 1.0, 60)            -- t=468 MOVE_DIR_TIME(60,4,GET_EXIT_ANGLE,1)
                task.Wait(60)                   -- t=528 JUMP 回 t=240（一轮 396 帧）
            end
        end)
    end, { skin = skin3, enter = enter3b })

    ---原作 sub51 / sub53 的「人形」（闇符 / 廻符共用同一套四段循环，只有弹型与指令不同）：
    ---  · 公转：圆心 = 本体**当前**位置、半径 = 本体 ORBR、角速度 = 本体 ORBAV。
    ---    子机 t=0 一条 `MOVE_ORBIT` 只定「起始角」（继承本体写在 l3f0 的值 —— `SPAWN_ENEMY_REL`
    ---    会把调用方的 eclContextArgs 一并交给子机，EclManager.cpp:1841 / EnemyManager.cpp:116），
    ---    之后每帧 `SET_EX_INS 5`（= `ExInsCopyMainBossMovement`，EnemyEclInstr.cpp:227）
    ---    把本体的 pos / ORBR / ORBAV 抄过来；所以子机绕的是**移动中的**本体。
    ---  · 弹幕：t=0 起四段「2 发对径小环」（RING_ABS c1=2、c2=1、v1=f1、v2=1.5、a1=f0、a2=0，
    ---    环心是子机自己），每段 20 环：
    ---      段1 t=0  每 8 帧一环、f0 += 0.165347、f1 += 0.05
    ---      段2 t=8  每 8 帧一环、f0 -= 0.314159、f1 -= 0.05
    ---      段3 t=46 每 6 帧一环、f0 先归零再 += 0.314159、f1 += 0.05
    ---      段4 t=52 每 6 帧一环、f0 -= 0.314159、f1 -= 0.05
    ---    段 2→3 之间空 30 帧（段 2 的 `DEC_JUMP` 跑完停在 t=16，段 3 到 t=46 才开）；
    ---    四段跑完后 `JUMP` 回段 1（闇符回到环本身，廻符回到 t=0 的 `INIT_BULLET_CMD`）。
    ---  · 差异 21：本仓库弹工厂不认 ECL 的 spawn flags 位（原作靠 `flags & cmd.type` 决定
    ---    某段指令要不要上弹），所以这里按原作 flags 逐段挂指令：
    ---      闇符 sub51：spr2、偏 10/6/11/8；段 1/3 flags 0x202 ⇒ 无指令，
    ---                  段 2/4 flags 0x203 ⇒ 挂 `0x1` 起爆（+5 → +0.3125 /17 帧后回自身速度）；
    ---      廻符 sub53：spr6、偏 10/6/11/8；四段 flags 都是 0x222 ⇒ 每段都挂 `0x20` 自旋
    ---                  （30 帧、±0.0523599 rad/帧，段 1/3 正、段 2/4 负）。
    ---    其余 flags 位（`0x2` 快速出屏动画等）本仓库没有对应表现。
    local function kyodoll(boss, a0_th, spr, spin, kick)
        pspawn(boss.x, boss.y, function(o)
            ---★ 第 1 帧 `SET_EX_INS 5` 还没生效：子机自己的 `MOVE_ORBIT` 用 f3_1 当角速度
            ---  先转一拍（`orbitAngle += orbitAngleVel`）。TH07 里 θ 变成 θ0+f3_1，
            ---  本仓库角取反 ⇒ ang = −(θ0+f3_1) = −θ0 − kick。漏掉这 0.0523599 rad
            ---  （= 3°，半径 96 时约 5px）会让每颗弹的出膛点都偏掉。
            local ang = -(a0_th + kick)                -- 我们的弧度（TH07 角取反）
            task.New(o, function()
                while true do
                    local r = boss._kR or 0
                    o.x, o.y = boss.x + math.cos(ang) * r, boss.y + math.sin(ang) * r
                    task.Wait(1)
                    ---本体 ORBAV 是 TH07 口径，本仓库角度取反 ⇒ 每帧「减」。
                    ang = ang - (boss._kW or 0)
                end
            end)
            ---★ 这段是 `pspawn` 的**主体**：`PSCRIPT` 的包装协程在 fn 返回后会立刻
            ---`RawDel` 掉这只子机（连同它的 task），所以 fn 自己必须一直阻塞下去。
            ---f0 是**弹的基准角**，跟 ECL 一样用 TH07 弧度（shoot6 内部再取反）。
            local f0, f1 = a0_th, 1.0
            ---原作 INIT_BULLET_CMD 0 1 ... 的 `0x1` 起爆段（duration/loop 都不看）。
            local burst = { type = 1 }
            local function spin_cmd(sgn)
                return { type = 0x20, dur = 30, loop = -1, speed = 0,
                         angle = -sgn * 0.0523599 * RAD2DEG }
            end
            ---一段 20 环：每 gap 帧一环、逐环推 f0（d0）/ f1（d1）。
            local function phase(off, gap, d0, d1, cmd)
                for k = 1, 20 do
                    shoot6(o, 0, 0, 67, spr, off, 2, 1, f1, 1.5, f0, 0, cmd, true)
                    f0, f1 = f0 + d0, f1 + d1
                    if k < 20 then task.Wait(gap) end
                end
            end
            while true do
                phase(10, 8, 0.165347, 0.05, spin and spin_cmd(1) or nil)
                task.Wait(8)                           -- 段1 尾 → 段2 首
                phase(6, 8, -0.314159, -0.05, spin and spin_cmd(-1) or burst)
                task.Wait(38)                          -- 段2 尾 → 段3 首（含原作 30 帧空档）
                f0 = 0
                phase(11, 6, 0.314159, 0.05, spin and spin_cmd(1) or nil)
                task.Wait(6)                           -- 段3 尾 → 段4 首
                phase(8, 6, -0.314159, -0.05, spin and spin_cmd(-1) or burst)
                task.Wait(6)                           -- 段4 尾 → 段1 首
            end
        end)
    end

    ---──────────────────── 闇符「霧の倫敦人形」（原作 sub50/51，E/N 行） ────────────────────
    ---本体（原作 sub50 的 N 行）：`MOVE_POS_TIME 120 4 192 112` 进场 ⇒ 我们 (0,112)，
    ---t=240 起主循环（t=1123 的 `JUMP` 跳回 t=300 ⇒ 一轮 **883 帧**）：
    ---  t=240 ORBR 0→96（60 帧 ease-out-quad）、ORBAV 0→+0.0523599（60 帧线性）；
    ---  之后随机角放人形 —— 原作 `SET_INT *i0` 只有 **E 行 4 只 / N 行 7 只**两行
    ---  （skip=0x1 / 0x2），H/L 行没有这一条 ⇒ Lunatic 上 i0 保持 0，
    ---  `DEC_JUMP` 的计数为 0（体只走一遍）⇒ **只放 1 只**。本卡照 Lunatic 行。
    ---  t=301 ORBR 96→48、ORBAV +0.0523599→−0.0261799；
    ---  t=361 `GET_EXIT_ANGLE` + `MOVE_DIR_TIME(60,4,lf0,2)`；
    ---  t=421 同两条把 48 / −0.0261799 续 60 帧 + `MOVE_POS_TIME(60,4,192,128)`（我们 (0,96)）；
    ---  t=873 再漂一次；t=933 `MOVE_POS_TIME` 回中心 + ORBR 48→96、ORBAV −0.0261799→+0.0523599。
    scard("闇符「霧の倫敦人形」", 4472, 45, 2700, false, function(self)
        self._box = box5(32, 48, 352, 128)
        self._kR, self._kW = 0, 0
        task.New(self, function()
            local add, wait = kyorbit(self)
            ---原作 N 行：t=120 才开卡，t=240 `SUB_CALL 2`（gi0=30 ⇒ 120 帧）后才放人形
            ---⇒ 我们等 120（MOVE_POS_TIME）+ 120（SUB_CALL 2）= 240 帧。
            task.Wait(240)
            ---t=240：放 1 只人形（起始角 rand(0,π/4)）。原作 L 行 i0=0 ⇒ 循环体只走一遍。
            local a0 = ran:Float(0, 0.785398)
            for _ = 1, 1 do
                ---原作 sub50：`SET_FLOAT *f3_1 -0.0523599`（t=240）⇒ 第 1 帧的角速度。
                kyodoll(self, a0, 2, false, -0.0523599)
                a0 = a0 + 2 * PI / 1
            end
            add("_kR", 60, 96, 4)
            add("_kW", 60, 0.0523599, 0)
            wait(60)                           -- t=240 → t=300
            while true do
                wait(1)                        -- t=300 → t=301
                add("_kR", 60, 48, 4)
                add("_kW", 60, -0.0261799, 0)
                wait(60)                       -- t=301 → t=361
                drift(self, 2, 60)             -- GET_EXIT_ANGLE + MOVE_DIR_TIME(60,4,lf0,2)
                wait(60)                       -- t=361 → t=421
                add("_kR", 60, 48, 4)
                add("_kW", 60, -0.0261799, 0)
                bmove(self, 60, 4, 0, 96)      -- MOVE_POS_TIME(60,4,192,128)
                wait(60)                       -- t=421 → t=481
                wait(392)                      -- t=481 → t=873（原作 t=551/t=812 只是写 i2_2）
                drift(self, 2, 60)             -- 再一次 GET_EXIT_ANGLE + 漂移
                wait(60)                       -- t=873 → t=933
                bmove(self, 60, 4, 0, 96)
                add("_kR", 60, 96, 4)
                add("_kW", 60, 0.0523599, 0)
                wait(250)                      -- t=933 → 下一轮 t=300（周期 883）
            end
        end)
    end, { skin = skin3, enter = enter3c })

    ---──────────────────── 廻符「輪廻の西蔵人形」（原作 sub52/53，H 行） ────────────────────
    ---同「闇符」家族（本体 sub52），差别只在：
    ---  · 只有 6 只人形（原作 H 行 `SET_INT *i0 6`），弹型换成 spr6、四段都带 `0x20` 自旋；
    ---  · 本体**不漂移**（原作 t=241 / t=753 的 `GET_EXIT_ANGLE` 结果没人读，是死代码），
    ---    只有两次 `MOVE_POS_TIME(60,4,192,128)`；
    ---  · 主循环从 t=180 开始（t=1003 的 `JUMP` 跳回 t=180 ⇒ 一轮也是 **883 帧**），
    ---    ORBR/ORBAV 的排程与「闇符」逐帧同相（0→96、96→48、48→48、48→96）。
    scard("廻符「輪廻の西蔵人形」", 4473, 45, 2700, false, function(self)
        self._box = box5(32, 48, 352, 128)
        self._kR, self._kW = 0, 0
        task.New(self, function()
            local add, wait = kyorbit(self)
            ---原作 t=0 开卡 + `MOVE_POS_TIME 120`，t=120 `SUB_CALL 2`（gi0=30 ⇒ 120 帧）
            ---⇒ 我们等 120 + 120 = 240 帧，人形才是原作 t=120 的那批。
            task.Wait(240)
            local a0 = ran:Float(0, 0.785398)
            for _ = 1, 6 do
                ---原作 sub52：`SET_FLOAT *f3_1 -0.0523599`（t=120）⇒ 第 1 帧的角速度。
                kyodoll(self, a0, 6, true, -0.0523599)
                a0 = a0 + 2 * PI / 6
            end
            add("_kR", 60, 96, 4)
            add("_kW", 60, 0.0523599, 0)
            wait(60)                           -- t=120 → t=180
            while true do
                wait(1)                        -- t=180 → t=181
                add("_kR", 60, 48, 4)
                add("_kW", 60, -0.0261799, 0)
                wait(60)                       -- t=181 → t=241
                ---原作 t=241 的 `GET_EXIT_ANGLE *f0`：结果没人读（后面没有 MOVE_DIR_TIME），
                ---但它照样消耗一次 rand(0,π/2) ⇒ 必须照抽，否则随机流错位。
                exang(self)
                wait(60)                       -- t=241 → t=301
                add("_kR", 60, 48, 4)
                add("_kW", 60, -0.0261799, 0)
                bmove(self, 60, 4, 0, 96)      -- MOVE_POS_TIME(60,4,192,128)
                wait(60)                       -- t=301 → t=361
                wait(332)                      -- t=361 → t=693
                wait(60)                       -- t=693 → t=753
                exang(self)                    -- 原作 t=753 的 `GET_EXIT_ANGLE` 同样是死代码，仍要抽
                wait(60)                       -- t=753 → t=813
                bmove(self, 60, 4, 0, 96)      -- MOVE_POS_TIME(60,4,192,128)
                add("_kR", 60, 96, 4)
                add("_kW", 60, 0.0523599, 0)
                wait(250)                      -- t=813 → 下一轮 t=180（周期 883）
            end
        end)
    end, { skin = skin3, enter = enter3c })

    ---──────────────────── 仙符「鳳凰卵」（原作 sub44/30/31/24/25，E/N 行） ────────────────────
    ---──────────────────── 仙符「鳳凰卵」（原作 sub44／30／31／24／25，E/N 行） ────────────────────
    ---取 N 行（sub44 用 `JNEQ a=DIFF` 分岔：E 行 t=0 就开卡、N 行 t=120 才开）。
    ---时间轴：t=120 起 `MOVE_POS_TIME 120 4 192 112`（我们 (0,224)→(0,112)）+ 开卡；
    ---t=240 起 `SUB_CALL 2`（`gI0=30` ⇒ **阻塞 120 帧**的粒子/音效），随后主循环 ——
    ---t=240 放第一只凤凰火，之后按 0/10/20、100/110/120、190/200 的**墙钟**节奏各放 8 只
    ---（两次 `SUB_CALL 2` 各阻塞 40 帧 ⇒ 一轮 **210 帧**；t=370 的 `JUMP off=-432` 跳回 t=240）。
    ---凤凰火（sub30/31，life 240、无判定、OOB 自毁）：在 (192,112) 出生，180 帧里沿两条
    ---**三次 Hermite**（X/Y 各一条：出生点 → rand(64,320) / rand(32,192)，两条切线各 ±144）
    ---漂到随机点；t=180 原地放出炸环（sub24 = 30 号 / sub25 = 31 号，life 80）后自毁（t=210）。
    ---炸环（基准角 f0 = rand(−π,π) **每组共用**；弹型 spr6 → ball_small）：
    ---  ① `INIT_BULLET_CMD 0 64 0 60 1 1.5708 1`（0x40：60 帧把速度线性刹到 0 → 转 +90° →
    ---     1 px/帧复飞）⇒ sub24 打 16 发（色 2、速度 2）+ 24 发（同速）；
    ---     sub25 打 10 发（色 14、速度 2）+ 12 发（同速）；
    ---  ② `INIT_BULLET_CMD 0 64 0 60 1 −1.5708 1.8`（−90°、1.8 复飞）⇒ 同样两组、
    ---     发数相同、速度 1.4（这一对的 flags = 0x240 带 0x200 音效位）。
    ---（`SUB_CALL 2` 只是粒子 + `PLAY_SOUND 5`（= se_power0）；移植版只留音效、不画粒子。）
    scard("仙符「鳳凰卵」", 4470, 40, 3000, false, function(self)
        self._box = box5(32, 48, 352, 128)
        ---凤凰火：180 帧三次 Hermite 漂到随机点，末帧原地炸环。
        local function firebird(burst)
            local x0, y0 = self.x, self.y
            ---★ 原作 sub30 在 t=0 抽随机数的**顺序与个数**照抄（错一个整条流就位移）：
            ---  idx11 `RAND_FLOAT_ADD *f0 256 64` X 起点（随后被 idx13 `SET_FLOAT *f0 *X`
            ---        覆盖 ⇒ 死抽）、idx14 `RAND_FLOAT_ADD *f1 256 64` X 终点、
            ---  idx15/16 `RAND_SIGN_FLOAT *f2/*f3 144` X 两条切线、
            ---  idx18 `RAND_FLOAT_ADD *f0 160 32` Y 起点（死抽）、
            ---  idx21 `RAND_FLOAT_ADD *f1 160 32` Y 终点、idx22/23 Y 两条切线。
            ran:Float(0, 256)
            local tx = ran:Float(64, 320) - 192
            local mx0, mx1 = rnd_sign() * 144, rnd_sign() * 144
            ran:Float(0, 160)
            local ty = 224 - ran:Float(32, 192)
            ---我们的 y 轴和 TH07 相反，切线要跟着取反（同 sub75 的移植口径）。
            local my0, my1 = -rnd_sign() * 144, -rnd_sign() * 144
            pspawn(x0, y0, function(o)
                ---原作 sub30 在出生帧执行 t=0 的 INIT_INTERP，t=180 才 SPAWN_ENEMY_REL 24
                ---⇒ 位移第 1 拍在出生帧、炸环在出生后第 180 帧（子程先空等 1 帧）。
                task.Wait(1)
                for k = 1, 180 do
                    local u = k / 180
                    o.x = hermite(u, x0, tx, mx0, mx1)
                    o.y = hermite(u, y0, ty, my0, my1)
                    if k == 180 then burst(o) end
                    task.Wait(1)
                end
            end)
        end
        ---sub24：spr6／色 2，两组「16 + 24 发」；0x40 先 +90°（1.0 复飞）再 −90°（1.8）。
        local function burst30(o)
            local a0 = rngrad()
            local ca = { type = 0x40, dur = 60, loop = 1,
                         angle = -1.5708 * RAD2DEG, speed = 1 }
            local cb = { type = 0x40, dur = 60, loop = 1,
                         angle = 1.5708 * RAD2DEG, speed = 1.8 }
            shoot6(o, 0, 0, 67, 6, 2, 24, 1, 2, 1.5, a0, 0, ca, false)
            shoot6(o, 0, 0, 67, 6, 2, 24, 1, 1.4, 1.5, a0, 0, cb, true)
        end
        ---sub25：spr6／色 14，两组「10 + 12 发」，两条 0x40 的方向与 sub24 对调。
        local function burst31(o)
            local a0 = rngrad()
            local ca = { type = 0x40, dur = 60, loop = 1,
                         angle = 1.5708 * RAD2DEG, speed = 1 }
            local cb = { type = 0x40, dur = 60, loop = 1,
                         angle = -1.5708 * RAD2DEG, speed = 1.8 }
            shoot6(o, 0, 0, 67, 6, 14, 12, 1, 2, 1.5, a0, 0, ca, false)
            shoot6(o, 0, 0, 67, 6, 14, 12, 1, 1.4, 1.5, a0, 0, cb, true)
        end
        task.New(self, function()
            task.Wait(120)                              -- 原作 t=120 的 MOVE_POS_TIME + 开卡
            PlaySound("power0", 0.35, self.x / 256)     -- 原作 t=240 SUB_CALL 2（gI0=30）
            task.Wait(120)                              -- SUB_CALL 2：30 次 × 4 帧
            while true do
                firebird(burst30); task.Wait(10)        -- t=240 → 250
                firebird(burst31); task.Wait(10)        -- t=250 → 260
                firebird(burst30)
                PlaySound("power0", 0.35, self.x / 256) -- t=260 SUB_CALL 2（gI0=10）
                task.Wait(40)                           -- SUB_CALL 2：10 次 × 4 帧
                task.Wait(40)                           -- t=260 → 300
                firebird(burst31); task.Wait(10)        -- t=300 → 310
                firebird(burst30); task.Wait(10)        -- t=310 → 320
                firebird(burst31)
                PlaySound("power0", 0.35, self.x / 256) -- t=320 SUB_CALL 2（gI0=10）
                task.Wait(40)                           -- SUB_CALL 2：10 次 × 4 帧
                task.Wait(30)                           -- t=320 → 350
                firebird(burst30); task.Wait(10)        -- t=350 → 360
                firebird(burst31); task.Wait(10)        -- t=360 → 370（JUMP 回 t=240）
            end
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1e })

    ---──────────────────── 鬼符「鬼門金神」（原作 sub70／71／72／73，H 行） ────────────────────
    ---取 H 行（sub66 的 `SET_LIFE_CALLBACK_SUB 70` 掩码 0x04 = H；L 行才是 sub75「方符」）。
    ---时间轴：t=10 起 `MOVE_POS_TIME 120 4 192 112`（我们 (0,224)→(0,112)）+ 开卡；
    ---t=130 `SPAWN_ENEMY_REL 71`（第一只鬼火）、t=265 `SPAWN_ENEMY_REL 72`（第二只）；
    ---t=265 的 `JUMP off=-12` 只跳回**同帧的 NOP**、每 3000 帧空转一次 ⇒ 两只鬼火放下后
    ---一直在原地打（它们 CAN_DIE 0 + HAS_NO_COLLISION 1，原作里也打不掉）。
    ---鬼火（sub71 = 色 6／sub72 = 色 2）：不移动，每 **30 帧**打一轮 sub73。
    ---  基准角从 0 起，每轮 sub71 `+=` / sub72 `−=` `rand(0,0.0981748)+0.392699`（弧度）；
    ---  一轮 sub73 = 18 圈 × 2 发（对径，共 36 发）：圈间基准角 +0.174533（10°）；
    ---  速度走 H 行的掩码分支（skip=0x04）：`rand(0,0.5)+2.8` 起、每圈 −0.222222 连减 9 圈，
    ---  再 +0.222222 连加 9 圈；色档 = gI0（6 / 2）、flags = 0x200（响音效）。
    ---（18 圈在 `DEC_JUMP` 里**同一帧**打完 —— 原作 DEC_JUMP 不消耗帧。）
    scard("鬼符「鬼門金神」", 4471, 45, 3600, false, function(self)
        ---sub66 在 t=240 已经 `DISABLE_MOVEMENT_BOUNDS`（HandleLifeCallback 不重置）⇒ 无框。
        self._box = nil
        ---一只鬼火：每 30 帧按 sub73 打 18 圈（base 每轮按 sgn 推进一次）。
        local function onibi(off, sgn)
            pspawn(self.x, self.y, function(o)
                local base = 0
                while true do
                    local a, v = base, ran:Float(0, 0.5) + 2.8
                    for _ = 1, 9 do
                        shoot6(o, 0, 0, 67, 6, off, 2, 1, v, 0.5, a, 0.1309, nil, true)
                        a, v = a + 0.174533, v - 0.222222
                    end
                    for _ = 1, 9 do
                        shoot6(o, 0, 0, 67, 6, off, 2, 1, v, 0.5, a, 0.1309, nil, true)
                        a, v = a + 0.174533, v + 0.222222
                    end
                    base = base + sgn * (ran:Float(0, 0.0981748) + 0.392699)
                    task.Wait(30)
                end
            end)
        end
        task.New(self, function()
            task.Wait(130)              -- 原作 t=10 起 120 帧 MOVE_POS_TIME + 开卡
            onibi(6, 1)                 -- t=130（SPAWN_ENEMY_REL 71）
            task.Wait(135)              -- t=130 → 265
            onibi(2, -1)                -- t=265（SPAWN_ENEMY_REL 72）
            while true do task.Wait(3000) end   -- t=265 的 JUMP 只是空转回同帧 NOP
        end)
    end, { skin = skin2, wallskin = skin2w, enter = enter1e })

    ---──────────────────── 弦奏「グァルネリ・デル・ジェス」（原作 sub127 → 130 → 129） ────────────────
    ---sub127 只带 E/N 两行卡名（L 行落到 sub128 的「偽弦」），但 sub127 内**所有发弹
    ---指令都没有难度掩码**，所以这里严格照 sub127 的排版移植（= Normal 行的弹幕）。
    ---逐条照抄 `ecldata4.ecl`：
    ---  · t=0 MOVE_POS_TIME(120,4,192,80)（我们 (0,224)→(0,144)）；t=120 限位框、
    ---    SUB_CALL 2（16 帧）；t=150 起进四块循环（t=150/153/156/159）。i2_1 从 150 起
    ---    每块 −5、≤60 后冻结；块内 `i0 = i2_1/2` 作为两段 SET_WAIT_TIMER。
    ---      - 每块先 1 次（自机距离 <128 才打）SPREAD_AIMED 3:2 6 3 3.2 0.5 0 0.392699；
    ---      - 再 3 只 sub130：每 3 帧一只、f2 各 +0.785398；
    ---      - 四块 (f0, f2 的 A2P 偏移, f4, 色档) =
    ---          ( 1.5708, −1.74533, +0.015708, 2)  (−1.5708, +1.74533, −0.015708, 6)
    ---          ( 1.5708, −1.5708 , +0.015708, 6)  (−1.5708, +1.5708 , −0.015708, 2)
    ---      - t=162 `JUMP 150 -2080` 落回 instr16（SET_ANM 129）——**不重置 i2_1**，
    ---        所以各块间隔逐块缩短（9+2·⌊i2_1/2⌋ 帧）。
    ---  · sub130（音符串，共 180 帧）：以 f3=6 沿 f2 飞、自转 f4；按 i2_1 = 4,6,…,26
    ---    在自己位置放 12 只 sub129。
    ---  · sub129（音符）：以 f1=0.5 沿 f0 直线飞 120 帧；t=60 记下本体坐标、t=120
    ---    朝 ATAN2(本体→自己) 取反后打 1 发 SPREAD_ABS 3:col 1 1 1.2 0.5 f0 1.5708
    ---    （Lunatic 行；Hard 行是 8 发、E/N 行另走一支）；自机距离 ≤32 时自毁。
    scard("弦奏「グァルネリ・デル・ジェス」", 4475, 60, 3600, false, function(self)
        local B = self
        ---原作 sub129：音符（a = { 色档, 飞行方向(TH07 rad) }）。
        local function note(me, a)
            local col, th = a[1], a[2]
            local bx, by
            for i = 1, 120 do
                me.x, me.y = me.x + cos(th * RAD2DEG) * 0.5,
                             me.y - sin(th * RAD2DEG) * 0.5
                if i == 60 then bx, by = B.x, B.y end     -- t=60 GET_BOSS_FLOAT
                task.Wait(1)
            end
            ---★ Lunatic 行**不执行** `ATAN2 *f0 *f6 *f7 *X *Y`（sd=0111，只给 E/N/H），
            ---只有下一条 `MUL_FLOAT *f0 *f0 -1`（sd=1000）⇒ 自机弹向 = 音符自身
            ---飞行方向取负（GET_BOSS_FLOAT 仍照跑，只是值没人用）。
            local f0 = -th
            if sqrt((me.x - player.x) ^ 2 + (me.y - player.y) ^ 2) > 32 then
                ---★ 原作的这发弹带 `INIT_BULLET_CMD 0 128 0 60 1 0 1`（type 0x80、
                ---dur 60、loop 1、cmd.speed=0、cmd.angle=1；波 flags=644=0x284 含 0x80 位）：
                ---先沿当前朝向 60 帧线性刹到 0，然后 rot = A2P + state.angle(=cmd.speed=0)、
                ---速度 = state.speed(=cmd.angle=1)。漏掉 ⇒ 弹不刹车、一路 1.2 直飞。
                shoot6(me, 0, 0, 65, 3, col, 1, 1, 1.2, 0.5, f0, 1.5708,
                       brake_aim6(60, 0, 1, 1), true)
            end
        end
        ---原作 sub130：音符串（a = { f2, f4, 色档, 音符方向 }）。
        local function chain(me, a)
            local ang, av = a[1], a[2]
            local g = 4
            for _ = 1, 12 do
                for _ = 1, g do
                    ---★ 原作 ENEMY_MOVE_POLAR 每帧「先转 angleVel、再按 angle 走」
                    ---（EclManager.cpp:2018-2026），顺序反了整串轨迹会偏。
                    ang = ang + av
                    me.x, me.y = me.x + cos(ang * RAD2DEG) * 6,
                                 me.y - sin(ang * RAD2DEG) * 6
                    task.Wait(1)
                end
                pspawn(me.x, me.y, note, { a[3], a[4] })
                g = g + 2                                   -- ADD *i2_1 *i2_1 2
            end
        end
        ---原作 sub127 的四块：(f0, f2 的 A2P 偏移, f4, 色档)。
        ---★ 第 5 个字段是**块内每只 sub130 的 f2 步进**：块1/3 的循环体是
        ---`ADD_FLOAT *f2 *f2 0.785398`、块2/4 是 `SUB_FLOAT`（DEC_JUMP 回到
        ---SPAWN 那条，所以步进在每只之后叠加、方向按块反号）。
        local BLK = {
            {  1.5708, -1.74533,  0.015708, 2,  0.785398 },
            { -1.5708,  1.74533, -0.015708, 6, -0.785398 },
            {  1.5708, -1.5708,   0.015708, 6,  0.785398 },
            { -1.5708,  1.5708,  -0.015708, 2, -0.785398 },
        }
        task.New(self, function()
            bmove(self, 120, 4, 0, 144)                 -- t=0 MOVE_POS_TIME(120,4,192,80)
            task.Wait(120)                              -- t=120
            self._box = box5(32, 48, 352, 128)          -- SET_MOVEMENT_BOUNDS
            task.Wait(16)                               -- SUB_CALL 2（墙钟 136，time 120）
            task.Wait(30)                               -- time 120 → 150（墙钟 166）
            local i2_1 = 150                            -- SET_INT *i2_1 150（每轮只在此设一次）
            while true do
                for _, b in ipairs(BLK) do
                    if pdist(self) < 128 then           -- JGEQ_F *DIST 128 → 跳过
                        shoot6(self, 0, 0, 64, 3, 2, 6, 3, 3.2, 0.5,
                               0, 0.392699, nil, true)
                    end
                    local base = aimth(self) + b[2]
                    for k = 0, 2 do                     -- DEC_JUMP *i2_0 3 次、每 3 帧
                        local f2 = base + k * b[5]
                        pspawn(self.x, self.y, chain,
                               { f2, b[3], b[4], b[1] + f2 })
                        task.Wait(3)
                    end
                    local w = int(i2_1 / 2)             -- DIV *i0 *i2_1 2
                    task.Wait(w)                        -- SET_WAIT_TIMER *i0
                    task.Wait(w)                        -- SET_WAIT_TIMER *i0
                    if i2_1 > 60 then i2_1 = i2_1 - 5 end
                end
            end
        end)
    end, { skin = skin4L, wallskin = skin4Lw, enter = enter4 })

    ---──────────────────── 合葬「プリズムコンチェルト」（原作 sub132） ────────────────────
    ---原作 sub132 L 行（`ecldata4.ecl`）逐条照抄。sub132 的 L 行只有 16 发 × 3 层这一组
    ---（-Lunatic- 不存在，实际用的是 Normal 行的排版），周期由 DEC_JUMP 控制：
    ---  · t=120 BEGIN / MOVE_POS_TIME(120,4,192,96)（我们 (0,224)→(0,128)）；
    ---  · t=240 限位框、SUB_CALL 2（16 帧）后 i2_0=2，连打 2 轮「正转五环 + 反转五环」：
    ---      每轮 = f0=*RNGRAD、RING_AIMED 2:col 16 3 2 0.5 f0 ±0.0785398（每圈 f0+=0.0392699）
    ---      五圈色档 1/2/4/6/5（+0.0785398）或 9/10/11/13/12（−0.0785398）；
    ---  · t=440 起同样结构（复用同一组正/反转五环），t=640 JUMP 回 t=240。
    ---⇒ 实测：自机钉在 (0,0) 时每 100 帧打一组，+0.0785398 / −0.0785398 交替，
    ---  首组在墙钟 256（= t=240 + SUB_CALL 2 的 16 帧）。
    scard("合葬「プリズムコンチェルト」", 4476, 60, 3600, false, function(self)
        local CA = { 1, 2, 4, 6, 5 }                 -- 正转组（a2 = +0.0785398）
        local CB = { 9, 10, 11, 13, 12 }             -- 反转组（a2 = -0.0785398）
        task.New(self, function()
            task.Wait(120)                           -- t=0..120 前奏
            bmove(self, 120, 4, 0, 128)              -- t=120 MOVE_POS_TIME(120,4,192,96)
            task.Wait(120)                           -- t=120 → t=240
            self._box = box5(32, 48, 352, 128)       -- SET_MOVEMENT_BOUNDS
            task.Wait(16)                            -- SUB_CALL 2
            local pos = true
            while true do
                local a0 = rngrad()
                local cs = pos and CA or CB
                for i = 1, 5 do
                    shoot6(self, 0, 0, 66, 2, cs[i], 16, 3, 2, 0.5, a0,
                           (pos and 1 or -1) * 0.0785398, nil, true)
                    a0 = a0 + 0.0392699
                end
                pos = not pos
                task.Wait(100)
            end
        end)
    end, { skin = skin4L, wallskin = skin4Lw, enter = enter4 })
end

TH34_add_stage12()
TH34_add_stage78()
TH34_add_stage78_boss()
TH34_add_stage56_boss()
