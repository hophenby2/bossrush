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
// 颜色只用于被省略的装饰粒子，不影响发弹分支。
const std::array<int, 3> &paletteColor(int) {
  static const std::array<int, 3> c{};
  return c;
}
class StageRuntime {
public:
  struct {
    int stage = 1, difficulty = 3;
  } config_;
  struct {
    float x = 360, y = 600;
    int invulnerableFrames = 0, bombLock = 0, specialGauge = 0;
  } player_;
  int frame_ = 1000;
  int lateStageBossCountdown_ = 5000, lateStageBossPhaseMode_ = 1;
  int bossSe15SoundHandle_ = 0, bossSe1SoundHandle_ = 0,
      bossSe2SecondSoundHandle_ = 0, bossSe5SoundHandle_ = 0,
      bossSe6SoundHandle_ = 0, bossSe9SoundHandle_ = 0, bullet1SoundHandle_ = 0,
      bullet2SoundHandle_ = 0;
  int timer = 0;
  StageEnemy root{}, assembly{};
  std::vector<StageEnemy> enemies_, pendingEnemies_;
  int nextEntityId_ = 3, enemyDown1SoundHandle_ = 0, bossSe7SoundHandle_ = 0,
      blast2SoundHandle_ = 0;
  std::vector<int> enemySmallFrames_, effectMediumFrames_, enemyMediumFrames_,
      playerFrames_, enemyLargeFrames_, effectSmallFrames_;
  int selectedStage_ = 1, stage01BossPhaseMode_ = 1,
      stage01BossCountdown_ = 9999, stage02BossPhaseMode_ = 1,
      stage02BossCountdown_ = 9999, stage03BossPhaseMode_ = 1,
      stage03BossCountdown_ = 9999, stage04BossPhaseMode_ = 1,
      stage04BossCountdown_ = 9999, lateStageBossPhaseIndex_ = 0;
  bool stage01BossPhaseActive_ = true;
  StageEnemy *findEnemyById(int id) { return id == 3 ? &assembly : &root; }
  void flushEnemyProjectilesToEffects() {}
  template <class... T> void spawnEnemyDeathEffects(T...) {}
  template <class... T> void spawnEnemyDeathRewardBurst(T...) {}
  template <class... T> void spawnDelayedOwnerDamageNode(T...) {}
  template <class... T> void spawnPostDeathCounterEntity(T...) {}
  template <class... T> void spawnPlayerSideObject(T...) {}
  template <class... T> void maybeSpawnStage10GuardNode(T...) {}

  bool isStage07HeadType(int n) const { return n == 0x83 || n == 0x84; }

  template <class... T> void spawnBossPhaseBreakFeedback(T...) {}
  template <class... T> void spawnStage03DeathNode(T...) {}
  template <class... T> void spawnStage04DeathNode(T...) {}
  template <class... T> void spawnStage02DeathExplosionChain(T...) {}
  template <class... T> void spawnSharedHitboxProxy(T...) {}
  template <class... T> void spawnStage03Auxiliary(T...) {}
  template <class... T> void spawnStage07BossNode(T...) {}
  template <class... T> bool spawnStage05BossChild(T...) { return true; }
  template <class... T> bool spawnStage06BossNode(T...) { return true; }
  template <class... T> bool spawnStage10FinalBossNode(T...) { return true; }
  template <class... T> bool spawnStage10FinalBossEmitter(T...) { return true; }

  template <class... T> bool spawnStage03BossChild(T...) { return true; }
  template <class... T> bool spawnStage08BossNode(T...) { return true; }
  template <class... T> bool spawnStage09BossNode(T...) { return true; }
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
  int stage = atoi(argv[1]), kind = atoi(argv[2]), state = atoi(argv[3]),
      d = atoi(argv[4]);
  r.config_.stage = r.selectedStage_ = stage;
  r.config_.difficulty = d;
  r.root.spawnType = 0x137 + stage;
  r.root.hp = r.root.maxHp = 100000;
  r.root.active = true;
  r.root.helperState = state;
  r.root.entityId = 1;
  r.root.liveChildCount = 4;
  r.root.x = 360;
  r.root.y = 200;
  StageEnemy e;
  e.spawnType = kind;
  e.entityId = 2;
  e.parentEntityId = 1;
  e.parentSpawnType = r.root.spawnType;
  e.x = 460;
  e.y = 150;
  e.originX = 100;
  e.originY = -50;
  if (stage == 4 && kind == 65)
    e.originY = 200;
  if (stage == 4 && (kind == 66 || kind == 67))
    e.originX = 180;
  if (stage == 9 && kind >= 218)
    e.radius = 180;
  e.liveChildCount = 4;
  e.hp = e.maxHp = 6000;
  e.sourceSpeed = e.speed = 1;
  e.sourceAngle16 = 0x4000;
  e.secondaryAngle16 = e.targetAngle16 = 0;
  e.childIndex = 1;
  if (stage == 9 && kind >= 218)
    e.sourceSpeed = (kind == 218 || kind == 220) ? 200 : -200;
  if (stage == 10) {
    int owner = 0;
    if (kind == 0x114)
      owner = 0x113;
    else if (kind >= 0x116 && kind <= 0x119)
      owner = 0x115;
    else if (kind >= 0x11b && kind <= 0x11c)
      owner = 0x11a;
    else if (kind >= 0x11e && kind <= 0x122)
      owner = 0x11d;
    else if (kind >= 0x12e && kind <= 0x133)
      owner = 0x12d;
    if (owner) {
      r.assembly = r.root;
      r.assembly.spawnType = owner;
      r.assembly.entityId = 3;
      r.assembly.parentEntityId = 1;
      r.assembly.parentSpawnType = r.root.spawnType;
      r.assembly.helperState = 1;
      e.parentEntityId = 3;
      e.parentSpawnType = owner;
    }
  }
  for (int t = 0; t < (argc > 5 ? atoi(argv[5]) : 2400) && e.active; t++) {
    r.timer = t;
    r.frame_ = 1000 + t;
    r.root.helperTimer = t;
    r.assembly.helperTimer = t;
    r.player_.x = 200 + t % 200;
    r.player_.y = 500 + t % 100;
    switch (stage) {
    case 1:
      r.updateStage01BossChild(e);
      break;
    case 2:
      r.updateStage02BossChild(e);
      break;
    case 3:
      r.updateStage03BossChild(e);
      break;
    case 4:
      r.updateStage04BossChild(e);
      break;
    case 5:
      r.updateStage05BossChild(e);
      break;
    case 6:
      r.updateStage06BossNode(e);
      break;
    case 7:
      r.updateStage07BossNode(e);
      break;
    case 8:
      r.updateStage08BossNode(e);
      break;
    case 9:
      r.updateStage09BossNode(e);
      break;
    case 10:
      r.updateStage10FinalBossNode(e);
      break;
    }
    e.helperTimer++;
  }
}
