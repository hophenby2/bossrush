# TH33–TH35 子弹贴图映射方案

目标：按原作 ANM 的主弹精灵，把移植版使用的占位弹型换成本项目里形状、颜色
最接近的原生弹样式。本文只描述视觉映射；弹道、发数、速度、变换程序和判定口径
不在这次替换范围内。

依据：

- TH095：`/Users/happyelements/th095/src/BulletManager.cpp`
  （`g_PhotoBulletScriptBases`、`g_PhotoBulletCollisionSizes`、颜色表）
- TH07：`/Users/happyelements/th07/src/th07/BulletManager.cpp`
  （`g_BulletTypeInfos`、主弹 `spriteOffset`）
- TH10：`th10.exe` 的 `g_BulletSpriteScriptBase`，以及
  `th10/src/BulletManager.cpp`、`th10/src/BulletTransform.cpp`
- 原作 ANM 解包：`/tmp/bulletmap/{th07,th10,th095}/list.txt`
- 本项目可选样式：`THlib/bullet/bulletStyle.lua`

## 1. 本项目样式

映射优先看轮廓，其次看尺寸；尺寸接近时优先使用不带动画的单帧样式。

| 原生样式 | 用途 |
| --- | --- |
| `ball_small` | 8×8/16×16 小圆粒 |
| `ball_mid_c` | 白心 + 粗色环圆弹 |
| `ball_big` | 30×30/32×32 大圆弹 |
| `ball_huge` | 56×56/64×64 特大圆弹 |
| `ball_light` | 加算光晕球 |
| `ellipse` | 竖椭圆/米弹 |
| `square` | 方形符卡/札 |
| `arrow_small` | 小箭头/飞镖 |
| `arrow_big_c` | 大箭头/燕尾 |
| `grain_a` | 彗星/叶片 |
| `grain_b` | 细长胶囊/针 |
| `grain_d` | 水滴 |
| `star_small` | 小五角星 |
| `star_big` | 大五角星 |
| `butterfly` | 四瓣/蝶形 |

## 2. TH095 → `th33.lua`

TH095 的 24 个 `bulletType`（0–23）映射如下：

| type | 原作形状 | 本项目样式 |
| ---: | --- | --- |
| 0 | 8×8 小圆粒 | `ball_small` |
| 1 | 白心 + 外环圆弹 | `ball_mid_c` |
| 2 | 白心 + 点状外环 | `ball_mid_c` |
| 3 | 实心竖椭圆 | `ellipse` |
| 4 | 三角箭头 + 尾环 | `arrow_small` |
| 5 | 细长胶囊 | `grain_b` |
| 6 | 方形符卡 | `square` |
| 7 | 拱形/燕尾 | `arrow_big_c` |
| 8 | 水滴 | `grain_d` |
| 9 | 彗星/叶片 | `grain_a` |
| 10 | 描边竖椭圆 | `ellipse` |
| 11 | 小五角星 | `star_small` |
| 12 | 32×32 圆弹 | `ball_big` |
| 13 | 30×30 竖椭圆 | `ellipse` |
| 14 | 大竖椭圆 | `ellipse` |
| 15 | 四瓣/蝶形 | `butterfly` |
| 16 | 大五角星 | `star_big` |
| 17 | 64×64 红色眼球 | `ball_huge` |
| 18 | 光晕球 | `ball_light` |
| 19 | 32×32 圆弹 | `ball_big` |
| 20 | 竖椭圆 | `ellipse` |
| 21 | 大竖椭圆 | `ellipse` |
| 22 | 四瓣/蝶形 | `butterfly` |
| 23 | 方形符卡 | `square` |

## 3. TH10 → `th35.lua`

TH10 的 `etSprite(slot, type, color)` 中，第二个参数是 bullet type：

| type | 原作形状 | 本项目样式 |
| ---: | --- | --- |
| 0 | 8×8 小圆粒 | `ball_small` |
| 1 | 白心 + 外环圆弹 | `ball_mid_c` |
| 2 | 白心 + 点状外环 | `ball_mid_c` |
| 3 | 实心竖椭圆 | `ellipse` |
| 4 | 三角箭头 + 尾环 | `arrow_small` |
| 5 | 细长胶囊 | `grain_b` |
| 6 | 方形符卡 | `square` |
| 7 | 拱形/燕尾 | `arrow_big_c` |
| 8 | 水滴 | `grain_d` |
| 9 | 彗星/叶片 | `grain_a` |
| 10 | 描边竖椭圆 | `ellipse` |
| 11 | 小五角星 | `star_small` |
| 12 | 32×32 圆弹 | `ball_big` |
| 13 | 30×30 竖椭圆 | `ellipse` |
| 14 | 大竖椭圆 | `ellipse` |
| 15 | 四瓣/蝶形 | `butterfly` |
| 16 | 大五角星 | `star_big` |
| 17 | 64×64 红色眼球 | `ball_huge` |
| 18 | 光晕球 | `ball_light` |
| 19 | 32×32 圆弹 | `ball_big` |
| 20 | 竖椭圆 | `ellipse` |
| 21 | 大竖椭圆 | `ellipse` |
| 22 | 四瓣/蝶形 | `butterfly` |
| 23 | 16×16 方形符卡 | `square` |
| 24 | 8×8 小粒子 | `ball_small` |
| 25 | 红色光晕球 | `ball_light` |
| 26 | 竖椭圆 | `ellipse` |

`風神様の神徳` 的原作调用是 `etSprite(0, 6, $I0)`，因此它的
弹型改为 `square`；色号仍按 type 6 的 16 色表换算。

`etSprite` 在飞行途中还会改 type/color。`th35.lua` 的 `TK_SPRITE` 必须同时执行
`ChangeImage(t10_style(type), t10_color(type, color))`，不能只记录颜色。

TH10 各 type 的连续调色板帧数（由 `g_BulletSpriteScriptBase` 与
`bullet.anm` 的相邻脚本数核对）为：

- type 0–11、24、26：16 色；
- type 12–16、19–22：8 色；
- type 17：4 色（红、紫、绿、黄）；
- type 23：3 色；
- type 18、25：各只有 1 个固定色脚本，分别是蓝色与红色光球，不按色表偏移。

## 4. TH07 → `th34.lua`

TH07 的 bullet sprite 是 `g_BulletTypeInfos[type]` 的主弹脚本，再由
`spriteOffset` 选颜色帧。

| sprite | 原作形状 | 本项目样式 |
| ---: | --- | --- |
| 0 | 8×8 小粒子 | `ball_small` |
| 1 | 白心 + 外环圆弹 | `ball_mid_c` |
| 2 | 实心竖椭圆/米弹 | `ellipse` |
| 3 | 白心 + 细色环圆弹 | `ball_mid` |
| 4 | 三角箭头 + 尾环 | `arrow_small` |
| 5 | 细长粒子 | `grain_b` |
| 6 | 拱形/燕尾 | `arrow_big_c` |
| 7 | 32×32 大圆弹 | `ball_big` |
| 8 | 蝶形 | `butterfly` |
| 9 | 剑/长针 | `knife_b` |
| 10 | 64×64 爆闪光球 | `ball_huge` |

TH07 的主弹颜色是 `baseSprite + spriteOffset`。`g_BulletSpriteOffset16Px` /
`g_BulletSpriteOffset32Px` 只用于出生特效，不能用它们代替主弹颜色映射。

## 5. 颜色映射

本项目 16 色帧序为：

`1 深红 / 2 红 / 3 紫 / 4 品红 / 5 深蓝 / 6 蓝 / 7 青 / 8 亮青 /
9 深绿 / 10 绿 / 11 黄绿 / 12 黄 / 13 橙 / 14 亮橙 / 15 深灰 / 16 白`

原作 16 色组（颜色号 0–15）映射：

| 原作色号 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 |
| --- | -: | -: | -: | -: | -: | -: | -: | -: | -: | -: | --: | --: | --: | --: | --: | --: |
| 本项目帧 | 16 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 11 | 13 | 16 |

原作 8 色组（颜色号 0–7）映射：

| 原作色号 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | -: | -: | -: | -: | -: | -: | -: | -: |
| 本项目帧 | 16 | 1 | 3 | 5 | 7 | 9 | 11 | 15 |

TH095 的色组按原作主弹精灵宽度选择：

- type 0–11：16 色；
- type 12–16、18–23：8 色；
- type 17：4 色（红/蓝/绿/黄）。

TH07 按主弹精灵尺寸选用 16/8/4 色组。TH10 的精确分组见第 3 节，不能仅按
尺寸类推 type 18/23/25。尤其要注意颜色号 0 是白/灰，不能像旧代理那样夹到 1
（红）。

## 6. 已知不可完全等价项

- `butterfly` 在本项目只有 8 行贴图，且 non-colorful；原作蝶形弹的色相只能近似。
- `ball_light` 是加算光晕，适合 type 18/25，但原作某些大光球的边缘纹理仍不同。
- `arrow_small`/`grain_b` 的轮廓与原作 14×16 飞镖/胶囊同族，但不是逐像素相同。
- 原作的逐帧自转、4 帧动画（如 TH07/TH10 的大眼球、TH095 的 type 19）本次不补；
  本次只对齐第一帧外形与色号。
- 本项目样式自带碰撞尺寸；替换后如果与原移植版的占位判定不同，应以脚本检查结果
  为准，后续再单独处理判定兼容。

## 7. 实现状态

- `th33.lua`：已落地。`ex_color` 按 TH095 的 16/8/4 色组换算，`sg_style`
  覆盖 bulletType 0–23；固定样式调用点已改为按 type 取图。
- `th34.lua`：已落地。公共 `TH07_STYLE` / `th07_color` 覆盖 TH07 bulletType
  0–10，各关道中、Boss 非符和符卡均已替换旧的局部占位样式。
- `th35.lua`：已落地。公共 `T10_STYLE` / `t10_color` 覆盖 TH10 bulletType
  0–26；顶部「風神様の神徳」使用 type 6，后半 ECL pattern 发弹按 type/color
  取图，飞行中的 `TK_SPRITE` 同时换形状与颜色。
- 验证：`luajit tools/check_stage.lua mod/GAME/th33.lua`、
  `th34.lua`、`th35.lua` 均通过，注册与全卡模拟无运行时错误。

近似项：

- `butterfly`、`ball_light` 与部分 14×16 的 arrow/grain 只是同族轮廓，不是逐像素一致；
- 原作出生/消散动画、自转和 4 帧循环动画本次不补，只对齐主弹第一帧外形与色相；
- 本项目样式自带碰撞尺寸；本次没有为了视觉映射改弹道、发数、速度、判定或流程。
