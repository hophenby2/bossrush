"""核对TH07入口和隐身循环的体术/受弹开关；执行实际卡片协程，不只检查配置表。"""
from pathlib import Path
import sys

from card_catalogue import runtime, plain
from ecl_source import Source


def check():
    lua=runtime()
    lua.execute('''
        local f=assert(io.open('tools/check_original_ecl_fidelity.lua','rb'));local s=f:read('*a');f:close()
        E=assert(loadstring(s:sub(1,assert(s:find('local function upvalue',1,true))-1)..
            '\\nreturn {class=C,cards=cards,objects=objects,make=make}'))()
        function contact_trace(id)
            local c=E.cards[id]
            local b={x=0,y=96,rot=0,timer=0,ani=0,hp=10000,maxhp=10000,colli=true,_live=true}
            c.init(b)
            local out={}
            for t=0,900 do
                task.Do(b);c.frame(b)
                out[#out+1]={b.colli and true or false,b.colli and b.group==GROUP.ENEMY or false,
                    b._original_damage_box[1],b._original_damage_box[2]}
                b.timer,b.ani=t+1,t+1
            end
            c.del(b)
            return out
        end
    ''')
    sources={}
    count=0

    def source(stage):
        if stage not in sources:
            sources[stage]=Source(Path(f'E:/workspace/.bossrush-validation/original-anm/ecl/7/ecldata{stage}.decl'),
                                  Path(f'E:/workspace/原作/ECL/th07/ecldata{stage}.ecl'),7)
        return sources[stage]

    def instruction(stage,sub,op,value):
        found=[r for r in source(stage).subs[f'Sub{sub}'] if r.mask&8 and r.op==op and r.args[0]==value]
        assert found,(stage,sub,op,value)
        return found[0]

    cases={3440:(8,129,104,0),3442:(8,119,132,1),3470:(7,115,132,1)}
    for card,(stage,sub,op,value) in cases.items():
        at=instruction(stage,sub,op,value).time
        for t,row in enumerate(plain(lua.globals().contact_trace(card))):
            assert row[:2]==[t<at,t<at],(card,t,row,at)
            count+=1

    for card,stage,root,called in [(4430,3,22,23),(4450,1,20,26),(4460,2,40,41)]:
        instruction(stage,root,102,0)
        assert instruction(stage,called,102,1).time==0
        call=instruction(stage,root,41,called)
        for t,row in enumerate(plain(lua.globals().contact_trace(card))):
            assert row[:2]==[True,t>=call.time],(card,t,row)
            count+=1

    at=instruction(7,61,102,0).time
    box=instruction(7,61,101,96).args[:2]
    entry_box=instruction(7,54,101,48).args[:2]
    assert at==instruction(7,61,101,96).time
    for t,row in enumerate(plain(lua.globals().contact_trace(3461))):
        assert row==[True,t<at,*(box if t>=at else entry_box)],(3461,t,row)
        count+=1
    # Sub70的三次难度跳转把0→120→240→360压在同一帧执行，480对应墙钟120。
    at=instruction(5,70,102,1).time-360
    for t,row in enumerate(plain(lua.globals().contact_trace(4409))):
        assert row[:2]==[True,t>=at],(4409,t,row)
        count+=1

    # 同步CALL的耗时属于墙钟，不推进调用者脚本时刻。
    # Sub103每次4帧、Sub100每次14帧；Sub2的粒子循环每次4帧。
    for card,stage,root,cast,hidden,restored,call_time,gap,decrease in [
            (3446,8,102,103,266,243,12,100,6), (3466,7,99,100,260,None,14,100,10)]:
        eq=instruction(stage,root,102,0)
        assert eq.time==210
        assert instruction(stage,root,132,1).time==hidden
        assert instruction(stage,root,132,0).time==hidden
        if restored:assert instruction(stage,root,102,1).time==restored
        # 调用者240帧CALL；被调用程序的RET给出无额外循环的发弹耗时。
        ret=[r for r in source(stage).subs[f'Sub{cast}'] if r.op==42][-1]
        assert ret.time==(4 if card==3446 else 14)
        changes={210:(True,False)}
        start=210
        while start<=900:
            if restored:
                changes[start+16+(restored-210)+call_time]=(True,True)
                changes[start+16+(246-210)+call_time]=(True,False)
            off=start+16+(hidden-210)+call_time
            changes[off]=(False,False)
            start=off+gap+40
            changes[start]=(True,False)
            if gap>(40 if card==3446 else 10):gap-=decrease
        state=(True,True)
        for t,row in enumerate(plain(lua.globals().contact_trace(card))):
            state=changes.get(t,state)
            assert row[:2]==list(state),(card,t,row,state)
            count+=1
    print(f'TH07十张卡的实际协程对照原始体术/受弹开关及判定框：{count}帧通过。')


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    check()
