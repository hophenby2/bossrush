-- 原作高分辨率纹理必须完整取图；旋转时月亮中心、几何尺寸与UV都按ANM逻辑尺寸计算。
local textures,images,draws={},{},{}
stage={current_stage={timer=0}};lstg={SetTextureSamplerState=function()end}
ran={Float=function(_,a)return a end,Int=function(_,a)return a end}
local function near(a,b)assert(math.abs(a-b)<1e-6,tostring(a)..' / '..tostring(b))end
LoadTexture=function(name,path)
    local f=assert(io.open(path,'rb'));local h=f:read(24);f:close()
    local function size(i)local a,b,c,d=h:byte(i,i+3);return ((a*256+b)*256+c)*256+d end
    textures[name]={size(17),size(21)}
end
CheckRes=function(kind,name)return (kind=='tex' and textures or images)[name]end
GetTextureSize=function(name)return unpack(assert(textures[name]))end
LoadImage=function(name,tex,x,y,w,h)images[name]={tex=tex,x=x,y=y,w=w,h=h}end
FindResSprite=function(name)return assert(images[name])end
Color=function(...)return {...}end;SetImageState=function()end
Render=function(name,x,y,rot,sx,sy)draws[#draws+1]={image=images[name],x=x,y=y,rot=rot,sx=sx,sy=sy}end
RenderTexture=function(tex,blend,...)draws[#draws+1]={tex=tex,vertices={...}}end
dofile('THlib/anm/original.lua')
local A=OriginalANM
for _,native in ipairs({false,true})do
    lstg.AndroidRenderSprite=native and function(image,blend,x,y,rot,sx,sy)
        draws[#draws+1]={image=image,x=x,y=y,rot=rot,sx=sx,sy=sy}
    end or nil
    for _,case in ipairs({{'eff05',0,0},{'eff06',0,0},{'eff07',0,0},{'eff08',3,3},
        {'eff09al',1,1},{'eff09sk',1,1}})do
        local data=A.load(8,case[1]);local v=A.new(8,case[1],case[2])
        v.sprite=case[3];v.visible=true;v.position={224,240,.5};v.scale={2.304886,2.304886}
        for _,angle in ipairs({0,math.pi/2,math.pi,math.pi*1.5})do
            v.rotation={0,0,angle};draws={};A.draw(v,-224,240)
            local d=assert(draws[#draws]);local im=d.image
            local tw,th=GetTextureSize(im.tex)
            near(im.x,0);near(im.y,0);near(im.w,tw);near(im.h,th)
            near(d.x,0);near(d.y,0)
            near(im.w*d.sx,256*2.304886);near(im.h*d.sy,256*2.304886)
            -- 月亮在原纹理中心；任意旋转角下，其旋转半径都应为0。
            near((tw/2-im.w/2)*d.sx,0);near((th/2-im.h/2)*d.sy,0)
        end
    end
end
local v=A.new(8,'eff05',0);v.visible=true;v.u=.125;v.v=.25
draws={};A.draw(v,-224,240)
local p=assert(draws[1].vertices)
near(p[1][4],64);near(p[2][4],576);near(p[1][5],128);near(p[3][5],640)
local x,y=0,0
for _,q in ipairs(p)do x,y=x+q[1],y+q[2]end
near(x/4,0);near(y/4,0)
textures,images={},{};stage.current_stage={timer=0};v.u,v.v=0,0
draws={};A.draw(v,-224,240);near(draws[1].image.w,512)
print('PASS：六份永夜抄高分辨率ANM完整取图、四角旋转中心、逻辑几何、原生/普通绘制、滚动UV及资源重载。')
