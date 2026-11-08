"""只读原版1.00a PE，核对移植用到的分派表与回调地址；不执行或修改原游戏。"""
from pathlib import Path
import argparse
import hashlib
import json
import struct
import sys


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('exe',type=Path)
    ap.add_argument('--callback',type=int)
    ap.add_argument('--address',type=lambda x:int(x,0))
    ap.add_argument('--bytes',type=int,default=600)
    ap.add_argument('--export-profiles',type=Path)
    args=ap.parse_args()
    import pefile,capstone
    raw=args.exe.read_bytes()
    assert hashlib.sha256(raw).hexdigest()=='2978b17f6184d100d249d4311348dd30c5c32ec75c014b667a525b797d3d8813'
    pe=pefile.PE(data=raw)
    read=lambda va,n:pe.get_data(va-0x400000,n)
    callbacks=struct.unpack('<13I',read(0x4a3d64,13*4))
    if args.export_profiles:
        sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'th3x-tests'))
        from export_original_anm import lua
        profiles={}
        for kind in range(29):
            d=read(0x4a3ec0+kind*208,208)
            profiles[kind]={'script':struct.unpack_from('<i',d)[0],
                'sprites':{i:struct.unpack_from('<i',d,4+i*4)[0] for i in range(48)},
                'radius':struct.unpack_from('<f',d,0xc4)[0],
                'effect':struct.unpack_from('<i',d,0xc8)[0],
                'color_mode':struct.unpack_from('<i',d,0xcc)[0]}
        args.export_profiles.write_text('-- TH11日文1.00a，VA 0x4a3ec0，29项×0xd0；由native_evidence.py从原PE导出。\nreturn '+lua(profiles)+'\n','utf-8')
        return
    if args.callback is None and args.address is None:
        print(json.dumps({'sha256':hashlib.sha256(raw).hexdigest(),'callbacks':[hex(x) for x in callbacks]},indent=2))
        return
    address=args.address or callbacks[args.callback]
    cs=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
    for row in cs.disasm(read(address,args.bytes),address):print(f'{row.address:08x} {row.mnemonic} {row.op_str}')


if __name__=='__main__':main()
