// Sub曲线激光按节点圆和原碰撞包络判定，不改变绘制节点的宽度。
LUA_REGISTER_FUNC_DEF(lstg, AndroidBentLaserEnvelopeValues) {
    const float height=luaL_checknumber(L,1),base=std::clamp(float(luaL_checknumber(L,2)),0.f,1.f);
    const float rate=luaL_checknumber(L,3),power=.4f*std::floor(float(luaL_checknumber(L,4))/.4f);
    for (const float value : {height,base,rate,power}) lua_pushnumber(L,value);
    return 4;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidBentLaserCollision) {
    auto* laser=lua::tousertype<GameObjectBentLaser>(L,1,"lstg.GameObjectBentLaser");
    if (!laser) return luaL_error(L,"无效的曲线激光数据");
    const cocos2d::Vec2 point(luaL_checknumber(L,2),luaL_checknumber(L,3));
    // Sub的BentLaserData碰撞接口将参数直接交给弧度几何函数，不走对象rot的角度setter。
    const float rotation=luaL_checknumber(L,4);
    const float a=std::abs(float(luaL_checknumber(L,5))),b=std::abs(float(luaL_checknumber(L,6)));
    const auto shape=lua_toboolean(L,7) ? XColliderType::OBB : a==b ? XColliderType::Circle : XColliderType::Ellipse;
    luaL_checktype(L,8,LUA_TTABLE);luaL_checktype(L,9,LUA_TTABLE);
    float envelope[4];
    for (int i=0;i<4;++i) { lua_rawgeti(L,8,i+1);envelope[i]=luaL_checknumber(L,-1);lua_pop(L,1); }
    const int count=int(laser->getNodeCount());
    if (count<=1) { lua_pushboolean(L,false);return 1; }
    const bool overrideWidth=!lua_isnoneornil(L,10);
    const float width=overrideWidth ? float(luaL_checknumber(L,10)) : 0.f;
    for (int i=0;i<count;++i) {
        lua_rawgeti(L,9,i+1);const bool active=lua_toboolean(L,-1)!=0;lua_pop(L,1);
        if (!active) continue;
        const float t=float(i)/float(count-1);
        const float scale=std::max(0.f,envelope[0]+envelope[1]*(1.f-envelope[2]*2.f*std::pow(t-.5f,envelope[3])));
        // x公开节点接口从1开始，包络参数仍按Sub的0到count-1归一化。
        const float radius=std::abs(overrideWidth ? width*.5f : laser->getNodeWidth(i+1)*.5f*scale);
        if (xmath::collision::check(laser->getNodePosition(i+1),radius,radius,0.f,XColliderType::Circle,
                point,a,b,rotation,shape)) {
            lua_pushboolean(L,true);return 1;
        }
    }
    lua_pushboolean(L,false);return 1;
}
