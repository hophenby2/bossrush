"""隔离Windows挑战模式高速采样；持续选择中间强化，并可仅消融自机弹绘制。

自机受保护，敌机HP维持后定时结束样本卡；不等同自然通关或Android手机性能实测。
正常模式、原尺寸绘制和跳过自机弹绘制应顺序运行，避免硬件争用。
"""
from pathlib import Path
import argparse,subprocess,json,sys,importlib.util
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--out',type=Path,required=True)
ap.add_argument('--mode',choices=['normal','scale1','no-player'],default='normal')
ap.add_argument('--fps',type=int,default=600);ap.add_argument('--frames',type=int,default=900)
ap.add_argument('--seed',type=int,default=2026112630);a=ap.parse_args()
assert a.fps>0 and a.frames>0
root=Path(__file__).resolve().parents[1];out=a.out.resolve()
assert out!=root and root not in out.parents,'输出必须在源码目录之外'
spec=importlib.util.spec_from_file_location('stress',root/'tools/rogue_native_stress.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
c={'platform':f'Windows Sub；{a.fps} FPS上限，单逻辑步/绘制帧；固定中间强化','fps':a.fps,'draw_mode':a.mode,'runs':[{'mode':'staged','seed':a.seed,'limit':38,'frames':a.frames,'speed':1}]}
m.prepare_windows(out,c)
s=(out/'native_test.lua').read_text(encoding='utf-8-sig')
s=s.replace("        if IsValid(player) then\n", """        if IsValid(player) then
            local upgrade=lstg.var.upgrades
            local active=upgrade and upgrade.active
            if active and not active.picks[1] then
                player.x=0;player.y=GameDrops.rowY(active)
            else player.x,player.y=0,-176 end
""",1)
s=s.replace('    local function sample(scene,run)', """    local rawApply=GameDrops.apply
    GameDrops.apply=function(slot,option)
        assert(option==2,'夹具未选择中间强化：'..tostring(option))
        rawApply(slot,option)
        current.choices=current.choices or {};current.choices[#current.choices+1]=option
        event({event='middle_upgrade',run=runIndex,power=GameDrops.power(player),completed=lstg.var.rogue_run.completed})
    end
    local function sample(scene,run)""",1)
s=s.replace('    local frame,render=FrameFunc,RenderFunc',r'''    SetFPS(config.fps)
    local frame,render=FrameFunc,RenderFunc
    local watch=lstg.StopWatch()
    local file=assert(io.open('User/profile-frames.jsonl','wb'));file:setvbuf('full',262144)
    local audio=assert(io.open('User/profile-sounds.jsonl','wb'));audio:setvbuf('full',262144)
    local nativeSound=lstg.PlaySound
    lstg.PlaySound=function(name,...)
        if name:match('^th3x.original.') then
            local run=lstg.var.rogue_run;local scene=stage.current_stage
            audio:write(Serialize({name=name,card=run and run.encounter and run.encounter.cardId,
                clock=scene and scene.timer,source=_boss and IsValid(_boss) and _boss._original_source and _boss._original_source.key}),'\n')
        end
        return nativeSound(name,...)
    end
    local drawing=false
    local oldPower=GameDrops.power
    local mode=config.draw_mode
    GameDrops.power=function(o) if drawing and mode=='scale1' then return 1 end;return oldPower(o) end
    local classes=setmetatable({},{__mode='k'})
    local playerDraws=0
    local function wrap(c)
        if classes[c] then return end
        local fn=c[4];assert(type(fn)=='function')
        c[4]=function(body)
            playerDraws=playerDraws+1
            if drawing and mode=='no-player' then return end
            return fn(body)
        end
        classes[c]=true
    end
    for _,pc in ipairs({reimu_player,marisa_player})do for _,c in pairs(pc.bullets or {})do wrap(c)end end
    local oldNew=New
    New=function(class,...)
        local o=oldNew(class,...)
        if o.group==GROUP.PLAYER_BULLET or o.group==GROUP.SPELL then wrap(o.class) end
        return o
    end
    local pending
    local function flush()
        if not pending then return end
        if lstg.GetSourceFrameStatistics then
            pending.wait_ms,pending.engine_update_ms,pending.engine_render_ms,pending.present_ms,
                pending.total_ms,pending.pacer_ms,pending.gpu_ms,pending.present_busy=lstg.GetSourceFrameStatistics()
        end
        file:write(Serialize(pending),'\n');pending=nil
    end
    local rawFrame=frame
    frame=function()
        flush()
        local start=watch:GetElapsed();local result=rawFrame()
        local run=lstg.var.rogue_run;local scene=stage.current_stage
        pending={logic_ms=(watch:GetElapsed()-start)*1000,objects=GetnObj(),lua_kb=collectgarbage('count'),
            power=IsValid(player) and oldPower(player) or 1,completed=run and run.completed or -1,card=run and run.encounter and run.encounter.cardId,
            stage=scene and scene.stage_name,fps=GetFPS(),clock=scene and scene.timer,mode=mode,preparing=run and run.preparing or false}
        return result
    end
    local rawRender=render
    render=function()
        local start=watch:GetElapsed();playerDraws=0;drawing=true
        local ok,err=xpcall(rawRender,debug.traceback);drawing=false
        if not ok then error(err,0)end
        if pending then pending.render_ms=(watch:GetElapsed()-start)*1000;pending.player_draws=playerDraws end
    end
''',1)
s=s.replace("if done then return true end\n        local ok,result", "if done then flush();file:close();audio:close();return true end\n        local ok,result",1)
(out/'native_test.lua').write_bytes(s.encode('utf-8'))
(out/'profile-configuration.json').write_text(json.dumps(c,ensure_ascii=False,indent=2),encoding='utf-8')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
proc=subprocess.Popen([str(out/'LuaSTGSub.exe')],cwd=out,startupinfo=startup);print('mode',a.mode,'pid',proc.pid,'out',out,flush=True)
proc.wait(timeout=1200)
r=json.loads((out/'User/stress-result.json').read_text(encoding='utf-8'));print(json.dumps({'complete':r['complete'],'errors':r['errors'],'runs':r['runs']},ensure_ascii=False),flush=True)
assert r['complete'] and not r['errors']

