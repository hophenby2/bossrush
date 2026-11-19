return {["id"]="47",["total"]=12000,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,100,180,50,90,0,0,1,0,0,0,0,0,0,"marisa2"},{0,180,100,180,50,90,0,0,1,0,0,0,0,0,0,"marisa2"},{100,0,80,80,40,40,0,0,9,2,0,0,0,0,0,"marisa2"},{180,0,80,80,40,40,0,0,9,2,0,0,0,0,0,"marisa2"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=505,["y"]=400,["begin"]=2,["life"]=11999,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.9,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/200)*200) then R.change(o,"sonspeedd",20,0,2,"正比",25) end
if t==(25+math.floor(t/200)*200) then R.change(o,"sonspeedd",140,0,2,"正比",50) end
if t==(75+math.floor(t/200)*200) then R.change(o,"sonspeedd",40,0,2,"正比",50) end
if t==(125+math.floor(t/200)*200) then R.change(o,"sonspeedd",140,0,2,"正比",50) end
if t==(175+math.floor(t/200)*200) then R.change(o,"sonspeedd",20,0,2,"正比",25) end
if t==(51+math.floor(t/200)*200) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",200) end
if t==(51+math.floor(t/200)*200) then R.change(o,"hscale",0.05,0,2,"无缝正弦",200) end
if t==(50+math.floor(t/200)*200) then R.change(o,"alpha",100,0,0,"正比",10) end
if t==(160+math.floor(t/200)*200) then R.change(o,"alpha",0,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",-0.8,0,0,"正比",18) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",18) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=456,["y"]=400,["begin"]=2,["life"]=11999,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.9,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/200)*200) then R.change(o,"sonspeedd",20,0,1,"正比",25) end
if t==(25+math.floor(t/200)*200) then R.change(o,"sonspeedd",140,0,1,"正比",50) end
if t==(75+math.floor(t/200)*200) then R.change(o,"sonspeedd",40,0,1,"正比",50) end
if t==(125+math.floor(t/200)*200) then R.change(o,"sonspeedd",140,0,1,"正比",50) end
if t==(175+math.floor(t/200)*200) then R.change(o,"sonspeedd",20,0,1,"正比",25) end
if t==(51+math.floor(t/200)*200) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",200) end
if t==(51+math.floor(t/200)*200) then R.change(o,"hscale",-0.05,0,2,"无缝正弦",200) end
if t==(50+math.floor(t/200)*200) then R.change(o,"alpha",100,0,0,"正比",10) end
if t==(160+math.floor(t/200)*200) then R.change(o,"alpha",0,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",-0.8,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",-0.8,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=442,["y"]=413,["begin"]=1,["life"]=12000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12000,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.7,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/400)*400) then R.change(o,"sonspeedd",20,0,1,"正比",50) end
if t==(50+math.floor(t/400)*400) then R.change(o,"sonspeedd",140,0,1,"正比",100) end
if t==(150+math.floor(t/400)*400) then R.change(o,"sonspeedd",40,0,1,"正比",100) end
if t==(250+math.floor(t/400)*400) then R.change(o,"sonspeedd",140,0,1,"正比",100) end
if t==(350+math.floor(t/400)*400) then R.change(o,"sonspeedd",20,0,1,"正比",50) end
if t==(100+math.floor(t/400)*400) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",400) end
if t==(100+math.floor(t/400)*400) then R.change(o,"hscale",-0.05,0,2,"无缝正弦",400) end
if t==(250+math.floor(t/400)*400) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(50+math.floor(t/400)*400) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",-0.5,0,0,"正比",60) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",12) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",12) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(13) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=521,["y"]=413,["begin"]=1,["life"]=12000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12000,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.7,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(31) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/400)*400) then R.change(o,"sonspeedd",20,0,2,"正比",50) end
if t==(50+math.floor(t/400)*400) then R.change(o,"sonspeedd",140,0,2,"正比",100) end
if t==(150+math.floor(t/400)*400) then R.change(o,"sonspeedd",40,0,2,"正比",100) end
if t==(250+math.floor(t/400)*400) then R.change(o,"sonspeedd",140,0,2,"正比",100) end
if t==(350+math.floor(t/400)*400) then R.change(o,"sonspeedd",20,0,2,"正比",50) end
if t==(100+math.floor(t/400)*400) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",400) end
if t==(100+math.floor(t/400)*400) then R.change(o,"hscale",-0.05,0,2,"无缝正弦",400) end
if t==(50+math.floor(t/400)*400) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(250+math.floor(t/400)*400) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.5,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",-0.5,0,0,"正比",30) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",12) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",12) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(13) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=315,["begin"]=1,["life"]=11999,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(2) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/200)*200) then R.change(o,"sonspeedd",360,0,1,"正比",200) end
if t==(51+math.floor(t/200)*200) then R.change(o,"wscale",-0.05,0,1,"无缝正弦",200) end
if t==(51+math.floor(t/200)*200) then R.change(o,"hscale",-0.05,0,1,"无缝正弦",200) end
if t==(55+math.floor(t/200)*200) then R.change(o,"alpha",0,0,0,"正比",5) end
if t==(150+math.floor(t/200)*200) then R.change(o,"alpha",100,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",-0.8,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",-0.8,0,0,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=406,["begin"]=1,["life"]=11999,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(2) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/200)*200) then R.change(o,"sonspeedd",360,0,1,"正比",200) end
if t==(51+math.floor(t/200)*200) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",200) end
if t==(51+math.floor(t/200)*200) then R.change(o,"hscale",-0.05,0,2,"无缝正弦",200) end
if t==(50+math.floor(t/200)*200) then R.change(o,"alpha",100,0,0,"正比",5) end
if t==(155+math.floor(t/200)*200) then R.change(o,"alpha",0,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",-0.8,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",-0.8,0,0,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=294,["begin"]=1,["life"]=11999,["fx"]=-99998,["fy"]=315,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(2) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeedd",360,0,1,"正比",100) end
if t==(25+math.floor(t/100)*100) then R.change(o,"wscale",-0.05,0,1,"无缝正弦",100) end
if t==(25+math.floor(t/100)*100) then R.change(o,"hscale",-0.05,0,1,"无缝正弦",100) end
if t==(25+math.floor(t/100)*100) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(75+math.floor(t/100)*100) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.35,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",-0.35,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=262,["begin"]=1,["life"]=11999,["fx"]=-99998,["fy"]=405,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(2) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeedd",360,0,1,"正比",100) end
if t==(25+math.floor(t/100)*100) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",100) end
if t==(25+math.floor(t/100)*100) then R.change(o,"hscale",-0.05,0,2,"无缝正弦",100) end
if t==(25+math.floor(t/100)*100) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(75+math.floor(t/100)*100) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",-0.5,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=198,["begin"]=1,["life"]=11999,["fx"]=-99998,["fy"]=435,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(2) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",360,0,2,"正比",120) end
if t==(25+math.floor(t/120)*120) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",120) end
if t==(25+math.floor(t/120)*120) then R.change(o,"hscale",-0.05,0,2,"无缝正弦",120) end
if t==(30+math.floor(t/120)*120) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(90+math.floor(t/120)*120) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",-0.5,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=166,["begin"]=1,["life"]=11999,["fx"]=-99998,["fy"]=435,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=155,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(2) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",360,0,1,"正比",120) end
if t==(25+math.floor(t/120)*120) then R.change(o,"wscale",-0.05,0,2,"无缝正弦",120) end
if t==(25+math.floor(t/120)*120) then R.change(o,"hscale",-0.05,0,2,"无缝正弦",120) end
if t==(30+math.floor(t/120)*120) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(90+math.floor(t/120)*120) then R.change(o,"alpha",0,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.4,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",-0.4,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"hscale",0,0,0,"正比",15) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(16) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=153,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeed",0.1,0,1,"无缝正弦",100) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"head",210,0,0,"正比",12) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"head",180,0,0,"正比",12) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12000,["type"]=153,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeed",0.1,0,1,"无缝正弦",100) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"head",150,0,0,"正比",12) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"head",180,0,0,"正比",12) end
end}
}}
