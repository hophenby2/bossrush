-- 原作 C# 的音效和视觉调用；攻击脚本保留在 phases.lua。
return {titles={["1"]={["file"]="Resources/th40/presentation/music01.png",["size"]={210,34},["name"]="宁静夏夜的微风"},["2"]={["file"]="Resources/th40/presentation/music02.png",["size"]={135,34},["name"]="灯火竹林"},["3"]={["file"]="Resources/th40/presentation/music03.png",["size"]={208,34},["name"]="木灵们的夏夜祭"},["4"]={["file"]="Resources/th40/presentation/music04.png",["size"]={234,34},["name"]="万花世界的光与影"},["5"]={["file"]="Resources/th40/presentation/music05.png",["size"]={234,34},["name"]="记忆中遥远的星星"},["6"]={["file"]="Resources/th40/presentation/music06.png",["size"]={158,34},["name"]="银河的彼方"},["EX"]={["file"]="Resources/th40/presentation/musicEx.png",["size"]={208,34},["name"]="来自仙界的新风"}},step={
["Boss_Ami01.Ctrl1"]=function(o,t,N)

end,
["Boss_Ami02.Ctrl1"]=function(o,t,N)
if (t == 90) then N.presentation.energy(o.cx-320,240-o.cy,true,{255,255,155}) end
if (t == 90) then N.sound("se_ch02.wav") end
end,
["Boss_Ami02.Ctrl2"]=function(o,t,N)
if (t == 10) then N.presentation.energy(o.cx-320,240-o.cy,true,{255,255,155}) end
if (t == 10) then N.sound("se_ch02.wav") end
end,
["Boss_Kage01.Ctrl4"]=function(o,t,N)

end,
["Boss_Kage01.Ctrl5"]=function(o,t,N)

end,
["Boss_Rakuki01.Ctrl1"]=function(o,t,N)

end,
["Boss_Rakuki02.Ctrl2"]=function(o,t,N)

end,
["Boss_Rakuki02.Ctrl3"]=function(o,t,N)

end,
["Boss_Rakuki04.Ctrl1"]=function(o,t,N)

end,
["Boss_Rakukun01.Ctrl3"]=function(o,t,N)

end,
["Boss_Rakukun01.Ctrl4"]=function(o,t,N)

end,
["Boss_Rakukun01.Ctrl5"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl10"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl3"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl4"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl5"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl6"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl7"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl8"]=function(o,t,N)

end,
["Boss_Rika01.Ctrl9"]=function(o,t,N)

end,
["Boss_Seiryuu01.Ctrl1"]=function(o,t,N)

end,
["Boss_Seiryuu01.Ctrl2"]=function(o,t,N)

end,
["Boss_Seiryuu01.Ctrl3"]=function(o,t,N)

end,
["Boss_Tensei01.Ctrl3"]=function(o,t,N)

end,
["Boss_Tensei01.Ctrl4"]=function(o,t,N)

end,
["Boss_Tensei01.Ctrl5"]=function(o,t,N)

end,
["Boss_Tensei01.Ctrl6"]=function(o,t,N)

end,
["SpellCard_SSS01_01"]=function(o,t,N)

end,
["SpellCard_SSS01_02"]=function(o,t,N)

end,
["SpellCard_SSS01_03"]=function(o,t,N)

end,
["SpellCard_SSS01_FSC"]=function(o,t,N)

end,
["SpellCard_SSS02_01"]=function(o,t,N)

end,
["SpellCard_SSS02_02"]=function(o,t,N)

end,
["SpellCard_SSS02_03"]=function(o,t,N)

end,
["SpellCard_SSS02_04"]=function(o,t,N)

end,
["SpellCard_SSS02_FSC"]=function(o,t,N)

end,
["SpellCard_SSS03_01"]=function(o,t,N)

end,
["SpellCard_SSS03_02"]=function(o,t,N)

end,
["SpellCard_SSS03_03"]=function(o,t,N)

end,
["SpellCard_SSS03_04"]=function(o,t,N)

end,
["SpellCard_SSS03_05"]=function(o,t,N)

end,
["SpellCard_SSS03_FSC"]=function(o,t,N)

end,
["SpellCard_SSS04_01"]=function(o,t,N)

end,
["SpellCard_SSS04_02A"]=function(o,t,N)

end,
["SpellCard_SSS04_02B"]=function(o,t,N)

end,
["SpellCard_SSS04_02C"]=function(o,t,N)

end,
["SpellCard_SSS04_02D"]=function(o,t,N)

end,
["SpellCard_SSS04_03A"]=function(o,t,N)

end,
["SpellCard_SSS04_03B"]=function(o,t,N)

end,
["SpellCard_SSS04_03C"]=function(o,t,N)

end,
["SpellCard_SSS04_03D"]=function(o,t,N)

end,
["SpellCard_SSS04_04A"]=function(o,t,N)

end,
["SpellCard_SSS04_04B"]=function(o,t,N)

end,
["SpellCard_SSS04_04C"]=function(o,t,N)

end,
["SpellCard_SSS04_04D"]=function(o,t,N)

end,
["SpellCard_SSS04_05"]=function(o,t,N)

end,
["SpellCard_SSS04_FSC"]=function(o,t,N)

end,
["SpellCard_SSS05_00"]=function(o,t,N)

end,
["SpellCard_SSS05_01"]=function(o,t,N)

end,
["SpellCard_SSS05_02"]=function(o,t,N)

end,
["SpellCard_SSS05_03"]=function(o,t,N)

end,
["SpellCard_SSS05_04"]=function(o,t,N)

end,
["SpellCard_SSS05_05"]=function(o,t,N)

end,
["SpellCard_SSS05_FSC"]=function(o,t,N)

end,
["SpellCard_SSS06_01"]=function(o,t,N)

end,
["SpellCard_SSS06_02"]=function(o,t,N)

end,
["SpellCard_SSS06_03"]=function(o,t,N)

end,
["SpellCard_SSS06_04"]=function(o,t,N)

end,
["SpellCard_SSS06_05"]=function(o,t,N)

end,
["SpellCard_SSS06_06"]=function(o,t,N)

end,
["SpellCard_SSS06_FSC01"]=function(o,t,N)

end,
["SpellCard_SSS06_FSC02"]=function(o,t,N)

end,
["SpellCard_SSS06_FSC03"]=function(o,t,N)

end,
["SpellCard_SSSEx_01"]=function(o,t,N)

end,
["SpellCard_SSSEx_01A"]=function(o,t,N)

end,
["SpellCard_SSSEx_01B"]=function(o,t,N)

end,
["SpellCard_SSSEx_01C"]=function(o,t,N)

end,
["SpellCard_SSSEx_01D"]=function(o,t,N)

end,
["SpellCard_SSSEx_02"]=function(o,t,N)

end,
["SpellCard_SSSEx_02A"]=function(o,t,N)

end,
["SpellCard_SSSEx_02B"]=function(o,t,N)

end,
["SpellCard_SSSEx_02C"]=function(o,t,N)

end,
["SpellCard_SSSEx_02D"]=function(o,t,N)

end,
["SpellCard_SSSEx_03"]=function(o,t,N)

end,
["SpellCard_SSSEx_03A"]=function(o,t,N)

end,
["SpellCard_SSSEx_03B"]=function(o,t,N)

end,
["SpellCard_SSSEx_03C"]=function(o,t,N)

end,
["SpellCard_SSSEx_03D"]=function(o,t,N)

end,
["SpellCard_SSSEx_04A"]=function(o,t,N)

end,
["SpellCard_SSSEx_04B"]=function(o,t,N)

end,
["SpellCard_SSSEx_04C"]=function(o,t,N)

end,
["SpellCard_SSSEx_04D"]=function(o,t,N)

end,
["SpellCard_SSSEx_05A"]=function(o,t,N)

end,
["SpellCard_SSSEx_05B"]=function(o,t,N)

end,
["SpellCard_SSSEx_05C"]=function(o,t,N)

end,
["SpellCard_SSSEx_05D"]=function(o,t,N)

end,
["SpellCard_SSSEx_06A"]=function(o,t,N)

end,
["SpellCard_SSSEx_06B"]=function(o,t,N)

end,
["SpellCard_SSSEx_06C"]=function(o,t,N)

end,
["SpellCard_SSSEx_06D"]=function(o,t,N)

end,
["SpellCard_SSSEx_07A"]=function(o,t,N)

end,
["SpellCard_SSSEx_07B"]=function(o,t,N)

end,
["SpellCard_SSSEx_07C"]=function(o,t,N)

end,
["SpellCard_SSSEx_07D"]=function(o,t,N)

end,
["SpellCard_SSSEx_08"]=function(o,t,N)

end,
["SpellCard_SSSEx_09"]=function(o,t,N)

end,
["SpellCard_SSSEx_10"]=function(o,t,N)

end,
["SpellCard_SSSEx_FSC"]=function(o,t,N)

end,
},opening={
["SpellCard_SSS01_01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS01_02"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS01_03"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS01_FSC"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS02_01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS02_02"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS02_03"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS02_04"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS02_FSC"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS03_01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS03_02"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS03_03"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS03_04"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS03_05"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS03_FSC"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_02A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_02B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_02C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_02D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_03A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_03B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_03C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_03D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_04A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_04B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_04C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_04D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_05"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS04_FSC"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS05_00"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS05_01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS05_02"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS05_03"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS05_04"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS05_05"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS05_FSC"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_02"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_03"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_04"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_05"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_06"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_FSC01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_FSC02"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSS06_FSC03"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_01"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_01A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_01B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_01C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_01D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_02"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_02A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_02B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_02C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_02D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_03"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_03A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_03B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_03C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_03D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_04A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_04B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_04C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_04D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_05A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_05B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_05C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_05D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_06A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_06B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_06C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_06D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_07A"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_07B"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_07C"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_07D"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_08"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_09"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_10"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
["SpellCard_SSSEx_FSC"]=function(o,t,N)
if true then N.sound("se_cat00.wav") end
end,
}}
