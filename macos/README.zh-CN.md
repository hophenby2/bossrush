# Mac 0.11.0 测试版

使用与 Android 相同的 LuaSTG-x 20260913 固定源码、Sub 对象 / 碰撞 / 资源兼容层和游戏脚本，在 macOS 上原生运行。渲染使用 Cocos Metal 后端。

当前产物面向 Apple Silicon（arm64）、macOS 15 及以上，使用本地临时签名。

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

后者启动真实 Metal 应用，依次检查菜单、TH35「客星」、2D / RenderTarget / 平铺 / 3D，以及逐帧拖拽与松手停止。渲染包含 30 项像素检查，测试使用临时存档，截图与日志输出至 `macos/dist/test/`。

当前 Apple M4 Max 实测菜单与基础渲染约 60 FPS；「客星」密集激光约 15–25 FPS，碰撞计算仍需继续优化。

Mac 与 Android 共用 `android/lua/main.lua`、`compat.lua`、`platform.lua` 等移植逻辑；`macos/lua/` 提供窗口、键鼠输入和私有诊断差异。Mac 精确续玩包含平台、LuaJIT 版本、入口和原生适配源码指纹。

发布构建可用 `--game-root /absolute/source/snapshot` 指定已提交的游戏内容快照，避免混入并行修改。
