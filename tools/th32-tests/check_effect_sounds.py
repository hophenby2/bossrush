"""对照原生ECL，核对全部可达直接音效指令及正式Lua子程序，不改卡表或素材。"""
import argparse
from pathlib import Path
import re

from source import Source, catalogue, road_catalogue
from expand import reachable, routine


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('data',type=Path)
    args=parser.parse_args()
    source=Source(args.data)
    code=Path('mod/GAME/th32.lua').read_text(encoding='utf-8-sig')
    count=programs=0
    for stage,subs in reachable(source,catalogue(source),road_catalogue(source)).items():
        assert f'ecldata{stage}.ecl SHA-256：{source.hashes[stage]}' in code,'原始ECL哈希与产物不符'
        for sub in sorted(subs):
            expected=routine(source,stage,sub)
            start=code.index(expected.split('\n',1)[0])
            footer=f'    P[{stage}][{sub}]=B.part1\nend'
            end=code.index(footer,start)+len(footer)
            actual=code[start:end]
            assert actual==expected,('正式子程序未同步导出器',stage,sub)
            ids=[row['a'][0] for row in source.active(stage,sub) if row['op']==106]
            emitted=list(map(int,re.findall(r'H\.play_sound\(b,(\d+)\)',actual)))
            assert emitted==ids,('直接音效指令遗漏或编号变化',stage,sub,ids,emitted)
            assert all(0<=id<32 for id in ids)
            count+=len(ids);programs+=1
    assert count==261,'原始音效指令范围变化，需要重新核对来源'
    print(f'通过：{programs} 个原始子程序、{count} 处106号音效指令及SoundIdx编号一致')


if __name__=='__main__':main()
