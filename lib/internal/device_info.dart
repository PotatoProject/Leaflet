import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';

part 'device_info.g.dart';

class DeviceInfo extends _DeviceInfoBase with _$DeviceInfo {
  static bool get isDesktopOrWeb {
    if (kIsWeb) return true;

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) return true;

    return false;
  }

  static bool get isDesktop {
    if (kIsWeb) return false;

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) return true;

    return false;
  }

  static bool get isAndroid {
    if (kIsWeb) return false;

    if (Platform.isAndroid) return true;

    return false;
  }

  static bool get isMacOS {
    if (kIsWeb) return false;

    if (Platform.isMacOS) return true;

    return false;
  }
}

abstract class _DeviceInfoBase with Store {
  @observable
  @protected
  bool _canCheckBiometricsValue;

  @observable
  @protected
  List<BiometricType> _availableBiometricsValue;

  @observable
  @protected
  bool _canUseSystemAccentValue = true;

  @observable
  @protected
  bool _isLandscapeValue = false;

  @observable
  @protected
  int _uiSizeFactorValue = 2;

  @observable
  @protected
  UiType _uiTypeValue;

  _DeviceInfoBase() {
    _loadInitialData();
  }

  bool get canCheckBiometrics => _canCheckBiometricsValue;
  List<BiometricType> get availableBiometrics => _availableBiometricsValue;
  bool get canUseSystemAccent => _canUseSystemAccentValue;
  bool get isLandscape => _isLandscapeValue;
  int get uiSizeFactor => _uiSizeFactorValue;
  UiType get uiType => _uiTypeValue;

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
      _uiTypeValue = UiType.DESKTOP;
    } else if (width >= 1600) {
      _uiSizeFactorValue = 7;
      _uiTypeValue = UiType.DESKTOP;
    } else if (width >= 1460) {
      _uiSizeFactorValue = 6;
      _uiTypeValue = UiType.DESKTOP;
    } else if (width >= 1280) {
      _uiSizeFactorValue = 5;
      _uiTypeValue = UiType.DESKTOP;
    } else if (width >= 900) {
      _uiSizeFactorValue = 4;
      _uiTypeValue = UiType.LARGE_TABLET;
    } else if (width >= 600) {
      _uiSizeFactorValue = 3;
      _uiTypeValue = UiType.TABLET;
    } else if (width >= 360) {
      _uiSizeFactorValue = 2;
      _uiTypeValue = UiType.PHONE;
    } else {
      _uiSizeFactorValue = 1;
      _uiTypeValue = UiType.PHONE;
    }
  }
}

enum UiType {
  PHONE,
  TABLET,
  LARGE_TABLET,
  DESKTOP,
}
