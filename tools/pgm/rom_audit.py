"""用本地 ShmupMAME 核验 ZIP、父集和设备 ROM。"""
import argparse
from pathlib import Path
import subprocess
from zipfile import BadZipFile, ZipFile


ALIASES = {'batsugunspl2': 'batsugspl2'}


def run(executable, root, extra):
    rom_paths = {root, *extra}
    zips = sorted(root.rglob('*.zip'))
    known = {path.stem for path in zips}
    zips.extend(path for folder in extra for path in sorted(folder.glob('*.zip')) if path.stem not in known)
    rom_paths.update(path.parent for path in zips)
    rompath = ';'.join(str(path) for path in sorted(rom_paths))
    for path in zips:
        label = path.relative_to(root) if path.is_relative_to(root) else path
        try:
            with ZipFile(path) as archive:
                placeholder = archive.namelist() == ['placeholder']
        except BadZipFile:
            print(f'{label}：ZIP 损坏')
            continue
        game = ALIASES.get(path.stem, path.stem)
        result = subprocess.run(
            [str(executable), '-noreadconfig', '-rompath', rompath, '-verifyroms', game],
            capture_output=True, text=True, encoding='utf-8', errors='replace')
        marker = '（占位 ZIP）' if placeholder else ''
        print(f'[{label}]{marker}')
        for line in (result.stdout + result.stderr).splitlines():
            if line and not line[0].isdigit():
                print('  ' + line)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mame', type=Path, required=True)
    parser.add_argument('--roms', type=Path, required=True)
    parser.add_argument('--extra-roms', type=Path, action='append', default=[])
    args = parser.parse_args()
    run(args.mame.resolve(), args.roms.resolve(), [path.resolve() for path in args.extra_roms])


if __name__ == '__main__':
    main()
