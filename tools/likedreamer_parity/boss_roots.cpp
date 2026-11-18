// 逐阶段诊断夹具：原版函数在运行时从用户本地复原目录读取。
#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <vector>
namespace reconstructed {
#include "reference_constants.inc"
#include "reference_enemy.inc"
#include "reference_helpers.inc"
class StageRuntime {
public:
  struct {
    int stage = 1, difficulty = 3;
  } config_;
  struct {
    float x = 360, y = 600;
    int invulnerableFrames = 0;
  } player_;
  int frame_ = 1000;
  int lateStageBossCountdown_ = 5000, lateStageBossPhaseMode_ = 1;
  int bossSe15SoundHandle_ = 0, bossSe1SoundHandle_ = 0,
      bossSe2SecondSoundHandle_ = 0, bossSe5SoundHandle_ = 0,
      bossSe6SoundHandle_ = 0, bossSe9SoundHandle_ = 0, bullet1SoundHandle_ = 0,
      bullet2SoundHandle_ = 0;
  int timer = 0;
  int lateStageBossBreaksRemaining_ = 5, lateStageBossMaxHp_ = 100000,
      lateStageBossPhaseIndex_ = 0, lateStageClearTimer_ = 0,
      enemyDown3SoundHandle_ = 0, bossSe8SoundHandle_ = 0, selectedStage_ = 6;
  int blast2SoundHandle_ = 0, lateStageBossCountdownDraw_ = 5000;
  float lateStageBossTargetX_ = 360, lateStageBossTargetY_ = 200;
  bool lateStageClearStarted_ = false;
  template <class... T> bool spawnStage06BossNode(T...) { return true; }
  template <class... T> void spawnBossPhaseBreakFeedback(T...) {}
  template <class... T> void spawnPostDeathCounterEntity(T...) {}
  template <class... T> void spawnPlayerSideObject(T...) {}
  template <class... T> void spawnStage02DeathExplosionChain(T...) {}
  void flushEnemyProjectilesToEffects() {}
  template <class... T> void spawnEnemyDeathEffects(T...) {}
  template <class... T> void updateBossCountdownAudio(T...) {}
  void clearLateStageGate(int) {}
  template <class... T> bool spawnStage03BossChild(T...) { return true; }
  template <class... T> bool spawnStage08BossNode(T...) { return true; }
  template <class... T> bool spawnStage09BossNode(T...) { return true; }
  template <class... T> bool spawnStage10FinalBossEmitter(T...) { return true; }
  template <class... T> void spawnStageEffect(T...) {}
  template <class... T> void playPlayerSound(T...) {}
  void spawnProjectileNode(int v, int id, float x, float y, uint16_t a,
                           float tr, double s, int r, int aux) {
    printf("b %d %d %d %.5f %.5f %d %.5f %.5f %d %d\n", timer, v, id, x, y,
           int(a), s, tr, r, aux);
  }
  void spawnProjectileSpread(int v, int id, float x, float y, uint16_t a,
                             float tr, double s, int r, int n, int width,
                             int aux) {
    int first = a, step = 0;
    if (n > 1) {
      if (width == 65536)
        step = 65536 / n;
      else {
        first -= width / 2;
        step = width > 0 ? width / (n - 1) : 0;
      }
    }
    for (int i = 0; i < n; i++)
      spawnProjectileNode(v, id, x, y, uint16_t(first + i * step), tr, s, r,
                          aux);
  }
#include "reference_declarations.inc"
};
#include "reference_behavior.inc"
} // namespace reconstructed
int main(int argc, char **argv) {
  using namespace reconstructed;
  StageRuntime r;
  int stage = atoi(argv[1]), state = atoi(argv[2]), d = atoi(argv[3]),
      children = atoi(argv[4]);
  r.config_.stage = stage;
  r.config_.difficulty = d;
  StageEnemy e;
  e.entityId = 1;
  e.helperState = state;
  e.x = 360;
  e.y = 200;
  e.liveChildCount = children;
  e.hp = 100000;
  e.maxHp = 100000;
  e.sourceAngle16 = 0;
  e.secondaryAngle16 = 0;
  e.targetAngle16 = 0;
  for (int t = 0; t < (argc > 5 ? atoi(argv[5]) : 2400); t++) {
    r.timer = t;
    e.helperTimer = t;
    r.frame_ = 1000 + t;
    r.player_.x = 200 + t % 200;
    r.player_.y = 500 + t % 100;
    switch (stage) {
    case 1:
      r.emitStage01BossProjectiles(e);
      break;
    case 2:
      r.emitStage02BossProjectiles(e);
      break;
    case 3:
      r.emitStage03BossProjectiles(e);
      break;
    case 4:
      r.emitStage04BossProjectiles(e);
      break;
    case 5:
      r.emitStage05BossProjectiles(e);
      break;
    case 6:
      r.updateStage06Boss(e);
      break;
    case 8:
      r.emitStage08BossProjectiles(e);
      break;
    case 9:
      r.emitStage09BossProjectiles(e);
      break;
    case 10:
      r.emitFinalRootPattern(e);
      break;
    case 11:
      r.emitScenePattern(e);
      break;
    }
  }
}
