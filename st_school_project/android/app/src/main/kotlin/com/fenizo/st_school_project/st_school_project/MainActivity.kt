//package com.fenizo.st_school_project.st_school_project
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity : FlutterActivity()
package com.fenizo.st_school_project.st_school_project

import android.content.ContentValues
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "file_downloader"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveToDownloads") {
                val name = call.argument<String>("name")
                val bytes = call.argument<ByteArray>("bytes")

                if (name == null || bytes == null) {
                    result.success(false)
                    return@setMethodCallHandler
                }

                try {
                    val resolver = contentResolver
                    val contentValues = ContentValues().apply {
                        put(MediaStore.Downloads.DISPLAY_NAME, name)
                        put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                        put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                    }

                    val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
                    uri?.let {
                        resolver.openOutputStream(it)?.use { output ->
                            output.write(bytes)
                            output.flush()
                        }
                        result.success(true)
                    } ?: result.success(false)
                } catch (e: Exception) {
                    e.printStackTrace()
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
