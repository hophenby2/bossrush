# 挑战与混沌模式原生回归

`rogue_native_stress.lua` 仅由隔离检查入口加载，正式客户端不引用它。检查沿 `RogueTen.start` 进入挑战或混沌模式，使用真实对象更新、碰撞、绘制、资源预载、卡间清理和返回标题。不会读取源码目录的 `User/` 或 `replay/`。

为重复覆盖攻击窗口，夹具保护自机，并在样本结束前恢复敌机血量；到指定帧后通过血量归零结束该卡。`speed` 大于 1 时，每次显示更新推进多次正常逻辑帧，仅用于崩溃检查，不用于帧率、流畅度或逐帧画面结论。没有修改正式攻击参数、时限或发射器。

配置示例：

```json
{
  "platform": "Windows Sub",
  "bent_contract": true,
  "runs": [
    {"mode": "staged", "seed": 2026112602, "limit": 38, "frames": 600, "speed": 4},
    {"mode": "single", "seed": 2026112603, "limit": 24, "frames": 900, "speed": 4},
    {"mode": "single", "seed": 2026112601, "cards": [39011], "limit": 1, "frames": 1400, "speed": 1, "capture": true},
    {"mode": "single", "seed": 2026112610, "cards": [37004, 72036, 70403], "limit": 3, "frames": 900, "speed": 2, "bombs": [180, 480]}
  ]
}
```

`cards` 只用于混沌模式的定向复现，条目仍必须存在于正式候选池；未指定时沿正式随机抽卡。各轮自动返回标题再重新进入。`bombs` 通过正式强化规则的 Bomb 入口触发并记录成功与库存，不额外补充库存。

`bent_contract` 额外调用两个平台的实际 `BentLaserData`，对照包络、活动节点、改宽、缩短节点队列、点/圆/旋转椭圆/矩形和固定宽度接口，共 103968 次查询。结果保存在 `bent_contract.bits`，应逐位对照而非只比较命中总数；这不代表全部曲线轨迹或画面已逐帧等价。

Windows 从仓库根目录执行，输出目录必须不存在且位于源码目录之外：

```powershell
python tools/rogue_native_stress.py --out E:/workspace/rogue-native-run --config E:/workspace/stress-config.json
```

输出包含 `User/stress-result.json`、逐样本 `User/stress-progress.jsonl`、引擎日志和源码/引擎指纹。`capture` 对 39011 的三轮第 185 帧额外保存实际画面。`complete` 为真且 `errors` 为空才表示整份配置完成；提前结束的结果仍保留，不能当成通过。`runs[].completed` 是完成张数，早期夹具记录的下一张排队条目不计入完成张数。

安卓使用独立模拟器实例或测试设备，生成的诊断 APK 需要本机测试签名；不作为正式安装包交付：

```powershell
python tools/rogue_native_stress.py --out E:/workspace/rogue-android-run --config E:/workspace/stress-config.json --android-base <当前500MB安装包> --overlay-source
```

`--overlay-source` 将当前正式 `THlib/`、`mod/` Lua 覆盖进诊断包，不重编码素材；原生库和其余压缩资源来自指定安装包。仅适用于没有修改原生补丁的回归。签名安装后，将配置写入应用私有 `files/bossrush/User/stress-config.json`，将 `benchmark stress=1` 写入 `files/bossrush/User/android-diagnostics`，然后启动应用。用 ADB 读取同目录的结果和进度，原生日志在 `files/lstg_log.txt`。完成后移除诊断开关或卸载该测试包。不要在玩家日常使用的设备/模拟器实例上覆盖存档或开启夹具。

模拟器若通过转译运行 arm64 包，结果仅证明该模拟器中的运行路径；不能视为安卓真机性能或所有设备兼容性结论。原作源码对照、Lua 模拟、原生绘制和整卡通关的覆盖范围分别记录。

本轮实际故障、配置、成功轮次、未完成批次、结果/画面指纹及覆盖范围见 `verification-rogue-native-2026-11-26.json`。正式包需从提交后的源码另行构建，诊断包不作为发布包。
