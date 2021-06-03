package com.potatoproject.notes

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.content.res.Resources
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.util.Log
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContract
import androidx.core.net.toFile

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class NotesPlugin(private val activity: MainActivity) : FlutterPlugin {
    var fileResult: ActivityResultLauncher<FileInputPayload> =
        activity.registerForActivityResult(CreateCustomDocument()) { payload: FileOutputPayload ->
            if (payload.outputUri != null) {
                FileTools.cloneOriginToResult(activity, payload.inputUri, payload.outputUri);

                payload.result.success(payload.outputUri.toString())
            } else {
                payload.result.success(null)
            }
        }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        EventChannel(binding.binaryMessenger, "potato_notes_accents").setStreamHandler(
            AccentStreamHandler(binding.applicationContext)
        )

        MethodChannel(
            binding.binaryMessenger,
            "potato_notes_file_prompt"
        ).setMethodCallHandler { call, result ->
            if (call.method == "requestFileExport") {
                val name: String? = call.argument<String>("name")
                val inputPath: String? = call.argument<String>("path");

                if (name != null && inputPath != null) {
                    fileResult.launch(
                        FileInputPayload(
                            name,
                            Uri.fromFile(File(inputPath)),
                            result
                        )
                    )
                } else {
                    result.success(null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}

    class AccentStreamHandler(private val mContext: Context) : EventChannel.StreamHandler {
        private val handler = Handler(mContext.mainLooper)
        private var eventSink: EventSink? = null
        private var isThemeDark: Boolean? = null
        private var savedThemeMode: Long? = null
        private var accentColor: Int? = null

        private val runnable: Runnable = object : Runnable {
            override fun run() {
                val sharedPref =
                    mContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                val currentSavedThemeMode = sharedPref.getLong("flutter.theme_mode", 0)
                val isCurrentlyThemeDark = isCurrentThemeDark()
                val lightAccent = getColorRes("accent_device_default_light")
                val darkAccent = getColorRes("accent_device_default_dark")

                if (currentSavedThemeMode != savedThemeMode) {
                    savedThemeMode = currentSavedThemeMode
                    isThemeDark = isCurrentlyThemeDark
                    when (savedThemeMode) {
                        0L -> accentColor = if (isThemeDark == true) darkAccent else lightAccent
                        1L -> accentColor = lightAccent
                        2L -> accentColor = darkAccent
                    }
                    eventSink?.success(accentColor)
                } else if (currentSavedThemeMode == 0L && isThemeDark != isCurrentlyThemeDark) {
                    isThemeDark = isCurrentlyThemeDark
                    accentColor = if (isThemeDark == true) darkAccent else lightAccent
                    eventSink?.success(accentColor)
                }
                handler.postDelayed(this, 125)
            }
        }

        override fun onListen(o: Any?, eventSink: EventSink?) {
            this.eventSink = eventSink
            runnable.run()
        }

        override fun onCancel(o: Any?) {
            if (o != null) {
                handler.removeCallbacks(runnable)
            }
            isThemeDark = null
            savedThemeMode = null
            accentColor = null
        }

        fun getColorRes(resName: String): Int {
            val resId: Int
            val res: Resources?
            val colorInt: Int?

            if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.M) {
                return -1;
            }

            try {
                res = mContext.packageManager.getResourcesForApplication("android")
                resId = res.getIdentifier(resName, "color", "android")
            } catch (e: PackageManager.NameNotFoundException) {
                return -1
            }

            colorInt = try {
                res.getColor(resId) ?: 0
            } catch (e: Resources.NotFoundException) {
                -1
            }

            return colorInt ?: 0
        }

        fun isCurrentThemeDark(): Boolean {
            return when (mContext.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) {
                Configuration.UI_MODE_NIGHT_YES -> true
                Configuration.UI_MODE_NIGHT_NO -> false
                else -> false
            }
        }
    }

    class CreateCustomDocument : ActivityResultContract<FileInputPayload, FileOutputPayload>() {
        private lateinit var result: MethodChannel.Result
        private lateinit var inputUri: Uri

        override fun createIntent(context: Context, input: FileInputPayload): Intent {
            result = input.result
            inputUri = input.inputUri

            return Intent(Intent.ACTION_CREATE_DOCUMENT)
                .setType("*/*")
                .putExtra(Intent.EXTRA_TITLE, input.name)
        }

        override fun getSynchronousResult(
            context: Context,
            input: FileInputPayload
        ): SynchronousResult<FileOutputPayload>? {
            return null
        }

        override fun parseResult(resultCode: Int, intent: Intent?): FileOutputPayload {
            val uri: Uri? =
                if (intent == null || resultCode != Activity.RESULT_OK) null else intent.data
            return FileOutputPayload(inputUri, uri, result)
        }
    }

    data class FileInputPayload(
        val name: String,
        val inputUri: Uri,
        val result: MethodChannel.Result
    )

    data class FileOutputPayload(
        val inputUri: Uri,
        val outputUri: Uri?,
        val result: MethodChannel.Result
    )

    object FileTools {
        fun cloneOriginToResult(context: Context, originUri: Uri, resultUri: Uri): Uri {
            FileInputStream(originUri.toFile()).use { inputStream ->
                context.contentResolver.openOutputStream(resultUri).use { outputStream ->
                    val buffer = ByteArray(4 * 1024)
                    while (true) {
                        val byteCount = inputStream.read(buffer)
                        if (byteCount < 0) break
                        outputStream!!.write(buffer, 0, byteCount)
                    }
                    outputStream!!.flush()
                }
            }
            return resultUri
        }
    }
}