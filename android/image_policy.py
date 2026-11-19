"""非核心图片白名单；未明确识别的图片一律按核心资源处理。"""
from pathlib import PurePosixPath
from pathlib import Path
import json
import re

DECORATIVE_IMAGES=json.loads(Path(__file__).with_name('decorative_images.json').read_text(encoding='utf-8'))
# 这些透明背景的 RGB 量化在 GLES 混合后误差会放大一档，保留无损。
GPU_EXACT_IMAGES={
    'Resources/th39/scene/bg2-32.png',
    'Resources/th39/scene/2-19.png',
    'Resources/th39/scene/4bgs-01.png',
}

def noncore_category(path):
    path = str(path).replace('\\', '/')
    if path in GPU_EXACT_IMAGES:
        return None
    if path in DECORATIVE_IMAGES:
        return DECORATIVE_IMAGES[path]
    if path=='Resources/ports/theis/res/ui/ui_stage_bg_16_9_1.png':
        return '祈华梦场外界面背景'
    if path.startswith('Resources/th43/performer/'):
        return '栖霞园开符立绘与界面演出'
    if path.startswith('Resources/th43/boss/Sonia/red_moon/'):
        return '栖霞园旧月亮背景序列'
    if path.startswith('Resources/th39/5bg-'):
        return '永夜篇五面场景纹理'
    if path in {'THlib/UI/ui_bg.png', 'THlib/UI/ui_bg2.png', 'THlib/UI/menu_bg.png',
                'THlib/UI/menu_bg2.png', 'THlib/UI/menu_bg_sub.png', 'THlib/UI/loading.png'}:
        return '菜单与界面背景'
    if path.startswith('Resources/Special/') and path.endswith('_player_tachie.png'):
        return '菜单角色立绘'
    if re.fullmatch(r'mod/GAME/stage_pic(?:29|30|31|32|33)\.png', path):
        return '五作关卡预览'
    if path.startswith('Resources/BossBackGround/'):
        return '符卡背景'
    if path.startswith('mod/BG/'):
        return '道中背景'
    if path.startswith('Resources/Original/') and re.match(r'(stg\d+bg|stage\d+_|world\d+_)', PurePosixPath(path).name):
        return '原作场景纹理'
    if path.startswith((
        'Resources/th37/scene/', 'Resources/th37/media/',
        'Resources/th38/background/', 'Resources/th38/media/',
        'Resources/th39/scene/', 'Resources/th39/media/',
        'Resources/th40/Background/', 'Resources/th40/scene/', 'Resources/th43/background/',
        'Resources/ports/theis/res/background/',
        'Resources/ports/dreamer/res/likedreamer/optimized/background/',
    )):
        return '同人作品场景纹理'
    if path.startswith('Resources/th43/boss/') and (
        re.fullmatch(r'scbg\d*\.png', PurePosixPath(path).name) or '/bgch/' in path
    ):
        return '栖霞园符卡背景'
    if path == 'mod/th16AEX.png':
        return '旧入口预览'
    return None
