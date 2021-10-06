import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:universal_platform/universal_platform.dart';

part 'device_info.g.dart';

class DeviceInfo extends _DeviceInfoBase with _$DeviceInfo {
  static bool get isDesktopOrWeb {
    if (UniversalPlatform.isLinux ||
        UniversalPlatform.isWindows ||
        UniversalPlatform.isMacOS ||
        UniversalPlatform.isWeb) return true;

    return false;
  }

  static bool get isDesktop {
    if (UniversalPlatform.isLinux ||
        UniversalPlatform.isWindows ||
        UniversalPlatform.isMacOS) return true;

    return false;
  }

  static bool get isMobile {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) return true;

    return false;
  }

  static bool get isAndroid {
    if (kIsWeb) return false;

    if (UniversalPlatform.isAndroid) return true;

    return false;
  }

  static int getColumnsForWidth(double width) {
    if (width >= 1920) {
      return 8;
    } else if (width >= 1600) {
      return 7;
    } else if (width >= 1460) {
      return 6;
    } else if (width >= 1280) {
      return 5;
    } else if (width >= 900) {
      return 4;
    } else if (width >= 600) {
      return 3;
    } else if (width >= 360) {
      return 2;
    } else {
      return 1;
    }
  }
}

abstract class _DeviceInfoBase with Store {
  @observable
  @protected
  bool _canCheckBiometricsValue = false;

  @observable
  @protected
  List<BiometricType> _availableBiometricsValue = [];

  @observable
  @protected
  bool _canUseSystemAccentValue = true;

  @observable
  @protected
  bool _isLandscapeValue = false;

  @observable
  @protected
  int _uiSizeFactorValue = 2;

  bool get canCheckBiometrics => _canCheckBiometricsValue;
  List<BiometricType> get availableBiometrics => _availableBiometricsValue;
  bool get canUseSystemAccent => _canUseSystemAccentValue;
  bool get isLandscape => _isLandscapeValue;
  int get uiSizeFactor => _uiSizeFactorValue;

  @action
  // ignore: use_setters_to_change_properties
  void setCanUseSystemAccent(bool value) => _canUseSystemAccentValue = value;

  @action
  Future<void> loadData() async {
    if (!DeviceInfo.isDesktopOrWeb) {
      _canCheckBiometricsValue = await LocalAuthentication().canCheckBiometrics;
      _availableBiometricsValue =
          await LocalAuthentication().getAvailableBiometrics();
    } else {
      _canCheckBiometricsValue = false;
      _availableBiometricsValue = [];
    }
  }

  @action
  void updateDeviceInfo(MediaQueryData mq, bool canUseSystemAccent) {
    _isLandscapeValue = mq.orientation == Orientation.landscape;
    final double width = mq.size.width;
    _uiSizeFactorValue = DeviceInfo.getColumnsForWidth(width);
  }
}
