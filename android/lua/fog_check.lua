-- 显式诊断入口：真实TH35瀑布背景与32个加色/透明度像素样本。
-- 固定种子并在背景第180帧停住，便于比较修复前后的相同场景。
local Q = {}
function Q.run()
    local scene = stage.New('android_fog', true, true)
    function scene:init()
        math.randomseed(20261103)
        New(Class(TH10_bg, {
            frame = function(o) if o.timer < 180 then TH10_bg.frame(o) end end,
        }, true))
        New(Class(object, {
            init = function(o) o.group, o.layer = GROUP.GHOST, LAYER.TOP + 100 end,
            render = function()
                SetViewMode('ui')
                local index = 0
                for fog = 0, 3 do
                    for _, blend in ipairs({'add+alpha', 'add+add'}) do
                        for _, alpha in ipairs({0, 64, 128, 255}) do
                            local x = 16 + index * 29
                            SetFog()
                            SetImageState('white', '', Color(255, 20, 40, 60))
                            RenderRect('white', x, x + 25, 8, 32)
                            local color = Color(255, 32, 64, 96)
                            -- w=1；加色四边形靠近UI远裁面，使GL与Metal的|clip.z|也接近1。
                            -- 三种雾模型均取约50%的雾化比例，避免后端的深度区间转换影响样本。
                            if fog == 1 then SetFog(0, 2, color)
                            elseif fog == 2 then SetFog(-1, math.log(2), color)
                            elseif fog == 3 then SetFog(-2, math.sqrt(math.log(2)), color) end
                            SetImageState('white', blend, Color(alpha, 64, 128, 192))
                            Render4V('white', x, 32, -1023, x + 25, 32, -1023,
                                x + 25, 8, -1023, x, 8, -1023)
                            index = index + 1
                        end
                    end
                end
                SetFog()
                RenderTTF('title', 'TH35 / add color / alpha / fog', 480, 520,
                    Color(255, 255, 255, 255), 'centerpoint')
            end,
        }, true))
    end
    function scene:render() SetViewMode('ui'); RenderClear(Color(255, 0, 0, 0)) end
    stage.Set('none', 'android_fog')
end
return Q
