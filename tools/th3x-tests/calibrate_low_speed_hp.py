"""读取原作 SHT，按低速、满火力、持续全命中模型换算活跃 TTK 中位数。

这是血量标定模型，不是移动中的 Boss 实测击破时间。命中相位按 SHT 发射帧；
保留每帧70点上限、符卡整数减伤、持续光束与爆裂弹的伤害窗口。
不把全免与九倍防御时间折进 HP。原作 ECL 的有效 HP 取仓库已有审计表。
"""
import argparse
import hashlib
import json
import math
from pathlib import Path
import re
import statistics
import struct

ROOT = Path(__file__).resolve().parents[2]


def descriptors(path, game):
    data = path.read_bytes()
    count = struct.unpack_from('<H', data, 2)[0]
    header = {7: 0x34, 8: 0x38, 10: 0x110}[game]
    levels = [struct.unpack_from('<II', data, header + i * 8) for i in range(count)]
    offset = (levels[9] if game == 10 else next(x for x in levels if x[1] > 128))[0]
    size = 0x38 if game == 8 else 0x34
    result = []
    while struct.unpack_from('<b' if game == 10 else '<h', data, offset)[0] >= 0:
        interval, phase = struct.unpack_from('<bb' if game == 10 else '<hh', data, offset)
        damage = struct.unpack_from('<h', data, offset + (2 if game == 10 else 0x1c))[0]
        kind = struct.unpack_from('<h' if game == 8 else '<B', data,
                                  offset + {7: 0x1f, 8: 0x22, 10: 0x1d}[game])[0]
        result.append(dict(interval=interval, phase=phase, damage=damage, kind=kind))
        offset += size
    return result


def damage_cycle(rows, game, spell):
    # 600 帧包含所有发射周期；预热600帧，避免截断爆裂弹和持续光束。
    hits = [0] * 1200
    for row in rows:
        interval, phase, damage, kind = (row[k] for k in ('interval', 'phase', 'damage', 'kind'))
        if game in (7, 8) and kind in (4, 5):
            for t in range(1200):
                hits[t] += (damage if t % 2 == 0 else 0) + (interval if kind == 5 else 0)
        elif game == 10 and kind == 3:
            for t in range(0, 1200, 4):
                hits[t] += damage
        else:
            for t in range(phase, 1200, interval):
                hits[t] += damage
                if game in (7, 8) and kind == 3:
                    # player01: TH07主射击ANM104在45帧结束，TH08 ANM21在20帧结束。
                    end, gap, d = (45 if game == 7 else 20), (4 if game == 8 and spell else 2), damage
                    for age in range(gap, end, gap):
                        d = max(1, d // 3)
                        if t + age < 1200:
                            hits[t + age] += d
                elif game == 10 and kind == 2:
                    # SpawnEffectRow 在命中帧即加入 damage；计时13递减到1，整除帧跳过。
                    for age in range(13):
                        if (13-age) % 4 and t + age < 1200:
                            hits[t + age] += damage // 3
    hits = hits[600:]
    if game in (7, 8):
        hits = [min(70, x) for x in hits]
    if spell:
        divisor = 5 if game == 10 else 7
        hits = [max(1, x // divisor) if x else 0 for x in hits]
    return sum(hits) / 10


def ecl_rows():
    text = (ROOT / 'mod/GAME/th31_th34_th35_original_player_ttk_hp_calibration.md').read_text('utf-8')
    section, result = None, {7: {}, 8: {}, 10: {}}
    for line in text.splitlines():
        m = re.match(r'## TH(31|34|35)\b', line)
        if m:
            section = {31: 8, 34: 7, 35: 10}[int(m[1])]
        elif line.startswith('## '):
            section = None
        if section and re.match(r'\| `\d+`', line):
            columns = [c.strip() for c in line.split('|')[1:-1]]
            key = int(columns[0].strip('`'))
            raw = columns[3].replace(',', '')
            if not raw.isdigit() or (section == 10 and key == 3607):
                continue
            immune = re.search(r'(\d+)f 全免', columns[5])
            guard = re.search(r'(\d+)f /9', columns[5])
            result[section][key] = dict(raw=int(raw), spell=columns[1] == '符卡',
                                       immune=int(immune[1]) if immune else 0,
                                       guard=int(guard[1]) if guard else 0)
            windows = re.findall(r'(\d+)–(\d+)f (全免|/9)', columns[5])
            if windows:
                result[section][key].update(immune=0, guard=0,
                    windows=[[int(a), int(b)+1, 0 if mode=='全免' else 1/9]
                             for a,b,mode in windows])
    # 原审计表没有列普通 Last Word；来源见 th31_combat.lua 的 M.lastwords。
    combat = (ROOT / 'mod/GAME/th31_combat.lua').read_text('utf-8')
    block = re.search(r'M.lastwords=\{(.*?)\n    \}', combat, re.S)[1]
    for key, hp, immune, guard in re.findall(r'\[(\d+)\]=\{(\d+),(\d+),(\d+)\}', block):
        result[8][int(key)] = dict(raw=int(hp), spell=True, immune=int(immune), guard=int(guard))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sht', type=Path, required=True)
    args = parser.parse_args()
    evidence, scale = {}, {}
    for game in (7, 8, 10):
        directory = args.sht / str(game)
        if game == 7:
            files = sorted(directory.glob('*s.sht'))
        elif game == 10:
            files = sorted(directory.glob('*.sht'))
        else:
            # Player.cpp g_Player2ShtFile：4组队+8单人，各可选机体低速各占一个样本。
            names = ['ply00as', 'ply01as', 'ply02as', 'ply03as', 'ply00a', 'ply00as',
                     'ply01a', 'ply01as', 'ply02a', 'ply02as', 'ply03a', 'ply03as']
            files = [directory / (n + '.sht') for n in names]
        assert len(files) == (12 if game == 8 else 6)
        modes = []
        for path in files:
            rows = descriptors(path, game)
            modes.append(dict(file=path.name, sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                              normal=damage_cycle(rows, game, False), spell=damage_cycle(rows, game, True)))
        scale[game] = {mode: 115.5 * statistics.median(1 / m[mode] for m in modes)
                       for mode in ('normal', 'spell')}
        if game == 8:
            humans = [modes[i] for i in (4, 6, 8, 10)]
            for mode in ('normal', 'spell'):
                scale[game]['familiar_' + mode] = 115.5 * statistics.median(1 / m[mode] for m in humans)
        evidence[game] = dict(modes=modes, scale=scale[game])
    entries = ecl_rows()
    lines = ['-- tools/th3x-tests/calibrate_low_speed_hp.py 生成；低速满火力活跃 TTK 中位数。',
             '-- 无敌/减伤独立于血量；标定模型和限制见同名原作血量审计文档。', 'local H={scale={},entries={},cards={}}']
    for game in (7, 8, 10):
        lines.append('H.scale[%d]={normal=%.17g,spell=%.17g}' % (game, scale[game]['normal'], scale[game]['spell']))
        if game == 8:
            for mode in ('normal', 'spell'):
                lines.append('H.scale[8].familiar_%s=%.17g' % (mode, scale[8]['familiar_' + mode]))
        lines.append('H.entries[%d]={' % game)
        for key, row in sorted(entries[game].items()):
            hp = max(1, math.floor(row['raw'] * scale[game]['spell' if row['spell'] else 'normal'] + .5))
            windows = ',windows={' + ','.join('{%d,%d,%s}' % (a,b,'0' if factor==0 else '1/9')
                        for a,b,factor in row['windows']) + '}' if row.get('windows') else ''
            lines.append('    [%d]={raw=%d,hp=%d,immune=%d,guard=%d,spell=%s%s},' %
                         (key, row['raw'], hp, row['immune'], row['guard'], str(row['spell']).lower(), windows))
        lines.append('}')
    lines.extend(['for game,entries in pairs(H.entries) do',
                  '    H.cards[game]={}', '    for id,row in pairs(entries) do H.cards[game][id]=row.hp end', 'end',
                  'function H.unit(o,game,spell)', '    local scale=H.scale[game]',
                  '    if not scale or not o.hp or o.hp>=999999 or o._original_hp_scale then return end',
                  "    local mode=spell and 'spell' or 'normal'",
                  "    scale=(game==8 and o.th08_attached) and scale['familiar_'..mode] or scale[mode]",
                  '    o._original_raw_hp,o._original_hp_scale=o.hp,scale',
                  '    o.hp=math.max(1,o.hp*scale);o.maxhp=o.hp', 'end',
                  'function H.factor(profile,timer)',
                  '    -- 带前置可受击/减伤段的入口不能压成从零开始的一段全免。',
                  '    if profile.windows then',
                  '        for _,w in ipairs(profile.windows) do',
                  '            if timer>=w[1] and timer<w[2] then return w[3] end',
                  '        end', '        return 1', '    end',
                  '    return timer<profile.immune and 0 or timer<profile.immune+profile.guard and 1/9 or 1',
                  'end', 'return H'])
    (ROOT / 'mod/GAME/original/low_speed_hp.lua').write_text('\n'.join(lines) + '\n', 'utf-8')
    report = ROOT / 'tools/th3x-tests/low_speed_hp_calibration.json'
    report.write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n', 'utf-8')
    print(json.dumps({g: dict(cards=len(entries[g]), scale=scale[g]) for g in entries}))


if __name__ == '__main__':
    main()
