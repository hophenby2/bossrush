-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=270,["ways"]=1,["cycle"]=3,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=25,["radius_angle"]=323,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=52220,["type"]=6,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0.025,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",255.0,2,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",255.0,2,1,1) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",125.0,1,1,1) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",125.0,1,1,1) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,1,0,150) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",270.0,0,1,1) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,2,1,1) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,1,1,1) end
if (t == (300.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",255.0,2,1,1) end
if (t == (300.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",255.0,2,1,1) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",125.0,1,1,1) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",125.0,1,1,1) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,1,0,150) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",270.0,0,1,1) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,1,0,150) end
if (t == (300.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,2,0,150) end
if (t == (300.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,2,0,150) end
if (t == (300.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,2,1,1) end
if (t == (600.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",255.0,2,1,1) end
if (t == (600.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",255.0,2,1,1) end
if (t == (750.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",125.0,1,1,1) end
if (t == (750.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",125.0,1,1,1) end
if (t == (750.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,1,0,150) end
if (t == (750.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",270.0,0,1,1) end
if (t == (750.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,1,0,150) end
if (t == (600.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,2,0,150) end
if (t == (600.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,2,0,150) end
if (t == (600.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,2,1,1) end
if (t == (750.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,1,1,1) end
if (t == (900.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",255.0,2,1,1) end
if (t == (900.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",255.0,2,1,1) end
if (t == (1050.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",125.0,1,1,1) end
if (t == (1050.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",125.0,1,1,1) end
if (t == (1050.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,1,0,150) end
if (t == (1050.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",270.0,0,1,1) end
if (t == (1050.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,1,0,150) end
if (t == (900.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,2,0,150) end
if (t == (900.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",360.0,2,0,150) end
if (t == (900.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,2,1,1) end
if (t == (1050.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,1,1,1) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o.p,"type",1.0,1,1,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.5)+2.5*N.pm(o.run),0,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.75)+0.25*N.pm(o.run),0,0,50) end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"accel",(0.03)+0.02*N.pm(o.run),0,1,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=6200,["duration"]=1,["mode"]="enemy",["fx"]=316,["fy"]=16,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002222,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA8",["hp"]=7250,["red_drop"]=10,["blue_drop"]=10,["enemy_color"]=0,["backfire"]=true,["clear_radius"]=150,["green_drop"]=0,["star_drop"]=1}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.025,0,0,75) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=6200,["duration"]=3800,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=12,["cycle"]=100,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=222200,["type"]=116,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=8,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=nil
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,25) end
end
return T
