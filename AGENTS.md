# AGENTS.md

给在这个仓库里写代码的 AI 助手看的说明书。人也可以看。

> 这份文档记录的是**验证过的事实**和**踩过的坑**，不是设计理想。
> 每条结论后面尽量附「怎么知道的」（文件:行号、实测数字、失败现场），
> 这样下一个人（或下一次的你）可以自己去核对，而不是照抄。
>
> 凡是自己没验证过的，宁可不写。写错了比不写更贵。

---

## 1. 这是什么

**Boss Rush HD** —— 基于 **LuaSTG Sub 0.21.129** 的中文东方同人弹幕游戏。
把官方各作的 Boss 战串成一整个长流程，每关一个 Boss 组，外加若干自制关卡。

- 本目录是**游戏发行目录**（引擎 exe + Lua 脚本 + 素材），不是引擎源码工程
- 引擎 C++ 源码在隔壁 **`../LuaSTG-Sub`**（同版本）。查引擎行为/API 真相去那里找，
  比如回收规则在 `LuaSTG/LuaSTG/GameObject/GameObject.hpp`
- 远端：`github.com/hophenby2/bossrush`

**语言**：Lua 5.1 语义（引擎内嵌 LuaJIT）。
**注释、卡名、文档一律用中文**，与现有代码一致。

### 关卡编号

| 文件前缀 | level | 说明 |
|---|---|---|
| `th06` – `th185` | 1 – 19 | **原作移植**。卡 id 1–243 |
| `th00` – `th05` | 20 – 25 | 自制关卡。卡 id 244–295 |
| `th20` | 26 | 自制：地灵殿全员。卡 id 296–330 |
| `th16AEX` | `STAGE_COUNT + 1` | 天空璋 AEX，自成一套 |

⚠ **别用「卡名是不是日文」判断哪张是原作。** 原作脚本的卡名**已经被中文化**
（CLAUDE.md 硬性规定），保留日文的只有寥寥几个；反过来 `th00`/`th02`/`th05`/`th20`
这些自制关卡的卡名里有不少日文。**正确判据是文件批次**（`th06`–`th185` 才是原作）。

---

## 2. 硬约束（先读这段）

| 事实 | 含义 |
|---|---|
| **没有构建步骤** | Lua 是引擎解释执行的，改完脚本直接生效，没有编译/打包 |
| **本机跑不起游戏** | `LuaSTGSub.exe` 是 Windows 的，macOS 上没有构建产物。**别假设你能"跑一下看看"** |
| **没有 `.dat` 资源包** | `launch` 会优先加载 `mod.dat`/`core.dat`/`res.dat`/`shader.dat`；当前都不存在，所以散装文件直接生效。**若哪天出现了 `.dat`，它会盖住散装文件** |
| **别动 `User/`、`replay/`** | 玩家存档与录像，已在 `.gitignore` 里忽略 |
| **改动要能被验证** | 见第 10 节。跑不起游戏不代表可以不验证 |

---

## 3. 目录地图

```
core.lua              入口回调：GameInit / GameExit，STAGE_COUNT / SYSTEM_COUNT 也在这
launch.lua            引擎启动 + 全局注入（把 lstg.* 全灌进 _G）+ 按键常量
launcher.lua          启动器的 UI
manual                游戏内说明书（纯文本）

mod/
  root.lua            载入 THlib 与 _editor_output
  _editor_output.lua  ★ 编辑器产物总汇：_editor_class/_editor_boss 的建立、
                        StageID 关卡载入列表、Create.* 弹幕工厂、WhiteScreen、stage_pic 纹理
  main_stage.lua      ★ 所有关卡组的注册（NewStage(...)）与关卡流程
  music.lua           AddMusic(...)（BGM 的循环点与曲名）
  defachievement.lua  DefineAchievement(id, ...)
  BG/TH<id>/TH<id>_bg.lua   关卡背景类（全局 TH<id>_bg）
  GAME/th<id>.lua     ★ 关卡内容：_editor_class["THxx"]、boss.Define、符卡
  GAME/th08-boss_lastword.lua / th08-boss1.lua   th08 拆出来的两部分
  th16AEX/            天空璋 AfterExtra，自成一套（关卡号 = STAGE_COUNT + 1）

THlib/                游戏框架（"Touhou style library"），一般不用改
  lib/      底层：Lobject(Class/object) LObjectEvents(对象方法) Ltask(协程/移动)
            Lresources(资源与 SetImageState) Lscreen(世界/摄像机) Lmath/Lapi(全局数学)
  enemy/    ★ boss.lua(Define/Create/CreateGroup) boss_card.lua(New/add)
            boss_system.lua(状态机) enemy.lua(敌机基类)
  bullet/   bullet.lua + bulletStyle.lua（全部弹样式与贴图名都在这）
  laser/    laser.lua（直线光）/ bent laser.lua（曲线光，别名 bent_laser）
  background/  background.lua(基类) spellcard.lua(_SC_BG 符卡背景基类)
  sp/       spMath.lua（AngleIterator / EllipseIterator / HeartIterator / PolygonIterator）
            sp.lua（GetPointLine / GetPointBezier）
  misc/     misc.lua（RenderRing / SectorRender / RenderOutLine / RenderTexInRect /
            PolarCoordinatesRender / RenderPointLine / ShakeScreen …）
  player/ item/ ext/ UI/

Resources/
  Special/*.png       ★ 引擎按目录自动扫，名字 = 文件名去 .png（主题贴图库，50 张）
  BossBackGround/*.png ★ 同上，按文件名注册成**纹理**（th06_1 … th18_13，每作十几张）
  BossImage/*.png     行走图
  System/*.lua

music/*.ogg           BGM，文件名必须等于 AddMusic 的 id
tools/check_stage.lua 静态自检工具（不是游戏的一部分，引擎不会载入）
```

**`Resources/Special/` 是主题装饰贴图库**，用之前先翻一遍：
`Nuclear1/2`（核融合，空的）、`FireBird`、`cherry_bullet`、`fan`、`mirror`、
`eyeL/eyeR`、`moon`、`Boat`、`servant`、`ice`、`frog`、`miko_back`、`yukari-ef`、
`kanako-ef*`、`junko_back`、`suika_fog`、`Blindness`、`BlackFog`、`Slash`、
`bright`、`bright_line`、`circle_charge`、`machine`、`photo*`、`2dcode*` …

---

## 4. 载入顺序

```
core.lua: GameInit()
  └─ Include 'mod\root.lua'
       ├─ Include 'THlib\THlib.lua'        （全局框架、LoadRes = {}）
       └─ Include 'mod\_editor_output.lua'
            ├─ 立刻执行：建 _editor_class / _editor_boss、WhiteScreen、Create.*、
            │            读 StageID 列表……
            └─ 其余全部走 IncludeLuaFile → 塞进 LoadRes **延后执行**：
                 mod/BG/TH<id>/…_bg.lua → mod/GAME/th<id>.lua （每个 id 先 BG 后 GAME）
                 mod/main_stage.lua、mod/summary.lua、mod/th16AEX/root.lua

  STAGE_COUNT = 26、InitAllClass() ……（注意：在 Include 'mod\root.lua' **之后**）

稍后（进游戏、载入画面时）
  THlib/UI/loading.lua 的 LoadingImage() 才真正执行 LoadRes
```

两个容易踩的点：

- `IncludeLuaFile` 只在 `GlobalAddAchievement` 为真时立即执行（那个标志在
  `THlib/UI/title.lua:20` 才置真），所以正常情况下上面那些文件**都是延后载入的**。
  这也意味着「在文件顶层读 `STAGE_COUNT`」是安全的 —— 等你被载入时它已经赋好值了。
- `LoadRes` 是用 `pairs` 遍历的。它是个稠密数组，实践中顺序稳定，所以
  「BG 先于 GAME」成立 —— 这是**约定**，别依赖得更细。

---

## 5. 接口速查

### 5.1 Boss / 符卡

```lua
-- 注册一个 boss（THlib/enemy/boss.lua）
boss.Define(editname, name, BGM, BG, {x, y}, SCBG, img, level[, scale])
--   editname  "1a"（字母后缀不能省）      name   "西行寺幽幽子"
--   BGM       "TH03_0"                  BG     TH03_bg（全局背景类）
--   SCBG      class["SCBG1"]（符卡背景，**允许为 nil**）
--   img       "Yuyuko"（行走图，必须是 THlib/BossImageList.lua 里的键）
--   level     23（= 关卡号；注册键是 editname..level，即 "1a23"）

-- 造一张符卡（THlib/enemy/boss_card.lua:57）
local card = boss.card.New(name, t1, t2, t3, hp[, drop, is_extra])
--   t1/t2/t3 单位是**秒**（内部 ×60 存成帧）：
--     t1 = 无敌时间（打不动）  t2 = 防御时间（伤害线性爬升）  t3 = 总时限
--   强制 t1 <= t2 <= t3；t1 == t3 就是「耐久符卡」（伤害恒 0）
--   name 传空串 "" → 这是**非符**（is_sc = false）

-- 挂到 boss 上（THlib/enemy/boss_card.lua:112）
boss.card.add({ { card, "1a" } }, level, CardName, data_id[, OD, inotherstage])
--   {card, bossID} 组：双 boss 同一张符卡就写两组
--   data_id  符卡历史的槽位号（spell_card_data 的键），**跨关卡全局唯一**
--   OD       填了就变成「只能在符卡练习里打」的隐藏卡，不进 BOSS.cards
--   卡**挂在各个 boss 自己的 `BOSS.cards` 表上**，所以同一 boss 的 card.add
--   调用顺序 = 出卡顺序

-- 关卡里生成（mod/main_stage.lua 的关卡任务中）
boss.CreateGroup(group, level)   -- 依次 Create "…a"/"…b"/…，字母必须从 a 起连续
boss.Create("1a26")
```

符卡的生命周期（`THlib/enemy/boss_system.lua:918` `system:doCard`；
 `b.current_card = card` 在 :922、`card.init(b)` 在 :955、`current_card.frame(b)` 在 :133）：

```
b.current_card = card            ← ① 立刻设上
task.New(self, function()        ← ② 协程里排队
    before(boss)                 ← ③ 等它跑完（可能几十帧）
    …castcard / setStatus / openSCBonus…
    init(boss)                   ← ④ 这时才第一次跑
end)
frame(boss) × N  →  del(boss)
```

**`self` 是 boss 本身，不是卡对象**（卡只是被挂到 boss 上的行为表）。
所以 `self.x/self.y/self.ani/self.timer/self.colli/self._bosssys` 都是 boss 的。

⚠️ **除了 `before` / `init` / `frame` / `render` / `del` 这五个，别在卡上挂别的方法。**
引擎只按名字调这五个，其余字段属于**卡表**；而 `self` 是 boss ——
`function card:helper()` 之后再写 `self:helper()` 会直接 `nil`。
要在卡里复用逻辑，就写成 `do` 块里的**局部函数**，把 boss 当参数传进去。

⚠️ `self.ani` / `self.timer` 是 **boss 从出生算起**的总帧数，不是"本张卡的第几帧"。
卡里要做随时间收窄/加速的效果，得自己在 `init` 里开个计数器。

### 5.2 弹 / 对象 / 激光

```lua
-- 最常见的直线弹（THlib/bullet/bullet.lua:287）
NewSimpleBullet(style, color, x, y, v, a[, aim, omiga, stay, destroyable,
                rebound, through, frame, render])
--   style 必须是**弹样式对象**（ball_mid / knife / butterfly / ellipse …），不是字符串
--   ⚠ 写成 "ball_mid"（带引号）**必崩**：bullet.init 里 `self.class = imgclass`，
--     引擎要求 class 是 luastg 对象类 → "invalid argument for property 'class'"
--   color 1..16（COLOR.RED=2 等）；butterfly/music 只有 8 色
--   stay = false 表示"一出膛就走"；不传会先原地悬停约 11 帧
--   ★ **末两参 frame/render 是自绘钩子** —— 自定义运动不用写子弹子类：
--     `NewSimpleBullet(..., ..., function(b) … end)`，或事后 `b.frame_other = fn`
--     （th07.lua:812、th13.lua:671 都是这么写的）
--     签名：`frame(self)`、`render(self)` —— **只收一个参数**
--     ⚠ `THlib/bullet/bullet.lua:251` 是 `self.frame_other(self)`，引擎
--       **不会**把计时器传进来。要计时读 `self.timer`（引擎每帧 +1）。
--       写成 `function(b, t)` 的话 `t` 恒为 nil → `t > w` 就是
--       `attempt to compare nil with number`，**真机上第一颗弹就崩**（th20 的
--       `freeze_layer` 整整 7 张卡都栽在这上面，而自检当时也不调 frame_other）。

-- 自定义运动：继承 bullet，在自己的 frame 里算位置
local my_bullet = Class(bullet, {
    init = function(self, style, col, x, y, a, path)
        bullet.init(self, style, col, false, true)
        self.x, self.y, self.rot = x, y, a or 0
        self.path, self.bound = path, false      -- 关掉引擎回收 → 必须自己回收
    end,
    frame = function(self)
        bullet.frame(self)
        if self.timer > 300 then object.RawDel(self) return end
        self.path(self, self.timer)
    end,
    render = function(self) bullet.render(self) end,
})

-- ★ 可碰撞的实体（无限血、自机会撞到）—— 做「结构」用这个
class["hitter"] = Class(enemy, {
    init = function(self, x, y, xx, yy, mst)
        enemy.init(self, 15, 999999, false, false, false)  -- nontaijutsu=false → group=GROUP.ENEMY
        self.mst, self.xx, self.yy, self.sc = mst, xx, yy, 0
        object.Connect(mst, self, 0, true)                 -- 挂到 boss，跟着走
    end,
    frame = function(self)
        self.x = self.mst.x + self.xx * self.sc            -- sc 是 0→1 的 sin 半周
        self.y = self.mst.y + self.yy * self.sc
    end,
})
--   `ext.lua:205 ck(GROUP.PLAYER, GROUP.ENEMY)` → 自机会撞到 GROUP.ENEMY
--   `ext.lua:209 ck(GROUP.ENEMY, GROUP.PLAYER_BULLET)` → 自机的弹能打到它

-- 纯演出（无判定）：Class(object, {...}, true)，自己在 frame 里动、自己 RawDel
-- 光束：laser（直线）/ bent_laser（曲线，别名 bent）
-- 自绘：SetImageState("white", "mul+add", a, r, g, b) + Render("white", x, y, rot, h, v)
--      画实心矩形 / 边框用 RenderRect(img, x1, x2, y1, y2)
```

### 5.3 移动 / 挂载

```lua
task.MoveTo(x, y, t, mode)                     -- 直线走 t 帧
task.CRMoveTo(t, mode, x1,y1, x2,y2, …)        -- Catmull-Rom 样条
task.MoveToPlayer(t, x1,x2, y1,y2,
                  dxmin,dxmax, dymin,dymax, mmode, dmode)
--   ★ 第一个参数是**时长**，别和 MoveTo(x, y, t) 搞混
--   框 [x1,x2]×[y1,y2] 是**相对自机**的：boss 在「自机旁边那个框里」随机游走
--   dmode：0 从自机方向靠近 / 1 只管 x / 2 只管 y / 3 随机（WANDER_MODE.*）
--   原作的压迫感主要来自这里 —— th16.lua 用了 18 次、th08-boss1 13 次

object.Connect(master, servant, dmg_transfer, con_death)
--   con_death 为真 → 登记进 master._servants；object:KillServants() 会 Kill 它们
--   ⚠ `boss_system:refresh(1)`（boss_system.lua:653，换卡/击破时调）会 KillServants
--     → **要活得比卡久的物件不要挂**；只活本卡的挂了最省事
object.SetRelPos(x, y, rot, follow_rot)        -- 相对 master 定位
object.RawDel(o) / object.Kill(o) / object.Del(o)
object.smear_add(o, a) / smear_frame(o, decay) / smear_render(o, mode, color)
```

---

## 6. 房屋风格

作者的自制关卡有一套很统一的写法，**新代码请沿用**：

- 文件头一段注释说明这一关/这张卡想做什么（含设计意图和量化参数）
- `local class = {}` + `_editor_class["THxx"] = class`，所有自定义类都放 `class["..."]`
- 文件顶部把要用的全局抓成本地（`local task, object, bullet = task, object, bullet`）——
  既能防手滑写错名，也快一点
- **每张符卡一个 `do … end` 块**，块的**最上面**集中放这一卡的常量（数值、节奏、速度），
  下面才是逻辑。改手感只动那一段
- 需要复杂运动的弹走 `NewSimpleBullet` 的 `frame` 钩子；演出控制器是挂在 boss 上的
  object 子类，`card:del` 里 `object.RawDel` 掉
- **注释写"为什么"**，不写"是什么"。现有代码里大段中文注释解释设计意图，请保持

模板：`th01.lua` / `th02.lua` / `th03.lua` 是基本风格；
**`th20.lua` 是「按第 7 节规范写」的样板**，每张卡块的注释里标了结构、缺口、周期。

参数别用魔数随手写。

---

## 7. 弹幕设计规范

### 7.1 核心认识：**没有「限位层」这个东西**

这是本仓库最容易走偏的一条。早期版本（`th03`/`th04`，以及已删除的 `th19`）把「限位」当成一个
要**单独完成**的任务，于是越做越硬：先画矩形弹墙，再直接夹 `player.x/y`。**那是错的。**

**证据**（可自行核对）：

| | 改 `player.x/y` | 铺满屏的自绘墙 |
|---|---|---|
| SR_Subterrain_Reanimation（61 张卡） | **0 次** | **0 次**（`RenderRect` 一次没用） |
| 原作移植 `th06`–`th185`（**221 张**） | **10 处**（20 行），**全是传送 / 软场** | 0 处「四面朝内收」的墙 |

那 10 处里真正「夹住自机」的**只有 1 处**（`th08-boss_lastword.lua:1552` 蝴蝶梦之舞），
而且 90 帧才收一点、横向根本夹不住。其余是：

| 机制 | 出处 | 性质 |
|---|---|---|
| 与 boss **对调坐标** | `th06.lua:329` | 演出（配 `WhiteScreen` + `bullet_cleaner` 清场） |
| **开局传送**到固定点 | `th07.lua:1214`、`th10.lua:1460`、`th11_2.lua`（6 处） | 演出，一次性 |
| **隙间**传送 | `th143.lua:200` | 道具 |
| **抬地板**（单向） | `th07.lua:819` `player.y = max(player.y, y+80)` | 软场 |
| **弹簧**拖到幕布下方 | `th125.lua:449` `* 0.07`（τ≈14 帧） | 软场 |
| **切向甩**（不是往外推） | `th095.lua:657` `+90*d` | 软场 |
| **引力**吸向某点 | `th143.lua:1841` `* 0.4` | 软场 |

**「四面矩形弹墙朝内收」在原作里一处都没有。** 自制关卡里倒有 3 处
（`th03.lua:521` 夹框、`th04.lua:539` 抬地板、`th04.lua:1235` 夹框三档），
**`th20` 是 0 处。**

**约束是攻击图案本身的副产品。** 它来自三样东西，按重要性排：

1. **boss 一直贴在自机旁边** —— `task.MoveToPlayer(...)`。原作每个文件用 4~18 次。
   它决定所有自机狙的出膛距离恒定，是压迫感的**主来源**，跟墙完全无关。
2. **挂在 boss 身上的实体**（`Class(enemy, …)`，见 7.4）—— 自机会撞到它。
3. **子弹从结构上发出来**，以及**冻结 / 解冻的节奏**（见 7.6）。

### 7.2 密度的量化标尺

自检的 `--threat` 会报 `60px 内弹数 平均/峰值`、`死局 N 帧 (%)`。
用实测反推出的档位（数据来自对 `th06`–`th185` 的抽样）：

| 档 | 60px 内平均 | 死局 | 代表 |
|---|---|---|---|
| 装饰档 | 0 ~ 1 | 0% | th06 暗冰符、th07 春人偶 |
| **标准符卡** | **5 ~ 14** | 0% | th06 金华、th07 网孔、th12 猛虎 |
| 高压符卡 | 13 ~ 25 | 0 ~ 3% | th12「缝里的珍宝」、th10 祸斗 |
| **墙（失控）** | **≥ 25 且 死局 > 5%** | 8% ~ 48% | th07「花诞日」48.2%、th10 祸斗 11.7% |

**判据：一张卡如果 `60px 内平均 > 25` 或 `死局 > 5%`，那是墙，不是符卡。**
原作 221 张里抽样只见到 3 张（`th07.lua:704` 花诞日 48.2%、`th10.lua:984` 祸斗 11.7%、
`th12.lua:755`「缝里的珍宝」8.7% —— 都可以用 `--threat` 自己复现）。

⚠ **`死局` 比 `密度` 重要。** 密度高但死局 0% = 「很挤但永远有路」；
死局一有就是「这一帧无解」，玩家会觉得被耍。

⚠ **`60px 内平均` 量的是自机脚边，不是「屏幕上」。** 自机站在弹幕外围时这一栏会是 0
（`th20` 的卡 1 实测 0.0，同屏却有 224 发）。判断「这张卡是不是空的」要看
**`峰值同屏 弹`**：`th20` 修好之后最低的一张是 **158**，中位 **263**；
低于 **150** 就该怀疑是不是缺了底帘（见 7.3.1）。

⚠ **所有密度读数都必须跑多种子取最坏**（理由见 §10 扫②）。

### 7.3 密度靠**形状**，不靠**墙**

每张卡换一种，**别一张抄十遍**（这是本仓库犯过的最大错误：`th19` 的 35 张卡里
18 张用了同一段螺旋，只改颜色）。可以换的形状：

| 形状 | 怎么做 | 缺口 / 节奏 |
|---|---|---|
| **多路扇 + 相位重掷** | `fly(style, col, x, y, v, base + i*step)`，`n = 13~30` | 缝 = `360/n`°；每波 `base = ran:Float(0,360)` 或 `base += k*d`，20~40 波后 `d=-d` 反向 |
| **同心环 + 层间速度差** | 同一帧打 `L` 个环，每环相位差 1°、**速度差 `1/L`** | 环在**径向上自己拉开**，玩家穿的是「环与环之间的径向缝」。每 60~80 帧一轮、每轮反向（`th15.lua:1249`「料得年年肠断处」：16 环 × 15 路，v 2.0→3.0） |
| **双螺旋** | 正反两股，半径递减 + 相位每层推进 | 层间 `task.Wait(5~10)`，`rot = ran:Float(0,360)` 每轮重掷、`d=-d`。**同样弹数下读数比放射环高好几倍** |
| **冻结环 → 解冻外射** | 先 `v = 0` 冻在场上，等 `w` 帧再把速度从 0 加上去 | 整屏是弹，但「哪些已激活」的波前在推进，**安全区就是这个波前**（SR 的 `4p0-wait`，卡 5092：30 个环，半径 90→3 递减、冻结 30→204 帧递增） |
| **结构节点吐扇** | 子弹从 7.4 的结构上发，不从 boss 发 | 每个节点各自瞄准 / 各自相位 |
| **单向帘幕** | 从屏幕**一条边**生成 `行×列` 点阵，每 k 帧推一行 | 只盖住一角，另一侧永远空。`d=-d` 换边（`th13.lua:716`、`th10.lua:351`） |
| **激光笼** | 几根激光插在一个多边形顶点上，**全程不动** | 限制的是「能去哪」，不是「必须站哪」。安全区 = 笼内全部（`th07.lua:1218`：r=260 八边形 + boss 在内圈公转） |

**「环 + 缺口」和「螺旋」是最主流的两种**；「放射环」最不划算 ——
它的弹走径向，只有正对自机那条线 ±2° 以内的几颗会被统计到
（实测同参数下放射环 0.1~0.5、螺旋 1.5~3.5）。

#### 7.3.1 每张卡都**先有一层底帘**（`th20` 血的教训）

写完招式不算写完。**每张卡都要先挂一层「不管这张卡在演什么，屏幕上始终有弹在走」的底**，
招式叠在它上面 —— 原作每张卡都是这两层加起来的密度。

`th20` 第一版漏了这一层，于是 35 张里有 **13 张同屏弹数比原版低一个数量级**
（最少的一张峰值只有 9 发），玩家看到的就是「空的、不知道这卡在干什么」。
补上底帘之后同屏峰弹中位从 **207 → 263**，最低的一张从 9 → 158。

`mod/GAME/th20.lua` 的 `base(self, o)` 就是干这个的，四种形状按卡换：

```lua
base(self, { kind = "ring",   layers = 7, n = 14, v0 = 1.5, v1 = 3.3 })  -- 同心环
base(self, { kind = "fan",    n = 14, v0 = 1.8, dv = 0.6 })              -- 自机方向扇
base(self, { kind = "spiral", layers = 10, n = 14, v0 = 1.5, v1 = 3.5 }) -- 双螺旋
base(self, { kind = "rain",   n = 20, rows = 3, reps = 26 })             -- 垂帘（缝会滑动）
```

**底帘不能和招式叠成两堵墙。** 卡本身已经是全屏约束（比如四边往内收）时，
底帘要用「环 / 螺旋」这种不封路的，别用「垂帘」。

#### 7.3.2 层间速度差**必须够大**，否则环是实心的

同心环 / 螺旋是 `L` 层叠着打出去的。相邻两层在 `T` 帧后拉开 `T*(v1-v0)/L` px。
`L=12`、`v0=2.0 v1=3.0` → 每层只差 `0.083 px/帧` → 150 帧后才拉开 **12 px**：
整圈糊成**一个实心环**，玩家一条径向缝都找不到 —— `th20` 里 25 处
`ring_layer`/`spiral_layer` 调用**全部**踩了这个（死局 4~8%）。

**下限：每层至少差 `0.20 px/帧`**（150 帧 → 30 px 缝，够穿）。
`th20.lua` 的 `spread_v(L, v0, v1)` 把这条写进了 helper ——
**约束要写在代码里，不能只写在文档里**，否则下一张卡照样违反。

#### 7.3.3 一股「流」是有宽度上限的

一条从固定点每 `k` 帧发一颗的流，弹与弹的间隔 = `v × k`。
间隔**小于**自机能钻的宽度（约 14 px）时，**这一股本身就是一条过不去的活动墙** ——
`th20` 的「死符『ゴーストタウン』」原来 `v=1.9`、每 3 帧 → 间隔 5.7 px，
四股一扫就把自机夹死（**死局 19%**）。拉到 `v=3.0`、每 6 帧 → 间隔 18 px 才穿得过去。

**同理：缝（缺口）固定不动也是墙。** 垂帘的缝、环的缺口都要在动
（`gapx` 每帧 `±gapspeed`、`d = -d`），否则两片固定缝一旦错开就夹死。

### 7.4 结构：挂在 boss 身上的实体

这是 SR 最核心的原语（`hitter`，全作用了 **42 次**）：

```lua
-- 位置 = master + (xx, yy) * sc，sc 是 0→1 的 sin 半周（从 boss 身上长出来）
frame = function(self)
    self.x = self.mst.x + self.xx * self.sc
    self.y = self.mst.y + self.yy * self.sc
end
```

用法：

- **排成格 / 圈**：SR 的燐那张卡（`_editor_output.lua:5746`）摆 **3 圈 × 6 个**
  （半径 30/60/90，每圈错开 30°），整个格绕 boss 转，**子弹全从这 18 个节点发**。
- **连成链**：`x = o1.x*sc + o2.x*(1-sc)` —— **两点插值，每帧重算**。
  boss 一动整张网自动跟着变形，**不需要谁去维护它**（SR 的 `1p1-chain`）。
- **可打掉的节点**：给有限 hp + `kill` 里 `Damage(boss, n)`，清光就结束符卡
  （SR 山女的网：8 个 `hp=400` 的节点，符卡结束靠打光它们）。
- **探照灯**：`x = boss.x + dx*cos(aa)`、`y = boss.y + dy*cos(aa+30)` ——
  李萨如曲线绕 boss 转，各自扫出一道光束（SR 的 `2p0-cctv`）。

⚠ **不要用「每 N 帧往同一批坐标撒一把 `v = 0` 的弹」来做装饰图形。**
那些弹永远不会离开回收边界（`bound` 对不动的弹没有意义），弹数会**线性涨** ——
`th19` 有 18 处这么写，几张卡的峰值弹数冲到 24692 / 9188 / 6963（真机就是卡死）。
**整体在动、单体不动的图形要自绘**（`thin_line` / `Render` / `RenderRect`）。

### 7.5 装饰：**符卡背景是面积最大的装饰面**

原作的装饰分六类，按面积排：

| 类 | 是什么 | 怎么做 |
|---|---|---|
| **A 符卡背景 SCBG** | **最大的一层**，原作每张卡 3~5 层 | `_SC_BG.AddLayer(tex, tile, x,y, r, vx,vy, omi, blend, hs, vs, init, …)`；贴图用 `Resources/BossBackGround/th<本作>_<n>.png`。**同图铺两层、`vy` 相反、一层 `mul+add`** 是最省事的做法（`th07.lua:26`）。`Beforeframe` 回调里用互质周期改 RGB |
| B 全屏 `RenderRect` | 白闪、视野遮挡、扫描线、整屏染色 | `SetImageState("white", "mul+add", a, r,g,b)` + `RenderRect`。**别拿它当墙** |
| C 无害实体 object | 扇 / 火鸟 / 核融合球 | 见 7.4；`GROUP.GHOST`，`colli = false` |
| D 装饰**真弹** | 不朝自机，但有判定 | `NewSimpleBullet(...)`，方向不朝自机、速度 0.4~1.2 px/帧 |
| E 屏幕级后处理 | 残影 / 抖动 / 慢镜 | `mod/_editor_output.lua` 的 `SmearScreen` / `WhiteScreen`；`misc.ShakeScreen`（**只在重音用**）；`lstg.var.timeslow / gray`（**`del` 里必须还原**） |
| F 文字层 | Last Word 的歌词 | `SimpleText`（`_editor_output.lua:97`），`viewmode = "ui"` 时不随世界滚动 |

**前景装饰按角色母题选贴图**，别一律用「一圈紫色小点」。对照：

| 母题 | 贴图 | 运动 |
|---|---|---|
| 樱（幽幽子） | `sakura` / `flower2`（`cherry_bullet.png`） | **椭圆内旋螺线**：`EllipsePoint(x, y, 80+i*2, 80-i*2, …)` —— 半径一增一减，不是同心圆（`th07.lua:744`） |
| 线 / 笼（芙兰） | `knife` | 沿椭圆绕成**会张缩的笼子**（`th06.lua:490`） |
| 火（妹红 / 辉夜） | `FireBird.png` 画三遍（常驻 + 周期爆闪 + 拖尾残焰）；火焰用 **`water_drop` 水滴贴图** | `th08-boss_lastword.lua:965` |
| 核融合（空） | **`Nuclear1`（白心）+ `Nuclear2`（等离子）同轴叠两层** | `s = 0.95 + 0.05*sin(timer*4)` 脉动（`th11.lua:1286`） |
| 心 / 玫瑰（恋） | `heart` / `ellipse6` | 分层玫瑰，**个数 / 半径 / 角速度三项都不同** |
| 眼（觉） | `ellipse` 排成杏仁形；`eyeL/eyeR.png` | 第三只眼绕 boss 转 |

### 7.6 配色

- 同一张卡里**主色只用一个色系**，再拿**白心 / 亮边**提对比
- 贴图自带高光不够亮时用 `_blend = "mul+add"` 叠成发光
- **装饰层 alpha 压到 120~180，威胁层满 255** —— 玩家一眼分出该躲哪层
- 深色底放亮弹、亮色底放深弹；别全用同一档灰度的紫

### 7.7 「不显脏」四条（同一图案重复很多遍时）

1. **每轮至少改一个参数**：`d = -d` / `rot += k` / `s = min(s + k, 上限)` /
   预警时长递减。（`th13.lua:522`「桜吹雪～千年の恋をしました」一轮里同时改了三项）
2. **至少两层反向自转**，且**个数、半径、角速度三项都不同**
   （`th12.lua:1415`：内圈 4 个 +0.6、外圈 6 个 −0.3）
3. **第 i 次发射的参数写成 i 的函数**：`r_step = f(i)`、`wait = g(i)`、
   `v = base + sin(i*k) - i/N`（`th13.lua:432`）
4. **狂暴档只改局部变量**，不新增图层

### 7.8 不许做的四件事

1. **不许有独立的「限位层」** —— 见 7.1。约束必须从图案里长出来。
2. **不许「挖洞」**（`safe_spawn`：发射点离自机近就这一格不放弹）。
   玩家会看到墙少了一块，限位也被自己废掉一半。
   自机贴在发射点上时，**只允许整层换形状**（扇形 → 整圈，弹数一发不少），
   或把整层速度压到 ≤ 距离/20。
3. **不许「把这一颗挪到对面」**（`mirror_spawn`）。对面那个位置本来就有自己的一颗，
   挪过去 = 局部加倍，图案反而破了；而且阈值和同层弹的间隔是一个量级，
   一次只挪得动一两颗，**挡不住贴脸**（实测删掉前后难度几乎不变）。
4. **不许子弹「突然消失」**。`object.RawDel(弹)` 会让子弹在玩家眼皮底下不见。
   离场只有三种合法方式：**飞出回收边界**（`bound = true` 默认）、
   **淡出**（`_a` 递减到 0 再 RawDel）、**转化为下一层**。

**关于改 `player.x/y`**：原作只有四种合法形态，且都限速 ≤ 6 px/帧 ——
抬地板（**单向**，`player.y = max(player.y, floor + 80)`）、
弹簧（`player.y += (−player.y + target) * 0.07`，τ≈14 帧）、
切向甩（`Angle(self, player) + 90*d`，不是往外推）、引力（吸向某个点）。
**不要用它来「夹住自机」。**

### 7.9 写卡自检清单

1. 用 `luajit tools/check_stage.lua` 跑过吗？再跑一次 `--threat`：
   **`60px 内平均` 在 5~14 吗（高压可到 25）？`死局` 是 0% 吗？**
2. 这张卡的约束**从哪来**？说得出「boss 站位 / 结构 / 密度形状」三者之一吗？
   如果答案是「我另画了一层墙」，回去改。
3. 每张卡的**形状**和同关其他卡不同吗？参数**每轮都变**吗（7.7 四条）？
4. 屏幕上大部分区域有弹吗？还是只有中间一团？
5. **配色**明亮、有对比吗？装饰层和威胁层一眼分得开吗？
6. 有没有子弹**突然消失**？有没有**挖洞** / **挪一颗**？
7. 卡里改了 `player.x/y` 吗？是 7.8 那四种之一吗？限速了吗？
8. 装饰图形是**自绘**的，还是「每 N 帧撒一把 v=0 的弹」（后者会线性涨）？
9. `del` 里把挂上去的对象、改过的全局（`timeslow`/`gray`）都还原了吗？

---

## 8. 加一个新关卡（**9 个地方，缺一个都不行**）

以「加 `TH21`，level 27」为例（`<N>` = level，`<ID>` = 通关标记 id）：

| # | 文件 | 改什么 |
|---|---|---|
| 1 | `core.lua` | `STAGE_COUNT = 26` → `27` |
| 2 | `mod/_editor_output.lua` | `StageID` 列表里加 `"21"`（**顺序决定载入顺序**） |
| 3 | `mod/_editor_output.lua` | `for t = 1, 26 do` → `27`（`stage_pic` 纹理循环） |
| 4 | `THlib/UI/UI.lua` | `difftext` 列表**按 level 下标**加一项（**下标必须等于 level**） |
| 5 | `THlib/UI/UI.lua` | `sntext` 里加 `TH21 = "关卡名"`（存档 / replay 列表用） |
| 6 | `mod/main_stage.lua` | `NewStage("TH21", "关卡名", 27, function(self) … end)` + `self:Next(<ID>)` |
| 7 | `mod/music.lua` | `AddMusic("TH21_0", 循环起点, 循环终点, "曲名")` |
| 8 | `mod/defachievement.lua` | `DefineAchievement(<ID>, [[关卡名]], [[关卡名 No Miss]], {…})` |
| 9 | 素材 | `Resources/BossBackGround/th21_0.png`、`mod/GAME/stage_pic27.png`、`music/TH21_0.ogg` |

外加两个新文件：`mod/GAME/th21.lua`、`mod/BG/TH21/TH21_bg.lua`。

**几个联动，动一处要跟着动其余几处：**

- `STAGE_COUNT` 是 `th16AEX` 的关卡号基准（`mod/th16AEX/class.lua:6` 与 `stage.lua:19`
  都用 `STAGE_COUNT + 1`）→ 改它会让 AEX **整体平移一位**，`boss.Define` / `boss.card.add` /
  `boss.CreateGroup` 内部一致，不会错位。
- `THlib/lib/Lstage.lua:193,218` 靠 `STAGE_COUNT` 判断「通关」与「统计关」——
  新关卡应该是最后一个。`self:Next(<ID>)` 里的 `<ID>` 是**通关标记 id**，不是 level
  （TH20 是 162、TH05 是 161）。
- **符卡背景贴图**：`THlib/UI/loading.lua:14` 会把 `Resources/BossBackGround/` 下所有 png
  按文件名注册成纹理，所以放进去就能用。

**关卡背景类**（`mod/BG/TH21/TH21_bg.lua`）的 `init` 第一行必须是：

```lua
function TH21_bg:init()
    background.init(self, false)   -- ★ 漏了这句背景会被画在自机和 boss 上面
    ...
end
```

---

## 9. 坑

按**失败方式**分组，不按发现顺序。

### A. 会当场崩的

**A1. 弹样式写成字符串**：`NewSimpleBullet("ball_mid", …)`。
`bullet.init` 里 `self.class = imgclass`，引擎要求 class 是 luastg 对象类 →
`invalid argument for property 'class'`。

**A2. 贴图名不存在**：引擎在 `obj.img = "X"` / `SetImageState("X", …)` / `Render("X", …)`
时会查资源池，名字不存在直接抛 `can't find resource 'X'`。
⚠ **`LoadImageGroup('Ghost1', …, 8, 1, …)` 生成的是 `Ghost11`…`Ghost18`，
没有 `Ghost1`** —— 第 6/7 个参数是**列数、行数**，写组名当图名是最常见的错法。
自检在 `New` 出来的对象上挂了 `__newindex`，赋值那一刻就会报
（静态扫源码抓不到 `self.img = o.img or "Ghost1"` 这种 fallback 写法）。

**A3. `card.frame` 会先于 `card.init` 跑满整个 `before()` 期间**（见 5.1 的生命周期）。
所以「在 `init` 里初始化、在 `frame` 里直接 `+`」必崩：

```
th19.lua:289: attempt to perform arithmetic on field '__webrot' (a nil value)
```

⚠ 还有更早的一帧：`system:doCard` 是**立刻** `b.current_card = card` 的，
而它排的那个协程（`before` → … → `init`）**同一帧不一定跑得到**
（`doTask` 倒序遍历任务表，新加的任务本轮不会被访问）。
于是 **`frame`/`render` 会先于 `before` 和 `init` 各跑一次**。

写法二选一：**状态一律 nil 安全**（`self.__r = ((self.__r or 0) + V) % 360`），
或**把初始化挪进 `before()`**（它在任何一次 frame 之前必定跑过）。

这一类的报错是 `attempt to compare nil with number` /
`attempt to perform arithmetic on a nil value`，
**`check_stage.lua` 测不出来**（桩件太宽容，而且只有真走到那一行才炸）——
必须用静态审计：

```bash
luajit tools/check_fields.lua mod/GAME/th20.lua
```

`frame`/`render` 里读了、但 `init` 顶层从没赋值的字段，它全列出来（见 §10 扫③）。

**A3b. 自绘钩子的签名是 `frame(self)`，不是 `frame(self, timer)`。**
`THlib/bullet/bullet.lua:251-259` 调的是 `self.frame_other(self)` / `self.render_other(self)`
—— **只传一个参数**。写成 `b.frame_other = function(b, t)` 的话 `t` 恒为 `nil`，
里面任何 `t > w` 都是 `attempt to compare nil with number`，**真机上第一颗弹就崩**。

```lua
-- ✗ 崩：t 永远是 nil
b.frame_other = function(b, t)
    if t > w then object.SetV(b, v, b.rot, true) end
end
-- ✓ 计时读 b.timer（引擎每帧替所有弹 +1）
b.frame_other = function(b)
    local t = b.timer
    if t > w then object.SetV(b, v, b.rot, true) end
end
```

原作全都写 `function(self)`：`th07.lua:812`、`th13.lua:671`、`th12.lua:83`。

⚠ **`check_stage.lua` 原来从不调 `frame_other`**，所以这一整类错自检一个都抓不到
（冻结弹不开、路径弹不动，密度读数也跟着全错）。2026-09-16 补上了
（`step_tasks` 的子弹步进里）。如果你改了自检、把它去掉了，这一类会重新变成盲区。

**A4. `object.smear_add` 读的是 `self.img`，而 `bullet.init` 不设它。**
`self.img` 是**弹样式自己的 init** 设的（`bulletStyle.lua:67`
`self.img = img .. int(index)`）。直接 `Class(bullet, …)` + `bullet.init(...)`
绕过样式 init 的类，`smear_render` 里 `SetImageState(nil, …)` → 崩（th02 的流星）。

**A5. 背景类的 `init` 必须先调 `background.init(self, false)`。**
基类负责设 `self.group = 0` / `self.layer = -700.1`、把 `lstg.tmpvar.bg` 指过来、
`background.Capture(self)`。漏了 → 背景没有 group/layer → 被画在**自机和 boss 上面**，
而整屏背景不透明 → **屏幕上只剩背景，自机和 boss 都看不见**（th19 的 `TH19_bg`）。

### B. 会静默失效的（不报错，但东西没了）

**B1. `% N == 偏移` 里的偏移必须 < N。** 否则那个分支永远不成立，
整层弹幕**无声消失**。改 `GAP` 之类的常数时特别容易踩。

**B2. `sin` / `cos` / `tan` 是角度制。** `THlib/lib/Lapi.lua:110 sin = lstg.sin`，
引擎的 `legacy/DegreesMath.lua`。想要周期 P 帧就写 `sin(t * 360 / P)`。
写成弧度的 `sin(t * 0.05)` 周期是 **7200 帧**（等于不动）——
所有动画都会「冻住」，而且自检以前也查不出来（桩件原来给的是 `math.sin`）。

**B3. 自绘物件 `bound = false` 时必须自己 `RawDel`，而寿命判断不能写在提前 `return` 后面。**
th04 卡 3 踩过：扇框那 18 把不发弹，`frame` 里写了

```lua
if not self.fires then return end        -- ← 提前 return
… if t > LIFE then … object.RawDel(self) end
```

于是它们永远走不到自删那一步，每 210 帧泄 18 个对象，一张 60 秒的卡泄 300 多个，
而且**还在渲染**（`_a` 被卡在满值）—— 屏幕边缘越堆越多。
**症状：自检里「峰值同屏 对象」随时间线性涨**（修前 900/1800/3600 帧 = 107/184/341，
修后 42/43/44）。扫描办法见第 10 节。

**B4. 装饰层「每 N 帧往同一批坐标撒 v=0 的弹」。** 那些弹永远不离场，
弹数线性涨（`th19` 18 处，峰值弹数 24692）。**整体在动、单体不动的图形要自绘。**

**B5. 嵌套 `task.New` 的周期是外层的周期。** 把协程翻成帧计数器时：

```lua
while true do
    task.New(self, function() … 只活 40 帧 … end)   -- ← 起完就返回，不阻塞
    for i = 1, 60 do … task.Wait() end
    task.Wait(60)
end
```

内层虽然只活 40 帧，**触发周期是 120 帧（外层的周期）**。
翻成 `v = u % 40` 就变成频率高 3 倍。两层各取自己的模。

**B?. 自绘物件的自定义速度不要叫 `vx` / `vy`。**
引擎每帧替**所有**对象做一次 `x += vx`、`y += vy`（不是只有弹才走）。
你在 `frame` 里再自己算一遍就是**两倍速**；方向相反时正好抵消 ——
物件永远停在出生点，而且不报错，只是看起来「装饰物不动」。

```lua
-- ✗ 引擎会再 y += vy 一次，和这里的 -vy 抵消 → 一动不动
self.vy = 2.2
frame = function(self) self.y = self.y - self.vy end
-- ✓ 换个名字，引擎那一路就只看到 0
self.fall = 2.2
frame = function(self) self.y = self.y - self.fall end
```

th04 第三版的装饰蝶 / 花瓣就是这么「不动」的：3600→7200 帧对象峰从 226 涨到 458
（没有任何一个被回收）。改名之后两处峰值完全一致。

### C. 会难看的 / 会看错的

**C1. `rot` 是标准数学角。** 证据：`LObjectEvents.lua:205` 的 `SetRelPos` 用的是标准
旋转矩阵 `x' = x·cos(r) − y·sin(r)`。贴图在 `rot = 0` 时朝 **+y（上）**。
判断一张贴图 rot=0 朝哪：量它每行的不透明像素跨度（上宽下窄 = 开口朝上）。
`Lfan2` 是「上宽下窄」（160 → 487 → 279 px），所以开口在图片顶部。
⚠ **「画出来的朝向」和「弹飞出去的方向」是两个数**，别混用同一个变量。

**C2. 移植参考卡时，所有长度要按场地比例一起缩。**
我们场地 384 宽、原作 640 宽 → `K = 0.6`。只缩贴图、不缩半径 =
「扇子缩到 0.18、弹却还从原作的 r=100 冒出来」—— 弹根本不在扇子上。
**只留一个比例常数，所有长度从它算。**

**C3. 不要给原作没有的东西编生命周期。** th04 的舞扇我加过 `hold` 淡出，
而且淡出乘的是 **scale 不是 alpha** → 每张卡开头「张开 → 又缩到 0」。
原作 `th07.lua:2259` 的 `fan` 是 `while true` 死循环，**一直张着到 boss 死亡**。

**C4. 预警线要够粗，alpha 不能为负。**
`Render(img, x, y, rot, hscale, vscale)` 的后两个是**缩放倍数**不是像素 ——
`white` 是 16×16，写 `0.06` → 不到 1 px，看不见。按像素给粗细用
`RenderRect(img, x1, x2, y1, y2)`。
亮度写成 `A * (0.4 + 0.6*sin(...))` 时 `sin` 有一半时间为负 → 那半圈什么都不画。
用**恒正**的形式（`0.55 + 0.45*sin(...)`）。

**C5. 拖影会让边缘亮很多。** `object.smear_add` 每帧存一份快照、
`smear_frame(dealpha)` 衰减（13 → 拖尾约 20 帧）、`smear_render` 画在底下。
**三个都要写**，漏 `smear_frame` 就是一直变亮。
密度要按**我们场地 384 宽**重算，不是照抄原作的 640。

---

## 10. 验证：跑不起游戏时怎么做

```bash
luajit tools/check_stage.lua mod/GAME/th20.lua        # 单关：注册检查 + 逐卡逐帧模拟
luajit tools/check_stage.lua mod/GAME/th20.lua 1800 --threat   # 加密度 / 难度分析
luajit tools/check_stage.lua --all                    # 全项目：按引擎顺序载入检查
```

用 `luajit`（5.1 语义），**别用 homebrew 的 `luac`**（那是 5.4，会把 5.1 风格的
代码报成假错）。环境变量：`STAGE_PROBE`（打每卡造了什么）、`STAGE_DEBUG`、
`STAGE_DUMP=<帧>`。

### 它查什么

- 注册：`boss.Define` / `boss.card.add` 的参数、`addAutoSPPoint` 阈值有没有超出本卡血量
- 运行：逐卡跑 N 帧，看有没有 Lua 报错
- **`--threat`**：机器人模拟自机，报 `★被打频率`、`60px 内弹数`、`★安全角度`、
  `★分区域`、`★难度场`、`死局 N 帧 (%)`
- **贴图名**：对象上设 `img` 时对资源池校验（见 A2）
- **`--all`** 里还有一条静态检查：`*_bg.lua` 必须能找到 `background.init(`

### 它查不出来（只能进游戏看）

**贴图名以外的观感问题、手感、演出效果、引擎侧的被弹/擦弹/结算。**
桩件是简化的：`Render` / `SetImageState` 是空函数，
所以「画出来长什么样」一概不验证。

### 五个必做的扫描

**① 泄漏扫描**（对象数随时间线性涨 = 漏回收）：

```bash
for f in 3600 7200; do luajit tools/check_stage.lua mod/GAME/th20.lua $f; done
# 同一张卡两次的「对象 / 弹」峰值应当一致；差得远就是漏
```

⚠ 关卡是 60 秒的，1800 帧（30 秒）还在爬升期，**要拿 3600 和 7200 比**。

**② 密度对表 —— 必须跑多种子。** 单跑一遍的数字**不可信**：`ran` 的相位一变，
「死局」能从 0.1% 跳到 12%（`th20` 实测）。自检现在**每张卡独立定种**
（`seed_rng(SEED_BASE + idx * 7919)`，见 `step_tasks` 上方），所以换 `STAGE_SEED`
就能量同一张卡的方差：

```bash
for sd in 20260916 11111 98765 55555 31415 777; do
    STAGE_SEED=$sd STAGE_PROBE=1 luajit tools/check_stage.lua mod/GAME/th20.lua 1200 --threat
done
# 取**最坏**那次的「死局%」和「同屏峰弹」做判断
```

判据：`死局 > 3%`（最坏种子）要改；`60px 内平均 < 5` 说明卡是空的；
**还要看 `峰值同屏 弹`** —— 用户说的「屏幕上没几颗子弹」量的是这个，
不是 `60px 内平均`（那一栏只统计自机脚边，自机站在远处时恒为 0）。

**③ 字段审计**（`nil` 和数字比较 / 运算这一类当场崩）：

```bash
luajit tools/check_fields.lua mod/GAME/th20.lua      # 单关
luajit tools/check_fields.lua $(ls mod/GAME/th*.lua) # 全项目
```

`check_stage.lua` **测不出这一类**：桩件太宽容，而且只有真走到那一行才会炸。
（它靠 `New` 的第一参加了一道运行期校验：第一参不是对象类就当场报 —— 引擎报的是
`invalid argument #1, luastg object class required for 'New'`。th04 第三版的 `th04_fandeco`
就是「换正文时删了类定义、调用还在」这么漏到真机上的，桩件当时会**静默造一个死对象**。）
`check_fields.lua` 静态地找「`frame`/`render` 里读了、但 `init` 顶层从没赋值」
的字段 —— 这类字段在真机上第一帧就是 `nil`。它认三种守卫：
`self.X or 默认值`、`if self.X then`、`self.X and`，也认**同一函数体内先赋值后使用**。
（所以守卫要**直接**写在 `self.X` 上：`local p = self.X; if not p then` 人看得懂，
审计器看不懂 —— 写成 `if not self.X then return end; local p = self.X`。）

**④ 威胁度 / 限位对表**（按《什么是好的弹设.md》实现，独立于自检）：

```bash
luajit tools/threat.lua mod/GAME/th04.lua 1800        # 全部卡
THREAT_CARDS=3,4 luajit tools/threat.lua …            # 只测某几张
THREAT_POS=0,-176 luajit tools/threat.lua …           # 把自机钉死在一点
```

文档的两条硬指标：**子弹总威胁度 0.5~1.5**、**同时作用威胁组数 1~2**，
外加「一张卡 = 至少一种限位 + 至少一种威胁」。报告里逐条给判定。

度量定义（工具头部注释写得更细）：
- 威胁度 = Σ_帧[自机位置会被打到] × (危险方向数/16)，换算成每秒。
  **奇数狙不计入「会被打到」的帧数**（不动的自机必中，微移就能躲），
  但它封死 16 方向里的 9 个 —— 所以它是**限位**，不是威胁。
- 安全方向 = 沿它量到最近一颗弹**表面**的距隙 > `5 + 自机判定半径`（自机半径取 1，
  6 px；弹半径取自 `LoadImageGroup` 末两参，见 check_stage 的 `STYLE_RADIUS`）。
- 参考自机**跟着限位做大范围移动、但不做微操**：当前格还安全就原地不动，
  不安全了才挪（限速 4 px/帧）。钉死在一点会对「安全区会移动」的卡严重高估；
  而完美躲避按定义恒等于 0 —— 两个极端都量不出东西。

实测（2026-09-17，第二版 th04 十张卡的对比见 `mod/GAME/th04.lua` 文件头）。

**⑤ 贴图名**：自检会自动报（A2）；报不出来时手动核对
`THlib/bullet/bulletStyle.lua`（弹样式）、`Resources/Special/`（主题贴图）、
`Resources/BossBackGround/`（背景纹理）。

---

## 11. 速查表

| 想做的事 | 用什么 |
|---|---|
| 造直线弹 | `NewSimpleBullet(style, col, x, y, v, a[, aim, omiga, stay, destroyable, rebound, through, frame, render])` |
| 造自定义轨迹弹 | 同上，末位传 `frame` 钩子；或 `Class(bullet, {...})` 自己 `RawDel` |
| 造纯演出物件 | `Class(object, {...}, true)`，`card:del` 里清掉 |
| **造会挡路的实体** | `Class(enemy, {...})` + `enemy.init(self, style, hp, false, false, false)` + `object.Connect(boss, self, 0, true)` |
| 弹样式名 / 颜色 | `THlib/bullet/bulletStyle.lua`；`COLOR.*` 1..16 |
| 挂机移动 | `task.MoveTo(x,y,t,mode)`、`task.CRMoveTo(t,mode,…)` |
| **boss 贴着自机** | `task.MoveToPlayer(t, x1,x2, y1,y2, dxmin,dxmax, dymin,dymax, mmode, dmode)`（注意第一个参数是**时长**） |
| 并行发弹循环 | `task.New(self, function() while true do … task.Wait(n) end end)` |
| 血量驱动的多阶段 | `self._bosssys:addAutoSPPoint(掉血量, 兜底帧, true)` + 读 `self._sp_point_auto` |
| 圆形 / 星形 / 心形排布 | `sp.math.AngleIterator / EllipseIterator / HeartIterator / PolygonIterator` |
| 直线上切点 / 贝塞尔 | `sp:GetPointLine(t, …)` / `sp:GetPointBezier(t, mode, …)` |
| 画图形（无判定） | `SetImageState("white", "mul+add", a,r,g,b)` + `Render` / `RenderRect` / `Render4V` |
| 画环 / 扇形 / 平铺 | `misc.RenderRing` / `misc.SectorRender` / `misc.RenderTexInRect` / `misc.PolarCoordinatesRender` |
| 符卡背景 | `class["SCBG"] = Class(_SC_BG)` + `_SC_BG.AddLayer(...)`，贴图 `Resources/BossBackGround/th*.png` |
| 拖影 | `object.smear_add(o,a)` + `smear_frame(o,13)` + `smear_render(o,"mul+add",{r,g,b})`（三个都要） |
| 全屏白闪 / 转场 | `New(WhiteScreen, LAYER.TOP, 30)` |
| 自机坐标 | `player.x` / `player.y`（**只在 7.8 那四种软场里动它**） |
| 世界边界 | `lstg.world.l/r/b/t`（可视区）、`boundl/r/b/t`（±32 的回收边界） |
