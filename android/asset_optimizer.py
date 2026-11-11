"""安卓入包图片优化：核心像素无损，非核心白名单允许有损，源PNG不改。"""
from concurrent.futures import ThreadPoolExecutor
import hashlib
import io
import json
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


def optimize_images(sources, cache, game_root=None, lossy_noncore=False):
    try:
        import numpy as np
        from PIL import Image, __version__, features
    except ImportError as exc:
        raise RuntimeError('资源优化需要安装 android/requirements-assets.txt') from exc
    if not features.check('webp'):
        raise RuntimeError('当前Pillow没有WebP编码支持')
    cache.mkdir(parents=True, exist_ok=True)

    def encode(source):
        raw = source.read_bytes()
        logical = source.relative_to(game_root).as_posix() if game_root else source.as_posix()
        category = noncore_category(logical)
        allow_lossy = bool(lossy_noncore and category)
        version = f'images-{"v5" if allow_lossy else "v3"}-{allow_lossy}-{__version__}'
        key = hashlib.sha256(str(source).encode() + raw + version.encode()).hexdigest()
        metadata = cache/(key+'.json')
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
                    candidates = [('png-lossless', 'png', recompress_png(image,raw))]
                    opaque = rgba.getchannel('A').getextrema() == (255,255)
                    if opaque:
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
                        # WebP固定预乘Alpha，与当前引擎PNG路径不同；透明图保持PNG。
                        # 非核心仅将RGB四舍五入到5bit阶梯，逐通道误差<=4，Alpha不动。
                        values = np.asarray(rgba).copy()
                        values[:,:,:3] = np.minimum((values[:,:,:3].astype('uint16')+4)//8*8,255).astype('uint8')
                        quantized = Image.fromarray(values)
                        result = recompress_png(quantized,raw)
                        packed = zip_size(result)
                        if packed < cost*.95:
                            with Image.open(io.BytesIO(result)) as decoded:
                                values = np.asarray(decoded.convert('RGBA')).astype('int16')
                            reference = np.asarray(rgba).astype('int16')
                            assert np.array_equal(reference[:,:,3],values[:,:,3]),source
                            assert int(np.max(np.abs(reference[:,:,:3]-values[:,:,:3])))<=4,source
                            changed = not np.array_equal(reference,values)
                            selected,cost = result,packed
                            record.update(format='png',codec='png-rgb5' if changed else 'png-lossless',max_rgb_error=4,lossy=changed)
                    if allow_lossy and opaque:
                        reference = np.asarray(rgba).astype('float32')
                        for quality in (85,90,95):
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
                            if psnr < 36:
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
