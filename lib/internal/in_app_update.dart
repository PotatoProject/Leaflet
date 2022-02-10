import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:universal_platform/universal_platform.dart';

class InAppUpdater {
  const InAppUpdater._();

  static BuildType get buildType {
    if (UniversalPlatform.isWeb ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isMacOS) {
      // For web, users always get the latest version as long as they refresh and
      // other stuff we cant really manipulate (at least idk how to do that)
      //
      // On apple OSes instead i just couldn't care less about their shenanigans,
      // apple shall resolve those by their own

      return BuildType.unsupported;
    }

    if (DeviceInfo.isDesktop) {
      // No other way to have an in app update, we can just notify users
      return BuildType.gitHub;
    }

    return _getBuildType(appConfig.buildType);
  }

  static BuildType _getBuildType(String buildTypeString) {
    switch (buildTypeString.toLowerCase()) {
      case 'playstore':
        return BuildType.playStore;
      case 'github':
      default:
        return BuildType.gitHub;
    }
  }

  static Future<AppUpdateInfo> _internalCheckForUpdate() async {
    switch (buildType) {
      case BuildType.playStore:
        return InAppUpdate.checkForUpdate();
      case BuildType.gitHub:
        final Response githubRelease = await dio.get(
          "https://api.github.com/repos/HrX03/PotatoNotes/releases/latest",
        );
        final Map<dynamic, dynamic> body =
            Utils.asMap<String, dynamic>(githubRelease.data);
        final int versionCode =
            int.parse(body["tag_name"].toString().split("+").last);
        final bool updateAvailable =
            versionCode > appInfo.packageInfo.buildNumberInt;
        return AppUpdateInfo(
          updateAvailable
              ? UpdateAvailability.updateAvailable
              : UpdateAvailability.updateNotAvailable,
          false,
          true,
          versionCode,
          0,
          "com.potatoproject.notes",
          0,
          0,
        );
      case BuildType.unsupported:
      default:
        return AppUpdateInfo(
          UpdateAvailability.updateNotAvailable,
          false,
          false,
          -1,
          -1,
          "com.potatoproject.notes",
          0,
          -1,
        );
    }
  }

  static Future<void> checkForUpdate(
    BuildContext context, {
    bool showNoUpdatesAvailable = false,
  }) async {
    final AppUpdateInfo updateInfo = await _internalCheckForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      update(
        context: context,
        immediateUpdateAllowed: updateInfo.immediateUpdateAllowed,
        flexibleUpdateAllowed: updateInfo.flexibleUpdateAllowed,
      );
    } else {
      if (showNoUpdatesAvailable) {
        Utils.showAlertDialog(
          context: context,
          title: Text(LocaleStrings.miscellaneous.updaterAlreadyOnLatest),
          content: Text(LocaleStrings.miscellaneous.updaterAlreadyOnLatestDesc),
          actions: (context) => [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(LocaleStrings.common.close),
            ),
          ],
        );
      }
    }
  }

  static Future<void> update({
    required BuildContext context,
    bool immediateUpdateAllowed = false,
    bool flexibleUpdateAllowed = false,
  }) async {
    switch (buildType) {
      case BuildType.playStore:
        //for now support only immediate
        await InAppUpdate.performImmediateUpdate();
        break;
      case BuildType.gitHub:
        final bool shouldUpdate = await _showUpdateDialog(context);

        if (!shouldUpdate) return;

        await Utils.launchUrl(
          "https://github.com/PotatoProject/Leaflet/releases/latest",
        );
        break;
      case BuildType.unsupported:
      default:
        break;
    }
  }

  static Future<bool> _showUpdateDialog(BuildContext context) async {
    final bool? status = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Illustration.leaflet(
                height: 24,
              ),
              const SizedBox(width: 16),
              Text(LocaleStrings.miscellaneous.updaterUpdateAvailable),
            ],
          ),
          content: Text(LocaleStrings.miscellaneous.updaterUpdateAvailableDesc),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(LocaleStrings.common.notNow.toUpperCase()),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text(LocaleStrings.common.update.toUpperCase()),
            ),
          ],
        );
      },
    );

    return status ?? false;
  }
}

enum BuildType {
  gitHub,
  playStore,
  unsupported,
}
