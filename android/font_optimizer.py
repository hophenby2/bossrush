"""安卓逐码点绘字：保留所有Unicode、提示指令和缺字框，移除不用的布局替代字形。"""
from pathlib import Path
import hashlib
import json
import struct


def verify_font_pair(source, packed):
    import freetype as ft
    a,b=ft.Face(str(source)),ft.Face(str(packed))
    chars={c for c,g in a.get_chars() if g};other={c for c,g in b.get_chars() if g}
    assert chars==other,'字体Unicode范围改变'
    assert (a.ascender,a.descender,a.height,a.units_per_EM)==(b.ascender,b.descender,b.height,b.units_per_EM),'字体行高改变'
    flags=ft.FT_LOAD_RENDER|ft.FT_LOAD_NO_AUTOHINT
    digest=hashlib.sha256();count=0
    def glyph(face,code):
        face.load_char(code,flags);g=face.glyph;m=g.metrics
        metrics=(g.bitmap.width,g.bitmap.rows,g.bitmap.pitch,g.bitmap.pixel_mode,g.bitmap_left,g.bitmap_top,
                 g.advance.x,g.advance.y,m.width,m.height,m.horiBearingX,m.horiBearingY,m.horiAdvance,
                 m.vertBearingX,m.vertBearingY,m.vertAdvance)
        return struct.pack('<16q',*metrics)+bytes(g.bitmap.buffer)
    samples=sorted(({0,0x10ffff,0xfffd,32}|{ord(c) for c in '分数樱点信仰低速剣斬閃龍靈梦妖ABC0123456789'}) & (chars|{0,0x10ffff,0xfffd}))
    for size in (20,26,28,32,80):
        a.set_pixel_sizes(0,size);b.set_pixel_sizes(0,size)
        codes=sorted(chars|{0,0x10ffff}) if size==32 else samples
        for code in codes:
            first,second=glyph(a,code),glyph(b,code)
            assert first==second,(hex(code),size,'字形像素或度量改变')
            digest.update(struct.pack('<II',size,code));digest.update(first);count+=1
    return {'unicode_characters':len(chars),'glyph_cases':count,'bitmap_and_metrics_exact':True,
            'glyph_sha256':digest.hexdigest(),'fallback_glyph_kept':True}


def optimize_fonts(sources, cache):
    import fontTools
    from fontTools import subset
    from fontTools.ttLib import TTFont
    import freetype
    cache.mkdir(parents=True,exist_ok=True)
    variants,records={},{}
    for source in sources:
        raw=source.read_bytes()
        policy=f'all-unicode-hints-notdef-v1-{fontTools.__version__}-{freetype.version()}'
        key=hashlib.sha256(raw+policy.encode()).hexdigest()
        target,metadata=cache/(key+source.suffix),cache/(key+'.json')
        if metadata.exists():
            record=json.loads(metadata.read_text())
            if target.exists() and hashlib.sha256(target.read_bytes()).hexdigest()==record['packed_sha256']:
                if record['converted']:variants[source]=target
                records[source]=record;continue
        font=TTFont(source,recalcBBoxes=False,recalcTimestamp=False)
        characters={c for table in font['cmap'].tables if table.isUnicode() for c in table.cmap}
        options=subset.Options()
        options.layout_features=[];options.hinting=True;options.notdef_outline=True;options.legacy_kern=True
        options.recalc_timestamp=False;options.recalc_bounds=False
        options.name_IDs=['*'];options.name_legacy=True;options.name_languages=['*']
        sub=subset.Subsetter(options=options);sub.populate(unicodes=characters);sub.subset(font)
        font.save(target);font.close()
        check=verify_font_pair(source,target)
        converted=target.stat().st_size<len(raw)*.98
        record={'converted':converted,'source_bytes':len(raw),'packed_bytes':target.stat().st_size,
                'source_sha256':hashlib.sha256(raw).hexdigest(),'packed_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),**check}
        metadata.write_text(json.dumps(record,ensure_ascii=False)+'\n')
        if converted:variants[source]=target
        records[source]=record
    return variants,records
