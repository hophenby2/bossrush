-- 离线展开：b489.xna；事件均已编译为Lua条件和调用。
return {id="489",total=360,centerAvailable=true,center={315,140,0,0,0,0},centerEvents=function(o,t,R)
if t==(121) then R.move(o,270,360,124,176) end
if t==(301) then R.move(o,270,360,124,176) end
end,globalEvents=function(c,t,R)

end,types={{0,0,50,50,25,24,15,0},{50,0,50,50,25,25,15,0},{100,0,31,43,16,20,5,0},{132,0,17,12,8,6,1,3},{132,12,17,12,8,6,2,1},{132,24,17,12,8,6,2,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=61,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=219,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(3) then R.change(o,"tiao",1.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",3) end
if t==(1) then R.change(o,"tiao",1.0,0,1,"正比",1) end
if t==(2) then R.change(o,"tiao",1.0,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",2400.0,0,2,"正比",1200) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=150,["life"]=181,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=21,["t"]=60,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=218,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",2400.0,0,1,"正比",1200) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=61,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=51,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=233,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3.0,0,2,"正比",20) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,1,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(3) then R.change(o,"rdirection",120.0,0,2,"正比",21) end
if t==(2) then R.change(o,"fdirection",60.0,0,1,"正比",1) end
if t==(3) then R.change(o,"fdirection",360.0,0,2,"正比",31) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,1.0,0,"正比",61) end
if t==(2) then R.change(o,"head",6666.0,0,1,"正比",1200) end
if t==(1) then R.change(o,"head",0.0,360.0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=15,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=51,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=233,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3.0,0,2,"正比",20) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,2,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(3) then R.change(o,"rdirection",120.0,0,1,"正比",21) end
if t==(2) then R.change(o,"fdirection",60.0,0,2,"正比",1) end
if t==(3) then R.change(o,"fdirection",360.0,0,1,"正比",31) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.0,1.0,0,"正比",61) end
if t==(2) then R.change(o,"head",6666.0,0,2,"正比",1200) end
if t==(1) then R.change(o,"head",0.0,360.0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=181,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=51,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3.0,0,2,"正比",20) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,1,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(3) then R.change(o,"rdirection",120.0,0,2,"正比",21) end
if t==(2) then R.change(o,"fdirection",60.0,0,1,"正比",1) end
if t==(3) then R.change(o,"fdirection",360.0,0,2,"正比",31) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,1.0,0,"正比",61) end
if t==(2) then R.change(o,"head",6666.0,0,1,"正比",1200) end
if t==(1) then R.change(o,"head",0.0,360.0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=205,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=51,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3.0,0,2,"正比",20) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"rdirection",60.0,0,2,"正比",1) end
if t==(3) then R.change(o,"t",1.0,0,0,"正比",1) end
if t==(3) then R.change(o,"rdirection",120.0,0,1,"正比",21) end
if t==(2) then R.change(o,"fdirection",60.0,0,2,"正比",1) end
if t==(3) then R.change(o,"fdirection",360.0,0,1,"正比",31) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.0,1.0,0,"正比",61) end
if t==(2) then R.change(o,"head",6666.0,0,2,"正比",1200) end
if t==(1) then R.change(o,"head",0.0,360.0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=39,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=34,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4.0,0,0,"正比",120) end
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"r",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=180,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=39,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=39,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4.0,0,0,"正比",120) end
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"r",0.0,0,0,"正比",120) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end}
}}
