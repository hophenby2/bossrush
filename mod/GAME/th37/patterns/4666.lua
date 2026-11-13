-- 离线展开：b4666.xna；事件均已编译为Lua条件和调用。
return {id="4666",total=1850,centerAvailable=true,center={315,-20,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,160,200,80,100,0,0},{160,0,160,200,80,100,0,0},{320,0,160,200,80,100,0,0},{480,0,160,200,80,100,0,0},{640,0,160,200,80,100,0,0},{800,0,160,200,80,100,0,0},{0,200,160,200,80,100,0,0},{160,200,160,200,80,100,0,0},{800,400,160,200,80,100,0,0},{640,400,160,200,80,100,0,0},{480,400,160,200,80,100,0,0},{320,400,160,200,80,100,0,0},{160,400,160,200,80,100,0,0},{0,400,160,200,80,100,0,0},{800,600,160,200,80,100,0,0},{640,600,160,200,80,100,0,0},{0,700,500,300,250,150,0,0},{550,804,44,189,22,340,0,0},{629,965,15,20,8,10,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=301,["life"]=300,["fx"]=-99998,["fy"]=-56,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=1.5,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=247,["wscale"]=0.24,["hscale"]=0.4,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",70.0,0,1,"正比",200) end
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(241) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",120) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.5,0.3,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.5,0.4,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",6.0,2.0,1,"正比",90) end
if t==(1+math.floor(t/14)*14) then R.change(o,"wscale",0.04,0,0,"正弦",13) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=64,["begin"]=301,["life"]=400,["fx"]=-99998,["fy"]=-56,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=1.5,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=247,["wscale"]=0.2,["hscale"]=0.4,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",90.0,0,1,"正比",300) end
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(241) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",120) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.5,0.3,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.5,0.4,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",7.0,2.0,1,"正比",90) end
if t==(1+math.floor(t/14)*14) then R.change(o,"wscale",0.04,0,0,"正弦",13) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=1,["life"]=400,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=247,["wscale"]=0.2,["hscale"]=0.4,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(300) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(241) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.5,0.3,1,"正比",60) end
if t==(62) then R.change(o,"sonspeed",6.0,2.0,1,"正比",90) end
if t==(1+math.floor(t/14)*14) then R.change(o,"wscale",0.04,0,0,"正弦",13) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=306,["life"]=800,["fx"]=-99998,["fy"]=-58,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=1.5,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=247,["wscale"]=0.3,["hscale"]=0.5,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=110,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(360) then R.change(o,"t",4.0,0,0,"正比",1) end
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",200) end
if t==(250) then R.change(o,"t",6.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(481) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",120) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.5,0.4,0,"正比",161) end
if t==(1+math.floor(t/14)*14) then R.change(o,"wscale",0.04,0,0,"正弦",13) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=301,["life"]=600,["fx"]=-99998,["fy"]=-56,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=1.5,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=247,["wscale"]=0.2,["hscale"]=0.4,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=110,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(360) then R.change(o,"t",4.0,0,0,"正比",1) end
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",200) end
if t==(250) then R.change(o,"t",6.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(481) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",120) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.5,0.4,0,"正比",161) end
if t==(1+math.floor(t/24)*24) then R.change(o,"wscale",0.04,0,0,"正弦",23) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=301,["life"]=300,["fx"]=-99998,["fy"]=-50,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=1.5,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=247,["wscale"]=0.3,["hscale"]=0.5,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",70.0,0,1,"正比",200) end
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(241) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",120) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.5,0.3,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.5,0.4,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",6.0,2.0,1,"正比",90) end
if t==(1+math.floor(t/14)*14) then R.change(o,"wscale",0.04,0,0,"正弦",13) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=121,["life"]=300,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=247,["wscale"]=0.3,["hscale"]=0.5,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(300) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(241) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.5,0.3,1,"正比",60) end
if t==(62) then R.change(o,"sonspeed",6.0,2.0,1,"正比",90) end
if t==(1+math.floor(t/14)*14) then R.change(o,"wscale",0.04,0,0,"正弦",13) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=301,["life"]=600,["fx"]=-99998,["fy"]=-56,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=1.5,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=247,["wscale"]=0.15,["hscale"]=0.3,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=110,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(360) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",200) end
if t==(250) then R.change(o,"t",6.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(481) then R.change(o,"alpha",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",120) end
if t==(1) then R.change(o,"head",0.0,2100.0,1,"正比",380) end
if t==(1) then R.change(o,"sonspeedd",0.0,320.0,1,"正比",421) end
if t==(1) then R.change(o,"sonspeed",0.3,0.1,0,"正比",161) end
if t==(1+math.floor(t/24)*24) then R.change(o,"wscale",0.04,0,0,"正弦",23) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=384,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=530,["type"]=227,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",44.0,0,0,"正比",330) end
if t==(1) then R.change(o,"hscale",33.0,0,0,"正比",330) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",530) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=301,["life"]=5,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=530,["type"]=227,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",44.0,0,0,"正比",330) end
if t==(1) then R.change(o,"hscale",33.0,0,0,"正比",330) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",530) end
end}
}}
