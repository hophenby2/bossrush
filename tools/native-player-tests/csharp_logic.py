#!/usr/bin/env python3
"""把原作自机 C# 的语法树转换为 Lua；遇到未支持的节点立即停止。"""
import argparse, ast, hashlib, json, re, sys
from pathlib import Path


class Compiler:
    def __init__(self, source, parser):
        self.source = source
        self.tree = parser.parse(source)
        if self.tree.root_node.has_error:
            raise ValueError('C# 语法树含错误')
        self.classes = {}
        self.known_classes = set()
        self.inherited_methods = set()
        self.method_owners = {}
        self.locals = {}
        self.refs = {}
        self.fields = {}
        self.methods = set()
        self.serial = 0

    def text(self, node):
        return self.source[node.start_byte:node.end_byte].decode()

    def fail(self, node):
        raise ValueError(f'{node.type} 第 {node.start_point.row + 1} 行：{self.text(node)[:180]}')

    def default(self, kind):
        if kind in ('Sincos.Xiaodan_im','Sincos.Renwu'):return 'CS.new('+json.dumps(kind)+')'
        if kind in ('float', 'double', 'int', 'byte', 'long', 'short'): return '0'
        if kind == 'bool': return 'false'
        if kind.endswith('Status') or kind in ('CharacterState','EquipType','Order','ClipMode','SpriteEffects'):return '0'
        if kind in ('Vector2', 'Vector3','Vector4', 'Rectangle', 'Color', 'Colors'): return f'CS.{kind}()'
        return 'nil'

    def args(self, node):
        out=[]
        for n in node.named_children:
            if n.type!='argument':continue
            value=self.expr(n.named_children[-1]) if n.named_children else 'self' if self.text(n)=='this' else self.fail(n)
            if self.text(n).startswith(('out ', 'ref ')):
                value=f'CS.ref(function() return {value} end,function(v) {value}=v end)'
            out.append(value)
        return ','.join(out)

    def kind(self, n):
        if n.type == 'integer_literal': return 'int'
        if n.type == 'real_literal': return 'float'
        if n.type == 'identifier': return self.locals.get(self.text(n), self.fields.get(self.text(n)))
        if n.type in ('this','this_expression','base'):return self.current_class
        if n.type == 'cast_expression': return self.text(n.child_by_field_name('type'))
        if n.type == 'parenthesized_expression': return self.kind(n.named_children[0])
        if n.type == 'object_creation_expression':return self.text(n.child_by_field_name('type'))
        if n.type == 'member_access_expression':
            name=self.text(n.child_by_field_name('name'))
            owner_kind=self.kind(n.child_by_field_name('expression'))
            if owner_kind=='Rectangle' and name in ('X','Y','Width','Height','Top','Bottom','Left','Right'):return 'int'
            if owner_kind in ('Vector2','Vector3','Vector4','PointF') and name in ('X','Y','Z','W','x','y','z','w'):return 'float'
            declared=getattr(self,'class_fields',{}).get(owner_kind,{}).get(name)
            if declared:return declared
            if name in ('position','Position','origin','scale','Scale','SpawnPoint','LanternPos','LanternControlPos','playerPos','deadOrigin','uv','uvSpeed'):return 'Vector2'
            if name in ('rect','deadRect'):return 'Rectangle'
        if n.type == 'member_access_expression' and self.text(n.child_by_field_name('name')) in ('Count', 'Length'): return 'int'
        if n.type=='binary_expression':
            a,b=self.kind(n.child_by_field_name('left')),self.kind(n.child_by_field_name('right'))
            if a==b=='int':return 'int'
            if a in ('int','float','double') and b in ('int','float','double'):return 'float'

    def expr(self, n):
        t = n.type
        if t in ('lambda_expression','anonymous_method_expression'):
            params=n.child_by_field_name('parameters')
            names=[]
            for param in params.named_children if params else []:
                name=self.text(param.child_by_field_name('name'))
                self.locals[name]=self.text(param.child_by_field_name('type'))
                names.append(name)
            body=n.child_by_field_name('body') or next(c for c in n.named_children if c.type=='block')
            return 'function('+','.join(names)+') '+(self.stmt(body) if body.type=='block' else 'return '+self.expr(body))+' end'
        if t in ('identifier','predefined_type'):
            name = self.text(n)
            if name in self.refs:return self.refs[name]
            return 'self.' + name if name not in self.locals and name in self.fields else name
        if t in ('boolean_literal', 'integer_literal'): return self.text(n).lower().rstrip('ul')
        if t == 'real_literal': return 'CS.f(' + re.sub('[fFdDmM]$', '', self.text(n)) + ')'
        if t == 'null_literal': return 'nil'
        if t in ('this_expression','this','base'): return 'self'
        if t in ('string_literal','character_literal'): return json.dumps(ast.literal_eval(self.text(n)), ensure_ascii=False)
        if t == 'typeof_expression':return json.dumps(self.text(n.named_children[0]))
        if t == 'interpolated_string_expression':
            parts=[]
            for v in n.named_children:
                if v.type=='string_content':parts.append(json.dumps(self.text(v)))
                elif v.type=='interpolation':parts.append('tostring('+self.expr(next(c for c in v.named_children if c.type!='interpolation_brace'))+')')
                elif v.type!='interpolation_start':self.fail(v)
            return '('+'..'.join(parts)+')'
        if t == 'parenthesized_expression': return '(' + self.expr(n.named_children[0]) + ')'
        if t == 'member_access_expression':
            owner=n.child_by_field_name('expression')
            if self.text(owner) in ('EquipType','CharacterState','ClipMode','Cname','Difficulty','LanternStatus','SakuraStatus','BreakSource','CharacterCard'):
                return self.text(owner)+'.'+self.text(n.child_by_field_name('name'))
            return self.expr(n.child_by_field_name('expression')) + '.' + self.text(n.child_by_field_name('name')).split('<')[0]
        if t == 'element_access_expression':
            return self.expr(n.named_children[0]) + '[' + self.expr(n.named_children[1].named_children[0].named_children[-1]) + ']'
        if t == 'binary_expression':
            a, b = n.child_by_field_name('left'), n.child_by_field_name('right')
            op = self.text(n.child_by_field_name('operator'))
            x, y = self.expr(a), self.expr(b)
            if op == '%': return f'CS.rem({x},{y})'
            if op == '??': return f'CS.coalesce({x},function() return {y} end)'
            if op == '/' and self.kind(a) == self.kind(b) == 'int': return f'CS.idiv({x},{y})'
            if op in ('&', '|', '^'): return f'CS.bitop({json.dumps(op)},{x},{y})'
            op = {'&&': 'and', '||': 'or', '!=': '~='}.get(op, op)
            return f'({x} {op} {y})'
        if t == 'prefix_unary_expression':
            op = self.text(n.children[0]); value = self.expr(n.named_children[-1])
            if op in ('++','--'):return '(function() '+value+'='+value+('+' if op=='++' else '-')+'1;return '+value+' end)()'
            if op == '!': return '(not ' + value + ')'
            if op in ('-', '+'): return '(' + (op if op == '-' else '') + value + ')'
        if t=='postfix_unary_expression':
            value=self.expr(n.named_children[0]);op='+' if '++' in self.text(n) else '-'
            return '(function() local old='+value+';'+value+'='+value+op+'1;return old end)()'
        if t == 'cast_expression':
            kind = self.text(n.child_by_field_name('type')); value = self.expr(n.child_by_field_name('value'))
            if kind in ('float', 'int', 'byte'): return f'CS.{dict(float="f", int="trunc", byte="byte")[kind]}({value})'
            return value
        if t == 'conditional_expression':
            c, a, b = n.named_children
            return f'CS.choose({self.expr(c)},function() return {self.expr(a)} end,function() return {self.expr(b)} end)'
        if t == 'invocation_expression':
            fn = n.child_by_field_name('function'); args = self.args(n.child_by_field_name('arguments'))
            generic=fn if fn.type=='generic_name' else fn.child_by_field_name('name') if fn.type=='member_access_expression' else None
            if generic and generic.type=='generic_name' and self.text(generic).split('<')[0] in ('GetComponent','GetComponents','AddComponent'):
                method=self.text(generic).split('<')[0]
                kind=self.text(generic).split('<',1)[1].rsplit('>',1)[0]
                receiver=self.expr(fn.child_by_field_name('expression')) if fn.type=='member_access_expression' else 'self'
                return f'CS.invoke({receiver},{json.dumps(method)},{json.dumps(kind)}{"," if args else ""}{args})'
            if fn.type in ('identifier', 'generic_name'):
                name = self.text(fn).split('<')[0]
                if name=='MemberwiseClone':return 'CS.copy(self)'
                if name in self.methods:
                    owner=self.method_owners[name]
                    return f'{owner}.{name}(self{"," if args else ""}{args})'
                return f'{name}({args})'
            if fn.type == 'member_access_expression':
                owner = fn.child_by_field_name('expression'); method = self.text(fn.child_by_field_name('name')).split('<')[0]
                receiver = self.expr(owner)
                if receiver in self.known_classes:
                    instance=receiver if receiver=='TempArray' else 'self'
                    return f'{receiver}.{method}({instance}{"," if args else ""}{args})'
                return f'CS.invoke({receiver},{json.dumps(method)}{"," if args else ""}{args})'
            if fn.type == 'conditional_access_expression':
                owner,access=fn.named_children
                method=self.text(access.named_children[0])
                return f'CS.optionalCall({self.expr(owner)},{json.dumps(method)}{"," if args else ""}{args})'
        if t == 'object_creation_expression':
            kind = self.text(n.child_by_field_name('type')).split('<')[0]
            argnode = n.child_by_field_name('arguments'); args = self.args(argnode) if argnode else ''
            initializer = n.child_by_field_name('initializer')
            if kind in ('List', 'Dictionary'):
                values = self.expr(initializer) if initializer else '{}'
                return f'CS.{kind}({values})'
            value=f'CS.new({json.dumps(kind)}{"," if args else ""}{args})'
            if initializer:
                fields=[]
                for child in initializer.named_children:
                    if child.type!='assignment_expression':self.fail(child)
                    fields.append('['+json.dumps(self.text(child.child_by_field_name('left')))+']='+self.expr(child.child_by_field_name('right')))
                value='CS.initialize('+value+',{'+','.join(fields)+'})'
            return value
        if t == 'default_expression': return self.default(self.text(n.named_children[0]))
        if t == 'declaration_expression':
            kind=n.child_by_field_name('type')
            # tree-sitter 会将参数中的 a.b * C 误判为指针声明；它仍是乘法表达式。
            if kind.type=='pointer_type':
                lhs=kind.child_by_field_name('type')
                parts=self.text(lhs).split('.')
                root='self.'+parts[0] if parts[0] in self.fields and parts[0] not in self.locals else parts[0]
                return '('+root+''.join('.'+p for p in parts[1:])+' * '+self.expr(n.child_by_field_name('name'))+')'
            return self.expr(n.child_by_field_name('name'))
        if t == 'as_expression': return f'CS.as({self.expr(n.named_children[0])},{json.dumps(self.text(n.named_children[-1]))})'
        if t == 'is_pattern_expression': return f'CS.is({self.expr(n.named_children[0])},{json.dumps(self.text(n.named_children[-1]))})'
        if t == 'initializer_expression':
            return '{' + ','.join(f'[{i}]={self.expr(v)}' for i, v in enumerate(n.named_children)) + '}'
        if t == 'array_creation_expression':
            typ = n.child_by_field_name('type')
            init = n.child_by_field_name('initializer') or next((v for v in n.named_children if v.type=='initializer_expression'),None)
            if init: return f'CS.arrayValues({self.expr(init)})'
            rank = next(v for v in typ.named_children if v.type == 'array_rank_specifier')
            length = self.expr(rank.named_children[0])
            return f'CS.array({length},function() return {self.default(self.text(typ.named_children[0]))} end)'
        if t == 'conditional_access_expression':
            owner, access = n.named_children
            if access.type == 'member_binding_expression':
                return f'CS.optional({self.expr(owner)},{json.dumps(self.text(access.named_children[0]))})'
        if t == 'assignment_expression':
            # C# 连续赋值的值是右值；用闭包保留副作用和作用域。
            return f'(function() {self.assignment(n)};return {self.expr(n.child_by_field_name("left"))} end)()'
        self.fail(n)

    def assignment(self, n):
        left, right = n.child_by_field_name('left'), n.child_by_field_name('right')
        target, value = self.expr(left), self.expr(right)
        op = self.text(n.child_by_field_name('operator'))
        if op != '=': value = f'({target} {op[:-1]} {value})'
        kind = self.kind(left)
        if kind == 'float': value = 'CS.f(' + value + ')'
        if kind in ('Vector2', 'Vector3', 'Rectangle') or self.kind(right) in ('Vector2','Vector3','Rectangle'): value = 'CS.copy(' + value + ')'
        return target + '=' + value

    def declaration(self, n):
        kind = self.text(n.child_by_field_name('type'))
        out = []
        for v in n.named_children:
            if v.type != 'variable_declarator': continue
            name = self.text(v.child_by_field_name('name'))
            value = v.named_children[-1] if len(v.named_children) > 1 else None
            if kind.startswith('ref '):
                self.refs[name]=self.expr(value.named_children[0]);continue
            self.locals[name] = kind
            text = self.expr(value) if value else self.default(kind)
            if kind in ('Vector2', 'Vector3', 'Rectangle'): text = 'CS.copy(' + text + ')'
            out.append('local ' + name + '=' + text)
        return '\n'.join(out)

    def stmt(self, n, switch=False, loop=None):
        t = n.type
        if t in ('comment', 'empty_statement'): return ''
        if t == 'block': return '\n'.join(self.stmt(c, switch, loop) for c in n.named_children)
        if t == 'local_declaration_statement': return self.declaration(n.named_children[0])
        if t == 'expression_statement':
            v = n.named_children[0]
            if v.type == 'assignment_expression': return self.assignment(v)
            if v.type in ('postfix_unary_expression', 'prefix_unary_expression'):
                name = self.expr(v.named_children[0]); op = '+' if '++' in self.text(v) else '-'
                return f'{name}={name}{op}1'
            return self.expr(v)
        if t == 'if_statement':
            cond = self.expr(n.child_by_field_name('condition'))
            yes = self.stmt(n.child_by_field_name('consequence'), switch, loop)
            no = n.child_by_field_name('alternative')
            return 'if '+cond+' then\n'+yes+('\nelse\n'+self.stmt(no, switch, loop) if no else '')+'\nend'
        if t == 'return_statement': return 'do return '+(self.expr(n.named_children[0]) if n.named_children else '')+' end'
        if t == 'break_statement': return 'break' if switch else ('__break'+str(loop)+'=true;break' if loop is not None else 'break')
        if t == 'continue_statement': return '__continue'+str(loop)+'=true;break' if loop is not None else self.fail(n)
        if t == 'while_statement':
            self.serial+=1;index=self.serial
            return f'while {self.expr(n.child_by_field_name("condition"))} do\nlocal __break{index},__continue{index}=false,false\nrepeat\n{self.stmt(n.child_by_field_name("body"),False,index)}\nuntil true\nif __break{index} then break end\nend'
        if t == 'for_statement':
            self.serial += 1; index = self.serial
            init = n.child_by_field_name('initializer'); cond = n.child_by_field_name('condition'); update = n.child_by_field_name('update')
            initial = self.declaration(init) if init.type == 'variable_declaration' else self.stmt(init)
            if update.type in ('postfix_unary_expression', 'prefix_unary_expression'):
                target = self.expr(update.named_children[0]); inc = f'{target}={target}'+('+' if '++' in self.text(update) else '-')+'1'
            elif update.type == 'assignment_expression': inc = self.assignment(update)
            else: self.fail(update)
            body = self.stmt(n.child_by_field_name('body'), False, index)
            return f'do\n{initial}\nwhile {self.expr(cond)} do\nlocal __break{index},__continue{index}=false,false\nrepeat\n{body}\nuntil true\nif __break{index} then break end\n{inc}\nend\nend'
        if t == 'foreach_statement':
            name = self.text(n.child_by_field_name('left')); self.locals[name] = self.text(n.child_by_field_name('type'))
            self.serial += 1; index = self.serial
            return f'for _,{name} in CS.each({self.expr(n.child_by_field_name("right"))}) do\nlocal __break{index},__continue{index}=false,false\nrepeat\n{self.stmt(n.child_by_field_name("body"),False,index)}\nuntil true\nif __break{index} then break end\nend'
        if t == 'switch_statement':
            self.serial += 1; key = '__switch'+str(self.serial)
            out = ['do local '+key+'='+self.expr(n.child_by_field_name('value')),'repeat']
            labels=[];index=0
            for section in n.child_by_field_name('body').named_children:
                labels.extend(v for v in section.named_children if v.type == 'constant_pattern')
                statements=[v for v in section.named_children if v.type not in ('constant_pattern','comment')]
                if not statements:continue
                condition = ' or '.join(key+'=='+self.expr(v.named_children[0]) for v in labels) or 'true'
                out.append(('if ' if index == 0 else 'elseif ')+condition+' then');index+=1
                out.extend(self.stmt(v,True,loop) for v in statements);labels=[]
            return '\n'.join(out)+'\nend\nuntil true\nend'+ ('\nif __continue'+str(loop)+' then break end' if loop is not None else '')
        self.fail(n)

    def collect(self, node):
        if node.type == 'class_declaration':
            name = self.text(node.child_by_field_name('name'))
            self.classes[name] = node
        for c in node.named_children: self.collect(c)

    def compile(self, inherited=None):
        self.collect(self.tree.root_node)
        self.known_classes.update(self.classes)
        out = []; main_fields=None
        for name, node in self.classes.items():
            self.current_class=name
            self.fields = dict(inherited or {})
            body = node.child_by_field_name('body')
            methods = [v for v in body.named_children if v.type in ('method_declaration', 'constructor_declaration')]
            if getattr(self,'method_filter',None):methods=[v for v in methods if self.text(v.child_by_field_name('name')) in self.method_filter or self.text(v.child_by_field_name('name'))+'@'+str(len(v.child_by_field_name('parameters').named_children)) in self.method_filter]
            self.methods = {self.text(v.child_by_field_name('name')) for v in methods}
            for method in self.methods:self.method_owners[method]=name
            self.methods.update(self.inherited_methods)
            fieldnodes = [v.named_children[-1] for v in body.named_children if v.type == 'field_declaration']
            for d in fieldnodes:
                for v in d.named_children:
                    if v.type == 'variable_declarator': self.fields[self.text(v.child_by_field_name('name'))] = self.text(d.child_by_field_name('type'))
            for prop in (v for v in body.named_children if v.type=='property_declaration'):
                self.fields[self.text(prop.child_by_field_name('name'))]=self.text(prop.child_by_field_name('type'))
            if main_fields is None:main_fields=dict(self.fields)
            out.append(name+'={__get={},__set={}}\n'+name+'.__index=function(o,k) local getter='+name+'.__get[k];if getter then return getter(o) end;return '+name+'[k] end\n'+name+'.__newindex=function(o,k,v) local setter='+name+'.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end')
            base=next((v for v in node.named_children if v.type=='base_list'),None)
            if base:out.append(name+'.__base='+json.dumps(self.text(base.named_children[0]).split('<')[0]))
            for enum in (v for v in body.named_children if v.type=='enum_declaration'):
                enum_name=self.text(enum.child_by_field_name('name'));members=enum.child_by_field_name('body').named_children
                out.append(name+'.'+enum_name+'={'+','.join(self.text(v.child_by_field_name('name'))+'='+str(i) for i,v in enumerate(members))+'}')
            for prop in (v for v in body.named_children if v.type=='property_declaration'):
                arrow=next((v for v in prop.named_children if v.type=='arrow_expression_clause'),None)
                if arrow:
                    self.locals={}
                    out.append('function '+name+'.__get.'+self.text(prop.child_by_field_name('name'))+'(self) return '+self.expr(arrow.named_children[0])+' end')
                else:
                    for accessor in prop.named_children[-1].named_children:
                        if accessor.type=='accessor_declaration':
                            operation='set' if 'set' in self.text(accessor).split('{')[0].split() else 'get'
                            field=self.text(prop.child_by_field_name('name'))
                            block=accessor.child_by_field_name('body')
                            if block:
                                self.locals={'value':self.text(prop.child_by_field_name('type'))}
                                out.append('function '+name+'.__'+operation+'.'+field+'(self'+(',value' if operation=='set' else '')+') '+self.stmt(block)+' end')
                            elif operation=='get':out.append('function '+name+'.__get.'+field+'(self) return self.__prop_'+field+' end')
                            else:out.append('function '+name+'.__set.'+field+'(self,value) self.__prop_'+field+'=value end')
            overloads={}
            for m in methods:
                key='ctor' if m.type=='constructor_declaration' else self.text(m.child_by_field_name('name'))
                overloads.setdefault(key,[]).append(m)
            for m in methods:
                method = 'ctor' if m.type == 'constructor_declaration' else self.text(m.child_by_field_name('name'))
                if len(overloads[method])>1:method+='_'+str(len(m.child_by_field_name('parameters').named_children))
                params = m.child_by_field_name('parameters').named_children
                self.locals = {self.text(p.child_by_field_name('name')): self.text(p.child_by_field_name('type')) for p in params if p.type == 'parameter'}
                self.refs={}
                names = list(self.locals)
                declarations=[]
                parameter_list=m.child_by_field_name('parameters')
                variadic=parameter_list.child_by_field_name('name')
                if variadic:
                    pname=self.text(variadic);self.locals[pname]=self.text(parameter_list.child_by_field_name('type'))
                    names.append('...');declarations.append('local '+pname+'=CS.params(...)')
                for param in params:
                    if param.type=='parameter' and self.text(param).startswith('params '):
                        pname=self.text(param.child_by_field_name('name'))
                        names[names.index(pname)]='...';declarations.append('local '+pname+'=CS.params(...)')
                    elif param.type=='parameter' and '=' in self.text(param):
                        pname=self.text(param.child_by_field_name('name'))
                        value=param.named_children[-1]
                        declarations.append('if '+pname+'==nil then '+pname+'='+self.expr(value)+' end')
                def scan(v):
                    if v.type=='declaration_expression' and v.child_by_field_name('type').type!='pointer_type':
                        key=self.text(v.child_by_field_name('name'));self.locals[key]=self.text(v.child_by_field_name('type'));declarations.append('local '+key)
                    for c in v.named_children:scan(c)
                scan(m.child_by_field_name('body'))
                out.append('function '+name+':'+method+'('+','.join(names)+')\n'+'\n'.join(declarations)+'\n'+self.stmt(m.child_by_field_name('body'))+'\nend')
            for method,variants in overloads.items():
                if len(variants)>1:
                    arities=[len(v.child_by_field_name('parameters').named_children) for v in variants]
                    if len(set(arities))!=len(arities):raise ValueError('需要按类型区分重载：'+name+'.'+method)
                    branches=[]
                    for i,(arity,v) in enumerate(zip(arities,variants)):
                        required=sum(1 for p in v.child_by_field_name('parameters').named_children if p.type=='parameter' and '=' not in self.text(p))
                        condition='n=='+str(arity) if required==arity else '(n>='+str(required)+' and n<='+str(arity)+')'
                        branches.append(('if' if i==0 else 'elseif')+' '+condition+' then return '+name+'.'+method+'_'+str(arity)+'(self,...)')
                    out.append('function '+name+':'+method+'(...) local n=select("#",...);'+';'.join(branches)+' end;error("原作方法参数数目不符：'+name+'.'+method+'") end')
            self.locals = {}
            out.append('function '+name+'.defaults(self)')
            for d in fieldnodes:
                kind = self.text(d.child_by_field_name('type'))
                for v in d.named_children:
                    if v.type != 'variable_declarator': continue
                    key = self.text(v.child_by_field_name('name'))
                    value = self.expr(v.named_children[-1]) if len(v.named_children) > 1 else self.default(kind)
                    out.append('self.'+key+'='+value)
            out.append('end')
            if name=='TempArray':out.append(name+'.defaults('+name+')')
        return '\n'.join(out), main_fields


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--parser-lib', type=Path)
    ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--methods',help='仅导出列出的原始方法，逗号分隔')
    ap.add_argument('sources', nargs='+', type=Path)
    args = ap.parse_args()
    if args.parser_lib: sys.path.insert(0, str(args.parser_lib))
    import tree_sitter, tree_sitter_c_sharp
    parser = tree_sitter.Parser(tree_sitter.Language(tree_sitter_c_sharp.language()))
    out = ['-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。', 'return function(CS)', 'local _ENV=setmetatable({CS=CS},{__index=CS.env})', 'setfenv(1,_ENV)']
    fields = {}; known_classes=set(); known_methods=set(); method_owners={};class_fields={}
    for path in args.sources:
        probe=Compiler(path.read_bytes(),parser);probe.collect(probe.tree.root_node)
        for name,node in probe.classes.items():
            members={};body=node.child_by_field_name('body')
            for field in (v.named_children[-1] for v in body.named_children if v.type=='field_declaration'):
                for v in field.named_children:
                    if v.type=='variable_declarator':members[probe.text(v.child_by_field_name('name'))]=probe.text(field.child_by_field_name('type'))
            for prop in (v for v in body.named_children if v.type=='property_declaration'):members[probe.text(prop.child_by_field_name('name'))]=probe.text(prop.child_by_field_name('type'))
            class_fields[name]=members
    for path in args.sources:
        raw = path.read_bytes(); compiler = Compiler(raw, parser)
        compiler.class_fields=class_fields
        compiler.method_filter=set(args.methods.split(',')) if args.methods else None
        compiler.known_classes.update(known_classes)
        compiler.inherited_methods.update(known_methods)
        compiler.method_owners.update(method_owners)
        code, fields = compiler.compile(fields)
        known_classes.update(compiler.classes)
        for c in compiler.classes.values():
            known_methods.update(compiler.text(v.child_by_field_name('name')) for v in c.child_by_field_name('body').named_children if v.type=='method_declaration')
            method_owners.update({compiler.text(v.child_by_field_name('name')):compiler.text(c.child_by_field_name('name')) for v in c.child_by_field_name('body').named_children if v.type=='method_declaration'})
        out.extend(['-- '+path.name+' SHA256 '+hashlib.sha256(raw).hexdigest(), code])
    out.append('return _ENV\nend')
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text('\n'.join(out)+'\n')


if __name__ == '__main__': main()
