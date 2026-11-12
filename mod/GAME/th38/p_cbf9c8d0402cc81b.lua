-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=9000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=68,["cycle"]=16,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=23,["width"]=0.5,["height"]=0.5,["red"]=255,["green"]=177,["blue"]=27,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2.1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[1].events=nil
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%32==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*32)) then N.tween(o,o,"speed",0.0,0,0,15) end
if (t == (16.0+o.loops[0]*32)) then N.tween(o,o,"speed",2.1,0,0,16) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (175.0+o.loops[1]*0)) then N.tween(o,o,"speed",2.1,0,0,1) end
if (t == (160.0+o.loops[1]*0)) then N.tween(o,o,"green",(177.0)+40.0*N.pm(o.run),0,0,30) end
end
return T
