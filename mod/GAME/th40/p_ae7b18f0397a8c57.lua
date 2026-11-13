-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=750,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=0,["start"]=1,["duration"]=360,["mode"]="bullet",["fx"]=100,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=10,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=1,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=3,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"cy",0.0,0,0,1) end
if (t == (2.0+o.loops[0]*60)) then N.tween(o,o,"cy",480.0,0,0,58) end
o.loops[1]=o.loops[1] or 0
if (t)%60==0 then o.loops[1]=o.loops[1]+1 end
if (t == (59.0+o.loops[1]*60)) then N.tween(o,o,"cycle",1.0,1,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(20.0)+5.0*N.pm(o.run),1,0,90) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+0.5*N.pm(o.run),0,0,90) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=192,["cy"]=0,["start"]=390,["duration"]=360,["mode"]="bullet",["fx"]=540,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=170,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=1,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=5,["width"]=1,["height"]=1,["red"]=200,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"cy",0.0,0,0,1) end
if (t == (2.0+o.loops[0]*60)) then N.tween(o,o,"cy",480.0,0,0,58) end
o.loops[1]=o.loops[1] or 0
if (t)%60==0 then o.loops[1]=o.loops[1]+1 end
if (t == (59.0+o.loops[1]*60)) then N.tween(o,o,"cycle",1.0,1,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(20.0)+5.0*N.pm(o.run),2,0,90) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+0.5*N.pm(o.run),0,0,90) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=160,["cy"]=0,["start"]=360,["duration"]=360,["mode"]="bullet",["fx"]=100,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=8,["emit_angle"]=10,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=3,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2.8,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"cy",0.0,0,0,1) end
if (t == (2.0+o.loops[0]*60)) then N.tween(o,o,"cy",480.0,0,0,58) end
o.loops[1]=o.loops[1] or 0
if (t)%60==0 then o.loops[1]=o.loops[1]+1 end
if (t == (59.0+o.loops[1]*60)) then N.tween(o,o,"cycle",1.0,2,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(20.0)+5.0*N.pm(o.run),1,0,90) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(4.0)+0.5*N.pm(o.run),0,0,90) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=224,["cy"]=0,["start"]=30,["duration"]=360,["mode"]="bullet",["fx"]=540,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=8,["emit_angle"]=170,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=5,["width"]=1,["height"]=1,["red"]=200,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2.8,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"cy",0.0,0,0,1) end
if (t == (2.0+o.loops[0]*60)) then N.tween(o,o,"cy",480.0,0,0,58) end
o.loops[1]=o.loops[1] or 0
if (t)%60==0 then o.loops[1]=o.loops[1]+1 end
if (t == (59.0+o.loops[1]*60)) then N.tween(o,o,"cycle",1.0,2,0,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(20.0)+5.0*N.pm(o.run),2,0,90) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(4.0)+0.5*N.pm(o.run),0,0,90) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=0,["start"]=1,["duration"]=750,["mode"]="bullet",["fx"]=100,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=4,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=3,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"cy",0.0,0,0,1) end
if (t == (2.0+o.loops[0]*60)) then N.tween(o,o,"cy",250.0,0,0,58) end
o.loops[1]=o.loops[1] or 0
if (t)%60==0 then o.loops[1]=o.loops[1]+1 end
if (t == (59.0+o.loops[1]*60)) then N.tween(o,o,"cycle",1.0,1,0,1) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(10.0)+10.0*N.pm(o.run),2,0,90) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+0.5*N.pm(o.run),0,0,90) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=192,["cy"]=0,["start"]=1,["duration"]=750,["mode"]="bullet",["fx"]=540,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=4,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=5,["width"]=1,["height"]=1,["red"]=200,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"cy",0.0,0,0,1) end
if (t == (2.0+o.loops[0]*60)) then N.tween(o,o,"cy",250.0,0,0,58) end
o.loops[1]=o.loops[1] or 0
if (t)%60==0 then o.loops[1]=o.loops[1]+1 end
if (t == (59.0+o.loops[1]*60)) then N.tween(o,o,"cycle",1.0,1,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(10.0)+10.0*N.pm(o.run),1,0,90) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+0.5*N.pm(o.run),0,0,90) end
end
return T
