#!/usr/bin/env python3
"""复用 Sub 已构建的 Release 对象，编译原作网格接口；不改写上游工程或运行游戏。"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import uuid
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
NS='http://schemas.microsoft.com/developer/msbuild/2003'
ET.register_namespace('',NS)
def tag(name): return '{'+NS+'}'+name

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--engine',type=Path,default=ROOT.parent/'LuaSTG-Sub')
    ap.add_argument('--no-install',action='store_true')
    args=ap.parse_args()
    engine=args.engine.resolve()
    version=json.loads((engine/'version.json').read_text(encoding='utf-8'))
    if (version['major'],version['minor'],version['patch'])!=(0,21,129):
        raise RuntimeError('此补丁对应 Sub 0.21.129，请先核对其他版本的接口和对象文件')
    project=engine/'build/amd64/LuaSTG/LuaSTG.vcxproj'
    object_dir=project.parent/'LuaSTG.dir/Release'
    original=engine/'LuaSTG/LuaSTG/LuaBinding/LW_Renderer.cpp'
    header=ROOT/'windows/native/source_model_mesh.hpp'
    output=ROOT/'windows/build/source_mesh'
    output.mkdir(parents=True,exist_ok=True)
    source=original.read_text(encoding='utf-8-sig')
    anchor='namespace luastg {'
    register='\t\tMKFUNC(beginScene),'
    if source.count(anchor)!=1 or source.count(register)!=1:
        raise RuntimeError('Sub 渲染绑定的补丁上下文不匹配')
    source=source.replace(anchor,'#include "'+header.as_posix()+'"\n\n'+anchor,1)
    source=source.replace(register,
        '\t\t{ "CreateSourceModelMesh", &source_mesh::create },\n'
        '\t\t{ "RenderSourceModelMesh", &source_mesh::draw },\n'+register,1)
    patched=output/'LW_Renderer.cpp'
    patched.write_text(source,encoding='utf-8')

    # 仅重编译被补丁影响的翻译单元，其余对象和依赖库以只读方式复用。
    objects=sorted(object_dir.rglob('*.obj'))
    old_renderer=[p for p in objects if p.name=='LW_Renderer.obj']
    if len(old_renderer)!=1 or len(objects)<20:
        raise RuntimeError('缺少完整的 Sub x64 Release 构建，请先在上游完成正常构建')
    objects=[p for p in objects if p!=old_renderer[0]]
    resources=list(object_dir.rglob('*.res'))
    if not resources: raise RuntimeError('缺少 Sub 已编译的程序资源')
    tree=ET.parse(project);root=tree.getroot()
    for group in list(root):
        for item in list(group):
            if item.tag in {tag('ProjectReference'),tag('CustomBuild'),tag('ResourceCompile')}:
                group.remove(item)
            elif group.tag==tag('ItemGroup') and item.tag==tag('ClCompile'):
                group.remove(item)
    for group in root.findall(tag('ItemDefinitionGroup')):
        for name in ('PreBuildEvent','PostBuildEvent','PreLinkEvent'):
            event=group.find(tag(name))
            if event is not None: group.remove(event)
        link=group.find(tag('Link'))
        if link is not None:
            deps=link.find(tag('AdditionalDependencies'))
            if deps is not None:
                values=[]
                for value in deps.text.split(';'):
                    if value.startswith('..'):
                        value=str((project.parent/value).resolve())
                    values.append(value)
                deps.text=';'.join([*values,*map(str,objects),*map(str,resources),'d3dcompiler.lib'])
    for item in root.iter():
        name=item.tag.rsplit('}',1)[-1]
        if name=='OutDir': item.text=str(output/'bin')+os.sep
        elif name=='IntDir': item.text=str(output/'obj')+os.sep
        elif name=='ProjectGuid': item.text='{'+str(uuid.uuid5(uuid.NAMESPACE_URL,str(output)))+'}'
        elif name in {'ProgramDataBaseFile','ImportLibrary'} and item.text:
            item.text=str(output/Path(item.text.replace('\\','/')).name)
    group=ET.SubElement(root,tag('ItemGroup'))
    item=ET.SubElement(group,tag('ClCompile'),{'Include':str(patched)})
    ET.SubElement(item,tag('PrecompiledHeader')).text='NotUsing'
    ET.SubElement(item,tag('ForcedIncludeFiles')).text=str(project.parent/'CMakeFiles/LuaSTG.dir/Release/cmake_pch.hxx')
    local_project=output/'SourceModelMesh.vcxproj'
    tree.write(local_project,encoding='utf-8',xml_declaration=True)
    vswhere=Path(os.environ.get('ProgramFiles(x86)','C:/Program Files (x86)'))/'Microsoft Visual Studio/Installer/vswhere.exe'
    installation=subprocess.check_output([str(vswhere),'-latest','-products','*','-requires','Microsoft.Component.MSBuild','-property','installationPath'],text=True).strip()
    if not installation: raise RuntimeError('未找到 Visual Studio MSBuild')
    msbuild=Path(installation)/'MSBuild/Current/Bin/MSBuild.exe'
    subprocess.run([str(msbuild),str(local_project),'/m','/t:Build','/p:Configuration=Release','/p:Platform=x64',
        '/p:BuildProjectReferences=false','/verbosity:minimal','/nologo'],check=True,cwd=output)
    built=output/'bin/LuaSTGSub.exe'
    if not built.is_file(): raise RuntimeError('编译未生成 Windows 引擎')
    record={'engine':str(engine),'version':'0.21.129','renderer_sha256':hashlib.sha256(original.read_bytes()).hexdigest(),
        'patch_sha256':hashlib.sha256(header.read_bytes()).hexdigest(),'exe_sha256':hashlib.sha256(built.read_bytes()).hexdigest()}
    (output/'build.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    if not args.no_install:
        target=ROOT/'LuaSTGSub.exe';backup=output/'LuaSTGSub.before.exe'
        if target.exists() and not backup.exists(): shutil.copy2(target,backup)
        shutil.copy2(built,target)
        print('已更新本地 Windows 引擎：'+str(target))
    print('仅完成编译；未启动游戏或运行测试。')

if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    main()
