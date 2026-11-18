#!/usr/bin/env python3
"""检验音效时长/声道/采样率、APK收益判断及缓存。"""
from pathlib import Path
import importlib.util
import tempfile
import wave
import numpy as np
import soundfile as sf

spec = importlib.util.spec_from_file_location('audio_optimizer', Path(__file__).resolve().parents[1]/'audio_optimizer.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
with tempfile.TemporaryDirectory() as temp:
    root = Path(temp)
    paths = []
    for rate, channels in [(44100, 2), (22050, 1), (11025, 2)]:
        path = root/f'{rate}-{channels}.wav'
        time = np.arange(rate*2)/rate
        signal = (.5*np.sin(2*np.pi*(440*time+60*time**2))).astype('float32')
        sf.write(path, np.repeat(signal[:, None], channels, axis=1), rate, subtype='PCM_16')
        paths.append(path)
    tiny = root/'tiny.wav'
    with wave.open(str(tiny), 'wb') as w:
        w.setparams((1, 1, 22050, 32, 'NONE', 'not compressed'))
        w.writeframes(bytes([128])*32)
    paths.append(tiny)
    original = {p:p.read_bytes() for p in paths}
    variants, records = m.optimize_audio(paths, root/'cache')
    assert tiny not in variants, '极短音效不能因Ogg文件头而变大'
    assert len(variants) == 3
    for p, target in variants.items():
        a, b = sf.info(p), sf.info(target)
        assert (a.frames,a.samplerate,a.channels) == (b.frames,b.samplerate,b.channels)
        assert records[p]['ogg_bytes'] < records[p]['wav_zip_bytes']*.95
    assert all(p.read_bytes() == raw for p,raw in original.items()), '不能改写源WAV'
    assert m.optimize_audio(paths,root/'cache') == (variants,records)
    music = root/'music.ogg'
    low_rate = root/'low-rate.ogg'
    noise = np.random.default_rng(17).normal(0, .1, (44100*2+137, 2)).astype('float32')
    sf.write(music, noise, 44100, format='OGG', subtype='VORBIS', compression_level=0)
    sf.write(low_rate, noise, 44100, format='OGG', subtype='VORBIS', compression_level=.9)
    original = {p: p.read_bytes() for p in (music, low_rate)}
    variants, records = m.optimize_music([music, low_rate], root/'music-cache')
    assert music in variants and low_rate not in variants
    before, after = sf.info(music), sf.info(variants[music])
    assert (before.frames, before.samplerate, before.channels) == (after.frames, after.samplerate, after.channels)
    assert after.frames == len(noise), '循环点使用的非整秒帧数不能改变'
    assert records[music]['packed_bytes'] < records[music]['source_bytes']*.95
    assert all(p.read_bytes() == raw for p, raw in original.items()), '源音乐不能被改写'
    assert m.optimize_music([music, low_rate], root/'music-cache') == (variants, records)
print('音效及音乐采样率/声道/帧数、包体收益、源文件及缓存检查通过')
