"""反向核对原作符卡入口，避免只遍历已有移植条目而看不见整段遗漏。"""
import argparse
from collections import Counter
import json
from pathlib import Path
import sys

from ecl_source import Source


def build(args):
    cards = json.loads(args.catalogue.read_text('utf-8'))['cards']
    spells, parsed = {}, Counter()
    # 静态掩码不能代替运行期难度分支；结果只证明存在对应子程序，不证明走到同一张卡。
    for game in (6, 7, 8, 10):
        for declaration in sorted((args.cache / 'ecl' / str(game)).glob('*.decl')):
            binary = args.binaries / f'th{game:02}' / (declaration.stem + '.ecl')
            source = Source(declaration, binary, game)
            parsed[game] += sum(map(len, source.subs.values()))
            for sub, rows in source.subs.items():
                for ins in rows:
                    if not ins.mask & 8:
                        continue
                    if game in (6, 7, 8):
                        if ins.op != {6:93, 7:90, 8:122}[game]:
                            continue
                        spell, name = ins.args[1], ins.args[3 if game == 8 else 2]
                    else:
                        if ins.op not in (342, 348, 357, 358, 359):
                            continue
                        spell = ins.args[0] + {342:0, 348:0, 357:3, 358:2, 359:1}[ins.op]
                        name = ins.args[3]
                    entry = spells.setdefault((game, spell), dict(game=game, spell=spell,
                        name=name.strip('"') if game != 7 else None, locations=[], mapped_cards=set()))
                    matching = [c['id'] for c in cards if c['source'].get('game') == game
                        and c['source'].get('file') == binary.name and sub in c['source'].get('closure', [])]
                    entry['mapped_cards'].update(matching)
                    entry['locations'].append(dict(file=binary.name, sha256=source.sha256,
                        sub=sub, address=hex(ins.address), time=ins.time, mask=ins.mask,
                        op=ins.op, mapped_cards=matching))

    entries = []
    for _, row in sorted(spells.items()):
        row['mapped_cards'] = sorted(row['mapped_cards'])
        row['status'] = '有静态子程序映射，行为仍待核对' if row['mapped_cards'] else '无静态映射，须检查路线可达性'
        entries.append(row)

    # 已人工沿原作阶段链证实的遗漏。保留触发条件，不能把只因低难度未选中的分支算漏卡。
    restored = [
        dict(game=31, file='ecldata3.ecl', roots=['Sub30'], name='产灵「最初的金字塔」',
             evidence=['Sub20:ins_133(0,2100,29) / ins_134(2220,29)',
                       'Sub29:ins_126(30,1)', 'Timeline0:t=3083 ins_8(0,0,1)',
                       'Sub30:0x33a4 ins_122，Lunatic符卡35'],
             card=3426,status='已补入Lua对象实现；使魔运动/发弹与ECL比较见check_keine_sources.py'),
        dict(game=31, file='ecldata3.ecl', roots=['Sub43', 'Sub71'], name='未来「高天原」',
             evidence=['Timeline0:t=4663 !NHL生成Sub43',
                       'Sub43:ins_50([10098],2,0,Sub43_40)；未达刻符阈值则终止',
                       'Sub43:t=132 ins_52(71)', 'Sub71:0x9da4 ins_122，Lunatic符卡53'],
             card=3427,status='已补入Lua对象实现；Boss Rush不设刻符门槛，保留为独立战斗/练习条目'),
    ]
    gaps = [
        dict(game=34, file='ecldata4.ecl', roots=['Sub45'], name='三姐妹第二段非符',
             evidence=['共享控制器Sub45，血量19000，下一阶段阈值2450',
                       '现有4440/4442/4444均为Sub44的不同机体主奏路线'],
             cards=[5480,5481,5482], status='主奏攻击已补入并核对；原作机体选路、另两人离场及跨阶段位置继承仍待对齐'),
        dict(game=34, file='ecldata4.ecl', roots=['Sub47'], name='三姐妹第三段非符',
             evidence=['共享控制器Sub47，血量20000，下一阶段阈值2100',
                       '现有4440/4442/4444均为Sub44的不同机体主奏路线'],
             cards=[5483,5484,5485], status='主奏攻击已补入并核对；上一阶段伤害选路、另两人离场及跨阶段位置继承仍待对齐'),
    ]
    for spell,card in ((35,3426),(53,3427)):
        assert card in spells[8, spell]['mapped_cards'], ('已补阶段丢失原作映射', spell,card)
    result = dict(
        scope='反向扫描各作Lunatic静态掩码内的符卡指令；同子程序的运行期分支可能仍含其他难度。',
        full_original_frame_equivalence=False,
        limits=['有映射只证明源码定位，不能证明逐帧行为正确。',
                '非符和道中没有符卡指令，需要另沿时间轴、生命回调、计时回调逐段检查。',
                'TH07源文件为汉化版，本文不把其GBK说明按日文名称解码。',
                'TH095按每场独立ECL文件核对，见entry-audit，不在本表的符卡编号集合中。'],
        instruction_headers_checked=dict(parsed), spells=entries, confirmed_gaps=gaps,restored_phases=restored)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', 'utf-8')
    print('反向扫描：', dict(parsed), '条指令；仍含未完成阶段逻辑', len(gaps))
    for game in (6, 7, 8, 10):
        group = [r for r in entries if r['game'] == game]
        print(f'TH{game:02}：{len(group)}个符卡编号，{sum(not r["mapped_cards"] for r in group)}个无静态映射（不能直接视为缺失）')


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--cache', type=Path, default=Path('E:/workspace/.bossrush-validation/original-anm'))
    parser.add_argument('--binaries', type=Path, default=Path('E:/workspace/原作/ECL'))
    parser.add_argument('--catalogue', type=Path, default=Path('tools/th3x-tests/card-audit-index.json'))
    parser.add_argument('--output', type=Path, default=Path('tools/th3x-tests/reverse-coverage-2026-11-02.json'))
    build(parser.parse_args())
