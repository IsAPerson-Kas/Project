package com.example.media_guard_v2

import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity

import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {

    private val shareChanel = "vn.tinasoft.native_share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shareChanel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "shareFiles" -> {
                        val paths = call.argument<List<String>>("paths") ?: emptyList()
                        val text = call.argument<String>("text") ?: ""
                        shareFiles(paths, text)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun shareFiles(paths: List<String>, text: String) {
        val uris = ArrayList<Uri>()
        for (p in paths) {
            val f = File(p)
            if (f.exists()) {
                val uri = FileProvider.getUriForFile(
                    this,
                    "com.example.media_guard.fileprovider",
                    f
                )
                uris.add(uri)
            }
        }
        if (uris.isEmpty()) return

        val sendIntent = Intent().apply {
            action = if (uris.size == 1) Intent.ACTION_SEND else Intent.ACTION_SEND_MULTIPLE
            type = "*/*"
            if (uris.size == 1)
                putExtra(Intent.EXTRA_STREAM, uris[0])
            else
                putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
            putExtra(Intent.EXTRA_TEXT, text)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        val chooser = Intent.createChooser(sendIntent, "Chia sẻ qua")
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)   // tách task → tránh Zalo “đóng băng”

        startActivity(chooser)
    }
}
