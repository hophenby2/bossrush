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
LOCK = json.loads((ROOT / 'engine.lock.json').read_text())
ENGINE = CACHE / 'LuaSTG-x'
NATIVE = BUILD / 'native-gfx'


def run(*args, **kwargs):
    print('+', ' '.join(map(str, args)), flush=True)
    subprocess.run(list(map(str, args)), check=True, **kwargs)


def copy_tree(source, target):
    shutil.copytree(source, target, dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('.git', '.DS_Store', '*.bat'))


def prepare_shaders(target):
    # GFX 通过 glslang 生成 SPIR-V，再转换为设备的 GLES shader；必须显式声明位置和 uniform 块。
    for source in (ROOT / 'shaders').glob('*.frag'):
        text = source.read_text()
        uniforms = re.findall(r'^uniform vec4 (\w+);$', text, re.MULTILINE)
        text = re.sub(r'^uniform vec4 \w+;\n', '', text, flags=re.MULTILINE)
        text = text.replace('uniform sampler2D u_texture;', 'layout(binding=2) uniform sampler2D u_texture;')
        text = text.replace('varying vec2 v_texCoord;', 'layout(location=1) in mediump vec2 v_texCoord;')
        text = text.replace('gl_FragColor', 'cc_FragColor').replace('texture2D(', 'texture(')
        block = 'layout(std140, binding=1) uniform FSBlock {\n' + ''.join(
            '    vec4 ' + name + ';\n' for name in uniforms) + '};\n' if uniforms else ''
        prefix = 'precision mediump float;\nlayout(location=0) out vec4 cc_FragColor;\n' + block
        (target / source.name).write_text(prefix + text)
    (target / 'common.vert').write_text('''precision highp float;
layout(location=0) in vec4 a_position;
layout(location=1) in vec4 a_color;
layout(location=2) in vec2 a_texCoord;
layout(std140, binding=0) uniform VSBlock { mat4 u_MVPMatrix; };
layout(location=0) out lowp vec4 v_fragmentColor;
layout(location=1) out mediump vec2 v_texCoord;
void main() {
    gl_Position = u_MVPMatrix * a_position;
    v_texCoord = a_texCoord;
    v_fragmentColor = a_color;
}
''')


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


def prepare_assets():
    assets = BUILD / 'assets'
    if assets.exists():
        shutil.rmtree(assets)
    assets.mkdir(parents=True, exist_ok=True)
    copy_tree(ENGINE / 'src', assets / 'src')
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
                target.write_text(source.read_text(encoding='utf-8-sig'), encoding='utf-8')
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
    (destination / 'asset_index.lua').write_text('return ' + '{\n' + ''.join(
        '  ' + json.dumps(p, ensure_ascii=False) + ',\n' for p in paths) + '}\n')
    (destination / 'asset_dimensions.lua').write_text('return {\n' + ''.join(
        '  [' + json.dumps(p, ensure_ascii=False) + ']={' + str(size[0]) + ',' + str(size[1]) + '},\n'
        for p, size in sorted(dimensions.items())) + '}\n')
    copy_tree(ROOT / 'lua', destination / 'android')
    copy_tree(ROOT / 'shaders', destination / 'android' / 'shaders')
    prepare_shaders(destination / 'android' / 'shaders')
    modes = (ENGINE / 'src/core/corefunc.lua').read_text()
    modes = modes.split('local shader_path = ', 1)[1].split('local _capture = {}', 1)[0]
    modes = modes.replace("lstg.RenderMode:getByName(''):setAsDefault()",
                          "lstg.RenderMode:getDefault():setProgram(lstg.RenderMode:getByName(''):getProgram())")
    (destination / 'android/render_modes.lua').write_text(
        '-- 来自固定版本 LuaSTG-x core/corefunc.lua 的渲染模式与雾效。\nlocal shader_path = ' + modes)
    shutil.copy2(ROOT / 'lua' / 'main.lua', assets / 'src' / 'main.lua')
    for source in ENGINE.rglob('*'):
        if source.is_file() and source.name.lower() in {
            'license', 'license.txt', 'license.md', 'copying', 'copying.txt',
            'copyright', 'copyright.txt', 'notice', 'notice.txt', 'authors', 'authors.txt',
        }:
            target = assets / 'licenses' / source.relative_to(ENGINE)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, target)
    (assets / 'licenses' / 'SOURCE.txt').write_text(
        'LuaSTG-x 20260913 及其随包依赖的源码与许可证来自：\n' + LOCK['url'] +
        '\nSHA-256: ' + LOCK['sha256'] + '\nAndroid 适配变更见项目 android/patch_engine.py 和 android/native/。\n')
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
    native = NATIVE
    run('cmake', '-S', ENGINE, '-B', native, '-G', 'Ninja',
        f'-DCMAKE_TOOLCHAIN_FILE={ndk}/build/cmake/android.toolchain.cmake',
        '-DANDROID_ABI=arm64-v8a', '-DANDROID_PLATFORM=android-28',
        '-DANDROID_STL=c++_shared', '-DCMAKE_BUILD_TYPE=Release',
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
    javac = Path(java_home) / 'bin/javac' if java_home else Path(shutil.which('javac'))
    keytool = javac.parent / 'keytool'
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
    compiled = BUILD / 'resources.zip'
    if any(java_res.rglob('*.xml')):
        run(tools / 'aapt2', 'compile', '--dir', java_res, '-o', compiled)
        resource_args = [compiled]
    else:
        resource_args = []
    run(tools / 'aapt2', 'link', '-o', BUILD / 'resources.apk', '-I', android_jar,
        '--manifest', ROOT / 'AndroidManifest.xml', '--java', gen,
        '--auto-add-overlay', *resource_args)
    sources += list(gen.rglob('*.java'))
    source_list = BUILD / 'java-sources.txt'
    source_list.write_text('\n'.join('"' + str(p) + '"' for p in sources))
    run(javac, '-encoding', 'UTF-8', '-source', '11', '-target', '11',
        '-classpath', os.pathsep.join(map(str, [android_jar] + jars)), '-d', classes, '@' + str(source_list))
    dex = BUILD / 'dex'
    dex.mkdir(exist_ok=True)
    run(tools / 'd8', '--min-api', '28', '--lib', android_jar, '--output', dex,
        *sorted(classes.rglob('*.class')), *jars)
    unsigned = BUILD / 'unsigned.apk'
    shutil.copy2(BUILD / 'resources.apk', unsigned)
    libs = sorted(NATIVE.rglob('*.so'))
    if not any(p.name == 'libcocos2dlua.so' for p in libs):
        raise RuntimeError('原生引擎尚未生成 libcocos2dlua.so，不能生成空壳 APK')
    cpp = ndk / 'toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so'
    if not cpp.exists():
        cpp = next(ndk.glob('toolchains/llvm/prebuilt/*/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so'))
    libs.append(cpp)
    strip = next(ndk.glob('toolchains/llvm/prebuilt/*/bin/llvm-strip'))
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
                apk.write(path, 'assets/' + path.relative_to(assets).as_posix())
    sign_apk(tools, keytool, unsigned)


def sign_apk(tools, keytool, unsigned):
    aligned = BUILD / 'aligned.apk'
    run(tools / 'zipalign', '-f', '-p', '4', unsigned, aligned)
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
    run(tools / 'apksigner', 'sign', '--ks', keystore, '--ks-pass', 'pass:android',
        '--v4-signing-enabled', 'false', '--out', output, aligned)
    run(tools / 'apksigner', 'verify', '--verbose', output)
    digest = hashlib.file_digest(output.open('rb'), 'sha256').hexdigest()
    (dist / (output.name + '.sha256')).write_text(digest + '  ' + output.name + '\n')
    print(f'APK：{output}\nSHA-256：{digest}', flush=True)


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
                if entry.file_size != path.stat().st_size or entry.CRC != crc:
                    changed.append(name)
        if changed:
            run('zip', '-q', unsigned, *changed, cwd=BUILD)
        tools = max((sdk / 'build-tools').iterdir(), key=lambda p: tuple(map(int, p.name.split('.'))))
        java_home = os.environ.get('JAVA_HOME')
        keytool = Path(java_home) / 'bin/keytool' if java_home else Path(shutil.which('keytool'))
        sign_apk(tools, keytool, unsigned)
        return
    if not (ndk / 'build/cmake/android.toolchain.cmake').exists():
        raise RuntimeError(f'缺少 NDK {LOCK["ndk"]}：{ndk}')
    if not args.package_only:
        native_build(sdk, ndk, args.jobs)
    package_apk(sdk, ndk, assets)


if __name__ == '__main__':
    main()
