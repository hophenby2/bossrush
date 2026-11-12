-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=2,["with_direction"]=true,["cx"]=160,["cy"]=192,["start"]=90,["duration"]=750,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=30,["ways"]=2,["cycle"]=1,["emit_angle"]=28,["spread"]=360,["speed"]=0.0001,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1302,["type"]=72,["width"]=0.8,["height"]=0.8,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=450,["follow"]=false,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=180,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",21600.0,2,0,1440) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",50.0,0,0,700) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o.p,"speed",3.0,0,2,1400) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (15.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=2,["with_direction"]=true,["cx"]=160,["cy"]=256,["start"]=90,["duration"]=750,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=30,["ways"]=2,["cycle"]=1,["emit_angle"]=18,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1302,["type"]=72,["width"]=0.8,["height"]=0.8,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=450,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=180,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",21600.0,2,0,1440) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",50.0,0,0,700) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o.p,"speed",3.2,0,2,1400) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (15.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=1920,["duration"]=8080,["mode"]="enemy",["fx"]=316,["fy"]=-25,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=222200,["type"]=221,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=10,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA8",["hp"]=6000,["red_drop"]=10,["blue_drop"]=10,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=500,["green_drop"]=10,["star_drop"]=1}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",-0.24,0,0,50) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=2,["with_direction"]=true,["cx"]=192,["cy"]=192,["start"]=90,["duration"]=750,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=30,["ways"]=2,["cycle"]=1,["emit_angle"]=28,["spread"]=360,["speed"]=0.0001,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1302,["type"]=72,["width"]=1.1,["height"]=1.1,["red"]=0,["green"]=0,["blue"]=255,["alpha"]=255,["angle"]=450,["follow"]=false,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=180,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet10_15"}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",21600.0,2,0,1440) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",50.0,0,0,700) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o.p,"speed",3.0,0,2,1400) end
o.loops[2]=o.loops[2] or 0
if (t)%1==0 then o.loops[2]=o.loops[2]+1 end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o.p,"red",255.0,0,0,250) end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o.p,"green",0.0,0,0,250) end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o.p,"blue",0.0,0,0,250) end
if (t == (500.0+o.loops[2]*0)) then N.tween(o,o.p,"blue",255.0,0,0,250) end
if (t == (500.0+o.loops[2]*0)) then N.tween(o,o.p,"green",0.0,0,0,250) end
if (t == (500.0+o.loops[2]*0)) then N.tween(o,o.p,"red",0.0,0,0,250) end
if (t == (250.0+o.loops[2]*0)) then N.tween(o,o.p,"green",255.0,0,0,250) end
if (t == (250.0+o.loops[2]*0)) then N.tween(o,o.p,"blue",0.0,0,0,250) end
if (t == (250.0+o.loops[2]*0)) then N.tween(o,o.p,"red",0.0,0,0,250) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (15.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=2,["with_direction"]=true,["cx"]=192,["cy"]=256,["start"]=90,["duration"]=750,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=30,["ways"]=2,["cycle"]=1,["emit_angle"]=18,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1302,["type"]=72,["width"]=1.1,["height"]=1.1,["red"]=0,["green"]=0,["blue"]=255,["alpha"]=255,["angle"]=450,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=180,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet10_15"}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",28800.0,1,0,1440) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",21600.0,2,0,1440) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",50.0,0,0,700) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o.p,"speed",3.2,0,2,1400) end
o.loops[2]=o.loops[2] or 0
if (t)%1==0 then o.loops[2]=o.loops[2]+1 end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o.p,"red",255.0,0,0,250) end
if (t == (500.0+o.loops[2]*0)) then N.tween(o,o.p,"blue",255.0,0,0,250) end
if (t == (250.0+o.loops[2]*0)) then N.tween(o,o.p,"green",255.0,0,0,250) end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o.p,"green",0.0,0,0,250) end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o.p,"blue",0.0,0,0,250) end
if (t == (500.0+o.loops[2]*0)) then N.tween(o,o.p,"red",0.0,0,0,250) end
if (t == (500.0+o.loops[2]*0)) then N.tween(o,o.p,"green",0.0,0,0,250) end
if (t == (250.0+o.loops[2]*0)) then N.tween(o,o.p,"blue",0.0,0,0,250) end
if (t == (250.0+o.loops[2]*0)) then N.tween(o,o.p,"red",0.0,0,0,250) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (15.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=480,["cy"]=192,["start"]=90,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=75,["green"]=75,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[6].events=nil
T.emitters[6].p.events=nil
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=320,["cy"]=79,["start"]=508,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=3,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=85,["green"]=85,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[7].events=nil
T.emitters[7].p.events=nil
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=384,["cy"]=79,["start"]=508,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=3,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=0,["blue"]=0,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[8].events=nil
T.emitters[8].p.events=nil
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=352,["cy"]=79,["start"]=508,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=3,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=0,["green"]=255,["blue"]=0,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[9].events=nil
T.emitters[9].p.events=nil
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=448,["cy"]=192,["start"]=65,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=80,["blue"]=80,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[10].events=nil
T.emitters[10].p.events=nil
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=416,["cy"]=192,["start"]=40,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=80,["green"]=255,["blue"]=80,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[11].events=nil
T.emitters[11].p.events=nil
return T
