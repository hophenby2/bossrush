"""用TH06原始发弹操作数和C++公式核对TH32的出生方向；参照端不调用游戏几何函数。

覆盖九种发弹方式、float32的±π边界、跨边界随机区间，以及全部七面静态发弹入口。
运行：python tools/th32-tests/check_shot_angles.py E:/workspace/原作/ECL/th06
"""
import argparse
import json
import math
from pathlib import Path
import struct

from lupa.luajit21 import LuaRuntime
from source import Source


def f32(x):
    return struct.unpack('<f', struct.pack('<f', x))[0]


PI = f32(math.pi)
TAU = f32(PI * 2)


def normalize(a):
    # Global.cpp:1201的ZUN_PI/ZUN_2PI均为单精度，等号处不会换边。
    a = f32(a)
    while a > PI: a = f32(a - TAU)
    while a < -PI: a = f32(a + TAU)
    return a


def expected(mode, n, layers, v1, v2, a, step, u):
    # EclManager.cpp:423只归一化angle1；BulletManager.cpp:138–193再算各弹。
    a = normalize(a)
    aim = math.atan2(286, 52) if mode in (1, 3, 5) else 0
    v1, v2 = max(.3, v1) if v1 else 0, max(.3, v2)
    rows = []
    for layer in range(layers):
        for index in range(n):
            speed = v1 - (v1-v2)*layer/layers
            if mode in (1, 2):
                offset = ((index+1)//2)*step if n%2 else (index//2+.5)*step
                angle = a+aim+(-offset if index%2 else offset)
            elif mode in (3, 4, 8): angle = aim+index*TAU/n+layer*step+a
            elif mode in (5, 6): angle = aim+PI/n+index*TAU/n+a
            else: angle = step+u*(a-step)
            if mode in (8, 9): speed = v2+u*(v1-v2)
            angle = normalize(angle)
            rows.append([angle, math.cos(angle)*speed, -math.sin(angle)*speed])
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('data', type=Path)
    parser.add_argument('--report', type=Path)
    parser.add_argument('--allow-failures', action='store_true', help='仅保存修复前故障证据')
    args = parser.parse_args()
    source = Source(args.data)
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.globals().arg = lua.table_from(['shot-angle-audit'])
    setup = Path('tools/th32-tests/native.lua').read_text('utf-8').split("if mode=='program' then", 1)[0]
    lua.execute(setup + '''
        local ffi=require('ffi');local f=ffi.new('float[1]')
        local function f32(x)f[0]=x;return tonumber(f[0])end
        local function up(fn,wanted)
            for i=1,100 do local k,v=debug.getupvalue(fn,i);if not k then break end
                if k==wanted then return v end
            end
            error(wanted)
        end
        local H
        for _,entry in ipairs(cards) do
            if entry.card.th06_source then H=up(entry.card.init,'H');break end
        end
        audit_normal=up(H.pattern,'normal_angle')
        function audit_pattern(mode,sprite,n,l,v1,v2,a,step,u)
            objects={}
            -- 与真实Sub引擎相同：参数先转float32，倒置端点会被交换。
            ran.Float=function(_,lo,hi)
                lo,hi=f32(lo),f32(hi)
                if lo>hi then lo,hi=hi,lo end
                return f32(lo+(hi-lo)*u)
            end
            local s={pool={},next_slot=1,actors={},rank_speed=0,lasers={}}
            local b={x=12,y=110,hp=1000,maxhp=1000,_live=true}
            local actor=H.new_actor(s,b,3,33,true,{epoch=0,threshold=0})
            actor.rank_lo,actor.rank_hi=0,0
            actor.extra={99999,1,0,0,0,0,0,0}
            player.x,player.y=64,-176
            H.pattern(b,mode,sprite,0,n,l,v1,v2,a,step,0)
            local out={}
            for _,p in ipairs(s.pool)do out[#out+1]={p.th06_angle,p.vx,p.vy} end
            return out
        end
    ''')
    failures, checks, scanned = [], 0, 0
    affected = {}

    def compare(actual, wanted, where, angular=False):
        nonlocal checks
        checks += 1
        delta = actual-wanted
        if angular: delta = math.remainder(delta, math.tau)
        if abs(delta) > 3e-6:
            if len(failures) < 25: failures.append(dict(where=where, actual=actual, expected=wanted))
            return False
        return True

    for a in (PI,-PI,f32(PI+2**-22),f32(-PI-2**-22),f32(3*PI),f32(-3*PI)):
        compare(lua.globals().audit_normal(a), normalize(a), ['归一化',a])

    def wave(mode,sprite,n,l,v1,v2,a,step,where):
        ok = True
        for u in (0,.125,.5,.875):
            actual=lua.globals().audit_pattern(mode,sprite,n,l,v1,v2,a,step,u)
            wanted=expected(mode,n,l,v1,v2,a,step,u)
            assert len(actual)==len(wanted),(where,len(actual),len(wanted))
            for i,row in enumerate(wanted):
                for k,value in enumerate(row):
                    ok=compare(actual[i+1][k+1],value,[*where,u,i,k],k==0) and ok
        return ok

    for mode in range(1,10):
        for a,step in ((PI,-PI),(-PI,PI),(f32(.7),f32(-.3)),(f32(-.7),f32(.3))):
            wave(mode,2,6,2,2,.4,a,step,['发弹方式',mode,a,step])

    for stage, subs in source.stages.items():
        for sub in subs:
            for r in source.active(stage,sub):
                if not 67<=r['op']<=75: continue
                scanned += 1
                sprite,c,n,l,v1,v2,a,step,flags=r['a']
                # 动态寄存器在整卡控制流对照中检查；此处只验证可独立求值的发射几何。
                if any(-10025<=v<=-10001 for v in (sprite,v1,v2,a,step)): continue
                n=n if n>0 else 6
                l=l if l>0 else 2
                # 保留原作层数；池满截断由已有原生流程测试验证。
                if n*l>640: continue
                if not wave(r['op']-66,sprite,n,l,v1,v2,a,step,[stage,sub,hex(r['pos'])]):
                    affected.setdefault(stage,set()).add(sub)

    result=dict(checks=checks, raw_shooters_scanned=scanned,
        failures=failures, affected_subs={k:sorted(v) for k,v in affected.items()},
        scope='出生角度与速度；动态控制流、后续运动、碰撞和渲染另行测试')
    if args.report: args.report.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n','utf-8')
    print(json.dumps({k:result[k] for k in ('checks','raw_shooters_scanned','affected_subs')},ensure_ascii=False))
    if failures:
        print('不一致示例：',json.dumps(failures[:2],ensure_ascii=False))
        if not args.allow_failures: raise SystemExit(1)
    else: print('全部出生方向与原作公式相符')


if __name__=='__main__':
    main()
