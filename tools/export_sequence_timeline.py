"""从TH07原始ECL核对保留波次的时间轴归属、WAIT_BOSS及中Boss交接地址。"""
from pathlib import Path
import argparse
import collections
import hashlib
import json
import struct
import subprocess

ROOT = Path(__file__).resolve().parents[1]
MIDPOINTS = {1: {3257: 20}, 3: {403: 13, 1408: 22}, 6: {1194: 18}, 7: {3520: 54}, 8: {3420: 56}}


def native(path):
    data = path.read_bytes()
    count = struct.unpack_from('<h', data, 2)[0]
    events = []
    for timeline in range(count):
        address = struct.unpack_from('<I', data, 4 + timeline * 4)[0]
        while struct.unpack_from('<h', data, address)[0] >= 0:
            time, sub, op, size = struct.unpack_from('<hhhh', data, address)
            event = dict(time=time, timeline=timeline, sub=sub, op=op, address=address)
            if op <= 7:
                x, y, _ = struct.unpack_from('<fff', data, address + 8)
                event.update(x=x - 192, y=224 - y)
            events.append(event)
            address += size
    return count, events, hashlib.sha256(data).hexdigest()


def matches(stage, event, sub, x, y):
    if event['op'] > 7:
        return False
    if stage == 5 and isinstance(sub, int) and sub not in (22, 23, 24):
        sub -= 1  # 五面波表保存子体号，原时间轴先创建前一号的载体。
    return ((not isinstance(sub, int) or event['sub'] == sub)
            and abs(x - event['x']) < .01 and abs(y - event['y']) < .01)


def export(workspace):
    result = subprocess.check_output(['luajit', 'tools/sequence_registry.lua'], cwd=ROOT, text=True)
    registry = {r['id']: r for r in map(json.loads, result.splitlines())}
    lines = ['-- 由原始ECL二进制逐波核对；每项为{时间轴号,原指令地址}，不是合并后的数组下标。', 'return {']
    report = {}
    for stage in range(1, 9):
        card = registry[3399 + stage]
        count, events, digest = native(workspace / f'original/ECL/th07/ecldata{stage}.ecl')
        rows, time = [], 0
        for wave in card['waves']:
            time += wave[0]
            rows.append((time, wave[1], wave[2], wave[3]))
        candidates = collections.Counter()
        for t, sub, x, y in rows[:30]:
            for e in events:
                if matches(stage, e, sub, x, y):
                    candidates[e['time'] - t] += 1
        options = []
        for origin, _ in candidates.most_common(12):
            taken, sources = set(), []
            for t, sub, x, y in rows:
                found = [e for e in events if e['time'] == t + origin and e['address'] not in taken
                         and matches(stage, e, sub, x, y)]
                if not found:
                    break
                e = min(found, key=lambda v: (v['timeline'], v['address']))
                taken.add(e['address'])
                sources.append(e)
            if len(sources) == len(rows):
                options.append((origin, sources))
        assert len(options) == 1, (stage, '波表必须唯一、完整地对应原时间轴', len(options))
        origin, sources = options[0]
        # 六面原卡只覆盖中Boss之前；战后至幽幽子对话的空档仍属于同一原作时间轴。
        length = 2518 - origin if stage == 6 else card['length']
        lines.append(f'[{card["id"]}]={{origin={origin},count={count},primary={1 if stage in (1,4) else 0},length={length},')
        lines.append('waves={' + ','.join('{' + str(e['timeline']) + ',' + str(e['address']) + '}' for e in sources) + '},')
        lines.append('waits={')
        for timeline in range(count):
            waits = [e for e in events if e['timeline'] == timeline and e['op'] == 12
                     and 0 <= e['time'] - origin <= length]
            lines.append(f'[{timeline}]={{' + ','.join('{' + str(e['time']-origin) + ',' + str(e['address']) + '}' for e in waits) + '},')
        lines.append('},midpoints={')
        for point, sub in MIDPOINTS.get(stage, {}).items():
            # 用原始创建入口定位，不沿用练习窗口的分割帧；例如一面中Boss实际在2667帧。
            found = [e for e in events if e['op'] <= 7 and e['timeline'] == 0 and e['sub'] == sub]
            assert len(found) == 1, (stage, point, found)
            e = found[0]
            lines.append(f'["{point}"]={{{e["time"]-origin},{e["timeline"]},{e["address"]}}},')
        lines.append('}},')
        report[stage] = dict(source_sha256=digest, source_waves=len(sources), origin=origin, length=length)
    lines.append('}')
    (ROOT / 'mod/GAME/original/sequence_timeline.lua').write_text('\n'.join(lines) + '\n')
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('workspace', type=Path)
    export(parser.parse_args().workspace)
