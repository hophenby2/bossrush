-- 通用自检工具没有 SetAttr 桩件；补上原生对象属性赋值，再按原工具逐帧检查。
SetAttr=function(o,k,v) rawset(o,k,v) end
-- TH32_THREAT_TOOL=1 时复用独立威胁分析工具，仍保留上述属性桩件。
dofile(os.getenv('TH32_THREAT_TOOL')=='1' and 'tools/threat.lua' or 'tools/check_stage.lua')
