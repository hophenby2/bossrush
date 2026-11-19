#!/usr/bin/env python3
"""无损解码春雪特殊系统原始纹理，并记录来源哈希。"""
import argparse
import hashlib
from io import BytesIO
import json
from pathlib import Path
from PIL import Image
from export_art import read

ROOT = Path(__file__).resolve().parents[2]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--spring-content', type=Path, required=True)
args = parser.parse_args()
sources = {}
for name, relative in [('grazebox', 'UI/grazebox.xna'), ('spscore', 'List/spscore.xna')]:
    source = args.spring_content / 'Graphics' / relative
    target = ROOT / 'Resources/native_players/source' / ('37_' + name + '.png')
    original = Image.open(BytesIO(read(source, 0))).convert('RGBA')
    original.save(target, optimize=True)
    assert Image.open(target).convert('RGBA').tobytes() == original.tobytes()
    sources[relative] = {'sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
                         'png_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                         'width': original.width, 'height': original.height}
(ROOT / 'mod/GAME/ports/mhj/native_players/hud_sources.json').write_text(
    json.dumps(sources, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(sources, ensure_ascii=False))
