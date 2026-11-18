#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <vector>
namespace reconstructed {
#include "reference_enemy.inc"

class StageRuntime {
public:
  struct {
    int difficulty = 3, stage = 9;
  } config_;
  struct {
    float x = 360, y = 600;
    int bombLock = 0, invulnerableFrames = 0;
  } player_;
  int frame_ = 6000, nextEntityId_ = 2, lateStageBossBreaksRemaining_ = 0,
      lateStageBossCountdownDraw_ = 0, lateStageBossCountdown_ = 0,
      lateStageBossMaxHp_ = 0, lateStageBossPhaseIndex_ = 0,
      lateStageBossPhaseMode_ = 0;
  float lateStageBossTargetX_ = 360, lateStageBossTargetY_ = 200;
  std::array<int, 6> stage09BossDefeatFrames_{{-1, -1, -1, -1, -1, -1}};
  std::vector<StageEnemy> enemies_, pendingEnemies_;
  int bossSe15SoundHandle_ = 0, bossSe1SoundHandle_ = 0,
      bossSe2SecondSoundHandle_ = 0, bossSe5SoundHandle_ = 0,
      bossSe6SoundHandle_ = 0, bossSe9SoundHandle_ = 0, bullet1SoundHandle_ = 0,
      bullet2SoundHandle_ = 0;
  int actor = 0;
  StageEnemy *findEnemyById(int id) {
    for (auto &e : enemies_)
      if (e.entityId == id)
        return &e;
    return nullptr;
  }
  template <class... T> void playPlayerSound(T...) {}
  template <class... T> void spawnEnemyDeathEffects(T...) {}
  template <class... T> void spawnEnemyDeathRewardBurst(T...) {}
  template <class... T> void spawnPlayerSideObject(T...) {}
  template <class... T> void spawnBossPhaseBreakFeedback(T...) {}
  template <class... T> void spawnPostDeathCounterEntity(T...) {}
  template <class... T> void spawnStage02DeathExplosionChain(T...) {}
  template <class... T> void updateBossCountdownAudio(T...) {}
  template <class... T> void clearLateStageGate(T...) {}
  void flushEnemyProjectilesToEffects() {}
  void spawnDelayedOwnerDamageNode(int hp, int id, int type, const char *) {
    StageEnemy n;
    n.entityId = nextEntityId_++;
    n.spawnType = 0x153;
    n.sourceAngle16 = 0x4000;
    n.hp = n.maxHp = hp;
    n.parentEntityId = id;
    n.parentSpawnType = type;
    n.x = n.y = -100;
    pendingEnemies_.push_back(n);
  }
  void damage(StageEnemy &e) {
    auto p = findEnemyById(e.parentEntityId);
    if (!p || !p->active) {
      e.active = false;
      return;
    }
    int d = std::min(e.hp, std::max(1, e.maxHp / 30));
    e.hp -= d;
    p->hp -= d;
    if (e.hp < 1)
      e.active = false;
  }
  void spawnProjectileNode(int v, int id, float x, float y, uint16_t a,
                           float tr, double s, int r, int arg) {
    printf("b %d %d %d %d %.6f %.6f %d %.6f %.6f %d %d\n", frame_, actor, v, id,
           x, y, int(a), s, tr, r, arg);
  }
  void spawnProjectileSpread(int v, int id, float x, float y, uint16_t a,
                             float tr, double s, int r, int n, int spread,
                             int arg) {
    int first = a, step = 0;
    if (n > 1) {
      if (spread == 65536)
        step = 65536 / n;
      else {
        first -= spread / 2;
        step = spread > 0 ? spread / (n - 1) : 0;
      }
    }
    for (int i = 0; i < n; i++)
      spawnProjectileNode(v, id, x, y, uint16_t(first + i * step), tr, s, r,
                          arg);
  }
#include "reference_declarations.inc"
};
} // namespace reconstructed

#include "reference_behavior.inc"

int main(int argc, char **argv) {
  using namespace reconstructed;
  StageRuntime r;
  r.enemies_.reserve(512);
  int k = atoi(argv[1]), mode = atoi(argv[3]);
  r.config_.difficulty = atoi(argv[2]);
  StageEnemy e;
  e.spawnType = 0x146 + k;
  e.entityId = 1;
  e.x = e.markerDrawX = 360;
  e.y = k == 1 ? 270 : k == 5 ? 240 : 200;
  e.markerDrawY = 200;
  e.sourceSpeed = std::array<double, 6>{{.3, .3, 4.5, .3, .3, 1.6}}[k];
  e.speed = e.sourceSpeed;
  e.hp = e.maxHp = 100000;
  r.enemies_.push_back(e);
  for (int t = 0; t < 2600; t++) {
    r.frame_ = 6000 + t;
    r.player_.x = 200 + t % 200;
    r.player_.y = 500 + t % 100;
    if (mode == 1 && t == 1000)
      r.enemies_[0].hp = 0;
    if (mode == 2 && t == 1000)
      r.lateStageBossCountdown_ = 0;
    for (size_t i = 0; i < r.enemies_.size(); i++) {
      auto &o = r.enemies_[i];
      if (!o.active)
        continue;
      r.actor = o.entityId;
      if (mode == 3 && t == 700 && o.spawnType == 0xc8)
        o.hp = 0;
      if (o.spawnType == 0x153)
        r.damage(o);
      else if (o.spawnType >= 0x146)
        r.updateStage09Midboss(o);
      else
        r.updateStage09MidbossNode(o);
      printf("s %d %d %d %d %.6f %.6f %d %d %d %d %d\n", r.frame_, o.entityId,
             o.helperState, o.helperTimer, o.x, o.y, int(o.sourceAngle16),
             int(o.secondaryAngle16), int(o.targetAngle16), o.hp,
             int(o.active));
      o.helperTimer++;
      for (auto &p : r.pendingEnemies_)
        r.enemies_.push_back(p);
      r.pendingEnemies_.clear();
    }
  }
}
