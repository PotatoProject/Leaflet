package com.potatoproject.notes

import android.graphics.drawable.Drawable
import android.widget.ImageView.ScaleType

import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.getPlugins().add(NotesPlugin())
    }

    override fun provideSplashScreen(): SplashScreen? {
        var manifestSplashDrawable: Drawable = resources.getDrawable(R.drawable.launch_background, theme)
        
        return DrawableSplashScreen(manifestSplashDrawable, ScaleType.FIT_XY, 0)
    }
}