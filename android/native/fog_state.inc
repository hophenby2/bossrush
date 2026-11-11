// 雾仍在原9种混合模式和默认模式上切换；避免逐帧Lua反射与重复创建ProgramState。
uint64_t androidFogStatesCreated=0,androidFogStatesReused=0;
static cocos2d::Vec4 androidFogCamera(0,0,0,0);
static cocos2d::Color4B androidFogColor(0,0,0,255);
static float androidFogNear=0,androidFogFar=0;
static int androidFogMode=0;
static const char* androidFogNames[]={"","add+add","add+alpha","add+sub","add+rev","mul+add","mul+alpha","mul+sub","mul+rev"};
static void androidSyncFog(RenderMode* mode) {
    if (!androidFogMode) return;
    mode->setVec4("u_fogCamera",androidFogCamera);mode->setColor("u_fogColor",androidFogColor);
    mode->setFloat("u_fogMode",androidFogMode);mode->setFloat("u_fogStart",androidFogNear);
    mode->setFloat("u_fogEnd",androidFogFar);mode->setFloat("u_fogDensity",androidFogFar);
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidSetFogCamera) {
    androidFogCamera=cocos2d::Vec4(luaL_checknumber(L,1),luaL_checknumber(L,2),luaL_checknumber(L,3),0);
    // 调用者在改变投影前已经提交旧批次，后续命令取得新的uniform快照。
    if (androidFogMode) {
        for (auto* name:androidFogNames) androidSyncFog(RenderMode::getByName(name));
        androidSyncFog(RenderMode::getDefault());
    }
    return 0;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidSetFogState) {
    const bool absent=lua_isnoneornil(L,1);
    androidFogNear=luaL_optnumber(L,1,0);androidFogFar=luaL_optnumber(L,2,0);
    androidFogColor=cocos2d::Color4B(0,0,0,255);
    if (!lua_isnoneornil(L,3)) lua::_luaval_to_color4b(L,3,&androidFogColor);
    // 判型用原Lua双精度值，不能在转float后把两个接近的平面误判为“无雾”。
    const double near=luaL_optnumber(L,1,0),far=luaL_optnumber(L,2,0);
    androidFogMode=absent || near==far ? 0 : near==-1 ? 2 : near==-2 ? 3 : 1;
    auto* renderer=XRenderer::getInstance();renderer->flushTriangles();renderer->setProgramStateDirty();
    for (auto* name:androidFogNames) {
        const std::string key=androidFogMode ? std::string(name)+"+fog"+std::to_string(androidFogMode) : std::string("_")+name;
        auto* mode=RenderMode::getByName(name);auto* source=RenderMode::getByName(key);
        if (!mode || !source) return luaL_error(L,"原作雾效混合模式缺失");
        mode->setProgramCached(source->getProgram());androidSyncFog(mode);
    }
    auto* fallback=RenderMode::getDefault();fallback->setProgramCached(RenderMode::getByName("")->getProgram());androidSyncFog(fallback);
    return 0;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidFogCacheStats) {
    lua_newtable(L);lua_pushnumber(L,androidFogStatesCreated);lua_setfield(L,-2,"created");
    lua_pushnumber(L,androidFogStatesReused);lua_setfield(L,-2,"reused");return 1;
}
