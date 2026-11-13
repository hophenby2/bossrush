-- 离线展开：b199.xna；事件均已编译为Lua条件和调用。
return {id="199",total=6666,centerAvailable=true,center={315,145,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,100,100,50,50,10,0},{100,0,100,100,50,50,10,0},{200,0,100,100,50,50,10,0},{300,0,100,100,50,50,10,0},{0,100,100,100,50,50,10,0},{100,100,100,100,50,50,10,0},{200,100,100,100,50,50,10,0},{300,100,100,100,50,50,10,0},{0,200,100,100,50,50,20,0},{100,200,36,36,18,18,2,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=20,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=9,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=237,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"hscale",1.0,0,0,"正比",29) end
if t==(1+math.floor(t/60)*60) then R.change(o,"head",5.0,0,1,"正弦",59) end
if t==(1+math.floor(t/60)*60) then R.change(o,"wscale",1.0,0,0,"正比",29) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1,["life"]=400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=238,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=225,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=-2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=12,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(190) then R.change(o,"type",23.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0.0,10.0,1,"正弦",120) end
if t==(180) then R.change(o,"wscale",0.01,0,0,"正比",10) end
if t==(190) then R.change(o,"wscale",1.0,0,0,"正比",10) end
if t==(131) then R.change(o,"sonspeed",0.5,0,1,"正比",221) end
if t==(460) then R.change(o,"sonspeedd",0.0,20.0,1,"正弦",219) end
if t==(1) then R.change(o,"sonspeedd",0.0,20.0,1,"正弦",119) end
if t==(1) then R.change(o,"sonspeed",1.0,0.8,0,"正比",121) end
if t==(120) then R.change(o,"sonspeedd",0.0,20.0,1,"正弦",119) end
if t==(240) then R.change(o,"sonspeedd",0.0,20.0,1,"正弦",219) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",30.0,0,2,"正弦",119) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=1,["life"]=6200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/320)*320) then R.change(o,"head",12.0,0,1,"正弦",319) end
if t==(6+math.floor(t/28)*28) then R.change(o,"type",1.0,0,2,"正比",1) end
if t==(13+math.floor(t/28)*28) then R.change(o,"type",1.0,0,2,"正比",1) end
if t==(20+math.floor(t/28)*28) then R.change(o,"type",1.0,0,2,"正比",1) end
if t==(27+math.floor(t/28)*28) then R.change(o,"type",3.0,0,1,"正比",1) end
end,Sonevents=function(o,t,R)

end}
}}
