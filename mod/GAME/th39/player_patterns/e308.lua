return {["id"]="308",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,200,0,0,0,0},["types"]={},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=616,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=130,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=145,["wscale"]=0.15,["hscale"]=0.15,["colorR"]=255,["colorG"]=66,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=60,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.1,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.1,0,1,"无缝正弦",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",17,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",9999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",0,0,0,"无缝正弦",13) end
if t==(90) then R.change(o,"sonspeed",1,0,0,"正比",60) end
if t==(31) then R.change(o,"sonspeedd",0,70,1,"正比",120) end
if t==(1) then R.change(o,"head",0,1240,1,"正比",170) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=648,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=130,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=5,["wscale"]=0.1,["hscale"]=1.3,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=70,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=60,["r"]=100,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=13,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.05,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.05,0,1,"无缝正弦",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",15,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,40,1,"正比",60) end
if t==(40) then R.change(o,"alpha",1,0,0,"正比",20) end
end}
}}
