"""检查符卡标题的实际Unicode字形覆盖；只用Python标准库。"""
from pathlib import Path
import re
import struct
import sys

ROOT = Path(__file__).resolve().parents[1]


def font_codepoints(path):
    """读取SFNT的Unicode cmap（项目字体使用format 4/12）。"""
    data = path.read_bytes()
    u16 = lambda at: struct.unpack_from('>H', data, at)[0]
    u32 = lambda at: struct.unpack_from('>I', data, at)[0]
    tables = {}
    for i in range(u16(4)):
        at = 12 + i * 16
        tables[data[at:at + 4]] = u32(at + 8)
    cmap = tables[b'cmap']
    result = set()
    for i in range(u16(cmap + 2)):
        at = cmap + 4 + i * 8
        platform, encoding = u16(at), u16(at + 2)
        if platform != 0 and (platform != 3 or encoding not in (1, 10)):
            continue
        sub = cmap + u32(at + 4)
        fmt = u16(sub)
        if fmt == 12:
            for j in range(u32(sub + 12)):
                start, end, glyph = struct.unpack_from('>III', data, sub + 16 + j * 12)
                result.update(range(start + (glyph == 0), end + 1))
        elif fmt == 4:
            count = u16(sub + 6) // 2
            ends = sub + 14
            starts = ends + count * 2 + 2
            deltas = starts + count * 2
            offsets = deltas + count * 2
            for j in range(count):
                delta, offset = u16(deltas + j * 2), u16(offsets + j * 2)
                for cp in range(u16(starts + j * 2), u16(ends + j * 2) + 1):
                    if cp == 0xffff:
                        continue
                    glyph = u16(offsets + j * 2 + offset + 2 * (cp - u16(starts + j * 2))) if offset else cp
                    if glyph or not offset:
                        glyph = (glyph + delta) & 0xffff
                    if glyph:
                        result.add(cp)
    assert result, f'字体没有可读取的Unicode cmap：{path}'
    return result


def main():
    font_dir = ROOT / 'THlib/UI/font'
    primary = font_codepoints(font_dir / 'text.ttf')
    fallback = font_codepoints(font_dir / 'NotoSansCJKjp-Bold.otf')
    # 同时覆盖卡表与脚本中的标题字面量，不依赖卡名语言或关卡编号判断。
    titles = set()
    for path in (ROOT / 'mod').rglob('*.lua'):
        text = path.read_text(encoding='utf-8-sig')
        titles.update(re.findall(r'''["']([^"'\n]*[「『][^"'\n]*)["']''', text))
    assert titles, '未找到符卡标题'
    chars = {ord(c) for title in titles for c in title}
    missing = chars - fallback
    # 单字体兼容路径也必须完整，不能只核对字体组的并集。
    if missing:
        print('回退字体仍缺字：' + ''.join(chr(cp) for cp in sorted(missing)))
        return 1
    print(f'符卡标题字形覆盖通过：{len(titles)} 个标题字面量；'
          f'原字体缺 {len(chars - primary)} 字，补齐后缺 0 字')
    return 0


if __name__ == '__main__':
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(encoding='utf-8')
    sys.exit(main())
