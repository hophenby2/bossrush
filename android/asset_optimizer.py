"""安卓入包图片优化：核心像素无损，非核心白名单允许有损，源PNG不改。"""
from concurrent.futures import ThreadPoolExecutor
import hashlib
import io
import json
import shutil
import struct
import zlib
from image_policy import noncore_category


def zip_size(data):
    compressor = zlib.compressobj(6, zlib.DEFLATED, -15)
    return len(compressor.compress(data) + compressor.flush())


def png_chunks(data):
    offset = 8
    while offset < len(data):
        length = struct.unpack('>I', data[offset:offset+4])[0]
        chunk = data[offset:offset+length+12]
        yield chunk[4:8], chunk
        offset += length+12


def recompress_png(image, original):
    # 只替换IDAT；保留IHDR、色表、透明度、色彩配置等全部原始块。
    encoded = io.BytesIO()
    image.save(encoded, format='PNG', optimize=True, compress_level=9)
    replacement = encoded.getvalue()
    if replacement[8:33] != original[8:33]:
        return original
    idat = b''.join(chunk for kind,chunk in png_chunks(replacement) if kind == b'IDAT')
    output, inserted = [original[:8]], False
    for kind, chunk in png_chunks(original):
        if kind == b'IDAT':
            if not inserted:
                output.append(idat)
                inserted = True
        else:
            output.append(chunk)
    return b''.join(output)


def optimize_images(sources, cache, game_root=None, lossy_noncore=False, transparent_webp=False, png_only=(),
                    lossy_psnr=36, lossy_qualities=(85,90,95), detail_limit=None,
                    portrait_detail_limit=None, alpha_step=1):
    try:
        import numpy as np
        from PIL import Image, __version__, features
    except ImportError as exc:
        raise RuntimeError('资源优化需要安装 android/requirements-assets.txt') from exc
    if not features.check('webp'):
        raise RuntimeError('当前Pillow没有WebP编码支持')
    cache.mkdir(parents=True, exist_ok=True)
    png_only = set(png_only)

    def encode(source):
        raw = source.read_bytes()
        logical = source.relative_to(game_root).as_posix() if game_root else source.as_posix()
        category = noncore_category(logical)
        allow_lossy = bool(lossy_noncore and category)
        version = f'images-{"v5" if allow_lossy else "v3"}-{allow_lossy}-{__version__}'
        if transparent_webp:
            version = f'images-v6-webp-alpha-{allow_lossy}-{__version__}'
        if source in png_only:
            version += '-png-only'
        if allow_lossy and (lossy_psnr!=36 or tuple(lossy_qualities)!=(85,90,95)):
            version += f'-psnr{lossy_psnr}-q'+','.join(map(str,lossy_qualities))
        if allow_lossy and detail_limit and source not in png_only:
            version += f'-detail-v2-{detail_limit}-{portrait_detail_limit}-alpha{alpha_step}'
        legacy_version=version
        if allow_lossy:
            version += '-rgb-step6'
        key = hashlib.sha256(str(source).encode() + raw + version.encode()).hexdigest()
        metadata = cache/(key+'.json')
        if allow_lossy and not metadata.exists():
            legacy_key=hashlib.sha256(str(source).encode()+raw+legacy_version.encode()).hexdigest()
            legacy_metadata=cache/(legacy_key+'.json')
            if legacy_metadata.exists():
                previous=json.loads(legacy_metadata.read_text())
                previous_target=cache/(legacy_key+'.'+previous['format'])
                # WebP 与无损候选的质量不变；仅重算旧的 PNG RGB 量化结果。
                if not previous['codec'].startswith('png-rgb') and (not previous['converted'] or previous_target.exists()):
                    if previous['converted']:
                        shutil.copyfile(previous_target,cache/(key+'.'+previous['format']))
                    metadata.write_text(json.dumps(previous,ensure_ascii=False)+'\n')
        if metadata.exists():
            record = json.loads(metadata.read_text())
            target = cache/(key+'.'+record['format'])
            if not record['converted'] or target.exists():
                return source, target if record['converted'] else None, record
        source_cost = zip_size(raw)
        record = {'converted':False, 'core':not bool(category), 'category':category,
                  'source_bytes':len(raw), 'source_zip_bytes':source_cost,
                  'packed_bytes':len(raw), 'packed_zip_bytes':source_cost,
                  'format':'png', 'codec':'source', 'lossy':False}
        selected, cost = raw, source_cost
        if len(raw) >= 8192:
            with Image.open(io.BytesIO(raw)) as image:
                if getattr(image, 'n_frames', 1) == 1:
                    rgba = image.convert('RGBA')
                    pixels = rgba.tobytes()
                    record.update(width=rgba.width, height=rgba.height,
                                  rgba_sha256=hashlib.sha256(pixels).hexdigest())
                    if allow_lossy and detail_limit and source not in png_only:
                        # 只降低背景/立绘的细节，再还原画布，所有裁图坐标、UV、中心与绘制大小不变。
                        limit=portrait_detail_limit if '立绘' in category else detail_limit
                        limit=limit or detail_limit
                        scale=min(1,limit/max(rgba.size))
                        detail_size=(max(1,round(rgba.width*scale)),max(1,round(rgba.height*scale)))
                        detail=rgba.resize(detail_size,Image.Resampling.LANCZOS)
                        filtered=detail.resize(rgba.size,Image.Resampling.BILINEAR)
                        values=np.asarray(filtered).copy()
                        if alpha_step>1:
                            values[:,:,3]=np.minimum((values[:,:,3].astype('uint16')+alpha_step//2)//alpha_step*alpha_step,255).astype('uint8')
                        filtered=Image.fromarray(values)
                        for quality in lossy_qualities:
                            encoded=io.BytesIO()
                            filtered.save(encoded,format='WEBP',quality=quality,method=4,exact=True)
                            result=encoded.getvalue();packed=zip_size(result)
                            if packed<cost*.98:
                                selected,cost=result,packed
                                record.update(format='webp',codec=f'webp-detail{limit}-q{quality}-alpha{alpha_step}',lossy=True)
                        # 索引色按低细节网格放大，整张画布仍为原尺寸，避免大图重复存储平滑渐变。
                        palette=detail.quantize(colors=256,method=Image.Quantize.FASTOCTREE,dither=Image.Dither.NONE)
                        palette=palette.resize(rgba.size,Image.Resampling.NEAREST)
                        encoded=io.BytesIO();palette.save(encoded,format='PNG',optimize=True,compress_level=9)
                        result=encoded.getvalue();packed=zip_size(result)
                        if packed<cost*.98:
                            selected,cost=result,packed
                            record.update(format='png',codec=f'png-palette256-detail{limit}',lossy=True)
                        if selected!=raw:
                            with Image.open(io.BytesIO(selected)) as decoded:
                                decoded=decoded.convert('RGBA')
                                if decoded.size!=rgba.size:raise RuntimeError(f'画布尺寸变化：{source}')
                                reference=np.asarray(rgba).astype('float32');values=np.asarray(decoded).astype('float32')
                            visible=(reference[:,:,:3]*reference[:,:,3:4]-values[:,:,:3]*values[:,:,3:4])/255
                            mse=float(np.mean(visible**2))
                            record.update(converted=True,packed_bytes=len(selected),packed_zip_bytes=cost,
                                detail_width=detail_size[0],detail_height=detail_size[1],
                                alpha_preserved=bool(np.array_equal(reference[:,:,3],values[:,:,3])),
                                visible_rgb_psnr_db=round(float(10*np.log10(255**2/mse)) if mse else 99,3))
                            target=cache/(key+'.'+record['format']);target.write_bytes(selected)
                        metadata.write_text(json.dumps(record,ensure_ascii=False)+'\n')
                        return source,target if record['converted'] else None,record
                    candidates = [('png-lossless', 'png', recompress_png(image,raw))]
                    opaque = rgba.getchannel('A').getextrema() == (255,255)
                    if source not in png_only and (opaque or transparent_webp):
                        encoded = io.BytesIO()
                        (rgba.convert('RGB') if opaque else rgba).save(encoded,format='WEBP',lossless=True,exact=True,method=6)
                        candidates.append(('webp-lossless','webp',encoded.getvalue()))
                    for codec, suffix, result in candidates:
                        packed = zip_size(result)
                        if packed < cost*.98:
                            with Image.open(io.BytesIO(result)) as decoded:
                                if decoded.convert('RGBA').tobytes() != pixels:
                                    raise RuntimeError(f'无损编码改变了像素：{source}')
                            selected, cost = result, packed
                            record.update(format=suffix,codec=codec)
                    if allow_lossy and not opaque:
                        # PNG继续提供低误差候选，透明WebP由修正后的原生解码路径处理。
                        # RGB 按步长 6 四舍五入，CPU 误差<=3，为 GLES 混合舍入留出一级余量。
                        values = np.asarray(rgba).copy()
                        values[:,:,:3] = np.minimum((values[:,:,:3].astype('uint16')+3)//6*6,255).astype('uint8')
                        quantized = Image.fromarray(values)
                        result = recompress_png(quantized,raw)
                        packed = zip_size(result)
                        if packed < cost*.95:
                            with Image.open(io.BytesIO(result)) as decoded:
                                values = np.asarray(decoded.convert('RGBA')).astype('int16')
                            reference = np.asarray(rgba).astype('int16')
                            assert np.array_equal(reference[:,:,3],values[:,:,3]),source
                            assert int(np.max(np.abs(reference[:,:,:3]-values[:,:,:3])))<=3,source
                            changed = not np.array_equal(reference,values)
                            selected,cost = result,packed
                            record.update(format='png',codec='png-rgb-step6' if changed else 'png-lossless',max_rgb_error=3,gpu_max_rgb_error=4,lossy=changed)
                    if allow_lossy and source not in png_only and (opaque or transparent_webp):
                        reference = np.asarray(rgba).astype('float32')
                        for quality in lossy_qualities:
                            encoded = io.BytesIO()
                            rgba.save(encoded,format='WEBP',quality=quality,method=6,exact=True)
                            result = encoded.getvalue()
                            with Image.open(io.BytesIO(result)) as decoded:
                                decoded_rgba = decoded.convert('RGBA')
                                if decoded_rgba.getchannel('A').tobytes() != rgba.getchannel('A').tobytes():
                                    raise RuntimeError(f'有损编码改变了Alpha：{source}')
                                values = np.asarray(decoded_rgba).astype('float32')
                            error = (reference[:,:,:3]-values[:,:,:3])*(reference[:,:,3:4]/255)
                            mse = float(np.mean(error**2))
                            psnr = float(10*np.log10(255**2/mse)) if mse else 99.0
                            if psnr < lossy_psnr:
                                continue
                            packed = zip_size(result)
                            if packed < cost*.95:
                                selected, cost = result, packed
                                record.update(format='webp',codec='webp-q'+str(quality),visible_rgb_psnr_db=round(psnr,3),lossy=True)
                            break
                    if selected != raw:
                        record.update(converted=True,packed_bytes=len(selected),packed_zip_bytes=cost)
                        target = cache/(key+'.'+record['format'])
                        target.write_bytes(selected)
        metadata.write_text(json.dumps(record,ensure_ascii=False)+'\n')
        return source, cache/(key+'.'+record['format']) if record['converted'] else None, record

    variants, records = {}, {}
    with ThreadPoolExecutor(max_workers=4) as pool:
        for source, target, record in pool.map(encode,sources):
            if target:
                variants[source] = target
            records[source] = record
    return variants, records
