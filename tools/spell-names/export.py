"""按原ECL入口/难度提取日文卡名，以THBWiki双语表匹配中文；不按移植标题猜来源。"""
from pathlib import Path
import argparse
import ast
import hashlib
import json
import re
import sys
import struct
from types import SimpleNamespace
import unicodedata
from lxml import html

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools/th3x-tests'))
from export_original_anm import lua

GAMES={31:8,32:6,33:95,34:7,35:10,36:11}
TITLES={6:'东方红魔乡',7:'东方妖妖梦',8:'东方永夜抄',95:'东方文花帖',10:'东方风神录',11:'东方地灵殿'}


def norm(name):
    return re.sub(r'\s+','',unicodedata.normalize('NFKC',name)).replace('～','~')


def decrypt_name(raw,at,game):
    if game==8:
        return bytes(b^0xaa for b in raw[at+20:at+68]).split(b'\0')[0].decode('cp932')
    if game==10:
        length=struct.unpack_from('<i',raw,at+28)[0];key=0x77;step=7;out=[]
        for b in raw[at+32:at+32+length]:
            out.append(b^key);key=(key+step)&255;step=(step+16)&255
        return bytes(out).split(b'\0')[0].decode('cp932')
    return bytes(b^0xaa for b in raw[at+12:at+60]).split(b'\0')[0].decode('cp932')


def wiki_tables(folder):
    result={}
    for game,title in TITLES.items():
        raw=(folder/(title+'.html')).read_bytes()
        table=html.fromstring(raw).xpath('//table[contains(@class,"wikitable")]')[0]
        pending={};header=None;out=[]
        for tr in table.xpath('./tbody/tr|./tr'):
            row={};col=0
            for c,(v,left) in list(pending.items()):
                row[c]=v
                if left==1:del pending[c]
                else:pending[c]=(v,left-1)
            for td in tr.xpath('./td|./th'):
                while col in row:col+=1
                text=''.join(td.itertext()).strip()
                for _ in range(int(td.get('colspan','1'))):
                    row[col]=text
                    if int(td.get('rowspan','1'))>1:pending[col]=(text,int(td.get('rowspan'))-1)
                    col+=1
            values=[row[k] for k in sorted(row)]
            if '符卡翻译名' in values:
                header=values;continue
            if not header or len(values)!=len(header):continue
            d=dict(zip(header,values));ja=d['符卡名'];zh=d['符卡翻译名']
            if '「' not in ja and '『' not in ja:continue
            out.append(dict(ja=ja,zh=zh,number=d.get('编号',d.get('符卡号/编号',d.get('符卡号',''))),
                            difficulty=d.get('难度',''),character=d.get('角色','')))
        assert out,(game,'缺少THBWiki符卡表')
        result[game]=dict(rows=out,url='https://thwiki.cc/'+title+'/符卡',sha256=hashlib.sha256(raw).hexdigest())
    return result


def quoted(text):
    return (ast.literal_eval(text) if text[:1] in ('"',"'") else text).split('\0')[0]


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--wiki-cache',type=Path,default=Path('E:/workspace/.bossrush-validation/spell-names'))
    ap.add_argument('--ecl',type=Path,default=Path('E:/workspace/原作/ECL'))
    ap.add_argument('--decl',type=Path,default=Path('E:/workspace/.bossrush-validation/original-anm/ecl'))
    ap.add_argument('--th11',type=Path,default=Path('E:/workspace/.bossrush-validation/th36-source'))
    args=ap.parse_args();wiki=wiki_tables(args.wiki_cache)
    index=json.loads((ROOT/'tools/th3x-tests/card-audit-index.json').read_text('utf-8'))['cards']
    loaded={};cards={};records=[];failures=[]
    def source(game,file):
        key=(game,file)
        if key not in loaded:
            decl=args.decl/str(game)/(file+'.decl')
            if game==95:decl=args.decl.parent.parent/'source-assets/th095'/(file+'.decl')
            binary=args.ecl/('th095' if game==95 else f'th{game:02d}')/(file+'.ecl')
            # 只读取START_SPELL，不解析说明文字的控制字节；地址、编号、掩码均核对原二进制。
            raw=binary.read_bytes();subs={}
            ops={6:{93},7:{90},8:{122},95:{104},10:{342,357,358,359}}[game]
            for m in re.finditer(r'(?:sub|void) (\w+)\([^)]*\)\s*\{(.*?)\n\}',decl.read_text('cp932',errors='replace'),re.S):
                rows=[]
                for match in re.finditer(r'/\*\s*([0-9a-f]+) \([^*]+\*/\s*ins_(\d+)\(([^\n]*)',m[2]):
                    at=int(match[1],16);op=int(match[2])
                    if op not in ops:continue
                    assert struct.unpack_from('<h',raw,at+4)[0]==op
                    payload=at+(16 if game==10 else 12)
                    if game in (6,7):
                        operands=list(struct.unpack_from('<hh',raw,payload))
                        if game==6:operands.append(repr(raw[payload+4:payload+38].split(b'\0')[0].decode('cp932')))
                    else:
                        name=repr(decrypt_name(raw,at,game))
                        operands=[name] if game==95 else ([*struct.unpack_from('<hhi',raw,payload),name] if game==8 else [*struct.unpack_from('<iii',raw,payload),name])
                    rows.append(SimpleNamespace(op=op,mask=raw[at+(10 if game==10 else 9)],args=operands,address=at))
                subs[m[1]]=rows
            loaded[key]=SimpleNamespace(subs=subs,sha256=hashlib.sha256(raw).hexdigest())
        return loaded[key]
    for c in index:
        if not c['is_spell'] or c['source'].get('kind') in ('时间轴','自制条目'):continue
        game=GAMES[c['game']];src=c['source'];file=Path(src['file']).stem;s=source(game,file)
        rank=c['metadata'].get('th07_motion_source',{}).get('difficulty',3)
        mask=16 if re.search(r'(?:ecldata[78]|stage07)$',file) else 1<<rank
        candidates=[];rank_fallback=[]
        for sub in (src['closure'] if game==95 else src['roots']):
            for r in s.subs[sub]:
                if not r.mask&mask:continue
                if game==6 and r.op==93:candidates.append((quoted(r.args[2]),r.args[1],r.address))
                elif game==7 and r.op==90:
                    # 本地妖妖梦是汉化版，名字区已改写；原生卡号未改。用THBWiki的原作日文列恢复。
                    number=r.args[1]+1
                    difficulty='Extra' if file=='ecldata7' else 'Phantasm' if file=='ecldata8' else ('Easy','Normal','Hard','Lunatic')[rank]
                    entries=[w for w in wiki[7]['rows'] if w['number'].isdigit() and int(w['number'])==number]
                    names={w['ja'] for w in entries}
                    assert len(names)==1,(c['id'],number,names)
                    item=(names.pop(),r.args[1],r.address)
                    rank_fallback.append(item)
                    if any(difficulty.lower() in w['difficulty'].lower() for w in entries):candidates.append(item)
                elif game==8 and r.op==122:candidates.append((quoted(r.args[3]),r.args[1],r.address))
                elif game==95 and r.op==104:candidates.append((quoted(r.args[0]),None,r.address))
                elif game==10 and r.op in (342,357,358,359):candidates.append((quoted(r.args[3]),r.args[0],r.address))
        # 已有移植中有三张只在E/N命名的独立卡；源入口只有同一种名称时保留该原名。
        if game==7 and not candidates and len({x[0] for x in rank_fallback})==1:candidates=rank_fallback
        number=c['metadata'].get('cardnum')
        if number is not None and any(x[1]==number for x in candidates):candidates=[x for x in candidates if x[1]==number]
        names={x[0] for x in candidates}
        if len(names)!=1:
            failures.append(dict(game=c['game'],id=c['id'],file=file,roots=src['roots'],candidates=candidates));continue
        ja=names.pop();matches=[w for w in wiki[game]['rows'] if norm(w['ja'])==norm(ja)]
        # 原版文花帖ECL的ダイア／THBWiki表的ダイヤ是同一张5-8；日文仍保留ECL字节。
        if game==95 and ja=='日＆月符「ロイヤルダイアモンドリング」':
            matches=[w for w in wiki[95]['rows'] if w['number']=='5-8']
        if not matches:
            failures.append(dict(game=c['game'],id=c['id'],ja=ja,file=file,reason='THBWiki无匹配'));continue
        zh=matches[0]['zh']
        level=c['game']-2;cards.setdefault(level,{})[c['id']]=dict(ja=ja,zh=zh)
        records.append(dict(game=c['game'],id=c['id'],ja=ja,zh=zh,file=src['file'],roots=src['roots'],
                            source_sha256=s.sha256,spell_addresses=[x[2] for x in candidates],
                            japanese_source='THBWiki原作日文列（本地ECL为汉化版）' if game==7 else '原作ECL',wiki=wiki[game]['url']))
    sys.path.insert(0,str(ROOT/'tools/th36-tests'))
    from source import load,programs
    from catalogue import catalogue,Probe
    sources=load(args.th11)
    for c in catalogue(sources):
        if c['spell'] is None:continue
        p=Probe(programs(sources,c['stage']),c['stage'],c['total_hp'],c['shot']).run(c['sub'])
        ja=quoted(p.spell[2]);matches=[w for w in wiki[11]['rows'] if norm(w['ja'])==norm(ja)]
        if not matches:failures.append(dict(game=36,id=c['id'],ja=ja,reason='THBWiki无匹配'));continue
        zh=matches[0]['zh'];cards.setdefault(34,{})[c['id']]=dict(ja=ja,zh=zh)
        records.append(dict(game=36,id=c['id'],ja=ja,zh=zh,stage=c['stage'],sub=c['sub'],
                            native_spell_index=c['spell'],japanese_source='原作ECL',wiki=wiki[11]['url']))
    output=dict(cards=records,failures=failures,wiki={str(g):{k:v for k,v in d.items() if k!='rows'} for g,d in wiki.items()})
    (ROOT/'tools/spell-names/catalogue.json').write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n','utf-8')
    if failures:
        print(json.dumps(failures,ensure_ascii=False,indent=2));raise SystemExit(f'{len(failures)}项需核对，未写运行时表')
    (ROOT/'mod/GAME/original/spell_names.lua').write_text('-- 按原作ECL入口与THBWiki原作日文／中文列生成；来源见tools/spell-names/catalogue.json。\nreturn '+lua(cards)+'\n','utf-8',newline='\n')
    print(json.dumps(dict(cards=len(records),by_game={g:sum(c['game']==g for c in records) for g in GAMES}),ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
