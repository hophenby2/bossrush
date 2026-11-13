-- 离线展开：b6994.xna；事件均已编译为Lua条件和调用。
return {id="6994",total=240,centerAvailable=true,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,500,500,250,250,0,0},{500,0,500,500,250,250,0,0},{0,500,500,500,250,250,0,0},{800,900,100,100,50,50,0,0},{900,900,100,100,50,50,0,0},{500,800,500,100,-50,50,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=81,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=232,["wscale"]=0.08,["hscale"]=0.15,["colorR"]=255,["colorG"]=215,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",60.0,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(300) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",3.0,2.0,0,"正比",1) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",30) end
if t==(1+math.floor(t/24)*24) then R.change(o,"wscale",0.15,0,0,"正弦",23) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=201,["life"]=5,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=232,["wscale"]=0.08,["hscale"]=0.15,["colorR"]=255,["colorG"]=215,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",60.0,0,2,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(300) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",3.0,2.0,0,"正比",1) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",30) end
if t==(1+math.floor(t/24)*24) then R.change(o,"wscale",0.15,0,0,"正弦",23) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=81,["life"]=5,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=232,["wscale"]=0.12,["hscale"]=0.2,["colorR"]=255,["colorG"]=215,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",60.0,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(300) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",3.0,2.0,0,"正比",1) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",30) end
if t==(1+math.floor(t/35)*35) then R.change(o,"wscale",0.2,0,0,"正弦",34) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=201,["life"]=5,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=232,["wscale"]=0.12,["hscale"]=0.2,["colorR"]=255,["colorG"]=215,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",60.0,0,2,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(300) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",3.0,2.0,0,"正比",1) end
if t==(1) then R.change(o,"alpha",70.0,10.0,0,"正比",30) end
if t==(1+math.floor(t/35)*35) then R.change(o,"wscale",0.2,0,0,"正弦",34) end
end}
}}
