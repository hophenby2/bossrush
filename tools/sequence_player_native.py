"""隔离发行目录中的顺序模式原作机体验证；不启动用户的存档目录。"""
from pathlib import Path
import argparse
import importlib.util
import json
import subprocess
import os

ROOT=Path(__file__).resolve().parents[1]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--output',type=Path,required=True)
ap.add_argument('--probe',choices=['background','shots','drops','opening'])
args=ap.parse_args()
output=args.output.resolve()
assert output!=ROOT and ROOT not in output.parents, '验证输出必须放在发行目录以外'
assert not output.exists(),'使用新的隔离目录，避免旧结果混入'
spec=importlib.util.spec_from_file_location('native',ROOT/'tools/th3x-tests/native_engine.py')
native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
prepare_source=(ROOT/'tools/th3x-tests/native_engine.py').read_text('utf8').replace(
    "'shader', 'BadApple'", "'shader'")
exec(compile(prepare_source,str(ROOT/'tools/th3x-tests/native_engine.py'),'exec'),native.__dict__)
native.prepare(output)
(output/'native_test.lua').write_bytes(Path(__file__).with_suffix('.lua').read_bytes())
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
environment=dict(os.environ)
if args.probe:environment['SEQUENCE_PLAYER_PROBE']=args.probe
p=subprocess.Popen([str(output/'LuaSTGSub.exe')],cwd=output,startupinfo=startup,env=environment)
print('隔离引擎进程',p.pid,flush=True)
try:
    code=p.wait(timeout=240)
except subprocess.TimeoutExpired:
    p.terminate();p.wait(timeout=15)
    raise SystemExit('隔离引擎超时，已停止本次验证进程')
path=output/'sequence-player-result.json'
if not path.exists():
    print((output/'native-boot.log').read_text('utf8'))
    raise SystemExit('原生引擎没有生成结果')
report=json.loads(path.read_text('utf8'))
summary={k:report[k] for k in ('completed','expected','errors')}
summary['results']=[{**{k:r[k] for k in ('game','machine','power','score','drops')},
                    'opening_kills':sum('killed' in row for row in r.get('opening',[]))}
                   for r in report['results']] if report['results'] else []
print(json.dumps(summary,ensure_ascii=False))
expected=6 if args.probe=='opening' else 1 if args.probe else 29
assert code==0 and not report['errors'] and report['completed']==report['expected'] and report['expected']==expected
