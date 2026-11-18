"""离线展开第一面关底 0x0c14c260 的绘图、牵引点及脚步事件。

游戏内仅运行固定整数算式与只读绘图参数；不解释原程序指令。
曲线的细分上限 30 来自 0x0c14edbc，循环按此上限静态展开。
"""
import argparse,copy,re,struct
from pathlib import Path
import capstone

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('ram',type=Path)
parser.add_argument('output',type=Path)
parser.add_argument('--vram',type=Path)
parser.add_argument('--atlas',type=Path)
parser.add_argument('--art-data',type=Path)
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
for a in range(0xc14c260,0xc14e230,2):
    i=next(md.disasm(sh3.m[a-sh3.base:a-sh3.base+2],a),None)
    if i:code[a]=(i.mnemonic,i.op_str)

def parts(s):return re.split(r',(?![^()]*\))',s)
switches={0xc14cad0:(0xc14caec,4),0xc14cf70:(0xc14cf9c,5)}

def succ(pc):
    mn,args=code[pc]
    if mn in('rts','jmp'):return []
    if mn=='bra':return [int(args,16)]
    if mn=='braf':
        if pc in switches:
            table,count=switches[pc]
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
            # 原关节更新将曲线细分数钳到 30；不能无限展开运行时循环。
            if pc==0xc14d3ea and self.read(self.r[14]+168,4)>=30:self.t=1
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
                    table,count={0xc14cad0:(0xc14caec,4),0xc14cf70:(0xc14cf9c,5)}[pc]
                    index=call('ushr',self.r[2],1)
                    choices=[]
                    for i in range(count):
                        branch=copy.deepcopy(self);branch.guard.append((call('eq',index,i),True))
                        branch.run(pc+4+sh3.read(table+2*i,'h'),joins[pc]);choices.append(branch)
                    def choose(values):
                        value=values[-1]
                        for i in range(count-2,-1,-1):value=call('select',call('eq',index,i),values[i],value)
                        return value
                    self.r=[choose([b.r[j]for b in choices])for j in range(16)]
                    self.mach=choose([b.mach for b in choices]);self.macl=choose([mac_value(b.macl)for b in choices])
                    self.mem={a:choose([b.read(a,field_size(a))for b in choices])for a in sorted(set().union(*(set(b.mem)for b in choices)))}
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
        if isinstance(addr,int) and 0x10000000<=addr<0x10003f50:
            if addr in self.mem:return self.mem[addr]
            read_sizes.setdefault(addr-0x10000000,set()).add(size)
            return expr('b[%d]'%(addr-0x10000000))
        return super().read(addr,size)
    def write(self,addr,value):
        if not isinstance(addr,int):raise ValueError('关节写入地址必须在导出时确定')
        if 0x10000000<=addr<0x10003f50:write_sizes.setdefault(addr-0x10000000,set()).add(self.write_size)
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
        else:raise ValueError(('helper',hex(target)))


funcs['sw']=lambda n:(n+32768)%65536-32768
funcs['swap']=lambda n:signed((n%65536)*65536+(n%4294967296)//65536)
funcs['ugt']=lambda a,b:int(a%4294967296>b%4294967296)
def mac_value(n):return call('low',*n)if isinstance(n,tuple)else n
read_sizes,write_sizes={},{}
def field_size(a):return next(iter(write_sizes.get(a-0x10000000)or read_sizes.get(a-0x10000000)or{4}))
def action(text):defs.append('ACTION:'+text)

class Draw(Boss):
 def __init__(self):
  super().__init__();self.r[4]=0x40000000;self.r[7]=0x50000000
 def guard_value(self):
  value=1
  for c,yes in self.guard:value=call('band',value,c if yes else call('eq',c,0))
  return value
 def read(self,addr,size):
  if addr==0x50000000:return 0x10002010
  if addr==0x50000004:return 0x10003f4c
  if addr==0x10002010:return Expr('color')
  if addr==0x10003f4c:return Expr('alpha')
  if isinstance(addr,Expr):return expr('rom%d(%s,%s)'%(size,fmt(addr),fmt(self.guard_value())))
  return super().read(addr,size)
 def helper(self,target):
  global sprite_count
  self.write_size=4;r=self.r
  if target==0xc075a70:r[0]=0x10000000
  elif target==0xc075c10:r[0]=Expr('depth')
  elif target==0xc0760b0:r[0]=Expr('sx')
  elif target==0xc0760d0:r[0]=Expr('sy')
  elif target in (0xc14e360,0xc1b1270):
   color_ptr=self.read(r[15],4);alpha_ptr=self.read(r[15]+4,4);flip=self.read(r[15]+8,4)
   color=self.read(color_ptr,4)if color_ptr else 0x808080
   alpha=self.read(alpha_ptr,4)if alpha_ptr else -1
   action(('strip(%s)'if target==0xc14e360 else'single(%s)')%','.join(fmt(v)for v in(r[4],r[5],r[6],r[7],color,alpha,flip,self.guard_value())))
  elif target==0xc063740:
   sprite_count+=1;ptr=0x70000000+sprite_count*64
   action('sprite(%s)'%','.join(fmt(v)for v in(ptr,r[4],r[5],r[6],r[7],self.guard_value())))
   r[0]=ptr
  elif target in (0xc05e328,0xc05e2d8,0xc05e424):
   action('setSprite(%s)'%','.join(fmt(v)for v in(target,r[4],r[5],r[6],r[7],self.guard_value())))
  elif target==0xc1d45c4:r[0]=expr('div(%s,%s,%s)'%(fmt(r[4]),fmt(r[5]),fmt(self.guard_value())))
  elif target==0xc063150:r[0]=expr('abs(%s)'%fmt(r[4]))
  elif target==0xc14b620:r[0]=expr('triangle(%s,%s)'%(fmt(r[4]),fmt(r[5])))
  elif target in (0xc14bce0,0xc14bd30):
   for i in (5,6,7):
    self.write(r[i],expr('facing%d(%s,%d)'%(i-5,fmt(r[4]),1 if target==0xc14bd30 else 0)))
  elif target==0xc0631f0:
   # 此分支只选脚步音效；几何状态不依赖随机结果。
   r[0]=expr('stepRandom(%s,%s)'%(fmt(r[4]),fmt(self.guard_value())))
  elif target in (0xc09c4c0,0xc154b40,0xc10faf0):
   action('event(%s)'%','.join(fmt(v)for v in(target,r[4],r[5],self.guard_value())))
  else:super().helper(target)

nodes=set();todo=[0xc14c260]
while todo:
 pc=todo.pop()
 if pc in nodes:continue
 nodes.add(pc);todo.extend(succ(pc))
post={n:set(nodes)|{-1}for n in nodes};post[-1]={-1}
changed=True
while changed:
 changed=False
 for pc in sorted(nodes,reverse=True):
  result={pc}|set.intersection(*(post[n]for n in(succ(pc)or[-1])))
  if post[pc]!=result:post[pc]=result;changed=True
joins={pc:max(post[pc]-{pc},key=lambda n:len(post[n]))for pc in nodes}
sprite_count=0
state=Draw();state.run(0xc14c260)

output_fields={a-0x10000000:v for a,v in state.mem.items()if 0x10000000<=a<0x10003f50}
for sizes in (read_sizes,write_sizes):
    for at,widths in sizes.items():
        if len(widths)!=1:raise ValueError(('绘图字段混用宽度',hex(at),widths))

needed=set()
def require(text):
    for number in re.findall(r'v\[(\d+)\]',text):
        i=int(number)
        if i not in needed:needed.add(i);require(defs[i-1])
for value in output_fields.values():require(fmt(value))
for i,text in enumerate(defs,1):
    if text.startswith('ACTION:'):needed.add(i);require(text)
input_fields=set()
for i in needed:input_fields.update(map(int,re.findall(r'b\[(\d+)\]',defs[i-1])))
input_fields.discard(0)  # 根对象指针只作为脚步事件的所有者，运行时由原生对象闭包提供。

def emit_runtime():
    first,last=0xc303ebc,0xc307c38
    data=sh3.m[first-sh3.base:last-sh3.base]
    out=['-- 0x0c14c260 的完整绘制、六个牵引点与脚步事件；离线展开，运行时没有指令解释器。',
         '-- 曲线最多细分 30 次，来自原关节更新 0x0c14edbc；不得据采样姿态删减分支。',runtime_helpers,
         'local abs=math.abs',
         '-- 分支被压平后仍不执行未激活的除法；原版零除会陷入异常入口，不能让它污染其它分支。',
         'local function div(a,b,active)',
         '    if active==0 then return 0 end',
         '    assert(s(b)~=0,"关底绘图发生零除")',
         '    local n=s(a)/s(b);return n<0 and -floor(-n)or floor(n)','end',
         'local function triangle(a,n)if n==0 then return 0 end;local r=(a%4294967296)%(n*2);return math.min(r,n*2-r)end',
         'local function facing(a,high)',
         '    local d=high==1 and floor((a%4294967296)/2)%256 or floor((a%512)/4)',
         '    local center=high==1 and 128 or 64',
         '    local limit=high==1 and 32 or 16',
         '    if d>center then return math.min(limit,d-center),1,-1 end',
         '    return math.min(limit,center-d),0,1','end',
         'local function facing0(a,h)local i=facing(a,h);return i end',
         'local function facing1(a,h)local _,f=facing(a,h);return f end',
         'local function facing2(a,h)local _,_,d=facing(a,h);return d end',
         '-- 只保留绘图表和有符号锚点字节，不携带原程序的可执行代码。','local data=']
    chunks=['"'+''.join('\\%03d'%n for n in data[i:i+96])+'"'for i in range(0,len(data),96)]
    out.append('    '+('..\n    '.join(chunks)))
    out+=['local function rom(a,width,active)',
          '    if active==0 then return 0 end',
          '    local at=a-%d+1'%first,
          '    assert(at>=1 and at+width-1<=#data,"关底绘图表越界："..a)',
          '    local n=0;for i=0,width-1 do n=n*256+data:byte(at+i)end',
          '    return n>=2^(width*8-1)and n-2^(width*8)or n','end',
          'local function rom1(a,g)return rom(a,1,g)end',
          'local function rom2(a,g)return rom(a,2,g)end',
          'local function rom4(a,g)return rom(a,4,g)end',
          'local function update(b,depth,sx,sy,color,alpha,emit,event,random)',
          '    local v=b._drawWork;if not v then v={};b._drawWork=v end',
          '    local allocated={}',
          '    local function single(id,x,y,z,c,a,f,g)',
          '        if g~=0 then return emit(id,x,y,z,c,a<0 and -1 or a%256,f)end','    end',
          '    local function strip(at,x,y,z,c,a,f,g)',
          '        if g==0 then return end',
          '        local id,count=rom2(at,1),rom2(at+2,1)',
          '        if id<=0 or count<=0 then return end',
          '        local anchors=rom4(at+4,1)',
          '        for i=0,count-1 do',
          '            local dx,dy=rom1(anchors+i*2,1),rom1(anchors+i*2+1,1)',
          '            single(id+i,s(x+(f%2~=0 and -dx or dx)*65536),s(y+dy*65536),z,c,a,f,1)',
          '        end','    end',
          '    local function sprite(ptr,id,x,y,z,g)',
          '        if g~=0 then allocated[ptr]=single(id,x,y,z,8421504,-1,0,1)end','    end',
          '    local function setSprite(kind,ptr,a,c,d,g)',
          '        if g==0 then return end',
          '        local row=assert(allocated[ptr],"关底绘图属性缺少精灵")',
          '        if kind==%d then row[5]=a'%0xc05e328,
          '        elseif kind==%d then row[7]=a'%0xc05e2d8,
          '        elseif kind==%d then row[6]=d end'%0xc05e424,'    end',
          '    local function stepRandom(n,g)if g==0 then return 0 end;return random and random(n)or 0 end',
          '    local function notify(kind,a,c,g)',
          '        if g~=0 and event then',
          '            if kind==%d then event("stepSound",a)'%0xc09c4c0,
          '            elseif kind==%d then event("foot",c)'%0xc154b40,
          '            else event("stepShake")end','        end','    end']
    for i,text in enumerate(defs,1):
        if i not in needed:continue
        if text.startswith('ACTION:'):out.append('    '+text[7:].replace('event(','notify('))
        else:out.append('    v[%d]=%s'%(i,text))
    for at,value in sorted(output_fields.items()):out.append('    b[%d]=%s'%(at,fmt(value)))
    def fields(offsets,sizes):
        return ','.join('{%d,%d}'%(at,next(iter(sizes[at])))for at in sorted(offsets))
    out+=['end','return {update=update,',
          '    inputFields={'+fields(input_fields,read_sizes)+'},',
          '    outputFields={'+fields(output_fields,write_sizes)+'},','}']
    args.output.write_bytes(('\n'.join(out)+'\n').encode('utf-8'))
    print('展开',len(needed),'个算式与',len(output_fields),'个输出字段')


runtime_helpers="local direction=dofile('mod/GAME/th46/direction.lua')\nlocal heading,vector=direction.heading,direction.vector\nlocal floor=math.floor\nlocal function s(n)return(n+2147483648)%4294967296-2147483648 end\nlocal function high(a,b)\n    local ah,bh=floor(a/65536),floor(b/65536)\n    local al,bl=a%65536,b%65536\n    return ah*bh+floor((ah*bl+al*bh+floor(al*bl/65536))/65536)\nend\nlocal function hi(a,b)return high(s(a),s(b))end\nlocal function uhi(a,b)return high(a%4294967296,b%4294967296)end\nlocal function low(a,b)\n    local al,bl=a%65536,b%65536\n    local cross=(floor((a%4294967296)/65536)*bl+floor((b%4294967296)/65536)*al)%65536\n    return s(cross*65536+al*bl)\nend\nlocal function shr(a,b)return floor(s(a)/2^b)end\nlocal function shl(a,b)return s(a*2^b)end\nlocal function ushr(a,b)return floor((a%4294967296)/2^b)end\nlocal function sw(n)return(n+32768)%65536-32768 end\nlocal band=bit.band\nlocal function swap(n)return s((n%65536)*65536+floor((n%4294967296)/65536))end\nlocal function eq(a,b)return a==b and 1 or 0 end\nlocal function gt(a,b)return s(a)>s(b)and 1 or 0 end\nlocal function ge(a,b)return s(a)>=s(b)and 1 or 0 end\nlocal function ugt(a,b)return a%4294967296>b%4294967296 and 1 or 0 end\nlocal function neg(a)return a<0 and 1 or 0 end\nlocal function select(t,a,b)return t~=0 and a or b end\nlocal function vx(speed,a)local x=vector(speed,a);return s(x)end\nlocal function vy(speed,a)local _,y=vector(speed,a);return s(y)end\nlocal function aim(x,y,px,py,active)return active~=0 and heading(x,y,px,py)or 256 end\nlocal function distance(x,y,tx,ty)\n    local a,b=math.abs(x-tx),math.abs(y-ty)\n    return math.max(a,b)+floor(math.min(a,b)/2)\nend\nlocal function turn(target,current,amount)\n    return(current+math.max(-amount,math.min(amount,(target-current+256)%512-256)))%512\nend\n"

def emit_atlas():
    if not(args.vram and args.atlas and args.art_data):raise ValueError('图集导出需要 --vram、--atlas 和 --art-data')
    import numpy as np
    from PIL import Image
    from analyze import decode_sprite
    pixels=np.memmap(args.vram,dtype='<u4',mode='r',shape=(4096,8192))
    ids=set()
    # 八字节分片表：起始图号、分片数、锚点指针；包含所有朝向，不能只取实战见过的画格。
    first,last=0xc303ebc,0xc307c38
    for at in range(first,last-7,2):
        base,count,anchors=struct.unpack_from('>HHI',sh3.m,at-sh3.base)
        if 1<=base<28000 and 1<=count<=128 and first<=anchors<last-count*2:
            ids.update(range(base,base+count))
    # 关节单片：24 档转动 + 固定盖片、曲线节、躯干孔。见 c14cad0 / c14cf70 的四、五态分支。
    ids.update(range(0x508e,0x50ad));ids.update(range(0x6927,0x692c));ids.update(range(0x6a42,0x6a4c))
    width,x,y,row_height=2048,1,1,0
    rects={};artworks=[]
    for index in sorted(ids):
        record=0xc20bf14+10*index
        page=sh3.read(0xc051854+2*sh3.read(record,'H'),'H')-1
        height,w=sh3.read(record+4,'H'),sh3.read(record+6,'H')
        sx=sh3.read(0xc052420+page,'H')+256-sh3.read(record+3,'B')-w
        sy=sh3.read(0xc052422+page,'H')+sh3.read(record+2,'B')
        art=decode_sprite(pixels,sx,sy,w,height,0x100)
        if art.width+2>width:raise ValueError('关底裁片超过图集宽度')
        if x+art.width+1>width:x=1;y+=row_height+2;row_height=0
        rects[index]=[x,y,art.width,art.height];artworks.append(art)
        x+=art.width+2;row_height=max(row_height,art.height)
    height=2**(y+row_height+1).bit_length()
    if height>8192:raise ValueError('关底图集超过 8192 像素，需拆分纹理')
    sheet=Image.new('RGBA',(width,height))
    for (_,rect),art in zip(rects.items(),artworks):sheet.alpha_composite(art,tuple(rect[:2]))
    args.atlas.parent.mkdir(parents=True,exist_ok=True);sheet.save(args.atlas)
    lines=['-- 全部朝向的原版分片，不以实战轨迹选图；坐标为图集矩形。',
           f'return {{width={width},height={height},sprites={{']
    lines+=['    [%d]={%s},'%(i,','.join(map(str,r)))for i,r in rects.items()]
    lines+=['}}'];args.art_data.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))
    print('图集',len(rects),'片',width,height)

emit_runtime()
if args.vram or args.atlas or args.art_data:emit_atlas()
