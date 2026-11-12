-- 离线展开：b813.xna；事件均已编译为Lua条件和调用。
return {id="813",total=5240,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)
if t==(10) then R.sound("ch000") end
if t==(310) then R.sound("ch000") end
if t==(610) then R.sound("ch000") end
if t==(710) then R.sound("enep03") end
end,globalEvents=function(c,t,R)
if t==720 then R.quake(c,60,7) end
end,types={{0,0,60,54,30,27,8,0},{60,0,64,62,32,31,8,0},{124,0,56,53,28,27,8,0},{180,0,18,24,9,12,1,0},{180,27,17,25,9,13,1,0},{207,24,11,11,5,5,1,0},{0,62,194,194,97,97,70,0},{194,62,192,192,96,96,70,0},{344,256,86,132,43,120,10,0},{430,256,86,132,43,120,10,0},{0,256,344,344,172,172,1,0},{0,600,392,392,196,196,1,0},{344,399,135,168,67,84,1,0},{459,0,45,45,22,18,2,0},{505,0,45,45,22,18,2,0},{550,0,45,45,22,18,2,0},{595,0,45,45,22,18,2,0},{459,45,45,45,22,18,2,0},{505,45,45,45,22,18,2,0},{550,45,45,45,22,18,2,0},{595,45,45,45,22,18,2,0},{460,90,45,45,22,22,3,0},{505,90,45,45,22,22,3,0},{550,90,45,45,22,22,3,0},{595,90,45,45,22,22,3,0},{460,135,45,45,22,22,3,0},{505,135,45,45,22,22,3,0},{550,135,45,45,22,22,3,0},{595,135,45,45,22,22,3,0},{373,0,21,31,10,15,2,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=64,["begin"]=121,["life"]=5,["fx"]=315,["fy"]=106,["r"]=36,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=11,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=100,["colorB"]=50,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=1,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",2.3,0,0,"正比",5) end
if t==(1+math.floor(t/60)*60) then R.change(o,"rdirection",360.0,0,1,"正比",12) end
if t==(1+math.floor(t/60)*60) then R.change(o,"fdirection",360.0,0,1,"正比",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,3600.0,1,"正比",1200) end
if t==(1) then R.change(o,"colorB",255.0,0,0,"正比",81) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.0,0.5,1,"正比",61) end
if t==(1) then R.change(o,"colorG",255.0,0,0,"正比",61) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=192,["begin"]=60,["life"]=5121,["fx"]=315,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=55,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",10.0,20.0,1,"正弦",400) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=32,["begin"]=120,["life"]=3,["fx"]=315,["fy"]=106,["r"]=12,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=232,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=125,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"rdirection",360.0,0,1,"正比",30) end
if t==(1+math.floor(t/60)*60) then R.change(o,"fdirection",360.0,0,1,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,3600.0,1,"正比",200) end
if t==(1) then R.change(o,"sonspeed",2.5,2.0,0,"正比",1) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=1,["life"]=900,["fx"]=-99998,["fy"]=175,["r"]=5,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=112,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,2,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(200) then R.change(o,"colorG",1.0,0,0,"正比",400) end
if t==(200) then R.change(o,"colorB",1.0,0,0,"正比",400) end
if t==(300) then R.change(o,"colorR",1.0,0,0,"正比",500) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=120,["life"]=5031,["fx"]=-99998,["fy"]=175,["r"]=5,["rdirection"]=2,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=229,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,2,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(100) then R.change(o,"colorG",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"colorB",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"alpha",100.0,0,0,"正比",400) end
if t==(100) then R.change(o,"colorR",255.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,190.0,1,"正比",300) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=900,["fx"]=-99998,["fy"]=175,["r"]=25,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=112,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=2,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(200) then R.change(o,"colorG",1.0,0,0,"正比",400) end
if t==(200) then R.change(o,"colorB",1.0,0,0,"正比",400) end
if t==(300) then R.change(o,"colorR",1.0,0,0,"正比",500) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=384,["begin"]=120,["life"]=5061,["fx"]=-99998,["fy"]=175,["r"]=25,["rdirection"]=2,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=229,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=11,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=5,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(100) then R.change(o,"colorG",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"colorB",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"alpha",100.0,0,0,"正比",400) end
if t==(100) then R.change(o,"colorR",255.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,190.0,1,"正比",300) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=1,["life"]=900,["fx"]=-99998,["fy"]=175,["r"]=25,["rdirection"]=40,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=112,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=2,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(200) then R.change(o,"colorG",1.0,0,0,"正比",400) end
if t==(200) then R.change(o,"colorB",1.0,0,0,"正比",400) end
if t==(300) then R.change(o,"colorR",1.0,0,0,"正比",500) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=120,["life"]=5061,["fx"]=-99998,["fy"]=175,["r"]=25,["rdirection"]=30,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=229,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=5,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(100) then R.change(o,"colorG",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"colorB",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"alpha",100.0,0,0,"正比",400) end
if t==(100) then R.change(o,"colorR",255.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,190.0,1,"正比",300) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=120,["life"]=5061,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=50,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=233,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=5,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(100) then R.change(o,"colorG",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"colorB",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"alpha",100.0,0,0,"正比",400) end
if t==(100) then R.change(o,"colorR",255.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,190.0,1,"正比",300) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=448,["begin"]=120,["life"]=5061,["fx"]=315,["fy"]=175,["r"]=0,["rdirection"]=120,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=15,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=232,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=5,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",360.0,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,2,"正比",120) end
if t==(100) then R.change(o,"colorG",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"colorB",255.0,0,0,"正比",300) end
if t==(100) then R.change(o,"alpha",100.0,0,0,"正比",400) end
if t==(100) then R.change(o,"colorR",255.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,190.0,1,"正比",300) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=720,["type"]=241,["wscale"]=21,["hscale"]=21,["colorR"]=255,["colorG"]=15,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",700) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=192,["begin"]=630,["life"]=4501,["fx"]=315,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=240,["wscale"]=1.6,["hscale"]=1.6,["colorR"]=255,["colorG"]=55,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",10.0,20.0,1,"正弦",400) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=256,["begin"]=1,["life"]=1,["fx"]=315,["fy"]=170,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=176,["wscale"]=12,["hscale"]=12,["colorR"]=255,["colorG"]=1,["colorB"]=120,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",120) end
end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=256,["begin"]=301,["life"]=1,["fx"]=315,["fy"]=170,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=174,["wscale"]=12,["hscale"]=12,["colorR"]=255,["colorG"]=111,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",120) end
end},
{["id"]=15,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=256,["begin"]=601,["life"]=1,["fx"]=315,["fy"]=170,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=174,["wscale"]=12,["hscale"]=12,["colorR"]=255,["colorG"]=111,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",120) end
end},
{["id"]=16,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=320,["begin"]=720,["life"]=1,["fx"]=315,["fy"]=170,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=176,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=120,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"wscale",12.0,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",12.0,0,0,"正比",30) end
end},
{["id"]=17,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=320,["begin"]=720,["life"]=1,["fx"]=315,["fy"]=170,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=176,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=120,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",20) end
if t==(1) then R.change(o,"wscale",12.0,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",12.0,0,0,"正比",20) end
end},
{["id"]=18,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=320,["begin"]=720,["life"]=1,["fx"]=315,["fy"]=170,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=200,["colorB"]=120,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",20) end
if t==(1) then R.change(o,"wscale",3.0,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",3.0,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=3,["life"]=5238,["fx"]=-99998,["fy"]=176,["r"]=12,["rdirection"]=2,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=6,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=25,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"rdirection",360.0,0,1,"正比",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"fdirection",360.0,0,1,"正比",30) end
if t==(300) then R.change(o,"colorG",1.0,0,0,"正比",200) end
if t==(450) then R.change(o,"alpha",1.0,0,0,"正比",150) end
if t==(91) then R.change(o,"hscale",1.3,0,0,"正比",200) end
if t==(300) then R.change(o,"colorB",1.0,0,0,"正比",200) end
if t==(91) then R.change(o,"wscale",1.3,0,0,"正比",200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=64,["begin"]=301,["life"]=4940,["fx"]=-99998,["fy"]=176,["r"]=4,["rdirection"]=2,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=6,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=242,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=12,["colorB"]=12,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"rdirection",360.0,0,1,"正比",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"fdirection",360.0,0,1,"正比",30) end
if t==(1) then R.change(o,"colorB",255.0,0,0,"正比",200) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",100) end
if t==(1) then R.change(o,"colorG",255.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=121,["life"]=400,["fx"]=315,["fy"]=176,["r"]=11,["rdirection"]=2,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=6,["fdirection"]=2,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=225,["wscale"]=0.3,["hscale"]=0.6,["colorR"]=255,["colorG"]=11,["colorB"]=1,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"rdirection",360.0,0,1,"正比",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"fdirection",360.0,0,1,"正比",30) end
if t==(101) then R.change(o,"alpha",1.0,0,0,"正比",200) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",100) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=128,["begin"]=1,["life"]=5240,["fx"]=315,["fy"]=176,["r"]=12,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=14,["t"]=24,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=39,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(300) then R.change(o,"colorG",1.0,0,0,"正比",200) end
if t==(450) then R.change(o,"alpha",1.0,0,0,"正比",150) end
if t==(91) then R.change(o,"hscale",1.4,0,0,"正比",200) end
if t==(300) then R.change(o,"colorB",1.0,0,0,"正比",200) end
if t==(91) then R.change(o,"wscale",1.4,0,0,"正比",200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=96,["begin"]=121,["life"]=400,["fx"]=315,["fy"]=176,["r"]=11,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=14,["t"]=24,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=225,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(101) then R.change(o,"alpha",1.0,0,0,"正比",200) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",100) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=64,["begin"]=301,["life"]=4940,["fx"]=315,["fy"]=176,["r"]=17,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=14,["t"]=24,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=246,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=12,["colorB"]=12,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"colorB",255.0,0,0,"正比",200) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",100) end
if t==(2700) then R.change(o,"fdirection",20.0,0,1,"正弦",599) end
if t==(1) then R.change(o,"colorG",255.0,0,0,"正比",200) end
if t==(300) then R.change(o,"fdirection",5.0,0,1,"正弦",599) end
if t==(900) then R.change(o,"fdirection",10.0,0,1,"正弦",599) end
if t==(1500) then R.change(o,"fdirection",20.0,0,1,"正弦",599) end
if t==(2700) then R.change(o,"fdirection",20.0,0,1,"正弦",599) end
if t==(2100) then R.change(o,"fdirection",20.0,0,1,"正弦",599) end
end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=1,["life"]=700,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=44,["type"]=50,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=25,["colorB"]=145,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(30) then R.change(o,"alpha",30.0,10.0,0,"正比",10) end
if t==(30) then R.change(o,"head",0.0,290.0,1,"正比",30) end
if t==(30) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=420,["life"]=260,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=44,["type"]=50,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=25,["colorB"]=145,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(30) then R.change(o,"alpha",40.0,30.0,0,"正比",10) end
if t==(30) then R.change(o,"head",0.0,290.0,1,"正比",30) end
if t==(30) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=120,["life"]=600,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=44,["type"]=50,["wscale"]=1.4,["hscale"]=1.4,["colorR"]=255,["colorG"]=25,["colorB"]=145,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(30) then R.change(o,"alpha",40.0,10.0,0,"正比",10) end
if t==(30) then R.change(o,"head",0.0,290.0,1,"正比",30) end
if t==(30) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=226,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.05,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",6.0,0,0,"正比",60) end
end}
}}
