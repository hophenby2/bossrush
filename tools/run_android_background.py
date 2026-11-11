#!/usr/bin/env python3
"""在指定隔离安卓设备采集五作STD与雾效像素；可与旧包固定帧基线逐像素对照。"""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import numpy as np
from PIL import Image

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--serial',required=True)
p.add_argument('--adb',default=str(Path.home()/'Library/Android/sdk/platform-tools/adb'))
p.add_argument('--apk',type=Path,required=True)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--reference',type=Path)
p.add_argument('--only',choices=['fog','tail'])
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
root=Path(__file__).resolve().parents[1]
mode='benchmark backgrounds=1 probe=1'+(' only='+a.only if a.only else '')
subprocess.run([sys.executable,str(root/'tools/run_android_performance.py'),'--serial',a.serial,
    '--adb',a.adb,'--apk',str(a.apk.resolve()),'--mode',mode,'--output',str(a.output.resolve()),'--timeout','360'],check=True)
cases=json.loads((a.output/'probe.json').read_text())
rows=[]
for case in cases:
    name='background-'+case['id']+'.png'
    data=subprocess.run([a.adb,'-s',a.serial,'exec-out','run-as','org.bossrush.hd','cat',
        'files/bossrush/snapshot/'+name],stdout=subprocess.PIPE,check=True).stdout
    target=a.output/name;target.write_bytes(data)
    with Image.open(target) as image:
        image.load();actual=np.asarray(image.convert('RGB')).astype('int16')
    if a.reference:
        with Image.open(a.reference/name) as image:expected=np.asarray(image.convert('RGB')).astype('int16')
        assert actual.shape==expected.shape,('画布尺寸变化',name,actual.shape,expected.shape)
        # 最底部是Android实际FPS文字，位于背景视口外；不作为STD/雾像素的期望值。
        border=round(actual.shape[0]*48/1600)
        delta=np.abs(actual[:-border]-expected[:-border])
        row={'id':case['id'],'max_channel_error':int(delta.max()),'changed_pixels':int(np.any(delta,axis=2).sum())}
        rows.append(row)
    else:rows.append({'id':case['id'],'state':case['state']})
if a.reference:
    expected={c['id']:c['state'] for c in json.loads((a.reference/'probe.json').read_text())}
    assert all(c['state']==expected[c['id']] for c in cases),'STD/ANM状态变化'
(a.output/'pixels.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
assert all(r.get('max_channel_error',0)==0 for r in rows),'背景像素变化，见pixels.json'
print('背景/雾效固定帧原生对照通过：',len(cases),'组')
