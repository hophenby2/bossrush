return {["id"]="311",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,230,0,0,0,0},["types"]={{600,0,200,200,100,100,0,0,7,6,0,0,0,0,0,"reisen(1)"},{0,0,350,350,175,175,0,0,1,0,0,0,0,0,0,"circle"},{0,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{200,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{400,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{600,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{288,511,326,333,163,166,0,0,1,0,0,0,0,0,0,"5BOSS"},{0,133,257,257,128,128,0,0,1,0,0,0,0,0,0,"5BOSS"},{571,121,392,390,196,196,0,0,1,0,0,0,0,0,0,"5BOSS"},{0,390,288,288,144,144,0,0,1,0,0,0,0,0,0,"5BOSS"},{288,221,283,283,140,140,0,0,1,0,0,0,0,0,0,"5BOSS"},{257,0,221,221,111,111,0,0,1,0,0,0,0,0,0,"5BOSS"},{0,0,100,400,50,40,0,0,1,0,0,0,0,0,0,"5-machinegun1"},{300,0,200,400,100,40,0,0,1,0,0,0,0,0,0,"5-machinegun1"},{700,0,200,400,100,40,0,0,1,0,0,0,0,0,0,"5-machinegun1"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=233,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"life",40,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"life",1,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"t",7,0,0,"正比",1) end
if t==(50+math.floor(t/90)*90) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(2) then R.change(o,"alpha",88,0,0,"正比",1) end
if t==(3) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=584,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=91,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=1,["colorB"]=125,["alpha"]=20,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/130)*130) then R.change(o,"hscale",0.2,0,1,"无缝正弦",130) end
if t==(1+math.floor(t/130)*130) then R.change(o,"wscale",0.2,0,1,"无缝正弦",130) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=161,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=155,["colorG"]=155,["colorB"]=155,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"head",10,0,2,"正比",4) end
if t==(5+math.floor(t/90)*90) then R.change(o,"head",100,0,1,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"alpha",0,0,0,"正比",13) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=161,["wscale"]=0.66,["hscale"]=0.66,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"head",10,0,1,"正比",4) end
if t==(5+math.floor(t/90)*90) then R.change(o,"head",100,0,2,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"alpha",0,0,0,"正比",13) end
end}
}}
