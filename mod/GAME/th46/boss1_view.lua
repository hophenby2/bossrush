-- 第一面关底绘图对象：先执行 c14c260 的整数算式，再同步六盒；render 只提交已算好的裁片。
-- 两次绘制共用同一份本体状态，受伤叠加层也会推进关节计数，不能只复制第一遍的图片。
-- 差异 1：脚步随机数默认走 LuaSTG 录像随机数；声音、足印和抖屏由战斗控制器接收事件后挂载。
-- 差异 2：EP1C12 的两倍 RGB 与加法混色使用 LuaSTG 最近的颜色乘法 / mul+add 代理，亮部有截断差异。
-- 差异 3：原版共用绘图池的容量竞争尚未接入，本体复用自己的裁片清单。
local draw=dofile('mod/GAME/th46/boss1_draw.lua')
local art=dofile('mod/GAME/th46/boss1_art.lua')
local object=object
local floor,min=math.floor,math.min
local unit,texture=65536,'th46_boss1'

local function load()
    if CheckRes('tex',texture)then return end
    LoadTexture(texture,'Resources/th46/stage1/boss1.png')
    SetTextureSamplerState(texture,'point+clamp')
    for id,r in pairs(art.sprites)do LoadImage(texture..'_'..id,texture,unpack(r))end
end
local function sync(o)
    for i=0,5 do
        local at=0x1f9c+i*0x8c
        o.points[i+1][1],o.points[i+1][2]=o.host.raw[at],o.host.raw[at+4]
    end
    o.syncBoxes(o.host,o.points)
end
local function step(o)
    if o.closed or o.serial==o.run.serial then return end
    local input=o.host.drawInput
    if not input then return end
    o.serial,o.count=o.run.serial,0
    local b=o.host.raw
    draw.update(b,input[1],input[2],input[3],b[0x2010],-1,o.emit,o.event,o.random)
    if input[4]then
        draw.update(b,input[1],input[2],input[3],b[0x22e4],b[0x22e0],o.emit,o.event,o.random)
    end
    -- 原队列按深度从小到大，同深度保持申请次序；独立提交探针见 capture 的 draw-order。
    for i=1,o.count do o.rows[i]=o.pool[i]end
    for i=#o.rows,o.count+1,-1 do o.rows[i]=nil end
    table.sort(o.rows,function(a,c)return a[4]<c[4]or(a[4]==c[4]and a[8]<c[8])end)
    sync(o)
end
local View=Class(object,{
    init=function(o,host,random,syncBoxes)
        assert(not host.view,'关底只能挂一份绘图对象')
        o.host,o.run,o.serial,o.closed=host,host.run,host.run.serial,false
        o.syncBoxes=assert(syncBoxes,'关底绘图缺少碰撞同步器')
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY,false,false
        o.rows,o.pool,o.points,o.count={},{},{},0
        for i=1,6 do o.points[i]={0,0}end
        o.random=random or function(n)return ran:Int(0,n)end
        o.emit=function(id,x,y,z,color,alpha,flip)
            assert(art.sprites[id],'关底缺少原版裁片 '..id)
            o.count=o.count+1
            local row=o.pool[o.count]
            if not row then row={};o.pool[o.count]=row end
            row[1],row[2],row[3],row[4]=id,x,y,z
            row[5],row[6],row[7],row[8]=color,alpha,flip,o.count
            return row
        end
        o.event=function(kind,value)
            if host.drawEvent then host.drawEvent(host,kind,value)end
        end
        host.view=o
    end,
    frame=step,
    render=function(o)
        if o.closed then return end
        for _,r in ipairs(o.rows)do
            local image,color=texture..'_'..r[1],r[5]
            SetImageState(image,r[6]<0 and ''or'mul+add',r[6]<0 and 255 or r[6],
                min(255,floor(color/65536)%256*2),min(255,floor(color/256)%256*2),min(255,color%256*2))
            Render(image,floor(r[2]/unit)-120,floor(r[3]/unit)-160,0,r[7]%2==1 and -1 or 1,
                floor(r[7]/2)%2==1 and -1 or 1)
        end
    end,
})
return {
    draw=draw,load=load,sync=sync,
    create=function(host,random,syncBoxes)load();return New(View,host,random,syncBoxes)end,
    step=step,
    close=function(o)
        if not o or o.closed then return end
        o.closed,o.hide=true,true
        if o.host.view==o then o.host.view=nil end
        object.RawDel(o)
    end,
}
