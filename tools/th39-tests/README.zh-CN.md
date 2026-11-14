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

## 差异

- 原版背景贴图按关卡及符卡变体分层重组，BGM 使用原版曲目与循环点。Boss 和敌机图来自原版，Boss 当前使用待机动画。对白、过场、灯笼系统、护送演出、五面队友替身与完整音效库尚未移植。
- 石化使用方向键解除，定身和强制移动使用项目自机锁定。原作灯笼联动、部分立体遮罩、扫掠判定、物理体积和激光贴图仍有差异。个别大型视觉对象仅使用弹图和基础判定。
- 使用原脚本的主要开场和攻击时限。EX、PH 的使魔连续战斗可按使魔击破切换，练习保留脚本时限作为退出条件。

## 验证

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
