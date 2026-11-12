-- 离线展开：b651.xna；事件均已编译为Lua条件和调用。
return {id="651",total=900,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)
if t==(61) then R.move(o,250,250,94,96) end
if t==(121) then R.change(o,"speedd",30.0,0,0,"正比",1) end
if t==(122) then R.change(o,"speedd",-30.0,0,0,"正比",60) end
if t==(121) then R.change(o,"speed",3.0,0,0,"正比",1) end
if t==(122) then R.change(o,"speed",0.01,0,0,"正比",90) end
if t==(301) then R.move(o,380,380,94,96) end
if t==(361) then R.change(o,"speedd",150.0,0,0,"正比",1) end
if t==(362) then R.change(o,"speedd",210.0,0,0,"正比",60) end
if t==(361) then R.change(o,"speed",3.0,0,0,"正比",1) end
if t==(362) then R.change(o,"speed",0.01,0,0,"正比",90) end
if t==(541) then R.move(o,280,350,140,130) end
if t==(631) then R.move(o,280,350,140,130) end
end,globalEvents=function(c,t,R)

end,types={{0,0,40,40,20,20,8,0},{40,0,40,40,20,20,8,0},{80,0,40,40,20,20,8,0},{120,0,40,40,20,20,8,0},{160,0,28,43,13,21,5,0},{0,40,56,62,28,36,15,0},{56,40,56,62,28,36,15,0},{112,40,28,28,14,14,5,0},{112,68,28,28,14,14,5,0},{140,43,35,21,17,11,5,0},{140,64,35,21,17,11,5,0},{0,102,388,388,194,194,50,0},{460,0,45,45,22,22,3,0},{505,0,45,45,22,22,3,0},{550,0,45,45,22,22,3,0},{595,0,45,45,22,22,3,0},{460,45,45,45,22,22,3,0},{505,45,45,45,22,22,3,0},{550,45,45,45,22,22,3,0},{595,45,45,45,22,22,3,0},{459,90,45,45,22,14,3,0},{505,90,45,45,22,14,3,0},{550,90,45,45,22,14,3,0},{595,90,45,45,22,14,3,0},{460,135,45,45,22,22,3,0},{505,135,45,45,22,22,3,0},{550,135,45,45,22,22,3,0},{595,135,45,45,22,22,3,0},{388,180,248,141,124,130,0,0},{388,321,248,141,124,130,0,0},{388,462,248,141,124,130,0,0},{188,0,45,59,23,30,4,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=31,["life"]=216,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",330) end
if t==(215) then R.change(o,"sonlife",30.0,0,0,"固定",1) end
if t==(31) then R.change(o,"alpha",50.0,0,0,"正比",61) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",30) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",33) end
if t==(1) then R.change(o,"sonspeedd",30.0,0,1,"正比",30) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=384,["begin"]=271,["life"]=216,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",330) end
if t==(215) then R.change(o,"sonlife",30.0,0,0,"固定",1) end
if t==(31) then R.change(o,"alpha",50.0,0,0,"正比",61) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",30) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",33) end
if t==(1) then R.change(o,"sonspeedd",30.0,0,2,"正比",30) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=31,["life"]=216,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",120.0,0,2,"正弦",330) end
if t==(215) then R.change(o,"sonlife",30.0,0,0,"固定",1) end
if t==(31) then R.change(o,"alpha",10.0,0,0,"正比",61) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",30) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",33) end
if t==(1) then R.change(o,"sonspeedd",30.0,0,1,"正比",30) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=384,["begin"]=271,["life"]=216,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",120.0,0,1,"正弦",300) end
if t==(215) then R.change(o,"sonlife",30.0,0,0,"固定",1) end
if t==(31) then R.change(o,"alpha",10.0,0,0,"正比",61) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",30) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",33) end
if t==(1) then R.change(o,"sonspeedd",30.0,0,2,"正比",30) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",30) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=61,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1210,["type"]=249,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,2,"正弦",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=300,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1220,["type"]=249,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=601,["life"]=216,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1200.0,0,2,"正比",330) end
if t==(1) then R.change(o,"hscale",2.0,0,0,"正比",261) end
if t==(150) then R.change(o,"alpha",1.0,0,0,"正比",61) end
if t==(1) then R.change(o,"wscale",2.0,0,0,"正比",261) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",30) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",33) end
if t==(1) then R.change(o,"sonspeedd",30.0,0,1,"正比",30) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",30) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=601,["life"]=216,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1200.0,0,1,"正比",330) end
if t==(1) then R.change(o,"hscale",1.2,0,0,"正比",261) end
if t==(150) then R.change(o,"alpha",1.0,0,0,"正比",61) end
if t==(1) then R.change(o,"wscale",1.2,0,0,"正比",261) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",30) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",33) end
if t==(1) then R.change(o,"sonspeedd",30.0,0,1,"正比",30) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",30) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=660,["life"]=241,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=15,["t"]=36,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=175,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=128,["begin"]=240,["life"]=3,["fx"]=316,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=31,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=19,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,0,0,"正比",3) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=128,["begin"]=480,["life"]=3,["fx"]=316,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=31,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=19,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,0,0,"正比",3) end
end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=61,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1210,["type"]=249,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,2,"正弦",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=300,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1220,["type"]=249,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=61,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1210,["type"]=249,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,2,"正弦",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=300,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1220,["type"]=249,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=61,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=258,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,2,"正弦",240) end
if t==(185) then R.change(o,"Blend",1.0,0,0,"固定",1) end
if t==(185) then R.change(o,"Afterimage",1.0,0,0,"固定",1) end
if t==(60) then R.change(o,"sonlife",15.0,0,0,"固定",1) end
if t==(1) then R.change(o,"r",40.0,0,0,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",15) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",14) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=61,["life"]=60,["fx"]=-99998,["fy"]=175,["r"]=36,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=258,["wscale"]=0.1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.6,0,0,"正比",15) end
if t==(1) then R.change(o,"r",40.0,0,0,"正比",15) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=301,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=258,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",240) end
if t==(185) then R.change(o,"Blend",1.0,0,0,"固定",1) end
if t==(185) then R.change(o,"Afterimage",1.0,0,0,"固定",1) end
if t==(60) then R.change(o,"sonlife",15.0,0,0,"固定",1) end
if t==(1) then R.change(o,"r",40.0,0,0,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",15) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",14) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",15) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=301,["life"]=60,["fx"]=-99998,["fy"]=175,["r"]=36,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=258,["wscale"]=0.1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.6,0,0,"正比",15) end
if t==(1) then R.change(o,"r",40.0,0,0,"正比",15) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=61,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=122,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,2,"正弦",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=300,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=122,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=661,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=-30,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=258,["wscale"]=0.1,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",3000.0,0,1,"正比",200) end
if t==(1) then R.change(o,"rdirection",3000.0,0,1,"正比",200) end
if t==(1) then R.change(o,"r",130.0,0,1,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",25) end
if t==(25) then R.change(o,"wscale",0.1,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",9) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=661,["life"]=180,["fx"]=-99998,["fy"]=175,["r"]=-10,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5,["type"]=0,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",3000.0,0,1,"正比",200) end
if t==(1) then R.change(o,"rdirection",3000.0,0,1,"正比",200) end
if t==(1) then R.change(o,"r",150.0,0,1,"正比",200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=384,["y"]=320,["begin"]=663,["life"]=238,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=14,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=249,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=416,["y"]=320,["begin"]=663,["life"]=238,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=14,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=122,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.58,0,0,"正比",180) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=448,["y"]=320,["begin"]=663,["life"]=238,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=14,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=122,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.75,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.54,0,0,"正比",180) end
end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=300,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=122,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=61,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=110,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=999,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=122,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,2,"正弦",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=384,["y"]=288,["begin"]=663,["life"]=238,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=2,["wscale"]=0.2,["longs"]=600,["alpha"]=80,["Ray"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="laser",["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(45) then R.change(o,"alpha",100.0,0,0,"正比",5) end
if t==(45) then R.change(o,"wscale",3.0,0,0,"正比",15) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=160,["begin"]=91,["life"]=120,["fx"]=78,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=260,["wscale"]=0.15,["hscale"]=0.3,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=90,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3.0,0,1,"正比",80) end
end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"Outdispel",1.0,0,1,"固定",1) end
if t==(60) then R.change(o,"sonspeed",10.0,10.0,2,"正比",121) end
if t==(3) then R.change(o,"sonspeed",0.11,0.1,0,"正比",121) end
if t==(3) then R.change(o,"head",0.0,1200.0,1,"正比",121) end
if t==(60) then R.change(o,"hscale",0.1,0,0,"正比",61) end
if t==(60) then R.change(o,"sonspeedd",0.0,30.0,1,"正比",121) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=160,["begin"]=331,["life"]=120,["fx"]=522,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=260,["wscale"]=0.15,["hscale"]=0.3,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=90,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3.0,0,1,"正比",80) end
end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"Outdispel",1.0,0,1,"固定",1) end
if t==(60) then R.change(o,"sonspeed",10.0,10.0,2,"正比",121) end
if t==(3) then R.change(o,"sonspeed",0.11,0.1,0,"正比",121) end
if t==(3) then R.change(o,"head",0.0,1200.0,1,"正比",121) end
if t==(60) then R.change(o,"hscale",0.1,0,0,"正比",61) end
if t==(60) then R.change(o,"sonspeedd",0.0,30.0,1,"正比",121) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=6,["life"]=300,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=239,["wscale"]=0,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=60,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(241) then R.change(o,"wscale",0.0,0,0,"正比",15) end
if t==(61) then R.change(o,"yscale",0.2,0,1,"正弦",240) end
if t==(61) then R.change(o,"wscale",1.3,0,0,"正比",15) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正弦",350) end
if t==(11) then R.change(o,"sonspeed",30.0,0,1,"正弦",360) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(2) then R.change(o,"alpha",100.0,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=246,["life"]=300,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=239,["wscale"]=0,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=60,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(241) then R.change(o,"wscale",0.0,0,0,"正比",15) end
if t==(61) then R.change(o,"yscale",0.2,0,1,"正弦",240) end
if t==(61) then R.change(o,"wscale",1.3,0,0,"正比",15) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正弦",350) end
if t==(11) then R.change(o,"sonspeed",30.0,0,1,"正弦",360) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(2) then R.change(o,"alpha",100.0,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=61,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=258,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,2,"正弦",240) end
if t==(185) then R.change(o,"Blend",1.0,0,0,"固定",1) end
if t==(185) then R.change(o,"Afterimage",1.0,0,0,"固定",1) end
if t==(185) then R.change(o,"sonlife",60.0,0,0,"固定",1) end
if t==(1) then R.change(o,"r",40.0,0,0,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",60) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",60) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=301,["life"]=186,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=70,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=70,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=258,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",240) end
if t==(61) then R.change(o,"r",30.0,0,1,"正弦",120) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",240) end
if t==(185) then R.change(o,"Blend",1.0,0,0,"固定",1) end
if t==(185) then R.change(o,"Afterimage",1.0,0,0,"固定",1) end
if t==(185) then R.change(o,"sonlife",60.0,0,0,"固定",1) end
if t==(1) then R.change(o,"r",40.0,0,0,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorR",1.0,0,0,"正比",60) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",60) end
if t==(2) then R.change(o,"alpha",50.0,0,0,"正比",1) end
end}
}}
