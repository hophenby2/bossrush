#!/usr/bin/env python3
"""在校验过的 20260913 源码上应用 Android 构建与 Sub 兼容补丁。"""
from pathlib import Path
import re
import shutil
import sys

engine = Path(sys.argv[1]).resolve()
root = Path(__file__).resolve().parent

# 发布源码含原仓库的子模块指针，但不含 .git/modules；构建版本探测不能追踪它们。
for git_pointer in engine.rglob('.git'):
    if git_pointer.is_file():
        git_pointer.unlink()


def replace(path, before, after):
    target = engine / path
    text = target.read_text(encoding='utf-8-sig')
    if after in text and (before in after or before not in text):
        return
    if before not in text:
        raise RuntimeError(f'补丁上下文不匹配：{path}: {before[:80]}')
    target.write_text(text.replace(before, after), encoding='utf-8')



# 升级旧构建缓存中的文字快路径，保持后续 replace 校验可重复执行。
_renderer = engine / 'frameworks/LSTG/Renderer.cpp'
_renderer_text = _renderer.read_text(encoding='utf-8-sig')

_renderer_text = _renderer_text.replace('    const bool glyphBatch = p->getLabelType() == ResFont::LabelType::TTF &&', '    const bool glyphBatch = (p->getLabelType() == ResFont::LabelType::TTF || p->getLabelType() == ResFont::LabelType::BMFONT) &&')

_renderer_text = _renderer_text.replace('        const auto key = std::string("android:glyph:")+p->getRenderMode()->getName();\n        auto* mode = RenderMode::getByName(key);\n        if (!mode) {\n            mode = p->getRenderMode()->clone(key);\n            mode->setProgram(backend::Program::getBuiltinProgram(backend::ProgramType::LABEL_NORMAL));\n            mode->setColor("u_textColor", Color4B::WHITE);\n        }\n        updateRenderMode(mode);', '        auto* mode = p->getRenderMode();\n        if (p->getLabelType() == ResFont::LabelType::TTF) {\n            const auto key = std::string("android:glyph:")+mode->getName();\n            auto* glyphMode = RenderMode::getByName(key);\n            if (!glyphMode) {\n                glyphMode = mode->clone(key);\n                glyphMode->setProgram(backend::Program::getBuiltinProgram(backend::ProgramType::LABEL_NORMAL));\n                glyphMode->setColor("u_textColor", Color4B::WHITE);\n            }\n            mode = glyphMode;\n        }\n        updateRenderMode(mode);')

if _renderer_text != _renderer.read_text(encoding='utf-8-sig'):
    _renderer.write_text(_renderer_text, encoding='utf-8')

replace('CMakeLists.txt', 'set(CC_USE_GFX LSTGX_USE_GFX)', 'set(CC_USE_GFX ${LSTGX_USE_GFX})')
_luajit_cmake = engine / 'frameworks/cocos2d-x/external/lua/luajit/CMakeLists.txt'
_luajit_text = _luajit_cmake.read_text()
if 'if(ANDROID AND BOSSRUSH_LUAJIT_LIBRARY)' not in _luajit_text:
    _luajit_cmake.write_text(_luajit_text + '''
if(ANDROID AND BOSSRUSH_LUAJIT_LIBRARY)
  get_filename_component(BOSSRUSH_LUAJIT_INCLUDE "${BOSSRUSH_LUAJIT_LIBRARY}" DIRECTORY)
  set_target_properties(luajit PROPERTIES IMPORTED_LOCATION "${BOSSRUSH_LUAJIT_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${BOSSRUSH_LUAJIT_INCLUDE}")
endif()
''')
# OpenAL 已支持 MONO8/STEREO8；旧解码器却在读取原作 PCM8 音效前将其拒绝。
replace('frameworks/Audio/AudioDecoderWav.cpp',
        'if (bit_depth != 16)', 'if (bit_depth != 8 && bit_depth != 16)')
replace('frameworks/Audio/AudioDecoderWav.cpp',
        'only support 16bit format, got ', 'only support 8/16bit PCM format, got ')
# 应用按 Choreographer 的显示时钟请求60帧；不能再在 GL 线程里叠加 Thread.sleep。
renderer_java = 'frameworks/cocos2d-x/cocos/platform/android/java/src/org/cocos/lib/CocosRenderer.java'
replace(renderer_java, '    private long mLastTickInNanoSeconds;', '''    private static volatile boolean externalFramePacing;
    public static void setExternalFramePacing(boolean enabled) { externalFramePacing = enabled; }
    private long mLastTickInNanoSeconds;''')
replace(renderer_java,
        'if (CocosRenderer.sAnimationInterval > CocosRenderer.FPS_CONTROL_THRESHOLD)',
        'if (!externalFramePacing && CocosRenderer.sAnimationInterval > CocosRenderer.FPS_CONTROL_THRESHOLD)')
replace('frameworks/LSTG/Object/GameObjectPropertyHash.cpp',
        '//#define PROP_OLD_STYLE', '#define PROP_OLD_STYLE')
replace('frameworks/LSTG/Object/GameObjectPropertyHash.cpp',
        '\t{ "res",\tGameObjectProperty::RES\t\t},',
        '\t// Sub 的 res 是普通 Lua 字段；游戏用它保存后处理纹理名。')
replace('frameworks/LSTG/Object/GameObjectPropertyHash.cpp', '''GameObjectProperty lstg::GameObjectPropertyHash(const char* key)
{
\tconst auto hash = ((const uint32_t*)key)[HASH_OFFSET];
\tconst auto it = prop_hash_map.find(hash);
\tif (it != prop_hash_map.end())
\t\treturn it->second;
\treturn GameObjectProperty::_KEY_NOT_FOUND;
}''', '''GameObjectProperty lstg::GameObjectPropertyHash(const char* key)
{
    const auto it = prop_map.find(key);
    return it != prop_map.end() ? it->second : GameObjectProperty::_KEY_NOT_FOUND;
}''')
replace('frameworks/LSTG/Object/GameObjectPropertyHash.cpp', '''\t// hack into lua
\tconst auto hash = ((const uint32_t*)s)[HASH_OFFSET];
\tconst auto it = prop_hash_map.find(hash);
\tif (it != prop_hash_map.end())
\t\treturn it->second;
\treturn GameObjectProperty::_KEY_NOT_FOUND;''', '\treturn GameObjectPropertyHash(s);')
replace('CMakeLists.txt', 'project(${APP_NAME})',
        'project(${APP_NAME})\ninclude_directories("${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cocos2d-x/external/glad/include")')
replace('frameworks/cocos2d-x/external/CMakeLists.txt', 'configure_target_outdir(common)',
        'if(TARGET common)\n    configure_target_outdir(common)\nendif()')
replace('frameworks/cocos2d-x/external/openal/common/alstring.cpp',
        'namespace al {', '''namespace al {
// NDK r26 libc++ 尚未提供 lexicographical_compare_three_way。
template<class I, class J, class Compare>
auto androidLexCompare3(I first, I last, J other, J end, Compare compare) -> std::weak_ordering {
    for (; first != last && other != end; ++first, ++other) {
        auto result = compare(*first, *other);
        if (result != 0) return result;
    }
    return first == last ? (other == end ? std::weak_ordering::equivalent : std::weak_ordering::less)
                         : std::weak_ordering::greater;
}''')
replace('frameworks/cocos2d-x/external/openal/common/alstring.cpp',
        'return std::lexicographical_compare_three_way(', 'return androidLexCompare3(')
replace('frameworks/cocos2d-x/external/openal/common/alformat.hpp',
        '|| !__has_include(<format>)', '|| defined(__ANDROID__) || !__has_include(<format>)')
replace('frameworks/cocos2d-x/cocos/platform/android/java/src/org/cocos/lib/CocosGLSurfaceView.java',
        'this.setEGLContextClientVersion(2);', 'this.setEGLContextClientVersion(3);')
replace('frameworks/cocos2d-x/cocos/platform/android/java/src/org/cocos/lib/CocosGLSurfaceView.java',
        'this.setEGLContextClientVersion(3);',
        'this.setEGLContextClientVersion(3);\n        this.setPreserveEGLContextOnPause(true);')
replace('frameworks/cocos2d-x/cocos/platform/android/CCGLViewImpl-android.cpp',
        'auto desiredApi = cc::gfx::API::VULKAN;', 'auto desiredApi = cc::gfx::API::GLES3;')
replace('frameworks/cocos2d-x/cocos/platform/android/CCGLViewImpl-android.cpp',
        'bool GLViewImpl::initWithFullScreen(std::string_view viewName)\n{\n    return true;\n}',
        'bool GLViewImpl::initWithFullScreen(std::string_view viewName)\n{\n    return initWithRect(viewName, Rect::ZERO, 1.0f, false);\n}')
replace('frameworks/cocos2d-x/cocos/platform/android/CCGLViewImpl-android.cpp',
        'agent->setMultithreaded(configMT.asBool());', 'agent->setMultithreaded(false);')
replace('frameworks/cocos2d-x/cocos/platform/android/CCGLViewImpl-android.cpp',
        'if (agent && configMT.getType() == Value::Type::BOOLEAN)', 'if (agent)')
replace('frameworks/cocos2d-x/cocos/platform/android/javaactivity-android.cpp',
        '#include "platform/android/CCGLViewImpl-android.h"',
        '#include "platform/android/CCGLViewImpl-android.h"\n#ifdef CC_USE_GFX\n#include "renderer/backend/gfx/DeviceGFX.h"\n#endif')
replace('frameworks/cocos2d-x/cocos/platform/android/javaactivity-android.cpp',
        '#include "base/CCDirector.h"', '#include "base/CCDirector.h"\nvoid androidApplySwapInterval();')
replace('frameworks/cocos2d-x/cocos/platform/android/javaactivity-android.cpp',
        'glView->setFrameSize(w, h);',
        'glView->setFrameSize(w, h);\n#ifdef CC_USE_GFX\n        cocos2d::backend::DeviceGFX::setSwapchainInfo(nullptr, true, w, h);\n#endif')
replace('frameworks/cocos2d-x/cocos/platform/android/javaactivity-android.cpp',
        '    cocos2d::Application::getInstance()->applicationScreenSizeChanged(w, h);', '''    if (w <= 0 || h <= 0) return;
    auto* view = cocos2d::Director::getInstance()->getOpenGLView();
    if (view) {
        // Android 默认回调为空；系统栏、旋转及渲染档位改变后必须更新真实画布。
        view->setFrameSize(w, h);
#ifdef CC_USE_GFX
        cocos2d::backend::DeviceGFX::setSwapchainInfo(nullptr, true, w, h);
#endif
    }
    cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("glview_window_resized");
    cocos2d::Application::getInstance()->applicationScreenSizeChanged(w, h);''')
replace('frameworks/cocos2d-x/cocos/platform/android/javaactivity-android.cpp',
        '    cocos2d::Application::getInstance()->applicationScreenSizeChanged(w, h);',
        '    cocos2d::Application::getInstance()->applicationScreenSizeChanged(w, h);\n    androidApplySwapInterval();')

# GLSurfaceView 已拥有 EGL 上下文及窗口，GFX 必须借用，不能再次创建或再次交换同一 Surface。
gpu = 'frameworks/cocos2d-x/external/gfx/backend/gfx-gles3/GLES3GPUContext.cpp'
replace('frameworks/cocos2d-x/external/gfx/backend/gfx-gles3/GLES3GPUObjects.h',
        'EGLint eglMajorVersion{0};', 'bool androidBorrowedContext{false};\n    EGLint eglMajorVersion{0};')
replace(gpu, '''    EGL_CHECK(eglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY));''', '''#if CC_PLATFORM == CC_PLATFORM_ANDROID
    if (eglGetCurrentContext() != EGL_NO_CONTEXT) {
        androidBorrowedContext = true;
        eglDisplay = eglGetCurrentDisplay();
        eglDefaultContext = eglGetCurrentContext();
        eglDefaultSurface = eglGetCurrentSurface(EGL_DRAW);
        EGLint configId = 0, count = 0;
        eglQueryContext(eglDisplay, eglDefaultContext, EGL_CONFIG_ID, &configId);
        const EGLint attributes[] = { EGL_CONFIG_ID, configId, EGL_NONE };
        eglChooseConfig(eglDisplay, attributes, &eglConfig, 1, &count);
        _extensions = StringUtil::split(eglQueryString(eglDisplay, EGL_EXTENSIONS), " ");
        _sharedContexts[std::hash<std::thread::id>{}(std::this_thread::get_id())] = eglDefaultContext;
        bindContext(true);
        return true;
    }
#endif
    EGL_CHECK(eglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY));''')
replace(gpu, 'void GLES3GPUContext::destroy() {', '''void GLES3GPUContext::destroy() {
    if (androidBorrowedContext) { _sharedContexts.clear(); return; }''')
replace(gpu, 'void GLES3GPUContext::present(const GLES3GPUSwapchain *swapchain) {',
        'void GLES3GPUContext::present(const GLES3GPUSwapchain *swapchain) {\n    if (androidBorrowedContext) return;')
swap = 'frameworks/cocos2d-x/external/gfx/backend/gfx-gles3/GLES3Swapchain.cpp'
replace(swap, '    _gpuSwapchain = ccnew GLES3GPUSwapchain;', '''    _gpuSwapchain = ccnew GLES3GPUSwapchain;
    if (context->androidBorrowedContext) {
        _gpuSwapchain->eglSurface = context->eglDefaultSurface;
    } else {''')
replace(swap, '    switch (_vsyncMode) {', '    }\n    switch (_vsyncMode) {')
replace(swap, 'void GLES3Swapchain::doDestroySurface() {', '''void GLES3Swapchain::doDestroySurface() {
    if (GLES3Device::getInstance()->context()->androidBorrowedContext) {
        _gpuSwapchain->eglSurface = EGL_NO_SURFACE; return;
    }''')

# 光栅 shader 只需 GLES 3.0；硬编码 310 会让 Mac 模拟器的硬件 GPU 编译失败。
replace('frameworks/cocos2d-x/cocos/renderer/backend/gfx/ProgramGFX.cpp',
        's.source = UtilsGFX::compileSPIRVtoGLSL(spirvCodes[stage.stage], 310, true);',
        '''const auto version = stage.stage == gfx::ShaderStageFlagBit::COMPUTE ? 310 : 300;
            s.source = UtilsGFX::compileSPIRVtoGLSL(spirvCodes[stage.stage], version, true);''')

# GLES 3 支持 NPOT 循环采样；修改描述符后必须更新真正绑定的不可变 sampler。
texture_gfx = 'frameworks/cocos2d-x/cocos/renderer/backend/gfx/TextureGFX.cpp'
replace(texture_gfx, 'const bool isPow2 = ISPOW2(_width) && ISPOW2(_height);',
        '''const auto api = gfx::Device::getInstance()->getGfxAPI();
    const bool legacy = api == gfx::API::GLES2 || api == gfx::API::WEBGL;
    const bool isPow2 = !legacy || (ISPOW2(_width) && ISPOW2(_height));''')
replace(texture_gfx, '_sinfo.addressW   = _sinfo.addressU;',
        '''_sinfo.addressW   = _sinfo.addressU;
    _sampler = gfx::Device::getInstance()->getSampler(_sinfo);''')

# 按文本复用仍空闲的 Label，避免 LIFO 每帧将稳定菜单文字换到另一份 Label 上重排。
replace('frameworks/Classes/LabelPool.cpp', '''			auto ret = it->second.back();
			it->second.popBack();''', '''            auto ret = it->second.back();
            for (auto* candidate : it->second) {
                if (candidate->getString() == str) { ret = candidate; break; }
            }
            it->second.eraseObject(ret);''')
replace('frameworks/LSTG/Renderer.cpp', '#include "Renderer.h"', '#include "Renderer.h"\n#include "compat.h"')
replace('frameworks/LSTG/RenderMode.cpp',
        'desc.destinationAlphaBlendFactor = backend::BlendFactor::ONE_MINUS_SRC_ALPHA;',
        '''desc.destinationAlphaBlendFactor =
        funcSrc == backend::BlendFactor::ONE && funcDst == backend::BlendFactor::ZERO
            ? backend::BlendFactor::ZERO : backend::BlendFactor::ONE_MINUS_SRC_ALPHA;''')
replace('frameworks/LSTG/Renderer.cpp', 'auto label = labelPool.getWithResFont(p, str);',
        '''const auto textT0 = androidProfileText ? androidNow() : 0.;
    auto label = labelPool.getWithResFont(p, str);
    const auto textT1 = androidProfileText ? androidNow() : 0.;''')
replace('frameworks/LSTG/Renderer.cpp', 'label->visit(pRenderer, proj.getInversed()*currentProjection, 0);',
        '''const auto textT2 = androidProfileText ? androidNow() : 0.;
    label->visit(pRenderer, proj.getInversed()*currentProjection, 0);
    if (androidProfileText) {
        androidTextTime[0] += textT1-textT0;
        androidTextTime[1] += textT2-textT1;
        androidTextTime[2] += androidNow()-textT2;
        ++androidTextCalls;
    }''')

# 空文本不进入Label缓存：CCLabel::alignText的空串分支不会清理上一段文字的atlas顶点。
replace('frameworks/LSTG/Renderer.cpp',
        'float x, float y, float width, float height, float scaleX, float scaleY)noexcept\n{',
        'float x, float y, float width, float height, float scaleX, float scaleY)noexcept\n{\n    if (str.empty()) return true;')

# Label::draw 已通过 _blendFunc 绘制整批字形，无须创建每个字的 Sprite 来改混合模式。
replace('frameworks/LSTG/Renderer.cpp', '''	label->setBlendFunc(func);
	if (p->getLabelType() == ResFont::LabelType::TTF)
	{
		// for TTF
		for (int i = 0; i < label->getStringLength(); ++i)
		{
			auto sp = label->getLetter(i);
			if (sp)
				sp->setBlendFunc(func);
		}
	}
	else''', '''    if (label->getBlendFunc() != func) label->setBlendFunc(func);
    if (p->getLabelType() != ResFont::LabelType::TTF)''')

# 普通 TTF 直接提交字库中的四边形，避免每一行文字独立 visit 和更新 GPU buffer。
# 描边、阴影、发光、系统字体等继续由 Cocos Label 绘制。
replace('frameworks/cocos2d-x/cocos/2d/CCLabel.h', 'virtual void updateContent();', '''virtual void updateContent();
    const Vector<SpriteBatchNode*>& androidGlyphBatches() {
        if (_systemFontDirty || _contentDirty) updateContent();
        return _batchNodes;
    }''')
replace('frameworks/LSTG/Renderer.cpp', '//#define BATCH_COMMAND', '#define BATCH_COMMAND')
# 连续同材质的精灵仍按原顺序合并；8192小于16位索引和Cocos VBO上限，减少微小命令块。
replace('frameworks/LSTG/Renderer.cpp', 'constexpr int limit = 512;', 'constexpr int limit = 8192;')
replace('frameworks/LSTG/Renderer.cpp', '#include "Global.h"', '#include "sprite_clip.h"\n#include "Global.h"')
replace('frameworks/LSTG/Renderer.cpp', '\tLMP.clear();\n\tRenderMode::modeMap.clear();',
        '\tLMP.clear();\n    androidResetSpriteClipping();\n\tRenderMode::modeMap.clear();')
replace('frameworks/LSTG/Renderer.cpp', '''void XRenderer::addXTCommand(XTrianglesCommand* cmd)
{
\tCCASSERT(bRenderStarted, "not in render!");''', '''void XRenderer::addXTCommand(XTrianglesCommand* cmd)
{
    CCASSERT(bRenderStarted, "not in render!");
    if (androidClipSprites && cmd->getVertexCount()==4 && cmd->getDesc()->programState->getCallbackUniforms().empty()) {
        const auto& projection=cmd->isSkipModelView() ? currentProjection : currentProjection*(*cmd->getMV());
        if (androidSpriteOutside(cmd->getVertices(),projection,cmd->getDesc()->programState->getProgram())) return;
    }''')
replace('frameworks/LSTG/Renderer.cpp', 'const auto size = triToDraw.size();',
        'const auto size = triToDraw.size();\n    if (androidProfileBatches) androidRecordSpriteBatch(size);')
# 完整覆盖缓冲区时允许驱动更换存储，避免等待上一帧的GPU读取；部分更新保留其余字节。
_gles_commands='frameworks/cocos2d-x/external/gfx/backend/gfx-gles3/GLES3Commands.cpp'
replace(_gles_commands,
        'static void uploadBufferData(GLenum target, GLintptr offset, GLsizeiptr length, const void *buffer) {',
        'static void uploadBufferData(GLenum target, GLintptr offset, GLsizeiptr length, const void *buffer, GLsizeiptr capacity) {')
replace(_gles_commands, '''    //NOTE: do not use GL_MAP_INVALIDATE_BUFFER_BIT here since it can be partially updated
    GL_CHECK(dst = glMapBufferRange(target, offset, length, GL_MAP_WRITE_BIT | GL_MAP_INVALIDATE_RANGE_BIT));''',
        '''    const auto invalidate = offset==0 && length==capacity ? GL_MAP_INVALIDATE_BUFFER_BIT : GL_MAP_INVALIDATE_RANGE_BIT;
    GL_CHECK(dst = glMapBufferRange(target, offset, length, GL_MAP_WRITE_BIT | invalidate));''')
for _buffer_target in ['GL_ARRAY_BUFFER','GL_ELEMENT_ARRAY_BUFFER','GL_UNIFORM_BUFFER','GL_SHADER_STORAGE_BUFFER']:
    replace(_gles_commands, f'uploadBufferData({_buffer_target}, offset, size, buffer);',
            f'uploadBufferData({_buffer_target}, offset, size, buffer, gpuBuffer->size);')
# 雾切换复用默认状态的存储；普通setProgram仍保留原有重建语义。
replace('frameworks/LSTG/RenderMode.h',
        'void setProgram(cocos2d::backend::Program* program);',
        'void setProgram(cocos2d::backend::Program* program);\n        void setProgramCached(cocos2d::backend::Program* program);')
replace('frameworks/LSTG/RenderMode.h',
        'cocos2d::backend::ProgramState* defaultState = nullptr;',
        '''cocos2d::backend::ProgramState* defaultState = nullptr;
        bool androidReuseProgramState = false;
        cocos2d::Map<cocos2d::backend::Program*, cocos2d::backend::ProgramState*> androidProgramStates;''')
replace('frameworks/LSTG/RenderMode.cpp', '#include "RenderMode.h"',
        '#include "RenderMode.h"\n#include "compat.h"')
replace('frameworks/LSTG/RenderMode.cpp', 'void RenderMode::setProgram(Program* program)',
        '''void RenderMode::setProgramCached(Program* program)
{
    if (!program || program == _program) return;
    if (defaultState) androidProgramStates.insert(_program, defaultState);
    androidReuseProgramState = true;
    setProgram(program);
    androidReuseProgramState = false;
}

void RenderMode::setProgram(Program* program)''')
replace('frameworks/LSTG/RenderMode.cpp',
        'defaultState = new backend::ProgramState(_program);',
        '''if (androidReuseProgramState && androidProgramStates.find(_program) != androidProgramStates.end()) {
        defaultState = androidProgramStates.at(_program);
        defaultState->retain();
        ++androidFogStatesReused;
    } else {
        defaultState = new backend::ProgramState(_program);
        if (androidReuseProgramState) ++androidFogStatesCreated;
    }''')
replace('frameworks/LSTG/RenderMode.cpp',
        'defaultState->getVertexUniformBuffer(&vertUniformBuffer, vertUniformBufferSize);',
        '''defaultState->getVertexUniformBuffer(&vertUniformBuffer, vertUniformBufferSize);
    // 与新建ProgramState的零初始化一致，不能带回上一帧/另一套雾的uniform。
    if (androidReuseProgramState) {
        if (fragUniformBuffer) std::memset(fragUniformBuffer, 0, fragUniformBufferSize);
        if (vertUniformBuffer) std::memset(vertUniformBuffer, 0, vertUniformBufferSize);
    }''')
# 普通精灵已在入队前变换顶点。合批不能再次乘对象池中可能残留的模型矩阵。
replace('frameworks/LSTG/Renderer.cpp',
        'xtc->getMV()->transformPoint(&(_verts.back().vertices));',
        'if (!xtc->isSkipModelView()) xtc->getMV()->transformPoint(&(_verts.back().vertices));')
replace('frameworks/LSTG/Renderer.cpp',
        '*cmd->getMV() = Mat4::IDENTITY;', '*cmd->getMV() = Mat4::IDENTITY;\n    cmd->setSkipModelView(true);')
replace('frameworks/LSTG/Renderer.cpp', '''	renderTargetStack.pop_back();
	rt->end();

	return true;''', '''    renderTargetStack.pop_back();
    rt->end();
    // Sub 的 PopRenderTarget 保持当前视口/投影；Cocos 会恢复进入 RT 前的值。
    const auto viewport = currentVP;
    const auto projection = currentProjection;
    pushCallbackCommand([this, viewport, projection]() {
        pRenderer->setViewPort(viewport.x, viewport.y, viewport.w, viewport.h);
        Director::getInstance()->loadMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION, projection);
    });
    return true;''')
replace('frameworks/LSTG/Renderer.cpp', '''	const auto mt = currentProjection;
	pushCallbackCommand([=]()
	{
		// RenderTexture::onEnd will restore viewport to default, set again
		pRenderer->setViewPort(currentVP.x, currentVP.y, currentVP.w, currentVP.h);''', '''    const auto mt = currentProjection;
    const auto viewport = currentVP;
    pushCallbackCommand([this, mt, viewport]()
    {
        // 捕获调用时的视口，不能延迟读取下一次 SetViewMode 改写后的 currentVP。
        pRenderer->setViewPort(viewport.x, viewport.y, viewport.w, viewport.h);''')
replace('frameworks/LSTG/Renderer.cpp', '#include "compat.h"',
        '#include "compat.h"\n#include "2d/CCSpriteBatchNode.h"\n#include "renderer/CCTextureAtlas.h"\n#include "renderer/backend/Program.h"')
replace('frameworks/LSTG/Renderer.cpp', '''	flushTriangles();
	updateRenderMode(p->getRenderMode());

	// use temprary label''', '''    const bool glyphBatch = (p->getLabelType() == ResFont::LabelType::TTF || p->getLabelType() == ResFont::LabelType::BMFONT) &&
        !p->isOutlined() && !p->isShadowed() && !p->isGlowed() && !p->isBold() &&
        !p->isUnderlined() && !p->isStrikethrough() && !p->getTTFConfig().distanceFieldEnabled;
    if (!glyphBatch) {
        flushTriangles();
        updateRenderMode(p->getRenderMode());
    }

    // use temprary label''')
replace('frameworks/LSTG/Renderer.cpp', '''	//label->visit(pRenderer, Mat4::IDENTITY, 0);''', '''    if (glyphBatch) {
        auto* mode = p->getRenderMode();
        if (p->getLabelType() == ResFont::LabelType::TTF) {
            const auto key = std::string("android:glyph:")+mode->getName();
            auto* glyphMode = RenderMode::getByName(key);
            if (!glyphMode) {
                glyphMode = mode->clone(key);
                glyphMode->setProgram(backend::Program::getBuiltinProgram(backend::ProgramType::LABEL_NORMAL));
                glyphMode->setColor("u_textColor", Color4B::WHITE);
            }
            mode = glyphMode;
        }
        updateRenderMode(mode);
        const auto& batches = label->androidGlyphBatches();
        const auto transform = label->getNodeToParentTransform();
        const auto color = p->getColor();
        for (auto* batch : batches) {
            auto* atlas = batch->getTextureAtlas();
            for (ssize_t i = 0; i < atlas->getTotalQuads(); ++i) {
                auto* quad = LMP.getQuad();
                *quad = atlas->getQuads()[i];
                for (auto* v : { &quad->tl, &quad->tr, &quad->bl, &quad->br }) {
                    transform.transformPoint(&v->vertices);
                    v->colors.r = (v->colors.r*color.r+127)/255;
                    v->colors.g = (v->colors.g*color.g+127)/255;
                    v->colors.b = (v->colors.b*color.b+127)/255;
                    v->colors.a = (v->colors.a*color.a+127)/255;
                }
                renderTexture(atlas->getTexture(), quad);
            }
        }
        return true;
    }
    //label->visit(pRenderer, Mat4::IDENTITY, 0);''')

# 位图文字同样把颜色乘进最终顶点，Label 本身保持白色，防止透明度被乘两次。
replace('frameworks/LSTG/Renderer.cpp',
        '\t\tlabel->setOpacity(p->getColor().a);\n\t\tlabel->setColor(Color3B(p->getColor()));',
        '''        const auto fontColor = glyphBatch ? Color4B::WHITE : p->getColor();
        label->setOpacity(fontColor.a);
        label->setColor(Color3B(fontColor));''')

# uniform setters 原本逐字段同步上传 GPU（文字每帧上千次）。在 CPU 合并字段，
# 真正绑定该 uniform block 时一次提交；相同数据不重复上传。仅作用于 CPU 写入的 UBO。
buffer_h = 'frameworks/cocos2d-x/cocos/renderer/backend/gfx/BufferGFX.h'
buffer_cpp = 'frameworks/cocos2d-x/cocos/renderer/backend/gfx/BufferGFX.cpp'
replace(buffer_h, '#include "renderer/backend/Buffer.h"',
        '#include "renderer/backend/Buffer.h"\n#include <vector>')
replace(buffer_h, 'cc::gfx::Buffer* getHandler() const { return _buffer; }',
        'cc::gfx::Buffer* getHandler() const { flushAndroidUniforms(); return _buffer; }')
replace(buffer_h, 'void updateInfo();', '''void updateInfo();
    void flushAndroidUniforms() const;
    mutable std::vector<unsigned char> _androidUniformData;
    mutable bool _androidUniformDirty = false;''')
replace(buffer_cpp, '#include <cassert>', '#include <cassert>\n#include <cstring>')
replace(buffer_cpp, "    // NOTE: 'offset' requires modified gfx\n    _buffer->update(data, size, offset);", '''    if (_buffer->getUsage() == gfx::BufferUsageBit::UNIFORM) {
        if (_androidUniformData.empty()) {
            _androidUniformData.resize(_size, 0);
            _androidUniformDirty = true;
        }
        auto* destination = _androidUniformData.data()+offset;
        if (std::memcmp(destination, data, size)) {
            std::memcpy(destination, data, size);
            _androidUniformDirty = true;
        }
        return;
    }
    // NOTE: 'offset' requires modified gfx
    _buffer->update(data, size, offset);''')
replace(buffer_cpp, 'CC_BACKEND_END', '''void BufferGFX::flushAndroidUniforms() const {
    if (_androidUniformDirty && _buffer) {
        _buffer->update(_androidUniformData.data(), _androidUniformData.size(), 0);
        _androidUniformDirty = false;
    }
}

CC_BACKEND_END''')

for relative in ['frameworks/LSTG/Resource/ResFont.cpp', 'frameworks/LSTG/Resource/ResFont.h']:
    replace(relative, 'unordered_map<char, GlyphInfo>', 'unordered_map<uint32_t, GlyphInfo>')
replace('frameworks/LSTG/Resource/ResFont.cpp', '\t\t\tchar c;', '\t\t\tuint32_t c = 0;')
replace('frameworks/LSTG/Resource/ResFont.cpp',
        '&c, &x, &y, &w, &h, &left_offset, &right_offset',
        'reinterpret_cast<char*>(&c), &x, &y, &w, &h, &left_offset, &right_offset')
replace('frameworks/LSTG/Resource/ResFont.cpp', 'c = static_cast<char>(c_hex);',
        'c = static_cast<uint32_t>(c_hex);')
target = engine / 'CMakeLists.txt'
text = target.read_text()
marker = '# Boss Rush HD Android bridge'
if marker not in text:
    target.write_text(text + '\n' + marker + '\nif(ANDROID)\n'
                      '  target_sources(cocos2dlua PRIVATE android/bridge.cpp android/compat.cpp)\n'
                      '  target_include_directories(cocos2dlua PRIVATE android)\nendif()\n')
copy = engine / 'android'
copy.mkdir(exist_ok=True)
for p in (root / 'native').glob('*'):
    shutil.copy2(p, copy / p.name)

replace('frameworks/LSTG/Object/GameObject.h', 'bool hide = false;',
        'bool hide = false;\n\t\tint androidWorld = 15;\n\t\tbool androidNoPause = false;\n\t\tbool androidFrozen = false;')
replace('frameworks/LSTG/Object/GameObject.cpp', 'hide = false;\n\ttimer = 0;',
        'hide = false;\n\tandroidWorld = 15; androidNoPause = false; androidFrozen = false;\n\ttimer = 0;')
manager = 'frameworks/LSTG/Object/GameObjectManager.cpp'
# LuaJIT 在 Android 上用外部展开传播 Lua 错误；Lua 回调跨越 noexcept 会直接终止进程。
for relative in ['frameworks/LSTG/Object/GameObjectManager.cpp', 'frameworks/LSTG/Object/GameObjectManager.h']:
    target = engine / relative
    source = target.read_text(encoding='utf-8-sig')
    updated = re.sub(r'\bnoexcept\b', '', source)
    if updated != source:
        target.write_text(updated)
replace(manager, '#include "GameObjectManager.h"', '#include "GameObjectManager.h"\n#include "compat.h"')
replace(manager, 'if (!p1->colli || !p2->colli)',
        'if (!(p1->androidWorld & p2->androidWorld) || !p1->colli || !p2->colli)')
replace(manager, 'inDoFrame = true;\n\tGetObjectTable(L);',
        'inDoFrame = true;\n\tandroidCurrentSuperPause = androidSuperPause;\n'
        '\tif (androidSuperPause > 0) --androidSuperPause;\n\tGetObjectTable(L);')
replace(manager, 'currentObj = p;\n\t\tif (p->cls->isDefaultFrame)',
        'p->androidFrozen = androidCurrentSuperPause > 0 && !p->androidNoPause;\n'
        '\t\tif (p->androidFrozen) continue;\n\t\tcurrentObj = p;\n\t\tif (p->cls->isDefaultFrame)')
replace(manager, 'if (!p->hide)\n\t\t{\n\t\t\tcurrentObj = p;',
        'if (!p->hide && (p->androidWorld & androidWorldFlag))\n\t\t{\n\t\t\tcurrentObj = p;')
replace(manager, 'p->timer++;\n\t\tp->cm->updateAni();\n\t\tp->ani_timer++;',
        'if (!p->androidFrozen) {\n\t\t\tp->timer++;\n\t\t\tp->cm->updateAni();\n\t\t\tp->ani_timer++;\n\t\t}')
# 世界位和超级暂停必须进入原生对象属性，不能只给 Lua 空实现。
p = engine / manager
text = p.read_text()
key = 'const char* key = luaL_checklstring(L, 2, &strlen);'
get, set_ = text.split('int GameObjectManager::SetAttr(lua_State* L)', 1)
if 'strcmp(key, "world")' not in get:
    get = get.replace(key, key + '\n\tif (!strcmp(key, "world")) { lua_pushinteger(L, p->androidWorld); return 1; }'
                      '\n\tif (!strcmp(key, "nopause")) { lua_pushboolean(L, p->androidNoPause); return 1; }')
if 'strcmp(key, "world")' not in set_:
    set_ = set_.replace(key, key + '\n\tif (!strcmp(key, "world")) { p->androidWorld = luaL_checkinteger(L, 3); return 0; }'
                       '\n\tif (!strcmp(key, "nopause")) { p->androidNoPause = lua_toboolean(L, 3); return 0; }')
updated = get + 'int GameObjectManager::SetAttr(lua_State* L)' + set_
if updated != text:
    p.write_text(updated)
pool = 'frameworks/LSTG/Object/GameObjectPool.cpp'
p = engine / pool
text = p.read_text(encoding='utf-8-sig')
if 'if (!obj[i]->androidFrozen)' not in text:
    a, b = text.split('void GameObjectPool::update(size_t begin, size_t end)', 1)
    body, rest = b.split('cocos2d::Vec2 GameObjectPool::getPosition', 1)
    body = body.replace('for (auto i = begin; i < end; ++i)\n',
                        'for (auto i = begin; i < end; ++i)\n\t\tif (!obj[i]->androidFrozen)\n')
    p.write_text(a + 'void GameObjectPool::update(size_t begin, size_t end)' + body +
                 'cocos2d::Vec2 GameObjectPool::getPosition' + rest)
# 空分组没有回调；无需创建 Lua 栈记录或唤醒工作线程。
replace('frameworks/LSTG/Object/GameObjectManager.h',
        'size_t GetObjectCount()  { return pool.size(); }',
        'size_t GetObjectCount()  { return pool.size(); }\n'
        '        const std::set<GameObject*, less_obj>& androidCollisionGroup(size_t group) const { return colliList[group]; }')
replace(manager, '''void GameObjectManager::CollisionCheck(size_t groupA, size_t groupB)
{
\tif (!checkGroupID(groupA) || !checkGroupID(groupB))
\t\tluaL_error(L, "Invalid collision group.");''', '''void GameObjectManager::CollisionCheck(size_t groupA, size_t groupB)
{
    if (!checkGroupID(groupA) || !checkGroupID(groupB))
        luaL_error(L, "Invalid collision group.");
    if (colliList[groupA].empty() || colliList[groupB].empty()) return;''')
# 小任务仍先完成全部命中检测，再执行回调，与线程路径保持同样的快照语义。
# 升级本轮旧缓存；回调可嵌套发起碰撞，命中结果须由当前调用独占。
_manager_path=engine / manager
_manager_text=_manager_path.read_text()
_previous_hits='''                static vector<size_t> hits;
                hits.clear();
                for (size_t j=0;j<size;++j)
                    if (::CollisionCheck(to_colli_lhs[j],to_colli_rhs[j])) hits.push_back(j);
                for (auto j : hits)
                    callBack(L,to_colli_lhs[j],to_colli_rhs[j],LGOBJ_CC_COLLI,ot_idx);'''
_current_hits='''                vector<std::pair<GameObject*,GameObject*>> hits;
                for (size_t j=0;j<size;++j)
                    if (::CollisionCheck(to_colli_lhs[j],to_colli_rhs[j])) hits.emplace_back(to_colli_lhs[j],to_colli_rhs[j]);
                for (const auto& hit : hits)
                    callBack(L,hit.first,hit.second,LGOBJ_CC_COLLI,ot_idx);'''
if _previous_hits in _manager_text:
    _manager_path.write_text(_manager_text.replace(_previous_hits,_current_hits))
replace(manager, '''\t\t\tconst auto size = to_colli_lhs.size();
\t\t\tauto dat_l = to_colli_lhs.data();''', '''            const auto size = to_colli_lhs.size();
            if (size < 2048) {
                vector<std::pair<GameObject*,GameObject*>> hits;
                for (size_t j=0;j<size;++j)
                    if (::CollisionCheck(to_colli_lhs[j],to_colli_rhs[j])) hits.emplace_back(to_colli_lhs[j],to_colli_rhs[j]);
                for (const auto& hit : hits)
                    callBack(L,hit.first,hit.second,LGOBJ_CC_COLLI,ot_idx);
                lua_pop(L,1);
                return;
            }
            auto dat_l = to_colli_lhs.data();''')
# 这些内部任务只处理独立对象/顶点。少量或零元素直接执行，避免创建三份空 future。
replace('frameworks/LSTG/Util/Utility.cpp', '''void lstg::deployThreadTaskAndWait(size_t taskSize, size_t nSlice, const std::function<void(int, int, int)>& task)
{
\tconst auto nThr = nSlice;''', '''void lstg::deployThreadTaskAndWait(size_t taskSize, size_t nSlice, const std::function<void(int, int, int)>& task)
{
    constexpr size_t serialTaskLimit=2048;
    if (!taskSize) return;
    if (taskSize<serialTaskLimit) { task(0,taskSize,0);return; }
    const auto nThr = nSlice;''')
# 自绘 ANM 不使用对象矩阵；自绘回调中的 DefaultRenderFunc 会按 dirty 标记惰性更新。
# 绑定节点和灯光仍保留预更新，避免改变它们的可见变换时机。
replace(manager, 'if (!p->hide/*&&p->isDefaultRender*/)',
        'if (!p->hide && (p->cls->isDefaultRender || p->cm->getBindNode() || p->cm->getLightSource()))')
print('已应用固定版本 Android 补丁')
