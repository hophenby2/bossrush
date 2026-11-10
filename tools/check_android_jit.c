/* 在Android原生进程中验证多个Lua状态、跨区域trace、flush/关闭与W^X。
 * 使用与APK相同的静态运行时，不读写玩家目录。
 */
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
extern void bossrush_luajit_mcode_stats(uint64_t *out);
static void run(lua_State *L, const char *code) {
  if (luaL_dostring(L, code)) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    assert(0);
  }
}
static void opaque_pointer(lua_State *L) {
  void *tagged = (void *)(uintptr_t)UINT64_C(0xb400007512345678);
  lua_pushlightuserdata(L, tagged);
  assert(lua_touserdata(L, -1) == tagged);
  lua_pop(L, 1);
  lua_newtable(L);
  lua_pushlightuserdata(L, tagged);lua_pushinteger(L, 123);lua_rawset(L, -3);
  lua_pushlightuserdata(L, tagged);lua_rawget(L, -2);
  assert(lua_tointeger(L, -1) == 123);lua_pop(L, 2);
}
static void compiled(lua_State *L) {
  run(L,
    "require('jit.opt').start('hotloop=1','hotexit=1','maxtrace=8000') "
    "F={} for k=1,400 do "
    " local f=assert(loadstring('return function(n) local x=n for i=1,300 do x=x+i*'..k..' end return x end'))() "
    " F[k]=f assert(f(3)==3+45150*k) end "
    "assert(require('jit.util').traceinfo(1)) "
    "local ok,err=pcall(function() error('jit错误展开') end) assert(not ok and err:find('jit错误展开'))");
}
static void permissions(uint64_t address) {
  FILE *maps=fopen("/proc/self/maps", "r");
  char line[1024],flags[8];unsigned long long start,end;int found=0;
  assert(maps);
  while (fgets(line,sizeof(line),maps)) {
    if (sscanf(line,"%llx-%llx %7s",&start,&end,flags)!=3) continue;
    assert(!(flags[1]=='w' && flags[2]=='x'));
    if (address>=start && address<end) { assert(flags[0]=='r' && flags[1]=='-' && flags[2]=='x');found=1; }
  }
  fclose(maps);assert(found);
}
int main(void) {
  uint64_t before[11],after[11];
  lua_State *a=luaL_newstate(),*b=luaL_newstate();assert(a && b);
  luaL_openlibs(a);luaL_openlibs(b);opaque_pointer(a);opaque_pointer(b);
  bossrush_luajit_mcode_stats(before);
  for (int round=0;round<4;++round) {
    compiled(a);compiled(b);
    bossrush_luajit_mcode_stats(after);permissions(after[7]);
    run(a,"jit.flush() collectgarbage('collect')");
    run(b,"assert(F[251](3)==3+45150*251)");
    run(b,"jit.flush() collectgarbage('collect')");
  }
  compiled(a);compiled(b);lua_close(a);
  run(b,"assert(F[399](3)==3+45150*399)");lua_close(b);
  bossrush_luajit_mcode_stats(after);
  assert(after[3]-before[3]>=4 && after[4]==before[4] && after[1]==before[1]);
  printf("Android LuaJIT验证通过：10批编译，%llu个机器码块，失败0；双状态、flush、关闭、64位userdata、错误展开、W^X。\n",
         (unsigned long long)(after[3]-before[3]));
  return 0;
}
