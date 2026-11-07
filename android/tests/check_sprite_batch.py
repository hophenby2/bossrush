#!/usr/bin/env python3
"""编译实际flushTriangles函数，核对合批前后顶点、索引顺序及模型变换次数。"""
from pathlib import Path
import os
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
source = (ROOT / '.cache/LuaSTG-x/frameworks/LSTG/Renderer.cpp').read_text(encoding='utf-8-sig')
body = source.split('void XRenderer::flushTriangles()', 1)[1].split('void XRenderer::updateBatchedVerts()', 1)[0]
BUILD = ROOT / 'build/sprite-batch-check'
BUILD.mkdir(parents=True, exist_ok=True)
prefix = r'''
#include <vector>
#include <memory>
#include <array>
#include <algorithm>
#include <cassert>
#include <cmath>
#include <iostream>
using namespace std;
struct Point {float x,y,z;};
struct Vertex {Point vertices;unsigned color;};
struct Mat4 {
    float dx=0,dy=0,scale=1;
    void transformPoint(Point* p) const {p->x=p->x*scale+dx;p->y=p->y*scale+dy;}
    static const Mat4 IDENTITY;
};
const Mat4 Mat4::IDENTITY={};
struct Triangles {Vertex* verts=nullptr;unsigned short* indices=nullptr;int vertCount=0,indexCount=0;};
struct XTrianglesCommand {
    Mat4 matrix;Triangles tri;bool skip=false;
    Mat4* getMV() {return &matrix;} Triangles* getTri() {return &tri;}
    int getVertexCount() {return tri.vertCount;} int getIndexCount() {return tri.indexCount;}
    Vertex* getVertices() {return tri.verts;} unsigned short* getIndices() {return tri.indices;}
    void setSkipModelView(bool v) {skip=v;} bool isSkipModelView() {return skip;}
    void copyProperties(XTrianglesCommand*) const {}
};
struct Pool {
    vector<unique_ptr<XTrianglesCommand>> commands;
    XTrianglesCommand* getXTrianglesCommand() {commands.emplace_back(new XTrianglesCommand);return commands.back().get();}
} LMP;
struct Renderer {vector<XTrianglesCommand*> commands;void addCommand(XTrianglesCommand* c) {commands.push_back(c);}};
struct XRenderer {
    struct Batch {XTrianglesCommand* cmd;size_t vertex,index,command,count;};
    vector<XTrianglesCommand*> triToDraw,_cmds;
    vector<Vertex> _verts;vector<unsigned short> _indices;vector<Batch> batchTaskInfo;
    Renderer renderer;Renderer* pRenderer=&renderer;
    void flushTriangles();
};
void XRenderer::flushTriangles()
'''
suffix = r'''
int main() {
    for (int count : {0,1,7,8,85,86,1365,1366,2000,10000}) {
        XRenderer renderer;
        vector<array<Vertex,4>> vertices(count);
        array<unsigned short,6> indices={0,1,2,3,2,1};
        vector<Vertex> expected;
        for(int i=0;i<count;i++) {
            auto* cmd=LMP.getXTrianglesCommand();
            cmd->matrix={91.f,-37.f,2.f};cmd->skip=i%2==0;
            cmd->tri={vertices[i].data(),indices.data(),4,6};
            for(int j=0;j<4;j++) {
                vertices[i][j]={{float(i),float(j),.5f},unsigned(i)};
                auto v=vertices[i][j];if(!cmd->skip)cmd->matrix.transformPoint(&v.vertices);
                expected.push_back(v);
            }
            renderer.triToDraw.push_back(cmd);
        }
        renderer.flushTriangles();
        assert(renderer.triToDraw.empty());
        size_t offset=0;
        for(auto* cmd : renderer.renderer.commands) {
            auto found=find_if(renderer.batchTaskInfo.begin(),renderer.batchTaskInfo.end(),[=](auto& b){return b.cmd==cmd;});
            auto& tri=cmd->tri;
            if(found!=renderer.batchTaskInfo.end()) {
                tri.verts=renderer._verts.data()+found->vertex;tri.indices=renderer._indices.data()+found->index;
                assert(cmd->skip);
            }
            assert(tri.vertCount<65536);
            for(int j=0;j<tri.vertCount;j++) {
                auto v=tri.verts[j];if(!cmd->skip)cmd->matrix.transformPoint(&v.vertices);
                auto e=expected.at(offset+j);
                assert(v.vertices.x==e.vertices.x && v.vertices.y==e.vertices.y && v.vertices.z==e.vertices.z && v.color==e.color);
            }
            for(int j=0;j<tri.indexCount;j++) assert(tri.indices[j]==(j/6)*4+indices[j%6]);
            offset+=tri.vertCount;
        }
        assert(offset==expected.size());
        if(count==2000) assert(renderer.renderer.commands.size()==2);
    }
    cout << "合批顶点/颜色/索引顺序、模型矩阵只变换一次、16位索引与批次上限检查通过\n";
}
'''
target = BUILD / 'check.cpp'
target.write_text(prefix + body + suffix, encoding='utf-8')
compiler = shutil.which('g++') or shutil.which('clang++')
if not compiler:
    raise RuntimeError('需要主机C++编译器')
exe = BUILD / ('check.exe' if os.name == 'nt' else 'check')
command = [compiler, '-std=c++17', '-O2']
if os.name == 'nt':
    command += ['-static', '-fno-use-linker-plugin']
subprocess.run(command+[str(target), '-o', str(exe)], check=True)
subprocess.run([str(exe)], check=True)
