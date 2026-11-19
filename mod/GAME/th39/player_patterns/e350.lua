return {["id"]="350",["total"]=9200,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=125,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2.5,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1.8,0.2,0,"正比",2) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=155,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2.5,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1.8,0.2,0,"正比",2) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=520,["begin"]=1,["life"]=9200,["fx"]=-99999,["fy"]=-99999,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=10,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=125,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"colorB",1,0,0,"正比",40) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",40) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=188,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2.5,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1.8,0.2,0,"正比",2) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2.5,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1.8,0.2,0,"正比",2) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=416,["y"]=520,["begin"]=1,["life"]=9200,["fx"]=-99999,["fy"]=-99999,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=15,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=155,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"colorG",1,0,0,"正比",40) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",40) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=1,["life"]=9200,["fx"]=-99999,["fy"]=-99999,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=13,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=188,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"colorB",1,0,0,"正比",40) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",40) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=544,["y"]=520,["begin"]=1,["life"]=9200,["fx"]=-99999,["fy"]=-99999,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=11,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",40) end
if t==(1) then R.change(o,"colorG",1,0,0,"正比",40) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",40) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=188,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1,0.2,0,"正比",2) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=188,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1,0.2,0,"正比",2) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=188,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1,0.2,0,"正比",2) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=1,["life"]=9200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=188,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(3) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2,0.5,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",1,0.2,0,"正比",2) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if (o.status or 0)==(2) and (o.statusFrame or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
if t>(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if t>(0) then R.change(o,"fy","中心",0,0,"固定",1) end
end}
}}
