-- 启动器与正式界面共用字形回退规则；启动器只加载自己实际使用的一组字体。
local path='THlib\\UI\\font\\'
local major,minor,patch=lstg.GetVersionNumber()
local safe=major==0 and minor==21 and patch and patch>=24
return function(name,size)
    if safe and type(lstg.LoadTrueTypeFont)=='function' then
        assert(lstg.LoadTrueTypeFont(name,{
            {source=path..'text.ttf',height=size},
            {source=path..'NotoSansCJKjp-Bold.otf',height=size},
        }),'界面字体加载失败：'..name)
    else
        LoadTTF(name,path..'NotoSansCJKjp-Bold.otf',size)
    end
end
