-- 蕾可的移动速度来自两版横移实测。自弹、低速射击和炸弹使用共用原生对象。
return function(speed)
    return {
        name='蕾可',speed=speed*64,focus=80,hold=18,bombs=3,spawnX=120*64,spawnY=50*64,
        shot={{0,0}},interval=2,shotSpeed=10.5,shotDamage=28,
        laserWidth=8,laserDamage=42,bomb=66,focusBomb=80,bombWidth=55,bombDamage=88,
        color={178,247,123},
    }
end
