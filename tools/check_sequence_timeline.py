"""逐条执行原始TH07时间轴的Boss门控与等待，核对Lua实际生成器的出场帧/指令地址。"""
from pathlib import Path
import argparse
import json
import subprocess
import sys

from export_sequence_timeline import native

ROOT = Path(__file__).resolve().parents[1]


def reference(metadata, native_events, origin, duration):
    timelines = [[] for _ in range(metadata['count'])]
    for e in native_events:
        if e['time'] >= origin:
            timelines[e['timeline']].append(e)
    times = [origin] * metadata['count']
    pointers = [0] * metadata['count']
    wave_addresses = set(metadata['addresses'])
    markers = set(metadata['markers'])
    born, output = None, []
    for frame in range(50000):
        boss = born is not None and frame < born + duration
        for index, rows in enumerate(timelines):
            p = pointers[index]
            held = False
            while p < len(rows) and rows[p]['time'] <= times[index]:
                e = rows[p]
                if e['time'] == times[index]:
                    if e['op'] <= 7 and not boss:
                        if e['address'] in markers:
                            born, boss = frame, True
                        elif e['address'] in wave_addresses:
                            output.append((frame, e['address']))
                    elif e['op'] == 12 and boss:
                        held = True
                        break
                p += 1
            pointers[index] = p
            if not held:
                times[index] += 1
        if times[metadata['primary']] >= origin + metadata['length']:
            return output
    raise AssertionError('原始时间轴未结束')


def main(workspace):
    # Lua只导出已载入的正式元数据；期望的执行逻辑来自上面的原始指令语义。
    code = '''local t=dofile('mod/GAME/original/sequence_timeline.lua')
for id,m in pairs(t) do
 local a,b={},{}
 for _,w in ipairs(m.waves) do a[#a+1]=w[2] end
 for _,p in pairs(m.midpoints) do b[#b+1]=p[3] end
 print(id..' '..m.origin..' '..m.count..' '..m.primary..' '..m.length..' '..table.concat(a,',')..' '..table.concat(b,','))
end'''
    data = subprocess.check_output(['luajit', '-e', code], cwd=ROOT, text=True)
    checked, cases = 0, []
    for line in sorted(data.splitlines()):
        sid, origin, count, primary, length, addresses, *markers = line.split()
        sid, origin = int(sid), int(origin)
        metadata = dict(count=int(count), primary=int(primary), length=int(length),
                        addresses=list(map(int, addresses.split(','))),
                        markers=list(map(int, markers[0].split(','))) if markers else [])
        _, events, _ = native(workspace / f'original/ECL/th07/ecldata{sid-3399}.ecl')
        for duration in (0, 300, 1300, 2400):
            expected = reference(metadata, events, origin, duration)
            result = subprocess.check_output(['luajit', 'tools/run_sequence_timeline.lua', str(sid), str(duration)], cwd=ROOT, text=True)
            actual = [tuple(map(int, row.split(','))) for row in result.splitlines()]
            if actual != expected:
                mismatch = next((i for i, (a, b) in enumerate(zip(actual, expected)) if a != b), min(len(actual), len(expected)))
                raise AssertionError((sid, duration, mismatch, actual[mismatch:mismatch+3], expected[mismatch:mismatch+3]))
            checked += len(actual)
            cases.append(dict(source_card=sid, midboss_frames=duration, spawns=len(actual)))
    print(json.dumps(dict(cases=len(cases), source_spawns_checked=checked, details=cases), ensure_ascii=False, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('workspace', type=Path)
    main(parser.parse_args().workspace)
