# Mac 0.12.0 测试版

使用与 Android 相同的 LuaSTG-x 20260913 固定源码、Sub 对象 / 碰撞 / 资源兼容层和游戏脚本，在 macOS 上原生运行。渲染使用 Cocos Metal 后端。

当前产物面向 Apple Silicon（arm64）、macOS 15 及以上，使用本地临时签名。

0.12.0 在 TH32「猩红测试」中补齐红魔乡 Lunatic / Extra：47 个不同符卡名、帕秋莉四条机体路线、37 段非符和 14 段道中载体。道中按中 Boss 分为前后半，普通敌机可被击破；六面后半保留原作入场等待。固定 ECL rank、素材与道具代理的具体口径见 `mod/GAME/th32.lua` 文件头。

## 启动

双击 `macos/run.command` 会先刷新最新脚本和资源，再启动游戏。已打包的应用也可直接双击 `macos/dist/Boss Rush HD.app`，或在项目根目录执行：

```sh
open 'macos/dist/Boss Rush HD.app'
```

方向键移动，Z 射击 / 确认，Shift 低速，X 释放 Bomb，C 特殊，Esc 暂停 / 返回。
F8 切换触屏预览：显示 Android 按钮，用鼠标左键模拟手指，在战斗区拖拽即可测试相对移动。

## 构建与更新

需要 Xcode 命令行工具、CMake、Ninja，以及 Homebrew 的 LuaJIT、libzip、jpeg-turbo：

```sh
brew install cmake ninja luajit libzip jpeg-turbo
python3 macos/build.py
```

构建会校验并复用 Android 的固定引擎压缩包。Mac 补丁仅作用于 `macos/.cache/` 中的源码副本。

退出运行中的 Mac 版后，修改游戏 Lua、图片或音乐只需更新资源：

```sh
python3 macos/build.py --update-assets
```

应用内嵌动态库，运行时无需 Homebrew。源代码、构建缓存和 `.app` 产物分开存放。

## 测试数据

Mac 默认存档位置为：

```text
~/Library/Application Support/BossRushHD-Mac/bossrush/
```

可用环境变量 `BOSSRUSH_MAC_DATA` 指定其他数据根目录；游戏在其下创建 `bossrush/`。
源码目录的 `User/`、`replay/` 不参与打包。

## 验证

```sh
python3 macos/verify.py
python3 macos/verify.py --smoke
```

后者启动真实 Metal 应用，依次检查菜单、TH35「客星」、2D / RenderTarget / 平铺 / 3D、逐帧拖拽与松手停止、双击 Bomb、触控设置保存，以及 1920 次高频音效请求、暂停 / 恢复 / 停止和 BGM 连续播放。渲染包含 30 项像素检查，测试使用临时存档，截图与日志输出至 `macos/dist/test/`。

F8 触屏预览也支持“设置 → 触控”：双击 Bomb 最大间隔默认 0.10 秒，可调为 0.05–0.50 秒；“拖动无移速限制”默认关闭。开启后自机直接跟随相对拖拽向量，松手停止。移动选项从下一局开始生效，并记录进录像 / 续玩初态。使用 `BOSSRUSH_MAC_TEST_UNLIMITED=1 python3 macos/verify.py --smoke --mode input` 可检查无限速拖拽与双击 Bomb。

Mac 与 Android 一样只链接随包的 OpenAL Soft。旧 Mac 可执行文件同时链接系统 OpenAL，导致音效重播时主线程阻塞在系统 `alBufferData`；这些等待发生在命中回调中，之前被误计为碰撞计算耗时。构建校验现在禁止系统 OpenAL 依赖，并在真实运行中检查 AL 符号归属。

2026-10-30 在 Apple M4 Max 上，以相同脚本、种子 20261030、TH35「客星」900 个逻辑帧对照旧版与优化版：

| 指标 | 旧版 | 优化版 |
|---|---:|---:|
| 结束前 FPS | 17.3 | 59.1 |
| 测试耗时（含截图等待，不含启动） | 46.26 秒 | 15.56 秒 |
| 碰撞及其回调累计耗时 | 31.45 秒 | 0.062 秒 |
| 峰值弹幕数 | 249 | 249 |

两次运行在第 900 逻辑帧的战斗对象状态 SHA-256 均为 `306a3ceeaa7d07e3713745bef08cb8d85559bc127b44a0415f03d729aac4ba93`。该校验比较对象分组、位置、速度、角度、判定尺寸和计时器；优化未修改弹幕逻辑。这个结果针对该测试场景，不代表全部符卡的性能。

可用以下命令复测；每次运行使用独立临时存档：

```sh
python3 macos/tests/benchmark.py --app 'macos/dist/Boss Rush HD.app' --output macos/build/performance/current
```

传入 `--compare /path/to/old/result.json` 可校验两次运行的逻辑帧、弹幕峰值、对象数和状态哈希一致，并生成耗时对照。种子和帧数分别用 `--seed`、`--frames` 指定。

Mac 与 Android 共用 `android/lua/main.lua`、`compat.lua`、`platform.lua` 等移植逻辑；`macos/lua/` 提供窗口、键鼠输入和私有诊断差异。Mac 精确续玩包含平台、LuaJIT 版本、入口和原生适配源码指纹。

发布构建可用 `--game-root /absolute/source/snapshot` 指定已提交的游戏内容快照，避免混入并行修改。
