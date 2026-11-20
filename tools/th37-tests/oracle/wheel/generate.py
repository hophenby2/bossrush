#!/usr/bin/env python3
"""只读编译原作天舞宝轮，输出 90 秒点弹坐标；激光绘制与激光轨迹不在此夹具范围。"""
import argparse, hashlib, json, os, re, shutil, subprocess, tempfile
from pathlib import Path
from Crypto.Cipher import DES3

HERE=Path(__file__).resolve().parent
NAMES='Batch Lase Barrage Event EventRead Execution BExecution COExecution LExecution BLExecution CExecution Cover Force Rebound Center Time GlobalEvent Layer LayerManager Grazebox Shadows CSManager CrazyStorm BarrageType Line PointF SakuraStatus'.split()

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--source',required=True,type=Path)
    args=ap.parse_args();source=args.source.resolve();code=source/'src/THMHJ/THMHJ'
    hashes={};omitted={}
    with tempfile.TemporaryDirectory(prefix='bossrush-wheel-csharp-') as name:
        work=Path(name)
        for n in NAMES:
            original=code/(n+'.cs');data=original.read_bytes()
            hashes[str(original.relative_to(source))]=hashlib.sha256(data).hexdigest()
            text=data.decode('utf-8-sig')
            # 不改动原始文件；去掉绘制与激光更新，仅保留点弹运动/事件代码；Batch 本就排除激光母弹。
            pattern=r'public void (Draw\w*|LDraw|LUpdate)\([^)]*\)\s*\{'
            matches=list(re.finditer(pattern,text))
            omitted[n]=[m[1] for m in matches]
            for m in reversed(matches):
                i=m.end();depth=1
                while depth:
                    depth+=(text[i]=='{')-(text[i]=='}');i+=1
                text=text[:m.end()]+text[i-1:]
            (work/original.name).write_text(text)
        raw=work/'raw';raw.mkdir()
        for n in ('3','b587'):
            p=source/'src/THMHJ/bin/x86/Debug/net461/Content/Data'/(n+'.xna')
            data=p.read_bytes();hashes[str(p.relative_to(source))]=hashlib.sha256(data).hexdigest()
            data=DES3.new(bytes.fromhex('4D3C3F50123A4577898C758F7E9E1187'),DES3.MODE_ECB).decrypt(data)
            pad=data[-1];assert data[-pad:]==bytes([pad])*pad
            (raw/p.name).write_bytes(data[:-pad])
        shutil.copyfile(HERE/'Program.cs',work/'Program.cs')
        (work/'oracle.csproj').write_text('<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net9.0</TargetFramework><ImplicitUsings>enable</ImplicitUsings><NoWarn>SYSLIB0011;SYSLIB0051</NoWarn></PropertyGroup></Project>')
        subprocess.run(['dotnet','build','oracle.csproj','--nologo'],cwd=work,check=True,stdout=subprocess.DEVNULL)
        with (HERE/'wheel.tsv').open('wb') as out:
            subprocess.run(['dotnet','bin/Debug/net9.0/oracle.dll'],cwd=work,check=True,stdout=out,env=dict(os.environ,DOTNET_ROLL_FORWARD='Major'))
    result={'source_sha256':hashes,'omitted_methods':omitted,'fixture_sha256':hashlib.sha256((HERE/'wheel.tsv').read_bytes()).hexdigest(),
            'harness_sha256':hashlib.sha256((HERE/'Program.cs').read_bytes()).hexdigest(),'cases':['天舞宝轮 5400 帧，采样点弹位置与存活数量；随机输入固定为 0.5，不覆盖激光轨迹']}
    (HERE/'sources.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print('原始 C# 天舞宝轮轨迹及输入指纹已更新。')

if __name__=='__main__':main()
