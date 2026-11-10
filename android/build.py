#!/usr/bin/env python3
"""固定引擎版本，交叉编译并生成可侧载的 ARM64 测试 APK。"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import zipfile
import wave
import re
import struct
import zlib

ROOT = Path(__file__).resolve().parent
GAME = ROOT.parent
CACHE = ROOT / '.cache'
BUILD = ROOT / 'build'
LOCK = json.loads((ROOT / 'engine.lock.json').read_text(encoding='utf-8'))
ENGINE = CACHE / 'LuaSTG-x'
NATIVE = BUILD / 'native-gfx'
sys.path.insert(0, str(ROOT.parent / 'tools'))
from release_version import game_version


def prepare_manifest():
    """显示版本来自UI.lua；versionCode保留清单中的安装升级序号。"""
    source = (ROOT / 'AndroidManifest.xml').read_text(encoding='utf-8-sig')
    source, count = re.subn(r'android:versionName="[^"]*"',
                           lambda _: f'android:versionName="{game_version(GAME)}"', source)
    assert count == 1, 'AndroidManifest.xml必须声明一个versionName'
    path = BUILD / 'AndroidManifest.xml'
    write_utf8(path, source)
    return path


def resume_fingerprint(game, include_android=True):
    """对实际入包的游戏与移植 Lua 源码生成续玩版本指纹。"""
    files = {game / 'core.lua', game / 'launch.lua'}
    for folder in ['THlib', 'mod', 'Resources/System'] + (['android'] if include_android else []):
        files.update((game / folder).rglob('*.lua'))
    parts = []
    for path in sorted(files, key=lambda item: item.relative_to(game).as_posix()):
        data = path.read_text(encoding='utf-8-sig').replace('\r\n', '\n').encode('utf-8')
        parts.append(f'{path.relative_to(game).as_posix()}:{len(data)}:{hashlib.sha256(data).hexdigest()}')
    return hashlib.sha256('\n'.join(parts).encode('utf-8')).hexdigest()


def run(*args, **kwargs):
    print('+', ' '.join(map(str, args)), flush=True)
    subprocess.run(list(map(str, args)), check=True, **kwargs)


def executable(directory, name):
    """同一打包入口兼容 Windows 的可执行文件后缀。"""
    return Path(directory) / (name + ('.exe' if os.name == 'nt' else ''))


def write_utf8(path, text):
    """生成资源固定为 UTF-8/LF，避免 Windows 改写换行和中文编码。"""
    path.write_text(text, encoding='utf-8', newline='\n')


def asset_compression(path):
    # FreeType 默认通过 AAsset_seek 流式读取；字体压缩后反复跳读会重复解压。
    # Ogg 同样需要随机访问，已有自身压缩，直接存储也避免循环播放时再套一层解压。
    return zipfile.ZIP_STORED if path.suffix.lower() in {'.ttf', '.otf', '.ogg'} else zipfile.ZIP_DEFLATED


def copy_tree(source, target):
    shutil.copytree(source, target, dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('.git', '.DS_Store', '*.bat'))


def prepare_shaders(target):
    # GFX 通过 glslang 生成 SPIR-V，再转换为设备的 GLES shader；必须显式声明位置和 uniform 块。
    for source in target.glob('*.frag'):
        text = source.read_text(encoding='utf-8')
        uniforms = re.findall(r'^uniform vec4 (\w+);$', text, re.MULTILINE)
        text = re.sub(r'^uniform vec4 \w+;\n', '', text, flags=re.MULTILINE)
        text = text.replace('uniform sampler2D u_texture;', 'layout(binding=2) uniform sampler2D u_texture;')
        text = text.replace('varying vec2 v_texCoord;', 'layout(location=1) in highp vec2 v_texCoord;')
        text = text.replace('gl_FragColor', 'cc_FragColor').replace('texture2D(', 'texture(')
        block = 'layout(std140, binding=1) uniform FSBlock {\n' + ''.join(
            '    vec4 ' + name + ';\n' for name in uniforms) + '};\n' if uniforms else ''
        prefix = 'precision highp float;\nlayout(location=0) out vec4 cc_FragColor;\n' + block
        write_utf8(target / source.name, prefix + text)
    write_utf8(target / 'common.vert', '''precision highp float;
layout(location=0) in vec4 a_position;
layout(location=1) in vec4 a_color;
layout(location=2) in vec2 a_texCoord;
layout(std140, binding=0) uniform VSBlock { mat4 u_MVPMatrix; };
layout(location=0) out highp vec4 v_fragmentColor;
layout(location=1) out highp vec2 v_texCoord;
void main() {
    gl_Position = u_MVPMatrix * a_position;
    v_texCoord = a_texCoord;
    v_fragmentColor = a_color;
}
''')


def prepare_posteffect_shaders(target):
    """两个后端都先注入Sub采样口径，再由Android转换GLSL版本。"""
    helper = (target / 'sampling.glsl').read_text(encoding='utf-8')
    for path in target.glob('*.frag'):
        text = path.read_text(encoding='utf-8')
        text = text.replace('precision highp float;', 'precision highp float;\nprecision highp sampler2D;')
        # 此时只替换效果正文；公共采样函数保留真正的纹理读取。
        text = text.replace('texture2D(u_texture,', 'subSampleScreen(')
        if 'uniform vec4 SCREENSIZE;' not in text:
            text = text.replace('uniform sampler2D u_texture;',
                                'uniform sampler2D u_texture;\nuniform vec4 SCREENSIZE;')
        anchor = 'varying vec2 v_texCoord;'
        if anchor not in text:
            raise RuntimeError(f'后处理shader上下文不匹配：{path.name}')
        write_utf8(path, text.replace(anchor, anchor + '\n' + helper))


def prepare_engine(archive=None):
    CACHE.mkdir(exist_ok=True)
    if not (ENGINE / 'CMakeLists.txt').exists():
        archive = Path(archive) if archive else CACHE / 'engine.zip'
        if not archive.exists():
            run('curl', '-fL', '--retry', '3', '-o', archive, LOCK['url'])
        digest = hashlib.file_digest(archive.open('rb'), 'sha256').hexdigest()
        if digest != LOCK['sha256']:
            raise RuntimeError('引擎压缩包 SHA-256 不匹配，请删除后重新下载')
        with zipfile.ZipFile(archive) as z:
            for name in z.namelist():
                if '..' in Path(name).parts or Path(name).is_absolute():
                    raise RuntimeError('压缩包路径非法')
            z.extractall(ENGINE)
    # 对固定版本施加最小构建修复，补丁检查原文防止版本漂移。
    patcher = ROOT / 'patch_engine.py'
    if patcher.exists():
        run(sys.executable, patcher, ENGINE)


def prepare_sprite_shaders(target):
    """Sub v0.21.129的顶点色与逐像素雾效；两平台共用相同公式。"""
    path = target / 'ColorAdd.frag'
    text = path.read_text(encoding='utf-8')
    for output in ('cc_FragColor', 'gl_FragColor'):
        before = f'{output}.rgb = v_fragmentColor.rgb + tex.rgb;'
        after = f'{output}.rgb = min(v_fragmentColor.rgb + tex.rgb, vec3(1.0));'
        if after in text:
            continue
        if text.count(before) != 1:
            raise RuntimeError(f'加色shader上下文不匹配：ColorAdd.frag/{output}')
        text = text.replace(before, after)
    write_utf8(path, text)
    for filename in ('ColorAdd.frag', 'ColorMulti.frag', 'Common.vert'):
        path = target / filename
        text = re.sub(r'\b(?:lowp|mediump)\b', 'highp', path.read_text(encoding='utf-8'))
        if filename.endswith('.frag'):
            text = text.replace('precision highp float;', 'precision highp float;\nprecision highp sampler2D;')
        write_utf8(path, text)
    vertex = (ROOT / 'sprite_shaders' / 'fog.vert').read_text(encoding='utf-8')
    fragment = (ROOT / 'sprite_shaders' / 'fog.frag').read_text(encoding='utf-8')
    for filename in ('Fog_Liner.vert', 'Fog_Exp1.vert', 'Fog_Exp2.vert'):
        write_utf8(target / filename, vertex)
    write_utf8(target / 'ColorMulti_Fog.frag', fragment)
    write_utf8(target / 'ColorAdd_Fog.frag', fragment.replace('#define SUB_COLOR_ADD 0', '#define SUB_COLOR_ADD 1'))


def prepare_assets():
    assets = BUILD / 'assets'
    if assets.exists():
        shutil.rmtree(assets)
    assets.mkdir(parents=True, exist_ok=True)
    copy_tree(ENGINE / 'src', assets / 'src')
    # 只修改入包资源，不依赖手动改过的引擎缓存，也不需要重编译原生库。
    prepare_sprite_shaders(assets / 'src' / 'shader')
    copy_tree(ENGINE / 'res', assets / 'res')
    destination = assets / 'game'
    destination.mkdir(exist_ok=True)
    paths = []
    dimensions = {}
    for name in ['THlib', 'Resources', 'mod', 'music', 'BadApple', 'shader',
                 'core.lua', 'launch.lua', 'manual', 'Update.txt']:
        source = GAME / name
        sources = sorted(source.rglob('*')) if source.is_dir() else [source]
        for source in sources:
            if not source.is_file() or source.name.startswith('.'):
                continue
            relative = source.relative_to(GAME)
            target = destination / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            if source.suffix == '.lua':
                write_utf8(target, source.read_text(encoding='utf-8-sig'))
            elif source.suffix.lower() == '.wav':
                if not target.exists() or target.stat().st_mtime <= source.stat().st_mtime:
                    # 去掉 JUNK/LIST 等元数据，不改变 PCM 样本、声道、采样率或位深。
                    with wave.open(str(source), 'rb') as audio:
                        params = audio.getparams()
                        samples = audio.readframes(audio.getnframes())
                    with wave.open(str(target), 'wb') as audio:
                        audio.setparams(params)
                        audio.writeframes(samples)
            elif not target.exists() or target.stat().st_mtime < source.stat().st_mtime:
                shutil.copy2(source, target)
            paths.append(relative.as_posix())
            if source.suffix.lower() == '.png':
                with source.open('rb') as image:
                    header = image.read(24)
                if header[:8] == b'\x89PNG\r\n\x1a\n':
                    dimensions[relative.as_posix()] = struct.unpack('>II', header[16:24])
    # assets 无目录遍历接口，用打包清单提供确定性枚举与大小写纠正。
    seen = {}
    for path in paths:
        if path.lower() in seen:
            raise RuntimeError(f'存在大小写冲突：{path} / {seen[path.lower()]}')
        seen[path.lower()] = path
    write_utf8(destination / 'asset_index.lua', 'return ' + '{\n' + ''.join(
        '  ' + json.dumps(p, ensure_ascii=False) + ',\n' for p in paths) + '}\n')
    write_utf8(destination / 'asset_dimensions.lua', 'return {\n' + ''.join(
        '  [' + json.dumps(p, ensure_ascii=False) + ']={' + str(size[0]) + ',' + str(size[1]) + '},\n'
        for p, size in sorted(dimensions.items())) + '}\n')
    copy_tree(ROOT / 'lua', destination / 'android')
    for script in (destination / 'android').glob('*.lua'):
        write_utf8(script, script.read_text(encoding='utf-8-sig'))
    copy_tree(ROOT / 'shaders', destination / 'android' / 'shaders')
    expected_shaders = {p.stem for p in (GAME / 'shader').glob('*.hlsl')}
    ported_shaders = {p.stem for p in (destination / 'android' / 'shaders').glob('*.frag')}
    if expected_shaders != ported_shaders:
        raise RuntimeError(f'后处理移植清单未对齐：缺少{expected_shaders-ported_shaders}，多出{ported_shaders-expected_shaders}')
    prepare_posteffect_shaders(destination / 'android' / 'shaders')
    prepare_shaders(destination / 'android' / 'shaders')
    modes = (ENGINE / 'src/core/corefunc.lua').read_text(encoding='utf-8')
    modes = modes.split('local shader_path = ', 1)[1].split('local _capture = {}', 1)[0]
    modes = modes.replace("lstg.RenderMode:getByName(''):setAsDefault()",
                          "lstg.RenderMode:getDefault():setProgram(lstg.RenderMode:getByName(''):getProgram())")
    write_utf8(destination / 'android/render_modes.lua',
        '-- 来自固定版本 LuaSTG-x core/corefunc.lua 的渲染模式与雾效。\nlocal shader_path = ' + modes)
    write_utf8(destination / 'android/resume-version.txt', resume_fingerprint(destination))
    write_utf8(destination / 'android/net-version.txt', resume_fingerprint(destination, include_android=False))
    shutil.copy2(ROOT / 'lua' / 'main.lua', assets / 'src' / 'main.lua')
    for source in ENGINE.rglob('*'):
        if source.is_file() and source.name.lower() in {
            'license', 'license.txt', 'license.md', 'copying', 'copying.txt',
            'copyright', 'copyright.txt', 'notice', 'notice.txt', 'authors', 'authors.txt',
        }:
            target = assets / 'licenses' / source.relative_to(ENGINE)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, target)
    write_utf8(assets / 'licenses' / 'SOURCE.txt',
        'LuaSTG-x 20260913 及其随包依赖的源码与许可证来自：\n' + LOCK['url'] +
        '\nSHA-256: ' + LOCK['sha256'] + '\nAndroid 适配变更见项目 android/patch_engine.py 和 android/native/。\n')
    jit_lock = json.loads((ROOT / 'luajit.lock.json').read_text(encoding='utf-8'))
    shutil.copy2(ROOT / 'LUAJIT_LICENSE.txt', assets / 'licenses/LUAJIT_LICENSE.txt')
    write_utf8(assets / 'licenses/LUAJIT_SOURCE.txt',
        'Android ARM64 LuaJIT源码：' + jit_lock['url'] + '\nSHA-256: ' + jit_lock['sha256'] +
        '\n本项目补丁：android/build_luajit.py、android/native/luajit_mcode_arena.inc。\n')
    sdk = Path(os.environ.get('ANDROID_HOME', str(Path.home() / 'Library/Android/sdk')))
    ndk = Path(os.environ.get('ANDROID_NDK_HOME', str(sdk / 'ndk' / LOCK['ndk'])))
    if (ndk / 'NOTICE').exists():
        target = assets / 'licenses/android-ndk/NOTICE'
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(ndk / 'NOTICE', target)
    # APK 直接保存原始资源，桌面 User/ 和 replay/ 从未参与打包。
    print(f'已准备 {len(paths)} 个游戏资源文件', flush=True)
    return assets


def native_build(sdk, ndk, jobs):
    from build_luajit import build as build_luajit
    luajit = build_luajit(ndk, jobs)
    native = NATIVE
    run('cmake', '-S', ENGINE, '-B', native, '-G', 'Ninja',
        f'-DCMAKE_TOOLCHAIN_FILE={ndk}/build/cmake/android.toolchain.cmake',
        '-DANDROID_ABI=arm64-v8a', '-DANDROID_PLATFORM=android-28',
        '-DANDROID_STL=c++_shared', '-DCMAKE_BUILD_TYPE=Release',
        f'-DBOSSRUSH_LUAJIT_LIBRARY={luajit}',
        '-DCMAKE_POLICY_VERSION_MINIMUM=3.5',
        '-DCMAKE_CXX_SCAN_FOR_MODULES=OFF',
        '-DALSOFT_ENABLE_MODULES=OFF',
        '-DALSOFT_RTKIT=OFF',
        '-DLSTGX_NO_LIVE2D=ON', '-DLSTGX_NO_VIDEO=ON',
        '-DLSTGX_NO_YUESCRIPT=ON', '-DLSTGX_USE_GFX=ON',
        '-DFT_DISABLE_PNG=ON', '-DFT_DISABLE_BZIP2=ON', '-DFT_DISABLE_BROTLI=ON',
        '-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-z,max-page-size=16384')
    run('cmake', '--build', native, '--target', 'cocos2dlua', '-j', jobs)


def package_apk(sdk, ndk, assets):
    tools = max((sdk / 'build-tools').iterdir(), key=lambda p: tuple(map(int, p.name.split('.'))))
    platforms = sorted((sdk / 'platforms').glob('*/android.jar'))
    android_jar = platforms[-1]
    java_home = os.environ.get('JAVA_HOME')
    javac = executable(Path(java_home) / 'bin', 'javac') if java_home else Path(shutil.which('javac'))
    keytool = executable(javac.parent, 'keytool')
    java_runtime = executable(javac.parent, 'java')
    classes = BUILD / 'classes'
    classes.mkdir(exist_ok=True)
    java = ENGINE / 'frameworks/cocos2d-x/cocos/platform/android/java'
    jars = list((java / 'libs').glob('*.jar'))
    sources = list((java / 'src').rglob('*.java'))
    sources += list((ROOT / 'java').rglob('*.java'))
    resources = BUILD / 'resources'
    resources.mkdir(exist_ok=True)
    gen = BUILD / 'gen'
    gen.mkdir(exist_ok=True)
    java_res = java / 'res'
    resource_args = []
    for index, source in enumerate((java_res, ROOT / 'res')):
        if any(source.rglob('*.xml')):
            compiled = BUILD / f'resources-{index}.zip'
            run(executable(tools, 'aapt2'), 'compile', '--dir', source, '-o', compiled)
            resource_args.append(compiled)
    run(executable(tools, 'aapt2'), 'link', '-o', BUILD / 'resources.apk', '-I', android_jar,
        '--manifest', BUILD / 'AndroidManifest.xml', '--java', gen,
        '--auto-add-overlay', *resource_args)
    sources += list(gen.rglob('*.java'))
    source_list = BUILD / 'java-sources.txt'
    source_list.write_text('\n'.join('"' + p.as_posix() + '"' for p in sources), encoding='utf-8')
    run(javac, '-encoding', 'UTF-8', '-source', '11', '-target', '11',
        '-classpath', os.pathsep.join(map(str, [android_jar] + jars)), '-d', classes, '@' + str(source_list))
    dex = BUILD / 'dex'
    dex.mkdir(exist_ok=True)
    # 汇成一个输入，避免 Windows 命令行长度上限；直接调用 Java 也无需执行 bat。
    class_archive = BUILD / 'classes.jar'
    with zipfile.ZipFile(class_archive, 'w', compression=zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(classes.rglob('*.class')):
            archive.write(path, path.relative_to(classes).as_posix())
    run(java_runtime, '-cp', tools / 'lib/d8.jar', 'com.android.tools.r8.D8',
        '--min-api', '28', '--lib', android_jar, '--output', dex, class_archive, *jars)
    unsigned = BUILD / 'unsigned.apk'
    shutil.copy2(BUILD / 'resources.apk', unsigned)
    libs = sorted(NATIVE.rglob('*.so'))
    if not any(p.name == 'libcocos2dlua.so' for p in libs):
        raise RuntimeError('原生引擎尚未生成 libcocos2dlua.so，不能生成空壳 APK')
    cpp = ndk / 'toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so'
    if not cpp.exists():
        cpp = next(ndk.glob('toolchains/llvm/prebuilt/*/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so'))
    libs.append(cpp)
    strip = next(ndk.glob('toolchains/llvm/prebuilt/*/bin/llvm-strip' + ('.exe' if os.name == 'nt' else '')))
    staging = BUILD / 'stripped-libs'
    staging.mkdir(exist_ok=True)
    lib_names = set()
    with zipfile.ZipFile(unsigned, 'a', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as apk:
        apk.write(dex / 'classes.dex', 'classes.dex')
        for lib in libs:
            if lib.name not in lib_names:
                lib_names.add(lib.name)
                target = staging / lib.name
                shutil.copy2(lib, target)
                run(strip, '--strip-unneeded', target)
                apk.write(target, 'lib/arm64-v8a/' + lib.name)
        for path in sorted(assets.rglob('*')):
            if path.is_file():
                apk.write(path, 'assets/' + path.relative_to(assets).as_posix(), compress_type=asset_compression(path))
    sign_apk(tools, keytool, unsigned)


def sign_apk(tools, keytool, unsigned):
    aligned = BUILD / 'aligned.apk'
    run(executable(tools, 'zipalign'), '-f', '-p', '4', unsigned, aligned)
    keystore = CACHE / 'debug.keystore'
    if not keystore.exists():
        run(keytool, '-genkeypair', '-keystore', keystore, '-storepass', 'android',
            '-keypass', 'android', '-alias', 'androiddebugkey', '-keyalg', 'RSA',
            '-keysize', '2048', '-validity', '10000',
            '-dname', 'CN=Boss Rush HD Android Debug,O=Local Development,C=CN')
    dist = ROOT / 'dist'
    dist.mkdir(exist_ok=True)
    output = dist / 'BossRushHD-android-arm64-debug.apk'
    idsig = Path(str(output) + '.idsig')
    if idsig.exists():
        idsig.unlink()
    signer = [executable(keytool.parent, 'java'), '-jar', tools / 'lib/apksigner.jar']
    run(*signer, 'sign', '--ks', keystore, '--ks-pass', 'pass:android',
        '--v4-signing-enabled', 'false', '--out', output, aligned)
    run(*signer, 'verify', '--verbose', '--print-certs', output)
    digest = hashlib.file_digest(output.open('rb'), 'sha256').hexdigest()
    (dist / (output.name + '.sha256')).write_text(digest + '  ' + output.name + '\n')
    print(f'APK：{output}\nSHA-256：{digest}', flush=True)
    release = dist / f'BossRushHD-android-arm64-{game_version(GAME)}.apk'
    shutil.copy2(output, release)
    write_utf8(dist / (release.name + '.sha256'), digest + '  ' + release.name + '\n')
    write_utf8(BUILD / 'packaged-manifest.sha256',
               hashlib.sha256((BUILD / 'AndroidManifest.xml').read_bytes()).hexdigest())
    print(f'发行包：{release}', flush=True)


def main():
    global GAME
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--game-root', type=Path, help='从指定的游戏源码快照打包，隔离工作区其他未提交改动')
    parser.add_argument('--engine-archive')
    parser.add_argument('--assets-only', action='store_true')
    parser.add_argument('--package-only', action='store_true')
    parser.add_argument('--update-assets', '--update-lua', dest='update_assets', action='store_true', help='复用已经生成的原生库，更新 assets 并重新签名')
    parser.add_argument('--jobs', type=int, default=min(os.cpu_count() or 4, 8))
    args = parser.parse_args()
    if args.game_root:
        GAME = args.game_root.resolve()
        if not (GAME / 'core.lua').is_file():
            parser.error('--game-root 必须包含 core.lua')
    BUILD.mkdir(exist_ok=True)
    manifest = prepare_manifest()
    prepare_engine(args.engine_archive)
    assets = prepare_assets()
    if args.assets_only:
        return
    sdk = Path(os.environ.get('ANDROID_HOME', str(Path.home() / 'Library/Android/sdk')))
    ndk = Path(os.environ.get('ANDROID_NDK_HOME', str(sdk / 'ndk' / LOCK['ndk'])))
    if args.update_assets:
        unsigned = BUILD / 'unsigned.apk'
        if not unsigned.exists():
            raise RuntimeError('请先完成一次完整构建')
        previous = BUILD / 'packaged-manifest.sha256'
        if not previous.exists() or previous.read_text().strip() != hashlib.sha256(manifest.read_bytes()).hexdigest():
            # 安装清单在APK的二进制资源中；版本变更不能只替换Lua后沿用旧清单。
            package_apk(sdk, ndk, assets)
            return
        current = {p.relative_to(BUILD).as_posix(): p for p in assets.rglob('*') if p.is_file()}
        changed = []
        with zipfile.ZipFile(unsigned) as archive:
            if any(name.startswith('assets/') and name not in current for name in archive.namelist()):
                package_apk(sdk, ndk, assets)
                return
            for name, path in current.items():
                try:
                    entry = archive.getinfo(name)
                except KeyError:
                    changed.append(name)
                    continue
                crc = 0
                with path.open('rb') as resource:
                    while chunk := resource.read(1024*1024):
                        crc = zlib.crc32(chunk, crc)
                if entry.file_size != path.stat().st_size or entry.CRC != crc or entry.compress_type != asset_compression(path):
                    changed.append(name)
        if changed:
            # Windows 没有系统 zip；统一用 Python 更新，也保证中文文件名带 UTF-8 标记。
            changed_names = set(changed)
            replacement = BUILD / 'updated.apk'
            with zipfile.ZipFile(unsigned) as source, zipfile.ZipFile(
                    replacement, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as target:
                for entry in source.infolist():
                    if entry.filename not in changed_names:
                        target.writestr(entry, source.read(entry))
                for name in sorted(changed):
                    target.write(current[name], name, compress_type=asset_compression(current[name]))
            replacement.replace(unsigned)
        tools = max((sdk / 'build-tools').iterdir(), key=lambda p: tuple(map(int, p.name.split('.'))))
        java_home = os.environ.get('JAVA_HOME')
        keytool = executable(Path(java_home) / 'bin', 'keytool') if java_home else Path(shutil.which('keytool'))
        sign_apk(tools, keytool, unsigned)
        return
    if not (ndk / 'build/cmake/android.toolchain.cmake').exists():
        raise RuntimeError(f'缺少 NDK {LOCK["ndk"]}：{ndk}')
    if not args.package_only:
        native_build(sdk, ndk, args.jobs)
    package_apk(sdk, ndk, assets)


if __name__ == '__main__':
    main()
