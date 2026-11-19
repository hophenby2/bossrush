return {["id"]="320",["total"]=4800,["order"]=0,["centerAvailable"]=true,["center"]={480,274,0,0,0,0},["types"]={{250,0,250,250,125,130,0,0,7,6,0,0,0,0,0,""},{220,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{250,0,250,250,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,200,200,100,100,0,0,10,2,0,0,0,0,0,""},{0,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"doll"},{25,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{0,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{50,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=1,["life"]=4800,["fx"]=490,["fy"]=250,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=15,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=147,["wscale"]=0.3,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=233,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1.2,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=1,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"fdirection",360,0,1,"正比",20) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(2) then R.change(o,"t",999999,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"t",10,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"t",999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.3,0,0,"正比",60) end
if t==(35) then R.change(o,"colorB",0,0,0,"正比",20) end
if t==(40) then R.change(o,"alpha",20,0,0,"正比",20) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",60) end
end}
}}
