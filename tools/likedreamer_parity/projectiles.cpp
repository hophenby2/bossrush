#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <vector>
namespace reconstructed {
#include "reference_helpers.inc"
#include "reference_projectile.inc"

struct StageEnemy {
  int helperTimer = 930;
};
class StageRuntime {
public:
  struct {
    int difficulty;
  } config_;
  struct {
    float x, y;
  } player_;
  int frame_ = 1000;
  std::vector<int> effectSmallFrames_ = std::vector<int>(100);
  StageEnemy parent{};
  StageEnemy *findEnemyById(int) { return &parent; }
  template <class... T> void spawnStageEffect(T...) {}
  template <class... T> void spawnProjectileTerminalEffect(T...) {}
  void spawnProjectileNode(int v, int id, float x, float y, uint16_t a,
                           float tr, double s, int r, int arg) {
    printf("b %d %d %d %.6f %.6f %d %.6f %.6f %d %d\n", frame_, v, id, x, y,
           int(a), s, tr, r, arg);
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
  void updateProjectileCommonMotion(StageProjectile &);
  void updateProjectileReflectOnBoundary(StageProjectile &);
  void updateProjectileHomingSteering(StageProjectile &);
  void updateProjectileScriptedEmitter(StageProjectile &);
  void updateProjectileOrbitArcPair(StageProjectile &);
  void updateProjectileExpandingSpiralPair(StageProjectile &);
};

#include "reference_behavior.inc"

} // namespace reconstructed
int main(int argc, char **argv) {
  using namespace reconstructed;
  StageRuntime r;
  int id = atoi(argv[1]), d = atoi(argv[2]), seed = atoi(argv[3]);
  r.config_.difficulty = d;
  StageProjectile p;
  p.projectileId = id;
  p.visualSelector = 3;
  p.radius = 1;
  p.anchorX = p.prevX = p.x = 300;
  p.anchorY = p.prevY = p.y = 300;
  p.speed = p.baseSpeed = 2.5;
  p.speedOrAccelHint = 30;
  p.angle16 = p.prevAngle16 = uint16_t(seed * 8192);
  p.arg8OrAux = 1;
  int mode = atoi(argv[4]);
  if (mode == 1) {
    p.x = p.anchorX = p.prevX = 80;
    p.y = p.anchorY = p.prevY = 15;
    p.speed = p.baseSpeed = 9.7;
    p.speedOrAccelHint = 0;
  }
  if (mode == 2) {
    p.x = p.anchorX = p.prevX = 615;
    p.y = p.anchorY = p.prevY = 710;
    p.speed = p.baseSpeed = .1;
    p.speedOrAccelHint = 120;
  }
  for (int t = 0; t < 360 && p.active; t++) {
    p.age = t;
    r.frame_ = 1000 + t;
    r.player_.x = 200 + t % 200;
    r.player_.y = 500 + t % 100;
    r.parent.helperTimer = 900 + t;
    if (id == 8)
      r.updateProjectileReflectOnBoundary(p);
    else if (id == 31 || id == 32)
      r.updateProjectileOrbitArcPair(p);
    else if (id == 58 || id == 59)
      r.updateProjectileExpandingSpiralPair(p);
    else if (id == 12 || id == 14 || id == 35 || id == 36 || id == 37 ||
             id == 38 || id == 39 || id == 44 || id == 45 || id == 53 ||
             id == 54)
      r.updateProjectileHomingSteering(p);
    else if (id == 23 || (id >= 24 && id <= 30) || id == 33 || id == 34 ||
             (id >= 40 && id <= 43) || (id >= 46 && id <= 52) ||
             (id >= 55 && id <= 57) || id == 60)
      r.updateProjectileScriptedEmitter(p);
    else if (id == 19 || id == 21) {
      p.collisionEnabled = false;
      if (t == 1)
        p.active = false;
    } else if (id == 20) {
      p.collisionEnabled = false;
      if (t == 3)
        p.active = false;
    } else
      r.updateProjectileCommonMotion(p);
    printf("s %d %.6f %.6f %d %.6f %.6f %d %d\n", t, p.x, p.y, int(p.angle16),
           p.speed, p.speedOrAccelHint, int(p.active), int(p.collisionEnabled));
  }
}
