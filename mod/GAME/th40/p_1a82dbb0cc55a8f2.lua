-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=512,["cy"]=32,["start"]=990,["duration"]=1,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=135,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4.75,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA8",["hp"]=1900,["red_drop"]=9,["blue_drop"]=9,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=120,["green_drop"]=0,["star_drop"]=1}}
T.emitters[1].events=nil
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",40.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,150) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=32,["start"]=780,["duration"]=1,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=45,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4.75,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA8",["hp"]=1900,["red_drop"]=9,["blue_drop"]=9,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=120,["green_drop"]=0,["star_drop"]=1}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",40.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,0,0,150) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=384,["cy"]=160,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=60,["ways"]=2,["cycle"]=999,["emit_angle"]=180,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=67,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,2,190) end
o.loops[1]=o.loops[1] or 0
if (t)%10==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*10)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (5.0+o.loops[1]*10)) then N.tween(o,o,"cycle",9999.0,0,1,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"speed",4.0,0,0,200) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=416,["cy"]=160,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=60,["ways"]=2,["cycle"]=999,["emit_angle"]=180,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=67,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,2,190) end
o.loops[1]=o.loops[1] or 0
if (t)%10==0 then o.loops[1]=o.loops[1]+1 end
if (t == (5.0+o.loops[1]*10)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (1.0+o.loops[1]*10)) then N.tween(o,o,"cycle",9999.0,0,1,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"speed",-3.0,0,0,130) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=480,["cy"]=160,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=60,["ways"]=2,["cycle"]=5,["emit_angle"]=190,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=65,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=4.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.0,0,2,220) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,2,0,130) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,2,0,1) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=160,["cy"]=96,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=60,["ways"]=2,["cycle"]=999,["emit_angle"]=180,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=67,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,2,190) end
o.loops[1]=o.loops[1] or 0
if (t)%10==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*10)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (5.0+o.loops[1]*10)) then N.tween(o,o,"cycle",9999.0,0,1,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"speed",4.0,0,0,200) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=192,["cy"]=96,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=60,["ways"]=2,["cycle"]=999,["emit_angle"]=180,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=67,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",2.0,0,2,190) end
o.loops[1]=o.loops[1] or 0
if (t)%10==0 then o.loops[1]=o.loops[1]+1 end
if (t == (5.0+o.loops[1]*10)) then N.tween(o,o,"cycle",2.0,0,1,1) end
if (t == (1.0+o.loops[1]*10)) then N.tween(o,o,"cycle",9999.0,0,1,1) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"speed",-3.0,0,0,130) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=256,["cy"]=96,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=60,["ways"]=2,["cycle"]=5,["emit_angle"]=170,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=65,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=4.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.0,0,2,220) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,2,0,130) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,2,0,1) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=160,["cy"]=160,["start"]=145,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=-99999,["ways"]=30,["cycle"]=1,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=114,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[9].events=nil
T.emitters[9].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,0,0,30) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,25) end
end
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=384,["cy"]=224,["start"]=145,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=-99999,["ways"]=30,["cycle"]=1,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=114,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[10].events=nil
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,0,0,30) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,25) end
end
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=288,["cy"]=96,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=60,["ways"]=2,["cycle"]=5,["emit_angle"]=170,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=65,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[11].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",1.0,0,2,220) end
end
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,1,0,130) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,2,0,1) end
end
T.emitters[12]={["id"]=11,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=512,["cy"]=160,["start"]=1,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=60,["ways"]=2,["cycle"]=5,["emit_angle"]=190,["spread"]=2140,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=65,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[12].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",420.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",500.0,1,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",1060.0,2,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",1.0,0,2,220) end
end
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,1,0,130) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,2,0,1) end
end
T.emitters[13]={["id"]=12,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=192,["cy"]=160,["start"]=145,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=-99999,["ways"]=30,["cycle"]=1,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2020,["type"]=114,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[13].events=nil
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,30) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.75,0,0,25) end
end
T.emitters[14]={["id"]=13,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=416,["cy"]=224,["start"]=145,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=-99999,["ways"]=30,["cycle"]=1,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2002,["type"]=114,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[14].events=nil
T.emitters[14].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,30) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.75,0,0,25) end
end
return T
