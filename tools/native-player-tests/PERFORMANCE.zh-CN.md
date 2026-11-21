# Windows 逐作性能采样

`tools/profile_windows_suite.py` 串行运行当前十二作的一个高负载攻击和一个末关入口。实际选择写在脚本的 `GAMES` 中；这不是全部符卡、机体和路线的穷举。逐次结果保留卡号、路线、原作机体、逻辑与绘制耗时、对象数、Lua 堆、引擎指纹和源码树指纹。

```powershell
python tools/profile_windows_suite.py --out windows/build/performance-new --frames 1800
python tools/profile_windows_suite.py --out windows/build/performance-night-new --games th39 --frames 3600
python tools/profile_windows_cases.py --case practice --level 40 --card 72039 --shoot --frames 1800 --fps 60 --engine-stats --frame-detail --out windows/build/performance-like-new
```

输出目录必须是新的。夹具在独立目录运行，源码素材使用硬链接；覆盖对照 Lua 前先解除目标硬链接。不会载入源码目录的 `User/`、`replay/`。`--override-dir` 只替换隔离目录中的 Lua；引擎对照用 `--engine-file`。

所有原生场景在加载游戏之前锁定 BGM、SE 的全局混音音量为零，正式游戏采样的每一行都复查两路音量。静音只作用于测试进程。保留正常音频调用，避免通过删除音频逻辑改变测试负载。

默认 960×720、窗口模式、60 FPS、关闭垂直同步。持续射击、站桩、保护计时 120；夹具保留每个 Boss 阶段首次观察的 HP，以覆盖发弹时间窗。此输入不用于证明正常死亡、伤害和通关流程。进入结算或暂停菜单便停止记录，禁止把之后的空闲帧算入战斗性能。

统计从第 300 帧开始，到实际结束之前。比较不同长度的运行时另取相同帧窗口；FPS 是引擎平滑计数，逻辑加绘制耗时不包含提交和等待。引擎完整帧计时另行记录，GPU 计时来自延迟查询缓存。截图、JIT 采样和编译会干扰耗时，诊断及截图运行应与正式性能复测分开；游戏进程串行运行。

`--capture` 在正式场景第 120 帧及每 600 帧保存截图。画面对照需按该作的实际视口选择完整战斗区域，各作的原作画幅不同。`--sample` 提供 LuaJIT 调用栈，仅用于定位热点。

## 等价性检查

```powershell
python tools/profile_windows_cases.py --case target-query --frames 4 --fps 60 --out windows/build/target-query-new
luajit tools/native-player-tests/check_unity_transform.lua
luajit tools/native-player-tests/check_snow_damage.lua
luajit tools/native-player-tests/check_mhj_target_collision.lua
luajit tools/native-player-tests/check_likedreamer_context.lua
luajit tools/native-player-tests/check_likedreamer_registry.lua
luajit tools/native-player-tests/check_th43_bent.lua
luajit tools/native-player-tests/check_object_cache.lua
```

使用 LuaJIT 的 5.1 语义。目标查询原生检查覆盖普通表、准备后的表和原生成员视图三条路径，共 72,000 次比较，并检查自定义属性、遮蔽字段、严格边界、无敌、NaN/Inf 和视图回收。

## 原生目标视图的约束

`CreateSourceTargetView` 仅用于春雪/永夜桥接自行维护、在一次对象更新期间成员固定的列表。桥接刷新目标后重建视图，绑定新自机时释放旧视图。视图复制成员顺序，不复制位置；原生查询实时读取对象位置和碰撞开关，可能命中时继续检查对象引用和无敌状态。对象池 ID、出生唯一号及几何元数据身份均参与检查；失配时回到完整查询。

快速路径只接受标准 `GetAttr`、没有同名原始遮蔽字段、且由 `NativeActorCollision.bind` 管理形状的对象。自定义对象继续完整查询。不要在已准备的视图内更改对象元表或新增原始坐标遮蔽字段；如需这样做，应重建视图或禁用该对象的快速标记。

受弹几何以 `NativeActorCollision` 的 `damage` 为准。`bind` 和跟随尺寸更新同步原生副本，不从精灵尺寸、体术范围推测受弹范围。新增几何写入入口时应通过 `bind`，不得绕过它直接改 `damage` 数组。原生查询不执行伤害、删除、发弹或运动。

Windows 补丁由 `windows/build_source_mesh.py` 在 `windows/engine.lock.json` 指定的官方干净源码上构建。Lua 改动在散装目录直接生效；新增原生接口必须更新可执行文件。Mac、Android 未提供这些 Windows 接口时继续使用 Lua 查询，性能结论不能跨平台外推。

代理缓存使用 `mod/GAME/ports/object_cache.lua`，每帧最多检查 128 项，只移除 `IsValid` 为假的键，避免弱键表的值反向引用键而长期保留整个对象图。存活代理保持身份；外部仍持有已失效代理时，其引用也不受影响。绑定自机时清空缓存并重置扫描游标。
