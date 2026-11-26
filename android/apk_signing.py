"""固定安卓签名身份；仓库保存加密密钥库，密码由环境变量或本地文件提供。"""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess

SIGNING_DIR = Path(__file__).resolve().parent / 'signing'
PASSWORD_ENV = 'BOSSRUSH_ANDROID_SIGNING_PASSWORD'


def load_identity(keytool):
    identity = json.loads((SIGNING_DIR / 'identity.json').read_text(encoding='utf-8'))
    keystore = SIGNING_DIR / identity['keystore']
    if not keystore.is_file():
        raise RuntimeError(f'缺少固定签名密钥库：{keystore}，不会自动生成新密钥')
    password = os.environ.get(PASSWORD_ENV)
    password_file = SIGNING_DIR / 'password.local'
    if password is None and password_file.is_file():
        password = password_file.read_text(encoding='utf-8').strip()
    if not password:
        raise RuntimeError(f'请设置 {PASSWORD_ENV}，或将签名密码保存到 {password_file}')
    env = os.environ.copy()
    env[PASSWORD_ENV] = password
    # 密码不进入命令行参数和构建日志；导出公钥证书核对既有安装包的身份。
    result = subprocess.run([str(keytool), '-exportcert', '-keystore', str(keystore),
        '-storetype', identity['store_type'], '-alias', identity['alias'],
        '-storepass:env', PASSWORD_ENV], env=env, capture_output=True)
    if result.returncode:
        raise RuntimeError('无法解密固定签名密钥库，请检查签名密码')
    if hashlib.sha256(result.stdout).hexdigest() != identity['certificate_sha256']:
        raise RuntimeError('签名证书与仓库固定身份不一致，已停止打包')
    return identity, keystore, env


def verify_certificate(output, identity):
    digests = re.findall(r'^Signer #\d+ certificate SHA-256 digest: ([0-9a-fA-F]+)\s*$',
                         output, re.MULTILINE)
    if [digest.lower() for digest in digests] != [identity['certificate_sha256']]:
        raise RuntimeError('APK签名证书与固定身份不一致，不能交付')


if __name__ == '__main__':
    java_home = os.environ.get('JAVA_HOME')
    keytool = (Path(java_home) / 'bin' / ('keytool.exe' if os.name == 'nt' else 'keytool')
               if java_home else shutil.which('keytool'))
    if not keytool:
        raise SystemExit('缺少JDK keytool')
    identity, _, _ = load_identity(keytool)
    print('固定签名证书 SHA-256：' + identity['certificate_sha256'])
