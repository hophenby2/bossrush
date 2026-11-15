-- Espgaluda II。普通弹和低速射击使用 LuaSTG 自弹与激光。
dofile('mod/GAME/cv1000/stage.lua')('TH47',45,{
    name='Ageha',speed=176,focus=90,hold=15,bombs=3,spawnX=120*64,spawnY=50*64,
    shot={{-5,0},{5,0}},interval=3,shotSpeed=9.5,shotDamage=23,
    laserWidth=7,laserDamage=46,bomb=68,focusBomb=88,bombWidth=54,bombDamage=90,
    color={108,240,167},
})
