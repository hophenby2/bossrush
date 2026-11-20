# 移植符卡运行性能

运行期批量同步作用于春雪、雪莲华的普通弹体。原生 `AndroidProjectBullet` 一次提交图像、位置、旋转、缩放、判定、图层、分组和碰撞开关，仍使用原组件的数据类型和换算。只在提交结束时重算判定数据；手动积分对象的引擎速度仍置零。图像名称变化时继续经过原资源查找。激光、曲线、敌机和 Boss 的特殊同步不改用这个接口。

没有该接口的平台继续逐字段同步。春雪不再为没有 Cover 事件的弹体逐帧分配空表；夏夜祭复用绑定运动的四个历史值，并保留原反向更新顺序。原作的发弹、随机数、动画、判定数值、寿命和回收边界不作性能降级。

尝试过雪莲华背景粒子缓存/批量绘制和夏夜祭批量同步，虽通过行为对照，但连续运行的性能没有可靠收益，部分窗口更慢，最终撤回。雪莲华背景和夏夜祭的属性提交路径保留原实现，夏夜祭只保留绑定历史复用、同角度三角函数复用和遍历函数复用。

永夜双 Boss 的附属代理退出时直接回收，不再继承普通杂鱼的死亡回调。该代理没有杂鱼气泡特效索引，原回调会在部分阶段结束时报错。

## 采集

先更新原生程序和包内资源，再在隔离存档中运行：

```sh
python3 macos/build.py --update-assets
python3 tools/profile_rogue_entry.py --runtime --cards 37067,38041,68041,68053,39060 --frames 1800 --out /tmp/bossrush-runtime
python3 tools/profile_rogue_entry.py --runtime --speed 4 --frames 900 --out /tmp/bossrush-runtime-cross
python3 tools/profile_rogue_entry.py --runtime --runtime-sample --cards 68041 --frames 1800 --out /tmp/bossrush-runtime-stack
```

`--runtime` 固定时钟种子为20261120，对局的 `ran_seed` 为29952；不射击、自机保护，沿真实 RogueTen 入口推进。记录每帧逻辑、绘制、关卡/自机时钟，每60帧记录对象和 Lua 内存。每次进入下一张卡时保存部分报告，完成后 `passed` 才为真。客户端有批量接口时，还在私有采集入口执行240组、3360项原setter与批量接口的字段对照；正常游戏不执行这些检查。

正式耗时使用速度1、不启用栈采样，仅统计非准备帧中 `fight_age=180..1800` 的区间。这里测的是主线程逻辑和绘制的墙钟，并非 GPU 执行时间。速度4只检查较长流程和对象规模；连续跨卡的 LuaJIT 栈采样出现过停滞，因此栈采样限制为独立进程中的单卡，不作为耗时基线。

## 行为对照

```sh
python3 tools/check_runtime_optimizations.py
luajit tools/th37-tests/check_motion.lua
luajit tools/th38-tests/check_motion.lua
luajit tools/th40-tests/recycling.lua 7200
python3 tools/check_rogue_ports.py --out /tmp/bossrush-runtime-regression
```

轨迹工具从指定 Git 基线提取参考代码，只写入临时目录。对照春雪191/367、雪莲华一面及六面、夏夜祭「八百里的烈焰」和「流星神话」；同时检查普通接口与批量同步调用路径的字段、位置、判定、事件、寿命和随机流。Lua 桩中未赋值的 `rect` 为nil，真实引擎默认Circle的getter返回false，输出按这一已确认的引擎规则归一。原生字段换算由上面的客户端接口对照覆盖，模拟不能代替设备实测。

本轮原生验证只在macOS/Metal执行。完整前后数据、哈希和覆盖限制见 `tools/verification-runtime-performance-2026-11-20.json`。

这次包含原生接口变更，Mac/Android需通过构建工具同步重建原生程序；只有替换Lua资源无法启用批量路径。缺少新接口的引擎仍可运行逐字段回退路径。
