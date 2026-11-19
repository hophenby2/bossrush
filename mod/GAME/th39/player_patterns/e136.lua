return {["id"]="136",["total"]=6000,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,215,224,108,112,10,0,1,0,0,0,0,0,0,"bommmmm2"},{430,0,215,224,107,106,0,0,1,0,0,0,0,0,0,"bommmmm2"},{215,0,215,224,108,112,0,0,1,0,0,0,0,0,0,"bommmmm2"},{645,0,215,224,108,112,0,0,1,0,0,0,0,0,0,"bommmmm2"},{0,224,112,112,56,56,10,0,1,0,0,0,0,0,0,"bommmmm2"},{112,224,301,301,150,180,0,0,1,0,0,0,0,0,0,"bommmmm2"},{0,0,100,300,50,300,0,0,1,0,0,0,0,0,0,"TyndallEffect"},{0,0,600,600,300,300,0,0,1,0,0,0,0,0,0,"e-100jianbian"},{0,0,200,200,100,100,0,0,16,1,0,0,0,0,0,"xuanwo-G"},{0,0,200,200,100,100,0,0,16,0,0,0,0,0,0,"xuanwo-G"},{0,0,300,300,150,150,0,0,1,0,0,0,0,0,0,""},{0,0,300,300,150,160,0,0,1,0,0,0,0,0,0,"juqi-2"},{0,0,500,500,250,250,0,0,1,0,0,0,0,0,0,"6-dianqiu"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=424,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=280,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=9999,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=35,["type"]=62,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",1,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/17)*17) then R.change(o,"rdirection",360,0,1,"正比",17) end
if t==(1+math.floor(t/17)*17) then R.change(o,"fdirection",360,0,1,"正比",17) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",13,3,0,"正比",1) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",31) end
if t==(2) then R.change(o,"sonspeed",0.5,0,0,"正比",31) end
if t==(5) then R.change(o,"hscale",1,0,0,"正比",30) end
if t==(5) then R.change(o,"alpha",60,10,0,"正比",20) end
if t==(25) then R.change(o,"alpha",1,0,0,"正比",10) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=424,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=300,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=32,["type"]=153,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",2,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/17)*17) then R.change(o,"rdirection",360,0,1,"正比",17) end
if t==(1+math.floor(t/17)*17) then R.change(o,"fdirection",360,0,1,"正比",17) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",13,3,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",31) end
if t==(2) then R.change(o,"sonspeed",2,0,0,"正比",31) end
if t==(5) then R.change(o,"alpha",66,0,0,"正比",10) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",31) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=552,["begin"]=1,["life"]=6000,["fx"]=470,["fy"]=340,["r"]=350,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=153,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=5,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.3,["hscale"]=0.3},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",3,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/300)*300) then R.change(o,"fdirection",18,0,1,"无缝正弦",300) end
if t==(1+math.floor(t/300)*300) then R.change(o,"rdirection",18,0,1,"无缝正弦",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",11,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",90) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",90) end
if t==(5) then R.change(o,"alpha",99,0,0,"正比",30) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeedd",200,0,2,"正比",90) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=552,["begin"]=1,["life"]=6000,["fx"]=470,["fy"]=340,["r"]=350,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=91,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=5,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.5,["hscale"]=0.5},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",3,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/300)*300) then R.change(o,"rdirection",18,0,1,"无缝正弦",300) end
if t==(1+math.floor(t/300)*300) then R.change(o,"fdirection",18,0,1,"无缝正弦",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",17,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",60) end
if t==(5) then R.change(o,"alpha",50,20,0,"正比",30) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",200,0,2,"正比",60) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=31,["t"]=9999,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=42,["type"]=153,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",8,4,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",41) end
if t==(2) then R.change(o,"sonspeed",2,0,0,"正比",41) end
if t==(5) then R.change(o,"alpha",77,0,0,"正比",10) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",41) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=672,["y"]=552,["begin"]=1,["life"]=6000,["fx"]=500,["fy"]=340,["r"]=380,["rdirection"]=300,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=50,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=110,["type"]=153,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=5,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.3,["hscale"]=0.3},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",3,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(61+math.floor(t/300)*300) then R.change(o,"fdirection",24,0,1,"无缝正弦",300) end
if t==(61+math.floor(t/300)*300) then R.change(o,"rdirection",24,0,1,"无缝正弦",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",12,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",90) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",90) end
if t==(5) then R.change(o,"alpha",99,0,0,"正比",30) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeedd",200,0,1,"正比",90) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=704,["y"]=552,["begin"]=1,["life"]=6000,["fx"]=490,["fy"]=340,["r"]=350,["rdirection"]=310,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=91,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=1,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=3,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.5,["hscale"]=0.5},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",3,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(61+math.floor(t/300)*300) then R.change(o,"rdirection",24,0,1,"无缝正弦",300) end
if t==(61+math.floor(t/300)*300) then R.change(o,"fdirection",24,0,1,"无缝正弦",300) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",16,0,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",60) end
if t==(5) then R.change(o,"alpha",50,20,0,"正比",30) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",40) end
if t==(1) then R.change(o,"sonspeedd",200,0,1,"正比",60) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=1,["life"]=6000,["fx"]=480,["fy"]=350,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=4,["hscale"]=4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=40,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=10,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(0) and (o.statusFrame or 0)==(1) then R.change(o,"t",13,0,0,"正比",1) end
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"head",200,0,2,"正比",60) end
if t==(40) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",20,0,0,"正比",40) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=152,["wscale"]=0,["hscale"]=0,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if (o.status or 0)==(1) and (o.statusFrame or 0)==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",6,0,0,"正比",40) end
if t==(1) then R.change(o,"hscale",6,0,0,"正比",40) end
if t==(1) then R.change(o,"alpha",0,0,0,"正比",30) end
end}
}}
