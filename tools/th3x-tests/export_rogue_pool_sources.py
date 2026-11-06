"""从已逐卡核对的源清单导出随机十战白名单；不运行Lua/ECL，不修改玩家数据。"""
import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
INDEX = ROOT / 'tools/th3x-tests/card-audit-index.json'
NATIVE = {31: 8, 32: 6, 34: 7, 35: 10}


def classify(row):
    game, source = row['game'], row['source']
    if source.get('game') != NATIVE[game]:
        return None, '自制条目'
    metadata = row.get('metadata', {})
    if game == 31 and 'th08_lastword_source' in metadata:
        return None, 'Last Word独立模式'
    filename = source['file']
    kind = 'road' if source['kind'] == '时间轴' else 'boss'
    if game == 34:
        if filename == 'ecldata8.ecl':
            return ('phantasm', kind), None
        rank = metadata.get('th07_motion_source', {}).get('difficulty', 3)
        if rank != 3:
            return None, {1: 'Normal', 2: 'Hard'}[rank]
    extra = filename == {31: 'ecldata8.ecl', 32: 'ecldata7.ecl',
                         34: 'ecldata7.ecl', 35: 'stage07.ecl'}[game]
    difficulty = 'extra' if extra else 'lunatic'
    return (difficulty, kind), None


def export():
    rows = [r for r in json.loads(INDEX.read_text())['cards'] if r['game'] in NATIVE]
    groups = defaultdict(list)
    excluded = []
    for row in rows:
        tag, reason = classify(row)
        if tag:
            groups[row['game'], *tag].append(row)
        else:
            excluded.append((row, reason))
    lines = ['-- 随机十战已核对的原作来源白名单；由export_rogue_pool_sources.py导出。',
             '-- 难度取实际ECL来源/实现分支，不按卡名、Boss名或注册顺序猜测。',
             '-- Phantasm保留原作来源标签，抽取时与Extra共用一个开关；不含文花帖/独立Last Word/自制。',
             'return {']
    for game in NATIVE:
        lines.append(f'    TH{game}={{')
        for difficulty in ('lunatic', 'extra', 'phantasm'):
            if difficulty == 'phantasm' and not any(groups[game, difficulty, k] for k in ('boss', 'road')):
                continue
            lines.append(f'        {difficulty}={{')
            for kind in ('boss', 'road'):
                items = groups[game, difficulty, kind]
                lines.append('            ' + kind + '={')
                for i in range(0, len(items), 12):
                    lines.append('                ' + ','.join(str(r['id']) for r in items[i:i+12]) + ',')
                lines.append('            },')
            lines.append('        },')
        lines.append('    },')
    lines.append('}')
    (ROOT / 'mod/rogue_pool_sources.lua').write_text('\n'.join(lines) + '\n')
    report = ['# 随机十战抽取来源（2026-11-06）', '',
              '准备界面选择四作、Lunatic与Extra/Phantasm、Boss/道中；Boss包括符卡、非符与中Boss。'
              '每组至少保留一项；按筛选后的总池无放回抽十张，不足十张禁止开始，不跨池补抽。', '',
              '仅收录已核对来源的卡号。妖妖梦ecldata8的23个Phantasm条目并入Extra/Phantasm开关。'
              'TH34显式Normal/Hard分支、TH31独立Last Word与TH32自制条目仍排除。', '',
              '| 来源 | L Boss | L 道中 | EX/PH Boss | EX/PH 道中 |', '| --- | ---: | ---: | ---: | ---: |']
    for game in NATIVE:
        counts = [sum(len(groups[game, d, k]) for d in difficulties) for difficulties, k in
                  [(('lunatic',), 'boss'), (('lunatic',), 'road'), (('extra', 'phantasm'), 'boss'),
                   (('extra', 'phantasm'), 'road')]]
        report.append(f'| TH{game} | ' + ' | '.join(map(str, counts)) + ' |')
    report += ['', f'全开共{sum(map(len, groups.values()))}个候选；排除{len(excluded)}项。', '',
               '## 排除条目', '', '| 来源/卡号 | 卡名 | 原ECL入口 | 排除原因 |', '| --- | --- | --- | --- |']
    for row, reason in excluded:
        source = row['source']
        original = source.get('file', '无原作ECL') + ':' + '/'.join(source.get('roots', []))
        report.append(f"| TH{row['game']}/{row['id']} | {row['name']} | `{original}` | {reason} |")
    report += ['', '## 分类依据', '',
               '- 原始文件与入口：`tools/th3x-tests/card-audit-index.json`，逐行记录见同目录`ECL_LINE_REVIEW_2026-11-05.md`。',
               '- TH34的Normal/Hard采用`th07_motion_source.difficulty`的实际实现分支（1/2）；'
               '例如ecldata1/Sub39在0x4e10以mask03设置Sub48，ecldata3/Sub37在0x4f20/0x4f30以mask03/04选择Sub50/52。',
               '- TH34/4468虽然Sub68有共同回调入口，移植卡明确使用Normal分支，仍排除；不能仅凭被共用子程序引用就判为L。',
               '- Extra按原作扩展关ECL文件，TH34的ecldata8为Phantasm，TH31的ecldata8为Extra；两个原作来源均由Extra/Phantasm开关控制。',
               '- 道中取已审阅清单的时间轴类型，不再通过标题包含“道中”猜测。',
               '- 筛选与卡池版本在开局前写入录像/续玩初态；未带版本的旧录像使用旧抽取算法；版本2仍排除Phantasm以保留旧路线，新局版本3使用合并池。',
               '', '按此前要求未运行测试、游戏或构建；本工具只读取已有源清单并导出白名单及报告。', '']
    (ROOT / 'tools/th3x-tests/ROGUE_POOL_SOURCES_2026-11-06.md').write_text('\n'.join(report))
    print('白名单', sum(map(len, groups.values())), '排除', len(excluded), dict(Counter(r for _, r in excluded)))


if __name__ == '__main__':
    argparse.ArgumentParser(description=__doc__).parse_args()
    export()
