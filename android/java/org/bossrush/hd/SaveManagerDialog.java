package org.bossrush.hd;

import android.Manifest;
import android.app.Activity;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.PermissionRequest;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

/** 只允许本机存档服务的 WebView；相机、剪贴板与系统文件选择器按用户操作开启。 */
final class SaveManagerDialog extends Dialog {
    private static final int CAMERA = 6101, OPEN = 6102, SAVE = 6103;
    private final Activity activity;
    private final WebView web;
    private final String origin;
    private PermissionRequest cameraRequest;
    private ValueCallback<Uri[]> fileCallback;
    private String pendingSave;
    private boolean destroyed;

    SaveManagerDialog(Activity activity, String url) {
        super(activity, android.R.style.Theme_Material_Light_NoActionBar_Fullscreen);
        this.activity = activity;
        Uri uri = Uri.parse(url);
        if (!"http".equals(uri.getScheme()) || !"127.0.0.1".equals(uri.getHost()) || uri.getPort() < 1024 ||
            !"/".equals(uri.getPath()) || uri.getFragment() == null || !uri.getFragment().startsWith("token=")) {
            throw new IllegalArgumentException("存档管理地址无效");
        }
        origin = "http://127.0.0.1:" + uri.getPort();
        web = new WebView(activity);
        WebSettings settings = web.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setAllowFileAccess(false);
        settings.setAllowContentAccess(true);
        settings.setCacheMode(WebSettings.LOAD_NO_CACHE);
        settings.setMediaPlaybackRequiresUserGesture(false);
        settings.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
        web.setWebViewClient(new WebViewClient() {
            @Override public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                Uri target = request.getUrl();
                return !("http".equals(target.getScheme()) && "127.0.0.1".equals(target.getHost()) && target.getPort() == uri.getPort());
            }
        });
        web.setWebChromeClient(new WebChromeClient() {
            @Override public void onPermissionRequest(PermissionRequest request) {
                activity.runOnUiThread(() -> {
                    if (!request.getOrigin().toString().replaceAll("/$", "").equals(origin)) { request.deny(); return; }
                    for (String resource : request.getResources()) {
                        if (!PermissionRequest.RESOURCE_VIDEO_CAPTURE.equals(resource)) { request.deny(); return; }
                    }
                    if (activity.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                        request.grant(new String[]{PermissionRequest.RESOURCE_VIDEO_CAPTURE});
                    } else {
                        if (cameraRequest != null) cameraRequest.deny();
                        cameraRequest = request;
                        activity.requestPermissions(new String[]{Manifest.permission.CAMERA}, CAMERA);
                    }
                });
            }
            @Override public void onPermissionRequestCanceled(PermissionRequest request) {
                if (cameraRequest == request) cameraRequest = null;
            }
            @Override public boolean onShowFileChooser(WebView view, ValueCallback<Uri[]> callback, FileChooserParams params) {
                if (fileCallback != null) fileCallback.onReceiveValue(null);
                fileCallback = callback;
                try {
                    Intent intent = params.createIntent();
                    intent.addCategory(Intent.CATEGORY_OPENABLE);
                    activity.startActivityForResult(intent, OPEN);
                } catch (RuntimeException error) {
                    fileCallback.onReceiveValue(null); fileCallback = null;
                    Toast.makeText(activity, "无法打开文件选择器", Toast.LENGTH_SHORT).show();
                }
                return true;
            }
        });
        web.addJavascriptInterface(new Object() {
            @JavascriptInterface public boolean copy(String value) {
                if (value == null || value.length() > 800000) return false;
                try {
                    ((ClipboardManager) activity.getSystemService(Activity.CLIPBOARD_SERVICE)).setPrimaryClip(ClipData.newPlainText("Boss Rush 存档", value));
                    return true;
                } catch (RuntimeException error) { return false; }
            }
            @JavascriptInterface public String paste() {
                ClipboardManager manager = (ClipboardManager) activity.getSystemService(Activity.CLIPBOARD_SERVICE);
                ClipData clip = manager.getPrimaryClip();
                return clip == null || clip.getItemCount() == 0 ? "" : clip.getItemAt(0).coerceToText(activity).toString();
            }
            @JavascriptInterface public void close() { activity.runOnUiThread(SaveManagerDialog.this::dismiss); }
            @JavascriptInterface public void save(String value) {
                if (value == null || value.length() > 24 * 1024 * 1024) return;
                activity.runOnUiThread(() -> {
                    pendingSave = value;
                    Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT).addCategory(Intent.CATEGORY_OPENABLE)
                        .setType("application/octet-stream").putExtra(Intent.EXTRA_TITLE, "BossRush.brsave");
                    activity.startActivityForResult(intent, SAVE);
                });
            }
        }, "BossRushNative");
        setContentView(web, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        web.loadUrl(url);
    }

    void permissionResult(int code, int[] results) {
        if (code != CAMERA || cameraRequest == null) return;
        if (results.length > 0 && results[0] == PackageManager.PERMISSION_GRANTED) cameraRequest.grant(new String[]{PermissionRequest.RESOURCE_VIDEO_CAPTURE});
        else cameraRequest.deny();
        cameraRequest = null;
    }

    boolean activityResult(int code, int result, Intent data) {
        if (code == OPEN) {
            if (fileCallback != null) fileCallback.onReceiveValue(WebChromeClient.FileChooserParams.parseResult(result, data));
            fileCallback = null; return true;
        }
        if (code == SAVE) {
            String value = pendingSave; pendingSave = null;
            if (result == Activity.RESULT_OK && data != null && data.getData() != null && value != null) {
                Uri destination = data.getData();
                new Thread(() -> {
                    try (OutputStream out = activity.getContentResolver().openOutputStream(destination)) {
                        if (out == null) throw new IllegalStateException("无法打开目标文件");
                        out.write(value.getBytes(StandardCharsets.UTF_8));
                        activity.runOnUiThread(() -> Toast.makeText(activity, "存档文件已保存", Toast.LENGTH_SHORT).show());
                    } catch (Exception error) {
                        activity.runOnUiThread(() -> Toast.makeText(activity, "存档文件保存失败", Toast.LENGTH_LONG).show());
                    }
                }, "BossRushSaveExport").start();
            }
            return true;
        }
        return false;
    }

    @Override public void dismiss() {
        if (destroyed) return;
        destroyed = true;
        if (cameraRequest != null) { cameraRequest.deny(); cameraRequest = null; }
        if (fileCallback != null) { fileCallback.onReceiveValue(null); fileCallback = null; }
        web.stopLoading(); web.removeJavascriptInterface("BossRushNative"); web.destroy();
        super.dismiss();
    }
}
