return {["id"]="245",["total"]=390,["order"]=0,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{0,0,40,550,20,275,10,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,0,182,204,92,102,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,204,331,335,166,173,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{371,139,282,295,141,147,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{653,139,320,335,160,168,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{973,139,43,42,22,21,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{0,0,500,200,300,100,0,0,1,0,0,0,0,0,0,"Tinda2"},{0,200,500,200,300,100,0,0,1,0,0,0,0,0,0,"Tinda2"},{0,400,500,200,300,100,0,0,1,0,0,0,0,0,0,"Tinda2"},{0,0,500,200,300,100,0,0,8,2,0,0,0,0,0,"Tinda2"},{0,1400,500,200,300,100,0,0,1,0,0,0,0,0,0,"Tinda2"},{973,230,164,166,82,83,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,202,90,81,45,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,283,57,58,28,29,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,341,68,71,34,36,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{0,0,200,150,100,30,0,0,1,0,0,0,0,0,0,"yujingquyu2"},{0,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"Jifeijiantou"}},centerEvents=function(o,t,R)
if t==(1) then R.change(o,"speedd","自机",0,0,"正比",1) end
if t==(151) then R.change(o,"speed",11,0,0,"正比",1) end
if t==(170) then R.change(o,"speed",0,0,0,"正比",12) end
if t==(300) then R.move(o,false,420,540,320,290) end
if t==(140) then R.sound("stage2claw") end
if t==(150) then R.sound("stage2claw") end
if t==(160) then R.sound("stage2claw") end
if t==(165) then R.sound("stage2claw") end
if t==(170) then R.sound("enep02") end
if t==(270) then R.sound("iainuki") end
end,globalEvents=function(c,t,R)
if t==179 then R.jump(c,2,1,0) end
if t==180 then R.quake(c,30,9) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=168,["begin"]=182,["life"]=5,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=70,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.3,0,0,"正比",5) end
if t==(5) then R.change(o,"type",1,0,2,"正比",1) end
if t==(1) then R.change(o,"wscale",1.3,0,0,"正比",5) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=72,["begin"]=152,["life"]=5,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=70,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=200,["begin"]=1,["life"]=60,["fx"]=480,["fy"]=264,["r"]=100,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=163,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(5) then R.change(o,"t",4,0,0,"正比",1) end
if t==(30) then R.change(o,"t",9,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.3,0,0,"正比",5) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(1) then R.change(o,"wscale",1.3,0,0,"正比",5) end
if t==(100) then R.change(o,"alpha",1,0,0,"正比",20) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=72,["begin"]=162,["life"]=5,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=70,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",6,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",6,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=72,["begin"]=182,["life"]=5,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=70,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=7,["type"]=96,["wscale"]=6,["hscale"]=6,["colorR"]=255,["colorG"]=12,["colorB"]=12,["alpha"]=44,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",16,0,0,"正比",7) end
if t==(1) then R.change(o,"hscale",16,0,0,"正比",7) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",7) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=168,["wscale"]=0.1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=33,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",2,0,0,"正比",60) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=608,["y"]=520,["begin"]=270,["life"]=31,["fx"]=-99998,["fy"]=-99998,["r"]=350,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=163,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=250,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",5) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",5) end
if t==(30) then R.change(o,"colorR",1,0,0,"正比",30) end
if t==(30) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=640,["y"]=520,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=1,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=12,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"sonspeedd","自机",0,0,"正比",1) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=616,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=18,["wscale"]=133,["hscale"]=133,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",33,0,0,"正比",60) end
if t==(60) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=true,["x"]=352,["y"]=360,["begin"]=5,["life"]=296,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6,["type"]=167,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=40,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(31) then R.change(o,"alpha",10,0,1,"无缝正弦",30) end
if t==(61) then R.change(o,"alpha",10,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeed",3,0,1,"无缝正弦",120) end
if t==(90) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",99,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=91,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(18) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(18) then R.change(o,"hscale",5,0,0,"正比",60) end
if t==(17) then R.change(o,"alpha",33,0,0,"正比",1) end
if t==(18) then R.change(o,"wscale",5,0,0,"正比",60) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=264,["begin"]=1,["life"]=1,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=158,["wscale"]=0.5,["hscale"]=-0.5,["colorR"]=255,["colorG"]=245,["colorB"]=245,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(151) then R.change(o,"sonspeed",11,0,0,"正比",1) end
if t==(170) then R.change(o,"sonspeed",0.01,0,0,"正比",12) end
if t>(1) then R.change(o,"head",90,0,1,"正比",1) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",18) end
if t==(191) then R.change(o,"hscale",-0.1,0,0,"正比",20) end
if t==(2) then R.change(o,"alpha",100,0,0,"正比",5) end
if t==(1) then R.change(o,"hscale",-0.8,0,0,"正比",18) end
if t==(8) then R.change(o,"type",1,0,1,"正比",1) end
if t==(150) then R.change(o,"type",3,0,1,"正比",1) end
if t==(174) then R.change(o,"type",1,0,1,"正比",1) end
if t==(12) then R.change(o,"type",1,0,1,"正比",1) end
if t==(140) then R.change(o,"type",1,0,2,"正比",1) end
if t==(145) then R.change(o,"type",1,0,2,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["x"]=640,["y"]=168,["begin"]=181,["life"]=20,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["addaspeed"]=0,["addaspeedd"]=0,["Suction"]=false,["Repulsion"]=true,["addspeed"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=13,["Deepbind"]=false,["kind"]="force"},
{["id"]=0,["parentid"]=1,["x"]=448,["y"]=424,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=2,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(151) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(151) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(151) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(185) then R.change(o,"life",0,0,0,"正比",1) end
if t==(155) then R.change(o,"wscale",0.01,0,0,"正比",31) end
if t==(151) then R.change(o,"colorB",125,0,0,"正比",1) end
if t==(171) then R.change(o,"alpha",1,0,0,"正比",11) end
if t==(153) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["x"]=480,["y"]=424,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(166) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(166) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(166) then R.change(o,"colorB",125,0,0,"正比",1) end
if t==(192) then R.change(o,"life",0,0,0,"正比",1) end
if t==(170) then R.change(o,"wscale",0.01,0,0,"正比",31) end
if t==(166) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(186) then R.change(o,"alpha",1,0,0,"正比",11) end
if t==(168) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["x"]=512,["y"]=424,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=6,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(151) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(151) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(151) then R.change(o,"colorB",125,0,0,"正比",1) end
if t==(188) then R.change(o,"life",0,0,0,"正比",1) end
if t==(155) then R.change(o,"wscale",0.01,0,0,"正比",31) end
if t==(151) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(171) then R.change(o,"alpha",1,0,0,"正比",11) end
if t==(154) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=1,["x"]=480,["y"]=520,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(141) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(141) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(141) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(174) then R.change(o,"life",0,0,0,"正比",1) end
if t==(145) then R.change(o,"wscale",0.01,0,0,"正比",31) end
if t==(141) then R.change(o,"colorB",125,0,0,"正比",1) end
if t==(161) then R.change(o,"alpha",1,0,0,"正比",11) end
if t==(144) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=1,["x"]=544,["y"]=424,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=12,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(271) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(308) then R.change(o,"life",0,0,0,"正比",1) end
if t==(275) then R.change(o,"wscale",0.01,0,0,"正比",31) end
if t==(291) then R.change(o,"alpha",1,0,0,"正比",11) end
if t==(273) then R.change(o,"alpha",95,0,0,"正比",1) end
if t==(271) then R.change(o,"colorB",255,0,0,"正比",1) end
if t==(271) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(271) then R.change(o,"colorG",255,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",90) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=648,["begin"]=2,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=6,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=66,["wscale"]=0.3,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=88,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",230,0,2,"正比",90) end
if t==(1) then R.change(o,"sonspeed",50,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",2,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",90,0,2,"正比",1) end
if t==(7) then R.change(o,"alpha",20,0,0,"正比",1) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(30) then R.change(o,"colorG",130,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=648,["begin"]=32,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=6,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=66,["wscale"]=0.3,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=55,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",330,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",45,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",2.4,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",100,0,1,"正比",1) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(30) then R.change(o,"colorG",130,0,0,"正比",30) end
if t==(7) then R.change(o,"alpha",20,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=384,["y"]=392,["begin"]=150,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=163,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",12,11,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.0001,0,0,"正比",20) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=416,["y"]=392,["begin"]=170,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=163,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",12,11,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.0001,0,0,"正比",20) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=12,["Bindwithspeedd"]=true,["x"]=512,["y"]=328,["begin"]=180,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=167,["wscale"]=0.1,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",9,0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",190,0,1,"正比",60) end
if t==(1) then R.change(o,"wscale",9,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(7) then R.change(o,"alpha",30,0,0,"正比",1) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=12,["Bindwithspeedd"]=true,["x"]=576,["y"]=328,["begin"]=145,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=154,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=15,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",2,0,0,"正比",90) end
if t==(1) then R.change(o,"head",6666,0,1,"正比",200) end
if t==(1) then R.change(o,"hscale",2,0,0,"正比",90) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=true,["x"]=608,["y"]=360,["begin"]=6,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=220,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=58,["wscale"]=0.01,["hscale"]=1,["colorR"]=255,["colorG"]=133,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2) then R.change(o,"fdirection",3900,0,1,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",166,0,0,"正比",80) end
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",30) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=520,["begin"]=2,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=6,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=66,["wscale"]=-0.1,["hscale"]=1.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=140,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.3,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",230,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",80,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",3,0,2,"正弦",180) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",90,0,2,"正比",1) end
if t==(6) then R.change(o,"alpha",20,0,0,"正比",1) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(26) then R.change(o,"colorG",130,0,0,"正比",31) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=640,["y"]=360,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=120,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=220,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=58,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=125,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"t",80,5,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",130,0,0,"正比",9) end
if t==(1) then R.change(o,"wscale",0.7,0.2,0,"正比",9) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=12,["Bindwithspeedd"]=true,["x"]=576,["y"]=360,["begin"]=130,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=2,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=15,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正比",1) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=12,["Bindwithspeedd"]=true,["x"]=544,["y"]=328,["begin"]=180,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=18,["wscale"]=0.1,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",7,0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",190,0,1,"正比",60) end
if t==(1) then R.change(o,"wscale",7,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(6) then R.change(o,"alpha",30,0,0,"正比",1) end
if t==(36) then R.change(o,"colorG",130,0,0,"正比",1) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=250,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=1,["life"]=1,["fx"]=480,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=250,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=16.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=544,["y"]=168,["begin"]=31,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=24,["type"]=168,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-33,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",5,0,1,"无缝正弦",120) end
if t==(100) then R.change(o,"alpha",1,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",13) end
if t==(1) then R.change(o,"wscale",0.4,0,0,"正比",13) end
if t==(1) then R.change(o,"sonspeed",66,0,2,"正比",13) end
end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=576,["y"]=168,["begin"]=40,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=90,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=144,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(20) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"wscale",4,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",4,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",88,0,0,"正比",1) end
end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=608,["y"]=168,["begin"]=180,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=90,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=215,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1) then R.change(o,"wscale",13,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",13,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=2,["x"]=448,["y"]=456,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=2,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(151) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(191) then R.change(o,"life",0,0,0,"正比",1) end
if t==(161) then R.change(o,"alpha",1,0,0,"正比",31) end
if t==(151) then R.change(o,"type",10,0,0,"正比",1) end
if t==(161) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(161) then R.change(o,"colorB",255,0,0,"正比",1) end
if t==(161) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(161) then R.change(o,"Blend",1,0,0,"正比",1) end
if t==(154) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=2,["x"]=480,["y"]=456,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(166) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(195) then R.change(o,"life",0,0,0,"正比",1) end
if t==(170) then R.change(o,"alpha",1,0,0,"正比",31) end
if t==(176) then R.change(o,"Blend",1,0,0,"正比",1) end
if t==(176) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(176) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(176) then R.change(o,"colorB",255,0,0,"正比",1) end
if t==(166) then R.change(o,"type",10,0,0,"正比",1) end
if t==(169) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=2,["x"]=512,["y"]=456,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(151) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(165) then R.change(o,"life",0,0,0,"正比",1) end
if t==(155) then R.change(o,"wscale",0.01,0,0,"正比",21) end
if t==(154) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=2,["x"]=480,["y"]=552,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=5,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(141) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(165) then R.change(o,"life",0,0,0,"正比",1) end
if t==(145) then R.change(o,"wscale",0.01,0,0,"正比",31) end
if t==(151) then R.change(o,"colorB",255,0,0,"正比",1) end
if t==(151) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(151) then R.change(o,"Blend",1,0,0,"正比",1) end
if t==(151) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(145) then R.change(o,"type",10,0,0,"正比",1) end
if t==(143) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=2,["x"]=544,["y"]=456,["begin"]=1,["life"]=240,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=6,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(271) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(295) then R.change(o,"life",0,0,0,"正比",1) end
if t==(275) then R.change(o,"wscale",0.01,0,0,"正比",21) end
if t==(274) then R.change(o,"alpha",95,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",90) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=648,["begin"]=2,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=6,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=18,["wscale"]=0.1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=88,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",230,0,2,"正比",90) end
if t==(1) then R.change(o,"sonspeed",50,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",1.7,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",90,0,2,"正比",1) end
if t==(12) then R.change(o,"alpha",88,0,0,"正比",51) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=648,["begin"]=32,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=6,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=18,["wscale"]=0.1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=55,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",330,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",45,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",1.7,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",100,0,1,"正比",1) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(12) then R.change(o,"alpha",88,0,0,"正比",51) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=512,["y"]=360,["begin"]=180,["life"]=31,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=167,["wscale"]=0.04,["hscale"]=0.15,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",200,0,1,"正比",60) end
if t==(1) then R.change(o,"wscale",0.5,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(7) then R.change(o,"alpha",88,0,0,"正比",1) end
if t==(10) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=520,["begin"]=2,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=6,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=66,["wscale"]=0.1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=140,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",230,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",80,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",2,0,2,"正弦",180) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",90,0,2,"正比",1) end
if t==(6) then R.change(o,"alpha",88,0,0,"正比",1) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=544,["y"]=360,["begin"]=180,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=10,["wscale"]=0.1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",8,0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",190,0,1,"正比",60) end
if t==(1) then R.change(o,"wscale",8,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(6) then R.change(o,"alpha",88,0,0,"正比",13) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=250,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=520,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=6,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=18,["wscale"]=0.1,["hscale"]=1,["colorR"]=130,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=140,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",230,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",70,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",2,0,2,"正弦",180) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",90,0,2,"正比",1) end
if t==(6) then R.change(o,"alpha",20,0,0,"正比",1) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=11,["Bindwithspeedd"]=true,["x"]=672,["y"]=392,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=120,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=220,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=10,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=125,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"t",80,5,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",130,0,0,"正比",9) end
if t==(1) then R.change(o,"wscale",0.8,0.2,0,"正比",9) end
end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=true,["x"]=608,["y"]=392,["begin"]=9,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=74,["wscale"]=0.01,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2) then R.change(o,"fdirection",3900,0,1,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.6,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",188,0,0,"正比",40) end
end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=576,["y"]=392,["begin"]=180,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=2,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=16,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,10,1,"正比",1) end
end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=9,["Bindwithspeedd"]=true,["x"]=640,["y"]=392,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=74,["wscale"]=0.01,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",40) end
if t==(1) then R.change(o,"hscale",188,0,0,"正比",40) end
end},
{["id"]=12,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=520,["begin"]=2,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=6,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=167,["wscale"]=0.1,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=140,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.4,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",230,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",80,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",4,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.4,0,1,"正弦",180) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",99,0,2,"正比",1) end
if t==(7) then R.change(o,"alpha",88,0,0,"正比",5) end
if t==(6) then R.change(o,"sonspeed",-0.01,0,0,"正比",1) end
if t==(30) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=13,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=648,["begin"]=32,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=6,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=55,["type"]=167,["wscale"]=0.01,["hscale"]=0.1,["colorR"]=122,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=55,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.3,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",330,0,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",47,0,2,"正弦",290) end
if t==(5) then R.change(o,"t",4,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.3,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(20) then R.change(o,"colorR",255,0,0,"正比",20) end
if t==(20) then R.change(o,"colorG",255,0,0,"正比",20) end
if t==(20) then R.change(o,"colorB",255,0,0,"正比",20) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",110,0,1,"正比",1) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(12) then R.change(o,"alpha",88,0,0,"正比",10) end
if t==(22) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=14,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=648,["begin"]=2,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=6,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=167,["wscale"]=0.01,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=88,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.3,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection",230,0,2,"正比",90) end
if t==(1) then R.change(o,"sonspeed",50,0,2,"正弦",270) end
if t==(5) then R.change(o,"t",4,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.3,0,1,"正弦",180) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(6) then R.change(o,"sonspeedd",100,0,2,"正比",1) end
if t==(12) then R.change(o,"alpha",88,0,0,"正比",51) end
if t==(6) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(60) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=151,["life"]=40,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=154,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",40) end
if t==(21) then R.change(o,"colorB",1,0,0,"正比",20) end
if t==(21) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1) then R.change(o,"fdirection",1000,0,1,"正比",40) end
if t==(1) then R.change(o,"wscale",0.5,0,1,"正比",40) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=171,["life"]=40,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=154,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,1,"正比",40) end
if t==(21) then R.change(o,"colorB",1,0,0,"正比",20) end
if t==(21) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1) then R.change(o,"fdirection",1000,0,2,"正比",40) end
if t==(1) then R.change(o,"wscale",1,0,1,"正比",40) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=180,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=19,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=380,["type"]=148,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,1,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,13,1,"正比",90) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",90) end
if t==(93) then R.change(o,"sonspeed",1,0.3,0,"正比",60) end
if t==(1) then R.change(o,"head",5600,0,1,"正比",1200) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=40,["begin"]=240,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=11,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=110,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4,0,0,"正比",120) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=211,["life"]=60,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=154,["wscale"]=9,["hscale"]=9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,0,"正比",60) end
if t==(21) then R.change(o,"colorB",1,0,0,"正比",20) end
if t==(21) then R.change(o,"alpha",88,0,0,"正比",30) end
if t==(1) then R.change(o,"fdirection",1800,0,2,"正比",88) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=271,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=61,["type"]=154,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",13,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",13,0,0,"正比",60) end
if t==(1) then R.change(o,"head",1300,0,2,"正比",60) end
end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=72,["begin"]=180,["life"]=2,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1700,["type"]=139,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1,0,2,"正比",3) end
end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"sonspeed",1,0,1,"正比",120) end
end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=544,["y"]=232,["begin"]=379,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=163,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(61) then R.change(o,"colorR",1,0,0,"正比",60) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",60) end
if (o.fy or 0)>(690) then R.change(o,"life",0,0,0,"固定",1) end
end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=576,["y"]=232,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=17,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=389,["type"]=58,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(91) then R.change(o,"sonspeed",1.6,0,0,"正比",160) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",30) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",30) end
if t==(81) then R.change(o,"colorB",255,0,0,"正比",60) end
if t==(81) then R.change(o,"colorG",255,0,0,"正比",60) end
if t==(385) then R.change(o,"sonspeed",0,0,0,"正比",1) end
end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=false,["x"]=608,["y"]=232,["begin"]=387,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=99,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(30) then R.change(o,"colorR",1,0,0,"正比",30) end
if t==(15) then R.change(o,"alpha",1,0,0,"正比",45) end
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
end}
}}
