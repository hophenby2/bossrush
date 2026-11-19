-- 测试模块在自机完成初始化后按作品选择。
local T={}
local source
function T.before(p)
    if not source and os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='fidelity' then
        source=dofile('macos/source_logic_fidelity.lua')
    end
    if not source and os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='mechanics' then
        source=dofile('macos/source_logic_mechanics.lua')
    end
    if not source and (p.native_level==35 or p.native_level==37) and os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='damage' then
        source=dofile('macos/source_logic_mhj_damage.lua')
    end
    source=source or dofile('macos/source_logic_'..((({[35]=os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='system' and 'spring_system' or 'spring',[36]='unity',[37]='night',[38]='summer',[41]='bdb'})[p.native_level]) or 'theis')..'.lua')
    return source.before(p)
end
function T.after(...) if source then return source.after(...) end end
function T.checkpoint(...) return assert(source).checkpoint(...) end
return T
