import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:universal_platform/universal_platform.dart';

part 'device_info.g.dart';

class DeviceInfo extends _DeviceInfoBase with _$DeviceInfo {
  DeviceInfo();

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

  _DeviceInfoBase() {
    _loadInitialData();
  }

  bool get canCheckBiometrics => _canCheckBiometricsValue;
  List<BiometricType> get availableBiometrics => _availableBiometricsValue;
  bool get canUseSystemAccent => _canUseSystemAccentValue;
  bool get isLandscape => _isLandscapeValue;
  int get uiSizeFactor => _uiSizeFactorValue;

  @action
  Future<void> _loadInitialData() async {
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
    _canUseSystemAccentValue = canUseSystemAccent;
    _isLandscapeValue = mq.orientation == Orientation.landscape;
    final double width = mq.size.width;

    if (width >= 1920) {
      _uiSizeFactorValue = 8;
    } else if (width >= 1600) {
      _uiSizeFactorValue = 7;
    } else if (width >= 1460) {
      _uiSizeFactorValue = 6;
    } else if (width >= 1280) {
      _uiSizeFactorValue = 5;
    } else if (width >= 900) {
      _uiSizeFactorValue = 4;
    } else if (width >= 600) {
      _uiSizeFactorValue = 3;
    } else if (width >= 360) {
      _uiSizeFactorValue = 2;
    } else {
      _uiSizeFactorValue = 1;
    }
  }
}
