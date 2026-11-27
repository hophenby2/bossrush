#!/usr/bin/env python3
"""编译正式集中上传代码，验证透明绘制顺序、字节偏移、矩阵及16位索引边界。"""
from pathlib import Path
import os
import subprocess
import shutil

root = Path(__file__).resolve().parents[1]
build = root / 'build/triangle-upload-check'
build.mkdir(parents=True, exist_ok=True)
source = r'''
#include <algorithm>
#include <cassert>
#include <cstring>
#include <cstdint>
#include <iostream>
#include <memory>
#include <vector>
#define CC_ASSERT assert
using namespace std;
struct Point {float x,y,z;};
struct V3F_C4B_T2F {Point vertices; uint32_t color; float u,v;};
struct Matrix {void transformPoint(Point* p) const {p->x=p->x*2+7;p->y=p->y*2-9;}};
struct Pipeline {int programState;};
struct Command {
    vector<V3F_C4B_T2F> vertices;
    vector<uint16_t> indices;
    bool skip;
    Matrix matrix;
    Pipeline pipeline;
    size_t getVertexCount()const{return vertices.size();}
    size_t getIndexCount()const{return indices.size();}
    auto getVertices()const{return vertices.data();}
    auto getIndices()const{return indices.data();}
    bool isSkipModelView()const{return skip;}
    auto& getModelView()const{return matrix;}
    auto& getPipelineDescriptor(){return pipeline;}
};
struct Batch {vector<Command*> cmds; Command* cmd; size_t indicesToDraw;};
struct Buffer {vector<unsigned char> data;int updates=0;
    void updateData(void* p,size_t n){++updates;data.assign((unsigned char*)p,(unsigned char*)p+n);}
};
struct Pool {
    struct Pair{shared_ptr<Buffer> vb,ib;};
    vector<Pair> buffers;
    vector<V3F_C4B_T2F> vertices;
    vector<uint16_t> indices;
    auto nextVertexData(size_t n){vertices.resize(n);return vertices.data();}
    auto nextIndexData(size_t n){indices.resize(n);return indices.data();}
    Pair nextBuffer(size_t,size_t){Pair p{make_shared<Buffer>(),make_shared<Buffer>()};buffers.push_back(p);return p;}
} GlobalTriangleBufferPool;
namespace backend {enum class PrimitiveType{TRIANGLE};enum class IndexFormat{U_SHORT};}
struct Draw {int program;size_t count,offset;vector<V3F_C4B_T2F> vertices;};
struct CommandBuffer {
    shared_ptr<Buffer> vb,ib;int program;
    vector<Draw> draws;
    void setVertexBuffer(shared_ptr<Buffer> p){vb=p;}
    void setIndexBuffer(shared_ptr<Buffer> p){ib=p;}
    void updatePipelineState(void*,Pipeline& p){program=p.programState;}
    void setProgramState(int p){assert(program==p);}
    void drawElements(backend::PrimitiveType,backend::IndexFormat,size_t count,size_t offset){
        assert(offset%sizeof(uint16_t)==0 && offset+count*sizeof(uint16_t)<=ib->data.size());
        Draw d{program,count,offset,{}};
        for(size_t i=0;i<count;++i){
            uint16_t index;memcpy(&index,ib->data.data()+offset+i*sizeof(index),sizeof(index));
            assert((index+1)*sizeof(V3F_C4B_T2F)<=vb->data.size());
            V3F_C4B_T2F v;memcpy(&v,vb->data.data()+index*sizeof(v),sizeof(v));d.vertices.push_back(v);
        }
        draws.push_back(d);
    }
};
struct Renderer {
    vector<Batch> _triBatchesToDraw;
    CommandBuffer commands;
    CommandBuffer* _commandBuffer=&commands;
    void* _currentRT=nullptr;
    size_t _filledVertex=0,_filledIndex=0,_drawnBatches=0,_drawnVertices=0;
    void draw(){int batchesTotal=_triBatchesToDraw.size();
#include "triangle_upload.inc"
    }
};
int main(){
    for(auto sizes:vector<vector<int>>{{},{4},{4,4,4,4},{65532,4,4},{32768,32768,4},{4,65000,528,4}}){
        GlobalTriangleBufferPool={};Renderer r;
        vector<unique_ptr<Command>> commands;
        vector<Draw> expected;
        size_t expectedVertices=0,expectedIndices=0;
        for(size_t i=0;i<sizes.size();++i){
            Batch b{};Draw d{int(i%2),0,0,{}};
            // 一个材质批次允许包含多个命令，矩阵和skip状态逐命令变化。
            for(int part=0;part<2;++part){
                auto c=make_unique<Command>();c->skip=(i+part)%2;c->pipeline.programState=i%2;
                int n=part==0?sizes[i]/2:sizes[i]-sizes[i]/2;
                for(int j=0;j<n;++j){c->vertices.push_back({{float(i),float(j),.5f},uint32_t(j),.25f,.75f});c->indices.push_back(j);}
                for(auto index:c->indices){auto v=c->vertices[index];if(!c->skip)c->matrix.transformPoint(&v.vertices);d.vertices.push_back(v);}
                expectedVertices+=n;expectedIndices+=n;d.count+=n;b.indicesToDraw+=n;
                b.cmd=c.get();b.cmds.push_back(c.get());commands.push_back(std::move(c));
            }
            expected.push_back(d);r._triBatchesToDraw.push_back(b);
        }
        r.draw();assert(r.commands.draws.size()==expected.size());
        assert(r._filledVertex==expectedVertices && r._filledIndex==expectedIndices);
        assert(r._drawnBatches==expected.size() && r._drawnVertices==expectedIndices);
        for(size_t i=0;i<expected.size();++i){auto& a=r.commands.draws[i];auto& e=expected[i];
            assert(a.program==e.program && a.count==e.count);
            for(size_t j=0;j<e.vertices.size();++j){auto& x=a.vertices[j];auto& y=e.vertices[j];
                assert(!memcmp(&x,&y,sizeof(x)));
            }
        }
        size_t bytes=0;for(auto& b:GlobalTriangleBufferPool.buffers){assert(b.vb->updates==1&&b.ib->updates==1);bytes+=b.vb->data.size();}
        assert(bytes==expectedVertices*sizeof(V3F_C4B_T2F));
        if(sizes==vector<int>{4,4,4,4})assert(GlobalTriangleBufferPool.buffers.size()==1);
        if(sizes==vector<int>{65532,4,4}){assert(GlobalTriangleBufferPool.buffers.size()==2);assert(r.commands.draws[2].offset==0);}
    }
    // 超大顶点数组可只用16位索引引用其中一部分，不能因集中上传而新增崩溃。
    GlobalTriangleBufferPool={};Renderer large;
    Command c{};c.skip=true;c.pipeline.programState=3;c.vertices.resize(65540);
    c.vertices[65535].color=123;c.indices={0,65535};
    Command tail=c;tail.vertices.resize(4);tail.indices={0,3};
    large._triBatchesToDraw={{{&c},&c,2},{{&tail},&tail,2}};
    large.draw();assert(GlobalTriangleBufferPool.buffers.size()==2);
    assert(large.commands.draws[0].vertices[1].color==123 && large.commands.draws[1].offset==0);
    cout<<"有序材质、顶点/颜色/UV、矩阵、索引字节偏移、65536边界及每块两次上传检查通过\n";
}
'''
target = build / 'check.cpp'
target.write_text(source)
compiler = shutil.which('clang++') or shutil.which('g++')
if not compiler:
    raise RuntimeError('需要主机C++编译器')
exe=build / ('check.exe' if os.name=='nt' else 'check')
subprocess.run([compiler, '-std=c++17', '-O2', '-I', str(root / 'native'), str(target), '-o', str(exe)], check=True)
subprocess.run([str(exe)], check=True)
