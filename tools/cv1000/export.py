"""把 CV1000 第一面采样导出为可碰撞的 LuaSTG 敌机和敌弹。"""
import argparse
from collections import defaultdict
from dataclasses import dataclass
from functools import lru_cache
from hashlib import blake2b
from pathlib import Path
import sys

import numpy as np
from PIL import Image

from analyze import decode_sprite, frames

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from ketsui.export import Atlas, ROOT, save_level


@dataclass(frozen=True)
class Game:
    code: str
    first: int
    boss: int
    end: int
    loop: int
    shot: tuple
    hp: int


GAMES = {
    'futari15': Game('th46', 5430, 10930, 15794, 11651, (2512,512,16,8), 11800),
    'espgal2': Game('th47', 5310, 9759, 14515, 11000, (1440,608,24,24), 13200),
    'futariblj': Game('th48', 5130, 10701, 15397, 11230, (2512,512,16,8), 11800),
}


def signed(word):
    return (word ^ 32768) - 32768


@dataclass(frozen=True)
class Draw:
    attr: int
    alpha: int
    sx: int
    sy: int
    x: int
    y: int
    w: int
    h: int
    tint: int
    tint_gb: int

    @property
    def center(self):
        return self.x+self.w//2, self.y+self.h//2

    @property
    def shape(self):
        return self.sx//128, self.sy//128, self.w, self.h


def visible(rows, cx, cy):
    for attr,alpha,sx,sy,x,y,w,h,tint,gb in rows:
        x,y=signed(x)-cx,signed(y)-cy
        w,h=(w&8191)+1,(h&4095)+1
        sx,sy=sx&8191,sy&4095
        if sx+w<=8192 and sy+h<=4096 and x<320 and y<240 and x+w>0 and y+h>0:
            yield Draw(attr,alpha,sx,sy,x,y,w,h,tint&255,gb)


def pilot(d, futari):
    if futari:
        return 6384<=d.sx<6912 and 240<=d.sy<512 and d.tint in (0x78,0x80)
    return 7440<=d.sx<7584 and 512<=d.sy<744 and d.tint==0x80


def enemy_bullet(d, futari):
    if not d.attr&0x100 or d.tint!=0x80 or d.tint_gb!=0x8080:
        return False
    if futari:
        return ((1784<=d.sx<1820 and 1024<=d.sy<1250)
                or (2160<=d.sx<2224 and 1024<=d.sy<1208)
                or (2712<=d.sx<2864 and 1024<=d.sy<1264)) and 8<=d.w<=32 and 8<=d.h<=32
    return 6272<=d.sx<6416 and 1024<=d.sy<1488 and d.w==d.h==16


def scenery_tile(d):
    return d.sy>=3744 and d.w==d.h==32 or background(d)


def boss_piece(d, futari):
    if futari:
        return ((3600<=d.sx<=3792 and 2304<=d.sy<=2500)
                or (d.sx in (2208,2848) and d.sy==2304)
                or (6496<=d.sx<=6624 and 2720<=d.sy<=2800)) and (d.w,d.h)!=(32,32)
    return ((432<=d.sx<540 or 1016<=d.sx<1104 or 1504<=d.sx<1552)
            and 3072<=d.sy<3376 and d.w>=24 and d.h>=24)


def enemy(d, futari):
    if d.tint!=0x80 or d.tint_gb!=0x8080 or not d.attr&0x100:
        return False
    if futari:
        return ((7104<=d.sx<7440 and 2048<=d.sy<2200 and max(d.w,d.h)>=64)
                or (d.sx//128,d.sy//128) in {
                    (9,15),(16,15),(17,14),(20,14),(21,14),(30,15),(55,16),(9,14),(15,8),
                })
    return (d.sx//128,d.sy//128) in {
        (36,9),(36,8),(24,11),(37,8),(7,11),(37,9),(34,9),(6,10),(35,8),(35,9),
        (7,10),(33,10),(38,8),(40,8),
    }


def background(d):
    # 0x1301 同样可用于地形。天空底片、地形小图块与大块地形按指令顺序绘制。
    if d.w==d.h==32 and d.sy>=1536 and d.tint==0x80 and d.tint_gb==0x8080 and d.attr&0x200==0:
        return True
    return d.w==d.h and d.w in (128,256) or d.w>=128 and d.h>=120


class Materials:
    def __init__(self, snapshots):
        self.snapshots=sorted((frame,np.memmap(path,dtype='<u4',mode='r',shape=(4096,8192)))
                              for frame,path in snapshots)
        self.tiles=Atlas('tiles', lambda key, _: self.decode(key))
        self.art=Atlas('sprites', lambda key, _: self.decode(key))
        self.blank=set()
        self.decoded_ids={}
        self.pixel_ids={}
        self.tile_uploads={}
        self.tile_overlays={}
        self.upload_count=0

    def decode(self, key):
        i,sx,sy,w,h,flags,opacity=key
        if i<0:
            _,pixels=self.tile_uploads[sx,sy]
            image=decode_sprite(pixels,0,0,w,h,flags)
        else:
            image=decode_sprite(self.snapshots[i][1],sx,sy,w,h,flags)
        if opacity!=255:
            image.putalpha(image.getchannel('A').point(lambda a:a*opacity//255))
        return image

    def upload(self,x,y,pixels):
        h,w=pixels.shape
        for ty in range(y//32*32,y+h,32):
            for tx in range(x//32*32,x+w,32):
                key=tx,ty
                if key not in self.tile_overlays:
                    self.tile_overlays[key]=(np.zeros((32,32),dtype='u4'),np.zeros((32,32),dtype=bool))
                tile,known=self.tile_overlays[key]
                x0,x1=max(x,tx),min(x+w,tx+32)
                y0,y1=max(y,ty),min(y+h,ty+32)
                region=np.s_[y0-ty:y1-ty,x0-tx:x1-tx]
                update=pixels[y0-y:y1-y,x0-x:x1-x]
                if known[region].all() and np.array_equal(tile[region],update):
                    continue
                tile[region]=update
                known[region]=True
                if not known.all():
                    continue
                self.upload_count+=1
                self.tile_uploads[key]=(-self.upload_count,tile.copy())

    def image(self, d, tiles=False, opacity=None):
        if opacity is None and tiles and d.attr&0x200:
            if d.tint==0 and d.tint_gb==0:
                return 0
            if d.sx<256 and 1792<=d.sy<2048 and d.w==d.h==256:
                opacity=96
            elif d.alpha<0xff00:
                opacity=192
        if opacity is None:
            opacity=255
        coordinates=d.sx,d.sy,d.w,d.h,d.attr&0xd00,opacity
        atlas=self.tiles if tiles else self.art
        uploaded=self.tile_uploads.get((d.sx,d.sy)) if tiles and d.w==d.h==32 else None
        order=(uploaded[0],*self.order) if uploaded else self.order
        for i in order:
            key=i,*coordinates
            lookup=(tiles,key)
            if lookup in self.decoded_ids:
                return self.decoded_ids[lookup]
            if key in self.blank:
                continue
            if key not in atlas.ids and d.attr&0x100:
                pixels=uploaded[1] if i<0 else self.snapshots[i][1][d.sy:d.sy+d.h,d.sx:d.sx+d.w]
                if not np.any(pixels&0x20000000):
                    self.blank.add(key)
                    continue
            image=self.decode(key)
            fingerprint=(tiles,image.size,blake2b(image.tobytes(),digest_size=16).digest())
            index=self.pixel_ids.get(fingerprint)
            if index is None:
                original=atlas.decode
                atlas.decode=lambda *_: image
                try:
                    index=atlas.get(key,None)
                finally:
                    atlas.decode=original
                self.pixel_ids[fingerprint]=index
            self.decoded_ids[lookup]=index
            return index
        return 0

    @lru_cache(maxsize=128)
    def order_at(self, slot):
        return sorted(range(len(self.snapshots)),key=lambda i:abs(slot-self.snapshots[i][0]))

    def at(self, frame):
        self.order=self.order_at(frame//32*32)

    def player_image(self, ship, index):
        decode=self.art.decode
        self.art.decode=lambda *_: ship
        try:
            return self.art.get(('player',index),None)
        finally:
            self.art.decode=decode


def find_tracks(candidates, active, distance, compatible=None):
    nearby=defaultdict(list)
    for i,(key,trail) in enumerate(active):
        x,y=trail[-1][0:2]
        nearby[(x//16,y//16)].append((i,key,x,y,trail))
    used=set()
    for key,x,y,*extra in candidates:
        options=[]
        for a in range((x-distance)//16,(x+distance)//16+1):
            for b in range((y-distance)//16,(y+distance)//16+1):
                for i,k,px,py,trail in nearby[a,b]:
                    d=(px-x)**2+(py-y)**2
                    if i not in used and d<=distance**2 and (not compatible or compatible(k,key)):
                        options.append((d+(distance if k!=key else 0),i,trail))
        if options:
            _,i,trail=min(options,key=lambda o:o[:2])
            used.add(i)
        else:
            trail=[]
        trail.append((x,y,*extra))
        yield key,trail


def fixed(x,y):
    return x*64,y*64


def pose(d,image):
    return image,d.x,d.y


def compile_game(trace, materials, game, futari):
    enemies,shots,views=[],[],[]
    active_enemies,active_shots=[],[]
    completed_enemies,completed_shots={},{}
    pilot_frames={}
    body=[]
    previous_bg=None
    for frame,cx,cy,rows in frames(trace):
        if not game.first<=frame<=game.end:
            continue
        tick=frame-game.first
        materials.at(frame)
        backgrounds,enemy_draws,bullet_draws,boss_draws,player_draws=[],[],[],[],[]
        for d in visible(rows,cx,cy):
            x,y=d.center
            if d.attr&0x100==0 or d.sx<360 and d.sy<160 or d.w>256 or d.h>256:
                continue
            if pilot(d,futari):
                if -48<x<140 and 77<y<162 and d.y>=91 and d.y+d.h<=148:
                    if image:=materials.image(d): player_draws.append(pose(d,image))
            elif frame>=game.boss and boss_piece(d,futari):
                if image:=materials.image(d): boss_draws.append(pose(d,image))
            elif enemy_bullet(d,futari):
                if image:=materials.image(d): bullet_draws.append((d.shape,x,y,image,tick,d.w,d.h))
            elif frame<game.boss and enemy(d,futari):
                if image:=materials.image(d): enemy_draws.append((d.shape,x,y,pose(d,image),tick,d.w,d.h))
            elif background(d):
                if image:=materials.image(d,True): backgrounds.append(pose(d,image))
        if player_draws:
            parts=tuple((image,x-min(i[1] for i in player_draws),y-96 if futari else y-103)
                        for image,x,y in player_draws)
            pilot_frames[parts]=pilot_frames.get(parts,0)+1
        active_enemies=list(find_tracks(enemy_draws,active_enemies,7))
        active_shots=list(find_tracks(bullet_draws,active_shots,8))
        completed_enemies.update((id(track),track) for _,track in active_enemies)
        completed_shots.update((id(track),track) for _,track in active_shots)
        if frame>=game.boss:
            # 关底用整组部件渲染，主体判定跟随前部精灵。
            anchor=min(boss_draws,key=lambda part:part[1],default=None)
            if anchor:
                bx,by=anchor[1]+20,anchor[2]+20
            else:
                if not body:
                    raise ValueError(f'{game.code} 第 {frame} 帧缺关底精灵')
                bx,by=body[-1][0]//64,body[-1][1]//64
            body.append((*fixed(bx,by),[(img,x-bx,y-by) for img,x,y in boss_draws]))
        if backgrounds!=previous_bg:
            views.append((tick,0,0,[],backgrounds))
        previous_bg=backgrounds

    for trail in completed_enemies.values():
        if len(trail)<14:
            continue
        x,y,layer,tick,w,h=trail[0]
        enemy_id=len(enemies)+1
        poses=[(*fixed(x,y),[(img,dx-x,dy-y)]) for x,y,(img,dx,dy),*rest in trail]
        enemies.append([enemy_id,tick,1,min(1100,90+w*h//6),w*22,h*22,0,poses])
    boss_frame=game.boss-game.first
    assert body and body[0][2], f'{game.code} 缺关底首帧'
    enemies.append([len(enemies)+1,boss_frame,2,game.hp,26*64,35*64,2,body])
    timeline=defaultdict(list)
    for eid,start,_,_,_,_,phase,poses in enemies:
        if phase==0:
            for age,(x,y,_) in enumerate(poses):
                timeline[start+age].append((x//64,y//64,eid))
    for trail in completed_shots.values():
        if len(trail)<4 or max(abs(trail[-1][0]-trail[0][0]),abs(trail[-1][1]-trail[0][1]))<4:
            continue
        x,y,image,tick,w,h=trail[0]
        if tick>=boss_frame:
            owner=len(enemies)
        else:
            distance,owner=min((((x-px)**2+(y-py)**2,eid) for px,py,eid in timeline[tick]),
                               default=(999999,0))
            if distance>54**2:
                owner=0
        visuals=[]
        for age,(_,_,img,_,width,height) in enumerate(trail):
            visual=(img,-width*32,-height*32,1)
            if not visuals or visual!=visuals[-1][1:]:
                visuals.append((age,*visual))
        shots.append([tick,owner,*fixed(x,y),0,0,2*64,2*64,0,0,0,image,0,
                      [fixed(x,y) for x,y,*rest in trail],visuals])
    assert len(enemies)>20 and len(shots)>100 and views and pilot_frames
    return (enemies,shots,views),pilot_frames


def ship_frames(materials, poses):
    frames=[]
    for pose,_ in sorted(poses.items(),key=lambda row:-row[1])[:8]:
        # 组合之后将纵向位置翻回游戏坐标，素材保持原图的转向。
        ship=Image.new('RGBA',(56,56))
        for image,x,y in pose:
            page,ax,ay,w,h=materials.art.rects[image-1]
            tile=materials.art.pages[page-1].crop((ax,ay,ax+w,ay+h))
            ship.paste(tile,(y+4,52-x-h),tile)
        if not ship.getbbox():
            continue
        frames.append((materials.player_image(ship,len(frames)),))
    return frames


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('game',choices=GAMES)
    parser.add_argument('trace',type=Path)
    parser.add_argument('--vram',type=Path)
    parser.add_argument('--vram-frame',type=int,default=10300)
    parser.add_argument('--extra-vram',action='append',default=[],metavar='帧=路径')
    parser.add_argument('--output',type=Path,default=ROOT)
    parser.add_argument('--preview',type=Path,required=True)
    args=parser.parse_args()
    game=GAMES[args.game]
    snapshots=[(args.vram_frame,args.vram or args.trace.with_name(args.trace.name+'.vram'))]
    for entry in args.extra_vram:
        frame,path=entry.split('=',1)
        snapshots.append((int(frame),Path(path)))
    materials=Materials(snapshots)
    content,poses=compile_game(args.trace,materials,game,args.game!='espgal2')
    player=ship_frames(materials,poses)
    materials.at(game.first+100)
    shot=Draw(0x100,0,*game.shot[:2],0,0,*game.shot[2:],128,32896)
    shot_id=materials.image(shot)
    assert player and shot_id
    player.append((shot_id,))
    output=args.output/'mod/GAME'/game.code
    resources=args.output/'Resources'/game.code
    output.mkdir(parents=True,exist_ok=True)
    resources.mkdir(parents=True,exist_ok=True)
    # 背景图块使用独立纹理页。
    config=dict(last=game.end-game.first,loop=game.loop-game.first,halfWidth=120,halfHeight=160,
                clockStep=1,clockUnit=1,wide=1,scenery=1,cvTiles=1,shotVisuals=1,shotLifetime=1)
    routes=[(2,game.hp,0,0,0,0,0,0,0)]
    save_level(content,output,materials.tiles,materials.art,[],player,config,'tools/cv1000/export.py',routes)
    for atlas in (materials.tiles,materials.art):
        for i,page in enumerate(atlas.pages,1):
            page.save(resources/f'{atlas.name}{i}.png',optimize=True)
    preview=Image.open(args.preview).convert('RGB')
    preview.thumbnail((384,512))
    preview.save(resources/'preview.png',optimize=True)
    print(game.code,tuple(map(len,content)),len(materials.tiles.pages),len(materials.art.pages))


if __name__=='__main__':
    main()
