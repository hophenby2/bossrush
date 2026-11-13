local path = EISlib.Background.path

lstg.DoFile(path.."stage1bg.lua")
lstg.DoFile(path.."stage2bg.lua")
lstg.DoFile(path.."stage3bg.lua")
if not config.preview_version then
	lstg.DoFile(path.."stage4bg.lua")
	lstg.DoFile(path.."stage5bg.lua")
	lstg.DoFile(path.."stage6bg.lua")
	lstg.DoFile(path.."stage7bg.lua")
	lstg.DoFile(path.."stageEDbg.lua") --ed背景
end
