#!/usr/bin/env python3
"""从实际场景/角色元数据核对装饰图白名单，避免把 Boss 行走图归入有损压缩。"""
from pathlib import Path
import json, subprocess, sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'android'))
from image_policy import DECORATIVE_IMAGES, noncore_category

script=r'''
local d=dofile('mod/GAME/th38/actors.lua')
local function collect(t,out,seen)
 if type(t)~='table' or seen[t]then return end;seen[t]=true
 for _,v in pairs(t)do
  if type(v)=='string'and d.sprites[v]then out[v]=true
  elseif type(v)=='string'and d.controllers[v]then collect(d.controllers[v],out,seen)
  elseif type(v)=='table'then collect(v,out,seen)end
 end
end
local core={};collect(d.profiles,core,{})
for key in pairs(core)do print('core\tResources/th38/actors/'..d.sprites[key].file)end
for _,kind in ipairs({'portraits','backgrounds'})do local set={};collect(d[kind],set,{})
 for key in pairs(set)do if not core[key]then print(kind..'\tResources/th38/actors/'..d.sprites[key].file)end end
end
'''
lines=subprocess.check_output(['luajit','-'],input=script,text=True,cwd=ROOT).splitlines()
expected={}
for line in lines:
    kind,path=line.split('\t')
    assert (ROOT/path).is_file(),path
    if kind=='core':assert noncore_category(path) is None,('行走图不能有损',path)
    else:expected[path]='雪莲华开符立绘' if kind=='portraits' else '雪莲华符卡背景'
assert DECORATIVE_IMAGES==expected,'请按 actors.lua 背景/立绘重新生成白名单，并排除 profiles/Animator 中的战斗角色'
for path in ['Resources/th43/boss/Sonia/BossWalkImage1.png','Resources/th43/player/reimu/normal.png',
             'Resources/th39/barrages.png','Resources/th38/bullet.png',
             'Resources/ports/theis/res/item/item.png','Resources/ports/theis/res/player/reimu/reimu_player.png',
             'Resources/ports/theis/res/ui/ui_item_16_9_1.png',
             'Resources/th39/scene/bg2-32.png','Resources/th39/scene/2-19.png',
             'Resources/th39/scene/4bgs-01.png']:
    assert noncore_category(path) is None,path
for path in ['Resources/th43/performer/Sonia/spellcard/1.png','Resources/th43/boss/Sonia/red_moon/0.png',
             'Resources/th40/scene/万花镜素材.png','Resources/th39/5bg-2.png',
             'Resources/ports/theis/res/ui/ui_stage_bg_16_9_1.png']:
    assert noncore_category(path),path
print(f'场景白名单通过：{len(expected)} 张背景/开符立绘；战斗角色、子弹、自机、道具及道具界面保持核心无损')
