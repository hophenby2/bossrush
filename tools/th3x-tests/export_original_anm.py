"""导出原作 ANM 精灵、指令和像素；不重绘、不缩放原始图像。"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import shutil
import struct
import subprocess
import sys
import zlib

ROOT = Path(__file__).resolve().parents[2]

def run(args, cwd=None):
    p = subprocess.run([str(a) for a in args], cwd=cwd, capture_output=True)
    if p.returncode:
        raise RuntimeError(p.stderr.decode('utf-8', 'replace'))
    return p.stdout.decode('utf-8', 'replace')

def png(target, width, height, rgba):
    def chunk(name, data):
        return struct.pack('>I', len(data)) + name + data + struct.pack('>I', zlib.crc32(name + data) & 0xffffffff)
    stride = width * 4
    rows = b''.join(b'\0' + rgba[y*stride:(y+1)*stride] for y in range(height))
    target.write_bytes(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0))
                       + chunk(b'IDAT', zlib.compress(rows, 9)) + chunk(b'IEND', b''))

def read_png(source):
    raw = source.read_bytes(); pos = 8; packed = b''; palette = None; trans = b''
    while pos < len(raw):
        n, = struct.unpack_from('>I', raw, pos); tag = raw[pos+4:pos+8]; data = raw[pos+8:pos+8+n]; pos += n+12
        if tag == b'IHDR': width, height, bits, color, _, _, interlace = struct.unpack('>IIBBBBB', data)
        elif tag == b'IDAT': packed += data
        elif tag == b'PLTE': palette = [data[i:i+3] for i in range(0, len(data), 3)]
        elif tag == b'tRNS': trans = data
    assert bits in (1, 2, 4, 8) and interlace == 0, (source, bits, interlace)
    channels = {0:1, 2:3, 3:1, 4:2, 6:4}[color]; stride = (width * channels * bits + 7)//8
    bpp = max(1, (channels * bits + 7)//8)
    packed = zlib.decompress(packed); previous = bytearray(stride); pixels = bytearray()
    def paeth(a, b, c):
        p = a+b-c; da, db, dc = abs(p-a), abs(p-b), abs(p-c)
        return a if da <= db and da <= dc else b if db <= dc else c
    for y in range(height):
        off = y*(stride+1); filt = packed[off]; row = bytearray(packed[off+1:off+1+stride])
        for i in range(stride):
            a = row[i-bpp] if i >= bpp else 0; b = previous[i]; c = previous[i-bpp] if i >= bpp else 0
            row[i] = (row[i] + (0 if filt == 0 else a if filt == 1 else b if filt == 2 else (a+b)//2 if filt == 3 else paeth(a,b,c))) & 255
        for x in range(width):
            p = row[x*channels:(x+1)*channels] if bits == 8 else [(row[x*bits//8] >> (8-bits-x*bits%8)) & ((1<<bits)-1)]
            if color == 6: pixels.extend(p)
            elif color == 2: pixels.extend((*p, 255))
            elif color == 3: pixels.extend((*palette[p[0]], trans[p[0]] if p[0] < len(trans) else 255))
            elif color == 0:
                gray = p[0]*255//((1<<bits)-1)
                pixels.extend((gray, gray, gray, 255))
            elif color == 4: pixels.extend((p[0], p[0], p[0], p[1]))
        previous = row
    return width, height, pixels

def convert(source, target, width, height, fmt, key=None, alpha=None):
    raw = source.read_bytes()
    if raw.startswith(b'\x89PNG'):
        if alpha:
            width, height, rgba = read_png(source)
            aw, ah, pixels = read_png(alpha)
            assert (aw, ah) == (width, height)
            rgba[3::4] = pixels[0::4]
            png(target, width, height, rgba)
        else: shutil.copyfile(source, target)
        return
    if raw.startswith(b'BM'):
        # 红魔乡的 ANM 引用外置 BMP；调色板也取自原文件。
        off, = struct.unpack_from('<I', raw, 10)
        bw, bh, _, bits = struct.unpack_from('<iiHH', raw, 18)
        assert bw == width and abs(bh) == height and bits in (8, 24, 32)
        stride = ((width * bits + 31) // 32) * 4
        rgba = bytearray()
        for y in range(height):
            row = off + (height - 1 - y if bh > 0 else y) * stride
            for x in range(width):
                if bits == 8:
                    pos = 54 + raw[row + x] * 4
                else:
                    pos = row + x * (bits // 8)
                b, g, r = raw[pos:pos+3]
                rgba.extend((r, g, b, 0 if (r<<16 | g<<8 | b) == (key or 0) else 255))
    elif fmt == 1:
        assert len(raw) == width * height * 4, (source, len(raw), width, height)
        rgba = bytearray(raw)
        rgba[0::4], rgba[2::4] = raw[2::4], raw[0::4]
    elif fmt in (3, 5):
        stride = (width * 2 + 3)//4*4
        if len(raw) == stride*height and stride != width*2:
            raw = b''.join(raw[y*stride:y*stride+width*2] for y in range(height))
        assert len(raw) == width * height * 2, (source, len(raw), width, height, fmt)
        rgba = bytearray()
        for (p,) in struct.iter_unpack('<H', raw):
            if fmt == 5:
                rgba.extend(((p>>8 & 15)*17, (p>>4 & 15)*17, (p & 15)*17, (p>>12)*17))
            else:
                rgba.extend(((p>>11)*255//31, (p>>5 & 63)*255//63, (p & 31)*255//31, 255))
    elif fmt == 7:
        assert len(raw) == width * height
        rgba = bytearray(v for p in raw for v in (255, 255, 255, p))
    else:
        raise ValueError((source, fmt))
    png(target, width, height, rgba)

def lua(v):
    if v is None: return 'nil'
    if isinstance(v, bool): return str(v).lower()
    if isinstance(v, (float, int)): return repr(v)
    if isinstance(v, str): return json.dumps(v, ensure_ascii=False)
    if isinstance(v, list): return '{' + ','.join(lua(x) for x in v) + '}'
    return '{' + ','.join('[' + lua(k) + ']=' + lua(x) for k, x in v.items()) + '}'

def entries(decl):
    starts = list(re.finditer(r'^entry (\w+) \{', decl, re.M))
    for i, m in enumerate(starts):
        yield decl[m.end():starts[i+1].start() if i+1 < len(starts) else len(decl)]

def parse(decl, assetdir, dest, game, archive):
    data = {'sprites': {}, 'scripts': {}, 'ids': {}}
    for index, entry in enumerate(entries(decl)):
        def prop(name, default=None):
            m = re.search(r'^    '+name+r': ([^,\r\n]+)', entry, re.M)
            return m.group(1) if m else default
        name = json.loads(prop('name'))
        if name.startswith('@'):
            continue
        texture = f'{archive}_{index}.png'
        source = assetdir / name
        if not source.exists():
            source = next((p for p in assetdir.rglob('*') if p.name.lower() == Path(name).name.lower()), source)
        if source.exists():
            alpha_name = prop('name2')
            alpha = next((p for p in assetdir.rglob('*') if p.name.lower() == Path(json.loads(alpha_name)).name.lower()), None) if alpha_name else None
            convert(source, dest / texture, int(prop('THTXWidth', prop('width'))),
                    int(prop('THTXHeight', prop('height'))), int(prop('THTXFormat', prop('format', '1'))),
                    int(prop('colorKey', '0'), 0), alpha)
        else:
            raise FileNotFoundError(source)
        data.setdefault('textures', []).append(texture)
        for m in re.finditer(r'sprite(\d+): \{ x: ([\d.-]+), y: ([\d.-]+), w: ([\d.-]+), h: ([\d.-]+)', entry):
            data['sprites'][int(m[1])] = [index, *[float(m[n]) for n in range(2, 6)]]
    # 脚本位于 entry 外层，thtk 使用 script scriptN。
    script_id = -1
    for m in re.finditer(r'script (?:(-?\d+) )?script(\d+)\s*\{([^}]+)\}', decl):
        script_id = int(m[1]) if m[1] is not None else script_id+1
        data['ids'][script_id] = int(m[2])
        commands, labels, t = [], {}, 0
        for line in m[3].splitlines():
            line = line.strip()
            time = re.fullmatch(r'([+-]?\d+):(?:\s*//.*)?', line)
            if time:
                t = t + int(time[1]) if time[1].startswith('+') else int(time[1]); continue
            if line.endswith(':'): labels[line[:-1]] = len(commands) + 1; continue
            ins = re.fullmatch(r'ins_?(-?\d+)\((.*)\);', line)
            if ins:
                args = []
                for a in ins[2].split(',') if ins[2] else []:
                    a = a.strip()
                    if a.startswith('['): args.append({'var': int(float(a[1:-1].rstrip('f')))})
                    elif re.fullmatch(r'sprite\d+', a): args.append(int(a[6:]))
                    elif re.fullmatch(r'script\d+', a): args.append(int(a[6:]))
                    elif a.startswith('0x'): args.append(int(a, 16))
                    elif re.fullmatch(r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?f?', a): args.append(float(a.rstrip('f')) if any(c in a for c in '.eEf') else int(a))
                    else: args.append(a)
                commands.append([t, int(ins[1]), *args])
        for cmd in commands:
            for i, arg in enumerate(cmd):
                if isinstance(arg, str) and arg in labels: cmd[i] = labels[arg]
        data['scripts'][int(m[2])] = commands
    return data

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--source', type=Path, default=Path(r'E:\workspace\原作'))
    ap.add_argument('--thtk', type=Path, default=Path(r'E:\workspace\thtkGUI-th20tr\thtk\thtk-th20'))
    ap.add_argument('--cache', type=Path, default=Path(r'E:\workspace\.bossrush-validation\original-anm'))
    args = ap.parse_args()
    manifest = {}
    for game in (6, 7, 8, 95, 10):
        cache = args.cache / str(game); cache.mkdir(parents=True, exist_ok=True)
        dats = [p for p in args.source.rglob('*') if p.is_file() and
                (p.name.lower() == ('th095.dat' if game == 95 else f'th{game:02}.dat') if game != 6 else p.name.startswith('紅魔郷') and p.suffix == '.DAT')]
        selected = {}
        for dat in dats:
            names = []
            for line in run([args.thtk/'thdat.exe', '-l', game, dat]).splitlines()[1:]:
                fields = line.split()
                if fields: names.append(fields[0])
            assets = [n for n in names if n.lower().endswith(('.anm', '.bmp', '.png')) and not n.lower().startswith(('face', 'ascii', 'title', 'staff', 'result', 'slpl', 'player', 'pl00', 'pl01', 'pl02', 'pl03', 'music', 'text', 'front', 'select', 'ending', 'enemy_name'))]
            if not assets: continue
            run([args.thtk/'thdat.exe', '-C', cache, '-x', game, dat, *assets])
            for n in assets:
                if n.lower().endswith('.anm'): selected[n] = dat
        dest = ROOT/'Resources'/'Original'/str(game); dest.mkdir(parents=True, exist_ok=True)
        output = ROOT/'mod'/'GAME'/'original'/str(game); output.mkdir(parents=True, exist_ok=True)
        manifest[game] = {}
        for n, dat in selected.items():
            archive = Path(n).stem
            path = cache/n
            decl = run([args.thtk/'thanm.exe', '-l', game, path])
            (cache/(archive+'.decl')).write_text(decl, encoding='utf-8')
            if game != 6: run([args.thtk/'thanm.exe', '-x', game, path], cwd=cache)
            data = parse(decl, cache, dest, game, archive)
            (cache/(archive+'.json')).write_text(json.dumps(data), encoding='utf-8')
            data['game'], data['archive'] = game, archive
            (output/(archive+'.lua')).write_text('-- 原作 ANM 自动导出；由 tools/th3x-tests/export_original_anm.py 生成。\nreturn '+lua(data)+'\n', encoding='utf-8')
            manifest[game][archive] = {'source': dat.name, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
                                       'sprites': len(data['sprites']), 'scripts': len(data['scripts'])}
        print(game, len(selected), 'ANM', flush=True)
    (ROOT/'mod'/'GAME'/'original'/'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    main()
