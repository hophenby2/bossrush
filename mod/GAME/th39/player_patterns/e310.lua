return {["id"]="310",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,230,0,0,0,0},["types"]={{600,0,200,200,100,100,0,0,7,6,0,0,0,0,0,"reisen(1)"},{0,0,350,350,175,175,0,0,1,0,0,0,0,0,0,"circle"},{0,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{200,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{400,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{600,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{288,511,326,333,163,166,0,0,1,0,0,0,0,0,0,"5BOSS"},{0,133,257,257,128,128,0,0,1,0,0,0,0,0,0,"5BOSS"},{571,121,392,390,196,196,0,0,1,0,0,0,0,0,0,"5BOSS"},{0,390,288,288,144,144,0,0,1,0,0,0,0,0,0,"5BOSS"},{288,221,283,283,140,140,0,0,1,0,0,0,0,0,0,"5BOSS"},{257,0,221,221,111,111,0,0,1,0,0,0,0,0,0,"5BOSS"},{0,0,100,400,50,40,0,0,1,0,0,0,0,0,0,"5-machinegun1"},{300,0,200,400,100,40,0,0,1,0,0,0,0,0,0,"5-machinegun1"},{700,0,200,400,100,40,0,0,1,0,0,0,0,0,0,"5-machinegun1"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=1,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=164,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",90,0,1,"正比",5) end
if t==(1) then R.change(o,"fdirection",90,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",20) end
if t==(1) then R.change(o,"wscale",-0.4,0,0,"正比",20) end
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",6,2,0,"正比",180) end
if t==(130) then R.change(o,"sonaspeed",6,2,0,"正比",130) end
if t==(130) then R.change(o,"head",40,0,2,"正比",230) end
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360,0,2,"正比",180) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=480,["y"]=72,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=1,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=164,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",90,0,1,"正比",5) end
if t==(1) then R.change(o,"fdirection",90,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",20) end
if t==(1) then R.change(o,"wscale",-0.4,0,0,"正比",20) end
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",6,2,0,"正比",180) end
if t==(130) then R.change(o,"sonaspeed",6,2,0,"正比",130) end
if t==(130) then R.change(o,"head",40,0,1,"正比",230) end
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360,0,1,"正比",180) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=5,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=352,["y"]=296,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=6,["wscale"]=0.3,["hscale"]=1,["colorR"]=255,["colorG"]=135,["colorB"]=1,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.3,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",4,2,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0.2,0,0,"正比",21) end
if t==(1) then R.change(o,"hscale",0.6,0.2,0,"正比",1) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=233,["r"]=130,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=54,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=5,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",5,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=233,["r"]=130,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=67,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=5,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",5,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=false,["x"]=384,["y"]=296,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=6,["wscale"]=0.3,["hscale"]=1,["colorR"]=255,["colorG"]=135,["colorB"]=1,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.3,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",4,2,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0.2,0,0,"正比",31) end
if t==(1) then R.change(o,"hscale",0.6,0.2,0,"正比",1) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=233,["r"]=130,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=37,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=5,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",5,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=416,["y"]=296,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=6,["wscale"]=0.3,["hscale"]=1,["colorR"]=255,["colorG"]=135,["colorB"]=1,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.3,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",3,2,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0.2,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",0.6,0.2,0,"正比",1) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=233,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",40,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",1,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"t",7,0,0,"正比",1) end
if t==(50+math.floor(t/90)*90) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(2) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(3) then R.change(o,"alpha",1,0,0,"正比",60) end
end}
}}
