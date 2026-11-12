-- 离线展开：b291.xna；事件均已编译为Lua条件和调用。
return {id="291",total=6000,centerAvailable=true,center={224,-50,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,50,50,25,25,5,0},{50,0,50,50,25,25,5,0},{100,0,50,50,25,25,5,0},{150,0,50,50,25,25,5,0}},emitters={
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=235,["begin"]=2610,["life"]=209,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=125,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=68,["y"]=192,["begin"]=1760,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=100,["y"]=96,["begin"]=900,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=32,["begin"]=440,["life"]=130,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",20.0,0,2,"正弦",90) end
if t==(90) then R.change(o,"speed",0.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=30,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.5,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",6.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=132,["y"]=160,["begin"]=120,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.5,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",6.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=324,["y"]=160,["begin"]=240,["life"]=100,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.5,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",6.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=32,["begin"]=453,["life"]=130,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",20.0,0,1,"正弦",90) end
if t==(90) then R.change(o,"speed",0.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=32,["begin"]=465,["life"]=130,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",20.0,0,1,"正弦",90) end
if t==(90) then R.change(o,"speed",0.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=100,["y"]=32,["begin"]=478,["life"]=130,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",20.0,0,2,"正弦",90) end
if t==(90) then R.change(o,"speed",0.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=356,["y"]=32,["begin"]=491,["life"]=130,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speedd",20.0,0,2,"正弦",90) end
if t==(90) then R.change(o,"speed",0.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=356,["y"]=224,["begin"]=928,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=132,["y"]=160,["begin"]=956,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=324,["y"]=160,["begin"]=984,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=356,["y"]=96,["begin"]=1012,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=68,["y"]=160,["begin"]=1040,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=100,["y"]=224,["begin"]=1068,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=17,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=96,["begin"]=1096,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=18,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=224,["begin"]=1124,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=19,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=388,["y"]=160,["begin"]=1152,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=20,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=224,["begin"]=1180,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=21,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=96,["begin"]=1208,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=22,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=292,["y"]=224,["begin"]=1236,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=23,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=164,["y"]=96,["begin"]=1264,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=24,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=260,["y"]=160,["begin"]=1292,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=25,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=196,["y"]=160,["begin"]=1320,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=26,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=132,["y"]=192,["begin"]=1773,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=27,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=196,["y"]=192,["begin"]=1786,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=28,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=260,["y"]=192,["begin"]=1822,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=29,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=324,["y"]=192,["begin"]=1835,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=30,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=388,["y"]=192,["begin"]=1848,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=31,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=68,["y"]=192,["begin"]=1980,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=32,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=132,["y"]=192,["begin"]=1993,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=33,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=196,["y"]=192,["begin"]=2006,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=34,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=260,["y"]=192,["begin"]=2044,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=35,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=324,["y"]=192,["begin"]=2057,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=36,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=388,["y"]=192,["begin"]=2070,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=37,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=68,["y"]=192,["begin"]=2205,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=38,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=132,["y"]=192,["begin"]=2218,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=39,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=196,["y"]=192,["begin"]=2231,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=40,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=260,["y"]=192,["begin"]=2267,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=41,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=324,["y"]=192,["begin"]=2280,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=42,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=388,["y"]=192,["begin"]=2297,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.7,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.0,0,0,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=43,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=68,["y"]=128,["begin"]=2420,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=44,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=132,["y"]=128,["begin"]=2433,["life"]=107,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=45,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=196,["y"]=128,["begin"]=2446,["life"]=94,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=46,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=260,["y"]=128,["begin"]=2482,["life"]=58,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=47,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=324,["y"]=128,["begin"]=2495,["life"]=45,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=48,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=388,["y"]=128,["begin"]=2508,["life"]=29,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.6,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",15) end
if t==(8) then R.change(o,"alpha",1.0,0,0,"正比",7) end
if t==(11) then R.change(o,"hscale",0.2,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",8) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",10) end
end},
{["id"]=49,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=2821,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=50,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=2821,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=60,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=51,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=2821,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=120,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=52,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=2821,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=180,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=53,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=2821,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=240,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=54,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=2821,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=300,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=55,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=235,["begin"]=3060,["life"]=219,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=125,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=56,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=57,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=45,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=58,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=59,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=135,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=60,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=190,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=61,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=235,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=62,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=280,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
{["id"]=63,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=228,["y"]=160,["begin"]=3260,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=325,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=232,["wscale"]=0.8,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=5,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
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
end}
}}
