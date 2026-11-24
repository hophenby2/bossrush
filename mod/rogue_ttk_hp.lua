-- tools/calibrate_ports_hp.py 生成；低速、满火力、包含子机的活跃TTK中位数。
-- 原HP数值域/免疫/卡片减伤不变；Like Dreamer后端的×52只计算一次。
local H={damageUnits={},bossDamageUnits={},scale={}}
H.damageUnits[35]=10.751470837073255
H.scale[35]=0.093010529922268589
H.damageUnits[36]=8.8748621934792347
H.scale[36]=0.11267780594213006
H.damageUnits[37]=25.976024170238961
H.bossDamageUnits[37]=11.428571428571429
H.scale[37]=0.087499999999999994
H.damageUnits[38]=10.559931871407281
H.scale[38]=0.094697580645161289
H.damageUnits[39]=1.2121212121212122
H.scale[39]=0.82499999999999996
H.damageUnits[40]=0.91908091908091905
H.scale[40]=0.020923913043478262
H.damageUnits[41]=1.402597402597316
H.scale[41]=0.71296296296300699
return H
