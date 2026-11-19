return {["id"]="302",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,200,0,0,0,0},["types"]={},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=9999999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=3,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"r",0,10,1,"无缝正弦",60) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(2) then R.change(o,"rdirection",130,30,1,"正比",58) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0.7,0,0,"正比",10) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(30) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0.7,0,0,"正比",10) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(30) then R.change(o,"hscale",0.1,0,0,"正比",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"rdirection",0,360,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",1,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(60) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",30) end
end}
}}
