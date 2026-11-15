-- 绊地狱使用共用的 PGM 图块与精灵加载器。
local source = dofile('mod/GAME/pgm/source.lua')('th43')
source.midBoxes = true
-- 0x10f24e 到 0x10f760 分别结算六个部件。两门内炮使用较小的计数。
source.partHP = {[0x7080]={[2]=0x1040,[3]=0x1040,[4]=0x1380,[5]=0x1380,[6]=0x1380,[7]=0x1380}}
return source
