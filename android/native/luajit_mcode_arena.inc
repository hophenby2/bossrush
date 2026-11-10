/* Android链接器/分配器可占满解释器附近的跳转窗口。每个Lua状态独占连续
 * 64MiB虚拟地址，只有实际机器码页提交内存；保留上游RW/RX切换，绝不RWX。
 * 区域只在所有trace释放后整体解除映射，避免覆盖或复用仍在执行的机器码。
 */
#if defined(__ANDROID__) && LJ_TARGET_ARM64
  const size_t capacity = (size_t)64 << 20;
  const size_t alignment = (size_t)64 << 10;
  size_t committed;
  void *area;
  bossrush_mcode_stats[0]++;
  bossrush_mcode_stats[5] = (uintptr_t)(void *)lj_vm_exit_handler;
  if (!sz || sz > capacity) goto bossrush_mcode_failure;
  committed = (sz + alignment - 1) & ~(alignment - 1);
  if (!J->bossrush_mcode_arena) {
    void *base = mmap(NULL, capacity, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (base == MAP_FAILED) {
      bossrush_mcode_stats[1]++;
      bossrush_mcode_stats[8] = errno;
      goto bossrush_mcode_failure;
    }
    J->bossrush_mcode_arena = base;
    J->bossrush_mcode_used = 0;
    mcode_setrange(J, (uintptr_t)base + capacity/2);
  }
  if (committed > capacity - J->bossrush_mcode_used) goto bossrush_mcode_failure;
  area = (char *)J->bossrush_mcode_arena + J->bossrush_mcode_used;
  if (mprotect(area, committed, MCPROT_GEN)) {
    bossrush_mcode_stats[1]++;
    bossrush_mcode_stats[8] = errno;
    goto bossrush_mcode_failure;
  }
  J->bossrush_mcode_used += committed;
  bossrush_mcode_stats[3]++;
  bossrush_mcode_stats[6] = (uintptr_t)area;
  bossrush_mcode_stats[7] = (uintptr_t)area;
  bossrush_mcode_stats[8] = 0;
  return area;
bossrush_mcode_failure:
  bossrush_mcode_stats[4]++;
  lj_trace_err(J, LJ_TRERR_MCODEAL);
#endif
