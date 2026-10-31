# Boss Rush v3.10 子弹图集

这九张 PNG 原样取自 `吃药图书全作bossrush/Boss Rush v3.10/data/THlib/bullet/`，
已核对与该版本实际载入的 `data.zip` 中同路径文件逐字节一致。
映射集中在 `THlib/bullet/bulletStyle.lua`，使用 `v310_` 纹理名前缀，避免与保留的高清图集重名。

- 按同名弹型使用旧版切图坐标、中心点和原生显示尺寸，共 26 种弹型。
- 旧版只有八色的弹型，将相邻两个色号映射到同一张原图，保留现有 1–16 色编号接口。
- `music`、`water_drop` 沿用旧版动画帧布局与间隔；`gun_bullet` 使用旧版静态图，
  以单帧动画资源注册，兼容现有渲染和灰色拖影接口。
- `preimg` 出生雾效、`fade_ball_huge` 和 `fade_ball_light` 消散图同步使用旧版图集。
- 保留本项目原有碰撞尺寸、判定形状、运动和发弹逻辑。
- 旧版没有同名资源的 `arrow_big_b`、`arrow_big_c`、`arrow_small_b`、`grain_d`、
  `diamond`、`money_big` 继续使用原有图集；独立樱花贴图与激光资源不属于本次图集替换。

已验证：448 项图像/动画资源与旧版切图一致，524 项原有资源的碰撞参数和资源类型不变；
Windows LuaSTG Sub v0.21.2 实际载入、创建 416 个同名弹型实例并完成渲染；
现有子弹映射、换色、动画及灰色拖影回归部分通过 1708 项检查。
