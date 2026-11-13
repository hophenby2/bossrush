# 春雪篇、雪莲华和永夜篇的原作自机

顺序模式、关卡练习和符卡练习共享原生自机。录像初态保存机体和版本号，早期录像根据原有的项目机体播放。符卡练习沿用项目的无敌规则。

- 春雪篇 4 台。根据 `Characters.cs`、`Character.cs`、`EquipShoot.cs`、`ItemManager.cs` 接入高速/低速、主炮、子机、决死、火力与残机。掉落取自关卡脚本，Boss 扣血取自 `BossCard.DeHp`。
- 雪莲华 6 台。根据 Unity 工程的角色预制件、`Centeryidong.cs`、`Damage_zhuqiang.cs`、`Jiemian_system.cs` 接入机体、切换、蓄力、结界、碎片和决死。每帧调度两次 120 Hz 的射击计数，弹体交由 60 Hz 的 LuaSTG 碰撞流程处理。
- 永夜篇 8 台。根据 `Data/10.xna`、`EquipShoot.cs`、`Character.cs` 接入 A/B 装备、决死、库存与妹红复活。Boss 按原脚本掉落，并按 `BossCard.DeHp` 的开场时间和斜率扣血。

春雪篇的部分子机轨迹、雪莲华的激光及变身派生攻击、永夜篇的部分副武器使用近似表现。Bomb 和结界释放使用 LuaSTG 的消弹与伤害逻辑，春雪篇樱花系统、雪莲华回流、永夜篇灯笼完整状态机与原作分数体系仍待移植。机体素材用 `export_art.py` 从两作 XNA Content 和雪莲华 Assets 离线切出。

## macOS 真实引擎回归

```sh
python3 macos/build.py --update-assets
BOSSRUSH_MAC_TEST_MACHINE=youmu python3 tools/th37-tests/native.py --sequence thmhj2_lunatic --frames 350 --out /tmp/player-th37
BOSSRUSH_MAC_TEST_MACHINE=marisa_b python3 tools/th38-tests/native.py --sequence thasl_lunatic --frames 350 --out /tmp/player-th38
BOSSRUSH_MAC_TEST_MACHINE=mokou_b python3 tools/th38-tests/native.py --sequence thmhj3_lunatic --frames 350 --out /tmp/player-th39
BOSSRUSH_MAC_TEST_MACHINE=yukari python3 tools/th38-tests/native.py --card 38002 --repeat --frames 350 --out /tmp/player-practice
```

测试使用独立的临时存档。顺序模式用实际射击命中原生敌机，再通过接触碰撞触发决死、扣结界和扣命。练习检查机体资源在重开后仍可用，并对比同种子的场内状态。
