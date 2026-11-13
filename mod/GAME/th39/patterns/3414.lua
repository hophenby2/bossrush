return {["id"]="3414",["total"]=2200,["order"]=1,["centerAvailable"]=true,["center"]={480,168,0,0,0,0},["types"]={{0,0,200,200,98,150,0,0,1,0,0,0,0,0,0,"3-3WuDing"},{200,0,200,200,99,150,0,0,1,0,0,0,0,0,0,"3-3WuDing"},{0,0,200,200,98,150,0,0,1,0,0,0,0,0,0,"3-3WuDing"},{200,0,200,112,99,150,0,0,1,0,0,0,0,0,0,"3-3WuDing"}},centerEvents=function(o,t,R)
if t==(60) then R.sound("ch03") end
if t==(210) then R.sound("ch03") end
if t==(360) then R.sound("ch03") end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=121,["life"]=440,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=13,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=147,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
if t==(41+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=608,["y"]=328,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=66,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,0,2,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",3,0,1,"正比",160) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=121,["life"]=440,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=13,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=147,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
if t==(41+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=608,["y"]=296,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=2,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=66,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"range",24,0,1,"正比",5) end
if t==(1) then R.change(o,"sonspeed",2.4,0,2,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",3,0,1,"正比",160) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=672,["y"]=264,["begin"]=1,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=82,["wscale"]=1,["longs"]=330,["alpha"]=100,["Ray"]="Line",["sonspeed"]=6.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=true,["Invincible"]=false,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3,0,1,"正比",160) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=121,["life"]=440,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=13,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=147,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
if t==(41+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=121,["life"]=440,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=9999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=80,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=13,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=210,["colorB"]=55,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
if t==(41+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,20,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3,2,0,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=121,["life"]=440,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=13,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=147,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
if t==(41+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=608,["y"]=264,["begin"]=1,["life"]=6,["fx"]=-99998,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=2,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=65,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"range",18,0,1,"正比",6) end
if t==(1) then R.change(o,"sonspeed",3,0,2,"正比",6) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",3,0,1,"正比",160) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=218,["begin"]=61,["life"]=440,["fx"]=-99998,["fy"]=178,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=13,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=45,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=10,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.change(o,"t",1,0,0,"正比",1) end
if t==(50+math.floor(t/150)*150) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",-4,1,0,"正比",1) end
if t==(2) then R.change(o,"alpha",40,20,0,"正比",10) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=121,["life"]=440,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=13,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=12,["type"]=147,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
if t==(41+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",12) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=121,["life"]=440,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=18,["t"]=9999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=310,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=510,["type"]=58,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=-7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
if t==(41+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",-4,0,0,"正比",30) end
end}
}}
