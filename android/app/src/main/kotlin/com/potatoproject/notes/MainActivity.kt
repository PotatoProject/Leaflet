package com.potatoproject.notes

import android.graphics.drawable.Drawable
import android.graphics.Color
import android.os.Build
import android.view.View
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
        var manifestSplashDrawable: Drawable = getResources().getDrawable(R.drawable.launch_background, getTheme())
        
        return DrawableSplashScreen(manifestSplashDrawable, ScaleType.FIT_XY, 700)
    }
}