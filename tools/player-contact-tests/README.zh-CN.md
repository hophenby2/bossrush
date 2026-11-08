# 自机接触实体弹的消散

新局记录`lstg.var.__contact_cancel_version=1`，普通开局与练习开局均在保存初态之前设置。致死弹在死亡分支返回前转入消散；保护期、复活后已可操作的阶段和练习无敌期间，实际接触自机的实体弹同样消散。

旧问题有三处：死亡分支提前返回，没有执行后面的消弹；保护期仅处理1号弹幕组，遗漏12号及不可被Bomb消除的实体弹；外层只接受`death==0`，复活后`death=1..49`虽然已可操作仍无法消弹。

原作依据为重建工程`E:/workspace/th06/src/Player.cpp`的`Player::CheckCollision`与`BulletManager.cpp`的FIRED分支，以及`E:/workspace/th08/src/Player.cpp`的`Player::CheckBulletCollision`和`BulletManager.cpp`的`lethalCollision`分支。实体命中返回1，造成死亡或处于非ALIVE状态时均会将弹转为DESPAWNING。永夜抄的Bomb免疫仅拦截返回2的Bomb碰撞，不拦截实体接触。因此接触消弹直接走`object.Del`，绕过`OriginalBulletVisual.can_cancel`，保留弹本身的消散动画，不产生消弹掉落。

覆盖1／12号敌弹组，以及5号组中带`imgclass`的实体弹；5号组的使魔／结构和敌机体术不按子弹消除。激光与曲线光不走实体弹消散，继续使用原有激光规则。只以实际受弹判定为入口，擦弹不会扩大为消弹范围。死亡演出、对白和灵魂出窍阶段保持原有无交互规则。

旧录像和旧续玩初态未带此字段时，继续使用原行为；新录像会记录该字段。未改写玩家的`User/`或`replay/`。

验证：

- `tools/drop-tests/unit.lua`覆盖致死、无敌、复活、练习无敌、弹幕分组、敌机／结构／激光排除及旧版本回归。
- `python tools/player-contact-tests/native.py --output <新的独立目录>`在真实LuaSTG Sub中创建红／妖／永／文／风／地六作实体弹，调用实际`CollisionCheck`；6作×3组×3状态共54例，检查立即关闭判定、原作消散状态和120帧后回收，并检查擦弹、敌机体术及旧版本行为。
- 原有随机十战2550项回归通过。APK版本与校验见`verification-2026-11-08.json`。

测试宿主只在隔离目录中创建存档、录像与日志，不代替Android设备实测。
