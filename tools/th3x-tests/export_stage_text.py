#!/usr/bin/env python3
"""恢复红魔乡运行时生成的关卡文字；字体、排版和 ANM 均取原始入口。"""
import argparse
import ctypes as C
from ctypes import wintypes as W
from copy import deepcopy
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import sys
sys.dont_write_bytecode=True
from PIL import Image

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('anm_export',Path(__file__).with_name('export_original_anm.py'))
anm=importlib.util.module_from_spec(spec);spec.loader.exec_module(anm)


def raster(text,height,center):
    gdi=C.WinDLL('gdi32',use_last_error=True)
    class BitmapInfo(C.Structure):
        _fields_=[('size',W.DWORD),('width',W.LONG),('height',W.LONG),('planes',W.WORD),
                  ('bits',W.WORD),('compression',W.DWORD),('imageSize',W.DWORD),
                  ('xppm',W.LONG),('yppm',W.LONG),('used',W.DWORD),('important',W.DWORD)]
    for name in ['CreateCompatibleDC','CreateDIBSection','CreateFontW','SelectObject']:
        getattr(gdi,name).restype=W.HANDLE
    gdi.CreateCompatibleDC.argtypes=[W.HDC]
    gdi.CreateDIBSection.argtypes=[W.HDC,C.POINTER(BitmapInfo),W.UINT,C.POINTER(C.c_void_p),W.HANDLE,W.DWORD]
    gdi.SelectObject.argtypes=[W.HDC,W.HANDLE]
    gdi.DeleteObject.argtypes=[W.HANDLE];gdi.DeleteDC.argtypes=[W.HDC]
    gdi.SetBkMode.argtypes=[W.HDC,C.c_int];gdi.SetTextColor.argtypes=[W.HDC,W.DWORD]
    gdi.TextOutW.argtypes=[W.HDC,C.c_int,C.c_int,W.LPCWSTR,C.c_int]
    gdi.CreateFontW.argtypes=[C.c_int]*5+[W.DWORD]*8+[W.LPCWSTR]
    width,rows=512,height*2+6
    info=BitmapInfo(40,width,-rows,1,32,0,width*rows*4,0,0,0,0)
    pointer=C.c_void_p();dc=gdi.CreateCompatibleDC(None)
    bitmap=gdi.CreateDIBSection(dc,C.byref(info),0,C.byref(pointer),None,0)
    assert bitmap and pointer.value,'GDI 文字缓冲区创建失败'
    previous=gdi.SelectObject(dc,bitmap)
    font=gdi.CreateFontW(height*2,0,0,0,700,0,0,0,128,0,0,4,0x11,'ＭＳ ゴシック')
    assert font,'原作字体创建失败'
    old_font=gdi.SelectObject(dc,font)
    memory=(C.c_ubyte*(width*rows*4)).from_address(pointer.value)
    memory[:]=bytes([0,0,0,255])*(width*rows)
    length=len(text.encode('cp932'));x=int(128-length*(height+1)/4) if center else int(256-length*(height+1)/2)
    gdi.SetBkMode(dc,1);gdi.SetTextColor(dc,0)
    assert gdi.TextOutW(dc,x*2+3,2,text,len(text))
    gdi.SetTextColor(dc,0x00ffffe0)
    assert gdi.TextOutW(dc,x*2,0,text,len(text))
    raw=bytearray(memory)
    for i in range(3,len(raw),4):raw[i]^=255
    image=Image.frombytes('RGBA',(width,rows),bytes(raw),'raw','BGRA')
    image=image.crop((0,0,510,height*2-2)).resize((256,16),Image.Resampling.BILINEAR)
    gdi.SelectObject(dc,old_font);gdi.DeleteObject(font)
    gdi.SelectObject(dc,previous);gdi.DeleteObject(bitmap);gdi.DeleteDC(dc)
    return image


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--game',type=Path,required=True)
    ap.add_argument('--thtk',type=Path,required=True)
    args=ap.parse_args();art=ROOT/'Resources/Original/6';output=ROOT/'mod/GAME/original/6';evidence={}
    def record(file):evidence[file.name]=hashlib.sha256(file.read_bytes()).hexdigest()
    with tempfile.TemporaryDirectory(prefix='bossrush-stage-text-') as temp:
        temp=Path(temp)
        for file,names in [('紅魔郷IN.DAT',['text.anm']),('紅魔郷ST.DAT',[f'stage{i}.std' for i in range(1,8)])]:
            path=args.game/file;record(path)
            subprocess.run([str(args.thtk/'thdat.exe'),'-C',str(temp),'-x','6',str(path),*names],check=True,capture_output=True)
        decl=subprocess.check_output([str(args.thtk/'thanm.exe'),'-l','6',str(temp/'text.anm')]).decode('utf8').replace('\r','')
        data=anm.parse(decl,temp,temp,6,'text')
        for index in range(1,8):
            raw=(temp/f'stage{index}.std').read_bytes()
            title=raw[16:144].split(b'\0')[0].decode('cp932')
            song=raw[144:272].split(b'\0')[0].decode('cp932')
            image=Image.new('RGBA',(256,32))
            image.paste(raster(title,15,True),(0,0));image.paste(raster('♪'+song,16,False),(0,16))
            archive='stage_title'+str(index);image.save(art/(archive+'_0.png'))
            meta=deepcopy(data);meta.update(game=6,archive=archive,textures=[archive+'_0.png'])
            meta['sprites']={key:data['sprites'][key] for key in (0,1)}
            meta['scripts']={key:data['scripts'][key] for key in (0,1)}
            meta['ids']={key:data['ids'][key] for key in (0,1)}
            (output/(archive+'.lua')).write_text('-- 红魔乡原始 text.anm 与 STD 文字；由 export_stage_text.py 导出。\nreturn '+anm.lua(meta)+'\n',encoding='utf8',newline='\n')
    record(Path('C:/Windows/Fonts/msgothic.ttc'))
    (output.parent/'stage_text_sources.json').write_text(json.dumps(dict(source_sha256=evidence,
        font='ＭＳ ゴシック / FW_BOLD / SHIFTJIS_CHARSET',filter='GDI 二倍文字按原源矩形缩为 256×16；三角采样采用双线性重建'),ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print('红魔乡关卡文字 7 组')


if __name__=='__main__':main()
