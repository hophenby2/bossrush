#pragma once
#include <cstddef>
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
