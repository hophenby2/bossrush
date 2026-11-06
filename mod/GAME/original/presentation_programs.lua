-- 原 presentation_programs.lua 约 20 万个字面量常量，超过 LuaJIT 单函数 65536 常量上限
-- （lj_parse.c: fs_fixup_k -> checklimitgt(..., BCMAX_D+1, "constants")，BCMAX_D = 0xffff）。
-- 已按 ECL 文件拆到 presentation_programs.d/，索引见 presentation_programs_index.lua，
-- 运行时由 THlib/anm/presentation.lua 按需加载。
-- 重新生成：先跑 tools/th3x-tests/export_presentation_programs.py，再跑本脚本。
error('presentation_programs.lua 已拆分为 presentation_programs.d/，请从 THlib/anm/presentation.lua 加载，不要直接读取此文件')
