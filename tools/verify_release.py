#!/usr/bin/env python3
"""逐文件核对三端安装包与已提交源码快照；WAV 仅忽略容器元数据，比较 PCM 样本。"""
from pathlib import Path
import argparse,hashlib,io,json,wave,zipfile

GAME_PATHS=('THlib','Resources','mod','music','BadApple','shader','core.lua','launch','launch.lua','manual','Update.txt')

def same(source,packed):
    if source.suffix=='.lua':return source.read_text(encoding='utf-8-sig')==packed.decode('utf-8-sig').replace('\r\n','\n').replace('\r','\n')
    if source.suffix.lower()=='.wav':
        with wave.open(str(source),'rb') as a,wave.open(io.BytesIO(packed),'rb') as b:
            return a.getparams()==b.getparams() and a.readframes(a.getnframes())==b.readframes(b.getnframes())
    return source.read_bytes()==packed

def inputs(root):
    result=[]
    for name in GAME_PATHS:
        path=root/name
        for p in sorted(path.rglob('*')) if path.is_dir() else [path]:
            if p.is_file() and not p.name.startswith('.') and p.suffix not in {'.bak','.orig','.bakpool'}:result.append(p)
    return result

def verify(path,root,kind):
    # ditto 的 ZIP 保留 UTF-8 名字但不总置 UTF-8 标志；显式解码，避免中文资源被当作 CP437。
    with zipfile.ZipFile(path,metadata_encoding='utf-8') as archive:
        assert archive.testzip() is None,('CRC 失败',path)
        names=archive.namelist()
        assert not any('/User/' in '/'+n or '/replay/' in '/'+n for n in names),('混入用户数据',path)
        if kind=='windows':prefix=next(n[:-len('core.lua')] for n in names if n.endswith('/core.lua'))
        elif kind=='android':prefix='assets/game/'
        else:prefix=next(n[:-len('core.lua')] for n in names if n.endswith('/Contents/Resources/game/core.lua'))
        count=0
        for source in inputs(root):
            relative=source.relative_to(root).as_posix()
            # Android/Mac 的入口由各自移植层提供，Windows 的 launch 不是 Lua 资源清单成员。
            if kind!='windows' and relative=='launch':continue
            name=prefix+relative
            assert name in names,('缺少资源',kind,relative)
            assert same(source,archive.read(name)),('与提交快照不一致',kind,relative)
            count+=1
        if kind=='windows':assert prefix+'LuaSTGSub.exe' in names
        if kind=='android':
            assert 'lib/arm64-v8a/libcocos2dlua.so' in names
            for source in (root/'android/lua').rglob('*.lua'):
                assert same(source,archive.read(prefix+'android/'+source.relative_to(root/'android/lua').as_posix()))
        if kind=='mac':
            assert any(n.endswith('/Contents/MacOS/BossRushHD') for n in names)
            for source in (root/'macos/lua').rglob('*.lua'):
                assert same(source,archive.read(prefix+'macos/'+source.relative_to(root/'macos/lua').as_posix()))
        return {'file':path.name,'bytes':path.stat().st_size,'sha256':hashlib.file_digest(path.open('rb'),'sha256').hexdigest(),'game_files_compared':count,'crc':True,'source_matches':True,'user_data_excluded':True}

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source',type=Path,required=True);p.add_argument('--commit',required=True)
    for platform in ('windows','android','mac'):p.add_argument('--'+platform,type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);args=p.parse_args()
    report={'commit':args.commit,'platforms':{}}
    for platform in ('windows','android','mac'):
        report['platforms'][platform]=verify(getattr(args,platform),args.source,platform)
        print(platform+'：CRC、全部游戏文件、源码及用户数据排除校验通过',flush=True)
    args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
if __name__=='__main__':main()
