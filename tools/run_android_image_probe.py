#!/usr/bin/env python3
"""将源PNG放入专用测试设备的私有诊断目录，对照入包图片的真实GPU混合像素。"""
import argparse
import json
from pathlib import Path
import subprocess
import time
import numpy as np
from PIL import Image

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--serial',required=True)
p.add_argument('--apk',type=Path,required=True)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--adb',default=str(Path.home()/'Library/Android/sdk/platform-tools/adb'))
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
root=Path(__file__).resolve().parents[1]
records=json.loads((root/'android/build/asset-optimization.json').read_text())
selected=[]
def take(rows,count):
    for path,record in sorted(rows,key=lambda x:-x[1]['source_bytes'])[:count]:
        if path not in selected:selected.append(path)
take([(k,v) for k,v in records.items() if v['core'] and v['codec']=='png-lossless'],6)
take([(k,v) for k,v in records.items() if v['core'] and v['codec']=='webp-lossless'],4)
take([(k,v) for k,v in records.items() if v['core'] and '/player/' in k],2)
take([(k,v) for k,v in records.items() if v['core'] and '/bullet/' in k],2)
take([(k,v) for k,v in records.items() if v['codec'].startswith('webp-q')],10)
take([(k,v) for k,v in records.items() if v['codec'] in ('png-rgb6','png-rgb5')],6)
take([(k,v) for k,v in records.items() if not v['core'] and v['codec']=='webp-lossless'],3)
for path in ['Resources/Original/8/eff09al_1.png','Resources/Original/8/eff09sk_1.png']:
    if path not in selected:selected.append(path)
base=[a.adb,'-s',a.serial];package='org.bossrush.hd';flag='files/bossrush/User/android-diagnostics'
def adb(*words,input=None,check=True):
    return subprocess.run(base+list(words),input=input,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=check)
adb('install','-r',str(a.apk.resolve()))
saved=adb('exec-out','run-as',package,'cat',flag,check=False)
token='tag='+str(time.time_ns());mode='content images=1 '+token
try:
    adb('shell','am','force-stop',package)
    adb('shell','run-as',package,'mkdir','-p','files/bossrush/User/image-probe')
    for index,path in enumerate(selected,1):
        adb('shell','run-as',package,'tee',f'files/bossrush/User/image-probe/{index}.png',input=(root/path).read_bytes())
    adb('shell','run-as',package,'tee','files/bossrush/User/image-probe/list.tsv',input='\n'.join(selected).encode())
    adb('shell','run-as',package,'tee',flag,input=mode.encode())
    adb('shell','am','start','-n',package+'/.BossRushActivity')
    deadline=time.monotonic()+120
    while time.monotonic()<deadline:
        time.sleep(1)
        log=adb('exec-out','run-as',package,'cat','files/lstg_log.txt',check=False).stdout.decode(errors='replace')
        (a.output/'runtime.log').write_text(log)
        if 'BOSSRUSH_ERROR:' in log or 'BOSSRUSH_BOOT_ERROR:' in log:raise RuntimeError('GPU图片对照报错')
        if token in log and 'BOSSRUSH_CONTENT_DONE:' in log[log.index(token):]:break
    else:raise TimeoutError('GPU图片对照超时')
    results=[]
    for index,path in enumerate(selected,1):
        targets={}
        for phase in ('source','packed'):
            target=a.output/f'{index:03d}-{phase}.png'
            target.write_bytes(adb('exec-out','run-as',package,'cat',f'files/bossrush/snapshot/android-image-{index:03d}-{phase}.png').stdout)
            targets[phase]=Image.open(target).convert('RGB')
        image=targets['packed'];reference=targets['source'];k=image.width/540
        assert image.width%2==0,image.size
        # 底部动态FPS/版本号位于y<64；同一位置前后两帧对照，消除左右光栅插值舍入差异。
        boxes=[(round(8*k),round((image.height/k-top+2)*k),round(262*k),round((image.height/k-bottom-2)*k)) for bottom,top in [(64,290),(306,564)]]
        errors=[]
        for box in boxes:
            region=(box[0]+image.width//2,box[1],box[2]+image.width//2,box[3])
            lhs=np.asarray(reference.crop(region)).astype('int16')
            rhs=np.asarray(image.crop(region)).astype('int16')
            errors.append(lhs-rhs)
        error=np.concatenate([x.reshape(-1,3) for x in errors]);mse=float(np.mean(error.astype('float32')**2))
        maximum=int(np.max(np.abs(error)))
        if records[path]['core']:assert maximum==0,(path,maximum)
        if records[path]['codec'] in ('png-rgb6','png-rgb5'):
            assert maximum<=records[path].get('max_rgb_error',2),(path,maximum)
        if records[path]['codec'].startswith('webp-q'):assert maximum>0,('未采到有损图片差异',path)
        results.append({'path':path,'core':records[path]['core'],'max_channel_error':maximum,
                        'psnr_db':round(float(10*np.log10(255**2/mse)),3) if mse else None})
    (a.output/'result.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
    print('GPU对照通过：',len(results),'张；核心',sum(r['core'] for r in results),'张两种混合模式逐像素一致')
finally:
    adb('shell','am','force-stop',package,check=False)
    if saved.returncode==0:adb('shell','run-as',package,'tee',flag,input=saved.stdout,check=False)
    else:adb('shell','run-as',package,'rm','-f',flag,check=False)
    adb('shell','run-as',package,'rm','-rf','files/bossrush/User/image-probe',check=False)
