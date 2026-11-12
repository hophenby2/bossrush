# 夏夜祭原生移植首版

本 worktree 基于 `origin/original-sequence` 的干净提交
`617c8a84ee4e4e5016e9cfd0e8449ed19b349dba`，分支为 `codex/thsss-native-sequence`。
没有修改另一个 agent 使用的 `Boss Rush HD-slim`。为避开其 TH37 命名，本作使用 TH38，level 35。

## 内容与入口

- 练习：关卡练习、符卡练习增加“夏夜祭原作”。
- 顺序模式：`thsss_lunatic` 六面、`thsss_extra` Extra，均为包含 FSC 的全阶段路线。
- 90 个阶段：51 个符卡位置、27 个非符、12 个道中片段。机体分支实际引用 81 个符卡类。
- 四条攻击路线 A/B/C/D 对应原作灵梦、魔理沙、早苗、恋；C/D 暂用现有 LuaSTG 灵梦/魔理沙自机。
- 纳入全部 937 个原 MBG 的离线编译结果；当前阶段入口按项目 th31–th35 的范围选择 Lunatic/Extra。
- 1159 个原图切片、43 个音效、15 首音乐；音乐循环点取原 GameState/Story 的 PCM 样本参数。

游戏运行时只加载 Lua 常量和已编译的 Lua 回调，不读取 MBG，不运行 CrazyStorm、C# 或中文事件解释器。
点弹、敌机、直线/射线、曲线分别使用原生 `bullet`、`enemy`、`laser`、`bent_laser` 派生对象；
发射器、遮罩、特效使用原生 `object`。手动运动对象的引擎 `vx/vy` 保持零。

## 来源与时钟

来源是本地 THSSS.exe 反编译出的 `Boss_*`、`SpellCard_SSS*`、`GameState_SSS*`、
`CS_Data`、`BaseEmitter_CS`、`EventGroup`、`Execution` 等，以及原作 CS/Image/Sound/BGM。
`mod/GAME/th38/source_manifest.json` 记录原 exe 与 937 个文件的 SHA-256；
`phase_manifest.json` 记录阶段与源类、难度分支、HP、防御、时间和攻击文件的对应关系。

阶段顺序取 Boss 的 Life/Ctrl 调用链。连续道中保持原 TimeMain，Boss 在场只阻止新的道中根发射器；
B 段等待中 Boss 退场后，从实际 TimeMain 续接。第一面偏移为 `+60`，其余为 `-60`。
四、六面只有贯穿全道中的 A 控制器。四面目录中的 B 文件未被原 GameState 调用，因此不加入流程。
每面按原代码重建 `MyRandom(0)`，道中和 Boss 共用该状态。

## 已知差异

这是可运行的首版，还不能称为原作逐帧复现。

1. Direct3D 场景和蓄力粒子使用原图平面/粒子代理；直线与曲线激光使用 LuaSTG 原生碰撞。
   射线椭圆判定、反射激光的网格拼接等尚未逐帧核对，不能声明判定完全一致。
2. 使用现有 LuaSTG 自机和资源规则。原作星屑、结界、分数、专属自机与部分敌机掉落行为没有完整移植。
   顺序模式固定包含全部 FSC，不按原作结界次数解锁；该变化已标在入口和卡头。
3. 对话、结局与原 FSC 入场过程由 BossRush 转场代理，原舞台和攻击时钟不计这些对话。
4. 部分含绑定及多组事件的样本在较长时间后出现随机流差异。属性的单精度舍入和特效随机消耗
   尚未完整还原。`verification/reference-samples.json` 仅证明所列窗口与种子的采样结果。
5. 编译出的低难度文件供来源追踪和后续扩展，目前没有 Easy/Normal/Hard 整关入口。

## 验证

现有检查涵盖：90 个阶段注册、Lua 5.1 语法、严格实例字段、对象回收、四条攻击路线、
道中快杀/慢杀交接，以及练习/顺序/音乐注册回归。验证记录保存在 `verification/`。

```sh
STAGE_STRICT_NEW=1 luajit tools/check_stage.lua mod/GAME/th38.lua 120
luajit tools/th38-tests/sequence.lua
luajit tools/th38-tests/laser.lua
luajit tools/th38-tests/runtime.lua 3600
TH38_TEST_IDS=68006,68053,68075,68085,68089,68090,68091 luajit tools/th38-tests/runtime.lua 7200
luajit tools/check_sequence_mode.lua
luajit tools/check_original_practice.lua
luajit tools/check_sequence_media.lua
luajit tools/check_fields.lua mod/GAME/th38.lua mod/GAME/th38/native.lua
```

`runtime.lua` 的 A 路线运行指定时长，其他三路线每段运行 600 帧。退出后检查所有派生对象均已回收。
3600 帧检查覆盖 360 个阶段/路线组合；7200 帧压力检查覆盖 7 个重点阶段。
另用三个种子对四个点弹阶段进行 600 帧威胁采样，结果只记录、不调原作参数。
该采样不包含激光，也没有原作出膛狙分类回调，不能直接视为原作难度评分。

```sh
STAGE_SEED=11111 THREAT_CARDS=3,6,26,50 luajit tools/th38-tests/threat.lua mod/GAME/th38.lua 600
```

Mac 原生检查使用临时存档目录，不读取真实玩家数据。加速检查关闭音效，并在战斗阶段 300 帧后
强制击破，只证明阶段衔接；正常速率声画另测。加速播放高频音效曾触发 OpenAL 音源重启崩溃，
这也是加速测试静音的原因。

```sh
BOSSRUSH_MAC_TEST_CARD=68003 BOSSRUSH_MAC_TEST_FRAMES=420 python3 macos/verify.py --smoke --mode battle
BOSSRUSH_MAC_TEST_SPEED=120 BOSSRUSH_MAC_TEST_KILL=300 BOSSRUSH_MAC_TEST_END=1 python3 macos/verify.py --smoke --mode th38-sequence
BOSSRUSH_MAC_TEST_SEQUENCE=thsss_extra BOSSRUSH_MAC_TEST_ROUTE=D BOSSRUSH_MAC_TEST_SPEED=120 BOSSRUSH_MAC_TEST_KILL=300 BOSSRUSH_MAC_TEST_END=1 python3 macos/verify.py --smoke --mode th38-sequence
```

## 重新导出与打包

三个导出脚本只读取原作目录。`export_thsss.py`、`export_phases.py` 的 `--source` 指向反编译的
`Shooting` 目录；`export_audio.py` 的 `--source` 指向其上级完整反编译目录。
参数和回调均由工具生成，修改兼容逻辑时应改导出器后重跑。

Mac 可用 `package_mac.py --base-app <已有.app> --engine <已有LuaSTG-x缓存>` 复用原生程序，
在本 worktree 重新打包。它调用项目正式资源管线，重写 WAV 的标准数据块；直接把源码 WAV
覆盖进 app 会导致截图中出现过的 `se_focus.wav` 解码失败。
