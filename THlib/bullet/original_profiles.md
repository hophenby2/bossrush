原作弹型属性来自原始 ANM，不从代理图样的形状推断。`original_profiles.lua` 只记录主弹精灵的宽高、随逻辑角旋转位和 Z 轴自转速度；宽高用于回收，不覆盖现有碰撞尺寸。

取证方法：用本机 thtk 的 `thdat -x` 提取资源，`thanm -l` 读取脚本与精灵。TH06/07/08 的主弹脚本起点来自各作 `BulletManager.cpp`；TH095 来自 `g_PhotoBulletScriptBases`；TH10 来自原始 `th10.exe` 地址 `0x474170` 的27项脚本起点表。TH10 的旋转位是 ANM 指令82，自转速度是指令53；TH07/08 对应指令25和13。

例子：TH08 的12/13型小星弹分别每帧正/负 `0.05235988` 弧度，14/15型大星弹为正/负 `0.03141593` 弧度；TH095/10 的17型泡弹为 `0.7853982` 弧度。显示时翻转 Y 轴，独立于控制弹道的 `rot`。飞行中 `etSprite` 换弹型会重开 ANM 自转相位；缓时灰化换色保留相位。

资源 SHA-256：

| 原作 | 文件 | SHA-256 |
|---|---|---|
| TH06 | etama3.anm | 1bbbbea06778111585c33223a9376e76299db746fbed627908d09807b114cd4c |
| TH06 | etama4.anm | edf59b5ddab4b19026938a3831185b1e16fb6ff905cfa62340ffeca471687b04 |
| TH07 | etama.anm | 4fe2cda06dfa2bab28a5a9f4e65e06257b928e663b5b37691aa5598aa8132533 |
| TH08 | etama.anm | c3d19370bcbbc2f9b320f437ab5493834c9a6cd2b7bb9f866a4ed4df1d59f3de |
| TH095 | bullet.anm | a789b1528844c7df87d8e74e64c1ff02c77f3fbfd1d14fb05b8e7088bf8d5a34 |
| TH10 | bullet.anm | 5e2f7076ba11f577849c7c1d114deeb190511d922ec6a6aa5e99e637ef60a2d9 |

回收与穿墙依据：

- TH06 `BulletManager.cpp:864..888`：按主弹尺寸检查，折向/反弹或已有出屏计数时最多连续出屏256帧。
- TH07 `BulletManager.cpp:990..1022`：先递减 `spawnDelay`，再检查积分后的坐标。折向/反弹期间累计出屏帧，128帧释放；变换结束后递减已积累的计数，重新入屏归零。`ecldata8/Sub110..113` 的第1/2条命令分别是60/180帧出屏延迟，后一条覆盖前一条。
- TH08 `BulletManager.cpp:856..900`：与TH07相同的128帧计数规则。TH095 `BulletManager.cpp:761..769,1504..1514` 按精灵全宽高作边界余量，不能套用TH07规则。
- TH10 `BulletRuntime.cpp:140..159`：先积分/穿墙，再检查边界，最后递减出屏延迟。原始全局边界位于 `0x470B40/3C/5C/38`，值分别为 `-192/192/-64/448`。`BulletManager.cpp:413..472` 的穿墙移动量为场地宽高加精灵宽高；每穿过一侧扣一次次数，耗尽后关闭变换。

验证入口：`tools/check_original_ecl_fidelity.lua` 验证原作时序、回程、穿墙和陪战清场；`tools/check_bullet_visuals.lua` 验证实际绘制角；`tools/check_th35_patterns.lua` 用真实子弹/样式和协程对点名及同类缺口的15张卡各运行7200帧，检查实际发弹与弹池容量；可用PATTERN_LONG_CARDS筛选。

妖妖梦补充核对（2026-10-31）：

- `ecldata4/Sub121`的首张骚符还同时运行`Sub122/123→125/126`：左右陪战在原作(96,96)/(288,96)，首轮六只幽灵在墙钟354帧生成，之后间隔60/60/60/100帧。
- `ecldata8/Sub101`与`ecldata7/Sub98`都有slot1、flag1、200帧的0x2000。只恢复公共128帧宽限而漏这条命令，仍会提前回收。幽曲、墨染、反魂蝶、人形、键灵等缺失记录也按原槽位补回；ExIns6的分裂延迟为130帧，末级没有延迟，不能统一套用母弹999帧。
- `BulletManager.cpp:1068..1094`的出生阶段不运行命令或离屏检查，也不递减spawnDelay。出场先退velocity×4，再按2/2.5/3的除数运动，最后一帧落入NORMAL。ANM时长为10/16/32帧，大弹32帧，泡弹24帧。负spawnDelay按`!=0`继续递减。
- 华灵蝶妄想的`ecldata6/Sub53`使用`stg6enm/script12`、`SET_TRAIL(25,48,16,1)`：48帧带状拖尾、宽32、隐藏头部；这不是BulletManager里的直线激光。`EnemyManager.cpp:758..773`在头部及历史1/7/13帧节点检查8×8接触框，框除以1.5后再取半宽；`1221..1351`负责原作纹理带。ex16/17/18只处理仍激活的蝶弹，已回收弹的最后坐标不能继续生成弹源。
- 动静均衡`Sub94`、梦现`Sub91/92`、弹幕结界`Sub130..134`、式神驻点`Sub116`使用ANM31。EX同型驻点`Sub112`的精灵像素与PH一致。保留法阵到原生敌机脚本结束；驻点法阵持续120帧。
- 两套段式激光共用`mod/GAME/th34_visual.lua`：flags1按原作全宽淡入/收束；startTime/endTime为0时走原始分支；startOffset≥640释放。原生生命周期结束时直接删除，不能再继承THlib额外30帧的del收束。消弹仍保留原生类并从当前宽度进入原作endTime。
- `Resources/System/th34_native.png`仅裁切原始精灵：etama/script10/11的两种激光及源点光球、stg6enm/sprite42的曲线带、stg8enm/sprite64的法阵。未缩放原像素。取自本机th07.dat，用thdat提取、thanm解出PNG；下面给出原ANM的SHA-256。

- stg6enm.anm：`d1224e65d644fc95cd7e3e3e2e068e97e6d0fdffa9974b3a98940d427f4ba40b`
- stg7enm.anm：`c85745c03d10080137e967b68650b7d9c170403772232be276c7dabd8d3416d7`
- stg8enm.anm：`9a5242bd1823008df620c3c5a6446b54d2787b0ea461da0ee0c777b6bebfa69c`
