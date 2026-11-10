"""非核心图片白名单；未明确识别的图片一律按核心资源处理。"""
from pathlib import PurePosixPath
import re


def noncore_category(path):
    path = str(path).replace('\\', '/')
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
    if path == 'mod/th16AEX.png':
        return '旧入口预览'
    return None
