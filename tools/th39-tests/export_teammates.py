#!/usr/bin/env python3
"""补导原关卡 BindTeammate 的机体分支，不重导弹幕或修改原作。"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('night_export', HERE / 'export.py')
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--content', type=Path, required=True)
    args = parser.parse_args()
    exporter = base.Export(None, args.content.resolve())
    bindings, hashes = {}, {}
    for path in sorted((exporter.content / 'Data').glob('*.xna')):
        if not re.fullmatch(r'\d{3}', path.stem):
            continue
        text = exporter.text(path.stem)
        if 'SetBossCard(' not in text:
            continue
        found = False
        for route in ('灵', '魔', '早', '妹'):
            number = None
            for _, command in base.commands(text, route):
                name, values = base.split_command(command)
                if name == 'SetBossCard':
                    number = int(values[1])
                elif name == 'BindTeammate' and number is not None:
                    key = path.stem + '/' + str(number)
                    bindings.setdefault(key, {})[route] = [max(1, min(4, int(values[0]))), int(values[1])]
                    found = True
        if found:
            hashes['Data/' + path.name] = hashlib.sha256(path.read_bytes()).hexdigest()
    (base.OUT / 'teammates.lua').write_text('-- 原关卡 BindTeammate：使魔槽位、队友机体；按原机体分支保留。\nreturn ' + base.lua(bindings) + '\n', encoding='utf-8')
    (base.OUT / 'teammate_sources.json').write_text(json.dumps({'source_sha256': hashes, 'cards': len(bindings)}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


if __name__ == '__main__':
    main()
