"""导出顺序模式的原作界面ANM和字体像素；不重画原作素材。"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('anm',ROOT/'tools/th3x-tests/export_original_anm.py')
anm=importlib.util.module_from_spec(spec);spec.loader.exec_module(anm)
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--source',type=Path,default=Path('E:/workspace/原作'))
ap.add_argument('--cache',type=Path,default=Path('E:/workspace/.bossrush-validation/sequence-ui-export'))
ap.add_argument('--thtk',type=Path,default=Path('E:/workspace/thtkGUI-th20tr/thtk/thtk-th20'))
args=ap.parse_args()
manifest={}
for game in (6,7,8,95,10):
    cache=args.cache/str(game);cache.mkdir(parents=True,exist_ok=True)
    selected={}
    for dat in args.source.rglob('*'):
        if not dat.is_file():continue
        if not (dat.name.startswith('紅魔郷') and dat.suffix=='.DAT' if game==6 else dat.name.lower()==f'th{game:02}.dat' if game!=95 else dat.name.lower()=='th095.dat'):continue
        names=[line.split()[0] for line in anm.run([args.thtk/'thdat.exe','-l',game,dat]).splitlines()[1:] if line.split()]
        assets=[n for n in names if Path(n).name.lower().startswith(('front','ascii','times')) and n.lower().endswith(('.anm','.bmp','.png'))]
        if not assets:continue
        anm.run([args.thtk/'thdat.exe','-C',cache,'-x',game,dat,*assets])
        for n in assets:
            if n.lower().endswith('.anm'):selected[n]=dat
    assert selected,('缺少原作界面资源',game)
    dest=ROOT/'Resources/Original'/str(game);dest.mkdir(parents=True,exist_ok=True)
    for name,dat in selected.items():
        archive=Path(name).stem;path=cache/name
        decl=anm.run([args.thtk/'thanm.exe','-l',game,path])
        (cache/(archive+'.decl')).write_text(decl,'utf8')
        if game!=6:anm.run([args.thtk/'thanm.exe','-x',game,path],cwd=cache)
        data=anm.parse(decl,cache,dest,game,archive)
        data.update(game=game,archive=archive)
        (cache/(archive+'.json')).write_text(json.dumps(data),'utf8')
        output=ROOT/'mod/GAME/original'/str(game)/(archive+'.lua')
        body='return '+anm.lua(data)+'\n'
        # times已经由关卡演出导出；数据相同时保留旧文件注释和换行，避免无关改动。
        previous=output.read_text('utf8') if output.exists() else ''
        if previous.partition('\n')[2].strip()!=body.strip():
            output.write_text('-- 原作界面ANM与字体精灵；由tools/export_sequence_ui.py导出。\n'+body,'utf8',newline='\n')
        manifest[f'{game}/{archive}']={'source':dat.name,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'sprites':len(data['sprites']),'scripts':len(data['scripts'])}
    print(game,', '.join(Path(n).stem for n in selected),flush=True)
target=ROOT/'mod/GAME/original/ui';target.mkdir(exist_ok=True)
(target/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n','utf8')
