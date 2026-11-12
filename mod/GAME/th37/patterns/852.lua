-- 离线展开：b852.xna；事件均已编译为Lua条件和调用。
return {id="852",total=5120,centerAvailable=true,center={315,240,0,0,0,0},centerEvents=function(o,t,R)
if t==(5) then R.move(o,315,315,240,240) end
if t==(65) then R.move(o,315,315,240,240) end
end,globalEvents=function(c,t,R)

end,types={{0,0,60,54,30,27,7,0},{60,0,64,62,32,31,7,0},{124,0,56,53,28,27,6,0},{180,0,18,24,9,12,1,0},{180,27,17,25,9,13,1,0},{207,24,11,11,5,5,1,0},{0,62,194,194,102,97,60,0},{194,62,192,192,96,96,60,0},{344,256,86,132,43,120,10,0},{430,256,86,132,43,120,10,0},{0,256,344,344,172,172,1,0},{0,600,392,392,196,196,1,0},{344,399,135,168,67,84,1,0},{459,0,45,45,22,18,2,0},{505,0,45,45,22,18,2,0},{550,0,45,45,22,18,2,0},{595,0,45,45,22,18,2,0},{459,45,45,45,22,18,2,0},{505,45,45,45,22,18,2,0},{550,45,45,45,22,18,2,0},{595,45,45,45,22,18,2,0},{460,90,45,45,22,18,2,2},{505,90,45,45,22,18,2,2},{550,90,45,45,22,18,2,2},{595,90,45,45,22,18,2,2},{460,134,45,45,22,18,2,1},{505,135,45,45,22,18,2,1},{550,135,45,45,22,18,2,1},{595,135,45,45,22,18,2,1},{373,0,21,31,10,15,3,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=64,["y"]=256,["begin"]=61,["life"]=4940,["fx"]=316,["fy"]=255,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=230,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=280,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"r",2.0,0,1,"正弦",79) end
if t==(1) then R.change(o,"alpha",88.0,0,0,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=64,["y"]=288,["begin"]=1,["life"]=4970,["fx"]=316,["fy"]=255,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=20,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=230,["wscale"]=1,["hscale"]=1,["colorR"]=25,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=280,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"r",2.0,0,1,"正弦",79) end
if t==(690+math.floor(t/700)*700) then R.change(o,"colorR",10.0,0,1,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=160,["y"]=96,["begin"]=241,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=80,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(8+math.floor(t/20)*20) then R.change(o,"t",9999.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1.5,0,2,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=64,["y"]=128,["begin"]=1,["life"]=1,["fx"]=315,["fy"]=305,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=235,["wscale"]=6,["hscale"]=6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.8,0,0,"正弦",480) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正弦",480) end
if t==(1) then R.change(o,"alpha",88.0,0,0,"正比",120) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=64,["y"]=160,["begin"]=121,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3700,["type"]=235,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=0,["begin"]=121,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=84,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,1,"正比",120) end
if t==(120) then R.change(o,"sonspeedd",1200.0,0,1,"正比",600) end
if t==(1) then R.change(o,"sonspeed",8.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=160,["y"]=128,["begin"]=251,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=100,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(8+math.floor(t/20)*20) then R.change(o,"t",9999.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1.5,0,2,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=160,["y"]=192,["begin"]=244,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if (o.fx or 0)==(200) then R.change(o,"sonspeed",1.0,0,1,"正比",100) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=160,["y"]=64,["begin"]=211,["life"]=30,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=107,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(8+math.floor(t/20)*20) then R.change(o,"t",9999.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=0,["begin"]=820,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,2,"正比",120) end
if t==(120) then R.change(o,"sonspeedd",1200.0,0,2,"正比",600) end
if t==(1) then R.change(o,"sonspeed",8.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=224,["y"]=64,["begin"]=940,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(16+math.floor(t/30)*30) then R.change(o,"t",9999.0,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",90.0,0,1,"正比",300) end
if t==(1) then R.change(o,"sonspeed",1.0,0,2,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(90) then R.change(o,"sonspeed",-0.01,0,0,"正比",21) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=224,["y"]=96,["begin"]=940,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/16)*16) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(8+math.floor(t/16)*16) then R.change(o,"t",9999.0,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",60.0,0,2,"正比",300) end
if t==(1) then R.change(o,"sonspeed",1.0,0,1,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",-0.01,0,0,"正比",21) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=224,["y"]=192,["begin"]=940,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",-0.01,0,0,"正比",21) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=0,["begin"]=2221,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,1,"正比",120) end
if t==(120) then R.change(o,"sonspeedd",1200.0,0,1,"正比",600) end
if t==(1) then R.change(o,"sonspeed",8.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=11,["Bindwithspeedd"]=true,["x"]=352,["y"]=96,["begin"]=2341,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=92,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(80) then R.change(o,"fdirection",90.0,0,2,"正比",180) end
if t==(1) then R.change(o,"sonspeed",4.0,0,2,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(40) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=32,["begin"]=2221,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,2,"正比",120) end
if t==(120) then R.change(o,"sonspeedd",1200.0,0,2,"正比",600) end
if t==(1) then R.change(o,"sonspeed",9.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=352,["y"]=160,["begin"]=2341,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.0,0,1,"正比",300) end
if t==(1+math.floor(t/36)*36) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(12+math.floor(t/36)*36) then R.change(o,"t",0.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=352,["y"]=192,["begin"]=2341,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,0,2,"正比",300) end
if t==(1+math.floor(t/36)*36) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(10+math.floor(t/36)*36) then R.change(o,"t",0.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=11,["Bindwithspeedd"]=true,["x"]=352,["y"]=128,["begin"]=2341,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=17,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=0,["begin"]=2921,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,1,"正比",120) end
if t==(121) then R.change(o,"sonspeedd",1200.0,0,1,"正比",600) end
if t==(1) then R.change(o,"sonspeed",9.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=18,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=32,["begin"]=2921,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=63,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,2,"正比",120) end
if t==(121) then R.change(o,"sonspeedd",1200.0,0,2,"正比",600) end
if t==(1) then R.change(o,"sonspeed",8.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=19,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=96,["begin"]=3041,["life"]=300,["fx"]=316,["fy"]=240,["r"]=250,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=4,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",250.0,0,1,"正比",320) end
if t==(1) then R.change(o,"sonspeed",3.4,0,2,"正比",320) end
if t==(1) then R.change(o,"fdirection",250.0,0,1,"正比",320) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=20,["parentid"]=1,["Binding"]=false,["bindid"]=18,["Bindwithspeedd"]=true,["x"]=416,["y"]=128,["begin"]=3041,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1222,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=110,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.0,0,1,"正比",200) end
if t==(1+math.floor(t/20)*20) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(16+math.floor(t/20)*20) then R.change(o,"t",9999.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=21,["parentid"]=1,["Binding"]=false,["bindid"]=18,["Bindwithspeedd"]=true,["x"]=416,["y"]=160,["begin"]=3041,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1222,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=60,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"sonspeed",0.1,0,1,"正比",1) end
if t==(8+math.floor(t/20)*20) then R.change(o,"t",9999.0,0,0,"正比",1) end
if t==(1+math.floor(t/20)*20) then R.change(o,"t",2.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=22,["parentid"]=1,["Binding"]=false,["bindid"]=18,["Bindwithspeedd"]=true,["x"]=416,["y"]=224,["begin"]=3041,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
end},
{["id"]=23,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=352,["y"]=224,["begin"]=2341,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
end},
{["id"]=24,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=96,["begin"]=3781,["life"]=60,["fx"]=316,["fy"]=240,["r"]=33,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1080.0,0,1,"正比",60) end
if t==(1) then R.change(o,"r",480.0,0,1,"正比",60) end
if t==(1) then R.change(o,"rdirection",1080.0,0,1,"正比",60) end
if t==(1+math.floor(t/3)*3) then R.fire(o) end
if t==(2+math.floor(t/3)*3) then R.fire(o) end
if t==(3+math.floor(t/3)*3) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(10) then R.change(o,"Invincible",1.0,0,0,"正比",1) end
end},
{["id"]=25,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=128,["begin"]=3781,["life"]=60,["fx"]=316,["fy"]=240,["r"]=60,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1080.0,0,1,"正比",60) end
if t==(1) then R.change(o,"r",480.0,0,1,"正比",60) end
if t==(1) then R.change(o,"rdirection",1080.0,0,1,"正比",60) end
if t==(1+math.floor(t/3)*3) then R.fire(o) end
if t==(2+math.floor(t/3)*3) then R.fire(o) end
if t==(3+math.floor(t/3)*3) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(10) then R.change(o,"Invincible",1.0,0,0,"正比",1) end
end},
{["id"]=26,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=160,["begin"]=3781,["life"]=60,["fx"]=316,["fy"]=240,["r"]=50,["rdirection"]=5,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=185,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1080.0,0,1,"正比",60) end
if t==(1) then R.change(o,"r",480.0,0,1,"正比",60) end
if t==(1) then R.change(o,"rdirection",1080.0,0,1,"正比",60) end
if t==(1+math.floor(t/3)*3) then R.fire(o) end
if t==(2+math.floor(t/3)*3) then R.fire(o) end
if t==(3+math.floor(t/3)*3) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(10) then R.change(o,"Invincible",1.0,0,0,"正比",1) end
end},
{["id"]=27,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=192,["begin"]=3781,["life"]=60,["fx"]=316,["fy"]=240,["r"]=50,["rdirection"]=5,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=185,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1080.0,0,1,"正比",60) end
if t==(1) then R.change(o,"r",480.0,0,1,"正比",60) end
if t==(1) then R.change(o,"rdirection",1080.0,0,1,"正比",60) end
if t==(1+math.floor(t/3)*3) then R.fire(o) end
if t==(2+math.floor(t/3)*3) then R.fire(o) end
if t==(3+math.floor(t/3)*3) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(10) then R.change(o,"Invincible",1.0,0,0,"正比",1) end
end},
{["id"]=28,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=416,["begin"]=660,["life"]=3061,["fx"]=315,["fy"]=245,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=700,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=235,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=29,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=96,["begin"]=1641,["life"]=300,["fx"]=316,["fy"]=240,["r"]=250,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=4,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",460.0,0,1,"正比",360) end
if t==(1) then R.change(o,"sonspeed",2.0,0,1,"正比",360) end
if t==(1) then R.change(o,"fdirection",460.0,0,1,"正比",360) end
if t==(1+math.floor(t/20)*20) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"t",99999.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=30,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=128,["begin"]=1641,["life"]=300,["fx"]=316,["fy"]=240,["r"]=250,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=4,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",460.0,0,1,"正比",360) end
if t==(1) then R.change(o,"sonspeed",1.7,0,2,"正比",360) end
if t==(1) then R.change(o,"fdirection",460.0,0,1,"正比",360) end
if t==(1+math.floor(t/20)*20) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"t",99999.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"sonspeed",0.01,0,0,"正比",21) end
end},
{["id"]=31,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=0,["begin"]=1520,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,1,"正比",120) end
if t==(120) then R.change(o,"sonspeedd",1200.0,0,1,"正比",600) end
if t==(1) then R.change(o,"sonspeed",9.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=32,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=32,["begin"]=1520,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",10.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.01,0,2,"正弦",119) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.01,0,1,"正弦",119) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",300.0,0,2,"正比",120) end
if t==(120) then R.change(o,"sonspeedd",1200.0,0,2,"正比",600) end
if t==(1) then R.change(o,"sonspeed",8.0,0,0,"正比",120) end
if t==(420) then R.change(o,"sonspeed",6.0,0,1,"正比",60) end
end},
{["id"]=33,["parentid"]=1,["Binding"]=false,["bindid"]=32,["Bindwithspeedd"]=true,["x"]=288,["y"]=192,["begin"]=1640,["life"]=300,["fx"]=316,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",61) end
end},
{["id"]=34,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=224,["begin"]=3781,["life"]=60,["fx"]=316,["fy"]=240,["r"]=70,["rdirection"]=7,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=187,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1080.0,0,1,"正比",60) end
if t==(1) then R.change(o,"r",480.0,0,1,"正比",60) end
if t==(1) then R.change(o,"rdirection",1080.0,0,1,"正比",60) end
if t==(1+math.floor(t/3)*3) then R.fire(o) end
if t==(2+math.floor(t/3)*3) then R.fire(o) end
if t==(3+math.floor(t/3)*3) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(10) then R.change(o,"Invincible",1.0,0,0,"正比",1) end
end},
{["id"]=35,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=256,["begin"]=3781,["life"]=60,["fx"]=316,["fy"]=240,["r"]=50,["rdirection"]=8,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=188,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=254,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1080.0,0,1,"正比",60) end
if t==(1) then R.change(o,"r",480.0,0,1,"正比",60) end
if t==(1) then R.change(o,"rdirection",1080.0,0,1,"正比",60) end
if t==(1+math.floor(t/3)*3) then R.fire(o) end
if t==(2+math.floor(t/3)*3) then R.fire(o) end
if t==(3+math.floor(t/3)*3) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(60) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(10) then R.change(o,"Invincible",1.0,0,0,"正比",1) end
end},
{["id"]=36,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=416,["begin"]=660,["life"]=3061,["fx"]=315,["fy"]=245,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=700,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=37,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=416,["begin"]=660,["life"]=3061,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=700,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=38,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=416,["begin"]=61,["life"]=3061,["fx"]=315,["fy"]=270,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=225,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.05,0,1,"正弦",11) end
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.05,0,1,"正弦",11) end
if t==(1) then R.change(o,"alpha",20.0,10.0,0,"正比",30) end
if t==(31) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"head",0.0,300.0,1,"正比",60) end
end},
{["id"]=39,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=63,["life"]=3061,["fx"]=315,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=96,["wscale"]=0.3,["hscale"]=0.5,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.2,0,1,"正弦",11) end
if t==(1) then R.change(o,"alpha",40.0,10.0,0,"正比",30) end
if t==(31) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"head",0.0,300.0,1,"正比",60) end
end},
{["id"]=0,["parentid"]=1,["x"]=160,["y"]=224,["begin"]=1,["life"]=600,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(660) then R.change(o,"sonspeed",3.0,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=1,["x"]=224,["y"]=224,["begin"]=701,["life"]=600,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1360) then R.change(o,"sonspeed",-3.0,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=1,["x"]=224,["y"]=256,["begin"]=700,["life"]=600,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1360) then R.change(o,"sonspeed",-2.5,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=1,["x"]=224,["y"]=288,["begin"]=700,["life"]=600,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=11,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1360) then R.change(o,"sonspeed",-2.0,0,0,"正比",60) end
end},
{["id"]=4,["parentid"]=1,["x"]=352,["y"]=288,["begin"]=2200,["life"]=800,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2760) then R.change(o,"sonspeed",2.0,0,0,"正比",60) end
end},
{["id"]=5,["parentid"]=1,["x"]=416,["y"]=256,["begin"]=2921,["life"]=900,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=20,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3460) then R.change(o,"sonspeed",2.5,0,0,"正比",120) end
end},
{["id"]=6,["parentid"]=1,["x"]=416,["y"]=288,["begin"]=2921,["life"]=900,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=21,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3460) then R.change(o,"sonspeed",1.5,0,0,"正比",60) end
end},
{["id"]=7,["parentid"]=1,["x"]=416,["y"]=320,["begin"]=2921,["life"]=800,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=22,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3580) then R.change(o,"sonspeed",3.0,0,0,"正比",120) end
end},
{["id"]=8,["parentid"]=1,["x"]=416,["y"]=352,["begin"]=2921,["life"]=800,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=23,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3460) then R.change(o,"sonspeed",1.5,0,0,"正比",120) end
end},
{["id"]=9,["parentid"]=1,["x"]=480,["y"]=320,["begin"]=3721,["life"]=600,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3900) then R.change(o,"sonspeed",0.3,0.2,0,"正比",120) end
end},
{["id"]=10,["parentid"]=1,["x"]=320,["y"]=224,["begin"]=3661,["life"]=1460,["halfw"]=15,["halfh"]=15,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"life",0.0,0,0,"正比",1) end
end},
{["id"]=11,["parentid"]=1,["x"]=288,["y"]=224,["begin"]=1521,["life"]=700,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2060) then R.change(o,"sonspeed",2.5,0,0,"正比",60) end
end}
}}
