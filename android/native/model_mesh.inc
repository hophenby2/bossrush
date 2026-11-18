// 原始XNA/DirectX网格只在载入时解析；逐帧变换和提交在C++完成，不简化三角形。
#include "Classes/MemPoolManager.h"
struct AndroidModelMesh {
    cocos2d::RefPtr<cocos2d::Texture2D> texture;
    std::vector<std::array<float,5>> vertices;
};
static const char* androidModelMeshType="BossRush.SourceModelMesh";
LUA_REGISTER_FUNC_DEF(lstg, AndroidCreateModelMesh) {
    auto* texture=lua::toTexture2D(L,1);
    if (!texture) return luaL_error(L,"原作模型纹理缺失");
    luaL_checktype(L,2,LUA_TTABLE);
    const size_t count=lua_objlen(L,2);
    if (count%15) return luaL_error(L,"原作模型三角形顶点表不完整");
    auto* mesh=new(lua_newuserdata(L,sizeof(AndroidModelMesh))) AndroidModelMesh();
    if (luaL_newmetatable(L,androidModelMeshType)) {
        lua_pushcfunction(L,[](lua_State* s) {
            static_cast<AndroidModelMesh*>(luaL_checkudata(s,1,androidModelMeshType))->~AndroidModelMesh();return 0;
        });lua_setfield(L,-2,"__gc");
    }
    lua_setmetatable(L,-2);mesh->texture=texture;mesh->vertices.resize(count/5);
    for (size_t i=0;i<count;++i) {
        lua_rawgeti(L,2,i+1);mesh->vertices[i/5][i%5]=luaL_checknumber(L,-1);lua_pop(L,1);
    }
    return 1;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidRenderModelMesh) {
    const auto* mesh=static_cast<AndroidModelMesh*>(luaL_checkudata(L,1,androidModelMeshType));
    auto* mode=RenderMode::getByName(luaL_checkstring(L,2));
    if (!mode) return luaL_error(L,"原作模型混合模式缺失");
    cocos2d::Color4B color;lua::_luaval_to_color4b(L,3,&color);
    const bool matrix=lua_istable(L,4);double t[12]{},uv[4]{1,1,0,0};
    if (matrix) {
        for (int i=0;i<12;++i) {lua_rawgeti(L,4,i+1);t[i]=luaL_checknumber(L,-1);lua_pop(L,1);}
        for (int i=0;i<4;++i) {lua_rawgeti(L,5,i+1);uv[i]=luaL_checknumber(L,-1);lua_pop(L,1);}
    } else for (int i=0;i<11;++i) t[i]=luaL_checknumber(L,i+4);
    const double cull=matrix ? luaL_optnumber(L,6,0) : 0;
    const double cx=std::cos(t[6]),sx=std::sin(t[6]),cy=std::cos(t[7]),sy=std::sin(t[7]),cz=std::cos(t[8]),sz=std::sin(t[8]);
    auto* renderer=XRenderer::getInstance();renderer->updateRenderMode(mode);
    for (size_t start=0;start<mesh->vertices.size();start+=512*3) {
        const size_t count=std::min(size_t(512), (mesh->vertices.size()-start)/3);
        auto* quads=LMP.getLaserQuads()->data();size_t used=0;
        for (size_t i=0;i<count;++i) {
            auto* v=reinterpret_cast<cocos2d::V3F_C4B_T2F*>(&quads[used]);
            for (int j=0;j<4;++j) {
                const auto& p=mesh->vertices[start+i*3+std::min(j,2)];
                if (matrix) {
                    v[j].vertices.set(t[0]*p[0]+t[3]*p[1]+t[6]*p[2]+t[9],t[1]*p[0]+t[4]*p[1]+t[7]*p[2]+t[10],t[2]*p[0]+t[5]*p[1]+t[8]*p[2]+t[11]);
                    v[j].texCoords.u=p[3]*uv[0]+uv[2];v[j].texCoords.v=p[4]*uv[1]+uv[3];v[j].colors=color;continue;
                }
                double x=(p[0]+t[0])*t[3],y=(p[1]+t[1])*t[4],z=(p[2]+t[2])*t[5];
                const double yy=y*cx-z*sx;z=y*sx+z*cx;y=yy;
                const double xx=x*cy+z*sy;z=-x*sy+z*cy;x=xx;
                v[j].vertices.set(x*cz-y*sz,x*sz+y*cz,z);
                v[j].texCoords.u=p[3]+t[9];v[j].texCoords.v=p[4]+t[10];v[j].colors=color;
            }
            if (cull!=0) {
                const auto& a=v[0].vertices;const auto& b=v[1].vertices;const auto& c=v[2].vertices;
                const double facing=a.x*(b.y*c.z-b.z*c.y)-a.y*(b.x*c.z-b.z*c.x)+a.z*(b.x*c.y-b.y*c.x);
                if (facing*cull>=0) continue;
            }
            ++used;
        }
        cocos2d::TrianglesCommand::Triangles triangles;
        triangles.verts=reinterpret_cast<cocos2d::V3F_C4B_T2F*>(quads);
        triangles.vertCount=used*4;triangles.indices=XRenderer::quadIndices512;triangles.indexCount=used*6;
        if (used) renderer->renderTexture(mesh->texture,triangles);
    }
    return 0;
}
