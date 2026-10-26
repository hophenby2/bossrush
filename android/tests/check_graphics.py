#!/usr/bin/env python3
"""验收 graphics 诊断画面的实际像素；支持 1200×540 及同比例超宽屏。"""
from pathlib import Path
import sys
from PIL import Image

im = Image.open(sys.argv[1]).convert('RGB')
k = im.width / 1200
assert abs(im.height / 540 - k) < .01, im.size
checks = []
palette = [(255,0,0),(0,255,0),(0,0,255),(0,255,255),(255,0,255),(255,255,0)]
for row in range(8):
    for col in range(12):
        checks.append((140+(col+.5)*220/12, 90+(row+.5)*45, palette[(row%2)*3+col%3]))
checks += [(504,158,palette[0]),(696,158,palette[1]),(504,382,palette[2]),(696,382,palette[5])]
for x,y in [(400,60),(800,60),(500,40),(700,500),(400,480),(800,480),(390,270),(810,270)]:
    checks.append((x,y,(0,0,0)))
checks.append((960,190,(180,60,220)))
failures=[]
for x,y,expected in checks:
    pixel=im.getpixel((round(x*k),round(y*k)))
    if max(abs(a-b) for a,b in zip(pixel,expected)) > 2:
        failures.append(f'({x:.1f},{y:.1f}) expected={expected} actual={pixel}')
assert not failures, '\n'.join(failures)
print(f'通过 {len(checks)} 个 GPU 像素检查：NPOT 多周期平铺、宽屏 RT 位置/裁剪、2D→3D→UI 切换；{im.width}×{im.height}')
