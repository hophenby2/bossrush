#!/usr/bin/env python3
"""把 Crazy Storm 的 b<id>.xna 弹幕数据解析成可读规格，供手工移植到 Lua 用。

字段顺序来自 `src-decompiled-raw/THMHJ/CrazyStorm.cs:229-352` 的解析器
（按逗号下标取字段），不是猜的。

  python3 tools/thmhj_dump.py 651          # 看某张卡
  python3 tools/thmhj_dump.py 651 -v       # 连事件组一起打
"""
import sys, os, subprocess, re

SRC = "/Users/happyelements/crack/THMHJ.PartII.Restored/src/THMHJ/bin/x86/Debug/net461/Content/Data"
K2 = "4D3C3F50123A4577898C758F7E9E1187"

# 字段表：下标 → 名字（CrazyStorm.cs 的 Batch 构造）
BATCH_FIELDS = [
    "id", "parentid", "Binding", "bindid", "Bindwithspeedd", "_空",
    "x", "y", "begin", "life", "fx", "fy", "r", "rdirection", "rdirections",
    "tiao", "t", "fdirection", "fdirections", "range", "speed", "speedd", "speedds",
    "aspeed", "aspeedd", "aspeedds", "sonlife", "type", "wscale", "hscale",
    "colorR", "colorG", "colorB", "alpha", "head", "heads", "Withspeedd",
    "sonspeed", "sonspeedd", "sonspeedds", "sonaspeed", "sonaspeedd", "sonaspeedds",
    "xscale", "yscale", "Mist", "Dispel", "Blend", "Afterimage", "Outdispel",
    "Invincible", "_父事件组", "_子事件组",
    "rand.fx", "rand.fy", "rand.r", "rand.rdirection", "rand.tiao", "rand.t",
    "rand.fdirection", "rand.range", "rand.speed", "rand.speedd", "rand.aspeed",
    "rand.aspeedd", "rand.head", "rand.sonspeed", "rand.sonspeedd",
    "rand.sonaspeed", "rand.sonaspeedd",
    "Cover", "Rebound", "Force", "Deepbind",
]

# 只在这些下标上打印（其余是随机器/不常用的）
SHOW = ["id", "parentid", "Binding", "bindid", "Bindwithspeedd", "Deepbind", "x", "y", "begin", "life", "fx", "fy", "r", "rdirection", "tiao", "t", "fdirection",
        "range", "speed", "speedd", "aspeed", "type", "wscale", "hscale", "alpha",
        "sonlife", "sonspeed", "colorR", "colorG", "colorB",
        "aspeed", "aspeedd", "sonaspeed", "sonaspeedd"]
SHOW_IDX = {BATCH_FIELDS.index(k): k for k in SHOW if k in BATCH_FIELDS}


GLOBAL = []
def load_global():
    """全局弹型表：Content/Data/3.xna（恰好 228 项，CSManager.cs:227）"""
    f = os.path.join(os.path.dirname(__file__), "..", "mod", "GAME", "THMHJ", "global_types.txt")
    dec = "/tmp/dec/3.xna.dec"
    if os.path.exists(f):
        src = open(f, encoding="utf-8").read()
    elif os.path.exists(dec):
        src = open(dec, encoding="utf-8").read()
    else:
        return []
    return [l.split("_")[0] for l in src.split("\n") if l.strip()]


def sprite_of(t, types):
    """批次的 type → 贴图名。`Batch.cs:1638`：发出去的子弹是 `type - 1`；
    再按 `type < 228 ? 全局[type] : 本卡[type-228]` 取（Barrage.cs:1625）。"""
    t = t - 1
    if t < 0:
        return "(不可见)"
    if t < 228:
        return GLOBAL[t] if t < len(GLOBAL) else "?%d" % t
    i = t - 228
    return types[i]["name"] if i < len(types) else "?%d" % t


def decrypt(src, dst):
    k = K2 + K2[:16]
    subprocess.run(["openssl", "enc", "-des-ede3", "-d", "-K", k,
                    "-in", src, "-out", dst], capture_output=True)
    return os.path.exists(dst)


def load(bid):
    dec = "/tmp/dec/b%s.xna.dec" % bid
    if not os.path.exists(dec):
        if not decrypt(os.path.join(SRC, "b%s.xna" % bid), dec):
            raise SystemExit("解密失败 b%s" % bid)
    return open(dec, "rb").read().decode("utf-8", "replace").split("\n")


def parse(bid, verbose):
    global GLOBAL
    if not GLOBAL:
        GLOBAL = load_global()
    lines = [l.rstrip("\r") for l in load(bid)]
    it = iter(lines)
    pending = []
    title = next(it)
    assert title.startswith("Crazy Storm Data"), title

    types = []
    t = next(it)
    if "Types" in t:
        for _ in range(int(t.split(" ")[0])):
            p = next(it).split("_")
            types.append({"name": p[0], "rect": tuple(int(x) for x in p[1:5]),
                          "org": tuple(int(x) for x in p[5:7])})
        t = next(it)
    # 可选段：GlobalEvents / Sounds —— 顺序不固定，按关键词跳过（见 CrazyStorm.cs:139-192）
    while "Events" in t or "Sounds" in t:
        for _ in range(int(t.split(" ")[0])):
            next(it)
        t = next(it)
    print("== b%s ==" % bid)
    print("  Center: %s" % t.split(":", 1)[1][:80])
    t = next(it)
    print("  Totalframe: %s" % t.split(":", 1)[1])
    print("  Types(%d): %s" % (len(types), " ".join(x["name"] for x in types)))

    for _ in range(4):
        hdr = pending.pop(0) if pending else next(it)
        try:
            val = hdr.split(":", 1)[1]
        except IndexError:
            continue
        if val.split(",")[0] == "empty":
            continue
        f = val.split(",")
        print("\n  --- %s  begin=%s end=%s 批次数=%s ---" % (hdr.split(":")[0], f[1], f[2], f[3]))
        for _ in range(int(f[3])):
            p = next(it).split(",")
            if len(p) < 52:
                continue
            info = []
            for idx in sorted(SHOW_IDX):
                if idx < len(p):
                    info.append("%s=%s" % (SHOW_IDX[idx], p[idx]))
            tn = sprite_of(int(float(p[27])), types)
            print("    [%s] %s  贴图=%s" % (p[0], " ".join(info), tn))
            if verbose and len(p) > 51 and p[51]:
                for grp in p[51].split("&"):
                    if not grp:
                        continue
                    g = grp.split("|")
                    if len(g) < 4:
                        continue
                    print("        父事件组 t=%s add=%s :" % (g[1], g[2]))
                    for ev in g[3].split(";"):
                        if ev:
                            print("           · %s" % ev)
        # 一个 Layer 段里批次之后还有 Lase/Cover/Rebound/Force 数组，
        # 数量在表头的 [4]..[7]。本工具只看批次，直接跳到下一个 Layer。
        while True:
            try:
                nxt = next(it)
            except StopIteration:
                break
            if nxt.lstrip().startswith("Layer") or "," in nxt and nxt.split(",")[0] == "empty":
                pending.append(nxt)
                break
    return types


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    parse(sys.argv[1], "-v" in sys.argv)
