return {["id"]="405",["total"]=300,["order"]=0,["centerAvailable"]=true,["center"]={480,200,0,0,0,0},["types"]={{0,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"Bommmm-blood"},{200,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"Bommmm-blood"},{400,0,200,200,100,200,0,0,1,0,0,0,0,0,0,"Bommmm-blood"},{0,200,100,200,50,100,0,0,1,0,0,0,0,0,0,"Bommmm-blood"},{973,230,164,166,82,83,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,202,90,81,45,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,283,57,58,28,29,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,341,68,71,34,36,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{371,139,282,295,141,147,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{973,139,43,42,22,21,0,0,1,0,0,0,0,0,0,"2BOSS-fw"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)
if t==1 then R.quake(c,120,9) end
if t==120 then R.quake(c,60,15) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=320,["y"]=200,["begin"]=4,["life"]=160,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9,["fdirection"]=-10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=155,["wscale"]=0.5,["longs"]=300,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=16,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=true,["Invincible"]=true,["segment"]=12,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=90,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)
if t==(115) then R.change(o,"t",3,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(11) then R.change(o,"longs",100,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",30) end
if t==(11) then R.change(o,"wscale",0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeedd",90,30,0,"正比",50) end
if t==(1) then R.change(o,"wscale",0.8,0.2,0,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=288,["y"]=200,["begin"]=1,["life"]=160,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9,["fdirection"]=190,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=155,["wscale"]=0.5,["longs"]=300,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=16,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=true,["Invincible"]=true,["segment"]=12,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=90,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)
if t==(118) then R.change(o,"t",3,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(11) then R.change(o,"longs",100,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",30) end
if t==(1) then R.change(o,"wscale",0.8,0.2,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",90,30,0,"正比",50) end
if t==(11) then R.change(o,"wscale",0,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=512,["y"]=232,["begin"]=9,["life"]=2,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=155,["wscale"]=0.5,["longs"]=120,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=11,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=true,["Invincible"]=true,["segment"]=12,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",40) end
if t==(21) then R.change(o,"wscale",0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeedd",90,30,0,"正比",60) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=true,["x"]=448,["y"]=232,["begin"]=9,["life"]=2,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=155,["wscale"]=0.5,["longs"]=120,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=11,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=true,["Invincible"]=true,["segment"]=12,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",40) end
if t==(21) then R.change(o,"wscale",0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeedd",90,30,0,"正比",60) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=154,["wscale"]=0.3,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",40,30,1,"正比",80) end
if t==(1) then R.change(o,"hscale",0,0.2,1,"正比",1) end
if t==(3) then R.change(o,"alpha",1,0,0,"正比",70) end
if t==(2) then R.change(o,"wscale",0.5,0.3,1,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",0,20,1,"正比",1) end
if t==(2) then R.change(o,"alpha",90,10,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0.5,1,"正比",80) end
if t==(1) then R.change(o,"wscale",0,0.3,1,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=1,["life"]=1,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=160,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",13,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",13,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=121,["life"]=30,["fx"]=480,["fy"]=200,["r"]=130,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=156,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=130,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.9,0,0,"正比",13) end
if t==(1) then R.change(o,"hscale",0.9,0,0,"正比",13) end
if t==(100) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(70) then R.change(o,"colorR",1,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=133,["life"]=70,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=-20,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=156,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=88,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=15,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=70,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=9,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(50) then R.change(o,"sonspeed",15,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(5) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(5) then R.change(o,"wscale",0.5,0,0,"正比",4) end
if t==(5) then R.change(o,"hscale",0.5,0,0,"正比",4) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(6) then R.change(o,"alpha",1,0,0,"正比",21) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=154,["wscale"]=0.3,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",40,30,2,"正比",80) end
if t==(1) then R.change(o,"hscale",0,0.2,1,"正比",1) end
if t==(3) then R.change(o,"alpha",1,0,0,"正比",80) end
if t==(2) then R.change(o,"wscale",0.5,0.3,1,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",0,20,1,"正比",1) end
if t==(2) then R.change(o,"alpha",80,10,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0.5,1,"正比",80) end
if t==(1) then R.change(o,"wscale",0,0.3,1,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=200,["begin"]=135,["life"]=70,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=200,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=156,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=88,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=15,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=70,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=9,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(50) then R.change(o,"sonspeed",15,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(5) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(5) then R.change(o,"wscale",0.5,0,0,"正比",4) end
if t==(5) then R.change(o,"hscale",0.5,0,0,"正比",4) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(6) then R.change(o,"alpha",1,0,0,"正比",21) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=328,["begin"]=21,["life"]=160,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=147,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121) then R.change(o,"t",2,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",60) end
if t==(5) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",25) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",25) end
if t==(40) then R.change(o,"hscale",0,0,0,"正比",20) end
if t==(40) then R.change(o,"wscale",0,0,0,"正比",20) end
if t==(1) then R.change(o,"head",0,420,1,"正比",60) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=40,["begin"]=1,["life"]=121,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=121,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=13,["type"]=91,["wscale"]=13,["hscale"]=13,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(8) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",0,0,0,"正比",13) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=121,["life"]=1,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=90,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",18,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",18,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=1,["life"]=150,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=161,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.1,0,1,"无缝正弦",12) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.1,0,1,"无缝正弦",12) end
if t==(120) then R.change(o,"t",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",2,1,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",4,3,0,"正比",1) end
if t==(55) then R.change(o,"alpha",0,0,0,"正比",5) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.1,0,2,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.1,0,1,"无缝正弦",30) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=154,["wscale"]=0.3,["hscale"]=2.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",0,50,1,"正比",100) end
if t==(1) then R.change(o,"hscale",0,0.2,1,"正比",1) end
if t==(10) then R.change(o,"alpha",1,0,0,"正比",80) end
if t==(2) then R.change(o,"wscale",0.5,0.3,1,"正比",110) end
if t==(1) then R.change(o,"sonspeedd",0,20,1,"正比",1) end
if t==(2) then R.change(o,"alpha",80,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0.5,1,"正比",110) end
if t==(1) then R.change(o,"wscale",0,0.3,1,"正比",1) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=480,["y"]=264,["begin"]=9,["life"]=6,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=45,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=25,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.45,0.1,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.55,0.1,0,"正比",15) end
if t==(16) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeedd",90,0,0,"正比",60) end
if t==(16) then R.change(o,"hscale",0,0,0,"正比",30) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=9,["Bindwithspeedd"]=true,["x"]=352,["y"]=392,["begin"]=31,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=161,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,1,"正比",4) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"正比",4) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeed",2,2,0,"正比",1) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"正比",20) end
if t==(1) then R.change(o,"wscale",0.2,0,1,"正比",20) end
if t==(21) then R.change(o,"hscale",0.1,0,1,"无缝正弦",20) end
if t==(21) then R.change(o,"wscale",0.1,0,2,"无缝正弦",20) end
if t==(41) then R.change(o,"hscale",0,0,0,"正比",20) end
if t==(41) then R.change(o,"wscale",0,0,0,"正比",20) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=133,["life"]=70,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=156,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=88,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=15,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=50,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=9,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(50) then R.change(o,"sonspeed",15,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(5) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(5) then R.change(o,"wscale",0.5,0,0,"正比",4) end
if t==(5) then R.change(o,"hscale",0.5,0,0,"正比",4) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(6) then R.change(o,"alpha",1,0,0,"正比",21) end
end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=553,["begin"]=1,["life"]=121,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=154,["wscale"]=0.3,["hscale"]=2.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",0,30,1,"正比",100) end
if t==(1) then R.change(o,"hscale",0,0.2,1,"正比",1) end
if t==(10) then R.change(o,"alpha",1,0,0,"正比",80) end
if t==(2) then R.change(o,"wscale",0.5,0.3,1,"正比",110) end
if t==(1) then R.change(o,"sonspeedd",0,20,1,"正比",1) end
if t==(2) then R.change(o,"alpha",80,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0.5,1,"正比",110) end
if t==(1) then R.change(o,"wscale",0,0.3,1,"正比",1) end
end},
{["id"]=15,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=328,["begin"]=1,["life"]=150,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=161,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.1,0,1,"无缝正弦",12) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.1,0,1,"无缝正弦",12) end
if t==(120) then R.change(o,"t",3,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",4,3,0,"正比",1) end
if t==(62) then R.change(o,"sonspeedd",90,0,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",2,0.5,0,"正比",60) end
if t==(120) then R.change(o,"alpha",0,0,0,"正比",60) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.04,0,2,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.04,0,1,"无缝正弦",30) end
end},
{["id"]=16,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=104,["begin"]=1,["life"]=120,["fx"]=480,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=156,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=130,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.9,0,0,"正比",6) end
if t==(1) then R.change(o,"hscale",0.9,0,0,"正比",6) end
if t==(100) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(70) then R.change(o,"colorR",1,0,0,"正比",60) end
end}
}}
