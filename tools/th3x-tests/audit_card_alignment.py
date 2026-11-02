"""采集具体卡片的对齐差异；核验原始指令头，保留真实入口运行快照。"""
import argparse
import dataclasses
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import sys

sys.dont_write_bytecode = True
from ecl_source import Source, Variable, f32


ROOT = Path(__file__).resolve().parents[2]


def command(args, cwd=ROOT):
    return subprocess.check_output(args, cwd=cwd, text=True).strip()


def capture(script):
    # 旧检查器可能输出初始化信息；最后一行才是本探针的JSON。
    return json.loads(command(['luajit', str(ROOT / 'tools' / script)]).splitlines()[-1])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace', type=Path, default=ROOT.parent / 'workspace')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    workspace = args.workspace.resolve()
    sources, records = {}, []

    def evidence(game, filename, sub, address, op, expected):
        key = (game, filename)
        if key not in sources:
            binary = workspace / 'original' / 'ECL' / f'th{game:02d}' / f'{filename}.ecl'
            declaration = workspace / 'decompiled' / 'ecl' / str(game) / f'{filename}.decl'
            sources[key] = Source(declaration, binary, game)
        source = sources[key]
        row = next(r for r in source.subs[sub] if r.address == address)
        assert row.op == op and row.args == expected, (filename, sub, hex(address), row)
        data = source.binary.read_bytes()
        size = struct.unpack_from('<H', data, address + 6)[0]
        # 原始操作数也核对，变量引用的字段值仍是原作变量索引。
        operand_verified = False
        if game == 10 and op == 409:
            actual = struct.unpack_from('<6i2f', data, address + 16)
            wanted = [v.index if isinstance(v, Variable) else v for v in expected]
            wanted[6:] = [f32(v) for v in wanted[6:]]
            assert list(actual) == wanted, (filename, hex(address), actual, wanted)
            operand_verified = True
        elif op in (95, 55, 80, 160) and game in (7, 8):
            assert struct.unpack_from('<i', data, address + 12)[0] == expected[0]
            operand_verified = True
        elif game == 8 and op == 77:
            assert list(struct.unpack_from('<2f', data, address + 12)) == expected
            operand_verified = True
        record = dataclasses.asdict(row)
        record.update(game=game, file=f'{filename}.ecl', sub=sub, address=hex(address),
                      operand_bytes_verified=operand_verified,
                      instruction_hex=data[address:address + size].hex())
        records.append(record)

    # 神德两支枪：禁止常规消弹、等待、加速；等待引用每只枪自己的I2。
    for sub, cancel, accel in [('BossCard5_atN', 0xb4ac, 0xb4dc),
                               ('BossCard5_at2', 0xa9e8, 0xaa18)]:
        evidence(10, 'stage06', sub, cancel, 409,
                 [0, 1, 0, 4096, 10000, -999999, -999999.0, -999999.0])
        evidence(10, 'stage06', sub, accel, 409,
                 [0, 3, 0, 32, 120, -999999, Variable(20), 0.0])
        # at2的WAIT地址由子程序内的kind确认，防止使用另一版thecl的行号。
        source = sources[(10, 'stage06')]
        wait = next(r.address for r in source.subs[sub] if r.op == 409 and r.args[3] == 32768)
        evidence(10, 'stage06', sub, wait, 409,
                 [0, 2, 0, 32768, Variable(-9983), -999999, -999999.0, -999999.0])
    for sub, address, index in [('BossCard5_at', 0x8cd4, 4), ('BossCard5_at2', 0x9158, 4),
                                ('BossCard8_at', 0xaf18, 7), ('BossCard9_at', 0xc694, 5)]:
        evidence(10, 'stage07', sub, address, 409,
                 [0, index, 0, 65536, -999999, -999999, -999999.0, -999999.0])
    for address in (0xd9a4, 0xdabc):
        evidence(7, 'ecldata4', 'Sub76', address, 95, [135])
    for address in (0x3f8, 0x4ac):
        evidence(8, 'ecldata_al', 'Sub1', address, 92,
                 ['"Sub2"', 0.0, 0.0, 9000, -2, 10])
    for address, op, values in [(0x5b0, 55, [12]), (0x5c0, 80, [16]),
                                (0x5d0, 77, [24.0, 24.0]), (0x5e4, 160, [30])]:
        evidence(8, 'ecldata_al', 'Sub2', address, op, values)
    runtime = capture('audit_th3x_card_alignment.lua')
    familiar = capture('audit_th31_familiar_alignment.lua')
    assert {r['id'] for r in runtime['cards']} == {3600, 3616, 3619, 3620, 4442}
    assert familiar['id'] == 364
    files = ['mod/GAME/th31.lua', 'mod/GAME/th31_combat.lua', 'mod/GAME/th34.lua',
             'mod/GAME/th35.lua', 'THlib/anm/stage_visual.lua', 'THlib/bullet/visual_match.lua',
             'THlib/lib/LObjectEvents.lua']
    result = {
        '说明': '未修复差异的审计快照；离线桩不替代Windows/Mac实机画面验证。',
        'game_commit_at_capture': command(['git', 'rev-parse', 'HEAD']),
        'game_sources_sha256': {p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in files},
        'reconstruction_commits': {name: command(['git', 'rev-parse', 'HEAD'], workspace / 'reconstructions' / name)
                                   for name in ('th08', 'th10')},
        'ecl_inputs': [{'game': game, 'file': f'{filename}.ecl', 'sha256': source.sha256}
                       for (game, filename), source in sources.items()],
        'ecl_records': records, 'runtime': runtime, 'familiar_runtime': familiar,
    }
    data = json.dumps(result, ensure_ascii=False, indent=2) + '\n'
    if args.output:
        args.output.write_text(data, encoding='utf-8')
    else:
        print(data, end='')


if __name__ == '__main__':
    main()
