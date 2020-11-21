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
  bool canCheckBiometricsValue = false;

  @observable
  @protected
  List<BiometricType> availableBiometricsValue = [];

  @observable
  @protected
  bool canUseSystemAccentValue = true;

  @observable
  @protected
  bool isLandscapeValue = false;

  @observable
  @protected
  int uiSizeFactorValue = 2;

  @observable
  @protected
  UiType uiTypeValue = UiType.PHONE;

  _DeviceInfoBase() {
    _loadInitialData();
  }

  bool get canCheckBiometrics => canCheckBiometricsValue;
  List<BiometricType> get availableBiometrics => availableBiometricsValue;
  bool get canUseSystemAccent => canUseSystemAccentValue;
  bool get isLandscape => isLandscapeValue;
  int get uiSizeFactor => uiSizeFactorValue;
  UiType get uiType => uiTypeValue;

  @action
  Future<void> _loadInitialData() async {
    if (!DeviceInfo.isDesktopOrWeb) {
      canCheckBiometricsValue = await LocalAuthentication().canCheckBiometrics;
      availableBiometricsValue =
          await LocalAuthentication().getAvailableBiometrics();
    } else {
      canCheckBiometricsValue = false;
      availableBiometricsValue = [];
    }
  }

  @action
  void updateDeviceInfo(MediaQueryData mq, bool canUseSystemAccent) {
    canUseSystemAccentValue = canUseSystemAccent;
    isLandscapeValue = mq.orientation == Orientation.landscape;
    double width = mq.size.width;

    if (width >= 1920) {
      uiSizeFactorValue = 8;
      uiTypeValue = UiType.DESKTOP;
    } else if (width >= 1600) {
      uiSizeFactorValue = 7;
      uiTypeValue = UiType.DESKTOP;
    } else if (width >= 1460) {
      uiSizeFactorValue = 6;
      uiTypeValue = UiType.DESKTOP;
    } else if (width >= 1280) {
      uiSizeFactorValue = 5;
      uiTypeValue = UiType.DESKTOP;
    } else if (width >= 900) {
      uiSizeFactorValue = 4;
      uiTypeValue = UiType.LARGE_TABLET;
    } else if (width >= 600) {
      uiSizeFactorValue = 3;
      uiTypeValue = UiType.TABLET;
    } else if (width >= 360) {
      uiSizeFactorValue = 2;
      uiTypeValue = UiType.PHONE;
    } else {
      uiSizeFactorValue = 1;
      uiTypeValue = UiType.PHONE;
    }
  }
}

enum UiType {
  PHONE,
  TABLET,
  LARGE_TABLET,
  DESKTOP,
}
