"""发行包统一使用游戏界面声明的版本号。"""
from pathlib import Path
import re


def game_version(root):
    path = Path(root) / 'THlib/UI/UI.lua'
    source = path.read_text(encoding='utf-8-sig')
    match = re.search(r'''(?m)^\s*ui\.version\s*=\s*(["'])([^"']+)\1''', source)
    if not match:
        raise ValueError(f'找不到界面版本号：{path}')
    version = match[2].strip()
    if not version or re.search(r'[\\/:*?"<>|\x00-\x1f]', version):
        raise ValueError(f'界面版本号不能用于安装包文件名：{version!r}')
    return version
