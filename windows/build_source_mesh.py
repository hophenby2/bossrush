#!/usr/bin/env python3
"""从锁定的官方 Sub 干净源码完整构建，再接入独立维护的背景网格与原作对象接口。"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import re
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
    ap.add_argument('--engine',type=Path,default=ROOT/'windows/build/official-sub')
    ap.add_argument('--no-install',action='store_true')
    args=ap.parse_args()
    engine=args.engine.resolve()
    lock=json.loads((ROOT/'windows/engine.lock.json').read_text(encoding='utf-8'))
    def git(*commands):
        return subprocess.check_output(['git','-C',str(engine),*commands],text=True,encoding='utf-8').strip()
    if git('remote','get-url','origin')!=lock['repository']:
        raise RuntimeError('引擎 origin 必须对应 windows/engine.lock.json 中的官方仓库')
    if git('rev-parse','HEAD')!=lock['commit']:
        raise RuntimeError('引擎提交与 windows/engine.lock.json 不一致')
    if git('status','--porcelain','--untracked-files=no','--ignore-submodules=none'):
        raise RuntimeError('引擎或子模块存在本地修改，拒绝混入构建')
    modules=git('submodule','status','--recursive')
    if any(line.startswith(('-', '+', 'U')) for line in modules.splitlines()):
        raise RuntimeError('官方引擎的子模块未按锁定版本初始化')
    version=json.loads((engine/'version.json').read_text(encoding='utf-8'))
    if (version['major'],version['minor'],version['patch'])!=(0,21,129):
        raise RuntimeError('此补丁对应 Sub 0.21.129，请先核对其他版本的接口和对象文件')
    # 先从该工作区构建全部引擎目标，不读取其他目录的历史对象文件。
    subprocess.run(['cmake','--preset','vs2022-amd64'],check=True,cwd=engine)
    subprocess.run(['cmake','--build','--preset','windows-amd64-release','--parallel','6'],check=True,cwd=engine)
    project=engine/'build/amd64/LuaSTG/LuaSTG.vcxproj'
    object_dir=project.parent/'LuaSTG.dir/Release'
    original=engine/'LuaSTG/LuaSTG/LuaBinding/LW_Renderer.cpp'
    header=ROOT/'windows/native/source_model_mesh.hpp'
    output=ROOT/'windows/build/source_mesh'
    output.mkdir(parents=True,exist_ok=True)
    source=original.read_text(encoding='utf-8-sig')
    anchor='namespace luastg {'
    register='\tstatic luaL_Reg const lib_compat[] = {'
    if source.count(anchor)!=1 or source.count(register)!=1:
        raise RuntimeError('Sub 渲染绑定的补丁上下文不匹配')
    source=source.replace(anchor,'#include "'+header.as_posix()+'"\n\n'+anchor,1)
    # Lua 桥接使用 lstg.*；lib_func 注册到 lstg.Renderer，不能把接口插在那里。
    source=source.replace(register,register+'\n'
        '\t\t{ "CopySourceTable", &source_mesh::copyTable },\n'
        '\t\t{ "SyncSourceBulletGeometry", &source_mesh::syncBulletGeometry },\n'
        '\t\t{ "CreateSourceModelMesh", &source_mesh::create },\n'
        '\t\t{ "RenderSourceModelMesh", &source_mesh::draw },\n'
        '\t\t{ "RenderSourceModelMeshes", &source_mesh::drawBatch },',1)
    patched=output/'LW_Renderer.cpp'
    patched.write_text(source,encoding='utf-8')
    # 着色器原先到第一次画模型时才编译；构建时也编译两入口，避免把语法错误带进游戏。
    sdk=Path(os.environ.get('ProgramFiles(x86)','C:/Program Files (x86)'))/'Windows Kits/10/bin'
    compilers=sorted(sdk.glob('*/x64/fxc.exe'),key=lambda p:tuple(int(n) for n in p.parents[1].name.split('.')))
    if not compilers: raise RuntimeError('缺少 Windows SDK 的 x64 fxc.exe')
    shader=re.search(r'shader\[\]=R"\((.*?)\)";',header.read_text(encoding='utf-8'),re.S)
    if not shader: raise RuntimeError('未找到背景网格着色器源码')
    shader_path=output/'source_model_mesh.hlsl';shader_path.write_text(shader[1],encoding='utf-8')
    for stage in ('vs','ps'):
        subprocess.run([str(compilers[-1]),'/nologo','/T',stage+'_4_0','/E',stage+'_main','/O3',
            '/Fo',str(output/(stage+'.cso')),str(shader_path)],check=True)

    # 官方限帧器沿旧截止时间追赶十帧以内的延迟；项目暂时改为按上一帧实际起点限帧。
    pacer_original=engine/'engine/window-system/windows/FrameRateController.cpp'
    pacer_source=pacer_original.read_text(encoding='utf-8-sig')
    deadline='const int64_t target = m_baseline + m_frame_count * m_interval;'
    if pacer_source.count(deadline)!=2:
        raise RuntimeError('官方限帧器补丁上下文不匹配')
    pacer_source=pacer_source.replace(deadline,
        'const int64_t target = m_last + m_interval;')
    patched_pacer=output/'FrameRateController.cpp'
    patched_pacer.write_text(pacer_source,encoding='utf-8')

    # 在刚完成的官方构建上接入渲染绑定和限帧补丁，不改写上游源码。
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
    for source_file in (patched,patched_pacer):
        item=ET.SubElement(group,tag('ClCompile'),{'Include':str(source_file)})
        ET.SubElement(item,tag('PrecompiledHeader')).text='NotUsing'
        ET.SubElement(item,tag('ForcedIncludeFiles')).text=str(project.parent/'CMakeFiles/LuaSTG.dir/Release/cmake_pch.hxx')
        ET.SubElement(item,tag('AdditionalIncludeDirectories')).text=str(engine/'engine/window-system')+';%(AdditionalIncludeDirectories)'
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
    if git('status','--porcelain','--untracked-files=no','--ignore-submodules=none'):
        raise RuntimeError('构建后官方源码或子模块出现修改，拒绝安装引擎')
    record={'engine':str(engine),'version':'0.21.129','repository':lock['repository'],'ref':lock['ref'],
        'commit':lock['commit'],'submodules':modules,'renderer_sha256':hashlib.sha256(original.read_bytes()).hexdigest(),
        'pacer_source_sha256':hashlib.sha256(pacer_original.read_bytes()).hexdigest(),
        'pacer_patch_sha256':hashlib.sha256(patched_pacer.read_bytes()).hexdigest(),
        'frame_pacing':'按上一帧实际起点限帧，不追赶旧截止时间',
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
