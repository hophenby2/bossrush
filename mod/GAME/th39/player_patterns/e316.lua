return {["id"]="316",["total"]=4800,["order"]=0,["centerAvailable"]=true,["center"]={480,275,0,0,0,0},["types"]={{250,0,250,250,125,130,0,0,7,6,0,0,0,0,0,""},{220,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{250,0,250,250,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,200,200,100,100,0,0,10,2,0,0,0,0,0,""},{0,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"doll"},{25,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{0,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{50,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=248,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=157,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",7,0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",55) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if t==(16) then R.change(o,"hscale",0.05,0,2,"无缝正弦",30) end
if t==(16) then R.change(o,"wscale",0.05,0,1,"无缝正弦",30) end
if t==(46) then R.change(o,"hscale",0.05,0,2,"无缝正弦",30) end
if t==(46) then R.change(o,"wscale",0.05,0,1,"无缝正弦",30) end
if t==(1) then R.change(o,"head",20,0,2,"正比",60) end
if t==(60) then R.change(o,"alpha",0,0,0,"正比",13) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=475,["y"]=56,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=157,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.fire(o) end
end,Sonevents=function(o,t,R)
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"sonspeedd",15,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"sonspeed",30,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"alpha",100,0,0,"正比",45) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"Afterimage",1,0,0,"正比",1) end
if (o.statusFrame or 0)==(10) and (o.status or 0)==(0) then R.change(o,"hscale",0.9,0,0,"正比",40) end
if (o.statusFrame or 0)==(10) and (o.status or 0)==(0) then R.change(o,"wscale",0.9,0,0,"正比",40) end
if (o.statusFrame or 0)==(70) and (o.status or 0)==(0) then R.change(o,"life",1,0,0,"固定",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"hscale",0.5,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"wscale",0.5,0,0,"正比",1) end
if (o.statusFrame or 0)==(2) and (o.status or 0)==(0) then R.change(o,"sonspeedd",480,0,1,"正比",60) end
if (o.statusFrame or 0)==(2) and (o.status or 0)==(0) then R.change(o,"sonspeed",1,0,0,"正比",60) end
if (o.statusFrame or 0)==(2) and (o.status or 0)==(0) then R.change(o,"head",360,0,1,"正比",60) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"head",280,0,0,"正比",1) end
if (o.statusFrame or 0)==(60) and (o.status or 0)==(0) then R.change(o,"alpha",0,0,0,"固定",10) end
if (o.statusFrame or 0)==(60) and (o.status or 0)==(0) then R.change(o,"sonspeed",0,0,0,"固定",10) end
end}
}}
