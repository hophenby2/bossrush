return {["id"]="307",["total"]=4800,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,180,220,90,110,0,0,7,6,0,0,0,0,0,"tei3"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=999999,["type"]=152,["wscale"]=1.2,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.fire(o) end
end,Sonevents=function(o,t,R)
if (o.statusFrame or 0)==(1+math.floor(t/240)*240) and (o.status or 0)==(0) then R.change(o,"sonspeedd",360,0,1,"正比",240) end
if (o.statusFrame or 0)==(60+math.floor(t/240)*240) and (o.status or 0)==(0) then R.change(o,"alpha",0,0,0,"固定",1) end
if (o.statusFrame or 0)==(180+math.floor(t/240)*240) and (o.status or 0)==(0) then R.change(o,"alpha",100,0,0,"固定",1) end
if (o.statusFrame or 0)>(1) and (o.status or 0)==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"sonspeed",40,0,0,"正比",5) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"alpha",0,0,0,"正比",15) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"Afterimage",1,0,0,"正比",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"wscale",1.2,0,0,"正比",15) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.statusFrame or 0)==(16) and (o.status or 0)==(1) then R.change(o,"life",1,0,0,"固定",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"wscale",1,0,0,"正比",15) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"hscale",1,0,0,"正比",15) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"alpha",100,0,0,"正比",15) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"fx","中心",0,0,"固定",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"fy","中心",0,0,"固定",1) end
if (o.statusFrame or 0)==(1) and (o.status or 0)==(0) then R.change(o,"fy",64,0,2,"固定",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=552,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=152,["wscale"]=3,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=11,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.statusFrame or 0)==(3) and (o.status or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)>(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"sonspeed",20,0,0,"正比",5) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"alpha",0,0,0,"正比",10) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"Afterimage",1,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",1.2,0,0,"正比",10) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",10) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(20) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",6) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",6) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",6) end
if t==(1) then R.change(o,"sonspeed",0,0,0,"正比",15) end
if t==(15) then R.change(o,"Afterimage",0,0,0,"正比",1) end
end}
}}
