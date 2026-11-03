#!/usr/bin/env python3
"""按Sub的加色饱和、顶点透明度和雾混合口径验收真实GPU像素。"""
import sys
from PIL import Image

image = Image.open(sys.argv[1]).convert('RGB')
# UI内容区为960×540；超宽屏在左右各有同样宽的留边。
scale = image.height / 540
offset = (image.width - 960 * scale) / 2
failures = []
index = 0
for fog in range(4):
    for blend in ('add+alpha', 'add+add'):
        for alpha in (0, 64, 128, 255):
            # 纯白纹理+正顶点RGB先饱和为白，再混雾，最后按源alpha混合。
            source = (255, 255, 255) if fog == 0 else (143.5, 159.5, 175.5)
            a = alpha / 255
            expected = [round(min(255, s * a + d * (1 - a if blend == 'add+alpha' else 1)))
                        for s, d in zip(source, (20, 40, 60))]
            x, y = offset + (28.5 + index * 29) * scale, (540 - 20) * scale
            pixel = image.getpixel((round(x), round(y)))
            if max(abs(actual - target) for actual, target in zip(pixel, expected)) > 3:
                failures.append(f'fog={fog} {blend} alpha={alpha}: expected={expected}, actual={pixel}')
            index += 1
assert not failures, '\n'.join(failures)
print(f'通过 {index} 个GPU像素检查：加色饱和、透明/半透明、加法与alpha混合、线性/指数/平方指数雾')
