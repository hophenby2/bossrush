-- 虫姬二人 1.5，Original 模式。
local machine = dofile('mod/GAME/cv1000/futari_player.lua')(2.5)
machine.pilot = dofile('mod/GAME/th46/pilot.lua')
dofile('mod/GAME/cv1000/stage.lua')('TH46',44,machine,dofile('mod/GAME/th46/road1.lua'))
