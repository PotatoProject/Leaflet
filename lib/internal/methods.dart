import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void launchUrl(String url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    throw 'Could not launch $url!';
}

void changeSystemBarsColors(
    Color navBarColor, Brightness systemBarsIconBrightness) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: navBarColor,
    systemNavigationBarIconBrightness: systemBarsIconBrightness,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: systemBarsIconBrightness,
  ));
}

class Preferences {
  SharedPreferences prefs;

  Future<Preferences> create() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool getWelcomeScreenSeen() {
    return prefs.getBool('weclome_screen_seen') ?? false;
  }

  void setWelcomeScreenSeen(bool seen) {
    prefs.setBool('weclome_screen_seen', seen);
  }

  bool getFollowSystemTheme() {
    return prefs.getBool('follow_system_theme') ?? true;
  }

  void setFollowSystemTheme(bool follow) {
    prefs.setBool('follow_system_theme', follow);
  }

  int getThemeMode() {
    return prefs.getInt('theme_mode') ?? 0;
  }

  void setThemeMode(int mode) {
    prefs.setInt('theme_mode', mode);
  }

  int getDarkThemeMode() {
    return prefs.getInt('dark_theme_mode') ?? 0;
  }

  void setDarkThemeMode(int mode) {
    prefs.setInt('dark_theme_mode', mode);
  }

  bool getUseCustomMainColor() {
    return prefs.getBool('use_custom_main_color') ?? false;
  }

  void setUseCustomMainColor(bool use) {
    prefs.setBool('use_custom_main_color', use);
  }

  Color getCustomMainColor() {
    return Color(prefs.getInt('custom_main_color') ?? 0xFFFF9100);
  }

  void setCustomMainColor(Color color) {
    prefs.setInt('custom_main_color', color?.value ?? null);
  }

  bool getDevShowIdLabels() {
    return prefs.getBool('dev_show_id_labels') ?? false;
  }

  void setDevShowIdLabels(bool show) {
    prefs.setBool('dev_show_id_labels', show);
  }

  bool getIsGridView() {
    return prefs.getBool('is_grid_view') ?? false;
  }

  void setIsGridView(bool isGrid) {
    prefs.setBool('is_grid_view', isGrid);
  }

  bool getIsQuickStarredGestureOn() {
    return prefs.getBool('quick_starred_gesture') ?? false;
  }

  void setIsQuickStarredGestureOn(bool isOn) {
    prefs.setBool('quick_starred_gesture', isOn);
  }

  List<String> getNotificationsIdList() {
    return prefs.getStringList('notifications_id_list') ?? List<String>();
  }

  void setNotificationsIdList(List<String> idList) {
    prefs.setStringList('notifications_id_list', idList);
  }

  List<String> getRemindersNotifIdList() {
    return prefs.getStringList('reminders_notif_id_list') ?? List<String>();
  }

  void setRemindersNotifIdList(List<String> idList) {
    prefs.setStringList('reminders_notif_id_list', idList);
  }

  SortMode getSortMode() {
    return (prefs.getInt('notes_sort_mode') ?? 0) == 0
        ? SortMode.ID
        : SortMode.DATE;
  }

  void setSortMode(SortMode sort) {
    prefs.setInt('notes_sort_mode', sort == SortMode.ID ? 0 : 1);
  }

  String getUserImage() {
    return prefs.getString('user_image') ?? null;
  }

  void setUserImage(String path) {
    prefs.setString('user_image', path);
  }

  String getUserName() {
    return prefs.getString('user_name') ?? "Guest";
  }

  void setUserName(String name) {
    prefs.setString('user_name', name);
  }

  String getUserEmail() {
    return prefs.getString('user_email') ?? "";
  }

  void setUserEmail(String email) {
    prefs.setString('user_email', email);
  }

  String getUserToken() {
    return prefs.getString('user_token') ?? null;
  }

  void setUserToken(String token) {
    prefs.setString('user_token', token);
  }

  bool getAutoSync() {
    return prefs.getBool('auto_sync') ?? false;
  }

  void setAutoSync(bool autoSync) {
    prefs.setBool('auto_sync', autoSync);
  }

  int getAutoSyncTimeInterval() {
    return prefs.getInt('auto_sync_time_interval') ?? 15;
  }

  void setAutoSyncTimeInterval(int interval) {
    prefs.setInt('auto_sync_time_interval', interval);
  }

  void filtersSetColor(int color) {
    prefs.setInt('filters_color', color);
  }

  int filtersGetColor() {
    return prefs.getInt('filters_color') ?? null;
  }

  void filtersSetDate(int date) {
    prefs.setInt('filters_date', date);
  }

  int filtersGetDate() {
    return prefs.getInt('filters_date') ?? null;
  }

  void filtersSetCaseSensitive(bool caseSensitive) {
    prefs.setBool('filters_case_sensitive', caseSensitive);
  }

  bool filtersGetCaseSensitive() {
    return prefs.getBool('filters_case_sensitive') ?? false;
  }
}
