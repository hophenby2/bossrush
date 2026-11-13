-- 离线展开：b492.xna；事件均已编译为Lua条件和调用。
return {id="492",total=420,centerAvailable=true,center={315,140,0,0,0,0},centerEvents=function(o,t,R)
if t==(61) then R.move(o,270,360,124,116) end
end,globalEvents=function(c,t,R)

end,types={{0,0,50,50,25,24,15,0},{50,0,50,50,25,25,15,0},{100,0,32,43,16,20,5,0},{132,0,17,12,8,6,1,3},{132,12,17,12,8,6,2,1},{132,24,17,12,8,6,2,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-30,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=555,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=49,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=233,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,2,"正比",1) end
if t==(2) then R.change(o,"fdirection",120.0,0,2,"正比",1) end
if t==(3) then R.change(o,"fdirection",260.0,0,1,"正比",31) end
if t==(3) then R.change(o,"rdirection",60.0,0,1,"正比",31) end
if t==(1+math.floor(t/6)*6) then R.change(o,"sonspeed",1.0,0,0,"正比",1) end
if t==(2+math.floor(t/6)*6) then R.change(o,"sonspeed",5.0,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/111)*111) then R.change(o,"head",633.0,0,1,"正比",111) end
if t==(1) then R.change(o,"head",0.0,360.0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",121) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=211,["life"]=30,["fx"]=-99998,["fy"]=-30,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=555,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=49,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=234,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,1,"正比",1) end
if t==(2) then R.change(o,"fdirection",120.0,0,1,"正比",1) end
if t==(3) then R.change(o,"fdirection",260.0,0,2,"正比",31) end
if t==(3) then R.change(o,"rdirection",60.0,0,2,"正比",31) end
if t==(1+math.floor(t/6)*6) then R.change(o,"sonspeed",1.0,0,0,"正比",1) end
if t==(2+math.floor(t/6)*6) then R.change(o,"sonspeed",5.0,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/111)*111) then R.change(o,"head",633.0,0,2,"正比",111) end
if t==(1) then R.change(o,"head",0.0,360.0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",121) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=256,["y"]=224,["begin"]=140,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=218,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",20) end
if t==(61) then R.change(o,"sonspeed",1.0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",20) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",240.0,0,1,"正比",120) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=288,["y"]=224,["begin"]=350,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=219,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",20) end
if t==(60) then R.change(o,"sonspeed",1.0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",20) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",240.0,0,2,"正比",120) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-30,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=555,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=49,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=226,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,2,"正比",1) end
if t==(2) then R.change(o,"fdirection",120.0,0,2,"正比",1) end
if t==(3) then R.change(o,"fdirection",260.0,0,1,"正比",31) end
if t==(3) then R.change(o,"rdirection",60.0,0,1,"正比",31) end
if t==(1+math.floor(t/6)*6) then R.change(o,"sonspeed",1.0,0,0,"正比",1) end
if t==(2+math.floor(t/6)*6) then R.change(o,"sonspeed",5.0,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/111)*111) then R.change(o,"head",633.0,0,1,"正比",111) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",121) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=211,["life"]=30,["fx"]=-99998,["fy"]=-30,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=555,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=49,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=225,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=70,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,1,"正比",1) end
if t==(2) then R.change(o,"fdirection",120.0,0,1,"正比",1) end
if t==(3) then R.change(o,"fdirection",260.0,0,2,"正比",31) end
if t==(3) then R.change(o,"rdirection",60.0,0,2,"正比",31) end
if t==(1+math.floor(t/6)*6) then R.change(o,"sonspeed",1.0,0,0,"正比",1) end
if t==(2+math.floor(t/6)*6) then R.change(o,"sonspeed",5.0,0,1,"正比",5) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/111)*111) then R.change(o,"head",633.0,0,2,"正比",111) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",121) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=55,["t"]=42,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=66,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"head",360.0,0,1,"正比",60) end
end}
}}
