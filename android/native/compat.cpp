#include "compat.h"
#include "LSTG/LuaWrapper/LuaWrapper.h"
#include "LSTG/Util/UtilLuaRes.h"
#include "LSTG/Renderer.h"
#include "Classes/XLuaModuleRegistry.h"
#include "renderer/backend/Device.h"
#include "renderer/backend/DeviceInfo.h"
#ifdef CC_USE_GFX
#include "glad/gl.h"
#include "renderer/backend/gfx/TextureGFX.h"
#include "renderer/backend/gfx/BufferGFX.h"
#include "gfx/backend/gfx-gles3/GLES3Buffer.h"
#include "gfx/backend/gfx-gles3/GLES3Device.h"
#include "gfx/backend/gfx-gles3/GLES3GPUObjects.h"
#include "gfx/backend/gfx-agent/BufferAgent.h"
#endif
#include <chrono>
#include <cstring>

int androidSuperPause = 0;
int androidCurrentSuperPause = 0;
int androidWorldFlag = 15;
bool androidProfileText = false;
double androidTextTime[3] = {};
unsigned androidTextCalls = 0;
double androidNow() {
    return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count();
}
using namespace lstg;

LUA_REGISTER_FUNC_DEF(lstg, AndroidRendererInfo) {
#ifdef CC_USE_GFX
    std::string info = reinterpret_cast<const char*>(glGetString(GL_VERSION));
    info += " / "; info += reinterpret_cast<const char*>(glGetString(GL_RENDERER));
    info += " / GL error=" + std::to_string(glGetError());
#else
    auto* device = cocos2d::backend::Device::getInstance()->getDeviceInfo();
    std::string info = std::string(device->getVersion()) + " / " + device->getRenderer();
#endif
    lua_pushlstring(L, info.data(), info.size()); return 1;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidClock) {
    lua_pushnumber(L, androidNow()); return 1;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidDrawStats) {
    auto* renderer = cocos2d::Director::getInstance()->getRenderer();
    lua_pushinteger(L, renderer->getDrawnBatches());
    lua_pushinteger(L, renderer->getDrawnVertices()); return 2;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidTextProfile) {
    if (lua_gettop(L)) androidProfileText = lua_toboolean(L, 1);
    for (double& t : androidTextTime) { lua_pushnumber(L, t); t = 0; }
    lua_pushinteger(L, androidTextCalls); androidTextCalls = 0;
    return 4;
}
#ifdef CC_USE_GFX
LUA_REGISTER_FUNC_DEF(lstg, AndroidVerifyGraphics) {
    using namespace cocos2d;
    using namespace cocos2d::backend;
    const unsigned char pixels[3*2*4] = {};
    auto* texture = new Texture2D();
    bool ok = texture->initWithData(pixels, sizeof(pixels), PixelFormat::RGBA8888, 3, 2, false);
    auto* gpu = dynamic_cast<Texture2DGFX*>(texture->getBackendTexture());
    if (ok && gpu) {
        Texture2D::TexParams params;
        params.minFilter = params.magFilter = SamplerFilter::LINEAR;
        for (auto mode : { SamplerAddressMode::REPEAT, SamplerAddressMode::CLAMP_TO_EDGE, SamplerAddressMode::REPEAT }) {
            params.sAddressMode = params.tAddressMode = mode;
            texture->setTexParameters(params);
            const auto expected = mode == SamplerAddressMode::REPEAT ? cc::gfx::Address::WRAP : cc::gfx::Address::CLAMP;
            const auto* sampler = gpu->getSampler();
            ok = ok && sampler && sampler->getInfo().addressU == expected && sampler->getInfo().addressV == expected;
        }
    } else { ok = false; }
    texture->release();
    if (!ok) return luaL_error(L, "NPOT 纹理循环/边缘采样切换失败");
    // 读取真实 GPU 数据，覆盖零值、分段修改、重复值和后续覆盖，防止 UBO 合并丢字段。
    cc::gfx::BufferInfo info;
    info.usage = cc::gfx::BufferUsageBit::UNIFORM;
    info.memUsage = cc::gfx::MemoryUsageBit::DEVICE;
    info.size = info.stride = 64;
    auto* uniform = new BufferGFX(info);
    unsigned char expected[64] = {};
    const float first[4] = { 1, 2, 3, 4 }, second[4] = { 5, 6, 7, 8 };
    for (int phase = 0; phase < 4 && ok; ++phase) {
        if (phase == 0) uniform->update(expected, 16, 0);
        if (phase == 1 || phase == 2) {
            uniform->update(first, sizeof(first), 0); std::memcpy(expected, first, sizeof(first));
            uniform->update(second, sizeof(second), 16); std::memcpy(expected+16, second, sizeof(second));
        }
        if (phase == 3) {
            uniform->update(first, sizeof(first), 32); std::memcpy(expected+32, first, sizeof(first));
        }
        auto* handle = uniform->getHandler();
        if (auto* agent = dynamic_cast<cc::gfx::BufferAgent*>(handle)) handle = agent->getActor();
        auto* gpuBuffer = static_cast<cc::gfx::GLES3Buffer*>(handle)->gpuBuffer();
        glBindBuffer(GL_UNIFORM_BUFFER, gpuBuffer->glBuffer);
        cc::gfx::GLES3Device::getInstance()->stateCache()->glUniformBuffer = gpuBuffer->glBuffer;
        const auto* actual = glMapBufferRange(GL_UNIFORM_BUFFER, 0, 64, GL_MAP_READ_BIT);
        ok = actual && !std::memcmp(actual, expected, 64);
        if (!ok) cocos2d::log("BOSSRUSH_UBO_CHECK: phase=%d mapped=%d error=%u", phase, actual != nullptr, glGetError());
        if (actual) ok = glUnmapBuffer(GL_UNIFORM_BUFFER) && ok;
        glBindBuffer(GL_UNIFORM_BUFFER, 0);
        cc::gfx::GLES3Device::getInstance()->stateCache()->glUniformBuffer = 0;
    }
    uniform->release();
    if (!ok) return luaL_error(L, "UBO 合并提交的 GPU 读取校验失败");
    lua_pushboolean(L, true); return 1;
}
#endif
LUA_REGISTER_FUNC_DEF(lstg, AndroidSetFrameBufferEnabled) {
    lstg::XRenderer::getInstance()->setUseFrameBuffer(lua_toboolean(L, 1)); return 0;
}

LUA_REGISTER_FUNC_DEF(lstg, GetSuperPause) { lua_pushinteger(L, androidSuperPause); return 1; }
LUA_REGISTER_FUNC_DEF(lstg, GetCurrentSuperPause) { lua_pushinteger(L, androidCurrentSuperPause); return 1; }
LUA_REGISTER_FUNC_DEF(lstg, SetSuperPause) { androidSuperPause = luaL_checkinteger(L, 1); return 0; }
LUA_REGISTER_FUNC_DEF(lstg, AddSuperPause) { androidSuperPause += luaL_checkinteger(L, 1); return 0; }
LUA_REGISTER_FUNC_DEF(lstg, SetWorldFlag) { androidWorldFlag = luaL_checkinteger(L, 1); return 0; }
LUA_REGISTER_FUNC_DEF(lstg, GetWorldFlag) { lua_pushinteger(L, androidWorldFlag); return 1; }

static void scaleQuad(cocos2d::V3F_C4B_T2F_Quad& quad, cocos2d::Vec2 anchor, float x, float y) {
    for (auto* v : { &quad.tl, &quad.tr, &quad.bl, &quad.br }) {
        v->vertices.x = anchor.x + (v->vertices.x - anchor.x) * x;
        v->vertices.y = anchor.y + (v->vertices.y - anchor.y) * y;
    }
}

LUA_REGISTER_FUNC_DEF(lstg, AndroidScaleResource) {
    const float x = luaL_checknumber(L, 2), y = luaL_optnumber(L, 3, x);
    if (lua_toboolean(L, 4)) {
        auto* resource = lua::toResAnimation(L, 1);
        if (!resource) return luaL_error(L, "找不到动画资源");
        for (size_t i = 0; i < resource->getCount(); ++i)
            scaleQuad(resource->getVertex(i), resource->getSprite(i)->getAnchorPointInPoints(), x, y);
    } else {
        auto* resource = lua::toResSprite(L, 1);
        if (!resource) return luaL_error(L, "找不到图像资源");
        scaleQuad(resource->getVertex(), resource->getSprite()->getAnchorPointInPoints(), x, y);
    }
    return 0;
}

LUA_REGISTER_FUNC_DEF(lstg, SetTextureSamplerState) {
    auto* texture = lua::toTexture2D(L, 1);
    if (!texture) return luaL_error(L, "找不到纹理资源");
    const std::string mode = luaL_checkstring(L, 2);
    cocos2d::Texture2D::TexParams params;
    using namespace cocos2d::backend;
    params.minFilter = params.magFilter = mode.find("linear") != std::string::npos ? SamplerFilter::LINEAR : SamplerFilter::NEAREST;
    params.sAddressMode = params.tAddressMode = mode.find("wrap") != std::string::npos ? SamplerAddressMode::REPEAT : SamplerAddressMode::CLAMP_TO_EDGE;
    texture->setTexParameters(params);
    return 0;
}

LUA_REGISTER_FUNC_DEF(lstg, ClearZBuffer) {
    auto* renderer = cocos2d::Director::getInstance()->getRenderer();
    renderer->clear(cocos2d::ClearFlag::DEPTH, cocos2d::Color4F(0, 0, 0, 0), 1.f, 0, 0.f);
    return 0;
}

LUA_REGISTER_FUNC_DEF(lstg, SetZBufferEnable) {
    const bool enabled = lua_isboolean(L, 1) ? lua_toboolean(L, 1) : luaL_checkinteger(L, 1) != 0;
    auto* renderer = cocos2d::Director::getInstance()->getRenderer();
    renderer->setDepthTest(enabled);
    renderer->setDepthWrite(enabled);
    renderer->setDepthCompareFunction(cocos2d::backend::CompareFunction::LESS_EQUAL);
    return 0;
}
