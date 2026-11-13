-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=340,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=224,["start"]=1,["duration"]=110,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=360,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=180,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",2.0,1,0,1) end
end
T.emitters[1].p.events=nil
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=192,["cy"]=352,["start"]=30,["duration"]=81,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=12,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=120,["type"]=130,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",12.0,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=192,["cy"]=384,["start"]=1,["duration"]=110,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=9,["cycle"]=6,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=90,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=4,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=nil
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(360.0)+20.0*N.pm(o.run),1,0,30) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.5*N.pm(o.run),0,0,60) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=224,["cy"]=352,["start"]=30,["duration"]=81,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=48,["cycle"]=12,["emit_angle"]=-99999,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=360,["type"]=130,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=nil
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",(5.0)+4.0*N.pm(o.run),0,0,1) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+3.5*N.pm(o.run),1,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",4.0,0,0,60) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=150,["green"]=255,["blue"]=150,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[5].events=nil
T.emitters[5].p.events=nil
T.emitters[6]={["id"]=0,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=192,["cy"]=320,["start"]=30,["duration"]=81,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=12,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=50,["type"]=2,["width"]=3.515625,["height"]=0.2,["length"]=900,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=3.515625,["max_height"]=1}}
T.emitters[6].events=nil
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
end
T.emitters[7]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=224,["cy"]=320,["start"]=30,["duration"]=81,["mode"]="laser",["radius"]=0,["radius_angle"]=0,["ways"]=3,["cycle"]=12,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=120,["type"]=2,["width"]=1,["height"]=2.5,["length"]=35,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0}}
T.emitters[7].events=nil
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",12.0,0,0,1) end
end
return T
