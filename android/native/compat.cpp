#include "compat.h"
#include "sprite_clip.h"
#include "LSTG/LuaWrapper/LuaWrapper.h"
#include "LSTG/Util/UtilLuaRes.h"
#include "LSTG/Util/UtilLua.h"
#include "LSTG/Renderer.h"
#include "LSTG/AppFrame.h"
#include "LSTG/Component/ComponentDataColli.h"
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
#include <array>
#include <algorithm>
#include <cfloat>
#include <cmath>
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include <EGL/egl.h>
#endif

static bool androidVsyncRequested=false;
bool androidClipSprites=false;
static cocos2d::Vector<cocos2d::backend::Program*> androidClipPrograms;
static uint64_t androidClipTested=0,androidClipCulled=0;
void androidResetSpriteClipping() {
    androidClipSprites=false;androidClipPrograms.clear();
    androidClipTested=androidClipCulled=0;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidSpriteClipping) {
    // 只登记已知MVP顶点程序；模式后续换成自定义程序时自动退出裁剪。
    androidClipPrograms.clear();
    for (const char* name : {"","mul+add"}) {
        if (auto* mode=lstg::RenderMode::getByName(name)) androidClipPrograms.pushBack(mode->getProgram());
    }
    androidClipSprites=lua_toboolean(L,1);
    return 0;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidSpriteClipStats) {
    lua_pushnumber(L,androidClipTested);lua_pushnumber(L,androidClipCulled);
    androidClipTested=androidClipCulled=0;return 2;
}
bool androidSpriteOutside(const cocos2d::V3F_C4B_T2F* vertices,
                         const cocos2d::Mat4& projection,
                         cocos2d::backend::Program* program) {
    const auto* m=projection.m;
    if (!androidClipSprites || m[3]!=0 || m[7]!=0 || m[11]!=0 || m[15]!=1 ||
        !androidClipPrograms.contains(program)) return false;
    bool left=true,right=true,bottom=true,top=true;
    for (int i=0;i<4;++i) {
        const auto& p=vertices[i].vertices;
        const double xx=double(m[0])*p.x,xy=double(m[4])*p.y,xz=double(m[8])*p.z;
        const double yx=double(m[1])*p.x,yy=double(m[5])*p.y,yz=double(m[9])*p.z;
        const double x=xx+xy+xz+m[12],y=yx+yy+yz+m[13];
        // 留出NDC 0.01及浮点误差余量，旋转/负缩放/大坐标边缘均保守保留。
        const double ex=.01+8*FLT_EPSILON*(std::abs(xx)+std::abs(xy)+std::abs(xz)+std::abs(m[12]));
        const double ey=.01+8*FLT_EPSILON*(std::abs(yx)+std::abs(yy)+std::abs(yz)+std::abs(m[13]));
        left&=x < -1-ex;right&=x > 1+ex;bottom&=y < -1-ey;top&=y > 1+ey;
    }
    if (androidProfileBatches) ++androidClipTested;
    const bool outside=left || right || bottom || top;
    if (outside && androidProfileBatches) ++androidClipCulled;
    return outside;
}
bool androidProfileBatches=false;
static uint64_t androidBatchSizes[18]={};
void androidRecordSpriteBatch(std::size_t size) {
    ++androidBatchSizes[std::min<std::size_t>(size,17)];
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidBatchProfile) {
    lua_newtable(L);
    for (int i=1;i<18;++i) { lua_pushnumber(L,androidBatchSizes[i]);lua_rawseti(L,-2,i); }
    std::fill(std::begin(androidBatchSizes),std::end(androidBatchSizes),0);
    androidProfileBatches=lua_toboolean(L,1);
    return 1;
}
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
extern "C" void bossrush_luajit_mcode_stats(uint64_t*);
LUA_REGISTER_FUNC_DEF(lstg, AndroidJitMcodeStats) {
    uint64_t values[11]; bossrush_luajit_mcode_stats(values);
    const char* names[]={"attempts","os_failures","outside_range","regions","failures",
        "target","last_hint","last_address","last_errno","mcode_reason","cache_limit_hits"};
    lua_newtable(L);
    for (int i=0;i<11;++i) { lua_pushnumber(L,static_cast<lua_Number>(values[i])); lua_setfield(L,-2,names[i]); }
    return 1;
}
#endif
void androidApplySwapInterval() {
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    const auto display=eglGetCurrentDisplay();
    const auto context=eglGetCurrentContext();
    if (display==EGL_NO_DISPLAY || context==EGL_NO_CONTEXT) return;
    const int interval=androidVsyncRequested ? 1 : 0;
    const auto ok=eglSwapInterval(display,interval);
    EGLint id=0,count=0,minimum=-1,maximum=-1;
    EGLConfig config;
    if (eglQueryContext(display,context,EGL_CONFIG_ID,&id)) {
        const EGLint attributes[]={EGL_CONFIG_ID,id,EGL_NONE};
        if (eglChooseConfig(display,attributes,&config,1,&count) && count) {
            eglGetConfigAttrib(display,config,EGL_MIN_SWAP_INTERVAL,&minimum);
            eglGetConfigAttrib(display,config,EGL_MAX_SWAP_INTERVAL,&maximum);
        }
    }
    cocos2d::log("BOSSRUSH_VSYNC: requested=%d result=%d driver_min=%d driver_max=%d",interval,ok,minimum,maximum);
#endif
}

LUA_REGISTER_FUNC_DEF(lstg, AndroidSetVsync) {
    androidVsyncRequested=lua_toboolean(L,1)!=0;
    androidApplySwapInterval();
    return 0;
}

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
#include "original_collision.inc"
#include "quad_batch.inc"
#include "fog_state.inc"

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
LUA_REGISTER_FUNC_DEF(lstg, AndroidDrawCounts) {
    auto* renderer=cocos2d::Director::getInstance()->getRenderer();
    lua_pushinteger(L,renderer->getDrawnBatches());lua_pushinteger(L,renderer->getDrawnVertices());return 2;
}
LUA_REGISTER_FUNC_DEF(lstg, AndroidDrawStats) {
    static bool observing = false;
    static double drawStarted = 0, total = 0;
    static std::array<double, 512> samples{};
    static unsigned count = 0;
    if (!observing) {
        observing = true;
        auto* dispatcher = cocos2d::Director::getInstance()->getEventDispatcher();
        dispatcher->addCustomEventListener(cocos2d::Director::EVENT_BEFORE_DRAW,
            [](cocos2d::EventCustom*) { drawStarted = androidNow(); });
        dispatcher->addCustomEventListener(cocos2d::Director::EVENT_AFTER_DRAW,
            [](cocos2d::EventCustom*) {
                const auto elapsed=(androidNow()-drawStarted)*1000;
                samples[count%samples.size()]=elapsed;total+=elapsed;++count;
            });
    }
    auto* renderer = cocos2d::Director::getInstance()->getRenderer();
    lua_pushinteger(L, renderer->getDrawnBatches());
    lua_pushinteger(L, renderer->getDrawnVertices());
    lua_pushnumber(L, count ? total/count : 0);
    auto sorted=samples;
    const auto size=std::min<size_t>(count,sorted.size());
    std::sort(sorted.begin(),sorted.begin()+size);
    lua_pushnumber(L,size ? sorted[(size*95+99)/100-1] : 0);
    lua_pushnumber(L,size ? sorted[(size*99+99)/100-1] : 0);
    lua_pushinteger(L,count);
    count=0;total=0;
    return 6;
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

// ANM精灵把几何与顶点色一次送入原有有序批处理，避免逐粒创建Color和反射调用setter。
// 使用临时四边形，不改共享图像状态；纹理、UV、锚点和全局缩放仍取原资源。
LUA_REGISTER_FUNC_DEF(lstg, AndroidRenderSprite) {
    auto* resource = lua::toResSprite(L, 1);
    if (!resource) return luaL_error(L, "找不到ANM图像资源");
    auto* mode = RenderMode::getByName(luaL_checkstring(L, 2));
    if (!mode) return luaL_error(L, "找不到ANM混合模式");
    const float x = luaL_checknumber(L, 3), y = luaL_checknumber(L, 4);
    const float rotation = luaL_checknumber(L, 5);
    const float factor = LPOOL.getImageScale();
    const float sx = luaL_checknumber(L, 6)*factor, sy = luaL_checknumber(L, 7)*factor;
    const cocos2d::Color4B color(luaL_checkinteger(L, 9), luaL_checkinteger(L, 10),
        luaL_checkinteger(L, 11), luaL_checkinteger(L, 8));
    auto quad = resource->getVertex();
    quad.tl.colors = quad.tr.colors = quad.bl.colors = quad.br.colors = color;
    auto* renderer = XRenderer::getInstance();
    renderer->updateRenderMode(mode);
    renderer->render(resource->getSprite(), &quad, x, y, rotation, sx, sy, 0.5f);
    return 0;
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

// 改相机或同一种雾的参数前提交旧批次，下一批重新取得uniform快照。
LUA_REGISTER_FUNC_DEF(lstg, AndroidFlushRenderState) {
    auto* renderer = lstg::XRenderer::getInstance();
    renderer->flushTriangles();
    renderer->setProgramStateDirty();
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
