import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void launchUrl(String url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    throw 'Could not launch $url!';
}

Future<int> getThemeMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('theme_mode') ?? false;
}

Future<void> setThemeMode(int mode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme_mode', mode);
}

Future<Color> getMainColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Color(prefs.getInt('main_color')) ?? Colors.blue;
}

Future<void> setMainColor(Color color) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('main_color', color.value);
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