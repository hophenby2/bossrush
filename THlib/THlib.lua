---=====================================
---THlib
---Touhou style library
---=====================================

----------------------------------------
---加载的列表
LoadRes = {  }
Include 'THlib\\rank.lua'--全局 Rank，先于各模块缓存 New
Include 'THlib\\drops.lua'--阶段二选一与自机伤害 / 射速成长
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
Include 'THlib\\enemy\\enemy.lua'
Include 'THlib\\bullet\\bullet.lua'
Include 'THlib\\laser\\laser.lua'
Include 'THlib\\background\\background.lua'
Include 'THlib\\ext\\ext.lua'
Include 'THlib\\UI\\menu.lua'
--Include 'THlib\\editor.lua'
Include 'THlib\\UI\\UI.lua'
Include 'THlib\\sp\\sp.lua'--OLC神的sp加强库
