#!/usr/bin/env python3
"""只读提取栖霞园发行包通用 Boss 特效；密码仅在内存中从 EXE 生成，不写入源码。"""
import argparse
import hashlib
import hmac
import json
from pathlib import Path
import re
import struct
import sys
import zipfile
import zlib
sys.dont_write_bytecode=True

import capstone
from capstone import x86
from Crypto.Cipher import AES
from Crypto.Util import Counter
import pefile

ROOT=Path(__file__).resolve().parents[2]


def executable_key(path):
    """沿启动时 LoadArchive(data,0,password) 找到密码函数，解释其只读字节跳转表。"""
    data=path.read_bytes();pe=pefile.PE(data=data);base=pe.OPTIONAL_HEADER.ImageBase
    assert pe.FILE_HEADER.Machine==0x14c,'此提取器针对发行包的 x86 game.exe'
    text=next(s for s in pe.sections if s.Name.startswith(b'.text'))
    decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
    decoder.detail=True;decoder.skipdata=True
    code=list(decoder.disasm(text.get_data(),base+text.VirtualAddress))
    names={}
    for section in pe.sections:
        if not section.Name.startswith(b'.rdata'):continue
        start=section.PointerToRawData
        offset=data.find(b'data\0',start,start+section.SizeOfRawData)
        while offset!=-1:
            names[base+pe.get_rva_from_offset(offset)]='data'
            offset=data.find(b'data\0',offset+5,start+section.SizeOfRawData)
    getters=set()
    for i,ins in enumerate(code):
        if ins.mnemonic!='push' or not ins.operands or ins.operands[0].type!=x86.X86_OP_IMM:continue
        if ins.operands[0].imm not in names:continue
        if code[i-1].mnemonic!='push' or code[i-1].op_str!='0':continue
        previous=next((v for v in reversed(code[max(0,i-24):i]) if v.mnemonic=='call'),None)
        if previous and previous.operands[0].type==x86.X86_OP_IMM:getters.add(previous.operands[0].imm)
    assert len(getters)==1,('启动密码入口不匹配',len(getters))
    address=getters.pop();index=next(i for i,v in enumerate(code) if v.address==address)
    body=[]
    for ins in code[index:]:
        body.append(ins)
        if ins.mnemonic=='ret':break
        assert ins.address-address<4096,'密码函数超出预期范围'
    bound=next(v.operands[1].imm for i,v in enumerate(body[:-1])
        if v.mnemonic=='cmp' and v.op_str.startswith('edx, 0x') and body[i+1].mnemonic=='jb'
        and body[i+1].operands[0].imm<v.address)
    loads=[];immediates=[];source=None
    for ins in body:
        if ins.mnemonic=='.byte':continue
        a=ins.operands
        if ins.mnemonic=='cmp' and ins.op_str=='al, 0xff':break
        if ins.mnemonic=='movaps' and len(a)==2 and a[1].type==x86.X86_OP_MEM and a[1].mem.base==0:
            source=pe.get_offset_from_rva(a[1].mem.disp-base)
        elif ins.mnemonic=='movups' and len(a)==2 and a[0].type==x86.X86_OP_MEM and a[0].mem.base==x86.X86_REG_EBP and source is not None:
            loads.append((a[0].mem.disp,source));source=None
        elif ins.mnemonic=='mov' and len(a)==2 and a[0].type==x86.X86_OP_MEM and a[0].mem.base==x86.X86_REG_EBP and a[1].type==x86.X86_OP_IMM:
            immediates.append((a[0].mem.disp,a[0].size,a[1].imm))
    beginning=min(dst for dst,_ in loads);table=bytearray(bound);filled=set()
    for dst,offset in loads:
        at=dst-beginning
        assert 0<=at<=bound-16
        table[at:at+16]=data[offset:offset+16];filled.update(range(at,at+16))
    for dst,size,value in immediates:
        at=dst-beginning
        if 0<=at<=bound-size:
            table[at:at+size]=(value&((1<<(8*size))-1)).to_bytes(size,'little');filled.update(range(at,at+size))
    assert len(filled)==bound,'密码表未完整恢复'
    key=bytearray();at=0;seen=set()
    while at<bound and table[at]!=255:
        assert at not in seen,'密码跳转表存在循环'
        seen.add(at);step=table[at];at+=step if step<128 else step-256
        assert 0<=at<bound
        key.append(table[at]);at+=1
    assert key and 0 not in key
    return bytes(key),dict(exe_sha256=hashlib.sha256(data).hexdigest(),getter_rva=address-base,
                          table_bytes=bound,key_bytes=len(key))


class Archive:
    def __init__(self,path,password):
        self.path,self.password=path,password
        self.zip=zipfile.ZipFile(path)
        self.file=path.open('rb')

    def read(self,name):
        info=self.zip.getinfo(name)
        if not info.flag_bits&1:return self.zip.read(info)
        assert info.compress_type==99,'发行包加密方式已改变'
        self.file.seek(info.header_offset)
        header=self.file.read(30);n,e=struct.unpack_from('<HH',header,26)
        self.file.seek(n+e,1);raw=self.file.read(info.compress_size)
        at=0;aes=None
        while at<len(info.extra):
            tag,size=struct.unpack_from('<HH',info.extra,at)
            if tag==0x9901:aes=struct.unpack_from('<H2sBH',info.extra,at+4)
            at+=4+size
        assert aes and aes[1]==b'AE'
        version,_,strength,method=aes;length={1:16,2:24,3:32}[strength];salt=length//2
        derived=hashlib.pbkdf2_hmac('sha1',self.password,raw[:salt],1000,length*2+2)
        assert hmac.compare_digest(derived[-2:],raw[salt:salt+2]),'发行包密码校验失败'
        encrypted=raw[salt+2:-10]
        assert hmac.compare_digest(hmac.new(derived[length:length*2],encrypted,hashlib.sha1).digest()[:10],raw[-10:]),'发行包 HMAC 校验失败'
        data=AES.new(derived[:length],AES.MODE_CTR,counter=Counter.new(128,initial_value=1,little_endian=True)).decrypt(encrypted)
        if method==8:data=zlib.decompress(data,-15)
        else:assert method==0,method
        assert len(data)==info.file_size and (not info.CRC or zlib.crc32(data)==info.CRC),name
        return data


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--game',type=Path,required=True)
    args=ap.parse_args();game=args.game.resolve()
    key,origin=executable_key(game/'game.exe');archive=Archive(game/'data',key)
    source='EISlib/boss/common/boss_class.lua';raw=archive.read(source)
    text=raw.decode('utf-8-sig').replace('\r\n','\n');start=text.index('--- 默认的开卡演出');end=text.index('--endregion',start)
    fragment='\n'.join(line.rstrip() for line in text[start:end].splitlines())+'\n'
    result='-- 发行包原始通用特效回调，由 tools/th43-tests/export_release_effects.py 提取。\n'+fragment
    target=ROOT/'mod/GAME/th43/source/EISlib/boss/common/default_effects.lua'
    target.parent.mkdir(parents=True,exist_ok=True);target.write_text(result,encoding='utf8',newline='\n')
    checked={}
    for name in ['EISlib/EGGlib/RenderEffect.lua','EISlib/boss/boss_type.lua',
                 *['EISlib/boss/definition/'+p.name for p in sorted((ROOT/'mod/GAME/th43/source/EISlib/boss/definition').glob('*.lua'))]]:
        actual=archive.read(name);existing=(ROOT/'mod/GAME/th43/source'/name).read_bytes()
        normalize=lambda v:v.decode('utf-8-sig').replace('\r\n','\n')
        assert normalize(actual)==normalize(existing),'原特效依赖版本不一致：'+name
        checked[name]=hashlib.sha256(actual).hexdigest()
    assets={};system=Archive(game/'system.res',key)
    for name in ['item_eff','Cherry_eff','circle_eff','boss_aura']:
        entry='res/effect/'+name+'.png';data=system.read(entry)
        target_asset=ROOT/'Resources/th43/effect'/(name+'.png')
        assert data==target_asset.read_bytes(),'特效原图版本不一致：'+entry
        assets[entry]=hashlib.sha256(data).hexdigest()
    boss_card='EISlib/EGGlib/BossCard.lua'
    checked[boss_card]=hashlib.sha256(archive.read(boss_card)).hexdigest()
    sound=Archive(game/'sound.res',key)
    sound_info=sound.read('res/soundeffect/soundeffect.info')
    rows={};wave_hashes={};imported,updated=0,0
    sound_rows=re.findall(r'\{\s*name\s*=\s*"([^"]+)"\s*,\s*filename\s*=\s*"([^"]+)"\s*,\s*volume\s*=\s*([\d.]+)',sound_info.decode('utf-8-sig'))
    assert len(sound_rows)==85,'音效注册表结构已改变'
    for name,filename,volume in sound_rows:
        assert Path(filename).name==filename
        data=sound.read('res/soundeffect/'+filename)
        destination=ROOT/'Resources/th43/soundeffect'/filename
        previous=destination.read_bytes() if destination.exists() else None
        if previous!=data:
            temp=destination.with_suffix('.wav.source-tmp');temp.write_bytes(data);temp.replace(destination)
            if previous is None:imported+=1
            else:updated+=1
        rows[name]={'path':destination.relative_to(ROOT).as_posix(),'volume':float(volume)}
        wave_hashes[filename]=hashlib.sha256(data).hexdigest()
    lines=['-- 发行包 soundeffect.info 的原始名称映射和默认音量。','return {']
    for name,cue in rows.items():
        lines.append('['+json.dumps(name)+']={path='+json.dumps(cue['path'])+',volume='+repr(cue['volume'])+'},')
    lines.append('}')
    (ROOT/'mod/GAME/th43/release_sounds.lua').write_text('\n'.join(lines)+'\n',encoding='utf8',newline='\n')
    helper='EISlib/EGGlib/ObjectEvent.lua';upstream=archive.read(helper)
    local_helper=(ROOT/'mod/GAME/th43/source'/helper).read_bytes()
    adjusted=upstream.decode('utf-8-sig').replace('\r\n','\n')
    for before,after in [
        ('obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale','obj.a, obj.b = obj.a*math.abs(obj.hscale), obj.b*math.abs(obj.vscale)'),
        ('obj.a, obj.b = colli_a, colli_b','obj.a, obj.b = math.max(0,colli_a), math.max(0,colli_b)'),
        ('obj.a, obj.b = obj.a + dcolli_a, obj.b + dcolli_b','obj.a, obj.b = math.max(0,obj.a+dcolli_a), math.max(0,obj.b+dcolli_b)')]:
        assert adjusted.count(before)==1
        adjusted=adjusted.replace(before,after)
    assert adjusted==local_helper.decode('utf-8-sig').replace('\r\n','\n'),'特效运动助手存在未核对的差异'
    manifest=dict(origin=origin,archive_sha256=hashlib.sha256((game/'data').read_bytes()).hexdigest(),
        source=source,source_sha256=hashlib.sha256(raw).hexdigest(),output_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),
        checked_dependencies=checked,checked_assets=assets,
        sounds=dict(info_sha256=hashlib.sha256(sound_info).hexdigest(),archive_sha256=hashlib.sha256((game/'sound.res').read_bytes()).hexdigest(),
            entries=rows,wave_sha256=wave_hashes,semantics_source='src/basic/audio.lua',
            semantics_sha256=hashlib.sha256(archive.read('src/basic/audio.lua')).hexdigest()),
        checked_adapter={helper:dict(source_sha256=hashlib.sha256(upstream).hexdigest(),local_sha256=hashlib.sha256(local_helper).hexdigest(),
            differences='仅三处已有的判定尺寸非负适配；本次未修改运动函数')},
        authentication='WinZip AES 密码校验、HMAC、文件大小及非零 CRC')
    (ROOT/'mod/GAME/th43/release_effects_sources.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print('已补导通用 Boss 特效；核对',len(checked),'份脚本、85 个音效，新增',imported,'个、更新',updated,'个原波形；未保存密钥')


if __name__=='__main__':main()
