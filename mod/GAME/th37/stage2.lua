-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。
return function(R,state,t)
if t==0 then
R.stage_LoadBackGround(state)
end
if t==1 then
R.stage_SetEnemy(state,"19","224","140","0","270","525","180","221","11")
R.stage_AddEvent(state,"245","speed","0.2","30","1")
R.stage_AddEvent(state,"480","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==2 then
R.stage_CopyEnemy(state,"164+120","80+120","0","false","all","11")
end
if t==3 then
R.stage_CopyEnemy(state,"164+120","80+120","0","false","all","11")
end
if t==4 then
R.stage_CopyEnemy(state,"164+120","80+120","0","false","all","11")
end
if t==5 then
R.stage_CopyEnemy(state,"164+120","80+120","0","false","all","11")
end
if t==10 then
R.stage_PlayMusic(state,"road")
end
if t==40 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","3480","9990","91")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"3480")
end
if t==130 then
R.stage_CopyEnemy(state,"68+120","80+120","0","false","all","11")
R.stage_SetEnemy(state,"22","224","167","0.5","270","999","600","96","2")
R.stage_SetEnemyItems(state,"100","0","100","0","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","270","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
end
if t==131 then
R.stage_CopyEnemy(state,"68+120","80+120","0","false","all","11")
end
if t==132 then
R.stage_CopyEnemy(state,"68+120","80+120","0","false","all","11")
end
if t==133 then
R.stage_CopyEnemy(state,"68+120","80+120","0","false","all","11")
end
if t==134 then
R.stage_CopyEnemy(state,"68+120","80+120","0","false","all","11")
end
if t==135 then
R.stage_CopyEnemy(state,"68+120","80+120","0","false","all","11")
end
if t==230 then
R.stage_CopyEnemy(state,"259+120","80+120","0","false","all","11")
end
if t==231 then
R.stage_CopyEnemy(state,"259+120","80+120","0","false","all","11")
end
if t==232 then
R.stage_CopyEnemy(state,"259+120","80+120","0","false","all","11")
end
if t==233 then
R.stage_CopyEnemy(state,"259+120","80+120","0","false","all","11")
end
if t==234 then
R.stage_CopyEnemy(state,"259+120","80+120","0","false","all","11")
end
if t==235 then
R.stage_CopyEnemy(state,"259+120","80+120","0","false","all","11")
end
if t==250 then
R.stage_CopyEnemy(state,"128","167","0+1","false","all","2")
end
if t==350 then
R.stage_CopyEnemy(state,"319","167","0+1","false","all","2")
end
if t==580 then
R.stage_SetEnemy(state,"22","224","147","0.5","270","999","180","93","3")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","270","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
end
if t==593 then
R.stage_CopyEnemy(state,"158","147","0+1","false","all","3")
end
if t==605 then
R.stage_CopyEnemy(state,"287","147","0+1","false","all","3")
end
if t==618 then
R.stage_CopyEnemy(state,"95","147","0+1","false","all","3")
end
if t==631 then
R.stage_CopyEnemy(state,"351","147","0+1","false","all","3")
end
if t==654 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==655 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==656 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==657 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==658 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==659 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==660 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==661 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==662 then
R.stage_CopyEnemy(state,"64+320","60+80","0","false","all","11")
end
if t==900 then
R.stage_ShowTitle(state)
end
if t==988 then
R.stage_SetEnemy(state,"19","224","140","0","90","525","180","222","12")
R.stage_AddEvent(state,"245","speed","0.2","30","1")
R.stage_AddEvent(state,"480","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"120")
end
if t==1016 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1034 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1052 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1070 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1088 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1106 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1124 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1142 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1160 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1178 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1196 then
R.stage_CopyEnemy(state,"64+320","60+180","0","false","all","12")
end
if t==1330 then
R.stage_SetEnemy(state,"22","96","114","0.5","270","999","190","97","4")
R.stage_SetEnemyItems(state,"0","0","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","90","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
end
if t==1358 then
R.stage_CopyEnemy(state,"352","241","0+1","false","all","4")
end
if t==1386 then
R.stage_CopyEnemy(state,"128","177","0+1","false","all","4")
end
if t==1414 then
R.stage_CopyEnemy(state,"320","177","0+1","false","all","4")
end
if t==1442 then
R.stage_CopyEnemy(state,"352","114","0+1","false","all","4")
end
if t==1470 then
R.stage_CopyEnemy(state,"64","177","0+1","false","all","4")
end
if t==1498 then
R.stage_CopyEnemy(state,"96","241","0+1","false","all","4")
end
if t==1526 then
R.stage_CopyEnemy(state,"288","114","0+1","false","all","4")
end
if t==1554 then
R.stage_CopyEnemy(state,"158","241","0+1","false","all","4")
end
if t==1582 then
R.stage_CopyEnemy(state,"384","177","0+1","false","all","4")
end
if t==1610 then
R.stage_CopyEnemy(state,"224","241","0+1","false","all","4")
end
if t==1638 then
R.stage_CopyEnemy(state,"224","114","0+1","false","all","4")
end
if t==1666 then
R.stage_CopyEnemy(state,"288","241","0+1","false","all","4")
end
if t==1694 then
R.stage_CopyEnemy(state,"158","114","0+1","false","all","4")
end
if t==1722 then
R.stage_CopyEnemy(state,"257","177","0+1","false","all","4")
end
if t==1750 then
R.stage_CopyEnemy(state,"192","177","0+1","false","all","4")
end
if t==1860 then
R.stage_SetEnemy(state,"22","64","142","0.5","270","999","180","92","5")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","270","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
end
if t==1873 then
R.stage_CopyEnemy(state,"128","142","0+1","false","all","5")
end
if t==1886 then
R.stage_CopyEnemy(state,"192","142","0+1","false","all","5")
end
if t==1922 then
R.stage_CopyEnemy(state,"257","142","0+1","false","all","5")
end
if t==1935 then
R.stage_CopyEnemy(state,"320","142","0+1","false","all","5")
end
if t==1948 then
R.stage_CopyEnemy(state,"384","142","0+1","false","all","5")
end
if t==2080 then
R.stage_CopyEnemy(state,"64","142","0+1","false","all","5")
end
if t==2093 then
R.stage_CopyEnemy(state,"128","142","0+1","false","all","5")
end
if t==2106 then
R.stage_CopyEnemy(state,"192","142","0+1","false","all","5")
end
if t==2144 then
R.stage_CopyEnemy(state,"257","142","0+1","false","all","5")
end
if t==2157 then
R.stage_CopyEnemy(state,"320","142","0+1","false","all","5")
end
if t==2170 then
R.stage_CopyEnemy(state,"384","142","0+1","false","all","5")
end
if t==2305 then
R.stage_CopyEnemy(state,"64","142","0+1","false","all","5")
end
if t==2318 then
R.stage_CopyEnemy(state,"128","142","0+1","false","all","5")
end
if t==2331 then
R.stage_CopyEnemy(state,"192","142","0+1","false","all","5")
end
if t==2369 then
R.stage_CopyEnemy(state,"257","142","0+1","false","all","5")
end
if t==2382 then
R.stage_CopyEnemy(state,"320","142","0+1","false","all","5")
end
if t==2395 then
R.stage_CopyEnemy(state,"384","142","0+1","false","all","5")
end
if t==2550 then
R.stage_CopyEnemy(state,"64","150","0+1","false","all","3")
R.stage_CopyEnemy(state,"128","150","0+1","false","all","3")
R.stage_CopyEnemy(state,"192","150","0+1","false","all","3")
R.stage_CopyEnemy(state,"257","150","0+1","false","all","3")
R.stage_CopyEnemy(state,"320","150","0+1","false","all","3")
R.stage_CopyEnemy(state,"384","150","0+1","false","all","3")
end
if t==2650 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2651 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2652 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2653 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2654 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2655 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2656 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2657 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==2810 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==2811 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==2812 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==2813 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==2814 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==2815 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==2816 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==2817 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3041 then
R.stage_SetEnemy(state,"22","224","81","0.5","270","999","180","94","6")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","90","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
R.stage_CopyEnemy(state,"224","282","0+1","false","all","6")
R.stage_CopyEnemy(state,"135","135","0+1","false","all","6")
R.stage_CopyEnemy(state,"135","234","0+1","false","all","6")
R.stage_CopyEnemy(state,"305","135","0+1","false","all","6")
R.stage_CopyEnemy(state,"305","234","0+1","false","all","6")
end
if t==3070 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3071 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3072 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3073 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3074 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3075 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3076 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3077 then
R.stage_CopyEnemy(state,"68+120","60+130","0","false","all","11")
end
if t==3190 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3191 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3192 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3193 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3194 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3195 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3196 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3197 then
R.stage_CopyEnemy(state,"259+120","60+130","0","false","all","11")
end
if t==3450 then
R.stage_SetEnemy(state,"22","179","95","0.5","270","999","180","95","7")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","90","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
R.stage_CopyEnemy(state,"255","85","0+1","false","all","7")
R.stage_CopyEnemy(state,"305","126","0+1","false","all","7")
R.stage_CopyEnemy(state,"323","198","0+1","false","all","7")
R.stage_CopyEnemy(state,"281","266","0+1","false","all","7")
R.stage_CopyEnemy(state,"208","281","0+1","false","all","7")
R.stage_CopyEnemy(state,"141","234","0+1","false","all","7")
R.stage_CopyEnemy(state,"129","149","0+1","false","all","7")
end
if t==3570 then
R.stage_SetBossItems(state,"0","12","0","12","0","0","1","0","0")
R.stage_SetBossItems(state,"0","12","0","12","0","100","1","0","0")
end
if t==3600 then
R.stage_SetEnemy(state,"2","224","-50","0.0","20","3480","9990","98")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"3480")
end
if t==4020 then
R.stage_SetEnemy(state,"22","159","81","0.5","270","999","240","99","8")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","90","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
R.stage_CopyEnemy(state,"159","282","0+1","false","all","8")
R.stage_CopyEnemy(state,"70","135","0+1","false","all","8")
R.stage_CopyEnemy(state,"70","234","0+1","false","all","8")
R.stage_CopyEnemy(state,"241","135","0+1","false","all","8")
R.stage_CopyEnemy(state,"241","234","0+1","false","all","8")
end
if t==4410 then
R.stage_SetEnemy(state,"22","288","81","0.5","270","999","240","99","8")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","90","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
R.stage_CopyEnemy(state,"288","282","0+1","false","all","8")
R.stage_CopyEnemy(state,"200","135","0+1","false","all","8")
R.stage_CopyEnemy(state,"200","234","0+1","false","all","8")
R.stage_CopyEnemy(state,"370","135","0+1","false","all","8")
R.stage_CopyEnemy(state,"370","234","0+1","false","all","8")
end
if t==4800 then
R.stage_SetEnemy(state,"22","179","95","0.5","270","999","240","94","9")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","90","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
R.stage_CopyEnemy(state,"255","85","0+1","false","all","9")
R.stage_CopyEnemy(state,"305","126","0+1","false","all","9")
R.stage_CopyEnemy(state,"323","198","0+1","false","all","9")
R.stage_CopyEnemy(state,"281","266","0+1","false","all","9")
R.stage_CopyEnemy(state,"208","281","0+1","false","all","9")
R.stage_CopyEnemy(state,"141","234","0+1","false","all","9")
R.stage_CopyEnemy(state,"129","149","0+1","false","all","9")
R.stage_SetEnemy(state,"22","224","167","0.5","270","999","500","96","10")
R.stage_SetEnemyItems(state,"100","0","100","0","0","0")
R.stage_AddEvent(state,"1","speed","0","60","1")
R.stage_SetNoHarmTime(state,"10")
R.stage_AddEvent(state,"161","speedf","270","1","1")
R.stage_AddEvent(state,"161","speed","1","120","1")
end
if t==5030 then
R.stage_SetBossItems(state,"0","12","0","12","0","0","1","0","0")
end
end
