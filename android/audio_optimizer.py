"""只修改入包音频副本；音效保留解码帧数，BGM按目标采样率保持时长。"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import hashlib
import io
import json
import shutil
import subprocess
import wave
import zlib


def optimize_audio(sources, cache, compression_level=.2):
    try:
        import soundfile as sf
    except ImportError as exc:
        raise RuntimeError('音效压缩需要安装 android/requirements-assets.txt') from exc
    if 'VORBIS' not in sf.available_subtypes('OGG'):
        raise RuntimeError('当前libsndfile没有Ogg Vorbis编码支持')
    cache.mkdir(parents=True, exist_ok=True)

    def encode(source):
        raw = source.read_bytes()
        codec = f'vorbis-v1-compression-{compression_level}-{sf.__version__}-{sf.__libsndfile_version__}'
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
                          format='OGG',subtype='VORBIS',compression_level=compression_level) as output:
            for offset in range(0,len(pcm),32768):
                output.write(pcm[offset:offset+32768])
        result = encoded.getvalue()
        record = {'converted': False, 'source_bytes': len(raw), 'wav_zip_bytes': len(packed_wav),
                  'ogg_bytes': len(result), 'frames': len(pcm), 'sample_rate': rate,
                  'channels': pcm.shape[1], 'compression_level': compression_level}
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
                   sample_rate=None, mono=False, bitrate_kbps=None):
    import soundfile as sf
    cache.mkdir(parents=True, exist_ok=True)
    oggenc=None
    if bitrate_kbps:
        oggenc=shutil.which('oggenc')
        if not oggenc:raise RuntimeError('500MB高音质档需要vorbis-tools提供oggenc')
        encoder_version=subprocess.check_output([oggenc,'--version'],text=True).strip()

    def encode(source):
        raw = source.read_bytes()
        codec = f'music-v2-compression-{compression_level}-min-{minimum_bitrate}-{sf.__version__}-{sf.__libsndfile_version__}'
        if sample_rate or mono:
            codec += f'-resample-v2-pcm-{sample_rate}-mono{mono}'
        if bitrate_kbps:
            codec += f'-managed-v1-{bitrate_kbps}-{encoder_version}'
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
            encoded = io.BytesIO()
            if target_rate!=info.samplerate or target_channels!=info.channels or bitrate_kbps:
                import numpy as np
                ffmpeg=shutil.which('ffmpeg')
                if not ffmpeg:
                    raise RuntimeError('低码率 BGM 档需要 ffmpeg')
                pcm,rate=sf.read(io.BytesIO(raw),dtype='float32',always_2d=True)
                # ffmpeg 只负责 PCM 重采样，Vorbis 由现有 libsndfile 编码，
                # 不要求系统 ffmpeg 额外编入 libvorbis，也避免两套 Ogg 解码的首帧差异。
                result=subprocess.run([ffmpeg,'-v','error','-f','f32le','-ar',str(rate),
                    '-ac',str(info.channels),'-i','pipe:0','-vn','-ar',str(target_rate),
                    '-ac',str(target_channels),'-c:a','pcm_f32le','-f','f32le','pipe:1'],
                    input=pcm.astype('<f4',copy=False).tobytes(),stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,check=True).stdout
                pcm=np.frombuffer(result,dtype='<f4').reshape(-1,target_channels)
                expected=round(info.frames*target_rate/info.samplerate)
                if abs(len(pcm)-expected)>1:
                    raise RuntimeError(f'BGM重采样改变了时长：{source}')
                if len(pcm)<expected:
                    pcm=np.pad(pcm,((0,expected-len(pcm)),(0,0)))
                if bitrate_kbps:
                    samples=np.clip(np.rint(pcm[:expected]*32768),-32768,32767).astype('<i2')
                    output=subprocess.run([oggenc,'--quiet','--raw','--raw-bits=16',
                        '--raw-rate='+str(target_rate),'--raw-chan='+str(target_channels),
                        '--raw-endianness=0','--managed','--bitrate='+str(bitrate_kbps),
                        '--serial=1','--output=-','-'],input=samples.tobytes(),
                        stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=True)
                    encoded.write(output.stdout)
                    record.update(target_bitrate_kbps=bitrate_kbps,encoder=encoder_version)
                else:
                    with sf.SoundFile(encoded,'w',samplerate=target_rate,channels=target_channels,
                                      format='OGG',subtype='VORBIS',compression_level=compression_level) as output:
                        for offset in range(0,expected,32768):
                            output.write(pcm[offset:min(expected,offset+32768)])
            else:
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
                    if (frames!=expected_frames or decoded.samplerate!=target_rate
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
