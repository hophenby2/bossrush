-- 扫描雪莲华七条镜头时间轴，包含四面洞壁切换和 Extra A 后半段。
local Background=dofile('mod/GAME/th38/background.lua')
local stages=dofile('mod/GAME/th38/catalogue.lua').chapters
local checked,views,quads,restored=0,0,0,nil
local function finite(...)
    for i=1,select('#',...) do
        local v=select(i,...)
        assert(v==v and math.abs(v)<1e7,'无效的背景投影坐标')
    end
end
function SetPerspective(...)
    local fov,aspect,near,far=select(10,...)
    assert(fov>0 and fov<math.pi and aspect==8/9.6 and near>0 and near<far)
    views=views+1
end
function SetViewMode(mode) restored=mode end
function SetImageState() end
function RenderRect(_,...) finite(...) end
function Render4V(_,...)
    finite(...)
    quads=quads+1
end
lstg={world={l=-192,r=192,b=-224,t=224}}
for i,stage in ipairs(stages) do
    local draw=Background.road(i)
    for _,entry in ipairs(Background.load(i)) do
        local file=assert(io.open('Resources/th38/media/'..entry[1]..'.png','rb'))
        file:close()
    end
    for tick=0,stage.bosses[#stage.bosses].time+18000,50 do
        views,quads,restored=0,0,nil
        draw({timer=tick/2,mediaPrefix='TH38_'..i..'_'})
        assert(views==2 and quads>0 and restored=='world',
            ('关卡 %s 原作第 %d tick 缺少透视图元或未恢复战斗视口'):format(stage.name,tick))
        checked=checked+1
    end
end
print('雪莲华七关镜头和背景资源检查通过：'..checked)
