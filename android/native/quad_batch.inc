// 模型数据仅在更新时解析；实例绘制不再读Lua顶点表，也不跨原有透明/深度顺序重排。
struct AndroidQuadData {
    cocos2d::RefPtr<cocos2d::Texture2D> texture;
    cocos2d::RefPtr<RenderMode> mode;
    cocos2d::Color4B color;
    double value[38]{};
    bool visible=false;
};
struct AndroidQuadBatchData { std::vector<AndroidQuadData> quads; };
static const char* androidQuadBatchType="BossRush.STDQuadBatch";
LUA_REGISTER_FUNC_DEF(lstg, AndroidUpdateQuadBatch) {
    luaL_checktype(L,2,LUA_TTABLE);
    AndroidQuadBatchData* batch;
    if (lua_isnil(L,1)) {
        batch=new(lua_newuserdata(L,sizeof(AndroidQuadBatchData))) AndroidQuadBatchData();
        if (luaL_newmetatable(L,androidQuadBatchType)) {
            lua_pushcfunction(L,[](lua_State* state) {
                static_cast<AndroidQuadBatchData*>(luaL_checkudata(state,1,androidQuadBatchType))->~AndroidQuadBatchData();return 0;
            });lua_setfield(L,-2,"__gc");
        }
        lua_setmetatable(L,-2);
    } else {
        batch=static_cast<AndroidQuadBatchData*>(luaL_checkudata(L,1,androidQuadBatchType));lua_pushvalue(L,1);
    }
    batch->quads.resize(lua_objlen(L,2));
    for (size_t i=0;i<batch->quads.size();++i) {
        auto& out=batch->quads[i];lua_rawgeti(L,2,i+1);const int packet=lua_gettop(L);
        lua_rawgeti(L,packet,1);out.visible=lua_toboolean(L,-1);
        if (!out.visible) {out.texture=nullptr;out.mode=nullptr;lua_pop(L,2);continue;}
        auto* resource=lua::toResSprite(L,-1);lua_pop(L,1);
        if (!resource) return luaL_error(L,"背景批次的图像资源失效");
        out.texture=resource->getSprite()->getTexture();
        lua_rawgeti(L,packet,2);out.mode=RenderMode::getByName(luaL_checkstring(L,-1));lua_pop(L,1);
        if (!out.mode) return luaL_error(L,"背景批次的混合模式缺失");
        lua_rawgeti(L,packet,4);lua::_luaval_to_color4b(L,-1,&out.color);lua_pop(L,1);
        for (int k=3;k<=38;++k) if (k!=4) {
            lua_rawgeti(L,packet,k);out.value[k-1]=lua_tonumber(L,-1);lua_pop(L,1);
        }
        lua_pop(L,1);
    }
    return 1;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidRenderQuadBatch) {
    const auto* batch=static_cast<AndroidQuadBatchData*>(luaL_checkudata(L,1,androidQuadBatchType));
    const double ix=luaL_checknumber(L,2),iy=luaL_checknumber(L,3),iz=luaL_checknumber(L,4);
    const double ox=luaL_checknumber(L,5),oy=luaL_checknumber(L,6),oz=luaL_checknumber(L,7);
    const bool flip=lua_toboolean(L,8);
    auto* renderer=XRenderer::getInstance();
    auto* deviceRenderer=cocos2d::Director::getInstance()->getRenderer();
    int previousDepth=-1;
    for (const auto& source:batch->quads) {
        if (!source.visible) continue;
        const auto number=[&](int k) {return source.value[k-1];};
        const int depth=number(3)!=0;
        if (depth!=previousDepth) {
            deviceRenderer->setDepthTest(depth);deviceRenderer->setDepthWrite(depth);
            deviceRenderer->setDepthCompareFunction(cocos2d::backend::CompareFunction::LESS_EQUAL);previousDepth=depth;
        }
        const bool strip=number(10)!=0;double x=0,y=0,z=0;
        if (!strip) {
            x=number(5)+ix-ox;y=number(6)+iy-oy;z=number(7)+iz-oz;
            if (flip) y=-y;
            x+=number(8);y+=number(9);
        }
        const float u0=number(23),v0=number(24),u1=number(25),v1=number(26);
        const auto width=source.texture->getPixelsWide(),height=source.texture->getPixelsHigh();
        cocos2d::V3F_C4B_T2F_Quad quad;
        auto* vertices=reinterpret_cast<cocos2d::V3F_C4B_T2F*>(&quad);
        for (int j=0;j<4;++j) {
            auto& v=vertices[j];
            if (strip) {
                v.vertices.x=number(27+j*3)+ix-ox+number(11+j*3);
                v.vertices.y=number(28+j*3)+iy-oy+number(12+j*3);
                v.vertices.z=number(29+j*3)+iz-oz+number(13+j*3);
            } else {v.vertices.x=x+number(11+j*3);v.vertices.y=y+number(12+j*3);v.vertices.z=z+number(13+j*3);}
            v.texCoords.u=(j==0 || j==3 ? u0 : u1)/width;v.texCoords.v=(j<2 ? v0 : v1)/height;v.colors=source.color;
        }
        std::swap(vertices[2],vertices[3]);
        renderer->updateRenderMode(source.mode);renderer->renderTexture(source.texture,&quad);
    }
    return 0;
}
