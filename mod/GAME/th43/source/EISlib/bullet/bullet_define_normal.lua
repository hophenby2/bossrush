---=====================================
---祈华梦专用高清弹型
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---Texture:DD
---=====================================

local PATH = "res/bullet/"
local S = lstg.ResourceSet.create("EISlib.bullet", "global")

local function load_res(res)
	for _, v in ipairs(res.texture) do
		S:addTexture(v[1], v[2], v[3])
	end
	for _, v in ipairs(res) do
		S:addSpriteSequence(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8])
		if v[9] and v[10] then
			S:setSpriteSequenceCenter(v[1], v[7], v[8], v[9], v[10])
		end
		if v[11] then
			S:setSpriteSequenceState(v[1], v[7], v[8], v[11], v[12])
		end
	end
end

----------------------------------------
--region 消弹

local BulletBreakIndex={
	lstg.Color(0xC0FF3030),--red
	lstg.Color(0xC0FF30FF),--purple
	lstg.Color(0xC03030FF),--blue
	lstg.Color(0xC030FFFF),--cyan
	lstg.Color(0xC030FF30),--green
	lstg.Color(0xC0FFFF30),--yellow
	lstg.Color(0xC0FF8030),--orange
	lstg.Color(0xC0D0D0D0),--gray
}

S:addTexture("etbreak", PATH .. "etbreak.png", false)
for j = 1, 16 do
	S:addAnimation("etbreak"..j, "etbreak", 0, 0, 128, 128, 4, 2, 3)
end
for j = 1, 16 do
	if (j % 2) == 0 then
		S:setAnimationState("etbreak"..j, "mul+add", BulletBreakIndex[j / 2])
	elseif j==15 then
		S:setAnimationState("etbreak"..j, "mul+add", 0.5 * BulletBreakIndex[(j + 1) / 2] + lstg.Color(0x60000000))
	else
		S:setAnimationState("etbreak"..j, "mul+add", 0.5 * BulletBreakIndex[(j + 1) / 2] + lstg.Color(0x60000000))
	end
end

--endregion
----------------------------------------
--region 一般弹型

local res1 = {
	--imagename,textname,x,y,width,height,col,row,cx,cy,blend,color
	--region bullet_512
	{"ball_small","_bullet_512_texture",  0,0,32,32,1,16},--点弹
	{      "drop","_bullet_512_texture", 32,0,48,32,1,16,32,16},--水滴
	{   "ellipse","_bullet_512_texture", 80,0,50,32,1,16},--椭弹
	{    "mildew","_bullet_512_texture",130,0,32,32,1,16},--菌弹
	{    "preimg","_bullet_512_texture",162,0,64,64,2, 8},--16色雾化，不需要定义弹型
	--endregion
	--region bullet_1024
	{   "arrow_big", "_bullet_512_2_texture",192,0,32,32,1,16},--常规鳞弹
	{ "arrow_big_b",  "_bullet_1024_texture",  0,0,50,36,1,16},--鳞弹2
	{   "arrow_mid",  "_bullet_1024_texture", 50,0,82,36,1,16,64,18},--箭弹
	{ "arrow_small",  "_bullet_1024_texture",132,0,52,36,1,16,32,18},--苦无
	{ "arrow_small_b",  "_bullet_512_2_texture",32,0,32,32,1,16},--苦无2
	{    "ball_mid",  "_bullet_1024_texture",184,0,50,36,1,16},--小玉
	{  "ball_mid_c",  "_bullet_1024_texture",234,0,50,36,1,16},--环弹
	{     "grain_a",  "_bullet_1024_texture",284,0,50,36,1,16},--米弹
	{     "grain_b", "_bullet_512_2_texture",224,0,32,32,1,16},--凌弹
	{     "grain_d",  "_bullet_1024_texture",334,0,50,36,1,16},--凌弹2
	{     "grain_c",  "_bullet_1024_texture",384,0,50,36,1,16},--黑心米弹
	{  "gun_bullet",  "_bullet_1024_texture",434,0,50,36,1,16},--子弹
	{      "kite_b",  "_bullet_1024_texture",484,0,50,36,1,16},--菱形方砖
	{ "laserbullet",  "_bullet_1024_texture",534,0,50,36,1,16},--棍弹--old
	{      "square",  "_bullet_1024_texture",584,0,50,36,1,16},--札弹
	{  "star_small",  "_bullet_1024_texture",634,0,50,36,1,16},--小星弹
	--endregion
	--region bullet_1024_2
	--{"ellipse","_bullet_1024_2_texture",924,  0,100,64,1,16},--椭弹
	{  "money","_bullet_1024_2_texture",400,672, 50,50,4, 2},--钱币--8
	--endregion
	--region bullet_2048
	{  "butterfly","_bullet_1024_2_texture", 860,  0, 64,64,1,16},--蝶弹
	{"butterfly_b",  "_bullet_2048_texture",   0,  0, 66,66,16,1},--蝶弹2(最初的蝶弹素材）
	{      "heart",  "_bullet_2048_texture",   0, 66, 64,64,16,1},--心弹
	{   "ball_big",  "_bullet_2048_texture",   0,190, 64,64,16,1},--中玉
	{   "star_big",  "_bullet_2048_texture",1024,190, 64,64,16,1},--大星弹
	{      "knife_b",  "_bullet_2048_texture",   0, 382, 102, 64, 16, 1},--qhm的老刀弹
	{      "knife",  "_knife_texture",   0, 0, 64,64,1,16},--新刀弹
	{    "silence",  "_bullet_2048_texture",   0,446, 78,40,16,1},--休止符
	{ "music_high",  "_bullet_2048_texture",1056, 30, 98,64, 8,1},--高音符--8
	{       "kite",  "_bullet_2048_texture",1056,  0, 45,30,16,1},--菱弹
	{  "kite_dark",  "_bullet_2048_texture",1056, 94, 45,30,16,1},--灰菱弹
	--endregion
	
	--texturename,texturefile,mipmap
	texture={
		{    "_bullet_512_texture", PATH ..    "bullet_512.png", false },
		{  "_bullet_512_2_texture", PATH ..  "bullet_512_2.png", false },
		{   "_bullet_1024_texture", PATH ..   "bullet_1024.png", false },
		{ "_bullet_1024_2_texture", PATH .. "bullet_1024_2.png", false },
		{   "_bullet_2048_texture", PATH ..   "bullet_2048.png", false },
		{ "_knife_texture",          PATH ..         "knife.png", false} --新刀弹
		--{      "_bullet_4_texture", PATH .. "theis_bullet4.png", false },
	},
}
load_res(res1)

local def={
	type={
		--name,image,colorcnt,size,a,b,rect,highlight
		--region bullet_512
		{"ball_small","ball_small",16, 0.5,2,2,false},--点弹
		{      "drop",      "drop",16, 1.5,2,2,false},--水滴
		{   "ellipse",   "ellipse",16,1.25,4,4,false},--椭弹
		{    "mildew",    "mildew",16, 0.5,2,2,false},--菌弹
		--endregion
		--region bullet_1024
		{   "arrow_big",   "arrow_big",16,1.25,2.5,2.5,false},--鳞弹
		{   "arrow_mid",   "arrow_mid",16,1.99,3.5,3.5,false},--箭弹
		{ "arrow_small", "arrow_small",16,1.25,2.5,2.5,false},--苦无
		{ "arrow_small2", "arrow_small2",16,1.25,2.5,2.5,false},--苦无2
		{    "ball_mid",    "ball_mid",16,0.75,  4,  4,false},--小玉
		{  "ball_mid_c",  "ball_mid_c",16,0.85,  4,  4,false},--环弹
		{     "grain_a",     "grain_a",16,0.85,2.5,2.5,false},--米弹
		{     "grain_b",     "grain_b",16,1.25,2.5,2.5,false},--凌弹
		{     "grain_c",     "grain_c",16,0.85,2.5,2.5,false},--黑心米弹
		{     "grain_d",     "grain_d",16,1.25,2.5,2.5,false},--水晶凌弹
		{  "gun_bullet",  "gun_bullet",16,1.25,2.5,2.5,false},--子弹
		{      "kite_b",      "kite_b",16,0.75,2.5,2.5,false},--菱形方砖
		{ "laserbullet", "laserbullet",16,1.25,  2,  2,false},--棍弹--old
		{      "square",      "square",16, 1.0,  3,  3,false},--札弹
		{  "star_small",  "star_small",16,0.65,  2,  2,false},--小星弹
		--endregion
		--region bullet_1024_2
		--{"ellipse","ellipse",16,2.0,4,4,false},--椭弹
		{  "money",  "money", 8,0.9,4,4,false},--钱币--8
		--endregion
		--region bullet_2048
		{ "butterfly", "butterfly",16, 1.0,2.5,2.5,false},--蝶弹
		{     "heart",     "heart",16,1.65,  7,  7,false},--心弹
		{  "ball_big",  "ball_big",16,1.75,  8,  8,false},--中玉
		{  "star_big",  "star_big",16,1.65,  4,  4,false},--大星弹
		{     "knife",     "knife",16,1.99,  4,  4,false},--刀弹
		{   "knife_b",   "knife_b",16,1.99,  4,  4,false},--qhm的老刀弹
		{   "silence",   "silence",16,1.65,  3,  3,false},--休止符
		{"music_high","music_high", 8, 1.5,  3,  3,false},--高音符--8
		{      "kite",      "kite",16,1.15,2.5,2.5,false},--菱弹
		{ "kite_dark", "kite_dark",16,1.15,2.5,2.5,false},--灰菱弹
		--endregion
	},
	res={
		path = PATH,
		texture={},
	},
}

BulletLibrary.addBulletStyles("dd",def.res,def.type,BulletLibrary.classCreatorBase)

--endregion
----------------------------------------
--region 带动画帧的弹型

for i = 1, 8 do
	--water_drop
	S:addAnimation("water_drop" .. (2 * i), "_bullet_1024_2_texture", 96 * (i - 1), 0, 96, 60, 1, 4, 4)
	S:setAnimationState("water_drop" .. (2 * i), "mul+add")
	S:setAnimationCenter("water_drop" .. (2 * i), 64, 30)
	
	S:addAnimation("water_drop" .. (2 * i - 1), "_bullet_1024_2_texture", 96 * (i - 1), 240, 96, 60, 1, 4, 4)
	S:setAnimationState("water_drop" .. (2 * i - 1), "mul+add")
	S:setAnimationCenter("water_drop" .. (2 * i - 1), 64, 30)
	
	S:addAnimation("water_drop_dark" .. (2 * i), "_bullet_1024_2_texture", 96 * (i - 1), 0, 96, 60, 1, 4, 4)
	S:setAnimationCenter("water_drop_dark" .. (2 * i), 64, 30)
	
	S:addAnimation("water_drop_dark" .. (2 * i - 1), "_bullet_1024_2_texture", 96 * (i - 1), 240, 96, 60, 1, 4, 4)
	S:setAnimationCenter("water_drop_dark" .. (2 * i - 1), 64, 30)
	--music
	S:addAnimation("music" .. i, "_bullet_1024_2_texture", 102 * (i - 1), 480, 102, 64, 1, 3, 8)
end

local def3 = {
	type = {
		--name,image,colorcnt,size,a,b,rect,highlight
		{      "water_drop",      "water_drop",16,1.5,4,4,false,true},--高光滴弹
		{ "water_drop_dark", "water_drop_dark",16,1.5,4,4,false},--滴弹
		{     "water_drop2",     "water_drop2", 8,1.5,4,4,false,true},--高光火弹
		{"water_drop_dark2","water_drop_dark2", 8,1.5,4,4,false},--火弹
		{           "music",           "music", 8,1.5,3,3,false},--音符
	},
	res = {
		path = PATH,
		texture = {},
	},
}

BulletLibrary.addBulletStyles("dd",def3.res,def3.type,BulletLibrary.classCreatorBase)

--endregion
----------------------------------------
--region 超大弹型，需要使用自身作为雾化贴图

local res2 = {
	--imagename,texturefile,x,y,width,height,col,row,cx,cy,blend,color
	--region ball_huge
	{          "ball_huge","_bullet_1024_texture",768,0,128,128,2,8,nil,nil,"mul+add"},--blend
	{     "fade_ball_huge","_bullet_1024_texture",768,0,128,128,2,8},--ball_huge fade image
	{     "ball_huge_dark","_bullet_1024_texture",768,0,128,128,2,8},
	{"fade_ball_huge_dark","_bullet_1024_texture",768,0,128,128,2,8},--ball_huge_dark fade image
	--endregion
	--region ball_light
	{          "ball_light","_bullet_512_3_texture",0,0,128,128,4,4,nil,nil,"mul+add"},--blend
	{     "fade_ball_light","_bullet_512_3_texture",0,0,128,128,4,4},--ball_light fade image
	{     "ball_light_dark","_bullet_512_3_texture",0,0,128,128,4,4},
	{"fade_ball_light_dark","_bullet_512_3_texture",0,0,128,128,4,4},--ball_light_dark fade image
	--endregion
	
	--texturename,texturefile,mipmap
	texture={
		{"_bullet_512_3_texture", PATH .. "bullet_512_3.png", false}
	},
}
load_res(res2)

local def2 = {
	--name,image,fadeimage,colorcnt,size,a,b,rect,darktype
	type = {
		--region ball_huge
		{     "ball_huge",     "ball_huge",     "fade_ball_huge",16,2.0,13.5,13.5,false,false},
		{"ball_huge_dark","ball_huge_dark","fade_ball_huge_dark",16,2.0,13.5,13.5,false, true},
		--endregion
		--region ball_light
		{     "ball_light",     "ball_light",     "fade_ball_light",16,2.0,11.5,11.5,false,false},
		{"ball_light_dark","ball_light_dark","fade_ball_light_dark",16,2.0,11.5,11.5,false, true},
		--endregion
	},
	res = {
		path = PATH,
		texture = {},
	},
}

BulletLibrary.addBulletStyles("dd",def2.res,def2.type,BulletLibrary.classCreatorBaseHuge)

--endregion
----------------------------------------

--这些是体验版之后的素材
if not config.preview_version then
    local PATH = "res/bullet2/"
    -------------------------------------------------------------------
    --region 一般弹型

    local res1 = {
        --imagename,textname,x,y,width,height,col,row,cx,cy,blend,color
        {"star_big_b","star_big_b", 0, 0, 64, 64, 8, 1},--四角星弹
		{"ball_wool","ball_wool", 0, 0, 128, 128, 2, 8},--毛线球
		{"feather","feather", 0, 0, 146, 64, 1, 8},--羽毛弹
		{"jewel","jewel", 0, 0, 64, 64, 1, 8},

        --texturename,texturefile,mipmap
        texture={
            {"star_big_b", PATH .."star_big_b.png", false },
			{"ball_wool", PATH .."ball_wool.png", false },
			{"feather", PATH .."feather.png", false },
			{"jewel", PATH .."jewel.png", false },
        },
    }
    load_res(res1)

    local def={
        type={
            --name,image,colorcnt,size,a,b,rect,highlight
            {"star_big_b", "star_big_b", 8, 1, 4, 4, false},--四角星弹
			{"ball_wool", "ball_wool", 16, 1, 8, 8, false },--毛线球
			{"feather", "feather", 8, 1, 2, 2, false}, --鸟弹
			{"jewel", "jewel", 8, 1, 4, 4, false}
        },
        res={
            path = PATH,
            texture={},
        },
    }

    BulletLibrary.addBulletStyles("dd",def.res,def.type,BulletLibrary.classCreatorBase)

    --endregion
    -------------------------------------------------------------------
    --region 带帧动画的类型
    local ani_name
    --中玉2
    S:addTexture("ball_big_b", PATH .. "ball_big_b.png", false)

    for i = 0, 7 do
        for j = 1, 2 do
            ani_name = "ball_big_b" .. (2*i + j)
            S:addAnimation(ani_name, "ball_big_b", 80 * i, 0, 80, 80, 1, 4, 4)
            S:setAnimationState(ani_name, "")
            --S:setAnimationCenter(ani_name, 0, 0)
        end
    end

    --中玉3
    S:addTexture("ball_big_c", PATH .. "ball_big_c.png", false)
    for i = 0, 7 do
        for j = 1, 2 do
            ani_name = "ball_big_c" .. (2*i + j)
            S:addAnimation(ani_name, "ball_big_c", 64 * i, 0, 64, 64, 1, 2, 4)
            S:setAnimationState(ani_name, "")
            --S:setAnimationCenter(ani_name, 0, 0)
        end
    end

    --米弹5
    S:addTexture("grain_e", PATH .. "grain_e.png", false)
    for i = 0, 7 do
        for j = 1, 2 do
            ani_name = "grain_e" .. (2*i + j)
            S:addAnimation(ani_name, "grain_e", 0, 48 * (2*i + j - 1), 48, 48, 3, 1, 4)
            S:setAnimationState(ani_name, "")
            --S:setAnimationCenter(ani_name, 0, 0)
        end
    end

	--鸟
	S:addTexture("bird", PATH .. "bird.png", false)
	for i = 0, 7 do
		for j = 1, 2 do
			ani_name = "bird" .. (2*i + j)
			S:addAnimation(ani_name, "bird", 64 * i, 0, 64, 64, 1, 3, 8)
			S:setAnimationState(ani_name, "")
			--S:setAnimationCenter(ani_name, 0, 0)
		end
	end

    local def3 = {
        type = {
            --name,image,colorcnt,size,a,b,rect,highlight
            {"ball_big_b", "ball_big_b", 16, 1, 6, 6, false, false},--中玉2
            {"ball_big_c", "ball_big_c", 16, 1, 6, 6, false, false},--中玉3
            {"grain_e", "grain_e", 16, 1, 2.5, 2.5, false, false},--米弹5
			{"bird", "bird", 16, 1, 2, 2, false, false}, --鸟弹
        },
        res = {
            path = PATH,
            texture = {},
        },
    }

    BulletLibrary.addBulletStyles("dd",def3.res,def3.type,BulletLibrary.classCreatorBase)
    --endregion
end



BulletLibrary.usingBulletStyles("dd")
