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
        '\t\t{ "FindSourceTargetInList", &source_mesh::findTargetInList },\n'
        '\t\t{ "SetSourceActorDamageShape", &source_mesh::setActorDamageShape },\n'
        '\t\t{ "CreateSourceTargetView", &source_mesh::createTargetView },\n'
        '\t\t{ "GetSourceFrameStatistics", &source_mesh::frameStatistics },\n'
        '\t\t{ "SetSourceSoundVolume", &source_mesh::soundVolume },\n'
        '\t\t{ "SetSourceImageStateRGBA", &source_mesh::imageStateRGBA },\n'
        '\t\t{ "RenderSourceObjectImage", &source_mesh::renderObjectImage },\n'
        '\t\t{ "CreateSourceModelMesh", &source_mesh::create },\n'
        '\t\t{ "RenderSourceModelMesh", &source_mesh::draw },\n'
        '\t\t{ "RenderSourceModelMeshes", &source_mesh::drawBatch },',1)
    patched=output/'LW_Renderer.cpp'
    patched.write_text(source,encoding='utf-8')
    # 单个原作环境音的淡入淡出不应改动玩家设置的全局音效音量。
    # 只增加非虚成员，不改变官方资源对象布局或现有虚表。
    audio_header=engine/'LuaSTG/LuaSTG/GameResource/Implement/ResourceSoundEffectImpl.hpp'
    audio_source=audio_header.read_text(encoding='utf-8-sig')
    audio_anchor='\t\tfloat GetSpeed() override;'
    if audio_source.count(audio_anchor)!=1:
        raise RuntimeError('官方音效资源补丁上下文不匹配')
    audio_source=audio_source.replace(audio_anchor,audio_anchor+'\n'
        '\t\tvoid SetSourceVolume(float volume) {\n'
        '\t\t\tif (m_last_command.type == CommandType::play) m_last_command.vol = volume;\n'
        '\t\t\tm_player->setVolume(volume);\n'
        '\t\t}',1)
    audio_include=output/'include/GameResource/Implement/ResourceSoundEffectImpl.hpp'
    audio_include.parent.mkdir(parents=True,exist_ok=True)
    audio_include.write_text(audio_source,encoding='utf-8')
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
    # 将限帧等待与 DXGI 队列等待分开记录；读取上一完整帧，避免错配当前帧。
    pacer_anchor='    double FrameRateController::update() noexcept {'
    if pacer_source.count(pacer_anchor)!=1:
        raise RuntimeError('官方限帧计时入口不匹配')
    pacer_source=('namespace { double source_pacer_wait{}, source_previous_pacer_wait{}; }\n'
        'extern "C" double GetSourcePacerWait() { return source_previous_pacer_wait; }\n'+pacer_source)
    pacer_source=pacer_source.replace(pacer_anchor,pacer_anchor+'\n'
        '        source_previous_pacer_wait = source_pacer_wait;\n'
        '        const core::ScopeTimer source_wait_timer(&source_pacer_wait);',1)
    patched_pacer=output/'FrameRateController.cpp'
    patched_pacer.write_text(pacer_source,encoding='utf-8')

    # 无垂直同步时先让 CPU 更新，再在 Present 必要时等待队列，避免前一画面的显示等待串行挡住逻辑。
    app_original=engine/'LuaSTG/LuaSTG/AppFrame.cpp'
    app_source=app_original.read_text(encoding='utf-8-sig')
    wait_anchor='if (m_swap_chain) {\n\t\t\tm_swap_chain->waitFrameLatency();'
    if app_source.count(wait_anchor)!=1:
        raise RuntimeError('官方交换链等待入口不匹配')
    app_source=app_source.replace(wait_anchor,
        'if (m_swap_chain && m_swap_chain->getVSync()) {\n\t\t\tm_swap_chain->waitFrameLatency();',1)
    patched_app=output/'AppFrame.cpp';patched_app.write_text(app_source,encoding='utf-8')
    swap_original=engine/'engine/graphics/d3d11/SwapChain.cpp'
    swap_source=swap_original.read_text(encoding='utf-8-sig')
    present_flags='flags |= DXGI_PRESENT_DO_NOT_WAIT;'
    present_call='const auto present_result = m_swap_chain->Present(interval, flags);'
    if swap_source.count(present_flags)!=1 or swap_source.count(present_call)!=1:
        raise RuntimeError('官方画面提交入口不匹配')
    swap_source=swap_source.replace(present_flags,'if (m_vsync) flags |= DXGI_PRESENT_DO_NOT_WAIT;',1)
    swap_source=('namespace { unsigned long long source_present_busy{}; }\n'
        'extern "C" unsigned long long GetSourcePresentBusy() { return source_present_busy; }\n'+swap_source)
    swap_source=swap_source.replace(present_call,present_call+'\n'
        '        if (present_result == DXGI_ERROR_WAS_STILL_DRAWING) ++source_present_busy;',1)
    patched_swap=output/'SwapChain.cpp';patched_swap.write_text(swap_source,encoding='utf-8')

    # 保留单线程逻辑和原线程优先级，让系统选择运行核心，避免所有逻辑固定挤在 CPU 0。
    application_original=engine/'engine/window-system/windows/ApplicationManager.cpp'
    application_source=application_original.read_text(encoding='utf-8-sig')
    affinity_anchor='        SetThreadAffinityMask(g_main_thread, 0x1);'
    if application_source.count(affinity_anchor)!=1:
        raise RuntimeError('官方主线程亲和性入口不匹配')
    application_source=application_source.replace(affinity_anchor,
        '        // 主线程保留系统默认亲和性，由调度器选择核心。',1)
    patched_application=output/'ApplicationManager.cpp';patched_application.write_text(application_source,encoding='utf-8')

    # 在刚完成的官方构建上接入独立补丁，不改写上游源码。
    objects=sorted(object_dir.rglob('*.obj'))
    old_renderer=[p for p in objects if p.name=='LW_Renderer.obj']
    old_app=[p for p in objects if p.name=='AppFrame.obj']
    if len(old_renderer)!=1 or len(old_app)!=1 or len(objects)<20:
        raise RuntimeError('缺少完整的 Sub x64 Release 构建，请先在上游完成正常构建')
    objects=[p for p in objects if p not in old_renderer+old_app]
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
    for source_file in (patched,patched_pacer,patched_app,patched_swap,patched_application):
        item=ET.SubElement(group,tag('ClCompile'),{'Include':str(source_file)})
        ET.SubElement(item,tag('PrecompiledHeader')).text='NotUsing'
        ET.SubElement(item,tag('ForcedIncludeFiles')).text=str(project.parent/'CMakeFiles/LuaSTG.dir/Release/cmake_pch.hxx')
        ET.SubElement(item,tag('AdditionalIncludeDirectories')).text=(str(output/'include')+';'+str(engine/'engine/window-system')+';'
            +str(engine/'engine/graphics')+';%(AdditionalIncludeDirectories)')
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
        'presentation':'无垂直同步时不在更新前等待 DXGI 队列；Present 必要时阻塞，保留画面提交',
        'app_source_sha256':hashlib.sha256(app_original.read_bytes()).hexdigest(),
        'app_patch_sha256':hashlib.sha256(patched_app.read_bytes()).hexdigest(),
        'swap_source_sha256':hashlib.sha256(swap_original.read_bytes()).hexdigest(),
        'swap_patch_sha256':hashlib.sha256(patched_swap.read_bytes()).hexdigest(),
        'main_thread_affinity':'系统默认亲和性，不固定 CPU 0',
        'application_source_sha256':hashlib.sha256(application_original.read_bytes()).hexdigest(),
        'application_patch_sha256':hashlib.sha256(patched_application.read_bytes()).hexdigest(),
        'patch_sha256':hashlib.sha256(header.read_bytes()).hexdigest(),'exe_sha256':hashlib.sha256(built.read_bytes()).hexdigest()}
    record['sound_volume']='独立音效资源音量；不改动全局音效混音器'
    record['sound_header_sha256']=hashlib.sha256(audio_header.read_bytes()).hexdigest()
    record['sound_patch_sha256']=hashlib.sha256(audio_include.read_bytes()).hexdigest()
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
