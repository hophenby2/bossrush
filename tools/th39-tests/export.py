#!/usr/bin/env python3
"""从本地永夜篇脚本与 Content 离线展开 Lua 和纹理。"""
import argparse
from collections import Counter, defaultdict
import hashlib
from io import BytesIO
import json
from pathlib import Path
import re
import sys

from Crypto.Cipher import DES3
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'th37-tests'))
from export import (KEYS, PROPS, BATCH, RAND_BATCH, LASE, RAND_LASE, COVER, REBOUND,
                    FORCE, lua, atom)

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'mod/GAME/th39'
ART = ROOT / 'Resources/th39'
FIELDS = [
    ('batch', BATCH, RAND_BATCH, ['Cover', 'Rebound', 'Force', 'Deepbind', 'wscale', 'hscale', 'syncScale', 'instantMovement']),
    ('laser', LASE[:41] + ['segment'] + LASE[42:], RAND_LASE, ['Deepbind', 'colorR', 'colorG', 'colorB', 'head']),
    ('cover', COVER, RAND_BATCH[8:12], ['bindid', 'Deepbind', 'maskOn', 'maskType', 'maskMutex', 'degree']),
    ('rebound', REBOUND, RAND_BATCH[8:12], ['oneSide']),
    ('force', FORCE, RAND_BATCH[8:12], ['bindid', 'Deepbind']),
]
EVENT_FIELDS = {**PROPS, '进入遮罩瞬间': 'maskEntered', '状态': 'status', '状态帧': 'statusFrame'}
ROAD = set('SetEnemy CopyEnemy AddEvent SetEnemyItems SetNoHarmTime SetHideTime PauseByEnemy Pause BindFamiliar SetEnemyUnderneath SetEnemyBarrageDispel SetEnemyDeadCondition'.split())
PRESENTATION = set('PlayMusic FadeoutMusic FadeinMusic LoadBackGround ShowDialog SetEnemyBarrageUnderActor RaiseEffect SetBossItems SetEnemyExplo SetBackgroundEffect StopBackgroundEffect AdjustBackgroundEffect FadeinBackground FadeinEnvSound FadeoutEnvSound PlaySound SkipMusic ReplaceBackgroundEffect DistortEffect BreakBackgroundEffect SetBossCardBackground SetBossCardOpenEffect SetBossCardSide SetBossCardTip PreloadMusic SetBossDialogDelay KeepBackground TimeIgnoreBackground SetSpecialItem SetBossCardBombMoveFactor SetBossCardBarrageOrder SetBossCardDialog SetBossCardDispel LastBoss ExtraBoss PauseLantern Respawn PlaceTeammate StartProtect EndProtect'.split())
ACTORS = [
    ['莉格露·奈特巴格', 'Tewi'], ['今泉影狼', 'Kagerou'], ['因幡帝', 'Tewi'],
    ['因幡帝', 'Tewi'], ['上白泽慧音', 'Reisen'], ['铃仙·优昙华院·因幡', 'Reisen'],
    ['蓬莱山辉夜', 'Reisen'], ['八意永琳', 'Reisen'], ['EX Boss', 'Yukari'], ['EX Boss', 'Yukari'],
]


def tick(value):
    m, s, f = map(int, value.split(':'))
    return m * 3600 + s * 60 + f


def commands(script, character):
    lines = iter(script.splitlines())
    for line in lines:
        line = line.split('//', 1)[0].strip()
        if not line:
            continue
        if line.startswith('For '):
            first, last, step = map(tick, re.findall(r'\[([^]]+)\]', line))
            for body in lines:
                body = body.split('//', 1)[0].strip()
                if body == '}':
                    break
                if body and body != '{':
                    for t in range(first, last + 1, step):
                        yield t, body
            continue
        labels = re.findall(r'^((?:\[[^]]+\])+)', line)
        assert labels, line
        tags = re.findall(r'\[([^]]+)\]', labels[0])
        if any(tag not in ('头', character) for tag in tags[:-1]):
            continue
        yield tick(tags[-1]), line[len(labels[0]):].strip()


def split_command(command):
    m = re.fullmatch(r'(\w+)(?:\((.*)\))?', command)
    assert m, command
    return m[1], [arg.strip() for arg in m[2].split(',')] if m[2] else []


class Export:
    def __init__(self, source, content):
        self.source = source
        self.content = content
        self.hashes = {}
        self.counts = Counter()
        self.proxies = Counter()
        self.patterns = set()
        self.textures = {}
        self.next_id = 39000

    def read(self, path, key):
        data = path.read_bytes()
        self.hashes[str(path.relative_to(self.content))] = hashlib.sha256(data).hexdigest()
        decoded = DES3.new(KEYS[key], DES3.MODE_ECB).decrypt(data)
        pad = decoded[-1]
        assert 1 <= pad <= 8 and decoded[-pad:] == bytes([pad]) * pad, path
        return decoded[:-pad]

    def text(self, name):
        data = self.read(self.content / 'Data' / (name + '.xna'), 2)
        return data.decode('utf-16' if data.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig')

    def texture(self, name, relative):
        if name not in self.textures:
            data = self.read(self.content / relative, 0)
            with Image.open(BytesIO(data)) as img:
                self.textures[name] = img.height
                if img.format == 'PNG':
                    (ART / (name + '.png')).write_bytes(data)
                else:
                    img.convert('RGBA').save(ART / (name + '.png'))
        return name

    def action(self, a, kind):
        if a.startswith('范围移动'):
            name, *args = a.split('，')
            return 'R.move(o,' + ','.join([str(name.endswith('慢')).lower(), *args]) + ')'
        if a.startswith('跟随自机'):
            return 'R.follow(o,' + lua(a[4:]) + ')'
        if a == '额外发射':
            return 'R.fire(o)'
        if a == 'Recover' and kind != 'center':
            return 'R.recover(o)'
        if a in ('BossHide', 'BossUnhide'):
            return 'R.hide(o,' + str(a == 'BossHide').lower() + ')'
        m = re.fullmatch(r'(State|Select)\(([^)]+)\)', a)
        if m:
            return 'R.' + m[1].lower() + '(o,' + ','.join(m[2].split('，')) + ')'
        m = re.fullmatch(r'(.+?)(变化到|增加|减少)(.+?)，([^，]+)，(\d+)帧(?:\((\d+)\))?', a)
        if m:
            prop, op, value, mode, duration, _ = m.groups()
            assert prop in EVENT_FIELDS, (a, kind)
            value, _, spread = value.partition('+')
            field = EVENT_FIELDS[prop]
            return 'R.change(o,' + ','.join([lua(field), lua(atom(value)), spread or '0',
                                            str({'变化到': 0, '增加': 1, '减少': 2}[op]), lua(mode), duration]) + ')'
        m = re.fullmatch(r'(\w+)(?:\((.*)\))?', a)
        assert m, (kind, a)
        name, args = m.groups()
        if name == 'PlaySound':
            return 'R.sound(' + lua(args) + ')'
        if kind == 'center' and name in ('Petrify', 'Lockdown', 'Control'):
            values = [atom(x) for x in args.split('，')]
            return 'R.' + name.lower() + '(o,' + ','.join(map(lua, values)) + ')'
        if name in ('Petrify', 'Lockdown', 'Control', 'GettingOld'):
            self.proxies['mechanic:' + name] += 1
        else:
            self.proxies['presentation:' + name] += 1
        return None

    def events(self, groups, kind):
        code = []
        for group in filter(None, groups.split('&')):
            if kind == 'rebound':
                action = self.action(group + '，正比，1帧', kind)
                if action:
                    code.append(action)
                continue
            _, period, add, events = group.split('|', 3)
            for event in filter(None, events.split(';')):
                cond, action = event.split('：', 1) if '：' in event else ('', event)
                action = action.strip()
                body = self.action(action, kind)
                self.counts['events'] += 1
                if not body:
                    continue
                checks = []
                for term in re.split('(且|或)', cond):
                    if not term:
                        continue
                    if term in ('且', '或'):
                        checks.append('and' if term == '且' else 'or')
                        continue
                    m = re.fullmatch(r'(.+?)([=<>])([-+.\d]+)', term)
                    assert m, (term, event)
                    prop, op, value = m.groups()
                    if prop.startswith('状态') and prop[2:].isdigit():
                        assert kind == 'center', (kind, event)
                        checks.append(f'o.status=={prop[2:]}')
                        checks.append('and')
                        lhs = '(o.statusFrame or 0)'
                    else:
                        lhs = 't' if prop == '当前帧' else '(o.' + EVENT_FIELDS[prop] + ' or 0)'
                    shift = f'+math.floor(t/{max(1, int(period))})*{int(add)}' if int(add) and prop in ('当前帧', '状态帧') else ''
                    checks.append(f'{lhs}{"==" if op == "=" else op}({value}{shift})')
                limit = re.search(r'帧\((\d+)\)$', action)
                if limit:
                    if checks:
                        checks.append('and')
                    checks.append(f'R.once(o,{self.counts["events"]},{limit[1]})')
                code.append('if ' + ' '.join(checks) + ' then ' + body + ' end' if checks else body)
        return 'function(o,t,R)\n' + '\n'.join(code) + '\nend'

    def record(self, raw, kind, fields, rands, extra):
        values = raw.split(',')
        rec = {k: atom(v) for k, v in zip(fields, values)
               if k not in ('unused', 'Parentevents', 'Sonevents') and v}
        start = len(fields)
        rec['rand'] = {k: atom(v) for k, v in zip(rands, values[start:]) if v}
        for k, v in zip(extra, values[start + len(rands):]):
            if v:
                if kind == 'batch' and k in ('wscale', 'hscale'):
                    rec['rand'][k] = atom(v)
                else:
                    rec[k] = atom(v)
        rec['kind'] = kind
        if kind in ('batch', 'laser'):
            rec['type'] += 1
        out = lua(rec)[:-1]
        for k in ('Parentevents', 'Sonevents'):
            if k in fields:
                i = fields.index(k)
                out += ',' + k + '=' + self.events(values[i], kind if k == 'Parentevents' else kind + '-son')
        return out + '}'

    def pattern(self, key):
        if key in self.patterns:
            return
        lines = iter(self.text('b' + key).splitlines())
        assert next(lines) == 'Crazy Storm Data 1.01', key
        line = next(lines)
        order = 0
        textures, profiles, global_events = [], [], []
        while not line.startswith('Center:'):
            if line.startswith('RenderingOrder:'):
                order = int(line[-1])
                line = next(lines)
                continue
            if line == 'External:':
                line = next(lines)
                while not line.endswith('Types:'):
                    tex = self.texture(Path(line).stem, Path('Data') / line)
                    textures.append(tex)
                    line = next(lines)
            count, kind = line.split()
            block = [next(lines) for _ in range(int(count))]
            if kind == 'Types:':
                for raw in block:
                    values = [atom(v) for v in raw.split('_')[1:]]
                    index = values.pop(0) if len(values) >= 11 else 0
                    values += [0] * (15 - len(values))
                    values.append(textures[index] if 0 <= index < len(textures) else '')
                    profiles.append(values)
            elif kind == 'GlobalEvents:':
                global_events = [[atom(x) for x in row.split('_')] for row in block]
            else:
                assert kind == 'Sounds:', (key, line)
            line = next(lines)
        center = line[7:].split(',')
        available = center[0] != 'False'
        positions = [atom(x) for x in center[:6]] if available else [481, 360, 0, 0, 0, 0]
        raw_center_events = center[6:] if available else center[1:]
        total = int(next(lines).split(':')[1].split(',')[0])
        rows = []
        for _ in range(4):
            layer = next(lines).split(':', 1)[1].split(',')
            if layer[0] == 'empty':
                continue
            layer_rows = []
            for n, (kind, fields, rands, extra) in zip(layer[3:], FIELDS):
                for _ in range(int(n)):
                    try:
                        layer_rows.append((kind, self.record(next(lines), kind, fields, rands, extra)))
                    except Exception as exc:
                        raise ValueError((key, kind, exc)) from exc
                    self.counts[kind] += 1
            order_by_kind = {name: i for i, name in enumerate(('force', 'rebound', 'cover', 'laser', 'batch'))}
            rows.extend(row for _, row in sorted(layer_rows, key=lambda item: order_by_kind[item[0]]))
        assert not any(line.strip() for line in lines), key
        glob = []
        for idx, ge in enumerate(global_events, 1):
            start = ge[0]
            if ge[4]:
                glob.append(f'if t=={start} then R.jump(c,{idx},{ge[5]},{ge[6]}) end')
            if ge[10]:
                glob.append(f'if t=={start} then R.quake(c,{ge[11]},{ge[12]}) end')
            if ge[16]:
                glob.append(f'if t>={start} then R.slow(c,{ge[17]},{ge[18]},t,{start}) end')
        # 中心事件参数使用全角逗号。保留 ASCII 逗号给旧版行中使用的动作参数。
        center_code = self.events('中心|1|0|' + ','.join(raw_center_events), 'center')
        head = lua(dict(id=key, total=total, order=order, centerAvailable=available, center=positions, types=profiles))[:-1]
        code = 'return ' + head + ',centerEvents=' + center_code + ',globalEvents=function(c,t,R)\n'
        code += '\n'.join(glob) + '\nend,emitters={\n' + ',\n'.join(rows) + '\n}}\n'
        (OUT / 'patterns' / (key + '.lua')).write_text(code)
        self.patterns.add(key)

    def new_id(self):
        self.next_id += 1
        return self.next_id - 1

    def chapter(self, stage, key, name, difficulty, titles):
        raw = self.text(key)
        source = list(commands(raw, '灵'))
        other = list(commands(raw, '魔'))
        # 唯一的机体分支是护送演出与五面队友。主卡链共用同一时间轴。
        assert [x for x in source if split_command(x[1])[0] not in ('StartProtect', 'EndProtect', 'BindTeammate')] == [
            x for x in other if split_command(x[1])[0] not in ('StartProtect', 'EndProtect', 'BindTeammate')], key
        timeline = defaultdict(list)
        for t, command in source:
            timeline[t].append(split_command(command))
        driver, groups, roads = defaultdict(list), [], []
        group = card = host = None
        road_start, end = 0, 0
        for t in sorted(timeline):
            for cmd, a in timeline[t]:
                if cmd == 'SetBossStage':
                    if t > road_start and difficulty != 9:
                        roads.append(dict(id=self.new_id(), first=road_start, last=t))
                    road_start = t
                    group = dict(time=t, cards=[], hosts=[], index=len(groups) + 1, role='mid' if a[1] == '-1' or a[1] == '0' else 'boss')
                    groups.append(group)
                    card = host = None
                elif cmd == 'SetBossCard':
                    kind, number, seconds, hp = map(int, a[:4])
                    flag = a[4] if len(a) > 4 else ''
                    titlekey = ('' if kind else 'f') + f'{stage}{number}'
                    card = dict(id=self.new_id(), number=number, kind=kind, title=titles.get(titlekey, f'通常弹幕 {number}' if not kind else f'符卡 {number}'),
                                seconds=seconds, hp=hp, immune=int(flag) if flag.isdigit() else 0,
                                flags=[flag] if flag and not flag.isdigit() else [], familiars={}, tracks={})
                    group['cards'].append(card)
                elif cmd == 'SetBoss':
                    actor = int(a[0])
                    host = dict(actor=actor, entry=int(a[1]), leave=int(a[2]), x=float(a[4]) if len(a) > 4 else 336, y=float(a[5]) if len(a) > 5 else 255)
                    group['hosts'].append(host)
                elif cmd == 'AddBossBarrage':
                    p = f'{stage}{a[1]}'
                    self.pattern(p)
                    phase = next((c for c in group['cards'] if c['number'] == int(a[0])), None)
                    if phase is None:
                        self.proxies['unused:AddBossBarrage'] += 1
                        continue
                    track = dict(pattern=p, time=int(a[2]) if len(a) > 2 else 0, hp=int(a[3]) if len(a) > 3 else 0, familiar=int(a[4]) if len(a) > 4 else 0)
                    phase['tracks'].setdefault(str(len(group['hosts'])), []).append(track)
                elif cmd == 'SetBossCardLabel':
                    card['flags'].append(a[0])
                elif cmd == 'SetBossCardLSCCondition':
                    card['condition'] = int(a[0])
                elif cmd == 'SetBossCardBossOrder':
                    card['order'] = int(a[0])
                elif cmd == 'BindFamiliar' and card and t == group['time']:
                    card['familiars'][str(max(1, min(4, int(a[0]))))] = [atom(x) for x in a[1:]]
                elif cmd == 'StageEnd':
                    if a[0] != 'exed':
                        end = max(end, t)
                elif cmd == 'Goto':
                    driver[t].append('R.stage_Goto(s,' + str(tick(a[0])) + ')')
                elif cmd == 'SkipAtNoLSCVersion':
                    pass
                elif cmd in ROAD:
                    if cmd == 'SetEnemy' and a[7] != '-1':
                        self.pattern(f'{stage}{a[7]}')
                    driver[t].append('R.stage_' + cmd + '(' + ','.join(['s', *map(lua, a)]) + ')')
                elif cmd == 'BindTeammate':
                    self.proxies['mechanic:' + cmd] += 1
                elif cmd in PRESENTATION:
                    self.proxies['stage:' + cmd] += 1
                else:
                    raise ValueError((key, t, cmd, a))
        if not end:
            end = groups[-1]['time'] + 1
        if end > road_start and difficulty != 9 and any(road_start <= t < end and any('SetEnemy' in line for line in lines) for t, lines in driver.items()):
            roads.append(dict(id=self.new_id(), first=road_start, last=end))
        for g in groups:
            assert g['hosts'] and all(c['tracks'] for c in g['cards']), (key, g)
        (OUT / ('stage_' + key + '.lua')).write_text('return {\n' + '\n'.join(
            '[' + str(t) + ']=function(R,s)\n' + '\n'.join(lines) + '\nend,' for t, lines in driver.items()) + '\n}\n')
        self.counts['stage_commands'] += sum(map(len, driver.values()))
        self.counts['roads'] += len(roads)
        self.counts['cards'] += sum(len(g['cards']) for g in groups)
        return dict(name=name, stage=stage, difficulty=difficulty, script=key, length=end, bosses=groups, roads=roads)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, required=True)
    parser.add_argument('--content', type=Path, required=True)
    args = parser.parse_args()
    ex = Export(args.source.resolve(), args.content.resolve())
    (OUT / 'patterns').mkdir(parents=True, exist_ok=True)
    ART.mkdir(parents=True, exist_ok=True)
    chapters = []
    for stage, difficulty in [(n, 4) for n in range(1, 7)] + [(7, 5), (8, 6)] + [(n, 9) for n in range(1, 7)]:
        key = f'{stage}lw' if difficulty == 9 else f'{stage}0{difficulty}'
        name = 'Last Word' if difficulty == 9 else 'EX' if stage == 7 else 'PH' if stage == 8 else str(stage)
        names = dict(line.split(' ', 1) for line in ex.text('s' + str(difficulty)).splitlines() if ' ' in line)
        chapters.append(ex.chapter(stage, key, name, difficulty, names))
    common = [[atom(x) for x in line.split('_')[1:]] for line in ex.text('3').splitlines() if line]
    enemies = [[atom(x) for x in line.split(',')] for line in ex.text('0').splitlines() if line]
    for name in sorted({p[0] for p in enemies}):
        ex.texture(name, Path('Graphics/List') / (name + '.xna'))
    ex.texture('barrages', Path('Graphics/Pattern/barrages.xna'))
    ex.texture('bosses', Path('Graphics/List/bosses.xna'))
    profiles = []
    lines = iter(ex.text('1').splitlines())
    for row in lines:
        base = [atom(x) for x in row.split(',')]
        animations = dict((a[0], [atom(x) for x in a[1:]]) for a in (next(lines).split(',') for _ in range(base[0])))
        profiles.append(dict(size=base[1:3], scale=base[3], animations=animations))
    (OUT / 'catalogue.lua').write_text('return ' + lua(dict(chapters=chapters, bulletTypes=common, enemyTypes=enemies,
        actors=ACTORS, bossTypes=profiles, textureHeights=ex.textures)) + '\n')
    for name in ('Game', 'StageManager', 'CrazyStorm', 'Batch', 'Barrage', 'Lase', 'Enemy', 'EnemyEvent', 'Boss', 'BossCard', 'BossStage', 'CSManager', 'Center', 'CExecution', 'Familiar', 'Time'):
        p = ex.source / 'src/THMHJ/THMHJ' / (name + '.cs')
        ex.hashes[str(p.relative_to(ex.source))] = hashlib.sha256(p.read_bytes()).hexdigest()
    ex.counts['patterns'] = len(ex.patterns)
    ex.counts['textures'] = len(ex.textures)
    manifest = dict(source=str(ex.source), content=str(ex.content), statistics=dict(ex.counts),
                    proxies=dict(sorted(ex.proxies.items())), sha256=dict(sorted(ex.hashes.items())))
    (OUT / 'sources.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    print(ex.counts)


if __name__ == '__main__':
    main()
