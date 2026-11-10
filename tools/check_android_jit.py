#!/usr/bin/env python3
"""在显式选择的Android ARM64设备验证与APK相同的LuaJIT源码运行时。"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SDK = Path(os.environ.get('ANDROID_HOME', str(Path.home() / 'Library/Android/sdk')))
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--serial', required=True)
parser.add_argument('--adb', type=Path, default=SDK / 'platform-tools/adb')
parser.add_argument('--ndk', type=Path, default=Path(os.environ.get('ANDROID_NDK_HOME', str(SDK / 'ndk/26.3.11579264'))))
parser.add_argument('--output', type=Path, default=ROOT / 'android/build/jit-check')
args = parser.parse_args()
sys.path.insert(0, str(ROOT / 'android'))
from build_luajit import build

library = build(args.ndk, 8)
tools = next(p for p in (args.ndk / 'toolchains/llvm/prebuilt').iterdir() if p.is_dir()) / 'bin'
compiler = tools / ('aarch64-linux-android28-clang' + ('.cmd' if os.name == 'nt' else ''))
args.output.mkdir(parents=True, exist_ok=True)
binary = args.output / 'jit-check'
subprocess.run([str(compiler), '-O2', '-fPIE', '-pie', '-I' + str(library.parent),
                str(ROOT / 'tools/check_android_jit.c'), str(library), '-lm', '-ldl', '-o', str(binary)], check=True)
base = [str(args.adb), '-s', args.serial]
remote = '/data/local/tmp/bossrush-jit-check'
try:
    subprocess.run(base + ['push', str(binary), remote], check=True)
    subprocess.run(base + ['shell', 'chmod', '755', remote], check=True)
    run = subprocess.run(base + ['shell', remote], capture_output=True, text=True,encoding='utf-8')
    (args.output / 'runtime.log').write_text(run.stdout + run.stderr,encoding='utf-8')
    print(run.stdout + run.stderr)
    run.check_returncode()
    result = {'serial': args.serial, 'passed': True, 'runtime': json.loads((ROOT / 'android/luajit.lock.json').read_text(encoding='utf-8')),
              'library_sha256': hashlib.sha256(library.read_bytes()).hexdigest(), 'output': run.stdout}
    (args.output / 'result.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n',encoding='utf-8')
finally:
    subprocess.run(base + ['shell', 'rm', '-f', remote], check=False, stdout=subprocess.PIPE)
