import 'package:flutter/material.dart';
import 'package:liblymph/providers.dart';

class GeneratedSharedPrefs extends LocalPreferences<TypedPreferencesBackend> {
  const GeneratedSharedPrefs({required super.backend});

  String? get locale {
    return backend.read<String>("locale");
  }

  set locale(String? value) {
    if (value != null) {
      backend.write<String>("locale", value);
    } else {
      backend.delete("locale");
    }
  }

  String get masterPass {
    return backend.read<String>("master_pass") ?? "";
  }

  set masterPass(String? value) {
    if (value != null) {
      backend.write<String>("master_pass", value);
    } else {
      backend.delete("master_pass");
    }
  }

  ThemeMode get themeMode {
    final int? value = backend.read<int>("theme_mode");
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
      backend.delete("theme_mode");
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

    backend.write<int>("theme_mode", resolvedValue);
  }

  String get lightTheme {
    return backend.read<String>("light_theme") ?? "light";
  }

  set lightTheme(String? value) {
    if (value != null) {
      backend.write<String>("light_theme", value);
    } else {
      backend.delete("light_theme");
    }
  }

  String get darkTheme {
    return backend.read<String>("dark_theme") ?? "dark";
  }

  set darkTheme(String? value) {
    if (value != null) {
      backend.write<String>("dark_theme", value);
    } else {
      backend.delete("dark_theme");
    }
  }

  int? get customAccent {
    return backend.read<int>("custom_accent");
  }

  set customAccent(int? value) {
    if (value != null) {
      backend.write<int>("custom_accent", value);
    } else {
      backend.delete("custom_accent");
    }
  }

  bool get useAmoled {
    return backend.read<bool>("use_amoled") ?? false;
  }

  set useAmoled(bool? value) {
    if (value != null) {
      backend.write<bool>("use_amoled", value);
    } else {
      backend.delete("use_amoled");
    }
  }

  bool get useGrid {
    return backend.read<bool>("use_grid") ?? false;
  }

  set useGrid(bool? value) {
    if (value != null) {
      backend.write<bool>("use_grid", value);
    } else {
      backend.delete("use_grid");
    }
  }

  bool get useCustomAccent {
    return backend.read<bool>("use_custom_accent") ?? false;
  }

  set useCustomAccent(bool? value) {
    if (value != null) {
      backend.write<bool>("use_custom_accent", value);
    } else {
      backend.delete("use_custom_accent");
    }
  }

  bool get welcomePageSeenV2 {
    return backend.read<bool>("welcome_page_seen_v2") ?? false;
  }

  set welcomePageSeenV2(bool? value) {
    if (value != null) {
      backend.write<bool>("welcome_page_seen_v2", value);
    } else {
      backend.delete("welcome_page_seen_v2");
    }
  }

  bool get migrationInfoShown {
    return backend.read<bool>("migration_info_shown") ?? false;
  }

  set migrationInfoShown(bool? value) {
    if (value != null) {
      backend.write<bool>("migration_info_shown", value);
    } else {
      backend.delete("migration_info_shown");
    }
  }

  bool get protectBackups {
    return backend.read<bool>("protect_backups") ?? false;
  }

  set protectBackups(bool? value) {
    if (value != null) {
      backend.write<bool>("protect_backups", value);
    } else {
      backend.delete("protect_backups");
    }
  }

  String get apiUrl {
    return backend.read<String>("api_url") ??
        "https://sync.potatoproject.co/api/v2";
  }

  set apiUrl(String? value) {
    if (value != null) {
      backend.write<String>("api_url", value);
    } else {
      backend.delete("api_url");
    }
  }

  String? get accessToken {
    return backend.read<String>("access_token");
  }

  set accessToken(String? value) {
    if (value != null) {
      backend.write<String>("access_token", value);
    } else {
      backend.delete("access_token");
    }
  }

  String? get refreshToken {
    return backend.read<String>("refresh_token");
  }

  set refreshToken(String? value) {
    if (value != null) {
      backend.write<String>("refresh_token", value);
    } else {
      backend.delete("refresh_token");
    }
  }

  String? get username {
    return backend.read<String>("username");
  }

  set username(String? value) {
    if (value != null) {
      backend.write<String>("username", value);
    } else {
      backend.delete("username");
    }
  }

  String? get email {
    return backend.read<String>("email");
  }

  set email(String? value) {
    if (value != null) {
      backend.write<String>("email", value);
    } else {
      backend.delete("email");
    }
  }

  String? get avatarUrl {
    return backend.read<String>("avatar_url");
  }

  set avatarUrl(String? value) {
    if (value != null) {
      backend.write<String>("avatar_url", value);
    } else {
      backend.delete("avatar_url");
    }
  }

  int get logLevel {
    return backend.read<int>("log_level") ?? 0;
  }

  set logLevel(int? value) {
    if (value != null) {
      backend.write<int>("log_level", value);
    } else {
      backend.delete("log_level");
    }
  }

  List<String> get downloadedImages {
    return backend.read<List<String>>("downloaded_images") ?? [];
  }

  set downloadedImages(List<String>? value) {
    if (value != null) {
      backend.write<List<String>>("downloaded_images", value);
    } else {
      backend.delete("downloaded_images");
    }
  }

  List<String> get deletedImages {
    return backend.read<List<String>>("deleted_images") ?? [];
  }

  set deletedImages(List<String>? value) {
    if (value != null) {
      backend.write<List<String>>("deleted_images", value);
    } else {
      backend.delete("deleted_images");
    }
  }

  int get lastUpdated {
    return backend.read<int>("last_updated") ?? 0;
  }

  set lastUpdated(int? value) {
    if (value != null) {
      backend.write<int>("last_updated", value);
    } else {
      backend.delete("last_updated");
    }
  }

  String? get deleteQueue {
    return backend.read<String>("delete_queue");
  }

  set deleteQueue(String? value) {
    if (value != null) {
      backend.write<String>("delete_queue", value);
    } else {
      backend.delete("delete_queue");
    }
  }
}
