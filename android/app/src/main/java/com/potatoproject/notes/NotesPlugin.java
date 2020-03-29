package com.potatoproject.notes;

import android.content.Context;
import android.os.Handler;
import android.util.Log;

import app.loup.streams_channel.StreamsChannel;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class NotesPlugin implements FlutterPlugin {
    public static void registerWith(PluginRegistry.Registrar registrar) {
        new StreamsChannel(registrar.messenger(), "potato_notes_accents").setStreamHandlerFactory(
            args -> new AccentStreamHandler(registrar.context())
        );

        new StreamsChannel(registrar.messenger(), "potato_notes_themes").setStreamHandlerFactory(
            args -> new ThemeStreamHandler(registrar.context())
        );
    }
    
    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        new StreamsChannel(binding.getBinaryMessenger(), "potato_notes_accents").setStreamHandlerFactory(
            args -> new AccentStreamHandler(binding.getApplicationContext())
        );

        new StreamsChannel(binding.getBinaryMessenger(), "potato_notes_themes").setStreamHandlerFactory(
            args -> new ThemeStreamHandler(binding.getApplicationContext())
        );
    }
    
    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
    
    }
    
    public static class AccentStreamHandler implements EventChannel.StreamHandler {
        public AccentStreamHandler(Context context) {
          this.mContext = context;
        }
    
        private final Context mContext;
        private final Handler handler = new Handler();
        private EventChannel.EventSink eventSink;
        private Boolean themeMode;
        private Integer accentColor;
    
        private final Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Boolean currentThemeMode = Utils.isCurrentThemeDark(mContext);
                Integer lightAccent = Utils.getLightAccentColor(mContext);
                Integer darkAccent = Utils.getDarkAccentColor(mContext);
        
                if(themeMode != currentThemeMode) {
                    themeMode = currentThemeMode;
                    accentColor = themeMode
                        ? lightAccent
                        : darkAccent;
                    eventSink.success(accentColor);
                } else {
                    if(themeMode) {
                        if(accentColor != darkAccent) {
                            accentColor = darkAccent;
                            eventSink.success(accentColor);
                        }
                    } else {
                        if(accentColor != lightAccent) {
                            accentColor = lightAccent;
                            eventSink.success(accentColor);
                        }
                    }
                }
    
                handler.postDelayed(this, 50);
            }
        };
    
        @Override
        public void onListen(Object o, final EventChannel.EventSink eventSink) {
            this.eventSink = eventSink;
            runnable.run();
        }
    
        @Override
        public void onCancel(Object o) {
            if(o != null) {
                handler.removeCallbacks(runnable);
            }

            themeMode = null;
            accentColor = null;
        }
    }
    
    public static class ThemeStreamHandler implements EventChannel.StreamHandler {
        public ThemeStreamHandler(Context context) {
            this.mContext = context;
        }
    
        private final Context mContext;
        private final Handler handler = new Handler();
        private EventChannel.EventSink eventSink;
        private Boolean themeMode;
    
        private final Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Boolean currentThemeMode = Utils.isCurrentThemeDark(mContext);
                if(themeMode != currentThemeMode) {
                    themeMode = currentThemeMode;
                    eventSink.success(themeMode);
                }
        
                handler.postDelayed(this, 50);
            }
        };
    
        @Override
        public void onListen(Object o, final EventChannel.EventSink eventSink) {
            this.eventSink = eventSink;
            runnable.run();
        }
    
        @Override
        public void onCancel(Object o) {
            if(o != null) {
                handler.removeCallbacks(runnable);
            }

            themeMode = null;
        }
    }
}