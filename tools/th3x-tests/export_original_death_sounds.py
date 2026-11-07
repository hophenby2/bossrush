"""提取原作击破音效；元数据取复原源码，TH10取原版PE的0x4749c8表。"""
from pathlib import Path
import argparse
import re
import shutil
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]


def source_metadata(workspace, game):
    folder = 'th095' if game == 95 else f'th{game:02}'
    code = (workspace / folder / 'src/SoundPlayer.cpp').read_text('utf-8')
    block = re.search(r'(?:g_SoundBufferIdxVol|SOUND_BUFFER_IDX_VOL)[^=]*=\s*\{(.*?)\};', code, re.S)[1]
    records = [tuple(map(int, m)) for m in re.findall(r'\{\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\}', block)]
    block = re.search(r'g_SFXList[^=]*=\s*\{(.*?)\};', code, re.S)[1]
    names = [Path(n).name for n in re.findall(r'"([^"]+\.wav)"', block)]
    return {i: (names[records[i][0]], *records[i][1:]) for i in (2, 3, 18)}


def th10_metadata(game_dir):
    raw = next(game_dir.rglob('th10.exe')).read_bytes()
    pe, = struct.unpack_from('<I', raw, 0x3c)
    count, = struct.unpack_from('<H', raw, pe + 6)
    opt_size, = struct.unpack_from('<H', raw, pe + 20)
    section = pe + 24 + opt_size
    rva = 0x4749c8 - 0x400000
    for i in range(count):
        size, va, _, pointer = struct.unpack_from('<IIII', raw, section + 40*i + 8)
        if va <= rva < va + size:
            offset = pointer + rva - va
            result = {}
            for sound in (2, 3, 18):
                sample, volume, priority = struct.unpack_from('<ihh', raw, offset + sound*8)
                assert sample == (15 if sound == 18 else 1)
                result[sound] = ('se_enep01.wav' if sound == 18 else 'se_enep00.wav', volume, priority)
            return result
    raise ValueError('未找到TH10音效元数据')


def export(workspace):
    originals = workspace / '原作'
    thdat = workspace / 'thtkGUI-th20tr/thtk/thtk-th20/thdat.exe'
    output = ['-- 原版击破音效的SoundIdx和DirectSound音量；由export_original_death_sounds.py导出。', 'return {']
    for game in (6, 8, 95, 10):
        prefix = '[th095]' if game == 95 else f'[th{game:02}]'
        game_dir = next(p for p in originals.iterdir() if p.is_dir() and p.name.startswith(prefix))
        records = th10_metadata(game_dir) if game == 10 else source_metadata(workspace, game)
        archive_name = '紅魔郷IN.DAT' if game == 6 else 'th095.dat' if game == 95 else f'th{game:02}.dat'
        archive = next(game_dir.rglob(archive_name))
        dest = ROOT / 'Resources/OriginalAudio' / str(game)
        dest.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(prefix='bossrush-death-sounds-') as temp:
            names = sorted({v[0] for v in records.values()})
            subprocess.run([str(thdat), '-C', temp, '-x', str(game), str(archive), *names], check=True, capture_output=True)
            for name in names:
                shutil.copyfile(Path(temp) / name, dest / name)
        output.append(f'    [{game}]={{')
        for sound, (name, volume, priority) in records.items():
            path = (dest / name).relative_to(ROOT).as_posix()
            output.append(f'        [{sound}]={{"{path}",{volume},{priority}}},')
        output.append('    },')
    output.append('}')
    (ROOT / 'mod/GAME/original/death_sounds.lua').write_text('\n'.join(output) + '\n', encoding='utf-8', newline='\n')
    print('已提取红/永/文/风的原版击破音效及音量表；妖使用既有原版音效表。')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('workspace', type=Path)
    export(parser.parse_args().workspace)
