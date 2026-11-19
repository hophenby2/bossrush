-- 离线展开：e30.xna；事件均已编译为Lua条件和调用。
return {id="e30",total=96000,centerAvailable=true,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,500,500,250,250,0,0},{500,0,500,500,250,250,0,0},{0,500,500,500,250,250,0,0},{800,900,100,100,50,50,0,0},{900,900,100,100,50,50,0,0},{500,800,500,100,-20,50,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=160,["begin"]=1,["life"]=60,["fx"]=316,["fy"]=240,["r"]=90,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",1.0,0.9,0,"正比",1) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.3,0,0,"正弦",29) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=192,["begin"]=1,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.11,["hscale"]=0.2,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,0,"正弦",19) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=601,["life"]=60,["fx"]=316,["fy"]=240,["r"]=90,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",1.0,0.9,0,"正比",1) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.3,0,0,"正弦",29) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=601,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.11,["hscale"]=0.2,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,0,"正弦",19) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=160,["begin"]=1201,["life"]=60,["fx"]=316,["fy"]=240,["r"]=90,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.16,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",1.0,0.9,0,"正比",1) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.3,0,0,"正弦",29) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=192,["begin"]=1201,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.11,["hscale"]=0.2,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,0,"正弦",19) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=256,["begin"]=1,["life"]=62,["fx"]=316,["fy"]=240,["r"]=80,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,2,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=224,["begin"]=7,["life"]=62,["fx"]=316,["fy"]=240,["r"]=80,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=601,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,2,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=605,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=256,["begin"]=1201,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=111,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,2,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=224,["begin"]=1205,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=110,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=224,["begin"]=1204,["life"]=62,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",60.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=192,["begin"]=1201,["life"]=94200,["fx"]=316,["fy"]=240,["r"]=220,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.11,["hscale"]=0.2,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=210,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",40.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,0,"正弦",19) end
end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=224,["begin"]=1,["life"]=96000,["fx"]=316,["fy"]=240,["r"]=220,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=210,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",30.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=15,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=288,["begin"]=616,["life"]=95085,["fx"]=316,["fy"]=240,["r"]=160,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=40,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=160,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,2,"正比",121) end
if t==(1) then R.change(o,"alpha",30.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end},
{["id"]=16,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=128,["begin"]=1,["life"]=96000,["fx"]=316,["fy"]=240,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=232,["wscale"]=0.11,["hscale"]=0.2,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",0.0,900.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",40.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,0,"正弦",19) end
end},
{["id"]=17,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=601,["life"]=95100,["fx"]=316,["fy"]=240,["r"]=160,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=233,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=155,["colorB"]=215,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=160,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(1) then R.change(o,"head",360.0,60.0,1,"正比",121) end
if t==(1) then R.change(o,"alpha",30.0,10.0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0.0,90.0,1,"正比",121) end
if t==(61) then R.change(o,"alpha",0.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",1) end
end}
}}
