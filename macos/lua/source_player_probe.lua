local T={}
local rendered={support=0,body=0}
local render=Render
Render=function(id,...)
    if type(id)=='string' then
        if id:find('native_theis_reimu_support',1,true) then rendered.support=rendered.support+1 end
        if id:find('native_theis_reimu_player',1,true) or id:find('native_theis_yukari_player',1,true) then rendered.body=rendered.body+1 end
    end
    return render(id,...)
end
function T.before(p)
    p.protect=100000
    local t=stage.current_stage.timer
    AndroidInput.keys[setting.keys.shoot]=true
    AndroidInput.keys[setting.keys.slow]=t>80 and t<180
    if t==5 then
        assert(p.theis_source,'没有执行原始机体类')
        assert(p.A==1 and p.B==1 and p.ani_intv==8)
        assert(p.grazer.a==32 and p.grazer.b==32)
    end
    if t==200 then
        lstg.SystemLog(('SOURCE_PLAYER_STATE: shift=%s slow=%s support=(%s,%s) p=(%s,%s)'):format(tostring(p.shift),tostring(p.slow),tostring(p.supportx),tostring(p.supporty),tostring(p.x),tostring(p.y)))
    end
end
function T.after() end
function T.checkpoint()
    assert(rendered.body>0 and rendered.support>0,'原始行走图或子机没有渲染')
    lstg.SystemLog(('SOURCE_PLAYER: body=%d support=%d'):format(rendered.body,rendered.support))
end
return T
