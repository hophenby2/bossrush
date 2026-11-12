-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=99999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=156,["cy"]=154,["start"]=8410,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=3000,["type"]=1,["width"]=0,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=2.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=nil
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,70) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0148,1,0,35) end
if (t == (650.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (650.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (631.0+o.loops[0]*0)) and (t < (700.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (631.0+o.loops[0]*0)) and (t < (700.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0148,2,0,35) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=124,["cy"]=209,["start"]=8510,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=316,["cy"]=209,["start"]=8520,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=nil
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=508,["cy"]=209,["start"]=8530,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=nil
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=316,["cy"]=273,["start"]=8550,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=nil
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=124,["cy"]=401,["start"]=8600,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=nil
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=508,["cy"]=273,["start"]=8560,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=nil
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=124,["cy"]=337,["start"]=8570,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=nil
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=124,["cy"]=273,["start"]=8540,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[9].events=nil
T.emitters[9].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=316,["cy"]=401,["start"]=8610,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[10].events=nil
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=508,["cy"]=401,["start"]=8620,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[11].events=nil
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[12]={["id"]=11,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=316,["cy"]=337,["start"]=8580,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[12].events=nil
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
T.emitters[13]={["id"]=12,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=508,["cy"]=337,["start"]=8590,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0,["height"]=0.75,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=430,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[13].events=nil
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t == (20.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t > (1.0+o.loops[0]*0)) and (t < (70.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,1,0,35) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (530.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,0,0,70) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"angle",0.3,1,0,35) end
if (t > (501.0+o.loops[0]*0)) and (t < (570.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0111,2,0,35) end
end
return T
