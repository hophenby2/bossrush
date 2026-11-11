"""核对实际APK中的完整Unicode字体、压缩来源及可选的全字符像素复验。"""
from pathlib import Path
import argparse
import hashlib
import json
import sys
import tempfile
import zipfile

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'android'))
from font_optimizer import verify_font_pair
from fontTools.ttLib import TTFont


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('apk',type=Path);p.add_argument('--rasterize',action='store_true');p.add_argument('--output',type=Path)
    a=p.parse_args()
    records=json.loads((ROOT/'android/build/font-optimization.json').read_text())
    report={}
    with zipfile.ZipFile(a.apk) as z,tempfile.TemporaryDirectory() as tmp:
        for name,record in records.items():
            source=ROOT/name[5:] if name.startswith('game/') else ROOT/'android/.cache/LuaSTG-x'/name
            raw=z.read('assets/'+name)
            assert hashlib.sha256(source.read_bytes()).hexdigest()==record['source_sha256'],name
            assert hashlib.sha256(raw).hexdigest()==record['packed_sha256'],name
            assert record['bitmap_and_metrics_exact'] and record['fallback_glyph_kept'],name
            assert z.getinfo('assets/'+name).compress_type==zipfile.ZIP_STORED,'字体必须保留流式随机读取'
            packed=Path(tmp)/Path(name).name;packed.write_bytes(raw)
            with TTFont(source) as f,TTFont(packed) as g:
                codes=lambda font:{c for t in font['cmap'].tables if t.isUnicode() for c in t.cmap}
                assert codes(f)==codes(g),'Unicode字符被删减'
            if a.rasterize:assert verify_font_pair(source,packed)['glyph_sha256']==record['glyph_sha256']
            report[name]={**record,'apk_bytes_match':True,'full_unicode_kept':True,'rasterized_again':a.rasterize}
    if a.output:a.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'fonts':len(report),'unicode_characters':sum(m['unicode_characters'] for m in report.values()),
        'glyph_cases':sum(m['glyph_cases'] for m in report.values()),'saved_bytes':sum(m['source_bytes']-m['packed_bytes'] for m in report.values())}))


if __name__=='__main__':main()
