#!/usr/bin/env python3
"""编译实际分组碰撞函数，检查空任务、大小任务和先检测后回调的语义。"""
from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[1]
source = (root / '.cache/LuaSTG-x/frameworks/LSTG/Object/GameObjectManager.cpp').read_text(encoding='utf-8-sig')
body = source.split('void GameObjectManager::CollisionCheck(size_t groupA, size_t groupB)', 1)[1].split('void GameObjectManager::CollisionCheck(GameObject* objectA', 1)[0]
utility=(root / '.cache/LuaSTG-x/frameworks/LSTG/Util/Utility.cpp').read_text(encoding='utf-8-sig')
task_body=utility.split('void lstg::deployThreadTaskAndWait',1)[1].split('std::vector<std::future<std::shared_ptr<void>>> lstg::deployThreadTaskFuture',1)[0]
prefix = r'''
#include <vector>
#include <array>
#include <future>
#include <memory>
#include <cassert>
#include <iostream>
#include <stdexcept>
#include <functional>
using namespace std;
struct Object { bool colli=true;int id; };
using GameObject=Object;
int queued=0;
struct Workers {
    bool empty() const{return false;} size_t size() const{return 3;}
    template<class F> future<void> add_task_future(F fn){++queued;return async(launch::deferred,fn);}
} LTHP;
int dispatched=0, pops=0;
vector<int> seen;
vector<Object*> disable;
function<void()> nested;
bool CollisionCheck(Object* a,Object* b){return a->colli && b->colli;}
int lua_gettop(int){return 1;}
void lua_pop(int,int){++pops;}
void luaL_error(int,const char*){throw runtime_error("invalid group");}
const int LGOBJ_CC_COLLI=0;
void callBack(int,Object* a,Object* b,int,int){
    seen.push_back(a->id*10000+b->id);
    // 第一个回调改变碰撞属性，后续仍须使用此前收集的命中。
    if(seen.size()==1)for(auto* p:disable)p->colli=false;
    if(nested){auto fn=std::move(nested);nested=nullptr;fn();}
}
template<class F> vector<future<shared_ptr<void>>> deployThreadTaskFuture(size_t n,size_t,F fn){
    ++dispatched;vector<future<shared_ptr<void>>> out;
    out.push_back(async(launch::deferred,[=]()->shared_ptr<void>{return fn(0,n,0);}));return out;
}
struct GameObjectManager {
    int L=0;array<vector<Object*>,3> colliList;
    bool checkGroupID(size_t i){return i<3;} void GetObjectTable(int){}
    size_t GetObjectCount(){return colliList[0].size()+colliList[1].size();}
    void CollisionCheck(size_t,size_t);
};
'''
suffix = r'''
int main(){
    for(int n:{0,1,31,2047,2048,3000}){
        vector<Object> a(1), b(n);GameObjectManager m;
        a[0].id=1;m.colliList[0].push_back(&a[0]);
        for(int i=0;i<n;++i){b[i].id=i;m.colliList[1].push_back(&b[i]);}
        disable=m.colliList[1];seen.clear();dispatched=0;pops=0;
        m.CollisionCheck(0,1);
        assert(seen.size()==size_t(n));
        for(int i=0;i<n;++i)assert(seen[i]==10000+i);
        assert(dispatched==(n>=2048));assert(pops==(n>0));
    }
    GameObjectManager m;Object a{false,1},b{false,2};m.colliList[0]={&a};m.colliList[1]={&b};
    seen.clear();dispatched=0;m.CollisionCheck(0,1);assert(seen.empty()&&dispatched==0);
    vector<Object> outer(4),inner(2);GameObjectManager out,in;
    outer[0].id=1;out.colliList[0]={&outer[0]};
    for(int i=1;i<4;++i){outer[i].id=i-1;out.colliList[1].push_back(&outer[i]);}
    inner[0].id=8;inner[1].id=9;in.colliList[0]={&inner[0]};in.colliList[1]={&inner[1]};
    seen.clear();disable.clear();nested=[&]{in.CollisionCheck(0,1);};out.CollisionCheck(0,1);
    assert((seen==vector<int>{10000,80009,10001,10002}));
    for(size_t n:{0,1,2047,2048,10000}){
        vector<int> visits(n);queued=0;
        deployThreadTaskAndWait(n,4,[&](int first,int last,int){for(int i=first;i<last;++i)++visits[i];});
        for(int count:visits)assert(count==1);
        assert(queued==(n<2048?0:3));
    }
    cout<<"实际碰撞派发检查通过：空分组、空候选、阈值两侧、命中快照与回调顺序。\n";
}
'''
build = root / 'build/collision-dispatch-check'
build.mkdir(parents=True, exist_ok=True)
cpp = build / 'check.cpp'
cpp.write_text(prefix + 'void deployThreadTaskAndWait' + task_body + 'void GameObjectManager::CollisionCheck(size_t groupA,size_t groupB)' + body + suffix)
subprocess.run(['clang++', '-std=c++17', '-O2', str(cpp), '-o', str(build / 'check')], check=True)
subprocess.run([str(build / 'check')], check=True)
