#!/usr/bin/env python3
"""把 Lua 导出逻辑与原始 C# 的 2332 次发弹结果逐字段对照。"""
import math,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
actual=subprocess.check_output(['luajit',str(Path(__file__).with_name('check_spring_source.lua'))],cwd=ROOT,text=True).splitlines()
expected=(Path(__file__).parent/'oracle/spring.tsv').read_text().splitlines()
assert len(actual)==len(expected),(len(actual),len(expected))
for i,(a,b) in enumerate(zip(actual,expected),1):
 av,bv=list(map(float,a.split())),list(map(float,b.split()))
 assert len(av)==len(bv)
 for j,(x,y) in enumerate(zip(av,bv),1):assert math.isclose(x,y,rel_tol=1e-6,abs_tol=1e-6),(i,j,x,y)
print('原始 C# 对照：2332 次发弹的坐标、切片、速度、角度、伤害和缩放全部相符')
