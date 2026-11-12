-- 离线展开：b841.xna；事件均已编译为Lua条件和调用。
return {id="841",total=3000,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)
if t==(10) then R.sound("enep03") end
end,globalEvents=function(c,t,R)
if t==1 then R.quake(c,120,10) end
end,types={{0,0,60,54,30,27,7,0},{60,0,64,62,32,31,7,0},{124,0,56,53,28,27,7,0},{180,0,18,24,9,12,1,0},{180,27,17,25,9,13,1,0},{207,24,11,11,5,5,1,0},{0,62,194,194,97,97,50,0},{194,62,192,192,96,96,0,0},{344,256,86,132,43,120,10,0},{430,256,86,132,43,120,10,0},{0,256,344,344,172,172,1,0},{0,600,392,392,196,196,1,0},{344,399,135,168,67,84,1,0},{459,0,45,45,22,18,2,0},{505,0,45,45,22,18,2,0},{550,0,45,45,22,18,2,0},{595,0,45,45,22,18,2,0},{459,45,45,45,22,16,2,0},{505,45,45,45,22,16,2,0},{550,45,45,45,22,16,2,0},{595,45,45,45,22,16,2,0},{460,90,45,45,22,22,3,0},{505,90,45,45,22,22,3,0},{550,90,45,45,22,22,3,0},{595,90,45,45,22,22,3,0},{460,135,45,45,22,22,3,0},{505,135,45,45,22,22,3,0},{550,135,45,45,22,22,3,0},{595,135,45,45,22,22,3,0},{373,0,21,31,10,15,2,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=64,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=174,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",18.0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",18.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=174,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",18.0,0,0,"正比",90) end
if t==(1) then R.change(o,"hscale",18.0,0,0,"正比",90) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",90) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=61,["life"]=2940,["fx"]=315,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=246,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=125,["colorB"]=15,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=60,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",31) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",31) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",31) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=224,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",24.0,0,0,"正比",90) end
if t==(1) then R.change(o,"hscale",24.0,0,0,"正比",90) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",90) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=224,["wscale"]=33,["hscale"]=33,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=64,["begin"]=1,["life"]=1040,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=239,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",3.0,0,0,"正比",30) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",24) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",24) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=128,["begin"]=1,["life"]=1040,["fx"]=-99998,["fy"]=-120,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=72,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=330,["type"]=224,["wscale"]=4,["hscale"]=4,["colorR"]=255,["colorG"]=10,["colorB"]=50,["alpha"]=68,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=200,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",800.0,0,1,"正比",600) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=96,["begin"]=1,["life"]=1040,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=192,["y"]=160,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=241,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=65,["colorB"]=11,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeedd",0.0,13.0,1,"正比",10) end
if t==(20) then R.change(o,"alpha",1.0,0,0,"正比",40) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",18.0,0,0,"正比",10) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=192,["y"]=192,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=241,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=51,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeedd",0.0,13.0,1,"正比",10) end
if t==(30) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",18.0,0,0,"正比",15) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=64,["begin"]=1050,["life"]=850,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=239,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=110,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,2,"正弦",34) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",3.0,0,0,"正比",30) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",24) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",24) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",30) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=128,["begin"]=1050,["life"]=850,["fx"]=-99998,["fy"]=-120,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=109,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=330,["type"]=224,["wscale"]=4,["hscale"]=4,["colorR"]=255,["colorG"]=10,["colorB"]=50,["alpha"]=68,["head"]=110,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=200,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,2,"正弦",34) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",800.0,0,2,"正比",600) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=96,["begin"]=1050,["life"]=850,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=110,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,2,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=448,["y"]=160,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=241,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=65,["colorB"]=11,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeedd",0.0,13.0,1,"正比",10) end
if t==(20) then R.change(o,"alpha",1.0,0,0,"正比",40) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",18.0,0,0,"正比",10) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=448,["y"]=192,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=241,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=51,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeedd",0.0,13.0,1,"正比",10) end
if t==(20) then R.change(o,"alpha",1.0,0,0,"正比",40) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",18.0,0,0,"正比",15) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=1951,["life"]=1050,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=239,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/32)*32) then R.change(o,"r",290.0,0,2,"正弦",31) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",4.0,0,0,"正比",30) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",24) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",24) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",30) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=1951,["life"]=1050,["fx"]=-99998,["fy"]=-120,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=330,["type"]=224,["wscale"]=4.5,["hscale"]=4.5,["colorR"]=255,["colorG"]=10,["colorB"]=50,["alpha"]=68,["head"]=110,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=200,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/32)*32) then R.change(o,"r",290.0,0,2,"正弦",31) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",800.0,0,1,"正比",600) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=1951,["life"]=1050,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/32)*32) then R.change(o,"r",290.0,0,2,"正弦",31) end
end,Sonevents=function(o,t,R)

end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=11,["Bindwithspeedd"]=true,["x"]=320,["y"]=384,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=241,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=65,["colorB"]=11,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeedd",0.0,13.0,1,"正比",10) end
if t==(20) then R.change(o,"alpha",1.0,0,0,"正比",40) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",18.0,0,0,"正比",10) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=11,["Bindwithspeedd"]=true,["x"]=320,["y"]=416,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=241,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=11,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeedd",0.0,13.0,1,"正比",10) end
if t==(20) then R.change(o,"alpha",1.0,0,0,"正比",40) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",18.0,0,0,"正比",15) end
end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=192,["y"]=256,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=235,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"head",360.0,0,2,"正比",600) end
end,Sonevents=function(o,t,R)

end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=448,["y"]=256,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=235,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"head",360.0,0,1,"正比",600) end
end,Sonevents=function(o,t,R)

end},
{["id"]=17,["parentid"]=1,["Binding"]=false,["bindid"]=11,["Bindwithspeedd"]=true,["x"]=352,["y"]=352,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=235,["wscale"]=0.75,["hscale"]=0.75,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"head",30.0,0,2,"正比",600) end
end,Sonevents=function(o,t,R)

end},
{["id"]=18,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=0,["begin"]=91,["life"]=1040,["fx"]=-99998,["fy"]=510,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=145,["colorB"]=65,["alpha"]=1,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=19,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=0,["begin"]=1140,["life"]=850,["fx"]=-99998,["fy"]=510,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=145,["colorB"]=65,["alpha"]=88,["head"]=110,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",310.0,0,2,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=20,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=2041,["life"]=960,["fx"]=-99998,["fy"]=510,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=65,["alpha"]=88,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/32)*32) then R.change(o,"r",290.0,0,2,"正弦",31) end
end,Sonevents=function(o,t,R)

end},
{["id"]=21,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=151,["life"]=2850,["fx"]=-99998,["fy"]=500,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=18,["colorB"]=1,["alpha"]=88,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=10,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/32)*32) then R.change(o,"r",290.0,0,2,"正弦",31) end
end,Sonevents=function(o,t,R)

end},
{["id"]=22,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=160,["y"]=288,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=72,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=11,["type"]=236,["wscale"]=0.7,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/6)*6) then R.change(o,"wscale",0.3,0,1,"正比",4) end
if t==(5+math.floor(t/6)*6) then R.change(o,"wscale",0.3,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.1,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",15) end
if t==(1) then R.change(o,"colorR",100.0,0,0,"正比",15) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.3,0,1,"正比",15) end
if t==(5) then R.change(o,"Blend",0.0,0,0,"固定",1) end
end},
{["id"]=23,["parentid"]=1,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=false,["x"]=480,["y"]=288,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=109,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=11,["type"]=236,["wscale"]=0.7,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/6)*6) then R.change(o,"wscale",0.3,0,1,"正比",4) end
if t==(5+math.floor(t/6)*6) then R.change(o,"wscale",0.3,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.1,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",15) end
if t==(1) then R.change(o,"colorR",100.0,0,0,"正比",15) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.3,0,1,"正比",15) end
if t==(5) then R.change(o,"Blend",0.0,0,0,"固定",1) end
end},
{["id"]=24,["parentid"]=1,["Binding"]=false,["bindid"]=11,["Bindwithspeedd"]=false,["x"]=384,["y"]=352,["begin"]=3,["life"]=2998,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=236,["wscale"]=0.9,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/6)*6) then R.change(o,"wscale",0.3,0,1,"正比",4) end
if t==(5+math.floor(t/6)*6) then R.change(o,"wscale",0.3,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.1,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",15) end
if t==(1) then R.change(o,"colorR",100.0,0,0,"正比",15) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.3,0,1,"正比",15) end
if t==(5) then R.change(o,"Blend",0.0,0,0,"固定",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=320,["begin"]=60,["life"]=1010,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=430,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=10,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",250.0,0,1,"正弦",34) end
if t==(221) then R.change(o,"t",6.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"Outdispel",1.0,0,0,"固定",1) end
if t==(1) then R.change(o,"head",300.0,100.0,2,"正比",300) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=160,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-70,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=4,["hscale"]=1,["colorR"]=255,["colorG"]=245,["colorB"]=111,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=10,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=224,["begin"]=1100,["life"]=810,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=430,["type"]=246,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=10,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",250.0,0,2,"正弦",34) end
if t==(361) then R.change(o,"t",3.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"Outdispel",1.0,0,0,"固定",1) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=192,["begin"]=1,["life"]=1150,["fx"]=-99998,["fy"]=-5,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=17,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=215,["colorB"]=125,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",210.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=224,["begin"]=1,["life"]=1150,["fx"]=-99998,["fy"]=-5,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=17,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=215,["colorB"]=125,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",210.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=1051,["life"]=950,["fx"]=-99998,["fy"]=-5,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=17,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=215,["colorB"]=125,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",210.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1051,["life"]=950,["fx"]=-99998,["fy"]=-5,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=17,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=215,["colorB"]=125,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",210.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=1951,["life"]=1050,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=430,["type"]=246,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=10,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",250.0,0,2,"正弦",34) end
if t==(241) then R.change(o,"t",3.0,0,0,"正比",1) end
if t==(481) then R.change(o,"t",2.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"Outdispel",1.0,0,0,"固定",1) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=192,["begin"]=1951,["life"]=950,["fx"]=-99998,["fy"]=-5,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=17,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=215,["colorB"]=125,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",210.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=224,["begin"]=1951,["life"]=950,["fx"]=-99998,["fy"]=-5,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=17,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=215,["colorB"]=125,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",210.0,0,1,"正弦",34) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=128,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=550,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=4,["hscale"]=0.5,["colorR"]=255,["colorG"]=245,["colorB"]=111,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=10,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=224,["begin"]=80,["life"]=1030,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=430,["type"]=246,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=10,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",250.0,0,2,"正弦",34) end
if t==(361) then R.change(o,"t",3.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"Outdispel",1.0,0,0,"固定",1) end
end},
{["id"]=12,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=320,["begin"]=1100,["life"]=800,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=430,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=10,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",250.0,0,1,"正弦",34) end
if t==(261) then R.change(o,"t",6.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"Outdispel",1.0,0,0,"固定",1) end
if t==(1) then R.change(o,"head",300.0,100.0,1,"正比",300) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=13,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=1900,["life"]=1101,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=430,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=70,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=10,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/35)*35) then R.change(o,"r",250.0,0,1,"正弦",34) end
if t==(361) then R.change(o,"t",6.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"Outdispel",1.0,0,0,"固定",1) end
if t==(1) then R.change(o,"head",300.0,100.0,2,"正比",300) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=14,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=256,["y"]=384,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=225,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeedd",0.0,15.0,1,"正比",1) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",15) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
end},
{["id"]=15,["parentid"]=2,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=352,["y"]=384,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=225,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=15,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeedd",0.0,15.0,1,"正比",1) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",15) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
end},
{["id"]=16,["parentid"]=2,["Binding"]=false,["bindid"]=12,["Bindwithspeedd"]=true,["x"]=384,["y"]=384,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=225,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=15,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeedd",0.0,15.0,1,"正比",1) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",15) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=352,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=16,["rdirection"]=96,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=224,["wscale"]=0.2,["hscale"]=3,["colorR"]=255,["colorG"]=205,["colorB"]=15,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",80.0,0,0,"正比",61) end
if t==(1+math.floor(t/15)*15) then R.change(o,"hscale",0.2,0,1,"正弦",14) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=352,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=16,["rdirection"]=96,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=225,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=155,["colorB"]=15,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",61) end
if t==(1+math.floor(t/15)*15) then R.change(o,"wscale",0.05,0,1,"正弦",14) end
if t==(1+math.floor(t/15)*15) then R.change(o,"hscale",0.05,0,1,"正弦",14) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=352,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=16,["rdirection"]=96,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=224,["wscale"]=0.2,["hscale"]=3,["colorR"]=255,["colorG"]=205,["colorB"]=15,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",80.0,0,0,"正比",61) end
if t==(1+math.floor(t/15)*15) then R.change(o,"hscale",0.2,0,1,"正弦",14) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=352,["begin"]=1,["life"]=3000,["fx"]=-99998,["fy"]=-99998,["r"]=16,["rdirection"]=96,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=155,["colorB"]=15,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",61) end
if t==(1+math.floor(t/15)*15) then R.change(o,"wscale",0.01,0,1,"正弦",14) end
if t==(1+math.floor(t/15)*15) then R.change(o,"hscale",0.01,0,1,"正弦",14) end
end,Sonevents=function(o,t,R)

end}
}}
