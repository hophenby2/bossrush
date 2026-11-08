"""在Lupa的LuaJIT 2.1中运行仓库检查；保留5.1语义并转接只读目录枚举。"""
from pathlib import Path
import os
import shlex
import sys

ROOT=Path(__file__).resolve().parents[2]


def runtime():
    from lupa.luajit21 import LuaRuntime
    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.globals().print=lambda *args:print(*args,flush=True)
    def listing(command):
        args=shlex.split(command.split('2>')[0])
        if args[0]=='ls':return '\n'.join(p.name for p in (ROOT/args[1]).iterdir())
        if args[0]=='find':return '\n'.join(p.relative_to(ROOT).as_posix() for d in args[1:args.index('-name')] for p in (ROOT/d).rglob('*.lua'))
        raise ValueError(command)
    lua.globals().python_listing=listing
    lua.execute("io.popen=function(c) local f=assert(io.tmpfile());f:write(python_listing(c));f:seek('set');return f end")
    return lua


def main():
    os.chdir(ROOT)
    lua=runtime();lua.globals().arg=lua.table_from({i:v for i,v in enumerate(sys.argv[1:])})
    lua.execute(Path(sys.argv[1]).read_text('utf-8-sig'))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
