#!/usr/bin/env python3
"""核心无损、PNG透明路径、非核心有损白名单和缓存契约。"""
from pathlib import Path
import importlib.util
import struct
import sys
import tempfile
import numpy as np
from PIL import Image, PngImagePlugin
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
spec=importlib.util.spec_from_file_location('asset_optimizer',Path(__file__).resolve().parents[1]/'asset_optimizer.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
with tempfile.TemporaryDirectory() as temp:
    root=Path(temp);opaque=root/'opaque.png';transparent=root/'transparent.png'
    im=Image.new('RGBA',(256,256),(21,128,240,255));im.save(opaque,compress_level=0)
    im.putpixel((20,20),(10,90,120,0))
    chunks=PngImagePlugin.PngInfo();chunks.add(b'gAMA',struct.pack('>I',45455))
    im.save(transparent,compress_level=0,pnginfo=chunks)
    variants,records=m.optimize_images([opaque,transparent],root/'cache')
    assert opaque in variants and transparent in variants
    assert variants[transparent].suffix=='.png','核心透明图继续使用PNG预乘路径'
    for source in (opaque,transparent):
        with Image.open(source) as a,Image.open(variants[source]) as b:assert a.convert('RGBA').tobytes()==b.convert('RGBA').tobytes()
    assert [c for k,c in m.png_chunks(transparent.read_bytes()) if k!=b'IDAT']==[c for k,c in m.png_chunks(variants[transparent].read_bytes()) if k!=b'IDAT']
    again,other=m.optimize_images([opaque,transparent],root/'cache')
    assert variants==again and records==other
    background=root/'mod/BG/TH10/TH10_bg_test.png';background.parent.mkdir(parents=True)
    core=root/'THlib/player/Reimu.png';core.parent.mkdir(parents=True)
    photo=Image.fromarray(np.random.default_rng(17).integers(0,256,(32,32,3),dtype=np.uint8)).resize((256,256),Image.Resampling.BICUBIC).convert('RGBA')
    photo.putalpha(Image.linear_gradient('L').resize((256,256)))
    photo.save(background);photo.save(core)
    lossy,report=m.optimize_images([background,core],root/'mixed-cache',root,True)
    assert report[background]['codec']=='png-rgb5' and report[background]['lossy']
    assert report[background]['format']=='png','非核心透明图也保持原生PNG混合路径'
    assert report[core]['core'] and not report[core]['codec'].startswith('webp-q')
    with Image.open(lossy[background]) as packed:assert packed.getchannel('A').tobytes()==photo.getchannel('A').tobytes()
    with Image.open(lossy.get(core,core)) as packed:assert packed.convert('RGBA').tobytes()==photo.tobytes()
    from image_policy import noncore_category
    for path in ('THlib/UI/font/score.png','THlib/UI/life.png','THlib/bullet/img/bullet5.png','Resources/Original/10/stgenm06_0.png','Resources/Original/8/eff09al_1.png','unknown.png'):
        assert noncore_category(path) is None,path
    opaque_bg=background.with_name('TH10_bg_opaque.png');photo.convert('RGB').save(opaque_bg)
    variants,report=m.optimize_images([opaque_bg],root/'opaque-cache',root,True)
    assert report[opaque_bg]['codec'].startswith('webp-q') and report[opaque_bg]['visible_rgb_psnr_db']>=36
print('核心RGBA无损、透明PNG色彩块、非核心有损白名单/Alpha/误差及缓存检查通过')
