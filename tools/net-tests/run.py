#!/usr/bin/env python3
"""真实 TCP、房间验证、双向输入、中继、重连与 Windows LuaJIT 回归。"""
from pathlib import Path
import argparse
import base64
import http.client
import json
import os
import socket
import subprocess
import tempfile
import time

ROOT=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--windows-pc',action='store_true')
args=parser.parse_args()
env=dict(os.environ,WINEPREFIX=str(ROOT/'android/build/save-tests/wine'),WINEDEBUG='-all',MVK_CONFIG_LOG_LEVEL='0')
def command(script,folder,windows=False,*extra):
    if windows:
        win=lambda p:'Z:'+str(p).replace('/','\\')
        return ['wine',str(ROOT/'android/build/save-tests/LuaJIT-win/src/luajit.exe'),win(ROOT/script),win(ROOT),win(folder),*extra]
    return ['luajit',str(ROOT/script),str(ROOT),str(folder),*extra]
def wait(fn,seconds=15):
    end=time.monotonic()+seconds
    while time.monotonic()<end:
        try:
            v=fn()
            if v:return v
        except (FileNotFoundError,json.JSONDecodeError,ConnectionError):pass
        time.sleep(.03)
    raise AssertionError('等待联机状态超时')
def port():
    with socket.socket() as s:s.bind(('127.0.0.1',0));return s.getsockname()[1]
def api(peer,path,body=None,expected=200):
    c=http.client.HTTPConnection('127.0.0.1',peer['port'],timeout=5)
    c.request('GET' if body is None else 'POST',path,None if body is None else json.dumps(body),{'Authorization':'Bearer '+peer['token'],'Content-Type':'application/json'})
    r=c.getresponse();data=json.loads(r.read());c.close();assert r.status==expected,(r.status,data);return data
def status(p):return api(p,'/api/coop/status')
count=0
def check(v,label):
    global count
    assert v,label
    count+=1
with tempfile.TemporaryDirectory(prefix='bossrush-net-tests-') as temp:
    temp=Path(temp)
    for windows in ([False,True] if args.windows_pc else [False]):
        folder=temp/('unit-win' if windows else 'unit-mac');folder.mkdir()
        subprocess.run(command('tools/net-tests/unit.lua',folder,windows),env=env,check=True)
    processes=[];logs=[]
    try:
        peers=[]
        for i in range(3):
            folder=temp/str(i);folder.mkdir();log=(folder/'process.log').open('wb');logs.append(log)
            proc=subprocess.Popen(command('tools/net-tests/peer.lua',folder,args.windows_pc and i==0,*(('b',) if i==2 else ())),env=env,stdout=log,stderr=log);processes.append(proc)
            peers.append(wait(lambda:json.loads((folder/'peer.json').read_text())))
        host,guest,bad=peers
        for transport in ['direct','relay']:
            relay=None;options={'hero':'reimu_player','mode':'dual','port':port(),'address':'127.0.0.1'}
            if transport=='relay':
                relay=subprocess.Popen(['node',str(ROOT/'tools/relay/server.cjs')],env=dict(os.environ,PORT='0',BIND='127.0.0.1'),stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True);processes.append(relay)
                address=json.loads(relay.stdout.readline());options['relay']='127.0.0.1:'+str(address['port'])
            code=api(host,'/api/coop/host',options)['code']
            check(code.startswith('BRM1.'),'生成房间口令')
            api(bad,'/api/coop/join',{'code':code})
            wait(lambda:status(bad)['phase']=='disconnected')
            check(not status(host)['connected'],'拒绝游戏内容不匹配的设备')
            api(bad,'/api/coop/leave',{})
            # 错误房间密钥不能加入，直连与中继都校验。
            decoded=json.loads(base64.urlsafe_b64decode(code[5:]+'==='));decoded['key']='x'*32
            wrong='BRM1.'+base64.urlsafe_b64encode(json.dumps(decoded,separators=(',',':')).encode()).decode().rstrip('=')
            api(guest,'/api/coop/join',{'code':wrong})
            wait(lambda:status(guest)['phase']=='disconnected')
            check(not status(host)['connected'],'拒绝错误密钥')
            api(guest,'/api/coop/leave',{})
            api(guest,'/api/coop/join',{'code':code,'hero':'reimu_player'})
            wait(lambda:status(host)['ready'] and status(guest)['connected'])
            check(True,transport+'握手与准备')
            api(host,'/api/coop/start',{})
            wait(lambda:status(guest)['frames']>3)
            check(status(guest)['match'],'开始后真实 TCP 接收二进制画面')
            (temp/'1/keys.json').write_text(json.dumps({'mask':8+32}))
            wait(lambda:wait(lambda:json.loads((temp/'0/status.json').read_text()))['inputs'][1].get('right'))
            check(True,'客机独立方向和射击输入到达房主')
            api(guest,'/api/coop/pause',{'value':True})
            wait(lambda:status(host)['paused'][1])
            tick=wait(lambda:(v if v['paused'][1] else None) if (v:=json.loads((temp/'0/status.json').read_text())) else None)['tick'];time.sleep(.15)
            check(wait(lambda:json.loads((temp/'0/status.json').read_text()))['tick']==tick,'任一方暂停时战斗停止')
            api(guest,'/api/coop/pause',{'value':False})
            wait(lambda:wait(lambda:json.loads((temp/'0/status.json').read_text()))['tick']>tick)
            api(guest,'/api/coop/leave',{})
            wait(lambda:not status(host)['connected'])
            time.sleep(.05);tick=wait(lambda:json.loads((temp/'0/status.json').read_text()))['tick'];time.sleep(.15)
            check(wait(lambda:json.loads((temp/'0/status.json').read_text()))['tick']==tick,'断线后房主暂停')
            api(guest,'/api/coop/join',{'code':code,'hero':'reimu_player'})
            wait(lambda:status(guest)['frames']>3 and status(host)['ready'])
            check(wait(lambda:json.loads((temp/'0/status.json').read_text()))['tick']>tick,'原房间重连并继续')
            api(guest,'/api/coop/leave',{});api(host,'/api/coop/leave',{})
            if relay:relay.terminate();relay.wait(timeout=5)
        reuse={'hero':'reimu_player','mode':'dual','port':port(),'address':'127.0.0.1'}
        invite=api(host,'/api/coop/host',reuse)['code'];api(guest,'/api/coop/join',{'code':invite})
        wait(lambda:status(host)['ready']);api(host,'/api/coop/leave',{})
        wait(lambda:not status(guest)['connected'])
        check(api(host,'/api/coop/host',reuse)['phase']=='hosting','房主主动离开后立即复用同一监听端口')
        api(guest,'/api/coop/leave',{});api(host,'/api/coop/leave',{})
        print(f'真实联机回归通过：{count} 项（直连、中继、密钥/版本校验、暂停、断线、重连）'+('；房主为 Windows x64 LuaJIT / Wine。' if args.windows_pc else '。'))
    except BaseException:
        for folder in temp.iterdir():
            if folder.is_dir() and (folder/'process.log').exists():print(folder.name,(folder/'process.log').read_text(errors='replace')[-4000:])
        raise
    finally:
        for p in processes:
            if p.poll() is None:p.terminate()
        for p in processes:
            try:p.wait(timeout=5)
            except subprocess.TimeoutExpired:p.kill();p.wait()
        for log in logs:log.close()
