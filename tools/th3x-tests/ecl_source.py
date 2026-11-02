"""离线读取原作反汇编，并用原始二进制校验指令地址、时间和难度掩码。

仅供逐卡核对，游戏不载入。本模块不会把未实现的指令当作通过。
"""
from dataclasses import dataclass
from pathlib import Path
import hashlib
import math
import re
import struct


def f32(value):
    return struct.unpack('<f', struct.pack('<f', value))[0]


@dataclass(frozen=True)
class Variable:
    index: int


@dataclass
class Instruction:
    address: int
    time: int
    op: int
    mask: int
    args: list


class Source:
    def __init__(self, declaration, binary, game=8):
        self.declaration, self.binary = Path(declaration), Path(binary)
        data = self.binary.read_bytes()
        self.sha256 = hashlib.sha256(data).hexdigest()
        self.subs, self.labels = {}, {}
        # 文本的日文字符串不是指令语义的来源；数值部分为 ASCII，原始掩码从二进制取。
        text = self.declaration.read_text('cp932', errors='replace')
        # 说明字符串尾部也可能含真正的CR/LF（ecldata3sp:Sub56）；先保留为转义文本，
        # 防止它伪造指令/子程序的文本行边界。名称本身仍用于入口身份核对。
        text = re.sub(r'"(?:\\.|[^"\\])*"',
                      lambda m: m[0].replace('\r', r'\r').replace('\n', r'\n'), text)
        for match in re.finditer(r'(?:void|sub) (\w+)\([^)]*\)\s*\{(.*?)\n\}', text, re.S):
            name, body = match.groups()
            rows, time, labels, next_address = [], 0, [], None
            # 原版符卡说明的尾部可能含0x1c等未清零字节。splitlines会把它当换行，
            # 从而整条漏掉START_SPELL（例如永夜抄ecldata6的0x908c）。只认文本的LF。
            for line in body.split('\n'):
                tick = re.match(r'\+(\d+):', line)
                if tick:
                    time += int(tick[1])
                absolute = re.fullmatch(r'(\d+):', line.strip())
                if absolute:
                    time = int(absolute[1])
                label = re.fullmatch(r'(\w+):', line.strip())
                if label and not absolute:
                    labels.append(label[1])
                ins = re.search(r'/\*\s*([0-9a-f]+) \([^*]+\*/\s*ins_(\d+)\((.*)\);', line)
                if not ins:
                    assert not re.search(r'\bins_\d+\(', line), (self.binary, name, '未解析的指令', repr(line))
                    continue
                address, op = int(ins[1], 16), int(ins[2])
                if game == 10:
                    bt, bo, size, flags, mask, _ = struct.unpack_from('<ihHHBB', data, address)
                else:
                    bt, bo, size, _, mask, flags = struct.unpack_from('<ihhBBH', data, address)
                assert (bt, bo) == (time, op), (self.binary, name, address, bt, bo, time, op)
                assert next_address is None or address == next_address, (self.binary, name, '子程序中漏读指令', hex(address), hex(next_address))
                assert size >= (16 if game == 10 else 12), (self.binary, name, address, size)
                next_address = address + size
                tokens = re.findall(r'"(?:\\.|[^"\\])*"|[^,]+', ins[3])
                args = []
                for token in tokens:
                    token = re.sub(r'^_[SFDsfd]{2}\s+', '', token.strip())
                    if token.startswith('['):
                        args.append(Variable(int(float(token[1:-1].removesuffix('f')))))
                    elif token.startswith('"') or re.fullmatch(r'\w+_\d+', token):
                        args.append(token)
                    elif token:
                        args.append(f32(float(token[:-1])) if token.endswith('f') else int(token))
                row = Instruction(address, time, op, mask, args)
                for label in labels:
                    self.labels[label] = address
                labels.clear()
                rows.append(row)
            self.subs[name] = rows


class ScalarTrace:
    """TH08 单个发弹子程序的标量/跳转参照，不模拟对象运动和子弹生命周期。

    外部坐标、随机数由调用者显式提供；副作用保留成事件供 Lua 实现对比。
    遇到此范围以外的指令立即报错，不能据此声称整卡逐帧一致。
    """
    def __init__(self, source, sub, variables=None, external=None, mask=8, effects=(), snapshots=False):
        self.source, self.rows = source, source.subs[sub]
        self.lookup = {r.address: i for i, r in enumerate(self.rows)}
        self.variables = {**dict.fromkeys(range(10000, 10032), 0), **(variables or {})}
        self.external = external or (lambda index, frame: 0)
        self.mask, self.pc, self.time, self.frame = mask, 0, 0, 0
        self.wait, self.done, self.transforms, self.events = 0, False, {}, []
        # 调用者必须显式声明哪些副作用只取事件，不据此推断其执行结果。
        self.effects = set(effects)
        self.snapshots = snapshots

    def get(self, value):
        if not isinstance(value, Variable):
            return value
        if value.index in self.variables:
            return self.variables[value.index]
        return self.external(value.index, self.frame)

    def put(self, target, value, floating=False):
        assert isinstance(target, Variable), target
        self.variables[target.index] = f32(value) if floating else int(value)

    def branch(self, time, label):
        self.time = time
        self.pc = self.lookup[self.source.labels[label]]

    def tick(self):
        steps = 0
        while not self.done and self.pc < len(self.rows):
            if self.wait > 0:
                self.wait -= 1
                self.time -= 1
                break
            r = self.rows[self.pc]
            if r.time != self.time:
                break
            self.pc += 1
            if r.mask & self.mask != self.mask:
                continue
            steps += 1
            assert steps < 100000, ('零时长死循环', r.address)
            op, raw = r.op, r.args
            a = [self.get(v) for v in raw]
            if op in (0, 3):
                pass
            elif op in (1, 53):
                self.done = True
            elif op == 2:
                self.wait = a[0]
            elif op == 4:
                self.branch(*a)
            elif op == 5:
                self.put(raw[2], a[2] - 1)
                if self.get(raw[2]) > 0:
                    self.branch(a[0], a[1])
            elif op in (6, 7):
                self.put(raw[0], a[1], op == 7)
            elif 10 <= op <= 29:
                if op < 20:
                    left, right, index = a[0], a[1], (op - 10) % 5
                else:
                    left, right, index = a[1], a[2], (op - 20) % 5
                value = (lambda: left + right, lambda: left - right, lambda: left * right,
                         lambda: left / right, lambda: math.fmod(left, right))[index]()
                self.put(raw[0], value, 15 <= op <= 19 or 25 <= op <= 29)
            elif op in (30, 31):
                self.put(raw[0], a[0] + (1 if op == 30 else -1))
            elif op == 37:
                value = a[0] % (2 * math.pi)
                self.put(raw[0], value - (2 * math.pi if value > math.pi else 0), True)
            elif op == 34:
                self.put(raw[0], math.atan2(a[4] - a[2], a[3] - a[1]), True)
            elif 40 <= op <= 51:
                take = (a[0] == a[1], a[0] != a[1], a[0] < a[1], a[0] <= a[1],
                        a[0] > a[1], a[0] >= a[1])[(op - 40) // 2]
                if take:
                    self.branch(a[2], a[3])
            elif op == 111:
                self.transforms[a[0]] = a[1:]
            elif op in self.effects or op in (54, 55, 56, 57, 58, 59, 60, 61, 62, 67, 80, 81, 114, 115, 124) or 96 <= op <= 104:
                self.events.append(dict(frame=self.frame, op=op, args=a, address=r.address,
                                        transforms={k: list(v) for k, v in self.transforms.items()}))
                if self.snapshots:
                    self.events[-1]['variables'] = dict(self.variables)
            else:
                raise NotImplementedError((self.source.binary.name, hex(r.address), op))
        self.time += 1
        self.frame += 1

    def run(self, frames):
        for _ in range(frames):
            self.tick()
        return self.events
