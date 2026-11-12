-- 离线展开：b654.xna；事件均已编译为Lua条件和调用。
return {id="654",total=6080,centerAvailable=true,center={315,145,0,0,0,0},centerEvents=function(o,t,R)
if t==(1) then R.move(o,315,315,145,145) end
if t==(120) then R.move(o,260,370,146,142) end
if t==(240) then R.move(o,260,370,146,142) end
if t==(360) then R.move(o,260,370,146,142) end
if t==(480) then R.move(o,260,370,146,142) end
if t==(600) then R.move(o,260,370,146,142) end
if t==(720) then R.move(o,260,370,146,142) end
if t==(840) then R.move(o,260,370,146,142) end
if t==(960) then R.move(o,260,370,146,142) end
if t==(1120) then R.move(o,260,370,146,142) end
if t==(1240) then R.move(o,260,370,146,142) end
if t==(1360) then R.move(o,260,370,146,142) end
if t==(1480) then R.move(o,260,370,146,142) end
if t==(1600) then R.move(o,260,370,146,142) end
if t==(1720) then R.move(o,260,370,146,142) end
if t==(1840) then R.move(o,260,370,146,142) end
if t==(1960) then R.move(o,260,370,146,142) end
if t==(2041) then R.move(o,315,315,145,145) end
if t==(2111) then R.move(o,315,315,145,145) end
end,globalEvents=function(c,t,R)

end,types={{0,0,40,40,20,20,8,0},{40,0,40,40,20,20,8,0},{80,0,40,40,20,20,8,0},{120,0,40,40,20,20,8,0},{160,0,28,43,13,21,5,0},{0,40,56,62,28,36,15,0},{56,41,56,62,28,36,15,0},{112,40,28,28,14,14,5,0},{112,68,28,28,14,14,5,0},{140,43,35,21,17,11,5,0},{140,64,35,21,17,11,5,0},{0,102,388,388,194,194,50,0},{460,0,45,45,22,22,3,0},{505,0,45,45,22,22,3,0},{550,0,45,45,22,22,3,0},{595,0,45,45,22,22,3,0},{460,45,45,45,22,22,3,0},{505,45,45,45,22,22,3,0},{550,45,45,45,22,22,3,0},{595,45,45,45,22,22,3,0},{460,90,45,45,22,22,3,0},{505,90,45,45,22,22,3,0},{550,90,45,45,22,22,3,0},{595,90,45,45,22,22,3,0},{460,135,45,45,22,22,3,0},{505,135,45,45,22,22,3,0},{550,135,45,45,22,22,3,0},{595,135,45,45,22,22,3,0},{388,180,248,141,124,130,0,0},{388,321,248,141,124,130,0,0},{388,462,248,141,124,130,0,0},{188,0,45,59,23,30,4,0},{234,0,48,42,24,21,5,0},{234,42,56,50,28,25,5,0},{291,42,56,50,28,25,5,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=384,["begin"]=401,["life"]=5280,["fx"]=-99998,["fy"]=12,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=229,["wscale"]=1.4,["hscale"]=1.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/160)*160) then R.change(o,"r",230.0,0,1,"正弦",159) end
if t==(1+math.floor(t/60)*60) then R.change(o,"fdirection",5.0,0,1,"正弦",59) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.5,0,1,"正弦",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
if t==(1) then R.change(o,"yscale",3.0,0,0,"正比",240) end
if t==(1+math.floor(t/45)*45) then R.change(o,"head",90.0,0,1,"正比",45) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=401,["life"]=5280,["fx"]=-99998,["fy"]=12,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=177,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/160)*160) then R.change(o,"r",230.0,0,1,"正弦",159) end
if t==(1+math.floor(t/60)*60) then R.change(o,"fdirection",5.0,0,1,"正弦",59) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.5,0,1,"正弦",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorB",100.0,50.0,1,"正比",1) end
if t==(1) then R.change(o,"yscale",3.0,0,0,"正比",240) end
if t==(1+math.floor(t/45)*45) then R.change(o,"head",90.0,0,1,"正比",45) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=401,["life"]=5280,["fx"]=-99998,["fy"]=12,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=19,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=232,["wscale"]=1.4,["hscale"]=1.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/160)*160) then R.change(o,"r",230.0,0,1,"正弦",159) end
if t==(1+math.floor(t/60)*60) then R.change(o,"fdirection",5.0,0,1,"正弦",59) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.5,0,1,"正弦",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorB",200.0,88.0,0,"正比",1) end
if t==(1) then R.change(o,"yscale",3.0,0,0,"正比",240) end
if t==(1) then R.change(o,"colorG",200.0,88.0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=384,["y"]=160,["begin"]=151,["life"]=5900,["fx"]=-99998,["fy"]=-99998,["r"]=50,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=259,["wscale"]=0.1,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",8.0,0,1,"正弦",119) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",12) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=173,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=140,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=240,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.6,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(150) then R.change(o,"hscale",0.4,0,0,"正比",10) end
if t==(1) then R.change(o,"sonspeed",0.001,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",60) end
if t==(150) then R.change(o,"wscale",0.4,0,0,"正比",10) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",120.0,0,1,"正比",120) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=128,["begin"]=1,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=29,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=178,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",111.0,0,1,"正比",22) end
if t==(120) then R.change(o,"sonspeed",5.0,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=128,["begin"]=1,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=29,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=177,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",111.0,0,1,"正比",22) end
if t==(120) then R.change(o,"sonspeed",4.0,0,0,"正比",60) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=128,["begin"]=1,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=29,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=178,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",111.0,0,1,"正比",22) end
if t==(120) then R.change(o,"sonspeed",3.0,0,0,"正比",60) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=128,["begin"]=1,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=29,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=177,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",111.0,0,1,"正比",22) end
if t==(120) then R.change(o,"sonspeed",2.0,0,0,"正比",60) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=721,["life"]=1,["fx"]=-99998,["fy"]=54,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=218,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.002,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"r",360.0,0,1,"正弦",179) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",40.0,0,1,"正比",22) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",15) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=320,["begin"]=1,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=240,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/222)*222) then R.change(o,"head",222.0,0,1,"正比",222) end
if t==(1) then R.change(o,"hscale",0.9,0,0,"正比",240) end
if t==(1) then R.change(o,"wscale",0.9,0,0,"正比",240) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=352,["begin"]=1,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=240,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/222)*222) then R.change(o,"head",222.0,0,2,"正比",222) end
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",240) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=96,["begin"]=188,["life"]=5230,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=229,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.008,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/120)*120) then R.change(o,"fdirection",130.0,0,1,"正比",58) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,0,"正比",1) end
if t==(62+math.floor(t/120)*120) then R.change(o,"fdirection",130.0,0,2,"正比",58) end
if t==(61+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",40.0,0,1,"正比",22) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",15) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=96,["begin"]=188,["life"]=5230,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=232,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.008,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/120)*120) then R.change(o,"fdirection",130.0,0,1,"正比",58) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,0,"正比",1) end
if t==(62+math.floor(t/120)*120) then R.change(o,"fdirection",130.0,0,2,"正比",58) end
if t==(61+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"colorB",100.0,70.0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",15) end
end},
{["id"]=0,["parentid"]=1,["x"]=128,["y"]=0,["begin"]=1,["life"]=6080,["longs"]=500,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={},["kind"]="rebound",Parentevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["x"]=512,["y"]=0,["begin"]=1,["life"]=6080,["longs"]=500,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={},["kind"]="rebound",Parentevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=120,["life"]=5961,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=60,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=223,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=192,["y"]=64,["begin"]=142,["life"]=5939,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=5,["wscale"]=1,["hscale"]=1,["colorR"]=205,["colorG"]=255,["colorB"]=205,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=9,["y"]=0,["begin"]=1,["life"]=10,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=48,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=124,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=192,["y"]=32,["begin"]=142,["life"]=5939,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=235,["colorG"]=255,["colorB"]=205,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=352,["y"]=32,["begin"]=150,["life"]=5931,["fx"]=-99998,["fy"]=-99998,["r"]=24,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=60,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=225,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=9,["y"]=224,["begin"]=1,["life"]=10,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=48,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=54,["wscale"]=0.2,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",240) end
if t==(1) then R.change(o,"hscale",39.0,0,0,"正比",60) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=9,["y"]=224,["begin"]=1,["life"]=10,["fx"]=-99998,["fy"]=-99998,["r"]=24,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=48,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=53,["wscale"]=0.2,["hscale"]=3,["colorR"]=1,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",240) end
if t==(1) then R.change(o,"hscale",39.0,0,0,"正比",60) end
end}
}}
