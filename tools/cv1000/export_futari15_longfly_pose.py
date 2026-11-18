"""离线展开 0x32 / 0x42–0x44 的 SH-3 绘制及 0x32 Original 击破算式。

分支在导出时合并为数值选择，查表数据随文件导出，不在游戏中执行 CPU 指令。
遇到未支持的指令或产生绘制副作用的分支会失败，防止静默漏掉零件。
击破只展开已核对的第一面单人 Original 参数；计分、掉落、声音与对象回收由原生类处理。
"""
import argparse,copy,re,struct
from pathlib import Path
import capstone

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('ram',type=Path)
parser.add_argument('output',type=Path)
parser.add_argument('--mode',choices=('pose','death','groundpose'),default='pose')
parser.add_argument('--variant',type=lambda s:int(s,0),choices=(0x42,0x43,0x44),default=0x42)
args=parser.parse_args()
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
for a in range(*({'pose':(0xc0a9880,0xc0aa910,2),'death':(0xc0aac50,0xc0ab9e0,2),
                  'groundpose':(0xc0a5e40,0xc0a6f00,2)}[args.mode])):
    i=next(md.disasm(sh3.m[a-sh3.base:a-sh3.base+2],a),None)
    if i:code[a]=(i.mnemonic,i.op_str)
def parts(s):return re.split(r',(?![^()]*\))',s)
def succ(pc):
    mn,args=code[pc]
    if mn in('rts','jmp'):return []
    if mn=='bra':return [int(args,16)]
    if mn=='braf':
        before=code[pc-2]
        assert before[0]=='mov.w'
        offset=sh3.read(int(parts(before[1])[0],16),'h')
        return [pc+4+offset]
    if mn in('bt','bf','bt/s','bf/s'):return [int(args,16),pc+(4 if '/s'in mn else 2)]
    return [pc+(4 if mn=='jsr'else 2)]
def reachable(pc):
    seen={};todo=[(pc,0)]
    while todo:
        pc,n=todo.pop(0)
        if pc in seen:continue
        seen[pc]=n
        for nxt in succ(pc):todo.append((nxt,n+1))
    return seen
class State:
    def __init__(self):
        self.r=[0]*16;self.r[4]=0x10000;self.r[15]=0x20000000
        self.t=0;self.mach=self.macl=0;self.mem={};self.draw=[]
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
            j=reg(args);self.r[j]=call('shr'if mn=='shar'else'ushr',self.r[j],1)
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
    def helper(self,target):
        if target==0xc075a50:self.r[0]=0x10000000
        elif target==0xc075c10:self.r[0]=130
        elif target==0xc063740:
            self.draw.append({'sprite':self.r[4],'x':self.r[5],'y':self.r[6],'flip':0});self.r[0]=0x30000000+len(self.draw)*64
        elif target in(0xc05e328,0xc05e2d8,0xc05e424):
            i=(self.r[4]-0x30000000)//64-1
            assert 0<=i<len(self.draw),(hex(target),self.r[4])
            if target==0xc05e2d8:self.draw[i]['flip']=self.r[5]
            self.r[0]=self.r[4]
        else:raise ValueError(('helper',hex(target)))
    def run(self,pc,stop=None):
        while pc!=stop:
            mn,args=code[pc]
            if mn in('bt','bf','bt/s','bf/s'):
                condition=self.t
                if '/s'in mn:self.instruction(pc+2)
                yes,no=int(args,16),pc+(4 if '/s'in mn else 2)
                if mn.startswith('bf'):yes,no=no,yes
                if isinstance(condition,int):pc=yes if condition else no;continue
                a,b=reachable(yes),reachable(no);common=set(a)&set(b)
                join=min(common,key=lambda x:(max(a[x],b[x]),a[x]+b[x]))
                left,right=copy.deepcopy(self),copy.deepcopy(self)
                left.run(yes,join);right.run(no,join)
                assert left.draw==right.draw
                self.r=[call('select',condition,x,y)for x,y in zip(left.r,right.r)]
                self.t=call('select',condition,left.t,right.t)
                assert left.mem==right.mem
                pc=join;continue
            if mn=='bra':self.instruction(pc+2);pc=int(args,16);continue
            if mn=='braf':
                offset=self.r[int(args[1:])];assert isinstance(offset,int)
                self.instruction(pc+2);pc=pc+4+offset;continue
            if mn in('jsr','jmp'):
                target=self.r[int(args[2:])];self.instruction(pc+2);self.helper(target)
                if mn=='jmp':return
                pc+=4;continue
            if mn=='rts':self.instruction(pc+2);return
            self.instruction(pc);pc+=2

def action(text):defs.append('ACTION:'+text)
class Death(State):
    def __init__(self):
        super().__init__();self.r[13]=0x10000000;self.r[9]=0x100000bc
        self.r[14]=self.r[15];self.mem[self.r[14]]=0x40000000;self.mem[self.r[14]+8]=0x100000bc
        self.r[10]=130;self.fx={}
    def read(self,addr,size):
        if not isinstance(addr,int)and size==4:return expr('kind(%s)'%fmt(addr))
        return super().read(addr,size)
    def helper(self,target):
        r=self.r
        if target==0xc075c30:r[0]=130
        elif target in(0xc10ed70,0xc10fab0,0xc06ae10,0xc06b350,0xc06b4b0,0xc076900,0xc0768f0,0xc076920,0xc076940):r[0]=0
        elif target==0xc0631f0:
            defs.append('random(%s)'%fmt(r[4]));r[0]=Expr('v[%d]'%len(defs))
        elif target==0xc0992c0:
            action('fragment(%s,%s,%s,%s)'%tuple(fmt(r[i])for i in(4,5,6,7)));r[0]=0
        elif target==0xc0966d0:
            ptr=0x30000000+len(self.fx)*256
            self.fx[ptr]={'kind':r[4],'x':r[5],'y':r[6],'depth':r[7],'speed':0,'angle':0,'wait':0,'flags':1,'alpha':255}
            r[0]=ptr
        elif target in(0xc096830,0xc096870,0xc0968d0,0xc096930):
            fx=self.fx[r[4]]
            if target==0xc096830:fx['speed'],fx['angle']=r[5],r[6]
            else:fx[{0xc096870:'wait',0xc0968d0:'alpha',0xc096930:'flags'}[target]]=r[5]
        elif target==0xc096950:
            fx=self.fx[r[4]]
            action('particle(%s)'%','.join(fmt(fx[key])for key in('kind','x','y','depth','speed','angle','wait','flags','alpha')))
        elif target==0xc0765b0:pass
        else:raise ValueError(('helper',hex(target)))

class GroundPose(State):
    def read(self,addr,size):
        if addr==0x1000000c:return args.variant
        return super().read(addr,size)
    def helper(self,target):
        if target==0xc075c10:self.r[0]=100
        elif target==0xc0760f0:
            for register,name in ((5,'sx'),(6,'sy')):
                address=self.r[register]
                self.mem[address]=op(self.read(address,4),Expr('trunc(%s/65536)*65536'%name),'+')
        elif target==0xc0760b0:self.r[0]=Expr('sx')
        elif target==0xc0760d0:self.r[0]=Expr('sy')
        else:super().helper(target)

if __name__=='__main__':
    if args.mode=='death':
        state=Death();state.run(0xc0aacb0,0xc0ab93a)
        lines=['-- 0x0c0aacb0–0x0c0ab93a 的 Original 击破参数；按原指令保留随机调用顺序。',
               'local kinds={'+','.join(str(sh3.read(a))for a in range(0xc2dbbd8,0xc2dbbf8,4))+'}',
               'local function kind(address)return assert(kinds[(address-0xc2dbbd8)/4+1])end',
               'local function shl(a,b)return a*2^b end',
               'return function(b,particle,fragment,random)','    local v={}']
        for i,text in enumerate(defs):lines.append('    '+(text[7:]if text.startswith('ACTION:')else'v[%d]=%s'%(i+1,text)))
        lines.append('end');args.output.write_text('\n'.join(lines)+'\n',encoding='utf-8')
        print('expanded',len(defs),'expressions;',len(state.fx),'explosions')
    else:
        ground=args.mode=='groundpose'
        start=0xc0a5e40 if ground else 0xc0a9880
        state=GroundPose()if ground else State();state.run(start)
        first,last=(0xc2db818,0xc2db90c)if ground else(0xc2dbb1c,0xc2dbbd8)
        out=['-- 由 0x%08x 的整数绘制运算展开；参数来自原生对象的振动及轨迹状态。'%start,
             'local floor=math.floor','local function s(n)return (n+2147483648)%4294967296-2147483648 end',
             '-- 拆成十六位求乘积高字，避免 LuaJIT 的双精度乘法丢失 64 位乘积的低位。',
             'local function high(a,b)',
             '    local ah,bh=floor(a/65536),floor(b/65536)',
             '    local al,bl=a%65536,b%65536',
             '    return ah*bh+floor((ah*bl+al*bh+floor(al*bl/65536))/65536)',
             'end',
             'local function hi(a,b)return high(s(a),s(b))end',
             'local function uhi(a,b)return high(a%4294967296,b%4294967296)end',
             'local function shr(a,b)return floor(s(a)/2^b)end','local function shl(a,b)return s(a*2^b)end',
             'local function ushr(a,b)return floor((a%4294967296)/2^b)end','local band=bit.band',
             'local function mod(a,b)return a%b end','local function neg(a)return a<0 and 1 or 0 end',
             'local function ge(a,b)return s(a)>=s(b)and 1 or 0 end','local function gt(a,b)return s(a)>s(b)and 1 or 0 end',
             'local function eq(a,b)return a==b and 1 or 0 end','local function select(t,a,b)return t~=0 and a or b end',
             'local bytes={'+','.join(str(sh3.read(a,'b'))for a in range(first,last))+'}',
             'local function byte(a)return assert(bytes[a-%d+1])end'%first,
             'return function(b,draw,sx,sy)','    sx,sy=sx or 0,sy or 0','    local v={}']
        if ground:out[1:1]=['local trunc=math.modf']
        if any('low('in text for text in defs):
            out[1:1]=['-- 同样拆开低字乘法，避免 MACL 参与绘制时发生双精度截断。',
                      'local function low(a,b)',
                      '    local al,bl=a%65536,b%65536',
                      '    local cross=(math.floor((a%4294967296)/65536)*bl+math.floor((b%4294967296)/65536)*al)%65536',
                      '    return (cross*65536+al*bl+2147483648)%4294967296-2147483648',
                      'end']
        out+=['    v[%d]=%s'%(i+1,text)for i,text in enumerate(defs)]
        out+=['    draw(%s,%s,%s,%s)'%tuple(fmt(row[key])for key in('sprite','x','y','flip'))for row in state.draw]
        out+=['end']
        args.output.write_text('\n'.join(out)+'\n',encoding='utf-8')
        print('expanded',len(defs),'expressions;',len(state.draw),'sprites')
