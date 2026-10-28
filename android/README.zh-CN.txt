Boss Rush HD Android 内部测试版
============================

安装包：dist/BossRushHD-android-arm64-debug.apk
校验值：同名 .sha256 文件
系统：Android 9（API 28）及以上，ARM64，OpenGL ES 3.0 及以上。
应用标识：org.bossrush.hd。当前使用本地测试密钥签名，可侧载安装。
连接设备后可用：adb install -r android/dist/BossRushHD-android-arm64-debug.apk

本目录是完整的 Android 构建入口。引擎固定为 LuaSTG-x 20260913 发布源码，
下载地址、SHA-256、NDK 版本见 engine.lock.json，不跟随 master。
移植层独立于桌面启动器；游戏本体继续使用现有 33 关、AEX、脚本和高清素材。

操作
----
菜单：触摸选择，拖动列表，右下角“确定”“返回”。
游戏：左下方向区域，右侧射击、低速、符卡、特殊，右上暂停。
移动和动作分别按触点编号保存，可以同时移动、射击、低速。
Android 返回键映射为 ESC；切后台或失去音频焦点时暂停。
首次运行使用游戏原有屏幕键盘输入标签，选择键盘右下“终”完成。

0.3.0 多存档与同步
-----------------
标题菜单“存档 / 同步”、右上同名按钮或 F10 可打开管理界面。
支持多存档切换、复制、重命名、选择性导入、冲突副本及替换前备份。
PC 与 Android 可通过 BRS1 口令、文件、分片二维码或同网 / 热点配对进行双向传输。
旧存档自动复制到首槽，原文件保留；完整操作与格式说明见 THlib/save/README.zh-CN.txt。
本轮验证记录以 dist/save-sync-test/ 为准；下文 0.2.0 渲染与性能数据保留作历史参考。
可用 --game-root /absolute/source/snapshot 从独立源码快照打包，隔离并行改动。

0.3.1 关内续玩（内部测试，不更新 Release）
----------------------------------------
约每 120 个逻辑帧自动保存，暂停、切后台和退出时补存；上方 F5 按钮可手动保存。
强制杀进程后，在标题选择“恢复关内续玩”，重建结束后停在暂停画面。
精确续玩要求同脚本、同引擎平台与架构；PC / Android 间可同步成长和关卡检查点，
精确关内记录跨平台会保留但拒绝直接重建。升级脚本也会保留记录并提示用关卡检查点。
原理、交换包兼容范围、失败保护和完整限制见 THlib/save/README.zh-CN.txt。
本轮验证文件位于 dist/resume-test/，玩家数据使用独立测试槽。

0.4.0 简易 Roguelike：随机十战
----------------------------
主菜单“随机十战”选角色后开始；每局十张不重复的符卡 / 非符，来自 TH31 / TH34 / TH35。
来源等概率选择，累计十次失误结束；原卡参数与收卡判定保留。不加入天气、商店或道具构筑。
支持既有 F5 / 触屏保存、强杀续玩和录像；详细规则见 mod/roguelike.txt。
本轮测试在 dist/roguelike-test/，使用独立模拟器测试槽；不更新 Release。

0.5.0 双Boss随机十战
-------------------
主菜单新增“双Boss随机十战”，每步同时两名 Boss，十步共二十张不同卡，允许同角色。
出场与开卡初始化 X 分别 +96 / -96，Y 不变；后续移动依原卡执行。
双方都结束后推进；弹池、子机和清场按实例隔离。双模式成绩单独记录。
规则见 mod/roguelike.txt，验证记录位于 dist/dual-rogue-test/。
本次同时提供 Windows x64 完整包（含引擎、脚本、音乐和素材），并发布 0.5.0 测试版 Release。

0.6.0 定位、子弹朝向与答题复活
------------------------------
双 Boss 的第一次指定位置移动也应用 X±96，覆盖 before 插值、延迟任务与 ECL 载体，Y 不变。
子弹按实际位移绘制朝向，中途换型保留策略；星弹、音符与显式自转沿用原表现。
失败前可答题复活，每局最多成功三次；先沿用原 Special 符卡的八道数学题。
移动选择答案区，射击确认、符卡键放弃；500 帧后自动按所在区判题。
答题期间战斗冻结，答对后原场续战并无敌三秒；累计失误不减少，复活状态支持关内续玩。
详细规则见 mod/roguelike.txt；验证记录在 dist/revive-test/。

0.7.0 全局 Rank
--------------
Rank 初始 50，范围 0–100；每秒自然 +0.05，收卡 +3，中弹 -8。
全局敌弹速度与 Boss 开卡 HP 按 90%–110% 小幅调整，基准为当前卡片定义的 HP。
右侧显示 Rank 与倍率；暂停和答题期间冻结，切关与复活继承，存档/录像/检查点保留。
HP 在开卡时决定，Rank 变化不会让正在打的 Boss 突然回血；详细规则见 THlib/rank.txt。

构建（本机 macOS ARM64 已验证）
----------------------------
需要 Python 3.11+、JDK 17、CMake、Ninja、Android SDK 和 NDK 26.3.11579264。
SDK 默认位置：~/Library/Android/sdk，可用 ANDROID_HOME 覆盖。
NDK 默认位置：SDK/ndk/26.3.11579264，可用 ANDROID_NDK_HOME 覆盖。

  export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
  python3 android/build.py

首次构建下载并校验上游源码到 .cache/。也可指定已经下载的发布压缩包：

  python3 android/build.py --engine-archive /absolute/path/LuaSTG-x_release_20260913.zip

只改 Lua、图片、音乐或 shader 时可以更新资源后重新签名：

  python3 android/build.py --update-assets

修改 Java、Manifest 后使用 --package-only；修改 C++ 或补丁后使用完整构建。
生成的 unsigned.apk 只供构建复用；安装时使用 dist/ 中通过签名校验的 APK。

验证
----
在游戏根目录运行：

  luajit android/check.lua
  python3 android/verify_apk.py
  luajit tools/check_stage.lua --all

check.lua 检查只读资源、大小写路径、二进制流、懒加载、触点释放、快速点击和滚动。
游戏启动时还会执行真实引擎契约检查：对象分组、位置、运动、边界、超级暂停、
nopause、对象回收以及 Lua 构造错误的安全传播。通过记录在私有 lstg_log.txt。
verify_apk.py 检查 CRC、SHA-256、全部游戏资源、ARM64 ELF 和 WAV 原始样本。
WAV 只重写容器头，去除上游解码器无法跳过的 JUNK/LIST 元数据，PCM 数据保持一致。

原游戏静态自检基线：281 个 Boss、824 张符卡，15 处既存卡号重复
（453–460、470–476）。该基线的详细输出保存在 dist/stage-check.log。
这些属于原关卡注册数据，Android 适配不重新分配卡号。

主要适配文件
------------
patch_engine.py / native/：GFX 与 GLSurfaceView 共用 EGL、对象属性、超级暂停、
  世界标志、动画缩放、平铺采样器、深度缓冲、HGE 字体码点、Lua 错误展开。
lua/platform.lua：APK 只读 VFS、资源清单、大小写纠正、私有存档及录像。
lua/compat.lua：Sub API 重载、资源类型、类注册、音频播放速率、后处理及曲线光。
lua/lazy_textures.lua：Boss 背景与行走图按首次使用加载，切关释放背景纹理。
lua/input.lua：多点触控、菜单点击/拖动、虚拟键与键盘兼容。
shaders/：六个后处理的 GLES 实现；打包时生成 GFX 所需的位置和 uniform 块。

资源与数据
----------
APK 为完整离线包，包含音乐和高清素材，体积约 390 MiB。
应用不请求外部存储权限。新存档位于应用内部 files/bossrush/User，
录像位于 files/bossrush/replay。卸载应用会清除这些私有数据。
测试密钥位于 .cache/debug.keystore，不纳入版本控制。
上游与依赖许可证、固定源码地址一并打入 assets/licenses/。

测试范围与后续验收
----------------
已在 Android 16 / API 36.1 ARM64 模拟器验证启动、首次输入、主菜单、玩家选择、
TH06 进入与持续运行、方向移动、射击、暂停模糊、返回键及切后台恢复；
原生契约测试和脚本输入测试通过。
完整 33 关、AEX、BadApple、长时间录像以及 Android 9/12/14/15 真机仍需逐项回归。
GFX 后端共享 GLSurfaceView 的 GLES 上下文；极端系统回收导致的上下文丢失仍需真机测试。
自编译库按 16KB 对齐；NDK r26 的 libc++_shared.so 仍为 4KB 对齐，16KB 页面设备未验收。
当前是内部侧载测试包，未制作商店 AAB、Play 资源分发包或正式发行签名。

Mac GPU 模拟器与 0.2.0 优化（2026-10-26）
-------------------------------------
0.2.0 将光栅 shader 改为 GLES 3.0，修复 Mac GPU 模式黑屏；目前可以使用硬件加速：

  ~/Library/Android/sdk/emulator/emulator -avd Medium_Phone_API_36.1 \
    -no-snapshot -gpu host -skin 1080x2400 -dpi-device 420 \
    -cores 4 -memory 4096 -no-audio

背景修复包括：sampler 修改后实际更新 GPU 采样器、允许 NPOT 纹理循环平铺、
WorldToScreen 加入宽屏留边偏移、离屏目标出栈后恢复 Sub 所需的当前视口/投影，
以及后处理回调捕获调用时的视口。109 个 GPU 像素检查覆盖平铺、RT 范围和 3D 切换。
普通 TTF 直接使用字库四边形合批，保留字体效果的兼容路径；UBO 字段修改在 CPU 合并，
绑定时提交。暂停场景与模糊只捕获一次，恢复、切关、失去焦点后使缓存失效。
主菜单的 1200×540 同环境采样从约 21–23 FPS 提升到 59–60 FPS。
密集弹幕的帧率仍随关卡和机器负载变化，完整结果和限制见 dist/optimization-test/。

触控现同时支持左下固定摇杆和战斗区相对拖拽。按下拖拽不会使自机跳到手指位置；
角色按原来的高速/低速移动到相对目标，松手立即停止，不绕过原版碰撞或录像输入。
先按下的移动触点持有控制权，其他手指可射击、低速、符卡与特殊，不互相抢占。

开发诊断（仅通过 run-as 写应用私有 files/bossrush/User/android-diagnostics）
  profile：输出文字调用耗时；graphics：进入确定性图像检查画面；
  input：记录真实拖拽起止坐标，并开启测试保护，避免死亡打断测试轨迹。
正式操作前移除该诊断文件并重启应用。本轮交付时已关闭诊断。

  luajit android/check.lua
  python3 android/tests/check_graphics.py /absolute/path/to/graphics-check.png

像素检查脚本需要 Pillow。原始 Mac SwiftShader 测试保存在 dist/mac-emulator-test/，
其黑屏与性能记录为 0.1.0 历史结果；当前包和报告以 dist/optimization-test/ 为准。

0.8.0 双人合作
F9 或顶部“联机合作”建房/加入；双方有独立自机，支持同角色。
局域网/热点或公网 IPv4 TCP 直连；也可部署 tools/relay/server.cjs 并填写中继地址。
对方自机与子弹显示为原透明度的 65%；分数、Rank、失误和复活次数共享。
断线暂停，原口令与原自机可重连；合作统计独立，不覆盖单人关内点和金币。
详见 THlib/net/联机说明.txt。

0.9.0 阶段二选一道具
击破符卡 / 非符阶段后，两个选项最多 60 逻辑帧从顶部落到底部。
接触即选，左右选边、上移提前接取；选择期间短暂冻结战斗。
红字按 火力/100 放大伤害；蓝字按 射速/100 改变射击频率。初始均为 100。
右侧明确显示；联机两位玩家独立成长，选择状态与射击时钟支持关内保存和恢复。
规则：THlib/drops.txt；测试：python3 tools/drop-tests/run.py --windows-pc。
