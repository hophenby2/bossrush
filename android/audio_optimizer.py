"""安卓入包音效：源WAV保留，只在Ogg比ZIP内的PCM更小时替换。"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import hashlib
import io
import json
import wave
import zlib


def optimize_audio(sources, cache):
    try:
        import soundfile as sf
    except ImportError as exc:
        raise RuntimeError('音效压缩需要安装 android/requirements-assets.txt') from exc
    if 'VORBIS' not in sf.available_subtypes('OGG'):
        raise RuntimeError('当前libsndfile没有Ogg Vorbis编码支持')
    cache.mkdir(parents=True, exist_ok=True)

    def encode(source):
        raw = source.read_bytes()
        codec = f'vorbis-v1-compression-0.2-{sf.__version__}-{sf.__libsndfile_version__}'
        key = hashlib.sha256(str(source).encode() + raw + codec.encode()).hexdigest()
        metadata, target = cache / (key + '.json'), cache / (key + '.ogg')
        if metadata.exists():
            record = json.loads(metadata.read_text())
            if not record['converted'] or target.exists():
                return source, target if record['converted'] else None, record
        # 与原打包器相同：先去掉WAV元数据，再计算DEFLATE level 6后的实际代价。
        with wave.open(io.BytesIO(raw), 'rb') as wav:
            params, samples = wav.getparams(), wav.readframes(wav.getnframes())
        stripped = io.BytesIO()
        with wave.open(stripped, 'wb') as wav:
            wav.setparams(params)
            wav.writeframes(samples)
        compressor = zlib.compressobj(6, zlib.DEFLATED, -15)
        packed_wav = compressor.compress(stripped.getvalue()) + compressor.flush()
        pcm, rate = sf.read(io.BytesIO(raw), dtype='float32', always_2d=True)
        encoded = io.BytesIO()
        sf.write(encoded, pcm, rate, format='OGG', subtype='VORBIS', compression_level=.2)
        result = encoded.getvalue()
        record = {'converted': False, 'source_bytes': len(raw), 'wav_zip_bytes': len(packed_wav),
                  'ogg_bytes': len(result), 'frames': len(pcm), 'sample_rate': rate,
                  'channels': pcm.shape[1], 'compression_level': .2}
        # Ogg自身已压缩，APK按ZIP_STORED存放；极短音效可能反而变大，继续保留PCM。
        if len(result) < len(packed_wav) * .95:
            decoded, decoded_rate = sf.read(io.BytesIO(result), dtype='float32', always_2d=True)
            if decoded_rate != rate or decoded.shape != pcm.shape:
                raise RuntimeError(f'Ogg改变了音效采样率、声道或帧数：{source}')
            target.write_bytes(result)
            record['converted'] = True
        metadata.write_text(json.dumps(record, ensure_ascii=False) + '\n')
        return source, target if record['converted'] else None, record

    variants, records = {}, {}
    with ThreadPoolExecutor(max_workers=4) as pool:
        for source, target, record in pool.map(encode, sources):
            if target:
                variants[source] = target
            records[source] = record
    return variants, records
