"""渲染人工逐卡核对清单；只读源文件，不运行ECL或Lua，不自动勾选。"""
import argparse
import hashlib
import json
from pathlib import Path

from ecl_source import Source

ROOT = Path(__file__).resolve().parents[2]
STEM = 'ECL_LINE_REVIEW_2026-11-05'


def render(workspace):
    folder = Path(__file__).parent
    index = json.loads((folder / 'card-audit-index.json').read_text())['cards']
    manual = json.loads((folder / (STEM + '.json')).read_text())
    completed = manual['reviews']
    cache = {}
    lines = ['# TH31–TH35 ECL逐卡逐行核对', '',
             '这份清单取代历史报告中的笼统“类别完成”结论。历史静态扫描、调用闭包和源点数量均不自动计为逐卡完成。', '',
             '勾选条件：人工读完该卡在目标难度下的根程序、同步调用、并行context、生成实体及相关共享运行逻辑；'
             '记录源地址、逐段对应关系、修复和阶段接口。未完成的卡保持空框。这里只声明静态源码核对，不声明实机等价。', '',
             '保留Boss Rush的阶段入口/结束、HP换算和自机接口；原作过场、计分与道具系统不属于攻击窗口。'
             '例如独立练习缺少上一段历史时的初始化映射必须单独记载，不能冒充原作历史。', '',
             '**按用户要求未运行测试、游戏、Lua、ECL模拟或构建。**', '']
    done = sum(f"{r['game']}/{r['id']}" in completed for r in index)
    lines += [f'当前：{done}/521张原作条目逐行核对完成；{521-done}张未完成；另1张为自制条目。', '']
    for game in range(31, 36):
        lines += [f'## TH{game}', '']
        for row in index:
            if row['game'] != game:
                continue
            key = f"{game}/{row['id']}"
            source = row['source']
            if not source.get('game'):
                lines += [f"- 自制：TH{key} {row['name']}（无原作ECL，不计入完成数）"]
                continue
            checked = 'x' if key in completed else ' '
            roots = '/'.join(source['roots']) or '时间轴窗口待逐行核对'
            detail = f'；[核对记录](#{game}-{row["id"]})' if key in completed else ''
            lines += [f"- [{checked}] TH{key} {row['name']} — `{source['file']}:{roots}`{detail}"]
        lines.append('')
    for row in index:
        key = f"{row['game']}/{row['id']}"
        if key not in completed:
            continue
        review = completed[key]
        lines += [f'<a id="{key.replace("/", "-")}"></a>',
                  f"## TH{key} {row['name']}", '']
        lines += [f'- {note}' for note in review['findings']]
        if review.get('boundaries'):
            lines += ['', '阶段接口：' + review['boundaries']]
        lines += ['', '| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |',
                  '| --- | --- | --- |']
        evidence = []
        for part in review['subprograms']:
            game, filename, sub = part['game'], part['file'], part['sub']
            source_key = game, filename
            if source_key not in cache:
                name = Path(filename).stem
                cache[source_key] = Source(
                    workspace / 'decompiled/ecl' / str(game) / (name + '.decl'),
                    workspace / 'original/ECL' / ('th095' if game == 95 else f'th{game:02}') / (name + '.ecl'), game)
            source = cache[source_key]
            instructions = source.subs[sub]
            # 指令清单只是已人工审阅子程序的地址证据，不能替未审阅卡生成通过状态。
            addresses = ', '.join(f'`0x{i.address:x}`' for i in instructions)
            lines += [f"| `{filename}:{sub}` | {addresses} | {part['note']} |"]
            evidence += [dict(file=filename, sub=sub, game=game, sha256=source.sha256,
                              instructions=[dict(address=hex(i.address), time=i.time, op=i.op,
                                                 mask=i.mask) for i in instructions])]
        review['source_evidence'] = evidence
        review['implementation_sha256'] = {
            filename: hashlib.sha256((ROOT / filename).read_bytes()).hexdigest()
            for filename in review['implementation']}
        lines.append('')
    manual['completed'], manual['pending'] = done, 521-done
    (folder / (STEM + '.json')).write_text(json.dumps(manual, ensure_ascii=False, indent=2) + '\n')
    (folder / (STEM + '.md')).write_text('\n'.join(lines))
    print(f'人工完成 {done}/521；未完成 {521-done}；未执行游戏代码')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('workspace', type=Path)
    render(parser.parse_args().workspace)
