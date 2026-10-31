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

验证入口：`tools/check_original_ecl_fidelity.lua` 验证原作时序、回程、穿墙和陪战清场；`tools/check_bullet_visuals.lua` 验证实际绘制角；`tools/check_th35_patterns.lua` 用真实子弹/样式和协程对点名的四张卡各运行7200帧，检查弹池容量。
