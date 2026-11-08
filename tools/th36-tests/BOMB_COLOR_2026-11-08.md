# 回归虚无炸弹颜色修正

问题不是ECL色号或加算参数填错，而是ANM子动画被当作固定底层绘制。旧`OriginalANM.draw`先递归绘制子动画，再绘制父动画；同时忽略68号指令。因此白色加算光被后画的红色半透明圆盘覆盖，中心变成粉红／暗红，多颗重叠时也逐个盖色。

原作证据：

- `stage4c01a.ecl`的`BossCard4_01ADollA`在60帧选择bullet ANM175。
- `bullet.anm`脚本175：精灵376、RGB(255,0,0)、68(12)、普通透明混合；20／24／28帧生成174号子动画。
- 脚本174：精灵375、66(1)加算、68(14)，默认白色顶点色。
- 重建工程`E:/workspace/th11/src/AnimationExecutionInstructions.inc`的68分支写`VM.persistent020`；`AnimationRendererDispatch.cpp`按该层分组；`AnimationQuad.cpp`确认模式0为SRCALPHA/INVSRCALPHA、模式1为SRCALPHA/ONE。

修正：ANM播放器保留TH11层号与创建序号；TH36为12、14层设置跨敌机的绘制通道，分别位于普通弹幕前后。所有红色本体先绘制，然后绘制普通弹幕，最后绘制白色加算辉光。保持原贴图、色号、混合参数、生成节奏、运动、判定和血量。

`check_bomb_visual.lua`检查原作层号、色彩与混合、三次子动画、单颗顺序、多颗跨敌机顺序和退出清理。真引擎11042号跑完整4290帧，截图证明白亮中心恢复；另跑TH36全部100个注册入口，覆盖其他演员的绘制与清理。结果及APK哈希见`verification-bomb-color-2026-11-08.json`。这不等于原版逐像素全量比对。

重现：

```text
luajit tools/th36-tests/check_bomb_visual.lua
python tools/th3x-tests/native_engine.py --output <新的独立目录> --games 36 --cases 11042 --frames 4290 --speed 1200
```
