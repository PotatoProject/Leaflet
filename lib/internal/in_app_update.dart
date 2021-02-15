import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/logos.dart';

class InAppUpdater {
  static final BuildType buildType = _getBuildType(
    const String.fromEnvironment(
      "build_type",
      defaultValue: "github",
    ),
  );

  static BuildType _getBuildType(String buildTypeFromEnv) {
    switch (buildTypeFromEnv.toLowerCase()) {
      case 'playstore':
        return BuildType.PLAYSTORE;
      case 'github':
      default:
        return BuildType.GITHUB;
    }
  }

  static Future<AppUpdateInfo> _internalCheckForUpdate() async {
    switch (buildType) {
      case BuildType.PLAYSTORE:
        return await InAppUpdate.checkForUpdate();
      case BuildType.GITHUB:
      default:
        final http.Response githubRelease = await http.get(
          "https://api.github.com/repos/HrX03/PotatoNotes/releases/latest",
        );
        final Map<dynamic, dynamic> body = json.decode(githubRelease.body);
        final int versionCode = int.parse(body["tag_name"].split("+")[1]);
        return AppUpdateInfo(
          versionCode > int.parse(appInfo.packageInfo.buildNumber),
          false,
          true,
          versionCode,
        );
    }
  }

  static void checkForUpdate(BuildContext context,
      {bool showNoUpdatesAvailable = false}) async {
    if (DeviceInfo.isDesktopOrWeb) return;
    final AppUpdateInfo updateInfo =
        await InAppUpdater._internalCheckForUpdate();
    if (updateInfo.updateAvailable) {
      InAppUpdater.update(
        context,
        updateInfo.immediateUpdateAllowed,
        updateInfo.flexibleUpdateAllowed,
      );
    } else {
      if (showNoUpdatesAvailable) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("You're already on the latest app version"),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  static Future<void> update(
    BuildContext context,
    bool immediateUpdateAllowed,
    bool flexibleUpdateAllowed,
  ) async {
    switch (buildType) {
      case BuildType.PLAYSTORE:
        if (flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
        } else {
          await InAppUpdate.performImmediateUpdate();
        }
        break;
      case BuildType.GITHUB:
      default:
        final bool shouldUpdate = await _showUpdateDialog(context);

        if (!shouldUpdate) return;

        await Utils.launchUrl(
            "https://github.com/PotatoProject/Leaflet/releases/latest");
    }
  }

  static Future<bool> _showUpdateDialog(BuildContext context) async {
    final bool status = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              LeafletLogo(
                height: 24,
              ),
              SizedBox(width: 16),
              Text("Update available!"),
            ],
          ),
          content: Text(
            "A new update is available to download, click update to download the update.",
          ),
          actions: [
            TextButton(
              child: Text("Not now".toUpperCase()),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text("Update".toUpperCase()),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    return status ?? false;
  }
}

enum BuildType {
  GITHUB,
  PLAYSTORE,
}
