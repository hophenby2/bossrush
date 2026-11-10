"""固定上游源码与摘要，构建支持远距离机器码区域的安卓ARM64 LuaJIT。"""
import hashlib
import json
import os
import shutil
from pathlib import Path
import subprocess
import tarfile

ROOT = Path(__file__).resolve().parent


def build(ndk, jobs):
    lock = json.loads((ROOT / 'luajit.lock.json').read_text(encoding='utf-8'))
    cache = ROOT / '.cache'
    cache.mkdir(parents=True,exist_ok=True)
    archive = cache / ('luajit-' + lock['commit'] + '.tar.gz')
    if not archive.exists():
        subprocess.run(['curl', '-fL', '--retry', '3', '-o', str(archive), lock['url']], check=True)
    if hashlib.sha256(archive.read_bytes()).hexdigest() != lock['sha256']:
        raise RuntimeError('LuaJIT源码压缩包SHA-256不匹配')
    source = cache / ('LuaJIT-' + lock['commit'])
    if not source.exists():
        with tarfile.open(archive) as package:
            package.extractall(cache, filter='data')
    mcode = source / 'src/lj_mcode.c'
    with tarfile.open(archive) as package:
        pristine = package.extractfile(source.name + '/src/lj_mcode.c').read().decode()
        header = package.extractfile(source.name + '/src/lj_jit.h').read().decode()
    text = pristine
    text = text.replace('#include "lj_vm.h"', '''#include "lj_vm.h"
#include <errno.h>
/* BossRush: mcode diagnostics */
static __thread uint64_t bossrush_mcode_stats[11];
void bossrush_luajit_mcode_stats(uint64_t *out)
{
  bossrush_mcode_stats[9] = LJ_TRERR_MCODEAL;
  memcpy(out, bossrush_mcode_stats, sizeof(bossrush_mcode_stats));
}''')
    text = text.replace('  void *p = mmap((void *)hint, sz, prot|MCPROT_CREATE, MAP_PRIVATE|MAP_ANONYMOUS|MCMAP_CREATE, -1, 0);', '''  void *p = mmap((void *)hint, sz, prot|MCPROT_CREATE, MAP_PRIVATE|MAP_ANONYMOUS|MCMAP_CREATE, -1, 0);
  bossrush_mcode_stats[0]++;
  bossrush_mcode_stats[6] = hint;
  bossrush_mcode_stats[7] = (uintptr_t)p;
  bossrush_mcode_stats[8] = p == MAP_FAILED ? errno : 0;
  if (p == MAP_FAILED) bossrush_mcode_stats[1]++;''')
    text = text.replace('  uintptr_t hint;\n', '  bossrush_mcode_stats[5] = (uintptr_t)(void *)lj_vm_exit_handler;\n  uintptr_t hint;\n')
    text = text.replace('      return p;  /* Success. */', '      { bossrush_mcode_stats[3]++; return p; }  /* Success. */')
    text = text.replace('    else if (p)\n      mcode_free(p, sz);', '    else if (p) {\n      bossrush_mcode_stats[2]++;\n      mcode_free(p, sz);\n    }')
    text = text.replace('  lj_trace_err(J, LJ_TRERR_MCODEAL);  /* Give up.', '  bossrush_mcode_stats[4]++;\n  lj_trace_err(J, LJ_TRERR_MCODEAL);  /* Give up.')
    text = text.replace('  if (J->szallmcarea + sizemcode > maxmcode)\n    lj_trace_err(J, LJ_TRERR_MCODEAL);', '  if (J->szallmcarea + sizemcode > maxmcode) {\n    bossrush_mcode_stats[10]++;\n    lj_trace_err(J, LJ_TRERR_MCODEAL);\n  }')
    body = (ROOT / 'native/luajit_mcode_arena.inc').read_text(encoding='utf-8')
    anchor = 'static void *mcode_alloc(jit_State *J, size_t sz)\n{'
    assert text.count(anchor) == 2, 'LuaJIT机器码入口上下文变化'
    text = text.replace(anchor, anchor + '\n' + body, 1)
    text = text.replace('    mcode_free(mc, sz);', '    if (!J->bossrush_mcode_arena) mcode_free(mc, sz);')
    anchor = '    mc = next;\n  }\n}'
    assert text.count(anchor) == 1
    text = text.replace(anchor, '''    mc = next;
  }
  if (J->bossrush_mcode_arena) {
    munmap(J->bossrush_mcode_arena, (size_t)64 << 20);
    J->bossrush_mcode_arena = NULL;
    J->bossrush_mcode_used = 0;
    J->mcmin = J->mcmax = 0;
  }
}''')
    anchor = '  size_t szallmcarea;'
    assert header.count(anchor) == 1
    header = header.replace(anchor, '''  void *bossrush_mcode_arena;
  size_t bossrush_mcode_used;
  size_t szallmcarea;''')
    for path, content in [(mcode, text), (source / 'src/lj_jit.h', header)]:
        if path.read_text(encoding='utf-8') != content:
            path.write_text(content, encoding='utf-8', newline='\n')

    toolchain = next(p for p in (ndk / 'toolchains/llvm/prebuilt').iterdir() if p.is_dir()) / 'bin'
    make = shutil.which('make') or shutil.which('mingw32-make')
    if not make:
        raise RuntimeError('构建LuaJIT需要GNU Make，以及本机C编译器；可用BOSSRUSH_HOST_CC指定')
    host_cc = os.environ.get('BOSSRUSH_HOST_CC') or next(
        (cc for cc in ['cc', 'gcc', 'clang'] if shutil.which(cc)), 'cc')
    def command(name):
        path = toolchain / name
        if os.name == 'nt':
            path = path.with_name(path.name + ('.cmd' if name.endswith('clang') else '.exe'))
        return '"' + path.as_posix() + '"'

    subprocess.run([make, '-C', str(source / 'src'), '-j', str(jobs),
                    'BUILDMODE=static', 'TARGET_SYS=Linux', 'HOST_CC=' + host_cc,
                    'CC=' + command('aarch64-linux-android28-clang'),
                    'TARGET_AR=' + command('llvm-ar') + ' rcus',
                    'TARGET_STRIP=' + command('llvm-strip'),
                    'TARGET_CFLAGS=-fPIC -funwind-tables', 'libluajit.a'], check=True)
    return source / 'src/libluajit.a'
