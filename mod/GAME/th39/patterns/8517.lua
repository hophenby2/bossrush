return {["id"]="8517",["total"]=1300,["order"]=0,["centerAvailable"]=true,["center"]={480,10,0,0,0,0},["types"]={},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=296,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=40,["fdirection"]=30,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.2,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1100,["type"]=147,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=520,["begin"]=1,["life"]=500,["fx"]=-99998,["fy"]=-99998,["r"]=50,["rdirection"]=225,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=180,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=151,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",60,0,2,"正比",180) end
if t==(66) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=320,["y"]=552,["begin"]=1,["life"]=1300,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=73,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.4,0,1,"无缝正弦",60) end
if t==(1+math.floor(t/30)*30) then R.change(o,"t",3,0,0,"正比",1) end
if t==(20+math.floor(t/30)*30) then R.change(o,"t",9000,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"type",149,0,0,"正比",1) end
if t==(26+math.floor(t/30)*30) then R.fire(o) end
if t==(30+math.floor(t/30)*30) then R.change(o,"t",3,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"type",71,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"colorG",0,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"colorR",80,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"hscale",1,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"wscale",0.6,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"hscale",0.6,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5,0,0,"正比",240) end
if t==(120) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=800,["y"]=296,["begin"]=61,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=40,["fdirection"]=150,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1.2,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1100,["type"]=147,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=384,["y"]=520,["begin"]=1,["life"]=500,["fx"]=-99998,["fy"]=-99998,["r"]=50,["rdirection"]=-45,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=180,["fdirection"]=170,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=151,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",60,0,1,"正比",180) end
if t==(66) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=384,["y"]=552,["begin"]=61,["life"]=1240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=73,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.4,0,1,"无缝正弦",60) end
if t==(1+math.floor(t/30)*30) then R.change(o,"t",3,0,0,"正比",1) end
if t==(20+math.floor(t/30)*30) then R.change(o,"t",9000,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"type",149,0,0,"正比",1) end
if t==(26+math.floor(t/30)*30) then R.fire(o) end
if t==(30+math.floor(t/30)*30) then R.change(o,"t",3,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"type",71,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"colorG",0,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"colorR",80,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"hscale",1,0,0,"正比",1) end
if t==(24+math.floor(t/30)*30) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"wscale",0.6,0,0,"正比",1) end
if t==(27+math.floor(t/30)*30) then R.change(o,"hscale",0.6,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5,0,0,"正比",240) end
if t==(120) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end}
}}
