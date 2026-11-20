#!/usr/bin/env python3
"""在隔离存档中采集 RogueTen 入场帧；正常速度，不截图、不改弹幕密度。"""
import argparse
from collections import defaultdict
import json
import os
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--out', required=True, type=Path)
parser.add_argument('--source')
parser.add_argument('--move-during-entry', action='store_true', help='入场边界强制改变自机位置，覆盖永夜失效快照重建')
parser.add_argument('--frames', type=int, default=480)
parser.add_argument('--retain-resources', action='store_true', help='仅用于同作重复入场的诊断对照')
parser.add_argument('--sample-lua', action='store_true', help='对永夜背景预演采集 LuaJIT 调用栈')
parser.add_argument('--timeout', type=int, default=400)
args = parser.parse_args()
assert not args.retain_resources or args.source, '保留资源对照必须限定单个作品，避免同名资源冲突'
out = args.out.resolve()
out.mkdir(parents=True, exist_ok=True)
binary = ROOT / 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
bundle = binary.parents[1] / 'Resources/game'
for name in ('android/lua/main.lua', 'macos/lua/test.lua', 'macos/lua/rogue_entry_profile.lua',
             'mod/roguelike.lua', 'mod/rogue_encounter.lua'):
    packed = name.replace('android/lua/', 'android/').replace('macos/lua/', 'macos/')
    assert (ROOT / name).read_bytes() == (bundle / packed).read_bytes(), '包内源码已过时：' + name
env = dict(os.environ, BOSSRUSH_MAC_DATA=str(out), BOSSRUSH_MAC_TEST='rogue-entry-profile',
           BOSSRUSH_ENTRY_FRAMES=str(args.frames), BOSSRUSH_ENTRY_RETAIN=str(int(args.retain_resources)),
           BOSSRUSH_ENTRY_SAMPLE=str(int(args.sample_lua)),
           BOSSRUSH_ENTRY_MOVE=str(int(args.move_during_entry)))
if args.source:
    env['BOSSRUSH_ENTRY_SOURCE'] = args.source
with (out / 'stdout.log').open('w') as log:
    process = subprocess.Popen([str(binary)], cwd=out, env=env, stdout=log, stderr=subprocess.STDOUT)
    deadline = time.monotonic() + args.timeout
    error = None
    while process.poll() is None and time.monotonic() < deadline:
        trace = out / 'lstg_log.txt'
        if trace.exists():
            errors = [line for line in trace.read_text(errors='replace').splitlines() if 'BOSSRUSH_ERROR:' in line]
            if errors:
                error = errors[-1]
                process.terminate()
                break
        time.sleep(.5)
    if process.poll() is None:
        if not error:
            error = '采集超时'
        process.kill()
    process.wait()
report = out / 'bossrush/User/rogue-entry-profile.json'
if error or process.returncode != 0 or not report.exists():
    raise SystemExit(error or f'采集未完成：exit={process.returncode}，日志 {out}')
result = json.loads(report.read_text())
summaries = []
for case in result['cases']:
    frames = [f for f in result['frames'] if f['case'] == case['index'] and f.get('fight_age', f['age']) <= args.frames]
    numbers = {f['frame'] for f in frames}
    totals = defaultdict(lambda: dict(count=0, ms=0, self_ms=0))
    for number in numbers:
        for name, calls in result['calls'].get(str(number), {}).items():
            for key in totals[name]:
                totals[name][key] += calls[key]
    summaries.append(dict(case, frames=len(frames),
        preparation_frames=sum(bool(f.get('preparing')) for f in frames),
        max_logic_ms=max(f['logic_ms'] for f in frames),
        max_render_ms=max(f.get('render_ms', 0) for f in frames),
        max_wall_ms=max(f.get('wall_ms', 0) for f in frames),
        cpu_over_16ms=sum(f['logic_ms'] + f.get('render_ms', 0) > 1000 / 60 for f in frames),
        operations=dict(totals),
        top_frames=sorted(frames, key=lambda f: f['logic_ms'] + f.get('render_ms', 0), reverse=True)[:4],
        top_events=sorted([e for e in result['events'] if e['frame'] in numbers],
                          key=lambda e: e['ms'], reverse=True)[:14]))
if args.move_during_entry:
    assert any(c.get('background_reprepares', 0) for c in result['cases']), '未触发背景位置重建'
summary = dict(data=str(report), retain_resources=args.retain_resources, speed=1,
               move_during_entry=args.move_during_entry,
               window_frames=args.frames, cases=summaries)
(out / 'summary.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2))
print(json.dumps({'passed': result['passed'], 'cases': len(summaries), 'data': str(report),
                  'summary': str(out / 'summary.json')}, ensure_ascii=False))
