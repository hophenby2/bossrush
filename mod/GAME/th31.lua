---=====================================
---TH31  永夜 Last Word
---  TH08（东方永夜抄）官方 17 张 Last Word（卡 205..221）的移植。
---
---移植方法：**不用 ECL 字节码 VM**，跟 th32「红色的幻想乡」同一套 —— 逐张读 th08full
---  （reccmp 复原的 TH08 1.00d 反编译源码）+ data/ecldata*.ecl 的原始字节，把每条指令
---  的语义翻成原生 LuaSTG 对象（Class(bullet, ...)、task、卡片自己的弹池登记表）。
---  下面每处「文件:行号」都能在本机复查。旧版（5537 行的字节码 VM + L.RAW 数据表）整个废弃。
---
---贯穿全关的几条事实（每张卡都靠它们）：
---  · 坐标：TH08 是 384×448、左上原点、y 朝下（GameManager.hpp:44-45）；我们原点在场地
---    中心、y 朝上（Lscreen.lua 的 SetWorld(288,46,384,448) → l=−192,r=192,b=−224,t=224）。
---    两边尺寸相同，所以换算是纯平移 + y 翻转、**没有比例缩放**：
---        x_我们 = x_原作 − 192        y_我们 = 224 − y_原作        角度整体取反
---  · rank 固定取 32（移植版没有难度系统）。原作 Last Word 全程是符卡，出弹的 rank 缩放
---    整段被 `if (!g_Spellcard.IsActive())` 挡住（EclDependencies.cpp:735-761），
---    所以 rank 取多少都不进算式 —— 记一笔备查。
---  · 同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455 `Bullet bullets[0x601]`）。
---    activeBulletCount >= 0x600 时**整波不生**；波中间某一颗生不出来就放弃整波剩下的，
---    音效照响（BulletManager.cpp:686-712）。移植版没有全局弹池，卡片自己维护一张登记表。
---  · 出生动画：flags 带 SPAWN_FAST(2)/NORMAL(4)/SLOW(8) 的弹进入 SPAWNING_* 状态：
---    出生瞬间位置先减去 velocity*4，之后每帧只走 velocity/2、/2.5、/3，
---    动画播完那一帧再补一次完整的 FIRED 更新（BulletManager.cpp:820-1013）。
---    etama.anm 的 script 21/22/23 长度 = 10/15/30 帧（末尾 ins_0/Delete 的 time）。
---  · 敌方每帧顺序（EnemyManagerUpdate.cpp:159-192）：RunEcl（主 context → 子 context）
---    → ClampPosition → IntegrateVelocity → ClampPosition → worldPosition = position + offset。
---    也就是**子程序（枪）先跑、位移后跑**；而且 RunEcl 里用到的世界坐标是**上一帧末**的
---    位置（position 只在 UpdateMovement 里变）。移植版把这条顺序抄进对象自己的 frame。
---  · ★ 每张 LW 的 BOSS 都由一个「生成助手」子程序建起来：`ins_63 SET_POSITION(192,128)` →
---    `ins_75 SET_MOVEMENT_BOUNDS(32,48,352,128)`（**同时置 CLAMP_POSITION**）→
---    `ins_77 SET_HITBOX` → t=43 `ins_52 CALL(根)`。⇒ **BOSS 一律原地出现在我们 (0,96)**，
---    并且每帧被夹在 x∈[−160,160]、y∈[96,176]（EnemyManagerUpdate.cpp:172-174 位移前后各钳
---    一次）。卡 214 / 216 在自己的根里另设边界，卡 212 也是；卡 215 / 217 / 221 用
---    `ins_76` 直接关掉夹框。`ins_67` 的四条边界修正判据就是拿这组边界 ±96/48 去比的。
---  · 占位贴图：娃娃 = "servant"，小弹 = ball_small（TH08 色号 2/4 → COLOR.RED/PURPLE）。
---    ★ 17 张全部实现完之后再统一换素材。
---
---实现进度（每张都在 CARD 表里登记；没登记的走文件末尾的占位实现）：
---  · 205「季节外调的蝴蝶风暴」（莉格露）  —— 平均 9.6 / 死局 9.1% / 峰值 1537 发有判定 1185
---  · 206「盲夜鸟」（米斯蒂娅）          —— 平均 15.9 / 死局 0.2% / 峰值 1436 发有判定 1046
---  · 207「日出之国的天子」（慧音）      —— 平均 4.0 / 死局 0.0% / 峰值 326 发有判定 98
---  · 218「格兰吉纽尔剧场的怪人」（爱丽丝）—— 平均 14.1 / 死局 1.4% / 峰值 1136 发有判定 677
---  · 208「幻胧月睨」（铃仙）            —— 平均 4.8 / 死局 1.7% / 峰值 784 发有判定 353
---  · 209「天网蛛网捕蝶之法」（永琳）    —— 平均 9.4 / 死局 0.0% / 峰值 1449 发有判定 98
---  · 210「蓬莱之树海」（辉夜）          —— 平均 17.6 / 死局 7.5% / 峰值 679 发有判定 477
---      ★ 7 棵树在移植版里打不掉（原作有 life 1000..4000），密度比原作高一档；
---        安全角度 10.4/24（同屏最密的卡 205 是 6.8/24）。
---  · 211「不死鸟再诞」（妹红）          —— 平均 5.2 / 死局 0.6% / 峰值 815 发有判定 295
---  · 212「远古的欺骗者」（因幡帝）      —— 平均 5.6 / 死局 0.1% / 峰值 1090 发有判定 504
---  · 213「无何有净化」（慧音）           —— 平均 15.6 / 死局 44.8% / 峰值 658 发有判定 574
---      ★ 8 只小怪在**屏幕外** 380 px 的圆上自转、每 2 帧各打 1 发朝圆心
---        （每根弹流 2 帧 × 3 px/帧 = 6 px 一颗）→ 8 根扫过来的弹流墙。
---        弹出生 li6 帧（50→150 递增）后自己消失，所以前几秒的弹飞不到场内。
---  · 214「梦想天生」（灵梦）             —— 平均 35.9 / 死局 2.3% / 峰值 1024 发有判定 667
---      ★ 24 只使魔在场上随机漂移，每只每轮扇射的间隔 li1 从 200 帧开始、逐轮 −10，
---        减到 ≤60 帧后钉死（→ 后期是 60 帧一轮的密集扇；安全角度均 11.3/24）。
---  · 215「炽热之星」（魔理沙）           —— 平均 2.1 / 死局 0.0% / 峰值 985 发有判定 355
---      ★ BOSS 带 4 层彗星头俯冲，沿途撒的弹**先减速停住、原地等 180 帧、
---        再朝转向后的方向加速 200 帧飞出**—— 两段式，所以被打频率很低。
---  · 216「紧缩世界」（十六夜咲夜）       —— 平均 8.5 / 死局 0.0% / 峰值 980 发有判定 347
---      ★ 每 270 帧一轮：扇形弹飞出去 60 帧减速停住、再折 90°；第 150 帧**冻结 100 帧**
---        （弹不位移、自机 lock），并把场上所有带标记的弹就地变成隐形发射源
---        （每 3 帧一发 5.5、朝源弹角度与它的反方向各一条弹流）；
---        解冻那一帧 BOSS 朝自机打一发扇形，弹数逐轮 +1（5、6、7…）。
---  · 217「待宵反射卫星斩」（魂魄妖梦） —— 平均 7.6 / 死局 0.2% / 峰值 984 发有判定 222
---      ★ 一轮 180 真帧（前 20 个 tick 是 1/3 倍速的慢动作）：入场 → 瞬移到场地**底部**，
---        以 BOSS 的 x 为轴拉起一条**贯穿整个场地高度**的卫星链（16 点 × 2 方向 = 32 颗），
---        每颗每 6 帧朝**正上/正下**各打一发、共 10 拍；弹出生后原地停 11 帧，
---        再经「加速 0.5 → 刹停 → 转向加速到 1.0 → 直线加速到 2.0」四段飞出。
---      ★ 原作 Sub2 的斩击是**碰到就死**的判定线，移植版按 205..216 的惯例做成纯观感。
---  · 219「猩红命运」（蕾米莉亚·斯卡蕾特）—— 平均 2.5 / 死局 0.0% / 峰值 443 发有判定 105
---      ★ BOSS 原地出现在 (0,96)，每 190 帧一轮：本轮往 BOSS 上挂 3 台「螺旋发射器」
---        （同一个 enemy 的第 0/1/2 号子 context），分别朝「自机角 ±90°」与「自机角 +180°」，
---        按 64 / 64 / 16 拍各甩 4 发；轮末 BOSS 沿「边界感知随机方向」在 ins_75 的方框里
---        漂 60 px，同轮出弹初速 +1（4 → 10 封顶）。
---  · 220「西行寺无余涅槃」（西行寺幽幽子）—— 平均 217.8 / 死局 68.6% / 峰值 1570 发有判定 1067
---      ★ 一轮 415 帧：t=585 的 `ins_4(170, −1848)` 把 context time 也写成 170 ⇒ **同一帧**
---        从循环体第一条续跑（`#29..#35` 那七条初始化只在第一轮跑）。
---      ★ 轮首那两台「对转光柱扇」是 `ins_94` 生成的**独立敌人**：xi0 = ⌊li3/2⌋ 逐轮 +1
---        （6 起、每轮 +2）⇒ 第 14 轮正好 16 = 原作 `laserSlots[16]` 的容量；两个整圆
---        互相错开 ±(π/3 + π/(2xi0))，随后 60 帧一起对转 ∓60°（OUT_QUAD）。
---      ★ 四个出弹子程序（Sub2/3 车轮环、Sub4 扇环、Sub7 OFFSCREEN 环）每圈**只差
---        records[2] 的 magnitude**（0.16 起，Sub2/3 −0.0816667、Sub4 −0.054、Sub7 −0.0825）
---        而它们**同一帧全甩完**（子程序 xi0 是「圈数」、JUMP_DEC 的 loop 时间是 0）
---        ⇒ 同心的多层环：越外层的加速度越大（内圈减速停住再倒飞 = 那张卡的招牌手感）。
---      ★ 同屏上限 1536 发：本卡一轮就要 1632 发（车轮 6 组×4 圈×li2 + 扇 4 拍×5 圈×2 速×
---        (24+26+28+30) + 副环 3 圈×24）⇒ 弹池从第一轮起**长期饱和**，后面的波大半生不出来
---        （原作 BulletManager.cpp:692 整波不生、:698-712 波中间生不出就放弃剩下的，照抄）。
---  · 221「深弹幕结界 -梦幻泡影-」（八云紫）—— 平均 10.9 / 死局 13.8% / 峰值 1309 发有判定 473
---      ★ 助手 Sub18 先到 (0,96)、并被 ins_75 夹在 y∈[96,176]；t=90 关夹框、60 帧漂到 (0,0) 后
---        整场不再动。12 批使魔（共 28 台）先后从 BOSS 处出生（Sub5..Sub15 模板）。
---      ★ 每台使魔的前 120 帧是「原地螺旋张开」：ORBIT_AROUND_POINT 的圆心 = 自己的出生点、
---        半径 0 起、radialVelocity = lf2/120；t=120 改成「同圆心、半径 lf2、radialVelocity 0、
---        duration 0」⇒ 之后**永久绕圈**（EnemyManager.cpp:47-53 只在 movementDuration > 0 时清模式）。
---      ★ 大弹（type 6/11）：出生后先按「加速 → 刹停」两段走出去、原地停 90 帧、
---        再朝转向后的方向加速 200 帧飞出；各路使魔只有 records 的时长/系数不同
---        （60/90 帧、0.019~0.041）。小弹（type 6）从使魔的 (MOVE_ANGLE+lf3) 方向 16px 处甩出，
---        角速度 = rndUnit·π/8 + π/90 —— 出屏回收没有宽限（transformFlags 的 SPAWN_NORMAL 位本就
---        只有 4，不是 0x10），出生点在场外就当场收掉。
---      ★ 同屏上限 1536 发：终盘每真帧 6 发、且**离 BOSS 32px 内不打**；池满整波不生、
---        波中间生不出就放弃整波剩下的（BulletManager.cpp:692、:698-712，照抄）。
---Stage EX（ecldata8sp.ecl）的 14 张 —— 全部挂进已有角色组：慧音 191..193（组 3）、
---  妹红 194..204（组 7），所以 boss.CreateGroup(3/7) 会先打完该角色的 Last Word 再逐张打这些。
---  （读数也是 tools/check_stage.lua --threat，按每张卡自己的时长跑：3600..5400 帧。）
---  · 191「旧秘境史 -旧日秘史-」（慧音）    —— 平均 6.0 / 死局 0.0% / 峰值 372 发有判定 216
---      ★ BOSS 原地；一把常驻的枪 + 4 只使魔（2 对、life 1350 / 750）。
---  · 192「一条归桥」（慧音）              —— 平均 0.2 / 死局 0.0% / 峰值 835 发有判定 729
---      ★ BOSS 原地；8 台**看不见**的发射器（4 对 × 2 种色号），各自按 ±ω 自转甩弹。
---  · 193「新幻想史 -未来秘史-」（慧音）   —— 平均 9.3 / 死局 0.1% / 峰值 482 发有判定 297
---      ★ BOSS 原地；一把枪 + 一次 8 只使魔；使魔的枪是 14 张里唯一「一发 4 颗十字」的。
---  · 194「月之岩笠的诅咒」（妹红）        —— 平均 8.1 / 死局 0.1% / 峰值 231 发有判定 184
---      ★ BOSS 原地；t=110 挂两条枪（十字 / 八向环）+ 6 只使魔。
---  · 195「火之鸟 -凤翼天翔-」（妹红）      —— 平均 8.7 / 死局 2.9% / 峰值 1092 发有判定 499
---      ★ 全场最密的 EX 卡之一；「火之鸟」= 一颗使魔 + 6 圈偏移弹，使魔自己散 150 发。
---  · 196「灭罪寺院伤」（妹红）            —— 平均 5.1 / 死局 0.0% / 峰值 113 发有判定 88
---      ★ 两只使魔生成在同一个点、方向相反，各带一把枪；BOSS 每 180 帧漂 60 px。
---  · 197「徐福时空」（妹红）              —— 平均 25.8 / 死局 1.6% / 峰值 1549 发有判定 1261
---      ★ 全场最密；BOSS 从 (0,96) 漂到 (0,32) 后不夹框，使魔 + **BOSS 自己两把枪**一起压。
---  · 198「正直者之死」（妹红）            —— 平均 14.3 / 死局 0.0% / 峰值 887 发有判定 794
---      ★ BOSS 整卡不动；4 只使魔 + 两把常驻枪（0 号光柱、1 号自机狙扇）。
---  · 199「乌」（妹红）                    —— 平均 7.5 / 死局 0.0% / 峰值 519 发有判定 267
---      ★ 乌鸦 = 一次 3 只；每只自己带枪，整卡的节拍走 0 号子 context（整卡只挂一次）。
---  · 200「不死鸟之尾」（妹红）            —— 平均 9.6 / 死局 0.0% / 峰值 446 发有判定 359
---      ★ 两条「一次放 5 只凤凰」的链 + 0/1 号子 context（0 号重挂计时、1 号是 BOSS 自己的枪）。
---  · 201「凯风快晴 -富士山火山-」（妹红）  —— 平均 15.3 / 死局 2.1% / 峰值 692 发有判定 223
---      ★ 24 发环 + 10 只使魔（火山弹的发射台）；t=290 起 0 号子 context 换成另一种枪。
---  · 202「被不死鸟附身」（妹红）          —— 平均 7.3 / 死局 0.8% / 峰值 710 发有判定 165
---      ★ BOSS 先漂到场地中心、之后每帧贴住自机（这就是「附身」），四段轮流出小/中/大凤凰。
---  · 203「蓬莱人形」（妹红）              —— 平均 19.4 / 死局 12.5% / 峰值 620 发有判定 384
---      ★ 两个人形沿矩形螺旋往里绕、边走边掉弹；BOSS 自己也甩圈 + 自机狙。
---  · 204「不灭之射击」（妹红）            —— 平均 11.6 / 死局 18.3% / 峰值 1536 发有判定 550
---      ★ 圆周波招牌手感（出生刹车 → 停 → 加速 120 帧 → 掉头 → 再加速 → 转向飞走）；
---        末段两条枪各出 16×16 波 ⇒ 弹池从 t≈3900 起长期饱和（原作全局池同样 1536，照抄）。
---（Last Word 的读数 = tools/check_stage.lua --threat；205..220 跑 5940 帧、221 跑 7860 帧；
---  「平均」= 自机 60px 内弹数）。
---=====================================

local class = {}
_editor_class["TH31"] = class

---卡号（TH08 的 205..221）→ 原生实现 { before, init, frame, render, del }。
---没登记的卡 = 还没移植。
local CARD = {}

---------------------------------------------------------------
---★ EX 卡（191..204）共用引擎：TH08 的「弹」（Bullet）本体。
---
---  Last Word 那 17 张的弹大都是「直线 + 一条转弯记录」，每张卡手写一遍还看得过来；
---  EX 反过来 —— 一张卡里就有「出生动画 → 减速停住 → 折向 → 加速 → 出屏宽限」
---  好几段叠着（BulletManager.hpp:129-155 的 17 种 transform 记录）。
---  所以这里把 BulletManager.cpp 的三段状态机
---  （AdvanceTransformProgram :307-475、各 Update* :1180-1464、OnUpdate :806-1013）
---  整段搬成一个**原生对象**，每张卡只写「ins_111 的记录表 + ins_96..104 的
---  出弹参数」这两样，剩下的交给它。
---
---  卡里的用法：
---    EX.set_record(槽, kind, allow, int0, int1, float0, float1)   -- = ins_111
---    EX.shoot(x, y, { op = …, … })                               -- = ins_96..104
---    EX.clear_records() / EX.pool_clear()                        -- 卡片 init / del
---    EX.scr_x(x) / EX.scr_y(y) / EX.color(c)                     -- 坐标与色号换算
---  ★ 只有 op 96..99（FAN/FAN_AIMED/CIRCLE/CIRCLE_AIMED）与部分 transform 记录
---    在本文件里被用到（全 14 张卡扫过一遍，见各卡注释）；没用到的分支也照
---    BulletManager.cpp 写了，省得下一张卡再回来补。
---------------------------------------------------------------
local EX = {}
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x−192、y' = 224−y、角度整体取反。
---（Last Word 那 17 张的卡里叫 to_th08_x/to_th08_y，名字是反的、沿用会看晕。）
function EX.scr_x(x) return x - 192 end
function EX.scr_y(y) return 224 - y end
---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
function EX.color(c) return c + 1 end

---IsWithinPlayfield 的场地（GameManager.cpp:132-150）：TH08 是 [0,384]×[0,448]，
---判据里还加半个精灵宽高 → 我们坐标就是 ±192 / ±224 再放半个精灵。
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---弹池（= 原作那 1536 个弹槽，BulletManager.hpp:455 `Bullet bullets[0x601]`）。
---EX 全程只有一张卡在跑，所以全 EX 共用一个池，卡片 init / del 里清空。
EX.POOL_MAX = 1536
EX.pool = {}

---出生动画的帧数 = etama.anm 里那条出生脚本末尾 Delete 的 time（VM 的 currentTimeInScript
---是从模板里拷过来的 —— 模板 SetAndExecuteScriptIdx 时就已经走了一帧 ⇒ 调用次数 = t）。
---见 BulletManager.cpp:222-247 与 :948-1013。
---★ **按弹种选脚本**（BulletManager.cpp:302-310 的 g_BulletSpriteScripts）：
---    type 0 / 1..6 / 11..13 / 16,17 → 脚本 18/19/20 与 21/22/23 → 10/15/30（随旗标）
---    type 7,8,9 / 14,15 / 18,19,20 → 脚本 **24**（三种旗标共用）→ 30/30/30
---    type 10                    → 脚本 **27** → 24/24/24
---  ⇒ 「SPAWN_FAST 就是 10 帧」只对小弹成立：7..9 / 14,15 / 18..20 这些大弹的出生动画
---    一律 30 帧（脚本 24 是一段 30 帧的放大淡入），10 号是 24 帧。
---  ★ 卡 191..194 之前按「一律 10/15/30」写的，这次一起对齐（它们用的 10/18 号弹都受影响）。
EX.SPAWN_FAST, EX.SPAWN_NORMAL, EX.SPAWN_SLOW = 10, 15, 30
local SPAWN_FRAMES = {
    [7] = { 30, 30, 30 }, [8] = { 30, 30, 30 }, [9] = { 30, 30, 30 },
    [10] = { 24, 24, 24 },
    [14] = { 30, 30, 30 }, [15] = { 30, 30, 30 },
    [18] = { 30, 30, 30 }, [19] = { 30, 30, 30 }, [20] = { 30, 30, 30 },
}
---消失动画（DESPAWNING，BulletManager.cpp:1019-1025）：小弹的 despawn 脚本 16
---也是 12 帧（etama.anm script 16 的 Delete 在 t=12）。
EX.DESPAWN_FRAMES = 12

---transform 位（BulletManager.hpp:129-155）。
local K_DECEL       = 0x1
local K_FAST        = 0x2
local K_NORMAL      = 0x4
local K_SLOW        = 0x8
local K_VEC         = 0x10
local K_POLAR       = 0x20
local K_REL         = 0x40
local K_AIMED       = 0x80
local K_ABS         = 0x100
local K_SPAWN_SND   = 0x200
local K_BOUNCE_ALL  = 0x400
local K_BOUNCE_BOT  = 0x800
local K_NO_CANCEL   = 0x1000
local K_CULL        = 0x2000
local K_SPRITE      = 0x4000
local K_ONLY_YOUKAI = 0x8000
local K_ONLY_HUMAN  = 0x10000
local K_WAIT        = 0x20000
local K_DESPAWN     = 0x40000
local K_SND         = 0x80000
local K_WRAP_X      = 0x400000
local K_WRAP_Y      = 0x800000
local K_CHILD       = 0x1000000
---★ 0x2000000 不是真 kind：SPAWN_CHILD_PATTERN 一次吃**两条**记录（主 + 次），
---  次记录那条的 kind 写成 0x2000000 只是占位（BulletManager.hpp:129-155 的枚举到
---  0x1000000 为止；BulletManager.cpp:442-470 只把「下一条记录」当 payload 读）。
local K_CHILD2      = 0x2000000
EX.K = {
    DECEL = K_DECEL, FAST = K_FAST, NORMAL = K_NORMAL, SLOW = K_SLOW,
    VEC = K_VEC, POLAR = K_POLAR, REL = K_REL, AIMED = K_AIMED, ABS = K_ABS,
    SPAWN_SND = K_SPAWN_SND, NO_CANCEL = K_NO_CANCEL,
    BOUNCE_ALL = K_BOUNCE_ALL, BOUNCE_BOT = K_BOUNCE_BOT, CULL = K_CULL,
    SPRITE = K_SPRITE, ONLY_YOUKAI = K_ONLY_YOUKAI, ONLY_HUMAN = K_ONLY_HUMAN,
    WAIT = K_WAIT, DESPAWN = K_DESPAWN, WRAP_X = K_WRAP_X, WRAP_Y = K_WRAP_Y,
    SND = K_SND, CHILD = K_CHILD, CHILD2 = K_CHILD2,
}

---位判（内嵌的 Lua 5.1 没有位运算）：掩码都是 2 的幂，`floor(v / mask) % 2 == 1` 就行。
---★ v 是负数时这条会**误判成 true**（Lua 的 % 对负数取正余：−1 % 2 == 1）——
---  ex_act 是「点亮了哪些 transform 位」的集合，负数没有意义，直接当没点亮。
local function bit_hit(v, mask)
    if v < 0 then return false end
    return math.floor(v / mask) % 2 == 1
end

---等价于 `v &= ~mask`（Lua 5.1 没有位运算）：**先判再减**。
---★ 直接写 `ex_act - A - B` 会在只点亮一位时把 ex_act 减成负数（原作用是
---  `activeTransformFlags &= ~(A|B)`，BulletManager.cpp:1415-1418）——踩过：
---  卡 196 的 bounceLimit = 0，弹只点亮 BOUNCE_ALL，一次反弹后减两位之和就变负，
---  接着 bit_hit 对负数误判、跑去跑根本没点亮的 WRAP 分支。
local function bit_clear(v, mask)
    if math.floor(v / mask) % 2 == 1 then return v - mask end
    return v
end

---AddNormalizeAngle(a, 0)（Global.cpp:1231-1252）：卷进 (−π, π]。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

---自机方向（Player::AngleToPoint，Player.cpp:967-981；换算到我们坐标就是普通 atan2）。
---★ player 只在函数体里取（顶层取会拿到 nil，见文件里其它卡的注释）。
local function aim_at_player(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---IsWithinPlayfield 的反面（GameManager.cpp:132-150），half = 半个精灵宽高。
local function outside_field(x, y, half)
    return x + half < FIELD_L or x - half > FIELD_R
            or y + half < FIELD_B or y - half > FIELD_T
end

---bulletType → 占位贴图 + 半个精灵宽高。
---原作每种 type 的精灵尺寸（etama.anm 的 sprite 表）：0 = 8×8、1..6 = 14×16、
---7..9 = 32×32、10 = 64×64、11..18 是 16×16 / 32×32 混着。
---★ 占位口径（跟 Last Word 那 17 张一致）：小弹 ball_small、大弹 ball_mid、
---  超大 ellipse；全部实现完再统一换素材。
local function style_of(t)
    if t == 10 then return ellipse, 32 end
    if t == 1 or t == 3 or t == 7 or t == 8 or t == 9 or t >= 12 then
        return ball_mid, 16
    end
    return ball_small, 8
end
EX.style_of = style_of

---「子弹生成描述符」的 transform 记录表（敌机的 bulletSpawnDescriptor.transforms，
---op111 写它、出弹时**整块拷给弹**，BulletManager.cpp:258-263）。槽从 1 起（原作从 0）。
---★ **每个发射源一份**（BOSS、每只使魔在原件里都是各自的敌机、各自的描述符），
---  所以记录表挂在发射源对象上，调用时把它当第一参传进来。
local function recs_of(who)
    local t = who.ex_recs
    if t == nil then
        t = {}
        who.ex_recs = t
    end
    return t
end
EX.recs_of = recs_of

---ins_111 SET_BULLET_TRANSFORM（EclRunHigh.inl:243-262）：
---  发射源, 槽, kind, allowWhileActive, int0, int1, float0, float1。
function EX.set_record(who, slot, kind, allow, i0, i1, f0, f1)
    recs_of(who)[slot + 1] = { kind = kind, allow = allow, i0 = i0, i1 = i1, f0 = f0, f1 = f1 }
end

---清空一个发射源的记录表（卡片 init 里调用；原作的描述符是零填的）。
function EX.clear_records(who)
    local t = recs_of(who)
    for i = 1, 18 do t[i] = nil end
end

---出弹那一刻把记录表拷一份（原作 memcpy）→ 之后卡里再改记录不会动到已经在飞的弹。
local function copy_records(who)
    local src = recs_of(who)
    local t = {}
    for i = 1, 18 do t[i] = src[i] end
    return t
end

---------------------------------------------------------------------
---弹本体。字段一律 ex_ 前缀，避免和 bullet 基类撞名。
---------------------------------------------------------------------

---AdvanceTransformProgram（BulletManager.cpp:307-475）：从 transformIndex 起，
---按顺序找第一条「transformFlags 里带着它、且（allowWhileActive 或当前没有活动状态）」
---的记录点亮。SET_CULL_DELAY / SET_SPRITE / PLAY_SOUND 是「顺手」类 —— 处理完
---同一次调用里继续往下走（原作的 goto nextRecord）。
---SPAWN_CHILD_PATTERN 要往弹池里生成一整波弹，实现放在下面（出弹那一段），
---这里先声明：advance 里要用它（Lua 的 upvalue 必须在定义处之前就声明成 local）。
local spawn_child

local function advance(self)
    local recs = self.ex_recs
    while true do
        if self.ex_idx > 18 then return end
        local r = recs[self.ex_idx]
        if r == nil or r.kind == 0 then return end
        if r.allow == 0 and self.ex_act ~= 0 then return end
        if not bit_hit(self.ex_flags, r.kind) then
            self.ex_idx = self.ex_idx + 1
        else
            local k = r.kind
            local again = false
            if k == K_DECEL then
                self.ex_act = self.ex_act + K_DECEL
                self.ex_decel_t = 0
            elseif k == K_VEC then
                self.ex_act = self.ex_act + K_VEC
                ---加速度向量按**生效那一刻**的弹角定死（:345-357）；float1 < −990
                ---→ 用弹自己的角度（payload: magnitude, angle, durationFrames）。
                local a = r.f1 > -990 and r.f1 or self.ex_angle
                self.ex_vax, self.ex_vay = math.cos(a) * r.f0, math.sin(a) * r.f0
                self.ex_vec_t, self.ex_vec_n = 0, r.i0
            elseif k == K_POLAR then
                self.ex_act = self.ex_act + K_POLAR
                self.ex_pol_t, self.ex_pol_n = 0, r.i0
                self.ex_pol_ds, self.ex_pol_da = r.f0, r.f1
            elseif k == K_REL or k == K_AIMED or k == K_ABS then
                ---三种折向共用一份状态（原作就是同一个 exState，只有角度算法不同）。
                self.ex_act = self.ex_act + k
                self.ex_dir_t, self.ex_dir_n = 0, r.i0
                self.ex_dir_rep, self.ex_dir_done = r.i1, 0
                self.ex_dir_ang = r.f0
                ---float1 < −999 → 折向时用弹**当时**的速度（:391-393）。
                self.ex_dir_spd = r.f1 > -999 and r.f1 or self.ex_speed
            elseif k == K_BOUNCE_ALL or k == K_BOUNCE_BOT then
                self.ex_act = self.ex_act + k
                self.ex_bnc_spd = r.f0 >= 0 and r.f0 or self.ex_speed
                self.ex_bnc_lim, self.ex_bnc_done = r.i0, 0
            elseif k == K_WRAP_X then
                self.ex_act = self.ex_act + K_WRAP_X
                self.ex_wrap_t = r.i0
            elseif k == K_WRAP_Y then
                self.ex_act = self.ex_act + K_WRAP_Y
                self.ex_wrap_t = r.i0
            elseif k == K_WAIT then
                self.ex_act = self.ex_act + K_WAIT
                self.ex_wait_t = r.i0
            elseif k == K_CHILD then
                ---SPAWN_CHILD_PATTERN（:442-470）：主记录 + **下一条**记录配成一张描述符，
                ---生成完弹自己不动，继续往下扫（原作是 `goto nextRecord`）；
                ---所以下面先 +1、末尾那次 +1 一共吃掉两条。
                spawn_child(self, r, recs[self.ex_idx + 1])
                self.ex_idx = self.ex_idx + 1
                again = true
            elseif k == K_CULL then
                self.ex_cull = r.i0
                again = true
            elseif k == K_SPRITE then
                ---SET_SPRITE：换贴图与色号（payload: bulletType, color）。
                local style, half = style_of(r.i0)
                self.ex_half = half
                ---bullet:ChangeImage(imgclass, index)（THlib/bullet/bullet.lua:116）——
                ---不是全局函数，是弹类的方法（踩过：全局 ChangeImage 是空的）。
                self:ChangeImage(style, EX.color(r.i1))
                again = true
            elseif k == K_SND then
                again = true                    -- PLAY_SOUND：移植版不放音效
            elseif k == K_DESPAWN then
                self.ex_despawn = EX.DESPAWN_FRAMES
            end
            self.ex_idx = self.ex_idx + 1
            if not again then return end
        end
    end
end

---UpdateDeceleration（BulletManager.cpp:1180-1201）：timer ≤ 16 时速度改成
---`speed + (5 − timer·5/16)`（原作就这么写的 —— 它其实是先**加速**到 +5 再掉回来），
---超过 16 帧把位清掉。
local function upd_decel(self)
    if self.ex_decel_t <= 16 then
        local m = 5 - self.ex_decel_t * 5 / 16
        self.ex_vx = math.cos(self.ex_angle) * (m + self.ex_speed)
        self.ex_vy = math.sin(self.ex_angle) * (m + self.ex_speed)
    else
        self.ex_act = self.ex_act - K_DECEL
    end
    self.ex_decel_t = self.ex_decel_t + 1
end

---UpdateVectorAcceleration（:1204-1226）：每帧 velocity += 固定向量，然后
---angle = atan2(vy, vx)（所以弹会自己顺着合速度转）。
local function upd_vec(self)
    if self.ex_vec_t >= self.ex_vec_n then
        self.ex_act = self.ex_act - K_VEC
    else
        self.ex_vx = self.ex_vx + self.ex_vax
        self.ex_vy = self.ex_vy + self.ex_vay
        if math.abs(self.ex_vx) > 0.0001 or math.abs(self.ex_vy) > 0.0001 then
            self.ex_angle = math.atan2(self.ex_vy, self.ex_vx)
        end
    end
    self.ex_vec_t = self.ex_vec_t + 1
end

---UpdatePolarAcceleration（:1228-1251）：极坐标加速（角速度 + 速度增量）。
---payload: speedDelta(float0), angleDelta(float1), durationFrames(int0)。
local function upd_polar(self)
    if self.ex_pol_t >= self.ex_pol_n then
        self.ex_act = self.ex_act - K_POLAR
    else
        self.ex_angle = add_norm(self.ex_angle + self.ex_pol_da)
        self.ex_speed = self.ex_speed + self.ex_pol_ds
        self.ex_vx = math.cos(self.ex_angle) * self.ex_speed
        self.ex_vy = math.sin(self.ex_angle) * self.ex_speed
    end
    self.ex_pol_t = self.ex_pol_t + 1
end

---三种折向（UpdateRelative/Absolute/AimedDirectionChange，:1253-1374）。
---timer < intervalFrames 时**速度线性掉到 0**（方向不变）；到点那一帧才
---「转向 + 把速度换成 record 里的 speed（没给就用原速）」、timer 归零。
local function upd_dir(self, k)
    local m
    if self.ex_dir_t >= self.ex_dir_n then
        self.ex_dir_done = self.ex_dir_done + 1
        if self.ex_dir_done >= self.ex_dir_rep then
            self.ex_act = self.ex_act - k
        end
        if k == K_REL then
            self.ex_angle = self.ex_angle + self.ex_dir_ang      -- 相对：角度直接相加（不归一化）
        elseif k == K_ABS then
            self.ex_angle = self.ex_dir_ang                      -- 绝对：直接换成记录里的角
        else
            self.ex_angle = add_norm(aim_at_player(self.x, self.y) + self.ex_dir_ang)
        end
        self.ex_speed = self.ex_dir_spd
        m = self.ex_speed
        self.ex_dir_t = 0
    else
        m = self.ex_speed - self.ex_dir_t * self.ex_speed / self.ex_dir_n
    end
    self.ex_vx = math.cos(self.ex_angle) * m
    self.ex_vy = math.sin(self.ex_angle) * m
    self.ex_dir_t = self.ex_dir_t + 1
end

---UpdateBoundaryBounce（:1376-1420）：出界就反射（x 面 = π − 角、y 面 = −角），
---速度换成 bounceSpeed，撞够 bounceLimit 次就把位清掉。
local function upd_bounce(self)
    if not outside_field(self.x, self.y, self.ex_half) then return end
    if self.x < FIELD_L or self.x >= FIELD_R then
        self.ex_angle = add_norm(PI - self.ex_angle)
    end
    if self.y > FIELD_T or (self.y <= FIELD_B and bit_hit(self.ex_act, K_BOUNCE_ALL)) then
        self.ex_angle = -self.ex_angle
    end
    self.ex_speed = self.ex_bnc_spd
    self.ex_vx = math.cos(self.ex_angle) * self.ex_speed
    self.ex_vy = math.sin(self.ex_angle) * self.ex_speed
    self.ex_bnc_done = self.ex_bnc_done + 1
    if self.ex_bnc_done >= self.ex_bnc_lim then
        self.ex_act = bit_clear(bit_clear(self.ex_act, K_BOUNCE_ALL), K_BOUNCE_BOT)
    end
end

---WRAP_X / WRAP_Y（:1422-1464）：出屏就从对面绕回来，计时到了把位清掉。
local function upd_wrap_x(self)
    if self.x < FIELD_L then self.x = self.x + 384
    elseif self.x > FIELD_R then self.x = self.x - 384 end
    if self.ex_wrap_t <= 0 then self.ex_act = self.ex_act - K_WRAP_X
    else self.ex_wrap_t = self.ex_wrap_t - 1 end
end

local function wrap_y_check(self)
    if self.y > FIELD_T then self.y = self.y - 448
    elseif self.y < FIELD_B then self.y = self.y + 448 end
end

local function upd_wrap_y(self)
    wrap_y_check(self)
    if self.ex_wrap_t <= 0 then self.ex_act = self.ex_act - K_WRAP_Y
    else self.ex_wrap_t = self.ex_wrap_t - 1 end
end

---弹本体。位移全部自己在 frame 里算（引擎的自动积分保持 vx = vy = 0）。
EX.bullet = Class(bullet, {
    ---p = { x, y, angle, speed, style, color, half, flags, start }
    init = function(self, p)
        ---bullet:init(imgclass, index, stay, destroyable)（THlib/bullet/bullet.lua:75）
        bullet.init(self, p.style, p.color, false, true)
        self.bound = false                  -- 出屏回收自己判（原作 IsWithinPlayfield）
        self.vx, self.vy = 0, 0
        self.ex_angle, self.ex_speed = p.angle, p.speed
        self.ex_flags = p.flags
        self.ex_recs = p.recs
        self.ex_idx = p.start or 1
        self.ex_act = 0                     -- activeTransformFlags
        ---★ 消失动画的剩余帧数必须**在这里归零**：DESPAWN 记录把它写成 12 之前，
        ---  frame 每帧都要读它（`:497`），漏了就 `compare number with nil`。
        self.ex_despawn = 0
        self.ex_half = p.half
        self.ex_cull, self.ex_off = 0, 0
        self.ex_vx = math.cos(p.angle) * p.speed
        self.ex_vy = math.sin(p.angle) * p.speed
        ---出生动画（BulletManager.cpp:196-247）：位置先退 velocity·4，状态进 SPAWNING_*。
        ---动画期间没有判定、不跑 transform（:948-1013）。
        local n, div = 0, 2
        local row = SPAWN_FRAMES[p.btype]
        if bit_hit(p.flags, K_FAST) then
            n = row and row[1] or EX.SPAWN_FAST
        elseif bit_hit(p.flags, K_NORMAL) then
            n, div = row and row[2] or EX.SPAWN_NORMAL, 2.5
        elseif bit_hit(p.flags, K_SLOW) then
            n, div = row and row[3] or EX.SPAWN_SLOW, 3
        end
        self.ex_spawn, self.ex_div = n, div
        if n > 0 then
            self.x = p.x - self.ex_vx * 4
            self.y = p.y - self.ex_vy * 4
            self.colli = false
        else
            self.x, self.y = p.x, p.y
        end
        ---生成时先跑一次 AdvanceTransformProgram（:262）：第一段 transform 就此点亮，
        ---真正生效要等出生动画播完。
        advance(self)
    end,
    frame = function(self)
        ---① 出生动画：每帧只走 velocity/2、/2.5、/3；播完那一帧**不 return**，
        ---   继续走完整的 FIRED 更新（:831 activateBullet / :948-1013）。
        if self.ex_spawn > 0 then
            self.x = self.x + self.ex_vx / self.ex_div
            self.y = self.y + self.ex_vy / self.ex_div
            self.ex_spawn = self.ex_spawn - 1
            if self.ex_spawn > 0 then
                bullet.frame(self)
                return
            end
            self.colli = true
        end
        ---② 消失动画（DESPAWNING，:1019-1025）：只走 velocity/2、不跑 transform。
        if self.ex_despawn > 0 then
            self.x = self.x + self.ex_vx / 2
            self.y = self.y + self.ex_vy / 2
            self.ex_despawn = self.ex_despawn - 1
            if self.ex_despawn == 0 then object.RawDel(self) end
            bullet.frame(self)
            return
        end
        ---③ transform 推进 + 各状态更新（:825-854）
        advance(self)
        if bit_hit(self.ex_act, K_DECEL) then upd_decel(self) end
        if bit_hit(self.ex_act, K_VEC) then upd_vec(self) end
        if bit_hit(self.ex_act, K_POLAR) then upd_polar(self) end
        if bit_hit(self.ex_act, K_REL) then upd_dir(self, K_REL) end
        if bit_hit(self.ex_act, K_ABS) then upd_dir(self, K_ABS) end
        if bit_hit(self.ex_act, K_AIMED) then upd_dir(self, K_AIMED) end
        if bit_hit(self.ex_act, K_BOUNCE_ALL) or bit_hit(self.ex_act, K_BOUNCE_BOT) then
            upd_bounce(self)
        end
        if bit_hit(self.ex_act, K_WRAP_X) then upd_wrap_x(self) end
        if bit_hit(self.ex_act, K_WRAP_Y) then upd_wrap_y(self) end
        if bit_hit(self.ex_act, K_WAIT) then
            if self.ex_wait_t <= 0 then self.ex_act = self.ex_act - K_WAIT
            else self.ex_wait_t = self.ex_wait_t - 1 end
        end
        ---④ 出屏宽限计时（:856-857）
        if self.ex_cull > 0 then self.ex_cull = self.ex_cull - 1 end
        ---⑤ 位移（:858-859）
        self.x = self.x + self.ex_vx
        self.y = self.y + self.ex_vy
        ---⑥ 出屏回收（:861-900）：带着折向 / 反弹位的弹有 0x80 帧宽限（每帧重新数），
        ---   其它弹一出屏就回收。
        if self.ex_cull == 0 then
            if outside_field(self.x, self.y, self.ex_half) then
                if bit_hit(self.ex_act, K_REL) or bit_hit(self.ex_act, K_ABS)
                        or bit_hit(self.ex_act, K_AIMED)
                        or bit_hit(self.ex_act, K_BOUNCE_ALL)
                        or bit_hit(self.ex_act, K_BOUNCE_BOT) then
                    self.ex_off = self.ex_off + 1
                    if self.ex_off >= 0x80 then
                        object.RawDel(self)
                        return
                    end
                else
                    ---★ 从「带折向 / 反弹位」掉到「不带」的那一帧起，出屏计数是**每帧 −1**、
                    ---  减到 0 才回收；只有一次都没出过屏（计数 0）的弹才是当场回收
                    ---  （BulletManager.cpp:895-900 的 else 分支）。
                    ---  卡 194 的「月笠」弹正好走这条路：先带着 AIMED 位出屏攒计数，
                    ---  170 帧后转向把位清掉，计数再一帧一帧减回去。
                    if self.ex_off == 0 then
                        object.RawDel(self)     -- 原作的 Deactivate()：静默回收
                        return
                    end
                    self.ex_off = self.ex_off - 1
                end
            else
                self.ex_off = 0
            end
        end
        bullet.frame(self)
    end,
})

---------------------------------------------------------------------
---出弹
---------------------------------------------------------------------

---还在占槽的弹数（= 原作 activeBulletCount：**所有非 UNUSED 的槽都算**，
---含出生动画与消失动画里的，BulletManager.cpp:810-816 每帧先清零再数一遍）。
local function pool_used()
    for i = #EX.pool, 1, -1 do
        if not IsValid(EX.pool[i]) then
            table.remove(EX.pool, i)
        end
    end
    return #EX.pool
end
EX.pool_used = pool_used

---清池（卡片 init / del）。
function EX.pool_clear()
    for i = #EX.pool, 1, -1 do
        if IsValid(EX.pool[i]) then object.RawDel(EX.pool[i]) end
        EX.pool[i] = nil
    end
end

---`REMOVE_ALL_BULLETS`（`ins_162`，EclRunHigh.inl:937 调 BulletManager::RemoveAllBullets(4)，
---BulletManager.cpp:484-541）：所有非 UNUSED / 非 DESPAWNING 的弹**当帧**进 DESPAWNING
---（12 帧淡出后回收）；恰好贴在自机取消圈里的那几颗是立刻清掉（mode = 4 ⇒ 不掉道具）。
---★ 原作还会把 `spawnSuppressionFrames` 置 10（之后 10 帧生不出弹）——卡 202 里没有任何出弹
---  落在那三个窗口内（每批使魔都在 120 帧后才开火；大玉的子波也在 15 帧后），所以不实现。
function EX.pool_cancel()
    for i = #EX.pool, 1, -1 do
        local b = EX.pool[i]
        if IsValid(b) and b.ex_despawn == 0 then
            b.ex_despawn = EX.DESPAWN_FRAMES
        end
    end
end

---生成一颗弹（SpawnSingleBullet，BulletManager.cpp:95-270）。调用前请自己判池。
---★ 第一参从「发射源」改成**记录表本身**：原作出弹那一刻把描述符整块 memcpy 进弹里，
---  一波弹共享同一份拷贝 —— 发射源之后改自己的记录不会动到已经在飞的弹。
local function spawn_one(recs, x, y, angle, speed, btype, color, flags, start)
    local style, half = style_of(btype)
    local b = New(EX.bullet, {
        x = x, y = y, angle = angle, speed = speed,
        style = style, color = color, half = half,
        btype = btype, flags = flags, recs = recs, start = start,
    })
    EX.pool[#EX.pool + 1] = b
    return b
end

---SpawnBulletPattern（BulletManager.cpp:686-712）+ SpawnSingleBullet 的瞄准段（:95-186）。
---d 的字段就是原作的 BulletSpawnDescriptor：
---  aimMode / btype / color / count1 / count2 / speed1 / speed2 / angle / angleStep /
---  flags / start / recs。
---★ aimMode 0..8 全套都写在这里：ECL 的 96..99 只用到 0..3，
---  但「子弹再生子弹」（SPAWN_CHILD_PATTERN）用的是 8 = RANDOM，全 14 张卡只此一处。
---★ 池满 → **整波不生**；波中间生不出来 → 丢掉这一波剩下的（照抄原作）。
local function spawn_pattern(x, y, d)
    if pool_used() >= EX.POOL_MAX then return end
    local aim = aim_at_player(x, y)
    local m = d.aimMode
    local count1 = d.count1 or 1
    local count2 = d.count2 or 1
    for j = 0, count2 - 1 do
        for i = 0, count1 - 1 do
            if #EX.pool >= EX.POOL_MAX then return end
            local speed = count2 > 1
                    and d.speed1 - (d.speed1 - d.speed2) * j / count2 or d.speed1
            local angle = 0
            if m == 0 or m == 1 then                          -- FAN(_AIMED)
                if count1 % 2 ~= 0 then
                    angle = math.floor((i + 1) / 2) * d.angleStep
                else
                    angle = math.floor(i / 2) * d.angleStep + d.angleStep * 0.5
                end
                if i % 2 ~= 0 then angle = -angle end
                if m == 0 then angle = angle + aim end
                angle = angle + d.angle
            elseif m == 2 or m == 3 then                      -- CIRCLE(_AIMED)
                if m == 2 then angle = angle + aim end
                angle = angle + i * (2 * PI) / count1
                angle = angle + j * d.angleStep + d.angle
            elseif m == 4 or m == 5 then                      -- OFFSET_CIRCLE(_AIMED)
                if m == 4 then angle = angle + aim end
                angle = angle + PI / count1
                angle = angle + i * (2 * PI) / count1
                angle = angle + d.angle
            elseif m == 6 then                                -- RANDOM_ANGLE
                angle = ran:Float(0, d.angle - d.angleStep) + d.angleStep
            elseif m == 7 or m == 8 then                      -- RANDOM_SPEED / RANDOM
                speed = ran:Float(0, d.speed1 - d.speed2) + d.speed2
                if m == 7 then
                    angle = angle + i * (2 * PI) / count1
                    angle = angle + j * d.angleStep + d.angle
                else
                    ---★ RANDOM（8）= 角与速度**各自**随机，角走的还是
                    ---  `GetRandomF32InRange(angle − angleStep) + angleStep`（:146-149）：
                    ---  angle/angleStep 在这里当的是「角的区间端点」，不是「基准角 + 增量」。
                    angle = ran:Float(0, d.angle - d.angleStep) + d.angleStep
                end
            end
            spawn_one(d.recs, x, y, add_norm(angle), speed, d.btype, d.color,
                    d.flags, d.start)
        end
    end
end
EX.spawn_pattern = spawn_pattern

---SPAWN_CHILD_PATTERN（BulletManager.cpp:442-470）：一次吃**两条**记录。
---  主记录 payload = packedPattern(int0) / count1(int1) / speed1(float0) / speed2(float1)，
---  次记录 payload = count2(int0) / transformFlags(int1) / angle(float0) / angleStep(float1)。
---  packedPattern：bit31 = fadeParent、bit30..24 = aimMode、bit23..16 = 弹种、
---  bit15..8 = 色号、bit7..0 = 子弹的 transformStartIndex。
---★ 子波的 transforms 是**父弹的整块记录**（`memcpy(pattern.transforms, this->transforms)`）
---  ⇒ 直接把 self.ex_recs 传下去；子弹自己的 transformIndex 从 startIdx 起跑。
---★ fadeParent = 1 ⇒ 母弹当帧进 DESPAWNING（边飞边淡出、12 帧后回收）：富士山那颗
---  「火山弹」炸开之后自己就化掉了。
spawn_child = function(self, prim, sec)
    local u = prim.i0 % 4294967296                       -- 当成 u32 读
    spawn_pattern(self.x, self.y, {
        aimMode = math.floor(u / 16777216) % 128,
        btype = math.floor(u / 65536) % 256,
        color = math.floor(u / 256) % 256,
        count1 = prim.i1, count2 = sec.i0,
        speed1 = prim.f0, speed2 = prim.f1,
        angle = sec.f0, angleStep = sec.f1,
        flags = sec.i1, start = u % 256, recs = self.ex_recs,
    })
    if math.floor(u / 2147483648) % 2 == 1 then
        self.ex_despawn = EX.DESPAWN_FRAMES
    end
end

---一次出弹（DispatchShotInstruction，EclDependencies.cpp:681-770 +
---SpawnBulletPattern，BulletManager.cpp:686-712）。
---  who = 发射源（它身上挂着记录表）、x, y = 发射点（原作是 worldPosition + shootOffset）
---  a = { op, type, color, count1, count2, speed1, speed2, angle, step, flags[, start] }
---  op 只支持 96..99（FAN_AIMED / FAN / CIRCLE_AIMED / CIRCLE）—— EX 14 张卡
---  扫过一遍，这四种之外一条都没有；这四种正好一一对上 aimMode 0..3。
function EX.shoot(who, x, y, a)
    ---ONLY_WHEN_PLAYER_YOUKAI / HUMAN（:688-696）：移植版按「自机是人类」这一支，
    ---所以只打妖梦系的那一半不生。
    if bit_hit(a.flags, K_ONLY_YOUKAI) then return end
    spawn_pattern(x, y, {
        aimMode = a.op - 96, btype = a.type, color = a.color,
        count1 = a.count1 or 1, count2 = a.count2 or 1,
        speed1 = a.speed1, speed2 = a.speed2, angle = a.angle,
        angleStep = a.step, flags = a.flags, start = a.start,
        recs = copy_records(who),
    })
end
end

---------------------------------------------------------------
---卡 218「格兰吉纽尔剧场的怪人」（爱丽丝·玛格特洛依德）
---  ecldata_al.ecl：Sub1 = BOSS 根、Sub2 = 娃娃（使魔）、Sub3 = 娃娃的枪·环、
---  Sub4 = 娃娃的枪·自机狙扇形。
---  内容：16 个娃娃在半径 96 的圆上绕 BOSS 摊开、边公转边放弹。每 900 帧里，
---  娃娃的枪有 300 帧切成 Sub4（速度 8 的 3 路自机狙），其余 600 帧是 Sub3
---  （「直飞弹」和「2 秒后停住、再拐 144° 加速到 2.9 的弹」各一半）。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x−192、y' = 224−y、角度取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---Sub1（BOSS 根）的节拍，全部来自 ecldata_al.ecl Sub1 的裸字节。
local BOSS_END_Y = 96                       -- ins_64(110, 4, 192, 128)：TH08 y=128 → 我们 96
local BOSS_MOVE_FRAMES = 110                -- ... 的时长
local DOLL_SPAWN_FRAME = 110                -- 16 个 ins_92 全在这一帧
local WANDER_FIRST = 710                    -- 第一条 ins_67（710/770/830/890/950/1010…）
local WANDER_PERIOD = 60                    -- 之后每 60 帧一条
local WANDER_FRAMES = 60                    -- 每条 ins_67 的时长（参数 0）
local WANDER_SPEED = 1.0                    -- ... 的速度（参数 2）

---Sub2（娃娃）的节拍。
local ORBIT_RADIAL = 1.6                    -- op72 的 radialVelocity（Sub2 t=0）
local ORBIT_GROW_FRAMES = 60                -- op72 的 duration → 半径长到 96 就冻结
local ORBIT_ANGLE_SPEED = PI / 640          -- v10017 = 0.004908738658 rad/帧
local ORBIT_SPEEDUP = 1.03                  -- t=660+900k 的 `v10017 *= 1.03`
local GUN_SWITCH_FIRST = 660                -- t=660+900k → 枪切 Sub4；t=960+900k → 切回 Sub3
local GUN_CYCLE = 900

---两批娃娃的差别（Sub1 t=110 的两段循环体，裸字节实测）：
---  第一批 8 个：v10000 = 2（弹色 2）、v10018 = +0.104719758、v10017 = +0.004908738658
---  第二批 8 个：v10000 = 4、v10018 = −0.104719758、v10017 = −0.004908738658
---v10017 = 公转角速度、v10018 = 每发弹的偏角增量，两个都是 TH08 坐标系里的量，
---我们整体取反（见文件头），所以这里写的是**已经在「我们」坐标系里的值**。
---转弯角同理：op51 判 `v10018 >= 0` 跳去 −2.5132742 那条（Sub3 偏移 0x88），
---所以第一批（v10018 > 0）用 −2.5132742、第二批用 +2.5132742；取反后就是下表。
local DOLL_BATCHES = {
    { color = COLOR.RED,    angle_speed = -ORBIT_ANGLE_SPEED,
      shot_step = -0.10471975803375244,  turn_angle =  2.5132741928100586 },
    { color = COLOR.PURPLE, angle_speed =  ORBIT_ANGLE_SPEED,
      shot_step =  0.10471975803375244,  turn_angle = -2.5132741928100586 },
}
local DOLLS_PER_BATCH = 8                   -- v10036 = 8
local DOLL_ANGLE_STEP = PI / 4              -- v10016 每轮 += π/4

---Sub3/Sub4 的弹参数（op99 / op96 的 ShotArgs 裸字节）。
local GUN_SHOT_SPEED = 1.0                  -- op99 的 speed1
local FAN_STEP = 0.2617993950843811         -- op96 的 angleStep（15°）
local FAN_SPEED = 8.0                       -- op96 的 speed1
local FAN_OFFSETS = { 0, FAN_STEP, -FAN_STEP }  -- FAN_AIMED 的三路（BulletManager.cpp:118-127）
local SPAWN_FAST_FRAMES = 10                -- etama.anm script21（末尾 Delete 在 t=10）
local WAIT_FRAMES = 120                     -- op111 slot0 的 WAIT frames
local TURN_INTERVAL = 60                    -- op111 slot1 的 intervalFrames
local TURN_SPEED = 2.9                      -- ... 的 directionChange.speed
local POOL_SIZE = 1536                      -- BulletManager.hpp:455

---本卡自己的池子（= 原作那 1536 个弹槽）与娃娃登记表。
local dolls = {}
local pool = {}

---这颗弹还占着槽位吗。原作是「弹整体出屏那一帧回收」（BulletManager.cpp:885-900 的
---IsInBounds 带半个精灵宽高）；移植版用引擎的回收边界判，时机一致。
local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---本卡的弹类（定义在下面，先在这里声明：spawn_bullet 里要用到它）。
local bullet_218

---一次出弹。池满 → 整波不生（SpawnBulletPattern 的 BulletManager.cpp:686-690）。
local function spawn_bullet(x, y, angle, speed, color, turn)
    if pool_used() >= POOL_SIZE then
        return false
    end
    local unit = New(bullet_218, x, y, angle, speed, color, turn)
    pool[#pool + 1] = unit
    return true
end

---Sub3/Sub4 的弹（bulletType 2 / 6，都是 14×16 的小弹，占位用 ball_small）。
---  op99 = SHOOT_CIRCLE（EclManager.hpp:308）：count1=count2=1、speed1=1.0、
---  angle=v10020、color=v10000、flags=514（SPAWN_FAST|PLAY_SPAWN_SOUND）。
---  同一条 op99 在 Sub3 的 t=64 用的是 flags=131650 —— 多带 WAIT(0x20000) 与
---  CHANGE_DIRECTION_RELATIVE(0x40)，于是那颗弹会等 120 帧、再按 60 帧线性减速到 0、
---  然后 `angle += ±144°`、速度跳到 2.9 继续直飞（BulletManager.cpp:1255-1291）。
---  判据是 `(transformFlags & record->kind) == 0 → 跳过这条 record`（:328-332），
---  所以 flags=514 的弹两条 record 都不跑，纯直线。
---  两种弹都是 SPAWN_FAST：出生位置先减 velocity*4，之后 10 帧每帧 +velocity/2，
---  动画播完那一帧再照常走一遍 FIRED 的更新（BulletManager.cpp:250、953-957、:831）。
bullet_218 = Class(bullet, {
    init = function(self, x, y, angle, speed, color, turn)
        bullet.init(self, ball_small, color, false, true)
        self.alice_angle = angle
        self.alice_speed = speed
        self.alice_turn = turn
        self.alice_turn_timer = 0
        self.alice_turn_armed = false
        self.alice_wait = turn and WAIT_FRAMES or 0
        self.alice_spawn_left = SPAWN_FAST_FRAMES
        self.vx, self.vy = 0, 0             -- 位移全部自己在 frame 里算
        self.x = x - math.cos(angle) * speed * 4
        self.y = y - math.sin(angle) * speed * 4
    end,
    frame = function(self)
        local speed = self.alice_speed
        if self.alice_wait > 0 then
            -- WAIT 的 timer 每帧 -1，减到 <= 0 才把位清掉（BulletManager.cpp:848-854）
            self.alice_wait = self.alice_wait - 1
        elseif not self.alice_turn_armed then
            -- 清位那一帧不会激活下一条 record：AdvanceTransformProgram 在每帧**最前面**跑
            -- （:820），清位发生在同一帧的后面（:848），所以转向要等下一帧。
            self.alice_turn_armed = true
        elseif self.alice_turn then
            if self.alice_turn_timer >= TURN_INTERVAL then
                -- 拐弯：角度 += record.angle、速度 = record.speed，然后把位清掉
                self.alice_angle = self.alice_angle + self.alice_turn
                self.alice_speed = TURN_SPEED
                self.alice_turn = nil
                self.alice_turn_timer = 0
                speed = TURN_SPEED
            else
                -- 拐弯前先按 interval 线性减速到 0：magnitude = speed − timer*speed/interval
                speed = self.alice_speed
                        - self.alice_turn_timer * self.alice_speed / TURN_INTERVAL
                self.alice_turn_timer = self.alice_turn_timer + 1
            end
        end
        local vx = math.cos(self.alice_angle) * speed
        local vy = math.sin(self.alice_angle) * speed
        if self.alice_spawn_left > 0 then
            self.x = self.x + vx * 0.5
            self.y = self.y + vy * 0.5
            self.alice_spawn_left = self.alice_spawn_left - 1
            if self.alice_spawn_left == 0 then
                self.x = self.x + vx
                self.y = self.y + vy
            end
        else
            self.x = self.x + vx
            self.y = self.y + vy
        end
        bullet.frame(self)
    end,
})

---Sub3 t=60 / t=64 的那一发：角度 = 轨道角 + 逐发累积的偏角。
---op25 是 v10020 = v10077 + v10019，其中 v10077 = ECL_OPERAND_ORBIT_ANGLE
---（EclManager.hpp:478）—— 也就是娃娃当前的轨道角，用的是**上一帧末**的值。
---发完才 `v10019 += v10018`（op15）。
local function gun_shot(owner, turn)
    local angle = owner.alice_angle + owner.alice_gun_offset
    spawn_bullet(owner.x, owner.y, angle, GUN_SHOT_SPEED, owner.alice_color,
            turn and owner.alice_turn_angle or nil)
    owner.alice_gun_offset = owner.alice_gun_offset + owner.alice_shot_step
end

---Sub4 的 3 路自机狙（op96 = SHOOT_FAN_AIMED，EclManager.hpp:306）：
---count1=3、count2=1、speed1=8.0、angle=0、angleStep=0.261799395、bulletType=6、flags=514。
---FAN_AIMED 的角 = 自机方向 + 扇形偏移（BulletManager.cpp:118-127）。
local function gun_fan(owner)
    local aim = math.atan2(player.y - owner.y, player.x - owner.x)
    for i = 1, #FAN_OFFSETS do
        -- 生不出来 → 放弃整波剩下的（BulletManager.cpp:700-703）
        if not spawn_bullet(owner.x, owner.y, aim + FAN_OFFSETS[i], FAN_SPEED,
                owner.alice_color, nil) then
            return
        end
    end
end

---娃娃的枪（原作的子 ECL 槽 0，Sub2 用 op135 挂上/换掉）。
---  Sub3：t=60 发一发直飞弹、t=64 发一发「2 秒后拐弯」的弹，t=68 那条 `ins_4(60, −240)`
---  把 time 拨回 60 并**同帧**回到 t=60 的尾段（EclManager.cpp:239-243 的 JUMP 语义），
---  于是 t=60..68 这 8 帧一轮、每 4 帧一发，两种弹交替。
---  Sub4：t=120 发一轮 3 路自机狙，t=128 的 `ins_4(120, −44)` 每 8 帧跳回 t=120 那条。
local function gun_step(owner)
    local t = owner.alice_gun_time
    if owner.alice_gun_mode == 3 then
        if t == 60 or t == 68 then
            gun_shot(owner, false)
            if t == 68 then
                t = 60
            end
        elseif t == 64 then
            gun_shot(owner, true)
        end
    elseif t >= 120 and (t - 120) % 8 == 0 then
        gun_fan(owner)
    end
    owner.alice_gun_time = t + 1
end

---娃娃（Sub2）。占位贴图 "servant"；原作它有 24×24 判定与 life=9000，
---这里不给判定（99 秒内本来就打不死，给判定的意义只有干扰玩家）。
---（要改成可击破的实体就换 Class(enemy, ...) + object.Connect，见 AGENTS §7.4。）
local alice_doll = Class(object, {
    init = function(self, x, y, angle, info)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        if info.color == COLOR.RED then
            self._r, self._g, self._b = 255, 150, 150
        else
            self._r, self._g, self._b = 190, 150, 255
        end
        -- 公转圆心 = BOSS 生成娃娃时的位置（原作的 positionOffset 就写这一次，
        -- 之后 BOSS 乱走跟娃娃无关：EnemyManagerUpdate.cpp:170-176 只在
        -- inheritParentPosition 置位时才刷新，而这个位在 spawnTemplate 里是 0）
        self.alice_center_x, self.alice_center_y = x, y
        self.alice_angle = angle
        self.alice_radius = 0
        self.alice_radial = ORBIT_RADIAL
        self.alice_angle_speed = info.angle_speed
        self.alice_color = info.color
        self.alice_shot_step = info.shot_step
        self.alice_turn_angle = info.turn_angle
        self.alice_gun_offset = 0
        self.alice_gun_mode = 3             -- op135(0, 3)
        self.alice_gun_time = 0
        self.alice_t = 0                    -- 主 context 的 time
    end,
    frame = function(self)
        local t = self.alice_t
        -- ① 主 context（Sub2）的定时动作。
        --   原作 EclRun.cpp:181-209 的顺序是「主 context → 子 context → UpdateMovement」，
        --   所以 t=660+900k 那一帧是**先把枪换成 Sub4、再跑枪**（换枪那一帧不会再多打一发 Sub3）。
        if t == 60 then
            -- ins_74(12000, v10017, 0)：半径冻结在 96，角速度不变
            self.alice_radial = 0
        elseif t >= GUN_SWITCH_FIRST and (t - GUN_SWITCH_FIRST) % GUN_CYCLE == 0 then
            -- ins_135(0, 4) + ins_17(v10017 *= 1.03) + ins_74(12000, v10017, 0)
            self.alice_gun_mode = 4
            self.alice_gun_time = 0
            self.alice_angle_speed = self.alice_angle_speed * ORBIT_SPEEDUP
        elseif t >= GUN_SWITCH_FIRST + 300 and (t - GUN_SWITCH_FIRST - 300) % GUN_CYCLE == 0 then
            -- ins_135(0, 3)：切回 Sub3
            self.alice_gun_mode = 3
            self.alice_gun_time = 0
        end
        -- ② 子 context（枪）跟着跑；它用的世界坐标 / 轨道角都是**上一帧末**的值
        gun_step(self)
        -- ③ 最后才是 UpdateMovement 的 ORBIT 分支（EnemyManager.cpp:36-58）：
        --    orbitAngle += ω；orbitRadius += radial；position = origin + polar(angle, radius)
        self.alice_angle = self.alice_angle + self.alice_angle_speed
        if self.alice_angle > PI then
            self.alice_angle = self.alice_angle - 2 * PI
        elseif self.alice_angle < -PI then
            self.alice_angle = self.alice_angle + 2 * PI
        end
        if self.alice_radial ~= 0 and self.alice_radius > 96 - ORBIT_RADIAL * 0.5 then
            -- 半径按 op72 的 radialVelocity 长到 96 就停（op74 也会在 t=60 把它归零）
            self.alice_radial = 0
        end
        self.alice_radius = self.alice_radius + self.alice_radial
        self.x = self.alice_center_x + math.cos(self.alice_angle) * self.alice_radius
        self.y = self.alice_center_y + math.sin(self.alice_angle) * self.alice_radius
        self.rot = -self.alice_angle * RAD     -- 观感近似：娃娃朝自己前进的方向
        self.alice_t = t + 1
    end,
})

---Sub1 t=110 的两段循环：各 8 个 ins_92（SPAWN_FAMILIAR_INHERITING_POSITION），
---positionOffset = BOSS 当时的 position → 公转圆心 = BOSS 生成时的位置。
---v10016 从 −π 起每轮 += π/4，两批的起始角一模一样（第二批时 v10016 被重新赋 −π）。
local function spawn_dolls(owner)
    for batch = 1, #DOLL_BATCHES do
        local info = DOLL_BATCHES[batch]
        for k = 0, DOLLS_PER_BATCH - 1 do
            local th08_angle = -PI + k * DOLL_ANGLE_STEP
            local doll = New(alice_doll, owner.x, owner.y, -th08_angle, info)
            dolls[#dolls + 1] = doll
        end
    end
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---每帧 movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress；
---timer 到 0 时直接落在终点。本卡用的缓动都写 4 = OUT_QUADRATIC（EclManager.hpp:519-530），
---也就是 LuaSTG 的 VALUE_SET.DECEL 那条曲线（2n − n²）。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---`ins_75(32, 48, 352, 128)`（**生成助手** t=0 设的移动边界，同时置 CLAMP_POSITION）→
---我们坐标的夹框 x∈[−160,160]、y∈[96,176]；下面四条判据拿「边界 ±96/48」去比。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）把角卷进 (−π, π]。原作只对「自机在左」
---那一支做（EclDependencies.cpp:135-138），后面的符号判据全靠它。
local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---抽角度 + 四条边界修正，再交给 StartTimedPolarDisplacement（:105-126）
---（delta = (cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4）。
---★ 「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle`，用的是**上一段的
---  移动方向**、不是刚抽到的 angle —— 原作自己的怪癖，照抄，别「修」成 angle。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BW_TH_L + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.alice_movement_angle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.alice_movement_angle = angle
    owner.alice_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0,
    }
end

---BOSS 的每帧（原作是 enemy 的 interpolated movement，在 RunEcl 之后跑）。
---娃娃的生成排在位移**之前**：原作 RunEcl 里用的 worldPosition 就是上一帧末的位置。
local function boss_frame(owner)
    if not owner.alice_frame then return end
    local f = owner.alice_frame
    if f == DOLL_SPAWN_FRAME then
        spawn_dolls(owner)
    end
    local move = owner.alice_move
    if move == nil and f >= WANDER_FIRST and (f - WANDER_FIRST) % WANDER_PERIOD == 0 then
        begin_wander(owner)
        move = owner.alice_move
    end
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.alice_move = nil
        end
    end
    ---ClampPosition（EnemyManager.cpp:803-819）：生成助手的 `ins_75` 置了 CLAMP_POSITION，
    ---原作每帧在位移**前后**各钳一次（EnemyManagerUpdate.cpp:172-174）；这里位移只在本函数里变。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
    owner.alice_frame = f + 1
end

local function card_init(owner)
    -- 这张卡自己的帧计数器（boss 的 self.timer 是从出生算起的总帧数，不能用）
    owner.alice_frame = 0
    ---★ 落位：生成助手 Sub8 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    -- 位移恒 0 → movementAngle = VectorAngle(0, 0) = 0。
    owner.alice_movement_angle = 0
    owner.alice_move = {
        x0 = owner.x, y0 = owner.y,
        dx = 0 - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    -- 原作 Sub1 t=0 还有一堆「关掉射击、关判定、登记符卡」的指令：
    --   ins_105(0) 关自动射击、ins_110(0,0) 射击偏移归零、ins_113(-1,-1) 弹音效、
    --   ins_80(4) 关可伤害、ins_134(5940, 6) 设 99 秒时限、ins_122 START_SPELL、
    --   ins_95 清掉场上非 BOSS 敌机。
    --   移植版这些都由 boss 系统管（这张卡 t1 = t2 = t3，本来就打不动），
    --   t=110 的 ins_81(4) 开可伤害同理 —— 不另写。
end

local function card_del(owner)
    owner.alice_frame = nil
    owner.alice_move = nil
    for i = #dolls, 1, -1 do
        if IsValid(dolls[i]) then
            object.RawDel(dolls[i])
        end
        dolls[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[218] = {
    init = function(owner)
        dolls = {}
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 205「季节外调的蝴蝶风暴」（莉格露·奈特巴格）
---  ecldata1sp.ecl：Sub36 = BOSS 根、Sub37 = BOSS 的枪（CALL 进来的子程序）、
---  Sub38 = 子机（ins_94 生出来的独立敌机）。
---  下面每个节拍都用 /tmp/lw35/sim.py（照 EclRun.cpp 写的 ECL 解释器）逐帧模拟核对过：
---  执行条件是 `time == 指令.time`，JUMP/JUMP_DEC 会把 context 的 time **改写成目标的 time**，
---  CALL 压栈时父 context 的 time 冻结、帧末只给活动 context 的 time++（EclRun.cpp:96-209）。
---    · 一轮 302 帧：第 110 帧 CALL 37（Sub37 自己走 113 帧）→ 第 352 帧跑 t=240 那组
---      → 第 412 帧 t=300 的 JUMP 跳回 t=110。也就是 CALL 之间正好隔 302 帧，
---      5940 帧（99 秒）里 20 轮。
---    · t=240 那组**每轮只跑一次**（它的 JMP_INT_LT 目标不是自己那组，而是 t=300 的 JUMP）：
---      xi2++；xi2<3 就跳过「xi2=0、xi3++」直接去 JUMP；满 3 轮才 xi3++。
---      xi3 就是 ins_99 的 count1 → **每环弹数 6、6、6、7、7、7、8…**（每 3 轮 +1）。
---      同组还把 lf7/lf6/lf4 取反（cf0 = lf4 只影响本轮的旋转方向与槽 2 往哪边拐）。
---    · Sub37 一轮 48 个出弹帧：前 24 帧按「7 帧一组、组内偏移 0/3/5」，
---      后 24 帧同样 7 帧一组但组内偏移 0/2/5，两组之间换个符号做 lf2 的累加方向。
---      每个出弹帧：lf7 -= 0.006、lf0 += lf2（每组的第 3 块再 lf2 ± lf1）。
---    · 子机 Sub38：t=0 起什么都不做，t=300 开始**每 5 帧**打一发 24 颗的环
---      （speed1 = 4.5、angleStep = 15°）；13 发换一次极坐标加速方向（±0.4°/帧、120 帧），
---      **26 发重算一次自机方向**（= 130 帧）。
---  ins_99 = SHOOT_CIRCLE（EclManager.hpp:307，aimMode 3）：
---    args = (bulletType/color 打包, count1 = xi3, count2, speed1 = lf7, speed2 = 0.5,
---            angle = lf0, angleStep = 15°, transformFlags = 0xA6244)。
---    角度 = angle + i*(2π/count1) + j*angleStep（BulletManager.cpp:139-145），
---    速度 = count2 > 1 时 speed1 − (speed1−speed2)*j/count2（:83-92）。
---  ★ 难度掩码：判据是 `(mask & (difficultyMask|override)) == (difficultyMask|override)`
---    （EclRun.cpp:69-73），difficultyMask = 1 << difficulty（Lunatic = 8，GameManager.cpp:709），
---    override = 32（人类）/64（妖怪）（EnemyManager.cpp:903）。这张卡按 **Lunatic** 移植：
---    每个出弹帧的 3 条 ins_99 里 mask 0xff 与 mask 0xf8 的执行、mask 0xf4 的跳过
---    （那是 Hard 专用的重复波）。所以每帧 2 条：count2=1 一圈 + count2=2 两圈。
---  ★ 出生动画：transformFlags 带 SPAWN_NORMAL(4) → etama.anm 的 script22（15 帧，
---    etama8.decl script22 末尾 `+15:`）：出生瞬间位置先减 velocity*4，之后 15 帧每帧只走
---    velocity/2.5，第 16 帧（脚本走完那帧）再补一次完整位移并激活变换程序
---    （BulletManager.cpp:228-236、979-993 → :964 activateBullet）。子机的弹 flags = 544
---    没有 SPAWN_* → 出生当帧就是 FIRED（直接开始走变换程序）。
---  ★ 贴图占位：TH08 这张卡用 bulletType 0（初始）/ 3 / 8（蝴蝶）三种外观在飞行途中换，
---    这里拿 ball_small / ellipse / butterfly 顶替，TH08 的色号 c 对应我们的 1..16 号里的
---    c+1。17 张全实现完之后再统一换素材。
---  ★ 子机占位贴图 "servant"；它没有判定、不移动、也不参与碰撞。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_y(y) return 224 - y end

---节拍（裸字节 + 模拟核对）。
local BOSS_END_X, BOSS_END_Y = 0, 96        -- ins_64(110, 4, 192, 128) 的终点
local BOSS_MOVE_FRAMES = 110                -- ... 的时长
local FIRST_FRAME = 110                     -- 子机出生 + 第 1 次 CALL 37
local PERIOD = 302                          -- 一轮 302 帧（见上面那段）
local FAM_FIRST = 300                       -- 子机自己的 t=300 开始出弹
local FAM_PERIOD = 5                        -- 每 5 帧一发
local FAM_SWAP = 13                         -- 13 发换一次加速方向
local FAM_CYCLE = 26                        -- 26 发重算一次自机方向（=130 帧）

---同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455），
---activeBulletCount >= 0x600 时**整波不生**，波中间生不出来就放弃整波剩下的
---（BulletManager.cpp:686-712）。移植版没有全局弹池，本卡自己维护一张登记表。
local POOL_SIZE = 1536

---TH08 的场地（GameManager.cpp:132-155 的 IsWithinPlayfield：0..384 / 0..448）。
---弹飞出这里、且槽 0 的 400 帧回收延迟跑完之后才会被回收，所以这条边界必须自己判，
---不能让引擎按 bound 自动回收（那样弹一出屏就没了）。原作判据还带半个精灵宽高，
---这里从简（本卡的弹要么在场内、要么早就飞出很远，差这 16 px 不改变结论）。
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---ins_111 的 kind 位（BulletManager.hpp:429-455）。本卡 transformFlags = 680516 = 0xA6244
---把用到的几种全点亮了，所以程序里没有「按位与不上被跳过」的记录 —— 移植版直接把
---槽号顺序编成程序，运行时不用再按位与。
local K_ACCEL_POLAR = 0x20
local K_DIR_RELATIVE = 0x40
local K_CULL_DELAY = 0x2000
local K_SPRITE = 0x4000
local K_WAIT = 0x20000
local K_PLAY_SOUND = 0x80000

local SPAWN_NORMAL_FRAMES = 15              -- etama.anm script22 的长度（帧）

---Sub37 的 ins_99 参数。
local SHOT_SPEED2 = 0.5
local SHOT_STEP = 0.2617993950843811        -- angleStep = 15°
local SHOT_COLOR = 1                        -- TH08 色号 0 → 我们的 1 号色
local CULL_DELAY = 400                      -- 槽 0 的 frames
local WAIT_LONG = 60                        -- 槽 1
local WAIT_SHORT = 10                       -- 槽 6
local DIR_TURN_FRAMES = 30                  -- 槽 2 的 intervalFrames
local DIR_STOP_FRAMES = 60                  -- 槽 4 的 intervalFrames
local DIR_LAST_FRAMES = 10                  -- 槽 7 的 intervalFrames
local SOUND_INDEX = 27                      -- 槽 9（占位：不打音效）
local SPEED_DECAY = 0.006                   -- 每个出弹帧 lf7 -= 0.006

---子机 Sub38 的 ins_111(0, 32, 0, 120, -1, 0, ±0.006981317)：120 帧里每帧角度 ±0.4°、
---速度不变（4.5），于是弹画一条半径 4.5/0.006981317 ≈ 645 px 的圆弧。
local FAM_ANGLE_DELTA = 0.006981317
local FAM_SPEED = 4.5
local FAM_COUNT = 24
local FAM_COLOR_PLUS = 2                    -- TH08 色号 1 → 我们的 2 号色（+0.4°/帧）
local FAM_COLOR_MINUS = 4                   -- TH08 色号 3 → 我们的 4 号色（−0.4°/帧）

---本卡自己的池子（= 原作那 1536 个弹槽）。
local pool = {}

---池子里还活着几颗。原作是 BulletManager::OnUpdate 每帧边扫边数（BulletManager.cpp:814-818），
---这里只在出弹帧扫一次 —— 出弹帧之外池子不会变，少扫几千次。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---Sub37 的变换程序：10 条记录，**按槽号顺序**走（AdvanceTransformProgram 是
---`transformIndex++` 顺序扫，不是按 ECL 写的先后，BulletManager.cpp:310-333）。
---块（= 一轮里 7 帧周期的第几个出弹帧）决定槽 7/8；part 1 是块的第 1 发、
---part 2 是第 2·3 发（第 2 发在 Lunatic 上被掩码跳过，但它的槽 7 写在第 3 发之前，
---所以两发用同一份 part 2 程序）；sign = cf0 的符号，只影响槽 2 往哪边拐 90°。
local BLOCK = {
    { a_turn = 120,  a_speed = 2.8, b_turn = 120,  b_speed = 2.4, sprite = 7 },
    { a_turn = 180,  a_speed = 1.9, b_turn = 180,  b_speed = 2.4, sprite = 6 },
    { a_turn = -120, a_speed = 2.0, b_turn = -120, b_speed = 2.6, sprite = 5 },
}

local program_cache = {}

local function storm_program(block, part, sign)
    local key = ((block * 2 + part - 2) * 2) + (sign > 0 and 1 or 2)
    local p = program_cache[key]
    if p then return p end
    local blk = BLOCK[block]
    local turn, speed = blk.a_turn, blk.a_speed
    if part == 2 then turn, speed = blk.b_turn, blk.b_speed end
    ---槽 2 的 ±90°：TH08 里 cf0>=0 写的是 −1.5708（0x800c），取反之后我们要 +π/2。
    p = {
        { kind = K_CULL_DELAY,   allow = 1, frames = CULL_DELAY },                -- 槽 0
        { kind = K_WAIT,         allow = 1, frames = WAIT_LONG },                 -- 槽 1
        { kind = K_DIR_RELATIVE, allow = 0, angle = sign * PI / 2,                -- 槽 2
          keep_speed = true, interval = DIR_TURN_FRAMES, repeats = 1 },
        { kind = K_SPRITE,       allow = 0, style = ellipse, color = 2 },         -- 槽 3（type 3）
        { kind = K_DIR_RELATIVE, allow = 0, angle = -PI, speed = 0,               -- 槽 4
          interval = DIR_STOP_FRAMES, repeats = 1 },
        { kind = K_SPRITE,       allow = 0, style = ball_small, color = 14 },     -- 槽 5（type 0）
        { kind = K_WAIT,         allow = 1, frames = WAIT_SHORT },                -- 槽 6
        { kind = K_DIR_RELATIVE, allow = 0, angle = -turn * PI / 180,             -- 槽 7
          speed = speed, interval = DIR_LAST_FRAMES, repeats = 1 },
        { kind = K_SPRITE,       allow = 0, style = butterfly, color = blk.sprite }, -- 槽 8（type 8）
        { kind = K_PLAY_SOUND,   allow = 0, index = SOUND_INDEX },                -- 槽 9
    }
    program_cache[key] = p
    return p
end

---子机的弹：只有槽 0（极坐标加速 120 帧）。TH08 的 float1 是 angleDelta（±0.4°/帧）、
---float0 是 speedDelta（0），取反之后角度增量的符号翻过来。
local FAM_PROGRAM = {
    [FAM_COLOR_PLUS]  = { { kind = K_ACCEL_POLAR, allow = 0, frames = 120,
                            angle_delta = -FAM_ANGLE_DELTA, speed_delta = 0 } },
    [FAM_COLOR_MINUS] = { { kind = K_ACCEL_POLAR, allow = 0, frames = 120,
                            angle_delta = FAM_ANGLE_DELTA, speed_delta = 0 } },
}

local storm_bullet

---小弹（Sub37 和子机共用）。★ 位移全部自己在 frame 里算：LuaSTG 引擎每帧会替所有对象
---积分 x += vx（所以 vx/vy 必须留 0，否则每个位移都算两遍），速度矢量存在 bvx/bvy。
storm_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, program, color, spawn_frames)
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（槽 0 的 400 帧延迟）
        self.angle = angle                  -- 极坐标里的角
        self.speed = speed
        self.bvx = math.cos(angle) * speed  -- 真正用来位移的矢量
        self.bvy = math.sin(angle) * speed
        self.vx, self.vy = 0, 0             -- 引擎的自动积分必须保持 0
        ---出生动画：位置先退 velocity*4（BulletManager.cpp:228-236）。
        self.x = x - self.bvx * 4
        self.y = y - self.bvy * 4
        self.tf_program = program
        self.tf_index = 1
        self.tf_busy = 0                    -- 正在跑的变换数（原作的 activeTransformFlags != 0）
        self.tf_cull = 0                    -- 回收延迟
        self.tf_off = 0                     -- 出屏帧数
        self.tf_spawn = spawn_frames
    end,
    frame = function(self)
        ---① 出生动画：每帧只走 velocity/2.5；脚本走完那帧（第 16 次调用）再走一次完整位移
        ---并接着跑变换程序（BulletManager.cpp:979-993 → :964 activateBullet）。
        if self.tf_spawn then
            self.x = self.x + self.bvx * 0.4
            self.y = self.y + self.bvy * 0.4
            if self.tf_spawn > 0 then
                self.tf_spawn = self.tf_spawn - 1
                bullet.frame(self)
                return
            end
            self.tf_spawn = nil
        end
        ---② 变换程序：每帧至多应用一条会占位的记录；「即时记录」在同一次调用里继续往下走
        ---（BulletManager.cpp:310-482）。
        local program = self.tf_program
        while self.tf_index <= #program do
            local r = program[self.tf_index]
            if r.allow == 0 and self.tf_busy > 0 then break end
            local kind = r.kind
            self.tf_index = self.tf_index + 1
            if kind == K_CULL_DELAY then
                self.tf_cull = r.frames
            elseif kind == K_SPRITE then
                self:ChangeImage(r.style, r.color)
            elseif kind == K_PLAY_SOUND then
                -- 原作是 PlaySoundPositionedByIdx(27, x)，占位：不出声
            elseif kind == K_WAIT then
                self.tf_wait = r.frames
                self.tf_busy = self.tf_busy + 1
                break
            elseif kind == K_DIR_RELATIVE then
                self.tf_dir_angle = r.angle
                ---方向变换记录里 speed < -999（这里是 keep_speed）= 应用那一刻的当前速度
                ---（BulletManager.cpp:379-381）。
                self.tf_dir_speed = r.keep_speed and self.speed or r.speed
                self.tf_dir_interval = r.interval
                self.tf_dir_repeats = r.repeats
                self.tf_dir_timer = 0
                self.tf_dir_done = 0
                self.tf_dir = true
                self.tf_busy = self.tf_busy + 1
                break
            elseif kind == K_ACCEL_POLAR then
                self.tf_pol_angle = r.angle_delta
                self.tf_pol_speed = r.speed_delta
                self.tf_pol_end = r.frames
                self.tf_pol_timer = 0
                self.tf_pol = true
                self.tf_busy = self.tf_busy + 1
                break
            end
        end
        ---③ 各 Update —— 顺序照 BulletManager.cpp:824-857（极坐标加速 → 方向变换 → WAIT）。
        if self.tf_pol then
            if self.tf_pol_timer >= self.tf_pol_end then
                self.tf_pol = false
                self.tf_busy = self.tf_busy - 1
            else
                self.angle = self.angle + self.tf_pol_angle
                self.speed = self.speed + self.tf_pol_speed
                self.bvx = math.cos(self.angle) * self.speed
                self.bvy = math.sin(self.angle) * self.speed
            end
            self.tf_pol_timer = self.tf_pol_timer + 1   -- 最后那帧也 ++（:1250）
        end
        if self.tf_dir then
            local timer = self.tf_dir_timer
            local magnitude
            if timer >= self.tf_dir_interval then
                ---拐弯：角度 += record.angle、速度 = record.speed；拐够 repeat 次才清位
                ---（BulletManager.cpp:1255-1291）。
                self.tf_dir_done = self.tf_dir_done + 1
                if self.tf_dir_done >= self.tf_dir_repeats then
                    self.tf_dir = false
                    self.tf_busy = self.tf_busy - 1
                end
                self.angle = self.angle + self.tf_dir_angle
                self.speed = self.tf_dir_speed
                magnitude = self.speed
                self.tf_dir_timer = 1       -- 拐弯分支里 timer 归 0，函数末尾还要 ++
            else
                ---拐弯前按 interval 线性减速到 0：speed − timer*speed/interval（:1284-1289）。
                magnitude = self.speed - timer * self.speed / self.tf_dir_interval
                self.tf_dir_timer = timer + 1
            end
            self.bvx = math.cos(self.angle) * magnitude
            self.bvy = math.sin(self.angle) * magnitude
        end
        if self.tf_wait then
            if self.tf_wait > 0 then
                self.tf_wait = self.tf_wait - 1
            else
                ---清位那一帧不会激活下一条记录（AdvanceTransformProgram 在每帧最前面跑）。
                self.tf_wait = false
                self.tf_busy = self.tf_busy - 1
            end
        end
        ---④ 位移（BulletManager.cpp:859-860）。
        self.x = self.x + self.bvx
        self.y = self.y + self.bvy
        ---⑤ 出界回收（:862-893）：回收延迟跑完才判；正在转向的弹多给 128 帧机会。
        if self.tf_cull > 0 then
            self.tf_cull = self.tf_cull - 1
        end
        if self.tf_cull == 0 then
            if self.x < FIELD_L or self.x > FIELD_R
                    or self.y < FIELD_B or self.y > FIELD_T then
                if self.tf_dir then
                    self.tf_off = self.tf_off + 1
                    if self.tf_off >= 128 then
                        object.RawDel(self)
                        return
                    end
                else
                    if self.tf_off == 0 then
                        object.RawDel(self)       -- 原作的 Deactivate()：静默回收，不给碎片
                        return
                    end
                    self.tf_off = self.tf_off - 1
                end
            else
                self.tf_off = 0
            end
        end
        bullet.frame(self)
    end,
})

---一条 ins_99。生不出来就放弃整波剩下的（BulletManager.cpp:700-703）。
local function storm_shot(owner, base_angle, speed1, block, part, count1, count2, used)
    if used >= POOL_SIZE then return used end
    local program = storm_program(block, part, owner.lw205_sign)
    for j = 0, count2 - 1 do
        local speed = speed1
        if count2 > 1 then
            speed = speed1 - (speed1 - SHOT_SPEED2) * j / count2
        end
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then return used end
            ---TH08 的角度是 base + i*(2π/count1) + j*angleStep，我们整体取反。
            local angle = base_angle - i * (2 * PI / count1) - j * SHOT_STEP
            pool[#pool + 1] = New(storm_bullet, owner.x, owner.y, angle, speed,
                    program, SHOT_COLOR, SPAWN_NORMAL_FRAMES)
            used = used + 1
        end
    end
    return used
end

---Sub37 的 48 个出弹帧（相对 CALL 那一帧），逐字节 + 模拟核对：
---第 1 段 8 组 × 7 帧、组内偏移 0/3/5；第 2 段（起点 56）同样 7 帧一组、组内偏移 0/2/5。
---inc = 该帧收尾时 lf2 怎么变（第 1 段 +lf1、第 2 段 −lf1，只发生在每组的第 3 块）。
local SUB37_SHOTS = {}
do
    local n = 0
    local function push(base, off, inc)
        n = n + 1
        SUB37_SHOTS[n] = { frame = base + off, block = ((n - 1) % 3) + 1, inc = inc }
    end
    for i = 0, 7 do
        local base = 7 * i
        push(base, 0, 0)
        push(base, 3, 0)
        push(base, 5, 1)
    end
    for i = 0, 7 do
        local base = 56 + 7 * i
        push(base, 0, 0)
        push(base, 2, 0)
        push(base, 5, -1)
    end
end

---子机（Sub38）。占位贴图 "servant"；不移动、不给判定。
local familiar = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self._r, self._g, self._b = 190, 255, 175
        self.fam_t = 0
        self.fam_aim = 0
    end,
    frame = function(self)
        local t = self.fam_t
        if t >= FAM_FIRST and (t - FAM_FIRST) % FAM_PERIOD == 0 then
            local k = (t - FAM_FIRST) / FAM_PERIOD          -- 第几发（0 起）
            if k % FAM_CYCLE == 0 then
                ---ins_7(lf0, AIM_TO_PL)：这一发之后 130 帧都用这个方向。
                ---（y 翻转之后用我们自己的坐标直接算 atan2 就是同一个角。）
                self.fam_aim = math.atan2(player.y - self.y, player.x - self.x)
            end
            if pool_used() < POOL_SIZE then
                local first = (k % FAM_CYCLE) < FAM_SWAP     -- 前 13 发一个方向、后 13 发反过来
                local color = first and FAM_COLOR_PLUS or FAM_COLOR_MINUS
                local program = FAM_PROGRAM[color]
                for i = 0, FAM_COUNT - 1 do
                    if pool_used() >= POOL_SIZE then break end
                    local angle = self.fam_aim - i * (2 * PI / FAM_COUNT)
                    pool[#pool + 1] = New(storm_bullet, self.x, self.y, angle, FAM_SPEED,
                            program, color, nil)
                end
            end
        end
        self.fam_t = t + 1
    end,
})

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：movementTimer-- →
---progress = 1 − timer/duration → 缓动 → position = origin + delta·progress。
---ins_64 的缓动 4 = OUT_QUADRATIC（EclManager.hpp:519-530）= 1−(1−u)²。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---BOSS（Sub36）每帧。原作顺序是 RunEcl（出弹）→ UpdateMovement（位移），
---所以出弹用的是**上一帧末**的位置（EnemyManagerUpdate.cpp:159-192）。
local function boss_frame(owner)
    ---★ boss 系统在 card.init 之前就会先跑一段 card.before（tools/check_stage.lua:1660-1680
    ---  也照抄了这个顺序），那几帧 frame 里 alice/lw205_frame 还是 nil；卡 218 同款守卫。
    if not owner.lw205_frame then return end
    local f = owner.lw205_frame
    if f == FIRST_FRAME then
        ---ins_94(38, 0, 0, 0, 9000, -2, 10)：子机的出生点 = BOSS 当时的 worldPosition。
        owner.lw205_fam = New(familiar, owner.x, owner.y)
    end
    ---t=110 那组的循环体（每 302 帧一次）：PLAY_SPECIAL_ANM + scf0 = lf4 + CALL 37。
    if f >= FIRST_FRAME and (f - FIRST_FRAME) % PERIOD == 0 then
        local i = (f - FIRST_FRAME) / PERIOD + 1            -- 第几轮（1 起）
        ---cf0 每轮在 t=240 取反一次 → 第 1 轮 +、第 2 轮 − ……
        owner.lw205_sign = (i % 2 == 1) and 1 or -1
        ---xi3：每 3 轮 +1（t=240 的 xi2<3 分支），是 ins_99 的 count1。
        owner.lw205_count1 = 6 + math.floor((i - 1) / 3)
        owner.lw205_angle = ran:Float(-PI, PI)              -- ins_7(lf0, RANDOM_ANGLE)
        owner.lw205_step = -owner.lw205_sign * 0.0392699093 -- lf2 = cf0（取反）
        owner.lw205_inc = -owner.lw205_sign * 0.00392699093 -- lf1 = cf0*0.1（取反）
        owner.lw205_speed1 = 2.2                            -- lf7 = 1.2 + 1
        owner.lw205_base = f
        owner.lw205_cursor = 1
    end
    local shots = SUB37_SHOTS
    local used = -1
    while owner.lw205_cursor <= #shots do
        local e = shots[owner.lw205_cursor]
        if owner.lw205_base + e.frame > f then break end
        if owner.lw205_base + e.frame == f then
            if used < 0 then used = pool_used() end
            local c1 = owner.lw205_count1
            local sp = owner.lw205_speed1
            local ang = owner.lw205_angle
            ---Lunatic：mask 0xff（count2=1）与 mask 0xf8（count2=2）执行，mask 0xf4 跳过。
            used = storm_shot(owner, ang, sp, e.block, 1, c1, 1, used)
            used = storm_shot(owner, ang, sp, e.block, 2, c1, 2, used)
            ---ins_16(lf7, 0.006) / ins_15(lf0, lf2) /（每组的第 3 块）lf2 ± lf1
            owner.lw205_speed1 = sp - SPEED_DECAY
            owner.lw205_angle = ang + owner.lw205_step
            if e.inc > 0 then
                owner.lw205_step = owner.lw205_step + owner.lw205_inc
            elseif e.inc < 0 then
                owner.lw205_step = owner.lw205_step - owner.lw205_inc
            end
        end
        owner.lw205_cursor = owner.lw205_cursor + 1
    end
    ---ins_64(110, 4, 192, 128)：从出生点插值到 (0,96)。
    local move = owner.lw205_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw205_move = nil
        end
    end
    ---t=240 的 ins_67(60, 4, 0)：速度参数是 0 → 位移恒 0（只有那条没人用的随机角被算出来
    ---又丢掉），所以 BOSS 从第 110 帧起就停在 (0,96)，不另写。
    owner.lw205_frame = f + 1
end

local function card_init(owner)
    owner.lw205_frame = 0
    owner.lw205_sign = 1
    owner.lw205_count1 = 6
    owner.lw205_angle = 0
    owner.lw205_step = 0
    owner.lw205_inc = 0
    owner.lw205_speed1 = 2.2
    owner.lw205_base = -1000000
    owner.lw205_cursor = 1
    owner.lw205_fam = nil
    ---★ 落位：生成助手 Sub42 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    owner.lw205_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub36 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw205_frame 它就会继续按 302 帧的周期出弹（踩过：卡结束后 180 帧还在新建
    ---  864 个对象）。卡 218 的 card_del 也是这么清的。
    owner.lw205_frame = nil
    owner.lw205_move = nil
    ---★ 子机是普通 object，del 里必须自己回收 —— 它内部每 5 帧打一发环、不会自己停，
    ---  漏掉的话卡结束后它还在无限出弹（踩过：卡结束后 180 帧还在新建对象）。
    if owner.lw205_fam and IsValid(owner.lw205_fam) then
        object.RawDel(owner.lw205_fam)
    end
    owner.lw205_fam = nil
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
    pool = {}
end

CARD[205] = {
    init = function(owner)
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 206「盲夜鸟」（米斯蒂娅·萝蕾拉）
---  ecldata2sp.ecl：Sub46 = BOSS 根、Sub47 = 子 context 3、Sub48 = 子 context 0。
---  这张卡**没有独立敌机**：两条子 context 都用 ins_135(SET_CHILD_ECL) 挂在 BOSS 自己
---  身上，弹全部从 BOSS 的位置出。下面的节拍用 /tmp/lw206/sim206.py（照 EclRun.cpp 写的
---  ECL 解释器：`time == 指令.time` 才执行、JUMP/JUMP_DEC 把 context 的 time 改写成目标的
---  time、帧末只给活动 context 的 time++）逐帧核对过。
---
---  · 根 Sub46：110 帧插值移动到 (0,96)；t=140 装 Sub47、t=170 装 Sub48；t=370 起空转。
---  · Sub47 是**夜盲症画面效果**：CALL_EX_INSTRUCTION(0,0) = g_EclExInsn[0]
---    = ConfigureNightBlindness（EclGlobals.cpp:65、EclExIns.cpp:30-34），把 li0/lf0
---    写进 g_AsciiManager 的 alpha / 半径，画成「以自机为中心的洞 + 洞外一片黑」
---    （AsciiManager.cpp:1627-1691）。半径 320→96（120 帧）、再 96→64（1800 帧），
---    alpha 0→255（10 帧）。移植成下面 lw206_blind 那个自绘 object。
---  · Sub48 是真正的出弹程序，一轮 396 帧：
---      t=0..95   每帧一发 ins_97（SHOOT_FAN）：count1=1、count2=8 → **同一角度、速度从
---                8 递减到 2.75 的 8 颗「虚线流」**；角度以自机方向 ±90° 起步、每帧转 7.5°，
---                4 段各 24 帧（第 1/3 段同向、第 2/4 段反向；色 6 / 8 交替）。
---      t=96      先跑 ins_67(60,4,1.0)：BOSS 沿「边界感知随机方向」漂 60 px（60 帧缓动），
---                紧接着 ins_99（SHOOT_CIRCLE）：count1 = xi3 的一圈速度 1.3 + 一圈速度 0.5、
---                随机基准角；之后每 20 帧一发、共 15 发。
---      一轮结束时 xi3 += 6（32 → … → 68 封顶）→ 环越打越密。
---  ★ 自机方向**整个卡只算一次**：Sub48 末尾的 JUMP 目标落在 `xi3 = 32` **之后**
---    （反汇编核对：rel=1048 的 ins_4(0,−1028) 指向 rel=20，不是 rel=0），所以
---    `lf3 = AIM_TO_PL` 从挂上来那一帧就冻住了。
---  ★ 出生动画：ins_97 的 transformFlags = 0x202 带 SPAWN_FAST(0x2) → 出生瞬间位置先退
---    velocity*4，之后每帧只走 velocity/2；etama8.decl script21 是 `+10: ins_1`
---    （脚本要 11 次调用才结束），走完那帧再补一次完整位移
---    （BulletManager.cpp:228-236、950-968）。ins_99 的 flags = 0x200 只有
---    PLAY_SPAWN_SOUND → 出生当帧就是 FIRED，立刻按全速走。
---  ★ 贴图占位：ins_97 的 bulletType 6、ins_99 的 bulletType 1 都先拿 ball_small 顶，
---    TH08 色号 c → 我们的 c+1；夜盲症用 Resources/Special/Blindness.png。
---    17 张全实现完之后再统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---节拍（Sub46/47/48 的裸字节）。
local BOSS_END_X, BOSS_END_Y = 0, 96
local BOSS_MOVE_FRAMES = 110
local BLIND_FRAME = 140                 -- ins_135(3, 47)
local SHOT_FRAME = 170                  -- ins_135(0, 48)
local ROUND = 396                       -- 一轮 396 帧
local STREAM_FRAMES = 96                -- 前 96 帧：每帧一发 8 连虚线流
local RING_FIRST = 96                   -- 从 t=96 起每 20 帧一发环
local RING_PERIOD = 20
local RING_SHOTS = 15
local MOVE_FRAMES = 60                  -- ins_67(60, 4, 1.0)
local MOVE_SPEED = 1.0

local FAN_COUNT = 8                     -- count2
local FAN_SPEED = 8.0                   -- lf0 初值（每个 24 帧段开头重置成 8）
local FAN_SPEED_DECAY = 0.25            -- 每帧 lf0 -= 0.25
local FAN_SPEED2_RATIO = 0.25           -- speed2 = lf0/4（ins_28(lf2, lf0, 4)）
local FAN_ANGLE0 = 1.5707963705062866   -- ±π/2（ins_25/26 的 1.5708）
local FAN_ANGLE_STEP = 0.13089969754219055  -- 每帧 ±7.5°
local FAN_BLOCK = 24

local RING_SPEED1 = 1.2999999523162842
local RING_SPEED2 = 0.5
---xi3（ins_99 的 count1）：初值 32，每轮收尾 `JMP_INT_GE(xi3, 64)` 不成立就 +6，
---所以是 32,38,44,50,56,62,68,68,…（判的是「加之前到没到 64」，于是跳过 64 直接到 68）。
local RING_COUNT0, RING_COUNT_STEP, RING_COUNT_MAX = 32, 6, 68
local RING_COLOR = 11                   -- TH08 色号 10 → 我们的 11

---出生动画：SPAWN_FAST 的脚本（etama8.decl script21）里 `+10: ins_1` → 一共 11 次调用，
---所以前 11 帧每帧只走 velocity/2，脚本走完那一帧再补一次完整位移。
local SPAWN_FAST_FRAMES = 10

---同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455 `Bullet bullets[0x601]`），
---activeBulletCount >= 0x600 时**整波不生**、波中间生不出来就放弃整波剩下的
---（BulletManager.cpp:686-712）。移植版没有全局弹池，本卡自己维护一张登记表。
local POOL_SIZE = 1536

---TH08 的场地（GameManager.cpp:132-155 的 IsWithinPlayfield：0..384 / 0..448）。
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---夜盲症的三条 ins_36。INSTALL_INTERPOLATION 的操作数是
---[目标 float 变量, 时长, 回调号, 缓动, p0, p1, p2, p3]（EclDependencies.cpp:356-383），
---回调 0..6 全是 InterpolateLinear（EclGlobals.cpp:16-25），缓动 0 = 线性。
local BLIND_R0, BLIND_R1, BLIND_R_FRAMES = 320, 96, 120
local BLIND_R2, BLIND_R2_FRAMES = 64, 1800
local BLIND_A_FRAMES = 10
local BLIND_LOOP = 125                  -- 循环 125 次之后换第二条半径插值

---本卡自己的池子（= 原作那 1536 个弹槽）。
local pool = {}

---池子里还活着几颗。原作是 BulletManager::OnUpdate 每帧边扫边数
---（BulletManager.cpp:810-818），这里只在出弹帧扫一次 —— 出弹帧之外池子不会变。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local lw206_bullet

---本卡的弹。★ 位移全部自己在 frame 里算：LuaSTG 引擎每帧会替所有对象积分 x += vx
---（所以 vx/vy 必须留 0，否则每个位移都算两遍），速度矢量存在 bvx/bvy。
lw206_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, style, color, spawn_frames)
        bullet.init(self, style, color, false, true)
        self.bound = false                  -- 出屏回收自己判
        self.angle = angle                  -- 我们坐标下的方向
        self.speed = speed
        self.bvx = math.cos(angle) * speed
        self.bvy = math.sin(angle) * speed
        self.vx, self.vy = 0, 0             -- 引擎的自动积分必须保持 0
        self.spawn = spawn_frames
        if spawn_frames then
            ---出生动画：位置先退 velocity*4（BulletManager.cpp:228-236）。
            self.x = x - self.bvx * 4
            self.y = y - self.bvy * 4
        else
            self.x, self.y = x, y
        end
    end,
    frame = function(self)
        ---① 出生动画（BulletManager.cpp:950-968）：每帧只走 velocity/2；脚本走完那帧
        ---   `goto activateBullet` → 同一帧再走一次完整位移。
        if self.spawn then
            self.x = self.x + self.bvx * 0.5
            self.y = self.y + self.bvy * 0.5
            if self.spawn > 0 then
                self.spawn = self.spawn - 1
                bullet.frame(self)
                return
            end
            self.spawn = nil
        end
        ---② 本卡的弹没有任何变换程序（Sub48 里没有 ins_111），直接匀速直线。
        self.x = self.x + self.bvx
        self.y = self.y + self.bvy
        ---③ 出界回收（BulletManager.cpp:862-893）：原作判的是「中心出屏超过半个精灵」，
        ---   这里从简用场地本身（本卡的弹要么在场内、要么早就飞远了）。
        if self.x < FIELD_L or self.x > FIELD_R
                or self.y < FIELD_B or self.y > FIELD_T then
            object.RawDel(self)
            return
        end
        bullet.frame(self)
    end,
})

---Sub47 的夜盲症。原作是纯画面效果（写在 AsciiManager 里），这里做成一个跟着自机走的
---object：洞内画 Blindness 贴图、洞外补四块黑。alpha/半径的插值口径照抄 Sub47。
local lw206_blind = Class(object, {
    init = function(self)
        self.img = "Blindness"
        self.layer = LAYER.ENEMY_BULLET_EF + 1
        self.group = GROUP.INDES
        self.hide, self.bound, self.navi, self.colli = false, false, false, false
        self._blend, self._a, self._r, self._g, self._b = "", 255, 255, 255, 255
        self.bl = 0
        self.alpha = 0
        self.radius = BLIND_R0
    end,
    frame = function(self)
        local bl = self.bl
        self.bl = bl + 1
        self.x, self.y = player.x, player.y
        ---alpha：lf1 的 10 帧插值。li0 = (int)lf1 只在头 10 帧里被读，之后固定 255。
        local a = bl * 255 / BLIND_A_FRAMES
        if a > 255 then a = 255 end
        self.alpha = a
        ---半径：LF0 的 320→96（120 帧），第 125 帧换成 96→64（1800 帧）。
        if bl < BLIND_LOOP then
            local u = bl
            if u > BLIND_R_FRAMES then u = BLIND_R_FRAMES end
            self.radius = BLIND_R0 + (BLIND_R1 - BLIND_R0) * u / BLIND_R_FRAMES
        else
            local u = bl - (BLIND_LOOP - 1)
            if u > BLIND_R2_FRAMES then u = BLIND_R2_FRAMES end
            self.radius = BLIND_R1 - (BLIND_R1 - BLIND_R2) * u / BLIND_R2_FRAMES
        end
    end,
    render = function(self)
        local a = self.alpha
        if a <= 0 then return end
        local r = self.radius
        local w = lstg.world
        ---洞外四块黑（AsciiManager.cpp:1630-1676 的四个 DrawSquare；参数序是 l, r, b, t）。
        SetImageState("white", "", a, 0, 0, 0)
        if self.x - r > w.l then RenderRect("white", w.l, self.x - r, w.b, w.t) end
        if self.x + r < w.r then RenderRect("white", self.x + r, w.r, w.b, w.t) end
        if self.y - r > w.b then RenderRect("white", w.l, w.r, w.b, self.y - r) end
        if self.y + r < w.t then RenderRect("white", w.l, w.r, self.y + r, w.t) end
        ---洞本身：原作把 128×128 的贴图缩放成半径/63（≈ 直径 2r）。
        SetImageState("Blindness", "", a, 255, 255, 255)
        Render("Blindness", self.x, self.y, 0, r / 64, r / 64)
    end,
})

---一条 ins_97（SHOOT_FAN）：count1 = 1、count2 = 8。
---角度只跟 index1 走（count1=1 → 偏移 0），index2 只改速度：
---speed_j = speed1 − (speed1−speed2)·j/count2（BulletManager.cpp:83-92、139-145）。
local function lw206_shot_fan(owner, angle, speed1, color)
    local used = pool_used()
    if used >= POOL_SIZE then return end
    local speed2 = speed1 * FAN_SPEED2_RATIO
    for j = 0, FAN_COUNT - 1 do
        if used >= POOL_SIZE then return end
        local speed = speed1 - (speed1 - speed2) * j / FAN_COUNT
        pool[#pool + 1] = New(lw206_bullet, owner.x, owner.y, angle, speed,
                ball_small, color, SPAWN_FAST_FRAMES)
        used = used + 1
    end
end

---一条 ins_99（SHOOT_CIRCLE）：count1 = xi3、count2 = 2、speed1 = 1.3、speed2 = 0.5、
---angle = RANDOM_ANGLE（一次指令只抽一个基准角，两圈共用）。
---角度 = angle + i·(2π/count1) + j·angleStep，我们整体取反。
local function lw206_shot_circle(owner, count1)
    local used = pool_used()
    if used >= POOL_SIZE then return end
    local base = ran:Float(-PI, PI)
    for j = 0, 2 - 1 do
        local speed = RING_SPEED1 - (RING_SPEED1 - RING_SPEED2) * j / 2
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then return end
            local angle = base - i * (2 * PI / count1)
            pool[#pool + 1] = New(lw206_bullet, owner.x, owner.y, angle, speed,
                    ball_small, RING_COLOR, nil)
            used = used + 1
        end
    end
end

---ins_67 = BeginBoundaryAwareMove（EclDependencies.cpp:128-191）。本卡从没跑过 ins_75，
---movementBounds 一直是 (0,0,0,0)，于是四条判据退化成：
---  · x < 96（TH08）才左反射；
---  · x > −96 **恒真** → 这一段里的 `π − enemy->movementAngle` 用的是**上一段位移的方向**
---    （原作这里就是这么写的，照抄，不要「修」成 angle）；
---  · y > 176（我们坐标）且角度朝上才翻；
---  · y < 272 **恒真** → 正角度一律翻成负（TH08 里就是永远往上飞）。
---返回的是 **TH08 角度**（和原作的比较口径一致），调用处再取反成我们的角度。
local function lw206_move_angle(owner)
    local ex8 = to_th08_x(owner.x)
    local ey8 = to_th08_y(owner.y)
    local px8 = to_th08_x(player.x)
    local angle
    if px8 < ex8 then
        ---AddNormalizeAngle(..., 0)（Global.cpp:1239-1252）把结果卷进 [−π, π]；
        ---后面的符号判据靠这个，必须照做。
        angle = ran:Float(0, PI / 2) + 2.3561945
        if angle > PI then angle = angle - 2 * PI end
    else
        angle = ran:Float(0, PI / 2) - 0.78539819
    end
    if ex8 < 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if ex8 > -96 then
        if angle >= 0 and angle < PI / 2 then
            angle = PI - owner.lw206_mangle
        elseif angle <= 0 and angle > -PI / 2 then
            angle = -PI - angle
        end
    end
    if ey8 < 48 and angle < 0 then
        angle = -angle
    end
    if ey8 > -48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：movementTimer-- →
---progress = 1 − timer/duration → 缓动 → position = origin + delta·progress。
---ins_67 的缓动 4 = OUT_QUADRATIC（EclManager.hpp:519-530）= 1−(1−u)²。
local function lw206_move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---BOSS（Sub46 + 两条子 context）每帧。原作顺序是 RunEcl（主 context → 子 context 3 →
---子 context 0）→ UpdateMovement，所以出弹用的是**上一帧末**的位置
---（EnemyManagerUpdate.cpp:159-192）。
local function boss_frame(owner)
    ---★ boss 系统在 card.init 之前就会先跑一段 card.before（tools/check_stage.lua 也照抄了
    ---  这个顺序），那几帧 frame 里 lw206_t 还是 nil；卡 205/218 同款守卫。
    if not owner.lw206_t then return end
    local f = owner.lw206_t
    if f == BLIND_FRAME then
        ---ins_135(3, 47)：子 context 3 = 夜盲症。
        owner.lw206_blind = New(lw206_blind)
    end
    if f >= SHOT_FRAME then
        ---子 context 0（Sub48）的 time：挂上来那一帧是 0。
        local ct = (f - SHOT_FRAME) % ROUND
        if f == SHOT_FRAME then
            ---ins_7(lf3, AIM_TO_PL)：整个卡只算这一次（见文件头）。
            owner.lw206_aim = math.atan2(player.y - owner.y, player.x - owner.x)
        end
        if ct < STREAM_FRAMES then
            ---t=0..95：4 段 × 24 帧。第 1/3 段从「自机方向 +90°」起步、每帧 −7.5°；
            ---第 2/4 段从 −90° 起步、每帧 +7.5°（色 6 / 8 交替）。
            local block = math.floor(ct / FAN_BLOCK)
            local i = ct % FAN_BLOCK
            local speed1 = FAN_SPEED - FAN_SPEED_DECAY * i
            local angle
            if block % 2 == 0 then
                angle = owner.lw206_aim - FAN_ANGLE0 + FAN_ANGLE_STEP * i
            else
                angle = owner.lw206_aim + FAN_ANGLE0 - FAN_ANGLE_STEP * i
            end
            ---TH08 色号 6 / 8 → 我们的 7 / 9。
            local color = (block % 2 == 0) and 7 or 9
            lw206_shot_fan(owner, angle, speed1, color)
        elseif (ct - RING_FIRST) % RING_PERIOD == 0 then
            local k = (ct - RING_FIRST) / RING_PERIOD
            if k < RING_SHOTS then
                if k == 0 then
                    ---ins_67(60, 4, 1.0)：同一帧、且在 ins_99 之前。
                    local round = math.floor((f - SHOT_FRAME) / ROUND)
                    local count1 = RING_COUNT0 + RING_COUNT_STEP * round
                    if count1 > RING_COUNT_MAX then count1 = RING_COUNT_MAX end
                    owner.lw206_round_count = count1
                    local a = lw206_move_angle(owner)
                    local len = MOVE_FRAMES * MOVE_SPEED
                    owner.lw206_mangle = a
                    owner.lw206_move = {
                        x0 = owner.x, y0 = owner.y,
                        dx = math.cos(a) * len,         -- TH08 的 (dx, dy) 取 y 反
                        dy = -math.sin(a) * len,
                        n = MOVE_FRAMES, t = 0,
                    }
                end
                lw206_shot_circle(owner, owner.lw206_round_count or RING_COUNT0)
            end
        end
    end
    ---ins_64(110, 4, 192, 128)：根的入场插值（TH08 y=128 → 我们 96）。
    local move = owner.lw206_move
    if move then
        local x, y, done = lw206_move_step(move)
        ---位移方向（TH08 角）在整段里不变；原作每帧用 VectorAngle 重算一次，等价。
        owner.lw206_mangle = math.atan2(-(y - owner.y), x - owner.x)
        owner.x, owner.y = x, y
        if done then
            owner.lw206_move = nil
        end
    end
    owner.lw206_t = f + 1
end

local function card_init(owner)
    owner.lw206_t = 0
    owner.lw206_aim = 0
    owner.lw206_mangle = PI / 2          -- 入场那一段是垂直向下（TH08 y+）
    owner.lw206_round_count = RING_COUNT0
    owner.lw206_blind = nil
    ---★ 落位：生成助手 Sub52 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    owner.lw206_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub46 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw206_t 它就会继续按 396 帧的周期出弹（卡 205 踩过同款坑）。
    owner.lw206_t = nil
    owner.lw206_move = nil
    if owner.lw206_blind and IsValid(owner.lw206_blind) then
        object.RawDel(owner.lw206_blind)
    end
    owner.lw206_blind = nil
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
    pool = {}
end

CARD[206] = {
    init = function(owner)
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 207「日出之国的天子」（上白泽慧音）
---  ecldata3sp.ecl：Sub56 = BOSS 根、Sub57 = 子 context 0（BOSS 自己的激光）、
---  Sub58 = 使魔、Sub59 = 使魔的枪（挂在使魔的子 context 0 上）。
---
---  · Sub56：110 帧插值入场到 TH08 (192,128) = 我们 (0,96)；t=110 一次生成 10 只
---    使魔、并把 Sub57 挂到自己身上；t=290 的 `ins_4(110, −16)` 跳回的是**紧邻的
---    `INT_INC(xi3)`**（裸字节 rel 1204 − 16 = 1188 = INT_INC，用 jt.py 复核过），
---    所以循环体里只有 `xi3++`（本卡没人读 xi3）—— 使魔和 Sub57 都只建一次。
---  · Sub58（使魔）：`ins_72(41, selfX, selfY, lf0, lf1, 0, lf2)` = 绕**生成点**
---    公转：半径每帧 +0.8、角度每帧 +lf1（±4.5°），到 t=40（ins_72 的 duration 41
---    正好走完）用 `ins_74(3600, 0, 0)` 把两个速度归零 → 停在半径 32 处
---    （角度一共扫过 ±180°）；t=100 起 `ins_74(3600, lf1/16, 0)` 以 ±0.28125°/帧
---    慢慢公转；t=3700 的 `ins_1` TERMINATE → 使魔消失。
---  · Sub59（使魔的枪；挂上时它自己的 time 从 0 起算）：t=300 / 320 / 340 各一发，
---    t=360 的 `ins_4(300, −272)` 跳回 t=300 —— 因为 JUMP 会把 time 直接拨回去、
---    同一帧接着跑 t=300 的头，所以实际就是「每 20 帧一发、3 发一轮」：
---    每个 60 帧周期的第 1 拍是 `ins_96`(FAN_AIMED，自机狙、速度 0.9、色 1)，
---    第 2/3 拍是 `ins_97`(FAN，角度 = `ins_34` 算出的「从自己指向公转圆心」
---    = **朝里**、速度 1.1、色 3)。
---  · Sub57（BOSS 的激光）：t=120 起 60 帧每帧一发 `ins_114` CREATE_LASER，
---    角度从 `AIM_TO_PL − 90°` 起每帧 −6°；紧接着（t=179 那一帧接上）再 60 发，
---    角度 +183° 起步、每帧 +6°；t=322 跳回 t=120 → 周期 202 帧。
---    激光是**静止**的 ray：长 640、宽 12，生成后 startTime 帧才成实体
---    （startTime = 190, 188, …, 72 逐发递减），实体 30 帧 + 消散 20 帧。
---  ★ 参数怎么传给使魔：`SpawnChildAtScriptPosition`（EclRunLow.inl:52-77）把父
---    context 的**整块变量** memcpy 给子敌机（SpawnEnemy2 的第 6 个参数就是那块），
---    所以 ins_90 之前设的 lf0/lf1/lf2 就是使魔 Sub58 的初值；同样地 `ins_135`
---    SET_CHILD_ECL 会把当前 context 的变量复制给子 context
---    （EclRunHigh.inl:646-671），使魔 t=0 存进 xf0/xf1 的「生成点」就这样传给了枪。
---  ★ 公转圆心不漂：`ins_90` 不给 positionOffset 赋值（只有 ins_92 那类
---    inheritParentPosition 才会在每帧刷 positionOffset，EnemyManagerUpdate.cpp:169-176），
---    所以 worldPosition = position，ORBIT 分支的
---    velocity = (圆心 + 极坐标) − position 就是「一步走到极坐标点」（EnemyManager.cpp:36-58）。
---  ★ 贴图占位：使魔 "servant"（跟卡 218 的娃娃一样）、弹 ball_small、
---    激光用 THlib 的 laser 类。17 张全部实现完之后再统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---TH08 口径的「从 BOSS 指向自机」角。ECL_OPERAND_ANGLE_TO_PLAYER 就是
---`Player::AngleToPoint`（Player.cpp:967-980）= atan2(pl.y − self.y, pl.x − self.x)，
---换成我们的坐标读就是 atan2(self.y − pl.y, pl.x − self.x)（= −aim_我们）。
---本卡凡是要跟原作算式对齐的量（下面激光的 lf0）都保持 TH08 口径，落笔给 LuaSTG 时再取反。
local function aim_to_player_th08(owner)
    return math.atan2(to_th08_y(player.y) - to_th08_y(owner.y),
                      to_th08_x(player.x) - to_th08_x(owner.x))
end

---根 Sub56 的节拍。
local BOSS_END_X, BOSS_END_Y = 0, 96
local BOSS_MOVE_FRAMES = 110
local SPAWN_FRAME = 110                 -- ins_90 ×10 + ins_135(0, 57)

---使魔 Sub58 的节拍。
local FAM_RADIAL = 0.8                  -- lf2：半径每帧 +0.8
local FAM_SPIRAL_OMEGA = 0.0785398185   -- lf1 = 4.5°/帧
local FAM_HOVER_FRAME = 40              -- ins_74(3600, 0, 0)
local FAM_SLOW_FRAME = 100              -- ins_74(3600, lf1/16, 0)
local FAM_SLOW_DIV = 16
local FAM_END_FRAME = 3700              -- ins_1 TERMINATE

---使魔的枪 Sub59 的节拍。
local GUN_FIRST = 300
local GUN_PERIOD = 20
local GUN_AIM_SPEED = 0.9               -- ins_96 的 speed1（speed2 用不上：count2=1）
local GUN_IN_SPEED = 1.1                -- ins_97 的 speed1

---BOSS 的激光 Sub57。
local LASER_FIRST = 120
local LASER_STEP = 0.10471975803375244  -- 每帧 ∓6°
local LASER_TURN = 3.1939525604248047   -- 两块之间 +183°
local LASER_WRAP = LASER_FIRST + 202    -- t=322 的 ins_4(120, −444) → 周期 202 帧
local LASER_START0 = 190                -- li0 初值
local LASER_START_STEP = -2             -- 每发 li0 −= 2
local LASER_COUNT = 60                  -- 每块 60 发（xi0 = 60 的 JUMP_DEC 循环）
local LASER_WIDTH = 12
local LASER_LENGTH = 640                -- startOffset 0 → endOffset 640，speed = 0
local LASER_DURATION = 30
local LASER_DESPAWN = 20
local LASER_RAMP = 30                   -- startTime > 30 时最后 30 帧才开始变粗
local LASER_COLOR1 = 7                  -- TH08 色号 6 → 我们的 7
local LASER_COLOR2 = 3                  -- TH08 色号 2 → 我们的 3
local LASER_HITBOX_START = 190
local LASER_HITBOX_DELAY = 20

---10 只使魔（ins_90 的裸字节：subId=58, x, y, life, itemDropType=-2, score=100）。
---x/y 是 TH08 的**绝对**坐标；lf0（初始公转角）/lf1（公转角速度）/lf2（径向速度）
---由 ins_90 前那段 SET_FLOAT / FLOAT_ADD_ASSIGN 给出，随变量块一起被子使魔继承。
---下面写的是**已经换算到我们坐标系**的值（角度 = −TH08 角、角速度 = −TH08 角速度）：
---  · 组 1：TH08 (96,128) → 我们 (−96,96)，lf0 = −90°/30°/150°（每只 +120°）、lf1 = +4.5°/帧
---  · 组 2：TH08 (288,128) → 我们 (96,96)，同角度、lf1 = −4.5°/帧
---  · 组 3：TH08 (192,224) → 我们 (0,0)，lf0 = 0°/180°/180°/360°，
---         前两只 lf1 = −4.5°/帧、后两只 +4.5°/帧
---{我们x, 我们y, 我们初始角, 我们角速度, 组号（占位贴图配色）}
local FAMILIARS = {
    { -96, 96, PI / 2,          -FAM_SPIRAL_OMEGA, 1 },
    { -96, 96, -PI / 6,         -FAM_SPIRAL_OMEGA, 1 },
    { -96, 96, -5 * PI / 6,     -FAM_SPIRAL_OMEGA, 1 },
    { 96,  96, PI / 2,           FAM_SPIRAL_OMEGA, 2 },
    { 96,  96, -PI / 6,          FAM_SPIRAL_OMEGA, 2 },
    { 96,  96, -5 * PI / 6,      FAM_SPIRAL_OMEGA, 2 },
    { 0,   0,  0,                FAM_SPIRAL_OMEGA, 3 },
    { 0,   0, -PI,               FAM_SPIRAL_OMEGA, 3 },
    { 0,   0, -PI,              -FAM_SPIRAL_OMEGA, 3 },
    { 0,   0, -2 * PI,          -FAM_SPIRAL_OMEGA, 3 },
}

---同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455），
---activeBulletCount >= 0x600 时整波不生（BulletManager.cpp:686-690）。移植版本卡自建登记表。
local POOL_SIZE = 1536

local familiars = {}
local pool = {}

local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local lw207_bullet

---本卡的弹。ins_96/ins_97 的 transformFlags = 16912 = 0x4210
---（SET_SPRITE|PLAY_SPAWN_SOUND|ACCELERATE_VECTOR），**没有** SPAWN_FAST/NORMAL/SLOW，
---所以出生当帧就是 FIRED、按全速走（BulletManager.cpp:208-236）。
---ACCELERATE_VECTOR/SET_SPRITE 要有 ins_111 写进 descriptor->transforms 才生效，
---而本卡从没写过 → transforms 全 0 → `record->kind == BULLET_TRANSFORM_NONE`
---直接返回（BulletManager.cpp:310-320），弹是纯直线。所以这里把速度交给引擎积分。
lw207_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color)
        ---bullet:init(imgclass, index, stay, destroyable, fogtime)（THlib/bullet/bullet.lua:75）
        bullet.init(self, ball_small, color, false, true)
        self.angle = angle
        self.speed = speed
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
    end,
})

---一次出弹。池满 → 整波不生（BulletManager.cpp:686-690）。
local function spawn_bullet(x, y, angle, speed, color)
    if pool_used() >= POOL_SIZE then
        return false
    end
    pool[#pool + 1] = New(lw207_bullet, x, y, angle, speed, color)
    return true
end

local lw207_familiar
local lw207_laser

---使魔的枪（Sub59）。第 1 拍两发（自机狙 + 朝里），第 2/3 拍各一发（朝里）。
---gt = 枪自己的 time：它是在使魔 t=40 那一帧被 `ins_135(0, 59)` 挂上的，
---挂上时从 0 起算，所以 gt = 使魔 t − 40。
---朝里的角度 = ins_34 POINT_ANGLE(lf0, selfX, selfY, xf0, xf1)
---= atan2(xf1 − selfY, xf0 − selfX)（EclRunLow.inl:342-351）—— 注意是**从自己指向圆心**。
---用的坐标是**上一帧末**的位置（RunEcl 在 UpdateMovement 之前，EnemyManagerUpdate.cpp:159-192）。
local function gun_step(owner, gt)
    if gt >= GUN_FIRST and (gt - GUN_FIRST) % GUN_PERIOD == 0 then
        local phase = math.floor((gt - GUN_FIRST) / GUN_PERIOD) % 3
        if phase == 0 then
            ---ins_96 SHOOT_FAN_AIMED：count1 = count2 = 1 → 一发自机狙
            ---（angle = angleToPlayer + descriptor->angle(0)，BulletManager.cpp:118-127）。
            local aim = math.atan2(player.y - owner.y, player.x - owner.x)
            if not spawn_bullet(owner.x, owner.y, aim, GUN_AIM_SPEED, COLOR.RED) then
                return
            end
        end
        ---ins_97 SHOOT_FAN：count1 = count2 = 1 → 一发，角度 = lf0（朝圆心）。
        local inward = math.atan2(owner.lw207_center_y - owner.y,
                                  owner.lw207_center_x - owner.x)
        spawn_bullet(owner.x, owner.y, inward, GUN_IN_SPEED, COLOR.PURPLE)
    end
end

---使魔（Sub58）。占位贴图 "servant"。
---原作它有 24×24 判定、life 1200（中间那 4 只是 500）、可被击破；移植版不给判定、
---也不做击破（跟卡 218 的娃娃一个处理口径：这只是占位实现，判定交给后面的统一收敛）。
lw207_familiar = Class(object, {
    init = function(self, x, y, angle, omega, group)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        if group == 1 then
            self._r, self._g, self._b = 255, 160, 160
        elseif group == 2 then
            self._r, self._g, self._b = 180, 160, 255
        else
            self._r, self._g, self._b = 255, 235, 150
        end
        ---公转圆心 = 生成位置（= 原作 t=0 存进 xf0/xf1 的 selfX/selfY）。
        self.lw207_center_x, self.lw207_center_y = x, y
        self.lw207_angle = angle          -- 我们坐标
        self.lw207_radius = 0
        self.lw207_radial = FAM_RADIAL
        self.lw207_omega = omega
        self.lw207_omega0 = omega
        self.lw207_t = 0                  -- Sub58 的 time
    end,
    frame = function(self)
        local t = self.lw207_t
        ---① 主 context Sub58（RunEcl 先跑主 context，再跑子 context）。
        if t == FAM_HOVER_FRAME then
            ---ins_74(3600, 0, 0)：公转角速度和径向速度都归零（同时把 duration 续成 3600）
            self.lw207_omega, self.lw207_radial = 0, 0
        elseif t == FAM_SLOW_FRAME then
            ---ins_74(3600, lf1/16, 0)：lf1 在 t=40 已经被 `ins_18(lf1, 16)` 除过 16
            self.lw207_omega = self.lw207_omega0 / FAM_SLOW_DIV
        elseif t >= FAM_END_FRAME then
            ---ins_1 TERMINATE → 敌机消失
            object.RawDel(self)
            return
        end
        ---② 子 context Sub59（枪）：t=40 才挂上，它自己的 time 从 0 起算；
        ---   用的是**上一帧末**的位置
        if t >= FAM_HOVER_FRAME then
            gun_step(self, t - FAM_HOVER_FRAME)
        end
        ---③ ORBIT 位移（EnemyManager.cpp:36-58）：orbitAngle += ω、orbitRadius += radial、
        ---   position = 圆心 + polar(angle, radius)
        self.lw207_angle = self.lw207_angle + self.lw207_omega
        if self.lw207_angle > PI then
            self.lw207_angle = self.lw207_angle - 2 * PI
        elseif self.lw207_angle < -PI then
            self.lw207_angle = self.lw207_angle + 2 * PI
        end
        self.lw207_radius = self.lw207_radius + self.lw207_radial
        self.x = self.lw207_center_x + math.cos(self.lw207_angle) * self.lw207_radius
        self.y = self.lw207_center_y + math.sin(self.lw207_angle) * self.lw207_radius
        self.rot = -self.lw207_angle * RAD   -- 观感近似：朝向自己所在的方向
        self.lw207_t = t + 1
    end,
})

---BOSS 的激光（Sub57 的 ins_114 = CREATE_LASER）。原作这段激光是**静止**的：
---speed = 0 → endOffset 一直 640、startOffset 一直 0，判定盒就是「从生成点沿 angle
---长 640、宽 12」的矩形（Player::CalcLaserHitbox 里是 `position ± size/2`、
---size[0] = endOffset − startOffset、size[1] = width/2，Player.cpp:396-424）。
---状态机照抄 BulletManager.cpp:1049-1150：
---  STARTING（startTime 帧）：startTime > 30 时前 (startTime−30) 帧画 1.2px 细线、
---    最后 30 帧按 timer·width/startTime 变粗；判定要 timer >= hitboxStartTime；
---    timer 到 startTime → 转 ACTIVE、timer 归零、宽度取满。
---  ACTIVE（duration 帧）：满宽、每帧判定。
---  DESPAWNING（despawnDuration 帧）：宽度线性收到 0，判定留到 hitboxEndDelay。
lw207_laser = Class(laser, {
    init = function(self, x, y, angle, color, start_time)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）
        ---l1/l2/l3 = 尾/身/头三段长度；这里只要一段 640 的身部。
        laser.init(self, color, x, y, angle, 0, LASER_LENGTH, 0, 1.2, 0, 0)
        self.lw207_state = 1
        self.lw207_timer = 0
        self.lw207_start_time = start_time
        self.alpha = 1
        self.colli = false        -- STARTING 段的判定要 hitboxStartTime 之后才开
    end,
    frame = function(self)
        local t = self.lw207_timer
        if self.lw207_state == 1 then
            local ramp = self.lw207_start_time > LASER_RAMP and LASER_RAMP
                    or self.lw207_start_time
            if self.lw207_start_time - ramp < t then
                self.w = t * LASER_WIDTH / self.lw207_start_time
            else
                self.w = 1.2
            end
            self.colli = t >= LASER_HITBOX_START
            if t >= self.lw207_start_time then
                ---原作这里不 break，直接落到 ACTIVE 那一支
                self.lw207_state = 2
                self.lw207_timer = 0
                t = 0
            end
        end
        if self.lw207_state == 2 then
            self.w = LASER_WIDTH
            self.colli = true
            if t >= LASER_DURATION then
                self.lw207_state = 3
                self.lw207_timer = 0
                t = 0
            end
        end
        if self.lw207_state == 3 then
            self.w = LASER_WIDTH - t * LASER_WIDTH / LASER_DESPAWN
            self.colli = t < LASER_HITBOX_DELAY
            if t >= LASER_DESPAWN then
                object.RawDel(self)
                return
            end
        end
        self.lw207_timer = t + 1
        laser.frame(self)
    end,
})

---Sub57 的一帧。lt = 子 context 的 time（挂上那一帧 = 0）。
---ins_4(120, −444) 会把 time 直接拨回 120、**同一帧**接着跑 t=120 的头，
---所以这里读到 322 就先把 lt 归到 120 再执行。
local function laser_step(owner, lt)
    if lt == LASER_WRAP then
        lt = LASER_FIRST
    end
    if lt == LASER_FIRST then
        ---t=120 的头：li0 = 190、lf0 = AIM_TO_PL − π/2（FLOAT_SUB 是 op1 − op2，
        ---EclRunLow.inl:301-307；AIM_TO_PL 是「从 BOSS 指向自机」的角）
        owner.lw207_lf0 = aim_to_player_th08(owner) - PI / 2
        owner.lw207_li0 = LASER_START0
    end
    ---块 1：t=120..179，每帧一发，角度每帧 −6°、起始延迟每帧 −2。
    ---（t=179 那一帧打完结 1 的第 60 发之后，会同帧接着跑块 2 的头。）
    if lt >= LASER_FIRST and lt < LASER_FIRST + LASER_COUNT then
        New(lw207_laser, owner.x, owner.y, -owner.lw207_lf0, LASER_COLOR1, owner.lw207_li0)
        owner.lw207_lf0 = owner.lw207_lf0 - LASER_STEP
        owner.lw207_li0 = owner.lw207_li0 + LASER_START_STEP
    end
    ---块 2：t=179..238，与块 1 共享 t=179 那一帧（FLOAT_ADD_ASSIGN lf0 += 183°）
    if lt >= LASER_FIRST + LASER_COUNT - 1 and lt < LASER_FIRST + 2 * LASER_COUNT - 1 then
        if lt == LASER_FIRST + LASER_COUNT - 1 then
            owner.lw207_lf0 = owner.lw207_lf0 + LASER_TURN
            owner.lw207_li0 = LASER_START0
        end
        New(lw207_laser, owner.x, owner.y, -owner.lw207_lf0, LASER_COLOR2, owner.lw207_li0)
        owner.lw207_lf0 = owner.lw207_lf0 + LASER_STEP
        owner.lw207_li0 = owner.lw207_li0 + LASER_START_STEP
    end
    return lt + 1
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）。
---ins_64 的缓动 4 = OUT_QUADRATIC = 1−(1−u)²。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---Sub56 每帧（RunEcl 主 context → 子 context，然后才是 UpdateMovement）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑（tools/check_stage.lua 也照抄了这个顺序），
    ---  那几帧 lw207_t 还是 nil；卡 205/206/218 同款守卫。
    if not owner.lw207_t then return end
    local f = owner.lw207_t
    if f == SPAWN_FRAME then
        ---ins_90 ×10（绝对坐标 → 换算成我们的） + ins_135(0, 57)
        for i = 1, #FAMILIARS do
            local e = FAMILIARS[i]
            familiars[#familiars + 1] = New(lw207_familiar, e[1], e[2], e[3], e[4], e[5])
        end
        owner.lw207_laser_t = 0
    end
    if owner.lw207_laser_t then
        owner.lw207_laser_t = laser_step(owner, owner.lw207_laser_t)
    end
    local move = owner.lw207_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw207_move = nil
        end
    end
    owner.lw207_t = f + 1
end

local function card_init(owner)
    owner.lw207_t = 0
    owner.lw207_laser_t = nil       -- 挂上 Sub57 的那一帧才是 0
    owner.lw207_lf0, owner.lw207_li0 = 0, LASER_START0
    ---★ 落位：生成助手 Sub63 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    owner.lw207_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub56 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw207_t 它会继续按周期出激光（卡 205/206 都踩过同款坑）。
    owner.lw207_t = nil
    owner.lw207_laser_t = nil
    owner.lw207_move = nil
    for i = #familiars, 1, -1 do
        if IsValid(familiars[i]) then
            object.RawDel(familiars[i])
        end
        familiars[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
    pool = {}
end

CARD[207] = {
    init = function(owner)
        familiars = {}
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 208「幻胧月睨」（铃仙·优昙华院·因幡）
---  ecldata5sp.ecl：Sub40 = BOSS 根、Sub38 = BOSS 的子 context 0（月亮 + 红光）、
---  Sub39 = 月亮本体、Sub42 = 使魔、Sub41 = 使魔的枪（挂在使魔的子 context 0 上）。
---
---  · Sub40 是个 180 帧的循环：t=290 的 `ins_4(110, −1032)` 把 time 拨回 t=110，
---    落点 = 裸字节 21892 − 1032 = 20860 = `ins_7(lf0, RANDOM_ANGLE)` 那条（复核过），
---    所以每个周期的动作是：
---      +0   t=110  一发 144 发的大圆环（速度 5.0、掩码 0x100200）
---      +30  t=140  两组掩码各推进一次相位（lf1 = 0.1）+ `ins_135(0, 38)` 重建子 context
---      +120 t=230  两组各推一次
---      +150 t=260  两组各推一次
---      +160 t=270  两发 44×2 的小圆环（速度 5.4→2.8、色 2、两掩码，第二发基准角 +3.75°）
---      +170 t=280  两发 44×2 的小圆环（速度 5.2→2.6、色 6）→ ins_67 乱走 → 24 只使魔
---      +180 t=290  跳回 +0
---    （那 4 条难度掩码的 `ins_6(li7, …)` 紧跟在跳转落点**后面**，所以每个周期都会
---    把 li7 重写成 144 —— 不是「只有第一轮是 144」。）
---  · 相位机 = ex 指令 14（`ins_136(14, 0)`）AdvanceReisenBulletPhase（EclExIns.cpp:669-717）。
---    它对**全池**扫一遍，把 `(transformFlags & li0) != 0` 的弹推一格（li0 就是掩码）：
---      type1 → type0：换 +16 号精灵、附加混合、alpha 归 0、关判定，速度换成
---                     `FromAngleMagnitude(bullet->angle, lf1)` —— 沿自己原朝向、速度 0.1
---      type0 → type2：alpha 从 0 线性插到 255（15 帧），仍然关判定
---      type2 → type1：换回普通精灵、开判定、速度回到弹自己的原速
---    于是每颗弹是「30 帧可见（5.0 飞）→ 90 帧隐身（0.1 爬）→ 15 帧淡入 →
---    之后每 180 帧里可见 60 帧」。两组掩码（0x100000 / 0x200000）在**同一帧**被推进
---    —— 照抄原作，不做偏置。
---  · 使魔 Sub42：`ins_65(lf0, lf1)` 直着飞（速度 4.0、无边界、无角速度），
---    朝向 = AIM_TO_PL + k·15°（0..23）；原作 life 200、判定 24×24。
---  · 枪 Sub41：t=0 三条 `ins_111` 写 transform 记录 + 一条 `ins_97`，t=10 的
---    `ins_4(0, −44)` 跳回的是**那条 ins_97**（裸字节 164 − 44 = 120，复核过），
---    所以记录只写一次、每 10 帧出一发：速度 0.6、角度恒 0.09817477（5.625°、
---    FAN 不加自机方向）、弹型 7、色 3。三条记录：
---      WAIT(180) → SET_SPRITE(7/1) → ACCELERATE_VECTOR(60 帧、每帧沿原方向 +1/30)
---    （BulletManager.cpp:311-420 记记录、:816-855 跑状态机、:1205-1228 跑加速）。
---  ★ 贴图占位：使魔 "servant"、月亮 "eyeL"、弹 ball_small。17 张全部实现完再统一换。
---  ★ 没移植的纯画面效果：Sub38 每帧的 `ins_137(13, 0)` = ex 13 ApplyRedBackgroundTint
---    （EclExIns.cpp:719-722：给**背景层**逐帧叠 0xffc03030 的乘算色，52 帧）。
---    配音效一样，等统一换素材时再补。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1258）：归一到 [−π, π]。
local function norm(angle)
    while angle > PI do angle = angle - 2 * PI end
    while angle < -PI do angle = angle + 2 * PI end
    return angle
end

---TH08 口径的「从 BOSS 指向自机」角（ECL_OPERAND_ANGLE_TO_PLAYER =
--- Player::AngleToPoint）：atan2(pl.y − self.y, pl.x − self.x)。
---本卡凡是要跟原作算式对齐的量都保持 TH08 口径，落笔给 LuaSTG 时再取反。
local function aim_to_player_th08(owner)
    return math.atan2(to_th08_y(player.y) - to_th08_y(owner.y),
                      to_th08_x(player.x) - to_th08_x(owner.x))
end

---BOSS 根 Sub40 的节拍（全部来自 ecldata5sp.ecl Sub40 的裸字节）。
local BOSS_END_X, BOSS_END_Y = 0, 96
local BOSS_MOVE_FRAMES = 110            -- ins_64(110, 4, 192, 128)：TH08 (192,128) → 我们 (0,96)
local CYCLE_FIRST = 110                 -- ins_4 的落点 = 每个周期的第 0 帧
local CYCLE_PERIOD = 180                -- t=290 − t=110
local PHASE_S1, PHASE_S2, PHASE_S3 = 30, 120, 150
local PHASE_RING_A, PHASE_RING_B = 160, 170
local MASK_A = 0x100000                 -- BULLET_TRANSFORM_ECL_EX_TRIGGER_MARKER（BulletManager.hpp:152）
local MASK_B = 0x200000                 -- 枚举里没有名字的另一位（0x400000 才是 WRAP_X）
local SPAWN_SOUND_BIT = 0x200           -- BULLET_TRANSFORM_PLAY_SPAWN_SOUND（本卡只影响音效）
local HIDDEN_SPEED = 0.1                -- lf1（t=140 写死；三个推进点都用它）
local FADE_FRAMES = 15                  -- StartColor1AlphaInterpolation(15, ·, 0, 255)
local GHOST_BLEND = "add+alpha"         -- 原作 type0/2 是 AnmBlendMode_Additive

---圆环的弹参数（op99 = SHOOT_CIRCLE，EclManager.hpp:308）。
---  aimMode = opcode − 96 = 3 = BULLET_AIM_CIRCLE：
---    angle = i·2π/count1 + j·angleStep + angle、count2 > 1 时
---    speed_j = speed1 − (speed1−speed2)·j/count2（BulletManager.cpp:83-92、129-133）。
local RING_STEP = 0.09817477315664291    -- angleStep（2π/64 = 5.625°）
local RING_OFFSET = 0.06544985           -- 第二发圆环的基准角 +3.75°
local BIG_COUNT = 144                    -- t=110：li7 在 Lunatic 下的值
local BIG_SPEED = 5.0                    -- speed1（count2 = 1）
local SMALL_COUNT = 44                   -- t=270 / t=280 的 count1
local SMALL_A = { s1 = 5.4, s2 = 2.8, color = COLOR.RED }   -- t=270（TH08 色 2）
local SMALL_B = { s1 = 5.2, s2 = 2.6, color = COLOR.BLUE }  -- t=280（TH08 色 6）
local POOL_SIZE = 1536                   -- BulletManager.hpp:455

---ins_67(120, 0, 0.5)：120 帧走 0.5·120 = 60 px（缓动 0 = 线性）。
local WANDER_FRAMES = 120
local WANDER_SPEED = 0.5

---使魔（Sub42）与它的枪（Sub41）。
local FAM_COUNT = 24                    -- xi0 = 24 的 JUMP_DEC 循环
local FAM_SPEED = 4.0                   -- lf1
local FAM_STEP = 0.2617994              -- lf0 每轮 +15°
local EYE_X, EYE_Y = 0, -20             -- Sub39 的绝对坐标（TH08 192, 244）
local EYE_FRAMES = 60                   -- Sub39 的 ins_1
local GUN_PERIOD = 10                   -- t=10 的 ins_4(0, −44) → 每 10 帧一发
local GUN_SPEED = 0.6                   -- ins_97 的 speed1（count2 = 1）
local GUN_ANGLE = 0.09817477315664291   -- ins_97 的 angle（固定值，TH08 口径）
local GUN_COLOR = COLOR.DEEP_PURPLE     -- TH08 色 3
local GUN_WAIT = 180                    -- 记录 0 WAIT 的帧数
local GUN_ACCEL_FRAMES = 60             -- 记录 2 的 durationFrames
local GUN_ACCEL = 0.03333333507180214   -- 记录 2 的 magnitude（1/30）
---ins_97 的 transformFlags = 147984 = 0x24210（WAIT|SET_SPRITE|PLAY_SPAWN_SOUND|
---ACCELERATE_VECTOR）。相位机按 `transformFlags & li0` 挑弹，这几位跟两个掩码都不沾
---（0x24210 & 0x100000 = 0），所以枪弹不会被相位机推走 —— 照抄。
local GUN_FLAGS = 0x24210

---本卡自己的弹池（= 原作那 1536 个弹槽）与使魔 / 月亮登记表。
local pool = {}
local familiars = {}
local eyes = {}

local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local lw208_bullet

---本卡的圆环弹。掩码位只用来分组，运动全部自己算（vx/vy 交给引擎积分，同卡 218/207）。
---相位改速度的口径照 EclExIns.cpp:669-717：type1→0 用 lf1 沿**当前朝向**，
---type2→1 用弹自己的 speed。
lw208_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color, mask)
        bullet.init(self, ball_small, color, false, true)
        self.lw208_angle = angle           -- 我们坐标
        self.lw208_speed = speed           -- 原速（type2→1 时回到它）
        self.lw208_flags = mask            -- = 原作的 transformFlags 字
        self.lw208_type = 1                -- 1 可见 / 0 隐身 / 2 淡入
        self.lw208_fade = 0
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
    end,
    frame = function(self)
        ---type0 → type2 之后的淡入：15 帧线性 0 → 255（原作是 ANM 的
        ---StartColor1AlphaInterpolation，判定仍然关着）。
        if self.lw208_type == 2 and self.lw208_fade < FADE_FRAMES then
            self.lw208_fade = self.lw208_fade + 1
            local a = math.floor(self.lw208_fade * 255 / FADE_FRAMES)
            if a > 255 then a = 255 end
            self._a = a
        end
        bullet.frame(self)
    end,
})

---一次圆环出弹（SpawnBulletPattern：BulletManager.cpp:685-712）。
---池满（activeBulletCount >= 0x600）→ **整波不生**；波中间生不出来就放弃整波剩下的。
---base 是 TH08 口径的基准角（= RANDOM_ANGLE 或它 +3.75°）。
local function fire_ring(owner, count1, count2, s1, s2, color, mask, base)
    local used = pool_used()
    for j = 0, count2 - 1 do
        local speed = s1
        if count2 > 1 then
            speed = s1 - (s1 - s2) * j / count2
        end
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then return end
            local th08 = base + i * 2 * PI / count1 + j * RING_STEP
            pool[#pool + 1] = New(lw208_bullet, owner.x, owner.y, -th08, speed,
                    color, mask + SPAWN_SOUND_BIT)
            used = used + 1
        end
    end
end

---`(flags & mask) ~= 0` 的等价判据。内嵌 Lua 只认 5.1 语法，没有 `&` 运算符
---（用 `&` 会在加载时直接报 `') expected near '&'`），所以自己按位拆。
---掩码是单 bit（0x100000 / 0x200000），这里写成通用形式，任意掩码都对。
local function flag_hit(flags, mask)
    while flags > 0 and mask > 0 do
        if flags % 2 == 1 and mask % 2 == 1 then
            return true
        end
        flags = math.floor(flags / 2)
        mask = math.floor(mask / 2)
    end
    return false
end

---推进一格相位（EclExIns.cpp:669-717 的三分支）。原作扫的是**全 1536 个槽**，
---只按 `(transformFlags & li0) != 0` 挑；移植版扫本卡自己的登记表，判据等价。
local function advance_phase(mask)
    for i = 1, #pool do
        local b = pool[i]
        if IsValid(b) and flag_hit(b.lw208_flags, mask) then
            if b.lw208_type == 1 then
                ---type1 → type0：换 +16 号精灵（占位贴图看不出差别）、附加混合、
                ---alpha 归 0、关判定、速度 = 沿当前朝向的 lf1
                b.lw208_type = 0
                b._blend = GHOST_BLEND
                b._a = 0
                b.colli = false
                b.vx = math.cos(b.lw208_angle) * HIDDEN_SPEED
                b.vy = math.sin(b.lw208_angle) * HIDDEN_SPEED
            elseif b.lw208_type == 0 then
                ---type0 → type2：alpha 从 0 开始插值（判定还关着）
                b.lw208_type = 2
                b.lw208_fade = 0
                b._a = 0
            else
                ---type2 → type1：换回普通精灵、开判定、速度回原速
                b.lw208_type = 1
                b._blend = ""
                b._a = 255
                b.colli = true
                b.vx = math.cos(b.lw208_angle) * b.lw208_speed
                b.vy = math.sin(b.lw208_angle) * b.lw208_speed
            end
        end
    end
end

local lw208_familiar
local lw208_eye

---使魔枪弹（Sub41 的 ins_97：弹型 7、色 3、flags = 0x24210）。
---三条 transform 记录（t=0 的三条 ins_111）：
---  · WAIT(180)：激活后 activeTransformFlags ≠ 0 → AdvanceTransformProgram 立刻返回
---    （BulletManager.cpp:313-316），所以后两条要等它走完
---  · SET_SPRITE(7/1)：占位实现保持同一张贴图（换素材时再区分）
---  · ACCELERATE_VECTOR(60 帧, magnitude 1/30, angle −999 → 取弹自己的 angle)：
---    之后 60 帧每帧 velocity += 沿该角的 1/30，angle 跟着重算（:1205-1228）
local lw208_gun_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color)
        bullet.init(self, ball_small, color, false, true)
        self.lw208_angle = angle
        self.lw208_flags = GUN_FLAGS
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
        ---记录 0 在出生那一刻就激活（SpawnSingleBullet 末尾会调一次
        ---AdvanceTransformProgram，BulletManager.cpp:233）
        self.lw208_wait = GUN_WAIT
        self.lw208_accel = false
        self.lw208_accel_timer = 0
        self.lw208_accel_vx = 0
        self.lw208_accel_vy = 0
    end,
    frame = function(self)
        if self.lw208_wait > 0 then
            self.lw208_wait = self.lw208_wait - 1
        elseif not self.lw208_accel then
            ---WAIT 归零那一帧不会立刻接上下一条：AdvanceTransformProgram 在每帧最前面跑，
            ---清位发生在同一帧的后面（:848-854），所以加速要等下一帧。
            self.lw208_accel = true
            self.lw208_accel_vx = math.cos(self.lw208_angle) * GUN_ACCEL
            self.lw208_accel_vy = math.sin(self.lw208_angle) * GUN_ACCEL
        elseif self.lw208_accel_timer < GUN_ACCEL_FRAMES then
            self.vx = self.vx + self.lw208_accel_vx
            self.vy = self.vy + self.lw208_accel_vy
            if math.abs(self.vx) > 0.0001 or math.abs(self.vy) > 0.0001 then
                self.lw208_angle = math.atan2(self.vy, self.vx)
            end
            self.lw208_accel_timer = self.lw208_accel_timer + 1
        end
        bullet.frame(self)
    end,
})

local function fire_gun(owner)
    pool[#pool + 1] = New(lw208_gun_bullet, owner.x, owner.y, -GUN_ANGLE, GUN_SPEED, GUN_COLOR)
end

---使魔（Sub42）。24 只一批，朝向 = AIM_TO_PL + k·15°、速度 4.0（ins_65）。
---占位贴图 "servant"；原作 life 200、判定 24×24，移植版不给判定
---（跟卡 218 的娃娃、卡 207 的使魔同一个口径）。飞出场地就回收（EnemyManagerUpdate.cpp:240-262）。
lw208_familiar = Class(object, {
    init = function(self, x, y, angle)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self._r, self._g, self._b = 255, 160, 255
        ---ins_65(lf0, lf1)：ENEMY_MOVEMENT_MODE_POLAR、无角速度 / 加速度 / 时长
        self.vx = math.cos(angle) * FAM_SPEED
        self.vy = math.sin(angle) * FAM_SPEED
        self.lw208_t = 0
    end,
    frame = function(self)
        local t = self.lw208_t
        ---枪 Sub41：挂上的那一帧（t=0）就出第一发，之后每 10 帧一发
        if t % GUN_PERIOD == 0 then
            fire_gun(self)
        end
        self.rot = -math.atan2(self.vy, self.vx) * RAD   -- 观感近似：朝自己飞的方向
        self.lw208_t = t + 1
        if not in_bound(self) then
            object.RawDel(self)
        end
    end,
})

---Sub39 的「月亮」：Sub38 的 t=0 用 `ins_93(39, xf0, xf1, 0, 10, −2, 10)` 生成，
---绝对坐标 TH08 (192, 244) = 我们 (0, −20)，`ins_1` 在 t=60 收掉。占位贴图 "eyeL"。
lw208_eye = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "eyeL"
        self.hscale, self.vscale = 2, 2
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self._r, self._g, self._b = 255, 255, 255
        self.lw208_t = 0
    end,
    frame = function(self)
        self.lw208_t = self.lw208_t + 1
        if self.lw208_t > EYE_FRAMES then
            object.RawDel(self)
        end
    end,
})

---24 只使魔（Sub40 t=280 的 JUMP_DEC 循环：`ins_91(42, 0, 0, 200, −2, 100)` 24 次）。
---循环体是「先 ins_91 再 lf0 += 15° 再 NORMALIZE_ANGLE」，所以第一只取 AIM_TO_PL、
---第 24 只取 AIM_TO_PL + 345°（都在 TH08 口径下；给 LuaSTG 时取反）。
local function spawn_familiars(owner)
    local angle = aim_to_player_th08(owner)
    for _ = 1, FAM_COUNT do
        familiars[#familiars + 1] = New(lw208_familiar, owner.x, owner.y, -angle)
        angle = norm(angle + FAM_STEP)
    end
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress；
---timer 归 0 那一帧直接落在终点。ins_64 的缓动 4 = OUT_QUADRATIC、ins_67 的 0 = LINEAR。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = u
    if move.easing == 4 then
        e = 1 - (1 - u) * (1 - u)
    end
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---`ins_75(32, 48, 352, 128)`（**生成助手** t=0 设的移动边界，同时置 CLAMP_POSITION）→
---我们坐标的夹框 x∈[−160,160]、y∈[96,176]；下面四条判据拿「边界 ±96/48」去比。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）把角卷进 (−π, π]。原作只对「自机在左」
---那一支做（EclDependencies.cpp:135-138），后面的符号判据全靠它。
local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---抽角度 + 四条边界修正，再交给 StartTimedPolarDisplacement（:105-126）
---（delta = (cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4）。
---★ 「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle`，用的是**上一段的
---  移动方向**、不是刚抽到的 angle —— 原作自己的怪癖，照抄，别「修」成 angle。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BW_TH_L + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.lw208_movement_angle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---StartTimedPolarDisplacement（EclDependencies.cpp:106-126）：ins_67 的 operand0 = 120 > 0，
---所以是「120 帧走完 (cos,sin)(angle)·0.5·120 px」的插值，不是匀速极坐标。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw208_movement_angle = angle
    owner.lw208_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0, easing = 0,
    }
end

---Sub40 每帧（原作 RunEcl 主 context → 子 context，然后才是 UpdateMovement，:159-192）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑（tools/check_stage.lua 也照抄了这个顺序），
    ---  那几帧 lw208_t 还是 nil；卡 205/206/207/218 同款守卫。
    if not owner.lw208_t then return end
    local f = owner.lw208_t
    if f >= CYCLE_FIRST then
        local ph = (f - CYCLE_FIRST) % CYCLE_PERIOD
        if ph == 0 then
            ---t=110：`ins_7(lf0, RANDOM_ANGLE)` + 难度掩码写 li7 = 144 + 大圆环
            fire_ring(owner, BIG_COUNT, 1, BIG_SPEED, BIG_SPEED, COLOR.RED, MASK_A,
                    ran:Float(-PI, PI))
        elseif ph == PHASE_S1 then
            ---t=140：lf1 = 0.1；li0 = 0x100000 推一次、li0 = 0x200000 再推一次；
            ---然后 `ins_135(0, 38)` 重建子 context 0（月亮 + 红光）
            advance_phase(MASK_A)
            advance_phase(MASK_B)
            eyes[#eyes + 1] = New(lw208_eye, EYE_X, EYE_Y)
        elseif ph == PHASE_S2 or ph == PHASE_S3 then
            ---t=230 / t=260：两组各推一次（t=260 那条还写了 li1 = 1，ex14 不读它）
            advance_phase(MASK_A)
            advance_phase(MASK_B)
        elseif ph == PHASE_RING_A then
            ---t=270：lf0 = RANDOM_ANGLE、li7 = 44，两发 44×2（第二发基准角 +3.75°）
            local base = ran:Float(-PI, PI)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_A.s1, SMALL_A.s2, SMALL_A.color,
                    MASK_A, base)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_A.s1, SMALL_A.s2, SMALL_A.color,
                    MASK_B, base + RING_OFFSET)
        elseif ph == PHASE_RING_B then
            ---t=280：同上，色 6 + 速度更低；尾部还有 ins_67 乱走 + 24 只使魔
            local base = ran:Float(-PI, PI)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_B.s1, SMALL_B.s2, SMALL_B.color,
                    MASK_A, base)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_B.s1, SMALL_B.s2, SMALL_B.color,
                    MASK_B, base + RING_OFFSET)
            begin_wander(owner)
            spawn_familiars(owner)
        end
    end
    local move = owner.lw208_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw208_move = nil
        end
    end
    ---ClampPosition（EnemyManager.cpp:803-819）：生成助手的 `ins_75` 置了 CLAMP_POSITION，
    ---原作每帧在位移**前后**各钳一次（EnemyManagerUpdate.cpp:172-174）；这里位移只在本函数里变。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
    owner.lw208_t = f + 1
end

local function card_init(owner)
    owner.lw208_t = 0
    ---上一段（从出生点插值进场）的方向：TH08 口径的 π/2 = 朝下 = 我们坐标朝上。
    ---BeginBoundaryAwareMove 的 `bx > −96` 那条会拿它改写角度。
    ---★ 落位：生成助手 Sub52 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    ---位移恒 0 的插值每帧 velocity = 0 → movementAngle = VectorAngle(0,0) = atan2(0,0) = 0。
    owner.lw208_movement_angle = 0
    owner.lw208_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0, easing = 4,
    }
    ---原作 Sub40 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw208_t 它会继续按周期出弹（卡 205/206/207 都踩过同款坑）。
    owner.lw208_t = nil
    owner.lw208_move = nil
    for i = #familiars, 1, -1 do
        if IsValid(familiars[i]) then
            object.RawDel(familiars[i])
        end
        familiars[i] = nil
    end
    for i = #eyes, 1, -1 do
        if IsValid(eyes[i]) then
            object.RawDel(eyes[i])
        end
        eyes[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[208] = {
    init = function(owner)
        pool = {}
        familiars = {}
        eyes = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 209「天网蛛网捕蝶之法」（八意永琳）
---  ecldata6sp.ecl：Sub76 = BOSS 根、Sub79 = 蛛网节点（敌机）。整张卡只有这两个子程序。
---
---  · Sub76（根）：110 帧插值入场到 TH08 (192,128) = 我们 (0,96)；之后每 240 帧一轮：
---      t=110  `ins_7(lf0, AIM_TO_PL)` 记下「从 BOSS 指向自机」的角、`xi0 = 0`、
---             `lf7 = rndUnit·(−π/8) + 2π/5`（rndUnit ∈ [0,1) → lf7 ∈ (50°, 72°]）、
---             再 `ins_94(79, 0,0,0, 10, −2, 10)` 在**当前位置**生成一个蛛网节点；
---      t=290  `ins_67(60, 4, 1.0)` = MOVE_RANDOM_IN_BOUNDS；
---      t=350  `ins_4(110, −180)` 跳回 t=110 的头 —— 周期 240 帧，节拍是「先出网、后乱走」。
---      ★ lf7 整棵树**共用**（子节点不重抽），所以每一轮只有一个随机偏角。
---  · Sub79（蛛网节点）：不可见（`ins_80(8)` NO_SPRITE）+ 允许出屏（`ins_80(16)`）。
---      t=0    `ins_114` CREATE_LASER：从自己的位置朝 lf0 生成一条**静止**光柱。
---      t=0,2,…12 每 2 帧一发 `ins_99` SHOOT_CIRCLE（xi1 = 7 的 JUMP_DEC 循环）。
---      t=0    `ins_64(14, 0, selfX + 70·cos(lf0), selfY + 70·sin(lf0))`：14 帧沿 lf0 走 70 px。
---      t=12   `xi0++`；`xi0 < 8` 就 `lf0 = lf1 ± lf7`（lf1 = 本节点的 lf0）生成 2 个子节点
---             ——子节点**继承整块变量**（含 lf7 / li5，EnemyTimeline.cpp:64-108 的
---             EnemyContextCopy 0x78 字节 = int + float 变量块）——且生成在**父节点当前位置**，
---             父节点这时已走完 12/14 步 = 60 px，所以每条枝长 60 px；
---             `xi0 >= 8` 就直接 `ins_1` TERMINATE。树深 8 代、每代翻倍：
---             1+2+…+256 = **511 个节点**，最深那 256 个只活 12 帧。
---      t=102  `li5 >= 1`（第 2 轮起的网）时补一发 `ins_99`(3, 6, 1, 1, 1, 1, π/2, 0, 514)
---             → 朝**正下方**（TH08 π/2）、速度 1、transformFlags 514 = 0x202（SPAWN_FAST），
---             然后 TERMINATE。第 1 轮的网 li5 = 0，那一帧直接跳去 TERMINATE（只活 12 帧）。
---  · 光柱参数（ins_114 的裸字节）：bulletType 0、color li7 = 6、speed 0、startOffset 0、
---    endOffset 600、startLength 600、width 10、startTime 110、duration 50、despawnDuration 20、
---    hitboxStartTime 110、hitboxEndDelay 20、transformFlags 4（SPAWN_NORMAL）。
---    判定盒 = 「从生成点沿 angle 长 600、高 width/2 = 5」的矩形：Player::CalcLaserHitbox
---    拿 `position ± size/2` 比，size[0] = endOffset − startOffset、size[1] = width/2
---    （Player.cpp:396-424）→ 半宽 2.5。★ 所以给 THlib 的 laser 类要填 w = width/2 = 5
---    （laser:frame 的判定是 `dy < self.w / 2`，THlib/laser/laser.lua:91）——
---    填 10 的话判定会宽一倍。
---    状态机照抄 BulletManager.cpp:1049-1150：STARTING 的 110 帧里前 80 帧只画 1.2 px 细线、
---    最后 30 帧按 timer·width/startTime 变粗，`timer >= hitboxStartTime` 才有判定 ——
---    本卡 hitboxStartTime == startTime == 110，所以**从第 110 帧起**才成实体；ACTIVE 50 帧满宽
---    判定；之后 DESPAWNING 20 帧。★ 消散段原作把 laserSize[0]（= 判定盒的**长度**）
---    改写成 currentWidth/2，而盒心还钉在 position + 300 —— 于是那 20 帧的判定只剩
---    「光柱中点附近一个 5 px 的小方块」，等于没有；移植版据此在消散段关掉判定，
---    只保留宽度收细的观感（照抄反而更不忠实）。
---  · 同屏上限：光柱槽只有 256 个（`Laser lasers[0x100]`，BulletManager.hpp:313-339），
---    SpawnLaserPattern（BulletManager.cpp:712-760）只是**从头找第一个空槽**，槽满就整发不生成。
---    节点按代生成、每代相隔 12 帧 → 第 1..8 代的 255 条光柱都拿得到槽，第 9 代只有第 1 条
---    拿得到，其余全被丢掉。移植版照抄这个「先到先得」。
---  ★ 敌机槽（480 个，EnemyManagerUpdate.cpp:119）没有移植：LuaSTG 没有敌机池，而被丢掉的
---    那 31 个节点本来也抢不到光柱槽（对蛛网形状零影响），只差它们第 102 帧那一发慢弹。
---  ★ 火花：`ins_111(0, 0x40000, …)` 把 0 号 transform 记录写成 DESPAWN，配上
---    transformFlags 0x40204 → 出生当帧 `AdvanceTransformProgram` 就把 state 打到
---    DESPAWNING（BulletManager.cpp:310-323、432-434）→ **纯观感、永远不伤人**，
---    播完 etama.anm script 16（12 帧）就消失。它们照旧占 1536 个弹槽
---    （BulletManager.hpp:455；整波生不出来就丢掉，BulletManager.cpp:686-712）。
---  ★ 贴图占位：节点不可见（原作就是 NO_SPRITE）、光柱用 THlib 的 laser 类、
---    火花与慢弹用 ball_small（TH08 色号 6 → 我们的 7 号色）。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---根 Sub76 的节拍。
local CYCLE_FIRST = 110                 -- ins_4 的落点 = 每个周期的第 0 帧
local CYCLE_PERIOD = 240                -- t=290 + 60 帧 → t=350 跳回 t=110
local WANDER_PHASE = 180                -- t=290 − t=110
local BOSS_END_X, BOSS_END_Y = 0, 96    -- ins_64(110, 4, 192, 128)
local BOSS_MOVE_FRAMES = 110
local WANDER_FRAMES = 60                -- ins_67(60, 4, 1.0)
local WANDER_SPEED = 1.0
local BRANCH_BASE = 1.2566371           -- lf7 的常量项 = 2π/5 = 72°
local BRANCH_JITTER = 0.3926991         -- lf7 的随机系数 = π/8 = 22.5°

---蛛网节点 Sub79 的节拍。
local WEB_DEPTH_MAX = 8                 -- ins_44(xi0, 8, …)
local WEB_SPARKS = 7                    -- xi1 = 7 的 JUMP_DEC 循环
local SPARK_INTERVAL = 2                -- 那条 JUMP_DEC 的 time = 2
local CHILD_FRAME = 12                  -- 7 发火花走完那一帧（0,2,…,12）
local MOVE_FRAMES = 14                  -- ins_64(14, 0, …)
local MOVE_DIST = 70
local EXTRA_FRAME = 102                 -- 子节点生成后 context time 到 92 → 本节点第 102 帧
local EXTRA_SPEED = 1.0                 -- ins_99 的 speed1
local EXTRA_ANGLE = -PI / 2             -- TH08 π/2 = 朝下 → 我们也是 −π/2
local SPARK_SPEED = 0.1                 -- 火花的 speed1
local SPARK_LIFE = 12                   -- etama.anm script 16 = 12 帧
local SPAWN_FAST_FRAMES = 10            -- etama.anm script 21 = 10 帧

---光柱（ins_114 CREATE_LASER）。
local LASER_LEN = 600                   -- endOffset − startOffset
local LASER_W = 5                       -- THlib 的 w：判定半宽 = w/2 = 2.5
local LASER_W0 = 1.2                    -- STARTING 段的细线宽度（BulletManager.cpp:1081）
local LASER_START_TIME = 110
local LASER_RAMP = 30
local LASER_DURATION = 50
local LASER_DESPAWN = 20
local LASER_SLOTS = 256                 -- `Laser lasers[0x100]`（BulletManager.hpp:313-339）
local POOL_SIZE = 1536                  -- `Bullet bullets[0x601]`（BulletManager.hpp:455）
local COLOR209 = COLOR.ROYAL_BLUE       -- TH08 色号 6 → 我们的 7 号色

---本卡的弹池（= 原作 1536 个弹槽）与光柱槽（= 原作 256 个激光槽）。
local pool = {}
local lasers = {}
---蛛网节点登记表（原作那 480 个敌机槽里被本卡占用的部分）。
local webs = {}

local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local function laser_used()
    for i = #lasers, 1, -1 do
        if not IsValid(lasers[i]) then
            table.remove(lasers, i)
        end
    end
    return #lasers
end

local lw209_spark
local lw209_bullet
local lw209_laser
local lw209_web

---火花（Sub79 t=0..12 的 7 发 ins_99）。出生当帧就在 DESPAWNING（见头部注释），
---每帧 `position += velocity/2`（BulletManager.cpp:1005-1013），12 帧后消失，判定全程关着。
---是 `object` 而不是 `bullet`：它永远打不到自机，也不该进 tools 的威胁统计。
lw209_spark = Class(object, {
    init = function(self, x, y, angle)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY_BULLET
        self.img = "ball_small7"
        self.hscale, self.vscale = 0.5, 0.5
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self.lw209_vx = math.cos(angle) * SPARK_SPEED
        self.lw209_vy = math.sin(angle) * SPARK_SPEED
        self.lw209_life = SPARK_LIFE
    end,
    render = function() end,
    frame = function(self)
        self.x = self.x + self.lw209_vx / 2
        self.y = self.y + self.lw209_vy / 2
        self.lw209_life = self.lw209_life - 1
        if self.lw209_life <= 0 then
            object.RawDel(self)
        end
    end,
})

---Sub79 t=102 的那发慢弹。transformFlags = 514 = 0x202（SPAWN_FAST|PLAY_SPAWN_SOUND）：
---出生瞬间先把位置往回退 velocity·4，之后每帧只走 velocity/2，动画（10 帧）播完那一帧
---才转 FIRED、补一次完整速度（BulletManager.cpp:936-945 的 BULLET_STATE_SPAWNING_FAST）。
---出生动画期间**没有判定**（判定在 FIRED 分支里），所以 colli 要到那时才开。
lw209_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed)
        bullet.init(self, ball_small, COLOR209, false, true)
        self.lw209_angle = angle
        self.lw209_speed = speed
        self.lw209_vx = math.cos(angle) * speed
        self.lw209_vy = math.sin(angle) * speed
        self.x = x - self.lw209_vx * 4
        self.y = y - self.lw209_vy * 4
        self.vx, self.vy = self.lw209_vx / 2, self.lw209_vy / 2
        self.lw209_spawn = SPAWN_FAST_FRAMES
        self.colli = false
    end,
    frame = function(self)
        if self.lw209_spawn > 0 then
            self.lw209_spawn = self.lw209_spawn - 1
            if self.lw209_spawn == 0 then
                self.vx, self.vy = self.lw209_vx, self.lw209_vy
                self.colli = true
            end
        end
        bullet.frame(self)
    end,
})

---光柱（ins_114）。状态机见头部注释；`alpha = 1` 是 THlib laser:frame 开判定的条件。
lw209_laser = Class(laser, {
    init = function(self, x, y, angle)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）
        ---l1/l2/l3 = 尾/身/头三段长度；这里只要一段 600 的身部。
        laser.init(self, COLOR209, x, y, angle, 0, LASER_LEN, 0, LASER_W0, 0, 0)
        self.lw209_state = 1
        self.lw209_timer = 0
        self.alpha = 1
        self.colli = false        -- STARTING 段还没有判定（hitboxStartTime == startTime）
        ---★ 光柱的寿命只由它自己的状态机决定：原作把这 256 条光柱存在固定槽位里，
        ---  槽位要到状态机跑完才释放（BulletManager.cpp:1049-1150），光柱**不会**因为
        ---  起点离开场地就被回收 —— 深几代的蛛网节点本来就在场外（一棵 8 代的树半径能
        ---  到 480 px），而起点在场外的光柱照样能横扫过场地打人。
        ---  不关 bound 的话，起点出界的那些会被引擎立刻回收，槽位也提前空出来。
        self.bound = false
    end,
    frame = function(self)
        local t = self.lw209_timer
        if self.lw209_state == 1 then
            local ramp = LASER_START_TIME > LASER_RAMP and LASER_RAMP or LASER_START_TIME
            if LASER_START_TIME - ramp < t then
                self.w = t * LASER_W / LASER_START_TIME
            else
                self.w = LASER_W0
            end
            if t >= LASER_START_TIME then
                ---原作这里不 break，直接落到 ACTIVE 那一支
                self.lw209_state = 2
                self.lw209_timer = 0
                t = 0
            end
        end
        if self.lw209_state == 2 then
            self.w = LASER_W
            self.colli = true
            if t >= LASER_DURATION then
                self.lw209_state = 3
                self.lw209_timer = 0
                t = 0
            end
        end
        if self.lw209_state == 3 then
            ---消散段关判定：原作那 20 帧把判定盒的长度改写成 currentWidth/2、盒心却还钉在
            ---position + 300，只剩「光柱中点附近一个 5 px 的小方块」（见头部注释），
            ---照抄一个 600 px 长的盒子反而更危险、更不忠实。
            self.colli = false
            self.w = LASER_W - t * LASER_W / LASER_DESPAWN
            if t >= LASER_DESPAWN then
                object.RawDel(self)
                return
            end
        end
        self.lw209_timer = t + 1
        laser.frame(self)
    end,
})

---一次出弹（SpawnBulletPattern：BulletManager.cpp:685-712）。池满 → 整波不生。
local function spawn_by_pool(factory)
    if pool_used() >= POOL_SIZE then
        return
    end
    pool[#pool + 1] = factory()
end

---蛛网节点（Sub79）。
---dir/depth/li5/jitter 都是「上一帧那条 ins_94 时变量块里的值」：
---  dir    = 本节点的 lf0（TH08 口径换成**我们口径**存：−TH08 角）
---  depth  = xi0（生成了几个后代）
---  li5    = 根的循环计数（0 = 第 1 轮，>= 1 = 第 2 轮起才有第 102 帧那发慢弹）
---  jitter = lf7（整棵树共用）
lw209_web = Class(object, {
    init = function(self, x, y, dir, depth, li5, jitter)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        ---原作 NO_SPRITE：拿 0 透明度的 "white" 顶替，视觉上不存在。
        self.img = "white"
        self.hscale, self.vscale = 0.01, 0.01
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 0
        self.lw209_t = 0
        self.lw209_dir = dir
        self.lw209_depth = depth
        self.lw209_li5 = li5
        self.lw209_jitter = jitter
        self.lw209_x0, self.lw209_y0 = x, y
        self.lw209_dx = math.cos(dir) * MOVE_DIST
        self.lw209_dy = math.sin(dir) * MOVE_DIST
        self.lw209_extra = false
    end,
    render = function() end,
    frame = function(self)
        local t = self.lw209_t
        if t == 0 then
            ---ins_114：光柱生成在**移动前**的位置（RunEcl 先跑、UpdateMovement 后跑）。
            ---槽满就整发不生成（SpawnLaserPattern 从头找第一个空槽）。
            if laser_used() < LASER_SLOTS then
                lasers[#lasers + 1] = New(lw209_laser, self.x, self.y, self.lw209_dir)
            end
        end
        ---7 发火花：t = 0,2,4,…,12 各一发（RANDOM_ANGLE 在 TH08 口径下均匀，
        ---取反后仍均匀，直接把我们的角写成就行）。
        if t <= CHILD_FRAME and t % SPARK_INTERVAL == 0 then
            spawn_by_pool(function()
                return New(lw209_spark, self.x, self.y, ran:Float(-PI, PI))
            end)
        end
        if t == CHILD_FRAME then
            local nd = self.lw209_depth + 1
            if nd < WEB_DEPTH_MAX then
                ---子节点生成在**父节点当前位置**（已走完 12/14 步 = 60 px），
                ---方向 = 本节点的 lf0 ± lf7，lf7 与 li5 原样继承。
                local d = self.lw209_dir
                local j = self.lw209_jitter
                webs[#webs + 1] = New(lw209_web, self.x, self.y, d + j, nd,
                        self.lw209_li5, j)
                webs[#webs + 1] = New(lw209_web, self.x, self.y, d - j, nd,
                        self.lw209_li5, j)
                ---`ins_44(li5, 1, …)` 不跳（li5 >= 1）时才等 92 帧补那一发慢弹。
                self.lw209_extra = self.lw209_li5 >= 1
            else
                ---`xi0 >= 8` → ins_1 TERMINATE（第 1 轮的网只活到这一帧）。
                object.RawDel(self)
                return
            end
        end
        if t == EXTRA_FRAME then
            if self.lw209_extra then
                spawn_by_pool(function()
                    return New(lw209_bullet, self.x, self.y, EXTRA_ANGLE, EXTRA_SPEED)
                end)
            end
            ---ins_1 TERMINATE（跑完那一发就消失）
            object.RawDel(self)
            return
        end
        ---插值位移一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支，缓动 0 = 线性）。
        if t < MOVE_FRAMES then
            local u = (t + 1) / MOVE_FRAMES
            self.x = self.lw209_x0 + self.lw209_dx * u
            self.y = self.lw209_y0 + self.lw209_dy * u
        end
        self.lw209_t = t + 1
    end,
})

---`ins_75(32, 48, 352, 128)`（**生成助手** t=0 设的移动边界，同时置 CLAMP_POSITION）→
---我们坐标的夹框 x∈[−160,160]、y∈[96,176]；下面四条判据拿「边界 ±96/48」去比。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）把角卷进 (−π, π]。原作只对「自机在左」
---那一支做（EclDependencies.cpp:135-138），后面的符号判据全靠它。
local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---抽角度 + 四条边界修正，再交给 StartTimedPolarDisplacement（:105-126）
---（delta = (cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4）。
---★ 「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle`，用的是**上一段的
---  移动方向**、不是刚抽到的 angle —— 原作自己的怪癖，照抄，别「修」成 angle。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BW_TH_L + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.lw209_movement_angle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---StartTimedPolarDisplacement（EclDependencies.cpp:106-126）：operand0 = 60 > 0 →
---「60 帧走完 (cos,sin)(angle)·1.0·60 = 60 px」的插值，缓动 4 = OUT_QUADRATIC。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw209_movement_angle = angle
    owner.lw209_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121）。缓动 4 = OUT_QUADRATIC = 1−(1−u)²。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---Sub76 每帧（原作 RunEcl 主 context → 子 context，然后才是 UpdateMovement）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑（tools/check_stage.lua 也照抄了这个顺序），
    ---  那几帧 lw209_t 还是 nil；卡 205/206/207/208/218 同款守卫。
    if not owner.lw209_t then return end
    local f = owner.lw209_t
    if f >= CYCLE_FIRST then
        local ph = (f - CYCLE_FIRST) % CYCLE_PERIOD
        if ph == 0 then
            ---t=110：lf0 = AIM_TO_PL、xi0 = 0、lf7 = rndUnit·(−π/8) + 2π/5、生成 1 个节点。
            ---AIM_TO_PL 是 TH08 口径「从 BOSS 指向自机」的角；我们坐标里取反即可。
            local aim = math.atan2(to_th08_y(player.y) - to_th08_y(owner.y),
                                   to_th08_x(player.x) - to_th08_x(owner.x))
            local jitter = BRANCH_BASE - BRANCH_JITTER * ran:Float(0, 1)
            webs[#webs + 1] = New(lw209_web, owner.x, owner.y, -aim, 0, owner.lw209_li5,
                    jitter)
        elseif ph == WANDER_PHASE then
            ---t=290：ins_67 随机走 60 px（缓动 4），同帧 li5++。
            begin_wander(owner)
            owner.lw209_li5 = owner.lw209_li5 + 1
        end
    end
    local move = owner.lw209_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw209_move = nil
        end
    end
    ---ClampPosition（EnemyManager.cpp:803-819）：生成助手的 `ins_75` 置了 CLAMP_POSITION，
    ---原作每帧在位移**前后**各钳一次（EnemyManagerUpdate.cpp:172-174）；这里位移只在本函数里变。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
    owner.lw209_t = f + 1
end

local function card_init(owner)
    owner.lw209_t = 0
    owner.lw209_li5 = 0
    ---★ 落位：生成助手 Sub80 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    ---movementAngle = VectorAngle(0, 0) = 0（见上）。
    owner.lw209_movement_angle = 0
    owner.lw209_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub76 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_129/130/105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw209_t 它会继续按周期出网（卡 205/206/207/208 都踩过同款坑）。
    owner.lw209_t = nil
    owner.lw209_move = nil
    owner.lw209_li5 = nil
    for i = #webs, 1, -1 do
        if IsValid(webs[i]) then
            object.RawDel(webs[i])
        end
        webs[i] = nil
    end
    for i = #lasers, 1, -1 do
        if IsValid(lasers[i]) then
            object.RawDel(lasers[i])
        end
        lasers[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[209] = {
    init = function(owner)
        pool = {}
        lasers = {}
        webs = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 210「蓬莱之树海」（蓬莱山辉夜）
---  ecldata7sp.ecl：Sub79 = BOSS 根、Sub80 = 樹（使魔）、Sub81 = BOSS 的并行子 ECL（环）、
---  Sub82 = 樹的枪。整张卡只有这四处，下面每条「文件:行号」都能在本机复查。
---
---  · Sub79（根）：
---      t=0    入场 `ins_64(110, 4, 192, 128)` 插值到 TH08 (192,128) = 我们 (0,96)。
---      t=110  `ins_81(4)`/`ins_160(180)`/`ins_62()`/`ins_52(33)`：开判定、伤害减免 180 帧、
---             特殊动画、循环放特效（Sub33 纯观感）—— 由 boss 系统与 lw_before 管，不另写。
---      t=130  一次性做完三件事：
---             ① `ins_64(240, 0, selfX, 64)`：240 帧**线性**从 (192,128) 移到 (192,64)
---                = 我们 (0,96) → (0,160)（往上飞 64 px）。缓动 0 = LINEAR。
---             ② 7 个 `ins_91(80, 0, 0, life, −2, 100)`（SPAWN_FAMILIAR_AT_OFFSET）：
---                ★ 偏移是**字面量 0,0**（operandFlags = 0，裸字节复核过），7 棵树全长在
---                  BOSS 身上，靠继承过去的 `li0` = 2/4/6/8/10/13/14 与
---                  life = 4000/2100/1000/1000/1000/2100/4000 区分。
---                  子 context 整块拷父的 int+float 变量（EnemyTimeline.cpp:64-108 的
---                  EnemyContextCopy 0x78 字节）→ 每棵树拿到自己的 lf0/lf1/lf2/lf3。
---                  树的出生位置 = 父 worldPosition + 偏移 = BOSS 的位置（**移动前**的
---                  (192,128)：SpawnEnemy2 在 RunEcl 里跑，而 UpdateMovement 在后面）。
---             ③ `ins_135(0, 81)`：给 BOSS 挂上并行子 ECL（Sub81 = 环）。
---      t=290  `ins_4(130, 0)`：位移 0 = **跳到自己**（把时间拨回 130、指令指针原地不动，
---             EclRunLow.inl:239-243）→ t=130 那一整块**只跑一次**；之后 context 的时间在
---             130..290 之间空转（真要循环的块写负位移：Sub82 是 −80、Sub81 是 −1848）。
---  · Sub80（樹）：给 position.x / position.y 各装一个 120 帧的 Hermite 插值
---      （op36 INSTALL_INTERPOLATION，callback 7 = InterpolateHermite，
---      EclDependencies.cpp:325-350）。op36 的操作数是
---      [目标 float 变量, 时长, 回调号, 缓动, p0, p1, p2, p3]，本卡是：
---        x：p0 = xf0 = 自己的 x、p1 = lf0 = 192 + 32·cos φ、p2 = cf2 = lf3·cos ψ、p3 = ±400
---        y：p0 = xf1 = 自己的 y、p1 = lf1 = 288 + 32·sin φ、p2 = cf3 = lf3·sin ψ、p3 = ±400
---      其中 φ = lf4 = −π/2 + k·2π/7、ψ = lf2 = −k·2π/7、lf3 = 400；
---      p3 的两个符号是**两次独立随机抽**（op9 SET_FLOAT_RANDOM_SIGN，先 x 后 y，
---      EclRunLow.inl:257-260），所以每根树枝甩出的弧线都不一样。
---      Hermite 是控制点的仿射组合（权重和 = 1），所以整体平移/翻转不改形状 ——
---      移植版把 4 个控制点**留在 TH08 口径**算完，再把结果换算回我们的坐标（最不容易错）。
---      ★ 插值的计时器在**每帧尾部**先 +1 再算进度（EclRun.cpp:133-146），
---        所以出生当帧进度就是 1/120、第 120 帧到 1.0；t=1 的权重是 w1 = 1，
---        终点的 x/y 分量恰好 = p1 → 7 棵树最后停在以 (192,288) 为心、半径 32 的圆上
---        （TH08 口径），= 我们坐标里以 (0,−64) 为心、半径 32 的圆上。
---      t=120  `ins_65(0, 0)` 停住 + `ins_81(3)` 开判定 + 三条 `ins_111`（见下）；
---      t=150  `ins_135(0, 82)` 挂上自己的枪；t=30150 又是那个「跳到自己」→ 枪只挂一次。
---  · Sub82（樹的枪）：每 8 帧一对**相反方向**的弹。
---      `ins_99(type 17, color li0, count1 = 2, count2 = 1, speed1 = 2.1, speed2 = 0.5,
---       angle = π + n·π/40, angleStep = π/32, flags = 0x4A82)`：CIRCLE 的角是
---      `index1·2π/count1 + index2·angleStep + angle`（BulletManager.cpp:143-149），
---      count1 = 2 且 count2 = 1 → 就是角度相差 π 的两发、速度都取 speed1。
---      flags 0x4A82 = SPAWN_FAST(2) | DIR_AIMED(0x80) | PLAY_SPAWN_SOUND(0x200) |
---      BOUNCE_EXCEPT_BOTTOM(0x800) | SET_SPRITE(0x4000)（BulletManager.hpp:129-156）。
---  · 三条 op111（Sub80 t=120 写进**樹的** bulletSpawnDescriptor，所有树弹共用）：
---      slot0 `[0, 0x800, allow 0, int0 = 0, int1 = −1, float0 = −999.9, float1 = 0]`
---        = 弹墙：bounceLimit = payload.int0 = **0**、bounceSpeed = 当前速度
---          （float0 < 0 → 取 this->speed，BulletManager.cpp:369-376）；
---          撞一次就 `bouncesCompleted(1) >= bounceLimit(0)` 把状态清掉（:1397-1406）。
---      slot1 `[1, 0x80, allow 0, int0 = 1, int1 = 1, float0 = 0, float1 = 2.4]`
---        = 自机狙：intervalFrames = 1、repeatCount = 1、angle = 0、speed = 2.4。
---      slot2 `[2, 0x4000, allow 0, int0 = 2, int1 = li0, float0 = −1, float1 = −1]`
---        = 换精灵：bulletType = 2、color = li0（operandFlags = 0x10 → 只有 int1 是变量）。
---      ★ 三条的 allowWhileActive 都是 0，而 AdvanceTransformProgram 在
---        `allowWhileActive == 0 && activeTransformFlags != 0` 时直接 return（:321-323）
---        → 必须等前一条的状态结束才会轮到下一条。这张卡的节奏就是
---        「弹出去撞一次墙 → 拐过来直冲自机 → 换贴图」。
---  · 出屏回收（:857-899）：判据是**整颗精灵**出没出场地（IsWithinPlayfield 要加半个
---      精灵宽高，GameManager.cpp:132-150），而弹墙的翻轴判据用的是**中心的裸坐标**
---      （`x < 0 || x >= 384`、上边 `y < 0`，下边因为 BOUNCE_EXCEPT_BOTTOM 不翻）。
---      于是「撞墙那一帧」的位置一定是刚越过 (场地 + 半精灵) 的那一帧，而反弹后的位移
---      正好把它带回来 → **同帧的出屏判定放行**，弹活下来；下一帧才轮到自机狙记录。
---      只有往下飞的那半圈（下边不反弹、也不满足任何翻轴条件）会在这一帧直接消失。
---  · Sub81（环）：`ins_2(15)`（SET_SECONDARY_TIME → 把 context 暂停 15 帧）+ `ins_99`
---      ×14（color 依次 2/4/6/8/10/13/14 循环两轮），每发 count1 = 16、count2 = 1、
---      speed1 = lf7 = 2.5、angle 交替 lf0/lf1，lf0 每发 +0.0122718、lf1 每发 −0.0122718。
---      14 × 15 = 210 帧一轮，块尾 `ins_4(600, −1848)` 回到块首（JUMP 会把 time 拨回 600，
---      于是同帧重跑整个块 → 下一轮的 shot1 与这一轮的 shot14 相隔仍是 15 帧）。
---      **第一条指令在 t=600** → 从挂上（BOSS t=130）起数 600 帧才开火 = BOSS t=730。
---      flags 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND；BOSS 自己没写过 blueprint
---      （records 全 0 = BULLET_TRANSFORM_NONE）→ 环的弹是普通直飞弹。
---  · 时间：`ins_134(5940, 21)` = 5940 帧后结束（99 秒，和 LIST 里的秒数一致）。
---  · 占位贴图：樹 = "servant"、弹 = ball_small（TH08 色号 2/4/6/8/10/13/14 →
---    我们的 3/5/7/9/11/14/15，见文件头）。17 张全部实现完之后再统一换素材。
---  ★ 已知差异：原作这 7 棵树**可以打掉**（`ins_81(3)` 开 ACCEPTS_DAMAGE|COLLISION、
---    life 1000..4000），打掉就不再放弹；移植版跟其它卡一样不给使魔判定
---    （占位做法，见卡 218 的娃娃），所以 7 棵树会一直在场上。
---  ★ 换精灵那条记录（slot2）只改观感：移植版占位不改贴图，见「统一换素材」。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（见文件头）：x_我们 = x_原作 − 192、y_我们 = 224 − y_原作。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---Sub79（BOSS 根）的节拍。
local FIRST_Y = 96                      -- ins_64(110, 4, 192, 128)：TH08 y=128 → 我们 96
local FIRST_FRAMES = 110
local SPAWN_FRAME = 130                 -- t=130：7 棵树 + 挂上环 + 开始上移
local BOSS_END_Y = 160                  -- ins_64(240, 0, selfX, 64)：TH08 y=64 → 我们 160
local BOSS_MOVE_FRAMES = 240

---Sub80（樹）的节拍。
local TREE_COUNT = 7                    -- 7 次 ins_91（li0 = 2/4/6/8/10/13/14）
local TREE_FLIGHT = 120                 -- INSTALL_INTERPOLATION 的 duration
local TREE_ARM = 400                    -- lf3
local TREE_RADIUS = 32                  -- lf0/lf1 里围着 (192,288) 的那个半径
local TREE_CENTER_Y_TH08 = 288          -- lf1 的常量项（TH08 口径）
local TREE_GUN_FRAME = 150              -- Sub80 t=150 → ins_135(0, 82)
local TREE_FIRE_PERIOD = 8              -- Sub82 尾部的 JUMP（位移 −80，落点 t=0）
local TREE_SHOT_SPEED = 2.1             -- Sub82 的 speed1 = lf0
local TREE_TURN_SPEED = 2.4             -- op111 slot1 的 directionChange.speed
local TREE_TURN_INTERVAL = 1            -- op111 slot1 的 intervalFrames
local TREE_ANGLE_STEP = PI / 40         -- Sub82 的 lf2（每发 +4.5°）

---Sub81（BOSS 的环）的节拍。
local RING_FIRST = 600                  -- 子 ECL 的第一条指令在 t=600
local RING_GAP = 15                     -- ins_2(15) 的暂停帧数
local RING_SHOTS = 14                   -- 一轮 14 发
local RING_CYCLE = RING_SHOTS * RING_GAP
local RING_COUNT = 16                   -- count1
local RING_SPEED = 2.5                  -- speed1 = lf7
local RING_STEP = 0.012271847           -- lf0/lf1 每发的增量

---弹的公共参数。
local SPAWN_FAST_FRAMES = 10            -- etama.anm script21（+10 那条 ins_1）
local POOL_SIZE = 1536                  -- BulletManager.hpp:455（0x600 个弹槽）
local SPRITE_HALF = 8                   -- bulletType 17 的贴图 sprite302 = 16×16（etama.decl）
local BOUNCE_LIMIT = 0                  -- op111 slot0 的 bounceLimit = intPayload0
local OUTSIDE_KEEP = 0x80               -- 带活动状态的弹最多在外面拖 128 帧
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---TH08 色 2/4/6/8/10/13/14 → 我们的 3/5/7/9/11/14/15（同色名 +1）。
local TREE_COLORS = {
    COLOR.DEEP_PURPLE, COLOR.DEEP_BLUE, COLOR.ROYAL_BLUE,
    COLOR.DEEP_GREEN, COLOR.CHARTREUSE, COLOR.ORANGE, COLOR.DEEP_GRAY,
}

---本卡的弹池（= 原作那 1536 个弹槽）与树登记表。
local pool = {}
local trees = {}

---弹 / 樹 的类（先声明：下面的 spawn_bullet 要引用这个 upvalue）。
local lw210_bullet
local lw210_tree

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---本卡的弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（不看位置，
---BulletManager.cpp:810-816 每帧先清零再数一遍），所以这里只按「对象还活着」清表。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---一次出弹（SpawnBulletPattern：BulletManager.cpp:685-712）。池满 → 整波不生。
local function spawn_by_pool(factory)
    if pool_used() >= POOL_SIZE then
        return
    end
    pool[#pool + 1] = factory()
end

local function spawn_bullet(x, y, angle, speed, color, is_tree)
    spawn_by_pool(function()
        return New(lw210_bullet, x, y, angle, speed, color, is_tree)
    end)
end

---AdvanceTransformProgram 的移植（BulletManager.cpp:310-332 的推进规则）。
---只有樹的弹带记录：0 = 弹墙（出生当帧就生效，这里用 lw210_state = "bounce" 表示）、
---1 = 自机狙、2 = 换精灵。`allowWhileActive == 0` 的记录必须等状态清掉才轮到。
local function bullet_advance(self)
    if self.lw210_state or self.lw210_prog >= 3 then
        return
    end
    if self.lw210_prog == 1 then
        ---记录 1 生效：timer = 0、directionChangesCompleted = 0
        self.lw210_prog = 2
        self.lw210_state = "dir"
        self.lw210_dir_timer = 0
        self.lw210_dir_done = 0
    else
        ---记录 2（SET_SPRITE）：换完立刻继续往下，程序到此结束（下一条是 NONE）。
        ---占位实现不改贴图（见文件头）。
        self.lw210_prog = 3
    end
end

---UpdateBoundaryBounce（BulletManager.cpp:1374-1418）。
---   · 先看整颗精灵出没出场地；
---   · 再按**中心的裸坐标**决定翻哪条轴（我们坐标：x < l || x >= r、上边 y > t）；
---     本卡是 BOUNCE_EXCEPT_BOTTOM → 下边永远不翻（只有 ALL_EDGES 才翻）；
---   · 速度回到 bounceSpeed（本卡 = 出生速度，因为 payload.speed = −999.9 < 0）；
---   · bouncesCompleted(1) >= bounceLimit(0) → **当帧**把弹墙状态清掉。
local function bullet_bounce(self)
    if not outside_field(self.x, self.y) then
        return
    end
    if self.x < FIELD_L or self.x >= FIELD_R then
        self.lw210_bvx = -self.lw210_bvx        -- 原作 angle = −angle − π
    end
    if self.y > FIELD_T then
        self.lw210_bvy = -self.lw210_bvy        -- 原作 angle = −angle
    end
    self.lw210_bounces = self.lw210_bounces + 1
    if self.lw210_bounces >= BOUNCE_LIMIT then
        self.lw210_state = nil
    end
end

---UpdateAimedDirectionChange（BulletManager.cpp:1332-1372）。
---intervalFrames = 1、repeatCount = 1：生效后的第 1 帧只把 timer 往前推
---（magnitude = speed − timer·speed/interval = 原速度、角度不动），**第 2 帧**才把角度
---改成「朝自机」、速度跳到 2.4，并把状态清掉 —— 所以只瞄一次、之后直线飞出去。
local function bullet_dir(self)
    if self.lw210_dir_timer >= TREE_TURN_INTERVAL then
        self.lw210_dir_done = self.lw210_dir_done + 1
        if self.lw210_dir_done >= 1 then
            self.lw210_state = nil
        end
        self.lw210_dir_timer = 0
        local dx, dy = player.x - self.x, player.y - self.y
        local d = math.sqrt(dx * dx + dy * dy)
        if d > 1e-4 then
            self.lw210_bvx = dx / d * TREE_TURN_SPEED
            self.lw210_bvy = dy / d * TREE_TURN_SPEED
        end
    else
        self.lw210_dir_timer = self.lw210_dir_timer + 1
    end
end

---樹 / 环的弹。is_tree = true 时带 op111 那三条记录；环的弹没有任何变换程序。
---出生（SPAWN_FAST）：位置先退 velocity·4，之后每帧只走 velocity/2，
---动画（10 帧）播完那一帧落到 FIRED 分支：同帧再走一遍完整位移（BulletManager.cpp:950-968）。
lw210_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color, is_tree)
        ---bullet:init(imgclass, index, stay, destroyable)（THlib/bullet/bullet.lua:75）
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（卡 206/209 同款）
        self.lw210_bvx = math.cos(angle) * speed
        self.lw210_bvy = math.sin(angle) * speed
        self.vx, self.vy = 0, 0             -- 引擎的自动积分必须保持 0，位移全在 frame 里算
        self.x = x - self.lw210_bvx * 4
        self.y = y - self.lw210_bvy * 4
        self.lw210_spawn = SPAWN_FAST_FRAMES
        self.colli = false                  -- 出生动画期间没有判定
        ---变换程序：is_tree 的弹出生当帧就已经吃下记录 0（弹墙状态生效）。
        self.lw210_prog = is_tree and 1 or 3
        self.lw210_state = is_tree and "bounce" or nil
        self.lw210_bounces = 0
        self.lw210_dir_timer = 0
        self.lw210_dir_done = 0
        self.lw210_off = 0
    end,
    frame = function(self)
        local bvx, bvy = self.lw210_bvx, self.lw210_bvy
        ---① 出生动画：每帧只走 velocity/2；跑完那一帧不 return，继续往下走完整流程。
        if self.lw210_spawn > 0 then
            self.x = self.x + bvx * 0.5
            self.y = self.y + bvy * 0.5
            self.lw210_spawn = self.lw210_spawn - 1
            if self.lw210_spawn > 0 then
                bullet.frame(self)
                return
            end
            self.colli = true
        end
        ---② 推进变换程序（每帧最前面跑，BulletManager.cpp:820）
        bullet_advance(self)
        ---③ 活动状态的更新（同 :825-854 的顺序）
        if self.lw210_state == "bounce" then
            bullet_bounce(self)
        elseif self.lw210_state == "dir" then
            bullet_dir(self)
        end
        ---④ 位移，然后出屏回收（:857-899）
        self.x = self.x + self.lw210_bvx
        self.y = self.y + self.lw210_bvy
        if not outside_field(self.x, self.y) then
            self.lw210_off = 0
        elseif self.lw210_state then
            ---还有活动状态的弹出屏不立刻死，最多拖 128 帧
            self.lw210_off = self.lw210_off + 1
            if self.lw210_off >= OUTSIDE_KEEP then
                object.RawDel(self)
                return
            end
        else
            if self.lw210_off == 0 then
                object.RawDel(self)
                return
            end
            self.lw210_off = self.lw210_off - 1
        end
        bullet.frame(self)
    end,
})

---Hermite 插值（InterpolateHermite，EclDependencies.cpp:325-350）：
---w0 = (t−1)²(2t+1)、w1 = t²(3−2t)、w2 = (1−t)²t、w3 = (t−1)t²。
local function hermite(p0, p1, p2, p3, t)
    local m = t - 1
    return m * m * (2 * t + 1) * p0
            + t * t * (3 - 2 * t) * p1
            + (1 - t) * (1 - t) * t * p2
            + m * t * t * p3
end

---Sub82（樹的枪）：每 8 帧一对相反方向的弹，角度每发 +π/40（TH08 口径）。
---发弹位置用**上一帧末**的位置（RunEcl 在 UpdateMovement 之前）。
local function tree_gun(owner, t)
    if t < TREE_GUN_FRAME or (t - TREE_GUN_FRAME) % TREE_FIRE_PERIOD ~= 0 then
        return
    end
    local n = (t - TREE_GUN_FRAME) / TREE_FIRE_PERIOD
    local a = PI + n * TREE_ANGLE_STEP       -- TH08 口径；我们坐标整体取反
    local x, y, color = owner.x, owner.y, owner.lw210_color
    spawn_bullet(x, y, -a, TREE_SHOT_SPEED, color, true)
    spawn_bullet(x, y, -a - PI, TREE_SHOT_SPEED, color, true)
end

---樹（Sub80）。占位贴图 "servant"；原作它有 24×24 判定与 life（1000..4000），可被击破，
---移植版不给判定（占位口径，见文件头）。
lw210_tree = Class(object, {
    init = function(self, x, y, k)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.6, 0.6
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        self.lw210_t = 0
        self.lw210_color = TREE_COLORS[k + 1]
        ---φ = lf4、ψ = lf2（都是 TH08 口径）。控制点留在 TH08 口径算，算完再换算回我们坐标。
        local phi = -PI / 2 + k * (2 * PI / TREE_COUNT)
        local psi = -k * (2 * PI / TREE_COUNT)
        ---★ 两个 p3 的符号是两次独立随机抽，顺序是先 x 后 y（op9 在两条 op36 之前各一条）。
        self.lw210_cx = {
            to_th08_x(x),                                       -- p0 = xf0 = 自己的 x
            192 + TREE_RADIUS * math.cos(phi),                  -- p1 = lf0
            TREE_ARM * math.cos(psi),                           -- p2 = cf2 = lf3·cos ψ
            ran:Sign() * TREE_ARM,                              -- p3 = ±lf3
        }
        self.lw210_cy = {
            to_th08_y(y),                                       -- p0 = xf1 = 自己的 y
            TREE_CENTER_Y_TH08 + TREE_RADIUS * math.sin(phi),   -- p1 = lf1
            TREE_ARM * math.sin(psi),                           -- p2 = cf3 = lf3·sin ψ
            ran:Sign() * TREE_ARM,                              -- p3 = ±lf3
        }
    end,
    frame = function(self)
        local t = self.lw210_t
        ---枪先跑（EnemyManagerUpdate.cpp:159-192：RunEcl → UpdateMovement）。
        tree_gun(self, t)
        ---两个 120 帧 Hermite：计时器从 1 数到 120（EclRun.cpp:133-146 在尾部先 ++ 再算进度）。
        if t <= TREE_FLIGHT then
            local n = t + 1
            if n > TREE_FLIGHT then n = TREE_FLIGHT end
            local u = n / TREE_FLIGHT
            local cx, cy = self.lw210_cx, self.lw210_cy
            self.x = hermite(cx[1], cx[2], cx[3], cx[4], u) - 192
            self.y = 224 - hermite(cy[1], cy[2], cy[3], cy[4], u)
        end
        self.lw210_t = t + 1
    end,
})

---Sub81（BOSS 的环）：从挂上那一刻数 600 帧开火，之后每 15 帧一发、14 发一轮。
---第 k 发（k = 0..13）的角度偏移：偶数发取 lf0 = (k/2)·step、奇数发取 lf1 = −((k+1)/2)·step。
local function ring_shot(owner, rt)
    local k = math.floor(((rt - RING_FIRST) % RING_CYCLE) / RING_GAP)
    local off
    if k % 2 == 0 then
        off = (k / 2) * RING_STEP
    else
        off = -((k + 1) / 2) * RING_STEP
    end
    local x, y, color = owner.x, owner.y, TREE_COLORS[(k % TREE_COUNT) + 1]
    for i = 0, RING_COUNT - 1 do
        ---ANGLE = index1·2π/count1 + angle（BulletManager.cpp:143-149），我们整体取反。
        spawn_bullet(x, y, -(i * (2 * PI / RING_COUNT) + off), RING_SPEED, color, false)
    end
end

---Sub79 每帧（原作 RunEcl 主 context → 子 context，然后才是 UpdateMovement）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑，那几帧 lw210_t 还是 nil（卡 205..209 同款守卫）。
    if not owner.lw210_t then return end
    local f = owner.lw210_t
    if f == SPAWN_FRAME then
        ---① 7 棵树都生成在 BOSS **移动前**的位置（偏移是字面量 0,0）。
        for k = 0, TREE_COUNT - 1 do
            trees[#trees + 1] = New(lw210_tree, owner.x, owner.y, k)
        end
        ---② ins_135(0, 81)：挂上环（它自己再数 600 帧才开火）。
        owner.lw210_ring_t = 0
    end
    ---子 context（环）先跑，用的是**上一帧末**的位置。
    if owner.lw210_ring_t then
        local rt = owner.lw210_ring_t
        if rt >= RING_FIRST and (rt - RING_FIRST) % RING_GAP == 0 then
            ring_shot(owner, rt)
        end
        owner.lw210_ring_t = rt + 1
    end
    ---③ 位移：t<130 是入场插值（缓动 4 = OUT_QUADRATIC），t>=130 是线性上移 64 px。
    if f < SPAWN_FRAME then
        local mv = owner.lw210_move
        if mv then
            mv.t = mv.t + 1
            local u = mv.t / mv.n
            if u > 1 then u = 1 end
            local e = 1 - (1 - u) * (1 - u)
            owner.x = mv.x0 + mv.dx * e
            owner.y = mv.y0 + mv.dy * e
            if mv.t >= mv.n then
                owner.lw210_move = nil
            end
        end
    else
        local n = f - SPAWN_FRAME + 1
        if n > BOSS_MOVE_FRAMES then n = BOSS_MOVE_FRAMES end
        owner.y = FIRST_Y + (BOSS_END_Y - FIRST_Y) * (n / BOSS_MOVE_FRAMES)
    end
    owner.lw210_t = f + 1
end

local function card_init(owner)
    owner.lw210_t = 0
    owner.lw210_ring_t = nil
    ---★ 落位：生成助手 Sub83 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**。
    owner.x, owner.y = 0, FIRST_Y
    owner.lw210_move = {
        x0 = owner.x, y0 = owner.y,
        dx = 0 - owner.x, dy = FIRST_Y - owner.y,
        n = FIRST_FRAMES, t = 0,
    }
    ---原作 t=0 还有一串关射击、关判定、登记符卡、清场的指令 —— boss 系统与 lw_before 管。
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw210_t = nil
    owner.lw210_ring_t = nil
    owner.lw210_move = nil
    for i = #trees, 1, -1 do
        if IsValid(trees[i]) then
            object.RawDel(trees[i])
        end
        trees[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[210] = {
    init = function(owner)
        pool = {}
        trees = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 211「不死鸟再诞」（藤原妹红）
---  ecldata8sp.ecl：Sub110 = BOSS 根、Sub111 = 一次「凤凰」出弹、Sub112 = 凤凰本体。
---
---  · 时间轴：t=0 `ins_64(110, 4, 192, 128)` 入场插值到 TH08 (192,128) = 我们 (0,96)。
---    之后是 **680 帧一轮**的循环：t=850 的 `ins_4(170, −1560)` 跳回 064324
---    （= t=170 的第 4 条 `SET_FLOAT [lf0, π]`）—— 不是跳回 t=170 的第一条，
---    所以前面的 `SET_SECONDARY_HITBOX [256,24]`（064264）、`SET_INT [li7, 20]`
---    （064284）、`SET_FLOAT [lf5, 3]`（064304）**只跑一次**；循环体每轮把
---    li7 重置成 2、li6 重置成 1（= SHOOT_CIRCLE 的两个色号）。
---  · 一轮里有五段 CALL 111（Sub111），段与段之间 BOSS 随机飘 60 px：
---      t=190..230 ×5   每段前 lf0 = AIM_TO_PL（li6/li7 = 1/2）
---      t=260           ins_67 MOVE_RANDOM_IN_BOUNDS [60, 4, 1]（60 帧 · 1 px/帧）
---      t=340..380 ×5   lf0 = AIM_TO_PL
---      t=440           ins_67
---      t=500..560 ×7   lf0 = AIM_TO_PL − π/2 … + π/2（扇面，li6/li7 = 1/2）
---      t=560           li7 = 4、li6 = 3
---      t=570..630 ×7   lf0 = AIM_TO_PL + π/2 … − π/2（li6/li7 = 3/4）
---      t=630           li7 = 6、li6 = 5
---      t=640..700 ×7   lf0 = AIM_TO_PL − π/2 … + π/2（li6/li7 = 5/6）
---      t=230/380/700   `[lf5 ≥ 4] ? 不动作 : lf5 += 0.2`（lf5 = 第二圈圆环的速度；
---                      初值 3，跨轮一直累加到 4 —— 它在循环体里**不被重置**）
---      t=700           `SET_SECONDARY_TIME [li7]`：`li7 < 2` 时跳掉 INT_DEC
---                      （`ins_44(li7,2)` 的 +44 正好落在 SET_SECONDARY_TIME 上），
---                      所以从第二轮起 li7 恒为 1 → 每轮多冻 1 帧
---                      （EclRun.cpp:62-66：secondaryTime > 0 时 context 的时间
---                      **不前进**，但 RunEcl 末尾的 UpdateMovement 照跑）。
---  · Sub111（一次 CALL）：
---      t=0  `ins_111` ×2：给**这个敌机**的 bulletSpawnDescriptor 装两条记录 ——
---            记录 0 = SET_CULL_DELAY(0x2000)、frames = intPayload0 = 120；
---            记录 1 = ACCELERATE_VECTOR(0x10)、magnitude = floatPayload0 = 0.141667、
---            angle = floatPayload1 = −999.9 < −990 → 取弹自己的角度
---            （BulletManager.cpp:345-352）、durationFrames = intPayload0 = 120。
---            allowWhileActive 都是 0，但这两条都是「顺手跳过」的种类，出生当帧就生效。
---      t=0  `ins_94` SPAWN_ENEMY_RELATIVE [112, 0,0,0, life 1000, −2, 0]：生一只凤凰
---            （Sub112）。
---      t=0  `ins_97`（SHOOT_FAN）×26：24 发在 BOSS 周围排成「凤凰」轮廓
---            （偏移 = polar(lf0 + δ, r)，r ∈ 16/32/48/64/80/96，见 PHOENIX_OFFSETS），
---            外加两发零偏移（bulletType 7/color 1、bulletType 10/color 0）。
---            方向一律是 lf0 的**字面量**：FAN 模式的下标修正
---            `angle += ((index1+1)/2)·angleStep` 在 count1 = 1、angleStep = 0 时是 0，
---            而 FAN（不是 FAN_AIMED）不叠加自机角（BulletManager.cpp:130-141）。
---            flags = 0x2212 = SPAWN_FAST(2) | ACCELERATE_VECTOR(0x10) |
---            PLAY_SPAWN_SOUND(0x200) | SET_CULL_DELAY(0x2000)；
---            最后那发是 0x2214（把 SPAWN_FAST 换成 SPAWN_NORMAL(4)）。
---      t=0  `ins_99`（SHOOT_CIRCLE）×2：各 23 发（count1 = 23、count2 = 1），
---            angle = RANDOM_ANGLE + i·2π/23（:143-149）、
---            speed1 = lf5（第一条）/ 2.0（第二条）、color = li7 / li5（li5 从没写过 = 0）、
---            flags = 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND。
---  · Sub112（凤凰本体）：t=0 `ins_65(lf0, 0.3)` 沿 lf0 起步、t=20 `ins_71(0.025)`
---    开始加速；t=50 是一段「150 次循环改射击偏移」的怪代码（它既没有 ins_97/99、
---    也没设过 ins_105 的射击间隔 → 这个循环**一发弹都不出**），t=51 TERMINATE
---    → RunEcl 返回 −1 → 敌机 Despawn（EnemyManagerUpdate.cpp:161-165）。
---    移植版照做：飞 51 帧就自己消失。
---  · 出屏回收：SET_CULL_DELAY 让弹在**出生后 120 个 FIRED 帧**内不做出屏判定
---    （offscreenCullDelayFrames 每帧先减、再位移、再判，BulletManager.cpp:856-899），
---    之后一出屏就 Deactivate。出生动画那 10/15 帧不算在这 120 帧里。
---  · 占位贴图：凤凰 = "servant"、弹 = ball_small（TH08 色 c → 我们的 c+1）。
---    17 张全部实现完之后再统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（见文件头）：x_我们 = x_原作 − 192、y_我们 = 224 − y_原作。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---Sub110 的节拍。
local BOSS_END_Y = 96                   -- ins_64(110, 4, 192, 128)：TH08 y=128 → 我们 96
local BOSS_MOVE_FRAMES = 110
local CYCLE_FIRST = 170                 -- ins_4(170, −1560) 的落点时间
local CYCLE_LAST = 850                  -- 循环体最后一条（那条 ins_4）
local WANDER_1, WANDER_2 = 260, 440     -- 两次 ins_67
local WANDER_FRAMES = 60                -- ins_67 的参数 0
local WANDER_SPEED = 1.0                -- ins_67 的参数 2
local SECONDARY_HOLD = 1                -- t=700 的 SET_SECONDARY_TIME

---Sub111（一次 CALL 111）的弹参数。
local CULL_DELAY = 120                  -- op111 记录 0 的 frames
local PHOENIX_SPEED = 0.5               -- ins_97 的 speed1 / speed2
local PHOENIX_ACCEL = 0.141667          -- op111 记录 1 的 magnitude
local PHOENIX_ACCEL_FRAMES = 120        -- op111 记录 1 的 durationFrames
local SPAWN_FAST_FRAMES = 10            -- etama.anm script21 的长度
local SPAWN_NORMAL_FRAMES = 15          -- etama.anm script22 的长度
local SPAWN_FAST_STEP = 0.5             -- 出生期每帧走 velocity/2（BulletManager.cpp:951）
local SPAWN_NORMAL_STEP = 1 / 2.5       -- 出生期每帧走 velocity/2.5（:971）
local RING_COUNT = 23                   -- ins_99 的 count1
local RING_SPEED_2 = 2.0                -- 第二条 ins_99 的 speed1
local PHOENIX_COLOR_1 = 1               -- ins_97 打包字里的 color
local PHOENIX_COLOR_0 = 0               -- bulletType 10 那发的 color
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local POOL_SIZE = 1536                  -- BulletManager.hpp:455（0x600 个弹槽）

---24 个「凤凰」偏移（TH08 口径）：偏移角 = lf0 + δ、半径 = r。
---逐条对上 Sub111 的 24 组 ins_38 + ins_97（顺序就是原作的出生顺序）。
local PHOENIX_OFFSETS = {
    {  0,       32 }, {  3.14159, 32 }, {  2.0944,  32 }, { -2.0944,  32 },
    {  0,       16 }, {  3.14159, 16 }, {  2.0944,  16 }, { -2.0944,  16 },
    {  2.35619, 64 }, { -2.35619, 64 }, {  2.0944,  64 }, { -2.0944,  64 },
    {  2.51327, 96 }, { -2.51327, 96 }, {  2.35619, 96 }, { -2.35619, 96 },
    {  2.35619, 48 }, { -2.35619, 48 }, {  2.0944,  48 }, { -2.0944,  48 },
    {  2.51327, 80 }, { -2.51327, 80 }, {  2.35619, 80 }, { -2.35619, 80 },
}

---t → 这一次 CALL 111 写进 lf0 的偏移（TH08 口径：lf0 = AIM_TO_PL + shift）。
---常数都照抄 ECL 里的字面量（2.0944 / 1.1781 / 2.35619 / 2.51327 / 0.785398）。
local CALL_SHIFT = {}
for _, e in ipairs({
    { 190, 0 }, { 200, 0 }, { 210, 0 }, { 220, 0 }, { 230, 0 },
    { 340, 0 }, { 350, 0 }, { 360, 0 }, { 370, 0 }, { 380, 0 },
    { 500, -PI / 2 }, { 510, -1.1781 }, { 520, -0.785398 }, { 530, 0 },
    { 540, 0.785398 }, { 550, 1.1781 }, { 560, PI / 2 },
    { 570, PI / 2 }, { 580, 1.1781 }, { 590, 0.785398 }, { 600, 0 },
    { 610, -0.785398 }, { 620, -1.1781 }, { 630, -PI / 2 },
    { 640, -PI / 2 }, { 650, -1.1781 }, { 660, -0.785398 }, { 670, 0 },
    { 680, 0.785398 }, { 690, 1.1781 }, { 700, PI / 2 },
}) do CALL_SHIFT[e[1]] = e[2] end

---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
local function th08_color(c) return c + 1 end

---本卡自己的弹池（= 原作那 1536 个弹槽）与凤凰登记表。
local pool = {}
local phoenixes = {}

---弹 / 凤凰的类（先声明：下面的 spawn_batch 要引用这两个 upvalue）。
local lw211_bullet
local lw211_phoenix

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
---本卡四种弹的贴图都是占位 ball_small（16×16）→ 半宽高 8。
local SPRITE_HALF = 8
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---本卡的弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（不看位置，
---BulletManager.cpp:810-816 每帧先清零再数一遍），所以这里只按「对象还活着」清表。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---一次 SpawnBulletPattern（BulletManager.cpp:686-712）：
---activeBulletCount >= 0x600 → **整波不生**；波中间某一颗生不出来（1536 个槽全占满）
---→ 放弃这一波剩下的（音效照响，移植版本来也不放音效）。
local function spawn_batch(count, factory)
    if pool_used() >= POOL_SIZE then
        return
    end
    for i = 1, count do
        if #pool >= POOL_SIZE then
            return
        end
        pool[#pool + 1] = factory(i)
    end
end

---本卡的弹。出生动画（SPAWN_FAST / SPAWN_NORMAL）期间：位置先退 velocity·4，
---之后每帧只走 velocity/2 或 /2.5，动画播完那一帧补一次完整的 FIRED 更新
---（BulletManager.cpp:196-227、:950-1013）。
lw211_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color,
                    spawn_frames, spawn_step, accel, accel_frames, cull)
        ---bullet:init(imgclass, index, stay, destroyable)（THlib/bullet/bullet.lua:75）
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（卡 206/209/210 同款）
        self.lw211_bvx = math.cos(angle) * speed
        self.lw211_bvy = math.sin(angle) * speed
        self.vx, self.vy = 0, 0             -- 引擎的自动积分必须保持 0，位移全在 frame 里算
        self.x = x - self.lw211_bvx * 4
        self.y = y - self.lw211_bvy * 4
        self.lw211_spawn = spawn_frames
        self.lw211_step = spawn_step
        self.colli = false                  -- 出生动画期间没有判定
        ---ACCELERATE_VECTOR 的加速度向量是**出生那一刻**按弹自己的角度定下的固定向量
        ---（BulletManager.cpp:345-352 + :1204-1226），不是「一直沿着当前朝向」。
        self.lw211_acx = math.cos(angle) * accel
        self.lw211_acy = math.sin(angle) * accel
        self.lw211_accel = accel_frames
        ---SET_CULL_DELAY：出生当帧就写进 offscreenCullDelayFrames（:395-398），
        ---但只有 FIRED 分支每帧才减它（:856-857）→ 出生动画那几帧不算。
        self.lw211_cull = cull
    end,
    frame = function(self)
        ---① 出生动画：每帧只走 velocity·step；跑完那一帧不 return，继续走完整流程。
        if self.lw211_spawn > 0 then
            self.x = self.x + self.lw211_bvx * self.lw211_step
            self.y = self.y + self.lw211_bvy * self.lw211_step
            self.lw211_spawn = self.lw211_spawn - 1
            if self.lw211_spawn > 0 then
                bullet.frame(self)
                return
            end
            self.colli = true
        end
        ---② 活动状态的更新（BulletManager.cpp:825-854；本卡只有加速度一种状态）
        if self.lw211_accel > 0 then
            self.lw211_bvx = self.lw211_bvx + self.lw211_acx
            self.lw211_bvy = self.lw211_bvy + self.lw211_acy
            self.lw211_accel = self.lw211_accel - 1
        end
        ---③ 出屏延时先减
        if self.lw211_cull > 0 then
            self.lw211_cull = self.lw211_cull - 1
        end
        ---④ 位移
        self.x = self.x + self.lw211_bvx
        self.y = self.y + self.lw211_bvy
        ---⑤ 出屏回收（:857-899）：本卡没有 DIRECTION_CHANGE / BOUNCE 状态
        ---   → 延时一过，一出屏就消失。
        if self.lw211_cull == 0 and outside_field(self.x, self.y) then
            object.RawDel(self)
            return
        end
        bullet.frame(self)
    end,
})

---Sub112（凤凰本体）。占位贴图 "servant"；原作它有 life 1000 与判定，
---但 t=51 就 TERMINATE，移植版不给判定（占位口径，见文件头）。
local PHOENIX_LIFE = 51                 -- t=51 的 ins_1 TERMINATE
local PHOENIX_SPEED_0 = 0.3             -- ins_65 的 speed
local PHOENIX_ACCEL_0 = 0.025           -- ins_71 的参数
local PHOENIX_ACCEL_AT = 20             -- ins_71 在 t=20
lw211_phoenix = Class(object, {
    init = function(self, x, y, angle)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.5, 0.5
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        self.lw211_t = 0
        self.lw211_dir = angle          -- 我们坐标（= lf0 取反）
        self.lw211_spd = PHOENIX_SPEED_0
    end,
    frame = function(self)
        local t = self.lw211_t
        ---t=51 TERMINATE → RunEcl 返回 −1 → 敌机 Despawn（EnemyManagerUpdate.cpp:161-165）。
        if t >= PHOENIX_LIFE then
            object.RawDel(self)
            return
        end
        ---先跑 ECL（t=20 才装上加速度），再 UpdateMovement（POLAR：speed += accel）。
        if t >= PHOENIX_ACCEL_AT then
            self.lw211_spd = self.lw211_spd + PHOENIX_ACCEL_0
        end
        self.x = self.x + math.cos(self.lw211_dir) * self.lw211_spd
        self.y = self.y + math.sin(self.lw211_dir) * self.lw211_spd
        self.lw211_t = t + 1
    end,
})

---`ins_75(32, 48, 352, 128)`（**生成助手** t=0 设的移动边界，同时置 CLAMP_POSITION）→
---我们坐标的夹框 x∈[−160,160]、y∈[96,176]；下面四条判据拿「边界 ±96/48」去比。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）把角卷进 (−π, π]。原作只对「自机在左」
---那一支做（EclDependencies.cpp:135-138），后面的符号判据全靠它。
local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---抽角度 + 四条边界修正，再交给 StartTimedPolarDisplacement（:105-126）
---（delta = (cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4）。
---★ 「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle`，用的是**上一段的
---  移动方向**、不是刚抽到的 angle —— 原作自己的怪癖，照抄，别「修」成 angle。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BW_TH_L + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.lw211_mangle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---开始一次 60 帧的随机飘（TH08 口径的角度 → 我们坐标整体取反）。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw211_mangle = angle          -- 下一段 ins_67 的怪癖要用它
    owner.lw211_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0,
    }
end

---一次 CALL 111（Sub111）。lf0（TH08）= AIM_TO_PL + shift；换算到我们坐标只差一个
---整体取反（见文件头），所以方向 = dir − shift，其中 dir 就是「BOSS → 自机」的
---我们的角度（给自机狙用同一个数）。
local function call_111(owner, shift)
    local bx, by = owner.x, owner.y
    local dir = math.atan2(player.y - by, player.x - bx) - shift
    ---① ins_94：凤凰本体从此处起飞。
    phoenixes[#phoenixes + 1] = New(lw211_phoenix, bx, by, dir)
    ---② ins_97 ×24：凤凰轮廓。偏移角 = lf0 + δ（我们 = dir − δ），方向一律 lf0。
    spawn_batch(#PHOENIX_OFFSETS, function(i)
        local o = PHOENIX_OFFSETS[i]
        local a = dir - o[1]
        return New(lw211_bullet, bx + math.cos(a) * o[2], by + math.sin(a) * o[2],
                dir, PHOENIX_SPEED, th08_color(PHOENIX_COLOR_1),
                SPAWN_FAST_FRAMES, SPAWN_FAST_STEP,
                PHOENIX_ACCEL, PHOENIX_ACCEL_FRAMES, CULL_DELAY)
    end)
    ---③ ins_97：零偏移的那发 bulletType 7（SPAWN_FAST）。
    spawn_batch(1, function()
        return New(lw211_bullet, bx, by, dir, PHOENIX_SPEED, th08_color(PHOENIX_COLOR_1),
                SPAWN_FAST_FRAMES, SPAWN_FAST_STEP,
                PHOENIX_ACCEL, PHOENIX_ACCEL_FRAMES, CULL_DELAY)
    end)
    ---④ ins_97：零偏移的那发 bulletType 10（flags 0x2214 → 换成 SPAWN_NORMAL，15 帧 /2.5）。
    spawn_batch(1, function()
        return New(lw211_bullet, bx, by, dir, PHOENIX_SPEED, th08_color(PHOENIX_COLOR_0),
                SPAWN_NORMAL_FRAMES, SPAWN_NORMAL_STEP,
                PHOENIX_ACCEL, PHOENIX_ACCEL_FRAMES, CULL_DELAY)
    end)
    ---⑤ ins_99 ×2：两圈各 23 发的圆环。angle = RANDOM_ANGLE + i·2π/23（每条自己抽一次
    ---   RANDOM_ANGLE，BulletManager.cpp:143-149）→ 我们整体取反。
    local ring1 = ran:Float(-PI, PI)
    local speed1 = owner.lw211_lf5      -- lf5：3 起步、跨轮累加到 4
    local color1 = th08_color(owner.lw211_li7)
    spawn_batch(RING_COUNT, function(i)
        return New(lw211_bullet, bx, by, -(ring1 + (i - 1) * (2 * PI / RING_COUNT)),
                speed1, color1, SPAWN_FAST_FRAMES, SPAWN_FAST_STEP, 0, 0, 0)
    end)
    local ring2 = ran:Float(-PI, PI)
    local color2 = th08_color(0)        -- li5：Sub110 从没写过它 → 0
    spawn_batch(RING_COUNT, function(i)
        return New(lw211_bullet, bx, by, -(ring2 + (i - 1) * (2 * PI / RING_COUNT)),
                RING_SPEED_2, color2, SPAWN_FAST_FRAMES, SPAWN_FAST_STEP, 0, 0, 0)
    end)
end

---位移：插值（缓动 4 = OUT_QUADRATIC）。原作在 RunEcl 之后跑，而且
---`velocity = origin + delta·progress − position`、`position += velocity`
---→ 等价于 position = origin + delta·progress（EnemyManager.cpp:80-118、
---EnemyManagerUpdate.cpp:169-172）。
local function step_move(owner)
    local mv = owner.lw211_move
    if not mv then return end
    mv.t = mv.t + 1
    local u = mv.t / mv.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    owner.x = mv.x0 + mv.dx * e
    owner.y = mv.y0 + mv.dy * e
    if mv.t >= mv.n then
        owner.lw211_move = nil
    end
end

---Sub110 每帧。★ 出弹用的是**上一帧末**的位置（RunEcl 在 UpdateMovement 之前）。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw211_t 还是 nil（卡 205..210 同款守卫）。
    if owner.lw211_t == nil then return end
    if owner.lw211_freeze > 0 then
        ---冻结帧（SET_SECONDARY_TIME）：ECL 不前进，位移照跑。
        owner.lw211_freeze = owner.lw211_freeze - 1
    else
        local t = owner.lw211_t
        if t == WANDER_1 or t == WANDER_2 then
            begin_wander(owner)
        end
        local shift = CALL_SHIFT[t]
        if shift then
            call_111(owner, shift)
        end
        if t == 560 then
            owner.lw211_li7, owner.lw211_li6 = 4, 3
        elseif t == 630 then
            owner.lw211_li7, owner.lw211_li6 = 6, 5
        end
        if t == 230 or t == 380 or t == 700 then
            ---`ins_51(lf5, 4)` 命中时跳过 `ins_15(lf5, 0.2)`
            if owner.lw211_lf5 < 4 then
                owner.lw211_lf5 = owner.lw211_lf5 + 0.2
            end
        end
        if t == 700 then
            ---`ins_2(li7)`：li7 < 2 时跳过 INT_DEC，所以从第二轮起恒为 1
            ---（每轮都被循环体重置成 2 → 第一轮 2 → 减到 1）。
            if owner.lw211_li7 >= 2 then
                owner.lw211_li7 = owner.lw211_li7 - 1
            end
            owner.lw211_freeze = owner.lw211_li7
        end
        if t == CYCLE_LAST then
            ---ins_4(170, −1560)：时间拨回 170，**同帧**重跑循环体（EclRunLow.inl:239-243
            ---把 time.current 设回 170 后 goto low_redispatch_instruction，170 == 目标
            ---指令的 time → 当场执行），帧末 time++ 变 171。循环体重置色号，但不重置 lf5。
            owner.lw211_t = CYCLE_FIRST + 1
            owner.lw211_li7, owner.lw211_li6 = 2, 1
        else
            owner.lw211_t = t + 1
        end
    end
    step_move(owner)
    ---ClampPosition（EnemyManager.cpp:803-819）：生成助手的 `ins_75` 置了 CLAMP_POSITION，
    ---原作每帧在位移**前后**各钳一次（EnemyManagerUpdate.cpp:172-174）；这里位移只在本函数里变。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_init(owner)
    owner.lw211_t = 0
    owner.lw211_freeze = 0
    owner.lw211_lf5 = 3                 -- 循环体第一条（**只跑一次**）：ins_7(lf5, 3)
    owner.lw211_li7 = 2
    owner.lw211_li6 = 1
    ---★ 落位：生成助手 Sub116 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    ---movementAngle = VectorAngle(0, 0) = 0。
    owner.lw211_mangle = 0
    owner.lw211_move = {
        x0 = owner.x, y0 = owner.y,
        dx = 0 - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 t=0 还有一串关射击、关判定、登记符卡、清场的指令（ins_105/110/113/80/134/122/95）
    ---—— boss 系统与 lw_before 管。
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw211_t = nil
    owner.lw211_freeze = nil
    owner.lw211_move = nil
    for i = #phoenixes, 1, -1 do
        if IsValid(phoenixes[i]) then
            object.RawDel(phoenixes[i])
        end
        phoenixes[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[211] = {
    init = function(owner)
        pool = {}
        phoenixes = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 212「远古的欺骗者」（因幡帝）
---  ecldata5sp.ecl：Sub43 = BOSS 根、Sub44 = 一次 CALL（生 4 只使魔）、
---  Sub45 = BOSS 的子 context 0（4 条扫射光柱）、Sub46 = 使魔的枪（原地留弹）、
---  Sub47 = BOSS 的子 context 1（自机狙五连弹环）、Sub48 = 使魔本体。
---
---  · Sub43（根）：
---      t=0    `ins_64(110, 4, 192, 128)` 插值入场到 TH08 (192,128) = 我们 (0,96)。
---      t=110  一次性做完这些事：
---             ① `ins_75(32,112,352,192)`：给 BOSS 上**位置钳制**（我们 x∈[−160,160]、
---                y∈[32,112]）。EnemyManager.cpp:803-819 只在 CLAMP_POSITION 位置位时才钳。
---             ② `ins_7(lf0, AIM_TO_PL)`：把「BOSS → 自机」的角**存下来**。后面 4 次
---                CALL 44 与两条子 context 用的都是这同一个冻结角，不是每帧重取。
---             ③ `ins_6(xi3, 30)`、`ins_6(xi2, 60)`、`ins_7(lf6, 4)`：三个循环计数器。
---             ④ `ins_135(0, 45)`：挂上子 context 0（Sub45 → 4 条光柱）。
---             ⑤ `ins_6(ei0, 0)`。
---             ⑥ `ins_135(1, 47)`：挂上子 context 1（Sub47 → 自机狙五连弹环）。
---             ⑦ `ins_17(lf7, −1)`：lf7 取反成 −π/8。★ 本卡**没人读 lf7**（Sub44 的
---                `ins_38(lf7, lf6, …)` 直接把它当临时量重写），记一笔备查。
---      t=170/200/230/260  各一次 `ins_52(44)`（CALL 44）：四次**写的参数完全相同**
---             （cf0 = 上面存下的 lf0；常数项都是 `lf0 ± π/2`，而 Sub44 根本不读 cf1），
---             所以四个 spawnFamiliar 位置只差 Sub44 里各块重抽的随机半径。
---      t=500  循环尾：`ei0 = 1`、销毁子 context 1、`ins_67(xi2, 4, 1.5)` 随机飘一段，
---             然后 xi3/xi2/lf6 三个计数器的收尾 + `ins_4(110, −600)`。
---             ★ `ins_4` 的操作数 0 是 **110**，而空间落点是 t=170 的第一条
---               （EclRunLow.inl:233-243：只改 time.current 再跳空间）→ 时间先拨回 110，
---               **再过 60 帧**才轮到 t=170 那一块。加上 `ins_2(xi2)` 冻住的 xi2 帧，
---               一轮的实际长度 = (500−170) + 60 + xi2 帧。
---             ★ `ins_46(xi3, 16, …)` 命中时直接跳到 `ins_4`：`ins_2` 的冻结、
---               `xi2 −= 3`、`lf6 += 0.4` 全被跳过 → 第 15 轮起 xi2 恒为 18、lf6 恒为 6。
---             ★ `lf6` 的 4 → 6 递增**没有人读**（子 context 拿到的是挂上那一刻的拷贝，
---               CALL 44 又被 RETURN 整块还原）——照抄下来只为对齐时序。
---
---  · Sub44（CALL 44，生 4 只使魔）：两个结构相同的块，每块**重新抽一次半径**
---    `lf3 = rndUnit × 16 + 64`，块内两只共用同一个 lf3：
---      块 1（`ins_91` 的偏移角 = cf0 + π/2）：
---          A1 `xf = polar(cf0, lf3)`、ω = −3°（TH08）；A2 `xf = polar(cf0+π, lf3)`、ω = +3°。
---      块 2（偏移角 = cf0 − π/2）：
---          A3 `xf = polar(cf0, lf3)`、ω = +3°；A4 `xf = polar(cf0+π, lf3)`、ω = −3°。
---    同块的两只**生成在同一点**（`ins_91` 的偏移只跟 cf0 ± π/2 有关，与 xf 无关），
---    靠 xf（公转圆心偏移）与 ω 分成「往自机飞」和「往反方向飞」两路。
---    ★ CALL **复用同一个 context 对象**（EclDependencies.cpp:474-504 的 CallSubOnEnemy
---      把 subTable[subId] 装回 activeEclContext），RETURN 时整块变量从 call stack
---      拷回来（:530-534）→ Sub44 写的 lf0/lf1/lf3/lf6/lf7/xf0/xf1 不会污染 BOSS 的。
---    ★ `ins_91` = SPAWN_FAMILIAR_AT_OFFSET → SpawnChildAtParentOffset
---      （EclDependencies.cpp:621-649）：新敌机位置 = (op1, op2) + 父 worldPosition；
---      变量块拷 0x78 字节（int/float/extraInt/extraFloat/callParams，EnemyTimeline.cpp:64-114）
---      → 使魔继承那一刻的 xf0/xf1（= 它自己的公转圆心偏移，0x68 的两个 extra float）。
---    ★ `ins_91` 的 life = 2000、itemDrop = −2、score = 100，都被 Sub48 的 t=240
---      TERMINATE 盖过去（实际寿命 240 帧）。
---
---  · Sub48（使魔本体；子 context 的 time 从挂上那一帧的 0 起算）：
---      t=0   `ins_25(lf7, xf0, selfX)` / `ins_25(lf6, xf1, selfY)`：圆心 = 生成点 + xf。
---            `ins_72(60, lf7, lf6, lf0, lf1, lf3, 0)` = ORBIT_AROUND_POINT：时长 60、
---            圆心 (lf7,lf6)、起始轨道角 lf0（= cf0 ± π 归一化）、角速度 lf1、半径 lf3、
---            径向速度 0（EclRunLow.inl:577-597）。
---            `ins_135(0, 46)`：挂上子 context 0（Sub46 → 原地留弹）。
---      t=1   `ins_81(3)` 开判定。
---      t=60/120/180  四条 `ins_15` 把圆心**再加 2×xf**，然后重发 `ins_72`。
---      t=240  同样的四条 `ins_15` + `ins_72` + `ins_1` TERMINATE（那帧不再位移）。
---      ★ ORBIT 的位移（EnemyManager.cpp:36-58）是「orbitAngle += ω → 位置直接落在圆周点」：
---        velocity = 圆心 + polar(angle, r) − 当前位置，再由 IntegrateVelocity 加回去
---        （:936-946）→ 等价于 position = 圆心 + polar(angle, r)，movementAngle = 这一步
---        的位移方向。圆心每 60 帧外移 2×lf3（≈128..160 px）→ 使魔「边公转边一段段往外跳」。
---
---  · Sub46（使魔的枪）：`ins_6(xi2, 200)` + 三条 `ins_111` + 一发 1 颗的 `ins_99`
---    + `ins_46(xi2, 2, …)` + `ins_6(xi2, −2)` + `ins_4(2, −212)`。
---      ★ `ins_4` 的落点是 t=2 的**第一条**（又是 `ins_6(xi2, 200)`）→ 每轮都把计数器
---        重置回 200，`xi2 <= 2` 那个出口**永远走不到**。实际节奏（同帧重跑换来的）：
---        子 context time 2 打一发、之后每 2 帧一发，直到使魔 TERMINATE。
---      ★ 三条 `ins_111` 记录（BulletTransformInstructionArgs，EclRunHigh.inl:78-92）：
---        记录 0 = WAIT(0x20000)，frames = payload.int0 = intPayload0 = xi2 = 200；
---        记录 1 = SET_SPRITE(0x4000)，bulletType/color = intPayload0/intPayload1 = 2/2；
---        记录 2 = ACCELERATE_VECTOR(0x10)，magnitude = floatPayload0 = 0.0666667、
---          angle = floatPayload1 = −999（< −990 → 取弹自己的角）、durationFrames
---          = intPayload0 = 60（BulletManager.cpp:337-356）。
---      ★ WAIT 记录会把后面的记录挡住：AdvanceTransformProgram 在
---        `allowWhileActive == 0 && activeTransformFlags != 0` 时直接 return
---        （BulletManager.cpp:313-324），WAIT 不清零就走不到 SET_SPRITE / 加速。
---        WAIT 的计时也只在 FIRED 分支里减（:848-854），出生动画那几帧不算。
---      ★ `ins_99` 的 flags = 147986 = 0x24212（SPAWN_FAST | 加速 | 音效 | 换贴图 | WAIT，
---        **没有** SET_CULL_DELAY）；count1 = count2 = 1、speed1 = speed2 = 0、
---        angle = MOVE_ANGLE（子弹角度 = **使魔当前移动方向**，即 ORBIT 上一步的位移方向，
---        用的是上一帧末的值）、bulletType 2 / color 1。
---        → 使魔每 2 帧在自己位置上留一颗**不动**的弹（speed = 0），200 帧后沿它出生时的
---        方向以 0.0666667/帧 加速满 60 帧（末速 4）飞出去。
---      ★ SPAWN_FAST：出生瞬间位置退 velocity·4（速度 0 → 不动），之后每帧走 velocity/2。
---
---  · Sub47（BOSS 的子 context 1）：t=60 出第一条 `ins_98` SHOOT_CIRCLE_AIMED
---    （count1 = 15、count2 = 5、speed1 = lf6 = 4、speed2 = lf5 = 0.7×lf6 = 2.8、
---    angleStep = ±0.0392699、flags = 514 = SPAWN_FAST|音效），紧跟一条 `ins_2(xi3 = 30)`：
---    子 context 被冻 30 帧（`secondaryTime > 0` 时每帧 `secondaryTime--` 且 `time--`，
---    EclRun.cpp:59-65 → ECL 停在那条第二条 `ins_98` 上不前进），30 帧后才出第二条
---    （角度步长取反）；第二条后面又是 `ins_2(xi3 = 30)`，再冻 30 帧后 `ins_4(60, −120)`
---    把时间绕回 t=60，回到第一条。
---    → 每 30 帧出**半波**（15×5 = 75 发），两半交替（+`S47_STEP` 与 −`S47_STEP`
---      各隔 60 帧出现一次）：15 个方向（24° 一档）× 5 档速度（4 / 3.76 / 3.52 / 3.28 /
---      3.04，`speed1 − (speed1−speed2)·index2/count2`），±2.25°×index2。
---      半波的 angleToPlayer 只算一次（BulletManager.cpp:697），两条 `ins_98` 各算各的。
---    ★ lf6/lf5/xi3 都是**这份拷贝**里的值（t=110 挂上那刻从 BOSS 拷的），所以整张卡的
---      自机狙速度恒为 4，不会跟着 BOSS 后面 lf6 的 4 → 6 变。
---
---  · Sub45（BOSS 的子 context 0，t=0 就是挂上那一帧）：
---    生成 4 条光柱 —— 两条在「BOSS + polar(cf0+π/2, 64)」、角度 cf0+π/2，
---    两条在 cf0−π/2 那一边（`ins_110` 设 shootOffset、`ins_116` 选槽、`ins_114` 建）。
---    t=60 起 20 帧，每帧 `ins_117` ×4 转 ±4.5°（slot0 −、slot1 +、slot2 +、slot3 −，
---    TH08 口径）→ 合计 ±90°：两条扫到自机方向、两条扫到反方向。
---    之后 `ins_6(ei0, 0)` + `ins_42(ei0, 1, …)`/`ins_4(61, −48)` 组成的**等待循环**
---    一直转到 `ei0`（= ENEMY_INT_0。★ 它是 **enemy 级**变量，主 context 与所有子
---    context 共用，EclOperandsInt.cpp:38 走 `enemy->eclIntVariables[]`）被 BOSS 在
---    t=500 置 1，然后 `ins_121` ×4 CANCEL_LASER。
---    ★ 光柱参数（ins_114 裸字节，LaserSpawnArgs 见 EclRunHigh.inl:53-76）：
---      bulletType 0 / color 2 / angle = lf2 或 lf1 / speed 0 / startOffset 0 /
---      endOffset 512 / startLength 512 / width 32 / startTime 60 / duration **6000** /
---      despawnDuration 60 / hitboxStartTime 60 / hitboxEndDelay 60 / flags 4。
---      判定盒 = 「从生成点沿 angle 长 512、半宽 width/4 = 8」——Player::CalcLaserHitbox
---      拿 `position ± size/2`，size[0] = endOffset − startOffset、size[1] = width/2
---      （Player.cpp:396-424）。★ 给 THlib 的 laser 类填 w = width/2 = 16
---      （laser:frame 的判定是 `dy < self.w / 2`）→ 有效半宽 8，两边一致。
---    ★ 光柱寿命：STARTING 60 帧 → ACTIVE **duration = 6000 帧**（BulletManager.cpp:1122-1127），
---      所以这 4 条会**一直挂到 BOSS 在 t=500 把它们 CANCEL 掉**（`ins_121` ×4，`:454-464`）——
---      转完 ±90° 之后停在「两条指向自机方向、两条指向反方向」的姿态上，是整轮
---      （t=110..500）的常驻障碍。★ 子 context 那个等 `ei0` 的循环才是让它们退场的正主
---      （duration 不写 6000 的话，它们会在 t=290 自己消失，那条等待循环就变成空转了）。
---    ★ STARTING 段没有多余的判定帧：原作在 `timer >= hitboxStartTime` 那一刻才开判定
---      （BulletManager.cpp:1101-1103），而 hitboxStartTime == startTime == 60，正好是转
---      ACTIVE 的那一帧 → `colli = (timer >= 60)` 与原作等价。
---    ★ DESPAWNING 段的近似：原作那 60 帧把判定盒的**长度**改写成 `currentWidth/2`
---      （半宽仍是 width/4 = 8），盒心还钉在 `position + 256`（laserCenter 在 switch
---      之前就用 endOffset−startOffset = 512 算好了，BulletManager.cpp:1069）——
---      也就是「光柱中点上一个小方块」。THlib 的 laser 类表达不出「中点上的小盒子」，
---      所以照卡 209 的口径在消散段关掉判定（照抄整条 512 px 的判定会比原作狠得多）。
---
---  · 同屏上限：弹 1536 槽、光柱 256 槽（BulletManager.hpp:455、:313-339）。波满不生、
---    波中途生不出来就丢掉剩下的（BulletManager.cpp:685-712、:712-760）。
---
---  · 占位贴图：弹 = ball_small（TH08 色号 1 / 6 → 我们的 2 / 7）、使魔 = "servant"、
---    光柱 = THlib 的 laser 类。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x−192、y' = 224−y、角度取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
local function th08_color(c) return c + 1 end

---Sub43（根）的节拍。
local BOSS_END_Y = 96                       -- ins_64(110, 4, 192, 128)：TH08 y=128 → 我们 96
local BOSS_MOVE_FRAMES = 110
local SETUP_T = 110                         -- 一大串一次性设置都在这一帧
local CYCLE_LAST = 500                      -- `ins_4(110, −600)` 在这一帧
local RESTART_T = 111                       -- 时间拨回 110、帧末再 +1 → 下一帧从 111 起算
local CALL_T = { [170] = true, [200] = true, [230] = true, [260] = true }
local XI3_INIT, XI2_INIT, LF6_INIT = 30, 60, 4
local XI3_STOP = 16                         -- `ins_46(xi3, 16, …)`
local XI2_MIN, XI2_STEP = 30, 3             -- `ins_44(xi2, 30, …)` / `ins_11(xi2, 3)`
local LF6_MAX, LF6_STEP = 6, 0.4            -- `ins_51(lf6, 6, …)` / `ins_15(lf6, 0.4)`
local WANDER_SPEED = 1.5                    -- ins_67 的参数 2
local WANDER_EASING = 4                     -- ins_67 的参数 1（OUT_QUADRATIC）
---ins_75(32, 112, 352, 192) 的钳制范围 → 我们坐标（y 是 224 − y）。
local BOUND_L, BOUND_R, BOUND_B, BOUND_T = -160, 160, 32, 112

---Sub45（4 条扫射光柱）。
local S45_SPIN_FIRST = 60                   -- 子 context 自己的 time 60 开始转
local S45_SPIN_FRAMES = 20                  -- `ins_6(xi0, 20)` 的 JUMP_DEC 循环
local S45_SPIN_STEP = 0.0785398             -- `ins_117` 的字面量（4.5°）
local S45_SPIN_DIR = { 1, -1, -1, 1 }        -- TH08 的 ∓ 取反后 = 我们坐标里的符号
local LASER_LEN = 512                       -- endOffset − startOffset
local LASER_W = 16                          -- TH08 的 width 32 → THlib 的 w = width/2
local LASER_W0 = 1.2                        -- STARTING 段的细线宽度（BulletManager.cpp:1081）
local LASER_START_TIME = 60                 -- ins_114 的 startTime
local LASER_RAMP = 30
local LASER_DURATION = 6000                 -- ... 的 duration（≈100 秒，实际由 CANCEL 收掉）
local LASER_DESPAWN = 60                    -- ... 的 despawnDuration
local LASER_HITBOX_START = 60               -- ... 的 hitboxStartTime（== startTime，不产生多余的判定帧）
local LASER_HITBOX_DELAY = 60               -- ... 的 hitboxEndDelay（消散段那个中点小方块，见头注）
local LASER_SLOTS = 256                     -- `Laser lasers[0x100]`（BulletManager.hpp:313-339）
local COLOR_LASER = 3                       -- TH08 色号 2 → 我们的 3（占位，选 laser 贴图用）

---Sub47（自机狙五连弹环）。
local S47_FIRST, S47_PERIOD = 60, 30        -- 子 context time 60 起、每 30 帧一波
local S47_COUNT1, S47_COUNT2 = 15, 5
local S47_STEP = 0.0392699                  -- `ins_98` 的字面量（2.25°）
local S47_SPEED = 4.0                       -- 这份拷贝里的 lf6
local S47_SPEED2 = 2.8                      -- lf5 = 0.7 × lf6

---Sub44 / Sub48（使魔）。
local FAM_OFFSET_R = 64                     -- `ins_38(lf7, lf6, lf0, 64)`
local FAM_SPIN = 0.0523599                  -- ±3°（lf1）
local FAM_RADIUS_ADD = 16                   -- `ins_27(lf3, RANDOM_UNIT_FLOAT)` × 16
local FAM_RADIUS_BASE = 64                  -- `ins_15(lf3, 64)`
local ORBIT_FRAMES = 60                     -- `ins_72` 的时长（也是重发间隔）
local ORBIT_RESEND = { [60] = true, [120] = true, [180] = true }
local FAM_LIFE = 240                        -- Sub48 t=240 的 `ins_1`

---Sub46（使魔的枪）。
local PELLET_FIRST = 2                      -- 子 context time 2 的第一发
local PELLET_PERIOD = 2                     -- 之后每 2 帧一发（`ins_4(2, −212)` 同帧绕回）
local PELLET_WAIT = 200                     -- 记录 0（WAIT）的 frames = intPayload0 = xi2
local PELLET_ACCEL = 0.0666667              -- 记录 2 的 magnitude
local PELLET_ACCEL_FRAMES = 60              -- 记录 2 的 durationFrames
local SPAWN_FAST_FRAMES = 10                -- etama.anm script21 的长度
local SPAWN_FAST_STEP = 0.5                 -- 出生期每帧走 velocity/2
local COLOR_PELLET = 2                      -- Sub46 打包字的 color 1 → 我们 2
local COLOR_AIMED = 7                       -- Sub47 打包字的 color 6 → 我们 7

local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local SPRITE_HALF = 8                       -- 占位 ball_small 是 16×16
local POOL_SIZE = 1536                      -- `Bullet bullets[0x601]`（BulletManager.hpp:455）

---本卡自己的弹池（= 原作 1536 个弹槽）、光柱槽（= 256）、使魔登记表。
local pool = {}
local lasers = {}
local familiars = {}

---弹 / 光柱 / 使魔的类（先声明：下面的 spawn 助手要引用它们）。
local lw212_bullet
local lw212_aim_bullet
local lw212_laser
local lw212_familiar

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:810-816），
---移植版按「对象还活着」清表。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local function laser_used()
    for i = #lasers, 1, -1 do
        if not IsValid(lasers[i]) then
            table.remove(lasers, i)
        end
    end
    return #lasers
end

---一次 SpawnBulletPattern（BulletManager.cpp:685-712）：池满 → **整波不生**。
---本卡只有 Sub46 的「1 发」用得上它（Sub47 的 15×5 两重循环写在 volley_s47 里）。
local function spawn_one(factory)
    if pool_used() >= POOL_SIZE then
        return
    end
    pool[#pool + 1] = factory()
end

---自机狙弹（Sub47）。SPAWN_FAST + 直线，没有任何 transform 记录（BOSS 的
---bulletSpawnDescriptor.transforms 全是 0 → AdvanceTransformProgram 第 2 行就返回）。
lw212_aim_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed)
        bullet.init(self, ball_small, COLOR_AIMED, false, true)
        self.bound = false                  -- 出屏回收自己判（卡 206/209/210/211 同款）
        self.lw212_bvx = math.cos(angle) * speed
        self.lw212_bvy = math.sin(angle) * speed
        ---SPAWN_FAST：出生瞬间位置先退 velocity·4，之后每帧只走 velocity/2
        ---（BulletManager.cpp:220-227、:936-945）。
        self.x = x - self.lw212_bvx * 4
        self.y = y - self.lw212_bvy * 4
        self.vx, self.vy = self.lw212_bvx / 2, self.lw212_bvy / 2
        self.lw212_spawn = SPAWN_FAST_FRAMES
        self.colli = false                  -- 出生动画期间没有判定
    end,
    frame = function(self)
        if self.lw212_spawn > 0 then
            self.lw212_spawn = self.lw212_spawn - 1
            if self.lw212_spawn == 0 then
                self.vx, self.vy = self.lw212_bvx, self.lw212_bvy
                self.colli = true
            end
        end
        if self.lw212_spawn == 0 and outside_field(self.x, self.y) then
            object.RawDel(self)
            return
        end
        bullet.frame(self)
    end,
})

---使魔留在原地的弹（Sub46）：speed = 0，200 帧 WAIT 之后沿出生时的角度加速 60 帧。
lw212_bullet = Class(bullet, {
    init = function(self, x, y, angle)
        bullet.init(self, ball_small, COLOR_PELLET, false, true)
        self.bound = false
        self.x, self.y = x, y
        self.vx, self.vy = 0, 0             -- speed1 = speed2 = 0
        self.lw212_angle = angle            -- 出生那一刻的使魔移动方向（= MOVE_ANGLE）
        self.lw212_spawn = SPAWN_FAST_FRAMES
        self.colli = false
        ---出生当帧 SpawnSingleBullet 末尾就调一次 AdvanceTransformProgram
        ---（BulletManager.cpp:233）→ WAIT 记录立刻激活、计时 = 200。
        self.lw212_wait = PELLET_WAIT
        self.lw212_accel = false
        self.lw212_accel_t = 0
    end,
    frame = function(self)
        ---① 出生动画（速度 0 → 位置不动）；跑完那一帧不 return，继续走完整流程。
        if self.lw212_spawn > 0 then
            self.lw212_spawn = self.lw212_spawn - 1
            if self.lw212_spawn > 0 then
                bullet.frame(self)
                return
            end
            self.colli = true
        end
        ---② WAIT 走完才轮到 ACCELERATE_VECTOR：记录 0 挡着记录 1/2（:313-324），
        ---   而清位发生在每帧**后半**（:848-854）→ 加速比 WAIT 归零晚一帧开始。
        if self.lw212_wait > 0 then
            self.lw212_wait = self.lw212_wait - 1
        elseif not self.lw212_accel then
            self.lw212_accel = true
            ---accelerationAngle = angle > −990 ? angle : 弹自己的角（:337-352），
            ---本卡记录里写的是 −999 → 取弹自己出生时的角度。
        elseif self.lw212_accel_t < PELLET_ACCEL_FRAMES then
            self.vx = self.vx + math.cos(self.lw212_angle) * PELLET_ACCEL
            self.vy = self.vy + math.sin(self.lw212_angle) * PELLET_ACCEL
            self.lw212_accel_t = self.lw212_accel_t + 1
        end
        ---③ 出屏回收：本卡没有 SET_CULL_DELAY → 一出屏就回收（:856-899）。
        if outside_field(self.x, self.y) then
            object.RawDel(self)
            return
        end
        bullet.frame(self)
    end,
})

---光柱（Sub45 的 ins_114）。状态机照抄 BulletManager.cpp:1049-1150；
---`alpha = 1` 是 THlib laser:frame 开判定的条件。
lw212_laser = Class(laser, {
    init = function(self, x, y, angle)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）
        ---l1/l2/l3 = 尾/身/头三段长度；这里只要一段 512 的身部。
        laser.init(self, COLOR_LASER, x, y, angle, 0, LASER_LEN, 0, LASER_W0, 0, 0)
        self.lw212_state = 1
        self.lw212_timer = 0
        self.alpha = 1
        self.colli = false                  -- STARTING 段要 hitboxStartTime 之后才开判定
        ---★ 光柱不会因为起点出界被回收：原作那 256 条存在固定槽位里，槽位要到状态机
        ---  跑完才释放（BulletManager.cpp:1049-1150）。不关 bound 的话引擎会提前收走。
        self.bound = false
    end,
    frame = function(self)
        local t = self.lw212_timer
        if self.lw212_state == 1 then
            local ramp = LASER_START_TIME > LASER_RAMP and LASER_RAMP or LASER_START_TIME
            if LASER_START_TIME - ramp < t then
                self.w = t * LASER_W / LASER_START_TIME
            else
                self.w = LASER_W0
            end
            self.colli = t >= LASER_HITBOX_START
            if t >= LASER_START_TIME then
                ---原作这里不 break，直接落到 ACTIVE 那一支
                self.lw212_state = 2
                self.lw212_timer = 0
                t = 0
            end
        end
        if self.lw212_state == 2 then
            self.w = LASER_W
            self.colli = true
            if t >= LASER_DURATION then
                self.lw212_state = 3
                self.lw212_timer = 0
                t = 0
            end
        end
        if self.lw212_state == 3 then
            ---★ 消散段关判定：原作那 60 帧的盒子只剩「中点 ±8 px」（见头部注释），
            ---  照抄成整条 512 px 的光柱反而比原作狠得多（卡 209 同款处理）。
            ---  原作的 hitboxEndDelay 是 60，也就是整个消散段都在判 —— 但它判的是那个
            ---  中点小方块，不是整条光柱，所以这里只能整个关掉。
            self.colli = false
            self.w = LASER_W - t * LASER_W / LASER_DESPAWN
            if t >= LASER_DESPAWN then
                object.RawDel(self)
                return
            end
        end
        self.lw212_timer = t + 1
        laser.frame(self)
    end,
})

---使魔（Sub48）。占位贴图 "servant"；原作它有 24×24 判定与 life，
---但 `ins_80(16)` 关掉了与自机的判定（移植版照抄：不给判定）。
---  ox/oy   = 圆心相对生成点的偏移（我们坐标，= 继承来的 xf0/xf1 换过来）
---  angle0  = 起始轨道角（我们坐标）
---  omega   = 轨道角速度（我们坐标，正 = 逆时针）
---  radius  = 轨道半径（lf3）
lw212_familiar = Class(object, {
    init = function(self, x, y, ox, oy, angle0, omega, radius)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.5, 0.5
        self.colli = false
        self.navi = false
        self.bound = false                  -- 圆心会漂到场地外，不能自动回收
        self.rot = 0
        self._blend, self._a = "", 255
        self.lw212_t = 0
        self.lw212_ox, self.lw212_oy = ox, oy
        self.lw212_cx, self.lw212_cy = x + ox, y + oy
        self.lw212_angle = angle0
        self.lw212_omega = omega
        self.lw212_radius = radius
        self.lw212_orbit = 0                -- ORBIT 的 movementTimer
        self.lw212_mangle = 0               -- movementAngle（我们坐标）
        self.lw212_rot = angle0
    end,
    frame = function(self)
        local t = self.lw212_t
        ---t=240：`ins_1` TERMINATE → RunEcl 返回 −1 → 敌机 Despawn，那一帧不再位移
        ---（EnemyManagerUpdate.cpp:161-165）。
        if t >= FAM_LIFE then
            object.RawDel(self)
            return
        end
        ---① 主 context Sub48：t=0 与 t=60/120/180 重发 `ins_72`（每次重置 60 帧计时）。
        if t == 0 then
            self.lw212_orbit = ORBIT_FRAMES
        elseif ORBIT_RESEND[t] then
            ---四条 `ins_15`：圆心 += 2×xf（我们坐标里就是 2×(ox, oy)）
            self.lw212_cx = self.lw212_cx + 2 * self.lw212_ox
            self.lw212_cy = self.lw212_cy + 2 * self.lw212_oy
            self.lw212_orbit = ORBIT_FRAMES
        end
        ---② 子 context Sub46（主 context 先跑、子 context 后跑）：每 2 帧一发。
        ---   出弹位置用的是**上一帧末**的位置（RunEcl 在 UpdateMovement 之前）。
        if t >= PELLET_FIRST and t % PELLET_PERIOD == 0 then
            local mx, my, ma = self.x, self.y, self.lw212_mangle
            spawn_one(function()
                return New(lw212_bullet, mx, my, ma)
            end)
        end
        ---③ ORBIT 位移（EnemyManager.cpp:36-58）：ω 先加到角度，位置直接落在圆周点上。
        if self.lw212_orbit > 0 then
            self.lw212_orbit = self.lw212_orbit - 1
            self.lw212_angle = self.lw212_angle + self.lw212_omega
            local nx = self.lw212_cx + math.cos(self.lw212_angle) * self.lw212_radius
            local ny = self.lw212_cy + math.sin(self.lw212_angle) * self.lw212_radius
            local dx, dy = nx - self.x, ny - self.y
            if math.abs(dx) > 0.0001 or math.abs(dy) > 0.0001 then
                self.lw212_mangle = math.atan2(dy, dx)
            end
            self.x, self.y = nx, ny
            self.lw212_rot = self.lw212_mangle
        end
        self.rot = -self.lw212_rot * RAD      -- 观感近似：朝自己飞的方向
        self.lw212_t = t + 1
    end,
})

---生一只使魔（`ins_91` 的移植）。圆心偏移在传进来时就已经换成我们坐标的向量。
local function spawn_familiar(x, y, ox, oy, angle0, omega, radius)
    local fam = New(lw212_familiar, x, y, ox, oy, angle0, omega, radius)
    familiars[#familiars + 1] = fam
end

---一次 CALL 44 的 4 只使魔（顺序 = 原作 4 条 `ins_91` 的先后）：
---{ 块号, 圆心偏移相对 cf0（TH08 口径）的倍数, ω 符号（我们坐标）}。
---两个块各**重新抽一次**半径；块内两只共用同一个半径。
local CALL44 = {
    { 1, 0,   1 },      -- A1：xf = polar(cf0, lf3)、lf1 = −3°（TH08）→ 我们 +3°
    { 1, PI, -1 },      -- A2：xf = polar(cf0+π, lf3)、lf1 = +3°（TH08）→ 我们 −3°
    { 2, 0,  -1 },      -- A3：xf = polar(cf0, lf3)、lf1 = +3°（TH08）→ 我们 −3°
    { 2, PI,  1 },      -- A4：xf = polar(cf0+π, lf3)、lf1 = −3°（TH08）→ 我们 +3°
}

---一次 CALL 44。dir = cf0（「BOSS → 自机」的角，冻结在 t=110 那一刻）换到我们坐标的值。
local function call_44(owner, dir)
    local bx, by = owner.x, owner.y
    for blk = 1, 2 do
        ---`ins_27(lf3, RANDOM_UNIT_FLOAT)` + `ins_15(lf3, 64)`：每个块抽一次（∈ [64,80)）
        local r = ran:Float(0, 1) * FAM_RADIUS_ADD + FAM_RADIUS_BASE
        ---`ins_91` 的偏移角：块 1 = cf0 + π/2、块 2 = cf0 − π/2（我们坐标取反）
        local off = (blk == 1) and (dir - PI / 2) or (dir + PI / 2)
        local sx = bx + math.cos(off) * FAM_OFFSET_R
        local sy = by + math.sin(off) * FAM_OFFSET_R
        for k = 1, 2 do
            local spec = CALL44[(blk - 1) * 2 + k]
            local ca = dir + spec[2]        -- xf 的方向（我们坐标）
            spawn_familiar(sx, sy, math.cos(ca) * r, math.sin(ca) * r,
                    dir + PI, spec[3] * FAM_SPIN, r)
        end
    end
end

---Sub45 的 t=0：4 条光柱。两条在 cf0+π/2 那边（slot 0/1）、两条在 cf0−π/2 那边（slot 2/3）。
local function spawn_lasers(owner)
    local d = owner.lw212_dir
    local ls = {}
    for i = 1, 4 do
        local a = (i <= 2) and (d - PI / 2) or (d + PI / 2)
        local lx = owner.x + math.cos(a) * FAM_OFFSET_R
        local ly = owner.y + math.sin(a) * FAM_OFFSET_R
        ---SpawnLaserPattern 是「从头找第一个空槽」，槽满就整发不生成（BulletManager.cpp:712-760）
        if laser_used() < LASER_SLOTS then
            local l = New(lw212_laser, lx, ly, a)
            lasers[#lasers + 1] = l
            ls[#ls + 1] = l
        end
    end
    owner.lw212_s45 = { k = 0, lasers = ls }
end

---Sub45 每帧（frame = 挂上那一帧起算的帧序号）。BOSS 冻结时子 context 照跑。
local function s45_step(owner)
    local s = owner.lw212_s45
    if not s then return end
    local k = s.k
    if k >= S45_SPIN_FIRST and k < S45_SPIN_FIRST + S45_SPIN_FRAMES then
        ---`ins_117` ×4：每帧把 4 条各转 ±4.5°（TH08 口径；我们坐标取反）
        for i = 1, 4 do
            local l = s.lasers[i]
            if IsValid(l) then
                l.rot = l.rot + S45_SPIN_DIR[i] * S45_SPIN_STEP
            end
        end
    elseif k >= S45_SPIN_FIRST + S45_SPIN_FRAMES then
        ---等待循环：`ei0`（enemy 级变量）被 BOSS 在 t=500 置 1 才出来 → `ins_121` ×4。
        ---★ 4 条光柱在第 180 帧就自然过期了，这里通常是空操作（照抄原作的收尾）。
        if owner.lw212_ei0 == 1 then
            ---`ins_121` = CANCEL_LASER（EclRunHigh.inl:454-464）：state = DESPAWNING、
            ---timer = 0、width = currentWidth（`l.w` 本身就是 currentWidth，无需赋值）。
            for i = 1, 4 do
                local l = s.lasers[i]
                if IsValid(l) then
                    l.lw212_state = 3
                    l.lw212_timer = 0
                    l.colli = false
                end
            end
            s.lasers = {}
            owner.lw212_s45 = nil
            return
        end
    end
    s.k = k + 1
end

---一次 SpawnBulletPattern 的半波（BulletManager.cpp:685-712 的两重循环 + `goto doneSpawning`）：
---池满 → **整波不生**；波中途某一颗生不出来 → 放弃这一波剩下的所有 i 和 j。
---sign = +1 是第一条 `ins_98`（TH08 的 angleStep = +0.0392699），−1 是第二条。
local function volley_s47(owner, sign)
    local used = pool_used()
    if used >= POOL_SIZE then
        return
    end
    local bx, by = owner.x, owner.y
    ---整波的 angleToPlayer 只算一次（BulletManager.cpp:697）
    local aim = math.atan2(player.y - by, player.x - bx)
    ---j（速度档）在外、i（方向）在内（:698-705）
    for j = 0, S47_COUNT2 - 1 do
        local speed = S47_SPEED - (S47_SPEED - S47_SPEED2) * j / S47_COUNT2
        for i = 0, S47_COUNT1 - 1 do
            if used >= POOL_SIZE then
                return
            end
            ---TH08：angle = angleToPlayer + i·2π/count1 + j·angleStep（:134-137）；
            ---我们坐标整体取反。
            local a = aim - i * 2 * PI / S47_COUNT1 - sign * j * S47_STEP
            pool[#pool + 1] = New(lw212_aim_bullet, bx, by, a, speed)
            used = used + 1
        end
    end
end

---Sub47 每帧。见头部注释：`ins_2` 把子 context 冻 30 帧，所以两条 `ins_98` 是
---**交替**出弹（各隔 30 帧），不是同一帧出双份。
local function s47_step(owner)
    local s = owner.lw212_s47
    if not s then return end
    if s.k >= S47_FIRST and (s.k - S47_FIRST) % S47_PERIOD == 0 then
        local half = (s.k - S47_FIRST) / S47_PERIOD
        volley_s47(owner, (half % 2 == 0) and 1 or -1)
    end
    s.k = s.k + 1
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）。
---返回值是 TH08 口径的角。本卡有 `ins_75(32,112,352,192)`，所以四条判据用的是
---lower+96 = 128 / upper−96 = 256 / lower+48 = 160 / upper−48 = 144。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        ---★ 这一支过了 AddNormalizeAngle(..., 0)（Global.cpp:1239-1257 归到 [−π, π]）：
        ---  rnd(π/2) + 3π/4 ∈ [3π/4, 5π/4]，超过 π 的那一半会折成负数，而下面的
        ---  `angle > π/2` / `angle < 0` 这些判据是按**归一化后**的值比的 —— 不归一
        ---  就会走错支（卡 206 同款处理）。
        angle = ran:Float(0, PI / 2) + 2.3561945
        if angle > PI then angle = angle - 2 * PI end
    else
        angle = ran:Float(0, PI / 2) - 0.78539819
    end
    if bx < 128 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > 256 then
        ---★ 这条改写用的是**上一段的移动方向**（enemy->movementAngle），不是刚抽到的 angle
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.lw212_mangle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < 160 and angle < 0 then
        angle = -angle
    end
    if by > 144 and angle > 0 then
        angle = -angle
    end
    return angle
end

---开始一次随机飘（`ins_67(xi2, 4, 1.5)`）：delta = polar(角, 1.5 × 时长)、
---时长 = xi2、缓动 4 = OUT_QUADRATIC、origin = 当前 worldPosition
---（StartTimedPolarDisplacement，EclDependencies.cpp:104-126）。
local function begin_wander(owner, frames)
    local angle = wander_angle(owner)
    owner.lw212_mangle = angle            -- 下一段 ins_67 的怪癖要用它（TH08 口径）
    owner.lw212_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * frames,
        dy = math.sin(-angle) * WANDER_SPEED * frames,
        n = frames, t = 0, easing = WANDER_EASING,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = u
    if move.easing == 4 then
        e = 1 - (1 - u) * (1 - u)
    end
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---BOSS 每帧。原作顺序：RunEcl（主 context → 子 context）→ ClampPosition →
---IntegrateVelocity → ClampPosition → worldPosition（EnemyManagerUpdate.cpp:159-192）。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw212_t 还是 nil（卡 205..211 同款守卫）。
    if owner.lw212_t == nil then return end
    if owner.lw212_freeze > 0 then
        ---冻结帧（`ins_2`）：ECL 不前进（原作 time-- 与帧末 time++ 相抵），位移照跑。
        owner.lw212_freeze = owner.lw212_freeze - 1
    else
        local t = owner.lw212_t
        if t == SETUP_T then
            ---t=110：`ins_18(lf0, AIM_TO_PL)` 把「BOSS → 自机」的角存下来
            ---（BOSS 这时已经停在 (0,96)，入场插值在 t=109 收尾）。
            owner.lw212_dir = math.atan2(player.y - owner.y, player.x - owner.x)
            owner.lw212_xi3 = XI3_INIT
            owner.lw212_xi2 = XI2_INIT
            owner.lw212_lf6 = LF6_INIT
            owner.lw212_ei0 = 0
            spawn_lasers(owner)                     -- ins_135(0, 45)
            owner.lw212_s47 = { k = 0 }             -- ins_135(1, 47)
        elseif CALL_T[t] then
            call_44(owner, owner.lw212_dir)
        elseif t == CYCLE_LAST then
            owner.lw212_ei0 = 1
            owner.lw212_s47 = nil                   -- ins_135(1, −1)
            begin_wander(owner, owner.lw212_xi2)    -- ins_67(xi2, 4, 1.5)
            ---`ins_46(xi3, 16, …)` 命中就直接跳到 `ins_4`，下面整段（含 `ins_2`）全跳过
            if owner.lw212_xi3 > XI3_STOP then
                owner.lw212_xi3 = owner.lw212_xi3 - 1
                owner.lw212_freeze = owner.lw212_xi2       -- ins_2(xi2)：下一帧起冻结
                if owner.lw212_xi2 >= XI2_MIN then
                    owner.lw212_xi2 = owner.lw212_xi2 - XI2_STEP
                    if owner.lw212_lf6 < LF6_MAX then
                        owner.lw212_lf6 = owner.lw212_lf6 + LF6_STEP
                    end
                end
            end
            ---`ins_4(110, −600)`：时间拨回 110，落点是 t=170 的第一条 → 再过 60 帧
            ---才轮到下一轮（帧末的 time++ 已经在 RESTART_T 里算进去了）。
            owner.lw212_t = RESTART_T
        end
        if owner.lw212_t == t then
            owner.lw212_t = t + 1
        end
    end
    ---子 context（主线跑完再跑子线，而且不理会主线的冻结）
    s45_step(owner)
    s47_step(owner)
    ---位移（RunEcl 之后）
    local mv = owner.lw212_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw212_move = nil
        end
    end
    ---ClampPosition（EnemyManager.cpp:803-819；ins_75 置了 CLAMP_POSITION）
    if owner.x < BOUND_L then owner.x = BOUND_L elseif owner.x > BOUND_R then owner.x = BOUND_R end
    if owner.y < BOUND_B then owner.y = BOUND_B elseif owner.y > BOUND_T then owner.y = BOUND_T end
end

local function card_init(owner)
    owner.lw212_t = 0
    owner.lw212_freeze = 0
    owner.lw212_xi3 = XI3_INIT
    owner.lw212_xi2 = XI2_INIT
    owner.lw212_lf6 = LF6_INIT
    owner.lw212_ei0 = 0
    owner.lw212_dir = 0
    owner.lw212_s45 = nil
    owner.lw212_s47 = nil
    ---★ 落位：生成助手 Sub52 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    ---movementAngle = VectorAngle(0, 0) = 0。
    owner.lw212_mangle = 0
    owner.lw212_move = {
        x0 = owner.x, y0 = owner.y,
        dx = 0 - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0, easing = WANDER_EASING,
    }
    ---原作 t=0 还有一串关射击、关判定、登记符卡、清场的指令（ins_105/110/113/80/134/122/95）
    ---—— boss 系统与 lw_before 管。
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw212_t = nil
    owner.lw212_freeze = nil
    owner.lw212_move = nil
    owner.lw212_s45 = nil
    owner.lw212_s47 = nil
    for i = #familiars, 1, -1 do
        if IsValid(familiars[i]) then
            object.RawDel(familiars[i])
        end
        familiars[i] = nil
    end
    for i = #lasers, 1, -1 do
        if IsValid(lasers[i]) then
            object.RawDel(lasers[i])
        end
        lasers[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[212] = {
    init = function(owner)
        pool = {}
        lasers = {}
        familiars = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 213「无何有净化」（上白泽慧音）
---  ecldata8sp.ecl：Sub113 = BOSS 根、Sub114 = 小怪本体、Sub115 = 小怪的子 context 0。
---
---  · Sub113（根）：
---      t=0    `ins_64(110, 4, 192, 128)` 插值入场到 TH08 (192,128) = 我们 (0,96)。
---             其余（ins_105 关射击、ins_95 清场、ins_113 弹音效、ins_134/122 符卡登记、
---             ins_80(4) 关可伤害）都由 boss 系统与 lw_before 管，不另写。
---      t=110  `ins_81(4)` 开可伤害、`ins_160(60)` 减伤计时（移植版不打伤害，跳过）；
---             然后**一次性生成 8 只小怪**（`ins_94` = SPAWN_ENEMY_RELATIVE）：
---               4 组 × 2 只；每组进组时重抽一次起始角（`ins_7(lf0, RANDOM_ANGLE)`，
---               TH08 的 RANDOM_ANGLE = rnd[0,2π) − π，EclOperandsFloat.cpp:56）：
---                 组长（先出）：li0 = 6（= 弹色）+ lf1 = +0.0261799（+1.5°/帧）
---                 组员（后出）：li0 = 4 + lf1 = −0.022439947（−1.2857°/帧）
---             组与组之间的 `ins_15(lf0, π/2)` / `ins_37` 是死代码（下一组立刻重抽）。
---             ★ `ins_94` 的偏移是 (0,0) + 父的 **position** → 8 只全部生成在 BOSS 的
---               当前位置（我们 (0,96)），而且共用同一个公转圆心（小怪 t=0 的
---               `ins_7(xF0, ENEMY_POSITION_X)` 把圆心记成自己的出生点）。
---             ★ 变量继承：SpawnEnemy2 把父 context 从 intVariables 起 **0x78 字节**
---               整块拷给子 context（EnemyTimeline.cpp:64-114；0x78 =
---               8 li + 8 lf + 4 xInt + 2 xFloat + 4 callInt + 4 callFloat，
---               布局见 EclManager.hpp:600-626）→ 小怪拿到的是**生成那一刻**的
---               lf0/lf1/li0。
---      t=510  `ins_67(60, 4, 1.0)`：随机飘 60 帧（BeginBoundaryAwareMove，
---             EclDependencies.cpp:128-191）。本卡**没有** ins_75/ins_78 设过
---             movementBounds → 四条边界判据都是拿 (0,0,0,0) 比，跟卡 218 同款怪癖。
---      t=570  `ins_7(lf0, ANGLE_TO_PLAYER)` 冻住「BOSS→自机」角 + `ins_97` 扇形 1 发。
---      t=590/610/630  同样的扇形，count1 = 2/3/4（角度仍用 t=570 冻的那个）。
---      t=690  `ins_4(510, −236)`：时间拨回 510、落点是 t=510 的 `ins_67`
---             → **同一帧**就开始下一轮的随机飘 → 一轮 = 180 帧（510..689）。
---      ★ BOSS 扇形弹（ins_97 的 ShotArgs：bulletType/color i16 ×2 + count1/count2 i32
---        + speed1/speed2/angle/angleStep f32 + transformFlags u32，
---        EclDependencies.cpp:673-693）：
---        bulletType 10 / color 1 / count1 = 1..4 / count2 1 / speed1 4.0 / speed2 0.8 /
---        angle = lf0 / angleStep 0.1308997（7.5°）/ flags 514 = SPAWN_FAST|PLAY_SPAWN_SOUND。
---        op97 = SHOOT_FAN → aimMode 1（**不加** angleToPlayer，BulletManager.cpp:118-129）：
---        count1 奇数 → 偏移 0,±step,±2step…；偶数 → ±step/2,±3step/2…
---      ★ bulletType 10 的出生脚本 = etama.decl script27（`+24: ins_1`）→ 24 帧。
---
---  · Sub114（小怪本体；time 从生成那一帧的 0 起算）。整条子程序只有 22 条指令，
---    而且**时间戳只有 0 和 2**，靠 `ins_5`(JUMP_DEC)/`ins_4`(JUMP) 在两个时间戳之间
---    来回跳。解释器只在 `time == instruction->time` 时执行、不等就结束这一帧，
---    帧末才 time++（EclRun.cpp:44-110）——推下来的实际节拍是：
---      每 2 帧出一次弹（t 为偶数的帧）；角度 = normalize(ORBIT_ANGLE + π + lf0)，
---      出弹后 lf0 += lf1；每 9 次出弹（= 16 帧）走一次 t=2 的尾块：
---        `ins_10(li6, 6)` → li6 变大（`ins_46(li6, 150, ≤)` 判定后钳在 150）、
---        lf0 归零，然后 `ins_4(0, …)` 把时间拨回 0 → **同一帧**再补一次弹
---      → 8 只小怪每帧平均 4 发（8 只 / 2 帧），稳态约 4×(10+150) = 640 发在场上。
---      （counter extraInt0 = 8：t=2 那一帧先 `--` 再判，>0 就跳回 t=0 那一段出弹、
---        <=0 才落进尾块；所以一轮 16 帧里正好 1（头）+ 7（跳）+ 1（尾）= 9 次。）
---    ★ li6 就是小怪弹的寿命：`ins_111` 建了 3 条 transform 记录（EclRunHigh.inl:243-262）：
---        #0 SET_CULL_DELAY(li6)、#1 WAIT(li6, allowWhileActive = 1)、#2 DESPAWN。
---      SET_CULL_DELAY 是「出生后 li6 帧内不许按出屏回收」（BulletManager.cpp:419-421、
---      :856-899）；WAIT 记录一生成就把 timer 设成 li6（:415-417），之后只在 FIRED
---      分支每帧减 1（:848-854）→ 减到 0 的下一帧轮到 DESPAWN（:437-439）→
---      这些弹**飞不到屏幕外就自己消失**（速度 3 → 最多飞 3×150 = 450 px）。
---    ★ ins_97 的 ShotArgs 按结构体字段解出来是：bulletType **2** / color = li0（4 或 6，
---      变量位 bit1）/ count1 **1** / count2 1 / speed1 3.0 / speed2 0.8 /
---      angle = lf2 / angleStep 0.1308997（count1 = 1 → 偏移恒 0，用不上）/
---      flags 401922 = SPAWN_FAST|音效|CULL|WAIT|DESPAWN。
---      ★ li0 是**弹色**不是弹数（组长 6、组员 4 → 两种颜色的弹）。
---      bulletType 2 的出生脚本 = etama.decl script21（`+10: ins_1`）→ 10 帧。
---    ★ t=0 的 `ins_72(6000, xF0, xF1, lf0, lf1, 0, 3)` = ORBIT_AROUND_POINT
---      （EclRunLow.inl:577-597）：圆心 = 出生点、起始角 = 组的随机角、角速度 = lf1、
---      半径 0 起、径向速度 +3/帧（边自转边外扩）。
---      `ins_135(0, 115)` 挂上子 context 0（Sub115）、`ins_18(lf1, 1)` 是除以 1，无作用。
---    ★ `ins_80(8)` 关的是 **NO_SPRITE** 选择位（EclInteractionFlag，EclManager.hpp:520-530），
---      = 让这只小怪**显示贴图**，不是关判定。
---
---  · Sub115（小怪的子 context 0）：t=120 `ins_72(6000, xF0, xF1, lf0, lf1, 380, 0)`
---    → 半径直接跳到 **380**、径向速度归零、角度**复位成组的随机角**。
---    ★ 子 context 的 xF0/xF1/lf0/lf1 是 `ins_135` 那一刻从主 context 拷来的
---      （EclRunHigh.inl:646-680 拷到 secondaryTime 为止 = 同样 0x78 字节）
---      → 圆心与「组的随机角」都保留着。
---    ★ 380 px 远大于场地半宽/半高（192 / 224）→ 8 只小怪**全程在屏幕外**，
---      只当弹源；它们朝 `ORBIT_ANGLE + π`（= 圆心方向）打，也就是从屏幕外往里打。
---
---  · 同屏上限：弹 1536 槽（`Bullet bullets[0x601]`，BulletManager.hpp:455）。
---    波满不生、波中途生不出来就丢掉剩下的（BulletManager.cpp:685-712）。
---    8 只小怪每 2 帧一轮扇形 → 实测同屏峰值 658 个对象 / 1536 槽，**没有打满**（槽位够用，
---    不需要为了「玩得下去」降密度，但也不能再加密）。
---  · 占位贴图：弹 = ball_small、小怪 = "servant"。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x−192、y' = 224−y、角度取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
local function th08_color(c) return c + 1 end

---Sub113（根）的节拍。
local BOSS_END_Y = 96                       -- ins_64(110, 4, 192, 128)：TH08 y=128 → 我们 96
local BOSS_MOVE_FRAMES = 110
local SETUP_T = 110                         -- 8 只小怪都在这一帧
local WANDER_T = 510                        -- `ins_67(60, 4, 1.0)`
local FAN_FIRST_T = 570                     -- `ins_7(lf0, ANGLE_TO_PLAYER)` + 第一条 ins_97
local FAN_T = { [570] = 1, [590] = 2, [610] = 3, [630] = 4 }   -- 值 = count1
local CYCLE_LAST = 690                      -- `ins_4(510, −236)`
local RESTART_T = 511                       -- 时间拨回 510、帧末 time++ → 下一帧从 511 起算
local WANDER_FRAMES = 60                    -- ins_67 的时长（参数 0）
local WANDER_SPEED = 1.0                    -- ... 的速度（参数 2）
local WANDER_EASING = 4                     -- ... 的缓动（OUT_QUADRATIC）
local BOSS_FAN_SPEED = 4.0                  -- ins_97 的 speed1（count2 = 1 → 直接用它）
local BOSS_FAN_STEP = 0.1308997             -- ... 的 angleStep（7.5°）
local BOSS_BULLET_COLOR = 2                 -- 打包色号 1 → 我们的 2
local BOSS_SPAWN_FRAMES = 24                -- bulletType 10 → etama.decl script27（`+24: ins_1`）

---Sub114 / Sub115（小怪）。
local MINION_GROUPS = 4                     -- 4 组
local MINIONS_PER_GROUP = 2                 -- 每组 2 只
local MINION_SPIN_FAST = -0.0261799         -- TH08 组长的 +1.5°/帧 → 我们取反
local MINION_SPIN_SLOW = 0.022439947        -- TH08 组员的 −1.2857°/帧 → 我们取反
local MINION_FAN_COUNT = 1                  -- ins_97 的 count1（两组都是 1 发；li0 是**弹色**）
local MINION_SIZE_LEAD = 6                  -- 组长 li0 = 6 → 弹色 6（大一点的弹）
local MINION_SIZE_MEMBER = 4                -- 组员 li0 = 4
local MINION_FAN_SPEED = 3.0                -- ins_97 的 speed1
local MINION_FAN_STEP = 0.1308997           -- ... 的 angleStep（7.5°）
local MINION_SPAWN_FRAMES = 10              -- bulletType 2 → etama.decl script21（`+10: ins_1`）
local MINION_VOLLEY_PERIOD = 2              -- 每 2 帧一次扇形（Sub114 的 t=0/t=2 循环）
local MINION_CYCLE = 16                     -- 9 次扇形 = 16 帧（t=2 尾块）
local MINION_RADIAL = 3.0                   -- ins_72 的 radialVelocity（Sub114）
local MINION_RESTART_T = 120                -- Sub115 自己的 time 120
local MINION_RADIUS_RESET = 380             -- ... 的 orbitRadius
local MINION_CULL_INIT = 50                 -- `ins_6(li6, 50)`
local MINION_CULL_STEP = 6                  -- `ins_10(li6, 6)`
local MINION_CULL_MAX = 150                 -- `ins_46(li6, 150, ≤)` 之后的 `ins_6(li6, 150)`
local MINION_COLOR_LEAD = 7                 -- th08_color(6)
local MINION_COLOR_MEMBER = 5               -- th08_color(4)
local POOL_SIZE = 1536                      -- `Bullet bullets[0x601]`（BulletManager.hpp:455）

local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local SPRITE_HALF = 8                       -- 占位 ball_small 是 16×16

---本卡自己的弹池（= 原作那 1536 个弹槽）与小怪登记表。
local pool = {}
local minions = {}

---弹 / 小怪的类（先声明：下面的 spawn 助手要引用它们）。
local lw213_bullet
local lw213_minion

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:810-816）。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---一次 SHOOT_FAN（ins_97 = op97；BulletManager.cpp:118-129 的 FAN 分支）：
---  count1 奇数 → 偏移 0,±step,±2step…；偶数 → ±step/2,±3step/2…；不含自机角。
---  （本卡小怪的 count1 恒为 1 → 偏移恒 0，angleStep 用不上。）
---  ★ 池满 → **整波不生**；波中途生不出来就丢掉剩下的（BulletManager.cpp:685-712）。
local function fan_shot(x, y, base, count1, speed, color, step, spawn_frames, life)
    local used = pool_used()
    for i = 0, count1 - 1 do
        if used >= POOL_SIZE then return end
        local off
        if count1 % 2 == 1 then
            off = math.floor((i + 1) / 2) * step
        else
            off = math.floor(i / 2) * step + step * 0.5
        end
        if i % 2 == 1 then off = -off end
        pool[#pool + 1] = New(lw213_bullet, x, y, base + off, speed, color, spawn_frames, life)
        used = used + 1
    end
end

---本卡的弹。SPAWN_FAST 出生动画 + 直线；`life > 0` = 带 WAIT 记录（小怪弹，
---出生 life 帧后自己 DESPAWN），`life == 0` = 没有 transform 记录（BOSS 弹，出屏回收）。
lw213_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color, spawn_frames, life)
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（卡 206/209/210/211/212 同款）
        self.lw213_bvx = math.cos(angle) * speed
        self.lw213_bvy = math.sin(angle) * speed
        ---SPAWN_FAST：出生瞬间位置先退 velocity·4，之后每帧只走 velocity/2
        ---（BulletManager.cpp:220-227、:936-945）。
        self.x = x - self.lw213_bvx * 4
        self.y = y - self.lw213_bvy * 4
        self.vx, self.vy = self.lw213_bvx / 2, self.lw213_bvy / 2
        self.lw213_spawn = spawn_frames
        self.lw213_wait = life              -- WAIT 记录的 frames（0 = 没有这条记录）
        self.colli = false                  -- 出生动画期间没有判定
    end,
    frame = function(self)
        ---① 出生动画：跑完那一帧才进 FIRED（BulletManager.cpp:953-1040 的
        ---   SPAWNING_FAST → activateBullet，速度在那一帧补成整速）。
        if self.lw213_spawn > 0 then
            self.lw213_spawn = self.lw213_spawn - 1
            if self.lw213_spawn == 0 then
                self.vx, self.vy = self.lw213_bvx, self.lw213_bvy
                self.colli = true
            end
            bullet.frame(self)
            return
        end
        if self.lw213_wait > 0 then
            ---② 小怪弹：WAIT 记录的 timer 每帧减 1（BulletManager.cpp:848-854），减到 0 的
            ---   下一帧轮到 DESPAWN（:437-439）→ 出生 li6 帧后自己消失，永远飞不出屏。
            self.lw213_wait = self.lw213_wait - 1
            if self.lw213_wait == 0 then
                object.RawDel(self)
                return
            end
        elseif outside_field(self.x, self.y) then
            ---③ BOSS 弹：没有 SET_CULL_DELAY → 一出屏就回收（BulletManager.cpp:856-899）。
            object.RawDel(self)
            return
        end
        bullet.frame(self)
    end,
})

---小怪（Sub114 + 子 context Sub115）。占位贴图 "servant"；原作它有 24×24 判定与 life 1000，
---但移植版没有「敌机受伤」这套系统（卡 205..212 同款），所以打不掉、也不会被打死。
---  x, y    = 出生点（= BOSS 在 t=110 的位置，也是公转圆心）
---  theta0  = 组的随机起始角（我们坐标）
---  omega   = 轨道角速度（我们坐标，也是扇形角累加量 lf1 —— 原作 lf0 += lf1 用的是同一个）
---  color   = 弹色（= li0：组长 6、组员 4。count1 恒为 1）
lw213_minion = Class(object, {
    init = function(self, x, y, theta0, omega, count1, color)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.5, 0.5
        self.colli = false
        self.navi = false
        self.bound = false                  -- 半径会跑到场地外，不能自动回收
        self.rot = 0
        self._blend, self._a = "", 255
        self.lw213_t = 0
        self.lw213_cx, self.lw213_cy = x, y -- 公转圆心（ins_7(xF0, ENEMY_POSITION_X)）
        self.lw213_theta0 = theta0
        self.lw213_theta = theta0
        self.lw213_omega = omega
        self.lw213_radius = 0               -- ins_72 的 orbitRadius
        self.lw213_radial = MINION_RADIAL   -- ... 的 radialVelocity
        self.lw213_count1 = count1
        self.lw213_color = color
        self.lw213_cull = MINION_CULL_INIT  -- li6
        self.lw213_acc = 0                  -- lf0（出弹角累加量）
    end,
    frame = function(self)
        local t = self.lw213_t
        ---① 主 context Sub114：每 2 帧一次扇形（见卡头注释的节拍推导）。
        if t % MINION_VOLLEY_PERIOD == 0 then
            if t % MINION_CYCLE == 0 then
                ---t=2 尾块：li6 += 6（钳在 150）、lf0 归零，然后同一帧补一次扇形。
                if t > 0 then
                    self.lw213_cull = math.min(self.lw213_cull + MINION_CULL_STEP,
                            MINION_CULL_MAX)
                end
                self.lw213_acc = 0
            end
            ---`ins_25/15/37`：角度 = normalize(ORBIT_ANGLE + π + lf0)。
            ---出弹位置用的是**上一帧末**的位置（RunEcl 在 UpdateMovement 之前）。
            local ang = self.lw213_theta + PI + self.lw213_acc
            fan_shot(self.x, self.y, ang, self.lw213_count1, MINION_FAN_SPEED,
                    self.lw213_color, MINION_FAN_STEP, MINION_SPAWN_FRAMES, self.lw213_cull)
            self.lw213_acc = self.lw213_acc + self.lw213_omega
        end
        ---② 子 context Sub115（t=120）：半径跳到 380、径向速度归零、角度复位成组的随机角。
        if t == MINION_RESTART_T then
            self.lw213_theta = self.lw213_theta0
            self.lw213_radius = MINION_RADIUS_RESET
            self.lw213_radial = 0
        end
        ---③ ORBIT 位移（EnemyManager.cpp:36-58）：ω 先加到角度，位置直接落在圆周点上。
        self.lw213_theta = self.lw213_theta + self.lw213_omega
        self.lw213_radius = self.lw213_radius + self.lw213_radial
        self.x = self.lw213_cx + math.cos(self.lw213_theta) * self.lw213_radius
        self.y = self.lw213_cy + math.sin(self.lw213_theta) * self.lw213_radius
        self.rot = -self.lw213_theta * RAD  -- 观感近似（小怪在屏幕外，本来也看不见）
        self.lw213_t = t + 1
    end,
})

---Sub113 t=110 的 8 只小怪（`ins_94`；顺序 = 4 组 × (组长 li0=6 → 组员 li0=4)）。
local function spawn_minions(owner)
    local bx, by = owner.x, owner.y
    for _ = 1, MINION_GROUPS do
        ---每组重抽一次起始角（我们坐标 = TH08 的 −RandomAngle）。
        local theta0 = -(ran:Float(0, 2 * PI) - PI)
        for k = 1, MINIONS_PER_GROUP do
            local lead = (k == 1)
            local m = New(lw213_minion, bx, by, theta0,
                    lead and MINION_SPIN_FAST or MINION_SPIN_SLOW,
                    MINION_FAN_COUNT,
                    lead and MINION_COLOR_LEAD or MINION_COLOR_MEMBER)
            minions[#minions + 1] = m
        end
    end
end

---「BOSS → 自机」的角（ANGLE_TO_PLAYER = g_Player.AngleToPoint(enemy->worldPosition)，
---EclOperandsFloat.cpp:114-115）。原作那两支都用 TH08 坐标算、我们整体取反，
---所以这里直接拿**我们坐标**算 atan2 就跟原作等价（卡 212 同款处理）。
local function aim_to_player(owner)
    return math.atan2(player.y - owner.y, player.x - owner.x)
end

---`ins_75(32, 48, 352, 128)`（**生成助手** t=0 设的移动边界，同时置 CLAMP_POSITION）→
---我们坐标的夹框 x∈[−160,160]、y∈[96,176]；下面四条判据拿「边界 ±96/48」去比。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）把角卷进 (−π, π]。原作只对「自机在左」
---那一支做（EclDependencies.cpp:135-138），后面的符号判据全靠它。
local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---抽角度 + 四条边界修正，再交给 StartTimedPolarDisplacement（:105-126）
---（delta = (cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4）。
---★ 「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle`，用的是**上一段的
---  移动方向**、不是刚抽到的 angle —— 原作自己的怪癖，照抄，别「修」成 angle。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BW_TH_L + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.lw213_mangle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---开始一次随机飘：delta = polar(角, 1.0 × 60)、时长 60、缓动 4、origin = 当前 worldPosition。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw213_mangle = angle            -- 下一段 ins_67 的怪癖要用它（TH08 口径）
    owner.lw213_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0, easing = WANDER_EASING,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = u
    if move.easing == 4 then
        e = 1 - (1 - u) * (1 - u)
    end
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---BOSS 每帧。原作顺序：RunEcl（主 context）→ ClampPosition → IntegrateVelocity → worldPosition。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw213_t 还是 nil（卡 205..212 同款守卫）。
    if owner.lw213_t == nil then return end
    local t = owner.lw213_t
    if t == SETUP_T then
        spawn_minions(owner)                         -- `ins_94` ×8
    elseif t == WANDER_T then
        begin_wander(owner)                          -- `ins_67(60, 4, 1.0)`
    elseif t == FAN_FIRST_T then
        owner.lw213_aim = aim_to_player(owner)       -- `ins_7(lf0, ANGLE_TO_PLAYER)`
    end
    local cnt = FAN_T[t]
    if cnt then
        ---`ins_97`：从 BOSS 的 worldPosition（+ shootOffset = 0，t=0 的 ins_110）出弹。
        fan_shot(owner.x, owner.y, owner.lw213_aim, cnt, BOSS_FAN_SPEED,
                BOSS_BULLET_COLOR, BOSS_FAN_STEP, BOSS_SPAWN_FRAMES, 0)
    end
    if t == CYCLE_LAST then
        owner.lw213_t = RESTART_T                    -- `ins_4(510, −236)`
        begin_wander(owner)                          -- **同一帧**接着跑 t=510 的 ins_67
    end
    if owner.lw213_t == t then
        owner.lw213_t = t + 1
    end
    ---位移（RunEcl 之后）
    local mv = owner.lw213_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw213_move = nil
        end
    end
    ---ClampPosition（EnemyManager.cpp:803-819）：生成助手的 `ins_75` 置了 CLAMP_POSITION，
    ---原作每帧在位移**前后**各钳一次（EnemyManagerUpdate.cpp:172-174）；这里位移只在本函数里变。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_init(owner)
    owner.lw213_t = 0
    owner.lw213_aim = 0
    ---★ 落位：生成助手 Sub116 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, BOSS_END_Y
    ---movementAngle = VectorAngle(0, 0) = 0。
    owner.lw213_mangle = 0
    owner.lw213_move = {
        x0 = owner.x, y0 = owner.y,
        dx = 0 - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0, easing = WANDER_EASING,
    }
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw213_t = nil
    owner.lw213_move = nil
    for i = #minions, 1, -1 do
        if IsValid(minions[i]) then
            object.RawDel(minions[i])
        end
        minions[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[213] = {
    init = function(owner)
        pool = {}
        minions = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
---------------------------------------------------------------
---卡 214「梦想天生」（博丽灵梦）
---  ecldata4asp.ecl：Sub43 = BOSS 根、Sub16 = 开场特效（`ins_52(16)` 调的）、
---  Sub44 = 使魔本体、Sub45 = 使魔的子 context 0（摆动）、Sub46 = 使魔的子 context 1（出弹）。
---
---  · Sub43（根）：
---      t=0    `ins_64(90, 4, 192, 224)` 插值入场到 TH08 (192,224) = 我们 (0,0)（场地正中），
---             缓动 4 = OUT_QUADRATIC。同帧的 ins_76（关移动边界）、ins_80(3)/(4)（关判定）、
---             ins_95（清场）、ins_105(0)（关射击间隔）、ins_113（弹音效）、
---             ins_134(2220, 38)（37 秒计时）、ins_122（符卡登记）、ins_155(1)（超时符卡）
---             都由 boss 系统与 lw_before 管，不另写。
---      t=90   `ins_81(4)` 开可伤害、`ins_160(480)` 减伤计时（移植版不打伤害，跳过）、
---             `ins_75(128,144,256,304)` 设移动边界 → 我们 x∈[−64,64]、y∈[−80,80]、
---             `ins_124(13)` 音效、`ins_52(16)` 调 Sub16（32 个特效，纯观感，跳过）。
---      t=120  `ins_59(6)` 换备用 ANM 序列（观感，跳过）。
---      t=170  ★ 一次性生成 8 只使魔（`ins_92` = SPAWN_FAMILIAR_INHERITING_POSITION，
---             操作数 (sub, x, y, life, itemDropType, score)；偏移用父的 **position**
---             → 8 只都生成在 BOSS 当前位置 = 场地正中）。三条变量按生成顺序递增：
---               li0 = 61,65,64,68,63,67,62,62（= 使魔的 anm 编号，Sub44 的 ins_54 用）
---               li1 = 0,6,12,18,24,30,36,42（每次 ins_92 之前 `ins_10(li1, li2)`，
---                                            li2 = 难度值 6 → !N 是 6、!H 是 16、!L 是 20）
---               lf0 = π/2, 3π/4, π, …（每次 `ins_15(lf0, π/4)`；第一次就是 π/2）
---               life = 500,300,500,300…（ins_92 的操作数 3）
---             ★ 变量继承：SpawnEnemy2 把父 context 从 intVariables 起 **0x78 字节**整块拷给
---               子 context（EnemyTimeline.cpp:64-114；0x78 = 8 li + 8 lf + 4 xInt + 2 xFloat
---               + 4 callInt + 4 callFloat，布局见 EclManager.hpp:600-626）
---               → 使魔拿到的就是**生成那一刻**的 lf0/lf1/li0。
---      t=170  `ins_67(120, 0, 0.5)` 随机飘（BeginBoundaryAwareMove，
---             EclDependencies.cpp:128-191；边界就是上面那个盒子，缓动 0 = LINEAR）。
---             这一条之后每 60 帧重来一次：t=230 的 `ins_4(170, Sub43_1464)` 把时间拨回 170、
---             落点正是 t=170 的 ins_67 → **同一帧**就开始下一段
---             → 每 60 帧重抽一次方向、每段线性 120 帧走 0.5×120 = 60 px 的随机游走。
---
---  · Sub44（使魔本体，t 从生成那一帧的 0 起算）：
---      t=0    `ins_54(li0)` 设 anm、`ins_77(24,24)` 判定、`ins_160(30)` 减伤、
---             `ins_80(16)` 关 ALLOW_OFFSCREEN、`ins_80(3)` 关判定，然后
---             `ins_73(100, lf0, −0.15708, 0.64)` = ORBIT_AROUND_CURRENT_POSITION
---             （EclRunLow.inl:598-615）：时长 100 帧、圆心 = 当前 position、起始角 = lf0、
---             角速度 −0.15708 rad/帧（−9°/帧）、半径从 0 起、径向速度 +0.64/帧。
---      t=99   `ins_74(6000, −0.0785398, 0)` = SET_ORBIT_VELOCITIES：时长改 6000、
---             角速度改 −0.0785398（−4.5°/帧）、径向速度归零 → 半径冻在 0.64×99 = 63.36；
---             然后 `ins_135(0, 45)` / `ins_135(1, 46)` 挂上两个子 context
---             （SET_CHILD_ECL 也把 0x78 字节变量拷进子 context，EclRunHigh.inl:646-680）。
---      t=6099 `ins_1` TERMINATE（远超符卡时长）。
---    ★ 圆心是**局部**坐标：ins_73 抄的是 enemy->position（使魔自己的坐标 = (0,0)），
---      而世界坐标 = position + positionOffset（= 生成那一刻 BOSS 的 position）
---      → 8 只使魔绕**场地正中**转、半径 63.36。
---    ★ ORBIT 位移（EnemyManager.cpp:36-72）：orbitAngle = AddNormalizeAngle(orbitAngle,
---      ω) → orbitRadius += radial → 目标点 = 圆心 + polar(角, 半径) →
---      velocity = 目标点 − 当前位置 → movementAngle = VectorAngle(velocity)。
---      RunEcl 里主 context → 子 context 依次跑完才调 UpdateMovement，所以**出弹用的是
---      上一帧末的位置和 movementAngle**。
---
---  · Sub45（子 context 0，摆动）：每帧把敌人的 **orbitAngularVelocity 字段**改写成
---      `cos(lf1) × (−0.0785398)`，然后 `lf1 += 0.0130899`（+0.75°/帧）再归一化。
---      角速度于是是余弦调制的 → θ(t) = θ0 − (0.0785398/0.0130899)·sin(φ) = θ0 − 6·sin(φ)，
---      φ = 0.75°·帧数 → **前后各扫约 6 rad（≈344°）、周期 480 帧**的大摆。
---      出弹方向取 MOVEMENT_ANGLE（= 这一帧的位移方向），弹流跟着大摆扫过整个场地。
---    ★ 子 context 的变量是 ins_135 那一刻的副本，Sub45 里的 lf0/lf1 跟 Sub44 的无关；
---      但它写的 10078 = ORBIT_ANGULAR_VELOCITY 是**敌人的字段**，主 context 也看得见。
---    ★ 顺序：同帧里主 context 先跑、再按 slot 升序跑子 context，所以 t=99 那一帧
---      ins_74 的 −0.0785398 立刻被 Sub45 的 cos(0)×(−0.0785398) 覆盖成同一个值。
---
---  · Sub46（子 context 1，出弹节拍）：整条子程序的时间戳全是 0，靠 `ins_2`
---      (SET_SECONDARY_TIME) 把**整个 context** 冻住：dispatch 顶部发现 secondaryTime > 0 就
---      secondaryTime--、time-- 然后结束这一帧，帧末统一 time++（EclRun.cpp:44-110）
---      → 净效果 = 冻结 N 帧后从原处继续（time 不前进）。裸字节推出来的节拍：
---        #0  li1 += 20
---        #1  SET_SECONDARY_TIME(li1)   ← 第一段冻结：第 k 只使魔 li1 = 6k → 冻 20+6k 帧
---                                         （8 只因此错开 6 帧）
---        #2..#18  17 条 ins_111          ← 只写一次，之后无限复用（见 BULLET_RECORDS）
---        #19 li1 = 200
---        #20 SHOOT_FAN(...)              ← 每轮都重新出一次弹
---        #21 SET_SECONDARY_TIME(li1)
---        #22 JUMP_IF_INT_LESS_EQUAL(li1, 60, @24)   ← li1 ≤ 60 就直接跳到 #24
---        #23 li1 -= 10
---        #24 JUMP(0, @20)                ← 回到 #20，同一帧再出一次弹
---      → 每只使魔的出弹间隔从 200 帧每次 −10 掉到 60 帧，之后固定 60 帧一发。
---    ★ 弹（ins_97 的 ShotArgs，EclDependencies.cpp:673-693 的结构体：
---        i16 bulletType / i16 color / i32 count1 / i32 count2 / f32 speed1 / f32 speed2 /
---        f32 angle / f32 angleStep / u32 transformFlags）：
---        bulletType 11 / color 15 / count1 2 / count2 16 / speed1 9.0 / speed2 3.8 /
---        angle = MOVEMENT_ANGLE（10069，操作数 6 带变量位 0x40）/ angleStep 0.0261799（1.5°）/
---        flags 680578（= 0xA6282，见下）。
---      op97 = SHOOT_FAN → aimMode 1（**不加**自机角，BulletManager.cpp:118-136）：
---        count1 = 2（偶数）→ 两个方向 ±angleStep/2；count2 = 16 → 速度 9 − 5.2·j/16
---        （j = 0..15 → 9.0 掉到 4.125）。一发扇形 = 2 × 16 = 32 发。
---    ★ flags 680578 = 0xA6282 = SPAWN_FAST(2) | CHANGE_DIRECTION_AIMED(0x80) |
---      PLAY_SPAWN_SOUND(0x200) | SET_CULL_DELAY(0x2000) | SET_SPRITE(0x4000) |
---      WAIT(0x20000) | PLAY_SOUND(0x80000)（BulletManager.hpp:129-155）。
---      17 条 transform 记录逐条核对过裸字节，见下面 BULLET_RECORDS。
---    ★ 出生动画：bulletType 11 的 SPAWN_FAST 脚本 = etama.decl script21
---      （`ins_34(10, …)` → `+10: ins_1`）= 10 帧。
---
---  · 同屏上限：弹 1536 槽（`Bullet bullets[0x601]`，BulletManager.hpp:455）；
---    `activeBulletCount >= 0x600` 时**整波不生**、波中途生不出来就丢掉剩下的
---    （BulletManager.cpp:685-712）。本卡 8 只使魔 × 每 60~200 帧 32 发 → 会顶到上限。
---  · 占位贴图：弹 = ball_small、使魔 = "servant"。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x−192、y' = 224−y、角度取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
local function th08_color(c) return c + 1 end

---AddNormalizeAngle(a, 0.0)：卷进 [−π, π]（Global.cpp:1239-1257）。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then
        a = a - 2 * PI
    end
    return a
end

---Sub43（根）的节拍。
local BOSS_MOVE_FRAMES = 90                 -- ins_64(90, 4, 192, 224) 的时长
local BOSS_END_X, BOSS_END_Y = 0, 0         -- TH08 (192,224) → 我们 (0,0)：场地正中
local BOSS_START_Y = 96                     -- 生成时的 SET_POSITION(192, 128) → 我们 96
local MOVE_EASING = 4                       -- 4 = OUT_QUADRATIC（EnemyManager.cpp:100-121）
local FAMILIAR_T = 170                      -- 8 只使魔都在这一帧生成
local WANDER_FIRST = 170                    -- 第一条 ins_67（跟使魔同一帧）
local WANDER_PERIOD = 60                    -- t=230 的 ins_4(170, …) → 每 60 帧重来一次
local WANDER_FRAMES = 120                   -- ins_67(120, 0, 0.5) 的时长
local WANDER_SPEED = 0.5                    -- … 的速度
local WANDER_EASING = 0                     -- … 的缓动（0 = LINEAR）
---ins_75(128,144,256,304) 的四条边界换成我们坐标。
local BOUND_L, BOUND_R = -64, 64
local BOUND_B, BOUND_T = -80, 80
---同一组边界的 TH08 值：BeginBoundaryAwareMove 的四条判据拿 enemy->position（TH08 口径）比。
local T08_L, T08_R = 128, 256
local T08_B, T08_T = 144, 304

---Sub44 / Sub45（使魔本体与摆动）。
local FAM_COUNT = 8
local FAM_ANM = { 61, 65, 64, 68, 63, 67, 62, 62 }   -- li0：ins_54 的 anm 编号
local FAM_LI1 = { 0, 6, 12, 18, 24, 30, 36, 42 }      -- li1：每次 ins_92 前 +6（!N 的难度值）
local FAM_LIFE = { 500, 300, 500, 300, 500, 300, 500, 300 }  -- ins_92 的操作数 3
local ORBIT_DURATION = 100                  -- ins_73 的时长
local ORBIT_RADIAL = 0.64                   -- … 的径向速度
local ORBIT_SPIN = -0.15708                 -- … 的角速度（TH08 口径，−9°/帧）
local ORBIT_DURATION2 = 6000                -- ins_74 的时长
local ORBIT_SPIN2 = -0.0785398              -- … 的角速度（TH08 口径，−4.5°/帧）
local SWING_STEP = 0.0130899                -- Sub45：lf1 每帧 +0.75°
local SHOOT_T = 99                          -- ins_74 / ins_135 的时刻
local FAM_TERMINATE_T = 6099                -- ins_1
local FAM_HITBOX = 24                       -- ins_77(24, 24)

---Sub46（出弹）。
local FAN_COUNT1 = 2
local FAN_COUNT2 = 16
local FAN_SPEED1 = 9.0
local FAN_SPEED2 = 3.8
local FAN_STEP = 0.0261799                  -- 1.5°
local FAN_COLOR = 15                        -- ShotArgs 的 color（操作数 0 的高 16 位）
local FAN_SPAWN_FRAMES = 10                 -- bulletType 11 → etama.decl script21
local INTERVAL_START = 200                  -- #19 的 li1 = 200
local INTERVAL_MIN = 60                     -- #22 的判据
local INTERVAL_STEP = 10                    -- #23 的 li1 -= 10
local INTERVAL_ADD = 20                     -- #0 的 li1 += 20
local POOL_SIZE = 1536                      -- `Bullet bullets[0x601]`（BulletManager.hpp:455）
local OFFSCREEN_GRACE = 128                 -- 有转向状态的弹允许出屏 0x80 帧（BulletManager.cpp:870-890）

local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local SPRITE_HALF = 8                       -- 占位 ball_small 是 16×16

---本卡自己的弹池（= 原作那 1536 个弹槽）与使魔登记表。
local pool = {}
local familiars = {}

---弹的 transform 记录（Sub46 的 #2..#18，17 条 ins_111 的裸字节）。
---字段名按 BulletTransformRecord / BulletTransformPayload（BulletManager.hpp:36-127）：
---  ins_111 的操作数 = index / kind / allowWhileActive / int0 / int1 / float0 / float1
---推进规则（AdvanceTransformProgram，BulletManager.cpp:312-478）：
---  · `allowWhileActive == 0 且已有激活的 transform` → 原地返回（挡住后面的记录）；
---  · SET_CULL_DELAY / SET_SPRITE / PLAY_SOUND 是一次性的：读完立刻 ++index 继续看下一条；
---  · WAIT / CHANGE_DIRECTION_* 是有状态的：激活后 index 也会前进，但状态一直挂着，
---    WAIT 要等 timer 减到 0 那一帧才清位（:848-854）、转向要等 timer 走到 interval 算
---    完成一次、完成 repeatCount 次才清位（:1343-1360）。
---逐条走一遍（0 起算的 index）：
---  0  SET_CULL_DELAY(200)  allow=1  → 出生那一下消费掉，弹 200 帧内不许按出屏回收
---  1  CD_AIMED  allow=1 interval=50 repeat=1 angle=0 speed=0.0
---     → 沿出弹方向线性减速到 0（50 帧），走完那一下把朝向改成**自机**、速度 0 → 停住
---  2  SET_SPRITE(3,15)  allow=0     ← 要等上面那条转向状态清掉才轮得到
---  3  WAIT(10)          allow=0     → 停住后原地闪 10 帧（WAIT 实际占 11 帧，见下）
---  4  SET_SPRITE(3,2)   allow=0
---  5  WAIT(10)          allow=0
---  6  PLAY_SOUND(25)    allow=0
---  7  SET_SPRITE(11,2)  allow=0
---  8  CD_AIMED allow=0 interval=1  repeat=1 speed=1.5  → 一帧后朝自机、速度 1.5
---  9  CD_AIMED allow=0 interval=50 repeat=1 speed=0.0  → 再用 50 帧减速到 0（停住）
---  10 SET_SPRITE(3,2)   11 WAIT(10)   12 SET_SPRITE(3,4)
---  13 PLAY_SOUND(25)    14 WAIT(10)   15 SET_SPRITE(11,4)
---  16 CD_AIMED allow=0 interval=1 repeat=1 speed=6.0  → 一帧后朝自机、速度 6 冲过来
---    （角度用**那一下**的自机位置算；最后这一段没有动作记录，所以出屏就回收）
---★ WAIT 的帧数：激活那一帧 timer = frames，同一帧的 FIRED 分支就 `timer--`，
---  之后每帧减 1，减到 0 的那一帧清位 → 占 frames+1 帧（BulletManager.cpp:848-854）。
---★ 占位贴图：SET_SPRITE 只记一笔（b_sprite），贴图不换（换素材时再按 bullet_type/color 区分）。
local K_CULL, K_CD, K_SPRITE, K_WAIT, K_SOUND = 0x2000, 0x80, 0x4000, 0x20000, 0x80000
local BULLET_RECORDS = {
    { k = K_CULL,   allow = 1, frames = 200 },
    { k = K_CD,     allow = 1, interval = 50, rep = 1, angle = 0.0, speed = 0.0 },
    { k = K_SPRITE, allow = 0, bullet_type = 3,  color = 15 },
    { k = K_WAIT,   allow = 0, frames = 10 },
    { k = K_SPRITE, allow = 0, bullet_type = 3,  color = 2 },
    { k = K_WAIT,   allow = 0, frames = 10 },
    { k = K_SOUND,  allow = 0, sound = 25 },
    { k = K_SPRITE, allow = 0, bullet_type = 11, color = 2 },
    { k = K_CD,     allow = 0, interval = 1,  rep = 1, angle = 0.0, speed = 1.5 },
    { k = K_CD,     allow = 0, interval = 50, rep = 1, angle = 0.0, speed = 0.0 },
    { k = K_SPRITE, allow = 0, bullet_type = 3,  color = 2 },
    { k = K_WAIT,   allow = 0, frames = 10 },
    { k = K_SPRITE, allow = 0, bullet_type = 3,  color = 4 },
    { k = K_SOUND,  allow = 0, sound = 25 },
    { k = K_WAIT,   allow = 0, frames = 10 },
    { k = K_SPRITE, allow = 0, bullet_type = 11, color = 4 },
    { k = K_CD,     allow = 0, interval = 1,  rep = 1, angle = 0.0, speed = 6.0 },
}

---弹 / 使魔的类与子 context 的步进（先声明：下面的类体里要引用它们）。
local lw214_bullet
local lw214_familiar
local sub46_step

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:810-816）。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---「弹 → 自机」的角（g_Player.AngleToPoint(&bullet->position)）。原作两边都在 TH08 坐标里算、
---我们整体取反，所以直接拿我们坐标算 atan2 就跟原作等价（卡 212/213 同款处理）。
local function aimed_angle(b)
    return math.atan2(player.y - b.y, player.x - b.x)
end

---AdvanceTransformProgram 的一次推进（BulletManager.cpp:312-478）。
local function advance_program(b)
    while b.b_prog <= #BULLET_RECORDS do
        local r = BULLET_RECORDS[b.b_prog]
        ---`allowWhileActive == 0 && activeTransformFlags != 0 → return`（:321-323）。
        if r.allow == 0 and (b.b_cd ~= nil or b.b_wait ~= nil) then
            return
        end
        if r.k == K_CULL then
            b.b_cull = r.frames                     -- offscreenCullDelayFrames（:419-422）
            b.b_prog = b.b_prog + 1
        elseif r.k == K_SPRITE then
            b.b_sprite = r                          -- 占位：只记一笔（:424-430）
            b.b_prog = b.b_prog + 1
        elseif r.k == K_SOUND then
            b.b_prog = b.b_prog + 1                 -- PLAY_SOUND（:436-441）
        elseif r.k == K_WAIT then
            b.b_wait = r.frames                     -- WAIT（:414-417）
            b.b_prog = b.b_prog + 1
            return
        else                                        -- K_CD：CHANGE_DIRECTION_AIMED（:372-388）
            b.b_cd = { timer = 0, interval = r.interval, rep = r.rep,
                       done = 0, angle = r.angle, speed = r.speed }
            b.b_prog = b.b_prog + 1
            return
        end
    end
end

---FIRED 分支里跟速度有关的那一段（AdvanceTransformProgram + 各 Update* 状态机）。
local function fired_transform(b)
    advance_program(b)
    if b.b_cd then
        local c = b.b_cd
        local magnitude
        if c.timer >= c.interval then
            ---走完一次：朝向改成自机 + 记录里的偏角，速度改成记录里的速度（:1343-1360）。
            c.done = c.done + 1
            if c.done >= c.rep then
                b.b_cd = nil
            end
            b.b_angle = add_norm(aimed_angle(b) + c.angle)
            b.b_speed = c.speed
            magnitude = b.b_speed
            c.timer = 0
        else
            ---没走完：速度沿**当前朝向**线性衰减到 0（:1361-1366）。
            magnitude = b.b_speed - (c.timer * b.b_speed) / c.interval
        end
        b.b_vx = math.cos(b.b_angle) * magnitude
        b.b_vy = math.sin(b.b_angle) * magnitude
        c.timer = c.timer + 1
    end
    if b.b_wait then
        if b.b_wait <= 0 then
            b.b_wait = nil
        else
            b.b_wait = b.b_wait - 1
        end
    end
end

---本卡的弹（bulletType 11）。占位贴图 ball_small。
lw214_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color)
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（卡 206/209/210/211/212/213 同款）
        self.b_angle = angle
        self.b_speed = speed
        self.b_vx = math.cos(angle) * speed
        self.b_vy = math.sin(angle) * speed
        ---SPAWN_FAST：出生瞬间位置先退 velocity·4（BulletManager.cpp:220-227）。
        self.x = x - self.b_vx * 4
        self.y = y - self.b_vy * 4
        self.vx, self.vy = self.b_vx / 2, self.b_vy / 2
        self.b_spawn = FAN_SPAWN_FRAMES
        self.b_prog = 1                     -- 出生那一刻也会跑一次 AdvanceTransformProgram
        self.b_cull = 0                     -- （:243-249），下面调一次就等价于原作的初始状态
        self.b_off = 0                      -- offscreenFrames
        self.colli = false                  -- 出生动画期间没有判定
        advance_program(self)
    end,
    frame = function(self)
        ---① 出生动画（SPAWN_FAST，10 帧）：每帧只走 velocity/2（:953-960）。
        if self.b_spawn > 0 then
            self.b_spawn = self.b_spawn - 1
            if self.b_spawn > 0 then
                bullet.frame(self)
                return
            end
            ---跑完那一帧紧接着补跑一次 FIRED 分支（`:966 goto activateBullet`），
            ---于是这一帧一共走了 velocity/2 + velocity（照抄原作的怪癖）。
            self.vx, self.vy = self.b_vx, self.b_vy
            self.colli = true
        end
        ---② FIRED：先跑 transform 程序（含转向/等待状态机），再按新速度位移。
        fired_transform(self)
        self.vx, self.vy = self.b_vx, self.b_vy
        bullet.frame(self)
        ---③ 出屏回收（BulletManager.cpp:856-899）。
        if self.b_cull > 0 then
            self.b_cull = self.b_cull - 1
        end
        if self.b_cull == 0 then
            if outside_field(self.x, self.y) then
                if self.b_cd then
                    ---还挂着转向状态 → 允许出屏 128 帧再回收。
                    self.b_off = self.b_off + 1
                    if self.b_off >= OFFSCREEN_GRACE then
                        object.RawDel(self)
                    end
                elseif self.b_off == 0 then
                    object.RawDel(self)
                else
                    self.b_off = self.b_off - 1
                end
            else
                self.b_off = 0
            end
        end
    end,
})

---一次 SHOOT_FAN（ins_97；BulletManager.cpp:685-712 的循环 + :118-136 的 FAN 分支）：
---  j（速度档）在外、i（方向）在内；count1 = 2（偶数）→ 两个方向 ±angleStep/2；
---  速度 = 9 − 5.2·j/16。角度整体取反（见文件头），所以偏角写成 −off。
---  池满（1536）→ **整波不生**；波中途生不出来就丢掉剩下的。
local function fan_shot(owner)
    local used = pool_used()
    if used >= POOL_SIZE then
        return
    end
    for j = 0, FAN_COUNT2 - 1 do
        local speed = FAN_SPEED1 - (FAN_SPEED1 - FAN_SPEED2) * j / FAN_COUNT2
        for i = 0, FAN_COUNT1 - 1 do
            if used >= POOL_SIZE then
                return
            end
            local off
            if FAN_COUNT1 % 2 == 1 then
                off = math.floor((i + 1) / 2) * FAN_STEP
            else
                off = math.floor(i / 2) * FAN_STEP + FAN_STEP * 0.5
            end
            if i % 2 == 1 then
                off = -off
            end
            pool[#pool + 1] = New(lw214_bullet, owner.x, owner.y, owner.fm_mangle - off,
                    speed, th08_color(FAN_COLOR))
            used = used + 1
        end
    end
end

---使魔（Sub44 + 子 context Sub45/Sub46）。占位贴图 "servant"；原作它有 24×24 判定与 life 500/300，
---但移植版没有「敌机受伤」这套系统（卡 205..213 同款），所以打不掉、也不会被打死。
---  x, y   = 出生点（= 生成那一刻 BOSS 的位置，也是公转圆心）
---  theta0 = 起始轨道角（我们坐标 = TH08 的 −lf0）
---  li1    = 子 context 1 的起始相位（= 6k，决定 8 只的错开量）
lw214_familiar = Class(object, {
    init = function(self, x, y, theta0, li1)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.5, 0.5
        self.colli = false
        self.navi = false
        self.bound = false                  -- 半径/位置都会跑到场地外，不能自动回收
        self.rot = 0
        self._blend, self._a = "", 255
        self.fm_t = 0
        self.fm_cx, self.fm_cy = x, y        -- 公转圆心（ins_73 抄的是自己的 position）
        self.fm_theta = theta0
        self.fm_radius = 0
        self.fm_radial = ORBIT_RADIAL        -- 主 context 的径向速度（ins_73）
        self.fm_spin = -ORBIT_SPIN           -- … 的角速度，我们坐标 = TH08 取反
        self.fm_mangle = 0                   -- MOVEMENT_ANGLE（我们坐标，出弹方向用它）
        self.fm_li1 = li1                    -- 子 context 1 的 li1
        self.fm_pc = 1                       -- 子 context 1 的程序计数器
        self.fm_sec = 0                      -- 子 context 1 的 secondaryTime
        self.fm_phi = 0                      -- 子 context 0 的 lf1
        self.fm_swing = false                -- 子 context 0 是否已建立（t=99）
        self.fm_shot = false                 -- 子 context 1 是否已建立（t=99）
    end,
    frame = function(self)
        local t = self.fm_t
        ---① 主 context（Sub44）。
        if t == SHOOT_T then
            self.fm_radial = 0                       -- `ins_74(6000, −0.0785398, 0)`
            self.fm_spin = -ORBIT_SPIN2
            self.fm_swing = true                     -- `ins_135(0, 45)`
            self.fm_shot = true                      -- `ins_135(1, 46)`
        elseif t >= FAM_TERMINATE_T then
            object.RawDel(self)                      -- `ins_1` TERMINATE
            return
        end
        ---② 子 context 0（Sub45）：把角速度改写成 cos(φ)×(−0.0785398)（TH08 口径）。
        if self.fm_swing then
            self.fm_spin = -ORBIT_SPIN2 * math.cos(self.fm_phi)
            self.fm_phi = self.fm_phi + SWING_STEP
        end
        ---③ 子 context 1（Sub46）：出弹节拍（见卡头注释的指令表）。
        if self.fm_shot then
            sub46_step(self)
        end
        ---④ ORBIT 位移（EnemyManager.cpp:36-72）+ IntegrateVelocity。
        self.fm_theta = self.fm_theta + self.fm_spin
        self.fm_radius = self.fm_radius + self.fm_radial
        local nx = self.fm_cx + math.cos(self.fm_theta) * self.fm_radius
        local ny = self.fm_cy + math.sin(self.fm_theta) * self.fm_radius
        self.fm_mangle = math.atan2(ny - self.y, nx - self.x)   -- 这一帧的位移方向
        self.x, self.y = nx, ny
        self.rot = -self.fm_theta * RAD              -- 观感近似
        self.fm_t = t + 1
    end,
})

---Sub46 的指令表（裸字节：全部 time = 0，靠 ins_2 冻结、ins_4/ins_46 跳转；1 起算）。
---#2..#18 那 17 条 ins_111 只在第一轮写一次、之后无限复用，而本卡 8 只使魔的记录完全一样
---→ 直接就是上面那张 BULLET_RECORDS，运行期没有要做的事，所以这里不占指令位。
local S46_ADD, S46_FREEZE, S46_SET, S46_SHOT, S46_JLE, S46_SUB, S46_JMP = 1, 2, 3, 4, 5, 6, 7
local SUB46 = {
    { S46_ADD, INTERVAL_ADD },          -- #0
    { S46_FREEZE },                     -- #1
    { S46_SET, INTERVAL_START },        -- #19（前面的 17 条 ins_111 见上）
    { S46_SHOT },                       -- #20
    { S46_FREEZE },                     -- #21
    { S46_JLE, INTERVAL_MIN, 8 },       -- #22 → 满足就跳到 #24（表内第 8 项）
---★ 目标必须是 8：裸字节里 op46 的第 4 个操作数 = +48，而 #22 的 off = 0x8c2c、
---  #24 的 off = 0x8c5c，0x8c2c + 48 = 0x8c5c → 跳到 #24（JUMP 回 #20）。
---  （原来写的 9 越界，`SUB46[9]` = nil → 跑到 5940 帧就 'attempt to index local ins'。）
    { S46_SUB, INTERVAL_STEP },         -- #23
    { S46_JMP, 4 },                     -- #24 → 跳回 #20（1 起算 = 4）
}

sub46_step = function(self)
    if self.fm_sec > 0 then
        self.fm_sec = self.fm_sec - 1
        return
    end
    while true do
        local ins = SUB46[self.fm_pc]
        local op = ins[1]
        if op == S46_ADD then
            self.fm_li1 = self.fm_li1 + ins[2]
            self.fm_pc = self.fm_pc + 1
        elseif op == S46_SET then
            self.fm_li1 = ins[2]
            self.fm_pc = self.fm_pc + 1
        elseif op == S46_SHOT then
            fan_shot(self)
            self.fm_pc = self.fm_pc + 1
        elseif op == S46_FREEZE then
            self.fm_sec = self.fm_li1
            self.fm_pc = self.fm_pc + 1
            ---原作的 dispatch 在 SET_SECONDARY_TIME 之后**同一帧**就会消耗一次
            ---（EclRun.cpp:52-58），所以这里也先减 1 再结束这一帧。
            self.fm_sec = self.fm_sec - 1
            return
        elseif op == S46_JLE then
            if self.fm_li1 <= ins[2] then
                self.fm_pc = ins[3]
            else
                self.fm_pc = self.fm_pc + 1
            end
        elseif op == S46_SUB then
            self.fm_li1 = self.fm_li1 - ins[2]
            self.fm_pc = self.fm_pc + 1
        else -- S46_JMP
            self.fm_pc = ins[2]
        end
    end
end

---Sub43 t=170 的 8 只使魔（`ins_92` ×8；li0/lf0/li1 按生成顺序递增）。
local function spawn_familiars(owner)
    local bx, by = owner.x, owner.y
    for k = 1, FAM_COUNT do
        ---lf0 从 π/2 起、每次生成前 +π/4（我们坐标取反）。
        local theta0 = -(PI / 2 + (k - 1) * PI / 4)
        local m = New(lw214_familiar, bx, by, theta0, FAM_LI1[k])
        m.fm_anm = FAM_ANM[k]
        m.fm_life = FAM_LIFE[k]
        familiars[#familiars + 1] = m
    end
end

---「BOSS → 自机」的 X（TH08 口径）比较要用 TH08 的 position（见 BeginBoundaryAwareMove）。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = add_norm(ran:Float(0, PI / 2) + 2.3561945)
    else
        angle = ran:Float(0, PI / 2) - 0.78539819
    end
    if bx < T08_L + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > T08_R - 96 then
        if angle < PI / 2 and angle >= 0 then
            ---★ 这一支用的是**上一段的移动方向**（enemy->movementAngle），不是刚抽到的 angle。
            angle = PI - (owner.lw214_mangle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < T08_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > T08_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove + StartTimedPolarDisplacement
---（EclDependencies.cpp:104-126、:128-191）：delta = polar(角, 0.5 × 120)、
---origin = 当前 worldPosition、时长 120、缓动 0（LINEAR）。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw214_mangle = angle            -- 下一段 ins_67 的怪癖要用它（TH08 口径）
    owner.lw214_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0, easing = WANDER_EASING,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then
        u = 1
    end
    local e = u
    if move.easing == 4 then
        e = 1 - (1 - u) * (1 - u)
    end
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---ClampPosition（EnemyManager.cpp:1200-1220 附近）：ins_75 之后位置被夹在那个盒子里。
local function clamp_boss(owner)
    if owner.x < BOUND_L then owner.x = BOUND_L
    elseif owner.x > BOUND_R then owner.x = BOUND_R end
    if owner.y < BOUND_B then owner.y = BOUND_B
    elseif owner.y > BOUND_T then owner.y = BOUND_T end
end

---BOSS 每帧。原作顺序：RunEcl（主 context）→ ClampPosition → IntegrateVelocity → ClampPosition
---→ worldPosition = position + offset。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw214_t 还是 nil（卡 205..213 同款守卫）。
    if owner.lw214_t == nil then
        return
    end
    local t = owner.lw214_t
    if t == FAMILIAR_T then
        spawn_familiars(owner)                       -- `ins_92` ×8（8 条都在同一帧）
    end
    if t >= WANDER_FIRST and (t - WANDER_FIRST) % WANDER_PERIOD == 0 then
        begin_wander(owner)                          -- `ins_67(120, 0, 0.5)`
    end
    owner.lw214_t = t + 1
    ---位移（RunEcl 之后）
    local mv = owner.lw214_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw214_move = nil
        end
    end
    clamp_boss(owner)
end

local function card_init(owner)
    owner.lw214_t = 0
    ---★ 落位：生成助手 Sub50 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)
    ---  （= BOSS_START_Y；BOSS_END_Y 是下面那条 ins_64 的终点 (0)）。
    owner.x, owner.y = 0, BOSS_START_Y
    ---`ins_64(90, 4, 192, 224)`：从 (0,96) 插值到我们 (0,0)，方向 = TH08 +y = π/2。
    owner.lw214_mangle = PI / 2
    owner.lw214_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0, easing = MOVE_EASING,
    }
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw214_t = nil
    owner.lw214_move = nil
    for i = #familiars, 1, -1 do
        if IsValid(familiars[i]) then
            object.RawDel(familiars[i])
        end
        familiars[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[214] = {
    init = function(owner)
        pool = {}
        familiars = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
end
---------------------------------------------------------------
---卡 215「炽热之星」（雾雨魔理沙）
---  ecldata4bsp.ecl：Sub60 = BOSS 根、Sub61 = BOSS 的子 context 0（出弹节拍）、
---  Sub62 = 彗星头的子 context 0（把自己钉在 BOSS 前方）、
---  Sub63/64/65/66 = 彗星头（同一帧生成 4 个，贴图与寿命不同）。
---
---  内容：魔理沙变成彗星，从场地上方反复俯冲穿过场地；俯冲时身后跟着 4 个彗星头，
---  同时按 8 帧一拍往外打「环」——环上的弹数一轮比一轮多（4/7/10…），
---  而且每发弹都会先飞出去、用 60 帧减速停住、原地等 180 帧，
---  再朝「出弹方向 + 一个固定偏角」加速 200 帧冲出来。
---
---  · Sub60（根）—— 时间与坐标（TH08 → 我们：x' = x−192、y' = 224−y、角度取反）：
---      t=0    `ins_64(90, 4, 192, 160)` 插值入场到 TH08 (192,160) = 我们 (0,64)，
---             缓动 4 = OUT_QUADRATIC。同帧的 ins_76（关移动边界）、ins_80(16)
---             （关 ALLOW_OFFSCREEN）、ins_105(0)（关射击间隔）、ins_95（清场）、
---             ins_113（弹音效）、ins_134(2160, 68)（36 秒计时）、ins_122（符卡登记）、
---             ins_155(1)（超时符卡）都由 boss 系统与 lw_before 管，不另写。
---      t=90   `ins_81(4)` 开可伤害、`ins_160(300)` 减伤计时（移植版不打伤害，跳过）；
---             `ins_64(60, 4, ENEMY_POSITION_X, −64)`：往**正上方**再插值 60 帧，
---             落点 TH08 y=−64 → 我们 y=288（场地顶端 224 再往上 64）。
---      t=150  ★ 循环体 Sub60_608 的起点（下面都按「本轮相位」记）。
---              `ins_6(li0, 4)` + `ins_7(lf6, 0.008333334)` 只在**第一次**执行 ——
---              标签 Sub60_608 就落在这两条**后面**（裸字节顺序：ins_0 / ins_6 / ins_7 /
---              标签 / ins_124），所以 t=530 的 jump 会跳过它们，li0 与 lf6 都只累积不清零。
---              `ins_7(lf7, PLAYER_POSITION_X)` 记下自机 x、
---              `ins_34(xF0, lf7, 640, ENEMY_X, ENEMY_Y)` = **从 (自机 x, 640) 指向 BOSS**
---              的角（POINT_ANGLE，EclRunLow.inl:342-357：atan2(y2−y1, x2−x1)）、
---              `ins_33/17/32/17` = lf0 = cos(xF0)×295、lf1 = sin(xF0)×295
---              （彗星头的偏移量）、`ins_94 ×4` 生成 4 个彗星头
---              （SPAWN_ENEMY_RELATIVE：落点 = 父的 position + (x,y,z) = 就在 BOSS 身上）、
---              `ins_136(10, 0)`（屏幕闪一下，纯观感，跳过）、
---              `ins_135(0, 61)` 挂上子 context 0。
---      t=210  `ins_64(60, 1, lf7, 640)`：朝 (自机 x, TH08 640) 俯冲 —— 缓动 1 =
---             IN_QUADRATIC（越来越快），落点 y=−416（场地底端 −224 再往下 192）
---             → **穿过整个场地**。
---      t=330  `ins_27(lf7, RANDOM_UNIT_FLOAT, 192)` + `ins_63(lf7, −64)`：瞬移到场上方的
---             随机 x（TH08 x ∈ [0,192] → 我们 [−192,0]，即**左半边**），y=288；
---             同帧 `ins_15(lf6, 0.0025)`。
---      t=340  和 t=150 是同一段（重读自机 x、重算瞄准角、再生成 4 个彗星头、再挂 Sub61）。
---      t=400  再俯冲一次（60 帧，落点还是 (自机 x, −416)）。
---      t=520  `ins_27` + `ins_15(lf7, 192)` → 随机 x 落在 **右半边**（我们 [0,192]）；
---             `ins_10(li0, 3)` 环上的弹数 +3（li0 与 lf6 都不复位，所以都逐轮变大）。
---      t=530  `ins_4(150, Sub60_608)` 把时间拨回 150、落点正是循环体第一条
---             → **同一帧**开始下一轮 → 一轮 = 380 帧、每轮多 3 发弹（4 → 7 → 10 …）。
---    ★ 4 个彗星头（Sub63..66）：t=0 `ins_58(22..25)` 换 ANM、`ins_159(3)` 画组、
---      `ins_77(24,24)` 判定，紧接着 `ins_80(16)`+`ins_80(3)` 把出屏宽容与判定一起关掉
---      → **不参与碰撞**（纯观感）、`ins_165(xF0)` 把立绘转到瞄准角；然后
---      lf2/lf3 = 自己位置 + 295·(cos/sin θ)、`ins_64(60, 1, lf2, lf3)` 往那里插值。
---      t≥60 子 context Sub62：**每帧**把自己钉到 `bosses[0].worldPosition + 295·(cos/sin θ)`
---      （ins_87 读 BOSS 的 worldPosition、ins_25 写自己的 position —— 读写不对称见
---       EclOperandsFloat.cpp:93-95 与 :183-185：读走 worldPosition、写落在 position）。
---      寿命：Sub63 在 t=240 终止（它多一条 t=60..180 的重复 ex 指令 25 = 旋转光柱判定，
---      本卡没有光柱 → 空转），Sub64/65/66 在 t=370 终止。4 个的 ANM 是 22/23/24/25，
---      所以是同一位置上叠的 4 层贴图（都在 BOSS 前方 295 px，也就是彗星的**前缘**）。
---    ★ 出弹（Sub61）：裸字节的时间戳只有 60/68/76，靠 `ins_5` 重置时间循环：
---        t=60 写 3 条 ins_111 + 第一发（bulletType 14 / color 1）
---        t=68 第二发（bulletType 15 / color 3）；两发之间 `ins_16(lf0, 0.1308997)`（−7.5°）
---        t=76 `ins_5(60, Sub61_160, [10036])`：counter（`ins_6([10036], 18)` 的 18）
---             先减 1，>0 就跳回 t=60 的**第一条出弹**（EclRunLow.inl:234-242）——
---             落点就在那条指令上 → **同一帧**再补一发；
---             减到 0 就不跳、落到 `ins_53`（RETURN）→ 子 context 结束。
---        ⇒ 子 context 从 time=60 起每 8 帧一发、连打 36 发（18 轮 × 2 发）。
---        ★ `ins_135` 每次都是 free 再新建（EclRunHigh.inl:646-680）→ t=340 那一次会把
---          上一次没打完的程序掐掉、从 time=0 重来。
---      ★ ins_99 = SHOOT_CIRCLE（→ aimMode 3）：angle_i = i·2π/count1 + j·angleStep
---        + args->angle（BulletManager.cpp:143-149），count2 = 1 → 速度恒为 speed1
---        （:213-217；本卡 speed1 3.0、speed2 0.9 用不上）；循环 j（速度档）在外、
---        i（方向）在内（:697-704）。本卡 count1 = li0、angle = lf0、
---        angleStep 0.049087387（count2 = 1 → 用不上）、bulletType 14/15、color 1/3、
---        transformFlags 131666。
---      ★ 弹的三条 ins_111（`ins_111(索引, kind, allowWhileActive, int0, int1, float0, float1)`；
---        BulletTransformInstructionArgs = EclRunHigh.inl:78-88，
---        payload 联合体 = BulletManager.hpp:36-127）：
---          0  CD_RELATIVE  allow=0  int0=60(interval) int1=1(repeat) f0=−999.9(angle) f1=0.0(speed)
---          1  WAIT         allow=0  int0=180(frames)
---          2  ACCEL_VECTOR allow=0  int0=200(duration) f0=lf6(magnitude) f1=−999.9(→ 用当前角)
---        transformFlags 131666 = 0x20252 = SPAWN_FAST(0x2) | ACCEL_VECTOR(0x10)
---                              | CD_RELATIVE(0x40) | PLAY_SPAWN_SOUND(0x200) | WAIT(0x20000)
---        ⇒ 弹的一生：出生动画 → 沿出弹方向线性减速到 0（60 帧）→ 把朝向改成
---          「原朝向 + 一个固定偏角」、速度 0 → 原地等 180 帧 → 沿那个朝向加速 200 帧
---          （每帧速度 += lf6，lf6 只有 0.0083333 / 0.0108333 两种值）→ 之后匀速飞出。
---        ★ CD_RELATIVE 的 f0 = −999.9 是 TH08 口径的量（原作 `angle += −999.9`，
---          UpdateRelativeDirectionChange，BulletManager.cpp:1255-1290）；
---          我们角度取反 → `angle += +999.9`。−999.9 rad ≈ −50.05°、
---          +999.9 rad ≈ +50.05°（模 2π 后不是同一个角，别顺手写错号）。
---        ★ 转向那一下 f1 = 0.0 → speed = 0（`speed > −999` 才用记录的 speed，
---          :378-380），所以那一帧弹是停着的，方向只用来给随后的 ACCEL_VECTOR 定加速方向。
---        ★ ACCEL_VECTOR 的 f1 = −999.9 < −990 → accelerationAngle = 弹当前的 angle
---          （:346-350），accelerationVector = polar(那个角, lf6)（:353-356）。
---          加速期间每帧 `velocity += vector`、再用 velocity 重算 angle（:1191-1215）。
---        ★ 出生动画长度 = `g_BulletSpriteScripts[bulletType].scripts[1]`
---          （BulletManager.cpp:299-317、:1605-1615）：bulletType 14/15 取 script24，
---          末尾 `+30: ins_1`（etama.decl）→ 出生分支跑 **31** 帧（vm.time 从 0 起算，
---          执行到 ins_1 的那一次调用才结束）。出生位置先退 velocity×4（:220-227），
---          每帧只走 velocity/2；动画结束那一帧再照常走一次整速（:966 goto activateBullet）。
---        ★ lf6 进记录是在 Sub61 的 t=60（`ins_111` 解析操作数那一刻），
---          而每次挂载都会把父 context 的变量块拷过来（EclRunHigh.inl:646-680）
---          → 记录里的 magnitude 就是**挂载那一刻**的 lf6。
---      ★ 同屏上限：弹 1536 槽（`Bullet bullets[0x601]`，BulletManager.hpp:455）。
---        波满不生、波中途生不出来就丢掉剩下的（BulletManager.cpp:685-712）。
---        本卡会把这个池打满 —— 这是原版行为，照抄，不要为了「玩得下去」降密度。
---      ★ 出屏回收（BulletManager.cpp:856-899）：`offscreenCullDelayFrames` 归零后才判；
---        还挂着转向/反弹状态的弹允许出屏 0x80 = 128 帧再回收，否则出屏即回收
---        → 俯冲途中在场地外打出的那些弹（BOSS 在 y=−416 附近时）最多活 128 帧。
---      ★ 符卡期间 rank 缩放整段被 `if (!g_Spellcard.IsActive())` 挡住
---        （EclDependencies.cpp:735-761）→ count1/speed 都不随 rank 变。
---  · 占位贴图：弹 = ball_small、彗星头 = "servant"。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
local function th08_color(c) return c + 1 end

---Sub60（根）的节拍（我们坐标）。
local ENTER_FRAMES, ENTER_Y = 90, 64        -- ins_64(90, 4, 192, 160)：TH08 y=160 → 我们 64
local BOSS_START_Y = 96                     -- 生成时的 SET_POSITION(192, 128) → 我们 96
local RISE_FRAMES, RISE_Y = 60, 288         -- ins_64(60, 4, x, −64)：TH08 y=−64 → 我们 288
local DIVE_FRAMES, DIVE_Y = 60, -416        -- ins_64(60, 1, x, 640)：TH08 y=640 → 我们 −416
local AIM_REF_Y = -416                      -- ins_34 的参考点 y（TH08 640 → 我们 −416）
local SETUP_T = 150                         -- 循环体 Sub60_608 的第一条（每条指令的 time）
local CYCLE = 380                           -- t=530 的 ins_4(150, …) → 一轮 380 帧
local PH_DIVE1, PH_WARP1 = 60, 180          -- t=210 / t=330
local PH_SETUP2, PH_DIVE2, PH_WARP2 = 190, 250, 370   -- t=340 / t=400 / t=520
local EASING_OUT_QUAD, EASING_IN_QUAD = 4, 1  -- EclEasingMode（EclManager.hpp:518-526）

---彗星头（Sub63..66 + 子 context Sub62）。
local HEAD_COUNT = 4
local HEAD_DIST = 295                       -- lf0/lf1 = cos/sin(θ) × 295
local HEAD_ANM = { 22, 23, 24, 25 }         -- `ins_58` 的操作数（Sub63..66）
local HEAD_END = { 240, 370, 370, 370 }     -- 各自的 `ins_1`（TERMINATE）时间
local HEAD_MOVE_FRAMES = 60                 -- `ins_64(60, 1, lf2, lf3)`
local HEAD_PIN_T = 60                       -- 子 context Sub62 的第一条在 time 60

---环（ins_99）与它的节拍。
local RING_START, RING_STEP = 4, 3          -- `ins_6(li0, 4)` / `ins_10(li0, 3)`
local ACCEL_START, ACCEL_STEP = 0.008333334, 0.0025  -- `ins_7(lf6, …)` / `ins_15(lf6, …)`
local GUN_START = 60                        -- Sub61 的第一条出弹（子 context 的 time）
local GUN_ROT_STEP = 0.1308997              -- `ins_16(lf0, 0.1308997)`
local GUN_ROUNDS = 18                       -- `ins_6([10036], 18)`
local GUN_SPEED = 3.0                       -- `ins_99` 的 speed1（count2 = 1 → 恒用这个）
local GUN_SPAWN_FRAMES = 31                 -- bulletType 14/15 → etama.decl script24

---弹的三条 transform 记录（Sub61 t=60 的 ins_111）。
local CD_INTERVAL, CD_REPEAT = 60, 1
local CD_ANGLE_OUR = 999.900024             -- TH08 记录里的 −999.9，我们坐标取反
local WAIT_FRAMES = 180
local ACCEL_FRAMES = 200

---同屏上限与回收（见卡头注释）。
local POOL_SIZE = 1536                      -- BulletManager.hpp:455
local OFFSCREEN_GRACE = 128                 -- BulletManager.cpp:870-890
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local SPRITE_HALF = 8                       -- 占位 ball_small 是 16×16

---本卡自己的弹池（= 原作那 1536 个弹槽）与彗星头登记表。
local pool = {}
local heads = {}

local lw215_bullet
local lw215_head

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:810-816）。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---AdvanceTransformProgram 的一次推进（BulletManager.cpp:312-478）。
---三条记录的 allowWhileActive 都是 0 → 只要有状态挂着就原地返回（:321-323）。
local function advance_program(b)
    if b.b_cd or b.b_wait or b.b_accel then
        return
    end
    if b.b_prog == 1 then
        b.b_cd = { timer = 0, interval = CD_INTERVAL, rep = CD_REPEAT, done = 0,
                   angle = CD_ANGLE_OUR, speed = 0.0 }        -- :372-388
        b.b_prog = 2
    elseif b.b_prog == 2 then
        b.b_wait = WAIT_FRAMES                                -- :414-417
        b.b_prog = 3
    elseif b.b_prog == 3 then
        b.b_accel = { timer = 0, dur = ACCEL_FRAMES }         -- :338-357
        b.b_avec_x = math.cos(b.b_angle) * b.b_mag
        b.b_avec_y = math.sin(b.b_angle) * b.b_mag
        b.b_prog = 4
    end
end

---FIRED 分支里跟速度/朝向有关的那一段：AdvanceTransformProgram + 各 Update* 状态机。
---原作每帧的固定顺序是 Deceleration→VectorAccel→PolarAccel→CD_REL→CD_ABS→CD_AIMED
---→Bounce→WrapX→WrapY→WAIT（BulletManager.cpp:831-846），本卡只用到三条。
local function fired_transform(b)
    advance_program(b)
    if b.b_accel then
        local a = b.b_accel
        if a.timer >= a.dur then
            b.b_accel = nil                                  -- :1198-1201（速度留着）
        else
            b.b_vx = b.b_vx + b.b_avec_x                     -- :1203-1204
            b.b_vy = b.b_vy + b.b_avec_y
            if math.abs(b.b_vx) > 0.0001 or math.abs(b.b_vy) > 0.0001 then
                b.b_angle = math.atan2(b.b_vy, b.b_vx)       -- :1206-1210
            end
        end
        a.timer = a.timer + 1
    end
    if b.b_cd then
        local c = b.b_cd
        if c.timer >= c.interval then
            ---走完一次：朝向 += 记录里的角、速度 = 记录里的速度（:1268-1280）。
            c.done = c.done + 1
            if c.done >= c.rep then
                b.b_cd = nil
            end
            b.b_angle = b.b_angle + c.angle
            b.b_speed = c.speed
            b.b_vx = math.cos(b.b_angle) * b.b_speed
            b.b_vy = math.sin(b.b_angle) * b.b_speed
            c.timer = 0
        else
            ---没走完：沿**当前朝向**线性减速到 0（:1281-1287）。
            local magnitude = b.b_speed - (c.timer * b.b_speed) / c.interval
            b.b_vx = math.cos(b.b_angle) * magnitude
            b.b_vy = math.sin(b.b_angle) * magnitude
        end
        c.timer = c.timer + 1
    end
    if b.b_wait then
        ---WAIT：激活那一帧 timer 就是 180，同一帧减一次，减到 0 的那一帧清位（:848-854）。
        if b.b_wait <= 0 then
            b.b_wait = nil
        else
            b.b_wait = b.b_wait - 1
        end
    end
end

---本卡的弹（bulletType 14/15，两者出生脚本都是 script24）。占位贴图 ball_small。
---  mag = 这一发所属 Sub61 context 的 lf6（= ins_111 #2 的 magnitude）。
lw215_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color, mag)
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（卡 206/209..214 同款）
        self.b_angle = angle
        self.b_speed = speed
        self.b_mag = mag
        self.b_vx = math.cos(angle) * speed
        self.b_vy = math.sin(angle) * speed
        ---SPAWN_FAST：出生瞬间位置先退 velocity×4（BulletManager.cpp:220-227）。
        self.x = x - self.b_vx * 4
        self.y = y - self.b_vy * 4
        self.vx, self.vy = self.b_vx / 2, self.b_vy / 2
        self.b_spawn = GUN_SPAWN_FRAMES
        self.b_prog = 1                     -- 出生那一刻不会跑 AdvanceTransformProgram
        self.b_cd, self.b_wait, self.b_accel = nil, nil, nil
        self.b_cull = 0                     -- 本卡没有 SET_CULL_DELAY 记录
        self.b_off = 0                      -- offscreenFrames
        self.colli = false                  -- 出生动画期间没有判定
    end,
    frame = function(self)
        ---① 出生动画（SPAWN_FAST）：每帧只走 velocity/2。
        if self.b_spawn > 0 then
            self.b_spawn = self.b_spawn - 1
            self.vx, self.vy = self.b_vx / 2, self.b_vy / 2
            bullet.frame(self)
            if self.b_spawn > 0 then
                return
            end
            ---动画播完那一帧紧接着补跑一次 FIRED 分支（`:966 goto activateBullet`），
            ---于是这一帧一共走了 velocity/2 + velocity（照抄原作的怪癖）。
            self.vx, self.vy = self.b_vx, self.b_vy
            self.colli = true
        end
        ---② FIRED：先跑 transform 程序，再按新速度位移。
        fired_transform(self)
        self.vx, self.vy = self.b_vx, self.b_vy
        bullet.frame(self)
        ---③ 出屏回收（BulletManager.cpp:856-899）。
        if self.b_cull > 0 then
            self.b_cull = self.b_cull - 1
        end
        if self.b_cull == 0 then
            if outside_field(self.x, self.y) then
                if self.b_cd then
                    ---还挂着转向状态 → 允许出屏 128 帧再回收。
                    self.b_off = self.b_off + 1
                    if self.b_off >= OFFSCREEN_GRACE then
                        object.RawDel(self)
                    end
                elseif self.b_off == 0 then
                    object.RawDel(self)
                else
                    self.b_off = self.b_off - 1
                end
            else
                self.b_off = 0
            end
        end
    end,
})

---彗星头（Sub63..66 + 子 context Sub62）。占位贴图 "servant"。
---  theta = 本轮的瞄准角（= TH08 的 xF0，我们坐标）；4 个都在 BOSS 前方 295 px。
---  end_t = 各自的 `ins_1` 时间（Sub63 是 240、其余 370）。
lw215_head = Class(object, {
    init = function(self, owner, theta, anm, end_t)
        self.x, self.y = owner.x, owner.y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.5, 0.5
        self.colli = false                  -- `ins_80(3)` 关判定 → 纯观感
        self.navi = false
        self.bound = false                  -- 会跑到场地外，不能自动回收
        self.rot = -theta * RAD             -- `ins_165(xF0)`：立绘转到瞄准角（我们取反）
        self._blend, self._a = "", 255
        self.h_boss = owner
        self.h_theta = theta
        self.h_anm = anm
        self.h_end = end_t
        self.h_t = 0
        ---`ins_25` 的两条把落点算成「自己位置 + 295·(cos/sin θ)」（t=0 时的自己位置）。
        self.h_x0, self.h_y0 = self.x, self.y
        self.h_tx = self.x + math.cos(theta) * HEAD_DIST
        self.h_ty = self.y + math.sin(theta) * HEAD_DIST
    end,
    frame = function(self)
        local t = self.h_t
        if t >= self.h_end then
            object.RawDel(self)             -- `ins_1`（TERMINATE）
            return
        end
        if t < HEAD_PIN_T then
            ---`ins_64(60, 1, lf2, lf3)`：60 帧 IN_QUADRATIC 插值（EnemyManager.cpp:90-121）。
            local u = (t + 1) / HEAD_MOVE_FRAMES
            if u > 1 then u = 1 end
            local e = u * u
            self.x = self.h_x0 + (self.h_tx - self.h_x0) * e
            self.y = self.h_y0 + (self.h_ty - self.h_y0) * e
        else
            ---子 context Sub62（每帧）：自己 position = BOSS 的 worldPosition + 295·(cos/sin θ)。
            local b = self.h_boss
            self.x = b.x + math.cos(self.h_theta) * HEAD_DIST
            self.y = b.y + math.sin(self.h_theta) * HEAD_DIST
        end
        self.h_t = t + 1
    end,
})

---一次出弹（ins_99 = SHOOT_CIRCLE）。池满 → 整波不生；波中途生不出来就丢掉剩下的
---（BulletManager.cpp:685-712）。角度 = lf0 − i·2π/count1（我们坐标取反）。
---（bulletType 14/15 的占位贴图一样，所以这里只区分颜色：TH08 的 1/3 → 我们的 2/4。）
local function ring_shot(owner, color)
    local used = pool_used()
    if used >= POOL_SIZE then
        return
    end
    local n = owner.g_count
    if n < 1 then
        n = 1
    end
    for i = 0, n - 1 do
        if used >= POOL_SIZE then
            return
        end
        pool[#pool + 1] = New(lw215_bullet, owner.x, owner.y,
                owner.g_rot - i * 2 * PI / n, GUN_SPEED, th08_color(color),
                owner.g_accel)
        used = used + 1
    end
end

---Sub61 的程序。1 起算的 pc；`t` = 那条指令的时间戳，`op` 见下面四个常量。
---  #1/#2 = t=60 的第一发 + `ins_16(lf0, 0.1308997)`
---  #3/#4 = t=68 的第二发 + `ins_16`
---  #5    = t=76 的 `ins_5(60, #1, [10036])`：counter 先减 1，>0 就跳回 #1 并把时间拨到 60
---  #6    = t=76 的 `ins_53`（RETURN → 子 context 结束；PopEclContext 会 free 掉这个块）
---（t=60 那三条 ins_111 是「一次性写记录」，效果在挂载时就固定了，不再占指令位。）
local OP_SHOOT, OP_ROT, OP_DECJMP, OP_RET = 1, 2, 3, 4
local SUB61 = {
    { t = 60, op = OP_SHOOT, color = 1 },       -- bulletType 14 / color 1
    { t = 60, op = OP_ROT },
    { t = 68, op = OP_SHOOT, color = 3 },       -- bulletType 15 / color 3
    { t = 68, op = OP_ROT },
    { t = 76, op = OP_DECJMP, target = 1 },
    { t = 76, op = OP_RET },
}

---`ins_135(0, 61)`：挂上/换掉子 context 0。每次都从 time=0 重来，
---变量块（含 li0/lf6）从父 context 整块拷过来（EclRunHigh.inl:646-680）。
local function attach_gun(owner)
    owner.g_pc = 1
    owner.g_t = 0
    owner.g_counter = GUN_ROUNDS     -- `ins_6([10036], 18)`
    owner.g_rot = 0                  -- `ins_7([10016], 0.0)`（我们坐标的 lf0）
    owner.g_count = owner.lw215_ring -- li0（环上的弹数）
    owner.g_accel = owner.lw215_accel -- lf6（后来进 ins_111 #2 的 magnitude）
end

---子 context 0 每帧的步进。解释器只在 `time == 指令的 time` 时执行、帧末才 time++
---（EclRun.cpp:44-110）；跳转落点就跟在循环体第一条上 → 同一帧会继续往下跑。
local function gun_frame(owner)
    if owner.g_t == nil then
        return
    end
    local time = owner.g_t
    while true do
        local ins = SUB61[owner.g_pc]
        if ins == nil or ins.t ~= time then
            break
        end
        if ins.op == OP_SHOOT then
            ring_shot(owner, ins.color)
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == OP_ROT then
            owner.g_rot = owner.g_rot + GUN_ROT_STEP
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == OP_DECJMP then
            owner.g_counter = owner.g_counter - 1
            if owner.g_counter <= 0 then
                owner.g_pc = owner.g_pc + 1        -- <=0 不跳，落到 `ins_53`
            else
                time = GUN_START                   -- `ins_5` 的第一个操作数 = 60
                owner.g_pc = ins.target
            end
        else
            owner.g_t = nil                        -- `ins_53` RETURN
            return
        end
    end
    owner.g_t = time + 1
end

---t=150 / t=340 那一段：记下自机 x、算瞄准角、生成 4 个彗星头、挂上/换掉子 context 0。
local function setup_dive(owner)
    local ax = player.x                     -- `ins_7(lf7, PLAYER_POSITION_X)`
    ---`ins_34(lf0, lf7, 640, ENEMY_X, ENEMY_Y)`：从 (自机 x, TH08 640) 指向 BOSS 的角。
    ---我们坐标里参考点就是 (自机 x, −416)，角度取反 → 直接用我们的 y 算。
    local theta = math.atan2(owner.y - AIM_REF_Y, owner.x - ax)
    owner.lw215_aimx = ax                   -- lf7：t=210/t=400 那条 ins_64 的落点 x
    for k = 1, HEAD_COUNT do
        heads[#heads + 1] = New(lw215_head, owner, theta, HEAD_ANM[k], HEAD_END[k])
    end
    attach_gun(owner)
end

---t=210 / t=400 的俯冲：`ins_64(60, 1, lf7, 640)`。
local function dive(owner)
    owner.lw215_move = { x0 = owner.x, y0 = owner.y,
                         dx = owner.lw215_aimx - owner.x, dy = DIVE_Y - owner.y,
                         n = DIVE_FRAMES, t = 0, easing = EASING_IN_QUAD }
end

---t=330 / t=520 的瞬移：`ins_63(lf7, −64)`（TH08 y=−64 → 我们 288）。
local function warp(owner, x)
    owner.x, owner.y = x, RISE_Y
    owner.lw215_aimx = x
    owner.lw215_move = nil
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then
        u = 1
    end
    local e = u
    if move.easing == EASING_OUT_QUAD then
        e = 1 - (1 - u) * (1 - u)
    elseif move.easing == EASING_IN_QUAD then
        e = u * u
    end
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---BOSS 每帧。原作顺序：RunEcl（主 context → 子 context）→ ClampPosition →
---IntegrateVelocity → ClampPosition（EnemyManagerUpdate.cpp:157-181）。
---本卡 t=0 的 `ins_76` 关掉了移动边界、也从来没 `ins_75` → 不夹框。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw215_t 还是 nil（卡 205..214 同款守卫）。
    if owner.lw215_t == nil then
        return
    end
    local t = owner.lw215_t
    if t == ENTER_FRAMES then
        ---t=90：`ins_64(60, 4, ENEMY_POSITION_X, −64)`（往正上方再飞 60 帧）。
        owner.lw215_move = { x0 = owner.x, y0 = owner.y, dx = 0, dy = RISE_Y - owner.y,
                             n = RISE_FRAMES, t = 0, easing = EASING_OUT_QUAD }
    end
    ---★ `ins_6(li0, 4)` / `ins_7(lf6, 0.008333334)` 在 t=150 那段里、但**标签
    ---Sub60_608 在它们后面**（裸字节：ins_0 / ins_6 / ins_7 三条在标签之前）
    ---→ t=530 的 jump 跳过这两条 → li0 与 lf6 只在第一次执行，之后靠 +3 / +0.0025 累积。
    if t == SETUP_T then
        owner.lw215_ring = RING_START
        owner.lw215_accel = ACCEL_START
    end
    if t >= SETUP_T then
        local u = (t - SETUP_T) % CYCLE     -- 本轮相位（t=530 的 jump 落回 t=150）
        if u == 0 then
            setup_dive(owner)
        elseif u == PH_DIVE1 then
            dive(owner)
        elseif u == PH_WARP1 then
            owner.lw215_accel = owner.lw215_accel + ACCEL_STEP   -- `ins_15(lf6, 0.0025)`
            warp(owner, ran:Float(0, 1) * 192)                   -- `ins_27` + `ins_63`
        elseif u == PH_SETUP2 then
            setup_dive(owner)
        elseif u == PH_DIVE2 then
            dive(owner)
        elseif u == PH_WARP2 then
            owner.lw215_accel = owner.lw215_accel + ACCEL_STEP
            owner.lw215_ring = owner.lw215_ring + RING_STEP      -- `ins_10(li0, 3)`
            warp(owner, ran:Float(0, 1) * 192 + 192)             -- `ins_15(lf7, 192)`
        end
    end
    ---子 context 0（Sub61）的出弹节拍。
    gun_frame(owner)
    ---位移（RunEcl 之后）。
    local mv = owner.lw215_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw215_move = nil
        end
    end
    owner.lw215_t = t + 1
end

local function card_init(owner)
    owner.lw215_t = 0
    owner.lw215_ring = RING_START
    owner.lw215_accel = ACCEL_START
    ---★ 落位：生成助手（这个文件里没有独立的助手子程序，BOSS 由关卡脚本直接建）
    ---  的 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)；下面是入场的 ins_64 到 ENTER_Y。
    owner.x, owner.y = 0, BOSS_START_Y
    owner.lw215_aimx = owner.x
    owner.g_t = nil
    ---`ins_64(90, 4, 192, 160)`：从 (0,96) 插值到我们 (0,64)（缓动 4 = OUT_QUADRATIC）。
    owner.lw215_move = { x0 = owner.x, y0 = owner.y,
                         dx = 0 - owner.x, dy = ENTER_Y - owner.y,
                         n = ENTER_FRAMES, t = 0, easing = EASING_OUT_QUAD }
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw215_t = nil
    owner.lw215_move = nil
    owner.g_t = nil
    for i = #heads, 1, -1 do
        if IsValid(heads[i]) then
            object.RawDel(heads[i])
        end
        heads[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[215] = {
    init = function(owner)
        pool = {}
        heads = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---卡 216「紧缩世界」（十六夜咲夜）
---  ecldata_sk.ecl：Sub1 = BOSS 根、Sub2 = BOSS 的子 context 0（出弹节拍）、
---  Sub5 = Sub1 用 `ins_52(5)` 调的一次性子程序（只生成观感特效，跳过）、
---  Sub3 = 「被标记的弹」原地变成的敌机、Sub4 = Sub3 在 t=0 再生的同伴。
---
---  内容：咲夜在自己的符卡里**把时间定住**。BOSS 每 270 帧一轮：先挂上子 context
---  打一轮扇形弹（每发弹飞出去 60 帧减速停住、再朝侧向折 90° 匀速飞出），
---  然后在第 150 帧**冻结整个世界 100 帧**（弹不位移、自机完全不能动），
---  冻结开始的那一帧把场上所有「带标记的弹」原地变成隐形敌机（Sub3/Sub4）——
---  它们沿弹的角度飞出、每 3 帧吐一发 5.5 px/帧 的弹；解冻那一刻，冻住的弹与
---  敌机吐出的弹一起开始动。同一帧 BOSS 再朝自机打一发扇形，弹数一轮比一轮多
---  （5、6、7……）。
---
---  · Sub1（根）—— 时间与坐标（TH08 → 我们：x' = x − 192、y' = 224 − y、角度取反）：
---      t=0    `ins_64(110, 4, 192, 128)` 入场插值到 TH08 (192,128) = 我们 (0,96)
---             （缓动 4 = OUT_QUADRATIC）；同帧 `ins_75(32, 64, 352, 128)` 设移动边界
---             （TH08 x∈[32,352] → 我们 [−160,160]、y∈[64,128] → 我们 [96,160]），
---             这条**同时打开 CLAMP_POSITION**（EclRunLow.inl:623-635）→ 入场途中
---             BOSS 就被夹在框里（原作也是这么怪的：入场前 70 帧贴在 y=160 上）；
---             `ins_6([10039], 0)`（扇形弹数计数器归零）。其余（关射击间隔、清场、
---             关可伤害、关弹音效、`ins_134(5940, 7)` 计时、`ins_122` 符卡登记）
---             由 boss 系统与 lw_before 管，不另写。
---      t=110  `ins_81(4)` 开可伤害、`ins_160(120)` 减伤计时（移植版不打伤害，跳过）、
---             `ins_6([10039], 5)` 扇形弹数 = 5。★ **标签 Sub1_504 落在这三条后面**
---             （裸字节：ins_81 / ins_160 / ins_6 / 标签 / ins_135）→ t=380 的 jump
---             跳过 ins_6 → 弹数只累积、不清零。
---      t=110（标签）`ins_135(0, 2)` 挂上子 context 0（Sub2，从 time=0 重来）、
---             `ins_124(5)` 音效、`ins_52(5)` 调 Sub5（30 帧 `ins_139(17, 4, −1)` 特效，跳过）。
---      t=200  `ins_67(60, 4, 1.0)` = MOVE_RANDOM_IN_BOUNDS：按「边界感知」的随机方向
---             漂 60 px（60 帧、缓动 4）。
---      t=260  ★ `ins_136(26, 1)`（ECL-Ex 26 = SetScriptedUpdateFreeze，EclGlobals.cpp:90、
---             EclExIns.cpp:815-830）**冻结世界**；`ins_6([10038], 3)` 写「子程序号」寄存器；
---             `ins_136(27, 0)`（Ex 27 = SpawnEnemiesFromMarkedBullets，EclExIns.cpp:835-855）
---             扫**全 1536 个弹槽**，凡是 transformFlags 带 0x100000 的弹 → 在弹的位置生成
---             一个跑 Sub3 的敌机（life 800、item −2、score 10，变量块整块拷过去），
---             并清掉那一位置位（同一发弹只转化一次）；
---             `ins_67(120, 4, 1.0)` 漂 120 px、`ins_124(33)` 音效、`ins_135(0, −1)` 卸子 context。
---      t=360  `ins_136(26, 0)` 解冻；`ins_96(20, 6, [10039], 2, 0.8, 0.4, 0, 0.19634955, 514)`
---             = SHOOT_FAN_AIMED：朝自机打 count1 = 计数器、两档速度（0.8 / 0.6）的扇形，
---             每 11.25° 一发；`ins_30([10039])` 计数器 +1。
---      t=380  `ins_4(110, Sub1_504)` 拨回标签 → **一轮 270 帧**（jump 的落点就是标签，
---             所以拨回去那一帧只跳过 ins_6，其余照跑）。
---    ★ 冻结只挡三件事：弹的位移（BulletManager.cpp:858-860）、自机整个 OnUpdate
---      （Player.cpp:1027-1038：位置、射击、碰撞判定都不更新）、Gui 与符卡计时
---      （Gui.cpp:98-100、Spellcard.cpp:1279）。**敌机的 ECL 与位移照常**
---      （EnemyManagerUpdate 只在 :663-665 挡了 bossTimer）→ 隐形发射源在冻结期照飞照打；
---      同一帧的顺序是 Player(9) → EnemyManager(11) → BulletManager(14)（Global.hpp:52-68）
---      → 所以 t=260 设下的冻结**当帧就挡住弹**、自机晚一帧（移植版按「同一帧」处理）。
---    ★ 冻结期弹不位移，但 **transform 状态机照跑**（:820-856 在 :858 之前）→ 转向照发生。
---  · Sub2（子 context 0；父在 cycle 相位 150 卸掉它 → 一共只活 150 帧）：
---      time 0  `ins_7(lf0, 0.0)`、`ins_6([10036], 15)`、
---              `ins_111(0, 64, 0, 60, 1, +π/2, 2.5)` 写 0 号弹变换记录（kind 0x40 =
---              CHANGE_DIRECTION_RELATIVE、interval 60、rep 1、+90°、速度 2.5）。
---      循环 A  15 帧、每帧一发 `ins_97`：bulletType 20、color 3、1 发、速度 2.5、
---              角度 = lf0、transformFlags 0x100242；随后 `ins_15(lf0, 0.44879895)`
---              （= 2π/14，15 发正好绕一圈）、`ins_37` 归一化。
---      time 1  `ins_5(0, Sub2_80, [10036])`：counter 先减 1、>0 就跳回循环 A 并把时间拨到 0
---              → **每帧一发**（跳转落点在循环体第一条上，同一帧继续往下跑，
---              EclRunLow.inl:242-243；落点是 ins_97 不是 ins_6 → counter 不复位）。
---      之后    `ins_7(lf0, π)`、counter = 15、`ins_111(…, −π/2, 2.5)` → 循环 B 反着转。
---      time 2  counter = 50；循环 C：`ins_96(20, 3, 1, 1, 3.0, 1.0, 0, 0.3926991, 0x100202)`
---              = 朝自机 1 发、速度 3；`ins_5(2, Sub2_388, [10036])` 在 **time 10**
---              → 每 8 帧一发。
---    ★ 记录语义（BulletManager.cpp:372-388 激活、:1255-1295 每帧）：timer 还没到 interval
---      时速度沿当前朝向线性衰减到 0；timer 走到 interval 那一帧角度 += 90°、速度 = 2.5、
---      并把激活位清掉（rep 1）。所以每发弹先飞 60 帧减速停住、再朝侧向折 90° 匀速飞出。
---      ★ 出生动画那 31 帧里**记录计时器不动**（那段是 SPAWNING_FAST 分支，
---      :955-975，根本不进 FIRED）→ 60 帧的减速是从出生动画结束才开始算的。
---  · Sub3 / Sub4（被标记的弹变成的隐形发射源）：`ins_80(8)` = 打上 NO_SPRITE →
---    **不画**（EclRunLow.inl:672-687；ECL_INTERACTION_NO_SPRITE = 1<<3，EclManager.hpp:511）。
---    移植版按「不可见 → 不建对象，用卡片自己的表步进」处理（它们的唯一可观效果是弹流）。
---      Sub3 t=0  `ins_94(4, 0, 0, 0, 1000, −2, 80)` = SPAWN_ENEMY_RELATIVE：在自己位置上
---                再生一个跑 Sub4 的同伴；`ins_80(8)`、`ins_65(lf0, 4.1)`（朝向 = 源弹角度、
---                速度 4.1）、`ins_71(0.0666667)`（加速度）、`ins_82(0)`。
---      Sub4 t=0  `ins_25(lf1, lf0, π)`（lf1 = lf0 + π）、`ins_37` 归一化、`ins_65(lf1, 4.1)`、
---                `ins_71`、`ins_82` → **朝相反方向**飞。
---      两者     t=10 `ins_6([10036], 20)`、`ins_97(20, 1, 1, 1, 5.5, 1.0, lf0, 0.3926991, 512)`：
---                每 3 帧一发、速度 5.5、方向 = 源弹角度，flags 只有 PLAY_SPAWN_SOUND
---                → **没有出生动画**、也没有记录；t=13 的 `ins_5(10, …, [10036])` 循环
---                20 次（落点是 ins_97，counter 不复位 → 正好 20 发），然后 `ins_1` TERMINATE。
---      ★ 位移按 POLAR：每帧 speed += 加速度、velocity = (cos, sin)(朝向)·speed、
---        position += velocity（EnemyManager.cpp:63-78、:936-946）→ 逆时针/顺时针的两条
---        弹流是从**移动中的发射点**拉出来的斜线。
---  · 同屏上限：全游戏共用 1536 个弹槽（`Bullet bullets[0x601]`，BulletManager.hpp:455）；
---    波满整波不生、波中途生不出来就丢掉剩下的（BulletManager.cpp:685-712）。
---    本卡会把这个池打满 —— 这是原版行为，照抄。
---  · 出生动画：bulletType 20 的出生脚本是 etama 的 script24（末条 ins_1 在 time 30）→
---    实际跑 31 帧；出生瞬间位置先退 velocity×4，之后每帧走 velocity/2，跑完那一帧
---    再补一次整速（BulletManager.cpp:219-243、:955-975）→ 一共 31 次 velocity/2 + 1 次整速。
---  · 出屏回收（BulletManager.cpp:856-899）：`offscreenCullDelayFrames` 归零后才判；
---    还挂着转向状态的弹允许出屏 0x80 = 128 帧再回收，否则出屏即回收。
---  · 占位贴图：弹 = ball_small。Sub3/Sub4 不可见，不建对象。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
local function th08_color(c) return c + 1 end

---TH08 → 我们：x' = x − 192、y' = 224 − y（卡头注释）。ins_67 的边界判据要按
---TH08 口径比（原作是拿 enemy->position 直接跟 movementBounds 比的）。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1257）：折进 [−π, π]。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then
        a = a - 2 * PI
    elseif a < -PI then
        a = a + 2 * PI
    end
    return a
end

---Sub1（根）的节拍。括号里的 t 是 TH08 的时间戳。
local ENTER_FRAMES, ENTER_Y = 110, 96        -- ins_64(110, 4, 192, 128) → 我们 (0,96)
local CYCLE_START = 110                      -- 标签 Sub1_504
local DRIFT1_T, DRIFT1_FRAMES = 200, 60      -- ins_67(60, 4, 1.0)
local FREEZE_T, UNFREEZE_T = 260, 360        -- ins_136(26, 1) / ins_136(26, 0)
local DRIFT2_T, DRIFT2_FRAMES = 260, 120     -- ins_67(120, 4, 1.0)
local JUMP_T = 380                           -- ins_4(110, Sub1_504)
local CYCLE = JUMP_T - CYCLE_START           -- 270
local FAN_T = 360                            -- ins_96(...)
local FAN_COUNT_START = 5                    -- ins_6([10039], 5)
local FAN_COUNT2 = 2                         -- ins_96 的 count2
local FAN_SPEED1, FAN_SPEED2 = 0.8, 0.4
local FAN_STEP = 0.19634955                  -- 11.25°
local FAN_COLOR = 6
local FREEZE_FRAMES = UNFREEZE_T - FREEZE_T  -- 100
local EASING_OUT_QUAD = 4
local WANDER_SPEED = 1.0                     -- ins_67 的第三个操作数
local BOUND_LO_X, BOUND_HI_X = 32.0, 352.0   -- ins_75 的四个操作数（TH08 口径）
local BOUND_LO_Y, BOUND_HI_Y = 64.0, 128.0
local OUR_LO_X, OUR_HI_X = -160, 160         -- 上面两个换到我们坐标
local OUR_LO_Y, OUR_HI_Y = 96, 160
local SPAWN_FRAMES_20 = 31                   -- bulletType 20 → etama script24（30 帧）→ 跑 31 帧

---Sub2（子 context 0）的节拍。
local S2_FAN_COUNT = 15                      -- ins_6([10036], 15)
local S2_FAN_STEP = 0.44879895               -- ins_15 / ins_16 的 0.44879895（= 2π/14）
local S2_FAN_SPEED = 2.5                     -- ins_97 的 speed1（count2 = 1 → 恒用这个）
local S2_FAN_COLOR = 3
local S2_CD_ANGLE = PI / 2                   -- ins_111 的 float0（循环 B 是 −π/2）
local S2_CD_INTERVAL, S2_CD_REPEAT = 60, 1
local S2_CD_SPEED = 2.5
local S2_AIM_COUNT = 50                      -- ins_6([10036], 50)
local S2_AIM_SPEED = 3.0
local S2_AIM_COLOR = 3
local S2_KILL_T = FREEZE_T - CYCLE_START     -- 父在 cycle 相位 150 卸子 context

---Sub3 / Sub4（隐形发射源）。
local KNIFE_SPEED = 4.1                      -- ins_65 的第二个操作数
local KNIFE_ACCEL = 0.06666667               -- ins_71
local KNIFE_SHOT_COUNT = 20                  -- ins_6([10036], 20)
local KNIFE_SHOT_T, KNIFE_LOOP_T = 10, 13    -- ins_97 在 t=10、ins_5 在 t=13（3 帧一发）
local KNIFE_BULLET_SPEED = 5.5               -- ins_97 的 speed1
local KNIFE_BULLET_COLOR = 1                 -- ins_97 的 color
local KNIFE_BULLET_STEP = 0.3926991          -- ins_97 的 angleStep（count1 = 1 → 用不上）

---同屏上限与回收（见卡头注释）。
local POOL_SIZE = 1536                       -- BulletManager.hpp:455
local OFFSCREEN_GRACE = 128                  -- BulletManager.cpp:870-890
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local SPRITE_HALF = 8                        -- 占位 ball_small 是 16×16

---本卡自己的弹池（= 原作那 1536 个弹槽）与隐形发射源登记表。
local pool = {}
local knives = {}

---冻结计时（原作 `scriptedUpdateFreeze`，EclExIns.cpp:815-830）。
local freeze_left = 0

local lw216_bullet

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:810-816）。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---一次 SHOOT_FAN / SHOOT_FAN_AIMED（BulletManager.cpp:685-712 的双层循环 +
---:118-136 的速度、角度分支）。角度整波只算一次自机角（:690-691）。
---cd 非空 = 这发弹带着 Sub2 的 0 号记录（CHANGE_DIRECTION_RELATIVE）。
local function fan_shot(x, y, count1, count2, s1, s2, angle, step, aimed,
                        color, spawn_frames, cd, mark)
    if count1 <= 0 then
        return
    end
    local used = pool_used()
    if used >= POOL_SIZE then
        return                               -- 波满整波不生（:685-687）
    end
    local base = angle
    if aimed then
        base = base + math.atan2(player.y - y, player.x - x)
    end
    for j = 0, count2 - 1 do
        local speed = s1
        if count2 > 1 then
            speed = s1 - (s1 - s2) * j / count2
        end
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then
                return                       -- 波中途生不出来 → 丢掉剩下的（:689-697）
            end
            local off
            if count1 % 2 == 1 then
                off = math.floor((i + 1) / 2) * step
            else
                off = math.floor(i / 2) * step + step * 0.5
            end
            if i % 2 == 1 then
                off = -off
            end
            pool[#pool + 1] = New(lw216_bullet, x, y, base + off, speed,
                    th08_color(color), spawn_frames, cd, mark)
            used = used + 1
        end
    end
end

---CHANGE_DIRECTION_RELATIVE 的每帧一步（Bullet.cpp::UpdateRelativeDirectionChange，
---BulletManager.cpp:1255-1295）。
local function fired_transform(b)
    local c = b.b_cd
    if c == nil then
        return
    end
    local magnitude
    if c.timer >= c.interval then
        ---走完一次：角度 += 记录里的偏角、速度 = 记录里的速度（:1259-1279）。
        c.done = c.done + 1
        if c.done >= c.rep then
            b.b_cd = nil
        end
        b.b_angle = add_norm(b.b_angle + c.angle)
        b.b_speed = c.speed
        magnitude = b.b_speed
        c.timer = 0
    else
        ---没走完：速度沿**当前朝向**线性衰减到 0（:1283-1286）。
        magnitude = b.b_speed - (c.timer * b.b_speed) / c.interval
    end
    b.b_vx = math.cos(b.b_angle) * magnitude
    b.b_vy = math.sin(b.b_angle) * magnitude
    c.timer = c.timer + 1
end

---本卡的弹（bulletType 20）。占位贴图 ball_small。
lw216_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color, spawn_frames, cd, mark)
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                   -- 出屏回收自己判（卡 206/209/210/211/212/213 同款）
        self.b_angle = angle
        self.b_speed = speed
        self.b_vx = math.cos(angle) * speed
        self.b_vy = math.sin(angle) * speed
        ---SPAWN_FAST：出生瞬间位置先退 velocity·4（BulletManager.cpp:219-227）。
        self.x = x - self.b_vx * 4
        self.y = y - self.b_vy * 4
        self.vx, self.vy = self.b_vx / 2, self.b_vy / 2
        self.b_spawn = spawn_frames
        self.b_mark = mark                   -- transformFlags 带 0x100000（可被 ins_136(27) 转化）
        self.b_off = 0                       -- offscreenFrames
        self.colli = spawn_frames <= 0       -- 出生动画期间没有判定
        if cd then
            ---记录在**出弹那一刻**就激活（SpawnSingleBullet 末尾会调一次
            ---AdvanceTransformProgram，:247-250）：状态从这里起算。
            self.b_cd = { timer = 0, interval = cd.interval, rep = cd.rep,
                          done = 0, angle = cd.angle, speed = cd.speed }
        end
    end,
    frame = function(self)
        ---① 出生动画：这一段原作**不看** scriptedUpdateFreeze（BulletManager.cpp:955-975）。
        if self.b_spawn > 0 then
            self.b_spawn = self.b_spawn - 1
            if self.b_spawn > 0 then
                bullet.frame(self)
                return
            end
            ---跑完那一帧紧接着补跑一次 FIRED 分支（`:966 goto activateBullet`）。
            self.vx, self.vy = self.b_vx, self.b_vy
            self.colli = true
        end
        ---② FIRED：先跑 transform 状态机（冻结期也照跑），再按新速度位移。
        fired_transform(self)
        self.vx, self.vy = self.b_vx, self.b_vy
        ---③ 冻结期弹不位移（BulletManager.cpp:858-860）。
        if freeze_left > 0 then
            self.vx, self.vy = 0, 0
        end
        bullet.frame(self)
        ---④ 出屏回收（BulletManager.cpp:856-899）。
        if outside_field(self.x, self.y) then
            if self.b_cd then
                ---还挂着转向状态 → 允许出屏 128 帧再回收。
                self.b_off = self.b_off + 1
                if self.b_off >= OFFSCREEN_GRACE then
                    object.RawDel(self)
                end
            elseif self.b_off == 0 then
                object.RawDel(self)
            else
                self.b_off = self.b_off - 1
            end
        else
            self.b_off = 0
        end
    end,
})

---Sub2 的程序。1 起算的 pc；`t` = 那条指令的时间戳。
---  #3  = t=1  `ins_5(0, Sub2_80, [10036])`   ← 跳回 #1（落点是 ins_97）
---  #6  = t=1  循环 B 的第一发（`ins_7(lf0, π)` / counter=15 / 换记录 都在它前面）
---  #9  = t=2  `ins_5(1, Sub2_264, [10036])`  ← 跳回 #7
---  #12 = t=10 `ins_5(2, Sub2_388, [10036])`  ← 跳回 #11
---  #13 = t=10 `ins_53`（RETURN → 子 context 结束）
local S2_SHOT, S2_ROT, S2_SETPI, S2_SETN, S2_REC, S2_DEC, S2_AIM, S2_RET =
        1, 2, 3, 4, 5, 6, 7, 8
local S2_PROG = {
    { t = 0,  op = S2_SHOT },                          -- 循环 A 第一发（角度 = lf0）
    { t = 0,  op = S2_ROT, delta = S2_FAN_STEP },      -- `ins_15(lf0, 0.44879895)` + `ins_37`
    { t = 1,  op = S2_DEC, target = 1, time = 0 },     -- `ins_5(0, Sub2_80, [10036])`
    { t = 1,  op = S2_SETPI },                         -- `ins_7(lf0, π)`
    { t = 1,  op = S2_SETN, n = S2_FAN_COUNT },        -- `ins_6([10036], 15)`
    { t = 1,  op = S2_REC, angle = S2_CD_ANGLE },      -- `ins_111(…, −π/2, 2.5)` → 我们 +π/2
    { t = 1,  op = S2_SHOT },                          -- 循环 B 第一发
    { t = 1,  op = S2_ROT, delta = -S2_FAN_STEP },     -- `ins_16(lf0, 0.44879895)` + `ins_37`
    { t = 2,  op = S2_DEC, target = 7, time = 1 },     -- `ins_5(1, Sub2_264, [10036])`
    { t = 2,  op = S2_SETN, n = S2_AIM_COUNT },        -- `ins_6([10036], 50)`
    { t = 2,  op = S2_AIM },                           -- 循环 C 第一发（朝自机）
    { t = 10, op = S2_DEC, target = 11, time = 2 },    -- `ins_5(2, Sub2_388, [10036])`
    { t = 10, op = S2_RET },                           -- `ins_53`
}

---`ins_135(0, 2)`：挂上/换掉子 context 0。每次都从 time=0 重来，变量块（含 lf0/li0）
---从父 context 整块拷过来（EclRunHigh.inl:646-680）。
local function attach_s2(owner)
    owner.g_pc = 1
    owner.g_t = 0
    owner.g_lf0 = 0.0                     -- `ins_7(lf0, 0.0)`
    owner.g_n = S2_FAN_COUNT              -- `ins_6([10036], 15)`
    ---★ 记录里的角度原作是 TH08 口径（+π/2 = 屏幕上的顺时针 90°）→ 存**我们的口径**
    ---（取反），出弹时直接进 velocity。
    owner.g_cd_angle = -S2_CD_ANGLE       -- `ins_111(0, 64, 0, 60, 1, +π/2, 2.5)`
end

---子 context 0 每帧的步进。解释器只在 `time == 指令的 time` 时执行、帧末才 time++
---（EclRun.cpp:44-110）；跳转落点就跟在循环体第一条上 → 同一帧会继续往下跑。
local function s2_frame(owner)
    if owner.g_t == nil then
        return
    end
    local time = owner.g_t
    while true do
        local ins = S2_PROG[owner.g_pc]
        if ins == nil or ins.t ~= time then
            break
        end
        if ins.op == S2_SHOT then
            ---`ins_97(20, 3, 1, 1, 2.5, 1.0, lf0, 0.3926991, 0x100242)`。
            ---★ lf0 是 TH08 口径 → 出弹时取反（我们坐标 y 朝上）。
            fan_shot(owner.x, owner.y, 1, 1, S2_FAN_SPEED, S2_FAN_SPEED,
                    -owner.g_lf0, 0, false, S2_FAN_COLOR, SPAWN_FRAMES_20,
                    { interval = S2_CD_INTERVAL, rep = S2_CD_REPEAT,
                      angle = owner.g_cd_angle, speed = S2_CD_SPEED }, true)
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == S2_ROT then
            owner.g_lf0 = add_norm(owner.g_lf0 + ins.delta)
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == S2_SETPI then
            owner.g_lf0 = PI
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == S2_SETN then
            owner.g_n = ins.n
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == S2_REC then
            owner.g_cd_angle = ins.angle
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == S2_AIM then
            ---`ins_96(20, 3, 1, 1, 3.0, 1.0, 0, 0.3926991, 0x100202)`：朝自机 1 发。
            fan_shot(owner.x, owner.y, 1, 1, S2_AIM_SPEED, S2_AIM_SPEED,
                    0, 0, true, S2_AIM_COLOR, SPAWN_FRAMES_20, nil, true)
            owner.g_pc = owner.g_pc + 1
        elseif ins.op == S2_DEC then
            owner.g_n = owner.g_n - 1
            if owner.g_n <= 0 then
                owner.g_pc = owner.g_pc + 1
            else
                time = ins.time                -- `ins_5` 的第一个操作数
                owner.g_pc = ins.target
            end
        else
            owner.g_t = nil                    -- `ins_53` RETURN
            return
        end
    end
    owner.g_t = time + 1
end

---`ins_136(27, 0)`：把场上所有带标记的弹就地变成隐形发射源。
---原作扫的是全 1536 个弹槽、判据 `transformFlags & 0x100000`（EclExIns.cpp:841-854）；
---移植版扫本卡池里还带着标记位的弹（等价）。lf0 = **转化那一刻**弹的角度
---（:847 把 bullet->angle 写进 floatVariables[0]，SpawnEnemy2 再把变量块整块拷给新敌机，
---:68-73）→ 发射源的朝向与出弹方向都用它。
local function spawn_knives()
    local n = pool_used()
    for i = 1, n do
        local b = pool[i]
        if IsValid(b) and b.b_mark then
            b.b_mark = false                  -- 清位：同一发弹只转化一次（:852）
            local ang = b.b_angle
            ---Sub3：朝源弹角度飞；t=0 的 `ins_94` 立刻再生一个朝 lf0+π 的 Sub4。
            knives[#knives + 1] = { x = b.x, y = b.y, dir = ang, ang = ang,
                                    speed = KNIFE_SPEED, t = 0, pc = 1, n = 0 }
            knives[#knives + 1] = { x = b.x, y = b.y, dir = add_norm(ang + PI), ang = ang,
                                    speed = KNIFE_SPEED, t = 0, pc = 1, n = 0 }
        end
    end
end

---Sub3/Sub4 的程序（两者只有初始朝向不同）。
---  #1 = t=10 `ins_6([10036], 20)`；#2 = t=10 `ins_97`（落点是 #2，counter 不复位）；
---  #3 = t=13 `ins_5(10, …, [10036])`；#4 = t=13 `ins_1` TERMINATE。
local K_SET, K_SHOT, K_DEC, K_RET = 1, 2, 3, 4
local K_PROG = {
    { t = KNIFE_SHOT_T, op = K_SET, n = KNIFE_SHOT_COUNT },
    { t = KNIFE_SHOT_T, op = K_SHOT },
    { t = KNIFE_LOOP_T, op = K_DEC, target = 2, time = KNIFE_SHOT_T },
    { t = KNIFE_LOOP_T, op = K_RET },
}

---一个发射源每帧：RunEcl → POLAR 位移（EnemyManager.cpp:63-78、:936-946）。
local function knife_step(k)
    local time = k.t
    while true do
        local ins = K_PROG[k.pc]
        if ins == nil or ins.t ~= time then
            break
        end
        if ins.op == K_SET then
            k.n = ins.n
            k.pc = k.pc + 1
        elseif ins.op == K_SHOT then
            ---`ins_97(20, 1, 1, 1, 5.5, 1.0, lf0, 0.3926991, 512)`：没有出生动画、没有记录。
            fan_shot(k.x, k.y, 1, 1, KNIFE_BULLET_SPEED, KNIFE_BULLET_SPEED,
                    k.ang, KNIFE_BULLET_STEP, false, KNIFE_BULLET_COLOR, 0, nil, false)
            k.pc = k.pc + 1
        elseif ins.op == K_DEC then
            ---`ins_5(10, …, [10036])`：counter 先减 1、>0 就跳回 ins_97 并把时间拨到 10
            ---→ **同一帧**继续跑完循环体（EclRunLow.inl:242-243），所以是「一跳就补一发」。
            k.n = k.n - 1
            if k.n <= 0 then
                k.pc = k.pc + 1
            else
                time = ins.time
                k.pc = ins.target
            end
        else
            k.done = true                      -- `ins_1` TERMINATE
            return
        end
    end
    k.t = time + 1
    ---speed += 加速度（EnemyManager.cpp:68）、position += velocity（:936-946）。
    k.speed = k.speed + KNIFE_ACCEL
    k.x = k.x + math.cos(k.dir) * k.speed
    k.y = k.y + math.sin(k.dir) * k.speed
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）。
---抽角度 + 四条边界修正（本卡 t=0 的 ins_75 真的设了边界，所以四条判据都按 32/352/64/128 算）。
---其中「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle`
---（用的是**上一段的移动方向**，不是刚抽到的 angle）—— 原作自己的怪癖，照抄。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        ---★ 这一支过了 AddNormalizeAngle(..., 0)：rnd(π/2) + 3π/4 ∈ [3π/4, 5π/4]，
        ---超过 π 的那一半会折成负数（下面的判据都是按归一化后的值比的）。
        angle = ran:Float(0, PI / 2) + 2.3561945
        if angle > PI then
            angle = angle - 2 * PI
        end
    else
        angle = ran:Float(0, PI / 2) - 0.78539819
    end
    if bx < BOUND_LO_X + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > BOUND_HI_X - 96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.lw216_mangle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BOUND_LO_Y + 48 and angle < 0 then
        angle = -angle
    end
    if by > BOUND_HI_Y - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---StartTimedPolarDisplacement（EclDependencies.cpp:104-126）：delta = polar(角, 速度×时长)、
---origin = 当前 worldPosition、时长 60/120、缓动 4。
local function begin_wander(owner, frames)
    local angle = wander_angle(owner)
    owner.lw216_mangle = angle             -- 下一段 ins_67 的怪癖要用它（TH08 口径）
    owner.lw216_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * frames,
        dy = math.sin(-angle) * WANDER_SPEED * frames,
        n = frames, t = 0,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：每帧 timer--
---→ progress = 1 − timer/duration → 套缓动（4 = OUT_QUADRATIC）→ position = origin + delta·progress。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then
        u = 1
    end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---ClampPosition（EnemyManager.cpp:804-818）：ins_75 打开的夹框，坐标换成我们的。
local function clamp_pos(owner)
    if owner.x < OUR_LO_X then
        owner.x = OUR_LO_X
    elseif owner.x > OUR_HI_X then
        owner.x = OUR_HI_X
    end
    if owner.y < OUR_LO_Y then
        owner.y = OUR_LO_Y
    elseif owner.y > OUR_HI_Y then
        owner.y = OUR_HI_Y
    end
end

---ins_136(26, 1) / (26, 0)：开/关冻结。原作自机那一侧是 Player::OnUpdate 直接早退
---（Player.cpp:1027-1038），移植版用 THlib 的 `player.lock`（th11_2/th14 同款写法）。
local function freeze_on()
    freeze_left = FREEZE_FRAMES
    player.lock = true
end

local function freeze_off()
    freeze_left = 0
    player.lock = nil
end

---BOSS 每帧。原作顺序：RunEcl（主 context → 子 context）→ ClampPosition →
---IntegrateVelocity → ClampPosition（EnemyManagerUpdate.cpp:157-181）。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw216_t 还是 nil（卡 205..215 同款守卫）。
    if owner.lw216_t == nil then
        return
    end
    local t = owner.lw216_t
    ---★ 标签 Sub1_504 之前的 `ins_6([10039], 5)` 只有第一次会执行
    ---（t=380 的 jump 落在标签上，跳过它）→ 弹数只累积。
    if t == CYCLE_START then
        owner.lw216_fan_count = FAN_COUNT_START
    end
    if t >= CYCLE_START then
        local u = (t - CYCLE_START) % CYCLE          -- 本轮相位
        if u == 0 then
            attach_s2(owner)                         -- `ins_135(0, 2)`
        elseif u == DRIFT1_T - CYCLE_START then
            begin_wander(owner, DRIFT1_FRAMES)        -- `ins_67(60, 4, 1.0)`
        elseif u == FREEZE_T - CYCLE_START then
            freeze_on()                              -- `ins_136(26, 1)`
            spawn_knives()                           -- `ins_136(27, 0)`
            begin_wander(owner, DRIFT2_FRAMES)        -- `ins_67(120, 4, 1.0)`
            owner.g_t = nil                          -- `ins_135(0, −1)`
        elseif u == FAN_T - CYCLE_START then
            freeze_off()                             -- `ins_136(26, 0)`
            fan_shot(owner.x, owner.y, owner.lw216_fan_count, FAN_COUNT2,
                    FAN_SPEED1, FAN_SPEED2, 0, FAN_STEP, true,
                    FAN_COLOR, SPAWN_FRAMES_20, nil, false)     -- `ins_96(...)`
            owner.lw216_fan_count = owner.lw216_fan_count + 1   -- `ins_30([10039])`
        end
    end
    ---子 context 0（Sub2）的出弹节拍。
    s2_frame(owner)
    ---隐形发射源照常跑（冻结不挡敌机）。
    for i = #knives, 1, -1 do
        local k = knives[i]
        knife_step(k)
        if k.done then
            table.remove(knives, i)
        end
    end
    ---位移（RunEcl 之后）。
    if owner.lw216_move then
        local nx, ny, done = move_step(owner.lw216_move)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw216_move = nil
        end
    end
    clamp_pos(owner)
    ---t=380 的 `ins_4(110, Sub1_504)`：拨回标签（那一帧已经跑过标签那一段）。
    if t == JUMP_T then
        owner.lw216_t = CYCLE_START
    else
        owner.lw216_t = t + 1
    end
    if freeze_left > 0 then
        freeze_left = freeze_left - 1
    end
end

local function card_init(owner)
    owner.lw216_t = 0
    owner.lw216_fan_count = 0
    ---★ 落位：生成助手 Sub9 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, ENTER_Y
    ---movementAngle = VectorAngle(0, 0) = 0。
    owner.lw216_mangle = 0
    owner.lw216_move = nil
    owner.g_t = nil
    freeze_left = 0
    owner.lw216_move = { x0 = owner.x, y0 = owner.y,
                         dx = 0 - owner.x, dy = ENTER_Y - owner.y,
                         n = ENTER_FRAMES, t = 0 }
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw216_t = nil
    owner.lw216_move = nil
    owner.g_t = nil
    ---冻结中途被打断也要把自机放开（否则自机永远动不了）。
    freeze_left = 0
    player.lock = nil
    for i = #knives, 1, -1 do
        knives[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[216] = {
    init = function(owner)
        pool = {}
        knives = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 217「待宵反射卫星斩」（魂魄妖梦）
---  ecldata_ym.ecl：Sub1 = BOSS 根、Sub2 = 斩击实体、Sub3 = 卫星发射器（BOSS 的子 context 0）、
---  Sub4 = 斩击生成器（Sub3 的子 context 1）、Sub5 = 卫星本体（Sub3 用 ins_93 生成的小怪）、
---  Sub6 = 屏幕特效（`ins_52(6)` 调的，跳过）。
---
---  内容：妖梦借月之力斩出的「卫星斩」。一轮 140 个 ECL tick（= 180 真帧，前 20 tick 是
---  **1/3 倍速的慢动作**）：入场 → 慢动作一秒 → 瞬移到场地**底部**，以 BOSS 的 x
---  （= 自机上一轮所在的 x）为轴拉起一条**贯穿整个场地高度**的卫星链 —— 16 个点 × 2 个方向
---  = 32 颗卫星朝两个方向斜着飞出，每颗每 6 帧朝**正上/正下**各打一发弹、共 10 拍；
---  弹出生后原地停 11 帧再慢慢加速 → BOSS 再朝自机飞到中场 → 下一轮。
---
---  · Sub1（根）—— 时间与坐标（TH08 → 我们：x' = x − 192、y' = 224 − y、角度取反）：
---      t=0    `ins_64(110, 4, 192, 128)` 入场插值 110 帧到 TH08 (192,128) = 我们 (0,96)，
---             缓动 4 = OUT_QUADRATIC。同帧的 ins_76（关移动边界）、ins_105(0)（关射击间隔）、
---             ins_95（清场）、ins_113（弹音效）、ins_80(4)（关可伤害）、ins_110(0,0)（出弹偏移归零）、
---             ins_134(5940, 8)（99 秒计时）、ins_122（符卡登记）都由 boss 系统与 lw_before 管。
---      t=110  ★ 循环体 Sub1_592 的起点（140 tick 一轮）。`ins_81(4)` 开可伤害、
---             `ins_160(120)` 减伤计时（移植版不打伤害，跳过）、`ins_6([10038], 0)`、
---             `ins_6([10039], 6)`、`ins_7(10020, 0.03926991)`（lf4）、`ins_7(10023, π/2)`（lf7）、
---             `ins_28(10022, 10023, 2.5)`（lf6 = lf7 ÷ 2.5）、`ins_7(10021, 4000)`（lf5 = 4000）
---             这七条只在头一轮跑：标签 Sub1_592 落在**最后一条的后**面（裸字节顺序
---             ins_81 / … / ins_7(lf5) / 标签 / ins_58 / ins_136 / ins_52），所以
---             `ins_4(110, Sub1_592)` 的跳转只回到 ins_58 那一条，lf5 与 lf6 都不会被重置。
---             循环体第一条：`ins_58(6)`（换 ANM）、`ins_136(28, 3)`（**开始慢动作**）、
---             `ins_52(6)`（屏幕特效，跳过）。
---      t=130  `ins_136(29, 1)`（**结束慢动作**：把所有弹的 velocity ×3 还原、倍率回 1）、
---             `ins_63(ENEMY_POSITION_X, 420)`（自己瞬移到 TH08 y=420 = 我们 y=−196，
---             **x 不变**；这条当场 ClampPosition，EclRunLow.inl:497-503）、`ins_58(5)`、
---             `ins_135(0, 3)`（挂上子 context 0 = Sub3，从 time=0 重来）。
---      t=190  `ins_64(60, 4, PLAYER_POSITION_X, 128)`：朝自机**那一刻**的 x 飞 60 帧到
---             (x, 我们 96)。`ins_47(lf5, 500, 190, Sub1_796)` → lf5 ≤ 500 就跳到标签；
---             否则 `ins_16(lf5, 300)`（lf5 −= 300）。两条路都落到 t=250 的同一条指令上
---             —— 真分支把时间拨到 190，而落点的指令 time = 250 > 190，要等到 t=250 才执行
---             （比较类指令的语义见 EclDependencies.cpp 的 CompareOperands / compare_success）。
---      t=250  `ins_4(110, Sub1_592)`：时间拨回 110 并跳回循环体第一条 → **同一 tick** 下一轮。
---    ★ 慢动作（`ins_136(28, 3)` = EnterScaledBulletTime，EclGlobals.cpp:65-95 第 28 项）：
---      原作把 `g_Supervisor.framerateMultiplier` 设成 1/3（EclExIns.cpp:859-884），
---      于是**所有 ZunTimer 每 3 真帧才走 1**（Supervisor.cpp:1218-1232 的 TickTimer 按
---      subFrame 累加）；弹、敌机位移、ANM、自机全都按倍率走。`ins_136(29, 1)` 退出时把
---      所有弹的 velocity ×3 还原（EclExIns.cpp:886-910）。
---      ⇒ 一轮的 20 个 tick（110→130）因此占 60 真帧，一轮 = 20×3 + 120 = **180 真帧**。
---      移植版没有全局倍率，就在本卡里自己模拟：`fm` = 1 或 1/3，`sub_acc` 是共享的亚帧
---      累加器（≡ 所有 ZunTimer 的 subFrame）；累加过 1 的那一真帧 `tick_frame = true`，
---      各对象的计时器才前进一格，而连续量（velocity/polar 的每帧增量）照原作每真帧 ×fm。
---      `ins_136(28/29)` 换成 set_slow()：进出时把本卡弹池里所有弹的 velocity ×(1/3 或 3)。
---      ★ 已知差异：原作连**自机**也 ×1/3（Player.cpp:851-852），移植版改不了自机速度 ——
---        慢动作那 60 帧自机相对偏快（这 60 帧里不出新弹，只是走位更从容一点）。
---      ★ 计时器的相位：各对象的计时器都从 0 起累加同一个 fm，所以共享一个累加器是等价的；
---        但「谁先跑」决定了各对象看到的是本帧还是上一帧的 tick —— 与对象列表顺序有关，
---        落差恒定 1 帧、对所有对象一致，不影响相对时序（见 tools/check_stage.lua 的实测）。
---  · Sub3（卫星发射器；挂上时继承父 context 的变量块，EclRunHigh.inl:646-680）：
---      t=0    `ins_135(1, 4)` 挂上 Sub4（斩击生成器）、`ins_124(42)` 音效、
---             `ins_27(extraFloat1, RANDOM_UNIT_FLOAT, 14)`（extraFloat1 = 随机 0..14）、
---             `ins_6([10038], 16)`（循环计数 = 16）。
---      标签 Sub3_80（t=0）：`ins_7(lf0, −7π/8)`、`ins_93(5, ENEMY_POSITION_X, extraFloat1, 0,
---             10, −2, 10)`（在绝对坐标 (BOSS.x, extraFloat1) 生成一颗 Sub5，life 10、
---             item −2、score 10）、`ins_7(lf0, −π/8)`、再生成一颗（同一个点、另一个方向）、
---             `ins_15(extraFloat1, 29.866667)`（extraFloat1 += 448/15）。
---      t=1    `ins_5(0, Sub3_80, [10038])`（JUMP_DEC：计数 −1，>0 就把时间拨回 0 并跳回标签
---             —— **同一帧继续执行**，EclRunLow.inl:234-244）、`ins_53` RETURN。
---      ⇒ 一 tick 出一对卫星：tick 0..15 各一对 = **32 颗**；第一对的 extraFloat1 = r0，
---        之后每次 +29.8667 → 16 个点正好铺满整个场地高度（448 px）；tick 16 计数归零 → RETURN。
---      ★ `ins_93` 的最后一个参数是父 context 的 intVariables（Enemy::SpawnEnemy2 会从
---        intVariables 起拷 0x78 = 120 字节，EnemyTimeline.cpp:64-115）—— intVariables 与
---        floatVariables 在 EnemyEclContext 里是连着的（EclManager.hpp:599-612）→
---        **floatVariables（lf0..lf7）也在拷贝范围里** → 卫星继承了刚设好的 lf0 与 BOSS 的 lf5。
---  · Sub4（斩击生成器）：t=0 `ins_94(2, 0, 0, …)`、t=8 两发（±8）、t=16 两发（±16）+ RETURN
---      → 一轮 5 条斩击，都生成在 BOSS 身上（SPAWN_ENEMY_RELATIVE：父 position + 偏移）。
---  · Sub2（斩击实体）：t=0 `ins_58(7)`、`ins_77(24, 1)` 判定（24 宽 × 1 高）、
---      `ins_80(49)`（1+16+32：关可伤害、允许出屏、不会死，EclRunLow.inl:667-700）、
---      `ins_81(2)`（**开碰撞**）、`ins_63(ENEMY_POSITION_X, 224)`（自己 y 挪到 TH08 正中
---      = 我们 y=0）；t=4 判定改成 `ins_77(16, 1024)`（16 宽 × 1024 高）；t=64 `ins_1`。
---      ⇒ 5 条并排（0、±8、±16）合成一条 **48 px 宽、贯穿整个场地**的斩击线；判定盒还要
---        再 ÷1.5（Enemy::CheckPlayerCollision，EnemyManager.cpp:822-849）→ 原作这是
---        **碰到就死**的判定线。
---      ★ 移植版按本文件其余卡（205..216 都没有能打死自机的对象）的惯例，把它做成纯观感，
---        只用一条同形状的光柱占位（enemy2.anm 脚本 7 长什么样还不知道，最后统一换素材）。
---  · Sub5（卫星本体，life 10）：
---      t=0    `ins_58(7)`、`ins_80(8)`（NO_SPRITE = **隐形**）、`ins_65(lf0, 10)`
---             （朝 lf0 以 10 px/帧 无限期移动 —— 移动模式 POLAR）、四条 `ins_111`（见下）、
---             `ins_6([10038], 10)`（射击拍数 = 10）、
---             `ins_28(10016, RANDOM_ANGLE, [10021])`（lf0 = 随机角 ÷ lf5）、
---             `ins_99(262150, 2, 1, 0, 0.4, π/2, 0.19634955, 131634)`（见下）。
---      t=6    `ins_5(0, …, [10038])`（计数 −1，>0 就跳回 t=0）、`ins_1`。
---      ⇒ 每 6 tick 打一发、共 10 发；tick 60 计数归零 → TERMINATE。
---      ★ `ins_65(lf0, 10)` 在 `ins_28` **之前**：第 1 拍的方向是继承来的 −π/8 或 −7π/8，
---        之后每一拍的方向 = **上一拍抽到的那个随机角**（≈0）→ 卫星第 2 拍起几乎笔直横飞。
---      ★ 四条 transform 记录（`ins_111` 的操作数布局 = EclRunHigh.inl:78-91 的
---        BulletTransformInstructionArgs；载荷联合体 = BulletManager.hpp:19-127；
---        kind 位 = BulletManager.hpp:124-152）：
---          0  WAIT         allow=0  int0=10（frames）
---          1  ACCEL_VECTOR allow=0  int0=60（duration）f0=0.00833333（magnitude）f1=−999（用当前角）
---          2  ACCEL_POLAR  allow=0  int0=120（duration）f0=0.00833333（speedDelta）f1=lf0（angleDelta）
---          3  ACCEL_VECTOR allow=0  int0=120（duration）f0=0.00833333（magnitude）f1=−999
---        transformFlags = 131634 = 0x20232 = SPAWN_FAST(0x2) | ACCEL_VECTOR(0x10) | ACCEL_POLAR(0x20)
---                        | PLAY_SPAWN_SOUND(0x200) | WAIT(0x20000)
---        ⇒ 弹的一生：出生动画（11 帧）→ 原地停 ~11 帧（WAIT 10）→ ACCEL_VECTOR 60 帧
---          （速度 0→0.5、位移 15 px）→ **ACCEL_POLAR 的头一帧就用 `velocity = polar(angle, fm·speed)`
---          重建速度，而 speed 还是 0 → 当场刹停**（BulletManager.cpp:1228-1252）→ 再花 120 帧
---          把 speed 从 0 加到 1.0（角度同时每帧 += fm·lf0）→ 最后 ACCEL_VECTOR 120 帧把速度
---          加到 2.0 → 之后匀速飞出。
---        ★ 出膛角：SHOOT_CIRCLE（op=99 → aimMode 3）用 `i·2π/count1 + angle`
---          （BulletManager.cpp:120-124）→ count1 = 2、angle = π/2 → **正下/正上**两发（TH08 口径）。
---        ★ speed1 = 0 且 count2 = 1 → 出膛速度恒 0（`:87-92`），speed2 = 0.4 用不上。
---        ★ 出生动画长度 = spawnFastVm 的脚本（bulletType 6 → g_BulletSpriteScripts 第 7 行
---          {6, 21, 22, 23, 16}，BulletManager.cpp:299-317）：etama 的 script21 末尾是
---          `+10: ins_1` → 出生分支跑 **11** 帧；出生瞬间先退 velocity×4（这里是 0），每帧只走
---          velocity/2，动画结束那一帧再补一次完整速度（`:966 goto activateBullet`）。
---      ★ 同屏上限：弹 1536 槽（`Bullet bullets[0x601]`，BulletManager.hpp:455）。池满整波不生、
---        波中途生不出来就丢掉剩下的（BulletManager.cpp:685-712）。本卡一轮 32 颗卫星 × 10 拍 × 2 发
---        = 640 发，而弹要飞满 4~5 秒才出屏 → 池会被打满。这是原版行为，照抄。
---      ★ 出屏回收（BulletManager.cpp:856-899）：本卡的弹没有转向/反弹状态 → 出屏即回收。
---  · 占位贴图：弹 = ball_small；卫星 = "servant"（原作 NO_SPRITE 隐形，这里画出来才看得见）；
---    斩击 = 光柱。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---色号：TH08 的 c → 我们的 c + 1（COLOR.DEEP_RED = 1，bulletStyle.lua:267）。
local function th08_color(c) return c + 1 end

---TH08 → 我们的坐标：x' = x − 192、y' = 224 − y（角度取反 —— y 轴翻了）。
---只在把 ECL 里写死的常数搬过来时用；自机/敌机自己的坐标本来就是我们的口径。
local function our_y(y) return 224 - y end

---根时间轴（单位 = ECL tick；慢动作期间 1 tick = 3 真帧）。
local ENTER_FRAMES, ENTER_Y = 110, our_y(128)     -- ins_64(110, 4, 192, 128)
local LOOP_T = 110                                -- 标签 Sub1_592
local SLOW_T0, SLOW_T1 = 110, 130                 -- ins_136(28, 3) / ins_136(29, 1)
local SLOW_DIV = 3                                -- 28 的操作数 → framerateMultiplier = 1/3
local DROP_T, DROP_Y = 130, our_y(420)            -- ins_63(ENEMY_POSITION_X, 420)
local AIM_T, AIM_FRAMES = 190, 60                 -- ins_64(60, 4, PLAYER_POSITION_X, 128)
local ROUND_END_T = 250                           -- ins_4(110, Sub1_592)
local LF0, LF_STEP, LF_MIN = 4000, 300, 500       -- ins_7(lf5, 4000) / ins_16(lf5, 300) / ins_47 的 500
local EASING_OUT_QUAD = 4                         -- EclEasingMode（EclManager.hpp:518-526）

---Sub3 / Sub4 / Sub5 的参数。
local SAT_LINE_N = 16                             -- `ins_6([10038], 16)`
local SAT_LINE_GAP = 29.866667                    -- `ins_15(extraFloat1, 29.866667)` = 448/15
local SAT_R0_MAX = 14.0                           -- `ins_27(extraFloat1, RANDOM_UNIT_FLOAT, 14)`
local SAT_DIR_A = -2.7488935                      -- lf0 = −7π/8（TH08 口径）
local SAT_DIR_B = -0.3926991                      -- lf0 = −π/8（TH08 口径）
local SAT_SPEED = 10                              -- `ins_65(lf0, 10)`
local SAT_SHOTS = 10                              -- `ins_6([10038], 10)`
local SAT_INTERVAL = 6                            -- 循环体在 t=0、`ins_5` 在 t=6
local SLASH_LIFE = 64                             -- Sub2 的 `ins_1` 在 t=64
local SLASH_LEN = 683                             -- 1024 ÷ 1.5（EnemyManager.cpp:840）
local SLASH_W = 11                                -- 16 ÷ 1.5
local SLASH_DX = { 0, -8, 8, -16, 16 }            -- Sub4 三拍合的并排偏移

---弹（`ins_99`）的参数：bulletType 6 / color 4、SPAWN_FAST、speed1 = 0。
local BULLET_COLOR = 4
local BULLET_SPAWN_FRAMES = 11                    -- etama script21（末尾 `+10: ins_1`）
local RING_COUNT = 2                              -- count1
local RING_ANGLE = PI / 2                         -- descriptor->angle
local WAIT_FRAMES = 10
local ACCEL_MAG = 0.00833333
local VEC_DUR1 = 60
local POLAR_DUR = 120
local VEC_DUR3 = 120

---同屏弹幕上限与出屏判据（见卡头注释）。
local POOL_SIZE = 1536                            -- BulletManager.hpp:455
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local SPRITE_HALF = 8                             -- 占位 ball_small 是 16×16

---本卡自己的弹池（≡ 原作的 1536 个弹槽）与登记表。
local pool = {}
local sats = {}
local slashes = {}

---慢动作状态（≡ 原作的全局 framerateMultiplier 与所有 ZunTimer 的 subFrame）。
local fm = 1
local sub_acc = 0
local tick_frame = true

---小车：Sub3/Sub4/Sub5 各自那份 ECL 上下文的程序。
local OP_PAIR, OP_FIRE, OP_DECJMP, OP_RET = 1, 2, 3, 4
local SUB3 = {
    { t = 0, op = OP_PAIR },                      -- 标签 Sub3_80 那一组
    { t = 1, op = OP_DECJMP, target = 1 },
    { t = 1, op = OP_RET },
}
local SUB4 = {
    { t = 0, dxs = { 0 } },                       -- `ins_94(2, 0, 0, …)`
    { t = 8, dxs = { -8, 8 } },
    { t = 16, dxs = { -16, 16 }, ret = true },
}
local SUB5 = {
    { t = 0, op = OP_FIRE },
    { t = SAT_INTERVAL, op = OP_DECJMP, target = 1 },
    { t = SAT_INTERVAL, op = OP_RET },
}

local sat = nil          -- Sub3 的状态机（nil = 没挂；Sub4 的时间挂在 sat.sub4_t 上）
local sub4_pc = nil      -- Sub4（斩击生成器）的程序计数器

local lw217_bullet
local lw217_sat
local lw217_slash

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:809-816）。
---本卡一轮就有 640 发弹，所以就地压缩（等价于卡 215 的 table.remove 版，只是 O(n)）。
local function pool_used()
    local n = 0
    local m = #pool
    for i = 1, m do
        if IsValid(pool[i]) then
            n = n + 1
            if n ~= i then
                pool[n] = pool[i]
            end
        end
    end
    for i = m, n + 1, -1 do
        pool[i] = nil
    end
    return n
end

---`ins_136(28, 3)` / `ins_136(29, 1)`：进出慢动作（EclExIns.cpp:859-910）。
---进：倍率 1/3，并把**所有**弹的 velocity ×1/3；出：倍率回 1，并把所有弹的 velocity ×3。
local function set_slow(on)
    local k
    if on then
        k = 1 / SLOW_DIV
    else
        k = SLOW_DIV
    end
    for i = 1, #pool do
        local b = pool[i]
        if IsValid(b) then
            b.b_vx = b.b_vx * k
            b.b_vy = b.b_vy * k
        end
    end
    fm = on and (1 / SLOW_DIV) or 1
end

---`ins_65(lf0, 10)`：把移动方向设成 lf0（TH08 → 我们取反），速度 10、无限期。
---（EnemyManager 的移动模式 POLAR：每帧 position += velocity×fm，EnemyManagerUpdate.cpp:941-945）
local function sat_set_dir(s)
    local a = -s.s_cur
    s.s_vx = math.cos(a) * SAT_SPEED
    s.s_vy = math.sin(a) * SAT_SPEED
end

---AdvanceTransformProgram 的一次推进（BulletManager.cpp:312-478）：四条记录的 allowWhileActive
---都是 0 → 只要有状态挂着就原地返回（:321-323）；本卡只有 4 条记录。
local function load_record(b)
    if b.b_rec >= 4 then
        return
    end
    b.b_rec = b.b_rec + 1
    if b.b_rec == 1 then
        b.b_wait = WAIT_FRAMES                                   -- :418-420
    elseif b.b_rec == 2 or b.b_rec == 4 then
        ---f1 = −999 < −990 → 用弹**当前**的角（:346-350）；装载时先 ×fm（:353-356）。
        local mag = fm * ACCEL_MAG
        b.b_vec = { timer = 0, dur = (b.b_rec == 2) and VEC_DUR1 or VEC_DUR3,
                    vx = math.cos(b.b_angle) * mag, vy = math.sin(b.b_angle) * mag }
    elseif b.b_rec == 3 then
        b.b_pol = { timer = 0, dur = POLAR_DUR,
                    sdelta = ACCEL_MAG, adelta = b.b_delta }     -- :358-370
    end
end

---UpdateVectorAcceleration（BulletManager.cpp:1198-1226）：timer 每 fm 帧才 +1，但每真帧都 ×fm 累加。
local function vec_step(b)
    local v = b.b_vec
    if v.timer >= v.dur then
        b.b_vec = nil
    else
        b.b_vx = b.b_vx + v.vx * fm
        b.b_vy = b.b_vy + v.vy * fm
        if math.abs(b.b_vx) > 0.0001 or math.abs(b.b_vy) > 0.0001 then
            b.b_angle = math.atan2(b.b_vy, b.b_vx)
        end
    end
    if tick_frame then
        v.timer = v.timer + 1
    end
end

---UpdatePolarAcceleration（BulletManager.cpp:1228-1252）：每帧用 speed 重建 velocity。
local function pol_step(b)
    local p = b.b_pol
    if p.timer >= p.dur then
        b.b_pol = nil
    else
        b.b_angle = b.b_angle + fm * p.adelta
        b.b_speed = b.b_speed + fm * p.sdelta
        b.b_vx = math.cos(b.b_angle) * (fm * b.b_speed)
        b.b_vy = math.sin(b.b_angle) * (fm * b.b_speed)
    end
    if tick_frame then
        p.timer = p.timer + 1
    end
end

---本卡的弹（bulletType 6 / color 4）。占位贴图 ball_small。
---  angle_th08 = 出膛角（TH08 口径）、adelta = 记录 2 的 angleDelta（= 那一拍抽到的 lf0）。
lw217_bullet = Class(bullet, {
    init = function(self, x, y, angle_th08, adelta)
        ---`bullet.init(self, imgclass, index, stay, destroyable)`：group = 1、colli = true
        ---（THlib/bullet/bullet.lua:85-89）。
        bullet.init(self, ball_small, th08_color(BULLET_COLOR), false, true)
        self.b_angle = -angle_th08
        self.b_speed = 0                     -- speed1 = 0、count2 = 1 → 出膛速度恒 0
        self.b_vx, self.b_vy = 0, 0
        self.b_spawn = BULLET_SPAWN_FRAMES   -- SPAWN_FAST
        self.b_rec = 0                       -- transformIndex
        self.b_wait, self.b_vec, self.b_pol = nil, nil, nil
        self.b_delta = adelta
        self.x, self.y = x, y                -- 出生瞬间退 velocity×4 —— 这里是 0
        self.colli = false                   -- 出生动画期间没有判定（判定在 FIRED 分支里）
    end,
    frame = function(self)
        ---① 出生动画（BulletManager.cpp:950-975）。本卡的弹都在慢动作结束后出生 → fm = 1。
        if self.b_spawn > 0 then
            self.b_spawn = self.b_spawn - 1
            self.vx, self.vy = self.b_vx / 2, self.b_vy / 2
            if self.b_spawn > 0 then
                bullet.frame(self)
                return
            end
            ---动画播完那一帧直接落到 FIRED 分支（`:966 goto activateBullet`），
            ---于是这一帧既走了 velocity/2 又补一次完整的 FIRED。
            self.colli = true
        end
        ---② FIRED：AdvanceTransformProgram → 各状态机 → WAIT（BulletManager.cpp:822-855）。
        if self.b_wait == nil and self.b_vec == nil and self.b_pol == nil then
            load_record(self)
        end
        if self.b_vec then
            vec_step(self)
        end
        if self.b_pol then
            pol_step(self)
        end
        if self.b_wait ~= nil then
            if self.b_wait <= 0 then
                self.b_wait = nil
            elseif tick_frame then
                self.b_wait = self.b_wait - 1
            end
        end
        ---③ position += velocity（velocity 里已经含 ×fm），交给引擎积分。
        self.vx, self.vy = self.b_vx, self.b_vy
        bullet.frame(self)
        ---④ 出屏回收（BulletManager.cpp:856-899）：本卡的弹没有转向/反弹状态 → 出屏即回收。
        if outside_field(self.x, self.y) then
            object.RawDel(self)
        end
    end,
})

---一次出弹（`ins_99` = SHOOT_CIRCLE）。池满 → 整波不生；波中途生不出来就丢掉剩下的
---（BulletManager.cpp:685-712）。count1 = 2、angle = π/2（TH08）→ 正下/正上一对。
local function sat_fire(owner, adelta)
    local used = pool_used()
    for i = 0, RING_COUNT - 1 do
        if used >= POOL_SIZE then
            return
        end
        pool[#pool + 1] = New(lw217_bullet, owner.x, owner.y,
                RING_ANGLE + i * 2 * PI / RING_COUNT, adelta)
        used = used + 1
    end
end

---卫星（Sub5）。life 10、item −2 → 死时不掉东西。占位贴图 "servant"
---（原作 `ins_80(8)` 是 NO_SPRITE = 隐形，这里画出来才看得见弹是从哪儿来的）。
lw217_sat = Class(object, {
    init = function(self, x, y, dir_th08, lf5)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.35, 0.35
        self.colli = false                  -- 见卡头注释：不做能打死自机的对象
        self.navi = false
        self.bound = false                  -- 会飞出场地（原作 NO_SPRITE → 引擎不按出屏回收）
        self.rot = 0
        self._blend, self._a = "", 255
        self.s_lf5 = lf5                    -- `ins_28` 的除数（= BOSS 那一刻的 lf5）
        self.s_cur = dir_th08               -- lf0：`ins_65` 先用它，`ins_28` 随后覆盖
        self.s_cnt = SAT_SHOTS              -- `ins_6([10038], 10)`
        self.s_pc = 1
        self.s_t = 0
        self.s_vx, self.s_vy = 0, 0
        sat_set_dir(self)
    end,
    frame = function(self)
        ---POLAR 移动模式的位移（×fm）。
        self.x = self.x + self.s_vx * fm
        self.y = self.y + self.s_vy * fm
        if not tick_frame then
            return
        end
        ---子 context 的 ECL：只在 tick 时推进（帧末才 time++，跳转落点跟在本轮第一条上）。
        local time = self.s_t
        while true do
            local ins = SUB5[self.s_pc]
            if ins == nil or ins.t ~= time then
                break
            end
            if ins.op == OP_FIRE then
                sat_set_dir(self)                                   -- `ins_65(lf0, 10)`
                ---★ `ins_28` 在 `ins_65` 之后、`ins_99` 之前 → 每一拍都重抽，
                ---  且下一拍的运动方向 = 这一拍抽到的角。
                self.s_cur = ran:Float(-PI, PI) / self.s_lf5
                sat_fire(self, self.s_cur)                          -- `ins_99`
                self.s_pc = self.s_pc + 1
            elseif ins.op == OP_DECJMP then
                self.s_cnt = self.s_cnt - 1
                if self.s_cnt <= 0 then
                    self.s_pc = self.s_pc + 1
                else
                    time = 0
                    self.s_pc = ins.target
                end
            else
                object.RawDel(self)                                 -- `ins_1`
                return
            end
        end
        self.s_t = time + 1
    end,
})

---斩击实体（Sub2）。原作是一条 16×1024 的**致命**判定（见卡头注释），移植版做成纯观感。
lw217_slash = Class(laser, {
    init = function(self, x, y)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）。
        ---rot = 90（角度制）→ 沿 +y 竖着长 683 px，正好贯穿场地。
        laser.init(self, 2, x, y, 90, 0, SLASH_LEN, 0, SLASH_W, 0, 0)
        self.colli = false
        self.alpha = 1
        self.w = SLASH_W
        self.bound = false
        self.sl_t = 0
    end,
    frame = function(self)
        if tick_frame then
            self.sl_t = self.sl_t + 1
            if self.sl_t >= SLASH_LIFE then
                object.RawDel(self)             -- `ins_1`（TERMINATE）
                return
            end
        end
        laser.frame(self)
    end,
})

---`ins_94(2, dx, 0, …)`：在 BOSS 身上 + dx 生成一条斩击，再被 `ins_63` 把 y 挪到场地正中。
local function spawn_slash(owner, dx)
    slashes[#slashes + 1] = New(lw217_slash, owner.x + dx, -SLASH_LEN / 2)
end

---`ins_93(5, ENEMY_POSITION_X, extraFloat1, …)`：在 (BOSS.x, extraFloat1) 生成一颗卫星。
---extraFloat1 是 TH08 的 y → 我们取 224 − r。
local function spawn_sat(owner, dir_th08)
    sats[#sats + 1] = New(lw217_sat, owner.x, our_y(sat.r), dir_th08, sat.lf5)
end

---Sub4（`ins_135(1, 4)` 挂上的斩击生成器）的步进。
local function sub4_step(owner, time)
    if sub4_pc == nil then
        return
    end
    local done = false
    while true do
        local ins = SUB4[sub4_pc]
        if ins == nil or ins.t ~= time then
            break
        end
        for k = 1, #ins.dxs do
            spawn_slash(owner, ins.dxs[k])
        end
        if ins.ret then
            done = true
        end
        sub4_pc = sub4_pc + 1
    end
    if done then
        sub4_pc = nil
    end
end

---`ins_135(0, 3)`：挂上子 context 0（Sub3）。子 context 是**同一只敌机**上另开的一份 ECL
---上下文，变量块从父 context 整块拷过来（EclRunHigh.inl:646-680）→ Sub3/Sub4/Sub5 都继承
---了 BOSS 那一刻的 lf5（Sub5 的 `ins_28` 拿它当除数）。
local function attach_sat(owner)
    sat = { t = 0, pc = 1, counter = SAT_LINE_N, r = 0, lf5 = owner.lw217_lf5, sub4_t = 0 }
    sat.r = ran:Float(0, 1) * SAT_R0_MAX      -- `ins_27(extraFloat1, RANDOM_UNIT_FLOAT, 14)`
    sub4_pc = 1
end

---Sub3（子 context 0）的步进：tick 0..15 各出一对卫星，tick 16 RETURN。
local function sat_step(owner, time)
    ---Sub4 比 Sub3 多活一 tick（两者都在自己的 tick 16 结束），所以先推它。
    sub4_step(owner, sat.sub4_t)
    sat.sub4_t = sat.sub4_t + 1
    while true do
        local ins = SUB3[sat.pc]
        if ins == nil or ins.t ~= time then
            break
        end
        if ins.op == OP_PAIR then
            spawn_sat(owner, SAT_DIR_A)                 -- `ins_7(lf0, −7π/8)` + `ins_93`
            spawn_sat(owner, SAT_DIR_B)                 -- `ins_7(lf0, −π/8)`  + `ins_93`
            sat.r = sat.r + SAT_LINE_GAP                -- `ins_15(extraFloat1, 29.866667)`
            sat.pc = sat.pc + 1
        elseif ins.op == OP_DECJMP then
            sat.counter = sat.counter - 1
            if sat.counter <= 0 then
                sat.pc = sat.pc + 1                     -- ≤0 不跳，落到 `ins_53`
            else
                time = 0                                -- `ins_5` 的第一个操作数 = 0
                sat.pc = ins.target
            end
        else
            sat = nil                                   -- `ins_53` RETURN
            return
        end
    end
    sat.t = time + 1
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支），按 fm 缩放。
local function move_step(mv)
    mv.t = mv.t + fm
    local u = mv.t / mv.n
    if u > 1 then
        u = 1
    end
    local e
    if mv.easing == EASING_OUT_QUAD then
        e = 1 - (1 - u) * (1 - u)
    else
        e = u
    end
    return mv.x0 + mv.dx * e, mv.y0 + mv.dy * e, mv.t >= mv.n
end

---BOSS 根时间轴的一条指令组。返回 true = 这一 tick 还要继续跑（`ins_4` 跳回循环体）。
local function root_step(owner, t)
    if t == LOOP_T then
        ---`ins_136(28, 3)`：开始慢动作。`ins_52(6)` 是屏幕特效，跳过。
        set_slow(true)
    elseif t == SLOW_T1 then
        ---`ins_136(29, 1)`（退出慢动作）→ `ins_63(ENEMY_POSITION_X, 420)`（瞬移到场地底部）
        ---→ `ins_135(0, 3)`（挂上子 context 0）。
        set_slow(false)
        owner.lw217_move = nil
        owner.y = DROP_Y
        attach_sat(owner)
    elseif t == AIM_T then
        ---`ins_64(60, 4, PLAYER_POSITION_X, 128)`：朝自机**此刻**的 x 飞到中场 (x, 96)。
        owner.lw217_move = { x0 = owner.x, y0 = owner.y,
                             dx = player.x - owner.x, dy = ENTER_Y - owner.y,
                             n = AIM_FRAMES, t = 0, easing = EASING_OUT_QUAD }
        ---`ins_47(lf5, 500, …)` + `ins_16(lf5, 300)`：lf5 > 500 才继续减。
        if owner.lw217_lf5 > LF_MIN then
            owner.lw217_lf5 = owner.lw217_lf5 - LF_STEP
        end
    elseif t == ROUND_END_T then
        ---`ins_4(110, Sub1_592)`：时间拨回 110 并跳回循环体第一条 → **同一 tick** 下一轮。
        owner.lw217_t = LOOP_T
        return true
    end
    return false
end

---BOSS 每帧。原作顺序：RunEcl（主 context → 子 context）→ ClampPosition →
---IntegrateVelocity → ClampPosition（EnemyManagerUpdate.cpp:157-181）。本卡 t=0 的 `ins_76`
---关掉了移动边界 → 不夹框。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw217_t 还是 nil（卡 205..216 同款守卫）。
    if owner.lw217_t == nil then
        return
    end
    ---① 亚帧累加（≡ Supervisor::TickTimer）：本真帧给所有「计时器」推一格吗？
    sub_acc = sub_acc + fm
    tick_frame = false
    if sub_acc >= 1 then
        sub_acc = sub_acc - 1
        tick_frame = true
    end
    ---② BOSS 根时间轴（含 t=250 那条跳回 t=110）。
    if tick_frame then
        local guard = 0
        while root_step(owner, owner.lw217_t) do
            guard = guard + 1
            if guard > 8 then
                break
            end
        end
        if sat ~= nil then
            sat_step(owner, sat.t)
        end
        owner.lw217_t = owner.lw217_t + 1
    end
    ---③ BOSS 的插值位移（RunEcl 之后）。
    local mv = owner.lw217_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw217_move = nil
        end
    end
end

local function card_init(owner)
    owner.lw217_t = 0
    owner.lw217_lf5 = LF0
    ---★ 落位：生成助手 Sub10 的 t=0 就 `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)。
    ---  根第一条 ins_64 的目标也是 (192,128) → 插值位移恒 0：原作 BOSS 是**原地出现**，
    ---  不是从场外飞进来（旧版从出生点插值，还会被 ins_75 的夹框拉回来）。
    owner.x, owner.y = 0, ENTER_Y
    owner.lw217_move = { x0 = owner.x, y0 = owner.y,
                         dx = 0 - owner.x, dy = ENTER_Y - owner.y,
                         n = ENTER_FRAMES, t = 0, easing = EASING_OUT_QUAD }
    fm, sub_acc, tick_frame = 1, 0, true
    sat, sub4_pc = nil, nil
end

local function card_del(owner)
    ---★ 帧计数器与全局慢动作都必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑
    ---（`fm` 更是本卡**自己**的全局量，留着下一张卡会一直慢动作）。
    owner.lw217_t = nil
    owner.lw217_move = nil
    owner.lw217_lf5 = nil
    fm, sub_acc, tick_frame = 1, 0, true
    sat, sub4_pc = nil, nil
    for i = #sats, 1, -1 do
        if IsValid(sats[i]) then
            object.RawDel(sats[i])
        end
        sats[i] = nil
    end
    for i = #slashes, 1, -1 do
        if IsValid(slashes[i]) then
            object.RawDel(slashes[i])
        end
        slashes[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[217] = {
    init = function(owner)
        pool = {}
        sats = {}
        slashes = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 219「猩红命运」（蕾米莉亚·斯卡雷特）
---  ecldata_rm.ecl：Sub1 = BOSS 根；Sub2 / Sub3 / Sub4 是挂在**同一只 BOSS** 上的
---  三个子 ECL context（slot 0 / 1 / 2，`ins_135` = SET_CHILD_ECL），
---  每个是一台「绕 BOSS 转的螺旋发射器」。
---
---  一轮 190 帧（t=300 的 `ins_4(110, …)` 把时间拨回 110，**同一帧**就从循环体
---  第一条继续 —— 跟卡 217 同一个套路）：
---    t=0    入场插值 110 帧到 TH08 (192,128) = 我们 (0,96)，缓动 4 = OUT_QUADRATIC。
---    t=110  ★ 标签 Sub1_600 落在**第一条循环指令**上（裸字节顺序：… ins_7(lf6,4)
---           / 标签 / ins_25 …），所以那批 `ins_7` 只在**头一轮**跑：
---             lf4 = 0.03926991、lf7 = π/2、lf6 = lf7/2.5（随后被 4.0 覆盖）、
---             lf2 = 0.18479957、lf6 = 4.0。
---           循环体（每轮都跑）：
---             ① lf0 = 自机方向角 + π/2 → `ins_135(0, 2)`（slot 0 = Sub2，正向螺旋）
---             ② lf0 = 自机方向角 − π/2 → `ins_135(1, 3)`（slot 1 = Sub3，反向螺旋）
---             ③ lf0 = 自机方向角 + π   → `ins_135(2, 4)`（slot 2 = Sub4，对向扇形）
---             ④ `ins_17(lf2, −1)`：lf2 取反（Sub4 的旋转方向每轮换一次）
---    t=240  `ins_67(60, 4, 1.0)` = MOVE_RANDOM_IN_BOUNDS：抽一个方向、漂移 60 帧；
---           然后 `ins_51(lf6, 10, 240, Sub1_824)`：lf6 ≥ 10 就跳过 `ins_15(lf6, 1)`
---           （真分支把 time 也写成 240，落点那条 `ins_4` 在 t=300，于是两条路都等到 300）。
---           ⇒ 出弹初速 lf6 从 4 每轮 +1，涨到 10 就钉死。
---    t=300  `ins_4(110, Sub1_600)`：时间拨回 110、跳回循环体第一条 → 同一帧下一轮。
---
---  ★ 子 context 的变量块是**父 context 整块拷过来的**（EclRunHigh.inl:646-680 的
---    SET_CHILD_ECL：CallEclSub 之后再 memcpy intVariables..floatVariables）——
---    所以三个发射器各自继承了那一刻的 lf0 / lf2 / lf6，之后各走各的；
---    「出弹初速每轮 +1」就是靠这条链路传进三个子 context 的。
---  ★ 每帧三个 context 依次跑（EclRun.cpp:181-209：主 context → slot 0 → 1 → 2），
---    最后才 UpdateMovement；所以子 context 用的世界坐标永远是**上一帧末**的。
---
---  · Sub2 / Sub3（互为镜像）：64 拍、每拍隔 2 帧（`ins_5` 在 t=2），整段 128 帧。
---      lf1 从 64 起、每拍 −2（`ins_16(lf1, 2)`）→ 发射点沿一条直线穿过 BOSS
---      （半径 64 → 0 → −64）；
---      lf0 每拍 ∓0.18479957（= 10.5875°）→ 发射点绕 BOSS 转 1.88 圈。
---      `ins_99`：count1 = 1、count2 = 4、speed1 = lf6、speed2 = 0.5、angle = lf0、
---      angleStep = ∓0.2617994（15°）、bulletType 20 / color 1、
---      flags 1049090（见下）。→ 每拍 4 发：角度 lf0 + j·(∓15°)、
---      速度 lf6 − (lf6 − 0.5)·j/4（j = 0..3）——**最快的一发顺着发射点方向直出，
---      后面的越慢越往回偏**，所以每拍是一小串「甩在后面」的弧。
---  · Sub4（slot 2）：自己的 t=60 才开跑（前 60 帧这份 context 空转）、16 拍、
---      每拍隔 2 帧，整段 92 帧。lf0 从 自机方向角 + π 起、每拍 += lf2（每轮换向）；
---      angleStep = lf2 / 1.5（每拍现算，但 lf2 在子 context 里不会再变）；
---      count1 = 1、count2 = 4、speed1 = lf6、speed2 = 0.5、bulletType 10 / color 0。
---      → 与 Sub2/Sub3 反着转、慢 60 帧起步的一串对向螺旋。
---  · `ins_38` = POLAR_TO_CARTESIAN（EclRunLow.inl:369-374）= (cos(angle)·mag, sin(angle)·mag)，
---    结果写进 extraFloat0/1，再由 `ins_110` = SET_SHOOT_OFFSET 当作出弹偏移 →
---    发射点 = worldPosition + polar(lf0, lf1)。
---  · `ins_99` = SHOOT_CIRCLE（aimMode 3，BulletManager.cpp:139-145）：
---      角度 = index1·2π/count1 + index2·angleStep + angle（count1 = 1 → index1 恒 0）；
---      速度 = count2 > 1 时 speed1 − (speed1 − speed2)·index2/count2（:83-92）；
---      创建顺序是 **j 在外、i 在内**（BulletManager.cpp:693-702）。
---  ★ 出膛：transformFlags = 1049090 = 0x100202 = SPAWN_FAST(2) | PLAY_SPAWN_SOUND(0x200)
---    | ECL_EX_TRIGGER_MARKER(0x100000)（BulletManager.hpp:129-152）。
---    本卡没有任何 `ins_111` → 变换程序为空 → 出膛后就是匀速直线（没有加速/转向记录）。
---    SPAWN_FAST：出生瞬间位置先退 velocity×4，出生动画期间每帧只走 velocity/2，
---    动画走完那一帧再补一次完整位移、同一帧开始有判定（BulletManager.cpp:226-228、
---    946-966 → goto activateBullet）。
---    出生动画长度 = etama 的 spawnFast 脚本（bulletType 20 → 脚本表第 21 行
---    {115,24,24,24,17} → etama script24，末尾 `+30: ins_1` → 31 帧；
---    bulletType 10 → 第 11 行 {25,27,27,27,26} → script27，末尾 `+24: ins_1` → 25 帧）。
---  ★ 出屏回收（BulletManager.cpp:856-899）：本卡的弹没有转向/反弹状态 → 出屏即回收；
---    判据是 IsWithinPlayfield（GameManager.cpp:132-152）=「加半个精灵宽高之后还在不在
---    场地里」，而原作这两种弹的精灵是 30×30 与 64×64（etama sprite146 / sprite168）。
---  ★ 同屏上限：1536 槽（BulletManager.hpp:455）。本卡一轮 3×64+16 拍 × 4 发 = 832 发，
---    但弹速 ≤ 10、场地只有 384×448，绝大多数 100 帧内出屏 → 池不会满。
---  ★ `minimumPlayerDistanceSquared` = 1024（EnemyManager.cpp:187 的出生默认值）：
---    出弹前若 BOSS 离自机 < 32 px 则**整条 `ins_99` 被跳过**（EclDependencies.cpp:707-712）。
---  ★ 符卡期间 rank 缩放整段被 `if (!g_Spellcard.IsActive())` 挡住
---    （EclDependencies.cpp:735-761）→ count1/count2/speed 都不随 rank 变。
---  ★ 占位贴图：bulletType 20 → ball_big、bulletType 10 → ball_mid。最后统一换素材。
---  ★ BOSS 的落位与移动边界（都在**生成助手 Sub8** 的 t=0，比根 Sub1 早 43 帧）：
---      `ins_63 SET_POSITION(192, 128)` → 我们 (0, 96)：BOSS **原地出现**。根的第一条
---      `ins_64(110, 4, 192, 128)`（MOVE_TO）目标正是同一点 → 插值位移恒 0，不是入场动画。
---      `ins_75 SET_MOVEMENT_BOUNDS(32, 48, 352, 128)` → 同时置 CLAMP_POSITION
---      （EclRunLow.inl:622-635）：EnemyManagerUpdate.cpp:172-174 每帧在位移**前后**各钳一次，
---      BOSS 被夹在 TH08 x∈[32,352]、y∈[48,128] ＝ 我们 x∈[−160,160]、y∈[96,176]。
---      ⇒ `ins_67` 那四条边界判据用的是**这组边界**（判据是「边界 ±96/48」）：
---         x 比 32+96 = 128、352−96 = 256；y 比 48+48 = 96、128−48 = 80。
---      （旧版按「没设过边界 = 全 0」写，于是 BOSS 60 帧一漂、一路漂到屏幕外几百像素。）
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x − 192、y' = 224 − y、角度取反。
---本卡的**内部角度全部保持 TH08 口径**（lf0 / lf1 / angleStep / 漂移角），只在
---出弹和出位移那一刻才取反 —— 因为原作那几条算式（POLAR_TO_CARTESIAN、
---SHOOT_CIRCLE、MOVE_RANDOM_IN_BOUNDS 的边界修正）全都是在 TH08 口径下写的。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---`ECL_OPERAND_ANGLE_TO_PLAYER` = Player::AngleToPoint（Player.cpp:967-980）
---= atan2(pl.y − self.y, pl.x − self.x)（TH08 口径）；两点重合时返回 +π/2。
local function aim_to_player_th08(owner)
    local dx = player.x - owner.x
    local dy = owner.y - player.y           -- = TH08 的 (pl.y − self.y)
    if dx == 0 and dy == 0 then
        return PI / 2
    end
    return math.atan2(dy, dx)
end

---根时间轴（单位 = ECL tick = 真帧；本卡没有慢动作）。
local ENTER_FRAMES, ENTER_Y = 110, 96        -- ins_64(110, 4, 192, 128)
local LOOP_T = 110                           -- 标签 Sub1_600
local WANDER_T = 240                         -- ins_67 / ins_51 所在的时间
local ROUND_END_T = 300                      -- ins_4(110, Sub1_600)
local EASING_OUT_QUAD = 4                    -- EclEasingMode（EclManager.hpp:519-526）
local WANDER_FRAMES, WANDER_SPEED = 60, 1.0  -- ins_67(60, 4, 1.0)
local LF2_0 = 0.18479957                     -- ins_7(lf2, 0.18479957)
local LF6_0, LF6_MAX = 4.0, 10.0             -- ins_7(lf6, 4) / ins_51 的 10

---三个发射器（子 context）的节拍与参数。
local DA = 0.18479957                        -- Sub2/Sub3 每拍 lf0 的步长
local STEP15 = 0.2617994                     -- Sub2/Sub3 的 angleStep（15°）
local SUB23_N, SUB23_R0, SUB23_DR = 64, 64.0, 2.0   -- ins_6([10036],64) / lf1=64 / −2
local SPIRAL_TICK = 2                        -- JUMP_DEC 在 t=2（每拍隔 2 帧）
local FAN_START, FAN_N, FAN_DIV = 60, 16, 1.5       -- Sub4 的第一条在 t=60、16 拍、÷1.5

---出弹参数（`ins_99`）。
local BURST_N = 4                            -- count2
local BURST_N1 = 1                           -- count1（SHOOT_CIRCLE 的一整圈个数）
local SPEED2 = 0.5                           -- speed2
local BIG_SPAWN, BIG_HALF = 31, 15           -- bulletType 20：script24 → 31 帧、30×30
local MID_SPAWN, MID_HALF = 25, 32           -- bulletType 10：script27 → 25 帧、64×64
local BIG_COLOR, MID_COLOR = 2, 1            -- TH08 色号 1 / 0 → 我们 +1

---同屏弹幕上限与出屏判据（见卡头注释）。
local POOL_SIZE = 1536                       -- BulletManager.hpp:455
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local AIM_MIN2 = 1024.0                      -- minimumPlayerDistanceSquared（32 px）²
---`ins_75(32, 48, 352, 128)` = SET_MOVEMENT_BOUNDS（Sub8 的 t=0）→ 我们坐标的夹框。
local BW_L, BW_R, BW_B, BW_T = 32, 352, 48, 128        -- TH08 口径（判据用）
local CLAMP_L, CLAMP_R = -160, 160                     -- 我们口径 = x − 192
local CLAMP_B, CLAMP_T = 96, 176                       -- 我们口径 = 224 − y

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）：把角卷进 (−π, π]。原作只对
---「自机在左」那一支做（EclDependencies.cpp:135-138），后面的符号判据全靠它 —— 必须照做。
local function norm_angle(a)
    while a > PI do a = a - 2 * PI end
    while a < -PI do a = a + 2 * PI end
    return a
end

---子 context 的小车：op = 出弹 / JUMP_DEC / RETURN。
local OP_SHOT, OP_DECJMP, OP_RET = 1, 2, 3
local SPIRAL_PROG = {
    { t = 0, op = OP_SHOT },                         -- 标签 Sub2_40 / Sub3_40
    { t = SPIRAL_TICK, op = OP_DECJMP, loopt = 0, target = 1 },
    { t = SPIRAL_TICK, op = OP_RET },
}
local FAN_PROG = {
    { t = FAN_START, op = OP_SHOT },                 -- 标签 Sub4_40
    { t = FAN_START + SPIRAL_TICK, op = OP_DECJMP, loopt = FAN_START, target = 1 },
    { t = FAN_START + SPIRAL_TICK, op = OP_RET },
}

local pool = {}          -- 本卡自己的弹池（≡ 原作的 1536 个弹槽）
local children = {}      -- 三份子 context：children[1..3]（nil = 没挂）
local BIG_CLS, MID_CLS   -- 两种弹的类（下面 make_bullet 造；root_step 会用到）

---IsWithinPlayfield（GameManager.cpp:132-152）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y, hw, hh)
    return x + hw < FIELD_L or x - hw > FIELD_R
            or y + hh < FIELD_B or y - hh > FIELD_T
end

---弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:809-816）。
---本卡一轮 832 发，所以就地压缩（等价于卡 215 的 table.remove 版，只是 O(n)）。
local function pool_used()
    local n = 0
    local m = #pool
    for i = 1, m do
        if IsValid(pool[i]) then
            n = n + 1
            if n ~= i then
                pool[n] = pool[i]
            end
        end
    end
    for i = m, n + 1, -1 do
        pool[i] = nil
    end
    return n
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---每帧 movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress；
---timer 到 0 时直接落在终点。本卡两处都用缓动 4 = OUT_QUADRATIC（2n − n²）。
local function move_step(mv)
    mv.t = mv.t + 1
    local u = mv.t / mv.n
    if u > 1 then
        u = 1
    end
    local e
    if mv.easing == EASING_OUT_QUAD then
        e = 1 - (1 - u) * (1 - u)
    else
        e = u
    end
    return mv.x0 + mv.dx * e, mv.y0 + mv.dy * e, mv.t >= mv.n
end

---本卡的弹。两种外观（占位 ball_big / ball_mid），SPAWN_FAST 出生动画。
local function make_bullet(style, color, spawn, half)
    return Class(bullet, {
        init = function(self, x, y, angle, speed)
            ---`bullet.init(self, imgclass, index, stay, destroyable)`：
            ---group = destroyable and 1 or 5、colli = true（THlib/bullet/bullet.lua:79-89）。
            bullet.init(self, style, color, false, true)
            self.b_angle = angle
            self.b_speed = speed
            self.b_vx = math.cos(angle) * speed
            self.b_vy = math.sin(angle) * speed
            ---SPAWN_FAST：出生瞬间位置退 velocity×4（BulletManager.cpp:226-228）。
            self.x, self.y = x - self.b_vx * 4, y - self.b_vy * 4
            self.vx, self.vy = 0, 0
            self.bound = false              -- 出屏回收由本卡自己按 IsWithinPlayfield 判（见卡头）
            self.colli = false              -- 出生动画期间没有判定（判定在 FIRED 分支里）
            self.b_spawn = spawn
            self.b_half = half
        end,
        frame = function(self)
            ---① 出生分支（BulletManager.cpp:946-966）：每帧只走 velocity/2。
            if self.b_spawn > 0 then
                self.b_spawn = self.b_spawn - 1
                self.vx, self.vy = self.b_vx / 2, self.b_vy / 2
                if self.b_spawn > 0 then
                    bullet.frame(self)
                    return
                end
                ---动画播完那一帧直接落到 FIRED 分支（`:966 goto activateBullet`）→
                ---这一帧既走了 velocity/2 又补一次完整的 FIRED。
                self.colli = true
            end
            ---② FIRED：变换程序是空的 → 只有 `position += velocity`。
            self.vx, self.vy = self.b_vx, self.b_vy
            bullet.frame(self)
            ---③ 出屏回收（BulletManager.cpp:856-899）：没有转向/反弹状态 → 出屏即回收。
            if outside_field(self.x, self.y, self.b_half, self.b_half) then
                object.RawDel(self)
            end
        end,
    })
end

---`ins_135(slot, sub)`：在同一只 BOSS 上再开一份 ECL context，变量块从父 context
---整块拷过来（EclRunHigh.inl:646-680）→ 三个发射器都继承了那一刻的 lf6（出弹初速）。
---  lf0  = 初始发射方向（TH08 口径）
---  da   = 每拍 lf0 的增量（TH08 口径）
---  step = 每次出弹的 angleStep（TH08 口径）
local function attach_child(owner, slot, lf0, da, step, cls, prog, cnt)
    children[slot] = { prog = prog, pc = 1, t = 0, a = lf0, r = SUB23_R0, cnt = cnt,
                       da = da, step = step, f6 = owner.lw219_lf6, cls = cls }
end

---子 context 的步进。返回 false = 这一帧返回（`ins_53`），调用方把它摘掉。
local function child_step(owner, c)
    local time = c.t
    while true do
        local ins = c.prog[c.pc]
        if ins == nil or ins.t ~= time then
            break
        end
        if ins.op == OP_SHOT then
            ---发射点 = worldPosition + shootOffset = BOSS + polar(lf0, lf1)（TH08 口径）。
            local ox = owner.x + math.cos(c.a) * c.r
            local oy = owner.y - math.sin(c.a) * c.r
            local pdx, pdy = player.x - owner.x, player.y - owner.y
            if pdx * pdx + pdy * pdy >= AIM_MIN2 then
                local used = pool_used()
                local j = 0
                while j < BURST_N and used < POOL_SIZE do
                    local ang_th = c.a + j * c.step
                    local spd = c.f6 - (c.f6 - SPEED2) * j / BURST_N
                    pool[#pool + 1] = New(c.cls, ox, oy, -ang_th, spd)
                    used = used + 1
                    j = j + 1
                end
            end
            ---`ins_16(lf1, 2)` 在出弹**之前**就减了，但偏移已经算过 → 下一拍才生效。
            c.r = c.r - SUB23_DR
            c.a = c.a + c.da
            c.pc = c.pc + 1
        elseif ins.op == OP_DECJMP then
            c.cnt = c.cnt - 1
            if c.cnt <= 0 then
                c.pc = c.pc + 1                 -- ≤0 不跳，落到 `ins_53`
            else
                time = ins.loopt                  -- `ins_5` 的第一个操作数
                c.pc = ins.target
            end
        else
            return false                        -- `ins_53` RETURN
        end
    end
    c.t = time + 1
    return true
end

---`ins_67` = MOVE_RANDOM_IN_BOUNDS（EclDependencies.cpp:128-191）：抽角度 +
---四条边界修正，然后 StartTimedPolarDisplacement（:105-126）：delta =
---(cos,sin)(angle)·speed·duration、origin = 当前 worldPosition、缓动 4、时长 60。
---★ 边界判据拿的是 **enemy->position**（TH08 口径）和 ins_75 设的那组边界
---  （32/48/352/128，见常量区）。「x > upper.x−96」那条还有一个原作自己的怪癖：
---  它把角度改写成 `π − enemy->movementAngle`，用的是**上一段的移动方向**，
---  不是刚抽到的 angle —— 照抄，别「修」成 angle。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local a
    if to_th08_x(player.x) < bx then
        a = norm_angle(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        a = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BW_L + 96 then
        if a > PI / 2 then
            a = PI - a
        elseif a < -PI / 2 then
            a = -PI - a
        end
    end
    if bx > BW_R - 96 then
        if a < PI / 2 and a >= 0 then
            a = PI - (owner.lw219_mv_angle or 0)
        elseif a > -PI / 2 and a <= 0 then
            a = -PI - a
        end
    end
    if by < BW_B + 48 and a < 0 then
        a = -a
    end
    if by > BW_T - 48 and a > 0 then
        a = -a
    end
    return a
end

---开一段漂移（StartTimedPolarDisplacement）。同时记下 UpdateMovement 会得到的
---movementAngle（TH08 口径）= atan2(dy, dx)，供下一次 `π − movementAngle` 那条怪癖用。
local function begin_move(owner, dx, dy, n, easing)
    owner.lw219_move = { x0 = owner.x, y0 = owner.y, dx = dx, dy = dy,
                         n = n, t = 0, easing = easing }
    ---位移恒 0（speed = 0 的 ins_67）时，UpdateMovement 每帧算出的 velocity 都是 0，
    ---movementAngle = VectorAngle(0, 0) = atan2(0,0) = **0**（ZunMath 里没有 0 向量守卫，
    ---那条约占守卫只在 Player::AngleToPoint，Player.cpp:974-977）。
    owner.lw219_mv_angle = math.atan2(-dy, dx)
end

local function begin_wander(owner)
    local a = wander_angle(owner)
    begin_move(owner, math.cos(a) * WANDER_SPEED * WANDER_FRAMES,
                      -math.sin(a) * WANDER_SPEED * WANDER_FRAMES,
                      WANDER_FRAMES, EASING_OUT_QUAD)
end

---BOSS 根时间轴的一条指令组。返回 true = 这一帧还要继续跑（`ins_4` 跳回循环体）。
local function root_step(owner, t)
    if t == LOOP_T then
        ---头一轮的 `ins_7` 批（lf4/lf7/lf6/lf2）—— 标签在它们后面，所以只跑这一次。
        if not owner.lw219_setup then
            owner.lw219_setup = true
            owner.lw219_lf2 = LF2_0
            owner.lw219_lf6 = LF6_0
        end
        local aim = aim_to_player_th08(owner)
        attach_child(owner, 1, aim + PI / 2, DA, -STEP15, BIG_CLS, SPIRAL_PROG, SUB23_N)
        attach_child(owner, 2, aim - PI / 2, -DA, STEP15, BIG_CLS, SPIRAL_PROG, SUB23_N)
        attach_child(owner, 3, aim + PI, owner.lw219_lf2, owner.lw219_lf2 / FAN_DIV,
                     MID_CLS, FAN_PROG, FAN_N)
        owner.lw219_lf2 = -owner.lw219_lf2      -- `ins_17(lf2, −1)`
    elseif t == WANDER_T then
        begin_wander(owner)                     -- `ins_67(60, 4, 1.0)`
        if owner.lw219_lf6 < LF6_MAX then       -- `ins_51(lf6, 10, 240, Sub1_824)`
            owner.lw219_lf6 = owner.lw219_lf6 + 1
        end
    elseif t == ROUND_END_T then
        owner.lw219_t = LOOP_T                  -- `ins_4(110, Sub1_600)`
        return true
    end
    return false
end

---BOSS 每帧。原作顺序：RunEcl（主 context → slot 0 → 1 → 2）→ UpdateMovement。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw219_t 还是 nil（卡 205..218 同款守卫）。
    if owner.lw219_t == nil then
        return
    end
    ---① 根时间轴（含 t=300 那条跳回 t=110）——同一帧里可能跑好几个指令组。
    local guard = 0
    while root_step(owner, owner.lw219_t) do
        guard = guard + 1
        if guard > 8 then
            break
        end
    end
    owner.lw219_t = owner.lw219_t + 1
    ---② 三份子 context 依次跑（t=110 刚挂上的那几份，同一帧就跑到自己的 t=0）。
    for slot = 1, 3 do
        local c = children[slot]
        if c ~= nil then
            if not child_step(owner, c) then
                children[slot] = nil
            end
        end
    end
    ---③ 根自己的插值位移（RunEcl 之后才 UpdateMovement）。
    local mv = owner.lw219_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw219_move = nil
        end
    end
    ---④ ClampPosition（EnemyManager.cpp:803-819）：ins_75 置了 CLAMP_POSITION，
    ---   原作每帧在位移前后各钳一次（EnemyManagerUpdate.cpp:172-174）；位移只在这儿变，
    ---   所以末尾钳一次等价。
    if owner.x < CLAMP_L then owner.x = CLAMP_L
    elseif owner.x > CLAMP_R then owner.x = CLAMP_R end
    if owner.y < CLAMP_B then owner.y = CLAMP_B
    elseif owner.y > CLAMP_T then owner.y = CLAMP_T end
end

local function card_init(owner)
    owner.lw219_t = 0
    owner.lw219_lf2 = 0
    owner.lw219_lf6 = LF6_0
    owner.lw219_setup = false
    ---Sub8 t=0 的 `ins_63(192, 128)` = SET_POSITION → 我们 (0, 96)，BOSS 原地出现。
    ---根头一条 `ins_64(110, 4, 192, 128)` 的目标是同一点 → 插值位移恒 0
    ---（所以不建入场位移；建了也会被 ins_75 的夹框在 y = 176 处拉回来）。
    owner.x, owner.y = 0, ENTER_Y
    ---位移恒 0 的插值算出的 movementAngle = atan2(0, 0) = 0（见 begin_move 的注释）。
    owner.lw219_mv_angle = 0
end

local function card_del(owner)
    owner.lw219_t = nil
    owner.lw219_setup = nil
    owner.lw219_move = nil
    owner.lw219_lf2 = nil
    owner.lw219_lf6 = nil
    owner.lw219_mv_angle = nil
    for i = 1, 3 do
        children[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

BIG_CLS = make_bullet(ball_big, BIG_COLOR, BIG_SPAWN, BIG_HALF)
MID_CLS = make_bullet(ball_mid, MID_COLOR, MID_SPAWN, MID_HALF)

CARD[219] = {
    init = function(owner)
        pool = {}
        children = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 220「西行寺无余涅槃」（西行寺幽幽子）
---  ecldata_yy.ecl：Sub11 = 生成助手（BOSS 入场）、Sub1 = BOSS 根（130 条指令）、
---    Sub2 / Sub3 = 「车轮环」（字节级只差调用方给的 ci1 色号）、Sub4 = 环、
---    Sub7 = 副环、Sub5 / Sub6 = 两台**独立敌人**当对转激光扇。
---
---  ★ ins_52 CALL 的语义（EclDependencies.cpp:472-500 + :509-535，必读）：
---    CALL 先把**调用方整份 context 压栈**（连 currentInstr 都写成 CALL 的下一条），
---    再让子程序复用同一份 context；`ins_53 RETURN` 把压栈的那份**整块拷回来**。
---    ⇒ 子程序对 intVariables / floatVariables / extraInt* 的写入**全部作废**，
---      它是**纯函数**，只能通过 ci0..3 / cf0..3 拿到参数 —— CALL 那一刻会把全局
---      g_EclCallParameters（= 调用方写进 sci0..3 / scf0..3 的共享调用参数）
---      整块拷进 callee 的 callParameterInts/Floats。
---    ⇒ 所以根里 `lf0 += lf4` 的累加**不会**被 Sub2 的 `lf0 = 0.16` 冲掉：
---      六个环组的角度是 lf0 = RANDOM_ANGLE + k·(π/li2)（每一轮现抽、半档半步铺开）。
---  ★ ins_94 = SPAWN_ENEMY_RELATIVE（EclRunHigh.inl:812-845 → SpawnEnemy2，
---    EnemyTimeline.cpp:64-116）走的是**另一只敌人**：位置 = 父 worldPosition + 偏移
---    （这里偏移恒 (0,0)），并把父 context 的 intVariables..callParameterFloats 整块
---    0x78 字节拷过去（EnemyTimeline.cpp:93-95）⇒ 两台发射器读到的是那一刻的
---    **ci0 = li3/2**（= 3、4、5… 逐轮 +1）。它们是独立敌人（自己跑 Sub5/Sub6、
---    自己计时、spawnTemplate 没有任何 anm 脚本 → 不画东西），本卡用独立对象实现。
---
---  一轮 = 415 帧（t=170 起、t=585 的 `ins_4 JUMP(170, −1848)` 拨回 **#36**
---  = 循环体第一条 `lf0 = RANDOM_ANGLE`，跳转把 context time 也写成 170 ⇒
---  **同一帧**就从 t=170 继续，也就是 #29..#35 那七条初始化**只在第一轮**跑）：
---    t=0..109   Sub11 把 BOSS 放在 TH08 (192,128) = 我们 (0,96)；根 `ins_64(110,4,192,128)`
---               原地插值（位移恒 0，但插值算出的 movementAngle 会被 t=430 的 ins_67 读到）。
---    t=110      `ins_64(60,4,192,112)`：60 帧 OUT_QUAD 下移到我们 (0,112)。
---    t=170 轮首  夹框换成 `ins_75(128,96,256,128)`（我们 x∈[−64,64]、y∈[96,128]）；
---               lf0 = RANDOM_ANGLE、li2 = 20、li3 = 6；
---               ci0 = ⌊li3/2⌋ → **当场 ins_94 生成 Sub5（色 4）+ Sub6（色 8）两台发射器**；
---               sci0 = li2、sci1 = 3、scf0/1/2 = (lf0, lf1, lf2) → CALL Sub2；
---               然后 lf4 = π/li2
---    t=180..220 每 10 帧：lf0 += lf4（+ 归一化）、sci1 在 2/3 之间交替 → CALL Sub3/Sub2
---    t=340..430 每 30 帧：sci0 = 24/26/28/30、sci1 = 1、scf0 = RANDOM_ANGLE（现抽）、
---               scf1 = ±0.005235988 / ±0.01047198（弹自己边飞边转）、scf2 = 0.8 → CALL Sub4
---    t=430      `ins_67(60, 0, 0.2)`：抽方向 + 四条边界修正后在夹框里线性漂 12 px
---    t=490      sci0 = 24、sci1 = 0、scf0 = π/2、scf1 = 0、scf2 = lf2 → CALL Sub7；
---               然后 lf2 += 0.08、li2 += 3、li3 += 2 → 下一轮更密、更快、光柱更多
---    t=585      `ins_4(170, −1848)` → 同一帧下一轮
---  ★ li3 逐轮 +2 ⇒ 发射器每次的 xi0 = ⌊li3/2⌋ 从 3 起逐轮 +1；全场只有 14 轮
---    （170+415×13 = 5565 < 5940 = ins_134 的时限），所以 xi0 最大正好 16 = 原作
---    `Enemy::laserSlots[16]` 的容量 —— 不是巧合。
---
---  ★ Sub2 / Sub3 / Sub4 / Sub7 的字节（SET_BULLET_TRANSFORM 的字段序 =
---  BulletTransformInstructionArgs：transformIndex, kind, allowWhileActive,
---  int0, int1, float0, float1，EclRunHigh.inl:78-91）：
---    records[0] = POLAR(speedDelta 0.01, angleDelta = **cf1**, 120)
---    records[1] = SET_CULL_DELAY(200)（allowWhileActive = 1 → 当场流过、不占状态）
---    records[2] = VECTOR(magnitude = 子程序里的 lf0, angle = −999 → 自身角, 80)
---    allowWhileActive = 0 ⇒ 必须等 POLAR 结束、activeTransformFlags 归零才装上
---    （BulletManager.cpp:321-337）。每帧顺序：AdvanceTransformProgram（:310-478）
---    → UpdateVectorAcceleration（:1205-1227）/ UpdatePolarAcceleration（:1229-1252）
---    → 出屏计时 −1 → position += velocity（:856-858）→ 出屏回收（:858-899）。
---    transformFlags = **8752 = 0x2230** = VECTOR(0x10) | POLAR(0x20) | SPAWN_SOUND(0x200)
---    | SET_CULL_DELAY(0x2000)：**没有 2/4/8** ⇒ 出生就是 FIRED、位置不退、不走出生动画
---    （BulletManager.cpp:215-235 三条 else-if 全不命中）—— 这一点和卡 205..219 里的
---    SPAWN_FAST 弹完全不同。
---  ★ 出弹参数（ShotArgs 字段序 = bulletType|color, count1, count2, speed1, speed2,
---    angle, angleStep, transformFlags，EclDependencies.cpp:677-691；operandFlags 的
---    位 0..7 依次对应这八个操作数，:700-750）：
---      Sub2/Sub3（SHOOT_CIRCLE）：count1 = ci0、count2 = 1、speed1 = **cf2**、
---        angle = cf0、angleStep = π/4（count2 = 1 时**用不上**）、bulletType = 8、
---        color = **ci1**（→ 调用方交替给 3 / 2）
---      Sub4（SHOOT_CIRCLE）：count1 = ci0、count2 = 2、speed1 = cf2、speed2 = 0.3、
---        angleStep = 0
---      Sub7（SHOOT_OFFSET_CIRCLE）：count1 = ci0、count2 = 1、speed1 = cf2、
---        bulletType = 10、color = ci1(=0)；角度 = π/ci0 + i·2π/ci0 + cf0
---  ★ xi0（子程序 #2 的 `SET_INT [10036], N`）= Sub2/3/4 是 4、Sub7 是 3，而 JUMP_DEC
---    的 loop 时间是 **0** ⇒ 4 圈**全在同一帧**甩出来（EclRun.cpp:53-104 的
---    `time.current = operand0` + `time == instruction->time` 判据），每圈只差
---    records[2] 的 magnitude：lf0 从 0.16 起每拍 −0.0816667（Sub4 是 −0.054、
---    Sub7 是 −0.0825）⇒ 同心的四层环，后两层会减速、停住、再往回倒飞。
---  ★ 同屏上限 1536（全游戏共用，BulletManager.hpp:455）：`activeBulletCount >= 0x600`
---    整条 ins_99 不生（BulletManager.cpp:692），波中间空槽用完就**放弃这一波剩下的**
---    （:698-712）。本卡一轮就要 1632 发（车轮 6 组 × 4 圈 × li2=20 = 480、扇 5 拍 ×
---    (24+26+28+30) × 2 = 1080、Sub7 3 圈 × 24 = 72），而 records[1] 给了 200 帧出屏
---    宽限 ⇒ 弹池从第一轮起就长期饱和，后面的波大半生不出来。这里照做：卡片自己的
---    pool 就是那 1536 个槽（含「出屏宽限」）。
---  ★ 光柱（ins_114，LaserSpawnArgs 字段序见 EclRunHigh.inl:60-79）：bulletType 1、
---    color 4 / 8、angle = lf2、speed 0、startOffset 64、endOffset 448、startLength 448、
---    width 16、startTime 120、duration 120、despawn 60、hitboxStartTime 90、
---    hitboxEndDelay 30、transformFlags 0。
---    原作的判定盒（BulletManager.cpp:1060-1075 + Player.cpp:396-431）= 在**激光系**里
---    以 origin + (256, 0) 为中心、长 384×0.7 = 268.8、宽 width/2 = 8（半宽 4）的矩形
---    ⇒ 相对 origin 的满宽段 = [121.6, 390.4]。
---    THlib 的 laser 用 l1/l2/l3 三段画、判定半宽 = w/2（THlib/laser/laser.lua:88-105），
---    所以这里取 w = **8**（半宽 4，和原作一致）、l1 = l3 = 57.6、l2 = 268.8，
---    并把起点放到 BOSS + 64 px 处 ⇒ 满宽判定段正好是 [121.6, 390.4]，画出来总长 384。
---    ★ rot 必须填**角度制**（THlib 的 laser 拿引擎的 cos/sin 画和判，都是角度制）。
---  ★ 占位贴图：bulletType 8（etama sprite120，32×32）= ball_mid、bulletType 10
---    （sprite168，64×64）= ball_big、光柱 = THlib 的 laser、发射器不可见（"white" + α=0）。
---    ★ 17 张全部实现完之后再统一换素材。
---
---  ★ 两台发射器（Sub5 / Sub6）的字节：
---    xi0 = ci0；lf1 = π/ci0、lf2 = lf1/2、lf0 = π/2 ± lf2、lf1 += lf1（⇒ 2π/ci0）；
---    #7..#15 循环 ci0 拍（**每拍 1 帧**，JUMP_DEC 的 loop 时间是 0、指令自己的 time 是 0
---    ⇒ 同一帧跑完）：lf2 = lf0 ± π/3（归一化）→ SELECT_LASER_SLOT(li1) → CREATE_LASER
---    → li1++ → lf0 += lf1；
---    之后 xi1 = 60、`ins_36` 在 lf0 上装线性插值（起点 0、终点 ∓π/3、时长 60、缓动 4）、
---    lf0 = lf1 = 0、xi0 = ci0、li1 = 0；
---    #20..#26 循环 ci0 拍：lf2 = lf0 − lf1、lf1 = lf0、ROTATE_LASER(li1, lf2)、li1++；
---    #27 `JUMP_DEC(0, −144, xi1)` 的指令 time = **1** ⇒ 每真帧转一次、共 60 次，
---    xi1 减到 0 那一帧落 `ins_1 TERMINATE`（**那一帧不转**）⇒ 发射器活 61 帧。
---  ★ 因此两台发射器各甩一个**整圆**光柱（xi0 条均分 2π），Sub5 与 Sub6 的整圆互相错开
---    ±(π/3 + π/(2xi0))，随后 60 帧里两个圆一起转 ∓60°（缓动 OUT_QUAD）—— 对转双环。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x − 192、y' = 224 − y、角度整体取反。
---本卡的**内部角度一律保持 TH08 口径**（lf0 / lf1 / lf2 / cf0 / cf1 / RANDOM_ANGLE），
---只在出弹、放光柱、算位移那一刻才换算 —— 因为原作那几条算式（SHOOT_CIRCLE、
---SHOOT_OFFSET_CIRCLE、MOVE_RANDOM_IN_BOUNDS 的边界修正）全是在 TH08 口径下写的。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）：把角卷进 (−π, π]。
local function norm_angle(a)
    while a > PI do a = a - 2 * PI end
    while a < -PI do a = a + 2 * PI end
    return a
end

---同屏弹幕上限（全游戏共用）与出屏判据，见文件头与卡头。
local POOL_SIZE = 1536                    -- `Bullet bullets[0x601]`（BulletManager.hpp:455）
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---IsWithinPlayfield（GameManager.cpp:132-152）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y, hw, hh)
    return x + hw < FIELD_L or x - hw > FIELD_R
            or y + hh < FIELD_B or y - hh > FIELD_T
end

---一轮的节拍（全部来自 Sub1 的裸字节）。
local ROUND_T, ROUND_END = 170, 585       -- 轮首 / `ins_4(170, −1848)` 所在帧
local ENTER_Y = 96                        -- Sub11 `ins_63(192,128)`
local MOVE_T, MOVE_FRAMES, MOVE_Y = 110, 60, 112   -- `ins_64(60,4,192,112)`
local WHEEL_AT = { [180] = 1, [190] = 2, [200] = 3, [210] = 4, [220] = 5 }
---每拍的 sci1（Sub2 拿 3、Sub3 拿 2），按 Sub1 #41/#50/#58/#66/#74/#82 的顺序抄：
---t=170 → 3、t=180 → 2、t=190 → 3、t=200 → 2、t=210 → 3、t=220 → 2。
local WHEEL_CI1 = { 2, 3, 2, 3, 2 }       -- 对应 t=180 / 190 / 200 / 210 / 220
local FAN_AT = { [340] = 1, [370] = 2, [400] = 3, [430] = 4 }
local FAN_COUNT = { 24, 26, 28, 30 }      -- Sub4 的 ci0
local FAN_DANGLE = { 0.005235988, -0.005235988, 0.010471976, -0.010471976 }  -- Sub4 的 cf1
local FAN_SPEED = 0.8                     -- Sub4 的 cf2
local WANDER_T = 430                      -- `ins_67` 所在帧（t=430）
local SUB7_T = 490
local SUB7_COUNT, SUB7_ANGLE = 24, PI / 2 -- Sub7 的 ci0 / cf0
local LF2_0, LF2_STEP = 0.5, 0.08
local LI2_0, LI2_STEP = 20, 3
local LI3_0, LI3_STEP = 6, 2
local EASING_LINEAR, EASING_OUT_QUAD = 0, 4   -- EclEasingMode（EnemyManager.cpp:283-310）
local WANDER_FRAMES, WANDER_SPEED = 60, 0.2   -- `ins_67(60, 0, 0.2)`
---`ins_75(128,96,256,128)` = SET_MOVEMENT_BOUNDS(lower.x, lower.y, upper.x, upper.y)
---（EclRunLow.inl:623-634）⇒ 原作口径 lower = (128, 96)、upper = (256, 128)。
---本卡 y 上边界 96、下边界 128，所以 `±48` 那两条恒成立（照抄，别「修」）。
---同一组数我们口径下就是夹框（见 CLAMP_*）。
local BX_L, BX_R, BY_T, BY_B = 128, 256, 96, 128
local CLAMP_L, CLAMP_R, CLAMP_B, CLAMP_T = -64, 64, 96, 128

---出弹描述符（Sub2/3/4/7 共用）。records[0] 的 speedDelta 0.01 / 120 帧、
---records[1] 的 200 帧出屏宽限、records[2] 的 80 帧，四个子程序字节级完全一样。
local SHOT_POLAR_DELTA, SHOT_POLAR_FRAMES = 0.01, 120
local SHOT_VEC_FRAMES = 80
local CULL_DELAY = 200
local MAG0 = 0.16                        -- 每个子程序开头的 lf0
local MAGD_23, MAGD_4, MAGD_7 = 0.081666663, 0.054, 0.0825
local ITER_23, ITER_4, ITER_7 = 4, 5, 3  -- 子程序的 xi0
local STEP23 = PI / 4                    -- Sub2/3/7 的 angleStep（count2 = 1 时用不上）
local SUB4_COUNT2, SUB4_SPEED2 = 2, 0.3  -- Sub4 的 count2 / speed2
local HALF23, HALF4, HALF7 = 16, 16, 32  -- bulletType 8 → 32×32、10 → 64×64（占位贴图另说）
---TH08 色号 → 我们的 COLOR（1..16；TH08 0..7 一一对应 +1）。
local function th08_color(c) return c + 1 end
---Sub2 / Sub3 的弹色（= 子程序的 ci1）：3 / 2。色号烘在弹类里，所以要两个类。
local COLOR_WHEEL_A, COLOR_WHEEL_B = th08_color(3), th08_color(2)  -- Sub2 / Sub3
local COLOR_FAN, COLOR_SUB7 = th08_color(1), th08_color(0)

---光柱（`ins_114`，见卡头）。
local LASER_X0 = 64                      -- startOffset：光柱起点离 BOSS 64 px
local LASER_BODY = 268.8                 -- (448 − 64) × 0.7：原作的判定盒长度
local LASER_TAIL = 57.6                  -- (448 − 64 − 268.8)/2：两端收尾
local LASER_W = 8                        -- THlib 的 w：判定半宽 = w/2 = 4（= 原作 width/4）
local LASER_W0 = 0.6                     -- STARTING 段的细线（原作 1.2，我们减半，见卡头）
local LASER_START, LASER_RAMP = 120, 30
local LASER_DURATION, LASER_DESPAWN = 120, 60
local LASER_HIT_START, LASER_HIT_DELAY = 90, 30
local LASER_SPIN_FRAMES = 60             -- Sub5/6 的 xi1 = 60
local LASER_SPACING = 1.0471976          -- Sub5/6 里硬编码的 π/3
local LASER_COLOR_NEG, LASER_COLOR_POS = th08_color(4), th08_color(8)
local LASER_POOL = 256                    -- `Laser lasers[0x100]`（BulletManager.cpp:748）

---本卡的登记表：弹（≡ 原作那 1536 个弹槽）、光柱、两台发射器（每轮新建）。
local pool = {}
local lasers = {}
local emitters = {}

---弹槽计数：原作的 activeBulletCount 数是**所有非空弹槽**（BulletManager.cpp:809-817），
---所以出屏回收过的弹（state = UNUSED）就不算了。这里就地压缩。
local function pool_used()
    local n = 0
    local m = #pool
    for i = 1, m do
        if IsValid(pool[i]) then
            n = n + 1
            if n ~= i then pool[n] = pool[i] end
        end
    end
    for i = m, n + 1, -1 do pool[i] = nil end
    return n
end

local function laser_used()
    local n = 0
    local m = #lasers
    for i = 1, m do
        if IsValid(lasers[i]) then
            n = n + 1
            if n ~= i then lasers[n] = lasers[i] end
        end
    end
    for i = m, n + 1, -1 do lasers[i] = nil end
    return n
end

local bullet_cls_23a, bullet_cls_23b, bullet_cls_4, bullet_cls_7
local laser_cls
local emitter_neg_cls, emitter_pos_cls

---AdvanceTransformProgram（BulletManager.cpp:310-478）的三条 record：
---  0 → POLAR（装上就把 index 推到 1）
---  1 → SET_CULL_DELAY(200)：allowWhileActive = 1 ⇒ 不占状态、当场流过（:419-421）
---  2 → VECTOR：allowWhileActive = 0 ⇒ 只在 activeTransformFlags 归零后才装上（:321-323）
local function lw220_advance(self)
    if self.lw_ti == 0 then
        self.lw_polar, self.lw_t = true, 0
        self.lw_ti = 1
        return
    end
    if self.lw_ti == 1 then
        self.lw_cull = CULL_DELAY
        self.lw_ti = 2
    end
    if self.lw_ti == 2 then
        if self.lw_polar or self.lw_vec then
            return
        end
        self.lw_vec, self.lw_t = true, 0
        ---`vector.FromAngleMagnitude(angle, magnitude)`：方向在**装上的那一刻**定死
        ---（record 的 angle = −999 < −990 ⇒ 用当时的自身角，:342-355）。
        self.lw_vvx = math.cos(self.lw_ang) * self.lw_mag
        self.lw_vvy = -math.sin(self.lw_ang) * self.lw_mag
        self.lw_ti = 3
    end
end

---本卡的弹。半尺寸只给出屏回收用（原作那 200 帧宽限让弹离场后还占着槽）。
local function make_bullet(style, color, half)
    return Class(bullet, {
        init = function(self, x, y, angle, speed, mag, angle_delta)
            ---`bullet.init(self, imgclass, index, stay, destroyable)`（THlib/bullet/bullet.lua:79-89）
            bullet.init(self, style, color, false, true)
            self.lw_ang = angle                 -- 自身角（TH08 口径、弧度）
            self.lw_spd = speed
            self.lw_pd = angle_delta or 0       -- records[0] 的 angleDelta = cf1
            self.lw_mag = mag
            self.lw_ti, self.lw_t = 0, 0
            self.lw_polar, self.lw_vec = false, false
            self.lw_cull = 0
            self.lw_half = half
            ---没有 SPAWN_FAST/NORMAL/SLOW ⇒ 出生就是 FIRED：位置不退、当帧就走一次
            ---velocity（BulletManager.cpp:172-186、215-235）。
            self.vx = math.cos(angle) * speed
            self.vy = -math.sin(angle) * speed
            self.bound = false                  -- 出屏回收自己按 IsWithinPlayfield 判
            lw220_advance(self)                 -- 出生帧先跑一次（BulletManager.cpp:250）
        end,
        frame = function(self)
            ---① AdvanceTransformProgram
            lw220_advance(self)
            ---② 加速状态（:822-834，顺序照抄：VECTOR 在 POLAR 前）
            if self.lw_vec then
                if self.lw_t >= SHOT_VEC_FRAMES then
                    self.lw_vec = false
                else
                    self.vx = self.vx + self.lw_vvx
                    self.vy = self.vy + self.lw_vvy
                    if math.abs(self.vx) > 0.0001 or math.abs(self.vy) > 0.0001 then
                        self.lw_ang = math.atan2(-self.vy, self.vx)
                    end
                end
                self.lw_t = self.lw_t + 1
            end
            if self.lw_polar then
                if self.lw_t >= SHOT_POLAR_FRAMES then
                    self.lw_polar = false
                else
                    self.lw_ang = norm_angle(self.lw_ang + self.lw_pd)
                    self.lw_spd = self.lw_spd + SHOT_POLAR_DELTA
                    self.vx = math.cos(self.lw_ang) * self.lw_spd
                    self.vy = -math.sin(self.lw_ang) * self.lw_spd
                end
                self.lw_t = self.lw_t + 1
            end
            ---③④ 出屏宽限计时与回收（:856-899）。原作的顺序是
            ---   `--offscreenCullDelayFrames` → `position += velocity` → 判 IsWithinPlayfield，
            ---   而位置积分由引擎在 frame 之后做 ⇒ 这里用「本帧末」的位置 (x+vx, y+vy) 判，
            ---   和原作逐帧一致。本卡的弹没有转向/反弹状态（改向/反弹那几位都没装），
            ---   所以计时归零后一出屏就当帧回收（:877-886 的 else 分支）。
            if self.lw_cull ~= 0 then
                self.lw_cull = self.lw_cull - 1
            end
            if self.lw_cull == 0
                    and outside_field(self.x + self.vx, self.y + self.vy,
                                      self.lw_half, self.lw_half) then
                object.RawDel(self)
                return
            end
            bullet.frame(self)
        end,
    })
end

---光柱（`ins_114`）。状态机照 BulletManager.cpp:1082-1150 抄；
---`alpha = 1` 是 THlib laser:frame 开判定的条件（THlib/laser/laser.lua:91）。
laser_cls = Class(laser, {
    init = function(self, x, y, ang_th, color)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）
        ---第一位在 THlib 里就是**颜色**（贴图组 1..16）；rot 要**角度制**。
        laser.init(self, color, x, y, -ang_th * RAD,
                   LASER_TAIL, LASER_BODY, LASER_TAIL, LASER_W0, 0, 0)
        self.lw_state, self.lw_t = 1, 0
        self.alpha = 1
        self.colli = false            -- 判定要等 hitboxStartTime（90）才开
        ---★ 光柱的寿命只由它自己的状态机决定：原作把这 256 条光柱存在固定槽位里，
        ---  槽位要到状态机跑完才释放（BulletManager.cpp:1049-1150），光柱**不会**因为
        ---  起点在场外就被回收。不关 bound 的话，起点出界的那些会被引擎立刻收掉。
        self.bound = false
    end,
    frame = function(self)
        local t = self.lw_t
        if self.lw_state == 1 then
            ---STARTING：前 90 帧一根 1.2 宽的细线，最后 30 帧胀到满宽（:1082-1097）
            local ramp = LASER_START > LASER_RAMP and LASER_RAMP or LASER_START
            if LASER_START - ramp < t then
                self.w = t * LASER_W / LASER_START
            else
                self.w = LASER_W0
            end
            self.colli = t >= LASER_HIT_START
            if t >= LASER_START then
                ---原作这里不 break，同帧就落进 ACTIVE（:1100-1104）
                self.lw_state = 2
                self.w = LASER_W
                self.colli = true
                self.lw_t = 0
                t = 0
            end
        end
        if self.lw_state == 2 then
            self.w = LASER_W
            self.colli = true
            if t >= LASER_DURATION then
                self.lw_state = 3
                self.lw_t = 0
                t = 0
            end
        end
        if self.lw_state == 3 then
            ---DESPAWNING：宽度线性收到 0，前 30 帧仍有判定（:1117-1140）
            self.colli = t < LASER_HIT_DELAY
            self.w = LASER_W - t * LASER_W / LASER_DESPAWN
            if t >= LASER_DESPAWN then
                object.RawDel(self)
                return
            end
        end
        self.lw_t = t + 1
        laser.frame(self)
    end,
})

---Sub5（dir = +1）/ Sub6（dir = −1）：`ins_94` 生成的两台**独立敌人**。
---参数 xi0 = ci0 = ⌊li3/2⌋（父 context 在 ins_94 那一刻的 ci0）。
local function make_emitter(dir, color)
    return Class(object, {
        init = function(self, x, y, xi0)
            self.x, self.y = x, y
            self.group, self.layer = GROUP.INDES, LAYER.ENEMY_BULLET
            self.img = "white"
            self._blend, self._a = "", 0   -- 不可见（占位）
            self.colli = false
            self.bound = false
            self.navi = false
            self.rot = 0
            self.lw_n = xi0                -- xi0 = ci0
            self.lw_t = 0
            self.lw_f0, self.lw_f1 = 0, 0  -- lf0 / lf1
            self.lw_slots = {}             -- ≡ 原作的 `laserSlots[16]`
            self.lw_interp = nil
        end,
        frame = function(self)
            local t = self.lw_t
            ---#27 的 xi1 减到 0 → 落 `ins_1 TERMINATE`：**这一帧不跑**旋转循环（见卡头）
            if t >= LASER_SPIN_FRAMES then
                object.RawDel(self)
                return
            end
            if t == 0 then
                ---#1..#15：本帧把 xi0 条光柱一次排满（JUMP_DEC 的 loop 时间是 0）
                local n = self.lw_n
                local lf0 = PI / 2 + dir * (PI / n) * 0.5   -- #2/#3/#4
                local lf1 = (PI / n) * 2                    -- #5 `lf1 += lf1`
                for k = 1, n do
                    local lf2 = norm_angle(lf0 + dir * LASER_SPACING)   -- #10/#11
                    ---原作 SpawnLaserPattern 是**找空槽**（BulletManager.cpp:744-790）：
                    ---256 个槽都占着就直接不生成（本卡实际最多几十条，不触顶，照抄兜底）。
                    if laser_used() < LASER_POOL then
                        local r = -lf2 * RAD
                        local lx = self.x + LASER_X0 * cos(r)
                        local ly = self.y + LASER_X0 * sin(r)
                        local l = New(laser_cls, lx, ly, lf2, color)
                        self.lw_slots[k] = l
                        lasers[#lasers + 1] = l
                    end
                    lf0 = norm_angle(lf0 + lf1)                          -- #13/#14
                end
                ---#17 `ins_36`：在 lf0 上装线性插值（起点 0、终点 −dir·π/3、时长 60、缓动 4），
                ---回调在**帧尾**（EclRun.cpp:130-198）；#18/#19 把 lf0/lf1 清零。
                self.lw_interp = { t = 0, n = LASER_SPIN_FRAMES, endv = -dir * LASER_SPACING }
                self.lw_f0, self.lw_f1 = 0, 0
            else
                ---#20..#26：lf2 = lf0 − lf1（本帧的转角）、再把 lf1 跟上，
                ---然后按 li1 = 0..xi0−1 把 xi0 条光柱**一起**转（ROTATE_LASER = 角度相加）。
                local delta = self.lw_f0 - self.lw_f1
                self.lw_f1 = self.lw_f0
                if delta ~= 0 then
                    local d = -delta * RAD      -- 我们的 rot 是角度制、且角度整体取反
                    for k = 1, self.lw_n do
                        local l = self.lw_slots[k]
                        if IsValid(l) then
                            l.rot = l.rot + d
                        end
                    end
                end
            end
            local ip = self.lw_interp
            if ip then
                ip.t = ip.t + 1
                if ip.t > ip.n then ip.t = ip.n end
                local p = ip.t / ip.n
                p = 1 - (1 - p) * (1 - p)       -- ECL_EASING_OUT_QUADRATIC
                self.lw_f0 = ip.endv * p
            end
            self.lw_t = t + 1
        end,
    })
end

---一次 `ins_99` / `ins_101`（BulletManager.cpp:685-790）：
---角度按 aimMode 算、速度按 count2 插值、创建顺序 j 在外 i 在内。
---  offset_circle = true 时按 OFFSET_CIRCLE（π/count1 + i·2π/count1 + angle，**不吃** angleStep）
local function spawn_shot(owner, cls, count1, count2, speed1, speed2,
                          angle, angle_step, angle_delta, offset_circle, mag)
    local used = pool_used()
    if used >= POOL_SIZE then
        return                          -- 池满：整条 ins_99 不生（BulletManager.cpp:692）
    end
    for j = 0, count2 - 1 do
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then
                return                  -- 空槽用完：放弃这一波剩下的（:698-712）
            end
            ---`descriptor->position = enemy->worldPosition + shootOffset`，本卡偏移恒 0
            local x, y = owner.x, owner.y
            local spd
            if count2 > 1 then
                spd = speed1 - (speed1 - speed2) * j / count2
            else
                spd = speed1
            end
            local a
            if offset_circle then
                a = PI / count1 + i * (2 * PI) / count1 + angle
            else
                a = i * (2 * PI) / count1 + j * angle_step + angle
            end
            used = used + 1
            pool[used] = New(cls, x, y, norm_angle(a), spd, mag, angle_delta)
        end
    end
end

---Sub2 / Sub3（车轮环）：xi0 = 4 ⇒ **同一帧**甩出 4 圈同心环，
---records[2] 的 magnitude 依次 0.16 / 0.0783333 / −0.0033333 / −0.085。
local function wheel_shot(owner, cls, count1, angle, speed)
    local mag = MAG0
    for _ = 1, ITER_23 do
        spawn_shot(owner, cls, count1, 1, speed, 0, angle, STEP23, 0, false, mag)
        mag = mag - MAGD_23
    end
end

---Sub4（环）：xi0 = 5 圈，每圈 count2 = 2（速度 0.8 / 0.55）、angleStep = 0，
---cf1 让弹自己每帧转 ±0.005235988 / ±0.010471976 弧度（120 帧 = ±36° / ±72°）。
local function fan_shot(owner, count1, angle, angle_delta, speed)
    local mag = MAG0
    for _ = 1, ITER_4 do
        spawn_shot(owner, bullet_cls_4, count1, SUB4_COUNT2, speed, SUB4_SPEED2,
                   angle, 0, angle_delta, false, mag)
        mag = mag - MAGD_4
    end
end

---Sub7（副环）：xi0 = 3 圈、bulletType 10（64×64）、OFFSET_CIRCLE。
local function sub7_shot(owner, count1, color, angle, speed)
    local mag = MAG0
    for _ = 1, ITER_7 do
        spawn_shot(owner, bullet_cls_7, count1, 1, speed, 0, angle, STEP23, 0, true, mag)
        mag = mag - MAGD_7
    end
end

---插值位移的一步（EnemyManager.cpp:84-121 的 INTERPOLATED 分支）：
---`movementTimer--` → `progress = 1 − timer/duration` → 套缓动 → position = origin + delta·progress；
---timer 归零那一帧直接落在终点、velocity 清零。
local function move_step(mv)
    mv.t = mv.t + 1
    local u = mv.t / mv.n
    if u > 1 then u = 1 end
    local e
    if mv.easing == EASING_OUT_QUAD then
        e = 1 - (1 - u) * (1 - u)
    else
        e = u
    end
    return mv.x0 + mv.dx * e, mv.y0 + mv.dy * e, mv.t >= mv.n
end

---`ins_67` = MOVE_RANDOM_IN_BOUNDS（EclDependencies.cpp:128-191）：抽角度 +
---四条边界修正，然后 StartTimedPolarDisplacement（:105-126）。
---★ 边界判据拿的是 **enemy->position**（TH08 口径）和 `ins_75` 设的那组边界
---  （128/96/256/128，见常量区）。「x > upper.x−96」那条还有一个原作自己的怪癖：
---  它把角度改写成 `π − enemy->movementAngle`，用的是**上一段的移动方向**
---  （本卡 = t=110 那次 ins_64 的下移 ⇒ −π/2），不是刚抽到的 angle —— 照抄，别「修」。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local a
    if to_th08_x(player.x) < bx then
        a = norm_angle(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        a = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BX_L + 96 then
        if a > PI / 2 then
            a = PI - a
        elseif a < -PI / 2 then
            a = -PI - a
        end
    end
    if bx > BX_R - 96 then
        if a < PI / 2 and a >= 0 then
            a = PI - (owner.lw220_mv_angle or 0)
        elseif a > -PI / 2 and a <= 0 then
            a = -PI - a
        end
    end
    ---★ 本卡这组边界是 y∈[96,128]、判据是「< 96+48」/「> 128−48」⇒ **两条恒成立**，
    ---  于是 a > 0 必被翻成负数（TH08 口径的负角 = 往上飘）。
    if by < BY_T + 48 and a < 0 then
        a = -a
    end
    if by > BY_B - 48 and a > 0 then
        a = -a
    end
    return a
end

---开一段插值位移（StartTimedPolarDisplacement）。同时记下 UpdateMovement 每帧会算出的
---movementAngle（TH08 口径）= atan2(dy, dx)，供下一次 `π − movementAngle` 那条怪癖用。
local function begin_move(owner, dx, dy, n, easing)
    owner.lw220_move = { x0 = owner.x, y0 = owner.y, dx = dx, dy = dy,
                         n = n, t = 0, easing = easing }
    ---位移恒 0（t=110 之前那条 ins_64）时 velocity 每帧都是 0，
    ---movementAngle = VectorAngle(0, 0) = atan2(0,0) = **0**（ZunMath 里没有 0 向量守卫）。
    owner.lw220_mv_angle = math.atan2(-dy, dx)
end

local function begin_wander(owner)
    local a = wander_angle(owner)
    begin_move(owner, math.cos(a) * WANDER_SPEED * WANDER_FRAMES,
                      -math.sin(a) * WANDER_SPEED * WANDER_FRAMES,
                      WANDER_FRAMES, EASING_LINEAR)
end

---BOSS 根时间轴的一条指令组。返回 true = 这一帧还要继续跑（`ins_4` 跳回 t=170）。
local function root_step(owner, t)
    if t == ROUND_END then
        owner.lw220_t = ROUND_T          -- `ins_4(170, −1848)`，同一帧继续
        return true
    end
    if t == MOVE_T then
        ---#27 `ins_64(60, 4, 192, 112)`：从 (0,96) 60 帧 OUT_QUAD 走到 (0,112)
        begin_move(owner, 0, MOVE_Y - ENTER_Y, MOVE_FRAMES, EASING_OUT_QUAD)
        return false
    end
    if t == ROUND_T then
        ---#29..#35 只在**第一轮**跑（循环标签在它们**后面**，跳转目标是 #36）
        if not owner.lw220_started then
            owner.lw220_started = true
            owner.lw220_lf1 = 0
            owner.lw220_lf2 = LF2_0
            owner.lw220_li2 = LI2_0
            owner.lw220_li3 = LI3_0
        end
        local lf0 = ran:Float(-PI, PI)   -- #36 `lf0 = RANDOM_ANGLE`（EclOperandsFloat.cpp:56）
        owner.lw220_lf0 = lf0
        ---#37 `INT_DIV ci0 = li3 / 2`（被 ins_94 拷给两台发射器当 xi0）
        local ci0 = math.floor(owner.lw220_li3 / 2)
        ---#38/#39 `ins_94(5, 0,0,0, 10, −2, 10)` / `ins_94(6, …)`：原地生成两台发射器
        emitters[#emitters + 1] = New(emitter_neg_cls, owner.x, owner.y, ci0)
        emitters[#emitters + 1] = New(emitter_pos_cls, owner.x, owner.y, ci0)
        ---#40..#45：sci0 = li2、sci1 = 3、scf0/1/2 = (lf0, lf1, lf2) → CALL Sub2
        wheel_shot(owner, bullet_cls_23a, owner.lw220_li2, lf0, owner.lw220_lf2)
        owner.lw220_lf4 = PI / owner.lw220_li2      -- #46 `lf4 = π / li2`
        return false
    end
    local wi = WHEEL_AT[t]
    if wi ~= nil then
        ---#47/#48：lf0 += lf4 后归一化；#49..#54：sci1 = 3 / 2 交替 → CALL Sub2 / Sub3
        owner.lw220_lf0 = norm_angle(owner.lw220_lf0 + owner.lw220_lf4)
        local cls = WHEEL_CI1[wi] == 3 and bullet_cls_23a or bullet_cls_23b
        wheel_shot(owner, cls, owner.lw220_li2, owner.lw220_lf0, owner.lw220_lf2)
        return false
    end
    local fi = FAN_AT[t]
    if fi ~= nil then
        ---#87..#118：sci0 = 24/26/28/30、sci1 = 1、scf0 = RANDOM_ANGLE、
        ---scf1 = ±0.005235988 / ±0.010471976、scf2 = 0.8 → CALL Sub4
        fan_shot(owner, FAN_COUNT[fi], ran:Float(-PI, PI), FAN_DANGLE[fi], FAN_SPEED)
        if t == WANDER_T then
            begin_wander(owner)          -- #119 `ins_67(60, 0, 0.2)`
        end
        return false
    end
    if t == SUB7_T then
        ---#120..#125：sci0 = 24、sci1 = 0、scf0 = π/2、scf1 = 0、scf2 = lf2 → CALL Sub7
        sub7_shot(owner, SUB7_COUNT, COLOR_SUB7, SUB7_ANGLE, owner.lw220_lf2)
        ---#126..#128：lf2 += 0.08、li2 += 3、li3 += 2
        owner.lw220_lf2 = owner.lw220_lf2 + LF2_STEP
        owner.lw220_li2 = owner.lw220_li2 + LI2_STEP
        owner.lw220_li3 = owner.lw220_li3 + LI3_STEP
        return false
    end
    return false
end

---BOSS 每帧。原作顺序：RunEcl（根 → 子 context）→ UpdateMovement（EnemyManagerUpdate.cpp）。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw220_t 还是 nil（卡 205..219 同款守卫）。
    if owner.lw220_t == nil then
        return
    end
    local guard = 0
    while root_step(owner, owner.lw220_t) do
        guard = guard + 1
        if guard > 4 then break end
    end
    owner.lw220_t = owner.lw220_t + 1
    ---根自己的插值位移（RunEcl 之后才 UpdateMovement）
    local mv = owner.lw220_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw220_move = nil
        end
    end
    ---ClampPosition（EnemyManagerUpdate.cpp:172-174）：ins_75 置了 CLAMP_POSITION，
    ---原作每帧在位移前后各钳一次；位移只在这儿变，所以末尾钳一次等价。
    if owner.x < CLAMP_L then owner.x = CLAMP_L
    elseif owner.x > CLAMP_R then owner.x = CLAMP_R end
    if owner.y < CLAMP_B then owner.y = CLAMP_B
    elseif owner.y > CLAMP_T then owner.y = CLAMP_T end
end

local function card_init(owner)
    owner.lw220_t = 0
    owner.lw220_started = false
    owner.lw220_move = nil
    owner.lw220_lf0 = 0
    owner.lw220_lf1 = 0
    owner.lw220_lf2 = 0
    owner.lw220_lf4 = 0
    owner.lw220_li2 = LI2_0
    owner.lw220_li3 = LI3_0
    ---Sub11 t=0 的 `ins_63(192, 128)` = SET_POSITION → 我们 (0, 96)，BOSS 原地出现。
    owner.x, owner.y = 0, ENTER_Y
    ---t=0 那条 `ins_64(110, 4, 192, 128)` 的目标就是同一点 ⇒ 位移恒 0，
    ---插值每帧算出的 movementAngle = atan2(0, 0) = 0（见 begin_move 的注释）。
    ---这里不建位移（建了也一样），但要把 movementAngle 摆在 0 —— 它是 t=110 那次
    ---下移之前的「上一段移动方向」。
    owner.lw220_mv_angle = 0
    pool = {}
    lasers = {}
    emitters = {}
end

local function card_del(owner)
    owner.lw220_t = nil
    owner.lw220_started = nil
    owner.lw220_move = nil
    owner.lw220_lf0, owner.lw220_lf1, owner.lw220_lf2, owner.lw220_lf4 = nil, nil, nil, nil
    owner.lw220_li2, owner.lw220_li3 = nil, nil
    owner.lw220_mv_angle = nil
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then object.RawDel(pool[i]) end
        pool[i] = nil
    end
    for i = #lasers, 1, -1 do
        if IsValid(lasers[i]) then object.RawDel(lasers[i]) end
        lasers[i] = nil
    end
    for i = #emitters, 1, -1 do
        if IsValid(emitters[i]) then object.RawDel(emitters[i]) end
        emitters[i] = nil
    end
end

bullet_cls_23a = make_bullet(ball_mid, COLOR_WHEEL_A, HALF23)
bullet_cls_23b = make_bullet(ball_mid, COLOR_WHEEL_B, HALF23)
bullet_cls_4 = make_bullet(ball_mid, COLOR_FAN, HALF4)
bullet_cls_7 = make_bullet(ball_big, COLOR_SUB7, HALF7)
emitter_neg_cls = make_emitter(1, LASER_COLOR_NEG)
emitter_pos_cls = make_emitter(-1, LASER_COLOR_POS)

CARD[220] = {
    init = card_init,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 221「深弹幕结界 -梦幻泡影-」（八云紫）
---  ecldata_yk.ecl：Sub18 = 生成助手（BOSS 入场）、Sub4 = BOSS 根（309 条指令）、
---  Sub5..Sub15 = 11 种「使魔」、Sub16 = CALL 助手（30 发纯观感特效，本卡省略）。
---
---  ★ 使魔（Sub5..Sub15）骨架完全一致，只有节拍常数不同：
---    t=0   `lf7 = lf2/120`、`lf5 = selfX`、`lf6 = selfY`；
---          `ORBIT_AROUND_POINT(120, lf5, lf6, lf0, lf1, 0, lf7)`
---          —— 圆心 = 出生点、半径 0→lf2、每帧转 lf1（「原地螺旋张开」）；
---          `lf7 = lf1*120 + lf0` 归一化（= 120 帧后该在的角）。
---    t=120 用**同一个圆心**、角 lf7、半径 lf2、radialVelocity 0、
---          **duration 0** 再装一次轨道 ⇒ 之后永久绕圈：
---          EnemyManager.cpp:47-53 只在 `movementDuration > 0` 时才递减计时并清模式。
---          此后每帧 `orbitAngle += lf1`、`velocity = polar(oa, or) + origin − position`、
---          `movementAngle = atan2(vy, vx)`（:36-45）。
---
---  ★ 五条弹 transform record（`ins_111`，BulletTransformInstructionArgs 的字段序 =
---    transformIndex / kind / allowWhileActive / int0 / int1 / float0 / float1，
---    EclRunHigh.inl:78-91）：
---      [0] SET_CULL_DELAY(frames = li0)（kind 0x2000）
---      [1] VECTOR(magnitude 0, angle −999, 时长 li1)（kind 0x10）
---      [2] RELATIVE_DIRECTION(angle 0, speed 0, interval 1, repeat 1)（kind 0x40）
---      [3] VECTOR(magnitude 0, angle −999, 时长 li0)（kind 0x10）
---      [4] VECTOR(magnitude m, angle −999, 时长 f)（kind 0x10）
---    五条 allowWhileActive 都是 0 ⇒ 一条跑完才装下一条（BulletManager.cpp:321-323）；
---    弹每帧 `AdvanceTransformProgram`（:310-478）→ 加速状态（:822-840）→
---    出屏宽限 −1 → `position += velocity` → 出屏回收（:856-899）。
---    ★ record 的 angle = −999 < −990 ⇒ 加速方向取**装上的那一刻**的自身角
---      （`:331-337` 的 `> -990.0f ? … : this->angle`），不是出弹角 —— 但 [1] 那段
---      零向量加速会把 `angle += atan2(v)` 重算一遍（:1221-1225），所以「停 → 归零 →
---      再加速」这一串下来方向就等于出弹方向。
---    ★ [2] 是「两帧把速度归零」：interval 1、repeat 1、speed 0 ⇒ 第一帧走 else 分支
---      magnitude = speed − timer*speed/interval = 0、第二帧 completed 到数 → 清位，
---      期间 `velocity = FromAngleMagnitude(angle, 0)`（:1255-1291）。
---    ⇒ 大弹的真实手感：出生动画 15 帧边走边减速（velocity/2.5），FIRED 后再按
---      出弹速度直飞 li1 帧、刹停 2 帧、原地停 li0 帧，最后以 m/帧 加速 f 帧。
---
---  ★ 循环体的调度（EclRun.cpp:53-104 的 time 机制，必读）：
---    循环体第一条在时间 t0（120 / 121），`JUMP_DEC` 在 t0 + per（124 / 123 / 122）。
---    JUMP_DEC 命中时 `context.time.current = operand0`（= t0）并跳回循环体，
---    ⇒ **同一帧**把循环体再跑一遍；跑完落到 JUMP_DEC，此刻 time.current(= t0) ≠
---    JUMP_DEC 自己的 time ⇒ 跳出，等 `time++` 一帧一帧涨回去。
---    净效果 = 循环体每 **per** 帧跑一次（per = JUMP_DEC.time − t0）。
---    循环圈数 xi0 = li0/div 在 t0 算一次就固定（跳转目标是循环体第一条，不是 #13）；
---    循环体里 `li0 -= div`、`li1` 在 `xi1 % mod == 0` 时 +1、`lf3 += lf4` 每遍都执行。
---    ⇒ 使魔活 `t0 + per*xi0` 帧 ≈ t0 + li0（Sub5 是 120 + 4*130 = 640 帧）。
---    ★ `#17 li3 = li0 − li1` 是死代码（下一句就被 `li3 = xi1 % mod` 覆盖），不实现。
---    ★ 大弹那条 `ins_99` 的角 = lf7 = `MOVE_ANGLE + lf3`（TH08 口径）；
---      小弹那条的角 = **ORBIT_ANGLE**（操作数 0x275D，EclManager.hpp:478），
---      扇形半角 = lf7 现抽的随机值 `rndUnit*π/8 + π/90`（RANDOM_UNIT_FLOAT = 0x2731）。
---      小弹的发射点比使魔远 16 px，方向还是那个 `MOVE_ANGLE + lf3`。
---      ★ 小弹那条 `ins_99` 的 transformFlags = **0** ⇒ 五条 record 全被跳过
---        （`:328-332` 的 `(transformFlags & kind) == 0 → ++index`）⇒ 没有出屏宽限、
---        没有加速，纯直线 0.5，一出场地就回收。
---
---  ★ 终盘（t=7050..7269，`#290..#307`）：xi1 = 220 做外层计数、每真帧 xi0 = 6 递减到 1
---    的内层循环甩 6 发 —— 出弹点在 BOSS 附近**均匀随机**的矩形里（`rndSignedUnit*192`、
---    `*224`，RANDOM_SIGNED_UNIT_FLOAT = 0x2733 = GetRandomF32Signed() ∈ [−1,1]，
---    Global.cpp:1231-1235），离 BOSS 不足 32 px 就不打（`lf0 = x²+y² < 1024`，:302），
---    角 = POINT_ANGLE(点, 原点)（= 朝 BOSS 中心），speed1 = 0、count2 = 1。
---    record 换成 CULL(li0=0) / VEC(90) / DIR(1,1) / VEC(90) / VEC(90, 0.0011111111)，
---    于是这 1320 发弹先原地不动 182 帧、再以 0.0011111/帧 慢慢加速朝中心聚。
---    ★ 同屏上限 1536（全游戏共用，BulletManager.hpp:455）：`activeBulletCount >= 0x600`
---      整条 ins_99 不生（:692）、波中间空槽用完就放弃这一波剩下的（:698-712），照抄。
---
---  ★ 贴图占位：使魔 = "servant"、弹（bulletType 6 与 11 都是 etama 的 21/22/23 脚本）
---    统一用 ball_small，色号取 TH08 色 +1。★ 17 张全部实现完之后再统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x′ = x − 192、y′ = 224 − y、角度整体取反。
---本卡的**内部角度一律保持 TH08 口径**（跟卡 220 同款），只在出弹、算位移那一刻才换算。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）：把角卷进 (−π, π]。
local function norm_angle(a)
    while a > PI do a = a - 2 * PI end
    while a < -PI do a = a + 2 * PI end
    return a
end

---同屏弹幕上限（全游戏共用，BulletManager.hpp:455）与出屏判据（GameManager.cpp:132-152）。
local POOL_SIZE = 1536
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224
local function outside_field(x, y, hw, hh)
    return x + hw < FIELD_L or x - hw > FIELD_R
            or y + hh < FIELD_B or y - hh > FIELD_T
end

---`(flags & mask) ~= 0` 的等价判据（内嵌 Lua 是 5.1，写 `&` 会在加载时报错）。
local function flag_hit(flags, mask)
    while flags > 0 and mask > 0 do
        if flags % 2 == 1 and mask % 2 == 1 then
            return true
        end
        flags = math.floor(flags / 2)
        mask = math.floor(mask / 2)
    end
    return false
end

---transform record 的种类与出生标志（BulletManager.hpp:131-154）。
local T_VEC, T_DIR, T_CULL = 0x10, 0x40, 0x2000
local TF_SPAWN_NORMAL = 4
---本卡大弹那两条 `ins_99` 的 transformFlags = 8788 = 0x2254（见卡头）。
local TF_SPELL = TF_SPAWN_NORMAL + T_VEC + T_DIR + T_CULL
---etama.anm 的 script 22（= SPAWN_NORMAL）长 15 帧：出生位移走 velocity/2.5，
---第 15 帧动画播完 → activateBullet → **同一帧**再走一遍 FIRED 的更新（:944-957）。
local SPAWN_NORMAL_FRAMES = 15
local HALF_SMALL = 8                -- 小弹 14×16 的半个宽高（只给出屏回收用）

---本卡的登记表：弹（≡ 原作那 1536 个弹槽）、使魔。
local pool = {}
local servants = {}

---弹槽计数：原作的 activeBulletCount 数的是**所有非空弹槽**（BulletManager.cpp:809-817），
---所以被出屏回收过的弹（state = UNUSED）就不算了。这里就地压缩。
local function pool_used()
    local n = 0
    local m = #pool
    for i = 1, m do
        if IsValid(pool[i]) then
            n = n + 1
            if n ~= i then pool[n] = pool[i] end
        end
    end
    for i = m, n + 1, -1 do pool[i] = nil end
    return n
end

---AdvanceTransformProgram（BulletManager.cpp:310-478）的等价实现：
---从 record[ti] 往后走，`transformFlags` 里没有的种类跳过、SET_CULL_DELAY 当场流过，
---第一条装得上的状态 record 装上就**停**（每帧最多装一条）。
local function adv_bullet(self)
    while self.ti < 5 do
        local r = self.rec[self.ti + 1]
        if r.allow == 0 and (self.af_v or self.af_d) then
            return
        end
        if not flag_hit(self.flags, r.kind) then
            self.ti = self.ti + 1
        elseif r.kind == T_CULL then
            self.cull = r.frames
            self.ti = self.ti + 1
        elseif r.kind == T_VEC then
            self.af_v = true
            self.va_t, self.va_n = 0, r.frames
            ---`angle = −999 < −990` ⇒ 加速方向 = 装的那一刻的自身角（:331-337）
            self.va_ang = r.ang > -990 and r.ang or self.ang
            self.va_vx = math.cos(self.va_ang) * r.mag
            self.va_vy = -math.sin(self.va_ang) * r.mag
            self.ti = self.ti + 1
            return
        else
            self.af_d = true
            self.dc_ang, self.dc_spd = r.ang, r.spd
            self.dc_iv, self.dc_re = r.itv, r.rep
            self.dc_n, self.dc_t = 0, 0
            self.ti = self.ti + 1
            return
        end
    end
end

---本卡的弹。TH08 口径：`vx = cos(角)*速`、`vy = −sin(角)*速`（y 轴整体翻转）。
---p 是出弹那条 `ins_99` 的 transform 程序快照：
---  { flags, cull = record[0] 的 frames, w1 = record[1] 的时长,
---    w2 = record[3] 的时长, f/m = record[4] 的时长与每帧加速度 }
---（record[2] 的 RELATIVE_DIRECTION 恒为 interval 1 / repeat 1 / angle 0 / speed 0）
local function make_bullet(style, color, half)
    return Class(bullet, {
        init = function(self, x, y, angle, speed, p)
            ---`bullet.init(self, imgclass, index, stay, destroyable)`
            ---（THlib/bullet/bullet.lua:79-89）
            bullet.init(self, style, color, false, true)
            self.rot = -angle * RAD          -- 贴图朝向（角度制）
            self.ang = angle                 -- 自身角（TH08 口径、弧度）
            self.flags = p.flags
            self.rec = {
                { kind = T_CULL, allow = 0, frames = p.cull },
                { kind = T_VEC,  allow = 0, frames = p.w1, mag = 0, ang = -999 },
                { kind = T_DIR,  allow = 0, ang = 0, spd = 0, itv = 1, rep = 1 },
                { kind = T_VEC,  allow = 0, frames = p.w2, mag = 0, ang = -999 },
                { kind = T_VEC,  allow = 0, frames = p.f, mag = p.m, ang = -999 },
            }
            self.ti, self.af_v, self.af_d = 0, false, false
            self.cull, self.half = 0, half
            self.spawn_left = 0
            self.svx, self.svy = math.cos(angle) * speed, -math.sin(angle) * speed
            self.bound = false               -- 出屏回收自己按 IsWithinPlayfield 判
            self.x, self.y = x, y
            if flag_hit(p.flags, TF_SPAWN_NORMAL) then
                ---出生瞬间位置先减 velocity*4、state = SPAWNING_NORMAL
                ---（BulletManager.cpp:215-235）；出生期间 velocity/2.5 由 frame 自己走，
                ---所以先把引擎那步积分用的 vx/vy 归零。
                self.x = x - self.svx * 4
                self.y = y - self.svy * 4
                self.spawn_left = SPAWN_NORMAL_FRAMES
                self.vx, self.vy = 0, 0
            else
                self.vx, self.vy = self.svx, self.svy
            end
            adv_bullet(self)                 -- 出生帧先跑一次（BulletManager.cpp:250）
        end,
        frame = function(self)
            if self.spawn_left > 0 then
                ---SPAWNING_NORMAL（:944-957）：每帧 +velocity/2.5，动画播完那一帧
                ---activate 并继续走 FIRED 的更新。
                self.x = self.x + self.svx / 2.5
                self.y = self.y + self.svy / 2.5
                self.spawn_left = self.spawn_left - 1
                if self.spawn_left > 0 then
                    bullet.frame(self)
                    return
                end
                self.vx, self.vy = self.svx, self.svy
            end
            ---① AdvanceTransformProgram
            adv_bullet(self)
            ---② 加速状态（:820-840，顺序照抄：VECTOR 在 DIRECTION_CHANGE 前）
            if self.af_v then
                if self.va_t >= self.va_n then
                    self.af_v = false
                else
                    self.vx = self.vx + self.va_vx
                    self.vy = self.vy + self.va_vy
                    if math.abs(self.vx) > 0.0001 or math.abs(self.vy) > 0.0001 then
                        self.ang = math.atan2(-self.vy, self.vx)
                    end
                end
                self.va_t = self.va_t + 1
            end
            if self.af_d then
                ---UpdateRelativeDirectionChange（:1255-1291）
                if self.dc_t >= self.dc_iv then
                    self.dc_n = self.dc_n + 1
                    if self.dc_n >= self.dc_re then
                        self.af_d = false
                    end
                    self.ang = self.ang + self.dc_ang
                    self.dc_t = 0
                    self.vx = math.cos(self.ang) * self.dc_spd
                    self.vy = -math.sin(self.ang) * self.dc_spd
                else
                    local sp = self.dc_spd > -999 and self.dc_spd or 0
                    local mag = sp - self.dc_t * sp / self.dc_iv
                    self.vx = math.cos(self.ang) * mag
                    self.vy = -math.sin(self.ang) * mag
                end
                self.dc_t = self.dc_t + 1
            end
            ---③④ 出屏宽限计时与回收（:856-899）。原作的顺序是
            ---   `--offscreenCullDelayFrames` → `position += velocity` → 判 IsWithinPlayfield，
            ---   位移由引擎在 frame 之后积分 ⇒ 这里用「本帧末」的位置 (x+vx, y+vy) 判，
            ---   和原作逐帧一致。本卡的弹没有装反弹/改向状态位，所以计时归零后一出屏就当帧回收。
            if self.cull ~= 0 then
                self.cull = self.cull - 1
            end
            if self.cull == 0
                    and outside_field(self.x + self.vx, self.y + self.vy,
                                      self.half, self.half) then
                object.RawDel(self)
                return
            end
            bullet.frame(self)
        end,
    })
end

---TH08 色号 0..7 → 我们的 COLOR（1..16；一一对应 +1）。
local function th08_color(c) return c + 1 end

local BULLET = {
    [6] = {
        [2] = make_bullet(ball_small, th08_color(2), HALF_SMALL),
        [4] = make_bullet(ball_small, th08_color(4), HALF_SMALL),
        [6] = make_bullet(ball_small, th08_color(6), HALF_SMALL),
    },
    [11] = {
        [2] = make_bullet(ball_small, th08_color(2), HALF_SMALL),
        [4] = make_bullet(ball_small, th08_color(4), HALF_SMALL),
        [6] = make_bullet(ball_small, th08_color(6), HALF_SMALL),
    },
}

---小弹那条 `ins_99` 的 flags = 0 ⇒ 五条 record 全跳过（没有宽限、没有加速）。
local P_PLAIN = { flags = 0, cull = 0, w1 = 0, w2 = 0, f = 0, m = 0 }

---一次 `ins_99`（SHOOT_FAN = opcode 97，EclManager.hpp:305）。
---aimMode = opcode − ECL_OPCODE_SHOOT_FAN_AIMED = 1 = BULLET_AIM_FAN
---（EclDependencies.cpp:727-728）；角度展开与速度插值照 BulletManager.cpp:118-135 抄，
---创建顺序 j 在外、i 在内，空槽用完就放弃这一波剩下的（:698-712）。
---wx/wy = 出弹点在 **TH08 世界坐标**（= 出弹者的 worldPosition + shootOffset）。
local function shoot_fan(wx, wy, bt, color, count1, count2, s1, s2, base, step, p)
    local used = pool_used()
    if used >= POOL_SIZE then
        return                          -- 池满：整条 ins_99 不生（BulletManager.cpp:692）
    end
    local cls = BULLET[bt][color]
    local px, py = wx - 192, 224 - wy   -- 出弹点（我们口径）
    for j = 0, count2 - 1 do
        local spd = s1
        if count2 > 1 then
            spd = s1 - (s1 - s2) * j / count2
        end
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then
                return
            end
            local a
            if count1 % 2 == 1 then
                a = math.floor((i + 1) / 2) * step
            else
                a = math.floor(i / 2) * step + step * 0.5
            end
            if i % 2 == 1 then a = -a end
            used = used + 1
            pool[used] = New(cls, px, py, norm_angle(base + a), spd, p)
        end
    end
end

---Sub5..Sub15 的静态节拍表（数字逐个来自 ecldata_yk.ecl 的裸字节，见卡头）。
---  t0  = 循环体第一条的时间（120 / 121）；per = 循环体两遍之间隔几帧
---  div = li0 每遍减多少（= 圈数 xi0 = li0/div 的除数）
---  f/m = record[4] 的 VECTOR 时长与每帧加速度；bt = bulletType
---  bc1/bc2/bs1/bs2 = 大弹那条的 count1/count2/speed1/speed2
---  sc1 = 小弹那条的 count1（count2 恒 1、speed1 恒 0.5）
---  ge/le = `#21 JMP_INT_GE xi1` / `#25 JMP_INT_LE xi1` 的门槛（nil = 没有这两条）
---  mod = `li3 = xi1 % mod`，只决定 li1 要不要 +1（0 = 没有这条判据）
---  noreset：Sub14 是 `#23 INT_INC xi1`，不是「xi1 = −1 再 ++」⇒ xi1 一路涨
local SUB = {
    [5]  = { t0 = 120, per = 4, div = 4, f = 60, m = 0.0333333351, bt = 6,
             bc1 = 1, bc2 = 1, bs1 = 2.5, bs2 = 2, sc1 = 3, ge = 6, le = 7, mod = 0 },
    [6]  = { t0 = 120, per = 3, div = 3, f = 90, m = 0.0333333351, bt = 6,
             bc1 = 1, bc2 = 1, bs1 = 2, bs2 = 2, sc1 = 2, ge = 3, le = 7, mod = 2 },
    [7]  = { t0 = 120, per = 3, div = 3, f = 90, m = 0.0333333351, bt = 6,
             bc1 = 1, bc2 = 1, bs1 = 2, bs2 = 2, sc1 = 2, ge = 15, le = 20, mod = 2 },
    [8]  = { t0 = 120, per = 3, div = 3, f = 90, m = 0.0188888889, bt = 6,
             bc1 = 1, bc2 = 1, bs1 = 2, bs2 = 2, sc1 = 2, ge = 3, le = 9, mod = 2 },
    [9]  = { t0 = 121, per = 2, div = 2, f = 90, m = 0.0266666673, bt = 6,
             bc1 = 1, bc2 = 2, bs1 = 2, bs2 = 1, sc1 = 2, mod = 4 },
    [10] = { t0 = 121, per = 2, div = 2, f = 90, m = 0.0377777778, bt = 11,
             bc1 = 1, bc2 = 2, bs1 = 4, bs2 = 1, sc1 = 2, mod = 4 },
    [11] = { t0 = 120, per = 3, div = 3, f = 90, m = 0.0411111116, bt = 11,
             bc1 = 1, bc2 = 1, bs1 = 2, bs2 = 2, sc1 = 2, ge = 3, le = 9, mod = 2 },
    [12] = { t0 = 121, per = 2, div = 2, f = 90, m = 0.0377777778, bt = 11,
             bc1 = 1, bc2 = 1, bs1 = 6, bs2 = 1, sc1 = 2, mod = 4 },
    [13] = { t0 = 120, per = 3, div = 3, f = 90, m = 0.0411111116, bt = 11,
             bc1 = 1, bc2 = 1, bs1 = 2, bs2 = 2, sc1 = 2, ge = 5, le = 11, mod = 2 },
    [14] = { t0 = 120, per = 2, div = 2, f = 90, m = 0.0411111116, bt = 11,
             bc1 = 1, bc2 = 2, bs1 = 5, bs2 = 2, sc1 = 2, mod = 2, noreset = true },
    [15] = { t0 = 120, per = 2, div = 2, f = 90, m = 0.0188888889, bt = 11,
             bc1 = 1, bc2 = 2, bs1 = 5, bs2 = 1, sc1 = 2, ge = 31, le = 33, mod = 2 },
}

---使魔每帧的位移：UpdateMovement 的 ORBIT 分支（EnemyManager.cpp:36-61）。
---★ 位置在 TH08 口径下算（sx/sy），跟原作逐帧一致；self.x/self.y 只是展示用。
local function servant_move(self)
    if self.mode == 0 then
        ---轨道模式已经结束（`movementDuration > 0` 且计时归零）：velocity 不再重算，
        ---但 IntegrateVelocity 照加 ⇒ 继续按上一次的 velocity 漂（:50-53、EnemyManagerUpdate.cpp:164-168）。
        self.sx = self.sx + self.vx
        self.sy = self.sy + self.vy
    else
        self.oa = norm_angle(self.oa + self.oav)
        self.orad = self.orad + self.orv
        local px, py = math.cos(self.oa) * self.orad, math.sin(self.oa) * self.orad
        self.vx = px + self.ox - self.sx
        self.vy = py + self.oy - self.sy
        self.move_ang = math.atan2(self.vy, self.vx)
        self.sx = self.sx + self.vx
        self.sy = self.sy + self.vy
        if self.mdur > 0 then
            self.mtimer = self.mtimer - 1
            if self.mtimer <= 0 then self.mode = 0 end
        end
    end
    self.x, self.y = self.sx - 192, 224 - self.sy
end

---循环体一遍（Sub5 的 #15..#38，其余 sub 同构）。
local function servant_body(self)
    local cfg = self.cfg
    ---#15..#18：把本遍的 record[0]/[1]/[3] 刷新（li0 每遍 −div、li1 每几遍 +1）
    local p = { flags = TF_SPELL, cull = self.li0, w1 = self.li1,
                w2 = self.li0, f = cfg.f, m = cfg.m }
    ---#19/#20：lf7 = MOVE_ANGLE + lf3（归一化）
    self.lf7 = norm_angle(self.move_ang + self.lf3)
    ---#21..#27：大弹只在 xi1 < ge 时打；xi1 > le 就归 −1；然后 ++xi1
    local fire_big = cfg.ge == nil or self.xi1 < cfg.ge
    if fire_big then
        ---#22/#23：SET_SHOOT_OFFSET(0, 0) + 一发大弹
        shoot_fan(self.sx, self.sy, cfg.bt, self.li2, cfg.bc1, cfg.bc2,
                  cfg.bs1, cfg.bs2, self.lf7, 0, p)
    end
    if cfg.ge ~= nil then
        if (not fire_big) and self.xi1 > cfg.le then
            self.xi1 = -1                -- #26
        end
    elseif not cfg.noreset then
        self.xi1 = -1                    -- #26（没有分支的 sub 每遍都归零）
    end
    self.xi1 = self.xi1 + 1              -- #27（Sub14 是 #23 INT_INC）
    ---#28..#34：小弹的发射点偏移 16 px（方向 = 上面那个 lf7），扇形半角换随机值
    local step = ran:Float(0, 1) * PI / 8 + PI / 90
    local ox = math.cos(self.lf7) * 16
    local oy = math.sin(self.lf7) * 16
    ---#35：以**轨道角**为基准的小扇形（count2 = 1、speed 0.5、flags = 0）
    shoot_fan(self.sx + ox, self.sy + oy, cfg.bt, self.li2, cfg.sc1, 1,
              0.5, 2, self.oa, step, P_PLAIN)
    ---#36/#37/#38：li0 -= div；li3 = xi1 % mod，li3 == 0 才 li1 += 1；lf3 += lf4 恒执行
    self.li0 = self.li0 - cfg.div
    if cfg.mod == 0 or (self.xi1 % cfg.mod) == 0 then
        self.li1 = self.li1 + 1
    end
    self.lf3 = self.lf3 + self.lf4
end

---使魔（Sub5..Sub15 共用一个类，靠 cfg 区分）。占位贴图 "servant"。
local servant_cls = Class(object, {
    init = function(self, x, y, cfg, li0, li1, li2, lf0, lf1, lf2, lf3, lf4)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY_BULLET
        self.img = "servant"
        self.colli, self.navi, self.bound, self.rot = false, false, false, 0
        self._blend, self._a = "", 255
        self.cfg = cfg
        self.li0, self.li1, self.li2 = li0, li1, li2
        self.lf3, self.lf4 = lf3, lf4
        self.t, self.xi0, self.xi1 = 0, 0, 0
        self.lf7 = 0
        ---世界坐标（TH08 口径，唯一真相）
        self.sx, self.sy = to_th08_x(x), to_th08_y(y)
        ---t=0 的三条：lf7 = lf2/120、lf5 = selfX、lf6 = selfY、
        ---#6 ORBIT(120, selfX, selfY, lf0, lf1, radius 0, radialVelocity lf2/120)
        self.ox, self.oy = self.sx, self.sy
        self.oa, self.oav, self.orad, self.orv = lf0, lf1, 0, lf2 / 120
        self.mdur, self.mtimer, self.mode = 120, 120, 1
        self.move_ang, self.vx, self.vy = 0, 0, 0
        self.lf1, self.lf2 = lf1, lf2
    end,
    frame = function(self)
        local cfg, t = self.cfg, self.t
        if t == cfg.t0 then
            ---#10：永久轨道（同一圆心、角 lf7、半径 lf2、radialVelocity 0、duration 0）
            self.oa, self.oav = self.lf7, self.lf1
            self.orad, self.orv = self.lf2, 0
            self.mdur, self.mtimer, self.mode = 0, 0, 1
            ---#13 xi0 = li0/div、#14 xi1 = 0，然后循环体第一遍
            self.xi0 = math.floor(self.li0 / cfg.div)
            self.xi1 = 0
            servant_body(self)
        elseif t > cfg.t0 and (t - cfg.t0) % cfg.per == 0 then
            ---JUMP_DEC：先减 xi0；还 > 0 就同帧再跑一遍循环体，否则落 TERMINATE
            self.xi0 = self.xi0 - 1
            if self.xi0 > 0 then
                servant_body(self)
            else
                object.RawDel(self)
                return
            end
        end
        ---RunEcl 之后才 UpdateMovement
        servant_move(self)
        self.t = t + 1
    end,
})

---Sub4 `#30..#47` 等：每一批的 5 个 li + 5 个 lf 都是**生成前现写**的（spawnTemplate 只拷
---intVariables/floatVariables），下面逐个照抄 spawns.py 读出来的裸值。
---  一行的 9 个字段 = { sub, li0, li1, li2, lf0, lf1, lf2, lf3, lf4 }
local WAVE = {
    [160] = {
        { 5, 520, 3, 4, PI, 0.0261799395, 224, PI / 2, 0.0026179939 },
        { 5, 520, 3, 6, 0, 0.0261799395, 224, PI / 2, 0.0026179939 },
    },
    [960] = {
        { 7, 520, 3, 4, PI, -0.0174532924, 192, -PI / 3, -0.007853982 },
        { 7, 520, 3, 6, 0, -0.0174532924, 192, -PI / 3, -0.007853982 },
    },
    [1760] = {
        { 6, 520, 3, 4, PI, -0.0174532924, 224, -PI / 2, -0.0026179939 },
        { 6, 520, 3, 6, 0, -0.0174532924, 224, -PI / 2, -0.0026179939 },
    },
    [1780] = {
        { 6, 520, 3, 4, PI, 0.0261799395, 192, PI / 2, 0.0026179939 },
        { 6, 520, 3, 6, 0, 0.0261799395, 192, PI / 2, 0.0026179939 },
    },
    [2610] = {
        { 8, 520, 3, 4, PI, 0.0174532924, 224, PI / 4, 0.0104719754 },
        { 8, 520, 3, 6, 0, 0.0174532924, 224, PI / 4, 0.0104719754 },
    },
    [2630] = {
        { 8, 520, 3, 4, PI, -0.0314159282, 208, -PI / 4, -0.0104719754 },
        { 8, 520, 3, 6, 0, -0.0314159282, 208, -PI / 4, -0.0104719754 },
    },
    [2650] = {
        { 8, 520, 3, 4, PI, 0.0261799395, 192, PI / 4, 0.0104719754 },
        { 8, 520, 3, 6, 0, 0.0261799395, 192, PI / 4, 0.0104719754 },
    },
    [3540] = {
        { 9, 520, 3, 4, PI, -0.0314159282, 224, -PI / 2, -0.0044879895 },
        { 9, 520, 3, 6, 0, -0.0314159282, 224, -PI / 2, -0.0044879895 },
    },
    [4430] = {
        { 10, 480, 3, 2, -PI / 2, 0.0314159282, 224, PI / 2, 0.0044879895 },
        { 10, 480, 3, 4, PI / 2, 0.0314159282, 224, PI / 2, 0.0044879895 },
        { 11, 520, 3, 6, -PI / 2, -0.0314159282, 224, -1.53152645, 0.0044879895 },
        { 11, 520, 3, 6, PI / 2, -0.0314159282, 224, -1.53152645, 0.0044879895 },
    },
    [5120] = {
        { 12, 480, 3, 2, -PI / 2, 0.0314159282, 224, 1.53152645, 0.0044879895 },
        { 12, 480, 3, 4, PI / 2, 0.0314159282, 224, 1.53152645, 0.0044879895 },
        { 13, 520, 3, 6, 0, -0.0314159282, 224, -1.53152645, 0.0015707964 },
        { 13, 520, 3, 6, PI, -0.0314159282, 224, -1.53152645, 0.0015707964 },
    },
    [5810] = {
        { 14, 280, 3, 2, -PI / 2, 0.0314159282, 224, 1.53152645, 0 },
        { 14, 280, 3, 4, PI / 2, 0.0314159282, 224, 1.53152645, 0 },
    },
    [6300] = {
        { 15, 280, 3, 2, -PI / 2, 0.0314159282, 224, PI / 2, 0 },
        { 15, 280, 3, 4, PI / 2, 0.0314159282, 224, PI / 2, 0 },
    },
}

---BOSS 根（Sub4）的时间轴。
local ENTER_Y = 96                 -- Sub18 `ins_63(192, 128)` = SET_POSITION → 我们 (0, 96)
local MOVE_T, MOVE_FRAMES, MOVE_Y = 90, 60, 0   -- `ins_64(60, 4, 192, 224)`
local FINAL_T, FINAL_FRAMES = 7050, 220         -- `#290 xi1 = 220`
local FINAL_COUNT = 6                           -- `#291 xi0 = 6`（内层循环，同帧 6 发）
local FINAL_MIN_R2 = 1024                       -- `#302 lf0 = x²+y² < 1024` 就不打（离 BOSS 32 px）
local FINAL_WAIT, FINAL_ACCEL_FRAMES, FINAL_ACCEL_MAG = 90, 90, 0.0011111111
---`ins_75(32, 48, 352, 128)` = SET_MOVEMENT_BOUNDS：我们口径 x ∈ [−160,160]、y ∈ [96,176]。
---`#22 ins_76` 在 t=90 把它关掉，之后就再也不夹框。
local CLAMP_L, CLAMP_R, CLAMP_B, CLAMP_T = -160, 160, 96, 176
local EASING_LINEAR, EASING_OUT_QUAD = 0, 4     -- EclEasingMode（EnemyManager.cpp:100-105）

---插值位移的一步（EnemyManager.cpp:84-121 的 INTERPOLATED 分支）。
local function move_step(mv)
    mv.t = mv.t + 1
    local u = mv.t / mv.n
    if u > 1 then u = 1 end
    local e
    if mv.easing == EASING_OUT_QUAD then
        e = 1 - (1 - u) * (1 - u)
    else
        e = u
    end
    return mv.x0 + mv.dx * e, mv.y0 + mv.dy * e, mv.t >= mv.n
end

local function begin_move(owner, dy, n, easing)
    owner.lw221_move = { x0 = owner.x, y0 = owner.y, dx = 0, dy = dy,
                         n = n, t = 0, easing = easing }
end

---生成一台使魔：位置 = BOSS 的 worldPosition + 偏移（本卡偏移恒 (0,0)，ins_94/EclRunHigh.inl:812-838）。
local function spawn_servant(owner, sub, li0, li1, li2, lf0, lf1, lf2, lf3, lf4)
    local sx, sy = to_th08_x(owner.x), to_th08_y(owner.y)
    local s = New(servant_cls, sx - 192, 224 - sy, SUB[sub],
                  li0, li1, li2, lf0, lf1, lf2, lf3, lf4)
    servants[#servants + 1] = s
end

---终盘：`#297..#306` 的内层循环，每真帧 6 发（`#307 JUMP_DEC` 把 xi1 从 220 数到 1）。
local function final_step(owner)
    local bx, by = to_th08_x(owner.x), to_th08_y(owner.y)
    local p = { flags = TF_SPELL, cull = 0, w1 = FINAL_WAIT, w2 = FINAL_WAIT,
                f = FINAL_ACCEL_FRAMES, m = FINAL_ACCEL_MAG }
    for _ = 1, FINAL_COUNT do
        ---`#297/#298`：lf94 = rndSignedUnit*192、lf95 = rndSignedUnit*224
        local f94 = ran:Float(-1, 1) * 192
        local f95 = ran:Float(-1, 1) * 224
        ---`#302`：离 BOSS 不足 32 px 就不打
        if f94 * f94 + f95 * f95 >= FINAL_MIN_R2 then
            ---`#303/#304`：发射点 = BOSS + (lf94, lf95)，角 = POINT_ANGLE(点, 原点)
            local ang = math.atan2(0 - f95, 0 - f94)
            shoot_fan(bx + f94, by + f95, 11, 2, 1, 1, 0, 2, ang, 0, p)
        end
    end
end

---BOSS 每帧。原作顺序：RunEcl（根 → 子 context）→ ClampPosition → IntegrateVelocity
---（EnemyManagerUpdate.cpp:157-175）。
local function boss_frame(owner)
    ---★ before 阶段 frame 先跑，那几帧 lw221_t 还是 nil（卡 205..220 同款守卫）。
    if owner.lw221_t == nil then
        return
    end
    local t = owner.lw221_t
    if t == MOVE_T then
        ---`#22 ins_76` 关夹框；`#27 ins_64(60, 4, 192, 224)`：60 帧 OUT_QUAD 下移到我们 (0, 0)
        owner.lw221_clamp = false
        begin_move(owner, MOVE_Y - ENTER_Y, MOVE_FRAMES, EASING_OUT_QUAD)
    end
    local wave = WAVE[t]
    if wave then
        for i = 1, #wave do
            local e = wave[i]
            spawn_servant(owner, e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8], e[9])
        end
    end
    if t >= FINAL_T and t < FINAL_T + FINAL_FRAMES then
        final_step(owner)
    end
    ---根自己的插值位移（RunEcl 之后才 UpdateMovement）
    local mv = owner.lw221_move
    if mv then
        local nx, ny, done = move_step(mv)
        owner.x, owner.y = nx, ny
        if done then
            owner.lw221_move = nil
        end
    end
    ---ClampPosition（EnemyManagerUpdate.cpp:164-174）：ins_75 置了 CLAMP_POSITION，
    ---原作每帧在位移前后各钳一次；位移只在这儿变，所以末尾钳一次等价。
    if owner.lw221_clamp then
        if owner.x < CLAMP_L then owner.x = CLAMP_L
        elseif owner.x > CLAMP_R then owner.x = CLAMP_R end
        if owner.y < CLAMP_B then owner.y = CLAMP_B
        elseif owner.y > CLAMP_T then owner.y = CLAMP_T end
    end
    owner.lw221_t = t + 1
end

local function card_init(owner)
    owner.lw221_t = 0
    owner.lw221_clamp = true
    owner.lw221_move = nil
    ---Sub18 t=0 的 `ins_63(192, 128)` = SET_POSITION ⇒ BOSS 出现在我们 (0, 96)；
    ---`#9 ins_64(90, 4, 192, 128)` 的目标就是同一点 ⇒ 位移恒 0（不建也行）。
    owner.x, owner.y = 0, ENTER_Y
    pool = {}
    servants = {}
end

local function card_del(owner)
    owner.lw221_t = nil
    owner.lw221_move = nil
    owner.lw221_clamp = nil
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then object.RawDel(pool[i]) end
        pool[i] = nil
    end
    for i = #servants, 1, -1 do
        if IsValid(servants[i]) then object.RawDel(servants[i]) end
        servants[i] = nil
    end
end

CARD[221] = {
    init = card_init,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 191「旧史「旧秘境史　-オールドヒストリー-」」（上白泽慧音）
---  ecldata8sp.ecl：Sub5 = BOSS 根、Sub6 = BOSS 的枪（子 context 0，t=110 挂上）、
---  Sub8 = 使魔、Sub7 = 使魔的枪（使魔的子 context 0，t=60 挂上）。
---
---  · Sub5（根 = 本卡的节拍表；ins_134(3600, 18) 给 60 秒）：
---      t=0    ins_64(110, 4, 192, 128) → 我们 (0, 96)：BOSS **原地**出现、不移动；
---             ins_75(32, 48, 352, 128) 设夹框（x∈[−160,160]、y∈[96,176]），不移动就用不上。
---             血条 / 符卡登记 / 可伤害开关 / 清场都由 boss 系统管，不另写。
---      t=110  ins_135(0, 6) 挂上 BOSS 的枪；4 个 ins_90 出使魔：(64,128)(320,128) life 1350、
---             (152,220)(232,220) life 750 —— 每条 ins_90 前面那条 ins_7 写 lf1
---             （±0.1570796 = ±π/20），使魔继承它当「每发偏角」。
---      t=550  再 4 个使魔：(32,188)(352,188) life 1350、(162,150)(222,150) life 750，
---             lf1 = ∓0.1047198（±π/30）。
---      t=990  ins_4(110, …) 把 time 拨回 110 ⇒ **同一帧**又跑 t=110 那一段
---             → 之后每 440 帧一批、两批交替（110 / 550 / 990 / 1430 / …）。
---
---  · Sub6（BOSS 的枪，时间轴从挂上那一刻的 0 起算）：
---      t=0    先写好记录槽 1 = ACCELERATE_VECTOR(60 帧、magnitude 1/30、用弹自己的角)。
---      t=200  xi0 = 60，然后**每 4 帧**打一轮、共 60 轮（ins_5 的 loop = 200，
---             而它自己的 t = 204 ⇒ 两轮之间只差 4 帧）。每轮：
---               ins_111 记录槽 0 = CHANGE_DIRECTION_AIMED(60 帧后折向、只折一次、
---                        angle = 偏角 k、speed = 2.5 或 −999 = 用弹当时的原速)
---               lf0 = rndSgn·π/8 + 偏角 k   （rndSgn ∈ [−1,1] 是随机数、不是 ±1，
---                                            EclOperandsFloat.cpp:55）
---               ins_98 出 1 发（type 6、色 2、speed1 = 4.0、angleStep = π/8、flags 658）
---             9 发的偏角 k = 0、±π/8、±π/4、±3π/8、±π/2 —— 朝自机 ±90° 的半个扇面，
---             每发再抖 ±π/8；只有第 1 发折向时保持原速。
---      60 轮走完 → ins_4(0, #1) 等 200 帧再重来。★ 注意 JUMP_DEC 掉出来的那一帧
---      （第 61 次执行、最后一轮 +4）也要算进 epoch ⇒ 一 epoch = 4×60 + 200 = 440 帧。
---      ★ 弹（flags 658 = SPAWN_FAST|ACCEL_VEC|DIR_AIMED|PLAY_SPAWN_SOUND）：
---        10 帧出生动画（位置先退 velocity·4、每帧走 velocity/2）→ 之后 60 帧
---        **按原方向线性减速到停住**（BulletManager.cpp:1255-1291 的 else 分支）→
---        到点那一帧重新瞄「自机 + 偏角 k」、速度换成 2.5（第 1 发换回 4.0）→
---        紧接着 60 帧每帧 velocity += (弹当时的朝向)·(1/30) 一路加速到 4.5 飞出。
---        两条记录是**串行**的：槽 1 的 allowWhileActive = 0，槽 0 还亮着就轮不到它。
---        「先停住、再一起折向自机」就是这张卡的手感来源。
---      ★ 同屏上限 1536（BulletManager.hpp:455）：本卡每 4 帧 9 发 = 2.25 发/帧，
---        弹又要飞一百多帧才回收 ⇒ 池子长期贴着上限，后面的波大半生不出来
---        （原作 :692 整波不生、:698-712 波中间生不出就放弃剩下的，照抄）。
---
---  · Sub8（使魔）：t=0 设 anm/判定、t=60 挂枪、t=260 TERMINATE（整只消失）。
---  · Sub7（使魔的枪，从使魔的 t=60 起算）：
---      xi0 = 3、lf0 = π/2（十字基准角）、li7 = 4（ins_7 SET_SECONDARY_TIME 冻 4 帧）、
---      lf6 = 2.5（速度）。前 3 轮每轮 2 发 ins_99（type 2、色 8、count1 = 4、
---      speed = 2.5、angleStep = π/12、flags 514）→ 每发 4 颗 90° 均分的十字；
---      之后 xi0 = 12，每轮 2 发、**每发之后 lf0 += lf1**（使魔继承来的偏角）再归一化
---      ⇒ 十字一边打一边转（±9° 或 ±6° 一发）。整段 120 帧后 ins_53 RETURN。
---      ★ 每对里的第一条（色 6）在 Lunatic+人类难度下**不执行**（难度掩码判据，
---        EclRun.cpp:69-73）—— 实际只打色 8 的那一半。
---  ★ 占位：使魔 = "servant"（原作 24×24 判定、life 1350/750，按本文件 205..216 的惯例
---    做成纯观感）、弹 = ball_small。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---AddNormalizeAngle(a, 0)（Global.cpp:1231-1252）：卷进 (−π, π]。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

---BOSS 落位（Sub5 t=0 的 ins_64 目标 192, 128 → 我们 (0, 96)）。
local BOSS_X, BOSS_Y = 0, 96

---使魔的两批（ins_90 的绝对坐标 + 它前面那条 ins_7 写的 lf1；角度取反后是我们坐标）。
---life 只用来说明原件里哪几只是硬的 —— 移植版不给判定、不结算。
local FAM_BATCH = {
    {
        { x = 64,  y = 128, life = 1350, d =  0.1570796 },
        { x = 320, y = 128, life = 1350, d = -0.1570796 },
        { x = 152, y = 220, life = 750,  d = -0.1570796 },
        { x = 232, y = 220, life = 750,  d =  0.1570796 },
    },
    {
        { x = 32,  y = 188, life = 1350, d = -0.1047198 },
        { x = 352, y = 188, life = 1350, d =  0.1047198 },
        { x = 162, y = 150, life = 750,  d =  0.1047198 },
        { x = 222, y = 150, life = 750,  d = -0.1047198 },
    },
}
local FAM_FIRST = 110           -- 第一批使魔（Sub5 #22..#29 的 t）
local FAM_PERIOD = 440          -- 两批交替的周期（Sub5 #42 的 ins_4(110, …)）

---使魔自己的节拍（Sub8）。
local FAM_GUN_AT = 60           -- ins_135(0, 7) 挂枪
local FAM_LIFE = 260            -- ins_1 TERMINATE（整只消失）

---使魔的枪（Sub7）。
local FG_STEP = 4               -- li7 = 4（每发之间冻 4 帧）
local FG_SHOTS_A = 6            -- 前半 xi0 = 3 × 每轮 2 发
local FG_SHOTS_B = 24           -- 后半 xi0 = 12 × 每轮 2 发
local FG_END = (FG_SHOTS_A + FG_SHOTS_B) * FG_STEP      -- 120 帧后 ins_53 RETURN
local FG_ANGLE = -PI / 2        -- lf0 = π/2（TH08）→ 我们 −π/2
local FG_SPEED = 2.5            -- lf6（ins_99 的 speed1）
local FG_SPEED2 = 0.5           -- ins_99 的 speed2（count2 = 1，用不上）
local FG_ANGLE_STEP = 0.2617994 -- ins_99 的 angleStep（π/12）
local FG_FLAGS = 514            -- 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND
local FG_TYPE, FG_COLOR = 2, 8  -- ins_99 的 bulletType / color

---BOSS 的枪（Sub6）。
local GUN_ATTACH = 110          -- Sub5 t=110 的 ins_135(0, 6)
local GUN_FIRST = 200           -- 第一轮连发（ins_6 的 t=200）
local GUN_STEP = 4              -- 相邻两轮的帧差（loop 200 与 ins_5 自己的 t=204）
local GUN_ROUNDS = 60           -- xi0
local GUN_PAUSE = 200           -- 连发走完到下一轮 ins_6 之间的等待（ins_4(0, #1)）
local GUN_EPOCH = GUN_STEP * GUN_ROUNDS + GUN_PAUSE            -- 4*60 + 200 = 440
local GUN_TYPE, GUN_COLOR = 6, 2
local GUN_SPEED = 4.0           -- ins_98 的 speed1
local GUN_ANGLE_STEP = PI / 8   -- ins_98 的 angleStep
local GUN_JITTER = PI / 8       -- lf0 = rndSgn · 0.3926991
local GUN_FLAGS = 658           -- 0x292 = SPAWN_FAST|ACCEL_VEC|DIR_AIMED|SPAWN_SOUND
local GUN_TURN_FRAMES = 60      -- 记录槽 0 的 intervalFrames
local GUN_ACCEL = 1 / 30        -- 记录槽 1 的 magnitude（0.03333334）
local GUN_ACCEL_FRAMES = 60     -- ... 的 durationFrames
---9 发的偏角与折向速度（−999 = 用弹当时的原速）。角度取反到我们坐标后正好是同一组。
local GUN_SHOTS = {
    { 0,           -999 },
    { PI / 8,      2.5 },
    { PI / 4,      2.5 },
    { 3 * PI / 8,  2.5 },
    { PI / 2,      2.5 },
    { -PI / 8,     2.5 },
    { -PI / 4,     2.5 },
    { -3 * PI / 8, 2.5 },
    { -PI / 2,     2.5 },
}

---使魔（Sub8）。占位贴图 "servant"；原作它有 24×24 判定与 life，移植版按
---205..216 的惯例做成纯观感（不给判定）。
local familiar = Class(object, {
    init = function(self, x, y, delta)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        self.fam_t = 0                  -- 自己的帧计数器（Sub8 的时间轴）
        self.fam_delta = delta          -- 继承来的 lf1（取反后 = 我们的每发偏角）
        self.fam_ang = FG_ANGLE         -- 枪的 lf0
    end,
    frame = function(self)
        local t = self.fam_t
        ---Sub8 t=260 的 ins_1 TERMINATE → RunEcl 返回 −1 → 敌机 Despawn。
        if t >= FAM_LIFE then
            object.RawDel(self)
            return
        end
        local g = t - FAM_GUN_AT        -- 枪自己的时间轴
        if g >= 0 and g < FG_END and g % FG_STEP == 0 then
            EX.shoot(self, self.x, self.y, {
                op = 99, type = FG_TYPE, color = FG_COLOR,
                count1 = 4, count2 = 1, speed1 = FG_SPEED, speed2 = FG_SPEED2,
                angle = self.fam_ang, step = FG_ANGLE_STEP, flags = FG_FLAGS,
            })
            ---后半（Sub7 #12..#22）：每发之后 lf0 += lf1 再归一化 → 十字一边打一边转。
            if g >= FG_SHOTS_A * FG_STEP then
                self.fam_ang = add_norm(self.fam_ang + self.fam_delta)
            end
        end
        self.fam_t = t + 1
    end,
})

---BOSS 的一轮连发（Sub6 #2..#36 那 9 条 ins_111 + ins_98）。
local function boss_burst(owner)
    for i = 1, #GUN_SHOTS do
        local off = GUN_SHOTS[i][1]
        EX.set_record(owner, 0, EX.K.AIMED, 0, GUN_TURN_FRAMES, 1,
                off, GUN_SHOTS[i][2])
        local angle = ran:Float(-GUN_JITTER, GUN_JITTER) + off
        EX.shoot(owner, owner.x, owner.y, {
            op = 98, type = GUN_TYPE, color = GUN_COLOR,
            count1 = 1, count2 = 1, speed1 = GUN_SPEED, speed2 = 1.0,
            angle = angle, step = GUN_ANGLE_STEP, flags = GUN_FLAGS,
        })
    end
end

local function card_init(owner)
    ---发射源自己的记录表（BOSS 一份、每只使魔各一份）。
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw191_t = 0                   -- 本卡自己的帧计数器
    owner.lw191_flip = false            -- 两批使魔交替的开关
    owner.lw191_fams = {}
    ---落位：BOSS 是**原地**出现的（Sub5 的 ins_64 与 Sub116 的 ins_63 同一个点）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    if not owner.lw191_t then return end
    local t = owner.lw191_t
    owner.lw191_t = t + 1

    ---① BOSS 的枪（子 context 0）：t=110 挂上，之后按它自己的时间轴走。
    local g = t - GUN_ATTACH
    if g >= 0 then
        if g == 0 then
            ---Sub6 #0：记录槽 1 = ACCELERATE_VECTOR(60 帧、1/30、angle −999 = 用弹自己的角)。
            EX.set_record(owner, 1, EX.K.VEC, 0, GUN_ACCEL_FRAMES, 0, GUN_ACCEL, -999)
        end
        local q = g - GUN_FIRST
        if q >= 0 then
            q = q % GUN_EPOCH
            if q % GUN_STEP == 0 and q < GUN_STEP * GUN_ROUNDS then
                boss_burst(owner)
            end
        end
    end

    ---② 使魔：每 440 帧一批、两批交替（Sub5 t=110 / t=550 那两段）。
    if t >= FAM_FIRST and (t - FAM_FIRST) % FAM_PERIOD == 0 then
        owner.lw191_flip = not owner.lw191_flip
        local batch = owner.lw191_flip and FAM_BATCH[1] or FAM_BATCH[2]
        for i = 1, #batch do
            local e = batch[i]
            ---ins_90 = SPAWN_FAMILIAR_AT_POSITION（绝对坐标），角度取反到我们坐标。
            owner.lw191_fams[#owner.lw191_fams + 1] =
                    New(familiar, EX.scr_x(e.x), EX.scr_y(e.y), -e.d)
        end
    end
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw191_t = nil
    owner.lw191_flip = nil
    if owner.lw191_fams then
        for i = #owner.lw191_fams, 1, -1 do
            if IsValid(owner.lw191_fams[i]) then
                object.RawDel(owner.lw191_fams[i])
            end
            owner.lw191_fams[i] = nil
        end
    end
    owner.lw191_fams = nil
    EX.pool_clear()
end

CARD[191] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 192「転世「一条戻り橋」」（上白泽慧音）
---  ecldata8sp.ecl：Sub10 = BOSS 根、Sub11 = **看不见**的发射器（8 台）。
---
---  · Sub10（根；ins_134(3600, 13) = 60 秒、ins_52→Sub5 之外的另一条链）：
---      t=0    ins_64(110, 4, 192, 128) → 我们 (0, 96)：**原地**出现（Sub116 的 ins_63
---             已经把它放在同一个点上，这条插值位移恒 0）。
---      t=110  8 台发射器 = 4 对 × 2 种。每台三步：
---               `ins_7 lf1 = ±ω` → `ins_6 li0 = 色`（6 或 4）→ `ins_94(Sub11, 0,0,0,
---               life 1000, −2, 10)`（相对坐标 ⇒ 生成在 BOSS 身上）。
---             对与对之间 `ins_15 lf0 += π/2` + `ins_37`（lf0 初值 = RANDOM_ANGLE）。
---      t=510  ins_67(60, 4, 1.0)：朝「背离自机 + 边界修正」的方向、OUT_QUADRATIC 缓动
---             在夹框里挪 60 px；t=570 `ins_96` 打 1 发 type10/色1 的自机狙
---             （count1 = 1 ⇒ 扇形展开为 0，就是正对自机；speed 1.0、flags 514）。
---      t=690  ins_4(510, …) 把 time 拨回 510 ⇒ 之后**每 180 帧**重来一次（510/570）。
---
---  · Sub11（发射器；时间轴从生成那一帧的 0 起算）：
---      t=0    ins_80(8) = 置 NO_SPRITE ⇒ 原件里它**不画任何东西**；也正因为 noSprite，
---             EnemyManagerUpdate.cpp:232-256 的「出场后再出屏就回收」两条判据都不成立
---             ⇒ 它飞出场外以后**永远不会被回收**，整张卡一直在打。
---             ins_72(6000, selfX, selfY, lf0, lf1, 0.0, 3.0) = 绕**生成点**公转：
---             圆心 = 生成点、半径 0 起每帧 +3（radialVelocity）、初角 lf0、角速度 lf1
---             （±1.2°/帧 / ±1.03°/帧）。⇒ 8 台在不存在的动画里螺旋着飞出场外。
---             `ins_18 lf1 /= 1.3` —— 这一条只改后面「每发之间的角度增量」，
---             公转角速度用的是**除之前**的值（顺序别搞反）。
---             `ins_111` 三条记录：槽 0 = SET_CULL_DELAY(li6)、槽 1 = WAIT(li6, 允许并发)、
---             槽 2 = DESPAWN。⇒ 弹先按 WAIT 的帧数直飞，WAIT 过期后才轮到 DESPAWN
---             （allowWhileActive = 0 的记录会被活着的位挡住，BulletManager.cpp:322-324）。
---      每 **2** 帧 1 发、每 8 发 li6 += 8（60 → 196 之后被 `ins_6 li6 = 200` 钉在 200）、
---             每发之间 `lf0 += lf1`：出弹角 = ORBIT_ANG + π + lf0 ⇒ **朝生成点（= BOSS）打**。
---             ★ li6 同时是「直飞帧数」和「出屏宽限帧数」：弹在 2 px/帧 下能飞
---               (li6+22)·2 ≈ 164 → 444 px，而发射器在 3 px/帧 地远去 ⇒
---               越到后面越多的弹**打不到中心**就自己消失 —— 这是原件自己的节奏，照抄。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local TAU = 2 * PI

local BOSS_X, BOSS_Y = 0, 96

---夹框：Sub116 的 `ins_75(32, 48, 352, 128)`（TH08 坐标）→ 我们 x∈[−160,160]、y∈[96,176]。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176

---Sub10 的节拍。
local EMIT_AT = 110                     -- 8 台发射器（Sub10 #22..#49 全在 t=110）
local MOVE_FIRST, MOVE_PERIOD = 510, 180
local MOVE_DUR, MOVE_SPEED = 60, 1.0    -- ins_67(60, 4, 1.0)
local FIRE_AT = 60                      -- t=570 的 ins_96（相对 t=510 是第 60 帧）

---发射器（Sub11）。
local EMIT_RADIAL = 3.0                 -- ins_72 的 radialVelocity
local EMIT_SHOT_PERIOD = 2              -- JUMP_DEC 的 loop 时间（+2）
local EMIT_BURST_SHOTS = 8              -- xi0
local EMIT_BURST = EMIT_SHOT_PERIOD * EMIT_BURST_SHOTS      -- 16 帧
local EMIT_CULL0, EMIT_CULL_STEP, EMIT_CULL_MAX = 60, 8, 200
local EMIT_TYPE, EMIT_SPEED = 2, 2.0
local EMIT_STEP = 0.1308997             -- ins_97 的 angleStep（count1 = 1，用不上）
---flags 401922 = 0x62202 = SPAWN_FAST | PLAY_SPAWN_SOUND | SET_CULL_DELAY | WAIT | DESPAWN
local EMIT_FLAGS = 401922
---两种发射器：色 6 用 +ω、色 4 用 −ω（Sub10 #20/#23 那两条 ins_7）。
local EMIT_VARIANTS = {
    { color = 6, omega =  0.0261799395 },
    { color = 4, omega = -0.0224399474 },
}

---BOSS 自己的弹（Sub10 #52 的 ins_96）。
local BOSS_TYPE, BOSS_COLOR = 10, 1
local BOSS_SPEED, BOSS_SPEED2 = 1.0, 0.8
local BOSS_STEP = 0.1308997
local BOSS_FLAGS = 514                  -- 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND

---记录表持有者：8 台发射器的 li6 同步（同一帧生成、同相位），所以共用一份就够。
---（EX.shoot 出弹时会把记录**拷一份**，之后改这里不会动到已经在飞的弹。）
local REC = {}

---AddNormalizeAngle(a, 0)：卷进 (−π, π]。
local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）。
---★ 「x > upper.x − 96」那一支用的是**上一段的移动方向**（原作写法就是 π − movementAngle），
---  不是刚抽到的 angle —— 照抄。
local function wander_angle(owner)
    local bx = owner.x + 192
    local by = 224 - owner.y
    local angle
    if player.x < owner.x then
        angle = wrap_pi(ran:Float(0, PI / 2) + 3 * PI / 4)
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < BW_TH_L + 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.lw192_ang or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---StartTimedPolarDisplacement（EclDependencies.cpp:105-126）：delta = polar(角)·speed·duration，
---圆心 = 当前世界坐标，缓动 = ins_67 的第二个操作数（4 = OUT_QUADRATIC）。
---角度是 TH08 口径（y 朝下）⇒ 我们的位移要取反。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw192_ang = angle
    owner.lw192_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * MOVE_SPEED * MOVE_DUR,
        dy = math.sin(-angle) * MOVE_SPEED * MOVE_DUR,
        t = 0,
    }
end

---插值位移的一帧（EnemyManager.cpp:85-125 的 ENEMY_MOVEMENT_MODE_INTERPOLATED）。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / MOVE_DUR
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)           -- OUT_QUADRATIC
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= MOVE_DUR
end

local function card_init(owner)
    EX.clear_records(REC)
    EX.pool_clear()
    owner.lw192_t = 0
    owner.lw192_emit = nil
    owner.lw192_move = nil
    owner.lw192_ang = 0                       -- movementAngle 初值（EnemyManager.cpp:145-160）
    owner.lw192_org = { x = BOSS_X, y = BOSS_Y }
    ---落位：BOSS **原地**出现（Sub10 t=0 的 ins_64 与 Sub116 的 ins_63 同一个点）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    if not owner.lw192_t then return end
    local t = owner.lw192_t
    owner.lw192_t = t + 1

    ---① t=110：4 对发射器（每对「色 6 正转 + 色 4 反转」），对与对之间 lf0 += π/2。
    if t == EMIT_AT then
        local th0 = ran:Float(-PI, PI)        -- ins_7(lf0, RANDOM_ANGLE)
        local list = {}
        for _ = 1, 4 do
            for v = 1, #EMIT_VARIANTS do
                local e = EMIT_VARIANTS[v]
                list[#list + 1] = {
                    ang0 = th0, omega = e.omega,
                    delta = e.omega / 1.3,    -- ins_18(lf1, 1.3)：只管每发之间的增量
                    color = e.color,
                }
            end
            th0 = wrap_pi(th0 + PI / 2)
        end
        owner.lw192_emit = list
    end

    ---② 发射器：每 2 帧 1 发、每 8 发 li6 += 8、出弹角一律朝生成点。
    local list = owner.lw192_emit
    if list then
        local u = t - EMIT_AT                   -- 发射器自己的时间轴
        if u >= 0 and u % EMIT_SHOT_PERIOD == 0 then
            local li6 = EMIT_CULL0 + EMIT_CULL_STEP * math.floor(u / EMIT_BURST)
            if li6 > EMIT_CULL_MAX then li6 = EMIT_CULL_MAX end
            EX.set_record(REC, 0, EX.K.CULL, 0, li6, 0, 0, 0)
            EX.set_record(REC, 1, EX.K.WAIT, 1, li6, 0, 0, 0)
            EX.set_record(REC, 2, EX.K.DESPAWN, 0, 0, 0, 0, 0)
            local i = math.floor(u % EMIT_BURST / EMIT_SHOT_PERIOD)
            local r = EMIT_RADIAL * u
            local ox, oy = owner.lw192_org.x, owner.lw192_org.y
            for n = 1, #list do
                local e = list[n]
                local th = e.ang0 + e.omega * u
                ---TH08 位置 = 圆心 + polar(θ, r)；我们 = (x−192, 224−y)，角度整体取反。
                EX.shoot(REC, ox + math.cos(th) * r, oy - math.sin(th) * r, {
                    op = 97, type = EMIT_TYPE, color = EX.color(e.color),
                    count1 = 1, count2 = 1, speed1 = EMIT_SPEED, speed2 = EMIT_SPEED,
                    angle = -(th + PI + e.delta * i), step = EMIT_STEP, flags = EMIT_FLAGS,
                })
            end
        end
    end

    ---③ t=510+180k 挪一次、t=570+180k 打一发自机狙（Sub10 #51/#52）。
    if t >= MOVE_FIRST then
        local u = (t - MOVE_FIRST) % MOVE_PERIOD
        if u == 0 then
            begin_wander(owner)
        end
        local move = owner.lw192_move
        if move then
            local x, y, done = move_step(move)
            owner.x, owner.y = x, y
            if done then
                owner.lw192_move = nil
            end
        end
        if u == FIRE_AT then
            EX.shoot(owner, owner.x, owner.y, {
                op = 96, type = BOSS_TYPE, color = EX.color(BOSS_COLOR),
                count1 = 1, count2 = 1, speed1 = BOSS_SPEED, speed2 = BOSS_SPEED2,
                angle = 0, step = BOSS_STEP, flags = BOSS_FLAGS,
            })
        end
    end

    ---④ ClampPosition（EnemyManagerUpdate.cpp:172-174 位移前后各钳一次）。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw192_t = nil
    owner.lw192_emit = nil
    owner.lw192_move = nil
    owner.lw192_ang = nil
    owner.lw192_org = nil
    EX.clear_records(REC)
    EX.pool_clear()
end

CARD[192] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 193「新史「新幻想史　-ネクストヒストリー-」」（上白泽慧音）
---  ecldata8sp.ecl：Sub14 = BOSS 根、Sub15 = BOSS 的枪（子 context 0）、
---  Sub17 = 使魔、Sub16 = 使魔的枪。
---  ★ 全 14 张 EX 卡里唯一「一发 4 颗十字」的使魔枪就在这里（Sub16）。
---
---  · Sub14（根；ins_134(3600, 18) = 60 秒）：
---      t=0    ins_64(110, 4, 192, 128) → 我们 (0, 96)：**原地**出现。
---      t=110  ins_135(0, 15) 挂上 BOSS 的枪；然后**一次**生成 **8 只**使魔
---             （ins_90 = SPAWN_FAMILIAR_AT_POSITION，绝对坐标），每只前面一条
---             ins_7 写 lf1 = ±π/20 / ±π/30（使魔继承它当「每发偏角」）。
---             ★ 与卡 191 的区别：191 是 4+4 两批交替，这里是 8 只一起、每 440 帧一批。
---      t=550  ins_62（演出）之后 `ins_4(110, #20)`：time 拨回 110、跳到 **#20**
---             ⇒ t=110 那 8 个 ins_90 **重跑**，而 ins_135（挂枪）不重跑。
---             ⇒ 之后的节拍：每 440 帧一批 8 只（110 / 550 / 990 / …），枪只挂一次。
---
---  · Sub15（BOSS 的枪）= 卡 191 的 Sub6，只换了弹：**type 18 / 色 1**。
---      t=0    记录槽 1 = ACCELERATE_VECTOR(60 帧、1/30、用弹自己的角)。
---      t=200  xi0 = 60，每 4 帧一轮、共 60 轮，每轮 9 发（偏角 k = 0、±π/8、±π/4、
---             ±3π/8、±π/2，再叠 rndSgn·π/8），记录槽 0 = CHANGE_DIRECTION_AIMED
---             （60 帧后折向自机+偏角 k、速度 2.5；第一条用原速 4.0）。
---      ★ 周期：round 1 在 u=200、round 60 在 u=236；JUMP_DEC 在 u=240 掉出来、
---        `ins_4(0, #1)` 把 time 归零 ⇒ 下一轮 round 1 在 u=440。
---        **epoch = 4×60 + 200 = 440**（不是「最后一次连发 + 200」——JUMP_DEC 自己
---        那一帧也要算进去，卡 191 的 436 是错的，这里一并修正）。
---
---  · Sub17（使魔）：t=0 设 anm/判定、t=60 挂枪（ins_135(0, 16)）、t=260 TERMINATE。
---  · Sub16（使魔的枪，从使魔的 t=60 起算；★ 时间轴靠 SET_SECONDARY_TIME 冻帧排）：
---      xi0 = 2、lf0 = π/2、li7 = 8（每发之间冻 8 帧）、lf6 = 1.2（色 8 的速度）、
---      lf7 = 0.8（色 6 的速度）。
---      前 2 轮每轮「色 6 一发 + 色 8 一发」，**色 6 那两条在人类形态下不执行**
---      （difficultyMask 0x5f = 只有妖怪形态才跑，EclRun.cpp:66-75）⇒ 实际每轮 1 发；
---      后 6 轮同样每轮 2 条、只跑色 8 的那一条，并且 `lf0 += lf1` + 归一化
---      ⇒ 十字一边打一边转。合起来：**14 发、每 8 帧一发**（0/8/…/104），
---      第 3 发起才开始转（前 2 发不转），发完 t=112 处 ins_53 RETURN。
---      ★ 每发是 `ins_99`(SHOOT_CIRCLE) count1 = 4 ⇒ **4 颗 90° 均分的十字**，
---        速度 1.2、angleStep π/12（count1=4 时用不到 step，但照抄）。
---      ★ 色 6（0.8 速）的那一半只在自机是**妖怪**时才出 —— 本移植版按人类形态，
---        所以整条不实现（跟 191 的色 6 处理一致）。
---  ★ 占位：使魔 = "servant"，弹 = ball_small（type 2）/ ball_mid（type 18）。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---AddNormalizeAngle(a, 0)：卷进 (−π, π]。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

local BOSS_X, BOSS_Y = 0, 96

---8 只使魔（Sub14 #21..#35 的绝对坐标 + 它前面那条 ins_7 写的 lf1）。
---d 是**原件**的 lf1（TH08 口径），出弹时取反。
local FAM_BATCH = {
    { x = 64,  y = 128, d =  0.1570796 },
    { x = 320, y = 128, d = -0.1570796 },
    { x = 152, y = 220, d = -0.1570796 },
    { x = 232, y = 220, d =  0.1570796 },
    { x = 32,  y = 188, d = -0.1047198 },
    { x = 352, y = 188, d =  0.1047198 },
    { x = 162, y = 150, d =  0.1047198 },
    { x = 222, y = 150, d = -0.1047198 },
}
local FAM_FIRST = 110
local FAM_PERIOD = 440

---使魔自己的节拍（Sub17）。
local FAM_GUN_AT = 60
local FAM_LIFE = 260

---使魔的枪（Sub16）。
local FG_STEP = 8                       -- li7（SET_SECONDARY_TIME）
local FG_SHOTS_A = 2                    -- 前半 xi0 = 2（每轮 1 条色 6 不跑 + 1 条色 8）
local FG_SHOTS_B = 12                   -- 后半 xi0 = 6（同上，每轮 2 条里只跑色 8）
local FG_END = (FG_SHOTS_A + FG_SHOTS_B) * FG_STEP      -- 112 帧后 ins_53 RETURN
local FG_ANGLE = -PI / 2                -- lf0 = π/2（TH08）→ 我们 −π/2
local FG_SPEED = 1.2                    -- lf6（色 8 那条的 speed1）
local FG_SPEED2 = 0.5
local FG_ANGLE_STEP = 0.2617994         -- π/12
local FG_FLAGS = 514                    -- 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND
local FG_TYPE, FG_COLOR = 2, 8

---BOSS 的枪（Sub15）—— 与卡 191 的 Sub6 同构，只换弹种。
local GUN_ATTACH = 110
local GUN_FIRST = 200
local GUN_STEP = 4
local GUN_ROUNDS = 60
local GUN_PAUSE = 200
---★ epoch = 「60 轮 × 4 帧」+ 停歇 200（JUMP_DEC 掉出来那一帧正好是最后一轮 +4）。
local GUN_EPOCH = GUN_STEP * GUN_ROUNDS + GUN_PAUSE
local GUN_TYPE, GUN_COLOR = 18, 1
local GUN_SPEED = 4.0
local GUN_ANGLE_STEP = PI / 8
local GUN_JITTER = PI / 8
local GUN_FLAGS = 658                   -- SPAWN_FAST|ACCEL_VEC|DIR_AIMED|PLAY_SPAWN_SOUND
local GUN_TURN_FRAMES = 60
local GUN_ACCEL = 1 / 30
local GUN_ACCEL_FRAMES = 60
---9 发的偏角与折向速度（−999 = 用弹当时的原速）。
local GUN_SHOTS = {
    { 0,           -999 },
    { PI / 8,      2.5 },
    { PI / 4,      2.5 },
    { 3 * PI / 8,  2.5 },
    { PI / 2,      2.5 },
    { -PI / 8,     2.5 },
    { -PI / 4,     2.5 },
    { -3 * PI / 8, 2.5 },
    { -PI / 2,     2.5 },
}

---使魔（Sub17）。占位贴图 "servant"；原件里它没有判定（ins_90 会清掉 COLLISION）。
local familiar = Class(object, {
    init = function(self, x, y, delta)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        self.fam_t = 0
        self.fam_delta = delta
        self.fam_ang = FG_ANGLE
    end,
    frame = function(self)
        local t = self.fam_t
        if t >= FAM_LIFE then
            object.RawDel(self)
            return
        end
        local g = t - FAM_GUN_AT
        if g >= 0 and g < FG_END and g % FG_STEP == 0 then
            EX.shoot(self, self.x, self.y, {
                op = 99, type = FG_TYPE, color = EX.color(FG_COLOR),
                count1 = 4, count2 = 1, speed1 = FG_SPEED, speed2 = FG_SPEED2,
                angle = self.fam_ang, step = FG_ANGLE_STEP, flags = FG_FLAGS,
            })
            ---第 3 发（g = 16）起，每发之后 lf0 += lf1 再归一化。
            if g >= FG_SHOTS_A * FG_STEP then
                self.fam_ang = add_norm(self.fam_ang + self.fam_delta)
            end
        end
        self.fam_t = t + 1
    end,
})

---BOSS 的一轮连发（Sub15 #2..#36 的 9 条 ins_111 + ins_98）。
local function boss_burst(owner)
    for i = 1, #GUN_SHOTS do
        local off = GUN_SHOTS[i][1]
        EX.set_record(owner, 0, EX.K.AIMED, 0, GUN_TURN_FRAMES, 1,
                off, GUN_SHOTS[i][2])
        local angle = ran:Float(-GUN_JITTER, GUN_JITTER) + off
        EX.shoot(owner, owner.x, owner.y, {
            op = 98, type = GUN_TYPE, color = EX.color(GUN_COLOR),
            count1 = 1, count2 = 1, speed1 = GUN_SPEED, speed2 = 1.0,
            angle = angle, step = GUN_ANGLE_STEP, flags = GUN_FLAGS,
        })
    end
end

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw193_t = 0
    owner.lw193_fams = {}
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    if not owner.lw193_t then return end
    local t = owner.lw193_t
    owner.lw193_t = t + 1

    ---① BOSS 的枪（子 context 0）：t=110 挂上，之后按它自己的时间轴走。
    local g = t - GUN_ATTACH
    if g >= 0 then
        if g == 0 then
            EX.set_record(owner, 1, EX.K.VEC, 0, GUN_ACCEL_FRAMES, 0, GUN_ACCEL, -999)
        end
        local q = g - GUN_FIRST
        if q >= 0 then
            q = q % GUN_EPOCH
            if q % GUN_STEP == 0 and q < GUN_STEP * GUN_ROUNDS then
                boss_burst(owner)
            end
        end
    end

    ---② 使魔：每 440 帧 8 只（Sub14 t=110 那 8 条 ins_90 被 ins_4 重跑）。
    if t >= FAM_FIRST and (t - FAM_FIRST) % FAM_PERIOD == 0 then
        for i = 1, #FAM_BATCH do
            local e = FAM_BATCH[i]
            owner.lw193_fams[#owner.lw193_fams + 1] =
                    New(familiar, EX.scr_x(e.x), EX.scr_y(e.y), -e.d)
        end
    end
end

local function card_del(owner)
    owner.lw193_t = nil
    if owner.lw193_fams then
        for i = #owner.lw193_fams, 1, -1 do
            if IsValid(owner.lw193_fams[i]) then
                object.RawDel(owner.lw193_fams[i])
            end
            owner.lw193_fams[i] = nil
        end
    end
    owner.lw193_fams = nil
    EX.pool_clear()
end

CARD[193] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 194「時効「月のいはかさの呪い」」（藤原妹红）
---  ecldata8sp.ecl：Sub47 = BOSS 根、Sub48 = 子 context 0（BOSS 的枪·十字）、
---  Sub49 = 子 context 1（BOSS 的枪·八向环）、Sub50 = 使魔（6 只）。
---
---  · Sub47（根；ins_134(3600, 22) = 60 秒、Sub116 #65 的 SET_LIFE 2200）：
---      t=0    ins_64(110, 4, 192, 128) → 我们 (0, 96)：**原地**出现（Sub116 的
---             ins_63 已经把它放在同一个点上，这条插值位移恒 0）。
---      t=110  ins_135(0, 48) / ins_135(1, 49) 挂两条枪。
---             ★ 子 context 的变量是**这一帧**从主 context 整块抄过去的
---             （EclRunHigh.inl:671-675 抄到 secondaryTime 为止 = int + float + extra
---             + 调用参数），而 lf0/lf1 的赋值（#18/#19）排在**后面** —— 好在这两条枪
---             各自的 t=0 都会重设 lf0，继承值没人读，所以顺序差无所谓。
---             ins_90 ×6：6 只使魔 = 两个圆心 × 三种初角。圆心 (96,128) 的三只
---             lf1 = +3°/帧、(288,128) 的三只 lf1 = −3°/帧；初角 lf0 = −π/2，
---             每生一只前 +2π/3。⇒ 我们：圆心 (−96, 96) 与 (+96, 96)。
---      t=170  ins_78(256, 32)：BOSS 的副判定 —— 移植版没有这个概念，跳过。
---      t=230  `ins_4(170, 0)`：**第二个操作数是相对字节偏移**（EclRunLow.inl:239-243
---             的 JUMP = `time = 操作数0` + `指令指针 += 操作数1`），这里是 0
---             ⇒ 指针**原地不动**、只把 time 拨回 170。之后每 60 帧这么来一次，
---             #0..#35 只跑一遍：整段是一个「保活空转」。★ 上一版总结把这个 0
---             读成了「跳回第一条」，于是以为整个根每 60 帧重跑一遍 —— 是错的。
---  · Sub48（子 context 0，本卡招牌）：每 15 帧一组 4 向十字。
---      t=0    记录槽 0 = CHANGE_DIRECTION_AIMED（interval 170 帧、折 1 次、角 0、
---             速度 0.6）、槽 1 = SET_SPRITE(type 9、色 1)；
---             ins_99 type 9 / **色 3** / count1 = 4 / count2 = 1 / speed1 = 3.4 /
---             speed2 = 0.5 / angle = lf0 / step 0 / flags 17026
---             （= SPAWN_FAST | CHANGE_DIRECTION_AIMED | PLAY_SPAWN_SOUND | SET_SPRITE）。
---             ⇒ 弹先按 3.4 飞、170 帧里线性刹到 0（位移 = 3.4·170/2 ≈ 289 px），
---             到点那一帧**朝自机转过去、以 0.6 慢慢爬回来** —— 这就是「诅咒」。
---             ★ 弹还在刹车的这 170 帧里带着折向位 ⇒ 出屏有 128 帧宽限
---             （BulletManager.cpp:861-900）；转向后位被清掉，出屏计数改成**每帧 −1**
---             而不是当场回收（这次顺手把 EX.bullet 那段改对了）。
---             之后 lf1 = RANDOM_ANGLE/256、lf0 += π/25、lf0 += lf1、NORMALIZE_ANGLE。
---      t=15   `ins_4(0, −124)` → 回 #3（0x76ec − 0x7768 = −124，相对偏移）
---             ⇒ 每 15 帧一组，十字整体每轮转 π/25 + 随机 ±π/256。
---  · Sub49（子 context 1，八向环）：每 10 帧一圈。
---      t=0    lf0 = π/2；ins_99 type 2 / **色 10** / count1 = 8 / count2 = 1 /
---             speed1 = 2.0 / speed2 = 0.5 / flags 512；lf0 −= 0.04487989（≈2.5714°
---             = 2π/140）、归一化。
---      t=10   `ins_4(0, −80)` → 回 #1 ⇒ 每 10 帧一圈 8 向环，环每轮反着转 2.57°。
---      ★ flags 512 里既没有出生动画位、也没有记录位 ⇒ 弹当场就在飞，槽 0/1 那两条
---        记录（kind 128 / 16384）都不点亮（AdvanceTransformProgram，
---        BulletManager.cpp:328-332）。
---  · Sub50（使魔）：
---      t=0    ins_57/58/59（主 anm、形态特效、自转）、ins_77(24,24)、
---             ins_72(80000, selfX, selfY, lf0, lf1, 64.0, 0) = **绕生成点公转、
---             半径恒 64**（radialVelocity = 0）、角速度 lf1、duration 80000。
---             ★ 变量是 ins_90 生成时从根 context 抄过来的（SpawnEnemy2 的
---             contextInts 覆盖 int + float + 调用参数，EnemyTimeline.cpp:104-112）
---             ⇒ 每只使魔拿到的是「自己出生那一刻」的 lf0/lf1。
---      t=1    ins_81 ENABLE_INTERACTION_FLAGS 3。
---      t=80001 TERMINATE ⇒ 活 80001 帧 > 整张卡，不会自己死。
---  ★ 同屏上限 1536 发：照抄 BulletManager.cpp:686-712（池满整波不生、波中间生不出
---    就丢掉整波剩下的），由 EX.shoot 负责。
---  ★ 占位：使魔 = "servant"、type 9 = ball_mid、type 2 = ball_small。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---AddNormalizeAngle(a, 0)：卷进 (−π, π]（Global.cpp:1231-1252）。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

local BOSS_X, BOSS_Y = 0, 96
---夹框（Sub116 #22/#29 的 ins_75(32, 48, 352, 128)）→ 我们 x∈[−160,160]、y∈[96,176]。
local BW_L, BW_R, BW_B, BW_T = -160, 160, 96, 176

---Sub47（根）：两条枪与 6 只使魔全在这一帧。
local SETUP_AT = 110

---Sub48（枪 0）。
local G0_PERIOD   = 15              -- JUMP 的 loop 时间
local G0_COUNT    = 4               -- count1（90° 均分的十字）
local G0_TYPE     = 9
local G0_COLOR    = 3
local G0_SPEED    = 3.4
local G0_SPEED2   = 0.5
local G0_SPIN     = 0.1256637       -- lf0 += π/25（TH08 口径）⇒ 我们 −=
local G0_FLAGS    = 17026           -- SPAWN_FAST|AIMED|SPAWN_SND|SET_SPRITE
local G0_TURN_FRAMES = 170          -- AIMED 记录：170 帧里线性刹到 0
local G0_TURN_SPEED  = 0.6          -- ... 然后朝自机以 0.6 爬
local G0_SPR_TYPE, G0_SPR_COLOR = 9, 1     -- 槽 1 = SET_SPRITE

---Sub49（枪 1）。
local G1_PERIOD   = 10
local G1_COUNT    = 8
local G1_TYPE     = 2
local G1_COLOR    = 10
local G1_SPEED    = 2.0
local G1_SPEED2   = 0.5
local G1_ANGLE0   = -PI / 2         -- lf0 = π/2（TH08）⇒ 我们 −π/2
local G1_SPIN     = 0.04487989      -- lf0 −= 0.04487989（TH08）⇒ 我们 +=
local G1_FLAGS    = 512             -- PLAY_SPAWN_SOUND

---Sub50（使魔）。
local FAM_R      = 64.0             -- ins_72 的 radius
local FAM_LIFE   = 80001            -- TERMINATE
local FAM_OMEGA  = 0.05235988       -- ins_72 的 3°/帧
---三种初角：TH08 的 −π/2、−π/2+2π/3、−π/2+4π/3 整体取反 = π/2、−π/6、−5π/6。
local FAM_ANGLES = { PI / 2, -PI / 6, -5 * PI / 6 }
---两组使魔的圆心与转向（TH08 (96,128) ω=+3°/帧 / (288,128) ω=−3°/帧，我们取反）。
local FAM_GROUPS = {
    { x = -96, y = 96, omega = -FAM_OMEGA },
    { x =  96, y = 96, omega =  FAM_OMEGA },
}

---使魔（Sub50）。占位贴图 "servant"；原件里它有 24×24 的判定，移植版不参与伤害
---（跟本文件其它卡的使魔一致）。
local familiar = Class(object, {
    init = function(self, cx, cy, ang0, omega)
        self.x, self.y = cx, cy
        self.fam_cx, self.fam_cy = cx, cy
        self.fam_ang, self.fam_omega = ang0, omega
        self.fam_t = 0
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
    end,
    frame = function(self)
        if self.fam_t >= FAM_LIFE then
            object.RawDel(self)
            return
        end
        ---ORBIT_AROUND_POINT 的一帧（EnemyManager.cpp:31-58）：先走角、半径不动，
        ---位置直接落到圆周上（原作也是这么算：velocity = 圆周点 − 当前位置）。
        self.fam_ang = add_norm(self.fam_ang + self.fam_omega)
        self.x = self.fam_cx + math.cos(self.fam_ang) * FAM_R
        self.y = self.fam_cy + math.sin(self.fam_ang) * FAM_R
        self.fam_t = self.fam_t + 1
    end,
})

---Sub48 #3..#7 的一轮：先按当前角打一组十字，再转 lf0。
local function volley0(owner)
    EX.shoot(owner, owner.x, owner.y, {
        op = 99, type = G0_TYPE, color = EX.color(G0_COLOR),
        count1 = G0_COUNT, count2 = 1, speed1 = G0_SPEED, speed2 = G0_SPEED2,
        angle = owner.lw194_a0, step = 0, flags = G0_FLAGS,
    })
    ---#4..#7：lf1 = RANDOM_ANGLE / 256 → lf0 += π/25 → lf0 += lf1 → NORMALIZE_ANGLE。
    ---RANDOM_ANGLE 每取一次都重摇（EclOperandsFloat.cpp:56）。
    owner.lw194_a0 = add_norm(owner.lw194_a0 - G0_SPIN - ran:Float(-PI, PI) / 256)
end

---Sub49 #1..#3 的一轮。
local function volley1(owner)
    EX.shoot(owner, owner.x, owner.y, {
        op = 99, type = G1_TYPE, color = EX.color(G1_COLOR),
        count1 = G1_COUNT, count2 = 1, speed1 = G1_SPEED, speed2 = G1_SPEED2,
        angle = owner.lw194_a1, step = 0, flags = G1_FLAGS,
    })
    owner.lw194_a1 = add_norm(owner.lw194_a1 + G1_SPIN)     -- Sub49 #2/#3
end

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw194_t = 0
    owner.lw194_a0, owner.lw194_a1 = 0, 0
    owner.lw194_fams = {}
    ---落位：BOSS **原地**出现（Sub47 #11 的 ins_64 与 Sub116 #28 同一个点）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    if not owner.lw194_t then return end
    local t = owner.lw194_t
    owner.lw194_t = t + 1

    ---① t=110：挂两条枪（创建的那一帧就跑第一条）+ 6 只使魔。
    if t == SETUP_AT then
        ---Sub48 的 t=0：两条记录先写进「BOSS 的子弹生成描述符」（ins_111 写的就是
        ---发射源自己的描述符，两条枪共用同一份 —— 原件里也是同一个敌人）。
        EX.set_record(owner, 0, EX.K.AIMED, 0, G0_TURN_FRAMES, 1, 0, G0_TURN_SPEED)
        EX.set_record(owner, 1, EX.K.SPRITE, 0, G0_SPR_TYPE, G0_SPR_COLOR, -1, -1)
        owner.lw194_a0 = ran:Float(-PI, PI)     -- Sub48 #0：lf0 = RANDOM_ANGLE
        owner.lw194_a1 = G1_ANGLE0              -- Sub49 #0：lf0 = π/2（TH08）
        volley0(owner)
        volley1(owner)
        ---ins_90 ×6（#20..#31）。
        for g = 1, #FAM_GROUPS do
            local grp = FAM_GROUPS[g]
            for k = 1, #FAM_ANGLES do
                owner.lw194_fams[#owner.lw194_fams + 1] =
                        New(familiar, grp.x, grp.y, FAM_ANGLES[k], grp.omega)
            end
        end
    end

    ---② 两条枪各自的时间轴（子 context 的 time 从挂上那一帧的 0 起算，CallEclSub
    ---   把 time 清零、当帧就跑 —— EclManager.cpp:69-80 + RunEcl 尾部的子 context 循环）。
    local u = t - SETUP_AT
    if u > 0 then
        if u % G0_PERIOD == 0 then volley0(owner) end
        if u % G1_PERIOD == 0 then volley1(owner) end
    end

    ---③ ClampPosition（EnemyManagerUpdate.cpp:172-174：位移前后各钳一次）。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw194_t = nil
    if owner.lw194_fams then
        for i = #owner.lw194_fams, 1, -1 do
            if IsValid(owner.lw194_fams[i]) then
                object.RawDel(owner.lw194_fams[i])
            end
            owner.lw194_fams[i] = nil
        end
    end
    owner.lw194_fams = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[194] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 195「不死「火之鸟 -凤翼天翔-」」（藤原妹红）
---  ecldata8sp.ecl：Sub51 = BOSS 根、Sub52 = 一次「火之鸟」（一颗使魔 + 6 圈偏移弹）、
---  Sub53 = 那颗使魔（150 发散射）。
---
---  · Sub51（根；ins_134(4620, 26) = 77 秒、Sub116 #74 的 SET_LIFE 2200）：
---      t=0    `ins_64(110, 4, 192, 128)`：跟助手 Sub116 #28 的 `ins_63(192, 128)` 是同一个点
---             ⇒ 我们**原地**出现在 (0, 96)（跟卡 194 一样）。
---      t=170  `li7 = 20`（#20，**整张卡只设这一次**）、`lf0 = π`（#21，每次回跳都会被覆盖）、
---             `lf1 = rndSgn·16`（#22；Sub52 自己会重写 lf1，没人读）。
---             #19 的 `ins_78(256, 32)` 是副判定 —— 移植版没有这个概念，跳过。
---      t=190 / t=330：`lf0 = AIM_TO_PL` + `CALL 52`
---      t=250 / t=390：`ins_67(60, 4, 1.0)` —— 60 帧、缓动 4、位移 60 px 的「边界感知随机漂」
---      t=440  演出（跳过）
---      t=450..510  每 10 帧一发：`lf0 = AIM_TO_PL ∓ {π/2, 1.178097, π/4, 0, π/4, 1.178097, π/2}`
---             + `CALL 52` ⇒ 一轮 9 次 CALL，方向从「自机角 +90°」扫到「−90°」。
---      t=510  `JMP_INT_LT li7 2 -> #48`（本身在 0x7cf4，相对偏移 +44 正好落在 #48 的
---             SET_SECONDARY_TIME 上）：li7 ≥ 2 才 `INT_DEC`；然后 `SET_SECONDARY_TIME li7`
---             ⇒ **冻 li7 帧**（EclRunLow.inl:227-229 + EclRun.cpp:66-72：secondaryTime > 0 的帧
---             只把 secondaryTime 和 time 各 −1，什么指令都不跑）。
---      t=660  `JUMP 170`（#49；相对偏移 −536 = 0x7d30 − 0x218 = 0x7b18 = #21）
---             ⇒ 回 #21 重跑一轮（**#20 的 li7 = 20 不重跑**）。
---      ⇒ 一轮 = 490 帧 + li7 帧；li7 每轮 −1（19、18、…、1），减到 1 之后永远停在 1
---        （#46 判 li7 < 2 就不再减）—— 77 秒里大约跑 9 轮。下面 PROG 表就是照这个节拍排的。
---  · Sub52（**同一帧**跑完的 CALL：EclRunLow.inl:416 的 CALL 把调用者的 context 压栈后
---    公用同一个 context 跑子程序、`RETURN` 时整块还原 ⇒ 子程序里改的变量不外泄）：
---      #0/#1  给 BOSS 的子弹生成描述符写两条记录（每次 CALL 都重写一遍，值不变）：
---             槽 0 = SET_CULL_DELAY(120)、槽 1 = ACCELERATE_VECTOR(120 帧、1/24、角 = 弹自己)。
---      #2     `SPAWN_ENEMY_RELATIVE(sub53, 0, 0, 0, life 1000, itemDrop −2, 0)`
---             → 使魔生成在 BOSS 的位置，飞行方向 = 这次的 lf0。
---      #3..#96  24 发「偏移弹」：`POLAR_TO_CARTESIAN(exF0, exF1, 角, 半径)` +
---             `SET_SHOOT_OFFSET` + `SHOOT_FAN(type 19 / 色 1 / 1 发 / 速度 0.5 / 角 = lf0)`。
---             半径/角序列（角都相对 lf0）：r=32 与 r=16 各 4 发（lf0、lf0+π、lf0±2π/3）、
---             r=64（±3π/4、±2π/3）、r=96（±4π/5、±3π/4）、
---             r=48（±3π/4、±2π/3）、r=80（±4π/5、±3π/4）。
---      #98    中心 1 发 type 7（速度 0.5、角 = lf0）
---      #99    `SHOOT_CIRCLE(type 18 / 色 1 / 32 发 / 速度 2.5 / 基准角 = RANDOM_ANGLE)`
---      ⇒ 57 发/CALL。flags 8722 = CULL|SPAWN_SND|ACCEL_VECTOR|SPAWN_FAST、
---        环的 514 = SPAWN_SND|SPAWN_FAST ⇒ 每颗弹都带 120 帧的 ACCEL_VECTOR（每帧 1/24），
---        速度从 0.5 一路加到 5.5（环是 2.5 直飞）—— 这就是「凤凰展翅」往外扫的那一下。
---      ★ #97 把 BOSS 的 shootOffset 复位成 0 ⇒ 下一次 CALL 从圆心重新开始。
---  · Sub53（使魔）：
---      t=0    `DISABLE_INTERACTION_FLAGS 8`（= ECL_INTERACTION_NO_SPRITE，EclManager.hpp:511
---             ⇒ 隐形）、`SET_DIR_AND_SPEED(lf0, 0.3)`：沿 lf0 直线飞。
---      t=20   `SET_ACCELERATION 0.025`（每帧 +0.025；EnemyManager.cpp:65-72）、
---             槽 0 = SET_CULL_DELAY(120)、槽 1 = WAIT(120)、槽 2 = ACCEL_VECTOR(120, 1/24, 弹角)。
---             ★ 槽 1 的 allowWhileActive = 0 把槽 2 堵住（BulletManager.cpp:317-321）⇒
---             弹先**原地停 120 帧**再开始加速。
---      t=50   `xi0 = 150`，然后每帧一发、共 150 发：半径 lf1 从 32 起每发 +1（涨到 64 钉住）、
---             位置 = 自己 + polar(RANDOM_ANGLE, lf1)、方向 = lf0、速度 0、
---             type 5 / 色 2 / flags 139282 = WAIT|CULL|ACCEL_VECTOR|SPAWN_FAST。
---             ★ `JUMP_DEC(50, −140, xi0)`（#14）的 loop 时间是 50、指令本身在 t=51
---             ⇒ **一帧一发**（不是同一帧 150 发），连打 150 帧之后 TERMINATE。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local HALF_PI = PI / 2
local QUARTER_PI = PI / 4

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）：卷进 (−π, π]。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---自机角。TH08 的 AIM_TO_PL 用了 y 朝下的角度口径，我们整体取反（见文件头）
---⇒ 在我们坐标系里它就是普通的 atan2。
local function aim_to_player(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---TH08 世界坐标 → 我们坐标：x' = x − 192、y' = 224 − y（见文件头）。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---助手 Sub116 #22/#29 的 `ins_75(32, 48, 352, 128)`（同时置 CLAMP_POSITION）：
---我们坐标的夹框 x∈[−160,160]、y∈[96,176]；ins_67 的四条判据拿「边界 ±96/48」去比。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176
local BOSS_X, BOSS_Y = 0, 96

---ins_67 的两个操作数（时长 / 速度；缓动固定 4）。
local WANDER_FRAMES = 60
local WANDER_SPEED  = 1.0

---Sub51 的节拍表：{ECL 时间, 这一帧要做的事}，按时间递增。
---  从卡开始（= Sub51 的 t=0）算起；#49 的 JUMP 170 由 step_ctx 在帧末处理。
local ROUND_HOME = 170                  -- #21（每轮回跳的落点）
local ROUND_END  = 660                  -- #49 所在的时间
local FREEZE_MAX = 20                   -- #20：li7 = 20

---Sub52 的出弹参数。
local S52_TYPE      = 19                -- 偏移弹的 bulletType（色在高 16 位：65555 = 0x10013）
local S52_COLOR     = 1
local S52_SPEED     = 0.5
local S52_FLAGS     = 8722              -- CULL | SPAWN_SND | ACCEL_VECTOR | SPAWN_FAST
local S52_MID_TYPE  = 7                 -- #98 的中心那发（65543 = 0x10007）
local S52_RING_TYPE = 18                -- #99 的 32 向环（65554 = 0x10012）
local S52_RING_N    = 32
local S52_RING_SPEED = 2.5
local S52_RING_FLAGS = 514              -- SPAWN_SND | SPAWN_FAST（环**不**带加速）
local S52_ACCEL     = 1 / 24            -- 记录槽 1 的加速度大小（0.0416667）

---24 发偏移弹的 {相对 lf0 的角, 半径}，**顺序照 ECL**（池满时先丢后面的）。
---★ 角度已经换成我们坐标系（= −TH08 口径）：ECL 里是 lf0±2π/3、lf0±3π/4、lf0±4π/5，
---  取反之后正负号对调。
local S52_RINGS = {
    { d = 0,           r = 32 }, { d = -PI,        r = 32 },
    { d = -2 * PI / 3, r = 32 }, { d =  2 * PI / 3, r = 32 },
    { d = 0,           r = 16 }, { d = -PI,        r = 16 },
    { d = -2 * PI / 3, r = 16 }, { d =  2 * PI / 3, r = 16 },
    { d = -3 * PI / 4, r = 64 }, { d =  3 * PI / 4, r = 64 },
    { d = -2 * PI / 3, r = 64 }, { d =  2 * PI / 3, r = 64 },
    { d = -4 * PI / 5, r = 96 }, { d =  4 * PI / 5, r = 96 },
    { d = -3 * PI / 4, r = 96 }, { d =  3 * PI / 4, r = 96 },
    { d = -3 * PI / 4, r = 48 }, { d =  3 * PI / 4, r = 48 },
    { d = -2 * PI / 3, r = 48 }, { d =  2 * PI / 3, r = 48 },
    { d = -4 * PI / 5, r = 80 }, { d =  4 * PI / 5, r = 80 },
    { d = -3 * PI / 4, r = 80 }, { d =  3 * PI / 4, r = 80 },
}

---Sub53（使魔）的参数。
local SAT_SPEED0    = 0.3               -- #1 SET_DIR_AND_SPEED 的 speed
local SAT_ACCEL     = 0.025             -- #2 SET_ACCELERATION
local SAT_R0        = 32                -- #7 lf1 = 32
local SAT_RMAX      = 64                -- #12 判 lf1 >= 64 就不再涨
local SAT_FIRE_T    = 50                -- #8（t=50）
local SAT_SHOTS     = 150               -- ... xi0 = 150
local SAT_TYPE      = 5                 -- #11 的 bulletType（131077 = 0x20005）
local SAT_COLOR     = 2
local SAT_FLAGS     = 139282            -- WAIT | CULL | ACCEL_VECTOR | SPAWN_FAST
local SAT_VEC_ACCEL = 1 / 24            -- 槽 2 的加速度大小（0.0416667）

---POLAR 模式的一帧（EnemyManager.cpp:65-72）：speed += acceleration，再沿 movementAngle
---把位移加上（RunEcl 末尾 UpdateMovement → EnemyManagerUpdate 的 IntegrateVelocity:936-945）。
local function sat_move(self)
    self.sat_speed = self.sat_speed + SAT_ACCEL
    self.x = self.x + math.cos(self.sat_dir) * self.sat_speed
    self.y = self.y + math.sin(self.sat_dir) * self.sat_speed
end

---Sub53 #9..#11 的一发：位置 = 自己 + polar(RANDOM_ANGLE, lf1)、方向 = lf0、速度 0。
---RANDOM_ANGLE 每取一次都重摇（EclOperandsFloat.cpp:56 = 均匀分布在 [−π, π)）。
local function sat_fire(self)
    local th = ran:Float(-PI, PI)
    EX.shoot(self, self.x + math.cos(th) * self.sat_r,
            self.y + math.sin(th) * self.sat_r, {
        op = 97, type = SAT_TYPE, color = EX.color(SAT_COLOR),
        count1 = 1, count2 = 1, speed1 = 0, speed2 = 0.5,
        angle = self.sat_dir, step = 0, flags = SAT_FLAGS,
    })
end

---使魔（Sub53）。原件是隐形发射器（NO_SPRITE），占位贴图给一张全透明的 "white"。
local satellite = Class(object, {
    init = function(self, x, y, lm0)
        self.x, self.y = x, y
        self.sat_dir = lm0              -- Sub53 #1 的 lf0：飞行方向，也是出弹方向
        self.sat_speed = SAT_SPEED0
        self.sat_r = SAT_R0
        self.sat_shots = 0
        self.sat_t = 0
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "white"
        self.hscale, self.vscale = 0.01, 0.01
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 0
        ---t=20 的三条出弹记录（#3..#5）。写在 init 里等价：这只使魔第一次出弹在 t=50，
        ---在那之前没有任何东西会读它的描述符。
        ---  ★ 槽 1 的 WAIT 把槽 2 堵住（allowWhileActive = 0）⇒ 弹先原地停 120 帧再加速。
        EX.set_record(self, 0, EX.K.CULL, 0, 120, -1, -1, -1)
        EX.set_record(self, 1, EX.K.WAIT, 0, 120, -1, -1, -1)
        EX.set_record(self, 2, EX.K.VEC, 0, 120, -1, SAT_VEC_ACCEL, -999.9)
        ---t=0 那一帧先走一步（原作 RunEcl 末尾的 UpdateMovement + IntegrateVelocity）。
        sat_move(self)
        self.sat_t = 1
    end,
    frame = function(self)
        ---Sub53 的每帧顺序：先跑 ECL（出弹用的是**上一帧末**的位置），再 UpdateMovement。
        if self.sat_t >= SAT_FIRE_T then
            if self.sat_shots >= SAT_SHOTS then
                object.RawDel(self)                     -- #15 TERMINATE
                return
            end
            sat_fire(self)
            self.sat_shots = self.sat_shots + 1
            ---#12/#13：lf1 每轮 +1，涨到 64 就钉住。
            if self.sat_r < SAT_RMAX then self.sat_r = self.sat_r + 1 end
        end
        sat_move(self)
        self.sat_t = self.sat_t + 1
    end,
})

---Sub52（一次 CALL 52）：一颗使魔 + 6 圈偏移弹 + 中心 1 发 + 32 向环，共 57 发。
---lm0 = 这次 CALL 的 lf0（我们坐标系 = 自机角 ± 偏移）。
local function call_52(owner, lm0)
    ---#0/#1：写 BOSS 描述符的两条记录。
    EX.set_record(owner, 0, EX.K.CULL, 0, 120, -1, -1, -1)
    EX.set_record(owner, 1, EX.K.VEC, 0, 120, -1, S52_ACCEL, -999.9)
    ---#2：使魔。
    owner.lw195_sats[#owner.lw195_sats + 1] = New(satellite, owner.x, owner.y, lm0)
    ---#3..#96：24 发偏移弹（从半径 r 的圆周上发射，方向全是 lf0）。
    for i = 1, #S52_RINGS do
        local e = S52_RINGS[i]
        local a = lm0 + e.d
        EX.shoot(owner, owner.x + math.cos(a) * e.r, owner.y + math.sin(a) * e.r, {
            op = 97, type = S52_TYPE, color = EX.color(S52_COLOR),
            count1 = 1, count2 = 1, speed1 = S52_SPEED, speed2 = S52_SPEED,
            angle = lm0, step = 0, flags = S52_FLAGS,
        })
    end
    ---#98：中心那一发。
    EX.shoot(owner, owner.x, owner.y, {
        op = 97, type = S52_MID_TYPE, color = EX.color(S52_COLOR),
        count1 = 1, count2 = 1, speed1 = S52_SPEED, speed2 = S52_SPEED,
        angle = lm0, step = 0, flags = S52_FLAGS,
    })
    ---#99：32 向环，基准角 = RANDOM_ANGLE（每执行一次重摇一次）。
    EX.shoot(owner, owner.x, owner.y, {
        op = 99, type = S52_RING_TYPE, color = EX.color(S52_COLOR),
        count1 = S52_RING_N, count2 = 1, speed1 = S52_RING_SPEED, speed2 = 0.5,
        angle = ran:Float(-PI, PI), step = 0, flags = S52_RING_FLAGS,
    })
end

---`ins_67` = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---先抽方向（自机在左：3π/4 + ran(π/2)、带上 AddNormalizeAngle；在右：ran(π/2) − π/4），
---再过四条边界修正，最后交给 StartTimedPolarDisplacement（:105-126）：位移 =
---(cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4。
---★「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle` —— 用的是**上一段**
---  的移动方向、不是刚抽到的角（原作自己的怪癖，照抄，别「修」）。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, HALF_PI) + 3 * PI / 4)
    else
        angle = ran:Float(0, HALF_PI) - QUARTER_PI
    end
    if bx < BW_TH_L + 96 then
        if angle > HALF_PI then
            angle = PI - angle
        elseif angle < -HALF_PI then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < HALF_PI and angle >= 0 then
            angle = PI - owner.lw195_mv_angle
        elseif angle > -HALF_PI and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

local function begin_wander(owner)
    local angle = wander_angle(owner)               -- TH08 口径
    owner.lw195_mv_angle = angle                    -- = enemy->movementAngle（#47 用得上）
    owner.lw195_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,   -- 我们坐标系 = 角取反
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：movementTimer-- →
---progress = 1 − timer/duration → 套缓动（4 = OUT_QUADRATIC，EclManager.hpp:524）→
---position = origin + delta·progress；timer 归零那一帧直接落在终点。
local function step_move(owner)
    local mv = owner.lw195_move
    if mv == nil then return end
    mv.t = mv.t + 1
    if mv.t >= mv.n then
        owner.x, owner.y = mv.x0 + mv.dx, mv.y0 + mv.dy
        owner.lw195_move = nil
        return
    end
    local u = mv.t / mv.n
    local e = 1 - (1 - u) * (1 - u)
    owner.x = mv.x0 + mv.dx * e
    owner.y = mv.y0 + mv.dy * e
end

---Sub51 的节拍（每项 = {ECL 时间, 这一帧要做的事}）。
---★ 时间从 0 起算（= Sub51 的 t=0，卡 195 开始那一帧），所以第一轮的第一个 CALL 在
---  ctx.t = 190 那一帧；#49 的 JUMP 170 落在 170（**不是 0**）—— 之后每轮从 #21 起跑。
local PROG = {
    { 190, function(owner) call_52(owner, aim_to_player(owner.x, owner.y)) end },
    { 250, function(owner) begin_wander(owner) end },
    { 330, function(owner) call_52(owner, aim_to_player(owner.x, owner.y)) end },
    { 390, function(owner) begin_wander(owner) end },
    { 450, function(owner) call_52(owner, aim_to_player(owner.x, owner.y) + HALF_PI) end },
    { 460, function(owner) call_52(owner, aim_to_player(owner.x, owner.y) + 1.1780972) end },
    { 470, function(owner) call_52(owner, aim_to_player(owner.x, owner.y) + QUARTER_PI) end },
    { 480, function(owner) call_52(owner, aim_to_player(owner.x, owner.y)) end },
    { 490, function(owner) call_52(owner, aim_to_player(owner.x, owner.y) - QUARTER_PI) end },
    { 500, function(owner) call_52(owner, aim_to_player(owner.x, owner.y) - 1.1780972) end },
    { 510, function(owner)
        call_52(owner, aim_to_player(owner.x, owner.y) - HALF_PI)
        ---#46..#48：li7 ≥ 2 才减一，然后 SET_SECONDARY_TIME li7 ⇒ 冻 li7 帧。
        local c = owner.lw195_ctx
        if c.li7 >= 2 then c.li7 = c.li7 - 1 end
        c.freeze = c.li7
    end },
    ---#49 的 `JUMP 170`：拨回 time 并**当场**从 #21 续跑 ⇒ 回跳本身也得写成一项，
    ---否则会慢一帧（一轮变成 491 帧）。
    { ROUND_END, function(owner)
        local c = owner.lw195_ctx
        c.t, c.i = ROUND_HOME, 1
    end },
}

---Sub51 的调度（照抄 EclRun.cpp:52-119 的 RunEcl 主循环）：
---  ① secondaryTime > 0 的帧：只把 secondaryTime 和 time 各 −1，什么都不跑；
---  ② 否则把 time 上所有 time == 当前 time 的指令依次跑完（#44..#48 就是这么挤在一帧的）；
---  ③ 帧末 time++；#49 的 JUMP 170 是 PROG 的最后一项 —— JUMP 改完 time 就
---     `goto low_redispatch_instruction`（EclRunLow.inl:239-243）⇒ 落点那条指令
---     **同一帧**接着跑，所以 while 会立刻去匹配新一轮的第一条。
local function step_ctx(owner)
    local c = owner.lw195_ctx
    if c.freeze > 0 then
        c.freeze = c.freeze - 1
        return
    end
    ---★ 步进要**先加再跑**：回跳那一项会把 c.i 拨回 1，若像平常那样「跑完再 ++」，
    ---  它会被循环自己的 ++ 顶成 2 —— 新一轮的第一条（t=190 的 CALL）就被跳过了。
    while c.i <= #PROG and PROG[c.i][1] == c.t do
        local fn = PROG[c.i][2]
        c.i = c.i + 1
        fn(owner)
    end
    c.t = c.t + 1
end

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw195_ctx = { t = 0, freeze = 0, li7 = FREEZE_MAX, i = 1 }
    owner.lw195_sats = {}
    owner.lw195_move = nil
    owner.lw195_mv_angle = 0
    ---落位：跟助手 Sub116 #28 的 `ins_63(192, 128)` 同一个点（Sub51 的 ins_64 是原地插值）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    if not owner.lw195_ctx then return end
    ---① RunEcl（Sub51 的调度）
    step_ctx(owner)
    ---② 位移：ins_67 的插值漂移在 RunEcl 之后、ClampPosition 之前跑
    ---   （EnemyManagerUpdate.cpp:159-192）。
    step_move(owner)
    ---③ ClampPosition（EnemyManagerUpdate.cpp:172-174；助手置了 ins_75 的夹框）。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw195_ctx = nil
    owner.lw195_move = nil
    if owner.lw195_sats then
        for i = #owner.lw195_sats, 1, -1 do
            if IsValid(owner.lw195_sats[i]) then
                object.RawDel(owner.lw195_sats[i])
            end
            owner.lw195_sats[i] = nil
        end
    end
    owner.lw195_sats = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[195] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---------------------------------------------------------------
---卡 196「藤原「灭罪寺院伤」」（藤原妹红）
---  ecldata8sp.ecl：Sub54 = BOSS 根、Sub55 = 使魔、Sub56 = 使魔身上那把枪。
---
---  · Sub54（根；`ins_134(3720, 24)` = 62 秒、Sub116 #75 的 SET_LIFE 2200）：
---      t=0    `ins_64(110, 4, 192, 128)`：跟助手 Sub116 #28 的 `ins_63(192, 128)` 同点
---             ⇒ 我们**原地**出现在 (0, 96)（跟 194/195 一样）。
---      t=170  `lf0 = π`（#20）→ `lf1 = rndSgn·16`（#21）→
---             `ins_91(Sub55, lf1, 0, 13500, −2, 100)`（#22）→ `lf0 = 0`（#23）→
---             又一模一样的 `ins_91`（#24）。
---             ★ 两只使魔生成在**同一个点**（x 偏移用的是同一个 lf1 = ±16），但方向相反。
---      t=230  `ins_67(60, 4, 1.0)`：60 帧、缓动 4、位移 60 px 的「边界感知随机漂」。
---      t=350  `JUMP 170`（#26，off=0x8d84、相对偏移 −160 → 0x8ce4 = #20）⇒ 回 #20 重跑。
---             ★ JUMP 是**先把 time 拨回 170、再当场从落点续跑**（EclRunLow.inl:239-243
---               改完 time 就 goto low_redispatch_instruction）⇒ t=170 那批指令与 JUMP
---               同帧执行 ⇒ 一轮正好 350 − 170 = 180 帧。
---  · `ins_91` = SPAWN_FAMILIAR_AT_OFFSET（EclRunLow.inl:819-821 →
---    EclDependencies.cpp:621-650 SpawnChildAtParentOffset）：
---      位置 = (READ_FLOAT(1), READ_FLOAT(2), 0) + **自己的 worldPosition**；
---      第 0 操作数是子程序号、第 3/4/5 操作数 = life / itemDropType / score
---      （EnemyTimeline.cpp:64-113 SpawnEnemy2）。
---    ★ 使魔的**整数与浮点变量整块继承**（SpawnEnemy2 里把 intVariables 一直拷到
---      secondaryTime 之前：EnemyTimeline.cpp:93-95；字段布局 EclManager.hpp:599-620）
---      ⇒ #22 的使魔拿到 lf0 = π（左飞）、#24 的拿到 lf0 = 0（右飞）。
---  · Sub55（使魔；life 13500 ⇒ 整张卡打不死；移植版按本文件惯例不参与伤害）：
---      t=0    `ins_54(57)` 主 ANM、`ins_65(lf0, 1.0)` 定速直飞（方向 = 从 BOSS 继承的 lf0）、
---             `ins_77(24, 24)` 判定、`ins_136(30)` 减伤计时。
---      t=1    `ENABLE_INTERACTION_FLAGS 3`（有贴图）、`ins_135(0, 56)` 给使魔挂**子 ECL**
---             = 那把枪（EclRunHigh.inl:646-679：子 context 的 time 从 0 起、挂上那一帧
---             就跟着主 context 一起跑）。
---      t=80001 `TERMINATE`（等于不休止）⇒ 实际靠「出场后再出屏就回收」清掉
---             （EnemyManagerUpdate.cpp:228-256：有贴图、且已经进过场地的敌人，出屏就 Del）。
---  · Sub56（枪；每 14 帧一轮、每轮 2 发）：
---      t=0    两条 `ins_111`（SET_BULLET_TRANSFORM，EclRunHigh.inl:242-264）：
---               槽 0 = BOUNCE_ALL_EDGES（kind 0x400）：速度 2.0、bounceLimit = 0
---                      （payload 布局 BulletManager.hpp:43-49；`bouncesCompleted(1) >= 0`
---                       ⇒ **弹弹一次之后就把反弹位清掉**，BulletManager.cpp:1411-1418）；
---               槽 1 = SET_SPRITE（kind 0x4000）：type 11 / 色 4。
---             `ins_99` SHOOT_CIRCLE：type 11 / 色 6、count1 = 2、count2 = 1、速度 3.5、
---                     基准角 = π/2（我们坐标 −π/2 ⇒ 朝自机方向上下各一发）、
---                     flags = 17920 = SET_SPRITE | BOUNCE_ALL | PLAY_SPAWN_SOUND。
---             ★ 槽 1 的 allowWhileActive = 0，而槽 0 已经把 activeTransformFlags 点亮
---               ⇒ 换色那条记录要等**第一次反弹把反弹位清掉**之后才轮得到（BulletManager.cpp:317-321）。
---      t=14   `JUMP 0`（#3，off=0x8ed4、相对偏移 −44 → 0x8ea8 = #2）⇒ 回到 t=0 的 #2
---             ⇒ **14 帧一轮**（time 走到 14 就拨回 0 重打）。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local HALF_PI = PI / 2
local QUARTER_PI = PI / 4

---AddNormalizeAngle(a, 0)（Global.cpp:1231-1252）：卷进 (−π, π]。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

local function wrap_pi(a)
    if a > PI then a = a - 2 * PI elseif a < -PI then a = a + 2 * PI end
    return a
end

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---助手 Sub116 #22/#29 的 `ins_75(32, 48, 352, 128)`（同时置 CLAMP_POSITION）：
---我们坐标的夹框 x∈[−160,160]、y∈[96,176]；ins_67 的四条判据拿「边界 ±96/48」去比。
local BW_TH_L, BW_TH_R = 32, 352
local BW_TH_B, BW_TH_T = 48, 128
local BW_L, BW_R = -160, 160
local BW_B, BW_T = 96, 176
local BOSS_X, BOSS_Y = 0, 96

---ins_67 的两个操作数（时长 / 速度；缓动固定 4）。
local WANDER_FRAMES = 60
local WANDER_SPEED  = 1.0

---Sub54 的节拍（PROG 表用）。
local ROUND_HOME = 170                  -- #20（JUMP 的落点）
local ROUND_END  = 350                  -- #26 JUMP 所在的时间

---Sub55（使魔）。
local FAM_OFF_X = 16                    -- #21 lf1 = rndSgn·16（两只使魔共用同一个值）
local FAM_SPEED = 1.0                   -- #6 SET_DIR_AND_SPEED(lf0, 1.0) 的 speed
local FAM_HALF  = 12                    -- #3 SET_HITBOX(24, 24) 的一半（回收判据用）

---Sub56（枪）。
local GUN_FIRST_T  = 1                  -- 子 ECL 在使魔的 t=1 那一帧挂上、并当场开跑
local GUN_INTERVAL = 14                 -- #3 的 `JUMP 0 -> #2` ⇒ 14 帧一轮
local GUN_TYPE     = 11
local GUN_COLOR    = 6
local GUN_SPRITE_COLOR = 4              -- 槽 1 SET_SPRITE 的色号
local GUN_SPEED    = 3.5
local GUN_FLAGS    = 17920              -- SET_SPRITE | BOUNCE_ALL | PLAY_SPAWN_SOUND
local GUN_BOUNCE_SPEED = 2.0            -- 槽 0 的 float0
local GUN_BOUNCE_LIMIT = 0              -- 槽 0 的 int0

---出屏判据（IsWithinPlayfield 的反面，GameManager.cpp:132-150）。半宽传精灵尺寸就行 ——
---这里只用它决定使魔什么时候被回收，差几个像素看不出来。
local PLAY_L, PLAY_R, PLAY_B, PLAY_T = -192, 192, -224, 224
local function outside_field(x, y, half)
    return x + half < PLAY_L or x - half > PLAY_R
            or y + half < PLAY_B or y - half > PLAY_T
end

---`ins_67` = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---先抽方向（自机在左：3π/4 + ran(π/2)、带上 AddNormalizeAngle；在右：ran(π/2) − π/4），
---再过四条边界修正，最后交给 StartTimedPolarDisplacement（:105-126）：位移 =
---(cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4。
---★「x > upper.x − 96」那条把角度改写成 `π − enemy->movementAngle` —— 用的是**上一段**
---  的移动方向、不是刚抽到的角（原作自己的怪癖，照抄，别「修」）。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, HALF_PI) + 3 * PI / 4)
    else
        angle = ran:Float(0, HALF_PI) - QUARTER_PI
    end
    if bx < BW_TH_L + 96 then
        if angle > HALF_PI then
            angle = PI - angle
        elseif angle < -HALF_PI then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < HALF_PI and angle >= 0 then
            angle = PI - owner.lw196_mv_angle
        elseif angle > -HALF_PI and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

local function begin_wander(owner)
    local angle = wander_angle(owner)               -- TH08 口径
    owner.lw196_mv_angle = angle                    -- = enemy->movementAngle（边界修正要用）
    owner.lw196_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,   -- 我们坐标系 = 角取反
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：movementTimer-- →
---progress = 1 − timer/duration → 套缓动（4 = OUT_QUADRATIC）→
---position = origin + delta·progress；timer 归零那一帧直接落在终点。
local function step_move(owner)
    local mv = owner.lw196_move
    if mv == nil then return end
    mv.t = mv.t + 1
    if mv.t >= mv.n then
        owner.x, owner.y = mv.x0 + mv.dx, mv.y0 + mv.dy
        owner.lw196_move = nil
        return
    end
    local u = mv.t / mv.n
    local e = 1 - (1 - u) * (1 - u)
    owner.x = mv.x0 + mv.dx * e
    owner.y = mv.y0 + mv.dy * e
end

---使魔（Sub55）的一步位移（SET_DIR_AND_SPEED 定速直飞，没有加速度）。
local function fam_step(self)
    self.x = self.x + math.cos(self.fam_dir) * FAM_SPEED
    self.y = self.y + math.sin(self.fam_dir) * FAM_SPEED
end

---Sub56 #2 的一轮：2 发（基准角 ±π）圆环，速度 3.5、带 SET_SPRITE/BOUNCE_ALL 位。
local function fam_fire(self)
    EX.shoot(self, self.x, self.y, {
        op = 99, type = GUN_TYPE, color = EX.color(GUN_COLOR),
        count1 = 2, count2 = 1, speed1 = GUN_SPEED, speed2 = 0.5,
        angle = -HALF_PI, step = 0, flags = GUN_FLAGS,
    })
end

---使魔（Sub55）。占位贴图 "servant"（原件是 anm 57 的使魔立绘，最后统一换素材）。
local familiar = Class(object, {
    init = function(self, x, y, dir)
        self.x, self.y = x, y
        self.fam_dir = dir              -- 飞行方向（我们坐标 = Sub55 #6 的 lf0 取反）
        ---★ 使魔自己的 ECL 时间。init 里跑掉的 = t=0（SET_DIR_AND_SPEED + UpdateMovement），
        ---  而**同一帧**它会再被更新一次（EnemyManagerUpdate.cpp:126-160 的循环是按
        ---  下标 0..479 跑的，BOSS 在前面、使魔被 SpawnEnemy2 塞进后面的空位 ⇒ 同一帧
        ---  还会跑一次 RunEcl），那一次跑的就是 t=1（挂枪、当场打第一轮）——所以这里
        ---  预置成 1，让本帧稍后的 frame() 正好处理 t=1。
        self.fam_t = GUN_FIRST_T
        self.fam_gun = false            -- t=1 才挂上枪（#8 的 ins_135）
        self.fam_seen = false           -- ENEMY_FLAG_HAS_BEEN_IN_BOUNDS
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        ---Sub56 #0/#1 的两条 ins_111 记录。挂在**使魔**身上：原件里子 ECL 的
        ---TH08_ECL_CONTEXT_ENEMY 就是这只使魔，子弹描述符也写在它身上。
        EX.clear_records(self)
        EX.set_record(self, 0, EX.K.BOUNCE_ALL, 0, GUN_BOUNCE_LIMIT, -1, GUN_BOUNCE_SPEED, -1)
        EX.set_record(self, 1, EX.K.SPRITE, 0, GUN_TYPE, GUN_SPRITE_COLOR, -1, -1)
        ---t=0 那一帧：SET_DIR_AND_SPEED 跑完，RunEcl 末尾的 UpdateMovement 先走一步。
        fam_step(self)
    end,
    frame = function(self)
        ---① 使魔自己的 ECL：t=1 挂枪（#7/#8），之后没有别的指令。
        if self.fam_t == GUN_FIRST_T then self.fam_gun = true end
        ---② 枪（子 ECL）：挂上那一帧打 #2，之后每 14 帧一轮（#3 的 JUMP 0 → #2）。
        if self.fam_gun and (self.fam_t - GUN_FIRST_T) % GUN_INTERVAL == 0 then
            fam_fire(self)
        end
        ---③ RunEcl 末尾的 UpdateMovement。
        fam_step(self)
        ---④ 「出场后再出屏就回收」（EnemyManagerUpdate.cpp:228-256）。
        if not self.fam_seen then
            if not outside_field(self.x, self.y, FAM_HALF) then self.fam_seen = true end
        elseif outside_field(self.x, self.y, FAM_HALF) then
            object.RawDel(self)
            return
        end
        self.fam_t = self.fam_t + 1
    end,
})

---Sub54 #22/#24：生成一对同点反向的使魔（两块浮点变量分别继承 lf0 = π 与 0）。
local function spawn_pair(owner)
    local off = ran:Sign() * FAM_OFF_X
    owner.lw196_fams[#owner.lw196_fams + 1] =
            New(familiar, owner.x + off, owner.y, -PI)          -- 左飞（TH08 π 取反）
    owner.lw196_fams[#owner.lw196_fams + 1] =
            New(familiar, owner.x + off, owner.y, 0)            -- 右飞（TH08 0）
end

---Sub54 的节拍表：{ECL 时间, 这一帧要做的事}，按时间递增。
local PROG = {
    { ROUND_HOME, function(owner) spawn_pair(owner) end },
    { 230, function(owner) begin_wander(owner) end },
    ---#26 的 `JUMP 170`。★ 步进「先加再跑」（见 step_ctx）：改完 c.t/c.i 之后 while 会
    ---立刻接着匹配新一轮的第一条 —— 也就是 t=170 的 spawn 与 JUMP **同帧**发生。
    { ROUND_END, function(owner)
        local c = owner.lw196_ctx
        c.t, c.i = ROUND_HOME, 1
    end },
}

---Sub54 的调度（照抄 EclRun.cpp:52-119 的 RunEcl 主循环）：把 time 上所有
---time == 当前 time 的指令依次跑完，然后帧末 time++。
local function step_ctx(owner)
    local c = owner.lw196_ctx
    ---★ 先加再跑：回跳那一项会把 c.i 拨回 1，若「跑完再 ++」会被循环自己的 ++ 顶成 2，
    ---  新一轮的第一条就被跳过了。
    while c.i <= #PROG and PROG[c.i][1] == c.t do
        local fn = PROG[c.i][2]
        c.i = c.i + 1
        fn(owner)
    end
    c.t = c.t + 1
end

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw196_ctx = { t = 0, i = 1 }
    owner.lw196_fams = {}
    owner.lw196_move = nil
    owner.lw196_mv_angle = 0
    ---落位：跟助手 Sub116 #28 的 `ins_63(192, 128)` 同一个点（Sub54 的 ins_64 是原地插值）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    if not owner.lw196_ctx then return end
    ---① RunEcl（Sub54 的调度）
    step_ctx(owner)
    ---② 位移：ins_67 的插值漂移在 RunEcl 之后、ClampPosition 之前跑
    ---   （EnemyManagerUpdate.cpp:159-192）。
    step_move(owner)
    ---③ ClampPosition（EnemyManagerUpdate.cpp:172-174；助手置了 ins_75 的夹框）。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw196_ctx = nil
    owner.lw196_move = nil
    if owner.lw196_fams then
        for i = #owner.lw196_fams, 1, -1 do
            if IsValid(owner.lw196_fams[i]) then
                object.RawDel(owner.lw196_fams[i])
            end
            owner.lw196_fams[i] = nil
        end
    end
    owner.lw196_fams = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[196] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 197「不死「徐福时空」」（藤原妹红）
---  ecldata8sp.ecl：Sub57 = BOSS 根、Sub58 = 使魔、Sub59 = 使魔的枪、
---  Sub60 / Sub61 = **BOSS 自己**的两把枪（`ins_135` 挂的子 ECL）。
---
---  · Sub57（根；`ins_134(5400, 28)` = 90 秒、Sub116 #76 的 SET_LIFE 2500）：
---      t=0    `ins_76` DISABLE_MOVEMENT_BOUNDS（EclRunLow.inl:636-638 清 CLAMP_POSITION）
---             ⇒ **本卡不夹框**（所以 frame 里没有 ClampPosition）。
---             `ins_64(110, 4, 192, 128→192)` = MOVE_TO(110, 缓动 4, 192, 192)：
---             ConfigureRelativeMotion（EclHelpers.cpp:59-84）把 origin 定在**当前位置**
---             (= (192, 128))、delta = 目标 − worldPosition ⇒ 我们坐标里是从 (0, 96)
---             向下 64 px 漂到 **(0, 32)**、110 帧、缓动 4（EclRun.cpp:140-158 的 OUT_QUADRATIC）。
---      t=170  `lf2 = π`（#21）、`lf3 = π/2`（#22）—— **这两条每轮回跳都跳过**（见 #56）；
---             `ins_135(0, 60)` / `ins_135(1, 61)`（#23/#24）给 BOSS 挂两把枪 ——
---             **整张卡只挂这一次**（#56 的 JUMP 落在 #25 上）；
---             `lf1 = π/2`（#25）、`lf0 = lf2 = π`（#26）、`li7 = 6`（#27），然后 4 只使魔：
---             `ins_91(Sub58, 0, 0, 13500, −2, 100)` + `lf0 += π/2` + 归一化 ⇒
---             使魔生成在 **BOSS 身上**、方向依次 π、−π/2、0、π/2（TH08 口径 = 4 个正方向）。
---      t=270  `lf1 = −π/2`（#38）、`lf0 += π/2` → π（#39/#40）、`li7 = 2`（#41）、
---             `lf3 += π`（#42/#43）⇒ 这一批的 lf3 = −π/2，再 4 只使魔（方向同样是 4 个正方向）、
---             `lf3 += π`（#54/#55）⇒ 每轮结束时 lf3 回到 π/2。
---      t=370  `JUMP 170 -> #25`（#56，off=0x9f74、相对偏移 −?）⇒ 回 **#25** 重跑 ⇒
---             #20..#24 只跑一次；一轮 = 370 − 170 = **200 帧**。
---      ⇒ 每轮 8 只使魔：4 只在轮首（lf1 = +π/2、lf3 = +π/2）、4 只在 100 帧后
---        （lf1 = −π/2、lf3 = −π/2）。
---  · Sub58（使魔；life 13500 ⇒ 整张卡打不死，移植版按本文件惯例不参与伤害）：
---      t=0    主 ANM 57、判定 24×24、`ins_82` SET_MIN_PLAYER_DISTANCE 0（等于没设）。
---      t=1    `ENABLE_INTERACTION_FLAGS 3`、`li0 = 27`、`ins_135(0, 59)` 挂枪，然后循环：
---               #10 `ins_66 MOVE_IN_DIR(li0, 4, lf0, 3.0)`：ConfigurePolarMotion
---                   （EclHelpers.cpp:27-56）位移 = (cos,sin)(lf0)·3.0·li0、origin = 当前位置、
---                   时长 li0、缓动 4；#11 `lf0 += lf1`（每段转 ±90°）；
---               #12 `SET_SECONDARY_TIME li0` ⇒ **冻 li0 帧**（EclRun.cpp:66-72：secondaryTime > 0
---                   的帧只把 secondaryTime 和 time 各 −1）；#13 `li0 += 27`；#15 `JUMP 1 -> #10`。
---             ⇒ 一段 = li0 帧（27、54、81、108…），位移的插值在冻结期间照样走
---               （UpdateMovement 在 RunEcl 之外）⇒ 每段正好用 li0 帧走完 li0·3 px。
---      t=80001 `TERMINATE`（等于不休止）⇒ 靠「出场后再出屏就回收」清掉。
---  · Sub59（使魔的枪；每 4 帧 2 发）：
---      t=0    三条 `ins_111`：槽 0 = WAIT(70)、槽 1 = ACCEL_VECTOR(70 帧、0.025、角 = lf3)、
---             槽 2 = DESPAWN；`ins_97 SHOOT_FAN`：type 11 / 色 7、count1 = 2、速度 0、
---             角 = lf3、flags = 393746 = DESPAWN | WAIT | PLAY_SPAWN_SOUND | ACCEL_VECTOR | SPAWN_FAST。
---             ⇒ 弹**原地**等 70 帧 → 沿 lf3 加速 70 帧（0.025/帧 ⇒ 末速 1.75）→ 消失。
---             ★ count1 = 2 且 step = 0 ⇒ 两发完全重叠（原作就是这样）。
---      t=4    `JUMP 0 -> #3` ⇒ 4 帧一轮。
---  · Sub60（BOSS 的 0 号枪）：t=180 起每 60 帧：`lf0 = rndSgn·3°`（#1 是 FLOAT_MUL、直接覆盖）
---     → `lf0 += −π/2`（#2）⇒ 基准角 = π/2 偏 ±3°（我们坐标 = −lf0）；
---     `ins_97` 打 **85 发**扇（step = 3.75° ⇒ 扫 ±157.5°）、速度 1.6、flags 512。
---  · Sub61（BOSS 的 1 号枪）：t=180 起每 20 帧：同样 ±3° 抖动 + `ins_96 SHOOT_FAN_AIMED`
---     1 发自机狙、速度 0.8、flags 514。
---     ★ 两把枪的子 context 都是 t=170 那一刻建的（`SET_CHILD_ECL` 会先释放旧的子 context，
---       EclRunHigh.inl:646-679），而那两条**不在回跳范围里** ⇒ 枪的时间轴整张卡连续走。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local HALF_PI = PI / 2

---AddNormalizeAngle(a, 0)（Global.cpp:1231-1252）：卷进 (−π, π]。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

---BOSS 落位与 MOVE_TO 的终点（TH08 (192,128) → (192,192)）。
local BOSS_X, BOSS_Y = 0, 96
local MOVE_FRAMES, MOVE_DEST_Y = 110, 32

---Sub57 的节拍（PROG 表用；#56 的 JUMP 落在 #25 = t=170 那条）。
local ROUND_HOME = 170
local ROUND_END  = 370

---Sub58（使魔）。
local FAM_SEG0   = 27                   -- #8 li0 = 27（每段 +27）
local FAM_SEG_D  = 27                   -- #13 li0 += 27
local FAM_SPEED  = 3.0                  -- #10 的速度
local FAM_HALF   = 12                   -- #3 SET_HITBOX(24, 24) 的一半（回收判据）
local FAM_TURN_A = -HALF_PI             -- 第一批 lf1 = +π/2（TH08）⇒ 我们 −π/2
local FAM_TURN_B =  HALF_PI             -- 第二批 lf1 = −π/2（TH08）⇒ 我们 +π/2
local FAM_AIM_A  = -HALF_PI             -- 第一批 lf3 = +π/2（TH08）⇒ 我们 −π/2
local FAM_AIM_B  =  HALF_PI             -- 第二批 lf3 = −π/2（TH08）⇒ 我们 +π/2
local FAM_PI     = PI                   -- TH08 的 π ⇒ 我们 −π = π（同一个方向：向左）

---Sub59（使魔的枪）。
local FG_FIRST_T   = 1                  -- #9 在使魔的 t=1 挂枪、当场跑
local FG_INTERVAL  = 4                  -- #4 的 `JUMP 0 -> #3`
local FG_TYPE      = 11
---★ 色号是**变量**：Sub59 #3 的 bulletType 操作数高 16 位是 `10007` = li7，
---  而 operandFlags 带着 0x02 位 ⇒ EclDependencies.cpp:782-786 走 `ResolveInt`
---  把它解成**使魔自己的 li7**（SpawnEnemy2 会把父机的整块变量抄过来：
---  EnemyTimeline.cpp:93-95 从 intVariables 起抄 0x78 字节，含 int/float 两组）。
---  Sub57 #27 把 li7 设成 6（第一批那 4 只）、#41 设成 2（第二批那 4 只）
---  ⇒ 两批使魔的弹色不同，这里照抄。
local FG_COLOR_A   = 7                  -- = EX.color(6)：第一批（li7 = 6）
local FG_COLOR_B   = 3                  -- = EX.color(2)：第二批（li7 = 2）
local FG_FLAGS     = 393746             -- DESPAWN | WAIT | PLAY_SPAWN_SOUND | ACCEL_VECTOR | SPAWN_FAST
local FG_WAIT      = 70                 -- 槽 0 的 int0
local FG_VEC_N     = 70                 -- 槽 1 的 int0（加速帧数）
local FG_VEC_ACCEL = 0.025              -- 槽 1 的 float0（每帧速度增量）

---Sub60 / Sub61（BOSS 的两把枪）。
local FAN_TYPE, FAN_COLOR = 2, 2
local FAN_COUNT, FAN_SPEED, FAN_STEP, FAN_FLAGS = 85, 1.6, 0.06544985, 512
local FAN_FIRST, FAN_PERIOD = 180, 60
local AIM_SPEED, AIM_FLAGS = 0.8, 514
local AIM_FIRST, AIM_PERIOD = 180, 20
local GUN_JITTER = 0.05235988           -- `FLOAT_MUL lf0 rndSgn 0.05235988` = ±3°

---出屏判据（IsWithinPlayfield 的反面，GameManager.cpp:132-150）。
local PLAY_L, PLAY_R, PLAY_B, PLAY_T = -192, 192, -224, 224
local function outside_field(x, y, half)
    return x + half < PLAY_L or x - half > PLAY_R
            or y + half < PLAY_B or y - half > PLAY_T
end

---INTERPOLATED 位移的一步（EnemyManager.cpp:80-121）：movementTimer-- →
---progress = 1 − timer/duration → 缓动（4 = OUT_QUADRATIC）→ velocity = origin + delta·progress − position
---（这一帧的位移由 IntegrateVelocity 加上）。timer ≤ 0 时直接落到终点。
local function step_interp(mv, obj)
    mv.t = mv.t + 1
    if mv.t >= mv.n then
        obj.x, obj.y = mv.x0 + mv.dx, mv.y0 + mv.dy
        return true
    end
    local u = mv.t / mv.n
    local e = 1 - (1 - u) * (1 - u)
    obj.x = mv.x0 + mv.dx * e
    obj.y = mv.y0 + mv.dy * e
    return false
end

---------------------------------------------------------------------
---使魔（Sub58）。
---------------------------------------------------------------------
---Sub58 #10（MOVE_IN_DIR）：开一段新位移（origin = 当前位置、时长 li0、缓动 4），
---然后 #11 转向、#12 冻 li0 帧。
local function fam_new_segment(self)
    local n = self.fam_li0
    self.fam_mv = {
        x0 = self.x, y0 = self.y,
        dx = math.cos(self.fam_dir) * FAM_SPEED * n,
        dy = math.sin(self.fam_dir) * FAM_SPEED * n,
        n = n, t = 0,
    }
    self.fam_dir = add_norm(self.fam_dir + self.fam_turn)    -- #11 + #14
    ---#12 SET_SECONDARY_TIME(li0)：**同一次 RunEcl 里它就被减掉一次**
    ---（EclRun.cpp:60-63 的检查在派发下一跳时立刻跑），所以这里存 n − 1。
    ---照抄成 n 的话冻结会多一帧、每段之间空转一帧（段长 27/54/81… 会漂）。
    self.fam_freeze = n - 1                                  -- #12 SET_SECONDARY_TIME(li0)
end

---Sub59 #3 的一轮：2 发完全重叠的静止弹（原地等 70 帧 → 沿 lf3 加速 70 帧 → 消失）。
local function fam_fire(self)
    EX.shoot(self, self.x, self.y, {
        op = 97, type = FG_TYPE, color = EX.color(self.fam_color),
        count1 = 2, count2 = 1, speed1 = 0, speed2 = 0.5,
        angle = self.fam_aim, step = 0, flags = FG_FLAGS,
    })
end

---使魔（Sub58）。占位贴图 "servant"。
local familiar = Class(object, {
    init = function(self, x, y, dir, turn, aim, color)
        self.x, self.y = x, y
        self.fam_dir  = dir             -- 我们坐标（= TH08 lf0 取反）
        self.fam_turn = turn            -- 我们坐标（= TH08 lf1 取反）
        self.fam_aim  = aim             -- 我们坐标（= TH08 lf3 取反）
        self.fam_color = color          -- 继承来的 li7（枪的弹色，两批不同）
        self.fam_t    = 1               -- 本帧稍后 frame() 跑 t=1（同 196：同一帧会被更新两次）
        self.fam_frame = 1              -- 真帧计数（枪用它，冻结期间也照样涨）
        self.fam_li0  = 0
        self.fam_freeze = 0
        self.fam_mv = nil
        self.fam_phase = "start"        -- start = 还没跑 t=1
        self.fam_seen = false
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        ---Sub59 #0/#1/#2 的三条记录（挂在使魔身上：子 ECL 的描述符写在宿主敌机上）。
        EX.clear_records(self)
        EX.set_record(self, 0, EX.K.WAIT, 0, FG_WAIT, -1, -1, -1)
        EX.set_record(self, 1, EX.K.VEC, 0, FG_VEC_N, -1, FG_VEC_ACCEL, self.fam_aim)
        EX.set_record(self, 2, EX.K.DESPAWN, 0, -1, -1, -1, -1)
    end,
    frame = function(self)
        ---① 使魔的 ECL（Sub58）：t=1 挂枪 + 第一段；之后每段冻结结束就 li0 += 27 再走一段。
        if self.fam_phase == "start" then
            self.fam_phase = "seg"
            self.fam_li0 = FAM_SEG0                     -- #8
            self.fam_gun = true                         -- #9 SET_CHILD_ECL(0, 59)
            fam_new_segment(self)                       -- #10..#12
        elseif self.fam_freeze > 0 then
            self.fam_freeze = self.fam_freeze - 1        -- 冻结帧（位移插值照样走）
        else
            self.fam_li0 = self.fam_li0 + FAM_SEG_D      -- #13
            fam_new_segment(self)                        -- #10..#12
        end
        ---② 枪（Sub59 子 ECL）：挂在 t=1 那一帧并当场打第一轮，之后每 4 帧一轮
        ---   （子 context 的时间不受宿主冻结影响）。
        if self.fam_gun and (self.fam_frame - FG_FIRST_T) % FG_INTERVAL == 0 then
            fam_fire(self)
        end
        ---③ 段内插值（RunEcl 末尾的 UpdateMovement）
        if self.fam_mv and step_interp(self.fam_mv, self) then self.fam_mv = nil end
        ---④ 「出场后再出屏就回收」（EnemyManagerUpdate.cpp:228-256）。
        if not self.fam_seen then
            if not outside_field(self.x, self.y, FAM_HALF) then self.fam_seen = true end
        elseif outside_field(self.x, self.y, FAM_HALF) then
            object.RawDel(self)
            return
        end
        self.fam_frame = self.fam_frame + 1
    end,
})

---------------------------------------------------------------------
---BOSS 自己的两把枪（Sub60 / Sub61 的子 ECL）。
---------------------------------------------------------------------
---★ 子 context 是在 BOSS 的 t=170 那一刻建的、而且**不在回跳范围里** ⇒ 时间轴整张卡连续。
---  这里用 ctx.gun_t 记子 context 自己的时间（建好那帧 = 0），每帧先判再 ++。
local function step_guns(owner)
    local c = owner.lw197_ctx
    if not c.gun_on then return end
    ---0 号枪（Sub60）：`t=180` 起每 60 帧打一发 85 发大扇。
    if c.gun_t >= FAN_FIRST and (c.gun_t - FAN_FIRST) % FAN_PERIOD == 0 then
        local off = ran:Sign() * GUN_JITTER              -- #1 FLOAT_MUL(lf0, rndSgn, 3°)
        EX.shoot(owner, owner.x, owner.y, {
            op = 97, type = FAN_TYPE, color = EX.color(FAN_COLOR),
            count1 = FAN_COUNT, count2 = 1, speed1 = FAN_SPEED, speed2 = 0.5,
            angle = HALF_PI - off,      -- #2 lf0 += −π/2 ⇒ 我们 = π/2 ∓ 抖动
            step = FAN_STEP, flags = FAN_FLAGS,
        })
    end
    ---1 号枪（Sub61）：同样 `t=180` 起、每 20 帧 1 发自机狙。
    if c.gun_t >= AIM_FIRST and (c.gun_t - AIM_FIRST) % AIM_PERIOD == 0 then
        local off = ran:Sign() * GUN_JITTER
        EX.shoot(owner, owner.x, owner.y, {
            op = 96, type = FAN_TYPE, color = EX.color(FAN_COLOR),
            count1 = 1, count2 = 1, speed1 = AIM_SPEED, speed2 = 0.5,
            angle = HALF_PI - off, step = 0, flags = AIM_FLAGS,
        })
    end
    c.gun_t = c.gun_t + 1
end

---------------------------------------------------------------------
---Sub57（BOSS 根）。
---------------------------------------------------------------------
---一批 4 只使魔（方向 π、−π/2、0、π/2 —— 我们坐标里正好是 4 个正方向）。
---color = 那 4 只继承到的 li7（第一批 6、第二批 2，见 FG_COLOR_A/B）。
local function spawn_quad(owner, turn, aim, color)
    local dirs = { FAM_PI, HALF_PI, 0, -HALF_PI }
    for i = 1, 4 do
        owner.lw197_fams[#owner.lw197_fams + 1] =
                New(familiar, owner.x, owner.y, dirs[i], turn, aim, color)
    end
end

local PROG = {
    { ROUND_HOME, function(owner)
        ---#23/#24 只在第一轮跑（回跳落在 #25 上）——用 gun_on 记一笔。
        local c = owner.lw197_ctx
        if not c.gun_on then
            c.gun_on = true
            c.gun_t = 0                        -- 两把枪的子 context 建好那一帧 = 0
        end
        spawn_quad(owner, FAM_TURN_A, FAM_AIM_A, FG_COLOR_A)        -- #25..#37
    end },
    { 270, function(owner)
        spawn_quad(owner, FAM_TURN_B, FAM_AIM_B, FG_COLOR_B)        -- #38..#55
    end },
    ---#56 的 `JUMP 170 -> #25`：拨回 time 并当场从 #25 续跑（步进「先加再跑」，见 step_ctx）。
    { ROUND_END, function(owner)
        local c = owner.lw197_ctx
        c.t, c.i = ROUND_HOME, 1
    end },
}

local function step_ctx(owner)
    local c = owner.lw197_ctx
    ---★ 先加再跑：回跳那一项会把 c.i 拨回 1，若「跑完再 ++」会被循环自己的 ++ 顶成 2。
    while c.i <= #PROG and PROG[c.i][1] == c.t do
        local fn = PROG[c.i][2]
        c.i = c.i + 1
        fn(owner)
    end
    c.t = c.t + 1
end

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw197_ctx = { t = 0, i = 1, gun_on = false, gun_t = 0 }
    owner.lw197_fams = {}
    ---落位 + MOVE_TO（Sub57 #12）：从助手给的 (0, 96) 向下 64 px 漂到 (0, 32)。
    owner.x, owner.y = BOSS_X, BOSS_Y
    owner.lw197_mv = { x0 = BOSS_X, y0 = BOSS_Y, dx = 0, dy = MOVE_DEST_Y - BOSS_Y,
                       n = MOVE_FRAMES, t = 0 }
end

local function card_frame(owner)
    if not owner.lw197_ctx then return end
    ---① RunEcl 主 context（Sub57）
    step_ctx(owner)
    ---② RunEcl 里的子 context（两把枪）
    step_guns(owner)
    ---③ RunEcl 末尾的 UpdateMovement（MOVE_TO 的插值）
    ---   ★ 本卡 `ins_76` 关了夹框 ⇒ 没有 ClampPosition。
    if owner.lw197_mv and step_interp(owner.lw197_mv, owner) then owner.lw197_mv = nil end
end

local function card_del(owner)
    owner.lw197_ctx = nil
    owner.lw197_mv = nil
    if owner.lw197_fams then
        for i = #owner.lw197_fams, 1, -1 do
            if IsValid(owner.lw197_fams[i]) then
                object.RawDel(owner.lw197_fams[i])
            end
            owner.lw197_fams[i] = nil
        end
    end
    owner.lw197_fams = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[197] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 198「灭罪「正直者之死」」（藤原妹红）
---  ecldata8sp.ecl：Sub62 = BOSS 根、Sub63 = 使魔、Sub64 = 使魔的枪、
---  Sub65 = BOSS 0 号枪（**光柱**）、Sub66 = BOSS 1 号枪（自机狙扇）。
---
---  · Sub62（根；#7 `SET_TIMER_CALLBACK 4200` = 70 秒、Sub118 #74 的 SET_LIFE 2500）：
---      t=0    #11 `MOVE_TO(110, 4, 192.0, 128.0)` —— 目标就是**当前位置**（BOSS 由生成助手
---             放在 (192,128)）⇒ delta = 0 ⇒ **整张卡 BOSS 不动**（我们 (0, 96)）。
---      t=170  #20..#23 四只使魔（`ins_92 SPAWN_FAMILIAR_INHERIT_POS sub63`，位置 =
---             BOSS 世界坐标 + 偏移）：TH08 偏移 (−96,−16) / (96,−16) / (−64,32) / (64,32)
---             ⇒ 我们 (−96,+16) / (96,+16) / (−64,−32) / (64,−32)。
---             #24/#25 `SET_CHILD_ECL` 0→65、1→66（BOSS 自己两把枪，整卡只挂一次）。
---      t=350  #26 `JUMP 170 0`（相对偏移 **0**）—— 落点就是**这条 JUMP 自己**：
---             把 time 拨回 170 之后没有别的指令可跑（指针停在 JUMP 上、而它的 time=350），
---             等于「每 180 帧空转一次」。所以 #20..#25 只跑一次，整卡靠子 context 撑。
---  · Sub63（使魔）：t=0 主 ANM 53 + `SET_HITBOX 24 24`；t=1 ENABLE_INTERACTION_FLAGS 3 +
---      `SET_CHILD_ECL 0 -> 64`；t=80001 TERMINATE。**使魔不移动**（钉在出生点）。
---  · Sub64（使魔的枪）：t=0 `lf0 = RANDOM_ANGLE`、`lf1 = sin(lf0)·π/64`，
---      `SHOOT_FAN_AIMED` 8 发（type 2 / 色 6 → 我们 7）、速度 6.5、角度操作数 = lf1、
---      step 30°、flags 512；`lf0 += 30°`；#6 `JUMP 0 -> #1` ⇒ #0 只跑一次、每 2 帧一轮。
---  · Sub66（BOSS 1 号枪）：t=60 `lf0 = RANDOM_ANGLE`（算出的 lf1 **没被用上** —— 角度操作数
---      是常数 0）、15 发 FAN_AIMED（type 17 / 色 2 → 我们 3）、速度 2.5、step 5.625°、
---      flags 512；#6 `JUMP 60 -> #1` ⇒ 每 10 帧一轮、#0 只跑一次。
---  · Sub65（BOSS 0 号枪 = 光柱）：
---      t=120  `lf1 = −0.484328866`（−27.75°）、`xi2 = 120`、`lf0 = AIM_TO_PL + lf1`、
---             `SELECT_LASER_SLOT 0` + `CREATE_LASER`（色 6 → 我们 7、angle = lf0、speed 0、
---             startOffset 0 / endOffset 512 / startLength 512 / width 16 / startTime 60 /
---             duration 120 / despawn 20 / hitboxStartTime 60 / hitboxEndDelay 20 / flags 4）。
---             然后 `xi0 = 180` 的 `JUMP_DEC` 循环里每帧 `ROTATE_LASER 0 ±0.00785398204`
---             （±0.45°/帧）：方向由 lf1 的符号定（#8 `JMP_FLOAT_GE lf1 0` 走 −、否则 +）。
---      180 帧后 `lf1 *= −1`、`xi2 −= 10`（到 20 为止）、`SET_SECONDARY_TIME xi2` 冻一会儿，
---      再 `JUMP 120 -> #3` 重新瞄准、重造光柱。
---      ⇒ 光柱本体寿命 = 60 + 120 + 20 = 200 帧（BulletManager.cpp:1049-1150），
---        每轮「180 帧扫 + xi2 帧停」，xi2 从 110 一路减到 20，之后固定 20。
---      ★ `SET_SECONDARY_TIME` 冻的是**枪自己的子 context**（每个 context 有独立的
---        secondaryTime，见 EclManager.hpp:599-620）⇒ BOSS 主 context 不受影响；
---        而且它**当帧就被减一次**（EclRun.cpp:60-63 在派发下一跳时立刻检查），
---        所以下面的冻结帧数直接取 xi2 本身（冻结覆盖 xi2 帧）。
---      ★ 这里的 time 轴不能用「一个计数器」表示：子 context 的 time 在冻结期间不动，
---        所以下面用「相位 + 剩余帧数」写这台相位机。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1252）：卷进 (−π, π]。
---★ 本文件每张卡各写一份自己的工具函数（**不许借别的 do-block 里的 local**）：
---  这张卡以前是「凑巧」靠外层 do-block 的 add_norm 活着的，补一份自己的。
local function add_norm(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

---BOSS 落位 = 生成助手给的 (192, 128) → 我们 (0, 96)；#11 的 MOVE_TO 落在当前点。
local BOSS_X, BOSS_Y = 0, 96

---自机方向（我们的坐标系 = 普通 atan2）。
---★ player 只在函数体里取 —— 顶层取会拿到 nil（见文件里其它卡的注释）。
local function aim_our(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---Sub63（使魔）出生偏移（TH08 → 我们：x 同号、y 取反）。使魔整卡不移动、也不回收。
local FAM_OFFS = { { -96, 16 }, { 96, 16 }, { -64, -32 }, { 64, -32 } }

---Sub64（使魔的枪）：每 2 帧一轮的 8 发扇。
local FG_PERIOD = 2                      -- #6 的 `JUMP 0 -> #1`
local FG_COUNT  = 8
local FG_TYPE   = 2
local FG_COLOR  = 7                      -- TH08 色 6 → 我们 7
local FG_SPEED  = 6.5
local FG_STEP   = 0.5235988              -- 30°
local FG_FLAGS  = 512                    -- 只有 PLAY_SPAWN_SOUND ⇒ 没有出生动画
local FG_SWING  = 0.04908739             -- π/64：lf1 = sin(lf0)·π/64

---Sub66（BOSS 1 号枪）：每 10 帧一轮的 15 发自机狙扇。
local SG_FIRST  = 60                     -- 第一条指令在 t=60
local SG_PERIOD = 10
local SG_COUNT  = 15
local SG_TYPE   = 17
local SG_COLOR  = 3                      -- TH08 色 2 → 我们 3
local SG_SPEED  = 2.5
local SG_STEP   = 0.09817477             -- 5.625°
local SG_FLAGS  = 512

---Sub65（BOSS 0 号枪 = 光柱）。
local LG_FIRST        = 120              -- 第一条指令在 t=120
local LG_COLOR        = 7                -- TH08 色 6 → 我们 7
local LG_LEN          = 512              -- startOffset 0 → endOffset 512、startLength 512
local LG_WIDTH        = 16
local LG_START_TIME   = 60
local LG_DURATION     = 120
local LG_DESPAWN      = 20
local LG_HITBOX_START = 60
local LG_HITBOX_DELAY = 20
local LG_THIN         = 1.2              -- 胀粗之前那根细线（BulletManager.cpp:1096）
local LG_RAMP_WINDOW  = 30               -- startTime > 30 时最后 30 帧才开始胀粗
local LG_ROT_STEP     = 0.00785398204    -- 0.45°/帧
local LG_ROT_FRAMES   = 180              -- xi0
local LG_AIM_OFF      = 0.484328866      -- lf1 初值（−27.75°）
local LG_PAUSE0       = 120              -- xi2 初值
local LG_PAUSE_MIN    = 20
local LG_PAUSE_STEP   = 10

---光柱（`ins_114 CREATE_LASER`；状态机照 BulletManager.cpp:1049-1150 抄）。
---  STARTING（startTime 帧）：startTime > 30 时前 (startTime−30) 帧画 1.2 px 细线、
---    最后 30 帧按 timer·width/startTime 变粗；判定要 timer >= hitboxStartTime。
---  ACTIVE（duration 帧）：满宽、每帧判定。
---  DESPAWNING（despawnDuration 帧）：宽度线性收到 0，判定留到 hitboxEndDelay。
local laser198 = Class(laser, {
    init = function(self, x, y, ang)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）：
        ---第一位在 THlib 里就是**颜色组**；rot 是**角度制**的世界角（AGENTS.md C1）。
        ---l1/l2/l3 = 尾/身/头三段长度 —— 这里只有一段 512 的身部（起点 = 光柱原点）。
        laser.init(self, LG_COLOR, x, y, ang * RAD, 0, LG_LEN, 0, LG_THIN, 0, 0)
        self.l198_state, self.l198_t = 1, 0
        self.alpha = 1
        self.colli = false          -- 判定要等状态机点亮
        ---★ 寿命只由状态机决定（原作把光柱存在固定槽位、跑完才释放），
        ---  起点在场外也不许引擎提前收掉。
        self.bound = false
    end,
    frame = function(self)
        local t = self.l198_t
        if self.l198_state == 1 then
            if LG_START_TIME - LG_RAMP_WINDOW < t then
                self.w = t * LG_WIDTH / LG_START_TIME
            else
                self.w = LG_THIN
            end
            self.colli = t >= LG_HITBOX_START
            if t >= LG_START_TIME then
                ---原作这一支**不 break**，直接落到 ACTIVE（BulletManager.cpp:1104）
                self.l198_state = 2
                self.l198_t = 0
                t = 0
            end
        end
        if self.l198_state == 2 then
            self.w = LG_WIDTH
            self.colli = true
            if t >= LG_DURATION then
                self.l198_state = 3
                self.l198_t = 0
                t = 0
            end
        end
        if self.l198_state == 3 then
            self.w = LG_WIDTH - t * LG_WIDTH / LG_DESPAWN
            self.colli = t < LG_HITBOX_DELAY
            if t >= LG_DESPAWN then
                object.RawDel(self)
                return
            end
        end
        self.l198_t = t + 1
        laser.frame(self)
    end,
})

---------------------------------------------------------------------
---Sub64（使魔的枪）：8 发 FAN_AIMED，基准角 = 自机角 + lf1。
---------------------------------------------------------------------
local function fam_fire(self)
    self.fam_lf1 = math.sin(self.fam_lf0) * FG_SWING           -- #1/#2
    EX.shoot(self, self.x, self.y, {
        op = 96, type = FG_TYPE, color = EX.color(FG_COLOR),
        count1 = FG_COUNT, count2 = 1, speed1 = FG_SPEED, speed2 = 0.5,
        angle = -self.fam_lf1,          -- #3 的角度操作数（TH08）→ 我们取反
        step = FG_STEP, flags = FG_FLAGS,
    })
    self.fam_lf0 = add_norm(self.fam_lf0 + FG_STEP)             -- #4/#5
end

---使魔（Sub63）。占位贴图 "servant"。整卡不动，只当枪架子。
local familiar = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.fam_frame = 1              -- 使魔自己的帧计数（t=1 那一帧 = 出生帧）
        self.fam_lf0 = ran:Float(-PI, PI)   -- Sub64 #0 的 RANDOM_ANGLE
        self.fam_lf1 = 0
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
    end,
    frame = function(self)
        ---Sub64 的 time 轴：出生帧 = 使魔的 t=1 = 枪的 t=0，之后每 2 帧一轮。
        if (self.fam_frame - 1) % FG_PERIOD == 0 then
            fam_fire(self)
        end
        self.fam_frame = self.fam_frame + 1
    end,
})

---------------------------------------------------------------------
---Sub66（BOSS 1 号枪）与 Sub65（BOSS 0 号枪 = 光柱）。
---------------------------------------------------------------------
---1 号枪：子 context 建好那帧 = 它的 time 0（= 卡的第 171 帧），t=60 起每 10 帧一轮。
local function step_aim_gun(owner)
    local c = owner.lw198_ctx
    if not c.gun_on then return end
    if c.sg_t >= SG_FIRST and (c.sg_t - SG_FIRST) % SG_PERIOD == 0 then
        EX.shoot(owner, owner.x, owner.y, {
            op = 96, type = SG_TYPE, color = EX.color(SG_COLOR),
            count1 = SG_COUNT, count2 = 1, speed1 = SG_SPEED, speed2 = 0.5,
            angle = 0,                  -- ★ 原作的角度操作数是常数 0（lf1 算了没用上）
            step = SG_STEP, flags = SG_FLAGS,
        })
    end
    c.sg_t = c.sg_t + 1
end

---0 号枪：造一条光柱（#3..#5）——瞄准角 = 自机方向 − s·27.75°（我们坐标）。
local function laser_new(owner, g)
    local aim = aim_our(owner.x, owner.y)
    g.ang = aim - g.s * LG_AIM_OFF
    g.laser = New(laser198, owner.x, owner.y, g.ang)
    owner.lw198_lasers[#owner.lw198_lasers + 1] = g.laser
end

---一次 `ROTATE_LASER`：原作 th08_delta = −s·0.45° ⇒ 我们 = +s·0.45°。
local function laser_rotate(g)
    g.ang = g.ang + g.s * LG_ROT_STEP
    if IsValid(g.laser) then
        g.laser.rot = g.ang * RAD       -- rot 是角度制、我们存的就是我们坐标系的角
    end
end

local function step_laser_gun(owner)
    local c = owner.lw198_ctx
    if not c.gun_on then return end
    local g = c.lg
    if g.phase == "pre" then
        if g.t == LG_FIRST then
            g.phase, g.s, g.rot_left = "sweep", -1, LG_ROT_FRAMES
            laser_new(owner, g)         -- #3..#5
            laser_rotate(g)             -- #9（造好当帧就转一格）
            g.rot_left = g.rot_left - 1
        end
        g.t = g.t + 1
    elseif g.phase == "sweep" then
        if g.rot_left > 0 then
            laser_rotate(g)
            g.rot_left = g.rot_left - 1
        else
            ---xi0 跑完那一帧：`lf1 *= −1`（换向）、`xi2 −= 10`（到 20 为止）、冻结 xi2 帧
            g.phase = "pause"
            g.s = -g.s
            g.pause = math.max(g.pause - LG_PAUSE_STEP, LG_PAUSE_MIN)
            g.freeze = g.pause
        end
    elseif g.phase == "pause" then
        g.freeze = g.freeze - 1
        if g.freeze == 0 then
            g.phase, g.rot_left = "sweep", LG_ROT_FRAMES - 1
            laser_new(owner, g)         -- #18 `JUMP 120 -> #3` 落在 #3 上，同帧续跑
            laser_rotate(g)
        end
    end
end

---------------------------------------------------------------------
---Sub62（BOSS 根）。
---------------------------------------------------------------------
local ROUND_HOME, ROUND_END = 170, 350

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    ---#26 的 `JUMP 170 0` 每 180 帧空转一次 ⇒ t 到 350 就拨回 170（不跑任何指令）。
    owner.lw198_ctx = {
        t = 0, spawned = false,
        gun_on = false, sg_t = 0,
        lg = { phase = "pre", t = 0, s = -1, rot_left = 0, pause = LG_PAUSE0,
               freeze = 0, ang = 0, laser = nil },
    }
    owner.lw198_fams = {}
    owner.lw198_lasers = {}
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    local c = owner.lw198_ctx
    if not c then return end
    ---① RunEcl 主 context（Sub62）。t=0 的 MOVE_TO 落在当前点 ⇒ 没有位移要积分。
    if c.t == ROUND_HOME and not c.spawned then
        c.spawned = true
        for i = 1, 4 do
            owner.lw198_fams[#owner.lw198_fams + 1] =
                    New(familiar, owner.x + FAM_OFFS[i][1], owner.y + FAM_OFFS[i][2])
        end
        c.gun_on, c.sg_t = true, 0      -- #24/#25：两把枪的子 context，当帧建、当帧跑 t=0
    end
    if c.t >= ROUND_END then
        c.t = ROUND_HOME                -- #26 空转（指针停在 JUMP 上，没有指令可跑）
    end
    c.t = c.t + 1
    ---② RunEcl 的子 context（先跑枪、后跑位移 —— 本卡 BOSS 不动，没有位移那一步）
    step_aim_gun(owner)
    step_laser_gun(owner)
end

local function card_del(owner)
    owner.lw198_ctx = nil
    if owner.lw198_fams then
        for i = #owner.lw198_fams, 1, -1 do
            if IsValid(owner.lw198_fams[i]) then
                object.RawDel(owner.lw198_fams[i])
            end
            owner.lw198_fams[i] = nil
        end
    end
    owner.lw198_fams = nil
    if owner.lw198_lasers then
        for i = #owner.lw198_lasers, 1, -1 do
            if IsValid(owner.lw198_lasers[i]) then
                object.RawDel(owner.lw198_lasers[i])
            end
            owner.lw198_lasers[i] = nil
        end
    end
    owner.lw198_lasers = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[198] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 199「虚人「乌」」（藤原妹红）
---  ecldata8sp.ecl：Sub67 = BOSS 根、Sub71 = BOSS 0 号子 context（整卡的节拍）、
---  Sub70 = 「一次放 3 只乌鸦」的生成助手、Sub68 = 乌鸦、Sub69 = 乌鸦的枪。
---  （根 t=110 的 `ins_52(39)` = 32 发纯观感火花 —— 按本文件惯例跳过。）
---
---  · Sub67（根；`ins_134(4200, …)` = 70 秒、Sub118 #77 的 SET_LIFE 3000）：
---      t=0    `ins_64(110, 4, 192, 128)` 的目标就是**当前位置** ⇒ BOSS 原地（我们 (0, 96)）。
---             `ins_95 KILL_ALL_NON_BOSS` / `ins_105(0)` / `ins_110(0,0)` 都是清理类。
---      t=110  `ENABLE_INTERACTION_FLAGS 4`（拿回判定 = 能被打）+ 伤减 420 + 火花。
---      t=170  `ins_78(256, 32)` SET_SECONDARY_HITBOX（判定盒，纯视觉）+ `ins_135(0, 71)`
---             ⇒ 0 号子 context 建在这里、**整卡只建这一次**。
---      t=350  `JUMP 170 -> #22`（相对偏移 0）⇒ 落点就是**这条 JUMP 自己**：把 time 拨回 170
---             之后没有别的指令可跑 ⇒ 每 180 帧空转一次，主 context 从此不再做任何事。
---  · Sub71（0 号子 context；它的 t=0 = 根 t=170 那一帧；一轮 740 帧）：
---      t=0     `scf0 = π/2`、`sci0 = 2`、CALL 70 ⇒ 3 只乌鸦（方向朝下 = 我们 −π/2）。
---      t=120   `plX >= 192`（自机在右半边）→ x=320（我们 128），否则 x=64（我们 −128）；
---              60 帧、缓动 4 = OUT_QUADRATIC（EclRun.cpp:140-158）。
---      t=180   `scf0 = AIM_TO_PL`、`sci0 = 4`、CALL 70 ⇒ 3 只乌鸦朝自机。
---      t=300   `selfX >= 192`（BOSS 在右半边）→ x=64（我们 −128），否则 x=320（我们 128）；
---              200 帧、缓动 0 = 线性。
---      t=350/400/450/500  `scf0 = AIM_TO_PL`、`sci0 = 2 / 4 / 6 / 8`，各 CALL 70 ⇒ 又 12 只。
---      t=680   60 帧线性回到 x=192（我们 0）。
---      t=740   `JUMP 0 -> #0` ⇒ 一轮 740 帧；#0..#2 在**同一帧**续跑 ⇒ 又一批朝下的乌鸦。
---      ⇒ 每轮 18 只。`sci0` 一路是 **li7 的来源**（见下）。
---  · Sub70（生成助手；`CALL` 走 CallSubOnEnemy，子程序与调用方**共用同一块变量**）：
---      #0 `lf0 = cf0 + π/2`、#1 `lf1 = cf0`、#2 `li7 = ci0`。
---          ★ 调用方写的是 `scf0/sci0`（= **全局共享**那组，EclOperandsFloat.cpp:64-71），
---            CALL 那一刻 `g_EclCallParameters` 被抄进 context 的 callParameter（EclDependencies.cpp:487-493），
---            所以子程序里读的是 `cf0/ci0` —— 两边名字不同、值是一条。
---      #3..#5 `POLAR_TO_CARTESIAN(exF0, exF1, lf0, 50)` + `ins_91(Sub68, exF0, exF1, …)`
---            = SPAWN_FAMILIAR_AT_OFFSET：**位置 = 父机世界坐标 + 偏移**（EclDependencies.cpp:614-641）。
---      #6..#8 把 exF0/exF1 取反再放一只、#9 再放一只 (0,0) ⇒ 一次 3 只、两只在方向的两侧 50 px。
---      ★ 子机继承父机的**整块变量**（EnemyTimeline.cpp:93-95 从 intVariables 起抄 0x78 字节，
---        含 int 与 float 两组）⇒ 乌鸦拿到 `lf1`（飞行方向）与 `li7`（弹色）。
---  · Sub68（乌鸦）：t=0 主 ANM 53 + 24×24 判定 + 伤减 30；t=1 `ins_65(lf1, 0.5)` 定方向与速度、
---      `ins_135(0, 69)` 挂枪；t=61 `ins_71(0.1166667)` SET_ACCELERATION（模式转 POLAR；
---      之后每帧 `speed += acceleration`，EnemyManager.cpp:63-77）；t=80061 TERMINATE（＝不休止）。
---      ⇒ 沿出生方向匀速 0.5 飞，第 61 帧起每帧 +7/60，油门踩到底、出屏即回收。
---  · Sub69（乌鸦的枪；#5 `JUMP 0 -> #2` ⇒ **6 帧一轮**，#0..#4 只在第一轮）：
---      #1 槽 0 = `ins_111(0, 0x20000 WAIT, 0, 120, −1, −1, −1)`；#2 槽 1 = VEC（60 帧、
---      0.0283333、角 −999.9 = 用弹自己的角）。#3 `SHOOT_FAN_AIMED`：type 2、color = **li7**（变量）、
---      count1 = 2、count2 = 1、speed1 = 0.05、speed2 = 0.5、**角与角增量都是 RANDOM_ANGLE**、
---      flags = 131600 = WAIT | PLAY_SPAWN_SOUND | ACCELERATE_VECTOR。
---      ⇒ 弹先以 0.05 爬 120 帧（WAIT 没走完、后一条记录进不来），再沿自己的角加速 60 帧；
---        两发相对「自机方向 + 随机角」对称张开 ±随机角/2。
---  ★ 乌鸦按 205..216 的惯例做成**纯观感**（原作有 24×24 判定与 COLLISION 位，移植版不给判定）。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local HALF_PI = PI / 2

---BOSS 落位 = 生成助手给的 (192, 128) → 我们 (0, 96)。
local BOSS_X, BOSS_Y = 0, 96

---夹框：Sub116 的 `ins_75(32, 48, 352, 128)`（TH08 坐标）→ 我们 x∈[−160,160]、y∈[96,176]。
---（Sub67 没有 `ins_76` ⇒ 本卡夹框有效，frame 末尾要 ClampPosition。）
local BW_L, BW_R, BW_B, BW_T = -160, 160, 96, 176

---自机方向（我们坐标 = 普通 atan2）。
---★ player 只在函数体里取 —— 顶层取会拿到 nil（见文件里其它卡的注释）。
local function aim_our(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---出屏判据（IsWithinPlayfield 的反面，GameManager.cpp:132-150）。
local PLAY_L, PLAY_R, PLAY_B, PLAY_T = -192, 192, -224, 224
local function outside_field(x, y, half)
    return x + half < PLAY_L or x - half > PLAY_R
            or y + half < PLAY_B or y - half > PLAY_T
end

---INTERPOLATED 位移的一步（EnemyManager.cpp:85-125）：movementTimer-- →
---progress = 1 − timer/duration → 缓动 → 到点那一帧直接落位。
---  ease = 4 是 OUT_QUADRATIC（`ins_64` 的第二操作数）、0 是线性。
local function interp_step(mv, obj)
    mv.t = mv.t + 1
    if mv.t >= mv.n then
        obj.x, obj.y = mv.x0 + mv.dx, mv.y0 + mv.dy
        return true
    end
    local u = mv.t / mv.n
    if mv.ease == 4 then u = 1 - (1 - u) * (1 - u) end
    obj.x = mv.x0 + mv.dx * u
    obj.y = mv.y0 + mv.dy * u
    return false
end

---Sub71 的 `ins_64 MOVE_TO`：目标 y 就是 `selfY`（= 指令执行那一刻的 y）⇒ 只横向走。
local function begin_move(owner, tx, n, ease)
    owner.lw199_mv = {
        x0 = owner.x, y0 = owner.y,
        dx = tx - owner.x, dy = 0,
        n = n, ease = ease, t = 0,
    }
end

---Sub68（乌鸦）。
local CROW_R        = 50        -- `POLAR_TO_CARTESIAN(…, 50)` 的 50
local CROW_SPEED    = 0.5       -- #7 `ins_65(lf1, 0.5)`
local CROW_ACCEL    = 0.1166667 -- #9 `ins_71(0.1166667)`
local CROW_ACCEL_AT = 61        -- #9 自己的 t
local CROW_HALF     = 8         -- 半精灵宽高（回收判据用；占位贴图按小弹算）
---Sub69（乌鸦的枪）。
local GUN_PERIOD    = 6         -- #5 `JUMP 0 -> #2`
local GUN_TYPE      = 2
local GUN_COUNT     = 2
local GUN_SPEED1    = 0.05
local GUN_SPEED2    = 0.5
local GUN_WAIT      = 120       -- 槽 0 的 int0 = timed.frames
local GUN_VEC_N     = 60        -- 槽 1 的 int0 = durationFrames
local GUN_VEC_ACCEL = 0.0283333343
local GUN_FLAGS     = 131600    -- 0x20210 = WAIT | PLAY_SPAWN_SOUND | ACCELERATE_VECTOR

---乌鸦本体。占位贴图 "servant"。
---★ 时间轴：TH08 里子机被 SpawnEnemy2 塞进**后面的空位**，而敌机循环是按下标 0..479 跑的
---  （EnemyManagerUpdate.cpp:126-160）⇒ 它在**出生那一帧**就会跑第一次 RunEcl（= t=0）。
---  所以 `cw_t` 从 0 起、`frame` 第一次进来处理的就是 t=0（本卡它的 t=0 只有主 ANM 与判定，
---  全是观感 ⇒ 这一帧什么都不做），t=1（挂钩 + 起步 + 第一轮）落在**下一帧** ——
---  与原件逐帧对齐。
local crow = Class(object, {
    init = function(self, x, y, dir, color)
        self.x, self.y = x, y
        self.cw_dir = dir               -- 飞行方向（我们坐标 = TH08 的 lf1 取反）
        self.cw_sp = 0                  -- SPEED（t=1 才写成 0.5）
        self.cw_acc = 0                 -- ACCELERATION（t=61 才写成 7/60）
        self.cw_color = color           -- 继承来的 li7（枪的弹色）
        self.cw_t = 0                   -- 出生帧就跑 t=0（见上）
        self.cw_gun = false             -- t=1 才挂枪
        self.cw_seen = false            -- ENEMY_FLAG_HAS_BEEN_IN_BOUNDS
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false              -- ★ 纯观感（见头注）
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        ---Sub69 #1/#2 的两条记录。挂在**乌鸦**身上 —— 在原件里子 ECL 的
        ---`TH08_ECL_CONTEXT_ENEMY` 就是这只乌鸦，子弹描述符也写在它身上。
        EX.clear_records(self)
        EX.set_record(self, 0, EX.K.WAIT, 0, GUN_WAIT, -1, -1, -1)
        EX.set_record(self, 1, EX.K.VEC, 0, GUN_VEC_N, -1, GUN_VEC_ACCEL, -999.9)
    end,
    frame = function(self)
        local t = self.cw_t
        ---① 乌鸦的 ECL（Sub68）。
        if t == 1 then
            self.cw_sp = CROW_SPEED          -- #7 `ins_65(lf1, 0.5)`
            self.cw_gun = true               -- #8 `ins_135(0, 69)`
        elseif t == CROW_ACCEL_AT then
            self.cw_acc = CROW_ACCEL         -- #9 `ins_71(0.1166667)`
        end
        ---② 枪（Sub69 的子 context）：挂上那一帧就当打第一轮，之后每 6 帧一轮。
        ---   `RANDOM_ANGLE` 每读一次抽一次 ⇒ 角与角增量各抽一次（EclOperandsFloat.cpp:56）。
        if self.cw_gun and (t - 1) % GUN_PERIOD == 0 then
            local r_ang = ran:Float(-PI, PI)                -- #3 的角操作数
            local r_step = ran:Float(-PI, PI)               -- #3 的角增量操作数
            EX.shoot(self, self.x, self.y, {
                op = 96, type = GUN_TYPE, color = EX.color(self.cw_color),
                count1 = GUN_COUNT, count2 = 1,
                speed1 = GUN_SPEED1, speed2 = GUN_SPEED2,
                angle = -r_ang, step = -r_step, flags = GUN_FLAGS,
            })
        end
        ---③ RunEcl 末尾的 UpdateMovement（EnemyManager.cpp:63-77 的 POLAR）：
        ---   speed += acceleration → velocity = fromAngle(speed) → 位置由 IntegrateVelocity 加。
        ---   （这只对象没挂 vx/vy，位移在这里自己走。）
        self.cw_sp = self.cw_sp + self.cw_acc
        self.x = self.x + math.cos(self.cw_dir) * self.cw_sp
        self.y = self.y + math.sin(self.cw_dir) * self.cw_sp
        self.cw_t = t + 1
        ---④ 「出场后再出屏就回收」（EnemyManagerUpdate.cpp:228-256）。
        if not self.cw_seen then
            if not outside_field(self.x, self.y, CROW_HALF) then self.cw_seen = true end
        elseif outside_field(self.x, self.y, CROW_HALF) then
            object.RawDel(self)
        end
    end,
})

---Sub70 #5/#8/#9：一次性 3 只（偏移 = 方向的两侧 50 px + 正中一只）。
---TH08 的偏移 = polar(lf0 = cf0 + π/2, 50)；换到我们坐标（y 取反）后
---正好是 `(50·sin d, −50·cos d)` 与它的相反数（d = 我们的飞行方向）。
local function crow_batch(owner, dir, color)
    local ox, oy = CROW_R * math.sin(dir), -CROW_R * math.cos(dir)
    local offs = { { ox, oy }, { -ox, -oy }, { 0, 0 } }
    for i = 1, 3 do
        owner.lw199_crows[#owner.lw199_crows + 1] =
                New(crow, owner.x + offs[i][1], owner.y + offs[i][2], dir, color)
    end
end

---Sub71 的时间轴（key = 它自己的 time）。`sci0` 就是弹色，见头注。
local SUB71 = {
    [0]   = function(owner) crow_batch(owner, -HALF_PI, 2) end,     -- #0..#2（朝下那批）
    [120] = function(owner)                                         -- #4..#7
        begin_move(owner, player.x >= 0 and 128 or -128, 60, 4)
    end,
    [180] = function(owner) crow_batch(owner, aim_our(owner.x, owner.y), 4) end,   -- #8..#10
    [300] = function(owner)                                         -- #12..#15
        begin_move(owner, owner.x >= 0 and -128 or 128, 200, 0)
    end,
    [350] = function(owner) crow_batch(owner, aim_our(owner.x, owner.y), 2) end,   -- #16..#18
    [400] = function(owner) crow_batch(owner, aim_our(owner.x, owner.y), 4) end,   -- #19..#21
    [450] = function(owner) crow_batch(owner, aim_our(owner.x, owner.y), 6) end,   -- #22..#24
    [500] = function(owner) crow_batch(owner, aim_our(owner.x, owner.y), 8) end,   -- #25..#27
    [680] = function(owner) begin_move(owner, 0, 60, 0) end,                        -- #28
    ---#29 `JUMP 0 -> #0`：把 time 拨回 0，而且**同一帧**从 #0 续跑（#0..#2 全在 t=0）。
    [740] = function(owner)
        crow_batch(owner, -HALF_PI, 2)
        owner.lw199_ctx.ct = 0          -- 本帧末的 ++ 把它顶成 1
    end,
}

local function step_show(owner)
    local c = owner.lw199_ctx
    local fn = SUB71[c.ct]
    if fn then fn(owner) end
    c.ct = c.ct + 1
end

---Sub67（BOSS 根）。
local ROOT_CHILD_AT = 170
local ROOT_WRAP = 350

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw199_ctx = { t = 0, child_on = false, ct = 0 }
    owner.lw199_crows = {}
    owner.lw199_mv = nil
    ---落位：BOSS **原地**出现（Sub116 的 ins_63 与 Sub67 的 ins_64 同一个点）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    local c = owner.lw199_ctx
    if not c then return end
    ---① RunEcl 主 context（Sub67）
    if c.t == ROOT_CHILD_AT and not c.child_on then
        c.child_on = true               -- `ins_135(0, 71)`：子 context 当帧建、当帧跑 t=0
        c.ct = 0
    end
    if c.t >= ROOT_WRAP then c.t = ROOT_CHILD_AT end     -- #22 的 JUMP 落点就是它自己
    c.t = c.t + 1
    ---② RunEcl 的子 context（Sub71：整张卡的节拍都在这里）
    if c.child_on then step_show(owner) end
    ---③ RunEcl 末尾的 UpdateMovement（`ins_64` 的插值）
    if owner.lw199_mv and interp_step(owner.lw199_mv, owner) then owner.lw199_mv = nil end
    ---④ ClampPosition（EnemyManagerUpdate.cpp:172-174 位移前后各钳一次）
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw199_ctx = nil
    owner.lw199_mv = nil
    if owner.lw199_crows then
        for i = #owner.lw199_crows, 1, -1 do
            if IsValid(owner.lw199_crows[i]) then
                object.RawDel(owner.lw199_crows[i])
            end
            owner.lw199_crows[i] = nil
        end
    end
    owner.lw199_crows = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[199] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 200「不灭「不死鸟之尾」」（藤原妹红）
---  ecldata8sp.ecl：Sub72 = BOSS 根、Sub78 = 0 号子 context（重挂计时）、
---  Sub79 = 1 号子 context（BOSS 自己的枪）、Sub76 / Sub77 = 两条「一次放 5 只凤凰」的
---  生成助手、Sub73 = 凤凰本体、Sub74 / Sub75 = 凤凰身上的两把枪。
---  （根 t=110 的 `ins_52(39)` = 32 发纯观感火花，按本文件惯例跳过。）
---
---  · Sub72（根；Sub116 的 `CALL 72` 带 life 3000 = 我们的卡血、`ins_134(4200, …)` = 70 秒）：
---      t=0    `ins_64(110, 4, 192, 128)` 的目标就是**当前位置** ⇒ BOSS 原地（我们 (0, 96)）。
---      t=110  拿回判定（能被打）+ 伤减 420（观感）。
---      t=170  `ins_78(256, 32)`（次级判定盒，观感）+ `ins_135(1, 79)` + `ins_135(0, 78)`：
---             0 / 1 号子 context 建在这一帧，**同一帧就跑各自的 t=0**（EclRun.cpp:196-212 的
---             `low_select_next_context` 从当前下标往后找活着的子 context）。
---      t=350  `JUMP 170 -> #23`（相对偏移 0）⇒ 落点就是这条 JUMP 自己 ⇒ 从此每 180 帧空转。
---  · Sub78（0 号子 context；`SET_CHILD_ECL` 的语义是**先释放再重建**，EclRunHigh.inl:646-678）：
---      t=0    `ins_135(2, 76)` + `ins_135(3, 77)` ⇒ 两条生成助手（同样同帧跑 t=0）。
---      t=180  `JUMP 0 -> #0` ⇒ 每 180 帧把 2 / 3 号子 context 整个重建：它们的 context time
---             归零、出生时刻表从头再来（★ **上一轮放出去的凤凰不会消失**，还在继续绕圈打）。
---  · Sub76（2 号子 context）：`ins_91` = SPAWN_FAMILIAR_AT_OFFSET(sub, 0, 0, life 13500, …)
---      ⇒ 生成在**父机世界坐标 + (0, 0)**，也就是 BOSS 身上（EclDependencies.cpp:614-641）。
---      t=0    `lf2 = −0.02855993`；`lf1 = π`；生成第 1 只；t=0 尾 `lf1 = −2.945243`
---      t=10   生成第 2 只；`lf1 = −2.748893`
---      t=20   生成第 3 只；`lf2 = −0.01208305`；`lf1 = −2.552544`
---      t=30   生成第 4 只；`lf1 = −2.356194`
---      t=40   生成第 5 只；`ins_53 RETURN`
---      ⇒ 方向 = π + k·π/16（k = 0..4）、角速度 = −0.02855993（k ≤ 2）或 −0.01208305
---        （k = 3、4）。★ t=20 那次生成排在改 lf2 **之前** ⇒ 第 3 只还是快角速度。
---  · Sub77 与 Sub76 镜像：`lf1` = 0、−π/16、−2π/16、−3π/16、−4π/16，`lf2` 取正。
---      ★ 子机继承父机的**整块变量**（EnemyTimeline.cpp:93-95 从 intVariables 起抄 0x78 字节）
---        ⇒ 凤凰拿到 `lf1`（方向）与 `lf2`（角速度）。
---  · Sub73（凤凰；占位贴图 "servant"；原作有 24×24 判定与 life 13500，
---      按本文件 205..216 的惯例做成**纯观感**）：
---      t=1    `ins_65(lf1, 2.0)` 定方向与速度（POLAR）+ `ins_70(lf2)` 定角速度 ⇒ 绕圈飞。
---      t=61   `ins_135(0, 74)` + `ins_135(1, 75)` ⇒ 两把枪挂上（当帧就跑 t=0）。
---      t=121  `ins_70(0)` ⇒ 角速度归零（之后直线飞，枪照打）。
---      t=80121 TERMINATE（＝不休止）⇒ 只有出屏才回收（EnemyManagerUpdate.cpp:228-256）。
---  · Sub74 / Sub75（两把枪；节拍都是 12 帧，Sub75 整条时间轴 +6 帧、相位错开）：
---      #5/#6  两条 `ins_111`：槽 0 = VEC(90 帧)、槽 1 = VEC(30 帧)，`allowWhileActive = 0`
---             ⇒ 槽 1 必须等槽 0 跑完（activeTransformFlags 清零）才点亮（BulletManager.cpp:307-475）。
---             float0 = lf0 = rndSgn·(1/120) + 7/240（≈ 0.0208..0.0375，**每发重抽**）、
---             float1 = 加速方向：槽 0 是常量 ∓π/2、槽 1 是「RANDOM_ANGLE / 50 ∓ π/2」。
---      #7     `SHOOT_FAN`：type 19、色 1、count1 = count2 = 1、speed 2.0、角 ±π/2、
---             flags 528 = PLAY_SPAWN_SOUND | ACCELERATE_VECTOR（**没有出生动画** ⇒ 出生即 FIRED）。
---      #9     `JUMP 0 / 6 -> #1` ⇒ 每 12 帧一轮。
---      ⇒ 两把枪各打 1 发 / 12 帧、相位差 6 帧；弹先朝外飞、再被反向的 VEC 拉回来
---        （90 + 30 帧）—— 这就是「凤凰尾」那条外放再回勾的弧线。
---  · Sub79（1 号子 context = BOSS 自己的枪）：#0..#6 全在 t=180 ⇒ 前 180 帧什么都不做、
---      之后每发之间用 `SET_SECONDARY_TIME(li0)` 冻 li0 帧（li0 每发 −2、下限 60，见 #3/#4），
---      打的是 type 7 / 色 1 / speed 1.0 的**自机狙**单发；flags 514 = SPAWN_FAST | PLAY_SPAWN_SOUND。
---      ★ `SET_SECONDARY_TIME` 的语义（EclRun.cpp:58-63）：secondaryTime > 0 时每帧
---        secondaryTime 与 context time **各减 1** ⇒ 这个子 context 接下来 li0 帧都不执行指令。
---  ★ 坐标：x_我们 = x_原作 − 192、y_我们 = 224 − y_原作、角度整体取反（见文件头），
---    所以 TH08 里写成 −π/2 的角，到我们这边是 +π/2（反之亦然）—— 下面都写成取反后的值。
---  ★ 子机（ins_91）在**出生那一帧**就跑第一次 RunEcl（SpawnEnemy2 当帧直接调 RunEcl，
---    EnemyTimeline.cpp:88-96）⇒ 凤凰的时间轴从 t=0 起、出生帧就是 t=0。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local HALF_PI = PI / 2
local RAD = 57.29577951308232

---BOSS 落位（Sub116 的 `ins_63(192,128)` 与 Sub72 的 `ins_64` 同一个点）→ 我们 (0, 96)。
local BOSS_X, BOSS_Y = 0, 96

---夹框：Sub116 的 `ins_75(32, 48, 352, 128)`（同时置 CLAMP_POSITION）→ 我们
---x∈[−160,160]、y∈[96,176]；位移前后各钳一次（EnemyManagerUpdate.cpp:172-174）。
local BW_L, BW_R, BW_B, BW_T = -160, 160, 96, 176

---IsWithinPlayfield 的反面（GameManager.cpp:132-150），half = 半个精灵宽高。
local PLAY_L, PLAY_R, PLAY_B, PLAY_T = -192, 192, -224, 224
local function outside_field(x, y, half)
    return x + half < PLAY_L or x - half > PLAY_R
            or y + half < PLAY_B or y - half > PLAY_T
end

---AddNormalizeAngle(a, b)（Global.cpp:1239-1252）：卷进 (−π, π]。
---`SET_DIR_AND_SPEED`（EclRunLow.inl:506-513）与 UpdateMovement 的 POLAR 分支都走它。
local function add_norm(a)
    while a > PI do a = a - 2 * PI end
    while a < -PI do a = a + 2 * PI end
    return a
end

---------------------------------------------------------------------
---常量：全部照抄上面那几段 ECL 的裸字节，角度已取反到我们坐标
---------------------------------------------------------------------

---Sub79（BOSS 的枪）。
local BG_TYPE, BG_COLOR = 7, 1          -- `SHOOT_FAN_AIMED type7/col1`
local BG_SPEED, BG_SPEED2 = 1.0, 0.5    -- speed1 / speed2（count2 = 1 ⇒ 实际只用 speed1）
local BG_FLAGS = 514                    -- 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND
local BG_FIRST = 180                    -- #0..#6 都在 t=180 ⇒ 子 context 建好后第 180 帧开第一枪
local BG_STEP = 2                       -- #4 `INT_SUB_ASSIGN li0 2`
local BG_FLOOR = 60                     -- #3 `JMP_INT_LE li0 60 -> #5`：到 60 就不再减

---Sub73（凤凰）。
local PHX_SPEED = 2.0                   -- Sub73 #8 `ins_65(lf1, 2.0)`
local PHX_GUN_AT = 61                   -- Sub73 #10/#11 挂两把枪
local PHX_STOP_TURN = 121               -- Sub73 #12 `ins_70(0)` 角速度归零
local PHX_HALF = 12                     -- 出屏判据的半个精灵宽高（占位口径；原作贴图更大）

---Sub74 / Sub75（两把枪）。
local GUN_PERIOD = 12                   -- #9 `JUMP 0 -> #1`（Sub75 是 `JUMP 6 -> #1`，同周期）
local GUN2_PHASE = 6                    -- Sub75 的第一条指令在 t=6
local GUN_VEC_N0 = 90                   -- 槽 0 的 VEC 时长（int0）
local GUN_VEC_N1 = 30                   -- 槽 1 的 VEC 时长
local GUN_MAG_K = 0.008333334           -- #1 的乘数（1/120）
local GUN_MAG_B = 0.02916667            -- #2 的加数（7/240）
local GUN_TYPE, GUN_COLOR = 19, 1
local GUN_SPEED, GUN_SPEED2 = 2.0, 0.5
local GUN_FLAGS = 528                   -- 0x210 = PLAY_SPAWN_SOUND | ACCELERATE_VECTOR

---Sub76 / Sub77 的方向表（**已经取反到我们坐标**）。
---原作把 Sub76 写成 `lf1 = π`、`−2.945243`、…（负数是「π 再往上加 kπ/16」的写法），
---取反之后就是 `−π`、`+2.945243`、…；Sub77 是它的镜像。
local PHX_DIR_A = { -PI, 2.945243, 2.748893, 2.552544, 2.356194 }   -- Sub76（π + kπ/16）
local PHX_DIR_B = { 0, 0.1963495, 0.3926991, 0.5890486, 0.7853982 } -- Sub77（kπ/16）
local PHX_AV_FAST, PHX_AV_SLOW = 0.02855993, 0.01208305             -- TH08 的 ∓lf2 取反
local PHX_FAST_UPTO = 3                 -- k = 0..2 用快角速度（t=20 那次排在改 lf2 之前）

---一把枪的一轮（Sub74 / Sub75 的 #0..#8）。
---★ 两把枪共用**同一份**发射源记录表：原作里 `ins_111` 写的就是凤凰自己身上的
---  bulletSpawnDescriptor（DispatchShotInstruction 才把它整块拷进弹里）。两把枪相位差 6 帧、
---  每次都是「先写记录、再出弹」，所以共用一份不会串味。
local function gun_fire(self, which)
    local mag = ran:Float(-1, 1) * GUN_MAG_K + GUN_MAG_B     -- #0..#2 算出的 lf0
    local rnd = ran:Float(-PI, PI) / 50                      -- #3 的 RANDOM_ANGLE / 50
    ---which = 0 是 Sub74（发射角 −π/2、槽 1 方向 RANDOM/50 + π/2）、
    ---which = 1 是 Sub75（发射角 +π/2、槽 1 方向 RANDOM/50 − π/2）—— 下面统一取反。
    local shoot_ang, dir0, dir1
    if which == 0 then
        shoot_ang = HALF_PI
        dir0 = -HALF_PI
        dir1 = -(rnd + HALF_PI)
    else
        shoot_ang = -HALF_PI
        dir0 = HALF_PI
        dir1 = -(rnd - HALF_PI)
    end
    EX.set_record(self, 0, EX.K.VEC, 0, GUN_VEC_N0, -1, mag, dir0)
    EX.set_record(self, 1, EX.K.VEC, 0, GUN_VEC_N1, -1, mag, dir1)
    EX.shoot(self, self.x, self.y, {
        op = 97, type = GUN_TYPE, color = EX.color(GUN_COLOR),
        count1 = 1, count2 = 1, speed1 = GUN_SPEED, speed2 = GUN_SPEED2,
        angle = shoot_ang, step = 0, flags = GUN_FLAGS,
    })
end

---Sub73（凤凰本体）。占位贴图 "servant"；★ 纯观感（见头注）。
local phoenix = Class(object, {
    init = function(self, x, y, dir, av)
        self.x, self.y = x, y
        self.px_dir = dir               -- 继承来的 lf1（已取反）；t=1 才生效
        self.px_av0 = av                -- 继承来的 lf2（已取反）；t=1 才生效
        self.px_av = 0                  -- ★ t=0 时原作的角速度还是模板的 0
        self.px_sp = 0                  -- t=1 才写成 2.0
        self.px_t = 0                   -- 出生帧 = t=0（见头注）
        self.px_g0, self.px_g1 = 0, 0   -- 两把枪各自的 context time（t=61 建）
        self.px_gun = false
        self.px_seen = false            -- ENEMY_FLAG_HAS_BEEN_IN_BOUNDS
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        EX.clear_records(self)
    end,
    frame = function(self)
        local t = self.px_t
        ---① 凤凰自己的 ECL（Sub73）。t=0 那一段只有主 ANM / 判定 / 形变，全是观感。
        if t == 1 then
            self.px_dir = add_norm(self.px_dir)     -- SET_DIR_AND_SPEED 里的 AddNormalizeAngle
            self.px_av = self.px_av0                -- `ins_70(lf2)` 也在这条 t=1 上
            self.px_sp = PHX_SPEED
        elseif t == PHX_GUN_AT then
            self.px_gun = true                      -- 两把枪当帧就建、当帧跑 t=0
            self.px_g0, self.px_g1 = 0, 0
        elseif t == PHX_STOP_TURN then
            self.px_av = 0                          -- `ins_70(0)`
        end
        ---② 两把枪（0 / 1 号子 context）。主 context 之后按 0、1 的顺序跑。
        if self.px_gun then
            if self.px_g0 % GUN_PERIOD == 0 then gun_fire(self, 0) end
            self.px_g0 = self.px_g0 + 1
            if self.px_g1 % GUN_PERIOD == GUN2_PHASE then gun_fire(self, 1) end
            self.px_g1 = self.px_g1 + 1
        end
        ---③ UpdateMovement 的 POLAR 分支（EnemyManager.cpp:63-77）：先转方向、再沿新方向
        ---   走 speed 那么远（acceleration 一直是 0）；位置由 IntegrateVelocity 加。
        self.px_dir = add_norm(self.px_dir + self.px_av)
        self.x = self.x + math.cos(self.px_dir) * self.px_sp
        self.y = self.y + math.sin(self.px_dir) * self.px_sp
        self.rot = -self.px_dir * RAD       -- 观感近似：`SET_ANM_ROTATION_ENABLED 1` 朝自己飞的方向
        self.px_t = t + 1
        ---④ 「出场后再出屏就回收」（EnemyManagerUpdate.cpp:228-256）。
        if not self.px_seen then
            if not outside_field(self.x, self.y, PHX_HALF) then self.px_seen = true end
        elseif outside_field(self.x, self.y, PHX_HALF) then
            object.RawDel(self)
        end
    end,
})

---Sub76 / Sub77：两条生成助手，各自在 t = 0/10/20/30/40 放一只凤凰（就放在 BOSS 身上）。
---`which` = 1 走 Sub76 的方向表（快/慢角速度都取正号）、2 走 Sub77（取负号）。
local function spawner_step(owner, s, which)
    local t = s.t
    if t <= 40 and t % 10 == 0 then
        local k = t / 10
        local dir, av
        if which == 1 then
            dir = PHX_DIR_A[k + 1]
            av = (k < PHX_FAST_UPTO) and PHX_AV_FAST or PHX_AV_SLOW
        else
            dir = PHX_DIR_B[k + 1]
            av = (k < PHX_FAST_UPTO) and -PHX_AV_FAST or -PHX_AV_SLOW
        end
        owner.lw200_phx[#owner.lw200_phx + 1] = New(phoenix, owner.x, owner.y, dir, av)
    end
    s.t = t + 1
end

---Sub79（BOSS 的枪）。
---★ 冻结语义：`SET_SECONDARY_TIME(li0)` 之后这个子 context 要**再等 li0 帧**才继续
---  （EclRun.cpp:58-63：冻结帧里 secondaryTime 与 time 各减 1，指令游标不动）⇒
---  两次开火之间的间隔正好 = li0 帧，第一发则在子 context 建好之后第 180 帧。
local function boss_gun_step(owner, c)
    if c.bg_wait > 0 then
        c.bg_wait = c.bg_wait - 1               -- 冻结帧
        return
    end
    EX.shoot(owner, owner.x, owner.y, {         -- #2 `SHOOT_FAN_AIMED`（自机狙）
        op = 96, type = BG_TYPE, color = EX.color(BG_COLOR),
        count1 = 1, count2 = 1, speed1 = BG_SPEED, speed2 = BG_SPEED2,
        angle = 0, step = 0, flags = BG_FLAGS,
    })
    if c.bg_li0 > BG_FLOOR then c.bg_li0 = c.bg_li0 - BG_STEP end   -- #3 / #4
    c.bg_wait = c.bg_li0 - 1                    -- #5 `SET_SECONDARY_TIME` + 同帧那次 −1
end

---Sub72（BOSS 根）。
local ROOT_CHILD_AT = 170               -- t=170 建 0 / 1 号子 context
local ROOT_WRAP = 350                   -- t=350 的 JUMP 落点就是它自己
local CYCLE = 180                       -- Sub78 在 t=180 `JUMP 0 -> #0`

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw200_ctx = {
        t = 0,
        kids = false,       -- 根 t=170 建过 0 / 1 号子 context 没有
        z_t = 0,            -- Sub78 的 context time
        s1 = nil, s2 = nil, -- Sub76 / Sub77 两条生成助手的 time（{ t = … }）
        bg_li0 = BG_FIRST,  -- Sub79 的 li0
        bg_wait = BG_FIRST, -- Sub79 距下一枪还有多少帧
    }
    owner.lw200_phx = {}
    ---落位：BOSS **原地**出现（Sub116 的 ins_63 与 Sub72 的 ins_64 同一个点）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    local c = owner.lw200_ctx
    if not c then return end
    ---① RunEcl 主 context（Sub72）
    if c.t == ROOT_CHILD_AT and not c.kids then
        c.kids = true
        c.z_t = 0
        c.bg_li0, c.bg_wait = BG_FIRST, BG_FIRST
    end
    if c.t >= ROOT_WRAP then c.t = ROOT_CHILD_AT end     -- #23 的 JUMP 落点就是它自己
    c.t = c.t + 1
    ---② RunEcl 的子 context：按 0 → 1 → 2 → 3 的顺序
    if c.kids then
        ---0 号（Sub78）：t=0 建 2 / 3 号，t=180 回到 t=0 重建（两个生成助手的时间轴归零）
        if c.z_t % CYCLE == 0 then
            c.s1 = { t = 0 }
            c.s2 = { t = 0 }
        end
        c.z_t = c.z_t + 1
        ---1 号（Sub79）：BOSS 自己的枪
        boss_gun_step(owner, c)
        ---2 / 3 号（Sub76 / Sub77）：建出来那一帧就跑 t=0
        spawner_step(owner, c.s1, 1)
        spawner_step(owner, c.s2, 2)
    end
    ---③ ClampPosition（位移前后各钳一次；本卡 BOSS 不动，钳了也是原地）
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw200_ctx = nil
    if owner.lw200_phx then
        for i = #owner.lw200_phx, 1, -1 do
            if IsValid(owner.lw200_phx[i]) then
                object.RawDel(owner.lw200_phx[i])
            end
            owner.lw200_phx[i] = nil
        end
    end
    owner.lw200_phx = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[200] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 201「蓬莱「凯风快晴 -富士山火山-」」（藤原妹红）
---  ecldata8sp.ecl：Sub80 = BOSS 根、Sub84 = 「24 发环 + 10 只使魔」的 CALL 子程序、
---  Sub82 / Sub83 = 0 号子 context（自机狙扇 / 42 发环）、Sub81 = 使魔（火山弹的发射台）。
---  （根 t=110 的 `CALL 39` = 32 发纯观感火花，按本文件惯例跳过。）
---
---  · Sub80（根；Sub116 #106 的 `CALL 80` 带 life 2500 = 我们的卡血、`ins_134(4200, …)` = 70 秒）：
---      t=0    `ins_64(110, 4, 192, 128)` 的目标就是**当前位置** ⇒ BOSS 原地（我们 (0, 96)）。
---      t=110  `CALL 84` ⇒ 24 发环 + 10 只使魔。
---      t=290  `SET_CHILD_ECL(0, 82)`（0 号子 context 换成 Sub82）+ `ins_67(60, 4, 1.2)`。
---      t=350  `ins_67` + `CALL 84`；t=410 / 470 各 `CALL 84`。
---      t=590  `SET_CHILD_ECL(0, 82)` + `ins_67`；t=650 `ins_67` + `CALL 84`；
---             t=670 / 690 / 710 / 730 / 750 各 `CALL 84`。
---      t=870  `SET_CHILD_ECL(0, 83)` + `ins_67`；t=930 `ins_67` + `CALL 84`。
---      t=1130 `SET_CHILD_ECL(0, 82)` + `ins_67`；t=1190 `ins_67` + `CALL 84`；
---             t=1250 / 1310 各 `CALL 84`。
---      t=1430 `SET_CHILD_ECL(0, 82)` + `ins_67`；t=1490 `ins_67` + `CALL 84`；
---             t=1510 / 1530 / 1550 / 1570 / 1590 各 `CALL 84`。
---      t=1590 `JUMP 750 -> #37` ⇒ **JUMP 把 context time 直接拨回 750**（EclRunLow.inl:251-256），
---             而落点 #37 的 t=870 ⇒ 120 帧之后事件重开一轮、周期 840 帧。
---             **t ≥ 870 的事件会循环，290..750 的只在第一轮发生。**
---  · `ins_67 MOVE_RANDOM_IN_BOUNDS` = 抽一个「朝自机、又躲着边界」的角，再 60 帧插值走
---    (cos,sin)(角)·1.2·60 = 72 px（BeginBoundaryAwareMove，EclDependencies.cpp:128-191）。
---  · Sub84（`CALL` 子程序，当帧一口气跑完）：#0 一圈 24 发（type 1 / 色 2 / speed 1.0 /
---      基准角 RANDOM_ANGLE / step 0.09817477 / flags 514）；#1..#6 连放 10 只使魔：
---      `lf7 = π/2` 起步、每放一只 `lf7 += 0.6283185`（36°）⇒ 10 只正好转满一圈。
---      ★ `ins_91 SPAWN_FAMILIAR_AT_OFFSET(sub81, 0, 0, 13500, nan, 100)`：位置 = 父机世界
---        坐标 + (0, 0)（EclDependencies.cpp:621-641）⇒ **都生在 BOSS 身上**；
---        子机继承父机的整块变量（EnemyTimeline.cpp:88-95、SpawnEnemy2 从 intVariables 起
---        抄 0x78 字节）⇒ 每只使魔各自拿到自己那个 lf7。
---  · Sub82（0 号子 context；`SET_CHILD_ECL` 的语义 = 先释放再重建，时间归零、脚本从头跑）：
---      #0/#1 xi1 = xi0 = 10；#2 lf0 = AIM_TO_PL（**那一刻**的自机方向）；
---      #3 `SHOOT_FAN`：type 6 / 色 2 / 3 发 / speed 6.0 / 基准角 lf0 / step 0.09817477 /
---         flags 514；#4 t=2 `JUMP_DEC 0 -> #3 xi0`（每 2 帧一发、连打 10 发）；
---      #5 t=4 `JUMP_DEC 0 -> #1 xi1`（重新瞄准、再来 10 发）；#6 RETURN。
---      ⇒ 一次调用 100 发 3 路自机狙扇、共 220 帧（两段之间因为 time 拨零会多出 2 帧）。
---  · Sub83（0 号子 context 的另一支）：xi0 = 20；#1 `SHOOT_CIRCLE`：type 1 / 色 2 / **42 发**
---      （42 × 2π/42 = 正好一圈）/ speed 2.0 / 基准角 RANDOM_ANGLE / step 0.09817477 /
---      flags 514；#2 t=20 `JUMP_DEC 0 -> #1 xi0` ⇒ 每 20 帧一圈、连打 20 圈、共 400 帧。
---  · Sub81（使魔；占位贴图 "servant"，★ 纯观感 —— 原作有 24×24 判定，按本文件惯例不给）：
---      t=0    `ins_7(exF0, selfX)` / `ins_7(exF1, selfY)` 记下出生点、
---             `ins_38 POLAR_TO_CARTESIAN(lf0, lf1, lf7, 200)` ⇒ (lf0, lf1) = 200·(cos, sin)(lf7)、
---             再两条 `ins_36 INSTALL_INTERPOLATION(selfX/Y, 120, 7, 0, …)`：
---             **回调 7 = InterpolateHermite**（EclGlobals.cpp:16-25），
---             值 = h00·起点 + h01·自机 + h10·(lf0/lf1) + h11·0（EclDependencies.cpp:306-350）⇒
---             从出生点沿自己那条方向「鼓」一下、120 帧后落在**自机当时的位置**上。
---             ★ 插值槽的参数存的是**变量 id**（RunEcl.cpp:170-173 拿它去比 ECL_OPERAND_ENEMY_POSITION_X），
---               所以 plX / plY 是**每帧现取**的，中途自机移动它跟着走。
---      t=120  `ins_65(0, 0)` 停住；`lf0 −= 1.256637`、`lf1 += 1.256637`（72°）；
---             11 条 `ins_111 SET_BULLET_TRANSFORM`；`SHOOT_FAN`：type 10（大玉）/ 色 0 / 1 发 /
---             speed 4.0 / 角 lf7 / flags 16908800（**没有出生动画** ⇒ 出生即 FIRED）。
---      t=160  TERMINATE。
---  · 那 11 条记录（槽 0..10）= 「大玉炸成小玉、小玉再炸」的链条：
---      槽 0 / 3 = WAIT 15、槽 6 / 9 = WAIT 10、槽 1 / 4 / 7 = SPAWN_CHILD_PATTERN、
---      槽 2 / 5 / 8 = 它们的「次记录」、槽 10 = DESPAWN（大玉的 flags 里没有这个位 ⇒ 不触发）。
---      三张子波的 packedPattern：0x88070103（4 发 type 7 / 色 1 / 从槽 3 起跑）、
---      0x88030206（3 发 type 3 / 色 2 / 从槽 6 起跑）、0x88000209（2 发 type 0 / 色 2 /
---      从槽 9 起跑）；三者 bit31 = 1 ⇒ **母弹生成完当帧就进 DESPAWNING**（边飞边淡出）。
---      ★ 记录里的 (angle, angleStep) 就是 lf0 / lf1 —— RANDOM 模式的角是
---        「在 [angleStep, angle] 里均匀抽」（BulletManager.cpp:146-149），这两个数上百，
---        等于**整圈乱射**：这就是「火山喷发」的样子。
---      ★ 子弹是**自己在飞的时候**一步步炸开的：每颗弹的 transformIndex 从 startIdx 起，
---        因为每条记录 allowWhileActive = 0，必须等前一条（WAIT）的位清掉才轮到下一条。
---  ★ 坐标：x_我们 = x_原作 − 192、y_我们 = 224 − y_原作、角度取反。Sub81 的两条插值在 y 上
---    取反之后，t=120 的那对加减**都变成减 1.256637**（见 fm_tx / fm_ty）。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local HALF_PI = PI / 2

---BOSS 落位与夹框：Sub116 的 `ins_63 SET_POSITION(192, 128)` / `ins_75(32, 48, 352, 128)`
---（TH08 口径）⇒ 我们 (0, 96)、x∈[−160,160]、y∈[96,176]；Sub80 里没有 `ins_76` ⇒ 夹框有效。
---★ 夹框只加在 BOSS 身上：`ins_75` 写的是**这个敌机实例**（TH08_ECL_CONTEXT_ENEMY(ctx) = enemy，
---  EclRun.cpp:29），而 ins_91 生成的使魔是从 `spawnTemplate` 初始化的
---  （EnemyTimeline.cpp:88-95，模板的 CLAMP_POSITION 在 EnemyManager.cpp:176 被清掉）
---  ⇒ **使魔不夹框**（卡 199 的乌鸦、卡 200 的凤凰同理）。
local BOSS_X, BOSS_Y = 0, 96
local BW_L, BW_R, BW_B, BW_T = -160, 160, 96, 176
---`ins_67` 的四条边界修正判据拿 **TH08 口径**的边界 ±96 / ±48 去比（EclDependencies.cpp:141-171）。
local BW_TH_L, BW_TH_R, BW_TH_B, BW_TH_T = 32, 352, 48, 128

---自机方向（我们坐标 = 普通 atan2）。★ player 只在函数体里取 —— 顶层取会拿到 nil。
local function aim_our(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---卷进 (−π, π]（Global.cpp:1231-1252 的 AddNormalizeAngle(a, 0)）。
local function wrap_pi(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

---出屏判据（IsWithinPlayfield 的反面，GameManager.cpp:132-150）。
local PLAY_L, PLAY_R, PLAY_B, PLAY_T = -192, 192, -224, 224
local function outside_field(x, y, half)
    return x + half < PLAY_L or x - half > PLAY_R
            or y + half < PLAY_B or y - half > PLAY_T
end

---TH08 口径的坐标（只有 ins_67 的边界修正用得上）。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---三种射击共用的参数（Sub84 #0 / Sub82 #3 / Sub83 #1 的 op 97/99 裸操作数）。
local SHOT_STEP  = 0.09817477       -- angleStep（= 2π/64）
local SHOT_FLAGS = 514              -- 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND
local RING_COUNT, RING_SPEED     = 24, 1.0      -- Sub84 #0：24 发环
local FAN_COUNT, FAN_SPEED       = 3, 6.0       -- Sub82 #3：3 路自机狙扇
local BIG_COUNT, BIG_SPEED       = 42, 2.0      -- Sub83 #1：42 发环
local RING_TYPE, RING_COLOR      = 1, 2
local FAN_TYPE, FAN_COLOR        = 6, 2
local BIG_TYPE, BIG_COLOR        = 1, 2
local RING_SPEED2, FAN_SPEED2, BIG_SPEED2 = 0.5, 0.5, 0.5   -- count2 = 1 ⇒ 用不到，照抄

---Sub84 #1..#6：10 只使魔、方向 lf7 = π/2 + k·0.6283185（36°）。
local FAM_BATCH = 10
local FAM_STEP  = 0.6283185

---ins_67 的节拍（`MOVE_RANDOM_IN_BOUNDS 60 4 1.2`）。
local WANDER_FRAMES = 60
local WANDER_SPEED  = 1.2

---Sub81（使魔）的节拍与记录参数。
local FAM_R     = 200               -- `ins_38 POLAR_TO_CARTESIAN(…, 200)`
local FAM_MOVE  = 120               -- `ins_36 INSTALL_INTERPOLATION(…, 120, …)`
local FAM_SHOOT = 120               -- #11..#25 全在 t=120
local FAM_END   = 160               -- #30 TERMINATE
local FAM_TURN  = 1.256637          -- t=120 的 `lf0 -= 1.256637` / `lf1 += 1.256637`
local FAM_HALF  = 16                -- 半精灵宽高（占位贴图口径，回收判据用）
local BIG_SPEED_MAIN = 4.0          -- #25 `SHOOT_FAN` 的 speed1
local BIG_FLAGS = 16908800          -- 0x1020200 = PLAY_SPAWN_SOUND | WAIT | SPAWN_CHILD_PATTERN
local L12_FLAGS = 16908864          -- 0x1020240 = 上一行 + CHANGE_DIRECTION_RELATIVE
local L3_FLAGS  = 393728            -- 0x60200 = PLAY_SPAWN_SOUND | WAIT | DESPAWN
local CHILD_1   = -2012806909       -- 0x88070103：4 发 type 7 / 色 1 / 从槽 3 起跑
local CHILD_2   = -2013068794       -- 0x88030206：3 发 type 3 / 色 2 / 从槽 6 起跑
local CHILD_3   = -2013265399       -- 0x88000209：2 发 type 0 / 色 2 / 从槽 9 起跑

---Sub81 #14..#24 的 11 条 `ins_111 SET_BULLET_TRANSFORM`。
---槽 2 / 5 / 8 是「次记录」（kind 位只是占位，见 EX.K.CHILD2 的注释）。
local function build_records(self)
    EX.clear_records(self)
    EX.set_record(self, 0, EX.K.WAIT, 0, 15, -1, -1, -1)
    EX.set_record(self, 1, EX.K.CHILD, 0, CHILD_1, 4, 0.5, 4.0)
    EX.set_record(self, 2, EX.K.CHILD2, 0, 1, L12_FLAGS, self.fm_tx, self.fm_ty)
    EX.set_record(self, 3, EX.K.WAIT, 0, 15, -1, -1, -1)
    EX.set_record(self, 4, EX.K.CHILD, 0, CHILD_2, 3, 2.5, 4.0)
    EX.set_record(self, 5, EX.K.CHILD2, 0, 1, L12_FLAGS, self.fm_tx, self.fm_ty)
    EX.set_record(self, 6, EX.K.WAIT, 0, 10, -1, -1, -1)
    EX.set_record(self, 7, EX.K.CHILD, 0, CHILD_3, 2, 2.5, 4.0)
    EX.set_record(self, 8, EX.K.CHILD2, 0, 1, L3_FLAGS, self.fm_tx, self.fm_ty)
    EX.set_record(self, 9, EX.K.WAIT, 0, 10, -1, -1, -1)
    EX.set_record(self, 10, EX.K.DESPAWN, 0, -1, -1, -1, -1)
end

---Sub81（使魔）。★ 时间轴：子机在**出生那一帧**就跑第一次 RunEcl（= t=0），
---所以 fm_t 从 0 起、frame 第一次进来处理的就是 t=0（那一帧只有主 ANM / 判定 / 形变与两条
---装插值槽，全是观感 + 下面每帧跑的插值本身）—— 与原件逐帧对齐。
local familiar = Class(object, {
    init = function(self, x, y, dir)
        self.x, self.y = x, y
        self.fm_dir = dir                   -- 继承来的 lf7（已取反到我们坐标）
        self.fm_x0, self.fm_y0 = x, y       -- exF0 / exF1：插值的起点
        ---`POLAR_TO_CARTESIAN(lf0, lf1, lf7, 200)`：TH08 里 (lf0, lf1) = 200·(cos, sin)(lf7)；
        ---我们坐标 y 取反 ⇒ (200·cos(dir), 200·sin(dir))（见头注末条）。
        self.fm_tx = FAM_R * math.cos(dir)
        self.fm_ty = FAM_R * math.sin(dir)
        self.fm_t = 0
        self.fm_shot = false
        self.fm_seen = false
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false                  -- ★ 纯观感
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        EX.clear_records(self)
    end,
    frame = function(self)
        local t = self.fm_t
        ---① 使魔自己的 ECL（Sub81）。t=120 那一批必须**按顺序**来：先改 lf0 / lf1，
        ---   再写 11 条记录（记录里存的就是改过之后的 lf0 / lf1），最后出大玉。
        if t == FAM_SHOOT then
            self.fm_tx = self.fm_tx - FAM_TURN
            self.fm_ty = self.fm_ty - FAM_TURN
            build_records(self)
            self.fm_shot = true
        end
        ---② #25 的 `SHOOT_FAN`：type 10 大玉、色 0、1 发、speed 4.0、角 = lf7、flags 16908800。
        ---   ★ 顺序：出弹在插值**之前**（RunEcl 的指令段先跑），所以用的是上一帧的位置。
        if self.fm_shot then
            self.fm_shot = false
            EX.shoot(self, self.x, self.y, {
                op = 97, type = 10, color = EX.color(0),
                count1 = 1, count2 = 1, speed1 = BIG_SPEED_MAIN, speed2 = 0.5,
                angle = self.fm_dir, step = 0, flags = BIG_FLAGS,
            })
        end
        ---③ #30 TERMINATE。
        if t >= FAM_END then
            object.RawDel(self)
            return
        end
        ---④ RunEcl 末尾的插值回调（RunEcl.cpp:115-175）：timer 每帧 +1、到 duration 封顶，
        ---   progress = timer / duration、缓动 0 = 线性；**装上那一帧就已经跑过一次**
        ---   ⇒ 第 t 帧用的是 progress = (t + 1) / 120。
        if t <= FAM_SHOOT then
            local u = (t + 1) / FAM_MOVE
            if u > 1 then u = 1 end
            local w0 = (1 - u) * (1 - u) * (2 * u + 1)
            local w1 = u * u * (3 - 2 * u)
            local w2 = (1 - u) * (1 - u) * u
            self.x = w0 * self.fm_x0 + w1 * player.x + w2 * self.fm_tx
            self.y = w0 * self.fm_y0 + w1 * player.y + w2 * self.fm_ty
        end
        self.fm_t = t + 1
        ---⑤ 使魔不夹框（见 BW_L 那段注释），出屏**不回收**（原作也有 life 13500：
        ---   它只在 t=160 自己 TERMINATE）——所以这里不做 IsWithinPlayfield 那一套。
    end,
})

---Sub84（CALL 子程序）：24 发环 + 10 只使魔（都生在 BOSS 身上）。
local function call_84(owner)
    EX.shoot(owner, owner.x, owner.y, {
        op = 99, type = RING_TYPE, color = EX.color(RING_COLOR),
        count1 = RING_COUNT, count2 = 1, speed1 = RING_SPEED, speed2 = RING_SPEED2,
        angle = ran:Float(-PI, PI), step = SHOT_STEP, flags = SHOT_FLAGS,
    })
    ---先清一遍已经自己 TERMINATE（或卡结束时被删）的使魔，免得登记表无限长。
    local list = owner.lw201_fams
    for i = #list, 1, -1 do
        if not IsValid(list[i]) then table.remove(list, i) end
    end
    for k = 0, FAM_BATCH - 1 do
        local f = New(familiar, owner.x, owner.y, -(HALF_PI + k * FAM_STEP))
        list[#list + 1] = f
    end
end

---Sub82 #3 的 `SHOOT_FAN`（3 路自机狙扇，基准角 = 上一次 `lf0 = AIM_TO_PL` 的快照）。
local function sub82_shot(owner, c)
    EX.shoot(owner, owner.x, owner.y, {
        op = 97, type = FAN_TYPE, color = EX.color(FAN_COLOR),
        count1 = FAN_COUNT, count2 = 1, speed1 = FAN_SPEED, speed2 = FAN_SPEED2,
        angle = c.lf0, step = SHOT_STEP, flags = SHOT_FLAGS,
    })
end

---Sub83 #1 的 `SHOOT_CIRCLE`（42 发整圈，基准角 RANDOM_ANGLE）——每次开火抽一次。
local function sub83_shot(owner)
    EX.shoot(owner, owner.x, owner.y, {
        op = 99, type = BIG_TYPE, color = EX.color(BIG_COLOR),
        count1 = BIG_COUNT, count2 = 1, speed1 = BIG_SPEED, speed2 = BIG_SPEED2,
        angle = ran:Float(-PI, PI), step = SHOT_STEP, flags = SHOT_FLAGS,
    })
end

---0 号子 context（Sub82 / Sub83）。`SET_CHILD_ECL` = 先释放再重建 ⇒ 每次都从 t=0 起。
local function child_new(sub)
    return { sub = sub, t = 0, xi0 = 0, xi1 = 0, lf0 = 0, dead = false }
end

---Sub82 / Sub83 的指令表（含两条 JUMP_DEC 把 time 拨回 0 之后再跑目标指令）。
local function child_step(owner, c)
    if c.sub == 82 then
        if c.t == 0 then
            c.xi0, c.xi1 = 10, 10                   -- #0 / #1
            c.lf0 = aim_our(owner.x, owner.y)       -- #2 `lf0 = AIM_TO_PL`
            sub82_shot(owner, c)                    -- #3
        elseif c.t == 2 then
            c.xi0 = c.xi0 - 1                       -- #4 `JUMP_DEC 0 -> #3 xi0`
            if c.xi0 > 0 then
                c.t = 0                             -- JUMP 把 time 拨回 0、落点 #3（t=0）
                sub82_shot(owner, c)                -- ⇒ 目标指令同一帧续跑
            end
        elseif c.t == 4 then
            c.xi1 = c.xi1 - 1                       -- #5 `JUMP_DEC 0 -> #1 xi1`
            if c.xi1 > 0 then
                c.t = 0
                c.xi0 = 10                          -- 落点 #1（t=0）⇒ 三个都在同帧跑
                c.lf0 = aim_our(owner.x, owner.y)
                sub82_shot(owner, c)
            else
                c.dead = true                       -- #6 RETURN
            end
        end
    else
        if c.t == 0 then
            c.xi0 = 20                              -- #0
            sub83_shot(owner)                       -- #1
        elseif c.t == 20 then
            c.xi0 = c.xi0 - 1                       -- #2 `JUMP_DEC 0 -> #1 xi0`
            if c.xi0 > 0 then
                c.t = 0
                sub83_shot(owner)
            else
                c.dead = true                       -- #3 RETURN
            end
        end
    end
    c.t = c.t + 1
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:128-191）：
---抽角 + 四条边界修正，再交给 StartTimedPolarDisplacement（:105-126）
---（delta = (cos,sin)(角)·speed·duration、origin = 当前 worldPosition、缓动 4 = OUT_QUADRATIC）。
---★ 「x > upper.x − 96」那条把角改写成 `π − enemy->movementAngle`，用的是**上一段的移动方向**、
---  不是刚抽到的 angle —— 原作自己的怪癖，照抄（卡 208 的 wander_angle 同款）。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = wrap_pi(ran:Float(0, HALF_PI) + 2.3561945)
    else
        angle = ran:Float(0, HALF_PI) - 0.78539819
    end
    if bx < BW_TH_L + 96 then
        if angle > HALF_PI then
            angle = PI - angle
        elseif angle < -HALF_PI then
            angle = -PI - angle
        end
    end
    if bx > BW_TH_R - 96 then
        if angle < HALF_PI and angle >= 0 then
            angle = PI - (owner.lw201_mv_ang or 0)
        elseif angle > -HALF_PI and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < BW_TH_B + 48 and angle < 0 then
        angle = -angle
    end
    if by > BW_TH_T - 48 and angle > 0 then
        angle = -angle
    end
    return angle
end

local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw201_mv_ang = angle
    ---TH08 的 (cos, sin) 到我们坐标就是 (cos, −sin)。
    owner.lw201_mv = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = -math.sin(angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0, ease = 4,
    }
end

---INTERPOLATED 位移的一步（EnemyManager.cpp:85-125）：timer-- →
---progress = 1 − timer/duration → 缓动 → 到点那一帧直接落位。
local function move_step(mv, obj)
    mv.t = mv.t + 1
    if mv.t >= mv.n then
        obj.x, obj.y = mv.x0 + mv.dx, mv.y0 + mv.dy
        return true
    end
    local u = mv.t / mv.n
    if mv.ease == 4 then u = 1 - (1 - u) * (1 - u) end
    obj.x = mv.x0 + mv.dx * u
    obj.y = mv.y0 + mv.dy * u
    return false
end

---Sub80（BOSS 根）的事件表。key = context time；t=1590 的 JUMP 会把 time 拨回 750
---（表里只需写 750 之后的动作 —— 拨回去之后 #37 落在 t=870，所以 750..869 没有事件）。
local ROOT = {
    [110] = function(o) call_84(o) end,
    [290] = function(o) o.lw201_ctx.child = child_new(82); begin_wander(o) end,
    [350] = function(o) begin_wander(o); call_84(o) end,
    [410] = function(o) call_84(o) end,
    [470] = function(o) call_84(o) end,
    [590] = function(o) o.lw201_ctx.child = child_new(82); begin_wander(o) end,
    [650] = function(o) begin_wander(o); call_84(o) end,
    [670] = function(o) call_84(o) end,
    [690] = function(o) call_84(o) end,
    [710] = function(o) call_84(o) end,
    [730] = function(o) call_84(o) end,
    [750] = function(o) call_84(o) end,
    [870] = function(o) o.lw201_ctx.child = child_new(83); begin_wander(o) end,
    [930] = function(o) begin_wander(o); call_84(o) end,
    [1130] = function(o) o.lw201_ctx.child = child_new(82); begin_wander(o) end,
    [1190] = function(o) begin_wander(o); call_84(o) end,
    [1250] = function(o) call_84(o) end,
    [1310] = function(o) call_84(o) end,
    [1430] = function(o) o.lw201_ctx.child = child_new(82); begin_wander(o) end,
    [1490] = function(o) begin_wander(o); call_84(o) end,
    [1510] = function(o) call_84(o) end,
    [1530] = function(o) call_84(o) end,
    [1550] = function(o) call_84(o) end,
    [1570] = function(o) call_84(o) end,
    ---#55 `CALL 84` + #56 `JUMP 750 -> #37`：time 拨回 750，本帧剩下的时间（750）不够再跑
    ---任何一条指令 ⇒ 下一轮从 t=751 数起、t=870（= #37）时事件重开。
    [1590] = function(o) call_84(o); o.lw201_ctx.t = 750 end,
}

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw201_ctx = { t = 0, child = nil }
    owner.lw201_fams = {}
    owner.lw201_mv = nil
    owner.lw201_mv_ang = 0
    ---落位：BOSS **原地**出现（Sub116 的 `ins_63` 与 Sub80 的 `ins_64` 同一个点）。
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    local c = owner.lw201_ctx
    if not c then return end
    ---① RunEcl 主 context（Sub80）。★ 先跑事件、再把 time 自增 —— 所以新建的 context
    ---   第一帧处理的就是 t=0；事件里把 time 拨小（JUMP）也会在这一帧之后生效。
    local fn = ROOT[c.t]
    if fn then fn(owner) end
    c.t = c.t + 1
    ---② 0 号子 context（主 context 之后跑；SET_CHILD_ECL 重建的那一帧就当帧跑 t=0）
    local ch = c.child
    if ch and not ch.dead then child_step(owner, ch) end
    ---③ RunEcl 末尾的 UpdateMovement（`ins_64` 的插值 / `ins_67` 的定时位移）
    if owner.lw201_mv and move_step(owner.lw201_mv, owner) then owner.lw201_mv = nil end
    ---④ ClampPosition（EnemyManagerUpdate.cpp:172-174 位移前后各钳一次）
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw201_ctx = nil
    owner.lw201_mv = nil
    owner.lw201_mv_ang = nil
    if owner.lw201_fams then
        for i = #owner.lw201_fams, 1, -1 do
            if IsValid(owner.lw201_fams[i]) then
                object.RawDel(owner.lw201_fams[i])
            end
            owner.lw201_fams[i] = nil
        end
    end
    owner.lw201_fams = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[201] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 202「被不死鸟附身」（藤原妹红）
---  ecldata8sp.ecl：Sub85 = BOSS 根、Sub86 = 钉自机的 3 号子 context、
---  Sub92 = 又一个「钉自机」的敌机（不判定、只负责贴图）、
---  Sub87 / Sub88 / Sub89 / Sub90 / Sub91 = 0 号（Sub88 是 1 号）子 context 的出弹段、
---  Sub93 / Sub94 / Sub95 = 使魔（小 / 中 / 大凤凰）、Sub96 = 大凤凰的发射子程序（CALL 目标）。
---  内容：BOSS 飘到场地中心，然后每帧贴住自机（这就是「附身」），四段轮流出凤凰。
---
---  · Sub85（根）时间轴（帧号都是**实测**：/tmp/sim.py 按 EclRun.cpp 的调度语义逐帧模拟）：
---      t=0    `ins_64 MOVE_TO(90, 4, 192, 224)`：从出生点 (192,128) 用 90 帧走到场地中心
---             （EclHelpers.cpp:59-87；缓动 4 = ECL_EASING_OUT_QUADRATIC，EclManager.hpp:524）。
---      t<90   `ins_80 DISABLE_INTERACTION_FLAGS 4` 关掉「可受伤」→ t=90 `ins_81` 再打开
---             （位定义 EclManager.hpp:508-513 ⇒ 入场前 89 帧打不掉、也没有判定音）。
---      #19..#23 = `xi0 = 32` 的**钉自机循环**：`selfX = plX` / `selfY = plY`（#20/#21，
---             写的是 enemy->position，EclOperandsFloat.cpp:186-188）+ 火花（#22 `ins_139`
---             SPAWN_EFFECT，纯观感 ⇒ 按本文件惯例跳过）。
---             ★ #23 是 `JUMP_DEC 180 -> #20`（把 time 拨回 180）：32 次循环只花 32 帧，
---               而 context time 只走到 181 ⇒ **根的时间轴比真实帧号快 30 帧**
---               （真实帧 = t − 30，对 t ≥ 181 成立）。
---      #25..#27（真实帧 212）`SPAWN_ENEMY_RELATIVE(sub92)`（life 10000、偏移 0 ⇒ 生在 BOSS 身上）
---             + `SET_CHILD_ECL(3, 86)` + `SET_CHILD_ECL(0, 87)`。
---      真实帧 1112 `SET_CHILD_ECL(0, −1)` 释放 0 号子 context；
---      1292 `REMOVE_ALL_BULLETS` + 0 号 = Sub89；2492 释放；
---      2672 `REMOVE_ALL_BULLETS` + 0 号 = Sub90；3512 释放；
---      3692 `REMOVE_ALL_BULLETS` + 0 号 = Sub91 + 1 号 = Sub88。
---      （#43 `JUMP 181 -> #27` 要到真实帧 13691 才重开一轮，而 ins_134 的 4620 帧超时
---        （= 77 秒，见文件末尾 LIST）永远先到 ⇒ 移植版不实现那段回环。）
---  · Sub86（3 号子 context）：`selfX = plX` / `selfY = plY` 每帧跑 ⇒ BOSS 从此贴住自机。
---      子 context 跑在根与 0/1 号之后，所以「钉」发生在使魔出生**之后**——照抄。
---  · Sub92：`SET_MAIN_ANM 13`、`SET_EXTRA_ANM_SCRIPT_ALT 1 14`、
---      `DISABLE_INTERACTION_FLAGS 16`（ALLOW_OFFSCREEN）/ `3`（ACCEPTS_DAMAGE | COLLISION）
---      ⇒ 没有判定、能出屏；`ins_75 SET_MOVEMENT_BOUNDS(96, 0, 288, 448)` 后每帧贴自机。
---      ★ 贴图未知（主 ANM 13），占位 "servant"；移植版不给判定、不回收（见下面 phoenix_self）。
---  · Sub87（0 号第一段）：`#0 xi0 = 3`；`#1/#2` 各放一只小凤凰（±88, −32）；
---      `#3 t=10 JUMP_DEC 0 -> #1 xi0`；`#5 xi0 = 12`；`#6/#7` 再各放一只；
---      `#8 t=140 JUMP_DEC 130 -> #6 xi0`；`#9 t=200 JUMP 130 -> #5`。
---      ⇒ 实测：212/222/232 三对，之后 362+10j（j=0..11）十二对、每组隔 60 帧再来一组，
---        周期 180 帧（362 → 542 → 722 → 902 → 1082）；1112 被根释放。
---  · Sub88（1 号子 context）：与 Sub87 前半同构（`xi0 = 3` 三连发）+
---      `#4 t=90 JUMP 0 -> #0` ⇒ 实测 3692/3702/3712、3802/3812/3822 …（周期 110 帧、每组 3 对）。
---  · Sub89：`xi0 = 12`；每 10 帧一对中凤凰；`#3` 的 `JUMP_DEC` 落到 0 时，
---      紧接着的 `#4 t=10 JUMP 0 -> #0` **当帧**续跑（time 都是 10）⇒ 实测 1292 起每 10 帧
---      一对、不停顿（1292…2482）。
---  · Sub90：`xi0 = 120`、`lf6 = 2.5`、`li0 = 120`；每轮 `scf0 = ±88` 两次 `CALL 96`
---      （各 8 只大凤凰）→ `lf6 += 0.1` → `ins_2 SET_SECONDARY_TIME(li0)`（冻结 li0 帧）→
---      `if li0 > 30 then li0 -= 10` → `JUMP_DEC 0 -> #3 xi0`。
---      ⇒ 实测轮首 2672/2792/2902/3002/3092/3172/3242/3302/3352/3392/3422/…，也就是
---        间隔 = 上一轮的 li0（120,110,…,30,30,…），大玉初速 lf6 = 2.5,2.6,2.7,…。
---  · Sub91：`xi0 = 12`、`lf6 = 1.5`；结构与 Sub90 一样但**不冻结**（只有 t=60 的
---      `JUMP_DEC 0 -> #2 xi0`）⇒ 实测每 60 帧一轮 16 只，lf6 = 1.5,1.6,…；
---      xi0 归零后 `JUMP 0 -> #0` 重头来（lf6 回到 1.5）。
---  · Sub96（CALL 目标）：`lf7 = π/2`、`xi0 = 8`，每次
---      `SPAWN_FAMILIAR_AT_OFFSET(sub95, cf0, −32, 13500, …)` 之后 `lf7 += π/4` 并
---      `NORMALIZE_ANGLE`（= AddNormalizeAngle(a, 0)，卷进 (−π, π]）。
---      ★ `cf0`（callParameterFloats[0]）是 CALL 从调用者的 `scf0` 拷来的
---        （CallSubOnEnemy，EclDependencies.cpp:487-493）⇒ 两批分别在 bx ± 88。
---      ★ RETURN 恢复的是**整个 context 拷贝**（PopEclContext，EclDependencies.cpp:504-546）
---        ⇒ Sub96 对 xi0 / lf7 的改写不会漏回 Sub90/Sub91。
---      ★ 使魔出生时整块继承创建者的变量（SpawnEnemy2，EnemyTimeline.cpp:88-95）
---        ⇒ 每只大凤凰自带自己的 lf7（方向）与 lf6（大玉初速）。
---  · Sub93（小凤凰）：t=0 `SET_DIR_AND_SPEED(AIM_TO_PL, 0.01)`（朝自机每帧 0.01 px，
---      140 帧才挪 1.4 px）；t=140 `SHOOT_CIRCLE(type1/col4, 4 发 × 2 圈, speed 1.0→0.75,
---      基准角 RANDOM_ANGLE, step π/4, flags 514)`，同一帧 TERMINATE。
---  · Sub94（中凤凰）：同前，但 t=140 `SHOOT_CIRCLE_AIMED(type6/col6, 5 发 × 4 圈,
---      speed 5.0/3.875/2.75/1.625, 角 0 / step 0, flags 514)`。
---  · Sub95（大凤凰）：t=0 `AIM_TO_PL` 0.01；t=120 停住（`SET_DIR_AND_SPEED(0, 0)`）、
---      `lf0 = lf7 − 1.256637`、`lf1 = lf7 + 1.256637`、11 条 `ins_111`，再甩一发大玉
---      （type10/col0、speed1 = lf6、角 = lf7、flags 16908800）；t=160 TERMINATE。
---      ★ 那 11 条记录与卡 201 的 Sub81 **逐条同构**，只有槽 4/7 的 float0 不同
---        （卡 201 是 2.5、这里是 1.5）；float1（speed2）写的是 lf6，但次记录的 count2 = 1
---        ⇒ `SpawnSingleBullet` 走 speed1（BulletManager.cpp:107-112），float1 用不到。
---  ★ 坐标：x_我们 = x_原作 − 192、y_我们 = 224 − y_原作、角度整体取反。子机的出生偏移
---    (Δx, −32)（原作朝上）⇒ 我们 (Δx, +32)（也朝上）。
---  ★ 使魔一律按本文件惯例：占位贴图 "servant"、不判定（原作有 24×24 与 30 帧减伤，
---    移植版不给）、不夹框、不回收（出屏不死，只在自己的 t 到点后 TERMINATE）。
---    Sub92 同理（贴图未知，占位 "servant"）。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local HALF_PI = PI / 2
local QUARTER_PI = PI / 4
local RAD = 57.29577951308232

local function wrap_pi(a)
    a = a % (2 * PI)
    if a > PI then a = a - 2 * PI end
    return a
end

local function aim_our(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---BOSS 落位 / 夹框：生成助手 Sub116 的 `ins_63 SET_POSITION(192,128)` ⇒ 我们 (0, 96)；
---Sub85 #1 的 `ins_75 SET_MOVEMENT_BOUNDS(96, 32, 288, 448)`（TH08 口径 = 左上右下）
---⇒ 我们 x∈[−96, 96]、y∈[−224, 192]（EnemyManagerUpdate.cpp:172-174 位移前后各钳一次）。
local BOSS_X, BOSS_Y = 0, 96
local BW_L, BW_R, BW_B, BW_T = -96, 96, -224, 192

---`MOVE_TO` 的参数与缓动（EclHelpers.cpp:59-87：delta = 目标 − 世界坐标、origin = 当前位置）。
local MOVE_FRAMES, MOVE_EASE, MOVE_TX, MOVE_TY = 90, 4, 0, 0

---根 context 的时间轴（真实帧号）：钉自机循环 180..211、212 挂子 context，之后是事件表。
local PIN_FIRST, PIN_LAST = 180, 211
local T_ATTACH = 212
local T_FREE_A, T_SUB89, T_FREE_B, T_SUB90, T_FREE_C, T_SUB91 = 1112, 1292, 2492, 2672, 3512, 3692

---使魔的出生偏移：`SPAWN_FAMILIAR_AT_OFFSET(sub, ±88, −32, …)`（TH08 口径）。
local FAM_OFF_X, FAM_OFF_Y = 88, 32
local FAM_DRIFT = 0.01                  -- `SET_DIR_AND_SPEED(AIM_TO_PL, 0.01)`

---Sub93 / Sub94 的出弹参数（#8 的 op 99 / op 98 裸操作数；aimMode = op − 96）。
local F93_TYPE, F93_COLOR, F93_N1, F93_N2, F93_SPD1, F93_SPD2, F93_STEP = 1, 4, 4, 2, 1.0, 0.5, QUARTER_PI
local F94_TYPE, F94_COLOR, F94_N1, F94_N2, F94_SPD1, F94_SPD2, F94_STEP = 6, 6, 5, 4, 5.0, 0.5, 0
local F_SHOOT   = 140                  -- 93 / 94 的开火帧（= 同一帧 TERMINATE）
local F95_SHOOT = 120                  -- 95 的开火帧
local F95_END   = 160                  -- 95 的 TERMINATE
local F95_N2, F95_SPD2 = 1, 0.5        -- #24 的 count2 / speed2（count2 = 1 ⇒ 用不到）

---flags：514 = 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND；
---16908800 = 0x1020200 = PLAY_SPAWN_SOUND | WAIT | SPAWN_CHILD_PATTERN。
local F_SMALL_FLAGS = 514
local F_BIG_FLAGS   = 16908800

---Sub95 #13..#23 的 11 条 `ins_111`（与卡 201 的 Sub81 同构，只有槽 4/7 的 float0 不同）。
local CHILD_1  = -2012806909          -- 0x88070103：4 发 type 7 / 色 1 / 从槽 3 起跑
local CHILD_2  = -2013068794          -- 0x88030206：3 发 type 3 / 色 2 / 从槽 6 起跑
local CHILD_3  = -2013265399          -- 0x88000209：2 发 type 0 / 色 2 / 从槽 9 起跑
local CW_CHILD1, CW_CHILD2 = 0.5, 1.5 -- 三条子波的 speed1（float0）
local L12_FLAGS = 16908864            -- 0x1020240 = PLAY_SPAWN_SOUND | REL | WAIT | CHILD
local L3_FLAGS  = 393728              -- 0x60200 = PLAY_SPAWN_SOUND | WAIT | DESPAWN
local CW_HALF   = 1.256637            -- 72°：lf0 = lf7 − 1.256637 / lf1 = lf7 + 1.256637

---`ins_67` 那类插值的逐步推进（EnemyManager.cpp:80-121 的 INTERPOLATED 模式）：
---timer-- → progress = 1 − timer/duration → 缓动 → 到点那一帧直接落位。
local function move_step(mv, obj)
    mv.t = mv.t + 1
    if mv.t >= mv.n then
        obj.x, obj.y = mv.x0 + mv.dx, mv.y0 + mv.dy
        return true
    end
    local u = mv.t / mv.n
    if mv.ease == 4 then u = 1 - (1 - u) * (1 - u) end     -- OUT_QUADRATIC
    obj.x = mv.x0 + mv.dx * u
    obj.y = mv.y0 + mv.dy * u
    return false
end

---使魔登记表（卡结束时统一删；每次出弹前顺手清掉已经自己 TERMINATE 的）。
local function prune_fams(owner)
    local list = owner.lw202_fams
    for i = #list, 1, -1 do
        if not IsValid(list[i]) then table.remove(list, i) end
    end
end

---子 context 的**迷你解释器**：`ins` 表按 ECL 的指令号索引（下标 = `#N`），
---每项 = { t = 指令的 time, act = function(owner, c) … end }。
---★ 调度语义照抄 EclRun.cpp:63-85：`context time == 指令的 time` 才执行；
---  JUMP / JUMP_DEC 把 time 直接拨走、拨到的那条**同一帧**接着跑（所以下面是 while）；
---  帧尾 time + 1（EclRun.cpp:188）。
---★ act 的返回值：无返回 = 正常执行（pc + 1）；返回 (新pc, 新time) = 跳转；
---  返回 'stop' = 本帧到此为止（二级计时器冻结，EclRun.cpp:60-65）。
local function run_child(owner, c)
    local ins = c.ins
    while true do
        local i = ins[c.pc]
        if i == nil then
            c.dead = true               -- 指令表跑完（= RETURN / TERMINATE）
            return
        end
        if c.t ~= i.t then break end
        local npc, nt = i.act(owner, c)
        if npc == 'stop' then return end
        if npc then c.pc, c.t = npc, nt else c.pc = c.pc + 1 end
    end
    c.t = c.t + 1
end

---一帧的子 context：先吃 `ins_2 SET_SECONDARY_TIME` 的冻结。
---★ 原作里冻结是「每帧 secondaryTime--、time--」（EclRun.cpp:60-65），设完的**当帧**
---  就已经算掉一次 ⇒ 这里把剩余帧数记成 li0 − 1，之后每帧再减一次（实测轮距 = li0）。
local function child_step(owner, c)
    if c.freeze > 0 then
        c.freeze = c.freeze - 1
        return
    end
    run_child(owner, c)
end

---Sub95 #13..#23 的 11 条记录（`ins_111 SET_BULLET_TRANSFORM`）——定义在使魔类之后，
---但使魔的 frame 里要用，所以先声明（Lua 的 upvalue 必须在定义处之前 local）。
local build_records

---使魔（Sub93 小 / Sub94 中 / Sub95 大凤凰）。
---  `dir` 是**我们坐标**下的朝向：93/94 用不到（开火角是 RANDOM 或自机狙），
---  95 是继承来的 lf7（大玉就沿这个方向飞）。
---  `lf6` 是继承来的「大玉初速」（Sub90 每轮 +0.1、Sub91 每轮 +0.1）。
local familiar = Class(object, {
    init = function(self, kind, x, y, dir, lf6)
        self.x, self.y = x, y
        self.fam_kind = kind
        self.fam_lf6 = lf6 or 0
        self.fam_t = 0
        ---`ins_65 SET_DIR_AND_SPEED(角, 速)`：EclRunLow.inl:506-513 把它设成 POLAR 模式、
        ---duration 0 ⇒ 之后一直沿这条直线漂（93/94/95 的 t=0 都是 `AIM_TO_PL 0.01`）。
        local a = aim_our(x, y)
        self.fam_dir = (kind == 95) and dir or a
        self.vx = math.cos(a) * FAM_DRIFT
        self.vy = math.sin(a) * FAM_DRIFT
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false                  -- ★ 纯观感（原作 24×24 判定，按本文件惯例不给）
        self.navi = false
        self.bound = false                  -- 出屏不回收：它只在自己 TERMINATE 时消失
        self.rot = -self.fam_dir * RAD      -- 观感：朝自己飞的方向（rot 是角度制）
        self._blend = ""
        self._a = 255
        EX.clear_records(self)
    end,
    frame = function(self)
        local t, k = self.fam_t, self.fam_kind
        if k == 95 then
            ---① t=120：`SET_DIR_AND_SPEED(0, 0)` 停住 → 写 11 条记录 → 甩一发大玉。
            if t == F95_SHOOT then
                self.vx, self.vy = 0, 0
                build_records(self)
                EX.shoot(self, self.x, self.y, {
                    op = 99, type = 10, color = EX.color(0),
                    count1 = 1, count2 = F95_N2,
                    speed1 = self.fam_lf6, speed2 = F95_SPD2,
                    angle = self.fam_dir, step = 0, flags = F_BIG_FLAGS,
                })
            end
            ---② t=160 TERMINATE。
            if t >= F95_END then
                object.RawDel(self)
                return
            end
        else
            ---t=140：开火 + 同一帧 TERMINATE（顺序不能反）。
            if t == F_SHOOT then
                if k == 93 then
                    EX.shoot(self, self.x, self.y, {
                        op = 99, type = F93_TYPE, color = EX.color(F93_COLOR),
                        count1 = F93_N1, count2 = F93_N2,
                        speed1 = F93_SPD1, speed2 = F93_SPD2,
                        angle = ran:Float(-PI, PI), step = F93_STEP, flags = F_SMALL_FLAGS,
                    })
                else
                    EX.shoot(self, self.x, self.y, {
                        op = 98, type = F94_TYPE, color = EX.color(F94_COLOR),
                        count1 = F94_N1, count2 = F94_N2,
                        speed1 = F94_SPD1, speed2 = F94_SPD2,
                        angle = 0, step = F94_STEP, flags = F_SMALL_FLAGS,
                    })
                end
                object.RawDel(self)
                return
            end
        end
        self.fam_t = t + 1
    end,
})

---Sub92：`SPAWN_ENEMY_RELATIVE(sub92, 0, 0, 0, 10000, …)` 生出来的「第二个自己」。
---原作它没有判定（`DISABLE_INTERACTION_FLAGS 3` = 关 ACCEPTS_DAMAGE | COLLISION）、
---`SET_MAIN_ANM 13`、`SET_EXTRA_ANM_SCRIPT_ALT 1 14`，之后每帧 `selfX/Y = plX/Y`，
---并被 `SET_MOVEMENT_BOUNDS(96, 0, 288, 448)` 夹住（⇒ 我们 x∈[−96,96]、y 几乎不夹）。
---★ 贴图未知，占位 "servant"。
local phoenix_self = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        self.ps_t = 0
    end,
    frame = function(self)
        ---#5/#6 `selfX = plX` / `selfY = plY`（每帧）。
        self.x, self.y = player.x, player.y
        if self.x < -96 then self.x = -96 elseif self.x > 96 then self.x = 96 end
        if self.y < -224 then self.y = -224 elseif self.y > 224 then self.y = 224 end
        self.ps_t = self.ps_t + 1
    end,
})

---Sub95 #13..#23 的 11 条记录（`ins_111 SET_BULLET_TRANSFORM`）。
---★ 记录里的 (float0, float1) = (lf0, lf1)，而 RANDOM 模式的角是「在 [angleStep, angle]
---  里均匀抽」（BulletManager.cpp:146-149）⇒ 子波在 lf7 ± 72° 的扇形里乱射。
build_records = function(self)
    EX.clear_records(self)
    local a0, a1 = self.fam_dir - CW_HALF, self.fam_dir + CW_HALF
    EX.set_record(self, 0, EX.K.WAIT, 0, 15, -1, -1, -1)
    EX.set_record(self, 1, EX.K.CHILD, 0, CHILD_1, 4, CW_CHILD1, self.fam_lf6)
    EX.set_record(self, 2, EX.K.CHILD2, 0, 1, L12_FLAGS, a0, a1)
    EX.set_record(self, 3, EX.K.WAIT, 0, 15, -1, -1, -1)
    EX.set_record(self, 4, EX.K.CHILD, 0, CHILD_2, 3, CW_CHILD2, self.fam_lf6)
    EX.set_record(self, 5, EX.K.CHILD2, 0, 1, L12_FLAGS, a0, a1)
    EX.set_record(self, 6, EX.K.WAIT, 0, 10, -1, -1, -1)
    EX.set_record(self, 7, EX.K.CHILD, 0, CHILD_3, 2, CW_CHILD2, self.fam_lf6)
    EX.set_record(self, 8, EX.K.CHILD2, 0, 1, L3_FLAGS, a0, a1)
    EX.set_record(self, 9, EX.K.WAIT, 0, 10, -1, -1, -1)
    EX.set_record(self, 10, EX.K.DESPAWN, 0, -1, -1, -1, -1)
end

---放一只使魔（`SPAWN_FAMILIAR_AT_OFFSET(sub, Δx, −32, …)`：位置 = BOSS 的世界坐标 + 偏移）。
local function fam_one(owner, kind, dx)
    prune_fams(owner)
    local list = owner.lw202_fams
    list[#list + 1] = New(familiar, kind, owner.x + dx, owner.y + FAM_OFF_Y, 0, 0)
end

---Sub96（CALL 目标）：8 只大凤凰、方向 lf7 = π/2 + k·π/4（归一化后取反到我们坐标），
---出生点 = BOSS + (cf0, −32)（cf0 = 调用者的 scf0）。
local function call96(owner, c)
    prune_fams(owner)
    local list = owner.lw202_fams
    for k = 0, 7 do
        local a = wrap_pi(HALF_PI + k * QUARTER_PI)
        list[#list + 1] = New(familiar, 95, owner.x + c.scf0, owner.y + FAM_OFF_Y, -a, c.lf6)
    end
end

---Sub87（0 号子 context 第一段）。下标 = ECL 指令号。
local SUB87 = {
    [0] = { t = 0, act = function(o, c) c.xi0 = 3 end },
    [1] = { t = 0, act = function(o, c) fam_one(o, 93, FAM_OFF_X) end },
    [2] = { t = 0, act = function(o, c) fam_one(o, 93, -FAM_OFF_X) end },
    [3] = { t = 10, act = function(o, c)               -- JUMP_DEC 0 -> #1 xi0
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end                  -- 落到 #4（t=130）
        return 1, 0
    end },
    [4] = { t = 130, act = function(o, c) end },       -- op0：跳转表占位字节，什么都不做
    [5] = { t = 130, act = function(o, c) c.xi0 = 12 end },
    [6] = { t = 130, act = function(o, c) fam_one(o, 93, FAM_OFF_X) end },
    [7] = { t = 130, act = function(o, c) fam_one(o, 93, -FAM_OFF_X) end },
    [8] = { t = 140, act = function(o, c)               -- JUMP_DEC 130 -> #6 xi0
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end                  -- 落到 #9（t=200）
        return 6, 130
    end },
    [9] = { t = 200, act = function(o, c) return 5, 130 end },   -- JUMP 130 -> #5
}
---Sub88（1 号子 context）：同 Sub87 前半 + `#4 JUMP 0 -> #0`。
local SUB88 = {
    [0] = { t = 0, act = function(o, c) c.xi0 = 3 end },
    [1] = { t = 0, act = function(o, c) fam_one(o, 93, FAM_OFF_X) end },
    [2] = { t = 0, act = function(o, c) fam_one(o, 93, -FAM_OFF_X) end },
    [3] = { t = 10, act = function(o, c)               -- JUMP_DEC 0 -> #1 xi0
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end                  -- 落到 #4（t=90）
        return 1, 0
    end },
    [4] = { t = 90, act = function(o, c) return 0, 0 end },      -- JUMP 0 -> #0
}

---Sub89：`xi0 = 12` + 每 10 帧一对中凤凰（JUMP_DEC 归零后 #4 的 JUMP 当帧接上）。
local SUB89 = {
    [0] = { t = 0, act = function(o, c) c.xi0 = 12 end },
    [1] = { t = 0, act = function(o, c) fam_one(o, 94, FAM_OFF_X) end },
    [2] = { t = 0, act = function(o, c) fam_one(o, 94, -FAM_OFF_X) end },
    [3] = { t = 10, act = function(o, c)               -- JUMP_DEC 0 -> #1 xi0
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end                  -- 落到 #4（同样是 t=10）
        return 1, 0
    end },
    [4] = { t = 10, act = function(o, c) return 0, 0 end },      -- JUMP 0 -> #0
}

---Sub90：每轮 16 只大凤凰（±88 两批 ×8）+ 冻结 li0 帧。
local SUB90 = {
    [0] = { t = 0, act = function(o, c) c.xi0 = 120 end },
    [1] = { t = 0, act = function(o, c) c.lf6 = 2.5 end },
    [2] = { t = 0, act = function(o, c) c.li0 = 120 end },
    [3] = { t = 0, act = function(o, c) end },                 -- 音效 5（跳过）
    [4] = { t = 0, act = function(o, c) c.scf0 = 88 end },
    [5] = { t = 0, act = function(o, c) call96(o, c) end },     -- CALL 96
    [6] = { t = 0, act = function(o, c) c.scf0 = -88 end },
    [7] = { t = 0, act = function(o, c) call96(o, c) end },     -- CALL 96
    [8] = { t = 0, act = function(o, c) c.lf6 = c.lf6 + 0.1 end },
    [9] = { t = 0, act = function(o, c)                         -- SET_SECONDARY_TIME li0
        c.freeze = c.li0 - 1
        return 'stop'
    end },
    [10] = { t = 0, act = function(o, c)                        -- JMP_INT_LE li0 30 -> #12
        if c.li0 <= 30 then return 12, c.t end
    end },
    [11] = { t = 0, act = function(o, c) c.li0 = c.li0 - 10 end },
    [12] = { t = 0, act = function(o, c)                        -- JUMP_DEC 0 -> #3 xi0
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end                           -- 落到 #13
        return 3, 0
    end },
    [13] = { t = 0, act = function(o, c) return 0, 0 end },      -- JUMP 0 -> #0
}

---Sub91：每 60 帧一轮 16 只（不冻结），lf6 每轮 +0.1、xi0 归零后重头。
local SUB91 = {
    [0] = { t = 0, act = function(o, c) c.xi0 = 12 end },
    [1] = { t = 0, act = function(o, c) c.lf6 = 1.5 end },
    [2] = { t = 0, act = function(o, c) end },                 -- 音效 5（跳过）
    [3] = { t = 0, act = function(o, c) c.scf0 = 88 end },
    [4] = { t = 0, act = function(o, c) call96(o, c) end },     -- CALL 96
    [5] = { t = 0, act = function(o, c) c.scf0 = -88 end },
    [6] = { t = 0, act = function(o, c) call96(o, c) end },     -- CALL 96
    [7] = { t = 0, act = function(o, c) c.lf6 = c.lf6 + 0.1 end },
    [8] = { t = 60, act = function(o, c)                        -- JUMP_DEC 0 -> #2 xi0
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end                           -- 落到 #9
        return 2, 0
    end },
    [9] = { t = 60, act = function(o, c) return 0, 0 end },      -- JUMP 0 -> #0
}

---子 context 的登记表：`sub` → 指令表。
local CHILD_INS = { [87] = SUB87, [88] = SUB88, [89] = SUB89, [90] = SUB90, [91] = SUB91 }

---`SET_CHILD_ECL`（op 135）＝先释放再重建：新 context 的 time 从 0 起、变量清零
---（EclRunHigh.inl 的 op135 分支给新 context 分配干净存储）。
local function child_new(sub)
    return { sub = sub, ins = CHILD_INS[sub], t = 0, pc = 0, freeze = 0,
             xi0 = 0, li0 = 0, lf6 = 0, scf0 = 0, dead = false }
end

---根 context 的事件表：key = 真实帧号（见头注的 +30 说明）。
local ROOT = {
    [T_ATTACH] = function(o)
        ---`SPAWN_ENEMY_RELATIVE(sub92, 0, 0, 0, life 10000, …)`：偏移 (0,0) ⇒ 生在 BOSS 身上。
        o.lw202_self = New(phoenix_self, o.x, o.y)
        o.lw202_ctx.pin = true              -- `SET_CHILD_ECL(3, 86)`：之后交给 3 号子 context
        o.lw202_ctx.c0 = child_new(87)      -- `SET_CHILD_ECL(0, 87)`
    end,
    [T_FREE_A] = function(o) o.lw202_ctx.c0 = nil end,       -- `SET_CHILD_ECL(0, −1)`
    [T_SUB89] = function(o)
        EX.pool_cancel()                    -- `REMOVE_ALL_BULLETS`
        o.lw202_ctx.c0 = child_new(89)
    end,
    [T_FREE_B] = function(o) o.lw202_ctx.c0 = nil end,
    [T_SUB90] = function(o)
        EX.pool_cancel()
        o.lw202_ctx.c0 = child_new(90)
    end,
    [T_FREE_C] = function(o) o.lw202_ctx.c0 = nil end,
    [T_SUB91] = function(o)
        EX.pool_cancel()
        o.lw202_ctx.c0 = child_new(91)
        o.lw202_ctx.c1 = child_new(88)
    end,
}

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw202_ctx = { t = 0, c0 = nil, c1 = nil, pin = false }
    owner.lw202_fams = {}
    owner.lw202_self = nil
    owner.lw202_mv = {
        x0 = BOSS_X, y0 = BOSS_Y,
        dx = MOVE_TX - BOSS_X, dy = MOVE_TY - BOSS_Y,
        n = MOVE_FRAMES, t = 0, ease = MOVE_EASE,
    }
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    local c = owner.lw202_ctx
    if not c then return end
    local t = c.t
    ---① 根 context。★ `MOVE_TO` 的插值跑在 RunEcl 末尾的 UpdateMovement 里（EclRun.cpp:208），
    ---  也就是**指令跑完之后** ⇒ 这里放在事件之前，和引擎同序。
    if owner.lw202_mv and move_step(owner.lw202_mv, owner) then owner.lw202_mv = nil end
    ---#20/#21（t=180..#23 的 32 次循环）：钉自机。
    if t >= PIN_FIRST and t <= PIN_LAST then
        owner.x, owner.y = player.x, player.y
    end
    local fn = ROOT[t]
    if fn then fn(owner) end
    ---② 0 号子 context（Sub87 / Sub89 / Sub90 / Sub91）——`SET_CHILD_ECL` 重建的那一帧
    ---  就当帧跑 t=0（子 context 在主 context 之后跑，见头注）。
    if c.c0 and not c.c0.dead then child_step(owner, c.c0) end
    ---③ 1 号子 context（Sub88）。
    if c.c1 and not c.c1.dead then child_step(owner, c.c1) end
    ---④ 3 号子 context（Sub86）：钉自机（子 context 里跑的 ⇒ 在 0/1 号之后）。
    if c.pin then owner.x, owner.y = player.x, player.y end
    ---⑤ ClampPosition（EnemyManagerUpdate.cpp:172-174；BOSS 没有速度，钳一次就够）。
    if owner.x < BW_L then owner.x = BW_L elseif owner.x > BW_R then owner.x = BW_R end
    if owner.y < BW_B then owner.y = BW_B elseif owner.y > BW_T then owner.y = BW_T end
    c.t = t + 1
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw202_ctx = nil
    owner.lw202_mv = nil
    if owner.lw202_self and IsValid(owner.lw202_self) then
        object.RawDel(owner.lw202_self)
    end
    owner.lw202_self = nil
    if owner.lw202_fams then
        for i = #owner.lw202_fams, 1, -1 do
            if IsValid(owner.lw202_fams[i]) then
                object.RawDel(owner.lw202_fams[i])
            end
            owner.lw202_fams[i] = nil
        end
    end
    owner.lw202_fams = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[202] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 203「蓬莱人形」（藤原妹红）
---  ecldata8sp.ecl：Sub97 = BOSS 根、Sub98 = 「人形」（使魔）、Sub99 / Sub100 = 人形的枪
---  （0 / 1 号子 context）、Sub101 / Sub102 = BOSS 的枪（0 / 1 号子 context）、
---  Sub39 = 公用火花循环（根与两把枪都在开火前 CALL 一次）。
---  内容：BOSS 原地不动，先在场地左下角 / 右上角各放一个「人形」；人形沿**矩形螺旋**
---  一条边一条边地往里绕（每 280 帧换一次腿、每换腿落点往里缩 8 px），走过的地方
---  每 30 帧掉一颗**站着不动**的小弹（1 号枪 = 留下轨迹），另外每 4 帧掉一颗
---  「原地站 60 帧、再朝自机方向按 1/30 每帧加速到 2.0」的弹（0 号枪）。
---  BOSS 自己 t=900 起每 40 帧甩一圈 32 发（速度 1.5..2.0 随机、基准角随机），
---  t=1800 起每 2 帧一发自机狙（速度 2.0、每 30 发回 #2 重新瞄准）。
---
---  · Sub97（根）时间轴（帧号都是**实测**：/tmp/sim.py 照 EclRun.cpp 的调度逐帧模拟）：
---      t=0    `ins_105 SET_SHOOT_INTERVAL 0`、`ins_95 KILL_ALL_NON_BOSS`、
---             `ins_80 DISABLE_INTERACTION_FLAGS 4`（4 = DAMAGEABLE ⇒ 入场先无敌）、
---             `ins_113 SET_BULLET_SOUNDS(-1, -1)`（移植版不放音效）、
---             `ins_110 SET_SHOOT_OFFSET(0, 0)`、`ins_134 SET_TIMER_CALLBACK(5400)`（90 秒超时，
---             见文件末尾 LIST）、`ins_131/132/153` 血量 / 倒计时、`ins_12 START_SPELL`
---             （符卡名与横幅；移植版走 LIST 里的卡名）、
---             `ins_64 MOVE_TO(110, 4, 192, 128)` —— 目标正好是生成助手 Sub116 #28
---             `SET_POSITION(192, 128)` 放它的地方 ⇒ **delta = 0，原地不动**（缓动 4 用不上）。
---      t=110  `ins_81 ENABLE_INTERACTION_FLAGS 4`（恢复可受伤）、
---             `ins_160 SET_DAMAGE_REDUCTION_TIMER 420`（原作入场后 420 帧砍不出伤害；
---               移植版的伤害走 boss_system，不另做）、`ins_183 SET_NO_DAMAGE_DURING_STOP 1`、
---             `ins_182/61/61` 换 EXTRA 图层、`ins_52 CALL 39`（火花，纯观感 ⇒ 跳过）、
---             `ins_6 SET_INT li7 6` → `ins_90 SPAWN_FAMILIAR_AT_POSITION(sub98, 0, 448, …)`
---             （TH08 左下角）、`li7 = 2` → 同样的调用 (384, 0)（右上角）、
---             `ins_135 SET_CHILD_ECL(0, 101)` / `(1, 102)`（BOSS 的两把枪）。
---      t=170  `ins_4 JUMP 110 -> #26` ⇒ 之后一直空转（子 context 接着跑）。
---  · ★ li7 是**整数**变量，SPAWN_ENEMY 只把 intVariables 拷给新敌机（EclDependencies.cpp:605-612）
---      ⇒ 两个人形各自带着自己的色号（6 / 2），枪里的 `col10007` 就是它。
---  · ★ Sub98（人形）的两条腿：#8 先把「对面那条边的坐标」算进 exF0/exF1、#12 走第一条边、
---      #18（t=170）走第二条边 —— **第二条腿在第一腿还剩 10 帧时就把插值改写了**
---      （ConfigureRelativeMotion 重新算 origin / delta / timer），所以每一腿都不是走满的。
---      #17 `FLOAT_ADD_ASSIGN lf0 8`：每换一条腿，落点往里缩 8 px ⇒ 矩形螺旋往里收。
---      ★ 注意 `ins_26 FLOAT_SUB exF1 448 lf0` 的**第 0 个操作数是目的**
---        （EclRunLow.inl:300-306：dst = op0 = 448 − op2）⇒ 写的是 exF1，不是 lf0（看反就抓瞎）。
---  · ★ 人形的枪（Sub99 / Sub100）挂在**同一个敌机**的 bulletSpawnDescriptor 上 ⇒
---      Sub99 #0/#2 那两条 `ins_111`（`WAIT 60` + `VEC 1/30 × 60 帧`）对两种弹都写着；
---      但 Sub100 的 flags = 0x1202 **没有** WAIT(0x20000) / VEC(0x10) 位 ⇒
---      AdvanceTransformProgram 两条都跳过（BulletManager.cpp:317-329）⇒ 那批弹 speed1 = 0
---      **站着不动**（「人形走过留下的一串点」）。Sub99 的 flags = 0x20212 带这两位
---      ⇒ 先站 60 帧、再朝记录里的角度加速 60 帧到 2.0；记录里的角度 = 写记录那一刻的
---      `AIM_TO_PL`（EclOperandsFloat.cpp:114-115），而 #2 每 4 帧就重写一次记录
---      ⇒ 每个时刻发出的弹都朝**当时的**自机方向。
---  · ★ 两把 BOSS 枪的出弹点在 BOSS 的世界坐标（`descriptor->position = worldPosition + shootOffset`）；
---      子 context 跑在根之后、而 UpdateMovement 又在 RunEcl 之后 ⇒ 用的是**上一帧末**的坐标。
---      ★ `ins_51 JMP_FLOAT_GE` / `ins_5 JUMP_DEC` 的位移操作数是**相对字节偏移**
---        （EclRunLow.inl:239-243、:234-243 用 RawInt 直接加），反汇编里已还原成目标指令号。
---      ★ Sub102 的 `ins_97 SHOOT_FAN` 只发 1 发、瞄准靠 `lf0 = AIM_TO_PL`（#3 每轮重设）。
---  · 占位贴图：人形 = "servant"、弹 = ball_small / ball_mid（全部实现完再统一换素材）。
---  ★ 人形按本文件惯例**不给判定**（原作 24×24 判定、life 13500）：它是背景装饰性的弹源，
---    移植版只保它的位置、出弹与轨迹（`DISABLE_INTERACTION_FLAGS 16` = ALLOW_OFFSCREEN
---    ⇒ 出屏不回收，所以 bound = false）。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x − 192、y' = 224 − y、角度整体取反。
local function scr_x(x) return x - 192 end
local function scr_y(y) return 224 - y end

---自机方向（我们坐标下的弧度；直接能当出弹角 / 记录里的加速方向用）。
local function aim_our(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---`ins_64 MOVE_TO(time, easing, x, y)`（EclHelpers.cpp:59-87 ConfigureRelativeMotion）：
---delta = 目标 − 当前坐标、origin = 当前位置；之后每帧 position = origin + delta·progress
---（EnemyManager.cpp:80-121 的 INTERPOLATED 分支；easing 0 = ECL_EASING_LINEAR，EclManager.hpp:520）。
---返回 true = 这一帧正好落地（movementTimer 归零那一帧）。
local function move_step(mv, obj)
    mv.t = mv.t + 1
    if mv.t >= mv.n then
        obj.x, obj.y = mv.x0 + mv.dx, mv.y0 + mv.dy
        return true
    end
    local u = mv.t / mv.n
    obj.x = mv.x0 + mv.dx * u
    obj.y = mv.y0 + mv.dy * u
    return false
end

---★ delta / origin 都按**改写那一刻**的坐标重算（ConfigureRelativeMotion:61-72）：
---  第一腿还没走完就被第二腿改写时，人形是从「当时站的地方」重新出发的。
local function config_move(obj, n, th08x, th08y)
    local tx, ty = scr_x(th08x), scr_y(th08y)
    obj.fam_mv = {
        x0 = obj.x, y0 = obj.y, dx = tx - obj.x, dy = ty - obj.y, n = n, t = 0,
    }
end

---BOSS 落位：生成助手 Sub116 #28 的 `ins_63 SET_POSITION(192, 128)` ⇒ 我们 (0, 96)。
---（Sub116 #22 / #29 的 `ins_75 SET_MOVEMENT_BOUNDS(32, 48, 352, 128)` 把 BOSS 夹在
---  我们 x∈[−160,160]、y∈[96,176]；本卡 BOSS 不动 ⇒ 夹框用不上，记一笔备查。）
local BOSS_X, BOSS_Y = 0, 96

---Sub97 的节拍：`ins_64(110, 4, 192, 128)` 之后第一条指令的 time = 110。
local T_SPAWN = 110

---人形的出生点（TH08 口径）与色号（`ins_6 SET_INT li7`，SPAWN_ENEMY 拷给新敌机的那个 int）。
local FAM_SPAWN = {
    { x = 0,   y = 448, li7 = 6 },      -- (0, 448)  → 我们 (−192, −224)：左下角
    { x = 384, y = 0,   li7 = 2 },      -- (384, 0)  → 我们 (192, 224)：右上角
}

---Sub98（人形本体）的节拍。
local F98_LEG1 = 180                    -- `#12 ins_64(180, 0, exF0, exF1)`：第一条腿
local F98_LEG2 = 120                    -- `#18 ins_64(120, 0, exF0, exF1)`：第二条腿
local F98_SWITCH = 170                  -- `#18` 的指令 time（第一腿只剩 10 帧时改写）
local F98_LOOP = 280                    -- `#19 ins_4 JUMP 0 -> #8` 的指令 time ⇒ 循环 280 帧
local F98_INSET = 8                     -- `#17 FLOAT_ADD_ASSIGN lf0 8`（每换腿往里缩 8 px）

---Sub99（人形 0 号枪）：每 4 帧一发「站 60 帧再加速」的弹。
local S99_PERIOD, S99_LIMIT, S99_RESTART = 4, 30, 44
local S99_TYPE, S99_SPEED2, S99_FLAGS = 1, 0.5, 131602
local S99_WAIT, S99_VEC_N, S99_VEC_A = 60, 60, 0.0333333351   -- 1/30

---Sub100（人形 1 号枪）：每 30 帧一发**站着不动**的弹（flags 里没有 WAIT / VEC 位）。
local S100_PERIOD, S100_LIMIT, S100_RESTART = 30, 3000, 60
local S100_TYPE, S100_SPEED2, S100_FLAGS = 3, 0.5, 4610

---Sub101（BOSS 0 号枪）：t=900 起每 40 帧一圈 32 发。
local S101_T, S101_PERIOD = 900, 40
local S101_TYPE, S101_COLOR, S101_N1, S101_SPD2, S101_FLAGS = 2, 13, 32, 0.5, 514
local S101_SPD_MIN, S101_SPD_SPAN = 1.5, 0.5      -- `lf0 = rndUnit·0.5 + 1.5`

---Sub102（BOSS 1 号枪）：t=1800 起每 2 帧一发自机狙，30 发之后回 #2 重新瞄准。
local S102_T, S102_PERIOD, S102_BURST, S102_RESTART_T = 1800, 2, 30, 1832
local S102_TYPE, S102_COLOR, S102_SPD1, S102_SPD2, S102_FLAGS = 6, 2, 2.0, 0.5, 514

---子 context 的**迷你解释器**：`ins` 表按 ECL 的指令号索引（下标 = `#N`），
---每项 = { t = 指令的 time, act = function(owner, c) … end }。
---★ 调度语义照抄 EclRun.cpp:63-85：context time == 指令的 time 才执行；
---  `JUMP` / `JUMP_DEC` 把 time 直接拨走（EclRunLow.inl:239-243），拨到的那条**同一帧**接着跑
---  （所以下面是 while）；帧尾 time + 1（EclRun.cpp:188）。
---★ act 的返回值：无返回 = 正常执行（pc + 1）；返回 (新pc, 新time) = 跳转；
---  返回 'stop' = 本帧到此为止（二级计时器冻结，EclRun.cpp:60-65）。
local function run_ctx(ins, owner, c)
    while true do
        local i = ins[c.pc]
        if i == nil then return end     -- 指令表跑完（这张卡的子程序都不会 RETURN）
        if c.t ~= i.t then break end
        local npc, nt = i.act(owner, c)
        if npc == 'stop' then return end
        if npc then c.pc, c.t = npc, nt else c.pc = c.pc + 1 end
    end
    c.t = c.t + 1
end

---------------------------------------------------------------
---Sub98：人形本体。exF0 / exF1 = TH08 口径的「这一腿的目标点」（我们存在 fam_ex0/fam_ex1）。
---------------------------------------------------------------
local S98 = {
    ---#0..#3 = `ins_54 SET_MAIN_ANM 55` / `ins_77 SET_HITBOX 24 24` / `ins_80 DISABLE_INTERACTION_FLAGS 16`
    ---/ `ins_83 SET_FORM_EFFECT_ENABLED 1`（占位贴图与「不给判定、出屏不回收」都在 init 里落好）；
    ---#5/#6/#7 = `ins_7 SET_FLOAT exF1 selfY` / `ins_135 SET_CHILD_ECL(0, 99)` / `(1, 100)`。
    [0] = { t = 0, act = function() end },
    [1] = { t = 0, act = function() end },
    [2] = { t = 0, act = function() end },
    [3] = { t = 0, act = function() end },
    [4] = { t = 0, act = function(o)            -- `ins_7 SET_FLOAT exF0 selfX` / `exF1 selfY`
        o.fam_ex0, o.fam_ex1 = o.x + 192, 224 - o.y
    end },
    [5] = { t = 0, act = function() end },
    [6] = { t = 0, act = function() end },
    [7] = { t = 0, act = function() end },
    [8] = { t = 0, act = function(o)            -- `ins_51 JMP_FLOAT_GE exF1 224.0 -> #11`
        ---两条分支都落在 #12（#10 是 `JUMP 0 -> #12`）。
        if o.fam_ex1 >= 224 then o.fam_ex1 = o.fam_lf0 else o.fam_ex1 = 448 - o.fam_lf0 end
        return 12, 0
    end },
    [12] = { t = 0, act = function(o) config_move(o, F98_LEG1, o.fam_ex0, o.fam_ex1) end },
    [13] = { t = 0, act = function(o)           -- `ins_51 JMP_FLOAT_GE exF0 192.0 -> #16`
        if o.fam_ex0 >= 192 then o.fam_ex0 = o.fam_lf0 else o.fam_ex0 = 384 - o.fam_lf0 end
        return 17, 0
    end },
    [17] = { t = 0, act = function(o) o.fam_lf0 = o.fam_lf0 + F98_INSET end },
    [18] = { t = F98_SWITCH,
             act = function(o) config_move(o, F98_LEG2, o.fam_ex0, o.fam_ex1) end },
    [19] = { t = F98_LOOP, act = function() return 8, 0 end },   -- `ins_4 JUMP 0 -> #8`
}

---Sub99：0 号枪。`#2` 每轮重写记录 1（方向 = 当时的 AIM_TO_PL）、`#3` 出一发。
local S99 = {
    [0] = { t = 0, act = function() end },      -- `ins_111(0, WAIT, 0, 60, −1, −1, −1)`（init 里写好）
    [1] = { t = 0, act = function(o, c) c.xi0 = S99_LIMIT end },
    [2] = { t = 0, act = function(o)            -- `ins_111(1, VEC, 0, 60, −1, 1/30, AIM_TO_PL)`
        EX.set_record(o, 1, EX.K.VEC, 0, S99_VEC_N, -1, S99_VEC_A, aim_our(o.x, o.y))
    end },
    [3] = { t = 0, act = function(o)            -- `ins_96 SHOOT_FAN_AIMED(type1, col li7, speed 0)`
        EX.shoot(o, o.x, o.y, {
            op = 96, type = S99_TYPE, color = EX.color(o.fam_li7),
            count1 = 1, count2 = 1, speed1 = 0, speed2 = S99_SPEED2,
            angle = 0, step = 0, flags = S99_FLAGS,
        })
    end },
    [4] = { t = S99_PERIOD, act = function(o, c)    -- `ins_5 JUMP_DEC 0 -> #2 xi0`
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end           -- 减到 0 就落到 #5（JUMP_DEC 的 advance 分支）
        return 2, 0
    end },
    [5] = { t = S99_RESTART, act = function() return 1, 0 end },   -- `ins_4 JUMP 0 -> #1`
}

---Sub100：1 号枪（弹的 flags 不带 WAIT / VEC ⇒ 出生后就停在那儿）。
local S100 = {
    [0] = { t = 0, act = function(o, c) c.xi0 = S100_LIMIT end },
    [1] = { t = 0, act = function(o)            -- `ins_96 SHOOT_FAN_AIMED(type3, col li7, speed 0)`
        EX.shoot(o, o.x, o.y, {
            op = 96, type = S100_TYPE, color = EX.color(o.fam_li7),
            count1 = 1, count2 = 1, speed1 = 0, speed2 = S100_SPEED2,
            angle = 0, step = 0, flags = S100_FLAGS,
        })
    end },
    [2] = { t = S100_PERIOD, act = function(o, c)   -- `ins_5 JUMP_DEC 0 -> #1 xi0`
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end           -- 落到 #3
        return 1, 0
    end },
    [3] = { t = S100_RESTART, act = function() return 0, 0 end },  -- `ins_4 JUMP 0 -> #0`
}

---Sub101：BOSS 0 号枪（自己的 time 900 起；子 context 是根 t=110 挂上去的 ⇒ 实际在真帧 1010）。
local S101 = {
    [0] = { t = S101_T, act = function() end },     -- `op0`（跳转表占位）
    [1] = { t = S101_T, act = function() end },     -- `ins_52 CALL 39`（火花，纯观感）
    [2] = { t = S101_T, act = function(o, c) c.lf0 = ran:Float(0, 1) * S101_SPD_SPAN end },
    [3] = { t = S101_T, act = function(o, c) c.lf0 = c.lf0 + S101_SPD_MIN end },
    [4] = { t = S101_T, act = function(o, c)    -- `ins_99 SHOOT_CIRCLE(type2, col13, 32 发)`
        EX.shoot(o, o.x, o.y, {
            op = 99, type = S101_TYPE, color = EX.color(S101_COLOR),
            count1 = S101_N1, count2 = 1, speed1 = c.lf0, speed2 = S101_SPD2,
            angle = ran:Float(-PI, PI), step = 0, flags = S101_FLAGS,
        })
    end },
    [5] = { t = S101_T + S101_PERIOD, act = function() return 2, S101_T end },  -- `JUMP 900 -> #2`
}

---Sub102：BOSS 1 号枪（自己的 time 1800 起 ⇒ 实际在真帧 1910）。
local S102 = {
    [0] = { t = S102_T, act = function() end },     -- `op0`
    [1] = { t = S102_T, act = function() end },     -- `ins_52 CALL 39`
    [2] = { t = S102_T, act = function(o, c) c.xi0 = S102_BURST end },
    [3] = { t = S102_T, act = function(o, c) c.lf0 = aim_our(o.x, o.y) end },
    [4] = { t = S102_T, act = function(o, c)    -- `ins_97 SHOOT_FAN(type6, col2, 1 发, speed 2.0)`
        EX.shoot(o, o.x, o.y, {
            op = 97, type = S102_TYPE, color = EX.color(S102_COLOR),
            count1 = 1, count2 = 1, speed1 = S102_SPD1, speed2 = S102_SPD2,
            angle = c.lf0, step = 0, flags = S102_FLAGS,
        })
    end },
    [5] = { t = S102_T + S102_PERIOD, act = function(o, c)  -- `ins_5 JUMP_DEC 1800 -> #4 xi0`
        c.xi0 = c.xi0 - 1
        if c.xi0 <= 0 then return end           -- 落到 #6（t=1832）
        return 4, S102_T
    end },
    [6] = { t = S102_RESTART_T, act = function() return 2, S102_T end },  -- `JUMP 1800 -> #2`
}

---人形（Sub98 + 两把枪）。位置由两条 MOVE_TO 腿（见 S98）推着走。
local familiar = Class(object, {
    init = function(self, spec)
        self.x, self.y = scr_x(spec.x), scr_y(spec.y)
        self.fam_ex0, self.fam_ex1 = spec.x, spec.y   -- exF0 / exF1（TH08 口径）
        self.fam_lf0 = 0
        self.fam_li7 = spec.li7                       -- 出弹色号（枪里的 `col10007`）
        self.fam_mv = nil
        self.fam_main = { t = 0, pc = 0 }              -- Sub98 的 context
        self.fam_c0 = { t = 0, pc = 0, xi0 = 0 }       -- Sub99
        self.fam_c1 = { t = 0, pc = 0, xi0 = 0 }       -- Sub100
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false                  -- ★ 纯观感（原作 24×24 判定 + life 13500）
        self.navi = false
        self.bound = false                  -- `DISABLE_INTERACTION_FLAGS 16` = ALLOW_OFFSCREEN
        self.rot = 0
        self._blend = ""
        self._a = 255
        EX.clear_records(self)
        ---`Sub99 #0` 的记录 0（WAIT 60）写一次就够；记录 1 由 S99 #2 每 4 帧重写。
        EX.set_record(self, 0, EX.K.WAIT, 0, S99_WAIT, -1, -1, -1)
        EX.set_record(self, 1, EX.K.VEC, 0, S99_VEC_N, -1, S99_VEC_A, aim_our(self.x, self.y))
    end,
    frame = function(self)
        ---① 主 context（Sub98）：算目标点、改写两条腿的 MOVE_TO。
        run_ctx(S98, self, self.fam_main)
        ---② 0 号子 context（Sub99）开火 —— 用**上一帧末**的坐标（RunEcl 在 IntegrateVelocity 之前）。
        run_ctx(S99, self, self.fam_c0)
        ---③ 1 号子 context（Sub100）。
        run_ctx(S100, self, self.fam_c1)
        ---④ 最后才是 UpdateMovement（EclRun 末尾，EclRun.cpp:208）。
        if self.fam_mv and move_step(self.fam_mv, self) then self.fam_mv = nil end
    end,
})

---根 context 的事件表：key = 真帧号。
local ROOT = {
    [T_SPAWN] = function(o)
        local list = o.lw203_fams
        for i = #list, 1, -1 do
            if not IsValid(list[i]) then table.remove(list, i) end
        end
        for i = 1, #FAM_SPAWN do
            list[#list + 1] = New(familiar, FAM_SPAWN[i])
        end
        ---`ins_135 SET_CHILD_ECL(0, 101)` / `(1, 102)`：新建的 context 当帧就跑（time 从 0 起）。
        o.lw203_ctx.c0 = { t = 0, pc = 0, lf0 = 0 }
        o.lw203_ctx.c1 = { t = 0, pc = 0, lf0 = 0 }
    end,
}

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw203_ctx = { t = 0, c0 = nil, c1 = nil }
    owner.lw203_fams = {}
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    local c = owner.lw203_ctx
    if not c then return end
    local t = c.t
    ---① 根 context（Sub97）：t=110 放人形与两把枪，之后空转。
    local fn = ROOT[t]
    if fn then fn(owner) end
    ---② 0 / 1 号子 context（Sub101 / Sub102）跑在根之后。
    if c.c0 then run_ctx(S101, owner, c.c0) end
    if c.c1 then run_ctx(S102, owner, c.c1) end
    c.t = t + 1
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw203_ctx = nil
    if owner.lw203_fams then
        for i = #owner.lw203_fams, 1, -1 do
            if IsValid(owner.lw203_fams[i]) then object.RawDel(owner.lw203_fams[i]) end
            owner.lw203_fams[i] = nil
        end
    end
    owner.lw203_fams = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[203] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---卡 204「不灭之射击」（藤原妹红）
---  ecldata8sp.ecl：Sub103 = BOSS 根；Sub106 / Sub107 = 根自己的两种圆周波模板
---  （Sub106 的 16 波挤在**同一帧**、Sub107 一帧一波）；Sub104 / Sub105 = BOSS 的两条子
---  context（枪），各对 Sub108 / Sub109 连 CALL 16 次；Sub108 / Sub109 = 那两条枪的模板；
---  Sub39 = 公用火花（纯观感，跳过）。
---  内容：BOSS 从 (192,128) 下挪到 (192,192)（90 帧、easing 4 = OUT_QUADRATIC）；t=90 起
---  一波一波地放「圆周扩散」弹。子弹的 11 条 transform 记录（见 set_records）拼出这张卡的
---  招牌手感：出生 → 60 帧内刹停（停在原地）→ 停 xi1 帧 → 沿原方向加速 120 帧 → 掉头 180°
---  再加速 120 帧 → 停 xi2 帧 → 转 f5、以 5.0 飞走（1 号枪的记录 10 是 1.5）。
---  最后 272 帧里两条枪各出 16×16 波（每波 4 发 ⇒ 每轴 1024 发）。
---
---  ★ 时间轴用**真帧**（下面 ROOT 的 key），不是 ECL 的 time：原作的 CALL 会冻住 caller 的
---    time（EclRunLow.inl:416-423 的 CALL/RETURN 走 restart_context / low_select_next_context，
---    跳过帧尾那次 time++，见 EclRun.cpp:188）。CALL 39（火花）占 33 帧、CALL 106 占 2 帧、
---    CALL 107 占 17 帧，累计下来 t=90 的指令落在真帧 123、t=540 → 574、t=1000 → 1036 / 1069、
---    t=2280 → 2522 / 2555、t=3410 → 3846 / 3879 / 3912、t=3510 → 4012。
---    （帧号 = /tmp/sim.py 照 EclRun.cpp 的调度逐帧模拟出来的实测值。）
---    ★ 卡在真帧 4740 就被 LIST 的 79 秒收掉 —— 正好是 `#6 ins_134 SET_TIMER_CALLBACK(4740, …)`，
---      所以 `#246` 那条循环（真帧 10012）在本移植里永远走不到，只留一条空壳。
---
---  ★ 变量是「每个 context 一份」（EclOperandsInt.cpp:29-36 的 LOCAL_INT/FLOAT 取的是
---    ECL_CONTEXT->intVariables / floatVariables）：子程序看得见 caller 的 li0/li1/lf0/lf7/xi1/xi2
---    （CallSubOnEnemy:475-485 只换 currentInstr、不换变量；RETURN 时 PopEclContext:532-534
---    整块恢复 ⇒ 子程序里改的 lf0/lf1/lf2 不会漏回根），而 SET_CHILD_ECL 会把父的变量
---    **整块拷给新子 context**（EclRunHigh.inl:670-674）⇒ 两条枪带着出生那一刻的
---    li0/li1/lf7/lf6/xi1/xi2 出生（实测：0 号枪 lf7 = 6.0、1 号枪 lf7 = 1.0）。
---
---  ★ 角度：ECL 的角在我们的坐标系里整体取反（见文件头），所以模板里的 lf0/lf5/lf6 与
---    `ins_110 SET_SHOOT_OFFSET` 的 y 都按取反后的值写进下面的代码。
---  ★ 占位贴图：弹 = ball_small（type 2 / 6 都是小弹）；BOSS 用本体立绘。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---我们坐标下的自机方向（弧度）。★ player 只在函数体里取：顶层取会拿到 nil。
local function aim_our(x, y)
    return math.atan2(player.y - y, player.x - x)
end

---BOSS 落位：生成助手 Sub116 `#28 ins_63 SET_POSITION(192, 128)` ⇒ 我们 (0, 96)；
---`#0 ins_76 DISABLE_MOVEMENT_BOUNDS` 把 Sub116 设的夹框关掉了 ⇒ 本卡全程不夹位置。
local BOSS_X, BOSS_Y = 0, 96
local MOVE_N = 90                       -- `#10 ins_64 MOVE_TO(90, 4, 192, 192)`
local BOSS_END_Y = 32                   -- scr_y(192) = 224 − 192

---圆周波模板（Sub106..Sub109）的常量。
local SHOT_FLAGS = 0x0a3252             -- FAST|VEC|REL|SPAWN_SND|NO_CANCEL|CULL|WAIT
local SPD2 = 0.5                        -- count2 = 1 ⇒ 进不了算式，照抄原值
local A_INIT, A_STEP = 0.02583333, 0.003229167
local N_WAVES = 16                      -- 一次 CALL 106/107/108/109 = 16 波
local CULL_DELAY = 500                  -- 记录 0（`#3`）：出屏后还有 500 帧宽限
local VEC_FRAMES, VEC_ANGLE = 120, -999.9   -- 记录 4/6（`#17/#18`）：VEC 用弹自己的角度
local REL_STOP = 60                     -- 记录 1（`#4`）：60 帧内速度线性掉到 0
local REL_TURN = 1                      -- 记录 5/7/10：1 帧就掉头
local TURN_180 = PI                     -- 记录 5 的相对掉头角（我们这边 −π ≡ π）
local SND_A, SND_B = 16, 15             -- 记录 3/9（`#6/#13`）：PLAY_SOUND（移植版不放）

---RANDOM_ANGLE = GetRandomF32InRange(2π) − π（EclOperandsFloat.cpp:56）；
---角度取反后 Sub106/107/109 的 `lf5 = RANDOM_ANGLE/5 + π`、Sub108 的 `lf5 = RANDOM_ANGLE/128`
---在我们这边就是同分布的随机（均匀随机取负还是均匀随机，±π 差 2π 等价）。
local function f5_turn() return -(ran:Float(-PI, PI) / 5 + PI) end
local function f5_small() return -(ran:Float(-PI, PI) / 128) end

---11 条 bullet transform 记录（= Sub106 `#3..#14` + `#17/#18` 的 ins_111；Sub107/108/109
---同构，只是 payload 的数值不同）。槽号照抄 ECL 的 0 基编号（EX.set_record 内部存 slot+1）。
---f5 = 记录 10 的相对掉头角（已取反）、rel_spd = 掉头后的速度。
local function set_records(o, xi1, xi2, a1, a2, f5, rel_spd)
    EX.set_record(o, 0, EX.K.CULL, 0, CULL_DELAY, -1, -1, -1)
    EX.set_record(o, 1, EX.K.REL, 0, REL_STOP, 1, 0, 0)
    EX.set_record(o, 2, EX.K.WAIT, 0, xi1, -1, -1, -1)
    EX.set_record(o, 3, EX.K.SND, 0, SND_A, -1, -1, -1)
    EX.set_record(o, 4, EX.K.VEC, 0, VEC_FRAMES, -1, a1, VEC_ANGLE)
    EX.set_record(o, 5, EX.K.REL, 0, REL_TURN, 1, TURN_180, 0)
    EX.set_record(o, 6, EX.K.VEC, 0, VEC_FRAMES, -1, a2, VEC_ANGLE)
    EX.set_record(o, 7, EX.K.REL, 0, REL_TURN, 1, 0, 0)
    EX.set_record(o, 8, EX.K.WAIT, 0, xi2, -1, -1, -1)
    EX.set_record(o, 9, EX.K.SND, 0, SND_B, -1, -1, -1)
    EX.set_record(o, 10, EX.K.REL, 0, REL_TURN, 1, f5, rel_spd)
end

---一串圆周波的状态：v = 参数表、k = 已出的波数、a1/a2 = 当前的 lf1/lf2（子程序里
---「先用后改」）、f5 = 记录 10 当前的角（Sub108/109 每波重掷：`#13` / `#34` 在循环体里）。
---出弹点 = BOSS 位置 + 偏移（偏移已经是**我们坐标**的值，调用处的注释给出 ECL 的原值）。
local function new_volley(o, t)
    local s = { v = t, k = 0, a1 = A_INIT, a2 = A_INIT, x = o.x + t.ox, y = o.y + t.oy }
    s.f5 = t.f5_fn and t.f5_fn() or t.f5
    return s
end

---一波 = 模板里的一次 `ins_99 SHOOT_CIRCLE`。
local function fire_wave(o, s, ang)
    local v = s.v
    set_records(o, v.xi1, v.xi2, s.a1, s.a2, s.f5, v.rel_spd)
    EX.shoot(o, s.x, s.y, {
        op = 99, type = v.type, color = EX.color(v.col),
        count1 = v.n1, count2 = 1, speed1 = v.spd, speed2 = SPD2,
        angle = ang, step = 0, flags = SHOT_FLAGS,
    })
end

---出下一波。角度：模板里 lf0 每波 += lf6（`#21` / `#31`），我们这边取反 ⇒ ang + k·da。
---lf1/lf2 前 8 波每波 −A_STEP、后 8 波每波 +A_STEP（Sub106 `#23/#24` 与 `#33/#34`；
---Sub107/108/109 同构 —— 两条 VEC 加速度因此是「先收后放」）。
local function volley_next(o, s)
    if s.k >= N_WAVES then return end
    fire_wave(o, s, s.v.ang + s.k * s.v.da)
    local d = s.k < 8 and -A_STEP or A_STEP
    s.a1, s.a2 = s.a1 + d, s.a2 + d
    if s.v.f5_fn then s.f5 = s.v.f5_fn() end
    s.k = s.k + 1
end

---`CALL 106`：Sub106 的指令 time 全是 0 ⇒ 两个 8 次循环在**同一帧**里跑完，16 波一起出。
local function call106(o, s)
    while s.k < N_WAVES do volley_next(o, s) end
end

---枪（Sub105 → 16×CALL 109、Sub104 → 16×CALL 108）的一帧。
---每次 CALL 的最后一帧是 RETURN（原作那次 time++ 被跳过）⇒ 实测 17 帧一轮：16 帧出波 + 1 帧空。
---返回 true = 16 次 CALL 跑完（Sub105/104 自己 RETURN，这个子 context 被收掉）。
local function gun_tick(o, g)
    if g.gap then
        g.gap = false
        g.calls = g.calls - 1
        if g.calls <= 0 then return true end
        g.s = nil                       -- 下一条 CALL：子程序里 lf1/lf2/lf0 从初值重来
        return false
    end
    if g.s == nil then g.s = new_volley(o, g.t) end
    volley_next(o, g.s)
    if g.s.k >= N_WAVES then g.gap = true end
    return false
end

---两条枪的参数（其余从根的变量整块拷来，见 ROOT 里 SET_CHILD_ECL 的注释）。
---出弹参数（lf7 / li0 / xi1 / xi2 / li1）全是 SET_CHILD_ECL 那一刻从根拷过来的值：
---0 号枪（Sub105 → Sub109）：弹种 6、色号 li0 = 6、n1 = li1/16 = 64/16 = 4、速度 lf7 = 6.0、
---  xi1 = 10、xi2 = 50、lf6 = 2π/64；记录 10 的角 = RANDOM_ANGLE/5 + π、速度 **0.5**
---  （Sub109 `#14 ins_111 10 64 0 1 1 lf5 0.5`）。
---1 号枪（Sub104 → Sub108）：色号 li0 = 2、速度 lf7 = 1.0、xi1 = 60、xi2 = 50、n1 = 4、
---  lf6 = 2π/64；记录 10 的角 = RANDOM_ANGLE/128、速度 **1.5**（Sub108 `#13`）。
---★ 别把 Sub109 `#10` 里那个 5.0 当成速度 —— 那是 `lf5 = RANDOM_ANGLE / 5.0` 的**除数**，
---  记录 10 的速度在 `#14`，是 0.5（踩过：照抄成 5.0 会让两条枪的末段飞得太快）。
local GUN0 = {
    type = 6, col = 6, n1 = 4, spd = 6.0, xi1 = 10, xi2 = 50,
    ---★ 起始角：`#229 ins_105 SET_FLOAT lf0 = 0`（真帧 3912 出生前摆好）⇒ 我们 ang = 0。
    ang = 0, da = -2 * PI / 64, f5_fn = f5_turn, rel_spd = 0.5, ox = 0, oy = 0,
}
local GUN1 = {
    type = 6, col = 2, n1 = 4, spd = 1.0, xi1 = 60, xi2 = 50,
    ---★ 起始角：`#238 ins_105 SET_FLOAT lf0 = 0`（真帧 3912 摆好、4012 出生）⇒ ang = 0。
    ang = 0, da = -2 * PI / 64, f5_fn = f5_small, rel_spd = 1.5, ox = 0, oy = 0,
}

---根 context（Sub103）的事件表：key = **真帧**（见卡片注释），`#N` = Sub103 的指令号。
local ROOT = {
    ---真帧 0 = t=0 的 `#0..#12`：初始化 + `#10 ins_64 MOVE_TO(90, 4, 192, 192)`。
    ---（`#2 KILL_ALL_NON_BOSS`、`#3` 关音效、`#4` 入场无敌、`#6` 超时 4740 帧、
    ---  `#11 ins_12 START_SPELL`、`#12 ins_155 SET_TIMEOUT_SPELL 1`。）
    [0] = function(o, c)
        c.mv = { t = 0, n = MOVE_N, x0 = o.x, y0 = o.y,
                 dx = BOSS_X - o.x, dy = BOSS_END_Y - o.y }
    end,

    ---真帧 90 = t=90 的 `#13..#21`：开判定（`ins_81 ENABLE_INTERACTION_FLAGS 4`）、
    ---`ins_160 SET_DAMAGE_REDUCTION_TIMER 420`、`ins_183 SET_TIMER_PAUSED 1`、换 EXTRA 图层、
    ---`#21 CALL 39`（火花，跳过）。移植版的伤害走 boss_system ⇒ 这里什么都不做
    ---（CALL 39 的那 33 帧已经算进后面的真帧里）。
    [90] = function() end,

    ---真帧 123 = t=90 的 `#22..#28`：li1=160、lf0=π/2、lf7=5.0、li0=6、xi1=60、xi2=10
    ---→ `#28 CALL 106`（同一帧 16 波 × 10 发 = 160 发，整圆朝外）。
    [123] = function(o)
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 10, spd = 5.0, xi1 = 60, xi2 = 10,
            ang = -PI / 2, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,

    ---真帧 574 = t=540 的 `#29..#36`：lf0 = RANDOM_ANGLE、li1=160、lf7=5.0、xi1=60、xi2=70；
    ---`#34 POLAR_TO_CARTESIAN(exF0, exF1, RANDOM_ANGLE, 8.0)` + `#35 SET_SHOOT_OFFSET`
    ---⇒ 出弹点离 BOSS 8 px、方向随机（`#34` 的 RANDOM_ANGLE 与 `#29` 是两次独立的掷）。
    [574] = function(o, c)
        local a = ran:Float(-PI, PI)                        -- `#29 lf0 = RANDOM_ANGLE`
        local b = ran:Float(-PI, PI)                        -- `#34` 的 RANDOM_ANGLE
        c.lf0 = a
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 10, spd = 5.0, xi1 = 60, xi2 = 70,
            ang = a, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = 8 * math.cos(b), oy = 8 * math.sin(b),
        }))
    end,

    ---真帧 635 = t=600 的 `#37..#44`：`#37 lf0 += π/10`（取反后我们这边减）、lf7=3.0、
    ---xi2=10、li0=2；`#42` 的随机偏移半径是 12（`#35` 的 8 px 换成 12 px）。
    [635] = function(o, c)
        c.lf0 = c.lf0 - 0.3141593                           -- `#37 FLOAT_ADD_ASSIGN lf0 π/10`
        local b = ran:Float(-PI, PI)
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 10, spd = 3.0, xi1 = 60, xi2 = 10,
            ang = c.lf0, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = 12 * math.cos(b), oy = 12 * math.sin(b),
        }))
    end,

    ---真帧 1036 = t=1000 的 `#45..#47`：lf0 = AIM_TO_PL、li1 = 112、`#47 CALL 39`（跳过）。
    ---★ lf0 是在**这一帧**算的、真帧 1069 的那一波用它（原作也是先算后用）。
    [1036] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
    end,

    ---真帧 1069 = t=1000 的 `#48..#52`：`#48 SET_SHOOT_OFFSET(-60, 60)` → 我们 (−60, −60)、
    ---lf7=4.0、xi1=60、xi2=70；li0/li1 沿用（li0 = 2、li1 = 112 ⇒ n1 = 7）。
    [1069] = function(o, c)
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 7, spd = 4.0, xi1 = 60, xi2 = 70,
            ang = c.lf0, da = -2 * PI / 112, f5 = f5_turn(), rel_spd = 5.0,
            ox = -60, oy = -60,
        }))
    end,

    ---真帧 1100 = t=1030 的 `#53..#59`：lf0 = AIM_TO_PL（重算）、出弹点 (60, 60) → 我们 (60, −60)、
    ---xi2=40、li0=4（lf7 / xi1 / li1 沿用 4.0 / 60 / 112）。
    [1100] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
        call106(o, new_volley(o, {
            type = 2, col = 4, n1 = 7, spd = 4.0, xi1 = 60, xi2 = 40,
            ang = c.lf0, da = -2 * PI / 112, f5 = f5_turn(), rel_spd = 5.0,
            ox = 60, oy = -60,
        }))
    end,

    ---真帧 1131 = t=1060 的 `#60..#66`：lf0 = AIM_TO_PL（重算）、出弹点 (0, −60) → 我们 (0, 60)、
    ---xi2=10、li0=6。
    [1131] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 7, spd = 4.0, xi1 = 60, xi2 = 10,
            ang = c.lf0, da = -2 * PI / 112, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 60,
        }))
    end,

    ---真帧 1532 = t=1460 的 `#67..#70`：lf0 = AIM_TO_PL、li0=2、li1=160、`#70 CALL 39`（跳过）。
    [1532] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
    end,

    ---真帧 1565 = t=1460 的 `#71..#75`：出弹点 (−128, 192) → 我们 (−128, −192)、lf7=2.7、
    ---xi1=60、xi2=1。（lf0 用真帧 1532 算好的那个 AIM_TO_PL。）
    [1565] = function(o, c)
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 10, spd = 2.7, xi1 = 60, xi2 = 1,
            ang = c.lf0, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = -128, oy = -192,
        }))
    end,

    ---真帧 1666 = t=1560 的 `#76..#77`：lf0 = AIM_TO_PL、`#77 CALL 39`（跳过）。
    [1666] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
    end,

    ---真帧 1699 = t=1560 的 `#78..#83`：出弹点 (128, 128) → 我们 (128, −128)、xi2=1、li0=6。
    [1699] = function(o, c)
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 10, spd = 2.7, xi1 = 60, xi2 = 1,
            ang = c.lf0, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = 128, oy = -128,
        }))
    end,

    ---真帧 1800 = t=1660 的 `#84..#85`：lf0 = AIM_TO_PL、`#85 CALL 39`（跳过）。
    [1800] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
    end,

    ---真帧 1833 = t=1660 的 `#86..#91`：出弹点 (−128, 64) → 我们 (−128, −64)、xi2=1、li0=2。
    [1833] = function(o, c)
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 10, spd = 2.7, xi1 = 60, xi2 = 1,
            ang = c.lf0, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = -128, oy = -64,
        }))
    end,

    ---真帧 1934 = t=1760 的 `#92..#93`：`#92 lf0 += π/40`（我们这边减）、`#93 CALL 39`（跳过）。
    [1934] = function(o, c)
        c.lf0 = c.lf0 - 0.07853982
    end,

    ---真帧 1967 = t=1760 的 `#94..#99`：出弹点 (128, 0)、xi2=1、li0=6。
    [1967] = function(o, c)
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 10, spd = 2.7, xi1 = 60, xi2 = 1,
            ang = c.lf0, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = 128, oy = 0,
        }))
    end,

    ---真帧 2068 = t=1860 的 `#100..#101`：lf0 = AIM_TO_PL、`#101 CALL 39`（跳过）。
    [2068] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
    end,

    ---真帧 2101 = t=1860 的 `#102..#107`：出弹点 (−128, −64) → 我们 (−128, 64)、lf7=2.5、
    ---xi2=1、li0=2。
    [2101] = function(o, c)
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 10, spd = 2.5, xi1 = 60, xi2 = 1,
            ang = c.lf0, da = -2 * PI / 160, f5 = f5_turn(), rel_spd = 5.0,
            ox = -128, oy = 64,
        }))
    end,

    ---真帧 2522 = t=2280 的 `#108..#110`：lf0 = π/2（我们 −π/2）、li1=144、`#110 CALL 39`。
    [2522] = function(o, c)
        c.lf0 = -PI / 2
    end,

    ---真帧 2555 = t=2280 的 `#111..#116`：lf0 = AIM_TO_PL（重算）、出弹点 (0,0)、lf7=6.0、
    ---xi1=10、xi2=50；li0/li1 沿用（li0 = 2、li1 = 144 ⇒ n1 = 9）。
    [2555] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 9, spd = 6.0, xi1 = 10, xi2 = 50,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,

    ---真帧 2566..2599 = t=2290..2320 的 `#117..#141`：五连波，每波 `lf0 += π/40`（我们减）、
    ---lf7 6.0 → 5.2 → 4.6 → 3.8 → 3.0（xi2 50 → 40 → 30 → 20 → 10），色号 4/6 交替。
    [2566] = function(o, c)
        c.lf0 = c.lf0 - 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 4, n1 = 9, spd = 5.2, xi1 = 10, xi2 = 40,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,
    [2577] = function(o, c)
        c.lf0 = c.lf0 - 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 9, spd = 4.6, xi1 = 10, xi2 = 30,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,
    [2588] = function(o, c)
        c.lf0 = c.lf0 - 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 4, n1 = 9, spd = 3.8, xi1 = 10, xi2 = 20,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,
    [2599] = function(o, c)
        c.lf0 = c.lf0 - 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 9, spd = 3.0, xi1 = 10, xi2 = 10,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,

    ---真帧 2950 = t=2670 的 `#142..#144`：lf0 = π/2（我们 −π/2）、li1 = 144、`#144 CALL 39`。
    [2950] = function(o, c)
        c.lf0 = -PI / 2
    end,

    ---真帧 2983 = t=2670 的 `#145..#151`：lf0 = AIM_TO_PL、出弹点 (0,0)、lf7=6.0、xi1=10、
    ---xi2=50、li0=6。
    [2983] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
        call106(o, new_volley(o, {
            type = 2, col = 6, n1 = 9, spd = 6.0, xi1 = 10, xi2 = 50,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,

    ---真帧 2994..3027 = t=2680..2710 的 `#152..#176`：与上一组镜像的一条五连波
    ---（`#152/#159/#165/#171` 是 `FLOAT_SUB_ASSIGN lf0` ⇒ 我们这边**加** π/40）。
    [2994] = function(o, c)
        c.lf0 = c.lf0 + 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 4, n1 = 9, spd = 5.2, xi1 = 10, xi2 = 40,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,
    [3005] = function(o, c)
        c.lf0 = c.lf0 + 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 9, spd = 4.6, xi1 = 10, xi2 = 30,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,
    [3016] = function(o, c)
        c.lf0 = c.lf0 + 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 4, n1 = 9, spd = 3.8, xi1 = 10, xi2 = 20,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,
    [3027] = function(o, c)
        c.lf0 = c.lf0 + 0.07853982
        call106(o, new_volley(o, {
            type = 2, col = 2, n1 = 9, spd = 3.0, xi1 = 10, xi2 = 10,
            ang = c.lf0, da = -2 * PI / 144, f5 = f5_turn(), rel_spd = 5.0,
            ox = 0, oy = 0,
        }))
    end,

    ---真帧 3358 = t=3040 的 `#177..#179`：lf0 = AIM_TO_PL、li1 = 96、`#179 CALL 39`（跳过）。
    [3358] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
    end,

    ---真帧 3391 = t=3040 的 `#180..#187`：lf0 = AIM_TO_PL（重算）、`#181 SET_SHOOT_OFFSET` 的
    ---`POLAR_TO_CARTESIAN(exF0, exF1, AIM_TO_PL, 32.0)` ⇒ 出弹点在**朝自机方向 32 px**；
    ---lf7=5.0、xi1=10、xi2=50、li0=10、`#186 lf6 = 2π/96` → `CALL 107`（16 帧、一帧一波）。
    [3391] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
        local a = c.lf0
        local off = 32
        c.v107 = new_volley(o, {
            type = 2, col = 10, n1 = 6, spd = 5.0, xi1 = 10, xi2 = 50,
            ang = a, da = -2 * PI / 96, f5 = f5_turn(), rel_spd = 5.0,
            ox = off * math.cos(a), oy = off * math.sin(a),
        })
    end,

    ---真帧 3418 = t=3050 的 `#188..#195`：`#188 lf0 += 0`（不动）、出弹点
    ---(18.80913, −25.88854) → 我们 (18.80913, 25.88854)、xi2=40、li0=10、
    ---`#194 lf6 = −2π/96`（取反 ⇒ 我们 +2π/96）。
    [3418] = function(o, c)
        c.v107 = new_volley(o, {
            type = 2, col = 10, n1 = 6, spd = 5.0, xi1 = 10, xi2 = 40,
            ang = c.lf0, da = 2 * PI / 96, f5 = f5_turn(), rel_spd = 5.0,
            ox = 18.80913, oy = 25.88854,
        })
    end,

    ---真帧 3445 = t=3060 的 `#196..#202`：出弹点 (−30.43381, 9.888544) → 我们
    ---(−30.43381, −9.888544)、xi2=30、li0=10、lf6 = −2π/96（我们 +2π/96）。
    [3445] = function(o, c)
        c.v107 = new_volley(o, {
            type = 2, col = 10, n1 = 6, spd = 5.0, xi1 = 10, xi2 = 30,
            ang = c.lf0, da = 2 * PI / 96, f5 = f5_turn(), rel_spd = 5.0,
            ox = -30.43381, oy = -9.888544,
        })
    end,

    ---真帧 3472 = t=3070 的 `#203..#209`：出弹点 (30.43381, 9.888544) → 我们
    ---(30.43381, −9.888544)、xi2=20、li0=10、lf6 = 2π/96（我们 −2π/96）。
    [3472] = function(o, c)
        c.v107 = new_volley(o, {
            type = 2, col = 10, n1 = 6, spd = 5.0, xi1 = 10, xi2 = 20,
            ang = c.lf0, da = -2 * PI / 96, f5 = f5_turn(), rel_spd = 5.0,
            ox = 30.43381, oy = -9.888544,
        })
    end,

    ---真帧 3499 = t=3080 的 `#210..#216`：出弹点 (−18.80913, −25.88854) → 我们
    ---(−18.80913, 25.88854)、xi2=10、li0=10、lf6 = −2π/96（我们 +2π/96）。
    [3499] = function(o, c)
        c.v107 = new_volley(o, {
            type = 2, col = 10, n1 = 6, spd = 5.0, xi1 = 10, xi2 = 10,
            ang = c.lf0, da = 2 * PI / 96, f5 = f5_turn(), rel_spd = 5.0,
            ox = -18.80913, oy = 25.88854,
        })
    end,

    ---真帧 3846 = t=3410 的 `#217..#219`：lf0 = AIM_TO_PL、li1 = 96、`#219 CALL 39`（跳过）。
    [3846] = function(o, c)
        c.lf0 = aim_our(o.x, o.y)
    end,

    ---真帧 3879 = t=3410 的 `#220..#228`：出弹点 (0,0)、lf7=5.0、xi1=10、xi2=50、li0=10、
    ---`#226 lf6 = 2π/96`、`#227 li1 = 64`、`#228 CALL 39`（火花，跳过）。
    ---★ 这一批**不出弹** —— 它是给 0 号枪摆参数；`#227` 把 li1 改成 64 之后 `#235` 会重算
    ---  lf6 = 2π/64，所以枪用的是 2π/64（不是这里的 2π/96）。
    [3879] = function() end,

    ---真帧 3912 = t=3410 的 `#229..#244`：0 号枪出生 + 给 1 号枪摆参数。
    ---★ `#236 SET_CHILD_ECL(0, 105)` 会把根的变量整块拷给新子 context（EclRunHigh.inl:670-674）
    ---  ⇒ 0 号枪带着 li0 = 6（`#234`）、li1 = 64（`#227`）、lf7 = 6.0（`#231`）、
    ---  lf6 = 2π/64（`#235`）、xi1 = 10（`#232`）、xi2 = 50（`#233`）出生。
    ---  1 号枪的参数摆在这之后（li1 = 64、lf0 = 0、lf7 = 1.0、xi1 = 60、xi2 = 50、li0 = 2），
    ---  到真帧 4012 才出生。
    [3912] = function(o, c)
        c.gun0 = { t = GUN0, calls = 16, gap = false, s = nil }
    end,

    ---真帧 4012 = t=3510 的 `#245 SET_CHILD_ECL(1, 104)`：1 号枪出生。
    [4012] = function(o, c)
        c.gun1 = { t = GUN1, calls = 16, gap = false, s = nil }
    end,

    ---真帧 10012 = t=9510 的 `#246 ins_4 JUMP 90 -> #22`：整张卡循环（周期 9420 帧）。
    ---★ 卡在真帧 4740 就被 LIST 的 79 秒收掉 ⇒ 这条 JUMP 走不到（原作靠它把这张卡拉到
    ---  157 秒，`#6` 的 SET_TIMER_CALLBACK(4740) 才是本卡的实际时长）。
    [10012] = function() end,
}

local function card_init(owner)
    EX.clear_records(owner)
    EX.pool_clear()
    owner.lw204 = { t = 0, mv = nil, lf0 = 0, v107 = nil, gun0 = nil, gun1 = nil }
    owner.x, owner.y = BOSS_X, BOSS_Y
end

local function card_frame(owner)
    local c = owner.lw204
    if not c then return end
    ---① 进场位移（`#10 ins_64(90, 4, 192, 192)`：easing 4 = OUT_QUADRATIC，
    ---   progress = 1 − (1−u)²，EnemyManager.cpp:93-97）。
    local mv = c.mv
    if mv then
        mv.t = mv.t + 1
        local u = mv.t >= mv.n and 1 or mv.t / mv.n
        local p = 1 - (1 - u) * (1 - u)
        owner.x = mv.x0 + mv.dx * p
        owner.y = mv.y0 + mv.dy * p
        if mv.t >= mv.n then c.mv = nil end
    end
    ---② 根 context（Sub103）的真帧事件。
    local fn = ROOT[c.t]
    if fn then fn(owner, c) end
    ---③ `CALL 107` 的那 16 波：一帧一波（Sub107 的指令 time 是 0/1/2）。
    if c.v107 then
        volley_next(owner, c.v107)
        if c.v107.k >= N_WAVES then c.v107 = nil end
    end
    ---④ 两条枪（引擎里子 context 排在根之后：EclRun.cpp:188-208 的 low_select_next_context）。
    if c.gun0 and gun_tick(owner, c.gun0) then c.gun0 = nil end
    if c.gun1 and gun_tick(owner, c.gun1) then c.gun1 = nil end
    c.t = c.t + 1
end

local function card_del(owner)
    ---★ 帧计数器要清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw204 = nil
    EX.clear_records(owner)
    EX.pool_clear()
end

CARD[204] = {
    init = card_init,
    frame = card_frame,
    del = card_del,
}
end
---还没移植的卡：占位实现。实现一张就在上面的 CARD 表里登记一张
---（key = TH08 卡号 205..221）。
---------------------------------------------------------------
local function placeholder_init() end
local function placeholder_frame() end
local function placeholder_del() end

---------------------------------------------------------------
---注册。跟旧版一样：SCBG 类、17 个角色、17 张卡，等级 29、卡 id 351..367。
---------------------------------------------------------------
do
local _SC_BG = _SC_BG
local TH08_bg = TH08_bg
local TH08_SC = _editor_class["TH08"] or {}
local TH07_SC = _editor_class["TH07"] or {}

class["SCBG1"] = Class(_SC_BG)
class["SCBG2"] = Class(_SC_BG)

---SCBG 的取自：多数是 TH08_SC["SCBG-LWn"]；灵梦/魔理沙用本文件自定义的
---SCBG1/SCBG2（TH08_SC 里没有她俩对应的 LW 背景），紫借 TH07 的 SCBG8。
local function scbg_of(key)
    if key == "SCBG1" or key == "SCBG2" then return class[key] end
    if key == "SCBG8" then return TH07_SC[key] end
    return TH08_SC[key]
end

---17 个角色。**顺序 = 组号 = 下面 LIST 的顺序**（第 k 条 = 组 k = boss id "ka"）。
---{角色名, 立绘, SCBG, 角色图名, 缩放}
local CHARS = {
    { "莉格露·奈特巴格",     "TH08_NEW_0", "SCBG-LW1",  "Nightbug" },
    { "米斯蒂娅·萝蕾拉",     "TH08_NEW_0", "SCBG-LW1",  "Lorelei" },
    { "上白泽慧音",          "TH08_NEW_0", "SCBG-LW3",  "Kamishirasawa" },
    { "铃仙·优昙华院·因幡",  "TH08_NEW_1", "SCBG-LW4",  "Reisen" },
    { "八意永琳",            "TH08_NEW_1", "SCBG-LW5",  "Yagokoro" },
    { "蓬莱山辉夜",          "TH08_NEW_1", "SCBG-LW6",  "Neet" },
    { "藤原妹红",            "TH08_NEW_1", "SCBG-LW6",  "Mokou" },
    { "因幡帝",              "TH08_NEW_2", "SCBG-LW8",  "Tewi" },
    { "上白泽慧音",          "TH08_NEW_2", "SCBG-LW9",  "Kamishirasawa2" },
    { "博丽灵梦",            "TH08_NEW_3", "SCBG1",     "Reimu" },
    { "雾雨魔理沙",          "TH08_NEW_3", "SCBG2",     "Marisa" },
    { "十六夜咲夜",          "TH08_NEW_3", "SCBG-LW10", "Sakuya" },
    { "魂魄妖梦",            "TH08_NEW_3", "SCBG-LW11", "Youmu", 0.6 },
    { "爱丽丝·玛格特洛依德", "TH08_NEW_3", "SCBG-LW12", "Alice" },
    { "蕾米莉亚·斯卡蕾特",   "TH08_NEW_3", "SCBG-LW13", "Remilia" },
    { "西行寺幽幽子",        "TH08_NEW_3", "SCBG-LW14", "Yuyuko" },
    { "八云紫",              "TH08_NEW_3", "SCBG8",     "Yukari" },
}

---{卡号, 中文卡名, 卡 id, 秒数[, 组号[, 血量]]}。
---  没有第 5 项时「组号 = 自己的序号」（= 一个角色一张 Last Word）；
---  有第 5 项就挂到指定的角色组上（Stage EX 的 191..204 挂到慧音组 3、妹红组 7）。
---秒数 = ins_134 的 threshold/60：5940/60=99、2220/60=37、2160/60=36、7860/60=131。
---★ EX 卡（带血量）是**普通符卡**，不是 Last Word 那种耐久卡：有 HP、能被击破、
---  超时算失败；Last Word 用 hp = 10000000 让血条永远打不掉（t1 = t2 = t3 ⇒ 伤害恒 0）。
local LIST = {
    { 205, "「季节外调的蝴蝶风暴」",   351,  99 },
    { 206, "「盲夜鸟」",               352,  99 },
    { 207, "「日出之国的天子」",       353,  99 },
    { 208, "「幻胧月睨」",             354,  99 },
    { 209, "「天网蛛网捕蝶之法」",     355,  99 },
    { 210, "「蓬莱之树海」",           356,  99 },
    { 211, "「不死鸟再诞」",           357,  99 },
    { 212, "「远古的欺骗者」",         358,  99 },
    { 213, "「无何有净化」",           359,  99 },
    { 214, "「梦想天生」",             360,  37 },
    { 215, "「炽热之星」",             361,  36 },
    { 216, "「紧缩世界」",             362,  99 },
    { 217, "「待宵反射卫星斩」",       363,  99 },
    { 218, "「格兰吉纽尔剧场的怪人」", 364,  99 },
    { 219, "「猩红命运」",             365,  99 },
    { 220, "「西行寺无余涅槃」",       366,  99 },
    { 221, "「深弹幕结界 -梦幻泡影-」", 367, 131 },

    ---------------------------------------------------------------
    ---Stage EX（ecldata8sp.ecl）的 14 张：慧音 191..193、妹红 194..204。
    ---全部挂进上面已有的角色组（组 3 = 上白泽慧音、组 7 = 藤原妹红），
    ---所以 boss.CreateGroup(3/7, level) 会先把该角色的 Last Word 打完、再逐张打这些。
    ---（组号的对应：CHARS[3] = 上白泽慧音、CHARS[7] = 藤原妹红，见上面 CHARS。）
    ---HP = Spellcard 表的 life：192/193 都是 1900、195/196 是 2200 …
    ---秒数 = 根子程序的 ins_134(threshold, …) / 60（下面每张卡的注释里都有出处）。
    { 191, "旧史「旧秘境史 -旧日秘史-」",         370, 60, 3, 1900 },
    { 192, "转世「一条归桥」",                   371, 60, 3, 1900 },
    { 193, "新史「新幻想史 -未来秘史-」",         372, 60, 3, 1900 },
    { 194, "时效「月之岩笠的诅咒」",             373, 60, 7, 2200 },
    { 195, "不死「火之鸟 -凤翼天翔-」",           374, 77, 7, 2200 },
    { 196, "藤原「灭罪寺院伤」",                 375, 62, 7, 2200 },
    { 197, "不死「徐福时空」",                   376, 90, 7, 2500 },
    { 198, "灭罪「正直者之死」",                 377, 70, 7, 2500 },
    { 199, "虚人「乌」",                         378, 70, 7, 3000 },
    { 200, "不灭「不死鸟之尾」",                 379, 70, 7, 3000 },
    { 201, "蓬莱「凯风快晴 -富士山火山-」",       380, 70, 7, 2500 },
    { 202, "「被不死鸟附身」",                   381, 77, 7, 6000 },
    { 203, "「蓬莱人形」",                       382, 90, 7, 6000 },
    { 204, "「不灭之射击」",                     383, 79, 7, 6000 },
}

---每张卡共用的 before：不打超时音、关掉 BOSS 的判定与血量条渲染。
---Last Word 全是耐久卡（t1 = t2 = t3，伤害恒 0），所以判定本来也没用。
local function lw_before(self)
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end

---组号 k 的 boss id = k.."a"：Define 和 card.add 必须用同一个 key。
---⚠ boss.Define 必须**先于** boss.card.add：add 会当场按 "<字母><关卡号>" 查 _editor_boss，
---  Define 晚一行就报「找不到 boss」（踩过）。**每个角色一个组**（旧版把 17 个全塞进
---  组 1 的 a..q，于是 boss.CreateGroup(1, level) 一次就把 17 个全建出来了）。
for k, c in ipairs(CHARS) do
    boss.Define(k .. "a", c[1], c[2], TH08_bg, { 0, 420 },
            scbg_of(c[3]), c[4], 29, c[5])
end

for k, e in ipairs(LIST) do
    local cardnum, name, id, seconds = e[1], e[2], e[3], e[4]
    local group = e[5] or k              -- 第 5 项 = 挂到哪个角色组（EX 卡才给）
    local hp = e[6]                      -- 第 6 项 = 血量（有它就说明是能打掉的普通符卡）
    local band = group .. "a"
    local card
    if hp then
        ---Stage EX 的普通符卡：`card.New(name, t1, t2, t3, hp)`，t1/t2 = 1 秒
        ---（跟本文件其它 TH08 卡 th08-boss1.lua:22 一样的写法：1 秒无敌、1 秒防御）。
        card = boss.card.New(name, 1, 1, seconds, hp)
    else
        ---Last Word：t1 = t2 = t3 ⇒ boss_system.lua:161 判成耐久卡、伤害恒 0；
        ---hp 给一个打不掉的大数（boss_system.lua:126 用它决定血条长度）。
        card = boss.card.New(name, seconds, seconds, seconds, 10000000)
    end
    ---boss.card.add(sc_group, level, CardName, data_id)：level 29 = TH31 的关卡号。
    boss.card.add({ { card, band } }, 29, name, id)
    local impl = CARD[cardnum]
    if hp then
        ---EX 卡：不动 colli（要靠判定吃伤害），只把超时音关掉。
        card.before = function(self)
            if impl and impl.before then
                impl.before(self)
            end
        end
    else
        card.before = function(self)
            lw_before(self)
            if impl and impl.before then
                impl.before(self)
            end
        end
    end
    ---⚠ 只能**逐个** `if impl.xxx` 覆盖：`boss.card.New`（boss_card.lua:66）给的默认值
    ---  是五个空函数，写 `card.render = impl.render` 在 impl 没实现 render 时
    ---  会把它**覆盖成 nil**，下一帧 `boss_system.lua:197` 无条件调
    ---  `current_card.render(self.boss)` → `attempt to call field 'render' (a nil value)`（踩过）。
    if impl then
        if impl.init then card.init = impl.init end
        if impl.frame then card.frame = impl.frame end
        if impl.render then card.render = impl.render end
        if impl.del then card.del = impl.del end
    else
        ---TODO：这张卡还没移植（init/frame/del 走 boss_card.lua:66 的空函数）。
        card.init = placeholder_init
        card.frame = placeholder_frame
        card.del = placeholder_del
    end
end

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
end
