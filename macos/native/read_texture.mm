#include "read_texture.h"
#include "renderer/backend/metal/DeviceMTL.h"
#import <Metal/Metal.h>
#include <cstring>
#include <vector>

// 原生 Metal 纹理通过有序 blit 读回，不借用 Android GLES 的 getBytes。
bool bossrushMacReadTexture(cocos2d::Texture2D* source,size_t x,size_t y,size_t width,size_t height,bool flip,cocos2d::Image* image) {
    auto* device=static_cast<cocos2d::backend::DeviceMTL*>(cocos2d::backend::Device::getInstance());
    id<MTLTexture> texture=(id<MTLTexture>)source->getBackendTexture()->getHandler();
    const size_t stride=(width*4+255)&~size_t(255);
    id<MTLBuffer> buffer=[device->getMTLDevice() newBufferWithLength:stride*height options:MTLResourceStorageModeShared];
    if (!buffer) return false;
    id<MTLCommandBuffer> command=[device->getMTLCommandQueue() commandBuffer];
    id<MTLBlitCommandEncoder> blit=[command blitCommandEncoder];
    [blit copyFromTexture:texture sourceSlice:0 sourceLevel:0 sourceOrigin:MTLOriginMake(x,y,0)
        sourceSize:MTLSizeMake(width,height,1) toBuffer:buffer destinationOffset:0
        destinationBytesPerRow:stride destinationBytesPerImage:stride*height];
    [blit endEncoding];[command commit];[command waitUntilCompleted];
    bool ok=command.status==MTLCommandBufferStatusCompleted;
    if (ok) {
        std::vector<unsigned char> pixels(width*height*4);
        auto* bytes=(const unsigned char*)buffer.contents;
        for (size_t row=0;row<height;++row) std::memcpy(pixels.data()+row*width*4,bytes+(flip?height-1-row:row)*stride,width*4);
        if (texture.pixelFormat==MTLPixelFormatBGRA8Unorm) for(size_t i=0;i<pixels.size();i+=4) std::swap(pixels[i],pixels[i+2]);
        ok=image->initWithRawData(pixels.data(),pixels.size(),width,height,8,source->hasPremultipliedAlpha());
    }
    [buffer release];return ok;
}

#include "Classes/XLuaModuleRegistry.h"
#include "LSTG/LuaWrapper/LuaWrapper.h"
#include "platform/desktop/CCGLViewImpl-desktop.h"
LUA_REGISTER_FUNC_DEF(lstg, MacConfigureDisplay) {
    auto* view=static_cast<cocos2d::GLViewImpl*>(cocos2d::Director::getInstance()->getOpenGLView());
    int width,height;glfwGetFramebufferSize(view->getWindow(),&width,&height);
    view->enableRetina(true);view->setFrameSize(width,height);
    lua_pushinteger(L,width);lua_pushinteger(L,height);return 2;
}
