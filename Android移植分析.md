# Boss Rush HD Android 移植分析

> 结论先行：当前项目没有一个可以直接替换的 Android 版 LuaSTG Sub。游戏实际运行基线是 **LuaSTG Sub 0.21.2**，本地源码目录是 0.21.129，两者不能混用。短期验证优先使用 `LuaSTGPlusAndroid`，长期产品化优先评估 `LuaSTG-x 20260913`，若必须保留 Sub 语义则只能基于 `LuaSTG-Evo` 自建 Android 后端。

## 1. 结论

1. `Boss Rush HD/engine.log:1` 显示发行目录实际运行的是 `LuaSTG Sub v0.21.2`，LuaJIT 2.1.0-beta3；`LuaSTG-Sub/version.json` 则是 `0.21.129`。移植前必须先固定兼容基线。
2. 不存在官方或现成的 Android 版 Sub 0.21.2。`LuaSTG-Sub` 的构建目标是 Windows + D3D11 + XAudio2，`LuaSTGSub.exe` 不能直接打包成 APK。
3. 目前唯一专门的 Android 工程是 `LuaSTGPlusAndroid`，但它停留在 2023-08-21，并且构建时禁用了 LuaJIT FFI。
4. `LuaSTG-x` 的 Android 基础设施更完整，适合长期产品化，但 shader、输入、文件枚举和部分 THlib 语义需要重写或加兼容层。
5. `LuaSTG-Evo` 与 Sub 语义最接近，但没有 Android 工程，也没有 GLES 后端；选择它意味着要自行补 Android 图形/窗口/文件/触屏后端。

**不建议**

- 直接把 `LuaSTG Sub 0.21.2` 或 `0.21.129` 当作 Android 版本使用。
- 直接打包 Windows 的 `LuaSTGSub.exe`。
- 只把触摸事件映射成鼠标左键，不做虚拟摇杆、多点触控和菜单滑动。
- 无脑跟 `LuaSTG-x` master；它仍会有破坏性 Lua API 改动。
- 通过打开 9chu 的 FFI 来解决 `kernel32` 依赖；Windows API 本身不可移植。

## 2. 版本选择

| 方案 | 固定版本 | Android 现状 | 优点 | 主要缺口 | 适用场景 |
|---|---|---|---|---|---|
| `LuaSTGPlusAndroid` | 2023-08-21，9chu `49daeed` | minSdk 28、compile/target 33、GLES 3.0、asset/local 双文件系统 | 入口和 API 最接近当前 `launch`/`core.lua`/`GameInit`；有 Android asset VFS | FFI 被禁用、Sub 专有 API 缺口多、无触屏 UI、工程维护停滞 | 技术验证、短期移植 |
| `LuaSTG-x` | release `20260913` | minSdk 21、target 33、GLES 3.0、自带触屏/虚拟摇杆 | 维护活跃、移动基础设施完整、音频和文件系统跨平台 | `LoadFX` 是 GLSL、`PostEffect` 签名不同、没有 Sub 音频变速/FileManager API | 长期产品化 |
| `LuaSTG-Evo` | v0.3.1 / master | 无 Android 工程、无 GLES 后端；桌面 OpenGL 4.1 + SDL2 + miniaudio | 最保 Sub 语义，已有 SDL2 和 miniaudio | 需要自建 Android 窗口、GLES、asset、触屏和生命周期 | 有 C++ 引擎能力的长期路线 |
| `LuaSTG Sub` | 0.21.2 / 0.21.129 | 无 Android，D3D11 + XAudio2 + Win32 | 原版行为 | 不能直接使用 | 仅作为兼容基线 |

注意：`LuaSTG-x` 的 master 在 2026-10 仍有 `fix(lua)!` 破坏性改动，必须固定 release `20260913` 或对应 commit。

### 2.1 推荐路线

1. **先做 1–2 周 spike**：用 `LuaSTGPlusAndroid` 编出 APK，替换 Windows 启动层和 FFI，跑通一个无 shader、无 3D 的单 stage。
2. **如果目标是尽快发布这个游戏**：继续在 `LuaSTGPlusAndroid` / 9chu 线上补 API、文件系统和触屏，尽量保留 33 关脚本。
3. **如果目标是长期多平台维护**：迁到 `LuaSTG-x 20260913`，接受 shader 和 THlib 平台层的较大改造。
4. **如果必须保留 Sub 全部语义且团队有引擎能力**：以 `LuaSTG-Evo` 为基础补 Android GLES 后端。

## 3. 必须改动

### 3.1 启动与平台层

- [ ] `Boss Rush HD/launch:1` 把 `package.cpath` 指向 `.dll`，`:5` 调用 `LoadPackSub`；Android 上必须替换成新的启动脚本或 zip/asset 加载。
- [ ] `Boss Rush HD/launch.lua:11` 的 `ShowSplashWindow`、`:240` 的 `User\setting`、`:284` 的窗口/分辨率/垂直同步/音量设置，需要映射成 Android 全屏、固定横屏、无窗口模式。
- [ ] 启动器是 480×640 竖屏（`launch.lua:277`），游戏是 640×480 横屏（`launch.lua:149`）。Android 上要么允许启动器竖屏再切横屏，要么重做启动器布局。
- [ ] `MessageBox`、`EnumGPUs`、`EnumResolutions`、`ChangeVideoMode` 在 Android 上没有直接对应，先做对话框/Toast 或隐藏对应设置。
- [ ] 处理 Android 生命周期：`onPause`/`onResume`、返回键、后台暂停、音频焦点、屏幕常亮、沉浸式全屏。

### 3.2 文件系统与资源

- [ ] `THlib/plus/NativeAPI.lua:1` 直接 `require "ffi"`，`:4` 使用 `ffi.load("kernel32")`，`:388` 用 `FindFirstFileW` 枚举文件。这是第一个硬崩溃点，必须改成纯 Lua VFS、`lfs` 或引擎文件接口。
- [ ] `THlib/UI/loading.lua:2` 和 `THlib/lib/Lresources.lua:282` 依赖 `lstg.FileManager`；`THlib/se/se.lua:8`、`:66` 依赖 `FindFiles`。APK assets 只读且不能直接枚举，需要补 asset 枚举绑定，或在打包时生成 asset 清单。
- [ ] `THlib/lib/Lscoredata.lua:104`、`THlib/plus/Replay.lua:307`、`launch.lua:240` 都把 `User\...` 当可写目录。Android 上要改到 app-private files 目录。
- [ ] `mod/BadApple.lua:48`、`THlib/UI/menus/manual.lua:5`、`THlib/UI/title.lua:183` 使用 `io.lines`/`io.open` 读 assets，需要 VFS 包装或预加载。
- [ ] 静态扫描到约 188 处带反斜杠的字符串路径。Android assets 区分大小写，需要统一把 `\` 转 `/`，并逐个核对文件名大小写。
- [ ] `.dat` 资源包逻辑（`launch:5`）要么继续使用散装 assets，要么改 zip/asset pack；`ExtractRes` 的异常恢复路径也要有 Android 版本。

### 3.3 输入与 UI

- [ ] `THlib/lib/Linput.lua:14` 把输入归并成 8 个逻辑键：`up/down/left/right/slow/shoot/spell/special`。建议保留这 8 个键，用虚拟摇杆 + 4 个按钮 + 暂停/返回键向引擎注入按键事件。
- [ ] `launcher.lua:58` 和 `THlib/ext/ext_mouse.lua` 大量使用键盘、鼠标左/中/右键。触摸至少要模拟鼠标位置和左键；菜单还要支持拖动/滑动。
- [ ] 返回手势映射到 ESC 或右键取消；暂停键要独立于系统返回键。
- [ ] 不要只做“触摸=鼠标左键”。弹幕游戏需要同时移动 + 射击 + 低速，必须支持多点触控。
- [ ] 处理刘海/挖孔/安全区、横屏比例、系统手势区域，避免按钮被系统手势挡住。

### 3.4 渲染、Shader 与 3D

- [ ] `shader/` 目录有 8 个 HLSL，实际被 `LoadFX` 加载的是 6 个：`alpha`、`screen_save`、`color_set`、`gray`、`gaussian_blur`、`texture_BoxBlur49`。`thl_distortion.hlsl`、`world_rotate.hlsl` 目前未被引用，可以后置。
- [ ] Sub 后处理绑定名是 `screen_texture`、`screen_texture_size`、`viewport`；9chu/Diligent 路线使用 `MainTexture`，`LuaSTG-x` 是 GLSL 的 `u_texture`、`SCREENSIZE` 等。这 6 个 shader 都要改绑定名和语法。
- [ ] 游戏使用 Sub 旧式 `PostEffect(fx, rt, sampler, blend, cbdata, tdata)` 调用，例如 `THlib/ext/ext_other.lua:148`、`THlib/ext/ext_pause_menu.lua:271`、`mod/GAME/th16.lua:1788`。`LuaSTG-x` 是 `PostEffect(rt, fx, blend, param)`，需要兼容层或改调用点。
- [ ] 3D 背景不是模型渲染，而是 `Set3D` + `SetPerspective`/`SetOrtho` + `Render4V` 的伪 3D。静态扫描约 302 处 `Set3D`、49 处 `Move3D`、145 处 `Render4V`。
- [ ] `LuaSTG-x` 已有 `Set3D`、`SetPerspective`、`SetOrtho`、`Render4V`；`LuaSTGPlusAndroid` 的 9chu 层也有这些接口。3D 不是最大难题，但必须逐关回归投影、视口和雾效。
- [ ] 真正的 3D 风险是深度：游戏使用 `SetZBufferEnable`/`ClearZBuffer`（例如 `mod/BG/TH08/TH08_bg.lua:179`），9chu 有 depth stencil 但没有暴露 Lua API；`LuaSTG-x` 有 `SetDepth`，仍需映射。
- [ ] `THlib/lib/Lresources.lua:191` 的 `SetTextureSamplerState(tex, "linear+wrap")` 在 9chu/x 里没有直接对应。背景平铺依赖 wrap，不能简单丢掉。
- [ ] 字体需要验证 `LoadFont`/`LoadTTF`/`RenderTTF` 的中文度量、DPI 缩放和缓存；`CacheTTFString` 只导出未实际使用，可以先空实现。
- [ ] `LoadModel`/`RenderModel`/`MeshData`/`RenderMesh` 只在 `THlib/lib/Lapi.lua` 导出，业务代码没有实际调用，可先空实现。

### 3.5 音频

- [ ] XAudio2 要换成 SDL2 audio、OpenAL、AAudio 或 miniaudio。`LuaSTG-x` 和 `LuaSTG-Evo` 已有多平台音频层，`LuaSTGPlusAndroid` 走 9chu 的音频实现。
- [ ] `LoadMusic(name, path, loop_end, loop_duration)` 要保留 OGG 循环点；游戏约 42 处 `PlayMusic`、1247 处 `PlaySound`，必须测循环、延迟和同时发声数。
- [ ] `THlib/ext/ext_other.lua:469`、`:488` 使用 `SetBGMSpeed`/`GetBGMSpeed` 做 BGM 变速。9chu 和 x 都没有这些 Sub 专有接口，必须实现播放速率，或先固定为 1.0 并确认不影响流程。
- [ ] `SetBGMLoop`、`GetBGMVolume`、`GetMusicFFT`、`SetSESpeed`、`GetSESpeed`、`GetSEVolume` 大多只在 `THlib/lib/Lapi.lua:155` 起导出，业务使用很少；可以分优先级实现或空实现。
- [ ] Android 上处理音频焦点：切后台暂停、来电/通知 duck、返回前台恢复。

### 3.6 资源体积与性能

- [ ] 项目总量约 806 MB：`music` 225 MB、`Resources` 69 MB、`THlib` 48 MB、`mod` 49 MB、`BadApple` 21 MB。
- [ ] 614 张 PNG，按 RGBA 解码约 462 MiB；启动时 `THlib/UI/loading.lua:14` 会把 `Resources/BossBackGround`、`BossImage`、`Special` 全部加载，三处解码后约 265 MiB，再加 THlib 和关卡资源，峰值容易超过 300 MiB。
- [ ] 建议把 Boss 图和 Special 图改成按 stage 懒加载，离开 stage 后卸载。
- [ ] 大背景使用 ASTC/ETC2 压缩或降分辨率；弹幕小图保持无损/图集，避免文字和判定点变糊。
- [ ] 音乐保持流式播放，不要启动时全部解码。
- [ ] 限制 render target 数量、粒子和同时发声数，先在中端机上锁 60 FPS 做基线。
- [ ] 806 MB 不适合直接塞进 Google Play 基础包，应使用 AAB + Play Asset Delivery/OBB，或拆分“基础包 + 音乐包 + 高清背景包”。
- [ ] 若提升 targetSdk 到 35+，还要检查 NDK 库的 16 KB page size 对齐。

## 4. 关键缺口与优先级

| 优先级 | 缺口 | 影响 | 处理方式 |
|---|---|---|---|
| P0 | `THlib/plus/NativeAPI.lua` 的 FFI/kernel32 | 启动直接失败 | 改纯 Lua VFS / `lfs` / 引擎文件接口 |
| P0 | `SetTextureSamplerState` | `LoadTexture2` 可能直接报错；背景平铺错误 | 补绑定或确认默认 sampler |
| P0 | `RenderAnimation` / `SetAnimationScale` | 弹幕和特效动画无法绘制或缩放 | 补 C++ 绑定，或改少量调用点 |
| P0 | `SetZBufferEnable` / `ClearZBuffer` | 3D 背景遮挡错误 | 补深度状态绑定 |
| P1 | `SetBGMSpeed` / `GetBGMSpeed` | BGM 变速失效 | 实现播放速率或固定 1.0 |
| P1 | `lstg.FileManager` / `FindFiles` / `plus.EnumFiles` | 资源扫描、SE 加载、录像列表失败 | asset 清单或 VFS 枚举 |
| P1 | `PostEffect` / `LoadFX` 签名和 shader 格式 | 后处理失效 | 兼容层 + GLSL ES/HLSL 适配 |
| P1 | 鼠标菜单 / 触屏 UI | 菜单不可操作 | 触摸→鼠标 + 虚拟按键 + 滑动 |
| P2 | `SaveTexture` | 菜单背景截图失败 | 实现或降级为空实现 |
| P2 | `GetResourceStatus` / `SetResLoadInfo` | 资源池切换/卸载异常 | 兼容状态表或空实现 |
| P2 | `MessageBox` / `EnumGPUs` / `EnumResolutions` | 错误提示和视频设置异常 | Android 对话框/隐藏设置项 |
| P2 | `LoadModel` / `RenderModel` / `MeshData` / `RenderMesh` | 目前业务未使用 | 先空实现 |

## 5. 验证计划

1. **空 Android shell**：能启动、能加载 `launch`/`core.lua`、能打印日志。
2. **资源与字体**：能枚举 assets、加载 PNG/OGG/WAV、渲染中文。
3. **单 stage、无 shader、无 3D**：跑通移动、射击、碰撞、暂停。
4. **单 stage + 后处理**：验证 6 个 shader、render target 和截图。
5. **3D 背景 + Z-buffer + BGM 循环 + replay**：重点测 `Set3D`/`Render4V`/`SetZBufferEnable`。
6. **全 33 关 + 启动器 + 存档/成就 + `th16AEX` + `BadApple`**。
7. **设备矩阵**：Android 9/12/14/15、低/中/高端、刘海屏、平板、外接手柄。

静态检查仍按项目约定跑 `luajit tools/check_stage.lua --all`，但它只能保证 Lua 脚本不回归，不能替代 Android 上的引擎/渲染/音频实测。

**建议记录的验收指标**

- 冷启动时间、首次进入关卡时间。
- 各阶段峰值内存和纹理显存。
- 中端机平均 FPS、1% low、卡顿次数。
- 音频延迟、循环点误差、同时发声数。
- 崩溃率、ANR、切后台恢复成功率。
- 触摸操作覆盖率：移动、射击、低速、符卡、暂停、返回、菜单滑动。

## 6. 风险清单

- **引擎维护风险**：`LuaSTGPlusAndroid` 只有 2023 年的单 commit，后续需要自己维护 Gradle/NDK/LuaJIT/9chu 代码。
- **API 兼容风险**：Sub 0.21.2 与 9chu v2、LuaSTG-x 的对象模型、资源池、动画、音频接口并不完全一致。
- **Shader 风险**：HLSL 到 GLSL ES 的转换不只是语法，还包括纹理绑定、uniform 布局、采样器状态和颜色空间。
- **3D 风险**：投影/视口/深度状态在不同后端上容易产生细微差异，需要逐关回归。
- **触屏风险**：菜单和录像回放对输入时序敏感，触摸映射可能改变操作手感。
- **内存风险**：启动即加载约 265 MiB 解码纹理，低端机容易 OOM。
- **包体风险**：806 MB 资源需要拆分和分发策略，不能按桌面目录直接打包。
- **音频风险**：BGM 变速、循环点、音频焦点和低延迟在 Android 上需要单独验证。

## 7. 关键证据

- 实际引擎版本：`Boss Rush HD/engine.log:1`
- 本地源码版本：`LuaSTG-Sub/version.json`
- Windows 启动层：`Boss Rush HD/launch:1`、`Boss Rush HD/launch:5`
- 设置与窗口：`Boss Rush HD/launch.lua:240`、`Boss Rush HD/launch.lua:284`
- 启动器/游戏分辨率：`Boss Rush HD/launch.lua:277`、`Boss Rush HD/launch.lua:149`
- FFI 与文件枚举：`Boss Rush HD/THlib/plus/NativeAPI.lua:1`、`Boss Rush HD/THlib/plus/NativeAPI.lua:388`
- 资源枚举：`Boss Rush HD/THlib/UI/loading.lua:2`、`Boss Rush HD/THlib/lib/Lresources.lua:282`、`Boss Rush HD/THlib/se/se.lua:8`
- 输入映射：`Boss Rush HD/THlib/lib/Linput.lua:14`、`Boss Rush HD/launcher.lua:58`
- 3D 视图：`Boss Rush HD/THlib/lib/Lscreen.lua:247`、`Boss Rush HD/THlib/lib/Lscreen.lua:281`
- 后处理：`Boss Rush HD/THlib/ext/ext_other.lua:148`、`Boss Rush HD/THlib/ext/ext_pause_menu.lua:9`
- 采样器状态：`Boss Rush HD/THlib/lib/Lresources.lua:191`
- 音频变速：`Boss Rush HD/THlib/ext/ext_other.lua:469`
- 存档路径：`Boss Rush HD/THlib/lib/Lscoredata.lua:104`
- 录像路径：`Boss Rush HD/THlib/plus/Replay.lua:307`
- BadApple 文件读取：`Boss Rush HD/mod/BadApple.lua:48`

## 8. 一句话总结

这不是“换一个 LuaSTG 版本就能跑”的移植，而是“选一个 Android 底座 + 补平台兼容层 + 重做触屏/文件/音频/Shader + 重新验证 33 关”的工程。短期用 `LuaSTGPlusAndroid` 验证可行性，长期产品化评估 `LuaSTG-x 20260913`，必须保留 Sub 语义则走 `LuaSTG-Evo` 自建 Android 后端。
