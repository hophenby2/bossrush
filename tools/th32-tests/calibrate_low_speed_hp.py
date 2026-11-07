"""读取TH06满火力射击表，生成四种低速机体活跃TTK中位数的血量换算数据。

只做源数据计算与导出，不启动游戏或运行测试。模型沿用TH31/34/35血量文档：
持续全命中、无Bomb；保护窗口独立于HP，不计弹道飞行、脱靶与移动时间。
"""
import argparse
import hashlib
import json
import math
from pathlib import Path
import re
import statistics
import sys

sys.dont_write_bytecode = True
from source import Source, catalogue

ROOT = Path(__file__).resolve().parents[2]
TARGET_DPS = 115.5
CYCLE = 1980  # 同时覆盖30帧射击计时器与330帧激光周期。


def shot_rows(text, name):
    block = re.search(r'g_CharacterPowerBulletData' + name + r'Rank9\[\]\s*=\s*\{(.*?)\n\};', text, re.S)[1]
    rows = []
    for body in re.findall(r'\{([^{}]+)\}', block):
        fields = [s.strip() for s in body.split(',')]
        rows.append(dict(interval=int(fields[0]), phase=int(fields[1]), damage=int(fields[8]),
                         kind=fields[10], animation=fields[11]))
    return rows


def anm_scripts(text):
    scripts, index = {}, -1
    for block in re.finditer(r'script\s+(?:(\d+)\s+)?\w+\s*\{(.*?)\n\}', text, re.S):
        index = int(block[1]) if block[1] else index + 1
        time, rows = 0, []
        for line in block[2].splitlines():
            delta = re.match(r'\+(\d+):', line.strip())
            if delta:
                time += int(delta[1])
            ins = re.search(r'ins_(\d+)\((.*?)\);', line)
            if ins:
                rows.append((time, int(ins[1]), ins[2]))
        scripts[index] = rows
    return scripts


def damage_cycle(rows, explosion_lifetime, laser_fade):
    hits = [0] * (CYCLE * 2)
    for row in rows:
        interval, phase, damage = (row[k] for k in ('interval', 'phase', 'damage'))
        if row['kind'] == 'PLAYER_LASER':
            # bulletFrame是独立laserTimer的编号；两个光束均在计时器空闲时发射。
            active = interval - 70 + laser_fade
            for t in range(len(hits)):
                if t % interval < active:
                    hits[t] += damage
            continue
        for t in range(len(hits)):
            # Player::UpdateFireBulletsTimer到30归零；interval16不能视作无限16帧周期。
            if (t % 30) % interval != phase:
                continue
            hits[t] += damage
            if row['kind'] == 'PLAYER_BULLET_TYPE_2':
                d = damage
                for age in range(1, explosion_lifetime):
                    d = max(1, d // 4)
                    if t + age < len(hits):
                        hits[t + age] += d
    normal = [min(70, d) for d in hits[CYCLE:]]
    spell = [max(1, d // 7) if d else 0 for d in normal]
    return {mode: sum(values) * 60 / CYCLE
            for mode, values in (('normal', normal), ('spell', spell))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, default=Path('E:/workspace/th06/src'))
    parser.add_argument('--ecl', type=Path, default=Path('E:/workspace/原作/ECL/th06'))
    parser.add_argument('--player-anm', type=Path, required=True)
    args = parser.parse_args()
    scripts = anm_scripts(args.player_anm.read_text('utf-8'))
    # 满火力魔理沙A的ANM68命中后+32；魔理沙B使用ANM71。
    explosion_lifetime = next(t for t, op, _ in scripts[100] if op in (0, 15))
    laser_fade = next(int(a.split(',')[1]) for _, op, a in scripts[71] if op == 12 and a.split(',')[0].strip() == '0')
    bullet_data = (args.source / 'BulletData.cpp').read_text('utf-8')
    samples = []
    for name in ('ReimuA', 'ReimuB', 'MarisaA', 'MarisaB'):
        rows = shot_rows(bullet_data, name)
        samples.append(dict(name=name, focus=True, power=128, rows=rows,
                            **damage_cycle(rows, explosion_lifetime, laser_fade)))
    scale = {mode: TARGET_DPS * statistics.median(1 / m[mode] for m in samples)
             for mode in ('normal', 'spell')}
    source = Source(args.ecl)
    cards = []
    for c in catalogue(source):
        spell = bool(c['name'])
        survival = c['invul'] == c['timeout']
        hp = c['hp'] if survival else max(1, math.floor(c['hp'] * scale['spell' if spell else 'normal'] + .5))
        cards.append(dict(id=c['id'], stage=c['stage'], sub=c['sub'], name=c['label'] or c['name'],
                          raw=c['hp'], entry=c['life'], threshold=c['threshold'], hp=hp,
                          spell=spell, survival=survival, immune=c['invul'], timeout=c['timeout'],
                          active_ttk_median=None if survival else statistics.median(c['hp'] / m['spell' if spell else 'normal'] for m in samples)))
    hashes = {name: hashlib.sha256((args.source / name).read_bytes()).hexdigest()
              for name in ('BulletData.cpp', 'Player.cpp', 'EnemyManager.cpp', 'AnmManager.cpp')}
    hashes[args.player_anm.name] = hashlib.sha256(args.player_anm.read_bytes()).hexdigest()
    evidence = dict(target_dps=TARGET_DPS, sample_frames=CYCLE, source_sha256=hashes,
                    ecl_sha256=source.hashes, explosion_lifetime=explosion_lifetime,
                    laser_fade=laser_fade, samples=samples, scale=scale, cards=cards)
    report = ROOT / 'tools/th32-tests/low_speed_hp_calibration.json'
    report.write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n', 'utf-8', newline='\n')
    lines = ['-- tools/th32-tests/calibrate_low_speed_hp.py生成；仅取四种原作低速、满火力机体。',
             '-- 活跃TTK中位数折算到115.5 DPS；保护窗口与原生ECL的life单位保持独立。',
             'local H={scale={normal=%.17g,spell=%.17g},entries={}}' % (scale['normal'], scale['spell'])]
    for c in cards:
        lines.append('H.entries[%d]={raw=%d,hp=%d,spell=%s,survival=%s}' %
                     (c['id'], c['raw'], c['hp'], str(c['spell']).lower(), str(c['survival']).lower()))
    lines.append('return H')
    (ROOT / 'mod/GAME/original/th06_low_speed_hp.lua').write_text('\n'.join(lines) + '\n', 'utf-8', newline='\n')
    doc = ROOT / 'mod/GAME/th31_th34_th35_original_player_ttk_hp_calibration.md'
    text = doc.read_text('utf-8')
    text = text.replace('# TH31 / TH33 / TH34 / TH35', '# TH31 / TH32 / TH33 / TH34 / TH35', 1)
    section = ['<!-- TH32低速血量标定开始 -->', '## TH32（原作 TH06 东方红魔乡）', '',
               '仅取灵梦A/B、魔理沙A/B四种低速、满火力机体，各占一个样本；TH06高低速共用同一发弹回调。',
               '沿用本文的持续全命中模型，不计飞行、脱靶、移动和Bomb。它是血量标定，不是实机击破时间测量。', '',
               '射击表取`th06/src/BulletData.cpp`的Rank9；30帧射击计时器按`Player.cpp`重置。',
               '魔理沙A爆裂弹按ANM100保留20帧、每次命中后伤害整除4；魔理沙B光束按ANM71保留30帧收束，330帧中可伤害290帧。',
               '预热1980帧后统计完整1980帧；每帧先合计并封顶70，再对符卡整数除7（正伤害最低1）。', '',
               '| 原作低速机体 | 非符/道中 DPS | 符卡 DPS |', '|---|---:|---:|']
    for m in samples:
        section.append('| %s | %.6f | %.6f |' % (m['name'], m['normal'], m['spell']))
    section += ['', '对原作有效血量`R`，换算为`round(115.5 × median(R / DPS_i))`。',
                '非符/普通道中比例为`%.12f`；符卡期间比例为`%.12f`。取的是击破时间中位数，没有对DPS取平均。' % (scale['normal'], scale['spell']),
                'Boss以进场life扣除收尾阈值后换算并取整数；实际道中敌机/子发弹对象按出生或脚本写入的life换算（最低1）。',
                '隐形道中载体、999999占位血量和全程耐久不换算；ECL读取life、血量阈值和依赖血量的攻击仍用原作单位。',
                '无敌时间、是否受击、收尾阈值与发弹时序不折进HP。符卡全局状态切换时，存活子机保留原作剩余life再切换换算比例。', '',
                '生成器：`tools/th32-tests/calibrate_low_speed_hp.py`；逐样本射击行、源文件/ECL的SHA-256及每阶段中位数见`tools/th32-tests/low_speed_hp_calibration.json`。',
                '按用户要求，本次未运行测试或游戏。', '',
                '| ID | 原作入口 | 名称 | 有效原始HP | 换算HP | 活跃TTK中位数/秒 |', '|---:|---|---|---:|---:|---:|']
    for c in cards:
        section.append('| `%d` | ecldata%d/Sub%d | %s | %d | %d | %s |' %
                       (c['id'], c['stage'], c['sub'], c['name'], c['raw'], c['hp'],
                        '耐久，未换算' if c['survival'] else '%.6f' % c['active_ttk_median']))
    section.append('<!-- TH32低速血量标定结束 -->')
    block = '\n'.join(section)
    if '<!-- TH32低速血量标定开始 -->' in text:
        text = re.sub(r'<!-- TH32低速血量标定开始 -->.*?<!-- TH32低速血量标定结束 -->', lambda _: block, text, flags=re.S)
    else:
        text = text.rstrip() + '\n\n' + block + '\n'
    doc.write_text(text, 'utf-8', newline='\n')
    print(json.dumps(dict(samples=[{k: m[k] for k in ('name', 'normal', 'spell')} for m in samples], scale=scale, cards=len(cards)), ensure_ascii=False))


if __name__ == '__main__':
    main()
