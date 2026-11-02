"""核对原始生成指令的继承ANM，以及使魔出屏的原作边界；不代表整卡通过。"""
from pathlib import Path
import sys

from card_catalogue import runtime, plain
from ecl_source import Source, Variable, ScalarTrace


def check():
    lua = runtime()
    lua.execute('''
        audit_cards={}
        boss.card.add=function(parts,_,_,id) audit_cards[id]=parts[1][1] end
        dofile('mod/GAME/th31.lua')
        function audit_wave(id,frames,losses)
            local c=audit_cards[id]
            local b={x=0,y=96,vx=0,vy=0,timer=0,ani=0}
            local original=New
            local out,actors,clock={},{},0
            New=function(cls,...)
                local o=original(cls,...)
                if o.th08_source then
                    local actor=o._original_actor
                    out[#out+1]={o.th08_source,actor and actor.archive or false,
                        actor and actor.vm.id or false,clock,o.fam_color or false}
                    actors[#actors+1]=o
                end
                return o
            end
            c.init(b)
            for t=0,frames do
                clock=t;b.timer,b.ani=t,t
                if losses and losses[t] then
                    for _,o in ipairs(actors) do if IsValid(o) then object.RawDel(o);break end end
                end
                c.frame(b)
            end
            c.del(b);New=original
            return out
        end
    ''')
    count = 0

    def eq(actual, expected, context):
        nonlocal count
        assert actual == expected, (context, actual, expected)
        count += 1

    cases = [(360,'ecldata4asp',43,44), (440,'ecldata4a',41,42),
             (441,'ecldata4a',46,(47,48)), (443,'ecldata4b',17,21),
             (444,'ecldata4b',36,40), (445,'ecldata4b',22,24),
             (446,'ecldata4b',41,46), (447,'ecldata4b',28,30),
             (448,'ecldata4b',47,52), (449,'ecldata4b',31,33),
             (451,'ecldata4b',62,65)]
    for card,file,root,target in cases:
        targets = target if isinstance(target, tuple) else (target,)
        source = Source(Path(f'E:/workspace/.bossrush-validation/original-anm/ecl/8/{file}.decl'),
                        Path(f'E:/workspace/原作/ECL/th08/{file}.ecl'))
        body = [r for r in source.subs[f'Sub{root}'] if r.mask & 8]
        first = next(r.time for r in body if r.op in (91,92) and r.args[0] in targets)
        script,expected = None,[]
        for r in body:
            if r.time > first: break
            if r.op == 6 and r.args[0] == Variable(10000): script = r.args[1]
            if r.op in (91,92) and r.args[0] in targets:
                assert isinstance(script,int), (card,hex(r.address),'未解析ANM变量')
                expected.append(script)
        actual = plain(lua.globals().audit_wave(card,first+1))
        # 同帧新建的补充枪会继续生成对象；这里只核对主入口的第一批。
        actual = [row for row in actual if row[0] in {file+':'+str(n) for n in targets}]
        eq(len(actual)>=len(expected),True,(card,'第一批对象完整'))
        for i, (row,script) in enumerate(zip(actual,expected)):
            eq(row[1:3],['enemy',script],(card,i,'继承li0选择主ANM'))

    source = Source(Path('E:/workspace/.bossrush-validation/original-anm/ecl/8/ecldata4b.decl'),
                    Path('E:/workspace/原作/ECL/th08/ecldata4b.ecl'))
    for card,sub,initial,begin,losses in [(443,19,5,60,{120,1200}),
                                       (449,34,10,120,{960,1200})]:
        alive=initial
        trace=ScalarTrace(source,f'Sub{sub}',{10000:69},
                          external=lambda index,frame: alive if index==10096 else 0,effects=(92,))
        expected=[]
        for t in range(1441):
            if t in losses: alive-=1
            before=len(trace.events);trace.tick()
            for event in trace.events[before:]:
                if event['op']==92:
                    expected.append([t,trace.variables[10001],trace.variables[10000]])
                    alive+=1
        actual=plain(lua.globals().audit_wave(card,1440+begin,
                                             lua.table_from({t+begin:True for t in losses})))
        eq([[r[3]-begin,r[4],r[2]] for r in actual[initial:]],expected,
           (card,'有击破和无击破条件下，跨两轮的补充时刻、弹色及ANM'))

    # 独立记录 GameManager.cpp:132 的四个边界，使用原作ANM而非受击框。
    lua.execute('''
        local M=_editor_class.TH31.th08_combat
        audit_bounds={}
        for _,key in ipairs({'ecldata5sp:42','ecldata4b:70'}) do
            local o={x=0,y=0,ani=0,a=1,b=2,hscale=9,vscale=.1}
            OriginalStageVisual.bind_source(o,8,key)
            local vm=o._original_actor.vm
            local spr=vm.data.sprites[vm.sprite]
            local w,h=spr[4]/2,spr[5]/2
            local positions={{-192-w,0},{-192-w-.01,0},{192+w,0},{192+w+.01,0},
                {0,-224-h},{0,-224-h-.01},{0,224+h},{0,224+h+.01}}
            for _,p in ipairs(positions) do
                audit_bounds[#audit_bounds+1]=M.actor_outside(o,p[1],p[2])
            end
        end
        -- 弹跳使魔必须能经过顶边和侧边外侧，再由原作480下边界解除ALLOW_OFFSCREEN。
        function audit_find(root,key)
            local seen={}
            local function walk(v)
                if (type(v)~='table' and type(v)~='function') or seen[v] then return end
                seen[v]=true
                if type(v)=='function' then
                    for i=1,100 do local name,u=debug.getupvalue(v,i);if not name then break end
                        if name==key then return u end
                        -- 只沿本卡行为闭包；M/class里会连到别的卡和上一轮Boss，
                        -- 遍历整个对象图会碰巧取到另一个同名familiar。
                        if type(u)=='function' or name=='impl' or name=='opt' or name=='cfg' then
                            local r=walk(u);if r then return r end
                        end
                    end
                else for _,u in pairs(v) do if type(u)=='function' then
                    local r=walk(u);if r then return r end
                end end end
            end
            return assert(walk(root),key)
        end
        audit_bounce={}
        for _,cfg in ipairs({{433,'familiar','fam_thx','fam_thy','fam_t'},
                {435,'familiar20','fm_thx','fm_thy','fm_t'},
                {438,'familiar38','fm_thx','fm_thy','fm_t'},
                {439,'familiar','fm_thx','fm_thy','fm_t'}}) do
            local cls=audit_find(audit_cards[cfg[1]],cfg[2])
            local boss={x=0,y=96,timer=0,ani=0}
            audit_cards[cfg[1]].init(boss)
            local o=New(cls,0,96,-math.pi/2,2)
            o[cfg[3]],o[cfg[4]],o[cfg[5]]=192,-40,1
            cls.frame(o)
            audit_bounce[#audit_bounce+1]=IsValid(o)
            o[cfg[3]],o[cfg[4]],o[cfg[5]]=192,480,2
            cls.frame(o)
            audit_bounce[#audit_bounce+1]=IsValid(o)
            audit_cards[cfg[1]].del(boss)
        end
    ''')
    eq(plain(lua.globals().audit_bounds),[False,True]*8,'包含边界本身，忽略受击框和绘制缩放')
    eq(plain(lua.globals().audit_bounce),[True,False]*4,'原作ExIns2解除允许出屏的时机')
    lua.execute('''
        audit_fan={}
        local c=audit_cards[466]
        local fan=audit_find(c,'SUB466')[4][2]
        local ex=audit_find(c,'EX')
        local original=ex.shoot
        local shots=0
        ex.shoot=function() shots=shots+1 end
        for n=0,4 do
            local b={x=0,y=96,timer=0,ani=0};c.init(b)
            for i=1,n do b.c466_hawks[i]={_live=true} end
            b.c466_hawks[#b.c466_hawks+1]={_live=true,th08_dead=true}
            b.c466_hawks[#b.c466_hawks+1]={_live=false}
            shots=0;fan(b,{})
            audit_fan[#audit_fan+1]=shots
            c.del(b)
        end
        ex.shoot=original
    ''')
    mistia=Source(Path('E:/workspace/.bossrush-validation/original-anm/ecl/8/ecldata2.decl'),
                  Path('E:/workspace/原作/ECL/th08/ecldata2.ecl'))
    condition=next(r for r in mistia.subs['Sub44'] if r.op==50 and r.args[0]==Variable(10096))
    eq(plain(lua.globals().audit_fan),[int(n<condition.args[1]) for n in range(5)],
       '米斯蒂娅Sub44按存活附着链数量决定本体是否发弹')
    print(f'原作使魔独立回归通过：{len(cases)}个入口，{count}项比较；覆盖ANM第一批继承、出屏边界、附着链数量分支及两轮补充，不代表整卡通过。')


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    check()
