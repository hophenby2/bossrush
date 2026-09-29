---=====================================
---TH33  文花帖（TH095）第 7 关 world08 + Stage EX —— 原作 15 张符卡
---
---本关把原作 world08 的 7 张符卡 + Stage EX 的 8 张符卡逐幕移植成一条 Boss Rush。
---world08 的 7 幕数据来源是
---th095/src/SceneSelect.cpp:138-145 的 TH095_SCENE 表（scoreIndex, 关卡组, 幕, ECL, BGM）：
---  71 ecl17_a 幽幽子 幽雅「死出の誘蛾灯」    75 ecl17_c 幽幽子 死符「醉人之生、死之梦幻」
---  72 ecl16_b 妖梦   密符「御大師様の秘鍵」  76 ecl16_d 妖梦   超人「飛翔役小角」
---  73 ecl17_b 幽幽子 蝶符「鳳蝶紋の死槍」    77 ecl17_d 幽幽子 「死蝶浮月」
---  74 ecl16_c 妖梦   行符「八千万枚護摩」
---（同表里的 scene 70 = ecl16_a 是**非符**、没有 ins_104 亮卡名，不在本关这 7 张里。）
---7 幕共用同一份场景资源（world08.std / enm16,17.anm / bgm th095_04.wav），所以两班人马
---共用 BGM 与背景：BGM = "TH07_1"（幽雅に咲かせ、墨染の桜）、背景 = TH095_bg。
---每个数值都标了它在反汇编里的出处：`/tmp/B_ecl16_{b,c,d}.txt` 与 `/tmp/B_ecl17_{a,b,c,d}.txt`
---是这次临时反汇编出来的（脚本 /tmp/p95b.py 不入库；数据在 `[th095] …/data/ecl1{6,7}_*.ecl`，
---换机器要重 dump 一遍）。各卡块里的「@地址」都指这几份 dump，改前先回去核对。
---
---Stage EX（scene group 10）的 8 幕在文件后半（"Stage EX —— 两件公共工具" 往下），
---数据来源是 th095/src/SceneSelect.cpp:165-172 的同一张 TH095_SCENE 表（scene 100..107）：
---  100 ecl22_a 芙兰 禁忌「フォービドゥンフルーツ」   101 ecl22_b 芙兰 禁忌「禁じられた遊び」
---  102 ecl23_a 紫   境符「色と空の境界」             103 ecl23_b 紫   境符「波と粒の境界」
---  104 ecl24_a 妹红 貴人「サンジェルマンの忠告」     105 ecl24_b 妹红 蓬莱「瑞江浦嶋子と五色の瑞亀」
---  106 ecl25_a 萃香 鬼気「濛々迷霧」                 107 ecl25_b 萃香 「百万鬼夜行」
---八张也是**自由选关**、共用场景资源（world05/06/09/10.std + enm22..25.anm + bgm th095_03.wav），
---所以四人共用 BGM = "TH09_5_1"（東の国の眠らない夜）、背景 = TH095_bg。
---每个数值都标了它在反汇编里的出处：`/tmp/E_ecl2{2,3,4,5}_{a,b}.txt`
---（脚本 /tmp/d95v2.py 不入库；数据在 `[th095] …/data/ecl2{2,3,4,5}_{a,b}.ecl`）。
---
---六个 boss 组怎么排
---  原作 15 幕全是**自由选关**、本来没有先后；这里按角色归成六个 boss 组
---  （AGENTS.md §8 与 th31.lua 的教训：**一个角色一个组**，boss.CreateGroup 一次建一组）：
---      world08：组 1 = 西行寺幽幽子：71 → 73 → 75 → 77（4 张）
---              组 2 = 魂魄妖梦：  72 → 74 → 76（3 张）
---      Stage EX：组 3 = 芙兰朵露：100 → 101（2 张）
---                组 4 = 八云紫：  102 → 103（2 张）
---                组 5 = 藤原妹红：104 → 105（2 张）
---                组 6 = 伊吹萃香：106 → 107（2 张）
---  main_stage.lua 的 TH33 里连着调 boss.CreateGroup(1..6, 31)，就会依次打完这六班的 15 张。
---  ★ 别把两个角色塞进同一个组的 a、b：CreateGroup 会把 a、b、c… 一次全建出来（两人同时上场）。
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
---  换算规则：角度取反（θ → −θ）。整圈/整扇一起取反**方向集合不变**
---  （{a + 2πk/n} 取反 = {−a + 2πk/n}），所以对称图案直接抽 [0,360) 就等价，
---  不必逐个取反；只有**逐发自机狙**那种「每发各朝一个方向」才必须取反。
---  本文件里每一处用到角度的地方都写了它属于哪一种。
---
---与原作的差异（15 张卡共有；Stage EX 若某一条的落点不同，写在那张卡自己的注释里）
---  1) 拍照关的相机 / 计分系统：**相机本身不实现** —— 本仓库有自己的拍照自机
---     射命丸文（THlib/player/aya/aya.lua:191 给 player 挂了 player.camera，快门由玩家
---     自己按）。原作那套 opcode —— ins_141（快门上限）、ins_143（拍照标记）、
---     ins_144（快门脉冲）、ins_149（分数倍率）、ins_114（卡计时）、ins_104/105
---     （亮卡名 / 收会话）、ins_150（装饰 ANM）—— 只保留**影响弹幕数值**的那一头：
---     卡里用 photo_index()（见文件中部）去读「本卡内**拍中本体**的张数」当
---     camera.photoIndex，快门音 / 上限 / 计分一概不做；卡名与计时交给符卡系统
---     （CARD_NAME / CARD_TIME）。
---     ★ 例外：拿到快门数之后**怎么算伤害**这一头按作者要求改了 —— 见差异 9。
---  2) 弹型：原作靠 g_PhotoBulletCollisionSizes（th095/src/BulletManager.cpp:118-122，
---     存的是**直径**、命中框取 ±size/2，见同文件 :1155）区分二十几种弹。本关按作者
---     指定把小玉换成 **butterfly（幽幽子系）与 water_drop（妖梦系）**两种贴图；
---     原作的大玉（type 17，直径 28 ⇒ 半径 14）用本仓库最大的一档 **ball_huge**。
---  3) 回收边界：原作是**弹心一越过场地边就回收**（PhotoBulletIsOutsidePlayfield，
---     th095/src/BulletManager.cpp:759-765，判据是「弹心 ± 半宽」出 384x448 的框），
---     而且全游戏共用 640 个弹槽、扫不到空槽就不发（同文件 :310-345）。
---     我们的回收边界是引擎全局的 ±224/±256（= 场地外 32 px，THlib/lib/Lscreen.lua:90-97，
---     bullet.lua:36 用的是 `lstg.world.bound*`，**弹不能单独设**）。后果：同一颗弹多活
---     ~10%，稳态同屏弹数比原作多一点。**屏幕上看不出区别** —— 两种回收都发生在屏幕外
---     （场地是 x±192 / y±224，边界都在它外面），差的只是场外那几十颗的寿命，
---     所以没有为它去改引擎的全局边界。
---  4) 判定框：Sub2 的 `ins_77(24,24)`（子机是 `77(8,8)`）设的是敌人判定框
---     （EclRunLow.inl:663-670 → hitboxDimensions）。TH095 没有自机子弹（th095/src 里
---     没有 PlayerBullet 一类文件，「射击键」就是快门），这个框在拍照关里读不出用处；
---     我们这边本体是要用子弹打掉的 HP Boss，判定框交给 boss_system 的默认值
---     —— 全仓库没有任何一张卡自己设过判定框，为一张卡破例反而不一致。
---  5) 子机：原作用 ins_83 / ins_84 生成**真的子敌机**（各自跑自己的 ECL 子程序、
---     有自己的生命），它们会一直累积、由 640 弹槽兜底。本仓库没有「无限累积的子机」
---     这种写法（§7.3 的装饰层都是自绘或真弹），所以每一幕都把它改成
---     **数量受限、有明确寿命、淡出离场**的自绘 object 或真弹（逐卡注释里写明）。
---
---──────────────────── 第 5 幕（死符「醉人之生、死之梦幻」） ────────────────────
---形状（三句话）
---  本体在**中轴 x=0** 上按 1600 帧一轮上下扫（256→448→256→64，每段 400 帧，
---  缓动 加速/减速/加速/减速），两条并行上下文**每 14 帧交替放一整圈**弹
---  （每条各每 28 帧一圈），每圈 32+拍照数 发、速度 1.3 定速直线、基准角每圈重抽。
---  圈与圈之间靠「发射点在动 + 基准角重抽」错开，玩家穿的是相邻两圈之间的径向缝。
---
---这一张与原作的差异（都交代在这，另外 6 张写在各卡块的注释里）
---  1) 原作是拍照关：玩家按快门，`camera.photoIndex`（已拍张数）决定每圈弹数，
---     即 Sub7/Sub8 的 `ins_20(intV0, 0x2761, 32)` —— 0x2761 = camera.photoIndex
---     （th095/src/EclOperandsInt.cpp:186），上限由 Sub2 的 ins_141(10) 设定
---     （同文件 EclRunTargetHigh.inl:448）。本仓库的相机挂在射命丸文自机上，卡里只读
---     它的快门数（photo_index(10)，见文件中部）⇒ 弹数曲线 32→42 与原作一致，
---     而且**卡里不需要自带任何拍照机制**。
---  2) 弹种 15 / 18：原作是两种**半径不同**的小玉 —— `g_PhotoBulletCollisionSizes`
---     （th095/src/BulletManager.cpp:118-122）存的是**直径**、命中框取 ±size/2
---     （同文件 :1155），15 号 = 8.0/2 = 半径 4.0、18 号 = 6.0/2 = 半径 3.0。
---     **贴图不照原作**：按作者要求两股分别换成 `butterfly` 与 `water_drop`
---     （§7.5 母题表里「蝶 → butterfly」正是幽幽子这一系的母题）。尺寸对得上：
---     butterfly 的判定半径 = 4（bulletStyle.lua:145 的 LoadImageGroup 末两参），
---     和原作的 15 号完全相等；water_drop 是动画样式（LoadAnimation，判定取引擎默认）。
---     颜色按贴图**实测**挑的两档紫：butterfly 第 2 行 (228,201,237) 淡紫、
---     water_drop3 (104,47,207) 深紫（见下面 RING_COLOR_* 的注释）。
---  3) transformFlags = 0x202：0x2 = SPAWN_FAST、0x200 = PLAY_SPAWN_SOUND
---     （th095/src/BulletManager.hpp:133,141）。原作弹出生时先播一小段出场动画、
---     并把位置往回退 4 帧的运动量（同文件 :445-457）；移植版让它出膛就飞
---     （NewSimpleBullet 的 stay=false）。音效原作也是整波响一次（:717-723），一致。
---  4) 原作 Sub4 是 ins_83 生成的**寄生敌机**：它的 ANM 12 是一张 512x255 的整屏叠图
---     （enm17.anm 的 entry3 = boss17b.png，script12 里在 `fsetDiv(128,4,0,±8,0)`
---     之间来回晃），Sub5 每帧把自己挪到拍照目标的位置（ins_63 + 自跳）。
---     我们拿不到那张图 ⇒ 整屏装饰交给符卡背景（不做额外的底帘 / 花瓣雨，作者要求）。
---  5) 原作的 104/105（拍照会话）、143（拍照标记）、118(0)（死亡照片 VM）、
---     149（分数倍率 1.9）、114（10208 帧的卡计时）都是 TH095 的相机 / 计分机制，
---     我们没有对应系统；卡时限改用本仓库的惯例秒数（见 CARD_TIME）。
---  6) 回收边界：原作是**弹心一越过场地边就回收**（PhotoBulletIsOutsidePlayfield，
---     th095/src/BulletManager.cpp:759-765，判据是「弹心 ± 半宽」出 384x448 的框），
---     而且全游戏共用 640 个弹槽、扫不到空槽就不发（同文件 :310-345）。
---     我们的回收边界是引擎全局的 ±224/±256（= 场地外 32 px，THlib/lib/Lscreen.lua:90-97，
---     bullet.lua:36 用的是 `lstg.world.bound*`，**弹不能单独设**）。后果：同一颗弹多活
---     ~10%，稳态同屏弹数比原作的 640 槽多一点（本关最挤的一张 = 死符，
---     7200 帧实测峰值 527）。**屏幕上看不出区别** ——
---     两种回收都发生在屏幕外（场地是 x±192 / y±224，边界都在它外面），差的只是场外
---     那几十颗的寿命，所以没有为它去改引擎的全局边界。
---  7) 判定框：Sub2 的 `ins_77(24,24)`（Sub4 的寄生敌机是 `77(8,8)`）设的是敌人判定框
---     （EclRunLow.inl:663-670 → hitboxDimensions）。TH095 没有自机子弹（th095/src 里
---     没有 PlayerBullet 一类文件，「射击键」就是快门），这个框在拍照关里读不出用处；
---     我们这边本体是要用子弹打掉的 HP Boss，判定框交给 boss_system 的默认值
---     —— 全仓库没有任何一张卡自己设过判定框，为一张卡破例反而不一致。
---  8) 自检报「贴脸狙」的只有第 4 张「死蝶浮月」一处（12 个种子实测 2~8 发、
---     最短 1~19 帧；第 6 张偶尔 1 发）：那是它 Sub7 的 ins_88 CIRCLE_AIMED 自机狙
---     大玉 —— 出膛点就是**本体所在点**，自机贴到本体身上时那一发是瞬发。那不是
---     「必中设计」：真机站到离本体 5 px 的地方会先被本体撞到，而且 6 个种子死局
---     全 0；照原作的形状留着，细节写在那张卡常量段尾的那段注释里。
---  9) 拍照扣血：原作是**拍照关** —— 本体不吃自机子弹，唯一的伤害来源就是快门，
---     拍够 N 张（N = 本卡的 ins_141，也就是相机在一关里能按的次数：
---     EclRunTargetHigh.inl:448 → EclRunHigh.inl:113 写 camera.photoLimit、
---     PhotoCamera.cpp:503 拍到上限就把相机锁死）这一关就结束。
---     我们这边相机挂在射命丸文自机上（aya.lua:191），拍照命中是
---     aya_system.lua:260-274 里 `o.class.base.take_damage2(o, 400 - Dist(...))` ——
---     400−距离 是**普通敌人**的口径（900 血的卡三张就拍死），与「拍 N 张过关」不符。
---     ⇒ 本关按作者要求把拍照那一口伤害换成**固定 1/N 血**，而且按「拍中的第几张」
---     重算剩余血量、第 N 张硬取 0（拍够 N 张**正好**清空血条，见文件中部
---     「拍照扣血」那一节）—— 逐张累减会在 N 张后留下 1e-13 级的残血。
---     子弹照旧能打（差异 4/7 的一贯口径：本体是 HP Boss）⇒ N 张照够打完，
---     边打边拍更快。
--- 10) 原作每一发的弹数 = ins_86..94 的 `count1 × count2`（th095/src/BulletManager.cpp
---     的 SpawnBulletPattern :699-726），速度公式是 count2 > 1 时
---     speed1 − (speed1−speed2)×index2/count2、否则 speed1（同文件 :340-346）。
---     本文件**不再打折**：各卡一律按操作数里的 count1/count2 原样发，装饰（子机 /
---     蛾 / 蝶）才做数量与寿命上的近似；原作靠全游戏 640 弹槽 + 拍照清屏兜底，
---     我们两条都没有，同屏弹数会落在原作的量级上（实测见文末）。
---     另一处刻意不做的近似：原作的 SPAWN_FAST / SPAWN_SLOW（flags 的 0x2 / 0x8）会把弹
---     先退到 velocity×4 的位置、再用几帧滑回出膛点（BulletManager.cpp:445-478）；
---     本文件没有这层出场滑动，弹一出生就按最终速度飞 —— 弹数、角度、速度曲线都不变，
---     只是每颗弹在它自己那条轨迹上比原作早几帧到位。
---=====================================

---实测（2026-09-28，本机 luajit；自检是**逐卡**跑的 —— 每张卡都清场、从 0 帧起，
---所以下面每一列都是「这一张单独打」的数，不是整关同时在场。
---★ 自检桩件里没有相机（`player.camera == nil`）⇒ take_damage2 不会被调、photo_hits
---恒为 0，所以下面这些读数都是**原作 photoIndex = 0**（一张照都没拍）那一档；
---真机用射命丸文拍中本体之后，看 photoIndex 的那几张（world08：卡 1 的狙间隔、
---卡 3 的每圈弹数、卡 5 的小圈圈数、卡 6 的俯冲速度、卡 7 的光翼；Stage EX：卡 8 的
---每轮弹数、卡 11 的弹速、卡 12 的每圈弹数、卡 13 的基角、卡 15 的躲闪/密度）
---会再往上抬。）
---  卡                             峰值同屏弹(7200f)  威胁度(1800f)
---  1 幽雅「死出の誘蛾灯」                704             14.64
---  2 蝶符「鳳蝶紋の死槍」                283              4.68
---  3 死符「醉人之生、死之梦幻」           527              2.21
---  4 「死蝶浮月」                       709              2.76
---  5 密符「御大師様の秘鍵」              371              0.00
---  6 行符「八千万枚護摩」                888              2.19
---  7 超人「飛翔役小角」                  186              0.24
---  ── Stage EX（scene group 10；背景 TH095_bg / BGM TH09_5_1）──
---  8 禁忌「フォービドゥンフルーツ」        679              0.78
---  9 禁忌「禁じられた遊び」                 12              0.34
--- 10 境符「色と空の境界」                1100              2.60
--- 11 境符「波と粒の境界」                 277              2.28
--- 12 貴人「サンジェルマンの忠告」          650              4.64
--- 13 蓬莱「瑞江浦嶋子と五色の瑞亀」        913              2.71
--- 14 鬼気「濛々迷霧」                   2161（见下）        10.69
--- 15 「百万鬼夜行」                       575              2.32
---  （8 张 EX 的 7200f 峰值都在 14400/28800/57600 帧保持不变或只差个位数，
---  不是泄漏；唯一的例外是卡 14 濛々迷霧：Sub4 的雾滴速度只有 0.05 px/帧、
---  平均要在场里飘几千帧才出边界，所以它的同屏数是很长的暂态
---  —— 1800/3600/7200/14400/28800/57600 帧 = 798/1461/2161/2171/2178/2188，
---  7200 帧以后基本不再涨；而且本卡 CARD_TIME = 50s = 3000 帧，
---  **真机一局活不到 7200 帧** —— 按卡时限量到 3000 帧时峰值 1272
---  （1800/2400/3000 帧 = 798/988/1272），只有表里那个 2161 的六成。
---  EX 这一批的发射量与各卡常量一律按 ECL 原样，没打折。卡 9「禁じられた遊び」同屏
---  只有 12 颗弹、出膛总数也少，是因为原作弹幕全在**激光**里（4 组 × 4 根 type 12、
---  第 4 波再加 8 根朝自机的），唯一的 NewSimpleBullet 是每波 4 颗大玉（type 17
---  → ball_huge）—— 激光在本仓库是独立对象、不计进这里的弹数，详见那张卡的注释。）
---  （威胁度那一列是 `tools/threat.lua mod/GAME/th33.lua 1800` 的默认种子读数。
---  这一列对发弹相位极敏感：卡 1 只把蝶弹两组的相位从「闸门多等一帧」改回原作的
---  4+4 帧（见那一卡 ring_t 的注释）、自机狙间隔改 1 帧（121→120），读数就从
---  13.54 一路跳到 14.64 —— 躲避机器人的轨迹是混沌的，**不能拿 1~5% 的差当回归**。）
---  卡 5 那一档 0.00 是**桩件口径**，不是卡坏了：这一档 photoIndex = 0 ⇒ 只在
---  photoIndex ≥ 3 之后才打的单发自机狙（Sub4 的 ins_44 闸）**一颗都没发**，
---  场上只剩钥匙的定角三连（上/左/右）；威胁工具那个躲避机器人只要不往那三条线上站
---  就不会被判到（真机里钥匙本体有判定、会撞人，桩件量不到；见各卡的 §7.4 C 类说明）。
---  · ① 泄漏扫描 ✅ —— 1800 / 3600 / 14400 帧三档，7 张卡的峰值同屏弹是平的：
---    700/702/704、281/283/283、527/527/529、706/708/712、282/308/371、
---    885/888/890、183/183/187 —— 不会随时间线性爬（末位浮动是发弹相位，不是泄漏；
---    卡 5 的 282→371 是「钥匙边掉边发」的长暂态，14400 帧以后不再涨，见 7200/14400/28800
---    = 371/371/379）。8 张 EX 同样扫了四档，除了卡 14 濛々迷霧的长暂态（见上表
---    下面那段）以外全部持平：678/679/679/680、12 平、1100 平、277 平、
---    633/642/650/664、913 平、798/1461/2161/2171、574/574/575/581。
---  · ② 字段审计 ✅ —— `luajit tools/check_fields.lua mod/GAME/th33.lua`：通过。
---  · ③ 整项目扫描 ✅ —— `luajit tools/check_stage.lua --all`：76 个 lua 全过
---    （th34.lua 原来那张 433 与本关 Stage EX 之后的空号没关系；它撞的是 th31 的
---    LIST，已在 2026-09-28 改成 461，现在没有跨组重复）。
---  · ④ `luajit tools/threat.lua mod/GAME/th33.lua 1800`：15 张全部「有限位」、
---    威胁度 0.00 ~ 14.64。文档的 0.5~1.5 是同工具量**自制卡**定的；拿它量原作移植卡
---    本来就是超区间读数（本仓库 th20.lua 的 35 张：中位 1.15、8 张 > 1.5、最高 3.99），
---    硬压到 1.5 就成了「把原作改松」，不是移植。卡 1 的 14.64 最高，那是「两组蝶弹
---    一起压」的原作形状，**不要压**（卡 5 的 0.00 见上）；真嫌挤就调各卡常量段里的
---    RING_SPEED / CYCLE / SPEAR_SPEED —— 改前先想清楚那还是不是原作。
---  · ⑤ 拍照扣血（差异 9）**自检看不见**：桩件里没有相机，拍照这条路径根本不会
---    被走到（`player.camera == nil`）。验证方式是从本文件里把 photo_index /
---    photo_damage_on / photo_damage_off / take_damage2 包装**原地抽出来**、配桩件跑断言：
---    「第 k 张后 hp = maxhp×(1−k/N)」「第 N 张恰好 == 0（不是 1e-13 级残血）」
---    「拍空枪不加计数」「photo_index 截断到 N」「未标记的 boss 仍走原函数」
---    「子弹已经打得更狠时不回血」共 14 条全过（脚本 /tmp/th33_photo_test.lua，不入库）。
---    逐卡的 N：world08 七张是 7/7/10/4/6/7/8，Stage EX 八张是
---    6/6/5/6/10/5/3/10（各卡 PHOTO_LIMIT 就是那一张的 ins_141，见各卡常量段）。
---
---符卡历史槽位（CARD_ID，跨关唯一）：world08 七张占 410..415 与 416（409 被 th31 占）、
---Stage EX 八张占 453..460。⚠ 只扫 `boss.card.add` 的末参会漏号 —— th31.lua 的
---`local LIST = {` 表里还有一批带 id 的行（LIST 实际用到 452），所以从 453 起。
---★ 本关的 453 与 th31.lua Stage 5 的首张（LIST 里的 453）**撞号**，是 th31 那边的
---遗留问题（本关 Stage EX 整段 453..460 都归 th33）—— 见 `check_stage.lua --all`。
---th34.lua 现在用自己独立的一段 464..469（2026-09-29 从 426/461..463 挪过来）。
---=====================================

local object, boss = object, boss
local enemybase = enemybase
local task, ran = task, ran
local New, NewSimpleBullet = New, NewSimpleBullet
local PlaySound, IsValid = PlaySound, IsValid
local SetImageState, Render, RenderRect = SetImageState, Render, RenderRect
local Class = Class
local laser = laser
local sqrt = sqrt
local cos, sin, max, min = cos, sin, max, min
local lstg = lstg
local VALUE_SET = VALUE_SET
local Angle, Dist = Angle, Dist

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

do  -- 妖梦的符卡背景
    ---同一套白玉楼贴图，但**层数、转速、缩放、配色**全换一组：幽幽子那套压在紫里，
    ---这一套压成青白（刀光 / 半灵），换人了一眼就看得出来（§7.6）。
    class.scbg2 = Class(_SC_BG)
    function class.scbg2:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 90, 0, 0, -0.5, "mul+add", 3.4, 3.4,
                function(l) l.a = 150; l.r, l.g, l.b = 190, 240, 225 end)
        _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 0, 0.3, 0.3, 0.8, "mul+rev", 1.6, 1.6,
                function(l) l.a = 120; l.r, l.g, l.b = 180, 215, 205 end)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 0, 0, 0, 0, "", 2.2, 2.2,
                function(l) l.a = 190 end)
    end
end

do  -- Stage EX：芙兰的符卡背景（红 / 深红）
    ---Stage EX（scene 100/101 = world05）四张卡各一个背景，配色跟着角色的主题色走，
    ---理由同上面两套：换人了一眼就看得出来（§7.6）。
    ---贴图只用 Resources/BossBackGround 里**已存在**的 th*.png（§2 硬约束：不新增素材）。
    class.scbg3 = Class(_SC_BG)
    function class.scbg3:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_4", false, 0, 0, 0, 0, 0, 0.28, "mul+add", 2.2, 2.2,
                function(l) l.a = 170; l.r, l.g, l.b = 255, 96, 120 end)
        _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 200, 0, 0, -0.18, "mul+rev", 2.8, 2.8,
                function(l) l.r, l.g, l.b = 255, 160, 180 end)
        _SC_BG.AddLayer(self, "th06_2", false, 0, 0, 0, 0, 0, 0, "", 1.6, 1.6,
                function(l) l.a = 140 end)
    end
end

do  -- Stage EX：紫的符卡背景（紫 / 青）
    class.scbg4 = Class(_SC_BG)
    function class.scbg4:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_3", false, 0, 0, 40, 0, 0, 0.4, "mul+add", 2.4, 2.4,
                function(l) l.a = 160; l.r, l.g, l.b = 226, 150, 255 end)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0.25, 0.25, -0.3, "mul+rev", 2.0, 2.0,
                function(l) l.r, l.g, l.b = 120, 210, 235 end)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 120, 0, 0, 0, "", 1.9, 1.9,
                function(l) l.a = 150 end)
    end
end

do  -- Stage EX：妹红的符卡背景（火红 / 金）
    class.scbg5 = Class(_SC_BG)
    function class.scbg5:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_2", false, 0, 0, 0, 0, 0, -0.34, "mul+add", 2.6, 2.6,
                function(l) l.a = 165; l.r, l.g, l.b = 255, 140, 90 end)
        _SC_BG.AddLayer(self, "th08_9", false, 0, 0, 160, 0, 0, 0.22, "mul+rev", 2.0, 2.0,
                function(l) l.r, l.g, l.b = 255, 210, 140 end)
        _SC_BG.AddLayer(self, "th08_1", false, 0, 0, 0, 0, 0, 0, "", 2.2, 2.2,
                function(l) l.a = 130 end)
    end
end

do  -- Stage EX：萃香的符卡背景（雾 / 灰紫）
    class.scbg6 = Class(_SC_BG)
    function class.scbg6:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th10_3", false, 0, 0, 0, 0, 0, 0.3, "mul+add", 3.0, 3.0,
                function(l) l.a = 175; l.r, l.g, l.b = 210, 190, 220 end)
        _SC_BG.AddLayer(self, "th10_9", false, 0, 0, 260, 0, 0, -0.24, "mul+rev", 2.4, 2.4,
                function(l) l.r, l.g, l.b = 170, 150, 200 end)
        _SC_BG.AddLayer(self, "th10_4", false, 0, 0, 90, 0, 0, 0, "", 2.0, 2.0,
                function(l) l.a = 120 end)
    end
end

---──────────────────── 「已拍张数」（原作 camera.photoIndex） ────────────────────
---原作有四处读 camera.photoIndex（th095/src/EclOperandsInt.cpp:186 的 0x2761）来定弹数 /
---间隔：卡 71 的自机狙大圈间隔、卡 75 的每圈弹数、卡 74 的小圈圈数、卡 76 的俯冲速度。
---本仓库**不实现拍照** —— 项目自带拍照自机射命丸文：THlib/player/aya/aya.lua:191 给
---player 挂了 player.camera，快门由玩家自己按（aya.lua:59-62 → aya_system.lua 的
---TenguCamera:GetPhoto）。
---原作的 photoIndex 是**这一关里按过快门的张数**（按了就加、拍空也算，见
---PhotoCamera.cpp:503 附近的计数）；按作者要求这里换成**拍中本体的张数**：只有先过
---取景框判定、真的打到本体的那一下才算（记在下面 take_damage2 的包装里），按空枪不加。
---⇒ 每波弹的密度只跟着「打中本体几次」涨，拍空的快门不该让下一波更密。
---⚠ 一处口径差异：原作 photoIndex 是**关卡内累计**的；这里改成「本卡内、拍中本体才加」，
---  老存档的 scoredata.total_photocount 不再影响密度。每张卡在自己的 init
---  （photo_damage_on）里把计数清零 —— 原作 7 幕本来就是各自独立的选关、各自从 0 开始。
---  各卡按自己的 ins_141 上限截断（例如卡 71 的 0..7）。
local photo_hits = 0

---本卡（原作的「这一关」）拍中本体的张数，按各卡的 ins_141 上限截断。
local function photo_index(limit)
    return min(photo_hits, limit)
end

---──────────────────── 拍照扣血：一张照固定扣 1/N 血 ────────────────────
---原作（TH095）是拍照关：本体不吃自机子弹，唯一的伤害来源就是快门，而且**每关的
---快门次数是有限的** —— ins_141 → EclRunTargetHigh.inl:448 的 AssignPhotoCameraLimit
---→ EclRunHigh.inl:113 写进 camera.photoLimit；PhotoCamera.cpp:503 拍到 photoLimit 张
---之后相机直接锁死（PHOTO_CAMERA_DISABLED）、这一关就结束了，PhotoStage.cpp:855 还
---按这个数生成照片格。所以「N = 本卡的 ins_141」就是原作要求拍中的张数。
---
---本仓库的相机挂在射命丸文自机上（THlib/player/aya/aya.lua:191），拍照命中走
---THlib/player/aya/aya_system.lua:260-274 的 object.EnemyNontjtDo 分支：先在取景框
---里 Math.PointInRectangle(Math.NewPoint(o), rect) 判一下，再调
---    o.class.base.take_damage2(o, 400 - Dist(框心, o))
---⇒ 「拍照拍中」这一个入口可以精确替换掉，两个前提都成立：
---  · take_damage2 在整个游戏目录里**只有这一处调用**（grep 全目录：只有
---    THlib/enemy/boss.lua:66 的定义与上面这一处调用）⇒ 包它 = 只改拍照伤害；
---  · o.class.base 对 boss 实例**就是 boss 类本身** —— 每个关卡的 boss 是
---    Class(boss, {...})（THlib/enemy/boss.lua:163 的 boss.Define），实例的 o.class
---    是那个子类、子类的 base 才是 boss，于是查到的正好是这里包过的这张表。
---于是本关卡把血条换成「拍照计数」：卡在 init 里写 self.photo_damage_limit = N、
---在 del 里清掉；被拍到就按「这是拍中的第几张」**重算**剩余血量
---    remain = maxhp × (1 − 第几张/N)
---第 N 张硬取 0 ⇒ 拍够 N 张**正好**清空，和原作等价。
---★ 为什么不逐张扣 maxhp/N：maxhp/N 是除不尽的浮点数，N 次相加与 maxhp 差一个 ulp
---  —— 实测 950/7 连扣 7 次后 hp 还剩 1e-13 级的正数，血条上就是「一丝血」。
---  remain 在第 N 张直接落 0，没有累加误差。
---★ 顺便：这个包装也是「拍中本体」的唯一入口 ⇒ photo_hits 在这里 +1（见上面那一节）。
---没标记过的 boss（别的关卡、别的自机、卡与卡之间的空档）原样走原函数，一点不影响。
---为什么不改 aya_system.lua：THlib 是框架，改它会影响整个项目（§2 的硬约束）。
---为什么不用 onPhotoFunc：那个钩子在**取景框之外也会被调**（aya_system.lua:262 在
---PointInRectangle **之前**），要用它就得自己复刻取景框几何；take_damage2 这一层
---已经判过框了，借它的判定更准。
---⚠ 两个刻意保持原样的口径：
---  · 拍照伤害**不吃 dmg_factor**（系统的 t1 无敌 / t2 爬升）—— 原函数只乘
---    DMG_factor 与 astral_dmg_factor，这里沿用，只把伤害值换成 maxhp/N。
---  · 子弹照旧能打（本仓库对原作移植卡的一贯口径：本体是 HP Boss，见文件头差异 4）
---    ⇒ N 张照**够**打完这张卡，边打边拍会更快；「只能靠拍照打掉」是另一件事。
if not boss.photo_damage_patch then
    boss.photo_damage_patch = true
    local boss_take_damage2 = boss.take_damage2
    boss.take_damage2 = function(self, dmg)
        local limit = self.photo_damage_limit
        if not limit then
            ---本关卡没标记过的 boss：原样交给原函数（THlib/enemy/boss.lua:66）。
            return boss_take_damage2(self, dmg)
        end
        ---拍中本体：本卡计数 +1（photo_index 靠它；见上面那一节）。
        self.photo_hit_count = (self.photo_hit_count or 0) + 1
        photo_hits = photo_hits + 1
        local hits = min(self.photo_hit_count, limit)
        ---「拍中第 hits 张」之后本体应该剩的血；第 N 张直接 0（不靠累减，见上）。
        local remain = hits >= limit and 0 or self.maxhp * (1 - hits / limit)
        if remain > self.hp then
            remain = self.hp            -- 子弹已经打掉更多时不要把血加回来
        end
        ---enemybase.take_damage 是「计分 / 掉落 / 受击音」那一半
        ---（THlib/enemy/enemy.lua:94），原函数也是先调它再扣血（boss.lua:66-74）；
        ---照抄，让拍的这一下该响的响、该掉的掉（伤害值用名义上的 maxhp/N）。
        enemybase.take_damage(self, self.maxhp / limit)
        if self.dmgmaxt then
            self.dmgt = self.dmgmaxt        -- 受击闪烁（原函数 boss.lua:68-69）
        end
        if not self.protect then
            local dmg0 = self.hp - remain
            self.spell_damage = self.spell_damage + dmg0
            self.hp = remain
        end
    end
end

---给「这一张卡」的本体挂上拍照扣血：limit = 本卡的 ins_141（拍够这么多张 = 清空血条）。
---顺便把「拍中本体的张数」清零（photo_index 的能量来源）。
---init 里调（setStatus 设 maxhp 与 card.init 在同一帧，boss_system.lua:952/955），
---del 里用 photo_damage_off 收掉，免得别的 boss 沾到。
local function photo_damage_on(boss_obj, limit)
    boss_obj.photo_damage_limit = limit
    boss_obj.photo_hit_count = 0
    photo_hits = 0
end

local function photo_damage_off(boss_obj)
    boss_obj.photo_damage_limit = nil
end

---──────────────────── 两个 boss（必须先 Define、再 card.add） ────────────────────
---boss.Define(editname, name, BGM, BG, xy, SCBG, img, level)：
---  · editname = "1a" / "2a" ⇒ _editor_boss 的键是 "1a31" / "2a31"，而
---    boss.CreateGroup(1/2, 31) 按「组号 + 字母 + 关卡号」枚举，正好各建一个。
---  · ⚠ Define 必须**先于** card.add：add 会当场按 "<字母><关卡号>" 查 _editor_boss，
---    晚一行就报「找不到 boss」（boss_card.lua:119；th31.lua 那边踩过）。
---  · img = Resources/BossImage 下的行走图名，幽幽子 "Yuyuko"、妖梦 "Youmu"
---    （BossImageList.lua 里两个都登记过）。
---  · 两人共用 BGM 与背景：原作 world08 的 7 幕本来就是同一份场景资源
---    （SceneSelect.cpp:138-145 全是 world08.std + bgm/th095_04.wav）。
---  · 出生点都在左上角外（-128, 288）—— 原作每一幕的本体都从那里进场。
---
---关卡号 31（= STAGE_COUNT + 1）。2026-09-24 已按 AGENTS.md §8 注册完，一处都别漏：
---  core.lua:54              STAGE_COUNT 30 → 31
---  _editor_output.lua:47   StageID 加 "33"（顺便决定载入顺序：在 "32" 之后）
---  _editor_output.lua:49   不建自己的 BG 目录（和 TH30/31/32 一样复用别人的）
---  _editor_output.lua:1213 stage_pic 纹理循环 30 → 31
---  UI.lua:56 的 difftext   第 31 项 = "醉生梦死"（下标必须等于 level，AEX 顺延到 32）
---  UI.lua:77 的 sntext     TH33 = "醉生梦死"
---  main_stage.lua           NewStage("TH33", …) + self:Next(166)
---  defachievement.lua      成就 166
--- 素材 mod/GAME/stage_pic31.png 是**占位图**（用本关 SCBG 的 th07_8 / th07_10 拼的；
--- 顺便一提：23~30 关现在也共用同一张占位图，md5 都是 96ce7b2…），
--- 要换成真立绘直接覆盖这个文件就行。
local LEVEL = 31
boss.Define("1a", "西行寺幽幽子", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg, "Yuyuko", LEVEL)
boss.Define("2a", "魂魄妖梦", "TH07_1", TH095_bg,
        { 128, field_y(-64) }, class.scbg2, "Youmu", LEVEL)

---──────────────────── Stage EX（scene group 10）的四个 boss 组 ────────────────────
---TH095 的 Stage EX 是 scene group 10 = scene 100..107（SceneSelect.cpp:165-172），
---八个 scene 分属四位角色、四张场地（world05/06/09/10），八张符卡：
---  100 ecl22_a 芙兰 禁忌「フォービドゥンフルーツ」   101 ecl22_b 芙兰 禁忌「禁じられた遊び」
---  102 ecl23_a 紫   境符「色と空の境界」             103 ecl23_b 紫   境符「波と粒の境界」
---  104 ecl24_a 妹红 貴人「サンジェルマンの忠告」     105 ecl24_b 妹红 蓬莱「瑞江浦嶋子と五色の瑞亀」
---  106 ecl25_a 萃香 鬼気「濛々迷霧」                 107 ecl25_b 萃香 「百万鬼夜行」
---原作是八张**各自独立选关**的卡；这里按角色归成四个组（§8：一个角色一个组）：
---  组 3a = 芙兰（100/101）、组 4a = 紫（102/103）、组 5a = 妹红（104/105）、组 6a = 萃香（106/107）。
---main_stage.lua 的 TH33 里连着调 boss.CreateGroup(3..6, 31) 就会依次打完这八张。
---★ 同样别把两个角色塞进同一组的 a、b：CreateGroup 会把 a、b 一起建出来（两人同时上场）。
---四人共用同一首 BGM：八个 scene 都是 bgm/th095_03.wav（SceneSelect.cpp:165-172），
---也就是 music.lua 里的 "TH09_5_1"（東の国の眠らない夜）——**不要用 TH07_1**，
---那是上一批 world08 七幕的曲子。场景背景沿用本关的 TH095_bg。
---出生点同样都在左上角外 (-128, 288)：每一幕的本体都是从这里进场。
boss.Define("3a", "芙兰朵露·斯卡雷特", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg3, "Flandre", LEVEL)
boss.Define("4a", "八云紫", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg4, "Yukari", LEVEL)
boss.Define("5a", "藤原妹红", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg5, "Mokou", LEVEL)
boss.Define("6a", "伊吹萃香", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg6, "Suika", LEVEL)

do  -- 71 幽雅「死出の誘蛾灯」（ecl17_a，幽幽子，组 1a 第 1 张）
    ---原作是「蛾扑向灯」：本体从场外落到中轴，**一条**发弹上下文每 8 帧甩出**两组**
    ---16 发的整圈蝶弹（像绕着灯打转的蛾群），第 10 秒再放出一只「蛾」（拍照目标）
    ---加一层自机狙大圈。骨架（/tmp/B_ecl17_a.txt）：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,128) 用 30 帧落到 (0,128)，
    ---    同时 ins_141(7) 把相机的快门上限设成 7 张。
    ---  · Sub3：t=0 起子 ECL 上下文 ins_117(0,4)（= Sub4）+ 一声 ins_106(5)；
    ---    t=600 才放拍照目标（ins_83(6) 的蛾）并起第二条上下文 ins_117(1,5)（= Sub5）。
    ---    两个 ins_117 用的都是**固定槽位**（会把上一个上下文 free 掉、不叠加，
    ---    EclRunTargetHigh.inl:206）⇒ 全场一共只有两条发弹上下文。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,128)。
    ---（world08 七幕的本体都在左上角外生成，所以入场段是同一套。）
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(128)                    -- 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---主弹幕（Sub4，dump 的 @860-1180）：**一条**上下文、**一轮 8 帧**、一轮发**两组** 16 发。
    ---  @920  t=0  ins_101(0, 0x20, 0, 120, -1, -0.025,  0.019635)  ← 写 slot0（被下面那行覆盖）
    ---  @960  t=0  ins_89(15, 4, 16, 1, 4.0, 1.5, floatV0, 0.0327249, 546)  ← 第 1 组：色号 4
    ---  @1004 t=0  ins_101(0, 0x20, 0, 120, -1, -0.025, -0.019635)  ← 同一个 slot 再写一遍
    ---  @1044 t=4  ins_89(15, 5, 16, 1, 4.0, 1.5, floatV1, 0.0327249, 546)  ← 第 2 组：色号 5
    ---  @1088/1124 t=4  ins_15 / ins_16(floatV0 / floatV1, 0.01309)  ← floatV0 +0.75°、floatV1 −0.75°
    ---  @1108/1144 t=4  ins_37(floatV0 / floatV1)                    ← 归一化到 (−π,π]
    ---  @1160 t=8       ins_4(0, -240) → time 设回 0、跳回 @920
    ---四条**对着源码核过**的读数（旧版注释在这几条上写错过，别再照抄）：
    ---  · ins_89 的 aimMode = opcode − 0x56 = 3 = CIRCLE（EnemyShotDispatch.cpp:145、
    ---    BulletManager.hpp:167）：angle = angle + index1×2π/count1 + index2×angleStep，
    ---    而 count2 = 1 ⇒ 操作数里那个 0.0327249 rad（1.875°）**根本没参与**
    ---    （BulletManager.cpp:368-372 的 CIRCLE 分支）。
    ---  · 一轮是 **8 帧**：ins_4(0,-240) 在 t=8 把 ctx->time 拨回 0 并跳回 @920，而解释器
    ---    跳转后会**在同一帧**继续派发 time 与新值相等的指令（EclRunLow.inl:242-246 的
    ---    `goto low_redispatch_instruction`；th31.lua:2758 记着同一条）⇒ t=0 那一组在
    ---    跳跃的**那一帧**就再放一次。于是稳态下一轮 = 8 帧：第 1 组在跳回的那一帧、
    ---    第 2 组在 4 帧后（t=8 与 t=4 的 frame 相隔 4 帧，t=0 与 t=4 同理）。
    ---  · ins_37 **不是取反**、是归一化（EclRunLow.inl:357-363 调 AddNormalizeAngle，
    ---    RuntimeMath.cpp:7 把角折进 (−π,π]）⇒ 两个基准角各自**单调**转，不是来回翻。
    ---  · ins_101 是「往第 N 号 transform 槽里写一条记录」（EclRunTargetHigh.inl:45-63）。
    ---    slot0 被写了**两遍**（@920 的 +0.019635 与 @1004 的 −0.019635）：descriptor 是
    ---    被后来的那条覆盖，但**两组弹各在发弹那一刻抄一份**（BulletManager.cpp:484）
    ---    ⇒ 色号 4 抄到 +0.019635、色号 5 抄到 −0.019635，两组**反向**自转（不是同向）。
    ---    speedDelta 两遍都是 −0.025/帧，所以两组一起在 120 帧里从 4.0 减到 1.0。
    local CYCLE, SPLIT = 8, 4
    local RING_COUNT = 16                   -- ins_89 的 count1 ⇒ 16 等分 22.5°
    local RING_SPEED = 4.0                  -- ins_89 的 speed1（count2 = 1 ⇒ speed2 不参与）
    ---两个基准角**不是同一个**：t=4 的 ins_15(floatV0, 0.01309) 加、ins_16(floatV1, 0.01309)
    ---减（case 15 = 加、case 16 = 减；EclRunLow.inl:269/273）⇒ 两组基准角每轮**反向**各转
    ---0.75°，越拉越开 —— 这就是「两组蝶弹」在屏幕上分成两圈的原因。换算到我们这边
    ---（TH095 正角 = 顺时针 ⇒ 取反）：floatV0 那组每轮 −BASE_STEP、floatV1 那组 +BASE_STEP。
    local BASE_STEP = 0.75
    local RING_STYLE = butterfly
    ---色号照原作：两组分别是 color 4 与 color 5。butterfly 不是 colorful 样式 ⇒
    ---贴图下标 = ceil(色号/2)（Lresources.lua:208 的 LoadImageGroup + bulletStyle.lua:64
    ---的 init），于是两组正好落在 butterfly2 / butterfly3 **两张不同的贴图**上。
    local RING_COLOR_A, RING_COLOR_B = COLOR.PURPLE, COLOR.DEEP_BLUE

    ---圈里每一颗自己会**一边转一边减速**（Sub4 的 ins_101 slot0，kind = 0x20 = 极坐标加速，
    ---PhotoBulletSpawnDescriptor.hpp:100；实现在 BulletManager.cpp:822-841 的
    ---UpdatePolarAcceleration）：每帧 angle += angleDelta、speed += speedDelta，
    ---持续 int0 = 120 帧，之后整条 transform 失效、弹保持最后的速度与方向直飞。
    ---  angleDelta = ∓0.019635 rad/帧 = ∓1.125°/帧 —— TH095 是「顺时针为正」，换算到
    ---  我们「逆时针为正」的坐标系要**取反**。RING_SPIN 只记大小，两组在 fire_ring 里
    ---  一个拿 −RING_SPIN、一个拿 +RING_SPIN（见下面 fire_ring 的注释）；
    ---  speedDelta = −0.025/帧 ⇒ 4.0 在 120 帧里线性掉到 1.0。
    ---★ 「120 帧之后必须停」是硬要求：极坐标加速是有时长的 transform，过了就没了；
    ---  一直转下去就成了「1.0 px/帧 + 1.125°/帧」的半径 51 px 小圈 —— 子弹永远出不了
    ---  回收边界，同屏弹数会线性涨（旧版实测 1800 帧 1432 → 7200 帧 5548）。
    ---（frame 钩子只收一个参数，§5.2；「还剩几帧」存在弹自己身上。）
    local RING_SPIN = 1.125
    local RING_DRAG = -0.025
    local RING_MIN_SPEED = 1.0              -- 120 帧刚好减到 1.0，这个下限只是兜底
    local RING_FRAMES = 120

    ---自机狙大圈（Sub5，dump 的 @1204-1352）：ins_88(17, 0, 8, 1, 0.8, 1.5, 0, 0.0327249, 514)。
    ---  · opcode 88 ⇒ aimMode 2 = CIRCLE_AIMED：每一发的角度 = 自机角 + index1×2π/count1，
    ---    也就是**整圈一起转向自机**（BulletManager.cpp:367-372）。
    ---  · count1 = 8（8 等分 45°）、speed1 = 0.8（count2 = 1 ⇒ speed2 不参与）、
    ---    transformFlags 0x202 = 0x200 出场音 + 0x2 SPAWN_FAST（出场回退 4 帧的运动量，
    ---    BulletManager.cpp:445-457；我们出膛就飞）。
    ---  · 间隔由 Sub5 自己算：ins_22(extraIntV0, photoIndex, 10) → ×10、
    ---    ins_21(extraIntV0, 120, extraIntV0) → 120 − 它、ins_2 等这么多帧。
    ---    ins_2 = SET_SECONDARY_TIME：**设它的那一帧就已经算掉 1 帧** —— dispatch 顶部
    ---    看到 secondaryTime > 0 就 secondaryTime-- 与 time-- 相抵、本帧到此为止
    ---    （EclRun.cpp:296-303），帧末再统一 time++（同文件 :422）⇒ 冻结 N 帧之后
    ---    下一发**正好隔 N 帧**，不是 N+1（th31.lua:15230-15235 对同一条指令也是这么算的；
    ---    旧版这里按 N+1 写成 121，自机狙每圈慢 1 帧）。
    ---    ⇒ 每 (120 − 10×photoIndex) 帧一圈，拍得越多压得越密；
    ---    photoIndex ≤ 7（ins_141(7)）⇒ 最密 50 帧，正好是 AIM_GAP_MIN。
    ---弹型 17 = 原作的**大玉**（g_PhotoBulletCollisionSizes[17] = 28，命中框取
    ---±28/2 ⇒ 半径 14；BulletManager.cpp:118-122 与 :1155），这里用本仓库最大的一档
    ---**ball_huge**（bulletStyle.lua:174-180）。原作这一发的色号是 0，但 ball_huge 是
    ---colorful 样式（贴图名 = "ball_huge"..色号），色号 0 会取到不存在的 ball_huge0
    ---（AGENTS §9 A2 会当场报错）⇒ 取同色系的紫 4，和上面两组蝶弹同一族。
    local AIM_COUNT = 8
    local AIM_SPEED = 0.8
    local AIM_STYLE = ball_huge
    local AIM_COLOR = COLOR.PURPLE
    local AIM_GAP_BASE, AIM_GAP_STEP, AIM_GAP_MIN = 120, 10, 50
    local AIM_LIMIT = 7                     -- Sub2 的 ins_141(7)：相机快门上限（photo_index 的截断值）

    ---蛾（Sub3 的 ins_83(6)，子程序 Sub6/Sub7）：原作是一只**真的子敌机** ——
    ---ins_55(12) 指 ANM、ins_143(1,99999) 挂拍照标记、ins_77(8,8) 给个小判定框，
    ---然后 Sub7 每帧 ins_63(photoTarget0.x, photoTarget0.y) 把自己挪到「拍照目标」身上；
    ---它自己**不发弹**（整份 ecl17_a 里只有 Sub4/Sub5 发弹）。
    ---我们这边没有「拍照目标」这个对象、也没有子敌机这一层（§7.3），所以按 §7.4 的 C 类
    ---做成 2 只**不出判定的蝶形装饰**绕自机飞 —— 位置含义从「拍照目标」换成「自机」，
    ---既点了「誘蛾灯」的题，也留下原作那只蛾的存在感。
    ---★ Sub3 的时间基准：它是 Sub2 在 t=130 用 ins_52(3) **同步调用**进来的
    ---（CallSubOnEnemy → EclRunTargetHigh.inl:147 的 enter_subroutine），而 CallEclSub
    --- 会把子上下文的 time 清零（EnemyManagerUpdate.cpp:172-186）⇒ **Sub3 的 t=N 是
    ---「入场结束（第 130 帧）之后再过 N 帧」**，不是第 N 帧。
    ---  所以 Sub3 的 t=600 = 第 730 帧。旧版写成 `MOTH_WAIT - ENTRY_WAIT - ENTRY_TIME`
    ---（= 第 600 帧）早了 130 帧，这里按原文改成「入场之后再等 600 帧」。
    local MOTH_WAIT = 600                   -- Sub3 的 t=600（第 730 帧）
    local MOTH_COUNT = 2
    local MOTH_RADIUS_X, MOTH_RADIUS_Y = 58, 30
    local MOTH_ALPHA = 170                  -- §7.6：装饰层 alpha 压在 120~180

    local CARD_NAME = "幽雅「死出の誘蛾灯」"
    local CARD_TIME = 60
    local CARD_HP = 950
    ---符卡历史槽位（跨关卡唯一）：本关 7 张取 410..415 与 416
    ---（409 被 th31.lua 的 LIST 表占走，详见死符那张的注释）。
    local CARD_ID = 410

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---一只蛾：绕自机转一个小椭圆、上下再摆一点，像绕着灯打转。
    ---纯装饰（§7.4 的 C 类无害实体）：不出判定、不撞自机，只在 render 里画贴图。
    class.moth = Class(object, {
        init = function(self, boss, phase)
            self.boss, self.phase, self.t = boss, phase, 0
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.rot = 0
            self._a = 0
            self.x, self.y = boss.x, boss.y
            task.New(self, function()
                while self._a < MOTH_ALPHA do
                    self._a = min(MOTH_ALPHA, self._a + 5)
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            self.t = self.t + 1
            local a = self.phase + self.t * 1.7
            local tx = player.x + cos(a) * MOTH_RADIUS_X
            local ty = player.y + sin(a) * MOTH_RADIUS_Y + sin(self.t * 2.3) * 10
            self.x = self.x + (tx - self.x) * 0.05
            self.y = self.y + (ty - self.y) * 0.05
            self.rot = self.rot + 2.5
        end,
        render = function(self)
            SetImageState("butterfly2", "mul+add", self._a, 235, 205, 255)
            Render("butterfly2", self.x, self.y, self.rot, 0.85)
        end,
    })

---圈弹每一颗的逐帧钩子：**只在前 RING_FRAMES 帧**自转 + 减速（ins_101 那条 transform
---的时长），之后保持最后的速度与方向直飞（理由见上面 RING_SPIN 的注释）。
---自转方向存在弹自己身上（unit.ring_spin）：原作是**发弹前**把 ins_101 写进 descriptor、
---发弹时整份抄给弹（BulletManager.cpp:484 memcpy）—— 两组色号之间 @1004 又改写过一次，
---所以两组抄到的 angleDelta 符号相反（见 fire_ring）。
    local function ring_frame(unit)
        if unit.spin_left == nil then
            unit.spin_left = RING_FRAMES
            unit.ring_v = RING_SPEED
        end
        if unit.spin_left <= 0 then
            return
        end
        unit.spin_left = unit.spin_left - 1
        unit.ring_v = max(RING_MIN_SPEED, unit.ring_v + RING_DRAG)
        object.SetV(unit, unit.ring_v, unit.rot + unit.ring_spin, true)
    end

---一整圈 16 发（圈里每一颗自己还要转 + 减速，见 ring_frame）；
---spin = 这一圈的自转角速度（度/帧），两组取相反符号。
    local function fire_ring(owner, base, color, spin)
        for i = 0, RING_COUNT - 1 do
            local b = NewSimpleBullet(RING_STYLE, color, owner.x, owner.y, RING_SPEED,
                    base + i * 360 / RING_COUNT, false, 0, false,
                    nil, nil, nil, ring_frame)
            b.ring_spin = spin
        end
        -- transformFlags 的 0x200 = PLAY_SPAWN_SOUND：一整圈只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---主弹幕（Sub4 = ins_117(0,4) 的**子 ECL 上下文**，不是子敌机）：一条上下文、一轮两组。
    ---两条基准角 floatV0/floatV1 从同一个 playerAngle 起，但每轮**反向**转 0.75°（见常量段的
    ---BASE_STEP 注释）⇒ 两组各转各的，这里跟着存两个 base。
    ---★ 两组的自转**方向相反**：slot0 在 @920 先写 angleDelta = +0.019635、@1004 又改成
    ---  −0.019635，而弹是**发弹那一刻**把 descriptor 整份抄走的（BulletManager.cpp:484）
    ---  ⇒ 色号 4 那一组抄到 +0.019635、色号 5 那一组抄到 −0.019635，换算到我们这边
    ---  就是 −RING_SPIN 与 +RING_SPIN（两组反向卷，不是同向）。
    ---★ 两组必须**各卷各的**：自转方向与基准角只要有一处跟着对方走，第二组就会贴着第一
    ---  组的弹道飞（同向 + 同 base ⇒ 第二组只是延迟 4 帧的复制品）—— 16 条弹道上叠两组，
    ---  屏幕上只数得出 16 条臂，正是作者报的「子弹少一半」。原件是**反向自转 + 两组基准角
    ---  每轮各背向 0.75°**，臂越拉越开 ⇒ 32 条臂。这里照原件分开存 base_a / base_b。
    ---★ 节拍照抄那个循环本身：t=0 发 A、t=4 发 B、t=8 跳回 t=0 —— 用**逐帧计数器**
    ---  实现，而不是 task.Wait(4)。理由：真机与桩件对「等一帧」的记账差一帧
    ---  （THlib/lib/Ltask.lua:68-77 的 task.Wait(t) = yield t 次，真机每次 resume 推进一帧
    ---  ⇒ Wait(4) 正好 4 帧；tools/check_stage.lua 的等待计数每帧减一，同一句变成 5 帧），
    ---  而这条弹幕的相位很敏感 —— 用计数器两边就是同一把尺子，自检读数 = 真机读数。
    ---  计数器由 card.frame 驱动：boss_system.lua:133 每帧调一次 `b.current_card.frame(b)`，
    ---  所以「过了几帧」就是帧号，t ≡ 0 / 4 (mod 8) 与原作逐条对齐。
    local ring_t = nil                      -- 开始发弹之后的帧数（nil = 还没开始）
    local ring_base_a, ring_base_b = 0, 0   -- 两组基准角（原作的 floatV0 / floatV1）

    local function ring_begin(owner)
        ring_base_a = Angle(owner, player)
        ring_base_b = ring_base_a
        ring_t = 0
    end

    ---自机狙大圈（Sub5）：从原作第 600 帧起，每 max(50, 120 − 10×photoIndex) 帧一圈 8 发。
    ---aim = true ⇒ 整圈一起转到自机方向（CIRCLE_AIMED 就是把 angleToPlayer 加进每一发的角度）。
    local function aim_stream(owner)
        task.New(owner, function()
            while true do
                for i = 0, AIM_COUNT - 1 do
                    NewSimpleBullet(AIM_STYLE, AIM_COLOR, owner.x, owner.y, AIM_SPEED,
                            i * 360 / AIM_COUNT, true, 0, false)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                task.Wait(max(AIM_GAP_MIN,
                        AIM_GAP_BASE - AIM_GAP_STEP * photo_index(AIM_LIMIT)))
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)
    ---本卡放出的蛾；卡结束时统一收掉（§7.9 第 9 条）。
    local moths = {}

    function card:before()
        moths = {}
    end

    function card:init()
        photo_damage_on(self, AIM_LIMIT)    -- 拍照扣血：拍够 AIM_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧（Sub2 的 ins_52(3) 调用 Sub3），
            ---而 Sub3 的 t=0 同时起主弹幕上下文并响一声（ins_106(5)）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            ring_begin(self)
            ---Sub3 的 t=600（第 730 帧）：亮卡名 → 起自机狙大圈 + 放出蛾。
            ---（我们这边卡名由符卡系统在开场就亮，所以这里只做后两件。）
            ---MOTH_WAIT 是 Sub3 自己的时间（见常量段的说明）⇒ 入场之后直接等它。
            task.Wait(MOTH_WAIT)
            for i = 1, MOTH_COUNT do
                moths[i] = New(class.moth, self, (i - 1) * 180)
            end
            aim_stream(self)
        end)
    end

    ---本体的逐帧逻辑：原作里移动与发弹都挂在 ECL 上下文上，这里只驱动 Sub4 那个
    ---8 帧循环的计数器（见上面 ring_t 的注释）。计数器就绪之后每帧进一次，
    ---相位 0 发第 1 组、相位 SPLIT 发第 2 组并在同一拍推进两组基准角
    ---（原作 @1088/1124 的 ins_15/ins_16 紧跟在 @1044 的第二组之后）。
    function card:frame()
        if not ring_t then
            return
        end
        ---卡结束时本体会先被打死（hp 落 0，checkHP 立刻走 object.Kill，boss_system.lua:351-361），
        ---之后 current_card 还指着这张卡、frame 仍会被调上几帧 —— 自己停手，别在死后接着发弹。
        ---★ 判据只能用 hp，**不能**用 `self.is_combat`：真机上 is_combat 由 setStatus
        ---  （boss_system.lua:874）置 true，可自检桩件的 boss_obj（tools/check_stage.lua:1789）
        ---  根本没这个字段 ⇒ `not self.is_combat` 恒真、蝶弹一帧都发不出来（自检读数全假）。
        ---  hp 两边都有：真机 = 卡结束落 0，桩件 = 9999（永不触发），行为一致。
        ---  `self.hp and` 这一层只是「万一是 nil 也当停手」，顺便满足
        ---  tools/check_fields.lua 对 frame 内读字段必须带守卫的要求。
        if self.hp and self.hp <= 0 then
            ring_t = nil
            return
        end
        local phase = ring_t % CYCLE
        if phase == 0 then
            fire_ring(self, ring_base_a, RING_COLOR_A, -RING_SPIN)   -- @960 t=0：色号 4
        elseif phase == SPLIT then
            fire_ring(self, ring_base_b, RING_COLOR_B, RING_SPIN)    -- @1044 t=4：色号 5
            ---@1088/1124 的 ins_15 / ins_16（@1108/1144 的 ins_37 只是归一化）：
            ---两组基准角反向各转 0.75°，下一轮生效 —— 两组越拉越开。
            ring_base_a = (ring_base_a - BASE_STEP) % 360
            ring_base_b = (ring_base_b + BASE_STEP) % 360
        end
        ring_t = ring_t + 1
    end

    function card:del()
        ---卡结束（kill -> current_card.del(b)，boss_system.lua:241）时把发弹计数器也收掉：
        ---超时结束（hp 没到 0）时 frame 里那条 hp 判据不会触发，这里兜住不多吐一轮。
        ring_t = nil
        photo_damage_off(self)
        for i = #moths, 1, -1 do
            if IsValid(moths[i]) then
                object.RawDel(moths[i])
            end
        end
        moths = {}
    end

    local LEVEL = 31
    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--幽雅「死出の誘蛾灯」

do  -- 73 蝶符「鳳蝶紋の死槍」（ecl17_b，幽幽子，组 1a 第 2 张）
    ---「鳳蝶紋」是凤蝶翅上的眼斑。本体站定，六只蝶形子机分三档从两侧扎进场地：
    ---起飞那一刻朝自机甩一条直激光、一片**背对自机**的乱枪，然后开始每 2 帧一发的
    ---「死槍」——0.02 px/帧 出膛、120 帧里一路加速到 ~1 px/帧 的窄扇；同时子机自己
    ---朝自机冲（原作 ins_65 把子机的 mvAngle/speed 直接设成 playerAngle / 8）。
    ---我们这边没有「敌机」这一层，子机做成不出判定的**自绘蝶**（GROUP.GHOST +
    ---colli = false），威胁全在弹与激光上（和卡 71 的蛾同一个做法）。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 的 ins_63(-128,-64) + t=100 的 ins_64(30,4,0,160) ⇒ 落点 (0,160)
    ---（TH095 坐标）⇒ 我们的 (0, field_y(160) = 64)。三张幽幽子卡的落点刻意不同。
    local BOSS_X = -128
    local BOSS_START_Y = field_y(-64)       -- 288（场地之外）
    local BOSS_HOME_Y = field_y(160)        -- 64
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---Sub3 的点位表：t=60 / t=180 / t=270 各放一对子机，t=270 的 ins_4(0,-504) 跳回
    ---循环头 ⇒ 一轮 270 帧。点位（TH095 坐标 → 我们的 y）：
    ---  (∓128, 16) → (∓128, 208)　(∓96, −32) → (∓96, 256)　(∓64, −64) → (∓64, 288)
    ---后两档在我们的场地上沿（y = 224）之外 —— 原作那四只就是从场外扎进来的。
---每档带自己的 (intV6, intV7)。ins_94/ins_87 的操作数顺序是
---(type, color, count1, count2, speed1, speed2, angle, angleStep, flags)
---（ShotArgs, EnemyShotDispatch.cpp:83-95 的字段顺序）⇒
---  · **intV6 = Sub5 乱枪的色号**（count1 是字面量 64，不是 intV6）；
---  · **intV7 = Sub4 死槍的色号**（count1 是字面量 1）—— 三档的区别只有颜色。
---(intV6, intV7) = (6,3) / (8,4) / (10,5)（Sub3 的 ins_6 逐档改）。
    local WAVES = {
        { delay = 60, x = 128, y = 16, volley_color = 6, spear_color = 3 },
        { delay = 120, x = 96, y = -32, volley_color = 8, spear_color = 4 },
        { delay = 90, x = 64, y = -64, volley_color = 10, spear_color = 5 },
    }

---子机（Sub5）在 t=60 那一帧一次做四件事：
---  ins_145(12, intV7, 8, playerAngle, 256, 24) —— 直激光（色号 = intV7）
---  ins_94(1, intV6, **64**, 4.0, 0.5, playerAngle+80°/+280°, 512) —— 64 发的 RANDOM 乱枪
---  ins_117(0,4) —— 起 Sub4 子上下文（下面那个每 2 帧一发单发直弹的「死槍」）
---  ins_65(playerAngle, 8) —— 子机自己朝自机冲（8 px/帧）
    local DRONE_FIRE_DELAY = 60
    local DRONE_DASH = 8
    local LASER_SPEED = 8                   -- ins_145 第 3 个操作数
    local LASER_LEN = 256                   -- 第 5 个：最大长度
    local LASER_GROW = LASER_LEN / LASER_SPEED  -- 32 帧长满
    local LASER_W = 10                      -- 我们 laser 的 w（命中半宽 = w/2，见 laser.lua）
    local LASER_SUSTAIN, LASER_FADE = 40, 20

---Sub4（子上下文）：ins_87(15, intV7, 1, 1, 0.02, 1.5, playerAngle, 0.0327249, 536)。
---★ 对着 ShotArgs 读一遍：**count1 = 1**、intV7 是**色号**（旧注释把它当成发数，错）。
---所以「死槍」是**一帧一发单发直弹**、朝自机，不是 3~5 发的窄扇；节拍每 **2 帧**一发
---（Sub4 的 ins_4(0,-116) 在 t=2 跳回 @1404）。三档子机的区别只有色号 3/4/5。
---出膛点每发重抽：@1404 的 ins_27(·, 24, randF32) + ins_38 把「半径 ≤24 px 的随机点」
---算成二维偏移、ins_100 写进 shootOffset ⇒ 死槍围着子机散开，不是一条精确的线。
---536 = 0x218 = 0x200 出场音 + 0x10 矢量加速 + 0x8 慢出；ins_101(0, 0x10, 0, 120, -1,
---1/120, -999.99) 再给弹挂上「沿自身方向 120 帧、每帧 +1/120 px/帧」的加速
---（0x10 = ACCELERATE_VECTOR，BulletManager.cpp 的 UpdateVectorAcceleration），
---于是 0.02 一路加到 ~1.02 之后常速飞出去。
    local FAN_INTERVAL = 2
    local FAN_OFFSET_R = 24                 -- ins_27 的第 2 个操作数：出膛点随机半径
    local FAN_STEP = 1.875                  -- angleStep：count1 = 1 ⇒ 本卡不参与，留着备查
    local FAN_SPEED = 0.02
    local FAN_ACCEL = 1 / 120
    local FAN_ACCEL_FRAMES = 120
    local FAN_STYLE = butterfly
    local FAN_COLOR = COLOR.PURPLE

---乱枪（ins_94，aimMode 8 = RANDOM）：angle = random(angle ∓ angleStep)、
---speed = random(speed2, speed1)（BulletManager.cpp:383-395）。
---ins_94 的参数 = (type 1, color intV6, **count1 = 64**, count2 = 1, speed1 = 4, speed2 = 0.5,
---angle = floatV0, angleStep = floatV1, flags = 512) ⇒ 一发就是 **64 颗**（不是 intV6×64）。
---floatV0/floatV1 的算法（Sub5 的 ins_25/ins_7/ins_16/ins_15，EclRunLow.inl:296/251/273/269）：
---  floatV0 = playerAngle + π → floatV1 = floatV0 → floatV0 −= 100°、floatV1 += 100°
---  ⇒ 操作数里 floatV0 = playerAngle + 80°、floatV1 = playerAngle + 280°。
---RANDOM 分支算的是 GetRandomF32InRange(angle − angleStep) + angleStep；range 为负
---（80−280 = −200°）时落在 [angleStep − 200°, angleStep] = [playerAngle+80°, playerAngle+280°]
---⇒ **以背对自机方向（playerAngle+180°）为中心、宽 200° 的扇**。
---速度同样随机：RANDOM 分支 speed = random(speed2, speed1) = random(0.5, 4.0)。
    local VOLLEY_ARC = 100
    local VOLLEY_COUNT = 64                 -- ins_94 的 count1
    local VOLLEY_SPEED1, VOLLEY_SPEED2 = 4.0, 0.5
    local VOLLEY_STYLE = water_drop

    ---子机的淡入 / 淡出（它在原作里靠「飞出屏幕就回收」，我们照做）。
    local DRONE_FADE_IN = 15
    local DRONE_ALPHA = 175                  -- §7.6：装饰层 alpha 压在 120~180

    ---Sub2 的 ins_141(7)（dump 的 @464）：相机快门上限，也就是**原作要求拍中的张数**。
    ---这张卡的弹幕不读 photoIndex（原作的扇与乱枪都是定死的），所以它只用在
    ---「拍几张过关」上（见文件头「拍照扣血」那一节）。
    local PHOTO_LIMIT = 7

    local CARD_NAME = "蝶符「鳳蝶紋の死槍」"
    ---原作卡计时 ins_114(6608) ≈ 110 秒（拍照关留给玩家取景用）；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900（同卡 71/75）。
    local CARD_HP = 900
    ---符卡历史槽位：卡 71 占了 410，这张往下取 411。
    local CARD_ID = 411

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的激光（卡结束时统一 RawDel，§7.9 第 9 条）。
    local lasers = {}

    ---一条「死槍」激光：CyGrow 以 8 px/帧 长到 256（32 帧）→ 维持 40 帧 → 收 20 帧。
    ---⚠ 计时**不能挂在 laser 自己身上**：laser:frame 只在真机里调 task.Do
    ---（THlib/laser/laser.lua:65），而 tools/check_stage.lua 的 laser 桩件不调 ——
    ---挂上去自检里永远不收，7200 帧会攒下上百条激光、看着像泄漏。
    ---所以计时挂在 boss 身上（boss_system 每帧 task.Do），换卡时被 task.Clear 清掉。
    local function fire_spear_laser(drone, x, y, a, color)
        local owner = drone.owner
        local l = New(laser, color, x, y, a, 0, 0, 0, LASER_W, LASER_W, 0)
        laser.CyGrow(l, LASER_SPEED, LASER_GROW, 3, a, true)
        lasers[#lasers + 1] = l
        drone.my_lasers[#drone.my_lasers + 1] = l
        task.New(owner, function()
            task.Wait(LASER_GROW + LASER_SUSTAIN)
            if IsValid(l) then
                laser._TurnOff(l, LASER_FADE, true)
                task.Wait(LASER_FADE)
                if IsValid(l) then
                    object.Del(l)
                end
            end
        end)
    end

    ---窄扇里每一颗的逐帧钩子：只在前 120 帧沿自身方向加速，之后保持末速直飞。
    ---（frame 钩子只收一个参数，§5.2；和卡 71 的 ring_frame 一样**必须停**，
    ---否则一直加速的弹永远出不了回收边界。）
    ---★ ins_87 的 flags 536 里还有 0x8 = SPAWN_SLOW（出场时先退到 velocity×4 再滑回来，
    ---BulletManager.cpp:445-478）；本文件统一不做这层出场滑动（见文件头差异 10），
    ---速度曲线与弹数不变，只是这发「死槍」早几帧到位。
    local function spear_frame(unit)
        if unit.accel_left == nil then
            unit.accel_left = FAN_ACCEL_FRAMES
            unit.cur_v = FAN_SPEED
        end
        if unit.accel_left <= 0 then
            return
        end
        unit.accel_left = unit.accel_left - 1
        unit.cur_v = unit.cur_v + FAN_ACCEL
        object.SetV(unit, unit.cur_v, unit.rot, true)
    end

---Sub4 的一发「死槍」：**单发**朝自机；出膛点每发在子机周围 24 px 内重抽。
---color = intV7（三档 3/4/5）。
    local function fire_fan(x, y, color)
        local base = Angle(x, y, player.x, player.y)
        local pa = ran:Float(0, 360)
        local pr = FAN_OFFSET_R * ran:Float(0, 1)
        NewSimpleBullet(FAN_STYLE, color,
                x + cos(pa) * pr, y + sin(pa) * pr,
                FAN_SPEED, base, false, 0, false,
                nil, nil, nil, spear_frame)
    end

---Sub5 的一片乱枪：64 颗、整片背对自机（±100°）、随机角度、随机速度。
---color = intV6（三档 6/8/10）。
    local function fire_volley(x, y, color)
        local center = Angle(x, y, player.x, player.y) + 180
        for _ = 1, VOLLEY_COUNT do
            NewSimpleBullet(VOLLEY_STYLE, color, x, y,
                    ran:Float(VOLLEY_SPEED2, VOLLEY_SPEED1),
                    center + ran:Float(-VOLLEY_ARC, VOLLEY_ARC), false, 0, false)
        end
        PlaySound("tan00", 0.1, x / 256, false)
    end

---蝶形子机（Sub5 的本体）。自己做自己的回收：起飞后活 DRONE_LIFE 帧就淡出，
---淡出期间先把自己的激光收掉（激光比子机活得久一点）。
    class.spear_drone = Class(object, {
        init = function(self, owner, x, y, spear_color, volley_color)
            self.owner = owner
            self.spear_color, self.volley_color = spear_color, volley_color
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false               -- 自己管回收（下面那个协程）
            self.x, self.y = x, y
            self.rot = 0
            self._a = 0
            self.my_lasers = {}
            ---一条协程干完整个 Sub5（★ 不要在里面再 task.New 一条常驻循环：
            ---tools/check_stage.lua 的协程表是全局摊平的，挂在对象名下的 while true
            ---在对象被 RawDel 之后照样会被 resume —— 自检会报「卡结束后还在发弹」。）
            task.New(self, function()
                ---fade in（§7.6：装饰层用淡入，不要凭空出现）
                for _ = 1, DRONE_FADE_IN do
                    self._a = min(DRONE_ALPHA, self._a + DRONE_ALPHA / DRONE_FADE_IN)
                    task.Wait()
                end
                ---Sub5 的 t=60：四条一起（激光 / 乱枪 / 窄扇子上下文 / 起飞）
                task.Wait(DRONE_FIRE_DELAY)
                local a = Angle(self.x, self.y, player.x, player.y)
                fire_spear_laser(self, self.x, self.y, a, self.spear_color)
                fire_volley(self.x, self.y, self.volley_color)
                object.SetV(self, DRONE_DASH, a, true)
                ---Sub4 的死槍：每 FAN_INTERVAL 帧一发单发直弹，直到自己飞出场地为止
                ---（原作靠敌人的 offscreen 检查收掉，这里照做；原作没有「贴脸停火」，
                ---这里也不加 —— 距离由子机自己冲过来决定，玩家有 20 帧按快门）。
                local w = lstg.world
                while self.x > w.l - 64 and self.x < w.r + 64
                        and self.y > w.b - 64 and self.y < w.t + 64 do
                    fire_fan(self.x, self.y, self.spear_color)
                    task.Wait(FAN_INTERVAL)
                end
                ---冲出场地：淡出、把自己那几条激光一起收掉。
                for _ = 1, 20 do
                    self._a = max(0, self._a - DRONE_ALPHA / 20)
                    task.Wait()
                end
                for i = #self.my_lasers, 1, -1 do
                    if IsValid(self.my_lasers[i]) then
                        object.RawDel(self.my_lasers[i])
                    end
                end
                self.my_lasers = {}
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.rot = self.rot + 4          -- 自转，让蝶看起来在扑翅
        end,
        render = function(self)
            SetImageState("butterfly2", "mul+add", self._a, 224, 186, 252)
            Render("butterfly2", self.x, self.y, self.rot, 1.15)
            SetImageState("butterfly6", "mul+add", self._a * 0.7, 196, 156, 244)
            Render("butterfly6", self.x - cos(self.rot) * 12, self.y - sin(self.rot) * 12,
                    self.rot + 40, 0.85)
        end,
    })

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)
    ---本卡放出的子机；卡结束时统一收掉（§7.9 第 9 条）。
    local drones = {}

    function card:before()
        drones = {}
        lasers = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 ins_52(3) 调 Sub3，
            ---而 Sub3 的 t=0 就是 ins_106(5)（一个定位置的音效）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            while true do
                for _, w in ipairs(WAVES) do
                    task.Wait(w.delay)
                    for _, sx in ipairs({ -1, 1 }) do
                        drones[#drones + 1] = New(class.spear_drone, self,
                                sx * w.x, field_y(w.y), w.spear_color, w.volley_color)
                    end
                end
            end
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动与发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #drones, 1, -1 do
            if IsValid(drones[i]) then
                ---★ 先 task.Clear 再 RawDel：协程是挂在子机名下的，
                ---自检的协程表不认「对象已死」这件事（见子机 init 里的注），
                ---不清的话那 180 帧里它还会接着发弹。
                task.Clear(drones[i])
                object.RawDel(drones[i])
            end
        end
        drones = {}
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
        lasers = {}
    end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--蝶符「鳳蝶紋の死槍」

do  -- 75 死符「醉人之生、死之梦幻」（ecl17_c，幽幽子，组 1a 第 3 张）
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
    local PHOTO_LIMIT = 10                  -- ins_141(10) ⇒ count1 上限 42（photo_index 的截断值）

    ---两股弹的样式/颜色。原作两股是 type18/color0 与 type15/color4 两道 ANM 脚本，
    ---贴图都是小玉；这里按作者要求换成**蝶与水**滴，两股一眼分得开（§7.6：一张卡
    ---只用一个色系，所以两个都压在紫里）。颜色下标是照贴图像素挑的，不是猜的：
    ---  · butterfly 有 8 行（bullet4.png 的 x=832..864），第 2 行平均 (228,201,237)
    ---    是淡紫；butterfly 的 DeFineBulletStyle 没给 colorful ⇒ 贴图下标 = ceil(色号/2)，
    ---    所以色号 4 落在第 2 行。
    ---  · water_drop 有 16 行，water_drop3 = (104,47,207) 深紫（colorful ⇒ 色号 = 下标）。
    local RING_STYLE_A = butterfly
    local RING_STYLE_B = water_drop
    local RING_COLOR_A = COLOR.PURPLE         -- Sub8 那圈：原作 type15（半径 4.0）→ butterfly（淡紫）
    local RING_COLOR_B = COLOR.DEEP_PURPLE    -- Sub7 那圈：原作 type18（半径 3.0）→ water_drop（深紫）

    local CARD_NAME = "死符「醉人之生、死之梦幻」"
    ---原作卡计时是 ins_114(10208) ≈ 170 秒 —— 那是拍照关留给玩家取景用的。
    ---我们按本仓库符卡惯例取 50 秒（th095.lua 的卡是 45~55 秒）。
    local CARD_TIME = 50
    ---原作 Timeline0 生成本体时给的生命是 150（life；我们这边的 HP 量级见 th095.lua
    ---的 550~900）。
    local CARD_HP = 900
    ---符卡历史的槽位号（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
    ---实测：把全项目的 boss.card.add 末参 **和 th31.lua 的 LIST 表第 3 项**一起数，
    ---th31 占 351..367 与 370..**409**（409 就是它 LIST 里「秘術「天文密葬法」」那行）、
    ---th32 占 368/369、本关另 6 张占 410..415，所以 1..415 全满、这张取 416。
    ---⚠ 409 这个坑说明：**只扫 boss.card.add 的末参会漏掉 th31 的 LIST**
    ---（它的 id 写在表里、由变量传进 add），照那种扫法挑的"空号"一注册就被
    ---  `check_stage.lua --all` 报「card_id 跨组重复：N（spell_card_data 会串）」。
    local CARD_ID = 416

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---Sub7 / Sub8 的一次发弹：一整圈、定速直线。
    ---count1 的操作数是变量（ins_20 把 camera.photoIndex + 32 写进 intV0），
    ---所以每圈都在发弹那一刻重读一次 —— 两条上下文读的是同一个值，永远一致。
    local function fire_ring(owner, style, color)
        local count = RING_BASE_COUNT + photo_index(PHOTO_LIMIT)
        local base = ran:Float(0, 360)      -- 原作 ins_89 的 angle = random(−π,π)
        local x, y = owner.x, owner.y
        for i = 0, count - 1 do
            NewSimpleBullet(style, color, x, y, RING_SPEED,
                    base + i * 360 / count, false, 0, false)
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整圈只响一声（BulletManager.cpp:717-723），
        -- 与逐发的出场音不同。
        PlaySound("tan00", 0.1, x / 256, false)
    end

    ---一条发弹上下文（Sub7 或 Sub8）：先等自己的相位，然后每 28 帧一圈。
    local function ring_stream(owner, phase, style, color)
        task.New(owner, function()
            task.Wait(phase)
            while true do
                fire_ring(owner, style, color)
                task.Wait(RING_PERIOD)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        ---入场点：原作本体第一帧就把自己定到 (-128,-64)（场地外），第 100 帧才起步。
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 在 t=130 CALL Sub3，而 Sub3 的 t=0 同时
            ---起两股整圈弹、开扫动循环、响一声（ins_106(5)，一个定位置的音效）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            ring_stream(self, 0, RING_STYLE_A, RING_COLOR_A)
            ring_stream(self, RING_PHASE, RING_STYLE_B, RING_COLOR_B)
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
        photo_damage_off(self)
    end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--死符「醉人之生、死之梦幻」

do  -- 77 「死蝶浮月」（ecl17_d，幽幽子，组 1a 第 4 张）
    ---「死蝶浮月」= 一群死蝶绕着浮在空中的月亮打转。原作（/tmp/B_ecl17_d.txt）的骨架是四层：
    ---  · Sub4 + Sub3：本体在 320x64 的框里慢慢晃（ins_75 划框、ins_67 边界感知走位），
    ---  · Sub5：**两股反向自转的双色整圈**（ins_89 发弹 + ins_101 的 0x20 极坐标加速），
    ---  · Sub7：每 30 帧一圈 12 发的自机狙大玉（ins_88，type17 = 半径 14 的大玉），
    ---  · Sub6：48 根放射状激光（ins_153）—— 这张卡的招牌。
    ---激光为什么锚在本体上：ins_153 的第 11 个操作数 followPhotoTarget = 1
    ---（EclRunHigh.inl:729-750 原样照抄进 args.flags；PhotoEffect.cpp:362 的 Update
    ---把它当「每帧把 position 设到 photoTarget0 上」），而 Sub2 的 ins_109(0)
    ---把本体自己登记成了 photoTarget0（EclRunTargetHigh.inl:104-118 的 ins_109 分支）。
    ---⇒ 48 根光柱是**从「月亮」里射出来的**。我们没有相机这一层，激光直接锚在本体上。
---★ 激光扇**不打折**：48 根、角距 7.5°、前摇 120 帧、长度 512、扇面不自转
---（原作 angularVelocity = 0，靠「本体在晃」+「每轮换随机基准角」两种运动），
---全部照 ins_153 的操作数（见下面常量段）。48 根 16 px 宽的光柱在 r < 122 px 内
---确实是实心的（角距 0.131 rad × r < 16）—— 那是原作的形状，不再压。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,256)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(256)                    -- -32（比中心略低）
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---扫动（Sub4）：ins_75(-160,192,160,256) 划出 x∈[-160,160]、y∈[192,256]（TH095 坐标）
    ---⇒ 我们的 y∈[field_y(256), field_y(192)] = [-32, 32]。
    ---ins_67(91,1,0.3) = 边界感知走位 91 帧、速度 0.3；t=90 的
    ---ins_66(91,4,mvAngle,0.3) 再沿**同一个方向**走 91 帧（缓动 4 = 二次减速）
    ---（BeginBoundaryAwareMove，EclDependencies.cpp:108：随机挑一个偏向自机的角度，
    ---靠墙时反射；ins_66 的 ConfigurePolarMotion 见 EclHelpers.cpp:28）。
    ---⇒ 一轮 181 帧、走 ~54 px。原作 0.3 px/帧 是真的慢，「浮月」本来就不该乱跑。
    local BOX_L, BOX_R = -160, 160
    local BOX_B, BOX_T = field_y(256), field_y(192)     -- -32 / 32
    local LEG_TIME = 91
    local SWEEP_SPEED = 0.3
    local SWEEP_SPREAD = 40                  -- 方向相对「自机方向」的散角（度）

    ---双色环（Sub5）：整圈 16 发（ins_89(22, 4, 16, 1, 1.0, 1.5, floatV0, 0.0327249)，
    ---type22 = 半径 4、color 4；t=20 再发一圈 color 5）、速 1.0；
    ---ins_101(1, 0x20, 0, 600, -1, 0, ±0.0261799) 给弹挂上
    ---「每帧 angle ± 1.5°、速度不变、持续 600 帧」的极坐标加速（BulletManager.cpp
    ---的 ACCELERATE_POLAR：exStates[2].angleDelta）。t=40 的 ins_4(0,-248) 跳回
    ---@1240（也就是 t=0 那两条 ins_101）⇒ **40 帧一轮、一轮两圈**
    ---（t=0 → t=40 = 40 帧；跳转同帧派发，见卡 71 的注释）。
    ---半径 = v/ω = 1.0 / 0.02618 = 38 px ⇒ 一圈蝶会绕着出发点卷成一个小旋涡（母题正中）。
---★ 转向时长照原作 600 帧（ins_101 slot1 的 int0 = 600）：这 10 秒里蝶一直绕着出发点
---卷（半径 = v/ω = 38 px），10 秒后放它们直线飞出去（见 swirl_frame 的注释）。
    local RING_PERIOD = 40
    local RING_PHASE = 20                    -- 两圈相隔 20 帧（t=0 与 t=20）
    local RING_COUNT = 16
    local RING_SPEED = 1.0
    local RING_SPIN = 1.5                    -- ±1.5°/帧
    local RING_SPIN_FRAMES = 600
    local RING_STYLE_A, RING_STYLE_B = butterfly, butterfly
    ---颜色下标是照贴图挑的（LoadImageGroup('butterfly','bullet4',832,0,32,32,1,8) 的
    ---8 行；非 colorful ⇒ 贴图号 = ceil(色号/2)）：
    ---色号 4 → butterfly2 = (228,201,237) 淡紫；色号 5 → butterfly3 = (190,190,242) 蓝紫。
    ---两个都在紫系里、又一眼分得开（§7.6）。
    local RING_COLOR_A, RING_COLOR_B = COLOR.PURPLE, COLOR.DEEP_BLUE

    ---小环（Sub7）：ins_88(17, 1, 12, 1, 2.5, 1.5, 0, 0.0327249, 514) = CIRCLE_AIMED、
    ---type17（半径 14 的大玉）12 发、整圈、速 2.5；ins_4(0,-44) 跳回 t=0（t=30）⇒ 每 30 帧。
    ---type 17 = 原作的**大玉**，按文件头差异 2 用本仓库最大的一档 **ball_huge**
    ---（同卡 71 的自机狙大圈，那边也是 type 17）。ball_huge 是 colorful 样式 ⇒
    ---贴图名 = "ball_huge"..色号，原作的色号 1 直接可用。
    ---★ 这三条时间（TICK_FIRST / FAN_FIRST / MOTH_MORE）都是 **Sub3 自己的 t**：
    ---Sub3 是 Sub2 在 t=130 用 ins_52(3) 同步调用的，CallEclSub 把子上下文 time 清零
    ---（EnemyManagerUpdate.cpp:172-186）⇒ 「Sub3 的 t=N」= 入场结束（第 130 帧）之后
    ---再过 N 帧。旧版把这三个数又减了一次 ENTRY_WAIT+ENTRY_TIME，整体早了 130 帧
    ---（第一组死蝶那条（t=0）没减，所以旧版自己也是前后不一致的）。
    local TICK_FIRST = 470                  -- Sub3 的 t=470 ⇒ 第 600 帧
    local TICK_PERIOD = 30
    local TICK_COUNT = 12
    local TICK_SPEED = 2.5
    local TICK_STYLE = ball_huge
    local TICK_COLOR = 1                    -- ins_88 的 color（ball_huge 是 colorful：1..16）
    ---★ 自检偶尔会报这张「贴脸狙」（最多 8 发/1200 帧、最短 0 帧）：小环是 ins_88
    ---的 CIRCLE_AIMED、出膛点就是**本体所在点**，所以自机贴在本体身上时那颗是瞬发。
    ---那不是「必中设计」—— 自机站在离本体 5 px 的地方，真机上先被本体撞到；
    ---6 个种子死局全 0，所以照原作的形状留着。

    ---激光扇（Sub6）：ins_153(12, 3, floatV0, 512, 16, 120, 20, 60, 20, 0, 1)
    ---  type 12、color 3、基准角 = random(-π,π)、最大长度 512、最大宽度 16、
    ---  前摇 120 帧 → 张开 20 帧 → 维持 60 帧 → 收 20 帧，followPhotoTarget = 1。
    ---  ins_15(floatV0, 0.1309) + ins_5(0,-84,extraIntV0=48) ⇒ 48 根、每根差 7.5°。
    ---  命中半宽 = 宽度/2 = 8（PhotoEffect.cpp:436-440：width < 32 时取 width*0.5），
    ---  我们的 laser 命中半宽 = w/2 ⇒ LASER_W 也填 16。
---前摇照原作 120 帧；「张开」用我们的 laser:_TurnOn(GROW) 做
---（alpha 与 w 一起涨 ⇒ 视觉上就是一根细线亮起来）。
---★ 四个时长/根数都照 ins_153 的操作数：前摇 120、张开 20、维持 60、收 20、48 根。
    local FAN_FIRST = 320                    -- Sub3 的 t=320 ⇒ 第 450 帧（第一轮扇）
    ---第二轮在 Sub3 的 t=910（320 + 60 + 530），之后每 530 帧一轮：Sub3 的 t=1000
    ---ins_4(470,-20) 把 time 拨回 470、跳回 t=910 的 @964（跳转后同帧派发），
    ---所以从那一轮起周期才是 530。
    local FAN_INTERVAL = 530
    local FAN_COUNT = 48                     -- ins_5(0,-84,extraIntV0=48)：48 根、每根 7.5°
    local FAN_WARN = 120
    local FAN_GROW = 20
    local FAN_HOLD = 60
    local FAN_FADE = 20
    local FAN_SPIN = 0                       -- 原作 angularVelocity = 0（扇面不自转）
    local LASER_INDEX = 3                    -- 原作的 color 3（laser 的颜色下标 1..16）
    local LASER_W = 16                       -- 命中半宽 = 8
    local LASER_LEN = 512                    -- ins_153 的最大长度
    ---laser1 的贴图是 64+128+64 = 256 px 三段，按 LASER_LEN 的比例切 ⇒ 拉长 1.56 倍。
    local LASER_SEG1, LASER_SEG2 = LASER_LEN * 0.25, LASER_LEN * 0.5

    ---死蝶（Sub3 的 ins_83(4) + t=380 的 ins_83(8)）：原作放出来的是敌机
    ---（ins_83 的 TH095 分支见 EclRunTargetHigh.inl:271-281），这里按 §7.4 的 C 类
    ---做成**不出判定的蝶形装饰**绕本体飞 —— 正好接住「死蝶」这层意思。
    ---第一组 4 只在 Sub3 的 t=0（= 出场后的第 130 帧）立刻放，第二组 8 只在 t=380。
    local MOTH_MORE = 380                   -- Sub3 的 t=380 ⇒ 第 510 帧
    local MOTH_COUNT1, MOTH_COUNT2 = 4, 8
    local MOTH_ALPHA = 165                   -- §7.6：装饰层 alpha 压在 120~180

    ---Sub2 的 ins_141(4)（dump 的 @468）：相机快门上限，也就是**原作要求拍中的张数**。
    ---这张卡的弹幕不读 photoIndex（原作四层都是定死的），所以它只用在「拍几张过关」上
    ---（见文件头「拍照扣血」那一节）。
    local PHOTO_LIMIT = 4

    local CARD_NAME = "「死蝶浮月」"
    ---原作卡计时 ins_114(8408) ≈ 140 秒（拍照关留给玩家取景用）；沿用本仓库的 55 秒。
    local CARD_TIME = 55
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 1000（本卡四层同时压）。
    local CARD_HP = 1000
    ---符卡历史槽位：410/411 已被卡 71/73 占掉、416 被卡 75 占掉，这张取 412。
    local CARD_ID = 412

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的激光与死蝶（卡结束时统一收掉，§7.9 第 9 条）。
    local lasers = {}
    local moths = {}

    ---双色环里每一颗的逐帧钩子：前 RING_SPIN_FRAMES 帧每帧把方向拧 ±RING_SPIN 度
    ---（速度不变 ⇒ 极坐标加速，跟原作 ins_101 的 0x20 一致），之后放开直线飞走。
    ---（frame 钩子只收一个参数，§5.2；**必须停**，否则弹永远绕在原地。）
    local function swirl_frame(unit)
        if unit.spin_left == nil then
            unit.spin_left = RING_SPIN_FRAMES
        end
        if unit.spin_left <= 0 then
            return
        end
        unit.spin_left = unit.spin_left - 1
        object.SetV(unit, RING_SPEED, unit.rot + unit.spin, true)
    end

    ---一整圈 RING_COUNT 发（原作 ins_89：CIRCLE，count2 = 1 ⇒ 操作数里的 angleStep 不参与）。
    ---spin = ±RING_SPIN，两圈反向自转 ⇒ 一眼看得出是两个旋涡错开转。
    local function fire_ring(owner, base, color, spin)
        local x, y = owner.x, owner.y
        for i = 0, RING_COUNT - 1 do
            local b = NewSimpleBullet(RING_STYLE_A, color, x, y, RING_SPEED,
                    base + i * 360 / RING_COUNT, false, 0, false,
                    nil, nil, nil, swirl_frame)
            b.spin = spin
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整圈只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, x / 256, false)
    end

---一股双色环（Sub5）：每 RING_PERIOD 帧两圈（相隔 RING_PHASE 帧），两圈反向自转。
---基准角只在 Sub5 进入时读一次自机角（原作 @1200/@1220 读进 floatV0/floatV1，
---而循环跳回的是 @1240、跳过了那两条）⇒ 之后每轮都用同一个基准角。
---整圈是对称的，基准角只决定相位，所以这里固定取 0 就等价。
---★ 两圈的自转方向**固定**（原作 slot1 在发弹前写一次 +0.0261799、另一圈写 −0.0261799，
---弹在发弹那一刻抄走、之后每轮都是同一份）——旧版每轮把 spin 翻一次符号是错的。
---换算到我们这边（TH095 的正角 = 顺时针 ⇒ 取反）：色号 4 那圈用 −RING_SPIN、
---色号 5 那圈用 +RING_SPIN。
    local function swirl_stream(owner)
        task.New(owner, function()
            while true do
                fire_ring(owner, 0, RING_COLOR_A, -RING_SPIN)
                task.Wait(RING_PHASE)
                fire_ring(owner, 0, RING_COLOR_B, RING_SPIN)
                task.Wait(RING_PERIOD - RING_PHASE)
            end
        end)
    end

    ---小环（Sub7）：每 30 帧一圈 12 发整圈大玉。原作是 CIRCLE_AIMED（基准角 = 自机角），
    ---我们把整圈的相位跟着自机走（对称图案看不出朝向，但相位会跟着转，和原作一致）。
    local function fire_tick(owner)
        local base = Angle(owner.x, owner.y, player.x, player.y)
        for i = 0, TICK_COUNT - 1 do
            NewSimpleBullet(TICK_STYLE, TICK_COLOR, owner.x, owner.y, TICK_SPEED,
                    base + i * 360 / TICK_COUNT, false, 0, false)
        end
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---一根扇激光（原作 ins_153，PhotoEffect.cpp 的 PhotoRotatingLaserView）。
    ---生命周期四段：前摇（细白线预警）→ 张开（w 0→LASER_W）→ 维持 → 收。
    ---★ 计时**挂在 boss 身上**（见 fire_fan）：laser:frame 只在真机里被调，
    ---tools/check_stage.lua 的 laser 桩件既不调 task.Do、`_TurnOn` 也是空函数，
    ---挂 laser 自己的话自检里既不会亮也不会收 —— 卡 73 踩过这个坑。
    class.fan_laser = Class(laser, {
        init = function(self, x, y, a)
            laser.init(self, LASER_INDEX, x, y, a,
                    LASER_SEG1, LASER_SEG2, LASER_SEG1, LASER_W, 0, 0)
            self.warn = FAN_WARN
        end,
        frame = function(self)
            laser.frame(self)
            if self.warn > 0 then
                ---前摇期间把宽度和亮度按死在 0：**不能有判定**（§7.8 第 4 条：
                ---预警不是墙）。laser:frame 里 alpha > 0.999 才判命中，所以 w/alpha 归零即可。
                self.warn = self.warn - 1
                self.w, self.alpha = 0, 0
            end
        end,
        render = function(self)
            if self.warn > 0 then
                ---细白线：全长的预警，粗细按像素给（§C4）—— white 是 16x16，
                ---Render 的 hscale 是「倍数」⇒ LASER_LEN/16 才是全长，0.2 = 3.2 px 粗。
                ---亮度恒正（§C4）：120 + 60*sin(...) ∈ [60,180]。
                local k = 1 - self.warn / FAN_WARN
                SetImageState("white", "mul+add", 120 + 60 * sin(self.timer * 8), 255, 235, 255)
                Render("white", self.x + cos(self.rot) * LASER_LEN * 0.5,
                        self.y + sin(self.rot) * LASER_LEN * 0.5,
                        self.rot, LASER_LEN / 16, 0.2)
            else
                laser.render(self)
            end
        end,
    })

    ---一轮激光扇（Sub6）：FAN_COUNT 根、角距 360/FAN_COUNT，锚在本体上跟着本体走
    ---（原作 followPhotoTarget 的等价物），扇面自己慢转 FAN_SPIN 度/帧。
    local function fire_fan(owner)
        local base = ran:Float(0, 360)          -- 原作 ins_153 的 angle = random(-π,π)
        local fan = {}
        for i = 0, FAN_COUNT - 1 do
            local l = New(class.fan_laser, owner.x, owner.y, base + i * 360 / FAN_COUNT)
            fan[#fan + 1] = l
            lasers[#lasers + 1] = l
        end
        ---一条协程干完这一轮（★ 不要再在 laser 名下开 task：见 fan_laser 的注释）。
        task.New(owner, function()
            ---前摇：预警线跟着本体+扇面转
            for _ = 1, FAN_WARN do
                for i = 1, #fan do
                    local l = fan[i]
                    if IsValid(l) then
                        l.rot = l.rot + FAN_SPIN
                        l.x, l.y = owner.x, owner.y
                    end
                end
                task.Wait()
            end
            PlaySound("lazer00", 0.25, owner.x / 200)
            for i = 1, #fan do
                laser._TurnOn(fan[i], FAN_GROW, false)
            end
            for _ = 1, FAN_GROW + FAN_HOLD do
                for i = 1, #fan do
                    local l = fan[i]
                    if IsValid(l) then
                        l.rot = l.rot + FAN_SPIN
                        l.x, l.y = owner.x, owner.y
                    end
                end
                task.Wait()
            end
            for i = 1, #fan do
                laser._TurnOff(fan[i], FAN_FADE)
            end
            for _ = 1, FAN_FADE do
                task.Wait()
            end
            for i = #fan, 1, -1 do
                if IsValid(fan[i]) then
                    object.RawDel(fan[i])
                end
            end
        end)
    end

    ---本体在框里慢慢晃（Sub4）：先朝自机方向 ±SWEEP_SPREAD 度挑一个角度走 LEG_TIME 帧
    ---（缓动 1 = 二次加速），再沿同一方向走 LEG_TIME 帧（缓动 4 = 二次减速）。
    ---框是凸的 ⇒ 在框内的两点之间直线插值不会跑出框，所以直接把目标点夹进框里就行
    ---（原作的 ins_75 夹取是引擎行为：TH095_ECL_ENEMY_FLAG_CLAMP_TO_MOVEMENT_BOUNDS）。
    local function sweep(owner)
        task.New(owner, function()
            while true do
                local a = Angle(owner.x, owner.y, player.x, player.y)
                        + ran:Float(-SWEEP_SPREAD, SWEEP_SPREAD)
                local step = SWEEP_SPEED * LEG_TIME
                local tx = max(BOX_L, min(BOX_R, owner.x + step * cos(a)))
                local ty = max(BOX_B, min(BOX_T, owner.y + step * sin(a)))
                task.MoveTo(tx, ty, LEG_TIME, VALUE_SET.ACCEL)
                tx = max(BOX_L, min(BOX_R, tx + step * cos(a)))
                ty = max(BOX_B, min(BOX_T, ty + step * sin(a)))
                task.MoveTo(tx, ty, LEG_TIME, EASE_OUT)
            end
        end)
    end

    ---一只死蝶：绕本体转一个小椭圆（母题：绕着月亮飞的蝶），半径各有不同（§7.7 第 2 条）。
    ---纯装饰（§7.4 的 C 类无害实体）：不出判定、不撞自机，只在 render 里画贴图。
    class.dead_moth = Class(object, {
        init = function(self, owner, phase, radius)
            self.owner, self.phase, self.t = owner, phase, 0
            self.radius = radius
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.rot = 0
            self._a = 0
            self.x, self.y = owner.x, owner.y
            task.New(self, function()
                for _ = 1, 30 do
                    self._a = min(MOTH_ALPHA, self._a + MOTH_ALPHA / 30)
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            if not IsValid(self.owner) then
                object.RawDel(self)
                return
            end
            self.t = self.t + 1
            local a = self.phase + self.t * (1.1 + self.radius / 200)
            local tx = self.owner.x + cos(a) * self.radius
            local ty = self.owner.y + sin(a) * self.radius * 0.55
            self.x = self.x + (tx - self.x) * 0.06
            self.y = self.y + (ty - self.y) * 0.06
            self.rot = self.rot + 3
        end,
        render = function(self)
            SetImageState("butterfly2", "mul+add", self._a, 226, 200, 245)
            Render("butterfly2", self.x, self.y, self.rot, 0.9)
        end,
    })

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        lasers = {}
        moths = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 同时 ins_52(3)（Sub3 本体脚本，含
            ---ins_83(4) 放 4 只死蝶）和 Sub4（扫动 + Sub5 的双色环）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            for i = 1, MOTH_COUNT1 do
                moths[#moths + 1] = New(class.dead_moth, self, (i - 1) * 360 / MOTH_COUNT1,
                        46 + i * 6)
            end
            swirl_stream(self)
            sweep(self)
            ---Sub3 的 t=320（第 450 帧）：起 Sub6，第一轮 48 根激光扇。
            ---（Sub6 的 t=0 就摆好 ins_153、开始 120 帧前摇 ⇒ 「起扇」就是这一帧。）
            task.Wait(FAN_FIRST)
            fire_fan(self)
            ---Sub3 的 t=380（第 510 帧）：亮卡名 + 再放 8 只死蝶（ins_83(8)）。
            task.Wait(MOTH_MORE - FAN_FIRST)
            for i = 1, MOTH_COUNT2 do
                moths[#moths + 1] = New(class.dead_moth, self, (i - 1) * 360 / MOTH_COUNT2,
                        64 + i * 5)
            end
            ---下一轮激光扇在 Sub3 的 t=910（= 这里再等 FAN_INTERVAL 帧），之后每 530 帧一轮。
            task.Wait(FAN_INTERVAL)
            while true do
                fire_fan(self)
                task.Wait(FAN_INTERVAL)
            end
        end)
        ---Sub7 的小环：原作 t=470 起到卡结束。
        task.New(self, function()
            task.Wait(TICK_FIRST)
            while true do
                fire_tick(self)
                task.Wait(TICK_PERIOD)
            end
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动、发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
        lasers = {}
        for i = #moths, 1, -1 do
            if IsValid(moths[i]) then
                task.Clear(moths[i])
                object.RawDel(moths[i])
            end
        end
        moths = {}
    end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--「死蝶浮月」

do  -- 72 密符「御大師様の秘鍵」（ecl16_b，妖梦，组 2a 第 1 张）
    ---「御大師様の秘鍵」= 空海（御大師）传下来的密教法器。原作的骨架（/tmp/B_ecl16_b.txt）：
    ---  · Sub2/Sub6：本体在一条**很扁的横带**里（ins_75(-160,128,160,144) ⇒ 我们的 y∈[80,96]）
    ---    每 60 帧做一次 ins_67(30,4,4) 的边界感知走位（30 帧、4 px/帧 ⇒ 一次挪 120 px），
    ---  · Sub3：Sub2 在 t=130 用 ins_52(3) **同步调**进来（子上下文 time 从 0 起）。
    ---    t=60 起三件事各自开工：
    ---      Sub4 = 每 45 帧一发「自机狙小弹」，**photoIndex ≥ 3 才开火**
    ---      （ins_44(photoIndex,3,0,72) = 小于就跳过后面的发弹，EclRunLow.inl:409 的比较分支），
    ---      Sub5 = 每 60 帧往**绝对 (±128, -32)** 各放一把「钥匙」（t=0 与 t=30 各一把）
    ---      （ins_26 先把偏移算成 (-128−pos.x)/(-32−pos.y)，ins_84 再加父坐标，
    ---       所以落点是绝对的场地外左上/右上角），
    ---      Sub6 = 每 45 帧一次边界感知挪位（ins_52(6) 是同步调用：Sub6 跑 45 帧、
    ---      调用者的 time 冻着；Sub6 的 ins_53 返回后 ins_4 又把 time 拨回 60、跳回
    ---      ins_52 ⇒ 立刻再来一次）。
    ---  · Sub7 = 钥匙的炮口（Sub8 在 t=0 用 ins_117(1,7) 起它）：t=10 抽 n = 12 + rand(0..15)，
    ---    再**每 2 帧**甩一发**定角**三连（ins_87 九个操作数全是字面量 ⇒ 上/左/右三个死方向，
    ---    floatV0 那条 +5.625° 是没人读的死指令），一共 n 发；n ≤ 15 时 30 帧一轮、
    ---    n ≥ 16 时越过外层 t=40 就此停摆（理由见 burst_cycle）。
---我们这边的一处差异 / 两条形状上的照抄：
---  ① 「钥匙」做成**不出判定的法器装饰**（§7.4 的 C 类）—— 原作的子敌机本体能撞死人，
---     跟卡 71 的蛾 / 卡 73 的蝶子机一样，威胁全交给弹。
---  ② 三连的**节拍与发数照原作**：每 2 帧一发、n = 12..27 发（不再截断到 15，
---     见 burst_cycle）；方向**不旋转**（旧版按那条死指令转了 5.625°/轮，是从没发生过的形状）。
---     **不做距离闸** —— 原作这张卡没有 ins_82，贴着也照发（见常量段）。
---  ③ 钥匙飞出场地就淡出收掉（原作挂到 t=2000 才退役）。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,160)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(160)                    -- 64
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---横带与「挪一格」（Sub6 的 ins_67(30,4,4) + Sub3 每 60 帧的节奏）：
    ---ins_75 划的是 x∈[-160,160]、y∈[128,144]（TH095）⇒ 我们的 y∈[field_y(144), field_y(128)]。
    local BAND_L, BAND_R = -160, 160
    local BAND_B, BAND_T = field_y(144), field_y(128)   -- 80 / 96
    local SCOOT_PERIOD, SCOOT_TIME = 60, 30
    local SCOOT_SPEED = 4

    ---钥匙（Sub5 的 ins_84 + Sub8）：
    ---  落点 = 绝对 (±KEY_SPAWN_X, KEY_SPAWN_Y)、两次相隔 KEY_GAP 帧（t=0 与 t=30）；
    ---  朝下飞（TH095 的 π/2 是 +y ⇒ 我们的 -90°）、速度 2（ins_65 的第 2 个操作数）；
    ---  每 KEY_BURST_PERIOD 帧甩一次定角三连（上/左/右，见下面「不旋转」那一段）。
    local KEY_SPAWN_X = 128
    local KEY_SPAWN_Y = field_y(-32)                    -- 256（场地上沿之外）
    local KEY_GAP = 30
    local KEY_SPEED = 2
    local KEY_DOWN = -90
    ---淡入 10 帧：原作的 key 在 Sub8 的 t=0 定完速度就开工，Sub7 的 t=10 甩第一轮三连
    ---⇒ 淡入只占这 10 帧（§7.8：不许突然出现 / 突然消失，所以留着这一段）。
    local KEY_FADE_IN, KEY_FADE_OUT = 10, 25
    local KEY_ALPHA = 170                   -- §7.6：装饰层 alpha 压在 120~180
    ---Sub7 的 ins_4(10,-152)：t=40 跳回 t=10 ⇒ **一轮 30 帧**（跳转同帧派发，见卡 71）。
    local KEY_BURST_PERIOD = 30
    local KEY_BURST_GAP = 2                 -- ins_5(10,-64,n) 每轮占 2 帧 ⇒ 2 帧一发三连
    local KEY_BURST_HOLD = KEY_BURST_PERIOD / KEY_BURST_GAP  -- 30 帧里塞得下的三连发数 = 15
    local KEY_BURST_BASE = 12               -- ins_6(extraIntV0, 12)
    local KEY_BURST_RAND = 16               -- ins_24(extraIntV1, randU31, 16) ⇒ 0..15
    ---★ 不要在这里加「贴脸停火」：TH095 的 minimumPlayerDistanceSquared 出生默认是 **0**
    ---（EnemyManagerUpdate.cpp:457 的 `nSquared = 0`），只有卡里调 ins_82 才有距离闸
    ---（EclRunHigh.inl:951-958 把它平方写进去；EnemyShotDispatch.cpp:131-140 才是那个
    ---early return）—— 这张卡**没有** ins_82 ⇒ 原作就是贴着也照甩。加了距离闸等于少发弹。
    ---★ 三连**不旋转**：dump 里 Sub7 的 ins_87 九个操作数 pm=0000（全是字面量）
    ---  ⇒ 基准角写死 −π/2，扇面每轮都是「上/左/右」三个定方向；同帧那条
    ---  ins_15(floatV0, 0.0981748)（floatV0 += 5.625°）**没有任何指令读它**
    ---  （整份 ecl16_b 里 10008 只在这一条被写）⇒ 原作没有「旋转三连」这回事，
    ---  旧版按 5.625°/轮 转是照着那条死指令猜的（画蛇添足）。
    ---  换算：TH095 的 −π/2（朝上）在「逆时针为正」的我们这边是 +90°；
    ---  angleStep = π/2 的两个旁瓣落在 0°（右）与 180°（左）。
    local KEY_STEP = 90                     -- ins_87 的 angleStep = π/2
    local KEY_AIM0 = 90                     -- ins_87 的 angle = -π/2（TH095 朝上）⇒ 我们的 +90°
    local KEY_BULLET_SPEED = 2.0
    local KEY_STYLE = butterfly
    ---颜色：butterfly 非 colorful ⇒ 贴图号 = ceil(色号/2)；色号 8 → butterfly4 = (193,216,235) 冰蓝。
    local KEY_COLOR = COLOR.CYAN

    ---自机狙小弹（Sub4）：ins_86(12, 1, 1, 1, 1.5, 1.5, 0, π/2, 514) = FAN_AIMED、
    ---count1 = 1 ⇒ 单发、正对自机；type12（半径 5）、速 1.5；每 45 帧一发。
    ---★ 原作只在 camera.photoIndex ≥ 3 之后才打（ins_44）—— 这是拍照关「拍够了才开始
    ---给你上强度」的设计，我们照抄：photo_index(PHOTO_LIMIT) < 3 时这一层不存在。
    local AIM_PERIOD = 45
    local AIM_FROM_PHOTO = 3
    local AIM_SPEED = 1.5
    local AIM_STYLE = water_drop
    local AIM_COLOR = COLOR.CYAN            -- water_drop 是 colorful ⇒ 色号 8 = 亮青 (70,204,207)

    local PHOTO_LIMIT = 6                   -- Sub2 的 ins_141(6)：相机快门上限（photo_index 的截断值）

    local CARD_NAME = "密符「御大師様の秘鍵」"
    ---原作卡计时 ins_114(6608) ≈ 110 秒（拍照关留给玩家取景用）；沿用本仓库的 55 秒。
    local CARD_TIME = 55
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..412 已被卡 71/73/77 占掉、416 被卡 75 占掉，这张取 413。
    local CARD_ID = 413

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的钥匙（卡结束时统一收掉，§7.9 第 9 条）。
    local keys = {}

---一次三连（原作 Sub7 循环体 @1364 的 ins_87）：3 发定角（KEY_AIM0、±90°；
---FAN 的奇数 count1 分支，和卡 74 的 fan_angle 同一条公式），不旋转（理由见常量段）。
    local function fire_burst(key)
        for _, off in ipairs({ 0, KEY_STEP, -KEY_STEP }) do
            NewSimpleBullet(KEY_STYLE, KEY_COLOR, key.x, key.y, KEY_BULLET_SPEED,
                    KEY_AIM0 + off, false, 0, false)
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：一次只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, key.x / 256, false)
    end

---Sub7 的一轮：t=10 先抽 n = 12 + rand(0..15)（@1300 ins_6 → @1320 ins_24(randU31,16)
---→ @1344 ins_10 累加），然后**每 2 帧**一发三连、一共 n 发（@1428 的 ins_5(10,-64,n)
---把 time 拨回 10 再跳回 @1364 的 ins_87 ⇒ 一圈占 t=10→t=12 这 2 帧，计数器减到 0 才继续）。
---★ 这一轮占用 2n 帧的 ECL 时间，而外层的 @1452 ins_4 只在 **t=40** 才把 time 拨回 10：
---  · n ≤ 15（2n ≤ 30）⇒ 循环结束时 t ≤ 40，外循环照常重开、重抽 n；
---  · n ≥ 16（2n > 40）⇒ 循环结束时 ctx->time 已经越过 40，那条 ins_4 再也不会匹配
---    （EclRun.cpp:302 只在 `time == instruction->time` 时派发）⇒ **Sub7 就此停摆**，
---    这把钥匙发完这 n 轮三连之后不再发弹（这是原作本身的行为，不是我们加的闸；
---    旧版把 n 截断到 15 再重开，反而比原作多发了弹）。
---返回 true = 这一轮按时收工、等满 30 帧重抽；false = 已经停摆。
    local function burst_cycle(key)
        local n = KEY_BURST_BASE + ran:Int(0, KEY_BURST_RAND - 1)   -- 12..27
        for k = 1, n do
            fire_burst(key)
            if k < n then
                task.Wait(KEY_BURST_GAP)
            end
        end
        if n > KEY_BURST_HOLD then
            return false
        end
        task.Wait(KEY_BURST_PERIOD - KEY_BURST_GAP * (n - 1))
        return true
    end

    ---一把「秘鍵」（原作 Sub8）：场地外飘进来 → 一边往下走一边甩三连 → 出场地淡出。
    ---纯装饰实体（§7.4 的 C 类无害实体）：不出判定、不撞自机，只在 render 里画贴图。
    ---★ 一条协程干完整个生命周期（不要在对象名下再开 `while true`）：
    ---  tools/check_stage.lua 的协程表不认「对象已死」，被 RawDel 之后还会接着被 resume
    ---  —— 卡 73 的蝶子机踩过，自检会报「卡结束后还在发弹」。
    class.key = Class(object, {
        init = function(self, x, y)
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.x, self.y = x, y
            self.rot, self._a = 0, 0
            task.New(self, function()
                for _ = 1, KEY_FADE_IN do
                    self._a = min(KEY_ALPHA, self._a + KEY_ALPHA / KEY_FADE_IN)
                    task.Wait()
                end
                object.SetV(self, KEY_SPEED, KEY_DOWN, true)
                local w = lstg.world
                ---firing 变 false = Sub7 停摆（n ≥ 16）⇒ 之后只往下飘，不再发弹。
                local firing = true
                while self.y > w.b - 64 do
                    if firing then
                        firing = burst_cycle(self)
                    else
                        task.Wait()
                    end
                end
                ---冲出场地：淡出再收（§7.8 第 4 条：不许突然消失）。
                for _ = 1, KEY_FADE_OUT do
                    self._a = max(0, self._a - KEY_ALPHA / KEY_FADE_OUT)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.rot = self.rot - 2.5        -- 和卡 73 的蝶子机反着转（§7.7 第 2 条）
        end,
        render = function(self)
            SetImageState("servant", "mul+add", self._a, 175, 240, 240)
            Render("servant", self.x, self.y, self.rot, 1.05)
        end,
    })

    ---★ Sub3 的时间基准：它是 Sub2 在 t=130 用 ins_52(3) **同步调用**进来的、而
    ---CallEclSub 把子上下文的 time 清零（EnemyManagerUpdate.cpp:172-186）⇒
    ---**Sub3 的 t=N = 入场结束（第 130 帧）之后再过 N 帧**。Sub3 的 t=60 起
    ---Sub4（自机狙）/ Sub5（钥匙）/ Sub6（挪位）三件事，所以三条流都先等 SUB3_START。
    local SUB3_START = 60

    ---本体横着挪一格（Sub6）：朝自机方向 ±60° 挑一个角度走 30 帧、一共 120 px。
    ---带子是凸的 ⇒ 把目标点夹进带里就等价于引擎的 CLAMP_TO_MOVEMENT_BOUNDS。
    local function scoot(owner)
        task.New(owner, function()
            task.Wait(SUB3_START)
            while true do
                local a = Angle(owner.x, owner.y, player.x, player.y)
                        + ran:Float(-60, 60)
                local step = SCOOT_SPEED * SCOOT_TIME
                local tx = max(BAND_L, min(BAND_R, owner.x + step * cos(a)))
                local ty = max(BAND_B, min(BAND_T, owner.y + step * sin(a)))
                task.MoveTo(tx, ty, SCOOT_TIME, VALUE_SET.NORMAL)
                task.Wait(SCOOT_PERIOD - SCOOT_TIME)
            end
        end)
    end

    ---两把钥匙（Sub5）：相隔 KEY_GAP 帧、一左一右落在场地外，然后各自往下飘。
    local function key_stream(owner)
        task.New(owner, function()
            task.Wait(SUB3_START)
            while true do
                keys[#keys + 1] = New(class.key, -KEY_SPAWN_X, KEY_SPAWN_Y)
                task.Wait(KEY_GAP)
                keys[#keys + 1] = New(class.key, KEY_SPAWN_X, KEY_SPAWN_Y)
                task.Wait(SCOOT_PERIOD - KEY_GAP)
            end
        end)
    end

    ---自机狙小弹（Sub4）：photoIndex ≥ AIM_FROM_PHOTO 之后，每 45 帧一发正对自机。
    ---★ Sub4 的 t=0 就是「先判 ins_44 的闸、再发那发」⇒ 第一发机会在它被起的那一帧
    ---（不是等 45 帧之后）；跳回的是 @892（t=0）所以每 45 帧一次。
    local function aim_stream(owner)
        task.New(owner, function()
            task.Wait(SUB3_START)
            while true do
                if photo_index(PHOTO_LIMIT) >= AIM_FROM_PHOTO then
                    local a = Angle(owner.x, owner.y, player.x, player.y)
                    NewSimpleBullet(AIM_STYLE, AIM_COLOR, owner.x, owner.y, AIM_SPEED, a,
                            false, 0, false)
                end
                task.Wait(AIM_PERIOD)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        keys = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 是 ins_104（亮卡名）+ ins_52(3)
            ---（Sub3 = 起点两个子上下文、每 60 帧一次挪位）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            aim_stream(self)
            key_stream(self)
            scoot(self)
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动、发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #keys, 1, -1 do
            if IsValid(keys[i]) then
                ---★ 先 task.Clear 再 RawDel：协程挂在钥匙名下，自检的协程表不认「对象已死」
                ---（见 class.key 的注释），不清的话它还会接着发弹。
                task.Clear(keys[i])
                object.RawDel(keys[i])
            end
        end
        keys = {}
    end

    boss.card.add({ { card, "2a" } }, LEVEL, CARD_NAME, CARD_ID)
end--密符「御大師様の秘鍵」

do  -- 74 行符「八千万枚護摩」（ecl16_c，妖梦，组 2a 第 2 张）
    ---「護摩」是密教用火烧护摩木的修行，八千万枚 = 烧掉的木条数。原作的骨架
    ---（/tmp/B_ecl16_c.txt）：
    ---  · Sub5（主体脚本）：t=0 一记 **128 根的整扇**（ins_87，count1=128 ⇒ 每根差 1.875°、
    ---    以自机方向为中心铺开 ±119°），t=15 的 ins_5(0,-44,4) 把它**每 15 帧再放一次**
    ---    （一共 4 次：t=0/15/30/45；ins_5 把 time 拨回 0 ⇒ 一圈 15 帧），
    ---    t=85 调 Sub4（ins_67(20,4,4) 边界感知走位 20 帧 / 4 px/帧），然后 ins_4(0,-140)
    ---    跳回 t=0 ⇒ **一轮 165 帧**（4 次整扇占 45 帧 + 从最后一次回到 t=85 的 85 帧
    ---    + Sub4 的 35 帧）。
    ---  · Sub6：每 3 帧一小圈（ins_89(18, 1, intV0, 1, 2.0, ...)），
    ---    intV0 = photoIndex/3 + 1（ins_23 整除、ins_30 自增）⇒ 拍得越多圈越大（1~3 发）。
    ---    ins_4(100,-84) 跳回 @1172（t=100）⇒ 周期 3 帧（跳到 t=100 后同帧接着跑）。
    ---    角度是 rand(-π,π) ⇒ 每圈换个相位（§7.7 第 1 条）。
---我们这边的一处差异：
---  · type 6（半径 2）→ butterfly（半径 4）：本关只有 butterfly / water_drop 两种贴图。
---    **发数/速度都不打折**：ins_5(0,-44,4) 的「4 次整扇」照抄 ⇒ 4×128 颗一颗不少；
---    4 次之间隔 15 帧、共用同一个基准角（理由见 fire_fan / fan_stream 的注释）。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,224)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(224)                    -- 0（场地正中）
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---Sub4 的走位框：ins_75(-128,192,128,256) ⇒ x∈[-128,128]、y∈[192,256]（TH095）
    ---⇒ 我们的 y∈[-32, 32]。ins_67(20,4,4)：第 1 个操作数 = 20 帧、第 2 个 = 缓动 4
    ---（4 = 1−(1−t)²，EclRun.cpp:374-378 ⇒ 我们的 VALUE_SET.DECEL）、第 3 个 = 4 px/帧。
    local BAND_L, BAND_R = -128, 128
    local BAND_B, BAND_T = field_y(256), field_y(192)   -- -32 / 32
    local SCOOT_TIME, SCOOT_SPEED = 20, 4

    ---整扇（Sub5）：ins_87(6, 4, 128, 1, 1.4, 1.5, floatV0, 0.0327249, 514)。
    ---count2 = 1 ⇒ speed2 = 1.5 不参与（BulletManager.cpp 的速度公式），速 1.4；
    ---angleStep = 0.0327249 rad = 1.875°；count1 = 128 是**偶数** ⇒ 走偶数分支
    ---（k = index1/2 + 0.5，奇数 index1 取负）⇒ ±0.5、±1.5、…、±63.5 格
    ---= 以自机方向为中心、一口气铺开 ±119.06°。
    ---整扇的节拍：**一共 4 次**（t=0 直落的那次 + ins_5(0,-44,4) 循环出来的 3 次）。
    ---★ 不是「同帧连放 4 次」：ins_5 把 time 拨回 0、跳回 @1008 的 ins_87，而循环体里
    ---  最后一条 ins_5 自己的 time 是 15 ⇒ 每圈要过 15 帧才再派发到它（EclRunLow.inl:419-422
    ---  + 跳转同帧派发）⇒ 4 次整扇落在 t=0/15/30/45。
    ---之后的 85 帧：t=60 那次派发把计数减到 0（退出循环）→ t=85 的 ins_52(4) 是**同步调用**
    ---Sub4（CallSubOnEnemy 把调用者的上下文压栈，EclRunLow.inl:419-420；Sub4 的 ins_53
    ---才返回）—— 调用者的 time 在子程序跑的时候**冻着**，Sub4 自己占 35 帧
    ---（t=15 起步走 20 帧 + 收尾）⇒ 一轮 = 45 + 85 + 35 = 165 帧。
    local FAN_WAIT = 15                     -- 两次整扇之间隔 15 帧（ins_5 的一圈）
    local FAN_REPEAT = 4                    -- ins_5(0,-44,4)：整个扇组一共 4 次
    local FAN_CALL = 85                     -- 最后一次整扇之后 85 帧到 t=85（每次循环都把 time 拨回 0）
    local SCOOT_DELAY = 15                  -- Sub4 的 t=15 才起步
    local SCOOT_TIME = 20                   -- Sub4 的 ins_67(20,4,4) 走 20 帧
    local FAN_COUNT = 128
    local FAN_STEP = 1.875
    local FAN_SPEED = 1.4
    local FAN_STYLE = butterfly
    ---butterfly 非 colorful ⇒ 贴图号 = ceil(色号/2)；色号 8 → butterfly4 = (193,216,235) 冰蓝。
    local FAN_COLOR = COLOR.CYAN

    ---小圈（Sub6）：ins_89(18, 1, intV0, 1, 2.0, 1.5, rand(-π,π), 0.1848, 514)。
    ---type18（半径 3）、color 1、每 3 帧一圈、圈数 = photoIndex/3 + 1（1~3）。
    ---周期是 ins_4(100,-84) 跳回 @1172（t=100）⇒ 100→103 共 3 帧（跳转把 time 拨回 100）。
    local RING_PERIOD = 3
    ---★ Sub6 的第一条指令在 t=100（不是 t=0）：Sub3 在 t=0 起 Sub6，而 CallEclSub 把
    ---子上下文 time 清零（EnemyManagerUpdate.cpp:172-186）⇒ 「Sub6 的 t=100」= 入场
    ---结束（第 130 帧）之后再过 100 帧 = 第 230 帧。旧版入场一结束就开圈，早了 100 帧。
    local RING_DELAY = 100
    local RING_BASE_COUNT = 1               -- 1 + photoIndex/3
    local RING_SPEED = 2.0
    local RING_STYLE = water_drop
    local RING_COLOR = COLOR.CYAN           -- water_drop 是 colorful ⇒ 色号 8 = 亮青 (70,204,207)

    local PHOTO_LIMIT = 7                   -- Sub2 的 ins_141(7)：相机快门上限（photo_index 的截断值）

    local CARD_NAME = "行符「八千万枚護摩」"
    ---原作卡计时 ins_114(8408) ≈ 140 秒；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..413 已被占、416 被卡 75 占掉，这张取 414。
    local CARD_ID = 414

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---FAN 的角度公式（aimMode = 1；BulletManager.hpp 的 PhotoBulletAimModeValue，
    ---实现在 BulletManager.cpp 的 FAN 分支）：
    ---  奇数 count1 ⇒ k = (index1+1)/2 的整数除；偶数 ⇒ k = index1/2 + 0.5；
    ---  index1 为奇数时 k 取负 ⇒ 偶数 count1 的扇面**没有正中间那一根**、两两对称成对。
    local function fan_angle(base, index1, count1, step)
        local k
        if count1 % 2 == 1 then
            k = int((index1 + 1) / 2)
        else
            k = index1 / 2 + 0.5
        end
        if index1 % 2 == 1 then
            k = -k
        end
        return base + k * step
    end

    ---一记整扇（Sub5）：128 根、以自机方向为中心铺开 ±119°（奇数/偶数公式见 fan_angle）。
    ---base 由调用方传进来：原作只在**外圈**开头读一次自机方向（@988 的 ins_7 在 ins_5 的
    ---循环体外，ins_5 跳回的是 @1008 的 ins_87）⇒ 同一轮的 4 次整扇共用同一个基准角。
    local function fire_fan(owner, base)
        local x, y = owner.x, owner.y
        for i = 0, FAN_COUNT - 1 do
            NewSimpleBullet(FAN_STYLE, FAN_COLOR, x, y, FAN_SPEED,
                    fan_angle(base, i, FAN_COUNT, FAN_STEP), false, 0, false)
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整扇只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, x / 256, false)
    end

    ---一小圈（Sub6）：圈数 = 1 + photoIndex/3，相位每圈重抽（原作 angle = rand(-π,π)）。
    local function fire_ring(owner)
        local count = RING_BASE_COUNT + int(photo_index(PHOTO_LIMIT) / 3)
        local base = ran:Float(0, 360)
        for i = 0, count - 1 do
            NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y, RING_SPEED,
                    base + i * 360 / count, false, 0, false)
        end
    end

    ---主体脚本（Sub5）：t=0/15/30/45 各放一扇（共 4 次）→ t=85 调 Sub4（同步 35 帧）
    ---→ 回头（一轮 165 帧）。
    ---★ 4 次循环**不是同帧连放**：ins_5 把 time 拨回 0 再跳回 @1008 的 ins_87，
    ---  而跳转后 time（0）≠ 循环体那条 ins_5 自己的 time（15）⇒ 一圈占 15 帧
    ---  （EclRunLow.inl:419-422 + 跳转同帧派发）。基准角由 @988 的 ins_7 写、@988 在循环体外
    ---  ⇒ 同一轮 4 次整扇用**同一个**基准角，下一轮开头才重读自机方向。
    local function fan_stream(owner)
        task.New(owner, function()
            while true do
                ---@988 ins_7：本轮的自机方向，只在**这里**读一次（4 次整扇共用）。
                local base = Angle(owner.x, owner.y, player.x, player.y)
                ---t=0/15/30/45：4 次整扇，每次之间隔 15 帧（ins_5 的一圈）。
                for k = 1, FAN_REPEAT do
                    fire_fan(owner, base)
                    if k < FAN_REPEAT then
                        task.Wait(FAN_WAIT)
                    end
                end
                task.Wait(FAN_CALL)             -- 到 t=85（调 Sub4 的那一帧）
                task.Wait(SCOOT_DELAY)          -- Sub4 自己的 t=15 才起步
                ---Sub4：朝自机方向 ±60° 挑一个角度、4 px/帧 走 20 帧（= 80 px），夹进框里。
                local a = Angle(owner.x, owner.y, player.x, player.y) + ran:Float(-60, 60)
                local step = SCOOT_SPEED * SCOOT_TIME
                task.MoveTo(max(BAND_L, min(BAND_R, owner.x + step * cos(a))),
                        max(BAND_B, min(BAND_T, owner.y + step * sin(a))),
                        SCOOT_TIME, VALUE_SET.DECEL)
            end
        end)
    end

    ---小圈（Sub6）：t=100 起每 3 帧一圈。
    local function ring_stream(owner)
        task.New(owner, function()
            task.Wait(RING_DELAY)
            while true do
                fire_ring(owner)
                task.Wait(RING_PERIOD)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 是 ins_104（亮卡名）+ ins_52(3)。
            PlaySound("tan00", 0.1, self.x / 256, false)
            fan_stream(self)
            ring_stream(self)
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动、发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "2a" } }, LEVEL, CARD_NAME, CARD_ID)
end--行符「八千万枚護摩」

do  -- 76 超人「飛翔役小角」（ecl16_d，妖梦，组 2a 第 3 张）
    ---「飛翔役小角」= 会飞的役小角（修验道的祖师，传说能在空中飞行）。原作的骨架
    ---（/tmp/B_ecl16_d.txt）不是「站在原地放弹」，而是**本体自己在飞**：
    ---  · Sub3 的 t=0：ins_65(playerAngle, 0.5) + ins_71(0.1) ⇒ 朝自机方向起步、
    ---    速度 0.5、**加速度 0.1**（引擎每帧 speed += acceleration 地飞，越飞越快）；
    ---    然后每帧只跑一段「守卫链」（@940 → @1236 → @1512 → @1788 无条件跳到底），
    ---    也就是**在场地内什么都不做**。
    ---  · 链上的三个分支块（@988 / @1264 / @1540）内容一模一样：把本体挪到
    ---    **(随机 x, -48)**（TH095 坐标 ⇒ 我们的 y = 272，场地上沿之外）、
    ---    换成「俯冲」：ins_65(playerAngle, photoIndex*2)、ins_71(2/60 + 0.1)
    ---    （ins_28 是浮点**除**，EclRunLow.inl:320；2/60 + 0.1 = 0.1333），
    ---    并且 ins_117(0,4) 重启蝶云上下文。
    ---    三个块分别由「出下沿 / 出右沿 / 出左沿」选中 ⇒ **飞出场地就回顶上重来**。
    ---  · Sub4（蝶云）：每帧 1 发、4 发一组（t=0..3，t=4 跳回 @1960），
    ---    出膛点 = 本体 + 半径 24 px 内随机（ins_27 乘随机数、ins_38 化成向量、ins_100 设偏移），
    ---    方向随机；速度 0.02（几乎不动）→ 悬停 60 帧 → 沿自身方向以 1/60 px/帧² 加速 60 帧
    ---    （ins_101 slot0 的 0x8000 = WAIT、slot1 的 0x10 = ACCELERATE_VECTOR，
    ---     见 PhotoBulletSpawnDescriptor.hpp:82-107 的位表）⇒ 最后 ~1.02 px/帧。
    ---    所以这是一片**先悬在半空、再慢慢飘走**的蝶云（母题：役小角身边的蝶）。
---我们这边的一处差异 / 两条只影响自检的说明：
---  ① 俯冲速度照原作：photoIndex × 2（photoIndex 上限 8 ⇒ 最多 16 px/帧），**不封顶**。
---  ② 蝶云只在入场后开一次（原作每次俯冲都重启上下文）。重启只是重置相位
    ---     （ins_117 用的是**固定槽位**、会把上一个上下文 free 掉，EclRunTargetHigh.inl:206，
    ---     不会叠加），图案完全一样，省掉一次协程抖动。
    ---  ③ **自检在这张上的读数偏低，不是卡里缺弹幕。** 桩件只对 `objects` 表里的对象
    ---     积分速度（tools/check_stage.lua 的 step_objects），而本体是它另外造的
    ---     boss_obj、不在那张表里 ⇒ **飞行在自检里是静止的**，蝶云全堆在出生点、
    ---     自机站在别处，所以 `60px 内平均` 只有 0.5。把同一段飞行在桩件里手动积分
    ---     一次（= 引擎真正干的事，LuaSTG-Sub/LuaSTG/LuaSTG/GameObject/GameObject.cpp:330
    ---     的 `x += vx`），同样 1800 帧的读数就是 4.0~4.7。
    ---     这张卡的压迫感本来也主要来自**本体撞人**（自检量不了碰撞），蝶云只是挂在
    ---     身后的软墙；按 §7.2 真正权威的那一栏 `峰值同屏 弹` = 205（阈值 150）⇒ 不空。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,16,128)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_X, BOSS_HOME_Y = 16, field_y(128)   -- 16 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---飞行 / 俯冲（Sub3，公式见卡头注释）。
    local DIVE_SPEED0 = 0.5                 -- ins_65 的第 2 个操作数
    local DIVE_ACCEL0 = 0.1                 -- ins_71 的第 1 个操作数
    local DIVE_ACCEL = 2 / 60 + 0.1         -- 俯冲档的 ins_71(ins_28(2,60) + 0.1)
    local DIVE_SPEED_MUL = 2                -- 俯冲速度 = photoIndex × 2（原作，photoIndex 上限 8）
    local DIVE_X_RANGE = 192                -- ins_27(floatV0, randF32S, 192) ⇒ x ∈ [-192,192]
    local DIVE_SPAWN_Y = field_y(-48)       -- 272（原作的 ins_63(..., -48)）

    ---蝶云（Sub4）：4 发一组、每发 1 帧；出膛点在本体 24 px 内、方向随机；
    ---速度 0.02 → 悬停 60 帧 → 沿自身方向加速 1/60 px/帧² 共 60 帧。
    ---三个数都照原作 slot0/slot1 的 ins_101 抄：kind 0x8000(WAIT) 的 int0 = 60、
    ---kind 0x10(ACCELERATE_VECTOR) 的 int0 = 60 与 f0 = 0.0166667 = 1/60
    ---（B_ecl16_d.txt @1860 / @1900；加速度方向 f1 = -999.99 ⇒ 引擎取弹自己的 angle，
    ---BulletManager.cpp:545-556）。
    ---★ CLOUD_ACCEL 别再调大：实测 2/60 时弹更快飞出场地、云反而**更薄**
    ---（1800 帧的 `峰值同屏 弹` 从 205 掉到 139，`60px 内平均` 从 4.7 掉到 2.8）。
    ---1/60 那种慢慢飘的云才是原作「跟在役小角身后的蝶群」。
    local CLOUD_BURST = 4                   -- 一轮 4 发（= 4 帧）
    local CLOUD_RADIUS = 24
    local CLOUD_SPEED0 = 0.02
    local CLOUD_WAIT = 60
    local CLOUD_ACCEL = 1 / 60
    local CLOUD_ACCEL_FRAMES = 60
    local CLOUD_STYLE = butterfly
    ---原作四发轮着用 color 3/4/5/6（t=0..3 各一发）；butterfly 非 colorful ⇒
    ---贴图号 = ceil(色号/2)，3/4 都是 butterfly2、5/6 都是 butterfly3 —— 两种贴图。
    ---照抄原作四个色号（不再自己挑两个色）。
    local CLOUD_COLORS = { 3, 4, 5, 6 }

    local PHOTO_LIMIT = 8                   -- Sub2 的 ins_141(8)：相机快门上限（photo_index 的截断值）

    local CARD_NAME = "超人「飛翔役小角」"
    ---原作卡计时 ins_114(7208) ≈ 120 秒；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..414 已被占、416 被卡 75 占掉，这张取 415。
    local CARD_ID = 415

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---蝶云里每一颗的逐帧钩子：先悬停 CLOUD_WAIT 帧（原作 slot0 的 0x8000 WAIT），
    ---再沿自身方向加速 CLOUD_ACCEL_FRAMES 帧（slot1 的 0x10 矢量加速，每帧 +1/60）。
    ---（frame 钩子只收一个参数，§5.2；两次都**必须停**，否则弹会一直加速出不了回收边界。）
    local function cloud_frame(unit)
        if unit.wait_left == nil then
            unit.wait_left = CLOUD_WAIT
            unit.accel_left = CLOUD_ACCEL_FRAMES
            unit.cur_v = 0
        end
        if unit.wait_left > 0 then
            unit.wait_left = unit.wait_left - 1
            ---悬停期间原作也是拿 speed = 0.02 在飘（不是 0）：60 帧只挪 1.2 px，
            ---肉眼看不见，但照抄就是了。
            object.SetV(unit, CLOUD_SPEED0, unit.rot, true)
            return
        end
        if unit.accel_left <= 0 then
            return
        end
        unit.accel_left = unit.accel_left - 1
        unit.cur_v = unit.cur_v + CLOUD_ACCEL
        object.SetV(unit, unit.cur_v, unit.rot, true)
    end

    ---蝶云（Sub4）：每帧 1 发、4 帧一轮（ins_4(0,-756) 在 t=4 跳回 t=0 ⇒ 一轮 4 帧）；
    ---每发在出膛点 24 px 内重抽位置、方向各自随机，颜色按 CLOUD_COLORS 逐发轮换。
    local function cloud_stream(owner)
        task.New(owner, function()
            while true do
                for k = 1, CLOUD_BURST do
                    local pa = ran:Float(0, 360)
                    local pr = CLOUD_RADIUS * ran:Float(0, 1)
                    NewSimpleBullet(CLOUD_STYLE, CLOUD_COLORS[k],
                            owner.x + cos(pa) * pr, owner.y + sin(pa) * pr,
                            CLOUD_SPEED0, ran:Float(0, 360), false, 0, false,
                            nil, nil, nil, cloud_frame)
                    task.Wait()
                end
            end
        end)
    end

    ---主体脚本（Sub3）：起飞 → 每帧累加速度 → 出场地就回顶上改成「俯冲」。
    local function flight(owner)
        task.New(owner, function()
            local a = Angle(owner.x, owner.y, player.x, player.y)
            local speed, accel = DIVE_SPEED0, DIVE_ACCEL0
            object.SetV(owner, speed, a, true)
            local w = lstg.world
            while true do
                speed = speed + accel
                object.SetV(owner, speed, a, true)
                ---出界判据照抄原作（TH095 的 x = ±224、y = 480 ⇒ 我们的 boundl/r/b）。
                if owner.x > w.boundr or owner.x < w.boundl or owner.y < w.boundb then
                    local nx = ran:Float(-DIVE_X_RANGE, DIVE_X_RANGE)
                    owner.x, owner.y = nx, DIVE_SPAWN_Y
                    a = Angle(nx, DIVE_SPAWN_Y, player.x, player.y)
                    speed = photo_index(PHOTO_LIMIT) * DIVE_SPEED_MUL
                    accel = DIVE_ACCEL
                    object.SetV(owner, speed, a, true)
                    -- 定位置音效：原作的 ins_106(16)（一个与发弹无关的提示音）
                    PlaySound("tan00", 0.1, owner.x / 256, false)
                end
                task.Wait()
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(BOSS_HOME_X, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 是 ins_104（亮卡名）+ ins_52(3)。
            PlaySound("tan00", 0.1, self.x / 256, false)
            cloud_stream(self)
            flight(self)
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（飞行与发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "2a" } }, LEVEL, CARD_NAME, CARD_ID)
end--超人「飛翔役小角」

---──────────────────── Stage EX ── 两件公共工具 ────────────────────
---下面八张卡（scene 100..107）都要用到的两样东西：
---  ① TH095 的 16 色表 → 本仓库弹贴图的行号；
---  ② 原作的「旋转激光」（ins_147/148/153..157）→ 本仓库 laser 的四段驱动。

---TH095 的弹色是**调色板下标**（BulletManager.cpp:128-133 的 g_PhotoBulletColors16）：
---  0 灰 / 1,2 红 / 3,4 紫 / 5,6 蓝 / 7,8 青 / 9,10,11 绿 / 12,13,14 黄 / 15 灰。
---本仓库的弹样式（ball_small / ball_mid / ball_huge / butterfly / water_drop）都用
---COLOR.* 选行号，所以按色相挑最近的一行（灰 = 16，红 = 2，紫 = 4，蓝 = 6，
---青 = 8，绿 = 10，黄 = 12）。同一张卡的注释里只写原作色号，换算走这张表。
local EX_COLOR = {
    COLOR.GRAY,                    -- 0  0x808080 灰
    COLOR.RED,                     -- 1  0xff1010 红
    COLOR.RED,                     -- 2
    COLOR.PURPLE,                  -- 3  0x801080 紫
    COLOR.PURPLE,                  -- 4
    COLOR.BLUE,                    -- 5  0x1010ff 蓝
    COLOR.BLUE,                    -- 6
    COLOR.CYAN,                    -- 7  0x108080 青
    COLOR.CYAN,                    -- 8
    COLOR.GREEN,                   -- 9  0x10ff10 绿
    COLOR.GREEN,                   -- 10
    COLOR.GREEN,                   -- 11
    COLOR.YELLOW,                  -- 12 0x808010 黄
    COLOR.YELLOW,                  -- 13
    COLOR.YELLOW,                  -- 14
    COLOR.GRAY,                    -- 15
}
local function ex_color(i)
    return EX_COLOR[i] or COLOR.GRAY
end

---一把整圈（原作 ins_89，aimMode = CIRCLE）：基准角 + index1×2π/count1 + index2×angleStep。
---count2 = 1 时 speed2/angleStep 都不参与（BulletManager.cpp:369-372）；整圈是对称的，
---所以 TH095 的「顺时针为正」取反之后方向集合不变，直接用 base + i×360/count。
local function ex_ring(style, color, x, y, count, speed, base, frame)
    for i = 0, count - 1 do
        NewSimpleBullet(style, color, x, y, speed,
                base + i * 360 / count, false, 0, false, nil, nil, nil, frame)
    end
end

---一排扇（原作 ins_86 FAN_AIMED / 87 FAN）：第 index1 发的偏移量 =
---（count1 奇数 ? (index1+1)÷2 : index1÷2 + 0.5）× angleStep，index1 奇数取负
---（BulletManager.cpp:352-365）。FAN_AIMED 还要再加一次自机角（86 号）。
---返回的偏移量是**TH095 坐标系**下的度数；调用方按需要取反。
local function ex_fan_offsets(count, step_deg)
    local t = {}
    local odd = (count % 2) ~= 0
    for i = 0, count - 1 do
        ---★ 原作这两项都是**整数除法**（C 里 index1 是 i32，BulletManager.cpp:352-365）：
        ---    奇数：(index1+1)÷2 向下取整 ⇒ 0, 1, 1, 2, 2, 3…
        ---    偶数：index1÷2 向下取整再 +0.5 ⇒ 0.5, 0.5, 1.5, 1.5…
        ---  （旧写法 (i+1)*0.5 / i*0.5+0.5 从第 3 发起就偏了。）
        local k = odd and math.floor((i + 1) / 2) or (math.floor(i / 2) + 0.5)
        local a = k * step_deg
        if i % 2 ~= 0 then
            a = -a
        end
        t[i + 1] = a
    end
    return t
end

---──────────────────── Stage EX 的旋转激光 ────────────────────
---TH095 的 PhotoRotatingLaserView（PhotoEffect.cpp:348-460）：
---  · 长度每帧 += speed 直到 maximumLength（153/154 从 0 起，147/148/155/156/157 从满长起）；
---  · angle 每帧 += angularVelocity；position 每帧 += velocity（只有 155/156/157 带 vx/vy）；
---  · 四段：STARTUP（宽度恒 2 的细预警线、**无判定**）→ GROWING（宽度 0→maximumWidth）
---    → ACTIVE（maximumWidth 维持）→ FADING（→0、无判定）；宽度是**全宽**。
---  · 判定只在 GROWING/ACTIVE 且 length > 16 时存在（PhotoEffect.cpp:437-451）。
---  · followPhotoTarget 的激光每帧把位置拉回拍照目标（原作 ins_109 指的 boss），
---    我们这边就是本体（见各卡注释）。
---  · 原作的 g_AnmGameSpeed = 1；同时最多 256 条（PhotoEffect.cpp:1165），移植不设上限。
---★ 本仓库 laser 的命中半宽 = w/2（laser.lua:81-110 的 dist = 2），和上面的 width/2 一致；
---  长度放 l2、l1 = l3 = 0 ⇒ 判定盒是直矩形，不是本仓库默认两头收窄的六边形。
---★ 四段计时必须**挂在 owner（boss）的 task 上**：check_stage.lua 的 laser 桩件里
---  _TurnOn/_TurnOff 是空函数、laser:frame 也不跑 task.Do ⇒ 挂在 laser 自己身上，
---  自检里永远不收（th33 的 fan_laser 踩过同一个坑，见 :1310-1400）。
local EX_LASER_WARN_W = 2                 -- STARTUP 的预警线宽（原作初始 width = 2.0）

---把一根 EX 激光跑完四段，到点自己 RawDel。len0 已在 l.l2 里。
local function run_ex_laser(owner, l, max_len, width, speed, startup, grow, sustain, fade,
        ang_vel, vx, vy, follow)
    task.New(owner, function()
        local len = l.l2
        local phase, timer = 1, 0
        while IsValid(l) do
            if len < max_len then
                len = min(max_len, len + speed)
            end
            l.rot = l.rot + ang_vel
            if follow then
                l.x, l.y = owner.x, owner.y
            end
            l.x, l.y = l.x + vx, l.y + vy
            timer = timer + 1
            if phase == 1 then                     -- STARTUP：细线、无判定
                l.w = EX_LASER_WARN_W
                l.colli = false
                if timer >= startup then phase, timer = 2, 0 end
            elseif phase == 2 then                 -- GROWING：宽度线性长到 width
                l.w = width * timer / grow
                l.colli = len > 16
                if timer >= grow then phase, timer = 3, 0 end
            elseif phase == 3 then                 -- ACTIVE
                l.w = width
                l.colli = len > 16
                if timer >= sustain then phase, timer = 4, 0 end
            else                                   -- FADING：无判定
                l.w = width - width * timer / fade
                l.colli = false
                if timer >= fade then break end
            end
            l.l1, l.l2, l.l3 = 0, len, 0
            l.alpha = 1
            task.Wait()
        end
        if IsValid(l) then
            object.RawDel(l)
        end
    end)
end

---生成一根 EX 激光。index = 贴图行（1..16，见各卡注释里挑行的理由）；
---start_full = true ⇒ 初始就是 max_len（147/148/155/156/157），false ⇒ 从 0 长（153/154）。
local function spawn_ex_laser(owner, lasers, index, x, y, angle, max_len, width, speed,
        startup, grow, sustain, fade, ang_vel, vx, vy, follow, start_full)
    local len0 = start_full and max_len or 0
    local l = New(laser, index, x, y, angle, 0, len0, 0, 0, 0, 0)
    l.colli = false
    lasers[#lasers + 1] = l
    run_ex_laser(owner, l, max_len, width, speed, startup, grow, sustain, fade,
            ang_vel, vx, vy, follow)
    return l
end

do  -- 100 禁忌「フォービドゥンフルーツ」（ecl22_a，芙兰，组 3a 第 1 张）
    ---原作是「禁果从场地的四个角长出来」：本体停在**中轴 (0,192)** 不动，只把 shootOffset
    ---依次挪到四个角落，在每个角原地甩出一整圈小玉、再回本体甩一圈 —— 一共五圈一起炸开。
    ---数据源 /tmp/E_ecl22_a.txt（脚本 /tmp/d95v2.py 反汇编，ECL 在
    ---[th095] …/data/ecl22_a.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 用 30 帧落到 (0,192)，
    ---    同时 ins_141(6) 把「要拍够几张」设成 6；t=130 亮卡名 + ins_75 设移动框
    ---    (-140,128,140,192) + ins_52(3) 起主脚本。
    ---  · Sub3（主脚本）一轮 480 帧：t=0 起 Sub8（装饰），t=60 把 slot0 换成 Sub6（**发弹**），
    ---    t=60 的 ins_2(180) 把 Sub3 自己冻结 180 帧，醒来后重开 Sub8；t=120 处其实是
    ---    被 t=60 的冻结推迟到第 300 帧才执行的第二块 —— 换成 Sub7（另一色发弹），
    ---    再冻结 180 帧，然后 ins_4(0,-272) 跳回 t=0。⇒ 一轮 480 帧、两种颜色交替。
    ---  · Sub6 / Sub7 是发弹上下文，进入时立刻发一轮，之后 t=60 / t=120 各**有条件**再发一轮：
    ---    @2964 / @3472 的 `ins_44(photoIndex, 3)` 是 **CMPlt（< 才跳）**（EclRunLow.inl:420 附近
    ---    的比较表；跳转目标 @3460/@3968 正是「跳过这一轮」）⇒ **photoIndex ≥ 3 才有后两轮**，
    ---    拍得越多这一张越密（旧注释把这条读反过，别再照抄）。
    ---  · 每轮 = 四个角各一整圈（Sub6 96 发 / Sub7 88 发、速 1.0）+ 本体一圈
    ---    （两色都是 68 发、速 0.8）。四个角是 ins_26(extraFloat, 角坐标, pos) + ins_100 得到的
    ---    **世界坐标** (-192,0)/(192,0)/(-192,448)/(192,448)（TH095 坐标），
    ---    换算到我们这边 y = 224 − y ⇒ 四个角就是场地的四角。
    ---  · 弹型 18 = 直径 6 ⇒ 用 ball_small（半径 2，最接近）；ins_89 的 aimMode = CIRCLE
    ---    （angle = 操作数 angle + index1×2π/count1 + index2×angleStep，而 count2 = 1 ⇒
    ---    angleStep = 0.1848 不参与，BulletManager.cpp:369-372）。
    ---    flags 514 = 0x202 = PLAY_SPAWN_SOUND + SPAWN_FAST；出场滑动我们统一不做（文件头差异 3），
    ---    出膛音每条弹幕响一次（原作也是整波响一次，BulletManager.cpp:717-723）。
    ---  · 色号：原作两色是 1 与 0。TH095 的 16 色表 g_PhotoBulletColors16 下标 0 = 灰、
    ---    1 = 红（见文件头「色表」一节）⇒ 我们取 ball_small1（红）与 COLOR.GRAY（16，灰）。
    ---  · Sub8（106(5)+150(10) 每帧）是整屏装饰 ANM，Sub4/Sub5 在 Sub3 里从来没被调用过
    ---    （旧摘要把 4/5 当成主发弹是读错了），Sub9 也没被调用 —— 一律不实现。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_X, BOSS_HOME_Y = 0, field_y(192)    -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---Sub2 的 ins_141(6)：原作要求拍中的张数（也就是本卡的拍照血量分母）。
    local PHOTO_LIMIT = 6

    local CARD_NAME = "禁忌「フォービドゥンフルーツ」"
    ---原作卡计时 ins_114(7208) ≈ 120 秒；沿用本仓库的 50 秒（同前七张）。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..416 已被上一批七张占掉；th31 的 LIST 实际用到 452
    ---（mod/GAME/th31.lua 的 `local LIST = {`，末行「魔砲「ファイナルマスタースパーク」」
    ---占 452 —— **别只扫 boss.card.add 的 CARD_ID=、也别只看 LIST 第 3 项之外的行**），
    ---所以 Stage EX 从 453 起（见文件头「符卡历史槽位」）。
    local CARD_ID = 453

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---四个角（我们的坐标；TH095 的 (-192,0)/(192,0)/(-192,448)/(192,448) 各翻一次 y）。
    local CORNERS = { { -192, 224 }, { 192, 224 }, { -192, -224 }, { 192, -224 } }

    local STYLE = ball_small
    local CORNER_SPEED = 1.0                -- 四角那几圈 ins_89 的 speed1（count2 = 1）
    local BODY_SPEED = 0.8                  -- 本体那圈 ins_89 的 speed1
    local COLOR_A = ex_color(1)             -- Sub6 的 color 1（红）
    local COLOR_B = ex_color(0)             -- Sub7 的 color 0（灰）

    ---时间轴（单位：帧，全部从 Sub3 的 t=0 起算）：60 → Sub6 发第一轮；
    ---Sub6 自己会在 +60 / +120 再各发一轮（photoIndex ≥ 3 才发）；Sub3 冻结到 240 才醒；
    ---再 60 帧（= 300）换 Sub7；再冻结 180 → 480 回到 t=0。
    local FIRST_DELAY = 60
    local REPEAT_GAP = 60
    local REPEAT_LIMIT = 3                  -- Sub6/Sub7 最多 3 轮（t=0/60/120）
    local DENSITY_MIN_PHOTOS = 3            -- ins_44(photoIndex, 3)：< 3 就跳过后续轮
    local PAUSE = 180                       -- Sub3 的 ins_2(180)（冻结 180 帧）

    ---从 (x,y) 甩出一整圈 count 发：基准角每圈重抽（原作的 ins_7(floatV0, rand(-π,π))）。
    ---整圈是对称的，TH095 的「顺时针为正」取反后方向集合不变 ⇒ 直接用 base + i*360/count。
    local function fire_ring(x, y, color, count, speed)
        local base = ran:Float(0, 360)
        for i = 0, count - 1 do
            NewSimpleBullet(STYLE, color, x, y, speed,
                    base + i * 360 / count, false, 0, false)
        end
    end

    ---Sub6 / Sub7 的一轮：四个角各一圈 + 本体一圈（顺序、发数、速度全照 dump）。
    local function fire_volley(owner, color, corner_count, body_count)
        for i = 1, #CORNERS do
            fire_ring(CORNERS[i][1], CORNERS[i][2], color, corner_count, CORNER_SPEED)
        end
        fire_ring(owner.x, owner.y, color, body_count, BODY_SPEED)
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整波只响一声。
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---一个发弹上下文（= Sub6 / Sub7）：立刻一轮，然后 t=60 / t=120 各再看一次
    ---「photoIndex ≥ 3 才补一轮」（ins_44 的 CMPlt 意思就是 < 3 时跳过）。
    ---★ 它必须**独立于 Sub3**跑：Sub3 在 t=60 之后被 ins_2 冻住，两个上下文是各跑各的。
    local function volley_context(owner, color, corner_count, body_count)
        task.New(owner, function()
            fire_volley(owner, color, corner_count, body_count)
            for _ = 2, REPEAT_LIMIT do
                task.Wait(REPEAT_GAP)
                if photo_index(PHOTO_LIMIT) >= DENSITY_MIN_PHOTOS then
                    fire_volley(owner, color, corner_count, body_count)
                end
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(BOSS_HOME_X, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130：亮卡名 + 起 Sub3（那两条演出我们交给符卡系统）。
            while true do
                task.Wait(FIRST_DELAY)
                volley_context(self, COLOR_A, 96, 68)   -- Sub6（红）
                task.Wait(PAUSE)
                task.Wait(FIRST_DELAY)
                volley_context(self, COLOR_B, 88, 68)   -- Sub7（灰）
                task.Wait(PAUSE)
            end
        end)
    end

    ---本体的逐帧逻辑：原作没有（发弹全在 ECL 上下文里）。留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "3a" } }, LEVEL, CARD_NAME, CARD_ID)
end--禁忌「フォービドゥンフルーツ」

do  -- 101 禁忌「禁じられた遊び」（ecl22_b，芙兰，组 3a 第 2 张）
    ---原作是「不许玩的游戏」：本体贴着中轴 y=0 在 ±48 的窄框里**左右躲**（自机的反方向），
    ---同时只有**一层**弹幕 —— 每 120 帧换一组朝向的**飞棍激光**（外加每波一颗大玉圈）。
---数据源 /tmp/E_ecl22_b.txt。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → **t=40** 就 ins_64(30,4,0,224) 落到 (0,224)（TH095
    ---    坐标 y 朝下 ⇒ 我们的 y = 0，正中央）；t=70 亮卡名 + ins_75(-48,224,48,224)
    ---    ⇒ 移动框就一条横线 x∈[-48,48]、y = 0（原作的 CLAMP_TO_MOVEMENT_BOUNDS 会夹住它）。
    ---  · Sub3（主脚本）：t=0 起 Sub7（装饰）与 Sub4（激光）、t=30 一声演出、
    ---    t=60 的 ins_51(pos.x, player.x) 是**浮点 ≥**（CMPfge，条件成立才跳，EclRunLow.inl
    ---    的比较表）：本体在自机右边就往左走（π），否则往右走（0），ins_66(60,0,角,0.5)
    ---    = 60 帧直线走 30 px；t=120 的 ins_4(0,-132) 跳回 t=30 ⇒ 一轮 **90 帧**
    ---    （走 60 帧 + 歇 30 帧）。x 轴不受坐标翻转影响，判据可以照抄。
    ---  · Sub4（激光，480 帧一轮）：t=0/120/240/360 各放 16 根 **type 12** 的旋转激光
    ---    （4 组 × 4 根；每组先 ins_38 设一个「漂移方向」（155 的最后两参 = 每帧位移），
    ---    组内 4 根的指向是十字 {π, 0, −π/2, π/2}、角速度 ±1.5°/帧）。第 4 波额外再放
    ---    8 根 type 12（长 96、维持 600 帧、角速度 −2°/+3°、漂移 = 朝自机 0.5 px/帧）。
    ---    每波还各甩 4 颗 type 17 大玉（`89(17,0,4,1,1,1.5,基准角,…)`，基准角 π/2 与 π/4 交替）。
    ---  · Sub5（每 10 帧一轮的 ins_87 = FAN 双扇）**在文件里从来没被调用**：
    ---    Sub3 只有 ins_117(0,7) 与 ins_117(1,4) 两条（= 装饰 Sub7 + 激光 Sub4），
    ---    Sub2 的 ins_52(3) 起的是 Sub3 —— 全文件再没有第三条指向 Sub5。
    ---    ⇒ 原作这里不发弹，移植版不实现（见下面「Sub5 是死代码」那段）。
    ---  · Sub6（54(2)+80(8)+81(16)）只动标志位、Sub7（106(5)+150(10)）是整屏装饰 ANM，
    ---    都跟弹幕无关，不实现。
    ---  · 弹型：type 3 → ball_small（半径 2）、type 13 → ball_mid（半径 4）、
    ---    type 17 → ball_huge（半径 13.5）。色号走文件头 ex_color()。
    ---  · 角度换算：TH095 顺时针为正、我们逆时针为正 ⇒ 指向角取反、角速度取反、
    ---    漂移向量按 (cos(−θ), sin(−θ)) 算；x 轴不变。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local HOME_X, HOME_Y = 0, field_y(224)              -- 0 / 0
    local ENTRY_WAIT, ENTRY_TIME = 40, 30
    local EASE_OUT = VALUE_SET.DECEL
    local BOX_L, BOX_R = -48, 48                        -- ins_75(-48,224,48,224)
    local MOVE_DELAY = 60                               -- Sub3 t=60 的第一次走位
    local MOVE_FRAMES = 60                              -- ins_66 的 N
    local MOVE_STEP = 30                                -- ins_66 的 speed × N = 0.5 × 60
    local MOVE_IDLE = 30                                -- 一轮 90 帧 = 走 60 + 歇 30

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "禁忌「禁じられた遊び」"
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 454

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的激光（卡结束时统一 RawDel，§7.9 第 9 条）。
    local lasers = {}

    ---type 12 的激光参数（155：满长起步、每帧长 8、宽 16、四段 20/20/220/10）。
    local LASER_INDEX = 12
    local LASER_LEN = 108
    local LASER_W = 16
    local LASER_SPEED = 8
    local LASER_STARTUP, LASER_GROW, LASER_SUSTAIN, LASER_FADE = 20, 20, 220, 10
    ---第 4 波那 8 根（长 96、维持 600）。
    local LASER2_LEN = 96
    local LASER2_SUSTAIN = 600
    local LASER2_AV = { -2, 3 }                         -- 度/帧（TH095 顺时针为正）
    ---四组基准漂移方向与角速度（单位：度/帧，TH095 坐标；见卡头注释的 dump 行号）。
    ---@type table<{dir:number, av:number}>
    local WAVES = {
        { { 90, 1.5 }, { -90, 1.5 }, { 0, -1.5 }, { 180, -1.5 } },
        { { 45, 1.5 }, { -135, 1.5 }, { -45, -1.5 }, { 135, -1.5 } },
        { { 90, -1.5 }, { -90, -1.5 }, { 0, 1.5 }, { 180, 1.5 } },
        { { 45, -1.5 }, { -135, -1.5 }, { -45, 1.5 }, { 135, 1.5 } },
    }
    local WAVE_GAP = 120
    local RING_BASE = { 90, 45, 90, 45 }                -- 每波大玉圈的基准角（TH095 度）
    local BIG_STYLE = ball_huge
    local BIG_COLOR = ex_color(0)                       -- 89(17, 0, …)
    local BIG_COUNT, BIG_SPEED = 4, 1.0
    ---组内 4 根的指向角（TH095 度）：十字。
    local CROSS = { 180, 0, -90, 90 }

    ---一波激光 + 一颗大玉圈。
    local function fire_wave(owner, w, ring_base)
        for _, g in ipairs(w) do
            local vx = cos(-g[1])                            -- 漂移 = ins_38(dir, 1)
            local vy = sin(-g[1])
            local av = -g[2]                                 -- 角速度取反
            for i = 1, #CROSS do
                spawn_ex_laser(owner, lasers, LASER_INDEX, owner.x, owner.y, -CROSS[i],
                        LASER_LEN, LASER_W, LASER_SPEED,
                        LASER_STARTUP, LASER_GROW, LASER_SUSTAIN, LASER_FADE,
                        av, vx, vy, false, true)
            end
        end
        ex_ring(BIG_STYLE, BIG_COLOR, owner.x, owner.y, BIG_COUNT, BIG_SPEED, -ring_base)
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---第 4 波额外的 8 根：漂移 = 朝自机 0.5 px/帧（ins_38(playerAngle, 0.5)）。
    local function fire_player_lasers(owner)
        local a = Angle(owner.x, owner.y, player.x, player.y)
        local vx, vy = 0.5 * cos(a), 0.5 * sin(a)
        for i = 1, #LASER2_AV do
            local av = -LASER2_AV[i]
            for k = 1, #CROSS do
                spawn_ex_laser(owner, lasers, LASER_INDEX, owner.x, owner.y, -CROSS[k],
                        LASER2_LEN, LASER_W, LASER_SPEED,
                        LASER_STARTUP, LASER_GROW, LASER2_SUSTAIN, LASER_FADE,
                        av, vx, vy, false, true)
            end
        end
    end

    ---Sub4：480 帧一轮，第 4 波多一组朝自机的 8 根。
    local function laser_context(owner)
        task.New(owner, function()
            while true do
                for i = 1, #WAVES do
                    if i > 1 then
                        task.Wait(WAVE_GAP)
                    end
                    fire_wave(owner, WAVES[i], RING_BASE[i])
                    if i == #WAVES then
                        fire_player_lasers(owner)
                    end
                end
                task.Wait(WAVE_GAP)
            end
        end)
    end

    ---Sub5（原文件里的「对自机 7 发 / 背自机 21 发」双扇）是**死代码**：Sub3 只调
    ---ins_117(0,7) 与 ins_117(1,4)（= 装饰 Sub7 + 激光 Sub4），全文件再没有第二条
    ---ins_117/ins_52 指向 Sub5（`grep id=117 /tmp/E_ecl22_b.txt` 只有 @760/@780 两行）
    ---⇒ 原作里这一层根本不会执行，移植时删掉（旧注释把它当成真发弹，已改正）。

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=70：亮卡名 + 起 Sub3。
            laser_context(self)
            task.Wait(MOVE_DELAY)
            while true do
                ---ins_51：本体在自机右边就往左走，否则往右走（总是躲开自机）。
                local dir = (self.x >= player.x) and 180 or 0
                local tx = max(BOX_L, min(BOX_R, self.x + MOVE_STEP * cos(dir)))
                task.MoveTo(tx, HOME_Y, MOVE_FRAMES, VALUE_SET.NORMAL)
                task.Wait(MOVE_IDLE)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
    end

    boss.card.add({ { card, "3a" } }, LEVEL, CARD_NAME, CARD_ID)
end--禁忌「禁じられた遊び」

do  -- 102 境符「色と空の境界」（ecl23_a，紫，组 4a 第 1 张）
    ---原作分前后两段，各由「128 根旋转激光」+「4 条扇弹上下文」组成；两段之间把角色
    ---在场上清一次再换一套（激光的旋向、扇的转法都反过来）。
---数据源 /tmp/E_ecl23_a.txt。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落到 (0,192)（我们的 (0,32)）、
    ---    ins_141(5) ⇒ 本卡要拍中 5 张；t=130 亮卡名 + ins_75 + ins_52(3) 起 Sub3。
    ---  · Sub3 全在 t=0、靠 ins_2 一节一节往下走，一轮 **980 帧**：
    ---      117(0,4) Sub4 → 等 150 → 117(0,6) Sub6 → 等 120
    ---      → 4 条 Sub7（扇）→ 等 110 → 演出 → 等 50 → 把 4 条全删 → 等 60
    ---      → 117(0,5) Sub5 → 等 150 → 117(0,6) Sub6 → 等 120
    ---      → 4 条 Sub8（随机扇）→ 等 110 → 演出 → 等 50 → 全删 → 等 60 → 跳回开头。
    ---  · Sub4 / Sub5 是同一套的镜像（角速度符号相反）：128 根 ins_147 旋转激光，
    ---    分两批各 64 根 —— 批量 1（type 7、色 5、四段 30/30/30/10、角速度 ±0.1758°/帧）
    ---    在角度 k×11.25°；批量 2（type 12、色 0、四段 60/30/30/10、角速度 ∓0.1758°/帧）
    ---    在 (k+0.5)×11.25°（Sub4 的 @1836 ins_5 回到 @1708；@2024 回到 @1896）。
    ---    参数照 ins_147：最大长 512、宽 16、followPhotoTarget = 1 ⇒ 每帧钉在本体上。
    ---  · Sub6 换成 ins_157（四段 50/10/10/4、最大长 512、角速度 ∓0.3516°/帧），
    ---    每轮两根：A 在 (k+0.5)×11.25°、B 在 (k+1)×11.25°；64 轮 ⇒ 128 根。
    ---    ★ 两段调的**是同一个 Sub6**（@788 与 @1196 都是 ins_117(0,6)）⇒ 旋向不翻。
    ---  · Sub7（每 2 帧一轮）：先 ins_38(floatV0, 32) 把出膛点挪到本体 32 px 外、ins_100 写进去，
    ---    floatV2 = floatV0 + floatV1，再 ins_87 = FAN 8 发（步进 10°、速 2.5）；
    ---    收尾 floatV0 += 6°、floatV1 −= 3.6°（所以扇角 = floatV0 + floatV1 每轮净转 +2.4°）。
    ---  · Sub8 同构，只是把扇换成 ins_94 = RANDOM：3 发、角度均匀落 [floatV2−22.5°, floatV2+22.5°]、
    ---    速度均匀 [1.5, 3.1]；收尾 floatV0 −= 6°、floatV1 −= 3.6°（净 −9.6°/轮）。
    ---  · ★ 四条子上下文**不是同一个上下文**：Sub3 在每次 ins_117 之前把 floatV0 设成
    ---    π/2、−π/2、0、π，而 ins_117 会把父上下文的**整份变量区**（PhotoEnemy.hpp:25-34 的
    ---    intVariables/floatVariables/extra*/callParameter* 正好 0x80 字节）memcpy 给子上下文
    ---    （EclRunTargetHigh.inl:206-240）⇒ 四条各自从不同的初值出发、之后互不影响。
    ---    （旧摘要把这条读成「float 不复制、从 0 起」，那是把 0x80 当成了 intVariables[8] 的大小。）
    ---  · 弹型 0 → ball_small（半径 2）。色 6 走 ex_color()。
    ---  · 原作的弹槽上限 640（BulletManager.cpp:310-345）：这张卡在原作里是**打满弹槽**的。
    ---    本仓库没有弹槽上限 ⇒ 稳态同屏弹数比原作高（实测里能看到），图案不变，见文件头差异 3。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 5                               -- ins_141(5)
    local CARD_NAME = "境符「色と空の境界」"
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 455

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    local lasers = {}

    ---激光（ins_147 / ins_157）的公共参数。
    local LASER_ROT = 11.25                              -- 每根之间的角距（0.19635 rad）
    local LASER_LEN, LASER_W = 512, 16
    local LASER_SPEED_147 = 8                            -- ins_147 每帧长 8
    local LASER_SPEED_157 = 5                            -- ins_157 每帧长 5
    local AV_147 = -0.1758                               -- 0.00306796 rad/帧（TH095 顺时针为正）
    local AV_157 = -0.3516                               -- 0.00613592 rad/帧

    ---一批 ins_147：count 根、从角度 (k + phase)×LASER_ROT 起、角速度 av。
    ---startup 要单独传：同一批里 type 7 是 30 帧、type 12 是 60 帧（见 lasers_4）。
    local function burst_147(owner, count, phase, index, av, startup)
        for k = 0, count - 1 do
            local a = (k + phase) * LASER_ROT
            spawn_ex_laser(owner, lasers, index, owner.x, owner.y, -a,
                    LASER_LEN, LASER_W, LASER_SPEED_147, startup, 30, 30, 10,
                    av, 0, 0, true, true)
        end
    end

    ---Sub4 / Sub5：两批 64 根（先 type 7 色 5 四段 30/30/30/10、再 type 12 色 0 四段 60/30/30/10）。
    ---角速度按「TH095 顺时针为正 ⇒ 我们取反」：
    ---  Sub4（sign = +1）原值 +0.1758 / −0.1758（type 7 / type 12）
    ---  Sub5（sign = −1）原值 −0.1758 / +0.1758  ⇒ 用 AV_147 = −0.1758 表达就是下表。
    local function lasers_4(owner, sign)
        burst_147(owner, 64, 0, 7, AV_147 * sign, 30)
        burst_147(owner, 64, 0.5, 12, -AV_147 * sign, 60)
    end

    ---Sub6：64 轮 × 2 根 ins_157（A 在 (k+0.5)×11.25°、B 在 (k+1)×11.25°）。
    ---★ 两段用的是**同一个 Sub6**（Sub3 两次都 ins_117(0,6)）⇒ 没有 sign，两段一模一样。
    ---原值：type 12 是 −0.3516°/帧、type 7 是 +0.3516°/帧 ⇒ 我们这边正负互换。
    local function lasers_6(owner)
        for k = 0, 63 do
            local a = (k + 0.5) * LASER_ROT
            spawn_ex_laser(owner, lasers, 12, owner.x, owner.y, -a,
                    LASER_LEN, LASER_W, LASER_SPEED_157, 50, 10, 10, 4,
                    -AV_157, 0, 0, true, true)
            a = (k + 1) * LASER_ROT
            spawn_ex_laser(owner, lasers, 7, owner.x, owner.y, -a,
                    LASER_LEN, LASER_W, LASER_SPEED_157, 50, 10, 10, 4,
                    AV_157, 0, 0, true, true)
        end
    end

    ---Sub7 / Sub8：4 条子上下文，初值 floatV0 = π/2、−π/2、0、π（见卡头注释）。
    local SPAWN_R = 32                                   -- ins_38 的 magnitude
    local FAN_STYLE, FAN_COLOR = ball_small, ex_color(6)
    local FAN_COUNT, FAN_SPEED, FAN_STEP_DEG = 8, 2.5, 10
    local FAN_OFFSETS = ex_fan_offsets(FAN_COUNT, FAN_STEP_DEG)
    local RND_STYLE, RND_COLOR = FAN_STYLE, FAN_COLOR
    local RND_COUNT, RND_SPEED1, RND_SPEED2 = 3, 3.1, 1.5
    local RND_HALF = 22.5                                -- 0.392699 rad
    local FAN_STEP = 6                                   -- 0.10472 rad
    local FAN_STEP1 = 3.6                                -- 0.0628319 rad
    local FAN_INTERVAL = 2                               -- ins_4(0,-156) 在 t=2
    ---四条子上下文的初值（TH095 弧度；见 Sub3 的 ins_7 序列）。
    local CHILD_INIT = { math.pi * 0.5, -math.pi * 0.5, 0, math.pi }

    local function start_fan_children(owner, random)
        local toks = {}
        for i = 1, #CHILD_INIT do
            local tok = { alive = true }
            toks[i] = tok
            task.New(owner, function()
                local fv0 = CHILD_INIT[i]                -- 相对角度（TH095 弧度）
                local fv1 = 0
                while tok.alive do
                    local fv2 = fv0 + fv1
                    ---ins_38 的 (cos,sin) 用**弧度**（fv0 是弧度）⇒ 换算成度再交给本仓库
                    ---角度制的 cos/sin（tools/check_stage.lua:324：sin/cos 是角度制）。
                    local ox = cos(-math.deg(fv0)) * SPAWN_R
                    local oy = sin(-math.deg(fv0)) * SPAWN_R
                    if random then
                        for _ = 1, RND_COUNT do
                            local r = ran:Float(0, 1)
                            local a_th = (fv2 - math.rad(RND_HALF))
                                    + math.rad(RND_HALF * 2) * r
                            local v = RND_SPEED2 + (RND_SPEED1 - RND_SPEED2) * ran:Float(0, 1)
                            NewSimpleBullet(RND_STYLE, RND_COLOR,
                                    owner.x + ox, owner.y + oy, v, -math.deg(a_th), false, 0, false)
                        end
                        fv0 = fv0 - math.rad(FAN_STEP)
                    else
                        for k = 1, #FAN_OFFSETS do
                            NewSimpleBullet(FAN_STYLE, FAN_COLOR,
                                    owner.x + ox, owner.y + oy, FAN_SPEED,
                                    -math.deg(fv2) - FAN_OFFSETS[k], false, 0, false)
                        end
                        fv0 = fv0 + math.rad(FAN_STEP)
                    end
                    fv1 = fv1 - math.rad(FAN_STEP1)
                    PlaySound("tan00", 0.1, owner.x / 256, false)
                    task.Wait(FAN_INTERVAL)
                end
            end)
        end
        return toks
    end

    local function stop_children(toks)
        for i = 1, #toks do
            toks[i].alive = false
        end
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130，起 Sub3。
            while true do
                lasers_4(self, 1)                     -- 第一批的旋向
                task.Wait(150)
                lasers_6(self)                        -- 两段共用、不翻
                task.Wait(120)
                local toks = start_fan_children(self, false)
                task.Wait(110)
                PlaySound("tan00", 0.1, self.x / 256, false)
                task.Wait(50)
                stop_children(toks)
                task.Wait(60)

                lasers_4(self, -1)                    -- 旋向反过来
                task.Wait(150)
                lasers_6(self)                        -- 同一份 Sub6
                task.Wait(120)
                toks = start_fan_children(self, true)
                task.Wait(110)
                PlaySound("tan00", 0.1, self.x / 256, false)
                task.Wait(50)
                stop_children(toks)
                task.Wait(60)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
    end

    boss.card.add({ { card, "4a" } }, LEVEL, CARD_NAME, CARD_ID)
end--境符「色と空の境界」

do  -- 103 境符「波と粒の境界」（ecl23_b，紫，组 4a 第 2 张）
    ---原作只有一件事：本体停在 (0,192)（我们的 (0,32)）不动，一条发弹上下文**每帧**甩
    ---一圈 **5 发**（半径 2 的小玉）。圈本身每帧被转过一个角度、而这个「每帧转角」又
    ---**每帧再加一点点** ⇒ 子弹被一层层铺成弯的「波」，也就是卡名的「波」与「粒」。
---数据源 /tmp/E_ecl23_b.txt。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落地、ins_141(6)；
    ---    t=130 亮卡名 + ins_75(-140,128,140,192) + ins_52(3) 起 Sub3。
    ---  · Sub3：t=0 设 floatV2 = 0.000654498 rad（= π/4800）并起 Sub4；之后只有两段
    ---    ins_2(180) 的空转（t=60 → t=120 → 跳回 t=60），**Sub4 只起这一次**、永远跑下去。
    ---  · Sub4（每帧一轮，ins_4(0,-160) 在 t=1 跳回 @916）：
    ---      floatV3 = photoIndex × 0.1 + 2.6          ← 弹速：拍得越多越快（2.6 → 3.2）
    ---      ins_91 = OFFSET_CIRCLE：5 发，角度 = π/5 + index1×2π/5 + floatV0
    ---      floatV0 += floatV1；floatV1 += floatV2     ← 圈每帧转 floatV1，floatV1 自己每帧涨
    ---    所以第 t 帧的「每帧转角」= t×π/4800，转角是**二次加速**的（4 分钟才到 180°/帧）。
    ---  · Sub5（102 清屏 + 把 floatV2 改成负的 + 重起 Sub4）在整份 ECL 里**没有任何
    ---    ins_117(·,5)** —— 是死代码，原作里从来没跑过（自己在文件里搜过一遍字节确认），
    ---    所以「加速度反向」这件事不会发生，不实现。
    ---  · 弹型 3 → ball_small（半径 2）；色 4 走 ex_color()。flags 514 = 0x202（出场音 + SPAWN_FAST，
    ---    出场滑动我们统一不做，见文件头差异 3）。
    ---  · 角度：OFFSET_CIRCLE 的一圈是对称的，但整圈的**相位** floatV0 会被取反，
    ---    所以照常按 −(π/5 + i×2π/5 + floatV0) 发。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "境符「波と粒の境界」"
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 456

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    local RING_COUNT = 5                                -- ins_91 的 count1
    local RING_STYLE = ball_small
    local RING_COLOR = ex_color(4)                      -- ins_91 的 color 4
    local SPEED_BASE, SPEED_PER_PHOTO = 2.6, 0.1        -- floatV3 = photoIndex×0.1 + 2.6
    local ACCEL = math.pi / 4800                        -- floatV2 = 0.000654498 rad/帧
    local STEP0 = math.pi * 0.5                         -- floatV0 的初值 π/2

    ---Sub4：每帧一圈，圈在转、转速自己还在涨。
    local function ring_stream(owner)
        task.New(owner, function()
            local fv0, fv1 = STEP0, 0
            local step = 2 * math.pi / RING_COUNT
            while true do
                local speed = SPEED_BASE + photo_index(PHOTO_LIMIT) * SPEED_PER_PHOTO
                for i = 0, RING_COUNT - 1 do
                    local a = math.pi / RING_COUNT + i * step + fv0
                    ---原作的 a 是 TH095 弧度（floatV0 初值 π/2、每帧 += π/4800）
                    ---⇒ 取反并转度后再交给角度制的 NewSimpleBullet。
                    NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y,
                            speed, -math.deg(a), false, 0, false)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                fv0 = fv0 + fv1
                fv1 = fv1 + ACCEL
                task.Wait(1)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130：起 Sub3 → 起 Sub4（只起这一次）。
            ring_stream(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "4a" } }, LEVEL, CARD_NAME, CARD_ID)
end--境符「波と粒の境界」

do  -- 104 貴人「サンジェルマンの忠告」（ecl24_a，妹红，组 5a 第 1 张）
    ---原作：本体在一条**浅横带**里来回瞬移，同时每 2 帧朝四周甩一圈「快慢双弹」。
    ---数据源 /tmp/E_ecl24_a.txt（ECL …/data/ecl24_a.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 用 30 帧落到 (0,192)
    ---    （我们的 (0,32)）；ins_141(10) ⇒ 要拍中 10 张；t=130 亮卡名 +
    ---    ins_75(-140,128,140,192) 把活动框设成 x∈[-140,140]、y∈[128,192]（我们的
    ---    y∈[32,96]）+ ins_52(3) 起 Sub3。
    ---  · Sub3（主脚本）一轮 180 帧：
    ---      t=0 起 Sub4（发弹上下文）；t=75 演出；t=90 先瞬移再**重开 Sub4**
    ---      （ins_117(0,4) 会把旧上下文删掉重建）；t=165 演出；t=180 再瞬移一次，
    ---      然后 ins_4(0,-592) 跳回 **t=0 的 ins_62**（@784）—— 跳回点在那两条 ins_7 之后，
    ---      所以 playerAngle 只在第一轮读一次（旧摘要读成「每轮重读」）。⇒ 每 90 帧
    ---      瞬移一次、并把 Sub4 重开一次（重开时才重读 photoIndex → 圈数每 90 帧才变）。
    ---  · 瞬移（ins_63 = SetPosition，带 ins_75 的活动框 clamp）：
    ---      t=90：x = rand×64 + (intV0 ? 124 : -188)、y = rand×64+128
    ---            ⇒ clamp 后 x 落在 ±140 两侧、y∈[128,192]；
    ---      t=180：x = randSigned×32、y = rand×64+128 ⇒ 回到中线附近。
    ---  · Sub4：**每 2 帧**一轮：
    ---      intV1 = photoIndex/2 + 11（拍得越多圈越密，11..16）；
    ---      ins_89(type 18、color 1、count1 = intV1、count2 = 2、speed1 = 4、speed2 = 1.5、
    ---             angleStep = 0) ⇒ 一圈 intV1 个方向，每个方向**两颗**（速 4.0 与 2.75）。
    ---      基角是 floatV0/floatV1 二选一（intV0 = randU31 % 2，进上下文时抽一次、定死），
    ---      两者每轮分别 −0.5°/+0.5°（TH095）⇒ 环在慢慢转；变量本身由 Sub3 在 t=90/t=180
    ---      加减 45°、甚至被位置量覆盖后再复用（见 main_script / teleport_mid 的注释）。
    ---      ★ Sub4 在 t=2 处有一条 ins_4(0,-224) 跳回自己的 t=0 —— 这条跳转**先**执行、
    ---        且把上下文时间重置为 0，所以 @1740 之后那一段（四角 96 发 + 本体 64 发）
    ---        是**死代码**，原作里从来不会执行（旧摘要把它当成了第二段发弹）。
    ---  · Sub5/Sub6/Sub7：ins_83(5)/83(6) 生出来的**装饰**敌人（ANM 8/9，Sub7 每帧跟随
    ---    photoTarget0），不发弹也不吃判定，按文件头差异 3 的口径不实现。
    ---  · 弹型 18 = 直径 6 ⇒ ball_small；color 1 = 红。flags 514 的出场滑动同差异 3。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local BOX_L, BOX_R = -140, 140                      -- ins_75 的 x 范围
    local BAND_LO, BAND_HI = 128, 192                   -- ins_75 的 y 范围（TH095）

    local PHOTO_LIMIT = 10                              -- ins_141(10)
    local CARD_NAME = "貴人「サンジェルマンの忠告」"
    ---原作卡计时 ins_114(10808)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 457

    ---──────────────────────── 弹幕 ────────────────────────

    local RING_STYLE, RING_COLOR = ball_small, ex_color(1)
    local RING_COUNT0 = 11                              -- intV1 = photoIndex/2 + 11
    local RING_SPEED1, RING_SPEED2 = 4, 1.5             -- count2 = 2 ⇒ 4.0 与 2.75
    local RING_GAP = 2                                  -- Sub4 的 ins_4(0,-224)
    local BLOCK = 90                                    -- Sub3 每 90 帧重开一次 Sub4

    ---一圈：count1 个方向 × 2 个速度（angleStep = 0 ⇒ 同一方向两颗），基准角 base。
    local function fire_ring(owner, count, base)
        local step = 360 / count
        local v2 = RING_SPEED1 - (RING_SPEED1 - RING_SPEED2) / 2
        for i = 0, count - 1 do
            local a = base + i * step
            NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y,
                    RING_SPEED1, a, false, 0, false)
            NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y,
                    v2, a, false, 0, false)
        end
    end

    ---t=90 的瞬移：随机选左右一侧（clamp 之后落到 ±140）。
    ---原作顺序是先抽 intV0 = randU31 % 2 决定方向、再抽两个 randF32 当坐标，照抄。
    local function teleport_side(owner)
        local side = (ran:Int(0, 1) == 0)
        local x = ran:Float(0, 64) + (side and -188 or 124)
        owner.x = max(BOX_L, min(BOX_R, x))
        owner.y = field_y(ran:Float(BAND_LO, BAND_HI))
    end

    ---t=180 的瞬移：中线附近。★ 原作的 floatV0/floatV1 在这里**被位置量覆盖**
    ---（randF32S×32 与 randF32×64+128，本来是 x/y 坐标），瞬移之后又拿它们 ±45° 当
    ---**下一轮的基角**用（EclRun 里 floatV0 就是普通 f32，没有类型）——所以把这两个
    ---残值原样返回给 main_script，别当成普通坐标丢掉。
    local function teleport_mid(owner)
        local px = ran:Float(-32, 32)           -- floatV0 = randF32S × 32（TH095 x）
        local py = ran:Float(BAND_LO, BAND_HI)  -- floatV1 = randF32 × 64 + 128（TH095 y）
        owner.x = max(BOX_L, min(BOX_R, px))
        owner.y = field_y(py)
        return px, py
    end

    ---一轮发弹上下文（= Sub3 两次 ins_117(0,4) 之间那 90 帧）：
    ---  · 圈数 intV1 = int(photoIndex / 2) + 11，**重开时才重读**；
    ---  · 基角在 floatV0 / floatV1 里二选一（intV0 = randU31 % 2，进上下文时抽一次、定死）；
    ---  · 每轮（2 帧）floatV0 −0.5°、floatV1 +0.5°（TH095 弧度 0.00872665）⇒ 环慢慢转。
    ---我们这边基角 = −(TH095 角)：floatV0 那一支每轮 +0.5°、floatV1 那一支 −0.5°。
    local RING_DRIFT = 0.5
    local function ring_block(owner, base0, base1)
        local count = math.floor(photo_index(PHOTO_LIMIT) / 2) + RING_COUNT0
        local use0 = (ran:Int(0, 1) == 0)
        local b0, b1 = base0, base1
        for _ = 1, BLOCK / RING_GAP do
            fire_ring(owner, count, use0 and b0 or b1)
            b0 = b0 + RING_DRIFT
            b1 = b1 - RING_DRIFT
            task.Wait(RING_GAP)
        end
    end

    ---Sub3：一轮 180 帧，t=0 / t=90 各起一次发弹上下文（后一次先瞬移、再把两个「角度变量」
    ---±45°，见 Sub3 @1108/@1144），t=180 瞬移 + 覆盖变量后 ins_4 跳回 t=0（@784，
    ---**跳过**开头那两句 floatV0 = floatV1 = playerAngle ⇒ 自机角只在第一轮读一次）。
    local function main_script(owner)
        task.New(owner, function()
            local f0 = Angle(owner.x, owner.y, player.x, player.y)   -- = −deg(floatV0)
            local f1 = f0                                            -- = −deg(floatV1)
            while true do
                ring_block(owner, f0, f1)            -- @784/@796：起 Sub4
                teleport_side(owner)                 -- @1056：t=90 瞬移
                f0, f1 = f0 + 45, f1 - 45            -- @1108/@1144：floatV0 −= 45°、floatV1 += 45°
                ring_block(owner, f0, f1)            -- @1180：重开 Sub4
                local px, py = teleport_mid(owner)   -- @1284：t=180 瞬移
                ---@1304/@1340：残值当角度再 ±45°（TH095 侧 −45/+45 ⇒ 我们 +45/−45）。
                f0 = -math.deg(px) + 45
                f1 = -math.deg(py) - 45
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "5a" } }, LEVEL, CARD_NAME, CARD_ID)
end--貴人「サンジェルマンの忠告」

do  -- 105 蓬莱「瑞江浦嶋子と五色の瑞亀」（ecl24_b，妹红，组 5a 第 2 张）
    ---原作：本体在一条浅带里慢慢挪，同时每 30 帧在「上移 32 px 的位置」上向**五**个方向
    ---抛出五色亀（Sub4 = 15 发 24° 等分环、Sub5 = 10 发 36° 等分环，各 5 种颜色）。
    ---数据源 /tmp/E_ecl24_b.txt（ECL …/data/ecl24_b.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,144) 落 (0,144)（我们的 (0,80)）；
    ---    ins_141(5) ⇒ 拍 5 张；t=130 亮卡名 + ins_75(-140,112,140,144)
    ---    （我们的活动框 x∈[-140,140]、y∈[80,112]）+ ins_52(3) 起 Sub3。
    ---  · Sub3 一轮 360 帧：起 Sub6（子上下文 slot 0）→ ins_2(120) → 演出 →
    ---    ins_2(200) → 杀掉 slot 0（ins_117(0,-1)）→ ins_67(40,4,1) 躲 40 帧 →
    ---    ins_4(0,-124) 跳回 t=0 的 ins_117(0,6)。⇒ 每轮 320 帧齐射 + 40 帧移动。
    ---  · Sub6 是 30 帧一轮的**子上下文**：
    ---      t=0：ins_26(floatV0, pos.y, 32) + ins_63(pos.x, floatV0) ⇒ floatV0 = pos.y − 32
    ---           再写回 pos.y（TH095 y 下正 ⇒ 屏幕上**上移** 32 px；我们坐标就是 +32）；
    ---           一轮结束时（@2884）用 ins_25 加回来。发弹用的 worldPosition 就是**移位后**的位置。
    ---      floatV0 = playerAngle；然后 **5 轮**（每轮末 floatV0 += 72°、ins_37 归一化）：
    ---        ins_38(eF0,eF1, floatV0, 40) + ins_100 ⇒ shootOffset = 40 px 外
    ---        ins_52(4) ⇒ 调 Sub4（15 发）；40→32 px + ins_52(5) ⇒ Sub5（10 发）；
    ---        32→72 px + ins_52(5) ⇒ Sub5 再来一次。5 轮 × 35 = **175 发 / 30 帧**。
    ---      ins_4(0,-1232) 跳回 @1716（t=0），一轮正好 30 帧。
    ---  · Sub4 / Sub5 的基角：**都是同一个 playerAngle**（floatV1 = playerAngle，5 次调用
    ---      之间只把 floatV1 **加 24°/36°**，见 @1048 起的 ins_15）—— 不是「每个方向换个基角」。
    ---      由于 ins_89 的 count2 = 1（angleStep 不参与），Sub4 的 5 次调用得到
    ---      {pa + 24×(photoIndex+k) + 120i}，k=0..4、i=0..2 恰好铺满 15 个连续的 24° 网格
    ---      （k+5i = 0..14）⇒ 整体就是「以自机角为 0° 的 15 发 24° 环」；Sub5 同理是
    ---      10 发 36° 环。photoIndex 只改起点、不改集合（15×24 = 10×36 = 360）。
    ---  · Sub7/Sub8/Sub9：ins_83(7)/83(8) 生出来的装饰敌人（Sub9 每帧跟随 photoTarget0），
    ---    不发弹 ⇒ 按文件头差异 3 不实现。
    ---  · 弹型：Sub4 的 (19,6)(12,0)(19,1)(19,3)(12,7) → 半径 3/5/3/3/5（19→ball_small、
    ---    12→ball_mid）；Sub5 全是型 1（半径 3 → ball_small），色 13,0,2,6,15。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(144)              -- 0 / 80
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local BOX_L, BOX_R = -140, 140                      -- ins_75 的 x 范围
    local BOX_LO, BOX_HI = 112, 144                     -- ins_75 的 y 范围（TH095）

    local PHOTO_LIMIT = 5                               -- ins_141(5)
    local CARD_NAME = "蓬莱「瑞江浦嶋子と五色の瑞亀」"
    ---原作卡计时 ins_114(7208)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 458

    ---──────────────────────── 弹幕 ────────────────────────

    ---Sub4 的 5 次 ins_89：(弹型, 色)。半径 5 的型 12 用 ball_mid，其余（半径 3）用 ball_small。
    local TURTLE4 = { { 19, 6 }, { 12, 0 }, { 19, 1 }, { 19, 3 }, { 12, 7 } }
    local TURTLE5_COLOR = { 13, 0, 2, 6, 15 }
    local SUB4_SPEED, SUB5_SPEED = 1.5, 2               -- count2 = 1 ⇒ speed1
    local SUB4_STEP, SUB5_STEP = 24, 36                 -- 0.418879 / 0.628319 rad
    local DISPLACE = 32                                 -- ins_26 的 32

    ---Sub4：5 次（每次 24° 基角步进）× 3 发（120° 等分）= 15 发。
    local function fire_sub4(x, y, pa, pi)
        for k = 0, 4 do
            local st, co = TURTLE4[k + 1][1], TURTLE4[k + 1][2]
            local style = (st == 12) and ball_mid or ball_small
            local b = pa - SUB4_STEP * (pi + k)
            for i = 0, 2 do
                NewSimpleBullet(style, ex_color(co), x, y, SUB4_SPEED,
                        b - 120 * i, false, 0, false)
            end
        end
    end

    ---Sub5：5 次（每次 36° 基角步进）× 2 发（180° 对射）= 10 发。
    local function fire_sub5(x, y, pa, pi)
        for k = 0, 4 do
            local b = pa - SUB5_STEP * (pi + k)
            for i = 0, 1 do
                NewSimpleBullet(ball_small, ex_color(TURTLE5_COLOR[k + 1]), x, y,
                        SUB5_SPEED, b - 180 * i, false, 0, false)
            end
        end
    end

    ---Sub6：30 帧一轮，从本体上方 32 px 处向 3 个方向各甩 Sub4 + 2×Sub5。
    local function sub6(owner, tok)
        task.New(owner, function()
            while tok.alive do
                local ox, oy = owner.x, owner.y + DISPLACE
                local pa = Angle(ox, oy, player.x, player.y)
                local pi = photo_index(PHOTO_LIMIT)
                ---★ 原作是 **5 轮**（@1972/@2200/@2428/@2656 各一次 floatV0 += 72°，
                ---第 5 轮 @2692 之后就直接收尾了）⇒ j = 0..4，一圈 5 × 72° = 360°。
                for j = 0, 4 do
                    local dir = pa - 72 * j
                    local cx, cy = cos(dir), sin(dir)
                    fire_sub4(ox + 40 * cx, oy + 40 * cy, pa, pi)
                    fire_sub5(ox + 32 * cx, oy + 32 * cy, pa, pi)
                    fire_sub5(ox + 72 * cx, oy + 72 * cy, pa, pi)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                task.Wait(30)
            end
        end)
    end

    ---ins_67(40,4,1) = BeginBoundaryAwareMove（EclDependencies.cpp:108）：
    ---先随机挑一个「背离自机」的方向（TH095 弧度、顺时针为正），再按活动框的四条边界
    ---规则修正，最后 40 帧走 speed×duration = 40 px、缓动 4（= 我们的 DECEL）。
    ---活动框只有 32 px 高 ⇒ 两条 y 规则**恒成立**，净效果是把角度强制成负的（朝屏幕上方）。
    local function boundary_move(owner)
        local a
        if player.x < owner.x then
            a = ran:Float(0, math.pi / 2) + 3 * math.pi / 4
        else
            a = ran:Float(0, math.pi / 2) - math.pi / 4
        end
        ---原代码在 x 右边界那一条里用的是 enemy->movementAngle（不是 angle）——照抄。
        local ma = owner.ex_move_angle or 0
        if owner.x < BOX_L + 96 then
            if a > math.pi / 2 then
                a = math.pi - a
            elseif a < -math.pi / 2 then
                a = -math.pi - a
            end
        end
        if owner.x > BOX_R - 96 then
            if a < math.pi / 2 and a >= 0 then
                a = math.pi - ma
            elseif a > -math.pi / 2 and a <= 0 then
                a = -math.pi - a
            end
        end
        local yth = field_y(owner.y)
        if yth < BOX_LO + 48 and a < 0 then
            a = -a
        end
        if yth > BOX_HI - 48 and a > 0 then
            a = -a
        end
        owner.ex_move_angle = a
        local deg = -math.deg(a)                        -- 我们坐标的角度（度）
        task.MoveTo(owner.x + 40 * cos(deg), owner.y + 40 * sin(deg), 40, VALUE_SET.DECEL)
    end

    ---Sub3：每 320 帧齐射 + 40 帧移动，一轮 360 帧。
    local function main_script(owner)
        task.New(owner, function()
            while true do
                local tok = { alive = true }
                sub6(owner, tok)
                task.Wait(320)
                tok.alive = false
                boundary_move(owner)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "5a" } }, LEVEL, CARD_NAME, CARD_ID)
end--蓬莱「瑞江浦嶋子と五色の瑞亀」

do  -- 106 鬼気「濛々迷霧」（ecl25_a，萃香，组 6a 第 1 张）
    ---原作：萃香连续朝自机突进（每 60 帧一次、一次 120 px），沿途撒「雾滴」（几乎不动的小弹），
    ---并把 12 颗会**沿途加速**的大玉一圈圈甩出去。
    ---数据源 /tmp/E_ecl25_a.txt（ECL …/data/ecl25_a.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落 (0,192)（我们的 (0,32)）；
    ---    ins_141(3) ⇒ 拍 3 张；t=130 亮卡名 + ins_52(3) 起 Sub3。**没有 ins_75**（不设活动框）。
    ---  · Sub3（主脚本）：
    ---      t=0 起 Sub5（装饰脉冲，子槽 7）；t=40 演出；
    ---      t=70 起 Sub4（子槽 0，发雾滴）+ ins_143 + extraIntV0=30；
    ---      然后 ins_5 循环 **30 次**：`66(60,1,playerAngle,2)` = 60 帧内朝自机走
    ---        speed×duration = 120 px（缓动 1 = 线性）。
    ---      循环退出后（@888，t=130）起 Sub6（子槽 1，每帧一声脉冲音）+ 再突进一次（@908）；
    ---      t=190（即 60 帧后）把 Sub4 **换成 Sub7**（ins_117(0,7) 删旧建新）并杀掉 Sub6；
    ---      t=370 / t=410 演出；t=440 重新起 Sub4 + extraIntV0=15，
    ---      再 ins_5 循环 15 次突进（900 帧）；
    ---      ins_4(130,-276) 跳回 **@888**（那一次突进），t=130 —— 这就是外层循环。
    ---      ⇒ 首轮 30 次突进（1800 帧）只为开场；此后一轮 = 1 次突进 + 60 + 180 + 40 + 30
    ---        + 15 次突进 = **1210 帧**。
    ---  · Sub4（子槽 0，每帧一轮）：eF0 = 64×randSigned、方向 rand(−π,π) ⇒ 出膛点落在
    ---    离本体 ≤64 px 的圆里；弹角又一次 rand(−π,π)，速 0.05、型 3 色 6（半径 2 → ball_small、蓝）。
    ---    ins_100(0,0) 收尾，ins_4(0,-136) 每帧跳回。flags 520 的出场滑动同差异 3。
    ---  · Sub7（子槽 0，每 60 帧一轮）：先 ins_101(0,16,0,120,-1,0.025,-999) 往变换槽 0 装一条
    ---    ACCEL_VECTOR；然后 ins_89(型 17、色 1、count1=12、count2=1、速 1）甩一圈 12 颗大玉
    ---    （半径 14 → ball_huge）。子弹 flags 536 = 0x218 命中这条变换 ⇒ 之后 120 帧里
    ---    每帧 speed += 0.025（BulletManager.cpp:803-815 的 UpdateVectorAcceleration），
    ---    方向取弹自己的 angle ⇒ 沿原方向一路加速（速 1 → 4）。
    ---  · Sub5/Sub6（子槽 7/1）只做 ANM 脉冲与音效 ⇒ 不实现（文件头差异 3）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 3                               -- ins_141(3)
    local CARD_NAME = "鬼気「濛々迷霧」"
    ---原作卡计时 ins_114(12608)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 459

    ---──────────────────────── 弹幕 ────────────────────────

    local SUB3_LEAD = 70                                -- Sub3 t=0 → t=70 才起 Sub4 / 第一次突进
    local DASH_FRAMES, DASH_SPEED = 60, 2               -- ins_66(60,1,pa,2) ⇒ 120 px
    local MIST_R, MIST_SPEED = 64, 0.05                 -- Sub4：偏移半径 / 弹速
    local MIST_STYLE, MIST_COLOR = ball_small, ex_color(6)
    local BIG_STYLE, BIG_COLOR = ball_huge, ex_color(1)
    local BIG_COUNT, BIG_SPEED = 12, 1                  -- Sub7 的 ins_89
    local BIG_GAP = 60                                  -- Sub7 的 ins_4(0,-80)
    local ACCEL_STEP, ACCEL_FRAMES = 0.025, 120         -- ins_101 的 f0 / int0

    ---Sub4：每帧一颗雾滴（出膛点随机、方向随机、几乎不动）。
    local function sub4(owner, tok)
        task.New(owner, function()
            while tok.alive do
                local m = ran:Float(-MIST_R, MIST_R)
                local th = ran:Float(-math.pi, math.pi)
                local ba = ran:Float(-math.pi, math.pi)
                NewSimpleBullet(MIST_STYLE, MIST_COLOR,
                        owner.x + m * math.cos(th), owner.y - m * math.sin(th),
                        MIST_SPEED, -math.deg(ba), false, 0, false)
                task.Wait(1)
            end
        end)
    end

    ---Sub7 的子弹加速：前 120 帧每帧 +0.025（沿弹自己的 angle）。
    local function big_accel_frame(self)
        local n = self.ex_accel or 0
        if n < ACCEL_FRAMES then
            self.ex_accel = n + 1
            local v = (self.ex_vel or BIG_SPEED) + ACCEL_STEP
            self.ex_vel = v
            object.SetV(self, v, self.rot, true)
        end
    end

    ---Sub7：每 60 帧一圈 12 颗加速大玉（基角 rand(−π,π) ⇒ 30° 网格的随机朝向）。
    local function sub7(owner, tok)
        task.New(owner, function()
            while tok.alive do
                local base = ran:Float(0, 360)
                for i = 0, BIG_COUNT - 1 do
                    NewSimpleBullet(BIG_STYLE, BIG_COLOR, owner.x, owner.y, BIG_SPEED,
                            base + i * 360 / BIG_COUNT, false, 0, false,
                            nil, nil, nil, big_accel_frame)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                task.Wait(BIG_GAP)
            end
        end)
    end

    ---一次突进：60 帧、直线 120 px、朝当时的自机角。
    local function dash(owner)
        local a = Angle(owner.x, owner.y, player.x, player.y)
        task.MoveTo(owner.x + DASH_FRAMES * DASH_SPEED * cos(a),
                owner.y + DASH_FRAMES * DASH_SPEED * sin(a), DASH_FRAMES, VALUE_SET.NORMAL)
    end

    ---Sub3：首轮 30 次突进；之后进入 1210 帧的外层循环。
    local tok4, tok7
    local function main_script(owner)
        task.New(owner, function()
            ---Sub3 自己的时间轴：t=0 起 Sub5（装饰）、t=40 演出、t=70 才起 Sub4 与第一次突进。
            task.Wait(SUB3_LEAD)
            tok4 = { alive = true }
            sub4(owner, tok4)
            for _ = 1, 30 do
                dash(owner)
            end
            while true do
                dash(owner)                             -- @908：循环开头那次突进（60 帧）
                ---@948：Sub4 换成 Sub7（在突进结束的同一刻）。
                tok4.alive = false
                tok7 = { alive = true }
                sub7(owner, tok7)
                ---t=190 → t=440：180 + 40 + 30 帧的空档。
                task.Wait(250)
                ---@1060/@1080：Sub4 重新起、Sub7 收掉，然后是 15 次突进。
                tok7.alive = false
                tok4 = { alive = true }
                sub4(owner, tok4)
                for _ = 1, 15 do
                    dash(owner)
                end
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        if tok4 then tok4.alive = false end
        if tok7 then tok7.alive = false end
    end

    boss.card.add({ { card, "6a" } }, LEVEL, CARD_NAME, CARD_ID)
end--鬼気「濛々迷霧」

do  -- 107 「百万鬼夜行」（ecl25_b，萃香，组 6a 第 2 张）
    ---原作：本体每隔 120 帧躲一次（拍中 2 张以上才躲），同时六条子上下文按**拍照进度**
    ---逐条解锁的弹幕（拍得越多越密）。
    ---数据源 /tmp/E_ecl25_b.txt（ECL …/data/ecl25_b.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落 (0,192)（我们的 (0,32)）；
    ---    ins_141(10) ⇒ 拍 10 张；t=130 亮卡名 + ins_75(-140,128,140,192)
    ---    （我们的活动框 x∈[-140,140]、y∈[32,96]）+ ins_52(3) 起 Sub3。
    ---  · Sub3：t=0 起 Sub11（每帧一声脉冲音，装饰）；t=60 起 Sub4..Sub9（六条发弹上下文，
    ---    只起这一次、之后一直跑）；t=60 的 `ins_44(photoIndex,2,60,52)` 是 **CMPlt**：
    ---    photoIndex < 2 就跳过这一轮的 ins_67(60,4,0.8)；ins_4(60,-228) 每 120 帧跳回
    ---    那句 ins_44（t=60）。⇒ 一轮 120 帧、只有「拍中 ≥2 张」才会躲
    ---    （ins_67 的 60 帧走位就占这一轮的头 60 帧，task.MoveTo 是阻塞的）。
    ---  · Sub4（每 24 帧一轮）：**没有闸**，一上来就发（@1012 之后直接是 @1032 的随机半径，
    ---    全段没有 ins_44）；每轮 6 次「随机出膛点（半径 16×rand）+ ins_89(型 19、色 3、
    ---    count1=3、count2=1、速 1)」= 18 发；收尾 floatV0 += 18°（跳回点是 @1032、
    ---    **跳过**开头的 ins_7 rand ⇒ 基角持续累加）。
    ---  · Sub7 同构，只是色 1、速 2；**它有闸**（@2048 的 `ins_44(photoIndex,6,0,744)`）——
    ---    跳转目标 @2792 正是收尾的 `ins_15(floatV0, 0.314159)`，所以 photoIndex < 6 时
    ---    整轮发弹被跳过、但 18° 照样累加。
    ---  · Sub6（每 20 帧）：ins_91 = OFFSET_CIRCLE、型 3、色 6、count1=32、速 2。
    ---  · Sub8（t=10 起每 20 帧）：`ins_44(photoIndex,4,…)` 闸 ⇒ photoIndex ≥ 4 才有
    ---    ins_91（型 3、色 2、速 2、32 发）。
    ---  · Sub9（t=120 起每 20 帧）：`ins_44(photoIndex,8,…)` 闸 ⇒ photoIndex ≥ 8 才有
    ---    ins_88 = CIRCLE_AIMED（型 19、色 1、速 2、32 发）。
    ---  · Sub5（t=90 起每 60 帧）：ins_88 = CIRCLE_AIMED（型 12、色 3、速 1、32 发）。
    ---  · 32 发的整圈（360/32 = 11.25°）在取反后**方向集合不变**；OFFSET_CIRCLE 多出的
    ---    π/count1 = 5.625° 相位也正好落在同一网格上（−5.625 ≡ 5.625 + 11.25×31）。
    ---  · 弹型：12（半径 5）→ ball_mid；3/19（半径 2/3）→ ball_small。
    ---  · Sub10/Sub11 的 150(17)/150(18) 是 ANM 脉冲 ⇒ 不实现（文件头差异 3）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local BOX_L, BOX_R = -140, 140                      -- ins_75 的 x 范围
    local BOX_LO, BOX_HI = 128, 192                     -- ins_75 的 y 范围（TH095）

    local PHOTO_LIMIT = 10                              -- ins_141(10)
    local CARD_NAME = "「百万鬼夜行」"
    ---原作卡计时 ins_114(12008)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 460

    ---──────────────────────── 弹幕 ────────────────────────

    local MOVE_GAP = 120                                -- Sub3 的 ins_4(60,-228)
    local MOVE_MIN_PHOTOS = 2                           -- ins_44(photoIndex, 2)
    local MOVE_FRAMES, MOVE_SPEED = 60, 0.8             -- ins_67(60,4,0.8) ⇒ 48 px

    local BURST_N = 6                                   -- Sub4/Sub7 每轮的出膛点数
    local BURST_R = 16                                  -- eF0 = 16 × randF32
    local BURST_GAP = 24                                -- Sub4/Sub7 的 ins_4(0,-xxx)
    local BURST_STEP = 18                               -- 收尾 floatV0 += 0.314159（18°）
    local DENSITY_A = 6                                 -- ins_44(photoIndex, 6)：Sub4/Sub7
    local DENSITY_B = 4                                 -- ins_44(photoIndex, 4)：Sub8
    local DENSITY_C = 8                                 -- ins_44(photoIndex, 8)：Sub9

    local RING_N = 32                                   -- ins_88/91 的 count1
    local RING_STEP = 360 / RING_N                      -- 11.25°
    local OFFSET_PHASE = 180 / RING_N                   -- OFFSET_CIRCLE 的 π/count1

    ---一次 ins_89「count1=3、count2=1」：3 发 120° 等分环。
    local function fire_three(style, color, speed, x, y, base_deg)
        for i = 0, 2 do
            NewSimpleBullet(style, color, x, y, speed, base_deg - 120 * i, false, 0, false)
        end
    end

    ---Sub4 / Sub7：每 24 帧一轮，6 个随机出膛点各甩一个 3 发环。
    ---gate = nil ⇒ 无闸（Sub4），否则 photoIndex ≥ gate 才发（Sub7 = 6）。
    local function burst_stream(owner, tok, style, color, speed, gate)
        task.New(owner, function()
            local fv0 = ran:Float(-math.pi, math.pi)    -- 只在最开始抽一次
            while tok.alive do
                if not gate or photo_index(PHOTO_LIMIT) >= gate then
                    local b = -math.deg(fv0)
                    for _ = 1, BURST_N do
                        local m = ran:Float(0, BURST_R)
                        local th = ran:Float(-math.pi, math.pi)
                        fire_three(style, color, speed,
                                owner.x + m * math.cos(th), owner.y - m * math.sin(th), b)
                    end
                end
                fv0 = fv0 + math.rad(BURST_STEP)
                task.Wait(BURST_GAP)
            end
        end)
    end

    ---ins_88/91 的 32 发整圈：aimed = true 走 CIRCLE_AIMED（基角 = 自机角），
    ---false 走 OFFSET_CIRCLE（多 5.625° 相位）。
    local function ring_stream(owner, tok, style, color, speed, gap, first, aimed, gate)
        task.New(owner, function()
            if first > 0 then
                task.Wait(first)
            end
            while tok.alive do
                if not gate or photo_index(PHOTO_LIMIT) >= gate then
                    local base = aimed and Angle(owner.x, owner.y, player.x, player.y) or 0
                    for i = 0, RING_N - 1 do
                        local ph = aimed and 0 or OFFSET_PHASE
                        NewSimpleBullet(style, color, owner.x, owner.y, speed,
                                base + ph + i * RING_STEP, false, 0, false)
                    end
                    PlaySound("tan00", 0.1, owner.x / 256, false)
                end
                task.Wait(gap)
            end
        end)
    end

    ---ins_67(60,4,0.8) = BeginBoundaryAwareMove（EclDependencies.cpp:108）：
    ---先挑「背离自机」的随机方向（TH095 弧度），再按活动框边界修正，60 帧走 48 px、缓动 4。
    local function boundary_move(owner)
        local a
        if player.x < owner.x then
            a = ran:Float(0, math.pi / 2) + 3 * math.pi / 4
        else
            a = ran:Float(0, math.pi / 2) - math.pi / 4
        end
        ---原代码在 x 右边界那一条里用的是 enemy->movementAngle（不是 angle）——照抄。
        local ma = owner.ex_move_angle or 0
        if owner.x < BOX_L + 96 then
            if a > math.pi / 2 then
                a = math.pi - a
            elseif a < -math.pi / 2 then
                a = -math.pi - a
            end
        end
        if owner.x > BOX_R - 96 then
            if a < math.pi / 2 and a >= 0 then
                a = math.pi - ma
            elseif a > -math.pi / 2 and a <= 0 then
                a = -math.pi - a
            end
        end
        local yth = field_y(owner.y)
        if yth < BOX_LO + 48 and a < 0 then
            a = -a
        end
        if yth > BOX_HI - 48 and a > 0 then
            a = -a
        end
        owner.ex_move_angle = a
        local deg = -math.deg(a)
        task.MoveTo(owner.x + MOVE_FRAMES * MOVE_SPEED * cos(deg),
                owner.y + MOVE_FRAMES * MOVE_SPEED * sin(deg), MOVE_FRAMES, VALUE_SET.DECEL)
    end

    ---Sub3：起六条上下文；每 120 帧按拍照进度躲一次。
    local toks = {}
    local function main_script(owner)
        task.New(owner, function()
            ---t=60：Sub4..Sub9。
            ---Sub4 **没有闸**（它的 @1032 之后没有 ins_44）⇒ 一直发，不传 gate。
            toks[1] = { alive = true }; burst_stream(owner, toks[1], ball_small, ex_color(3), 1, nil)
            toks[2] = { alive = true }; ring_stream(owner, toks[2], ball_mid, ex_color(3), 1, 60, 90, true, nil)
            toks[3] = { alive = true }; ring_stream(owner, toks[3], ball_small, ex_color(6), 2, 20, 0, false, nil)
            toks[4] = { alive = true }; burst_stream(owner, toks[4], ball_small, ex_color(1), 2, DENSITY_A)
            toks[5] = { alive = true }; ring_stream(owner, toks[5], ball_small, ex_color(2), 2, 20, 10, false, DENSITY_B)
            toks[6] = { alive = true }; ring_stream(owner, toks[6], ball_small, ex_color(1), 2, 20, 120, true, DENSITY_C)
            while true do
                if photo_index(PHOTO_LIMIT) >= MOVE_MIN_PHOTOS then
                    ---ins_67 的移动占一轮的头 60 帧（ins_4 在 t=180 才跳回）。
                    boundary_move(owner)
                    task.Wait(MOVE_GAP / 2)
                else
                    task.Wait(MOVE_GAP)
                end
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = 1, #toks do
            toks[i].alive = false
        end
    end

    boss.card.add({ { card, "6a" } }, LEVEL, CARD_NAME, CARD_ID)
end--「百万鬼夜行」
