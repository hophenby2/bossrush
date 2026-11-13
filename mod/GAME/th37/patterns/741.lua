-- 离线展开：b741.xna；事件均已编译为Lua条件和调用。
return {id="741",total=6400,centerAvailable=true,center={315,145,0,0,0,0},centerEvents=function(o,t,R)
if t==(1) then R.move(o,315,315,145,145) end
end,globalEvents=function(c,t,R)

end,types={{0,0,90,127,45,63,20,0},{91,0,90,127,45,63,20,0},{182,0,90,127,43,63,20,0},{270,0,26,45,12,22,4,0},{296,0,36,46,18,23,4,0},{332,0,39,51,19,25,5,0},{371,0,21,31,10,15,2,0},{0,127,257,256,136,218,1,0},{257,127,257,256,120,228,1,0},{263,383,89,81,44,40,1,0},{185,383,78,136,39,68,1,0},{0,383,185,157,82,78,1,0},{567,200,172,89,86,89,1,0},{567,289,241,178,125,89,1,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=61,["life"]=6300,["fx"]=-99998,["fy"]=700,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fy",600.0,0,0,"正比",300) end
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=128,["y"]=256,["begin"]=1,["life"]=6360,["fx"]=-99998,["fy"]=-99998,["r"]=60,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=220,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.03,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,90.0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",20.0,0,0,"正弦",440) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=160,["y"]=160,["begin"]=62,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=288,["y"]=160,["begin"]=62,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=160,["y"]=256,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=40,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,90.0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正弦",360) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=256,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=242,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(1) then R.change(o,"sonspeed",-3.0,0,0,"正比",91) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=384,["y"]=256,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=65,["type"]=224,["wscale"]=23,["hscale"]=23,["colorR"]=35,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",8.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,0,0,"正比",60) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=61,["life"]=6300,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=49,["wscale"]=0.1,["hscale"]=43,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=20,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",20.0,0,0,"正比",60) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=192,["y"]=256,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=9,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=40,["tiao"]=0,["t"]=0,["fdirection"]=50,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=416,["y"]=256,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=65,["type"]=242,["wscale"]=0.05,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,0,0,"正比",60) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=256,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=65,["type"]=242,["wscale"]=3,["hscale"]=3,["colorR"]=125,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,0,0,"正比",60) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=320,["y"]=288,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=142,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=1.3,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",41.0,0,2,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",115.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(61) then R.change(o,"sonspeed",13.5,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=320,["y"]=320,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=140,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,2,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",105.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",50) end
if t==(61) then R.change(o,"sonspeed",11.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=320,["y"]=352,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=120,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,2,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",100.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
if t==(61) then R.change(o,"sonspeed",8.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=288,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=142,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=1.3,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",41.0,0,1,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",115.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(61) then R.change(o,"sonspeed",13.5,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=15,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=320,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=140,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,1,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",105.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",50) end
if t==(61) then R.change(o,"sonspeed",11.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=16,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=352,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=120,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,1,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",100.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
if t==(61) then R.change(o,"sonspeed",8.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=17,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=384,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=60,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=3,["hscale"]=3.2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(72) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
if t==(68) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=18,["parentid"]=0,["Binding"]=false,["bindid"]=22,["Bindwithspeedd"]=false,["x"]=256,["y"]=256,["begin"]=126,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=300,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1620,["type"]=1,["wscale"]=0.1,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=4,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"colorG",255.0,0,0,"正比",55) end
if t==(2) then R.change(o,"hscale",1.0,0,0,"正比",33) end
if t==(3) then R.change(o,"sonspeed",0.66,0,0,"正比",31) end
if t==(2) then R.change(o,"wscale",1.0,0,0,"正比",33) end
if t==(2) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(2) then R.change(o,"alpha",100.0,0,0,"正比",55) end
end},
{["id"]=19,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=256,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=9,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.015,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=15,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=30,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=20,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=224,["y"]=160,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=60,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,1,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,2,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(70) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(69) then R.change(o,"head",2.0,0,1,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,1,"正比",9) end
if t==(60) then R.change(o,"Afterimage",1.0,0,0,"正比",1) end
end},
{["id"]=21,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=160,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=60,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,2,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,1,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(70) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(69) then R.change(o,"head",2.0,0,2,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,2,"正比",9) end
if t==(60) then R.change(o,"Afterimage",1.0,0,0,"正比",1) end
end},
{["id"]=22,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=192,["y"]=160,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,1,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,2,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(69) then R.change(o,"head",2.0,0,1,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,1,"正比",9) end
end},
{["id"]=23,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=320,["y"]=160,["begin"]=62,["life"]=6299,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,2,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,1,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(69) then R.change(o,"head",2.0,0,2,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,2,"正比",9) end
end},
{["id"]=24,["parentid"]=0,["Binding"]=false,["bindid"]=22,["Bindwithspeedd"]=false,["x"]=288,["y"]=256,["begin"]=126,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=23,["t"]=300,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=230,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1620,["type"]=1,["wscale"]=0.1,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=4,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"colorG",255.0,0,0,"正比",55) end
if t==(2) then R.change(o,"hscale",1.0,0,0,"正比",33) end
if t==(3) then R.change(o,"sonspeed",0.88,0,0,"正比",31) end
if t==(2) then R.change(o,"wscale",1.0,0,0,"正比",33) end
if t==(2) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(2) then R.change(o,"alpha",100.0,0,0,"正比",55) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=211,["life"]=6150,["fx"]=-99998,["fy"]=-150,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fy",-100.0,0,0,"正比",300) end
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=128,["y"]=224,["begin"]=1,["life"]=6360,["fx"]=-99998,["fy"]=-99998,["r"]=60,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=220,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.03,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,90.0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",20.0,0,0,"正弦",440) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=160,["y"]=128,["begin"]=212,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=288,["y"]=128,["begin"]=212,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=160,["y"]=224,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=40,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,90.0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",15.0,0,0,"正比",360) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=480,["y"]=224,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=242,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(1) then R.change(o,"sonspeed",-3.0,0,0,"正比",91) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=384,["y"]=224,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=65,["type"]=224,["wscale"]=23,["hscale"]=23,["colorR"]=35,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",8.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,0,0,"正比",60) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=211,["life"]=6150,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=49,["wscale"]=0.1,["hscale"]=43,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=20,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",20.0,0,0,"正比",60) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=192,["y"]=224,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=9,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=40,["tiao"]=0,["t"]=0,["fdirection"]=50,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=224,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=180,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=65,["type"]=242,["wscale"]=0.05,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",8.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=448,["y"]=224,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=180,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=65,["type"]=242,["wscale"]=3,["hscale"]=3,["colorR"]=125,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",8.0,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=416,["y"]=288,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=142,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=1.3,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.5,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",41.0,0,2,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",105.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(61) then R.change(o,"sonspeed",15.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=416,["y"]=320,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=140,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,2,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",105.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",50) end
if t==(61) then R.change(o,"sonspeed",13.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=416,["y"]=352,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=120,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,2,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",100.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
if t==(61) then R.change(o,"sonspeed",8.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=288,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=142,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=1.3,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.5,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",41.0,0,1,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",105.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(61) then R.change(o,"sonspeed",15.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=320,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=140,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,1,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",105.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",50) end
if t==(61) then R.change(o,"sonspeed",13.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=352,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=120,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",7.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeedd",50.0,0,1,"正比",15) end
if t==(72) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",100.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
if t==(61) then R.change(o,"sonspeed",8.0,0,0,"正比",1) end
if t==(68) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=17,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=384,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=60,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=200,["wscale"]=3,["hscale"]=3.5,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.0,0,0,"正比",1200) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(72) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
if t==(68) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(72) then R.change(o,"sonspeed",2.0,0,0,"正比",21) end
end},
{["id"]=18,["parentid"]=1,["Binding"]=false,["bindid"]=22,["Bindwithspeedd"]=false,["x"]=256,["y"]=224,["begin"]=282,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=300,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1620,["type"]=1,["wscale"]=0.1,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=4,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"colorG",255.0,0,0,"正比",55) end
if t==(3) then R.change(o,"sonspeed",0.66,0,0,"正比",31) end
if t==(2) then R.change(o,"hscale",1.0,0,0,"正比",33) end
if t==(2) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(2) then R.change(o,"wscale",1.0,0,0,"正比",33) end
if t==(2) then R.change(o,"alpha",100.0,0,0,"正比",55) end
end},
{["id"]=19,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=224,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=9,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.015,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=15,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=30,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=20,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=224,["y"]=128,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=60,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.5,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,1,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,2,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",61) end
if t==(69) then R.change(o,"head",2.0,0,1,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,1,"正比",9) end
if t==(60) then R.change(o,"Afterimage",1.0,0,0,"正比",1) end
end},
{["id"]=21,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=128,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=60,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.5,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,2,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,1,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",61) end
if t==(69) then R.change(o,"head",2.0,0,2,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,2,"正比",9) end
if t==(60) then R.change(o,"Afterimage",1.0,0,0,"正比",1) end
end},
{["id"]=22,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=192,["y"]=128,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.5,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,1,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,2,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(69) then R.change(o,"head",2.0,0,1,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,1,"正比",9) end
end},
{["id"]=23,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=320,["y"]=128,["begin"]=212,["life"]=6149,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeed",6.5,0,0,"正比",600) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(31) then R.change(o,"hscale",0.05,0,2,"正弦",95) end
if t==(118) then R.change(o,"head",1.0,0,2,"正弦",80) end
if t==(1) then R.change(o,"head",30.0,0,1,"正比",50) end
if t==(1) then R.change(o,"sonspeed",-2.0,0,0,"正比",91) end
if t==(69) then R.change(o,"head",2.0,0,2,"正弦",48) end
if t==(60) then R.change(o,"head",30.0,0,2,"正比",9) end
end},
{["id"]=24,["parentid"]=1,["Binding"]=false,["bindid"]=22,["Bindwithspeedd"]=false,["x"]=288,["y"]=224,["begin"]=282,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=23,["t"]=300,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=230,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1620,["type"]=1,["wscale"]=0.1,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=4,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"colorG",255.0,0,0,"正比",55) end
if t==(3) then R.change(o,"sonspeed",0.88,0,0,"正比",31) end
if t==(2) then R.change(o,"hscale",1.0,0,0,"正比",33) end
if t==(2) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(2) then R.change(o,"wscale",1.0,0,0,"正比",33) end
if t==(2) then R.change(o,"alpha",100.0,0,0,"正比",55) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=32,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=180,["r"]=450,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=8,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",330.0,0,0,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(41) then R.change(o,"alpha",1.0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=64,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=180,["r"]=450,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=8,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",380.0,0,0,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(41) then R.change(o,"alpha",1.0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=96,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=140,["r"]=450,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=80,["rdirection"]=40,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",380.0,0,0,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(31) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=32,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=340,["r"]=450,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=8,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",330.0,0,0,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(41) then R.change(o,"alpha",1.0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=64,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=340,["r"]=450,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=8,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",380.0,0,0,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(41) then R.change(o,"alpha",1.0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=96,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=340,["r"]=450,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=80,["rdirection"]=40,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",380.0,0,0,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.5,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(31) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
end}
}}
