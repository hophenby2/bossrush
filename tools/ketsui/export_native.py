"""从解密程序导出 LuaSTG 所需的常量、关卡指令和原版图块。"""
import argparse
from pathlib import Path
import struct

import numpy as np

from export import Atlas, Graphics, ROOT, decode_palette, signed
from inspect_program import ENEMY_HANDLERS, bullet_descriptor, pointer, read_program, spawns, stages, word


# 0xccfa8 经 0xcd06c 按指令编号分派。长度以 16 位参数为单位。
SCROLL_ARGS = {0: 1, 4: 3, 8: 2, 12: 0, 16: 3, 20: 1, 24: 1, 28: 0,
               32: 0, 36: 0, 40: 4, 44: 0, 48: 0}
SMALL_GROUPS = {0x10: 0xD0898, 0x11: 0xD0D08, 0x12: 0xD0F46, 0x13: 0xD1214, 0x14: 0xD14CA,
                0x16: 0xD194A, 0x17: 0xD1C46, 0x18: 0xD1F00, 0x1A: 0xD2956}
SMALL_PARTS = {0x10: 0xD08B2, 0x11: 0xD0D22, 0x12: 0xD0F60, 0x13: 0xD122E, 0x14: 0xD14E4,
               0x16: 0xD1964, 0x17: 0xD1C60, 0x18: 0xD1F26, 0x1A: 0xD2970}
GROUND = {
    0x24: (0xD3C8E, 0xD3CB4, 38, 0xD3F92, 0xD4092, 0xD4112, 0x630, 0x430, 13),
    0x25: (0xD42EC, 0xD4312, 38, 0xD4600, 0xD4700, 0xD4780, 0x638, 0x638, 13),
    0x85: (0xEB89C, 0xEB8AA, 14, 0, 0xD6FDA, 0xD705A, 0, 0x830, 14),
    0x95: (0xEBFFC, 0xEC00E, 18, 0, 0xD70DA, 0xD715A, 0, 0xA38, 14),
}


def scroll_stream(program, address):
    instructions = []
    cursor = address + 8
    while pointer(program, cursor) != 0xFFFFFFFF:
        major, minor, op = struct.unpack_from('>HHH', program, cursor)
        args = struct.unpack_from(f'>{SCROLL_ARGS[op]}h', program, cursor + 6)
        instructions.append((major, minor, op, *args))
        cursor += 6 + len(args) * 2
    return instructions


def rows(values, indent='    '):
    return ''.join(indent + '{' + ','.join(map(str, row)) + '},\n' for row in values)


def lua_bytes(data, indent='    '):
    # 按行切开长字节串，保留原 ROM 地址关系。
    values = [data[index:index + 64] for index in range(0, len(data), 64)]
    return (' ..\n' + indent).join("'" + ''.join(f'\\{x:03d}' for x in value) + "'" for value in values)


def palette_banks(program, stream):
    address = pointer(program, stream)
    banks = {}
    if address:
        while pointer(program, address) != 0xFFFFFFFF:
            start, bank = struct.unpack_from('>IH', program, address)
            banks.setdefault(bank, start)
            address += 6
    return banks


def boss1_parts(program):
    main_hp, *hp = struct.unpack_from('>7I', program, 0x10CD5E)
    source = (0, 2, 3, 4, 5, 6, 7)
    offsets = (0, 0xFCFFF400, 0xFD000C00, 0xFBFFF280, 0xFC000D80, 0x14FFF100, 0x15000F00)
    group_hp = (main_hp, *hp[4:], *hp[:4])
    for index, part in enumerate(source):
        bounds = struct.unpack_from('>4h', program, 0x10CD7E + part * 32 + 12)
        offset = offsets[index]
        yield (group_hp[index], signed(offset >> 16), offset & 0xFFFF, *bounds)


def effect_commands(program, cursor):
    while word(program, cursor) != 0xffff:
        yield struct.unpack_from('>HHHhhBB', program, cursor)
        cursor += 12


def hatch_patrol_data(program, art):
    yield '  hatchPatrol={\n'
    for kind, state, part, sprites, explosions, muzzle, stages, sizes, offsets in (
            (0x27, 0xD904C, 0xD906E, 0xD941A, 0xD944A, 0xD9464, (5,), (0x850,0x228),
             (-0x800,-0xA00,-0x700,-0x500,0,0)),
            (0x28, 0xD8740, 0xD8762, 0xD8B0E, 0xD8B3E, 0xD8B58, (1,3), (0xA50,0x448),
             (-0xA00,-0xA00,-0x800,-0xA00,0x13F,-0x480)),
            (0x29, 0xD8BBA, 0xD8BDC, 0xD8F88, 0xD8FB8, 0xD8FD2, (1,), (0xA50,0x448),
             (-0xA00,-0xA00,-0x800,-0xA00,0x40,0x200))):
        yield f'    [0x{kind:x}]={{\n'
        yield '      state=' + lua_bytes(program[state:state+34]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        yield '      muzzle={\n' + rows((struct.unpack_from('>hh', program, muzzle+4*i)
                                          for i in range(6)), '        ') + '      },\n'
        yield '      breakup={\n' + rows(effect_commands(program, explosions), '        ') + '      },\n'
        yield '      offsets={' + ','.join(map(str,offsets)) + '},\n'
        yield '      sprites={\n'
        for stage in stages:
            banks = palette_banks(program, pointer(program, pointer(program, 0xCB8C6 + (stage-1)*4)))
            palette = np.zeros((0x400, 3), dtype='u1')
            for bank in (0x0D, 0x1F, 0x19):
                row = banks[bank]
                palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H', program, row))
            yield f'        [{stage}]={{\n'
            for bank in (0x0D, 0x1F, 0x19):
                yield rows([tuple(art(pointer(program, sprites+4*i), sizes[i>=8], bank, palette)
                                  for i in range(12))], '          ')
            yield '        },\n'
        yield '      },\n    },\n'
    yield '  },\n'


def fixed_cannon_data(program, art):
    yield '  fixedCannon={\n'
    yield '    state=' + lua_bytes(program[0xF3F76:0xF3F88]) + ',\n'
    yield '    part=' + lua_bytes(program[0xF3F88:0xF3FA8]) + ',\n'
    yield '    barrel={\n' + rows(struct.unpack_from('>4h', program, 0xE9C1E + 16*i)
                                 for i in range(32)) + '    },\n'
    yield '    muzzle={\n' + rows(struct.unpack_from('>2h', program, 0xD755A + 4*i)
                                 for i in range(64)) + '    },\n'
    yield '    breakup={\n'
    for i in range(5):
        kind, _, h, l, _, velocity, _, _, delay = struct.unpack_from('>HHhhHHHHH', program,0xF431C+i*18)
        yield rows([(delay,kind,0,h,l,velocity >> 8,velocity & 0xff)],'      ')
    yield '    },\n'
    banks = palette_banks(program, pointer(program, pointer(program, 0xCB8D6)))
    palette = np.zeros((0x400, 3), dtype='u1')
    for bank in (0x12,0x1f,0x19):
        palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H', program, banks[bank]))
    yield '    sprites={\n'
    for bank in (0x12,0x1f,0x19):
        yield rows([tuple(art(pointer(program,0xE9B9E+4*i),0x0C50,bank,palette) for i in range(32))], '      ')
    yield '    },\n  },\n'


def heavy_tank_data(program, art):
    yield '  heavyTank={\n'
    yield '    state=' + lua_bytes(program[0xD7C18:0xD7C3E]) + ',\n'
    yield '    part=' + lua_bytes(program[0xD7C3E:0xD7C5E]) + ',\n'
    yield '    second={\n'
    for i in range(1, 4):
        start = 0xD7C3E + i*32
        yield '      ' + lua_bytes(program[start:start+32]) + ',\n'
    yield '    },\n'
    yield '    breakup={\n' + rows(effect_commands(program, 0xD8614), '      ') + '    },\n'
    yield '    muzzle={\n' + rows(struct.unpack_from('>hh', program, 0xD840A+4*i)
                                 for i in range(32)) + '    },\n'
    yield '    stages={\n'
    for stage in (1, 3):
        stream = pointer(program, pointer(program, 0xCB8C6+(stage-1)*4))
        banks = palette_banks(program, stream)
        palette = np.zeros((0x400, 3), dtype='u1')
        for bank in (0x14,0x15,0x1f,0x19):
            palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H', program, banks[bank]))
        yield f'      [{stage}]={{\n'
        yield '        body={\n' + rows((tuple(art(address,size,bank,palette) for address,size in
                                                 ((0x1F0060,0x1448), *((pointer(program,0xD83FA+4*i),0xA48) for i in range(4))))
                                            for bank in (0x14,0x1f,0x19)), '          ') + '        },\n'
        yield '        guns={\n'
        for hatch, gun in ((0xD82BA,0xD82FA),(0xD82DA,0xD837A)):
            yield '          {\n'
            for bank in (0x15,0x1f,0x19):
                yield rows([tuple(art(pointer(program,address+4*i),size,bank,palette)
                                  for address,size,count in ((hatch,0xA20,8),(gun,0x620,32)) for i in range(count))], '            ')
            yield '          },\n'
        yield '        },\n      },\n'
    yield '    },\n  },\n'


def twin_aircraft_data(program, art):
    yield '  twinAircraft={\n'
    yield '    state=' + lua_bytes(program[0xE10DC:0xE1106]) + ',\n'
    yield '    part=' + lua_bytes(program[0xE1106:0xE1126]) + ',\n'
    yield '    second=' + lua_bytes(program[0xE1126:0xE1146]) + ',\n'
    for key, address, count in (('turretMuzzle',0xE193C,32), ('fanMuzzle',0xD755A,64)):
        yield f'    {key}={{\n' + rows(struct.unpack_from('>hh',program,address+4*i)
                                        for i in range(count)) + '    },\n'
    for key,address in (('damage',0xE176A),('breakup',0xE16E2)):
        yield f'    {key}={{\n' + rows(effect_commands(program,address)) + '    },\n'
    yield '    art={\n'
    for stage,base in ((3,0x12),(5,0x15)):
        stream = pointer(program,pointer(program,0xCB8C6+(stage-1)*4))
        banks = palette_banks(program,stream)
        palette = np.zeros((0x400,3), dtype='u1')
        for bank in (base,0x1f,0x19,0x18):
            palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))
        yield f'      [{stage}]={{\n'
        for bank in (base,0x1f,0x19):
            yield '        {\n'
            yield f'          body={art(0x1FA63C,0x1250,bank,palette)},\n'
            yield f'          flare={art(0x1FBCA0,0xA28,0x18,palette)},\n'
            for key,address,size,count in (('turret',0xE1652,0x218,32),('tail',0xE16D2,0x1080,4)):
                yield f'          {key}={{' + ','.join(str(art(pointer(program,address+4*i),size,bank,palette))
                                                        for i in range(count)) + '},\n'
            yield '        },\n'
        yield '      },\n'
    yield '    },\n  },\n'


def triple_aircraft_data(program, art):
    stream = pointer(program, pointer(program, 0xCB8C6 + 2 * 4))
    banks = palette_banks(program, stream)
    palette = np.zeros((0x400, 3), dtype='u1')
    colors = (0x0c, 0x1f, 0x19)
    for bank in colors:
        palette[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, banks[bank]))

    # 0xdf494 给三门直射炮共用，破损舱口改查 0xd755a。
    yield '  tripleAircraft={\n'
    yield '    turretMuzzle={\n' + rows(struct.unpack_from('>hh', program, 0xDF494 + 4*i)
                                          for i in range(32)) + '    },\n'
    yield '    hatchMuzzle={' + ','.join(str(pointer(program, 0xD755A + 4*i)) for i in range(64)) + '},\n'
    for name, base in (('direct',0xDF414), ('fan',0xDF314)):
        yield f'    {name}={{\n' + rows(tuple(art(pointer(program,base+4*i),0x420,bank,palette)
                                                 for i in range(32)) for bank in colors) + '    },\n'

    definitions = (
        (0x4e,0xDEA30,0xDEA5A,0xDF514,0xDF53A,0xDF2F4,0x628,0xFEC00500,0xFA00FB00,
         (0xFD8007C0,0xF94009C0,0x153FF5C0,0x0ABFFD80),
         ((0x2363E8,0x1228,0xEE00FB00,0x05FFFE00), (0x236344,0xA20,0xF600FC00,0x0B3FF500),
          (0x236554,0xE18,0xF200FD00,0xFCC00600), (0x236600,0xA18,0xF600FD00,0xF4000C00))),
        (0x50,0xDFEA6,0xDFED0,0xE06A4,0xE06D6,0xE0684,0x620,0xFEFFF840,0xFA00FC00,
         (0xFFBFF300,0xFCBFEEC0,0x09401700,0x06800380),
         ((0x235EB4,0xA50,0xF600F600,0xF7FFEF00), (0x236048,0xC28,0xF400FB00,0xFFFFFE00),
          (0x23613C,0xE10,0xF200FE00,0x04000500), (0x2361B0,0xA50,0xF600F600,0x00001100))),
        (0x51,0xE078E,0xE07B8,0xE0F8C,0xE0FBE,0xE0F6C,0x620,0x06000900,0xFA00FC00,
         (0x08400D40,0x07C011C0,0xFBBFE840,0x057FFE80),
         ((0x235A9C,0x838,0xF800F900,0xF7FFEC00), (0x235B80,0xE28,0xF200FB00,0x00BFF800),
          (0x235C9C,0xA30,0xF600FA00,0xFF800300), (0x235D90,0x848,0xF800F700,0x01801200))),
    )
    for kind, state, part, damaged, destroyed, hatch, size, pivot, draw, guns, pieces in definitions:
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:state + 42]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part + 32]) + ',\n'
        yield '      second={\n'
        for i in (1, 2):
            yield '        ' + lua_bytes(program[part + i*32:part + (i+1)*32]) + ',\n'
        yield '      },\n'
        # 第四片只保存尾部炮口的角度和计时器，没有独立受击区。
        yield f'      tailClock={program[part + 100]},tailReload={program[part + 101]},\n'
        yield f'      hatchPivot={pivot},hatchDraw={(pivot+draw) & 0xffffffff},\n'
        yield '      guns={' + ','.join(map(str,guns)) + '},\n'
        for name,address in (('damage',damaged), ('breakup',destroyed)):
            yield f'      {name}={{\n' + rows(effect_commands(program,address), '        ') + '      },\n'
        yield '      body={\n' + rows((((d+e) & 0xffffffff), *(art(address,mask,bank,palette) for bank in colors))
                                       for address,mask,d,e in pieces) + '      },\n'
        yield '      hatch={\n' + rows(tuple(art(pointer(program,hatch+4*i),size,bank,palette) for i in range(8))
                                        for bank in colors) + '      },\n'
        yield '    },\n'
    yield '  },\n'


def patrol42_data(program, art):
    stream = pointer(program, pointer(program, 0xCB8C6 + 4))
    banks = palette_banks(program, stream)
    palette = np.zeros((0x400, 3), dtype='u1')
    colors = (0x0b, 0x1f, 0x19)
    for bank in colors:
        palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))

    yield '  patrol42={\n'
    yield '    state=' + lua_bytes(program[0xDD2CE:0xDD2EC]) + ',\n'
    yield '    part=' + lua_bytes(program[0xDD2EC:0xDD30C]) + ',\n'
    yield '    second=' + lua_bytes(program[0xDD30C:0xDD32C]) + ',\n'
    for name,address in (('damage',0xDD83C),('breakup',0xDD86E)):
        yield f'    {name}={{\n' + rows(effect_commands(program,address)) + '    },\n'
    yield '    body={' + ','.join(str(art(0x1F93F8,0x1060,bank,palette)) for bank in colors) + '},\n'
    for name,table,size,count in (('turret',0xDD7BC,0x210,32),('hatch',0xDD77C,0xA28,16)):
        yield f'    {name}={{\n' + rows(tuple(art(pointer(program,table+4*i),size,bank,palette)
                                                 for i in range(count)) for bank in colors) + '    },\n'
    yield '  },\n'


def ground98_data(program, art):
    stream = pointer(program, pointer(program, 0xCB8C6 + 4*4))
    banks = palette_banks(program, stream)
    palette = np.zeros((0x400,3), dtype='u1')
    colors = (0x15,0x1f,0x19)
    for bank in (*colors,0x18,0x1a):
        palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))

    yield '  ground98={\n'
    yield '    state=' + lua_bytes(program[0xECE58:0xECE82]) + ',\n'
    yield '    part=' + lua_bytes(program[0xECE82:0xECEA2]) + ',\n'
    yield '    second={\n'
    for i in range(1,5):
        base = 0xECE82+32*i
        yield '      ' + lua_bytes(program[base:base+32]) + ',\n'
    yield '    },\n'
    yield '    radial={' + ','.join(str(pointer(program,0xD765A+4*i)) for i in range(64)) + '},\n'
    for name,base in (('leftFire',0xED862),('rightFire',0xED876)):
        yield f'    {name}={{\n' + rows(struct.unpack_from('>hh',program,base+4*i) for i in range(5)) + '    },\n'
    yield '    raisedLights={\n' + rows(struct.unpack_from('>4h',program,0xED902+4*i)
                                           for i in range(-5,6)) + '    },\n'
    blasts = []
    for i in range(6):
        kind, attr, h, l, _, vel, _, _, delay = struct.unpack_from('>HHhh5H',program,0xED932+18*i)
        blasts.append((delay,kind,attr,h,l,vel>>8,vel&255))
    yield '    breakup={\n' + rows(blasts) + '    },\n'

    yield '    art={\n'
    for name,base,size in (('hull',0xED802,0x1020),('left',0xED822,0xC30),('right',0xED842,0x1040)):
        yield f'      {name}={{\n' + rows(tuple(art(pointer(program,base+4*i),size,bank,palette)
                                             for i in range(8)) for bank in colors) + '      },\n'
    yield '      lifted={\n'
    for bank in colors:
        yield rows((tuple(art(pointer(program,0xED8C2+4*i),0x1290,bank,palette) if i else 0
                          for i in range(-5,6)),), '        ')
    yield '      },\n'
    yield '      wreckLeft={' + ','.join(str(art(0x20F08C,0xC30,bank,palette)) for bank in colors) + '},\n'
    yield '      wreckRight={' + ','.join(str(art(0x2101D0,0x1040,bank,palette)) for bank in colors) + '},\n'
    yield '      lights={\n' + rows(tuple(art(a,0x210,bank,palette) for bank in (0x1a,0x5a))
                                         for a in (0x21369C,0x21369C ^ 0x2C)) + '      },\n'
    yield f'      marker={art(0x2136C4,0x848,0x18,palette)},\n'
    yield '    },\n  },\n'


def large_vehicle_data(program, art):
    yield '  largeVehicle={\n'
    yield '    centerMuzzle={\n' + rows(struct.unpack_from('>hh',program,0xD66DA+4*i)
                                         for i in range(32)) + '    },\n'
    yield '    sideMuzzle={\n' + rows(struct.unpack_from('>hh',program,0xD74DA+4*i)
                                       for i in range(32)) + '    },\n'
    for kind,stage,state,part,base,body_size,track_size in (
            (0x2f,4,0xDB358,0xDB380,0xDBCA8,0x1098,0x248),
            (0x40,5,0xDBDB2,0xDBDDA,0xDC702,0x1088,0x878)):
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:state+40]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        for name,address,count in (('breakup',base+0x30,3),('death',base+0x56,6)):
            items = []
            for i in range(count):
                delay,effect,attr,h,l,velocity = struct.unpack_from('>HHHhhH',program,address+12*i)
                items.append((delay,effect,attr,h,l,velocity>>8,velocity&255))
            yield f'      {name}={{\n' + rows(items,'        ') + '      },\n'
        banks = palette_banks(program, pointer(program, pointer(program,0xCB8C6+4*(stage-1))))
        color, mask = program[0xDB34E+2*(stage-1):0xDB350+2*(stage-1)]
        colors = (color,color^mask,0x19)
        palette = np.zeros((0x400,3), dtype='u1')
        for bank in colors:
            palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))
        for name,address,size,count in (('hull',base,body_size,8),('track',base+0x20,track_size,4),
                ('center',0xD665A,0x848,32),('side',0xD745A,0x420,32)):
            yield f'      {name}={{\n' + rows((tuple(art(pointer(program,address+4*i),size,bank,palette)
                for i in range(count)) for bank in colors),'        ') + '      },\n'
        yield '    },\n'
    yield '  },\n'


def ground59_data(program, art):
    yield '  ground59={\n'
    yield '    state=' + lua_bytes(program[0xE39F6:0xE3A20]) + ',\n'
    yield '    part=' + lua_bytes(program[0xE3A20:0xE3A40]) + ',\n'
    yield '    second=' + lua_bytes(program[0xE3A40:0xE3A60]) + ',\n'
    for name,address,count in (('muzzleA',0xE4CAA,32),('muzzleB',0xE4D2A,32),
            ('spreadA',0xE4DAA,32),('spreadB',0xE4E2A,32),('radial',0xD775A,64)):
        yield f'    {name}={{' + ','.join(str(pointer(program,address+4*i)) for i in range(count)) + '},\n'
    for name,address in (('breakup',0xE493C),('death4',0xE4988),('death5',0xE4A26)):
        items = []
        while word(program, address) != 0xffff:
            delay,effect,attr,h,l,velocity = struct.unpack_from('>HHHhhH',program,address)
            items.append((delay,effect,attr,h,l,velocity>>8,velocity&255))
            address += 12
        yield f'    {name}={{\n' + rows(items) + '    },\n'
    items = []
    for i in range(14):
        kind,attr,h,l,_,vel,_,_,delay = struct.unpack_from('>HHhh5H',program,0xE4B54+18*i)
        items.append((delay,kind,attr | (0x40 if i == 2 else 0),h,l,vel>>8,vel&255))
    yield '    wreck={\n' + rows(items) + '    },\n'
    yield '    art={\n'
    for stage in (4,5):
        color,mask = program[0xE39AC+2*(stage-1):0xE39AE+2*(stage-1)]
        colors = (color,color^mask,0x19)
        banks = palette_banks(program, pointer(program, pointer(program,0xCB8C6+4*(stage-1))))
        palette = np.zeros((0x400,3), dtype='u1')
        for bank in (*colors,0x1a):
            palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))
        yield f'      [{stage}]={{\n'
        for name,size,addresses in (
                ('hull',0x1a50,(0x1FCB60,)),('left',0x820,(0x1FCF74,)),('right',0x820,(0x1FCFF8,)),
                ('cover',0x628,tuple(pointer(program,0xE4914+4*i) for i in range(8))),
                ('gun',0xA40,tuple(pointer(program,0xE4894+4*i) for i in range(32)))):
            yield f'        {name}={{\n' + rows((tuple(art(a,size,bank,palette) for a in addresses)
                    for bank in colors),'          ') + '        },\n'
        yield '        exhaust={\n' + rows((tuple(art(pointer(program,0xE4934+4*i),0xA28,bank,palette)
                                    for bank in (0x1a,0x5a)) for i in range(2)),'          ') + '        },\n'
        yield '      },\n'
    yield '    },\n  },\n'


def hover_data(program, art):
    banks = palette_banks(program, pointer(program, pointer(program, 0xCB8D6)))
    palette = np.zeros((0x400,3), dtype='u1')
    hull_colors = (0x10,0x1f,0x19)
    for bank in (*hull_colors,0x16,0x17,0x1b,0x1d):
        palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))
    yield '  hover={\n'
    yield '    cannonAngles={\n' + rows(tuple(program[0xF4524+i*8:0xF4528+i*8])
                                        for i in range(64)) + '    },\n'
    for kind,state,part,approach,glow,hatch,base,flame,bank in (
        (0x9a,0xF2552,0xF2578,0xF2A04,0xF2A48,0xF2BE2,0xF300E,0xF3052,0x17),
        (0x9b,0xF31FE,0xF3228,0xF3716,0xF375A,0xF392E,0xF3DA4,0xF3F24,0x16)):
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:part]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        yield '      second=' + lua_bytes(program[part+32:part+64]) + ',\n'
        yield '      nozzles={\n' + rows((tuple(program[part+i*32+12:part+i*32+16])
                                    + tuple(program[part+i*32+22:part+i*32+24])
                                    + (program[part+i*32+26],) for i in range(2,6)),'        ') + '      },\n'
        yield '      approach={\n' + rows((tuple(art(pointer(program,approach+4*i),0x620,color,palette)
                                    for i in range(-8,9)) for color in hull_colors),'        ') + '      },\n'
        yield '      glow={\n'
        for color in hull_colors:
            yield '        {\n' + rows((tuple(art(pointer(program,pointer(program,glow+4*i)+4*j),0x630,color,palette)
                                for j in range(4)) for i in range(-8,9)),'          ') + '        },\n'
        yield '      },\n'
        for name,addr,count in (('hatch',hatch,32),('body',base,32 if kind==0x9b else 17)):
            yield f'      {name}={{\n'
            for i in range(count):
                if name=='body' and kind==0x9a:
                    mask, h, l, speed, size = pointer(program,addr+4*(i-8)),-0xA00,-0x400,0,0xA20
                else:
                    mask,h,l,speed,size = struct.unpack_from('>IhhHH',program,addr+i*12)
                yield rows(((h,l,speed,*(art(mask,size,c,palette) for c in hull_colors)),),'        ')
            yield '      },\n'
        yield '      wake={\n'
        for color in hull_colors:
            if kind==0x9a:
                yield '        {\n' + rows((tuple(art(pointer(program,pointer(program,flame+4*i)+4*j),0x838,color,palette)
                                  for j in range(4)) for i in range(-8,9)),'          ') + '        },\n'
            else:
                yield rows((tuple(art(pointer(program,flame+4*j),0x830,color|0x40,palette)
                                  for j in range(4)),),'        ')
        yield '      },\n'
        for name,addr in (('initialNozzle',0xBCE14),('liveNozzle',0xBD0B4)):
            if kind==0x9b and name=='initialNozzle':
                continue
            yield f'      {name}={{\n'
            for color in (bank,0x1f,0x19):
                yield '        {\n' + rows((tuple(art(pointer(program,pointer(program,addr+4*i)+4*j),0x410,
                                        color | (0x40 if i>=16 else 0),palette) for j in range(8))
                                        for i in range(32)),'          ') + '        },\n'
            yield '      },\n'
        yield '    },\n'
    yield '  },\n'
    yield '  lifeDrop={\n'
    yield '    sprites={' + ','.join(str(art(pointer(program,0xF5702+4*i),0x420,0x1b,palette))
                                    for i in range(4)) + '},\n'
    yield '    taken={' + ','.join(str(art(pointer(program,0xF4C8A+4*i),0x450,0x1d,palette))
                                  for i in range(30)) + '},\n'
    yield '    full={' + ','.join(str(art(pointer(program,0xF4E0A+4*i),0x430,0x1d,palette))
                                 for i in range(17)) + '},\n'
    yield '  },\n'


def item_data(program, art):
    yield '  item={\n'
    for name, address in (('extend', 0xFE11A), ('extendAgain', 0xFE12A)):
        yield f'    {name}={{{",".join(map(str, struct.unpack_from(">4i", program, address)))}}},\n'
    yield '    initialLives={' + ','.join(map(str, struct.unpack_from('>5H', program, 0xFE21E))) + '},\n'
    for kind, address, size in ((0, 0xF51A4, 0x618), (4, 0xF537A, 0x620), (8, 0xF554E, 0x618)):
        yield f'    [{kind}]={{{",".join(str(art(pointer(program,address+4*i),size,0x1b)) for i in range(4))}}},\n'
    for name, address, count in (('powerTaken',0xF4D82,30), ('bombTaken',0xF4D02,30), ('powerFull',0xF4E4E,17)):
        size = word(program, address+4)
        yield f'    {name}={{{",".join(str(art(pointer(program,address+8+4*i),size,0x1d)) for i in range(count))}}},\n'
    yield '  },\n'


def chip_data(program, art):
    yield '  chip={\n'
    yield '    headingRandom=' + lua_bytes(program[0xAF830:0xAF870]) + ',\n'
    yield '    returnRoll=' + lua_bytes(program[0xAE308:0xAE408]) + ',\n'
    yield '    returnScatter={\n' + rows(struct.unpack_from('>hh',program,0xAFD3A+i*4)
                                        for i in range(64)) + '    },\n'
    yield '    returnBounds={\n' + rows(struct.unpack_from('>HH',program,0xAE0FA+i*4)
                                       for i in range(5)) + '    },\n'
    yield '    returnSprites={' + ','.join(str(art(0x27CC10+i*0x14,0x210,0x1a)) for i in range(6)) + '},\n'
    for kind, stride in enumerate((0x24,0x24,0x34,0x4c,0x64)):
        h,l,address,size,front,back,right,left = struct.unpack_from('>hhI5H',program,0xF6894+kind*22)
        yield '    {' + ','.join(map(str,(h,l,front,back,right,left))) + ',{'
        yield ','.join(str(art(address+i*stride,size,0x1c)) for i in range(32))
        yield '}},\n'
    yield '  },\n'


def raid_data(program, art):
    yield '  raid={\n'
    yield '    state=' + lua_bytes(program[0xED9D2:0xED9DA]) + ',\n'
    yield '    part=' + lua_bytes(program[0xED9DA:0xED9FA]) + ',\n'
    yield '    jitter=' + lua_bytes(program[0xAF1CE:0xAF2CE]) + ',\n'
    yield '    path=' + lua_bytes(program[0xEDB02:0xEDB08]) + ',\n'
    yield '    lanes={' + ','.join(str(word(program,0xEDB08+2*i)) for i in range(30)) + '},\n'
    for kind,base,part in ((0x1c,0xD32FA,0xD3314),(0x1d,0xD3716,0xD3730),(0x1f,0xD2F9C,0xD2FB6)):
        yield f'    [{kind}]={{state=' + lua_bytes(program[base:part]) + ',part=' + lua_bytes(program[part:part+32]) + '},\n'
    yield '    offsets={\n' + rows(struct.unpack_from('>hh',program,0xD2DF4+4*i) for i in range(32)) + '    },\n'
    yield '    scoutMuzzles={\n' + rows(struct.unpack_from('>hh',program,0xD2E74+4*i)
                                       for i in range(32)) + '    },\n'
    banks = palette_banks(program, pointer(program, pointer(program,0xCB8D6)))
    palette = np.zeros((0x400,3), dtype='u1')
    for bank in (0x14,0x1f):
        palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))
    yield '    art={\n'
    for color in (0x14,0x1f):
        yield '      {\n' + rows((tuple(art(pointer(program,0xD2C74+12*i+4*j),0x840,color,palette)
                                    for j in range(3)) for i in range(32)),'        ') + '      },\n'
    yield '    },\n  },\n'


def early_vehicle_data(program, art):
    yield '  earlyVehicle={\n'
    for kind,stage,state,part,bank in ((0x84,1,0xEACA0,0xEACC4,0x15),
            (0x44,2,0xDE448,0xDE468,0x0f),(0x4a,2,0xE7FB2,0xE7FB6,0x11),
            (0x4b,2,0xE8136,0xE813A,0x11),(0x56,2,0xE33BE,0xE33E8,0x0d),
            (0x55,2,0xE2EA2,0xE2ECC,0x0d),(0x45,2,0xE6A9C,0xE6AA8,0x0e),
            (0x48,2,0xE7A56,0xE7A6E,0x0d),(0x46,2,0xE6D8C,0xE6DB2,0x0b),
            (0x47,2,0xE73AA,0xE73D0,0x0b)):
        colors = (bank,0x1f,0x19)
        banks = palette_banks(program, pointer(program, pointer(program,0xCB8C6+4*(stage-1))))
        palette = np.zeros((0x400,3), dtype='u1')
        for color in (*colors, 0x13) if kind in (0x46,0x47) else colors:
            palette[color*32:(color+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[color]))
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:part]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        if kind==0x84:
            yield '      second={\n'
            for i in (1,2,4):
                yield '        ' + lua_bytes(program[part+i*32:part+(i+1)*32]) + ',\n'
            yield '      },\n'
            yield '      order={' + ','.join(str(x) for x in program[0xAF830:0xAF870]) + '},\n'
            yield '      cycle={\n' + rows(struct.unpack_from('>2h',program,0xEAC90+4*i)
                                         for i in range(4)) + '      },\n'
            yield '      mounts={\n' + rows(struct.unpack_from('>hhhh',program,0xEB678+8*i)
                                          for i in range(8)) + '      },\n'
            yield '      nozzle={\n' + rows(struct.unpack_from('>hh',program,0xD73DA+4*i)
                                          for i in range(32)) + '      },\n'
            yield '      radial={' + ','.join(str(pointer(program,0xD755A+4*i)) for i in range(64)) + '},\n'
            for name,base,count in (('breakup',0xEB734,8),('death',0xEB6C8,6)):
                items = []
                for i in range(count):
                    effect,attr,h,l,_,vel,_,_,delay = struct.unpack_from('>HHhh5H',program,base+18*i)
                    items.append((delay,effect,attr,h,l,vel>>8,vel&255))
                yield f'      {name}={{\n' + rows(items,'        ') + '      },\n'
        if kind in (0x55,0x56):
            ports = 0xE333A if kind==0x55 else 0xE3856
            yield '      hatchMuzzle={\n' + rows(struct.unpack_from('>hh',program,ports+4*i)
                                                for i in range(4)) + '      },\n'
            yield '      muzzle={\n' + rows(struct.unpack_from('>hh',program,0xD74DA+4*i)
                                           for i in range(32)) + '      },\n'
        if kind==0x45:
            for name,base in (('leftMuzzle',0xD67DA),('rightMuzzle',0xD685A)):
                yield f'      {name}={{\n' + rows(struct.unpack_from('>hh',program,base+4*i)
                                               for i in range(32)) + '      },\n'
            yield '      death={{0,0x84,0,0,0,0,0},{3,0x87,0,-513,-1024,2,0xb0},{6,0x88,0,-1536,512,3,0x70}},\n'
        if kind==0x48:
            for name,base in (('leftMuzzle',0xE7E60),('rightMuzzle',0xE7EE0)):
                yield f'      {name}={{\n' + rows(struct.unpack_from('>hh',program,base+4*i)
                                               for i in range(32)) + '      },\n'
            yield '      initialHeading=' + lua_bytes(program[0xAF2EC:0xAF36C]) + ',\n'
            yield '      death={\n' + rows(effect_commands(program,0xE7CF0),'        ') + '      },\n'
            yield '      gun={\n' + rows((tuple(art(pointer(program,0xE7D60+8*(angle//2)+4*frame),0xC50,
                                                      color | (0x40 if angle>32 else 0),palette)
                                                for angle in range(64) for frame in (0,1))
                                          for color in colors),'        ') + '      },\n'
        if kind in (0x46,0x47):
            yield '      second={\n'
            for i in range(1,4):
                yield '        ' + lua_bytes(program[part+i*32:part+(i+1)*32]) + ',\n'
            yield '      },\n'
            body_flip = 0x40 if kind==0x47 else 0
            yield '      body={' + ','.join(str(art(0x305950,0x1A78,color|body_flip,palette))
                                            for color in colors) + '},\n'
            doors = ((0x308B20,0xA28),(0x308BEC,0xA28),(0x308CB8,0x820)) if kind==0x46 else (
                     (0x308D3C,0x820),(0x308DC0,0xA28),(0x308E8C,0xA28))
            yield '      doors={\n' + rows((tuple(art(a,size,color,palette) for a,size in doors)
                                           for color in (0x13,0x1f,0x19)),'        ') + '      },\n'
            yield '      death={\n'
            for i in range(9):
                effect,_,h,l,_,velocity,delay = struct.unpack_from('>HHhhHHH',program,0xE7936+14*i)
                yield rows(((delay,effect,0,h,l,velocity>>8,velocity&255),),'        ')
            yield '      },\n'
        art_sets = {
            0x84: (('rotors',0x420,tuple(pointer(program,0xEB6B8+4*i) for i in range(4))),
                   ('gun',0x420,tuple(pointer(program,0xD735A+4*i) for i in range(32)))),
            0x44: (('tracks',0x810,tuple(pointer(program,0xDE924+4*i) for i in range(4))),
                   ('frontGun',0x420,tuple(pointer(program,0xD6CDA+4*i) for i in range(32))),
                   ('rearGun',0x628,tuple(pointer(program,0xD6E5A+4*i) for i in range(32)))),
            0x56: (('tracks',0x448,tuple(pointer(program,0xE37FA+4*i) for i in range(4))),
                   ('hatch',0xA50,tuple(pointer(program,0xE37DA+4*i) for i in range(8))),
                   ('gun',0x420,tuple(pointer(program,0xD745A+4*i) for i in range(32)))),
            0x4a: (), 0x4b: (),
            0x55: (('tracks',0x448,tuple(pointer(program,0xE32DE+4*i) for i in range(4))),
                   ('hatch',0xA50,tuple(pointer(program,0xE32BE+4*i) for i in range(8))),
                   ('gun',0x420,tuple(pointer(program,0xD745A+4*i) for i in range(32)))),
            0x45: (('gun',0x838,tuple(pointer(program,0xD675A+4*i) for i in range(32))),),
            0x48: (), 0x46: (), 0x47: (),
        }
        if kind in (0x84,0x44,0x4a,0x4b):
            body,size={0x84:(0x1F5344,0x1280),0x44:(0x227750,0xE58),
                       0x4a:(0x309074,0x820),0x4b:(0x308F58,0xE28)}[kind]
            yield '      body={' + ','.join(str(art(body,size,color,palette)) for color in colors) + '},\n'
        for name,size,addresses in art_sets[kind]:
            yield f'      {name}={{\n' + rows((tuple(art(a,size,color,palette) for a in addresses)
                                            for color in colors),'        ') + '      },\n'
        if kind==0x44:
            for name,addr in (('breakup',0xDE934),('death',0xDE94E)):
                yield f'      {name}={{\n' + rows(effect_commands(program,addr),'        ') + '      },\n'
        elif kind in (0x55,0x56):
            yield '      death={\n' + rows(effect_commands(program,0xE3314 if kind==0x55 else 0xE3830),
                                          '        ') + '      },\n'
        if kind in (0x84,0x44,0x55,0x56):
            cursor={0x84:0xEAD64,0x44:0xDE488,0x55:0xE2EEC,0x56:0xE3408}[kind]
            yield '      smoke={\n'
            while word(program,cursor)!=0xffff:
                hp,h,l,_,attr,script = struct.unpack_from('>HhhHHI',program,cursor)
                variants=[]
                while word(program,script)!=0xffff:
                    variants.append(word(program,script)//4+1)
                    script+=2
                yield '        {' + ','.join(map(str,(hp,h,l,attr,*variants))) + '},\n'
                cursor+=14
            yield '      },\n'
        yield '    },\n'
    yield '  },\n'

    smoke_frames = []
    for i in range(6):
        base=pointer(program,0x101554+4*i)
        h,l,size,bank,clock,last=struct.unpack_from('>hhHHHH',program,base+2)
        smoke_frames.append((base,h,l,size,bank,clock,last,{}))
    for stages in ((1,2),(5,),(3,)):
        for base,h,l,size,bank,clock,last,sprites in smoke_frames:
            for stage in stages:
                banks=palette_banks(program,pointer(program,pointer(program,0xCB8C6+4*(stage-1))))
                palette=np.zeros((0x400,3),dtype='u1')
                palette[bank*32:(bank+1)*32]=decode_palette(struct.unpack_from('>32H',program,banks[bank]))
                sprites[stage] = rows((tuple(art(pointer(program,base+14+4*j),size,bank|flip,palette)
                                              for j in range(last//4+1)) for flip in (0,0x20,0x40)),'        ')
    yield '  attachedSmoke={\n'
    for _,h,l,_,_,clock,_,sprites in smoke_frames:
        yield '    {h=%d,l=%d,clock=%d,art={\n' % (h,l,clock)
        for stage, frames in sprites.items():
            yield f'      [{stage}]={{\n' + frames + '      },\n'
        yield '    }},\n'
    yield '  },\n'


def heavy_hatch_data(program, art):
    banks = palette_banks(program, pointer(program, pointer(program,0xCB8D6)))
    yield '  heavyHatch={\n'
    yield '    radial={' + ','.join(str(pointer(program,0xD775A+4*i)) for i in range(64)) + '},\n'
    for kind,state,part,bank,body,size,tracks,track_size,death in (
            (0x5e,0xE55C0,0xE55EA,0x0d,0x234124,0xE60,0xE5B74,0x248,0xE5BAA),
            (0x5f,0xE5D2A,0xE5D54,0x0d,0x233838,0xE78,0xE62DE,0x478,0xE6314),
            (0x0e,0xE6484,0xE64AE,0x0b,0x2344F8,0x1060,0xE6936,0x818,0xE697C)):
        colors=(bank,0x1f,0x19)
        palette=np.zeros((0x400,3),dtype='u1')
        for color in colors:
            palette[color*32:(color+1)*32]=decode_palette(struct.unpack_from('>32H',program,banks[color]))
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:part]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        yield '      death={\n' + rows(effect_commands(program,death),'        ') + '      },\n'
        yield '      smoke={\n'
        cursor=part+32
        while word(program,cursor)!=0xffff:
            hp,h,l,_,attr,script=struct.unpack_from('>HhhHHI',program,cursor)
            variants=[]
            while word(program,script)!=0xffff:
                variants.append(word(program,script)//4+1)
                script+=2
            yield '        {' + ','.join(map(str,(hp,h,l,attr,*variants))) + '},\n'
            cursor+=14
        yield '      },\n'
        yield '      body={' + ','.join(str(art(body,size,color,palette)) for color in colors) + '},\n'
        art_sets = [('tracks',track_size,[pointer(program,tracks+4*i) for i in range(4)])]
        if kind==0x0e:
            yield '      ports={\n' + rows(struct.unpack_from('>hh',program,0xE6A2A+4*i)
                                          for i in range(4)) + '      },\n'
            yield '      muzzle={\n' + rows(struct.unpack_from('>4h',program,0xD79DA+8*i)
                                           for i in range(32)) + '      },\n'
            art_sets.append(('rightTrack',track_size,[pointer(program,0xE6946+4*i) for i in range(4)]))
            gun=0xD795A
        else:
            port=0xE5C66 if kind==0x5e else 0xE63D0
            for name,address in (('ports',port),('capOffsets',port+40)):
                yield f'      {name}={{\n' + rows(struct.unpack_from('>hh',program,address+4*i)
                                               for i in range(10)) + '      },\n'
            yield '      muzzle={\n' + rows(struct.unpack_from('>hh',program,0xD6EDA+4*i)
                                           for i in range(32)) + '      },\n'
            for name,address,sprite_size in (('hatch',0x233B84,0x1228),('cap',0x233CF0,0x818)):
                yield f'      {name}={{' + ','.join(str(art(address,sprite_size,color,palette))
                                                  for color in colors) + '},\n'
            gun=0xD6E5A
        art_sets.append(('gun',0x628,[pointer(program,gun+4*i) for i in range(32)]))
        for name,sprite_size,addresses in art_sets:
            yield f'      {name}={{\n' + rows((tuple(art(a,sprite_size,color,palette) for a in addresses)
                                            for color in colors),'        ') + '      },\n'
        yield '    },\n'
    yield '  },\n'


def breakaway_tank_data(program, art):
    yield '  breakawayTank={\n'
    yield '    jitter={' + ','.join(map(str,struct.unpack_from('>16h',program,0xDA262))) + '},\n'
    for name,base,count in (('muzzle',0xD66DA,32),('ring',0xD755A,64),('outerRing',0xD775A,64)):
        yield f'    {name}={{\n' + rows(struct.unpack_from('>hh',program,base+4*i)
                                       for i in range(count)) + '    },\n'
    for kind,source,part,ports,hull,wreck,size,tracks,track_size,death in (
            (0x2c,0xD9BAA,0xD9BD0,0xDA2F2,0xDA232,0x2186B8,0x1098,0xDA252,0x248,0xDA282),
            (0x2d,0xDA390,0xDA3B6,0xDAAB4,0xDAA14,0x21AF9C,0x1090,0xDAA34,0x878,0xDAA44),
            (0x2e,0xDAB7A,0xDABA0,0xDB29E,0xDB1FE,0x21D840,0x1090,0xDB21E,0x878,0xDB22E)):
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[source:part]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        yield '      ports={\n' + rows(struct.unpack_from('>hh',program,ports+4*i)
                                     for i in range(6)) + '      },\n'
        for name,address in (('breakup',death),('death',death+0x26)):
            yield f'      {name}={{\n' + rows(effect_commands(program,address),'        ') + '      },\n'
        yield '      smoke={\n'
        cursor=part+32
        while word(program,cursor)!=0xffff:
            hp,h,l,_,attr,script=struct.unpack_from('>HhhHHI',program,cursor)
            variants=[]
            while word(program,script)!=0xffff:
                variants.append(word(program,script)//4+1)
                script+=2
            yield '        {' + ','.join(map(str,(hp,h,l,attr,*variants))) + '},\n'
            cursor+=14
        yield '      },\n      art={\n'
        for stage in {0x2c:(3,),0x2d:(5,),0x2e:(1,5)}[kind]:
            banks=palette_banks(program,pointer(program,pointer(program,0xCB8C6+4*(stage-1))))
            colors=(program[0xD9BA0+2*(stage-1)],0x1f,0x19)
            palette=np.zeros((0x400,3),dtype='u1')
            for color in colors:
                palette[color*32:(color+1)*32]=decode_palette(struct.unpack_from('>32H',program,banks[color]))
            yield f'        [{stage}]={{\n'
            for name,sprite_size,addresses in (
                    ('hull',size,[pointer(program,hull+4*i) for i in range(8)]+[wreck]),
                    ('tracks',track_size,[pointer(program,tracks+4*i) for i in range(4)]),
                    ('gun',0x848,[pointer(program,0xD665A+4*i) for i in range(32)])):
                yield f'          {name}={{\n' + rows((tuple(art(a,sprite_size,color,palette) for a in addresses)
                                                     for color in colors),'            ') + '          },\n'
            yield '        },\n'
        yield '      },\n    },\n'
    yield '  },\n'


def scenery_data(program, art):
    palette=np.zeros((0x400,3),dtype='u1')
    for bank,source in ((0x11,0x64320),(0x15,0x64360),(0x16,0x64360)):
        palette[bank*32:(bank+1)*32]=decode_palette(struct.unpack_from('>32H',program,source))
    yield '  scenery={\n'
    for kind,state,part in ((0x8d,0xF16DC,0xF16E4),(0x92,0xF1876,0xF1884)):
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:part]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        if kind==0x8d:
            yield f'      art={{{art(0x2FE9D0,0x24D8,0x15,palette)},{art(0x2FD6AC,0x2320,0x16,palette)}}},\n'
        else:
            yield '      art={\n'
            for i in range(1,16):
                address = pointer(program,0xF1954+4*i)
                yield rows(((art(address,0x22B0,0x11,palette),art(address,0x22B0,0x51,palette)),),'        ')
            yield '      },\n'
        yield '    },\n'
    yield '  },\n'


def deck_carrier_data(program, art):
    yield '  deckCarrier={\n'
    yield '    state=' + lua_bytes(program[0xE1AC4:0xE1AE6]) + ',\n'
    yield '    part=' + lua_bytes(program[0xE1AE6:0xE1B06]) + ',\n'
    yield '    second={\n'
    for i in range(1,5):
        yield '      ' + lua_bytes(program[0xE1AE6+32*i:0xE1B06+32*i]) + ',\n'
    yield '    },\n    mounts={\n'
    for i in range(4):
        base=0xE1B86+32*i
        yield rows((struct.unpack_from('>4Bhh4B',program,base+2),),'      ')
    yield '    },\n'
    for name,base,count in (('gunMuzzle',0xE2884,32),('portMuzzle',0xD755A,64),('fanMuzzle',0xD765A,64)):
        yield f'    {name}={{\n' + rows(struct.unpack_from('>hh',program,base+4*i)
                                       for i in range(count)) + '    },\n'
    for name,base in (('innerBreak',0xE26EA),('outerBreak',0xE271C),('death',0xE274E)):
        yield f'    {name}={{\n' + rows(effect_commands(program,base)) + '    },\n'
    yield '    wreck={\n'
    for i in range(5):
        effect,_,h,l,_,velocity,_,_,delay=struct.unpack_from('>HHhhHHHHH',program,0xE27EC+18*i)
        yield rows(((delay,effect,0,h,l,velocity>>8,velocity&255),),'      ')
    yield '    },\n    art={\n'
    for stage in (3,5):
        banks=palette_banks(program,pointer(program,pointer(program,0xCB8C6+4*(stage-1))))
        colors=(program[0xE1ABA+2*(stage-1)],0x1f,0x19)
        palette=np.zeros((0x400,3),dtype='u1')
        for color in colors:
            palette[color*32:(color+1)*32]=decode_palette(struct.unpack_from('>32H',program,banks[color]))
        yield f'      [{stage}]={{\n'
        for name,addresses in (
                ('body',((0x1FBEB0,0xC48),(0x1FBD6C,0xA40),(0x1FC064,0xA40))),
                ('ports',((0x1FCB4C,0x210),(0x1FCB38,0x210))),
                ('gun',tuple((pointer(program,0xE266A+4*i),0x420) for i in range(32))),
                ('rotors',tuple((pointer(program,0xE265A+4*i),0x420) for i in range(4)))):
            grow_x = pointer(program,0xA7870) if stage==5 and name=='body' else 0
            yield f'        {name}={{\n' + rows((tuple(art(a,size,color,palette,grow_x=grow_x) for a,size in addresses)
                                                  for color in colors),'          ') + '        },\n'
        yield '      },\n'
    yield '    },\n  },\n'


def platform_cannon_data(program, art):
    banks=palette_banks(program,pointer(program,pointer(program,0xCB8D6)))
    colors=(program[0xF1A18],0x1f,0x19)
    palette=np.zeros((0x400,3),dtype='u1')
    for color in colors:
        palette[color*32:(color+1)*32]=decode_palette(struct.unpack_from('>32H',program,banks[color]))
    yield '  platformCannon={\n'
    yield '    state=' + lua_bytes(program[0xF1A1A:0xF1A2C]) + ',\n'
    yield '    part=' + lua_bytes(program[0xF1A2C:0xF1A4C]) + ',\n'
    yield '    ports={\n' + rows(struct.unpack_from('>hh',program,0xF2426+4*i)
                                 for i in range(16)) + '    },\n'
    yield '    death={\n'
    for i in range(8):
        effect,_,h,l,_,velocity,_,_,delay=struct.unpack_from('>HHhhHHHHH',program,0xF1F2E+18*i)
        yield rows(((delay,effect,0,h,l,velocity>>8,velocity&255),),'      ')
    yield '    },\n    frames={\n'
    for i in range(16):
        yield '      {\n'
        for table,count in ((0xF1FBE,4),(0xF22FE,1),(0xF236E,1)):
            row=pointer(program,table+4*i)
            for j in range(count):
                address,h,l,_,size=struct.unpack_from('>IhhHH',program,row+12*j)
                sprites=(art(address,size,color,palette) for color in colors)
                yield rows(((*sprites,h,l),),'        ')
        yield '      },\n'
    yield '    },\n  },\n'


def rising_turret_data(program, art):
    banks=palette_banks(program,pointer(program,pointer(program,0xCB8C6)))
    yield '  risingTurret={\n'
    yield '    muzzles={\n' + rows(struct.unpack_from('>8h',program,0xE9C1E+16*i)
                                   for i in range(32)) + '    },\n'
    for kind,state,part,bank,gun,door,platform,platform_size,death in (
            (0x88,0xEFE50,0xEFE68,0x13,0xE9B9E,0x2E9BBC,0x2E9074,0x1290,0xF0300),
            (0x89,0xF03AC,0xF03C4,0x16,0xE9B9E,0x2E9FF8,0x2E9588,0x12B0,0xF0858),
            (0x8a,0xF0904,0xF0920,0x16,0xE9B9E,0x2EA434,0,0,0xF0F1E),
            (0x8b,0xF0FCA,0xF0FE6,0x16,0xE9E1E,0x2EA434,0,0,0xF157E)):
        palette=np.zeros((0x400,3),dtype='u1')
        colors=(bank,0x1f,0x19)
        for color in colors:
            source=0x64320 if color==bank else banks[color]
            palette[color*32:(color+1)*32]=decode_palette(struct.unpack_from('>32H',program,source))
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:part]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        if platform:
            yield f'      door={art(door,0x1278,bank,palette)},platform={art(platform,platform_size,bank,palette)},\n'
        else:
            attr=bank|(0x40 if kind==0x8b else 0)
            yield f'      door={art(door,0x1250,attr,palette)},\n'
            yield '      cover={' + ','.join(str(art(pointer(program,0xF0EBE+4*i),0xE50,attr,palette))
                                            for i in range(24)) + '},\n'
        yield '      gun={\n' + rows((tuple(art(pointer(program,gun+4*i),0xC50,color,palette)
                                             for i in range(32)) for color in colors),'        ') + '      },\n'
        yield '      death={\n'
        for i in range(5):
            effect,_,h,l,_,velocity,_,_,delay=struct.unpack_from('>HHhhHHHHH',program,death+18*i)
            yield rows(((delay,effect,0,h,l,velocity>>8,velocity&255),),'        ')
        yield '      },\n    },\n'
    yield '  },\n'


def linked_cannon_data(program, art):
    banks=palette_banks(program,pointer(program,pointer(program,0xCB8C6)))
    yield '  linkedCannon={\n'
    for kind,state,part,bank,death in (
            (0x86,0xEECCE,0xEECEA,0x14,0xEF4C6),(0x87,0xEF598,0xEF5B4,0x13,0xEFDA4)):
        palette=np.zeros((0x400,3),dtype='u1')
        colors=(bank,0x1f,0x19)
        for color in colors:
            source=0x64320 if color==bank else banks[color]
            palette[color*32:(color+1)*32]=decode_palette(struct.unpack_from('>32H',program,source))
        yield f'    [{kind}]={{\n'
        yield '      state=' + lua_bytes(program[state:part]) + ',\n'
        yield '      part=' + lua_bytes(program[part:part+32]) + ',\n'
        yield '      second={\n'
        for i in range(1,3):
            yield '        ' + lua_bytes(program[part+32*i:part+32*(i+1)]) + ',\n'
        yield '      },\n      art={\n'
        for i in (0,2):
            address,size = struct.unpack_from('>IH',program,part+32*i+6)
            yield rows((tuple(art(address,size,color,palette) for color in colors),),'        ')
        yield '      },\n      gun={\n'
        yield rows((tuple(art(pointer(program,0xE9B9E+4*i),0xC50,color,palette)
                          for i in range(32)) for color in colors),'        ')
        yield '      },\n      death={\n'
        for i in range(5):
            effect,_,h,l,_,velocity,_,_,delay=struct.unpack_from('>HHhhHHHHH',program,death+18*i)
            yield rows(((delay,effect,0,h,l,velocity>>8,velocity&255),),'        ')
        yield '      },\n    },\n'
    yield '  },\n'


def mid1_data(program, art):
    stream = pointer(program, pointer(program, 0xCB8C6))
    banks = palette_banks(program, stream)
    banks.update({0x0f:0x632E0, 0x10:0x63320, 0x11:0x633A0})
    palette = np.zeros((0x400,3), dtype='u1')
    for bank in (0x0f,0x10,0x11,0x19,0x1f):
        palette[bank*32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H',program,banks[bank]))

    yield '  mid1={\n'
    yield '    hp={' + ','.join(str(pointer(program,0x12EADE+4*i)) for i in range(3)) + '},\n'
    yield '    boxes={\n' + rows(struct.unpack_from('>4h',program,0x12EAEC+32*i+12)
                                  for i in (1,2,6,7,8,9,10)) + '    },\n'
    yield '    droneBoxes={\n' + rows(struct.unpack_from('>4h',program,0x130A18+32*i+12)
                                       for i in range(2)) + '    },\n'
    for name,start,count in (('muzzle',0xD755A,64),('droneMuzzle',0x130CBE,32)):
        yield f'    {name}={{' + ','.join(str(pointer(program,start+4*i)) for i in range(count)) + '},\n'
    for name,start,count in (('leftBreak',0x12F374,6),('rightBreak',0x12F50E,6),('hullBreak',0x12F8A8,14)):
        effects = []
        for i in range(count):
            kind, attr, h, l, vel, _, _, delay = struct.unpack_from('>HHhh4H',program,start+16*i)
            effects.append((delay,kind,attr,h,l,vel>>8,vel&255))
        yield f'    {name}={{\n' + rows(effects) + '    },\n'

    yield '    art={\n'
    yield '      hull={' + ','.join(str(art(0x1770D4,0x1E60,bank,palette)) for bank in (0xf,0x1f,0x19)) + '},\n'
    for name,start,size,count,bases in (
            ('left',0x12ED5A,0xe60,8,(0x10,0x1f,0x19)),('right',0x12EDAE,0xe60,8,(0x10,0x1f,0x19)),
            ('barrel',0x12EDFC,0x410,12,(0xf,0x1f,0x19)),('deck',0x12EE5A,0x14b0,8,(0xf,0x1f,0x19)),
            ('shell',0x12EEBC,0x18c0,8,(0x11,)),('shellOpen',0x12EF02,0x1ec0,16,(0x11,)),
            ('drones',0x130C1E,0x420,8,(0xf,0x1f,0x19))):
        yield f'      {name}={{\n' + rows(tuple(art(pointer(program,start+4*i),size,bank,palette)
                                               for i in range(count)) for bank in bases) + '      },\n'
    yield '    },\n  },\n'


def mid3_data(program, art, colors):
    yield '  mid3={\n'
    indices = (*range(1, 15), *range(17, 22), *range(25, 30))
    offsets = (0xD5C02200,0xE4001980,0x203FED00,0x2D3FE500,0xC4003240,0xCB002DC0,0xF0800BC0,
               0xF4C01840,0x09400700,0x10800380,0x377FDA80,0x3A3FE280,0x3DFFD6C0,0x40BFDEC0,
               0xBF002F80,0xBF002F80,0xBF002F80,0x397FDA80,0x2CFFE200,0xFE800E00,0x1D7FFF80,
               0x06000000,0x06000000,0x06000000)
    yield '    parts={\n' + rows((i, d, *struct.unpack_from('>4h', program, 0x132EA2 + i * 32 + 12))
                                      for i, d in zip(indices, offsets)) + '    },\n'
    yield '    gunHp={' + ','.join(str(pointer(program, 0x132EA2 + part * 32 + 4 + i * 4) >> 16)
                                    for part in (15, 16) for i in range(7)) + '},\n'
    yield '    muzzleBig={\n' + rows(struct.unpack_from('>3I', program, 0x138042 + i * 12)
                                          for i in range(32)) + '    },\n'
    for name, base, count in (('muzzleSmall', 0x138406, 32), ('muzzleRing', 0xD765A, 64),
                              ('deathCycle', 0x134F4E, 4), ('deathCenters', 0x134F5E, 7)):
        yield f'    {name}={{' + ','.join(str(pointer(program, base + i * 4)) for i in range(count)) + '},\n'
    yield '    coreFire={\n' + rows(struct.unpack_from('>hI', program, 0x138A1E + i * 6)
                                         for i in range(8)) + '    },\n'

    def effects_at(base, count):
        for i in range(count):
            kind, attr, h, l, _, velocity, _, _, delay = struct.unpack_from('>HHhh5H', program, base + i * 18)
            yield (delay, kind, attr, h, l, velocity >> 8, velocity & 255)

    yield '    blasts={\n'
    for name, base, end in (('largeGun',0x136E6C,0x136EFC), ('smallGun',0x1371EC,0x1371FE),
                            ('side1',0x137A50,0x137AE0), ('side2',0x137C5C,0x137CEC),
                            ('deck1',0x1376D8,0x137732), ('deck2',0x13784C,0x1378A6),
                            ('hull',0x134F7A,0x13501C), ('final',0x135152,0x135302)):
        yield f'      {name}={{\n' + rows(effects_at(base, (end - base) // 18), '        ') + '      },\n'
    yield '    },\n'
    yield '    deathPoints={\n' + rows(struct.unpack_from('>HHhh', program, 0x134ECC + i * 8)
                                            for i in range(16)) + '    },\n'

    palette = colors.copy()
    for bank, address in ((0x16, 0x634A0), (0x17, 0xB2346)):
        palette[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, address))

    sections = (
        ('ends', ((0x1A5F90,0xC28,0x31FFD700,0xF400FB00), (0x1A6084,0x1620,0x27FFE000,0xEA00FC00),
                  (0x1A61E8,0x1C18,0x1DFFE700,0xE400FD00), (0x1A7134,0x1828,0xC8002B00,0xE800FB00),
                  (0x1A7318,0x1420,0xBC003400,0xEC00FC00), (0x1A745C,0xE20,0xB4003C00,0xF200FC00))),
        ('center', ((0x1A7540,0x1C28,0x147FEF00,0xE400FB00), (0x1A7774,0x1C18,0x0BFFF700,0xE400FD00),
                     (0x1A78C8,0x2030,0,0xE000FA00), (0x1A7BCC,0x2430,0xF5000C00,0xDC00FA00),
                     (0x1A7F30,0x2228,0xE9001700,0xDE00FB00), (0x1A81DC,0x1A28,0xD6002100,0xE600FB00))),
        ('wreck', ((0x1A9E98,0x2030,0,0xE000FA00), (0x1AA19C,0x2430,0xF5000C00,0xDC00FA00))),
        ('side1', ((0x1AA500,0xA20,0xCA002200,0xF600FC00), (0x1AA5A4,0x1028,0xC7002B00,0xF000FB00),
                   (0x1AA6E8,0x1220,0xBE003400,0xEE00FC00), (0x1AA80C,0xE30,0xB4003E00,0xF200FA00))),
        ('side2', ((0x1AA960,0xE28,0x33FFD700,0xF200FB00), (0x1AAA7C,0x1420,0x2DFFE000,0xEC00FC00),
                   (0x1AABC0,0x1018,0x2BFFE700,0xF000FD00), (0x1AAC84,0xA28,0x2BFFEF00,0xF600FB00))),
        ('deck1', ((0x1AAD50,0xE60,0xFE000C00,0xF200F400),)),
        ('deck2', tuple((pointer(program, 0x133A3C + i * 4),0xE38,0x1FFFFF00,0xF200F900)
                        for i in range(16))),
        ('open', tuple((pointer(program, 0x133CEA + i * 8 + j * 4), *offset)
                       for i in range(1, 15) for j, offset in enumerate(
                           ((0xC30,0x06000000,0xF400FA00),(0x830,0x0A000C00,0xF800FA00))))),
    )
    yield '    art={\n'
    for name, pieces in sections:
        yield f'      {name}={{\n' + rows((((d + e) & 0xffffffff),
            *(art(address, size, bank, palette) for bank in (0x16, 0x1F, 0x19)))
            for address, size, d, e in pieces) + '      },\n'
    for name, base, size in (('largeGun',0x133D62,0xA50), ('smallGun',0x133F5A,0x620)):
        yield f'      {name}={{\n' + rows(tuple(art(pointer(program, base + i * 4), size, bank + (0x40 if i > 16 else 0), palette)
                                                     for bank in (0x16, 0x1F, 0x19))
                                                    for i in range(32)) + '      },\n'
    yield '    },\n  },\n'


def rail_data(program, art):
    yield '  rail={\n'
    yield '    state=' + lua_bytes(program[0xE4FA0:0xE4FCA]) + ',\n'
    yield '    part=' + lua_bytes(program[0xE4FCA:0xE4FEA]) + ',\n'
    yield '    muzzle={\n' + rows(struct.unpack_from('>hh', program, 0xE193C + 4 * i)
                                 for i in range(32)) + '    },\n'
    yield '    hatchMuzzle={\n' + rows(struct.unpack_from('>hh', program, 0xD765A + 4 * i)
                                      for i in range(64)) + '    },\n'
    yield '    breakup={\n'
    for address in (0xE54B6, 0xE5524):
        yield '      {\n' + rows((d, k, c, h, l, 0, 0)
                                 for d, k, c, h, l, _, _ in effect_commands(program, address)) + '      },\n'
    yield '    },\n'
    yield '    art={\n'
    for stage in (4, 5):
        stream = pointer(program, pointer(program, 0xCB8C6 + (stage - 1) * 4))
        banks = palette_banks(program, stream)
        base, toggle = struct.unpack_from('>BB', program, 0xE4F96 + (stage - 1) * 2)
        yield f'      [{stage}]={{\n'
        for bank in (base, base ^ toggle, 0x19):
            palette = np.zeros((0x400, 3), dtype='u1')
            palette[bank * 32:(bank + 1) * 32] = decode_palette(
                struct.unpack_from('>32H', program, banks[bank]))
            hulls = [art(pointer(program, 0xE5486 + 4 * i), 0xC50, bank, palette) for i in range(8)]
            guns = [art(pointer(program, 0xE1652 + 4 * i), 0x218, bank, palette) for i in range(32)]
            yield '        {hull={' + ','.join(map(str, hulls)) + '},gun={' + ','.join(map(str, guns)) + '}},\n'
        yield '      },\n'
    yield '    },\n  },\n'


def warning_data(program, art):
    yield '  warning={\n'
    frame, clock, delay, _, _, cycles, _, sound_clock, sound_delay, sounds = struct.unpack_from(
        '>hBBBBHHBBH', program, 0xE8768)
    yield '    settings={' + ','.join(map(str, (frame // 16, clock, delay, cycles,
                                                   sound_clock, sound_delay, sounds))) + '},\n'
    for stage in range(1, 6):
        bank = program[0xE875E + (stage - 1) * 2]
        palette = np.zeros((0x400, 3), dtype='u1')
        palette[bank * 32:(bank + 1) * 32] = decode_palette(
            struct.unpack_from('>32H', program, 0x64CA0))
        yield f'    [{stage}]={{\n'
        yield '      core={\n'
        for addr in range(0xE9334, 0xE94A4, 16):
            image, h, l, dh, dl, size = struct.unpack_from('>IhhhhI', program, addr)
            yield rows([(art(image, size, bank, palette), h + dh - 0x800, l + dl - 0x800)], '        ')
        yield '      },\n      parts={\n'
        for index in range(6):
            part = 0xE8776 + 32 * (index + 2)
            tile = pointer(program, 0xE929C + 4 * index)
            base, h, l = struct.unpack_from('>Ihh', program, tile)
            yield '        {\n'
            for i in range(17):
                image, dh, dl, size = struct.unpack_from('>IhhI', program, base + i * 16)
                yield rows([(art(image, size & 0x3fff, bank, palette) if size & 0x3fff else 0,
                             h + dh - 0x800, l + dl - 0x800)], '          ')
            yield '          clock=' + str(program[part + 0x13]) + ',\n        },\n'
        yield '      },\n    },\n'
    zoom = (pointer(program, 0xA786C + i * 4).bit_count() if i < 15 else 1 for i in range(1, 16))
    yield '    zoom={' + ','.join(map(str, zoom)) + '},\n  },\n'


def boss5_data(program, art):
    yield '  boss5={\n'
    yield '    hp={' + ','.join(map(str, struct.unpack_from('>II', program, 0x125658))) + '},\n'
    yield '    timeouts={' + ','.join(map(str, struct.unpack_from('>6H', program, 0x125660))) + '},\n'
    yield '    parts={\n' + rows(struct.unpack_from('>4h', program, 0x125678 + 32 * i)
                                 for i in range(12)) + '    },\n'
    for name, address, count in (('orbitTargets',0x126D0C,16), ('rotaryMuzzle',0x12BB2E,56),
                                ('bodyMuzzle',0x12BE68,18), ('approach',0x126982,16),
                                ('rotaryTravel',0x128A5C,256), ('sideMuzzle',0x12C39A,32),
                                ('linkSpeed',0x1294BE,24)):
        yield f'    {name}={{\n' + rows(struct.unpack_from('>hh', program, address + i * 4)
                                         for i in range(count)) + '    },\n'
    yield '    rotaryAngles=' + lua_bytes(program[0x12BAF6:0x12BB2E]) + ',\n'
    yield '    bodyAngles=' + lua_bytes(program[0x12BE56:0x12BE68]) + ',\n'
    yield '    spreadTurns=' + lua_bytes(program[0x12BE44:0x12BE56]) + ',\n'
    yield '    homingRound={' + ','.join(str(art(0x27AD84 + i * 0x24,0x410,0x1a)) for i in range(4)) + '},\n'
    yield '    turnArt={\n' + rows(directional_bullet_art(program, art, 0xF8F68)) + '    },\n'
    yield '    finalRings={\n'
    for entry in range(3):
        address = pointer(program, 0x12D1F8 + entry * 4)
        frame_rows = []
        while pointer(program, address+4) != 0xffffffff:
            rays, gap, speed, kind, offset = struct.unpack_from('>HhhHh', program, address)
            frame_rows.append((rays+1, gap, speed, kind, offset))
            address += 16
        yield '      {\n' + rows(frame_rows, '        ') + '      },\n'
    yield '    },\n'
    yield '    droneSpeed={\n' + rows(struct.unpack_from('>HH', program, 0x12DA3C + i * 4)
                                      for i in range(24)) + '    },\n'
    yield '    droneBoxes={' + ','.join(map(str, struct.unpack_from('>4h', program, 0x12DB0E))) + '},\n'
    yield '    droneHeight={' + ','.join(map(str, struct.unpack_from('>16H', program, 0x12DE5A))) + '},\n'
    yield '    droneZoom={' + ','.join(str(word(program, 0x12DE7A + 4 * i) >> 11)
                                      for i in range(33)) + '},\n'
    yield '    scoutSetup={' + ','.join(map(str, struct.unpack_from('>3H',program,0x12E814))) + '},\n'
    yield '    cannonTravel={\n'
    for address in (0x1287B2,0x1287F6,0x12883A,0x12887E):
        yield '      {\n' + rows((struct.unpack_from('>hh', program, address + i * 4)
                                   for i in range(17)), '        ') + '      },\n'
    yield '    },\n'
    yield '    explosions={\n'
    for address in (0x128036,0x1280AA,0x128112,0x1281F4,0x12734E,0x12764A,0x1276D0):
        yield '      {\n' + rows(effect_commands(program, address), '        ') + '      },\n'
    yield '    },\n'
    yield '    finalExplosionOffsets={\n' + rows(struct.unpack_from('>hh', program, 0x1276C4 + 4 * i)
                                                  for i in range(3)) + '    },\n'
    yield '    openingExplosionOffsets={\n' + rows(struct.unpack_from('>hh', program, 0x1273C8 + 4 * i)
                                                    for i in range(3)) + '    },\n'
    palette = np.zeros((0x400, 3), dtype='u1')
    stage5 = palette_banks(program, pointer(program, pointer(program, 0xCB8D6)))
    for bank, address in ((0x0f,0x630e0),(0x13,0x63120),(0x11,0x63160),(0x14,0x631a0),
                          (0x10,0x63220),(0x1f,stage5[0x1f]),(0x19,stage5[0x19])):
        palette[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, address))
    for name, address, count, size, bank in (
            ('wheels',0x125B50,30,0x1240,0x0f), ('landingWheels',0x125C98,64,0x1e70,0x13),
            ('landingHull',0x125C08,16,0x1858,0x13), ('sideGuns',0x125E02,32,0x0620,0x0f),
            ('rotaryGuns',0x125F54,32,0x0410,0x13), ('lastHull',0x126692,32,0x0830,0x10),
            ('armBase',0x126466,32,0x0a40,0x11), ('armLink',0x126566,32,0x0a40,0x11),
            ('armHead',0x1264E6,32,0x0830,0x11)):
        yield f'    {name}={{\n'
        for color in (bank, 0x1f, 0x19):
            yield '      {\n' + rows((tuple(art(pointer(program, address + i * 4), size, color | flip, palette)
                                             for flip in (0, 0x40))
                                      for i in range(count)), '        ') + '      },\n'
        yield '    },\n'
    yield '    droneArt={\n'
    for bank in (0x16,0x1f):
        if bank == 0x16:
            palette[bank * 32:(bank+1)*32] = decode_palette(struct.unpack_from('>32H', program, 0xB2346))
        yield '      {\n'
        for i in range(32):
            address = pointer(program,0x12DF22+i*4)
            flip = word(program,0x12DFA2+i*2) & 0x60
            yield rows((tuple(art(pointer(program,address+4*j),0xE50,bank|flip,palette)
                              for j in range(16)),), '        ')
        yield '      },\n'
    yield '    },\n'
    yield '    armPod={\n'
    for i in range(10):
        address, h, l, size = struct.unpack_from('>IhhI',program,0x12E63E+i*16)
        yield rows([(art(address,size,6),h,l)])
    yield '    },\n'
    yield '    center={\n'
    for color in (0x0f, 0x1f, 0x19):
        yield '      {\n'
        for index in range(32):
            image, h, l, size, dh, dl = struct.unpack_from('>IhhIhh', program, 0x126008 + 16 * index)
            yield rows([(art(image,size & 0x3fff,color,palette), art(image,size & 0x3fff,color|0x40,palette),
                         h + dh, l + dl, l - dl)], '        ')
        yield '      },\n'
    yield '    },\n  },\n'


def boss3_data(program, art):
    yield '  boss3={\n'
    hp = struct.unpack_from('>9I', program, 0x11977C)
    part_hp = dict(zip((3, 4, 5, 6, 8, 7, 10, 9), hp[1:]))
    yield '    parts={\n' + rows((part_hp.get(i, hp[0]),
                                      *struct.unpack_from('>4h', program, 0x1197A6 + i * 32 + 12))
                                     for i in range(15)) + '    },\n'
    yield '    timeouts={' + ','.join(map(str, struct.unpack_from('>3H', program, 0x1197A0))) + '},\n'
    yield '    target={\n' + rows(struct.unpack_from('>hh', program, 0xAFE5C + i * 4) for i in range(64)) + '    },\n'
    yield '    lift={\n' + rows(struct.unpack_from('>I', program, 0x11AA4A + i * 4) for i in range(16)) + '    },\n'
    yield '    live={\n'
    for kind, visual in ((0x18, 0xFA324), (0x1A, 0xF8846), (0x1B, 0xF8846), (0x1C, 0xF8846)):
        yield f'      [{kind}]={{\n' + rows(directional_bullet_art(program, art, visual), '        ') + '      },\n'
    yield '    },\n'
    for name, address, length in (('muzzle',0x11D48A,32), ('leftMuzzle',0x11D138,32),
                                   ('rightMuzzle',0x11D1B8,32), ('wingMuzzle',0x11E7DC,32),
                                   ('radialMuzzle',0xD775A,64), ('sweepMuzzle',0xD765A,64),
                                   ('deathPositions',0x11B16A,3)):
        yield f'    {name}={{\n' + rows(struct.unpack_from('>hh', program, address + i * 4)
                                         for i in range(length)) + '    },\n'
    for name, address in (('leftDirection',0x11D238), ('rightDirection',0x11D278)):
        yield f'    {name}=' + lua_bytes(program[address:address + 64]) + ',\n'
    yield '    breakup={\n'
    for address in (0x11C840,0x11C906,0x11C718,0x11C786,0x11CA46,0x11C9A0,0x11CB66,0x11CAD0):
        yield '      {\n' + rows(effect_commands(program, address), '        ') + '      },\n'
    yield '    },\n'
    for name, address in (('change',0x11C5DE), ('deathBurst',0x11B0F0), ('deathTrail',0x11B1CC)):
        yield f'    {name}={{\n' + rows(effect_commands(program, address)) + '    },\n'
    yield '    base={\n' + rows((art(a, size, palette), h, l) for a,size,palette,h,l in (
        (0xD9080,0xE40,0x10,-0xe00,-0x800),(0xDA164,0x1838,0x11,-0x19ff,-0x1200),
        (0xDA408,0x1838,0x12,-0x19ff,0x400),(0xDD8CC,0x870,0x0f,-0x200,-0xe00),
        (0xDDA90,0xC40,0x0f,-0xa00,-0x800))) + '    },\n'
    yield '    engines={\n'
    for address,size,palette,count in ((0x119B7A,0xc50,0x10,8),(0x119B9A,0x820,0x11,8),
             (0x119BBA,0x820,0x12,8),(0x11A102,0xc50,0x0f,8),(0x119FF2,0x20A0,0x0f,16),
             (0x11A032,0xC38,0x0f,16),(0x11A072,0xC38,0x0f,16)):
        yield '      {' + ','.join(str(art(pointer(program, address + 4*i), size, palette))
                                  for i in range(count)) + '},\n'
    yield '    },\n'
    yield '    guns={\n'
    for address,size,palette in ((0x119D70,0x618,0x10),(0x119E1E,0x618,0x10),
                                (0x119EFA,0x630,0x10),(0x11A518,0x820,0x12)):
        yield '      {' + ','.join(str(art(pointer(program, address + 4*i), size, palette))
                                  for i in range(32)) + '},\n'
    yield '    },\n'
    yield '    wings={\n'
    for address,size,palette in ((0x11A266,0x1048,0x12),(0x11A2A6,0xE48,0x12),(0x11A2E6,0xA38,0x12),
                                (0x11A3DE,0x1048,0x12),(0x11A41E,0xE48,0x12),(0x11A45E,0xA38,0x12)):
        yield '      {' + ','.join(str(art(pointer(program, address + 4*i), size, palette))
                                  for i in range(16)) + '},\n'
    yield '    },\n  },\n'


def boss4_data(program, art):
    yield '  boss4={\n'
    yield f'    hp={pointer(program, 0x11F92E)},\n'
    yield '    timeouts={' + ','.join(map(str, struct.unpack_from('>3H', program, 0x11F932))) + '},\n'
    yield '    parts={\n' + rows(struct.unpack_from('>4h', program, 0x11F944 + i * 32)
                                 for i in range(3)) + '    },\n'
    for name, address, count in (('aimMuzzle',0x1222F2,32), ('ringMuzzle',0xD765A,64),
                                 ('outerMuzzle',0x122B14,17), ('deathOffsets',0x120B76,3),
                                 ('orbitSpeed',0x125168,24)):
        yield f'    {name}={{\n' + rows(struct.unpack_from('>hh', program, address + i * 4)
                                         for i in range(count)) + '    },\n'
    for name, address in (('death',0x120AFC), ('deathTrail',0x120BD8)):
        yield f'    {name}={{\n' + rows(effect_commands(program, address)) + '    },\n'
    yield '    randomByte=' + lua_bytes(program[0xAF388:0xAF488]) + ',\n'
    yield '    turn={' + ','.join(map(str, struct.unpack_from('>256b', program, 0xAF5FC))) + '},\n'
    yield '    sweepAngles={' + lua_bytes(program[0x122A94:0x122AD4]) + ',\n' \
        + lua_bytes(program[0x122AD4:0x122B14]) + '},\n'
    yield '    needle={\n' + rows(directional_bullet_art(program, art, 0xFA190)) + '    },\n'
    yield '    orbitNeedle={\n' + rows(directional_bullet_art(program, art, 0xFAED4)) + '    },\n'
    yield '    trail={' + ','.join(str(art(0x27CC10 + i * 0x14,0x210,0x1a)) for i in range(6)) + '},\n'
    yield '    orbitSeed={' + ','.join(str(art(0x27CC88 + i * 0x14,0x210,0x1a)) for i in range(6)) + '},\n'
    yield '    carrier={\n' + rows((art(a,s,p), art(a,s,p|0x40))
                                      for a,s,p in ((0x11162C,0x1430,0xf),(0x111810,0x1A30,0xf))) + '    },\n'
    for name, address, count, size, palette, flip in (
            ('hull',0x109264,1,0x640,0x10,False), ('deck',0x109328,1,0x1828,0x10,True),
            ('cover',0x10A318,1,0x820,0x10,True), ('rearEngine',0x11FB28,4,0x1020,0x10,True),
            ('sideEngine',0x11FBE0,4,0xA18,0x10,True), ('nozzle',0x11FC5A,16,0x828,0x10,True),
            ('engineCore',0x10B114,1,0xA30,0x10,False), ('engineSide',0x10B208,1,0xA18,0x10,True),
            ('engineFlash',0x11FD3C,8,0x610,0x10,False), ('wing',0x10B424,1,0x1430,0x11,True),
            ('leftWing',0x11FE28,8,0x1410,0x11,False), ('rightWing',0x11FDB0,8,0x1410,0x11,False),
            ('wingOpen',0x11FE76,16,0x1268,0x11,True), ('turret',0x11FF1C,32,0x620,0x11,False),
            ('eye',0x120006,32,0x410,0x11,False), ('thruster',0x123836,8,0xE28,0x0f,True),
            ('orbit',0x1254D6,8,0x410,0x1a,False), ('tether',0x123F5C,8,0x1048,0x15,False),
            ('tetherLink',0x112CA4,1,0x820,0x15,True)):
        frames = [pointer(program, address + i * 4) if count > 1 else address for i in range(count)]
        yield f'    {name}={{\n' + rows((art(a, size, palette), art(a, size, palette | 0x40) if flip else 0)
                                        for a in frames) + '    },\n'
    yield '  },\n'


def effect_art(program, kind, art):
    table = 0x61990 if kind & 0x80 else 0x61920
    cursor, ticks = struct.unpack_from('>II', program, table + (kind & 0x7f) * 8)
    size, h, l, dh, dl = 0, 0, 0, 0, 0
    while word(program, ticks) != 0xffff:
        while word(program, cursor) >= 0xfffe:
            op, value, a, b = struct.unpack_from('>HHhh', program, cursor)
            if op == 0xffff:
                size, h, l = value, a, b
            else:
                dh, dl = a, b
            cursor += 8
        address = pointer(program, cursor)
        yield (word(program, ticks), h, l, dh, dl,
               art(address, size, 0x1e), art(address, size, 0x5e))
        dh, dl = 0, 0
        cursor += 4
        ticks += 2


def directional_bullet_art(program, art, visual):
    for direction in range(32):
        table = 0xF7944 + direction * 8
        address = pointer(program, visual + word(program, table))
        yield tuple(art(pointer(program, address + j * 4), 0x410, 0x1A | program[table + 2])
                    for j in range(3))


def player_data(program, art):
    # 0xb5c72 与 0xbb444 各选自己的武装表。四个子机发射器占不同的自机弹槽。
    def shot(address, bank, index, lock=None):
        flags, h, l, dh, dl = struct.unpack_from('>Hhhhh', program, address)
        if flags & 0x20 and flags & 0x1000:
            offsets = [struct.unpack_from('>hh', program, pointer(program, address + 2) + 4 * i)
                       for i in range(32)]
            h, l = 0, 0
        else:
            offsets = []
        size, front, back, damage, width, _, vector = struct.unpack_from('>7H', program, address + 14)
        flash = pointer(program, address + 10)
        fly = pointer(program, address + 30)
        flash_count = 3 if flags == 0x8000 else 4
        fly_count = 6 if lock else 1
        fly_size = (0x410, 0x410, 0x618, 0x618, 0x620)[index] if lock else 0x210
        if flags & 0x20 and flags & 0x1000:
            fly_count, fly_size = 3, size
        elif flags & 0x20:
            fly_size = 0x210 if bank == 2 else 0x418
        frames = tuple(art(pointer(program, flash + i * 4), size, bank) for i in range(flash_count))
        motion = tuple(art(pointer(program, fly + i * 4), fly_size, bank) for i in range(fly_count))
        return (flags, h, l, dh, dl, front, back, damage, width, vector >> 8, vector & 255,
                frames, motion, offsets, *(lock or (0, 0)))

    def lua_shot(values):
        *params, frames, motion, offsets, charge, threshold = values
        offsets = '{' + ','.join('{' + ','.join(map(str, offset)) + '}' for offset in offsets) + '}'
        return '{' + ','.join(map(str, params)) + ',{' + ','.join(map(str, frames)) + '},{' \
            + ','.join(map(str, motion)) + '},' + offsets + f',{charge},{threshold}}}'

    yield '  player={\n'
    death = []
    h = l = size = 0
    for i in range(32):
        cursor = pointer(program,0xBCC3E+4*i)
        sprite = pointer(program,cursor)
        if sprite == 0:
            h,l,size = struct.unpack_from('>hhH',program,cursor+4)
            sprite = pointer(program,cursor+10)
        death.append((art(sprite,size,6),h,l))
    yield '    death={\n' + rows(death,'      ') + '    },\n'
    for ship in range(2):
        settings = pointer(program, 0xBC64E + ship * 4)
        profile = program[settings + 10:settings + 14]
        yield '    {profile={' + ','.join(map(str, profile)) + '},\n'
        yield '     hullOffsetH=' + str(signed(word(program, settings))) + ',\n'
        yield '     shotLimit={' + ','.join(str(word(program, pointer(program, 0xBC672 + ship * 8) + i * 2))
                                          for i in range(5)) + '},\n'
        yield '     optionShotLimit={' + ','.join(str(word(program, pointer(program, 0xBC676 + ship * 8) + i * 2))
                                                for i in range(5)) + '},\n'
        yield '     normal={\n'
        for index in range(5):
            address = pointer(program, pointer(program, 0xBC8DE + 4 * ship) + index * 4)
            yield '      ' + lua_shot(shot(address, 2 if ship == 0 else 6, index)) + ',\n'
        yield '     }, lock={\n'
        for index in range(5):
            address = pointer(program, pointer(program, 0xBC8E6 + 4 * ship) + index * 4)
            yield '      ' + lua_shot(shot(address, 2 if ship == 0 else 6, index,
                                           struct.unpack_from('>HH', program, address + 38))) + ',\n'
        yield '     },\n     optionParams=' + lua_bytes(program[pointer(program, 0xBCDCC + ship * 4):][:32]) + ',\n'
        fly_base = (0xB680C, 0xB6A08)[ship]
        lock_base = (0xB6CEC, 0xB702A)[ship]
        option_base = (0xB7492, 0xB78C8)[ship]
        yield '     fly={\n'
        for mode, table in (('normal', fly_base), ('lock', lock_base), ('option', option_base)):
            yield f'      {mode}={{\n'
            for i in range(5):
                address = pointer(program, table + i * 4)
                h, l, size, travel = struct.unpack_from('>hhHh', program, address)
                yield f'       {{{h},{l},{size},{travel}}},\n'
            yield '      },\n'
        yield '     }, hit={\n'
        for mode, table in (('normal', (0xB6848, 0xB6A44)[ship]),
                            ('lock', (0xB6D28, 0xB7066)[ship]),
                            ('lockFree', (0xB6D82, 0xB70C0)[ship]),
                            ('option', (0xB74FA, 0xB7930)[ship])):
            yield f'      {mode}={{\n'
            for i in range(5):
                address = pointer(program, table + i * 4)
                h, l, size, frames, _, last = struct.unpack_from('>hhHIHH', program, address)
                assert last % 4 == 0 and 0 < last <= 0x3c
                ids = [art(pointer(program, frames + 4 * j), size, 2 if ship == 0 else 6)
                       for j in range(last // 4)]
                yield f'       {{{h},{l},{{' + ','.join(map(str, ids)) + '}},\n'
            yield '      },\n'
        yield '     },\n'
        for state, name in ((0, 'optionShot'), (1, 'optionLock')):
            yield f'     {name}={{\n'
            for index in range(5):
                address = pointer(program, pointer(program, 0xBD894 + ship * 4 + state * 8) + 4 * index)
                yield '      {\n'
                for slot in range(17 if state else 2 if index < 2 else 4):
                    entry = pointer(program, address + 4 * slot)
                    yield '       ' + lua_shot(shot(entry, 2 if ship == 0 else 6, index)) + ',\n'
                yield '      },\n'
            yield '     },\n'
        yield '    },\n'
    yield '    directions=' + lua_bytes(program[0xBC6C2:0xBC6D2]) + ',\n'
    yield '    aim=' + lua_bytes(program[0xADEE6:0xADF27]) + ',\n'
    yield '    jitter={' + ','.join(str(signed(word(program, 0xAF9B4 + i * 4))) for i in range(64)) + '},\n'
    yield '    shake={\n' + rows(struct.iter_unpack('>hh', program[0xCAB0C:0xCAB0C + 42 * 4])) + '    },\n'
    yield '    bomb={\n'
    for address in (0xBE93E, 0xBE9D8, 0xBEA52):
        ids = []
        while pointer(program, address) != 0xFFFFFFFF:
            h, l, sprite, size = struct.unpack_from('>hhIH', program, address)
            ids.append((h, l, art(sprite, size, 2)))
            address += 10
        yield '      {\n' + rows(ids) + '      },\n'
    for address, size, count in ((0xBE986, 0x620, 16), (0xBEA20, 0x1478, 8)):
        ids = [(art(pointer(program, address + i * 4), size, 2),) for i in range(count)]
        yield '      {\n' + rows(ids) + '      },\n'
    yield '    },\n'
    yield '  },\n'


def export(program, rom, target, resources):
    graphics = Graphics(rom)
    tile_atlas = Atlas('tiles', lambda key, colors: graphics.tile(key[:2], colors))
    target.mkdir(parents=True, exist_ok=True)
    resources.mkdir(parents=True, exist_ok=True)

    # 原程序在每一面开始时从 0xcb114 复制 32 组背景调色板。
    stage_defs = list(stages(program))
    with (target / 'rom_stages.lua').open('w', encoding='utf-8', newline='\n') as out:
        out.write('-- 由 tools/ketsui/export_native.py 从原程序的生成表与背景表导出。\nreturn {\n')
        for index, stage in enumerate(stage_defs):
            base = pointer(program, 0xCB128 + 4 * index)
            palette = pointer(program, 0xCB114 + 4 * index)
            colors = np.zeros((0x800, 3), dtype='u1')
            colors[0x400:] = decode_palette(struct.unpack_from('>1024H', program, palette))
            across, forward = struct.unpack_from('>HH', program, 0xCB13C + 4 * index)
            tile_base = pointer(program, 0xAC69C + 4 * index)
            tiles = []
            for i in range(across * forward):
                raw = (pointer(program, base + 4 * i) + tile_base) & 0xFFFFFFFF
                tiles.append(tile_atlas.get((raw >> 16, raw & 0xFE, index), colors))
            # 调色板是按关载入的，因此图集的键还包含关卡编号。
            scroll = pointer(program, 0xCB8C6 + 4 * index)
            major, minor = struct.unpack_from('>HH', program, 0xCB100 + 4 * index)
            entries = list(spawns(program, stage))
            path_end = stage_defs[index + 1].records if index < 4 else max(e.path for e in entries) + 64
            assert all(stage.path_base <= entry.path < path_end for entry in entries)
            out.write(f'  {{major={major},minor={minor},across={across},forward={forward},'
                      f'pathBase={stage.path_base},\n    tiles={{\n')
            for i in range(0, len(tiles), across):
                out.write('      ' + ','.join(map(str, tiles[i:i + across])) + ',\n')
            out.write('    },\n    scroll={\n')
            for axis in range(2):
                address = pointer(program, scroll + 4 * axis)
                out.write('      {\n')
                out.write(rows(scroll_stream(program, address), '        '))
                out.write('      },\n')
            out.write('    },\n    spawns={\n')
            out.write(rows((e.major, e.minor, e.enemy, e.flags, e.params, e.path,
                            e.offset_x, e.offset_y, e.init, e.update) for e in entries))
            out.write('    },\n    paths=' + lua_bytes(program[stage.path_base:path_end]) + '\n  },\n')
        out.write('}\n')

    with (target / 'rom_spawn_types.lua').open('w', encoding='utf-8', newline='\n') as out:
        out.write('-- 由 tools/ketsui/export_native.py 导出的敌机回调表。\nreturn {\n')
        for kind in range(256):
            init, update = struct.unpack_from('>II', program, ENEMY_HANDLERS[kind >> 7] + 8 * (kind & 0x7F))
            if init and update:
                out.write(f'  [{kind}]={{{init + 8},{update}}},\n')
        out.write('}\n')

    def vector(speed, angle):
        return pointer(program, pointer(program, 0xD20 + speed * 4) + angle * 4)

    descriptors = []
    for kind in range(0x4A):
        address, init, update = bullet_descriptor(program, kind)
        descriptors.append((kind, word(program, address), word(program, address + 14),
                            word(program, address + 16), init, update))

    vectors = bytearray().join(struct.pack('>I', vector(speed, angle))
                               for speed in range(256) for angle in range(256))
    # 0xad94a 的子机分量在恢复象限符号前按 1/8 截断。
    for speed in range(0xd1):
        for angle in range(256):
            address = pointer(program, 0x920 + 4 * speed) + word(program, 0xAD572 + 2 * angle)
            h, l = (value // 8 for value in struct.unpack_from('>ii', program, address))
            if angle & 0x80:
                l = -l
            if (angle + 0x40) & 0x80:
                h = -h
            vectors.extend(struct.pack('>hh', h, l))
    (target / 'rom_vectors.bin').write_bytes(vectors)
    palette_stream = pointer(program, pointer(program, 0xCB8C6))
    banks = palette_banks(program, palette_stream)
    colors = np.zeros((0x400, 3), dtype='u1')
    banks.update({0: 0x628A0, 2: 0x629A0, 4: 0x62A20, 6: 0x62AA0})
    for bank, address in banks.items():
        colors[bank * 32:(bank + 1) * 32] = decode_palette(
            struct.unpack_from('>32H', program, address))
    def sprite_image(key, palette):
        grow_x = key[-1] if len(key)>5 and isinstance(key[-1],int) else 0
        return graphics.sprite(key[:5], palette, grow_x=grow_x)

    sprites = Atlas('sprites', sprite_image)
    transport_sprites = Atlas('transport', lambda key, palette: graphics.sprite(key[:5], palette))

    def art(address, size, attr, palette=None, *, grow_x=0):
        bank = attr & 31
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, attr >> 5 & 3)
        if palette is not None:
            key += (palette[bank * 32:(bank + 1) * 32].tobytes(),)
        if grow_x:
            key += (grow_x,)
        return sprites.get(key, colors if palette is None else palette)

    small_art = [art(pointer(program, 0xD0AEC + 4 * index), 0x638, 10)
                 for index in range(32)]
    burst_art = [[art(pointer(program, 0xD21FA + 4 * i), 0x840, bank) for i in range(32)]
                 for bank in (11, 12, 18)]
    flash = []
    live = {}
    fade = []
    for palette_index, base in enumerate((0xF7BAE, 0xF7D2E)):
        flash.append([])
        for direction in range(32):
            x, y, address, attr, _ = struct.unpack_from('>hhIHH', program, base + 12 * direction)
            flash[-1].append((x, y, *(art(address + j * 0x34, 0x418, attr >> 8) for j in range(3))))
        fade_base = (0x27CA58, 0x27E608)[palette_index]
        fade.append([art(fade_base + 0x14 * frame, 0x210, 0x1A) for frame in range(1, 16)])
    for kind, visual in ((9, 0xF8DAC), (0x0B, 0xF926C), (0x0C, 0xF9400), (0x0E, 0xF8DAC),
                         (0x13, 0xF8F68), (0x19, 0xFA4B8), (0x25, 0xFA190), (0x36, 0xF8DAC), (0x0F, 0xF9400)):
        live[kind] = list(directional_bullet_art(program, art, visual))
    live[0xA] = [tuple(art(pointer(program,pointer(program,0xF8F68+4*i)+4*j),0x410,0x1a)
                            for j in range(3)) for i in range(32)]
    round_bullet = [art(0x27AD0C + frame * 0x14, 0x210, 0x1A) for frame in range(6)]
    boss_round = [art(0x27AC1C + frame * 0x14, 0x210, 0x1A) for frame in range(6)]
    boss_yellow = [art(0x27CD00 + frame * 0x24, 0x410, 0x1A) for frame in range(4)]

    ground = {}
    for kind, (group, part, length, body, turret, muzzle, body_size, turret_size, bank) in GROUND.items():
        ground[kind] = (
            program[group:group + length], program[part:part + 32],
            [art(pointer(program, body + i * 4), body_size, bank) for i in range(64)] if body else [],
            [art(pointer(program, turret + i * 4), turret_size, bank) for i in range(32)],
            [struct.unpack_from('>hh', program, muzzle + i * 4) for i in range(64 if kind == 0x95 else 32)],
        )

    for bank, address in ((0x13, 0x62B20), (0x14, 0x62B60), (0x15, 0x62BA0), (0x16, 0x62BE0)):
        colors[bank * 32:(bank + 1) * 32] = decode_palette(
            struct.unpack_from('>32H', program, address))
    # 精灵的偏移由 0x10cf6e 起的绘制回调提供，位置在 Boss 本体定点坐标上加算。
    boss1_art = [
        (art(0x587EC, 0x1E68, 0x13), -0x1E00, -0x0D00),
        (art(pointer(program, 0x10D0A8), 0x838, 0x14), -0x800, -0x700),
        (art(pointer(program, 0x10D136), 0x838, 0x14), -0x800, -0x700),
        (art(pointer(program, 0x10D19C), 0xC38, 0x15), -0xC00, -0x700),
        (art(pointer(program, 0x10D202), 0xC38, 0x15), -0xC00, -0x700),
        (art(pointer(program, 0x10CFB4), 0xC38, 0x16), -0xC00, -0x700),
        (art(pointer(program, 0x10D01A), 0xC38, 0x16), -0xC00, -0x700),
    ]
    boss1_child_art = [art(pointer(program, pointer(program, 0xF8F68 + 4 * i)), 0x0410, 0x1A)
                       for i in range(32)]
    with (target / 'rom_objects.lua').open('w', encoding='utf-8', newline='\n') as out:
        out.write('-- 由 tools/ketsui/export_native.py 从原程序的对象参数导出。\nreturn {\n')
        out.write('  aim=' + lua_bytes(program[0xADBC0:0xADC44]) + ',\n')
        out.write('  enemyRandom=' + lua_bytes(program[0xAF2EC:0xAF36C]) + ',\n')
        out.write('  heavyTurretWreck=' + str(art(0x1EDC1C, 0x830, 14)) + ',\n')
        out.write('  aimLimits={\n')
        for loop in range(2):
            hi, lo = 0xAE0E6 + loop * 0x28, 0xAE0FA + loop * 0x28
            out.write('    {\n' + rows((*struct.unpack_from('>Hh', program, hi + 4 * i),
                                         *struct.unpack_from('>Hh', program, lo + 4 * i))
                                        for i in range(5)) + '    },\n')
        out.write('  },\n  muzzle={\n')
        out.write(rows(struct.unpack_from('>hh', program, 0xD0BFC + 4 * i) for i in range(32)))
        out.write('  },\n  small={\n')
        for kind, address in SMALL_GROUPS.items():
            size = 38 if kind == 0x18 else 26
            out.write(f'    [{kind}]=' + lua_bytes(program[address:address + size]) + ',\n')
        out.write('  },\n  smallParts={\n')
        for kind, address in SMALL_PARTS.items():
            out.write(f'    [{kind}]=' + lua_bytes(program[address:address + 32]) + ',\n')
        out.write('  },\n  smallArt={' + ','.join(map(str, small_art)) + '},\n')
        out.write('  burstArt={\n' + rows(burst_art) + '  },\n')
        out.write('  burstMuzzle={\n' + rows(struct.unpack_from('>hh', program, 0xD23FA + 4 * i)
                                                for i in range(32)) + '  },\n')
        out.write('  rearShotArt={\n' + rows((art(pointer(program, 0xD2C74 + 12 * i + 4 * j), 0x840, 13)
                                             for j in range(3)) for i in range(32)) + '  },\n')
        out.write('  ground={\n')
        for kind, (group, part, body, turret, muzzle) in ground.items():
            out.write(f'    [{kind}]={{state={lua_bytes(group)},part={lua_bytes(part)},\n')
            out.write('      body={' + ','.join(map(str, body)) + '},\n')
            out.write('      turret={' + ','.join(map(str, turret)) + '},\n')
            out.write('      muzzle={\n' + rows(muzzle, '        ') + '      }},\n')
        out.write('    [0x96]={state=' + lua_bytes(program[0xEC7C6:0xEC7EE])
                  + ',part=' + lua_bytes(program[0xEC7EE:0xEC80E])
                  + ',second=' + lua_bytes(program[0xEC80E:0xEC82E]) + ',\n')
        out.write('      hull=' + str(art(0x20D89C, 0x0A40, 0x0B)) + ',\n')
        out.write('      body={' + ','.join(str(art(pointer(program, 0xECDB0 + 4*i), 0x0610, 0x0B))
                                               for i in range(8)) + '},\n')
        out.write('      turret={' + ','.join(str(art(pointer(program, 0xD785A + 4*i), 0x0303, 0x0B))
                                                 for i in range(32)) + '},\n')
        out.write('      muzzle={\n' + rows(struct.unpack_from('>hh', program, 0xD78DA + 4 * i)
                                           for i in range(32)) + '      },\n')
        out.write('      muzzleFan={\n' + rows(struct.unpack_from('>hh', program, 0xD765A + 4*i)
                                              for i in range(64)) + '      },\n')
        out.write('    },\n')
        for kind, group, part, body in ((0x4C,0xD4EDC,0xD4F00,0xD51C2),
                                        (0x4D,0xD54EA,0xD550E,0xD57F8)):
            out.write(f'    [{kind}]={{state={lua_bytes(program[group:group + 36])},'
                      f'part={lua_bytes(program[part:part + 32])},\n')
            out.write('      body={' + ','.join(str(art(pointer(program, body + 4 * i), 0x838, 13))
                                                  for i in range(64)) + '},\n')
            out.write('      turret={' + ','.join(str(art(pointer(program, 0xD52C2 + 4 * i), 0x428, 13))
                                                    for i in range(32)) + '},\n')
            out.write('      flame={' + ','.join(str(art(0x2E5D34 + 0x24 * i, 0x410, 0x1E))
                                                   for i in range(4)) + '},\n')
            for name, base in (('pivot',0xD53C2), ('muzzle',0xD5342)):
                out.write(f'      {name}={{\n' + rows(struct.unpack_from('>hh', program, base + 4 * i)
                                                     for i in range(32)) + '      },\n')
            out.write('    },\n')
        out.write('  },\n')
        out.write('  bullet={\n' + rows(descriptors) + '  },\n')
        out.write('  flash={\n')
        for frames in flash:
            out.write('    {\n' + rows(frames) + '    },\n')
        out.write('  },\n  live={\n')
        for kind, sprites_by_angle in live.items():
            out.write(f'    [{kind}]={{\n' + rows(sprites_by_angle, '      ') + '    },\n')
        out.write('  },\n')
        out.write('  roundBullet={' + ','.join(map(str, round_bullet)) + '},\n')
        out.write('  bossRound={' + ','.join(map(str, boss_round)) + '},\n')
        out.write('  bossRoundAlt={' + ','.join(str(art(0x27AC94 + i * 0x14, 0x210, 0x1A))
                                               for i in range(6)) + '},\n')
        out.write('  bossYellow={' + ','.join(map(str, boss_yellow)) + '},\n')
        out.write('  turretRound={' + ','.join(str(art(pointer(program, 0xF886A + i * 4), 0x410, 0x1A))
                                               for i in range(3)) + '},\n')
        out.write('  fade={\n' + rows(fade) + '  },\n')
        out.write('  boss1Parts={\n' + rows(boss1_parts(program)) + '  },\n')
        out.write('  boss1Art={\n' + rows(boss1_art) + '  },\n')
        out.write('  boss1ChildArt={' + ','.join(map(str, boss1_child_art)) + '},\n')
        out.write('  boss1ChildMuzzle={\n' + rows(struct.unpack_from('>Hh', program, 0x112496 + 4 * i)
                                                 for i in range(4)) + '  },\n')
        out.write('  boss1ChildWaves={\n' + rows(struct.unpack_from('>3H2B', program, 0x1124A6 + 8 * i)
                                                 for i in range(4)) + '  },\n')
        out.write('  boss1Muzzle={\n' + rows(struct.unpack_from('>hh', program, 0x11237C + 4 * i)
                                               for i in range(4)) + '  },\n')
        out.write('  boss1FanMuzzle={\n' + rows(struct.unpack_from('>hh', program, 0xD755A + 4 * i)
                                                  for i in range(64)) + '  },\n')
        out.write('  boss1RearMuzzle={\n' + rows(struct.unpack_from('>hh', program, 0x11210E + 4 * i)
                                                   for i in range(32)) + '  },\n')
        out.write('  boss1Formation={\n')
        out.write('    rotation={\n' + rows((signed(word(program, 0xAE67E + i * 4 + 2)),
                                               signed(word(program, 0xAEA7E + i * 4 + 2)))
                                              for i in range(256)) + '    },\n')
        out.write('    speed={\n' + rows(struct.unpack_from('>HH', program, 0x110760 + i * 4)
                                          for i in range(24)) + '    },\n')
        out.write('    spread={\n' + rows(struct.unpack_from('>BB', program, 0x110940 + i * 2)
                                           for i in range(8)) + '    },\n')
        out.write('    idle={\n' + rows(struct.unpack_from('>hh', program, 0x1109EE + i * 4)
                                         for i in range(8)) + '    },\n')
        out.write('    muzzle={\n' + rows(struct.unpack_from('>hh', program, 0x1107C2 + i * 4)
                                           for i in range(32)) + '    },\n')
        out.write('    driftDelay={' + ','.join(map(str, struct.unpack_from('>8H', program, 0x110FFA))) + '},\n')
        out.write('    driftTurn={' + ','.join(map(str, struct.unpack_from('>8b', program, 0x11100A))) + '},\n')
        out.write('    art={\n')
        for i in range(32):
            out.write(rows((tuple(art(pointer(program, 0x110360 + 32 * i + 4 * j), 0x830, 0x13)
                                  for j in range(8)),)))
        out.write('    },\n  },\n')
        out.write('  effectRandom=' + lua_bytes(program[0xAF056:0xAF156]) + ',\n  effects={\n')
        for kind in (2, 4, 5, 6, 7, 8, 9, 11, 0x82, 0x83, 0x84, 0x85, 0x87, 0x88, 0x89, 0x8b, 0x8c, 0x86, 0xa):
            out.write(f'    [{kind}]={{\n' + rows(effect_art(program, kind, art), '      ') + '    },\n')
        out.write('  },\n  boss1Explosions={\n')
        for address in (0x10F994, 0x10F9F2, 0x10FA76, 0x10FB12, 0x10FBAE, 0x10FC3E,
                        0x10E27E, 0x10E458, 0x10E534):
            out.write('    {\n' + rows(effect_commands(program, address), '      ') + '    },\n')
        out.write('  },\n')
        out.write('  spawnJitter={' + ','.join(str(signed(word(program, 0xAF890 + 2 * i)))
                                               for i in range(128)) + '},\n')
        out.write('  randomParity=' + lua_bytes(program[0xAF388:0xAF488]) + ',\n')
        out.write('  randomSign=' + lua_bytes(program[0xAF4DE:0xAF5DE]) + ',\n')
        for bank, address in ((0x13, 0x63460), (0x14, 0x63420), (0x15, 0x633E0), (0x16, 0x63420)):
            colors[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, address))
        out.write('  mid2={\n')
        out.write('    hp={' + ','.join(map(str, struct.unpack_from('>II', program, 0x130F38))) + '},\n')
        out.write('    boxes={\n' + rows(struct.unpack_from('>4h', program, 0x130F56 + 32 * i)
                                        for i in range(2)) + '    },\n')
        out.write('    body={\n' + rows((art(pointer(program, base + 4 * i), size, bank) for i in range(-8, 9))
            for base, size, bank in ((0x1310C8,0x1088,0x13),(0x1312D2,0x1288,0x15),
                                     (0x13110C,0xC78,0x14),(0x131150,0xC78,0x14))) + '    },\n')
        out.write('    gun={\n' + rows((art(pointer(program, base + 4 * i), size, bank) for i in range(32))
            for base, size, bank in ((0x1311AA,0xC60,0x13),(0x1313AC,0x420,0x15))) + '    },\n')
        out.write('    muzzle={\n' + rows(struct.unpack_from('>hh', program, 0x1327E2 + 4 * i)
                                           for i in range(32)) + '    },\n')
        out.write('    rearMuzzle={\n' + rows(struct.unpack_from('>hh', program, 0xD74DA + 4 * i)
                                               for i in range(32)) + '    },\n')
        out.write('    sideMuzzle={\n')
        for base in (0x132A52, 0x132A96):
            out.write('    {\n' + rows(struct.unpack_from('>hh', program, base + 4 * i)
                                       for i in range(-8, 9)) + '    },\n')
        out.write('    },\n')
        out.write('    pods={' + ','.join(str(art(pointer(program, 0x13249E + 4 * i), 0x618, 0x13))
                                           for i in range(8)) + '},\n')
        out.write('    explosions={\n' + rows(effect_commands(program, 0x131B54), '      ') + '    },\n')
        out.write('    exitPaths={' + lua_bytes(program[0x131EA8:0x131EB0]) + ', '
                  + lua_bytes(program[0x131EB0:0x131EB4]) + '},\n')
        out.write('  },\n')
        for bank, address in ((0x13, 0x634E0), (0x0A, 0x63520), (0x0F, 0x63560)):
            colors[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, address))
        out.write('  mid4={\n')
        out.write(f'    hp={pointer(program, 0x138BF8)},\n')
        out.write('    boxes={\n' + rows(struct.unpack_from('>4h', program, 0x138C08 + 32 * i)
                                        for i in range(2)) + '    },\n')
        out.write('    hull=' + str(art(0x1AEC24, 0x0A48, 0x13)) + ',\n')
        out.write('    cover={' + ','.join(str(art(pointer(program, 0x138D6C + 4 * i), 0x0A50, 0x0A))
                                            for i in range(16)) + '},\n')
        out.write('    turret={' + ','.join(str(art(pointer(program, 0x138DDA + 4 * i), 0x0838, 0x13))
                                             for i in range(32)) + '},\n')
        out.write('    wing={\n' + rows((art(pointer(program, 0x138F18 + 4 * i), 0x1460, bank)
                                          for i in range(17)) for bank in (0x0F, 0x4F)) + '    },\n')
        out.write('    jets={' + ','.join(str(art(pointer(program, 0x138F60 + 4 * i), 0x0828, 0x0F))
                                           for i in range(4)) + '},\n')
        out.write('    jetsOffset={\n' + rows(struct.unpack_from('>8h', program, 0x138F70 + 16 * i)
                                              for i in range(17)) + '    },\n')
        out.write('    muzzle={\n')
        for address, count in ((0x13A6C8, 32), (0x13A748, 32), (0xD765A, 64),
                               (0xD775A, 64), (0xD755A, 64)):
            out.write('      {\n' + rows(struct.unpack_from('>hh', program, address + 4 * i)
                                          for i in range(count)) + '      },\n')
        out.write('    },\n')
        out.write('    destination={\n' + rows(struct.unpack_from('>hh', program, 0xAFE5C + 4 * i)
                                               for i in range(64)) + '    },\n')
        out.write('    breakup={\n' + rows(struct.unpack_from('>HHhh', program, 0x139818 + 8 * i)
                                           for i in range(16)) + '    },\n')
        out.write('    coverBreak={\n' + rows(struct.unpack_from('>HHHhh', program, 0x13A090 + 10 * i)
                                              for i in range(16)) + '    },\n')
        out.write('    finalBreak={\n' + rows(struct.unpack_from('>H H h h H B B H H H', program,
                                                                  0x1399E4 + 18 * i)
                                              for i in range(23)) + '    },\n')
        out.write('    pods={' + ','.join(str(art(pointer(program, 0x13AF50 + 4 * i), 0x0418, bank))
                                           for bank in (0x13, 0x53) for i in range(7)) + '},\n')
        out.write('  },\n')
        out.write('  mid4Round={\n')
        for kind, start, stride, size, count in ((6, 0x27CC10, 0x14, 0x0210, 6),
                                                 (7, 0x27CC88, 0x14, 0x0210, 6),
                                                 (0x28, 0x27AD84, 0x24, 0x0410, 4),
                                                 (0x14, 0x27CD00, 0x24, 0x0410, 4)):
            out.write(f'    [{kind}]={{' + ','.join(str(art(start + stride * i, size, 0x1A))
                                                    for i in range(count)) + '},\n')
        out.write('  },\n')
        out.write('  mid4Needle={\n')
        for direction in range(32):
            table = word(program, 0xF7944 + direction * 8)
            address = pointer(program, 0xF9FF2 + table)
            out.write(rows((tuple(art(pointer(program, address + i * 4), 0x0410, 0x1A)
                                  for i in (0, 2)),)))
        out.write('  },\n')
        colors[0x0B * 32:0x0C * 32] = decode_palette(struct.unpack_from('>32H', program, 0x635E0))
        out.write('  mid5={\n')
        hp = struct.unpack_from('>5I', program, 0x13B010)
        out.write(f'    hp={{{hp[0]},0,{hp[3]},{hp[4]},{hp[1]},{hp[2]}}},\n')
        out.write('    boxes={\n' + rows(struct.unpack_from('>4h', program, 0x13B034 + 32 * i)
                                        for i in range(6)) + '    },\n')
        out.write('    hull={' + ','.join(str(art(addr, size, 0x0B)) for addr, size in
            ((0x1B7134,0xA50),(0x1B6B14,0xE50),(0x1B6D48,0x828),(0x1B6DEC,0x830),
             (0x1B6EB0,0x1050),(0x1B72C8,0xC20),(0x1B738C,0xC20),(0x1B7450,0xA50))) + '},\n')
        for name, base, size, count in (('engineLeft',0x13C8CC,0x1030,8),('engineRight',0x13C8EC,0x1038,8),
                ('extension',0x13C9DA,0x828,4),('cover',0x13CA2C,0xC40,8),
                ('gunLeft',0x13CAA6,0x628,8),('gunRight',0x13CAC6,0x628,8),('turret',0x13CBFC,0x420,32)):
            out.write(f'    {name}={{' + ','.join(str(art(pointer(program, base + 4 * i), size, 0x0B))
                                                  for i in range(count)) + '},\n')
        for name, base, count in (('turretFlip',0x13CB7C,32),('turretOffset',0x13CBBC,32)):
            out.write(f'    {name}={{' + ','.join(map(str, struct.unpack_from(f'>{count}h', program, base))) + '},\n')
        for name, base, count in (('turretMuzzle',0x13DE5E,32),('ringMuzzle',0xD765A,64),
                                  ('coverMuzzle',0xD775A,64),('extensionMuzzle',0x13E0A2,8)):
            out.write(f'    {name}={{\n' + rows(struct.unpack_from('>hh', program, base + 4 * i)
                                               for i in range(count)) + '    },\n')
        out.write('    partBreak={\n')
        for base in (0x13D276,0x13D2FE,0x13D196,0x13D206):
            out.write('      {\n' + rows(effect_commands(program, base), '        ') + '      },\n')
        out.write('    },\n')
        out.write('    coverBreak={\n' + rows(effect_commands(program, 0x13D37A), '      ') + '    },\n')
        out.write('    breakup={\n' + rows(struct.unpack_from('>HHhh', program, 0x13B8BE + 8 * i)
                                           for i in range(16)) + '    },\n')
        out.write('    finalBreak={\n' + rows(struct.unpack_from('>H H h h H B B H H H', program,
                                                                0x13BA56 + 18 * i)
                                              for i in range(24)) + '    },\n')
        out.write('    exitPath=' + lua_bytes(program[0x13BFD0:0x13BFDA]) + ',\n  },\n')
        # 0xddde6 按朝向及受击状态选图，调色板由各面的卷轴指令载入。
        patrol_exhaust = []
        out.write('  patrol43={\n')
        out.write('    state=' + lua_bytes(program[0xDD984:0xDD9AA]) + ',\n')
        out.write('    part=' + lua_bytes(program[0xDD9AA:0xDD9CA]) + ',\n')
        out.write('    stages={\n')
        previous_colors = colors
        for stage in (2, 5):
            palette = pointer(program, pointer(program, 0xCB8C6 + (stage - 1) * 4))
            main, altern = program[0xDD97A + (stage - 1) * 2:0xDD97C + (stage - 1) * 2]
            banks = palette_banks(program, palette)
            colors = previous_colors.copy()
            for bank in (main, main ^ altern, 0x19):
                addr = banks[bank]
                colors[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, addr))
            exhaust = (art(pointer(program, 0xDE062 + i * 4), 0x838, main) for i in range(4))
            patrol_exhaust.append(f'      [{stage}]={{' + ','.join(map(str, exhaust)) + '},\n')
            out.write(f'      [{stage}]={{\n')
            for i in range(32):
                address, h, l, size = struct.unpack_from('>IhhI', program, 0xDDE62 + i * 16)
                out.write(rows([(art(address, size, main), art(address, size, main ^ altern),
                                 art(address, size, 0x19), h, l)], '        '))
            out.write('      },\n')
        colors = previous_colors
        out.write('    },\n')
        out.write('    exhaust={\n' + ''.join(patrol_exhaust) + '    },\n')
        out.write('    boxes={\n' + rows(struct.unpack_from('>4H', program, 0xDE0F2 + 8 * i)
                                         for i in range(32)) + '    },\n')
        out.write('    muzzles={\n' + rows((*struct.unpack_from('>hh', program, 0xDE1F2 + 4 * i),
                                            *struct.unpack_from('>hh', program, 0xDE272 + 4 * i))
                                          for i in range(32)) + '    },\n')
        zoom = (0, *(pointer(program, 0xA786C + i * 4) for i in range(1, 15)), 1)
        out.write('    zoom={' + ','.join(map(str, zoom)) + '},\n')
        out.write('    breakup={\n' + rows(effect_commands(program, 0xDE072)) + '    },\n')
        out.write('    crash={\n')
        for i in range(3):
            kind, delay, h, l, _, v, _, _, angle = struct.unpack_from('>HHhhHHHHH', program, 0xDE098 + i * 18)
            out.write(rows([(delay, kind, 0, h, l, v, angle)], '      '))
        out.write('    },\n')
        out.write('    debris={\n' + rows(struct.unpack_from('>hh', program, 0xAFC18 + 4 * i)
                                           for i in range(64)) + '    },\n')
        out.write('  },\n')
        # 0x112962 的四组对象回调共用这组部件、炮口和难度表。
        colors = colors.copy()
        for bank in range(0x13, 0x17):
            address = 0x62C20 + (bank - 0x13) * 0x40
            colors[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, address))
        out.write('  boss2={\n')
        hp = (*struct.unpack_from('>6I', program, 0x112A9A), 0x7fff)
        out.write('    parts={\n' + rows((value, *struct.unpack_from('>4h', program, 0x112AB6 + i * 32 + 12))
                    for i, value in zip((0, 1, 2, 3, 4, 5, 11), hp)) + '    },\n')
        out.write('    movementRandom=' + lua_bytes(program[0xAF1CE:0xAF2CE]) + ',\n')
        for name, address, size in (('outerFire',0x1165BE,18), ('coverFire',0x11678E,22),
                                    ('edgeFire',0x116C08,30), ('edgePause',0x1171F0,6), ('sweepFire',0x117276,26),
                                    ('innerFire',0x1175FC,30), ('coreFire',0x11813A,22),
                                    ('tailFire',0x118536,18), ('carrierFire',0x118768,30)):
            out.write(f'    {name}={{\n')
            for i in range(4):
                start = pointer(program, address + 4 * i)
                out.write('      ' + lua_bytes(program[start:start + size]) + ',\n')
            out.write('    },\n')
        for name, address, count in (('outerMuzzle',0x1166F8,32), ('coverMuzzle',0x116B66,33),
                                     ('sweepMuzzle',0xD765A,64), ('forwardMuzzle',0x1186CA,32),
                                     ('innerMuzzle',0x1180A4,32), ('coreMuzzle',0x1184A4,32),
                                     ('leftCarrier',0x118BE2,17), ('rightCarrier',0x118C26,17)):
            out.write(f'    {name}={{\n' + rows(struct.unpack_from('>hh', program, address + 4 * i)
                                               for i in range(count)) + '    },\n')
        out.write('    deployment={' + ','.join(map(str, struct.unpack_from('>22h', program, 0x115764))) + '},\n')
        for name, address, size, attr, count in (('podBody',0x118FAE,0x820,0x13,8),
                                                  ('carrierBody',0x11946C,0x620,0x14,32),
                                                  ('carrierFlight',0x1194EC,0x620,0x14,32)):
            out.write(f'    {name}={{' + ','.join(str(art(pointer(program, address + 4*i), size, attr))
                                                 for i in range(count)) + '},\n')
        out.write('    breakup={\n' + rows(struct.unpack_from('>HHhh', program, 0x1148D6 + 8 * i)
                                          for i in range(16)) + '    },\n')
        out.write('    phaseBurst={' + ','.join(map(str, struct.unpack_from('>8H', program, 0x114B56))) + '},\n')
        out.write('    phaseOffset={' + ','.join(str(signed(word(program, 0xB00A2 + i * 4))) for i in range(64)) + '},\n')
        out.write('    partBurst={\n')
        for address, count in ((0x115AB4,6),(0x115C5C,6),(0x115E04,6),(0x115FAC,6),(0x11615A,6),(0x116308,6)):
            out.write('      {\n' + rows(struct.unpack_from('>HHhhHBBHHH', program, address + 18 * i)
                                          for i in range(count)) + '      },\n')
        out.write('    },\n')
        out.write('    hull={\n' + rows((art(addr,size,bank), h,l) for addr,size,bank,h,l in (
            (0xC6DC0,0x1238,0x13,-0x1140,-0x13c0), (0xC93FC,0x1450,0x13,-0x1540,0x900),
            (0xC25FC,0xE40,0x14,-0x681,-0x800))) + '    },\n')
        out.write('    nacelle={\n')
        for base, offsetH, offsetL, bank in ((0x112E18,-0x1c80,-0x980,0x16),(0x112E18,-0x1c80,0xb80,0x16),
                                           (0x1130A0,0,0,0x13),(0x1131A0,0,0,0x13)):
            out.write('      {\n')
            for i in range(9):
                h, l, size, animation = struct.unpack_from('>hhII', program, base + i * 12)
                out.write('        {\n' + rows((art(pointer(program, animation + j * 4), size, bank),
                    signed((h + offsetH + (((l & 0xffff) + (offsetL & 0xffff)) >> 16)) & 0xffff),
                    signed((l + offsetL) & 0xffff))
                    for j in range(3)) + '        },\n')
            out.write('      },\n')
        out.write('    },\n')
        for name, address, size, bank, count in (('outer',0x112F52,0x620,0x16,32),
                ('innerLeft',0x1132C2,0x830,0x13,32), ('innerRight',0x113398,0x830,0x13,32),
                ('forward',0x113662,0x620,0x13,32), ('cover',0x113752,0xE40,0x14,33),
                ('tail',0x113ACE,0xC30,0x14,32)):
            out.write(f'    {name}={{' + ','.join(str(art(pointer(program, address + i*4), size, bank))
                                                     for i in range(count)) + '},\n')
        out.write(f'    tailWreck={art(0xBEA94,0xC30,0x14)},\n')
        for name,address,count,fmt,bank in (('hatchLeft',0x11343A,16,'IhhHxx',0x13),
                ('hatchRight',0x11351C,16,'IhhHxx',0x13), ('frontSlide',0x11384C,32,'hhIHxx',0x16),
                ('frontAim',0x1139CC,17,'hhIHxx',0x16)):
            frame_data = []
            for i in range(count):
                row = struct.unpack_from('>' + fmt, program, address + i * 12)
                addr,h,l,size = row if fmt.startswith('I') else (row[2],row[0],row[1],row[3])
                frame_data.append((art(addr,size,bank),h,l))
            out.write(f'    {name}={{\n' + rows(frame_data) + '    },\n')
        out.write('  },\n')
        colors = previous_colors
        out.writelines(player_data(program, art))
        out.write('  patrol2a={\n')
        out.write('    part=' + lua_bytes(program[0xD94E0:0xD9500]) + ',\n')
        out.write('    state=' + lua_bytes(program[0xD94D2:0xD94E0]) + ',\n')
        out.write('    stages={\n')
        for stage in range(5):
            banks = palette_banks(program, pointer(program, pointer(program, 0xCB8C6 + stage * 4)))
            for kind, bank_table in ((0x2a, 0xD94C8), (0x2b, 0xD98EC)):
                bank, toggle = program[bank_table + stage * 2:bank_table + stage * 2 + 2]
                out.write(f'      [{stage * 2 + kind - 0x29}]={{\n')
                for name, address, size, count in (('body',0xD9766,0x1048,8), ('turret',0xD9786,0x210,32),
                                                   ('marker',0x1F43AC,0x820,1)):
                    colors = previous_colors.copy()
                    variants = (0x18,) if name == 'marker' else (bank, bank ^ toggle, 0x19)
                    result = []
                    for attr in variants:
                        palette = banks[attr]
                        colors[attr * 32:(attr + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, palette))
                        ids = tuple(transport_sprites.get((start & 0x3fffff, size >> 9, size & 511, attr, 0, palette), colors)
                                    for start in (address if name == 'marker' else pointer(program, address + 4 * i)
                                                  for i in range(count)))
                        result.append(ids)
                    out.write(f'        {name}={{\n' + rows(result, '          ') + '        },\n')
                out.write('      },\n')
        out.write('    },\n')
        out.write('    muzzle={\n' + rows(struct.unpack_from('>hh', program, 0xD9820 + 4 * i)
                                              for i in range(32)) + '    },\n')
        out.write('    breakup={\n' + rows(effect_commands(program, 0xD9806)) + '    },\n')
        out.write('  },\n')
        colors = previous_colors
        # 三面替换外壳时会切换调色板，按 ROM 登记的后半场调色板导出该组精灵。
        colors = previous_colors.copy()
        for bank in range(0x0f, 0x14):
            address = 0x62E20 + (bank - 0x0f) * 0x40
            colors[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, address))
        out.writelines(boss3_data(program, art))
        colors = previous_colors.copy()
        for bank, address in ((0x0f,0x62FE0),(0x10,0x63020),(0x11,0x63060),(0x15,0x630A0)):
            colors[bank * 32:(bank + 1) * 32] = decode_palette(struct.unpack_from('>32H', program, address))
        out.writelines(boss4_data(program, art))
        out.writelines(rail_data(program, art))
        out.writelines(warning_data(program, art))
        out.writelines(boss5_data(program, art))
        out.writelines(hatch_patrol_data(program, art))
        out.writelines(fixed_cannon_data(program, art))
        out.writelines(heavy_tank_data(program, art))
        out.writelines(twin_aircraft_data(program, art))
        out.writelines(mid3_data(program, art, colors))
        out.writelines(triple_aircraft_data(program, art))
        out.writelines(patrol42_data(program, art))
        out.writelines(mid1_data(program, art))
        out.writelines(ground98_data(program, art))
        out.writelines(large_vehicle_data(program, art))
        out.writelines(ground59_data(program, art))
        out.writelines(hover_data(program, art))
        out.writelines(raid_data(program, art))
        out.writelines(early_vehicle_data(program, art))
        out.writelines(heavy_hatch_data(program, art))
        out.writelines(breakaway_tank_data(program, art))
        out.writelines(scenery_data(program, art))
        out.writelines(deck_carrier_data(program, art))
        out.writelines(platform_cannon_data(program, art))
        out.writelines(rising_turret_data(program, art))
        out.writelines(linked_cannon_data(program, art))
        out.writelines(item_data(program, art))
        out.writelines(chip_data(program, art))
        out.write('  transportSprites={\n' + rows(transport_sprites.rects) + '  },\n')
        out.write('  sprites={\n' + rows(sprites.rects) + '  },\n}\n')
    (target / 'rom_tiles.lua').write_text(
        '-- 由 tools/ketsui/export_native.py 导出的地图图块图集。\nreturn {\n'
        + rows(tile_atlas.rects) + '}\n', encoding='utf-8')
    tile_atlas.save(resources)
    sprites.save(resources)
    transport_sprites.save(resources)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('program', type=Path, help='logic_probe.lua 导出的 program.bin')
    parser.add_argument('rom', type=Path, help='2003/01/01 Master Ver. 的 ket.zip')
    parser.add_argument('--output', type=Path, default=ROOT / 'mod/GAME/th43/native')
    parser.add_argument('--resources', type=Path, default=ROOT / 'Resources/th43/native')
    args = parser.parse_args()
    export(read_program(args.program), args.rom, args.output, args.resources)


if __name__ == '__main__':
    main()
