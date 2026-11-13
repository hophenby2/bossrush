-- 离线展开：b729.xna；事件均已编译为Lua条件和调用。
return {id="729",total=6360,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,90,127,45,63,20,0},{91,0,90,127,45,63,20,0},{182,0,90,127,45,63,20,0},{270,0,26,45,12,22,4,0},{296,0,36,46,18,23,4,0},{332,0,39,51,19,25,5,0},{371,0,21,31,10,15,2,0},{0,127,257,256,136,218,1,0},{257,127,257,256,120,228,1,0},{263,383,89,81,44,40,1,0},{185,383,78,136,39,68,1,0},{0,383,185,157,82,78,1,0},{567,200,172,89,86,89,1,0},{567,289,241,178,120,89,1,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=183,["y"]=320,["begin"]=1,["life"]=5910,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=228,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=125,["colorG"]=15,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=36,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=0.8,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",12.0,0,1,"正弦",239) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",15.0,0,1,"正弦",239) end
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeed",0.4,0,1,"正弦",119) end
if t==(1) then R.change(o,"fy",20.0,0,2,"正比",60) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",90.0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",34.0,0,2,"正比",1) end
if t==(1) then R.change(o,"hscale",0.3,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",120) end
if t==(90) then R.change(o,"alpha",30.0,0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",120) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=256,["begin"]=1,["life"]=6000,["fx"]=316,["fy"]=290,["r"]=270,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=330,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",360.0,0,1,"正比",240) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",360.0,0,1,"正比",240) end
if t==(1) then R.change(o,"r",300.0,0,0,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0,0,"正比",220) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=32,["begin"]=61,["life"]=5940,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=680,["type"]=9,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"fdirection",120.0,0,2,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,1,"正比",15) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,2,"正比",15) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=64,["begin"]=61,["life"]=5940,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=680,["type"]=228,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=125,["colorG"]=1,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"hscale",1.0,0,0,"正比",120) end
if t==(1+math.floor(t/360)*360) then R.change(o,"fdirection",120.0,0,2,"正比",360) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",1.0,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,1,"正比",15) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,2,"正比",15) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=32,["begin"]=61,["life"]=5940,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=680,["type"]=9,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"fdirection",120.0,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,2,"正比",15) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,1,"正比",15) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=215,["y"]=320,["begin"]=1,["life"]=5910,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=110,["type"]=228,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=1,["colorB"]=15,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=36,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=0.8,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",12.0,0,1,"正弦",239) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",15.0,0,1,"正弦",239) end
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeed",0.4,0,1,"正弦",119) end
if t==(1) then R.change(o,"fy",20.0,0,2,"正比",60) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",34.0,0,2,"正比",1) end
if t==(1) then R.change(o,"hscale",0.3,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",120) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",120) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=64,["begin"]=61,["life"]=5940,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=680,["type"]=228,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=125,["colorG"]=1,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"hscale",1.0,0,0,"正比",120) end
if t==(1+math.floor(t/360)*360) then R.change(o,"fdirection",120.0,0,1,"正比",360) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",1.0,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,2,"正比",15) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",20.0,0,1,"正比",15) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1.0,0,1,"正弦",119) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=461,["life"]=5900,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=25,["t"]=120,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=58,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=290,["r"]=450,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=8,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",280.0,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(31) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=256,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=290,["r"]=450,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=18,["t"]=8,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",380.0,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(31) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",90.0,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=192,["y"]=128,["begin"]=1,["life"]=5930,["fx"]=316,["fy"]=270,["r"]=0,["rdirection"]=1,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",120) end
if t==(91) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=3,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.15,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=0.8,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=288,["begin"]=61,["life"]=5930,["fx"]=316,["fy"]=330,["r"]=360,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=8,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1.0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(31) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",90.0,0,0,"正比",30) end
end}
}}
