#!/usr/bin/env python3
"""在隔离存档和同一真实引擎进程中验证跨作品练习、特殊系统 HUD 与樱花环。"""
import argparse
import json
import os
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--out', type=Path, required=True)
parser.add_argument('--suite', choices=['cross', 'systems'], default='systems')
parser.add_argument('--portrait', action='store_true')
args = parser.parse_args()
out = args.out.resolve()
out.mkdir(parents=True, exist_ok=True)
env = dict(os.environ, BOSSRUSH_MAC_DATA=str(out), BOSSRUSH_MAC_TEST='practice-systems',
           BOSSRUSH_MAC_TEST_SUITE=args.suite, BOSSRUSH_MAC_TEST_PORTRAIT='1' if args.portrait else '0')
with (out / 'stdout.log').open('w') as log:
    process = subprocess.Popen([str(ROOT / 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD')],
                               cwd=out, env=env, stdout=log, stderr=subprocess.STDOUT)
    deadline = time.monotonic() + 300
    while process.poll() is None and time.monotonic() < deadline:
        trace = out / 'lstg_log.txt'
        if trace.exists() and 'BOSSRUSH_ERROR:' in trace.read_text(errors='replace'):
            process.terminate()
            process.wait(timeout=5)
            break
        time.sleep(.2)
    if process.poll() is None:
        process.kill()
        process.wait()
report = out / 'bossrush/User/mac-test.json'
assert process.returncode == 0 and report.exists(), ('练习系统回归失败，见', str(out), process.returncode)
result = json.loads(report.read_text())
assert result['passed']
print(json.dumps(result, ensure_ascii=False))
