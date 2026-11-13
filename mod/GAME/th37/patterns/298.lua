-- 离线展开：b298.xna；事件均已编译为Lua条件和调用。
return {id="298",total=6000,centerAvailable=true,center={224,-50,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,50,50,25,25,5,0},{50,0,50,50,25,25,5,0},{100,0,50,50,25,25,5,0},{150,0,50,50,25,25,5,0}},emitters={
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=235,["begin"]=1,["life"]=209,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=125,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",180.0,0,1,"正弦",240) end
if t==(1) then R.change(o,"speed",1.5,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.2,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",7.0,3.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.4,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=160,["begin"]=210,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,1,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=160,["begin"]=210,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=60,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,1,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=160,["begin"]=210,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=120,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,1,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=160,["begin"]=210,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=180,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,1,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=160,["begin"]=210,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=240,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,1,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=160,["begin"]=210,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=300,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,1,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=235,["begin"]=810,["life"]=400,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=133,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",180.0,0,1,"正弦",240) end
if t==(1) then R.change(o,"speed",1.5,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.0,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",7.0,3.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.4,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=45,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=135,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=190,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=235,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=280,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=325,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",2.0,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=235,["begin"]=391,["life"]=212,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=52,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",180.0,0,2,"正弦",240) end
if t==(1) then R.change(o,"speed",1.5,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.2,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",7.0,3.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.4,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=17,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=160,["begin"]=600,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=18,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=160,["begin"]=600,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=60,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=19,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=160,["begin"]=600,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=120,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=20,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=160,["begin"]=600,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=180,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=21,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=160,["begin"]=600,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=240,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=22,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=160,["begin"]=600,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=300,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",90.0,0,2,"正弦",180) end
if t==(1) then R.change(o,"speed",1.7,0,0,"正比",30) end
if t==(30) then R.change(o,"speed",0.5,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end}
}}
