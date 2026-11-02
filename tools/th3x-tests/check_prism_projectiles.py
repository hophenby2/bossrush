"""从新增六段原始ECL收集命令，逐帧核对真实TH34_cmdbullet的坐标、速度与弹雾。

参照公式来自TH07 BulletManager.cpp:352–441、759–872、1080–1102。
只隔离弹体运动；碰撞和回收由其他检查负责，不把未执行的部分算通过。
"""
import math
from pathlib import Path
import sys

from card_catalogue import runtime, plain
from check_prism_nonspell_sources import Reference
from ecl_source import Source, f32


def reference(speed, angle, flags, command, frames):
    x,y=192.,112.
    angle,speed=f32(angle),f32(speed)
    vx,vy=f32(math.cos(angle)*speed),f32(math.sin(angle)*speed)
    spawn=10 if flags&2 else 0
    if spawn:x,y=f32(x-vx*4),f32(y-vy*4)
    state,timer,done=(command[0] if command and flags&command[0] else 0),0,0
    result=[]
    for frame in range(frames):
        px,py=f32(240+30*math.sin(frame/31)),f32(400-20*math.cos(frame/23))
        extra_x=extra_y=0
        if spawn:
            x,y=f32(x+vx/2),f32(y+vy/2)
            spawn-=1
            extra_x,extra_y=vx/2,vy/2
        if not spawn:
            if state==32:
                if timer>=command[2]:state=0
                else:
                    angle=f32(angle+command[5]);speed=f32(speed+command[4])
                    vx,vy=f32(math.cos(angle)*speed),f32(math.sin(angle)*speed)
                timer+=1
            elif state in (64,128):
                if timer>=command[2]:
                    done+=1
                    if done>=command[3]:state=0
                    angle=f32((math.atan2(py-y,px-x) if command[0]==128 else angle)+command[4])
                    speed=command[5];v=speed;timer=0
                else:v=f32(speed-f32(f32(timer*speed)/command[2]))
                vx,vy=f32(math.cos(angle)*v),f32(math.sin(angle)*v)
                timer+=1
            x,y=f32(x+vx),f32(y+vy)
            dx,dy=vx+extra_x,vy+extra_y
        else:dx,dy=extra_x,extra_y
        result.append([x,y,dx,dy,spawn])
    return result


def check():
    source=Source(Path('E:/workspace/.bossrush-validation/original-anm/ecl/7/ecldata4.decl'),
                  Path('E:/workspace/原作/ECL/th07/ecldata4.ecl'),7)
    commands=set()
    for sub in (64,68,80,83,98,103):
        ref=Reference(source,f'Sub{sub}',16)
        for _ in range(3600):ref.tick()
        for e in ref.events:
            if e[1]=='shoot':commands.add((e[7],e[11],tuple(e[12])))
    lua=runtime()
    lua.execute('''
        dofile('mod/GAME/th34.lua')
        local ffi=require('ffi');local f=ffi.new('float[1]')
        local function f32(x) f[0]=x;return tonumber(f[0]) end
        function audit_projectile(speed,flags,cmd,frames)
            -- 本测试隔离运动，关闭回收，免得轨迹测量被删除对象打断。
            OriginalBulletVisual.th07_cull=function()end
            local c=_editor_class.TH34.TH34_cmdbullet
            local list={}
            if #cmd>0 then
                list[1]={type=cmd[1],flag=cmd[2],dur=cmd[3],loop=cmd[4],
                    speed=cmd[1]==32 and cmd[5] or cmd[6],
                    angle=-(cmd[1]==32 and cmd[6] or cmd[5])*180/math.pi}
            end
            local o={x=0,y=112,rot=0,timer=0,ani=0,_live=true}
            c.init(o,ball_mid,2,0,112,speed,-f32(.731)*180/math.pi,{list=list,flags=flags})
            local rows={}
            for t=0,frames-1 do
                player.x=f32(240+30*math.sin(t/31))-192
                player.y=224-f32(400-20*math.cos(t/23))
                c.frame(o)
                o.x,o.y=o.x+o.vx,o.y+o.vy
                rows[#rows+1]={o.x+192,224-o.y,o.vx,-o.vy,o.c_spawn_left}
                o.timer,o.ani=o.timer+1,o.ani+1
            end
            return rows
        end
    ''')
    count,max_error=0,0
    for speed,flags,cmd in sorted(commands):
        expected=reference(speed,.731,flags,cmd,181)
        actual=plain(lua.globals().audit_projectile(speed,flags,lua.table_from(cmd),181))
        for frame,(aa,bb) in enumerate(zip(actual,expected)):
            for i,(a,b) in enumerate(zip(aa,bb)):
                error=abs(a-b);max_error=max(max_error,error)
                assert error<.003,(speed,flags,cmd,frame,i,a,b)
                count+=1
    print(f'{len(commands)}种原始发弹/命令组合，各181帧：{count}项通过，最大数值误差{max_error:.6f}px；碰撞/回收未纳入本测试。')


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    check()
