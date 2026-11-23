#!/usr/bin/env python3
"""覆盖PCM符号、位深、声道交错与音效时长，确保只转换入包副本。"""
from pathlib import Path
import importlib.util
import sys
import tempfile
import wave

ANDROID = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ANDROID))
spec = importlib.util.spec_from_file_location('bossrush_android_build', ANDROID / 'build.py')
build = importlib.util.module_from_spec(spec)
spec.loader.exec_module(build)

samples = {
    1: [0, 1, 127, 128, 254, 255, 64, 192],
    2: [-32768, -32767, -1, 0, 1, 32767, -128, 128],
    3: [-8388608, -8388607, -257, -1, 0, 255, 256, 8388607],
    4: [-2147483648, -2147483647, -65537, -1, 0, 65535, 65536, 2147483647],
}
with tempfile.TemporaryDirectory(prefix='bossrush-wav-compat-') as folder:
    root = Path(folder)
    for width, values in samples.items():
        raw = b''.join(v.to_bytes(width, 'little', signed=width > 1) for v in values)
        for channels in (1, 2):
            source, target = root / 'source.wav', root / 'packed.wav'
            with wave.open(str(source), 'wb') as audio:
                audio.setparams((channels, width, 44100, 0, 'NONE', 'not compressed'))
                audio.writeframes(raw)
            original = source.read_bytes()
            build.prepare_wav(source, target)
            assert source.read_bytes() == original, '转换改写了源素材'
            with wave.open(str(target), 'rb') as audio:
                assert audio.getnchannels() == channels
                assert audio.getframerate() == 44100
                assert audio.getnframes() == len(values) // channels, '音效时长发生变化'
                assert audio.getsampwidth() == min(width, 2)
                result = audio.readframes(audio.getnframes())
            if width <= 2:
                assert result == raw, '原有8/16位样本被改变'
            else:
                decoded = [int.from_bytes(result[i:i + 2], 'little', signed=True)
                           for i in range(0, len(result), 2)]
                assert decoded == [v >> ((width - 2) * 8) for v in values], '符号或声道交错错误'
print('WAV入包兼容检查通过：8/16/24/32位、单/双声道、边界样本、时长及源文件保护')
