# AGENTS.md

本文件面向当前 Boss Rush HD 精简分支，按 2026-11-20 的源码结构重写。这里保留项目入口、工作约束与构建方式；具体原作差异、素材来源和历史验证记录放在各模块文档中。源码与文档冲突时先核对实际入口，不沿用旧文档的结论。用户当前指令优先。

## 项目与运行平台

- 游戏逻辑使用 Lua 5.1 / LuaJIT。新增注释、说明和界面文案使用中文，原始标识符与来源信息保留原名。
- 仓库包含 Lua 游戏内容、素材，以及 Android / macOS 的引擎补丁和构建工具。
- Windows 入口为 `launch.lua`、`core.lua`，使用 LuaSTG Sub；Android 与 Mac 使用 `android/engine.lock.json` 固定的 LuaSTG-x 和本项目兼容层。不能把一个平台的运行结果当成其他平台的实测。
- Mac 是可运行的 arm64 原生应用，使用 Metal。Android 当前构建目标为 `arm64-v8a`。
- 游戏 Lua 修改后，Windows 散装目录由引擎直接载入；已经打包的 `.app` / APK 必须更新包内资源才会生效。

## 当前内容与编号

实际加载范围以 `mod/content.lua` 为准，练习入口见 `mod/original_practice.lua`，顺序路线见 `mod/sequence_catalog.lua`。

| 游戏脚本 | 内部 level | 作品 |
| --- | ---: | --- |
| `mod/GAME/th31.lua` | 29 | 永夜抄 |
| `mod/GAME/th32.lua` | 30 | 红魔乡 |
| `mod/GAME/th33.lua` | 31 | 文花帖 |
| `mod/GAME/th34.lua` | 32 | 妖妖梦 |
| `mod/GAME/th35.lua` | 33 | 风神录 |
| `mod/GAME/th37.lua` | 35 | 幕华祭春雪篇 |
| `mod/GAME/th38.lua` | 36 | 雪莲华 |
| `mod/GAME/th39.lua` | 37 | 幕华祭永夜篇 |
| `mod/GAME/th40.lua` | 38 | 夏夜祭 |
| `mod/GAME/th41.lua` | 39 | 祈华梦 |
| `mod/GAME/th42.lua` | 40 | Like Dreamer |
| `mod/GAME/th43.lua` | 41 | 栖霞园 |

文件编号、内部 level、练习显示序号、原作编号和 `card_id` 是不同概念。仓库仍有历史关卡文件，文件存在不等于当前入口会加载它。`core.lua` 的 `STAGE_COUNT` 是历史 level 范围的上界，不是当前保留作品的数量。

不要为消除编号空位而重排 level、`card_id` 或现有练习索引；这些值参与存档、录像和续玩。改变内容入口时联查 `mod/content.lua`、`mod/original_practice.lua`、`mod/sequence_catalog.lua`、`mod/GAME/original/stage_flow.lua` 与对应作品注册代码，按实际依赖更新。

## 代码入口

| 范围 | 主要位置 |
| --- | --- |
| 启动和载入 | `launch.lua`、`core.lua`、`mod/root.lua`、`mod/_editor_output.lua` |
| 标题、选项和练习界面 | `THlib/UI/`、`mod/original_practice.lua` |
| 关卡与顺序模式 | `mod/main_stage.lua`、`mod/original_sequence.lua`、`mod/sequence_catalog.lua`、`mod/GAME/original/stage_flow.lua` |
| 随机模式 | `mod/roguelike.lua`、`mod/rogue_dual.lua`、`mod/rogue_pool.lua`；新作卡池/资源/伤害单位见 `mod/rogue_ports.README.zh-CN.md` |
| Boss、敌机和自机基类 | `THlib/enemy/`、`THlib/player/` |
| 原作自机、死亡和判定适配 | `THlib/native_players.lua`、`THlib/native_player_*.lua`、`THlib/native_actor_collision.lua` |
| TH31–TH35 自机和资源规则 | `THlib/sequence_resources.lua`、`mod/GAME/original/players/` |
| 原作 ANM 与显示接入 | `THlib/anm/`、`THlib/bullet/visual_match.lua`、`mod/GAME/original/` |
| 春雪、雪莲华、永夜、夏夜祭的关卡后端 | `mod/GAME/th37/`、`mod/GAME/th38/`、`mod/GAME/th39/`、`mod/GAME/th40/` |
| 共用移植桥接及原脚本 | `mod/GAME/ports/`；祈华梦在 `ports/theis/`，Like Dreamer 在 `ports/dreamer/` |
| 栖霞园适配 | `mod/GAME/th43/` |
| 共用移动端入口与兼容层 | `android/lua/`、`android/native/`、`android/patch_engine.py` |
| Mac 输入、渲染及平台差异 | `macos/lua/`、`macos/native/`、`macos/patch_engine.py` |
| 素材与导出数据 | `Resources/`、各作品的 `catalogue.lua` / 清单，以及 `tools/` 下对应导出器 |

`IncludeLuaFile` 会根据加载状态排队或立即执行，不能仅凭文件排列假定所有依赖已初始化。作品同时可能通过关卡练习、符卡练习、顺序和随机模式进入；修复共用逻辑时沿实际调用链确认影响范围。

## 修改原则

1. **按原作修复移植。** 发弹、运动、贴图、缩放、旋转、碰撞、系统状态和死亡消弹规则都需要对应原作证据。不得为了密度评分、性能数字或“看起来合理”改攻击参数、补弹或编造生命周期。
2. **先分清错误所在层。** 原作数据、导出器、作品运行时、自机桥接、共用框架和引擎兼容层各有职责。不要用默认值、吞异常或近似弹型掩盖上一层丢失的数据。
3. **来源工程保持只读。** 路径优先查当前会话、导出工具参数和 `sources.json` / `source_manifest.json` 等清单；清单里的旧绝对路径需要确认仍然存在。运行包不得依赖本机原作目录。
4. **导出数据与生成代码保留来源。** 改动生成内容时检查对应导出器；若错误来自生成过程，应修正导出器并更新相应产物。运行时桥接错误直接修在桥接层，避免无关的整批重新导出。
5. **保持各作时间和坐标口径。** 例如雪莲华在一个宿主逻辑帧内推进两个原作 tick；不能把所有作品统一套用同一缩放、帧率、无敌时间或出屏范围。坐标换算位置需与现有后端一致。
6. **资源池与状态要能跨练习切换。** 注意 global / stage 资源池、同名资源隔离、缓存失效、重试和返回标题后的状态恢复。切卡、退出时还原时间倍率、控制锁、背景及相关效果。
7. **保护玩家数据。** 不修改、删除或打包源码目录的 `User/`、`replay/`；原生运行检查使用独立数据目录。不要改动原作存档。
8. **只提交任务相关内容。** 构建缓存、临时探针、日志、密钥和未要求发布的安装包不纳入源码提交。不要编辑 `.cache/`、`build/`、`dist/` 中的副本来代替修改正式源码。

## 本项目容易踩到的接口差异

- 使用 LuaJIT 的 5.1 语义，不用 Lua 5.4 的 `luac` 判断兼容性。需要多个返回值时直接接收函数调用；`and` / `or` 表达式会截断额外返回值。
- 自定义对象方法不能假定可从引擎实例上继承读取。沿现有写法调用模块函数或 `类表.方法(对象, ...)`；引擎回调使用规定的签名。
- Boss 的 `before`、`init`、`frame`、`render`、`del` 回调接收的是 Boss 实例。不要把卡表字段当实例字段；卡片自己的计时也不能直接使用 Boss 出生以来的 `timer`。
- `enemybase` 的 `colli` 赋值会经过 `_colli`。需要立即更新引擎碰撞开关时，把计算出的同一个局部值传给 `SetAttr`，不要写入后又读回旧引擎值。
- 手动积分运动的对象需要避免引擎再次用 `vx` / `vy` 积分。对象出屏与回收规则应取自原作；`bound=false` 后不能依赖引擎自动回收。
- 全局 `sin` / `cos` 等使用角度，`math.sin` / `math.cos` 使用弧度；原作数据与绘制角度不要混用。
- 图片切换可能改变引擎判定尺寸。贴图中心、绘制缩放、体术范围和受弹范围分别核对，相关适配入口为 `THlib/native_actor_collision.lua`。

## 构建与交付

在仓库根目录执行。显示版本来自 `THlib/UI/UI.lua` 的 `ui.version`，构建工具通过 `tools/release_version.py` 读取；Android 的安装升级序号另由清单 `versionCode` 管理。

用户可见版本统一为 `YYYY.MM.DD.N`，例如 `2026.11.25.1`；`N` 是当天发布序号，从 1 开始，同日新版本递增，重建同一版本沿用原号。游戏内显示、Android `versionName` 与交付包名必须一致，新版本同时递增 `versionCode`。安卓包名使用 `BossRushHD-Android-<版本>-500MB.apk`（其他容量档同理）；修复代号、提交号和处理器架构只写入构建记录，不加入用户可见版本或交付文件名。

### macOS

```sh
# 首次构建，或需要完整重建原生程序
python3 macos/build.py

# 更新游戏资源；工具也会按补丁指纹判断是否需要重建引擎
python3 macos/build.py --update-assets

open 'macos/dist/Boss Rush HD.app'
```

`macos/run.command` 会先更新资源再启动，运行中的游戏需要先退出。产物是 `macos/dist/Boss Rush HD.app`，使用本地临时签名。Mac 构建复用 Android 的资源准备管线，不能通过手工覆盖资源绕过格式转换与打包策略。

### Android

```sh
# 完整构建，采用当前压缩选项
python3 android/build.py --lossy-images --compress-audio --optimize-fonts --transparent-webp --compact-music
```

产物在 `android/dist/`，包括固定名称测试 APK、带界面版本号的 APK 和 SHA-256 文件。`--package-only` / `--update-assets` 用于复用已有原生库，前提是原生补丁与编译选项匹配；新增解码能力或原生接口时不能只换 Lua。实际依赖版本见 `android/engine.lock.json`。

图片分类、裁剪和压缩策略位于 `android/asset_policy.py`、`android/build.py` 及相关工具中；优化包体不能直接改坏正式源素材。包体预算以本次 APK 的实际字节数计算，不沿用历史版本的大小结论。

Mac 和 Android 均支持 `--game-root` 指定源码快照。用户要求发布时应对应实际提交构建，并区分“本地已打包”“已推送源码”和“已上传 Release”，不要用旧安装包代替新提交的构建。

## 验证与排查的范围

- 按用户反馈的作品、卡号、机体、入口和触发条件选择检查。修渲染就覆盖实际绘制路径，修跨作品练习就覆盖切换，修泄漏就持续记录对象和发射器数量及帧耗时；不要用无关的全项目扫描代替复现。
- 用户明确要求不验证时，不运行验证，也不声称已经通过。文档修改不需要重建客户端。
- Lua 模拟、字段审计、原生运行、截图以及原作轨迹对照各有不同覆盖范围。模拟跑通不能证明画面正确，短窗口不能证明长期回收正常，加载了原图也不能证明所有行为已对齐。
- 如果需要原生检查，Mac 数据目录用 `BOSSRUSH_MAC_DATA` 隔离；测试工具通常自行创建临时存档。不要为复现覆盖真实玩家数据。
- 旧报告只证明报告对应的源码、输入和窗口。只有实际检查过的内容才能写成通过；未测平台和未覆盖分支不能外推。

按问题选择已有工具，而非每次全部运行：

| 问题范围 | 现有入口 |
| --- | --- |
| 关卡注册、Lua 模拟、字段 | `tools/check_stage.lua`、`tools/check_fields.lua` |
| 原作五作的脚本与显示 | `tools/th3x-tests/`、各作工具目录、`mod/GAME/original/README.zh-CN.md` |
| 春雪、雪莲华、永夜、夏夜祭后端 | `tools/th37-tests/`、`tools/th38-tests/`、`tools/th39-tests/`、`tools/th40-tests/` |
| 自机、判定、死亡、特殊系统、跨作品练习 | `tools/native-player-tests/README.zh-CN.md` 及对应专项脚本 |
| Mac 平台基础功能 | `macos/verify.py`、`macos/tests/` |
| Android 包体、图片和音乐 | `android/tests/`、`tools/check_android_image_package.py`、`tools/check_sequence_package.py` |

维护本文件时只更新仍适用的入口和约束。具体故障记录、性能数字、一次性路径及完整测试报告放在相应模块文档或验证文件中，不再在这里累计历史清单。
