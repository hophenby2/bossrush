return {["id"]="65802",["total"]=6000,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,100,100,50,50,10,0,1,0,0,0,0,0,0,"lanjiguang"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=3601,["life"]=2400,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=6,["wscale"]=0,["longs"]=100,["alpha"]=60,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=150,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",20) end
if t==(31) then R.change(o,"wscale",0.9,0.2,0,"正比",30) end
if t==(31) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeedd",0,10,1,"正比",90) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=1141,["life"]=2200,["fx"]=-99998,["fy"]=360,["r"]=150,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=55,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/360)*360) then R.change(o,"rdirection",60,0,1,"正比",360) end
if t==(2000) then R.change(o,"tiao",3,0,0,"正比",1) end
if t==(2000) then R.change(o,"range",360,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/333)*333) then R.change(o,"head",1333,0,1,"正比",333) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=1200,["life"]=1800,["fx"]=-99998,["fy"]=360,["r"]=260,["rdirection"]=300,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=55,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(2000) then R.change(o,"range",360,0,0,"正比",1) end
if t==(2000) then R.change(o,"tiao",3,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"rdirection",60,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/333)*333) then R.change(o,"head",1333,0,1,"正比",333) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=392,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=10,["rdirection"]=30,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=5,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=152,["wscale"]=0,["hscale"]=0.18,["colorR"]=133,["colorG"]=188,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.5,0,0,"正比",30) end
if t==(1) then R.change(o,"r",120,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.13,0,0,"正比",15) end
if t==(31) then R.change(o,"wscale",0.2,0,0,"正比",12) end
if t==(31) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(61) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=288,["y"]=424,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=10,["rdirection"]=30,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=5,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=152,["wscale"]=0,["hscale"]=0.18,["colorR"]=133,["colorG"]=188,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.5,0,0,"正比",30) end
if t==(1) then R.change(o,"r",120,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.13,0,0,"正比",15) end
if t==(31) then R.change(o,"wscale",0.2,0,0,"正比",12) end
if t==(131) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(61) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=72,["begin"]=1321,["life"]=2000,["fx"]=-99998,["fy"]=360,["r"]=150,["rdirection"]=300,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=55,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(2000) then R.change(o,"tiao",3,0,0,"正比",1) end
if t==(2000) then R.change(o,"range",360,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"rdirection",60,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/333)*333) then R.change(o,"head",1333,0,1,"正比",333) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=288,["y"]=488,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=10,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=152,["wscale"]=0,["hscale"]=0.18,["colorR"]=133,["colorG"]=188,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.5,0,0,"正比",30) end
if t==(1) then R.change(o,"r",120,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.13,0,0,"正比",15) end
if t==(31) then R.change(o,"wscale",0.2,0,0,"正比",12) end
if t==(31) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(61) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=1381,["life"]=1800,["fx"]=-99998,["fy"]=360,["r"]=260,["rdirection"]=330,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=55,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(2000) then R.change(o,"tiao",3,0,0,"正比",1) end
if t==(2000) then R.change(o,"range",360,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"rdirection",60,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/333)*333) then R.change(o,"head",1333,0,1,"正比",333) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=false,["x"]=288,["y"]=520,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=10,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=152,["wscale"]=0,["hscale"]=0.18,["colorR"]=133,["colorG"]=188,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.5,0,0,"正比",30) end
if t==(1) then R.change(o,"r",120,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.13,0,0,"正比",15) end
if t==(31) then R.change(o,"wscale",0.2,0,0,"正比",12) end
if t==(31) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(61) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=168,["begin"]=421,["life"]=366,["fx"]=480,["fy"]=360,["r"]=150,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=55,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(5) then R.change(o,"tiao",5,0,0,"正比",1) end
if t==(5) then R.change(o,"range",300,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/333)*333) then R.change(o,"head",1333,0,1,"正比",333) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=false,["x"]=320,["y"]=392,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=10,["rdirection"]=30,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=5,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=152,["wscale"]=0,["hscale"]=0.18,["colorR"]=133,["colorG"]=188,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.5,0,0,"正比",30) end
if t==(1) then R.change(o,"r",120,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.13,0,0,"正比",15) end
if t==(31) then R.change(o,"wscale",0.2,0,0,"正比",12) end
if t==(31) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(61) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=200,["begin"]=621,["life"]=366,["fx"]=480,["fy"]=360,["r"]=260,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=55,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(5) then R.change(o,"tiao",5,0,0,"正比",1) end
if t==(5) then R.change(o,"range",300,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/333)*333) then R.change(o,"head",1333,0,1,"正比",333) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=false,["x"]=320,["y"]=488,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=10,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=152,["wscale"]=0,["hscale"]=0.18,["colorR"]=133,["colorG"]=188,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.5,0,0,"正比",30) end
if t==(1) then R.change(o,"r",120,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.13,0,0,"正比",15) end
if t==(31) then R.change(o,"wscale",0.2,0,0,"正比",12) end
if t==(31) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(61) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=40,["begin"]=3801,["life"]=1801,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=60,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=93,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=133,["colorG"]=133,["colorB"]=133,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222,0,1,"正比",22) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=8,["begin"]=3801,["life"]=1801,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=60,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=92,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=133,["colorG"]=133,["colorB"]=133,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222,0,1,"正比",22) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=224,["y"]=168,["begin"]=1,["life"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=152,["wscale"]=0.1,["longs"]=250,["alpha"]=70,["Ray"]="Line",["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",55) end
if t==(60) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(60) then R.change(o,"wscale",0.3,0,0,"正比",12) end
if t==(90) then R.change(o,"sonspeed",16,0,0,"正比",20) end
if t==(87) then R.change(o,"longs",0,0,0,"正比",22) end
if t==(120) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(90) then R.change(o,"alpha",55,0,0,"正比",15) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=224,["y"]=200,["begin"]=1,["life"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=31,["wscale"]=0.6,["longs"]=250,["alpha"]=55,["Ray"]="Line",["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=1,["colorG"]=88,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",55) end
if t==(60) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(60) then R.change(o,"wscale",1.7,0,0,"正比",12) end
if t==(90) then R.change(o,"sonspeed",16,0,0,"正比",20) end
if t==(90) then R.change(o,"longs",0,0,0,"正比",20) end
if t==(120) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(90) then R.change(o,"alpha",88,0,0,"正比",5) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=352,["y"]=168,["begin"]=1,["life"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=152,["wscale"]=0.1,["longs"]=250,["alpha"]=70,["Ray"]="Line",["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",55) end
if t==(60) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(60) then R.change(o,"wscale",0.3,0,0,"正比",12) end
if t==(90) then R.change(o,"sonspeed",16,0,0,"正比",20) end
if t==(87) then R.change(o,"longs",0,0,0,"正比",22) end
if t==(120) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(90) then R.change(o,"alpha",55,0,0,"正比",15) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=352,["y"]=200,["begin"]=1,["life"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=31,["wscale"]=0.6,["longs"]=250,["alpha"]=55,["Ray"]="Line",["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=1,["colorG"]=88,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",55) end
if t==(60) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(60) then R.change(o,"wscale",1.7,0,0,"正比",12) end
if t==(90) then R.change(o,"sonspeed",16,0,0,"正比",20) end
if t==(90) then R.change(o,"longs",0,0,0,"正比",20) end
if t==(120) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(90) then R.change(o,"alpha",88,0,0,"正比",5) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=3400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=193,["type"]=18,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/15)*15) then R.change(o,"sonspeedd",60,0,1,"正比",1) end
if t==(14+math.floor(t/15)*15) then R.change(o,"sonspeed",10,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180,0,2,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=232,["begin"]=1,["life"]=5360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=15,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",2,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",2,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=136,["begin"]=2,["life"]=359,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=55,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=99,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"head",360,0,1,"正比",90) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=181,["life"]=3320,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=360,["fdirection"]=30,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=193,["type"]=18,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/15)*15) then R.change(o,"sonspeedd",60,0,2,"正比",1) end
if t==(14+math.floor(t/15)*15) then R.change(o,"sonspeed",10,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180,0,1,"正比",1) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=352,["y"]=232,["begin"]=1,["life"]=5360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=15,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",2,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",2,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=352,["y"]=136,["begin"]=2,["life"]=359,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=55,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=99,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"head",360,0,2,"正比",90) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=264,["begin"]=1,["life"]=5360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=15,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=133,["colorG"]=200,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.6,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.2,["hscale"]=0.2},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",88,0,0,"正比",12) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=352,["y"]=264,["begin"]=1,["life"]=5360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=15,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=113,["colorG"]=200,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.6,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.2,["hscale"]=0.2},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",88,0,0,"正比",12) end
end},
{["id"]=0,["parentid"]=2,["x"]=352,["y"]=360,["begin"]=2601,["life"]=200,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=12,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",30) end
if (o.maskEntered or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",30) end
if (o.maskEntered or 0)==(1) then R.change(o,"alpha",66,0,0,"正比",5) end
end},
{["id"]=1,["parentid"]=2,["x"]=384,["y"]=360,["begin"]=2601,["life"]=200,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=13,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",30) end
if (o.maskEntered or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",30) end
if (o.maskEntered or 0)==(1) then R.change(o,"alpha",66,0,0,"正比",5) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=608,["y"]=424,["begin"]=850,["life"]=2300,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=30,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=6,["wscale"]=0,["longs"]=100,["alpha"]=100,["Ray"]="Ray",["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",120) end
if t==(2000) then R.change(o,"wscale",0,0,0,"正比",300) end
if t==(2100) then R.change(o,"alpha",60,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=264,["begin"]=300,["life"]=550,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=35,["t"]=60,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=79,["wscale"]=0.75,["hscale"]=0.75,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,0.3,0,"正比",120) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=640,["y"]=488,["begin"]=3600,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2200,["type"]=15,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=0.1,["yscale"]=0.1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"xscale",2,0,0,"正比",400) end
if t==(1) then R.change(o,"yscale",2,0,0,"正比",400) end
if t==(1) then R.change(o,"fdirection",360,0,2,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"sonspeed",3.5,0,0,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"sonspeedd",360,0,1,"正比",1200) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=2401,["life"]=3600,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=267,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360,0,2,"正比",120) end
if t==(1+math.floor(t/8)*8) then R.change(o,"t",1,0,0,"正比",1) end
if t==(6+math.floor(t/8)*8) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=761,["life"]=1600,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=48,["t"]=60,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(301+math.floor(t/360)*360) then R.change(o,"fdirection",60,0,1,"正比",360) end
if t==(720) then R.change(o,"t",40,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"sonspeedd",90,0,1,"正比",180) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=296,["begin"]=300,["life"]=550,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=65,["t"]=60,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=31,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=672,["y"]=552,["begin"]=6000,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=120,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"sonspeed",1.5,0,0,"正比",60) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=264,["begin"]=1000,["life"]=1,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=21,["t"]=90,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"sonspeed",1.7,0.3,0,"正比",20) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=648,["begin"]=3301,["life"]=2100,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=31,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90,0,1,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=761,["life"]=1600,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=48,["t"]=60,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(301+math.floor(t/360)*360) then R.change(o,"fdirection",60,0,1,"正比",360) end
if t==(720) then R.change(o,"t",40,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"sonspeedd",90,0,2,"正比",180) end
end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=456,["begin"]=1500,["life"]=900,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=30,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=58,["y"]=72,["begin"]=400,["life"]=2201,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=20,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=60,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=false,["x"]=64,["y"]=136,["begin"]=500,["life"]=2091,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=15,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=155,["colorG"]=200,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"r",30,0,1,"正比",1) end
if t==(31+math.floor(t/60)*60) then R.change(o,"r",30,0,2,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=12,["parentid"]=2,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=false,["x"]=96,["y"]=136,["begin"]=500,["life"]=2091,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=14,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=188,["colorG"]=211,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"r",30,0,1,"正比",1) end
if t==(31+math.floor(t/60)*60) then R.change(o,"r",30,0,2,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=13,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=424,["begin"]=841,["life"]=1,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2800,["type"]=134,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1e-05,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(300+math.floor(t/360)*360) then R.change(o,"sonspeedd",60,0,1,"正比",360) end
end},
{["id"]=14,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=456,["begin"]=1500,["life"]=900,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=30,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=15,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=552,["begin"]=2401,["life"]=3600,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=267,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360,0,2,"正比",120) end
if t==(1+math.floor(t/8)*8) then R.change(o,"t",1,0,0,"正比",1) end
if t==(6+math.floor(t/8)*8) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=16,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=520,["begin"]=2401,["life"]=3600,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=267,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360,0,2,"正比",120) end
if t==(1+math.floor(t/8)*8) then R.change(o,"t",1,0,0,"正比",1) end
if t==(6+math.floor(t/8)*8) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=17,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=552,["begin"]=2401,["life"]=3600,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=267,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=134,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360,0,2,"正比",120) end
if t==(1+math.floor(t/8)*8) then R.change(o,"t",1,0,0,"正比",1) end
if t==(6+math.floor(t/8)*8) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=18,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=616,["begin"]=3501,["life"]=2100,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=22,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end}
}}
