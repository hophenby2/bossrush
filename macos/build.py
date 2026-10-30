#!/usr/bin/env python3
"""构建可在本机启动的 macOS 测试应用，共用固定 Android 引擎与 Sub 兼容层。"""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,shutil,subprocess,sys
ROOT=Path(__file__).resolve().parent
GAME=ROOT.parent
BUILD=ROOT/'build'
ENGINE=ROOT/'.cache/LuaSTG-x'
APP=ROOT/'dist/Boss Rush HD.app'
spec=importlib.util.spec_from_file_location('bossrush_android_build',GAME/'android/build.py')
shared=importlib.util.module_from_spec(spec);spec.loader.exec_module(shared)
def run(*args,**kw):
 print('+',' '.join(map(str,args)),flush=True);subprocess.run(list(map(str,args)),check=True,**kw)
def shared_patch_hash():
 paths=[GAME/'android/engine.lock.json',GAME/'android/patch_engine.py',GAME/'android/native/compat.cpp',GAME/'android/native/compat.h']
 return hashlib.sha256(b''.join(p.read_bytes() for p in paths)).hexdigest()

def resources():
 shared.GAME=GAME;shared.BUILD=BUILD;shared.ENGINE=ENGINE
 # Mac 使用 Cocos 原生 Metal 后端，保留 GLES 风格 GLSL，由原生后端翻译为 MSL。
 shared.prepare_shaders=lambda target:None
 assets=shared.prepare_assets()
 config=assets/'src/config.lua';text=config.read_text();config.write_text(text.replace("local title = 'LuaSTG-x'","local title = 'Boss Rush HD · Mac 测试版'"))
 target=assets/'game/macos';shutil.copytree(ROOT/'lua',target,dirs_exist_ok=True)
 shutil.copy2(ROOT/'lua/main.lua',assets/'src/main.lua')
 # 指纹必须包含 Mac 入口，跨平台精确续玩不会误用另一条渲染 / 输入实现。
 manifest=shared.resume_fingerprint(assets/'game')
 payload=manifest+''.join(p.relative_to(target).as_posix()+p.read_text() for p in sorted(target.rglob('*.lua')))
 payload+=shared_patch_hash()+(ROOT/'patch_engine.py').read_text()
 payload+=''.join(p.name+hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((ROOT/'native').iterdir()) if p.is_file())
 (assets/'game/android/resume-version.txt').write_text(hashlib.sha256(payload.encode()).hexdigest())
 return assets

def bundle_libraries(executable):
    """将非系统动态库复制到应用内，移除构建机 / Homebrew 的绝对链接。"""
    frameworks=APP/'Contents/Frameworks';frameworks.mkdir(exist_ok=True)
    copied={};pending=[(executable,executable)]
    def dependencies(path):
        return [line.strip().split(' (',1)[0] for line in subprocess.check_output(['otool','-L',str(path)],text=True).splitlines()[1:]]
    while pending:
        original,target=pending.pop()
        for name in dependencies(original):
            if name.startswith(('/System/Library/','/usr/lib/')):continue
            if name.startswith('@rpath/'):
                candidates=list((BUILD/'native').rglob(Path(name).name))
                source=next((p for p in candidates if p.is_file()),None)
            elif name.startswith('@loader_path/'):
                source=(original.parent/name[len('@loader_path/'):]).resolve()
            else:source=Path(name)
            if source is None or not source.is_file():raise RuntimeError('无法定位动态库：'+name)
            source=source.resolve();dest=frameworks/source.name
            # 动态库自身的 install name 不是依赖。
            if source==original.resolve():continue
            if source not in copied:
                if dest.exists():raise RuntimeError('动态库重名：'+str(source))
                shutil.copy2(source,dest);dest.chmod(0o755);copied[source]=dest
                run('install_name_tool','-id','@rpath/'+dest.name,dest)
                pending.append((source,dest))
                if 'Cellar' in source.parts:
                    part=source.parts.index('Cellar');prefix=Path(*source.parts[:part+3])
                    notices=APP/'Contents/Resources/licenses/Homebrew'/prefix.parent.name
                    for entry in prefix.rglob('*'):
                        if entry.is_file() and (entry.name.upper().startswith(('LICENSE','COPYING','COPYRIGHT','NOTICE','AUTHORS')) or entry.parent.name=='.brew'):
                            target_notice=notices/entry.relative_to(prefix);target_notice.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(entry,target_notice)
            prefix='@executable_path/../Frameworks/' if target==executable else '@loader_path/'
            run('install_name_tool','-change',name,prefix+copied[source].name,target)
    for path in frameworks.iterdir():run('codesign','--force','--sign','-',path)

def main():
 global GAME
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--game-root',type=Path,help='从指定的已提交源码快照复制游戏内容')
 parser.add_argument('--update-assets',action='store_true',help='保留原生程序，只更新游戏脚本与资源')
 parser.add_argument('--jobs',type=int,default=min(os.cpu_count() or 4,8))
 args=parser.parse_args()
 if args.game_root:
  GAME=args.game_root.resolve()
  if not (GAME/'core.lua').is_file():parser.error('--game-root 必须包含 core.lua')
 if sys.platform!='darwin':parser.error('此入口需要 macOS 与 Xcode 命令行工具')
 BUILD.mkdir(parents=True,exist_ok=True)
 if not args.update_assets:
  shared.CACHE=ROOT/'.cache';shared.ENGINE=ENGINE
  marker=ROOT/'.cache/shared-patch.sha256'
  fingerprint=shared_patch_hash()
  if not marker.exists() or marker.read_text()!=fingerprint:
   if ENGINE.exists():shutil.rmtree(ENGINE)
   archive=GAME/'android/.cache/engine.zip'
   shared.prepare_engine(archive if archive.exists() else None)
   marker.write_text(fingerprint)
  run(sys.executable,ROOT/'patch_engine.py',ENGINE)
 if not args.update_assets:
  run('cmake','-S',ENGINE,'-B',BUILD/'native','-G','Ninja','-DCMAKE_BUILD_TYPE=Release',
      '-DCMAKE_OSX_ARCHITECTURES=arm64','-DCMAKE_OSX_DEPLOYMENT_TARGET=13.0','-DCMAKE_POLICY_VERSION_MINIMUM=3.5',
      '-DLSTGX_NO_LIVE2D=ON','-DLSTGX_NO_VIDEO=ON','-DLSTGX_NO_YUESCRIPT=ON','-DLSTGX_USE_GFX=OFF',
      '-DFT_DISABLE_PNG=ON','-DFT_DISABLE_BZIP2=ON','-DFT_DISABLE_BROTLI=ON','-DCMAKE_CXX_SCAN_FOR_MODULES=OFF','-DALSOFT_ENABLE_MODULES=OFF','-DALSOFT_RTKIT=OFF')
  run('cmake','--build',BUILD/'native','--target','LuaSTG-x','-j',args.jobs)
 binaries=list((BUILD/'native').rglob('BossRushHD'))
 binary=next((p for p in binaries if p.is_file()),None)
 if not binary:raise RuntimeError('未找到原生构建产物，请先执行完整构建')
 if APP.exists():shutil.rmtree(APP)
 dest=APP/'Contents';(dest/'MacOS').mkdir(parents=True)
 shutil.copy2(binary,dest/'MacOS/BossRushHD');shutil.copy2(ROOT/'Info.plist',dest/'Info.plist')
 shutil.copytree(resources(),dest/'Resources')
 bundle_libraries(dest/'MacOS/BossRushHD')
 run('codesign','--force','--deep','--sign','-',APP)
 print('Mac 应用：'+str(APP))
if __name__=='__main__':main()
