"""建立独立 Windows 目录或 Android 诊断 APK，运行正式挑战/混沌模式的固定种子样本。"""
import argparse,hashlib,json,os,shutil,subprocess,zipfile
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def prepare_windows(out,config):
    out.mkdir(parents=True,exist_ok=False)
    for name in ('THlib','mod','Resources','music','shader'):
        def copy(source,target):
            return shutil.copy2(source,target) if Path(source).suffix=='.lua' else os.link(source,target)
        shutil.copytree(ROOT/name,out/name,copy_function=copy)
    for name in ('LuaSTGSub.exe','d3dcompiler_47.dll','xaudio2_9redist.dll','launch.lua','launcher.lua','core.lua','config.json'):
        shutil.copy2(ROOT/name,out/name)
    for name in ('User','replay','snapshot','userdata'): (out/name).mkdir()
    files=sorted([out/'LuaSTGSub.exe',*list((out/'THlib').rglob('*.lua')),*list((out/'mod').rglob('*.lua'))])
    digest=hashlib.sha256()
    for p in files:digest.update(p.relative_to(out).as_posix().encode()+b'\0'+p.read_bytes())
    (out/'source-fingerprint.json').write_text(json.dumps({'files':len(files),'sha256':digest.hexdigest()}),encoding='utf-8')
    (out/'User/stress-config.json').write_text(json.dumps(config),encoding='utf-8')
    shutil.copy2(ROOT/'tools/rogue_native_stress.lua',out/'native_test.lua')
    shutil.copy2(ROOT/'tools/check_bent_laser_native.lua',out/'native-bent-contract.lua')
    (out/'launch').write_text("lstg.DoFile('launch.lua')\nsetting.mod='launcher';setting.resx=960;setting.resy=720;setting.windowed=true;setting.vsync=false;setting.bgmvolume=0;setting.sevolume=0\nlstg.SetTitle('Boss Rush native stress')\nlstg.SetWindowed(true);lstg.SetResolution(960,720);lstg.SetVsync(false)\n",encoding='utf-8')
    with (out/'core.lua').open('a',encoding='utf-8') as f:
        f.write("\nlocal init=GameInit\nfunction GameInit()\n local ok,err=xpcall(function() init();setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting));Include('mod/root.lua');InitAllClass();InitGameSaveData();stage.next_stage=stage.stages.init;dofile('native_test.lua').install() end,debug.traceback)\n if not ok then local f=assert(io.open('User/stress-boot-error.txt','wb'));f:write(err);f:close();FrameFunc=function() return true end;RenderFunc=function() end;GameExit=function() end end\nend\n")

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out',type=Path,required=True);ap.add_argument('--config',type=Path,required=True)
    ap.add_argument('--android-base',type=Path);ap.add_argument('--overlay-source',action='store_true')
    ap.add_argument('--timeout',type=int,default=1500)
    args=ap.parse_args();out=args.out.resolve();config=json.loads(args.config.read_text(encoding='utf-8'))
    assert out!=ROOT and ROOT not in out.parents,'检查输出必须在源码目录之外'
    if args.android_base:
        out.mkdir(parents=True,exist_ok=False);apk=out/'stress.apk'
        module=(ROOT/'tools/rogue_native_stress.lua').read_bytes()
        with zipfile.ZipFile(args.android_base) as old,zipfile.ZipFile(apk,'w') as new:
            for item in old.infolist():
                if item.filename.startswith('META-INF/'): continue
                data=old.read(item)
                if item.filename=='assets/game/android/performance_case.lua':data=module
                elif args.overlay_source and item.filename.startswith(('assets/game/mod/','assets/game/THlib/')) and item.filename.endswith('.lua'):
                    source=ROOT/item.filename.removeprefix('assets/game/')
                    if source.is_file():data=source.read_bytes()
                new.writestr(item,data)
            new.writestr('assets/game/native-bent-contract.lua',(ROOT/'tools/check_bent_laser_native.lua').read_bytes())
        shutil.copy2(args.config,out/'stress-config.json')
        print(apk,flush=True);return
    prepare_windows(out,config)
    startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
    p=subprocess.Popen([str(out/'LuaSTGSub.exe')],cwd=out,startupinfo=startup)
    (out/'pid.txt').write_text(str(p.pid));print(f'Windows PID={p.pid} output={out}',flush=True)
    try:p.wait(timeout=args.timeout)
    except subprocess.TimeoutExpired:p.terminate();p.wait(timeout=15);raise RuntimeError('检查超时，保留独立目录和进度')
    result=json.loads((out/'User/stress-result.json').read_text(encoding='utf-8'))
    print(json.dumps({'complete':result['complete'],'errors':result['errors'],'runs':result['runs']},ensure_ascii=False))
    assert result['complete'] and not result['errors']

if __name__=='__main__':main()
