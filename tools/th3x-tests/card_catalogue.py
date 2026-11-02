"""逐卡核对的入口索引；载入真实卡表，保留实现位置，不把运行通过标为语义通过。"""
import argparse
import json
from pathlib import Path
import shlex
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]


def runtime():
    try:
        from lupa.luajit21 import LuaRuntime
    except ImportError:
        sys.path.insert(0, str(Path(tempfile.gettempdir()) / 'bossrush-motion-tools'))
        from lupa.luajit21 import LuaRuntime
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.globals().arg = lua.table_from(['逐卡原作核对'])

    def listing(command):
        args = shlex.split(command.split('2>')[0])
        if args[0] == 'ls':
            return '\n'.join(p.name for p in (ROOT / args[1]).iterdir())
        if args[0] == 'find':
            return '\n'.join(p.relative_to(ROOT).as_posix()
                             for d in args[1:args.index('-name')]
                             for p in (ROOT / d).rglob('*.lua'))
        raise ValueError(command)

    lua.globals().python_listing = listing
    lua.execute("io.popen=function(c) local f=assert(io.tmpfile());f:write(python_listing(c));f:seek('set');return f end")
    setup = (ROOT / 'tools/check_stage.lua').read_text('utf-8-sig')
    lua.execute(setup.split('if path == "--all" then', 1)[0])
    # 自检桩保留秒，真实卡表存帧。入口审计必须使用游戏的构造函数，
    # 否则低速血量包装写入的帧数会与桩的秒数混在同一张表中。
    lua.execute("local saved=boss.card;dofile('THlib/enemy/boss_card.lua');"
                "local new=boss.card.New;audit_register=boss.card.add;boss.card=saved;boss.card.New=new;"
                "_sc_table={};_sc_pr_table={}")
    return lua


def plain(value):
    if hasattr(value, 'items'):
        items = dict(value.items())
        if items and set(items) == set(range(1, len(items) + 1)):
            return [plain(items[i]) for i in range(1, len(items) + 1)]
        return {str(k): plain(v) for k, v in items.items()}
    return value


def catalogue():
    lua = runtime()
    lua.execute('''
        audit_cards={}
        boss.card.add=function(parts,level,title,id,...)
            audit_register(parts,level,title,id,...)
            audit_cards[#audit_cards+1]={parts=parts,level=level,title=title,id=id}
        end
        for game=31,35 do dofile('mod/GAME/th'..game..'.lua') end
        function audit_describe(entry)
            local c=entry.parts[1][1]
            local out={game=entry.level+2,id=entry.id,name=entry.title,implementation={},metadata={},
                hp=c.hp,t1=c.t1,t2=c.t2,t3=c.t3,is_spell=c.is_sc}
            local seen,locations={},{}
            local function visit(fn,path,depth)
                if type(fn)~='function' or seen[fn] or depth>12 then return end
                seen[fn]=true
                local info=debug.getinfo(fn,'S')
                if info.what~='Lua' or not info.source:find('mod/GAME/',1,true) then return end
                if path=='init/main' and OriginalStageVisual.functions[fn] then
                    out.metadata.main_source=OriginalStageVisual.functions[fn]
                end
                local key=info.source..':'..info.linedefined
                if not locations[key] then
                    locations[key]=true
                    out.implementation[#out.implementation+1]={file=info.source:gsub('^@',''),
                        first=info.linedefined,last=info.lastlinedefined,path=path}
                end
                for i=1,100 do
                    local name,u=debug.getupvalue(fn,i);if not name then break end
                    if type(u)=='function' then visit(u,path..'/'..name,depth+1)
                    elseif type(u)=='table' and (name=='impl' or name=='opt' or name=='cfg') then
                        for k,v in pairs(u) do if type(v)=='function' then visit(v,path..'/'..name..'/'..k,depth+1) end end
                    elseif name=='cardnum' and type(u)=='number' then out.metadata.cardnum=u
                    elseif name=='id' and info.source:find('th31_combat.lua',1,true) then out.metadata.cardnum=u end
                end
            end
            for _,name in ipairs({'before','init','frame','render','del'}) do visit(c[name],name,0) end
            out.metadata.original_ecl=c.original_ecl
            out.metadata.th06_source=c.th06_source
            out.metadata.th08_motion_source=c.th08_motion_source
            out.metadata.th08_lastword_source=c.th08_lastword_source
            out.metadata.balance=c._original_balance
            if out.game==34 then out.metadata.th07_motion_source=_editor_class.TH34.th07_motion_source[entry.id] end
            return out
        end
    ''')
    rows = [plain(lua.globals().audit_describe(entry)) for _, entry in lua.globals().audit_cards.items()]
    assert len(rows) == 521, len(rows)
    assert len({(r['game'], r['id']) for r in rows}) == len(rows)
    for new_id in range(5480,5486):
        assert sum(r['id']==new_id for r in rows)==1, ('新增卡ID与其他作品冲突',new_id)
    for n, row in enumerate(rows, 1):
        row['order'] = n
        row['review'] = '未逐条核对'
        row['implementation'] = sorted(row['implementation'], key=lambda x: (x['file'], x['first']))
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--sources', action='store_true', help='同时核对原始二进制入口与静态调用闭包')
    parser.add_argument('--cache', type=Path, default=Path(r'E:\workspace\.bossrush-validation\original-anm'))
    parser.add_argument('--binaries', type=Path, default=Path(r'E:\workspace\原作\ECL'))
    args = parser.parse_args()
    rows = catalogue()
    if args.sources:
        from card_sources import attach
        print(dict(attach(rows, args.cache, args.binaries)))
    data = {'说明': '这是全量入口索引。每张卡的语义核对记录单独保存；已有运行覆盖不能改变本表的未核对状态。',
            'cards': rows}
    args.output.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', 'utf-8')
    print(f'已索引 {len(rows)} 个条目：{args.output}')


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    main()
