"""安卓入包贴图优化：仅对不透明图尝试无损WebP，源PNG不改动。"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import hashlib
import io
import json


def optimize_images(sources, cache):
    try:
        from PIL import Image, __version__, features
    except ImportError as exc:
        raise RuntimeError('无损资源优化需要安装 android/requirements-assets.txt') from exc
    if not features.check('webp'):
        raise RuntimeError('当前Pillow没有WebP编码支持')
    cache.mkdir(parents=True, exist_ok=True)

    def encode(source):
        raw = source.read_bytes()
        key = hashlib.sha256(str(source).encode() + raw + ('opaque-webp-v1-' + __version__).encode()).hexdigest()
        metadata, target = cache / (key + '.json'), cache / (key + '.webp')
        if metadata.exists():
            record = json.loads(metadata.read_text())
            if not record['converted'] or target.exists():
                return source, target if record['converted'] else None, record
        record = {'converted': False, 'source_bytes': len(raw), 'packed_bytes': len(raw)}
        if len(raw) >= 32768:
            with Image.open(io.BytesIO(raw)) as image:
                if getattr(image, 'n_frames', 1) == 1:
                    rgba = image.convert('RGBA')
                    if rgba.getchannel('A').getextrema() == (255, 255):
                        encoded = io.BytesIO()
                        rgba.convert('RGB').save(encoded, format='WEBP', lossless=True, exact=True, method=6)
                        result = encoded.getvalue()
                        if len(result) < len(raw) * .95:
                            # 每张入包图片均核对RGBA像素；透明图不进入WebP预乘Alpha路径。
                            with Image.open(io.BytesIO(result)) as decoded:
                                assert decoded.convert('RGBA').tobytes() == rgba.tobytes(), source
                            target.write_bytes(result)
                            record.update(converted=True, packed_bytes=len(result),
                                          rgba_sha256=hashlib.sha256(rgba.tobytes()).hexdigest())
        metadata.write_text(json.dumps(record, ensure_ascii=False) + '\n')
        return source, target if record['converted'] else None, record

    variants, records = {}, {}
    with ThreadPoolExecutor(max_workers=4) as pool:
        for source, target, record in pool.map(encode, sources):
            if target:
                variants[source] = target
            records[source] = record
    return variants, records
