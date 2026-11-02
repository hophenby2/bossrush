# 已落实到具体符卡／非符的原作对齐问题

审计基线：`c986862cd3d920897cbed8f8c0802691bf03be8f`，2026-11-02。

本次确认 **6 个关卡条目、7 类未对齐行为**。下表中的 ID 是 Boss Rush HD 的练习／历史槽位号；永夜抄原作符卡号 218 在本项目对应 **364**，不能混用。

| 条目 ID | 角色与具体符卡／非符 | 已确认的问题 | 下文编号 |
| --- | --- | --- | --- |
| 3600 | 神奈子「風神様の神徳」（风神之神德） | 丢失禁止常规消弹设置；首次加速早 1 帧 | A01、A02 |
| 3616 | 诹访子 蛙狩「蛙は口ゆえ蛇に呑まるる」 | 场内弹执行退场指令时直接回收，跳过消散动画与保留弹槽 | A03 |
| 3619 | 诹访子 土着神「宝永四年の赤蛙」 | 同上；对应此卡自己的退场程序 | A03 |
| 3620 | 诹访子「諏訪大戦　～ 土着神話 vs 中央神話」 | 同上；对应此卡自己的退场程序 | A03 |
| 4442 | 梅露兰 第一非符 | 第 85、205 帧遗漏 ECL 指定的 135 号施法动画 | A04 |
| 364 | 爱丽丝「格兰吉纽尔剧场的怪人」（原作 Last Word 218） | 16 个人偶光环全部同向；形态切换缺过渡特效和音效；有效受击缺闪色 | A05、A06、A07 |

本报告附带真实卡片入口的离线采集程序和原始指令证据，未修改游戏玩法代码。这里的“确认”指原始 ECL／复原引擎语义与当前 Lua 路径可以逐项对应；尚未进行 Windows 或 Mac 实机截图验收。

## 输入、复现方式与计时口径

原作资料位于相邻的 `../workspace`：`original/ECL/th08`、`th07`、`th10` 是已整理的原文件入口；带地址反汇编在 `decompiled/ecl/{8,7,10}`。文件来自用户指定的 `/Users/happyelements/crack/thtkGUI-th20tr`，没有把原作资源或复原仓库拷入本 Git。

在游戏仓库根目录执行：

```sh
python3 tools/th3x-tests/audit_card_alignment.py \
  --workspace ../workspace \
  --output /tmp/alignment-evidence.json
```

也可以分别运行不依赖外部原文件的两个 Lua 探针：

```sh
luajit tools/audit_th3x_card_alignment.lua
luajit tools/audit_th31_familiar_alignment.lua
```

提交内的 [alignment-evidence-2026-11-02.json](alignment-evidence-2026-11-02.json) 保存游戏源文件哈希、4 个原始 ECL 的 SHA-256、18 条相关指令的地址／时间／难度掩码／原始字节，以及 6 个条目的采集结果。Python 采集器核对全部指令头，并直接核对其中 16 条定长指令的操作数字节；两条 `ins_92` 的变长字符串操作数来自带地址反汇编，记录中明确标为未单独核对操作数字节。

运行的是实际注册的卡片 `init/frame`、真实协程、真实子弹钩子和 ANM 状态机，没有替换成手工拼出来的弹幕配置。资源入口、对象调度、碰撞和绘制使用离线桩。TH35／TH34 探针沿用 `check_th35_patterns.lua` 的初始化部分，并专门修正其回收桩：**`object.RawDel` 直接写 `status='del'`，不执行 `class.del`**，不能误把它当作会触发消散回调的 `object.Del`。游戏定义见 `THlib/lib/LObjectEvents.lua:28` 和 `:58`；底层对应相邻 `LuaSTG-Sub` 的 `LuaBinding/modern/GameObject.cpp` 中 STATUS 写入与 `onQueueToDestroy` 两条不同路径。

表中的卡内帧从 `card.init` 后第一次执行任务记为 `t=0`；弹龄 `age` 是该弹自身 `frame` 已被调用的次数。新弹在下一轮对象更新开始执行，因此“卡内帧－出生帧”和弹龄在这里一致。坐标使用 Boss Rush HD 的场地坐标，中心为原点、y 朝上。玩家固定在 `(0,-176)`，随机流使用现有检查器的确定性初值；运行顺序固定，场内退场示例的坐标属于这个输入，不表示所有录像都在该坐标触发。

## A01 · 3600「風神様の神徳」：常规消弹保护丢失

**原作位置：** `stage06.ecl` → `BossCard5` → `BossCard5_atN`／`BossCard5_at2`。两支枪分别在 `0xb4ac`、`0xa9e8` 用 `ins_409` 配置变换记录：`kind=0x1000, int0=10000`。记录时间均为子程序 `t=0`，作用于它之后发射的弹，而非卡内第 10000 帧。

该指令在 [TH10 BulletTransform.cpp 的 SET_CANCEL_BEHAVIOR](https://github.com/N0zoM1z0/th10/blob/44dbc59c18d87001dfcb7fe66e17296161fedbbb/src/BulletTransform.cpp#L116) 写入 `cancelBehavior`；[EnemyEclDispatcher.cpp](https://github.com/N0zoM1z0/th10/blob/44dbc59c18d87001dfcb7fe66e17296161fedbbb/src/EnemyEclDispatcher.cpp#L427) 的常规消弹分支遇到非零值会跳过此弹。计数随弹更新递减。

**当前位置：** `mod/GAME/th35.lua:242` 的专用 `spawn_bullet` 保存了等待、加速和弹雾状态，没有保存这个计数。`THlib/bullet/visual_match.lua:107` 的 `can_cancel` 只检查通用 TH10 弹的 `o.tb.cancel`；本卡的专用弹没有 `tb`，因此放行。

**真实卡实测：** 首发弹在卡内 `t=150` 出生；弹龄 8 时 `can_cancel=false` 应成立，实际返回 **true**。继续运行到弹龄 190，再调用游戏真实的 `cancel_bullet(first,'Kill',false)`，确实到达 `object.Kill`。采集时只截获 Kill 调用以保存证据，没有伪造受保护弹作对照。

**玩家可见影响：** 以常规消弹圈接触本卡这些弹时，本应保留的弹被消掉。切卡强制清场不受此保护约束，不属于本项问题。

**修复验收点：** 两支专用枪都保留原作的保护计数；同一颗真实首发弹的普通消弹应被拒绝，强制清场仍按清场流程处理。

## A02 · 同一张 3600：WAIT 后首次加速早 1 帧

**原作位置：** `BossCard5_atN` 的 `0xb7cc` 与 `BossCard5_at2` 的 `0xadfc` 配置 `kind=0x8000, int0=I2`；`0xb4dc`／`0xaa18` 配置后续 `kind=0x20`、持续 120 帧的加速。

[TH10 BulletRuntime.cpp](https://github.com/N0zoM1z0/th10/blob/44dbc59c18d87001dfcb7fe66e17296161fedbbb/src/BulletRuntime.cpp#L85) 的顺序为先 `AdvanceTransformProgram`，后更新 WAIT。倒计时到 0 后，下一次更新先清掉 WAIT 活动位；再下一次 Advance 才接入加速。当前 `th35_bullet_frame`（`mod/GAME/th35.lua:222`）只有 `if th_wait>0 then --wait elseif ... then accelerate`，省掉了清活动位这一帧。

**真实首发弹：** 初速 `0.001`、`I2=160`、加速度 `0.01976`、出生过渡 8 次更新；以下期望值按上述原作顺序计算，未把通用 Lua 实现当作原作引擎运行结果。

| 卡内帧 | 弹龄 | 原作顺序应有速度 | 当前速度 |
| --- | --- | --- | --- |
| 316 | 166 | 0.001 | 0.001 |
| 317 | 167 | 0.001 | 0.001 |
| 318 | 168 | 0.001 | **0.02076** |
| 319 | 169 | 0.02076 | **0.04052** |
| 320 | 170 | 0.04052 | **0.06028** |

**影响：** 静止等待后的弹群提前一帧开始运动；这里没有据此调整速度、数量或密度。修复应对齐 WAIT 的活动位生命周期。

## A03 · 3616／3619／3620：指定退场直接释放弹体

三张卡各自可达的原始 ECL 记录如下；都为 `ins_409(kind=0x10000)`，在发弹子程序 `t=0` 写入后续变换程序。

| 条目 | 原作子程序 | 地址 | 记录索引（原作从 0 起） |
| --- | --- | --- | --- |
| 3616 蛙狩「蛙は口ゆえ蛇に呑まるる」 | `stage07/BossCard5_at`、`BossCard5_at2` | `0x8cd4`、`0x9158` | 4 |
| 3619 土着神「宝永四年の赤蛙」 | `stage07/BossCard8_at` | `0xaf18` | 7 |
| 3620「諏訪大戦　～ 土着神話 vs 中央神話」 | `stage07/BossCard9_at` | `0xc694` | 5 |

**原作行为：** [BulletTransform.cpp 的 DESPAWN](https://github.com/N0zoM1z0/th10/blob/44dbc59c18d87001dfcb7fe66e17296161fedbbb/src/BulletTransform.cpp#L141) 调用 [EnemyCancelBulletRecord](https://github.com/N0zoM1z0/th10/blob/44dbc59c18d87001dfcb7fe66e17296161fedbbb/src/EnemyEclDispatcher.cpp#L361)。场内弹进入 `state=3`，给 ANM 发 interrupt 1；后续更新半速移动，直到动画结束才释放原弹槽。原作也有屏外快捷回收分支，所以探针只取明显在场内的弹。

**当前位置：** `mod/GAME/th35.lua:618` 的 `TK_DESPAWN` 仅置 `b.dead=true`，`:774` 随即调用 `object.RawDel`。这条路径不经过已实现的 `OriginalBulletVisual.emit_despawn`，因此别处的正常消弹特效不能弥补此处。

**逐卡实测：** 三张卡都从注册入口启动，未手工造带 DESPAWN 的弹。下表是各卡采到的第一批场内退场中的一个实例：

| 条目 | 卡内触发帧 | 弹龄 | 位置 `(x,y)` | 触发前速度 | 帧末状态 |
| --- | --- | --- | --- | --- | --- |
| 3616 | 288 | 167 | `(-43.7594,-69.4469)` | 0.01 | 对象无效，弹槽 2 可复用 |
| 3619 | 529 | 448 | `(-92.6531,-3.8160)` | 0.01 | 对象无效，弹槽 2 可复用 |
| 3620 | 712 | 327 | `(-128.0000,18.0310)` | 0.901 | 对象无效，弹槽 332 可复用 |

三个实例的 `_original_despawning`、`_native_death_effect` 均为 false，证明没有进入原生消散路径。

**玩家可见影响：** 应逐渐消散的场内弹突然消失；原弹槽也提前可用，存在改变后续满池发弹结果的可能。本次没有把“可能改变满池结果”写成已经测出的额外弹数差异。

**修复验收点：** 上述三个真实触发点转入无碰撞消散；不提前释放原弹槽；仍按原作区分场内和屏外路径。

## A04 · 4442 梅露兰第一非符：两次施法动作缺失

**原作位置：** `ecldata4.ecl/Sub76` 在 `t=85 @0xd9a4`、`t=205 @0xdabc` 执行 `ins_95(135)`，同时生成 `Sub77` 乐器灵。此处调用的 `Sub60` 只设置 30 帧运动后立即返回，没有等待，所以第二次仍是墙钟第 **205** 帧，不能误加成 235 帧。

**当前位置：** `mod/GAME/th34.lua:13166` 的卡 4442 在对应两处生成乐器灵，没有设置本体 135 号动画。`THlib/WalkImageSystem.lua:94` 的原作分支直接走 `OriginalStageVisual.tick`；三姐妹通用姿态表（`THlib/anm/stage_visual.lua:461`）包含站立／移动／收势，跳过 `base+1` 的施法脚本。

**真实卡实测：** 运行 `t=0..500`，真实子机出生帧为 `[85,85,205,205]`。两个时点本体分别是 VM **37** 和 **42**；原始脚本 135 对应当前导出数据中的 VM **38**。整段只出现 VM `[37,39,40,41,42]`，没有 38；截获的本体 `set_script` 调用也没有 135。

**玩家可见影响：** 乐器灵和攻击照常出现，本体仍为站立或移动收势动作。修复验收应同时核对第 85、205 帧，以及循环后的重复触发；不能只给开场补一次动画。

## A05 · 364 爱丽丝 Last Word：16 个人偶光环全部同向

**原作位置：** `ecldata_al.ecl/Sub1` 在 `t=110 @0x3f8/0x4ac` 两段循环各执行 8 次 `ins_92("Sub2",...)`，共生成人偶 16 个。附着使魔创建路径见 [TH08 EclRunLow.inl](https://github.com/N0zoM1z0/th08/blob/08c7f00f81e35db8206d917b14f47883930beef6/src/EclRunLow.inl#L796)：光环创建后，按原作敌机槽号 `enemyIndex & 1` 翻转 z 角速度。干净的练习开场连续分配这些槽，16 个光环应有正反两个方向。

**当前位置：** `mod/GAME/th31.lua:1375` 的实际人偶经过 `th31_combat.actor` 接入 `THlib/anm/stage_visual.lua:76` 的 `S.familiar`。后者直接创建 etama 48 号光环，没有保留原作槽号奇偶导致的反向。

**真实卡实测：** 启动项目条目 364，正常运行到 `t=151`；找到了真实生成的 16 个人偶，其光环 `vm.omega[3]` **全部为 `-0.05235988`**。探针没有替对象指定假 `enemyIndex`。

**玩家可见影响：** 人偶本体的贴图可以正确，围绕它的光环仍不符合原作的正反旋转。修复时需要保留原作敌机分配／槽号语义，不能用每次 Render 随机选方向。

## A06 · 同一张 364：低速／高速切换缺过渡特效和音效

**原作路径：** 这些附着人偶的 `Enemy::UpdateYoukaiAlignment` 会在变成人类／妖怪形态的边界生成一次过渡效果，同时向光环发 interrupt 1／2，并切换绘制组。[TH08 EnemyManager.cpp](https://github.com/N0zoM1z0/th08/blob/08c7f00f81e35db8206d917b14f47883930beef6/src/EnemyManager.cpp#L871) 调用 `EFFECT_FAMILIAR_HIDE/UNHIDE` 和对应音效；[EffectManager.cpp](https://github.com/N0zoM1z0/th08/blob/08c7f00f81e35db8206d917b14f47883930beef6/src/EffectManager.cpp#L138) 将这两个效果映射到 **etama 60／59**。这是 ECL 附着使魔应调用的原引擎行为，不是说 ECL 中有两条 59／60 号贴图指令。

**当前位置：** `th31_combat.lua:226` 与 `stage_visual.lua:76` 会更新形态、碰撞和光环 interrupt，但没有生成两种过渡效果与音效；`M.render` 的低速染蓝也不能替代过渡粒子。此结论不涉及“低速条件是否成立”。

**真实卡实测：** 上述同一批人偶在 `t=153..168` 按住低速，在 `169..184` 恢复高速。`th08_youkai` 与光环的 `youkai` 都确实由 false→true→false；拦截真实 `OriginalANM.new` 入口期间，**60 号与 59 号脚本创建次数都是 0，PlaySound 调用次数也是 0**。人偶 layer 一直为 -600；原作绘制组 2→0→2 的转换也未在这条路径体现，但这里没有进一步声称已复现了与其他对象遮挡顺序错误的截图。

**修复验收点：** 每个人偶在每次形态边界产生一次对应过渡效果，形态稳定时不逐帧重播；音效调用遵循原作音效队列的合并规则；绘制组切换需另做重叠画面验收。

## A07 · 同一张 364：有效受击后没有原作闪色

**原作位置：** `ecldata_al/Sub2` 在 `0x5d0` 给人偶设置 `24×24` 受弹框，`0x5e4` 给 30 帧免伤。免伤结束后，人类形态受到有效伤害时，[TH08 EnemyManagerUpdate.cpp](https://github.com/N0zoM1z0/th08/blob/08c7f00f81e35db8206d917b14f47883930beef6/src/EnemyManagerUpdate.cpp#L600) 设置主 VM 的 `color2=(255,96,128)`、颜色覆盖标志和 `damageFlashTimer=1`，随后按原逻辑解除。这里同样是 ECL 人偶应继承的原引擎受击行为。

**当前位置：** `mod/GAME/th31_combat.lua:237` 的 `damage` 扣血、传递父伤害，没有设置对应颜色与闪色计时；原生绘制走 `OriginalStageVisual.draw`，旧替代图的受伤颜色不会自动补齐它。

**真实卡实测：** 同一批人偶运行至 `t=151` 后，第一只人偶已不在出生免伤期。向真实受伤入口施加伤害 10，再推进到 `t=152`：HP 确实下降 **10**，`guard=false`；主 VM `color2` 仍为 **`[255,255,255]`**，`secondary=false`。

**玩家可见影响：** 能打到人偶，但缺少原作的受击闪色反馈。修复验收要覆盖受击帧和解除帧，并保留妖怪形态原本的蓝色半透明显示。

## 本次结论的边界

- 原始 ECL、复原引擎语义和卡片入口三者均有对应证据的项目，才列入上面 7 类缺陷。
- 原始文件中另有 `BossCard4_at2` 的 `0x10000`，但没有在本次条目 3615 的真实入口中证实可达，**没有把 3615 加入 A03**。同理，没有因为通用施法姿态表缺项就直接把其他 Boss 全部判错。
- 之前统计的未实现 ANM 操作、视觉循环数量、流程选路、Rank／血量口径适配，不列为本次新增具体缺陷；已修复的贴图银行、伪激光拖尾、自机命中特效方向也不重复列入。
- 当前注册的 TH31–TH35 共 521 个条目；本次证实上述 6 个，不代表其余 515 个已经逐帧对齐，TH32／TH33 本次没有新增已证实条目。

## 验证记录

- Python 采集器通过原始 ECL 校验，并从 6 个真实条目生成完整 JSON。
- 两个 Lua 探针可独立运行；输出仅采集当前差异，不把发现缺陷当作“测试通过所以已修复”。
- 相同输入重新采集的 JSON 应完全一致；具体执行结果见本提交的证据文件。
- 重复采集后 `cmp` 完全一致；已有子弹显示检查 **2239 项**、TH31 战斗检查 **698 项**、TH34／TH35 短程及跨卡清场检查 **128 项**均通过。这些检查通过不表示本报告列出的原作差异已修复。
