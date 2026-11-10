"""从本机原作档案和已还原源码导出顺序模式自机数据；不读取或改写玩家存档。"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import math
import re
import struct

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('anm_export', ROOT/'tools/th3x-tests/export_original_anm.py')
anm = importlib.util.module_from_spec(spec)
spec.loader.exec_module(anm)


def sht(path, game):
    raw = path.read_bytes()
    count = struct.unpack_from('<H', raw, 2)[0]
    base = {7: 0x34, 8: 0x38, 10: 0x110}[game]
    out = {'sha256': hashlib.sha256(raw).hexdigest(), 'levels': []}
    if game == 10:
        out.update(zip(('speed', 'slow'), struct.unpack_from('<2f', raw, 0x10)))
        # PlayerInitialize在载入SHT后覆盖这三个头字段；原版th10.exe的476FA0..476FBF。
        character=int(path.stem[2:4])
        out.update(hitbox=(2.0,3.5)[character],attract=(5.0,7.0)[character],
                   collect=(20.0,24.0)[character],focus_collect=(50.0,59.0)[character])
        out['options'] = [list(struct.unpack_from('<2f', raw, p)) for p in range(0x20, 0x110, 8)]
    else:
        out.update(zip(('bombs', 'deathbomb', 'hitbox', 'graze', 'attract', 'collect'),
                       (*struct.unpack_from('<f', raw, 4), *struct.unpack_from('<i', raw, 8),
                        *struct.unpack_from('<4f', raw, 12))))
        out.update(zip(('poc', 'speed', 'slow'), struct.unpack_from('<3f', raw, 0x20 if game == 7 else 0x1c)[::1] if game == 7 else
                       (struct.unpack_from('<f', raw, 0x1c)[0], *struct.unpack_from('<2f', raw, 0x24))))
        if game == 7: out['cherryPenalty'] = struct.unpack_from('<f', raw, 0x1c)[0]
    for i in range(count):
        pos, power = struct.unpack_from('<Ii', raw, base + i*8)
        rows = []
        for _ in range(256):
            interval = struct.unpack_from('<b' if game == 10 else '<h', raw, pos)[0]
            if interval < 0: break
            if game == 10:
                interval, frame, damage = struct.unpack_from('<bbh', raw, pos)
                x,y,hx,hy,angle,speed = struct.unpack_from('<6f', raw, pos+4)
                option, kind, animation, hit, sound = struct.unpack_from('<bBhhh', raw, pos+28)
                callbacks = struct.unpack_from('<4I', raw, pos+36)
                shot = kind
            else:
                interval, frame, x,y,hx,hy,angle,speed,damage = struct.unpack_from('<hh6fh', raw, pos)
                if game == 7:
                    option,kind,animation,sound = struct.unpack_from('<bbhh', raw, pos+30)
                    callbacks = struct.unpack_from('<4I', raw, pos+36)
                    shot = kind
                else:
                    kind,option,shot,animation,sound = struct.unpack_from('<5h', raw, pos+30)
                    callbacks = struct.unpack_from('<4I', raw, pos+40)
            assert interval > 0, (path, pos)
            rows.append(dict(interval=interval, frame=frame, x=x, y=y, hx=hx, hy=hy,
                             angle=-math.degrees(angle), speed=speed, damage=damage,
                             option=option, kind=kind, shot=shot, animation=animation, callbacks=list(callbacks)))
            pos += 0x38 if game == 8 else 0x34
        else: raise ValueError((path, '缺少射击表终止符'))
        out['levels'].append({'power': power, 'shots': rows})
    return out


def th06(source):
    text = (source/'src/BulletData.cpp').read_text('utf8')
    text = re.sub(r'/\*.*?\*/|//[^\n]*', '', text, flags=re.S)
    result = {}
    for name in ('ReimuA', 'ReimuB', 'MarisaA', 'MarisaB'):
        levels = []
        for rank, body in re.findall(r'CharacterPowerBulletData g_CharacterPowerBulletData'+name+r'Rank(\d+)\[\] = \{(.*?)\n\};', text, re.S):
            shots = []
            for row in re.findall(r'\{([^{}]+)\}', body):
                fields = [s.strip() for s in row.split(',')]
                numbers = [float(s.rstrip('f')) for s in fields[:6]]
                angle = -float(re.fullmatch(r'RADIANS\((.*?)\)', fields[6])[1])
                kind = 3 if fields[10] == 'PLAYER_LASER' else int(fields[10].rsplit('_', 1)[1])
                anim = 64 if fields[11] == 'ANM_SCRIPT_PLAYER_BULLET' else 65
                if 'REIMU_B_ORB' in fields[11]: anim = 66
                elif 'MARISA_A_ORB' in fields[11]: anim = 64+int(fields[11][-1])
                elif 'MARISA_B_ORB' in fields[11]: anim = 68+int(fields[11][-1])
                shots.append(dict(zip(('interval','frame','x','y','hx','hy'), numbers),
                                  angle=angle, speed=float(fields[7].rstrip('f')), damage=int(fields[8]),
                                  option=int(fields[9]),kind=kind,animation=anim,callbacks=[0,kind,0,0]))
            levels.append({'power': [0,8,16,32,48,64,80,96,127][int(rank)-1], 'shots': shots})
        result[name.lower()] = {'speed': 4 if name.startswith('Reimu') else 5, 'slow': 2 if name.startswith('Reimu') else 2.5,
                                'bombs': 3, 'deathbomb': 6, 'hitbox': 2.5, 'graze': 48, 'collect': 12, 'attract': 8,
                                'poc': 128, 'levels': levels}
    return result


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--source', type=Path, default=Path('E:/workspace/原作'))
    ap.add_argument('--workspace', type=Path, default=Path('E:/workspace'))
    ap.add_argument('--thtk', type=Path, default=Path('E:/workspace/thtkGUI-th20tr/thtk/thtk-th20'))
    args = ap.parse_args()
    cache = args.workspace/'.bossrush-validation/sequence-player-export'
    result, manifest = {}, {}
    for game in (6,7,8,10):
        directory = cache/str(game); directory.mkdir(parents=True, exist_ok=True)
        data = th06(args.workspace/'th06') if game == 6 else {}
        for archive in args.source.rglob('*'):
            if not archive.is_file(): continue
            if not (archive.name.startswith('紅魔郷') and archive.suffix == '.DAT' if game == 6 else archive.name.lower() == f'th{game:02}.dat'): continue
            names = [line.split()[0] for line in anm.run([args.thtk/'thdat.exe','-l',game,archive]).splitlines()[1:] if line.split()]
            selected = [n for n in names if re.search(r'(^|/)(player\d+|pl\d+|ply\d+)',n) and n.endswith(('.anm','.sht','.png'))]
            if not selected: continue
            anm.run([args.thtk/'thdat.exe','-C',directory,'-x',game,archive,*selected])
            for name in selected:
                p = directory/name
                if p.suffix == '.sht': data[p.stem] = sht(p,game)
                elif p.suffix == '.anm':
                    decl = anm.run([args.thtk/'thanm.exe','-l',game,p])
                    if game != 6: anm.run([args.thtk/'thanm.exe','-x',game,p],cwd=directory)
                    dest = ROOT/'Resources/Original'/str(game); dest.mkdir(parents=True, exist_ok=True)
                    model = anm.parse(decl,directory,dest,game,p.stem)
                    model.update(game=game,archive=p.stem)
                    (ROOT/'mod/GAME/original'/str(game)/(p.stem+'.lua')).write_text('-- 原作自机 ANM 自动导出。\nreturn '+anm.lua(model)+'\n','utf8',newline='\n')
                manifest[f'{game}/{name}'] = hashlib.sha256(p.read_bytes()).hexdigest()
        result[game] = data
    out=ROOT/'mod/GAME/original/players';out.mkdir(parents=True,exist_ok=True)
    for game, data in result.items():
        (out/f'{game}.lua').write_text('-- 原作射击表自动导出；数值来自源 SHT 或红魔乡 BulletData.cpp。\nreturn '+anm.lua(data)+'\n','utf8',newline='\n')
    (out/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n','utf8')
    bombs={}
    for game,path in ((6,'src/BombData.cpp'),(7,'src/th07/BombData.cpp'),(8,'src/PlayerBomb.cpp')):
        source=(args.workspace/f'th{game:02}'/path).read_text('utf8')
        profiles={}
        for match in re.finditer(r'void (?:__fastcall )?(?:BombData::)?(\w+)\([^\n]*\)\s*\{',source):
            begin=match.end();depth=1;end=begin
            while depth:
                if source[end]=='{':depth+=1
                elif source[end]=='}':depth-=1
                end+=1
            body=source[begin:end-1]
            if game<8:
                duration=re.search(r'(?:duration|bombDuration) = (\d+);',body)
                protect=re.search(r'invulnerabilityTimer = (\d+);',body)
                if not duration or not protect:continue
                key=match[1].replace('Bomb','').replace('Calc','').replace('Focus','_slow').lower()
            else:
                call=re.search(r'BeginBombSpell\(player,\s*[^,]+,\s*"[^"]+",\s*(\d+),\s*(\d+),',body)
                if not call:continue
                duration,protect=call,call
                key=match[1]
            row={'duration':int(duration[1]),'protect':int(protect[2] if game==8 else protect[1]),'source':f'th{game:02}/{path}:{source[:match.start()].count(chr(10))+1}'}
            drain=re.search(r'ComputeBombCherryDrain\(player, (\d+), ([\d.]+)f',body)
            if drain:row['cherryCost'],row['cherryRate']=int(drain[1]),float(drain[2])
            profiles[key]=row
        bombs[game]=profiles
    (out/'bombs.lua').write_text('-- 原作 Bomb 时长、无敌时间与樱点消耗，直接从源码导出。\nreturn '+anm.lua(bombs)+'\n','utf8',newline='\n')
    print('已导出', sum(len(v) for v in result.values()), '份原作射击表及自机 ANM')


if __name__ == '__main__': main()
