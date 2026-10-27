#!/usr/bin/env python3
"""正式 Lua HTTP/配对/导入协议的双进程回归；不访问真实 User 目录。"""
from pathlib import Path
import base64
import http.client
import json
import subprocess
import tempfile
import time
import os
import sys

ROOT = Path(__file__).resolve().parents[2]


def api(host, path, body=None, *, token=None, origin=None, expected=200):
    connection = http.client.HTTPConnection('127.0.0.1', host['port'], timeout=10)
    headers = {'Authorization': 'Bearer ' + (host['token'] if token is None else token), 'Content-Type': 'application/json'}
    if origin:
        headers['Origin'] = origin
    connection.request('POST' if body is not None else 'GET', path, None if body is None else json.dumps(body), headers)
    response = connection.getresponse()
    data = response.read()
    assert response.status == expected, (path, response.status, data[:200])
    connection.close()
    return json.loads(data) if data else None


def job(host, operation):
    for _ in range(150):
        value = api(host, '/api/job/' + operation['job'])
        if value['state'] == 'done':
            return value['result']
        assert value['state'] != 'error', value
        time.sleep(.02)
    raise AssertionError('网络传输超时')


def main():
    processes = []
    with tempfile.TemporaryDirectory(prefix='bossrush-two-devices-') as temporary:
        try:
            hosts = []
            for name in ['pc', 'mobile']:
                folder = Path(temporary) / name
                folder.mkdir()
                command=['luajit', str(ROOT / 'tools/save-tests/host.lua'), str(ROOT), str(folder)]
                environment=None
                if name=='pc' and '--windows-pc' in sys.argv:
                    win=lambda p:'Z:'+str(p).replace('/','\\')
                    command=['wine',str(ROOT/'android/build/save-tests/LuaJIT-win/src/luajit.exe'),win(ROOT/'tools/save-tests/host.lua'),win(ROOT),win(folder)]
                    environment=dict(os.environ,WINEPREFIX=str(ROOT/'android/build/save-tests/wine'),WINEDEBUG='-all',MVK_CONFIG_LOG_LEVEL='0')
                process = subprocess.Popen(command,env=environment,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                processes.append(process)
                for _ in range(1000):
                    if (folder / 'host.json').exists():
                        break
                    assert process.poll() is None, process.stderr.read().decode()
                    time.sleep(.02)
                hosts.append(json.loads((folder / 'host.json').read_text()))
            pc, mobile = hosts
            api(pc, '/api/status', token='wrong', expected=403)
            api(pc, '/api/status', origin='https://untrusted.invalid', expected=403)
            a = api(pc, '/api/create', {'name': 'PC 主存档'})['id']
            b = api(pc, '/api/create', {'name': 'PC 练习存档'})['id']
            bundle = api(pc, '/api/export', {'ids': [a, b], 'checkpoint': False})['token']
            preview = api(mobile, '/api/preview', {'token': bundle})
            assert len(preview['entries']) == 2
            result = api(mobile, '/api/import', {'pending': preview['pending'], 'selection': [2], 'policy': 'copy'})
            assert result['imported'] == 1
            profiles = api(mobile, '/api/status')['profiles']
            assert any(p['name'] == 'PC 练习存档' for p in profiles)
            assert not any(p['name'] == 'PC 主存档' for p in profiles)
            connection = job(mobile, api(mobile, '/api/pair', {'code': pc['code']}))
            assert len(connection['profiles']) == 3
            pulled = job(mobile, api(mobile, '/api/pull', {'ids': [a], 'checkpoint': False}))
            assert len(pulled['entries']) == 1
            result = api(mobile, '/api/import', {'pending': pulled['pending'], 'selection': [1], 'policy': 'copy'})
            assert result['imported'] == 1
            mobile_id = api(mobile, '/api/create', {'name': '移动端返回 PC'})['id']
            pushed = job(mobile, api(mobile, '/api/push', {'ids': [mobile_id], 'checkpoint': False}))
            result = api(pc, '/api/import', {'pending': pushed['pending'], 'selection': [1], 'policy': 'copy'})
            assert result['imported'] == 1
            assert any(p['name'] == '移动端返回 PC' for p in api(pc, '/api/status')['profiles'])
            # 同一份口令被篡改时，导入过程不改变索引。
            count = len(api(pc, '/api/status')['profiles'])
            api(pc, '/api/preview', {'token': bundle[:-1] + ('A' if bundle[-1] != 'A' else 'B')}, expected=400)
            assert len(api(pc, '/api/status')['profiles']) == count
            api(pc, '/api/renew', {})
            failed = api(mobile, '/api/remote', {})
            for _ in range(150):
                value = api(mobile, '/api/job/' + failed['job'])
                if value['state'] == 'error':
                    break
                time.sleep(.02)
            assert value['state'] == 'error', '过期配对码仍可使用'
            # 对方关闭配对后，旧密钥不能继续获取存档。
            raw = base64.urlsafe_b64decode(pc['code'][5:] + '==')
            peer_key = base64.urlsafe_b64encode(raw[6:]).decode().rstrip('=')
            api(pc, '/api/close', {})
            api(pc, '/peer/list', token=peer_key, expected=403)
            print(('Windows x64（Wine）↔ macOS：' if '--windows-pc' in sys.argv else '')+'双进程同步回归通过：口令多存档筛选、局域网拉取/推送、接收选择、权限、过期和损坏数据隔离。')
        finally:
            for process in processes:
                process.terminate()
            for process in processes:
                process.wait(timeout=5)


if __name__ == '__main__':
    main()
