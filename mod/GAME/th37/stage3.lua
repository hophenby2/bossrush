-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。
return function(R,state,t)
if t==0 then
R.stage_PlayMusic(state,"road")
R.stage_LoadBackGround(state)
end
if t==20 then
R.stage_SetEnemy(state,"2","-90","280","3.5","0","499","240","3","1")
R.stage_SetEnemyItems(state,"0","1","0","2","0","0")
R.stage_SetNoHarmTime(state,"66")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"180","speedf","300","1","1")
R.stage_AddEvent(state,"180","speed","2","90","1")
end
if t==33 then
R.stage_SetEnemy(state,"2","540","280","3.5","180","499","240","3","2")
R.stage_SetEnemyItems(state,"0","1","0","2","0","0")
R.stage_SetNoHarmTime(state,"66")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"180","speedf","240","1","1")
R.stage_AddEvent(state,"180","speed","2","90","1")
end
if t==46 then
R.stage_CopyEnemy(state,"-60","220","0","false","all","1")
end
if t==59 then
R.stage_CopyEnemy(state,"510","220","0","false","all","2")
end
if t==72 then
R.stage_CopyEnemy(state,"-30","160","0","false","all","1")
end
if t==85 then
R.stage_CopyEnemy(state,"480","160","0","false","all","2")
end
if t==98 then
R.stage_CopyEnemy(state,"-10","100","0","false","all","1")
end
if t==111 then
R.stage_CopyEnemy(state,"470","100","0","false","all","2")
end
if t==270 then
R.stage_ShowTitle(state)
end
if t==480 then
R.stage_SetEnemy(state,"6","224","-10","3.0","90","999","2200","4","3")
R.stage_SetEnemyItems(state,"0","2","0","3","0","1")
R.stage_SetNoHarmTime(state,"126")
R.stage_AddEvent(state,"10","speed","0","110","1")
R.stage_AddEvent(state,"460","speedf","270","1","1")
R.stage_AddEvent(state,"460","speed","2","90","1")
end
if t==840 then
R.stage_SetEnemy(state,"2","64","-20","3.5","90","999","240","2","4")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_SetNoHarmTime(state,"126")
R.stage_AddEvent(state,"10","speed","0","110","1")
R.stage_AddEvent(state,"180","speedf","270","1","1")
R.stage_AddEvent(state,"180","speed","3","60","1")
end
if t==866 then
R.stage_CopyEnemy(state,"128","-40","0","false","all","4")
end
if t==892 then
R.stage_CopyEnemy(state,"192","-60","0","false","all","4")
end
if t==918 then
R.stage_CopyEnemy(state,"256","-80","0","false","all","4")
end
if t==934 then
R.stage_CopyEnemy(state,"320","-100","0","false","all","4")
end
if t==960 then
R.stage_CopyEnemy(state,"384","-120","0","false","all","4")
end
if t==1020 then
R.stage_CopyEnemy(state,"384","-20","0","false","all","4")
end
if t==1046 then
R.stage_CopyEnemy(state,"320","-40","0","false","all","4")
end
if t==1072 then
R.stage_CopyEnemy(state,"256","-60","0","false","all","4")
end
if t==1098 then
R.stage_CopyEnemy(state,"192","-80","0","false","all","4")
end
if t==1114 then
R.stage_CopyEnemy(state,"128","-100","0","false","all","4")
end
if t==1140 then
R.stage_CopyEnemy(state,"64","-120","0","false","all","4")
end
if t==1260 then
R.stage_CopyEnemy(state,"64","-20","0","false","all","4")
end
if t==1286 then
R.stage_CopyEnemy(state,"128","-40","0","false","all","4")
end
if t==1312 then
R.stage_CopyEnemy(state,"192","-60","0","false","all","4")
end
if t==1338 then
R.stage_CopyEnemy(state,"256","-80","0","false","all","4")
end
if t==1354 then
R.stage_CopyEnemy(state,"320","-100","0","false","all","4")
end
if t==1380 then
R.stage_CopyEnemy(state,"384","-120","0","false","all","4")
end
if t==1500 then
R.stage_CopyEnemy(state,"384","-20","0","false","all","4")
end
if t==1526 then
R.stage_CopyEnemy(state,"320","-40","0","false","all","4")
end
if t==1552 then
R.stage_CopyEnemy(state,"256","-60","0","false","all","4")
end
if t==1578 then
R.stage_CopyEnemy(state,"192","-80","0","false","all","4")
end
if t==1594 then
R.stage_CopyEnemy(state,"128","-100","0","false","all","4")
end
if t==1620 then
R.stage_CopyEnemy(state,"64","-120","0","false","all","4")
end
if t==1860 then
R.stage_SetEnemy(state,"6","-40","90","3.4","0","999","1800","5")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_AddEvent(state,"30","speedf","90","60","1")
R.stage_AddEvent(state,"30","speed","0","60","1")
R.stage_AddEvent(state,"320","speedf","140","90","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
end
if t==2040 then
R.stage_SetEnemy(state,"6","490","90","3.4","180","999","1800","5")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_AddEvent(state,"30","speedf","90","60","1")
R.stage_AddEvent(state,"30","speed","0","60","1")
R.stage_AddEvent(state,"320","speedf","40","90","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
end
if t==2340 then
R.stage_SetEnemy(state,"12","224","130","1.0","90","999","3000","6")
R.stage_SetEnemyItems(state,"0","5","0","5","0","1")
R.stage_SetNoHarmTime(state,"60")
R.stage_AddEvent(state,"10","speed","0","60","1")
R.stage_AddEvent(state,"460","speedf","270","1","1")
R.stage_AddEvent(state,"460","speed","2","90","1")
end
if t==2760 then
R.stage_SetEnemy(state,"2","344","-20","2.1","90","999","800","9","5")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_AddEvent(state,"1","speed","0.7","120","1")
R.stage_AddEvent(state,"360","speed","1","10","1")
R.stage_AddEvent(state,"12","speedf","135","120","1")
R.stage_SetEnemy(state,"2","104","-20","2.1","90","999","800","9","6")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_AddEvent(state,"1","speed","0.7","120","1")
R.stage_AddEvent(state,"360","speed","1","10","1")
R.stage_AddEvent(state,"12","speedf","45","120","1")
end
if t==2880 then
R.stage_SetEnemy(state,"2","224","-20","3.1","90","999","3600","8")
R.stage_SetEnemyItems(state,"0","2","0","3","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_AddEvent(state,"1","speed","0","90","1")
R.stage_AddEvent(state,"460","speed","2","10","1")
end
if t==2940 then
R.stage_CopyEnemy(state,"84","-20","0","false","all","6")
R.stage_CopyEnemy(state,"364","-20","0","false","all","5")
end
if t==3210 then
R.stage_CopyEnemy(state,"64","-20","0","false","all","6")
R.stage_CopyEnemy(state,"384","-20","0","false","all","5")
end
if t==3480 then
R.stage_SetEnemy(state,"2","224","-10","0.0","20","1090","9990","11")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1090")
end
if t==4140 then
R.stage_SetEnemy(state,"6","224","-20","3.3","90","999","3900","10")
R.stage_SetEnemyItems(state,"0","2","0","3","0","1")
R.stage_SetNoHarmTime(state,"130")
R.stage_AddEvent(state,"12","speed","0","100","1")
R.stage_AddEvent(state,"600","speed","2.5","120","1")
R.stage_AddEvent(state,"600","speedf","90","120","1")
end
if t==4590 then
R.stage_SetEnemy(state,"6","124","-20","2.5","90","999","1500","5")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_AddEvent(state,"30","speed","0","60","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
R.stage_SetEnemy(state,"6","324","-20","2.5","90","999","1500","5")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"120")
R.stage_AddEvent(state,"30","speed","0","60","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
end
if t==5040 then
R.stage_SetEnemy(state,"12","225","-10","5.0","90","999","3000","6")
R.stage_SetEnemyItems(state,"0","5","0","5","0","1")
R.stage_SetNoHarmTime(state,"40")
R.stage_AddEvent(state,"0","speed","0.0","60","1")
R.stage_AddEvent(state,"520","speedf","-90","1","2")
R.stage_AddEvent(state,"520","speed","3.0","90","1")
end
if t==5400 then
R.stage_SetEnemy(state,"2","224","-10","0.0","20","1290","9990","1")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1290")
end
if t==6420 then
R.stage_SetBossItems(state,"0","16","0","16","0","0","1","0","0")
end
end
