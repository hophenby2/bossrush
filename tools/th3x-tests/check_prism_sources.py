"""从原作分支、减伤和共享控制器取值，核对三姐妹逐帧伤害汇总。"""
from pathlib import Path
import sys

from card_catalogue import runtime, plain
from ecl_source import Source, Variable


def entry(source, sub, shot):
    """只走原作入口的机体分支；未知分支显式失败，不能据此忽略原作逻辑。"""
    rows = source.subs[f'Sub{sub}']
    positions = {r.address: i for i, r in enumerate(rows)}
    result, pc = [], 0
    for _ in range(1000):
        r = rows[pc]
        if r.time:
            return result
        pc += 1
        if not r.mask & 8:
            continue
        if r.op == 38:
            assert r.args[0] == Variable(10028)
            if shot >= r.args[1]:
                pc = positions[source.labels[r.args[3]]]
        elif r.op == 2:
            pc = positions[source.labels[r.args[1]]]
        else:
            result.append(r)
    raise AssertionError('入口分支没有结束')


def check():
    original = Source(Path('E:/workspace/.bossrush-validation/original-anm/ecl/7/ecldata4.decl'),
                      Path('E:/workspace/原作/ECL/th07/ecldata4.ecl'), 7)
    lua = runtime()
    lua.execute("P=dofile('mod/GAME/th34_prism.lua'); H=dofile('mod/GAME/original/low_speed_hp.lua')")
    phases = plain(lua.globals().P.phases)
    checks = 0

    def eq(a, b, why):
        nonlocal checks
        assert a == b, (why, a, b)
        checks += 1

    for card, shot, owner, root in [(4440, 0, 53, 58), (4442, 4, 71, 76), (4444, 2, 88, 95)]:
        interrupts = {r.args[1]: r.args[0] for r in entry(original, owner, shot) if r.op == 108}
        eq(interrupts[2], root, (card, '机体路线的一非入口'))
        lives = [r.args[0] for r in entry(original, 44, shot) if r.op == 110]
        eq(lua.globals().H.entries[7][card].raw, lives[-1], (card, '共享控制器的机体分支血量'))

    for card,shot,owner,root in [(5480,0,53,64),(5481,4,71,80),(5482,2,88,98)]:
        interrupts={r.args[1]:r.args[0] for r in entry(original,owner,shot) if r.op==108}
        eq(interrupts[3],root,(card,'机体路线的二非入口'))
    for card,owner,key,root in [(5483,53,4,68),(5484,71,5,83),(5485,88,6,103)]:
        interrupts={r.args[1]:r.args[0] for r in entry(original,owner,0) if r.op==108}
        eq(interrupts[key],root,(card,'受伤最多的主奏三非入口'))
    for card in range(5480,5486):
        controller=45 if card<5483 else 47
        rows=entry(original,controller,0) if controller==45 else original.subs['Sub47']
        life=next(r.args[0] for r in rows if r.op==110)
        threshold=next(r.args[1] for r in rows if r.op==148)
        eq(lua.globals().H.entries[7][card].raw,life-threshold,(card,'阶段有效血量'))

    roots = {4440:[58],4442:[76],4444:[95],4441:[121,122,123],
             4443:[138],4445:[145],4446:[128],4475:[127],
             4447:[133,142,151],4476:[132,141,150],4448:[135,143,152],
             5480:[64],5481:[80],5482:[98],5483:[68],5484:[83],5485:[103]}
    for card, subs in roots.items():
        phase = phases[str(card)]
        control = original.subs['Sub'+str(phase['controller'])]
        # 汇总前没有读取lastDamage；随后每帧一次，同一帧分别扣三人的值。
        reads = [r for r in control if r.op == 43]
        eq([r.args[2] for r in reads], [1,2,3], (card,'汇总三条受击记录'))
        eq({r.time for r in reads}, {phase['start']}, (card,'汇总开始帧'))
        eq([r.args[1] for r in reads], [Variable(10061)]*3, (card,'上一帧伤害变量'))
        jumps = [r for r in control if r.op == 2 and r.time > 0]
        eq((jumps[-1].time,jumps[-1].args[0]),(phase['start']+1,phase['start']), (card,'逐帧汇总'))
        guards = []
        for i,sub in enumerate(subs):
            writes = [r.args[0] for r in original.subs[f'Sub{sub}'] if r.op == 142 and r.time == 0]
            guards.append(writes[-1] if writes else 0)
            eq(guards[-1], phase.get('guard' if i==0 else 'companion_guard',0), (card,sub,'个体减伤'))

        # 大量早期命中不能在汇总开始时爆发；全程比较主奏和两位伴奏的独立减伤。
        owner = lua.table_from(dict(hp=1000000,maxhp=1000000,spell_damage=0,DMG_factor=1,astral_dmg_factor=1))
        lua.globals().P.begin(owner,card)
        actors = [owner] + [lua.table_from({'th07_shared_damage':owner.th07_shared_damage}) for _ in subs[1:]]
        hp, pending = 1000000, 0
        for t in range(602):
            if t:
                if t>=reads[0].time:hp-=pending
                pending=0
                lua.globals().P.step(owner)
            eq(round(owner.hp,8),round(hp,8),(card,t,'上一帧共享扣血'))
            for i,(actor,guard) in enumerate(zip(actors,guards)):
                damage=9*((t+i)%4)
                pending+=damage/(9 if t<guard else 1)
                lua.globals().P.receive(actor,damage)
        controller=owner.th07_shared_damage
        lua.globals().P.finish(owner)
        eq(owner.th07_shared_damage,None,(card,'换卡解绑'))
        before=owner.hp
        lua.globals().P.controller.receive(controller,owner,99999)
        eq(owner.hp,before,(card,'旧子机不能继续伤害新卡'))
    print(f'三姐妹原始ECL分支、个体减伤、共享血槽及换卡：{checks}项通过；弹幕轨迹另行核对。')


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    check()
