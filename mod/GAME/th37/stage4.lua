-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。
return function(R,state,t)
if t==0 then
R.stage_PlayMusic(state,"road")
R.stage_LoadBackGround(state)
end
if t==1 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","3480","9990","10")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"6480")
end
if t==420 then
R.stage_SetEnemy(state,"28","-20","110","1.2","0","399","20","1","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_AddEvent(state,"12","speed","4.1","60","1")
end
if t==430 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
end
if t==440 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
end
if t==450 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
end
if t==460 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
end
if t==470 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
end
if t==480 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
end
if t==490 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
end
if t==500 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
end
if t==510 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
end
if t==520 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
end
if t==530 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
end
if t==540 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
end
if t==550 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
end
if t==560 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
end
if t==570 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
end
if t==580 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
end
if t==590 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
end
if t==600 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
end
if t==610 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
end
if t==620 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
end
if t==840 then
R.stage_SetEnemy(state,"28","470","110","1.2","180","399","20","1","2")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_AddEvent(state,"12","speed","4.1","60","1")
end
if t==850 then
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==860 then
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==870 then
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==880 then
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==890 then
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==900 then
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==910 then
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==920 then
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==930 then
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==940 then
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==950 then
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==960 then
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==970 then
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==980 then
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==990 then
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1000 then
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1010 then
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1020 then
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1030 then
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1040 then
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1260 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1270 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1280 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1290 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1300 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1310 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1320 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1330 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1340 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1350 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1360 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1370 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1380 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1390 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1400 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1410 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1420 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1430 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1440 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1450 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1460 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1470 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1480 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1490 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1500 then
R.stage_CopyEnemy(state,"-20","110","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","110","0+12","false","all","2")
end
if t==1510 then
R.stage_CopyEnemy(state,"-20","130","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","130","0+12","false","all","2")
end
if t==1520 then
R.stage_CopyEnemy(state,"-20","150","0+12","false","all","1")
R.stage_CopyEnemy(state,"470","150","0+12","false","all","2")
end
if t==1830 then
R.stage_ShowTitle(state)
end
if t==2490 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","2180","9990","222")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"2180")
end
if t==2620 then
R.stage_SetEnemy(state,"4","449","272","2.4","150","999","900","3")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","330","240","1")
end
if t==2640 then
R.stage_SetEnemy(state,"28","449","272","2.4","150","999","150","101","3")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","330","240","1")
end
if t==2660 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2680 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2700 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2720 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2740 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2760 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2780 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2800 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2820 then
R.stage_CopyEnemy(state,"449","272","0","false","all","3")
end
if t==2980 then
R.stage_SetEnemy(state,"4","1","272","2.4","30","999","900","2")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","-150","240","1")
end
if t==3000 then
R.stage_SetEnemy(state,"28","1","272","2.4","30","999","150","101","4")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","-150","240","1")
end
if t==3020 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3040 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3060 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3080 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3100 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3120 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3140 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3160 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3180 then
R.stage_CopyEnemy(state,"1","272","0","false","all","4")
end
if t==3360 then
R.stage_SetEnemy(state,"28","424+20","-20+10","3.8+1.2","105","500","120","4","5")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","180","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetEnemy(state,"5","124+200","-20+10","3.8+1.2","70+40","400","180","6","7")
R.stage_AddEvent(state,"1","speed","0.1","30","1")
R.stage_AddEvent(state,"230","speed","3.0","30","1")
R.stage_AddEvent(state,"230","speedf","200+100","1","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==3380 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3390 then
R.stage_SetEnemy(state,"28","4+20","-20+10","3.8+1.6","75","500","120","4","6")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","0","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==3400 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3420 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==3430 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3440 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3450 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3460 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==3470 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3480 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3490 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3500 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==3510 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3520 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3530 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3540 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==3550 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3560 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3570 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3580 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==3590 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3600 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3610 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3620 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==3630 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3640 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3650 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3660 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==3670 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3680 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3690 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3700 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3710 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3720 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3730 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3740 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3750 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3760 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3770 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3780 then
R.stage_CopyEnemy(state,"434","-40+20","0","false","all","5")
end
if t==3790 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==3810 then
R.stage_CopyEnemy(state,"14","-40+20","0","false","all","6")
end
if t==4020 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","2780","9990","333")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"2780")
end
if t==4110 then
R.stage_SetEnemy(state,"4","229","500","2.4","215","999","900","2")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","395","240","1")
end
if t==4130 then
R.stage_SetEnemy(state,"28","229","500","2.4","215","999","150","101","8")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","395","240","1")
end
if t==4150 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4170 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4190 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4210 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4230 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4250 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4270 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4290 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4310 then
R.stage_CopyEnemy(state,"229","500","0","false","all","8")
end
if t==4470 then
R.stage_SetEnemy(state,"4","6","142","2.4","62","999","900","3")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","-118","240","1")
end
if t==4490 then
R.stage_SetEnemy(state,"28","6","142","2.4","62","999","150","101","9")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"5")
R.stage_AddEvent(state,"1","speedf","-118","240","1")
end
if t==4510 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4530 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4550 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4570 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4590 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4610 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4630 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4650 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4670 then
R.stage_CopyEnemy(state,"6","142","0","false","all","9")
end
if t==4890 then
R.stage_SetEnemy(state,"4","444","141","2.4","118","999","900","2")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","298","240","1")
end
if t==4910 then
R.stage_SetEnemy(state,"28","444","141","2.4","118","999","150","101","10")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"5")
R.stage_AddEvent(state,"1","speedf","298","240","1")
end
if t==4930 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==4950 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==4970 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==4990 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==5010 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==5030 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==5050 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==5070 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==5090 then
R.stage_CopyEnemy(state,"444","141","0","false","all","10")
end
if t==5250 then
R.stage_SetEnemy(state,"4","219","500","2.4","325","999","900","3")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","145","240","1")
end
if t==5270 then
R.stage_SetEnemy(state,"28","219","500","2.4","325","999","150","101","11")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"5")
R.stage_AddEvent(state,"1","speedf","145","240","1")
end
if t==5290 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5310 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5330 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5350 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5370 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5390 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5410 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5430 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5450 then
R.stage_CopyEnemy(state,"219","500","0","false","all","11")
end
if t==5610 then
R.stage_SetEnemy(state,"4","446","325","2.4","155","999","900","2")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","335","240","1")
end
if t==5630 then
R.stage_SetEnemy(state,"28","446","325","2.4","155","999","120","101","12")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"5")
R.stage_AddEvent(state,"1","speedf","335","240","1")
end
if t==5650 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
end
if t==5670 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
end
if t==5690 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
end
if t==5710 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
end
if t==5730 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
R.stage_SetEnemy(state,"4","458","16","2.4","90","999","900","3")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","270","240","1")
end
if t==5750 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
R.stage_SetEnemy(state,"28","458","16","2.4","90","999","120","101","13")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"5")
R.stage_AddEvent(state,"1","speedf","270","240","1")
end
if t==5770 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5790 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5810 then
R.stage_CopyEnemy(state,"446","325","0","false","all","12")
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5830 then
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5850 then
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5870 then
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5890 then
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5910 then
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==5930 then
R.stage_CopyEnemy(state,"458","16","0","false","all","13")
end
if t==6000 then
R.stage_SetEnemy(state,"4","5","326","2.4","25","999","900","2")
R.stage_SetEnemyItems(state,"0","3","0","3","0","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","-155","240","1")
end
if t==6020 then
R.stage_SetEnemy(state,"28","5","326","2.4","25","999","120","101","14")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","-155","240","1")
end
if t==6040 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6060 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6080 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6100 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6120 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6140 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6150 then
R.stage_SetEnemy(state,"4","-4","16","2.4","90","999","900","3")
R.stage_SetEnemyItems(state,"0","3","0","3","1","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","-90","240","1")
end
if t==6160 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6170 then
R.stage_SetEnemy(state,"28","-4","16","2.4","90","999","120","101","15")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"1","speedf","-90","240","1")
end
if t==6180 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6190 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6200 then
R.stage_CopyEnemy(state,"5","326","0","false","all","14")
end
if t==6210 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6230 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6250 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6270 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6290 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6310 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6330 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6350 then
R.stage_CopyEnemy(state,"-4","16","0","false","all","15")
end
if t==6380 then
R.stage_SetEnemy(state,"28","4+20","-20+10","3.8+1.6","75","500","160","7","17")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","0","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==6390 then
R.stage_SetEnemy(state,"28","424+20","-20","3.8+1.2","105","500","160","7","16")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","180","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==6400 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6410 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6440 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6450 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6480 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6490 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6510 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==6520 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6530 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6560 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6570 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6600 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6610 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6630 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==6640 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6650 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6680 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6690 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6720 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6730 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6750 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==6760 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6770 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6800 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6810 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6840 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6850 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6880 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6890 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6920 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==6930 then
R.stage_CopyEnemy(state,"434","-20+10","0","false","all","16")
end
if t==6960 then
R.stage_CopyEnemy(state,"14","-20+10","0","false","all","17")
end
if t==7020 then
R.stage_SetBossItems(state,"0","20","0","20","0","0","1","100","0")
end
if t==7080 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","1780","9990","444")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1780")
end
if t==7170 then
R.stage_SetEnemy(state,"4","175","500","2.4","215","999","900","502")
R.stage_SetEnemyItems(state,"0","3","0","3","0","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","395","240","1")
end
if t==7190 then
R.stage_SetEnemy(state,"28","175","500","2.4","215","999","120","101","18")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","395","240","1")
end
if t==7210 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7230 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7250 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7270 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7290 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7310 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7330 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7350 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7370 then
R.stage_CopyEnemy(state,"175","500","0","false","all","18")
end
if t==7440 then
R.stage_SetEnemy(state,"4","446","293","2.4","155","999","900","502")
R.stage_SetEnemyItems(state,"0","3","0","3","0","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","335","240","1")
end
if t==7460 then
R.stage_SetEnemy(state,"28","446","293","2.4","155","999","120","101","19")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","335","240","1")
end
if t==7480 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7500 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7520 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7530 then
R.stage_SetEnemy(state,"4","6","110","2.4","62","599","900","502")
R.stage_SetEnemyItems(state,"0","3","0","3","0","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","-118","240","1")
end
if t==7540 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7550 then
R.stage_SetEnemy(state,"28","6","110","2.4","62","599","120","101","20")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","-118","240","1")
end
if t==7560 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7570 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7580 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7590 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7600 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7610 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7620 then
R.stage_CopyEnemy(state,"446","293","0","false","all","19")
end
if t==7630 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7650 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7670 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7680 then
R.stage_SetEnemy(state,"4","275","500","2.4","325","599","900","502")
R.stage_SetEnemyItems(state,"0","3","0","3","0","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","145","240","1")
end
if t==7690 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7700 then
R.stage_SetEnemy(state,"28","275","500","2.4","325","599","120","101","21")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","145","240","1")
end
if t==7710 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7720 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7730 then
R.stage_CopyEnemy(state,"6","110","0","false","all","20")
end
if t==7740 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7760 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7780 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7800 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7820 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7840 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7860 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7880 then
R.stage_CopyEnemy(state,"275","500","0","false","all","21")
end
if t==7980 then
R.stage_SetEnemy(state,"4","444","141","2.4","118","599","900","502")
R.stage_SetEnemyItems(state,"0","3","0","3","0","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","298","240","1")
end
if t==8000 then
R.stage_SetEnemy(state,"28","444","141","2.4","118","599","120","101","22")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","298","240","1")
end
if t==8020 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
end
if t==8040 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
end
if t==8060 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
end
if t==8080 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
end
if t==8100 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
end
if t==8120 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
end
if t==8140 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
end
if t==8160 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
R.stage_SetEnemy(state,"4","5","293","2.4","25","599","900","502")
R.stage_SetEnemyItems(state,"0","3","0","3","0","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","-155","240","1")
end
if t==8180 then
R.stage_CopyEnemy(state,"444","141","0","false","all","22")
R.stage_SetEnemy(state,"28","5","293","2.4","25","599","120","101","23")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"1","speedf","-155","240","1")
end
if t==8200 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8220 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8240 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8260 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8280 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8300 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8320 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8340 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8360 then
R.stage_CopyEnemy(state,"5","293","0","false","all","23")
end
if t==8520 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","1480","9990","119")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1480")
end
if t==8580 then
R.stage_SetEnemy(state,"24","68","-10","1.8","90","419","800","9","25")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_SetNoHarmTime(state,"100")
R.stage_SetEnemy(state,"24","380","-70","1.8","90","419","800","9","26")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_SetNoHarmTime(state,"130")
end
if t==8660 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==8700 then
R.stage_SetEnemy(state,"25","124+200","-20+10","3.8+1.2","90","900","600","8","24")
R.stage_AddEvent(state,"0","speed","0.1","30","1")
R.stage_AddEvent(state,"230","speed","3.0","30","1")
R.stage_AddEvent(state,"230","speedf","90","1","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==8740 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==8760 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","24")
end
if t==8820 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==8880 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","24")
end
if t==8900 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==8980 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9000 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","24")
end
if t==9060 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9120 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","24")
end
if t==9140 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9220 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9240 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","24")
end
if t==9300 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9360 then
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","24")
end
if t==9380 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9460 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9540 then
R.stage_CopyEnemy(state,"68","-10","0","false","all","25")
R.stage_CopyEnemy(state,"380","-70","0","false","all","26")
end
if t==9780 then
R.stage_SetBossItems(state,"0","20","0","20","0","0","0","100","0")
end
if t==9810 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","1380","9990","555")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1380")
end
if t==9900 then
R.stage_SetEnemy(state,"28","434","-10","3.8+1.2","105","500","130","7","11")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","180","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetEnemy(state,"28","464","-50","3.8+1.2","105","500","130","5","5")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","180","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==9930 then
R.stage_SetEnemy(state,"28","14","-10","4.8+1.6","75","500","130","7","12")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","0","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetEnemy(state,"28","-24","-50","4.8+1.6","75","500","130","5","6")
R.stage_AddEvent(state,"0","speed","0.5","30","1")
R.stage_AddEvent(state,"30","speed","3.0","30","1")
R.stage_AddEvent(state,"30","speedf","0","60","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetEnemy(state,"5","124+200","-20+10","3.8+1.2","70+40","400","200","6","7")
R.stage_AddEvent(state,"1","speed","0.1","30","1")
R.stage_AddEvent(state,"230","speed","3.0","30","1")
R.stage_AddEvent(state,"230","speedf","200+100","1","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==9940 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
end
if t==9970 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==9990 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10000 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
end
if t==10020 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10030 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
end
if t==10040 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10060 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
end
if t==10070 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10090 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10120 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10140 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10150 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
end
if t==10170 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10180 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
end
if t==10190 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10210 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
end
if t==10220 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10240 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10270 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10290 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10300 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
end
if t==10320 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10330 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
end
if t==10340 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10360 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
end
if t==10370 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10390 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10420 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10440 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10450 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
end
if t==10470 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10480 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
end
if t==10490 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
R.stage_CopyEnemy(state,"124+200","-20+10","0","false","all","7")
end
if t==10510 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
end
if t==10520 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10540 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
end
if t==10570 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10590 then
R.stage_CopyEnemy(state,"464","-50","0","false","all","5")
end
if t==10600 then
R.stage_CopyEnemy(state,"434","-10","0","false","all","11")
end
if t==10620 then
R.stage_CopyEnemy(state,"-24","-50","0","false","all","6")
end
if t==10630 then
R.stage_CopyEnemy(state,"14","-10","0","false","all","12")
end
if t==10980 then
R.stage_SetEnemy(state,"4","224","-10","5.0","90","1499","15000","111")
R.stage_SetEnemyItems(state,"0","9","100","9","0","1")
R.stage_SetNoHarmTime(state,"90")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"1360","speedf","270","1","1")
R.stage_AddEvent(state,"1360","speed","2","90","1")
end
if t==11790 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","1680","9990","666")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1680")
end
if t==13140 then
R.stage_SetBossItems(state,"0","20","0","20","0","0","1","0","0")
end
end
