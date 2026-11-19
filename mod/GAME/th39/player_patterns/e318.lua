return {["id"]="318",["total"]=4800,["order"]=0,["centerAvailable"]=true,["center"]={480,274,0,0,0,0},["types"]={{250,0,250,250,125,130,0,0,7,6,0,0,0,0,0,""},{220,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{250,0,250,250,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,200,200,100,100,0,0,10,2,0,0,0,0,0,""},{0,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"doll"},{25,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{0,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{50,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=147,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"hscale",0.05,0,1,"无缝正弦",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"wscale",0.05,0,1,"无缝正弦",60) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(2) then R.change(o,"t",10,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",360,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",60,20,0,"正比",20) end
if t==(100) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1+math.floor(t/18)*18) then R.change(o,"wscale",0,0,0,"无缝正弦",18) end
if t==(1+math.floor(t/18)*18) then R.change(o,"hscale",0,0,0,"无缝正弦",18) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=147,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"hscale",0.05,0,1,"无缝正弦",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"wscale",0.05,0,1,"无缝正弦",60) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if (o.statusFrame or 0)==(5) and (o.status or 0)==(2) then R.change(o,"t",10,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",360,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",60,20,0,"正比",20) end
if t==(100) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0,0,0,"无缝正弦",12) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0,0,0,"无缝正弦",12) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=160,["wscale"]=0.3,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"hscale",0.05,0,1,"无缝正弦",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"wscale",0.05,0,1,"无缝正弦",60) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if (o.statusFrame or 0)==(5) and (o.status or 0)==(2) then R.change(o,"t",10,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",360,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",60,20,0,"正比",20) end
if t==(100) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"head",0,360,1,"正比",120) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0,0,"无缝正弦",30) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=160,["wscale"]=0.3,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"hscale",0.05,0,1,"无缝正弦",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"wscale",0.05,0,1,"无缝正弦",60) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if (o.statusFrame or 0)==(5) and (o.status or 0)==(2) then R.change(o,"t",10,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",360,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",60,20,0,"正比",20) end
if t==(100) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"head",0,360,1,"正比",120) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0,0,"无缝正弦",30) end
end}
}}
