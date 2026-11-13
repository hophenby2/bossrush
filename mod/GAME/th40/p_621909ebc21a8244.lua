-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=4000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=4000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=15,["cycle"]=5,["emit_angle"]=270,["spread"]=300,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=37,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=180,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%421==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*421)) then N.tween(o,o.p,"accel_angle",360.0,1,2,420) end
if (t == (211.0+o.loops[0]*421)) then N.tween(o,o,"spread",90.0,1,2,210) end
if (t == (1.0+o.loops[0]*421)) then N.tween(o,o,"spread",90.0,1,2,210) end
o.loops[1]=o.loops[1] or 0
if (t)%421==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*421)) then N.tween(o,o,"emit_angle",50.0,1,2,420) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"accel_angle",90.0,1,0,100) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.5*N.pm(o.run),0,0,60) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"red",(45.0)+45.0*N.pm(o.run),2,0,1) end
if (o.cy > (300.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.02,0,0,1) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"blue",(70.0)+70.0*N.pm(o.run),2,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+25.0*N.pm(o.run),1,0,60) end
if (o.cx < (0.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
return T
