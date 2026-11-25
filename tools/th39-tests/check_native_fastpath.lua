-- 对照原有逐属性/共享颜色路径，检查原生批量提交的参数、判定和资源重建。
arg={'th39-native-fastpath'}
local f=assert(io.open('tools/check_stage.lua'));local source=f:read('*a');f:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
local original={Render=Render,SetImageState=SetImageState,FindResSprite=FindResSprite,
    CheckRes=CheckRes,LoadImage=LoadImage,project=lstg.AndroidProjectBullet,draw=lstg.AndroidRenderSprite}
local function clone(t) local out={};for k,v in pairs(t) do out[k]=v end;return out end
local function run(fast)
    local rows,draws,colors={}, {},{}
    local projects,states,finds=0,0,0
    SetImageState=function(img,blend,a,r,g,b) states=states+1;colors[img]={blend,a,r,g,b} end
    Render=function(img,x,y,rot,hs,vs)
        local c=assert(colors[img]);draws[#draws+1]={img,x,y,rot,hs,vs,unpack(c)}
    end
    local images={}
    FindResSprite=function(img)
        finds=finds+1;return {img=img,generation=images[img] or 0}
    end
    lstg.AndroidRenderSprite=fast and function(resource,blend,x,y,rot,hs,vs,a,r,g,b)
        assert(resource.generation==(images[resource.img] or 0),'绘制使用了已释放的资源')
        draws[#draws+1]={resource.img,x,y,rot,hs,vs,blend,a,r,g,b}
    end or nil
    lstg.AndroidProjectBullet=fast and function(b,img,x,y,rot,hs,vs,a,bb,layer,group,colli)
        assert(img==nil,'属性投影意外更换图像')
        projects=projects+1
        b.x,b.y,b.rot,b.hscale,b.vscale,b.a,b.b,b.layer,b.group,b.colli=x,y,rot,hs,vs,a,bb,layer,group,colli
        b.vx,b.vy,b.rect=0,0,false
    end or nil
    local R=dofile('mod/GAME/th39/runtime.lua');R.sound=function() end
    local c=R.controller({_live=true,x=0,y=100},'146',false)
    local s=clone(c.pattern.emitters[1]);s.controller,s.pattern=c,c.pattern
    s.fx,s.fy,s.life,s.type=481,360,45,52
    s.wscale,s.hscale,s.sonspeed,s.sonaspeed=-.7,1.3,3,0
    s.alpha,s.head,s.sonspeedd,s.Mist,s.Dispel,s.Outdispel=100,30,70,true,true,false
    s.Sonevents=function(o,t)
        if t==5 then R.change(o,'sonspeedd',130,0,0,'正比',15) end
        if t==25 then R.change(o,'alpha',80,0,0,'正比',5) end
    end
    local b=New(R.classes.projectile,s)
    for tick=1,80 do
        b.class.frame(b)
        local row={}
        for _,key in ipairs({'x','y','rot','hscale','vscale','a','b','colli','layer','group','vx','vy','rect','_a','_r','_g','_b'}) do row[key]=b[key] end
        rows[tick]=row;b.class.render(b)
    end
    if fast then assert(projects==81 and states==0,'未合并属性/顶点色提交') end

    -- 同一场景资源可复用句柄；退出后重新创建同名图片必须取得新句柄。
    local present={}
    CheckRes=function(kind,name) return kind=='tex' or present[name] end
    LoadImage=function(name,...)
        original.LoadImage(name,...);images[name]=(images[name] or 0)+1;present[name]=true
    end
    local effect=R.backgroundEffect('e54',480,360,739,nil,{tex={},img={}})
    local p=clone(s);p.controller,p.pattern=effect,effect.pattern
    p.type=#dofile('mod/GAME/th39/catalogue.lua').bulletTypes+1
    p.age,p.alpha,p.Mist,p.fx,p.fy,p.layerid,p.serial=21,100,false,481,360,0,1
    effect.particles={p};effect.drawDirty=true
    lstg.world=lstg.world or {l=-224,r=224,b=-256,t=256}
    R.drawBackground(effect,1,0,0)
    local last=draws[#draws];assert(last,'背景没有实际绘制')
    local previous=finds;R.drawBackground(effect,1,0,0)
    if fast then assert(finds==previous,'每帧重复查找同一图像') end
    present[last[1]]=nil;R.drawBackground(effect,1,0,0)
    if fast then assert(finds==previous+1,'重建后没有更新图像句柄') end
    CheckRes,LoadImage=original.CheckRes,original.LoadImage
    R.clear(c)
    return rows,draws
end
local slow,slowDraw=run(false)
local fast,fastDraw=run(true)
for i,row in ipairs(slow) do for key,value in pairs(row) do
    assert(fast[i][key]==value,'投影属性不一致：'..i..'/'..key)
end end
assert(#slowDraw==#fastDraw,'绘制数量不一致')
for i,row in ipairs(slowDraw) do for k,value in ipairs(row) do
    assert(fastDraw[i][k]==value,'绘制参数不一致：'..i..'/'..k)
end end
Render,SetImageState,FindResSprite=original.Render,original.SetImageState,original.FindResSprite
CheckRes,LoadImage=original.CheckRes,original.LoadImage
lstg.AndroidProjectBullet,lstg.AndroidRenderSprite=original.project,original.draw
print('PASS 永夜批量属性投影、普通弹/弹雾/背景绘制参数、颜色隔离与资源重建')
