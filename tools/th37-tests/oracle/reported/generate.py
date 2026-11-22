#!/usr/bin/env python3
"""只读执行春雪原作点弹与直线激光，记录本次反馈涉及的轨迹和弹型。"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

from Crypto.Cipher import DES3

HERE = Path(__file__).resolve().parent
NAMES = 'Batch Lase Barrage Event EventRead Execution BExecution COExecution LExecution BLExecution CExecution Cover Force Rebound Center Time GlobalEvent Layer LayerManager Grazebox Shadows CSManager CrazyStorm BarrageType Line PointF SakuraStatus'.split()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, required=True)
    args = parser.parse_args()
    source = args.source.resolve()
    hashes = {}
    with tempfile.TemporaryDirectory(prefix='bossrush-reported-csharp-') as name:
        work = Path(name)
        for name in NAMES:
            original = source / 'src/THMHJ/THMHJ' / (name + '.cs')
            data = original.read_bytes()
            hashes[str(original.relative_to(source))] = hashlib.sha256(data).hexdigest()
            code = data.decode('utf-8-sig')
            for match in reversed(list(re.finditer(r'public void (Draw\w*|LDraw)\([^)]*\)\s*\{', code))):
                end, depth = match.end(), 1
                while depth:
                    depth += (code[end] == '{') - (code[end] == '}')
                    end += 1
                code = code[:match.end()] + code[end-1:]
            (work / original.name).write_text(code, encoding='utf-8')
        raw = work / 'raw'
        raw.mkdir()
        for name in ('3', 'b172', 'b163', 'b584', 'b586', 'b191', 'b2221', 'b33', 'b51'):
            original = source / 'src/THMHJ/bin/x86/Debug/net461/Content/Data' / (name + '.xna')
            data = original.read_bytes()
            hashes[str(original.relative_to(source))] = hashlib.sha256(data).hexdigest()
            data = DES3.new(bytes.fromhex('4D3C3F50123A4577898C758F7E9E1187'), DES3.MODE_ECB).decrypt(data)
            pad = data[-1]
            assert data[-pad:] == bytes([pad]) * pad
            (raw / original.name).write_bytes(data[:-pad])
        stubs = (HERE.parent / 'wheel/Program.cs').read_text(encoding='utf-8')
        stubs = stubs[:stubs.index('public class Program')]
        main_file=source / 'src/THMHJ/THMHJ/Main.cs'
        hashes[str(main_file.relative_to(source))]=hashlib.sha256(main_file.read_bytes()).hexdigest()
        original_main = main_file.read_text(encoding='utf-8-sig')
        cross = original_main[original_main.index('private static float CrossMul'):original_main.index('public static bool IsOut')]
        stubs = stubs.replace('public static bool CheckTwoLineCrose(Line a,Line b)=>throw new NotSupportedException();', cross)
        program = r'''
public class Program {
 public static Program main=new(); public Game game=new();
 public static void Main(){
  System.Globalization.CultureInfo.CurrentCulture=System.Globalization.CultureInfo.InvariantCulture;
  foreach(var id in new[]{"172","163","584","586","191","2221","33","51"}){
   var csm=new CSManager(null,null,null);var p=new Character();p.body.position=new(224,420);
   var boss=new Boss();var cs=new CrazyStorm(null,csm,true,"b"+id,new(317,407));cs.Start();csm.csc.Add(cs);
   for(int tick=1;tick<=900;tick++){
    cs.SetPos(boss.Position+new Vector2(93,-13),false);cs.Update(p,new EnemyManager(),boss);
    foreach(var layer in cs.layerm.LayerArray){
     foreach(var b in layer.Barrages){
      if(!b.NeedDelete && (tick<=120||tick%30==0))
       Console.WriteLine(string.Join("\t",id,tick,layer.sort,b.parentid,b.time,b.IsLase?1:0,b.type,b.x.ToString("R"),b.y.ToString("R"),b.speedx.ToString("R"),b.speedy.ToString("R"),b.head.ToString("R"),b.life,b.rlongs.ToString("R"),b.wscale.ToString("R")));
     }
     foreach(var b in layer.Barrages)if(b.NeedDelete){b.PoolState=false;foreach(var e in b.Events)e.PoolState=false;foreach(var e in b.Eventsexe)e.PoolState=false;foreach(var e in b.LEventsexe)e.PoolState=false;foreach(var e in b.grazeb)e.PoolState=false;b.Events.Clear();b.Eventsexe.Clear();b.LEventsexe.Clear();b.grazeb.Clear();}
     layer.Barrages.RemoveAll(b=>b.NeedDelete);
    }
   }
  }
 }
}
}
'''
        (work / 'Program.cs').write_text(stubs + program, encoding='utf-8')
        (work / 'oracle.csproj').write_text('<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net9.0</TargetFramework><NoWarn>SYSLIB0011;SYSLIB0051</NoWarn></PropertyGroup></Project>')
        subprocess.run(['dotnet', 'build', '--nologo', '-v:q'], cwd=work, check=True)
        with (HERE / 'reported.tsv').open('wb') as out:
            subprocess.run(['dotnet', 'bin/Debug/net9.0/oracle.dll'], cwd=work, check=True, stdout=out,
                           env=dict(os.environ, DOTNET_ROLL_FORWARD='Major'))
    (HERE / 'sources.json').write_text(json.dumps({'source_sha256': hashes,
        'harness_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),HERE.parent/'wheel/Program.cs']},
        'fixture_sha256': hashlib.sha256((HERE / 'reported.tsv').read_bytes()).hexdigest()}, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')


if __name__ == '__main__':
    main()
