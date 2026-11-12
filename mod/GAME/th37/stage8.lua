-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。
return function(R,state,t)
if t==0 then
R.stage_LoadBackGround(state)
end
if t==1 then
R.stage_PlayMusic(state,"road")
end
if t==235 then
R.stage_SetEnemy(state,"28","224","140","0","270","455","120","1","1")
R.stage_AddEvent(state,"305","speed","3.2","30","1")
R.stage_SetEnemyItems(state,"0","2","0","3","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==240 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==245 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==250 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==255 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==260 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==265 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==270 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==275 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==280 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==285 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==290 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==295 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","1")
end
if t==420 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==425 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==430 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==435 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==440 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==445 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==450 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==455 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==460 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==465 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==470 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==475 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==480 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","1")
end
if t==630 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==635 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==640 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==645 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==650 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==655 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==660 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==665 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==670 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==675 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==680 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==685 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==690 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","1")
end
if t==840 then
R.stage_ShowTitle(state)
end
if t==1021 then
R.stage_SetEnemy(state,"28","124","140","0","270","455","120","2","2")
R.stage_AddEvent(state,"305","speed","3.2","30","1")
R.stage_SetEnemyItems(state,"0","2","0","3","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==1025 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","2")
end
if t==1030 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","2")
end
if t==1035 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","2")
end
if t==1040 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","2")
end
if t==1045 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","2")
end
if t==1050 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","2")
end
if t==1260 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","2")
end
if t==1265 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","2")
end
if t==1270 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","2")
end
if t==1275 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","2")
end
if t==1280 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","2")
end
if t==1285 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","2")
end
if t==1290 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","2")
end
if t==1440 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1445 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1450 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1455 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1460 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1465 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1470 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1475 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1480 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1485 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1490 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1495 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1500 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","2")
end
if t==1620 then
R.stage_SetEnemy(state,"6","-40","90","4.8","0","999","1800","5","3")
R.stage_SetEnemyItems(state,"0","20","0","20","0","1")
R.stage_SetNoHarmTime(state,"40")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"240","speedf","140","90","1")
R.stage_AddEvent(state,"240","speed","2","90","1")
end
if t==1860 then
R.stage_SetEnemy(state,"6","490","90","4.8","180","999","1800","6","4")
R.stage_SetEnemyItems(state,"0","20","0","20","0","1")
R.stage_SetNoHarmTime(state,"40")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"240","speedf","40","90","1")
R.stage_AddEvent(state,"240","speed","2","90","1")
end
if t==2100 then
R.stage_CopyEnemy(state,"-40","90","0","false","all","3")
end
if t==2310 then
R.stage_CopyEnemy(state,"490","90","0","false","all","4")
end
if t==2460 then
R.stage_SetEnemy(state,"26","64","140","0","0","525","120","3","5")
R.stage_AddEvent(state,"210","speed","1.8","30","1")
R.stage_SetEnemyItems(state,"0","2","0","3","0","0")
R.stage_SetNoHarmTime(state,"185")
end
if t==2490 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
R.stage_SetEnemy(state,"26","334","140","0","180","525","120","4","6")
R.stage_AddEvent(state,"210","speed","1.8","30","1")
R.stage_SetEnemyItems(state,"0","2","0","3","0","0")
R.stage_SetNoHarmTime(state,"185")
end
if t==2520 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
end
if t==2550 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
end
if t==2580 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
end
if t==2610 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
end
if t==2640 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
end
if t==2670 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
end
if t==2700 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
R.stage_SetEnemy(state,"28","224","140","0","90","525","120","7","7")
R.stage_AddEvent(state,"195","speed","3.2","30","1")
R.stage_SetEnemyItems(state,"0","2","0","3","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==2730 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==2760 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==2790 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==2820 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==2850 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==2880 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==2910 then
R.stage_CopyEnemy(state,"55+50","40+190","0","false","all","5")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==2940 then
R.stage_CopyEnemy(state,"325+50","40+190","0","false","all","6")
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3090 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3100 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3110 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3120 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3130 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3140 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3150 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3160 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3170 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3180 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","7")
end
if t==3240 then
R.stage_SetEnemy(state,"6","-30","148","4.9","0","999","1800","9","8")
R.stage_SetEnemyItems(state,"0","20","0","20","1","0")
R.stage_SetNoHarmTime(state,"40")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"640","speedf","270","90","1")
R.stage_AddEvent(state,"640","speed","2","90","1")
end
if t==3420 then
R.stage_CopyEnemy(state,"234+100","50+80","0","false","all","1")
end
if t==3430 then
R.stage_CopyEnemy(state,"234+100","50+80","0","false","all","1")
end
if t==3440 then
R.stage_CopyEnemy(state,"234+100","50+80","0","false","all","1")
end
if t==3450 then
R.stage_CopyEnemy(state,"234+100","50+80","0","false","all","1")
end
if t==3460 then
R.stage_CopyEnemy(state,"234+100","50+80","0","false","all","1")
end
if t==3470 then
R.stage_CopyEnemy(state,"234+100","50+80","0","false","all","1")
end
if t==3480 then
R.stage_CopyEnemy(state,"234+100","50+80","0","false","all","1")
R.stage_SetEnemy(state,"6","480","148","4.9","180","999","1800","9","9")
R.stage_SetEnemyItems(state,"0","20","0","20","1","0")
R.stage_SetNoHarmTime(state,"40")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"640","speedf","270","90","1")
R.stage_AddEvent(state,"640","speed","2","90","1")
end
if t==3660 then
R.stage_CopyEnemy(state,"114+100","50+80","0","false","all","1")
end
if t==3670 then
R.stage_CopyEnemy(state,"114+100","50+80","0","false","all","1")
end
if t==3680 then
R.stage_CopyEnemy(state,"114+100","50+80","0","false","all","1")
end
if t==3690 then
R.stage_CopyEnemy(state,"114+100","50+80","0","false","all","1")
end
if t==3700 then
R.stage_CopyEnemy(state,"114+100","50+80","0","false","all","1")
end
if t==3710 then
R.stage_CopyEnemy(state,"114+100","50+80","0","false","all","1")
end
if t==3720 then
R.stage_CopyEnemy(state,"114+100","50+80","0","false","all","1")
R.stage_SetEnemy(state,"6","224","-20","3.8","90","999","3900","8")
R.stage_SetEnemyItems(state,"0","20","0","20","1","0")
R.stage_SetNoHarmTime(state,"60")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"640","speedf","270","90","1")
R.stage_AddEvent(state,"640","speed","2","90","1")
end
if t==4140 then
R.stage_SetEnemy(state,"28","-10","140","5","0","300","40","111","16")
R.stage_AddEvent(state,"1","speed","3.2","60","1")
R.stage_AddEvent(state,"1","speedf","25","120","3")
R.stage_AddEvent(state,"121","speedf","25","120","3")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==4150 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4160 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4170 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4180 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4190 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4200 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4210 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4220 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4230 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4240 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4250 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4260 then
R.stage_CopyEnemy(state,"-10","50+120","0","false","all","16")
end
if t==4350 then
R.stage_SetEnemy(state,"28","460","140","5","180","300","40","111","17")
R.stage_AddEvent(state,"1","speed","3.2","60","1")
R.stage_AddEvent(state,"1","speedf","155","120","3")
R.stage_AddEvent(state,"121","speedf","155","120","3")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==4360 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4370 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4380 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4390 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4400 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4410 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4420 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4430 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4440 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4450 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4460 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4470 then
R.stage_CopyEnemy(state,"460","50+120","0","false","all","17")
end
if t==4500 then
R.stage_SetEnemy(state,"26","224","100","0","180","420","500","114","13")
R.stage_SetEnemyItems(state,"0","8","0","8","0","0")
R.stage_SetNoHarmTime(state,"60")
end
if t==4560 then
R.stage_CopyEnemy(state,"84","100","0","false","all","13")
end
if t==4620 then
R.stage_CopyEnemy(state,"364","100","0","false","all","13")
end
if t==4680 then
R.stage_CopyEnemy(state,"154","100","0","false","all","13")
end
if t==4740 then
R.stage_CopyEnemy(state,"294","100","0","false","all","13")
end
if t==4896 then
R.stage_CopyEnemy(state,"75","140","0","false","all","13")
end
if t==4908 then
R.stage_CopyEnemy(state,"125","70","0","false","all","13")
end
if t==4920 then
R.stage_CopyEnemy(state,"175","140","0","false","all","13")
end
if t==4932 then
R.stage_CopyEnemy(state,"225","70","0","false","all","13")
end
if t==4944 then
R.stage_CopyEnemy(state,"275","140","0","false","all","13")
end
if t==4956 then
R.stage_CopyEnemy(state,"325","70","0","false","all","13")
end
if t==5100 then
R.stage_CopyEnemy(state,"375","140","0","false","all","13")
end
if t==5112 then
R.stage_CopyEnemy(state,"325","70","0","false","all","13")
end
if t==5124 then
R.stage_CopyEnemy(state,"275","140","0","false","all","13")
end
if t==5136 then
R.stage_CopyEnemy(state,"225","70","0","false","all","13")
end
if t==5148 then
R.stage_CopyEnemy(state,"175","140","0","false","all","13")
end
if t==5160 then
R.stage_CopyEnemy(state,"125","70","0","false","all","13")
end
if t==5304 then
R.stage_CopyEnemy(state,"75","140","0","false","all","13")
end
if t==5316 then
R.stage_CopyEnemy(state,"125","70","0","false","all","13")
end
if t==5328 then
R.stage_CopyEnemy(state,"175","140","0","false","all","13")
end
if t==5340 then
R.stage_CopyEnemy(state,"225","70","0","false","all","13")
end
if t==5352 then
R.stage_CopyEnemy(state,"275","140","0","false","all","13")
end
if t==5364 then
R.stage_CopyEnemy(state,"325","70","0","false","all","13")
end
if t==5376 then
R.stage_CopyEnemy(state,"375","140","0","false","all","13")
end
if t==5640 then
R.stage_SetEnemy(state,"19","224","-40","0.0","90","1500","9990","113")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1500")
end
if t==5760 then
R.stage_SetEnemy(state,"27","134","-28","1","90","999","3100","112","11")
R.stage_SetEnemyItems(state,"0","15","0","15","0","1")
R.stage_SetNoHarmTime(state,"20")
end
if t==5940 then
R.stage_CopyEnemy(state,"314","-28","0","false","all","11")
end
if t==6120 then
R.stage_CopyEnemy(state,"134","-28","0","false","all","11")
end
if t==6300 then
R.stage_CopyEnemy(state,"314","-28","0","false","all","11")
end
if t==6480 then
R.stage_CopyEnemy(state,"134","-28","0","false","all","11")
end
if t==6660 then
R.stage_SetEnemy(state,"27","314","-28","1","90","999","1600","112")
R.stage_SetEnemyItems(state,"0","12","0","12","0","1")
end
if t==7020 then
R.stage_SetBossItems(state,"100","24","100","24","0","100","0","0","0")
end
if t==7070 then
R.stage_SetEnemy(state,"28","224","140","0","270","625","130","115","19")
R.stage_AddEvent(state,"445","speed","3.2","30","1")
R.stage_SetEnemyItems(state,"0","2","0","3","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==7080 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","19")
end
if t==7090 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","19")
end
if t==7100 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","19")
end
if t==7110 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","19")
end
if t==7120 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","19")
end
if t==7130 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","19")
end
if t==7140 then
R.stage_CopyEnemy(state,"74+100","50+120","0","false","all","19")
end
if t==7150 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","19")
end
if t==7160 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","19")
end
if t==7170 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","19")
end
if t==7180 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","19")
end
if t==7190 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","19")
end
if t==7200 then
R.stage_CopyEnemy(state,"174+100","50+120","0","false","all","19")
end
if t==7210 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","19")
end
if t==7220 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","19")
end
if t==7230 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","19")
end
if t==7240 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","19")
end
if t==7250 then
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","19")
end
if t==7260 then
R.stage_SetEnemy(state,"19","224","-40","0.0","90","2800","9990","117")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"2800")
R.stage_CopyEnemy(state,"274+100","50+120","0","false","all","19")
end
if t==7500 then
R.stage_SetEnemy(state,"26","224","-20","2","90","230","100","116","18")
R.stage_AddEvent(state,"1","speedf","90","1","1")
R.stage_AddEvent(state,"1","speed","5.5+1","1","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==7530 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7540 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7550 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7560 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7570 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7580 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7590 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7600 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7610 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7620 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7630 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7640 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7650 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7660 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7670 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7680 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7690 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7700 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7710 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7720 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7730 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7740 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7750 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7760 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7770 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7780 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7790 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7800 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7810 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7815 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7820 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7825 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7830 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7835 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7840 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7845 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7850 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7855 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7860 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7865 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7870 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7875 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7880 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7885 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7890 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7895 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7900 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7905 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7910 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7915 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7920 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7925 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7930 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7935 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7940 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7945 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7950 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7955 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7960 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7965 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7970 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7975 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7980 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7985 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7990 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==7995 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8000 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8005 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8010 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8015 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8020 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8025 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8030 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8035 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8040 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8045 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8050 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8055 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8060 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8065 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8070 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8075 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8080 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8085 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8090 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8095 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8100 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8105 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8110 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8115 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8120 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8125 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8130 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8135 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8140 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8145 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8150 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8155 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8160 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8165 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8170 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8175 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8180 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8185 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8190 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8195 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8200 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8205 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8210 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8215 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8220 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8225 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8230 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8235 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8240 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8245 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8250 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8255 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8260 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8265 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8270 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8275 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8280 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8285 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8290 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8295 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8300 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8305 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8310 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8315 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8320 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8325 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8330 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8335 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8340 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8345 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8350 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8355 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8360 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8365 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8370 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8375 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8380 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8385 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8390 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8395 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8400 then
R.stage_CopyEnemy(state,"24+400","-20","0","false","all","18")
end
if t==8520 then
R.stage_SetEnemy(state,"4","-40","90","4.2","0","1399","1200","11")
R.stage_SetEnemyItems(state,"0","20","0","20","1","0")
R.stage_SetNoHarmTime(state,"40")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"1080","speedf","140","90","1")
R.stage_AddEvent(state,"1080","speed","2","90","1")
R.stage_SetEnemy(state,"4","490","90","4.2","180","1399","1200","11")
R.stage_SetEnemyItems(state,"0","20","0","20","1","0")
R.stage_SetNoHarmTime(state,"40")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"1080","speedf","40","90","1")
R.stage_AddEvent(state,"1080","speed","2","90","1")
end
if t==9840 then
R.stage_SetBossItems(state,"100","24","100","24","0","100","0","0","0")
end
if t==9900 then
R.stage_LastBoss(state)
R.stage_ExtraBoss(state)
R.stage_SetBossItems(state,"100","30","100","30","0","0","1","0","0")
end
if t==9925 then
R.stage_SetEnemy(state,"19","224","-40","0.0","90","860","9990","119")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"860")
end
if t==10225 then
R.stage_LastBoss(state)
R.stage_ExtraBoss(state)
R.stage_SetBossItems(state,"100","66","100","66","0","0","0","0","0")
end
end
