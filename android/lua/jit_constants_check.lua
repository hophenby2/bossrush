-- 仅私有诊断入口调用：验证开启JIT时的标准库返回和64位指针常量，不推进关卡。
local T={}
function T.run()
    assert(jit and jit.status(),'远地址检查必须开启JIT')
    jit.flush()
    local ffi=require('ffi')
    local util=require('jit.util')
    local compiledLen,compiled=0,0
    local function trace(kind,number,fn)
        if kind~='stop' then return end
        compiled=compiled+1
        local info=type(fn)=='function' and util.funcinfo(fn)
        if info and info.source=='len' then compiledLen=compiledLen+1 end
    end
    jit.off(trace,true);jit.attach(trace,'trace')
    local function interpreted(s)
        local length=string.len(s)
        return length+0
    end
    jit.off(interpreted,true)
    -- 外层保持解释执行，使被调用的标准库函数形成独立trace并返回解释器。
    local function exercise()
        for i=1,1024 do
            local length=i%127
            assert(interpreted(string.rep('x',length))==length,'字符串trace返回值错误')
        end
        local addresses={0x100040001234,0x1000c0001234,0x100140001234}
        for _,address in ipairs(addresses) do
            local function pointer() return ffi.cast('void*',address) end
            jit.on(pointer)
            for i=1,512 do
                assert(tonumber(ffi.cast('uintptr_t',pointer()))==address,'64位指针常量被截断')
            end
        end
    end
    jit.off(exercise,true)
    local ok,err=xpcall(exercise,debug.traceback)
    jit.attach(trace)
    assert(ok,err)
    assert(jit.status() and compiledLen>0,'未覆盖标准库返回trace')
    local result={passed=true,architecture=jit.arch,jit_enabled=jit.status(),
        compiled=compiled,compiled_len=compiledLen,string_calls=1024,pointer_calls=1536,
        mcode=lstg.AndroidJitMcodeStats and lstg.AndroidJitMcodeStats()}
    local file=assert(io.open('User/android-jit-constants.json','wb'))
    file:write(Serialize(result));file:close()
    lstg.SystemLog('BOSSRUSH_JIT_CONSTANTS: '..Serialize(result))
    return result
end
return T
