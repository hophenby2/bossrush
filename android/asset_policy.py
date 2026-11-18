"""安卓入包裁剪，Like Dreamer 的旧图集与菜单已由切片和宿主界面替代。"""
from pathlib import PurePosixPath
import re


DREAMER = 'Resources/ports/dreamer/res/likedreamer/'
DREAMER_BACKGROUNDS = {
    'StageBack1.png', 'StageBack1b.png', 'StageBack1c.png', 'StageBack1d.png',
    'StageBack2.png', 'Stage2Back.png', 'Stage3Back.png', 'Stage6Back.png',
    'Stage8Back1.png', 'Stage8Back2.png',
}
DREAMER_SYSTEM = {'ConfigNumber.png', 'Num_s.png', 'TextBox.png', 'TextIcon.png', 'WhiteBack.png'}


def native_font_images(root):
    images = set()
    for folder in ('THlib', 'Resources', 'mod'):
        for font in (root/folder).rglob('*.fnt'):
            text = font.read_text(encoding='utf-8-sig')
            for bitmap, page in re.findall(r'(?im)^\s*Bitmap\s*=\s*([^\r\n]+)|\bfile="([^"]+)"', text):
                image = font.parent/(bitmap or page).strip().strip('"').replace('\\', '/')
                images.add(image.resolve())
    return images


def include_asset(path):
    path = str(path).replace('\\', '/')
    if not path.startswith(DREAMER):
        return True
    relative = PurePosixPath(path[len(DREAMER):])
    folder, name = relative.parent.as_posix(), relative.name
    if folder == 'stage' and name in DREAMER_BACKGROUNDS:
        return False
    if folder == 'system' and relative.suffix == '.png':
        return name in DREAMER_SYSTEM
    if folder == 'player' and relative.suffix == '.png':
        return not name.startswith(('Pause', 'Unlock', 'StageClear'))
    if folder == 'bgm' and relative.suffix == '.ogg':
        return re.fullmatch(r'(Stage(?:[1-9]|10)|Boss[1-5])\.ogg', name) is not None
    return True
