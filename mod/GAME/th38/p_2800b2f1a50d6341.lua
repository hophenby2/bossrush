-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=40000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=60,["duration"]=39941,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=5,["cycle"]=4,["emit_angle"]=20,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=113,["width"]=0.7,["height"]=0.7,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",2.16,1,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",3.0,1,0,150) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (150.0+o.loops[0]*400)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (160.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",1.0,0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (5.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,10) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",1.2,2,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=260,["duration"]=39741,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=5,["cycle"]=4,["emit_angle"]=20,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=113,["width"]=0.7,["height"]=0.7,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",2.16,2,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",3.0,1,0,150) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (150.0+o.loops[0]*400)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (160.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",1.0,0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (5.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,10) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",1.2,1,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=200,["green"]=150,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[3].events=nil
T.emitters[3].p.events=nil
return T
