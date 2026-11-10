#!/usr/bin/env python3
"""直接解码真实APK，核对全部逻辑图片的尺寸、Alpha、核心像素与透明图路径。"""
import argparse
import io
import json
from pathlib import Path
import re
import sys
import zipfile
import numpy as np
from PIL import Image
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'android'))
from image_policy import noncore_category


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('apk',type=Path)
    p.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1])
    p.add_argument('--output',type=Path)
    p.add_argument('--windows',action='store_true',help='检查Windows ZIP及其逻辑文件名/贴图别名')
    a=p.parse_args()
    counts={'core_exact':0,'noncore_exact':0,'noncore_lossy_opaque':0,'noncore_lossy_transparent':0}
    with zipfile.ZipFile(a.apk) as z:
        prefix=next(n[:-len('core.lua')] for n in z.namelist() if n.endswith('/core.lua')) if a.windows else 'assets/game/'
        mapping='windows/asset_aliases.lua' if a.windows else 'asset_variants.lua'
        aliases=dict(re.findall(r'\["(.*?)"\]="(.*?)"',z.read(prefix+mapping).decode()))
        logical={n[len(prefix):] for n in z.namelist() if n.startswith(prefix)}|set(aliases) if a.windows else set(re.findall(r'"(.*?)"',z.read(prefix+'asset_index.lua').decode()))
        for folder in ('THlib','Resources','mod'):
            for source in (a.root/folder).rglob('*.png'):
                path=source.relative_to(a.root).as_posix()
                assert path in logical,('逻辑文件枚举遗漏',path)
                target=aliases.get(path,path)
                assert target not in aliases,('资源别名不能形成链',path,target)
                packed=z.read(prefix+target)
                with Image.open(source) as original,Image.open(io.BytesIO(packed)) as decoded:
                    assert original.size==decoded.size,('尺寸变化',path)
                    x,y=original.convert('RGBA'),decoded.convert('RGBA')
                    assert x.getchannel('A').tobytes()==y.getchannel('A').tobytes(),('Alpha变化',path)
                    opaque=x.getchannel('A').getextrema()==(255,255)
                    if not opaque:
                        assert decoded.format=='PNG',('透明图必须保留PNG解码路径',path)
                        assert source.read_bytes()[8:33]==packed[8:33],('透明图PNG头变化',path)
                    exact=x.tobytes()==y.tobytes()
                    if noncore_category(path) is None:
                        assert exact,('核心图片不是无损',path)
                        counts['core_exact']+=1
                    elif exact:
                        counts['noncore_exact']+=1
                    else:
                        x=np.asarray(x).astype('int16');y=np.asarray(y).astype('int16')
                        if opaque:
                            mse=float(np.mean((x[:,:,:3].astype('float32')-y[:,:,:3])**2))
                            assert 10*np.log10(255**2/mse)>=36,('非核心有损误差过大',path)
                            counts['noncore_lossy_opaque']+=1
                        else:
                            assert int(np.max(np.abs(x[:,:,:3]-y[:,:,:3])))<=2,('透明RGB误差超过2级',path)
                            counts['noncore_lossy_transparent']+=1
    if a.output:a.output.write_text(json.dumps(counts,ensure_ascii=False,indent=2)+'\n')
    print('APK全量图片校验通过：',counts)


if __name__=='__main__':main()
