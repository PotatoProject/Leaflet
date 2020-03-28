package com.potatoproject.notes;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import app.loup.streams_channel.StreamsChannel;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new StreamsChannel(getFlutterView(), "potato_notes_accents").setStreamHandlerFactory(
      args -> new AccentStreamHandler(this)
    );

    new StreamsChannel(getFlutterView(), "potato_notes_themes").setStreamHandlerFactory(
      args -> new ThemeStreamHandler(this)
    );
  }

  public static class AccentStreamHandler implements EventChannel.StreamHandler {
    public AccentStreamHandler(Context context) {
      this.mContext = context;
    }

    private final Context mContext;
    private final Handler handler = new Handler();
    private EventChannel.EventSink eventSink;
    private boolean themeMode = false;
    private int accentColor = -1;

    private final Runnable runnable = new Runnable() {
      @Override
      public void run() {
        boolean currentThemeMode = Utils.isCurrentThemeDark(mContext);
        int lightAccent = Utils.getLightAccentColor(mContext);
        int darkAccent = Utils.getDarkAccentColor(mContext);

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
      handler.removeCallbacks(runnable);
    }
  }

  public static class ThemeStreamHandler implements EventChannel.StreamHandler {
    public ThemeStreamHandler(Context context) {
      this.mContext = context;
    }

    private final Context mContext;
    private final Handler handler = new Handler();
    private EventChannel.EventSink eventSink;
    private boolean themeMode = false;

    private final Runnable runnable = new Runnable() {
      @Override
      public void run() {
        boolean currentThemeMode = Utils.isCurrentThemeDark(mContext);

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
      handler.removeCallbacks(runnable);
    }
  }
}
