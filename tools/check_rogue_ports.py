#!/usr/bin/env python3
"""在隔离存档中运行真实 RogueTen 跨作回归，须先更新 Mac 应用资源。"""
import argparse
import json
import os
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--out', type=Path, required=True)
parser.add_argument('--speed', type=int, default=8)
parser.add_argument('--timeout', type=int, default=600)
parser.add_argument('--source', help='仅运行指定作品，例如 TH42；元数据仍审计完整卡池')
args = parser.parse_args()
out = args.out.resolve()
out.mkdir(parents=True, exist_ok=True)
binary = ROOT / 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
bundle = binary.parents[1] / 'Resources/game'
for name in ('mod/roguelike.lua', 'mod/rogue_pool.lua', 'mod/rogue_ports.lua',
             'mod/rogue_encounter.lua', 'mod/rogue_music.lua', 'THlib/rogue_hp.lua',
             'THlib/UI/rogue_pool.lua', 'mod/GAME/th37.lua', 'mod/GAME/th42.lua',
             'mod/GAME/th43.lua', 'macos/lua/rogue_ports_test.lua'):
    assert (ROOT / name).read_bytes() == (bundle / name.replace('macos/lua/', 'macos/')).read_bytes(), \
        'Mac 包内资源不是当前源码：' + name
env = dict(os.environ, BOSSRUSH_MAC_DATA=str(out), BOSSRUSH_MAC_TEST='rogue-ports',
           BOSSRUSH_MAC_TEST_SPEED=str(args.speed))
if args.source:
    env['BOSSRUSH_MAC_TEST_SOURCE'] = args.source
with (out / 'stdout.log').open('w') as log:
    process = subprocess.Popen([str(binary)], cwd=out, env=env, stdout=log, stderr=subprocess.STDOUT)
    deadline = time.monotonic() + args.timeout
    error = None
    while process.poll() is None and time.monotonic() < deadline:
        trace = out / 'lstg_log.txt'
        if trace.exists():
            lines = [line for line in trace.read_text(errors='replace').splitlines() if 'BOSSRUSH_ERROR:' in line]
            if lines:
                error = lines[-1]
                process.terminate()
                break
        time.sleep(.2)
    if process.poll() is None:
        if error:
            process.wait(timeout=10)
        else:
            process.kill()
            process.wait()
            error = '原生回归超时'
report = out / 'bossrush/User/mac-test.json'
if error or process.returncode != 0 or not report.exists():
    raise SystemExit(error or f'回归未完成：exit={process.returncode}，日志 {out}')
result = json.loads(report.read_text())
assert result['passed']
print(json.dumps({'passed': True, 'cases': len(result['cases']), 'counts': result['counts']}, ensure_ascii=False))
