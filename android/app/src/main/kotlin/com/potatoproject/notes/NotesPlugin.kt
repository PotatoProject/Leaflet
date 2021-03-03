package com.potatoproject.notes

import android.content.Context
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Color
import android.os.Handler
import android.provider.Settings
import android.util.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

class NotesPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        EventChannel(binding.binaryMessenger, "potato_notes_accents").setStreamHandler(
            AccentStreamHandler(binding.applicationContext)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}

    class AccentStreamHandler(private val mContext: Context) : EventChannel.StreamHandler {
        private val handler = Handler(mContext.mainLooper)
        private var eventSink: EventSink? = null
        private var isThemeDark: Boolean? = null
        private var savedThemeMode: Long? = null
        private var accentColor: Int? = null

        private val runnable: Runnable = object: Runnable {
            override fun run() {
                val sharedPref = mContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                val currentSavedThemeMode = sharedPref.getLong("flutter.theme_mode", 0)
                val isCurrentlyThemeDark = isCurrentThemeDark()
                val lightAccent = getColorRes("accent_device_default_light")
                val darkAccent = getColorRes("accent_device_default_dark")

                if(currentSavedThemeMode != savedThemeMode) {
                    savedThemeMode = currentSavedThemeMode
                    isThemeDark = isCurrentlyThemeDark
                    when(savedThemeMode) {
                        0L -> accentColor = if (isThemeDark == true) darkAccent else lightAccent
                        1L -> accentColor = lightAccent
                        2L -> accentColor = darkAccent
                    }
                    eventSink?.success(accentColor)
                } else if(currentSavedThemeMode == 0L && isThemeDark != isCurrentlyThemeDark) {
                    isThemeDark = isCurrentlyThemeDark
                    accentColor = if (isThemeDark == true) darkAccent else lightAccent
                    eventSink?.success(accentColor)
                }

                /*if (savedThemeMode == 0L) {
                    if (currentThemeMode != themeMode) {
                        themeMode = currentThemeMode
                        accentColor = if (themeMode != false) lightAccent else darkAccent
                        eventSink?.success(accentColor)
                    } else {
                        if (themeMode == true) {
                            if (darkAccent != accentColor) {
                                accentColor = darkAccent
                                eventSink?.success(accentColor)
                            }
                        } else {
                            if (lightAccent != accentColor) {
                                accentColor = lightAccent
                                eventSink?.success(accentColor)
                            }
                        }
                    }
                } else {
                    if (savedThemeMode == 1L) {
                        if (lightAccent != accentColor) {
                            accentColor = lightAccent
                            eventSink?.success(accentColor)
                        }
                    } else if (savedThemeMode == 2L) {
                        if (darkAccent != accentColor) {
                            accentColor = darkAccent
                            eventSink?.success(accentColor)
                        }
                    }
                }*/
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
            var resId: Int
            var res: Resources?
            var colorInt: Int?

            if(android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.M) {
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
}