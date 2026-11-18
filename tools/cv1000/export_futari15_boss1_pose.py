"""离线展开第一/五面关底的整数关节更新（--boss 1 / 5）。

只在导出时分析指令与分支；游戏内文件仅含固定算式和原始数据表。
循环按原常量展开，八种牵引或动画状态通过数值选择合并，不在运行时解释 SH-3。
分支汇合使用后支配关系；半字标志必须按原宽度合并，不能冒充长字。
"""
import argparse,copy,re,struct
from pathlib import Path
import capstone

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('ram',type=Path)
parser.add_argument('output',type=Path)
parser.add_argument('--boss',type=int,choices=(1,5),default=1)
args=parser.parse_args()
entry,code_end,body_size=(0xc1b4c80,0xc1b57d0,0x27a8)if args.boss==5 else(0xc14e450,0xc14f360,0x3f50)
raw=args.ram.read_bytes()
if len(raw)!=0x800000:raise ValueError('工作 RAM 必须为 8 MiB')
class Memory:
    base=0xc000000
    m=b''.join(raw[i:i+8][::-1]for i in range(0,len(raw),8))
    @classmethod
    def read(cls,a,fmt='I'):return struct.unpack_from('>'+fmt,cls.m,a-cls.base)[0]
sh3=Memory

def signed(n):return (n+2147483648)%4294967296-2147483648
class Expr:
    def __init__(self,text):self.text=text
    def __repr__(self):return self.text
    def __deepcopy__(self,memo):return self
def fmt(x):return x.text if isinstance(x,Expr)else str(int(x))
defs=[];cache={}
def expr(text):
    if text not in cache:
        cache[text]=Expr('v[%d]'%(len(defs)+1));defs.append(text)
    return cache[text]
def op(a,b,symbol):
    if isinstance(a,int)and isinstance(b,int):return {'+':lambda:a+b,'-':lambda:a-b,'*':lambda:a*b}[symbol]()
    if symbol=='+'and b==0:return a
    if symbol=='+'and a==0:return b
    if symbol=='-'and b==0:return a
    return expr('(%s%s%s)'%(fmt(a),symbol,fmt(b)))
funcs={'s':signed,'low':lambda a,b:signed(a*b),'hi':lambda a,b:(signed(a)*signed(b))//4294967296,'uhi':lambda a,b:((a%4294967296)*(b%4294967296))//4294967296,'shr':lambda a,b:signed(a)//2**b,
       'shl':lambda a,b:signed(a*2**b),'ushr':lambda a,b:(a%4294967296)//2**b,
       'band':lambda a,b:a&b,'mod':lambda a,b:a%b,'neg':lambda a:int(a<0),
       'ge':lambda a,b:int(signed(a)>=signed(b)),'gt':lambda a,b:int(signed(a)>signed(b)),
       'eq':lambda a,b:int(a==b),'select':lambda t,a,b:a if t else b}
def call(name,*args):
    if all(isinstance(a,int)for a in args):return funcs[name](*args)
    if name=='select'and args[1]==args[2]:return args[1]
    return expr('%s(%s)'%(name,','.join(map(fmt,args))))
md=capstone.Cs(capstone.CS_ARCH_SH,capstone.CS_MODE_SH3|capstone.CS_MODE_BIG_ENDIAN)
code={}
for a in range(entry,code_end,2):
    i=next(md.disasm(sh3.m[a-sh3.base:a-sh3.base+2],a),None)
    if i:code[a]=(i.mnemonic,i.op_str)
switches={0xc14e9e6:(0xc14e9fc,8,7,0),0xc1b5238:(0xc1b5250,8,2,1)}

def parts(s):return re.split(r',(?![^()]*\))',s)
def succ(pc):
    mn,args=code[pc]
    if mn in('rts','jmp'):return []
    if mn=='bra':return [int(args,16)]
    if mn=='braf':
        if pc in switches:
            table,count,_,_=switches[pc]
            return [pc+4+sh3.read(table+2*i,'h')for i in range(count)]
        before=code[pc-2]
        assert before[0]=='mov.w'
        offset=sh3.read(int(parts(before[1])[0],16),'h')
        return [pc+4+offset]
    if mn in('bt','bf','bt/s','bf/s'):return [int(args,16),pc+(4 if '/s'in mn else 2)]
    return [pc+(4 if mn=='jsr'else 2)]
class State:
    def __init__(self):
        self.r=[0]*16;self.r[4]=0x10000;self.r[15]=0x20000000
        self.t=0;self.mach=self.macl=0;self.mem={}
    def address(self,text):
        if text.startswith('0x'):return int(text,16)
        text=text.lstrip('@').rstrip('+')
        if text.startswith('-'):return op(self.r[int(text[2:])],-4,'+')
        if text.startswith('('):
            a,b=parts(text[1:-1]);a=self.r[int(a[1:])]if a.startswith('r')else int(a)
            return op(a,self.r[int(b[1:])],'+')
        return self.r[int(text[1:])]
    def read(self,addr,size):
        if isinstance(addr,int):
            if addr in self.mem:return self.mem[addr]
            if 0x10000000<=addr<0x1000096c:return expr('b[%d]'%(addr-0x10000000))
            if 0xc000000<=addr<0xc800000:
                n=sh3.read(addr,{4:'I',2:'H',1:'B'}[size])
                return signed(n)if size==4 else n-(1<<(size*8))if n>=1<<(size*8-1)else n
            return 0
        assert size==1,addr
        return expr('byte(%s)'%fmt(addr))
    def write(self,addr,value):assert isinstance(addr,int);self.mem[addr]=value
    def instruction(self,pc):
        mn,args=code[pc];ss=parts(args)
        def reg(s):return int(s[1:])
        def value(s):return int(s[1:])if s.startswith('#')else self.r[reg(s)]
        if mn=='nop':return
        if mn.startswith('mov'):
            a,b=ss;size={'mov.l':4,'mov.w':2,'mov.b':1,'mov':4}[mn]
            if a.startswith('@')or a.startswith('0x'):
                addr=self.address(a);v=self.read(addr,size)
                if a.endswith('+'):self.r[reg(a[1:-1])]=op(addr,size,'+')
            else:v=value(a)
            if b.startswith('@'):
                addr=self.address(b);self.write(addr,v)
                if b.startswith('@-'):self.r[reg(b[2:])]=addr
            else:self.r[reg(b)]=v
        elif mn in('add','sub'):
            a,b=ss;j=reg(b);self.r[j]=op(self.r[j],value(a),'+'if mn=='add'else '-')
        elif mn in('dmuls.l','dmulu.l'):
            self.mach=call('hi'if mn=='dmuls.l'else'uhi',value(ss[0]),value(ss[1]))
            self.macl=(value(ss[0]),value(ss[1]))
        elif mn=='mul.l':self.macl=(value(ss[0]),value(ss[1]))
        elif mn=='sts':
            result=self.mach if ss[0]=='mach'else self.macl
            self.r[reg(ss[1])]=call('low',*result)if isinstance(result,tuple)else result
        elif mn=='sts.l':self.r[15]-=4;self.mem[self.r[15]]=0
        elif mn=='lds.l':self.r[15]+=4
        elif mn in('shll','shal'):
            j=reg(args);self.t=call('neg',self.r[j]);self.r[j]=call('shl',self.r[j],1)
        elif mn in('shll2','shll8','shll16','shlr2','shlr8','shlr16'):
            j=reg(args);bits=int(re.search(r'\d+',mn).group());self.r[j]=call('shl'if mn.startswith('shll')else'ushr',self.r[j],bits)
        elif mn in('shar','shlr'):
            j=reg(args);self.t=call('band',self.r[j],1);self.r[j]=call('shr'if mn=='shar'else'ushr',self.r[j],1)
        elif mn in('shad','shld'):
            a,b=ss;j=reg(b);shift=value(a);assert isinstance(shift,int)
            self.r[j]=call(('ushr'if mn=='shld'else'shr')if shift<0 else'shl',self.r[j],abs(shift))
        elif mn=='subc':
            a,b=ss;assert a==b;self.r[reg(b)]=op(0,self.t,'-')
        elif mn=='and':
            a,b=ss;self.r[reg(b)]=call('band',self.r[reg(b)],value(a))
        elif mn=='neg':self.r[reg(ss[1])]=op(0,value(ss[0]),'-')
        elif mn.startswith('cmp/'):
            if mn=='cmp/pz':self.t=call('ge',value(args),0)
            else:a,b=ss;self.t=call({'cmp/gt':'gt','cmp/eq':'eq'}[mn],value(b),value(a))
        elif mn=='extu.b':self.r[reg(ss[1])]=call('mod',value(ss[0]),256)
        else:raise ValueError((hex(pc),mn,args))
    def run(self,pc,stop=None):
        while pc!=stop:
            mn,args=code[pc]
            if mn in('bt','bf','bt/s','bf/s'):
                condition=self.t
                if '/s'in mn:self.instruction(pc+2)
                yes,no=int(args,16),pc+(4 if '/s'in mn else 2)
                if mn.startswith('bf'):yes,no=no,yes
                if isinstance(condition,int):pc=yes if condition else no;continue
                join=joins[pc]
                left,right=copy.deepcopy(self),copy.deepcopy(self)
                left.guard.append((condition,True));right.guard.append((condition,False))
                left.run(yes,join);right.run(no,join)
                self.r=[call('select',condition,x,y)for x,y in zip(left.r,right.r)]
                self.t=call('select',condition,left.t,right.t)
                self.mach=call('select',condition,left.mach,right.mach)
                self.macl=call('select',condition,mac_value(left.macl),mac_value(right.macl))
                self.mem={a:call('select',condition,left.read(a,field_size(a)),right.read(a,field_size(a)))for a in sorted(set(left.mem)|set(right.mem))}
                pc=join;continue
            if mn=='bra':self.instruction(pc+2);pc=int(args,16);continue
            if mn=='braf':
                offset=self.r[int(args[1:])]
                if isinstance(offset,Expr):
                    table,count,index_reg,shift=switches[pc]
                    index=call('shr',self.r[index_reg],shift)if shift else self.r[index_reg]
                    choices=[]
                    for i in range(count):
                        branch=copy.deepcopy(self);branch.guard.append((call('eq',index,i),True));branch.run(pc+4+sh3.read(table+2*i,'h'),joins[pc])
                        choices.append(branch)
                    def choose(values):
                        value=values[-1]
                        for i in range(count-2,-1,-1):value=call('select',call('eq',index,i),values[i],value)
                        return value
                    self.r=[choose([branch.r[j]for branch in choices])for j in range(16)]
                    self.mach=choose([b.mach for b in choices])
                    self.macl=choose([mac_value(b.macl)for b in choices])
                    self.mem={a:choose([branch.read(a,field_size(a))for branch in choices])for a in sorted(set().union(*(set(b.mem)for b in choices)))}
                    self.t=choose([b.t for b in choices]);pc=joins[pc];continue
                assert isinstance(offset,int)
                self.instruction(pc+2);pc=pc+4+offset;continue
            if mn in('jsr','jmp'):
                target=self.r[int(args[2:])];self.instruction(pc+2);self.helper(target)
                if mn=='jmp':return
                pc+=4;continue
            if mn=='rts':self.instruction(pc+2);return
            self.instruction(pc);pc+=2

class Boss(State):
    def __init__(self):
        super().__init__();self.r[4]=0x10000000;self.guard=[]
    def read(self,addr,size):
        if isinstance(addr,int) and 0x10000000<=addr<0x10000000+body_size:
            if addr in self.mem:return self.mem[addr]
            read_sizes.setdefault(addr-0x10000000,set()).add(size)
            return expr('b[%d]'%(addr-0x10000000))
        return super().read(addr,size)
    def write(self,addr,value):
        if not isinstance(addr,int):raise ValueError('关节写入地址必须在导出时确定')
        if 0x10000000<=addr<0x10000000+body_size:write_sizes.setdefault(addr-0x10000000,set()).add(self.write_size)
        self.mem[addr]=value
    def instruction(self,pc):
        mn,args=code[pc];ss=parts(args)
        self.write_size={'mov.w':2,'mov.b':1}.get(mn,4)
        def reg(s):return int(s[1:])
        def value(s):return int(s[1:])if s.startswith('#')else self.r[reg(s)]
        if mn=='tst':self.t=call('eq',call('band',value(ss[0]),value(ss[1])),0)
        elif mn=='dt':
            j=reg(args);self.r[j]=op(self.r[j],1,'-');self.t=call('eq',self.r[j],0)
        elif mn=='rotl':
            j=reg(args);self.t=call('neg',self.r[j]);self.r[j]=call('s',op(call('shl',self.r[j],1),self.t,'+'))
        elif mn=='movt':self.r[reg(args)]=self.t
        elif mn=='mova':self.r[0]=int(ss[0],16)
        elif mn=='cmp/hi':self.t=call('ugt',value(ss[1]),value(ss[0]))
        elif mn=='cmp/ge':self.t=call('ge',value(ss[1]),value(ss[0]))
        elif mn=='cmp/pl':self.t=call('gt',value(args),0)
        elif mn=='swap.w':self.r[reg(ss[1])]=call('swap',value(ss[0]))
        elif mn=='exts.w':self.r[reg(ss[1])]=call('sw',value(ss[0]))
        else:super().instruction(pc)
    def helper(self,target):
        self.write_size=4
        r=self.r
        if target==0xc1561e0:action('jump(b)')
        elif target==0xc076030:r[0]=Expr('dx')
        elif target==0xc0761d0:r[0]=Expr('camera')
        elif target==0xc057490:
            assert all(isinstance(r[i],int) for i in (4,5,6))
            values=[self.read(r[5]+i,4) for i in range(0,r[6],4)]
            for i,v in enumerate(values):self.write(r[4]+i*4,v)
        elif target==0xc063680:
            for i,name in ((6,'vx'),(7,'vy')):
                if r[i]:self.write(r[i],expr('%s(%s,%s)'%(name,fmt(r[4]),fmt(r[5]))))
        elif target==0xc063170:r[0]=expr('distance(%s)'%','.join(fmt(r[i]) for i in (4,5,6,7)))
        elif target==0xc0632b0:r[0]=expr('heading(%s)'%','.join(fmt(r[i]) for i in (6,7,4,5)))
        elif target==0xc063540:r[0]=expr('turn(%s)'%','.join(fmt(r[i]) for i in (4,5,6)))
        elif target==0xc076220:r[0]=expr('aim(%s,%s,px,py,active)'%(fmt(r[5]),fmt(r[6])))
        elif target==0xc1b6520:
            # 牵引段长由 24 项定点距离表决定，同时可写回寻向结果。
            length=self.read(r[15],4);angle=self.read(r[15]+4,4)
            value=expr('spacing(distance(%s))'%','.join(fmt(r[i])for i in(4,5,6,7)))
            if angle:self.write(angle,expr('heading(%s)'%','.join(fmt(r[i])for i in(6,7,4,5))))
            self.write(length,value);r[0]=call('gt',value,3)
        elif target==0xc1b11b0:r[0]=expr('angle_distance(%s,%s)'%(fmt(r[4]),fmt(r[5])))
        else:raise ValueError(('helper',hex(target)))


nodes=set();todo=[entry]
while todo:
    pc=todo.pop()
    if pc in nodes:continue
    nodes.add(pc);todo.extend(succ(pc))
exit_node=-1
all_nodes=nodes|{exit_node}
post={n:set(all_nodes)for n in nodes};post[exit_node]={exit_node}
changed=True
while changed:
    changed=False
    for pc in sorted(nodes,reverse=True):
        targets=succ(pc)or[exit_node]
        result={pc}|set.intersection(*(post[n]for n in targets))
        if post[pc]!=result:post[pc]=result;changed=True
joins={pc:max(post[pc]-{pc},key=lambda n:len(post[n]))for pc in nodes}
funcs['sw']=lambda n:(n+32768)%65536-32768
funcs['swap']=lambda n:signed((n%65536)*65536+(n%4294967296)//65536)
funcs['ugt']=lambda a,b:int(a%4294967296>b%4294967296)

def mac_value(n):return call('low',*n)if isinstance(n,tuple)else n
def field_size(a):
    at=a-0x10000000
    sizes=write_sizes.get(at)or read_sizes.get(at)or{4}
    assert len(sizes)==1,(hex(a),sizes)
    return next(iter(sizes))
originalread=Boss.read
def read(self,addr,size):
    if not isinstance(addr,int) and size==2:return expr('word(%s)'%fmt(addr))
    if not isinstance(addr,int) and size==4:
        guard=1
        for condition,yes in self.guard:
            guard=call('band',guard,condition if yes else call('eq',condition,0))
        return expr('long(%s,%s)'%(fmt(addr),fmt(guard)))
    return originalread(self,addr,size)
Boss.read=read

def emit_lua(state,output_fields,needed):
    input_fields=set((16,20,24))if args.boss==1 else set()
    for i in needed:
        input_fields.update(map(int,re.findall(r'b\[(\d+)\]',defs[i-1])))
    sizes={a:next(iter(read_sizes.get(a)or write_sizes.get(a)or{4}))for a in input_fields}
    # 四字节半径表位于两张相邻的关节参数表之间；不携带可执行指令。
    first,last=(0xc31c8c4,0xc31c924)if args.boss==5 else(0xc307c38,0xc307cc0)
    out=[f'-- 原版 0x{entry:08x} 的关节、振动与历史位置算式；由离线工具展开，运行时没有指令解释器。',
         '-- 本体仍等待完整原生控制器挂载；输入表使用原结构偏移，半字标志保留两字节宽度。',
         "local direction=dofile('mod/GAME/th46/direction.lua')",
         'local heading,vector=direction.heading,direction.vector','local floor=math.floor',
         'local function s(n)return(n+2147483648)%4294967296-2147483648 end',
         'local function high(a,b)',
         '    local ah,bh=floor(a/65536),floor(b/65536)',
         '    local al,bl=a%65536,b%65536',
         '    return ah*bh+floor((ah*bl+al*bh+floor(al*bl/65536))/65536)','end',
         'local function hi(a,b)return high(s(a),s(b))end',
         'local function uhi(a,b)return high(a%4294967296,b%4294967296)end',
         'local function low(a,b)',
         '    local al,bl=a%65536,b%65536',
         '    local cross=(floor((a%4294967296)/65536)*bl+floor((b%4294967296)/65536)*al)%65536',
         '    return s(cross*65536+al*bl)','end',
         'local function shr(a,b)return floor(s(a)/2^b)end',
         'local function shl(a,b)return s(a*2^b)end',
         'local function ushr(a,b)return floor((a%4294967296)/2^b)end',
         'local function sw(n)return(n+32768)%65536-32768 end','local band=bit.band',
         'local function swap(n)return s((n%65536)*65536+floor((n%4294967296)/65536))end',
         'local function eq(a,b)return a==b and 1 or 0 end',
         'local function gt(a,b)return s(a)>s(b)and 1 or 0 end',
         'local function ge(a,b)return s(a)>=s(b)and 1 or 0 end',
         'local function ugt(a,b)return a%4294967296>b%4294967296 and 1 or 0 end',
         'local function neg(a)return a<0 and 1 or 0 end',
         'local function select(t,a,b)return t~=0 and a or b end',
         'local function vx(speed,a)local x=vector(speed,a);return s(x)end',
         'local function vy(speed,a)local _,y=vector(speed,a);return s(y)end',
         'local function aim(x,y,px,py,active)return active~=0 and heading(x,y,px,py)or 256 end',
         'local function distance(x,y,tx,ty)',
         '    local a,b=math.abs(x-tx),math.abs(y-ty)',
         '    return math.max(a,b)+floor(math.min(a,b)/2)','end',
         'local function turn(target,current,amount)',
         '    return(current+math.max(-amount,math.min(amount,(target-current+256)%512-256)))%512','end',
         '-- 只在原分支实际使用时查参数，避免预求值读取另一种牵引状态的临时字段。',
         'local data={'+','.join(str(sh3.read(a,'i'))for a in range(first,last,4))+'}',
         'local function long(a,active)',
         '    if active==0 then return 0 end',
         '    return assert(data[(a-%d)/4+1],"关底牵引参数越界")'%first,'end',
         '-- 落地只返回事件，由原生控制器挂载 0x0c155da0，不能在算式里伪造演出。',
         'local function jump(b)',
         '    if b[24]==0 then return false end',
         '    b[16]=s(b[16]+b[20])',
         '    local landed=b[16]<=0',
         '    if landed then b[16],b[24]=0,0 end',
         '    b[20]=s(b[20]-6553)',
         '    return landed','end',
         'local function update(b,dx,camera,px,py,active)',
         '    -- 复用临时算式表，避免每步为大关节结构分配数千个临时槽。',
         '    local v=b._poseWork',
         '    if not v then v={};b._poseWork=v end', '    local landed=false']
    if args.boss==5:
        a=out.index('-- 落地只返回事件，由原生控制器挂载 0x0c155da0，不能在算式里伪造演出。')
        b=out.index('local function update(b,dx,camera,px,py,active)')
        out[a:b]=['-- 0x0c1b6520：以原版整数距离选牵引段长，超过表尾仍用最后一项。',
            'local function spacing(d)',
            '    local i=math.min(23,math.floor(math.abs(d)/65536))',
            '    return data[i+1]','end',
            'local function angle_distance(a,b)return math.abs((a-b+256)%512-256)end']
    for i,text in enumerate(defs,1):
        if i not in needed:continue
        if text.startswith('ACTION:'):
            assert text=='ACTION:jump(b)'
            out.append('    landed=jump(b)')
        else:out.append('    v[%d]=%s'%(i,text))
    for at,value in sorted(output_fields.items()):out.append('    b[%d]=%s'%(at,fmt(value)))
    out+=['    return landed','end','return {update=update,',
          '    inputFields={'+','.join('{%d,%d}'%(a,sizes[a])for a in sorted(sizes))+'},',
          '    outputFields={'+','.join('{%d,%d}'%(a,next(iter(write_sizes[a])))for a in sorted(output_fields))+'},','}']
    args.output.write_bytes(('\n'.join(out)+'\n').encode('utf-8'))
    print('展开',len(needed),'个算式与',len(output_fields),'个输出字段')


def action(text):defs.append('ACTION:'+text)
read_sizes,write_sizes={},{}
state=Boss();state.run(entry)
output_fields={a-0x10000000:v for a,v in state.mem.items()if 0x10000000<=a<0x10000000+body_size}
for a,sizes in read_sizes.items():
    if len(sizes)!=1:raise ValueError(('混用输入宽度',a,sizes))
for a,sizes in write_sizes.items():
    if len(sizes)!=1:raise ValueError(('混用输出宽度',a,sizes))

# 去掉间接跳转用的死值；运行时既不需要指令字，也不保留控制流地址。
needed=set()
def require(text):
    for number in re.findall(r'v\[(\d+)\]',text):
        i=int(number)
        if i not in needed:needed.add(i);require(defs[i-1])
for value in output_fields.values():require(fmt(value))
for i,text in enumerate(defs,1):
    if text.startswith('ACTION:'):needed.add(i);require(text)
assert not any('word('in defs[i-1]for i in needed)
emit_lua(state,output_fields,needed)
