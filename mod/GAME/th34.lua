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

---INIT_BULLET_CMD 的两条运动（TH07 `BulletManager.cpp:410-421 / 739-756 / 845-875`）：
---  0x10 TargetVelocity：出生时把（朝向, 速度）冻结成一个向量，之后每帧 velocity += 该向量，
---       并把朝向重新对齐到速度方向（速度过零后会自己反过来）。
---  0x80 DirChangeAim：用 dur 帧沿当前朝向把速度线性减到 0，dur 帧后
---       朝向 = 自机方向 + cmd.speed、速度 = cmd.angle，重复 loopCount 次。
---本仓库没有对应 API，所以逐帧自己算（差异 21）。bound 留默认 true ⇒ 出屏照常回收。
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
    ---实测：全项目 `boss.card.add` 的末参里 1..432 已被占满（432 = th31 的
    ---「虚史「幻想郷伝説」」那行），所以这张取 433；注册后 `check_stage.lua --all`
    ---会复核没有跨组重复。
    local CARD_ID = 433

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
