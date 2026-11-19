return {["id"]="991",["total"]=6000,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,215,224,108,112,10,0,1,0,0,0,0,0,0,"bommmmm2"},{430,0,215,224,107,106,0,0,1,0,0,0,0,0,0,"bommmmm2"},{215,0,215,224,108,112,0,0,1,0,0,0,0,0,0,"bommmmm2"},{645,0,215,224,108,112,0,0,1,0,0,0,0,0,0,"bommmmm2"},{0,224,112,112,56,56,10,0,1,0,0,0,0,0,0,"bommmmm2"},{112,224,301,301,150,180,0,0,1,0,0,0,0,0,0,"bommmmm2"},{0,0,100,300,50,300,0,0,1,0,0,0,0,0,0,"TyndallEffect"},{0,0,600,600,300,300,0,0,1,0,0,0,0,0,0,"e-100jianbian"},{0,0,200,200,100,100,0,0,16,1,0,0,0,0,0,"xuanwo-BG"},{0,0,200,200,100,100,0,0,16,0,0,0,0,0,0,"xuanwo-G"},{0,0,300,300,150,150,0,0,1,0,0,0,0,0,0,"luoxuan-G"},{0,0,300,300,150,160,0,0,1,0,0,0,0,0,0,"juqi-2"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=159,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=20,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",1,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(2) then R.change(o,"alpha",20,0,0,"正比",120) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"alpha",0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=424,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=400,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=9999,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=35,["type"]=33,["wscale"]=1,["hscale"]=6,["colorR"]=122,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",1,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/17)*17) then R.change(o,"rdirection",360,0,1,"正比",17) end
if t==(1+math.floor(t/17)*17) then R.change(o,"fdirection",360,0,1,"正比",17) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",15,5,0,"正比",1) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",31) end
if t==(2) then R.change(o,"sonspeed",0.5,0,0,"正比",31) end
if t==(5) then R.change(o,"hscale",1,0,0,"正比",30) end
if t==(5) then R.change(o,"alpha",60,30,0,"正比",20) end
if t==(25) then R.change(o,"alpha",1,0,0,"正比",10) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=424,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=400,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=153,["wscale"]=2,["hscale"]=2,["colorR"]=211,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",1,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/13)*13) then R.change(o,"rdirection",360,0,1,"正比",13) end
if t==(1+math.floor(t/13)*13) then R.change(o,"fdirection",360,0,1,"正比",13) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",18,5,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",31) end
if t==(2) then R.change(o,"sonspeed",2,0,0,"正比",31) end
if t==(5) then R.change(o,"alpha",100,0,0,"正比",10) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",31) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=552,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=350,["rdirection"]=300,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=190,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=91,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=66,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.5,["hscale"]=0.5},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",6,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/7)*7) then R.change(o,"rdirection",25,0,2,"无缝正弦",7) end
if t==(1+math.floor(t/7)*7) then R.change(o,"fdirection",25,0,2,"无缝正弦",7) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",11,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",90) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",90) end
if t==(5) then R.change(o,"alpha",30,20,0,"正比",60) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeedd",200,0,2,"正比",90) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=552,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=350,["rdirection"]=300,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=190,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=122,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.3,["hscale"]=0.3},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",5,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/7)*7) then R.change(o,"rdirection",22,0,2,"无缝正弦",7) end
if t==(1+math.floor(t/7)*7) then R.change(o,"fdirection",22,0,2,"无缝正弦",7) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",11,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",90) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",90) end
if t==(5) then R.change(o,"alpha",99,0,0,"正比",60) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",90) end
if t==(1) then R.change(o,"head",480,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeedd",200,0,2,"正比",90) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=552,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=350,["rdirection"]=300,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=190,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=91,["wscale"]=2,["hscale"]=2,["colorR"]=66,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.5,["hscale"]=0.5},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",2,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/7)*7) then R.change(o,"rdirection",26,0,2,"无缝正弦",7) end
if t==(1+math.floor(t/7)*7) then R.change(o,"fdirection",26,0,2,"无缝正弦",7) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",17,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",60) end
if t==(5) then R.change(o,"alpha",50,20,0,"正比",50) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",200,0,2,"正比",60) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=328,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=153,["wscale"]=0,["hscale"]=0,["colorR"]=211,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.fire(o) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",30,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",44,0,0,"正比",5) end
if t==(31) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",2,1,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",2,1,0,"正比",2) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=false,["x"]=352,["y"]=360,["begin"]=1,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12,["type"]=153,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=122,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=6,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.3,["hscale"]=0.3},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",480,0,1,"正比",100) end
if t==(1) then R.change(o,"r",0,0,0,"正比",100) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",12) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=161,["wscale"]=4,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=30,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=1,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/45)*45) then R.change(o,"head",360,0,1,"正比",45) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",8,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(16) then R.change(o,"alpha",0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",31) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",31) end
if t==(1) then R.change(o,"head",60,0,1,"正比",30) end
if t==(1) then R.change(o,"alpha",55,0,0,"正比",15) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=162,["wscale"]=3,["hscale"]=3,["colorR"]=122,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=30,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/45)*45) then R.change(o,"head",200,0,2,"正比",45) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",50,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"head",480,0,2,"正比",60) end
if t==(40) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",44,0,0,"正比",40) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=3,["hscale"]=3,["colorR"]=188,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=120,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=30,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/45)*45) then R.change(o,"head",300,0,1,"正比",45) end
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",15,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"head",240,0,2,"正比",60) end
if t==(40) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",33,0,0,"正比",40) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=6,["hscale"]=6,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=110,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=130,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=20,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",13,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"head",200,0,2,"正比",60) end
if t==(40) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",44,0,0,"正比",40) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=4,["hscale"]=4,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=290,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=130,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=20,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",13,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"head",200,0,2,"正比",60) end
if t==(40) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",44,0,0,"正比",40) end
end}
}}
