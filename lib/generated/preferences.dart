import 'package:flutter/material.dart';
import 'package:liblymph/providers.dart';

class GeneratedSharedPrefs extends LocalPreferences {
  const GeneratedSharedPrefs({required LocalPreferencesBackend backend})
      : super(backend: backend);

  String get masterPass {
    return backend.getString("master_pass") ?? "";
  }

  set masterPass(String? value) {
    backend.setString("master_pass", value);
  }

  ThemeMode get themeMode {
    final int? value = backend.getInt("theme_mode");
    switch (value) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
    }

    return ThemeMode.system;
  }

  set themeMode(ThemeMode? value) {
    if (value == null) {
      backend.setInt("theme_mode", null);
      return;
    }

    final int resolvedValue;

    switch (value) {
      case ThemeMode.system:
        resolvedValue = 0;
        break;
      case ThemeMode.light:
        resolvedValue = 1;
        break;
      case ThemeMode.dark:
        resolvedValue = 2;
        break;
    }

    backend.setInt("theme_mode", resolvedValue);
  }

  String get lightTheme {
    return backend.getString("light_theme") ?? "light";
  }

  set lightTheme(String? value) {
    backend.setString("light_theme", value);
  }

  String get darkTheme {
    return backend.getString("dark_theme") ?? "dark";
  }

  set darkTheme(String? value) {
    backend.setString("dark_theme", value);
  }

  int? get customAccent {
    return backend.getInt("custom_accent");
  }

  set customAccent(int? value) {
    backend.setInt("custom_accent", value);
  }

  bool get useAmoled {
    return backend.getBool("use_amoled") ?? false;
  }

  set useAmoled(bool? value) {
    backend.setBool("use_amoled", value);
  }

  bool get useGrid {
    return backend.getBool("use_grid") ?? false;
  }

  set useGrid(bool? value) {
    backend.setBool("use_grid", value);
  }

  bool get useCustomAccent {
    return backend.getBool("use_custom_accent") ?? false;
  }

  set useCustomAccent(bool? value) {
    backend.setBool("use_custom_accent", value);
  }

  bool get welcomePageSeenV2 {
    return backend.getBool("welcome_page_seen_v2") ?? false;
  }

  set welcomePageSeenV2(bool? value) {
    backend.setBool("welcome_page_seen_v2", value);
  }

  bool get migrationInfoShown {
    return backend.getBool("migration_info_shown") ?? false;
  }

  set migrationInfoShown(bool? value) {
    backend.setBool("migration_info_shown", value);
  }

  bool get protectBackups {
    return backend.getBool("protect_backups") ?? false;
  }

  set protectBackups(bool? value) {
    backend.setBool("protect_backups", value);
  }

  String get apiUrl {
    return backend.getString("api_url") ??
        "https://sync.potatoproject.co/api/v2";
  }

  set apiUrl(String? value) {
    backend.setString("api_url", value);
  }

  String? get accessToken {
    return backend.getString("access_token");
  }

  set accessToken(String? value) {
    backend.setString("access_token", value);
  }

  String? get refreshToken {
    return backend.getString("refresh_token");
  }

  set refreshToken(String? value) {
    backend.setString("refresh_token", value);
  }

  String? get username {
    return backend.getString("username");
  }

  set username(String? value) {
    backend.setString("username", value);
  }

  String? get email {
    return backend.getString("email");
  }

  set email(String? value) {
    backend.setString("email", value);
  }

  String? get avatarUrl {
    return backend.getString("avatar_url");
  }

  set avatarUrl(String? value) {
    backend.setString("avatar_url", value);
  }

  int get logLevel {
    return backend.getInt("log_level") ?? 0;
  }

  set logLevel(int? value) {
    backend.setInt("log_level", value);
  }

  List<String> get downloadedImages {
    return backend.getStringList("downloaded_images") ?? [];
  }

  set downloadedImages(List<String>? value) {
    backend.setStringList("downloaded_images", value);
  }

  List<String> get deletedImages {
    return backend.getStringList("deleted_images") ?? [];
  }

  set deletedImages(List<String>? value) {
    backend.setStringList("deleted_images", value);
  }

  int get lastUpdated {
    return backend.getInt("last_updated") ?? 0;
  }

  set lastUpdated(int? value) {
    backend.setInt("last_updated", value);
  }

  String? get deleteQueue {
    return backend.getString("delete_queue");
  }

  set deleteQueue(String? value) {
    backend.setString("delete_queue", value);
  }
}
