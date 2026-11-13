-- 离线展开：b735.xna；事件均已编译为Lua条件和调用。
return {id="735",total=6200,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,90,127,45,63,20,0},{91,0,90,127,45,63,20,0},{182,0,90,127,45,63,20,0},{270,0,26,45,12,22,4,0},{296,0,36,46,18,23,4,0},{332,0,39,51,19,25,5,0},{371,0,21,31,10,15,2,0},{0,127,257,256,128,128,40,0},{257,127,257,256,128,128,40,0},{263,383,89,81,44,40,1,0},{185,383,78,136,39,68,1,0},{0,383,185,157,82,78,1,0},{0,700,90,100,45,50,15,0},{380,600,200,200,100,100,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=224,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=228,["wscale"]=21,["hscale"]=21,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",26.0,0,0,"正比",240) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=237,["y"]=96,["begin"]=1,["life"]=6200,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=15,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(181+math.floor(t/240)*240) then R.change(o,"speed",-3.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",720.0,0,1,"正比",240) end
if t==(1+math.floor(t/240)*240) then R.change(o,"speed",3.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"speed",-3.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"speed",3.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=0,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=238,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",5) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",5) end
if t==(50) then R.change(o,"colorR",100.0,0,0,"正比",50) end
if t==(60) then R.change(o,"alpha",0.0,0,0,"正比",40) end
if t==(50) then R.change(o,"colorG",20.0,0,0,"正比",50) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=0,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=19,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=232,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=2,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,30.0,1,"固定",1) end
if t==(10) then R.change(o,"sonspeed",0.0,0,0,"正比",40) end
if t==(1) then R.change(o,"head",0.0,360.0,1,"正比",50) end
if t==(1) then R.change(o,"type",1.0,1.0,1,"正比",1) end
if t==(15) then R.change(o,"wscale",0.0,0,0,"正比",35) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=480,["y"]=0,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=228,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",2.5,0,0,"正比",10) end
if t==(1) then R.change(o,"hscale",2.5,0,0,"正比",10) end
if t==(1) then R.change(o,"colorG",200.0,0,2,"正比",10) end
if t==(5) then R.change(o,"alpha",0.0,0,0,"正比",5) end
if t==(1) then R.change(o,"colorR",200.0,0,2,"正比",10) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=288,["y"]=64,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=240,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",5) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",5) end
if t==(70) then R.change(o,"colorR",100.0,0,0,"正比",50) end
if t==(80) then R.change(o,"alpha",0.0,0,0,"正比",40) end
if t==(70) then R.change(o,"colorG",20.0,0,0,"正比",50) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=416,["y"]=64,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=228,["wscale"]=4,["hscale"]=4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",3.5,0,0,"正比",10) end
if t==(1) then R.change(o,"hscale",3.5,0,0,"正比",10) end
if t==(1) then R.change(o,"colorG",200.0,0,2,"正比",10) end
if t==(5) then R.change(o,"alpha",0.0,0,0,"正比",5) end
if t==(1) then R.change(o,"colorR",200.0,0,2,"正比",10) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=224,["y"]=64,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=15,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=150,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=232,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=1,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,30.0,1,"固定",1) end
if t==(10) then R.change(o,"sonspeed",0.0,0,0,"正比",40) end
if t==(1) then R.change(o,"head",0.0,360.0,1,"正比",50) end
if t==(1) then R.change(o,"type",1.0,1.0,1,"正比",1) end
if t==(15) then R.change(o,"wscale",0.0,0,0,"正比",35) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=96,["begin"]=1,["life"]=6200,["fx"]=-99998,["fy"]=-99998,["r"]=50,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(181+math.floor(t/240)*240) then R.change(o,"speed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",720.0,0,1,"正比",240) end
if t==(1+math.floor(t/240)*240) then R.change(o,"speed",-2.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"speed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"speed",-2.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=256,["y"]=160,["begin"]=1,["life"]=6200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=242,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=5,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=2,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=0,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=0,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=64,["begin"]=3,["life"]=6198,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=0,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0.4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,35.0,1,"正比",80) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=9,["Bindwithspeedd"]=false,["x"]=224,["y"]=224,["begin"]=1,["life"]=100,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=366,["type"]=199,["wscale"]=0.2,["hscale"]=1.2,["colorR"]=1,["colorG"]=165,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正弦",240) end
if t==(1) then R.change(o,"fdirection",90.0,0,0,"正比",1) end
if t==(17) then R.change(o,"t",8.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",12.0,0,1,"正弦",120) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",20.0,0,1,"正弦",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"wscale",0.15,0,1,"正弦",39) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=416,["y"]=160,["begin"]=3,["life"]=6198,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=25,["t"]=9970,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=199,["wscale"]=0.2,["hscale"]=1.2,["colorR"]=1,["colorG"]=125,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/300)*300) then R.change(o,"wscale",0.7,0,0,"正弦",89) end
if t==(10+math.floor(t/300)*300) then R.fire(o) end
if t==(15+math.floor(t/300)*300) then R.fire(o) end
if t==(20+math.floor(t/300)*300) then R.fire(o) end
if t==(25+math.floor(t/300)*300) then R.fire(o) end
if t==(30+math.floor(t/300)*300) then R.fire(o) end
if t==(35+math.floor(t/300)*300) then R.fire(o) end
if t==(40+math.floor(t/300)*300) then R.fire(o) end
if t==(45+math.floor(t/300)*300) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(10) then R.change(o,"alpha",100.0,0,0,"正比",15) end
if t==(182) then R.change(o,"sonspeedd",18.0,0,1,"正弦",180) end
if t==(2) then R.change(o,"sonspeedd",18.0,0,1,"正弦",180) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.07,0,1,"正弦",29) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=352,["y"]=160,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=45,["type"]=2,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",5) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",5) end
if t==(50) then R.change(o,"colorR",100.0,0,0,"正比",50) end
if t==(60) then R.change(o,"alpha",0.0,0,0,"正比",40) end
if t==(50) then R.change(o,"colorG",20.0,0,0,"正比",50) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=0,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=0,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=14,["Bindwithspeedd"]=false,["x"]=224,["y"]=256,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=0,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=366,["type"]=199,["wscale"]=0.3,["hscale"]=1,["colorR"]=1,["colorG"]=165,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.2,0,0,"正弦",240) end
if t==(1) then R.change(o,"fdirection",90.0,0,0,"正比",1) end
if t==(100) then R.change(o,"t",6.0,0,0,"正比",1) end
if t==(19) then R.change(o,"t",9999.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",12.0,0,1,"正弦",120) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",20.0,0,1,"正弦",120) end
end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=0,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=38,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=140,["type"]=0,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=17,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=448,["y"]=0,["begin"]=2,["life"]=6199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=38,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=140,["type"]=0,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=18,["parentid"]=1,["Binding"]=false,["bindid"]=16,["Bindwithspeedd"]=false,["x"]=288,["y"]=224,["begin"]=21,["life"]=100,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=190,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=366,["type"]=199,["wscale"]=0.2,["hscale"]=1.2,["colorR"]=1,["colorG"]=165,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正弦",240) end
if t==(17) then R.change(o,"t",8.0,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",92.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",12.0,0,1,"正弦",120) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",20.0,0,1,"正弦",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"wscale",0.2,0,1,"正弦",39) end
end},
{["id"]=19,["parentid"]=1,["Binding"]=false,["bindid"]=17,["Bindwithspeedd"]=false,["x"]=288,["y"]=256,["begin"]=21,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=8,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=190,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=366,["type"]=199,["wscale"]=0.3,["hscale"]=1,["colorR"]=1,["colorG"]=165,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.2,0,0,"正弦",240) end
if t==(100) then R.change(o,"t",8.0,0,0,"正比",1) end
if t==(17) then R.change(o,"t",9999.0,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",92.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",12.0,0,1,"正弦",120) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",20.0,0,1,"正弦",120) end
end},
{["id"]=20,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=416,["y"]=192,["begin"]=3,["life"]=6198,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=25,["t"]=9970,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=199,["wscale"]=0.3,["hscale"]=1.2,["colorR"]=1,["colorG"]=165,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(5+math.floor(t/300)*300) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(10) then R.change(o,"alpha",100.0,0,0,"正比",15) end
if t==(182) then R.change(o,"sonspeedd",18.0,0,1,"正弦",180) end
if t==(2) then R.change(o,"sonspeedd",18.0,0,1,"正弦",180) end
end},
{["id"]=21,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=448,["y"]=160,["begin"]=153,["life"]=6048,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=25,["t"]=9970,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=199,["wscale"]=0.2,["hscale"]=1.2,["colorR"]=1,["colorG"]=125,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/300)*300) then R.change(o,"wscale",0.7,0,0,"正弦",89) end
if t==(10+math.floor(t/300)*300) then R.fire(o) end
if t==(15+math.floor(t/300)*300) then R.fire(o) end
if t==(20+math.floor(t/300)*300) then R.fire(o) end
if t==(25+math.floor(t/300)*300) then R.fire(o) end
if t==(30+math.floor(t/300)*300) then R.fire(o) end
if t==(35+math.floor(t/300)*300) then R.fire(o) end
if t==(40+math.floor(t/300)*300) then R.fire(o) end
if t==(45+math.floor(t/300)*300) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(10) then R.change(o,"alpha",100.0,0,0,"正比",15) end
if t==(182) then R.change(o,"sonspeedd",18.0,0,2,"正弦",180) end
if t==(2) then R.change(o,"sonspeedd",18.0,0,2,"正弦",180) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.07,0,1,"正弦",29) end
end},
{["id"]=22,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=448,["y"]=192,["begin"]=153,["life"]=6048,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=25,["t"]=9970,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=199,["wscale"]=0.3,["hscale"]=1.2,["colorR"]=1,["colorG"]=165,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(5+math.floor(t/300)*300) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(10) then R.change(o,"alpha",100.0,0,0,"正比",15) end
if t==(182) then R.change(o,"sonspeedd",18.0,0,2,"正弦",180) end
if t==(2) then R.change(o,"sonspeedd",18.0,0,2,"正弦",180) end
end},
{["id"]=0,["parentid"]=1,["x"]=96,["y"]=448,["begin"]=1,["life"]=6200,["longs"]=700,["angle"]=0,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={},["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"life",0.0,0,0,"正比",1)
R.change(o,"Dispel",0.0,0,0,"正比",1)
end}
}}
