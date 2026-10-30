#!/usr/bin/env python3
"""校验 Mac 应用并可选地运行真实 Metal 菜单、弹幕与渲染测试；不读取玩家存档。"""
from pathlib import Path
import argparse,json,os,subprocess,tempfile,shutil,plistlib
ROOT=Path(__file__).resolve().parent
APP=ROOT/'dist/Boss Rush HD.app'
BINARY=APP/'Contents/MacOS/BossRushHD'
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def main():
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--smoke',action='store_true');parser.add_argument('--mode',choices=['menu','battle','graphics','input','audio','settings']);args=parser.parse_args()
 run('luajit',ROOT/'tests/input.lua',ROOT.parent)
 run('codesign','--verify','--deep','--strict',APP)
 info=plistlib.loads((APP/'Contents/Info.plist').read_bytes())
 assert info['CFBundleExecutable']=='BossRushHD'
 assert 'arm64' in subprocess.check_output(['lipo','-archs',str(BINARY)],text=True)
 for file in [BINARY,*list((APP/'Contents/Frameworks').iterdir())]:
  for line in subprocess.check_output(['otool','-L',str(file)],text=True).splitlines()[1:]:
   name=line.strip().split(' (',1)[0]
   assert name.startswith(('/System/Library/','/usr/lib/','@')), '存在构建机依赖：'+name
   assert '/OpenAL.framework/' not in name,'系统 OpenAL 会覆盖随包后端，造成高频音效重填阻塞'
 resources=APP/'Contents/Resources'
 assert (resources/'game/macos/main.lua').is_file()
 assert not (resources/'game/User').exists() and not (resources/'game/replay').exists()
 print('Mac 应用结构、Apple Silicon 架构、签名、动态库隔离校验通过',flush=True)
 if not args.smoke:return
 out=ROOT/'dist/test';out.mkdir(exist_ok=True);reports=[]
 for mode in ([args.mode] if args.mode else ('menu','battle','graphics','input','audio','settings')):
  with tempfile.TemporaryDirectory(prefix='bossrush-mac-'+mode+'-') as sandbox:
   data=Path(sandbox)
   env=dict(os.environ,BOSSRUSH_MAC_DATA=sandbox,BOSSRUSH_MAC_TEST=mode)
   logfile=out/(mode+'.log')
   with logfile.open('w') as log:
    process=subprocess.Popen([str(BINARY)],cwd=sandbox,env=env,stdout=log,stderr=subprocess.STDOUT)
    try:code=process.wait(timeout=55)
    except subprocess.TimeoutExpired:
     process.terminate();process.wait(timeout=10);raise RuntimeError(mode+' 超时，见 '+str(logfile))
   for screenshot in data.glob('bossrush/snapshot/*.png'):shutil.copy2(screenshot,out/(mode+'.png'))
   nativeLog=data/'lstg_log.txt'
   if nativeLog.exists():shutil.copy2(nativeLog,out/(mode+'-engine.log'))
   assert code==0,mode+' 异常退出（'+str(code)+'），见 '+str(logfile)
   report=data/'bossrush/User/mac-test.json'
   assert report.exists(),mode+' 未完成测试，见 '+str(logfile)
   result=json.loads(report.read_text());assert 'Metal' in result['version']
   assert result['audio']['renderer']=='OpenAL Soft' and '/Frameworks/soft_oal' in result['audio']['library'],'AL 符号未绑定到打包的 OpenAL Soft'
   assert mode!='battle' or result['peak']>0,'战斗测试没有生成弹幕'
   assert mode!='input' or (result['input_checked'] and result['input_bomb_checked'] and result['paused']),'Mac 逐帧拖拽 / 双击 Bomb / 暂停未完成验证'
   assert mode!='settings' or result['settings_checked'],'触控设置 / 持久保存未完成验证'
   assert mode!='audio' or (result['audio_checked'] and result['audio_calls']==1920),'高频音效 / BGM 状态回归未完成'
   screenshot=data/('bossrush/snapshot/mac-'+mode+'.png')
   assert screenshot.is_file(),'未生成画面截图'
   shutil.copy2(screenshot,out/(mode+'.png'));reports.append(result)
   if mode=='graphics':
    from PIL import Image
    image=Image.open(screenshot).convert('RGB');w,h=image.size
    def pixel(x,y):return image.getpixel((round(x*w/960),round((540-y)*h/540)))
    expected=[(384,382,(255,0,0)),(576,382,(0,255,0)),(384,158,(0,0,255)),(576,158,(255,255,0)),(840,350,(180,60,220))]
    for x,y,color in expected:assert all(abs(a-b)<=3 for a,b in zip(pixel(x,y),color)),('视口 / RT / 3D 像素不符',x,y,pixel(x,y),color)
    for row,colors in enumerate([[(255,0,0),(0,255,0),(0,0,255)],[(0,255,255),(255,0,255),(255,255,0)]]):
     for repeat in range(4):
      for col,color in enumerate(colors):
       x=20+(repeat*3+col+.5)*220/12;y=450-(row+.5)*45
       assert all(abs(a-b)<=3 for a,b in zip(pixel(x,y),color)),('NPOT 平铺像素不符',x,y,pixel(x,y),color)
    region=image.crop((int(320*w/960),int(4*h/540),int(630*w/960),int(35*h/540)))
    assert sum(min(p)>180 for p in region.getdata())>100,'TTF 标题未正确显示'
    result['pixel_checks']=30

   print(mode+' 原生运行通过：'+json.dumps(result,ensure_ascii=False),flush=True)
 (out/'results.json').write_text(json.dumps(reports,ensure_ascii=False,indent=2))
if __name__=='__main__':main()
