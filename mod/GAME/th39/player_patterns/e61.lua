return {["id"]="61",["total"]=120,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,200,200,100,100,0,0,5,2,0,0,0,0,0,"zybz01BLUE"},{200,0,200,200,100,100,0,0,5,2,0,0,0,0,0,"zybz01BLUE"},{400,0,200,200,100,100,0,0,5,2,0,0,0,0,0,"zybz01BLUE"},{600,0,200,200,100,100,0,0,5,2,0,0,0,0,0,"zybz01BLUE"},{0,0,85,100,44,50,0,0,1,0,0,0,0,0,0,"bzxy-JULI"},{85,0,85,100,45,50,0,0,1,0,0,0,0,0,0,"bzxy-JULI"},{170,0,85,100,45,50,0,0,1,0,0,0,0,0,0,"bzxy-JULI"},{255,0,85,100,45,50,0,0,1,0,0,0,0,0,0,"bzxy-JULI"},{340,0,85,100,45,50,0,0,1,0,0,0,0,0,0,"bzxy-JULI"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=48,["type"]=152,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(12) then R.change(o,"type",1,0,1,"正比",1) end
if t==(24) then R.change(o,"type",1,0,1,"正比",1) end
if t==(36) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11) then R.change(o,"Blend",0,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=1,["life"]=12,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=12,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=156,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2) then R.change(o,"type",1,0,1,"正比",1) end
if t==(3) then R.change(o,"type",1,0,1,"正比",1) end
if t==(4) then R.change(o,"type",1,0,1,"正比",1) end
if t==(9) then R.change(o,"type",1,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"hscale",0,0,0,"无缝正弦",60) end
if t==(1) then R.change(o,"sonspeed",1,1,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,360,0,"正比",1) end
if t==(1) then R.change(o,"head",0,300,1,"正比",90) end
if t==(40) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeedd",100,100,1,"正比",90) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=11,["life"]=12,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=4,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=156,["wscale"]=0.4,["hscale"]=-0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2) then R.change(o,"type",1,0,1,"正比",1) end
if t==(3) then R.change(o,"type",1,0,1,"正比",1) end
if t==(4) then R.change(o,"type",1,0,1,"正比",1) end
if t==(9) then R.change(o,"type",1,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1,1,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,360,0,"正比",1) end
if t==(1) then R.change(o,"head",0,300,2,"正比",90) end
if t==(40) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeedd",100,100,2,"正比",90) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=91,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",66,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.4,0,0,"正比",10) end
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",21,0,0,"正比",1) end
if t==(11) then R.change(o,"wscale",0.2,0,0,"正比",6) end
if t==(11) then R.change(o,"hscale",3,0,0,"正比",10) end
end}
}}
