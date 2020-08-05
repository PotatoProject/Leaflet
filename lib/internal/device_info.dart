import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class DeviceInfo {
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  bool _canUseSystemAccent = true;
  bool _isLandscape = false;
  int _uiSizeFactor = 2;
  UiType _uiType;

  DeviceInfo() {
    _loadInitialData();
  }

  bool get canCheckBiometrics => _canCheckBiometrics;
  List<BiometricType> get availableBiometrics => _availableBiometrics;
  bool get canUseSystemAccent => _canUseSystemAccent;
  bool get isLandscape => _isLandscape;
  int get uiSizeFactor => _uiSizeFactor;
  UiType get uiType => _uiType;

  void _loadInitialData() async {
    _canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
    _availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
  }

  void updateDeviceInfo(MediaQueryData mq, bool canUseSystemAccent) {
    _canUseSystemAccent = canUseSystemAccent;
    _isLandscape = mq.orientation == Orientation.landscape;
    double width = mq.size.width;

    if (width >= 1280) {
      _uiSizeFactor = 5;
      _uiType = UiType.DESKTOP;
    } else if (width >= 900) {
      _uiSizeFactor = 4;
      _uiType = UiType.LARGE_TABLET;
    } else if (width >= 600) {
      _uiSizeFactor = 3;
      _uiType = UiType.TABLET;
    } else if (width >= 360) {
      _uiSizeFactor = 2;
      _uiType = UiType.PHONE;
    } else {
      _uiSizeFactor = 1;
      _uiType = UiType.PHONE;
    }
  }

  static bool get isDesktopOrWeb {
    if (kIsWeb) return true;

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) return true;

    return false;
  }
}

enum UiType {
  PHONE,
  TABLET,
  LARGE_TABLET,
  DESKTOP,
}
