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
---  · `tools/check_fields.lua` 通过；`check_stage.lua --all` 通过（boss 242 / 符卡 492）。
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
---复刻成同一关上的第三张符卡（id 466「三道中『青之骚灵』」，130 秒）。
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
---spawn 复刻成同一关上的第四张符卡（id 468「五道中『幽明之径』」，120 秒）。
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
    ---中间，2026-09-29 已挪走）。本关（th34）改用自己**独立的一段 464..469**，
    ---按面序排：一道中 464、二道中 465、三道中 466、四面 467、五面 468、六面 469。
    ---这张是第六面 ⇒ 469。
    ---⚠ 只扫 `boss.card.add` 的末参会漏掉 th31 的 LIST（它的 id 写在表里、由变量传进 add），
    ---  照那种扫法挑出来的"空号"一注册就会被 `check_stage.lua --all` 报「card_id 跨组重复」。
    local CARD_ID = 469

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
        if not in_bound(pool4[i]) then
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
---       朝向 = 自机方向 + cmd.speed、速度 = cmd.angle，重复 loopCount 次。
---本仓库没有对应 API，所以逐帧自己算（差异 21）。bound 留默认 true ⇒ 出屏照常回收。
---（★ 角度/角速度都按「我们」的口径传进来：TH07 的弧度已经转成度、并且取过反，
---  见第 3 面/第 5 面那两段代码里的 `rad2our`。）
class["TH34_cmdbullet"] = Class(bullet, {
    ---@param cmd table { type, dur, loop, angle(度), speed, vec_x, vec_y }
    init = function(self, style, col, x, y, v, a, cmd)
        bullet.init(self, style, col, false, true)
        self.x, self.y = x, y
        self.rot = a
        self.vx, self.vy = v * cos(a), v * sin(a)
        self.c_type, self.c_dur, self.c_loop = cmd.type, cmd.dur, cmd.loop
        self.c_timer, self.c_done = 0, 0
        self.c_angle, self.c_speed = cmd.angle, cmd.speed
        self.c_vx, self.c_vy = cmd.vec_x or 0, cmd.vec_y or 0
        self.c_ang, self.c_spd = a, v
    end,
    frame = function(self)
        if self.c_type == 0x10 then
            if self.c_timer < self.c_dur then
                self.vx, self.vy = self.vx + self.c_vx, self.vy + self.c_vy
                if abs(self.vx) > 0.0001 or abs(self.vy) > 0.0001 then
                    ---TH07 的 this->angle 是弧度，而我们的 `rot` 是角度（LuaSTG 的 Render 吃角度）
                    self.rot = math.deg(atan2(self.vy, self.vx))
                end
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
            end
            self.c_timer = self.c_timer + 1
        elseif self.c_type == 1 then
            ---TH07 `UpdateBulletBurstSpeed`：前 17 帧速度 = 5 − timer*5/16 + 自身速度，
            ---沿**自己的**朝向（不是 cmd.angle）；第 17 帧之后把命令位清掉。
            if self.c_timer <= 16 then
                local spd = 5 - self.c_timer * 5 / 16 + self.c_spd
                self.vx, self.vy = spd * cos(self.rot), spd * sin(self.rot)
            else
                self.c_type = 0
            end
            self.c_timer = self.c_timer + 1
        elseif self.c_type == 0x80 then
            local spd
            if self.c_timer >= self.c_dur then
                self.c_done = self.c_done + 1
                self.c_ang = Angle(self, player) + self.c_angle
                self.c_spd = self.c_speed
                spd = self.c_spd
                self.c_timer = 0
                if self.c_done >= self.c_loop then
                    self.c_type = 0
                end
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
    ---本关（th34）自己的一段是 464..469（按面序，见第六面那张卡的注释），
    ---这张是第四面 ⇒ 467。
    ---⚠ 只扫 `boss.card.add` 的末参会漏掉 th31 的 LIST（它的 id 写在表里、由变量传进 add）——
    ---  照那种扫法挑出来的"空号"（本卡原来取的 433 就是）一注册就报「card_id 跨组重复」。
    local CARD_ID = 467

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
        return style, col16(off), ran:Float(v2, v1), base + ran:Float(-lim, lim)
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
    ---符卡历史槽位：本关（th34）自己的一段 464..469（按面序）；这张是第三面 ⇒ 466。
    local CARD_ID = 466

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
    ---符卡历史槽位：本关（th34）自己的一段 464..469（按面序）；这张是第五面 ⇒ 468。
    local CARD_ID = 468

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
