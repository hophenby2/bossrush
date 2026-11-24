"""安卓入包音频，保留源文件与解码帧数，只替换有包体收益的编码。"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import hashlib
import io
import json
import shutil
import subprocess
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
        # WAV 去掉元数据后比较实际入包代价；FLAC 也进入相同的音效压缩流程。
        original=raw
        if source.suffix.lower()=='.wav':
            with wave.open(io.BytesIO(raw), 'rb') as wav:
                params, samples = wav.getparams(), wav.readframes(wav.getnframes())
            stripped = io.BytesIO()
            with wave.open(stripped, 'wb') as wav:
                wav.setparams(params)
                wav.writeframes(samples)
            original=stripped.getvalue()
        compressor = zlib.compressobj(6, zlib.DEFLATED, -15)
        packed_wav = compressor.compress(original) + compressor.flush()
        pcm, rate = sf.read(io.BytesIO(raw), dtype='float32', always_2d=True)
        encoded = io.BytesIO()
        # 长音效一次交给 Vorbis 会耗尽编码线程的栈；按固定大小流式写入。
        with sf.SoundFile(encoded,'w',samplerate=rate,channels=pcm.shape[1],
                          format='OGG',subtype='VORBIS',compression_level=.2) as output:
            for offset in range(0,len(pcm),32768):
                output.write(pcm[offset:offset+32768])
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


def optimize_music(sources, cache, compression_level=.5, minimum_bitrate=192000,
                   sample_rate=None, mono=False):
    import soundfile as sf
    cache.mkdir(parents=True, exist_ok=True)

    def encode(source):
        raw = source.read_bytes()
        codec = f'music-v2-compression-{compression_level}-min-{minimum_bitrate}-{sf.__version__}-{sf.__libsndfile_version__}'
        if sample_rate or mono:
            codec += f'-resample-v1-{sample_rate}-mono{mono}'
        key = hashlib.sha256(str(source).encode() + raw + codec.encode()).hexdigest()
        metadata, target = cache / (key + '.json'), cache / (key + '.ogg')
        if metadata.exists():
            record = json.loads(metadata.read_text())
            if not record['converted'] or target.exists():
                return source, target if record['converted'] else None, record
        info = sf.info(io.BytesIO(raw))
        record = {'converted': False, 'source_bytes': len(raw), 'packed_bytes': len(raw),
                  'frames': info.frames, 'sample_rate': info.samplerate,
                  'channels': info.channels, 'compression_level': compression_level}
        # 常规档保留采样率、声道和帧数；小包档仅重采样 BGM，循环位置仍以秒计。
        if info.duration > 0 and len(raw) * 8 / info.duration > minimum_bitrate:
            target_rate=min(sample_rate or info.samplerate,info.samplerate)
            target_channels=1 if mono else info.channels
            if target_rate!=info.samplerate or target_channels!=info.channels:
                ffmpeg=shutil.which('ffmpeg')
                if not ffmpeg:
                    raise RuntimeError('低码率 BGM 档需要 ffmpeg')
                result=subprocess.run([ffmpeg,'-v','error','-i','pipe:0','-map_metadata','-1',
                    '-vn','-ar',str(target_rate),'-ac',str(target_channels),'-c:a','libvorbis',
                    '-q:a','-1','-f','ogg','pipe:1'],input=raw,stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,check=True).stdout
            else:
                encoded = io.BytesIO()
                with sf.SoundFile(io.BytesIO(raw)) as audio, sf.SoundFile(
                        encoded, 'w', samplerate=info.samplerate, channels=info.channels,
                        format='OGG', subtype='VORBIS', compression_level=compression_level) as output:
                    for block in audio.blocks(blocksize=32768, dtype='float32', always_2d=True):
                        output.write(block)
                result = encoded.getvalue()
            if len(result) < len(raw) * .95:
                with sf.SoundFile(io.BytesIO(result)) as decoded:
                    frames = sum(len(block) for block in decoded.blocks(blocksize=32768))
                    expected_frames=round(info.frames*target_rate/info.samplerate)
                    tolerance=1 if target_rate!=info.samplerate else 0
                    if (abs(frames-expected_frames)>tolerance or decoded.samplerate!=target_rate
                            or decoded.channels!=target_channels):
                        raise RuntimeError(f'Ogg改变了音乐采样率、声道或帧数：{source}')
                    record.update(packed_frames=frames,packed_sample_rate=decoded.samplerate,
                                  packed_channels=decoded.channels)
                target.write_bytes(result)
                record.update(converted=True, packed_bytes=len(result))
        metadata.write_text(json.dumps(record, ensure_ascii=False) + '\n')
        return source, target if record['converted'] else None, record

    variants, records = {}, {}
    with ThreadPoolExecutor(max_workers=4) as pool:
        for source, target, record in pool.map(encode, sources):
            if target:
                variants[source] = target
            records[source] = record
    return variants, records
