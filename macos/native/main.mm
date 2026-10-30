#import <Cocoa/Cocoa.h>
#include "LSTG/AppFrame.h"
#include "platform/CCFileUtils.h"
#include "platform/desktop/CCGLViewImpl-desktop.h"
#include <cstdlib>
#include <vector>
#include <string>

@interface BossRushMenuActions : NSObject
- (void)requestQuit:(id)sender;
@end
@implementation BossRushMenuActions
- (void)requestQuit:(id)sender {
    auto* view=static_cast<cocos2d::GLViewImpl*>(cocos2d::Director::getInstance()->getOpenGLView());
    if(view) glfwSetWindowShouldClose(view->getWindow(),GLFW_TRUE);
}
@end

// Finder 与终端都使用 .app 内的资源；测试数据不落入源码目录。
int main(int argc, char* argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        NSMenu* bar = [[NSMenu alloc] init];
        NSMenuItem* item = [[NSMenuItem alloc] init];
        [bar addItem:item];
        NSMenu* menu = [[NSMenu alloc] initWithTitle:@"Boss Rush HD"];
        BossRushMenuActions* actions=[[BossRushMenuActions alloc] init];
        NSMenuItem* quit=[menu addItemWithTitle:@"退出 Boss Rush HD" action:@selector(requestQuit:) keyEquivalent:@"q"];
        [quit setTarget:actions];
        [item setSubmenu:menu];
        [NSApp setMainMenu:bar];
        auto* application=lstg::AppFrame::getInstance();
        auto* files = cocos2d::FileUtils::getInstance();
        const char* override = std::getenv("BOSSRUSH_MAC_DATA");
        NSString* data = override ? [NSString stringWithUTF8String:override] :
            [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/BossRushHD-Mac"];
        [[NSFileManager defaultManager] createDirectoryAtPath:data withIntermediateDirectories:YES attributes:nil error:nullptr];
        files->setWritablePath(std::string([data fileSystemRepresentation])+"/");
        NSString* resources = [[NSBundle mainBundle] resourcePath];
        files->setDefaultResourceRootPath(std::string([resources fileSystemRepresentation])+"/");
        std::vector<std::string> args;
        for (int i=0;i<argc;++i) args.emplace_back(argv[i]);
        lstg::AppFrame::setCmdLineArgs(args);
        int code=application->run();
        lstg::AppFrame::destroyInstance();
        [actions release];
        return code;
    }
}
