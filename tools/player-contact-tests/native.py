"""隔离真引擎验证六作实体弹的致死、保护期、复活期接触消散与旧录像语义。"""
from pathlib import Path
import argparse
import importlib.util
import json

ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--output',type=Path,required=True)
args=ap.parse_args()
spec=importlib.util.spec_from_file_location('native_engine',ROOT/'tools/th3x-tests/native_engine.py')
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
prepare=engine.prepare
def instrument(output):
    prepare(output)
    path=output/'native_test.lua';source=path.read_text('utf8')
    anchor='                    if host.th36_session then'
    assert source.count(anchor)==1
    source=source.replace(anchor,'                    PlayerContactProbe(host,frames,current)\n'+anchor)
    path.write_text(Path(__file__).with_suffix('.lua').read_text('utf8')+'\n'+source,'utf8',newline='\n')
engine.prepare=instrument
try:
    engine.run(argparse.Namespace(output=args.output,games='36',cases='11042',frames=600,speed=600,
        mode='timeout',flow='single',seed=20261031))
except SystemExit as result:
    if result.code:raise
rows=json.loads((args.output/'native-player-contact.json').read_text('utf8'))
assert len([r for r in rows if r.get('despawn')])==54
assert any(r.get('cleanup') and r['count']==54 for r in rows)
print('六作54种实体弹接触消散通过，含致死、无敌、复活和三种弹组；消散后全部回收。')
