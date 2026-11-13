-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。
return function(R,state,t)
if t==0 then
R.stage_LoadBackGround(state)
R.stage_PlayMusic(state,"road")
end
if t==181 then
R.stage_ShowTitle(state)
end
if t==420 then
R.stage_SetEnemy(state,"19","74+200","40+150","0","0","900","180","1","1")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==480 then
R.stage_SetEnemy(state,"19","174+200","40+150","0","180","900","180","2","2")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==540 then
R.stage_SetEnemy(state,"19","74+200","40+150","0","0","900","180","3","3")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==600 then
R.stage_SetEnemy(state,"19","174+200","40+150","0","180","900","180","4","4")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==625 then
R.stage_SetEnemy(state,"19","74+200","40+150","0","0","900","180","5","5")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==650 then
R.stage_SetEnemy(state,"19","174+200","40+150","0","180","900","180","6","6")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==665 then
R.stage_SetEnemy(state,"19","124","160","0","0","900","240","7","7")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==695 then
R.stage_SetEnemy(state,"19","324","160","0","180","900","240","8","8")
R.stage_AddEvent(state,"125","speed","0.2","30","1")
R.stage_AddEvent(state,"380","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==840 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==860 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==880 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==900 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==910 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==920 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==930 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==940 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==960 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==980 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==990 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==1000 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==1010 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==1020 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==1040 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==1060 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==1070 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==1080 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==1090 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==1100 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==1120 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==1140 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==1150 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==1160 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==1170 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==1180 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==1200 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==1220 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==1230 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==1240 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==1250 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==1260 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==1280 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==1300 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==1310 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==1320 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==1330 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==1570 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==1620 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==1630 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==1650 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==1680 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==1690 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==1710 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==1740 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==1750 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==1770 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==1800 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==1830 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==1860 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==1890 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==1920 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==1950 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==1970 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==1980 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==2000 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==2010 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==2040 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==2050 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==2070 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==2080 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==2100 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==2130 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==2160 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==2190 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","2")
end
if t==2210 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==2220 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","3")
end
if t==2240 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==2250 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","4")
end
if t==2280 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","5")
end
if t==2290 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==2310 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","6")
end
if t==2320 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","7")
end
if t==2340 then
R.stage_CopyEnemy(state,"74+200","50+140","0","false","all","1")
end
if t==2370 then
R.stage_CopyEnemy(state,"174+200","50+140","0","false","all","8")
end
if t==2640 then
R.stage_SetBossItems(state,"100","24","100","24","0","0","0","0","0")
R.stage_SetBossItems(state,"100","48","100","48","0","100","0","0","0")
end
if t==2760 then
R.stage_SetEnemy(state,"32","-40","200","1.6","30","600","240","991","9")
R.stage_AddEvent(state,"1","speedf","-60","300","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"620")
R.stage_SetEnemy(state,"32","-40","200","1.6","30","600","300","996","15")
R.stage_AddEvent(state,"1","speedf","-60","300","1")
R.stage_SetEnemyItems(state,"0","5","0","5","0","0")
R.stage_SetNoHarmTime(state,"50")
end
if t==2790 then
R.stage_SetEnemy(state,"30","-40","200","1.6","30","600","240","993","11")
R.stage_AddEvent(state,"1","speedf","-60","300","1")
R.stage_SetEnemyItems(state,"0","5","0","5","0","0")
R.stage_SetNoHarmTime(state,"40")
R.stage_SetEnemy(state,"30","-40","200","1.6","30","600","240","996","17")
R.stage_AddEvent(state,"1","speedf","-60","300","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"960")
end
if t==2820 then
R.stage_CopyEnemy(state,"-40","200","0","false","all","11")
R.stage_CopyEnemy(state,"-40","200","0","false","all","17")
end
if t==2850 then
R.stage_CopyEnemy(state,"-40","200","0","false","all","11")
R.stage_CopyEnemy(state,"-40","200","0","false","all","17")
end
if t==2880 then
R.stage_SetEnemy(state,"32","460","180","1.6","150","600","240","992","10")
R.stage_AddEvent(state,"1","speedf","240","300","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"620")
R.stage_CopyEnemy(state,"-40","200","0","false","all","11")
R.stage_SetEnemy(state,"32","460","180","1.6","150","600","300","996","16")
R.stage_AddEvent(state,"1","speedf","240","300","1")
R.stage_SetEnemyItems(state,"0","5","0","5","0","0")
R.stage_SetNoHarmTime(state,"50")
R.stage_CopyEnemy(state,"-40","200","0","false","all","17")
end
if t==2910 then
R.stage_SetEnemy(state,"30","490","180","1.6","150","600","240","993","12")
R.stage_AddEvent(state,"1","speedf","240","300","1")
R.stage_SetEnemyItems(state,"0","5","0","5","0","0")
R.stage_SetNoHarmTime(state,"40")
R.stage_CopyEnemy(state,"-40","200","0","false","all","11")
R.stage_SetEnemy(state,"30","490","180","1.6","150","600","240","996","18")
R.stage_AddEvent(state,"1","speedf","240","300","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"960")
R.stage_CopyEnemy(state,"-40","200","0","false","all","17")
end
if t==2940 then
R.stage_CopyEnemy(state,"490","180","0","false","all","12")
R.stage_CopyEnemy(state,"490","180","0","false","all","18")
end
if t==2970 then
R.stage_CopyEnemy(state,"490","180","0","false","all","12")
R.stage_CopyEnemy(state,"490","180","0","false","all","18")
end
if t==3000 then
R.stage_CopyEnemy(state,"490","180","0","false","all","12")
R.stage_CopyEnemy(state,"-40","160","0+1","false","all","9")
R.stage_CopyEnemy(state,"490","180","0","false","all","18")
R.stage_CopyEnemy(state,"-40","160","0+1","false","all","15")
end
if t==3030 then
R.stage_CopyEnemy(state,"490","180","0","false","all","12")
R.stage_CopyEnemy(state,"-40","160","0","false","all","11")
R.stage_CopyEnemy(state,"490","180","0","false","all","18")
R.stage_CopyEnemy(state,"-40","160","0","false","all","17")
end
if t==3060 then
R.stage_CopyEnemy(state,"-40","160","0","false","all","11")
R.stage_CopyEnemy(state,"-40","160","0","false","all","17")
end
if t==3090 then
R.stage_CopyEnemy(state,"-40","160","0","false","all","11")
R.stage_CopyEnemy(state,"-40","160","0","false","all","17")
end
if t==3120 then
R.stage_CopyEnemy(state,"460","140","0+1","false","all","10")
R.stage_CopyEnemy(state,"-40","160","0","false","all","11")
R.stage_CopyEnemy(state,"460","140","0+1","false","all","16")
R.stage_CopyEnemy(state,"-40","160","0","false","all","17")
end
if t==3150 then
R.stage_CopyEnemy(state,"-40","160","0","false","all","11")
R.stage_CopyEnemy(state,"490","140","0","false","all","12")
R.stage_CopyEnemy(state,"-40","160","0","false","all","17")
R.stage_CopyEnemy(state,"490","140","0","false","all","18")
end
if t==3180 then
R.stage_CopyEnemy(state,"490","140","0","false","all","12")
R.stage_CopyEnemy(state,"490","140","0","false","all","18")
end
if t==3210 then
R.stage_CopyEnemy(state,"490","140","0","false","all","12")
R.stage_CopyEnemy(state,"490","140","0","false","all","18")
end
if t==3240 then
R.stage_CopyEnemy(state,"490","140","0","false","all","12")
R.stage_CopyEnemy(state,"-40","120","0+1","false","all","9")
R.stage_CopyEnemy(state,"490","140","0","false","all","18")
R.stage_CopyEnemy(state,"-40","120","0+1","false","all","15")
end
if t==3270 then
R.stage_CopyEnemy(state,"490","140","0","false","all","12")
R.stage_CopyEnemy(state,"-40","120","0","false","all","11")
R.stage_CopyEnemy(state,"490","140","0","false","all","18")
R.stage_CopyEnemy(state,"-40","120","0","false","all","17")
end
if t==3300 then
R.stage_CopyEnemy(state,"-40","120","0","false","all","11")
R.stage_CopyEnemy(state,"-40","120","0","false","all","17")
end
if t==3330 then
R.stage_CopyEnemy(state,"-40","120","0","false","all","11")
R.stage_CopyEnemy(state,"-40","120","0","false","all","17")
end
if t==3360 then
R.stage_CopyEnemy(state,"460","100","0+1","false","all","10")
R.stage_CopyEnemy(state,"-40","120","0","false","all","11")
R.stage_CopyEnemy(state,"460","100","0+1","false","all","16")
R.stage_CopyEnemy(state,"-40","120","0","false","all","17")
end
if t==3390 then
R.stage_CopyEnemy(state,"-40","120","0","false","all","11")
R.stage_CopyEnemy(state,"490","100","0","false","all","12")
R.stage_CopyEnemy(state,"-40","120","0","false","all","17")
R.stage_CopyEnemy(state,"490","100","0","false","all","18")
end
if t==3420 then
R.stage_CopyEnemy(state,"490","100","0","false","all","12")
R.stage_CopyEnemy(state,"490","100","0","false","all","18")
end
if t==3450 then
R.stage_CopyEnemy(state,"490","100","0","false","all","12")
R.stage_CopyEnemy(state,"490","100","0","false","all","18")
end
if t==3480 then
R.stage_CopyEnemy(state,"490","100","0","false","all","12")
R.stage_CopyEnemy(state,"490","100","0","false","all","18")
end
if t==3510 then
R.stage_CopyEnemy(state,"490","100","0","false","all","12")
R.stage_CopyEnemy(state,"490","100","0","false","all","18")
end
if t==3600 then
R.stage_CopyEnemy(state,"-80","120","0","false","all","9")
R.stage_CopyEnemy(state,"500","120","0","false","all","10")
R.stage_SetEnemy(state,"31","224","-30","2.2","90","900","240","994","13")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"120","speed","2.2","1","1")
R.stage_AddEvent(state,"121","speed","0","60","1")
R.stage_AddEvent(state,"240","speed","2.2","1","1")
R.stage_AddEvent(state,"241","speed","0","60","1")
R.stage_AddEvent(state,"360","speed","2.2","1","1")
R.stage_AddEvent(state,"361","speed","0","60","1")
R.stage_AddEvent(state,"480","speed","2.2","1","1")
R.stage_AddEvent(state,"481","speed","0","60","1")
R.stage_AddEvent(state,"600","speed","2.2","1","1")
R.stage_AddEvent(state,"601","speed","0","60","1")
R.stage_AddEvent(state,"720","speed","2.2","1","1")
R.stage_AddEvent(state,"721","speed","0","60","1")
R.stage_AddEvent(state,"840","speed","2.2","1","1")
R.stage_AddEvent(state,"841","speed","0","60","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"920")
R.stage_CopyEnemy(state,"-80","120","0","false","all","15")
R.stage_CopyEnemy(state,"500","120","0","false","all","16")
R.stage_SetEnemy(state,"31","224","-30","2.2","90","900","300","996","19")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"120","speed","2.2","1","1")
R.stage_AddEvent(state,"121","speed","0","60","1")
R.stage_AddEvent(state,"240","speed","2.2","1","1")
R.stage_AddEvent(state,"241","speed","0","60","1")
R.stage_AddEvent(state,"360","speed","2.2","1","1")
R.stage_AddEvent(state,"361","speed","0","60","1")
R.stage_AddEvent(state,"480","speed","2.2","1","1")
R.stage_AddEvent(state,"481","speed","0","60","1")
R.stage_AddEvent(state,"600","speed","2.2","1","1")
R.stage_AddEvent(state,"601","speed","0","60","1")
R.stage_AddEvent(state,"720","speed","2.2","1","1")
R.stage_AddEvent(state,"721","speed","0","60","1")
R.stage_AddEvent(state,"840","speed","2.2","1","1")
R.stage_AddEvent(state,"841","speed","0","60","1")
R.stage_SetEnemyItems(state,"0","5","0","5","0","0")
R.stage_SetNoHarmTime(state,"60")
end
if t==3720 then
R.stage_CopyEnemy(state,"224","-30","0","false","all","13")
R.stage_CopyEnemy(state,"224","-30","0","false","all","19")
end
if t==3840 then
R.stage_CopyEnemy(state,"224","-30","0","false","all","13")
R.stage_CopyEnemy(state,"224","-30","0","false","all","19")
end
if t==3960 then
R.stage_CopyEnemy(state,"224","-30","0","false","all","13")
R.stage_CopyEnemy(state,"224","-30","0","false","all","19")
end
if t==4080 then
R.stage_CopyEnemy(state,"224","-30","0","false","all","13")
R.stage_SetEnemy(state,"30","194","-100","2.2","90","900","240","996","14")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"120","speed","2.2","1","1")
R.stage_AddEvent(state,"121","speed","0","60","1")
R.stage_AddEvent(state,"240","speed","2.2","1","1")
R.stage_AddEvent(state,"241","speed","0","60","1")
R.stage_AddEvent(state,"360","speed","2.2","1","1")
R.stage_AddEvent(state,"361","speed","0","60","1")
R.stage_AddEvent(state,"480","speed","2.2","1","1")
R.stage_AddEvent(state,"481","speed","0","60","1")
R.stage_AddEvent(state,"600","speed","2.2","1","1")
R.stage_AddEvent(state,"601","speed","0","60","1")
R.stage_AddEvent(state,"720","speed","2.2","1","1")
R.stage_AddEvent(state,"721","speed","0","60","1")
R.stage_AddEvent(state,"840","speed","2.2","1","1")
R.stage_AddEvent(state,"841","speed","0","60","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"920")
R.stage_CopyEnemy(state,"254","-100","0+1","false","all","14")
R.stage_CopyEnemy(state,"224","-30","0","false","all","19")
R.stage_SetEnemy(state,"30","194","-100","2.2","90","900","300","996","20")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_AddEvent(state,"120","speed","2.2","1","1")
R.stage_AddEvent(state,"121","speed","0","60","1")
R.stage_AddEvent(state,"240","speed","2.2","1","1")
R.stage_AddEvent(state,"241","speed","0","60","1")
R.stage_AddEvent(state,"360","speed","2.2","1","1")
R.stage_AddEvent(state,"361","speed","0","60","1")
R.stage_AddEvent(state,"480","speed","2.2","1","1")
R.stage_AddEvent(state,"481","speed","0","60","1")
R.stage_AddEvent(state,"600","speed","2.2","1","1")
R.stage_AddEvent(state,"601","speed","0","60","1")
R.stage_AddEvent(state,"720","speed","2.2","1","1")
R.stage_AddEvent(state,"721","speed","0","60","1")
R.stage_AddEvent(state,"840","speed","2.2","1","1")
R.stage_AddEvent(state,"841","speed","0","60","1")
R.stage_SetEnemyItems(state,"0","5","0","5","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_CopyEnemy(state,"254","-100","0+1","false","all","20")
end
if t==4200 then
R.stage_SetEnemy(state,"32","204","-45","0","90","900","240","995")
R.stage_AddEvent(state,"120","speed","2.2","1","1")
R.stage_AddEvent(state,"121","speed","0","60","1")
R.stage_AddEvent(state,"240","speed","2.2","1","1")
R.stage_AddEvent(state,"241","speed","0","60","1")
R.stage_AddEvent(state,"360","speed","2.2","1","1")
R.stage_AddEvent(state,"361","speed","0","60","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"920")
R.stage_SetEnemy(state,"32","204","-45","0","90","900","300","996")
R.stage_AddEvent(state,"120","speed","2.2","1","1")
R.stage_AddEvent(state,"121","speed","0","60","1")
R.stage_AddEvent(state,"240","speed","2.2","1","1")
R.stage_AddEvent(state,"241","speed","0","60","1")
R.stage_AddEvent(state,"360","speed","2.2","1","1")
R.stage_AddEvent(state,"361","speed","0","60","1")
R.stage_SetEnemyItems(state,"0","5","0","5","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==4560 then
R.stage_CopyEnemy(state,"224","-20","0+1","false","all","14")
R.stage_CopyEnemy(state,"224","-20","0+1","false","all","19")
end
if t==4680 then
R.stage_LastBoss(state)
R.stage_SetBossItems(state,"100","48","100","48","0","0","1","0","0")
end
if t==4710 then
R.stage_FadeoutMusic(state,"5")
end
if t==5100 then
R.stage_SetEnemy(state,"19","224","-50","0.0","20","1180","9990","9910")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"6480")
end
if t==5640 then
R.stage_PlayMusic(state,"last")
end
if t==5880 then
R.stage_RaiseEffect(state,"36"," 224"," 170"," 3")
end
if t==6000 then
R.stage_LastBoss(state)
R.stage_SetBossItems(state,"100","66","100","66","0","0","1","0","0")
end
end
