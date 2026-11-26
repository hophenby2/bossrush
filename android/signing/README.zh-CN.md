# 固定安卓签名

`bossrush.p12` 是从既有 `android/.cache/debug.keystore` 迁移的加密 PKCS12 密钥库，保留同一把私钥和证书，仅更换密钥库密码。`identity.json` 固定别名与证书 SHA-256；构建前检查密钥库证书，签名后再次检查 APK 证书。不再因缓存缺失自动生成另一把密钥。

加密密钥库和签名逻辑纳入 Git；解密密码不入 Git，也不进入 APK 或构建日志。

本机已经配置 `android/signing/password.local`，直接执行原有构建命令即可。换机器时，从本机安全复制该文件到相同位置，或设置 `BOSSRUSH_ANDROID_SIGNING_PASSWORD` 环境变量。环境变量优先于本地文件；CI 应使用其秘密变量存储提供密码。密码文件在 Unix 下应只允许当前用户读写（`chmod 600 android/signing/password.local`）。请另外保存密码备份，仅克隆仓库不能恢复密码。

```sh
# 单独核对签名材料，不构建游戏
python3 android/apk_signing.py

# 基于当前代码完整构建，沿用既有签名
python3 android/build.py --compression-profile 500mb
```

签名身份的公开证书 SHA-256：

`5cf38a5e916314d33034b905523e48f878d38479d3de3c0059aac9777081e2db`

这里固定的是安卓签名身份，重新构建的 APK 文件哈希可以不同。macOS 的本地临时签名仍使用原有构建方式。
