-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=224,["cy"]=32,["start"]=805,["duration"]=130,["mode"]="enemy",["fx"]=316,["fy"]=16,["radius"]=200,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=80,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyMaoYu00",["hp"]=45,["red_drop"]=1,["blue_drop"]=1,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",50.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius",400.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,0,150) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+3.0*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,50) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",10.0,1,0,100) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+10.0*N.pm(o.run),0,1,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=256,["cy"]=32,["start"]=1020,["duration"]=130,["mode"]="enemy",["fx"]=316,["fy"]=16,["radius"]=-200,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=95,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyMaoYu01",["hp"]=45,["red_drop"]=1,["blue_drop"]=1,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",55.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius",400.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,0,150) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+3.0*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,50) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",10.0,1,0,100) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"direction",(180.0)+10.0*N.pm(o.run),0,1,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=384,["cy"]=32,["start"]=1225,["duration"]=130,["mode"]="enemy",["fx"]=316,["fy"]=16,["radius"]=200,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyMaoYu00",["hp"]=45,["red_drop"]=1,["blue_drop"]=1,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",55.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius",400.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,0,150) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+3.0*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,50) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",10.0,1,0,100) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+10.0*N.pm(o.run),0,1,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=416,["cy"]=32,["start"]=1430,["duration"]=120,["mode"]="enemy",["fx"]=316,["fy"]=16,["radius"]=-200,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyMaoYu01",["hp"]=45,["red_drop"]=1,["blue_drop"]=1,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",55.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius",400.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,0,150) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+3.0*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,50) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",10.0,1,0,100) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"direction",(180.0)+10.0*N.pm(o.run),0,1,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=224,["cy"]=192,["start"]=905,["duration"]=1,["mode"]="enemy",["fx"]=150,["fy"]=16,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=80,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2020,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA8",["hp"]=125,["red_drop"]=4,["blue_drop"]=4,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=100,["green_drop"]=0,["star_drop"]=0}}
T.emitters[5].events=nil
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+3.0*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,50) end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"speed",10.0,1,0,400) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=256,["cy"]=192,["start"]=1110,["duration"]=1,["mode"]="enemy",["fx"]=482,["fy"]=16,["radius"]=0,["radius_angle"]=180,["ways"]=1,["cycle"]=1,["emit_angle"]=100,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2020,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA8",["hp"]=125,["red_drop"]=4,["blue_drop"]=4,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=100,["green_drop"]=0,["star_drop"]=0}}
T.emitters[6].events=nil
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,50) end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"speed",10.0,1,0,400) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=4,["with_direction"]=false,["cx"]=224,["cy"]=256,["start"]=1,["duration"]=30,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=10,["cycle"]=222222,["emit_angle"]=-99999,["spread"]=180,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2022220,["type"]=56,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%50==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*50)) then N.tween(o,o.p,"speed",4.0,0,1,1) end
if (t == (1.0+o.loops[0]*50)) then N.tween(o,o.p,"speed",2.75,0,0,3) end
if (t == (1.0+o.loops[0]*50)) then N.tween(o,o,"cycle",1.0,0,1,1) end
if (t == (3.0+o.loops[0]*50)) then N.tween(o,o,"cycle",12222.0,0,1,1) end
end
T.emitters[7].p.events=nil
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=224,["cy"]=96,["start"]=10,["duration"]=12,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=12222,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200222,["type"]=77,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",90.0,0,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",1.0,0,0,10) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o.p,"type",5.0,0,1,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"ways",7.0,1,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.5,0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(0.0)+21421.0*N.pm(o.run),0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"cycle",22222.0,0,1,1) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.5*N.pm(o.run),1,0,50) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=5,["with_direction"]=false,["cx"]=256,["cy"]=256,["start"]=1,["duration"]=30,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=10,["cycle"]=222222,["emit_angle"]=-99999,["spread"]=180,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2022220,["type"]=56,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%50==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*50)) then N.tween(o,o.p,"speed",4.0,0,1,1) end
if (t == (1.0+o.loops[0]*50)) then N.tween(o,o.p,"speed",2.75,0,0,3) end
if (t == (1.0+o.loops[0]*50)) then N.tween(o,o,"cycle",1.0,0,1,1) end
if (t == (3.0+o.loops[0]*50)) then N.tween(o,o,"cycle",12222.0,0,1,1) end
end
T.emitters[9].p.events=nil
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=256,["cy"]=96,["start"]=10,["duration"]=12,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=12222,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200222,["type"]=77,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",90.0,0,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",1.0,0,0,10) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o.p,"type",5.0,0,1,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"ways",7.0,1,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.5,0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(0.0)+21421.0*N.pm(o.run),0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"cycle",22222.0,0,1,1) end
end
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.5*N.pm(o.run),1,0,50) end
end
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=384,["cy"]=96,["start"]=10,["duration"]=12,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=12222,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200222,["type"]=77,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[11].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",90.0,0,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",1.0,0,0,10) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o.p,"type",5.0,0,1,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"ways",7.0,1,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.5,0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(0.0)+21421.0*N.pm(o.run),0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"cycle",22222.0,0,1,1) end
end
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.5*N.pm(o.run),1,0,50) end
end
T.emitters[12]={["id"]=11,["layer"]=0,["bind"]=3,["with_direction"]=false,["cx"]=416,["cy"]=96,["start"]=10,["duration"]=12,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=12222,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200222,["type"]=77,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[12].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",90.0,0,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",1.0,0,0,10) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o.p,"type",5.0,0,1,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"ways",7.0,1,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.5,0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(0.0)+21421.0*N.pm(o.run),0,1,1) end
if (t == (12.0+o.loops[0]*0)) then N.tween(o,o,"cycle",22222.0,0,1,1) end
end
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.5*N.pm(o.run),1,0,50) end
end
return T
