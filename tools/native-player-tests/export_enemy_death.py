#!/usr/bin/env python3
"""展开永夜篇敌机击破的原作CrazyStorm演出。"""
import argparse,importlib.util,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('enemy_export',ROOT/'tools/th39-tests/export_background.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--content',type=Path,required=True);args=ap.parse_args()
ex=module.BackgroundExport(None,args.content)
rows=[[module.atom(v) for v in row.split(',')] for row in ex.text('0').splitlines() if row]
effects={str(row[16]) for row in rows}
for script in module.STAGES:
    for _,raw in module.commands(ex.text(script),'灵'):
        op,args=module.split_command(raw)
        if op=='BindFamiliar' and len(args)>3 and int(args[3])>0:effects.add(args[3])
effects=sorted(effects,key=int)
for effect in effects:ex.pattern(effect,'e',module.SCENES)
(module.SCENES/'enemy_death.lua').write_text('-- 原作Enemy.InitType的breakEffect对应图集高度。\nreturn '+module.lua(ex.textures)+'\n')
(ROOT/'tools/native-player-tests/enemy_death_sources.json').write_text(json.dumps({'effects':effects,'sha256':ex.hashes},ensure_ascii=False,indent=2)+'\n')
print(len(effects),'原始击破演出，',len(ex.textures),'材质')
