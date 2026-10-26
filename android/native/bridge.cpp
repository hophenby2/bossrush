#include <jni.h>
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
extern "C" {
#include "lua.h"
#include "lauxlib.h"
}

// 只在 Cocos 的 GL 线程进入 Lua，避免生命周期回调和游戏帧竞争。
static void callGame(const char* name, int value, bool hasArgument) {
    auto* stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
    auto* L = stack->getLuaState();
    const int top = lua_gettop(L);
    lua_getglobal(L, name);
    if (lua_isfunction(L, -1)) {
        if (hasArgument) lua_pushboolean(L, value);
        if (lua_pcall(L, hasArgument ? 1 : 0, 0, 0) != 0)
            cocos2d::log("BossRush Android callback: %s", lua_tostring(L, -1));
    }
    lua_settop(L, top);
}

extern "C" JNIEXPORT void JNICALL
Java_org_bossrush_hd_BossRushActivity_nativeFocus(JNIEnv*, jclass, jboolean active) {
    callGame("AndroidFocus", active, true);
}

extern "C" JNIEXPORT void JNICALL
Java_org_bossrush_hd_BossRushActivity_nativeBack(JNIEnv*, jclass) {
    callGame("AndroidBack", 0, false);
}
