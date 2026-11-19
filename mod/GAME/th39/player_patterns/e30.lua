return {["id"]="30",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,36,179,18,169,0,0,1,0,0,0,0,0,0,"marisashoot2"},{0,0,34,179,17,169,0,0,1,0,0,0,0,0,0,"marisashoot1"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=8,["type"]=153,["wscale"]=1.3,["hscale"]=0.4,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=120,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正比",13) end
if t==(6) and (o.status or 0)==(0) then R.change(o,"wscale",0.5,0,0,"正比",7) end
if t==(1) and (o.status or 0)==(0) then R.change(o,"hscale",0.4,0.2,0,"正弦",36) end
if t==(1) and (o.status or 0)==(1) then R.change(o,"wscale",0.3,0,0,"固定",1) end
if t==(1) and (o.status or 0)==(1) then R.change(o,"hscale",0.15,0,0,"固定",1) end
if t==(6) and (o.status or 0)==(1) then R.change(o,"wscale",0.15,0,0,"正比",7) end
if t==(1) and (o.status or 0)==(1) then R.change(o,"hscale",0,0.1,0,"正比",36) end
end}
}}
