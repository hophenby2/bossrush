"""保留风神录 playSound 的调用、标量、等待和跳转；不导出发弹或运动执行器。"""
import argparse
import hashlib
import importlib.util
import json
import sys
sys.dont_write_bytecode = True
from pathlib import Path

from ecl_source import Source, Variable

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('sound_serializer', Path(__file__).with_name('export_original_anm.py'))
serializer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(serializer)


def export(workspace):
    out = ROOT / 'mod/GAME/original/sound_programs.d'
    out.mkdir(exist_ok=True)
    evidence = []
    common = Source(workspace/'decompiled/ecl/10/default.decl', workspace/'original/ECL/th10/default.ecl', 10)
    for file in sorted((workspace/'original/ECL/th10').glob('stage*.ecl')):
        source = Source(workspace/'decompiled/ecl/10'/(file.stem+'.decl'), file, 10)
        subs = {**common.subs, **source.subs}
        active = {name for name, rows in subs.items() if any(i.op == 336 for i in rows)}
        while True:
            prior = len(active)
            active.update(name for name, rows in subs.items() if any(
                i.op in (11, 15, 16) and str(i.args[0]).strip('"') in active for i in rows))
            if prior == len(active):
                break
        programs = {}
        for name, rows in subs.items():
            # 同步子程序即使不直接播放音效，也可能修改调用者之后使用的标量。
            owner = source if name in source.subs else common
            positions = {i.address: n+1 for n, i in enumerate(rows)}
            program = []
            for i in rows:
                args = []
                for a in i.args:
                    if isinstance(a, Variable):
                        a = {'var': a.index}
                    elif isinstance(a, str):
                        a = positions[owner.labels[a]] if a in owner.labels else a.strip('"')
                    args.append(a)
                # 仅保留调度/标量和 playSound，其余指令保留弹栈操作数，维持表达式栈。
                op = i.op if i.op <= 87 or i.op in (336, 349, 350, 351, 352, 353, 354, 355, 356, 368) else 0
                if op == 0:
                    args = [a for a in args if isinstance(a, dict) and a.get('var') == -1]
                program.append([i.time, op, i.mask, *args])
                if i.op == 336:
                    evidence.append(dict(file=file.name, sub=name, address=hex(i.address), time=i.time, sound=i.args[0]))
            programs[name] = program
        text = '-- 风神录原二进制核对的音效调度；不产生运动、子弹或敌机。\nreturn '+serializer.lua({'scripts': programs, 'active': {n: True for n in active}})+'\n'
        (out/('10_'+file.stem+'.lua')).write_text(text)
        evidence.append(dict(file=file.name, sha256=hashlib.sha256(file.read_bytes()).hexdigest()))
    (out.parent/'sound_programs_manifest.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2)+'\n')
    print('风神录音效源点', sum('sound' in row for row in evidence))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('workspace', type=Path)
    export(parser.parse_args().workspace)
