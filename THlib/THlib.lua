---=====================================
---THlib
---Touhou style library
---=====================================

----------------------------------------
---加载的列表
LoadRes = {  }
Include 'THlib\\sequence_resources.lua'--仅新版顺序模式启用的原作自机与资源账本
Include 'THlib\\rogue_hp.lua'--阶段HP倍率，先于对象构造缓存New
Include 'THlib\\rank.lua'--全局 Rank，先于各模块缓存 New
Include 'THlib\\drops.lua'--阶段三选一与火力、Bomb恢复、自机判定成长
---加载脚本
Include 'THlib\\WalkImageSystem.lua'
--Include 'THlib\\DNHWalkImageSystem.lua'
--Include 'THlib\\DNHRenderObject.lua'
Include 'THlib\\eventListener.lua'
Include 'THlib\\misc\\misc.lua'
Include 'THlib\\se\\se.lua'
Include 'THlib\\item\\item.lua'
Include 'THlib\\player\\player.lua'
Include 'THlib\\player\\player_addon.lua'
Include 'THlib\\native_players.lua'
Include 'THlib\\enemy\\enemy.lua'
Include 'THlib\\bullet\\bullet.lua'
Include 'THlib\\laser\\laser.lua'
Include 'THlib\\background\\background.lua'
Include 'THlib\\sequence_player.lua'
Include 'THlib\\ext\\ext.lua'
Include 'THlib\\UI\\menu.lua'
--Include 'THlib\\editor.lua'
Include 'THlib\\UI\\UI.lua'
Include 'THlib\\sp\\sp.lua'--OLC神的sp加强库
