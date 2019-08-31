import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void launchUrl(String url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    throw 'Could not launch $url!';
}

void changeSystemBarsColors(Color navBarColor, Brightness systemBarsIconBrightness) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: navBarColor,
    systemNavigationBarIconBrightness: systemBarsIconBrightness,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: systemBarsIconBrightness,
  ));
}

Future<int> getThemeMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('theme_mode') ?? false;
}

Future<void> setThemeMode(int mode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme_mode', mode);
}

Future<bool> getUseCustomMainColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('use_custom_main_color') ?? false;
}

Future<void> setUseCustomMainColor(bool use) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('use_custom_main_color', use);
}

Future<Color> getCustomMainColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Color(prefs.getInt('custom_main_color')) ?? Color(0xFFFF0000);
}

Future<void> setCustomMainColor(Color color) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('custom_main_color', color.value);
}

Future<bool> getDevShowIdLabels() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dev_show_id_labels') ?? false;
}

Future<void> setDevShowIdLabels(bool show) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('dev_show_id_labels', show);
}

Future<bool> getIsGridView() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_grid_view') ?? false;
}

Future<void> setIsGridView(bool isGrid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('is_grid_view', isGrid);
}

Future<String> getUserImagePath() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_image_path') ?? null;
}

Future<void> setUserImagePath(String path) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user_image_path', path);
}

Future<String> getUserNameString() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name') ?? "User";
}

Future<void> setUserNameString(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user_name', userName);
}

Future<bool> getIsQuickStarredGestureOn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('quick_starred_gesture') ?? false;
}

Future<void> setIsQuickStarredGestureOn(bool isOn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('quick_starred_gesture', isOn);
}

Future<List<String>> getNotificationsIdList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('notifications_id_list') ?? List<String>();
}

Future<void> setNotificationsIdList(List<String> idList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('notifications_id_list', idList);
}

Future<List<String>> getRemindersNotifIdList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('reminders_notif_id_list') ?? List<String>();
}

Future<void> setRemindersNotifIdList(List<String> idList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('reminders_notif_id_list', idList);
}

Future<void> filtersSetColor(int color) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('filters_color', color);
}

Future<int> filtersGetColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('filters_color') ?? null;
}

Future<void> filtersSetDate(int date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('filters_date', date);
}

Future<int> filtersGetDate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('filters_date') ?? null;
}

Future<void> filtersSetCaseSensitive(bool caseSensitive) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('filters_case_sensitive', caseSensitive);
}

Future<bool> filtersGetCaseSensitive() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('filters_case_sensitive') ?? false;
}