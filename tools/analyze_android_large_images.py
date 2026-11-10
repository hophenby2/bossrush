#!/usr/bin/env python3
"""只分析非战斗核心大图；候选编码只在内存生成，不改源图或APK。"""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import hashlib
import io
import json
from pathlib import Path
import re
import zipfile
import zlib

import numpy as np
from PIL import Image


def category(path):
    if path.startswith('THlib/UI/'):
        return '菜单与界面'
    if path.startswith('Resources/Special/') and path.endswith('_player_tachie.png'):
        return '菜单角色立绘'
    if re.fullmatch(r'mod/GAME/stage_pic(?:29|30|31|32|33)\.png', path):
        return '五作关卡预览'
    if path.startswith('Resources/BossBackGround/'):
        return '符卡背景'
    if path.startswith('mod/BG/'):
        return '道中背景'
    if path.startswith('Resources/Original/') and re.match(r'(stg\d+bg|stage\d+_|world\d+_)', Path(path).name):
        return '原作场景纹理'
    if path == 'mod/th16AEX.png':
        return '框架仍载入的旧入口图'
    return None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apk', type=Path, required=True)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--min-kib', type=int, default=256)
    args = parser.parse_args()
    candidates, excluded = [], []
    with zipfile.ZipFile(args.apk) as apk:
        variants = dict(re.findall(r'\["(.*?)"\]="(.*?)"', apk.read('assets/game/asset_variants.lua').decode()))
        for folder in ('THlib', 'Resources', 'mod'):
            for source in (args.root/folder).rglob('*.png'):
                logical = source.relative_to(args.root).as_posix()
                native = variants.get(logical, logical)
                info = apk.getinfo('assets/game/'+native)
                if info.compress_size < args.min_kib*1024:
                    continue
                kind = category(logical)
                row = {'path':logical, 'category':kind, 'source_bytes':source.stat().st_size,
                       'apk_bytes':info.compress_size, 'current_format':Path(native).suffix[1:]}
                if kind:
                    candidates.append(row)
                else:
                    excluded.append(row)

    def measure(row):
        source = args.root/row['path']
        original = source.read_bytes()
        with Image.open(io.BytesIO(original)) as image:
            rgba = image.convert('RGBA')
            pixels = np.asarray(rgba).astype('float32')
            row.update(width=rgba.width, height=rgba.height,
                       gpu_rgba8_bytes=rgba.width*rgba.height*4,
                       rgba_sha256=hashlib.sha256(rgba.tobytes()).hexdigest(),
                       source_sha256=hashlib.sha256(original).hexdigest())
            row['candidates'] = {}
            lossless = io.BytesIO()
            rgba.save(lossless, format='WEBP', lossless=True, method=6, exact=True)
            compressor = zlib.compressobj(6,zlib.DEFLATED,-15)
            packed = compressor.compress(lossless.getvalue())+compressor.flush()
            with Image.open(io.BytesIO(lossless.getvalue())) as decoded:
                exact = decoded.convert('RGBA').tobytes() == rgba.tobytes()
            row['candidates']['lossless'] = {'apk_bytes_estimate':len(packed),
                'saved_bytes_estimate':max(0,row['apk_bytes']-len(packed)) if exact else 0,
                'rgba_exact':exact}
            for quality in (90, 85):
                encoded = io.BytesIO()
                rgba.save(encoded, format='WEBP', quality=quality, method=6, exact=True)
                data = encoded.getvalue()
                compressor = zlib.compressobj(6,zlib.DEFLATED,-15)
                packed = compressor.compress(data)+compressor.flush()
                with Image.open(io.BytesIO(data)) as decoded:
                    result = np.asarray(decoded.convert('RGBA')).astype('float32')
                error = (pixels[:,:,:3]-result[:,:,:3])*(pixels[:,:,3:4]/255)
                mse = float(np.mean(error**2))
                row['candidates'][str(quality)] = {
                    'apk_bytes_estimate':len(packed),
                    'saved_bytes_estimate':max(0,row['apk_bytes']-len(packed)),
                    'visible_rgb_psnr_db':round(10*np.log10(255**2/mse),2) if mse else None,
                    'alpha_exact':bool(np.array_equal(pixels[:,:,3],result[:,:,3]))}
        assert source.read_bytes() == original, source
        return row

    with ThreadPoolExecutor(max_workers=4) as pool:
        rows = sorted(pool.map(measure,candidates),key=lambda r:r['apk_bytes'],reverse=True)
    totals = Counter()
    for row in rows:
        totals['source_bytes'] += row['source_bytes']
        totals['current_apk_bytes'] += row['apk_bytes']
        for quality, data in row['candidates'].items():
            totals[quality+'_saved_bytes_estimate'] += data['saved_bytes_estimate']
    report = {'baseline_apk':str(args.apk), 'minimum_apk_bytes':args.min_kib*1024,
              'mode':'只分析；不写回图片，不改APK，不改变尺寸',
              'scope':'界面、菜单立绘、关卡预览、场景及符卡背景；排除弹图、自机/Boss行走图和ANM效果图集',
              'candidate_count':len(rows), 'totals':dict(totals),
              'images':rows, 'excluded_large_images':sorted(excluded,key=lambda r:r['apk_bytes'],reverse=True)}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'count':len(rows),'totals_mib':{k:round(v/1048576,3) for k,v in totals.items()},
                      'output':str(args.output)},ensure_ascii=False))


if __name__ == '__main__':
    main()
