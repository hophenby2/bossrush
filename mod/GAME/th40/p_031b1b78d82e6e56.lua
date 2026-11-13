-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=360,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=1,["duration"]=15,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=90,["spread"]=60,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=37,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=4,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",(120.0)+30.0*N.pm(o.run),0,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"cx",(510.0)+30.0*N.pm(o.run),0,0,14) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(20.0)+10.0*N.pm(o.run),1,2,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.6)+0.4*N.pm(o.run),0,0,30) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+30.0*N.pm(o.run),1,0,60) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.01,0,0,15) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+2.0*N.pm(o.run),0,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=384,["cy"]=256,["start"]=1,["duration"]=72,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=8,["radius_angle"]=90,["ways"]=2,["cycle"]=12,["emit_angle"]=90,["spread"]=180,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=37,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=4,["cover"]=true}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.2)+0.4*N.pm(o.run),0,0,30) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (90.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+45.0*N.pm(o.run),1,0,75) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
if (t == (5.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.01,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=true,["cx"]=480,["cy"]=256,["start"]=1,["duration"]=75,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=37,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",17.0,1,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.6)+0.4*N.pm(o.run),0,0,60) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",(225.0)+30.0*N.pm(o.run),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",(225.0)+30.0*N.pm(o.run),0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=0,["with_direction"]=true,["cx"]=512,["cy"]=256,["start"]=1,["duration"]=75,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=60,["type"]=37,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=nil
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.6)+0.4*N.pm(o.run),0,0,60) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
end
return T
