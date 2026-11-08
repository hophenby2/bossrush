"""在隔离Windows发行目录捕获妖梦缓时，核对原作背景interrupt2/1及撤销遮罩。"""
from pathlib import Path
import argparse
import importlib.util
import json
import shutil

spec=importlib.util.spec_from_file_location('native_engine',Path(__file__).with_name('native_engine.py'))
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
prepare=engine.prepare


def prepare_probe(output):
    prepare(output)
    shutil.copy2(Path(__file__).with_suffix('.lua'),output/'native_slow.lua')
    path=output/'native_test.lua';source=path.read_text(encoding='utf-8-sig')
    anchor='                    if host.th36_session then';assert source.count(anchor)==1
    source="local SlowProbe=dofile('native_slow.lua')\n"+source.replace(anchor,'                    SlowProbe(host,frames,current)\n'+anchor)
    anchor='                -- 大批推进只改变验证的墙钟时间';assert source.count(anchor)==1
    source=source.replace(anchor,'                if SlowNeedRender() then break end\n'+anchor)
    path.write_text(source,encoding='utf-8')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--baseline',action='store_true');args=parser.parse_args()
    engine.prepare=prepare_probe
    args.games,args.cases='34','4410' if args.baseline else '4391,4403,4405,4407,4408,4409,4410'
    args.frames,args.speed,args.seed=1500,600,20261108
    args.mode,args.flow='timeout','single'
    try:
        engine.run(args)
    except SystemExit as status:
        if status.code==0:
            result=json.loads((args.output/'slow-result.json').read_text('utf-8'))
            for id,row in result.items():
                assert row['restored'] and row['normalFactor']==1,(id,row)
                if args.baseline:
                    assert row['overlays']==1,(id,row)
                else:
                    assert row['overlays']==0,(id,row)
                    base,ring=row['slow'];normal=row['normal']
                    if id=='4391':
                        # 六面中Boss沿用eff06，原脚本没有interrupt2，原作也不额外叠遮罩。
                        assert row['factor']==1 and base['alpha']==255 and ring['alpha']==224,(id,row)
                        assert row['slow']==row['normal'] or all(vm['color']==[255,255,255] and vm['blend']=='' for vm in row['slow']),(id,row)
                    else:
                        assert base['alpha']==64 and base['color']==[255,64,64],(id,base)
                        assert ring['color']==[255,96,255] and ring['blend']=='mul+add',(id,ring)
                        assert all(vm['alpha']==255 and vm['color']==[255,255,255] for vm in normal),(id,normal)
                        assert normal[1]['blend']=='',(id,normal)
            assert len(result)==len(args.cases.split(',')),result
            print('缓时背景及恢复截图、原作颜色/混合模式检查通过。',flush=True)
        raise
