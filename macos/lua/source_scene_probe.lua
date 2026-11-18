-- Real-engine regression for original mesh submissions and scene timelines.
local T={}
local work,chapter,offset=(os.getenv('BOSSRUSH_MAC_TEST_SOURCE_SCENE') or 'spring:4:0'):match('^(%a+):([^:]+):(%d+)$')
chapter=chapter:match('^EX') and chapter or tonumber(chapter);offset=tonumber(offset)
local scene
local practice=(tonumber(os.getenv('BOSSRUSH_MAC_TEST_CARD')) or 0)>0
function T.before(p)
    p.protect=100000
    if stage.current_stage.timer==5 and not practice then
        if work=='spring' then scene=TH37.background.show(chapter,offset);assert(scene.state.frame==offset)
        elseif work=='unity' then scene=TH38.background.show(tostring(chapter),'',offset)
        elseif work=='summer' then
            scene=_editor_class.TH40.background.enter(tostring(chapter));scene.originalParts=nil;scene.tenseiAge=nil;scene.mediaSpell=false
            scene.scene=_editor_class.TH40.background.Scene.State.new(tostring(chapter),offset)
        elseif work=='theis' or work=='keiwa' then
            local E=work=='theis' and _editor_class.TH41.source or TH43.runtime.env
            scene=E.New(E['stage'..chapter..'_background'],true)
        else error(work) end
    end
end
function T.after() end
function T.checkpoint()
    if practice then scene=lstg.tmpvar.bg end
    assert(scene and IsValid(scene))
    local s=scene.state or scene.scene
    if work=='spring' then
        assert(s.frame>offset)
        if practice and chapter==6 and offset>=4680 then assert(s.mode~='music' and s.time>=4080,'练习预滚未处理原BGM切换') end
        if chapter==4 then
            if s.time<1920 then assert(TH37.background.State.find(s,1000))
            elseif s.time>=3120 then assert(not TH37.background.State.find(s,2000) and not TH37.background.State.find(s,3000)) end
        end
    elseif work=='summer' then assert(s.time>offset and #s.objects>0) end
    assert(lstg.AndroidCreateModelMesh and lstg.AndroidRenderModelMesh,'原模型批量接口缺失')
    lstg.SystemLog(('SOURCE_SCENE: %s chapter=%s offset=%d'):format(work,tostring(chapter),offset))
end
return T
