"""以原作ECL二进制校验五作角色映射；反汇编使用thecl -rx -d生成。"""
import argparse
import json
from pathlib import Path
import re
import sys

from ecl_source import Source

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/th36-tests'))
from run_lua import runtime


def check(args):
    lua = runtime()
    setup = (ROOT / 'tools/check_original_anm.lua').read_text('utf-8-sig')
    lua.execute(setup.split('local A,V=OriginalANM,OriginalStageVisual')[0])
    visual = lua.globals().OriginalStageVisual
    roles = lua.execute("for i=1,30 do local n,v=debug.getupvalue(OriginalStageVisual.bind_boss,i);if n=='roles' then return v end end")
    cache, rows = {}, []

    def source(game, file):
        key = game, file
        if key not in cache:
            folder = 'th095' if game == 95 else f'th{game:02d}'
            cache[key] = Source(args.dumps / str(game) / (file + '.decl'),
                                args.ecl / folder / (file + '.ecl'), game)
        return cache[key]

    def record(game, key, file, sub, op, expected):
        src = source(game, file)
        row = next(r for r in src.subs[sub] if r.op == op and r.args == expected)
        rows.append(dict(game=game, key=key, source=file + ':' + sub, op=op, args=row.args,
                         address=hex(row.address), time=row.time, ecl_sha256=src.sha256))

    def bound_poses(game, role, entry=None):
        boss = lua.table_from(dict(ani=0, x=0, y=96))
        boss['class'] = lua.table_from(dict(StageLevel={6:30, 7:32}[game]))
        visual.bind_boss(lua.table_from(dict(obj=boss)), role, entry)
        return list(boss['_original_actor']['poses'].values()) if boss['_original_actor']['poses'] else None

    for key, entry in visual.th07_boss_entries.items():
        file, number = entry[5].split(':')
        record(7, key, file, 'Sub' + number, 95, [entry[3]])
        pose = next(r for r in source(7, file).subs['Sub' + number]
                    if r.op == 96 and r.args[0] == entry[3])
        raw = pose.args
        assert bound_poses(7, entry[1], lua.table_from([entry[2], entry[3], entry[4]])) == [raw[i] for i in (0, 3, 4, 1, 2)], key

    for key, entry in visual.th10_boss_entries.items():
        record(10, key, f'stage{entry[2]:02d}', 'MBoss' if key.endswith('mid') else 'Boss',
               259 if key == 's4mid' else 262, [0, entry[3]])

    constructors6 = dict(Rumia=(1, 8, 98), Daiyousei=(2, 20, 97), Chiruno=(2, 21, 98),
                         Meirin=(3, 10, 97), Koakuma=(4, 21, 97), Knowledge=(4, 26, 98),
                         Sakuya=(5, 12, 98), Remilia=(6, 15, 98), Flandre=(7, 31, 98))
    for role, (stage, number, op) in constructors6.items():
        file, sub = f'ecldata{stage}', f'Sub{number}'
        row = next(r for r in source(6, file).subs[sub] if r.op == op)
        assert row.args[0] == roles[6][role][2], role
        if op == 98:
            assert bound_poses(6, role) == [row.args[i] for i in (0, 3, 4, 1, 2)], role
        record(6, role, file, sub, op, row.args)

    for role, cfg in roles[8].items():
        archive = cfg[1]
        file = ('ecldata' + archive[3:-3] if archive[3:4].isdigit()
                else 'ecldata_' + archive.split('_')[1])
        # 所有同角色入口的主序列基址相同；验证库名和原作59操作数的对应。
        sub = next(sub for sub, ins in source(8, file).subs.items()
                   if any(r.op == 59 and r.args == [cfg[2]] and r.time == 0 for r in ins))
        record(8, role, file, sub, 59, [cfg[2]])

    scene = (args.th095 / 'src/SceneSelect.cpp').read_text('utf-8-sig')
    for role, cfg in roles[95].items():
        index = int(cfg[1][3:])
        assert re.search(fr'"enm{index}\.anm", "ecl{index}_a\.ecl"', scene), role
        file = f'ecl{index}_a'
        sub, row = next((sub, r) for sub, ins in source(95, file).subs.items() for r in ins
                        if sub == 'Sub2' and r.op == 55 and r.args == [cfg[2]])
        record(95, role, file, sub, row.op, [cfg[2]])

    args.output.write_text(json.dumps(rows, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f'五作原作ECL编号核对通过：{len(rows)} 个角色/出场，原始指令地址和SHA256已记录。')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dumps', type=Path, required=True)
    parser.add_argument('--ecl', type=Path, required=True)
    parser.add_argument('--th095', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    check(parser.parse_args())
