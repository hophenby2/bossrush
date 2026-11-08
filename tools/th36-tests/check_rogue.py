"""检查地灵殿独立道中、准备面板的新增选项，以及可选的真引擎道中结果。"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import sys
from run_lua import ROOT,runtime


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--native',type=Path)
    args=ap.parse_args();os.chdir(ROOT)
    lua=runtime();lua.globals().arg=lua.table_from(['地灵殿随机池'])
    setup=(ROOT/'tools/check_stage.lua').read_text('utf-8-sig').split('if path == "--all" then',1)[0]
    lua.execute(setup);lua.execute("dofile('THlib/anm/original.lua');dofile('mod/GAME/th36.lua')")
    frames=lua.execute('''
        local H=_editor_class.TH36.runtime
        assert(#_editor_class.TH36.boss_order==7,'主线完整关卡顺序被随机道中改动')
        H.emit_pattern=function() end
        local frames={}
        for stage=1,7 do
            local host={_live=true}
            local s=H.session(host,stage,'main',nil,{road_only=true})
            local births=0
            local spawn=H.spawn
            H.spawn=function(a,...)
                local actor=spawn(a,...)
                if actor then
                    assert(not actor.is_boss and actor.sub~='Boss' and not actor.sub:match('^MBoss%d*$'))
                    births=births+1
                end
                return actor
            end
            while not s.done and s.frame<60000 do
                H.step(s)
                assert(not s.boss,'独立道中不能创建Boss演员')
            end
            assert(s.done and births>0,('道中未自然结束或没有敌机：%d'):format(stage))
            assert(next(s.skipped_bosses),'没有剥离原作Boss入口')
            frames[stage]={stage=stage,frames=s.frame,births=births}
            H.spawn=spawn;H.close(s)
        end
        -- 普通整关不走剥离分支，原Boss入口仍实际创建。
        local full=H.session({_live=true},1,'main')
        assert(H.spawn(full.root,257,'MBoss',0,-32,40,0,0),'整关中Boss被错误剥离')
        H.close(full)
        return frames
    ''')
    lua.execute('''
        RogueTen={copyFilters=dofile('mod/rogue_pool.lua').copy,poolStatus=function() return {valid=true,count=503} end}
        scoredata={};local keys={}
        KEY={ENTER=13};setting={keys={shoot=90}}
        menu={keyYes=function() return keys.yes end,keyNo=function() return false end,
              keyUp=function() return keys.up end,keyDown=function() return keys.down end,
              keyLeft=function() return false end,keyRight=function() return false end}
        ext.mouse={x=-1000,y=-1000,_wheel=0,isDown=function() return keys.click end}
        GetLastKey=function() return 0 end
        Dist=function(x,y,a,b) return math.sqrt((x-a)^2+(y-b)^2) end
        sp={math={PointBoundCheck=function(x,y,l,r,b,t) return x>=l and x<=r and y>=b and y<=t end}}
        local U=dofile('THlib/UI/rogue_pool.lua')
        local o={yes=function(o) o.started=true end,no=function() end,addpos1=function() end,alpha=1,keyname={},timer=0}
        U.fresh(o,'roguelike');assert(o.pool_options.stages.TH36)
        o.pool_focus=5;keys.yes=true;U.frame(o);keys.yes=false
        assert(not o.pool_options.stages.TH36,'射击键没有切换地灵殿')
        ext.mouse.x,ext.mouse.y=600,312;keys.click=true;U.frame(o);keys.click=false
        assert(o.pool_options.stages.TH36 and o.pool_focus==5,'触屏没有切换地灵殿')
        ext.mouse.x,ext.mouse.y=-1000,-1000
        keys.down=true;o.pool_focus=9;U.frame(o);assert(o.pool_focus==10)
        U.frame(o);assert(o.pool_focus==0,'键盘焦点没有覆盖全部九个选项和开始按钮');keys.down=false
        ext.mouse.x,ext.mouse.y=480,45;keys.click=true;U.frame(o);keys.click=false
        assert(o.started and o.pool_focus==10,'准备按钮点击失效')
        local rectangles,labels={},{}
        RenderRect=function(_,l,r,b,t) rectangles[#rectangles+1]={l,r,b,t} end
        ui={RenderText=function(_,_,label) labels[label]=true end}
        U.render(o);assert(labels['地灵殿 · TH36'] and #rectangles==9)
        for i,a in ipairs(rectangles) do
            assert(a[1]>=0 and a[2]<=960 and a[3]>=0 and a[4]<=540)
            for j=1,i-1 do local b=rectangles[j]
                assert(math.min(a[2],b[2])<=math.max(a[1],b[1]) or math.min(a[4],b[4])<=math.max(a[3],b[3]),'选项点击区域重叠')
            end
        end
    ''')
    result=dict(roads=[dict(row.items()) for row in frames.values()],road_bosses_excluded=True,
                full_stage_boss_preserved=True,ui_options=9,keyboard=True,touch=True,
                scope='LuaJIT道中演员和自然结束检查关闭发弹；面板输入及点击区域；不替代Android设备实测')
    if args.native:
        config=json.loads((args.native/'native-run.json').read_text('utf-8'))
        data=json.loads((args.native/'native-result.json').read_text('utf-8'))
        assert data['run_id']==config['run_id'] and not data['errors']
        assert data['completed']==data['expected']==7
        assert {r['id'] for r in data['records']}==set(range(11201,11208))
        for path,digest in config['hashes'].items():
            if path=='mod/GAME/th36.lua' or path.startswith('mod/GAME/th36/') or path in (
                    'mod/GAME/original/th11_low_speed_hp.lua','mod/roguelike.lua','mod/rogue_pool.lua',
                    'mod/rogue_pool_sources.lua','THlib/UI/rogue_pool.lua'):
                assert hashlib.sha256((ROOT/path).read_bytes()).hexdigest()==digest,path
        for row in data['records']:
            assert row['rendered']>0 and row['frames']<60000
            assert not row.get('th36_spells')
            assert all(v==0 for k,v in row['cleanup'].items() if k in ('actors','bullets','lasers'))
            assert not any(n=='Boss' or n.startswith('MBoss') for n in row.get('th36_spawns',{}))
        result['native']=dict(directory=str(args.native),run_id=data['run_id'],version=data['version'],
                              completed=7,frames=sum(r['frames'] for r in data['records']),errors=data['errors'])
    (ROOT/'tools/th36-tests/verification-rogue-2026-11-08.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n','utf-8')
    print(json.dumps(result,ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
