local path = "THlib\\UI\\font\\"
local ntext1 = path .. "text.ttf"
local ntext2 = path .. "text2.ttf"
LoadTTF('boss_name', ntext1, 20)
--LoadTTF("text", ntext1[1], 32)
LoadTTF("title", ntext1, 32)
LoadTTF("big_text", ntext1, 80)
LoadTTF("sc_menu", ntext1, 26)
LoadTTF("achievement", ntext1, 28)
LoadTTF("manual", ntext1, 25)

LoadTTF("pretty", ntext2, 32)
LoadFont('Score', path .. 'score_new.fnt', false)
--LoadFont('time', path .. 'score_new_score.fnt', true)
LoadFont('replay', path .. 'replay.fnt', false)

