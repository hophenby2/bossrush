#!/usr/bin/env python3
"""展开永夜篇关卡与符卡的背景层。"""
import argparse
import importlib.util
from pathlib import Path

spec = importlib.util.spec_from_file_location('th39_export', Path(__file__).with_name('export.py'))
export = importlib.util.module_from_spec(spec)
spec.loader.exec_module(export)
ART, OUT = export.ART, export.OUT
atom, commands, lua, split_command = export.atom, export.commands, export.lua, export.split_command

SCENES = OUT / 'scenes'
STAGES = [f'{stage}04' for stage in range(1, 7)] + ['705', '806'] + [f'{stage}lw' for stage in range(1, 7)]


class BackgroundExport(export.Export):
    def texture(self, name, relative):
        # CrazyStorm 以完整路径区分纹理，不能将不同目录的同名文件合并。
        key = 'scene/' + relative.relative_to('Data').with_suffix('').as_posix().replace('\\', '/')
        (ART / key).parent.mkdir(parents=True, exist_ok=True)
        return super().texture(key, relative)

    def action(self, action, kind):
        if action.startswith('PlaySound('):
            return None
        return super().action(action, kind)

    def effect(self, stage, prefix, number):
        key = f'{stage}{number}'
        self.pattern(key, prefix, SCENES)
        return prefix + key

    def chapter_background(self, script):
        stage = int(script[0])
        events, cards, jumps = {}, [], {}
        group = card = None
        for tick, raw in commands(self.text(script), '灵'):
            op, args = split_command(raw)
            vals = list(map(atom, args))
            if op == 'Goto':
                jumps[tick] = export.tick(args[0])
            elif op == 'SetBossStage':
                group = dict(variant=vals[0], cards={})
                cards.append(group)
                card = None
            elif op == 'SetBossCard':
                card = {}
                group['cards'][vals[1]] = card
            elif op == 'SetBossCardBackground':
                card['variant'] = vals[0]
            elif op == 'KeepBackground':
                card['keep'] = True
            elif op == 'TimeIgnoreBackground':
                card['ignoreTime'] = True
            elif op in ('SetBackgroundEffect', 'ReplaceBackgroundEffect'):
                number, x, y, order = vals
                event = [op, number, x, y, order, self.effect(stage, 'bg', number)]
                if op == 'ReplaceBackgroundEffect':
                    card['replace'] = event
                else:
                    events.setdefault(tick, []).append(event)
            elif op in ('StopBackgroundEffect', 'BreakBackgroundEffect', 'AdjustBackgroundEffect', 'FadeinBackground'):
                events.setdefault(tick, []).append([op, *vals])
        return dict(timeline=events, groups=cards, jumps=jumps)

    def spell_background(self, stage, variant):
        path = self.content / 'Data' / f'{stage}{variant}.xna'
        if not path.exists():
            return None
        effects = []
        for line in self.text(path.stem).splitlines():
            line = line.strip()
            if not line:
                continue
            op, args = split_command(line)
            if op == 'CreateEffect':
                number, x, y = map(atom, args)
                effects.append([self.effect(stage, 'be', number), x, y])
            else:
                raise ValueError((path, line))
        return effects


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--content', type=Path, required=True)
    args = parser.parse_args()
    SCENES.mkdir(exist_ok=True)
    ex = BackgroundExport(None, args.content.resolve())
    stages = {script: ex.chapter_background(script) for script in STAGES}
    spells = {stage: {i: ex.spell_background(stage, i) for i in range(2, 10)
                      if (ex.content / 'Data' / f'{stage}{i}.xna').exists()} for stage in range(1, 9)}
    data = dict(stages=stages, spells=spells, textureHeights=ex.textures)
    (SCENES / 'index.lua').write_text('return ' + lua(data) + '\n')
    print(len(ex.patterns), 'effects,', len(ex.textures), 'textures')


if __name__ == '__main__':
    main()
