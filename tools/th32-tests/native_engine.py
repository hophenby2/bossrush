#!/usr/bin/env python3
"""在临时应用和独立存档中测试 TH32；--prepare 只准备，--run 才启动图形应用。"""
from pathlib import Path
import argparse,json,os,shutil,subprocess,tempfile,time,signal
ROOT=Path(__file__).resolve().parents[2]

def prepare(output):
    output.mkdir(parents=True,exist_ok=True)
    app=output/'Boss Rush HD.app'
    if not app.exists():
        subprocess.run(['cp','-cR',str(ROOT/'macos/dist/Boss Rush HD.app'),str(app)],check=True)
    game=app/'Contents/Resources/game'
    for tree in ('THlib','mod'):
        for path in (ROOT/tree).rglob('*.lua'):
            target=game/path.relative_to(ROOT);target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,target)
    for name in ('core.lua','launch.lua','launcher.lua'):
        shutil.copy2(ROOT/name,game/name)
    shutil.copy2(ROOT/'tools/th32-tests/native_engine.lua',game/'macos/test.lua')
    subprocess.run(['codesign','--force','--deep','--sign','-',str(app)],check=True,stdout=subprocess.DEVNULL)
    (output/'manifest.json').write_text(json.dumps({'app':str(app),'prepared':time.time()},indent=2)+'\n')
    print('已准备临时应用：'+str(app),flush=True)

def run(output,frames,speed,card,shoot=False):
    manifest=json.loads((output/'manifest.json').read_text());app=Path(manifest['app'])
    with tempfile.TemporaryDirectory(prefix='th32-engine-data-') as sandbox:
        env=dict(os.environ,BOSSRUSH_MAC_DATA=sandbox,BOSSRUSH_MAC_TEST='th32',TH32_ENGINE_FRAMES=str(frames),TH32_ENGINE_SPEED=str(speed))
        if card:env['TH32_ENGINE_CARD']=str(card)
        if shoot:env['TH32_ENGINE_SHOOT']='1'
        logfile=output/('run-'+str(card or 'all')+'.log')
        with logfile.open('w') as log:
            p=subprocess.Popen([str(app/'Contents/MacOS/BossRushHD')],cwd=sandbox,env=env,stdout=log,stderr=subprocess.STDOUT)
            (output/'pid.json').write_text(json.dumps({'pid':p.pid,'binary':str(app/'Contents/MacOS/BossRushHD')}))
            try:code=p.wait(timeout=300)
            except subprocess.TimeoutExpired:
                p.terminate();p.wait(timeout=10);raise RuntimeError('原生测试超时：'+str(logfile))
        data=Path(sandbox)/'bossrush'
        for name in ('th32-engine.json','th32-progress.json'):
            path=data/'User'/name
            if path.exists():shutil.copy2(path,output/(str(card or 'all')+'-'+name))
        for path in (data/'snapshot').glob('th32-*.png'):
            shutil.copy2(path,output/path.name)
        log=logfile.read_text(errors='replace')
        assert code==0,(code,str(logfile))
        assert 'BOSSRUSH_ERROR:' not in log and 'BOSSRUSH_BOOT_ERROR:' not in log,str(logfile)
        result=json.loads((data/'User/th32-engine.json').read_text())
        assert result['count']==result['expected'],result
        summary={k:result[k] for k in ('count','expected','renderer','version')}
        summary['peak']=max(row['peak'] for row in result['records'])
        summary['frames']=sum(row['frames'] for row in result['records'])
        summary['defeats']=sum(row.get('defeats',0) for row in result['records'])
        summary['drops']=sum(row.get('drops',0) for row in result['records'])
        if shoot:assert summary['defeats']>0,'原生射击没有击破道中敌机'
        print('原生 Metal 验证通过：'+json.dumps(summary,ensure_ascii=False),flush=True)

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--prepare',action='store_true');parser.add_argument('--run',action='store_true');parser.add_argument('--stop',action='store_true');parser.add_argument('--frames',type=int,default=600);parser.add_argument('--speed',type=int,default=12);parser.add_argument('--card',type=int)
    parser.add_argument('--shoot',action='store_true',help='在原生测试中持续射击，检查普通敌机击破与掉落')
    args=parser.parse_args();output=args.output.resolve()
    if args.prepare:prepare(output)
    if args.stop:
        manifest=json.loads((output/'manifest.json').read_text());binary=str(Path(manifest['app'])/'Contents/MacOS/BossRushHD')
        for line in subprocess.check_output(['ps','-axo','pid=,command='],text=True).splitlines():
            fields=line.strip().split(None,1)
            if len(fields)==2 and fields[1].startswith(binary):os.kill(int(fields[0]),signal.SIGTERM)
    if args.run:run(output,args.frames,args.speed,args.card,args.shoot)
    assert args.prepare or args.run or args.stop
if __name__=='__main__':main()
