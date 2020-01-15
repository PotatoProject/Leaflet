package com.potatoproject.notes;

import android.os.Bundle;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.content.res.Configuration;
import android.util.Log;

import io.flutter.app.FlutterActivity;
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

    new MethodChannel(getFlutterView(), "potato_notes_utils").setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, Result result) {
          switch(call.method) {
            case "getAccentColor":
              result.success(getAccentColor());
              break;
            case "isCurrentThemeDark":
              result.success(isCurrentThemeDark());
              break;
            default:
              result.notImplemented();
              break;
          }
        }
      }
    );
  }

  private Integer getAccentColor() {
    String colResName = "accent_device_default_dark";
    Resources res = null;
    try {
      res = this.getPackageManager().getResourcesForApplication("android");
      int resId = res.getIdentifier("android:color/" + colResName, null, null);
      try {
        return res.getColor(resId);
      } catch (Resources.NotFoundException e) {
        return null;
      }
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    return 0;
  }

  private boolean isCurrentThemeDark() {
    switch (getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) {
      case Configuration.UI_MODE_NIGHT_YES:
        return true;
      case Configuration.UI_MODE_NIGHT_NO:
        return false;
      default:
        return false;
    }
  }
}
