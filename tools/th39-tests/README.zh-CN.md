# 东方幕华祭·永夜篇原生移植

`THMHJ.Restored` 的基线是 Part III v1.02。项目内使用 TH39、关卡号 37，练习 ID 为 39000–39122。顺序模式提供 Lunatic 1–6 面、Extra 和 Phantasm。104 个战斗条目由 34 个非符和 70 张符卡组成，另有 19 个道中时间轴窗口。符卡练习收录 8 张 Last Word 和 5 张依赖灯笼计数的 Last Spell，六面条件为 0 的三张永夜返保留在顺序模式。

转换器读取本地重建源码和 Content 的 XNA 数据，把 For 时间轴、发射器及事件展开为 Lua。运行时以 60 Hz 更新原作坐标，场地按 2/3 投影到 LuaSTG。普通弹、直线与曲线激光、敌机、使魔和 Boss 使用原生对象。敌机的出生、追瞄、复制和等待命令共用同一份时间轴。多个 Boss 各自推进弹幕，使用同一阶段血量和剩余时限。原始的射速、弹数、生命和血量来自脚本。弹体池上限沿用原版 10000，溢出时保留已生成对象并计数。

## 重建

从仓库根目录执行。若重建工程没有 Content，可用同版本备份目录作为 `--content`。Python 依赖 PyCryptodome 和 Pillow。

```sh
python3 tools/th39-tests/export.py \
  --source /Users/happyelements/crack/THMHJ.Restored \
  --content /Users/happyelements/repo_resource_backups_20260702/THMHJ.Restored/src/THMHJ/bin/x64/Debug/net472/Content
```

输入文件哈希、转换数量及演出和代理事件计数记录在 `mod/GAME/th39/sources.json`。游戏直接加载生成的 Lua 和 PNG。

五面「绝对弹界（违规终极射击）」及对应难度的队友绑定另由`export_teammates.py --content <原作Content目录>`补导，产物为`teammates.lua`和`teammate_sources.json`。保留灵、魔、早、妹四条机体分支，使魔槽位按原指令创建不受击的队友轨迹对象。原作机体将位置传入`SpecialSystem.UpdateTeammate`；随机模式的宿主机体由独立对象复用原`Character`、`Equipment`的跟随、保护圈和退场逻辑。`teammate_barrier.lua`为505～508效果中的完整`paopao`圆圈接入挡弹：按实际弹图中心和缩放计算椭圆，在宿主碰撞与穿越判定前拦截弹体，不受炸弹的不可消弹标志限制；圆圈退场及破碎的`shield1`碎片不提供保护。攻击原有Cover事件独立保留；切卡回收效果及引用。此修复未运行游戏测试。

## 差异

- 原版背景贴图按关卡及符卡变体分层重组，BGM 使用原版曲目与循环点。Boss 和敌机图来自原版，Boss 使用原始待机、转向、循环、回正动画、双层魔法阵及对应开符立绘。五面队友绑定及保护圈使用上文的补导数据和原作对象；对白、过场、护送演出仍有省略。
- 石化使用方向键解除，定身和强制移动使用项目自机锁定。原作灯笼联动、部分立体遮罩、扫掠判定、物理体积和激光贴图仍有差异。个别大型视觉对象仅使用弹图和基础判定。
- 使用原脚本的主要开场和攻击时限。EX、PH 的使魔连续战斗可按使魔击破切换，练习保留脚本时限作为退出条件。

## 验证

流星花火的深绑定副本按原作 `Batch.Shoot` 归父弹体所有，跨 840 帧循环保留事件、插值与本地时钟，避免重复创建分支和集中爆炸。春雪篇同类副本也保留事件状态；两作的本地时间推进仍各自沿用对应原作规则。永夜普通弹和背景/死亡特效共用原作 15 帧出生雾的贴图、尺寸及大图缩放，寿命到期保留 `Dispel` 的 30 帧尾段；已消除父弹体停止作为绑定发弹源。

专项回归：`luajit tools/th39-tests/check_fireworks.lua` 覆盖流星花火四轮、父子链、三帧 37/31/25 发、跨循环 8 帧间隔、普通弹/特效出生雾、大图翻转、消失尾段和消弹后绑定；`luajit tools/th37-tests/check_binding_loop.lua` 检查春雪跨三轮循环的深绑定事件状态。

星降之里等密集弹幕在 Mac/Android 使用现有 `AndroidProjectBullet` 一次提交最终几何与判定，普通弹、出生雾及无遮罩背景粒子使用 `AndroidRenderSprite` 提交本次顶点色，减少逐属性 setter 和临时颜色对象；有遮罩的绘制继续沿用原裁切路径。图像句柄按控制器/场景资源作用域缓存，同名场景图重建时使缓存失效。`luajit tools/th39-tests/check_native_fastpath.lua` 对照原路径检查参数、负缩放、判定、颜色和资源重建；原生同种子练习与随机模式的终点状态保持一致，记录见 `verification-starlit-2026-11-25.json`。

2026-11-25 的后续采样确认主要开销来自机器码区域反复耗尽：2700 帧内出现 21516 次 mcode 分配失败和 21517 次 trace 清空，CPU 大部分时间在重新编译。移动端共用启动入口现在于任何热脚本之前设置 16 MiB 的有界机器码区域和 8000 条 trace 上限；Mac 复跑分配失败为零，仅一次 trace 清空。战斗窗口平均 CPU 由 10.055 ms 降至 4.464 ms，1410 个对象峰值及终点状态哈希保持一致。另将逐帧发射器闭包改为共享函数、背景按层/混合/出生顺序线性分桶、缓存未变化旋转的裁切三角值。背景排序与旧实现的 780 次实际绘制参数逐项一致。原始数据及 Metal 提交阻塞、未测安卓的限制见 `verification-starlit-followup-2026-11-25.json`。

```sh
luajit tools/check_sequence_mode.lua
luajit tools/check_slim.lua
luajit tools/check_fields.lua mod/GAME/th39.lua mod/GAME/th39/runtime.lua
STAGE_STRICT_NEW=1 luajit tools/th39-tests/check.lua motion
STAGE_STRICT_NEW=1 luajit tools/th39-tests/check.lua flow
STAGE_STRICT_NEW=1 luajit tools/th39-tests/check.lua transitions
STAGE_STRICT_NEW=1 luajit tools/th39-tests/check.lua short
STAGE_SEED=11111 STAGE_STRICT_NEW=1 luajit tools/th39-tests/check.lua long 39044,39050,39060,39088,39089,39113,39114
python3 macos/build.py --update-assets
python3 tools/th38-tests/native.py --sequence thmhj3_lunatic --frames 550 --damage --out /tmp/th39-mac-stage1
python3 tools/th38-tests/native.py --card 39060 --frames 500 --repeat --out /tmp/th39-mac-six
```

首波弹幕 b1420 验证两发、15 帧雾化及首次有效帧的投影位移。严格桩检查八条路线、全部 123 个练习入口和 11 个切换阈值。Mac 真机测试使用临时数据目录，检查开场位移、实际伤害与双 Boss 同种子重试。Windows 原版逐帧对照和 Android 真机验证仍待完成。


挑战模式流星花火扔雷（2026-11-26）
----------------------------------
共用消弹入口使用 `THlib/bullet/cancel_state.lua` 跳过已经开始消散或待删除的对象。春雪与永夜篇在消弹回调里只关判定，下一次逻辑更新再转入GHOST组，保留原对象与淡出寿命。花映冢、兽、季节与拍照入口同样跳过既有消散，避免重复回调、掉落或重置源激光计时；首次消弹的免疫和强制清场规则不变。

`luajit tools/check_repeat_cancel.lua` 检查重叠/持续消弹与原寿命；`BOSSRUSH_MAC_TEST=fireworks-bomb` 在隔离数据目录运行正式挑战模式，记录第600帧扔雷前后的回调、轨迹检查点及CPU耗时。前后结果见 `verification-fireworks-bomb-2026-11-26.json`；该Mac采样不代表安卓真机帧率。
