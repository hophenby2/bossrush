-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=460,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=160,["cy"]=32,["start"]=1,["duration"]=460,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=87,["spread"]=360,["speed"]=0,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20000,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (50.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=nil
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=160,["cy"]=288,["start"]=1,["duration"]=460,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=40,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=3,["y"]=3,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=440,["type"]=21,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=204,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%240==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*240)) then N.tween(o,o,"speed",3.0,1,2,239) end
if (t == (100.0+o.loops[0]*240)) then N.tween(o,o,"angle",180.0,1,0,40) end
if (t == (220.0+o.loops[0]*240)) then N.tween(o,o,"angle",180.0,2,0,40) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,2,2,480) end
if (t == (121.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,1,2,480) end
if (t == (241.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,2,2,480) end
if (t == (361.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,1,2,480) end
if (t == (481.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,2,2,480) end
if (t == (601.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,1,2,480) end
if (t == (721.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,2,2,480) end
if (t == (841.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,1,2,480) end
if (t == (961.0+o.loops[1]*0)) then N.tween(o,o,"direction",80.0,2,2,480) end
o.loops[2]=o.loops[2] or 0
if (t+1)%1==0 then o.loops[2]=o.loops[2]+1 end
if (o.cy > (475.0+o.loops[2]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=530,["cy"]=0,["start"]=1,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=6,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=30,["delta_v"]=1,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=50,["type"]=21,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=7.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",580.0,2,0,180) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,1) end
end
return T
