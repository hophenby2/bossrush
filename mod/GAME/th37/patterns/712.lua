-- 离线展开：b712.xna；事件均已编译为Lua条件和调用。
return {id="712",total=900,centerAvailable=true,center={315,176,0,0,0,0},centerEvents=function(o,t,R)
if t==(1) then R.move(o,316,316,60,60) end
if t==(61) then R.change(o,"speedd",0.0,0,0,"固定",1) end
if t==(61) then R.change(o,"speed",5.2,0,0,"正比",1) end
if t==(60) then R.change(o,"speedd",360.0,0,1,"正比",240) end
if t==(280) then R.change(o,"speed",0.0,0,0,"正比",18) end
if t==(301) then R.move(o,316,316,60,60) end
if t==(361) then R.change(o,"speedd",180.0,0,0,"固定",1) end
if t==(361) then R.change(o,"speed",5.2,0,0,"正比",1) end
if t==(360) then R.change(o,"speedd",360.0,0,2,"正比",240) end
if t==(580) then R.change(o,"speed",0.0,0,0,"正比",61) end
if t==(660) then R.move(o,314,316,120,120) end
if t==(720) then R.move(o,314,316,120,120) end
end,globalEvents=function(c,t,R)

end,types={},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=63,["life"]=240,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=3,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/10)*10) then R.change(o,"sonspeed",1.0,0,1,"正比",9) end
if t==(1+math.floor(t/10)*10) then R.change(o,"sonspeed",1.0,0,2,"正比",1) end
if t==(1+math.floor(t/10)*10) then R.change(o,"fdirection",15.0,0,2,"正比",10) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=63,["life"]=230,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=5,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=80,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=11,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=361,["life"]=240,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=3,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=185,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2+math.floor(t/10)*10) then R.change(o,"sonspeed",1.0,0,1,"正比",9) end
if t==(1+math.floor(t/10)*10) then R.change(o,"sonspeed",1.0,0,2,"正比",1) end
if t==(1+math.floor(t/10)*10) then R.change(o,"fdirection",15.0,0,1,"正比",10) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=361,["life"]=230,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=80,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=11,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,2,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=721,["life"]=120,["fx"]=-99998,["fy"]=175,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=18,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=35,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",900.0,0,1,"正比",120) end
if t==(1) then R.change(o,"sonspeed",6.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)

end}
}}
