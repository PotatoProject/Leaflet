import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void launchUrl(String url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    throw 'Could not launch $url!';
}

Future<bool> getDark() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dark_theme') ?? false;
}

Future<void> setDark(bool dark) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('dark_theme', dark);
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

Future<bool> setDevShowIdLabels(bool show) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('dev_show_id_labels', show);
}