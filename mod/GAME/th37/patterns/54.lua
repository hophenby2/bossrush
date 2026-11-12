-- 离线展开：b54.xna；事件均已编译为Lua条件和调用。
return {id="54",total=2210,centerAvailable=true,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=34,["wscale"]=0.4,["hscale"]=0.6,["colorR"]=255,["colorG"]=88,["colorB"]=200,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=12,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=50,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.6,0,0,"正弦",19) end
if t==(1) then R.change(o,"sonspeed",1.0,0.7,0,"正比",1) end
if t==(270) then R.change(o,"alpha",1.0,0,0,"正比",31) end
if t==(1) then R.change(o,"head",0.0,1200.0,1,"正比",300) end
end}
}}
