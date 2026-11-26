// 原作路径、宽度、UV逐段保持不变；只合并同一条曲线的绘制提交。
#include "Classes/MemPoolManager.h"
LUA_REGISTER_FUNC_DEF(lstg, AndroidRenderSourceCurve) {
    auto* texture=lua::toTexture2D(L,1);
    auto* mode=RenderMode::getByName(luaL_checkstring(L,2));
    if (!texture || !mode) return luaL_error(L,"曲线激光纹理或混合模式缺失");
    luaL_checktype(L,3,LUA_TTABLE);
    const double half=luaL_checknumber(L,4),tail=luaL_checknumber(L,5),span=luaL_checknumber(L,6);
    const double y=luaL_checknumber(L,7),row=luaL_checknumber(L,8);
    cocos2d::Color4B color;lua::_luaval_to_color4b(L,9,&color);
    const double left=luaL_optnumber(L,10,-1e30)-1,right=luaL_optnumber(L,11,1e30)+1;
    const double bottom=luaL_optnumber(L,12,-1e30)-1,top=luaL_optnumber(L,13,1e30)+1;
    struct Point {double x,y;bool dead;};
    const auto point=[&](size_t i) {
        lua_rawgeti(L,3,i);const int node=lua_gettop(L);
        lua_getfield(L,node,"x");const double x=lua_tonumber(L,-1);lua_pop(L,1);
        lua_getfield(L,node,"y");const double y=lua_tonumber(L,-1);lua_pop(L,1);
        lua_getfield(L,node,"dead");const bool dead=lua_toboolean(L,-1);lua_pop(L,2);
        return Point{x,y,dead};
    };
    const size_t size=lua_objlen(L,3);if (size<2) return 0;
    auto* renderer=XRenderer::getInstance();renderer->updateRenderMode(mode);
    cocos2d::V3F_C4B_T2F_Quad* quads=nullptr;size_t used=0;
    const auto flush=[&]() {
        if (!used) return;
        cocos2d::TrianglesCommand::Triangles triangles;
        triangles.verts=reinterpret_cast<cocos2d::V3F_C4B_T2F*>(quads);
        triangles.vertCount=used*4;triangles.indices=XRenderer::quadIndices512;triangles.indexCount=used*6;
        renderer->renderTexture(texture,triangles);used=0;quads=nullptr;
    };
    Point a=point(1);
    for (size_t i=1;i<size;++i) {
        const Point b=point(i+1);
        if (!a.dead && !b.dead) {
            const double dx=b.x-a.x,dy=b.y-a.y,length=std::sqrt(dx*dx+dy*dy);
            if (length>0) {
                const double nx=-dy/length*half,ny=dx/length*half;
                if (std::max(a.x,b.x)+std::abs(nx)>=left && std::min(a.x,b.x)-std::abs(nx)<=right &&
                    std::max(a.y,b.y)+std::abs(ny)>=bottom && std::min(a.y,b.y)-std::abs(ny)<=top) {
                    if (!quads) quads=LMP.getLaserQuads()->data();
                    auto* v=reinterpret_cast<cocos2d::V3F_C4B_T2F*>(&quads[used]);
                    v[0].vertices.set(a.x+nx,a.y+ny,.5);v[1].vertices.set(b.x+nx,b.y+ny,.5);
                    v[2].vertices.set(b.x-nx,b.y-ny,.5);v[3].vertices.set(a.x-nx,a.y-ny,.5);
                    const float u1=double(i-1)/tail*span,u2=double(i)/tail*span;
                    const float v1=y,v2=y+row,w=texture->getPixelsWide(),h=texture->getPixelsHigh();
                    for (int j=0;j<4;++j) {
                        v[j].texCoords.u=(j==0 || j==3 ? u1 : u2)/w;
                        v[j].texCoords.v=(j<2 ? v1 : v2)/h;v[j].colors=color;
                    }
                    std::swap(v[2],v[3]);if (++used==512) flush();
                }
            }
        }
        a=b;
    }
    flush();return 0;
}
