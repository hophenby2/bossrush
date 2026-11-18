"""把蜈蚣专用的原版 actors / scene / randoms / births / effects / corpses 记录压缩成回归样本。"""
import argparse
from collections import defaultdict
from pathlib import Path


def compile_reference(prefix, output):
    def read(suffix):
        with Path(str(prefix)+'.'+suffix).open(encoding='utf-8') as stream:
            return [list(map(int, line.split())) for line in stream]

    def digest(rows):
        value = 0
        for row in rows:
            for number in row:
                value = (value*131+number) % 16777213
        return value

    def lua(value):
        if isinstance(value, dict):
            return '{'+','.join('['+str(k)+']='+lua(v) for k, v in value.items())+'}'
        if isinstance(value, list):
            return '{'+','.join(map(lua, value))+'}'
        if isinstance(value, str):
            return '"'+value+'"'
        return str(value)

    actors = {r[0]: r[4:] for r in read('actors')}
    scene = {r[0]: r for r in read('scene')}
    randoms, births, effects, corpses = (read(s) for s in ('randoms','births','effects','corpses'))
    entries = {0xC0AD3CE,0xC0ADDE8,0xC0ADF1A,0xC0AE040,0xC09CF7A,0xC09D048}
    starts = sorted(f for f, a in actors.items() if a[14] == 1)
    lines = ['-- 专用原版记录：HP 置 1 后由原碰撞回调触发击破，自机横坐标跟随头部。',
             '-- 只比较击破回调；不把测试注入算作自然通关。哈希模数 16777213，乘数 131。','return {']
    for start in starts:
        stop, end = start+122, start+232
        allocated = [r for r in births if start < r[0] <= stop and r[2] in entries]
        ids = {(r[0], r[1]): i+1 for i, r in enumerate(allocated)}
        frames = defaultdict(list)
        for r in effects:
            key = r[2], r[1]
            if key not in ids or not start < r[0] <= end or r[3] == 0:
                continue
            a = r[3:]
            frames[r[0]].append([ids[key],a[3],a[4],a[5],a[9],a[10],a[1],a[28],
                                 a[29] if a[1] else 0,a[31] if a[1] else 0,a[35],a[37],a[6]])
        fx_rows = [[f-start,*row] for f in sorted(frames) for row in sorted(frames[f])]
        controller = [[f-start,actors[f][1],actors[f][2],*[actors[f][i//4] for i in (56,60,64,68,72,76,80,88,236)]]
                      for f in range(start+1,stop+1)]
        before = [r[2:] for r in corpses if r[0] == stop-1]
        old_slots = {r[1] for r in corpses if r[0] == stop-1}
        new_slots = sorted({r[1] for r in corpses if r[0] == stop} - old_slots)
        corpse_rows = []
        for r in corpses:
            if not stop <= r[0] <= end or r[1] not in new_slots:
                continue
            a = r[2:]
            corpse_rows.append([r[0]-start,new_slots.index(r[1])+1,(a[0]>>8)&255,a[1],a[2],
                                a[0]&255,(a[4]>>24)&255,(a[5]>>16)&65535,(a[7]>>16)&65535])
        case = dict(frame=start,x=actors[start][1],y=actors[start][2],
                    scroll=''.join(str(scene[f][16]//65536) for f in range(start+1,end+1)),
                    randoms=[[r[0]-start,r[2],r[3]] for r in randoms if start < r[0] <= stop and 0xC0ACE50 <= r[1] <= 0xC0AE500],
                    corpseRandoms=[r[3] for r in randoms if r[0] == stop and r[1] == 0xC09B6B8],
                    before=[[a[1],a[2]] for a in before],controllerHash=digest(controller),
                    effectHash=digest(fx_rows),effectStates=len(fx_rows),effects=len(ids),
                    corpseHash=digest(corpse_rows),corpseStates=len(corpse_rows),corpses=len(new_slots))
        lines.append('    {'+',\n     '.join(k+'='+lua(v) for k, v in case.items())+'},')
    lines.append('}')
    output.parent.mkdir(parents=True,exist_ok=True)
    output.write_text('\n'.join(lines)+'\n',encoding='utf-8')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('prefix',type=Path)
    parser.add_argument('output',type=Path)
    args = parser.parse_args()
    compile_reference(args.prefix,args.output)
