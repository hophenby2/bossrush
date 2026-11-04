# TH31–TH35 ECL使魔运动、发弹节奏与激光全量静态核对

基线 `b477d5f`。原有521条逐卡核对完成；另发现并补齐永夜抄Extra战后整段道中，新增TH31/3439。最终登记**522条：521条原作、1条自制**。本报告接续此前各批记录，收拢为一份完整清单。

**核对范围：**生成/附着、局部/世界坐标、镜像、公转/插值/极性运动、出生与管理器更新、主/子context/CALL、自动枪/等待/重复发弹、life/NO_DEATH停火、出屏回收、普通激光与敌机型伪激光的生命周期。所有结论限于源码静态审阅；按要求未运行测试、Lua或游戏。

| 文件 | 注册数 | 本轮专项状态 |
| --- | ---: | --- |
| TH31 | 136 | 全部条目完成静态核对 |
| TH32 | 106 | 105条原作完成；1条自制不适用 |
| TH33 | 85 | 全部条目完成静态核对 |
| TH34 | 121 | 全部条目完成静态核对 |
| TH35 | 74 | 全部条目完成静态核对 |

## 本轮确认并修复的具体差异

| 编号 | 条目 | 原差异 | 修复 |
| --- | --- | --- | --- |
| F01 | TH31 / 3409、3410、3412、3414、3416、3418、3428、3429、3430、3431、3432、3433、3434、3435、3436、3437、3438、3439；道中使魔关系、原生年龄与停火/回收 | op91被误作无父机独立敌人；主ANM尺寸与NO_SPRITE未参与首次入场；部分枪缺少life门或正常更新的自动枪；NO_DEATH和父机死亡未完整约束子机。 | 区分附着与坐标跟随；源事件从出生后的t1推进；七组入口按主ANM判边界，死亡停火、保留NO_DEATH、父机死亡摘除子机；补三面/四面的普通更新自动枪；手写交互开关同步判定字段，CALL后能按原指令恢复受击。 |
| F02 | TH31 / 3410；一面战后副时间轴47只小妖精缺失 | 后半只包含Timeline0的6只中妖精，Timeline1的47只Sub0全部遗漏。 | 合并53次出场；WAIT_BOSS @0xab98在PUBLISH_EVENT @0xaba4之前，战后才唤醒Timeline1，不能按中Boss耗时削减它。 |
| F03 | TH31 / 3429；二面漏副时间轴及事件等待时间 | 只移植Timeline0的239条；漏54次出场，229条以ECL本地帧号当实际帧号，最迟累计提前355帧。 | 两轴合并293条；事件握手按轴顺序展开，最后普通敌机在5025、中Boss入口在5225；延长该道中至5225/60秒。 |
| F04 | TH31 / 3428、3437；三面三条辅助时间轴及八个例程缺失 | 原先前半25、后半16条，遗漏公转使魔、追踪自动枪和下落妖精。 | 四轴合并前半89、后半26条；补Sub2/3/4/10/11/12/17/18。Sub3在t60冻结半径、继续公转；Sub17追踪90轮并每8拍自动狙；Sub11共5轮、间隔60。 |
| F05 | TH31 / 3412、3414、3416、3418；四面副时间轴及转弯妖精缺失 | 4A/4B均只搬Timeline0，漏两段合计60次Sub3出场及Sub4枪。 | 每路线前半155、后半89条；Sub3在t30切换2.5速、挂枪并开始转向；Sub4当帧连续出前后两发，4帧周期共3轮。A/B的Sub0..15逐指令数值相同。 |
| F06 | TH31 / 3438、3439；Extra战后整段道中缺失 | 3438在清场帧附近结束；慧音三张符后没有原作5177..9497这段道中。 | 补3439并接在慧音三张EX符之后，72秒内包含284次出场；新增后半妖精、Sub29宿主及五组公转枪，保留原跳转形成的17只使魔分布。前半等待延续至5155慧音入口。 |
| F07 | TH31 / 3433、3436、3439；CALL返回丢失变量快照并多耗一帧 | RETURN只恢复指令表/时钟，保留被调函数改写后的局部变量；返回后直接结束帧。 | CALL保存完整22项变量银行，RETURN恢复并同帧继续调用者。Extra的Sub85不再吞掉宿主exI0=5，帝及慧音同类调用一并修正。 |
| F08 | TH31 / 470；莉格露一非枪组早60帧 | 宿主Sub15的60帧入场与Sub16主枪同时运行。 | 枪组从宿主60帧入场后开始；既有移动和总时限保留。 |
| F09 | TH31 / 363；待宵反射卫星斩的大斩击没有致命框 | Sub2被写成始终无判定的装饰激光，显示位置/生命期也不对应原实体。 | 绑定原ANM，原生年龄t4由24×1切到16×1024接触框，t64终止；独立处理敌机型伪激光，不套普通激光状态机。 |
| F10 | TH32 / 原生共用出口的100项，逐卡表列全；RunEcl出口夹框与自动枪顺序 | 先夹框再自动枪/重复ExIns；life<=0仍推进自动发射；出生也套管理器的帧尾夹框。 | 移动后先按life门运行自动枪/ExIns，正常管理器更新再夹框；出生RunEcl不额外执行帧尾夹框。 |
| F11 | TH34 / 3406、3407；Extra/Phantasm后续波次整体早200帧 | 移除中Boss占位时连同它前面的200帧等待一并丢掉，后半所有生成提前。 | 两表的23改为223，恢复原时间轴间隔；八段1970条生成记录完整对应原始记录。 |
| F12 | TH34 / 3404、3405；烟尘载体生成本体时少一次ECL/运动更新 | 合并成同一对象后只执行出生t0，没有同帧正常t1；炮弹首轮、加速度和插值相位偏一拍。 | 换身帧先保留出生状态、不积分，再执行正常t1；五面无载体直接出场不额外推进。六面左右本体绑定不同源脚本。 |
| F13 | TH34 / 3404；五面12条生成位置被舍入 | 部分轨道生成点只留4至6位小数。 | 改回从原始float32坐标换算得到的值，镜像、生命和生成间隔保持。 |
| F14 | TH35 / 3671、3680、3681、3682、3683、3684、3685；道中出屏使用错误坐标范围和尺寸 | 原始wy为0..448却按-224..224记入场、按±280回收，导致向下离场过早；私有载体也缺统一回收门。 | 按原始活动区和ECL设置主ANM时保存的可视尺寸回收；保留原作宽高交换及NO_OOB。74个永久置位子程序的字面数据另存，带定时清除的既有行为继续按时点切换。 |

## 可逐项复查的全量数据

- **TH08：**12张字面时间轴表共1435条记录逐行对应原始二进制；事件等待按轴顺序展开。四面A/B普通敌机Sub0..15的时间/操作码/难度/数值全部相同。Boss等待单列为分段边界，没有凭空代入战斗耗时。
- **TH06：**294个生成子程序与14段道中源码文本分别由原始二进制离线展开后对表；294项及14段相同，道中包含2177次创建。该结论只覆盖生成文本；共用运行出口另按复原源码核对，F10即来自该审阅。
- **TH07：**八段WAVE的293/324/265/293/94/47/282/372条，共1970条，核对生成帧、子程序、位置、生命、掉落和已有镜像字段；并进一步核对反汇编与二进制有效时间轴。载体生成本体、Boss直接伴奏及敌机型伪激光分别审阅。
- **TH095：**85幕逐卡接续前批的出生/插值/枪组/照片数回调/激光审阅。本轮复核原生反弹的边界外层与内部严格比较，以及仅改velocity而不回写scalar speed的差别，没有为“看起来不对称”的原版行为加改动。
- **TH10：**74项接续线程快照、双路运动、量化、枪组及激光反射审阅，本轮补统一回收门与可视尺寸；74个NO_OOB键是源函数数量，不等于74张卡发生新缺陷。

逐条二进制地址、时间、参数、哈希、时间轴事件、生成表及每张卡的源码候选见[同名JSON](ECL_BEHAVIOR_FULL_REVIEW_2026-11-04.json)。当前主索引已按本专项更新；旧implementation行号明确保留为历史快照，避免冒充本轮运行定位。

## 逐卡结论

“完成”表示上述三项的静态审阅已收尾；“无新差异”会接续之前修复，不表示这张卡从未有问题。时间轴候选与实际窗口在JSON中分开，不能将全文件其他阶段计入本卡。

| 文件/ID | 符卡、非符或道中 | 原始入口 | 本轮结论 |
| --- | --- | --- | --- |
| TH31/351 | 「季节外调的蝴蝶风暴」 | ecldata1sp.ecl / Sub36 | 完成；无新增差异 |
| TH31/352 | 「盲夜鸟」 | ecldata2sp.ecl / Sub46 | 完成；无新增差异 |
| TH31/353 | 「日出之国的天子」 | ecldata3sp.ecl / Sub56 | 完成；无新增差异 |
| TH31/354 | 「幻胧月睨」 | ecldata5sp.ecl / Sub40 | 完成；无新增差异 |
| TH31/355 | 「天网蛛网捕蝶之法」 | ecldata6sp.ecl / Sub76 | 完成；无新增差异 |
| TH31/356 | 「蓬莱之树海」 | ecldata7sp.ecl / Sub79 | 完成；无新增差异 |
| TH31/357 | 「不死鸟再诞」 | ecldata8sp.ecl / Sub110 | 完成；无新增差异 |
| TH31/358 | 「远古的欺骗者」 | ecldata5sp.ecl / Sub43 | 完成；无新增差异 |
| TH31/359 | 「无何有净化」 | ecldata8sp.ecl / Sub113 | 完成；无新增差异 |
| TH31/360 | 「梦想天生」 | ecldata4asp.ecl / Sub43 | 完成；无新增差异 |
| TH31/361 | 「炽热之星」 | ecldata4bsp.ecl / Sub60 | 完成；无新增差异 |
| TH31/362 | 「紧缩世界」 | ecldata_sk.ecl / Sub1 | 完成；无新增差异 |
| TH31/363 | 「待宵反射卫星斩」 | ecldata_ym.ecl / Sub1 | F09 |
| TH31/364 | 「格兰吉纽尔剧场的怪人」 | ecldata_al.ecl / Sub1 | 完成；无新增差异 |
| TH31/365 | 「猩红命运」 | ecldata_rm.ecl / Sub1 | 完成；无新增差异 |
| TH31/366 | 「西行寺无余涅槃」 | ecldata_yy.ecl / Sub1 | 完成；无新增差异 |
| TH31/367 | 「深弹幕结界 -梦幻泡影-」 | ecldata_yk.ecl / Sub4 | 完成；无新增差异 |
| TH31/3428 | 三面道中「迷途竹林」 | ecldata3.ecl / 时间轴 | F01、F04 |
| TH31/3436 | 三面中BOSS 非符 | ecldata3.ecl / Sub20 | F01、F07 |
| TH31/3426 | 产灵「最初的金字塔」 | ecldata3.ecl / Sub30 | 完成；无新增差异 |
| TH31/3437 | 三面道中後段「迷途竹林」 | ecldata3.ecl / 时间轴 | F01、F04 |
| TH31/427 | 非符一 | ecldata3.ecl / Sub35 | 完成；无新增差异 |
| TH31/428 | 始符「エフェメラリティ137」 | ecldata3.ecl / Sub44 | 完成；无新增差异 |
| TH31/429 | 野符「GHQクライシス」 | ecldata3.ecl / Sub47 | 完成；无新增差异 |
| TH31/430 | 非符二 | ecldata3.ecl / Sub38 | 完成；无新增差异 |
| TH31/431 | 国体「三種の神器　郷」 | ecldata3.ecl / Sub62 | 完成；无新增差异 |
| TH31/432 | 虚史「幻想郷伝説」 | ecldata3.ecl / Sub67 | 完成；无新增差异 |
| TH31/3427 | 未来「高天原」 | ecldata3.ecl / Sub71 | 完成；无新增差异 |
| TH31/3438 | EX道中「永夜の竹林」 | ecldata8.ecl / 时间轴 | F01、F06 |
| TH31/370 | 旧史「旧秘境史 -旧日秘史-」 | ecldata8.ecl / Sub51 | 完成；无新增差异 |
| TH31/371 | 转世「一条归桥」 | ecldata8.ecl / Sub56 | 完成；无新增差异 |
| TH31/372 | 新史「新幻想史 -未来秘史-」 | ecldata8.ecl / Sub60 | 完成；无新增差异 |
| TH31/3439 | EX道中後段「永夜の竹林」 | ecldata8.ecl / 时间轴 | F01、F06、F07 |
| TH31/384 | 非符一 | ecldata8.ecl / Sub66 | 完成；无新增差异 |
| TH31/373 | 时效「月之岩笠的诅咒」 | ecldata8.ecl / Sub93 | 完成；无新增差异 |
| TH31/385 | 非符二 | ecldata8.ecl / Sub68 | 完成；无新增差异 |
| TH31/374 | 不死「火之鸟 -凤翼天翔-」 | ecldata8.ecl / Sub97 | 完成；无新增差异 |
| TH31/386 | 非符三 | ecldata8.ecl / Sub70 | 完成；无新增差异 |
| TH31/375 | 藤原「灭罪寺院伤」 | ecldata8.ecl / Sub100 | 完成；无新增差异 |
| TH31/387 | 非符四 | ecldata8.ecl / Sub72 | 完成；无新增差异 |
| TH31/376 | 不死「徐福时空」 | ecldata8.ecl / Sub103 | 完成；无新增差异 |
| TH31/388 | 非符五 | ecldata8.ecl / Sub74 | 完成；无新增差异 |
| TH31/377 | 灭罪「正直者之死」 | ecldata8.ecl / Sub108 | 完成；无新增差异 |
| TH31/389 | 非符六 | ecldata8.ecl / Sub76 | 完成；无新增差异 |
| TH31/378 | 虚人「乌」 | ecldata8.ecl / Sub113 | 完成；无新增差异 |
| TH31/390 | 非符七 | ecldata8.ecl / Sub78 | 完成；无新增差异 |
| TH31/379 | 不灭「不死鸟之尾」 | ecldata8.ecl / Sub118 | 完成；无新增差异 |
| TH31/391 | 非符八 | ecldata8.ecl / Sub80 | 完成；无新增差异 |
| TH31/380 | 蓬莱「凯风快晴 -富士山火山-」 | ecldata8.ecl / Sub126 | 完成；无新增差异 |
| TH31/381 | 「被不死鸟附身」 | ecldata8.ecl / Sub131 | 完成；无新增差异 |
| TH31/382 | 「蓬莱人形」 | ecldata8.ecl / Sub143 | 完成；无新增差异 |
| TH31/383 | 「不灭之射击」 | ecldata8.ecl / Sub149 | 完成；无新增差异 |
| TH31/406 | 非符一 | ecldata7.ecl / Sub15 | 完成；无新增差异 |
| TH31/402 | 薬符「壶中之大银河」 | ecldata7.ecl / Sub19 | 完成；无新增差异 |
| TH31/3431 | 六面道中B「月都回廊」 | ecldata7.ecl / 时间轴 | F01 |
| TH31/405 | 非符一 | ecldata7.ecl / Sub27 | 完成；无新增差异 |
| TH31/401 | 神宝「龙颈之玉」 | ecldata7.ecl / Sub50 | 完成；无新增差异 |
| TH31/404 | 非符二 | ecldata7.ecl / Sub31 | 完成；无新增差异 |
| TH31/400 | 神宝「布迪斯特钻石」 | ecldata7.ecl / Sub55 | 完成；无新增差异 |
| TH31/407 | 非符三 | ecldata7.ecl / Sub34 | 完成；无新增差异 |
| TH31/399 | 神宝「萨拉曼达之盾」 | ecldata7.ecl / Sub61 | 完成；无新增差异 |
| TH31/403 | 非符四 | ecldata7.ecl / Sub38 | 完成；无新增差异 |
| TH31/398 | 神宝「ライフスプリングインフィニティ」 | ecldata7.ecl / Sub67 | 完成；无新增差异 |
| TH31/397 | 神宝「蓬莱之玉之枝 -梦色之乡-」 | ecldata7.ecl / Sub71 | 完成；无新增差异 |
| TH31/392 | 永夜归返「-待宵-」 | ecldata7.ecl / Sub77 | 完成；无新增差异 |
| TH31/393 | 永夜归返「-子之四-」 | ecldata7.ecl / Sub80 | 完成；无新增差异 |
| TH31/394 | 永夜归返「-丑之四-」 | ecldata7.ecl / Sub82 | 完成；无新增差异 |
| TH31/395 | 永夜归返「-寅之四-」 | ecldata7.ecl / Sub84 | 完成；无新增差异 |
| TH31/396 | 永夜归返「-天明-」 | ecldata7.ecl / Sub87 | 完成；无新增差异 |
| TH31/3430 | 六面道中A「永远亭参道」 | ecldata6.ecl / 时间轴 | F01 |
| TH31/422 | 非符一 | ecldata6.ecl / Sub16 | 完成；无新增差异 |
| TH31/421 | 天丸「壺中の天地」 | ecldata6.ecl / Sub21 | 完成；无新增差异 |
| TH31/420 | 神符「天人の系譜」 | ecldata6.ecl / Sub52 | 完成；无新增差异 |
| TH31/423 | 非符二 | ecldata6.ecl / Sub36 | 完成；无新增差异 |
| TH31/419 | 蘇生「ライジングゲーム」 | ecldata6.ecl / Sub56 | 完成；无新增差异 |
| TH31/424 | 非符三 | ecldata6.ecl / Sub40 | 完成；无新增差异 |
| TH31/418 | 神脳「オモイカネブレイン」 | ecldata6.ecl / Sub63 | 完成；无新增差异 |
| TH31/425 | 非符四 | ecldata6.ecl / Sub44 | 完成；无新增差异 |
| TH31/417 | 天呪「アポロ１３」 | ecldata6.ecl / Sub68 | 完成；无新增差异 |
| TH31/409 | 秘術「天文密葬法」 | ecldata6.ecl / Sub73 | 完成；无新增差异 |
| TH31/408 | 禁薬「蓬莱の薬」 | ecldata6.ecl / Sub78 | 完成；无新增差异 |
| TH31/3412 | 四面道中「虚実の境界」 | ecldata4a.ecl / 时间轴 | F01、F05 |
| TH31/3414 | 四面道中「虚実の境界」 | ecldata4b.ecl / 时间轴 | F01、F05 |
| TH31/433 | 非符一 | ecldata4a.ecl / Sub17 | 完成；无新增差异 |
| TH31/434 | 夢境「二重大結界」 | ecldata4a.ecl / Sub28 | 完成；无新增差异 |
| TH31/435 | 非符二 | ecldata4a.ecl / Sub19 | 完成；无新增差异 |
| TH31/436 | 散霊「夢想封印　寂」 | ecldata4a.ecl / Sub30 | 完成；无新增差异 |
| TH31/3416 | 四面道中後段「虚実の境界」 | ecldata4a.ecl / 时间轴 | F01、F05 |
| TH31/437 | 非符三 | ecldata4a.ecl / Sub25 | 完成；无新增差异 |
| TH31/438 | 神技「八方龍殺陣」 | ecldata4a.ecl / Sub33 | 完成；无新增差异 |
| TH31/439 | 非符四 | ecldata4a.ecl / Sub26 | 完成；无新增差异 |
| TH31/440 | 回霊「夢想封印　侘」 | ecldata4a.ecl / Sub41 | 完成；无新增差异 |
| TH31/441 | 大結界「博麗弾幕結界」 | ecldata4a.ecl / Sub46 | 完成；无新增差异 |
| TH31/442 | 神霊「夢想封印　瞬」 | ecldata4a.ecl / Sub54 | 完成；无新增差异 |
| TH31/443 | 非符一 | ecldata4b.ecl / Sub17 | 完成；无新增差异 |
| TH31/444 | 魔空「アステロイドベルト」 | ecldata4b.ecl / Sub36 | 完成；无新增差异 |
| TH31/445 | 非符二 | ecldata4b.ecl / Sub22 | 完成；无新增差异 |
| TH31/446 | 黒魔「イベントホライズン」 | ecldata4b.ecl / Sub41 | 完成；无新增差异 |
| TH31/3418 | 四面道中後段「虚実の境界」 | ecldata4b.ecl / 时间轴 | F01、F05 |
| TH31/447 | 非符三 | ecldata4b.ecl / Sub28 | 完成；无新增差异 |
| TH31/448 | 恋風「スターライトタイフーン」 | ecldata4b.ecl / Sub47 | 完成；无新增差异 |
| TH31/449 | 非符四 | ecldata4b.ecl / Sub31 | 完成；无新增差异 |
| TH31/450 | 恋心「ダブルスパーク」 | ecldata4b.ecl / Sub55 | 完成；无新增差异 |
| TH31/451 | 光撃「シュート・ザ・ムーン」 | ecldata4b.ecl / Sub62 | 完成；无新增差异 |
| TH31/452 | 魔砲「ファイナルマスタースパーク」 | ecldata4b.ecl / Sub67 | 完成；无新增差异 |
| TH31/3432 | 五面道中「幻想乡上空」 | ecldata5.ecl / 时间轴 | F01 |
| TH31/3433 | 五面中BOSS 非符一 | ecldata5.ecl / Sub38 | F01、F07 |
| TH31/3434 | 五面中BOSS 非符二 | ecldata5.ecl / Sub45 | F01 |
| TH31/3435 | 五面道中後段「幻想乡上空」 | ecldata5.ecl / 时间轴 | F01 |
| TH31/453 | 非符一 | ecldata5.ecl / Sub51 | 完成；无新增差异 |
| TH31/454 | 幻波「赤眼催眠(マインドブローイング)」 | ecldata5.ecl / Sub62 | 完成；无新增差异 |
| TH31/455 | 非符二 | ecldata5.ecl / Sub53 | 完成；无新增差异 |
| TH31/456 | 狂視「狂視調律(イリュージョンシーカー)」 | ecldata5.ecl / Sub66 | 完成；无新增差异 |
| TH31/457 | 非符三 | ecldata5.ecl / Sub56 | 完成；无新增差异 |
| TH31/458 | 懶惰「生神停止(マインドストッパー)」 | ecldata5.ecl / Sub63 | 完成；无新增差异 |
| TH31/459 | 散符「真実の月(インビジブルフルムーン)」 | ecldata5.ecl / Sub75 | 完成；无新增差异 |
| TH31/460 | 月眼「月兎遠隔催眠術(テレメスメリズム)」 | ecldata5.ecl / Sub78 | 完成；无新增差异 |
| TH31/3429 | 二面道中「夜雀小径」 | ecldata2.ecl / 时间轴 | F01、F03 |
| TH31/461 | 非符一 | ecldata2.ecl / Sub17 | 完成；无新增差异 |
| TH31/462 | 声符「木菟咆哮」 | ecldata2.ecl / Sub23 | 完成；无新增差异 |
| TH31/463 | 非符二 | ecldata2.ecl / Sub27 | 完成；无新增差异 |
| TH31/464 | 猛毒「毒蛾の暗闇演舞」 | ecldata2.ecl / Sub38 | 完成；无新增差异 |
| TH31/465 | 非符三 | ecldata2.ecl / Sub29 | 完成；无新增差异 |
| TH31/466 | 鷹符「イルスタードダイブ」 | ecldata2.ecl / Sub44 | 完成；无新增差异 |
| TH31/467 | 非符四 | ecldata2.ecl / Sub51 | 完成；无新增差异 |
| TH31/468 | 夜盲「夜雀の歌」 | ecldata2.ecl / Sub52 | 完成；无新增差异 |
| TH31/469 | 夜雀「真夜中のコーラスマスター」 | ecldata2.ecl / Sub58 | 完成；无新增差异 |
| TH31/3409 | 一面道中「萤火小径」 | ecldata1.ecl / 时间轴 | F01 |
| TH31/470 | 非符一 | ecldata1.ecl / Sub15 | F08 |
| TH31/471 | 蛍符「地上の彗星」 | ecldata1.ecl / Sub22 | 完成；无新增差异 |
| TH31/3410 | 一面道中後段「萤火小径」 | ecldata1.ecl / 时间轴 | F01、F02 |
| TH31/472 | 非符二 | ecldata1.ecl / Sub26 | 完成；无新增差异 |
| TH31/473 | 非符三 | ecldata1.ecl / Sub33 | 完成；无新增差异 |
| TH31/474 | 灯符「ファイヤフライフェノメノン」 | ecldata1.ecl / Sub38 | 完成；无新增差异 |
| TH31/475 | 蠢符「ナイトバグトルネード」 | ecldata1.ecl / Sub44 | 完成；无新增差异 |
| TH31/476 | 隠蟲「永夜蟄居」 | ecldata1.ecl / Sub48 | 完成；无新增差异 |
| TH32/3802 | 神罚「年幼的恶魔之王」（Lunatic） | ecldata6.ecl / Sub31 | 完成；无新增差异 |
| TH32/3805 | 狱符「千根针的针山」（Lunatic） | ecldata6.ecl / Sub33 | 完成；无新增差异 |
| TH32/3808 | 神术「吸血鬼幻想」（Lunatic） | ecldata6.ecl / Sub35 | 完成；无新增差异 |
| TH32/3811 | 红符「绯红之主」（Lunatic） | ecldata6.ecl / Sub39 | 完成；无新增差异 |
| TH32/369 | 「红色的幻想乡」（Lunatic） | ecldata6.ecl / Sub44 | 完成；无新增差异 |
| TH32/3900 | 一面中 Boss 非符（Lunatic） | ecldata1.ecl / Sub8 | F10 |
| TH32/3901 | 月符「月光」（Lunatic） | ecldata1.ecl / Sub9 | F10 |
| TH32/3902 | 露米娅 非符一（Lunatic） | ecldata1.ecl / Sub11 | F10 |
| TH32/3903 | 夜符「夜雀」（Lunatic） | ecldata1.ecl / Sub22 | F10 |
| TH32/3904 | 露米娅 非符二（Lunatic） | ecldata1.ecl / Sub16 | F10 |
| TH32/3905 | 暗符「境界线」（Lunatic） | ecldata1.ecl / Sub23 | F10 |
| TH32/3906 | 大妖精 非符（Lunatic） | ecldata2.ecl / Sub20 | F10 |
| TH32/3907 | 琪露诺 非符一（Lunatic） | ecldata2.ecl / Sub22 | F10 |
| TH32/3908 | 雹符「冰雹暴风」（Lunatic） | ecldata2.ecl / Sub30 | F10 |
| TH32/3909 | 琪露诺 非符二（Lunatic） | ecldata2.ecl / Sub25 | F10 |
| TH32/3910 | 冻符「完美冻结」（Lunatic） | ecldata2.ecl / Sub31 | F10 |
| TH32/3911 | 雪符「钻石风暴」（Lunatic） | ecldata2.ecl / Sub32 | F10 |
| TH32/3912 | 三面中 Boss 非符（Lunatic） | ecldata3.ecl / Sub9 | F10 |
| TH32/3913 | 华符「绚烂华灵」（Lunatic） | ecldata3.ecl / Sub14 | F10 |
| TH32/3914 | 红美铃 非符一（Lunatic） | ecldata3.ecl / Sub18 | F10 |
| TH32/3915 | 虹符「彩虹的风铃」（Lunatic） | ecldata3.ecl / Sub29 | F10 |
| TH32/3916 | 红美铃 非符二（Lunatic） | ecldata3.ecl / Sub20 | F10 |
| TH32/3917 | 幻符「华想梦葛」（Lunatic） | ecldata3.ecl / Sub30 | F10 |
| TH32/3918 | 红美铃 非符三（Lunatic） | ecldata3.ecl / Sub26 | F10 |
| TH32/3919 | 彩符「彩光乱舞」（Lunatic） | ecldata3.ecl / Sub32 | F10 |
| TH32/3920 | 彩符「极彩台风」（Lunatic） | ecldata3.ecl / Sub33 | F10 |
| TH32/3921 | 小恶魔 非符（Lunatic） | ecldata4.ecl / Sub21 | F10 |
| TH32/3922 | 帕秋莉 非符一（Lunatic·灵梦Ａ） | ecldata4.ecl / Sub27 | F10 |
| TH32/3923 | 火符「火神之光上级」（Lunatic·灵梦Ａ） | ecldata4.ecl / Sub43 | F10 |
| TH32/3924 | 帕秋莉 非符二（Lunatic·灵梦Ａ） | ecldata4.ecl / Sub37 | F10 |
| TH32/3925 | 土符「三石塔的震动」（Lunatic·灵梦Ａ） | ecldata4.ecl / Sub52 | F10 |
| TH32/3926 | 火＆土符「熔岩巨石」（Lunatic·灵梦Ａ） | ecldata4.ecl / Sub55 | F10 |
| TH32/3927 | 金＆水符「水银之毒」（Lunatic·灵梦Ａ） | ecldata4.ecl / Sub58 | F10 |
| TH32/3928 | 木＆火符「森林大火」（Lunatic·灵梦Ａ） | ecldata4.ecl / Sub56 | F10 |
| TH32/3929 | 帕秋莉 非符一（Lunatic·灵梦Ｂ） | ecldata4.ecl / Sub27 | F10 |
| TH32/3930 | 水符「湖葬」（Lunatic·灵梦Ｂ） | ecldata4.ecl / Sub46 | F10 |
| TH32/3931 | 帕秋莉 非符二（Lunatic·灵梦Ｂ） | ecldata4.ecl / Sub37 | F10 |
| TH32/3932 | 木符「翠绿风暴」（Lunatic·灵梦Ｂ） | ecldata4.ecl / Sub49 | F10 |
| TH32/3933 | 水＆木符「水精灵」（Lunatic·灵梦Ｂ） | ecldata4.ecl / Sub57 | F10 |
| TH32/3934 | 金＆水符「水银之毒」（Lunatic·灵梦Ｂ） | ecldata4.ecl / Sub58 | F10 |
| TH32/3935 | 土＆金符「翡翠巨石」（Lunatic·灵梦Ｂ） | ecldata4.ecl / Sub59 | F10 |
| TH32/3936 | 帕秋莉 非符一（Lunatic·魔理沙Ａ） | ecldata4.ecl / Sub27 | F10 |
| TH32/3937 | 木符「风灵角笛上级」（Lunatic·魔理沙Ａ） | ecldata4.ecl / Sub48 | F10 |
| TH32/3938 | 帕秋莉 非符二（Lunatic·魔理沙Ａ） | ecldata4.ecl / Sub37 | F10 |
| TH32/3939 | 火符「火神之光辉」（Lunatic·魔理沙Ａ） | ecldata4.ecl / Sub44 | F10 |
| TH32/3940 | 木＆火符「森林大火」（Lunatic·魔理沙Ａ） | ecldata4.ecl / Sub56 | F10 |
| TH32/3941 | 土＆金符「翡翠巨石」（Lunatic·魔理沙Ａ） | ecldata4.ecl / Sub59 | F10 |
| TH32/3942 | 火＆土符「熔岩巨石」（Lunatic·魔理沙Ａ） | ecldata4.ecl / Sub55 | F10 |
| TH32/3943 | 帕秋莉 非符一（Lunatic·魔理沙Ｂ） | ecldata4.ecl / Sub27 | F10 |
| TH32/3944 | 土符「三石塔上级」（Lunatic·魔理沙Ｂ） | ecldata4.ecl / Sub51 | F10 |
| TH32/3945 | 帕秋莉 非符二（Lunatic·魔理沙Ｂ） | ecldata4.ecl / Sub37 | F10 |
| TH32/3946 | 金符「银龙」（Lunatic·魔理沙Ｂ） | ecldata4.ecl / Sub54 | F10 |
| TH32/3947 | 土＆金符「翡翠巨石」（Lunatic·魔理沙Ｂ） | ecldata4.ecl / Sub59 | F10 |
| TH32/3948 | 水＆木符「水精灵」（Lunatic·魔理沙Ｂ） | ecldata4.ecl / Sub57 | F10 |
| TH32/3949 | 金＆水符「水银之毒」（Lunatic·魔理沙Ｂ） | ecldata4.ecl / Sub58 | F10 |
| TH32/3950 | 五面中 Boss 非符（Lunatic） | ecldata5.ecl / Sub13 | F10 |
| TH32/3951 | 奇术「迷惑误导」（Lunatic） | ecldata5.ecl / Sub18 | F10 |
| TH32/3952 | 咲夜 非符一（Lunatic） | ecldata5.ecl / Sub22 | F10 |
| TH32/3953 | 幻幽「夜雾幻影杀人鬼」（Lunatic） | ecldata5.ecl / Sub45 | F10 |
| TH32/3954 | 咲夜 非符二（Lunatic） | ecldata5.ecl / Sub34 | F10 |
| TH32/3955 | 幻世「世界」（Lunatic） | ecldata5.ecl / Sub47 | F10 |
| TH32/3956 | 咲夜 非符三（Lunatic） | ecldata5.ecl / Sub41 | F10 |
| TH32/3957 | 女仆秘技「杀人玩偶」（Lunatic） | ecldata5.ecl / Sub50 | F10 |
| TH32/3958 | 六面中 Boss 非符（Lunatic） | ecldata6.ecl / Sub9 | F10 |
| TH32/3959 | 奇术「永恒的温柔」（Lunatic） | ecldata6.ecl / Sub14 | F10 |
| TH32/3960 | 蕾米莉亚 非符一（Lunatic） | ecldata6.ecl / Sub17 | F10 |
| TH32/3961 | 蕾米莉亚 非符二（Lunatic） | ecldata6.ecl / Sub19 | F10 |
| TH32/3962 | 蕾米莉亚 非符三（Lunatic） | ecldata6.ecl / Sub23 | F10 |
| TH32/3963 | 蕾米莉亚 非符四（Lunatic） | ecldata6.ecl / Sub26 | F10 |
| TH32/3964 | 月符「沉默的月神」（Extra） | ecldata7.ecl / Sub22 | F10 |
| TH32/3965 | 日符「皇家烈焰」（Extra） | ecldata7.ecl / Sub23 | F10 |
| TH32/3966 | 火水木金土符「贤者之石」（Extra） | ecldata7.ecl / Sub24 | F10 |
| TH32/3967 | 芙兰朵露 非符一（Extra） | ecldata7.ecl / Sub32 | F10 |
| TH32/3968 | 禁忌「红莓陷阱」（Extra） | ecldata7.ecl / Sub33 | F10 |
| TH32/3969 | 芙兰朵露 非符二（Extra） | ecldata7.ecl / Sub35 | F10 |
| TH32/3970 | 禁忌「莱瓦汀」（Extra） | ecldata7.ecl / Sub36 | F10 |
| TH32/3971 | 芙兰朵露 非符三（Extra） | ecldata7.ecl / Sub38 | F10 |
| TH32/3972 | 禁忌「四重存在」（Extra） | ecldata7.ecl / Sub39 | F10 |
| TH32/3973 | 芙兰朵露 非符四（Extra） | ecldata7.ecl / Sub43 | F10 |
| TH32/3974 | 禁忌「笼中鸟」（Extra） | ecldata7.ecl / Sub44 | F10 |
| TH32/3975 | 芙兰朵露 非符五（Extra） | ecldata7.ecl / Sub47 | F10 |
| TH32/3976 | 禁忌「恋之迷宫」（Extra） | ecldata7.ecl / Sub48 | F10 |
| TH32/3977 | 芙兰朵露 非符六（Extra） | ecldata7.ecl / Sub49 | F10 |
| TH32/3978 | 禁弹「星弧破碎」（Extra） | ecldata7.ecl / Sub50 | F10 |
| TH32/3979 | 芙兰朵露 非符七（Extra） | ecldata7.ecl / Sub53 | F10 |
| TH32/3980 | 禁弹「折反射」（Extra） | ecldata7.ecl / Sub54 | F10 |
| TH32/3981 | 芙兰朵露 非符八（Extra） | ecldata7.ecl / Sub56 | F10 |
| TH32/3982 | 禁弹「刻着过去的钟表」（Extra） | ecldata7.ecl / Sub57 | F10 |
| TH32/3983 | 芙兰朵露 非符九（Extra） | ecldata7.ecl / Sub59 | F10 |
| TH32/3984 | 秘弹「之后就一个人都没有了吗？」（Extra） | ecldata7.ecl / Sub60 | F10 |
| TH32/3985 | ＱＥＤ「４９５年的波纹」（Extra） | ecldata7.ecl / Sub68 | F10 |
| TH32/4000 | 一面道中·前半 | ecldata1.ecl / 时间轴 | F10 |
| TH32/4001 | 一面道中·后半 | ecldata1.ecl / 时间轴 | F10 |
| TH32/4002 | 二面道中·前半 | ecldata2.ecl / 时间轴 | F10 |
| TH32/4003 | 二面道中·后半 | ecldata2.ecl / 时间轴 | F10 |
| TH32/4004 | 三面道中·前半 | ecldata3.ecl / 时间轴 | F10 |
| TH32/4005 | 三面道中·后半 | ecldata3.ecl / 时间轴 | F10 |
| TH32/4006 | 四面道中·前半 | ecldata4.ecl / 时间轴 | F10 |
| TH32/4007 | 四面道中·后半 | ecldata4.ecl / 时间轴 | F10 |
| TH32/4008 | 五面道中·前半 | ecldata5.ecl / 时间轴 | F10 |
| TH32/4009 | 五面道中·后半 | ecldata5.ecl / 时间轴 | F10 |
| TH32/4010 | 六面道中·前半 | ecldata6.ecl / 时间轴 | F10 |
| TH32/4011 | 六面道中·后半（入场等待） | ecldata6.ecl / 时间轴 | F10 |
| TH32/4012 | Extra道中·前半 | ecldata7.ecl / 时间轴 | F10 |
| TH32/4013 | Extra道中·后半 | ecldata7.ecl / 时间轴 | F10 |
| TH32/368 | 「克罗里·尤斯福德」 | 自制 | 原作不适用 |
| TH33/4480 | 八云蓝 非符（场景70） | ecl16_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/410 | 幽雅「死出の誘蛾灯」 | ecl17_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/411 | 蝶符「鳳蝶紋の死槍」 | ecl17_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/416 | 死符「酔人の生、死の夢幻」 | ecl17_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/412 | 「死蝶浮月」 | ecl17_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/413 | 密符「御大師様の秘鍵」 | ecl16_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/414 | 行符「八千万枚護摩」 | ecl16_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/415 | 超人「飛翔役小角」 | ecl16_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/453 | 禁忌「フォービドゥンフルーツ」 | ecl22_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/454 | 禁忌「禁じられた遊び」 | ecl22_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/455 | 境符「色と空の境界」 | ecl23_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/456 | 境符「波と粒の境界」 | ecl23_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/457 | 貴人「サンジェルマンの忠告」 | ecl24_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/458 | 蓬莱「瑞江浦嶋子と五色の瑞亀」 | ecl24_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/459 | 鬼気「濛々迷霧」 | ecl25_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/460 | 「百万鬼夜行」 | ecl25_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/470 |  | ecl20_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/471 | 嘘言「タン・オブ・ウルフ」 | ecl21_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/472 | 死歌「八重霧の渡し」 | ecl20_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/473 | 審判「十王裁判」 | ecl21_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/474 | 古雨「黄泉中有の旅の雨」 | ecl20_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/475 | 審判「ギルティ・オワ・ノットギルティ」 | ecl21_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/476 | 死価「プライス・オブ・ライフ」 | ecl20_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/477 | 審判「浄頗梨審判　-射命丸文-」 | ecl21_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/478 |  | ecl18_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/479 | 新難題「月のイルメナイト」 | ecl19_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/480 | 薬符「胡蝶夢丸ナイトメア」 | ecl18_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/481 | 新難題「エイジャの赤石」 | ecl19_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/482 | 錬丹「水銀の海」 | ecl18_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/483 | 新難題「金閣寺の一枚天井」 | ecl19_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/484 | 秘薬「仙香玉兎」 | ecl18_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/485 | 新難題「ミステリウム」 | ecl19_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/486 |  | ecl14_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/487 | 魔符「全世界ナイトメア」 | ecl15_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/488 | 時符「トンネルエフェクト」 | ecl14_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/489 | 紅符「ブラッディマジックスクウェア」 | ecl15_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/490 | 空虚「インフレーションスクウェア」 | ecl14_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/491 | 紅蝙蝠「ヴァンピリッシュナイト」 | ecl15_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/492 | 銀符「パーフェクトメイド」 | ecl14_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/493 | 神鬼「レミリアストーカー」 | ecl15_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/494 |  | ecl12_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/495 | 人智剣「天女返し」 | ecl13_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/496 | 星符「飛び重ね鱗」 | ecl12_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/497 | 妄執剣「修羅の血」 | ecl13_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/498 | 鬼神「鳴動持国天」 | ecl12_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/499 | 天星剣「涅槃寂静の如し」 | ecl13_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/500 | 化猫「橙」 | ecl12_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/501 | 四生剣「衆生無情の響き」 | ecl13_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/502 |  | ecl10_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/503 | 日＆水符「ハイドロジェナスプロミネンス」 | ecl11_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/504 | 華符「彩光蓮華掌」 | ecl10_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/505 | 水＆火符「フロギスティックレイン」 | ecl11_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/506 | 彩翔「飛花落葉」 | ecl10_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/507 | 月＆木符「サテライトヒマワリ」 | ecl11_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/508 | 彩華「虹色太極拳」 | ecl10_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/509 | 日＆月符「ロイヤルダイアモンドリング」 | ecl11_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/510 |  | ecl7_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/514 | 霧符「ガシングガーデン」 | ecl9_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/517 | 脱兎「フラスターエスケープ」 | ecl8_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/511 | 散符「朧月花栞（ロケット・イン・ミスト）」 | ecl7_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/515 | 毒符「ポイズンブレス」 | ecl9_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/512 | 波符「幻の月（インビジブルハーフムーン）」 | ecl7_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/516 | 譫妄「イントゥデリリウム」 | ecl9_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/518 | 借符「大穴牟遅様の薬」 | ecl8_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/513 | 狂夢「風狂の夢（ドリームワールド）」 | ecl7_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/519 |  | ecl6_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/520 | 操符「ドールズインシー」 | ecl6_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/521 | 呪符「ストロードールカミカゼ」 | ecl6_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/522 | 赤符「ドールミラセティ」 | ecl6_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/523 | 光符「アマテラス」 | ecl5_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/524 | 包符「昭和の雨」 | ecl5_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/525 | 葵符「水戸の光圀」 | ecl5_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/526 | 倭符「邪馬台の国」 | ecl5_d.ecl / Sub2 | 完成；无新增差异 |
| TH33/527 |  | ecl3_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/528 | 雪符「ダイアモンドブリザード」 | ecl3_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/529 | 凍符「マイナスＫ」 | ecl3_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/530 |  | ecl4_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/531 | 寒符「コールドスナップ」 | ecl4_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/532 | 冬符「ノーザンウイナー」 | ecl4_c.ecl / Sub3 | 完成；无新增差异 |
| TH33/533 |  | ecl1_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/534 | 蛍符「地上の恒星」 | ecl1_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/535 | 蝶符「バタフライストーム」 | ecl1_c.ecl / Sub2 | 完成；无新增差异 |
| TH33/536 |  | ecl2_a.ecl / Sub2 | 完成；无新增差异 |
| TH33/537 | 闇符「ダークサイドオブザムーン」 | ecl2_b.ecl / Sub2 | 完成；无新增差异 |
| TH33/538 | 夜符「ミッドナイトバード」 | ecl2_c.ecl / Sub2 | 完成；无新增差异 |
| TH34/3405 | 六面道中「成群的亡灵」 | ecldata6.ecl / 时间轴 | F12 |
| TH34/3403 | 四面道中「骚灵们的合奏」 | ecldata4.ecl / 时间轴 | 完成；无新增差异 |
| TH34/3402 | 三道中「青之骚灵」 | ecldata3.ecl / 时间轴 | 完成；无新增差异 |
| TH34/3404 | 五道中「幽明之径」 | ecldata5.ecl / 时间轴 | F12、F13 |
| TH34/3400 | 一道中「初雪之妖精」 | ecldata1.ecl / 时间轴 | 完成；无新增差异 |
| TH34/3401 | 二道中「雪之回廊」 | ecldata2.ecl / 时间轴 | 完成；无新增差异 |
| TH34/3406 | EX 道中「妖妖梦・Extra」 | ecldata7.ecl / 时间轴 | F11 |
| TH34/3407 | PH 道中「妖妖梦・Phantasm」 | ecldata8.ecl / 时间轴 | F11 |
| TH34/3408 | 藍 非符 0 | ecldata8.ecl / Sub57 | 完成；无新增差异 |
| TH34/3411 | 紫 非符 1 | ecldata8.ecl / Sub70 | 完成；无新增差异 |
| TH34/3413 | 紫 非符 2 | ecldata8.ecl / Sub72 | 完成；无新增差异 |
| TH34/3415 | 紫 非符 3 | ecldata8.ecl / Sub73 | 完成；无新增差异 |
| TH34/3417 | 紫 非符 4 | ecldata8.ecl / Sub75 | 完成；无新增差异 |
| TH34/3419 | 紫 非符 5 | ecldata8.ecl / Sub77 | 完成；无新增差异 |
| TH34/3421 | 紫 非符 6 | ecldata8.ecl / Sub79 | 完成；无新增差异 |
| TH34/3423 | 紫 非符 7 | ecldata8.ecl / Sub81 | 完成；无新增差异 |
| TH34/3425 | 紫 非符 8 | ecldata8.ecl / Sub83 | 完成；无新增差异 |
| TH34/3440 | 紫奥義「弾幕結界」 | ecldata8.ecl / Sub129 | 完成；无新增差异 |
| TH34/3441 | 結界「生と死の境界」 | ecldata8.ecl / Sub127 | 完成；无新增差异 |
| TH34/3442 | 「人間と妖怪の境界」 | ecldata8.ecl / Sub119 | 完成；无新增差异 |
| TH34/3443 | 式神「八雲藍」 | ecldata8.ecl / Sub114 | 完成；无新增差异 |
| TH34/3444 | 魍魎「二重黒死蝶」 | ecldata8.ecl / Sub109 | 完成；无新增差异 |
| TH34/3445 | 罔両「禅寺に棲む妖蝶」 | ecldata8.ecl / Sub104 | 完成；无新增差异 |
| TH34/3446 | 罔両「八雲紫の神隠し」 | ecldata8.ecl / Sub102 | 完成；无新增差异 |
| TH34/3447 | 罔両「ストレートとカーブの夢郷」 | ecldata8.ecl / Sub100 | 完成；无新增差异 |
| TH34/3448 | 結界「光と闇の網目」 | ecldata8.ecl / Sub97 | 完成；无新增差异 |
| TH34/3449 | 結界「動と静の均衡」 | ecldata8.ecl / Sub93 | 完成；无新增差异 |
| TH34/3450 | 結界「夢と現の呪」 | ecldata8.ecl / Sub88 | 完成；无新增差异 |
| TH34/3451 | 式神「憑依荼吉尼天」 | ecldata8.ecl / Sub63 | 完成；无新增差异 |
| TH34/3452 | 式神「前鬼後鬼の守護」 | ecldata8.ecl / Sub60 | 完成；无新增差异 |
| TH34/3471 | 幻神「飯綱権現降臨」 | ecldata7.ecl / Sub123 | 完成；无新增差异 |
| TH34/3470 | 「狐狗狸さんの契約」 | ecldata7.ecl / Sub115 | 完成；无新增差异 |
| TH34/3469 | 式神「橙」 | ecldata7.ecl / Sub110 | 完成；无新增差异 |
| TH34/3468 | 式弾「ユーニラタルコンタクト」 | ecldata7.ecl / Sub106 | 完成；无新增差异 |
| TH34/3467 | 式弾「アルティメットブディスト」 | ecldata7.ecl / Sub101 | 完成；无新增差异 |
| TH34/3466 | 式輝「プリンセス天狐　-Illusion-」 | ecldata7.ecl / Sub99 | 完成；无新增差异 |
| TH34/3465 | 式輝「四面楚歌チャーミング」 | ecldata7.ecl / Sub97 | 完成；无新增差异 |
| TH34/3464 | 式輝「狐狸妖怪レーザー」 | ecldata7.ecl / Sub94 | 完成；无新增差异 |
| TH34/3463 | 式神「十二神将の宴」 | ecldata7.ecl / Sub88 | 完成；无新增差异 |
| TH34/3462 | 式神「仙狐思念」 | ecldata7.ecl / Sub85 | 完成；无新增差异 |
| TH34/3461 | 鬼神「飛翔毘沙門天」 | ecldata7.ecl / Sub61 | 完成；无新增差异 |
| TH34/3460 | 鬼符「青鬼赤鬼」 | ecldata7.ecl / Sub58 | 完成；无新增差异 |
| TH34/3480 | EX 非符 1 | ecldata7.ecl / Sub68 | 完成；无新增差异 |
| TH34/3481 | EX 非符 2 | ecldata7.ecl / Sub70 | 完成；无新增差异 |
| TH34/3482 | EX 非符 3 | ecldata7.ecl / Sub71 | 完成；无新增差异 |
| TH34/3483 | EX 非符 4 | ecldata7.ecl / Sub73 | 完成；无新增差异 |
| TH34/3484 | EX 非符 5 | ecldata7.ecl / Sub75 | 完成；无新增差异 |
| TH34/3485 | EX 非符 6 | ecldata7.ecl / Sub77 | 完成；无新增差异 |
| TH34/3486 | EX 非符 7 | ecldata7.ecl / Sub79 | 完成；无新增差异 |
| TH34/3487 | EX 非符 8 | ecldata7.ecl / Sub81 | 完成；无新增差异 |
| TH34/3488 | EX 橙 非符 0 | ecldata7.ecl / Sub55 | 完成；无新增差异 |
| TH34/4390 | 幽々子 非符 1 | ecldata6.ecl / Sub19 | 完成；无新增差异 |
| TH34/4391 | 六道剣「一念無量劫 -Lunatic-」 | ecldata6.ecl / Sub23 | 完成；无新增差异 |
| TH34/4392 | 幽々子 非符 2 | ecldata6.ecl / Sub29 | 完成；无新增差异 |
| TH34/4393 | 亡郷「亡我郷 -自尽-」 | ecldata6.ecl / Sub43 | 完成；无新增差异 |
| TH34/4394 | 幽々子 非符 3 | ecldata6.ecl / Sub34 | 完成；无新增差异 |
| TH34/4395 | 幽々子 非符 4 | ecldata6.ecl / Sub36 | 完成；无新增差异 |
| TH34/4396 | 亡舞「生者必滅の理 -魔境-」 | ecldata6.ecl / Sub50 | 完成；无新增差异 |
| TH34/4397 | 華霊「バタフライディルージョン」 | ecldata6.ecl / Sub52 | 完成；无新增差异 |
| TH34/4398 | 幽々子 非符 5 | ecldata6.ecl / Sub38 | 完成；无新增差异 |
| TH34/4399 | 幽曲「リポジトリ・オブ・ヒロカワ -神霊-」 | ecldata6.ecl / Sub55 | 完成；无新增差异 |
| TH34/4400 | 桜符「完全なる墨染の桜 -開花-」 | ecldata6.ecl / Sub58 | 完成；无新增差异 |
| TH34/4401 | 「反魂蝶 -八分咲-」 | ecldata6.ecl / Sub62 | 完成；无新增差异 |
| TH34/4402 | 妖夢 非符 1 | ecldata5.ecl / Sub38 | 完成；无新增差异 |
| TH34/4403 | 餓王剣「餓鬼十王の報い」 | ecldata5.ecl / Sub42 | 完成；无新增差异 |
| TH34/4404 | 妖夢 非符 2 | ecldata5.ecl / Sub48 | 完成；无新增差异 |
| TH34/4405 | 獄神剣「業風神閃斬」 | ecldata5.ecl / Sub57 | 完成；无新增差异 |
| TH34/4406 | 妖夢 非符 3 | ecldata5.ecl / Sub52 | 完成；无新增差异 |
| TH34/4407 | 修羅剣「現世妄執 -Lunatic-」 | ecldata5.ecl / Sub62 | 完成；无新增差异 |
| TH34/4408 | 畜趣剣「無為無策の冥罰」 | ecldata5.ecl / Sub66 | 完成；无新增差异 |
| TH34/4409 | 人神剣「俗諦常住」 | ecldata5.ecl / Sub70 | 完成；无新增差异 |
| TH34/4410 | 天神剣「三魂七魄」 | ecldata5.ecl / Sub75 | 完成；无新增差异 |
| TH34/4430 | アリス 非符 1 | ecldata3.ecl / Sub22 | 完成；无新增差异 |
| TH34/4431 | 操符「乙女文楽　-Lunatic-」 | ecldata3.ecl / Sub27 | 完成；无新增差异 |
| TH34/4432 | アリス 非符 1 | ecldata3.ecl / Sub32 | 完成；无新增差异 |
| TH34/4433 | 蒼符「博愛のオルレアン人形」 | ecldata3.ecl / Sub42 | 完成；无新增差异 |
| TH34/4434 | アリス 非符 2 | ecldata3.ecl / Sub36 | 完成；无新增差异 |
| TH34/4435 | 白符「白亜の露西亜人形 -Lunatic-」 | ecldata3.ecl / Sub48 | 完成；无新增差异 |
| TH34/4436 | アリス 非符 3 | ecldata3.ecl / Sub37 | 完成；无新增差异 |
| TH34/4437 | 雅符「春の京人形」 | ecldata3.ecl / Sub54 | 完成；无新增差异 |
| TH34/4438 | 咒詛「首吊り蓬莱人形」 | ecldata3.ecl / Sub56 | 完成；无新增差异 |
| TH34/4440 | 露娜萨 非符 1 | ecldata4.ecl / Sub58 | 完成；无新增差异 |
| TH34/5480 | 露娜萨 非符 2 | ecldata4.ecl / Sub64 | 完成；无新增差异 |
| TH34/5483 | 露娜萨 非符 3 | ecldata4.ecl / Sub68 | 完成；无新增差异 |
| TH34/4441 | 騒符「ライブポルターガイスト -Lunatic-」 | ecldata4.ecl / Sub121 | 完成；无新增差异 |
| TH34/4442 | 梅露兰 非符 1 | ecldata4.ecl / Sub76 | 完成；无新增差异 |
| TH34/5481 | 梅露兰 非符 2 | ecldata4.ecl / Sub80 | 完成；无新增差异 |
| TH34/5484 | 梅露兰 非符 3 | ecldata4.ecl / Sub83 | 完成；无新增差异 |
| TH34/4443 | 管霊「ゴーストクリフォード -Lunatic-」 | ecldata4.ecl / Sub138 | 完成；无新增差异 |
| TH34/4444 | 莉莉卡 非符 1 | ecldata4.ecl / Sub95 | 完成；无新增差异 |
| TH34/5482 | 莉莉卡 非符 2 | ecldata4.ecl / Sub98 | 完成；无新增差异 |
| TH34/5485 | 莉莉卡 非符 3 | ecldata4.ecl / Sub103 | 完成；无新增差异 |
| TH34/4445 | 鍵霊「ベーゼンドルファー神奏 -Lunatic-」 | ecldata4.ecl / Sub145 | 完成；无新增差异 |
| TH34/4446 | 偽弦「スードストラディヴァリウス」 | ecldata4.ecl / Sub128 | 完成；无新增差异 |
| TH34/4447 | 騒葬「スティジャンリバーサイド -Lunatic-」 | ecldata4.ecl / Sub133 | 完成；无新增差异 |
| TH34/4448 | 大合葬「霊車コンチェルトグロッソ怪」 | ecldata4.ecl / Sub135 | 完成；无新增差异 |
| TH34/4450 | レティ 非符 1 | ecldata1.ecl / Sub20 | 完成；无新增差异 |
| TH34/4451 | 霜符「フロストコラムス -Lunatic-」 | ecldata1.ecl / Sub29 | 完成；无新增差异 |
| TH34/4452 | レティ 非符 2 | ecldata1.ecl / Sub38 | 完成；无新增差异 |
| TH34/4453 | 寒符「リンガリングコールド -Lunatic-」 | ecldata1.ecl / Sub42 | 完成；无新增差异 |
| TH34/4454 | レティ 非符 3 | ecldata1.ecl / Sub39 | 完成；无新增差异 |
| TH34/4455 | 白符「アンデュレイションレイ」 | ecldata1.ecl / Sub52 | 完成；无新增差异 |
| TH34/4456 | 怪符「テーブルターニング」 | ecldata1.ecl / Sub55 | 完成；无新增差异 |
| TH34/4460 | 橙 非符 1 | ecldata2.ecl / Sub40 | 完成；无新增差异 |
| TH34/4461 | 仙符「鳳凰展翅　-Lunatic-」 | ecldata2.ecl / Sub45 | 完成；无新增差异 |
| TH34/4462 | 橙 非符 2 | ecldata2.ecl / Sub49 | 完成；无新增差异 |
| TH34/4463 | 式符「飛翔晴明」 | ecldata2.ecl / Sub56 | 完成；无新增差异 |
| TH34/4464 | 陰陽「晴明大紋」 | ecldata2.ecl / Sub58 | 完成；无新增差异 |
| TH34/4465 | 橙 非符 3 | ecldata2.ecl / Sub53 | 完成；无新增差异 |
| TH34/4466 | 天符「天仙鳴動」 | ecldata2.ecl / Sub64 | 完成；无新增差异 |
| TH34/4467 | 童符「護法天童乱舞」 | ecldata2.ecl / Sub66 | 完成；无新增差异 |
| TH34/4468 | 仙符「屍解永遠」 | ecldata2.ecl / Sub68 | 完成；无新增差异 |
| TH34/4469 | 方符「奇門遁甲」 | ecldata2.ecl / Sub75 | 完成；无新增差异 |
| TH34/4457 | 冬符「フラワーウィザラウェイ」 | ecldata1.ecl / Sub48 | 完成；无新增差异 |
| TH34/4439 | 紅符「紅毛の和蘭人形」 | ecldata3.ecl / Sub46 | 完成；无新增差异 |
| TH34/4472 | 闇符「霧の倫敦人形」 | ecldata3.ecl / Sub50 | 完成；无新增差异 |
| TH34/4473 | 廻符「輪廻の西蔵人形」 | ecldata3.ecl / Sub52 | 完成；无新增差异 |
| TH34/4470 | 仙符「鳳凰卵」 | ecldata2.ecl / Sub44 | 完成；无新增差异 |
| TH34/4471 | 鬼符「鬼門金神」 | ecldata2.ecl / Sub70 | 完成；无新增差异 |
| TH34/4475 | 弦奏「グァルネリ・デル・ジェス」 | ecldata4.ecl / Sub127 | 完成；无新增差异 |
| TH34/4476 | 合葬「プリズムコンチェルト」 | ecldata4.ecl / Sub132 | 完成；无新增差异 |
| TH35/3600 | 「風神様の神徳」 | stage06.ecl / BossCard5 | 完成；无新增差异 |
| TH35/3601 | 光学「ハイドロカモフラージュ」 | stage03.ecl / MBossCard1 | 完成；无新增差异 |
| TH35/3660 | stage03 非符一 | stage03.ecl / Boss1 | 完成；无新增差异 |
| TH35/3602 | 漂溺「光り輝く水底のトラウマ」 | stage03.ecl / BossCard1 | 完成；无新增差异 |
| TH35/3661 | stage03 非符二 | stage03.ecl / Boss2 | 完成；无新增差异 |
| TH35/3603 | 水符「河童の幻想大瀑布」 | stage03.ecl / BossCard2 | 完成；无新增差异 |
| TH35/3662 | stage03 非符三 | stage03.ecl / Boss3 | 完成；无新增差异 |
| TH35/3604 | 河童「スピン・ザ・セファリックプレート」 | stage03.ecl / BossCard3L | 完成；无新增差异 |
| TH35/3670 | stage04 中BOSS 非符 | stage04.ecl / MBoss | 完成；无新增差异 |
| TH35/3663 | stage04 非符一 | stage04.ecl / Boss1 | 完成；无新增差异 |
| TH35/3605 | 岐符「サルタクロス」 | stage04.ecl / BossCard1 | 完成；无新增差异 |
| TH35/3664 | stage04 非符二 | stage04.ecl / Boss2 | 完成；无新增差异 |
| TH35/3606 | 風神「二百十日」 | stage04.ecl / BossCard2 | 完成；无新增差异 |
| TH35/3665 | stage04 非符三 | stage04.ecl / Boss3 | 完成；无新增差异 |
| TH35/3607 | 「無双風神」 | stage04.ecl / BossCard3 | 完成；无新增差异 |
| TH35/3608 | 塞符「天上天下の照國」 | stage04.ecl / BossCard4 | 完成；无新增差异 |
| TH35/3651 | stage07 中BOSS 非符 | stage07.ecl / MBoss1 | 完成；无新增差异 |
| TH35/3609 | 神符「水眼の如き美しき源泉」 | stage07.ecl / MBossCard1 | 完成；无新增差异 |
| TH35/3610 | 神符「杉で結ぶ古き縁」 | stage07.ecl / MBossCard2 | 完成；无新增差异 |
| TH35/3611 | 神符「神が歩かれた御神渡り」 | stage07.ecl / MBossCard3 | 完成；无新增差异 |
| TH35/3652 | stage07 非符一 | stage07.ecl / Boss1 | 完成；无新增差异 |
| TH35/3612 | 開宴「二拝二拍一拝」 | stage07.ecl / BossCard1 | 完成；无新增差异 |
| TH35/3653 | stage07 非符二 | stage07.ecl / Boss2 | 完成；无新增差异 |
| TH35/3613 | 土着神「手長足長さま」 | stage07.ecl / BossCard2 | 完成；无新增差异 |
| TH35/3654 | stage07 非符三 | stage07.ecl / Boss3 | 完成；无新增差异 |
| TH35/3614 | 神具「洩矢の鉄の輪」 | stage07.ecl / BossCard3 | 完成；无新增差异 |
| TH35/3655 | stage07 非符四 | stage07.ecl / Boss4 | 完成；无新增差异 |
| TH35/3615 | 源符「厭い川の翡翠」 | stage07.ecl / BossCard4 | 完成；无新增差异 |
| TH35/3656 | stage07 非符五 | stage07.ecl / Boss5 | 完成；无新增差异 |
| TH35/3616 | 蛙狩「蛙は口ゆえ蛇に呑まるる」 | stage07.ecl / BossCard5 | 完成；无新增差异 |
| TH35/3657 | stage07 非符六 | stage07.ecl / Boss6 | 完成；无新增差异 |
| TH35/3617 | 土着神「七つの石と七つの木」 | stage07.ecl / BossCard6 | 完成；无新增差异 |
| TH35/3658 | stage07 非符七 | stage07.ecl / Boss7 | 完成；无新增差异 |
| TH35/3618 | 土着神「ケロちゃん風雨に負けず」 | stage07.ecl / BossCard7 | 完成；无新增差异 |
| TH35/3659 | stage07 非符八 | stage07.ecl / Boss8 | 完成；无新增差异 |
| TH35/3619 | 土着神「宝永四年の赤蛙」 | stage07.ecl / BossCard8 | 完成；无新增差异 |
| TH35/3620 | 「諏訪大戦　～ 土着神話 vs 中央神話」 | stage07.ecl / BossCard9 | 完成；无新增差异 |
| TH35/3621 | 祟符「ミシャグジさま」 | stage07.ecl / BossCard10 | 完成；无新增差异 |
| TH35/3666 | stage06 非符一 | stage06.ecl / Boss1 | 完成；无新增差异 |
| TH35/3667 | stage06 非符二 | stage06.ecl / Boss2 | 完成；无新增差异 |
| TH35/3668 | stage06 非符三 | stage06.ecl / Boss3 | 完成；无新增差异 |
| TH35/3669 | stage06 非符四 | stage06.ecl / Boss4 | 完成；无新增差异 |
| TH35/3622 | stage06 符卡一 | stage06.ecl / BossCard1 | 完成；无新增差异 |
| TH35/3623 | stage06 符卡二 | stage06.ecl / BossCard2 | 完成；无新增差异 |
| TH35/3624 | stage06 符卡三 | stage06.ecl / BossCard3H | 完成；无新增差异 |
| TH35/3625 | stage06 符卡四 | stage06.ecl / BossCard4 | 完成；无新增差异 |
| TH35/3671 | 六面道中「妖怪之山的妖精」 | stage06.ecl / main | F14 |
| TH35/3680 | 一道中「初雪之妖精」 | stage01.ecl / main | F14 |
| TH35/3681 | 二道中「人里の妖精」 | stage02.ecl / main | F14 |
| TH35/3682 | 三道中「河童の渓谷」 | stage03.ecl / main | F14 |
| TH35/3683 | 四道中「妖怪の山」 | stage04.ecl / main | F14 |
| TH35/3684 | 五道中「洩矢の王国跡」 | stage05.ecl / main | F14 |
| TH35/3685 | EX道中「ネイティブフェイス」 | stage07.ecl / main | F14 |
| TH35/3642 | stage01 中BOSS 非符 | stage01.ecl / MBoss | 完成；无新增差异 |
| TH35/3630 | 葉符「狂いの落葉」 | stage01.ecl / MBossCard1 | 完成；无新增差异 |
| TH35/3643 | stage01 非符一 | stage01.ecl / Boss1 | 完成；无新增差异 |
| TH35/3631 | 秋符「秋の空と乙女の心」 | stage01.ecl / BossCard1 | 完成；无新增差异 |
| TH35/3644 | stage01 非符二 | stage01.ecl / Boss2 | 完成；无新增差异 |
| TH35/3632 | 豊作「穀物神の約束」 | stage01.ecl / BossCard2 | 完成；无新增差异 |
| TH35/3633 | 厄符「厄神様のバイオリズム」 | stage02.ecl / MBossCard1 | 完成；无新增差异 |
| TH35/3645 | stage02 非符一 | stage02.ecl / Boss1 | 完成；无新增差异 |
| TH35/3634 | 疵痕「壊されたお守り」 | stage02.ecl / BossCard1 | 完成；无新增差异 |
| TH35/3646 | stage02 非符二 | stage02.ecl / Boss2 | 完成；无新增差异 |
| TH35/3635 | 悲運「大鐘婆の火」 | stage02.ecl / BossCard2 | 完成；无新增差异 |
| TH35/3636 | 創符「流刑人形」 | stage02.ecl / BossCard3 | 完成；无新增差异 |
| TH35/3647 | stage05 中BOSS 非符 | stage05.ecl / MBoss | 完成；无新增差异 |
| TH35/3637 | 秘術「一子相伝の弾幕」 | stage05.ecl / MBossCard1 | 完成；无新增差异 |
| TH35/3648 | stage05 非符一 | stage05.ecl / Boss1 | 完成；无新增差异 |
| TH35/3638 | 奇跡「客星の明るすぎる夜」 | stage05.ecl / BossCard1 | 完成；无新增差异 |
| TH35/3649 | stage05 非符二 | stage05.ecl / Boss2 | 完成；无新增差异 |
| TH35/3639 | 開海「モーゼの奇跡」 | stage05.ecl / BossCard2 | 完成；无新增差异 |
| TH35/3650 | stage05 非符三 | stage05.ecl / Boss3 | 完成；无新增差异 |
| TH35/3640 | 準備「サモンタケミナカタ」 | stage05.ecl / BossCard3 | 完成；无新增差异 |
| TH35/3641 | 大奇跡「八坂の神風」 | stage05.ecl / BossCard4 | 完成；无新增差异 |

## 来源与记录修正

- 完成范围是指定三项的静态源码审阅，不把源码候选数量当成执行覆盖或形式化等价证明；未宣称全游戏逐帧、画面、道具或平台差异都通过。
- 原作资源与复原工程只读；用户现有android/shaders/texture_BoxBlur49.frag和th10test.lstges不纳入本提交。
- 按要求没有运行游戏、Lua、探针、弹幕模拟、测试、编译或构建。所有本轮数字来自二进制解析、文本展开/对表和词法结构审阅。
- TH35激光按实际412/413/428/429/431..434及操作指令归类；旧清单用500段作候选不是TH10激光的正确编号，本报告已纠正。
- 前批C14把公共task.Wait(0)描述为至少让出一帧并不准确；当前Ltask本来就允许零等待当帧继续，该项不再计作新增差异。
- TH07旧索引121条目的8个文件哈希与当前workspace原件不同，本轮刷新；1970条WAVE已进一步与当前原始二进制的有效时间轴对应，排除-1终止标记之后的伪指令。

原作数据位于`workspace/original/ECL`，反汇编位于`workspace/decompiled/ecl`，五个复原工程位于`workspace/reconstructions`。JSON保存本次实际读取的文件指纹。

TH31/406原索引误指向`ecldata6/Sub15`，已更正为`ecldata7/Sub15`（宿主Sub14），并重建该条闭包与指纹。TH31/3439的入口归类同时补入`card_sources.py`，注册索引条目数同步更新为522。
