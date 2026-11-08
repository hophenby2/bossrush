"""真引擎六作日文、设置保存和正式Bomb效果检查；每例补充库存，存档写独立目录。"""
import sys,importlib.util,argparse
from pathlib import Path
root=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,required=True)
args=parser.parse_args()
spec=importlib.util.spec_from_file_location('native',root/'tools/th3x-tests/native_engine.py')
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
prepare=engine.prepare
probe='''
local native_name_rows={}
local native_name_seen={}
function NameBombNativeProbe(host,frame,current)
    if frame~=120 or native_name_seen[current.level..':'..current.cardId] then return end
    native_name_seen[current.level..':'..current.cardId]=true
    local c=host.current_card
    assert(c.name==c.name_ja and current.title:find(c.name_ja,1,true),'原生战斗/随机池日文标题不一致')
    local p=player;local saved_death,saved_protect=p.death,p.protect
    p.death=1;p.protect=300
    -- 每张卡独立验证输入，不能把前五次测试消耗的库存带入第六次。
    lstg.var.upgrades.players[GameDrops.slot(p)].bombs=3
    local before=GameDrops.bombState(p);local objects=GetnObj()
    assert(GameDrops.bombInput(p,{spell=true},{spell=false}),'复活可操作期Bomb未释放')
    assert(GameDrops.bombState(p)==before-1 and GetnObj()>objects,'未消耗库存或未生成正式Bomb效果')
    assert(not GameDrops.bombInput(p,{spell=true},{spell=true}),'长按重复释放')
    p.death=84
    assert(not GameDrops.bombInput(p,{spell=true},{}),'死亡演出误释放')
    p.death,p.protect=saved_death,saved_protect
    local row={id=current.cardId,level=current.level,japanese=c.name,title=current.title,bomb=true}
    if host.th36_session then
        local bg=assert(host.th36_session.spell_background)
        row.background={bg.vms[1].id,bg.vms[2].id}
    end
    native_name_rows[#native_name_rows+1]=row
    local f=assert(io.open('native-name-bomb.json','w'));f:write(Serialize(native_name_rows));f:close()
end
'''
def instrument(output):
    prepare(output)
    path=output/'native_test.lua';s=path.read_text('utf8')
    anchor='    local function launch()\n'
    extra="""        assert(default_setting.spellNameLanguage==0,'默认语言不是中文')
        local menu=New(game_setting,function() end)
        local item=menu.menus[4].setting_item[2]
        assert(item.name=='spellNameLanguage' and item.display_way(0)=='中文' and item.display_way(1)=='日本語','语言选项缺失')
        object.RawDel(menu)
        cur_setting.spellNameLanguage=1;save_setting();loadConfigure()
        assert(setting.spellNameLanguage==1,'日文设置未保存')
        SpellNames.refresh(1)
"""
    assert s.count(anchor)==1;s=s.replace(anchor,anchor+extra)
    anchor='                    if host.th36_session then'
    assert s.count(anchor)==1;s=s.replace(anchor,'                    NameBombNativeProbe(host,frames,current)\n'+anchor)
    path.write_text(probe+s,'utf8',newline='\n')
engine.prepare=instrument
engine.run(argparse.Namespace(output=args.output,
    games='31,32,33,34,35,36',cases='401,369,509,4393,3606,11034',frames=960,speed=960,
    mode='timeout',flow='single',seed=20261031))
