"""按SceneSelect.cpp逐幕核对Boss入场ANM及背景，防止角色名称互换仍能跑通。"""
from pathlib import Path
import re
import sys

from card_catalogue import runtime, plain


def check():
    source = Path('E:/workspace/th095/src/SceneSelect.cpp').read_text('utf-8')
    expected = dict((ecl, anm.removesuffix('.anm')) for anm, ecl in
                    re.findall(r'TH095_SCENE\([^\n]+?"(enm\d+\.anm)", "(ecl\d+_[a-d]\.ecl)"', source))
    assert len(expected) == 85
    lua = runtime()
    lua.execute('''
        audit_roles={}
        boss.card.add=function(parts,level,title,id)
            local b=_editor_boss[parts[1][2]..level]
            local c=parts[1][1]
            audit_roles[#audit_roles+1]={definition=b,card=c,id=id}
        end
        dofile('mod/GAME/th33.lua')
        function audit_role(row)
            local o={class=row.definition,ani=0,timer=0,x=0,y=96,a=16,b=16,
                current_card=row.card,__show_scbg=true,rot=0,_live=true}
            assert(OriginalStageVisual.bind_boss({obj=o},row.definition.img))
            boss_group={o}
            local bg={}
            o._bg.init(bg);o._bg.frame(bg)
            local backgrounds={}
            for _,v in ipairs(bg.vms) do backgrounds[#backgrounds+1]=v.data.archive end
            return {id=row.id,file=row.card.original_ecl.file,name=row.definition.name,
                actor=o._original_actor.archive,backgrounds=backgrounds}
        end
    ''')
    rows = [plain(lua.globals().audit_role(row)) for _, row in lua.globals().audit_roles.items()]
    assert len(rows) == 85
    assert {r['file'] for r in rows} == set(expected)
    for row in rows:
        archive = expected[row['file']]
        assert row['actor'] == archive, (row, '入场角色与原作场景表不一致', archive)
        assert row['backgrounds'] and all(b == archive for b in row['backgrounds']), (row, '背景选了另一角色的ANM', archive)
    print('文花帖全部85幕：入场Boss主ANM与符卡背景均匹配原作SceneSelect表。')
    print('本项检查资源选择；移动姿态、动画中断与逐帧画面仍需单独对照。')


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    check()
