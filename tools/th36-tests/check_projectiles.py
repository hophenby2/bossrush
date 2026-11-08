"""按原PE发弹分派的数学契约检查九种枪、层相位、保护范围、出生期和递归占槽。"""
from pathlib import Path
import json
import math
import os
import struct
import sys
from run_lua import ROOT,runtime

F=lambda n:struct.unpack('<f',struct.pack('<f',n))[0]
PI=F(math.pi);TAU=F(2*math.pi)


def main():
    os.chdir(ROOT);lua=runtime();lua.globals().arg=lua.table_from(['发弹核对'])
    setup=(ROOT/'tools/check_stage.lua').read_text('utf-8-sig').split('if path == "--all" then',1)[0]
    lua.execute(setup);lua.execute("dofile('THlib/anm/original.lua');dofile('mod/GAME/th36.lua')")
    lua.execute('''
        H=_editor_class.TH36.runtime
        function pattern(mode,protect,dist)
            player.x,player.y=40,-76
            local s=H.session({_live=true},1,'main');s.random_seed=12345
            local p=s.root.guns[0]
            p.type,p.color,p.angle,p.step,p.s1,p.s2,p.n,p.layers,p.aim=0,0,.2,.1,3,1,3,2,mode
            if protect then p.angle,p.step,p.n,p.layers,p.aim,p.protect,p.dist=0,0,4,1,3,protect,dist end
            local out={};H.on_bullet=function(_,_,b) out[#out+1]={b.x,224-b.y,b.angle,b.speed,b.slot} end
            H.emit_pattern(s,p,0,300);H.on_bullet=nil
            return out
        end
        function nested()
            player.x,player.y=0,224
            local s=H.session({_live=true},1,'main');local p=s.root.guns[0]
            p.ex[0]={allow=1,kind=524288,i0=16777728,i1=1,f0=2,f1=0}
            p.ex[1]={allow=0,kind=1048576,i0=1,i1=0,f0=.2,f1=0}
            H.emit_pattern(s,p,0,300)
            assert(s.bullets[1] and s.bullets[2] and s.bullets[1]~=s.bullets[2],'出生分裂覆盖了父弹槽')
            assert(s.bullets[1].slot==1 and s.bullets[2].slot==2)
        end
        function birth()
            local s=H.session({_live=true},1,'main');local p=s.root.guns[0]
            p.aim,p.angle,p.s1=1,0,2;p.ex[0]={allow=1,kind=2,i0=0,i1=0,f0=0,f1=0}
            H.emit_pattern(s,p,0,300);local b=s.bullets[1];local out={}
            for i=1,8 do _editor_class.TH36.bullet.frame(b);out[i]=b.x end
            return out
        end
        function slow_cleanup()
            lstg.var.CYFPS=48
            local s=H.session({_live=true},1,'main')
            local node={_live=true};s.root.ring_nodes={node}
            H.time_scale(s.root,.25);assert(lstg.var.CYFPS==12 and s.rate==1)
            H.close(s);assert(lstg.var.CYFPS==48 and s.root.dead and not node._live and IsValid(s.host));lstg.var.CYFPS=nil
        end
        function timeout_result()
            local s=H.session({_live=true},1,'MBoss',{sub='MBoss',total_hp=100,hp=100,threshold=0})
            H.interrupt(s.root,0,0,10,'MBoss2');s.root.phase_time=10
            H.transition(s.root,false)
            assert(s.done and s.host.timeout and s.capture==0,'原作超时不能变成击破收卡')
            H.close(s)
        end
        function retained_death()
            local s=H.session({_live=true},1,'main');local a=s.root
            a.o.hp=0;H.interrupt(a,0,0,10,'MBoss2');H.transition(a,false)
            _editor_class.TH36.actor.kill(a.o);assert(not a.dead and a.transition_pending)
            a.flags=128;a.threads={{name='保留零血',co=coroutine.create(function() while true do coroutine.yield() end end)}}
            H.update(a);assert(not a.dead,'0x80应保留零血演员直到ECL自删');H.close(s)
            s=H.session({_live=true},1,'main');s.dialog=1;s.final_actor={o={_live=true}}
            local v={origin=0};local co=coroutine.create(function() H.dialog_wait(s.root,v) end)
            assert(coroutine.resume(co));assert(coroutine.status(co)=='suspended')
            s.final_actor.dead=true;s.final_dead=true;s.frame=10
            assert(coroutine.resume(co));assert(s.done and v.origin==10);H.close(s)
        end
        function phantom_blink()
            local s=H.session({_live=true},4,'main');local a=s.root
            H.actor_group(a,369,1);assert(require('bit').band(a.flags,0x8000000)~=0)
            H.actor_group(a,370,1);assert(a.actor_group==1)
            a.phase_time=0;a.threads={{name='闪烁',co=coroutine.create(function() while true do coroutine.yield() end end)}}
            H.update(a);assert(a.flash_magenta)
            s.frame=1;H.update(a);assert(not a.flash_magenta)
            H.actor_group(a,369,0);assert(require('bit').band(a.flags,0x8000000)==0);H.close(s)
        end
        function gravity_position()
            local s=H.session({_live=true},6,'main');local a=s.root
            a.o.x,a.o.y=0,0;a.vars[-9985]=1;H.callback(a,443,5)
            player.x,player.y=10,0;a.vars[-9978]=8;H.run_callback(a);assert(player.x==2 and player.y==0)
            player.x,player.y=10,0;a.vars[-9978]=-2;H.run_callback(a);assert(player.x==12)
            player.x,player.y=10,0;a.vars[-9978]=H.f32(.3);H.run_callback(a);assert(player.x==9.6953125)
            H.close(s);player.x,player.y=0,224
        end
    ''')
    checks=0
    for mode in range(9):
        rows=lua.globals().pattern(mode,None,None);seed=12345
        def random(lo,hi):
            nonlocal seed
            high=((seed^0x9630)-0x6553)&65535;seed=((high>>14)+(high<<2))&65535
            low=((seed^0x9630)-0x6553)&65535;seed=((low>>14)+(low<<2))&65535
            return F(lo+F((hi-lo)*F(F(high*65536+low)/4294967296)))
        aim=math.atan2(0,40)
        base=[0,-.1,.1] if mode<=1 else [0,TAU/3,TAU*2/3]
        for layer in range(2):
            for i in range(3):
                angle=.2;speed=3-layer
                if mode<=1:angle+=base[i]+(aim if mode==0 else 0)
                elif mode<=5:angle+=base[i]+layer*.1+(PI/3 if mode>=4 else 0)+(aim if mode in (2,4) else 0)
                elif mode==6:angle=random(.1,.2)
                elif mode==7:angle+=base[i]+layer*.1;speed=random(1,3)
                else:angle=random(.1,.2);speed=random(1,3)
                angle=F(angle)
                while angle>PI:angle=F(angle-TAU)
                while angle< -PI:angle=F(angle+TAU)
                actual=rows[layer*3+i+1]
                assert abs(actual[3]-angle)<2e-6 and abs(actual[4]-speed)<2e-6,(mode,layer,i,actual[3],angle)
                checks+=1
    assert len(lua.globals().pattern(3,20,40))==3,'原版出生点保护应拒绝一颗、保留其余三颗'
    lua.globals().nested();assert list(lua.globals().birth().values())==[-7,-6,-5,-4,-3,-2,-1,2]
    lua.globals().slow_cleanup()
    lua.globals().timeout_result()
    lua.globals().retained_death()
    lua.globals().phantom_blink()
    lua.globals().gravity_position()
    print(json.dumps(dict(pattern_bullets=checks,protected_spawn=True,recursive_slots=True,birth_frames=8,
        timeout_result=True,retained_death=True,global_slow_cleanup=True,phantom_blink=True,raw_gravity=True,
        scope='PE 0x408f20的发弹契约及对象生命周期；不替代全部变换的原版逐帧轨迹对照'),ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
