-- 离线展开：b490.xna；事件均已编译为Lua条件和调用。
return {id="490",total=900,centerAvailable=true,center={315,240,0,0,0,0},centerEvents=function(o,t,R)
if t==(1) then R.move(o,154,196,170,170) end
if t==(61) then R.change(o,"speedd",30.0,0,0,"固定",1) end
if t==(62) then R.change(o,"speedd",-20.0,0,0,"正比",60) end
if t==(61) then R.change(o,"speed",3.0,0,0,"正比",1) end
if t==(132) then R.change(o,"speed",0.0,0,0,"正比",51) end
if t==(225) then R.change(o,"speedd",150.0,0,0,"固定",1) end
if t==(226) then R.change(o,"speedd",200.0,0,0,"正比",60) end
if t==(225) then R.change(o,"speed",3.0,0,0,"正比",1) end
if t==(306) then R.change(o,"speed",0.0,0,0,"正比",31) end
if t==(370) then R.move(o,295,335,240,180) end
if t==(560) then R.move(o,156,156,240,180) end
if t==(620) then R.move(o,476,476,240,180) end
if t==(680) then R.move(o,226,226,90,160) end
if t==(740) then R.move(o,416,416,90,160) end
end,globalEvents=function(c,t,R)

end,types={{0,0,50,50,25,24,15,0},{50,0,50,50,25,25,15,0},{100,0,31,43,16,20,5,0},{132,0,17,12,8,6,1,3},{132,12,17,12,8,6,2,1},{132,24,17,12,8,6,2,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=560,["life"]=240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=10,["t"]=60,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=135,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.03,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"sonaspeed",0.004,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeed",1.5,0,0,"正比",1) end
if t==(1) then R.change(o,"sonaspeed",0.018,0,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",600.0,0,1,"正比",120) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=560,["life"]=240,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=60,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.03,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"sonaspeed",0.004,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeed",1.2,0,0,"正比",1) end
if t==(1) then R.change(o,"sonaspeed",0.022,0,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",600.0,0,2,"正比",120) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=320,["begin"]=61,["life"]=90,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=218,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0.0015,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",90.0,0,1,"正比",90) end
if t==(1+math.floor(t/7)*7) then R.change(o,"sonspeed",1.4,0,0,"正比",1) end
if t==(2+math.floor(t/7)*7) then R.change(o,"sonspeed",1.6,0,1,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"head",900.0,0,1,"正比",360) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",30) end
if t==(130) then R.change(o,"sonaspeed",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=384,["begin"]=225,["life"]=90,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=300,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=218,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0.0015,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",90.0,0,2,"正比",90) end
if t==(1+math.floor(t/7)*7) then R.change(o,"sonspeed",1.4,0,0,"正比",1) end
if t==(2+math.floor(t/7)*7) then R.change(o,"sonspeed",1.6,0,1,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"head",900.0,0,2,"正比",360) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",30) end
if t==(130) then R.change(o,"sonaspeed",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=560,["life"]=240,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=60,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=105,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"head",1800.0,0,1,"正比",360) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=160,["begin"]=560,["life"]=240,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=60,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=105,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"head",1800.0,0,1,"正比",360) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=61,["life"]=90,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=190,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=233,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=3,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/7)*7) then R.change(o,"sonspeed",1.5,0,2,"正比",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"sonspeed",2.5,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",180.0,0,1,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonaspeed",0.02,0.002,0,"正比",1) end
if t==(1) then R.change(o,"head",9900.0,360.0,1,"正比",1200) end
if t==(60) then R.change(o,"sonaspeed",0.005,0,0,"正比",120) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=384,["begin"]=225,["life"]=90,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=350,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=233,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=3,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/7)*7) then R.change(o,"sonspeed",1.5,0,2,"正比",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"sonspeed",2.5,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",180.0,0,2,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonaspeed",0.02,0.002,0,"正比",1) end
if t==(1) then R.change(o,"head",9900.0,360.0,2,"正比",1200) end
if t==(60) then R.change(o,"sonaspeed",0.005,0,0,"正比",120) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=500,["life"]=1,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=60,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.0,0.6,0,"正比",1) end
if t==(1) then R.change(o,"head",2400.0,360.0,2,"正比",600) end
if t==(120) then R.change(o,"sonaspeed",0.002,0,0,"正比",120) end
if t==(1) then R.change(o,"sonaspeed",0.01,0.006,0,"正比",1) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=320,["begin"]=61,["life"]=90,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=220,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=66,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=3,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/7)*7) then R.change(o,"sonspeed",2.0,0,2,"正比",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",120.0,0,1,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonaspeed",0.02,0.006,0,"正比",1) end
if t==(1) then R.change(o,"head",9000.0,360.0,1,"正比",1200) end
if t==(120) then R.change(o,"sonaspeed",0.007,0,0,"正比",120) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=384,["begin"]=225,["life"]=90,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=320,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=66,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=3,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/7)*7) then R.change(o,"sonspeed",2.0,0,2,"正比",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection",120.0,0,2,"正比",90) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonaspeed",0.02,0.006,0,"正比",1) end
if t==(1) then R.change(o,"head",9000.0,360.0,2,"正比",1200) end
if t==(120) then R.change(o,"sonaspeed",0.007,0,0,"正比",120) end
end}
}}
