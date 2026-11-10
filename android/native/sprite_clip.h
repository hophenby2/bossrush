#pragma once
#include "cocos2d.h"
extern bool androidClipSprites;
void androidResetSpriteClipping();
bool androidSpriteOutside(const cocos2d::V3F_C4B_T2F* vertices,
                         const cocos2d::Mat4& projection,
                         cocos2d::backend::Program* program);
