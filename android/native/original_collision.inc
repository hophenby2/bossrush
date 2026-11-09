// 批量执行原作判定的临时保存/恢复；不改变碰撞配对、回调和消散顺序。
// 游戏字段仍从对象 Lua 表读取，避免把动态 ECL 状态复制成过期的原生缓存。
namespace {
struct OriginalCollisionRow {
    GameObject* object;
    int64_t uid;
    lua_Number rotation, a, b;
    xmath::collision::ColliderType type;
    int enemy;
    bool colli, disabled;
};
std::vector<OriginalCollisionRow> originalRows;
int originalPlayerGroup=0, originalShotGroup=0;
bool originalValid(const OriginalCollisionRow& row) {
    return row.object->status!=STATUS_FREE && row.object->uid==row.uid;
}
void originalField(lua_State* L,int index,const char* key) {
    lua_pushstring(L,key);lua_rawget(L,index);
}
int originalGameValue(lua_State* L,int index) {
    if (!lua_toboolean(L,index)) return 0;
    if (lua_type(L,index)==LUA_TNUMBER) {
        const auto value=lua_tonumber(L,index);
        for (int game : {6,7,8,10,11,95}) if (value==game) return game;
    }
    // Lua的0、字符串和其他真值也激活轴对齐判定，但不触发6/7/8的作品特判。
    return -1;
}
int originalGame(lua_State* L,int index) {
    originalField(L,index,"_original_collision_game");
    int game=originalGameValue(L,-1);lua_pop(L,1);
    if (!game) {
        originalField(L,index,"_original_actor");
        if (lua_toboolean(L,-1)) { lua_getfield(L,-1,"game");game=originalGameValue(L,-1);lua_pop(L,1); }
        lua_pop(L,1);
    }
    return game;
}
bool originalBox(lua_State* L,int index,const char* key,lua_Number& a,lua_Number& b) {
    originalField(L,index,key);
    const bool exists=lua_istable(L,-1);
    if (exists) {
        lua_rawgeti(L,-1,1);a=lua_tonumber(L,-1)/2;lua_pop(L,1);
        lua_rawgeti(L,-1,2);b=lua_tonumber(L,-1)/2;lua_pop(L,1);
    }
    lua_pop(L,1);return exists;
}
bool originalFalse(lua_State* L,int index,const char* key) {
    originalField(L,index,key);
    const bool result=lua_isboolean(L,-1) && !lua_toboolean(L,-1);lua_pop(L,1);return result;
}
void originalSave(lua_State* L,GameObject* p,int index,int enemy) {
    auto* cm=p->cm;auto* c=cm->getDataColli();const auto scale=LPOOL.getColliderScale();
    // 与 Lua GetAttr/SetAttr 的单位转换完全相同，包含原有 float 舍入。
    originalRows.push_back({p,p->uid,p->getRotation()*LRAD2DEGREE_D,c->a/scale,c->b/scale,c->type,enemy,p->colli,false});
    auto& row=originalRows.back();
    lua_pushnumber(L,row.rotation);lua_setfield(L,index,"_original_collision_rot");
    cm->setRot(0);c->type=xmath::collision::ColliderType::OBB;cm->updateColli();
    if (enemy) {
        lua_Number a=row.a,b=row.b;
        if (!originalBox(L,index,"_original_contact_box",a,b) && (enemy==6 || enemy==7 || enemy==8)) {
            originalBox(L,index,"_original_damage_box",a,b);a/=1.5;b/=1.5;
        }
        cm->setColliA(a*scale);cm->setColliB(b*scale);
        if (enemy==8) {
            originalField(L,index,"_original_no_damage_during_bomb");const bool noBomb=lua_toboolean(L,-1);lua_pop(L,1);
            lua_getglobal(L,"player");
            if (noBomb && lua_istable(L,-1)) {
                lua_getfield(L,-1,"nextspell");
                if (lua_tonumber(L,-1)>0) { row.disabled=true;p->colli=false; }
                lua_pop(L,1);
            }
            lua_pop(L,1);
        }
    }
}
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidOriginalCollision) {
    const auto phase=luaL_checkstring(L,1);
    if (!std::strcmp(phase,"begin")) {
        luaL_checktype(L,2,LUA_TTABLE);luaL_checktype(L,3,LUA_TTABLE);
        originalRows.clear();int enemies=0;
        originalPlayerGroup=luaL_checkinteger(L,4);originalShotGroup=luaL_checkinteger(L,5);
        if (!LPOOL.checkGroupID(originalPlayerGroup) || !LPOOL.checkGroupID(originalShotGroup)) return luaL_error(L,"原作判定分组无效");
        for (int i=1;i<=5;++i) {
            lua_rawgeti(L,3,i);const int group=luaL_checkinteger(L,-1);lua_pop(L,1);
            if (!LPOOL.checkGroupID(group)) return luaL_error(L,"原作判定分组无效");
            for (auto* p:LPOOL.androidCollisionGroup(group)) if (p->colli) {
                LPOOL.pushObject(L,p);const int object=lua_gettop(L);const int game=originalGame(L,object);
                if (game) {
                    const int enemy=i>=4 ? game : 0;originalSave(L,p,object,enemy);
                    if (enemy) {
                        lua_rawgeti(L,2,++enemies);
                        if (!lua_istable(L,-1)) { lua_pop(L,1);lua_newtable(L);lua_pushvalue(L,-1);lua_rawseti(L,2,enemies); }
                        lua_pushvalue(L,object);lua_rawseti(L,-2,1);lua_pushinteger(L,enemy);lua_rawseti(L,-2,6);lua_pop(L,1);
                    }
                }
                lua_pop(L,1);
            }
        }
        if (!originalRows.empty()) for (auto* p:LPOOL.androidCollisionGroup(originalPlayerGroup)) if (p->colli) {
            LPOOL.pushObject(L,p);originalSave(L,p,lua_gettop(L),0);lua_pop(L,1);
        }
        lua_pushinteger(L,enemies);return 1;
    }
    if (!std::strcmp(phase,"shots")) {
        if (originalRows.empty()) return 0;
        const auto scale=LPOOL.getColliderScale();
        for (auto& row:originalRows) if (row.enemy && originalValid(row)) {
            LPOOL.pushObject(L,row.object);const int object=lua_gettop(L);
            lua_Number a=row.a,b=row.b;originalBox(L,object,"_original_damage_box",a,b);
            row.object->cm->setColliA(a*scale);row.object->cm->setColliB(b*scale);
            if (originalFalse(L,object,"_original_accepts_damage")) { row.disabled=true;row.object->colli=false; }
            lua_pop(L,1);
        }
        for (auto* p:LPOOL.androidCollisionGroup(originalShotGroup)) if (p->colli) {
            LPOOL.pushObject(L,p);originalSave(L,p,lua_gettop(L),0);lua_pop(L,1);
        }
        return 0;
    }
    if (!std::strcmp(phase,"finish")) {
        const auto scale=LPOOL.getColliderScale();
        for (auto& row:originalRows) if (originalValid(row)) {
            auto* p=row.object;auto* cm=p->cm;
            cm->setRot(row.rotation*LDEGREE2RAD);cm->getDataColli()->type=row.type;cm->updateColli();
            cm->setColliA(row.a*scale);cm->setColliB(row.b*scale);
            if (row.disabled && p->status!=STATUS_KILL && p->status!=STATUS_DEL) p->colli=row.colli;
            LPOOL.pushObject(L,p);lua_pushnil(L);lua_setfield(L,-2,"_original_collision_rot");lua_pop(L,1);
        }
        originalRows.clear();return 0;
    }
    return luaL_error(L,"未知原作判定阶段：%s",phase);
}
