-- 原关卡时间轴；For已展开，命令已转换成直接Lua调用。
return function(R,state,t)
if t==0 then
R.stage_PlayMusic(state,"road")
R.stage_LoadBackGround(state)
end
if t==1 then
R.stage_SetEnemy(state,"25","224","-30","4.5","90","900","1200","6","4")
R.stage_AddEvent(state,"8","speed","0.2","50","1")
R.stage_AddEvent(state,"368","speed","3.2","120","1")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_SetNoHarmTime(state,"10")
end
if t==200 then
R.stage_CopyEnemy(state,"124","-30","0","false","all","4")
R.stage_CopyEnemy(state,"324","-30","0","false","all","4")
end
if t==410 then
R.stage_CopyEnemy(state,"224","-20","0","false","all","4")
end
if t==630 then
R.stage_CopyEnemy(state,"124","-20","0","false","all","4")
R.stage_CopyEnemy(state,"324","-20","0","false","all","4")
end
if t==840 then
R.stage_ShowTitle(state)
end
if t==1020 then
R.stage_SetEnemy(state,"24","470","48","1.5","180","800","220","8","5")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_SetEnemy(state,"24","-22","144","1.5","0","800","220","8","12")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_SetEnemy(state,"24","470","240","1.5","180","800","220","8","5")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_SetEnemy(state,"24","-22","336","1.5","0","800","220","8","12")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"20")
end
if t==1080 then
R.stage_SetEnemy(state,"25","470","48","1.5","180","800","150","9","6")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_SetEnemy(state,"25","-22","144","1.5","0","800","150","9","13")
R.stage_SetEnemyItems(state,"0","1","0","2","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_SetEnemy(state,"25","470","240","1.5","180","800","150","9","6")
R.stage_SetEnemyItems(state,"0","1","0","2","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_SetEnemy(state,"25","-22","336","1.5","0","800","150","9","13")
R.stage_SetEnemyItems(state,"0","1","0","2","0","0")
R.stage_SetNoHarmTime(state,"20")
end
if t==1140 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1200 then
R.stage_CopyEnemy(state,"470","48","0","false","all","5")
R.stage_CopyEnemy(state,"-22","144","0","false","all","12")
R.stage_CopyEnemy(state,"470","240","0","false","all","5")
R.stage_CopyEnemy(state,"-22","336","0","false","all","12")
end
if t==1260 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1320 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1380 then
R.stage_CopyEnemy(state,"470","48","0","false","all","5")
R.stage_CopyEnemy(state,"-22","144","0","false","all","12")
R.stage_CopyEnemy(state,"470","240","0","false","all","5")
R.stage_CopyEnemy(state,"-22","336","0","false","all","12")
end
if t==1440 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1500 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1560 then
R.stage_CopyEnemy(state,"470","48","0","false","all","5")
R.stage_CopyEnemy(state,"-22","144","0","false","all","12")
R.stage_CopyEnemy(state,"470","240","0","false","all","5")
R.stage_CopyEnemy(state,"-22","336","0","false","all","12")
end
if t==1620 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1680 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1740 then
R.stage_CopyEnemy(state,"470","48","0","false","all","5")
R.stage_CopyEnemy(state,"-22","144","0","false","all","12")
R.stage_CopyEnemy(state,"470","240","0","false","all","5")
R.stage_CopyEnemy(state,"-22","336","0","false","all","12")
end
if t==1800 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1860 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==1920 then
R.stage_CopyEnemy(state,"470","48","0","false","all","5")
R.stage_CopyEnemy(state,"-22","144","0","false","all","12")
R.stage_CopyEnemy(state,"470","240","0","false","all","5")
R.stage_CopyEnemy(state,"-22","336","0","false","all","12")
end
if t==1980 then
R.stage_CopyEnemy(state,"470","48","0","false","all","6")
R.stage_CopyEnemy(state,"-22","144","0","false","all","13")
R.stage_CopyEnemy(state,"470","240","0","false","all","6")
R.stage_CopyEnemy(state,"-22","336","0","false","all","13")
end
if t==2610 then
R.stage_SetEnemy(state,"24","-20","110","3.0","0","999","2200","5","9")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_AddEvent(state,"30","speedf","90","60","1")
R.stage_AddEvent(state,"30","speed","0","60","1")
R.stage_AddEvent(state,"91","speedf","0","1","1")
R.stage_AddEvent(state,"91","speed","0.5","1","1")
R.stage_AddEvent(state,"320","speedf","40","90","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
end
if t==2790 then
R.stage_SetEnemy(state,"24","470","110","3.0","180","999","2200","5","10")
R.stage_SetEnemyItems(state,"0","3","0","3","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_AddEvent(state,"30","speedf","90","60","1")
R.stage_AddEvent(state,"30","speed","0","60","1")
R.stage_AddEvent(state,"91","speedf","180","1","1")
R.stage_AddEvent(state,"91","speed","0.5","1","1")
R.stage_AddEvent(state,"320","speedf","40","90","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
end
if t==2990 then
R.stage_CopyEnemy(state,"-20","110","0","false","all","9")
end
if t==3180 then
R.stage_CopyEnemy(state,"470","110","0","false","all","10")
end
if t==3390 then
R.stage_CopyEnemy(state,"-20","110","0","false","all","9")
end
if t==3460 then
R.stage_SetEnemy(state,"23","470","90","5.0","180","999","300","7","7")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"320","speedf","40","90","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
end
if t==3490 then
R.stage_CopyEnemy(state,"460+60","60+110","0","false","all","7")
end
if t==3510 then
R.stage_CopyEnemy(state,"460+60","60+110","0","false","all","7")
end
if t==3530 then
R.stage_CopyEnemy(state,"460+60","60+110","0","false","all","7")
end
if t==3550 then
R.stage_CopyEnemy(state,"460+60","60+110","0","false","all","7")
end
if t==3570 then
R.stage_CopyEnemy(state,"460+60","60+110","0","false","all","7")
end
if t==3590 then
R.stage_CopyEnemy(state,"460+60","60+110","0","false","all","7")
end
if t==3660 then
R.stage_CopyEnemy(state,"470","110","0","false","all","10")
end
if t==3720 then
R.stage_SetEnemy(state,"23","-20","90","5.0","0","999","300","7","8")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"20")
R.stage_AddEvent(state,"30","speedf","90","30","1")
R.stage_AddEvent(state,"30","speed","0","30","1")
R.stage_AddEvent(state,"320","speedf","130","90","1")
R.stage_AddEvent(state,"320","speed","2","90","1")
end
if t==3750 then
R.stage_CopyEnemy(state,"-70+60","60+110","0","false","all","8")
end
if t==3770 then
R.stage_CopyEnemy(state,"-70+60","60+110","0","false","all","8")
end
if t==3790 then
R.stage_CopyEnemy(state,"-70+60","60+110","0","false","all","8")
end
if t==3810 then
R.stage_CopyEnemy(state,"-70+60","60+110","0","false","all","8")
end
if t==3830 then
R.stage_CopyEnemy(state,"-70+60","60+110","0","false","all","8")
end
if t==4020 then
R.stage_SetEnemy(state,"28","-10","140","2","0","900","100","4","16")
R.stage_AddEvent(state,"1","speed","3.2","60","1")
R.stage_AddEvent(state,"1","speedf","25","120","3")
R.stage_AddEvent(state,"121","speedf","25","120","3")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==4030 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
end
if t==4040 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
end
if t==4050 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
end
if t==4060 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
end
if t==4070 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
end
if t==4080 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
R.stage_SetEnemy(state,"28","460","140","2","180","900","100","4","17")
R.stage_AddEvent(state,"1","speed","3.2","60","1")
R.stage_AddEvent(state,"1","speedf","155","120","3")
R.stage_AddEvent(state,"121","speedf","155","120","3")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==4090 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4100 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4110 then
R.stage_CopyEnemy(state,"-10","70+170","0","false","all","16")
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4120 then
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4130 then
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4140 then
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4150 then
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4160 then
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4170 then
R.stage_CopyEnemy(state,"460","70+170","0","false","all","17")
end
if t==4240 then
R.stage_SetEnemy(state,"2","224","-60","0.0","20","1480","9990","112")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetNoHarmTime(state,"1480")
end
if t==4260 then
R.stage_SetEnemy(state,"19","224","140","0","0","900","240","1","1")
R.stage_AddEvent(state,"245","speed","0.2","30","1")
R.stage_AddEvent(state,"480","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"240")
end
if t==4280 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4300 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4320 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4340 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4360 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4380 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4400 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4420 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4440 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4460 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4480 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4500 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4520 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4540 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4560 then
R.stage_CopyEnemy(state,"74+200","50+160","0","false","all","1")
end
if t==4600 then
R.stage_SetEnemy(state,"19","224","140","0","180","900","240","2","2")
R.stage_AddEvent(state,"245","speed","0.2","30","1")
R.stage_AddEvent(state,"480","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","2","0","1","0","0")
R.stage_SetNoHarmTime(state,"240")
end
if t==4620 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4640 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4660 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4680 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4700 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4720 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4740 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4760 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4780 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4800 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4820 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4840 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4860 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4880 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4900 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==4920 then
R.stage_CopyEnemy(state,"174+200","50+160","0","false","all","2")
end
if t==5100 then
R.stage_CopyEnemy(state,"74+150","50+200","0","false","all","1")
end
if t==5130 then
R.stage_CopyEnemy(state,"224+150","50+200","0","false","all","2")
end
if t==5160 then
R.stage_CopyEnemy(state,"74+150","50+200","0","false","all","1")
R.stage_SetEnemy(state,"19","124","130","0","0","900","390","10")
R.stage_AddEvent(state,"245","speed","0.2","30","1")
R.stage_AddEvent(state,"480","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"250")
end
if t==5190 then
R.stage_CopyEnemy(state,"224+150","50+200","0","false","all","2")
end
if t==5220 then
R.stage_CopyEnemy(state,"74+150","50+200","0","false","all","1")
end
if t==5250 then
R.stage_CopyEnemy(state,"224+150","50+200","0","false","all","2")
end
if t==5280 then
R.stage_CopyEnemy(state,"74+150","50+200","0","false","all","1")
R.stage_SetEnemy(state,"19","324","130","0","0","900","390","10")
R.stage_AddEvent(state,"245","speed","0.2","30","1")
R.stage_AddEvent(state,"480","speed","3.5","120","1")
R.stage_SetEnemyItems(state,"0","3","0","2","0","0")
R.stage_SetNoHarmTime(state,"250")
end
if t==5310 then
R.stage_CopyEnemy(state,"224+150","50+200","0","false","all","2")
end
if t==5520 then
R.stage_SetEnemy(state,"28","224","-10","4","90","900","80","4","14")
R.stage_AddEvent(state,"15","speed","6.2","30","1")
R.stage_AddEvent(state,"15","speedf","35","30","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==5555 then
R.stage_SetEnemy(state,"28","224","-10","4","90","900","80","4","15")
R.stage_AddEvent(state,"15","speed","6.2","30","1")
R.stage_AddEvent(state,"15","speedf","145","30","1")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
end
if t==5590 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5595 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5600 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5605 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5610 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5615 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5620 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5625 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5630 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5635 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5640 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5645 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5650 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5655 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5660 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5665 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5670 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
R.stage_SetEnemy(state,"2","224","-60","0.0","90","240","9990","113")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"240")
end
if t==5675 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5680 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5685 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5690 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5695 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5700 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5705 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5710 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5715 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5720 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5725 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5730 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5735 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5740 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5745 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5750 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5755 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5760 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5765 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5770 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5775 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5780 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5785 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5790 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5795 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5800 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5805 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5810 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5815 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5820 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5825 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5830 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5835 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5840 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5845 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5850 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5855 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5860 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5865 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5870 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5875 then
R.stage_CopyEnemy(state,"108+300","-50+40","0","false","all","15")
end
if t==5880 then
R.stage_CopyEnemy(state,"44+300","-50+40","0","false","all","14")
end
if t==5930 then
R.stage_SetEnemy(state,"2","224","-60","0.0","90","1580","9990","111")
R.stage_SetEnemyBarrageUnderActor(state)
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1580")
R.stage_SetEnemy(state,"2","224","-60","0.0","90","1580","9990","114")
R.stage_SetEnemyItems(state,"0","0","0","0","0","0")
R.stage_SetNoHarmTime(state,"1580")
end
if t==5980 then
R.stage_SetEnemy(state,"24","65","-50","3.5","90","900","600","3","3")
R.stage_SetEnemyItems(state,"0","2","0","2","0","0")
R.stage_SetNoHarmTime(state,"25")
R.stage_CopyEnemy(state,"385","-50","0","false","all","3")
R.stage_SetEnemy(state,"25","65","-50","0","90","900","120","110","11")
R.stage_SetEnemyItems(state,"0","1","0","1","0","0")
R.stage_SetNoHarmTime(state,"30")
R.stage_AddEvent(state,"25","speed","3.5","1","1")
R.stage_AddEvent(state,"25","speedf","90","1","1")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==6005 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==6030 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==6055 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==6080 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==6136 then
R.stage_CopyEnemy(state,"167","-50","0","false","all","3")
R.stage_CopyEnemy(state,"283","-50","0","false","all","3")
R.stage_CopyEnemy(state,"167","-50","0","false","all","11")
R.stage_CopyEnemy(state,"283","-50","0","false","all","11")
end
if t==6161 then
R.stage_CopyEnemy(state,"167","-50","0","false","all","11")
R.stage_CopyEnemy(state,"283","-50","0","false","all","11")
end
if t==6186 then
R.stage_CopyEnemy(state,"167","-50","0","false","all","11")
R.stage_CopyEnemy(state,"283","-50","0","false","all","11")
end
if t==6211 then
R.stage_CopyEnemy(state,"167","-50","0","false","all","11")
R.stage_CopyEnemy(state,"283","-50","0","false","all","11")
end
if t==6236 then
R.stage_CopyEnemy(state,"167","-50","0","false","all","11")
R.stage_CopyEnemy(state,"283","-50","0","false","all","11")
end
if t==6261 then
R.stage_CopyEnemy(state,"167","-50","0","false","all","11")
R.stage_CopyEnemy(state,"283","-50","0","false","all","11")
end
if t==6316 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","3")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6341 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6366 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6391 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6416 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6436 then
R.stage_CopyEnemy(state,"97","-50","0","false","all","3")
R.stage_CopyEnemy(state,"353","-50","0","false","all","3")
R.stage_CopyEnemy(state,"97","-50","0","false","all","11")
R.stage_CopyEnemy(state,"353","-50","0","false","all","11")
end
if t==6441 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6461 then
R.stage_CopyEnemy(state,"97","-50","0","false","all","11")
R.stage_CopyEnemy(state,"353","-50","0","false","all","11")
end
if t==6486 then
R.stage_CopyEnemy(state,"97","-50","0","false","all","11")
R.stage_CopyEnemy(state,"353","-50","0","false","all","11")
end
if t==6511 then
R.stage_CopyEnemy(state,"97","-50","0","false","all","11")
R.stage_CopyEnemy(state,"353","-50","0","false","all","11")
end
if t==6536 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","3")
R.stage_CopyEnemy(state,"97","-50","0","false","all","11")
R.stage_CopyEnemy(state,"353","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6561 then
R.stage_CopyEnemy(state,"97","-50","0","false","all","11")
R.stage_CopyEnemy(state,"353","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6586 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6611 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6636 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6661 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6796 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","3")
R.stage_CopyEnemy(state,"385","-50","0","false","all","3")
R.stage_CopyEnemy(state,"225","-50","0","false","all","3")
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6821 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6846 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6871 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6896 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6921 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
end
if t==6975 then
R.stage_CopyEnemy(state,"129","-50","0","false","all","3")
R.stage_CopyEnemy(state,"321","-50","0","false","all","3")
end
if t==6976 then
R.stage_CopyEnemy(state,"129","-50","0","false","all","11")
R.stage_CopyEnemy(state,"321","-50","0","false","all","11")
end
if t==7001 then
R.stage_CopyEnemy(state,"129","-50","0","false","all","11")
R.stage_CopyEnemy(state,"321","-50","0","false","all","11")
end
if t==7026 then
R.stage_CopyEnemy(state,"129","-50","0","false","all","11")
R.stage_CopyEnemy(state,"321","-50","0","false","all","11")
end
if t==7051 then
R.stage_CopyEnemy(state,"129","-50","0","false","all","11")
R.stage_CopyEnemy(state,"321","-50","0","false","all","11")
end
if t==7076 then
R.stage_CopyEnemy(state,"129","-50","0","false","all","11")
R.stage_CopyEnemy(state,"321","-50","0","false","all","11")
end
if t==7101 then
R.stage_CopyEnemy(state,"129","-50","0","false","all","11")
R.stage_CopyEnemy(state,"321","-50","0","false","all","11")
end
if t==7155 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","3")
R.stage_CopyEnemy(state,"65","-50","0","false","all","3")
R.stage_CopyEnemy(state,"385","-50","0","false","all","3")
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==7180 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==7205 then
R.stage_CopyEnemy(state,"225","-50","0","false","all","11")
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==7230 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==7255 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
end
if t==7280 then
R.stage_CopyEnemy(state,"173","-50","0","false","all","3")
R.stage_CopyEnemy(state,"279","-50","0","false","all","3")
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"173","-50","0","false","all","11")
R.stage_CopyEnemy(state,"279","-50","0","false","all","11")
end
if t==7305 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"173","-50","0","false","all","11")
R.stage_CopyEnemy(state,"279","-50","0","false","all","11")
end
if t==7330 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"173","-50","0","false","all","11")
R.stage_CopyEnemy(state,"279","-50","0","false","all","11")
end
if t==7355 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"173","-50","0","false","all","11")
R.stage_CopyEnemy(state,"279","-50","0","false","all","11")
end
if t==7380 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"173","-50","0","false","all","11")
R.stage_CopyEnemy(state,"279","-50","0","false","all","11")
end
if t==7405 then
R.stage_CopyEnemy(state,"65","-50","0","false","all","11")
R.stage_CopyEnemy(state,"385","-50","0","false","all","11")
R.stage_CopyEnemy(state,"173","-50","0","false","all","11")
R.stage_CopyEnemy(state,"279","-50","0","false","all","11")
end
if t==7460 then
R.stage_SetBossItems(state,"0","24","0","24","0","100","0","0","0")
end
if t==7500 then
R.stage_SetBossItems(state,"0","24","0","24","0","0","1","0","0")
end
end
