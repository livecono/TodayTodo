package com.eunchan.todaytodo;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;

import androidx.core.content.FileProvider;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@CapacitorPlugin(name = "Update")
public class UpdatePlugin extends Plugin {
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @PluginMethod
    public void downloadAndInstall(PluginCall call) {
        String apkUrl = call.getString("apkUrl", "");
        if (apkUrl.isEmpty() || !(apkUrl.startsWith("https://") || apkUrl.startsWith("http://"))) {
            call.reject("유효한 APK 다운로드 주소가 없습니다.");
            return;
        }
        executor.execute(() -> {
            HttpURLConnection connection = null;
            try {
                connection = (HttpURLConnection) new URL(apkUrl).openConnection();
                connection.setConnectTimeout(15000);
                connection.setReadTimeout(60000);
                connection.setInstanceFollowRedirects(true);
                connection.connect();
                if (connection.getResponseCode() < 200 || connection.getResponseCode() >= 300) {
                    throw new Exception("APK 다운로드 실패: HTTP " + connection.getResponseCode());
                }
                if (connection.getContentLengthLong() == 0) throw new Exception("빈 APK 파일입니다.");
                File apkFile = new File(getContext().getCacheDir(), "today-todo-update.apk");
                try (InputStream input = connection.getInputStream(); FileOutputStream output = new FileOutputStream(apkFile)) {
                    byte[] buffer = new byte[8192];
                    int count;
                    while ((count = input.read(buffer)) != -1) output.write(buffer, 0, count);
                }
                Uri apkUri = FileProvider.getUriForFile(getContext(), getContext().getPackageName() + ".fileprovider", apkFile);
                Intent installIntent = new Intent(Intent.ACTION_VIEW);
                installIntent.setDataAndType(apkUri, "application/vnd.android.package-archive");
                installIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_ACTIVITY_NEW_TASK);
                getActivity().runOnUiThread(() -> {
                    getActivity().startActivity(installIntent);
                    call.resolve(new JSObject());
                });
            } catch (Exception error) {
                getActivity().runOnUiThread(() -> call.reject(error.getMessage(), error));
            } finally {
                if (connection != null) connection.disconnect();
            }
        });
    }
}