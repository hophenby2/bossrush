#!/usr/bin/env python3
"""把 Crazy Storm 的 `b<id>.xna` 直接翻译成 `run_cs` 的批次表（Lua 源码）。

**为什么要有这个工具**：一张卡是 20~40 个批次 × 40 个字段。靠手抄进 Lua，
一定会抄错几处，而错了以后只能靠眼睛在游戏里看 —— 反复「还是不对」就是这么来的。
这里把「数据 → Lua」做成机械变换，手写的只剩运行时的语义（`run_cs`），
而运行时语义是能从 C# 一次读懂、一次写对的。

用法：
    python3 tools/thmhj_tolua.py 660 --sprite 226=S_beam,240=S_jin,257=S_bigfan,261=S_sakura \\
        --sprite 139=S_b138,141=S_b140,152=S_dot
输出直接贴进关卡文件（本仓库没有 dofile/require，一切自包含）。

生成出来的字段与 `run_cs` 的约定一一对应，详见关卡文件里的 `run_cs` 注释。
角度**一律取负**（`CA()`）：Crazy Storm 是 XNA，`+y 向下`、角度顺时针为正；
LuaSTG 是 `+y 向上`、逆时针为正。少这一步整张卡上下镜像、左右手性全反。
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import thmhj_dump as D  # noqa: E402  复用解密 / 字段表 / 贴图名

F = D.BATCH_FIELDS


def idx(name):
    return F.index(name)


# ── 属性名 → run_cs 的键 ────────────────────────────────────────────
#   两张表不一样：父事件改**批次**，子事件改**发出去的每颗子弹**
#   （`Batch.cs:408-452` 的 results / `Barrage.cs:487-501` 的 results）。
BATCH_ATTR = {
    "半径": "r", "半径方向": "rd", "条数": "tiao", "周期": "t",
    "角度": "fa", "范围": "spread", "速度": "speed", "速度方向": "sd",
    "加速度": "aspeed", "加速度方向": "aspeedd", "生命": "life", "类型": "type",
    "宽比": "sw", "高比": "sh", "R": "cr", "G": "cg", "B": "cb",
    "不透明度": "alpha", "朝向": "head",
    "子弹速度": "v", "子弹加速度": "sonaspeed", "子弹加速度方向": "sonaspeedd",
    "横比": "xs", "纵比": "ys",
}
BULLET_ATTR = {
    "生命": "life", "类型": "type", "宽比": "w", "高比": "h",
    "R": "r", "G": "g", "B": "b", "不透明度": "alpha", "朝向": "rot",
    "子弹速度": "speed", "子弹速度方向": "dir",
    "子弹加速度": "aspeed", "子弹加速度方向": "aspeedd", "横比": "xs", "纵比": "ys",
}
# 角度类属性：值要取负（见文件头）
ANGLE_KEYS = {"rd", "fa", "head", "dir", "rot", "aspeedd", "sd"}
# 纯碰撞/免疫类，画面上看不出来，直接跳过
SKIP_ATTR = {"无敌状态", "判定"}

VERB = {"变化到": 0, "增加": 1, "减少": 2}
MODE = {"正比": 0, "固定": 1, "正弦": 2}


def num(s):
    """`55` / `-3.5` / `0.01` → float；整数值保留整数写法，生成的 Lua 更短。"""
    v = float(s)
    return int(v) if v == int(v) else round(v, 4)


class Batch:
    def __init__(self, p):
        self.p = p
        self.f = {n: p[i] for i, n in enumerate(F) if i < len(p)}

    def g(self, name, cast=float):
        v = self.f.get(name)
        if v is None:
            return cast(0)
        return cast(v)


def parse_events(raw, table, warn, where):
    """`a|t|addtime|ev;ev;ev&b|t|addtime|ev` → [ {at, every, key, how, mode, v, rand, frames} ]"""
    out, extra = [], False
    if not raw:
        return out, extra
    for grp in raw.split("&"):
        if not grp:
            continue
        g = grp.split("|")
        if len(g) < 4:
            continue
        gt, gadd = int(g[1]), int(g[2])
        for ev in g[3].split(";"):
            ev = ev.strip()
            if not ev:
                continue
            if "额外发射" in ev:
                # 「发射」→ `special=2` → `Shoot()`（`Time.cs:409-412`）。
                # 条件是 `当前帧=1`，组 `t=1 add=0` → 只在第 1 帧多打一轮。
                extra = True
                continue
            if "恢复" in ev:
                # 「恢复」→ `special=1` → `Recover()`：把批次字段复位成原始数据。
                # 循环回卷时我们本来就整表复位，等价，忽略。
                continue
            m = re.match(r"^当前帧\s*(=|>|<)\s*([\-\d.]+)\s*[：:]\s*(.+)$", ev)
            if not m:
                warn("%s 认不出的条件：%s" % (where, ev))
                continue
            at = num(m.group(2))
            body = m.group(3)
            parts = body.split("，")
            if len(parts) < 3:
                warn("%s 事件字段不足：%s" % (where, ev))
                continue
            action, howtxt, frametxt = parts[0], parts[1], parts[2]
            # 动词在属性名**后面**（`速度增加3` / `半径方向减少360` / `不透明度变化到30+10`），
            # 所以是「找到动词、切两半」，不是 startswith。
            how = mode = None
            attr, valtxt = None, None
            for k, v in VERB.items():          # 「变化到」必须排在「化到」之前，dict 顺序已保证
                pos = action.find(k)
                if pos >= 0:
                    how, attr, valtxt = v, action[:pos], action[pos + len(k):]
                    break
            for k, v in MODE.items():
                if k in howtxt:
                    mode = v
                    break
            if how is None or mode is None:
                warn("%s 认不出的动词/方式：%s" % (where, ev))
                continue
            fm = re.search(r"(-?[\d.]+)", frametxt)
            frames = num(fm.group(1)) if fm else 0
            # `0+15` → 基准 0、随机 ±15
            if "+" in valtxt:
                a, b = valtxt.split("+", 1)
                v, rand = (num(a) if a.strip() else 0), num(b)
            else:
                v, rand = num(valtxt), None
            if how == 2:            # 「减少 N」 等价于 「增加 -N」
                v, how = -v, 1
            key = table.get(_strip_attr(attr))
            if key is None:
                if _strip_attr(attr) in SKIP_ATTR:
                    continue
                warn("%s 没登记属性 %r：%s" % (where, _strip_attr(attr), ev))
                continue
            if key in ANGLE_KEYS:
                v = -v
            spec = {"at": at, "key": key, "how": how, "mode": mode, "v": v, "frames": frames}
            if rand:
                spec["rand"] = rand
            # 组的 `addtime` = 每循环条件右移多少 → 就是事件的重复间隔。
            # 条件也因此变成 at + n*every（`Batch.cs:465-468`）。
            if gadd > 0:
                spec["every"] = gadd
            out.append(spec)
    return out, extra


def _strip_attr(action):
    """`半径方向增加55` 已经切掉了动词，这里再兜一层空白/`自身`/`自机`。"""
    a = action.strip()
    for k in ("自身", "自机"):
        if k in a:
            a = a.replace(k, "")
    return a.strip()


# ── 字段 → Lua 片段 ────────────────────────────────────────────────
def angle(v):
    v = num(v)
    return "CA(%s)" % v if v else "0"


def lua_events(specs, indent):
    if not specs:
        return None
    pad = " " * indent
    one = []
    for s in specs:
        kv = ["at=%s" % s["at"], 'key="%s"' % s["key"], "how=%s" % s["how"],
              "mode=%s" % s["mode"], "v=%s" % s["v"]]
        if "rand" in s:
            kv.append("rand=%s" % s["rand"])
        kv.append("frames=%s" % s["frames"])
        if "every" in s:
            kv.append("every=%s" % s["every"])
        one.append("%s{ %s }" % (pad + "    ", ", ".join(kv)))
    return "{\n" + ",\n".join(one) + ",\n" + pad + "}"


def emit_batch(b, sprites, warn, where):
    x, y = float(b.g("x")), float(b.g("y"))
    fx, fy = float(b.g("fx")), float(b.g("fy"))
    out = []
    add = out.append

    add("id=%d" % int(b.g("id")))
    add("bind=%d" % int(b.g("bindid")))
    add("begin=%d" % int(b.g("begin")))
    add("life=%d" % int(b.g("life")))
    add("t=%d" % int(b.g("t")))
    add("tiao=%d" % int(b.g("tiao")))

    # 出弹锚点：**只有根批次**用它，子弹落在 (fx,fy)（`Batch.cs:1637`）。
    # 哨兵 -99999 = 自机、-99998 = 批次自身 x−4 / y+16（`Time.cs:79-90`）。
    # ⚠ 炮塔（bindid != -1）的出弹点是**载体**的位置，自己的 x/y 只用来算子弹的
    #   `fx/fy`（子事件的瞄准原点），不写出来免得看着像锚点。
    if int(b.g("bindid")) < 0:
        if fx == -99999:
            add("fxp=true")
        elif fx == -99998:
            add("ax=CX(%s - 4)" % num(x))
        else:
            add("ax=CX(%s)" % num(fx))
        if fy == -99999:
            add("fyp=true")
        elif fy == -99998:
            add("ay=CY(%s + 16)" % num(y))
        else:
            add("ay=CY(%s)" % num(fy))

    add("r=%s" % num(b.g("r")))
    add("rd=%s" % angle(b.g("rdirection")))
    add("fa=%s" % angle(b.g("fdirection")))
    add("spread=%s" % num(b.g("range")))
    add("speed=%s" % num(b.g("speed")))
    add("sd=%s" % angle(b.g("speedd")))
    add("v=%s" % num(b.g("sonspeed")))          # 子弹速度 = sonspeed
    if num(b.g("aspeed")):
        add("aspeed=%s" % num(b.g("aspeed")))
    add("sw=%s" % num(b.g("wscale")))
    add("sh=%s" % num(b.g("hscale")))
    add("head=%s" % angle(b.g("head")))
    if b.g("Withspeedd", str) == "True":
        add("wsd=true")
    add("cr=%d" % int(b.g("colorR")))
    add("cg=%d" % int(b.g("colorG")))
    add("cb=%d" % int(b.g("colorB")))
    add("alpha=%s" % num(b.g("alpha")))
    add("sonlife=%d" % int(b.g("sonlife")))
    if float(b.g("xscale")) != 1:
        add("xs=%s" % num(b.g("xscale")))
    if float(b.g("yscale")) != 1:
        add("ys=%s" % num(b.g("yscale")))
    for flag, key in (("Mist", "mist"), ("Dispel", "dispel"),
                      ("Outdispel", "outdispel"), ("Invincible", "invincible")):
        if b.g(flag, str) == "True":
            add(key + "=true")

    t = int(b.g("type"))
    if t <= 0:
        add("invisible=true")                    # type-1 < 0 → 不画（`Barrage.cs` 早退）
    else:
        name = sprites.get(t)
        if name is None:
            warn("%s 贴图 type=%d（%s）没给映射，已置 `spr=nil`"
                 % (where, t, D.sprite_of(t, [])))
            add("spr=nil")
        else:
            add("spr=%s" % name)

    pev, extra = parse_events(b.f.get("_父事件组"), BATCH_ATTR, warn, where + " 父")
    sev, sextra = parse_events(b.f.get("_子事件组"), BULLET_ATTR, warn, where + " 子")
    if extra or sextra:
        add("extra=true")
    if pev:
        add("evspec=" + lua_events(pev, 8))
    if sev:
        add("sevspec=" + lua_events(sev, 8))
    if b.g("Deepbind", str) == "True":
        warn("%s 用了 Deepbind 克隆体，run_cs 还没实现，这一批会退化成普通炮塔" % where)
    return "{ " + ", ".join(out) + " }"


# ── 读数据 ────────────────────────────────────────────────────────
def layers(bid):
    D.GLOBAL = D.load_global()
    it = iter([l.rstrip("\r") for l in D.load(bid)])
    next(it)                                     # "Crazy Storm Data"
    types, t = [], next(it)
    if "Types" in t:
        for _ in range(int(t.split(" ")[0])):
            p = next(it).split("_")
            types.append({"name": p[0]})
        t = next(it)
    while "Events" in t or "Sounds" in t:
        for _ in range(int(t.split(" ")[0])):
            next(it)
        t = next(it)
    next(it)                                     # Center: ...
    t = next(it)                                 # Totalframe: ...
    out, pending, hdr = [], [], t
    for _ in range(4):
        hdr = pending.pop(0) if pending else hdr
        f = hdr.split(":", 1)[1].split(",")
        if f[0] == "empty":
            continue
        bs = []
        for _ in range(int(f[3])):
            p = next(it).split(",")
            if len(p) >= 52:
                bs.append(Batch(p))
        out.append((f[1], f[2], bs))
        while True:                              # 跳过 Lase/Cover/Rebound/Force
            try:
                nxt = next(it)
            except StopIteration:
                break
            if nxt.lstrip().startswith("Layer") or nxt.split(",")[0] == "empty":
                pending.append(nxt)
                break
    return types, out


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    bid = sys.argv[1]
    sprites = {}
    for i, a in enumerate(sys.argv):
        if a == "--sprite":
            for kv in sys.argv[i + 1].split(","):
                k, v = kv.split("=")
                sprites[int(k)] = v
    warns = []

    def warn(m):
        warns.append(m)

    _, ls = layers(bid)
    print("        --★ 以下由 `tools/thmhj_tolua.py %s` 从原版数据生成，**不要手改**" % bid)
    print("        --   要改请改生成器再重跑；手抄 40 字段 × N 批次一定会出错。")
    print("        local CS = {")
    for li, (beg, end, bs) in enumerate(ls, 1):
        print("            {   -- Layer%d（begin=%s end=%s）" % (li, beg, end))
        for b in bs:
            where = "b%s L%d id%s" % (bid, li, b.g("id"))
            print("                " + emit_batch(b, sprites, warn, where) + ",")
        print("            },")
    print("        }")
    for w in warns:
        print("-- warn: " + w, file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
