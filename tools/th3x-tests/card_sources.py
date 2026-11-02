"""给全量逐卡索引补充原作文件、入口和同步/异步/生成对象的静态调用闭包。"""
from collections import Counter
from pathlib import Path
import re

from ecl_source import Source

GAME = {31: 8, 32: 6, 33: 95, 34: 7, 35: 10}
# 道中不能冒充某一个Boss子程序；时间轴裁剪窗口仍须另行核对。
ROADS = {
    31: {3409: 1, 3410: 1, 3429: 2, 3428: 3, 3437: 3, 3412: '4a', 3416: '4a',
         3414: '4b', 3418: '4b', 3432: 5, 3435: 5, 3430: 6, 3431: 7, 3438: 8},
    34: {3400: 1, 3401: 2, 3402: 3, 3403: 4, 3404: 5, 3405: 6, 3406: 7, 3407: 8},
    35: {3680: 1, 3681: 2, 3682: 3, 3683: 4, 3684: 5, 3671: 6, 3685: 7},
}
# 参数下标按各作克隆解释器，不把TH08的生成指令套到TH095。
EDGES = {
    6: {35: 0, 37: 0, 38: 0, 39: 0, 40: 0, 41: 0, 42: 0, 95: 0},
    7: {41: 0, 92: 0, 93: 0, 144: 1},
    8: {52: 0, 88: 1, 89: 1, 90: 0, 91: 0, 92: 0, 93: 0, 94: 0, 135: 1},
    95: {52: 0, 84: 0, 117: 1},
    10: {op: 0 for op in (11, 15, 16, 256, 257, 260, 261, 265, 266, 267, 268, 270, 271)},
}


def attach(rows, cache, binaries):
    loaded = {}

    def get(game, file):
        key = (game, file)
        if key not in loaded:
            folder = cache.parent / 'source-assets/th095' if game == 95 else cache / 'ecl' / str(game)
            loaded[key] = Source(folder / (file + '.decl'),
                                 binaries / ('th095' if game == 95 else f'th{game:02}') / (file + '.ecl'), game)
        return loaded[key]

    lua35 = (Path(__file__).resolve().parents[2] / 'mod/GAME/th35.lua').read_text('utf-8').splitlines()
    for row in rows:
        number, card, meta = row['game'], row['id'], row['metadata']
        game, file, roots, timeline = GAME[number], None, [], False
        if number == 31:
            info = meta.get('th08_lastword_source') or meta.get('th08_motion_source')
            if info:
                file, roots = info['file'], ['Sub' + str(info['sub'])]
            elif card in (3436, 3433, 3434):
                file, roots = {3436: ('ecldata3', ['Sub20']), 3433: ('ecldata5', ['Sub38']),
                               3434: ('ecldata5', ['Sub45'])}[card]
        elif number == 32:
            info = meta.get('th06_source')
            if info:
                file = 'ecldata' + str(info['stage'])
                timeline = bool(info.get('road'))
                roots = [] if timeline else ['Sub' + str(info['sub'])]
            elif card == 368:
                row['source'] = {'kind': '自制条目', '说明': '克罗里·尤斯福德是仓库自制演出，没有TH06原作ECL。'}
                continue
            else:
                file, roots = 'ecldata6', ['Sub' + str({3802: 31, 3805: 33, 3808: 35, 3811: 39, 369: 44}[card])]
        elif number == 33:
            file = Path(meta['original_ecl']['file']).stem
            roots = [name for name, body in get(game, file).subs.items() if any(r.op == 141 for r in body)]
            assert len(roots) == 1, (card, roots)
        elif number == 34 and meta.get('th07_motion_source'):
            info = meta['th07_motion_source']
            file, roots = Path(info['file']).stem, ['Sub' + str(info['sub'])]
        elif number == 35:
            if card == 3600:
                file, roots = 'stage06', ['BossCard5']
            elif meta.get('main_source'):
                file, sub = meta['main_source'].split(':')
                roots = [sub]
            else:
                for place in row['implementation']:
                    if place['file'] == 'mod/GAME/th35.lua' and place['path'].endswith('/main'):
                        match = re.search(r'function s(\d)(?:n?\.|_)(\w+)\(', lua35[place['first'] - 1])
                        if match:
                            file, roots = f'stage{int(match[1]):02}', [match[2]]
        if card in ROADS.get(number, {}):
            stage = ROADS[number][card]
            file = f'stage{stage:02}' if game == 10 else 'ecldata' + str(stage)
            timeline = True
        assert file and (roots or timeline), (number, card, '未定位原作入口')
        source = get(game, file)
        # 风神录将时间轴也写成命名函数。
        if timeline and game == 10:
            roots = ['main']
        seen, pending, unresolved = set(), list(roots), []
        edges = []
        while pending:
            sub = pending.pop()
            if sub in seen:
                continue
            seen.add(sub)
            body = source.subs.get(sub)
            if body is None and game == 10:
                body = get(game, 'default').subs.get(sub)
            assert body is not None, (file, sub, '没有原作子程序')
            for instruction in body:
                at = EDGES[game].get(instruction.op)
                if at is None:
                    continue
                target = instruction.args[at]
                if isinstance(target, int):
                    if target < 0:
                        continue
                    target = 'Sub' + str(target)
                elif isinstance(target, str) and target.startswith('"'):
                    target = target[1:-1]
                else:
                    unresolved.append({'sub': sub, 'address': hex(instruction.address), 'op': instruction.op})
                    continue
                edges.append({'from': sub, 'to': target, 'address': hex(instruction.address), 'op': instruction.op,
                              'mask': instruction.mask, 'time': instruction.time})
                pending.append(target)
        row['source'] = {'game': game, 'file': file + '.ecl', 'sha256': source.sha256,
                         'kind': '时间轴' if timeline else '子程序', 'roots': roots,
                         'closure': sorted(seen), 'edges': edges, 'unresolved_targets': unresolved,
                         'scope': '静态调用闭包含各难度分支；未据此宣称语义通过。时间轴窗口及特殊回调另审。'}
    return Counter(row['source']['kind'] for row in rows)
