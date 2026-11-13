return {["id"]="6412",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,220,220,110,110,0,0,1,0,0,0,0,0,0,"6-cs501"},{0,0,500,500,250,250,0,0,1,0,0,0,0,0,0,"6-cs502"},{0,0,840,840,420,420,0,0,1,0,0,0,0,0,0,"6-cs503"},{330,0,110,230,55,115,0,0,1,0,40,15,30,200,40,"6boss-1-2"},{0,230,440,300,220,160,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,530,150,100,75,50,20,0,1,0,0,0,0,0,0,"6boss-1"},{150,530,100,100,50,50,24,0,1,0,20,20,60,60,40,"6boss-1"},{0,0,160,250,80,125,0,0,6,5,0,0,0,0,0,"6boss-2"},{0,1250,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,150,200,75,100,0,0,1,0,20,50,100,100,40,"6boss-cang"},{0,0,150,200,75,100,0,0,7,5,0,0,0,0,0,"6boss-cang"},{0,1200,150,200,75,100,0,0,1,0,0,0,0,0,0,"6boss-cang"},{0,0,220,220,110,110,0,0,1,0,0,0,0,0,0,"6-cs508"},{0,0,500,500,250,250,0,0,1,0,0,0,0,0,0,"6-cs509"},{0,0,840,840,420,420,0,0,1,0,0,0,0,0,0,"6-cs510"},{0,0,140,500,70,500,0,0,1,0,55,0,30,500,99,"6-LDjiguang"},{140,0,140,500,70,500,0,0,1,0,55,0,30,500,99,"6-LDjiguang"},{280,0,140,500,70,500,0,0,1,0,55,0,30,500,99,"6-LDjiguang"},{420,0,140,500,70,500,0,0,1,0,55,0,30,500,99,"6-LDjiguang"},{560,0,140,500,70,500,0,0,1,0,55,0,30,500,99,"6-LDjiguang"},{0,0,500,250,250,125,0,0,1,0,80,90,340,60,40,"spacestation"},{0,250,500,250,250,125,0,0,1,0,130,100,240,60,40,"spacestation"},{0,0,180,180,90,90,0,0,12,5,0,0,0,0,0,"6boss-lun"},{0,0,500,500,250,250,0,0,1,0,0,0,0,0,0,"6-dianqiu"},{0,0,840,840,420,420,0,0,1,0,0,0,0,0,0,"6-cs504"},{0,0,500,500,250,250,0,0,1,0,0,0,0,0,0,"6-cs505"},{0,0,220,220,110,110,0,0,1,0,0,0,0,0,0,"6-cs506"},{0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,""},{0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,""},{0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,""},{0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,""}},centerEvents=function(o,t,R)
if t==(5) then R.sound("stage6energy") end
if t==(240) then R.sound("stage6connect") end
end,globalEvents=function(c,t,R)
if t==240 then R.quake(c,60,13) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=91,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.6,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(241+math.floor(t/900)*900) then R.change(o,"sonspeedd",230,0,1,"正比",900) end
if t==(240) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(2200) then R.change(o,"fy",360,0,0,"正比",900) end
if t==(2200) then R.change(o,"sonspeed",0,0,0,"正比",900) end
if t==(2200) then R.change(o,"fx",480,0,0,"正比",900) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=520,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=6.8,["hscale"]=6.8,["colorR"]=66,["colorG"]=44,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(91+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",31) end
if t==(61+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(121+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=520,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=220,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=5,["hscale"]=3.9,["colorR"]=66,["colorG"]=22,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",31) end
if t==(181+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(241+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=520,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=400,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=6,["hscale"]=4.6,["colorR"]=55,["colorG"]=11,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(241+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(301+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(331+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",31) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=552,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=152,["wscale"]=1.35,["hscale"]=1.35,["colorR"]=255,["colorG"]=99,["colorB"]=1,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(330+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(91+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",12) end
if t==(61+math.floor(t/360)*360) then R.change(o,"alpha",30,0,0,"正比",1) end
if t==(121+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",2400,0,1,"正比",360) end
if t==(1+math.floor(t/360)*360) then R.change(o,"alpha",60,0,0,"正比",12) end
if t==(330+math.floor(t/360)*360) then R.change(o,"alpha",88,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=552,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=153,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=99,["colorB"]=1,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(91+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(91+math.floor(t/360)*360) then R.change(o,"alpha",88,0,0,"正比",30) end
if t==(181+math.floor(t/360)*360) then R.change(o,"alpha",30,0,0,"正比",1) end
if t==(241+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",2400,0,1,"正比",360) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",12) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=552,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=154,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=99,["colorB"]=1,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(211+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",88,0,0,"正比",30) end
if t==(301+math.floor(t/360)*360) then R.change(o,"alpha",30,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",2400,0,1,"正比",360) end
if t==(331+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",12) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=680,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=177,["wscale"]=-1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=211,["colorB"]=211,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(241+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(241+math.floor(t/360)*360) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(301+math.floor(t/360)*360) then R.change(o,"alpha",98,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",60,0,1,"正比",360) end
if t==(331+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=648,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=177,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=211,["colorB"]=211,["alpha"]=0,["head"]=130,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(241+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(241+math.floor(t/360)*360) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(301+math.floor(t/360)*360) then R.change(o,"alpha",98,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",60,0,2,"正比",360) end
if t==(331+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=648,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=178,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(181+math.floor(t/360)*360) then R.change(o,"alpha",98,0,0,"正比",1) end
if t==(241+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",60,0,1,"正比",360) end
if t==(221+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",20) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=680,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=178,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(181+math.floor(t/360)*360) then R.change(o,"alpha",98,0,0,"正比",1) end
if t==(241+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",60,0,2,"正比",360) end
if t==(221+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",20) end
end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=648,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=179,["wscale"]=1.35,["hscale"]=1.35,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=130,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(100+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(61+math.floor(t/360)*360) then R.change(o,"alpha",98,0,0,"正比",1) end
if t==(121+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",90,0,1,"正比",360) end
end,Sonevents=function(o,t,R)

end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=680,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=179,["wscale"]=-1.35,["hscale"]=1.35,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(100+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(61+math.floor(t/360)*360) then R.change(o,"alpha",98,0,0,"正比",1) end
if t==(121+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",90,0,2,"正比",360) end
end,Sonevents=function(o,t,R)

end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=552,["begin"]=121,["life"]=260,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=152,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(91+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",60) end
if t==(1+math.floor(t/360)*360) then R.change(o,"head",1800,0,1,"正比",360) end
if t==(1+math.floor(t/360)*360) then R.change(o,"alpha",40,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=616,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=99999,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=152,["wscale"]=1.35,["hscale"]=1.35,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(61+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(61+math.floor(t/360)*360) then R.change(o,"alpha",90,0,0,"正比",1) end
if t==(62+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",30) end
if t==(92+math.floor(t/360)*360) then R.change(o,"t",9999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=15,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=616,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=99999,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=153,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(181+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(181+math.floor(t/360)*360) then R.change(o,"alpha",90,0,0,"正比",1) end
if t==(182+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",30) end
if t==(212+math.floor(t/360)*360) then R.change(o,"t",9999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=16,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=616,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=99999,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=154,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(301+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(301+math.floor(t/360)*360) then R.change(o,"alpha",90,0,0,"正比",1) end
if t==(302+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",30) end
if t==(332+math.floor(t/360)*360) then R.change(o,"t",9999999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=17,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=584,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=165,["wscale"]=1.35,["hscale"]=1.35,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(330+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(81+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",11) end
if t==(61+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",1) end
if t==(121+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"alpha",66,0,0,"正比",12) end
if t==(330+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=18,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=584,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=166,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(91+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(91+math.floor(t/360)*360) then R.change(o,"alpha",66,0,0,"正比",30) end
if t==(181+math.floor(t/360)*360) then R.change(o,"alpha",30,0,0,"正比",1) end
if t==(241+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(191+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",11) end
end,Sonevents=function(o,t,R)

end},
{["id"]=19,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=584,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=167,["wscale"]=1.25,["hscale"]=1.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(211+math.floor(t/360)*360) then R.change(o,"t",1,0,0,"正比",1) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",66,0,0,"正比",30) end
if t==(301+math.floor(t/360)*360) then R.change(o,"alpha",30,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(301+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",11) end
end,Sonevents=function(o,t,R)

end},
{["id"]=20,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=584,["begin"]=181,["life"]=260,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=165,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(91+math.floor(t/360)*360) then R.change(o,"alpha",0,0,0,"正比",30) end
if t==(1+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=224,["y"]=360,["begin"]=1,["life"]=5200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=4,["wscale"]=1,["longs"]=100,["alpha"]=100,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=91,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=70,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.6,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(241+math.floor(t/900)*900) then R.change(o,"sonspeedd",230,0,1,"正比",900) end
if t==(240) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(2200) then R.change(o,"sonspeed",0,0,0,"正比",900) end
if t==(2200) then R.change(o,"fy",360,0,0,"正比",900) end
if t==(2200) then R.change(o,"fx",480,0,0,"正比",900) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=424,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=155,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=233,["colorG"]=233,["colorB"]=233,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",210,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=424,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=155,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=222,["colorG"]=222,["colorB"]=222,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",420,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=456,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=200,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=20,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=155,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=222,["colorG"]=222,["colorB"]=222,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",420,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=488,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=160,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=-20,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=155,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=222,["colorG"]=222,["colorB"]=222,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",420,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=328,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=500,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=173,["wscale"]=0.75,["hscale"]=0.75,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",290,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=328,["begin"]=2,["life"]=5199,["fx"]=-99998,["fy"]=-99998,["r"]=500,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=174,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",135,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=392,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=540,["rdirection"]=6,["rdirections"]={0.0,0.0},["tiao"]=30,["t"]=1,["fdirection"]=186,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=328,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=540,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=30,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=164,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=360,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=480,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=60,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.55,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=360,["begin"]=2,["life"]=5199,["fx"]=-99998,["fy"]=-99998,["r"]=500,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=162,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1200)*1200) then R.change(o,"fdirection",90,0,2,"正比",1200) end
if t==(1+math.floor(t/1200)*1200) then R.change(o,"rdirection",90,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",290,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=175,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=99,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.6,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(241+math.floor(t/900)*900) then R.change(o,"sonspeedd",230,0,1,"正比",900) end
if t==(240) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(2200) then R.change(o,"sonspeed",0,0,0,"正比",900) end
if t==(2200) then R.change(o,"fy",360,0,0,"正比",900) end
if t==(2200) then R.change(o,"fx",480,0,0,"正比",900) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=72,["begin"]=601,["life"]=4600,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.45,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(2+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(60+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(60+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(210+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(210+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=104,["begin"]=1321,["life"]=1440,["fx"]=-99998,["fy"]=-99998,["r"]=204,["rdirection"]=190,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=294,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/720)*720) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(1+math.floor(t/720)*720) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(70+math.floor(t/720)*720) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(70+math.floor(t/720)*720) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(211+math.floor(t/720)*720) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(211+math.floor(t/720)*720) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=104,["begin"]=601,["life"]=4600,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=243,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(80+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(80+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=136,["begin"]=1321,["life"]=1440,["fx"]=-99998,["fy"]=-99998,["r"]=204,["rdirection"]=190,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=-270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(361+math.floor(t/720)*720) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(361+math.floor(t/720)*720) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(430+math.floor(t/720)*720) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(430+math.floor(t/720)*720) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(571+math.floor(t/720)*720) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(571+math.floor(t/720)*720) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=136,["begin"]=601,["life"]=4600,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=117,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(80+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(80+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=136,["begin"]=2761,["life"]=2440,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=36,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=36,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.65,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(2+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(60+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(60+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(210+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(210+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=200,["begin"]=2761,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=216,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=168,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.73,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(70+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(70+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=232,["begin"]=2761,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=216,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=-96,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.73,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(70+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(70+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=104,["begin"]=601,["life"]=720,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=0.65,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(2+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(60+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(60+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(210+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(210+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=264,["begin"]=2041,["life"]=721,["fx"]=-99998,["fy"]=-99998,["r"]=500,["rdirection"]=24,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=1,["fdirection"]=144,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(90+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(90+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=264,["begin"]=2760,["life"]=1721,["fx"]=-99998,["fy"]=-99998,["r"]=500,["rdirection"]=36,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=1,["fdirection"]=156,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=168,["wscale"]=0,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(3+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(7+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15+math.floor(t/20)*20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",4,0,2,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",1) end
if t==(1+math.floor(t/360)*360) then R.change(o,"wscale",0.2,0,0,"正比",55) end
if t==(90+math.floor(t/360)*360) then R.change(o,"alpha",100,0,0,"正比",20) end
if t==(90+math.floor(t/360)*360) then R.change(o,"wscale",0.7,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(211+math.floor(t/360)*360) then R.change(o,"alpha",50,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=158,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.6,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(241+math.floor(t/900)*900) then R.change(o,"sonspeedd",230,0,1,"正比",900) end
if t==(2200) then R.change(o,"fy",360,0,0,"正比",900) end
if t==(240) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(2200) then R.change(o,"sonspeed",0,0,0,"正比",900) end
if t==(2200) then R.change(o,"fx",480,0,0,"正比",900) end
if t==(120) then R.change(o,"alpha",100,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=72,["begin"]=2,["life"]=5199,["fx"]=-99998,["fy"]=-99998,["r"]=500,["rdirection"]=60,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=158,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1) then R.change(o,"r",210,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=72,["begin"]=2,["life"]=5199,["fx"]=-99998,["fy"]=-99998,["r"]=500,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=158,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
if t==(1) then R.change(o,"r",300,0,0,"正比",240) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=448,["y"]=72,["begin"]=2,["life"]=5199,["fx"]=-99998,["fy"]=-99998,["r"]=490,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=1,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=158,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",60,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",60,0,1,"正比",600) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=608,["y"]=136,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=82,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(61+math.floor(t/360)*360) then R.change(o,"t",6,0,0,"正比",1) end
if t==(101+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=640,["y"]=136,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=220,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=15,["t"]=9999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=89,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(181+math.floor(t/360)*360) then R.change(o,"t",5,0,0,"正比",1) end
if t==(221+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=672,["y"]=136,["begin"]=241,["life"]=4960,["fx"]=-99998,["fy"]=-99998,["r"]=400,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=18,["t"]=9999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=89,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(301+math.floor(t/360)*360) then R.change(o,"t",5,0,0,"正比",1) end
if t==(341+math.floor(t/360)*360) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=true,["x"]=576,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=5,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-40,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",50,20,0,"正比",1) end
if t==(1) then R.change(o,"hscale",9,2,0,"无缝正弦",40) end
if t==(2) then R.change(o,"wscale",0,0,0,"正比",20) end
if t==(2) then R.change(o,"sonspeed",5,3,0,"正比",1) end
end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=false,["x"]=608,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=5,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-50,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",50,20,0,"正比",1) end
if t==(1) then R.change(o,"hscale",13,3,0,"无缝正弦",40) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",5,2,0,"正比",1) end
end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=544,["y"]=264,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=60,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=5,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",50,20,0,"正比",1) end
if t==(1) then R.change(o,"hscale",8,2,0,"无缝正弦",40) end
if t==(2) then R.change(o,"sonspeed",3,1,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",40) end
if t==(2) then R.change(o,"sonspeedd",180,130,1,"正比",1) end
end},
{["id"]=10,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=2400,["fx"]=480,["fy"]=360,["r"]=600,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=480,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=8000,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=130,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1200) then R.change(o,"t",360,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd","自机",13,0,"正比",1) end
if t==(600) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=11,["parentid"]=3,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=false,["x"]=576,["y"]=520,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",120,0,1,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",120,0,1,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=12,["parentid"]=3,["Binding"]=false,["bindid"]=10,["Bindwithspeedd"]=false,["x"]=576,["y"]=552,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=33,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=65,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",120,0,1,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=13,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=121,["life"]=2400,["fx"]=480,["fy"]=360,["r"]=600,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=480,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=8000,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=130,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1200) then R.change(o,"t",360,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd","自机",13,0,"正比",1) end
if t==(600) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=14,["parentid"]=3,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=608,["y"]=520,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=12,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",120,0,2,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",120,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=15,["parentid"]=3,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=608,["y"]=552,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=33,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=65,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",120,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=16,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=264,["begin"]=961,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=320,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=149,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(200) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",300,0,1,"正比",400) end
end},
{["id"]=17,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=800,["y"]=72,["begin"]=561,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=190,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=149,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(200) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",300,0,2,"正比",450) end
end},
{["id"]=18,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=800,["y"]=616,["begin"]=1361,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=150,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=149,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(200) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",300,0,1,"正比",400) end
end},
{["id"]=19,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=552,["begin"]=1801,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=149,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(200) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",300,0,2,"正比",400) end
end},
{["id"]=20,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=136,["begin"]=2261,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=320,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=149,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(200) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",300,0,1,"正比",400) end
end},
{["id"]=21,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=800,["y"]=264,["begin"]=2601,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=149,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(200) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",280,0,2,"正比",400) end
end},
{["id"]=22,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=552,["begin"]=2701,["life"]=500,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=40,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=150,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=120,["rdirection"]=130,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t>(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(200) then R.change(o,"t",20,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=23,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=552,["begin"]=3010,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=150,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=120,["rdirection"]=180,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t>(1) then R.change(o,"fx","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=24,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=584,["begin"]=3150,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=260,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=150,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=180,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t>(1) then R.change(o,"fx","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=25,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=616,["begin"]=3220,["life"]=100,["fx"]=-99998,["fy"]=-99998,["r"]=260,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=150,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=180,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t>(1) then R.change(o,"fx","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=26,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=104,["begin"]=80,["life"]=5121,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=120,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=180,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=27,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=136,["begin"]=180,["life"]=5001,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=120,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=181,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=28,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=136,["begin"]=260,["life"]=4861,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=360,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=182,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=29,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=104,["begin"]=3100,["life"]=320,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=24,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=183,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(100) then R.change(o,"t",15,0,0,"正比",1) end
if t==(200) then R.change(o,"t",10,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=30,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=4,["hscale"]=4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=31,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=544,["y"]=424,["begin"]=260,["life"]=2400,["fx"]=480,["fy"]=360,["r"]=540,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=8000,["type"]=151,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",600,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",600,0,1,"正比",600) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",70,0,0,"正比",5) end
if t==(600) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=32,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=576,["y"]=424,["begin"]=1880,["life"]=780,["fx"]=480,["fy"]=360,["r"]=540,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=8000,["type"]=151,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/600)*600) then R.change(o,"fdirection",600,0,1,"正比",600) end
if t==(1+math.floor(t/600)*600) then R.change(o,"rdirection",600,0,1,"正比",600) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",70,0,0,"正比",5) end
if t==(600) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end}
}}
