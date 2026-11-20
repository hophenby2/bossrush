#!/usr/bin/env python3
"""记录正式状态机的练习入口，并保存生成输入与输出指纹。"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / 'mod/GAME/ports/dreamer/LikeDreamer'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reference', type=Path, help='可选：只读记录复原原作 C++ 的来源指纹')
    args = parser.parse_args()
    subprocess.run(['luajit', 'tools/generate_likedreamer_practice.lua'], cwd=ROOT, check=True)
    modules = ['core', 'boss_recovered', 'boss_early', 'boss_middle', 'boss_late']
    inputs = [DEST / (name + '.lua') for name in modules]
    inputs += [DEST / 'recovered' / (name + '.lua') for name in
               ['defaults', 'early', 'boss07', 'boss08', 'boss09', 'late', 'boss10_aux', 'guard']]
    inputs += [ROOT / 'tools/likedreamer_parity/boss_fixture.lua',
               ROOT / 'tools/generate_likedreamer_practice.lua', Path(__file__).resolve()]
    result = {
        'method': 'Nightmare；正式状态机沿超时路线记录攻击开放前一帧，直接恢复存活节点及引用，不预滚先前攻击。',
        'entries': 61,
        'input_sha256': {str(p.relative_to(ROOT)): sha(p) for p in inputs},
        'output_sha256': sha(DEST / 'practice_entries.lua'),
    }
    if args.reference:
        names = ['stage_runtime.cpp', 'stage_runtime_scene10.cpp', 'stage_runtime_boss07.cpp',
                 'stage_runtime_boss08.cpp', 'stage_runtime_boss09.cpp', 'stage_runtime_late.cpp',
                 'stage_runtime_boss10_aux.cpp']
        result['reference_sha256'] = {name: sha(args.reference / name) for name in names}
        result['reference_note'] = '来源指纹；入口快照从正式 Lua 状态机生成，不等同于另一次 C++ 逐帧对照。'
    (DEST / 'practice_sources.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    main()
