# TH31–TH35 剩余特殊回调、使魔出屏与激光联动核对

基线 `b3a097c`，接续 [上一批逐卡报告](MOTION_LASER_REVIEW_EDGE_CASES_2026-11-04.md)。本轮确认修复7组差异，关联33个注册条目。只做源码和文本结构审阅；按要求未运行测试、游戏、模拟、探针、Lua、编译或构建。

## 具体差异

| 编号 | 条目 | 原差异 | 修复 |
| --- | --- | --- | --- |
| S01 | TH32：3922、3924、3929、3931、3936、3938、3943、3945；帕秋莉八段非符：激光联动发弹纵向偏移 | Func12沿激光方向偏移64px时使用b.y+sin(angle)*64，纵轴翻转漏取负号，弹口落在激光的镜像方向。 | 按原作旋转向量换算为b.y-sin(angle)*64。八段非符共用同一Func12出口，不改旋转、发数与间隔。 |
| S02 | TH32：3974、4000、4001、4002、4003、4004、4005、4006、4007、4008、4009、4010、4012、4013；普通敌机与笼中鸟使魔：出屏回收使用错误尺寸 | H.actor_motion固定按屏外32px延伸框判进入/出屏。原作使用当前主ANM精灵全宽高的一半：普通妖精常为30×30；笼中鸟Sub45的芙兰图为64×80。会推迟普通敌机停火，或提前结束纵向飞出的使魔。 | 从当前ANM主精灵取半宽/半高，保留先Move/Clamp、再出屏回收、再运行ECL的顺序以及hasBeenInBounds守卫。不使用受击框或显示缩放。无主精灵时保留旧兜底，未据此声称未绑定图的路径通过。 |
| S03 | TH32：3965；皇家烈焰：特殊发弹意外回写本体描述符 | Func13用a.pattern原表设置每路angle，改变了本体保存的发弹描述符。原作先复制EnemyShooter，只改局部副本。 | 在该次特殊发弹中复制描述符，并将副本显式传给H.fire。本体描述符、每六帧触发及3/5/6/5路顺序保持。 |
| S04 | TH32：369、3808、3910、3955、3957、3974；完美冻结、时停、吸血鬼幻想、红色幻想乡、笼中鸟：消散弹仍参与特殊回调 | 消弹后对象在原弹槽中继续播无判定消散动画，IsValid仍为真。Func0/4/8/9/11/15把它们当活弹，继续换色、抽随机数、转向或从消散大玉生成小玉。 | 另设active_bullet用于这些原作明确排除DESPAWNING的扫描；保留alive作为槽占用判断。消散对象仍占槽，不提前增加可发弹容量。 |
| S05 | TH33：476；死价：追踪重瞄周期及发弹前运动 | 循环虽写两帧，却在两次迭代内各取一次自机角，变成每帧重瞄；主context还直接改xy，使后续子context枪读取积分后位置。 | 两帧共用一次方向和速度快照；每帧只提交运动目标，由既有注册出口在全部枪执行后积分。 |
| S06 | TH34：4448；灵车协奏曲怪：公转与激光跟随顺序 | 公转协程先改xy再运行激光控制，激光从本帧移动后位置跟随；加速协程随后才增加角速度，公转晚一帧使用新角速度。第二条MOVE_ORBIT的角度/半径重设也被连续近似替代。 | 将公转求值放到bframe的运动阶段，全部ECL枪与激光控制完成后才写xy并记录movementAngle。第二条MOVE_ORBIT显式重设角/半径/径向速度；本帧写入的角速度立即参与同帧公转。激光角按原值和归一规则更新。 |
| S07 | TH34：4433、4447、4448、4476；奥尔良人形分裂与激光改向：消散对象状态过滤 | 分裂回调与激光反射/沿激光改向回调只用IsValid判断，继续拆分或反射正在消散的弹；原作ExIns6/7/8明确跳过DESPAWN。 | 仅为ExIns6分裂以及ExIns7/8的弹扫描加消散过滤；不修改弹槽容量或生命周期。妖梦和幽幽子其他只排除INACTIVE的回调保留原规则。 |

## 逐卡修正索引

| 文件 | ID | 符卡/非符 | 修正 |
| --- | ---: | --- | --- |
| TH32 | 369 | 「红色的幻想乡」（Lunatic） | S04 |
| TH32 | 3808 | 神术「吸血鬼幻想」（Lunatic） | S04 |
| TH32 | 3910 | 冻符「完美冻结」（Lunatic） | S04 |
| TH32 | 3922 | 帕秋莉 非符一（Lunatic·灵梦Ａ） | S01 |
| TH32 | 3924 | 帕秋莉 非符二（Lunatic·灵梦Ａ） | S01 |
| TH32 | 3929 | 帕秋莉 非符一（Lunatic·灵梦Ｂ） | S01 |
| TH32 | 3931 | 帕秋莉 非符二（Lunatic·灵梦Ｂ） | S01 |
| TH32 | 3936 | 帕秋莉 非符一（Lunatic·魔理沙Ａ） | S01 |
| TH32 | 3938 | 帕秋莉 非符二（Lunatic·魔理沙Ａ） | S01 |
| TH32 | 3943 | 帕秋莉 非符一（Lunatic·魔理沙Ｂ） | S01 |
| TH32 | 3945 | 帕秋莉 非符二（Lunatic·魔理沙Ｂ） | S01 |
| TH32 | 3955 | 幻世「世界」（Lunatic） | S04 |
| TH32 | 3957 | 女仆秘技「杀人玩偶」（Lunatic） | S04 |
| TH32 | 3965 | 日符「皇家烈焰」（Extra） | S03 |
| TH32 | 3974 | 禁忌「笼中鸟」（Extra） | S02 / S04 |
| TH32 | 4000 | 一面道中·前半 | S02 |
| TH32 | 4001 | 一面道中·后半 | S02 |
| TH32 | 4002 | 二面道中·前半 | S02 |
| TH32 | 4003 | 二面道中·后半 | S02 |
| TH32 | 4004 | 三面道中·前半 | S02 |
| TH32 | 4005 | 三面道中·后半 | S02 |
| TH32 | 4006 | 四面道中·前半 | S02 |
| TH32 | 4007 | 四面道中·后半 | S02 |
| TH32 | 4008 | 五面道中·前半 | S02 |
| TH32 | 4009 | 五面道中·后半 | S02 |
| TH32 | 4010 | 六面道中·前半 | S02 |
| TH32 | 4012 | Extra道中·前半 | S02 |
| TH32 | 4013 | Extra道中·后半 | S02 |
| TH33 | 476 | 死価「プライス・オブ・ライフ」 | S05 |
| TH34 | 4433 | 蒼符「博愛のオルレアン人形」 | S07 |
| TH34 | 4447 | 騒葬「スティジャンリバーサイド -Lunatic-」 | S07 |
| TH34 | 4448 | 大合葬「霊車コンチェルトグロッソ怪」 | S06 / S07 |
| TH34 | 4476 | 合葬「プリズムコンチェルト」 | S07 |

## 可复核原始证据

### S01 帕秋莉八段非符：激光联动发弹纵向偏移

- th06/src/EnemyEclInstr.cpp:ExInsStage4Func12，Rotate((64,0),laser.angle)+enemy.position
- ecldata4/Sub28..Sub35：ins_121(12,0)，地址0x3248、0x3a74、0x42a0、0x4acc、0x52f8、0x5b24、0x6350、0x6b7c

### S02 普通敌机与笼中鸟使魔：出屏回收使用错误尺寸

- th06/src/EnemyManager.cpp:EnemyManager_OnUpdate，Move→Clamp→IsInBounds(primaryVm.sprite宽高)→RunEcl
- th06/src/GameManager.cpp:IsInBounds，width/2、height/2，严格越界后才离场
- ecldata7/Sub44 @0x5c1e、0x5c42、0x5c66、0x5c8a生成Sub45；Sub45 @0x60ce设ANM160、@0x6136启动3.2速移动
- mod/GAME/original/6/stg7enm2.lua:sprite160=64×80；stg1enm.lua:sprite0=30×30
- 4000..4013道中共用该出口；4011是六面入场等待，无敌机，不计入修正卡数

### S03 皇家烈焰：特殊发弹意外回写本体描述符

- th06/src/EnemyEclInstr.cpp:ExInsStageXFunc13开头EnemyShooter bulletProps=enemy->bulletProps
- ecldata7/Sub23 @0x2470 t120、0x2594 t121、0x26b8 t122、0x27dc t123：ins_121(13,3/5/6/5)；回跳展开后才是实际周期

### S04 完美冻结、时停、吸血鬼幻想、红色幻想乡、笼中鸟：消散弹仍参与特殊回调

- th06/src/EnemyEclInstr.cpp:ExInsCirnoRainbowBallJank、ExInsStage56Func4、ExInsStage6Func8/9/11、ExInsStageXFunc15均排除INACTIVE和DESPAWNING
- THlib/bullet/visual_match.lua:emit_despawn设置_native_death_effect并Preserve原对象，native_despawn继续占槽
- H.extra15的大玉和小玉两层扫描分别过滤；seed_small/awaken同时用于手写蕾米莉亚路径

### S05 死价：追踪重瞄周期及发弹前运动

- ecl20_d/Sub3 @0x3a0 t60：photoIndex<2守卫；@0x3bc跳t61
- @0x3e4 t61：ins_65(PLAYER_ANGLE,0.30000001)；@0x3f8 t63跳回t61，只隔两帧重取一次角
- th095/src/ecl/EclRun.cpp:主/子context之后UpdateMovement；EnemyManagerUpdate.cpp随后PhotoEnemyMovementPhase
- mod/GAME/th33.lua:register_photo_card在frame末PhotoNative.flush_move

### S06 灵车协奏曲怪：公转与激光跟随顺序

- ecldata4/Sub135 @0x16b7c t150：MOVE_ORBIT(300,...,-π/2,0.01047197543,64,0.2133333385)
- @0x16c48 t450：MOVE_ORBIT(0,...,+π/2,0.01047197543,128,0)
- @0x16ca8/0x16d78：两根激光；@0x16d2c计数回跳300轮，第二根实际在卡内墙钟766出生，保留现有等待，不能把ECL的t451当墙钟451
- @0x16dcc起将ORBIT_ANGULAR_VELOCITY增加2.6179939595749602e-05，共1200次；随后ADD_LASER_ANGLE/SET_LASER_POS_REL
- th07/src/th07/EclManager.cpp:RunEcl出口才ORBIT角+=角速、半径+=径向速、求velocity；EnemyManager随后积分

### S07 奥尔良人形分裂与激光改向：消散对象状态过滤

- th07/src/th07/EnemyEclInstr.cpp:ExInsSplitBulletsOrShootBackwards、ExInsReflectBulletsFromLasers、ExInsShootBulletsAlongLaser
- ecldata3/Sub45 @0x6f00 t50、0x6f24 t100、0x6f48 t150：RUN_EX_INS6
- ecldata4/Sub133 @0x16374 t240：SET_EX_INS7；Sub135 @0x16b68 t150：SET_EX_INS8；Sub132 @0x15b40 t240：SET_EX_INS7
- 同文件ExInsYoumuCurveBulletsBelow/RedirectBulletsToPlayer仅排除INACTIVE，不套用此过滤

## 同类分支复核

- TH07 Sub135的第一根激光后确有300次计数回跳，第二根出生为墙钟766；本轮没有把这段等待错误缩成一帧。
- TH06的Func2/5/14/16逐项回看，未确认本轮新增行为差异；Func13的描述符快照单独修正，不改发弹路数。
- TH06所有30个显式op95生成目标都在t0直接设置主ANM，出生指令地址单列；道中时间轴普通敌机同样由原始SET_SPRITE绑定。
- TH095出屏函数直接使用精灵全宽/高乘ANM缩放，TH10使用visibilityExtent/2和flags4；不能把TH06的半精灵尺寸规则机械套到它们。
- TH07妖梦斩弹、幽幽子蝶弹等回调仅排除INACTIVE；保留它们原作的状态筛选，不因消散画面无判定就改变原指令行为。
- TH31接续前批主/子context及附着位置证据；TH35继续检查原生载体、两路motion、可视范围字段和固定/移动激光，本轮未确认新的具体差异，未修改这两作。
- TH32的294段离线展开程序文本未改；本轮修正其共用出口及特殊回调，不将生成文本相同当成出口语义一致。

## 记录范围

- 同名JSON保存原始ECL/复原源码SHA-256、修复条目来源、TH06/TH07每项注册的特殊指令静态候选以及TH06显式子机出生ANM指令。
- Lua仅审阅块边界、改动字段和显式local数量，未编译或执行。

- 本轮明确完成上述7组机制的静态核对，33条目是共用修复关联范围，不报成33处独立缺陷。
- 521项注册总目录与前批逐卡记录继续保留；本轮特殊指令候选仍不等于所有ECL、道中窗口、输入和死亡/超时中断的完整执行轨迹。
- 未运行测试或实机；不将本次静态修正表述为全部521条目已经逐帧完全对齐。
