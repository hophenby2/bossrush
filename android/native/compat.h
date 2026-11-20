#pragma once
#include <cstddef>
#include <cstdint>
#include <string>
namespace cocos2d { class Image; }
cocos2d::Image* androidTakePreparedTexture(const std::string& path);
extern uint64_t androidFogStatesCreated,androidFogStatesReused;
extern bool androidProfileBatches;
void androidRecordSpriteBatch(std::size_t size);
extern int androidSuperPause;
extern int androidCurrentSuperPause;
extern int androidWorldFlag;
extern bool androidProfileText;
extern double androidTextTime[3];
extern unsigned androidTextCalls;
double androidNow();
void androidApplySwapInterval();
