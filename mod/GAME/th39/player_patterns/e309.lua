return {["id"]="309",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,200,0,0,0,0},["types"]={{0,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{200,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{400,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"},{600,0,200,200,100,100,0,0,5,4,0,0,0,0,0,"zybz01white"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,1,"无缝正弦",130) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"无缝正弦",130) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=130,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=147,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=60,["r"]=100,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.1,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.1,0,1,"无缝正弦",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",8,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",0.05,0,1,"无缝正弦",13) end
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",0.05,0,1,"无缝正弦",13) end
if t==(60) then R.change(o,"sonspeed",0.5,0.2,0,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",0,70,1,"正比",120) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=481,["y"]=136,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=110,["type"]=153,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=66,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",7,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(64) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1) then R.change(o,"alpha",20,5,0,"正比",40) end
if t==(50) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(41) then R.change(o,"type",1,0,1,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=130,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=145,["wscale"]=0.15,["hscale"]=0.15,["colorR"]=255,["colorG"]=66,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=60,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.1,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.1,0,1,"无缝正弦",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",7,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",9999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",0,0,0,"无缝正弦",13) end
if t==(90) then R.change(o,"sonspeed",1,0,0,"正比",60) end
if t==(31) then R.change(o,"sonspeedd",0,70,1,"正比",120) end
if t==(1) then R.change(o,"head",0,1240,1,"正比",170) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=552,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=130,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=5,["wscale"]=0.1,["hscale"]=1.3,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=70,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=60,["r"]=100,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=13,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.05,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.05,0,1,"无缝正弦",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",13,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,40,1,"正比",60) end
if t==(40) then R.change(o,"alpha",1,0,0,"正比",20) end
end}
}}
