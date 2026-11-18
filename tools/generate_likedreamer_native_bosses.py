#!/usr/bin/env python3
"""将本地复原源码的 Boss 状态机转换成普通 Lua 函数；游戏运行时无需 C++ 或解释器。"""
import argparse
import json
from pathlib import Path
import re
import subprocess
import tempfile
from check_likedreamer_parity import extract_function

PROJECT = Path(__file__).resolve().parent.parent
DEST = PROJECT / 'mod/GAME/ports/dreamer/LikeDreamer/recovered'
UNITS = {
 'early': ('stage_runtime.cpp', ['updateStage02BossChild','emitStage02BossChildProjectiles','updateStage03Type34','updateStage04BossChild','updateStage04Type40','updateStage04Type41','updateStage04Type42Or43','spawnDelayedOwnerDamageNode','updateStage03DeathNode']),
 'guard': ('stage_runtime_scene10.cpp', ['isStage10GuardNodeType','maybeSpawnStage10GuardNode','updateStage10GuardNode','isSharedHitboxProxyType','spawnSharedHitboxProxy','updateSharedHitboxProxy']),
 'boss08': ('stage_runtime_boss08.cpp', ['isStage08BossNodeType','spawnStage08BossNode','emitStage08BossProjectiles','updateStage08BossNode','updateStage08Boss']),
 'boss09': ('stage_runtime_boss09.cpp', ['isStage09BossNodeType','spawnStage09BossNode','emitStage09BossProjectiles','updateStage09BossNode','updateStage09Boss']),
 'boss07': ('stage_runtime_boss07.cpp', ['isStage07BossNodeType','spawnStage07BossNode','updateStage07Boss','updateStage07BossNode']),
 'late': ('stage_runtime_late.cpp', ['isStage10FinalBossNodeType','clearLateStageGate','spawnStage05BossChild','emitStage05BossProjectiles','updateStage05BossChild','updateStage05Boss','spawnStage06BossNode','updateStage06BossNode','updateStage06Boss','spawnStage10FinalBossNode','updateStage10FinalBossNode','updateLateStageBoss','emitRecoveredFinalRootPattern']),
 'boss10_aux': ('stage_runtime_boss10_aux.cpp', ['isStage10FinalBossEmitterType','spawnStage10FinalBossEmitter','updateStage10FinalBossEmitter']),
}
RESERVED = {'and','break','do','else','elseif','end','false','for','function','goto','if','in','local','nil','not','or','repeat','return','then','true','until','while'}
def ident(name): return 'v_'+name if name in RESERVED else name

def children(n): return n.get('inner', [])
def typ(n):
 t=n.get('type',{});return t.get('desugaredQualType',t.get('qualType','')).replace('const ','').replace('std::uint16_t','unsigned short').replace('std::uint32_t','unsigned int').replace('std::int16_t','short').replace('std::size_t','unsigned long').strip()
def walk(n):
 yield n
 for c in children(n): yield from walk(c)
def unwrap(n):
 while n.get('kind') in ('ImplicitCastExpr','ParenExpr','ExprWithCleanups','MaterializeTemporaryExpr','CXXBindTemporaryExpr','FullExpr','ConstantExpr') and children(n): n=children(n)[0]
 return n

class Lua:
 def __init__(self, tree, unit):
  self.tree,self.unit=tree,unit
  self.nodes={n['id']:n for root in tree for n in walk(root) if 'id'in n}
  self.structs={n.get('name'):[c.get('name')for c in children(n)if c.get('kind')=='FieldDecl']for root in tree for n in walk(root)if n.get('kind')=='CXXRecordDecl'and n.get('completeDefinition')}
  self.breaks=[];self.continues=[];self.serial=0
  self.refs={n['id']:ident(n['name'])for root in tree for n in walk(root)if n.get('kind')=='VarDecl'and typ(n).rstrip('& ').strip()in('int','float','double','unsigned short','unsigned int','bool')and typ(n).endswith('&')}
 def fresh(self,prefix): self.serial+=1;return '__'+prefix+str(self.serial)
 def cast(self,value,target,source=''):
  if target.endswith('&') or target.endswith('*'):return value
  if source=='bool'and target!='bool':value='('+value+' and 1 or 0)';source='int'
  if target=='float':return 'f32('+value+')'
  if target=='bool':
   if source=='bool':return value
   return '('+value+' ~= nil)' if source.endswith('*') else '('+value+' ~= 0)'
  if target in ('unsigned short','uint16_t','std::uint16_t'):return '('+value+' % 65536)'
  if target in ('short','short int'):return 's16('+value+')'
  if target in ('unsigned int','std::uint32_t'):return 'u32('+value+')'
  if target in ('int','long','long long','unsigned long','unsigned long long') and source in ('float','double','long double'):return 'trunc('+value+')'
  if target in ('int','unsigned int')and source=='bool':return '('+value+' and 1 or 0)'
  return value
 def fail(self,n):raise ValueError(self.unit+' '+n.get('kind','?')+' '+str(n.get('range',{}))+': '+str(n)[:400])
 def init(self,n):
  t=typ(n);ch=children(n)
  if 'std::array<'in t:
   if len(ch)==1 and ('['in typ(ch[0])or ch[0].get('kind')=='InitListExpr'):return self.init(ch[0])
  key=t.replace('reconstructed::StageRuntime::','').replace('reconstructed::(anonymous namespace)::','').replace('reconstructed::','')
  if key in self.structs and not t.startswith('std::'):
   return '{'+', '.join(ident(k)+' = '+self.expr(v)for k,v in zip(self.structs[key],ch))+'}'
  if n.get('kind')=='ImplicitValueInitExpr':return '{}'
  return '{'+', '.join(self.expr(x)for x in ch)+'}'
 def default_arg(self,callee,index):
  c=unwrap(callee);rid=c.get('referencedDecl',{}).get('id')or c.get('referencedMemberDecl')
  d=self.nodes.get(rid,{})
  pars=[x for x in children(d)if x.get('kind')=='ParmVarDecl']
  if index<len(pars) and children(pars[index]):return self.expr(children(pars[index])[-1])
  self.fail({'kind':'MissingDefault','range':{},'callee':callee,'index':index})
 def args(self,args,callee,shift=0):return [self.default_arg(callee,i-shift)if a.get('kind')=='CXXDefaultArgExpr'else self.expr(a)for i,a in enumerate(args)]
 def reference(self,n):
  n=unwrap(n);ch=children(n)
  if n.get('kind')=='ConditionalOperator':return '(function() if '+self.expr(ch[0])+' then return '+self.reference(ch[1])+' else return '+self.reference(ch[2])+' end end)()'
  ref=self.ref_target(n)
  if ref:return ref
  lhs=self.expr(n)
  return 'cpp.ref(function() return '+lhs+' end, function(value) '+lhs+' = value end)'
 def ref_target(self,n):
  if n.get('kind')=='DeclRefExpr'and n['referencedDecl']['id']in self.refs:return self.refs[n['referencedDecl']['id']]
  if n.get('kind')=='UnaryOperator'and n.get('opcode')=='*':return self.expr(children(n)[0])
  return None

 def expr(self,n):
  k=n.get('kind');ch=children(n);t=typ(n)
  if k=='IntegerLiteral':return n['value']
  if k=='FloatingLiteral':return 'f32('+n['value']+')'if t=='float'else n['value']
  if k=='CXXBoolLiteralExpr':return 'true'if n['value']else'false'
  if k in ('CXXNullPtrLiteralExpr','GNUNullExpr'):return 'nil'
  # Clang 的 value 包含 C++ 字符串两端的引号；先解码再输出 Lua 字符串。
  if k=='StringLiteral':return json.dumps(json.loads(n['value']),ensure_ascii=False)
  if k=='CharacterLiteral':return str(n['value'])
  if k=='CXXThisExpr':return 'ctx'
  if k=='DeclRefExpr':
   name=ident(n['referencedDecl']['name'])
   return 'cpp.get('+name+')'if n['referencedDecl']['id']in self.refs else name
  if k=='MemberExpr':
   if n['name']in('first','second')and 'std::pair<'in typ(ch[0]):return '('+self.expr(ch[0])+')['+('1'if n['name']=='first'else'2')+']'
   return '('+self.expr(ch[0])+').'+ident(n['name'])
  if k in ('ParenExpr','ExprWithCleanups','MaterializeTemporaryExpr','CXXBindTemporaryExpr','FullExpr','SubstNonTypeTemplateParmExpr'):
   return self.expr(ch[-1])
  if k=='ConstantExpr':return self.expr(ch[0])if ch else str(n['value'])
  if k in ('ImplicitCastExpr','CXXStaticCastExpr','CStyleCastExpr','CXXFunctionalCastExpr'):
   value=self.expr(ch[0]);cast=n.get('castKind')
   if cast in ('LValueToRValue','FunctionToPointerDecay','ArrayToPointerDecay','NoOp','NullToPointer','ConstructorConversion'):return value
   if cast in ('IntegralToBoolean','FloatingToBoolean','PointerToBoolean'):return self.cast(value,'bool',typ(ch[0]))
   return self.cast(value,t,typ(ch[0]))
  if k=='CXXScalarValueInitExpr':return 'false'if t=='bool'else'0'
  if k in ('InitListExpr','ImplicitValueInitExpr'):return self.init(n)
  if k=='CXXStdInitializerListExpr':return self.expr(ch[0])
  if k in ('CXXConstructExpr','CXXTemporaryObjectExpr'):
   if 'StageEnemy'in t:return 'cpp.newEnemy()'
   if '(lambda at 'in t:return self.expr(ch[0])
   if 'basic_string'in t:return self.expr(ch[0])if ch else'""'
   return '{'+', '.join(self.expr(x)for x in ch if x.get('kind')!='CXXDefaultArgExpr')+'}'if ch else'{}'
  if k=='ArraySubscriptExpr':return '('+self.expr(ch[0])+')['+self.expr(ch[1])+' + 1]'
  if k in ('BinaryOperator','CompoundAssignOperator'):
   op=n['opcode'];a,b=map(self.expr,ch)
   if op=='=':
    v=self.cast(b,typ(ch[0]),typ(ch[1]))
    if self.ref_target(ch[0]):return 'cpp.set('+self.ref_target(ch[0])+', '+v+')'
    return '(function() '+a+' = '+v+'; return '+a+' end)()'
   if k=='CompoundAssignOperator':
    lhs=a
    a='('+a+' and 1 or 0)'if typ(ch[0])=='bool'else a
    b='('+b+' and 1 or 0)'if typ(ch[1])=='bool'else b
    value=self.binary(op[:-1],a,b,n.get('computeResultType',n.get('type',{})).get('qualType',t),typ(ch[0]))
    v=self.cast(value,typ(ch[0]),n.get('computeResultType',{}).get('qualType',''))
    if self.ref_target(ch[0]):return 'cpp.set('+self.ref_target(ch[0])+', '+v+')'
    return '(function() '+lhs+' = '+v+'; return '+lhs+' end)()'
   if op==',':return '(function() local __ignored = '+a+'; return '+b+' end)()'
   return self.binary(op,a,b,t,typ(ch[0]))
  if k=='UnaryOperator':
   op=n['opcode'];v=self.expr(ch[0])
   if op=='!':return '(not '+v+')'
   if op=='&':
    if typ(ch[0])in('int','float','double','unsigned short','unsigned int','bool'):return 'cpp.ref(function() return '+v+' end, function(value) '+v+' = value end)'
    return v
   if op=='*':return 'cpp.get('+v+')'if t in('int','float','double','unsigned short','unsigned int','bool')else v
   if op=='+':return v
   if op=='-':return self.cast('(-'+v+')',t,t)
   if op=='~':return 'bit.bnot('+v+')'
   if op in ('++','--'):
    expression=v+(' + 1'if op=='++'else' - 1');assign=v+' = '+self.cast(expression,t,t)
    return '(function() local __old = '+v+'; '+assign+'; return '+('__old'if n.get('isPostfix')else v)+' end)()'
   self.fail(n)
  if k in ('ConditionalOperator','BinaryConditionalOperator'):
   return '(function() if '+self.expr(ch[0])+' then return '+self.expr(ch[-2])+' else return '+self.expr(ch[-1])+' end end)()'
  if k=='LambdaExpr':
   record=next(x for x in ch if x.get('kind')=='CXXRecordDecl')
   method=next(x for x in children(record)if x.get('kind')=='CXXMethodDecl'and x.get('name')=='operator()')
   return self.function(method,False)
  if k=='CXXOperatorCallExpr':
   op=unwrap(ch[0]).get('referencedDecl',{}).get('name');args=ch[1:]
   if op=='operator()':return '('+self.expr(args[0])+')('+', '.join(self.args(args[1:],ch[0]))+')'
   if op=='operator[]':return '('+self.expr(args[0])+')['+self.expr(args[1])+' + 1]'
   if op=='operator=':
    a,b=map(self.expr,args);return '(function() '+a+' = '+b+'; return '+a+' end)()'
   self.fail(n)
  if k=='CXXMemberCallExpr':
   m=ch[0];base=self.expr(children(m)[0]);name=m['name'];args=self.args(ch[1:],m)
   if name in ('begin','end'):return base
   if name in ('size','empty'):return '(#'+base+(' == 0)'if name=='empty'else')')
   if name=='push_back':return 'cpp.push('+base+', '+args[0]+')'
   if name=='back':return '('+base+')[#'+base+']'
   if name=='clear':return 'cpp.clear('+base+')'
   return base+':'+ident(name)+'('+', '.join(args)+')'
  if k=='CallExpr':
   c=unwrap(ch[0]);name=c.get('referencedDecl',{}).get('name');args=self.args(ch[1:],ch[0])
   std={'sin':'math.sin','cos':'math.cos','atan2':'math.atan2','sqrt':'math.sqrt','hypot':'cpp.hypot','abs':'math.abs','fmod':'math.fmod','min':'math.min','max':'math.max','clamp':'cpp.clamp','lround':'cpp.lround','round':'cpp.lround','pow':'math.pow','floor':'math.floor','ceil':'math.ceil'}
   if name in ('count_if','any_of'):return 'cpp.'+name+'('+', '.join(args)+')'
   if name=='move'and c.get('referencedDecl',{}).get('kind')!='VarDecl':return args[0]
   if name in ('PlaySoundMem','StopSoundMem','ChangeVolumeSoundMem'):return 'ctx:audio('+json.dumps(name)+(', '+', '.join(args)if args else'')+')'
   if name not in std and name not in self.helperNames and c.get('referencedDecl',{}).get('kind')!='VarDecl':raise ValueError('未绑定的原版函数：'+str(name))
   return std.get(name,self.expr(ch[0]))+'('+', '.join(args)+')'
  if k=='CXXDefaultArgExpr':self.fail(n)
  self.fail(n)
 def binary(self,op,a,b,t,left_type):
  if op in ('&&','||','!=','==','<','>','<=','>='):
   return '('+a+' '+{'&&':'and','||':'or','!=':'~='}.get(op,op)+' '+b+')'
  if op in ('&','|','^','<<','>>'):
   fn={'&':'band','|':'bor','^':'bxor','<<':'lshift','>>':'rshift'if 'unsigned'in left_type else'arshift'}[op]
   return self.cast('bit.'+fn+'('+a+', '+b+')',t,t)
  if op=='%':return 'math.fmod('+a+', '+b+')'
  if op=='/'and t not in ('float','double','long double'):return 'trunc('+a+' / '+b+')'
  if op=='*'and t in ('unsigned int','std::uint32_t'):return 'cpp.mul32('+a+', '+b+')'
  return self.cast('('+a+' '+op+' '+b+')',t,t)
 def function(self,n,method):
  params=[x for x in children(n)if x.get('kind')=='ParmVarDecl']
  body=next(x for x in children(n)if x.get('kind')=='CompoundStmt')
  names=['ctx']if method else[]
  names += [ident(x.get('name','arg'+str(i)))for i,x in enumerate(params)]
  # 参数已由 C++ AST 的调用点转换；模块入口也在此收紧到原类型。
  setup=[]
  for name,param in zip(names[1:]if method else names,params):
   value=self.cast(name,typ(param),typ(param))
   if value!=name:setup.append(name+' = '+value)
  oldbreaks,oldcontinues=self.breaks,self.continues;self.breaks,self.continues=[],[]
  result='function('+', '.join(names)+')\n'+self.indent(';\n'.join(setup+[self.block(body)]))+'\nend'
  self.breaks,self.continues=oldbreaks,oldcontinues
  return result
 def indent(self,s):return '\n'.join('    '+x if x else''for x in s.splitlines())
 def block(self,n):return ';\n'.join(filter(None,(self.stmt(c)for c in children(n))))
 def stmt(self,n):
  k=n.get('kind');ch=children(n)
  if k=='ExprWithCleanups':return self.stmt(ch[0])
  if not k or k=='NullStmt' or (k=='CStyleCastExpr'and typ(n)=='void'):return ''
  if k=='CompoundStmt':return 'do\n'+self.indent(self.block(n))+'\nend'
  if k=='DeclStmt':return '\n'.join(self.stmt(c)for c in ch)
  if k=='VarDecl':
   if n['id']in self.refs:return 'local '+ident(n['name'])+' = '+self.reference(ch[-1])
   value=self.expr(ch[-1])if ch else('false'if typ(n)=='bool'else'nil'if typ(n).endswith('*')else'0')
   return 'local '+ident(n['name'])+' = '+value
  if k=='DecompositionDecl':
   init=next(x for x in ch if x.get('kind')!='BindingDecl');name=self.fresh('pair');s='local '+name+' = '+self.expr(init)
   for i,c in enumerate(x for x in ch if x.get('kind')=='BindingDecl'):s+='\nlocal '+ident(c['name'])+' = '+name+'['+str(i+1)+']'
   return s
  if k=='IfStmt':
   head=[]
   if n.get('hasInit'):head.append(self.stmt(ch.pop(0)))
   condition=self.expr(ch[0]);then=self.stmt(ch[1]);other='\nelse\n'+self.indent(self.stmt(ch[2]))if len(ch)>2 else''
   result='if '+condition+' then\n'+self.indent(then)+other+'\nend'
   return 'do\n'+self.indent('\n'.join(head+[result]))+'\nend'if head else result
  if k=='ReturnStmt':return 'do return'+(' '+self.expr(ch[0])if ch else'')+' end'
  if k=='BreakStmt':return 'goto '+self.breaks[-1]
  if k=='ContinueStmt':return 'goto '+self.continues[-1]
  if k in ('ForStmt','WhileStmt','DoStmt','CXXForRangeStmt'):
   end,cont=self.fresh('loop_end'),self.fresh('continue');self.breaks.append(end);self.continues.append(cont)
   if k=='ForStmt':
    init,condvar,cond,step,body=ch
    lead=self.stmt(init);cond=self.expr(cond)if cond.get('kind')else'true';step=self.stmt(step)
    code=lead+'\nwhile '+cond+' do\n'+self.indent(self.stmt(body)+'\n::'+cont+'::\n'+step)+'\nend'
   elif k=='CXXForRangeStmt':
    lead=self.stmt(ch[0]);rangevar=children(ch[1])[0];rangevalue=self.expr(children(rangevar)[-1]);binding=children(ch[-2])[0]
    code=lead+'\nfor _, '+ident(binding['name'])+' in ipairs('+rangevalue+') do\n'+self.indent(self.stmt(ch[-1])+'\n::'+cont+'::')+'\nend'
   elif k=='WhileStmt':code='while '+self.expr(ch[0])+' do\n'+self.indent(self.stmt(ch[-1])+'\n::'+cont+'::')+'\nend'
   else:code='repeat\n'+self.indent(self.stmt(ch[0])+'\n::'+cont+'::')+'\nuntil not '+self.expr(ch[-1])
   self.breaks.pop();self.continues.pop();return 'do\n'+self.indent(code+'\n::'+end+'::')+'\nend'
  if k=='SwitchStmt':
   end,value=self.fresh('switch_end'),self.fresh('switch');self.breaks.append(end);groups=[];dispatch=[];default=end
   def flatten(case):
    nonlocal default
    label=self.fresh('case')
    if case['kind']=='CaseStmt':dispatch.append((self.expr(children(case)[0]),label));tail=children(case)[-1]
    else:default=label;tail=children(case)[-1]
    groups.append('::'+label+'::')
    if tail['kind']in('CaseStmt','DefaultStmt'):flatten(tail)
    else:groups.append(self.stmt(tail))
   for c in children(ch[-1]):
    if c['kind']in('CaseStmt','DefaultStmt'):flatten(c)
    else:groups.append(self.stmt(c))
   self.breaks.pop()
   choose='\n'.join(('if'if i==0 else'elseif')+' '+value+' == '+v+' then goto '+label for i,(v,label)in enumerate(dispatch))
   choose+=('\nelse goto '+default+' end')if dispatch else'goto '+default
   return 'do\n'+self.indent('local '+value+' = '+self.expr(ch[0])+'\n'+choose+'\n'+';\n'.join(filter(None,groups))+'\n::'+end+'::')+'\nend'
  if k=='BinaryOperator'and n['opcode']=='=':
   v=self.cast(self.expr(ch[1]),typ(ch[0]),typ(ch[1]))
   if self.ref_target(ch[0]):return 'cpp.set('+self.ref_target(ch[0])+', '+v+')'
   return self.expr(ch[0])+' = '+v
  if k=='CompoundAssignOperator':
   lhs=self.expr(ch[0]);ct=n.get('computeResultType',n.get('type',{})).get('qualType',typ(n))
   a='('+lhs+' and 1 or 0)'if typ(ch[0])=='bool'else lhs
   b=self.expr(ch[1]);b='('+b+' and 1 or 0)'if typ(ch[1])=='bool'else b
   v=self.binary(n['opcode'][:-1],a,b,ct,typ(ch[0]))
   v=self.cast(v,typ(ch[0]),ct)
   if self.ref_target(ch[0]):return 'cpp.set('+self.ref_target(ch[0])+', '+v+')'
   return lhs+' = '+v
  if k=='UnaryOperator'and n['opcode']in('++','--'):
   v=self.expr(ch[0]);return v+' = '+self.cast(v+(' + 1'if n['opcode']=='++'else' - 1'),typ(n),typ(n))
  if k=='CXXOperatorCallExpr'and unwrap(ch[0]).get('referencedDecl',{}).get('name')=='operator=':return self.expr(ch[1])+' = '+self.expr(ch[2])
  return self.expr(n)
 def schemas(self):
  records=[n for root in self.tree for n in walk(root)if n.get('kind')=='CXXRecordDecl'and n.get('name')in('StageRuntime','StageEnemy')and n.get('completeDefinition')]
  out=['-- 原版字段初值；只用于原生 Lua 对象的状态存储。', 'local cpp = assert(LikeDreamer.Recovered)', 'local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16']
  for record in records:
   fields=[]
   for field in children(record):
    if field.get('kind')!='FieldDecl':continue
    t=typ(field)
    if t not in ('bool','int','float','double','unsigned int','unsigned short','const char *','char *')and not t.startswith('std::array<')and not t.startswith('std::vector<'):continue
    if t.startswith('std::vector<'):value='{}'
    elif children(field):
     try:value=self.expr(children(field)[-1])
     except ValueError:continue
    else:value='false'if t=='bool'else'0'
    fields.append(ident(field['name'])+' = '+value)
   out.append(('cpp.enemyDefaults'if record['name']=='StageEnemy'else'cpp.worldDefaults')+' = {\n'+self.indent(',\n'.join(fields))+'\n}')
  return '\n'.join(out)+'\n'

 def export(self,names,prefix_source_offset):
  # AST 同时含头文件；只导出当前恢复单元的匿名辅助函数与指定成员定义。
  namespace=self.tree[-1]
  candidates=[]
  def gather(n,in_anon=False):
   kind=n.get('kind')
   if kind=='NamespaceDecl':
    for c in children(n):gather(c,in_anon or not n.get('name'))
   elif kind=='FunctionDecl'and in_anon and any(c.get('kind')=='CompoundStmt'for c in children(n)):candidates.append(n)
   elif kind=='VarDecl'and in_anon:candidates.append(n)
   elif kind=='CXXMethodDecl'and n.get('name')in names and any(c.get('kind')=='CompoundStmt'for c in children(n)):candidates.append(n)
  gather(namespace)
  functions=[n for n in candidates if n['kind']in('FunctionDecl','CXXMethodDecl')]
  constants=[n for n in candidates if n['kind']=='VarDecl']
  self.helperNames={n['name']for n in functions if n['kind']=='FunctionDecl'}
  out=['-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。',
       '-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。',
       'local cpp = assert(LikeDreamer.Recovered)', 'local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16',
       'local bit = require("bit")', 'local M = {}']
  out.extend(self.stmt(n)for n in constants)
  out.extend('local '+ident(n['name'])for n in functions if n['kind']=='FunctionDecl')
  for n in functions:
   target=('M.'if n['kind']=='CXXMethodDecl'else'')+ident(n['name'])
   out.append(target+' = '+self.function(n,n['kind']=='CXXMethodDecl'))
  out += ['cpp.install(M)', 'return M']
  return '\n\n'.join(out)+'\n'


def compile_unit(reference, directory, name, filename, names):
 source=(reference/filename).read_text()
 prefix=source[source.index('namespace reconstructed {'):source.index('} // namespace')+len('} // namespace')]if filename!='stage_runtime.cpp'else''
 bodies=[]
 for method in names:
  if method=='emitRecoveredFinalRootPattern':
   start=source.index('const auto emitFinalRootPattern =');start=source.index('{',start);end=start+1;depth=1
   while depth:
    depth+=(source[end]=='{')-(source[end]=='}');end+=1
   aim='const auto aimFrom=[this](float x,float y){return radiansToAngle16(std::atan2(static_cast<double>(player_.y-y),static_cast<double>(player_.x-x)));};'
   bodies.append('void StageRuntime::emitRecoveredFinalRootPattern(StageEnemy& enemy){'+aim+source[start+1:end-1]+'}')
  else:bodies.append(extract_function(source,'StageRuntime::'+method))
 body='\n'.join(bodies)

 if filename=='stage_runtime.cpp':
  from audit_likedreamer_bosses import dependencies
  helpers={}
  for original in bodies:helpers.update(dependencies(source,original))
  ordered={};visiting=set()
  def order(key):
   if key in ordered or key in visiting:return
   visiting.add(key)
   for child in re.findall(r'\b([a-zA-Z]\w*)\(',helpers[key])[1:]:
    if child in helpers and child!=key:order(child)
   ordered[key]=helpers[key]
  for key in helpers:order(key)
  used=body+'\n'+'\n'.join(ordered.values());constants=[]
  for definition in re.findall(r'(?m)^constexpr [^;]+;',source):
   match=re.search(r'\b(k\w+)\b',definition)
   if match and match[1]not in('kPi','kTau')and re.search(r'\b'+match[1]+r'\b',used):constants.append(definition)
  # 从原始 PE 的 0x14053a020 读取过的 double 常量，修正复原版的 float 近似。
  prefix='namespace reconstructed { namespace {\nconstexpr double kPi=3.14159265358979;\nconstexpr double kTau=kPi*2.0;\n'+'\n'.join(constants+list(ordered.values()))+'\n} // namespace'
 header=(reference/'stage_runtime.h').read_text().replace('    void updateLateStageBoss(StageEnemy& enemy);','    void emitRecoveredFinalRootPattern(StageEnemy& enemy);\n    void updateLateStageBoss(StageEnemy& enemy);')
 (directory/'stage_runtime.h').write_text(header)
 cpp='#include "'+str(directory/'stage_runtime.h')+'"\n#include <algorithm>\n#include <array>\n#include <cmath>\n#include <cstdint>\n#include <utility>\nextern int PlaySoundMem(...),StopSoundMem(...),ChangeVolumeSoundMem(...);\nconstexpr int DX_PLAYTYPE_LOOP=1,TRUE=1;\n'+prefix+'\n'+body+'\n}\n'
 path=directory/(name+'.cpp');path.write_text(cpp)
 run=subprocess.run(['clang++','-std=c++20','-I',str(reference),'-fsyntax-only','-Xclang','-ast-dump=json','-Xclang','-ast-dump-filter=reconstructed',str(path)],capture_output=True,text=True)
 if run.returncode:raise RuntimeError(run.stderr)
 decoder=json.JSONDecoder();pos=0;trees=[]
 while pos<len(run.stdout):
  while pos<len(run.stdout)and run.stdout[pos].isspace():pos+=1
  if pos<len(run.stdout):node,pos=decoder.raw_decode(run.stdout,pos);trees.append(node)
 generator=Lua(trees,name)
 lua=generator.export(names,0)
 DEST.mkdir(parents=True,exist_ok=True)
 (DEST/'defaults.lua').write_text(generator.schemas())
 DEST.mkdir(parents=True,exist_ok=True);target=DEST/(name+'.lua');target.write_text(lua)
 subprocess.run(['luajit','-b',str(target),str(directory/'syntax.luac')],check=True)
 print(name,len(lua.splitlines()),'行',flush=True)


def main():
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('reference',type=Path);parser.add_argument('--unit',choices=UNITS,action='append');args=parser.parse_args()
 reference=args.reference
 if not (reference/'stage_runtime.h').exists():reference=reference/'reverse/reconstructed/project/src'
 with tempfile.TemporaryDirectory(prefix='likedreamer-native-')as path:
  for name in args.unit or UNITS:
   filename,names=UNITS[name];compile_unit(reference,Path(path),name,filename,names)
if __name__=='__main__':main()
