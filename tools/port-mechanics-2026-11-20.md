# 天舞宝轮、胡桃钳与 Like Dreamer 攻击练习

## 修复与原作证据

- 春雪 `b587`「天舞宝轮」：原 `Batch.Shoot` 排除 `IsLase` 母弹，移植版未排除，生成了额外点弹。普通绑定及深绑定均补回过滤；永夜共用路径同步修正。
- 两作的 `Batch.r`、`Batch.type` 为浮点数，`range`、`Barrage.type` 为整数。修复错误截断半径插值、发射器类型插值和整数增量的行为，在生成弹体时才截断类型。
- 原春雪 `Time.cs` 给 Cover 子事件设置 `special2=1`；永夜设置 `ConditionMode.GlobalTime`。子事件按整张弹幕时钟执行，区域停止更新后，已复制进弹体的事件继续存在，直到有效区域明确检测到离开。恢复这两项语义，方块才能按时退场。永夜使魔仍是底层 Barrage，也执行覆盖事件。
- 原春雪 `BossCard.Update` 在入场后对 TIME 卡调用 `Boss.Hide`，每帧 `alpha+=(0-alpha)/20`。恢复本体及光晕淡出；`TIMENOTHIDE` 保持可见。
- 永夜「胡桃钳」在原作机体符卡练习中，灯笼效果已创建，但桥接漏掉深度为 -1 的 `Equipment.DrawOverTop`。接入原作四个装备绘制入口，按深度分层；对象随所属自机一起清理。
- 永夜桥接只补了 Character 默认字段，未执行完整构造器。默认移动范围为零，首次操作会把灯笼钳到原点。按原 `Game.ScreenRange=(48,24,576,672)` 和 Character 构造器恢复横向 `[63,609]`、纵向 `[39,686]`。
- 原永夜 `BossCard` 只在整卡结束时 `FreeControl/ClearNegativeStatus`。同卡内替换弹幕后继续保留控制及异常状态，整卡结束仍正常解除。
- 原永夜使魔因底层 Barrage 寿命结束产生的 `NeedDeleteType.Dead` 也会令 `Familiar.Die` 生效。恢复自然结束的换段通知，避免只登记受击死亡而卡住机关阶段。
- Like Dreamer 61 个攻击练习入口恢复所选攻击开放前一帧的完整对象、父子引用与状态；下一帧走正式攻击初始化。进入练习不再运行之前攻击及其超时转场。完整 Boss 和道中入口保留正常流程。

原工程只读。春雪来源 `THMHJ.PartII.Restored/src/THMHJ/THMHJ`；永夜来源 `THMHJ.Restored/src/THMHJ/THMHJ`。轨迹夹具的原始代码与数据指纹见 `th37-tests/oracle/wheel/sources.json`。

## 可重复的专项检查

```sh
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_wheel.lua
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_fields.lua
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_motion.lua
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_soul.lua
STAGE_STRICT_NEW=1 luajit tools/th39-tests/check.lua motion
STAGE_STRICT_NEW=1 luajit tools/th39-tests/check.lua transitions
STAGE_STRICT_NEW=1 luajit tools/th39-tests/check_control.lua
luajit tools/likedreamer_parity/practice.lua
```

`check_wheel` 重放原始 C# 的 5400 帧，比较 6066 个点弹采样，核对数量、消失时间和位置；随机输入固定为 0.5。夹具排除了激光，不能把点弹轨迹通过当成激光轨迹对照。两作的原作半径和属性类型也来自 C# 声明，而非目测调整。

重新生成原作轨迹需 .NET SDK 和 pycryptodome：

```sh
python3 tools/th37-tests/oracle/wheel/generate.py --source /path/to/THMHJ.PartII.Restored
```

重新生成 Like Dreamer 入口：

```sh
python3 tools/generate_likedreamer_practice.py --reference '/path/to/Like Dreamer/reverse/reconstructed/project/src'
```

`--reference` 可省略，只用于记录复原 C++ 的指纹；正式输入、输出指纹保存在 `mod/GAME/ports/dreamer/LikeDreamer/practice_sources.json`。快照由正式 Lua 状态机沿超时路线生成，一帧比对证明与该路线初态相同，不替代逐条 C++ 轨迹对照。

Mac 原生检查先按 `AGENTS.md` 构建资源，再从隔离数据目录启动：

```sh
BOSSRUSH_MAC_DATA=/tmp/bossrush-hutao-check BOSSRUSH_MAC_TEST=port-mechanics BOSSRUSH_MECHANICS_CARD=39088 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
BOSSRUSH_MAC_DATA=/tmp/bossrush-hutao-ph-check BOSSRUSH_MAC_TEST=port-mechanics BOSSRUSH_MECHANICS_CARD=39113 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
BOSSRUSH_MAC_DATA=/tmp/bossrush-wheel-check BOSSRUSH_MAC_TEST=port-mechanics BOSSRUSH_MECHANICS_CARD=37050 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
BOSSRUSH_MAC_DATA=/tmp/bossrush-dreamer-check BOSSRUSH_MAC_TEST=dreamer-practice 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
```

胡桃钳检查使用方向键按下沿解除原作石化，再长按右键，记录受控灯笼持续移动、原作场地范围及顶层绘制。第850帧注入使魔死亡通知，仅核对同卡换段的控制保持；这项注入不证明使魔伤害正确。Like Dreamer 通过真实符卡练习入口逐一进入61个攻击，每次返回标题再切换，记录目标阶段已开放及实际部件数量。结果范围是 macOS，不代表 Android/Windows 实测。

`BOSSRUSH_MECHANICS_NATURAL=1` 跳过注入并运行2200帧，用于检查胡桃钳原始机关与自然使魔结束后的换段。
