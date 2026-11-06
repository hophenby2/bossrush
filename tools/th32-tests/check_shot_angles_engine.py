"""在隔离Windows发行目录记录TH32全周随机弹的实际出生速度和八方位分布。"""
import argparse
import importlib.util
import json
from pathlib import Path
from types import SimpleNamespace


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--cases',default='3920,4010')
    parser.add_argument('--frames',type=int,default=1200)
    parser.add_argument('--speed',type=int,default=1)
    args=parser.parse_args()
    path=Path('tools/th3x-tests/native_engine.py').resolve()
    spec=importlib.util.spec_from_file_location('th3x_native_engine',path)
    engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
    prepare=engine.prepare
    def instrument(output):
        prepare(output)
        source=output/'native_test.lua'
        text=source.read_text('utf-8')
        assert text.count('return T')==1
        source.write_text(text.replace('return T',"dofile('angle_probe.lua')(T)\nreturn T"),'utf-8')
        (output/'angle_probe.lua').write_bytes(Path('tools/th32-tests/angle_engine_probe.lua').read_bytes())
    engine.prepare=instrument
    options=SimpleNamespace(output=args.output,games='32',cases=args.cases,frames=args.frames,
                            speed=args.speed,mode='timeout',flow='single',seed=20261106)
    try:engine.run(options)
    except SystemExit as error:
        if error.code:raise
    rows=json.loads((args.output/'th32-angle-probe.json').read_text('utf-8'))
    assert set(map(int,rows))==set(map(int,args.cases.split(','))), ('缺少真实弹体样本',rows.keys())
    for key,row in rows.items():
        assert row['count']>=100,(key,'样本不足',row['count'])
        assert all(row['octants']),(key,'角度仍集中在部分方向',row['octants'])
        print(f"卡{key}：{row['count']}枚整周随机弹，向左{row['left']} / 向右{row['right']}，八方位{row['octants']}")


if __name__=='__main__':main()
