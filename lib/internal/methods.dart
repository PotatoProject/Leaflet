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