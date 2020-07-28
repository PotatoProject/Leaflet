package com.potatoproject.notes

import android.content.Context
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Color
import android.os.Handler
import app.loup.streams_channel.StreamsChannel
import app.loup.streams_channel.StreamsChannel.StreamHandlerFactory
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

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        
    }

    class AccentStreamHandler(private val mContext: Context) : EventChannel.StreamHandler {
        private val handler = Handler()
        private var eventSink: EventSink? = null
        private var themeMode: Boolean? = null
        private var accentColor: Int? = null

        private val runnable: Runnable = object: Runnable {
            override fun run() {
                val sharedPref = mContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                val savedThemeMode = sharedPref.getLong("flutter.theme_mode", 0)
                val currentThemeMode = isCurrentThemeDark()
                val lightAccent = getColorRes("accent_device_default_light")
                val darkAccent = getColorRes("accent_device_default_dark")

                if (savedThemeMode == 0L) {
                    if (currentThemeMode != themeMode) {
                        themeMode = currentThemeMode
                        accentColor = if (themeMode ?: true) lightAccent else darkAccent
                        eventSink?.success(accentColor)
                    } else {
                        if (themeMode ?: false) {
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
                }
                handler.postDelayed(this, 50)
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
            themeMode = null
            accentColor = null
        }

        fun getColorRes(resName: String): Int {
            var resId: Int = 0
            var res: Resources? = null
            var colorInt: Int? = null

            if(android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.M) {
                return -1;
            }

            try {
                res = mContext.getPackageManager().getResourcesForApplication("android")
                resId = res.getIdentifier(resName, "color", "android")
            } catch (e: PackageManager.NameNotFoundException) {
                return -1
            }

            try {
                colorInt = res?.getColor(resId) ?: 0
            } catch (e: Resources.NotFoundException) {
                colorInt = -1
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