#!/usr/bin/env python3
"""在主机编译实际WAV解码器，逐文件核对入包音效的格式、样本和seek；不创建音频设备。"""
from pathlib import Path
import os
import shutil
import struct
import subprocess
import wave

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / '.cache/LuaSTG-x/frameworks/Audio'
BUILD = ROOT / 'build/wav-check'
BUILD.mkdir(parents=True, exist_ok=True)
for name in ['AudioDecoderWav.cpp', 'AudioDecoderWav.h', 'NqrRiffUtils.cpp',
             'NqrRiffUtils.h', 'NqrCommon.cpp', 'NqrCommon.h', 'NqrDither.h']:
    shutil.copy2(SOURCE / name, BUILD / name)
# 只替代设备无关的引用计数、内存流与Decoder基类，解析和解码代码直接使用引擎源码。
(BUILD / 'AudioCommon.h').write_text('''#pragma once
#include <cassert>
#include <cstring>
#include <string>
#define CC_ASSERT assert
#define AINFO(...) ((void)0)
''')
(BUILD / 'AudioDecoder.h').write_text('''#pragma once
#include <cstdint>
#include <vector>
#include <cstring>
#include <algorithm>
namespace audio {
class Stream {
    std::vector<uint8_t> data; uint64_t position=0;
public:
    enum class SeekOrigin {BEGINNING, CURRENT, END};
    Stream(std::vector<uint8_t> value): data(std::move(value)) {}
    uint64_t size() {return data.size();}
    uint64_t tell() {return position;}
    bool seek(SeekOrigin origin, int64_t offset) {
        int64_t to=(origin==SeekOrigin::BEGINNING?0:origin==SeekOrigin::CURRENT?position:data.size())+offset;
        if(to<0 || uint64_t(to)>data.size()) return false;
        position=to;return true;
    }
    bool read(uint8_t* dst,uint64_t length,uint64_t* count=nullptr) {
        auto n=std::min(length,size()-position);memcpy(dst,data.data()+position,n);
        position+=n;if(count)*count=n;return true;
    }
    void lock() {} void unlock() {} void retain() {} void release() {}
};
class Decoder {
public:
    enum class DecoderType {WAV};
    virtual ~Decoder()=default;
    virtual int64_t decode(char*,uint64_t)=0;
    virtual bool seek(int64_t)=0;
    virtual int64_t tell()=0;
    virtual bool isSeekable()=0;
    void autorelease() {}
    int64_t getTotalFrames() const {return audioInfo.totalFrames;}
    int64_t getBytesPerFrame() const {return audioInfo.bytesPerFrame;}
    int64_t getSampleRate() const {return audioInfo.sampleRate;}
    int64_t getChannelCount() const {return audioInfo.channelCount;}
protected:
    Decoder(size_t,DecoderType) {}
    struct Info {int64_t totalFrames=0,bytesPerFrame=4,sampleRate=44100,channelCount=2;} audioInfo;
    Stream* stream=nullptr;bool eof=false;
};
}
''')
(BUILD / 'main.cpp').write_text('''#include "AudioDecoderWav.h"
#include <fstream>
#include <iostream>
#include <iterator>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif
int main(int argc,char** argv) {
    if(argc!=2)return 1;
    std::ifstream input(argv[1],std::ios::binary);
    std::vector<uint8_t> data((std::istreambuf_iterator<char>(input)),{});
    audio::Stream stream(std::move(data));
    auto* decoder=audio::DecoderWav::create(&stream,16384);
    if(!decoder)return 2;
    const uint64_t frames=decoder->getTotalFrames(), channels=decoder->getChannelCount();
    const uint64_t bytes=decoder->getBytesPerFrame();
    uint64_t info[]={uint64_t(decoder->getSampleRate()),channels,bytes/channels,frames};
    std::vector<char> pcm(frames*bytes);
    if(decoder->decode(pcm.data(),pcm.size())!=int64_t(pcm.size()) || decoder->tell()!=int64_t(frames))return 3;
    if(!decoder->seek(0) || decoder->tell()!=0)return 4;
    std::vector<char> first(std::min<size_t>(256,pcm.size()));
    if(decoder->decode(first.data(),first.size())!=int64_t(first.size()) || !std::equal(first.begin(),first.end(),pcm.begin()))return 5;
#ifdef _WIN32
    _setmode(_fileno(stdout),_O_BINARY);
#endif
    std::cout.write(reinterpret_cast<char*>(info),sizeof(info));
    std::cout.write(pcm.data(),pcm.size());
    delete static_cast<audio::Decoder*>(decoder);
}
''')
compiler = shutil.which('g++') or shutil.which('clang++')
if not compiler:
    raise RuntimeError('需要主机C++编译器g++或clang++')
exe = BUILD / ('check.exe' if os.name == 'nt' else 'check')
command = [compiler, '-std=c++17', '-O2', '-include', 'cstring']
if os.name == 'nt':
    command += ['-static', '-fno-use-linker-plugin']
subprocess.run(command + ['AudioDecoderWav.cpp', 'NqrRiffUtils.cpp', 'NqrCommon.cpp',
                         'main.cpp', '-o', str(exe)], cwd=BUILD, check=True)
count = pcm8 = 0
for path in (ROOT / 'build/assets/game').rglob('*.wav'):
    result = subprocess.run([str(exe), str(path)], capture_output=True, check=True).stdout
    info = struct.unpack('<QQQQ', result[:32])
    with wave.open(str(path), 'rb') as sound:
        expected = (sound.getframerate(), sound.getnchannels(), sound.getsampwidth(), sound.getnframes())
        assert info == expected, (path, info, expected)
        assert result[32:] == sound.readframes(sound.getnframes()), path
        pcm8 += sound.getsampwidth() == 1
    count += 1
assert count > 0 and pcm8 > 0, '未覆盖实际入包的PCM8音效'
print(f'实际WAV解码器检查通过：{count}个音效（{pcm8}个PCM8），格式、原始样本、定位均一致')
