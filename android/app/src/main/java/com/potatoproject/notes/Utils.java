package com.potatoproject.notes;

import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.content.res.Configuration;

final class Utils {
    static public Integer getLightAccentColor(Context context) {
        String colResName = "accent_device_default_light";
        Resources res = null;
        try {
            res = context.getPackageManager().getResourcesForApplication("android");
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
    
    static public Integer getDarkAccentColor(Context context) {
        String colResName = "accent_device_default_dark";
        Resources res = null;
        try {
            res = context.getPackageManager().getResourcesForApplication("android");
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
    
    static public boolean isCurrentThemeDark(Context context) {
        switch (context.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) {
            case Configuration.UI_MODE_NIGHT_YES:
                return true;
            case Configuration.UI_MODE_NIGHT_NO:
                return false;
            default:
                return false;
        }
    }
}