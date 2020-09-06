// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DeviceInfo on _DeviceInfoBase, Store {
  final _$canCheckBiometricsValueAtom =
      Atom(name: '_DeviceInfoBase.canCheckBiometricsValue');

  @override
  bool get canCheckBiometricsValue {
    _$canCheckBiometricsValueAtom.reportRead();
    return super.canCheckBiometricsValue;
  }

  @override
  set canCheckBiometricsValue(bool value) {
    _$canCheckBiometricsValueAtom
        .reportWrite(value, super.canCheckBiometricsValue, () {
      super.canCheckBiometricsValue = value;
    });
  }

  final _$availableBiometricsValueAtom =
      Atom(name: '_DeviceInfoBase.availableBiometricsValue');

  @override
  List<BiometricType> get availableBiometricsValue {
    _$availableBiometricsValueAtom.reportRead();
    return super.availableBiometricsValue;
  }

  @override
  set availableBiometricsValue(List<BiometricType> value) {
    _$availableBiometricsValueAtom
        .reportWrite(value, super.availableBiometricsValue, () {
      super.availableBiometricsValue = value;
    });
  }

  final _$canUseSystemAccentValueAtom =
      Atom(name: '_DeviceInfoBase.canUseSystemAccentValue');

  @override
  bool get canUseSystemAccentValue {
    _$canUseSystemAccentValueAtom.reportRead();
    return super.canUseSystemAccentValue;
  }

  @override
  set canUseSystemAccentValue(bool value) {
    _$canUseSystemAccentValueAtom
        .reportWrite(value, super.canUseSystemAccentValue, () {
      super.canUseSystemAccentValue = value;
    });
  }

  final _$isLandscapeValueAtom = Atom(name: '_DeviceInfoBase.isLandscapeValue');

  @override
  bool get isLandscapeValue {
    _$isLandscapeValueAtom.reportRead();
    return super.isLandscapeValue;
  }

  @override
  set isLandscapeValue(bool value) {
    _$isLandscapeValueAtom.reportWrite(value, super.isLandscapeValue, () {
      super.isLandscapeValue = value;
    });
  }

  final _$uiSizeFactorValueAtom =
      Atom(name: '_DeviceInfoBase.uiSizeFactorValue');

  @override
  int get uiSizeFactorValue {
    _$uiSizeFactorValueAtom.reportRead();
    return super.uiSizeFactorValue;
  }

  @override
  set uiSizeFactorValue(int value) {
    _$uiSizeFactorValueAtom.reportWrite(value, super.uiSizeFactorValue, () {
      super.uiSizeFactorValue = value;
    });
  }

  final _$uiTypeValueAtom = Atom(name: '_DeviceInfoBase.uiTypeValue');

  @override
  UiType get uiTypeValue {
    _$uiTypeValueAtom.reportRead();
    return super.uiTypeValue;
  }

  @override
  set uiTypeValue(UiType value) {
    _$uiTypeValueAtom.reportWrite(value, super.uiTypeValue, () {
      super.uiTypeValue = value;
    });
  }

  final _$_loadInitialDataAsyncAction =
      AsyncAction('_DeviceInfoBase._loadInitialData');

  @override
  Future<void> _loadInitialData() {
    return _$_loadInitialDataAsyncAction.run(() => super._loadInitialData());
  }

  final _$_DeviceInfoBaseActionController =
      ActionController(name: '_DeviceInfoBase');

  @override
  void updateDeviceInfo(MediaQueryData mq, bool canUseSystemAccent) {
    final _$actionInfo = _$_DeviceInfoBaseActionController.startAction(
        name: '_DeviceInfoBase.updateDeviceInfo');
    try {
      return super.updateDeviceInfo(mq, canUseSystemAccent);
    } finally {
      _$_DeviceInfoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
canCheckBiometricsValue: ${canCheckBiometricsValue},
availableBiometricsValue: ${availableBiometricsValue},
canUseSystemAccentValue: ${canUseSystemAccentValue},
isLandscapeValue: ${isLandscapeValue},
uiSizeFactorValue: ${uiSizeFactorValue},
uiTypeValue: ${uiTypeValue}
    ''';
  }
}
