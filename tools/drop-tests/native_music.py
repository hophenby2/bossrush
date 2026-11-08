"""在独立Windows发行目录验证正式BGM音源切换；快进计时，不修改歌曲循环点。"""
from pathlib import Path
import argparse
import importlib.util
import json
import shutil

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('native_engine',ROOT/'tools/th3x-tests/native_engine.py')
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
prepare=engine.prepare


def prepare_music(output):
    prepare(output)
    shutil.copy2(Path(__file__).with_suffix('.lua'),output/'native_music.lua')
    path=output/'native_test.lua';source=path.read_text(encoding='utf-8-sig')
    anchor='                    if host.th36_session then'
    assert source.count(anchor)==1
    source="local MusicProbe=dofile('native_music.lua')\n"+source.replace(anchor,'                    MusicProbe(host,frames,current)\n'+anchor)
    anchor='                DoFrame()'
    assert source.count(anchor)==1
    source=source.replace(anchor,anchor+"\n                ext.MusicFrame('timer');ext.MusicFrame('faketimer')")
    anchor='                if started and #records==#entries then'
    assert source.count(anchor)==1
    source=source.replace(anchor,anchor+'\n                    if settle==0 then lstg.var.dead=10 end')
    anchor='                    if settle>=120 then complete=true;save(true);break end'
    assert source.count(anchor)==1
    source=source.replace(anchor,anchor+'\n                    if settle==1 or settle==90 then break end')
    path.write_text(source,encoding='utf-8')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    engine.prepare=prepare_music
    args.games,args.cases,args.frames,args.speed='35','3601',1800,1800
    args.seed,args.mode,args.flow=20261108,'timeout','single'
    try:
        engine.run(args)
    except SystemExit as status:
        if status.code==0:
            data=json.loads((args.output/'music-result.json').read_text(encoding='utf-8'))
            assert data['cycle']==3 and data['plays']==27 and data['stopped'] and data['pausedChecked']
            songs=data['history'];assert len(songs)==27
            assert all(a!=b for a,b in zip(songs,songs[1:]))
            assert all(len(set(songs[i:i+9]))==9 for i in range(0,27,9))
            print('真实九首音源的三轮不重复、循环点切换、暂停/恢复和结算停止检查通过。',flush=True)
        raise
