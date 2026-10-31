"""从原版thecl反汇编导出85幕的计时、快门数和二进制指纹；不从移植常量反推。"""
from pathlib import Path
import argparse
import hashlib
import re

ROOT=Path(__file__).resolve().parents[2]

def export(declarations,binaries):
    script=(ROOT/'mod/GAME/th33.lua').read_text(encoding='utf-8-sig')
    blocks=list(re.finditer(r'^do\s*--[^\n]*\becl(\d+_[a-d])\b',script,re.M))
    mapping={4480:'ecl16_a'}
    for i,m in enumerate(blocks):
        block=script[m.start():blocks[i+1].start() if i+1<len(blocks) else len(script)]
        ids=re.findall(r'local CARD_ID\s*=\s*(\d+)',block)
        assert len(ids)==1,(m[1],ids)
        mapping[int(ids[0])]='ecl'+m[1]
    assert len(mapping)==85
    lines=['-- 原版TH095二进制ECL元数据，由tools/th3x-tests/export_th095_sources.py生成。',
           '-- timeout_at从本体主程序开始计帧；PhotoGameTask的ZunTimer随游戏速度推进。',
           'return {']
    for card_id,name in sorted(mapping.items()):
        decl=(declarations/(name+'.decl')).read_text(encoding='utf-8',errors='replace')
        frame=0;timer=None;photos=None
        for line in decl.splitlines():
            if line.startswith('sub '): frame=0
            timestamp=re.match(r'\+\d+:\s*//\s*(\d+)',line)
            if timestamp: frame=int(timestamp[1])
            value=re.search(r'ins_114\((\d+)\)',line)
            if value:
                assert timer is None,name
                timer=(frame,int(value[1]))
            value=re.search(r'ins_141\((\d+)\)',line)
            if value: photos=int(value[1])
        assert timer and photos,(name,timer,photos)
        digest=hashlib.sha256((binaries/(name+'.ecl')).read_bytes()).hexdigest()
        lines.append(f"    [{card_id}]={{file='{name}.ecl',timeout_start={timer[0]},timeout={timer[1]},photos={photos},sha256='{digest}'}},")
    lines.append('}')
    target=ROOT/'mod/GAME/th33_sources.lua'
    target.write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(f'已从原作导出{len(mapping)}幕：{target}')

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('declarations',type=Path)
    parser.add_argument('binaries',type=Path)
    args=parser.parse_args()
    export(args.declarations,args.binaries)
