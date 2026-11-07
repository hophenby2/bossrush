#!/usr/bin/env python3
"""检查离线 APK 的完整性、资源隔离、ARM64 库和无损 WAV 重封装。"""
from pathlib import Path
import argparse
import hashlib
import io
import json
import struct
import wave
import zipfile

ROOT = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--game-root', type=Path, default=ROOT.parent, help='与 APK 对应的游戏源码快照')
args = parser.parse_args()
GAME = args.game_root.resolve()
apk = ROOT / 'dist/BossRushHD-android-arm64-debug.apk'
with zipfile.ZipFile(apk) as archive:
    names = archive.namelist()
    assert len(names) == len(set(names)), 'APK 中有重名文件'
    assert archive.testzip() is None, 'APK CRC 校验失败'
    assert not any(name.startswith(('assets/game/User/', 'assets/game/replay/')) for name in names), '打包包含了用户数据'
    assert not any(name.lower().endswith(('.exe', '.dll')) for name in names), 'APK 中含 Windows 二进制'
    assert all(name.startswith('lib/arm64-v8a/') for name in names if name.startswith('lib/')), '存在非 ARM64 库'
    index = archive.read('assets/game/asset_index.lua').decode()
    paths = [json.loads(line.strip().rstrip(',')) for line in index.splitlines()[1:-1]]
    for name in names:
        if name.startswith('assets/') and Path(name).suffix.lower() in {'.ttf', '.otf', '.ogg'}:
            assert archive.getinfo(name).compress_type == zipfile.ZIP_STORED, '流式资源不能二次压缩：' + name
    assert len(paths) == len({path.lower() for path in paths}), '资源路径大小写冲突'
    wav_count = 0
    for path in paths:
        name = 'assets/game/' + path
        assert name in names, f'清单缺失资源：{path}'
        source = GAME / path
        if source.suffix == '.lua':
            assert archive.read(name).decode('utf-8') == source.read_text(encoding='utf-8-sig'), f'游戏脚本有额外改写：{path}'
        elif source.suffix.lower() == '.wav':
            with wave.open(str(source), 'rb') as original, wave.open(io.BytesIO(archive.read(name)), 'rb') as packed:
                assert original.getparams() == packed.getparams(), f'WAV 格式改变：{path}'
                assert original.readframes(original.getnframes()) == packed.readframes(packed.getnframes()), f'WAV 样本改变：{path}'
            wav_count += 1
        else:
            assert archive.read(name) == source.read_bytes(), f'游戏素材改变：{path}'
    for source in (ROOT / 'lua').glob('*.lua'):
        assert archive.read('assets/game/android/' + source.name).decode('utf-8') == source.read_text(), f'移植脚本不匹配：{source.name}'
    fingerprint = []
    for name in sorted(names):
        if not name.startswith('assets/game/') or not name.endswith('.lua'):
            continue
        relative = name[len('assets/game/'):]
        if relative not in {'core.lua', 'launch.lua'} and not relative.startswith(('THlib/', 'mod/', 'Resources/System/', 'android/')):
            continue
        data = archive.read(name).decode('utf-8-sig').replace('\r\n', '\n').encode('utf-8')
        fingerprint.append(f'{relative}:{len(data)}:{hashlib.sha256(data).hexdigest()}')
    expected = hashlib.sha256('\n'.join(fingerprint).encode('utf-8')).hexdigest()
    assert archive.read('assets/game/android/resume-version.txt').decode() == expected, '续玩版本指纹与实际入包源码不一致'
    net_parts = [part for part in fingerprint if not part.startswith('android/')]
    net_expected = hashlib.sha256('\n'.join(net_parts).encode('utf-8')).hexdigest()
    assert archive.read('assets/game/android/net-version.txt').decode() == net_expected, '跨平台联机版本指纹不一致'
    libraries = [name for name in names if name.startswith('lib/')]
    for name in libraries:
        data = archive.read(name)
        assert data[:5] == b'\x7fELF\x02' and struct.unpack_from('<H', data, 18)[0] == 183, f'不是 ARM64 ELF：{name}'
        if name.endswith(('libcocos2dlua.so', 'libopenal.so')):
            offset = struct.unpack_from('<Q', data, 32)[0]
            entry_size, count = struct.unpack_from('<HH', data, 54)
            for i in range(count):
                header = struct.unpack_from('<IIQQQQQQ', data, offset+i*entry_size)
                if header[0] == 1:
                    assert header[-1] >= 16384, f'自编译库未按 16KB 对齐：{name}'
    shaders = sorted(p.stem for p in (GAME / 'shader').glob('*.hlsl'))
    for shader in shaders:
        text = archive.read('assets/game/android/shaders/' + shader + '.frag').decode()
        assert 'subSampleScreen' in text and 'POSTFX_SAMPLER' in text, '后处理未接Sub采样器：' + shader
    text = archive.read('assets/src/shader/ColorAdd.frag').decode()
    for output in ('cc_FragColor', 'gl_FragColor'):
        assert f'{output}.rgb = min(v_fragmentColor.rgb + tex.rgb, vec3(1.0));' in text, '加色未在混合前饱和'
        assert f'{output}.a = tex.a * v_fragmentColor.a;' in text, '加色忽略顶点透明度'
    for shader in ('ColorAdd_Fog.frag', 'ColorMulti_Fog.frag'):
        text = archive.read('assets/src/shader/' + shader).decode()
        assert 'distance(u_fogCamera.xyz, v_worldPosition)' in text, '雾效未按世界坐标逐像素计算：' + shader
        assert 'u_fogColor.a*c.a' in text, '雾颜色透明度未参与混合：' + shader
    assert 'assets/licenses/SOURCE.txt' in names
digest = hashlib.file_digest(apk.open('rb'), 'sha256').hexdigest()
saved = (ROOT / 'dist' / (apk.name+'.sha256')).read_text().split()[0]
assert digest == saved, 'APK SHA-256 不匹配'
print(f'APK 校验通过：{len(paths)} 个游戏资源，{wav_count} 个 WAV 无损重封装，{len(libraries)} 个 ARM64 库，{len(shaders)} 个后处理shader；不含用户存档。')
print(f'大小：{apk.stat().st_size/1024/1024:.1f} MiB；SHA-256：{digest}')
