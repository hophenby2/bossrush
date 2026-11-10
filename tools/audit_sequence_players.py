"""只读比对原作SHT/ANM导出与发行数据，输出逐机体核查清单；不访问玩家目录。"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--workspace',type=Path,default=Path('E:/workspace'))
ap.add_argument('--luajit',type=Path,default=Path('E:/fork/LuaSTG-Sub/tool/luajit/luajit.exe'))
ap.add_argument('--thtk',type=Path,default=Path('E:/workspace/thtkGUI-th20tr/thtk/thtk-th20'))
ap.add_argument('--output',type=Path,required=True)
args=ap.parse_args()
spec=importlib.util.spec_from_file_location('player_export',ROOT/'tools/export_sequence_player.py')
export=importlib.util.module_from_spec(spec);spec.loader.exec_module(export)
lua=r'''
local function encode(t)
    if type(t)=='table' then
        local out={};for k,v in pairs(t) do out[#out+1]=encode(tostring(k))..':'..encode(v) end
        return '{'..table.concat(out,',')..'}'
    elseif type(t)=='string' then return '"'..t:gsub('[%z\1-\31\\"]',function(c)return ('\\u%04x'):format(c:byte())end)..'"'
    elseif type(t)=='boolean' then return tostring(t)
    elseif type(t)=='number' then return ('%.17g'):format(t) end
    return 'null'
end
local out={};local P=dofile('THlib/sequence_resources.lua')
for _,g in ipairs({6,7,8,10}) do
    out[g]={data=dofile('mod/GAME/original/players/'..g..'.lua'),machines=P.machines(g),anm={}}
    for _,m in ipairs(P.machines(g)) do
        local archive=(g==10 and 'pl' or 'player')..('%02d'):format(m.character)
        out[g].anm[archive]=dofile('mod/GAME/original/'..g..'/'..archive..'.lua')
    end
end
print(encode(out))
'''
result=subprocess.run([str(args.luajit),'-'],input=lua.encode(),capture_output=True,cwd=ROOT,check=True)
data=json.loads(result.stdout.decode('utf8'))
def normalized(value):
    if isinstance(value,list):return {str(i+1):normalized(v) for i,v in enumerate(value)}
    if isinstance(value,dict):return {str(k):normalized(v) for k,v in value.items()}
    return value
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()
report={'射击表':[],'动画档案':[],'机体':[],'范围':'数值与资源来源的一致性；运动/触发由check_sequence_fidelity.lua及真引擎另验'}
cache=args.workspace/'.bossrush-validation/sequence-player-export'
with tempfile.TemporaryDirectory(prefix='bossrush-anm-audit-') as tmp:
    for game in (6,7,8,10):
        source=export.th06(args.workspace/'th06') if game==6 else {p.stem:export.sht(p,game) for p in (cache/str(game)).rglob('*.sht')}
        assert normalized(source)==data[str(game)]['data'],f'{game} SHT数值与原件不一致'
        for key,value in source.items():
            report['射击表'].append({'原作':game,'文件':key,'火力档':len(value['levels']),'发弹行':sum(len(l['shots']) for l in value['levels'])})
        for archive,actual in data[str(game)]['anm'].items():
            path=next((cache/str(game)).rglob(archive+'.anm'))
            decl=export.anm.run([args.thtk/'thanm.exe','-l',game,path])
            dest=Path(tmp)/str(game)/archive;dest.mkdir(parents=True)
            expected=export.anm.parse(decl,cache/str(game),dest,game,archive)
            expected.update(game=game,archive=archive)
            assert normalized(expected)==actual,f'{game}/{archive} ANM指令或精灵映射不一致'
            from PIL import Image
            for texture in expected['textures']:
                original=Image.open(dest/texture).convert('RGBA')
                bundled=Image.open(ROOT/'Resources/Original'/str(game)/texture).convert('RGBA')
                assert original.size==bundled.size and original.tobytes()==bundled.tobytes(),f'{game}/{texture}像素不一致'
            report['动画档案'].append({'原作':game,'档案':archive,'sha256':digest(path),'脚本':len(expected['scripts']),'精灵':len(expected['sprites']),'纹理':len(expected['textures'])})
        for m in data[str(game)]['machines'].values():
            archive=('pl' if game==10 else 'player')+f"{m['character']:02d}"
            callbacks=set()
            for name in {m['primary'],m['secondary']}:
                for level in source[name]['levels']:
                    for row in level['shots']:callbacks.add(tuple(row['callbacks']))
            report['机体'].append({'原作':game,'机体':m['id'],'名称':m['name'],'高速':m['primary'],'低速':m['secondary'],'ANM':archive,'回调组合':[list(v) for v in sorted(callbacks)]})
args.output.parent.mkdir(parents=True,exist_ok=True)
args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n','utf8',newline='\n')
print(f"原件对表通过：{len(report['机体'])}个射击机体，{len(report['射击表'])}份射击表，{len(report['动画档案'])}份ANM。")
