#!/usr/bin/env python3
"""只修正固定引擎的 macOS 构建入口；Sub 兼容补丁共用 Android 实现。"""
from pathlib import Path
import sys
root=Path(__file__).resolve().parent
engine=Path(sys.argv[1]).resolve()
def replace(path,before,after):
 p=engine/path;s=p.read_text(encoding='utf-8-sig')
 if after in s and (before in after or before not in s):return
 if before not in s:raise RuntimeError('补丁上下文不匹配：'+path)
 p.write_text(s.replace(before,after))
replace('CMakeLists.txt','include(CocosBuildSet)','enable_language(OBJC OBJCXX)\ninclude(CocosBuildSet)')
replace('CMakeSources.cmake','${RUNTIME_SRC_ROOT}/proj.ios_mac/mac/main.mm','"'+str(root/'native/main.mm')+'"')
replace('frameworks/LSTG/AppFrame.cpp','if (pos == root.size() - postfix.size())','if (false && pos == root.size() - postfix.size())')
replace('CMakeLists.txt','LINK_FLAGS "-pagezero_size 10000 -image_base 100000000"','LINK_FLAGS ""')
p=engine/'CMakeLists.txt';s=p.read_text();mark='# Boss Rush HD macOS bridge'
if mark not in s:
 s+='\n'+mark+'''
if(MACOSX)
  target_sources(${APP_NAME} PRIVATE android/compat.cpp)
  target_include_directories(${APP_NAME} PRIVATE android)
  set_target_properties(${APP_NAME} PROPERTIES OUTPUT_NAME BossRushHD)
endif()
'''
 p.write_text(s)

replace('frameworks/cocos2d-x/external/png/pngpriv.h','include <fp.h>','include <math.h>')

# 发布包中的 JPEG / libzip 只有 Intel 机器码，改用本机 ARM64 依赖并在打包时内嵌。
p=engine/'CMakeLists.txt';s=p.read_text();mark='# Boss Rush HD macOS dependencies'
if mark not in s:
 s+='\n'+mark+'''
if(MACOSX)
  target_compile_options(OpenAL PRIVATE -Wno-error=function-effects)
  find_library(BR_JPEG jpeg HINTS /opt/homebrew/opt/jpeg-turbo/lib /usr/local/opt/jpeg-turbo/lib REQUIRED)
  find_path(BR_JPEG_HEADERS jpeglib.h HINTS /opt/homebrew/opt/jpeg-turbo/include /usr/local/opt/jpeg-turbo/include REQUIRED)
  set_target_properties(jpeg PROPERTIES IMPORTED_LOCATION "${BR_JPEG}" INTERFACE_INCLUDE_DIRECTORIES "${BR_JPEG_HEADERS}")
  find_library(BR_ZIP zip HINTS /opt/homebrew/opt/libzip/lib /usr/local/opt/libzip/lib REQUIRED)
  find_path(BR_ZIP_HEADERS zip.h HINTS /opt/homebrew/opt/libzip/include /usr/local/opt/libzip/include REQUIRED)
  set_target_properties(ext_zip PROPERTIES IMPORTED_LOCATION "${BR_ZIP}" INTERFACE_INCLUDE_DIRECTORIES "${BR_ZIP_HEADERS}")
endif()
'''
 p.write_text(s)
replace('frameworks/cocos2d-x/cocos/platform/CCGL.h','#ifndef glDrawBuffer','#if !defined(CC_USE_METAL) && !defined(glDrawBuffer)')
replace('frameworks/cocos2d-x/cocos/platform/mac/CCGLViewImpl-mac.mm','#include <Metal/Metal.h>','#include <Metal/Metal.h>\n#import <Cocoa/Cocoa.h>')
p=engine/'frameworks/cocos2d-x/cocos/platform/mac/CCGLViewImpl-mac.mm';s=p.read_text();original=s
s=s.replace('GL_TRUE','GLFW_TRUE').replace('GL_FALSE','GLFW_FALSE')
for args in ['', 'int w, int h, int refreshRate','int monitorIndex','int monitorIndex, int w, int h, int refreshRate','GLFWmonitor* monitor, int w, int h, int refreshRate']:
 s=s.replace('GLViewImpl::setFullscreen('+args+')','GLViewImpl::setFullscreen('+args+(', ' if args else '')+'bool exclusive)')
if s!=original:p.write_text(s)
p=engine/'CMakeLists.txt';s=p.read_text();mark='# Boss Rush HD OpenAL fmt isolation'
if mark not in s:
 s+='\n'+mark+'''
foreach(t OpenAL alsoft.common)
 target_include_directories(${t} BEFORE PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cocos2d-x/external/openal/fmt-11.2.0/include")
endforeach()
'''
 p.write_text(s)
replace('frameworks/cocos2d-x/cocos/renderer/CCRenderer.cpp','    GlobalTriangleBufferPool.reuse();','''#ifdef CC_USE_GFX
    GlobalTriangleBufferPool.reuse();
#endif''')
replace('frameworks/cocos2d-x/cocos/renderer/CCRenderer.cpp','if (!c->isSkipModelView())','if (!cmd->isSkipModelView())')
# Metal 后端仍使用旧 hlookup 别名，统一到当前公共接口的标准容器。
for p in (engine/'frameworks/cocos2d-x/cocos/renderer/backend/metal').glob('*'):
 if p.suffix not in ('.h','.mm'):continue
 original=p.read_text();s=original.replace('hlookup::string_map<','std::unordered_map<std::string, ')
 s=s.replace('_attributeInfo.find(name)','_attributeInfo.find(std::string(name))')
 s=s.replace('_uniformInfos.find(name)','_uniformInfos.find(std::string(name))')
 if s!=original:p.write_text(s)
replace('frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm','_attributeInfo[name]','_attributeInfo[std::string(name)]')
replace('frameworks/cocos2d-x/external/yasio/detail/obstream.hpp','return *this->impl_;','return *this->outs_;')
p=engine/'CMakeLists.txt';s=p.read_text();mark='# Boss Rush HD custom audio'
if mark not in s:
 s+='\n'+mark+'\ntarget_compile_definitions(cocos2d PUBLIC CC_USE_AUDIOENGINE=0)\n'
 p.write_text(s)
replace('frameworks/cocos2d-x/cocos/audio/AudioDecoder.h','#include <stdint.h>','#include <stdint.h>\n#include "platform/CCPlatformMacros.h"')
replace('frameworks/cocos2d-x/cocos/audio/AudioEngineImpl.h','hlookup::string_map<std::unique_ptr<AudioCache>>','std::unordered_map<std::string, std::unique_ptr<AudioCache>>')
replace('frameworks/cocos2d-x/cocos/audio/AudioEngineImpl.cpp','_scheduler->unschedule(CC_SCHEDULE_SELECTOR(AudioEngineImpl::update), this);','_scheduler->unschedule("AudioEngineUpdate", this);')
replace('frameworks/cocos2d-x/cocos/audio/AudioEngineImpl.cpp','_scheduler->schedule(CC_SCHEDULE_SELECTOR(AudioEngineImpl::update), this, 0.05f, false);','_scheduler->schedule([this](float dt) { update(dt); }, this, 0.05f, false, "AudioEngineUpdate");')
replace('frameworks/cocos2d-x/cocos/audio/AudioEngineImpl.cpp','_audioCaches.find(filePath)','_audioCaches.find(std::string(filePath))')
replace('frameworks/cocos2d-x/cocos/audio/AudioEngineImpl.cpp','_audioCaches.erase(filePath)','_audioCaches.erase(std::string(filePath))')
replace('frameworks/Audio/lua_conversion_tolua.hpp','TO_NATIVE_SIGNED(int64_t);','TO_NATIVE_SIGNED(int64_t);\n\tTO_NATIVE_SIGNED(long);')
replace('frameworks/Audio/lua_conversion_tolua.hpp','TO_NATIVE_UNSIGNED(uint64_t);','TO_NATIVE_UNSIGNED(uint64_t);\n\tTO_NATIVE_UNSIGNED(unsigned long);')
replace('frameworks/imgui/imgui_impl_cocos2dx.cpp','*desc.programState->getVertexLayout() = pinfo->layout;','desc.programState->setVertexLayout(pinfo->layout);')
replace('frameworks/imgui/imgui_impl_cocos2dx.cpp','backend::PixelFormat::A8, width, height, cocos2d::Size(width, height));','backend::PixelFormat::A8, width, height);')
for relative in ['frameworks/Audio/lua_conversion_tolua.hpp','frameworks/imgui/lua-bindings/lua_conversion_tolua.hpp','frameworks/LuaBindings/lua_conversion/lua_conversion_tolua.hpp']:
 replace(relative,'''#ifdef CC_USE_GFX
extern std::unordered_map<uintptr_t, const char*> g_luaType;
extern std::unordered_map<std::string, const char*> g_typeCast;
#else
extern std::unordered_map<std::string, std::string> g_luaType;
extern std::unordered_map<std::string, std::string> g_typeCast;
#endif''','''extern std::unordered_map<uintptr_t, const char*> g_luaType;
extern std::unordered_map<std::string, const char*> g_typeCast;''')

for relative in ['frameworks/imgui/lua-bindings/lua_conversion_tolua.hpp','frameworks/LuaBindings/lua_conversion/lua_conversion_tolua.hpp']:
 replace(relative,'TO_NATIVE_SIGNED(int64_t);','TO_NATIVE_SIGNED(int64_t);\n\tTO_NATIVE_SIGNED(long);')
 replace(relative,'TO_NATIVE_UNSIGNED(uint64_t);','TO_NATIVE_UNSIGNED(uint64_t);\n\tTO_NATIVE_UNSIGNED(unsigned long);')
replace('frameworks/Classes/XInfoware.cpp','''#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC) || (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
\t#include <cpuid.h>''','''#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC) || (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if defined(__aarch64__) || defined(__arm64__)
#define ARCH_ARM
#else
#include <cpuid.h>
#endif''')
replace('frameworks/Classes/XInfoware.cpp','int32_t out[4];','int32_t out[4] = {};')
replace('frameworks/Classes/XTrianglesCommand.cpp','#include "renderer/backend/gfx/ProgramGFX.h"','#ifdef CC_USE_GFX\n#include "renderer/backend/gfx/ProgramGFX.h"\n#endif')
replace('frameworks/LSTG/RenderMode.cpp','*state->getVertexLayout() = defaultLayout;','state->setVertexLayout(defaultLayout);')
replace('frameworks/LSTG/RenderMode.cpp','\t\tUniformLocation loc;','\t\tbackend::UniformLocation loc;')
replace('frameworks/LSTG/RenderMode.cpp','it.second.slot, it.second.textures','it.second.slots, it.second.textures')
replace('frameworks/LSTG/Util/Utility.cpp','#include "renderer/backend/gfx/TextureGFX.h"','''#ifdef CC_USE_GFX
#include "renderer/backend/gfx/TextureGFX.h"
#else
#include "read_texture.h"
#endif''')
replace('frameworks/LSTG/Util/Utility.cpp','''\t((cocos2d::backend::Texture2DGFX*)texture->getBackendTexture())->getBytes(
\t\tx, y, width, height, flipImage, callback);''','''#ifdef CC_USE_GFX
    ((cocos2d::backend::Texture2DGFX*)texture->getBackendTexture())->getBytes(x,y,width,height,flipImage,callback);
#else
    if (!bossrushMacReadTexture(texture,x,y,width,height,flipImage,image)) { delete image; return nullptr; }
#endif''')
replace('frameworks/cocos2d-x/cocos/platform/CCGL.h','#ifndef GL_MULTISAMPLE','#if !defined(CC_USE_METAL) && !defined(GL_MULTISAMPLE)')
p=engine/'CMakeLists.txt';s=p.read_text();mark='# Boss Rush HD Metal readback'
if mark not in s:
 s+='\n'+mark+'\ntarget_sources(${APP_NAME} PRIVATE "'+str(root/'native/read_texture.mm')+'")\n'
 s+='target_include_directories(${APP_NAME} PRIVATE "'+str(root/'native')+'")\n';p.write_text(s)
replace('frameworks/cocos2d-x/cocos/platform/mac/CCGLViewImpl-mac.mm','#import <Cocoa/Cocoa.h>','#import <Cocoa/Cocoa.h>\n#define GLFW_EXPOSE_NATIVE_COCOA\n#include "glfw3native.h"')
replace('frameworks/cocos2d-x/cocos/platform/mac/CCGLViewImpl-mac.mm','NS_CC_END  // end of namespace axmol;','''id GLViewImpl::getCocoaWindow() { return glfwGetCocoaWindow(_mainWindow); }
id GLViewImpl::getNSGLContext() { return nil; }
GLFWmonitor* GLViewImpl::getMonitor() const {
    if (_monitor) return _monitor;
    int x,y,w,h,count;glfwGetWindowPos(_mainWindow,&x,&y);glfwGetWindowSize(_mainWindow,&w,&h);
    auto monitors=glfwGetMonitors(&count);
    for(int i=0;i<count;++i) {
        int mx,my;glfwGetMonitorPos(monitors[i],&mx,&my);auto mode=glfwGetVideoMode(monitors[i]);
        if(x+w/2>=mx && x+w/2<mx+mode->width && y+h/2>=my && y+h/2<my+mode->height) return monitors[i];
    }
    return glfwGetPrimaryMonitor();
}
NS_CC_END  // end of namespace axmol;''')
p=engine/'CMakeLists.txt';s=p.read_text();mark='# Boss Rush HD system proxy framework'
if mark not in s:
 s+='\n'+mark+'\ntarget_link_libraries(${APP_NAME} "-framework SystemConfiguration")\n';p.write_text(s)
p=engine/'CMakeLists.txt';s=p.read_text();mark='# Boss Rush HD native Apple Silicon LuaJIT'
if mark not in s:
 s+='\n'+mark+'''
find_library(BR_LUAJIT NAMES luajit-5.1 luajit HINTS /opt/homebrew/opt/luajit/lib /usr/local/opt/luajit/lib REQUIRED)
set_target_properties(luajit PROPERTIES IMPORTED_LOCATION "${BR_LUAJIT}")
''';p.write_text(s)
replace('frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm','''        NSLog(@"Can not get metal shader:");''','''        NSLog(@"Can not get metal shader: %s", glslopt_get_log(glslShader));''')
replace('frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm','''    glslopt_ctx* ctx''','''    std::fill(_uniformLocation,_uniformLocation+UNIFORM_MAX,-1);
    std::fill(_attributeLocation,_attributeLocation+ATTRIBUTE_MAX,-1);
    glslopt_ctx* ctx''')
replace('frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm','''        NSLog(@"metal shader is ---------------");''','''        NSLog(@"metal shader functions: %@", library.functionNames);''')
if 'std::string portableSource(source);' not in (engine/'frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm').read_text():
 replace('frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm','''glslopt_shader* glslShader     = glslopt_optimize(ctx, shaderType, source.data(), 0);''','''std::string portableSource(source);
     const auto version=portableSource.find("#version");
     if(version!=std::string::npos) portableSource.erase(version,portableSource.find('\\n',version)-version+1);
     portableSource="#version 100\\n"+portableSource;
     glslopt_shader* glslShader = glslopt_optimize(ctx,shaderType,portableSource.c_str(),0);''')
replace('frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm','#include "ShaderModuleMTL.h"','#include "ShaderModuleMTL.h"\n#include <regex>')

replace('frameworks/cocos2d-x/cocos/platform/mac/CCGLViewImpl-mac.mm','[layer setFramebufferOnly:YES];','[layer setFramebufferOnly:NO];')
replace('frameworks/LSTG/Renderer.cpp','p->commandBuffer = p->pRenderer->getCommandBuffer();','p->commandBuffer = p->pRenderer->getCommandBuffer();\n\tCC_SAFE_RETAIN(p->commandBuffer);')



# 将版本、精度转换作为一个完整块更新，重复运行不会叠加声明。
p=engine/'frameworks/cocos2d-x/cocos/renderer/backend/metal/ShaderModuleMTL.mm';original=p.read_text();s=original
start=s.index('    std::string portableSource(source);')
end=s.index('    glslopt_shader* glslShader = glslopt_optimize',start)
portable=r'''    std::string portableSource(source);
    const auto version=portableSource.find("#version");
    if(version!=std::string::npos) portableSource.erase(version,portableSource.find('\n',version)-version+1);
    static const std::regex varyingPrecision(R"(\bvarying\s+(?:(?:lowp|mediump|highp)\s+)?)");
    portableSource=std::regex_replace(portableSource,varyingPrecision,"varying highp ");
    portableSource=std::regex_replace(portableSource,std::regex(R"(\b(lowp|mediump)\b)"),"highp");
    portableSource="#version 100\n"+portableSource;
'''
s=s[:start]+portable+s[end:]
if s!=original:p.write_text(s)

# 切换着色器后重新按属性 location 建立布局；默认材质与字体着色器的声明顺序不同。
replace('frameworks/LSTG/RenderMode.cpp','CC_SAFE_RETAIN(_program);',"""CC_SAFE_RETAIN(_program);
#ifndef CC_USE_GFX
    defaultLayout=backend::VertexLayout();
    SetDefaultVertexLayout(_program,&defaultLayout);
#endif""")

# Android 显式链接打包的 OpenAL Soft；Mac 也只保留它，防止同名 AL 符号先绑定到系统旧后端。
replace('frameworks/cocos2d-x/cmake/Modules/CocosConfigDepend.cmake',
        'find_library(OPENAL_LIBRARY OpenAL)',
        'set(OPENAL_LIBRARY "") # Boss Rush HD: use bundled OpenAL Soft target')
