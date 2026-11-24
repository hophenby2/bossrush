#!/usr/bin/env python3
"""用原生武器全命中采样，按各原作可选机体的活跃TTK中位数生成随机模式伤害单位。

满火力、低速、持续射击（蓄力机体正常释放）、默认装备/初始形态、无Bomb/Hyper；免疫和卡片减伤仍由原后端执行。
这与旧作HP标定使用同一 median(HP / DPS_i) 模型，不是移动Boss的实战击破时间。
先用 macos/build.py --update-assets 更新应用，再 --sample；也可 --input 重新生成。
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import statistics
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]
SOURCES = {
    35: ('幕华祭春雪', 4, 1), 36: ('雪莲华', 6, 1), 37: ('幕华祭永夜', 8, 1),
    38: ('夏夜祭', 4, 1), 39: ('祈华梦', 3, 1), 40: ('Like Dreamer', 3, 52),
    41: ('栖霞园', 3, 1),
}
HOST_DPS = 115.5


def sample(out, args):
    out.mkdir(parents=True, exist_ok=True)
    bundle = ROOT / 'macos/dist/Boss Rush HD.app/Contents/Resources/game'
    for name in ('macos/lua/rogue_ttk_calibration.lua', 'THlib/native_players.lua'):
        assert (ROOT / name).read_bytes() == (bundle / name.replace('macos/lua/', 'macos/')).read_bytes(), name
    env = dict(os.environ, BOSSRUSH_MAC_DATA=str(out), BOSSRUSH_MAC_TEST='rogue-ttk-calibration')
    for key, value in (('LEVEL', args.level), ('MACHINE', args.machine), ('ENEMY', args.enemy), ('WARMUP', args.warmup)):
        if value is not None: env['BOSSRUSH_TTK_'+key] = str(value)
    sampler_hash = hashlib.sha256((ROOT/'macos/lua/rogue_ttk_calibration.lua').read_bytes()).hexdigest()
    binary = ROOT / 'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
    trace = out / 'run.log'
    with trace.open('w') as log:
        proc = subprocess.Popen([str(binary)], cwd=out, env=env, stdout=log, stderr=subprocess.STDOUT)
        deadline = time.monotonic() + 900
        error = None
        while proc.poll() is None and time.monotonic() < deadline:
            if 'BOSSRUSH_ERROR:' in trace.read_text(errors='replace'):
                error = '原生采样报错，见 ' + str(trace)
                proc.terminate()
                break
            time.sleep(.5)
        if proc.poll() is None:
            if not error:
                error = '原生采样超时，见 ' + str(trace)
                proc.terminate()
            proc.wait(timeout=10)
    report = out / 'bossrush/User/ttk-calibration.json'
    if error or proc.returncode != 0 or not report.exists():
        raise RuntimeError(error or '原生采样未完成：' + str(proc.returncode))
    raw = json.loads(report.read_text())
    raw['runs'] = [{'sampler_sha256': sampler_hash, 'log': str(trace.relative_to(ROOT))}]
    return raw


def calibrate(raw):
    assert raw['warmup'] >= 600 and raw['window'] >= 3600
    result = {'host_dps': HOST_DPS, 'warmup_frames': raw['warmup'], 'window_frames': raw['window'],
              'model': 'median(active HP / full focused DPS), equal weight per selectable default machine',
              'works': {}, 'source_sha256': {}, 'sampling_runs': raw.get('runs', [])}
    for level, (name, count, backend) in SOURCES.items():
        groups = {}
        for kind in ('boss', 'enemy') if level == 37 else ('boss',):
            rows = [r for r in raw['cases'] if r['level'] == level and bool(r.get('enemy')) == (kind == 'enemy')]
            assert len(rows) == count and len({r['machine'] for r in rows}) == count, (level, kind)
            for row in rows:
                windows = row['windows']
                assert len(windows) == 2 and min(windows) > 0, row
                row['window_relative_delta'] = abs(windows[0]-windows[1])/max(windows)
                assert row['window_relative_delta'] < (.05 if kind == 'enemy' else .03), ('输出未稳定', row)
                row['dps'] = statistics.mean(windows)
            scale = HOST_DPS * statistics.median(1/r['dps'] for r in rows)
            groups[kind] = {'machines': rows, 'hp_scale': scale, 'damage_units': 1/scale/backend}
        result['works'][str(level)] = {'name': name, 'backend_damage_factor': backend, **groups}
    # 只记录本模型真正读取的武器与桥接文件，避免把无关资源当作校准证据。
    paths = [ROOT/'THlib/native_players.lua', ROOT/'THlib/player/reimu/reimu.lua',
             ROOT/'macos/lua/rogue_ttk_calibration.lua']
    for folder in ('mod/GAME/ports/mhj/native_players', 'mod/GAME/th38/native_players',
                   'mod/GAME/th40/native_players', 'mod/GAME/ports/theis/native_players',
                   'mod/GAME/th43/native_players'):
        paths.extend((ROOT/folder).rglob('*.lua'))
    paths += [ROOT/p for p in ('mod/GAME/th40/player.lua', 'mod/GAME/th43/player.lua',
                              'mod/GAME/ports/dreamer/LikeDreamer/player.lua')]
    for path in sorted(set(paths)):
        result['source_sha256'][path.relative_to(ROOT).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest()
    return result


def write(result):
    folder = ROOT/'tools/ports-hp';folder.mkdir(exist_ok=True)
    (folder/'low_speed_hp.json').write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
    lines = ['-- tools/calibrate_ports_hp.py 生成；低速、满火力、包含子机的活跃TTK中位数。',
             '-- 原HP数值域/免疫/卡片减伤不变；Like Dreamer后端的×52只计算一次。',
             'local H={damageUnits={},bossDamageUnits={},scale={}}']
    for level in SOURCES:
        work = result['works'][str(level)]
        boss = work['boss'];ordinary = work.get('enemy', boss)
        lines.append('H.damageUnits[%d]=%.17g' % (level, ordinary['damage_units']))
        if level == 37:
            lines.append('H.bossDamageUnits[37]=%.17g' % boss['damage_units'])
        lines.append('H.scale[%d]=%.17g' % (level, boss['hp_scale']))
    lines.append('return H')
    (ROOT/'mod/rogue_ttk_hp.lua').write_text('\n'.join(lines)+'\n')
    doc = ['# 新作随机模式血量标定', '',
           '由 `tools/calibrate_ports_hp.py` 与显式原生采样入口生成。宿主基准为低速满火力灵梦115.5 DPS。', '',
           '每个原作可选机体的默认装备/初始形态各一票；满普通火力，持续低速射击（蓄力机体按原作满蓄力后的最短松键/松低速周期释放），包含主炮、子机、激光、追踪及命中后的多段窗口，不使用Bomb、Hyper或强化。雪莲华每宿主帧执行两个120Hz tick，红/紫倍率均为3；栖霞园为普通Rank 3。', '',
           '预热600宿主帧后，采样两个3600帧窗口。只替代飞行/空间命中测试，保留原作发射时钟、弹池、命中回调、持续伤害和永夜Boss共用受伤上限。采样不渲染；不是移动Boss的实战击破测试。两窗口保留原始数据；Boss窗口偏差须低于3%，普通敌机窗口偏差须低于5%（本次最大约3.04%），合并两个窗口求每机体DPS。', '',
           '`S = 115.5 × median(1 / DPS_i)`，等效宿主血量为 `原HP × S`。不能先取DPS平均数/中位数再求倒数。随机模式保留原HP和阶段阈值，通过伤害乘`1/S`实现同一换算；阶段强化在此基础上单独应用。原作免疫与卡片自身减伤不折进HP。', '',
           '| 作品 | 完整输出 DPS（各机体） | HP换算系数 S |', '| --- | --- | ---: |']
    for level in SOURCES:
        w = result['works'][str(level)]
        modes = '、'.join(r['machine']+' '+format(r['dps'], '.3f') for r in w['boss']['machines'])
        doc.append('| %s | %s | %.9g |' % (w['name'], modes, w['boss']['hp_scale']))
    snow = result['works']['36']['boss']
    doc += ['', '冰砾「破碎的冰弹」原HP为9000，换算等效宿主HP约%.2f，活跃TTK中位数约%.2f秒；入场/全免时间仍由原卡控制。' %
            (9000*snow['hp_scale'], 9000*snow['hp_scale']/HOST_DPS), '',
            '永夜的普通敌机单独采样，Boss/部件共享伤害上限各自保留；Like Dreamer保留后端既有×52，表中输入系数已除52。原生逐机体窗口、命中统计和源文件SHA256见 `tools/ports-hp/low_speed_hp.json`。', '']
    (ROOT/'mod/rogue_ttk_hp.README.zh-CN.md').write_text('\n'.join(doc))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sample', action='store_true')
    parser.add_argument('--output', type=Path, default=ROOT/'macos/build/ttk-calibration')
    parser.add_argument('--input', type=Path)
    parser.add_argument('--level', type=int)
    parser.add_argument('--machine')
    parser.add_argument('--enemy', choices=('0','1'))
    parser.add_argument('--warmup', type=int)
    parser.add_argument('--collect', type=Path, help='只保存采样原始数据，供分作采样后合并')
    args = parser.parse_args()
    if args.sample:
        raw = sample(args.output.resolve(), args)
        if args.input:
            previous = json.loads(args.input.read_text())
            def key(row): return row['level'], row['machine'], bool(row.get('enemy'))
            replacing = {key(row) for row in raw['cases']}
            raw['cases'] = [r for r in previous['cases'] if key(r) not in replacing] + raw['cases']
            raw['runs'] = previous.get('runs', []) + raw['runs']
    else:
        assert args.input, '需要 --sample 或 --input'
        raw = json.loads(args.input.read_text())
    if args.collect:
        args.collect.write_text(json.dumps(raw, ensure_ascii=False, indent=2)+'\n')
        print('已采集/合并 %d 个机体/目标组合' % len(raw['cases']))
        return
    result = calibrate(raw);write(result)
    print(json.dumps({k: v['boss']['damage_units'] for k, v in result['works'].items()}, ensure_ascii=False))


if __name__ == '__main__':
    main()
