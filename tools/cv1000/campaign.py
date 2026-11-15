"""将 CV1000 实战采样切成 LuaSTG 原生关卡及逐关素材。"""
import argparse
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
import struct

import numpy as np

from export import (GAMES, Materials, ROOT, boss_piece, enemy, enemy_bullet, find_tracks,
                    fixed, frames, pilot, pose, save_level, scenery_tile, visible)


@dataclass(frozen=True)
class Battle:
    start: int
    defeat: int
    end: int
    hp: int
    groups: tuple = ()
    change: tuple = ()


@dataclass(frozen=True)
class Level:
    start: int
    battles: tuple
    restart: int = 0
    forest: bool = False


def groups(text):
    return tuple(tuple(map(int, value.split(':'))) for value in text.split())


FUTARI = (
    (),
    groups('9:22 9:23 0:21 0:20 42:18 42:19 27:19 5:22 5:23 2:23 19:19 29:18 46:18 4:21 5:20 33:21 3:21 33:20 2:22 28:23 28:22'),
    groups('20:20 20:21 21:20 21:21 17:20 15:20 15:22 23:20 12:21 46:21 27:21 24:20 29:21 11:21 39:21 33:21 13:22 23:21 45:21 43:21 53:21'),
    groups('37:23 41:19 53:20 47:21 53:21 51:21 5:23 61:20 7:20 11:20 45:20 3:21 58:20 59:20 63:20 1:21 49:21 19:21 52:20 39:22 39:23 36:22 36:23 37:22'),
    groups('35:26 35:27 36:26 36:27 37:26 37:27 34:27 59:21 14:23 56:20 57:21 38:20 37:21 56:21 39:20 38:20 36:20 36:21 17:20 17:21 40:20 1:22 1:23 47:21 35:20'),
)
ESP = (
    groups('11:25 8:25 10:24 11:24 3:24 3:25 8:24 10:25 6:25 6:24 2:24 9:24 5:24 9:25 2:25 7:24 7:25 5:25'),
    groups('55:22 62:20 61:21 46:22 55:23 1:22 44:22 53:22 7:23 61:20 6:23 59:21 49:23 26:23 56:22 34:23 58:20 63:20 51:22 63:21 21:22 34:24 56:23'),
    groups('34:22 9:22 14:22 1:18 17:22 14:23 15:23 4:22 17:23 22:20 5:23 4:23 6:23 13:22 16:23 5:22 13:23 11:22 7:22 10:22 7:23 6:22 8:22 10:23'),
    groups('51:24 51:25 53:24 48:25 50:24 32:24 48:24 32:25 50:25 53:25 37:25 36:24 37:24 36:25 54:24 56:24 31:25 31:24 52:24 33:24 30:24 39:24 35:24 33:25'),
    groups('51:24 52:25 52:24 55:25 55:24 33:27 51:25 54:25 11:26 50:24 53:25 59:25 57:25 53:24 8:27 29:27 28:26 50:25 36:26 29:26 61:24 31:26 11:27 37:26 34:26 57:24 59:24 45:26 39:26'),
    groups('25:19 24:18 5:20 5:21 51:18 2:20 44:18 2:21 20:21 56:18 53:18 53:19 59:18 56:19 50:19 23:21 33:20 50:18 22:20 25:20 30:20 24:20 52:18 23:20'),
    groups('63:20 62:20 59:18 46:20 63:21 28:18 54:19 55:18 7:20 56:18 3:21 39:20 59:21 58:21 2:20 57:18 44:21 55:19 1:24 1:25 58:24 59:25 58:25 39:23 56:24 56:25 59:24 57:25 36:23 47:21 44:21 22:24 34:23 47:20'),
)
LEVELS = {
    'futari15': (
        Level(5430,(Battle(10940,13415,14020,11800),)),
        Level(14560,(Battle(22860,27380,27910,13000,FUTARI[1],((24500,9500),(26700,3600))),)),
        Level(28540,(Battle(37600,43240,43870,15800,FUTARI[2],((39300,11500),(41700,5600))),),forest=True),
        Level(44580,(Battle(57550,61980,62780,17800,FUTARI[3],((59300,12500),(60900,5200))),)),
        Level(63340,(Battle(80600,90850,91540,23000,FUTARI[4],((85500,15500),(87600,8900),(89700,3500))),),72202),
    ),
    'futariblj': (
        Level(5130,(Battle(10715,12240,12800,11800),)),
        Level(13350,(Battle(21690,24560,25100,13000,FUTARI[1],((22950,9000),(24150,3500))),)),
        Level(26150,(Battle(35480,40150,40850,15800,FUTARI[2],((36500,11500),(38800,5200))),),forest=True),
        Level(41730,(Battle(55400,58460,59050,17800,FUTARI[3],((56600,12500),(57750,5200))),)),
        Level(59350,(Battle(77050,83230,83830,23000,FUTARI[4],((78600,15500),(80200,8900),(81800,3500))),),65602),
    ),
    'espgal2': (
        Level(5310,(Battle(9759,12570,13100,13200,ESP[0]),)),
        Level(13270,(Battle(19600,22520,24120,15500,ESP[1],((20580,10500),(21900,4900))),)),
        Level(24500,(Battle(27850,30200,30700,12000,ESP[2],((29100,5900),)),
                     Battle(34520,40920,41540,17000,ESP[3],((36700,11200),(38700,5400))))),
        Level(41800,(Battle(47920,57640,58120,20000,ESP[4],((51600,14200),(54800,7500),(56800,3000))),)),
        Level(58470,(Battle(65520,75050,75800,23000,ESP[5],((68300,16700),(70900,11000),(73700,4700))),),65302),
        Level(76300,(Battle(88580,94450,94900,21000,ESP[6],((91500,10200),(93450,4900))),
                     Battle(94900,112260,113500,25000,ESP[6],((98200,17500),(101100,11200),(105500,4900)))),76300),
    ),
}


def battle_draw(d, battle, futari):
    if not battle.groups:
        return boss_piece(d,futari)
    x,y=d.center
    return ((d.sx//128,d.sy//128) in battle.groups and 20<=d.w<=256 and 20<=d.h<=256
            and 75<x<425 and -72<y<312)


def combat_sprite(d, futari):
    if d.attr&0x200 or d.tint_gb!=0x8080 or d.tint!=0x80:
        return False
    if enemy(d,futari):
        return True
    low, high = (1024,3552) if futari else (1024,3664)
    return low<=d.sy<high and 16<=d.w<=144 and 16<=d.h<=144


def stage_scenery(d, futari_forest):
    if not scenery_tile(d):
        return False
    if futari_forest and d.attr&0x200 and d.w==d.h==256 and (d.sx,d.sy)==(1792,1792):
        # 原版以灰阶遮罩参与混色。当前渲染器按源透明度的高四位绘制。
        return (d.alpha>>12)*16
    return None


def campaign_bullet(d, futari):
    if enemy_bullet(d,futari):
        return True
    if not (d.tint==0x80 and d.tint_gb==0x8080 and 8<=d.w<=32 and 8<=d.h<=32):
        return False
    if futari:
        return 1024<=d.sy<1264 and (2160<=d.sx<2304 or 2560<=d.sx<2736
                                   or 3200<=d.sx<3584 or 3776<=d.sx<4096)
    return ((1408<=d.sx<1440 and 1536<=d.sy<1600)
            or (6208<=d.sx<6512 or 6848<=d.sx<6912) and 1216<=d.sy<1504)


def compatible(a,b):
    return abs(a[0]-b[0])<=1 and abs(a[1]-b[1])<=1


def frame_stream(primary, tail, level):
    last=level.battles[-1].end
    # 保存状态的采样边界可能相差一帧，两个来源都必须覆盖交接区间。
    spans=[(primary,level.start,min(level.restart-1,last) if level.restart else last)]
    if level.restart:
        spans.append((tail,max(level.restart,level.start),last))
    for filename,start,end in spans:
        if start>end:
            continue
        for frame,cx,cy,rows in frames(filename):
            if frame>end:
                break
            if frame>=start:
                yield frame,cx,cy,rows


def texture_uploads(path):
    if not path:
        return
    with path.open('rb') as file:
        assert file.read(4)==b'CVU1', f'{path} 的显存上传格式错误'
        while header:=file.read(14):
            frame,x,y,w,h,offset=struct.unpack('>I5H',header)
            size=(offset+w*h*2+7)&~7
            block=file.read(size)
            if len(block)!=size:
                raise ValueError(f'{path} 第 {frame} 帧上传记录截断')
            source=np.frombuffer(block,dtype='<u2').reshape((-1,4))[:,::-1].flatten()
            source=source[offset//2:offset//2+w*h].astype('u4').reshape((h,w))
            pixels=((source&0x8000)<<14)|((source&0x7c00)<<9)|((source&0x03e0)<<6)|((source&31)<<3)
            yield frame,x,y,pixels


def collect(primary,tail,material,level,futari,uploads):
    enemies,shots,views=[],[],[]
    active_enemies,active_shots=[],[]
    enemy_trails,shot_trails={},{}
    previous_bg=None
    battles=level.battles
    boss_frames=[[] for _ in battles]
    view_ticks=set()
    required={point for b in battles for point in (b.start,b.defeat,*(t for t,_ in b.change))}
    last_frame=0
    texture_stream=texture_uploads(uploads)
    upload=next(texture_stream,None)
    for frame,cx,cy,rows in frame_stream(primary,tail,level):
        if last_frame and frame!=last_frame+1:
            raise ValueError(f'关卡 {level.start} 的命令流缺少第 {last_frame+1} 帧')
        last_frame=frame
        material.at(frame)
        while upload and upload[0]<=frame:
            material.upload(*upload[1:])
            upload=next(texture_stream,None)
        tick=frame-level.start
        index=next((i for i,b in enumerate(battles) if b.start<=frame<=b.end),None)
        battle=battles[index] if index is not None else None
        backgrounds,enemy_draws,bullet_draws,boss_draws=[],[],[],[]
        projectile_centers=set()
        for d in visible(rows,cx,cy):
            if not d.attr&0x100 or d.w>256 or d.h>256 or d.sx<360 and d.sy<160 or pilot(d,futari):
                continue
            x,y=d.center
            if campaign_bullet(d,futari):
                key=(x,y,d.sx,d.sy)
                if key not in projectile_centers and (image:=material.image(d)):
                    projectile_centers.add(key)
                    bullet_draws.append((d.shape,x,y,image,tick,d.w,d.h))
            elif battle and battle_draw(d,battle,futari):
                if image:=material.image(d):
                    boss_draws.append((d,image))
            else:
                opacity=stage_scenery(d,level.forest)
                if opacity is False:
                    if not battle and combat_sprite(d,futari):
                        enemy_draws.append((d.shape,x,y,d,tick,d.w,d.h))
                    continue
                if opacity==0:
                    continue
                if image:=material.image(d,True,opacity=opacity):
                    backgrounds.append(pose(d,image))
        active_enemies=list(find_tracks(enemy_draws,active_enemies,8,compatible))
        active_shots=list(find_tracks(bullet_draws,active_shots,9,compatible))
        enemy_trails.update((id(trail),trail) for _,trail in active_enemies)
        shot_trails.update((id(trail),trail) for _,trail in active_shots)
        if battle:
            body=boss_frames[index]
            if boss_draws:
                # 大型本体的多块图保留相对位置。小部件和闪烁不参与本体中心估计。
                central=[d for d,_ in boss_draws if 36<d.center[1]<204]
                central=central or [d for d,_ in boss_draws]
                bx=sum(d.center[0] for d in central)//len(central)
                by=sum(d.center[1] for d in central)//len(central)
                layers=[(image,d.x-bx,d.y-by) for d,image in boss_draws]
                if len(layers)>255:
                    # 上传或闪光使用密集小块。优先保留面积较大的本体层。
                    largest=set(sorted(range(len(layers)),key=lambda j:boss_draws[j][0].w*boss_draws[j][0].h,
                                       reverse=True)[:255])
                    layers=[layer for j,layer in enumerate(layers) if j in largest]
            else:
                bx,by=(body[-1][0]//64,body[-1][1]//64) if body else (300,120)
                layers=[]
            body.append((*fixed(bx,by),layers))
        if (tick%2==0 or frame in required) and (backgrounds!=previous_bg or frame in required):
            views.append((tick,0,0,[],backgrounds))
            view_ticks.add(tick)
            previous_bg=backgrounds
    assert last_frame==battles[-1].end, (level.start,last_frame,battles[-1].end)
    positions=defaultdict(list)
    for trail in enemy_trails.values():
        if len(trail)<16:
            continue
        x,y,d,tick,w,h=trail[0]
        if len({(v[0],v[1]) for v in trail})<8 and not enemy(d,futari):
            continue
        rows=[]
        for x,y,d,frame,*_ in trail:
            material.at(frame+level.start)
            img=material.image(d)
            rows.append((*fixed(x,y),[(img,d.x-x,d.y-y)] if img else []))
        if not any(row[2] for row in rows):
            continue
        eid=len(enemies)+1
        enemies.append([eid,tick,1,min(900,75+w*h//8),w*20,h*20,0,rows])
        for i,(x,y,_) in enumerate(rows):
            positions[tick+i].append((x//64,y//64,eid))
    route_data=[]
    bosses=[]
    for n,(battle,body) in enumerate(zip(battles,boss_frames),2):
        start=battle.start-level.start
        defeat=battle.defeat-level.start
        end=battle.end-level.start
        first=next((i for i,row in enumerate(body) if row[2]),None)
        assert first is not None and first<660, (battle.start,first)
        changes=[(t-level.start,hp) for t,hp in battle.change]
        cuts=[start,*(t for t,_ in changes),defeat,end+1]
        for a,b in zip(cuts,cuts[1:]):
            boss_id=len(enemies)+1
            enemies.append([boss_id,a,n,battle.hp,32*64,29*64,2,body[a-start:b-start]])
            if a<defeat:
                bosses.append((a,b,boss_id))
        route_data.append((n,battle.hp,start,cuts[1]-1,defeat,end,changes))
    for trail in shot_trails.values():
        if len(trail)<4 or max(abs(trail[-1][0]-trail[0][0]),abs(trail[-1][1]-trail[0][1]))<4:
            continue
        x,y,image,tick,w,h=trail[0]
        owner=next((eid for a,b,eid in bosses if a<=tick<b),0)
        if not owner:
            distance,owner=min((((x-px)**2+(y-py)**2,eid) for px,py,eid in positions[tick]),default=(999999,0))
            if distance>48**2:
                owner=0
        visuals=[]
        for age,(_,_,img,_,width,height) in enumerate(trail):
            visual=(img,-width*32,-height*32,1)
            if not visuals or visual!=visuals[-1][1:]:
                visuals.append((age,*visual))
        shots.append([tick,owner,*fixed(x,y),0,0,2*64,2*64,0,0,0,image,0,
                      [fixed(x,y) for x,y,*_ in trail],visuals])
    assert len(enemies)>10 and len(shots)>100 and 0 in view_ticks
    return (enemies,shots,views),route_data


def lua_rows(rows):
    return ''.join('    {'+','.join(map(str,row))+'},\n' for row in rows)


def save_stage(primary,tail,material,level,game,index,output,more,uploads):
    code=GAMES[game].code
    content,routes=collect(primary,tail,material,level,game!='espgal2',uploads)
    data=output/'mod/GAME'/code
    assets=output/'Resources'/code/f'stage{index}'
    data.mkdir(parents=True,exist_ok=True)
    assets.mkdir(parents=True,exist_ok=True)
    save_level(content,data,material.tiles,material.art,[],[],
               dict(wide=1,scenery=1,shotVisuals=1,shotLifetime=1),stage_number=index)
    lines=['-- 由 tools/cv1000/campaign.py 生成。','return {',
           f'  last={routes[0][3]}, loop={routes[0][2]},',
           '  routes={']
    for i,(kind,hp,start,last,defeat,end,changes) in enumerate(routes):
        route=[f'hp={hp}',f'last={last}',f'loop={start}',f'defeat={defeat}',f'defeatEnd={end}',
               'next='+str(int(more))]
        if i+1<len(routes):
            route.append(f'resume={end+1}')
            route.append(f'resumeLast={routes[i+1][3]}')
            route.append(f'resumeLoop={routes[i+1][2]}')
        if changes:
            ends=[*(frame-1 for frame,_ in changes[1:]),defeat-1]
            phase=[f'{{hp={hp},first={frame},last={last}}}' for (frame,hp),last in zip(changes,ends)]
            route.append('phases={'+','.join(phase)+'}')
        lines.append(f'    [{kind}]={{'+','.join(route)+'},')
    lines.extend(['  },','  tiles={',lua_rows(material.tiles.rects).rstrip(),
                  '  },','  sprites={',lua_rows(material.art.rects).rstrip(),'  },','}'])
    (data/f'stage{index}.lua').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    material.tiles.save(assets)
    material.art.save(assets)
    print(code,index,tuple(map(len,content)),len(material.tiles.rects),len(material.art.rects),flush=True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('game',choices=LEVELS)
    parser.add_argument('primary',type=Path)
    parser.add_argument('tail',type=Path)
    parser.add_argument('--vram',type=Path,action='append',required=True)
    parser.add_argument('--uploads',type=Path)
    parser.add_argument('--stage',type=int,action='append')
    parser.add_argument('--output',type=Path,default=ROOT)
    args=parser.parse_args()
    levels=LEVELS[args.game]
    for index in args.stage or range(1,len(levels)+1):
        stage=levels[index-1]
        # 前后邻近显存可为还在同一关的过场补齐素材。
        snapshots=[(int(path.suffix[1:]),path) for path in args.vram
                   if stage.start-4000<=int(path.suffix[1:])<=stage.battles[-1].end+2000]
        assert snapshots, (args.game,index)
        save_stage(args.primary,args.tail,Materials(snapshots),stage,args.game,index,args.output,index<len(levels),
                   args.uploads)


if __name__=='__main__':
    main()
