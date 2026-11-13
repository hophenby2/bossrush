-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。
return function(R,state,t)
if t==0 then
R.stage_PlayMusic(state,"road")
R.stage_LoadBackGround(state)
end
if t==10 then
R.stage_SetEnemy(state,"7","224","-40","0.0","20","4360","9990","97")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"4390")
end
if t==190 then
R.stage_ShowTitle(state)
end
if t==420 then
R.stage_SetEnemy(state,"7","100","-20","3","90","400","40","91","1")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","55","1")
R.stage_AddEvent(state,"1","speedf","90","5","1")
R.stage_AddEvent(state,"60","speed","2.5","5","1")
R.stage_AddEvent(state,"60","speedf","45","1","1")
end
if t==430 then
R.stage_CopyEnemy(state,"140","-20","0","false","all","1")
end
if t==440 then
R.stage_CopyEnemy(state,"100","-20","0","false","all","1")
end
if t==450 then
R.stage_CopyEnemy(state,"140","-20","0","false","all","1")
end
if t==460 then
R.stage_CopyEnemy(state,"100","-20","0","false","all","1")
end
if t==470 then
R.stage_CopyEnemy(state,"140","-20","0","false","all","1")
end
if t==480 then
R.stage_CopyEnemy(state,"100","-20","0","false","all","1")
end
if t==490 then
R.stage_CopyEnemy(state,"140","-20","0","false","all","1")
end
if t==500 then
R.stage_CopyEnemy(state,"100","-20","0","false","all","1")
end
if t==540 then
R.stage_SetEnemy(state,"7","348","-20","3","90","400","40","91","2")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","55","1")
R.stage_AddEvent(state,"1","speedf","90","5","1")
R.stage_AddEvent(state,"60","speed","2.5","5","1")
R.stage_AddEvent(state,"60","speedf","135","1","1")
end
if t==550 then
R.stage_CopyEnemy(state,"308","-20","0","false","all","2")
end
if t==560 then
R.stage_CopyEnemy(state,"348","-20","0","false","all","2")
end
if t==570 then
R.stage_CopyEnemy(state,"308","-20","0","false","all","2")
end
if t==580 then
R.stage_CopyEnemy(state,"348","-20","0","false","all","2")
end
if t==590 then
R.stage_CopyEnemy(state,"308","-20","0","false","all","2")
end
if t==600 then
R.stage_CopyEnemy(state,"348","-20","0","false","all","2")
end
if t==610 then
R.stage_CopyEnemy(state,"308","-20","0","false","all","2")
end
if t==620 then
R.stage_CopyEnemy(state,"348","-20","0","false","all","2")
end
if t==840 then
R.stage_SetEnemy(state,"8","77","173","1.0","270","999","20","92","3")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"61","speedf","90","1","1")
R.stage_AddEvent(state,"61","speed","2","120","1")
end
if t==845 then
R.stage_CopyEnemy(state,"130","193","0+1","false","all","3")
end
if t==850 then
R.stage_CopyEnemy(state,"190","194","0+1","false","all","3")
end
if t==855 then
R.stage_CopyEnemy(state,"243","172","0+1","false","all","3")
end
if t==860 then
R.stage_CopyEnemy(state,"284","131","0+1","false","all","3")
end
if t==865 then
R.stage_CopyEnemy(state,"305","77","0+1","false","all","3")
end
if t==1020 then
R.stage_CopyEnemy(state,"370","173","0+1","false","all","3")
end
if t==1025 then
R.stage_CopyEnemy(state,"318","193","0+1","false","all","3")
end
if t==1030 then
R.stage_CopyEnemy(state,"258","194","0+1","false","all","3")
end
if t==1035 then
R.stage_CopyEnemy(state,"204","172","0+1","false","all","3")
end
if t==1040 then
R.stage_CopyEnemy(state,"162","131","0+1","false","all","3")
end
if t==1045 then
R.stage_CopyEnemy(state,"142","77","0+1","false","all","3")
end
if t==1200 then
R.stage_CopyEnemy(state,"77","173","0+1","false","all","3")
end
if t==1205 then
R.stage_CopyEnemy(state,"130","193","0+1","false","all","3")
end
if t==1210 then
R.stage_CopyEnemy(state,"190","194","0+1","false","all","3")
end
if t==1215 then
R.stage_CopyEnemy(state,"243","172","0+1","false","all","3")
end
if t==1220 then
R.stage_CopyEnemy(state,"284","131","0+1","false","all","3")
end
if t==1225 then
R.stage_CopyEnemy(state,"305","77","0+1","false","all","3")
end
if t==1380 then
R.stage_CopyEnemy(state,"370","173","0+1","false","all","3")
end
if t==1385 then
R.stage_CopyEnemy(state,"318","193","0+1","false","all","3")
end
if t==1390 then
R.stage_CopyEnemy(state,"258","194","0+1","false","all","3")
end
if t==1395 then
R.stage_CopyEnemy(state,"204","172","0+1","false","all","3")
end
if t==1400 then
R.stage_CopyEnemy(state,"162","131","0+1","false","all","3")
end
if t==1405 then
R.stage_CopyEnemy(state,"142","77","0+1","false","all","3")
end
if t==1710 then
R.stage_SetEnemy(state,"10","139","139","1.0","270","999","1200","94","4")
R.stage_SetEnemyItems(state,"0","0","0","3","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"61","speedf","90","1","1")
R.stage_AddEvent(state,"61","speed","2","120","1")
end
if t==1740 then
R.stage_CopyEnemy(state,"252","162","0+1","false","all","3")
end
if t==1750 then
R.stage_CopyEnemy(state,"308","140","0+1","false","all","3")
end
if t==1760 then
R.stage_CopyEnemy(state,"346","96","0+1","false","all","3")
end
if t==1930 then
R.stage_CopyEnemy(state,"308","140","0+1","false","all","4")
end
if t==1960 then
R.stage_CopyEnemy(state,"195","163","0+1","false","all","3")
end
if t==1970 then
R.stage_CopyEnemy(state,"139","139","0+1","false","all","3")
end
if t==1980 then
R.stage_CopyEnemy(state,"97","97","0+1","false","all","3")
end
if t==2150 then
R.stage_CopyEnemy(state,"139","139","0+1","false","all","4")
end
if t==2180 then
R.stage_CopyEnemy(state,"252","162","0+1","false","all","3")
end
if t==2190 then
R.stage_CopyEnemy(state,"308","140","0+1","false","all","3")
end
if t==2200 then
R.stage_CopyEnemy(state,"346","96","0+1","false","all","3")
end
if t==2290 then
R.stage_CopyEnemy(state,"308","140","0+1","false","all","4")
end
if t==2330 then
R.stage_CopyEnemy(state,"195","163","0+1","false","all","3")
end
if t==2340 then
R.stage_CopyEnemy(state,"139","139","0+1","false","all","3")
R.stage_CopyEnemy(state,"97","97","0+1","false","all","3")
end
if t==2580 then
R.stage_SetEnemy(state,"7","-10","80","2.2","15","999","180","95","5")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_AddEvent(state,"60","speed","1","60","1")
end
if t==2700 then
R.stage_SetEnemy(state,"7","460","80","2.2","165","999","180","95","6")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_AddEvent(state,"60","speed","1","60","1")
end
if t==2760 then
R.stage_CopyEnemy(state,"-10","80","0+2","false","all","5")
end
if t==2820 then
R.stage_CopyEnemy(state,"460","80","0+2","false","all","6")
end
if t==2880 then
R.stage_CopyEnemy(state,"-10","80","0+2","false","all","5")
end
if t==2940 then
R.stage_CopyEnemy(state,"460","80","0+2","false","all","6")
end
if t==3000 then
R.stage_CopyEnemy(state,"-10","80","0+2","false","all","5")
end
if t==3060 then
R.stage_CopyEnemy(state,"460","80","0+2","false","all","6")
end
if t==3420 then
R.stage_SetEnemy(state,"7","83","71","1.0","270","999","120","93","7")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"61","speedf","90","1","1")
R.stage_AddEvent(state,"61","speed","2","120","1")
end
if t==3425 then
R.stage_CopyEnemy(state,"116","118","0+1","false","all","7")
end
if t==3430 then
R.stage_CopyEnemy(state,"166","152","0+1","false","all","7")
end
if t==3435 then
R.stage_CopyEnemy(state,"224","170","0+1","false","all","4")
end
if t==3440 then
R.stage_CopyEnemy(state,"282","152","0+1","false","all","7")
end
if t==3445 then
R.stage_CopyEnemy(state,"330","121","0+1","false","all","7")
end
if t==3450 then
R.stage_CopyEnemy(state,"363","71","0+1","false","all","7")
end
if t==3630 then
R.stage_CopyEnemy(state,"363","71","0+1","false","all","7")
end
if t==3635 then
R.stage_CopyEnemy(state,"330","121","0+1","false","all","7")
end
if t==3640 then
R.stage_CopyEnemy(state,"282","152","0+1","false","all","7")
end
if t==3645 then
R.stage_CopyEnemy(state,"224","170","0+1","false","all","4")
end
if t==3650 then
R.stage_CopyEnemy(state,"166","152","0+1","false","all","7")
end
if t==3655 then
R.stage_CopyEnemy(state,"116","118","0+1","false","all","7")
end
if t==3660 then
R.stage_CopyEnemy(state,"83","71","0+1","false","all","7")
end
if t==3840 then
R.stage_CopyEnemy(state,"83","71","0+1","false","all","7")
end
if t==3845 then
R.stage_CopyEnemy(state,"116","118","0+1","false","all","7")
end
if t==3850 then
R.stage_CopyEnemy(state,"166","152","0+1","false","all","7")
end
if t==3855 then
R.stage_CopyEnemy(state,"224","170","0+1","false","all","4")
end
if t==3860 then
R.stage_CopyEnemy(state,"282","152","0+1","false","all","7")
end
if t==3865 then
R.stage_CopyEnemy(state,"330","121","0+1","false","all","7")
end
if t==3870 then
R.stage_CopyEnemy(state,"363","71","0+1","false","all","7")
end
if t==4050 then
R.stage_SetEnemy(state,"10","224","169","1.0","270","999","1900","910","8")
R.stage_SetEnemyItems(state,"0","0","100","0","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"181","speedf","90","1","1")
R.stage_AddEvent(state,"181","speed","1","120","1")
end
if t==4380 then
R.stage_SetEnemy(state,"7","-40","120","3.0","20","259","9990","98","11")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"280")
R.stage_AddEvent(state,"1","speedf","-90","360","1")
end
if t==4600 then
R.stage_SetEnemy(state,"8","65","155","2.0","270","999","180","96","14")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"61","speedf","90","1","1")
R.stage_AddEvent(state,"61","speed","1","120","1")
end
if t==4620 then
R.stage_CopyEnemy(state,"110","150","0+2","false","all","14")
end
if t==4640 then
R.stage_CopyEnemy(state,"155","147","0+2","false","all","14")
end
if t==4660 then
R.stage_CopyEnemy(state,"200","145","0+2","false","all","14")
end
if t==4680 then
R.stage_CopyEnemy(state,"245","140","0+2","false","all","14")
end
if t==4700 then
R.stage_CopyEnemy(state,"290","135","0+2","false","all","14")
end
if t==4720 then
R.stage_CopyEnemy(state,"335","130","0+2","false","all","14")
end
if t==4740 then
R.stage_CopyEnemy(state,"380","125","0+2","false","all","14")
end
if t==4800 then
R.stage_SetEnemy(state,"1","480","120","3.0","160","259","9990","99","12")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"280")
R.stage_AddEvent(state,"1","speedf","270","360","1")
end
if t==5020 then
R.stage_SetEnemy(state,"8","385","155","2.0","270","999","180","96","14")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"61","speedf","90","1","1")
R.stage_AddEvent(state,"61","speed","1","120","1")
end
if t==5040 then
R.stage_CopyEnemy(state,"340","150","0+2","false","all","14")
end
if t==5060 then
R.stage_CopyEnemy(state,"295","147","0+2","false","all","14")
end
if t==5080 then
R.stage_CopyEnemy(state,"250","145","0+2","false","all","14")
end
if t==5100 then
R.stage_CopyEnemy(state,"205","140","0+2","false","all","14")
end
if t==5120 then
R.stage_CopyEnemy(state,"160","135","0+2","false","all","14")
end
if t==5140 then
R.stage_CopyEnemy(state,"115","130","0+2","false","all","14")
end
if t==5160 then
R.stage_CopyEnemy(state,"70","125","0+2","false","all","14")
end
if t==5190 then
R.stage_CopyEnemy(state,"-10","120","0+1","false","0","11")
R.stage_AddEvent(state,"1","speedf","-90","360","1")
R.stage_SetNoHarmTime(state,"280")
end
if t==5410 then
R.stage_SetEnemy(state,"8","65","155","2.0","270","999","180","96","14")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"61","speedf","90","1","1")
R.stage_AddEvent(state,"61","speed","1","120","1")
end
if t==5430 then
R.stage_CopyEnemy(state,"110","150","0+2","false","all","14")
end
if t==5450 then
R.stage_CopyEnemy(state,"155","147","0+2","false","all","14")
end
if t==5470 then
R.stage_CopyEnemy(state,"200","145","0+2","false","all","14")
end
if t==5490 then
R.stage_CopyEnemy(state,"245","140","0+2","false","all","14")
end
if t==5510 then
R.stage_CopyEnemy(state,"290","135","0+2","false","all","14")
end
if t==5530 then
R.stage_CopyEnemy(state,"335","130","0+2","false","all","14")
end
if t==5550 then
R.stage_CopyEnemy(state,"380","125","0+2","false","all","14")
end
if t==5630 then
R.stage_CopyEnemy(state,"460","120","0+1","false","0","12")
R.stage_AddEvent(state,"1","speedf","270","360","1")
R.stage_SetNoHarmTime(state,"280")
end
if t==5860 then
R.stage_SetEnemy(state,"8","385","155","2.0","270","999","180","96","14")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"61","speedf","90","1","1")
R.stage_AddEvent(state,"61","speed","1","120","1")
end
if t==5880 then
R.stage_CopyEnemy(state,"340","150","0+2","false","all","14")
end
if t==5900 then
R.stage_SetBossItems(state,"0","12","0","12","0","0","1","100","0")
end
if t==5940 then
R.stage_SetBossItems(state,"0","12","0","12","0","0","1","0","0")
end
end
