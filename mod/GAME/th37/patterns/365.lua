-- 离线展开：b365.xna；事件均已编译为Lua条件和调用。
return {id="365",total=1800,centerAvailable=true,center={315,140,0,0,0,0},centerEvents=function(o,t,R)
if t==(1) then R.move(o,250,370,100,120) end
if t==(301) then R.move(o,250,370,100,120) end
if t==(601) then R.move(o,250,370,100,120) end
if t==(901) then R.move(o,315,315,140,140) end
end,globalEvents=function(c,t,R)

end,types={{188,188,60,60,30,30,0,0},{436,126,60,60,30,30,0,0},{374,126,60,60,30,30,0,0},{312,126,60,60,30,30,0,0},{250,126,60,60,30,30,0,0},{188,126,60,60,30,30,0,0},{126,436,60,60,30,30,0,0},{126,374,60,60,30,30,0,0},{126,312,60,60,30,30,0,0},{126,250,60,60,30,30,0,0},{126,188,60,60,30,30,0,0},{126,126,60,60,30,30,0,0},{436,64,60,60,30,30,0,0},{374,64,60,60,30,30,0,0},{312,64,60,60,30,30,0,0},{250,64,60,60,30,30,0,0},{64,64,60,60,30,30,0,0},{436,2,60,60,30,30,0,0},{374,2,60,60,30,30,0,0},{312,2,60,60,30,30,0,0},{250,2,60,60,30,30,0,0},{188,2,60,60,30,30,0,0},{126,2,60,60,30,30,0,0},{64,2,60,60,30,30,0,0},{2,436,60,60,30,30,0,0},{2,374,60,60,30,30,0,0},{2,312,60,60,30,30,0,0},{2,250,60,60,30,30,0,0},{2,188,60,60,30,30,0,0},{2,126,60,60,30,30,0,0},{2,64,60,60,30,30,0,0},{2,2,60,60,30,30,0,0},{64,312,60,60,30,30,0,0},{64,250,60,60,30,30,0,0},{64,188,60,60,30,30,0,0},{64,126,60,60,30,30,0,0},{270,210,193,197,96,105,0,0},{270,407,193,197,96,105,0,0},{64,636,60,60,30,30,0,0},{2,676,60,60,30,30,0,0},{2,614,60,60,30,30,0,0},{2,552,60,60,30,30,0,0},{64,698,55,49,27,24,0,0},{64,552,46,41,23,20,0,0},{1,512,118,38,59,20,0,0},{120,514,103,97,51,85,0,0},{64,595,39,39,20,20,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=61,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=241,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,1,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/50)*50) then R.change(o,"head",6.0,0,1,"正弦",49) end
if t==(8+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(16+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(31+math.floor(t/32)*32) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(76) then R.change(o,"sonspeed",3.0,0,0,"正比",61) end
if t==(76) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=121,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=130,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=25,["type"]=241,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",720.0,0,1,"正比",180) end
if t==(1) then R.change(o,"fdirection",720.0,0,1,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3.0,0,0,"正比",61) end
if t==(1) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=192,["y"]=128,["begin"]=120,["life"]=241,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",6.0,0,1,"正比",220) end
end,Sonevents=function(o,t,R)
if t==(61) then R.change(o,"sonspeed",3.0,0,1,"正比",160) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=361,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,2,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/50)*50) then R.change(o,"head",6.0,0,1,"正弦",49) end
if t==(8+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(16+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(31+math.floor(t/32)*32) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(76) then R.change(o,"sonspeed",3.0,0,0,"正比",61) end
if t==(76) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=421,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=130,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=25,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",720.0,0,2,"正比",180) end
if t==(1) then R.change(o,"fdirection",720.0,0,2,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3.0,0,0,"正比",61) end
if t==(1) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=192,["y"]=192,["begin"]=420,["life"]=221,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=4,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=270,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=17,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,0,1,"正比",220) end
end,Sonevents=function(o,t,R)
if t==(61) then R.change(o,"sonspeed",3.0,0,1,"正比",160) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=661,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=253,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,1,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/50)*50) then R.change(o,"head",6.0,0,1,"正弦",49) end
if t==(8+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(16+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(31+math.floor(t/32)*32) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(76) then R.change(o,"sonspeed",3.0,0,0,"正比",61) end
if t==(76) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=720,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=130,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=25,["type"]=253,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",720.0,0,1,"正比",180) end
if t==(1) then R.change(o,"fdirection",720.0,0,1,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3.0,0,0,"正比",61) end
if t==(1) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=192,["y"]=256,["begin"]=720,["life"]=221,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=4,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=21,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5.0,0,1,"正比",220) end
end,Sonevents=function(o,t,R)
if t==(61) then R.change(o,"sonspeed",3.0,0,1,"正比",160) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=961,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=257,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,2,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/50)*50) then R.change(o,"head",6.0,0,1,"正弦",49) end
if t==(8+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(16+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(31+math.floor(t/32)*32) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(76) then R.change(o,"sonspeed",3.0,0,0,"正比",61) end
if t==(76) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",40) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1020,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=130,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=25,["type"]=257,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",720.0,0,2,"正比",180) end
if t==(1) then R.change(o,"fdirection",720.0,0,2,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.6,0,0,"正比",61) end
if t==(1) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=true,["x"]=192,["y"]=320,["begin"]=1020,["life"]=221,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=4,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=300,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=19,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3.0,0,1,"正比",220) end
end,Sonevents=function(o,t,R)
if t==(61) then R.change(o,"sonspeed",3.0,0,1,"正比",160) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1280,["life"]=521,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=261,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"fdirection",1800.0,0,2,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/50)*50) then R.change(o,"head",6.0,0,1,"正弦",49) end
if t==(8+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(16+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/32)*32) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(31+math.floor(t/32)*32) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=12,["Bindwithspeedd"]=false,["x"]=288,["y"]=320,["begin"]=70,["life"]=2,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=23,["t"]=2,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=36,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",31) end
end}
}}
