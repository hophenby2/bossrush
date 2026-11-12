-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=137,["cy"]=0,["start"]=6600,["duration"]=246,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=246,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%123==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*123)) then N.tween(o,o,"speed",4.0,1,0,30) end
if (t == (61.0+o.loops[0]*123)) then N.tween(o,o,"direction",180.0,2,0,1) end
if (t == (61.0+o.loops[0]*123)) then N.tween(o,o,"speed",4.0,1,0,30) end
if (t == (31.0+o.loops[0]*123)) then N.tween(o,o,"speed",4.0,2,0,30) end
if (t == (91.0+o.loops[0]*123)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (121.0+o.loops[0]*123)) then N.tween(o,o,"direction",180.0,2,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=503,["cy"]=0,["start"]=6600,["duration"]=246,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=246,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%123==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*123)) then N.tween(o,o,"speed",4.0,1,0,30) end
if (t == (61.0+o.loops[0]*123)) then N.tween(o,o,"direction",180.0,2,0,1) end
if (t == (61.0+o.loops[0]*123)) then N.tween(o,o,"speed",4.0,1,0,30) end
if (t == (121.0+o.loops[0]*123)) then N.tween(o,o,"direction",180.0,2,0,1) end
if (t == (31.0+o.loops[0]*123)) then N.tween(o,o,"speed",4.0,2,0,30) end
if (t == (91.0+o.loops[0]*123)) then N.tween(o,o,"speed",0.0,0,0,30) end
end
T.emitters[3]={["id"]=0,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=256,["cy"]=64,["start"]=1,["duration"]=1200,["mode"]="laser",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=4,["emit_angle"]=90,["spread"]=90,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=true,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1200,["type"]=2,["width"]=1,["height"]=1.2,["length"]=25,["alpha"]=255,["angle"]=0,["speed"]=7,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0}}
T.emitters[3].events=nil
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,60) end
end
T.emitters[4]={["id"]=1,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=384,["cy"]=64,["start"]=1,["duration"]=1200,["mode"]="laser",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=4,["emit_angle"]=90,["spread"]=90,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=true,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1200,["type"]=2,["width"]=1,["height"]=1.2,["length"]=25,["alpha"]=255,["angle"]=0,["speed"]=7,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0}}
T.emitters[4].events=nil
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,60) end
end
return T
