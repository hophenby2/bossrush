#!/usr/bin/env python3
"""无损编码、透明图保留和构建缓存契约。"""
from pathlib import Path
import importlib.util
import tempfile
from PIL import Image
spec=importlib.util.spec_from_file_location('asset_optimizer',Path(__file__).resolve().parents[1]/'asset_optimizer.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
with tempfile.TemporaryDirectory() as temp:
    root=Path(temp);opaque=root/'opaque.png';transparent=root/'transparent.png'
    im=Image.new('RGBA',(256,256),(21,128,240,255));im.save(opaque,compress_level=0)
    im.putpixel((20,20),(10,90,120,0));im.save(transparent,compress_level=0)
    variants,records=m.optimize_images([opaque,transparent],root/'cache')
    assert opaque in variants and transparent not in variants
    with Image.open(opaque) as a,Image.open(variants[opaque]) as b:assert a.convert('RGBA').tobytes()==b.convert('RGBA').tobytes()
    again,other=m.optimize_images([opaque,transparent],root/'cache')
    assert variants==again and records==other
print('不透明贴图逐像素一致、透明图保留PNG及优化缓存检查通过')
