"""逐一核验全部TH31使魔的判定、交互开关、出生免伤和生命值来源。"""
from pathlib import Path
import struct
import sys

from card_catalogue import runtime, plain
from ecl_source import Source, Variable

# 慧音二非共用一个Lua类，通过gun/life参数选择四向680帧或八向580帧。
# 这里只允许明确的双入口；两个入口的交互指令必须分别与配置相等。
SHARED_ACTORS = {'ecldata3:40': (40, 42)}


def check():
    lua = runtime()
    profiles = plain(lua.execute("dofile('mod/GAME/th31.lua');return _editor_class.TH31.th08_combat.profiles"))
    sources, events, births = {}, 0, 0
    for key, profile in profiles.items():
        file, sub = key.split(':')
        if file not in sources:
            sources[file] = Source(
                Path(f'E:/workspace/.bossrush-validation/original-anm/ecl/8/{file}.decl'),
                Path(f'E:/workspace/原作/ECL/th08/{file}.ecl'))
        source = sources[file]
        binary = source.binary.read_bytes()
        subs = SHARED_ACTORS.get(key, (int(sub),))
        for source_sub in subs:
            rows = [r for r in source.subs['Sub' + str(source_sub)] if r.mask & 8 and r.op in (77, 79, 80, 81, 82, 160)]
            for r in rows:
                # 不只比较反汇编副本；交互数值与宽高必须等于原始操作数字节。
                fmt = '<ff' if r.op == 77 else '<f' if r.op == 82 else '<i'
                assert list(struct.unpack_from(fmt, binary, r.address + 12)) == r.args, (key, hex(r.address))
            expected = [[r.time, r.op, *r.args] for r in rows]
            assert profile['events'] == expected, (key, source_sub, '判定或交互指令遗漏/错译', profile['events'], expected)
            events += len(rows)

        # 共用配置保留其他难度的出生变体；这里只查其原始来源，不声称全部在Lunatic可达。
        spawn_rows = [r for rows in source.subs.values() for r in rows
                      if r.op in (90, 91, 92, 93, 94) and r.args[0] in subs]
        match_position = not profile.get('life') and len({p[1] for p in profile['spawns']}) > 1
        for pattern in profile['spawns']:
            found = []
            for r in spawn_rows:
                at = 4 if r.op in (93, 94) else 3
                if r.op != pattern[0] or r.args[at] != pattern[1]:
                    continue
                if match_position and any(v is not False and not isinstance(r.args[i + 1], Variable)
                                          and v != r.args[i + 1] for i, v in enumerate(pattern[2:])):
                    continue
                assert struct.unpack_from('<i', binary, r.address + 12 + 4 * at)[0] == pattern[1]
                found.append(r)
            assert found, (key, '生命值/匹配出生点没有原始生成指令', pattern)
            births += 1
    lua.execute('''
        audit_shot_distance={}
        local M=_editor_class.TH31.th08_combat
        for _,key in ipairs({'ecldata5sp:42','ecldata_al:2','ecldata8sp:68'}) do
            local cls=M.actor(key,{init=function(o) o.x,o.y=0,0 end,frame=function() end})
            local o=New(cls)
            for frame=0,62 do
                if frame>0 then cls.frame(o) end
                for _,x in ipairs({0,31.999,32,32.001}) do
                    player.x,player.y=x,0
                    audit_shot_distance[#audit_shot_distance+1]={key,frame,x,M.can_shoot(o)}
                end
            end
            object.RawDel(o)
        end
    ''')
    for key,frame,x,actual in plain(lua.globals().audit_shot_distance):
        file,sub=key.split(':')
        distance=32
        for r in sources[file].subs['Sub'+sub]:
            if r.op==82 and r.time<=frame:distance=r.args[0]
        assert actual==(x*x>=distance*distance),(key,frame,x,actual,distance)
    print(f'TH31全部{len(profiles)}个使魔配置：{events}条交互指令、{births}条出生生命值来源通过。')
    print('另核对756个近身出弹边界/默认关闭/第61帧关闭用例；EX发射入口及三种自定义LW发射入口使用同一属性。')
    print('范围：配置与原始操作数字节；动态生命值函数、同步CALL后的实际帧序、运动/发弹仍需分别对照。')


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    check()
