#!/usr/bin/env python3
"""比较私有state=full记录：对象状态严格比较，VM插值容差必须显式指定。"""
import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path
import struct

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('before',type=Path)
parser.add_argument('after',type=Path)
parser.add_argument('--vm-epsilon',type=float,default=0)
parser.add_argument('--images',action='store_true')
parser.add_argument('--fps-mask',help='显式排除动态FPS数字的原生像素矩形x1,y1,x2,y2')
parser.add_argument('--output',type=Path,required=True)
args=parser.parse_args()
result={'records':0,'physics_rows':0,'vm_rows':0,'formatter_only_tokens':0,'physics_differences':0,
        'vm_numeric_differences':0,'metadata_differences':0,'vm_max_abs':0,'vm_floor_color_differences':0,
        'vm_epsilon':args.vm_epsilon,'examples':[],'images':{},'raw_sha256':{}}
digests=[hashlib.sha256(),hashlib.sha256()]
with (args.before/'frames.txt').open(encoding='utf-8') as before,(args.after/'frames.txt').open(encoding='utf-8') as after:
    for line,(x,y) in enumerate(itertools.zip_longest(before,after),1):
        if x is None or y is None:
            raise RuntimeError(f'记录行数不同：{line}')
        for digest,text in zip(digests,[x,y]): digest.update(text.encode())
        result['records']+=1
        vm=x.startswith('vm,');result['vm_rows' if vm else 'physics_rows']+=1
        if x==y: continue
        left,right=x.rstrip('\n').split(','),y.rstrip('\n').split(',')
        if len(left)!=len(right): raise RuntimeError(f'字段数量不同：{line}')
        for column,(a,b) in enumerate(zip(left,right)):
            if a==b: continue
            numeric=(vm and (column in [2,3,4,8] or column>=10)) or (not vm and column<10)
            if numeric:
                try: p,q=float(a),float(b)
                except ValueError: numeric=False
            if numeric and struct.pack('>d',p)==struct.pack('>d',q):
                result['formatter_only_tokens']+=1;continue
            if not numeric or vm and column<10:
                result['metadata_differences']+=1
            elif vm:
                result['vm_numeric_differences']+=1
                result['vm_max_abs']=max(result['vm_max_abs'],abs(p-q))
                if 18<=column<=25 and math.floor(p)!=math.floor(q): result['vm_floor_color_differences']+=1
            else: result['physics_differences']+=1
            if len(result['examples'])<10:result['examples'].append({'line':line,'column':column,'before':a,'after':b})
result['raw_sha256']=dict(zip(['before','after'],[d.hexdigest() for d in digests]))
if args.images:
    import numpy as np
    from PIL import Image
    for frame in [630,720,780]:
        a=np.asarray(Image.open(args.before/f'frame-{frame}.png').convert('RGBA'))
        b=np.asarray(Image.open(args.after/f'frame-{frame}.png').convert('RGBA'))
        changed=np.any(a!=b,axis=2);total=int(changed.sum())
        if args.fps_mask:
            x1,y1,x2,y2=map(int,args.fps_mask.split(','));changed[y1:y2,x1:x2]=False
        result['images'][str(frame)]={'changed_pixels_total':total,'changed_pixels_outside_fps_mask':int(changed.sum())}
    result['fps_mask']=args.fps_mask
result['passed']=result['physics_differences']==0 and result['metadata_differences']==0 and \
    result['vm_max_abs']<=args.vm_epsilon and all(v['changed_pixels_outside_fps_mask']==0 for v in result['images'].values())
args.output.parent.mkdir(parents=True,exist_ok=True)
args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['examples','raw_sha256']},ensure_ascii=False))
if not result['passed']: raise SystemExit(1)
