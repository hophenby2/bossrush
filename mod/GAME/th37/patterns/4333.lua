-- 离线展开：b4333.xna；事件均已编译为Lua条件和调用。
return {id="4333",total=2800,centerAvailable=true,center={224,-50,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,216,400,200,195,0,0},{216,0,216,400,200,200,0,0},{0,400,30,42,15,21,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=343,["y"]=334,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=343,["y"]=334,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=343,["y"]=334,["begin"]=1,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=343,["y"]=334,["begin"]=21,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=171,["y"]=34,["begin"]=361,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=171,["y"]=34,["begin"]=361,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=171,["y"]=34,["begin"]=361,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=171,["y"]=34,["begin"]=391,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=287,["y"]=34,["begin"]=741,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=287,["y"]=34,["begin"]=741,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=287,["y"]=34,["begin"]=741,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=287,["y"]=34,["begin"]=761,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=112,["y"]=335,["begin"]=1101,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=112,["y"]=335,["begin"]=1101,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=112,["y"]=335,["begin"]=1101,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=15,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=112,["y"]=335,["begin"]=1121,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=16,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=142,["begin"]=1461,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=17,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=142,["begin"]=1461,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=18,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=142,["begin"]=1461,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=19,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=142,["begin"]=1481,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=20,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=279,["y"]=0,["begin"]=1521,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=21,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=279,["y"]=0,["begin"]=1521,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,1,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=22,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=279,["y"]=0,["begin"]=1601,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=23,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=279,["y"]=0,["begin"]=1621,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=24,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=82,["y"]=146,["begin"]=1841,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=25,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=82,["y"]=146,["begin"]=1841,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=26,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=82,["y"]=146,["begin"]=1841,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=27,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=82,["y"]=146,["begin"]=1861,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=28,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=179,["y"]=0,["begin"]=1901,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.22,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,1,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"正弦",19) end
end},
{["id"]=29,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=179,["y"]=0,["begin"]=1901,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=231,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.65,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",240.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",240.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",500) end
if t==(360) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",420) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=30,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=179,["y"]=0,["begin"]=1941,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",55.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=31,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=179,["y"]=0,["begin"]=1961,["life"]=199,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end},
{["id"]=32,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=230,["y"]=0,["begin"]=2100,["life"]=120,["fx"]=-99998,["fy"]=-110,["r"]=260,["rdirection"]=200,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=110,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=820,["type"]=231,["wscale"]=0.23,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.45,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=70,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"fdirection",180.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",880) end
if t==(760) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",80.0,5.0,0,"正比",50) end
if t==(1) then R.change(o,"head",3600.0,1200.0,2,"正比",820) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
end},
{["id"]=33,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=230,["y"]=0,["begin"]=2200,["life"]=559,["fx"]=-99998,["fy"]=-120,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=270,["type"]=230,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",180.0,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",33.0,0,0,"正比",120) end
if t==(150) then R.change(o,"alpha",0.0,0,0,"正比",120) end
end}
}}
